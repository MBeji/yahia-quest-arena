-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-donjon (English — Gauntlet (whole theme))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-donjon/
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
  ('anglais-donjon', 'English — Gauntlet (whole theme)', 'The English Gauntlet: a mixed challenge where every question comes from a different strand — grammar, vocabulary, reading, spelling — climbing from easy to elite. Test the whole language at once, not just one chapter.', 'Polyvalence', 'subject-english', 'Swords', 9, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-donjon'
      AND e.source = 'admin'
      AND q.id NOT IN ('ba906a31-7a45-59ab-8ff7-772704dec110', '30bce9d3-1707-52b7-95ad-287271987f56', 'a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '0b44b887-c29f-5439-a207-436abe18f062', '0d0dac16-6cad-5e51-a55c-81022aef2e7f', '4b280be3-3f34-5c19-95b8-f59252504bd7', 'be139b80-7580-5bd6-860d-4e161113c11b', 'd416661a-e85c-5a8e-9762-d8ad90c1b005', 'b5ae6c61-8f2c-55b6-a264-105387395a5c', '93b07ded-86c0-57b2-bc36-79f1df9297e6', 'c6c804d3-5bb4-55ba-8050-ced151076007', 'd4f9f123-8958-5a0b-b5ef-dc984f751769', 'af6f3259-f18f-5800-9d91-76c77b5b9716', 'fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '49a10031-9a73-5deb-b003-ca2c122aa1be', 'de1f1f74-b5e6-51a3-816f-4eae7524e380', '379e487e-550b-5153-9476-832883aa9c6a', '3d4a8d9f-f787-5721-80d0-a7417f53b6f6', '25945e86-4411-5059-a96e-64065bbd2631', 'fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', '6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', '9feae4fe-1931-51a8-a81a-19fdb0107ece', '1017f94d-0a74-56ce-a038-27db95459e51', 'b8854449-dfaf-5884-ae50-748cc2ca4ce7', '4045dd96-d531-5fc2-b60a-b0c81ead6640', '456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '94d35856-7f59-5838-bfae-b300b41bfe6c', 'cc67e3e3-776a-5c79-b592-e7885616e636', 'e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', 'fcba8d94-0a5b-5675-a05f-134dab76dcfd', '3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '5a19ce6e-44b7-5b44-84c4-70086c841584', '30aaecf9-d5a9-5515-9565-5eade9a990dd', 'deb2d0e6-638f-5362-a00c-592c72f75f3e', '9ffbae32-455d-5620-b30e-210f217f240d', 'cf099e79-fba7-5832-b484-acfcb3094e59', '84dd849c-f5f7-56a9-87a8-6bf27982b393', '89b12fff-740e-54f2-88e8-100a500354f2', '4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ace366dc-2fca-5c26-a061-3eac12cbfdce', '0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', 'a2e01a6c-d449-59bd-b089-a974205fbb09', 'b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '391494ec-2225-548e-baa9-cfefa0f3d473', 'f688da08-7b8e-563f-aa96-08929c36fe04', '2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '2b43508d-291e-587b-aa57-d359f8653093', '2f1cf64b-c744-5acf-911e-3c32c2b7e851', 'feaf3563-3abe-5395-b244-3e880ec79df8', '93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '27d3bdd0-d5b2-53f1-b433-2110058bdc89', '644a8500-026c-5933-8686-11915e185e57', '20083635-85e1-5bf9-9ceb-3fb001d288c9', 'f3485792-24b3-59fa-be2a-7c5246e9b53f', '0f320f6f-b28d-56a9-8277-c01e618d4a34', '9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', '0c98ec9e-bf30-5942-9a0a-de4c43ea858b', '4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', '315c2129-e18c-5618-b783-d3befb72b319', 'be963e07-2c4e-50c4-9523-33d4dd3877a9', '030a1f57-a9c6-5b83-bd90-dde2ccc10efa', '624f39c3-31a4-5b2a-86f8-dfabfd05bc92', '8f402bb1-d0ea-5b17-a1ae-8546063df794', '04a07c4f-9182-593f-abc9-745311969be3', '01e99d6b-2648-56a4-a69b-5149e18a61a1', '8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', 'e976e35f-7fd3-5b2c-9581-86dc41a59f26', 'c54e7d72-8852-5ac4-95c1-8498373a6509', '147d8224-0891-5ac2-a017-7bad399412c1', '2e505b1f-9d16-5b27-a959-6a584d42345f', '4e501524-914c-5567-b7b7-716f575dcc38', 'a62ac825-e95d-594f-9f73-339f0f152530', '576113c2-8990-5f99-8920-7dfe0f5e9798', 'c22de34c-acaa-595e-9f69-c6713c808e55', '8dfcb72a-70dc-5609-ac68-aae097b099ae', '3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'e275588a-04c6-5945-bcaa-e30fad0bdc2b', '4e80bebe-a948-5f60-addf-a7964150f11e', '98c98d95-8646-5a2b-9324-7971f72aa5db', '55463583-d0fb-5eb9-a775-b259094ec76b', '29d002ba-7118-5565-b210-9030f2648028', '2cba1ba7-af16-5d87-b768-affe2783e7bf', '68fc82c4-b675-5ddc-8326-7952e13a2a19', '19af87e0-dcf5-58b5-9861-544a725d24c9', '34eb0159-aead-52e8-a7b3-1b9273d5b564', '137d7a75-f95b-566a-bd55-779e463fd7ce', 'ddd14b29-f733-5239-bafb-9b71636483f5', '43936597-65e4-5161-bbea-4fdaa8d1d703', '40c35d08-9ad4-5316-b398-077e462b95e3', 'd4f1d3c1-2f7d-50bf-bf20-3f4aaf069204', 'd47d6aaf-b26f-5721-8346-fd44ce113bf0', '9f6012bd-ab0b-5412-8717-7826520c4ebd', '8f80563e-de08-5915-99f5-a9d2e519b985', '061a7ce2-dae2-5afc-b735-d75dc32d5d6b', '96065198-c631-5940-85da-ffa687264b9e', '66fd19f4-8376-5dfa-bad1-992fa439fc40', 'efe56cc8-bfa9-5f97-b30c-0d1f519a8965', '7cf596d7-fc1f-5778-85bd-07e8777f7191', '58c62e68-be83-5db1-b43d-aa97cfec9afe', '1a637546-9bd4-5c35-a718-7b955a19b6f1', '218b7f9f-f636-5b7d-be05-18220a4784d2', '3f0c051a-642c-5264-88af-f04bca87d0b5', 'd479b673-788d-5819-b88e-0e8896c4736f', 'f3fc0bee-724e-589e-b31f-1e4ff9d278f2', '459297c1-497d-5a68-8a3a-afe081d74fdb', '26ca6096-54f6-51ba-9721-18c900070c90', '73c614ba-cf10-550a-99b1-8505762d57ae', '7f186bc8-5d7d-5d08-a175-4e6914ebc0b0', '1f12804d-c4c8-52f2-b3f9-4c812bae78cd', '50c08489-c44f-5d98-90f5-caf947839450', 'a87acbf0-8928-57c3-85a6-d725b7461995', '214a674e-4334-5cec-99e9-d1a920a4bdf7', '44b76531-fa9e-5dec-b8b7-559d1ab35c1c', '6abb857b-0666-58e4-b710-737045621ccd', '6f2c7d19-d9fb-5d46-91cd-46a2d0ac41be', '12cd05c0-60ba-557e-b4e8-8669f251d80d', 'abb1ceea-b9ca-5363-b267-632efd57b29b', '18d554dd-1906-5417-bb26-0d807b53a7ab', 'caeaae61-668d-5672-98d3-6a675f9fdec0', '2e060da7-4d12-5ed2-b978-df88963198ac', 'c8d6e3bb-7b01-540c-9033-36118b54905f', '2e45c011-851f-5830-b174-e26e6806c292', 'e10669b7-1bca-553f-adc2-a26b45cd6f24', 'f5591f64-e973-5269-ab27-8c42bf6102af', '0439be1b-3d26-5bab-8827-e7cf2b78ff64', '31384070-726b-5aee-84e6-67ff77f04cf3', '5aa63085-11ec-5d37-a048-3ab6043e7e5e', '84f50bf6-1826-5eb5-ac6d-df3f7cf1c351', '5e809a94-2ac1-57da-afb0-2e98b38b905a', 'ce3e5517-73a3-5793-9be1-d7c8a3f2d634', '8d79f708-bab7-5a8a-96d2-48f6ecbbfa94', '66337dfa-73a1-5c4e-965e-cc2a2f36492c', 'f1bad442-44eb-5c6e-8d5f-963113dddd85', 'afb5e1d9-b7da-5598-abca-31493a3b7598', 'b353e5eb-73c1-5592-88e1-caf495753a57', '4a0ddfd2-ce9f-5927-ba29-7b54c16a5f97', '836d9887-fa08-5c69-8c86-4cb252f69203', '15ef63c3-7c2c-5325-977a-74c26087bcfa', 'ffbe251b-c81d-5b72-b1fe-6f9d4f3d2762', '8e456fc0-4fff-5f22-a286-f8f43f934e63', 'eb9982f3-8c43-5490-b299-4baf57f659cd', '47dc7334-7b55-5945-bea2-476d1b9d7014', 'd8e03da6-5d94-5048-833c-78485ba61f98', '11834420-809d-5206-8c0a-1af4f1e122c7', '44967475-3da8-5d2b-8733-1de3899c1155', 'a1d67367-d42e-5d3a-a8e3-0fb902c51ac4', '69f6d04c-a0b0-5241-bff2-39807b61bd0b', '53a71b5a-b637-543a-b68d-6ec1b5c05d2c', '1bd73099-d806-5277-9955-81a08711e720', '21a1635a-e895-5a08-8dc9-9400ed42cf00', '695dca2d-24e4-522c-a7bc-c5a0f1ad94f7', 'c30284dd-75af-5da7-b516-f0928b4a4cc1', 'b59e00e4-77f6-5895-aad4-a31b6e606d4a', '0a03f0c2-8f4b-502e-9ab0-2bca38ad6393', 'c2d8106c-9f46-55e9-9ab0-f9c52fe92d0d', 'd6ee0e6b-6a01-573c-8c56-1d57f6e1cc66', 'e75bacc4-6568-5a3a-865b-fab942843a04', '146958ce-d04b-5053-bceb-02d13b7af8f7', '682f8d8b-abda-5b84-8bc3-d4fbda1a5374', '59ae9bf1-9948-54f5-8c11-c111f9d0de32', '9e46c011-29ab-5f2b-b413-e31780e8b3a5', '8d755a59-3ba3-590a-a349-57c085a41b3f', '633dda78-06b5-5f6c-8367-938d350acd45', '34a81998-8b33-5503-af0f-10942dc90969', 'd96d53f9-fc41-5809-8626-f401eea9c716', '2dbb5a31-b9ee-5c0f-970b-0733cc619386', '20f331dc-6898-5844-862d-de8ec2b24b23', 'ab024f8b-6c19-5c21-9962-d3512a4b2dda', '77694b49-577b-5c48-af7f-b5ad3d589248', 'f9718932-b970-548b-bc09-fd9813dd937a', '50c89ad0-afd6-5355-b118-891792824021', 'c966ec51-ca9b-57b1-8d75-4f7479bc8768', '86b81606-25f2-5cad-a4d4-065185d1e551', 'd6a9332e-e72e-563d-989f-c523e6e43d5e');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-donjon' AND source = 'admin' AND id NOT IN ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'ad976a04-473a-5f6d-9899-3f29605d8a30', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', '088a3348-6c2f-5c30-9f59-99e199212f46', 'ac1edda7-019a-5303-b405-2243e1707f2f', '921bba7a-96bc-5389-8a70-774129c4103c', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '30d03a04-6201-59a0-a734-7750c0966a66', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', '9236c621-0487-5754-a561-61b796380f43', 'e804fdf7-a259-5a4a-a191-83cb552235d9', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', '880450ab-ecbb-5865-847c-ee1d96697d9b', '91d20544-8a7f-5848-acff-4a219e376de0', 'b53a8169-0e62-5775-bb3b-ec960886da6a', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', '861145f7-4055-5f75-9520-dcf4b49d9411', 'ec78bedf-84de-5ff5-8169-52d17335f480');
DELETE FROM public.questions WHERE exercise_id IN ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'ad976a04-473a-5f6d-9899-3f29605d8a30', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', '088a3348-6c2f-5c30-9f59-99e199212f46', 'ac1edda7-019a-5303-b405-2243e1707f2f', '921bba7a-96bc-5389-8a70-774129c4103c', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '30d03a04-6201-59a0-a734-7750c0966a66', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', '9236c621-0487-5754-a561-61b796380f43', 'e804fdf7-a259-5a4a-a191-83cb552235d9', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', '880450ab-ecbb-5865-847c-ee1d96697d9b', '91d20544-8a7f-5848-acff-4a219e376de0', 'b53a8169-0e62-5775-bb3b-ec960886da6a', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', '861145f7-4055-5f75-9520-dcf4b49d9411', 'ec78bedf-84de-5ff5-8169-52d17335f480') AND id NOT IN ('ba906a31-7a45-59ab-8ff7-772704dec110', '30bce9d3-1707-52b7-95ad-287271987f56', 'a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '0b44b887-c29f-5439-a207-436abe18f062', '0d0dac16-6cad-5e51-a55c-81022aef2e7f', '4b280be3-3f34-5c19-95b8-f59252504bd7', 'be139b80-7580-5bd6-860d-4e161113c11b', 'd416661a-e85c-5a8e-9762-d8ad90c1b005', 'b5ae6c61-8f2c-55b6-a264-105387395a5c', '93b07ded-86c0-57b2-bc36-79f1df9297e6', 'c6c804d3-5bb4-55ba-8050-ced151076007', 'd4f9f123-8958-5a0b-b5ef-dc984f751769', 'af6f3259-f18f-5800-9d91-76c77b5b9716', 'fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '49a10031-9a73-5deb-b003-ca2c122aa1be', 'de1f1f74-b5e6-51a3-816f-4eae7524e380', '379e487e-550b-5153-9476-832883aa9c6a', '3d4a8d9f-f787-5721-80d0-a7417f53b6f6', '25945e86-4411-5059-a96e-64065bbd2631', 'fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', '6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', '9feae4fe-1931-51a8-a81a-19fdb0107ece', '1017f94d-0a74-56ce-a038-27db95459e51', 'b8854449-dfaf-5884-ae50-748cc2ca4ce7', '4045dd96-d531-5fc2-b60a-b0c81ead6640', '456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '94d35856-7f59-5838-bfae-b300b41bfe6c', 'cc67e3e3-776a-5c79-b592-e7885616e636', 'e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', 'fcba8d94-0a5b-5675-a05f-134dab76dcfd', '3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '5a19ce6e-44b7-5b44-84c4-70086c841584', '30aaecf9-d5a9-5515-9565-5eade9a990dd', 'deb2d0e6-638f-5362-a00c-592c72f75f3e', '9ffbae32-455d-5620-b30e-210f217f240d', 'cf099e79-fba7-5832-b484-acfcb3094e59', '84dd849c-f5f7-56a9-87a8-6bf27982b393', '89b12fff-740e-54f2-88e8-100a500354f2', '4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ace366dc-2fca-5c26-a061-3eac12cbfdce', '0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', 'a2e01a6c-d449-59bd-b089-a974205fbb09', 'b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '391494ec-2225-548e-baa9-cfefa0f3d473', 'f688da08-7b8e-563f-aa96-08929c36fe04', '2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '2b43508d-291e-587b-aa57-d359f8653093', '2f1cf64b-c744-5acf-911e-3c32c2b7e851', 'feaf3563-3abe-5395-b244-3e880ec79df8', '93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '27d3bdd0-d5b2-53f1-b433-2110058bdc89', '644a8500-026c-5933-8686-11915e185e57', '20083635-85e1-5bf9-9ceb-3fb001d288c9', 'f3485792-24b3-59fa-be2a-7c5246e9b53f', '0f320f6f-b28d-56a9-8277-c01e618d4a34', '9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', '0c98ec9e-bf30-5942-9a0a-de4c43ea858b', '4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', '315c2129-e18c-5618-b783-d3befb72b319', 'be963e07-2c4e-50c4-9523-33d4dd3877a9', '030a1f57-a9c6-5b83-bd90-dde2ccc10efa', '624f39c3-31a4-5b2a-86f8-dfabfd05bc92', '8f402bb1-d0ea-5b17-a1ae-8546063df794', '04a07c4f-9182-593f-abc9-745311969be3', '01e99d6b-2648-56a4-a69b-5149e18a61a1', '8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', 'e976e35f-7fd3-5b2c-9581-86dc41a59f26', 'c54e7d72-8852-5ac4-95c1-8498373a6509', '147d8224-0891-5ac2-a017-7bad399412c1', '2e505b1f-9d16-5b27-a959-6a584d42345f', '4e501524-914c-5567-b7b7-716f575dcc38', 'a62ac825-e95d-594f-9f73-339f0f152530', '576113c2-8990-5f99-8920-7dfe0f5e9798', 'c22de34c-acaa-595e-9f69-c6713c808e55', '8dfcb72a-70dc-5609-ac68-aae097b099ae', '3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'e275588a-04c6-5945-bcaa-e30fad0bdc2b', '4e80bebe-a948-5f60-addf-a7964150f11e', '98c98d95-8646-5a2b-9324-7971f72aa5db', '55463583-d0fb-5eb9-a775-b259094ec76b', '29d002ba-7118-5565-b210-9030f2648028', '2cba1ba7-af16-5d87-b768-affe2783e7bf', '68fc82c4-b675-5ddc-8326-7952e13a2a19', '19af87e0-dcf5-58b5-9861-544a725d24c9', '34eb0159-aead-52e8-a7b3-1b9273d5b564', '137d7a75-f95b-566a-bd55-779e463fd7ce', 'ddd14b29-f733-5239-bafb-9b71636483f5', '43936597-65e4-5161-bbea-4fdaa8d1d703', '40c35d08-9ad4-5316-b398-077e462b95e3', 'd4f1d3c1-2f7d-50bf-bf20-3f4aaf069204', 'd47d6aaf-b26f-5721-8346-fd44ce113bf0', '9f6012bd-ab0b-5412-8717-7826520c4ebd', '8f80563e-de08-5915-99f5-a9d2e519b985', '061a7ce2-dae2-5afc-b735-d75dc32d5d6b', '96065198-c631-5940-85da-ffa687264b9e', '66fd19f4-8376-5dfa-bad1-992fa439fc40', 'efe56cc8-bfa9-5f97-b30c-0d1f519a8965', '7cf596d7-fc1f-5778-85bd-07e8777f7191', '58c62e68-be83-5db1-b43d-aa97cfec9afe', '1a637546-9bd4-5c35-a718-7b955a19b6f1', '218b7f9f-f636-5b7d-be05-18220a4784d2', '3f0c051a-642c-5264-88af-f04bca87d0b5', 'd479b673-788d-5819-b88e-0e8896c4736f', 'f3fc0bee-724e-589e-b31f-1e4ff9d278f2', '459297c1-497d-5a68-8a3a-afe081d74fdb', '26ca6096-54f6-51ba-9721-18c900070c90', '73c614ba-cf10-550a-99b1-8505762d57ae', '7f186bc8-5d7d-5d08-a175-4e6914ebc0b0', '1f12804d-c4c8-52f2-b3f9-4c812bae78cd', '50c08489-c44f-5d98-90f5-caf947839450', 'a87acbf0-8928-57c3-85a6-d725b7461995', '214a674e-4334-5cec-99e9-d1a920a4bdf7', '44b76531-fa9e-5dec-b8b7-559d1ab35c1c', '6abb857b-0666-58e4-b710-737045621ccd', '6f2c7d19-d9fb-5d46-91cd-46a2d0ac41be', '12cd05c0-60ba-557e-b4e8-8669f251d80d', 'abb1ceea-b9ca-5363-b267-632efd57b29b', '18d554dd-1906-5417-bb26-0d807b53a7ab', 'caeaae61-668d-5672-98d3-6a675f9fdec0', '2e060da7-4d12-5ed2-b978-df88963198ac', 'c8d6e3bb-7b01-540c-9033-36118b54905f', '2e45c011-851f-5830-b174-e26e6806c292', 'e10669b7-1bca-553f-adc2-a26b45cd6f24', 'f5591f64-e973-5269-ab27-8c42bf6102af', '0439be1b-3d26-5bab-8827-e7cf2b78ff64', '31384070-726b-5aee-84e6-67ff77f04cf3', '5aa63085-11ec-5d37-a048-3ab6043e7e5e', '84f50bf6-1826-5eb5-ac6d-df3f7cf1c351', '5e809a94-2ac1-57da-afb0-2e98b38b905a', 'ce3e5517-73a3-5793-9be1-d7c8a3f2d634', '8d79f708-bab7-5a8a-96d2-48f6ecbbfa94', '66337dfa-73a1-5c4e-965e-cc2a2f36492c', 'f1bad442-44eb-5c6e-8d5f-963113dddd85', 'afb5e1d9-b7da-5598-abca-31493a3b7598', 'b353e5eb-73c1-5592-88e1-caf495753a57', '4a0ddfd2-ce9f-5927-ba29-7b54c16a5f97', '836d9887-fa08-5c69-8c86-4cb252f69203', '15ef63c3-7c2c-5325-977a-74c26087bcfa', 'ffbe251b-c81d-5b72-b1fe-6f9d4f3d2762', '8e456fc0-4fff-5f22-a286-f8f43f934e63', 'eb9982f3-8c43-5490-b299-4baf57f659cd', '47dc7334-7b55-5945-bea2-476d1b9d7014', 'd8e03da6-5d94-5048-833c-78485ba61f98', '11834420-809d-5206-8c0a-1af4f1e122c7', '44967475-3da8-5d2b-8733-1de3899c1155', 'a1d67367-d42e-5d3a-a8e3-0fb902c51ac4', '69f6d04c-a0b0-5241-bff2-39807b61bd0b', '53a71b5a-b637-543a-b68d-6ec1b5c05d2c', '1bd73099-d806-5277-9955-81a08711e720', '21a1635a-e895-5a08-8dc9-9400ed42cf00', '695dca2d-24e4-522c-a7bc-c5a0f1ad94f7', 'c30284dd-75af-5da7-b516-f0928b4a4cc1', 'b59e00e4-77f6-5895-aad4-a31b6e606d4a', '0a03f0c2-8f4b-502e-9ab0-2bca38ad6393', 'c2d8106c-9f46-55e9-9ab0-f9c52fe92d0d', 'd6ee0e6b-6a01-573c-8c56-1d57f6e1cc66', 'e75bacc4-6568-5a3a-865b-fab942843a04', '146958ce-d04b-5053-bceb-02d13b7af8f7', '682f8d8b-abda-5b84-8bc3-d4fbda1a5374', '59ae9bf1-9948-54f5-8c11-c111f9d0de32', '9e46c011-29ab-5f2b-b413-e31780e8b3a5', '8d755a59-3ba3-590a-a349-57c085a41b3f', '633dda78-06b5-5f6c-8367-938d350acd45', '34a81998-8b33-5503-af0f-10942dc90969', 'd96d53f9-fc41-5809-8626-f401eea9c716', '2dbb5a31-b9ee-5c0f-970b-0733cc619386', '20f331dc-6898-5844-862d-de8ec2b24b23', 'ab024f8b-6c19-5c21-9962-d3512a4b2dda', '77694b49-577b-5c48-af7f-b5ad3d589248', 'f9718932-b970-548b-bc09-fd9813dd937a', '50c89ad0-afd6-5355-b118-891792824021', 'c966ec51-ca9b-57b1-8d75-4f7479bc8768', '86b81606-25f2-5cad-a4d4-065185d1e551', 'd6a9332e-e72e-563d-989f-c523e6e43d5e');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-donjon' AND c.id NOT IN ('fb713601-2e53-5225-b1e4-6b02471bee44', '9a5c79f6-867a-54ee-8649-f2559d061b06', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'f629892b-b08a-55bb-941c-20d478b84cbe', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', 'The English Gauntlet', 'A mixed whole-language challenge where every question strikes from a different strand — grammar, vocabulary, reading or spelling — climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The English Gauntlet — Every Skill, One Dungeon

> 💡 «The hero who masters one room is strong; the hero who masters every room is unstoppable.»

Welcome, challenger. This is no quiet single-lesson chapter. The Gauntlet is a **mixed dungeon** that throws the _whole language_ at you at once. One room tests a verb, the next a word, the next a tiny story, the next a spelling — and you never know which door opens next. Your only armour is a broad, solid command of everything you learned across A1.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a _to be_ form to an odd-one-out word, from a short passage to a tricky plural, with no warning. That is the whole point: real English is not sorted by topic. To survive here you must be **versatile** — ready for anything, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw.

## 📜 The four strands (your doors)

| Door | Strand     | What to expect                                                         |
| ---- | ---------- | ---------------------------------------------------------------------- |
| 🗡️   | Grammar    | pick the right form: _am / is / are_, present simple, _a / an / the_   |
| 💎   | Vocabulary | meaning, the **odd one out** of a set, the word that fits a sentence   |
| 📖   | Reading    | a 2–3 sentence story, then a question about a detail you must find     |
| ✒️   | Spelling   | the correct written form, above all tricky plurals (_cities, watches_) |

## 🗡️ Grammar — the backbone

These rooms drill the engine of A1. Choose the verb that matches its subject (_She **is**…_, _They **are**…_), put the present-simple **-s** only on _he / she / it_ (_He **plays**…_), and slot in the right article — **a** before a consonant sound, **an** before a vowel sound, **the** for something already known.

## 💎 Vocabulary — your word bank

Here you prove your treasure of words. Spot the intruder in a themed set (_which is **not** a colour?_), match a word to its meaning, or pick the one word that completes a natural sentence. Distractors come from the _same family_, so read every option.

## 📖 Reading — find the detail

A short text appears, then one question. The answer is **always in the text** — do not guess from outside knowledge. Read the two or three lines, hold the facts in mind, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

English plurals shift in predictable ways. A consonant **+ y** becomes **-ies** (_city → cities_), words ending **-ch / -sh / -s / -x** add **-es** (_watch → watches_), and some are simply irregular (_child → children_). These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand** in the prompt. A Grammar trap and a Spelling trap are beaten by different rules — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. _Plays_ is right in a Grammar room about _he_, but _citys_ is never right in a Spelling room — each strand has its own law.

> 🏆 You now know the rules of the Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your English has no weak room.', '# 📜 Résumé: The English Gauntlet

- **Goal** — one mixed dungeon that tests the whole A1 language at once, not a single chapter.
- **Grammar** — match the verb to its subject (_am / is / are_, present-simple _-s_) and pick the right article (_a / an / the_).
- **Vocabulary** — meaning, the **odd one out** of a themed set, and the word that completes a sentence.
- **Reading** — read a short 2–3 sentence text, then answer using only what the text says.
- **Spelling** — write the correct form, above all tricky plurals (_city → cities_, _watch → watches_, _child → children_).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero who is ready in every room has no weak spot.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', 'The A2 Gauntlet', 'A mixed elementary-level challenge that blends the whole A2 band — past simple, present continuous, the future, comparatives and superlatives, and quantifiers — across the grammar, vocabulary, reading and spelling strands, climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The A2 Gauntlet — The Whole Elementary Band, One Dungeon

> 💡 «A1 taught you to stand. A2 teaches you to move — through time, comparison, and quantity. Master every room, and nothing in this band can surprise you.»

Welcome back, challenger. You cleared the first Gauntlet; now the dungeon has grown. This is the **A2 Gauntlet** — a deeper, harder maze that throws the _whole elementary band_ at you at once. One room asks you to send a verb into the **past**, the next catches an action **happening now**, the next leaps into the **future**, then a room weighs two things against each other, and another measures _how much_ and _how many_. You never know which door opens next.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a past-tense form to a tricky -ing spelling, from a two-line story to a quantifier, with no warning. That is the whole point: real English never sorts itself by topic. To survive here you must be **versatile** — ready for any tense, any comparison, any spelling, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw: **Grammar —**, **Vocabulary —**, **Reading —**, or **Spelling —**.

## 🗡️ Grammar — the engine of A2

These rooms drill the machinery of the whole band. Choose the right past form — _was / were_, _did + base verb_, and the irregulars (_went_, _saw_, _bought_). Tell apart an action **happening now** (_she is cooking_) from a **habit** (_she cooks every day_). Pick the right future: **going to** for a plan or visible evidence, **will** for a decision made as you speak. Build comparisons — _-er … than_ and _the …est_ for short words, _more / the most_ for long ones. And match quantifiers to their nouns — _some / any_, _much / many_, _a few / a little_.

## 💎 Vocabulary — your word bank

Here you prove your treasure of A2 words. Spot the **odd one out** of a themed set, match a word to its opposite, or pick the one word that completes a natural sentence. Distractors come from the _same family_, so read every option before you strike.

## 📖 Reading — find the detail

A short text appears — a little past-tense story or a scene happening right now — then one question. The answer is **always in the text**: do not guess from outside knowledge. Read the two or three lines, hold the facts in mind, sometimes combine them, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

A2 spelling has its own traps. Past **-ed** forms shift: _study → studied_, _stop → stopped_, _arrive → arrived_. The **-ing** form shifts too: _run → running_, _make → making_, _lie → lying_. Comparatives and superlatives change spelling: _big → bigger_, _happy → happiest_. These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand and the rule**. A past-tense trap, a now-vs-habit trap, and a comparison trap are each beaten by a _different_ law — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. _Faster_ is right when you compare two things, but never _more faster_; _going to_ fits a plan, but a decision made on the spot wants _will_. Each strand, and each tense, has its own rule.

> 🏆 You now know the rules of the A2 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your elementary English has no weak room.', '# 📜 Résumé: The A2 Gauntlet

- **Goal** — one mixed dungeon that tests the whole A2 band at once, not a single chapter.
- **Grammar** — past simple (_was/were_, _did + base_, irregulars), present continuous vs simple (now vs habit), the future (_going to_ for plans/evidence, _will_ for on-the-spot decisions), comparatives & superlatives, and quantifiers (_some/any_, _much/many_, _a few/a little_).
- **Vocabulary** — the **odd one out** of a themed set, opposites, and the word that completes a sentence.
- **Reading** — read a short past-tense story or a now-scene, then answer using only what the text says.
- **Spelling** — past **-ed** (_studied_, _stopped_), **-ing** (_running_, _making_, _lying_), and comparison forms (_bigger_, _happiest_).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero ready in every tense, comparison and quantity has no weak spot.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', 'The B1 Gauntlet', 'A mixed intermediate-level challenge that blends the whole B1 band — the present perfect, the past continuous, conditionals, modals of obligation and advice, and relative clauses — across the grammar, vocabulary, reading and spelling strands, climbing from a gentle warm-up to a final elite trial.', '# ⚔️ The B1 Gauntlet — The Whole Intermediate Band, One Dungeon

> 💡 «A1 taught you to stand, A2 taught you to move. B1 teaches you to connect — past to now, cause to effect, idea to idea. Master every room, and the intermediate gate is yours.»

Welcome back, challenger. You cleared the A1 and A2 Gauntlets; now the dungeon has grown a third time. This is the **B1 Gauntlet** — a deeper, harder maze that throws the _whole intermediate band_ at you at once. One room ties a past action to **now**, the next sets a **scene** that an event suddenly cuts into, the next bends reality with an **if**, another hands you the **rules of the realm**, and the last welds two ideas into a single elegant sentence. You never know which door opens next.

## 🏰 The rule of the Gauntlet

Each battle **interleaves four strands**. You jump from a present-perfect form to a tricky participle spelling, from a two-line story to a relative pronoun, with no warning. That is the whole point: real English never sorts itself by topic. To survive here you must be **versatile** — ready for any tense, any structure, any spelling, in any order.

Every prompt is **tagged** with the strand it comes from, so you always know which weapon to draw: **Grammar —**, **Vocabulary —**, **Reading —**, or **Spelling —**.

## 🗡️ Grammar — the engine of B1

These rooms drill the machinery of the whole band. Tie a finished action to the present with the **present perfect** (_have / has_ + participle, _for / since_, _been_ vs _gone_), and never pair it with a finished-time word (_yesterday_). Set a scene with the **past continuous** (_was / were_ + -ing) and let a **past simple** event interrupt it (_while_ I **was cooking**, the phone **rang**). Reason with **conditionals** — _if_ + present → _will_ for the real future, _if_ + past → _would_ for the imaginary. Give orders with **modals**: _must / have to_ (necessary), _mustn''t_ (forbidden), _don''t have to_ (optional), _should_ (advice). And join ideas with **relative clauses** — _who_ for people, _which_ for things, _where_ for places, _whose_ for possession.

## 💎 Vocabulary — your word bank

Here you prove your treasure of B1 words. Spot the **odd one out** of a themed set, match a word to its opposite, complete a natural **collocation** (_make_ a decision, _do_ the housework), or pick the one word that finishes a sentence. Distractors come from the _same family_, so read every option before you strike.

## 📖 Reading — find the detail

A short text appears — a present-perfect life story, an interrupted past scene, or a clue-filled situation — then one question. The answer is **always in the text**: do not guess from outside knowledge. Read the two to four lines, hold the facts in mind, sometimes **infer** what they add up to, and pick the option the passage actually supports.

## ✒️ Spelling — write it right

B1 spelling has its own traps. **Past participles** can be irregular: _write → written_, _see → seen_, _do → done_, _eat → eaten_. The **-ing** form shifts: _run → running_, _make → making_, _lie → lying_, _sit → sitting_. And comparative or irregular forms bite: _good → better_, _big → bigger_. These rooms reward the eye that catches the silent trap.

> 🗡️ Hero''s tip: before you answer, **name the strand and the rule**. A present-perfect trap, a _while/when_ trap and a _mustn''t_ / _don''t have to_ trap are each beaten by a _different_ law — knowing which fight you are in is half the win.

> ⚠️ Classic trap: do **not** carry one room''s logic into the next. _Have seen_ fits an experience, but _yesterday_ forces _saw_; _if it rains, I will…_ is real, but never _if it will rain_; _mustn''t_ forbids, yet _don''t have to_ frees. Each strand, and each structure, has its own rule.

> 🏆 You now know the rules of the B1 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your intermediate English has no weak room.', '# 📜 Résumé: The B1 Gauntlet

- **Goal** — one mixed dungeon that tests the whole B1 band at once, not a single chapter.
- **Grammar** — present perfect (_have/has_ + participle, _for/since_, _been/gone_), past continuous vs past simple (_while/when_), conditionals (zero/first/second, _will_ vs _would_), modals (_must/have to_, _mustn''t_, _don''t have to_, _should_), and relative clauses (_who/which/that/where/whose_).
- **Vocabulary** — the **odd one out** of a themed set, opposites, collocations (_make a decision_, _do the housework_), and the word that completes a sentence.
- **Reading** — read a short story or clue-filled scene, then answer using only what the text says, inferring when needed.
- **Spelling** — irregular **past participles** (_written_, _seen_, _done_, _eaten_), **-ing** forms (_running_, _making_, _lying_), and comparison forms (_better_, _bigger_).
- **Method** — every prompt names its strand, so draw the matching rule; eliminate the look-alike trap, then choose.
- 🏆 Versatility wins: a hero ready in every tense, structure and spelling has no weak spot.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', 'The B2 Gauntlet', 'A mixed upper-intermediate challenge that blends the whole B2 band — the past perfect, the passive voice, reported speech, advanced conditionals (third and mixed), and gerunds & infinitives — across the grammar, vocabulary, usage and spelling strands, climbing from a warm-up to a punishing elite trial.', '# ⚔️ The B2 Gauntlet — The Whole Upper-Intermediate Band, One Dungeon

> 💡 «B1 taught you to connect ideas. B2 teaches you to step back in time, to view the world from a distance, and to report what others said. Conquer every room, and the upper-intermediate gate is yours.»

Welcome back, challenger. You cleared the B1 Gauntlet; now the dungeon descends a level deeper. This is the **B2 Gauntlet** — a labyrinth that throws the _whole upper-intermediate band_ at you at once. One room asks you to place an action further back in the past, the next turns an active sentence into a passive one, the third transforms direct speech into reported words, the fourth bends a past reality with a third conditional, and the last forces a choice between a gerund and an infinitive. You never know which door opens next.

## 🏰 The Rule of the Gauntlet

Each battle **interleaves five strands**. You leap from a past-perfect structure to a passive transformation, from a reported-speech verb change to a gerund/infinitive distinction, with no warning. Real English never sorts itself by topic. To survive here you must be **versatile** — ready for any tense, voice, or form, in any order.

Every prompt is **tagged** with the strand it comes from: **Grammar —**, **Vocabulary —**, **Usage —**, or **Spelling —**.

## 🗡️ Grammar — the engine of B2

### Past Perfect (_had_ + participle)

Use the past perfect to push one past action _before_ another: _By the time she arrived, we **had already eaten**_. The signal words are _by the time, already, after, before, when, once_. Do not confuse it with the past simple — the past simple just says a finished action; the past perfect says it finished _earlier than_ another past action.

### Passive Voice (_be_ + past participle)

The passive puts the _action_ at the centre, not the doer. Form it with the right tense of _be_ + participle: _The report **is written** every month_ (present), _The painting **was stolen** last night_ (past), _The bridge **has been repaired**_ (present perfect). The _by_-phrase is optional and is only included if the agent matters.

### Reported Speech

When you shift direct speech into reported speech, you back-shift tenses and change pronouns and time expressions. _"I will call you"_ → _He said **he would call me**_. Key shifts: _will → would_, _can → could_, _am/are/is → was/were_, _"yesterday" → the day before_, _"tomorrow" → the following day_. Reporting verbs: _say, tell, explain, ask, warn_.

### Advanced Conditionals (Third & Mixed)

- **Third conditional**: impossible past — _If she **had studied** harder, she **would have passed**_.
- **Mixed conditional**: past cause, present result — _If I **had taken** that job, I **would be** rich now_.
  Never put _would_ inside the _if_-clause.

### Gerunds & Infinitives

Some verbs take a gerund (_enjoy, avoid, suggest, consider, admit, keep_); others take an infinitive (_want, hope, decide, agree, plan, refuse_); a few change meaning (_stop to do_ vs _stop doing_, _remember to do_ vs _remember doing_, _try to do_ vs _try doing_).

## 💎 Vocabulary & Usage — your B2 word bank

At B2 you work with **formal/informal register**, **phrasal verbs**, and **fixed expressions**. Watch for the right preposition after a verb or adjective (_depend **on**_, _succeed **in**_, _insist **on**_) and for lexical collocations (_carry out_ a study, _draw_ a conclusion, _raise_ awareness).

## ✒️ Spelling — B2 traps

Passive and reported speech introduce spelling pitfalls: _known_, _chosen_, _written_, _spoken_, _forgotten_. Third-conditional past participles like _fallen_, _risen_, _broken_ are irregular. Watch double-letter patterns in words like _occurred_, _committed_, and _beginning_.

> 🗡️ Hero''s tip: before answering, **name the strand and identify the trigger**: a _by the time_ signal means past perfect; a form-of-_be_ + participle slot means passive; a reporting verb means back-shift; an _if_ + past perfect means the third conditional.

> ⚠️ Classic trap: **never** put _would_ in the _if_-clause of any conditional. _If I had known_ (not _If I would have known_). Likewise, do not use the past simple where the past perfect is required — the difference in time changes the whole meaning.

> 🏆 You now know the rules of the B2 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your upper-intermediate English has no weak room.', '# 📜 Résumé: The B2 Gauntlet

- **Goal** — one mixed dungeon that tests the whole B2 band at once, not a single chapter.
- **Grammar** — past perfect (_had_ + participle, _by the time / already / after_), passive voice (_be_ + participle across tenses), reported speech (tense back-shift, pronoun/time shifts, reporting verbs), third conditional (_had_ + participle → _would have_ + participle), mixed conditional (_had_ + participle → _would_ + base), and gerunds vs infinitives (_enjoy/avoid_ + -ing; _want/decide_ + to; meaning-changers: _stop, remember, try_).
- **Vocabulary / Usage** — register awareness, phrasal verbs, preposition collocations (_depend on, succeed in_), and lexical collocations (_carry out, draw a conclusion, raise awareness_).
- **Spelling** — irregular past participles in passive constructions (_known, chosen, spoken, forgotten_), double-letter patterns (_occurred, committed, beginning_), and third-conditional forms (_fallen, risen, broken_).
- **Method** — every prompt names its strand; identify the trigger signal (_by the time_ → past perfect; _be_ + slot → passive; reporting verb → back-shift; _if_ + past perfect → third conditional), eliminate look-alike traps, then choose.
- 🏆 Versatility wins: a hero ready in every tense, voice, and structure has no weak spot.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', 'The C1 Gauntlet', 'A mixed advanced-level challenge that blends the whole C1 band — inversion for emphasis, cleft sentences, modals of deduction (including past deduction), participle clauses, and discourse markers and cohesion — across the grammar, vocabulary, usage and spelling strands, climbing from a warm-up to a punishing elite trial.', '# ⚔️ The C1 Gauntlet — The Whole Advanced Band, One Dungeon

> 💡 «B2 gave you the tools. C1 teaches you to wield them with precision and elegance — to reorder words for effect, to strip a sentence to its bare bones, and to guide a reader through an argument without signposts. Enter the advanced dungeon.»

Welcome back, challenger. You cleared the B2 Gauntlet; now the dungeon opens its deepest level yet. This is the **C1 Gauntlet** — a labyrinth where every room demands a different weapon of advanced grammar. One room inverts a clause for dramatic effect, the next splits a sentence into a cleft to spotlight a single element, the third deduces certainty and doubt from modals alone, the fourth condenses two clauses into a single participle phrase, and the last binds paragraphs into a coherent whole. You never know which door opens next.

## 🏰 The Rule of the Gauntlet

Each battle **interleaves five strands**. You jump without warning from an inverted conditional to a deduction about the past, from a cleft sentence to a participle clause reduction. That is the whole point: advanced English is not neat — it is versatile, and mastery means being dangerous in every corner.

Every prompt is **tagged** with the strand it comes from: **Grammar —**, **Vocabulary —**, **Usage —**, or **Spelling —**.

## 🗡️ Grammar — the engine of C1

### Inversion for Emphasis

When a negative or restrictive adverbial is moved to the front of a sentence, the auxiliary and subject invert (like a question). Key triggers: _Never, Rarely, Seldom, Not only…but also, No sooner…than, Hardly…when, Only then, Under no circumstances_.

- _Never **have I seen** such a view._ (not _Never I have seen…_)
- _No sooner **had she sat down** than the phone rang._
- _Not only **did they arrive** late, but they also forgot the key._

### Cleft Sentences

A cleft splits one idea into two clauses to highlight a specific element.

- _It was the noise **that** kept me awake._ (It-cleft — highlights the noise)
- _What I enjoy most **is** reading._ (Wh-cleft / pseudo-cleft — highlights reading)
- _The reason (why) I left **was** that I felt unwelcome._ (reason-cleft)
  The highlighted element always comes after _it was_ or after the _be_ verb in the wh-cleft.

### Modals of Deduction (including Past)

- **Certainty now**: _must be_ (positive), _can''t be_ (negative)
- **Possibility now**: _could / might be_
- **Past deduction**: _must have been_, _can''t have been_, _might have been_, _should have been_
  The trap: _must_ for deduction is never followed by _have to_. And _could_ as a deduction differs from _could_ as an ability — context decides.

### Participle Clauses

A participle clause condenses a subordinate clause using -ing (active/simultaneous) or past participle (passive/prior):

- _Walking down the street, she noticed a crowd._ (simultaneous action — same subject)
- _Having finished the report, he went home._ (completed prior action)
- _Shocked by the news, they sat in silence._ (passive — participle replaces a relative or because-clause)
  The subject of the participle must be the same as the main clause''s subject. A dangling participle (mismatched subject) is an error.

### Discourse Markers and Cohesion

Cohesion links sentences into a coherent text. Key categories:

- **Contrast**: _however, nevertheless, nonetheless, on the other hand, yet, even so_
- **Addition**: _furthermore, moreover, in addition, what is more_
- **Result**: _as a result, therefore, consequently, hence_
- **Concession**: _although, even though, while, granted that_
- **Clarification**: _in other words, that is to say, namely_
  The trap: _however_ is not interchangeable with _although_ — _however_ links two sentences or independent clauses with a comma; _although_ introduces a subordinate clause.

## 💎 Vocabulary — C1 range

At C1 you are expected to exploit a wide, precise vocabulary: near-synonyms (_allow vs enable vs permit_), formal vs informal register, and abstract nouns from verbs (nominalisation: _the achievement of_ rather than _he achieved_). Collocation is tighter: _bear a resemblance_, _reach a consensus_, _draw a distinction_.

## ✒️ Spelling — C1 traps

Inversion can confuse the eye: _Rarely does he arrive on time_ (not _arrive_ → _arrives_ — the auxiliary does carries the third-person inflection). Participle clauses bring spelling challenges with irregular forms: _having broken_, _having spoken_, _having ridden_. Multi-syllable formal words test doubled consonants and silent letters: _occurrence_, _apparent_, _necessary_, _committed_.

> 🗡️ Hero''s tip: for inversion questions, ask yourself: _Is the auxiliary before the subject?_ For clefts: _What element is spotlighted — and does it follow it was / what is?_ For modals of deduction: _Am I certain (must/can''t) or uncertain (might/could)?_ And for past deduction, add have + participle.

> ⚠️ Classic trap: after a negative fronting word (_Never, Rarely, Not only_), **always** invert — _Never did I imagine_, never _Never I imagined_. And don''t mix up _however_ (semi-colon/comma, two clauses) with _although_ (subordinating conjunction, one clause).

> 🏆 You now know the rules of the C1 Gauntlet. Clear the warm-up, drill the mixed rounds, topple the Boss, then dare the Elite trial — and prove your advanced English commands every weapon in the arsenal.', '# 📜 Résumé: The C1 Gauntlet

- **Goal** — one mixed dungeon that tests the whole C1 band at once, not a single chapter.
- **Grammar** — inversion after negative/restrictive fronting (_Never have I…, No sooner had…than, Not only did…but also_), cleft sentences (_It was … that …_, _What I need is…_), modals of deduction present (_must / can''t / might / could be_) and past (_must have been, can''t have been, might have been_), participle clauses (-ing for simultaneous/active, past participle for passive/prior, _having_ + participle for completed prior), and discourse markers (_however, nevertheless, furthermore, therefore, although, consequently_).
- **Vocabulary / Usage** — near-synonym precision (_allow / enable / permit_), nominalisation (_achievement_ from _achieve_), formal collocations (_bear a resemblance, reach a consensus, draw a distinction_).
- **Spelling** — irregular participles in reduced clauses (_having broken, having ridden, having spoken_), and multi-syllable formal words (_occurrence, apparent, necessary, committed_).
- **Method** — every prompt names its strand; identify the trigger (negative fronting → invert; _it was … that_ → cleft; _must/can''t have_ → past deduction; -ing/-ed at clause start → participle clause; linking word slot → discourse marker), eliminate look-alikes, then choose.
- 🏆 Precision and versatility win: a hero who commands both the form and the effect has no weak room.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', 'The C2 Gauntlet', 'A mixed mastery-level challenge that blends the whole C2 band — the subjunctive and unreal past, idioms and figurative language, register, formality and nominalisation, nuance and confusable words, and ellipsis and substitution — across the grammar, vocabulary, usage and spelling strands, climbing from a warm-up to the ultimate elite trial.', '# ⚔️ The C2 Gauntlet — The Whole Mastery Band, One Dungeon

> 💡 «C1 made you precise. C2 makes you invisible — a speaker whose English leaves no seam, no foreign trace, no unnecessary word. Only the most complete mastery survives the final dungeon.»

Welcome back, champion. You cleared the C1 Gauntlet; now you stand at the summit. This is the **C2 Gauntlet** — the ultimate dungeon, where the rooms do not test whether you know English, but whether you _command_ it. One room asks you to use a form that has almost vanished from spoken English but remains alive in formal and literary writing. The next tests whether you know what a native speaker really means by a phrase that says one thing and means another. The third demands register awareness — can you shift from a casual sentence to a formal one without losing precision? The fourth forces you to choose between two words that look related but belong to different worlds. And the last strips away every redundant word, leaving only the grammatical skeleton. You never know which door opens next.

## 🏰 The Rule of the Gauntlet

Each battle **interleaves five strands** from the mastery band. Every answer requires not just rule knowledge but _linguistic intuition_ built on deep exposure. Every prompt is **tagged**: **Grammar —**, **Vocabulary —**, **Usage —**, or **Spelling —**.

## 🗡️ Grammar — the engine of C2

### The Subjunctive and Unreal Past

The **mandative subjunctive** uses the base form (infinitive) for all subjects, including third-person singular — no -s:

- _I suggest that she **be** present._ (not _is_)
- _It is essential that every student **submit** the form._ (not _submits_)
  Used after verbs of demand/recommendation/suggestion (_suggest, insist, recommend, demand, propose, require_) and adjective phrases (_it is essential/vital/necessary/important that_). Also found in **formulaic subjunctives**: _Be that as it may_, _Come what may_, _God save the King_, _Suffice it to say_.

The **unreal past** (also called the hypothetical past or the were-subjunctive) uses the past tense form for present/future hypothetical situations:

- _I wish I **were** taller._ (not _was_, in formal English)
- _If only she **hadn''t** said that!_
- _It''s time we **left**._ / _I''d rather you **didn''t** tell them._
- _Suppose/Imagine you **had** a million pounds — what would you do?_

### Idioms and Figurative Language

Idioms are non-compositional: the meaning cannot be predicted from the words. C2 mastery includes:

- Understanding them from context when you have never seen them before.
- Distinguishing idioms from literal uses (_break a leg_ vs _break a bone_).
- Key clusters: **body-part idioms** (_cost an arm and a leg_, _get cold feet_, _keep an eye on_, _bite the bullet_, _hit the nail on the head_), **animal idioms** (_let the cat out of the bag_, _the elephant in the room_, _beat around the bush_), **colour idioms** (_out of the blue_, _red tape_, _green light_, _once in a blue moon_), **idioms of effort/failure** (_go the extra mile_, _miss the boat_, _burn bridges_).
- Figurative language: metaphor (_the economy is bleeding_), metonymy (_the White House announced_), hyperbole (_I''ve told you a million times_).

### Register, Formality, and Nominalisation

Register is the variety of language appropriate to a situation. C2 requires conscious code-switching:

- Informal → formal: _start_ → _commence_; _find out_ → _ascertain_; _say_ → _state_; _look into_ → _investigate_; _buy_ → _purchase_.
- Nominalisation converts a verb or adjective into a noun, making prose more formal and abstract: _they failed_ → _their failure_; _we decided_ → _the decision_; _it declined_ → _a decline_. Academic writing relies heavily on nominalisation.
- Avoid fake formality: _utilise_ when _use_ is precise enough, or excessive passive when active is clearer.

### Nuance and Confusable Words

C2 precision means knowing the shade of difference between near-synonyms:

- _affect_ (verb: to influence) vs _effect_ (noun: a result; also a rare verb meaning to bring about)
- _imply_ (speaker hints) vs _infer_ (listener deduces)
- _disinterested_ (impartial, no stake) vs _uninterested_ (not curious/caring)
- _continual_ (repeated, with gaps) vs _continuous_ (unbroken, without pause)
- _fewer_ (countable) vs _less_ (uncountable)
- _historic_ (significant in history) vs _historical_ (of/relating to history)
- _comprise_ (to consist of) vs _compose_ (to make up: the parts compose the whole; the whole comprises the parts)

### Ellipsis and Substitution

Ellipsis omits understood words to avoid repetition; substitution replaces them with a pro-form.

- **Ellipsis**: _She can play piano and he can [play piano] too._ → _He can too._ / _I know you''re tired, but I am [tired] too._
- **Substitution**: _one/ones_ for nouns (_I bought the red one_), _do/does/did/do so_ for verb phrases (_She signed the contract and he did so later_), _so_ for clauses (_I think so, I hope so_).
- **Gapping** (comparative/parallel structure): _Mary ordered fish, and John [ordered] pasta._
  Ellipsis is only correct when the omitted material is recoverable; incorrect ellipsis creates ambiguity.

## 💎 Vocabulary — C2 precision

At C2 the vocabulary gaps are not in quantity but in nuance: the exact word for the exact shade. This includes low-frequency formal vocabulary (_pertinent_, _concede_, _corroborate_, _plausible_, _tentative_), the right preposition in a fixed phrase (_oblivious to_, _contingent on_, _commensurate with_), and awareness of **false friends** between English and French/Arabic that survive even at advanced level.

## ✒️ Spelling — mastery-level traps

C2 spelling traps are subtle: _accommodation_ (two c''s, two m''s), _conscientious_ (sc + ious), _miscellaneous_ (sc + aneous), _supersede_ (not -cede), _liaison_ (silent i in the middle), _millennium_ (two l''s, two n''s). Also: distinguishing British (_colour, programme, behaviour_) from American (_color, program, behavior_) spellings — consistent within a register.

> 🗡️ Hero''s tip: for the subjunctive, check whether the main verb or adjective is one of the trigger words (_suggest, insist, essential, vital_). For idioms, read the whole sentence for context — idioms live in situations, not in isolation. For confusables, ask: is this a verb-noun pair (_affect/effect_) or a nuance pair (_continual/continuous_)?

> ⚠️ Classic trap: _imply_ and _infer_ run in opposite directions — the speaker implies; the listener infers. Using them the wrong way is the single most common C2 error in academic writing. Likewise, _disinterested_ does NOT mean uninterested — a disinterested judge is impartial, not bored.

> 🏆 You now stand at the top. Clear the warm-up, drill the mixed rounds, topple the Boss, dare the Elite trial — and prove your English is truly masterful. The dungeon is complete.', '# 📜 Résumé: The C2 Gauntlet

- **Goal** — one mixed dungeon that tests the whole C2 mastery band at once, not a single chapter.
- **Grammar** — mandative subjunctive (base form for all subjects after _suggest/insist/essential/vital_: _that she be, that he submit_), unreal past (hypothetical situations: _I wish I were, It''s time we left, I''d rather you didn''t, If only…_), and formulaic subjunctives (_Be that as it may, Come what may_).
- **Vocabulary** — idioms and figurative language (body-part, animal, colour idiom clusters; metaphor and metonymy; meaning from context), and nuance/confusables (_affect/effect, imply/infer, disinterested/uninterested, continual/continuous, fewer/less, historic/historical, comprise/compose_).
- **Usage** — register and formality (code-switching: informal → formal; nominalisation: _they failed_ → _their failure_; avoiding fake formality), ellipsis and substitution (_one/ones, do so, so_; gapping; correct recovery of omitted material).
- **Spelling** — mastery-level words (_accommodation, conscientious, miscellaneous, supersede, liaison, millennium_), British vs American spelling consistency.
- **Method** — every prompt names its strand; for the subjunctive identify the trigger verb/adjective; for idioms read the full context; for confusables ask the semantic question (direction of meaning, countable/uncountable, adjective meaning); for ellipsis confirm the omitted material is recoverable.
- 🏆 Mastery wins: a speaker with no seam, no redundancy, and no false note commands every room.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5b207218-401a-5ff5-aae6-4f38547dd5e8', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ba906a31-7a45-59ab-8ff7-772704dec110', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Grammar — Complete: "The children ___ in the garden."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'b', 'Children is the plural of child, so it takes are: The children are in the garden. Is is only for a singular subject (the child is…), am is only for I, and be is the base form, not a present-tense form here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30bce9d3-1707-52b7-95ad-287271987f56', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"red"},{"id":"b","text":"blue"},{"id":"c","text":"apple"},{"id":"d","text":"green"}]'::jsonb, 'c', 'Red, blue and green are all colours, but apple is a food, so it is the odd one out. The intruder is grouped with the colours to test whether you sort words by meaning, not just recognise them.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6a7cd9b-f60d-5b73-aa7e-2b240ca68fdb', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Reading — Read: "Tom is a cook. He works in a restaurant. He makes pizza every day."
What is Tom''s job?', '[{"id":"a","text":"He is a cook."},{"id":"b","text":"He is a driver."},{"id":"c","text":"He is a teacher."},{"id":"d","text":"He is a doctor."}]'::jsonb, 'a', 'The text says directly "Tom is a cook", so that is his job. A reading answer must come from the text: driver, teacher and doctor are never mentioned, so they cannot be correct even though they are real jobs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b44b887-c29f-5439-a207-436abe18f062', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Spelling — Choose the correctly spelled plural of "city".', '[{"id":"a","text":"citys"},{"id":"b","text":"cityes"},{"id":"c","text":"cityies"},{"id":"d","text":"cities"}]'::jsonb, 'd', 'A noun ending in consonant + y changes y to i and adds -es: city → cities. "Citys" forgets the rule, and "cityes"/"cityies" keep the y by mistake. Compare baby → babies, party → parties.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d0dac16-6cad-5e51-a55c-81022aef2e7f', '5b207218-401a-5ff5-aae6-4f38547dd5e8', 'Grammar — Complete: "She ___ English at school."', '[{"id":"a","text":"study"},{"id":"b","text":"studys"},{"id":"c","text":"studies"},{"id":"d","text":"studying"}]'::jsonb, 'c', 'In the present simple, he/she/it adds -s, and a verb ending consonant + y changes to -ies: she studies. "Study" misses the third-person -s, "studys" breaks the y → ies spelling rule, and "studying" needs a form of be (she is studying).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ad976a04-473a-5f6d-9899-3f29605d8a30', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⭐ Gauntlet: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4b280be3-3f34-5c19-95b8-f59252504bd7', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Grammar — Complete: "I ___ from Tunisia."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'c', 'The subject I always takes am: I am from Tunisia. Is goes only with he/she/it, are with you/we/they, and be is the base form (used after to or a modal), not a present-tense form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be139b80-7580-5bd6-860d-4e161113c11b', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"mother"},{"id":"b","text":"sister"},{"id":"c","text":"brother"},{"id":"d","text":"table"}]'::jsonb, 'd', 'Mother, sister and brother are all family members, but table is an object, so it is the odd one out. The set tests whether you group words by meaning: a piece of furniture does not belong with the family.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d416661a-e85c-5a8e-9762-d8ad90c1b005', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Spelling — Choose the correctly spelled plural of "book".', '[{"id":"a","text":"bookes"},{"id":"b","text":"books"},{"id":"c","text":"bookies"},{"id":"d","text":"book''s"}]'::jsonb, 'b', 'Most nouns form the plural by simply adding -s: book → books. "Bookes" wrongly adds -es (that is only after -s, -x, -z, -ch, -sh), and "book''s" with an apostrophe shows possession, not a plural.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5ae6c61-8f2c-55b6-a264-105387395a5c', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Reading — Read: "This is Sara. She is nine years old. She is a student."
How old is Sara?', '[{"id":"a","text":"She is nine years old."},{"id":"b","text":"She is a student."},{"id":"c","text":"She is ten years old."},{"id":"d","text":"She is a teacher."}]'::jsonb, 'a', 'The text says "She is nine years old", so that is the answer. Read for the exact detail: (b) gives her job, not her age; (c) changes the number; and (d) contradicts the text, which calls her a student.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93b07ded-86c0-57b2-bc36-79f1df9297e6', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Grammar — Choose the correct article: "I have ___ apple."', '[{"id":"a","text":"the"},{"id":"b","text":"a"},{"id":"c","text":"an"},{"id":"d","text":"—  (no article)"}]'::jsonb, 'c', 'Apple begins with a vowel sound, so it takes an: an apple. Use a before a consonant sound (a book), and the for something already known. A singular countable noun like apple needs an article, so "no article" is wrong here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6c804d3-5bb4-55ba-8050-ced151076007', 'ad976a04-473a-5f6d-9899-3f29605d8a30', 'Vocabulary — Which word means a place where you learn?', '[{"id":"a","text":"kitchen"},{"id":"b","text":"school"},{"id":"c","text":"garden"},{"id":"d","text":"hospital"}]'::jsonb, 'b', 'A school is the place where you learn. A kitchen is where you cook, a garden is where plants grow, and a hospital is where doctors help sick people — each is a real place, but only school matches "where you learn".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⭐⭐ Gauntlet: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d4f9f123-8958-5a0b-b5ef-dc984f751769', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Grammar — Complete: "My brother ___ football every weekend."', '[{"id":"a","text":"play"},{"id":"b","text":"are playing"},{"id":"c","text":"playing"},{"id":"d","text":"plays"}]'::jsonb, 'd', 'In the present simple, he/she/it adds -s: my brother plays football. "Play" misses the third-person -s, "playing" needs a form of be, and "are playing" uses are with a singular subject — it should be is, and the habit "every weekend" calls for the present simple anyway.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af6f3259-f18f-5800-9d91-76c77b5b9716', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Spelling — Choose the correctly spelled plural of "brush".', '[{"id":"a","text":"brushs"},{"id":"b","text":"brushies"},{"id":"c","text":"brushes"},{"id":"d","text":"brushs''"}]'::jsonb, 'c', 'Nouns ending in -sh add -es: brush → brushes (the -es makes the extra syllable easy to say). "Brushs" forgets the -es rule, "brushies" wrongly applies the y → ies pattern, and the apostrophe form shows possession, not a plural. Compare dish → dishes, glass → glasses.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd8da27a-dce8-5adb-93ec-4f0ebc14d563', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Vocabulary — Complete the collocation: "She bought a ___ of water at the shop."', '[{"id":"a","text":"bottle"},{"id":"b","text":"loaf"},{"id":"c","text":"slice"},{"id":"d","text":"bar"}]'::jsonb, 'a', 'Water you buy or carry comes in a bottle, so we say a bottle of water. A loaf and a slice go with bread (a loaf of bread), and a bar goes with chocolate or soap — none of those is a container for a drink you take from a shop.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49a10031-9a73-5deb-b003-ca2c122aa1be', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Reading — Read: "Ali and Omar are brothers. Ali likes red. Omar likes blue."
What colour does Omar like?', '[{"id":"a","text":"He likes red."},{"id":"b","text":"He likes blue."},{"id":"c","text":"He likes green."},{"id":"d","text":"They like the same colour."}]'::jsonb, 'b', 'The text says "Omar likes blue", so blue is the answer. Watch the trap in (a): red is Ali''s colour, not Omar''s. Green (c) is never mentioned, and (d) contradicts the text, which gives the brothers two different colours.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de1f1f74-b5e6-51a3-816f-4eae7524e380', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Grammar — Complete: "___ two windows in this room."', '[{"id":"a","text":"There is"},{"id":"b","text":"It is"},{"id":"c","text":"There be"},{"id":"d","text":"There are"}]'::jsonb, 'd', 'Two windows is plural, so use there are: There are two windows. There is is for one thing (there is a window), "there be" is not a finite form, and it is cannot introduce a plural like this.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('379e487e-550b-5153-9476-832883aa9c6a', '60d33abe-abfb-5a93-9fa1-a611ca9cd6b4', 'Spelling — Choose the correctly spelled plural of "person".', '[{"id":"a","text":"people"},{"id":"b","text":"persons"},{"id":"c","text":"peoples"},{"id":"d","text":"personies"}]'::jsonb, 'a', 'Person has an irregular plural: person → people (no -s rule applies in everyday English). "Persons" is only used in very formal or legal English; "peoples" doubles the plural (people is already plural, so it takes no final -s, except to mean separate nations); and "personies" invents an ending that does not exist.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '⚔️ Gauntlet Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('3d4a8d9f-f787-5721-80d0-a7417f53b6f6', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Grammar — Complete: "My sister ___ like coffee."', '[{"id":"a","text":"don''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"isn''t"},{"id":"d","text":"aren''t"}]'::jsonb, 'b', 'In the present simple, he/she/it makes the negative with doesn''t + base verb: My sister doesn''t like coffee. "Don''t" is for I/you/we/they; isn''t and aren''t belong to the verb to be, not to an ordinary verb like like.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25945e86-4411-5059-a96e-64065bbd2631', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Reading — Read: "Sami works in a school. He helps children learn to read, and every evening he marks their homework."
What is most likely Sami''s job?', '[{"id":"a","text":"He is a nurse."},{"id":"b","text":"He is a farmer."},{"id":"c","text":"He is a teacher."},{"id":"d","text":"He is a pilot."}]'::jsonb, 'c', 'The text never says "teacher", but working in a school, helping children learn to read and marking homework together point to a teacher — a supported inference. A nurse helps sick people, a farmer grows crops, and a pilot flies planes, so none of them matches the school clues.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd3a7ed3-3fc8-50c4-a770-ae1a9cf8964d', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"boxes"},{"id":"b","text":"buses"},{"id":"c","text":"dishes"},{"id":"d","text":"babys"}]'::jsonb, 'd', 'The error is (d): a noun ending consonant + y changes to -ies, so it is babies, never "babys". The correct ones follow the -es rule after -x, -s and -sh: boxes, buses, dishes are all right.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a3b40b9-6533-5c7a-9dd8-7d50ad3347f8', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"Monday"},{"id":"b","text":"doctor"},{"id":"c","text":"teacher"},{"id":"d","text":"farmer"}]'::jsonb, 'a', 'Doctor, teacher and farmer are all jobs, but Monday is a day of the week, so it is the odd one out. The trap is that Monday looks at home among capitalised words, but it belongs to a different set — sort by meaning, not by appearance.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9feae4fe-1931-51a8-a81a-19fdb0107ece', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Grammar — Choose the correct article: "___ sun is very hot today."', '[{"id":"a","text":"A"},{"id":"b","text":"An"},{"id":"c","text":"—  (no article)"},{"id":"d","text":"The"}]'::jsonb, 'd', 'There is only one sun, so it is unique and takes the: The sun is very hot. We use a/an for one of many on first mention (a book), but a one-of-a-kind thing — the sun, the moon, the sky — always takes the.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1017f94d-0a74-56ce-a038-27db95459e51', 'ea3612c9-51c6-5388-b3f5-d61f2c7c33c7', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"keys"},{"id":"b","text":"citys"},{"id":"c","text":"days"},{"id":"d","text":"boys"}]'::jsonb, 'b', 'The error is (b): city ends in consonant + y, so it becomes cities, not "citys". The correct ones end in vowel + y, which simply adds -s: keys, days, boys. The letter before the y decides the rule.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('764099d1-17f2-525c-94bf-42d9c6a02b8c', 'fb713601-2e53-5225-b1e4-6b02471bee44', 'anglais-donjon', '👑 Gauntlet Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b8854449-dfaf-5884-ae50-748cc2ca4ce7', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Reading — Read: "Nour has two cats and one dog. The cats are black. The dog is brown."
Which sentence is TRUE?', '[{"id":"a","text":"Nour has two dogs."},{"id":"b","text":"The dog is black."},{"id":"c","text":"Nour has three pets."},{"id":"d","text":"The cats are brown."}]'::jsonb, 'c', 'Two cats + one dog = three pets, so (c) is true. The others contradict the text: Nour has one dog, not two (a); the dog is brown, not black (b); and the cats are black, not brown (d). Combine the facts before choosing.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4045dd96-d531-5fc2-b60a-b0c81ead6640', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Grammar — Choose the fully correct sentence.', '[{"id":"a","text":"She watch a film every weekend."},{"id":"b","text":"She watches a film every weekend."},{"id":"c","text":"She watches a film every weekends."},{"id":"d","text":"She watch films every weekend."}]'::jsonb, 'b', 'With she, the present simple adds -es: she watches. We also say every weekend (singular after every), so (b) is fully correct. (a) and (d) drop the third-person -s, and (c) wrongly pluralizes after every — every is always followed by a singular noun.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('456a8a78-00ce-5ec9-a4aa-a2bdcfb66066', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Spelling — Find the INCORRECT plural.', '[{"id":"a","text":"mans"},{"id":"b","text":"feet"},{"id":"c","text":"teeth"},{"id":"d","text":"mice"}]'::jsonb, 'a', 'The error is (a): man has an irregular plural, men, never "mans". The others are also irregular and correct: foot → feet, tooth → teeth, mouse → mice. None of these common nouns takes a regular -s.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94d35856-7f59-5838-bfae-b300b41bfe6c', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Vocabulary — Choose the word that best completes the sentence: "This bag is cheap, but that phone is very ___."', '[{"id":"a","text":"small"},{"id":"b","text":"fast"},{"id":"c","text":"happy"},{"id":"d","text":"expensive"}]'::jsonb, 'd', '"But" signals a contrast with cheap, so the missing word is its opposite, expensive: cheap ↔ expensive. Small, fast and happy are real adjectives, but none is the opposite of cheap, so they break the contrast the sentence sets up.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc67e3e3-776a-5c79-b592-e7885616e636', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Grammar — Put the words in the correct order: (study / what / does / he)', '[{"id":"a","text":"What does he study?"},{"id":"b","text":"What he does study?"},{"id":"c","text":"What does he studies?"},{"id":"d","text":"What studies he?"}]'::jsonb, 'a', 'An ordinary-verb question is: question word + does + subject + base verb → What does he study? "What he does study" misplaces the subject, "studies" double-marks the -s (it lives on does, not the main verb), and "What studies he?" drops the helper does and keeps statement order.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e10af6dc-8b76-5dbf-9fda-31c7dc81ab14', '764099d1-17f2-525c-94bf-42d9c6a02b8c', 'Spelling — Choose the correctly spelled plural of "shelf".', '[{"id":"a","text":"shelfs"},{"id":"b","text":"shelfes"},{"id":"c","text":"shelvs"},{"id":"d","text":"shelves"}]'::jsonb, 'd', 'Some nouns ending in -f or -fe change f to v and add -es: shelf → shelves (like wolf → wolves, half → halves). "Shelfs" and "shelfes" keep the f instead of switching to v, and "shelvs" changes to v but drops the needed -e before -s.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('088a3348-6c2f-5c30-9f59-99e199212f46', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('fcba8d94-0a5b-5675-a05f-134dab76dcfd', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Grammar — Complete the past simple: "We ___ a wonderful film at the cinema last Friday."', '[{"id":"a","text":"see"},{"id":"b","text":"saw"},{"id":"c","text":"seen"},{"id":"d","text":"seeing"}]'::jsonb, 'b', 'see is irregular: its past simple is saw, used here with the time marker "last Friday": We saw a wonderful film. "see" is the base/present, "seen" is the past participle (used after have), and "seeing" is the -ing form, which needs a form of be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fd6a582-42fe-56d8-a9a5-8f0453565cc6', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Grammar — Now or habit? Complete: "Don''t disturb him — Dad ___ a phone call at the moment."', '[{"id":"a","text":"is making"},{"id":"b","text":"make"},{"id":"c","text":"makes"},{"id":"d","text":"are making"}]'::jsonb, 'a', '"at the moment" marks an action in progress, so use the present continuous; Dad = he, so the form is is making. "makes"/"make" are the present simple (for habits), and "are making" uses the plural be with a singular subject.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a19ce6e-44b7-5b44-84c4-70086c841584', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"summer"},{"id":"b","text":"winter"},{"id":"c","text":"autumn"},{"id":"d","text":"Tuesday"}]'::jsonb, 'd', 'Summer, winter and autumn are all seasons, but Tuesday is a day of the week, so it is the odd one out. Sort the set by meaning, not by the fact that they are all time words.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30aaecf9-d5a9-5515-9565-5eade9a990dd', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Spelling — Choose the correct comparative of "big": "An elephant is ___ than a horse."', '[{"id":"a","text":"biger"},{"id":"b","text":"more big"},{"id":"c","text":"bigger"},{"id":"d","text":"biggest"}]'::jsonb, 'c', 'big has one short vowel + one consonant, so we double the g before -er: bigger than a horse. "biger" forgets to double the g, "more big" wrongly adds more to a short adjective, and "biggest" is the superlative (which needs the and no than).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb2d0e6-638f-5362-a00c-592c72f75f3e', '088a3348-6c2f-5c30-9f59-99e199212f46', 'Reading — Read: "Last weekend Leila painted her room. On Saturday she chose the colour, and on Sunday she finished the work."
When did Leila finish painting?', '[{"id":"a","text":"On Friday."},{"id":"b","text":"On Saturday."},{"id":"c","text":"On Sunday."},{"id":"d","text":"Next weekend."}]'::jsonb, 'c', 'The text says she finished the work "on Sunday", so (c) is correct. Read for the exact detail: Saturday (b) was when she chose the colour, Friday (a) is never mentioned, and the story is in the past, not "next weekend" (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ac1edda7-019a-5303-b405-2243e1707f2f', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⭐ Gauntlet A2: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9ffbae32-455d-5620-b30e-210f217f240d', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Grammar — Complete the past simple: "Yesterday my sister ___ a cake for the party."', '[{"id":"a","text":"bakes"},{"id":"b","text":"baked"},{"id":"c","text":"baking"},{"id":"d","text":"bake"}]'::jsonb, 'b', 'bake is a regular verb ending in -e, so we add only -d for the past: baked. With "yesterday" we need the past, so "bakes"/"bake" (present) and "baking" (the -ing form, which needs be) are all wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf099e79-fba7-5832-b484-acfcb3094e59', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Spelling — Choose the correct -ing form: "Look! The dog ___ across the field."', '[{"id":"a","text":"is runing"},{"id":"b","text":"is runeing"},{"id":"c","text":"is running"},{"id":"d","text":"is run"}]'::jsonb, 'c', 'run has one short vowel + one consonant, so we double the n before -ing: running. "is runing" forgets to double the n, "is runeing" adds a wrong e, and "is run" drops the -ing the continuous needs.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84dd849c-f5f7-56a9-87a8-6bf27982b393', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"apple"},{"id":"b","text":"banana"},{"id":"c","text":"carrot"},{"id":"d","text":"orange"}]'::jsonb, 'c', 'Apple, banana and orange are all fruits, but a carrot is a vegetable, so it is the odd one out. Sort by meaning: the set looks like "food", but only the fruits belong together.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89b12fff-740e-54f2-88e8-100a500354f2', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Reading — Read: "Karim got up early on Sunday. He went to the bakery and bought fresh bread for breakfast."
Where did Karim go?', '[{"id":"a","text":"To the bakery."},{"id":"b","text":"To school."},{"id":"c","text":"To the cinema."},{"id":"d","text":"To the beach."}]'::jsonb, 'a', 'The text says "He went to the bakery", so that is the answer. A reading answer must come from the text: school, cinema and beach are real places but are never mentioned, so they cannot be correct.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4054d66b-a984-59b3-b10c-6aad8e6f64bc', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Grammar — Future: "I''ve already decided — next summer I ___ visit my uncle in Sfax." (a plan)', '[{"id":"a","text":"will to"},{"id":"b","text":"am going to"},{"id":"c","text":"going to"},{"id":"d","text":"go to"}]'::jsonb, 'b', 'A plan you already decided uses be going to + base verb: I am going to visit. "will to" is never correct (will takes no to), "going to" alone drops the be (am), and "go to" is the present, not a future plan.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ace366dc-2fca-5c26-a061-3eac12cbfdce', 'ac1edda7-019a-5303-b405-2243e1707f2f', 'Spelling — Choose the correctly spelled past form: "He ___ very hard for the test last week."', '[{"id":"a","text":"studyed"},{"id":"b","text":"studed"},{"id":"c","text":"studies"},{"id":"d","text":"studied"}]'::jsonb, 'd', 'study ends in consonant + y, so the y becomes -ied in the past: studied. "studyed" keeps the y wrongly, "studed" drops a letter, and "studies" is the present he/she/it form, not the past.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('921bba7a-96bc-5389-8a70-774129c4103c', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⭐⭐ Gauntlet A2: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('0dd8f34e-b3de-5cc6-ac9a-91fdad7e2131', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Now or habit? "My father usually drives to work, but today he ___ the train."', '[{"id":"a","text":"takes"},{"id":"b","text":"is taking"},{"id":"c","text":"take"},{"id":"d","text":"are taking"}]'::jsonb, 'b', '"today" marks a temporary action against the usual habit, so use the present continuous: today he is taking the train. "usually drives" is the habit (simple), but "today" switches us to the continuous; "takes"/"take" are simple, and "are taking" uses the plural be with he.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e01a6c-d449-59bd-b089-a974205fbb09', '921bba7a-96bc-5389-8a70-774129c4103c', 'Vocabulary — Choose the opposite: "This suitcase isn''t heavy at all — in fact it''s very ___."', '[{"id":"a","text":"big"},{"id":"b","text":"old"},{"id":"c","text":"light"},{"id":"d","text":"expensive"}]'::jsonb, 'c', 'The opposite of heavy is light, so a case that isn''t heavy is very light. Big, old and expensive are real adjectives, but none is the opposite of heavy, so they don''t fit the contrast the sentence builds.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b38b70eb-7f13-5b7a-b4d2-cfe60c4d278b', '921bba7a-96bc-5389-8a70-774129c4103c', 'Spelling — Choose the correct superlative: "That was the ___ day of my whole holiday."', '[{"id":"a","text":"happyest"},{"id":"b","text":"most happy"},{"id":"c","text":"happier"},{"id":"d","text":"happiest"}]'::jsonb, 'd', 'happy ends in consonant + y, so the superlative changes y to i and adds -est: the happiest day. "happyest" keeps the y wrongly, "most happy" treats a short -y adjective as long (it isn''t), and "happier" is the comparative (for two things).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('391494ec-2225-548e-baa9-cfefa0f3d473', '921bba7a-96bc-5389-8a70-774129c4103c', 'Reading — Read: "Last Saturday Omar and his friends played football in the park. After the game they were thirsty, so they bought cold drinks."
How did the friends feel after the game?', '[{"id":"a","text":"They were thirsty."},{"id":"b","text":"They were cold."},{"id":"c","text":"They were bored."},{"id":"d","text":"They were afraid."}]'::jsonb, 'a', 'The text says "they were thirsty", which is why they bought cold drinks, so (a) is correct. Read for the exact detail: cold (b) describes the drinks, not the boys, and bored (c) and afraid (d) are never mentioned in the passage.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f688da08-7b8e-563f-aa96-08929c36fe04', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Quantifier: "Hurry up! We don''t have ___ time before the bus leaves."', '[{"id":"a","text":"many"},{"id":"b","text":"a few"},{"id":"c","text":"much"},{"id":"d","text":"some"}]'::jsonb, 'c', 'time is uncountable, so its amount word is much, and in a negative it fits naturally: we don''t have much time. many and a few need countable plural nouns, and some is normally used in affirmatives, not negatives.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dc6a633-b197-5ca5-a17f-6d497dbfa8da', '921bba7a-96bc-5389-8a70-774129c4103c', 'Grammar — Future: "A: There''s no milk left for the coffee. B: Oh, I ___ buy some on my way home." (deciding as you speak)', '[{"id":"a","text":"am going to"},{"id":"b","text":"will"},{"id":"c","text":"will to"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'B reacts to the news and decides at that moment, so use will + base verb: I will buy some. "am going to" would suggest a plan made earlier, "will to" wrongly adds to after will, and "going to" alone is missing the be (am).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('10d813a5-0872-5aaa-991d-7f0f76b66c9f', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '⚔️ Gauntlet A2 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('2b43508d-291e-587b-aa57-d359f8653093', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Put the words in the correct order: (did / when / you / arrive)', '[{"id":"a","text":"When did you arrive?"},{"id":"b","text":"When you did arrive?"},{"id":"c","text":"When did you arrived?"},{"id":"d","text":"When arrived you?"}]'::jsonb, 'a', 'A past question with an action verb is: question word + did + subject + base verb → When did you arrive? "When you did arrive" keeps statement order, "did you arrived" double-marks the past (the -ed lives on the helper did), and "When arrived you?" drops the helper did.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f1cf64b-c744-5acf-911e-3c32c2b7e851', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"making"},{"id":"b","text":"writing"},{"id":"c","text":"coming"},{"id":"d","text":"swiming"}]'::jsonb, 'd', 'The error is (d): swim has one short vowel + one consonant, so the m doubles before -ing — swimming, not "swiming". The correct ones drop a silent -e before -ing: make → making, write → writing, come → coming.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('feaf3563-3abe-5395-b244-3e880ec79df8', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"kitchen"},{"id":"b","text":"garden"},{"id":"c","text":"bedroom"},{"id":"d","text":"bathroom"}]'::jsonb, 'b', 'Kitchen, bedroom and bathroom are all rooms inside a house, but a garden is outside, so it is the odd one out. The trap is that all four belong to a home, but only the indoor rooms form the matching set.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93bfba0b-b84e-5a2c-93fe-08a9055b04b0', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Comparison: "This chair is ___ comfortable ___ that one; they feel exactly the same."', '[{"id":"a","text":"more … than"},{"id":"b","text":"so … then"},{"id":"c","text":"as … as"},{"id":"d","text":"the … est"}]'::jsonb, 'c', 'To say two things are equal we use as + adjective + as: as comfortable as that one. "more … than" would make one chair greater (but they''re the same), "then" is a time word (not than), and "the …est" is the superlative pattern, not a comparison of two chairs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27d3bdd0-d5b2-53f1-b433-2110058bdc89', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Reading — Read: "Hana wanted to buy a present for her mother. She had a little money, just enough for some flowers, but not enough for the scarf she liked."
What could Hana buy?', '[{"id":"a","text":"Some flowers."},{"id":"b","text":"The scarf."},{"id":"c","text":"Both the scarf and the flowers."},{"id":"d","text":"Nothing at all."}]'::jsonb, 'a', 'The text says she had "just enough for some flowers, but not enough for the scarf", so she could buy some flowers (a). She could not afford the scarf (so b and c are out), and "a little money" still means she had some, so "nothing at all" (d) is wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('644a8500-026c-5933-8686-11915e185e57', '10d813a5-0872-5aaa-991d-7f0f76b66c9f', 'Grammar — Future: "Our team is winning 3–0 with five minutes left. They ___ win the match!" (the evidence is clear)', '[{"id":"a","text":"will to"},{"id":"b","text":"are going to"},{"id":"c","text":"are going"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'A prediction from clear evidence in front of you uses be going to; with they the form is are going to: They are going to win. "are going" is missing the to, "going to" is missing the be (are), and "will to" is never correct because will takes no to.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc2145a3-1830-5fed-94ce-6b74e92b395c', '9a5c79f6-867a-54ee-8649-f2559d061b06', 'anglais-donjon', '👑 Gauntlet A2 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('20083635-85e1-5bf9-9ceb-3fb001d288c9', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Reading — Read: "Last winter Youssef broke his leg while skiing. He stayed at home for a month and couldn''t play football. His friends visited him every weekend."
Which sentence is TRUE?', '[{"id":"a","text":"Youssef hurt his leg last winter."},{"id":"b","text":"Youssef broke his arm."},{"id":"c","text":"He played football at home."},{"id":"d","text":"Nobody visited him."}]'::jsonb, 'a', 'The text says he "broke his leg" last winter, so (a) is true (to break your leg = to hurt it). It was his leg, not his arm (b); he "couldn''t play football" (c is false); and his friends visited every weekend, so (d) contradicts the text.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3485792-24b3-59fa-be2a-7c5246e9b53f', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"We didn''t go to the market yesterday."},{"id":"b","text":"She is reading a book at the moment."},{"id":"c","text":"They will going to move house next year."},{"id":"d","text":"He bought a new bike last week."}]'::jsonb, 'c', 'The error is (c): you can''t stack two futures — say "They are going to move" or "They will move", never "will going to". (a) is a correct past negative (didn''t + base), (b) a correct present continuous (now), and (d) a correct irregular past (bought).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f320f6f-b28d-56a9-8277-c01e618d4a34', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"hottest"},{"id":"b","text":"easiest"},{"id":"c","text":"biggest"},{"id":"d","text":"funnyest"}]'::jsonb, 'd', 'The error is (d): funny ends in consonant + y, so the y becomes i — funniest, not "funnyest". The correct ones follow their rules: hot doubles the t (hottest), easy changes y to i (easiest), and big doubles the g (biggest).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f14f7ec-3e0b-50e3-af2d-176eaa9a3ced', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Vocabulary — Choose the word that best completes the sentence: "The first question was easy, but the last one was really ___."', '[{"id":"a","text":"cheap"},{"id":"b","text":"difficult"},{"id":"c","text":"quiet"},{"id":"d","text":"early"}]'::jsonb, 'b', '"but" signals a contrast with easy, so the missing word is its opposite, difficult: easy ↔ difficult. Cheap, quiet and early are real adjectives, but none is the opposite of easy, so they break the contrast the sentence sets up.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c98ec9e-bf30-5942-9a0a-de4c43ea858b', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Grammar — Quantifiers: "There were ___ guests at the wedding, but only ___ of them danced."', '[{"id":"a","text":"many / a few"},{"id":"b","text":"a little / many"},{"id":"c","text":"much / a little"},{"id":"d","text":"a great deal / a few"}]'::jsonb, 'a', 'guests is countable and plural, so both gaps need countable quantifiers: many guests, and a few of them danced. So it is many / a few. much, a little and a great deal are for uncountable nouns and don''t fit countable guests.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d0b4f5f-9fd3-5242-9f1a-0a295edd87ea', 'fc2145a3-1830-5fed-94ce-6b74e92b395c', 'Reading — Read: "It''s 7 o''clock in the morning. Lina is at the bus stop with her schoolbag. She is looking at her watch and the bus isn''t here yet."
What is Lina probably doing?', '[{"id":"a","text":"She is sleeping at home."},{"id":"b","text":"She is cooking breakfast."},{"id":"c","text":"She is playing in the park."},{"id":"d","text":"She is waiting for the bus."}]'::jsonb, 'd', 'The clues — at the bus stop, with her schoolbag, looking at her watch, the bus not here yet — point to an action in progress now: she is waiting for the bus (d). "sleeping at home", "cooking breakfast" and "playing in the park" all contradict "is at the bus stop".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fcb06e0b-85c9-5e82-b475-a102bd8f1a41', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('315c2129-e18c-5618-b783-d3befb72b319', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Grammar — Present perfect: "Be careful — he ___ broken his arm, so he can''t play today."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"is"},{"id":"d","text":"had"}]'::jsonb, 'b', 'A past action with a result now (he can''t play) takes the present perfect, and with he the auxiliary is has + participle: he has broken his arm. "have" is for I/you/we/they, "is" doesn''t form the present perfect, and "had" is the past perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be963e07-2c4e-50c4-9523-33d4dd3877a9', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"thunder"},{"id":"b","text":"lightning"},{"id":"c","text":"fog"},{"id":"d","text":"ceiling"}]'::jsonb, 'd', 'Thunder, lightning and fog are all weather words, but a ceiling is part of a room, so it is the odd one out. Sort the set by meaning: three belong to the weather, while ceiling belongs to a building.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('030a1f57-a9c6-5b83-bd90-dde2ccc10efa', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Grammar — Advice: "You''ve had a headache all day. You ___ rest and drink some water."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"should"},{"id":"d","text":"should to"}]'::jsonb, 'c', 'This is friendly advice, so we use should + base verb: You should rest. "should to" is wrong (no to after should), "mustn''t" would forbid resting, and "don''t have to" only says it''s optional rather than recommended.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('624f39c3-31a4-5b2a-86f8-dfabfd05bc92', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Spelling — Choose the correct -ing form: "She was ___ for clothes when I saw her in town."', '[{"id":"a","text":"shoping"},{"id":"b","text":"shopping"},{"id":"c","text":"shoppping"},{"id":"d","text":"shopeing"}]'::jsonb, 'b', 'shop has one short vowel + one consonant, so the p doubles before -ing: shopping. "shoping" forgets to double the p, "shoppping" adds one too many, and "shopeing" wrongly inserts an e.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f402bb1-d0ea-5b17-a1ae-8546063df794', 'fcb06e0b-85c9-5e82-b475-a102bd8f1a41', 'Reading — Read: "Nadia moved to Tunis in 2019 and still lives there. She has worked at the same school since she arrived."
Where does Nadia live now?', '[{"id":"a","text":"In Tunis."},{"id":"b","text":"In Sfax."},{"id":"c","text":"In Paris."},{"id":"d","text":"She has left the country."}]'::jsonb, 'a', 'The text says she moved to Tunis and "still lives there", so she lives in Tunis now (a). Read for the detail: Sfax and Paris are never mentioned, and "still lives there" tells us she has not left (d is wrong).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('30d03a04-6201-59a0-a734-7750c0966a66', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⭐ Gauntlet B1: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('04a07c4f-9182-593f-abc9-745311969be3', '30d03a04-6201-59a0-a734-7750c0966a66', 'Grammar — Present perfect: "I ___ already read that book, so I''ll lend it to you."', '[{"id":"a","text":"has"},{"id":"b","text":"have"},{"id":"c","text":"am"},{"id":"d","text":"was"}]'::jsonb, 'b', 'With I the present perfect auxiliary is have + participle: I have already read it. "has" is only for he/she/it, "am" doesn''t form the present perfect, and "was" is the past simple of be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01e99d6b-2648-56a4-a69b-5149e18a61a1', '30d03a04-6201-59a0-a734-7750c0966a66', 'Spelling — Choose the correct -ing form: "The children were ___ in the pool all afternoon."', '[{"id":"a","text":"swiming"},{"id":"b","text":"swimming"},{"id":"c","text":"swimeing"},{"id":"d","text":"swimmming"}]'::jsonb, 'b', 'swim has one short vowel + one consonant, so the m doubles before -ing: swimming. "swiming" keeps only one m, "swimeing" adds a wrong e, and "swimmming" has one m too many.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c5bdd7a-c6bf-5b9b-a482-1c2ba61aba94', '30d03a04-6201-59a0-a734-7750c0966a66', 'Vocabulary — Which word is the odd one out?', '[{"id":"a","text":"doctor"},{"id":"b","text":"nurse"},{"id":"c","text":"hospital"},{"id":"d","text":"dentist"}]'::jsonb, 'c', 'Doctor, nurse and dentist are all people who work in health, but a hospital is a place, so it is the odd one out. Sort by meaning: three are jobs, while hospital is where they work.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e976e35f-7fd3-5b2c-9581-86dc41a59f26', '30d03a04-6201-59a0-a734-7750c0966a66', 'Grammar — Obligation: "At my school we ___ wear a uniform every day; it''s a strict rule."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"have"},{"id":"d","text":"have to"}]'::jsonb, 'd', 'A strict rule is an obligation, and with we we use have to + base verb: we have to wear a uniform. "don''t have to" would make it optional, "shouldn''t" advises against it, and "have" alone (without to) doesn''t express the rule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c54e7d72-8852-5ac4-95c1-8498373a6509', '30d03a04-6201-59a0-a734-7750c0966a66', 'Reading — Read: "Yesterday it was raining hard. Sami was waiting at the bus stop without an umbrella, so he got completely wet."
Why did Sami get wet?', '[{"id":"a","text":"He had no umbrella in the rain."},{"id":"b","text":"He fell into a river."},{"id":"c","text":"He was swimming."},{"id":"d","text":"He washed his car."}]'::jsonb, 'a', 'The text says it was raining and he was waiting "without an umbrella", so he got wet from the rain (a). A reading answer must come from the text: a river, swimming and washing a car are never mentioned.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('147d8224-0891-5ac2-a017-7bad399412c1', '30d03a04-6201-59a0-a734-7750c0966a66', 'Spelling — Choose the correct past participle: "We have ___ all the sandwiches; there are none left."', '[{"id":"a","text":"ate"},{"id":"b","text":"eated"},{"id":"c","text":"eaten"},{"id":"d","text":"eat"}]'::jsonb, 'c', 'eat is irregular: eat → ate (past) → eaten (participle). After have we use the participle: We have eaten them. "ate" is the past simple, "eated" is not a word, and "eat" is the base form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⭐⭐ Gauntlet B1: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('2e505b1f-9d16-5b27-a959-6a584d42345f', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — Past continuous: "___ we were walking home, we met an old friend."', '[{"id":"a","text":"When"},{"id":"b","text":"While"},{"id":"c","text":"Since"},{"id":"d","text":"During"}]'::jsonb, 'b', 'while introduces the long action in progress (we were walking): While we were walking home… The short event (we met a friend) is in the past simple. "when" goes with the short action, "since" marks a start point, and "during" is followed by a noun, not a clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e501524-914c-5567-b7b7-716f575dcc38', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Vocabulary — Choose the opposite: "The first exercise was difficult, but this one is quite ___."', '[{"id":"a","text":"heavy"},{"id":"b","text":"loud"},{"id":"c","text":"easy"},{"id":"d","text":"tall"}]'::jsonb, 'c', '"but" signals a contrast with difficult, so the missing word is its opposite, easy: difficult ↔ easy. Heavy, loud and tall are real adjectives, but none is the opposite of difficult, so they break the contrast the sentence sets up.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a62ac825-e95d-594f-9f73-339f0f152530', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — First conditional: "If you press this green button, the machine ___ immediately."', '[{"id":"a","text":"started"},{"id":"b","text":"would start"},{"id":"c","text":"will start"},{"id":"d","text":"starting"}]'::jsonb, 'c', 'This is a real, possible result, so the first conditional uses will + base verb: the machine will start. "would start" is the imaginary second conditional, "started" is the past simple, and "starting" is not a finite verb form here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('576113c2-8990-5f99-8920-7dfe0f5e9798', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Reading — Read: "Leila has visited many countries, but she has never been to Japan. Next spring, she is finally going there for two weeks."
Which country has Leila NOT visited yet?', '[{"id":"a","text":"Japan."},{"id":"b","text":"Italy."},{"id":"c","text":"Every country."},{"id":"d","text":"None — she has visited them all."}]'::jsonb, 'a', 'The text says she "has never been to Japan", so Japan is the one she hasn''t visited yet (a). She has visited many countries, just not Japan, so "every country" (c) and "all of them" (d) are wrong, and Italy (b) is never mentioned.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c22de34c-acaa-595e-9f69-c6713c808e55', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Spelling — Choose the correct past participle: "She has ___ three letters to the company this week."', '[{"id":"a","text":"wrote"},{"id":"b","text":"written"},{"id":"c","text":"writed"},{"id":"d","text":"writing"}]'::jsonb, 'b', 'write is irregular: write → wrote (past) → written (participle). After has we use the participle: She has written three letters. "wrote" is the past simple, "writed" is not a word, and "writing" is the -ing form, which needs a form of be.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dfcb72a-70dc-5609-ac68-aae097b099ae', 'fb91ba61-d6f5-5e82-89d4-e4ad9b7f55c5', 'Grammar — Relative clause: "That''s the cafe ___ owner makes the best coffee in town."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'd', 'whose shows possession — it replaces its here (its owner): the cafe whose owner makes the best coffee. "who" is for a person doing the action, "which" would need a verb after it (the cafe which sells coffee), and "where" marks a place inside the clause, not an owner.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '⚔️ Gauntlet B1 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('3a53c0d6-d02d-5abd-929d-8c13cae3d02a', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Present perfect vs past simple: "We ___ this film two days ago, so let''s watch something else."', '[{"id":"a","text":"have watched"},{"id":"b","text":"watched"},{"id":"c","text":"have watch"},{"id":"d","text":"has watched"}]'::jsonb, 'b', '"two days ago" is a finished time, so we use the past simple: We watched this film two days ago. The present perfect can''t take a finished-time marker (so "have watched" is wrong), "have watch" lacks the participle, and "has watched" is the wrong subject form for we.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e275588a-04c6-5945-bcaa-e30fad0bdc2b', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"If you don''t water plants, they die."},{"id":"b","text":"She was reading when the lights went out."},{"id":"c","text":"You should call the doctor tomorrow."},{"id":"d","text":"If I will see her, I''ll give her the message."}]'::jsonb, 'd', 'The error is (d): never put will in the if-clause — it should be If I see her, I''ll give her the message. (a) is a correct zero conditional, (b) correctly interrupts a past-continuous action with a past-simple event, and (c) is correct advice with should + base.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e80bebe-a948-5f60-addf-a7964150f11e', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Vocabulary — Complete the collocation: "Before you sign anything, you need to ___ an important decision."', '[{"id":"a","text":"do"},{"id":"b","text":"take"},{"id":"c","text":"make"},{"id":"d","text":"have"}]'::jsonb, 'c', 'In English we make a decision, not "do" or "have" one: you need to make an important decision. This is a fixed collocation — make goes with decision, plan and mistake, while do goes with homework or the housework.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98c98d95-8646-5a2b-9324-7971f72aa5db', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Reading — Read: "The ground outside is completely wet and there are puddles everywhere, but the sky is clear and bright now. People are closing their umbrellas."
What has just happened?', '[{"id":"a","text":"It has just rained."},{"id":"b","text":"It has been sunny all day."},{"id":"c","text":"There has been a sandstorm."},{"id":"d","text":"It has started to snow."}]'::jsonb, 'a', 'The clues — wet ground, puddles, a now-clear sky and people closing umbrellas — show it has just rained (a). "sunny all day" can''t explain the wet ground and umbrellas (b), and a sandstorm (c) or snow (d) don''t fit puddles and umbrellas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55463583-d0fb-5eb9-a775-b259094ec76b', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Grammar — Modals: "The test starts at exactly nine, so you ___ be late, or they won''t let you in."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"should"},{"id":"c","text":"don''t need to"},{"id":"d","text":"mustn''t"}]'::jsonb, 'd', 'Being late is not allowed (they won''t let you in), so we use mustn''t (prohibition): you mustn''t be late. The trap is "don''t have to"/"don''t need to", which mean it''s optional — but here lateness is forbidden, not a free choice, and "should" is only advice.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29d002ba-7118-5565-b210-9030f2648028', 'bda4321e-8e7f-5919-96d2-3f1cc7f1b0cd', 'Spelling — Choose the correct -ing form: "I''m always ___ where I put my keys."', '[{"id":"a","text":"forgeting"},{"id":"b","text":"forgettting"},{"id":"c","text":"forgetting"},{"id":"d","text":"forgetteing"}]'::jsonb, 'c', 'forget is stressed on the last syllable and ends in one vowel + one consonant, so the t doubles before -ing: forgetting. "forgeting" keeps only one t, "forgettting" has one too many, and "forgetteing" wrongly inserts an e.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('67c32e3b-7c05-5912-a9f2-012814f7a41f', '507347df-f038-5b3e-9f5a-2f5f94adaaae', 'anglais-donjon', '👑 Gauntlet B1 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('2cba1ba7-af16-5d87-b768-affe2783e7bf', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Reading — Read: "Omar has played the guitar since he was ten. He has given many concerts, but he has never recorded an album. This year, he is saving money to make his first one."
Which sentence is TRUE?', '[{"id":"a","text":"Omar started playing the guitar as a child."},{"id":"b","text":"Omar has already recorded several albums."},{"id":"c","text":"Omar has never performed in public."},{"id":"d","text":"Omar gave up the guitar this year."}]'::jsonb, 'a', '"since he was ten" means he began as a child, so (a) is true. He has never recorded an album (b is false), he has given many concerts, so he has performed (c is false), and he is saving to make an album, not giving up (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68fc82c4-b675-5ddc-8326-7952e13a2a19', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"The book which I borrowed was fascinating."},{"id":"b","text":"If I had more time, I would learn to paint."},{"id":"c","text":"I have seen that play last weekend."},{"id":"d","text":"They were arguing when the teacher walked in."}]'::jsonb, 'c', 'The error is (c): "last weekend" is a finished time, so it needs the past simple — I saw that play last weekend, not "have seen". (a) uses which correctly for a thing, (b) is a correct second conditional, and (d) correctly interrupts a long past action with a short one.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19af87e0-dcf5-58b5-9861-544a725d24c9', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Second conditional: "If I ___ better at maths, I would help you with this problem."', '[{"id":"a","text":"will be"},{"id":"b","text":"am"},{"id":"c","text":"would be"},{"id":"d","text":"were"}]'::jsonb, 'd', 'The result "would help" signals the imaginary second conditional, so the if-clause uses the past simple, and with the verb be we use were for every subject: If I were better at maths… "am" is the present, while "will be" and "would be" wrongly put a modal inside the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34eb0159-aead-52e8-a7b3-1b9273d5b564', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Spelling — Find the INCORRECT word.', '[{"id":"a","text":"better"},{"id":"b","text":"gooder"},{"id":"c","text":"worse"},{"id":"d","text":"further"}]'::jsonb, 'b', 'The error is (b): good is irregular, so its comparative is better, not "gooder". The other three are correct comparatives — bad → worse, far → further (and well → better) — irregular forms you must learn by heart.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('137d7a75-f95b-566a-bd55-779e463fd7ce', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Grammar — Relative clauses: "The journalist ___ wrote the article interviewed a scientist ___ research could change medicine."', '[{"id":"a","text":"which … who"},{"id":"b","text":"who … whose"},{"id":"c","text":"whose … which"},{"id":"d","text":"where … whose"}]'::jsonb, 'b', 'The journalist is a person doing the action (who wrote), and the scientist owns the research (whose research). So: who … whose. The other pairs mismatch — a person doing an action is never "which/where/whose" here, and "research" belongs to the scientist, which needs whose, not which.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddd14b29-f733-5239-bafb-9b71636483f5', '67c32e3b-7c05-5912-a9f2-012814f7a41f', 'Vocabulary — Choose the word that best completes the sentence: "He spoke so ___ that nobody at the back could hear him."', '[{"id":"a","text":"quietly"},{"id":"b","text":"clearly"},{"id":"c","text":"loudly"},{"id":"d","text":"quickly"}]'::jsonb, 'a', 'If nobody at the back could hear him, he must have spoken quietly: he spoke so quietly that nobody could hear. "loudly" and "clearly" would make him easy to hear (the opposite), and "quickly" is about speed, not volume, so it doesn''t explain why they couldn''t hear.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('43936597-65e4-5161-bbea-4fdaa8d1d703', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'Grammar — Past perfect: "By the time the ambulance arrived, the doctors ___ already started treatment."', '[{"id":"a","text":"have"},{"id":"b","text":"were"},{"id":"c","text":"had"},{"id":"d","text":"did"}]'::jsonb, 'c', '"By the time" signals that one past action was completed before another, so we use the past perfect: the doctors had already started. "have" is present perfect (wrong tense), "were" would begin a continuous form (needs -ing), and "did" is the past simple auxiliary (no participle follows it).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40c35d08-9ad4-5316-b398-077e462b95e3', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'Grammar — Passive voice: "This road ___ every winter because of heavy snowfall."', '[{"id":"a","text":"closes"},{"id":"b","text":"is closed"},{"id":"c","text":"was closing"},{"id":"d","text":"had closed"}]'::jsonb, 'b', 'A habitual, recurring event using a passive (the road is the object of closing) takes is + past participle: is closed. "closes" is active — it implies the road acts. "was closing" is a past continuous (scene-setting, not habitual), and "had closed" is the past perfect (wrong time frame here).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4f1d3c1-2f7d-50bf-bf20-3f4aaf069204', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'Usage — Gerund or infinitive: "She always avoids ___ in crowded places."', '[{"id":"a","text":"to speak"},{"id":"b","text":"speaking"},{"id":"c","text":"speak"},{"id":"d","text":"spoke"}]'::jsonb, 'b', 'avoid is always followed by a gerund (-ing), never an infinitive: She avoids speaking. "to speak" (infinitive) is wrong after avoid — compare with want/decide which take the infinitive. "speak" is the bare infinitive (used only after modals and make/let/help), and "spoke" is the past simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d47d6aaf-b26f-5721-8346-fd44ce113bf0', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'Grammar — Reported speech: "Sara said, ''I will call you tonight.'' " What did Sara say?', '[{"id":"a","text":"Sara said she would call me that night."},{"id":"b","text":"Sara said she will call me tonight."},{"id":"c","text":"Sara said she called me that night."},{"id":"d","text":"Sara said I would call her tonight."}]'::jsonb, 'a', 'Reported speech back-shifts will → would and tonight → that night, and changes the pronoun you → me: she would call me that night. (b) keeps will and tonight — no back-shift. (c) uses the past simple instead of would. (d) swaps the subject and object (I would call her) — wrong perspective.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f6012bd-ab0b-5412-8717-7826520c4ebd', 'c5c5853e-fc0c-554b-ab3e-d5b33b00f9b2', 'Grammar — Third conditional: "If they ___ earlier, they wouldn''t have missed the train."', '[{"id":"a","text":"would leave"},{"id":"b","text":"left"},{"id":"c","text":"had left"},{"id":"d","text":"have left"}]'::jsonb, 'c', 'The third conditional expresses an impossible past: if-clause = had + participle, result = would have + participle. "If they had left earlier" is correct. "would leave" wrongly puts a modal in the if-clause, "left" is the second conditional (imaginary present/future), and "have left" is the present perfect (wrong auxiliary for a past impossible).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', '⭐ Gauntlet B2: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('8f80563e-de08-5915-99f5-a9d2e519b985', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Grammar — Past perfect: "When I got to the station, the train ___ already left."', '[{"id":"a","text":"had"},{"id":"b","text":"was"},{"id":"c","text":"has"},{"id":"d","text":"did"}]'::jsonb, 'a', '"When I got to the station" is the later past event, so the earlier event (the train leaving) takes the past perfect: the train had already left. "has" is present perfect (wrong tense), "was" would need an -ing form to make a past continuous, and "did" is the past-simple auxiliary for questions/negatives, not affirmatives.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('061a7ce2-dae2-5afc-b735-d75dc32d5d6b', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Grammar — Passive voice: "The new library ___ by a famous architect."', '[{"id":"a","text":"designed"},{"id":"b","text":"was designed"},{"id":"c","text":"has design"},{"id":"d","text":"is designing"}]'::jsonb, 'b', 'The library is the receiver of the action, so a passive is required: was designed (past tense of be + participle). "designed" alone is an active past simple (the library can''t design anything). "has design" is not a correct tense (participle must be designed), and "is designing" is active present continuous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96065198-c631-5940-85da-ffa687264b9e', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Vocabulary — Choose the correct collocation: "The scientists decided to ___ further research into the disease."', '[{"id":"a","text":"make"},{"id":"b","text":"do"},{"id":"c","text":"run"},{"id":"d","text":"carry out"}]'::jsonb, 'd', 'At B2, the precise collocation is carry out research (or conduct research). "do research" is also acceptable in informal English, but "carry out" is the formal fixed expression tested here. "make research" is a false-friend calque (common non-native error), and "run research" is not standard English.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66fd19f4-8376-5dfa-bad1-992fa439fc40', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Grammar — Reported speech: "He said, ''I can swim very well.'' " What did he say?', '[{"id":"a","text":"He said he can swim very well."},{"id":"b","text":"He said he swam very well."},{"id":"c","text":"He said he could swim very well."},{"id":"d","text":"He said he will swim very well."}]'::jsonb, 'c', 'In reported speech, the modal can back-shifts to could: he said he could swim very well. (a) keeps can without back-shifting — only possible in informal immediate reporting. (b) uses the past simple swam, which changes the meaning. (d) uses will, which is not a back-shift of can.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efe56cc8-bfa9-5f97-b30c-0d1f519a8965', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Usage — Gerund or infinitive: "I hope ___ you at the conference next week."', '[{"id":"a","text":"to see"},{"id":"b","text":"see"},{"id":"c","text":"saw"},{"id":"d","text":"seeing"}]'::jsonb, 'a', 'hope is always followed by the infinitive: I hope to see you. Contrast this with enjoy, which takes -ing (I enjoy seeing you). "see" (bare infinitive) comes after modals, not after hope. "saw" is the past simple — no tense marker is needed here since hope already carries the time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cf596d7-fc1f-5778-85bd-07e8777f7191', '7fa9d06c-0246-534e-bfaf-cc643eefad4e', 'Spelling — Choose the correct past participle: "A solution to the water crisis has finally been ___."', '[{"id":"a","text":"founded"},{"id":"b","text":"find"},{"id":"c","text":"finded"},{"id":"d","text":"found"}]'::jsonb, 'd', 'find is irregular: find → found (past & participle). In the present-perfect passive (has been + participle) the form is found. "founded" means to establish an organisation — a different verb (he founded the company). "find" is the base form, and "finded" does not exist.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', '⭐⭐ Gauntlet B2: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('58c62e68-be83-5db1-b43d-aa97cfec9afe', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Grammar — Passive voice: "The winning essay ___ by the committee next Friday."', '[{"id":"a","text":"announces"},{"id":"b","text":"will be announced"},{"id":"c","text":"is announcing"},{"id":"d","text":"was announced"}]'::jsonb, 'b', '"Next Friday" points to the future and the essay (not the committee) is the grammatical subject, so we need the future passive: will be announced. "announces" is active present. "is announcing" is an active present continuous (the essay can''t announce itself). "was announced" is past — wrong time frame.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a637546-9bd4-5c35-a718-7b955a19b6f1', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Grammar — Third conditional: "If she had known about the meeting, she ___ on time."', '[{"id":"a","text":"would have arrived"},{"id":"b","text":"would arrive"},{"id":"c","text":"had arrived"},{"id":"d","text":"arrives"}]'::jsonb, 'a', 'The if-clause has had known (past perfect), so the result clause requires would have + participle: she would have arrived. "would arrive" is the second conditional result (imaginary present/future). "had arrived" would make a second if-clause, not a result. "arrives" is the zero conditional (fact), which doesn''t fit an impossible past.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('218b7f9f-f636-5b7d-be05-18220a4784d2', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Vocabulary — Choose the best word: "After hours of debate, the two sides finally reached an ___."', '[{"id":"a","text":"argument"},{"id":"b","text":"arrival"},{"id":"c","text":"appointment"},{"id":"d","text":"agreement"}]'::jsonb, 'd', 'You reach an agreement when two parties settle on a shared position after debate: a classic B2 collocation. An argument is the debate itself (the opposite of resolution). An arrival is a physical coming-somewhere event. An appointment is a scheduled meeting — not a consensus outcome.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f0c051a-642c-5264-88af-f04bca87d0b5', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Grammar — Gerunds & infinitives: "Would you mind ___ the window? It''s very cold."', '[{"id":"a","text":"to close"},{"id":"b","text":"close"},{"id":"c","text":"closing"},{"id":"d","text":"closed"}]'::jsonb, 'c', 'mind is always followed by a gerund (-ing): Would you mind closing…? "to close" (infinitive) is wrong after mind — compare with would like, which takes the infinitive. "close" (bare infinitive) follows modals, not mind. "closed" is the past participle and has no function here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d479b673-788d-5819-b88e-0e8896c4736f', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Grammar — Past perfect: "She realised she ___ her passport at home when she reached the check-in desk."', '[{"id":"a","text":"left"},{"id":"b","text":"has left"},{"id":"c","text":"was leaving"},{"id":"d","text":"had left"}]'::jsonb, 'd', 'She realised (past simple) = the later event. The leaving happened before that, so it needs the past perfect: she had left her passport at home. "left" (past simple) implies the two events happened at the same time, blurring the sequence. "has left" is present perfect — wrong in a past narrative. "was leaving" is past continuous, which sets a background scene, not a completed prior action.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3fc0bee-724e-589e-b31f-1e4ff9d278f2', '18cc4bc2-8094-5236-a1b0-99758da1ad6d', 'Spelling — Choose the correctly spelled word: "The company''s profits have ___ dramatically this quarter."', '[{"id":"a","text":"rised"},{"id":"b","text":"risen"},{"id":"c","text":"rose"},{"id":"d","text":"arisen"}]'::jsonb, 'b', 'rise is irregular: rise → rose (past simple) → risen (past participle). After have we need the participle: have risen. "rised" is not a word (rise is irregular, no -d ending). "rose" is the past simple, which doesn''t follow have. "arisen" is the participle of arise (a different verb — difficulties arise, not profits).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', '⚔️ Gauntlet B2 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('459297c1-497d-5a68-8a3a-afe081d74fdb', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Grammar — Mixed conditional: "If he had taken better care of his health, he ___ in hospital now."', '[{"id":"a","text":"wouldn''t be"},{"id":"b","text":"wouldn''t have been"},{"id":"c","text":"wouldn''t be having"},{"id":"d","text":"hadn''t been"}]'::jsonb, 'a', 'A mixed conditional pairs a past if-clause (had taken — past perfect) with a present result: he wouldn''t be in hospital now. "wouldn''t have been" is the pure third conditional result (past result, not present). "wouldn''t be having" adds an unnecessary continuous aspect. "hadn''t been" is another if-clause construction, not a result clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26ca6096-54f6-51ba-9721-18c900070c90', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Grammar — Reported speech: "The doctor warned, ''You must not eat salt.'' " What did the doctor say?', '[{"id":"a","text":"The doctor warned he must not eat salt."},{"id":"b","text":"The doctor warned me I would not eat salt."},{"id":"c","text":"The doctor warned that I not eat salt."},{"id":"d","text":"The doctor warned me not to eat salt."}]'::jsonb, 'd', 'warn + object + not to-infinitive is the standard reported-speech structure for a prohibition: warned me not to eat salt. (a) omits the object and doesn''t back-shift the modal properly. (b) uses would, changing the meaning from prohibition to prediction. (c) uses the bare subjunctive-style infinitive after that — grammatical in American English but not the standard form for reported warnings in British English.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73c614ba-cf10-550a-99b1-8505762d57ae', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Usage — Gerunds & infinitives: "I remember ___ the front door when I left — so why is it open?"', '[{"id":"a","text":"to lock"},{"id":"b","text":"lock"},{"id":"c","text":"locking"},{"id":"d","text":"locked"}]'::jsonb, 'c', 'remember + -ing refers to a memory of a past action (I recall doing it): I remember locking the door. remember + to-infinitive means ''not to forget to do it in the future'' — a completely different meaning. "lock" (bare infinitive) needs a modal. "locked" is the past participle (no auxiliary present).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f186bc8-5d7d-5d08-a175-4e6914ebc0b0', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Grammar — Passive voice: "More than a million trees ___ by the charity since 2010."', '[{"id":"a","text":"have been planted"},{"id":"b","text":"have planted"},{"id":"c","text":"are planted"},{"id":"d","text":"were planted"}]'::jsonb, 'a', '"Since 2010" triggers the present perfect, and the trees are the receiver of planting, so the present-perfect passive is required: have been planted. "are planted" is a present simple passive (habitual, no time span). "have planted" is active (trees don''t plant themselves). "were planted" is a past simple passive — past simple can''t be used with since in this continuous-up-to-now sense.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f12804d-c4c8-52f2-b3f9-4c812bae78cd', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Vocabulary — Find the INCORRECT collocation: which phrase does NOT exist in standard English?', '[{"id":"a","text":"draw a conclusion"},{"id":"b","text":"raise awareness"},{"id":"c","text":"do a decision"},{"id":"d","text":"carry out an investigation"}]'::jsonb, 'c', 'The error is (c): in English we make a decision, never "do a decision" — this is a false-friend calque. (a) draw a conclusion is correct (you draw logical conclusions from evidence). (b) raise awareness is a standard B2 collocation. (d) carry out an investigation is the fixed formal phrase.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50c08489-c44f-5d98-90f5-caf947839450', '5585aae9-bf9d-5163-88db-ebc5967f5c1d', 'Grammar — Find the INCORRECT sentence.', '[{"id":"a","text":"She admitted stealing the money."},{"id":"b","text":"They suggested to go to the cinema."},{"id":"c","text":"He managed to finish the report on time."},{"id":"d","text":"We decided to leave early."}]'::jsonb, 'b', 'The error is (b): suggest is followed by a gerund, not an infinitive — They suggested going to the cinema. (a) is correct: admit + -ing (She admitted stealing). (c) is correct: manage + to-infinitive (He managed to finish). (d) is correct: decide + to-infinitive (We decided to leave).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9236c621-0487-5754-a561-61b796380f43', 'f629892b-b08a-55bb-941c-20d478b84cbe', 'anglais-donjon', '👑 Gauntlet B2 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a87acbf0-8928-57c3-85a6-d725b7461995', '9236c621-0487-5754-a561-61b796380f43', 'Grammar — Past perfect: "Read: ''The team celebrated because they ___ won the championship for the first time in twenty years.'' " Which form is correct?', '[{"id":"a","text":"just have"},{"id":"b","text":"just had to"},{"id":"c","text":"have just"},{"id":"d","text":"had just"}]'::jsonb, 'd', 'The celebration (past simple) is the later event; winning happened just before it, so the past perfect is required. The adverb just slots between had and the participle: had just won. "just have" and "have just" are present-perfect forms (wrong tense in a past narrative). "just had to" means they were obliged to, which changes the meaning entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('214a674e-4334-5cec-99e9-d1a920a4bdf7', '9236c621-0487-5754-a561-61b796380f43', 'Grammar — Mixed conditional: "If I ___ born in France, I ___ French now."', '[{"id":"a","text":"was … would speak"},{"id":"b","text":"had been … would speak"},{"id":"c","text":"had been … would have spoken"},{"id":"d","text":"was … would have spoken"}]'::jsonb, 'b', 'A mixed conditional: the past cause (birth) uses had been (past perfect), and the present result uses would speak (not would have spoken — that would be a pure third conditional with a past result). (a) was … would speak is the second conditional (imaginary present, not a birth). (c) had been … would have spoken is a pure third conditional (past result). (d) was … would have spoken mixes the wrong forms.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44b76531-fa9e-5dec-b8b7-559d1ab35c1c', '9236c621-0487-5754-a561-61b796380f43', 'Grammar — Reported speech: "The manager told us, ''The meeting will be rescheduled.'' " What did she tell us?', '[{"id":"a","text":"The manager told us the meeting will be rescheduled."},{"id":"b","text":"The manager told us the meeting would have been rescheduled."},{"id":"c","text":"The manager told us the meeting had been rescheduled."},{"id":"d","text":"The manager told us the meeting would be rescheduled."}]'::jsonb, 'd', 'Reported speech back-shifts will → would and keeps the passive (will be → would be): the meeting would be rescheduled. (a) keeps will — valid only in informal immediate speech (same day), but the standard back-shift is required here. (b) would have been rescheduled is the third-conditional result form — a different meaning (now impossible). (c) had been rescheduled implies it had already happened — no back-shift from a prediction.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6abb857b-0666-58e4-b710-737045621ccd', '9236c621-0487-5754-a561-61b796380f43', 'Usage — Gerunds & infinitives: "Try as they might, the engineers couldn''t stop the leak. They tried ___ a new sealant, but it didn''t work either."', '[{"id":"a","text":"to use"},{"id":"b","text":"used"},{"id":"c","text":"using"},{"id":"d","text":"use"}]'::jsonb, 'c', 'try + -ing means ''experiment with an action to see if it helps'': they tried using a new sealant (and it didn''t work). try + to-infinitive means ''make an effort to do something'' — here the engineers aren''t effortfully attempting to use it; they''re experimenting with it. This is the classic meaning-change pair. "used" is the past simple, and "use" is the bare infinitive (requires a modal).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f2c7d19-d9fb-5d46-91cd-46a2d0ac41be', '9236c621-0487-5754-a561-61b796380f43', 'Vocabulary — Choose the sentence that uses the word CORRECTLY.', '[{"id":"a","text":"She succeeded to pass the exam."},{"id":"b","text":"She succeeded in passing the exam."},{"id":"c","text":"She succeeded at passing the exam."},{"id":"d","text":"She succeeded passing the exam."}]'::jsonb, 'b', 'succeed is followed by in + gerund: she succeeded in passing. (a) succeed + to-infinitive is a very common B2 error (calque from French/Arabic). (c) at is the preposition for good at something, not for succeed. (d) omits the preposition entirely — succeed cannot directly precede an -ing form without in.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12cd05c0-60ba-557e-b4e8-8669f251d80d', '9236c621-0487-5754-a561-61b796380f43', 'Grammar — Passive + past perfect combined: "The letter ___ long before we asked for a copy."', '[{"id":"a","text":"has been destroyed"},{"id":"b","text":"was destroyed"},{"id":"c","text":"had been destroyed"},{"id":"d","text":"would be destroyed"}]'::jsonb, 'c', 'We need a passive that places destruction before another past action (we asked). That is the past-perfect passive: had been destroyed. "has been destroyed" is present perfect passive (wrong tense — no link to a later past action). "was destroyed" is past simple passive (makes it simultaneous with asking, losing the prior-to relationship). "would be destroyed" is a conditional form, which doesn''t fit a factual statement.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e804fdf7-a259-5a4a-a191-83cb552235d9', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('abb1ceea-b9ca-5363-b267-632efd57b29b', 'e804fdf7-a259-5a4a-a191-83cb552235d9', 'Grammar — Inversion: "___ had the concert begun when it started to rain."', '[{"id":"a","text":"Rarely"},{"id":"b","text":"No sooner"},{"id":"c","text":"Never"},{"id":"d","text":"Only then"}]'::jsonb, 'b', 'No sooner … than is the fixed correlative pair for two rapid successive events: No sooner had the concert begun than it started to rain. "Rarely/Never + had" would need an adverbial of frequency, not the than-clause that follows. "Only then" triggers inversion but is followed by a new main clause, not a than-clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18d554dd-1906-5417-bb26-0d807b53a7ab', 'e804fdf7-a259-5a4a-a191-83cb552235d9', 'Grammar — Cleft sentence: "___ annoyed me most was the constant noise."', '[{"id":"a","text":"It"},{"id":"b","text":"That"},{"id":"c","text":"What"},{"id":"d","text":"Which"}]'::jsonb, 'c', 'A wh-cleft (pseudo-cleft) begins with What + clause + be + highlighted element: What annoyed me most was the constant noise. "It" begins an it-cleft, but then the verb must be: It was the noise that annoyed me (wrong word order here). "That" and "Which" are relative pronouns that cannot open a subject-cleft.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('caeaae61-668d-5672-98d3-6a675f9fdec0', 'e804fdf7-a259-5a4a-a191-83cb552235d9', 'Grammar — Modal of deduction: "The lights are off and the car is gone. They ___ home."', '[{"id":"a","text":"must go"},{"id":"b","text":"should go"},{"id":"c","text":"must be"},{"id":"d","text":"could be going"}]'::jsonb, 'c', 'The evidence (lights off, car gone) makes us near-certain: they must be home (logical deduction). "must go" is an obligation (they are obliged to go), not a deduction. "should go" is advice or a weaker expectation. "could be going" expresses possibility but less certainty than the evidence warrants.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e060da7-4d12-5ed2-b978-df88963198ac', 'e804fdf7-a259-5a4a-a191-83cb552235d9', 'Grammar — Participle clause: "___ the application form, she submitted it online."', '[{"id":"a","text":"Complete"},{"id":"b","text":"Having completed"},{"id":"c","text":"She completed"},{"id":"d","text":"Being completed"}]'::jsonb, 'b', 'A participle clause replacing a prior action (she completed it, then submitted it) uses having + past participle: Having completed the form, she submitted it. "Complete" is the bare form (needs a subject and tense). "She completed" is a full clause (would need a conjunction like after). "Being completed" is a passive participle — the form is not completing the form by itself.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8d6e3bb-7b01-540c-9033-36118b54905f', 'e804fdf7-a259-5a4a-a191-83cb552235d9', 'Usage — Discourse markers: "The plan was expensive; ___, it was approved by the board."', '[{"id":"a","text":"nevertheless"},{"id":"b","text":"therefore"},{"id":"c","text":"furthermore"},{"id":"d","text":"as a result"}]'::jsonb, 'a', 'The two facts contrast (expensive BUT approved), so a concessive connector is needed: nevertheless (= despite that). "therefore" and "as a result" show consequence — they would imply it was approved because it was expensive, which reverses the logical surprise. "furthermore" adds a further point, but there is no addition here — there is a contrast.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7af5f338-d403-5b26-8b39-0b0bbcfd1464', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', '⭐ Gauntlet C1: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('2e45c011-851f-5830-b174-e26e6806c292', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Grammar — Inversion: "Never ___ such a beautiful sunset."', '[{"id":"a","text":"I have seen"},{"id":"b","text":"I saw"},{"id":"c","text":"have I seen"},{"id":"d","text":"I had seen"}]'::jsonb, 'c', 'When a negative adverb like Never fronts a sentence, the subject and auxiliary invert (like a question): Never have I seen…. "I have seen" is normal SVO order — no inversion. "I saw" is past simple with no inversion. "I had seen" is also non-inverted. The pattern is Never + auxiliary + subject + main verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e10669b7-1bca-553f-adc2-a26b45cd6f24', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Grammar — Cleft sentence: "It was the president ___ announced the new policy."', '[{"id":"a","text":"which"},{"id":"b","text":"who"},{"id":"c","text":"what"},{"id":"d","text":"whom"}]'::jsonb, 'b', 'An it-cleft highlighting a person uses who: It was the president who announced the policy. "which" is for things. "what" opens a wh-cleft (What I need is…) — it cannot follow it was with a noun. "whom" is the object form and cannot be used when the highlighted noun is the subject of the relative clause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5591f64-e973-5269-ab27-8c42bf6102af', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Grammar — Modal of deduction (past): "She''s wet from head to toe. She ___ caught in the storm."', '[{"id":"a","text":"could be"},{"id":"b","text":"must be"},{"id":"c","text":"should have been"},{"id":"d","text":"must have been"}]'::jsonb, 'd', 'We are deducing a past event (she got wet earlier) from present evidence (she is wet now). Past deduction = must have been + participle: She must have been caught in the storm. "must be" deduces a present state, but "caught" is a past participle — the event was past, not ongoing. "should have been" implies she was supposed to be caught (obligation in the past), which makes no sense. "could be" is a present possibility.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0439be1b-3d26-5bab-8827-e7cf2b78ff64', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Vocabulary — Choose the correct discourse marker: "The results were promising. ___, further testing is needed before we draw conclusions."', '[{"id":"a","text":"Nevertheless"},{"id":"b","text":"Moreover"},{"id":"c","text":"Therefore"},{"id":"d","text":"Namely"}]'::jsonb, 'a', 'Promising results but further testing is needed — this is a concession (despite the good results, we still need more testing). Nevertheless signals this contrast. "Moreover" adds a further positive point. "Therefore" signals a logical result (which would mean the results cause the need for testing, losing the contrast). "Namely" introduces a list or specification.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31384070-726b-5aee-84e6-67ff77f04cf3', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Grammar — Participle clause: "___ by the unexpected news, the shareholders demanded an emergency meeting."', '[{"id":"a","text":"Having shock"},{"id":"b","text":"Shocking"},{"id":"c","text":"Being shock"},{"id":"d","text":"Shocked"}]'::jsonb, 'd', 'The shareholders received the action of the news (they were shocked), so the passive past participle is needed: Shocked by the unexpected news…. "Shocking" would be an active -ing participle — it would mean the shareholders were the ones doing the shocking. "Having shock" incorrectly uses the noun shock instead of the participle shocked. "Being shock" also uses the noun and is not grammatical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5aa63085-11ec-5d37-a048-3ab6043e7e5e', '7af5f338-d403-5b26-8b39-0b0bbcfd1464', 'Spelling — Choose the correctly spelled word that fills the gap: "His sudden disappearance was an extremely puzzling ___."', '[{"id":"a","text":"ocurrence"},{"id":"b","text":"occurence"},{"id":"c","text":"occurrence"},{"id":"d","text":"occurrance"}]'::jsonb, 'c', 'occurrence doubles both the c and the r: oc-cur-rence. The root is occur (double-r when the stress is on the final syllable before a vowel suffix), and -ence is the standard noun ending. "ocurrence" omits one c; "occurence" omits one r; "occurrance" uses the wrong suffix -rance.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9cd3f810-608d-5b15-ae69-5ad4eab40d29', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', '⭐⭐ Gauntlet C1: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('84f50bf6-1826-5eb5-ac6d-df3f7cf1c351', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Grammar — Inversion: "Not only ___ late, but she also forgot to bring her notes."', '[{"id":"a","text":"she arrived"},{"id":"b","text":"she did arrive"},{"id":"c","text":"did she arrive"},{"id":"d","text":"arrived she"}]'::jsonb, 'c', 'Not only triggers subject-auxiliary inversion: Not only did she arrive late…. In the past simple without a be-verb, the auxiliary do/did carries the inversion: did she arrive. "she arrived" is uninverted (wrong). "she did arrive" is emphatic but not inverted. "arrived she" inverts the main verb, not the auxiliary — that is only correct with be (Were she to…).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e809a94-2ac1-57da-afb0-2e98b38b905a', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Grammar — Cleft sentence: "___ I really need ___ a long holiday."', '[{"id":"a","text":"It … is"},{"id":"b","text":"What … is"},{"id":"c","text":"That … is"},{"id":"d","text":"Which … is"}]'::jsonb, 'b', 'A wh-cleft (pseudo-cleft) highlights the element that follows is: What I really need is a long holiday. The structure is What + subject + verb + is + highlighted noun phrase. "It…is" would need: It is a long holiday that I really need (it-cleft — different word order). "That…is" cannot open a subject cleft. "Which…is" is a relative clause, not a cleft.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce3e5517-73a3-5793-9be1-d7c8a3f2d634', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Grammar — Participle clause: "___ all the evidence, the detective concluded it was an accident."', '[{"id":"a","text":"Considered"},{"id":"b","text":"Being considered"},{"id":"c","text":"Consider"},{"id":"d","text":"Having considered"}]'::jsonb, 'd', 'The detective considered the evidence (active, completed before concluding), so having + past participle is needed: Having considered all the evidence. "Considered" alone would make it passive (the evidence was considered by someone else). "Being considered" is an ongoing passive participle. "Consider" is the bare infinitive (no subject, no tense — not a valid clause opener here).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d79f708-bab7-5a8a-96d2-48f6ecbbfa94', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Grammar — Modal of deduction: "No one answered the door and the windows were dark. They ___ out for the evening."', '[{"id":"a","text":"can''t be"},{"id":"b","text":"must have gone"},{"id":"c","text":"should have been"},{"id":"d","text":"could go"}]'::jsonb, 'b', 'We are deducing a past action (they went out earlier) from current evidence (no answer, dark windows): must have gone (near-certain past deduction). "can''t be" deduces a present state (they can''t be here) — but the question concerns the past action of going out. "should have been" implies an obligation in the past. "could go" is ability or permission, not deduction.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66337dfa-73a1-5c4e-965e-cc2a2f36492c', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Vocabulary — Choose the most precise C1 collocation: "The two theories ___ a remarkable resemblance to each other."', '[{"id":"a","text":"bear"},{"id":"b","text":"make"},{"id":"c","text":"carry"},{"id":"d","text":"have"}]'::jsonb, 'a', 'The fixed C1 collocation is bear a resemblance: the theories bear a remarkable resemblance to each other. While "have a resemblance" is used informally, it is not the precise idiomatic collocation. "make" and "carry" are never used with resemblance in standard English.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1bad442-44eb-5c6e-8d5f-963113dddd85', '9cd3f810-608d-5b15-ae69-5ad4eab40d29', 'Usage — Discourse marker: "The government pledged to reduce emissions. ___, the following year it approved three new coal plants."', '[{"id":"a","text":"Consequently"},{"id":"b","text":"Furthermore"},{"id":"c","text":"Nonetheless"},{"id":"d","text":"As a result"}]'::jsonb, 'c', 'Pledging to reduce emissions and then approving coal plants is a contradiction — a concession: Nonetheless (= in spite of the pledge). "Consequently" and "as a result" signal a logical effect — approving coal plants would then be the result of the pledge (illogical). "Furthermore" adds a supporting point, but there is a contradiction here, not an addition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('880450ab-ecbb-5865-847c-ee1d96697d9b', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', '⚔️ Gauntlet C1 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('afb5e1d9-b7da-5598-abca-31493a3b7598', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Grammar — Inversion: "Rarely ___ a policy that satisfied everyone."', '[{"id":"a","text":"the committee introduced"},{"id":"b","text":"has the committee introduced"},{"id":"c","text":"the committee has introduced"},{"id":"d","text":"did the committee introduced"}]'::jsonb, 'b', 'Rarely triggers inversion with the present perfect (no finished time given): Rarely has the committee introduced…. (a) has no inversion. (c) also has no inversion. (d) wrongly uses did with has introduced — you can''t use do-support with a present perfect; and "introduced" after did should be the base form introduce, making (d) doubly wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b353e5eb-73c1-5592-88e1-caf495753a57', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Grammar — Modal of deduction (past): "She answered every question immediately. She ___ the topic very well."', '[{"id":"a","text":"can''t have known"},{"id":"b","text":"might not have known"},{"id":"c","text":"should have known"},{"id":"d","text":"must have known"}]'::jsonb, 'd', 'Answering every question immediately is strong evidence of knowledge, so near-certain past deduction: must have known. "can''t have known" is the negative certainty (she definitely didn''t know) — but the evidence is the opposite. "might not have known" is uncertain possibility, too weak for the evidence. "should have known" implies an obligation or expectation, not a deduction from evidence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a0ddfd2-ce9f-5927-ba29-7b54c16a5f97', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Vocabulary — Near-synonym precision: "The new regulation ___ restaurants to display calorie information."', '[{"id":"a","text":"lets"},{"id":"b","text":"requires"},{"id":"c","text":"allows"},{"id":"d","text":"enables"}]'::jsonb, 'b', 'A regulation that mandates something requires compliance: the regulation requires restaurants to display… "allows" and "lets" both give permission (optional) — a regulation doesn''t merely permit, it compels. "enables" means to make something possible, not to make it obligatory. This is a classic C1 near-synonym trap.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('836d9887-fa08-5c69-8c86-4cb252f69203', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Grammar — Cleft sentence: "Find the correctly formed cleft."', '[{"id":"a","text":"It was in 1969 when the moon landing happened."},{"id":"b","text":"It is the economy what voters care about most."},{"id":"c","text":"What the refugees needed was immediate shelter."},{"id":"d","text":"What was the team celebrated was their victory."}]'::jsonb, 'c', 'What the refugees needed was immediate shelter is a correctly formed wh-cleft: What + subject + verb + was + highlight. (a) uses when instead of that for an it-cleft: correct form is It was in 1969 that… (b) uses what instead of that after the it-cleft: it should be It is the economy that voters care about. (d) inserts was where was is not needed: What the team celebrated was their victory.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15ef63c3-7c2c-5325-977a-74c26087bcfa', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Grammar — Participle clause: "Choose the sentence with a CORRECT participle clause."', '[{"id":"a","text":"Walking to work, his umbrella broke."},{"id":"b","text":"Having read the report, the meeting began."},{"id":"c","text":"Exhausted by the journey, she fell asleep immediately."},{"id":"d","text":"Looking out the window, the rain was heavy."}]'::jsonb, 'c', 'In (c), the subject of both clauses is she (she was exhausted, she fell asleep): Exhausted by the journey, she fell asleep immediately — correct passive participle clause. (a) is a dangling participle: his umbrella cannot be walking. (b) is a dangling participle: the meeting didn''t read the report. (d) is dangling: the rain wasn''t looking out the window.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffbe251b-c81d-5b72-b1fe-6f9d4f3d2762', '880450ab-ecbb-5865-847c-ee1d96697d9b', 'Usage — Discourse markers: "The evidence strongly suggested fraud. ___ no charges were ever brought against the company."', '[{"id":"a","text":"However,"},{"id":"b","text":"Therefore,"},{"id":"c","text":"Moreover,"},{"id":"d","text":"Hence,"}]'::jsonb, 'a', 'Evidence of fraud but no charges is a contradiction — a concessive link is needed: However (= in spite of the evidence). "Therefore" and "Hence" both signal a logical result — they would imply the evidence caused the charges not to be brought (illogical without further explanation). "Moreover" adds a further point in the same direction, but there is a clear contrast here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('91d20544-8a7f-5848-acff-4a219e376de0', '3e0b8e96-0c3d-53d7-b446-e73fc85da180', 'anglais-donjon', '👑 Gauntlet C1 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8e456fc0-4fff-5f22-a286-f8f43f934e63', '91d20544-8a7f-5848-acff-4a219e376de0', 'Grammar — Cleft sentence: "Rewrite — ''The deadline caused the most stress.'' — as a correct it-cleft."', '[{"id":"a","text":"It was the deadline who caused the most stress."},{"id":"b","text":"It was the deadline that caused the most stress."},{"id":"c","text":"It was the deadline which it caused the most stress."},{"id":"d","text":"It was the deadline what caused the most stress."}]'::jsonb, 'b', 'An it-cleft highlighting a thing uses that (or which): It was the deadline that caused the most stress. (a) uses who — only for people. (c) adds a redundant it after which, making a grammatical error. (d) uses what — what is used to open wh-clefts (What caused stress was the deadline), not as a relative in an it-cleft.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb9982f3-8c43-5490-b299-4baf57f659cd', '91d20544-8a7f-5848-acff-4a219e376de0', 'Grammar — Inversion: "Under no circumstances ___ leave the building during the alarm."', '[{"id":"a","text":"students should"},{"id":"b","text":"should students"},{"id":"c","text":"students must"},{"id":"d","text":"must students not"}]'::jsonb, 'b', 'Under no circumstances is a negative restrictive phrase that forces subject-auxiliary inversion: Under no circumstances should students leave…. Note: the negation is already in the fronted phrase, so mustn''t or not is not added again. (a) has no inversion. (c) uses must with no inversion. (d) wrongly adds not, creating a double negative (Under no circumstances must students not leave = they must leave!).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47dc7334-7b55-5945-bea2-476d1b9d7014', '91d20544-8a7f-5848-acff-4a219e376de0', 'Grammar — Modal of past deduction: "The exam paper was left on the desk all night. Anyone ___ the answers."', '[{"id":"a","text":"must see"},{"id":"b","text":"can''t have seen"},{"id":"c","text":"could have seen"},{"id":"d","text":"should have seen"}]'::jsonb, 'c', 'Anyone could have seen (past ability/possibility) — the exposure made it possible for someone to see the answers. "must see" is a present obligation (no past reference). "can''t have seen" expresses certainty that nobody saw — but the paper being left out makes seeing possible, not impossible. "should have seen" implies someone was expected or obliged to see the answers.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8e03da6-5d94-5048-833c-78485ba61f98', '91d20544-8a7f-5848-acff-4a219e376de0', 'Grammar — Participle clause: "___ the task was beyond its resources, the company withdrew its bid."', '[{"id":"a","text":"Realising"},{"id":"b","text":"Realise"},{"id":"c","text":"Having been realised"},{"id":"d","text":"It realised"}]'::jsonb, 'a', 'The company realised (active, simultaneous with withdrawing), so an active -ing participle is correct: Realising the task was beyond its resources, the company withdrew. The subject is the same in both clauses (the company). "Realise" is the base form (no tense). "Having been realised" is a passive past participle — the task can''t realise itself. "It realised" is a full clause (would need a conjunction).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11834420-809d-5206-8c0a-1af4f1e122c7', '91d20544-8a7f-5848-acff-4a219e376de0', 'Vocabulary — Nominalisation: "Choose the most formal academic rephrasing of ''The scientists achieved a breakthrough.''"', '[{"id":"a","text":"The scientists'' achievement of a breakthrough marked a turning point."},{"id":"b","text":"The scientists did a breakthrough thing."},{"id":"c","text":"The achievement of a breakthrough was made by the scientists."},{"id":"d","text":"The scientists had a very big success, and they broke through."}]'::jsonb, 'a', 'Nominalisation converts the verb achieve into the noun achievement, and the sentence becomes more compact and formal: The scientists'' achievement of a breakthrough marked a turning point — this is (a), the correct answer. (b) "did a breakthrough thing" uses breakthrough as an adjective modifier and "did" as a light verb — neither is a nominalisation and it reads as ungrammatical. (c) "The achievement of a breakthrough was made by the scientists" is a passive nominalisation but is wordy and awkward ("was made by" is a pseudo-passive that adds no clarity). (d) is informal paraphrase with no nominalisation whatsoever.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44967475-3da8-5d2b-8733-1de3899c1155', '91d20544-8a7f-5848-acff-4a219e376de0', 'Usage — Discourse cohesion: "Choose the option in which all discourse markers are used correctly."', '[{"id":"a","text":"She trained hard. However she won the race."},{"id":"b","text":"The plan failed. Therefore, it had been well-funded."},{"id":"c","text":"Although the results were poor but the team didn''t give up."},{"id":"d","text":"The study was small; moreover, its findings were surprising."}]'::jsonb, 'd', '(d) is correct: moreover links a small size to surprising findings as two related noteworthy points (the smallness makes the findings more surprising — a compound idea). (a) needs a comma after However: However, she won. (b) makes a logical error: Therefore signals a result, but the plan failing and being well-funded are not in a cause-result relationship — Nevertheless would fit. (c) doubles the concession word: Although and but cannot both appear in the same clause — remove but (Although the results were poor, the team didn''t give up).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b53a8169-0e62-5775-bb3b-ec960886da6a', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a1d67367-d42e-5d3a-a8e3-0fb902c51ac4', 'b53a8169-0e62-5775-bb3b-ec960886da6a', 'Grammar — Subjunctive: "The committee insists that every delegate ___ present at the opening session."', '[{"id":"a","text":"is"},{"id":"b","text":"be"},{"id":"c","text":"being"},{"id":"d","text":"was"}]'::jsonb, 'b', 'After insist + that, the mandative subjunctive requires the base form (infinitive) for all subjects, including third-person plural: every delegate be present. "is" is the indicative form (no subjunctive). "being" is the gerund or present participle (wrong form after that). "was" is the past indicative, not the subjunctive base form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69f6d04c-a0b0-5241-bff2-39807b61bd0b', 'b53a8169-0e62-5775-bb3b-ec960886da6a', 'Vocabulary — Idiom: "After years of rivalry, the two companies finally ___ and decided to merge."', '[{"id":"a","text":"buried the hatchet"},{"id":"b","text":"burned their bridges"},{"id":"c","text":"let the cat out of the bag"},{"id":"d","text":"bit the bullet"}]'::jsonb, 'a', 'To bury the hatchet means to end a conflict and make peace — perfect for ending a rivalry before a merger. "burn bridges" means to destroy relationships permanently (the opposite — you can''t merge after burning bridges). "let the cat out of the bag" means to reveal a secret. "bite the bullet" means to endure a painful situation stoically — not about reconciliation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53a71b5a-b637-543a-b68d-6ec1b5c05d2c', 'b53a8169-0e62-5775-bb3b-ec960886da6a', 'Usage — Ellipsis: "Tom said he would call back, and so ___ Lisa."', '[{"id":"a","text":"did"},{"id":"b","text":"said"},{"id":"c","text":"would"},{"id":"d","text":"does"}]'::jsonb, 'a', 'The ellipsis replaces said she would call back: the auxiliary did substitutes the past action. In so + auxiliary inversion (so did Lisa), the auxiliary did echoes the past reference of said. "said" would need an object (so said Lisa is archaic/poetic and the ellipsis is incomplete). "would" keeps the future sense but drops the past context of said. "does" is present tense and doesn''t match the past narrative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bd73099-d806-5277-9955-81a08711e720', 'b53a8169-0e62-5775-bb3b-ec960886da6a', 'Grammar — Unreal past: "I wish I ___ to the meeting yesterday — it sounds like it was very useful."', '[{"id":"a","text":"go"},{"id":"b","text":"went"},{"id":"c","text":"had gone"},{"id":"d","text":"would go"}]'::jsonb, 'c', 'I wish about a past event (yesterday) uses the past perfect: I wish I had gone. "went" (past simple after wish) refers to a present/future wish (I wish I went to work by bike — habitual), not a missed past event. "go" is the base form (no tense). "would go" after wish expresses a strong desire about another person''s future behaviour, not a personal regret.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21a1635a-e895-5a08-8dc9-9400ed42cf00', 'b53a8169-0e62-5775-bb3b-ec960886da6a', 'Usage — Confusable words: "The study ___ that higher caffeine intake may lead to improved focus."', '[{"id":"a","text":"infers"},{"id":"b","text":"implies"},{"id":"c","text":"supposes"},{"id":"d","text":"affects"}]'::jsonb, 'b', 'A study that suggests something without stating it directly implies it — the speaker/author implies, the reader infers. "infers" reverses the direction (the reader would infer from the study, but the study itself implies). "supposes" means to assume or hypothesise — not what a study does when it suggests an association. "affects" means to influence — the study doesn''t influence here; it communicates.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', '⭐ Gauntlet C2: Warm-up', 1, 50, 10, 'practice', 'admin', 1)
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
  ('695dca2d-24e4-522c-a7bc-c5a0f1ad94f7', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Grammar — Subjunctive: "The board recommended that the CEO ___ the decision immediately."', '[{"id":"a","text":"reverses"},{"id":"b","text":"reversed"},{"id":"c","text":"reverse"},{"id":"d","text":"reversing"}]'::jsonb, 'c', 'After recommend + that, the mandative subjunctive uses the base form (infinitive) for all persons, so even for third-person singular the CEO, no -s is added: that the CEO reverse. "reverses" is the third-person indicative (not the subjunctive). "reversed" is past indicative. "reversing" is the gerund/participle and cannot follow that in this construction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c30284dd-75af-5da7-b516-f0928b4a4cc1', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Vocabulary — Idiom: "Don''t tell anyone about the surprise party — I don''t want you to ___."', '[{"id":"a","text":"bite the bullet"},{"id":"b","text":"burn your bridges"},{"id":"c","text":"miss the boat"},{"id":"d","text":"let the cat out of the bag"}]'::jsonb, 'd', 'Let the cat out of the bag means to reveal a secret inadvertently — exactly the risk with a surprise party. "Bite the bullet" means to endure something unpleasant. "Burn your bridges" means to destroy a relationship or opportunity permanently. "Miss the boat" means to lose an opportunity by being too late — none of these is about revealing a secret.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b59e00e4-77f6-5895-aad4-a31b6e606d4a', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Usage — Confusable words: "The new contract will ___ all existing agreements."', '[{"id":"a","text":"supersede"},{"id":"b","text":"supercede"},{"id":"c","text":"surpass"},{"id":"d","text":"superior"}]'::jsonb, 'a', 'Supersede means to replace or make obsolete — the correct legal/formal term here. Note the spelling: supersede ends in -sede, not -cede (a very common error). "supercede" is a misspelling. "surpass" means to exceed or do better than (performance, not replacement). "superior" is an adjective, not a verb.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a03f0c2-8f4b-502e-9ab0-2bca38ad6393', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Grammar — Unreal past: "It''s high time this city ___ its public transport system."', '[{"id":"a","text":"modernises"},{"id":"b","text":"would modernise"},{"id":"c","text":"has modernised"},{"id":"d","text":"modernised"}]'::jsonb, 'd', 'It''s (high) time + past simple expresses a present wish or mild criticism that something should already have happened: It''s high time this city modernised its transport. The past form here has a present/future meaning (unreal past). "modernises" (present simple) breaks the unreal-past rule. "would modernise" is used in It''s time for someone else''s behaviour (It''s time you would… is wrong — no conditional modal). "has modernised" is present perfect — wrong form after It''s time.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2d8106c-9f46-55e9-9ab0-f9c52fe92d0d', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Usage — Register: "Which sentence is MOST appropriate for a formal academic report?"', '[{"id":"a","text":"The team looked into the problem."},{"id":"b","text":"The team investigated the problem."},{"id":"c","text":"The team checked out the problem."},{"id":"d","text":"The team had a good look at the problem."}]'::jsonb, 'b', 'investigate is the formal single-word verb appropriate for academic writing. "look into" is a neutral phrasal verb — acceptable in semi-formal writing but not ideal in academic reports. "check out" is informal/colloquial. "had a good look at" is informal and wordy. At C2 you choose investigate over look into without hesitation in formal writing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6ee0e6b-6a01-573c-8c56-1d57f6e1cc66', '8b3d088c-1a20-5c7d-8860-d0a3fabd64eb', 'Spelling — Choose the correctly spelled word: "Booking hotels for 200 guests requires careful ___."', '[{"id":"a","text":"accomodation"},{"id":"b","text":"accommodation"},{"id":"c","text":"accomadation"},{"id":"d","text":"acommodation"}]'::jsonb, 'b', 'accommodation has two c''s and two m''s: ac-com-mo-da-tion. A useful mnemonic: the hotel has a double bed in a double room (two c''s, two m''s). "accomodation" has only one m. "accomadation" swaps the second o for an a. "acommodation" has only one c.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6da01d13-f97e-5b7d-9f1f-b909367cbeac', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', '⭐⭐ Gauntlet C2: Mixed Drills', 2, 75, 15, 'practice', 'admin', 2)
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
  ('e75bacc4-6568-5a3a-865b-fab942843a04', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Vocabulary — Idiom in context: "Read: ''We all knew the project was failing, but nobody at the meeting mentioned the declining sales figures or the missed deadlines. The manager spoke only of future opportunities.'' What problem does the text describe?"', '[{"id":"a","text":"Beating around the bush."},{"id":"b","text":"Going the extra mile."},{"id":"c","text":"The elephant in the room."},{"id":"d","text":"Burning bridges."}]'::jsonb, 'c', 'The elephant in the room is a problem everyone is aware of but nobody wants to address directly — the failing project, missed deadlines, and declining sales that nobody mentioned in the meeting. "Beating around the bush" means to avoid saying something directly (about individual speech, not a collective avoidance). "Going the extra mile" means making extra effort. "Burning bridges" means destroying relationships permanently.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('146958ce-d04b-5053-bceb-02d13b7af8f7', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Grammar — Unreal past: "I''d rather you ___ that to the press without asking me first."', '[{"id":"a","text":"don''t say"},{"id":"b","text":"won''t say"},{"id":"c","text":"not say"},{"id":"d","text":"hadn''t said"}]'::jsonb, 'd', 'I''d rather + subject + past perfect expresses a wish that a past action had not happened (regret about the past): I''d rather you hadn''t said that. "don''t say" is a present wish about the future (I''d rather you don''t say it — semi-acceptable in informal speech, but doesn''t fit the past context of "to the press" already). "won''t say" after I''d rather is non-standard. "not say" is the form used in I''d rather not say myself (no subject), not when another subject follows.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('682f8d8b-abda-5b84-8bc3-d4fbda1a5374', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Usage — Nominalisation: "The most formal academic version of ''scientists have recently discovered that…'' is:"', '[{"id":"a","text":"Scientists made a recent discovery that…"},{"id":"b","text":"The recent discovery by scientists that…"},{"id":"c","text":"Scientists did a discovery recently that…"},{"id":"d","text":"The scientists found out recently that…"}]'::jsonb, 'b', 'Full nominalisation converts the verb phrase have recently discovered into the noun group The recent discovery by scientists — most formal and common in academic writing as a sentence opener. (a) made a discovery is a semi-nominalised light-verb construction — more formal than the original but less so than (b). (c) did a discovery is ungrammatical in English. (d) found out is a phrasal verb — informal register.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59ae9bf1-9948-54f5-8c11-c111f9d0de32', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Usage — Confusable: "A ___ rain fell on the city throughout the winter, never stopping for more than an hour."', '[{"id":"a","text":"continual"},{"id":"b","text":"repetitive"},{"id":"c","text":"constant"},{"id":"d","text":"continuous"}]'::jsonb, 'd', 'The phrase "never stopping for more than an hour" describes rain without any break — that is continuous (unbroken). "continual" means repeated at intervals with pauses (a continual cough = one that keeps coming back). "constant" is close in meaning but less precise about the unbroken quality. "repetitive" describes something done over and over in an identical way — it focuses on sameness, not unbrokenness.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e46c011-29ab-5f2b-b413-e31780e8b3a5', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Grammar — Ellipsis: "She works harder than any of her colleagues ___."', '[{"id":"a","text":"are working"},{"id":"b","text":"do"},{"id":"c","text":"working"},{"id":"d","text":"they work"}]'::jsonb, 'b', 'After a comparative than-clause, ellipsis drops the repeated verb phrase: …than any of her colleagues do [work hard]. The auxiliary do substitutes for the full verb phrase. "are working" would imply a present continuous (parallel with a simple present main clause — mismatch). "working" is an -ing form with no auxiliary. "they work" repeats the subject unnecessarily and is not the natural ellipsis form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d755a59-3ba3-590a-a349-57c085a41b3f', '6da01d13-f97e-5b7d-9f1f-b909367cbeac', 'Spelling — Choose the word spelled correctly: "The ambassador''s role as a ___ between the two governments was vital."', '[{"id":"a","text":"liason"},{"id":"b","text":"laiason"},{"id":"c","text":"liaison"},{"id":"d","text":"liaision"}]'::jsonb, 'c', 'liaison: li-ai-son — three vowels in a row (i-a-i) followed by son. It comes from French. "liason" omits the second i. "laiason" transposes the i and the a. "liaision" inserts a rogue i before son. Tip: li-AI-son — the AI is in the middle.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('861145f7-4055-5f75-9520-dcf4b49d9411', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', '⚔️ Gauntlet C2 Boss ⭐⭐⭐: Mixed Mastery', 3, 120, 30, 'boss', 'admin', 3)
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
  ('633dda78-06b5-5f6c-8367-938d350acd45', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Grammar — Subjunctive: "The judge demanded that all evidence ___ re-examined by an independent expert."', '[{"id":"a","text":"was"},{"id":"b","text":"is"},{"id":"c","text":"be"},{"id":"d","text":"were"}]'::jsonb, 'c', 'demand triggers the mandative subjunctive in the that-clause: the base form be (passive: be + re-examined) for all subjects. "was" is past indicative or past hypothetical (not the mandative subjunctive). "is" is present indicative — drops the subjunctive. "were" is the hypothetical/conditional subjunctive (If I were…; I wish it were…) — a different use; it would mean the evidence hypothetically was examined, not that the judge commands it.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34a81998-8b33-5503-af0f-10942dc90969', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Vocabulary — Figurative language: "The economy is bleeding jobs at an alarming rate." What technique does this sentence use?', '[{"id":"a","text":"Metonymy"},{"id":"b","text":"Simile"},{"id":"c","text":"Metaphor"},{"id":"d","text":"Hyperbole"}]'::jsonb, 'c', 'Bleeding applied to the economy is a metaphor — the economy is compared to a living body losing blood, conveying rapid loss without using like or as. Metonymy would replace one thing with a closely associated concept (e.g., The White House announced). A simile uses like or as (The economy is like a patient bleeding out). Hyperbole is deliberate exaggeration for effect (I''ve told you a million times) — bleeding here is not an exaggeration but a vivid figurative substitution.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d96d53f9-fc41-5809-8626-f401eea9c716', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Usage — Confusable words: "The C2 word meaning ''having no personal stake in the outcome'' (and therefore free from bias) — as opposed to ''not curious or caring'' — is ___."', '[{"id":"a","text":"uninterested"},{"id":"b","text":"disinterested"},{"id":"c","text":"indifferent"},{"id":"d","text":"impartial"}]'::jsonb, 'b', 'disinterested means having no personal stake in the outcome — etymologically ''without self-interest'', not ''without interest''. This C2 confusable is widely misused: "uninterested" means not curious or caring (the opposite of what you want in a mediator). "indifferent" implies apathy or lack of preference — a mediator must be engaged, not apathetic. "impartial" is a near-synonym but does not carry the specific ''no financial/personal stake'' nuance that disinterested uniquely encodes; the question targets the confusable pair disinterested/uninterested, not the synonym impartial.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dbb5a31-b9ee-5c0f-970b-0733cc619386', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Usage — Ellipsis: "Choose the sentence in which ellipsis is used CORRECTLY."', '[{"id":"a","text":"Some students passed the exam, and some did not."},{"id":"b","text":"She left early because tired."},{"id":"c","text":"He decided to leave, and so she."},{"id":"d","text":"He submitted the report, but not presented it."}]'::jsonb, 'a', '(a) is correct: …and some did not [pass the exam] — the omitted material is fully recoverable. (b) is incorrect: ''because tired'' omits the subject and auxiliary (because she was tired) — ungrammatical in standard English. (c) should be ''so did she'' (inversion required after ''so'': so + auxiliary + subject). (d) is incorrect: ''but not presented it'' drops the auxiliary verb — the correct form is ''but did not present it''; a lexical verb cannot be gapped this way.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20f331dc-6898-5844-862d-de8ec2b24b23', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Grammar — Formulaic subjunctive: "___ that as it may, we still need to find a solution."', '[{"id":"a","text":"Being"},{"id":"b","text":"Is"},{"id":"c","text":"Was"},{"id":"d","text":"Be"}]'::jsonb, 'd', 'Be that as it may is a fixed formulaic subjunctive meaning ''even if that is true'': the base form be is used, not the indicative is/was or the participle being. This is a fossilised C2 formula that appears in formal and written English. "Being" starts a participle clause and would mean something different. "Is" and "was" are indicative — they break the subjunctive mood of the formula.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab024f8b-6c19-5c21-9962-d3512a4b2dda', '861145f7-4055-5f75-9520-dcf4b49d9411', 'Usage — Register: "Which option nominalises correctly and raises the register of ''They failed to respond to warnings''?"', '[{"id":"a","text":"The fact that they were failing to respond to warnings…"},{"id":"b","text":"They did not respond, failing with the warnings…"},{"id":"c","text":"The warnings were not responded to by them, failing…"},{"id":"d","text":"Their failure to respond to warnings…"}]'::jsonb, 'd', 'Their failure to respond to warnings nominalises the verb fail → failure and compresses the clause into a clean noun phrase — concise and formal: this is (d), the correct answer. (a) "The fact that they were failing to respond…" is a heavy that-clause with unnecessary continuous aspect — not a nominalisation. (b) "They did not respond, failing with the warnings…" splits the structure awkwardly and is not more formal than the original. (c) "The warnings were not responded to by them, failing…" is a convoluted passive that adds words without adding clarity.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ec78bedf-84de-5ff5-8169-52d17335f480', '6bfedf31-14b5-594f-bced-8fd0ad6e6c37', 'anglais-donjon', '👑 Gauntlet C2 Elite ⭐⭐⭐⭐: The Final Trial', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('77694b49-577b-5c48-af7f-b5ad3d589248', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Grammar — Subjunctive vs indicative: "Find the sentence in which the subjunctive is used INCORRECTLY."', '[{"id":"a","text":"It is vital that every member sign the declaration."},{"id":"b","text":"The senator proposed that the bill be withdrawn immediately."},{"id":"c","text":"She insisted that the contract is reviewed by a lawyer."},{"id":"d","text":"The rules require that applicants submit their forms by Friday."}]'::jsonb, 'c', 'The error is (c): after insist + that (mandative), the subjunctive base form is required — the contract be reviewed, not is reviewed. (a) is correct: vital that…sign (base form, no -s). (b) is correct: proposed that…be withdrawn (base form passive). (d) is correct: require that…submit (base form, no -s even for applicants).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9718932-b970-548b-bc09-fd9813dd937a', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Vocabulary — Confusable pair: "The two reports ___ each other''s findings, making the conclusion very reliable."', '[{"id":"a","text":"confirm"},{"id":"b","text":"corroborate"},{"id":"c","text":"collaborate"},{"id":"d","text":"commemorate"}]'::jsonb, 'b', 'corroborate means to strengthen or confirm a claim by providing independent supporting evidence — the precise academic/legal term for two separate reports arriving at the same findings. "confirm" is correct in meaning but less precise and more general. "collaborate" means to work together — reports do not collaborate, people do. "commemorate" means to honour the memory of something — an entirely different word that happens to start with co-.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50c89ad0-afd6-5355-b118-891792824021', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Grammar — Unreal past & wish: "If only she ___ the warning signs earlier, the disaster could have been avoided."', '[{"id":"a","text":"recognised"},{"id":"b","text":"had recognised"},{"id":"c","text":"would recognise"},{"id":"d","text":"has recognised"}]'::jsonb, 'b', 'If only + past perfect expresses a regret about a past event (the disaster happened): If only she had recognised the warning signs earlier. This is the same unreal-past-perfect rule as I wish + past perfect (I wish she had recognised…). "recognised" (past simple) after If only refers to a current wish/regret about a present habit. "would recognise" after If only (If only she would…) is used about another person''s stubborn present behaviour — not a past counterfactual. "has recognised" is present perfect — wrong tense for a completed past counterfactual.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c966ec51-ca9b-57b1-8d75-4f7479bc8768', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Usage — Ellipsis and substitution: "She signed the contract immediately; he ___ the following week."', '[{"id":"a","text":"did it so"},{"id":"b","text":"so did"},{"id":"c","text":"did so"},{"id":"d","text":"did the same so"}]'::jsonb, 'c', 'did so substitutes the entire verb phrase signed the contract: he did so [signed the contract] the following week. This is verbal substitution with do so (formal/written register). "did it so" inserts an unnecessary pronoun and adverb. "so did" is the inverted form used for adding agreement (So did he — he also signed it), not for a substitution in a sequential narrative with a time marker. "did the same so" is not a grammatical substitution form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86b81606-25f2-5cad-a4d4-065185d1e551', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Vocabulary — Idiom precision: "After decades of ignoring environmental concerns, the oil company has finally decided to ___ and adopt a net-zero strategy."', '[{"id":"a","text":"miss the boat"},{"id":"b","text":"go the extra mile"},{"id":"c","text":"face the music"},{"id":"d","text":"turn over a new leaf"}]'::jsonb, 'd', 'turn over a new leaf means to change behaviour and start acting better — perfectly matched to a company that has finally changed direction after decades of ignoring environmental concerns. "miss the boat" means to lose an opportunity by being too late (possible in a different context, but the sentence says they have decided to act, not that they failed to). "go the extra mile" means to make extra effort — the sentence is about a change of direction, not additional effort. "face the music" means to accept the consequences of one''s actions — not the same as adopting a new positive strategy.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6a9332e-e72e-563d-989f-c523e6e43d5e', 'ec78bedf-84de-5ff5-8169-52d17335f480', 'Usage — Register shift: "Which option correctly rewrites the informal sentence ''The government looked into why so many young people can''t find jobs'' in formal academic style, with full nominalisation?"', '[{"id":"a","text":"The government investigated the reasons behind youth unemployment."},{"id":"b","text":"The government did an investigation about why young people cannot find jobs."},{"id":"c","text":"The reasons young people don''t find jobs were looked into by the government."},{"id":"d","text":"The government carried out a look into youth unemployment causes."}]'::jsonb, 'a', 'The government investigated the reasons behind youth unemployment achieves three things: (1) replaces the phrasal verb looked into with the single-word formal verb investigated; (2) nominalises can''t find jobs → youth unemployment; (3) is concise and precisely academic. (b) uses did an investigation — a light-verb construction that is less formal than investigated, and "about why" is verbose. (c) passive and keeps looked into (informal phrasal verb). (d) carry out a look into is unidiomatic — you carry out an investigation, not a look.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

