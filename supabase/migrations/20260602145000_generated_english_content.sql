-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: english (Anglais)
-- Regenerate with: npm run content:build
-- Source of truth: content/english/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium) VALUES
  ('english', 'Anglais', 'Grammar, tenses, modals, vocabulary, reading & writing — Tunisian 9th-grade syllabus', 'Agilite', 'subject-english', 'Globe', 5, 'en', false)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  description = EXCLUDED.description,
  attribute = EXCLUDED.attribute,
  color_token = EXCLUDED.color_token,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order,
  content_language = EXCLUDED.content_language,
  is_premium = EXCLUDED.is_premium;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'english'
      AND e.source = 'admin'
      AND q.id NOT IN ('080d7783-083d-5532-a30c-825175ef6d09', '5c8be484-cc52-575b-ac02-d7dd39f06af1', '138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'd819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', '4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', '7241ee79-462b-5b3a-984c-eea640002fb0', '7a63341f-b75c-5f33-9964-f0a5e371d967', '43bd124a-3273-5b3d-babe-7c21c893d954', 'c4629643-cb37-5769-8cef-57760b3611f9', '499dffeb-77ba-571a-a272-ef6b68e30622', 'a5481854-86d1-56f3-8ac1-c1496af746ac', 'd8b38f06-1764-5f19-ba99-8f0fd06fd79b', '620f8003-045f-50cd-a9f5-2e24398d3bc5', '535f555e-00ec-541c-9430-c8c68f6f8bb0', '71117f1e-36c4-5a8e-b723-9dbc88418bf1', 'bc94054e-1446-5d04-8e8c-221f38cdcb9d', '90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '86f3a7c0-5851-570f-9244-5836c0bd3430', '496b9bfb-62c9-5779-bfb6-c7155592c344', '40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '21b7cf2a-d994-5d60-ae47-b0557b541a1a', '43209281-e502-55a8-af03-57de11357db3', '4c7fcb80-216b-51a9-aea0-1a7b93d56db9', 'd14c0f60-6da2-55c5-8785-7bf3766936e3', '8407502b-fddc-5cd3-8d49-57b73532d39b', '52851484-7889-5e36-b119-90b1e3d6811a', 'ff900417-defa-574f-b8c7-08e0b3fa1c5f', '31b2179a-b120-5b3e-aa93-1c722607e47b', 'fa3867c5-204b-545f-8d8a-6a7d0bf12ca1', 'b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '0bb52641-d98c-5fc5-a598-beb8dbb6ef71', 'def1e0d2-88c6-5665-b598-fcbea95f96eb', '0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', 'f36a39c7-17e1-500d-a663-25676e3f151d', 'bc3de6df-27c5-564f-a509-4feb9efb0100', '14609924-058c-5c85-b515-6e83bfa1c218', '13f53f19-669d-5bae-bb4e-fee06ce7d631', '63809236-3326-5a22-bf77-ca09b2f1cd0c', '6259cdd8-58d3-5794-8789-ae21fa623ed6', 'c43f3d30-8f67-5e14-a3e2-445602f8671d', 'a79183ff-96f8-5044-a92c-581978d8d1c9', '937bbd74-4c72-52a9-a129-ef162fceeeb5', '67cf5732-4004-59fe-b4a5-bbc42565a024', '75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', 'dafd7523-eee4-517a-9606-6b8f9a72155f', '37470435-85a2-505c-91ca-b117d0515933', 'fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', 'cedab619-4c56-5ca3-ab85-a95e25b97113', '4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '42b58ca1-24dc-5af1-a693-9b4143086c60', 'e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', 'c5e159b5-bd31-599c-86e1-07e774c6fcbd', 'd022e990-1237-5d6b-b0bf-33f2369aeac4', '2dcbfba5-5976-5cf4-bd1c-49a3a8391813', '267cb805-3c50-5e96-bbde-23956195cd16', '920e5c43-24eb-5f48-a671-d828a09799d4', 'fdbb01a0-84ce-5e3a-8df0-75fbbf44dbe3', '3b891d10-ca35-57e9-bf7f-ba16e93395bb', '7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', 'd65ae3ef-84c2-5f87-b631-5f91de5eef1f', '1ceda0cf-76cc-5320-b521-1dbaaf81ff83', 'd607352b-8809-5647-8ea5-22f2ffea5f51', '8b0082a8-9de5-5939-9428-c20ddaf4909d', '12f16b47-6a4c-5487-99e2-f1f5e592d512', '4ba459b0-dc9e-57f9-9175-81ba6c0d490d', 'bc58c470-1c5f-570b-b347-e040a8aaabbf', 'ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', 'f82a2c0b-e513-5770-8b2a-024116d6b3a1', '389a214c-d24f-5aff-b8e6-447a45ed35ed', 'dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'e7a6d78a-35e1-5568-a53b-3be72295890c', 'fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'b3748c61-938a-5781-a6e3-e94630c69381', '723d0846-dcc9-57dc-a8d5-3f9a581abd90', '20e1e342-c46f-5418-9778-f7583673ec41', 'dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', 'cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '4416d439-5708-525c-ab80-c0cf44fcea23', '169e3347-7224-50c0-8f7d-5e3e2e95772a', '6b5844a2-8c40-5cb9-a0a5-f526268f5281', '120cfca7-61da-5532-94c1-0790a1ceffeb', '5eab5c5f-9ed1-5310-9572-af91d04eb918', '9b74588e-0387-5055-98fa-79d2e542499f', '0aff5ebb-d9a2-5842-9ac5-ae78c4e62fb7', '54b86e72-424b-5e9d-903e-fcfd68cae6b3', '14f5f97c-9c0f-5ede-9836-067638a273fc', 'd1c87325-095a-555e-95d3-138f47124355', '18298070-040f-5ac3-b119-9cb6fb720fa2', '9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', 'a682336a-8cac-55fe-98ed-d13e41b90c21', '10cdbbe6-7c81-509f-9107-c3f8ea0bc615', 'a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'a039206b-03d4-5fc9-86ad-75e0019c4a70', '3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', '1e66eafa-708f-5de1-a6cc-2921d6e02ffc', '01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd4455f0a-1f51-5dad-ad63-3e592ebb5d36', '59194e7b-1eac-57ca-935a-de51f43964ea', 'f2b8ba0d-7631-5805-8846-a5fa20b419c6', '3e6e3345-a167-528b-86c9-8f8012c051f7', '68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', 'ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '3f3f291b-0ed5-5034-8ea2-007904302b91', 'eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', 'ecf5bd5c-0f9d-5239-a6b2-06167c953a96', 'bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '8aeba267-0d13-5fa7-91bb-0e9a7697967e', '3a452b60-51b7-5ddc-874e-12e6700c8005', '5db5a8d8-fab9-5969-9c94-e595ed9267aa', '6fd3fc33-e3db-595a-a973-7967c0469ca6', 'f53f9f28-16bb-5349-a7d9-a3b69c334298', '48f3e5a8-8ced-57a6-9b00-4d5794ed4dd4', '1ea96d32-61f6-596f-8ba3-de15278076bc', 'ad16f401-eb6f-593c-a90c-07f819cc0d58', '390d080b-349c-538c-9250-acd59fd6c1c3', '462d9345-5c31-5111-8ce8-314de8fd5caa', 'da303622-b350-5b8b-9b6d-370d9728bb8e', '902f8a7c-6687-5818-814b-a17e2eef1444', '32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '013e8407-3e0a-5ecc-af47-acfb7edf86d9', '57545cb8-cc45-5e9a-acc6-42102f111e27', 'ee916acc-ccc1-509c-934c-be74d6578dc8', 'c3be55d8-8928-58bb-bd27-181af4a0d5e3', '9f28f12e-250e-5f6c-9fe4-d5c4de564764', '402518e0-c2ac-5c9c-86c9-8db84a66c20a', 'fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', '349da296-708e-512c-98a5-f79c0d32d5fd', 'dd9dffa7-3d7a-5ecc-a39f-486149eb142f', '6d753d89-3393-5d46-80cb-7105df4178f0', '279267c3-6b7e-528e-a57e-a4ab75cfd473', 'a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', '1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '9552a62c-6941-5408-b0ca-cb7b41978a9b', '4a556f41-88ff-55ab-b724-0ab31deddf69', '78208151-f432-5986-89c6-95d2261fe015', '277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '75194e7f-9c18-5bb3-b70d-cac4a264bee3', '2557f68b-d1fe-54ce-89df-1820a60e498f', '78bec8e7-42c1-5dda-80fd-20ba4136196d', '9829779a-863f-5a57-88b7-21254e3d8e69', 'fc04747b-aebe-5c37-a221-d25b5c3dcc39', 'c226d66f-23d6-5e65-ba82-2229c946b41c', '9f2d069b-fa0b-5f5c-9903-f395c6ade85b', '79afc241-0f21-57eb-b2de-d9c503d9d75c', '3248e070-6326-5ec2-9a5c-9a6562bf3d43', 'a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', 'c5b5be7e-f4ab-55b6-a38e-181570ee31d9', 'b71e28ea-6533-5302-b2c9-9ddad3b2c439', 'cf42ec20-80b2-537e-a00e-3c58063c62ff', '0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '1886b0c7-fccb-565d-92ff-f84e3a6993f4', 'e072540f-1856-5eac-9a8e-db19cec747e6', 'a9e2968b-a92d-5746-9362-164238da0854', '7989200f-316a-50cf-a23b-c990be75e64e', '43b02806-bc22-570c-b797-0b37b895db64', '8fdfff8c-ddbd-5448-85e5-83a9f52730c9', 'c961b0e5-2864-5565-abe0-a6579f21445f', '86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '02029c31-8bc4-5e35-8816-cce63c913e55', '01868ac1-1c85-531f-b957-c922c262d7c3', '5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', 'b3509320-48b2-5d64-b94a-277dd38e4efd', '741a817a-a456-5c11-aca4-40c0f9dd6d99', '850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '659c49ec-4a06-519d-aba8-8a72e9ad1b81', '9f51a9e2-ac5e-5418-9bce-61475a0c46c0', 'f5610d0d-6e08-5683-8742-12e78f2babaf', '7996acd6-f402-5397-b872-795a696c4bb7', '1dd1def4-86e5-5073-9b3f-49d80a876b39', 'a3576e59-8351-52db-963a-e23eb337b92f', '89ca831c-9475-5039-bc24-33bc96445b41', 'd5b41c1a-0a53-5c06-915c-102435d5c6c0', 'c4d34b52-281d-57e3-8460-aafe4175f0f5', '145aa30d-c72c-5e4d-9190-f15b093dd84f', '26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'b165d39a-8b1a-559a-bc93-6ef918be4194', '94522885-b8e2-5f36-becc-435d20c867e2', '719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'a209293d-9928-57f6-8315-b45fbd4f39e3', '0c4cb780-1da9-5b34-bd95-073216e9116a', 'f4aafc66-106d-5f85-918e-89cb6ca105d1', '1ddeacd6-9014-5387-85ab-5ebca4c59ff1', '71e33276-0916-5dbf-9e87-3633f36b26be', '6f165226-6514-5ab3-8be5-8e7b31368205', 'c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '97062025-2da0-52e1-b0a4-2dd3e6625115', 'ffba2614-6e95-5898-af20-4f54e0cfbf82', 'cd11e9b8-d66b-5df5-9042-1f71a4c1c943', 'ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', '7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', '11d6470e-14ec-5d4c-a173-f08aa8b53c8f', '98ae61e1-b215-5802-96f7-52e519f394d4', '63217691-5552-58cf-91f9-4fb34905a0ef', 'a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', '20c26877-8f50-5441-a3b2-64b75b441c2e', 'c62b1670-17ff-5d0e-b684-935a306288ac', 'ba8523d7-f226-5903-93dd-45435cff9844', 'fe1d97ca-88d0-5ee4-8fec-4f0ee037391e', 'b023da2d-36db-500b-ad6f-ce9794159a3f', '2aae1e21-eb52-5560-987a-f08b84c1c0ec', 'd9e00dc9-ff59-55d0-9648-d429ed81295c', 'c76b8b99-9da2-5728-9cb2-f075223db346', '4935e3cb-7a61-50a1-b744-1f0b34d7815f', '1da5ec88-b844-5781-97cc-219745da8727', '3286e813-6caa-57ff-a8e3-c3606cb69310', '4ae0793a-71f0-59d6-9e51-a31b37912048', 'f68a2c08-9617-5c02-a318-9e30a4619989', 'a387198b-d83b-52a6-9faf-fd4740453fb6', '53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', '44355f34-9f8c-53a1-aadb-81d5245d24b4', '72cf3144-6f03-53f3-a57f-d413730520ed', '684457b0-f151-5355-b7de-b1cc7331c8e0', '78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '118a1f96-6010-503b-a5bf-8d5a7fd05817', '2b2d3600-2cf9-5aa0-af06-ba7393c39024', '74caaa9d-d014-5673-8f8b-9c0121dc06c6', '481b204d-67d0-5c6e-b6f3-01c13e92b87e', 'da568abe-ed24-5c8b-87a8-366cf878cc44', '5dfbba67-23ca-5232-bd3a-a66957add243', '30ac2283-9c21-5f32-b50c-f55d02072c39', '509c6467-c2af-55d2-a464-d762a3a5f71a', 'c1b432f1-1cbc-574c-9660-5b7227a13d3a', '843870fc-8656-51d5-9c26-be88398192c7', '6dd765f8-f95a-54ac-9410-d82ad64ccace', '731275d6-6544-592f-a0bb-fd317ea9e825', 'd6e08b0d-d37d-534e-b7a3-fbc2929aa0bd', 'de922d60-b93c-52b8-9755-7ab94294ffd5', '3c2a16fe-94a8-5a71-beb6-413d5b472af7', '99bb5c63-3dc9-5203-88e2-3d6ecca98e13', 'ad44e9d8-fe1d-59d3-b518-2ea51b2a627c', '9b84ac2b-88c1-5e10-9ee7-a729713042ff', 'ed2c07e1-18f2-5a28-bdef-32269895079f', 'bdf11453-1d14-5f95-abf0-44c6b17b044b', 'ba4e859e-bd3f-50f4-86dd-36c0f4dc5c28', 'aa5b50d9-2c3d-57bc-80ef-83cf5473969c', '70814d98-d38e-52c0-8bd8-07f160d3afbb', '5acdc554-2621-5a4d-80f2-35310f2af5ef', '5b47820d-916f-58b9-a0d0-90c7eaff3938', 'd3ac0c0c-72d4-5c36-9af4-3e55e2bf61e3', '18944ced-9590-5b65-95c2-9b4e16b20d32', 'ca816cf8-5b8a-5807-9faf-b8115134aef4', 'f5b7882d-e334-5f41-bc99-df08d8742957', 'd4ecd2b9-807e-528e-8f74-5f0fa9e018bd', '42e3e7ea-b563-569c-90f5-b9b015b4ec33', '58334796-1688-507d-85b4-8d0f606d7eda', '9b59a2c4-f6dd-5ebf-846e-46ebc1fccfe2', '7f995235-7d0c-5578-977f-0367685bca7f', '6e40940f-e9de-597e-85f5-7a3a40f49971', '79d5ca59-ee45-54f7-b1a6-f94d0dcb221a', '82494c50-b2fd-5b15-ab67-5e6fd86d4058', 'c92e82a7-ebc6-5634-ba6d-67c111412e90', '76b801e8-7fda-5047-80f1-b82276886214', '59185207-289a-5a7b-878e-da52a9432e1d', '5df534a9-e67a-5969-a2c5-ad81ce85ec17', 'f4f69f32-d96d-5306-9ce3-7144a7664518', '9d18f897-c064-5575-bdf5-1eaf14cf48d1', 'c6e6d69e-f89f-589a-8d51-28ac9ed8fd2c', '73c5df4e-c223-5c0f-a812-7e7a6f85435d', '7a43e475-982f-58ea-aefc-70c672df20e2', '3562c6fd-8a22-558d-981c-69692e31fd0c', '0adab7d5-1c45-5d95-acce-c328c8f0dcf1', '36414703-691f-5aaf-85e9-9f664293de54', '80de5c70-358d-5f68-a4fe-c16457e56b24', 'b0d22343-a40f-5803-a63a-2d20027a1008', '9577d052-f65b-5fbb-9340-6341c231d3e2', '62cc893d-b490-5003-99db-a0a33132fb14', 'cda6ae4e-68e6-5e12-ae28-ae797997cbb7', '45de69e9-1de5-50f2-9f60-b4106d6397fb', '63b1b105-f43d-5d32-9238-bbf6fb14414b', '8c6fd010-6c6c-59dd-b928-aad83f83dec6', '079b30d7-3f60-59f7-a3aa-b1ef79ac3e78', '85188fa4-904b-567e-adf6-02a36c162396', '3c7fb0e5-23a9-5967-86c0-9ac82d0a5214', 'bb1df896-3806-5d03-9230-d9531cce5f93', '21c615c8-3484-52ef-8a08-9730c3daf203', '0b5540ce-a308-572a-8039-4e8cc0e980c5', '4ab8c800-399f-5877-9a19-a7885c560245', '02017d0d-9d9f-5fb3-a665-b8f263b9db89', 'cb662391-35a7-50c2-909c-081c92409fb5', '8efce0dd-10b4-5f6f-ae30-384ebdff0e63', '537e935a-652f-5111-8613-25656b00ad2e', '97e40233-213f-51fd-a7f1-f0bf0f053109', 'fb518c59-c56f-512e-b186-78d6542ecffd', '0d7f1d4a-b5cf-512f-9b50-88ac74c5e953', 'e04c9ac5-3c55-5ec1-8cb2-ef8646730baf', '316620e5-8554-5638-8f9d-5fd49771dd20', 'b2f60586-bf58-5a2d-b577-39ed8ac710dc', '037153f1-ec0e-5896-a66e-4371cc4ce27f', 'bdce6c1c-e193-542b-82a4-aa2d0b8fa00d', '0d8b0540-5dff-544a-9e9c-7de7022890e7', 'ba654174-6d8d-52bd-9e69-852833432ecd', '9b387f8f-8611-5635-929f-c59100149417', 'a1db5805-5ef7-57c2-a2e3-3e4704b633e4');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'english' AND source = 'admin' AND id NOT IN ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '5a7783a2-f424-5be0-b07f-8bed19499adb', '350e9c30-be36-5bb3-b3e9-719d9f142839', '285d360a-8465-518f-990c-916004f4f3b5', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '870d7346-31c1-546f-8e25-ad1a12362ea7', '46cd64a1-c660-59b3-9588-78efe0da7594', '6061e935-aa81-57d8-9e07-6940a9d538c9', '216cae02-7987-5531-b3fa-6af92e75e33d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '5e9f70de-f505-5482-a231-2c5e52d2bb68', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '1b58ef84-e8ff-5908-85ae-b13cda972800', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'aa6477e9-c60c-5771-9828-15c32bace66c', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', '50566438-5c32-582c-9b59-43a0b96cc9a4', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'e6171568-ac34-5461-a926-00b1198d046e', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', '1b387c5d-e284-59e9-a936-4be304908ee3', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', '72e8b533-b69b-5f4e-95db-09d94ad60365', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', '426b680e-1a1c-5019-af64-72f7b81cc641', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'bf325094-b7d9-517c-a966-9e62838c6136');
DELETE FROM public.questions WHERE exercise_id IN ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '5a7783a2-f424-5be0-b07f-8bed19499adb', '350e9c30-be36-5bb3-b3e9-719d9f142839', '285d360a-8465-518f-990c-916004f4f3b5', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '870d7346-31c1-546f-8e25-ad1a12362ea7', '46cd64a1-c660-59b3-9588-78efe0da7594', '6061e935-aa81-57d8-9e07-6940a9d538c9', '216cae02-7987-5531-b3fa-6af92e75e33d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '5e9f70de-f505-5482-a231-2c5e52d2bb68', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '1b58ef84-e8ff-5908-85ae-b13cda972800', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'aa6477e9-c60c-5771-9828-15c32bace66c', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', '50566438-5c32-582c-9b59-43a0b96cc9a4', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'e6171568-ac34-5461-a926-00b1198d046e', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', '1b387c5d-e284-59e9-a936-4be304908ee3', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', '72e8b533-b69b-5f4e-95db-09d94ad60365', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', '426b680e-1a1c-5019-af64-72f7b81cc641', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'bf325094-b7d9-517c-a966-9e62838c6136') AND id NOT IN ('080d7783-083d-5532-a30c-825175ef6d09', '5c8be484-cc52-575b-ac02-d7dd39f06af1', '138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'd819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', '4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', '7241ee79-462b-5b3a-984c-eea640002fb0', '7a63341f-b75c-5f33-9964-f0a5e371d967', '43bd124a-3273-5b3d-babe-7c21c893d954', 'c4629643-cb37-5769-8cef-57760b3611f9', '499dffeb-77ba-571a-a272-ef6b68e30622', 'a5481854-86d1-56f3-8ac1-c1496af746ac', 'd8b38f06-1764-5f19-ba99-8f0fd06fd79b', '620f8003-045f-50cd-a9f5-2e24398d3bc5', '535f555e-00ec-541c-9430-c8c68f6f8bb0', '71117f1e-36c4-5a8e-b723-9dbc88418bf1', 'bc94054e-1446-5d04-8e8c-221f38cdcb9d', '90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '86f3a7c0-5851-570f-9244-5836c0bd3430', '496b9bfb-62c9-5779-bfb6-c7155592c344', '40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '21b7cf2a-d994-5d60-ae47-b0557b541a1a', '43209281-e502-55a8-af03-57de11357db3', '4c7fcb80-216b-51a9-aea0-1a7b93d56db9', 'd14c0f60-6da2-55c5-8785-7bf3766936e3', '8407502b-fddc-5cd3-8d49-57b73532d39b', '52851484-7889-5e36-b119-90b1e3d6811a', 'ff900417-defa-574f-b8c7-08e0b3fa1c5f', '31b2179a-b120-5b3e-aa93-1c722607e47b', 'fa3867c5-204b-545f-8d8a-6a7d0bf12ca1', 'b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '0bb52641-d98c-5fc5-a598-beb8dbb6ef71', 'def1e0d2-88c6-5665-b598-fcbea95f96eb', '0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', 'f36a39c7-17e1-500d-a663-25676e3f151d', 'bc3de6df-27c5-564f-a509-4feb9efb0100', '14609924-058c-5c85-b515-6e83bfa1c218', '13f53f19-669d-5bae-bb4e-fee06ce7d631', '63809236-3326-5a22-bf77-ca09b2f1cd0c', '6259cdd8-58d3-5794-8789-ae21fa623ed6', 'c43f3d30-8f67-5e14-a3e2-445602f8671d', 'a79183ff-96f8-5044-a92c-581978d8d1c9', '937bbd74-4c72-52a9-a129-ef162fceeeb5', '67cf5732-4004-59fe-b4a5-bbc42565a024', '75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', 'dafd7523-eee4-517a-9606-6b8f9a72155f', '37470435-85a2-505c-91ca-b117d0515933', 'fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', 'cedab619-4c56-5ca3-ab85-a95e25b97113', '4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '42b58ca1-24dc-5af1-a693-9b4143086c60', 'e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', 'c5e159b5-bd31-599c-86e1-07e774c6fcbd', 'd022e990-1237-5d6b-b0bf-33f2369aeac4', '2dcbfba5-5976-5cf4-bd1c-49a3a8391813', '267cb805-3c50-5e96-bbde-23956195cd16', '920e5c43-24eb-5f48-a671-d828a09799d4', 'fdbb01a0-84ce-5e3a-8df0-75fbbf44dbe3', '3b891d10-ca35-57e9-bf7f-ba16e93395bb', '7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', 'd65ae3ef-84c2-5f87-b631-5f91de5eef1f', '1ceda0cf-76cc-5320-b521-1dbaaf81ff83', 'd607352b-8809-5647-8ea5-22f2ffea5f51', '8b0082a8-9de5-5939-9428-c20ddaf4909d', '12f16b47-6a4c-5487-99e2-f1f5e592d512', '4ba459b0-dc9e-57f9-9175-81ba6c0d490d', 'bc58c470-1c5f-570b-b347-e040a8aaabbf', 'ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', 'f82a2c0b-e513-5770-8b2a-024116d6b3a1', '389a214c-d24f-5aff-b8e6-447a45ed35ed', 'dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'e7a6d78a-35e1-5568-a53b-3be72295890c', 'fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'b3748c61-938a-5781-a6e3-e94630c69381', '723d0846-dcc9-57dc-a8d5-3f9a581abd90', '20e1e342-c46f-5418-9778-f7583673ec41', 'dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', 'cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '4416d439-5708-525c-ab80-c0cf44fcea23', '169e3347-7224-50c0-8f7d-5e3e2e95772a', '6b5844a2-8c40-5cb9-a0a5-f526268f5281', '120cfca7-61da-5532-94c1-0790a1ceffeb', '5eab5c5f-9ed1-5310-9572-af91d04eb918', '9b74588e-0387-5055-98fa-79d2e542499f', '0aff5ebb-d9a2-5842-9ac5-ae78c4e62fb7', '54b86e72-424b-5e9d-903e-fcfd68cae6b3', '14f5f97c-9c0f-5ede-9836-067638a273fc', 'd1c87325-095a-555e-95d3-138f47124355', '18298070-040f-5ac3-b119-9cb6fb720fa2', '9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', 'a682336a-8cac-55fe-98ed-d13e41b90c21', '10cdbbe6-7c81-509f-9107-c3f8ea0bc615', 'a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'a039206b-03d4-5fc9-86ad-75e0019c4a70', '3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', '1e66eafa-708f-5de1-a6cc-2921d6e02ffc', '01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd4455f0a-1f51-5dad-ad63-3e592ebb5d36', '59194e7b-1eac-57ca-935a-de51f43964ea', 'f2b8ba0d-7631-5805-8846-a5fa20b419c6', '3e6e3345-a167-528b-86c9-8f8012c051f7', '68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', 'ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '3f3f291b-0ed5-5034-8ea2-007904302b91', 'eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', 'ecf5bd5c-0f9d-5239-a6b2-06167c953a96', 'bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '8aeba267-0d13-5fa7-91bb-0e9a7697967e', '3a452b60-51b7-5ddc-874e-12e6700c8005', '5db5a8d8-fab9-5969-9c94-e595ed9267aa', '6fd3fc33-e3db-595a-a973-7967c0469ca6', 'f53f9f28-16bb-5349-a7d9-a3b69c334298', '48f3e5a8-8ced-57a6-9b00-4d5794ed4dd4', '1ea96d32-61f6-596f-8ba3-de15278076bc', 'ad16f401-eb6f-593c-a90c-07f819cc0d58', '390d080b-349c-538c-9250-acd59fd6c1c3', '462d9345-5c31-5111-8ce8-314de8fd5caa', 'da303622-b350-5b8b-9b6d-370d9728bb8e', '902f8a7c-6687-5818-814b-a17e2eef1444', '32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '013e8407-3e0a-5ecc-af47-acfb7edf86d9', '57545cb8-cc45-5e9a-acc6-42102f111e27', 'ee916acc-ccc1-509c-934c-be74d6578dc8', 'c3be55d8-8928-58bb-bd27-181af4a0d5e3', '9f28f12e-250e-5f6c-9fe4-d5c4de564764', '402518e0-c2ac-5c9c-86c9-8db84a66c20a', 'fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', '349da296-708e-512c-98a5-f79c0d32d5fd', 'dd9dffa7-3d7a-5ecc-a39f-486149eb142f', '6d753d89-3393-5d46-80cb-7105df4178f0', '279267c3-6b7e-528e-a57e-a4ab75cfd473', 'a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', '1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '9552a62c-6941-5408-b0ca-cb7b41978a9b', '4a556f41-88ff-55ab-b724-0ab31deddf69', '78208151-f432-5986-89c6-95d2261fe015', '277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '75194e7f-9c18-5bb3-b70d-cac4a264bee3', '2557f68b-d1fe-54ce-89df-1820a60e498f', '78bec8e7-42c1-5dda-80fd-20ba4136196d', '9829779a-863f-5a57-88b7-21254e3d8e69', 'fc04747b-aebe-5c37-a221-d25b5c3dcc39', 'c226d66f-23d6-5e65-ba82-2229c946b41c', '9f2d069b-fa0b-5f5c-9903-f395c6ade85b', '79afc241-0f21-57eb-b2de-d9c503d9d75c', '3248e070-6326-5ec2-9a5c-9a6562bf3d43', 'a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', 'c5b5be7e-f4ab-55b6-a38e-181570ee31d9', 'b71e28ea-6533-5302-b2c9-9ddad3b2c439', 'cf42ec20-80b2-537e-a00e-3c58063c62ff', '0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '1886b0c7-fccb-565d-92ff-f84e3a6993f4', 'e072540f-1856-5eac-9a8e-db19cec747e6', 'a9e2968b-a92d-5746-9362-164238da0854', '7989200f-316a-50cf-a23b-c990be75e64e', '43b02806-bc22-570c-b797-0b37b895db64', '8fdfff8c-ddbd-5448-85e5-83a9f52730c9', 'c961b0e5-2864-5565-abe0-a6579f21445f', '86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '02029c31-8bc4-5e35-8816-cce63c913e55', '01868ac1-1c85-531f-b957-c922c262d7c3', '5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', 'b3509320-48b2-5d64-b94a-277dd38e4efd', '741a817a-a456-5c11-aca4-40c0f9dd6d99', '850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '659c49ec-4a06-519d-aba8-8a72e9ad1b81', '9f51a9e2-ac5e-5418-9bce-61475a0c46c0', 'f5610d0d-6e08-5683-8742-12e78f2babaf', '7996acd6-f402-5397-b872-795a696c4bb7', '1dd1def4-86e5-5073-9b3f-49d80a876b39', 'a3576e59-8351-52db-963a-e23eb337b92f', '89ca831c-9475-5039-bc24-33bc96445b41', 'd5b41c1a-0a53-5c06-915c-102435d5c6c0', 'c4d34b52-281d-57e3-8460-aafe4175f0f5', '145aa30d-c72c-5e4d-9190-f15b093dd84f', '26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'b165d39a-8b1a-559a-bc93-6ef918be4194', '94522885-b8e2-5f36-becc-435d20c867e2', '719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'a209293d-9928-57f6-8315-b45fbd4f39e3', '0c4cb780-1da9-5b34-bd95-073216e9116a', 'f4aafc66-106d-5f85-918e-89cb6ca105d1', '1ddeacd6-9014-5387-85ab-5ebca4c59ff1', '71e33276-0916-5dbf-9e87-3633f36b26be', '6f165226-6514-5ab3-8be5-8e7b31368205', 'c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '97062025-2da0-52e1-b0a4-2dd3e6625115', 'ffba2614-6e95-5898-af20-4f54e0cfbf82', 'cd11e9b8-d66b-5df5-9042-1f71a4c1c943', 'ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', '7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', '11d6470e-14ec-5d4c-a173-f08aa8b53c8f', '98ae61e1-b215-5802-96f7-52e519f394d4', '63217691-5552-58cf-91f9-4fb34905a0ef', 'a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', '20c26877-8f50-5441-a3b2-64b75b441c2e', 'c62b1670-17ff-5d0e-b684-935a306288ac', 'ba8523d7-f226-5903-93dd-45435cff9844', 'fe1d97ca-88d0-5ee4-8fec-4f0ee037391e', 'b023da2d-36db-500b-ad6f-ce9794159a3f', '2aae1e21-eb52-5560-987a-f08b84c1c0ec', 'd9e00dc9-ff59-55d0-9648-d429ed81295c', 'c76b8b99-9da2-5728-9cb2-f075223db346', '4935e3cb-7a61-50a1-b744-1f0b34d7815f', '1da5ec88-b844-5781-97cc-219745da8727', '3286e813-6caa-57ff-a8e3-c3606cb69310', '4ae0793a-71f0-59d6-9e51-a31b37912048', 'f68a2c08-9617-5c02-a318-9e30a4619989', 'a387198b-d83b-52a6-9faf-fd4740453fb6', '53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', '44355f34-9f8c-53a1-aadb-81d5245d24b4', '72cf3144-6f03-53f3-a57f-d413730520ed', '684457b0-f151-5355-b7de-b1cc7331c8e0', '78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '118a1f96-6010-503b-a5bf-8d5a7fd05817', '2b2d3600-2cf9-5aa0-af06-ba7393c39024', '74caaa9d-d014-5673-8f8b-9c0121dc06c6', '481b204d-67d0-5c6e-b6f3-01c13e92b87e', 'da568abe-ed24-5c8b-87a8-366cf878cc44', '5dfbba67-23ca-5232-bd3a-a66957add243', '30ac2283-9c21-5f32-b50c-f55d02072c39', '509c6467-c2af-55d2-a464-d762a3a5f71a', 'c1b432f1-1cbc-574c-9660-5b7227a13d3a', '843870fc-8656-51d5-9c26-be88398192c7', '6dd765f8-f95a-54ac-9410-d82ad64ccace', '731275d6-6544-592f-a0bb-fd317ea9e825', 'd6e08b0d-d37d-534e-b7a3-fbc2929aa0bd', 'de922d60-b93c-52b8-9755-7ab94294ffd5', '3c2a16fe-94a8-5a71-beb6-413d5b472af7', '99bb5c63-3dc9-5203-88e2-3d6ecca98e13', 'ad44e9d8-fe1d-59d3-b518-2ea51b2a627c', '9b84ac2b-88c1-5e10-9ee7-a729713042ff', 'ed2c07e1-18f2-5a28-bdef-32269895079f', 'bdf11453-1d14-5f95-abf0-44c6b17b044b', 'ba4e859e-bd3f-50f4-86dd-36c0f4dc5c28', 'aa5b50d9-2c3d-57bc-80ef-83cf5473969c', '70814d98-d38e-52c0-8bd8-07f160d3afbb', '5acdc554-2621-5a4d-80f2-35310f2af5ef', '5b47820d-916f-58b9-a0d0-90c7eaff3938', 'd3ac0c0c-72d4-5c36-9af4-3e55e2bf61e3', '18944ced-9590-5b65-95c2-9b4e16b20d32', 'ca816cf8-5b8a-5807-9faf-b8115134aef4', 'f5b7882d-e334-5f41-bc99-df08d8742957', 'd4ecd2b9-807e-528e-8f74-5f0fa9e018bd', '42e3e7ea-b563-569c-90f5-b9b015b4ec33', '58334796-1688-507d-85b4-8d0f606d7eda', '9b59a2c4-f6dd-5ebf-846e-46ebc1fccfe2', '7f995235-7d0c-5578-977f-0367685bca7f', '6e40940f-e9de-597e-85f5-7a3a40f49971', '79d5ca59-ee45-54f7-b1a6-f94d0dcb221a', '82494c50-b2fd-5b15-ab67-5e6fd86d4058', 'c92e82a7-ebc6-5634-ba6d-67c111412e90', '76b801e8-7fda-5047-80f1-b82276886214', '59185207-289a-5a7b-878e-da52a9432e1d', '5df534a9-e67a-5969-a2c5-ad81ce85ec17', 'f4f69f32-d96d-5306-9ce3-7144a7664518', '9d18f897-c064-5575-bdf5-1eaf14cf48d1', 'c6e6d69e-f89f-589a-8d51-28ac9ed8fd2c', '73c5df4e-c223-5c0f-a812-7e7a6f85435d', '7a43e475-982f-58ea-aefc-70c672df20e2', '3562c6fd-8a22-558d-981c-69692e31fd0c', '0adab7d5-1c45-5d95-acce-c328c8f0dcf1', '36414703-691f-5aaf-85e9-9f664293de54', '80de5c70-358d-5f68-a4fe-c16457e56b24', 'b0d22343-a40f-5803-a63a-2d20027a1008', '9577d052-f65b-5fbb-9340-6341c231d3e2', '62cc893d-b490-5003-99db-a0a33132fb14', 'cda6ae4e-68e6-5e12-ae28-ae797997cbb7', '45de69e9-1de5-50f2-9f60-b4106d6397fb', '63b1b105-f43d-5d32-9238-bbf6fb14414b', '8c6fd010-6c6c-59dd-b928-aad83f83dec6', '079b30d7-3f60-59f7-a3aa-b1ef79ac3e78', '85188fa4-904b-567e-adf6-02a36c162396', '3c7fb0e5-23a9-5967-86c0-9ac82d0a5214', 'bb1df896-3806-5d03-9230-d9531cce5f93', '21c615c8-3484-52ef-8a08-9730c3daf203', '0b5540ce-a308-572a-8039-4e8cc0e980c5', '4ab8c800-399f-5877-9a19-a7885c560245', '02017d0d-9d9f-5fb3-a665-b8f263b9db89', 'cb662391-35a7-50c2-909c-081c92409fb5', '8efce0dd-10b4-5f6f-ae30-384ebdff0e63', '537e935a-652f-5111-8613-25656b00ad2e', '97e40233-213f-51fd-a7f1-f0bf0f053109', 'fb518c59-c56f-512e-b186-78d6542ecffd', '0d7f1d4a-b5cf-512f-9b50-88ac74c5e953', 'e04c9ac5-3c55-5ec1-8cb2-ef8646730baf', '316620e5-8554-5638-8f9d-5fd49771dd20', 'b2f60586-bf58-5a2d-b577-39ed8ac710dc', '037153f1-ec0e-5896-a66e-4371cc4ce27f', 'bdce6c1c-e193-542b-82a4-aa2d0b8fa00d', '0d8b0540-5dff-544a-9e9c-7de7022890e7', 'ba654174-6d8d-52bd-9e69-852833432ecd', '9b387f8f-8611-5635-929f-c59100149417', 'a1db5805-5ef7-57c2-a2e3-3e4704b633e4');
DELETE FROM public.chapters c WHERE c.subject_id = 'english' AND c.id NOT IN ('6c5876d5-c564-5362-9ec4-db66068dd428', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'ff2b7070-d893-5229-bd8c-2b042dee6081', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', '2bd52d30-882a-5849-a561-66dad79c756d', '9b958e8f-0a4d-5299-aedc-ca62d7866435', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', '28c49d05-7851-5d81-b041-e443203e34d3') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Present Tenses', 'Present simple vs present continuous: form, uses, time markers and stative verbs', '# ⚔️ Present Tenses — Your First Weapon

> 💡 "Choose your tense like a weapon: the **simple** for what is always true, the **continuous** for what is happening right now."

## 🏰 The Present Simple

We use the present simple for **habits, routines, facts and general truths**.

- **Form**: subject + base verb (add **-s / -es** for he / she / it).
  - _I / you / we / they **play**._
  - _He / she / it **plays**._
- **Negative**: don''t / doesn''t + base verb. _She **doesn''t play**._
- **Question**: Do / Does + subject + base verb? _**Does** she **play**?_

> 🗡️ Spelling of the third person: _go → goes_, _study → studies_, _watch → watches_.

## ⚡ Time markers of the Present Simple

These words signal a habit or routine:

- **Adverbs of frequency**: always, usually, often, sometimes, rarely, never.
- **Expressions**: every day, every week, on Mondays, twice a week.

_He **usually** gets up at six. We play football **every** Saturday._

## 🛡️ The Present Continuous

We use the present continuous for **actions happening now** or **around now**.

- **Form**: am / is / are + verb**-ing**.
  - _I **am working**. She **is working**. They **are working**._
- **Negative**: am/is/are + **not** + -ing. _He **isn''t sleeping**._
- **Question**: Am/Is/Are + subject + -ing? _**Are** you **listening**?_

## 📐 Time markers of the Present Continuous

- now, right now, at the moment, at present
- **Look! / Listen!**, today, these days

_**Look!** The baby **is crying**. I **am reading** an interesting book **these days**._

## 🔮 Simple vs Continuous

| Present Simple              | Present Continuous               |
| --------------------------- | -------------------------------- |
| habit / routine             | action happening now             |
| general truth               | temporary action                 |
| _Water **boils** at 100°C._ | _The kettle **is boiling** now._ |

## 🧪 Stative verbs

Some verbs describe **states**, not actions, and are **not** normally used in the continuous:
_like, love, hate, want, need, know, understand, believe, seem, **be**, have (= possess)_.

> ⚠️ Say _I **know** the answer_ (not "I am knowing"). Say _This cake **tastes** good_ (not "is tasting").

> 🏆 You now control the present. Next, we travel to the **past tenses**.', '# 📜 Summary: Present Tenses

- **Present simple** = habits, routines, facts, general truths. Add **-s/-es** for he/she/it. Negative/question with **do/does**.
- Time markers: always, usually, often, sometimes, never; every day, on Mondays.
- **Present continuous** = am/is/are + **verb-ing**, for actions happening **now** or around now.
- Time markers: now, right now, at the moment, Look!, Listen!, these days.
- **Simple vs continuous**: _Water boils at 100°C_ (truth) vs _The kettle is boiling_ (now).
- **Stative verbs** (like, know, want, understand, be, have=possess) are **not** used in the continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Past Tenses', 'Past simple, past continuous, and present perfect: form, uses, time markers and how to choose between them', '# ⚔️ Past Tenses — Journey Through Time

> 💡 "The past is your archive: **simple** for completed events, **continuous** for the scene behind the action, **perfect** for experiences that still matter now."

## 🏰 The Past Simple

We use the past simple for **completed actions at a specific time in the past**.

- **Regular verbs**: add **-ed** (or just **-d** if the verb ends in -e).
  - _walk → walked_, _study → studied_, _stop → stopped_ (double the consonant)
- **Irregular verbs**: must be memorised — there is no rule!
  - _go → went_, _see → saw_, _take → took_, _buy → bought_, _write → wrote_, _have → had_, _make → made_, _come → came_, _give → gave_, _tell → told_
- **Negative**: **did not (didn''t)** + base verb. _She **didn''t go** to school yesterday._
- **Question**: **Did** + subject + base verb? _**Did** you **see** the match?_

> 🗡️ Never add **-ed** after **did**: say _Did she **go**?_ NOT ~~Did she went?~~

## ⚡ Time Markers of the Past Simple

These words indicate a completed past event:

- yesterday, last night / last week / last year
- ago (two days **ago**, a month **ago**)
- in + year: in 2022, in the 19th century
- when + past: _When I was young, I **played** in the street._

## 🛡️ The Past Continuous

We use the past continuous for **an action that was in progress at a specific moment in the past**.

- **Form**: **was / were** + verb**-ing**
  - _I / he / she / it **was sleeping**. We / you / they **were sleeping**._
- **Negative**: was/were + **not** + -ing. _They **weren''t listening**._
- **Question**: Was/Were + subject + -ing? _**Were** you **studying** at 8 p.m.?_

## 🔮 Past Simple vs Past Continuous (when / while)

The most common pattern: the **continuous** gives the background, the **simple** interrupts it.

| Connector | Structure                                       | Example                                                  |
| --------- | ----------------------------------------------- | -------------------------------------------------------- |
| **when**  | past simple interrupts past continuous          | _I was cooking **when** the phone **rang**._             |
| **while** | two continuous actions at the same time         | _**While** I was reading, she was listening to music._   |
| **while** | continuous = background + simple = interruption | _**While** he was walking home, it **started** to rain._ |

> ⚠️ **When** the phone rang (= at the moment it rang) signals a short completed event → past simple. **While** I was cooking (= during the cooking) → past continuous.

## 🧪 The Present Perfect

We use the present perfect for:

1. **Life experiences** (at an unspecified time): _Have you ever **visited** Carthage?_
2. **Recent past with a connection to now**: _She has just **finished** her homework._
3. **Completed action with a result**: _I''ve **lost** my keys._ (I can''t find them now!)

- **Form**: **have / has** + **past participle**
  - _I / you / we / they **have seen** it. He / she / it **has seen** it._
- **Negative**: have/has + **not** (haven''t / hasn''t). _He **hasn''t arrived** yet._
- **Question**: Have/Has + subject + past participle? _**Have** you **eaten** breakfast?_

## 🌟 Key Adverbs of the Present Perfect

| Adverb      | Position                                        | Example                                               |
| ----------- | ----------------------------------------------- | ----------------------------------------------------- |
| **ever**    | between subject and past participle (questions) | _Have you **ever** tried sushi?_                      |
| **never**   | between have/has and past participle            | _I have **never** flown in a plane._                  |
| **just**    | between have/has and past participle            | _She has **just** left the room._                     |
| **already** | between have/has and past participle            | _They have **already** finished._                     |
| **yet**     | end of negative or question                     | _Has he arrived **yet**? / He hasn''t called **yet**._ |

## ⚔️ Present Perfect vs Past Simple

The key question: do you know **when** it happened?

| Present Perfect                            | Past Simple                                    |
| ------------------------------------------ | ---------------------------------------------- |
| Time is **unspecified** or **unimportant** | Specific time is **mentioned**                 |
| _I **have seen** that film._               | _I **saw** that film **last Sunday**._         |
| _She **has lived** in Sfax._               | _She **lived** in Sfax **from 2010 to 2015**._ |
| Uses: ever, never, just, already, yet      | Uses: yesterday, ago, last…, in + year         |

> 🏆 You now command the past! Next chapter: the **future tenses**.', '# 📜 Summary: Past Tenses

- **Past simple** = completed action at a specific time. Regular verbs: add **-ed**. Irregular verbs must be memorised (_go→went, see→saw, take→took_). Negative/question with **did**.
- Time markers: yesterday, last week, ago, in + year, when.
- **Past continuous** = **was/were + verb-ing**, for an action in progress at a past moment. Negative/question with was/were.
- **when/while pattern**: past continuous (background) + past simple (interruption). _I was cooking **when** the phone **rang**._
- **Present perfect** = **have/has + past participle**, for experiences (ever/never), recent events (just), and completed actions with present results.
- Key adverbs: **ever** (questions), **never**, **just**, **already** (after have/has); **yet** (end of negative/question).
- **Present perfect vs past simple**: no specific time → perfect; specific time mentioned → past simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'The Future', 'will, be going to, and present continuous for the future: uses, time markers, and time clauses', '# 🔮 The Future — Unlock Tomorrow

> 💡 "Choose your future weapon carefully: **will** for the unexpected decision, **going to** for your battle plan, the **present continuous** for the appointment already in the calendar."

## 🏰 "Will" — Predictions, Decisions and Promises

Use **will** in three key situations:

1. **Prediction** (based on opinion or belief, no visible evidence): _I think it **will rain** tomorrow._
2. **Decision made at the moment of speaking** (spontaneous): _The phone is ringing — I**''ll get** it!_
3. **Promises and offers**: _I **will help** you with your homework. / **Will** you **carry** this for me?_

- **Form**: subject + **will** + base verb (same for all persons)
  - _I / you / he / she / we / they **will go**._
- **Negative**: **will not (won''t)** + base verb. _She **won''t tell** anyone._
- **Question**: **Will** + subject + base verb? _**Will** you **come** to the party?_
- **Short form**: I''ll, you''ll, he''ll, she''ll, we''ll, they''ll.

> 🗡️ Never add **-s**, **-ed**, or **-ing** to the base verb after **will**: _He **will go**_, NOT ~~He will goes~~.

## ⚡ "Be Going To" — Intentions and Evidence-Based Predictions

Use **be going to** in two key situations:

1. **Intention or plan already decided**: _We **are going to visit** Carthage next weekend._ (we planned it)
2. **Prediction based on present evidence**: _Look at those clouds — it **is going to rain**!_

- **Form**: **am / is / are** + **going to** + base verb
  - _I **am going to study**. He **is going to study**. They **are going to study**._
- **Negative**: am/is/are + **not** + going to + base verb. _I**''m not going to** miss the bus._
- **Question**: Am/Is/Are + subject + going to + base verb? _**Is** she **going to** take the exam?_

## 🛡️ Will vs Be Going To

|            | **will**                               | **be going to**                                    |
| ---------- | -------------------------------------- | -------------------------------------------------- |
| Decision   | Made NOW while speaking                | Already decided BEFORE speaking                    |
| Prediction | Opinion / belief                       | Based on visible evidence                          |
| Example    | _"I''ll have the soup."_ (just decided) | _"He''s going to fall!"_ (you can see it happening) |

> ⚠️ Both can express future predictions, but the source of evidence makes the difference.

## 🔮 Present Continuous for Fixed Future Arrangements

When a future event is **already arranged** (time, place, other people involved), use the **present continuous**:

- _I **am meeting** Dr Ben Ali at 9 a.m. tomorrow._ (appointment in the diary)
- _They **are flying** to London next Monday._ (tickets booked)

> This is very similar to "be going to" for plans, but present continuous stresses that the arrangement is **fixed and confirmed** with others.

## 🌟 Future Time Markers

These words signal the future:

- **tomorrow**, the day after tomorrow
- **next** + period: next week, next month, next year, next Monday
- **soon**, in a moment, in + future time: in two days, in 2030
- **tonight**, this afternoon, this evening

_She **will finish** her project **tomorrow**. We**''re going to** travel **next summer**._

## ⚔️ Time Clauses: when / as soon as + Present

> 🔑 Rule: after **when**, **as soon as**, **before**, **after**, **until** in a **future** sentence, use the **present simple** — NOT will!

| ✅ Correct                                     | ❌ Wrong                          |
| ---------------------------------------------- | --------------------------------- |
| _Call me **when** you **arrive**._             | ~~Call me when you will arrive.~~ |
| _**As soon as** he **finishes**, we will eat._ | ~~As soon as he will finish...~~  |
| _She will call you **before** she **leaves**._ | ~~before she will leave~~         |

> 🏆 Future tenses mastered! Next: **modal verbs** — the power-ups of English grammar.', '# 📜 Summary: The Future

- **will** = prediction (opinion/belief), spontaneous decision made while speaking, promise or offer. Form: **will + base verb** (no -s/-ed/-ing). Negative: **won''t**.
- **be going to** = intention already decided before speaking, or prediction based on visible evidence. Form: **am/is/are + going to + base verb**.
- **will vs going to**: _"I''ll have the soup"_ (decided now) vs _"We''re going to visit Carthage"_ (plan already made) vs _"It''s going to rain"_ (dark clouds visible).
- **Present continuous** = fixed future arrangement (time/place/people confirmed). _I am meeting her at 9 a.m. tomorrow._
- Time markers: tomorrow, next week/month/year, soon, tonight, in + future time.
- **Time clauses** (when, as soon as, before, after, until): use **present simple** after them in a future sentence — NEVER will. _Call me when you **arrive**._', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Modal Verbs', 'can/could, must/have to, should/ought to, may/might: ability, obligation, advice, possibility and key form rules', '# 🧙 Modal Verbs — The Power-Ups of English

> 💡 "Modals are power-ups: they change the meaning of the main verb without changing its form. Master them and you control ability, permission, obligation, and possibility."

## 🏰 Key Form Rules

Before exploring each modal, learn these universal rules — they apply to **all** modals:

- Modal + **base verb** (no -s, no -ed, no -ing, no to).
  - _She **can swim**._ (NOT ~~She can swims~~)
  - _He **must leave**._ (NOT ~~He must to leave~~)
- **Negative**: modal + **not** + base verb (contractions: can''t, couldn''t, won''t, mustn''t, shouldn''t, mightn''t).
- **Question**: modal + subject + base verb (no do/does/did).
  - _**Can** you help me?_ (NOT ~~Do you can help?~~)
- **Exceptions**: **have to** and **ought to** include "to"; they follow different question patterns.

> 🗡️ Never write ~~She cans play~~ or ~~He musts go~~. Modals never take -s.

## ⚡ Can / Could — Ability, Possibility, Permission, Requests

| Use                   | Modal         | Example                                        |
| --------------------- | ------------- | ---------------------------------------------- |
| Ability (present)     | **can**       | _I **can** speak three languages._             |
| Ability (past)        | **could**     | _When I was five, I **could** read._           |
| Possibility           | **can/could** | _Smoking **can** damage your health._          |
| Permission (informal) | **can**       | _**Can** I use your pen, please?_              |
| Request (polite)      | **could**     | _**Could** you open the window?_ (more polite) |

> ⚠️ **Could** is also the past of **can**: _Last year she **couldn''t** swim; now she **can**._

## 🛡️ Must / Have To — Obligation

Both express obligation, but there is an important difference:

| Modal       | Source of obligation                       | Example                                |
| ----------- | ------------------------------------------ | -------------------------------------- |
| **must**    | Personal feeling / the speaker''s authority | _I **must** call my mother tonight._   |
| **have to** | External rule or authority                 | _Students **have to** wear a uniform._ |

- **Negative contrast** — this is crucial:
  - **mustn''t** = prohibition (you are NOT allowed to do it). _You **mustn''t** smoke here._
  - **don''t have to** = no obligation (you are free to choose). _You **don''t have to** come if you''re tired._

> 🔑 _You **mustn''t** tell anyone_ ≠ _You **don''t have to** tell anyone_. The first forbids it; the second merely says it isn''t required.

## 🔮 Should / Ought To — Advice

Use **should** or **ought to** to give advice or express what is the right or expected thing to do:

- _You **should** study more if you want to pass._ (advice)
- _He **ought to** apologise._ (moral expectation)
- **Negative**: **shouldn''t** (you shouldn''t stay up late) / **ought not to**.
- **Question with should**: _**Should** I bring anything to the party?_

> 💡 **Should** and **ought to** have the same meaning. **Should** is far more common in everyday English.

## 🌟 May / Might — Possibility and Permission

| Use                        | Modal       | Example                                           |
| -------------------------- | ----------- | ------------------------------------------------- |
| Possibility (quite likely) | **may**     | _It **may** be cold tonight — take a jacket._     |
| Possibility (less certain) | **might**   | _I **might** go to the party — I''m not sure yet._ |
| Permission (formal)        | **may**     | _**May** I leave the room, please?_               |
| Permission (negative)      | **may not** | _You **may not** use your phone during the exam._ |

> ⚠️ **Might** suggests even less certainty than **may**. In practice, students can use them interchangeably for possibility.

## ⚔️ Modals at a Glance

| Modal        | Main uses                        | Negative form             |
| ------------ | -------------------------------- | ------------------------- |
| **can**      | ability, permission, possibility | **can''t / cannot**        |
| **could**    | past ability, polite request     | **couldn''t**              |
| **must**     | strong obligation (personal)     | **mustn''t** (prohibition) |
| **have to**  | obligation (external rule)       | **don''t/doesn''t have to** |
| **should**   | advice, recommendation           | **shouldn''t**             |
| **ought to** | advice, moral duty               | **ought not to**          |
| **may**      | possibility, formal permission   | **may not**               |
| **might**    | weak possibility                 | **might not**             |

> 🏆 You have unlocked the modal power-ups! Next: **Conditionals** — the if-then power combos of English.', '# 📜 Summary: Modal Verbs

- **Universal form rules**: modal + **base verb** (no -s, no -ed, no -ing). Negative: modal + not. Question: modal + subject + base verb (no do/does). Exceptions: **have to** and **ought to** include "to".
- **can** = present ability, informal permission, possibility. **could** = past ability, polite request/permission.
- **must** = strong personal obligation. **have to** = external obligation (rules/authority).
- **mustn''t** (prohibition — NOT allowed) vs **don''t have to** (no obligation — free to choose). These are opposite in meaning!
- **should / ought to** = advice or recommendation. Negative: **shouldn''t**. Use should in questions: _Should I bring anything?_
- **may** = possibility (fairly likely) or formal permission. **might** = weaker possibility. Neither takes -s or -ed.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Conditionals', 'Zero, first, and second conditionals: form, uses, if-clause position, comma rules, and unless', '# ⚡ Conditionals — The If-Then Power Combos

> 💡 "Every conditional is a deal: the if-clause sets the condition, the main clause delivers the consequence. Get the tenses right, and you unlock the full power of possibility."

## 🏰 Zero Conditional — General Truths

Use the zero conditional for **facts, scientific truths, and things that always happen** when a condition is met.

- **Form**: **If + present simple, present simple**
  - _If you heat water to 100°C, it **boils**._
  - _If it **rains**, the ground **gets** wet._
  - _Plants **die** if they **don''t** get water._

> 🗡️ Both clauses use the **present simple** because the result is always, certainly true — it is not a prediction or a hypothesis.

## ⚡ First Conditional — Real Future Situations

Use the first conditional for **real or likely situations in the future**.

- **Form**: **If + present simple, will + base verb**
  - _If you **study** hard, you **will pass** the exam._
  - _If it **rains** tomorrow, we **won''t go** to the beach._
  - _She **will be** angry if you **are** late._

> 🗡️ The if-clause uses the **present simple** — NEVER will in the if-clause! The main clause uses **will** (or won''t).

## 🛡️ Second Conditional — Unreal / Hypothetical Situations

Use the second conditional for **imaginary, hypothetical, or unlikely situations in the present or future**.

- **Form**: **If + past simple, would + base verb**
  - _If I **had** a million dinars, I **would buy** a house._
  - _If she **lived** in Tunis, she **would visit** us more often._
  - _What **would** you do if you **won** the lottery?_

> ⚠️ With the verb **be** in the if-clause, use **were** for all persons in formal/standard English:
> _If I **were** you, I would apologise._ (NOT ~~If I was you~~)

> 🔑 The second conditional describes something **not real now** — the speaker does not have a million dinars, she does not live in Tunis.

## 🔮 First vs Second Conditional

|             | First Conditional        | Second Conditional                          |
| ----------- | ------------------------ | ------------------------------------------- |
| Situation   | **Real / likely** future | **Unreal / hypothetical** present or future |
| If-clause   | present simple           | past simple                                 |
| Main clause | **will** + base verb     | **would** + base verb                       |
| Example     | _If I study, I''ll pass._ | _If I studied all night, I would pass._     |

> 💡 Compare: _If it **rains** tomorrow, I **will** stay home._ (realistic possibility) vs _If it **rained** every day, this city **would** be a jungle._ (imaginary).

## 🌟 Position of the If-Clause and the Comma

The if-clause can come **first or second** in the sentence:

- **If-clause first**: use a **comma** after it.
  - _**If you practise every day**, your English will improve._
- **If-clause second** (after the main clause): **no comma**.
  - _Your English will improve **if you practise every day**._

> 🗡️ Comma rule: **comma only when the if-clause comes first**.

## ⚔️ "Unless" — The Negative Condition

**Unless** means **if … not**. It introduces a negative condition:

- _**Unless** you hurry, you **will** miss the train._ = _If you **don''t** hurry, you **will** miss the train._
- _I **won''t** go **unless** you come with me._ = _I **won''t** go if you **don''t** come._
- _**Unless** it **rains**, we play outside._ (zero conditional with unless)

> ⚠️ Do NOT use **unless** with a negative verb in the same clause — that creates a double negative: ~~Unless you don''t hurry~~ is wrong.

## 🧪 Summary Table

| Conditional | If-clause      | Main clause       | Use                   |
| ----------- | -------------- | ----------------- | --------------------- |
| **Zero**    | present simple | present simple    | General truths, facts |
| **First**   | present simple | will + base verb  | Real / likely future  |
| **Second**  | past simple    | would + base verb | Unreal / hypothetical |

> 🏆 Conditionals conquered! You can now express truths, plans, and dreams in English. Next: **the passive voice**.', '# 📜 Summary: Conditionals

- **Zero conditional** = If + present simple, present simple. General truths and facts that always happen. _If you heat ice, it melts._
- **First conditional** = If + present simple, will + base verb. Real or likely future situations. _If it rains, we will stay inside._
- **Second conditional** = If + past simple, would + base verb. Unreal or hypothetical situations (present/future). _If I had more time, I would learn guitar._
- **"were" rule**: In the second conditional, use **were** for all persons with "be": _If I were you, I would apologise._
- **If-clause position**: if-clause first → **comma** after it; if-clause second → **no comma**.
- **Unless** = if … not. _Unless you hurry, you will miss the bus._ Never combine unless with a negative verb in the same clause.
- Key contrast: First conditional = realistic (_If I study, I''ll pass._) vs Second conditional = hypothetical (_If I studied for 20 hours, I would pass._).', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'The Passive Voice', 'Form (be + past participle), present and past simple passive, turning active into passive, and when/why to use it', '# 🛡️ The Passive Voice — Shield Your Subject

> 💡 "In active voice the subject attacks; in **passive voice** the subject is attacked. Choose your stance wisely."

## 🏰 What is the Passive Voice?

In an **active** sentence, the subject performs the action.
In a **passive** sentence, the subject **receives** the action.

- Active: _The chef **cooks** the meal._ (subject = the chef, doing the action)
- Passive: _The meal **is cooked** by the chef._ (subject = the meal, receiving the action)

The passive shifts the focus from **who** does something to **what** is done to something.

## ⚔️ Form: be + Past Participle

The core formula is always the same regardless of tense:

> **Subject + correct form of BE + past participle (+ by + agent)**

The **past participle** is the third form of a verb (e.g. _cook → cooked_, _write → written_, _build → built_).

| Verb  | Past Participle |
| ----- | --------------- |
| cook  | cooked          |
| write | written         |
| build | built           |
| make  | made            |
| find  | found           |

## ⚡ Present Simple Passive

Replace the active present simple with **is / are + past participle**.

- Active: _Workers **build** the bridge._ → Passive: _The bridge **is built** by workers._
- Active: _They **speak** French here._ → Passive: _French **is spoken** here._
- Active: _She **cleans** the room._ → Passive: _The room **is cleaned** by her._

> 🗡️ Use **is** for singular subjects and **are** for plural subjects.

## 🛡️ Past Simple Passive

Replace the active past simple with **was / were + past participle**.

- Active: _Someone **stole** my bike._ → Passive: _My bike **was stolen**._
- Active: _They **built** the castle in 1400._ → Passive: _The castle **was built** in 1400._
- Active: _The teachers **tested** the students._ → Passive: _The students **were tested** by the teachers._

> 🗡️ Use **was** for singular subjects and **were** for plural subjects.

## 🔮 Turning Active into Passive — Step by Step

Follow these three steps every time:

1. Move the **object** of the active sentence to the **subject** position.
2. Put the verb **be** in the correct tense (is/are or was/were).
3. Add the **past participle** of the main verb.
4. (Optional) Add **by + the original subject** as the agent.

**Example:**

- Active: _Amina **wrote** the report._
- Step 1: _The report …_ (object → subject)
- Step 2: _The report **was** …_ (past simple passive)
- Step 3: _The report **was written** …_ (past participle of write)
- Step 4: _The report **was written by Amina**._ (add agent)

## 🧪 When / Why We Use the Passive

We prefer the passive when:

- The **agent is unknown**: _My wallet was stolen._
- The **agent is unimportant** or obvious: _Oil was discovered in the desert._
- We want to **focus on the result** or the object: _The Eiffel Tower was built in 1889._
- In **formal or scientific writing**: _The mixture was heated to 80°C._

> ⚠️ The **by + agent** phrase is often **omitted** when the agent is unknown, unimportant, or already obvious from context.

## 📐 Summary Table

| Tense          | Active                           | Passive                             |
| -------------- | -------------------------------- | ----------------------------------- |
| Present simple | _They grow rice here._           | _Rice **is grown** here._           |
| Past simple    | _They built the school in 1990._ | _The school **was built** in 1990._ |

> 🏆 You have mastered the passive shield! Next quest: **Reported Speech** — learn to pass messages like a ninja.', '# 📜 Summary: The Passive Voice

- **Passive form** = subject + **be** (correct tense) + **past participle** (+ by + agent).
- **Present simple passive**: is / are + past participle. _Rice **is grown** here._
- **Past simple passive**: was / were + past participle. _The castle **was built** in 1400._
- **Turning active → passive**: object becomes subject; keep the same tense with be; add past participle; "by + agent" is optional.
- **Use the passive** when the agent is unknown, unimportant, or when focus is on the result/object.
- **"by + agent"** is often omitted: _My bike was stolen._ (we don''t know who)
- Singular subject → **is / was**; plural subject → **are / were**.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Reported Speech', 'Direct vs reported speech, reporting verbs, tense backshift, pronoun changes, time/place word changes, reported questions and commands', '# 🗣️ Reported Speech — The Messenger Ninja

> 💡 "A ninja never repeats words exactly — they adapt the message to its new context. That is reported speech."

## 🏰 Direct vs Reported Speech

**Direct speech** quotes the exact words, written inside quotation marks.
**Reported speech** (also called _indirect speech_) reports what someone said without quotation marks, usually introduced by a reporting verb.

- Direct: _She said, **"I am tired."**_
- Reported: _She said **that she was tired**._

Notice: the verb **am** changes to **was**, and the pronoun **I** changes to **she**.

## ⚔️ Reporting Verbs: say, tell, ask

The three most important reporting verbs are:

| Verb     | Pattern                                     | Example                                   |
| -------- | ------------------------------------------- | ----------------------------------------- |
| **say**  | say (that) + clause                         | _He **said** that he was hungry._         |
| **tell** | tell + person + (that) + clause             | _She **told** me that the test was easy._ |
| **ask**  | ask + (person) + if/whether / question word | _He **asked** if she was ready._          |

> ⚠️ **tell** always needs a person (tell _me_, tell _him_, tell _the class_). **say** never takes a direct object person (_say me_ is wrong).

## ⚡ Tense Backshift

When the reporting verb is in the **past** (said, told, asked), the tense of the reported clause shifts **one step back** into the past.

| Direct tense       | Reported tense  |
| ------------------ | --------------- |
| present simple     | past simple     |
| present continuous | past continuous |
| past simple        | past perfect    |
| present perfect    | past perfect    |
| will               | would           |
| can                | could           |
| may                | might           |

**Examples:**

- "I **live** in Tunis." → He said he **lived** in Tunis.
- "She **is sleeping**." → He said she **was sleeping**.
- "They **have arrived**." → She said they **had arrived**.
- "I **will help** you." → He said he **would help** me.
- "I **can swim**." → She said she **could swim**.

## 🛡️ Changes of Pronouns

Pronouns change to match the new speaker''s perspective.

- "**I** am happy." → She said **she** was happy.
- "**We** are leaving." → They said **they** were leaving.
- "Can **you** help **me**?" → She asked if **I** could help **her**.

> 🗡️ Always think: who is speaking and who is listening _now_, then adjust the pronouns.

## 🔮 Changes of Time and Place Words

Time and place expressions also shift when the context changes.

| Direct speech | Reported speech                     |
| ------------- | ----------------------------------- |
| now           | then                                |
| today         | that day                            |
| yesterday     | the day before / the previous day   |
| tomorrow      | the next day / the following day    |
| last week     | the week before / the previous week |
| next year     | the following year                  |
| here          | there                               |
| this          | that                                |
| these         | those                               |

- "I will call you **tomorrow**." → She said she would call me **the next day**.
- "We met **here** **today**." → He said they had met **there** **that day**.

## 🧪 Reported Questions

To report a question, remove the question marks and quotation marks, and **reverse the word order** back to normal (subject before verb).

**Wh-questions** use the question word:

- Direct: "**Where** does he live?" → Reported: _She asked **where he lived**._
- Direct: "**What** did you do?" → Reported: _He asked **what I had done**._

**Yes/No questions** use **if** or **whether**:

- Direct: "**Are** you ready?" → Reported: _She asked **if I was ready**._
- Direct: "**Do** you like music?" → Reported: _He asked **whether I liked** music._

> ⚠️ No auxiliary verb inversion in reported questions: _she asked where **he lived**_ (NOT _where did he live_).

## 📐 Reported Commands

Commands (imperatives) are reported with **tell / ask + person + to + infinitive** (affirmative) or **not to + infinitive** (negative).

- "**Open** the window!" → She **told** him **to open** the window.
- "**Don''t run** in the corridor!" → The teacher **told** the students **not to run** in the corridor.
- "**Please sit down.**" → She **asked** us **to sit down**.

> 🏆 You are now a Reported Speech master! One final quest remains: **Relative Clauses & Comparatives**.', '# 📜 Summary: Reported Speech

- **Direct speech** = exact words in quotes. **Reported speech** = no quotes, introduced by say/tell/ask + that/if/whether.
- **say (that)** — no person object. **tell + person (that)** — always needs a person. **ask + (person) + if/whether/wh-word**.
- **Tense backshift** (reporting verb in past): present simple → past simple; will → would; can → could; present perfect / past simple → past perfect.
- **Pronouns** change to match the new speaker''s perspective: "I" → he/she, "we" → they, etc.
- **Time/place words**: now → then; today → that day; tomorrow → the next day; yesterday → the day before; here → there.
- **Reported wh-questions**: ask + question word + subject + verb (normal order, no inversion, no "?").
- **Reported yes/no questions**: ask + if / whether + subject + verb.
- **Reported commands**: tell/ask + person + **to** + infinitive; negative → **not to** + infinitive.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Relative Clauses & Comparatives', 'Defining relative clauses (who/which/that/whose/where), comparatives and superlatives of adjectives, as...as, and writing connectors', '# 🏆 Relative Clauses & Comparatives — The Final Combo

> 💡 "A great warrior uses every weapon in their arsenal. Relative clauses add precision; comparatives add power. Master both and your writing becomes unstoppable."

## 🏰 What is a Relative Clause?

A **defining relative clause** gives essential information about the noun it follows. Without it, the sentence would be unclear or incomplete. It is introduced by a **relative pronoun**.

- _The boy **who won the prize** is my brother._ (defines which boy)
- _The book **that she lent me** was fantastic._ (defines which book)

> ⚠️ A defining relative clause is NOT separated from the noun by a comma.

## ⚔️ Relative Pronouns: who, which, that, whose, where

| Pronoun   | Refers to           | Example                                              |
| --------- | ------------------- | ---------------------------------------------------- |
| **who**   | people              | _The teacher **who** inspired me retired last year._ |
| **which** | things / animals    | _The film **which** we watched was thrilling._       |
| **that**  | people or things    | _The city **that** I love most is Tunis._            |
| **whose** | possession (people) | _The girl **whose** bag was lost found it later._    |
| **where** | places              | _The school **where** I study has a great library._  |

> 🗡️ **whose** replaces a possessive: _The student whose phone rang …_ = the student''s phone rang.

## ⚡ Comparatives of Adjectives

We use comparatives to compare **two** things. The form depends on the adjective''s length:

**Short adjectives (one syllable, or two syllables ending in -y):**
Add **-er** (and **than** to introduce the second item).

| Adjective | Comparative  |
| --------- | ------------ |
| tall      | taller than  |
| fast      | faster than  |
| happy     | happier than |
| big       | bigger than  |

> 🗡️ Spelling rules: double the final consonant if the pattern is consonant–vowel–consonant (_big → bigger_); change -y to -ier (_happy → happier_).

**Long adjectives (two or more syllables, not ending in -y):**
Use **more … than**.

- _interesting → **more interesting than**_
- _beautiful → **more beautiful than**_
- _important → **more important than**_

## 🛡️ Superlatives of Adjectives

We use superlatives to compare **three or more** things and pick the top one. Use **the** before the superlative.

| Adjective   | Comparative      | Superlative          |
| ----------- | ---------------- | -------------------- |
| tall        | taller than      | the tallest          |
| fast        | faster than      | the fastest          |
| happy       | happier than     | the happiest         |
| big         | bigger than      | the biggest          |
| interesting | more interesting | the most interesting |
| beautiful   | more beautiful   | the most beautiful   |

_Tunis is **the largest** city in Tunisia._
_This is **the most difficult** question in the exam._

## 🔮 Irregular Comparatives and Superlatives

Some adjectives are completely irregular. You must memorise these:

| Adjective | Comparative            | Superlative             |
| --------- | ---------------------- | ----------------------- |
| good      | better than            | the best                |
| bad       | worse than             | the worst               |
| far       | farther / further than | the farthest / furthest |

_Her score is **better than** mine. His idea is **the best** of all._
_Traffic today is **worse than** yesterday. That was **the worst** film I have ever seen._

## 🧪 As … As (Equality)

To say two things are **equal**, use **as + adjective + as**:

- _Sami is **as tall as** his brother._ (they are the same height)
- _This exercise is **as difficult as** the last one._

For **inequality** (not equal), use **not as … as**:

- _This city is **not as big as** Tunis._

> ⚠️ The structure is always **as + adjective (base form) + as** — never use the comparative form inside this structure.

## 📐 Useful Writing Connectors

Good writing links ideas smoothly. Here are essential connectors you should use:

| Function           | Connectors                                             |
| ------------------ | ------------------------------------------------------ |
| Adding information | and, also, in addition, furthermore, moreover          |
| Contrasting        | but, however, although, even though, on the other hand |
| Giving a reason    | because, since, as                                     |
| Showing result     | so, therefore, as a result, consequently               |
| Giving an example  | for example, for instance, such as                     |
| Concluding         | in conclusion, to sum up, finally                      |

_He studied very hard; **therefore**, he passed the exam._
_**Although** the film was long, I enjoyed it._
_**In addition**, the school has a sports hall._

> 🏆 Congratulations, hero! You have completed the English grammar quest. Armed with tenses, passive, reported speech, relative clauses, comparatives, and connectors, you are ready for the national exam!', '# 📜 Summary: Relative Clauses & Comparatives

- **Defining relative clauses** give essential information about a noun. No comma before them.
  - **who** = people; **which** = things/animals; **that** = people or things; **whose** = possession; **where** = places.
- **Comparatives** compare two things: short adjectives add **-er than**; long adjectives use **more … than**.
  - Spelling: double consonant (_big → bigger_); -y → -ier (_happy → happier_).
- **Superlatives** pick the top from three or more: short adjectives add **-est**; long adjectives use **the most …**. Always use **the**.
- **Irregulars**: good → better → the best; bad → worse → the worst.
- **as … as** = equality (_as tall as_); **not as … as** = inequality. Always use the base adjective form inside.
- **Writing connectors**: adding (_also, furthermore_), contrasting (_however, although_), reason (_because, since_), result (_therefore, as a result_), example (_for example_), conclusion (_in conclusion_).', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Reading Comprehension & Writing', 'Read short texts with confidence and write clear paragraphs: find the main idea, scan for details, make inferences, resolve reference words, guess vocabulary from context, read connectors, and build well-organised paragraphs.', '# 📖 Reading Comprehension & Writing — Read Smart, Write Clear

> 💡 "A good reader is a detective: every text leaves clues. A good writer is a guide: every paragraph follows a path."

This chapter is your toolkit for the two big skills of the exam: **understanding a written text** and **producing a short, organised piece of writing** in English.

---

## 🔍 Part 1 — Reading Comprehension

### 🏰 1. Finding the main idea

The **main idea** is the single most important message of the whole text — not one small detail. To find it, ask: _"What is the writer mostly talking about? What would the title be?"_

- The main idea is often in the **first** or **last** sentence of a paragraph (the **topic sentence**).
- The other sentences usually **support** it with examples, reasons or details.

> 🗡️ Trap: a true detail is not the same as the main idea. "The text mentions a school garden" can be true but still be too small to be the main idea.

### ⚡ 2. Scanning for specific details

When a question asks _"How many…? When…? Who…? Where…?"_, you do not read everything — you **scan**. Move your eyes quickly, looking only for the **key word** in the question (a name, a number, a date, a place). Stop when you find it, then read that sentence carefully.

> 🛡️ Answer with what the text **says**, not with what you already know or guess.

### 🔮 3. Making inferences (reading between the lines)

An **inference** is a conclusion the text does **not** state directly but clearly suggests. You combine the clues with logic.

- _"Sami put on his coat, took his umbrella and looked at the grey sky."_ → We **infer** that it is going to rain. The text never says "rain", but the clues prove it.

> ⚠️ A good inference is **supported by the text**. If you cannot point to the clue, it is a guess, not an inference.

### 🧭 4. Reference words and pronouns

Writers avoid repeating words by using **reference words**: pronouns (_it, they, them, he, she, this, these, that_) and others. To understand a text, you must know what each one **points back to**.

- _"My brother bought a new phone. **It** was very expensive."_ → **It** = the phone.
- _"Students who revise daily pass easily. **They** rarely panic."_ → **They** = the students who revise daily.

> 🗡️ Rule of thumb: a pronoun usually refers to the **nearest matching noun** that came **before** it, and it must **agree** in number (singular/plural) and type (person/thing).

### 📚 5. Guessing vocabulary from context

You will meet unknown words. Do not stop — use the **context** (the words around) to guess the meaning.

- **Examples / lists**: _"reptiles such as snakes, lizards and **geckos**"_ → a gecko is a reptile.
- **Synonyms / definitions**: _"He was **furious**, that is, extremely angry."_
- **Contrast words** (but, however): _"The shop was tiny, **but** the storeroom was **spacious**."_ → spacious ≠ tiny, so it means roomy/large.

### 🔗 6. Connectors and their function

**Connectors** (linking words) show the **relationship** between ideas. Knowing their job helps you follow the writer''s logic.

| Function              | Connectors                                     |
| --------------------- | ---------------------------------------------- |
| Addition              | and, also, moreover, in addition, besides      |
| Contrast / opposition | but, however, although, yet, on the other hand |
| Cause                 | because, since, as, due to                     |
| Result / consequence  | so, therefore, thus, as a result               |
| Purpose               | to, in order to, so that                       |
| Example               | for example, such as, for instance             |
| Time / sequence       | first, then, after that, finally               |

> 🛡️ _"She studied hard, **therefore** she passed."_ → result. _"She studied hard, **but** she failed."_ → contrast.

---

## ✍️ Part 2 — Guided Writing

### 🏰 7. The topic sentence

A paragraph is about **one** main idea. The **topic sentence** states that idea — usually the **first** sentence. It should be:

- **Clear** (the reader knows the subject at once),
- **General enough** to cover the whole paragraph,
- but **not** just one tiny detail.

> 🗡️ Compare: _"Family life is important for many reasons."_ (good topic sentence) vs _"My cousin is twelve years old."_ (too narrow — only a detail).

### ⚡ 8. Organising a paragraph

A strong paragraph follows a clear order:

1. **Topic sentence** — announces the main idea.
2. **Supporting sentences** — give reasons, examples or details, in a logical order.
3. **Concluding / closing sentence** — sums up or gives a final thought.

> ⚠️ Every sentence must be **relevant**. A sentence that does not support the topic is an **irrelevant sentence** and should be removed.

### 🔗 9. Linking words in writing

Use connectors to join your ideas smoothly so the paragraph flows:

- Add ideas: _and, also, moreover._
- Show contrast: _but, however, although._
- Give reasons: _because, since._
- Show results: _so, therefore._
- Order ideas: _first, then, after that, finally._

> 🛡️ Choose the linking word by **meaning**: do not write "I was tired, **therefore** I went out" if you mean a contrast — use **but**.

### 🧱 10. A short guided paragraph (model)

**Task:** Write a short paragraph about the importance of reading.

> **Reading is one of the most useful habits a student can have.** First, it improves your vocabulary, **so** you write and speak more easily. **Moreover**, books open your mind to new ideas and faraway places. **Although** some people find it boring at first, the habit quickly becomes a real pleasure. **For these reasons**, every student should read a little every day.

Notice the structure: a clear **topic sentence**, **supporting ideas** linked with connectors (_first, so, moreover, although_), and a **closing sentence** (_for these reasons…_).

> 🏆 Read like a detective, write like a guide — and the exam text holds no surprises.', '# 📜 Summary: Reading Comprehension & Writing

## Reading

- **Main idea** = the whole text''s key message (often the topic sentence), not a small detail.
- **Scanning** = move fast and hunt only for the key word (name, number, date, place) to find a specific detail.
- **Inference** = a conclusion the text suggests but does not state; it must be supported by clues.
- **Reference words / pronouns** (it, they, this…) point back to the nearest matching noun before them; they must agree in number.
- **Vocabulary from context** = guess unknown words using examples, synonyms/definitions, or contrast words.
- **Connectors** show relationships: addition (also), contrast (but, however), cause (because), result (so, therefore), purpose (to), example (such as), time (first, then, finally).

## Writing

- **Topic sentence** = clear, general first sentence stating the paragraph''s one main idea.
- **Paragraph order** = topic sentence → supporting sentences (logical order) → closing sentence.
- **Linking words** join ideas smoothly; choose them by meaning (don''t use "therefore" for a contrast).
- **Irrelevant sentence** = one that does not support the topic — remove it.
- **Coherent continuation** = the next sentence must follow logically from the ones before.', 9)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Exam-Style Papers', 'Practise the full national exam (ختم التعليم الأساسي) in English: each paper gives you a reading text, then comprehension questions, language-in-context items and short writing tasks built on that same text. Learn to read carefully, use grammar accurately and write clearly under exam conditions.', '# 📝 Exam-Style Papers: Your Strategy Guide

The end-of-basic-education English exam (**ختم التعليم الأساسي**) is always built the
same way. If you know the shape of the paper, you can plan your time and pick up
easy marks. Every paper has three parts, all linked to **one reading text**:

1. **Reading comprehension** — questions about what the text says and means.
2. **Language** — grammar and vocabulary used _inside_ sentences from the text.
3. **Writing** — short tasks that test how you organise and connect ideas.

This chapter turns each part into clear QCM items so you can train the exact skills
the examiner rewards.

---

## Part 1 — Reading comprehension

You are given a text on a familiar theme: **Family Life, Education, Health &
Environment, Services, Entertainment** or **Civility**. Read it **twice**: once for
the general idea, once slowly for the details.

- **Main idea** — the whole message of the text or paragraph, not one small detail.
  It is often near the start or the end.
- **Specific details** — facts you find by _scanning_ for a key word (a name, a
  number, a place, a date).
- **Inference** — a conclusion the text _suggests_ but does not say directly. It must
  be supported by clues, never by your own opinion.
- **Reference words** — pronouns such as _it, they, this, these, such_ point **back**
  to the nearest matching noun. Always check what the word replaces.
- **Vocabulary in context** — guess an unknown word from the sentence: look for a
  synonym, a definition, an example, or a contrast word (_but, however_).
- **True / False / Not mentioned** — choose _Not mentioned_ when the text simply does
  not give the information; do not confuse it with _False_.

> Exam tip: every answer is **in the text**. If you cannot point to the line that
> proves your choice, choose again.

---

## Part 2 — Language in context

The language items test the grammar you studied in chapters 1–8, but always inside a
sentence taken from (or based on) the text. The most common points are:

- **Tenses** — present simple vs continuous, past simple vs present perfect, future
  forms. Match the time markers (_yesterday, since, already, next week_).
- **Modals** — _can, must, should, have to, might_ — choose by **meaning**
  (ability, obligation, advice, possibility).
- **Conditionals** — type 1 (_If it rains, we will…_), type 2 (_If I were…_),
  type 3 (_If he had studied, he would have passed_). The _if_-clause fixes the form.
- **Passive voice** — _be + past participle_. Use it when the doer is unknown or
  unimportant (_The bridge was built in 2010_).
- **Reported speech** — shift the tense back one step and change pronouns and time
  words (_"I am tired" → He said he was tired_).
- **Relative clauses** — _who_ (people), _which/that_ (things), _where_ (places),
  _whose_ (possession). The relative word stands for the noun before it.

> Exam tip: read the **whole** sentence before choosing. The right form depends on
> the words around the gap, not just the gap itself.

---

## Part 3 — Writing skills

The writing part is graded on **organisation and coherence**, not only on grammar.
The QCM items train the building blocks:

- **Topic sentence** — a clear, general first sentence that announces the paragraph''s
  one main idea (not an example, not a detail).
- **Logical order** — topic sentence → supporting sentences in a sensible order →
  closing sentence. Connectors (_first, then, however, therefore, finally_) show the
  order.
- **Linking words** — choose them by meaning: addition (_also_), contrast
  (_but, however_), cause (_because_), result (_so, therefore_), example
  (_such as, for instance_).
- **Unity** — every sentence must support the topic; remove any sentence that drifts
  off the subject.
- **Coherent continuation** — the next sentence must follow logically from what comes
  before; it cannot contradict it or jump to a new topic.

> Exam tip: a good paragraph says **one** thing well. Decide your idea first, then
> support it step by step.

---

## How to use the papers

- **Paper 1 (Practice)** — a gentle full paper to learn the routine.
- **Paper 2 (Boss)** — a harder paper under tighter time, like the real exam.
- **Challenge (Défi)** — a demanding paper for those aiming at the top mark.

Work calmly, prove each answer from the text, and check your grammar before you move
on. That is exactly how marks are won on exam day.', '# 📜 Summary: Exam-Style Papers

## The paper has three parts (all on one text)

1. **Reading comprehension** — what the text says and means.
2. **Language in context** — grammar inside the text''s sentences.
3. **Writing skills** — organising and connecting ideas.

## Reading

- **Main idea** = the whole message, not one detail; often near the start/end.
- **Detail** = scan for a key word (name, number, place, date).
- **Inference** = a conclusion the text suggests; must be backed by clues.
- **Reference words** (it, they, this, such) point back to the nearest matching noun.
- **Vocabulary in context** = guess from synonym, definition, example or contrast.
- **Not mentioned** ≠ **False**: choose it when the info is simply absent.

## Language

- **Tenses**: match the time markers (yesterday, since, already, next week).
- **Modals**: choose by meaning (ability, obligation, advice, possibility).
- **Conditionals**: type 1 will + base; type 2 would + base; type 3 would have + p.p.
- **Passive**: be + past participle (doer unknown/unimportant).
- **Reported speech**: shift tense back, change pronouns and time words.
- **Relative clauses**: who (people), which/that (things), where (place), whose (possession).

## Writing

- **Topic sentence** = clear, general first sentence with the one main idea.
- **Order** = topic sentence → supporting sentences → closing sentence.
- **Linking words** = pick by meaning (also / however / because / therefore / such as).
- **Unity** = remove any sentence that drifts off the topic.
- **Coherent continuation** = the next sentence must follow logically.

> Golden rule: every answer is **in the text** — if you can''t point to the proof, choose again.', 10)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4f248a7-393a-5c6d-b4af-90311f1ae35d', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('080d7783-083d-5532-a30c-825175ef6d09', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Which sentence uses the present simple correctly to express a habit?', '[{"id":"a","text":"She is going to school every day."},{"id":"b","text":"She goes to school every day."},{"id":"c","text":"She go to school every day."},{"id":"d","text":"She has gone to school every day."}]'::jsonb, 'b', '"every day" marks a habit, which takes the present simple. With the third-person singular "she", add -es: she goes. "is going" is present continuous (now); "go" forgets the -es; "has gone" is present perfect (a result), not a habit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c8be484-cc52-575b-ac02-d7dd39f06af1', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Which time marker signals that the present continuous should be used?', '[{"id":"a","text":"every Monday"},{"id":"b","text":"usually"},{"id":"c","text":"at the moment"},{"id":"d","text":"twice a week"}]'::jsonb, 'c', '"At the moment" signals an action happening right now, which requires the present continuous (am/is/are + -ing).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('138d5e16-6d8d-5dde-8107-11d41bfa48e9', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Complete the sentence correctly: "Look! The children ___ in the garden."', '[{"id":"a","text":"play"},{"id":"b","text":"plays"},{"id":"c","text":"have played"},{"id":"d","text":"are playing"}]'::jsonb, 'd', '"Look!" is a key signal for the present continuous because it draws attention to an action happening right now. The correct form is are playing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d819986f-cfe2-53f8-bd3e-f76c9aa3e3a5', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'Why is "I am knowing the answer" incorrect?', '[{"id":"a","text":"\"Know\" must take -s in the present."},{"id":"b","text":"\"Know\" is a stative verb and is not normally used in the continuous form."},{"id":"c","text":"The subject \"I\" requires \"is\" instead of \"am\"."},{"id":"d","text":"The continuous form requires \"was\" for the verb \"know\"."}]'::jsonb, 'b', 'Stative verbs like know, like, love, and want describe mental states, not actions. They are not used in the continuous form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e4014e1-cd1d-5dcc-aac5-f44926ed20ed', 'c4f248a7-393a-5c6d-b4af-90311f1ae35d', 'What is the correct negative form of "She plays tennis" in the present simple?', '[{"id":"a","text":"She isn''t playing tennis."},{"id":"b","text":"She doesn''t plays tennis."},{"id":"c","text":"She doesn''t play tennis."},{"id":"d","text":"She don''t play tennis."}]'::jsonb, 'c', 'The present simple negative uses doesn''t (does not) + the base verb for he/she/it. The main verb keeps its base form: doesn''t play.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b8bbba1-76cd-5943-aa66-9d9da0f72492', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', 'Practice: simple or continuous?', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7241ee79-462b-5b3a-984c-eea640002fb0', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Choose the correct form: "She ___ to school every day."', '[{"id":"a","text":"is going"},{"id":"b","text":"go"},{"id":"c","text":"goes"},{"id":"d","text":"going"}]'::jsonb, 'c', '"every day" signals a repeated habit, so we use the present simple. With the third-person singular "she", we add -es to a verb ending in -o: she goes. "is going" (present continuous) is for actions happening now; "go" forgets the -es needed after she/he/it; "going" alone is not a finite verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a63341f-b75c-5f33-9964-f0a5e371d967', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "Look! The baby ___."', '[{"id":"a","text":"cries"},{"id":"b","text":"cry"},{"id":"c","text":"is crying"},{"id":"d","text":"cried"}]'::jsonb, 'c', '"Look!" draws attention to something happening right now, so we use the present continuous (is + -ing): the baby is crying. "cries" and "cry" are present simple (habits, not this moment); "cried" is past simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43bd124a-3273-5b3d-babe-7c21c893d954', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Which word signals the present simple?', '[{"id":"a","text":"usually"},{"id":"b","text":"now"},{"id":"c","text":"at the moment"},{"id":"d","text":"Look!"}]'::jsonb, 'a', 'Adverbs of frequency such as "usually" describe how often something happens, so they signal a habit and the present simple. By contrast, "now", "at the moment", and "Look!" all point to an action in progress and go with the present continuous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4629643-cb37-5769-8cef-57760b3611f9', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "He ___ football on Sundays."', '[{"id":"a","text":"play"},{"id":"b","text":"plays"},{"id":"c","text":"is play"},{"id":"d","text":"playing"}]'::jsonb, 'b', '"on Sundays" signals a regular habit, so we use the present simple. The third-person singular "he" adds -s to the verb: he plays. "play" is missing the -s; "is play" mixes two verb forms; "playing" alone cannot be the main verb without am/is/are.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('499dffeb-77ba-571a-a272-ef6b68e30622', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Complete: "They ___ TV at the moment."', '[{"id":"a","text":"watch"},{"id":"b","text":"are watching"},{"id":"c","text":"watches"},{"id":"d","text":"is watching"}]'::jsonb, 'b', '"at the moment" signals now, so we use the present continuous with the plural subject they: are watching.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5481854-86d1-56f3-8ac1-c1496af746ac', '6b8bbba1-76cd-5943-aa66-9d9da0f72492', 'Choose the correct sentence:', '[{"id":"a","text":"I know the answer."},{"id":"b","text":"I am knowing the answer."},{"id":"c","text":"I knows the answer."},{"id":"d","text":"I am know the answer."}]'::jsonb, 'a', '"know" is a stative verb (a mental state, not an action), so it is not used in the continuous: "I am knowing" is wrong. With "I" we use the base form with no -s, so "I knows" is also wrong, and "I am know" mixes two verbs. The correct sentence is the simple present: I know the answer.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('458c297a-6ea2-522c-9a6c-6dc0c6c7267b', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', '⚔️ Boss: master the present', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d8b38f06-1764-5f19-ba99-8f0fd06fd79b', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete: "I can''t talk now, I ___ dinner."', '[{"id":"a","text":"cook"},{"id":"b","text":"cooks"},{"id":"c","text":"am cooking"},{"id":"d","text":"cooked"}]'::jsonb, 'c', '"I can''t talk now" tells us the action is in progress at this moment, so we use the present continuous: I am cooking dinner. "cook"/"cooks" are present simple (habits), and "cooked" is past simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('620f8003-045f-50cd-a9f5-2e24398d3bc5', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct form: "Water ___ at 100 degrees."', '[{"id":"a","text":"boils"},{"id":"b","text":"is boiling"},{"id":"c","text":"boil"},{"id":"d","text":"are boiling"}]'::jsonb, 'a', 'A scientific fact or general truth always takes the present simple: water boils at 100 degrees. "is boiling" would mean it is happening at this moment, not always; "boil" forgets the -s for the singular subject "water"; "are boiling" wrongly treats "water" as plural.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('535f555e-00ec-541c-9430-c8c68f6f8bb0', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct negative: "She ___ coffee."', '[{"id":"a","text":"don''t drink"},{"id":"b","text":"isn''t drink"},{"id":"c","text":"not drinks"},{"id":"d","text":"doesn''t drink"}]'::jsonb, 'd', 'In the present simple negative for he/she/it, the auxiliary "does" carries the -s, so the main verb stays in its base form: she doesn''t drink coffee. "don''t drink" uses the wrong auxiliary for "she"; "isn''t drink" mixes "be" with a base verb; "not drinks" has no auxiliary at all.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71117f1e-36c4-5a8e-b723-9dbc88418bf1', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete the question: "___ they live in Tunis?"', '[{"id":"a","text":"Does"},{"id":"b","text":"Do"},{"id":"c","text":"Are"},{"id":"d","text":"Is"}]'::jsonb, 'b', 'Present simple questions use "do/does" as the auxiliary. With the plural subject "they" we use "Do" + base verb: Do they live...? "Does" is only for he/she/it; "Are"/"Is" would be needed for the present continuous (Are they living...?), not the present simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc94054e-1446-5d04-8e8c-221f38cdcb9d', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Complete: "Be quiet! The students ___ a test right now."', '[{"id":"a","text":"take"},{"id":"b","text":"takes"},{"id":"c","text":"is taking"},{"id":"d","text":"are taking"}]'::jsonb, 'd', '"right now" signals an action in progress; with the plural subject students we use are + taking.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a789f4-e6c1-56be-86ef-0e8dd1a6eace', '458c297a-6ea2-522c-9a6c-6dc0c6c7267b', 'Choose the correct sentence:', '[{"id":"a","text":"This cake tastes delicious."},{"id":"b","text":"This cake is tasting delicious."},{"id":"c","text":"This cake taste delicious."},{"id":"d","text":"This cake are tasting delicious."}]'::jsonb, 'a', '"taste" (= have a flavour) is stative here, so we use the present simple: the cake tastes delicious.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a7783a2-f424-5be0-b07f-8bed19499adb', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', '👑 Elite Challenge: Precision Tenses', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('86f3a7c0-5851-570f-9244-5836c0bd3430', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'Which sentence is grammatically correct?', '[{"id":"a","text":"She has been waiting for two hours."},{"id":"b","text":"She is waiting since two hours."},{"id":"c","text":"She waits for two hours already."},{"id":"d","text":"She has waited since two hours."}]'::jsonb, 'a', 'Use the present perfect continuous (have/has been + -ing) for an action that started in the past and is still ongoing. ''For'' introduces a period of time (two hours), and ''since'' introduces a point in time (since 8 a.m.) — mixing ''since'' with a period (options b, d) is a classic error. Option c uses the wrong tense entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('496b9bfb-62c9-5779-bfb6-c7155592c344', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'The chef ___ the soup to check the salt, and it ___ wonderful. Choose the correct pair.', '[{"id":"a","text":"is tasting / tastes"},{"id":"b","text":"tastes / is tasting"},{"id":"c","text":"is tasting / is tasting"},{"id":"d","text":"tastes / tastes"}]'::jsonb, 'a', 'The verb ''taste'' has two uses: as a dynamic verb meaning ''to sample'' (an action the chef performs deliberately — present continuous is correct), and as a stative verb meaning ''to have a flavour'' (a state — present simple is correct). ''Is tasting / tastes'' captures both uses precisely.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40ef29e0-5fdd-59eb-bfc4-e34d75b19024', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'He ___ three novels this year, and his publisher is very pleased. Choose the correct form.', '[{"id":"a","text":"has been writing"},{"id":"b","text":"has written"},{"id":"c","text":"is writing"},{"id":"d","text":"writes"}]'::jsonb, 'b', 'When the focus is on a completed, countable result (three finished novels), use the present perfect simple (has written). The present perfect continuous (has been writing) emphasises duration and effort but does not confirm the novels are finished — it would be odd with a specific count of completed works.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21b7cf2a-d994-5d60-ae47-b0557b541a1a', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'You look completely exhausted. What ___ all morning?', '[{"id":"a","text":"have you done"},{"id":"b","text":"have you been doing"},{"id":"c","text":"are you doing"},{"id":"d","text":"do you do"}]'::jsonb, 'b', 'The present perfect continuous (have you been doing) is used when a recent, extended activity has a visible result in the present — here, the exhaustion. The present perfect simple (have you done) would focus on a completed achievement rather than the tiring process that caused the current state.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43209281-e502-55a8-af03-57de11357db3', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'Which sentence uses the verb ''think'' correctly?', '[{"id":"a","text":"I''m thinking you are absolutely right."},{"id":"b","text":"I am thinking that this is unfair."},{"id":"c","text":"I am thinking about your proposal right now."},{"id":"d","text":"She is thinking the answer is obvious."}]'::jsonb, 'c', '''Think'' is stative when it expresses an opinion (= believe), so options a, b, and d are wrong — you cannot say ''I am thinking (that)…'' to express a belief. However, ''think about'' describes an active mental process (= consider, reflect on), so the present continuous is correct in option c: ''I am thinking about your proposal right now.''', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c7fcb80-216b-51a9-aea0-1a7b93d56db9', '5a7783a2-f424-5be0-b07f-8bed19499adb', 'They ___ on the project for six months, and they still have not finished it. Choose the correct form.', '[{"id":"a","text":"worked"},{"id":"b","text":"are working"},{"id":"c","text":"have worked"},{"id":"d","text":"have been working"}]'::jsonb, 'd', 'The present perfect continuous (have been working) is the right choice: it expresses a continuous activity that started six months ago and is still unfinished now — confirmed by ''still have not finished''. ''Have worked'' (present perfect simple) would suggest the work is complete, contradicting the sentence. ''Worked'' is past simple (no link to the present), and ''are working'' ignores the six-month duration.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('350e9c30-be36-5bb3-b3e9-719d9f142839', '6c5876d5-c564-5362-9ec4-db66068dd428', 'english', '🔁 Practice Plus: present tenses review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d14c0f60-6da2-55c5-8785-7bf3766936e3', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Complete: "My brother usually ___ to school by bus."', '[{"id":"a","text":"go"},{"id":"b","text":"goes"},{"id":"c","text":"is going"},{"id":"d","text":"going"}]'::jsonb, 'b', '"usually" marks a habit, so we use the present simple; with the third-person singular subject "my brother" the verb takes -s: goes. "go" forgets the -s; "is going" is the present continuous (action now), which clashes with "usually"; "going" alone is not a finite verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8407502b-fddc-5cd3-8d49-57b73532d39b', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Choose the correct sentence:', '[{"id":"a","text":"I am knowing the answer."},{"id":"b","text":"I knows the answer."},{"id":"c","text":"I know the answer."},{"id":"d","text":"I am know the answer."}]'::jsonb, 'c', '"know" is a stative verb (a mental state), so it is not used in the continuous: I know the answer. "am knowing" wrongly makes a stative verb continuous; "I knows" adds -s to a first-person subject; "am know" mixes "be" with a base verb.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52851484-7889-5e36-b119-90b1e3d6811a', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Complete: "Look! It ___ outside, so take an umbrella."', '[{"id":"a","text":"rains"},{"id":"b","text":"rain"},{"id":"c","text":"is raining"},{"id":"d","text":"raining"}]'::jsonb, 'c', '"Look!" shows the action is happening at this moment, so we use the present continuous: it is raining. "rains" is present simple (a habit or general truth); "rain" lacks the -s and the continuous form; "raining" alone has no auxiliary "is".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff900417-defa-574f-b8c7-08e0b3fa1c5f', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Choose the correct question: "___ your sister speak English?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Does"},{"id":"c","text":"Is"},{"id":"d","text":"Are"}]'::jsonb, 'b', 'Present simple questions with he/she/it use the auxiliary "does" + base verb: Does your sister speak...? "Do" is for I/you/we/they; "Is"/"Are" would introduce the present continuous (Is your sister speaking...?), not the present simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31b2179a-b120-5b3e-aa93-1c722607e47b', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Choose the correct sentence:', '[{"id":"a","text":"He don''t understand the lesson."},{"id":"b","text":"He doesn''t understands the lesson."},{"id":"c","text":"He isn''t understand the lesson."},{"id":"d","text":"He doesn''t understand the lesson."}]'::jsonb, 'd', 'In the present simple negative with he, the auxiliary "does" carries the -s and the main verb stays in its base form: he doesn''t understand. "don''t" is the wrong auxiliary for "he"; "doesn''t understands" double-marks the -s; "isn''t understand" mixes "be" with a base verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa3867c5-204b-545f-8d8a-6a7d0bf12ca1', '350e9c30-be36-5bb3-b3e9-719d9f142839', 'Complete: "These days, more and more people ___ remotely from home."', '[{"id":"a","text":"are working"},{"id":"b","text":"works"},{"id":"c","text":"is working"},{"id":"d","text":"work"}]'::jsonb, 'a', '"These days" describes a temporary trend in progress around now, so we use the present continuous; the plural subject "people" takes "are": are working. "works" wrongly adds -s to a plural subject; "is working" uses the singular "is" with a plural subject; "work" (present simple) would suggest a fixed permanent habit, not a current trend.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('285d360a-8465-518f-990c-916004f4f3b5', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b5fe6ca3-0ae0-5d0a-becc-64b5e9be71c2', '285d360a-8465-518f-990c-916004f4f3b5', 'Which sentence uses the past simple correctly with an irregular verb?', '[{"id":"a","text":"She goed to the market yesterday."},{"id":"b","text":"She went to the market yesterday."},{"id":"c","text":"She has went to the market yesterday."},{"id":"d","text":"She was go to the market yesterday."}]'::jsonb, 'b', '"yesterday" needs the past simple, and "go" is irregular: its past form is "went", not the regular "goed". "has went" is wrong because the present perfect uses the past participle "gone", not "went"; "was go" mixes "be" with a base verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bb52641-d98c-5fc5-a598-beb8dbb6ef71', '285d360a-8465-518f-990c-916004f4f3b5', 'What is the correct form for a past simple question with a regular verb?', '[{"id":"a","text":"Did she walked to school?"},{"id":"b","text":"Was she walk to school?"},{"id":"c","text":"Did she walk to school?"},{"id":"d","text":"Does she walked to school?"}]'::jsonb, 'c', 'Past simple questions use Did + subject + base verb. After Did, the main verb stays in its base form (no -ed).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('def1e0d2-88c6-5665-b598-fcbea95f96eb', '285d360a-8465-518f-990c-916004f4f3b5', 'Which structure correctly describes a background action interrupted by a shorter event in the past?', '[{"id":"a","text":"I cooked when the phone was ringing."},{"id":"b","text":"I was cooking when the phone rang."},{"id":"c","text":"I was cooking when the phone was ringing."},{"id":"d","text":"I cooked when the phone had rung."}]'::jsonb, 'b', 'The past continuous (was cooking) provides the background action; the past simple (rang) describes the shorter event that interrupted it.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cb5ed33-22c7-5edc-901c-0c090a8ffbf8', '285d360a-8465-518f-990c-916004f4f3b5', 'Which adverb is associated with the present perfect, NOT the past simple?', '[{"id":"a","text":"yesterday"},{"id":"b","text":"last year"},{"id":"c","text":"in 2020"},{"id":"d","text":"already"}]'::jsonb, 'd', '"Already" is a key adverb of the present perfect (have/has + past participle). "Yesterday", "last year", and "in 2020" all indicate a specific past time, so they go with the past simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f36a39c7-17e1-500d-a663-25676e3f151d', '285d360a-8465-518f-990c-916004f4f3b5', 'Which sentence correctly uses the present perfect?', '[{"id":"a","text":"She has visited Rome last summer."},{"id":"b","text":"She visited Rome yet."},{"id":"c","text":"She has never visited Rome."},{"id":"d","text":"She have visited Rome."}]'::jsonb, 'c', 'The present perfect (has + past participle) is used with "never" for a life experience at an unspecified time. A specific time like "last summer" would require the past simple instead.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', 'Practice: past tenses', 2, 60, 12, 'practice', 'admin', 1)
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
  ('bc3de6df-27c5-564f-a509-4feb9efb0100', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "She ___ to the market yesterday."', '[{"id":"a","text":"go"},{"id":"b","text":"went"},{"id":"c","text":"goed"},{"id":"d","text":"goes"}]'::jsonb, 'b', '"yesterday" is a finished past time, so we use the past simple. "go" is irregular: go → went (not the regular "goed"). "go"/"goes" are present simple, which cannot describe yesterday.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14609924-058c-5c85-b515-6e83bfa1c218', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "Have you ___ eaten couscous?"', '[{"id":"a","text":"yet"},{"id":"b","text":"ago"},{"id":"c","text":"ever"},{"id":"d","text":"yesterday"}]'::jsonb, 'c', '"ever" is placed between the subject and the past participle in present perfect questions to ask about experience at any time in your life: Have you ever eaten couscous? "ago" and "yesterday" mark a finished past time and need the past simple, not the present perfect; "yet" is used in questions but goes at the end (Have you eaten yet?), not in this position.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13f53f19-669d-5bae-bb4e-fee06ce7d631', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "We ___ football when it started to rain."', '[{"id":"a","text":"played"},{"id":"b","text":"play"},{"id":"c","text":"have played"},{"id":"d","text":"were playing"}]'::jsonb, 'd', 'The football game was already in progress (background action) when the rain interrupted. Use past continuous: were playing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63809236-3326-5a22-bf77-ca09b2f1cd0c', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Choose the correct negative: "He ___ the test last Monday."', '[{"id":"a","text":"didn''t passed"},{"id":"b","text":"didn''t pass"},{"id":"c","text":"wasn''t pass"},{"id":"d","text":"hasn''t passed"}]'::jsonb, 'b', '"last Monday" is a specific finished time, so we use the past simple, not the present perfect. The negative is "didn''t" + base verb: he didn''t pass. "didn''t passed" double-marks the past; "wasn''t pass" wrongly uses "be"; "hasn''t passed" is present perfect, which cannot go with a specific past time.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6259cdd8-58d3-5794-8789-ae21fa623ed6', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Complete: "I ___ my homework. I can play now."', '[{"id":"a","text":"finished"},{"id":"b","text":"have just finished"},{"id":"c","text":"was finishing"},{"id":"d","text":"finish"}]'::jsonb, 'b', 'The action is very recent and its result matters now (I can play). Use present perfect with "just": have just finished.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c43f3d30-8f67-5e14-a3e2-445602f8671d', '1874477b-34e6-5ff5-8fa9-35f4a38c5e2a', 'Choose the correct sentence:', '[{"id":"a","text":"Did they go to Djerba last summer?"},{"id":"b","text":"Did they went to Djerba last summer?"},{"id":"c","text":"Have they gone to Djerba last summer?"},{"id":"d","text":"Were they go to Djerba last summer?"}]'::jsonb, 'a', '"last summer" is a specific past time, so use past simple. Questions: Did + subject + base verb. Never add -ed/-en after did.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('870d7346-31c1-546f-8e25-ad1a12362ea7', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', '⚔️ Boss: conquer the past', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a79183ff-96f8-5044-a92c-581978d8d1c9', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "While my sister ___, I washed the dishes."', '[{"id":"a","text":"slept"},{"id":"b","text":"sleeps"},{"id":"c","text":"was sleeping"},{"id":"d","text":"has slept"}]'::jsonb, 'c', '"While" + past continuous gives the background action. "I washed" (past simple) is the completed action during that time: while she was sleeping.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('937bbd74-4c72-52a9-a129-ef162fceeeb5', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Which sentence is correct?', '[{"id":"a","text":"She visited Paris two years ago."},{"id":"b","text":"She has visited Paris two years ago."},{"id":"c","text":"She have visited Paris two years ago."},{"id":"d","text":"She was visited Paris two years ago."}]'::jsonb, 'a', '"two years ago" names a specific finished time, so the past simple is required: she visited Paris. The present perfect (has/have visited) can never be used with a finished-time expression like "ago", which rules out options b and c; "was visited" is a passive form that does not fit here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67cf5732-4004-59fe-b4a5-bbc42565a024', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "___ the film start when you arrived?"', '[{"id":"a","text":"Did"},{"id":"b","text":"Has"},{"id":"c","text":"Was"},{"id":"d","text":"Were"}]'::jsonb, 'a', 'This asks about a completed event at a specific past moment. Past simple question: Did + subject + base verb. "Did the film start...?"', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75c9c3aa-c5c6-57b3-a6ae-72b8b7d071e4', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "I ___ never ___ sushi before. I tried it last night."', '[{"id":"a","text":"have ... eaten"},{"id":"b","text":"did ... eat"},{"id":"c","text":"had ... eaten"},{"id":"d","text":"was ... eating"}]'::jsonb, 'a', '"never" with present perfect describes a life experience up to now: I have never eaten sushi. The sentence then adds a specific past event (last night → past simple), showing the contrast.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dafd7523-eee4-517a-9606-6b8f9a72155f', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Complete: "Look — Salma ___ already ___ the report!"', '[{"id":"a","text":"did ... write"},{"id":"b","text":"has ... written"},{"id":"c","text":"was ... writing"},{"id":"d","text":"had ... written"}]'::jsonb, 'b', '"already" between have/has and the past participle signals the present perfect: has already written. The result is visible now (Look!).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37470435-85a2-505c-91ca-b117d0515933', '870d7346-31c1-546f-8e25-ad1a12362ea7', 'Choose the correct pair: "They ___ TV when the lights ___ out."', '[{"id":"a","text":"watched ... were going"},{"id":"b","text":"were watching ... went"},{"id":"c","text":"have watched ... went"},{"id":"d","text":"were watching ... were going"}]'::jsonb, 'b', 'Past continuous (were watching) = background in progress; past simple (went) = the sudden interrupting event. This is the classic when-pattern.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('46cd64a1-c660-59b3-9588-78efe0da7594', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', '👑 Elite Challenge: Mastering Time Sequences', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fe75d1d4-1b37-5ee0-bbb4-a75f8fe2fc53', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "By the time the guests arrived, Yasmine ___ all the food."', '[{"id":"a","text":"prepared"},{"id":"b","text":"was preparing"},{"id":"c","text":"had prepared"},{"id":"d","text":"has prepared"}]'::jsonb, 'c', '"By the time" signals that one past action was completed before another past event. The past perfect (had prepared) is required: Yasmine finished the food first, then the guests arrived. Past simple (prepared) ignores the sequence; past continuous (was preparing) implies it was unfinished; present perfect (has prepared) is impossible in a past context.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cedab619-4c56-5ca3-ab85-a95e25b97113', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Which sentence contains a grammatical error?', '[{"id":"a","text":"He used to walk to school every day."},{"id":"b","text":"She used to be afraid of spiders."},{"id":"c","text":"They used to played football on Fridays."},{"id":"d","text":"We used to live near the sea."}]'::jsonb, 'c', '"Used to" is always followed by the base form (infinitive without to is already included in the structure: used to + base verb). "Played" is a past form — writing "used to played" double-marks the past. The correct form is "used to play". Options a, b, and d all correctly use "used to" + base verb.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4dd4df16-b2ea-5580-ae08-b16f11a0a65b', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "When I ___ to the station, the train already ___ ."', '[{"id":"a","text":"got / had left"},{"id":"b","text":"had got / left"},{"id":"c","text":"was getting / left"},{"id":"d","text":"got / has left"}]'::jsonb, 'a', 'Two past events in sequence: arriving at the station (past simple: got) is the reference point; the train leaving happened before that (past perfect: had left). "Already" reinforces the earlier completion. Option b reverses the logic — the arrival cannot precede itself with past perfect here. Option c is wrong because "getting" implies the journey was still in progress when the train left. Option d mixes past simple with present perfect, which is grammatically impossible.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42b58ca1-24dc-5af1-a693-9b4143086c60', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "He ___ the report three times before he ___ it to his teacher."', '[{"id":"a","text":"checked / submitted"},{"id":"b","text":"had checked / submitted"},{"id":"c","text":"was checking / had submitted"},{"id":"d","text":"has checked / submitted"}]'::jsonb, 'b', 'The checking happened before the submitting — both are past events, but checking is the earlier one. The past perfect (had checked) marks it as prior; the past simple (submitted) marks the later reference event. Option a (both past simple) is grammatically possible in informal speech but loses the precise sequence signal required at exam level. Option c wrongly uses past perfect for the later action. Option d wrongly uses present perfect in a fully past context.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1a7eb87-ac87-505d-a32e-4d0f771fc4a9', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Identify the ONE correct sentence.', '[{"id":"a","text":"While the phone rang, I was cooking dinner."},{"id":"b","text":"When I was having a bath, the doorbell rang."},{"id":"c","text":"While I arrived, she was leaving the room."},{"id":"d","text":"When she was writing, she was finishing the letter."}]'::jsonb, 'b', 'Option b is correct: "was having" (past continuous) provides the ongoing background; "rang" (past simple) is the short interrupting event — the classic when-pattern. Option a is wrong because "rang" is a short punctual verb and cannot be the background of a "while" clause; it should be "when the phone rang, I was cooking". Option c is wrong because "arrive" is punctual and cannot be a "while" background. Option d is wrong because "finish" describes a completed result and cannot be past continuous alongside another continuous action.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5e159b5-bd31-599c-86e1-07e774c6fcbd', '46cd64a1-c660-59b3-9588-78efe0da7594', 'Complete: "The police discovered that the thief ___ through the back window and ___ the safe before anyone ___ the alarm."', '[{"id":"a","text":"climbed / emptied / raised"},{"id":"b","text":"had climbed / had emptied / raised"},{"id":"c","text":"was climbing / emptied / had raised"},{"id":"d","text":"had climbed / was emptying / raised"}]'::jsonb, 'b', 'The thief''s actions (climbing in, emptying the safe) both occurred before the alarm was raised — the reference past event. Past perfect (had climbed, had emptied) correctly places these two earlier actions; past simple (raised) marks the later reference point. Option a loses the sequence entirely. Option c wrongly puts "had raised" on the alarm, reversing the logic — the alarm came last, not first. Option d uses past continuous for "emptying", implying it was still in progress when the alarm went off, which contradicts the "before" clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6061e935-aa81-57d8-9e07-6940a9d538c9', '86194a0b-245d-5f29-bdad-cf1ed247131f', 'english', '🔁 Practice Plus: past tenses review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d022e990-1237-5d6b-b0bf-33f2369aeac4', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Complete: "Yesterday I ___ my grandparents in Sfax."', '[{"id":"a","text":"visit"},{"id":"b","text":"visited"},{"id":"c","text":"have visited"},{"id":"d","text":"was visiting"}]'::jsonb, 'b', '"Yesterday" is a finished past time marker, so we use the past simple: visited. "visit" is present; "have visited" (present perfect) cannot go with a finished time like yesterday; "was visiting" (past continuous) would need a longer background action, not a simple completed event.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dcbfba5-5976-5cf4-bd1c-49a3a8391813', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Complete: "While I ___ TV, the phone rang."', '[{"id":"a","text":"watched"},{"id":"b","text":"was watching"},{"id":"c","text":"have watched"},{"id":"d","text":"watch"}]'::jsonb, 'b', 'A longer background action interrupted by a sudden one uses the past continuous: I was watching TV when the phone rang. "watched" (past simple) loses the "in-progress" idea; "have watched" is present perfect; "watch" is present.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('267cb805-3c50-5e96-bbde-23956195cd16', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Choose the correct sentence:', '[{"id":"a","text":"I have seen this film last week."},{"id":"b","text":"I saw this film last week."},{"id":"c","text":"I see this film last week."},{"id":"d","text":"I was seeing this film last week."}]'::jsonb, 'b', '"last week" is a finished time, so we use the past simple: I saw this film last week. The present perfect (a) cannot combine with a finished time expression; (c) is present; (d) uses the continuous for a single completed action, which is wrong, and "see" is also stative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('920e5c43-24eb-5f48-a671-d828a09799d4', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Choose the correct negative: "They ___ the homework on time."', '[{"id":"a","text":"didn''t finished"},{"id":"b","text":"don''t finish"},{"id":"c","text":"didn''t finish"},{"id":"d","text":"wasn''t finish"}]'::jsonb, 'c', 'In the past simple negative, "did" carries the tense and the main verb returns to its base form: didn''t finish. "didn''t finished" double-marks the past; "don''t finish" is present; "wasn''t finish" mixes "be" with a base verb (and the wrong number for "they").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fdbb01a0-84ce-5e3a-8df0-75fbbf44dbe3', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Complete: "___ you ever ___ to London?"', '[{"id":"a","text":"Did / go"},{"id":"b","text":"Have / been"},{"id":"c","text":"Have / went"},{"id":"d","text":"Did / went"}]'::jsonb, 'b', '"ever" with no finished time asks about a life experience up to now, so we use the present perfect: Have you ever been to London? (a) past simple suits a specific past time, not an open experience; (c) uses the wrong past participle ("went" instead of "been/gone"); (d) mixes "did" with a past form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b891d10-ca35-57e9-bf7f-ba16e93395bb', '6061e935-aa81-57d8-9e07-6940a9d538c9', 'Complete: "She ___ already ___ when the guests arrived."', '[{"id":"a","text":"has / left"},{"id":"b","text":"was / leaving"},{"id":"c","text":"had / left"},{"id":"d","text":"did / leave"}]'::jsonb, 'c', 'An action completed before another past action takes the past perfect: she had already left when the guests arrived. "has left" (present perfect) refers to now, not to a point in the past; "was leaving" describes an interrupted action, not one already finished; "did leave" cannot follow "already" in this earlier-than-the-past sense.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('216cae02-7987-5531-b3fa-6af92e75e33d', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7b983cd9-c2c0-5a9c-a73c-ac98bf9d0808', '216cae02-7987-5531-b3fa-6af92e75e33d', 'The phone is ringing and you decide to answer it right now. Which sentence is correct?', '[{"id":"a","text":"I am going to answer it."},{"id":"b","text":"I will answer it."},{"id":"c","text":"I am answering it tomorrow."},{"id":"d","text":"I answer it."}]'::jsonb, 'b', '"Will" is used for a spontaneous decision made at the moment of speaking, so "I will answer it" fits. "am going to" implies a plan made earlier; "am answering it tomorrow" is a future arrangement at the wrong time; "I answer it" (present simple) is not used for a single on-the-spot decision.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d65ae3ef-84c2-5f87-b631-5f91de5eef1f', '216cae02-7987-5531-b3fa-6af92e75e33d', 'You can see dark clouds gathering overhead. Which sentence correctly expresses an evidence-based prediction?', '[{"id":"a","text":"I think it will rain."},{"id":"b","text":"It rains soon."},{"id":"c","text":"It is going to rain."},{"id":"d","text":"It will have rained."}]'::jsonb, 'c', '"Be going to" is used for predictions based on visible present evidence. The dark clouds you can see right now are the evidence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ceda0cf-76cc-5320-b521-1dbaaf81ff83', '216cae02-7987-5531-b3fa-6af92e75e33d', 'What is the correct negative form of "will" in a sentence?', '[{"id":"a","text":"She willn''t come."},{"id":"b","text":"She won''t come."},{"id":"c","text":"She doesn''t will come."},{"id":"d","text":"She isn''t will come."}]'::jsonb, 'b', 'The negative of will is will not, contracted to won''t. No auxiliary verb like do or be is added alongside will.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d607352b-8809-5647-8ea5-22f2ffea5f51', '216cae02-7987-5531-b3fa-6af92e75e33d', 'Which sentence correctly uses a time clause with a future meaning?', '[{"id":"a","text":"Call me when you will arrive."},{"id":"b","text":"Call me when you arrive."},{"id":"c","text":"Call me when you are arriving."},{"id":"d","text":"Call me when you arrived."}]'::jsonb, 'b', 'After time conjunctions such as when, as soon as, before, after, and until in a future sentence, use the present simple, not will.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b0082a8-9de5-5939-9428-c20ddaf4909d', '216cae02-7987-5531-b3fa-6af92e75e33d', 'Which form expresses a fixed, confirmed arrangement already in your diary?', '[{"id":"a","text":"I will meet the doctor at 9 a.m. tomorrow."},{"id":"b","text":"I meet the doctor at 9 a.m. tomorrow."},{"id":"c","text":"I am meeting the doctor at 9 a.m. tomorrow."},{"id":"d","text":"I was meeting the doctor at 9 a.m. tomorrow."}]'::jsonb, 'c', 'The present continuous is used for future events that are already arranged and confirmed with others, such as a diary appointment.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ac40b31-da66-5e9a-b82f-2414438a00c5', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', 'Practice: will, going to, or present continuous?', 2, 60, 12, 'practice', 'admin', 1)
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
  ('12f16b47-6a4c-5487-99e2-f1f5e592d512', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'The phone is ringing. Complete: "Don''t worry — I ___ it!"', '[{"id":"a","text":"am going to answer"},{"id":"b","text":"answer"},{"id":"c","text":"will answer"},{"id":"d","text":"am answering"}]'::jsonb, 'c', 'The phone rings and you decide to answer at that very moment, so this is a spontaneous decision: use "will" (I''ll answer it!). "am going to answer" implies a plan made earlier; "answer" (present simple) is for timetables; "am answering" (present continuous) is for fixed arrangements, not an on-the-spot offer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ba459b0-dc9e-57f9-9175-81ba6c0d490d', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Look at those black clouds! Complete: "It ___ rain."', '[{"id":"a","text":"will"},{"id":"b","text":"is"},{"id":"c","text":"rains"},{"id":"d","text":"is going to"}]'::jsonb, 'd', 'When you predict the future from evidence you can see right now (black clouds), use "be going to": it is going to rain. "will" is for opinions/predictions without present evidence; "is" alone and "rains" (present simple) do not express this kind of prediction.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc58c470-1c5f-570b-b347-e040a8aaabbf', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Which time marker does NOT typically go with future tenses?', '[{"id":"a","text":"next week"},{"id":"b","text":"tomorrow"},{"id":"c","text":"yesterday"},{"id":"d","text":"soon"}]'::jsonb, 'c', '"Yesterday" refers to the past, not the future. "Next week", "tomorrow", and "soon" are future time markers.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5d79b1-f11c-501e-b3aa-b94d4fb6c94f', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Complete the time clause: "I will call you when I ___ home."', '[{"id":"a","text":"get"},{"id":"b","text":"will get"},{"id":"c","text":"am getting"},{"id":"d","text":"got"}]'::jsonb, 'a', 'After time conjunctions (when, as soon as, before, after, until) in a future sentence, use the present simple — not will: when I get home.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f82a2c0b-e513-5770-8b2a-024116d6b3a1', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Choose the correct sentence about a plan already decided:', '[{"id":"a","text":"We will visit Djerba next summer."},{"id":"b","text":"We visit Djerba next summer."},{"id":"c","text":"We visited Djerba next summer."},{"id":"d","text":"We are going to visit Djerba next summer."}]'::jsonb, 'd', 'An intention or plan decided before the moment of speaking uses "be going to": we are going to visit Djerba next summer. "will visit" suits a decision made now or a simple prediction, not a settled plan; "visit" (present simple) needs a timetable; "visited" is past simple and clashes with the future marker "next summer".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('389a214c-d24f-5aff-b8e6-447a45ed35ed', '0ac40b31-da66-5e9a-b82f-2414438a00c5', 'Complete: "I ___ the dentist at 3 p.m. tomorrow." (appointment confirmed)', '[{"id":"a","text":"will see"},{"id":"b","text":"am seeing"},{"id":"c","text":"see"},{"id":"d","text":"am going to see"}]'::jsonb, 'b', 'A confirmed arrangement with a specific time uses the present continuous: I am seeing the dentist at 3 p.m. tomorrow.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('efb66754-8009-5a3d-995a-6b71e9cf5537', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', '⚔️ Boss: command the future', 3, 120, 30, 'boss', 'admin', 2)
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
  ('dbf15f17-58e6-5ab5-b012-27b2368c4ca5', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'A friend is cold. You spontaneously decide to help. Choose the best sentence:', '[{"id":"a","text":"I am going to close the window."},{"id":"b","text":"I close the window."},{"id":"c","text":"I''ll close the window."},{"id":"d","text":"I am closing the window."}]'::jsonb, 'c', 'You decide to help the instant you notice your friend is cold, so this is a spontaneous offer: use "will" (I''ll close the window). "am going to close" implies you had already planned it; "I close" (present simple) and "I am closing" (an action in progress / fixed arrangement) do not express an on-the-spot decision.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8ad51f2-0d2f-5a46-ba24-3e956beb4367', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete: "As soon as she ___, we will start eating."', '[{"id":"a","text":"arrives"},{"id":"b","text":"will arrive"},{"id":"c","text":"is arriving"},{"id":"d","text":"arrived"}]'::jsonb, 'a', 'After time conjunctions like "as soon as", "when", "before" and "until", a future sentence uses the present simple, not "will": as soon as she arrives. So "will arrive" is the classic trap; "is arriving" and "arrived" do not fit the future time-clause rule either.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7a6d78a-35e1-5568-a53b-3be72295890c', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Choose the correct form: "Look at that cyclist — he ___ fall!"', '[{"id":"a","text":"will"},{"id":"b","text":"is going to"},{"id":"c","text":"would"},{"id":"d","text":"falls"}]'::jsonb, 'b', 'You can see the cyclist losing balance right now, so this is a prediction from present evidence: use "be going to" (he is going to fall). "will" is for predictions based on opinion, not visible signs; "would" is conditional/past; "falls" (present simple) does not express an imminent future event.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc5f7dad-9d09-5117-ba74-0cdae2c753c4', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete: "I think robots ___ do most jobs in the future."', '[{"id":"a","text":"will"},{"id":"b","text":"are going to"},{"id":"c","text":"are"},{"id":"d","text":"would"}]'::jsonb, 'a', '"I think" introduces a personal opinion or prediction about the future with no present evidence, which calls for "will": robots will do most jobs. "are going to" needs visible evidence or a settled plan; "are" alone is not a future form here; "would" is conditional, not a plain future prediction.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3748c61-938a-5781-a6e3-e94630c69381', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Which sentence correctly uses the present continuous for a future arrangement?', '[{"id":"a","text":"They will flying to Paris next Friday."},{"id":"b","text":"They are flying to Paris next Friday. (tickets booked)"},{"id":"c","text":"They fly to Paris next Friday."},{"id":"d","text":"They going to fly to Paris next Friday."}]'::jsonb, 'b', 'A confirmed, fixed arrangement uses the present continuous: they are flying to Paris next Friday. Option b is ungrammatical (will + -ing), c is present simple with a future marker (possible but less natural for a fixed plan), d is missing the auxiliary "are".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('723d0846-dcc9-57dc-a8d5-3f9a581abd90', 'efb66754-8009-5a3d-995a-6b71e9cf5537', 'Complete both blanks: "She ___ not work tomorrow because she ___ to see a doctor." (arrangement already made)', '[{"id":"a","text":"is ... will go"},{"id":"b","text":"won''t ... will"},{"id":"c","text":"would ... goes"},{"id":"d","text":"will ... is going"}]'::jsonb, 'd', '"will not work" (won''t work) is a prediction/decision; "is going to see" reflects a pre-made plan. "will ... is going" correctly uses will for the first blank and be going to for the second.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('86c16cd5-392b-5ab2-af1c-2952deb88e38', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', '👑 Elite Challenge: Master of Future Forms', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('20e1e342-c46f-5418-9778-f7583673ec41', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Read the timetable notice carefully: "The school bus ___ at 7:15 every morning next term — students must be at the stop two minutes early." Which form is best?', '[{"id":"a","text":"will leave"},{"id":"b","text":"leaves"},{"id":"c","text":"is going to leave"},{"id":"d","text":"is leaving"}]'::jsonb, 'b', 'A fixed, recurring timetable event (official schedule for a vehicle or institution) uses the present simple for the future. "Leaves" is correct. "Will leave" expresses a spontaneous decision or prediction. "Is going to leave" expresses a pre-made personal intention, not a published schedule. "Is leaving" is for a personal confirmed arrangement, not an impersonal timetable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd27901a-06cb-5aa5-b6ff-932cc32ad2bd', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Sami calls his mother from the kitchen: the tap has just burst and water is flooding the floor. He shouts: "Mum! The kitchen ___ flood — there''s water everywhere!" Which form is best?', '[{"id":"a","text":"will"},{"id":"b","text":"would"},{"id":"c","text":"is going to"},{"id":"d","text":"is"}]'::jsonb, 'c', 'Water is already spreading — this is a prediction based on immediate visible evidence, which requires "be going to": the kitchen is going to flood. "Will" signals an opinion-based prediction with no direct evidence in front of the speaker. "Would" is conditional or past. "Is" alone describes a present state, not an imminent future event.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd4a4ebb-6763-5e29-a105-05d6d3c4f871', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Leila has already booked the hall, sent invitations, and confirmed the caterer. She tells a friend: "I ___ organise a surprise party for my brother on Saturday." Which form is best?', '[{"id":"a","text":"will organise"},{"id":"b","text":"am going to organise"},{"id":"c","text":"organise"},{"id":"d","text":"am organising"}]'::jsonb, 'd', 'The event is fully arranged with other people (hall booked, invitations sent, caterer confirmed) — this is a fixed future arrangement, which calls for the present continuous: I am organising a surprise party. "Going to" expresses a pre-made intention but lacks the emphasis on a confirmed, multi-party arrangement. "Will organise" would suggest she is deciding at this very moment. The present simple "organise" does not suit a personal one-off future event.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4416d439-5708-525c-ab80-c0cf44fcea23', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Complete the first conditional: "If the government invests more in education, students ___ better results in national exams."', '[{"id":"a","text":"achieve"},{"id":"b","text":"are going to achieve"},{"id":"c","text":"will achieve"},{"id":"d","text":"are achieving"}]'::jsonb, 'c', 'In a first conditional sentence (real possibility in the future), the if-clause uses the present simple and the main clause uses "will + base verb": students will achieve. "Are going to achieve" is not standard in the result clause of a first conditional — it signals a pre-made intention, not a future consequence of a condition. "Achieve" (present simple) would make this a zero conditional (always-true fact). "Are achieving" is present continuous and does not express a future result.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('169e3347-7224-50c0-8f7d-5e3e2e95772a', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Choose the correct words for BOTH blanks: "She ___ not come to school tomorrow; she has an appointment because she ___ see the doctor at 10 a.m."', '[{"id":"a","text":"is ... will"},{"id":"b","text":"will ... is going to"},{"id":"c","text":"would ... is going to"},{"id":"d","text":"will ... will"}]'::jsonb, 'b', '"Will not come" (won''t come) expresses the consequence/decision about tomorrow, so "will" fits the first blank. "Is going to see" reflects a pre-arranged appointment (already booked), so "is going to" fits the second blank. Option a puts "is" in the first blank, making a present-continuous form that implies she is not currently at school — wrong in context. Option c uses conditional "would" in the first blank — unwarranted here. Option d uses "will" for both, treating the appointment as a spontaneous decision rather than an existing arrangement.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b5844a2-8c40-5cb9-a0a5-f526268f5281', '86c16cd5-392b-5ab2-af1c-2952deb88e38', 'Spot the one grammatically AND contextually correct sentence about a personal future plan:', '[{"id":"a","text":"When I will finish the concours, I will take a long holiday."},{"id":"b","text":"I am going to take a long holiday as soon as I will finish the concours."},{"id":"c","text":"I am going to take a long holiday as soon as I finish the concours."},{"id":"d","text":"I will taking a long holiday when I finish the concours."}]'::jsonb, 'c', 'After future time conjunctions (when, as soon as, before, after, until), English requires the present simple — never will. The main clause correctly uses "am going to take" to express a pre-made personal intention. Option a wrongly uses "will finish" after "when". Option b uses "am going to take" correctly but then breaks the rule with "will finish" after "as soon as". Option d is ungrammatical: "will taking" is not a valid verb form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'ff2b7070-d893-5229-bd8c-2b042dee6081', 'english', '🔁 Practice Plus: future forms review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('120cfca7-61da-5532-94c1-0790a1ceffeb', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Choose the correct sentence:', '[{"id":"a","text":"Maybe it will snow tonight."},{"id":"b","text":"Maybe it is snowing tonight."},{"id":"c","text":"Maybe it snows tonight."},{"id":"d","text":"Maybe it going to snow tonight."}]'::jsonb, 'a', 'An uncertain prediction (signalled by "maybe") naturally uses "will": maybe it will snow tonight. The present continuous (b) implies a fixed arrangement, which is odd for weather; the present simple (c) suggests a habit/timetable; (d) drops "is" before "going to".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eab5c5f-9ed1-5310-9572-af91d04eb918', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Complete: "Look at those dark clouds! It ___ rain."', '[{"id":"a","text":"will"},{"id":"b","text":"is going to"},{"id":"c","text":"is"},{"id":"d","text":"goes to"}]'::jsonb, 'b', 'A prediction based on present evidence (dark clouds) uses "be going to": it is going to rain. "will" is used for predictions without visible evidence or for instant decisions; "is" alone has no main verb; "goes to" is not a future form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b74588e-0387-5055-98fa-79d2e542499f', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Complete: "The phone is ringing. Don''t worry, I ___ answer it."', '[{"id":"a","text":"will"},{"id":"b","text":"am going to"},{"id":"c","text":"am"},{"id":"d","text":"answer"}]'::jsonb, 'a', 'An instant decision made at the moment of speaking uses "will": I''ll answer it. "am going to" suggests a plan made earlier, which contradicts the spontaneous decision; "am" needs the -ing form; "answer" alone has no future marker.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0aff5ebb-d9a2-5842-9ac5-ae78c4e62fb7', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Complete: "The train ___ at 8:45 every morning."', '[{"id":"a","text":"will leave"},{"id":"b","text":"is leaving"},{"id":"c","text":"leaves"},{"id":"d","text":"is going to leave"}]'::jsonb, 'c', 'Timetables and schedules use the present simple, even for the future: the train leaves at 8:45. "will leave" and "is going to leave" treat a fixed timetable like a prediction; "is leaving" suits a one-off arrangement, not a regular schedule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54b86e72-424b-5e9d-903e-fcfd68cae6b3', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Choose the correct sentence about a fixed arrangement:', '[{"id":"a","text":"I will meet the dentist at 5 tomorrow."},{"id":"b","text":"I am meeting the dentist at 5 tomorrow."},{"id":"c","text":"I meet the dentist at 5 tomorrow."},{"id":"d","text":"I going to meet the dentist at 5 tomorrow."}]'::jsonb, 'b', 'A fixed, arranged plan with another person and a definite time uses the present continuous for the future: I am meeting the dentist at 5 tomorrow. "will" sounds like a prediction or instant decision, not a firm appointment; the present simple (c) is for timetables, not personal arrangements; (d) drops "am" before "going to".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14f5f97c-9c0f-5ede-9836-067638a273fc', 'fe6fdcea-afaf-5ac7-a0fb-744699f5ffc1', 'Complete: "I''ll call you when I ___ home."', '[{"id":"a","text":"will get"},{"id":"b","text":"get"},{"id":"c","text":"am going to get"},{"id":"d","text":"will be getting"}]'::jsonb, 'b', 'After time words like "when" we use the present simple, not a future form, even for future meaning: when I get home. "will get", "am going to get" and "will be getting" all wrongly place a future form inside the time clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d1c87325-095a-555e-95d3-138f47124355', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which sentence contains a correctly formed modal verb?', '[{"id":"a","text":"She cans swim very well."},{"id":"b","text":"He musts leave now."},{"id":"c","text":"They should to study harder."},{"id":"d","text":"You must wear a seatbelt."}]'::jsonb, 'd', 'Modal verbs are followed directly by the base verb with no -s, no -ed, and no "to". "You must wear" is the only correctly formed option.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18298070-040f-5ac3-b119-9cb6fb720fa2', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which sentence correctly uses "should" to give advice?', '[{"id":"a","text":"You should to eat more vegetables."},{"id":"b","text":"You should eating more vegetables."},{"id":"c","text":"You should eat more vegetables."},{"id":"d","text":"You shoulds eat more vegetables."}]'::jsonb, 'c', '"Should" is followed by the base verb with no "to" and no -ing. The correct form is "should eat".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fee0d9a-a27d-5059-b62b-3e5c40b1b7ed', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'Which modal expresses a polite request, more formal than "can"?', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"could"},{"id":"d","text":"may not"}]'::jsonb, 'c', '"Could" is used for polite requests and is considered more polite than "can". For example: "Could you open the window?"', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a682336a-8cac-55fe-98ed-d13e41b90c21', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'What is the difference between "may" and "might" when expressing possibility?', '[{"id":"a","text":"\"May\" refers to the past; \"might\" refers to the future."},{"id":"b","text":"\"May\" is more certain than \"might\"; \"might\" suggests less certainty."},{"id":"c","text":"\"Might\" is more certain than \"may\"."},{"id":"d","text":"They cannot be used interchangeably for possibility."}]'::jsonb, 'b', 'Both "may" and "might" express possibility, but "might" suggests even less certainty than "may". In practice they can often be used interchangeably.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10cdbbe6-7c81-509f-9107-c3f8ea0bc615', '818e12ec-9c1e-52e1-8f1a-dde92ca62d2e', 'What is the key difference between "mustn''t" and "don''t have to"?', '[{"id":"a","text":"They mean the same thing: neither action is required."},{"id":"b","text":"\"Mustn''t\" means prohibition; \"don''t have to\" means there is no obligation."},{"id":"c","text":"\"Mustn''t\" is polite; \"don''t have to\" is rude."},{"id":"d","text":"\"Don''t have to\" means it is forbidden; \"mustn''t\" means it is optional."}]'::jsonb, 'b', '"Mustn''t" forbids an action (you are not allowed). "Don''t have to" means the action is not required but you are free to choose.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d33dfa7f-2d01-5e1c-aac3-8c969ee05d93', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', 'Practice: modal verbs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a14eb5d9-6d29-5415-8ec9-f1557b3e5161', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Choose the correct form: "She ___ play the piano very well."', '[{"id":"a","text":"can"},{"id":"b","text":"cans"},{"id":"c","text":"can to"},{"id":"d","text":"is can"}]'::jsonb, 'a', 'Modals never take -s or -to before the base verb: she can play. "Cans" and "can to" are both wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a039206b-03d4-5fc9-86ad-75e0019c4a70', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Choose the best advice: "You look tired. You ___ go to bed early."', '[{"id":"a","text":"should"},{"id":"b","text":"must not"},{"id":"c","text":"could not"},{"id":"d","text":"may not"}]'::jsonb, 'a', '"Should" expresses advice: you should go to bed early. "Must not" and "may not" express prohibition — not advice.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e22eee7-36b9-5f3a-8e0f-5333d3b76fdf', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "Students ___ wear a uniform at school. It is the rule."', '[{"id":"a","text":"have to"},{"id":"b","text":"should"},{"id":"c","text":"might"},{"id":"d","text":"could"}]'::jsonb, 'a', '"It is the rule" shows an obligation imposed from outside, which "have to" expresses: students have to wear a uniform. "should" is only advice (weaker than a rule); "might" and "could" express possibility, not obligation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e66eafa-708f-5de1-a6cc-2921d6e02ffc', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "___ I use your dictionary, please?" (informal permission)', '[{"id":"a","text":"Should"},{"id":"b","text":"Can"},{"id":"c","text":"Must"},{"id":"d","text":"Might"}]'::jsonb, 'b', '"Can" is used for informal permission requests: Can I use your dictionary? "Could" would be more polite; "May" more formal.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ffd3bb-6105-5323-92a1-3cc14b8348db', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Which sentence means you are NOT allowed to do something?', '[{"id":"a","text":"You mustn''t smoke here."},{"id":"b","text":"You don''t have to come."},{"id":"c","text":"You should rest."},{"id":"d","text":"You might stay."}]'::jsonb, 'a', '"Mustn''t" expresses prohibition — you are not allowed to smoke here. "Don''t have to" simply means it is not necessary.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4455f0a-1f51-5dad-ad63-3e592ebb5d36', 'd33dfa7f-2d01-5e1c-aac3-8c969ee05d93', 'Complete: "I''m not sure, but she ___ be at the library."', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"can''t"},{"id":"d","text":"might"}]'::jsonb, 'd', '"Might" expresses weak or uncertain possibility: she might be at the library. "Must" would be near certainty; "might" fits "I''m not sure".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5e9f70de-f505-5482-a231-2c5e52d2bb68', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', '⚔️ Boss: master the modals', 3, 120, 30, 'boss', 'admin', 2)
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
  ('59194e7b-1eac-57ca-935a-de51f43964ea', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the grammatically correct sentence:', '[{"id":"a","text":"He musts leave now."},{"id":"b","text":"He must leave now."},{"id":"c","text":"He must to leave now."},{"id":"d","text":"He must leaves now."}]'::jsonb, 'b', 'Modals do not take -s, and "must" is not followed by "to". The correct form is modal + base verb: he must leave now.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2b8ba0d-7631-5805-8846-a5fa20b419c6', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the most polite request:', '[{"id":"a","text":"Could you pass the salt, please?"},{"id":"b","text":"Can you pass the salt?"},{"id":"c","text":"Pass the salt."},{"id":"d","text":"You should pass the salt."}]'::jsonb, 'a', '"Could you... please?" is the most polite form for a request. "Can" is acceptable but less formal; "could" is more polite.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e6e3345-a167-528b-86c9-8f8012c051f7', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Complete: "When she was a child, she ___ speak French fluently."', '[{"id":"a","text":"can"},{"id":"b","text":"may"},{"id":"c","text":"could"},{"id":"d","text":"should"}]'::jsonb, 'c', '"Could" is the past form of "can" and expresses past ability: she could speak French fluently when she was a child.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68c353c4-5d65-5e6c-a162-99ffe1dfcef8', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Choose the correct sentence about formal permission:', '[{"id":"a","text":"Can I go to the toilet?"},{"id":"b","text":"May I leave the room, please?"},{"id":"c","text":"Must I go to the toilet?"},{"id":"d","text":"Should I leave the room?"}]'::jsonb, 'b', '"May I...?" is the formal way to ask for permission. "Can" is informal; "must" is for obligation; "should" is for advice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('101b87bc-3422-5b24-b2e4-1cd2a0ca63ab', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'What is the difference between these two sentences? (1) "You mustn''t tell her." (2) "You don''t have to tell her."', '[{"id":"a","text":"They mean the same thing: it is not necessary."},{"id":"b","text":"(1) means it is forbidden; (2) means it is not necessary."},{"id":"c","text":"(1) means it is not necessary; (2) means it is forbidden."},{"id":"d","text":"Both mean you are not allowed."}]'::jsonb, 'b', '"Mustn''t" = prohibition (you are NOT allowed to tell her). "Don''t have to" = no obligation (you are free not to, but it''s your choice). These are opposite in meaning.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed4adc8e-de97-5a8f-a68f-5601a89daaa2', '5e9f70de-f505-5482-a231-2c5e52d2bb68', 'Complete: "It''s getting dark. We ___ hurry, or we''ll miss the bus."', '[{"id":"a","text":"might not"},{"id":"b","text":"should"},{"id":"c","text":"don''t have to"},{"id":"d","text":"couldn''t"}]'::jsonb, 'b', '"Should" expresses a strong recommendation or advice — the right thing to do in the situation: we should hurry. "Might not" and "don''t have to" would weaken the urgency incorrectly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1ce03879-94cc-59c1-9b29-387f46b3cb17', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', '👑 Elite Challenge: Modal Mastery Under Pressure', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('3f3f291b-0ed5-5034-8ea2-007904302b91', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Look at the context carefully. "There is thick smoke rising from the neighbour''s kitchen window." Which sentence expresses a logical deduction based on the evidence?', '[{"id":"a","text":"The food must be burning."},{"id":"b","text":"The food should be burning."},{"id":"c","text":"The food may burn."},{"id":"d","text":"The food can burn."}]'::jsonb, 'a', '"Must" is used for a strong logical deduction from evidence — the smoke is direct proof that something is burning. "Should" expresses expectation or advice, not deduction. "May burn" is a future possibility with no evidence base. "Can burn" states general ability, not a deduction about what is happening right now.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eba3fdd7-1b65-5e0b-a7d7-298e72c9e03a', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Leila told her teacher she was in Tunis all day yesterday, but her classmate saw her in Sfax at exactly the same time. What is the only logical conclusion?', '[{"id":"a","text":"Leila might not have been telling the truth."},{"id":"b","text":"Leila can''t have been telling the truth."},{"id":"c","text":"Leila mustn''t have been telling the truth."},{"id":"d","text":"Leila shouldn''t have been telling the truth."}]'::jsonb, 'b', '"Can''t have" expresses a logical impossibility about the past — a person cannot be in two cities at once, so it is impossible that she was telling the truth. "Might not have" only suggests doubt, not certainty. "Mustn''t have" is not used for past deduction; "mustn''t" is a prohibition modal. "Shouldn''t have" expresses past criticism, not logical deduction.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecf5bd5c-0f9d-5239-a6b2-06167c953a96', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'Your friend arrives at your door without warning. You say: "You ___ me you were coming! I would have cooked something."', '[{"id":"a","text":"must have told"},{"id":"b","text":"could tell"},{"id":"c","text":"should have told"},{"id":"d","text":"might have told"}]'::jsonb, 'c', '"Should have told" expresses past criticism or regret — the action did not happen, but it was the right thing to do. "Must have told" would mean you are deducing that the person did tell you (which contradicts the context). "Could tell" is present ability, not past. "Might have told" suggests only a weak past possibility, not the implied criticism in the speaker''s tone.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb70b1c9-47f1-5f87-af54-9173dbe7ab3e', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'The national exam results have not been published yet. Ali studied hard but the exam was very difficult. Which sentence is the most appropriate?', '[{"id":"a","text":"Ali must pass the exam."},{"id":"b","text":"Ali can''t pass the exam."},{"id":"c","text":"Ali should pass the exam."},{"id":"d","text":"Ali might pass the exam."}]'::jsonb, 'd', '"Might" expresses weak possibility — results are unknown and the outcome is uncertain (he studied hard but the exam was difficult). "Must" is used for strong logical deduction from clear evidence, which does not apply when the outcome is genuinely unknown. "Can''t" would mean it is logically impossible for him to pass, which contradicts his hard work. "Should" implies an expected or predictable outcome based on an established norm, but the added difficulty creates real uncertainty that "might" captures best.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8aeba267-0d13-5fa7-91bb-0e9a7697967e', '1ce03879-94cc-59c1-9b29-387f46b3cb17', '"The school regulations state that all pupils ___ arrive before 8:00 a.m. Latecomers will be sent to the headmaster." Which modal fits the context correctly?', '[{"id":"a","text":"have to"},{"id":"b","text":"must"},{"id":"c","text":"should"},{"id":"d","text":"may"}]'::jsonb, 'a', '"Have to" expresses external obligation — the rule comes from school regulations, an outside authority, not the speaker''s personal feeling. "Must" is used when the obligation comes from the speaker''s own will or authority (internal obligation). "Should" is advice or recommendation, not a binding rule. "May" expresses permission or possibility, not obligation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a452b60-51b7-5ddc-874e-12e6700c8005', '1ce03879-94cc-59c1-9b29-387f46b3cb17', 'She noticed the earlier train was still at the platform and chose to wait for her friend instead. She missed the award ceremony as a result. The best analysis of her situation is:', '[{"id":"a","text":"She could have taken the earlier train, but she chose not to."},{"id":"b","text":"She must have taken the earlier train to arrive on time."},{"id":"c","text":"She can''t have taken the earlier train."},{"id":"d","text":"She may take the earlier train if she hurries."}]'::jsonb, 'a', '"Could have" expresses a past possibility or option that existed but was not used — the train was there, the ability and opportunity were present, yet she chose not to act on them. "Must have taken" is a deduction that she did board the train, which contradicts the context. "Can''t have taken" implies it was impossible, also contradicted by the facts. "May take" is present or future possibility, not relevant to a past situation that has already concluded.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b58ef84-e8ff-5908-85ae-b13cda972800', '9fc5be6f-66c8-5756-a2b9-b3021d83e1ba', 'english', '🔁 Practice Plus: modal verbs review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5db5a8d8-fab9-5969-9c94-e595ed9267aa', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Complete: "You look tired. You ___ go to bed early."', '[{"id":"a","text":"must"},{"id":"b","text":"should"},{"id":"c","text":"can"},{"id":"d","text":"have to"}]'::jsonb, 'b', 'Friendly advice uses "should": you should go to bed early. "must" and "have to" express strong obligation, which is too forceful for a suggestion; "can" expresses ability or permission, not advice.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fd3fc33-e3db-595a-a973-7967c0469ca6', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Complete: "You ___ smoke here; it''s a hospital."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"shouldn''t to"},{"id":"d","text":"mustn''t to"}]'::jsonb, 'a', '"mustn''t" expresses prohibition (it is forbidden): you mustn''t smoke here. "don''t have to" means it is not necessary (no obligation), which is the opposite meaning; modals are followed by a bare infinitive, so "shouldn''t to" and "mustn''t to" wrongly add "to".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f53f9f28-16bb-5349-a7d9-a3b69c334298', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Choose the correct sentence:', '[{"id":"a","text":"She can to swim very well."},{"id":"b","text":"She cans swim very well."},{"id":"c","text":"She can swim very well."},{"id":"d","text":"She can swims very well."}]'::jsonb, 'c', 'A modal is followed by the bare infinitive and never changes for the third person: she can swim. "can to" wrongly adds "to"; "cans" wrongly adds -s to the modal; "can swims" wrongly adds -s to the main verb.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48f3e5a8-8ced-57a6-9b00-4d5794ed4dd4', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Complete: "___ I open the window? It''s very hot."', '[{"id":"a","text":"May"},{"id":"b","text":"Must"},{"id":"c","text":"Should I to"},{"id":"d","text":"Am I"}]'::jsonb, 'a', '"May I...?" is the polite way to ask for permission: May I open the window? "Must I" asks about obligation, not permission; "Should I to" wrongly adds "to" after the modal; "Am I" is not a modal and leaves "open" without a correct form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ea96d32-61f6-596f-8ba3-de15278076bc', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Complete: "It''s a public school, so students ___ pay any fees."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"shouldn''t"},{"id":"d","text":"can''t"}]'::jsonb, 'b', '"don''t have to" means there is no obligation: the fees are simply not required. "mustn''t" would mean paying is forbidden, which is not the idea; "shouldn''t" gives advice against it; "can''t" expresses impossibility or refusal.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad16f401-eb6f-593c-a90c-07f819cc0d58', '1b58ef84-e8ff-5908-85ae-b13cda972800', 'Complete: "The lights are off, so they ___ be asleep."', '[{"id":"a","text":"can"},{"id":"b","text":"must"},{"id":"c","text":"should"},{"id":"d","text":"have to"}]'::jsonb, 'b', '"must" expresses a logical deduction from evidence: the lights are off, so they must be asleep. "can" here would suggest ability, not certainty; "should" expresses advice or expectation, weaker than a deduction; "have to" expresses obligation, not a conclusion.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('390d080b-349c-538c-9250-acd59fd6c1c3', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'Which conditional form is used for general truths and scientific facts?', '[{"id":"a","text":"First conditional: if + present simple, will + base verb"},{"id":"b","text":"Zero conditional: if + present simple, present simple"},{"id":"c","text":"Second conditional: if + past simple, would + base verb"},{"id":"d","text":"Zero conditional: if + past simple, present simple"}]'::jsonb, 'b', 'The zero conditional (if + present simple, present simple) expresses facts and general truths where the result always follows the condition.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('462d9345-5c31-5111-8ce8-314de8fd5caa', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'What does the second conditional express?', '[{"id":"a","text":"A real and likely future situation"},{"id":"b","text":"A general scientific truth"},{"id":"c","text":"An imaginary or hypothetical situation in the present or future"},{"id":"d","text":"A completed past action"}]'::jsonb, 'c', 'The second conditional (if + past simple, would + base verb) describes situations that are unreal, imaginary, or unlikely right now.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da303622-b350-5b8b-9b6d-370d9728bb8e', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'Which sentence is a correctly formed first conditional?', '[{"id":"a","text":"If you will study hard, you will pass."},{"id":"b","text":"If you studied hard, you will pass."},{"id":"c","text":"If you study hard, you will pass."},{"id":"d","text":"If you study hard, you would pass."}]'::jsonb, 'c', 'The first conditional uses the present simple in the if-clause (never "will") and will + base verb in the main clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('902f8a7c-6687-5818-814b-a17e2eef1444', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'In formal/standard English, which form of "be" is used in the if-clause of a second conditional?', '[{"id":"a","text":"\"was\" for all persons"},{"id":"b","text":"\"is\" for all persons"},{"id":"c","text":"\"were\" for all persons"},{"id":"d","text":"\"are\" for all persons"}]'::jsonb, 'c', 'In formal and standard English, the second conditional uses "were" for all persons in the if-clause: "If I were you, I would apologise."', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32d6d026-1f7e-5d8d-9fea-2141ee659a6a', '04cd9fbd-81fc-5332-b16f-d4105405d5b6', 'What does "unless" mean in a conditional sentence?', '[{"id":"a","text":"if"},{"id":"b","text":"although"},{"id":"c","text":"if ... not"},{"id":"d","text":"even if"}]'::jsonb, 'c', '"Unless" means "if ... not". For example, "Unless you hurry, you will miss the train" means "If you don''t hurry, you will miss the train."', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('97d5948a-d69a-595c-a33a-175dd7c3b34e', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', 'Practice: zero, first and second conditionals', 2, 75, 15, 'practice', 'admin', 1)
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
  ('013e8407-3e0a-5ecc-af47-acfb7edf86d9', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the zero conditional: "If you mix red and blue, you ___ purple."', '[{"id":"a","text":"will get"},{"id":"b","text":"would get"},{"id":"c","text":"got"},{"id":"d","text":"get"}]'::jsonb, 'd', 'Mixing red and blue always gives purple, so this is a general truth = zero conditional, which uses the present simple in both clauses: you get purple. "will get" would make it a first conditional (a specific future result); "would get" is second conditional (imaginary); "got" is past simple and does not fit a timeless fact.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57545cb8-cc45-5e9a-acc6-42102f111e27', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the first conditional: "If she ___ harder, she will pass the baccalaureate."', '[{"id":"a","text":"studied"},{"id":"b","text":"will study"},{"id":"c","text":"studies"},{"id":"d","text":"would study"}]'::jsonb, 'c', 'In the first conditional, the if-clause uses the present simple and "will" appears only in the main clause: if she studies harder, she will pass. So "will study" inside the if-clause is the classic mistake; "studied"/"would study" belong to the second conditional (imaginary), not this realistic situation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee916acc-ccc1-509c-934c-be74d6578dc8', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Complete the second conditional: "If I ___ a superhero, I would fly to school."', '[{"id":"a","text":"am"},{"id":"b","text":"will be"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', 'Being a superhero is imaginary, so this is a second conditional. In standard English the verb "be" takes "were" for all persons in the if-clause: if I were a superhero. "am" is present (real); "will be" belongs to the first conditional; "would be" is for the main clause, not the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3be55d8-8928-58bb-bd27-181af4a0d5e3', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Which sentence correctly uses a comma?', '[{"id":"a","text":"I will help you, if you ask me."},{"id":"b","text":"If you ask me I will help you."},{"id":"c","text":"If, you ask me I will help you."},{"id":"d","text":"If you ask me, I will help you."}]'::jsonb, 'd', 'When the if-clause comes first, place a comma after it: "If you ask me, I will help you." No comma is used when the main clause comes first.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f28f12e-250e-5f6c-9fe4-d5c4de564764', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Identify the conditional type: "If animals could talk, the world would be very different."', '[{"id":"a","text":"Zero conditional"},{"id":"b","text":"First conditional"},{"id":"c","text":"No conditional"},{"id":"d","text":"Second conditional"}]'::jsonb, 'd', 'If + past simple (could talk) + would + base verb (would be) = second conditional. Animals cannot really talk — it is a hypothetical, unreal situation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('402518e0-c2ac-5c9c-86c9-8db84a66c20a', '97d5948a-d69a-595c-a33a-175dd7c3b34e', 'Rewrite using "unless": "If you don''t eat breakfast, you will feel weak." Choose the correct version:', '[{"id":"a","text":"Unless you don''t eat breakfast, you will feel weak."},{"id":"b","text":"Unless you ate breakfast, you would feel weak."},{"id":"c","text":"Unless you eat breakfast, you would feel weak."},{"id":"d","text":"Unless you eat breakfast, you will feel weak."}]'::jsonb, 'd', '"Unless" already means "if ... not", so the verb stays positive: unless you eat breakfast, you will feel weak. Using "don''t" after "unless" creates a double negative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa6477e9-c60c-5771-9828-15c32bace66c', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', '⚔️ Boss: master the conditionals', 3, 120, 30, 'boss', 'admin', 2)
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
  ('fc64ccc6-a874-5048-aa2b-ec4bf7fedd1b', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Choose the correct main clause: "If you press this button, the machine ___,"', '[{"id":"a","text":"started"},{"id":"b","text":"starts"},{"id":"c","text":"would start"},{"id":"d","text":"will starting"}]'::jsonb, 'b', 'Pressing the button always makes the machine start, so this is a zero conditional (a reliable fact): both clauses use the present simple, hence "the machine starts". "started" is past simple; "would start" is second conditional (imaginary); "will starting" is not a valid verb form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('349da296-708e-512c-98a5-f79c0d32d5fd', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete: "If I ___ you, I would talk to the teacher about this problem."', '[{"id":"a","text":"am"},{"id":"b","text":"was"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', '"If I were you" gives advice about an imaginary situation, so it is a second conditional. In standard English, "be" takes "were" for every person in the if-clause: If I were you. "am" is the real present; "was" is the common informal form but not the exam-standard one; "would be" belongs in the main clause, not the if-clause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd9dffa7-3d7a-5ecc-a39f-486149eb142f', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Which sentence is a correct first conditional?', '[{"id":"a","text":"If it will rain, we stay inside."},{"id":"b","text":"If it rained, we will stay inside."},{"id":"c","text":"If it rains, we would stay inside."},{"id":"d","text":"If it rains, we will stay inside."}]'::jsonb, 'd', 'First conditional: if + present simple (rains) + will + base verb (will stay), as in option d. Option a wrongly puts "will" in the if-clause; option b mixes past simple ("rained") with "will"; option c uses "would" in the main clause, which belongs to the second conditional.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d753d89-3393-5d46-80cb-7105df4178f0', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Choose the sentence where the comma is used correctly:', '[{"id":"a","text":"We will cancel the trip, if it snows."},{"id":"b","text":"If it snows we will cancel the trip."},{"id":"c","text":"We will cancel, the trip if it snows."},{"id":"d","text":"If it snows, we will cancel the trip."}]'::jsonb, 'd', 'The comma is placed after the if-clause when it comes first in the sentence: "If it snows, we will cancel the trip." No comma is needed when the main clause comes first (option a has an unnecessary comma).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('279267c3-6b7e-528e-a57e-a4ab75cfd473', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete: "___ you finish early, you can leave." (use unless or if)', '[{"id":"a","text":"Unless"},{"id":"b","text":"Although"},{"id":"c","text":"If"},{"id":"d","text":"Because"}]'::jsonb, 'c', 'The sentence means: finishing early is the condition for being allowed to leave. This is a positive condition, so use "if": if you finish early, you can leave. "Unless" would mean the opposite.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4ec5fc8-06d7-59b4-bdeb-31ef723ff6fb', 'aa6477e9-c60c-5771-9828-15c32bace66c', 'Complete both blanks: "If she ___ the exam, her parents ___ very proud."', '[{"id":"a","text":"will pass ... are"},{"id":"b","text":"passes ... will be"},{"id":"c","text":"passed ... will be"},{"id":"d","text":"passes ... would be"}]'::jsonb, 'b', 'First conditional: if + present simple (passes) + will + base verb (will be). The situation is realistic — she may well pass. Option c mixes past simple with will (second conditional main clause with first conditional if-clause), which is incorrect.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', '👑 Elite Challenge: Conditionals Mastery', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1eec2a52-2bf6-5ef9-ad37-838cf0aa6bdb', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Complete both blanks: "If the students ___ more carefully, they ___ that mistake."', '[{"id":"a","text":"had read ... would not have made"},{"id":"b","text":"have read ... would not make"},{"id":"c","text":"read ... would not have made"},{"id":"d","text":"had read ... would not make"}]'::jsonb, 'a', 'This is a third conditional: the reading happened (or did not happen) in the past and the mistake is a past consequence. Form: if + past perfect (had read) + would have + past participle (would not have made). Option d mixes past perfect with a second-conditional main clause, creating an incorrect hybrid.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9552a62c-6941-5408-b0ca-cb7b41978a9b', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Identify the conditional type: "If she had taken the earlier bus, she would be home by now."', '[{"id":"a","text":"First conditional — real future situation"},{"id":"b","text":"Second conditional — unreal present situation"},{"id":"c","text":"Third conditional — unreal past situation"},{"id":"d","text":"Mixed conditional — past condition, present result"}]'::jsonb, 'd', 'The if-clause uses past perfect (had taken), referring to a past event that did not happen. The main clause uses would + base verb (would be), describing an unreal present result. This is a mixed conditional: the condition is in the past, but the consequence is felt now. A pure third conditional would have ''would have been'' in the main clause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a556f41-88ff-55ab-b724-0ab31deddf69', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Choose the option that correctly rewrites this sentence using "unless": "You will not pass the test if you do not revise your notes."', '[{"id":"a","text":"You will not pass the test unless you don''t revise your notes."},{"id":"b","text":"You will not pass the test unless you revise your notes."},{"id":"c","text":"Unless you will revise your notes, you will not pass the test."},{"id":"d","text":"You will not pass the test unless you revised your notes."}]'::jsonb, 'b', '"Unless" already contains the negative meaning of "if ... not", so the clause after it must be positive. "Unless you revise" = "if you do not revise" — this is correct. Option a adds a double negative (unless + don''t), which is wrong. Option c wrongly uses "will" in the unless-clause. Option d uses past simple, which changes the conditional type incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78208151-f432-5986-89c6-95d2261fe015', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Which sentence correctly uses "could" in a second conditional?', '[{"id":"a","text":"If I have more free time, I could travel the world."},{"id":"b","text":"If I had more free time, I could travel the world."},{"id":"c","text":"If I had more free time, I could have travelled the world."},{"id":"d","text":"If I had had more free time, I could travel the world."}]'::jsonb, 'b', 'In the second conditional, the if-clause uses the past simple (had) for an unreal present or future situation. The main clause can use "would", "could", or "might" + base verb. "Could travel" expresses possibility in an unreal situation, making option b correct. Option a uses present simple in the if-clause (first conditional form). Option c uses "could have travelled" (third conditional main clause). Option d uses past perfect in the if-clause (third conditional form).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('277e4e6e-27b9-5fde-97cd-c6f8f1586ce2', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Four students wrote sentences about a past exam. Which sentence contains a grammatical error?', '[{"id":"a","text":"If Omar had studied the vocabulary, he would have scored higher."},{"id":"b","text":"If Nour had been more careful, she wouldn''t have misread the question."},{"id":"c","text":"If Tarek had revised, he would pass the exam easily."},{"id":"d","text":"If Sana had arrived earlier, she would have had more time."}]'::jsonb, 'c', 'Option c is incorrect because it mixes the third conditional if-clause (had revised — past perfect, referring to the past) with a second conditional main clause (would pass — present result). For a pure third conditional, it should be "would have passed". For a mixed conditional with a present result, the sentence would need a context change. As written, the inconsistency makes it grammatically wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75194e7f-9c18-5bb3-b70d-cac4a264bee3', '6fbedf7a-b234-5c70-b36f-1f11fed034fd', 'Complete: "___ the weather forecast ___ good tomorrow, we ___ have cancelled the school trip already."', '[{"id":"a","text":"If ... is ... will"},{"id":"b","text":"Unless ... were ... would"},{"id":"c","text":"If ... had been ... would have"},{"id":"d","text":"Unless ... had been ... would"}]'::jsonb, 'c', 'The adverb "already" signals a completed past action (the cancellation is being discussed as something that would have happened in the past). The correct structure is a third conditional: if + past perfect (had been) + would have + past participle (would have cancelled). "Already" confirms the result belongs to the past, ruling out second conditional forms. Unless does not fit the logic of this sentence, which states a positive past condition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'c9c30f7d-f352-5da1-8baa-12eac9f31b36', 'english', '🔁 Practice Plus: conditionals review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('2557f68b-d1fe-54ce-89df-1820a60e498f', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Complete: "If you heat ice, it ___."', '[{"id":"a","text":"will melt"},{"id":"b","text":"melts"},{"id":"c","text":"would melt"},{"id":"d","text":"melted"}]'::jsonb, 'b', 'A general truth uses the zero conditional: if + present simple, present simple. If you heat ice, it melts. "will melt" belongs to the first conditional (a specific future result), not a permanent fact; "would melt" and "melted" belong to the second conditional (imaginary situations).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78bec8e7-42c1-5dda-80fd-20ba4136196d', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Complete: "If it rains tomorrow, we ___ at home."', '[{"id":"a","text":"stay"},{"id":"b","text":"will stay"},{"id":"c","text":"would stay"},{"id":"d","text":"stayed"}]'::jsonb, 'b', 'A likely future condition uses the first conditional: if + present simple, will + base verb. If it rains tomorrow, we will stay at home. "stay" alone misses "will"; "would stay"/"stayed" are second-conditional forms for unreal situations.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9829779a-863f-5a57-88b7-21254e3d8e69', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Complete: "If I ___ rich, I would travel the world."', '[{"id":"a","text":"am"},{"id":"b","text":"will be"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', 'An unreal or imaginary present situation uses the second conditional: if + past simple, would + base verb (and "were" is used for all persons). If I were rich, I would travel. "am"/"will be" suit real conditions; "would be" cannot appear in the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc04747b-aebe-5c37-a221-d25b5c3dcc39', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Choose the correctly punctuated sentence:', '[{"id":"a","text":"If you study hard you will pass."},{"id":"b","text":"If you study hard, you will pass."},{"id":"c","text":"You will pass, if you study hard."},{"id":"d","text":"If, you study hard you will pass."}]'::jsonb, 'b', 'When the if-clause comes first, it is followed by a comma: If you study hard, you will pass. (a) omits that comma; in (c) there is no comma when the if-clause comes second; (d) wrongly places the comma straight after "If".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c226d66f-23d6-5e65-ba82-2229c946b41c', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Complete: "___ you hurry, you will miss the bus."', '[{"id":"a","text":"If"},{"id":"b","text":"Unless"},{"id":"c","text":"When"},{"id":"d","text":"Because"}]'::jsonb, 'b', '"Unless" means "if... not": Unless you hurry (= if you do not hurry), you will miss the bus. "If" would reverse the meaning (hurrying would cause you to miss the bus); "When" loses the conditional idea; "Because" introduces a reason, not a condition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f2d069b-fa0b-5f5c-9903-f395c6ade85b', 'a0cec752-fdcc-52c6-8f78-9fa392d7b638', 'Complete: "If she ___ harder, she would have better marks."', '[{"id":"a","text":"works"},{"id":"b","text":"will work"},{"id":"c","text":"worked"},{"id":"d","text":"would work"}]'::jsonb, 'c', 'This is a second conditional describing an unreal/imagined situation, so the if-clause takes the past simple: If she worked harder... she would have better marks. "works"/"will work" are for real conditions; "would work" cannot go in the if-clause — "would" belongs in the result clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6c069575-64c8-5d0f-bd94-5fda4d4c80a3', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('79afc241-0f21-57eb-b2de-d9c503d9d75c', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'What is the core formula for forming the passive voice?', '[{"id":"a","text":"subject + have + past participle"},{"id":"b","text":"subject + be + past participle"},{"id":"c","text":"subject + be + present participle (-ing)"},{"id":"d","text":"subject + do + base verb"}]'::jsonb, 'b', 'The passive is always formed with the correct form of "be" + the past participle of the main verb, regardless of tense.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3248e070-6326-5ec2-9a5c-9a6562bf3d43', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'Which sentence correctly transforms "They speak French here" into the present simple passive?', '[{"id":"a","text":"French was spoken here."},{"id":"b","text":"French has been spoken here."},{"id":"c","text":"French is spoken here."},{"id":"d","text":"French are spoken here."}]'::jsonb, 'c', 'The present simple passive uses is/are + past participle. "French" is a singular noun, so the correct form is "is spoken".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0d0bbc9-7f9c-56c2-a957-6fda2126ca6b', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'What is the first step when converting an active sentence to a passive one?', '[{"id":"a","text":"Add \"by\" and the original subject at the end."},{"id":"b","text":"Move the object of the active sentence to the subject position."},{"id":"c","text":"Change the main verb to its present participle."},{"id":"d","text":"Remove the subject of the active sentence entirely."}]'::jsonb, 'b', 'The first step is to move the object of the active sentence into the subject position. Then choose the correct form of "be" and add the past participle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5b5be7e-f4ab-55b6-a38e-181570ee31d9', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'Which sentence correctly uses the past simple passive?', '[{"id":"a","text":"The bridge is built in 1990."},{"id":"b","text":"The bridge was build in 1990."},{"id":"c","text":"The bridge were built in 1990."},{"id":"d","text":"The bridge was built in 1990."}]'::jsonb, 'd', 'The past simple passive uses was/were + past participle. "Bridge" is singular, so "was" is correct, and "built" is the past participle of "build".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b71e28ea-6533-5302-b2c9-9ddad3b2c439', '6c069575-64c8-5d0f-bd94-5fda4d4c80a3', 'When is the "by + agent" phrase typically omitted in a passive sentence?', '[{"id":"a","text":"When the sentence is in the present tense"},{"id":"b","text":"When the subject is plural"},{"id":"c","text":"When the agent is unknown, unimportant, or obvious from context"},{"id":"d","text":"When the verb is irregular"}]'::jsonb, 'c', 'The "by + agent" phrase is often left out when the agent is unknown ("My wallet was stolen"), unimportant, or already obvious from context.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('69ebe656-2d06-5124-80fc-9f898ee0a2b8', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', 'Practice: active or passive?', 2, 60, 12, 'practice', 'admin', 1)
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
  ('cf42ec20-80b2-537e-a00e-3c58063c62ff', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Choose the correct passive form: "The windows ___ every week." (present simple passive)', '[{"id":"a","text":"clean"},{"id":"b","text":"are cleaned"},{"id":"c","text":"is cleaned"},{"id":"d","text":"were cleaned"}]'::jsonb, 'b', 'The passive = "be" + past participle. "The windows" is plural and the time is present (every week), so we use ARE + cleaned: the windows are cleaned. "clean" is active; "is cleaned" wrongly uses the singular "is"; "were cleaned" is past, not present.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b38e0c4-8ce6-5c7a-a51b-cd1d96b9c7b9', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Complete: "Arabic ___ in Tunisia." (present simple passive of ''speak'')', '[{"id":"a","text":"speaks"},{"id":"b","text":"is spoken"},{"id":"c","text":"are spoken"},{"id":"d","text":"was spoken"}]'::jsonb, 'b', '"Arabic" (a language) is singular, so the present simple passive uses IS + the past participle "spoken": Arabic is spoken in Tunisia. "speaks" is active; "are spoken" wrongly uses the plural "are"; "was spoken" is past, not present.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1886b0c7-fccb-565d-92ff-f84e3a6993f4', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Turn this active sentence into passive: "Someone broke the vase." The correct passive is:', '[{"id":"a","text":"The vase is broken."},{"id":"b","text":"The vase was broken."},{"id":"c","text":"The vase were broken."},{"id":"d","text":"The vase was break."}]'::jsonb, 'b', 'The active verb "broke" is past simple, so the passive keeps the past tense: "the vase" (singular) + WAS + past participle "broken". "is broken" changes the tense to present; "were broken" wrongly uses the plural "were"; "was break" uses the base verb instead of the past participle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e072540f-1856-5eac-9a8e-db19cec747e6', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Which sentence is correct?', '[{"id":"a","text":"The letters were written by the students."},{"id":"b","text":"The letters were write by the students."},{"id":"c","text":"The letters was written by the students."},{"id":"d","text":"The letters are written by the students yesterday."}]'::jsonb, 'a', '"The letters" is plural and the action is past, so we need WERE + past participle (written): The letters were written by the students.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9e2968b-a92d-5746-9362-164238da0854', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Complete: "The exam ___ yesterday by all the students." (past simple passive of ''take'')', '[{"id":"a","text":"is taken"},{"id":"b","text":"are taken"},{"id":"c","text":"was taken"},{"id":"d","text":"took"}]'::jsonb, 'c', '"yesterday" signals past tense and "the exam" is singular, so the past simple passive is WAS + the past participle "taken": the exam was taken. "is taken"/"are taken" are present; "took" is the active past, not the passive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7989200f-316a-50cf-a23b-c990be75e64e', '69ebe656-2d06-5124-80fc-9f898ee0a2b8', 'Why is the passive preferred in: "Oil was discovered in the desert"?', '[{"id":"a","text":"Because the subject is performing the action."},{"id":"b","text":"Because the action is happening right now."},{"id":"c","text":"Because the agent is unimportant; the focus is on the discovery."},{"id":"d","text":"Because \"discover\" is a stative verb."}]'::jsonb, 'c', 'We use the passive here because the agent (who discovered it) is unimportant or unknown — the focus is on the result: oil being discovered.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50566438-5c32-582c-9b59-43a0b96cc9a4', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', '⚔️ Boss: passive voice mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('43b02806-bc22-570c-b797-0b37b895db64', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Transform to passive: "They make these shoes in Italy." The correct passive is:', '[{"id":"a","text":"These shoes are made in Italy."},{"id":"b","text":"These shoes were made in Italy."},{"id":"c","text":"These shoes is made in Italy."},{"id":"d","text":"These shoes are make in Italy."}]'::jsonb, 'a', 'The active verb "make" is present simple, so the passive stays present. "These shoes" is plural → ARE + the past participle "made": these shoes are made in Italy. "were made" changes the tense to past; "is made" wrongly uses the singular "is"; "are make" keeps the base verb instead of the participle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fdfff8c-ddbd-5448-85e5-83a9f52730c9', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Transform to passive: "The teacher corrected our homework." The correct passive is:', '[{"id":"a","text":"Our homework is corrected by the teacher."},{"id":"b","text":"Our homework were corrected by the teacher."},{"id":"c","text":"Our homework was correct by the teacher."},{"id":"d","text":"Our homework was corrected by the teacher."}]'::jsonb, 'd', 'The active verb "corrected" is past simple, and "our homework" is singular (uncountable), so the passive is WAS + the past participle "corrected": our homework was corrected by the teacher. "is corrected" changes the tense; "were corrected" wrongly uses the plural "were"; "was correct" uses the adjective/base form, not the past participle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c961b0e5-2864-5565-abe0-a6579f21445f', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Choose the sentence where the passive is used correctly:', '[{"id":"a","text":"The pyramids were build thousands of years ago."},{"id":"b","text":"The pyramids were built thousands of years ago."},{"id":"c","text":"The pyramids was built thousands of years ago."},{"id":"d","text":"The pyramids are built thousands of years ago."}]'::jsonb, 'b', '"The pyramids" is plural and "thousands of years ago" is past, so we use WERE + the past participle "built": the pyramids were built. "were build" keeps the base verb instead of the participle; "was built" wrongly uses the singular "was"; "are built" is present and clashes with the past time marker.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86e69d95-8ade-5dc8-bc07-e6ac553e4be0', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Active: "A student finds a wallet." → Passive:', '[{"id":"a","text":"A wallet is found by a student."},{"id":"b","text":"A wallet found by a student."},{"id":"c","text":"A wallet were found by a student."},{"id":"d","text":"A wallet was found by a student."}]'::jsonb, 'a', 'The active verb "finds" is present simple, and "a wallet" is singular, so the passive is IS + the past participle "found": a wallet is found by a student. Option b drops the auxiliary "is"; "were found" wrongly uses the plural past "were"; "was found" changes the tense to past.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02029c31-8bc4-5e35-8816-cce63c913e55', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Choose the sentence that correctly OMITS the by-agent because it is obvious:', '[{"id":"a","text":"The patient was examined by a doctor."},{"id":"b","text":"The patient is examining."},{"id":"c","text":"The patient was examined."},{"id":"d","text":"The patient examines."}]'::jsonb, 'c', 'When it is obvious that a doctor performs the examination, "by a doctor" adds no information and is correctly omitted: The patient was examined.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01868ac1-1c85-531f-b957-c922c262d7c3', '50566438-5c32-582c-9b59-43a0b96cc9a4', 'Complete the sentence with the correct passive: "The new library ___ last year." (open)', '[{"id":"a","text":"is opened"},{"id":"b","text":"was opened"},{"id":"c","text":"opened"},{"id":"d","text":"were opened"}]'::jsonb, 'b', '"last year" signals past tense and "the new library" is singular, so the passive is WAS + the past participle "opened": the new library was opened last year. "is opened" is present; "opened" alone is the active past, not the passive; "were opened" wrongly uses the plural "were".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4b1a1f73-c67e-5e29-92d8-9b3a4b074943', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', '👑 Elite Challenge: Passive Voice Across Tenses & Modals', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5c58a0e6-f68f-5902-ad5a-dfaf00b004c1', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (future simple): "The government will announce the results tomorrow."
Which option is correct?', '[{"id":"a","text":"The results will announced by the government tomorrow."},{"id":"b","text":"The results are announced by the government tomorrow."},{"id":"c","text":"The results will be announced by the government tomorrow."},{"id":"d","text":"The results were announced by the government tomorrow."}]'::jsonb, 'c', 'Future simple passive = will + be + past participle. "Announce" → past participle "announced". The object "the results" becomes the subject: The results WILL BE ANNOUNCED by the government tomorrow. Option a omits "be"; b uses present passive (wrong tense); d uses past passive (wrong tense).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3509320-48b2-5d64-b94a-277dd38e4efd', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (present perfect): "Someone has stolen the exam papers."
Which option is correct?', '[{"id":"a","text":"The exam papers have been stolen."},{"id":"b","text":"The exam papers has been stolen."},{"id":"c","text":"The exam papers were stolen."},{"id":"d","text":"The exam papers had been stolen."}]'::jsonb, 'a', 'Present perfect passive = have / has + been + past participle. "The exam papers" is plural → HAVE (not has). By-agent is omitted because the agent (someone) is unknown. Option b incorrectly uses "has" with a plural subject; c is past simple (loses the present-perfect meaning); d is past perfect (wrong tense).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('741a817a-a456-5c11-aca4-40c0f9dd6d99', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Transform to passive (modal — must): "You must submit all assignments before Friday."
Which option is correct?', '[{"id":"a","text":"All assignments must been submitted before Friday."},{"id":"b","text":"All assignments must be submitted before Friday."},{"id":"c","text":"All assignments must being submitted before Friday."},{"id":"d","text":"All assignments must submitted before Friday."}]'::jsonb, 'b', 'Passive with a modal = modal + be + past participle. "Must" is already a base-form modal, so: must + BE + submitted. Option a uses "been" without "be" (wrong); c uses "being" (continuous form, wrong here); d omits "be" entirely.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('850a7fac-2254-5cb0-ab2a-3bb1860c3d95', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Turn the active question into a passive question (present simple): "Do they teach Arabic in this school?"
Which passive question is correct?', '[{"id":"a","text":"Are Arabic taught in this school?"},{"id":"b","text":"Does Arabic taught in this school?"},{"id":"c","text":"Was Arabic taught in this school?"},{"id":"d","text":"Is Arabic taught in this school?"}]'::jsonb, 'd', 'Present simple passive question = Is / Are + subject + past participle? "Arabic" is an uncountable/singular noun → IS (not are). Past participle of teach = taught. Option a wrongly uses "Are" with the singular noun "Arabic"; b keeps the active auxiliary "Does" (wrong); c uses "Was" — past tense, not present.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35a20b5f-927d-587c-a45a-0c20fcc5c2a7', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Active: "Doctors should check patients regularly."
Which passive sentence is correct AND uses the most natural style (agent omitted when obvious)?', '[{"id":"a","text":"Patients should be check regularly."},{"id":"b","text":"Patients should been checked regularly."},{"id":"c","text":"Patients should be checked regularly."},{"id":"d","text":"Patients should being checked regularly."}]'::jsonb, 'c', 'Modal passive = should + be + past participle (checked). The agent "by doctors" is omitted because it is obvious from context. Option a uses the base form "check" instead of the past participle; b omits "be" and has "been" in the wrong position; d uses "being" (a progressive form that does not follow a bare modal).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('659c49ec-4a06-519d-aba8-8a72e9ad1b81', '4b1a1f73-c67e-5e29-92d8-9b3a4b074943', 'Active: "The jury awarded the winner a gold medal."
Which passive sentence is correct?', '[{"id":"a","text":"The winner were awarded a gold medal by the jury."},{"id":"b","text":"The winner was awarded a gold medal by the jury."},{"id":"c","text":"A gold medal is awarded to the winner by the jury."},{"id":"d","text":"The winner was awarded to a gold medal by the jury."}]'::jsonb, 'b', 'With two-object verbs like "award", the indirect object (the winner) can become the subject: The winner WAS awarded a gold medal by the jury. "The winner" is singular + past tense → WAS (not were). Option a wrongly uses "were" with a singular subject; c uses present tense (wrong) and misplaces "to"; d incorrectly inserts "to" between "awarded" and "a gold medal", which is ungrammatical in this pattern.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('91cddb44-e94f-5907-a8ba-7ce1683c3e42', '2bd52d30-882a-5849-a561-66dad79c756d', 'english', '🔁 Practice Plus: passive voice review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('9f51a9e2-ac5e-5418-9bce-61475a0c46c0', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Complete: "English ___ in many countries around the world."', '[{"id":"a","text":"speaks"},{"id":"b","text":"is spoken"},{"id":"c","text":"is speaking"},{"id":"d","text":"speak"}]'::jsonb, 'b', 'The subject "English" receives the action, so we use the present simple passive: be + past participle = is spoken. "speaks"/"speak" are active; "is speaking" is the active present continuous, which makes English the doer rather than the thing spoken.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5610d0d-6e08-5683-8742-12e78f2babaf', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Choose the passive form of: "They built this bridge in 1990."', '[{"id":"a","text":"This bridge was built in 1990."},{"id":"b","text":"This bridge is built in 1990."},{"id":"c","text":"This bridge built in 1990."},{"id":"d","text":"This bridge was build in 1990."}]'::jsonb, 'a', 'The past simple passive is was/were + past participle: this bridge was built in 1990. (b) uses the present "is" with a finished past time; (c) has no auxiliary, so it is not passive; (d) uses the base form "build" instead of the past participle "built".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7996acd6-f402-5397-b872-795a696c4bb7', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Complete: "The letters ___ yesterday by the postman."', '[{"id":"a","text":"was delivered"},{"id":"b","text":"were delivered"},{"id":"c","text":"are delivered"},{"id":"d","text":"delivered"}]'::jsonb, 'b', 'The plural subject "the letters" and the past time "yesterday" require were + past participle: were delivered. "was delivered" uses the singular "was" with a plural subject; "are delivered" is present, not past; "delivered" alone (active) makes the letters the doer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1dd1def4-86e5-5073-9b3f-49d80a876b39', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Choose the passive form of: "Someone cleans the offices every morning."', '[{"id":"a","text":"The offices are cleaned every morning."},{"id":"b","text":"The offices is cleaned every morning."},{"id":"c","text":"The offices were cleaned every morning."},{"id":"d","text":"The offices are cleaning every morning."}]'::jsonb, 'a', 'The present simple passive with a plural subject is are + past participle: the offices are cleaned. "is cleaned" uses the singular auxiliary with a plural subject; "were cleaned" is past, but "every morning" is present; "are cleaning" is the active continuous, making the offices the doer.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3576e59-8351-52db-963a-e23eb337b92f', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Choose the correct sentence. The agent is unknown.', '[{"id":"a","text":"My bike was stolen last night."},{"id":"b","text":"My bike was stolen by someone last night."},{"id":"c","text":"Someone was stolen my bike last night."},{"id":"d","text":"My bike stole last night."}]'::jsonb, 'a', 'When the doer is unknown or unimportant, we use the passive and simply leave out the "by" phrase: my bike was stolen last night. (b) adds an empty "by someone", exactly the kind of useless agent the passive lets us drop; (c) is muddled (the bike, not someone, was stolen); (d) is active and uses the wrong form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89ca831c-9475-5039-bc24-33bc96445b41', '91cddb44-e94f-5907-a8ba-7ce1683c3e42', 'Complete: "This song ___ by millions of people every day."', '[{"id":"a","text":"listens"},{"id":"b","text":"is listening"},{"id":"c","text":"is listened to"},{"id":"d","text":"is listened"}]'::jsonb, 'c', '"listen" needs the preposition "to", which stays in the passive: this song is listened to. "listens"/"is listening" are active; "is listened" drops the required "to", leaving the verb incomplete.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d5b41c1a-0a53-5c06-915c-102435d5c6c0', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "I am tired." She said ___.', '[{"id":"a","text":"she said that she is tired."},{"id":"b","text":"she said that she was tired."},{"id":"c","text":"she said that I was tired."},{"id":"d","text":"she said that she were tired."}]'::jsonb, 'b', 'When the reporting verb is in the past (said), the present simple "am" shifts back to the past simple "was". The pronoun "I" also changes to "she" to match the speaker.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4d34b52-281d-57e3-8460-aafe4175f0f5', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Which reporting verb always requires a person as its object?', '[{"id":"a","text":"say"},{"id":"b","text":"ask"},{"id":"c","text":"tell"},{"id":"d","text":"report"}]'::jsonb, 'c', '"Tell" always needs a person object: tell me, tell him, tell the class. "Say" never takes a direct person object ("say me" is wrong).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('145aa30d-c72c-5e4d-9190-f15b093dd84f', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'In reported speech, what does "tomorrow" in direct speech change to?', '[{"id":"a","text":"today"},{"id":"b","text":"the day before"},{"id":"c","text":"the next day"},{"id":"d","text":"that day"}]'::jsonb, 'c', '"Tomorrow" in direct speech shifts to "the next day" (or "the following day") in reported speech, because the time reference has changed.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26cb3024-d046-5eee-baa5-4d6eac88fbb0', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "Are you ready?" She asked ___.', '[{"id":"a","text":"if I was ready."},{"id":"b","text":"if was I ready."},{"id":"c","text":"if I am ready."},{"id":"d","text":"if I were ready."}]'::jsonb, 'a', 'Yes/no questions in reported speech use "if" or "whether", with normal word order (subject before verb): "she asked if I was ready". "Are" backshifts to "was".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b165d39a-8b1a-559a-bc93-6ef918be4194', 'aac0bca3-f9b2-50e6-9fe5-095b3caed4c2', 'Direct speech: "Don''t run in the corridor!" The teacher told the students ___.', '[{"id":"a","text":"to not run in the corridor."},{"id":"b","text":"don''t run in the corridor."},{"id":"c","text":"not to run in the corridor."},{"id":"d","text":"that they didn''t run in the corridor."}]'::jsonb, 'c', 'Negative commands in reported speech use tell/ask + person + not to + infinitive. The correct form is "told the students not to run".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', 'Practice: reported speech basics', 2, 60, 12, 'practice', 'admin', 1)
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
  ('94522885-b8e2-5f36-becc-435d20c867e2', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I am tired," she said. Choose the correct reported form:', '[{"id":"a","text":"She said that she is tired."},{"id":"b","text":"She told that she was tired."},{"id":"c","text":"She said that I was tired."},{"id":"d","text":"She said that she was tired."}]'::jsonb, 'd', 'The reporting verb is past (said), so the present simple ''am'' backshifts to past simple ''was''. The pronoun ''I'' changes to ''she''. We use ''say that'', not ''told that''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('719aef66-3c4a-5ad6-9af9-50fd99dcfbce', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Which sentence uses ''tell'' correctly?', '[{"id":"a","text":"She told that she was ready."},{"id":"b","text":"She said me that she was ready."},{"id":"c","text":"She told me that she was ready."},{"id":"d","text":"She told that the test was easy."}]'::jsonb, 'c', '''tell'' always requires a personal object: tell + person + (that) + clause. ''She told me that she was ready'' is the only correct pattern.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a209293d-9928-57f6-8315-b45fbd4f39e3', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I will help you," he said. Choose the correct reported form:', '[{"id":"a","text":"He said that he will help you."},{"id":"b","text":"He told that he would help me."},{"id":"c","text":"He said that he would help me."},{"id":"d","text":"He said that he would help you."}]'::jsonb, 'c', '''will'' backshifts to ''would''. The pronoun ''you'' changes to ''me'' (the listener becomes the reporter). We use ''say that'', not ''told that''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c4cb780-1da9-5b34-bd95-073216e9116a', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "Are you ready?" she asked me. Choose the correct reported question:', '[{"id":"a","text":"She asked me if I was ready."},{"id":"b","text":"She asked me if was I ready."},{"id":"c","text":"She asked me if I am ready."},{"id":"d","text":"She asked if was I ready."}]'::jsonb, 'a', 'Yes/no questions use ''if/whether''. Word order becomes normal (subject before verb): ''if I was ready''. The tense backshifts: ''are'' → ''was''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4aafc66-106d-5f85-918e-89cb6ca105d1', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "Don''t run in the corridor!" the teacher said. Choose the correct reported command:', '[{"id":"a","text":"The teacher said not to run in the corridor."},{"id":"b","text":"The teacher told the students don''t run in the corridor."},{"id":"c","text":"The teacher told the students not to run in the corridor."},{"id":"d","text":"The teacher asked don''t run in the corridor."}]'::jsonb, 'c', 'Negative commands are reported with ''tell + person + not to + infinitive''. ''The teacher told the students not to run in the corridor'' is correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ddeacd6-9014-5387-85ab-5ebca4c59ff1', 'e2d9a8ce-ad7d-5cdd-a8af-04c3a19cea1d', 'Direct: "I can swim," she said. The time word ''now'' in her speech would become:', '[{"id":"a","text":"then"},{"id":"b","text":"today"},{"id":"c","text":"here"},{"id":"d","text":"tomorrow"}]'::jsonb, 'a', 'When time and place words shift to reported speech, ''now'' becomes ''then''. Other shifts: today → that day, tomorrow → the next day, here → there.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('038be31c-9625-5dc2-8227-4a7402dbfe43', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', '⚔️ Boss: reported speech mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('71e33276-0916-5dbf-9e87-3633f36b26be', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "We have already finished the project," they said. Choose the correct reported form:', '[{"id":"a","text":"They said they had already finished the project."},{"id":"b","text":"They said they have already finished the project."},{"id":"c","text":"They told they had already finished the project."},{"id":"d","text":"They said they finished already the project."}]'::jsonb, 'a', 'Present perfect (''have finished'') backshifts to past perfect (''had finished''). ''We'' changes to ''they''. We use ''say (that)'', not ''told (that)''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f165226-6514-5ab3-8be5-8e7b31368205', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Where does she live?" he asked. Choose the correct reported question:', '[{"id":"a","text":"He asked where does she live."},{"id":"b","text":"He asked where she lives."},{"id":"c","text":"He asked where did she live."},{"id":"d","text":"He asked where she lived."}]'::jsonb, 'd', 'Reported wh-questions use normal word order (no inversion, no auxiliary) and apply backshift: ''does she live'' → ''she lived''. No question mark in reported speech.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8e56ca4-49e2-5025-8b40-72839f6dcbf5', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Can you open the window?" she asked him. Choose the correct reported form:', '[{"id":"a","text":"She asked him if he can open the window."},{"id":"b","text":"She told him if he could open the window."},{"id":"c","text":"She asked him if he could open the window."},{"id":"d","text":"She asked him could he open the window."}]'::jsonb, 'c', 'A yes/no question is reported with ''if/whether''. ''can'' backshifts to ''could''. Normal word order: ''he could open''. The pronoun ''you'' changes to ''he''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97062025-2da0-52e1-b0a4-2dd3e6625115', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "I studied here yesterday," she told me. Identify all the changes in the reported form: ''She told me she had studied there the day before.''', '[{"id":"a","text":"Only the tense changed."},{"id":"b","text":"Only the pronoun and time word changed."},{"id":"c","text":"The pronoun, tense, place word, and time word all changed."},{"id":"d","text":"The tense, place word, and time word all changed."}]'::jsonb, 'c', '''I'' → ''she'' (pronoun); past simple ''studied'' → past perfect ''had studied'' (tense backshift); ''here'' → ''there'' (place word); ''yesterday'' → ''the day before'' (time word). All four elements changed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffba2614-6e95-5898-af20-4f54e0cfbf82', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Direct: "Come back tomorrow!" he told her. Choose the correct reported command:', '[{"id":"a","text":"He told her to come back the next day."},{"id":"b","text":"He told her to come back tomorrow."},{"id":"c","text":"He said her to come back the next day."},{"id":"d","text":"He told to come back the next day."}]'::jsonb, 'a', 'Commands use ''tell + person + to + infinitive''. The time word ''tomorrow'' shifts to ''the next day'' in reported speech. ''said her'' is wrong — ''say'' never takes a direct person object.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd11e9b8-d66b-5df5-9042-1f71a4c1c943', '038be31c-9625-5dc2-8227-4a7402dbfe43', 'Which sentence applies the WRONG backshift?', '[{"id":"a","text":"He said he would call me. (will → would)"},{"id":"b","text":"They said they can finish. (can → no change)"},{"id":"c","text":"She said she had left early. (past simple → past perfect)"},{"id":"d","text":"He said he was studying. (present continuous → past continuous)"}]'::jsonb, 'b', 'When the reporting verb is in the past, ''can'' must backshift to ''could''. Saying ''they can finish'' is incorrect — it should be ''they could finish''.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f87026b5-e3f7-55ce-93f9-9d473c37a345', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', '👑 Elite Challenge: Mastering Reported Speech', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ce27e8ce-4c97-5c83-921e-c4c8b0fa87b7', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "I lost my keys yesterday," Tom told Sarah. Which reported form is FULLY correct (tense, pronoun, and time word all shifted)?', '[{"id":"a","text":"Tom told Sarah that he had lost his keys the day before."},{"id":"b","text":"Tom told Sarah that he lost his keys yesterday."},{"id":"c","text":"Tom told Sarah that he had lost his keys yesterday."},{"id":"d","text":"Tom told Sarah that he has lost his keys the day before."}]'::jsonb, 'a', 'Three shifts are required: (1) ''I'' → ''he'' (pronoun); (2) past simple ''lost'' → past perfect ''had lost'' (backshift); (3) ''yesterday'' → ''the day before'' (time-word shift). Option B misses all three. Option C backshifts the tense correctly but leaves ''yesterday'' unchanged. Option D uses present perfect ''has lost'' instead of past perfect ''had lost''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7819a5fe-fbe0-59b2-8d6c-056fc1f5b214', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "What did you buy at the market?" she asked him. Choose the correctly reported question:', '[{"id":"a","text":"She asked him what did he buy at the market."},{"id":"b","text":"She asked him what he bought at the market."},{"id":"c","text":"She asked him what he had bought at the market."},{"id":"d","text":"She asked him what had he bought at the market."}]'::jsonb, 'c', 'In a reported wh-question: (1) normal subject-before-verb order replaces the inverted question form (''what he…'', not ''what did he…''); (2) past simple ''did buy'' backshifts to past perfect ''had bought''; (3) ''you'' → ''he''. Option A keeps the auxiliary ''did'' (wrong order). Option B uses past simple ''bought'' with no backshift. Option D retains inversion (''had he'') — incorrect in reported speech.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11d6470e-14ec-5d4c-a173-f08aa8b53c8f', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "Don''t tell anyone about this!" she told him. Which reported command is correct?', '[{"id":"a","text":"She told him don''t tell anyone about that."},{"id":"b","text":"She asked him not telling anyone about that."},{"id":"c","text":"She said him not to tell anyone about this."},{"id":"d","text":"She told him not to tell anyone about that."}]'::jsonb, 'd', 'Negative commands are reported with ''tell + person + not to + infinitive''. Option A wrongly keeps the imperative ''don''t tell''. Option B incorrectly uses a gerund (''not telling'') instead of ''not to + infinitive''. Option C uses ''said him'' — ''say'' never takes a direct personal object — and fails to shift ''this'' to ''that''. Option D is fully correct: ''told him not to tell… about that''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98ae61e1-b215-5802-96f7-52e519f394d4', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "She may already know the answer," he said. Which sentence applies the correct modal backshift?', '[{"id":"a","text":"He said she may already know the answer."},{"id":"b","text":"He told she might already know the answer."},{"id":"c","text":"He said she might already know the answer."},{"id":"d","text":"He said she could already know the answer."}]'::jsonb, 'c', '''May'' backshifts to ''might'' when the reporting verb is in the past. Option A keeps ''may'' with no backshift. Option B uses ''told'' without a personal object — ''tell'' always requires one (e.g. ''told us''). Option D substitutes ''could'', which is the backshift of ''can'', not ''may''. Option C correctly applies the ''may → might'' backshift with ''said (that)''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63217691-5552-58cf-91f9-4fb34905a0ef', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "Have you ever been to Carthage?" the teacher asked the students. Choose the correct reported question:', '[{"id":"a","text":"The teacher asked the students if they have ever been to Carthage."},{"id":"b","text":"The teacher asked the students whether had they ever been to Carthage."},{"id":"c","text":"The teacher asked the students whether they had ever been to Carthage."},{"id":"d","text":"The teacher asked the students if they were ever to Carthage."}]'::jsonb, 'c', 'A yes/no question is reported with ''if'' or ''whether''. Present perfect ''have been'' backshifts to past perfect ''had been''. Normal word order (subject before verb) replaces inversion. Option A keeps present perfect ''have been'' with no backshift. Option B retains auxiliary inversion (''had they'') — wrong in reported speech. Option D wrongly replaces ''have been to'' with ''were to'', distorting the meaning entirely.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6eb3cd1-773c-5f0e-80a8-cdc14a156d80', 'f87026b5-e3f7-55ce-93f9-9d473c37a345', 'Direct: "I will visit my grandmother next week," Ahmed said. Which is the ONLY fully correct reported sentence?', '[{"id":"a","text":"Ahmed said he will visit his grandmother next week."},{"id":"b","text":"Ahmed told he would visit his grandmother the following week."},{"id":"c","text":"Ahmed said he would visit his grandmother next week."},{"id":"d","text":"Ahmed said he would visit his grandmother the following week."}]'::jsonb, 'd', 'Two shifts are required: (1) ''will'' → ''would'' (modal backshift); (2) ''next week'' → ''the following week'' (time-word shift). Option A applies neither shift. Option B correctly backshifts ''will → would'' and shifts the time word, but uses ''told'' without a personal object — always wrong. Option C backshifts ''will → would'' correctly but leaves ''next week'' unchanged. Only Option D applies both the modal backshift and the time-word shift correctly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('daa12303-1d75-5589-ab74-37dac1270cf7', '9b958e8f-0a4d-5299-aedc-ca62d7866435', 'english', '🔁 Practice Plus: reported speech review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('20c26877-8f50-5441-a3b2-64b75b441c2e', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this: He said, "I am tired."', '[{"id":"a","text":"He said that he is tired."},{"id":"b","text":"He said that he was tired."},{"id":"c","text":"He said that I was tired."},{"id":"d","text":"He said that he were tired."}]'::jsonb, 'b', 'In reported speech the present simple backshifts to the past simple, and "I" becomes "he": he said that he was tired. (a) keeps the present without backshift; (c) keeps the wrong pronoun "I"; (d) uses "were" with a singular subject.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c62b1670-17ff-5d0e-b684-935a306288ac', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this: She said, "I will call you tomorrow."', '[{"id":"a","text":"She said she will call me the next day."},{"id":"b","text":"She said she would call me the next day."},{"id":"c","text":"She said she would call you tomorrow."},{"id":"d","text":"She said she would called me the next day."}]'::jsonb, 'b', '"will" backshifts to "would", "you" becomes "me", and "tomorrow" becomes "the next day": she said she would call me the next day. (a) keeps "will"; (c) keeps "you"/"tomorrow" unchanged; (d) adds -ed after "would".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba8523d7-f226-5903-93dd-45435cff9844', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this command: "Open the window," the teacher told us.', '[{"id":"a","text":"The teacher told us open the window."},{"id":"b","text":"The teacher told us to open the window."},{"id":"c","text":"The teacher told us that open the window."},{"id":"d","text":"The teacher told us opening the window."}]'::jsonb, 'b', 'Commands are reported with "tell + object + to + infinitive": the teacher told us to open the window. (a) drops the "to"; (c) wrongly uses "that" for a command; (d) uses the -ing form instead of the to-infinitive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe1d97ca-88d0-5ee4-8fec-4f0ee037391e', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this yes/no question: "Are you coming to the party?" he asked.', '[{"id":"a","text":"He asked if I was coming to the party."},{"id":"b","text":"He asked if I am coming to the party."},{"id":"c","text":"He asked was I coming to the party."},{"id":"d","text":"He asked if you were coming to the party."}]'::jsonb, 'a', 'A reported yes/no question uses "if/whether", statement word order and backshift: he asked if I was coming. (b) fails to backshift "am" to "was"; (c) keeps question word order with no "if"; (d) keeps the wrong pronoun "you".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b023da2d-36db-500b-ad6f-ce9794159a3f', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this: "I bought a new phone yesterday," he said.', '[{"id":"a","text":"He said he bought a new phone yesterday."},{"id":"b","text":"He said he had bought a new phone the day before."},{"id":"c","text":"He said he has bought a new phone the day before."},{"id":"d","text":"He said he buys a new phone the previous day."}]'::jsonb, 'b', 'The past simple backshifts to the past perfect, and "yesterday" becomes "the day before": he had bought a new phone the day before. (a) keeps the past simple and "yesterday"; (c) uses the present perfect, not the past perfect; (d) wrongly uses the present "buys".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2aae1e21-eb52-5560-987a-f08b84c1c0ec', 'daa12303-1d75-5589-ab74-37dac1270cf7', 'Report this question: "Where do you live?" she asked.', '[{"id":"a","text":"She asked where do I live."},{"id":"b","text":"She asked where did I live."},{"id":"c","text":"She asked where I lived."},{"id":"d","text":"She asked where I live?"}]'::jsonb, 'c', 'A reported wh-question uses statement word order (no auxiliary "do", no question mark) and backshifts the tense: she asked where I lived. (a) and (b) keep the auxiliary "do/did" and question order; (d) keeps the question mark and present tense.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f34bbeba-a514-5828-9e27-2a8b3711fb93', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d9e00dc9-ff59-55d0-9648-d429ed81295c', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which relative pronoun is used to refer to people in a defining relative clause?', '[{"id":"a","text":"which"},{"id":"b","text":"where"},{"id":"c","text":"whose"},{"id":"d","text":"who"}]'::jsonb, 'd', '"Who" refers to people in a relative clause: "The teacher who inspired me retired last year." "Which" refers to things or animals.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c76b8b99-9da2-5728-9cb2-f075223db346', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'What is the comparative form of the adjective "happy"?', '[{"id":"a","text":"more happy than"},{"id":"b","text":"happier than"},{"id":"c","text":"happyer than"},{"id":"d","text":"the happiest"}]'::jsonb, 'b', 'Short adjectives ending in consonant + -y change the y to i and add -er: happy → happier (than). "more happy" is wrong because "more" is only for long adjectives; "happyer" keeps the y instead of changing it to i; "the happiest" is the superlative, not the comparative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4935e3cb-7a61-50a1-b744-1f0b34d7815f', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which sentence correctly uses the superlative form?', '[{"id":"a","text":"This is more difficult question in the exam."},{"id":"b","text":"This is most difficult question in the exam."},{"id":"c","text":"This is the most difficult question in the exam."},{"id":"d","text":"This is difficultest question in the exam."}]'::jsonb, 'c', 'Superlatives always require the definite article "the" before them: the most difficult. Long adjectives use "the most + adjective".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1da5ec88-b844-5781-97cc-219745da8727', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which relative pronoun shows possession?', '[{"id":"a","text":"that"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'd', '"Whose" replaces a possessive: "The girl whose bag was lost" means the girl''s bag was lost. It refers to people.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3286e813-6caa-57ff-a8e3-c3606cb69310', 'f34bbeba-a514-5828-9e27-2a8b3711fb93', 'Which sentence correctly expresses equality using "as ... as"?', '[{"id":"a","text":"Sami is as taller as his brother."},{"id":"b","text":"Sami is as tall as his brother."},{"id":"c","text":"Sami is more tall as his brother."},{"id":"d","text":"Sami is tallest as his brother."}]'::jsonb, 'b', 'The structure for equality is "as + adjective (base form) + as". Never use the comparative form inside this structure: "as tall as", not "as taller as".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f9d67f42-c6fd-52d1-b4d8-658c24c4069e', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', 'Practice: relative clauses & comparatives', 2, 75, 15, 'practice', 'admin', 1)
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
  ('4ae0793a-71f0-59d6-9e51-a31b37912048', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct relative pronoun: "The student ___ won the prize is in my class."', '[{"id":"a","text":"which"},{"id":"b","text":"whose"},{"id":"c","text":"where"},{"id":"d","text":"who"}]'::jsonb, 'd', 'We use "who" for people, and "the student" is a person: the student who won the prize. "which" is for things; "where" is for places; "whose" shows possession (the student''s...), which is not the meaning here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f68a2c08-9617-5c02-a318-9e30a4619989', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Complete: "This is the book ___ changed my life."', '[{"id":"a","text":"who"},{"id":"b","text":"that"},{"id":"c","text":"whose"},{"id":"d","text":"where"}]'::jsonb, 'b', 'We use ''which'' or ''that'' for things. ''The book that changed my life'' — ''that'' refers to ''the book'' (a thing). Both ''which'' and ''that'' are correct for things, but only ''that'' is offered.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a387198b-d83b-52a6-9faf-fd4740453fb6', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct comparative: "A cheetah is ___ a lion."', '[{"id":"a","text":"more fast than"},{"id":"b","text":"fastest than"},{"id":"c","text":"as fast than"},{"id":"d","text":"faster than"}]'::jsonb, 'd', '"fast" is a short (one-syllable) adjective, so the comparative adds -er + than: faster than. "more fast" is wrong because "more" is only for long adjectives; "fastest than" is a superlative form (and superlatives never take "than"); "as fast than" mixes the "as...as" pattern with "than".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53788e4f-8c7e-5bbf-86e1-f3ffc3ebb034', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Complete: "Mount Everest is ___ mountain in the world."', '[{"id":"a","text":"more high"},{"id":"b","text":"the most high"},{"id":"c","text":"higher"},{"id":"d","text":"the highest"}]'::jsonb, 'd', 'Comparing one mountain to all others needs a superlative. "high" is a short adjective, so the superlative adds -est and requires "the": the highest. "the most high" is wrong because "most" is only for long adjectives; "more high" and "higher" are comparatives (for two things), not superlatives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44355f34-9f8c-53a1-aadb-81d5245d24b4', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Which sentence uses ''as … as'' correctly?', '[{"id":"a","text":"She is as taller as her sister."},{"id":"b","text":"She is as more tall as her sister."},{"id":"c","text":"She is tall as her sister."},{"id":"d","text":"She is as tall as her sister."}]'::jsonb, 'd', 'The structure is ''as + base adjective + as''. Never use the comparative form inside ''as … as''. ''She is as tall as her sister'' is correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72cf3144-6f03-53f3-a57f-d413730520ed', 'f9d67f42-c6fd-52d1-b4d8-658c24c4069e', 'Choose the correct relative pronoun: "The house ___ she grew up was demolished."', '[{"id":"a","text":"who"},{"id":"b","text":"where"},{"id":"c","text":"which"},{"id":"d","text":"whose"}]'::jsonb, 'b', 'We use ''where'' for places. ''The house where she grew up'' — ''where'' refers to ''the house'' as a location.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2cbeb6e5-2960-512e-9f42-e5cbe625a305', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', '⚔️ Boss: relative clauses & comparatives mastery', 3, 120, 30, 'boss', 'admin', 2)
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
  ('684457b0-f151-5355-b7de-b1cc7331c8e0', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the correct relative pronoun: "The scientist ___ research won the Nobel Prize gave a lecture."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"whose"},{"id":"d","text":"that"}]'::jsonb, 'c', 'The research belongs to the scientist, so we need the possessive relative pronoun "whose": the scientist whose research won the Nobel Prize (= the scientist''s research). "who" replaces a person as subject/object, not a possessor; "which"/"that" refer to things and cannot show possession here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78a7a0fe-8fa8-50d9-8c2f-f514647fb4fc', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Complete with the correct comparative: "This exam is ___ the one we did last month." (difficult)', '[{"id":"a","text":"difficulter than"},{"id":"b","text":"the most difficult than"},{"id":"c","text":"more difficult as"},{"id":"d","text":"more difficult than"}]'::jsonb, 'd', '''difficult'' is a long adjective (three syllables), so the comparative is ''more difficult than''. We never add ''-er'' to long adjectives, and the second element is introduced by ''than'', not ''as''.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('118a1f96-6010-503b-a5bf-8d5a7fd05817', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the correct sentence:', '[{"id":"a","text":"Her results are better than mine."},{"id":"b","text":"Her results are gooder than mine."},{"id":"c","text":"Her results are more good than mine."},{"id":"d","text":"Her results are best than mine."}]'::jsonb, 'a', '''good'' is irregular. Its comparative is ''better than'' — not ''gooder'', ''more good'', or ''best''. The superlative would be ''the best''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b2d3600-2cf9-5aa0-af06-ba7393c39024', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Complete: "Rania is not ___ her brother at maths." (good)', '[{"id":"a","text":"as better as"},{"id":"b","text":"so good than"},{"id":"c","text":"as good as"},{"id":"d","text":"as well as"}]'::jsonb, 'c', 'For equality/inequality, use ''as + base adjective + as''. ''not as good as'' is correct. ''as better as'' wrongly uses the comparative inside the structure; ''so good than'' is not a real pattern; ''as well as'' is an adverb phrase, not an adjective comparison.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74caaa9d-d014-5673-8f8b-9c0121dc06c6', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Which sentence correctly uses a writing connector to show contrast?', '[{"id":"a","text":"He studied hard; therefore, he failed the exam."},{"id":"b","text":"He studied hard; furthermore, he failed the exam."},{"id":"c","text":"He studied hard; for example, he failed the exam."},{"id":"d","text":"He studied hard; however, he failed the exam."}]'::jsonb, 'd', '''however'' signals contrast between two opposing ideas. ''therefore'' = result, ''furthermore'' = addition, ''for example'' = illustration. Only ''however'' correctly contrasts studying hard with failing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('481b204d-67d0-5c6e-b6f3-01c13e92b87e', '2cbeb6e5-2960-512e-9f42-e5cbe625a305', 'Choose the sentence with the correct superlative form:', '[{"id":"a","text":"Yesterday was the most bad day of my life."},{"id":"b","text":"Yesterday was the baddest day of my life."},{"id":"c","text":"Yesterday was the worse day of my life."},{"id":"d","text":"Yesterday was the worst day of my life."}]'::jsonb, 'd', '''bad'' is irregular: bad → worse → the worst. ''The worst day'' is the only correct superlative. ''Baddest'', ''the most bad'', and ''the worse'' are all incorrect forms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e6171568-ac34-5461-a926-00b1198d046e', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', '👑 Elite Challenge: Relative Clauses & Comparatives Under Pressure', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('da568abe-ed24-5c8b-87a8-366cf878cc44', 'e6171568-ac34-5461-a926-00b1198d046e', 'A student writes: "The museum, that we visited last summer, was built in 1890." What is wrong with this sentence?', '[{"id":"a","text":"Nothing is wrong; ''that'' is always interchangeable with ''which''."},{"id":"b","text":"''that'' cannot be used in a non-defining relative clause; it must be replaced with ''which''."},{"id":"c","text":"The commas are wrong; remove them and the sentence is correct."},{"id":"d","text":"''that'' should be replaced with ''who'' because museums are important places."}]'::jsonb, 'b', 'Non-defining relative clauses (set off by commas) add extra, non-essential information. They require ''which'' for things — never ''that''. ''That'' is only used in defining relative clauses, where no comma is used. Removing the commas (option C) would make it defining, which changes the meaning entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dfbba67-23ca-5232-bd3a-a66957add243', 'e6171568-ac34-5461-a926-00b1198d046e', 'Combine these two sentences into ONE using the correct relative pronoun: "We read a report. Its conclusions surprised the entire committee."', '[{"id":"a","text":"We read a report which conclusions surprised the entire committee."},{"id":"b","text":"We read a report that its conclusions surprised the entire committee."},{"id":"c","text":"We read a report whose conclusions surprised the entire committee."},{"id":"d","text":"We read a report where its conclusions surprised the entire committee."}]'::jsonb, 'c', '''Whose'' replaces a possessive (''its conclusions'' = ''the report''s conclusions''). It can refer to both people AND things in formal English. ''Which conclusions'' is ungrammatical without a preposition; ''that its'' repeats the pronoun and is incorrect; ''where'' is for places, not possessive relationships.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30ac2283-9c21-5f32-b50c-f55d02072c39', 'e6171568-ac34-5461-a926-00b1198d046e', 'Choose the sentence in which the relative pronoun CAN be omitted without making the sentence ungrammatical:', '[{"id":"a","text":"The teacher whose class I attended retired last week."},{"id":"b","text":"The city where I was born is far from here."},{"id":"c","text":"The novel that she recommended to me was excellent."},{"id":"d","text":"The student who answered first won the prize."}]'::jsonb, 'c', 'A relative pronoun can be omitted only when it is the OBJECT of the relative clause. In option C, ''that'' is the object (''she recommended [it] to me''), so it can be dropped: ''The novel she recommended to me was excellent.'' In option D, ''who'' is the SUBJECT (''who answered first''), so it cannot be omitted. ''Whose'' and ''where'' can never be omitted.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('509c6467-c2af-55d2-a464-d762a3a5f71a', 'e6171568-ac34-5461-a926-00b1198d046e', 'Which sentence correctly uses the ''the … the …'' double comparative structure?', '[{"id":"a","text":"The more you practice, the more better your English becomes."},{"id":"b","text":"The harder you study, the best results you will get."},{"id":"c","text":"The harder you study, the better your results will be."},{"id":"d","text":"More harder you study, better your results will be."}]'::jsonb, 'c', 'The ''the + comparative … the + comparative'' structure requires a comparative form (not a superlative) in BOTH clauses. ''The harder … the better'' is correct. Option A wrongly doubles ''more'' and ''better''; option B uses the superlative ''best'' in the second clause; option D omits the definite article ''the'' and adds a redundant ''more'' before ''harder''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1b432f1-1cbc-574c-9660-5b7227a13d3a', 'e6171568-ac34-5461-a926-00b1198d046e', 'Complete the sentence with the correct form: "Among all the students in the school, Yasmine scored ___ marks on the national mock exam." (few)', '[{"id":"a","text":"the fewer"},{"id":"b","text":"the fewest"},{"id":"c","text":"the least few"},{"id":"d","text":"fewer than"}]'::jsonb, 'b', 'When comparing three or more (here: all students in the school), we use the superlative. ''Few'' forms its superlative as ''the fewest'' (regular short-adjective pattern: add -est). ''The fewer'' is the comparative, used only for two items. ''The least few'' is not a real form. ''Fewer than'' is a comparative requiring a second element to compare with.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('843870fc-8656-51d5-9c26-be88398192c7', 'e6171568-ac34-5461-a926-00b1198d046e', 'A student writes: "My handwriting is not as worse as my brother''s." Identify the error and choose the corrected version.', '[{"id":"a","text":"My handwriting is not as bad as my brother''s."},{"id":"b","text":"My handwriting is not as worst as my brother''s."},{"id":"c","text":"My handwriting is not more bad than my brother''s."},{"id":"d","text":"My handwriting is not as badly as my brother''s."}]'::jsonb, 'a', 'The ''as … as'' structure always requires the BASE (positive) form of the adjective — never the comparative or superlative. The base form of ''worse'' is ''bad'', so the correct sentence is ''not as bad as''. Using ''worse'' inside ''as…as'' is the most common trap with irregular adjectives. ''Badly'' is an adverb and cannot describe handwriting as a noun adjunct here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1db52ab9-d385-5a85-9cd2-6d84b31ac29c', '0bc67bcc-bd66-52fb-b968-3dc60375eba1', 'english', '🔁 Practice Plus: relative clauses & comparatives review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('6dd765f8-f95a-54ac-9410-d82ad64ccace', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "The man ___ lives next door is a doctor."', '[{"id":"a","text":"which"},{"id":"b","text":"who"},{"id":"c","text":"whose"},{"id":"d","text":"where"}]'::jsonb, 'b', '"who" is the relative pronoun for people acting as the subject: the man who lives next door. "which" is for things; "whose" shows possession; "where" refers to places.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('731275d6-6544-592f-a0bb-fd317ea9e825', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "That''s the girl ___ bag was stolen."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"whose"},{"id":"d","text":"that"}]'::jsonb, 'c', '"whose" shows possession (the girl''s bag): the girl whose bag was stolen. "who"/"that" replace the person but cannot show possession; "which" is for things.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6e08b0d-d37d-534e-b7a3-fbc2929aa0bd', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "This is the restaurant ___ we had dinner last night."', '[{"id":"a","text":"which"},{"id":"b","text":"who"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'c', '"where" refers to a place and means "in which": the restaurant where we had dinner. "which" would need a preposition (in which); "who" is for people; "whose" shows possession.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de922d60-b93c-52b8-9755-7ab94294ffd5', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "This book is ___ than the last one I read."', '[{"id":"a","text":"more interesting"},{"id":"b","text":"interestinger"},{"id":"c","text":"most interesting"},{"id":"d","text":"more interestinger"}]'::jsonb, 'a', 'Long adjectives form the comparative with "more": more interesting. "interestinger" wrongly adds -er to a long adjective; "most interesting" is the superlative; "more interestinger" double-marks the comparative.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c2a16fe-94a8-5a71-beb6-413d5b472af7', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "Everest is ___ mountain in the world."', '[{"id":"a","text":"the highest"},{"id":"b","text":"the higher"},{"id":"c","text":"highest"},{"id":"d","text":"the most high"}]'::jsonb, 'a', 'Comparing one thing with all others needs the superlative with "the": the highest mountain. "the higher" is a comparative (two things); "highest" needs "the"; "the most high" wrongly uses "most" with a short adjective that takes -est.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99bb5c63-3dc9-5203-88e2-3d6ecca98e13', '1db52ab9-d385-5a85-9cd2-6d84b31ac29c', 'Complete: "My new phone is just ___ my old one; they cost the same."', '[{"id":"a","text":"as expensive as"},{"id":"b","text":"more expensive than"},{"id":"c","text":"as expensive than"},{"id":"d","text":"so expensive than"}]'::jsonb, 'a', 'To say two things are equal we use "as + adjective + as": just as expensive as. "more expensive than" states a difference, which contradicts "they cost the same"; (c) and (d) wrongly mix "as/so" with "than".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6f4fe871-4346-5f8c-b962-72c71250e9bb', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Comprehension quiz', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ad44e9d8-fe1d-59d3-b518-2ea51b2a627c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"In many Tunisian families, dinner is more than just a meal. It is the moment when everyone sits together, shares the news of the day and laughs about small things. Even when life is busy, parents try hard to keep this evening habit alive."

What is the main idea of this passage?', '[{"id":"a","text":"Tunisian families always eat the same food for dinner."},{"id":"b","text":"Family dinner is an important moment for sharing and staying close."},{"id":"c","text":"Parents are too busy to spend time with their children."},{"id":"d","text":"Children prefer eating dinner alone in their rooms."}]'::jsonb, 'b', 'The whole passage shows that dinner is valued because the family sits together, shares news and laughs — and parents protect this habit. That is the main idea. (a) Food is never mentioned. (c) The opposite is true: even when busy, parents keep the habit. (d) Nothing suggests children eat alone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b84ac2b-88c1-5e10-9ee7-a729713042ff', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Our school library opens at eight in the morning and closes at five in the afternoon, from Monday to Friday. On Saturday, it is open only in the morning, and it stays closed on Sunday."

On which day is the library open in the morning only?', '[{"id":"a","text":"Monday"},{"id":"b","text":"Sunday"},{"id":"c","text":"Saturday"},{"id":"d","text":"Friday"}]'::jsonb, 'c', 'Scan for each day. The text says it opens ''only in the morning'' on Saturday. Monday and Friday follow the full 8 a.m.–5 p.m. timetable, and Sunday it is closed. So the answer is Saturday.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed2c07e1-18f2-5a28-bdef-32269895079f', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Plastic bags are cheap and easy to carry. However, they pollute our beaches and harm sea animals for many years."

What is the function of the connector "However" in this passage?', '[{"id":"a","text":"It adds another advantage of plastic bags."},{"id":"b","text":"It introduces a contrast with the first sentence."},{"id":"c","text":"It gives the cause of the pollution."},{"id":"d","text":"It shows the result of using plastic bags carefully."}]'::jsonb, 'b', '''However'' is a contrast connector: it opposes the advantage (cheap, easy) to the serious drawback (pollution, harm to animals). It does not add an advantage (a), give a cause — that would be ''because'' (c) — or show a positive result (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdf11453-1d14-5f95-abf0-44c6b17b044b', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"The festival offered something for everyone. There were films in the open air, live music until midnight, and games for the youngest visitors."

Which detail is mentioned in the passage?', '[{"id":"a","text":"a cooking competition"},{"id":"b","text":"live music until midnight"},{"id":"c","text":"a football match"},{"id":"d","text":"an art exhibition"}]'::jsonb, 'b', 'Scanning the text, the activities listed are open-air films, live music until midnight, and games for children. Only ''live music until midnight'' is actually stated. A cooking competition (a), football match (c) and art exhibition (d) do not appear.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba4e859e-bd3f-50f4-86dd-36c0f4dc5c28', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"When Lina opened her exam results, her hands were shaking. She read the page twice, then ran to the kitchen shouting and hugged her mother before she could even speak."

What can we infer about Lina''s results?', '[{"id":"a","text":"She failed and was very disappointed."},{"id":"b","text":"She did very well and was extremely happy."},{"id":"c","text":"She did not understand her results."},{"id":"d","text":"She was too tired to care about the results."}]'::jsonb, 'b', 'The clues — shaking hands, reading twice, running and shouting with joy, hugging her mother — all point to great excitement, so we infer she did very well. The text never states the grade, but the behaviour proves happiness, not disappointment (a), confusion (c) or tiredness (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa5b50d9-2c3d-57bc-80ef-83cf5473969c', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Volunteers planted hundreds of young trees along the dry riverbank last spring. Today, they are tall and green, and they give shade to the families who walk there."

In the second sentence, what does the word "they" refer to?', '[{"id":"a","text":"the volunteers"},{"id":"b","text":"the families"},{"id":"c","text":"the young trees"},{"id":"d","text":"the riverbanks"}]'::jsonb, 'c', '"They are tall and green" and "give shade" can only describe the trees that were planted. ''They'' refers back to the nearest matching plural noun that fits the meaning — the young trees. It is not the volunteers (people are not ''green''), the families, or the riverbank (singular).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70814d98-d38e-52c0-8bd8-07f160d3afbb', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"The new clinic is very convenient. It is close to the bus station, it opens early, and patients rarely wait more than a few minutes to see a doctor."

What does the word "convenient" most probably mean here?', '[{"id":"a","text":"expensive and modern"},{"id":"b","text":"easy and practical to use"},{"id":"c","text":"far and difficult to reach"},{"id":"d","text":"crowded and noisy"}]'::jsonb, 'b', 'The reasons given after the word — close to the bus station, opens early, short waiting time — describe something easy and practical to use, which is the meaning of ''convenient''. The context contradicts ''far and difficult'' (c), and says nothing about price (a) or noise (d).', 7)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5acdc554-2621-5a4d-80f2-35310f2af5ef', '6f4fe871-4346-5f8c-b962-72c71250e9bb', 'Read this passage:

"Saying ''please'' and ''thank you'' costs nothing, yet it changes everything. A polite word can turn a stranger into a friend and a tense moment into a calm one."

What is the writer''s main message?', '[{"id":"a","text":"Politeness is expensive and difficult."},{"id":"b","text":"Strangers are usually dangerous."},{"id":"c","text":"Small polite words have a big positive effect."},{"id":"d","text":"People should avoid speaking to strangers."}]'::jsonb, 'c', 'The passage stresses that polite words cost nothing yet ''change everything'' — they create friendship and calm. The main message is that small polite words have a big positive effect. (a) contradicts ''costs nothing''. (b) and (d) are not in the text.', 8)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Practice: read and understand (1)', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5b47820d-916f-58b9-a0d0-90c7eaff3938', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"My grandmother lives with us. Every afternoon she tells us old stories about her village, and we listen carefully. Thanks to her, we know a lot about how families lived long ago."

What is the main idea of this passage?', '[{"id":"a","text":"The grandmother is too old to live alone."},{"id":"b","text":"The grandmother shares stories that teach the family about the past."},{"id":"c","text":"The children do not like listening to old stories."},{"id":"d","text":"The village has changed a lot over the years."}]'::jsonb, 'b', 'The passage centres on the grandmother telling stories and the family learning about the past from her. (a) Living alone is never mentioned. (c) The opposite is true — they listen carefully. (d) The village''s changes are not the topic.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3ac0c0c-72d4-5c36-9af4-3e55e2bf61e3', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The science club meets twice a week. On Tuesday the members do experiments, and on Thursday they prepare projects for the school fair."

What do the members do on Thursday?', '[{"id":"a","text":"They do experiments."},{"id":"b","text":"They prepare projects for the school fair."},{"id":"c","text":"They clean the laboratory."},{"id":"d","text":"They take an exam."}]'::jsonb, 'b', 'Scan for ''Thursday''. The text says: on Thursday ''they prepare projects for the school fair''. The experiments happen on Tuesday (a), and cleaning (c) and an exam (d) are not mentioned.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18944ced-9590-5b65-95c2-9b4e16b20d32', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"Doctors say that walking is excellent for your health. It is free, and you can do it almost anywhere."

In the second sentence, what does the word "it" refer to?', '[{"id":"a","text":"the doctor"},{"id":"b","text":"your health"},{"id":"c","text":"walking"},{"id":"d","text":"the second sentence"}]'::jsonb, 'c', '"It is free" and "you can do it anywhere" describe the activity being praised — walking. ''It'' refers back to the nearest matching idea, which is walking. It is not the doctor (a person) or ''your health'', which is not something free that you ''do''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca816cf8-5b8a-5807-9faf-b8115134aef4', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The room was spotless. Not a single speck of dust could be seen, and everything was in its place."

What does the word "spotless" most probably mean?', '[{"id":"a","text":"very dirty"},{"id":"b","text":"very clean"},{"id":"c","text":"very large"},{"id":"d","text":"very dark"}]'::jsonb, 'b', 'The next sentence explains the word: no dust and everything in its place — that describes a very clean room, so ''spotless'' means very clean. The context rules out ''dirty'' (a, the opposite), and says nothing about size (c) or light (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5b7882d-e334-5f41-bc99-df08d8742957', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"Karim turned off the television, put away his books and yawned. He set his alarm and switched off the light."

What can we infer that Karim is about to do?', '[{"id":"a","text":"go to school"},{"id":"b","text":"start cooking dinner"},{"id":"c","text":"go to sleep"},{"id":"d","text":"watch a film"}]'::jsonb, 'c', 'Yawning, setting the alarm and switching off the light are all clues that Karim is going to bed. The text does not say ''sleep'' directly, but the actions prove it. He has just turned off the TV (not watching a film, d), and there is no sign of school (a) or cooking (b).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4ecd2b9-807e-528e-8f74-5f0fa9e018bd', '58c891e6-a44c-5e6a-aeaf-67e2d7f536c0', 'Read this passage:

"The bus was late, so we missed the beginning of the film."

What is the function of the connector "so" in this sentence?', '[{"id":"a","text":"It introduces a contrast."},{"id":"b","text":"It introduces the result of the first part."},{"id":"c","text":"It introduces an example."},{"id":"d","text":"It introduces a purpose."}]'::jsonb, 'b', '''So'' links a cause (the bus was late) to its result (we missed the start of the film). It marks result/consequence. A contrast would use ''but'' (a), an example ''such as'' (c), and a purpose ''in order to'' (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b387c5d-e284-59e9-a936-4be304908ee3', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', 'Practice: building good paragraphs (2)', 2, 50, 10, 'practice', 'admin', 2)
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
  ('42e3e7ea-b563-569c-90f5-b9b015b4ec33', '1b387c5d-e284-59e9-a936-4be304908ee3', 'You are writing a paragraph about the benefits of sport for students. Which sentence is the best topic sentence to begin it?', '[{"id":"a","text":"Last Saturday I scored two goals in the match."},{"id":"b","text":"Practising sport brings students many important benefits."},{"id":"c","text":"My favourite football player wears the number ten."},{"id":"d","text":"The school stadium is next to the main gate."}]'::jsonb, 'b', 'A topic sentence states the paragraph''s general main idea, and (b) clearly announces ''the benefits of sport for students''. The others are narrow details — one match (a), a player (c), a place (d) — too small to introduce the whole paragraph.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58334796-1688-507d-85b4-8d0f606d7eda', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Read this short paragraph about libraries:

"Public libraries are very useful. They lend thousands of books for free. They also offer a quiet place to study. My uncle prefers tea to coffee. Many students go there before exams."

Which sentence is irrelevant and should be removed?', '[{"id":"a","text":"\"They lend thousands of books for free.\""},{"id":"b","text":"\"They also offer a quiet place to study.\""},{"id":"c","text":"\"My uncle prefers tea to coffee.\""},{"id":"d","text":"\"Many students go there before exams.\""}]'::jsonb, 'c', 'The paragraph is about why libraries are useful. Sentences a, b and d all support that idea. ''My uncle prefers tea to coffee'' has nothing to do with libraries, so it is the irrelevant sentence and must be removed.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b59a2c4-f6dd-5ebf-846e-46ebc1fccfe2', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Put these sentences in the correct order to form a well-organised paragraph:

1. "Finally, eating fruit and vegetables keeps the body strong."
2. "A healthy lifestyle depends on a few simple habits."
3. "First, sleeping enough hours helps the brain rest."

What is the best order?', '[{"id":"a","text":"1 – 2 – 3"},{"id":"b","text":"2 – 3 – 1"},{"id":"c","text":"3 – 1 – 2"},{"id":"d","text":"2 – 1 – 3"}]'::jsonb, 'b', 'Sentence 2 is the general topic sentence, so it comes first. Then the sequence words guide the order: ''First'' (3) before ''Finally'' (1). The logical order is 2 – 3 – 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f995235-7d0c-5578-977f-0367685bca7f', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Choose the best linking word to complete the sentence:

"The medicine was bitter, ___ the child swallowed it without complaining."', '[{"id":"a","text":"because"},{"id":"b","text":"so"},{"id":"c","text":"but"},{"id":"d","text":"for example"}]'::jsonb, 'c', 'We expect a bitter medicine to be refused, yet the child took it easily — that surprise is a contrast, which needs ''but''. ''Because'' gives a cause, ''so'' a result, and ''for example'' an example; none fits the opposition here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e40940f-e9de-597e-85f5-7a3a40f49971', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Read the beginning of a paragraph:

"Smoking is dangerous for teenagers. It damages the lungs and reduces energy."

Which sentence is the most coherent continuation?', '[{"id":"a","text":"In addition, it wastes money that could be spent on useful things."},{"id":"b","text":"The weather in spring is usually pleasant."},{"id":"c","text":"My favourite colour has always been blue."},{"id":"d","text":"Cars need petrol to move from place to place."}]'::jsonb, 'a', 'The paragraph lists the dangers of smoking, so a coherent continuation adds another disadvantage and links it with ''In addition'' (a). The other options jump to unrelated topics — weather (b), a colour (c), cars (d) — and break the paragraph''s unity.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79d5ca59-ee45-54f7-b1a6-f94d0dcb221a', '1b387c5d-e284-59e9-a936-4be304908ee3', 'Choose the best linking word to complete the sentence:

"We should protect the environment ___ future generations can live healthy lives."', '[{"id":"a","text":"so that"},{"id":"b","text":"however"},{"id":"c","text":"for instance"},{"id":"d","text":"although"}]'::jsonb, 'a', 'The second part states the goal or aim of protecting the environment, which needs a purpose connector: ''so that''. ''However'' shows contrast, ''for instance'' gives an example, and ''although'' introduces a concession — none expresses purpose.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7a76fb51-3640-57fa-bff6-25ef94248cfb', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', '⚔️ Boss: read deeply, write tightly', 3, 120, 30, 'boss', 'admin', 3)
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
  ('82494c50-b2fd-5b15-ab67-5e6fd86d4058', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this paragraph about good manners:

"Good manners cost nothing but bring great rewards. A polite greeting makes people feel respected. Holding the door for others shows kindness. The new shopping mall has a huge car park. In short, small courteous acts build a friendlier society."

Which sentence breaks the unity of the paragraph and should be removed?', '[{"id":"a","text":"\"A polite greeting makes people feel respected.\""},{"id":"b","text":"\"Holding the door for others shows kindness.\""},{"id":"c","text":"\"The new shopping mall has a huge car park.\""},{"id":"d","text":"\"In short, small courteous acts build a friendlier society.\""}]'::jsonb, 'c', 'The paragraph develops one idea — good manners and their value — supported by examples (greeting, holding the door) and a closing sentence (''In short…''). ''The new shopping mall has a huge car park'' is off-topic and breaks the unity, so it must be removed.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c92e82a7-ebc6-5634-ba6d-67c111412e90', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Some people think a city is judged by its tall towers and wide roads. In truth, a city is judged by how it treats its weakest citizens — its children, its elderly and its sick."

What is the writer''s main point?', '[{"id":"a","text":"Tall towers make a city beautiful and successful."},{"id":"b","text":"The real value of a city is how well it cares for its most vulnerable people."},{"id":"c","text":"Cities should build wider roads to reduce traffic."},{"id":"d","text":"Children, the elderly and the sick live in every city."}]'::jsonb, 'b', 'The writer rejects the common view (towers, roads) with ''In truth'' and states the real measure: how a city treats its weakest citizens. That is the main point. (a) is the idea the writer corrects. (c) is not discussed. (d) is a literal detail, not the message.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76b801e8-7fda-5047-80f1-b82276886214', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Nadia had been saving for months. When she finally counted her coins on the table, she sighed, shook her head, and quietly put the bicycle catalogue back on the shelf."

What can we infer from this passage?', '[{"id":"a","text":"Nadia had enough money to buy the bicycle."},{"id":"b","text":"Nadia did not have enough money for the bicycle she wanted."},{"id":"c","text":"Nadia had decided she no longer liked bicycles."},{"id":"d","text":"Nadia had already bought the bicycle."}]'::jsonb, 'b', 'Sighing, shaking her head and putting the catalogue away after counting her coins are clues of disappointment — she still cannot afford the bicycle. The text never says it directly, but the clues prove it. (a) and (d) contradict her sad reaction; (c) is wrong, as she was saving precisely to buy one.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59185207-289a-5a7b-878e-da52a9432e1d', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"Online learning helped many students continue their studies. Teachers recorded lessons, and learners watched them at home. Yet this solution had a serious limit: it left out those who had no internet at all."

In the third sentence, what does "this solution" refer to?', '[{"id":"a","text":"the serious limit"},{"id":"b","text":"online learning"},{"id":"c","text":"the students who had no internet"},{"id":"d","text":"the teachers"}]'::jsonb, 'b', '"This solution" sums up what was described before: online learning (recorded lessons watched at home). Reference phrases like ''this solution'' point back to the whole idea just explained. It is not the limit (a), which the solution ''had'', nor the students (c) or teachers (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5df534a9-e67a-5969-a2c5-ad81ce85ec17', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Read this passage:

"The volunteers worked tirelessly all weekend, clearing rubbish from the beach despite the heat and the long hours."

What does the word "tirelessly" most probably mean?', '[{"id":"a","text":"without getting paid"},{"id":"b","text":"without stopping or becoming tired"},{"id":"c","text":"in complete silence"},{"id":"d","text":"very slowly and carefully"}]'::jsonb, 'b', 'The context — working ''all weekend'', ''long hours'', ''despite the heat'' — shows continuous, energetic effort, so ''tirelessly'' means without stopping or getting tired. Pay (a), silence (c) and slowness (d) are not suggested; in fact ''slowly'' would contradict the hard, steady work described.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4f69f32-d96d-5306-9ce3-7144a7664518', '7a76fb51-3640-57fa-bff6-25ef94248cfb', 'Put these sentences in the correct order to form a well-organised paragraph:

1. "As a result, customers receive their answers much faster than before."
2. "Therefore, many companies now combine machines with human staff to get the best of both."
3. "Technology has changed the way services treat their customers."
4. "However, a machine cannot fully understand a worried customer the way a person can."

What is the best order?', '[{"id":"a","text":"3 – 1 – 4 – 2"},{"id":"b","text":"1 – 3 – 2 – 4"},{"id":"c","text":"3 – 4 – 1 – 2"},{"id":"d","text":"2 – 3 – 1 – 4"}]'::jsonb, 'a', 'Sentence 3 is the general topic sentence (it comes first). Then 1 (''As a result'') gives a benefit of the technology. Sentence 4 (''However'') introduces the drawback, and 2 (''Therefore'') gives the logical conclusion. The chain of connectors gives 3 – 1 – 4 – 2.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', '👑 Elite Challenge: Master Reader & Writer', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('9d18f897-c064-5575-bdf5-1eaf14cf48d1', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"For years, the village school had only one computer, shared by two hundred pupils. Last year a charity sent thirty laptops. Test scores have not changed much yet, but for the first time the children no longer queue for hours, and their curiosity is finally awake."

What does the writer most strongly suggest about the donation?', '[{"id":"a","text":"It was a complete failure because test scores did not rise."},{"id":"b","text":"Its most valuable effect so far is on the children''s access and motivation, not yet on grades."},{"id":"c","text":"It proves that technology always improves exam results immediately."},{"id":"d","text":"The school no longer needs any teachers."}]'::jsonb, 'b', 'The writer admits scores ''have not changed much yet'' but stresses the real gains: no more queuing and awakened curiosity. The suggested meaning is that the early value lies in access and motivation, not grades. (a) ignores the clearly positive ''but''. (c) is contradicted by ''have not changed much''. (d) is never implied.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6e6d69e-f89f-589a-8d51-28ac9ed8fd2c', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"The film was praised by every critic in the country. Maya, however, walked out before the end, glancing at her watch more than once."

What can we most reasonably infer about Maya?', '[{"id":"a","text":"She agreed completely with the critics'' praise."},{"id":"b","text":"She found the film boring even though critics loved it."},{"id":"c","text":"She had to leave because the cinema was closing."},{"id":"d","text":"She had already seen the film many times before."}]'::jsonb, 'b', 'The contrast word ''however'', leaving early, and repeatedly checking her watch are clues that Maya was bored, unlike the critics. The inference is supported by the text. (a) contradicts those clues. (c) and (d) invent reasons the passage never gives.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73c5df4e-c223-5c0f-a812-7e7a6f85435d', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"Parents often worry about screens. Yet screens are only tools. Used wisely, they teach and connect; used carelessly, they isolate. The difference lies not in the device but in the hand that holds it."

In the last sentence, what does "the hand that holds it" refer to figuratively?', '[{"id":"a","text":"the parents'' actual hands"},{"id":"b","text":"the way each person chooses to use the screen"},{"id":"c","text":"the company that builds the device"},{"id":"d","text":"the size of the screen"}]'::jsonb, 'b', 'The passage argues that the same tool can help or harm depending on use (''used wisely… used carelessly''). ''The hand that holds it'' is a figurative image for the user''s choices and habits. It is not literal hands (a), the manufacturer (c) or the screen size (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a43e475-982f-58ea-aefc-70c672df20e2', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this passage:

"At first the new recycling rules seemed cumbersome: residents had to sort waste into four separate bins. Within a month, though, the sorting felt automatic and the streets were noticeably cleaner."

What does the word "cumbersome" most probably mean here?', '[{"id":"a","text":"cheap and simple"},{"id":"b","text":"awkward and troublesome to do"},{"id":"c","text":"dangerous and harmful"},{"id":"d","text":"exciting and enjoyable"}]'::jsonb, 'b', 'The contrast structure (''At first… though'') shows that ''cumbersome'' describes the early difficulty before it ''felt automatic''. Sorting waste into four bins being a burden means awkward and troublesome. ''Cheap and simple'' (a) and ''enjoyable'' (d) contradict the contrast, and danger (c) is not mentioned.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3562c6fd-8a22-558d-981c-69692e31fd0c', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'You must complete a paragraph whose topic sentence is: "Reading for pleasure offers benefits that go far beyond the classroom." Two supporting sentences and a wrong continuation follow. Which sentence would be the LEAST appropriate to include in this paragraph?', '[{"id":"a","text":"It widens vocabulary and sharpens the imagination."},{"id":"b","text":"Moreover, it builds patience and the habit of concentration."},{"id":"c","text":"These skills help young people in work and in life, not only in exams."},{"id":"d","text":"The bookshop near my house closes at nine o''clock in the evening."}]'::jsonb, 'd', 'The paragraph develops the benefits of reading beyond school. Sentences a, b and c each support that idea with relevant points and good connectors. The closing time of a bookshop (d) is an off-topic detail that breaks the unity, so it is the least appropriate to include.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0adab7d5-1c45-5d95-acce-c328c8f0dcf1', 'ce27ac89-a4f2-5563-b490-a0acb4caeb60', 'Read this opening:

"Civility is the oil that keeps a society running smoothly. When people are rude, even small disagreements turn into conflicts."

Which sentence is the most coherent AND best-linked continuation?', '[{"id":"a","text":"On the other hand, when people are courteous, tense situations are quickly calmed."},{"id":"b","text":"For example, the bus arrives at eight every morning."},{"id":"c","text":"Therefore, my favourite season is winter."},{"id":"d","text":"Although oil is used to cook many delicious meals."}]'::jsonb, 'a', 'The passage contrasts the effect of rudeness with that of courtesy, so the best continuation balances the two with a contrast connector: ''On the other hand…'' (a). Option (b) misuses ''For example'' for an unrelated fact; (c) draws an illogical conclusion; (d) takes the word ''oil'' literally and derails the paragraph.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('72e8b533-b69b-5f4e-95db-09d94ad60365', 'ebaeff35-fd0d-5802-8371-0e5c708f825d', 'english', '🔁 Practice Plus: reading & writing review', 3, 120, 30, 'boss', 'admin', 5)
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
  ('36414703-691f-5aaf-85e9-9f664293de54', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Read this paragraph about exercise:

"Regular exercise keeps the body healthy. It strengthens the heart and improves sleep. My cousin recently bought a red sports car. Above all, it lifts the mood and reduces stress."

Which sentence breaks the unity of the paragraph and should be removed?', '[{"id":"a","text":"\"It strengthens the heart and improves sleep.\""},{"id":"b","text":"\"My cousin recently bought a red sports car.\""},{"id":"c","text":"\"Above all, it lifts the mood and reduces stress.\""},{"id":"d","text":"\"Regular exercise keeps the body healthy.\""}]'::jsonb, 'b', 'The paragraph develops a single idea — the benefits of exercise — with supporting points and a closing sentence (''Above all…''). ''My cousin recently bought a red sports car'' has nothing to do with exercise, so it breaks the unity and should be removed.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80de5c70-358d-5f68-a4fe-c16457e56b24', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Read this passage:

"For years, the small village had no library. Then a retired teacher began lending books from her own home. Word spread, neighbours donated more books, and soon a single shelf grew into three full rooms."

What is the main idea of this passage?', '[{"id":"a","text":"Retired teachers should not lend their books to others."},{"id":"b","text":"One person''s small action grew into a village library."},{"id":"c","text":"The village already had three libraries."},{"id":"d","text":"Books are too expensive for small villages."}]'::jsonb, 'b', 'The passage traces how one teacher''s lending grew, step by step, into a real library — that is the main idea. (a) contradicts the positive story; (c) is false, as the rooms appeared only later; (d) is never mentioned in the text.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0d22343-a40f-5803-a63a-2d20027a1008', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Read this passage:

"Karim glanced at the clock, grabbed his bag without zipping it, and ran out of the house, leaving his breakfast untouched on the table."

What can we infer about Karim?', '[{"id":"a","text":"He was late and in a hurry."},{"id":"b","text":"He was not hungry that morning."},{"id":"c","text":"He had nothing to do that day."},{"id":"d","text":"He had forgotten where his bag was."}]'::jsonb, 'a', 'Glancing at the clock, not zipping the bag, running out and skipping breakfast are all clues that Karim was rushing because he was late. The text does not say this directly, but the details prove it. (b) ignores the rush as the cause; (c) contradicts his hurry; (d) is not suggested.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9577d052-f65b-5fbb-9340-6341c231d3e2', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Read this passage:

"Many tourists visit the old medina for its narrow streets and lively markets. However, few of them realise how fragile these ancient walls have become."

In the second sentence, what does "them" refer to?', '[{"id":"a","text":"the narrow streets"},{"id":"b","text":"the ancient walls"},{"id":"c","text":"the tourists"},{"id":"d","text":"the lively markets"}]'::jsonb, 'c', '"them" replaces the people who do the realising — the tourists mentioned in the first sentence. Pronouns point back to a noun already named. The streets (a), walls (b) and markets (d) are things that cannot "realise" anything.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62cc893d-b490-5003-99db-a0a33132fb14', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Read this passage:

"The new recycling scheme was a complete fiasco: bins were delivered late, instructions were unclear, and within a month most residents had simply given up."

What does the word "fiasco" most probably mean?', '[{"id":"a","text":"a great success"},{"id":"b","text":"a complete failure"},{"id":"c","text":"an expensive project"},{"id":"d","text":"a long delay"}]'::jsonb, 'b', 'The context — late bins, unclear instructions, residents giving up — all describes things going wrong, so "fiasco" means a complete failure. (a) is the opposite; (c) cost is not the focus; (d) a delay is only one of several problems, not the whole meaning.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cda6ae4e-68e6-5e12-ae28-ae797997cbb7', '72e8b533-b69b-5f4e-95db-09d94ad60365', 'Put these sentences in the correct order to form a well-organised paragraph:

1. "As a result, the team finished the project a whole week early."
2. "Working as a team brings many benefits."
3. "First, members can share the workload instead of struggling alone."
4. "They also encourage one another when difficulties appear."

What is the best order?', '[{"id":"a","text":"2 – 3 – 4 – 1"},{"id":"b","text":"1 – 2 – 3 – 4"},{"id":"c","text":"3 – 2 – 4 – 1"},{"id":"d","text":"2 – 1 – 3 – 4"}]'::jsonb, 'a', 'Sentence 2 is the general topic sentence and comes first. Then 3 (''First'') and 4 (''also'') give two supporting points, and 1 (''As a result'') states the outcome and closes the paragraph: 2 – 3 – 4 – 1. The connectors only make sense in this order.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Quiz: Know the exam paper', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('45de69e9-1de5-50f2-9f60-b4106d6397fb', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'An exam reading question asks: "What is the writer''s main idea?" What should you look for?', '[{"id":"a","text":"A small detail such as a name or a number."},{"id":"b","text":"The whole message of the text, often near the start or end."},{"id":"c","text":"Your own opinion about the topic."},{"id":"d","text":"The longest sentence in the text."}]'::jsonb, 'b', 'The main idea is the overall message of the text, usually stated near the beginning or end. (a) is a detail, not the main idea; (c) the answer must come from the text, not your opinion; (d) length has nothing to do with importance.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63b1b105-f43d-5d32-9238-bbf6fb14414b', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'In a True / False / Not mentioned task, when should you choose "Not mentioned"?', '[{"id":"a","text":"When the text clearly says the opposite."},{"id":"b","text":"When you personally disagree with the statement."},{"id":"c","text":"When the text simply does not give that information."},{"id":"d","text":"When the statement is too long to check."}]'::jsonb, 'c', '"Not mentioned" means the information is absent from the text. (a) describes "False" (the text contradicts it); (b) your opinion is irrelevant; (d) length does not decide the answer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c6fd010-6c6c-59dd-b928-aad83f83dec6', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Read this sentence:

"My sister loves animals, so she wants to become a vet."

In this sentence, who does the word "she" refer to?', '[{"id":"a","text":"the vet"},{"id":"b","text":"my sister"},{"id":"c","text":"the animals"},{"id":"d","text":"the writer"}]'::jsonb, 'b', 'A reference word points back to the nearest matching noun. "She" is singular and female, so it stands for "my sister". The vet (a) is what she wants to become, the animals (c) are plural, and "the writer" (d) would be "I".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('079b30d7-3f60-59f7-a3aa-b1ef79ac3e78', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the correct verb form:

"Yesterday, the students ______ a documentary about the desert."', '[{"id":"a","text":"watch"},{"id":"b","text":"watched"},{"id":"c","text":"are watching"},{"id":"d","text":"will watch"}]'::jsonb, 'b', 'The time marker "Yesterday" signals a finished past action, so the past simple "watched" is correct. (a) is present simple, (c) present continuous, and (d) future — none fits a past time marker.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85188fa4-904b-567e-adf6-02a36c162396', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the correct modal:

"You look tired. You ______ go to bed early tonight." (giving advice)', '[{"id":"a","text":"should"},{"id":"b","text":"can"},{"id":"c","text":"must"},{"id":"d","text":"might"}]'::jsonb, 'a', 'For advice we use "should". (b) "can" expresses ability/permission; (c) "must" is a strong obligation, too strong for friendly advice; (d) "might" expresses possibility, not advice.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c7fb0e5-23a9-5967-86c0-9ac82d0a5214', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Put the verb in the passive voice:

"The new library ______ last year." (open)', '[{"id":"a","text":"opened"},{"id":"b","text":"was opened"},{"id":"c","text":"is opening"},{"id":"d","text":"has opened"}]'::jsonb, 'b', 'The passive is "be + past participle", and "last year" needs a past form: "was opened". The library receives the action; it did not open itself. (a) and (d) are active, (c) is present continuous and wrong in time.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb1df896-3806-5d03-9230-d9531cce5f93', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Which sentence is the best topic sentence for a paragraph about the benefits of reading?', '[{"id":"a","text":"For example, novels can teach us about other cultures."},{"id":"b","text":"Reading regularly brings many benefits to young people."},{"id":"c","text":"Yesterday I borrowed two books from the school library."},{"id":"d","text":"In short, that is why everyone should read."}]'::jsonb, 'b', 'A topic sentence is general and announces the paragraph''s main idea — exactly what (b) does. (a) is a supporting example ("For example"), (c) is a narrow personal detail, and (d) is a closing sentence ("In short").', 7)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21c615c8-3484-52ef-8a08-9730c3daf203', '8349fe67-fc0a-5cbf-9318-f2cdbe86ffc0', 'Choose the best linking word:

"The bus was late; ______, we still arrived on time."', '[{"id":"a","text":"therefore"},{"id":"b","text":"because"},{"id":"c","text":"however"},{"id":"d","text":"for example"}]'::jsonb, 'c', 'There is a contrast between the late bus and arriving on time, so "however" fits. (a) "therefore" shows a result, (b) "because" shows a cause, and (d) "for example" introduces an example — none expresses contrast.', 8)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('426b680e-1a1c-5019-af64-72f7b81cc641', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', 'Paper 1: Practice — Family Life', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0b5540ce-a308-572a-8039-4e8cc0e980c5', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

What is the main idea of the text?', '[{"id":"a","text":"Couscous is the best dish to cook on Fridays."},{"id":"b","text":"The family''s weekly meal keeps them close together."},{"id":"c","text":"Grandfather lives in the house next door."},{"id":"d","text":"Children should always help in the kitchen."}]'::jsonb, 'b', 'The last sentence states the message directly: the weekly meal "keeps the family close". (a) couscous is only a detail; (c) where Grandfather lives is a small detail; (d) is not the writer''s point.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ab8c800-399f-5877-9a19-a7885c560245', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

According to the text, who arrives first?', '[{"id":"a","text":"the parents"},{"id":"b","text":"the children"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the neighbours"}]'::jsonb, 'c', 'The text says "Grandfather... always arrives first". (a) the parents are cooking, (b) the children set the table, and (d) neighbours are never mentioned.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02017d0d-9d9f-5fb3-a665-b8f263b9db89', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

In the last sentence, what does the word "it" refer to?', '[{"id":"a","text":"the present"},{"id":"b","text":"the weekly meal"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the kitchen"}]'::jsonb, 'b', '"It keeps the family close" — "it" points back to the subject just mentioned, "this weekly meal". A present (a) is what the meal is compared to, while Grandfather (c) and the kitchen (d) are not what keeps the family close.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb662391-35a7-50c2-909c-081c92409fb5', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Language: which tense is used in "the children set the table", and why?', '[{"id":"a","text":"Present simple, because it describes a regular Friday habit."},{"id":"b","text":"Past simple, because it happened yesterday."},{"id":"c","text":"Present continuous, because it is happening right now."},{"id":"d","text":"Future, because it will happen next week."}]'::jsonb, 'a', 'The phrase "Every Friday evening" marks a repeated routine, so the present simple is used. (b) there is no past time marker; (c) "set" here is simple, not "-ing"; (d) it is not a future plan but a habit.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8efce0dd-10b4-5f6f-ae30-384ebdff0e63', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Language: in "Grandfather, who lives next door", what does the relative word "who" refer to?', '[{"id":"a","text":"the door"},{"id":"b","text":"the children"},{"id":"c","text":"Grandfather"},{"id":"d","text":"the kitchen"}]'::jsonb, 'c', '"Who" is used for people and refers to the noun right before it: "Grandfather". (a) and (d) are places (they would need "where"/"which"); (b) the children are not the noun the clause describes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('537e935a-652f-5111-8613-25656b00ad2e', '426b680e-1a1c-5019-af64-72f7b81cc641', 'Read the text:

"Every Friday evening, the Karoui family gathers in the kitchen. While the parents prepare couscous, the children set the table and tell jokes. Grandfather, who lives next door, always arrives first. For them, this weekly meal is more important than any present, because it keeps the family close."

Writing: you want to add a sentence about another family activity. Which one best continues the paragraph?', '[{"id":"a","text":"The price of vegetables has risen sharply this month."},{"id":"b","text":"After dinner, they often play cards together and laugh until late."},{"id":"c","text":"My favourite football team won the match on Saturday."},{"id":"d","text":"The new mobile phone has a very good camera."}]'::jsonb, 'b', 'A coherent continuation must stay on the topic of family togetherness; playing cards after dinner fits perfectly. (a) prices, (c) football and (d) a phone all drift to unrelated subjects and break the paragraph''s unity.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d8e10e17-e701-5021-931b-4dcdbae61135', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', '⚔️ Paper 2: Boss — Health & the Environment', 3, 120, 30, 'boss', 'admin', 2)
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
  ('97e40233-213f-51fd-a7f1-f0bf0f053109', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

In the text, the word "banned" most probably means:', '[{"id":"a","text":"allowed everywhere"},{"id":"b","text":"officially not permitted"},{"id":"c","text":"repaired"},{"id":"d","text":"sold cheaply"}]'::jsonb, 'b', 'Cars were "banned from the centre" so that people would cycle instead — the context shows they were not allowed. (a) is the opposite; (c) and (d) do not fit the idea of keeping cars out for cleaner air.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb518c59-c56f-512e-b186-78d6542ecffd', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: the sentence "Cars were banned from the centre" is in the:', '[{"id":"a","text":"active voice, present simple"},{"id":"b","text":"passive voice, past simple"},{"id":"c","text":"active voice, past continuous"},{"id":"d","text":"passive voice, present perfect"}]'::jsonb, 'b', '"Were banned" = was/were + past participle, the passive of the past simple; the cars receive the action and the doer is unimportant. (a) and (c) are active; (d) would be "have been banned".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d7f1d4a-b5cf-512f-9b50-88ac74c5e953', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

What can we infer from the doctor''s words?', '[{"id":"a","text":"The doctor wanted the event to stop."},{"id":"b","text":"Cleaner air seemed to improve people''s breathing."},{"id":"c","text":"The hospital closed during the clean-air week."},{"id":"d","text":"Most people in the town were ill."}]'::jsonb, 'b', 'Fewer breathing patients during a clean-air week suggests the cleaner air helped people breathe better — an inference supported by the clues. (a) contradicts the positive report; (c) and (d) are never stated and go beyond what the text suggests.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e04c9ac5-3c55-5ec1-8cb2-ef8646730baf', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: report the doctor''s words. The doctor said that ______.', '[{"id":"a","text":"he has seen fewer patients with breathing problems that week"},{"id":"b","text":"he had seen fewer patients with breathing problems that week"},{"id":"c","text":"I have seen fewer patients with breathing problems this week"},{"id":"d","text":"he will see fewer patients with breathing problems this week"}]'::jsonb, 'b', 'In reported speech the present perfect "have seen" shifts back to the past perfect "had seen", "I" becomes "he", and "this week" becomes "that week". (a) keeps the present perfect, (c) keeps the exact quote, and (d) changes the meaning to the future.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('316620e5-8554-5638-8f9d-5fd49771dd20', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Language: complete this conditional sentence based on the text.

"If more towns banned cars for a week, the air ______ cleaner."', '[{"id":"a","text":"will be"},{"id":"b","text":"would be"},{"id":"c","text":"would have been"},{"id":"d","text":"is"}]'::jsonb, 'b', 'The if-clause uses the past simple "banned", which signals a second conditional (an imagined situation), so the main clause needs "would + base verb": "would be". (a) belongs to the first conditional, (c) to the third, and (d) is not conditional.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2f60586-bf58-5a2d-b577-39ed8ac710dc', 'd8e10e17-e701-5021-931b-4dcdbae61135', 'Read the text:

"Last summer, the small town of Beni Khalled launched a clean-air week. Cars were banned from the centre, and people were encouraged to cycle. By Friday, the streets were quieter and the sky looked clearer. A doctor told the local radio, ''I have seen fewer patients with breathing problems this week.'' The mayor promised to repeat the event every year."

Writing: which sentence would be the best topic sentence for a paragraph summarising this text?', '[{"id":"a","text":"The mayor spoke to the local radio on Friday."},{"id":"b","text":"A clean-air week in Beni Khalled made the town healthier and is set to return."},{"id":"c","text":"Some people prefer cars to bicycles in summer."},{"id":"d","text":"For instance, the sky looked clearer by Friday."}]'::jsonb, 'b', 'A topic sentence is general and captures the whole idea: a successful clean-air week that will be repeated — exactly (b). (a) is a small detail (and inaccurate: the doctor spoke), (c) is off-topic, and (d) is a supporting example introduced by "For instance".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bf325094-b7d9-517c-a966-9e62838c6136', '28c49d05-7851-5d81-b041-e443203e34d3', 'english', '👑 Challenge: Master the Exam Paper', 4, 300, 60, 'challenge', 'admin', 3)
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
  ('037153f1-ec0e-5896-a66e-4371cc4ce27f', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

What is the writer''s main message?', '[{"id":"a","text":"Libraries should only lend books, not teach coding."},{"id":"b","text":"An attractive activity turned an ignored library into a popular place."},{"id":"c","text":"Teenagers never read books in their free time."},{"id":"d","text":"Saturday is the best day to open a library."}]'::jsonb, 'b', 'The text traces how free coding clubs drew teenagers and made the once-empty library the busiest place in town — that is the message. (a) contradicts the positive view of the clubs; (c) overgeneralises one detail; (d) is a minor detail, not the point.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdce6c1c-e193-542b-82a4-aa2d0b8fa00d', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

Language: in "students who had never borrowed a book", the relative word "who" is used because it refers to:', '[{"id":"a","text":"a place"},{"id":"b","text":"people (the students)"},{"id":"c","text":"a thing (the book)"},{"id":"d","text":"a possession"}]'::jsonb, 'b', '"Who" introduces a relative clause describing people — here "students". (a) a place would take "where", (c) a thing would take "which/that", and (d) possession would take "whose".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d8b0540-5dff-544a-9e9c-7de7022890e7', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read this paragraph a student wrote about the text:

"The library became popular for a clear reason. A young librarian offered free coding clubs. These clubs attracted curious teenagers. My uncle bought a new car last week. As a result, a quiet building turned into a lively place."

Writing: which sentence breaks the unity of the paragraph and should be removed?', '[{"id":"a","text":"\"A young librarian offered free coding clubs.\""},{"id":"b","text":"\"These clubs attracted curious teenagers.\""},{"id":"c","text":"\"My uncle bought a new car last week.\""},{"id":"d","text":"\"As a result, a quiet building turned into a lively place.\""}]'::jsonb, 'c', 'Every sentence develops one idea — why the library became popular — except "My uncle bought a new car last week", which is off-topic and breaks the unity. (a) and (b) give the reasons, and (d) is the logical conclusion ("As a result").', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba654174-6d8d-52bd-9e69-852833432ecd', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

What can we infer about the teenagers?', '[{"id":"a","text":"They were attracted by the coding clubs more than by the books."},{"id":"b","text":"They had borrowed many books before the library opened."},{"id":"c","text":"They disliked the young librarian."},{"id":"d","text":"They only came to the library to sleep."}]'::jsonb, 'a', 'The crowds appeared after the coding clubs began, and many "had never borrowed a book before" — so the activity, not the books, drew them. (b) directly contradicts the text; (c) is unsupported and unlikely given the success; (d) is invented.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b387f8f-8611-5635-929f-c59100149417', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text:

"When the new public library opened in our neighbourhood, few teenagers paid attention. Then a young librarian started free coding clubs on Saturdays. Word spread quickly. Within months, the once-empty reading room was full of students who had never borrowed a book before. The library that everyone had ignored became the busiest place in town."

Language: complete this third-conditional sentence about the story.

"If the librarian had not started the clubs, the library ______ empty."', '[{"id":"a","text":"would stay"},{"id":"b","text":"will stay"},{"id":"c","text":"would have stayed"},{"id":"d","text":"stays"}]'::jsonb, 'c', 'The if-clause uses the past perfect "had not started", which marks a third conditional about an unreal past, so the main clause needs "would have + past participle": "would have stayed". (a) is second conditional, (b) first conditional, and (d) is not conditional.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1db5805-5ef7-57c2-a2e3-3e4704b633e4', 'bf325094-b7d9-517c-a966-9e62838c6136', 'Read the text again, then look at these four sentences:

1. "However, success did not come at once."
2. "A new library opened in the neighbourhood."
3. "Therefore, it soon became the busiest place in town."
4. "Then free coding clubs began to attract teenagers."

Writing: what is the best order to form a well-organised paragraph?', '[{"id":"a","text":"2 – 1 – 4 – 3"},{"id":"b","text":"1 – 2 – 3 – 4"},{"id":"c","text":"2 – 3 – 4 – 1"},{"id":"d","text":"4 – 2 – 1 – 3"}]'::jsonb, 'a', 'Sentence 2 is the general opening (the library opened). 1 ("However, success did not come at once") sets up the slow start, 4 ("Then... coding clubs") gives the turning point, and 3 ("Therefore... busiest place") is the result and conclusion: 2 – 1 – 4 – 3. The connectors "However → Then → Therefore" confirm this chain.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

