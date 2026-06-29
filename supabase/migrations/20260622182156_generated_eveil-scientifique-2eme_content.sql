-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-2eme (الإيقاظ العلمي)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-2eme/
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
  ('eveil-scientifique-2eme', 'الإيقاظ العلمي', 'نكتشفُ عالم الأحياء: الحيوانات الأليفة والبرّية، والنباتات المغروسة والتلقائية، وجسم الإنسان وتغذيته وتنقّله وتنفّسه؛ ثمّ عالم الفيزياء: الفضاء والمسافات والقيس، والزمن، والمادّة، والقوى، وفق برنامج الإيقاظ العلمي للسنة الثانية من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '2eme-base'))
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
      AND e.subject_id = 'eveil-scientifique-2eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('52fb00c8-bcd0-52b9-bb8b-bceaab89b93f', 'c8e6d1e4-812b-585e-96e5-a5cd9701b039', 'd75ec201-590f-5725-b44f-ea3518519781', '34002379-9e50-5965-92b0-00943d27bb98', '473e6959-e211-53bd-94bc-dd5ed8e24579', '1f56e6dc-d238-5844-81c3-9e2ccc428e1a', 'd6417697-66a8-51e6-a95e-e05892265eaf', 'a4be76f5-76a8-55ba-8593-7b3abd622afc', '03c13c7f-8e42-560e-9611-c90655a47f6b', 'c50d46f0-1343-5959-aef2-a3b3e7bee69e', '49b55742-a5d0-569c-87e9-dc97af861ac1', '22ae602f-d1da-5984-af03-003afdae5e1b', 'c1827a62-5275-59d7-9e4e-b77d4907b18a', 'd10f923f-c1cd-5766-8e59-bdf24e235174', '21423bd3-10ab-517a-81b0-a80f881e7c30', 'd43d67c1-7018-5d3b-9f25-5f68c284dbe5', '3be6e676-b090-5fa5-b9bb-6ff258817c02', '434389da-6cc5-5b25-bfb5-37ba886c30e3', '0bc32620-074c-54c1-b395-c9c7b50e6a64', 'c8360fa2-cd52-59e5-8815-75786b86fa1e', 'f23a2645-ee18-5f18-bd61-52b921e5e8af', '877861a6-03b7-5546-9a8a-a57ca70d4f61', 'db004e16-1359-5d79-825a-aed7d2f5dd06', '227a4a0d-2dc8-552d-b85e-3c386ac3b943', '7d1e83f0-b56f-5ae7-a670-79a6247d2e93', '9ef0d4f3-b7ff-56e5-bb02-2e322b35b5ea', 'f6e33470-7abb-5335-a73d-78b0e219cee8', '047defe7-b4fd-5600-bd2e-9e7bcc19fed8', '7162a7a7-c5fd-5927-af4d-9488bfe1e3cf', '523b0bb4-d3de-57b1-8f46-7e3a63d136bd', '3101a2c3-1b50-5891-b32e-776dd412b7cb', 'ca1d08a6-635b-55d3-8b35-710f364cdb03', '7f8a91eb-bb59-53c7-9850-bbf3357c15b0', '13aa8436-6ff2-51cc-bd3d-e9e9451f29ba', '1bf254bf-2332-5712-9375-a6c92e54010a', '5edf3a85-ea24-5cf8-9672-d438936778a6', 'bfe3f614-0d0b-5dd0-b4ab-731fc5eead5c', '3b9f5e36-e17c-5737-958d-66c065e0b9dd', '34f08ce5-4e1c-597e-9f2d-aa2bd9e956dd', '9bdd30ec-5d17-54b4-8104-64acc96e6376', '400c97c7-0bf5-5c6b-8ca6-7e11a583a4d6', '8380f141-0ea0-5fd0-893b-b5e56efee5e7', '8c22abb2-f364-5907-891d-756634524d19', 'd10536c6-8f0e-5492-96d5-b3edcc0e7f6d', '7c5420fe-9426-5b0c-871a-5777e68d0e47', '3a674224-fd62-5640-8e9d-729266e93904', 'c7142227-4dfe-5894-a6e7-347d7543b942', '7b4585eb-a192-5e9b-bd35-857370832357', '1f6694d1-bebd-5b09-ac84-dbeac2137d5f', '07d15b15-1d40-5f3b-b7b9-4835258bd368', 'e2954a24-5f6f-5f15-a81f-91ead78d8aa9', '151ecd05-aefe-5871-8fc6-7cadf964e59e', 'e2a3b8bc-07f2-5187-a81f-0478fb4db0c1', 'e59ccad4-4632-5196-9205-6cfcfc1c2783', '956361a8-6b3b-5265-bdb2-7ca5e7fc156c', '9b9625b1-ada4-5440-8cb3-5847cd81e256', '001e05e8-64c3-5ad8-8235-f4f885e12954', 'b709063c-4c0e-580b-8569-47086e0f9ac1', '42c1ffae-75a8-5930-8d05-698315105a55', '404fb1f3-caff-5a39-85ae-83b4034c1c46', '18019a79-b782-5887-91ad-63d04a9e4870', 'cc49188e-de66-5ea7-99df-fa62aca65d64', '87dc255b-a218-5b43-91e7-ac457d9b8510', '9753e100-ea99-549a-90d8-9c6674e49d4c', 'a120aa6b-4d3b-56e9-80e0-5de88a16ae8e', 'c40a70b2-b5f5-5d85-966d-af30d1801799', '3544a9ce-9d2e-56c8-8b7c-b000d1d6ebb0', '66627e12-cbff-5280-8514-df937c7cdca8', '6324bc19-4a98-5a43-a42e-ae6096020082', 'd2e7d893-6723-5142-91aa-954b92f9da94', 'acd80643-b0be-56ba-8cbb-5ff95a4f2414', 'd1bf4746-e9c0-58de-b9c9-c0a6be34408a', 'bc4fa748-002c-5390-9d20-18820233b1a0', '2fba0b1f-fffd-539e-bfdf-e279042a0528', 'c6b351fb-a6dd-5f50-a0e4-0fe4d097a0cd', 'aadf873b-6b66-594f-b2ad-c613f7313e39', 'da3ce2cf-e8c4-50b5-a017-c938fa216837', 'b6c1bbc9-e560-5ae9-bf2f-8fefa8f8162a', '6ae40ba1-2a2d-5d11-9459-6cbd5767dab0', '60b3ab6d-6d17-59fd-adf1-59be9c35fd2b', 'c88e3248-5f44-567f-b854-173913a3e975', '085f80cf-2fa5-5ae7-b781-19fc32c85f34', '09caa4f7-470e-5757-818c-e7508348b93f', 'fb506cec-30e1-5f7d-a8cd-cb04dd6de3d4', '0ec9d729-5ca1-5af7-b6ae-55ad088605ca', 'a5d6f58b-0d82-521d-87a6-e5c1e05c81b4', '16c019c7-b285-5aa7-9fb7-8e72b039fded', '9eaadc92-cce9-5fa0-8a1f-894bea90cba1', '24c99171-9685-5499-bb7c-61b2c87bcb7b', 'f0da5a4f-4b6f-5551-84c6-d24a2dd46950', 'b7502615-ef59-5ed5-a12b-f8c657979c52', '248e0d61-1c85-56c2-8fc8-ea1bc3ef143d', '4ce97f26-9078-55f8-b615-8bdb7f3e9430', 'f146f416-0b42-5172-b080-0dfbc82802b9', 'f627b0e7-43b7-507f-bb77-8c3168658819', '997de3c8-5927-5368-9b3c-f07a7ceec955', 'ccb008c5-3f3b-5422-922d-ed1b85c47ddf', '6352531f-9cee-51ba-92e9-9017d0d25f6c', '93d04bab-c8bd-5344-82ab-19b8af8345e0', 'd24cec10-326f-507b-bbab-8101c228fa0a', '29a58ebe-625c-50d9-a294-40d15561dc2e', '3d7bd806-d741-551f-ba56-d36ba4d7d4ed', '134a00f2-db5e-50bb-94cc-4acdbb84f8e7', '1db0a74c-38fd-57bd-8b3f-772609894cf1', 'c1a1d038-bf1d-5875-a9af-3c55b16a02d0', 'a24bd812-a457-5005-9702-ba2090e91f0b', '22dec132-6567-553b-93e0-7fa7f450b98d', '16cc4a7f-0317-557e-b492-85d4a047b122', '7e4d992b-79f8-56a3-8a15-04e4104a4cf6', '151fe381-8eac-5375-8d38-87d0be574832', 'abe83c50-3f20-5678-8cd1-fc6caefc8918', 'b734973b-bc9f-5a14-bfae-dfedfc01fc2d', '54b24891-d0ed-5032-812b-4450c320eede', '5383f455-cf9c-5277-902a-23b32f5e1296', '61bedf70-2703-50e1-959d-a5e7e7662dd8', '470e3303-0404-5ba3-b472-d249b66ff4b0', '5971b9e5-16eb-5915-a9e8-835d20a9f887', '51ca0f68-1eef-5e47-9dd6-989e0bc862d6', '70185331-1bd6-5b97-924d-cce7bbe18999', '6ec2073f-9c0b-52e9-9c2f-4fc5bb112705', '5f991490-0dc5-5416-a839-b63e6ada8cbb', '2b50805c-8c7e-5cf7-8f78-add08e1ea23a', 'a832e9b3-30bc-5cd2-9d19-7cf19380dc27', 'ed59ed4c-e1be-517e-a524-a7529dc6608a', '84d12636-60a6-5040-8f26-13e771600961', 'f74c7c4a-4a58-52c3-892e-234e19dc9e1f', 'c7c00be1-8109-5765-bc35-2c5c9061eade', '1323ae50-875d-55b3-94ce-0c3fffc01f3b', '8346a598-f714-52bb-8f3e-296ff94de58d', 'c8e14439-93af-5963-b468-3c90fe16cd96', '786a2c2f-e339-5257-ada4-72812c361be5', '7587a156-8ec0-56ec-97e0-43df9b2ead0f', 'f3f22dc9-1559-5883-a2ce-01b300f351ab', '70ce1fba-43b3-5a6f-977e-a3423d732049', 'd030d5d7-2343-51c4-99a8-9329219e926a', '45567b28-139c-552b-8e7f-466cf6693fa7', '120cf297-1936-56c3-a07c-cb11be317659', '22934687-9389-5bda-b9ec-3ce23636d507', 'f8f4ee7e-bbc9-58ee-9ef9-c413a85a2b8e', '7ae15ce6-6f99-56f4-a272-dc94f0f0cd85', 'edbed3e1-1a8b-5389-9395-ac872c0c8904', 'cd3b6cbf-37d5-5337-a3dd-4a7425924990', '47012b74-ccdf-54a0-bb2b-92e28bce1754', '01350a60-2e06-5e93-80de-24e3d2e5088a', 'b4db483a-5c89-56b8-8fb4-154c817c6249', 'c6af5d7c-9055-5b27-83d6-538e512920ed', '52771464-332d-5906-a3ef-38286fbec422', 'd2d335e2-1717-5a26-b70f-44f49be8488b', 'e23d71e4-cc66-56df-80c0-6b404345eb3a', 'a6a22b3a-69ab-5abc-95de-8b6e4835508f', '7e9ea785-661e-561f-8693-9536349192de', 'd8ad6c3f-36b2-5f0e-bc17-81e6894040aa', '6bfdea48-2eea-57e2-8179-b56f19ead567', 'f1236959-0064-5198-bec3-5b2c17ac6ef1', 'a901c09d-2d89-5c92-ad16-c941677cb845', 'a79e332a-e11c-5161-9074-2643a0907c84', '21d78123-2891-55db-9d43-29aa2b149d92', 'aa59cbfc-d6e3-5322-aaae-ee0e8f256e38', 'a5c5aa2a-2cb7-512c-96a0-683bbb52616d', '20d649b0-9e70-5215-992c-7050b20cd0ff', '2da37f96-7fee-5e3c-8bc9-5633e22cda48', 'cd6f9a83-1bc0-58ef-be01-cddc274b9df5', '1ed71c15-0b2e-547e-8a25-805430f5f942', '64b24877-8b08-58bc-8c2a-f8b5b3673d6f', 'e6d652e1-c276-5793-af70-67f262708323', '30628f8e-8e19-5ddc-9936-74f62bb066d2', '0b1fb3a7-ed20-598a-90e7-c9548403dfa3', '3389ff92-a7cc-5452-ad9c-28a78f9322f1', '52643f8b-930e-57e5-8671-6659fc8e757f', '415bf82f-6a5b-5e30-9817-f49efcd5b579', '08881516-dedc-5a79-b61e-96949394b1d4', 'f3773714-d38b-5cd6-bdad-ca23c2bce4d2', '2638a256-7a73-554f-8de1-f116a6c855f9', '784ed6cb-c659-5a09-ab83-df40e865082f', 'c5287d78-d360-530a-8d98-36869ae18cdf', '1d270559-2a4f-5694-bdb7-c68f0913d6b4', 'afbefc78-f752-5b91-b138-f064b6af59ca', 'e006f484-48cc-5acc-8617-075b1d26fdae', '3d55aef0-7d96-5b2a-9a5e-5e96a919b8fa', '4af96bd5-ab9e-5ee9-8bad-dfb27cfed972', '77643e23-4c93-5650-bc86-e73cbdcd3e7a', '9232522b-7078-571b-8cb8-643fd215b4dc', '9a310bfd-a9ae-580b-8ac0-2ddb7ce40902', 'fcc4dbe9-6c57-5fa7-9362-373908ddbec5', '9d287125-890d-516b-a2ad-d85ce5fa2b0d', '865d8454-6ece-565c-8846-70857fb82128', 'ee1b4883-7904-5baa-8748-f1aaadb0b824', '99f58de0-027a-51e5-b92e-939da182fc39', 'db1e4933-3d88-5725-9dab-c8922275af33', '6e4411f0-9a83-5a97-8ab9-01208968bc38', '07572ad5-ad8c-5ee2-9550-a0bf27d212d1', '7e62fca4-a1e9-58b3-abf2-1a5d4305fa1a', '7b136959-fb8d-545e-b7fe-eff9bb34ac10', 'b9473b71-8a2a-58d9-aead-06b23cc186ea', '3e80d806-564d-5146-b539-64a7d7739b53', 'aa7ae8d6-380f-5447-9e4d-6754e8044632', 'e9cc4661-b029-509e-b4ab-eca2bdf40c98', '04315d18-1657-5a51-9e55-e1362e87d2cd', '2d5bda67-9e88-548b-bd23-7e9bea185d0b', '44f9cc92-9589-5a79-94a3-fdfb0b22a26c', '85b82a83-ddbe-5c22-a2eb-e37302529ba2', 'a3b8556c-1afc-58ca-821e-61e783e7e722', '54a36307-c054-5302-9287-87331f79c3b1', 'd9ce0a4a-7f6f-50b0-831a-057f4ee4f8df', '3ef0f19e-eb4f-578a-bb25-b1e10252b1de', '8c80ae98-2eeb-5de0-adb0-7947387e778d', '9f060f94-ac60-50cd-b9e7-0e8a7d4a329e', 'b0692dc0-d797-5c60-a684-d6a86b560677', '565d0a86-2e44-5be6-aefe-9862d01fc948', '0a44597c-16be-53b5-b2c5-212b30968816', '9d089130-178b-55ee-8700-10fb84cfb355', '67aebe48-c514-5a7b-98bf-4094fcbb86d1', '9fe8e35a-ee1f-5a49-8bde-a4d9af5dbba4', '7c158fee-4ae0-596f-9361-0290adddb50b', 'a4d78067-3d7c-5f5e-89b3-a66fe2326412', '7346ae17-2c83-519d-b076-21c1ba7c2f95', 'f43313bc-1667-59c7-ad1b-55679567310d', '2977c18d-55b9-5fe6-a54c-9d23b1599ed0', '4764222d-636d-5e6e-8a14-a21cb818db86', 'd8059ccf-8da0-5641-a425-eb0b5092f0ac', '61850603-bb56-5e49-922f-bba1a3d355bf', 'a4927644-04e4-5a09-8235-b0b52ed2eac5', '76153d40-aa93-5ffa-b1be-b1bb2a0ba15f', 'b0a7e45b-1fc7-53e8-83df-904e61f02855', '57917e57-b39f-5d30-806b-ce7e2184e8ab', '205334da-290f-5a07-899d-23c714b0bdf1', 'ae079820-81d7-5f94-9357-be1256ef0c1a', '6ed90f9a-3677-5b0e-94f0-4db4ef3d7b86', 'a6ca1a9b-a820-5564-bc19-e5bd938d43af', '008049cc-6554-57b6-bddb-e5ef448c5bad', '7ab5b4df-6ec1-58bd-87cd-43cbac63a0b2', 'b10a3e40-ce94-502f-96c7-a2af13a7cf74', '56b56d19-2bf0-5ebf-a60b-704ff949adf5', '046d1ef9-8fa2-50fe-83e9-24a79e6f8249', '93348d94-5fe6-555c-8269-24619e89d885', '23bddb7e-23ce-5a55-8863-f5e7980c0cb8', '7f2cc5a5-749e-561d-9f35-e1f350fb4a46', '48367e32-6ea3-592d-b126-48f69758a887', '13abda19-d837-571f-b9c2-7478c8d38210', 'bba8fa81-5367-5695-9f51-9a1a2e139005', '4ac3a47e-e38e-5c65-bfb5-bd397d055eb0', 'ffe4265b-3c2f-5e12-b4b5-baeaae5fbc71', 'bfcda988-b968-52a7-a7be-530a7869764d', '8444d19d-da5b-5520-9097-793bde377aa9', '84732b4d-051d-5a79-aaa9-2526c562cca0', '66faee3c-480f-5b3d-ad03-313450712f1e', 'b7c8ef01-8d0d-559d-ab8a-1d235f3f6fa1', 'c24e3b47-ac15-5973-ab7f-1ab366f34c1b', 'e9ea2ac2-5973-524c-99c4-06771142f51a', '24504a83-60ca-5218-806b-1bc27dc0b183', 'f0b81e5e-4edd-5807-bb84-c60549789a32', 'f3fcc05c-7896-563d-b805-580aba5034aa', '56a09018-7897-5767-a779-ceda5fbb6a30', '9bccab64-a551-539e-80f0-cbd11ff989f8', '72fd6e87-502c-53b0-a308-dbf147d75e6c', '77ff7fc0-a439-5014-a113-696b14809891', 'ab489d97-bf33-5bf2-8cef-d664dc1c5bb1', 'd524b1f0-1f39-57f0-afc2-1d10cfcaef3f', '3a4b26d7-b9e8-5f97-bc5c-bad2ade7129c', '562c1ed8-e533-5947-bf17-efd713254271', 'cc3b8ba4-a015-537a-aa6e-2cbb7f3e3947', 'f34aa50a-a578-53e8-af0d-7eae23a089f0', 'fc898a65-4542-567d-a336-05d0bd7f2ec3', '575ec66c-04a9-5a3c-b07c-aec21f799739', '18711ef7-9a3f-5a40-9736-ac9b7c20065e', '459ecd0a-2c00-54b1-90fa-094fe0353e7d', 'bb8e37ad-c672-5f41-9d69-25495c80ee0b', '1d748656-87fd-5431-9f53-2b2f46c83a8d', 'c0e0329c-1704-56bd-be4f-7adf1f3b8c8c', '08f8dcbc-ade2-5c7e-96db-972751634399', '91a9bb65-3c2c-5104-b073-298491678a25', '1991fb16-e5f8-5cb8-8a0d-8152178c97f0', 'e509388a-ea68-5363-875f-afa35141e5ee', '74d03538-ff33-5658-9d19-d6b6aaa06fa6', '87472389-8add-5f27-9edb-6f79db5a0285', 'b24843a0-4d87-57ba-8db9-a8632abd4bda', 'bea120a0-87f0-59e1-9a73-add85990bf7d', '5e05aa30-ae66-57b8-abd8-829a04c834aa', '4f80682c-70b6-5f79-aeb5-7748614da7fb', 'b922afd6-082e-5614-ac01-c40279ec3b0c', 'a474b912-03f4-589c-b807-1ea8259978c3', '29b154b4-51fd-54ea-9034-6840755142c6', 'a19f9f04-6b38-5e33-a068-e55ae61ad037', 'de1eaf37-3d93-54c7-8e63-d4456ea44b7e', 'd369fc63-c92a-5242-96de-82f6e66ed22b', '123dbdc5-ef70-5b16-88e5-e7f807da07f6', '7bdfc822-c2e9-5995-a3b3-82004304b8e6', '1a8339db-0aa0-5eb5-890d-ee0562728a81', '289198e5-0cf2-5e54-8082-a54e89462f3a', 'bd3eeecb-52c8-5c15-a12a-7d1c817e2d0e', '8c442412-454c-5365-9a3c-2eef77a683a2', '33362f40-ce71-5723-8cf4-25f9443c52ac', '954691c1-e42a-51c9-a7db-3762054bfbe9', '312adbc5-adcf-56c5-bb33-64365ad5210a', 'ba03e2b2-7968-5c8b-839f-9823f6334ff6', 'e5f92f25-7750-5b3e-8142-92faee8ba1c9', '7ee6126d-6094-55ed-9ff7-6e911928d3a4', '06d8a32c-e828-5f2c-b46a-026559aef4c0', '0ca77c5d-c728-53c7-809f-42a4427d6feb', '0ae38c65-f573-5ad6-bf05-87c8c17878ea', 'd2f6278d-52a4-5c65-bfbb-f654336d3ecc', '2c7edf82-7e2e-56e1-94a1-12426b3b9f84', '2377cbd5-bff7-5235-9390-3704e6dd1fc6', '99a1a2e0-d2bd-50bd-beb1-d9d7c92f4bba', 'f8012e9c-6012-59d6-a560-1cd44b17e237', 'e1133193-cb38-56cc-9e70-7774ccd026d7', 'e9aa73b5-135c-52ec-a127-109803918386', 'c073a421-6402-55f6-a9c9-44a36b6c3d7e', 'b63ffb16-7255-5860-90d9-3654fed26497', '3f63cfd7-0ca6-5247-9d39-2d0255ea9c07', 'ae8c9d65-324a-5663-b4e8-d3cb4ba2e6ed', 'd3932e53-38a3-5799-9f96-2b7216a5f674', 'dcdd5215-44df-5521-85c6-3ba5d3754e76', '0b04f474-6726-5400-b0cb-3da76b853295', '2e9cc57a-04da-578b-a338-0c53bfde8359', 'cb8e1ae8-dfde-59de-b65f-0f191f1813ad', '801e2312-1507-596e-90f1-105400f73102', '75c2aeac-7dcf-56cc-9e9e-0c47d52d19f4', '0bbcf1a0-b884-5fc0-ab2d-6f9b64d87a87', '09d329b9-b63e-5a45-a8b7-37088da036bd', '3dcdcdf3-16f1-57fd-ab9b-b84f33f40878', 'acd2fea3-f55b-5425-9026-9d8bc652771b', 'e3946442-e297-534c-8e35-52ff5b67ce37', '31923788-ebac-5918-9b47-b7c4ca2155ff', 'd86fba62-e9b3-566d-adbb-10f2a4cb890c', '587cace2-68b6-55af-a771-c1a88fe28940', 'aac635e5-2cb1-5699-815a-033483ca8994', '6a0837d0-8efe-592a-a485-deb053ec5214', '5597dd0f-d091-5671-b3d3-419ee49fd41e', '1a70fcc4-c2e1-5acd-9dc7-346471fcc39d', 'ff7c6a8b-ac83-506c-a28b-6d8ecdd9f3fd', '2bcf9aec-2028-57aa-b1a7-cab09161650d', '51bace8d-d282-5302-9f74-2eb296d4149a', '2eb3f8a4-60cf-5fa3-a968-17df1f5e3e53', '56d4067d-bd5c-5d9e-949b-880142a35d1b', 'a9abe733-3e57-5b23-9e2a-93b8e74f8cba', '39c468ad-76af-590c-9839-22b43d359a4c', 'dd87e424-0eef-5376-b22d-2370aa9326b9', '628d5548-757c-5ebe-9bbf-3053aa444c09', '0612e33d-f880-507f-9e68-6f41d877ddc7', '4f8c4f26-5edf-5ffd-b67b-c9cc16460133', '1a46cff3-86b2-58ea-9a0f-0ff6f22ddd96', 'b42faa9f-4122-5179-92a5-94dfd2d3d376', '62ecf6ea-b89b-5151-b2c6-9c79d27b9e09', 'e00c008c-11c3-553a-b14b-98e856216451', '456ebe4f-f145-5181-b1dc-244568ccbaff', 'f3711687-7fd5-55e0-9c1e-97805daf780e', 'a42e1ffa-465d-54f9-847e-63e53bd014a6', 'f6b7db09-97c2-5579-bd96-550fc3e60967', '683f997a-99b0-5dfb-9d69-249e1783a94e');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-2eme' AND source = 'admin' AND id NOT IN ('39b4bf5f-3011-57a5-8035-744364eecbf5', '4294bff2-4018-5e9f-acf5-93e951c0301d', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', '143ab983-302e-57f2-b038-75f134f0e264', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'd088f26a-cc6d-5be1-97ea-070d39311c16', '365371e8-99b7-5a05-8f9e-18f550d15dac', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', '1981da26-1cdd-551b-b708-33e6b47d4be1', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'd406b796-1924-521f-abde-f22b82e82bd8', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'd301efc9-f00c-57f4-890e-e398454d2aa9', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', '551223aa-75ff-57a9-a2cd-b4b61336a410', '1c5aee80-f700-568c-9d6b-06a312ab7321', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'c99df168-9605-542b-8a8d-882dd952dd20', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', '334a7121-c262-5f9a-a903-3a04b98c5376', '6daa0799-6714-517d-a251-1ae62766c13d', '875e5eed-d064-5d2b-aae2-705f52f65553', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'a759be6b-654f-5497-98bb-7126c46c6987', '3592e190-995d-5f2d-b443-3215d80761f9', '0905a46d-e99c-518d-9aa2-40f480b7c258', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', '2bbb872c-0bf9-511a-8800-3b0116946564', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'da1fb36e-82ee-5396-b522-d95554347101', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', '7528f239-9cce-594d-be59-8ebbc0267b41', 'f6fc13f2-4623-5470-88e2-8598416f1e25', '489faaa3-f542-5fd9-a74a-c6c910f090e6', '7193e238-1765-5207-9f78-fde4538a639b', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', '9290404d-5200-5b58-be94-2847d8921f79', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', '1a3290f7-7e35-598c-b60b-ecf912cda704', '8da86998-8b34-574d-8e65-e852f0644a99', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb');
DELETE FROM public.questions WHERE exercise_id IN ('39b4bf5f-3011-57a5-8035-744364eecbf5', '4294bff2-4018-5e9f-acf5-93e951c0301d', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', '143ab983-302e-57f2-b038-75f134f0e264', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'd088f26a-cc6d-5be1-97ea-070d39311c16', '365371e8-99b7-5a05-8f9e-18f550d15dac', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', '1981da26-1cdd-551b-b708-33e6b47d4be1', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'd406b796-1924-521f-abde-f22b82e82bd8', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'd301efc9-f00c-57f4-890e-e398454d2aa9', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', '551223aa-75ff-57a9-a2cd-b4b61336a410', '1c5aee80-f700-568c-9d6b-06a312ab7321', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'c99df168-9605-542b-8a8d-882dd952dd20', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', '334a7121-c262-5f9a-a903-3a04b98c5376', '6daa0799-6714-517d-a251-1ae62766c13d', '875e5eed-d064-5d2b-aae2-705f52f65553', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'a759be6b-654f-5497-98bb-7126c46c6987', '3592e190-995d-5f2d-b443-3215d80761f9', '0905a46d-e99c-518d-9aa2-40f480b7c258', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', '2bbb872c-0bf9-511a-8800-3b0116946564', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'da1fb36e-82ee-5396-b522-d95554347101', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', '7528f239-9cce-594d-be59-8ebbc0267b41', 'f6fc13f2-4623-5470-88e2-8598416f1e25', '489faaa3-f542-5fd9-a74a-c6c910f090e6', '7193e238-1765-5207-9f78-fde4538a639b', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', '9290404d-5200-5b58-be94-2847d8921f79', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', '1a3290f7-7e35-598c-b60b-ecf912cda704', '8da86998-8b34-574d-8e65-e852f0644a99', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb') AND id NOT IN ('52fb00c8-bcd0-52b9-bb8b-bceaab89b93f', 'c8e6d1e4-812b-585e-96e5-a5cd9701b039', 'd75ec201-590f-5725-b44f-ea3518519781', '34002379-9e50-5965-92b0-00943d27bb98', '473e6959-e211-53bd-94bc-dd5ed8e24579', '1f56e6dc-d238-5844-81c3-9e2ccc428e1a', 'd6417697-66a8-51e6-a95e-e05892265eaf', 'a4be76f5-76a8-55ba-8593-7b3abd622afc', '03c13c7f-8e42-560e-9611-c90655a47f6b', 'c50d46f0-1343-5959-aef2-a3b3e7bee69e', '49b55742-a5d0-569c-87e9-dc97af861ac1', '22ae602f-d1da-5984-af03-003afdae5e1b', 'c1827a62-5275-59d7-9e4e-b77d4907b18a', 'd10f923f-c1cd-5766-8e59-bdf24e235174', '21423bd3-10ab-517a-81b0-a80f881e7c30', 'd43d67c1-7018-5d3b-9f25-5f68c284dbe5', '3be6e676-b090-5fa5-b9bb-6ff258817c02', '434389da-6cc5-5b25-bfb5-37ba886c30e3', '0bc32620-074c-54c1-b395-c9c7b50e6a64', 'c8360fa2-cd52-59e5-8815-75786b86fa1e', 'f23a2645-ee18-5f18-bd61-52b921e5e8af', '877861a6-03b7-5546-9a8a-a57ca70d4f61', 'db004e16-1359-5d79-825a-aed7d2f5dd06', '227a4a0d-2dc8-552d-b85e-3c386ac3b943', '7d1e83f0-b56f-5ae7-a670-79a6247d2e93', '9ef0d4f3-b7ff-56e5-bb02-2e322b35b5ea', 'f6e33470-7abb-5335-a73d-78b0e219cee8', '047defe7-b4fd-5600-bd2e-9e7bcc19fed8', '7162a7a7-c5fd-5927-af4d-9488bfe1e3cf', '523b0bb4-d3de-57b1-8f46-7e3a63d136bd', '3101a2c3-1b50-5891-b32e-776dd412b7cb', 'ca1d08a6-635b-55d3-8b35-710f364cdb03', '7f8a91eb-bb59-53c7-9850-bbf3357c15b0', '13aa8436-6ff2-51cc-bd3d-e9e9451f29ba', '1bf254bf-2332-5712-9375-a6c92e54010a', '5edf3a85-ea24-5cf8-9672-d438936778a6', 'bfe3f614-0d0b-5dd0-b4ab-731fc5eead5c', '3b9f5e36-e17c-5737-958d-66c065e0b9dd', '34f08ce5-4e1c-597e-9f2d-aa2bd9e956dd', '9bdd30ec-5d17-54b4-8104-64acc96e6376', '400c97c7-0bf5-5c6b-8ca6-7e11a583a4d6', '8380f141-0ea0-5fd0-893b-b5e56efee5e7', '8c22abb2-f364-5907-891d-756634524d19', 'd10536c6-8f0e-5492-96d5-b3edcc0e7f6d', '7c5420fe-9426-5b0c-871a-5777e68d0e47', '3a674224-fd62-5640-8e9d-729266e93904', 'c7142227-4dfe-5894-a6e7-347d7543b942', '7b4585eb-a192-5e9b-bd35-857370832357', '1f6694d1-bebd-5b09-ac84-dbeac2137d5f', '07d15b15-1d40-5f3b-b7b9-4835258bd368', 'e2954a24-5f6f-5f15-a81f-91ead78d8aa9', '151ecd05-aefe-5871-8fc6-7cadf964e59e', 'e2a3b8bc-07f2-5187-a81f-0478fb4db0c1', 'e59ccad4-4632-5196-9205-6cfcfc1c2783', '956361a8-6b3b-5265-bdb2-7ca5e7fc156c', '9b9625b1-ada4-5440-8cb3-5847cd81e256', '001e05e8-64c3-5ad8-8235-f4f885e12954', 'b709063c-4c0e-580b-8569-47086e0f9ac1', '42c1ffae-75a8-5930-8d05-698315105a55', '404fb1f3-caff-5a39-85ae-83b4034c1c46', '18019a79-b782-5887-91ad-63d04a9e4870', 'cc49188e-de66-5ea7-99df-fa62aca65d64', '87dc255b-a218-5b43-91e7-ac457d9b8510', '9753e100-ea99-549a-90d8-9c6674e49d4c', 'a120aa6b-4d3b-56e9-80e0-5de88a16ae8e', 'c40a70b2-b5f5-5d85-966d-af30d1801799', '3544a9ce-9d2e-56c8-8b7c-b000d1d6ebb0', '66627e12-cbff-5280-8514-df937c7cdca8', '6324bc19-4a98-5a43-a42e-ae6096020082', 'd2e7d893-6723-5142-91aa-954b92f9da94', 'acd80643-b0be-56ba-8cbb-5ff95a4f2414', 'd1bf4746-e9c0-58de-b9c9-c0a6be34408a', 'bc4fa748-002c-5390-9d20-18820233b1a0', '2fba0b1f-fffd-539e-bfdf-e279042a0528', 'c6b351fb-a6dd-5f50-a0e4-0fe4d097a0cd', 'aadf873b-6b66-594f-b2ad-c613f7313e39', 'da3ce2cf-e8c4-50b5-a017-c938fa216837', 'b6c1bbc9-e560-5ae9-bf2f-8fefa8f8162a', '6ae40ba1-2a2d-5d11-9459-6cbd5767dab0', '60b3ab6d-6d17-59fd-adf1-59be9c35fd2b', 'c88e3248-5f44-567f-b854-173913a3e975', '085f80cf-2fa5-5ae7-b781-19fc32c85f34', '09caa4f7-470e-5757-818c-e7508348b93f', 'fb506cec-30e1-5f7d-a8cd-cb04dd6de3d4', '0ec9d729-5ca1-5af7-b6ae-55ad088605ca', 'a5d6f58b-0d82-521d-87a6-e5c1e05c81b4', '16c019c7-b285-5aa7-9fb7-8e72b039fded', '9eaadc92-cce9-5fa0-8a1f-894bea90cba1', '24c99171-9685-5499-bb7c-61b2c87bcb7b', 'f0da5a4f-4b6f-5551-84c6-d24a2dd46950', 'b7502615-ef59-5ed5-a12b-f8c657979c52', '248e0d61-1c85-56c2-8fc8-ea1bc3ef143d', '4ce97f26-9078-55f8-b615-8bdb7f3e9430', 'f146f416-0b42-5172-b080-0dfbc82802b9', 'f627b0e7-43b7-507f-bb77-8c3168658819', '997de3c8-5927-5368-9b3c-f07a7ceec955', 'ccb008c5-3f3b-5422-922d-ed1b85c47ddf', '6352531f-9cee-51ba-92e9-9017d0d25f6c', '93d04bab-c8bd-5344-82ab-19b8af8345e0', 'd24cec10-326f-507b-bbab-8101c228fa0a', '29a58ebe-625c-50d9-a294-40d15561dc2e', '3d7bd806-d741-551f-ba56-d36ba4d7d4ed', '134a00f2-db5e-50bb-94cc-4acdbb84f8e7', '1db0a74c-38fd-57bd-8b3f-772609894cf1', 'c1a1d038-bf1d-5875-a9af-3c55b16a02d0', 'a24bd812-a457-5005-9702-ba2090e91f0b', '22dec132-6567-553b-93e0-7fa7f450b98d', '16cc4a7f-0317-557e-b492-85d4a047b122', '7e4d992b-79f8-56a3-8a15-04e4104a4cf6', '151fe381-8eac-5375-8d38-87d0be574832', 'abe83c50-3f20-5678-8cd1-fc6caefc8918', 'b734973b-bc9f-5a14-bfae-dfedfc01fc2d', '54b24891-d0ed-5032-812b-4450c320eede', '5383f455-cf9c-5277-902a-23b32f5e1296', '61bedf70-2703-50e1-959d-a5e7e7662dd8', '470e3303-0404-5ba3-b472-d249b66ff4b0', '5971b9e5-16eb-5915-a9e8-835d20a9f887', '51ca0f68-1eef-5e47-9dd6-989e0bc862d6', '70185331-1bd6-5b97-924d-cce7bbe18999', '6ec2073f-9c0b-52e9-9c2f-4fc5bb112705', '5f991490-0dc5-5416-a839-b63e6ada8cbb', '2b50805c-8c7e-5cf7-8f78-add08e1ea23a', 'a832e9b3-30bc-5cd2-9d19-7cf19380dc27', 'ed59ed4c-e1be-517e-a524-a7529dc6608a', '84d12636-60a6-5040-8f26-13e771600961', 'f74c7c4a-4a58-52c3-892e-234e19dc9e1f', 'c7c00be1-8109-5765-bc35-2c5c9061eade', '1323ae50-875d-55b3-94ce-0c3fffc01f3b', '8346a598-f714-52bb-8f3e-296ff94de58d', 'c8e14439-93af-5963-b468-3c90fe16cd96', '786a2c2f-e339-5257-ada4-72812c361be5', '7587a156-8ec0-56ec-97e0-43df9b2ead0f', 'f3f22dc9-1559-5883-a2ce-01b300f351ab', '70ce1fba-43b3-5a6f-977e-a3423d732049', 'd030d5d7-2343-51c4-99a8-9329219e926a', '45567b28-139c-552b-8e7f-466cf6693fa7', '120cf297-1936-56c3-a07c-cb11be317659', '22934687-9389-5bda-b9ec-3ce23636d507', 'f8f4ee7e-bbc9-58ee-9ef9-c413a85a2b8e', '7ae15ce6-6f99-56f4-a272-dc94f0f0cd85', 'edbed3e1-1a8b-5389-9395-ac872c0c8904', 'cd3b6cbf-37d5-5337-a3dd-4a7425924990', '47012b74-ccdf-54a0-bb2b-92e28bce1754', '01350a60-2e06-5e93-80de-24e3d2e5088a', 'b4db483a-5c89-56b8-8fb4-154c817c6249', 'c6af5d7c-9055-5b27-83d6-538e512920ed', '52771464-332d-5906-a3ef-38286fbec422', 'd2d335e2-1717-5a26-b70f-44f49be8488b', 'e23d71e4-cc66-56df-80c0-6b404345eb3a', 'a6a22b3a-69ab-5abc-95de-8b6e4835508f', '7e9ea785-661e-561f-8693-9536349192de', 'd8ad6c3f-36b2-5f0e-bc17-81e6894040aa', '6bfdea48-2eea-57e2-8179-b56f19ead567', 'f1236959-0064-5198-bec3-5b2c17ac6ef1', 'a901c09d-2d89-5c92-ad16-c941677cb845', 'a79e332a-e11c-5161-9074-2643a0907c84', '21d78123-2891-55db-9d43-29aa2b149d92', 'aa59cbfc-d6e3-5322-aaae-ee0e8f256e38', 'a5c5aa2a-2cb7-512c-96a0-683bbb52616d', '20d649b0-9e70-5215-992c-7050b20cd0ff', '2da37f96-7fee-5e3c-8bc9-5633e22cda48', 'cd6f9a83-1bc0-58ef-be01-cddc274b9df5', '1ed71c15-0b2e-547e-8a25-805430f5f942', '64b24877-8b08-58bc-8c2a-f8b5b3673d6f', 'e6d652e1-c276-5793-af70-67f262708323', '30628f8e-8e19-5ddc-9936-74f62bb066d2', '0b1fb3a7-ed20-598a-90e7-c9548403dfa3', '3389ff92-a7cc-5452-ad9c-28a78f9322f1', '52643f8b-930e-57e5-8671-6659fc8e757f', '415bf82f-6a5b-5e30-9817-f49efcd5b579', '08881516-dedc-5a79-b61e-96949394b1d4', 'f3773714-d38b-5cd6-bdad-ca23c2bce4d2', '2638a256-7a73-554f-8de1-f116a6c855f9', '784ed6cb-c659-5a09-ab83-df40e865082f', 'c5287d78-d360-530a-8d98-36869ae18cdf', '1d270559-2a4f-5694-bdb7-c68f0913d6b4', 'afbefc78-f752-5b91-b138-f064b6af59ca', 'e006f484-48cc-5acc-8617-075b1d26fdae', '3d55aef0-7d96-5b2a-9a5e-5e96a919b8fa', '4af96bd5-ab9e-5ee9-8bad-dfb27cfed972', '77643e23-4c93-5650-bc86-e73cbdcd3e7a', '9232522b-7078-571b-8cb8-643fd215b4dc', '9a310bfd-a9ae-580b-8ac0-2ddb7ce40902', 'fcc4dbe9-6c57-5fa7-9362-373908ddbec5', '9d287125-890d-516b-a2ad-d85ce5fa2b0d', '865d8454-6ece-565c-8846-70857fb82128', 'ee1b4883-7904-5baa-8748-f1aaadb0b824', '99f58de0-027a-51e5-b92e-939da182fc39', 'db1e4933-3d88-5725-9dab-c8922275af33', '6e4411f0-9a83-5a97-8ab9-01208968bc38', '07572ad5-ad8c-5ee2-9550-a0bf27d212d1', '7e62fca4-a1e9-58b3-abf2-1a5d4305fa1a', '7b136959-fb8d-545e-b7fe-eff9bb34ac10', 'b9473b71-8a2a-58d9-aead-06b23cc186ea', '3e80d806-564d-5146-b539-64a7d7739b53', 'aa7ae8d6-380f-5447-9e4d-6754e8044632', 'e9cc4661-b029-509e-b4ab-eca2bdf40c98', '04315d18-1657-5a51-9e55-e1362e87d2cd', '2d5bda67-9e88-548b-bd23-7e9bea185d0b', '44f9cc92-9589-5a79-94a3-fdfb0b22a26c', '85b82a83-ddbe-5c22-a2eb-e37302529ba2', 'a3b8556c-1afc-58ca-821e-61e783e7e722', '54a36307-c054-5302-9287-87331f79c3b1', 'd9ce0a4a-7f6f-50b0-831a-057f4ee4f8df', '3ef0f19e-eb4f-578a-bb25-b1e10252b1de', '8c80ae98-2eeb-5de0-adb0-7947387e778d', '9f060f94-ac60-50cd-b9e7-0e8a7d4a329e', 'b0692dc0-d797-5c60-a684-d6a86b560677', '565d0a86-2e44-5be6-aefe-9862d01fc948', '0a44597c-16be-53b5-b2c5-212b30968816', '9d089130-178b-55ee-8700-10fb84cfb355', '67aebe48-c514-5a7b-98bf-4094fcbb86d1', '9fe8e35a-ee1f-5a49-8bde-a4d9af5dbba4', '7c158fee-4ae0-596f-9361-0290adddb50b', 'a4d78067-3d7c-5f5e-89b3-a66fe2326412', '7346ae17-2c83-519d-b076-21c1ba7c2f95', 'f43313bc-1667-59c7-ad1b-55679567310d', '2977c18d-55b9-5fe6-a54c-9d23b1599ed0', '4764222d-636d-5e6e-8a14-a21cb818db86', 'd8059ccf-8da0-5641-a425-eb0b5092f0ac', '61850603-bb56-5e49-922f-bba1a3d355bf', 'a4927644-04e4-5a09-8235-b0b52ed2eac5', '76153d40-aa93-5ffa-b1be-b1bb2a0ba15f', 'b0a7e45b-1fc7-53e8-83df-904e61f02855', '57917e57-b39f-5d30-806b-ce7e2184e8ab', '205334da-290f-5a07-899d-23c714b0bdf1', 'ae079820-81d7-5f94-9357-be1256ef0c1a', '6ed90f9a-3677-5b0e-94f0-4db4ef3d7b86', 'a6ca1a9b-a820-5564-bc19-e5bd938d43af', '008049cc-6554-57b6-bddb-e5ef448c5bad', '7ab5b4df-6ec1-58bd-87cd-43cbac63a0b2', 'b10a3e40-ce94-502f-96c7-a2af13a7cf74', '56b56d19-2bf0-5ebf-a60b-704ff949adf5', '046d1ef9-8fa2-50fe-83e9-24a79e6f8249', '93348d94-5fe6-555c-8269-24619e89d885', '23bddb7e-23ce-5a55-8863-f5e7980c0cb8', '7f2cc5a5-749e-561d-9f35-e1f350fb4a46', '48367e32-6ea3-592d-b126-48f69758a887', '13abda19-d837-571f-b9c2-7478c8d38210', 'bba8fa81-5367-5695-9f51-9a1a2e139005', '4ac3a47e-e38e-5c65-bfb5-bd397d055eb0', 'ffe4265b-3c2f-5e12-b4b5-baeaae5fbc71', 'bfcda988-b968-52a7-a7be-530a7869764d', '8444d19d-da5b-5520-9097-793bde377aa9', '84732b4d-051d-5a79-aaa9-2526c562cca0', '66faee3c-480f-5b3d-ad03-313450712f1e', 'b7c8ef01-8d0d-559d-ab8a-1d235f3f6fa1', 'c24e3b47-ac15-5973-ab7f-1ab366f34c1b', 'e9ea2ac2-5973-524c-99c4-06771142f51a', '24504a83-60ca-5218-806b-1bc27dc0b183', 'f0b81e5e-4edd-5807-bb84-c60549789a32', 'f3fcc05c-7896-563d-b805-580aba5034aa', '56a09018-7897-5767-a779-ceda5fbb6a30', '9bccab64-a551-539e-80f0-cbd11ff989f8', '72fd6e87-502c-53b0-a308-dbf147d75e6c', '77ff7fc0-a439-5014-a113-696b14809891', 'ab489d97-bf33-5bf2-8cef-d664dc1c5bb1', 'd524b1f0-1f39-57f0-afc2-1d10cfcaef3f', '3a4b26d7-b9e8-5f97-bc5c-bad2ade7129c', '562c1ed8-e533-5947-bf17-efd713254271', 'cc3b8ba4-a015-537a-aa6e-2cbb7f3e3947', 'f34aa50a-a578-53e8-af0d-7eae23a089f0', 'fc898a65-4542-567d-a336-05d0bd7f2ec3', '575ec66c-04a9-5a3c-b07c-aec21f799739', '18711ef7-9a3f-5a40-9736-ac9b7c20065e', '459ecd0a-2c00-54b1-90fa-094fe0353e7d', 'bb8e37ad-c672-5f41-9d69-25495c80ee0b', '1d748656-87fd-5431-9f53-2b2f46c83a8d', 'c0e0329c-1704-56bd-be4f-7adf1f3b8c8c', '08f8dcbc-ade2-5c7e-96db-972751634399', '91a9bb65-3c2c-5104-b073-298491678a25', '1991fb16-e5f8-5cb8-8a0d-8152178c97f0', 'e509388a-ea68-5363-875f-afa35141e5ee', '74d03538-ff33-5658-9d19-d6b6aaa06fa6', '87472389-8add-5f27-9edb-6f79db5a0285', 'b24843a0-4d87-57ba-8db9-a8632abd4bda', 'bea120a0-87f0-59e1-9a73-add85990bf7d', '5e05aa30-ae66-57b8-abd8-829a04c834aa', '4f80682c-70b6-5f79-aeb5-7748614da7fb', 'b922afd6-082e-5614-ac01-c40279ec3b0c', 'a474b912-03f4-589c-b807-1ea8259978c3', '29b154b4-51fd-54ea-9034-6840755142c6', 'a19f9f04-6b38-5e33-a068-e55ae61ad037', 'de1eaf37-3d93-54c7-8e63-d4456ea44b7e', 'd369fc63-c92a-5242-96de-82f6e66ed22b', '123dbdc5-ef70-5b16-88e5-e7f807da07f6', '7bdfc822-c2e9-5995-a3b3-82004304b8e6', '1a8339db-0aa0-5eb5-890d-ee0562728a81', '289198e5-0cf2-5e54-8082-a54e89462f3a', 'bd3eeecb-52c8-5c15-a12a-7d1c817e2d0e', '8c442412-454c-5365-9a3c-2eef77a683a2', '33362f40-ce71-5723-8cf4-25f9443c52ac', '954691c1-e42a-51c9-a7db-3762054bfbe9', '312adbc5-adcf-56c5-bb33-64365ad5210a', 'ba03e2b2-7968-5c8b-839f-9823f6334ff6', 'e5f92f25-7750-5b3e-8142-92faee8ba1c9', '7ee6126d-6094-55ed-9ff7-6e911928d3a4', '06d8a32c-e828-5f2c-b46a-026559aef4c0', '0ca77c5d-c728-53c7-809f-42a4427d6feb', '0ae38c65-f573-5ad6-bf05-87c8c17878ea', 'd2f6278d-52a4-5c65-bfbb-f654336d3ecc', '2c7edf82-7e2e-56e1-94a1-12426b3b9f84', '2377cbd5-bff7-5235-9390-3704e6dd1fc6', '99a1a2e0-d2bd-50bd-beb1-d9d7c92f4bba', 'f8012e9c-6012-59d6-a560-1cd44b17e237', 'e1133193-cb38-56cc-9e70-7774ccd026d7', 'e9aa73b5-135c-52ec-a127-109803918386', 'c073a421-6402-55f6-a9c9-44a36b6c3d7e', 'b63ffb16-7255-5860-90d9-3654fed26497', '3f63cfd7-0ca6-5247-9d39-2d0255ea9c07', 'ae8c9d65-324a-5663-b4e8-d3cb4ba2e6ed', 'd3932e53-38a3-5799-9f96-2b7216a5f674', 'dcdd5215-44df-5521-85c6-3ba5d3754e76', '0b04f474-6726-5400-b0cb-3da76b853295', '2e9cc57a-04da-578b-a338-0c53bfde8359', 'cb8e1ae8-dfde-59de-b65f-0f191f1813ad', '801e2312-1507-596e-90f1-105400f73102', '75c2aeac-7dcf-56cc-9e9e-0c47d52d19f4', '0bbcf1a0-b884-5fc0-ab2d-6f9b64d87a87', '09d329b9-b63e-5a45-a8b7-37088da036bd', '3dcdcdf3-16f1-57fd-ab9b-b84f33f40878', 'acd2fea3-f55b-5425-9026-9d8bc652771b', 'e3946442-e297-534c-8e35-52ff5b67ce37', '31923788-ebac-5918-9b47-b7c4ca2155ff', 'd86fba62-e9b3-566d-adbb-10f2a4cb890c', '587cace2-68b6-55af-a771-c1a88fe28940', 'aac635e5-2cb1-5699-815a-033483ca8994', '6a0837d0-8efe-592a-a485-deb053ec5214', '5597dd0f-d091-5671-b3d3-419ee49fd41e', '1a70fcc4-c2e1-5acd-9dc7-346471fcc39d', 'ff7c6a8b-ac83-506c-a28b-6d8ecdd9f3fd', '2bcf9aec-2028-57aa-b1a7-cab09161650d', '51bace8d-d282-5302-9f74-2eb296d4149a', '2eb3f8a4-60cf-5fa3-a968-17df1f5e3e53', '56d4067d-bd5c-5d9e-949b-880142a35d1b', 'a9abe733-3e57-5b23-9e2a-93b8e74f8cba', '39c468ad-76af-590c-9839-22b43d359a4c', 'dd87e424-0eef-5376-b22d-2370aa9326b9', '628d5548-757c-5ebe-9bbf-3053aa444c09', '0612e33d-f880-507f-9e68-6f41d877ddc7', '4f8c4f26-5edf-5ffd-b67b-c9cc16460133', '1a46cff3-86b2-58ea-9a0f-0ff6f22ddd96', 'b42faa9f-4122-5179-92a5-94dfd2d3d376', '62ecf6ea-b89b-5151-b2c6-9c79d27b9e09', 'e00c008c-11c3-553a-b14b-98e856216451', '456ebe4f-f145-5181-b1dc-244568ccbaff', 'f3711687-7fd5-55e0-9c1e-97805daf780e', 'a42e1ffa-465d-54f9-847e-63e53bd014a6', 'f6b7db09-97c2-5579-bd96-550fc3e60967', '683f997a-99b0-5dfb-9d69-249e1783a94e');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-2eme' AND c.id NOT IN ('26822027-6ba8-5c53-8b8e-6dc554defe00', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'f8199513-467c-5afa-b4d8-93b694d592cd', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', '9b2889f8-906e-5629-b28d-da2c10b832fa', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', '80c7631d-4f76-5d61-a536-953b1f7a51e9') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', 'الحيوانات الأليفة والبرّية', 'نتعرّف الحيوانات الأليفة التي يربّيها الإنسان والحيوانات البرّية التي تعيش حرّة، وأماكن عيشها، ومنافع تربيتها، ونصنّفها إلى أليفة وبرّية.', '# ⚔️ الحيوانات الأليفة والبرّية — صديقي أم حُرٌّ في الغابة؟

> 💡 «القطّ ينام في البيت، والأسد يعيش في الغابة… كلّ حيوانٍ له مكان!»

حولنا حيواناتٌ كثيرة. بعضها يعيش **قُربنا** ونعتني به، وبعضها يعيش **بعيدًا** حُرًّا. هيّا نتعرّف عليها.

## 🐄 الحيوانات الأليفة

**الحيوان الأليف** يربّيه الإنسان ويعتني به. يعطيه **الأكل** و**الماء** و**المأوى**.

يعيش قُرب الإنسان: في البيت، أو في الحظيرة، أو في المزرعة. مثل: **القطّ**، و**الكلب**، و**الدجاجة**، و**البقرة**، و**الخروف**.

انظر: البقرة حيوانٌ أليف يربّيه الفلّاح.

<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="62" cy="52" rx="34" ry="20" fill="#fcd34d"/>
    <circle cx="98" cy="44" r="13" fill="#fcd34d"/>
    <ellipse cx="100" cy="48" rx="6" ry="4" fill="#fb7185"/>
    <path d="M90 34 q-3 -9 3 -10 M106 34 q3 -9 -3 -10" fill="#a16207"/>
    <path d="M40 70 l0 14 M54 72 l0 14 M72 72 l0 14 M86 70 l0 14"/>
    <ellipse cx="50" cy="46" rx="7" ry="9" fill="#f3f4f6"/>
    <ellipse cx="70" cy="56" rx="9" ry="7" fill="#f3f4f6"/>
    <circle cx="95" cy="40" r="2" fill="#1f2937" stroke="none"/>
  </g>
</svg>

*مثال: الدجاجة حيوانٌ أليف، تعيش في القنّ وتعطينا البيض.*

## 🦁 الحيوانات البرّية

**الحيوان البرّي** يعيش **حُرًّا** في الطبيعة. لا يربّيه الإنسان. يبحث بنفسه عن أكله وعن مأواه.

يعيش بعيدًا عن البيت: في **الغابة**، أو في **الصحراء**، أو في **الجبل**. مثل: **الأسد**، و**الفيل**، و**الغزال**، و**الأرنب البرّي**، و**الثعلب**.

انظر: الأسد حيوانٌ برّي يعيش في الغابة.

<svg viewBox="0 0 120 95" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="60" cy="48" r="22" fill="#b45309"/>
    <circle cx="60" cy="48" r="14" fill="#f59e0b"/>
    <path d="M60 26 v-6 M44 32 l-4 -5 M76 32 l4 -5 M38 48 h-6 M82 48 h6 M44 64 l-4 5 M76 64 l4 5 M60 70 v6" stroke="#92400e"/>
    <circle cx="53" cy="45" r="2.5" fill="#1f2937" stroke="none"/>
    <circle cx="67" cy="45" r="2.5" fill="#1f2937" stroke="none"/>
    <path d="M55 54 q5 4 10 0" fill="none"/>
    <circle cx="60" cy="52" r="2" fill="#1f2937" stroke="none"/>
  </g>
</svg>

*مثال: الغزال حيوانٌ برّي، يجري بسرعةٍ في البَرّ ولا يربّيه أحد.*

## 🏡 أين يعيش كلّ حيوان؟

ننظر إلى **مكان عيش** الحيوان لنعرف نوعه:

| الحيوان | أين يعيش؟ | النوع |
| --- | --- | --- |
| الكلب | قُرب البيت | أليف |
| البقرة | في المزرعة | أليف |
| الأسد | في الغابة | برّي |
| الغزال | في البَرّ | برّي |

## 🥚 منافع الحيوانات الأليفة

الحيوانات الأليفة **تنفعنا** كثيرًا:

- **البقرة** تعطينا **الحليب**.
- **الدجاجة** تعطينا **البيض**.
- **الخروف** يعطينا **الصوف**.
- **الكلب** يحرس البيت.

> 🗡️ حِيلة سريعة: اسأل نفسك: «هل **يربّيه الإنسان** ويعتني به؟» نعم ← أليف. لا، يعيش حُرًّا في الطبيعة ← برّي.

> ⚠️ الفخّ الشائع: لا تخلط! الأرنب الذي **نربّيه** في البيت أليف، أمّا الأرنب الذي يعيش **حُرًّا** في الغابة فهو برّي. المهمّ: هل يعتني به الإنسان أم لا.

> 🏆 أحسنت! صرتَ تعرف الفرق بين الحيوان الأليف والحيوان البرّي، وأين يعيش كلٌّ منهما، وماذا تعطينا الحيوانات الأليفة. في الفصل القادم نكتشف النباتات!', '# 📜 ملخّص: الحيوانات الأليفة والبرّية

- **الحيوان الأليف:** يربّيه الإنسان ويعتني به (أكل وماء ومأوى)، ويعيش قُربه، مثل القطّ والبقرة والدجاجة.
- **الحيوان البرّي:** يعيش حُرًّا في الطبيعة ولا يربّيه أحد، مثل الأسد والغزال والفيل.
- **مكان العيش:** الأليف قُرب البيت أو في المزرعة؛ البرّي في الغابة أو الصحراء أو الجبل.
- **منافع الأليفة:** البقرة تعطي الحليب، والدجاجة البيض، والخروف الصوف، والكلب يحرس.
- **القاعدة:** نسأل: هل يربّيه الإنسان؟ نعم ← أليف، لا ← برّي.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', 'النباتات المغروسة والتلقائية', 'نُميّز النباتات التي يغرسها الإنسان ويعتني بها من النباتات التلقائية التي تنبت وحدها في الطبيعة، ونتعرّف أماكنها.', '# ⚔️ النباتات المغروسة والتلقائية — مَن غرسها؟

> 💡 «الوردة في الحديقة غرسها الإنسان، والعُشب على الطريق نبت وحده… كلّ نبتةٍ لها حكاية!»

حولنا نباتاتٌ كثيرة. بعضها **يغرسه الإنسان** ويعتني به، وبعضها **ينبت وحده** في الطبيعة. هيّا نتعلّم الفرق.

## 🌱 النباتات المغروسة

**النبتة المغروسة** يغرسها الإنسان ويعتني بها. يسقيها **الماء**، ويُزيل عنها الأعشاب، ويحرسها.

تنمو حيث يضعها الإنسان: في **الحديقة**، أو في **الحقل**، أو في **الأصيص** (القَصرِيّة). مثل: **القمح**، و**الطماطم**، و**الوردة المغروسة**، و**أشجار الفواكه**.

انظر: نبتةٌ مغروسة في أصيص، يسقيها الإنسان بالماء.

<svg viewBox="0 0 130 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <path d="M40 64 h44 l-7 28 h-30 z" fill="#b45309"/>
    <rect x="36" y="58" width="52" height="8" rx="2" fill="#a16207"/>
    <path d="M62 58 v-22" stroke="#16a34a" stroke-width="3"/>
    <path d="M62 46 q-16 -4 -20 -16 q14 0 20 12 z" fill="#22c55e"/>
    <path d="M62 40 q16 -4 20 -16 q-14 0 -20 12 z" fill="#22c55e"/>
    <circle cx="62" cy="30" r="7" fill="#ef4444"/>
    <path d="M104 24 l-6 12 M110 30 l-9 9 M100 20 l-3 13" stroke="#3b82f6" stroke-width="2"/>
  </g>
</svg>

*مثال: الطماطم نبتةٌ مغروسة، يزرعها الفلّاح في الحقل ويسقيها.*

## 🌾 أين يغرس الإنسان النباتات؟

الإنسان يغرس نباتاته في أماكن يعتني بها:

في **الحقل** يزرع القمح والخضر. في **الحديقة** يغرس الورد وأشجار الفواكه. في **الأصيص** قُرب البيت يضع نبتةً صغيرة.

انظر: حقل قمحٍ غرسه الفلّاح في صفوفٍ منظّمة.

<svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="8" y="78" width="134" height="14" fill="#a16207"/>
    <path d="M28 78 v-44 M58 78 v-50 M88 78 v-50 M118 78 v-44" stroke="#16a34a" stroke-width="3"/>
    <ellipse cx="28" cy="30" rx="7" ry="12" fill="#fcd34d"/>
    <ellipse cx="58" cy="24" rx="7" ry="13" fill="#f59e0b"/>
    <ellipse cx="88" cy="24" rx="7" ry="13" fill="#f59e0b"/>
    <ellipse cx="118" cy="30" rx="7" ry="12" fill="#fcd34d"/>
    <path d="M24 36 l4 -4 l4 4 M54 30 l4 -4 l4 4 M84 30 l4 -4 l4 4 M114 36 l4 -4 l4 4" stroke="#f59e0b" fill="none"/>
  </g>
</svg>

*مثال: حقل القمح يغرسه الفلّاح ويعتني به حتّى ينضج.*

## 🌿 النباتات التلقائية

**النبتة التلقائية** تنبت **وحدها** في الطبيعة. لا يغرسها الإنسان، ولا يعتني بها أحد.

تنمو حيث تجد الماء والتربة: في **الحقول**، وفي **الغابة**، وعلى **جوانب الطرقات**. مثل: **العُشب البرّي**، و**زهور الأقحوان البرّية**، و**الأشواك**.

انظر: عُشبٌ تلقائي نبت وحده على جانب الطريق.

<svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="6" y="80" width="138" height="14" fill="#9ca3af"/>
    <path d="M6 87 h28 M52 87 h26 M96 87 h26" stroke="#fcd34d" stroke-width="2" stroke-dasharray="8 7"/>
    <path d="M126 80 q-6 -22 2 -34 q4 14 -2 34 z" fill="#22c55e"/>
    <path d="M132 80 q8 -18 18 -22 q-6 14 -18 22 z" fill="#16a34a"/>
    <path d="M120 80 q-10 -14 -18 -16 q8 10 18 16 z" fill="#16a34a"/>
    <circle cx="134" cy="40" r="5" fill="#fb7185"/>
  </g>
</svg>

*مثال: الأعشاب على جوانب الطرقات تلقائية، نبتت وحدها دون أن يغرسها أحد.*

## 🔍 كيف نُميّزها؟

ننظر: **هل غرسها الإنسان واعتنى بها؟**

| النبتة | مَن غرسها؟ | النوع |
| --- | --- | --- |
| القمح | الفلّاح | مغروسة |
| الوردة في الحديقة | الإنسان | مغروسة |
| العُشب على الطريق | لا أحد | تلقائية |
| الأشواك في الغابة | لا أحد | تلقائية |

<svg viewBox="0 0 160 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="6" y="60" width="64" height="18" fill="#b45309"/>
    <path d="M38 60 v-18" stroke="#16a34a" stroke-width="3"/>
    <circle cx="38" cy="36" r="8" fill="#ef4444"/>
    <text x="38" y="86" font-size="11" fill="#1f2937" stroke="none" text-anchor="middle">مغروسة</text>
    <rect x="92" y="64" width="62" height="14" fill="#9ca3af"/>
    <path d="M120 64 q-5 -18 2 -28 q4 12 -2 28 z" fill="#22c55e"/>
    <path d="M126 64 q7 -14 15 -18 q-5 12 -15 18 z" fill="#16a34a"/>
    <text x="123" y="86" font-size="11" fill="#1f2937" stroke="none" text-anchor="middle">تلقائية</text>
  </g>
</svg>

> 🗡️ حِيلة سريعة: اسأل نفسك: «هل **غرسها الإنسان** واعتنى بها؟» نعم ← مغروسة. لا، نبتت وحدها ← تلقائية.

> ⚠️ الفخّ الشائع: لا تخلط! الوردة في **حديقة البيت** مغروسة لأنّ الإنسان غرسها، أمّا الزهرة نفسها لو نبتت **وحدها** على الطريق فهي تلقائية. المهمّ: هل غرسها الإنسان أم نبتت وحدها.

> 🏆 أحسنت! صرتَ تُميّز النبتة المغروسة من النبتة التلقائية، وتعرف أين يغرس الإنسان نباتاته وأين تنبت التلقائية وحدها. في الفصل القادم نكتشف جسم الإنسان!', '# 📜 ملخّص: النباتات المغروسة والتلقائية

- **النبتة المغروسة:** يغرسها الإنسان ويعتني بها (يسقيها ويحرسها)، مثل القمح والطماطم والوردة المغروسة وأشجار الفواكه.
- **أماكن الغرس:** يغرس الإنسان نباتاته في الحقل والحديقة والأصيص قُرب البيت.
- **النبتة التلقائية:** تنبت وحدها في الطبيعة دون أن يغرسها أحد، في الحقول والغابة وعلى جوانب الطرقات.
- **كيف نُميّزها:** ننظر هل غرسها الإنسان واعتنى بها (مغروسة) أم نبتت وحدها (تلقائية).
- **القاعدة:** نسأل: هل غرسها الإنسان؟ نعم ← مغروسة، لا ← تلقائية.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', 'جسم الإنسان', 'نتعرّف الأجزاء الرئيسية لجسم الإنسان (الرأس والجذع والأطراف)، ودور المفاصل في الحركة، وكيف نحافظ على سلامة الجسم ونتوقّى الحوادث.', '# ⚔️ جسم الإنسان — قلعتي التي أحميها

> 💡 «رأسٌ وجذعٌ وأطراف… ومفاصلُ تُحرّكني، وأنا أحميها من الأذى!»

جسمي مثلُ قلعةٍ قويّة. له أجزاءٌ تعملُ معًا. هيّا نتعرّف عليها ونحافظُ عليها.

## 🧍 الأجزاء الرئيسية لجسمي

جسمُ الإنسان له **ثلاثة أجزاء رئيسية**:

- **الرأس**: في الأعلى، فيه الوجه.
- **الجذع**: الجزءُ الأوسط الكبير. يربطُ الرأس بالأطراف.
- **الأطراف**: الذراعان والساقان.

انظر: الدائرةُ البرتقاليّة حول **الرأس** في الأعلى.

<svg viewBox="0 0 110 150" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="55" cy="30" r="26" fill="none" stroke="#f59e0b" stroke-width="3"/>
    <circle cx="55" cy="32" r="15" fill="#fcd34d"/>
    <circle cx="50" cy="30" r="2" fill="#1f2937" stroke="none"/>
    <circle cx="60" cy="30" r="2" fill="#1f2937" stroke="none"/>
    <path d="M50 38 q5 4 10 0" fill="none"/>
    <rect x="40" y="52" width="30" height="44" rx="8" fill="#3b82f6"/>
    <path d="M40 60 l-16 22 M70 60 l16 22" fill="none"/>
    <path d="M50 96 l-6 40 M60 96 l6 40" fill="none"/>
  </g>
</svg>

## 💪 الأطراف العلوية والسفلية

للأطراف نوعان:

- **الأطراف العلوية**: في الأعلى، وهي **الذراعان واليدان**. بهما نكتبُ ونحملُ ونلعب.
- **الأطراف السفلية**: في الأسفل، وهي **الساقان والقدمان**. بهما نمشي ونجري ونقفز.

انظر: الذراعان (أعلى) والساقان (أسفل).

<svg viewBox="0 0 130 150" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="65" cy="26" r="14" fill="#fcd34d"/>
    <rect x="50" y="40" width="30" height="42" rx="8" fill="#ef4444"/>
    <path d="M50 48 l-26 14 M80 48 l26 14" fill="none" stroke="#fdba74" stroke-width="6"/>
    <circle cx="22" cy="64" r="4" fill="#fcd34d"/>
    <circle cx="108" cy="64" r="4" fill="#fcd34d"/>
    <path d="M56 82 l-8 44 M74 82 l8 44" fill="none" stroke="#3b82f6" stroke-width="7"/>
    <ellipse cx="46" cy="130" rx="8" ry="4" fill="#1f2937"/>
    <ellipse cx="84" cy="130" rx="8" ry="4" fill="#1f2937"/>
  </g>
</svg>

## 🦴 المفاصل تُحرّكني

**المفصل** هو مكانُ التقاءِ عظمتين. يربطُ أجزاء الجسم و**يسمحُ بالحركة**.

بفضلِ المفاصل **نثني** ذراعنا وساقنا ونُحرّكها. من المفاصل: **الركبة** و**المرفق (الكوع)** و**الكتف** و**الرقبة**.

انظر: ذراعٌ مثنيّةٌ عند **المرفق** (الدائرة البرتقاليّة هي المفصل).

<svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="3">
    <path d="M20 95 L70 60" fill="none" stroke="#fdba74" stroke-width="12" stroke-linecap="round"/>
    <path d="M70 60 L120 90" fill="none" stroke="#fdba74" stroke-width="12" stroke-linecap="round"/>
    <circle cx="70" cy="60" r="13" fill="#f59e0b"/>
    <path d="M58 30 q12 -6 24 0" fill="none" stroke="#22c55e" stroke-width="3"/>
    <path d="M76 26 l8 4 l-8 4" fill="none" stroke="#22c55e" stroke-width="3"/>
  </g>
</svg>

> 🗡️ حِيلة سريعة: عند كلِّ مكانٍ **ينثني فيه جسمُك** يوجدُ **مفصل**! جرّب: اثنِ ركبتك… هذا مفصل!

## 🛡️ أحافظُ على سلامة جسمي

جسمي ثمين. عليّ أن أحميَه من **الحوادث**: السقوط، الجروح، الحروق.

كيف أتوقّى؟

- لا أجري قرب **الدرج** أو على البلاط المبلّل (خطرُ السقوط).
- لا ألمسُ النار ولا الماء الساخن (خطرُ الحروق).
- ألبسُ **الخوذة** عند ركوب الدرّاجة.
- إن أُصبتُ بجرحٍ، أُخبرُ الكبير لينظّفه ويضمّده.

انظر: طفلٌ يلبسُ الخوذة لحمايةِ رأسه.

<svg viewBox="0 0 110 130" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="55" cy="40" r="18" fill="#fcd34d"/>
    <path d="M37 38 a18 18 0 0 1 36 0 z" fill="#ef4444"/>
    <line x1="55" y1="22" x2="55" y2="32" stroke="#1f2937"/>
    <circle cx="50" cy="42" r="2" fill="#1f2937" stroke="none"/>
    <circle cx="60" cy="42" r="2" fill="#1f2937" stroke="none"/>
    <path d="M49 50 q6 5 12 0" fill="none"/>
    <rect x="42" y="58" width="26" height="36" rx="7" fill="#3b82f6"/>
    <path d="M50 94 l-5 30 M60 94 l5 30" fill="none"/>
  </g>
</svg>

> ⚠️ احذر: الجريُ بقربِ الدرج أو لمسُ المكواة الساخنة يسبّبُ حادثًا مؤلمًا. الوقايةُ خيرٌ من العلاج!

> 🏆 أحسنت أيّها البطل! عرفتَ أجزاء جسمك (رأس، جذع، أطراف)، ودور المفاصل في الحركة، وكيف تحافظ على سلامتك. في الفصل القادم نكتشفُ كيف يتغذّى جسمُك ليبقى قويًّا!', '# 📜 ملخّص: جسم الإنسان

- **الأجزاء الرئيسية:** لجسم الإنسان ثلاثة أجزاء: **الرأس** (في الأعلى)، و**الجذع** (الجزء الأوسط)، و**الأطراف**.
- **الأطراف العلوية والسفلية:** العلوية هي **الذراعان واليدان** (للحمل والكتابة)، والسفلية هي **الساقان والقدمان** (للمشي والجري).
- **المفاصل:** **المفصل** يربط العظام ويسمح بالحركة (الثني)، مثل الركبة والمرفق والكتف والرقبة.
- **سلامة الجسم:** نتوقّى الحوادث (السقوط والجروح والحروق) بالحذر من الدرج والنار، ولبس الخوذة، وإخبار الكبير عند الإصابة.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', 'التغذية', 'نتعرّف وجبات اليوم ومواعيدها، ومكوّنات الوجبة ومصادر الأغذية (من الحيوان ومن النبات)، وقواعد الأكل الصحّية، وأعضاء التقاط الغذاء عند الحيوان (الأسنان والخرطوم والمنقار).', '# ⚔️ التغذية — أكلٌ لذيذٌ وقُوّةٌ كلَّ يوم!

> 💡 «نأكل في مواعيد، ونختار الأكل المفيد، فيكبر الجسم ويصير قويًّا!»

كلّ يومٍ نأكل لنحصل على **القوّة** ونكبر. لكنْ متى نأكل؟ وماذا نأكل؟ ومن أين يأتي الطعام؟ هيّا نكتشف.

## 🍽️ وجبات اليوم ومواعيدها

في اليوم **ثلاث وجباتٍ** رئيسية:

- **فطور الصباح:** نأكله في الصباح قبل الذهاب إلى المدرسة.
- **الغداء:** نأكله في وسط النهار.
- **العشاء:** نأكله في المساء قبل النوم.

نأكل في **مواعيد ثابتة** كلَّ يوم. هذا يحفظ الجسم سليمًا.

انظر إلى صحن فطور الصباح:

<svg viewBox="0 0 140 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="70" cy="62" rx="58" ry="30" fill="#f9fafb"/>
    <ellipse cx="70" cy="60" rx="46" ry="22" fill="#fef3c7"/>
    <rect x="36" y="50" width="22" height="16" rx="3" fill="#a16207"/>
    <circle cx="92" cy="58" r="13" fill="#ef4444"/>
    <path d="M92 45 q3 -6 7 -3" fill="none" stroke="#22c55e"/>
    <rect x="100" y="40" width="20" height="26" rx="3" fill="#3b82f6"/>
    <rect x="103" y="44" width="14" height="14" fill="#dbeafe" stroke="none"/>
  </g>
</svg>

*مثال: فطور الصباح فيه خبزٌ وحليبٌ (في الكأس) وتفّاحة.*

## 🥕 مصادر الأغذية: من الحيوان ومن النبات

الأغذية لها **مصدران**:

- **من الحيوان:** مثل **الحليب** و**اللحم** و**البيض**.
- **من النبات:** مثل **الخضر** و**الغلال** (الفواكه) و**الحبوب** (القمح).

انظر: التفّاحة غذاءٌ **نباتي**، والحليب غذاءٌ **حيواني**.

<svg viewBox="0 0 150 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <path d="M38 36 q-12 -2 -12 14 q0 22 12 26 q12 -4 12 -26 q0 -16 -12 -14 z" fill="#ef4444"/>
    <path d="M38 36 q1 -8 8 -10" fill="none" stroke="#a16207"/>
    <path d="M40 30 q8 -6 12 0 q-8 0 -12 0 z" fill="#22c55e"/>
    <rect x="92" y="30" width="34" height="48" rx="4" fill="#dbeafe"/>
    <rect x="92" y="30" width="34" height="14" fill="#3b82f6" stroke="none"/>
    <rect x="92" y="30" width="34" height="48" rx="4" fill="none"/>
    <text x="100" y="62" font-size="11" fill="#1f2937" stroke="none">حليب</text>
  </g>
</svg>

*مثال: الخضر والغلال والحبوب من النبات؛ والحليب واللحم والبيض من الحيوان.*

## 🚰 قواعد صحّية للأكل

لنبقى أصحّاء نحترم هذه القواعد:

- **نأكل فطور الصباح** كلَّ يومٍ قبل المدرسة.
- **نحترم مواعيد الأكل** ولا نأكل في كلّ وقت.
- **نغسل أيدينا** قبل الأكل.
- **نشرب الماء الصالح للشراب** (الماء النظيف).
- **نحفظ الطعام** في مكانٍ نظيفٍ وباردٍ حتّى لا يفسد.

> 🗡️ حِيلة سريعة: قبل كلّ وجبةٍ اسأل نفسك: «هل غسلتُ يديّ؟ وهل الماء نظيف؟»

## 🦷 التغذية عند الحيوان: أعضاء التقاط الغذاء

الحيوانات تلتقط غذاءها بأعضاء مختلفة:

- **الأسنان:** بها يأكل **الأسد** و**الكلب** و**البقرة**.
- **المنقار:** به يأكل **العصفور** و**الدجاجة**.
- **الخرطوم:** به يأكل **الفيل** ويقطف أوراق الشجر.

انظر: العصفور يلتقط الحَبَّ **بمنقاره**.

<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="60" cy="56" rx="30" ry="22" fill="#fcd34d"/>
    <circle cx="84" cy="38" r="14" fill="#fcd34d"/>
    <path d="M96 36 l18 4 l-18 6 z" fill="#f59e0b" stroke="none"/>
    <path d="M96 36 l18 4 l-18 6 z" fill="none"/>
    <circle cx="86" cy="35" r="2.5" fill="#1f2937" stroke="none"/>
    <path d="M30 52 q-14 4 -6 16 q6 -2 10 -8 z" fill="#fb923c"/>
    <path d="M52 76 l-3 10 M66 78 l1 10" stroke="#f59e0b"/>
  </g>
</svg>

*مثال: الفيل يأكل بالخرطوم، والأسد بالأسنان، والدجاجة بالمنقار.*

> ⚠️ الفخّ الشائع: ليست كلّ الحيوانات تأكل بنفس العضو! العصفور لا أسنان له، بل يأكل **بالمنقار**؛ والفيل يأكل **بالخرطوم** لا بمنقار.

> 🏆 أحسنت! صرتَ تعرف وجبات اليوم ومواعيدها، ومصادر الأغذية من الحيوان والنبات، وقواعد الأكل الصحّية، وكيف تلتقط الحيوانات غذاءها. في الفصل القادم نكتشف **التنقّل**!', '# 📜 ملخّص: التغذية

- **وجبات اليوم:** ثلاث وجباتٍ في مواعيد ثابتة: **فطور الصباح** و**الغداء** و**العشاء**.
- **مصادر الأغذية:** من **الحيوان** (الحليب واللحم والبيض)، ومن **النبات** (الخضر والغلال والحبوب).
- **قواعد صحّية:** نأكل فطور الصباح، ونحترم المواعيد، ونغسل أيدينا، ونشرب الماء النظيف، ونحفظ الطعام.
- **التغذية عند الحيوان:** يلتقط الحيوان غذاءه بعضوٍ خاصّ: **الأسنان** (الأسد)، أو **المنقار** (العصفور)، أو **الخرطوم** (الفيل).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', 'التنقّل عند الحيوان والإنسان', 'نكتشف كيف يتنقّل الحيوان في البَرّ بالقوائم وفي الهواء بالأجنحة وفي الماء بالزعانف، ونربط بين كيفيّة التنقّل والأعضاء المستعملة، ونصنّف الحيوانات، ونتعرّف تنقّل الإنسان.', '# ⚔️ التنقّل عند الحيوان والإنسان — كلٌّ يتحرّك بطريقته

> 💡 «الأرنب يقفز بقوائمه، والعصفور يطير بجناحيه، والسمكة تسبح بزعانفها… كلّ حيوانٍ والعضو الذي يتنقّل به!»

الحيوان يتحرّك من مكانٍ إلى مكان. هذا اسمه **التنقّل**. لكلّ حيوانٍ **عضوٌ** يتنقّل به. هيّا نكتشف.

## 🐇 التنقّل في البَرّ بالقوائم

كثيرٌ من الحيوانات تعيش في **البَرّ** (على الأرض). تتنقّل بـ**القوائم** (الأرجل).

تمشي، أو **تعدو** (تجري بسرعة)، أو **تقفز**. مثل: **الحصان** يجري، و**الأرنب** يقفز.

انظر: للأرنب أربع قوائم، يقفز بها.

<svg viewBox="0 0 120 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="56" cy="62" rx="26" ry="18" fill="#a16207"/>
    <circle cx="82" cy="46" r="13" fill="#a16207"/>
    <path d="M74 36 q-5 -24 4 -24 q7 6 4 26 z" fill="#fcd34d"/>
    <path d="M84 36 q5 -22 12 -20 q3 9 -6 24 z" fill="#fcd34d"/>
    <circle cx="84" cy="46" r="2.5" fill="#1f2937" stroke="none"/>
    <path d="M38 78 q-7 11 3 13 M58 80 q-3 11 7 11" fill="none" stroke="#92400e"/>
    <circle cx="34" cy="64" r="6" fill="#fcd34d"/>
  </g>
</svg>

*مثال: الأرنب يقفز في الحديقة بقوائمه، والحصان يعدو في البَرّ.*

## 🐦 التنقّل في الهواء بالأجنحة

بعض الحيوانات تتنقّل في **الهواء**. تطير بـ**الأجنحة**.

مثل: **العصفور** يطير، و**الفراشة** تطير. لها أجنحةٌ تحملها في الهواء.

انظر: للعصفور جناحان يطير بهما.

<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="64" cy="56" rx="26" ry="14" fill="#3b82f6"/>
    <circle cx="90" cy="46" r="11" fill="#3b82f6"/>
    <path d="M99 44 l13 -3 l-12 8 z" fill="#f59e0b" stroke="none"/>
    <circle cx="92" cy="44" r="2" fill="#1f2937" stroke="none"/>
    <path d="M50 50 q-22 -28 -36 -16 q15 6 32 22 z" fill="#60a5fa"/>
    <path d="M48 64 l-9 16 M62 66 l-4 18" stroke="#f59e0b"/>
  </g>
</svg>

*مثال: العصفور يطير فوق الشجرة بجناحيه، والفراشة تطير بين الأزهار.*

## 🐟 التنقّل في الماء بالزعانف

بعض الحيوانات تعيش في **الماء**. تسبح بـ**الزعانف**.

مثل: **السمكة**. لها ذيلٌ وزعانف تسبح بها في الماء.

انظر: للسمكة زعانف تسبح بها.

<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="66" width="130" height="24" fill="#3b82f6"/>
  <g stroke="#1f2937" stroke-width="2">
    <path d="M34 42 q26 -22 56 0 q-26 22 -56 0 z" fill="#fb923c"/>
    <path d="M34 42 l-18 -13 l0 26 z" fill="#fb923c"/>
    <path d="M58 24 q7 8 0 14" fill="#f59e0b"/>
    <path d="M58 44 q7 9 0 16" fill="#f59e0b"/>
    <circle cx="80" cy="38" r="2.5" fill="#1f2937" stroke="none"/>
    <path d="M68 38 q5 4 10 0" fill="none"/>
  </g>
</svg>

*مثال: السمكة تسبح في الماء طوال اليوم بزعانفها.*

## 🧭 نصنّف الحيوانات حسب تنقّلها

ننظر إلى **العضو** الذي يتنقّل به الحيوان، فنعرف كيف يتنقّل:

| الحيوان | العضو | كيف يتنقّل؟ |
| --- | --- | --- |
| الأرنب | قوائم | يقفز في البَرّ |
| الحصان | قوائم | يعدو في البَرّ |
| العصفور | أجنحة | يطير في الهواء |
| السمكة | زعانف | تسبح في الماء |

بعض الحيوانات تتنقّل **بأكثر من طريقة**! مثل **البطّة**: تمشي بقوائمها على الأرض، وتسبح في الماء، وتطير بجناحيها أيضًا.

<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="72" width="130" height="23" fill="#3b82f6"/>
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="60" cy="56" rx="30" ry="18" fill="#facc15"/>
    <circle cx="92" cy="40" r="12" fill="#facc15"/>
    <path d="M102 40 q12 -2 12 5 q-7 3 -12 0 z" fill="#f59e0b"/>
    <circle cx="92" cy="37" r="2" fill="#1f2937" stroke="none"/>
    <path d="M40 56 q-16 -10 -6 8" fill="#fde047"/>
    <path d="M54 74 l-3 12 M68 74 l0 12" stroke="#f59e0b"/>
  </g>
</svg>

*مثال: البطّة تجمع ثلاث طُرُق: المشي والسباحة والطيران.*

## 🚶 تنقّل الإنسان

الإنسان أيضًا يتنقّل. يستعمل **رجليه** (قدميه).

يمشي، أو **يعدو** (يجري)، أو **يقفز**. مثلما يفعل الحيوان في البَرّ بالقوائم.

> 🗡️ حِيلة سريعة: انظر إلى **العضو** و**أين يعيش** الحيوان. قوائم في البَرّ ← يمشي أو يعدو أو يقفز. أجنحة في الهواء ← يطير. زعانف في الماء ← يسبح.

> ⚠️ الفخّ الشائع: لا تخلط بين **المكان** و**طريقة التنقّل**. السمكة في الماء **تسبح** بزعانفها، والعصفور في الهواء **يطير** بأجنحته. المهمّ: ما العضو الذي يتنقّل به.

> 🏆 أحسنت! صرتَ تعرف كيف يتنقّل الحيوان في البَرّ والهواء والماء، وأيّ عضوٍ يستعمل، وكيف يتنقّل الإنسان. في الفصل القادم نكتشف **التنفّس** عند الحيوان والإنسان!', '# 📜 ملخّص: التنقّل عند الحيوان والإنسان

- **التنقّل في البَرّ:** الحيوان يتنقّل بـ**القوائم** (الأرجل): يمشي أو يعدو أو يقفز، مثل الحصان (يعدو) والأرنب (يقفز).
- **التنقّل في الهواء:** الحيوان يطير بـ**الأجنحة**، مثل العصفور والفراشة.
- **التنقّل في الماء:** الحيوان يسبح بـ**الزعانف**، مثل السمكة.
- **التصنيف:** نربط بين العضو وطريقة التنقّل: قوائم ← مشي/عدو/قفز، أجنحة ← طيران، زعانف ← سباحة.
- **أكثر من طريقة:** بعض الحيوانات تتنقّل بأكثر من طريقة، مثل البطّة (تمشي وتسبح وتطير).
- **تنقّل الإنسان:** الإنسان يتنقّل بـ**رجليه**: يمشي أو يعدو أو يقفز.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', 'التنفّس', 'نكتشف كيف نتنفّس بالأنف (شهيق وزفير)، والتنفّس العميق، والأوساط التي يتنفّس فيها الإنسان والحيوان في الهواء وفي الماء، والحالات التي يتعطّل فيها التنفّس وقواعد المحافظة عليه.', '# ⚔️ التنفّس — نفَسٌ يدخل ونفَسٌ يخرج

> 💡 «نشهق الهواء النقيّ، ونزفر… هكذا نعيش في كلّ لحظة!»

نحن نتنفّس دائمًا: في النوم وفي اللعب. نُدخِل الهواء ونُخرِجه بلا توقّف. هيّا نكتشف كيف.

## 🌬️ كيف نتنفّس؟

نحن نتنفّس **بالأنف**. الهواء يدخل ويخرج في حركتين:

- **الشهيق:** نُدخِل الهواء النقيّ إلى الداخل. يرتفع الصدر.
- **الزفير:** نُخرِج الهواء إلى الخارج. ينزل الصدر.

انظر: الطفل **يشهق**، والهواء الأزرق يدخل من الأنف.

<svg viewBox="0 0 130 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="78" cy="50" r="30" fill="#fdba74"/>
    <ellipse cx="62" cy="56" rx="6" ry="8" fill="#fb7185"/>
    <circle cx="72" cy="42" r="3" fill="#1f2937" stroke="none"/>
    <circle cx="88" cy="42" r="3" fill="#1f2937" stroke="none"/>
    <path d="M70 64 q8 6 16 0" fill="none"/>
    <line x1="10" y1="56" x2="50" y2="56" stroke="#3b82f6" stroke-width="4"/>
    <polygon points="50,50 60,56 50,62" fill="#3b82f6" stroke="none"/>
  </g>
</svg>

*مثال: عند الشهيق يدخل الهواء، وعند الزفير يخرج الهواء من الأنف.*

## 🫁 التنفّس العميق

أحيانًا نتنفّس **تنفّسًا عميقًا**: نشهق الهواء ببطءٍ حتّى يمتلئ الصدر، ثمّ نزفر ببطء.

التنفّس العميق **يُهدّئنا** ويُريح الجسم. نجرّبه عند التعب أو الخوف.

داخل الصدر **رئتان** تمتلئان بالهواء عند الشهيق.

<svg viewBox="0 0 120 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <line x1="60" y1="18" x2="60" y2="42" stroke="#3b82f6" stroke-width="4"/>
    <path d="M58 40 q-22 4 -22 28 q0 18 14 22 q8 2 8 -10 z" fill="#fb7185"/>
    <path d="M62 40 q22 4 22 28 q0 18 -14 22 q-8 2 -8 -10 z" fill="#fb7185"/>
    <line x1="60" y1="42" x2="60" y2="80"/>
  </g>
</svg>

*مثال: نشهق ببطءٍ فتمتلئ الرئتان، ثمّ نزفر ببطء؛ هذا يُريحنا.*

## 🐟 أين يتنفّس الحيوان؟

كلّ كائنٍ حيّ يتنفّس، لكن **ليس في المكان نفسه**:

- حيواناتٌ تتنفّس **في الهواء**: مثل القطّ، والعصفور، والإنسان.
- حيواناتٌ تتنفّس **في الماء**: مثل **السمكة**؛ فهي لا تخرج إلى الهواء لتتنفّس.

انظر: السمكة تعيش وتتنفّس **في الماء**.

<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg">
  <rect x="4" y="4" width="122" height="82" rx="8" fill="#3b82f6"/>
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="60" cy="46" rx="30" ry="17" fill="#fb923c"/>
    <polygon points="88,46 110,32 110,60" fill="#fb923c"/>
    <circle cx="42" cy="42" r="3" fill="#1f2937" stroke="none"/>
    <path d="M30 46 q6 5 12 0" fill="none"/>
    <circle cx="22" cy="22" r="4" fill="none" stroke="#bfdbfe"/>
    <circle cx="34" cy="14" r="3" fill="none" stroke="#bfdbfe"/>
  </g>
</svg>

*مثال: السمكة تتنفّس في الماء، أمّا العصفور فيتنفّس في الهواء.*

## 🤧 متى يتعطّل التنفّس؟

أحيانًا يصير التنفّس **صعبًا**:

- **الزكام:** ينسدّ الأنف، فيصعب دخول الهواء.
- **الاختناق:** يُمنع الهواء عن الأنف والفم، وهذا **خطير**.

> 🗡️ قواعد لتنفّسٍ سليم: نتنفّس **هواءً نقيًّا**، ونُغطّي الفم والأنف عند السُّعال أو العُطاس، ونبتعد عن الدُّخان.

> ⚠️ الفخّ الشائع: السمكة **لا** تتنفّس مثلنا في الهواء؛ لو أخرجناها من الماء تختنق. كلٌّ يتنفّس في وسطه: نحن في الهواء، والسمكة في الماء.

> 🏆 أحسنت! صرتَ تعرف كيف نتنفّس بالأنف (شهيق وزفير)، وفائدة التنفّس العميق، وأنّ بعض الحيوانات تتنفّس في الماء، ومتى يتعطّل التنفّس. في الفصل القادم نبدأ **علم الفيزياء** ونكتشف **الفضاء والمسافات**!', '# 📜 ملخّص: التنفّس

- **كيف نتنفّس:** نتنفّس بالأنف في حركتين: الشهيق (يدخل الهواء ويرتفع الصدر) والزفير (يخرج الهواء وينزل الصدر).
- **التنفّس العميق:** نشهق ونزفر ببطءٍ فتمتلئ الرئتان؛ هذا يُهدّئنا ويُريح الجسم عند التعب أو الخوف.
- **أين يتنفّس الحيوان:** حيواناتٌ تتنفّس في الهواء (القطّ، العصفور، الإنسان)، وأخرى تتنفّس في الماء (السمكة).
- **متى يتعطّل التنفّس:** يصعب التنفّس عند الزكام (انسداد الأنف) والاختناق؛ فنتنفّس هواءً نقيًّا ونُغطّي الفم عند السُّعال.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', 'الفضاء والمسافات والقيس', 'نكتشفُ الأبعاد الظاهريّة (القريب يظهر كبيرًا والبعيد صغيرًا)، ونعيّن مواقع الأجسام بالتغطية (الأقرب يحجب الأبعد)، ونختار الوحدة الملائمة للقيس: المتر للأطوال واللتر للسعات.', '# ⚔️ الفضاء والمسافات والقيس — القريب والبعيد، وكيف نقيس؟

> 💡 «الشّجرة القريبة تبدو كبيرة، والبعيدة تبدو صغيرة… وبالمتر نقيس الطّول، وباللتر نقيس الماء!»

في الفضاء حولنا أجسامٌ قريبة وأخرى بعيدة. هيّا نتعلّم كيف نعرف الأقرب من الأبعد، ثمّ كيف نقيس الأطوال والسوائل.

## 🌳 الأبعاد الظاهريّة: القريب كبير والبعيد صغير

**الجسم القريب** منّا يظهر **كبيرًا**. **الجسم البعيد** عنّا يظهر **صغيرًا**.

الشّجرتان متساويتان في الحقيقة. لكنّ القريبة تبدو أكبر، والبعيدة تبدو أصغر.

انظر: الشّجرة القريبة كبيرة، والشّجرة البعيدة صغيرة.

<svg viewBox="0 0 220 110" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <line x1="10" y1="95" x2="210" y2="95"/>
    <rect x="34" y="60" width="12" height="35" fill="#a16207"/>
    <circle cx="40" cy="48" r="26" fill="#22c55e"/>
    <rect x="172" y="72" width="6" height="20" fill="#a16207"/>
    <circle cx="175" cy="66" r="13" fill="#16a34a"/>
    <circle cx="120" cy="22" r="11" fill="#fcd34d"/>
  </g>
</svg>

> 🗡️ القاعدة: نفس الجسم… كلّما **اقترب** بدا **أكبر**، وكلّما **ابتعد** بدا **أصغر**.

## 🫥 التغطية: الأقرب يحجب الأبعد

عندما يقف جسمٌ **أمام** جسمٍ آخر، فهو **يغطّيه** (يحجبه). الجسم الذي **يغطّي** هو **الأقرب**، والمحجوب هو **الأبعد**.

- **تغطية جزئيّة:** الجسم الأمامي يحجب **جزءًا** من الخلفي.
- **تغطية كلّية:** الجسم الأمامي يحجب الخلفي **كلّه**.

انظر: الكرة الحمراء أمام الزرقاء وتحجب جزءًا منها. فالحمراء **أقرب**.

<svg viewBox="0 0 160 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="95" cy="52" r="30" fill="#3b82f6"/>
    <circle cx="60" cy="60" r="30" fill="#ef4444"/>
  </g>
</svg>

> 🗡️ حِيلة: مَن يحجب غيره فهو **أقرب** إليك؛ والمحجوب **أبعد**.

## 📏 المتر: لقيس الأطوال

لنعرف **طول** أو **مسافة**، نستعمل المتر. وحدة قيس الأطوال هي **المتر**، ونكتبها **m**.

نقيس بالمتر: طول الطّاولة، طول الحبل، المسافة بين البيت والمدرسة.

انظر: المسطرة تقيس طول الطّاولة بالمتر.

<svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="30" y="44" width="140" height="22" fill="#92400e"/>
    <rect x="34" y="34" width="12" height="10" fill="#a16207"/>
    <rect x="154" y="34" width="12" height="10" fill="#a16207"/>
    <rect x="30" y="20" width="140" height="12" fill="#f59e0b"/>
    <line x1="55" y1="20" x2="55" y2="32"/>
    <line x1="80" y1="20" x2="80" y2="32"/>
    <line x1="105" y1="20" x2="105" y2="32"/>
    <line x1="130" y1="20" x2="130" y2="32"/>
    <text x="100" y="84" font-size="16" text-anchor="middle" fill="#1f2937" stroke="none">m</text>
  </g>
</svg>

## 🥤 اللتر: لقيس السعات

لنعرف كمّيّة **السائل** (الماء، الحليب، العصير)، نستعمل اللتر. وحدة قيس السعات هي **اللتر**، ونكتبها **L**.

نقيس باللتر: ماء القارورة، حليب العلبة، عصير الإبريق.

انظر: القارورة فيها ماءٌ نقيسه باللتر.

<svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="50" y="10" width="20" height="16" fill="#3b82f6"/>
    <path d="M44 26 h32 l6 16 v70 a6 6 0 0 1 -6 6 h-32 a6 6 0 0 1 -6 -6 v-70 z" fill="#dbeafe"/>
    <path d="M38 72 h44 v40 a6 6 0 0 1 -6 6 h-32 a6 6 0 0 1 -6 -6 z" fill="#3b82f6"/>
    <text x="60" y="100" font-size="18" text-anchor="middle" fill="#ffffff" stroke="none">L</text>
  </g>
</svg>

> ⚠️ الفخّ الشائع: لا تخلط الوحدتين! **المتر (m)** للأطوال والمسافات، و**اللتر (L)** للسوائل. لا نقيس الماء بالمتر، ولا نقيس طول الحبل باللتر.

> 🏆 رائع! صرتَ تعرف أنّ القريب يبدو كبيرًا والبعيد صغيرًا، وأنّ الأقرب يحجب الأبعد، وأنّ المتر للأطوال واللتر للسعات. في الفصل القادم نكتشف الزمن!', '# 📜 ملخّص: الفضاء والمسافات والقيس

- **الأبعاد الظاهريّة:** الجسم القريب يظهر كبيرًا، والجسم البعيد يظهر صغيرًا (نفس الجسم).
- **التغطية:** الجسم الأقرب يحجب (يغطّي) الأبعد؛ تغطية جزئيّة (جزء) أو كلّية (كلّه).
- **المتر (m):** وحدة قيس الأطوال والمسافات، مثل طول الطّاولة والمسافة إلى المدرسة.
- **اللتر (L):** وحدة قيس السعات (السوائل)، مثل ماء القارورة وحليب العلبة.
- **القاعدة:** المتر للأطوال، واللتر للسوائل؛ ومَن يحجب غيره فهو الأقرب.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', 'الزمن', 'نرتّب الأحداث حسب تسلسلها الزمني، ونقارن الحركة الأسرع بالأبطأ بمقارنة المسافة المقطوعة في نفس المدّة، ونميّز الأحداث الدوريّة من غير الدوريّة.', '# ⚔️ الزمن — أوّلًا ثمّ أخيرًا، أسرع أم أبطأ؟

> 💡 «الوقت يمرّ: حدثٌ قبل حدث، ومن يقطع مسافةً أطول في نفس الوقت يكون أسرع!»

كلّ شيءٍ يحدث في **الزمن**. حدثٌ يأتي **أوّلًا** وحدثٌ **بعده**. وبعض الحركات **سريعة** وبعضها **بطيئة**. هيّا نكتشف.

## 🥇 الترتيب الزمني للأحداث

الأحداث تأتي **واحدًا بعد الآخر**. نرتّبها: ما حدث **أوّلًا**، ثمّ ما حدث بعده، ثمّ ما حدث **أخيرًا**.

نستعمل كلمتَي **قبل** و**بعد**: الصباح **قبل** الظهر، والمساء **بعد** الظهر.

انظر: تكبر البذرة بالترتيب — أوّلًا بذرة، ثمّ نبتة صغيرة، أخيرًا شجرة.

<svg viewBox="0 0 300 110" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="95" x2="290" y2="95" stroke="#1f2937" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="45" cy="80" rx="9" ry="6" fill="#a16207"/>
    <text x="38" y="22" font-size="16" stroke="none" fill="#1f2937">1</text>
    <line x1="130" y1="95" x2="130" y2="60" stroke="#15803d"/>
    <path d="M130 70 q-14 -4 -16 6 q12 2 16 -6 z" fill="#22c55e"/>
    <path d="M130 64 q14 -4 16 6 q-12 2 -16 -6 z" fill="#22c55e"/>
    <text x="123" y="22" font-size="16" stroke="none" fill="#1f2937">2</text>
    <line x1="225" y1="95" x2="225" y2="55" stroke="#a16207" stroke-width="4"/>
    <circle cx="225" cy="42" r="20" fill="#22c55e"/>
    <text x="218" y="22" font-size="16" stroke="none" fill="#1f2937">3</text>
    <path d="M70 50 h30 M180 50 h30" fill="none" stroke="#f59e0b" stroke-width="3"/>
    <path d="M100 50 l-7 -4 l0 8 z" fill="#f59e0b" stroke="none"/>
    <path d="M210 50 l-7 -4 l0 8 z" fill="#f59e0b" stroke="none"/>
  </g>
</svg>

الترتيب هو: أوّلًا (1)، ثمّ (2)، أخيرًا (3).

## 🐢 أسرع وأبطأ

نقارن حركتين في **نفس المدّة** (نفس الوقت). من يقطع **مسافةً أطول** يكون **أسرع**. ومن يقطع **مسافةً أقصر** يكون **أبطأ**.

في نفس الوقت: الأرنب قطع مسافةً طويلة، والسلحفاة قطعت مسافةً قصيرة. إذن **الأرنب أسرع** و**السلحفاة أبطأ**.

<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <line x1="20" y1="40" x2="280" y2="40" stroke="#f59e0b" stroke-width="3"/>
    <line x1="20" y1="100" x2="280" y2="100" stroke="#f59e0b" stroke-width="3"/>
    <line x1="20" y1="30" x2="20" y2="110" stroke="#1f2937" stroke-width="3"/>
    <ellipse cx="245" cy="30" rx="18" ry="11" fill="#a16207"/>
    <circle cx="263" cy="22" r="8" fill="#a16207"/>
    <path d="M258 16 q-3 -14 3 -14 q4 4 1 15 z" fill="#a16207"/>
    <path d="M266 16 q3 -13 8 -12 q1 6 -4 14 z" fill="#a16207"/>
    <circle cx="264" cy="22" r="1.6" fill="#1f2937" stroke="none"/>
    <ellipse cx="70" cy="92" rx="20" ry="13" fill="#22c55e"/>
    <ellipse cx="70" cy="92" rx="13" ry="8" fill="#15803d"/>
    <circle cx="90" cy="90" r="7" fill="#22c55e"/>
    <circle cx="92" cy="89" r="1.6" fill="#1f2937" stroke="none"/>
  </g>
</svg>

الأرنب وصل بعيدًا في نفس الوقت ← **أسرع**. السلحفاة بقيت قريبة ← **أبطأ**.

## 🔁 الأحداث الدوريّة

بعض الأحداث **تتكرّر بانتظام**، تعود كلّ مرّةٍ بعد نفس المدّة. نسمّيها **أحداثًا دوريّة**.

مثل: **تعاقب الليل والنهار** كلّ يوم، و**أيّام الأسبوع** السبعة، وعودة **الصباح** كلّ يوم.

انظر: بعد النهار يأتي الليل، ثمّ يعود النهار… دائمًا بانتظام.

<svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="14" y="20" width="80" height="80" rx="8" fill="#fef3c7"/>
    <circle cx="54" cy="60" r="17" fill="#fcd34d"/>
    <line x1="54" y1="33" x2="54" y2="26"/>
    <line x1="54" y1="87" x2="54" y2="94"/>
    <line x1="27" y1="60" x2="20" y2="60"/>
    <line x1="81" y1="60" x2="88" y2="60"/>
    <rect x="206" y="20" width="80" height="80" rx="8" fill="#3730a3"/>
    <path d="M252 38 a20 20 0 1 0 16 36 a16 16 0 0 1 -16 -36 z" fill="#fcd34d"/>
    <circle cx="226" cy="40" r="1.6" fill="#ffffff" stroke="none"/>
    <circle cx="270" cy="84" r="1.6" fill="#ffffff" stroke="none"/>
    <path d="M104 48 h36" fill="none" stroke="#f59e0b" stroke-width="3"/>
    <path d="M140 48 l-7 -4 l0 8 z" fill="#f59e0b" stroke="none"/>
    <path d="M196 72 h-36" fill="none" stroke="#f59e0b" stroke-width="3"/>
    <path d="M160 72 l7 -4 l0 8 z" fill="#f59e0b" stroke="none"/>
  </g>
</svg>

نهارٌ ثمّ ليلٌ ثمّ نهار… يتكرّر **بانتظام** كلّ يوم: هذا حدثٌ **دوريّ**.

## 🎈 الأحداث غير الدوريّة

بعض الأحداث **لا تتكرّر بانتظام**. لا نعرف متى تعود بالضبط، أو تحدث مرّةً واحدة. نسمّيها **أحداثًا غير دوريّة**.

مثل: **نزول المطر**، و**عيد ميلادك**، و**كسر قلم**، و**زيارة الجدّة**. لا تأتي كلّ يومٍ بانتظام مثل الليل والنهار.

> 🗡️ حِيلة سريعة: للترتيب اسأل «ما الذي حدث **قبل**؟». وللسرعة قارن المسافة في **نفس الوقت**: الأبعد أسرع. وللدوري اسأل «هل يتكرّر **بانتظام**؟» نعم ← دوريّ، لا ← غير دوريّ.

> ⚠️ الفخّ الشائع: في «أسرع وأبطأ» لا تنظر إلى المسافة وحدها، بل إلى المسافة في **نفس المدّة**. ومن يصل **أوّلًا** للنهاية في نفس الوقت يكون قد قطع مسافةً أطول، فهو الأسرع. ولا تخلط: الليل والنهار **دوريّان**، أمّا المطر فغير دوريّ.

> 🏆 ممتاز! صرتَ ترتّب الأحداث بـ«أوّلًا ثمّ أخيرًا»، وتقارن الأسرع بالأبطأ بالمسافة في نفس الوقت، وتميّز الحدث الدوريّ من غير الدوريّ. في الفصل القادم نكتشف **المادّة**!', '# 📜 ملخّص: الزمن

- **الترتيب الزمني:** نرتّب الأحداث أوّلًا ثمّ أخيرًا، ونستعمل «قبل» و«بعد» (الصباح قبل الظهر، المساء بعده).
- **أسرع وأبطأ:** نقارن المسافة في نفس المدّة؛ من يقطع مسافةً أطول يكون أسرع، ومن يقطع مسافةً أقصر يكون أبطأ.
- **الأحداث الدوريّة:** تتكرّر بانتظام، مثل تعاقب الليل والنهار وأيّام الأسبوع.
- **الأحداث غير الدوريّة:** لا تتكرّر بانتظام، مثل نزول المطر وعيد الميلاد.
- **القاعدة:** للسرعة قارن المسافة في نفس الوقت (الأبعد أسرع)؛ وللدوري اسأل: هل يتكرّر بانتظام؟', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', 'المادّة', 'نتعلّم كيف نقارن الأجسام من حيث الصلابة (أصلب وأليَن) ونرتّبها، ونكتشف حالات المادّة الثلاث: الصلب يحفظ شكله، والسائل والغازي يأخذان شكل الإناء.', '# ⚔️ المادّة — مستكشفُ الصلابة والحالات

> 💡 «الحجر صلبٌ يحفظ شكله، والماء سائلٌ يأخذ شكل الكوب: لكلّ مادّةٍ سرّ!»

كلّ الأشياء من حولنا مصنوعةٌ من **مادّة**. بعضها **صلبٌ قاسٍ** كالحجر، وبعضها **سائلٌ يجري** كالماء، وبعضها **غازٌ خفيف** كالهواء. هيّا نقارن بينها ونكتشف حالاتها.

## 💎 الصلابة: أصلب أم أليَن؟

نقارن جسمًا بجسمٍ آخر من حيث **الصلابة**:

- **الجسم الصلب القاسي** لا ينضغط بسهولة، مثل **الحجر** و**الخشب** و**المفتاح**.
- **الجسم الليّن** طريٌّ ينضغط بسهولة تحت الإصبع، مثل **الإسفنج** و**العجين**.

نقول: **الحجر أصلب من الخشب**، و**الخشب أصلب من الإسفنج**. والإسفنج **أليَن** من الخشب.

انظر: الحجر قاسٍ، والإسفنج طريٌّ ليّن.

<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <path d="M22 74 l8 -34 l24 -8 l22 12 l-6 32 z" fill="#64748b"/>
    <path d="M30 40 l24 -8 l22 12" fill="none"/>
    <text x="40" y="92" font-size="11" fill="#1f2937" stroke="none">حجر صلب</text>
    <rect x="118" y="44" width="60" height="34" rx="5" fill="#fcd34d"/>
    <circle cx="132" cy="56" r="3" fill="#f59e0b" stroke="none"/>
    <circle cx="150" cy="62" r="3" fill="#f59e0b" stroke="none"/>
    <circle cx="164" cy="52" r="3" fill="#f59e0b" stroke="none"/>
    <circle cx="146" cy="50" r="3" fill="#f59e0b" stroke="none"/>
    <text x="120" y="92" font-size="11" fill="#1f2937" stroke="none">إسفنج ليّن</text>
  </g>
</svg>

## 🪨 الجسم الصلب: له شكلٌ خاصّ به

**الجسم الصلب** له **شكلٌ خاصّ به لا يتغيّر**. نضعه في أيّ مكانٍ فيبقى شكله كما هو.

المفتاح صلب: شكله واحدٌ على الطاولة وفي اليد وفي الجيب.

انظر: المفتاح يحفظ شكله نفسه دائمًا.

<svg viewBox="0 0 180 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="44" cy="45" r="16" fill="#facc15"/>
    <circle cx="44" cy="45" r="6" fill="#fde68a"/>
    <rect x="58" y="40" width="62" height="10" rx="2" fill="#facc15"/>
    <rect x="104" y="50" width="8" height="12" fill="#facc15"/>
    <rect x="116" y="50" width="6" height="16" fill="#facc15"/>
    <text x="34" y="82" font-size="11" fill="#1f2937" stroke="none">مفتاح: شكل ثابت</text>
  </g>
</svg>

> 🗡️ حيلة سريعة: إن كان للجسم **شكلٌ واحدٌ لا يتغيّر** فهو **صلب**.

## 💧 الجسم السائل: يأخذ شكل الإناء

**الجسم السائل** يجري، و**يأخذ شكل الإناء** الذي يحويه. مثل **الماء** و**الحليب** و**الزيت**.

الماء نفسه: في الكوب يصير على شكل الكوب، وفي الصحن يصير على شكل الصحن.

انظر: نفس الماء الأزرق، شكلان مختلفان حسب الإناء.

<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <path d="M28 24 l44 0 l-5 64 l-34 0 z" fill="none"/>
    <path d="M32 50 l36 0 l-3 38 l-30 0 z" fill="#3b82f6"/>
    <text x="26" y="98" font-size="11" fill="#1f2937" stroke="none">كوب</text>
    <path d="M118 40 q42 0 64 0 q-6 40 -32 40 q-26 0 -32 -40 z" fill="none"/>
    <path d="M126 56 q34 6 48 0 q-6 24 -24 24 q-18 0 -24 -24 z" fill="#3b82f6"/>
    <text x="140" y="98" font-size="11" fill="#1f2937" stroke="none">صحن</text>
  </g>
</svg>

> ⚠️ الفخّ الشائع: لا تظنّ أنّ **للماء شكلًا خاصًّا به**. الماء سائلٌ **لا شكل له**، بل يأخذ شكل الكوب أو القارورة أو الصحن. الذي يحفظ شكله هو **الصلب** فقط.

## 🎈 الجسم الغازي: يأخذ شكل الإناء وينتشر فيه

**الجسم الغازي** مثل **الهواء**. هو أيضًا **يأخذ شكل الإناء** الذي يحويه، **وينتشر** ليملأه كلّه.

ننفخ الهواء في البالون فيأخذ شكل البالون، وننفخه في القارورة فيملأها كلّها.

انظر: الهواء يملأ البالون ويأخذ شكله.

<svg viewBox="0 0 140 110" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="70" cy="48" rx="34" ry="40" fill="#86efac"/>
    <path d="M64 88 l6 8 l6 -8 z" fill="#86efac"/>
    <path d="M70 96 q-8 8 0 12" fill="none"/>
    <circle cx="58" cy="38" r="4" fill="#bbf7d0" stroke="none"/>
    <text x="36" y="108" font-size="11" fill="#1f2937" stroke="none">هواء في بالون</text>
  </g>
</svg>

## 🗂️ نجمع ونرتّب

نرتّب الأجسام حسب الصلابة، ونصنّفها حسب الحالة:

| الجسم | الحالة | الشكل |
| --- | --- | --- |
| الحجر، المفتاح | صلب | شكلٌ خاصّ ثابت |
| الماء، الحليب | سائل | شكل الإناء |
| الهواء | غازي | شكل الإناء وينتشر |

> 🏆 رائع! صرتَ تقارن الأجسام من حيث الصلابة وترتّبها، وتعرف أنّ الصلب يحفظ شكله بينما السائل والغازي يأخذان شكل الإناء. في الفصل القادم نكتشف **القوى**!', '# 📜 ملخّص: المادّة

- **الصلابة:** نقارن جسمًا بجسم؛ الحجر **أصلب** من الخشب، والخشب أصلب من الإسفنج، والإسفنج **أليَن** (طريّ ينضغط).
- **الجسم الصلب:** له **شكلٌ خاصّ به لا يتغيّر**، مثل الحجر والخشب والمفتاح.
- **الجسم السائل:** **يأخذ شكل الإناء** الذي يحويه، مثل الماء والحليب والزيت.
- **الجسم الغازي:** يأخذ أيضًا **شكل الإناء وينتشر** فيه ليملأه، مثل الهواء.
- **القاعدة:** الصلب يحفظ شكله؛ أمّا السائل والغازي فلا شكل خاصّ لهما، يأخذان شكل الإناء.', 9)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', 'القوى', 'نتعرّف القوّة من خلال آثارها: تحرّك جسمًا ساكنًا أو توقف جسمًا متحرّكًا أو تغيّر حركته أو شكله، ونكتشف أنّ الأجسام تسقط على الأرض بفعل الجاذبيّة، وأنواع القوى: العضليّة والكهربائيّة والمغناطيسيّة.', '# ⚔️ القوى — أُحرّكُ الأشياءَ بقوّتي!

> 💡 «أدفعُ الكرةَ فتجري، وأرفعُ الحقيبةَ فترتفع: القوّةُ سرٌّ في يديّ!»

كلَّ يومٍ تستعملُ **قوّة**: تدفعُ بابًا، تركلُ كرةً، ترفعُ حقيبتَك. لا نرى القوّةَ، لكنّنا نرى **أثرَها** في الأشياء. هيّا نكتشفُ ما هي القوّة وأنواعَها.

## 💪 ما هي القوّة؟ نعرفُها من أثرها

القوّةُ هي ما يُغيّرُ حالَ الأجسام. نُدركُ القوّةَ من **أثرها**. للقوّة أربعةُ آثار:

- **تُحرّكُ جسمًا ساكنًا:** الكرةُ الواقفةُ تجري عندما نركلُها.
- **توقفُ جسمًا متحرّكًا:** نمسكُ الكرةَ الجاريةَ فتقف.
- **تغيّرُ حركةَ جسم:** نضربُ الكرةَ فتغيّرُ طريقَها أو سرعتَها.
- **تغيّرُ شكلَ جسم:** نضغطُ العجينَ بأيدينا فيتغيّرُ شكلُه.

انظر: يدٌ تدفعُ الكرةَ بقوّة، فتتحرّكُ الكرةُ إلى الأمام.

<svg viewBox="0 0 210 110" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="92" x2="200" y2="92" stroke="#1f2937" stroke-width="2"/>
  <rect x="10" y="84" width="190" height="8" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/>
  <ellipse cx="40" cy="62" rx="16" ry="20" fill="#fdba74" stroke="#1f2937" stroke-width="2"/>
  <path d="M40 50 q12 0 14 12 q-2 6 -8 4" fill="#fdba74" stroke="#1f2937" stroke-width="2"/>
  <line x1="58" y1="62" x2="98" y2="62" stroke="#f59e0b" stroke-width="6"/>
  <polygon points="118,62 96,52 96,72" fill="#f59e0b" stroke="#1f2937" stroke-width="1.5"/>
  <circle cx="150" cy="66" r="18" fill="#ef4444" stroke="#1f2937" stroke-width="2"/>
  <path d="M150 48 v36 M132 66 h36" stroke="#1f2937" stroke-width="1.5"/>
  <text x="88" y="44" font-size="11" fill="#1f2937" text-anchor="middle">قوّة</text>
</svg>

*مثال: الكرةُ لا تتحرّكُ وحدها، نحن نحرّكُها بقوّتنا.*

## 🏋️ رفعُ الأجسام يحتاجُ قوّة

لِرفعِ جسمٍ إلى **أعلى**، نُسلّطُ عليه **قوّة**. كلّما كان الجسمُ أثقل، احتجنا قوّةً أكبر.

تَرفعُ الحقيبةَ بقوّةِ عضلاتك، ويَرفعُ الرافعُ الصناديقَ الثقيلةَ بقوّةٍ كبيرة.

*مثال: ارفعْ حقيبتَك المدرسيّةَ، تَشعرُ أنّك تُسلّطُ قوّة. أمّا الحقيبةُ الفارغةُ فترفعُها بقوّةٍ أقلّ.*

## 🍎 السقوط: جاذبيّةُ الأرض

إذا تركنا جسمًا في الهواء **دون أن نمسكه**، فإنّه **يسقطُ على الأرض**. الأجسامُ لا تبقى معلّقةً في الهواء.

الذي يجذبُ الأجسامَ إلى **الأسفل** هو **جاذبيّةُ الأرض**. كلُّ جسمٍ نتركُه يقعُ على الأرض حتمًا.

<svg viewBox="0 0 160 130" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="112" x2="150" y2="112" stroke="#1f2937" stroke-width="2"/>
  <rect x="10" y="104" width="140" height="8" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/>
  <circle cx="80" cy="30" r="16" fill="#ef4444" stroke="#1f2937" stroke-width="2"/>
  <line x1="80" y1="50" x2="80" y2="88" stroke="#f59e0b" stroke-width="6"/>
  <polygon points="80,104 70,82 90,82" fill="#f59e0b" stroke="#1f2937" stroke-width="1.5"/>
  <text x="118" y="74" font-size="11" fill="#1f2937" text-anchor="middle">سقوط</text>
</svg>

*مثال: اترُكْ كرةً من يدك، فتسقطُ نحو الأرض. لا ترتفعُ إلى السماء وحدها أبدًا.*

## 🧲 أنواعُ القوى

ليست كلُّ القوى من العضلات. هناك ثلاثةُ أنواع:

- **قوّةٌ عضليّة:** بقوّةِ **العضلات** (نرفعُ، ندفعُ، نسحبُ).
- **قوّةٌ كهربائيّة:** قوّةُ **الكهرباء** التي تُشغّلُ الآلات.
- **قوّةٌ مغناطيسيّة:** **المغناطيسُ** يجذبُ **الحديد** إليه عن بُعد.

انظر: المغناطيسُ يجذبُ المسمارَ الحديديَّ نحوه.

<svg viewBox="0 0 210 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M20 30 h22 v40 h-22 z" fill="#ef4444" stroke="#1f2937" stroke-width="2"/>
  <path d="M20 30 h22 v14 h-22 z" fill="#3b82f6" stroke="#1f2937" stroke-width="2"/>
  <line x1="50" y1="50" x2="118" y2="50" stroke="#1f2937" stroke-width="2.5" stroke-dasharray="7 5"/>
  <polygon points="58,50 76,42 76,58" fill="#1f2937"/>
  <rect x="130" y="46" width="50" height="8" fill="#64748b" stroke="#1f2937" stroke-width="2"/>
  <polygon points="180,42 196,50 180,58" fill="#64748b" stroke="#1f2937" stroke-width="2"/>
  <text x="31" y="86" font-size="11" fill="#1f2937" text-anchor="middle">مغناطيس</text>
  <text x="150" y="86" font-size="11" fill="#1f2937" text-anchor="middle">حديد</text>
</svg>

*مثال: قرّبْ مغناطيسًا من مسمارِ حديد، فيقفزُ المسمارُ نحوه. أمّا الورقُ والخشبُ فلا يجذبُهما المغناطيس.*

> 🗡️ تذكّرِ القاعدة: القوّةُ **تُحرّك** الساكن، **توقفُ** المتحرّك، **تغيّرُ** الحركةَ أو **الشكل**. والأجسامُ المتروكةُ **تسقطُ** على الأرض.

> ⚠️ الفخّ الشائع: لا نرى القوّةَ نفسها، بل نرى **أثرَها**. إذا تحرّكَ جسمٌ أو توقّفَ أو تغيّرَ شكلُه، فاعلمْ أنّ قوّةً سُلّطت عليه.

> 🏆 أحسنت يا بطل! تعرفُ الآن آثارَ القوّة، وأنّ الأجسامَ تسقطُ بجاذبيّةِ الأرض، وأنواعَ القوى الثلاثة. بهذا أتممتَ كلَّ رحلةِ الإيقاظ العلميّ للسنة الثانية — مبروك، أنت الآن عالِمٌ صغيرٌ حقيقيّ! 🎉', '# 📜 ملخّص: القوى

- **القوّة وآثارها:** لا نرى القوّةَ بل أثرَها؛ فهي تُحرّكُ جسمًا ساكنًا، أو توقفُ جسمًا متحرّكًا، أو تغيّرُ حركتَه، أو تغيّرُ شكلَه.
- **رفعُ الأجسام:** لِرفعِ جسمٍ إلى أعلى نُسلّطُ عليه قوّة، وكلّما ثقُل الجسمُ احتجنا قوّةً أكبر.
- **السقوط:** كلُّ جسمٍ نتركُه في الهواء يسقطُ على الأرض بفعل **جاذبيّةِ الأرض** التي تجذبُه إلى الأسفل.
- **أنواعُ القوى:** قوّةٌ عضليّة (بالعضلات)، وقوّةٌ كهربائيّة (بالكهرباء)، وقوّةٌ مغناطيسيّة (المغناطيسُ يجذبُ الحديد).', 10)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('39b4bf5f-3011-57a5-8035-744364eecbf5', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('52fb00c8-bcd0-52b9-bb8b-bceaab89b93f', '39b4bf5f-3011-57a5-8035-744364eecbf5', 'ما هو الحيوان الأليف؟', '[{"id":"a","text":"حيوانٌ يربّيه الإنسان ويعتني به"},{"id":"b","text":"حيوانٌ يعيش حُرًّا في الغابة"},{"id":"c","text":"حيوانٌ يطير في السماء فقط"},{"id":"d","text":"حيوانٌ يعيش في البحر فقط"}]'::jsonb, 'a', 'الحيوان الأليف يربّيه الإنسان ويعطيه الأكل والماء والمأوى.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8e6d1e4-812b-585e-96e5-a5cd9701b039', '39b4bf5f-3011-57a5-8035-744364eecbf5', 'أين يعيش الأسد؟', '[{"id":"a","text":"في البيت"},{"id":"b","text":"في الغابة"},{"id":"c","text":"في الحظيرة"},{"id":"d","text":"في القنّ"}]'::jsonb, 'b', 'الأسد حيوانٌ برّي يعيش حُرًّا في الغابة، ولا يربّيه الإنسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d75ec201-590f-5725-b44f-ea3518519781', '39b4bf5f-3011-57a5-8035-744364eecbf5', 'أيّ حيوانٍ يُعطينا الحليب؟', '[{"id":"a","text":"الأسد"},{"id":"b","text":"الغزال"},{"id":"c","text":"البقرة"},{"id":"d","text":"الثعلب"}]'::jsonb, 'c', 'البقرة حيوانٌ أليف يربّيه الفلّاح، وهي تعطينا الحليب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34002379-9e50-5965-92b0-00943d27bb98', '39b4bf5f-3011-57a5-8035-744364eecbf5', 'الدجاجة حيوانٌ أليف. ماذا تعطينا؟', '[{"id":"a","text":"الصوف"},{"id":"b","text":"العسل"},{"id":"c","text":"الحليب"},{"id":"d","text":"البيض"}]'::jsonb, 'd', 'الدجاجة تعيش في القنّ قُرب الإنسان، وهي تعطينا البيض.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('473e6959-e211-53bd-94bc-dd5ed8e24579', '39b4bf5f-3011-57a5-8035-744364eecbf5', 'أيّ مجموعةٍ كلّها حيوانات برّية؟', '[{"id":"a","text":"الأسد، الغزال، الفيل"},{"id":"b","text":"القطّ، الكلب، البقرة"},{"id":"c","text":"الدجاجة، الخروف، القطّ"},{"id":"d","text":"الكلب، البقرة، الدجاجة"}]'::jsonb, 'a', 'الأسد والغزال والفيل تعيش حُرّةً في الطبيعة ولا يربّيها الإنسان، فهي برّية.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4294bff2-4018-5e9f-acf5-93e951c0301d', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', '⭐ تمرين: أليف أم برّي؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1f56e6dc-d238-5844-81c3-9e2ccc428e1a', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'القطّ يعيش في البيت ويعتني به الإنسان. هل هو أليف أم برّي؟', '[{"id":"a","text":"أليف"},{"id":"b","text":"برّي"},{"id":"c","text":"لا أليف ولا برّي"},{"id":"d","text":"نباتٌ وليس حيوانًا"}]'::jsonb, 'a', 'القطّ يربّيه الإنسان ويعتني به في البيت، فهو حيوانٌ أليف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6417697-66a8-51e6-a95e-e05892265eaf', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'الفيل يعيش حُرًّا في الطبيعة. ما نوعه؟', '[{"id":"a","text":"أليف"},{"id":"b","text":"برّي"},{"id":"c","text":"يربّيه الفلّاح في المزرعة"},{"id":"d","text":"يعيش في القنّ"}]'::jsonb, 'b', 'الفيل لا يربّيه الإنسان، بل يعيش حُرًّا في الطبيعة، فهو حيوانٌ برّي.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4be76f5-76a8-55ba-8593-7b3abd622afc', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'أين تعيش البقرة عادةً؟', '[{"id":"a","text":"في الغابة حُرّة"},{"id":"b","text":"في الصحراء"},{"id":"c","text":"في المزرعة قُرب الإنسان"},{"id":"d","text":"في أعالي الجبال وحدها"}]'::jsonb, 'c', 'البقرة حيوانٌ أليف يربّيه الفلّاح في المزرعة قُرب الإنسان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03c13c7f-8e42-560e-9611-c90655a47f6b', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'هذا الحيوان يعيش في الغابة. ما نوعه؟<svg viewBox="0 0 120 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="60" cy="48" r="22" fill="#b45309"/><circle cx="60" cy="48" r="14" fill="#f59e0b"/><path d="M60 26 v-6 M44 32 l-4 -5 M76 32 l4 -5 M38 48 h-6 M82 48 h6 M44 64 l-4 5 M76 64 l4 5 M60 70 v6" stroke="#92400e"/><circle cx="53" cy="45" r="2.5" fill="#1f2937" stroke="none"/><circle cx="67" cy="45" r="2.5" fill="#1f2937" stroke="none"/><path d="M55 54 q5 4 10 0" fill="none"/></g></svg>', '[{"id":"a","text":"حيوانٌ برّي (أسد)"},{"id":"b","text":"حيوانٌ أليف نربّيه في البيت"},{"id":"c","text":"دجاجةٌ في القنّ"},{"id":"d","text":"بقرةٌ في المزرعة"}]'::jsonb, 'a', 'الصورة تُظهر أسدًا بلَبدةٍ حول وجهه، وهو حيوانٌ برّي يعيش في الغابة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c50d46f0-1343-5959-aef2-a3b3e7bee69e', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'ماذا تعطينا الدجاجة؟', '[{"id":"a","text":"الصوف"},{"id":"b","text":"البيض"},{"id":"c","text":"العسل"},{"id":"d","text":"الحرير"}]'::jsonb, 'b', 'الدجاجة حيوانٌ أليف، وهي تعطينا البيض.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49b55742-a5d0-569c-87e9-dc97af861ac1', '4294bff2-4018-5e9f-acf5-93e951c0301d', 'أيّ حيوانٍ من هذه يربّيه الإنسان؟', '[{"id":"a","text":"الأسد"},{"id":"b","text":"الغزال"},{"id":"c","text":"الثعلب"},{"id":"d","text":"الخروف"}]'::jsonb, 'd', 'الخروف حيوانٌ أليف يربّيه الإنسان ويعطينا الصوف، أمّا الباقي فحيواناتٌ برّية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الحظيرة والغابة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('22ae602f-d1da-5984-af03-003afdae5e1b', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'حيوانٌ يعطيه الإنسان الأكل والمأوى ويعتني به. كيف نصنّفه؟', '[{"id":"a","text":"أليف"},{"id":"b","text":"برّي"},{"id":"c","text":"نبات"},{"id":"d","text":"لا نستطيع معرفته"}]'::jsonb, 'a', 'العناية بالحيوان وتوفير الأكل والمأوى له علامةُ أنّه حيوانٌ أليف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1827a62-5275-59d7-9e4e-b77d4907b18a', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'أيّ مجموعةٍ كلّها حيوانات أليفة؟', '[{"id":"a","text":"الأسد، الغزال، الفيل"},{"id":"b","text":"الثعلب، الأرنب البرّي، الغزال"},{"id":"c","text":"الفيل، الأسد، الدجاجة"},{"id":"d","text":"البقرة، الدجاجة، الكلب"}]'::jsonb, 'd', 'البقرة والدجاجة والكلب يربّيها الإنسان ويعتني بها، فهي كلّها أليفة. أمّا المجموعات الأخرى ففيها حيواناتٌ برّية كالأسد والغزال والفيل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d10f923f-c1cd-5766-8e59-bdf24e235174', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'لماذا نقول إنّ الأسد حيوانٌ برّي؟', '[{"id":"a","text":"لأنّه كبير الحجم فقط"},{"id":"b","text":"لأنّه يعيش حُرًّا في الطبيعة ولا يربّيه الإنسان"},{"id":"c","text":"لأنّه يأكل اللحم فقط"},{"id":"d","text":"لأنّ لونه أصفر"}]'::jsonb, 'b', 'ما يجعل الحيوان برّيًّا هو أنّه يعيش حُرًّا ويبحث بنفسه عن أكله ومأواه، لا حجمه ولا لونه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21423bd3-10ab-517a-81b0-a80f881e7c30', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'قال طفل: «كلّ حيوانٍ كبيرٍ هو حيوانٌ برّي». ما الصحيح؟', '[{"id":"a","text":"صحيح، الحجم هو الذي يحدّد النوع"},{"id":"b","text":"كلّ حيوانٍ صغيرٍ أليف"},{"id":"c","text":"البقرة كبيرةٌ لكنّها أليفة؛ المهمّ هل يربّيه الإنسان"},{"id":"d","text":"الحيوانات الكبيرة نباتات"}]'::jsonb, 'c', 'الخطأ الشائع: ربط النوع بالحجم. البقرة والفيل كلاهما كبير، لكنّ البقرة أليفة (يربّيها الإنسان) والفيل برّي. المعيار هو التربية لا الحجم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d43d67c1-7018-5d3b-9f25-5f68c284dbe5', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'أرنبٌ يعيش في الغابة ويبحث عن أكله بنفسه. ما نوعه؟', '[{"id":"a","text":"أليف لأنّ الأرنب يُربّى دائمًا"},{"id":"b","text":"برّي لأنّه يعيش حُرًّا ولا يربّيه أحد"},{"id":"c","text":"ليس حيوانًا"},{"id":"d","text":"يعيش في البحر"}]'::jsonb, 'b', 'الخطأ الشائع: الظنّ أنّ كلّ أرنبٍ أليف. الأرنب الذي يعيش حُرًّا في الغابة برّي، أمّا الذي نربّيه في البيت فأليف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3be6e676-b090-5fa5-b9bb-6ff258817c02', '14e554f8-96ae-55e0-aa1f-6946b7fc8b1d', 'هذا الحيوان يربّيه الفلّاح ويعطينا الحليب. ما نوعه؟<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="62" cy="52" rx="34" ry="20" fill="#fcd34d"/><circle cx="98" cy="44" r="13" fill="#fcd34d"/><ellipse cx="100" cy="48" rx="6" ry="4" fill="#fb7185"/><path d="M90 34 q-3 -9 3 -10 M106 34 q3 -9 -3 -10" fill="#a16207"/><path d="M40 70 l0 14 M54 72 l0 14 M72 72 l0 14 M86 70 l0 14"/><ellipse cx="50" cy="46" rx="7" ry="9" fill="#f3f4f6"/><ellipse cx="70" cy="56" rx="9" ry="7" fill="#f3f4f6"/><circle cx="95" cy="40" r="2" fill="#1f2937" stroke="none"/></g></svg>', '[{"id":"a","text":"حيوانٌ برّي يعيش في الغابة"},{"id":"b","text":"حيوانٌ يطير بجناحيه"},{"id":"c","text":"حيوانٌ أليف (بقرة) يربّيه الفلّاح"},{"id":"d","text":"حيوانٌ يعيش في البحر"}]'::jsonb, 'c', 'الصورة تُظهر بقرةً بقرنين وبقعٍ على جسمها؛ وهي حيوانٌ أليف يربّيه الفلّاح ويعطينا الحليب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('143ab983-302e-57f2-b038-75f134f0e264', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: في المزرعة والغابة (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('434389da-6cc5-5b25-bfb5-37ba886c30e3', '143ab983-302e-57f2-b038-75f134f0e264', 'الكلب يحرس البيت ويربّيه الإنسان. ما نوعه؟', '[{"id":"a","text":"برّي"},{"id":"b","text":"أليف"},{"id":"c","text":"نبات"},{"id":"d","text":"سمكة"}]'::jsonb, 'b', 'الكلب يربّيه الإنسان ويعتني به ويحرس البيت، فهو حيوانٌ أليف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bc32620-074c-54c1-b395-c9c7b50e6a64', '143ab983-302e-57f2-b038-75f134f0e264', 'أين يبحث الحيوان البرّي عن أكله؟', '[{"id":"a","text":"يعطيه الإنسان الأكل في البيت"},{"id":"b","text":"في القنّ"},{"id":"c","text":"يبحث عنه بنفسه في الطبيعة"},{"id":"d","text":"لا يأكل أبدًا"}]'::jsonb, 'c', 'الحيوان البرّي يعيش حُرًّا، فيبحث بنفسه عن أكله ومأواه في الطبيعة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8360fa2-cd52-59e5-8815-75786b86fa1e', '143ab983-302e-57f2-b038-75f134f0e264', 'أيّ هذه الحيوانات يعطينا الصوف؟', '[{"id":"a","text":"الخروف"},{"id":"b","text":"الأسد"},{"id":"c","text":"الثعلب"},{"id":"d","text":"الغزال"}]'::jsonb, 'a', 'الخروف حيوانٌ أليف يربّيه الإنسان، وهو يعطينا الصوف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f23a2645-ee18-5f18-bd61-52b921e5e8af', '143ab983-302e-57f2-b038-75f134f0e264', 'هذا الحيوان يعيش حُرًّا ويجري بسرعةٍ في البَرّ. ما نوعه؟', '[{"id":"a","text":"أليف يربّيه الفلّاح"},{"id":"b","text":"برّي"},{"id":"c","text":"يعيش في البيت"},{"id":"d","text":"يعيش في القنّ"}]'::jsonb, 'b', 'الحيوان الذي يعيش حُرًّا في البَرّ ولا يربّيه أحد، مثل الغزال، هو حيوانٌ برّي.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('877861a6-03b7-5546-9a8a-a57ca70d4f61', '143ab983-302e-57f2-b038-75f134f0e264', 'ما الفرق الأساسي بين الحيوان الأليف والحيوان البرّي؟', '[{"id":"a","text":"اللون فقط"},{"id":"b","text":"الحجم فقط"},{"id":"c","text":"عدد الأرجل"},{"id":"d","text":"الأليف يربّيه الإنسان، والبرّي يعيش حُرًّا"}]'::jsonb, 'd', 'الفرق الأساسي هو العناية: الأليف يربّيه الإنسان، أمّا البرّي فيعيش حُرًّا في الطبيعة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db004e16-1359-5d79-825a-aed7d2f5dd06', '143ab983-302e-57f2-b038-75f134f0e264', 'هذا الحيوان يطير ويعيش حُرًّا في الطبيعة. ما نوعه؟<svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="58" cy="52" rx="24" ry="13" fill="#22c55e"/><circle cx="82" cy="44" r="10" fill="#22c55e"/><path d="M90 42 l12 -3 l-11 7 z" fill="#f59e0b" stroke="none"/><circle cx="84" cy="42" r="2" fill="#1f2937" stroke="none"/><path d="M46 48 q-20 -24 -32 -12 q14 4 28 20 z" fill="#16a34a"/><path d="M44 60 l-8 14 M56 62 l-3 16"/></g></svg>', '[{"id":"a","text":"حيوانٌ برّي (عصفور) يعيش حُرًّا"},{"id":"b","text":"حيوانٌ أليف يربّيه الإنسان في البيت"},{"id":"c","text":"حيوانٌ يسبح في الماء"},{"id":"d","text":"نباتٌ أخضر"}]'::jsonb, 'a', 'الصورة تُظهر عصفورًا له جناحٌ ومنقار؛ والعصافير البرّية تعيش حُرّةً في الطبيعة وتطير.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('12e4428a-2eff-5ddf-84ea-5271cc4db619', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد التصنيف', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('227a4a0d-2dc8-552d-b85e-3c386ac3b943', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'نريد ترتيب الحيوانات في خانتين: «أليف» و«برّي». أين نضع البقرة؟', '[{"id":"a","text":"في خانة «أليف»"},{"id":"b","text":"في خانة «برّي»"},{"id":"c","text":"في خانة النباتات"},{"id":"d","text":"لا توضع في أيّ خانة"}]'::jsonb, 'a', 'البقرة يربّيها الفلّاح ويعتني بها، فتوضع في خانة «أليف».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d1e83f0-b56f-5ae7-a670-79a6247d2e93', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'حيوانٌ يعيش في الصحراء حُرًّا ويبحث عن أكله بنفسه. في أيّ خانة نضعه؟', '[{"id":"a","text":"خانة «أليف»"},{"id":"b","text":"خانة «برّي»"},{"id":"c","text":"خانة «يربّيه الإنسان»"},{"id":"d","text":"خانة «يعيش في البيت»"}]'::jsonb, 'b', 'العيش حُرًّا في الصحراء والبحث عن الأكل بالنفس علامةُ الحيوان البرّي، فيوضع في خانة «برّي».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ef0d4f3-b7ff-56e5-bb02-2e322b35b5ea', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'في مزرعةٍ: بقرةٌ ودجاجةٌ وكلب. وفي الغابة: أسدٌ وغزال. كم حيوانًا أليفًا في القائمة؟', '[{"id":"a","text":"حيوانان (2)"},{"id":"b","text":"خمسة (5)"},{"id":"c","text":"ثلاثة (3)"},{"id":"d","text":"لا يوجد أليف"}]'::jsonb, 'c', 'الأليفة هي البقرة والدجاجة والكلب، أي ثلاثة (3). أمّا الأسد والغزال فبرّيان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6e33470-7abb-5335-a73d-78b0e219cee8', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'قال طفل: «الحيوان الذي يأكل اللحم هو دائمًا برّي». ما الصحيح؟', '[{"id":"a","text":"صحيح، آكلات اللحم كلّها برّية"},{"id":"b","text":"القطّ يأكل اللحم لكنّه أليف؛ المعيار هو التربية لا نوع الأكل"},{"id":"c","text":"كلّ آكلات اللحم نباتات"},{"id":"d","text":"الحيوانات لا تأكل اللحم"}]'::jsonb, 'b', 'الخطأ الشائع: ربط النوع بالغذاء. القطّ والكلب يأكلان اللحم وهما أليفان لأنّ الإنسان يربّيهما. المعيار هو العناية، لا نوع الأكل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('047defe7-b4fd-5600-bd2e-9e7bcc19fed8', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"الأسد أليف لأنّه قويّ"},{"id":"b","text":"الدجاجة برّية لأنّها صغيرة"},{"id":"c","text":"كلّ الحيوانات أليفة"},{"id":"d","text":"البقرة أليفة والأسد برّي"}]'::jsonb, 'd', 'البقرة يربّيها الإنسان (أليفة) والأسد يعيش حُرًّا (برّي). أمّا بقيّة الجمل ففيها خلطٌ بين النوع والقوّة أو الحجم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7162a7a7-c5fd-5927-af4d-9488bfe1e3cf', '12e4428a-2eff-5ddf-84ea-5271cc4db619', 'هذا الحيوان نربّيه في المزرعة ويعطينا البيض. أين نضعه في التصنيف؟<svg viewBox="0 0 110 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="54" cy="56" rx="24" ry="22" fill="#f9fafb"/><circle cx="54" cy="30" r="13" fill="#f9fafb"/><path d="M50 18 q4 -8 8 0 q-4 -2 -8 0 z" fill="#ef4444"/><path d="M62 31 l10 -2 l-9 6 z" fill="#f59e0b" stroke="none"/><circle cx="58" cy="29" r="2" fill="#1f2937" stroke="none"/><path d="M44 76 l-3 8 M58 78 l0 8" /><path d="M30 56 q-10 -6 -4 8" fill="#fcd34d"/></g></svg>', '[{"id":"a","text":"في خانة «أليف» (دجاجة)"},{"id":"b","text":"في خانة «برّي»"},{"id":"c","text":"في خانة «يعيش في الغابة»"},{"id":"d","text":"في خانة «نبات»"}]'::jsonb, 'a', 'الصورة تُظهر دجاجةً لها عُرفٌ أحمر ومنقار؛ وهي حيوانٌ أليف نربّيه في المزرعة ويعطينا البيض، فتوضع في خانة «أليف».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f9164a09-8b42-5093-b57b-037edbaf9f33', '26822027-6ba8-5c53-8b8e-6dc554defe00', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لعالم الحيوان', 3, 120, 30, 'boss', 'admin', 5)
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
  ('523b0bb4-d3de-57b1-8f46-7e3a63d136bd', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'أكمل: الحيوان الذي يربّيه الإنسان ويعتني به يُسمّى حيوانًا …', '[{"id":"a","text":"أليفًا"},{"id":"b","text":"برّيًّا"},{"id":"c","text":"نباتًا"},{"id":"d","text":"طائرًا فقط"}]'::jsonb, 'a', 'الحيوان الذي يربّيه الإنسان ويعتني به يُسمّى حيوانًا أليفًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3101a2c3-1b50-5891-b32e-776dd412b7cb', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'أين يعيش الغزال؟', '[{"id":"a","text":"في القنّ"},{"id":"b","text":"في الحظيرة"},{"id":"c","text":"حُرًّا في البَرّ"},{"id":"d","text":"في البيت"}]'::jsonb, 'c', 'الغزال حيوانٌ برّي يعيش حُرًّا في البَرّ، ولا يربّيه الإنسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca1d08a6-635b-55d3-8b35-710f364cdb03', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'أيّ زوجٍ صحيح: حيوان ← ما يعطينا؟', '[{"id":"a","text":"الأسد ← الحليب"},{"id":"b","text":"الغزال ← البيض"},{"id":"c","text":"الثعلب ← الصوف"},{"id":"d","text":"البقرة ← الحليب"}]'::jsonb, 'd', 'البقرة حيوانٌ أليف تعطينا الحليب. أمّا الأسد والغزال والثعلب فبرّية ولا تُربّى لمنفعة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f8a91eb-bb59-53c7-9850-bbf3357c15b0', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'ولدٌ يربّي أرنبًا في قفصٍ في البيت ويطعمه كلّ يوم. ما نوع هذا الأرنب؟', '[{"id":"a","text":"برّي لأنّ الأرانب تعيش في الغابة"},{"id":"b","text":"أليف لأنّ الإنسان يربّيه ويطعمه"},{"id":"c","text":"ليس حيوانًا"},{"id":"d","text":"يعيش في الماء"}]'::jsonb, 'b', 'الخطأ الشائع: الحكم على الحيوان بنوعه العامّ. هذا الأرنب يربّيه الإنسان ويطعمه، فهو أليف، حتّى لو وُجِدت أرانب برّية في الغابة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13aa8436-6ff2-51cc-bd3d-e9e9451f29ba', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'صنّف: «الفيل، الكلب، الأسد». ما الصحيح؟', '[{"id":"a","text":"كلّها أليفة"},{"id":"b","text":"كلّها برّية"},{"id":"c","text":"الكلب أليف، والفيل والأسد برّيان"},{"id":"d","text":"الفيل أليف، والكلب برّي"}]'::jsonb, 'c', 'الكلب يربّيه الإنسان (أليف)، أمّا الفيل والأسد فيعيشان حُرّين في الطبيعة (برّيان).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bf254bf-2332-5712-9375-a6c92e54010a', 'f9164a09-8b42-5093-b57b-037edbaf9f33', 'هذا الحيوان يعيش حُرًّا في الغابة. في أيّ خانةٍ نضعه؟<svg viewBox="0 0 120 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="60" cy="48" r="22" fill="#b45309"/><circle cx="60" cy="48" r="14" fill="#f59e0b"/><path d="M60 26 v-6 M44 32 l-4 -5 M76 32 l4 -5 M38 48 h-6 M82 48 h6 M44 64 l-4 5 M76 64 l4 5 M60 70 v6" stroke="#92400e"/><circle cx="53" cy="45" r="2.5" fill="#1f2937" stroke="none"/><circle cx="67" cy="45" r="2.5" fill="#1f2937" stroke="none"/><path d="M55 54 q5 4 10 0" fill="none"/></g></svg>', '[{"id":"a","text":"خانة «أليف»"},{"id":"b","text":"خانة «برّي» (أسد)"},{"id":"c","text":"خانة «يربّيه الفلّاح»"},{"id":"d","text":"خانة «يعطينا الحليب»"}]'::jsonb, 'b', 'الصورة تُظهر أسدًا بلَبدةٍ حول وجهه؛ وهو حيوانٌ برّي يعيش حُرًّا في الغابة، فيوضع في خانة «برّي».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d088f26a-cc6d-5be1-97ea-070d39311c16', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5edf3a85-ea24-5cf8-9672-d438936778a6', 'd088f26a-cc6d-5be1-97ea-070d39311c16', 'ما هي النبتة المغروسة؟', '[{"id":"a","text":"نبتةٌ يغرسها الإنسان ويعتني بها"},{"id":"b","text":"نبتةٌ تنبت وحدها في الغابة"},{"id":"c","text":"نبتةٌ تعيش في البحر فقط"},{"id":"d","text":"نبتةٌ لا تحتاج إلى الماء أبدًا"}]'::jsonb, 'a', 'النبتة المغروسة يغرسها الإنسان ويعتني بها فيسقيها ويحرسها، مثل القمح والوردة المغروسة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfe3f614-0d0b-5dd0-b4ab-731fc5eead5c', 'd088f26a-cc6d-5be1-97ea-070d39311c16', 'أين تنبت النباتات التلقائية عادةً؟', '[{"id":"a","text":"في الأصيص الذي يضعه الإنسان"},{"id":"b","text":"وحدها على جوانب الطرقات وفي الغابة"},{"id":"c","text":"في الحقل الذي يحرثه الفلّاح"},{"id":"d","text":"في الحديقة التي يعتني بها الإنسان"}]'::jsonb, 'b', 'النبتة التلقائية تنبت وحدها في الطبيعة، مثل جوانب الطرقات والغابة، دون أن يغرسها أحد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b9f5e36-e17c-5737-958d-66c065e0b9dd', 'd088f26a-cc6d-5be1-97ea-070d39311c16', 'أيّ هذه النباتات يغرسها الفلّاح ويعتني بها؟', '[{"id":"a","text":"العُشب البرّي"},{"id":"b","text":"الأشواك على الطريق"},{"id":"c","text":"القمح"},{"id":"d","text":"زهور الأقحوان البرّية"}]'::jsonb, 'c', 'القمح نبتةٌ مغروسة يزرعها الفلّاح في الحقل ويسقيها، أمّا الباقي فينبت وحده فهو تلقائي.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34f08ce5-4e1c-597e-9f2d-aa2bd9e956dd', 'd088f26a-cc6d-5be1-97ea-070d39311c16', 'أين يغرس الإنسان نباتاته؟', '[{"id":"a","text":"في وسط البحر"},{"id":"b","text":"في الصحراء وحدها"},{"id":"c","text":"في أعالي السحاب"},{"id":"d","text":"في الحقل والحديقة والأصيص"}]'::jsonb, 'd', 'الإنسان يغرس نباتاته حيث يعتني بها: في الحقل والحديقة والأصيص قُرب البيت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bdd30ec-5d17-54b4-8104-64acc96e6376', 'd088f26a-cc6d-5be1-97ea-070d39311c16', 'ما السؤال الذي نطرحه لنعرف نوع النبتة؟', '[{"id":"a","text":"هل غرسها الإنسان واعتنى بها؟"},{"id":"b","text":"هل لونها أخضر؟"},{"id":"c","text":"هل هي طويلة؟"},{"id":"d","text":"هل لها أزهار؟"}]'::jsonb, 'a', 'نسأل: هل غرسها الإنسان واعتنى بها؟ نعم ← مغروسة، لا ← تلقائية. اللون والطول والأزهار لا تحدّد النوع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('365371e8-99b7-5a05-8f9e-18f550d15dac', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', '⭐ تمرين: مغروسة أم تلقائية؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('400c97c7-0bf5-5c6b-8ca6-7e11a583a4d6', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'الفلّاح زرع القمح في الحقل ويسقيه كلّ يوم. هل القمح نبتةٌ مغروسة أم تلقائية؟', '[{"id":"a","text":"مغروسة"},{"id":"b","text":"تلقائية"},{"id":"c","text":"لا مغروسة ولا تلقائية"},{"id":"d","text":"حيوانٌ وليس نباتًا"}]'::jsonb, 'a', 'الفلّاح غرس القمح ويسقيه ويعتني به، فالقمح نبتةٌ مغروسة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8380f141-0ea0-5fd0-893b-b5e56efee5e7', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'عُشبٌ نبت وحده على جانب الطريق دون أن يغرسه أحد. ما نوعه؟', '[{"id":"a","text":"مغروسة"},{"id":"b","text":"تلقائية"},{"id":"c","text":"يغرسها الفلّاح في الحقل"},{"id":"d","text":"تنمو في الأصيص داخل البيت"}]'::jsonb, 'b', 'العُشب نبت وحده على الطريق ولم يغرسه أحد، فهو نبتةٌ تلقائية.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c22abb2-f364-5907-891d-756634524d19', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'هذه نبتةٌ في أصيصٍ يسقيها الإنسان بالماء. ما نوعها؟<svg viewBox="0 0 130 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M40 64 h44 l-7 28 h-30 z" fill="#b45309"/><rect x="36" y="58" width="52" height="8" rx="2" fill="#a16207"/><path d="M62 58 v-22" stroke="#16a34a" stroke-width="3"/><path d="M62 46 q-16 -4 -20 -16 q14 0 20 12 z" fill="#22c55e"/><path d="M62 40 q16 -4 20 -16 q-14 0 -20 12 z" fill="#22c55e"/><circle cx="62" cy="30" r="7" fill="#ef4444"/><path d="M104 24 l-6 12 M110 30 l-9 9 M100 20 l-3 13" stroke="#3b82f6" stroke-width="2"/></g></svg>', '[{"id":"a","text":"مغروسة، لأنّ الإنسان غرسها في الأصيص ويسقيها"},{"id":"b","text":"تلقائية، لأنّها نبتت وحدها في الغابة"},{"id":"c","text":"تلقائية، لأنّها على جانب الطريق"},{"id":"d","text":"ليست نبتةً"}]'::jsonb, 'a', 'الصورة تُظهر نبتةً في أصيصٍ تُسقى بالماء؛ الإنسان غرسها ويعتني بها، فهي مغروسة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d10536c6-8f0e-5492-96d5-b3edcc0e7f6d', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'أين يغرس الفلّاح القمح؟', '[{"id":"a","text":"في وسط البحر"},{"id":"b","text":"على سطح القمر"},{"id":"c","text":"في الحقل"},{"id":"d","text":"في باطن الصخر"}]'::jsonb, 'c', 'الفلّاح يغرس القمح في الحقل ويسقيه ويعتني به حتّى ينضج.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c5420fe-9426-5b0c-871a-5777e68d0e47', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'أيّ هذه نبتةٌ تلقائية تنبت وحدها؟', '[{"id":"a","text":"الطماطم في الحقل"},{"id":"b","text":"الوردة في الحديقة"},{"id":"c","text":"شجرة الفواكه في البستان"},{"id":"d","text":"العُشب البرّي على جانب الطريق"}]'::jsonb, 'd', 'العُشب البرّي على جانب الطريق ينبت وحده دون أن يغرسه أحد، فهو تلقائي. أمّا الطماطم والوردة والشجرة فيغرسها الإنسان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a674224-fd62-5640-8e9d-729266e93904', '365371e8-99b7-5a05-8f9e-18f550d15dac', 'الوردة في حديقة البيت غرسها الإنسان ويسقيها. ما نوعها؟', '[{"id":"a","text":"تلقائية لأنّ الورد جميل"},{"id":"b","text":"مغروسة لأنّ الإنسان غرسها واعتنى بها"},{"id":"c","text":"ليست نباتًا"},{"id":"d","text":"تعيش في الماء"}]'::jsonb, 'b', 'الوردة في الحديقة غرسها الإنسان ويسقيها ويعتني بها، فهي نبتةٌ مغروسة. الجمال لا يحدّد النوع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9ad95a5c-5f7b-5ac3-8834-4064420a0bed', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الحقل والغابة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('c7142227-4dfe-5894-a6e7-347d7543b942', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'نبتةٌ غرسها الإنسان في الحديقة ويسقيها ويحرسها. كيف نصنّفها؟', '[{"id":"a","text":"مغروسة"},{"id":"b","text":"تلقائية"},{"id":"c","text":"حيوان"},{"id":"d","text":"لا نستطيع معرفتها"}]'::jsonb, 'a', 'غرس الإنسان للنبتة والعناية بها (سقي وحراسة) علامةُ أنّها نبتةٌ مغروسة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b4585eb-a192-5e9b-bd35-857370832357', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'أيّ مجموعةٍ كلّها نباتات مغروسة؟', '[{"id":"a","text":"العُشب البرّي، الأشواك، الأقحوان البرّي"},{"id":"b","text":"الأشواك، العُشب على الطريق، القمح"},{"id":"c","text":"العُشب البرّي، الطماطم، الأشواك"},{"id":"d","text":"القمح، الطماطم، الوردة المغروسة"}]'::jsonb, 'd', 'القمح والطماطم والوردة المغروسة يغرسها الإنسان ويعتني بها، فهي كلّها مغروسة. أمّا المجموعات الأخرى ففيها نباتاتٌ تلقائية كالعُشب البرّي والأشواك.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f6694d1-bebd-5b09-ac84-dbeac2137d5f', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'لماذا نقول إنّ العُشب على جانب الطريق نبتةٌ تلقائية؟', '[{"id":"a","text":"لأنّه أخضر اللون فقط"},{"id":"b","text":"لأنّه نبت وحده ولم يغرسه الإنسان"},{"id":"c","text":"لأنّه قصير الطول فقط"},{"id":"d","text":"لأنّه قريبٌ من البيوت"}]'::jsonb, 'b', 'ما يجعل النبتة تلقائية هو أنّها نبتت وحدها دون أن يغرسها أحد، لا لونها ولا طولها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07d15b15-1d40-5f3b-b7b9-4835258bd368', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'قالت طفلة: «كلّ نبتةٍ لها أزهار جميلة هي مغروسة». ما الصحيح؟', '[{"id":"a","text":"صحيح، الأزهار هي التي تحدّد النوع"},{"id":"b","text":"كلّ نبتةٍ بلا أزهار تلقائية"},{"id":"c","text":"الأقحوان البرّي له أزهار لكنّه تلقائي؛ المهمّ مَن غرسها"},{"id":"d","text":"النباتات المُزهِرة حيوانات"}]'::jsonb, 'c', 'الخطأ الشائع: ربط النوع بالأزهار. الأقحوان البرّي له أزهار جميلة لكنّه ينبت وحده فهو تلقائي. المعيار هو مَن غرس النبتة، لا وجود الأزهار.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2954a24-5f6f-5f15-a81f-91ead78d8aa9', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'زهرةٌ نبتت وحدها على جانب الطريق ولم يغرسها أحد. ما نوعها؟', '[{"id":"a","text":"مغروسة لأنّ الزهور يغرسها الإنسان دائمًا"},{"id":"b","text":"تلقائية لأنّها نبتت وحدها ولم يغرسها أحد"},{"id":"c","text":"ليست نبتةً"},{"id":"d","text":"تنمو في الماء فقط"}]'::jsonb, 'b', 'الخطأ الشائع: الظنّ أنّ كلّ زهرةٍ مغروسة. الزهرة التي نبتت وحدها على الطريق تلقائية، أمّا التي يغرسها الإنسان في الحديقة فمغروسة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('151ecd05-aefe-5871-8fc6-7cadf964e59e', '9ad95a5c-5f7b-5ac3-8834-4064420a0bed', 'هذه نبتةٌ نبتت وحدها على جانب الطريق. ما نوعها؟<svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><rect x="6" y="80" width="138" height="14" fill="#9ca3af"/><path d="M6 87 h28 M52 87 h26 M96 87 h26" stroke="#fcd34d" stroke-width="2" stroke-dasharray="8 7"/><path d="M126 80 q-6 -22 2 -34 q4 14 -2 34 z" fill="#22c55e"/><path d="M132 80 q8 -18 18 -22 q-6 14 -18 22 z" fill="#16a34a"/><path d="M120 80 q-10 -14 -18 -16 q8 10 18 16 z" fill="#16a34a"/><circle cx="134" cy="40" r="5" fill="#fb7185"/></g></svg>', '[{"id":"a","text":"مغروسة، يغرسها الفلّاح في الحقل"},{"id":"b","text":"مغروسة، في أصيصٍ داخل البيت"},{"id":"c","text":"تلقائية، نبتت وحدها على جانب الطريق"},{"id":"d","text":"ليست نبتةً"}]'::jsonb, 'c', 'الصورة تُظهر عُشبًا نبت وحده على جانب الطريق؛ لم يغرسه أحد، فهو نبتةٌ تلقائية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1981da26-1cdd-551b-b708-33e6b47d4be1', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: في الحقل والطريق (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('e2a3b8bc-07f2-5187-a81f-0478fb4db0c1', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'أكمل: النبتة التي يغرسها الإنسان ويعتني بها تُسمّى نبتةً …', '[{"id":"a","text":"تلقائية"},{"id":"b","text":"مغروسة"},{"id":"c","text":"حيوانًا"},{"id":"d","text":"حجرًا"}]'::jsonb, 'b', 'النبتة التي يغرسها الإنسان ويعتني بها تُسمّى نبتةً مغروسة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e59ccad4-4632-5196-9205-6cfcfc1c2783', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'كيف تنبت النبتة التلقائية؟', '[{"id":"a","text":"يغرسها الفلّاح في صفوف"},{"id":"b","text":"يضعها الإنسان في الأصيص"},{"id":"c","text":"تنبت وحدها في الطبيعة"},{"id":"d","text":"لا تنبت أبدًا"}]'::jsonb, 'c', 'النبتة التلقائية تنبت وحدها في الطبيعة دون أن يغرسها أحد أو يعتني بها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('956361a8-6b3b-5265-bdb2-7ca5e7fc156c', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'أيّ هذه النباتات يعتني بها الإنسان ويسقيها؟', '[{"id":"a","text":"أشجار الفواكه في البستان"},{"id":"b","text":"العُشب على جانب الطريق"},{"id":"c","text":"الأشواك في الغابة"},{"id":"d","text":"الأقحوان البرّي في الحقل"}]'::jsonb, 'a', 'أشجار الفواكه يغرسها الإنسان في البستان ويسقيها ويعتني بها، فهي مغروسة. أمّا الباقي فتلقائي ينبت وحده.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b9625b1-ada4-5440-8cb3-5847cd81e256', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'نبتةٌ نبتت وحدها بين الأشجار في الغابة. ما نوعها؟', '[{"id":"a","text":"مغروسة يغرسها الفلّاح"},{"id":"b","text":"تلقائية"},{"id":"c","text":"تنمو في أصيصٍ داخل البيت"},{"id":"d","text":"حيوانٌ يعيش في الغابة"}]'::jsonb, 'b', 'النبتة التي تنبت وحدها في الغابة دون أن يغرسها أحد هي نبتةٌ تلقائية.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('001e05e8-64c3-5ad8-8235-f4f885e12954', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'ما الفرق الأساسي بين النبتة المغروسة والنبتة التلقائية؟', '[{"id":"a","text":"اللون فقط"},{"id":"b","text":"الطول فقط"},{"id":"c","text":"عدد الأوراق"},{"id":"d","text":"المغروسة يغرسها الإنسان، والتلقائية تنبت وحدها"}]'::jsonb, 'd', 'الفرق الأساسي هو مَن غرس النبتة: المغروسة يغرسها الإنسان ويعتني بها، أمّا التلقائية فتنبت وحدها في الطبيعة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b709063c-4c0e-580b-8569-47086e0f9ac1', '1981da26-1cdd-551b-b708-33e6b47d4be1', 'هذا حقلٌ غرسه الفلّاح في صفوفٍ منظّمة ويعتني به. ما نوع هذه النباتات؟<svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><rect x="8" y="78" width="134" height="14" fill="#a16207"/><path d="M28 78 v-44 M58 78 v-50 M88 78 v-50 M118 78 v-44" stroke="#16a34a" stroke-width="3"/><ellipse cx="28" cy="30" rx="7" ry="12" fill="#fcd34d"/><ellipse cx="58" cy="24" rx="7" ry="13" fill="#f59e0b"/><ellipse cx="88" cy="24" rx="7" ry="13" fill="#f59e0b"/><ellipse cx="118" cy="30" rx="7" ry="12" fill="#fcd34d"/><path d="M24 36 l4 -4 l4 4 M54 30 l4 -4 l4 4 M84 30 l4 -4 l4 4 M114 36 l4 -4 l4 4" stroke="#f59e0b" fill="none"/></g></svg>', '[{"id":"a","text":"تلقائية نبتت وحدها على الطريق"},{"id":"b","text":"تلقائية في الغابة"},{"id":"c","text":"أعشابٌ برّية لا يعتني بها أحد"},{"id":"d","text":"مغروسة، غرسها الفلّاح في الحقل"}]'::jsonb, 'd', 'الصورة تُظهر حقل قمحٍ في صفوفٍ منظّمة غرسه الفلّاح ويعتني به؛ فهذه نباتاتٌ مغروسة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('07dc34d6-dd93-5c5c-b266-0491f1fdc26c', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد تصنيف النباتات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('42c1ffae-75a8-5930-8d05-698315105a55', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'نريد ترتيب النباتات في خانتين: «مغروسة» و«تلقائية». أين نضع القمح الذي يزرعه الفلّاح؟', '[{"id":"a","text":"في خانة «مغروسة»"},{"id":"b","text":"في خانة «تلقائية»"},{"id":"c","text":"في خانة الحيوانات"},{"id":"d","text":"لا يوضع في أيّ خانة"}]'::jsonb, 'a', 'القمح يزرعه الفلّاح ويسقيه ويعتني به، فيوضع في خانة «مغروسة».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('404fb1f3-caff-5a39-85ae-83b4034c1c46', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'نبتةٌ نبتت وحدها بين الصخور في الجبل ولم يغرسها أحد. في أيّ خانة نضعها؟', '[{"id":"a","text":"خانة «مغروسة»"},{"id":"b","text":"خانة «تلقائية»"},{"id":"c","text":"خانة «يغرسها الإنسان»"},{"id":"d","text":"خانة «تنمو في الأصيص»"}]'::jsonb, 'b', 'النبتة التي تنبت وحدها في الطبيعة دون أن يغرسها أحد تلقائية، فتوضع في خانة «تلقائية».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18019a79-b782-5887-91ad-63d04a9e4870', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'في حديقةٍ: قمحٌ وطماطمُ ووردةٌ مغروسة. وعلى الطريق: عُشبٌ برّي وأشواك. كم نبتةً مغروسةً في القائمة؟', '[{"id":"a","text":"نبتتان (2)"},{"id":"b","text":"خمسٌ (5)"},{"id":"c","text":"ثلاثٌ (3)"},{"id":"d","text":"لا توجد مغروسة"}]'::jsonb, 'c', 'المغروسة هي القمح والطماطم والوردة المغروسة، أي ثلاثٌ (3). أمّا العُشب البرّي والأشواك فتلقائية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc49188e-de66-5ea7-99df-fa62aca65d64', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'قال طفل: «النبتة الطويلة دائمًا مغروسة، والقصيرة تلقائية». ما الصحيح؟', '[{"id":"a","text":"صحيح، الطول هو الذي يحدّد النوع"},{"id":"b","text":"الأشواك البرّية قد تطول لكنّها تلقائية؛ المعيار مَن غرسها لا الطول"},{"id":"c","text":"كلّ النباتات القصيرة حيوانات"},{"id":"d","text":"النباتات لا تطول أبدًا"}]'::jsonb, 'b', 'الخطأ الشائع: ربط النوع بالطول. توجد أعشابٌ تلقائية طويلة وأخرى مغروسة قصيرة. المعيار هو مَن غرس النبتة واعتنى بها، لا طولها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87dc255b-a218-5b43-91e7-ac457d9b8510', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"القمح تلقائي لأنّه أصفر"},{"id":"b","text":"العُشب البرّي مغروسٌ لأنّه أخضر"},{"id":"c","text":"كلّ النباتات مغروسة"},{"id":"d","text":"القمح مغروسٌ والعُشب البرّي تلقائي"}]'::jsonb, 'd', 'القمح يغرسه الفلّاح (مغروس) والعُشب البرّي ينبت وحده (تلقائي). أمّا بقيّة الجمل ففيها خلطٌ بين النوع واللون.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9753e100-ea99-549a-90d8-9c6674e49d4c', '07dc34d6-dd93-5c5c-b266-0491f1fdc26c', 'هذه نبتةٌ في أصيصٍ يسقيها الإنسان. أين نضعها في التصنيف؟<svg viewBox="0 0 130 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M42 66 h44 l-7 26 h-30 z" fill="#b45309"/><rect x="38" y="60" width="52" height="8" rx="2" fill="#a16207"/><path d="M64 60 v-26" stroke="#16a34a" stroke-width="3"/><path d="M64 48 q-16 -3 -20 -16 q14 0 20 12 z" fill="#22c55e"/><path d="M64 42 q16 -3 20 -16 q-14 0 -20 12 z" fill="#22c55e"/><circle cx="64" cy="30" r="7" fill="#fb7185"/><path d="M106 26 l-6 12 M112 32 l-9 9 M102 22 l-3 13" stroke="#3b82f6" stroke-width="2"/></g></svg>', '[{"id":"a","text":"في خانة «مغروسة»، لأنّ الإنسان غرسها في الأصيص ويسقيها"},{"id":"b","text":"في خانة «تلقائية»، نبتت وحدها"},{"id":"c","text":"في خانة «على جانب الطريق»"},{"id":"d","text":"في خانة «حيوان»"}]'::jsonb, 'a', 'الصورة تُظهر نبتةً في أصيصٍ تُسقى بالماء؛ الإنسان غرسها ويعتني بها، فتوضع في خانة «مغروسة».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cab090db-5fbb-58b5-9f37-564651872e9d', '71b03ac5-1f3c-5fdf-9471-89e65eae9fd8', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لعالم النبات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('a120aa6b-4d3b-56e9-80e0-5de88a16ae8e', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'أكمل: النبتة التي تنبت وحدها في الطبيعة دون أن يغرسها أحد تُسمّى نبتةً …', '[{"id":"a","text":"تلقائية"},{"id":"b","text":"مغروسة"},{"id":"c","text":"حيوانًا"},{"id":"d","text":"أصيصًا"}]'::jsonb, 'a', 'النبتة التي تنبت وحدها دون أن يغرسها الإنسان تُسمّى نبتةً تلقائية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c40a70b2-b5f5-5d85-966d-af30d1801799', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'أين يغرس الإنسان الطماطم والخضر؟', '[{"id":"a","text":"على جوانب الطرقات وحدها"},{"id":"b","text":"في أعماق البحر"},{"id":"c","text":"في الحقل والحديقة"},{"id":"d","text":"في باطن الصخر"}]'::jsonb, 'c', 'الإنسان يغرس الطماطم والخضر في الحقل والحديقة ويسقيها ويعتني بها، فهي مغروسة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3544a9ce-9d2e-56c8-8b7c-b000d1d6ebb0', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'أيّ زوجٍ صحيح: نبتة ← نوعها؟', '[{"id":"a","text":"القمح ← تلقائية"},{"id":"b","text":"العُشب البرّي ← مغروسة"},{"id":"c","text":"الأشواك على الطريق ← مغروسة"},{"id":"d","text":"الوردة في الحديقة ← مغروسة"}]'::jsonb, 'd', 'الوردة في الحديقة يغرسها الإنسان فهي مغروسة. أمّا القمح فمغروس لا تلقائي، والعُشب البرّي والأشواك تلقائية لا مغروسة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66627e12-cbff-5280-8514-df937c7cdca8', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'نبتةٌ نبتت وحدها داخل الحقل بين سيقان القمح، ولم يزرعها الفلّاح. ما نوع هذه النبتة الدخيلة؟', '[{"id":"a","text":"مغروسة لأنّها داخل الحقل"},{"id":"b","text":"تلقائية لأنّها نبتت وحدها ولم يزرعها الفلّاح"},{"id":"c","text":"ليست نبتةً"},{"id":"d","text":"تعيش في الماء"}]'::jsonb, 'b', 'الخطأ الشائع: الحكم على النبتة بمكانها. هذه النبتة نبتت وحدها ولم يزرعها الفلّاح، فهي تلقائية، حتّى لو كانت داخل الحقل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6324bc19-4a98-5a43-a42e-ae6096020082', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'صنّف: «الطماطم، العُشب البرّي، الوردة المغروسة». ما الصحيح؟', '[{"id":"a","text":"كلّها مغروسة"},{"id":"b","text":"كلّها تلقائية"},{"id":"c","text":"الطماطم والوردة مغروستان، والعُشب البرّي تلقائي"},{"id":"d","text":"الطماطم تلقائية، والعُشب مغروس"}]'::jsonb, 'c', 'الطماطم والوردة المغروسة يغرسهما الإنسان (مغروستان)، أمّا العُشب البرّي فينبت وحده (تلقائي).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2e7d893-6723-5142-91aa-954b92f9da94', 'cab090db-5fbb-58b5-9f37-564651872e9d', 'زرع أحمد بذورًا في الحديقة وسقاها كلّ يوم حتّى صارت نباتاتٍ. ما نوع هذه النباتات؟', '[{"id":"a","text":"تلقائية لأنّها أصبحت كبيرة"},{"id":"b","text":"مغروسة لأنّ أحمد زرعها واعتنى بها"},{"id":"c","text":"تلقائية لأنّها في الحديقة"},{"id":"d","text":"حيوانات صغيرة"}]'::jsonb, 'b', 'أحمد زرع البذور بنفسه وسقاها واعتنى بها، فهذه النباتات مغروسة. حجمها الكبير لا يجعلها تلقائية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a853e0fa-99eb-530e-9a4f-d977b99288c0', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('acd80643-b0be-56ba-8cbb-5ff95a4f2414', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'ما هي الأجزاء الرئيسية الثلاثة لجسم الإنسان؟', '[{"id":"a","text":"العينان والأذنان والأنف"},{"id":"b","text":"الرأس والجذع والأطراف"},{"id":"c","text":"اليد والقدم والأصبع"},{"id":"d","text":"الشعر والجلد والأظافر"}]'::jsonb, 'b', 'لجسم الإنسان ثلاثة أجزاء رئيسية: الرأس في الأعلى، والجذع في الوسط، والأطراف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1bf4746-e9c0-58de-b9c9-c0a6be34408a', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'أين يوجد الرأس في الجسم؟', '[{"id":"a","text":"في الأسفل"},{"id":"b","text":"في وسط الجسم"},{"id":"c","text":"في الأعلى"},{"id":"d","text":"خلف الساقين"}]'::jsonb, 'c', 'الرأس هو الجزء الأعلى من الجسم، وفيه الوجه، أمّا الجذع ففي الوسط والأطراف في الجوانب والأسفل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc4fa748-002c-5390-9d20-18820233b1a0', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'الأطراف العلوية هي:', '[{"id":"a","text":"الذراعان واليدان"},{"id":"b","text":"الساقان والقدمان"},{"id":"c","text":"الرأس والرقبة"},{"id":"d","text":"الجذع والظهر"}]'::jsonb, 'a', 'الأطراف العلوية هي الذراعان واليدان، نحمل بهما ونكتب؛ أمّا الساقان والقدمان فهما الأطراف السفلية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fba0b1f-fffd-539e-bfdf-e279042a0528', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'ما الذي يسمح لنا بثني الذراع وتحريكها؟', '[{"id":"a","text":"الشعر"},{"id":"b","text":"الجلد"},{"id":"c","text":"اللون"},{"id":"d","text":"المفصل"}]'::jsonb, 'd', 'المفصل هو مكان التقاء العظمتين، وهو الذي يربط الأجزاء ويسمح بالثني والحركة، مثل المرفق والركبة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6b351fb-a6dd-5f50-a0e4-0fe4d097a0cd', 'a853e0fa-99eb-530e-9a4f-d977b99288c0', 'كيف نحافظ على سلامة الجسم ونتوقّى الحوادث؟', '[{"id":"a","text":"نجري بسرعة قرب الدرج"},{"id":"b","text":"نلبس الخوذة ونبتعد عن النار"},{"id":"c","text":"نلمس الماء الساخن لنجرّب"},{"id":"d","text":"نقفز من مكان عالٍ"}]'::jsonb, 'b', 'للحفاظ على السلامة نلبس الخوذة ونبتعد عن النار والدرج؛ أمّا الجري قرب الدرج ولمس الساخن والقفز من عالٍ فكلّها أسباب حوادث.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d406b796-1924-521f-abde-f22b82e82bd8', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', '⭐ تمرين: أجزاء جسمي ومفاصلي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('aadf873b-6b66-594f-b2ad-c613f7313e39', 'd406b796-1924-521f-abde-f22b82e82bd8', 'أين يوجد الجذع في الجسم؟', '[{"id":"a","text":"في وسط الجسم، يربط الرأس بالأطراف"},{"id":"b","text":"في أعلى الجسم فوق الرقبة"},{"id":"c","text":"في أسفل القدمين"},{"id":"d","text":"خارج الجسم"}]'::jsonb, 'a', 'الجذع هو الجزء الأوسط الكبير من الجسم، وهو الذي يربط الرأس بالأطراف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da3ce2cf-e8c4-50b5-a017-c938fa216837', 'd406b796-1924-521f-abde-f22b82e82bd8', 'بأيّ طرفٍ نمشي ونجري؟', '[{"id":"a","text":"بالذراعين"},{"id":"b","text":"باليدين"},{"id":"c","text":"بالساقين والقدمين"},{"id":"d","text":"بالرأس"}]'::jsonb, 'c', 'نمشي ونجري بالأطراف السفلية، وهي الساقان والقدمان؛ أمّا الذراعان واليدان فللحمل والكتابة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6c1bbc9-e560-5ae9-bf2f-8fefa8f8162a', 'd406b796-1924-521f-abde-f22b82e82bd8', 'الركبة مفصل. ماذا يفعل المفصل؟', '[{"id":"a","text":"يُغيّر لون الجلد"},{"id":"b","text":"يسمح بثني الطرف وتحريكه"},{"id":"c","text":"يجعل الشعر ينمو"},{"id":"d","text":"يمنع الحركة تمامًا"}]'::jsonb, 'b', 'المفصل يربط العظام ويسمح بثني الطرف وتحريكه؛ الركبة مفصل نثني به الساق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ae40ba1-2a2d-5d11-9459-6cbd5767dab0', 'd406b796-1924-521f-abde-f22b82e82bd8', 'أيّ هذه عادةٌ تحمي جسمي من الحوادث؟', '[{"id":"a","text":"الجري قرب الدرج"},{"id":"b","text":"لمس المكواة الساخنة"},{"id":"c","text":"القفز من مكان عالٍ"},{"id":"d","text":"لبس الخوذة عند ركوب الدرّاجة"}]'::jsonb, 'd', 'لبس الخوذة يحمي الرأس عند ركوب الدرّاجة؛ أمّا الجري قرب الدرج ولمس الساخن والقفز من عالٍ فكلّها أسباب حوادث.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60b3ab6d-6d17-59fd-adf1-59be9c35fd2b', 'd406b796-1924-521f-abde-f22b82e82bd8', 'في الصورة، أيّ جزءٍ من الجسم لوّنّاه بالأزرق؟<svg viewBox="0 0 110 150" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="55" cy="28" r="14" fill="#fcd34d"/><rect x="40" y="44" width="30" height="46" rx="8" fill="#3b82f6"/><path d="M40 52 l-16 24 M70 52 l16 24" fill="none" stroke="#fdba74" stroke-width="6"/><path d="M48 90 l-6 42 M62 90 l6 42" fill="none" stroke="#fdba74" stroke-width="7"/></g></svg>', '[{"id":"a","text":"الرأس"},{"id":"b","text":"الجذع"},{"id":"c","text":"القدم"},{"id":"d","text":"اليد"}]'::jsonb, 'b', 'الجزء الأزرق في الصورة هو الوسط الكبير الذي يربط الرأس بالأطراف، وهو الجذع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c88e3248-5f44-567f-b854-173913a3e975', 'd406b796-1924-521f-abde-f22b82e82bd8', 'اليدان من الأطراف العلوية. ماذا نفعل بهما؟', '[{"id":"a","text":"نحمل ونكتب ونلعب"},{"id":"b","text":"نمشي ونجري فقط"},{"id":"c","text":"نتنفّس"},{"id":"d","text":"نرى الألوان"}]'::jsonb, 'a', 'اليدان من الأطراف العلوية، نحمل بهما ونكتب ونلعب؛ أمّا المشي والجري فبالأطراف السفلية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارس القلعة (الجسم)', 3, 120, 30, 'boss', 'admin', 2)
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
  ('085f80cf-2fa5-5ae7-b781-19fc32c85f34', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'جزءٌ يربط الرأس بالأطراف وهو الجزء الأوسط الكبير. ما اسمه؟', '[{"id":"a","text":"الرأس"},{"id":"b","text":"الطرف العلوي"},{"id":"c","text":"الجذع"},{"id":"d","text":"المفصل"}]'::jsonb, 'c', 'الجذع هو الجزء الأوسط الكبير الذي يربط الرأس بالأطراف؛ المفصل ليس جزءًا رئيسيًّا بل مكان التقاء العظام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09caa4f7-470e-5757-818c-e7508348b93f', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'أيّ مجموعةٍ كلّها من الأطراف السفلية؟', '[{"id":"a","text":"الساقان والقدمان"},{"id":"b","text":"الذراعان واليدان"},{"id":"c","text":"الرأس والرقبة"},{"id":"d","text":"اليد والكتف"}]'::jsonb, 'a', 'الأطراف السفلية هي الساقان والقدمان، نمشي ونجري بها؛ أمّا الذراعان واليدان فهما الأطراف العلوية.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb506cec-30e1-5f7d-a8cd-cb04dd6de3d4', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'قال طفل: «المفصل جزءٌ رئيسيٌّ مثل الرأس والجذع». ما الصحيح؟', '[{"id":"a","text":"صحيح، المفصل جزءٌ رئيسيّ رابع"},{"id":"b","text":"المفصل هو الرأس نفسه"},{"id":"c","text":"الأجزاء الرئيسية اثنان فقط"},{"id":"d","text":"الأجزاء الرئيسية ثلاثة (رأس، جذع، أطراف)، والمفصل يربط بينها ويُحرّكها"}]'::jsonb, 'd', 'الخطأ الشائع: عدّ المفصل جزءًا رئيسيًّا. الأجزاء الرئيسية ثلاثة فقط (الرأس والجذع والأطراف)، أمّا المفصل فهو مكان التقاء العظام يسمح بالحركة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ec9d729-5ca1-5af7-b6ae-55ad088605ca', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'لماذا نستطيع ثنيَ الساق عند الركبة؟', '[{"id":"a","text":"لأنّ الساق ليس فيها عظم"},{"id":"b","text":"لأنّ الركبة مفصلٌ يسمح بالحركة"},{"id":"c","text":"لأنّ الجلد ناعم"},{"id":"d","text":"لأنّ الساق قصيرة"}]'::jsonb, 'b', 'الركبة مفصل، ومكان المفصل هو الذي يسمح بثني الطرف وتحريكه؛ لا علاقة للأمر بنعومة الجلد أو طول الساق.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5d6f58b-0d82-521d-87a6-e5c1e05c81b4', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'قال طفل: «أجري قرب الدرج بسرعة فلا خطر». ما الصواب؟', '[{"id":"a","text":"صحيح، الدرج آمنٌ دائمًا"},{"id":"b","text":"السرعة تحميه من السقوط"},{"id":"c","text":"الخطأ الشائع: الجري قرب الدرج يسبّب السقوط، فيجب المشي بهدوء"},{"id":"d","text":"السقوط لا يؤلم أبدًا"}]'::jsonb, 'c', 'الخطأ الشائع: الظنّ أنّ السرعة لا خطر فيها. الجري قرب الدرج سببٌ كبيرٌ للسقوط والإصابة، فالوقاية بالمشي بهدوء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16c019c7-b285-5aa7-9fb7-8e72b039fded', '787e2d68-4c9f-5f07-b881-4ad0e5c16e44', 'في الصورة، الدائرة البرتقاليّة تشير إلى مكانٍ في الذراع. ما هو؟<svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><path d="M20 95 L70 60" fill="none" stroke="#fdba74" stroke-width="12" stroke-linecap="round"/><path d="M70 60 L120 90" fill="none" stroke="#fdba74" stroke-width="12" stroke-linecap="round"/><circle cx="70" cy="60" r="13" fill="#f59e0b"/></g></svg>', '[{"id":"a","text":"نهاية الأصابع"},{"id":"b","text":"مفصلٌ (المرفق) ينثني عنده الذراع"},{"id":"c","text":"الرأس"},{"id":"d","text":"القدم"}]'::jsonb, 'b', 'الصورة تُظهر ذراعًا مثنيّة، والدائرة البرتقاليّة عند مكان الانثناء هي المفصل (المرفق أو الكوع) الذي يسمح بثني الذراع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d301efc9-f00c-57f4-890e-e398454d2aa9', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: أجزاء الجسم والسلامة (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('9eaadc92-cce9-5fa0-8a1f-894bea90cba1', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'أكمل: الجزء الأعلى من الجسم الذي فيه الوجه هو …', '[{"id":"a","text":"الرأس"},{"id":"b","text":"الجذع"},{"id":"c","text":"الساق"},{"id":"d","text":"اليد"}]'::jsonb, 'a', 'الرأس هو الجزء الأعلى من الجسم وفيه الوجه؛ أمّا الجذع ففي الوسط والساق واليد من الأطراف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24c99171-9685-5499-bb7c-61b2c87bcb7b', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'أيّ زوجٍ صحيح: طرف ← عمله؟', '[{"id":"a","text":"الساقان ← الكتابة"},{"id":"b","text":"اليدان ← الحمل والكتابة"},{"id":"c","text":"القدمان ← الرؤية"},{"id":"d","text":"الذراعان ← المشي"}]'::jsonb, 'b', 'اليدان من الأطراف العلوية نحمل بهما ونكتب؛ أمّا المشي فبالأطراف السفلية (الساقان والقدمان).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0da5a4f-4b6f-5551-84c6-d24a2dd46950', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'أيّ هذه المفاصل في الذراع؟', '[{"id":"a","text":"الركبة"},{"id":"b","text":"الكاحل"},{"id":"c","text":"المرفق (الكوع)"},{"id":"d","text":"أصابع القدم"}]'::jsonb, 'c', 'المرفق (الكوع) مفصلٌ في الذراع نثني به الذراع؛ أمّا الركبة والكاحل فمفصلان في الساق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7502615-ef59-5ed5-a12b-f8c657979c52', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'طفلٌ سقط فجُرحت ركبته. ما التصرّف السليم؟', '[{"id":"a","text":"يكتم الأمر ولا يخبر أحدًا"},{"id":"b","text":"يلمس الجرح بيدٍ متّسخة"},{"id":"c","text":"يضع على الجرح ترابًا"},{"id":"d","text":"يخبر الكبير لينظّف الجرح ويضمّده"}]'::jsonb, 'd', 'عند الإصابة بجرح نُخبر الكبير لينظّفه ويضمّده؛ أمّا التراب واليد المتّسخة فيزيدان الجرح خطرًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('248e0d61-1c85-56c2-8fc8-ea1bc3ef143d', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'ما الذي يربط أجزاء الجسم ويسمح بحركتها؟', '[{"id":"a","text":"المفاصل"},{"id":"b","text":"الشعر"},{"id":"c","text":"اللون"},{"id":"d","text":"الملابس"}]'::jsonb, 'a', 'المفاصل هي التي تربط العظام وأجزاء الجسم وتسمح بالثني والحركة، مثل الكتف والمرفق والركبة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ce97f26-9078-55f8-b615-8bdb7f3e9430', 'd301efc9-f00c-57f4-890e-e398454d2aa9', 'لماذا نلبس الخوذة عند ركوب الدرّاجة؟', '[{"id":"a","text":"لتغيير لون الشعر"},{"id":"b","text":"لحماية الرأس عند السقوط"},{"id":"c","text":"لكي نسير أسرع"},{"id":"d","text":"لأنّها ثقيلة"}]'::jsonb, 'b', 'نلبس الخوذة لحماية الرأس من الإصابة إن سقطنا عن الدرّاجة؛ فهي وقايةٌ من الحوادث لا زينة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4efde365-9679-58d3-a55f-7de8a76e3cc3', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد الجسم السليم', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f146f416-0b42-5172-b080-0dfbc82802b9', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'نريد ترتيب أجزاء الجسم من الأعلى إلى الأسفل. ما الترتيب الصحيح؟', '[{"id":"a","text":"الأطراف السفلية ثمّ الجذع ثمّ الرأس"},{"id":"b","text":"الجذع ثمّ الرأس ثمّ الأطراف"},{"id":"c","text":"الأطراف ثمّ الرأس ثمّ الجذع"},{"id":"d","text":"الرأس ثمّ الجذع ثمّ الأطراف السفلية"}]'::jsonb, 'd', 'من الأعلى إلى الأسفل: الرأس أوّلًا، ثمّ الجذع في الوسط، ثمّ الأطراف السفلية (الساقان والقدمان) في الأسفل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f627b0e7-43b7-507f-bb77-8c3168658819', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'قال طفل: «كلّما كبر العضو زادت مفاصله، فالجذع فيه أكثر المفاصل». ما الصحيح؟', '[{"id":"a","text":"صحيح، حجم العضو يحدّد عدد المفاصل"},{"id":"b","text":"الجذع لا يتحرّك أبدًا"},{"id":"c","text":"الخطأ الشائع: المفصل عند مكان الانثناء؛ الأطراف تنثني كثيرًا (الركبة، المرفق) لا الحجم"},{"id":"d","text":"المفاصل في الشعر"}]'::jsonb, 'c', 'الخطأ الشائع: ربط عدد المفاصل بالحجم. المفصل يوجد حيث ينثني الجسم؛ والأطراف تنثني كثيرًا عند الركبة والمرفق والكتف، لا لأنّها أكبر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('997de3c8-5927-5368-9b3c-f07a7ceec955', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'في حصّة الرياضة: ثنيُ الركبة، وثنيُ المرفق، وتحريك الرقبة. ما القاسم المشترك بينها؟', '[{"id":"a","text":"كلّها في الرأس"},{"id":"b","text":"كلّها تحدث عند مفاصل"},{"id":"c","text":"كلّها بلا حركة"},{"id":"d","text":"كلّها في الجذع فقط"}]'::jsonb, 'b', 'الركبة والمرفق والرقبة كلّها مفاصل، والقاسم المشترك أنّ الحركة والثني يحدثان عند المفاصل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ccb008c5-3f3b-5422-922d-ed1b85c47ddf', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'أربعة تصرّفات: لمس النار، الجري قرب الدرج، لبس الخوذة، القفز من نافذة. كم تصرّفًا خطِرًا فيها؟', '[{"id":"a","text":"ثلاثة (3)"},{"id":"b","text":"واحد (1)"},{"id":"c","text":"لا شيء خطِر"},{"id":"d","text":"أربعة (4)"}]'::jsonb, 'a', 'الخطِرة ثلاثة: لمس النار، والجري قرب الدرج، والقفز من نافذة. أمّا لبس الخوذة فتصرّفٌ سليمٌ يحمي الرأس.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6352531f-9cee-51ba-92e9-9017d0d25f6c', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"اليدان من الأطراف السفلية"},{"id":"b","text":"المفصل يمنع الحركة"},{"id":"c","text":"الرأس في وسط الجسم"},{"id":"d","text":"الركبة مفصلٌ نثني به الساق، والمرفق مفصلٌ نثني به الذراع"}]'::jsonb, 'd', 'الركبة مفصل الساق والمرفق مفصل الذراع. أمّا بقيّة الجمل ففيها خطأ: اليدان طرفٌ علويّ، والمفصل يسمح بالحركة، والرأس في الأعلى لا الوسط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93d04bab-c8bd-5344-82ab-19b8af8345e0', '4efde365-9679-58d3-a55f-7de8a76e3cc3', 'في الصورة، الدائرة البرتقاليّة تحيط بجزءٍ من الجسم. ما هو؟<svg viewBox="0 0 110 150" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="55" cy="30" r="24" fill="none" stroke="#f59e0b" stroke-width="3"/><circle cx="55" cy="32" r="14" fill="#fcd34d"/><circle cx="50" cy="30" r="2" fill="#1f2937" stroke="none"/><circle cx="60" cy="30" r="2" fill="#1f2937" stroke="none"/><rect x="41" y="54" width="28" height="42" rx="8" fill="#3b82f6"/><path d="M41 62 l-15 20 M69 62 l15 20" fill="none" stroke="#fdba74" stroke-width="6"/><path d="M49 96 l-6 38 M61 96 l6 38" fill="none" stroke="#fdba74" stroke-width="7"/></g></svg>', '[{"id":"a","text":"الرأس"},{"id":"b","text":"الجذع"},{"id":"c","text":"الساق"},{"id":"d","text":"اليد"}]'::jsonb, 'a', 'الدائرة البرتقاليّة تحيط بالجزء الأعلى الذي فيه العينان، وهو الرأس؛ أمّا الجذع فهو الجزء الأزرق في الوسط.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'f8199513-467c-5afa-b4d8-93b694d592cd', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لجسم الإنسان', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d24cec10-326f-507b-bbab-8101c228fa0a', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'أكمل: الذراعان واليدان هما الأطراف …', '[{"id":"a","text":"السفلية"},{"id":"b","text":"العلوية"},{"id":"c","text":"الوسطى"},{"id":"d","text":"الخلفية"}]'::jsonb, 'b', 'الذراعان واليدان في الأعلى، فهما الأطراف العلوية؛ أمّا الساقان والقدمان فهما السفلية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29a58ebe-625c-50d9-a294-40d15561dc2e', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'أيّ هذه ليست من الأجزاء الرئيسية الثلاثة للجسم؟', '[{"id":"a","text":"المفصل"},{"id":"b","text":"الرأس"},{"id":"c","text":"الجذع"},{"id":"d","text":"الأطراف"}]'::jsonb, 'a', 'الأجزاء الرئيسية الثلاثة هي الرأس والجذع والأطراف؛ أمّا المفصل فهو مكان التقاء العظام يربطها ويُحرّكها، وليس جزءًا رئيسيًّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d7bd806-d741-551f-ba56-d36ba4d7d4ed', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'ولدٌ يريد التقاط كرةٍ من الأرض، فانحنى وثنى ركبتيه. أيّ جزءٍ سمح له بثني الساق؟', '[{"id":"a","text":"الشعر"},{"id":"b","text":"الجلد فقط"},{"id":"c","text":"الرأس"},{"id":"d","text":"مفصل الركبة"}]'::jsonb, 'd', 'مفصل الركبة هو الذي يسمح بثني الساق وتحريكها؛ لا الشعر ولا الجلد ولا الرأس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('134a00f2-db5e-50bb-94cc-4acdbb84f8e7', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'أردنا أن نصنّف: «الرقبة، الكتف، الركبة، المرفق». ما الصحيح؟', '[{"id":"a","text":"كلّها أجزاء رئيسية"},{"id":"b","text":"كلّها أطراف سفلية"},{"id":"c","text":"كلّها مفاصل تسمح بالحركة"},{"id":"d","text":"كلّها في الرأس"}]'::jsonb, 'c', 'الرقبة والكتف والركبة والمرفق كلّها مفاصل، وهي تربط الأجزاء وتسمح بالحركة والثني.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1db0a74c-38fd-57bd-8b3f-772609894cf1', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'قال طفل: «جسمي قويّ فلا يتأذّى من النار». ما الصواب؟', '[{"id":"a","text":"صحيح، الجسم القويّ لا يحترق"},{"id":"b","text":"النار تسبّب حروقًا لكلّ جسم، فيجب الابتعاد عنها"},{"id":"c","text":"النار تنفع الجلد"},{"id":"d","text":"الحرق لا يؤلم"}]'::jsonb, 'b', 'النار تسبّب حروقًا مؤلمةً لكلّ جسمٍ مهما كان قويًّا، فالوقاية بالابتعاد عنها وعدم لمس الساخن.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1a1d038-bf1d-5875-a9af-3c55b16a02d0', 'a6ab43d3-53c9-54ed-a2fc-4ecbb5be5f4a', 'أيّ جملةٍ صحيحةٌ تمامًا عن سلامة الجسم؟', '[{"id":"a","text":"نجري قرب الدرج لنتمرّن"},{"id":"b","text":"نلمس الماء الساخن لنعرف حرارته"},{"id":"c","text":"نمشي بهدوء قرب الدرج ونلبس الخوذة على الدرّاجة"},{"id":"d","text":"نقفز من الأماكن العالية"}]'::jsonb, 'c', 'المشي بهدوء قرب الدرج ولبس الخوذة وقايةٌ من الحوادث؛ أمّا الجري قرب الدرج ولمس الساخن والقفز من عالٍ فأسباب إصابات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('551223aa-75ff-57a9-a2cd-b4b61336a410', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a24bd812-a457-5005-9702-ba2090e91f0b', '551223aa-75ff-57a9-a2cd-b4b61336a410', 'كم وجبةً رئيسيةً نأكل في اليوم؟', '[{"id":"a","text":"ثلاث وجبات"},{"id":"b","text":"وجبةٌ واحدة"},{"id":"c","text":"عشر وجبات"},{"id":"d","text":"لا نأكل في مواعيد"}]'::jsonb, 'a', 'في اليوم ثلاث وجباتٍ رئيسية: فطور الصباح والغداء والعشاء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22dec132-6567-553b-93e0-7fa7f450b98d', '551223aa-75ff-57a9-a2cd-b4b61336a410', 'أيّ وجبةٍ نأكلها في الصباح قبل المدرسة؟', '[{"id":"a","text":"العشاء"},{"id":"b","text":"فطور الصباح"},{"id":"c","text":"الغداء"},{"id":"d","text":"لا توجد وجبة"}]'::jsonb, 'b', 'فطور الصباح هو أوّل وجبة، نأكله في الصباح قبل الذهاب إلى المدرسة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16cc4a7f-0317-557e-b492-85d4a047b122', '551223aa-75ff-57a9-a2cd-b4b61336a410', 'الحليب غذاءٌ مصدره …', '[{"id":"a","text":"النبات"},{"id":"b","text":"الحجر"},{"id":"c","text":"الحيوان"},{"id":"d","text":"الماء"}]'::jsonb, 'c', 'الحليب يأتي من الحيوان (مثل البقرة)، فهو غذاءٌ حيواني.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e4d992b-79f8-56a3-8a15-04e4104a4cf6', '551223aa-75ff-57a9-a2cd-b4b61336a410', 'بأيّ عضوٍ يلتقط العصفور الحَبَّ؟', '[{"id":"a","text":"بالأسنان"},{"id":"b","text":"بالخرطوم"},{"id":"c","text":"بالمنقار"},{"id":"d","text":"باليدين"}]'::jsonb, 'c', 'العصفور لا أسنان له؛ يلتقط الحَبَّ بمنقاره.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('151fe381-8eac-5375-8d38-87d0be574832', '551223aa-75ff-57a9-a2cd-b4b61336a410', 'ماذا نفعل قبل الأكل لنبقى أصحّاء؟', '[{"id":"a","text":"نلعب في التراب"},{"id":"b","text":"نشرب ماءً غير نظيف"},{"id":"c","text":"ننام مباشرة"},{"id":"d","text":"نغسل أيدينا"}]'::jsonb, 'd', 'نغسل أيدينا قبل الأكل حتّى لا تدخل الجراثيم إلى أجسامنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c5aee80-f700-568c-9d6b-06a312ab7321', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', '⭐ تمرين: وجباتي وأكلي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('abe83c50-3f20-5678-8cd1-fc6caefc8918', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'أيّ وجبةٍ نأكلها في وسط النهار؟', '[{"id":"a","text":"الغداء"},{"id":"b","text":"فطور الصباح"},{"id":"c","text":"العشاء"},{"id":"d","text":"لا نأكل في النهار"}]'::jsonb, 'a', 'الغداء هو وجبة وسط النهار، بين فطور الصباح في الصباح والعشاء في المساء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b734973b-bc9f-5a14-bfae-dfedfc01fc2d', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'العشاء وجبةٌ نأكلها في …', '[{"id":"a","text":"الصباح الباكر"},{"id":"b","text":"المساء قبل النوم"},{"id":"c","text":"وسط النهار"},{"id":"d","text":"أثناء الدرس"}]'::jsonb, 'b', 'العشاء هو آخر وجبةٍ في اليوم، نأكله في المساء قبل النوم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54b24891-d0ed-5032-812b-4450c320eede', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'البيض غذاءٌ مصدره …', '[{"id":"a","text":"النبات"},{"id":"b","text":"الحجر"},{"id":"c","text":"الحيوان"},{"id":"d","text":"الهواء"}]'::jsonb, 'c', 'البيض يأتي من الحيوان (مثل الدجاجة)، فهو غذاءٌ حيواني.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5383f455-cf9c-5277-902a-23b32f5e1296', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'هذا الغذاء، ما مصدره؟<svg viewBox="0 0 100 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M50 32 q-16 -2 -16 18 q0 26 16 30 q16 -4 16 -30 q0 -20 -16 -18 z" fill="#ef4444"/><path d="M50 32 q1 -10 9 -12" fill="none" stroke="#a16207"/><path d="M52 24 q10 -7 15 0 q-10 0 -15 0 z" fill="#22c55e"/></g></svg>', '[{"id":"a","text":"من الحيوان"},{"id":"b","text":"من الحجارة"},{"id":"c","text":"من الماء فقط"},{"id":"d","text":"من النبات"}]'::jsonb, 'd', 'الصورة تُظهر تفّاحةً حمراء، وهي من الغلال (الفواكه)، أي غذاءٌ نباتي مصدره النبات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61bedf70-2703-50e1-959d-a5e7e7662dd8', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'ماذا نشرب لنبقى أصحّاء؟', '[{"id":"a","text":"الماء الصالح للشراب (النظيف)"},{"id":"b","text":"أيّ ماءٍ ولو كان متّسخًا"},{"id":"c","text":"ماء البِركة"},{"id":"d","text":"لا نشرب الماء"}]'::jsonb, 'a', 'نشرب الماء الصالح للشراب أي الماء النظيف؛ الماء المتّسخ يسبّب المرض.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('470e3303-0404-5ba3-b472-d249b66ff4b0', '1c5aee80-f700-568c-9d6b-06a312ab7321', 'بأيّ عضوٍ يأكل الأسد فريسته؟', '[{"id":"a","text":"بالمنقار"},{"id":"b","text":"بالخرطوم"},{"id":"c","text":"بالأسنان"},{"id":"d","text":"بالجناحين"}]'::jsonb, 'c', 'الأسد يلتقط غذاءه ويمزّقه بأسنانه القويّة؛ فهو يأكل بالأسنان.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الوجبات والمصادر', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5971b9e5-16eb-5915-a9e8-835d20a9f887', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'رتّب وجبات اليوم من الصباح إلى المساء. ما الترتيب الصحيح؟', '[{"id":"a","text":"فطور الصباح، ثمّ الغداء، ثمّ العشاء"},{"id":"b","text":"العشاء، ثمّ الغداء، ثمّ فطور الصباح"},{"id":"c","text":"الغداء، ثمّ فطور الصباح، ثمّ العشاء"},{"id":"d","text":"العشاء، ثمّ فطور الصباح، ثمّ الغداء"}]'::jsonb, 'a', 'نأكل فطور الصباح في الصباح، ثمّ الغداء في وسط النهار، ثمّ العشاء في المساء؛ هذا ترتيب الوجبات في اليوم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51ca0f68-1eef-5e47-9dd6-989e0bc862d6', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'أيّ مجموعةٍ كلّها أغذيةٌ من النبات؟', '[{"id":"a","text":"الحليب، اللحم، البيض"},{"id":"b","text":"الخضر، الغلال، الحبوب"},{"id":"c","text":"البيض، الجبن، اللحم"},{"id":"d","text":"الحليب، الخبز، اللحم"}]'::jsonb, 'b', 'الخضر والغلال والحبوب كلّها تأتي من النبات. أمّا الحليب واللحم والبيض فمن الحيوان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70185331-1bd6-5b97-924d-cce7bbe18999', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'حيوانٌ له خرطومٌ طويلٌ يقطف به أوراق الشجر. أيّ حيوانٍ هو؟', '[{"id":"a","text":"العصفور"},{"id":"b","text":"الأسد"},{"id":"c","text":"الفيل"},{"id":"d","text":"الدجاجة"}]'::jsonb, 'c', 'الفيل وحده له خرطومٌ طويلٌ يلتقط به غذاءه ويقطف أوراق الشجر؛ العصفور له منقار والأسد له أسنان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ec2073f-9c0b-52e9-9c2f-4fc5bb112705', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'قال طفل: «يمكن أن آكل في أيّ وقتٍ أردتُ، ولا حاجة لمواعيد». ما الصحيح؟', '[{"id":"a","text":"صحيح، الأكل في كلّ وقتٍ مفيد"},{"id":"b","text":"لا نأكل أبدًا حتّى لا نمرض"},{"id":"c","text":"نأكل مرّةً في الأسبوع فقط"},{"id":"d","text":"الخطأ الشائع هنا: نحترم مواعيد الوجبات الثلاث لنبقى أصحّاء"}]'::jsonb, 'd', 'الخطأ الشائع: الظنّ أنّ الأكل في كلّ وقتٍ مفيد. الصحيح أن نحترم مواعيد الوجبات الثلاث؛ الأكل العشوائي يضرّ الجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f991490-0dc5-5416-a839-b63e6ada8cbb', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'قال طفل: «كلّ الحيوانات تأكل بأسنانها». ما الصواب؟', '[{"id":"a","text":"صحيح، لكلّ حيوانٍ أسنان"},{"id":"b","text":"الخطأ الشائع هنا: العصفور يأكل بالمنقار لا بالأسنان"},{"id":"c","text":"كلّ الحيوانات تأكل بالخرطوم"},{"id":"d","text":"الحيوانات لا تأكل"}]'::jsonb, 'b', 'الخطأ الشائع: تعميم الأسنان على كلّ الحيوانات. العصفور والدجاجة لا أسنان لهما، بل يأكلان بالمنقار؛ والفيل يأكل بالخرطوم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b50805c-8c7e-5cf7-8f78-add08e1ea23a', '00dc9d8a-df8a-5cd4-b8b6-4e804adddbcf', 'هذا الغذاء، ما مصدره؟<svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><rect x="42" y="26" width="36" height="52" rx="4" fill="#dbeafe"/><rect x="42" y="26" width="36" height="15" fill="#3b82f6" stroke="none"/><rect x="42" y="26" width="36" height="52" rx="4" fill="none"/><text x="49" y="60" font-size="11" fill="#1f2937" stroke="none">حليب</text></g></svg>', '[{"id":"a","text":"من النبات"},{"id":"b","text":"من الحجارة"},{"id":"c","text":"من الحيوان"},{"id":"d","text":"من الهواء"}]'::jsonb, 'c', 'الصورة تُظهر كأس حليب؛ والحليب يأتي من الحيوان (مثل البقرة)، فهو غذاءٌ حيواني.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c99df168-9605-542b-8a8d-882dd952dd20', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: الوجبات والمصادر والتغذية عند الحيوان (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('a832e9b3-30bc-5cd2-9d19-7cf19380dc27', 'c99df168-9605-542b-8a8d-882dd952dd20', 'أكمل: أوّل وجبةٍ في اليوم نأكلها في الصباح هي …', '[{"id":"a","text":"فطور الصباح"},{"id":"b","text":"الغداء"},{"id":"c","text":"العشاء"},{"id":"d","text":"لا توجد وجبةٌ في الصباح"}]'::jsonb, 'a', 'فطور الصباح هو أوّل وجبة، نأكله في الصباح قبل الذهاب إلى المدرسة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed59ed4c-e1be-517e-a524-a7529dc6608a', 'c99df168-9605-542b-8a8d-882dd952dd20', 'أيّ زوجٍ صحيح: غذاء ← مصدره؟', '[{"id":"a","text":"الخبز ← الحيوان"},{"id":"b","text":"اللحم ← الحيوان"},{"id":"c","text":"الحليب ← النبات"},{"id":"d","text":"البيض ← الحجر"}]'::jsonb, 'b', 'اللحم يأتي من الحيوان، فالزوج صحيح. أمّا الخبز فمن النبات (القمح)، والحليب من الحيوان لا النبات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84d12636-60a6-5040-8f26-13e771600961', 'c99df168-9605-542b-8a8d-882dd952dd20', 'أيّ هذه ليست غذاءً من النبات؟', '[{"id":"a","text":"الجزر"},{"id":"b","text":"التفّاح"},{"id":"c","text":"البيض"},{"id":"d","text":"القمح"}]'::jsonb, 'c', 'البيض غذاءٌ من الحيوان؛ أمّا الجزر والتفّاح والقمح فكلّها من النبات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f74c7c4a-4a58-52c3-892e-234e19dc9e1f', 'c99df168-9605-542b-8a8d-882dd952dd20', 'لماذا نحفظ الطعام في مكانٍ نظيفٍ وبارد؟', '[{"id":"a","text":"لكي يتغيّر لونه"},{"id":"b","text":"لكي يصبح أثقل"},{"id":"c","text":"لكي يطير"},{"id":"d","text":"حتّى لا يفسد ويبقى صالحًا للأكل"}]'::jsonb, 'd', 'نحفظ الطعام في مكانٍ نظيفٍ وبارد حتّى لا يفسد؛ الطعام الفاسد يسبّب المرض.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7c00be1-8109-5765-bc35-2c5c9061eade', 'c99df168-9605-542b-8a8d-882dd952dd20', 'حيوانٌ يأكل الحَبَّ بمنقاره. أيّ حيوانٍ يصلح مثالًا؟', '[{"id":"a","text":"الدجاجة"},{"id":"b","text":"الأسد"},{"id":"c","text":"الفيل"},{"id":"d","text":"البقرة"}]'::jsonb, 'a', 'الدجاجة لها منقارٌ تلتقط به الحَبَّ؛ أمّا الأسد والبقرة فيأكلان بالأسنان، والفيل بالخرطوم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1323ae50-875d-55b3-94ce-0c3fffc01f3b', 'c99df168-9605-542b-8a8d-882dd952dd20', 'أيّ تصرّفٍ صحيحٌ قبل الأكل؟', '[{"id":"a","text":"نلمس الطعام بيدٍ متّسخة"},{"id":"b","text":"نأكل ونحن نلعب في التراب"},{"id":"c","text":"نشرب ماءً غير نظيف"},{"id":"d","text":"نغسل أيدينا بالماء والصابون"}]'::jsonb, 'd', 'نغسل أيدينا بالماء والصابون قبل الأكل لنُبعد الجراثيم؛ أمّا اليد المتّسخة والماء غير النظيف فيسبّبان المرض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير التغذية', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8346a598-f714-52bb-8f3e-296ff94de58d', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'نريد ترتيب الأغذية في خانتين: «من الحيوان» و«من النبات». أين نضع الجزر؟', '[{"id":"a","text":"في خانة «من النبات»"},{"id":"b","text":"في خانة «من الحيوان»"},{"id":"c","text":"في خانة «من الحجر»"},{"id":"d","text":"لا يُوضع في أيّ خانة"}]'::jsonb, 'a', 'الجزر من الخضر، والخضر تأتي من النبات؛ فيوضع في خانة «من النبات».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8e14439-93af-5963-b468-3c90fe16cd96', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'على المائدة: حليبٌ وبيضٌ ولحم. كم غذاءً مصدره الحيوان؟', '[{"id":"a","text":"غذاءٌ واحد"},{"id":"b","text":"ثلاثة (3)"},{"id":"c","text":"لا شيء"},{"id":"d","text":"اثنان (2)"}]'::jsonb, 'b', 'الحليب والبيض واللحم كلّها من الحيوان، أي ثلاثة (3) أغذيةٍ مصدرها الحيوان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('786a2c2f-e339-5257-ada4-72812c361be5', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'نصنّف الحيوانات حسب عضو التقاط الغذاء: «أسنان» و«منقار» و«خرطوم». أين نضع العصفور والدجاجة؟', '[{"id":"a","text":"في خانة «أسنان»"},{"id":"b","text":"في خانة «خرطوم»"},{"id":"c","text":"في خانة «منقار»"},{"id":"d","text":"في خانة «نبات»"}]'::jsonb, 'c', 'العصفور والدجاجة لهما منقار يلتقطان به الحَبَّ، فيوضعان في خانة «منقار».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7587a156-8ec0-56ec-97e0-43df9b2ead0f', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'قال طفل: «إذا أكلتُ كثيرًا في وجبةٍ واحدة، فلا حاجة لبقيّة الوجبات». ما الصحيح؟', '[{"id":"a","text":"صحيح، وجبةٌ واحدةٌ كبيرةٌ تكفي"},{"id":"b","text":"نأكل عشر مرّاتٍ في اليوم"},{"id":"c","text":"لا نأكل في المساء أبدًا"},{"id":"d","text":"الخطأ الشائع هنا: نوزّع الأكل على ثلاث وجباتٍ في مواعيدها"}]'::jsonb, 'd', 'الخطأ الشائع: تعويض الوجبات بوجبةٍ واحدةٍ كبيرة. الصحيح أن نوزّع الأكل على فطورٍ وغداءٍ وعشاءٍ في مواعيدها؛ هذا أفضل للجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3f22dc9-1559-5883-a2ce-01b300f351ab', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'قال طفل: «الفيل كبيرٌ فهو يأكل بأسنانه مثل الأسد». ما الصواب؟', '[{"id":"a","text":"صحيح، كلّ حيوانٍ كبيرٍ يأكل بالأسنان"},{"id":"b","text":"الخطأ الشائع هنا: الفيل يلتقط غذاءه بالخرطوم لا بالأسنان"},{"id":"c","text":"الفيل يأكل بالمنقار"},{"id":"d","text":"الفيل لا يأكل"}]'::jsonb, 'b', 'الخطأ الشائع: ربط عضو الأكل بالحجم. الفيل كبيرٌ لكنّه يلتقط غذاءه بخرطومه الطويل ويقطف أوراق الشجر؛ الأسد هو الذي يأكل بأسنانه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70ce1fba-43b3-5a6f-977e-a3423d732049', '06c8bb4f-0a0e-5116-ab6f-de5e196ac9ef', 'هذا الحيوان، بأيّ عضوٍ يلتقط غذاءه؟<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="58" cy="56" rx="30" ry="22" fill="#fcd34d"/><circle cx="82" cy="38" r="14" fill="#fcd34d"/><path d="M50 18 q4 -8 8 0 q-4 -2 -8 0 z" fill="#ef4444"/><path d="M94 36 l18 4 l-18 6 z" fill="#f59e0b" stroke="none"/><path d="M94 36 l18 4 l-18 6 z" fill="none"/><circle cx="84" cy="35" r="2.5" fill="#1f2937" stroke="none"/><path d="M50 76 l-3 10 M64 78 l1 10" stroke="#f59e0b"/></g></svg>', '[{"id":"a","text":"بالمنقار"},{"id":"b","text":"بالخرطوم"},{"id":"c","text":"بالأسنان الكبيرة"},{"id":"d","text":"باليدين"}]'::jsonb, 'a', 'الصورة تُظهر دجاجةً لها عُرفٌ أحمر ومنقارٌ برتقالي؛ وهي تلتقط الحَبَّ بمنقارها، لا بأسنانٍ ولا بخرطوم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('334a7121-c262-5f9a-a903-3a04b98c5376', '82259433-cfe7-5cd3-9bcd-34c27f107314', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتغذية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d030d5d7-2343-51c4-99a8-9329219e926a', '334a7121-c262-5f9a-a903-3a04b98c5376', 'أكمل: الوجبات الرئيسية في اليوم هي فطور الصباح والغداء و…', '[{"id":"a","text":"العشاء"},{"id":"b","text":"النوم"},{"id":"c","text":"اللعب"},{"id":"d","text":"الدرس"}]'::jsonb, 'a', 'الوجبات الثلاث هي فطور الصباح والغداء والعشاء؛ والعشاء آخرها في المساء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45567b28-139c-552b-8e7f-466cf6693fa7', '334a7121-c262-5f9a-a903-3a04b98c5376', 'أيّ هذه الأغذية مصدرها الحيوان؟', '[{"id":"a","text":"القمح"},{"id":"b","text":"الجبن"},{"id":"c","text":"الجزر"},{"id":"d","text":"التفّاح"}]'::jsonb, 'b', 'الجبن يُصنع من الحليب، والحليب من الحيوان؛ فالجبن غذاءٌ حيواني. أمّا القمح والجزر والتفّاح فمن النبات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('120cf297-1936-56c3-a07c-cb11be317659', '334a7121-c262-5f9a-a903-3a04b98c5376', 'حيوانٌ يأكل بأسنانه القويّة. أيّ حيوانٍ يصلح مثالًا؟', '[{"id":"a","text":"العصفور"},{"id":"b","text":"الدجاجة"},{"id":"c","text":"الأسد"},{"id":"d","text":"النحلة"}]'::jsonb, 'c', 'الأسد يلتقط فريسته ويمزّقها بأسنانه القويّة؛ أمّا العصفور والدجاجة فيأكلان بالمنقار.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22934687-9389-5bda-b9ec-3ce23636d507', '334a7121-c262-5f9a-a903-3a04b98c5376', 'أردنا أن نصنّف: «الأسنان، المنقار، الخرطوم». ما الذي تشترك فيه هذه الثلاثة؟', '[{"id":"a","text":"كلّها وجباتٌ غذائية"},{"id":"b","text":"كلّها مصادر للماء"},{"id":"c","text":"كلّها أنواعٌ من الخضر"},{"id":"d","text":"كلّها أعضاءٌ لالتقاط الغذاء عند الحيوان"}]'::jsonb, 'd', 'الأسنان والمنقار والخرطوم كلّها أعضاءٌ تلتقط بها الحيوانات غذاءها، كلٌّ حسب نوعه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8f4ee7e-bbc9-58ee-9ef9-c413a85a2b8e', '334a7121-c262-5f9a-a903-3a04b98c5376', 'في صحن فطور الصباح: خبزٌ وحليبٌ وتفّاحة. أيّ غذاءٍ منها مصدره الحيوان؟', '[{"id":"a","text":"الخبز"},{"id":"b","text":"التفّاحة"},{"id":"c","text":"الحليب"},{"id":"d","text":"لا شيء منها"}]'::jsonb, 'c', 'الحليب من الحيوان (البقرة)؛ أمّا الخبز (من القمح) والتفّاحة (من الغلال) فمصدرهما النبات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ae15ce6-6f99-56f4-a272-dc94f0f0cd85', '334a7121-c262-5f9a-a903-3a04b98c5376', 'قال طفل: «أشرب من أيّ ماءٍ أجده ولو كان متّسخًا». ما الصواب؟', '[{"id":"a","text":"صحيح، كلّ ماءٍ صالحٌ للشراب"},{"id":"b","text":"نشرب الماء الصالح للشراب (النظيف) فقط لنتجنّب المرض"},{"id":"c","text":"لا نشرب الماء أبدًا"},{"id":"d","text":"الماء المتّسخ ألذّ"}]'::jsonb, 'b', 'نشرب الماء الصالح للشراب أي الماء النظيف فقط؛ الماء المتّسخ يحمل الجراثيم ويسبّب المرض، فلا نشربه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6daa0799-6714-517d-a251-1ae62766c13d', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('edbed3e1-1a8b-5389-9395-ac872c0c8904', '6daa0799-6714-517d-a251-1ae62766c13d', 'كيف يتنقّل العصفور في الهواء؟', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالطيران بأجنحته"},{"id":"c","text":"بالزحف على بطنه"},{"id":"d","text":"بالسباحة بزعانفه"}]'::jsonb, 'b', 'العصفور له أجنحة يتنقّل بها في الهواء، أي يطير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd3b6cbf-37d5-5337-a3dd-4a7425924990', '6daa0799-6714-517d-a251-1ae62766c13d', 'بأيّ عضوٍ تسبح السمكة في الماء؟', '[{"id":"a","text":"بالزعانف"},{"id":"b","text":"بالأجنحة"},{"id":"c","text":"بالقوائم"},{"id":"d","text":"بالقرنين"}]'::jsonb, 'a', 'السمكة لها زعانف تسبح بها في الماء، فهي العضو المستعمل في تنقّلها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47012b74-ccdf-54a0-bb2b-92e28bce1754', '6daa0799-6714-517d-a251-1ae62766c13d', 'الأرنب يتنقّل في البَرّ. بأيّ عضوٍ يقفز؟', '[{"id":"a","text":"بالأجنحة"},{"id":"b","text":"بالزعانف"},{"id":"c","text":"بالقوائم (الأرجل)"},{"id":"d","text":"بالذيل وحده"}]'::jsonb, 'c', 'الأرنب له قوائم (أرجل) يقفز بها في البَرّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01350a60-2e06-5e93-80de-24e3d2e5088a', '6daa0799-6714-517d-a251-1ae62766c13d', 'كيف يتنقّل الإنسان عادةً؟', '[{"id":"a","text":"يمشي ويعدو ويقفز برجليه"},{"id":"b","text":"يطير بجناحيه"},{"id":"c","text":"يسبح بزعانفه دائمًا"},{"id":"d","text":"يزحف على بطنه"}]'::jsonb, 'a', 'الإنسان يتنقّل برجليه: يمشي أو يعدو (يجري) أو يقفز، مثل الحيوان في البَرّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4db483a-5c89-56b8-8fb4-154c817c6249', '6daa0799-6714-517d-a251-1ae62766c13d', 'أيّ حيوانٍ يتنقّل بأكثر من طريقة (يمشي ويسبح ويطير)؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الحصان"},{"id":"c","text":"العصفور فقط"},{"id":"d","text":"البطّة"}]'::jsonb, 'd', 'البطّة تتنقّل بأكثر من طريقة: تمشي على الأرض، وتسبح في الماء، وتطير في الهواء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('875e5eed-d064-5d2b-aae2-705f52f65553', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', '⭐ تمرين: بأيّ عضوٍ يتنقّل؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c6af5d7c-9055-5b27-83d6-538e512920ed', '875e5eed-d064-5d2b-aae2-705f52f65553', 'العصفور يطير في الهواء. بأيّ عضوٍ يتنقّل؟', '[{"id":"a","text":"بالأجنحة"},{"id":"b","text":"بالزعانف"},{"id":"c","text":"بالقوائم"},{"id":"d","text":"بالذيل وحده"}]'::jsonb, 'a', 'العصفور له أجنحة يطير بها في الهواء، فهي العضو الذي يتنقّل به.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52771464-332d-5906-a3ef-38286fbec422', '875e5eed-d064-5d2b-aae2-705f52f65553', 'كيف تتنقّل السمكة في الماء؟', '[{"id":"a","text":"تطير بأجنحتها"},{"id":"b","text":"تقفز بقوائمها"},{"id":"c","text":"تسبح بزعانفها"},{"id":"d","text":"تمشي على الأرض"}]'::jsonb, 'c', 'السمكة تعيش في الماء وتتنقّل فيه بالسباحة، مستعملةً زعانفها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2d335e2-1717-5a26-b70f-44f49be8488b', '875e5eed-d064-5d2b-aae2-705f52f65553', 'الأرنب يعيش في البَرّ. بأيّ عضوٍ يقفز؟', '[{"id":"a","text":"بالأجنحة"},{"id":"b","text":"بالقوائم (الأرجل)"},{"id":"c","text":"بالزعانف"},{"id":"d","text":"بالقرنين"}]'::jsonb, 'b', 'الأرنب له قوائم (أرجل) يقفز بها فوق الأرض في البَرّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e23d71e4-cc66-56df-80c0-6b404345eb3a', '875e5eed-d064-5d2b-aae2-705f52f65553', 'هذا الحيوان يعيش في الماء. كيف يتنقّل؟<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="66" width="130" height="24" fill="#3b82f6"/><g stroke="#1f2937" stroke-width="2"><path d="M34 42 q26 -22 56 0 q-26 22 -56 0 z" fill="#fb923c"/><path d="M34 42 l-18 -13 l0 26 z" fill="#fb923c"/><path d="M58 24 q7 8 0 14" fill="#f59e0b"/><path d="M58 44 q7 9 0 16" fill="#f59e0b"/><circle cx="80" cy="38" r="2.5" fill="#1f2937" stroke="none"/><path d="M68 38 q5 4 10 0" fill="none"/></g></svg>', '[{"id":"a","text":"يطير بأجنحته في الهواء"},{"id":"b","text":"يقفز بقوائمه في البَرّ"},{"id":"c","text":"يسبح بزعانفه في الماء"},{"id":"d","text":"يمشي على رجلين"}]'::jsonb, 'c', 'الصورة تُظهر سمكةً برتقاليّةً لها زعانف وذيلٌ داخل الماء؛ فهي تتنقّل بالسباحة بزعانفها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6a22b3a-69ab-5abc-95de-8b6e4835508f', '875e5eed-d064-5d2b-aae2-705f52f65553', 'كيف يتنقّل الإنسان عندما يذهب إلى المدرسة؟', '[{"id":"a","text":"يمشي برجليه"},{"id":"b","text":"يطير بجناحيه"},{"id":"c","text":"يسبح بزعانفه"},{"id":"d","text":"يزحف على بطنه"}]'::jsonb, 'a', 'الإنسان يتنقّل برجليه: يمشي أو يعدو، مثل الحيوان الذي يتنقّل بالقوائم في البَرّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e9ea785-661e-561f-8693-9536349192de', '875e5eed-d064-5d2b-aae2-705f52f65553', 'الحصان يعدو بسرعةٍ في البَرّ. بأيّ عضوٍ يتنقّل؟', '[{"id":"a","text":"بالأجنحة"},{"id":"b","text":"بالزعانف"},{"id":"c","text":"بالمنقار"},{"id":"d","text":"بالقوائم (الأرجل)"}]'::jsonb, 'd', 'الحصان له أربع قوائم يعدو (يجري) بها بسرعةٍ في البَرّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد طُرُق التنقّل', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d8ad6c3f-36b2-5f0e-bc17-81e6894040aa', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'أيّ مجموعةٍ كلّ حيواناتها تتنقّل بالطيران بالأجنحة؟', '[{"id":"a","text":"السمكة والحصان"},{"id":"b","text":"العصفور والفراشة"},{"id":"c","text":"الأرنب والسمكة"},{"id":"d","text":"الحصان والأرنب"}]'::jsonb, 'b', 'العصفور والفراشة لهما أجنحة يتنقّلان بها في الهواء، أي يطيران. أمّا البقيّة فتتنقّل بالقوائم أو بالزعانف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bfdea48-2eea-57e2-8179-b56f19ead567', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'حيوانٌ له زعانف. أين يتنقّل وكيف؟', '[{"id":"a","text":"في الهواء بالطيران"},{"id":"b","text":"في البَرّ بالقفز"},{"id":"c","text":"في الماء بالسباحة"},{"id":"d","text":"في الهواء بالقفز"}]'::jsonb, 'c', 'الزعانف عضوٌ للسباحة، فالحيوان الذي له زعانف يعيش في الماء ويتنقّل فيه بالسباحة، مثل السمكة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1236959-0064-5198-bec3-5b2c17ac6ef1', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'قال طفل: «كلّ حيوانٍ يعيش في الماء يطير». ما الصحيح؟', '[{"id":"a","text":"صحيح، الماء يجعل الحيوان يطير"},{"id":"b","text":"خطأ، السمكة في الماء تسبح بزعانفها ولا تطير"},{"id":"c","text":"كلّ حيوانات الماء تمشي"},{"id":"d","text":"السمكة تطير فوق الماء"}]'::jsonb, 'b', 'الخطأ الشائع: الخلط بين المكان وطريقة التنقّل. السمكة تعيش في الماء وتتنقّل بالسباحة بزعانفها، والطيران يكون في الهواء بالأجنحة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a901c09d-2d89-5c92-ad16-c941677cb845', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'قال طفل: «العصفور يسبح لأنّه يقترب أحيانًا من الماء». ما الصحيح؟', '[{"id":"a","text":"خطأ، العصفور له أجنحة يتنقّل بها بالطيران في الهواء"},{"id":"b","text":"صحيح، كلّ من يقترب من الماء يسبح"},{"id":"c","text":"العصفور يزحف على بطنه"},{"id":"d","text":"العصفور له زعانف"}]'::jsonb, 'a', 'الخطأ الشائع: تحديد طريقة التنقّل من قُرب الماء. العصفور له أجنحة لا زعانف، فهو يتنقّل بالطيران في الهواء، لا بالسباحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a79e332a-e11c-5161-9074-2643a0907c84', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'هذا الحيوان له جناحان. كيف يتنقّل؟<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="64" cy="56" rx="26" ry="14" fill="#3b82f6"/><circle cx="90" cy="46" r="11" fill="#3b82f6"/><path d="M99 44 l13 -3 l-12 8 z" fill="#f59e0b" stroke="none"/><circle cx="92" cy="44" r="2" fill="#1f2937" stroke="none"/><path d="M50 50 q-22 -28 -36 -16 q15 6 32 22 z" fill="#60a5fa"/><path d="M48 64 l-9 16 M62 66 l-4 18" stroke="#f59e0b"/></g></svg>', '[{"id":"a","text":"يسبح بزعانفه في الماء"},{"id":"b","text":"يقفز بقوائمه في البَرّ"},{"id":"c","text":"يطير بأجنحته في الهواء"},{"id":"d","text":"يزحف على بطنه"}]'::jsonb, 'c', 'الصورة تُظهر عصفورًا أزرق له جناحٌ منشورٌ ومنقار؛ والحيوان الذي له أجنحة يتنقّل بالطيران في الهواء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21d78123-2891-55db-9d43-29aa2b149d92', '346e0cee-a838-5c8f-b941-0fb0392fa9c2', 'أيّ زوجٍ صحيحٌ: حيوان ← العضو وطريقة التنقّل؟', '[{"id":"a","text":"العصفور ← زعانف، سباحة"},{"id":"b","text":"الأرنب ← أجنحة، طيران"},{"id":"c","text":"الحصان ← زعانف، سباحة"},{"id":"d","text":"السمكة ← زعانف، سباحة"}]'::jsonb, 'd', 'السمكة لها زعانف وتتنقّل بالسباحة، فالزوج صحيح. أمّا العصفور فيطير بأجنحته، والأرنب والحصان يتنقّلان بالقوائم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8461ddba-d9c5-53ff-a268-86f926e438f3', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: في البَرّ والهواء والماء (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('aa59cbfc-d6e3-5322-aaae-ee0e8f256e38', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'الحيوان الذي يعيش في البَرّ يتنقّل عادةً بـ…', '[{"id":"a","text":"القوائم (الأرجل)"},{"id":"b","text":"الزعانف"},{"id":"c","text":"الأجنحة فقط"},{"id":"d","text":"الذيل وحده"}]'::jsonb, 'a', 'في البَرّ يتنقّل الحيوان بقوائمه: يمشي أو يعدو أو يقفز، مثل الحصان والأرنب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5c5aa2a-2cb7-512c-96a0-683bbb52616d', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'الفراشة تتنقّل في الهواء. كيف؟', '[{"id":"a","text":"تسبح بزعانفها"},{"id":"b","text":"تطير بأجنحتها"},{"id":"c","text":"تقفز بقوائمها"},{"id":"d","text":"تزحف على بطنها"}]'::jsonb, 'b', 'الفراشة لها أجنحة تحملها في الهواء، فهي تتنقّل بالطيران مثل العصفور.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20d649b0-9e70-5215-992c-7050b20cd0ff', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'أكمل: الحيوان الذي له زعانف يتنقّل بـ…', '[{"id":"a","text":"السباحة في الماء"},{"id":"b","text":"الطيران في الهواء"},{"id":"c","text":"المشي في البَرّ"},{"id":"d","text":"القفز فوق الأشجار"}]'::jsonb, 'a', 'الزعانف عضوٌ للسباحة، فالحيوان الذي له زعانف يعيش في الماء ويتنقّل فيه بالسباحة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2da37f96-7fee-5e3c-8bc9-5633e22cda48', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'بأيّ شيءٍ يتشابه تنقّل الإنسان مع تنقّل الأرنب؟', '[{"id":"a","text":"كلاهما يطير بالأجنحة"},{"id":"b","text":"كلاهما يسبح بالزعانف"},{"id":"c","text":"كلاهما يتنقّل بالأرجل في البَرّ ويقفز"},{"id":"d","text":"كلاهما يزحف على بطنه"}]'::jsonb, 'c', 'الإنسان يتنقّل برجليه (يمشي ويقفز)، والأرنب يتنقّل بقوائمه (يقفز)، فكلاهما يتنقّل بالأرجل في البَرّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd6f9a83-1bc0-58ef-be01-cddc274b9df5', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'صنّف العضو لكلّ حيوان: «العصفور، السمكة، الحصان». ما الصحيح؟', '[{"id":"a","text":"أجنحة، أجنحة، أجنحة"},{"id":"b","text":"أجنحة، زعانف، قوائم"},{"id":"c","text":"زعانف، قوائم، أجنحة"},{"id":"d","text":"قوائم، قوائم، زعانف"}]'::jsonb, 'b', 'العصفور له أجنحة (يطير)، والسمكة لها زعانف (تسبح)، والحصان له قوائم (يعدو)، فالترتيب: أجنحة، زعانف، قوائم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ed71c15-0b2e-547e-8a25-805430f5f942', '8461ddba-d9c5-53ff-a268-86f926e438f3', 'كيف تتنقّل البطّة؟', '[{"id":"a","text":"بالطيران فقط"},{"id":"b","text":"بالسباحة فقط"},{"id":"c","text":"لا تتنقّل أبدًا"},{"id":"d","text":"بأكثر من طريقة: تمشي وتسبح وتطير"}]'::jsonb, 'd', 'البطّة من الحيوانات التي تتنقّل بأكثر من طريقة: تمشي بقوائمها، وتسبح في الماء، وتطير بجناحيها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6090eaf-253e-5f03-92b8-29f94884c082', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد تصنيف التنقّل', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('64b24877-8b08-58bc-8c2a-f8b5b3673d6f', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'نرتّب الحيوانات في خانات حسب العضو. أين نضع الحصان الذي يعدو في البَرّ؟', '[{"id":"a","text":"في خانة «أجنحة»"},{"id":"b","text":"في خانة «قوائم»"},{"id":"c","text":"في خانة «زعانف»"},{"id":"d","text":"في خانة «بلا عضو»"}]'::jsonb, 'b', 'الحصان يعدو في البَرّ بقوائمه (أرجله)، فيوضع في خانة «قوائم».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6d652e1-c276-5793-af70-67f262708323', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'هذا الحيوان يعيش في البَرّ. في أيّ خانةٍ نضعه؟<svg viewBox="0 0 120 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="56" cy="62" rx="26" ry="18" fill="#a16207"/><circle cx="82" cy="46" r="13" fill="#a16207"/><path d="M74 36 q-5 -24 4 -24 q7 6 4 26 z" fill="#fcd34d"/><path d="M84 36 q5 -22 12 -20 q3 9 -6 24 z" fill="#fcd34d"/><circle cx="84" cy="46" r="2.5" fill="#1f2937" stroke="none"/><path d="M38 78 q-7 11 3 13 M58 80 q-3 11 7 11" fill="none" stroke="#92400e"/><circle cx="34" cy="64" r="6" fill="#fcd34d"/></g></svg>', '[{"id":"a","text":"خانة «يطير بأجنحته»"},{"id":"b","text":"خانة «يسبح بزعانفه»"},{"id":"c","text":"خانة «يزحف على بطنه»"},{"id":"d","text":"خانة «يقفز بقوائمه في البَرّ» (أرنب)"}]'::jsonb, 'd', 'الصورة تُظهر أرنبًا بنّيًّا له أُذنان طويلتان وأربع قوائم؛ وهو يتنقّل بالقفز بقوائمه في البَرّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30628f8e-8e19-5ddc-9936-74f62bb066d2', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'في قائمة: «عصفور، فراشة، حمامة». كم حيوانًا يتنقّل بالطيران؟', '[{"id":"a","text":"ثلاثة (3)"},{"id":"b","text":"واحد (1)"},{"id":"c","text":"لا يوجد طائر"},{"id":"d","text":"اثنان (2)"}]'::jsonb, 'a', 'العصفور والفراشة والحمامة، كلّها لها أجنحة وتتنقّل بالطيران في الهواء، أي ثلاثة (3).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b1fb3a7-ed20-598a-90e7-c9548403dfa3', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'قال طفل: «البطّة لا يمكن أن تسبح لأنّها تمشي على الأرض». ما الصحيح؟', '[{"id":"a","text":"صحيح، من يمشي لا يسبح أبدًا"},{"id":"b","text":"البطّة تطير فقط ولا تمشي"},{"id":"c","text":"البطّة تسبح فقط ولا تمشي"},{"id":"d","text":"خطأ، البطّة تتنقّل بأكثر من طريقة: تمشي وتسبح وتطير"}]'::jsonb, 'd', 'الخطأ الشائع: الظنّ أنّ الحيوان يتنقّل بطريقةٍ واحدة. البطّة تتنقّل بأكثر من طريقة: تمشي بقوائمها وتسبح في الماء وتطير بجناحيها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3389ff92-a7cc-5452-ad9c-28a78f9322f1', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'هذا الحيوان يمشي على الأرض ويسبح في الماء. كيف نصنّف تنقّله؟<svg viewBox="0 0 130 95" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="72" width="130" height="23" fill="#3b82f6"/><g stroke="#1f2937" stroke-width="2"><ellipse cx="60" cy="56" rx="30" ry="18" fill="#facc15"/><circle cx="92" cy="40" r="12" fill="#facc15"/><path d="M102 40 q12 -2 12 5 q-7 3 -12 0 z" fill="#f59e0b"/><circle cx="92" cy="37" r="2" fill="#1f2937" stroke="none"/><path d="M40 56 q-16 -10 -6 8" fill="#fde047"/><path d="M54 74 l-3 12 M68 74 l0 12" stroke="#f59e0b"/></g></svg>', '[{"id":"a","text":"يطير فقط"},{"id":"b","text":"يزحف على بطنه"},{"id":"c","text":"يتنقّل بأكثر من طريقة (بطّة): يمشي ويسبح ويطير"},{"id":"d","text":"يسبح فقط ولا يفعل غير ذلك"}]'::jsonb, 'c', 'الصورة تُظهر بطّةً صفراء لها منقارٌ عريض قرب الماء؛ والبطّة تتنقّل بأكثر من طريقة: تمشي وتسبح وتطير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52643f8b-930e-57e5-8671-6659fc8e757f', 'c6090eaf-253e-5f03-92b8-29f94884c082', 'قال طفل: «الإنسان يتنقّل بالطيران لأنّه يركب الطائرة». ما الصحيح؟', '[{"id":"a","text":"صحيح، للإنسان أجنحة"},{"id":"b","text":"خطأ، الإنسان يتنقّل برجليه: يمشي ويعدو ويقفز"},{"id":"c","text":"الإنسان يسبح بزعانفه"},{"id":"d","text":"الإنسان يزحف على بطنه"}]'::jsonb, 'b', 'الخطأ الشائع: الخلط بين تنقّل جسم الإنسان والوسائل التي يصنعها. الإنسان ليس له أجنحة؛ فهو يتنقّل برجليه: يمشي ويعدو ويقفز.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'c6c62df4-42ba-5882-a9f8-5190744f962a', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتنقّل', 3, 120, 30, 'boss', 'admin', 5)
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
  ('415bf82f-6a5b-5e30-9817-f49efcd5b579', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'أكمل: التنقّل في الهواء يكون بـ…', '[{"id":"a","text":"الأجنحة (الطيران)"},{"id":"b","text":"الزعانف (السباحة)"},{"id":"c","text":"القوائم (القفز)"},{"id":"d","text":"البطن (الزحف)"}]'::jsonb, 'a', 'التنقّل في الهواء يكون بالأجنحة، أي بالطيران، مثل العصفور والفراشة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08881516-dedc-5a79-b61e-96949394b1d4', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'الحيوان الذي يتنقّل بالقوائم، أين يعيش ويتنقّل عادةً؟', '[{"id":"a","text":"في الهواء"},{"id":"b","text":"في الماء فقط"},{"id":"c","text":"في البَرّ (على الأرض)"},{"id":"d","text":"لا مكان له"}]'::jsonb, 'c', 'القوائم (الأرجل) عضوٌ للمشي والعدو والقفز، فالحيوان الذي يتنقّل بها يعيش في البَرّ على الأرض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3773714-d38b-5cd6-bdad-ca23c2bce4d2', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'أيّ زوجٍ صحيحٌ تمامًا: حيوان ← المكان ← طريقة التنقّل؟', '[{"id":"a","text":"العصفور ← الماء ← السباحة"},{"id":"b","text":"السمكة ← الهواء ← الطيران"},{"id":"c","text":"السمكة ← الماء ← السباحة"},{"id":"d","text":"الأرنب ← الماء ← السباحة"}]'::jsonb, 'c', 'السمكة تعيش في الماء وتتنقّل فيه بالسباحة بزعانفها، فالزوج صحيح. أمّا البقيّة ففيها خلطٌ بين المكان وطريقة التنقّل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2638a256-7a73-554f-8de1-f116a6c855f9', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'في قائمة: «أرنب، حصان، عصفور، سمكة». كم حيوانًا يتنقّل بالقوائم؟', '[{"id":"a","text":"اثنان (2)"},{"id":"b","text":"أربعة (4)"},{"id":"c","text":"لا يوجد"},{"id":"d","text":"ثلاثة (3)"}]'::jsonb, 'a', 'الأرنب والحصان يتنقّلان بالقوائم في البَرّ، أي اثنان (2). أمّا العصفور فيطير بأجنحته والسمكة تسبح بزعانفها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('784ed6cb-c659-5a09-ab83-df40e865082f', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"السمكة تطير بأجنحتها"},{"id":"b","text":"العصفور يطير بأجنحته والسمكة تسبح بزعانفها"},{"id":"c","text":"الأرنب يسبح بزعانفه"},{"id":"d","text":"الحصان يطير في الهواء"}]'::jsonb, 'b', 'العصفور له أجنحة يطير بها، والسمكة لها زعانف تسبح بها. أمّا الجمل الأخرى ففيها خلطٌ بين العضو وطريقة التنقّل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5287d78-d360-530a-8d98-36869ae18cdf', 'be5fd8a6-d96f-5ec6-ab28-8f4c3a2c11d5', 'لماذا نقول إنّ السمكة تسبح ولا تطير؟', '[{"id":"a","text":"لأنّ لونها برتقالي"},{"id":"b","text":"لأنّها صغيرة الحجم"},{"id":"c","text":"لأنّها تحبّ الماء فقط"},{"id":"d","text":"لأنّها تعيش في الماء ولها زعانف لا أجنحة"}]'::jsonb, 'd', 'ما يحدّد طريقة التنقّل هو العضو والمكان: السمكة تعيش في الماء ولها زعانف لا أجنحة، فهي تسبح ولا تطير.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a759be6b-654f-5497-98bb-7126c46c6987', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('1d270559-2a4f-5694-bdb7-c68f0913d6b4', 'a759be6b-654f-5497-98bb-7126c46c6987', 'بأيّ عضوٍ نتنفّس عادةً؟', '[{"id":"a","text":"بالأنف"},{"id":"b","text":"بالأذن"},{"id":"c","text":"بالعين"},{"id":"d","text":"باليد"}]'::jsonb, 'a', 'نحن نتنفّس بالأنف: يدخل الهواء ويخرج منه في حركتي الشهيق والزفير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afbefc78-f752-5b91-b138-f064b6af59ca', 'a759be6b-654f-5497-98bb-7126c46c6987', 'ماذا نسمّي إدخال الهواء إلى الداخل؟', '[{"id":"a","text":"الزفير"},{"id":"b","text":"الشهيق"},{"id":"c","text":"العُطاس"},{"id":"d","text":"النوم"}]'::jsonb, 'b', 'الشهيق هو إدخال الهواء النقيّ إلى الداخل، وعندها يرتفع الصدر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e006f484-48cc-5acc-8617-075b1d26fdae', 'a759be6b-654f-5497-98bb-7126c46c6987', 'أين تتنفّس السمكة؟', '[{"id":"a","text":"في الهواء فقط"},{"id":"b","text":"فوق الشجرة"},{"id":"c","text":"في الماء"},{"id":"d","text":"تحت الرمل"}]'::jsonb, 'c', 'السمكة تعيش وتتنفّس في الماء، ولا تخرج إلى الهواء لتتنفّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d55aef0-7d96-5b2a-9a5e-5e96a919b8fa', 'a759be6b-654f-5497-98bb-7126c46c6987', 'ماذا نسمّي إخراج الهواء إلى الخارج؟', '[{"id":"a","text":"الشهيق"},{"id":"b","text":"الجري"},{"id":"c","text":"الأكل"},{"id":"d","text":"الزفير"}]'::jsonb, 'd', 'الزفير هو إخراج الهواء إلى الخارج، وعندها ينزل الصدر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4af96bd5-ab9e-5ee9-8bad-dfb27cfed972', 'a759be6b-654f-5497-98bb-7126c46c6987', 'ماذا يحدث للتنفّس عند الزكام؟', '[{"id":"a","text":"ينسدّ الأنف فيصعب دخول الهواء"},{"id":"b","text":"يصير التنفّس أسهل"},{"id":"c","text":"نتوقّف عن النوم فقط"},{"id":"d","text":"يتغيّر لون العينين"}]'::jsonb, 'a', 'في الزكام ينسدّ الأنف، فيصعب دخول الهواء ويصير التنفّس متعِبًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3592e190-995d-5f2d-b443-3215d80761f9', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', '⭐ تمرين: شهيق وزفير', 1, 50, 10, 'practice', 'admin', 1)
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
  ('77643e23-4c93-5650-bc86-e73cbdcd3e7a', '3592e190-995d-5f2d-b443-3215d80761f9', 'بأيّ عضوٍ ندخِل الهواء ونُخرِجه؟', '[{"id":"a","text":"بالأنف"},{"id":"b","text":"بالقدم"},{"id":"c","text":"بالشعر"},{"id":"d","text":"بالأذن"}]'::jsonb, 'a', 'نتنفّس بالأنف: منه يدخل الهواء النقيّ ومنه يخرج.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9232522b-7078-571b-8cb8-643fd215b4dc', '3592e190-995d-5f2d-b443-3215d80761f9', 'عند الشهيق، ماذا يحدث للهواء؟', '[{"id":"a","text":"يخرج إلى الخارج"},{"id":"b","text":"يدخل إلى الداخل"},{"id":"c","text":"يبقى ساكنًا لا يتحرّك"},{"id":"d","text":"يتحوّل إلى ماء"}]'::jsonb, 'b', 'الشهيق هو إدخال الهواء إلى الداخل، وعندها يرتفع الصدر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a310bfd-a9ae-580b-8ac0-2ddb7ce40902', '3592e190-995d-5f2d-b443-3215d80761f9', 'هل نتنفّس ونحن نائمون؟', '[{"id":"a","text":"نتوقّف عن التنفّس في النوم"},{"id":"b","text":"نتنفّس مرّةً في اليوم فقط"},{"id":"c","text":"نعم، نتنفّس دائمًا حتّى في النوم"},{"id":"d","text":"نتنفّس بالعين أثناء النوم"}]'::jsonb, 'c', 'نحن نتنفّس في كلّ لحظةٍ بلا توقّف، في اللعب وفي النوم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcc4dbe9-6c57-5fa7-9362-373908ddbec5', '3592e190-995d-5f2d-b443-3215d80761f9', 'هذا الطفل يُدخِل الهواء الأزرق من أنفه. ماذا يفعل؟<svg viewBox="0 0 130 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="78" cy="50" r="30" fill="#fdba74"/><ellipse cx="62" cy="56" rx="6" ry="8" fill="#fb7185"/><circle cx="72" cy="42" r="3" fill="#1f2937" stroke="none"/><circle cx="88" cy="42" r="3" fill="#1f2937" stroke="none"/><path d="M70 64 q8 6 16 0" fill="none"/><line x1="10" y1="56" x2="50" y2="56" stroke="#3b82f6" stroke-width="4"/><polygon points="50,50 60,56 50,62" fill="#3b82f6" stroke="none"/></g></svg>', '[{"id":"a","text":"يشهق (يُدخِل الهواء)"},{"id":"b","text":"يأكل الطعام"},{"id":"c","text":"يشرب الماء"},{"id":"d","text":"ينام بعمق"}]'::jsonb, 'a', 'السهم الأزرق يدخل نحو الأنف، فالطفل يشهق أي يُدخِل الهواء إلى الداخل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d287125-890d-516b-a2ad-d85ce5fa2b0d', '3592e190-995d-5f2d-b443-3215d80761f9', 'أين تتنفّس السمكة؟', '[{"id":"a","text":"في الهواء فوق الماء"},{"id":"b","text":"في الماء"},{"id":"c","text":"في الرمل"},{"id":"d","text":"على الشجرة"}]'::jsonb, 'b', 'السمكة تتنفّس في الماء؛ فهي تعيش فيه ولا تخرج إلى الهواء لتتنفّس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('865d8454-6ece-565c-8846-70857fb82128', '3592e190-995d-5f2d-b443-3215d80761f9', 'أيّ حيوانٍ يتنفّس في الهواء مثل الإنسان؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"السمكة الكبيرة"},{"id":"c","text":"أيّ حيوانٍ يعيش في الماء"},{"id":"d","text":"العصفور"}]'::jsonb, 'd', 'العصفور يتنفّس في الهواء مثل الإنسان والقطّ، أمّا السمكة فتتنفّس في الماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0905a46d-e99c-518d-9aa2-40f480b7c258', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد النفَس', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ee1b4883-7904-5baa-8748-f1aaadb0b824', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'في حركة الزفير، ماذا يحدث للصدر؟', '[{"id":"a","text":"ينزل لأنّ الهواء يخرج"},{"id":"b","text":"يرتفع لأنّ الهواء يدخل"},{"id":"c","text":"يبقى كما هو تمامًا"},{"id":"d","text":"يختفي الصدر"}]'::jsonb, 'a', 'في الزفير يخرج الهواء إلى الخارج، فينزل الصدر. أمّا في الشهيق فيرتفع.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99f58de0-027a-51e5-b92e-939da182fc39', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'متى يفيدنا التنفّس العميق؟', '[{"id":"a","text":"ليس له أيّ فائدة"},{"id":"b","text":"يُهدّئنا عند التعب أو الخوف"},{"id":"c","text":"يجعلنا نتوقّف عن التنفّس"},{"id":"d","text":"يملأ المعدة بالطعام"}]'::jsonb, 'b', 'التنفّس العميق (شهيق وزفير ببطء) يُريح الجسم ويُهدّئنا عند التعب أو الخوف.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db1e4933-3d88-5725-9dab-c8922275af33', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'قال طفل: «السمكة تتنفّس في الهواء مثلنا». ما الصحيح؟', '[{"id":"a","text":"صحيح، كلّ الحيوانات تتنفّس في الهواء"},{"id":"b","text":"السمكة لا تتنفّس أبدًا"},{"id":"c","text":"خطأ، السمكة تتنفّس في الماء وكلٌّ يتنفّس في وسطه"},{"id":"d","text":"السمكة تتنفّس بالأذن"}]'::jsonb, 'c', 'الخطأ الشائع: الظنّ أنّ كلّ الحيوانات تتنفّس في الهواء. السمكة تتنفّس في الماء؛ لكلّ كائنٍ وسطٌ يتنفّس فيه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e4411f0-9a83-5a97-8ab9-01208968bc38', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'لماذا يصعب التنفّس عند الزكام؟', '[{"id":"a","text":"لأنّ العينين تُغلقان"},{"id":"b","text":"لأنّ الأذن تمتلئ بالماء"},{"id":"c","text":"لأنّ القدمين تتعبان"},{"id":"d","text":"لأنّ الأنف ينسدّ فيصعب دخول الهواء"}]'::jsonb, 'd', 'في الزكام ينسدّ الأنف، والأنف هو طريق الهواء، فيصير دخول الهواء صعبًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07572ad5-ad8c-5ee2-9550-a0bf27d212d1', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'ما القاعدة الصحّية الصحيحة للمحافظة على تنفّسٍ سليم؟', '[{"id":"a","text":"نستنشق الدُّخان كثيرًا"},{"id":"b","text":"نُغطّي الفم والأنف عند السُّعال ونتنفّس هواءً نقيًّا"},{"id":"c","text":"نسدّ الأنف دائمًا"},{"id":"d","text":"نتنفّس في غرفةٍ مليئةٍ بالدُّخان"}]'::jsonb, 'b', 'للمحافظة على تنفّسٍ سليم نتنفّس هواءً نقيًّا، ونُغطّي الفم والأنف عند السُّعال، ونبتعد عن الدُّخان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e62fca4-a1e9-58b3-abf2-1a5d4305fa1a', '0905a46d-e99c-518d-9aa2-40f480b7c258', 'هذا الحيوان داخل الماء كما في الصورة. كيف يتنفّس؟<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="4" width="122" height="82" rx="8" fill="#3b82f6"/><g stroke="#1f2937" stroke-width="2"><ellipse cx="60" cy="46" rx="30" ry="17" fill="#fb923c"/><polygon points="88,46 110,32 110,60" fill="#fb923c"/><circle cx="42" cy="42" r="3" fill="#1f2937" stroke="none"/><path d="M30 46 q6 5 12 0" fill="none"/><circle cx="22" cy="22" r="4" fill="none" stroke="#bfdbfe"/><circle cx="34" cy="14" r="3" fill="none" stroke="#bfdbfe"/></g></svg>', '[{"id":"a","text":"يخرج إلى الهواء كي يتنفّس"},{"id":"b","text":"لا يتنفّس مطلقًا"},{"id":"c","text":"يتنفّس في الماء حيث يعيش"},{"id":"d","text":"يتنفّس بأذنيه على اليابسة"}]'::jsonb, 'c', 'الصورة تُظهر سمكةً في الماء الأزرق؛ والسمكة تتنفّس في الماء ولا تخرج إلى الهواء لتتنفّس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: نتنفّس بسلام (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('7b136959-fb8d-545e-b7fe-eff9bb34ac10', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'أكمل: في الشهيق يرتفع الصدر، وفي الزفير …', '[{"id":"a","text":"ينزل الصدر"},{"id":"b","text":"يرتفع الصدر أكثر"},{"id":"c","text":"يدور الصدر"},{"id":"d","text":"يختفي الصدر"}]'::jsonb, 'a', 'في الزفير يخرج الهواء، فينزل الصدر؛ عكس الشهيق الذي يرتفع فيه الصدر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9473b71-8a2a-58d9-aead-06b23cc186ea', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'أيّ هذه يتنفّس في الماء؟', '[{"id":"a","text":"العصفور"},{"id":"b","text":"السمكة"},{"id":"c","text":"القطّ"},{"id":"d","text":"الإنسان"}]'::jsonb, 'b', 'السمكة تتنفّس في الماء، أمّا العصفور والقطّ والإنسان فيتنفّسون في الهواء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e80d806-564d-5146-b539-64a7d7739b53', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'كيف يكون التنفّس العميق؟', '[{"id":"a","text":"نتنفّس بسرعةٍ كبيرة ثمّ نتوقّف"},{"id":"b","text":"نسدّ الأنف ولا نتنفّس"},{"id":"c","text":"نشهق ونزفر ببطءٍ حتّى يمتلئ الصدر"},{"id":"d","text":"نتنفّس بالفم تحت الماء"}]'::jsonb, 'c', 'التنفّس العميق يكون بشهيقٍ وزفيرٍ بطيئين حتّى يمتلئ الصدر بالهواء، وهو يُريحنا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa7ae8d6-380f-5447-9e4d-6754e8044632', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'طفلٌ مصابٌ بالزكام وأنفه مسدود. لماذا يتنفّس بصعوبة؟', '[{"id":"a","text":"لأنّه يأكل كثيرًا"},{"id":"b","text":"لأنّه يجري بسرعة"},{"id":"c","text":"لأنّ عينيه متعبتان"},{"id":"d","text":"لأنّ الأنف المسدود يمنع دخول الهواء"}]'::jsonb, 'd', 'الأنف طريق الهواء؛ فإذا انسدّ بسبب الزكام صعب دخول الهواء وصار التنفّس متعِبًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9cc4661-b029-509e-b4ab-eca2bdf40c98', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'ماذا نفعل عند السُّعال للمحافظة على الآخرين؟', '[{"id":"a","text":"نفتح النافذة فقط"},{"id":"b","text":"نسدّ آذاننا"},{"id":"c","text":"نُغطّي الفم والأنف"},{"id":"d","text":"نغمض العينين"}]'::jsonb, 'c', 'نُغطّي الفم والأنف عند السُّعال أو العُطاس؛ فهذه قاعدةٌ صحّية تحمينا وتحمي غيرنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04315d18-1657-5a51-9e55-e1362e87d2cd', '9c1c5634-3cc4-57bc-a3df-bd055fefe2bf', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"نتنفّس بالأذن، والسمكة تتنفّس في الهواء"},{"id":"b","text":"الشهيق يُخرِج الهواء، والزفير يُدخِله"},{"id":"c","text":"نتنفّس بالعين، والسمكة تطير في السماء"},{"id":"d","text":"نتنفّس بالأنف، والسمكة تتنفّس في الماء"}]'::jsonb, 'd', 'نحن نتنفّس بالأنف في الهواء، والسمكة تتنفّس في الماء؛ أمّا بقيّة الجمل ففيها خلطٌ في عضو التنفّس أو في وسطه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: حارس الهواء النقيّ', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('2d5bda67-9e88-548b-bd23-7e9bea185d0b', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'نرتّب حركتي التنفّس. أيّهما يدخل فيه الهواء؟', '[{"id":"a","text":"الشهيق"},{"id":"b","text":"الزفير"},{"id":"c","text":"العُطاس"},{"id":"d","text":"لا شيء، الهواء لا يتحرّك"}]'::jsonb, 'a', 'في الشهيق يدخل الهواء النقيّ إلى الداخل ويرتفع الصدر، أمّا في الزفير فيخرج الهواء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44f9cc92-9589-5a79-94a3-fdfb0b22a26c', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'قال طفل: «كلّ الحيوانات تتنفّس في الهواء». ما الصحيح؟', '[{"id":"a","text":"صحيح، حتّى السمكة تتنفّس في الهواء"},{"id":"b","text":"خطأ، السمكة تتنفّس في الماء؛ لكلّ كائنٍ وسطه"},{"id":"c","text":"كلّ الحيوانات تتنفّس في الماء"},{"id":"d","text":"الحيوانات لا تتنفّس"}]'::jsonb, 'b', 'الخطأ الشائع: تعميم أنّ الكلّ يتنفّس في الهواء. السمكة تتنفّس في الماء؛ فمنها ما يتنفّس في الهواء ومنها ما يتنفّس في الماء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85b82a83-ddbe-5c22-a2eb-e37302529ba2', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'في غرفةٍ مليئةٍ بالدُّخان، لماذا يصعب التنفّس؟', '[{"id":"a","text":"لأنّ الدُّخان طعامٌ مفيد"},{"id":"b","text":"لأنّ الغرفة باردة فقط"},{"id":"c","text":"لأنّ الهواء ليس نقيًّا والدُّخان يؤذي التنفّس"},{"id":"d","text":"لأنّ النوافذ مفتوحة"}]'::jsonb, 'c', 'الدُّخان يجعل الهواء غير نقيّ ويؤذي التنفّس؛ لذلك نبتعد عنه ونتنفّس هواءً نقيًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3b8556c-1afc-58ca-821e-61e783e7e722', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'قال طفل: «التنفّس العميق يتعبنا ولا فائدة منه». ما الصحيح؟', '[{"id":"a","text":"صحيح، التنفّس العميق ضارّ"},{"id":"b","text":"التنفّس العميق يجعلنا نختنق"},{"id":"c","text":"يجب ألّا نتنفّس بعمقٍ أبدًا"},{"id":"d","text":"خطأ، التنفّس العميق يُهدّئنا ويُريح الجسم"}]'::jsonb, 'd', 'الخطأ الشائع: الظنّ أنّ التنفّس العميق ضارّ. بل هو مفيد: يُريح الجسم ويُهدّئنا عند التعب أو الخوف.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54a36307-c054-5302-9287-87331f79c3b1', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'هذه الصورة تُظهر الرئتين تمتلئان بالهواء الأزرق. متى يحدث ذلك؟<svg viewBox="0 0 120 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><line x1="60" y1="18" x2="60" y2="42" stroke="#3b82f6" stroke-width="4"/><path d="M58 40 q-22 4 -22 28 q0 18 14 22 q8 2 8 -10 z" fill="#fb7185"/><path d="M62 40 q22 4 22 28 q0 18 -14 22 q-8 2 -8 -10 z" fill="#fb7185"/><line x1="60" y1="42" x2="60" y2="80"/></g></svg>', '[{"id":"a","text":"عند الجري فقط دون تنفّس"},{"id":"b","text":"عند النوم دون هواء"},{"id":"c","text":"عندما نسدّ الأنف"},{"id":"d","text":"عند الشهيق حين يدخل الهواء إلى الرئتين"}]'::jsonb, 'd', 'الصورة تُظهر هواءً أزرق يدخل إلى رئتين ورديّتين؛ وهذا يحدث عند الشهيق حين يدخل الهواء فتمتلئ الرئتان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9ce0a4a-7f6f-50b0-831a-057f4ee4f8df', 'b7767a5f-f7bc-584e-8da0-76f1cdcd50e6', 'أيّ مجموعةٍ كلّها قواعد صحّية لتنفّسٍ سليم؟', '[{"id":"a","text":"هواءٌ نقيّ، تغطية الفم عند السُّعال، الابتعاد عن الدُّخان"},{"id":"b","text":"استنشاق الدُّخان، سدّ الأنف، البقاء في غرفةٍ مغلقة"},{"id":"c","text":"السُّعال على وجه الآخرين، استنشاق الغبار"},{"id":"d","text":"عدم تهوية الغرفة أبدًا"}]'::jsonb, 'a', 'القواعد الصحّية السليمة هي تنفّس الهواء النقيّ، وتغطية الفم والأنف عند السُّعال، والابتعاد عن الدُّخان؛ أمّا الباقي فعاداتٌ تؤذي التنفّس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2bbb872c-0bf9-511a-8800-3b0116946564', 'c04cb291-0d7d-5753-93c9-8893645e5990', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتنفّس', 3, 120, 30, 'boss', 'admin', 5)
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
  ('3ef0f19e-eb4f-578a-bb25-b1e10252b1de', '2bbb872c-0bf9-511a-8800-3b0116946564', 'أكمل: ندخِل الهواء ونُخرِجه عن طريق …', '[{"id":"a","text":"الأنف"},{"id":"b","text":"العين"},{"id":"c","text":"الأذن"},{"id":"d","text":"القدم"}]'::jsonb, 'a', 'نتنفّس بالأنف؛ فمنه يدخل الهواء النقيّ ومنه يخرج في الشهيق والزفير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c80ae98-2eeb-5de0-adb0-7947387e778d', '2bbb872c-0bf9-511a-8800-3b0116946564', 'أيّ زوجٍ صحيح: الحركة ← ما يحدث؟', '[{"id":"a","text":"الشهيق ← يخرج الهواء"},{"id":"b","text":"الزفير ← يخرج الهواء"},{"id":"c","text":"الشهيق ← ينام الجسم"},{"id":"d","text":"الزفير ← يدخل الطعام"}]'::jsonb, 'b', 'الزفير يخرج فيه الهواء إلى الخارج، أمّا الشهيق فيدخل فيه الهواء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f060f94-ac60-50cd-b9e7-0e8a7d4a329e', '2bbb872c-0bf9-511a-8800-3b0116946564', 'حيوانٌ لو أخرجناه من الماء يختنق. ما هو؟', '[{"id":"a","text":"القطّ"},{"id":"b","text":"العصفور"},{"id":"c","text":"السمكة"},{"id":"d","text":"الكلب"}]'::jsonb, 'c', 'السمكة تتنفّس في الماء؛ فإذا أخرجناها إلى الهواء تختنق، لأنّ وسطها هو الماء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0692dc0-d797-5c60-a684-d6a86b560677', '2bbb872c-0bf9-511a-8800-3b0116946564', 'لماذا نُغطّي الفم والأنف عند العُطاس؟', '[{"id":"a","text":"لكي نأكل بسرعة"},{"id":"b","text":"لكي نسمع جيّدًا"},{"id":"c","text":"لكي نجري أسرع"},{"id":"d","text":"قاعدةٌ صحّية تحمينا وتحمي غيرنا"}]'::jsonb, 'd', 'تغطية الفم والأنف عند العُطاس أو السُّعال قاعدةٌ صحّية تمنع نشر المرض وتحافظ على تنفّسٍ سليم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('565d0a86-2e44-5be6-aefe-9862d01fc948', '2bbb872c-0bf9-511a-8800-3b0116946564', 'طفلٌ خائفٌ ومتعب. ما الذي يساعده على الهدوء؟', '[{"id":"a","text":"التنفّس العميق ببطء"},{"id":"b","text":"حبس النفَس طويلًا"},{"id":"c","text":"استنشاق الدُّخان"},{"id":"d","text":"سدّ الأنف"}]'::jsonb, 'a', 'التنفّس العميق (شهيق وزفير ببطء) يُريح الجسم ويُهدّئ الطفل عند الخوف أو التعب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a44597c-16be-53b5-b2c5-212b30968816', '2bbb872c-0bf9-511a-8800-3b0116946564', 'أيّ جملةٍ صحيحةٌ عن أوساط التنفّس؟', '[{"id":"a","text":"كلّ الحيوانات تتنفّس في الماء"},{"id":"b","text":"بعض الحيوانات تتنفّس في الهواء وبعضها في الماء"},{"id":"c","text":"كلّ الحيوانات تتنفّس بالأذن"},{"id":"d","text":"الحيوانات لا تحتاج إلى الهواء أبدًا"}]'::jsonb, 'b', 'لكلّ كائنٍ وسطٌ يتنفّس فيه: القطّ والعصفور في الهواء، والسمكة في الماء؛ فليس الجميع في وسطٍ واحد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('9d089130-178b-55ee-8700-10fb84cfb355', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'شجرتان متساويتان، واحدة قريبة وواحدة بعيدة. أيّهما تبدو أكبر؟', '[{"id":"a","text":"الشّجرة القريبة"},{"id":"b","text":"الشّجرة البعيدة"},{"id":"c","text":"تبدوان متساويتين في النظر"},{"id":"d","text":"لا نراهما أبدًا"}]'::jsonb, 'a', 'الجسم القريب منّا يظهر كبيرًا، فالشّجرة القريبة تبدو أكبر من البعيدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67aebe48-c514-5a7b-98bf-4094fcbb86d1', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'الجسم البعيد عنّا… كيف يظهر في نظرنا؟', '[{"id":"a","text":"يظهر كبيرًا جدًّا"},{"id":"b","text":"يظهر صغيرًا"},{"id":"c","text":"يختفي تمامًا دائمًا"},{"id":"d","text":"يصير سائلًا"}]'::jsonb, 'b', 'كلّما ابتعد الجسم عنّا بدا أصغر، فالجسم البعيد يظهر صغيرًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fe8e35a-ee1f-5a49-8bde-a4d9af5dbba4', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'كرةٌ تقف أمام كرةٍ أخرى وتحجب جزءًا منها. أيّ الكرتين أقرب إلينا؟', '[{"id":"a","text":"الكرة المحجوبة (الخلفيّة)"},{"id":"b","text":"الكرتان على نفس البُعد"},{"id":"c","text":"الكرة التي تحجب (الأماميّة)"},{"id":"d","text":"لا توجد كرةٌ أقرب"}]'::jsonb, 'c', 'الجسم الذي يحجب غيره يكون أمامه، أي الأقرب إلينا؛ والمحجوب هو الأبعد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c158fee-4ae0-596f-9361-0290adddb50b', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'بأيّ وحدةٍ نقيس طول الطّاولة؟', '[{"id":"a","text":"باللتر (L)"},{"id":"b","text":"بعدد الحيوانات"},{"id":"c","text":"بالألوان"},{"id":"d","text":"بالمتر (m)"}]'::jsonb, 'd', 'نقيس الأطوال والمسافات بالمتر (m)، فطول الطّاولة يُقاس بالمتر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4d78067-3d7c-5f5e-89b3-a66fe2326412', '171a16ce-6ca9-5f35-8cae-bc9b1591c563', 'أردنا قيس كمّيّة الماء في قارورة. أيّ وحدةٍ نختار؟', '[{"id":"a","text":"المتر (m)"},{"id":"b","text":"اللتر (L)"},{"id":"c","text":"طول الحبل"},{"id":"d","text":"عدد الأشجار"}]'::jsonb, 'b', 'السوائل مثل الماء تُقاس بالسعة، ووحدتها اللتر (L)، فنختار اللتر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', '⭐ تمرين: قريب أم بعيد؟ بالمتر أم باللتر؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7346ae17-2c83-519d-b076-21c1ba7c2f95', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'طائرتان متماثلتان، واحدة قريبة وواحدة بعيدة في السماء. القريبة تبدو…', '[{"id":"a","text":"كبيرة"},{"id":"b","text":"صغيرة"},{"id":"c","text":"غير موجودة"},{"id":"d","text":"سائلة"}]'::jsonb, 'a', 'الجسم القريب منّا يظهر كبيرًا، فالطّائرة القريبة تبدو كبيرة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f43313bc-1667-59c7-ad1b-55679567310d', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'سيّارةٌ ابتعدت كثيرًا على الطّريق. كيف تبدو الآن؟', '[{"id":"a","text":"تكبر أكثر فأكثر"},{"id":"b","text":"تبدو صغيرة"},{"id":"c","text":"تطير في الهواء"},{"id":"d","text":"تتحوّل إلى ماء"}]'::jsonb, 'b', 'كلّما ابتعد الجسم عنّا بدا أصغر، فالسيّارة البعيدة تبدو صغيرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2977c18d-55b9-5fe6-a54c-9d23b1599ed0', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'بأيّ وحدةٍ نقيس المسافة بين البيت والمدرسة؟', '[{"id":"a","text":"باللتر (L)"},{"id":"b","text":"بعدد القوارير"},{"id":"c","text":"بالمتر (m)"},{"id":"d","text":"بكمّيّة الحليب"}]'::jsonb, 'c', 'المسافة طولٌ بين مكانين، ونقيس الأطوال بالمتر (m).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4764222d-636d-5e6e-8a14-a21cb818db86', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'في الصورة شجرتان متماثلتان. أيّ شجرةٍ هي الأقرب إلينا؟<svg viewBox="0 0 220 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><line x1="10" y1="95" x2="210" y2="95"/><rect x="34" y="58" width="12" height="37" fill="#a16207"/><circle cx="40" cy="46" r="27" fill="#22c55e"/><rect x="176" y="74" width="6" height="18" fill="#a16207"/><circle cx="179" cy="68" r="12" fill="#16a34a"/><circle cx="120" cy="22" r="11" fill="#fcd34d"/></g></svg>', '[{"id":"a","text":"الشّجرة الصغيرة على اليمين"},{"id":"b","text":"الشّمس في الأعلى"},{"id":"c","text":"لا فرق، الشّجرتان على نفس البُعد"},{"id":"d","text":"الشّجرة الكبيرة على اليسار"}]'::jsonb, 'd', 'الشّجرة الكبيرة تبدو كبيرة لأنّها قريبة، والصغيرة تبدو صغيرة لأنّها بعيدة؛ فالأقرب هي الكبيرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8059ccf-8da0-5641-a425-eb0b5092f0ac', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'نريد قيس كمّيّة الحليب في علبة. أيّ وحدةٍ نختار؟', '[{"id":"a","text":"اللتر (L)"},{"id":"b","text":"المتر (m)"},{"id":"c","text":"طول العلبة"},{"id":"d","text":"عدد الأشجار"}]'::jsonb, 'a', 'الحليب سائل، والسوائل تُقاس بالسعة ووحدتها اللتر (L).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61850603-bb56-5e49-922f-bba1a3d355bf', '50eff900-4c3a-537c-b216-5ebcc36fd4e2', 'ولدٌ يقف أمام صديقه فيحجب جزءًا منه عنك. أيّهما أقرب إليك؟', '[{"id":"a","text":"الصديق المحجوب خلفه"},{"id":"b","text":"هما على نفس البُعد تمامًا"},{"id":"c","text":"الولد الذي يحجب (الأمامي)"},{"id":"d","text":"لا أحد منهما قريب"}]'::jsonb, 'c', 'مَن يحجب غيره يكون أمامه، أي الأقرب إليك؛ فالولد الأمامي هو الأقرب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد القريب والبعيد', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a4927644-04e4-5a09-8235-b0b52ed2eac5', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'نفس البالون يبتعد عنك شيئًا فشيئًا. كيف يتغيّر حجمه الظاهر؟', '[{"id":"a","text":"يكبر كلّما ابتعد"},{"id":"b","text":"يصغر كلّما ابتعد"},{"id":"c","text":"لا يتغيّر أبدًا"},{"id":"d","text":"يتحوّل إلى لتر"}]'::jsonb, 'b', 'نفس الجسم يبدو أصغر كلّما ابتعد عنّا، فالبالون المبتعد يصغر في نظرنا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76153d40-aa93-5ffa-b1be-b1bb2a0ba15f', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'قارورةٌ فيها ماء، وحبلٌ على الأرض. أيّ قياسٍ صحيح؟', '[{"id":"a","text":"نقيس الماء بالمتر والحبل باللتر"},{"id":"b","text":"نقيس الاثنين باللتر"},{"id":"c","text":"نقيس الماء باللتر والحبل بالمتر"},{"id":"d","text":"نقيس الاثنين بالمتر"}]'::jsonb, 'c', 'الماء سائلٌ يُقاس باللتر (L)، والحبل طولٌ يُقاس بالمتر (m)؛ فلكلٍّ وحدته الملائمة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0a7e45b-1fc7-53e8-83df-904e61f02855', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'صحنٌ يقف أمام صحنٍ آخر ويحجبه كلّه، فلا نرى الخلفيّ. ماذا نسمّي هذه التغطية؟', '[{"id":"a","text":"تغطية كلّية"},{"id":"b","text":"تغطية جزئيّة"},{"id":"c","text":"لا توجد تغطية"},{"id":"d","text":"قياسٌ باللتر"}]'::jsonb, 'a', 'عندما يحجب الجسم الأمامي الجسم الخلفي كلّه فلا نراه، تكون التغطية كلّية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57917e57-b39f-5d30-806b-ce7e2184e8ab', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'قال طفل: «البيت يبدو صغيرًا، إذن البيت أصغر من قلمي». ما الصحيح؟', '[{"id":"a","text":"صحيح، البيت أصغر من القلم فعلًا"},{"id":"b","text":"البيت لا يُقاس بالمتر"},{"id":"c","text":"القلم بعيدٌ دائمًا"},{"id":"d","text":"البيت يبدو صغيرًا لأنّه بعيد، لكنّه في الحقيقة كبير"}]'::jsonb, 'd', 'الخطأ الشائع: الخلط بين الحجم الظاهر والحجم الحقيقي. البيت البعيد يبدو صغيرًا في النظر فقط، أمّا في الحقيقة فهو أكبر من القلم بكثير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('205334da-290f-5a07-899d-23c714b0bdf1', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'في الصورة دائرتان، إحداهما تحجب جزءًا من الأخرى. أيّ دائرةٍ هي الأقرب؟<svg viewBox="0 0 170 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><circle cx="105" cy="56" r="32" fill="#3b82f6"/><circle cx="66" cy="62" r="32" fill="#ef4444"/></g></svg>', '[{"id":"a","text":"الزرقاء، لأنّها في الخلف"},{"id":"b","text":"الحمراء، لأنّها تحجب الزرقاء"},{"id":"c","text":"الاثنتان على نفس البُعد"},{"id":"d","text":"لا نستطيع أن نعرف أبدًا"}]'::jsonb, 'b', 'الدائرة الحمراء تحجب جزءًا من الزرقاء، فهي أمامها أي الأقرب إلينا؛ والزرقاء المحجوبة هي الأبعد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae079820-81d7-5f94-9357-be1256ef0c1a', '9b8ac6d7-9e62-526a-b1e9-e5dbc1191d6d', 'أردنا قيس كمّيّة العصير في إبريق، وطول الإبريق نفسه. ما الوحدتان الصحيحتان بالترتيب؟', '[{"id":"a","text":"متر للعصير، ولتر للطول"},{"id":"b","text":"لتر للعصير، ولتر للطول"},{"id":"c","text":"لتر للعصير، ومتر للطول"},{"id":"d","text":"متر للعصير، ومتر للطول"}]'::jsonb, 'c', 'الخطأ الشائع: استعمال وحدةٍ واحدة لكلّ شيء. العصير سائلٌ يُقاس باللتر (L)، وطول الإبريق يُقاس بالمتر (m).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('da1fb36e-82ee-5396-b522-d95554347101', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: الفضاء والقيس (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('6ed90f9a-3677-5b0e-94f0-4db4ef3d7b86', 'da1fb36e-82ee-5396-b522-d95554347101', 'أكمل: الجسم القريب منّا يظهر … والجسم البعيد يظهر …', '[{"id":"a","text":"صغيرًا … كبيرًا"},{"id":"b","text":"كبيرًا … صغيرًا"},{"id":"c","text":"سائلًا … صلبًا"},{"id":"d","text":"قريبًا … قريبًا"}]'::jsonb, 'b', 'القاعدة: القريب يظهر كبيرًا والبعيد يظهر صغيرًا، وهذا ما نسمّيه الأبعاد الظاهريّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6ca1a9b-a820-5564-bc19-e5bd938d43af', 'da1fb36e-82ee-5396-b522-d95554347101', 'وحدة قيس الأطوال هي…', '[{"id":"a","text":"المتر (m)"},{"id":"b","text":"اللتر (L)"},{"id":"c","text":"اللون"},{"id":"d","text":"العدد"}]'::jsonb, 'a', 'نقيس الأطوال والمسافات بالمتر (m)، فهو وحدة قيس الأطوال.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('008049cc-6554-57b6-bddb-e5ef448c5bad', 'da1fb36e-82ee-5396-b522-d95554347101', 'أيّ هذه الأشياء نقيسها باللتر (L)؟', '[{"id":"a","text":"طول السبّورة"},{"id":"b","text":"المسافة إلى الملعب"},{"id":"c","text":"ارتفاع الباب"},{"id":"d","text":"ماء الدلو"}]'::jsonb, 'd', 'اللتر وحدةُ قيس السعات (السوائل)، فماء الدلو يُقاس باللتر؛ أمّا الباقي فأطوالٌ تُقاس بالمتر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ab5b4df-6ec1-58bd-87cd-43cbac63a0b2', 'da1fb36e-82ee-5396-b522-d95554347101', 'شجرةٌ تبدو صغيرة جدًّا وأخرى تبدو كبيرة قُربك. ماذا نستنتج عن المسافة؟', '[{"id":"a","text":"الشّجرتان على نفس البُعد"},{"id":"b","text":"الصغيرة أقرب من الكبيرة"},{"id":"c","text":"الشّجرة الصغيرة أبعد، والكبيرة أقرب"},{"id":"d","text":"لا علاقة للبُعد بالحجم الظاهر"}]'::jsonb, 'c', 'بُعد الأجسام مرتبطٌ بحجمها الظاهر: ما يبدو أصغر يكون أبعد، وما يبدو أكبر يكون أقرب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b10a3e40-ce94-502f-96c7-a2af13a7cf74', 'da1fb36e-82ee-5396-b522-d95554347101', 'كتابٌ يحجب نصف كرّاسٍ خلفه. ما نوع هذه التغطية؟', '[{"id":"a","text":"تغطية كلّية"},{"id":"b","text":"تغطية جزئيّة"},{"id":"c","text":"لا توجد تغطية"},{"id":"d","text":"قياسٌ بالمتر"}]'::jsonb, 'b', 'لمّا يحجب الجسم الأمامي جزءًا من الخلفي فقط (هنا نصف الكرّاس)، تكون التغطية جزئيّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56b56d19-2bf0-5ebf-a60b-704ff949adf5', 'da1fb36e-82ee-5396-b522-d95554347101', 'اختر الجملة الصحيحة تمامًا.', '[{"id":"a","text":"نقيس الماء بالمتر وطول الحبل باللتر"},{"id":"b","text":"الجسم القريب يبدو صغيرًا"},{"id":"c","text":"المحجوب أقرب من الذي يحجبه"},{"id":"d","text":"نقيس الماء باللتر وطول الحبل بالمتر"}]'::jsonb, 'd', 'الصحيح: الماء سائلٌ يُقاس باللتر (L)، والحبل طولٌ يُقاس بالمتر (m). أمّا بقيّة الجمل ففيها خلطٌ في الوحدات أو في القريب والبعيد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ff8af68d-a477-5266-b7f4-c701036d7b2d', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عالِم المسافات والقيس', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('046d1ef9-8fa2-50fe-83e9-24a79e6f8249', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'ثلاث شجراتٍ متماثلة تبدو بأحجامٍ مختلفة: كبيرة، متوسّطة، صغيرة. أيّها الأبعد عنّا؟', '[{"id":"a","text":"الكبيرة"},{"id":"b","text":"المتوسّطة"},{"id":"c","text":"الصغيرة"},{"id":"d","text":"كلّها على نفس البُعد"}]'::jsonb, 'c', 'كلّما بدا الجسم أصغر كان أبعد، فالشّجرة الصغيرة هي الأبعد، والكبيرة هي الأقرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93348d94-5fe6-555c-8269-24619e89d885', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'قال طفل: «الذي يبدو أكبر يكون دائمًا أبعد». ما الصحيح؟', '[{"id":"a","text":"صحيح، الأكبر هو الأبعد"},{"id":"b","text":"خطأ، الذي يبدو أكبر يكون أقرب لا أبعد"},{"id":"c","text":"الحجم لا علاقة له بالبُعد"},{"id":"d","text":"كلّ الأجسام بعيدة"}]'::jsonb, 'b', 'الخطأ الشائع: عكس القاعدة. الجسم الذي يبدو أكبر يكون أقرب إلينا، والذي يبدو أصغر يكون أبعد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23bddb7e-23ce-5a55-8863-f5e7980c0cb8', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'في صفٍّ من الأطفال، كلّ طفلٍ يحجب جزءًا من الذي خلفه. مَن هو أقرب الأطفال إليك؟', '[{"id":"a","text":"الطفل الأمامي الذي لا يحجبه أحد"},{"id":"b","text":"الطفل الأخير في الخلف"},{"id":"c","text":"الطفل المحجوب كلّيًّا"},{"id":"d","text":"كلّهم على نفس البُعد"}]'::jsonb, 'a', 'مَن يحجب غيره ولا يحجبه أحد يكون في المقدّمة، أي الأقرب إليك؛ والمحجوب خلفه أبعد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f2cc5a5-749e-561d-9f35-e1f350fb4a46', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'عندنا: ماءٌ في قارورة، وعصيرٌ في كأس، وطولُ طاولة، ومسافةٌ إلى الباب. كم شيءٍ نقيسه باللتر (L)؟', '[{"id":"a","text":"أربعة (4)"},{"id":"b","text":"ثلاثة (3)"},{"id":"c","text":"لا شيء"},{"id":"d","text":"اثنان (2)"}]'::jsonb, 'd', 'السوائل فقط تُقاس باللتر: الماء والعصير، أي اثنان (2). أمّا طول الطّاولة والمسافة فطولان يُقاسان بالمتر (m).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48367e32-6ea3-592d-b126-48f69758a887', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'في الصورة قارورةٌ مكتوبٌ عليها L. ماذا نقيس بهذه الوحدة؟<svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><rect x="50" y="10" width="20" height="16" fill="#3b82f6"/><path d="M44 26 h32 l6 16 v70 a6 6 0 0 1 -6 6 h-32 a6 6 0 0 1 -6 -6 v-70 z" fill="#dbeafe"/><path d="M38 70 h44 v42 a6 6 0 0 1 -6 6 h-32 a6 6 0 0 1 -6 -6 z" fill="#3b82f6"/><text x="60" y="100" font-size="20" text-anchor="middle" fill="#ffffff" stroke="none">L</text></g></svg>', '[{"id":"a","text":"نقيس طول القارورة"},{"id":"b","text":"نقيس المسافة إلى المدرسة"},{"id":"c","text":"نقيس كمّيّة السائل (الماء)"},{"id":"d","text":"نقيس عدد الأشجار"}]'::jsonb, 'c', 'الحرف L هو رمز اللتر، وهو وحدة قيس السعات؛ فالقارورة فيها سائلٌ (ماء) نقيس كمّيّته باللتر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13abda19-d837-571f-b9c2-7478c8d38210', 'ff8af68d-a477-5266-b7f4-c701036d7b2d', 'قال طفل: «نقيس كمّيّة الحليب بالمتر». أين الخطأ، وما الصواب؟', '[{"id":"a","text":"لا خطأ، الحليب يُقاس بالمتر"},{"id":"b","text":"الخطأ أنّ الحليب سائل، فيُقاس باللتر (L) لا بالمتر"},{"id":"c","text":"الحليب يُقاس بعدد الأبقار"},{"id":"d","text":"الحليب لا يُقاس أبدًا"}]'::jsonb, 'b', 'الخطأ الشائع: قيس سائلٍ بوحدة الأطوال. المتر للأطوال والمسافات، أمّا الحليب فسائلٌ تُقاس كمّيّته باللتر (L).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'd6c74e5e-02a9-53cb-a637-3cddc660e553', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: القريب والبعيد والوحدات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('bba8fa81-5367-5695-9f51-9a1a2e139005', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'عصفورٌ قريبٌ منك وآخر بعيد. أيّهما يبدو أكبر؟', '[{"id":"a","text":"العصفور القريب"},{"id":"b","text":"العصفور البعيد"},{"id":"c","text":"يبدوان متساويين"},{"id":"d","text":"لا نرى العصافير"}]'::jsonb, 'a', 'الجسم القريب يظهر كبيرًا، فالعصفور القريب يبدو أكبر من البعيد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ac3a47e-e38e-5c65-bfb5-bd397d055eb0', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'بأيّ وحدةٍ نقيس طول ملعب كرة القدم؟', '[{"id":"a","text":"باللتر (L)"},{"id":"b","text":"بعدد الكُرات"},{"id":"c","text":"بالمتر (m)"},{"id":"d","text":"بكمّيّة الماء"}]'::jsonb, 'c', 'طول الملعب طولٌ كبير، ونقيس الأطوال والمسافات بالمتر (m).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffe4265b-3c2f-5e12-b4b5-baeaae5fbc71', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'جبلٌ بعيدٌ يبدو صغيرًا في نظرنا. لماذا؟', '[{"id":"a","text":"لأنّ الجبل صغيرٌ في الحقيقة"},{"id":"b","text":"لأنّه بعيدٌ عنّا"},{"id":"c","text":"لأنّه يُقاس باللتر"},{"id":"d","text":"لأنّه يحجب الشّمس"}]'::jsonb, 'b', 'الجبل ضخمٌ في الحقيقة، لكنّه يبدو صغيرًا لأنّه بعيدٌ عنّا؛ فالبُعد يصغّر الحجم الظاهر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfcda988-b968-52a7-a7be-530a7869764d', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'صندوقٌ كبيرٌ يقف أمام صندوقٍ صغير ويحجبه كلّه. ما الترتيب الصحيح بالقرب؟', '[{"id":"a","text":"الصغير المحجوب هو الأقرب"},{"id":"b","text":"الاثنان على نفس البُعد"},{"id":"c","text":"لا نستطيع أن نعرف"},{"id":"d","text":"الكبير الذي يحجب هو الأقرب"}]'::jsonb, 'd', 'الجسم الذي يحجب غيره يكون أمامه أي الأقرب؛ فالصندوق الكبير الذي يحجب هو الأقرب، والمحجوب أبعد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8444d19d-da5b-5520-9097-793bde377aa9', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'أمامك دلوٌ فيه ماء وشريطٌ لقيس الطّول. أيّ ربطٍ بين الشيء ووحدته صحيح؟', '[{"id":"a","text":"ماء الدلو ← اللتر (L)، والطّول ← المتر (m)"},{"id":"b","text":"ماء الدلو ← المتر (m)، والطّول ← اللتر (L)"},{"id":"c","text":"الاثنان ← المتر (m)"},{"id":"d","text":"الاثنان ← اللتر (L)"}]'::jsonb, 'a', 'الماء سائلٌ يُقاس باللتر (L)، والطّول يُقاس بالمتر (m)؛ فلكلٍّ وحدته الملائمة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84732b4d-051d-5a79-aaa9-2526c562cca0', 'e6071bd2-1059-5414-9ee9-1a74cf4d741f', 'اختر الجملة الصحيحة تمامًا عن الفضاء والقيس.', '[{"id":"a","text":"البعيد يبدو كبيرًا والقريب صغيرًا"},{"id":"b","text":"نقيس السوائل بالمتر"},{"id":"c","text":"المحجوب أقرب من الذي يحجبه"},{"id":"d","text":"القريب يبدو كبيرًا، ونقيس الأطوال بالمتر والسوائل باللتر"}]'::jsonb, 'd', 'الصحيح: القريب يبدو كبيرًا والبعيد صغيرًا، والأطوال تُقاس بالمتر (m) والسوائل باللتر (L). أمّا بقيّة الجمل ففيها خلطٌ بيّن.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f91c7449-1eb3-5e1d-b366-77d73251617e', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('66faee3c-480f-5b3d-ad03-313450712f1e', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'أيّ كلمةٍ نستعملها للحدث الذي وقع أوّلًا؟', '[{"id":"a","text":"قبل"},{"id":"b","text":"بعد"},{"id":"c","text":"أخيرًا"},{"id":"d","text":"غدًا"}]'::jsonb, 'a', 'الحدث الذي وقع أوّلًا نقول إنّه حدث «قبل» غيره؛ والذي يأتي بعده نقول «بعد».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7c8ef01-8d0d-559d-ab8a-1d235f3f6fa1', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'تعاقب الليل والنهار يتكرّر بانتظام كلّ يوم. هذا حدثٌ…', '[{"id":"a","text":"غير دوريّ"},{"id":"b","text":"يحدث مرّةً واحدة"},{"id":"c","text":"دوريّ"},{"id":"d","text":"لا يتكرّر أبدًا"}]'::jsonb, 'c', 'تعاقب الليل والنهار يعود بانتظام كلّ يوم، فهو حدثٌ دوريّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c24e3b47-ac15-5973-ab7f-1ab366f34c1b', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'سيّارتان سارتا نفس الوقت. قطعت الحمراء مسافةً أطول من الزرقاء. أيّهما أسرع؟', '[{"id":"a","text":"الزرقاء لأنّها قطعت مسافةً أقصر"},{"id":"b","text":"الحمراء لأنّها قطعت مسافةً أطول في نفس الوقت"},{"id":"c","text":"هما متساويتان دائمًا"},{"id":"d","text":"لا يمكن أن نعرف"}]'::jsonb, 'b', 'في نفس المدّة، من يقطع مسافةً أطول يكون أسرع؛ فالسيّارة الحمراء هي الأسرع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9ea2ac2-5973-524c-99c4-06771142f51a', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'أيّ هذه الأحداث غير دوريّ (لا يتكرّر بانتظام)؟', '[{"id":"a","text":"عودة الصباح كلّ يوم"},{"id":"b","text":"أيّام الأسبوع السبعة"},{"id":"c","text":"تعاقب الليل والنهار"},{"id":"d","text":"نزول المطر"}]'::jsonb, 'd', 'نزول المطر لا يأتي كلّ يومٍ بانتظام، فهو حدثٌ غير دوريّ؛ أمّا الباقي فيتكرّر بانتظام.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24504a83-60ca-5218-806b-1bc27dc0b183', 'f91c7449-1eb3-5e1d-b366-77d73251617e', 'نرتّب نموّ النبتة: شجرة، بذرة، نبتة صغيرة. ما الترتيب الصحيح من الأوّل إلى الأخير؟', '[{"id":"a","text":"شجرة ثمّ بذرة ثمّ نبتة صغيرة"},{"id":"b","text":"بذرة ثمّ نبتة صغيرة ثمّ شجرة"},{"id":"c","text":"نبتة صغيرة ثمّ بذرة ثمّ شجرة"},{"id":"d","text":"شجرة ثمّ نبتة صغيرة ثمّ بذرة"}]'::jsonb, 'b', 'تبدأ النبتة بذرةً، ثمّ تصير نبتةً صغيرة، وأخيرًا شجرة؛ هذا هو الترتيب الزمني الصحيح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a912242a-7e3d-5ecf-b435-10f9e45a2b25', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', '⭐ تمرين: أوّلًا، أسرع، دوريّ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f0b81e5e-4edd-5807-bb84-c60549789a32', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'في الصباح نستيقظ، وفي الليل ننام. أيّهما يحدث أوّلًا؟', '[{"id":"a","text":"نستيقظ في الصباح"},{"id":"b","text":"ننام في الليل"},{"id":"c","text":"يحدثان في نفس اللحظة"},{"id":"d","text":"لا يحدث أيّ شيء"}]'::jsonb, 'a', 'نستيقظ في الصباح أوّلًا، ثمّ ننام في الليل أخيرًا؛ الصباح يأتي قبل الليل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3fcc05c-7896-563d-b805-580aba5034aa', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'أرنبٌ وسلحفاةٌ تحرّكا نفس الوقت. قطع الأرنب مسافةً أطول. ما حركته؟', '[{"id":"a","text":"حركة أبطأ"},{"id":"b","text":"حركة أسرع"},{"id":"c","text":"لا يتحرّك"},{"id":"d","text":"نائم"}]'::jsonb, 'b', 'في نفس المدّة، الأرنب قطع مسافةً أطول، إذن حركته أسرع من السلحفاة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56a09018-7897-5767-a779-ceda5fbb6a30', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'أيّ حدثٍ يتكرّر بانتظام كلّ يوم؟', '[{"id":"a","text":"نزول الثلج"},{"id":"b","text":"عيد الميلاد"},{"id":"c","text":"تعاقب الليل والنهار"},{"id":"d","text":"كسر قلم"}]'::jsonb, 'c', 'تعاقب الليل والنهار يعود بانتظام كلّ يوم، فهو حدثٌ دوريّ؛ أمّا الباقي فلا يتكرّر بانتظام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bccab64-a551-539e-80f0-cbd11ff989f8', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'أيّ هذه الأحداث غير دوريّ؟', '[{"id":"a","text":"عودة الصباح كلّ يوم"},{"id":"b","text":"تعاقب الليل والنهار"},{"id":"c","text":"أيّام الأسبوع"},{"id":"d","text":"نزول المطر"}]'::jsonb, 'd', 'نزول المطر لا يأتي بانتظام كلّ يوم، فهو غير دوريّ؛ أمّا الباقي فيتكرّر بانتظام.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72fd6e87-502c-53b0-a308-dbf147d75e6c', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'تحرّكت السيّارتان نفس الوقت. أيّ سيّارةٍ أسرع؟<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><line x1="20" y1="40" x2="280" y2="40" stroke="#f59e0b" stroke-width="3"/><line x1="20" y1="100" x2="280" y2="100" stroke="#f59e0b" stroke-width="3"/><line x1="20" y1="28" x2="20" y2="112" stroke="#1f2937" stroke-width="3"/><rect x="230" y="22" width="44" height="18" rx="5" fill="#ef4444"/><path d="M238 22 q6 -10 18 0 z" fill="#ef4444"/><circle cx="240" cy="42" r="5" fill="#1f2937"/><circle cx="264" cy="42" r="5" fill="#1f2937"/><rect x="50" y="82" width="44" height="18" rx="5" fill="#3730a3"/><path d="M58 82 q6 -10 18 0 z" fill="#3730a3"/><circle cx="60" cy="102" r="5" fill="#1f2937"/><circle cx="84" cy="102" r="5" fill="#1f2937"/></g></svg>', '[{"id":"a","text":"الحمراء، لأنّها قطعت مسافةً أطول في نفس الوقت"},{"id":"b","text":"الزرقاء، لأنّها بقيت قريبة"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا توجد سيّارة سريعة"}]'::jsonb, 'a', 'الصورة تُظهر أنّ السيّارة الحمراء وصلت بعيدًا والزرقاء بقيت قريبة في نفس الوقت، فالحمراء أسرع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77ff7fc0-a439-5014-a113-696b14809891', 'a912242a-7e3d-5ecf-b435-10f9e45a2b25', 'نرتّب: أوّلًا، ثمّ، أخيرًا. أيّ كلمةٍ تدلّ على آخر حدث؟', '[{"id":"a","text":"قبل"},{"id":"b","text":"أخيرًا"},{"id":"c","text":"أوّلًا"},{"id":"d","text":"في البداية"}]'::jsonb, 'b', 'كلمة «أخيرًا» تدلّ على الحدث الأخير، أمّا «أوّلًا» فتدلّ على الحدث الأوّل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d8b8c484-410f-5c68-ad4d-85e0853735d4', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الزمن', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ab489d97-bf33-5bf2-8cef-d664dc1c5bb1', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'نرتّب يوم سامي: يأكل الغداء، يستيقظ، ينام. ما الترتيب من الأوّل إلى الأخير؟', '[{"id":"a","text":"ينام ثمّ يأكل الغداء ثمّ يستيقظ"},{"id":"b","text":"يأكل الغداء ثمّ يستيقظ ثمّ ينام"},{"id":"c","text":"يستيقظ ثمّ يأكل الغداء ثمّ ينام"},{"id":"d","text":"ينام ثمّ يستيقظ ثمّ يأكل الغداء"}]'::jsonb, 'c', 'نستيقظ أوّلًا في الصباح، ثمّ نأكل الغداء في الظهر، وأخيرًا ننام في الليل؛ هذا هو الترتيب الزمني.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d524b1f0-1f39-57f0-afc2-1d10cfcaef3f', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'حصانٌ وقطٌّ جريا نفس المدّة. قطع الحصان مسافةً أطول. أيّهما حركته أبطأ؟', '[{"id":"a","text":"الحصان لأنّه أكبر"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"لا يمكن أن نعرف"},{"id":"d","text":"القطّ لأنّه قطع مسافةً أقصر في نفس الوقت"}]'::jsonb, 'd', 'في نفس المدّة، من يقطع مسافةً أقصر يكون أبطأ؛ القطّ قطع مسافةً أقصر فحركته أبطأ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a4b26d7-b9e8-5f97-bc5c-bad2ade7129c', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'الخطأ الشائع: قال طفل «من قطع مسافةً أطول يكون دائمًا أسرع». ما الصحيح؟', '[{"id":"a","text":"صحيح، المسافة وحدها تكفي دائمًا"},{"id":"b","text":"نقارن المسافة فقط إذا كان الوقت نفسه؛ الأبعد في نفس الوقت أسرع"},{"id":"c","text":"الأبعد دائمًا أبطأ"},{"id":"d","text":"الوقت لا يهمّ أبدًا"}]'::jsonb, 'b', 'الخطأ الشائع: مقارنة المسافة دون الوقت. نقارن المسافة في نفس المدّة؛ فإن سار جسمٌ وقتًا أطول قد يقطع مسافةً أطول دون أن يكون أسرع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('562c1ed8-e533-5947-bf17-efd713254271', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'الخطأ الشائع: قال طفل «عيد الميلاد حدثٌ دوريّ مثل الليل والنهار». ما الصحيح؟', '[{"id":"a","text":"عيد الميلاد لا يعود بانتظام كلّ يوم مثل الليل والنهار؛ نعتبره غير دوريّ في حياتنا اليوميّة"},{"id":"b","text":"صحيح، كلّ الأحداث دوريّة"},{"id":"c","text":"الليل والنهار غير دوريّين"},{"id":"d","text":"لا فرق بين الأحداث"}]'::jsonb, 'a', 'الخطأ الشائع: عدّ كلّ حدثٍ متكرّر دوريًّا. الحدث الدوريّ يعود بانتظام قريب مثل الليل والنهار كلّ يوم؛ أمّا عيد الميلاد فلا يأتي بهذا الانتظام اليوميّ، فنعدّه غير دوريّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc3b8ba4-a015-537a-aa6e-2cbb7f3e3947', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'في سباق، وصل العدّاء الأخضر إلى النهاية أوّلًا والعدّاء الأحمر بعده، في نفس الوقت من الانطلاق. من الأسرع؟', '[{"id":"a","text":"الأحمر لأنّه وصل أخيرًا"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"الأخضر لأنّه قطع المسافة في وقتٍ أقلّ"},{"id":"d","text":"لا أحد منهما سريع"}]'::jsonb, 'c', 'من يصل إلى نفس النهاية أوّلًا يكون قد قطع المسافة في وقتٍ أقصر، فهو الأسرع؛ إذن العدّاء الأخضر أسرع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f34aa50a-a578-53e8-af0d-7eae23a089f0', 'd8b8c484-410f-5c68-ad4d-85e0853735d4', 'أيّ صورةٍ تدلّ على حدثٍ دوريّ يتكرّر كلّ يوم؟<svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><rect x="14" y="22" width="80" height="78" rx="8" fill="#fef3c7"/><circle cx="54" cy="61" r="16" fill="#fcd34d"/><line x1="54" y1="35" x2="54" y2="28"/><line x1="54" y1="87" x2="54" y2="94"/><line x1="28" y1="61" x2="21" y2="61"/><line x1="80" y1="61" x2="87" y2="61"/><rect x="206" y="22" width="80" height="78" rx="8" fill="#3730a3"/><path d="M252 40 a19 19 0 1 0 15 34 a15 15 0 0 1 -15 -34 z" fill="#fcd34d"/><circle cx="228" cy="42" r="1.6" fill="#ffffff" stroke="none"/><path d="M104 50 h36" fill="none" stroke="#f59e0b" stroke-width="3"/><path d="M140 50 l-7 -4 l0 8 z" fill="#f59e0b" stroke="none"/><path d="M196 72 h-36" fill="none" stroke="#f59e0b" stroke-width="3"/><path d="M160 72 l7 -4 l0 8 z" fill="#f59e0b" stroke="none"/></g></svg>', '[{"id":"a","text":"لا تدلّ على شيء"},{"id":"b","text":"تعاقب النهار (الشمس) والليل (القمر)، وهو دوريّ"},{"id":"c","text":"نزول المطر مرّةً واحدة"},{"id":"d","text":"كسر قلمٍ فجأة"}]'::jsonb, 'b', 'الصورة تُظهر نهارًا بشمسٍ ثمّ ليلًا بقمر، يتعاقبان بانتظام كلّ يوم؛ وهذا حدثٌ دوريّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7528f239-9cce-594d-be59-8ebbc0267b41', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: الزمن (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('fc898a65-4542-567d-a336-05d0bd7f2ec3', '7528f239-9cce-594d-be59-8ebbc0267b41', 'أيّ كلمةٍ تدلّ على حدثٍ يأتي بعد حدثٍ آخر؟', '[{"id":"a","text":"قبل"},{"id":"b","text":"بعد"},{"id":"c","text":"أوّلًا"},{"id":"d","text":"في البداية"}]'::jsonb, 'b', 'كلمة «بعد» تدلّ على الحدث الذي يأتي تاليًا؛ والصباح قبل الظهر، والمساء بعده.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('575ec66c-04a9-5a3c-b07c-aec21f799739', '7528f239-9cce-594d-be59-8ebbc0267b41', 'دراجتان سارتا نفس الوقت. قطعت الأولى مسافةً قصيرة والثانية مسافةً طويلة. أيّهما أبطأ؟', '[{"id":"a","text":"الأولى، لأنّها قطعت مسافةً أقصر في نفس الوقت"},{"id":"b","text":"الثانية، لأنّها قطعت مسافةً أطول"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا توجد دراجة بطيئة"}]'::jsonb, 'a', 'في نفس المدّة، من يقطع مسافةً أقصر يكون أبطأ؛ فالدراجة الأولى أبطأ والثانية أسرع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18711ef7-9a3f-5a40-9736-ac9b7c20065e', '7528f239-9cce-594d-be59-8ebbc0267b41', 'أيّ مجموعةٍ كلّها أحداثٌ دوريّة (تتكرّر بانتظام)؟', '[{"id":"a","text":"نزول المطر، عيد الميلاد، كسر قلم"},{"id":"b","text":"زيارة الجدّة، الثلج، حادث"},{"id":"c","text":"نزول المطر، الليل والنهار، عيد الميلاد"},{"id":"d","text":"تعاقب الليل والنهار، أيّام الأسبوع، عودة الصباح"}]'::jsonb, 'd', 'تعاقب الليل والنهار وأيّام الأسبوع وعودة الصباح كلّها تتكرّر بانتظام، فهي دوريّة؛ أمّا المطر والعيد والحوادث فغير دوريّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('459ecd0a-2c00-54b1-90fa-094fe0353e7d', '7528f239-9cce-594d-be59-8ebbc0267b41', 'نرتّب مراحل قصّةٍ: البطل ينتصر، البطل يبدأ الرحلة، البطل يلتقي العدوّ. ما الترتيب الصحيح؟', '[{"id":"a","text":"البطل ينتصر ثمّ يبدأ الرحلة ثمّ يلتقي العدوّ"},{"id":"b","text":"البطل يلتقي العدوّ ثمّ ينتصر ثمّ يبدأ الرحلة"},{"id":"c","text":"البطل يبدأ الرحلة ثمّ يلتقي العدوّ ثمّ ينتصر"},{"id":"d","text":"البطل ينتصر ثمّ يلتقي العدوّ ثمّ يبدأ الرحلة"}]'::jsonb, 'c', 'أوّلًا يبدأ البطل الرحلة، ثمّ يلتقي العدوّ، وأخيرًا ينتصر؛ هذا هو الترتيب الزمني للأحداث.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb8e37ad-c672-5f41-9d69-25495c80ee0b', '7528f239-9cce-594d-be59-8ebbc0267b41', 'عصفورٌ وفراشةٌ طارا نفس المدّة. وصل العصفور إلى الشجرة البعيدة والفراشة بقيت قريبة. ما حركة العصفور؟', '[{"id":"a","text":"حركة أسرع، لأنّه قطع مسافةً أطول في نفس الوقت"},{"id":"b","text":"حركة أبطأ"},{"id":"c","text":"لا يتحرّك"},{"id":"d","text":"مثل الفراشة تمامًا"}]'::jsonb, 'a', 'في نفس المدّة، العصفور قطع مسافةً أطول من الفراشة، فحركته أسرع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d748656-87fd-5431-9f53-2b2f46c83a8d', '7528f239-9cce-594d-be59-8ebbc0267b41', 'حدثٌ يأتي مرّةً ولا نعرف متى يعود بالضبط. كيف نصنّفه؟', '[{"id":"a","text":"دوريّ لأنّه قد يتكرّر"},{"id":"b","text":"دوريّ مثل الليل والنهار"},{"id":"c","text":"ليس حدثًا"},{"id":"d","text":"غير دوريّ لأنّه لا يتكرّر بانتظام"}]'::jsonb, 'd', 'الحدث الذي لا يعود بانتظام نصنّفه غير دوريّ؛ عكس الليل والنهار الذي يتكرّر بانتظام كلّ يوم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f6fc13f2-4623-5470-88e2-8598416f1e25', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: حارس الزمن', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c0e0329c-1704-56bd-be4f-7adf1f3b8c8c', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'نرتّب فصول السنة كما تتعاقب: الصيف، الربيع، الشتاء، الخريف. أيّ فصلٍ يأتي قبل الصيف مباشرةً؟', '[{"id":"a","text":"الربيع"},{"id":"b","text":"الشتاء"},{"id":"c","text":"الخريف"},{"id":"d","text":"لا يأتي قبله شيء"}]'::jsonb, 'a', 'تتعاقب الفصول: الربيع ثمّ الصيف ثمّ الخريف ثمّ الشتاء؛ فالربيع يأتي قبل الصيف مباشرةً.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08f8dcbc-ade2-5c7e-96db-972751634399', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'ثلاثة أطفالٍ ركضوا نفس المدّة: قطع سامي 8 أمتار، وليلى 5 أمتار، وأمين 3 أمتار. من الأسرع؟', '[{"id":"a","text":"أمين لأنّه قطع 3 أمتار"},{"id":"b","text":"سامي لأنّه قطع أطول مسافة (8 أمتار) في نفس الوقت"},{"id":"c","text":"ليلى لأنّها في الوسط"},{"id":"d","text":"هم متساوون"}]'::jsonb, 'b', 'في نفس المدّة، من يقطع أطول مسافة يكون الأسرع؛ سامي قطع 8 أمتار، وهي الأطول، فهو الأسرع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91a9bb65-3c2c-5104-b073-298491678a25', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'الخطأ الشائع: قال طفل «السلحفاة قطعت 2 متر في ساعة، والنملة قطعت 1 متر في دقيقة، فالسلحفاة أسرع لأنّ مسافتها أطول». ما الصحيح؟', '[{"id":"a","text":"صحيح، المسافة الأطول تعني أسرع دائمًا"},{"id":"b","text":"الوقت مختلف (ساعة مقابل دقيقة)، فلا نقارن بالمسافة وحدها؛ نقارن فقط في نفس المدّة"},{"id":"c","text":"النملة لا تتحرّك أبدًا"},{"id":"d","text":"السلحفاة لا تتحرّك أبدًا"}]'::jsonb, 'b', 'الخطأ الشائع: مقارنة المسافة دون الوقت. هنا الوقت مختلف (ساعة مقابل دقيقة)، فلا يصحّ الحكم بالمسافة وحدها؛ نقارن السرعة في نفس المدّة فقط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1991fb16-e5f8-5cb8-8a0d-8152178c97f0', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'الخطأ الشائع: قال طفل «كلّ حدثٍ نعرف موعده هو دوريّ». ما الصحيح؟', '[{"id":"a","text":"صحيح، معرفة الموعد تكفي"},{"id":"b","text":"كلّ الأحداث دوريّة"},{"id":"c","text":"كلّ الأحداث غير دوريّة"},{"id":"d","text":"الدوريّ يتكرّر بانتظام (كالليل والنهار)؛ معرفة موعدٍ لمرّةٍ واحدة لا تجعله دوريًّا"}]'::jsonb, 'd', 'الخطأ الشائع: الخلط بين معرفة الموعد والدوريّة. الحدث الدوريّ يتكرّر بانتظام مثل الليل والنهار؛ أمّا حدثٌ يقع مرّةً ولو عرفنا موعده فليس دوريًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e509388a-ea68-5363-875f-afa35141e5ee', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'سار العدّاءان نفس المدّة من خطّ الانطلاق. انظر إلى مكان كلٍّ منهما الآن. من حركته أسرع؟<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><line x1="20" y1="40" x2="280" y2="40" stroke="#f59e0b" stroke-width="3"/><line x1="20" y1="100" x2="280" y2="100" stroke="#f59e0b" stroke-width="3"/><line x1="20" y1="28" x2="20" y2="112" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="24" r="7" fill="#a16207"/><line x1="60" y1="31" x2="60" y2="40" stroke="#a16207" stroke-width="3"/><line x1="60" y1="34" x2="52" y2="30" stroke="#a16207"/><line x1="60" y1="34" x2="68" y2="30" stroke="#a16207"/><circle cx="250" cy="84" r="7" fill="#22c55e"/><line x1="250" y1="91" x2="250" y2="100" stroke="#15803d" stroke-width="3"/><line x1="250" y1="94" x2="242" y2="90" stroke="#15803d"/><line x1="250" y1="94" x2="258" y2="90" stroke="#15803d"/></g></svg>', '[{"id":"a","text":"البنّيّ، لأنّه قريبٌ من الانطلاق"},{"id":"b","text":"هما متساويان في السرعة"},{"id":"c","text":"الأخضر، لأنّه قطع مسافةً أطول في نفس الوقت"},{"id":"d","text":"لا أحد منهما يتحرّك"}]'::jsonb, 'c', 'الصورة تُظهر أنّ العدّاء الأخضر ابتعد كثيرًا والبنّيّ بقي قرب الانطلاق في نفس المدّة، فالأخضر قطع مسافةً أطول، وحركته أسرع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74d03538-ff33-5658-9d19-d6b6aaa06fa6', 'f6fc13f2-4623-5470-88e2-8598416f1e25', 'نريد تصنيف هذه الأحداث في خانتَي «دوريّ» و«غير دوريّ»: تعاقب الليل والنهار، نزول المطر، أيّام الأسبوع، عيد الميلاد. كم حدثًا دوريًّا؟', '[{"id":"a","text":"ثلاثة (3)"},{"id":"b","text":"لا يوجد حدثٌ دوريّ"},{"id":"c","text":"اثنان (2): تعاقب الليل والنهار وأيّام الأسبوع"},{"id":"d","text":"أربعة (4)، كلّها دوريّة"}]'::jsonb, 'c', 'الدوريّ يتكرّر بانتظام: تعاقب الليل والنهار وأيّام الأسبوع، أي اثنان (2)؛ أمّا نزول المطر وعيد الميلاد فغير دوريّين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('489faaa3-f542-5fd9-a74a-c6c910f090e6', '9b2889f8-906e-5629-b28d-da2c10b832fa', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: الترتيب والسرعة والدوريّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('87472389-8add-5f27-9edb-6f79db5a0285', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'في طبخ كعكة: نأكلها، نخلط المكوّنات، نضعها في الفرن. ما الترتيب الصحيح؟', '[{"id":"a","text":"نأكلها ثمّ نخلط المكوّنات ثمّ نضعها في الفرن"},{"id":"b","text":"نضعها في الفرن ثمّ نخلط المكوّنات ثمّ نأكلها"},{"id":"c","text":"نأكلها ثمّ نضعها في الفرن ثمّ نخلط المكوّنات"},{"id":"d","text":"نخلط المكوّنات ثمّ نضعها في الفرن ثمّ نأكلها"}]'::jsonb, 'd', 'أوّلًا نخلط المكوّنات، ثمّ نضع الكعكة في الفرن، وأخيرًا نأكلها؛ هذا هو الترتيب الزمني الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b24843a0-4d87-57ba-8db9-a8632abd4bda', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'قاربان أبحرا نفس المدّة. قطع الأوّل مسافةً طويلة والثاني مسافةً قصيرة. أيّهما حركته أسرع؟', '[{"id":"a","text":"الثاني، لأنّه قطع مسافةً أقصر"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"الأوّل، لأنّه قطع مسافةً أطول في نفس الوقت"},{"id":"d","text":"لا يوجد قاربٌ سريع"}]'::jsonb, 'c', 'في نفس المدّة، من يقطع مسافةً أطول يكون أسرع؛ فالقارب الأوّل حركته أسرع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bea120a0-87f0-59e1-9a73-add85990bf7d', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'أيّ حدثٍ من هذه دوريّ يتكرّر بانتظام؟', '[{"id":"a","text":"عودة يوم الجمعة كلّ أسبوع"},{"id":"b","text":"سقوط ورقةٍ من شجرة"},{"id":"c","text":"زيارة طبيب الأسنان مرّةً"},{"id":"d","text":"كسر كأس"}]'::jsonb, 'a', 'عودة يوم الجمعة كلّ أسبوع تتكرّر بانتظام، فهي حدثٌ دوريّ؛ أمّا الباقي فلا يتكرّر بانتظام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e05aa30-ae66-57b8-abd8-829a04c834aa', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'مشى أحمد إلى المدرسة وعاد، ومشى كريم نفس المدّة لكنّه قطع مسافةً أقصر. ماذا نقول عن حركة كريم؟', '[{"id":"a","text":"أسرع من أحمد"},{"id":"b","text":"أبطأ من أحمد، لأنّه قطع مسافةً أقصر في نفس الوقت"},{"id":"c","text":"لا يتحرّك أبدًا"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'b', 'في نفس المدّة، من يقطع مسافةً أقصر يكون أبطأ؛ كريم قطع مسافةً أقصر فحركته أبطأ من أحمد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f80682c-70b6-5f79-aeb5-7748614da7fb', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'ما الفرق بين الحدث الدوريّ والحدث غير الدوريّ؟', '[{"id":"a","text":"الدوريّ كبير وغير الدوريّ صغير"},{"id":"b","text":"لا فرق بينهما"},{"id":"c","text":"الدوريّ يحدث في الليل وغير الدوريّ في النهار"},{"id":"d","text":"الدوريّ يتكرّر بانتظام، وغير الدوريّ لا يتكرّر بانتظام"}]'::jsonb, 'd', 'الحدث الدوريّ يتكرّر بانتظام مثل الليل والنهار؛ وغير الدوريّ لا يعود بانتظام مثل نزول المطر. الفرق في الانتظام لا في الحجم أو الوقت.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b922afd6-082e-5614-ac01-c40279ec3b0c', '489faaa3-f542-5fd9-a74a-c6c910f090e6', 'نرتّب أعمار الإنسان: شيخ، رضيع، شابّ، طفل. ما الترتيب من الأصغر إلى الأكبر؟', '[{"id":"a","text":"رضيع ثمّ طفل ثمّ شابّ ثمّ شيخ"},{"id":"b","text":"شيخ ثمّ شابّ ثمّ طفل ثمّ رضيع"},{"id":"c","text":"طفل ثمّ رضيع ثمّ شابّ ثمّ شيخ"},{"id":"d","text":"شابّ ثمّ رضيع ثمّ طفل ثمّ شيخ"}]'::jsonb, 'a', 'يكبر الإنسان بالترتيب: رضيع أوّلًا، ثمّ طفل، ثمّ شابّ، وأخيرًا شيخ؛ هذا هو التسلسل الزمني للأعمار.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7193e238-1765-5207-9f78-fde4538a639b', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a474b912-03f4-589c-b807-1ea8259978c3', '7193e238-1765-5207-9f78-fde4538a639b', 'الجسم الصلب، ماذا يحدث لشكله؟', '[{"id":"a","text":"له شكلٌ خاصّ به لا يتغيّر"},{"id":"b","text":"يأخذ شكل الإناء"},{"id":"c","text":"يجري ويسيل دائمًا"},{"id":"d","text":"ليس له شكل أبدًا"}]'::jsonb, 'a', 'الجسم الصلب مثل الحجر والمفتاح له شكلٌ خاصّ به لا يتغيّر مهما وضعناه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29b154b4-51fd-54ea-9034-6840755142c6', '7193e238-1765-5207-9f78-fde4538a639b', 'الماء سائل. ماذا يأخذ من الشكل؟', '[{"id":"a","text":"شكلًا خاصًّا به لا يتغيّر"},{"id":"b","text":"شكل الإناء الذي يحويه"},{"id":"c","text":"شكل المفتاح دائمًا"},{"id":"d","text":"شكل الحجر"}]'::jsonb, 'b', 'الماء سائلٌ لا شكل خاصّ له، فيأخذ شكل الكوب أو الصحن الذي يحويه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a19f9f04-6b38-5e33-a068-e55ae61ad037', '7193e238-1765-5207-9f78-fde4538a639b', 'أيّهما أصلب: الحجر أم الإسفنج؟', '[{"id":"a","text":"الإسفنج أصلب"},{"id":"b","text":"هما متساويان في الصلابة"},{"id":"c","text":"الحجر أصلب"},{"id":"d","text":"كلاهما ليّن"}]'::jsonb, 'c', 'الحجر قاسٍ لا ينضغط، أمّا الإسفنج فطريٌّ ينضغط بسهولة، فالحجر أصلب من الإسفنج.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de1eaf37-3d93-54c7-8e63-d4456ea44b7e', '7193e238-1765-5207-9f78-fde4538a639b', 'الهواء من أيّ حالات المادّة؟', '[{"id":"a","text":"صلب"},{"id":"b","text":"سائل"},{"id":"c","text":"حجر"},{"id":"d","text":"غازي"}]'::jsonb, 'd', 'الهواء جسمٌ غازي، يأخذ شكل الإناء وينتشر فيه ليملأه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d369fc63-c92a-5242-96de-82f6e66ed22b', '7193e238-1765-5207-9f78-fde4538a639b', 'أيّ جسمٍ من هذه ليّنٌ ينضغط بسهولة تحت الإصبع؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الإسفنج"},{"id":"c","text":"المفتاح"},{"id":"d","text":"الخشب"}]'::jsonb, 'b', 'الإسفنج جسمٌ ليّنٌ طريٌّ ينضغط بسهولة، أمّا الحجر والمفتاح والخشب فأجسامٌ صلبة قاسية.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('88a2ba0d-4c17-5370-99cd-25453130e38d', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', '⭐ تمرين: صلب أم سائل أم غازي؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('123dbdc5-ef70-5b16-88e5-e7f807da07f6', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'الحجر له شكلٌ واحدٌ لا يتغيّر. من أيّ حالات المادّة هو؟', '[{"id":"a","text":"صلب"},{"id":"b","text":"سائل"},{"id":"c","text":"غازي"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'a', 'الحجر له شكلٌ خاصّ به لا يتغيّر، وهذه علامةُ الجسم الصلب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bdfc822-c2e9-5995-a3b3-82004304b8e6', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'الحليب نسكبه في كوبٍ فيأخذ شكله. من أيّ حالات المادّة هو؟', '[{"id":"a","text":"صلب"},{"id":"b","text":"سائل"},{"id":"c","text":"حجر صلب"},{"id":"d","text":"له شكلٌ ثابت"}]'::jsonb, 'b', 'الحليب يجري ويأخذ شكل الكوب الذي يحويه، وهذه علامةُ الجسم السائل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a8339db-0aa0-5eb5-890d-ee0562728a81', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'ننفخ الهواء في بالونٍ فيملأه ويأخذ شكله. من أيّ حالات المادّة هو الهواء؟', '[{"id":"a","text":"صلب له شكل ثابت"},{"id":"b","text":"سائل فقط"},{"id":"c","text":"غازي"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'c', 'الهواء جسمٌ غازي، يأخذ شكل الإناء وينتشر فيه ليملأه كلّه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('289198e5-0cf2-5e54-8082-a54e89462f3a', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'أيّ جسمٍ من هذه أصلب؟', '[{"id":"a","text":"الإسفنج"},{"id":"b","text":"العجين"},{"id":"c","text":"القطن"},{"id":"d","text":"الحجر"}]'::jsonb, 'd', 'الحجر قاسٍ لا ينضغط، فهو أصلب من الإسفنج والعجين والقطن التي تنضغط بسهولة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd3eeecb-52c8-5c15-a12a-7d1c817e2d0e', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'هذا الجسم يحفظ شكله نفسه على الطاولة وفي اليد. من أيّ حالات المادّة هو؟<svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M28 70 l10 -38 l28 -10 l26 14 l-8 34 z" fill="#64748b"/><path d="M38 32 l28 -10 l26 14" fill="none"/><circle cx="52" cy="50" r="3" fill="#475569" stroke="none"/><circle cx="74" cy="56" r="3" fill="#475569" stroke="none"/></g></svg>', '[{"id":"a","text":"صلب (حجر) له شكلٌ خاصّ ثابت"},{"id":"b","text":"سائل يأخذ شكل الإناء"},{"id":"c","text":"غازي ينتشر في الهواء"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'a', 'الصورة تُظهر حجرًا بزواياه الثابتة؛ والحجر جسمٌ صلب له شكلٌ خاصّ به لا يتغيّر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c442412-454c-5365-9a3c-2eef77a683a2', '88a2ba0d-4c17-5370-99cd-25453130e38d', 'أكمل: الجسم السائل لا شكل خاصّ له، بل يأخذ شكل …', '[{"id":"a","text":"الحجر"},{"id":"b","text":"المفتاح"},{"id":"c","text":"الإناء الذي يحويه"},{"id":"d","text":"نفسه دائمًا"}]'::jsonb, 'c', 'الجسم السائل مثل الماء يأخذ شكل الإناء الذي يحويه، كالكوب أو الصحن.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f563d6f7-d1a3-59ec-a397-2a8160bf39fe', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد المادّة وحالاتها', 3, 120, 30, 'boss', 'admin', 2)
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
  ('33362f40-ce71-5723-8cf4-25f9443c52ac', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'جسمٌ نضعه في كوبٍ فيأخذ شكل الكوب، ونسكبه في صحنٍ فيأخذ شكل الصحن. ما حالته؟', '[{"id":"a","text":"سائل"},{"id":"b","text":"صلب"},{"id":"c","text":"له شكلٌ خاصّ ثابت"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'a', 'أخذُ شكل الإناء (الكوب ثمّ الصحن) علامةُ الجسم السائل، فهو لا شكل خاصّ له.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('954691c1-e42a-51c9-a7db-3762054bfbe9', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'رتّب من الأصلب إلى الأليَن. ما الترتيب الصحيح؟', '[{"id":"a","text":"الإسفنج، الخشب، الحجر"},{"id":"b","text":"الحجر، الخشب، الإسفنج"},{"id":"c","text":"الخشب، الحجر، الإسفنج"},{"id":"d","text":"الإسفنج، الحجر، الخشب"}]'::jsonb, 'b', 'الحجر أصلب من الخشب، والخشب أصلب من الإسفنج، فالترتيب من الأصلب إلى الأليَن: الحجر ثمّ الخشب ثمّ الإسفنج.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('312adbc5-adcf-56c5-bb33-64365ad5210a', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'قال طفل: «الماء له شكلٌ خاصّ به مثل الحجر». ما الصحيح؟', '[{"id":"a","text":"صحيح، كلّ جسمٍ له شكلٌ ثابت"},{"id":"b","text":"الماء صلب"},{"id":"c","text":"الخطأ الشائع: الماء سائلٌ لا شكل خاصّ له، يأخذ شكل الإناء"},{"id":"d","text":"الحجر يأخذ شكل الإناء"}]'::jsonb, 'c', 'الخطأ الشائع: ظنّ أنّ للماء شكلًا خاصًّا. الماء سائلٌ يأخذ شكل الإناء؛ الذي يحفظ شكله هو الجسم الصلب كالحجر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba03e2b2-7968-5c8b-839f-9823f6334ff6', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'لماذا نقول إنّ المفتاح جسمٌ صلب؟', '[{"id":"a","text":"لأنّه يأخذ شكل الجيب"},{"id":"b","text":"لأنّه يجري ويسيل"},{"id":"c","text":"لأنّ لونه لامع فقط"},{"id":"d","text":"لأنّ له شكلًا خاصًّا به لا يتغيّر"}]'::jsonb, 'd', 'المفتاح جسمٌ صلب لأنّ له شكلًا خاصًّا به يبقى ثابتًا في اليد والجيب وعلى الطاولة، لا لأنّ لونه لامع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f92f25-7750-5b3e-8142-92faee8ba1c9', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'ما الذي يميّز الجسم الغازي مثل الهواء عن الجسم السائل؟', '[{"id":"a","text":"الغازي له شكلٌ ثابت لا يتغيّر"},{"id":"b","text":"الغازي يأخذ شكل الإناء وينتشر فيه ليملأه كلّه"},{"id":"c","text":"الغازي قاسٍ لا ينضغط"},{"id":"d","text":"الغازي لا يوجد في الإناء"}]'::jsonb, 'b', 'الجسم الغازي كالهواء يأخذ شكل الإناء مثل السائل، لكنّه يزيد بأن ينتشر فيه ليملأه كلّه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ee6126d-6094-55ed-9ff7-6e911928d3a4', 'f563d6f7-d1a3-59ec-a397-2a8160bf39fe', 'نفس السائل الأزرق في إناءين مختلفين. ماذا نستنتج؟<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M30 24 l40 0 l-4 60 l-32 0 z" fill="none"/><path d="M34 48 l32 0 l-3 36 l-26 0 z" fill="#3b82f6"/><path d="M120 38 q40 0 60 0 q-6 38 -30 38 q-24 0 -30 -38 z" fill="none"/><path d="M128 54 q32 6 44 0 q-6 22 -22 22 q-16 0 -22 -22 z" fill="#3b82f6"/></g></svg>', '[{"id":"a","text":"السائل له شكلٌ خاصّ به لا يتغيّر"},{"id":"b","text":"السائل صلبٌ يحفظ شكله"},{"id":"c","text":"السائل يأخذ شكل كلّ إناءٍ يحويه"},{"id":"d","text":"السائل اختفى من الإناء الثاني"}]'::jsonb, 'c', 'الصورة تُظهر نفس السائل الأزرق بشكلين مختلفين حسب الإناء؛ وهذا يثبت أنّ السائل يأخذ شكل كلّ إناءٍ يحويه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('61cc18f0-9186-52c7-a49a-fb01eb0901b2', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: المادّة وحالاتها (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('06d8a32c-e828-5f2c-b46a-026559aef4c0', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'الخشب جسمٌ له شكلٌ خاصّ به لا يتغيّر. ما حالته؟', '[{"id":"a","text":"صلب"},{"id":"b","text":"سائل"},{"id":"c","text":"غازي"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'a', 'الخشب له شكلٌ خاصّ به لا يتغيّر، وهذه علامةُ الجسم الصلب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ca77c5d-c728-53c7-809f-42a4427d6feb', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'أيّ مجموعةٍ كلّها أجسامٌ صلبة؟', '[{"id":"a","text":"الماء، الحليب، الزيت"},{"id":"b","text":"الحجر، الخشب, المفتاح"},{"id":"c","text":"الهواء، الماء, الزيت"},{"id":"d","text":"الإسفنج فقط دون غيره"}]'::jsonb, 'b', 'الحجر والخشب والمفتاح أجسامٌ صلبة لها شكلٌ خاصّ ثابت. أمّا الماء والحليب والزيت فسوائل، والهواء غاز.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ae38c65-f573-5ad6-bf05-87c8c17878ea', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'أيّ زوجٍ صحيح: جسم ← حالته؟', '[{"id":"a","text":"الحجر ← سائل"},{"id":"b","text":"الهواء ← صلب"},{"id":"c","text":"الزيت ← سائل"},{"id":"d","text":"الماء ← صلب"}]'::jsonb, 'c', 'الزيت يجري ويأخذ شكل الإناء، فهو جسمٌ سائل. أمّا الحجر فصلب والهواء غاز والماء سائل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2f6278d-52a4-5c65-bfbb-f654336d3ecc', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'العجين طريٌّ ينضغط بسهولة تحت الإصبع. كيف نصفه من حيث الصلابة؟', '[{"id":"a","text":"أصلب من الحجر"},{"id":"b","text":"أصلب من المفتاح"},{"id":"c","text":"قاسٍ لا ينضغط"},{"id":"d","text":"ليّنٌ أقلّ صلابة من الحجر"}]'::jsonb, 'd', 'العجين ينضغط بسهولة، فهو جسمٌ ليّنٌ أقلّ صلابة من الحجر والمفتاح القاسيين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c7edf82-7e2e-56e1-94a1-12426b3b9f84', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'نسكب نفس الماء من كوبٍ إلى قارورة. ماذا يحدث لشكله؟', '[{"id":"a","text":"يأخذ شكل القارورة"},{"id":"b","text":"يبقى على شكل الكوب"},{"id":"c","text":"يصير صلبًا له شكلٌ ثابت"},{"id":"d","text":"يختفي تمامًا"}]'::jsonb, 'a', 'الماء سائلٌ لا شكل خاصّ له، فإذا انتقل إلى القارورة أخذ شكل القارورة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2377cbd5-bff7-5235-9390-3704e6dd1fc6', '61cc18f0-9186-52c7-a49a-fb01eb0901b2', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"الماء صلبٌ له شكلٌ ثابت"},{"id":"b","text":"الحجر سائلٌ يأخذ شكل الإناء"},{"id":"c","text":"كلّ الأجسام لها نفس الصلابة"},{"id":"d","text":"الصلب يحفظ شكله، والسائل يأخذ شكل الإناء"}]'::jsonb, 'd', 'القاعدة الصحيحة: الجسم الصلب يحفظ شكله الخاصّ، أمّا السائل فيأخذ شكل الإناء الذي يحويه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريّ الصلابة والحالات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('99a1a2e0-d2bd-50bd-beb1-d9d7c92f4bba', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'نريد ترتيب الأجسام في خانتين: «يحفظ شكله» و«يأخذ شكل الإناء». أين نضع الحجر؟', '[{"id":"a","text":"في خانة «يحفظ شكله»"},{"id":"b","text":"في خانة «يأخذ شكل الإناء»"},{"id":"c","text":"لا يوضع في أيّ خانة"},{"id":"d","text":"في خانة الغازات فقط"}]'::jsonb, 'a', 'الحجر جسمٌ صلب له شكلٌ خاصّ به لا يتغيّر، فيوضع في خانة «يحفظ شكله».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8012e9c-6012-59d6-a560-1cd44b17e237', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'في إناءٍ واحد: ماء وزيتٌ وهواء فوقهما. كم جسمًا يأخذ شكل الإناء؟', '[{"id":"a","text":"جسمٌ واحد فقط"},{"id":"b","text":"ثلاثة (3): الماء والزيت والهواء"},{"id":"c","text":"لا شيء يأخذ شكل الإناء"},{"id":"d","text":"الهواء وحده"}]'::jsonb, 'b', 'الماء والزيت سائلان والهواء غاز، وكلّها تأخذ شكل الإناء، فعددها ثلاثة (3). الصلب وحده يحفظ شكله.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1133193-cb38-56cc-9e70-7774ccd026d7', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'قال طفل: «الجسم الأكبر حجمًا هو دائمًا الأصلب». ما الصحيح؟', '[{"id":"a","text":"صحيح، الحجم يحدّد الصلابة"},{"id":"b","text":"كلّ جسمٍ كبيرٍ ليّن"},{"id":"c","text":"الخطأ الشائع: إسفنجةٌ كبيرة تبقى أليَن من حصاةٍ صغيرة؛ الصلابة لا الحجم"},{"id":"d","text":"الأجسام الكبيرة سوائل دائمًا"}]'::jsonb, 'c', 'الخطأ الشائع: ربط الصلابة بالحجم. الإسفنجة الكبيرة تنضغط بسهولة فهي أليَن من حصاةٍ صغيرة قاسية؛ المعيار هو الصلابة لا الحجم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9aa73b5-135c-52ec-a127-109803918386', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'قال طفل: «الزيت له شكلٌ خاصّ به لأنّه أثقل من الماء». ما الصحيح؟', '[{"id":"a","text":"صحيح، الزيت صلب"},{"id":"b","text":"الزيت يحفظ شكله مثل الحجر"},{"id":"c","text":"كلّ سائلٍ ثقيلٍ يصير صلبًا"},{"id":"d","text":"الخطأ الشائع: الزيت سائلٌ يأخذ شكل الإناء مهما كان ثقله"}]'::jsonb, 'd', 'الخطأ الشائع: ربط الحالة بالثقل. الزيت سائلٌ يأخذ شكل الإناء الذي يحويه، والثقل لا يجعله صلبًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c073a421-6402-55f6-a9c9-44a36b6c3d7e', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'نضغط هذا الجسم بالإصبع فينضغط بسهولة ثمّ يرجع. كيف نصفه من حيث الصلابة؟<svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><path d="M30 70 l0 -22 q35 -16 70 0 l0 22 z" fill="#fcd34d"/><path d="M30 48 q35 -16 70 0" fill="none"/><circle cx="48" cy="60" r="3" fill="#f59e0b" stroke="none"/><circle cx="66" cy="64" r="3" fill="#f59e0b" stroke="none"/><circle cx="82" cy="58" r="3" fill="#f59e0b" stroke="none"/><path d="M65 30 l-5 12 l10 0 z" fill="#94a3b8"/></g></svg>', '[{"id":"a","text":"قاسٍ أصلب من الحجر"},{"id":"b","text":"صلبٌ له شكلٌ ثابت لا ينضغط"},{"id":"c","text":"غازٌ ينتشر في الهواء"},{"id":"d","text":"ليّنٌ (إسفنج) ينضغط بسهولة أقلّ صلابة من الحجر"}]'::jsonb, 'd', 'الصورة تُظهر إسفنجةً يضغطها إصبع؛ والإسفنج جسمٌ ليّنٌ ينضغط بسهولة، فهو أقلّ صلابة من الحجر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b63ffb16-7255-5860-90d9-3654fed26497', '2b317ec2-31b9-57fa-9a8a-3fae4451c6e3', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"الهواء صلبٌ يحفظ شكله"},{"id":"b","text":"الحجر أصلب من الخشب، والماء يأخذ شكل الإناء"},{"id":"c","text":"الإسفنج أصلب من الحجر"},{"id":"d","text":"كلّ الأجسام تأخذ شكل الإناء"}]'::jsonb, 'b', 'الحجر فعلًا أصلب من الخشب، والماء سائلٌ يأخذ شكل الإناء. أمّا بقيّة الجمل ففيها خلطٌ في الصلابة أو الحالة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a60714d3-e65e-5bb1-be8a-57b91fe04399', '3a2ca4bc-5a90-5979-b2b6-7b03b84bc3db', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمادّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('3f63cfd7-0ca6-5247-9d39-2d0255ea9c07', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'أكمل: الجسم الذي له شكلٌ خاصّ به لا يتغيّر يُسمّى جسمًا …', '[{"id":"a","text":"صلبًا"},{"id":"b","text":"سائلًا"},{"id":"c","text":"غازيًّا"},{"id":"d","text":"ليّنًا يجري"}]'::jsonb, 'a', 'الجسم الذي يحفظ شكله الخاصّ ولا يتغيّر يُسمّى جسمًا صلبًا، مثل الحجر والمفتاح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae8c9d65-324a-5663-b4e8-d3cb4ba2e6ed', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'أيّ جسمٍ من هذه يأخذ شكل الإناء الذي يحويه؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الماء"},{"id":"c","text":"المفتاح"},{"id":"d","text":"الخشب"}]'::jsonb, 'b', 'الماء جسمٌ سائل لا شكل خاصّ له، فيأخذ شكل الإناء الذي يحويه. أمّا الحجر والمفتاح والخشب فصلبة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3932e53-38a3-5799-9f96-2b7216a5f674', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'الإسفنج أليَن من الخشب. ماذا يعني ذلك؟', '[{"id":"a","text":"الإسفنج أصلب من الخشب"},{"id":"b","text":"هما متساويان في الصلابة"},{"id":"c","text":"الإسفنج أقلّ صلابة وينضغط أسهل من الخشب"},{"id":"d","text":"الخشب يأخذ شكل الإناء"}]'::jsonb, 'c', '«أليَن» تعني أقلّ صلابة، فالإسفنج ينضغط بسهولة أكثر من الخشب الأصلب منه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcdd5215-44df-5521-85c6-3ba5d3754e76', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'ما الفرق بين الجسم الصلب والجسم السائل؟', '[{"id":"a","text":"لا فرق بينهما"},{"id":"b","text":"اللون فقط"},{"id":"c","text":"الحجم فقط"},{"id":"d","text":"الصلب يحفظ شكله، والسائل يأخذ شكل الإناء"}]'::jsonb, 'd', 'الفرق الأساسي في الشكل: الجسم الصلب له شكلٌ خاصّ ثابت، أمّا السائل فيأخذ شكل الإناء الذي يحويه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b04f474-6726-5400-b0cb-3da76b853295', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'صنّف: «الحجر، الماء، الهواء». ما الصحيح؟', '[{"id":"a","text":"كلّها صلبة"},{"id":"b","text":"كلّها سائلة"},{"id":"c","text":"الحجر صلب، والماء سائل، والهواء غازي"},{"id":"d","text":"الماء صلب، والحجر غازي"}]'::jsonb, 'c', 'الحجر له شكلٌ ثابت (صلب)، والماء يأخذ شكل الإناء (سائل)، والهواء يملأ الإناء وينتشر (غازي).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e9cc57a-04da-578b-a338-0c53bfde8359', 'a60714d3-e65e-5bb1-be8a-57b91fe04399', 'هذا الجسم نملأ به الإناء فينتشر فيه ويأخذ شكله، ولا نمسكه بأيدينا. ما حالته؟<svg viewBox="0 0 130 110" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2"><ellipse cx="66" cy="46" rx="32" ry="38" fill="#86efac"/><path d="M60 84 l6 8 l6 -8 z" fill="#86efac"/><path d="M66 92 q-7 7 0 11" fill="none"/><circle cx="54" cy="36" r="4" fill="#bbf7d0" stroke="none"/><circle cx="78" cy="50" r="3" fill="#bbf7d0" stroke="none"/></g></svg>', '[{"id":"a","text":"غازي (هواء) يأخذ شكل الإناء وينتشر فيه"},{"id":"b","text":"صلب له شكلٌ خاصّ ثابت"},{"id":"c","text":"حجرٌ قاسٍ لا ينضغط"},{"id":"d","text":"ليس مادّة"}]'::jsonb, 'a', 'الصورة تُظهر بالونًا ملأه الهواء؛ والهواء جسمٌ غازي يأخذ شكل الإناء وينتشر فيه ليملأه، ولا نمسكه بأيدينا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9290404d-5200-5b58-be94-2847d8921f79', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cb8e1ae8-dfde-59de-b65f-0f191f1813ad', '9290404d-5200-5b58-be94-2847d8921f79', 'كرةٌ واقفةٌ ركلناها فجرَت. ماذا فعلت القوّة؟', '[{"id":"a","text":"حرّكت جسمًا ساكنًا"},{"id":"b","text":"أوقفت جسمًا متحرّكًا"},{"id":"c","text":"غيّرت لون الكرة"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'a', 'الكرة كانت ساكنةً ثمّ تحرّكت بعد الرّكل، فالقوّة حرّكت جسمًا ساكنًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('801e2312-1507-596e-90f1-105400f73102', '9290404d-5200-5b58-be94-2847d8921f79', 'أمسكنا كرةً جاريةً فوقفت. ماذا فعلت القوّة؟', '[{"id":"a","text":"حرّكت جسمًا ساكنًا"},{"id":"b","text":"أوقفت جسمًا متحرّكًا"},{"id":"c","text":"كبّرت الكرة"},{"id":"d","text":"رفعت الكرة إلى السماء"}]'::jsonb, 'b', 'الكرة كانت تجري ثمّ وقفت عند الإمساك بها، فالقوّة أوقفت جسمًا متحرّكًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75c2aeac-7dcf-56cc-9e9e-0c47d52d19f4', '9290404d-5200-5b58-be94-2847d8921f79', 'تركنا كرةً من اليد في الهواء. ماذا يحدث لها؟', '[{"id":"a","text":"ترتفع إلى السماء وحدها"},{"id":"b","text":"تبقى معلّقةً في الهواء"},{"id":"c","text":"تسقط على الأرض"},{"id":"d","text":"تختفي تمامًا"}]'::jsonb, 'c', 'كلّ جسمٍ نتركه يسقط على الأرض بفعل جاذبيّة الأرض التي تجذبه إلى الأسفل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bbcf1a0-b884-5fc0-ab2d-6f9b64d87a87', '9290404d-5200-5b58-be94-2847d8921f79', 'أيّ قوّةٍ يجذب بها المغناطيسُ المسمارَ الحديديّ؟', '[{"id":"a","text":"قوّة عضليّة"},{"id":"b","text":"قوّة مغناطيسيّة"},{"id":"c","text":"قوّة كهربائيّة"},{"id":"d","text":"لا قوّة، يلتصق وحده"}]'::jsonb, 'b', 'المغناطيس يجذب الحديد بقوّةٍ مغناطيسيّة، وهي نوعٌ من أنواع القوى.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09d329b9-b63e-5a45-a8b7-37088da036bd', '9290404d-5200-5b58-be94-2847d8921f79', 'نرفع حقيبةً ثقيلةً إلى أعلى. ماذا نحتاج؟', '[{"id":"a","text":"لا نحتاج أيّ قوّة"},{"id":"b","text":"نتركها فترتفع وحدها"},{"id":"c","text":"نطلب من المغناطيس رفعها"},{"id":"d","text":"نُسلّط عليها قوّة عضليّة"}]'::jsonb, 'd', 'رفع الأجسام إلى أعلى يحتاج إلى تسليط قوّة، وكلّما ثقُل الجسم احتجنا قوّةً أكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('298b4be2-8d90-5ac7-9a6a-505d7423d793', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', '⭐ تمرين: القوّة وآثارها', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3dcdcdf3-16f1-57fd-ab9b-b84f33f40878', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'يدٌ تدفع الكرةَ بقوّة فتتحرّك إلى الأمام. ماذا فعلت القوّة؟<svg viewBox="0 0 210 110" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="92" x2="200" y2="92" stroke="#1f2937" stroke-width="2"/><rect x="10" y="84" width="190" height="8" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><ellipse cx="40" cy="62" rx="16" ry="20" fill="#fdba74" stroke="#1f2937" stroke-width="2"/><path d="M40 50 q12 0 14 12 q-2 6 -8 4" fill="#fdba74" stroke="#1f2937" stroke-width="2"/><line x1="58" y1="62" x2="98" y2="62" stroke="#f59e0b" stroke-width="6"/><polygon points="118,62 96,52 96,72" fill="#f59e0b" stroke="#1f2937" stroke-width="1.5"/><circle cx="150" cy="66" r="18" fill="#ef4444" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"حرّكت الكرةَ بعد أن كانت ساكنة"},{"id":"b","text":"أوقفت الكرةَ المتحرّكة"},{"id":"c","text":"غيّرت لونَ الكرة"},{"id":"d","text":"لم تفعل شيئًا للكرة"}]'::jsonb, 'a', 'الصورة تُظهر يدًا تدفع الكرةَ بسهمِ قوّة، فتحرّكت الكرةُ بعد أن كانت ساكنة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acd2fea3-f55b-5425-9026-9d8bc652771b', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'كرةٌ تجري نحوك، أمسكتَها فوقفت. ماذا فعلت قوّةُ يدك؟', '[{"id":"a","text":"حرّكت جسمًا ساكنًا"},{"id":"b","text":"أوقفت جسمًا متحرّكًا"},{"id":"c","text":"غيّرت شكلَ الكرة"},{"id":"d","text":"رفعت الكرة إلى السماء"}]'::jsonb, 'b', 'الكرة كانت تجري ثمّ وقفت عند الإمساك بها، فالقوّة أوقفت جسمًا متحرّكًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3946442-e297-534c-8e35-52ff5b67ce37', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'ضغطنا قطعةَ عجينٍ بأيدينا فصارت مسطّحة. ماذا فعلت القوّة؟', '[{"id":"a","text":"حرّكتها إلى الأمام"},{"id":"b","text":"أوقفتها"},{"id":"c","text":"غيّرت شكلَها"},{"id":"d","text":"لم تغيّر فيها شيئًا"}]'::jsonb, 'c', 'العجينُ تغيّر شكلُه بعد الضغط، فمن آثار القوّة أنّها تغيّر شكلَ الأجسام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31923788-ebac-5918-9b47-b7c4ca2155ff', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'تركنا تفّاحةً من اليد. إلى أين تذهب؟', '[{"id":"a","text":"ترتفع إلى السماء"},{"id":"b","text":"تبقى معلّقةً في الهواء"},{"id":"c","text":"تطير إلى الجانب"},{"id":"d","text":"تسقط على الأرض"}]'::jsonb, 'd', 'كلّ جسمٍ نتركه يسقط على الأرض بفعل جاذبيّة الأرض التي تجذبه إلى الأسفل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d86fba62-e9b3-566d-adbb-10f2a4cb890c', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'بأيّ قوّةٍ نرفع حقيبةً مدرسيّة؟', '[{"id":"a","text":"قوّة عضليّة"},{"id":"b","text":"قوّة مغناطيسيّة"},{"id":"c","text":"بلا قوّة، ترتفع وحدها"},{"id":"d","text":"قوّة المغناطيس"}]'::jsonb, 'a', 'نرفع الحقيبةَ بقوّةِ عضلاتنا، وهي قوّةٌ عضليّة من آثارها رفعُ الأجسام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('587cace2-68b6-55af-a771-c1a88fe28940', '298b4be2-8d90-5ac7-9a6a-505d7423d793', 'ماذا يجذب المغناطيس من بين هذه الأشياء؟', '[{"id":"a","text":"الورقة"},{"id":"b","text":"مسمارَ الحديد"},{"id":"c","text":"قطعةَ الخشب"},{"id":"d","text":"كوبَ الماء"}]'::jsonb, 'b', 'المغناطيس يجذب الحديدَ بقوّةٍ مغناطيسيّة، فيجذب مسمارَ الحديد دون الورق أو الخشب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a9c65e2a-bf32-5201-891b-a2e85832e11d', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد القوى', 3, 120, 30, 'boss', 'admin', 2)
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
  ('aac635e5-2cb1-5699-815a-033483ca8994', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'لاعبٌ ضربَ الكرةَ الجاريةَ فغيّرت طريقَها إلى جهةٍ أخرى. ماذا فعلت القوّة؟', '[{"id":"a","text":"غيّرت حركةَ الكرة (اتّجاهها)"},{"id":"b","text":"أوقفت الكرةَ تمامًا"},{"id":"c","text":"غيّرت لونَ الكرة"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'a', 'الكرةُ كانت تسير في طريقٍ ثمّ غيّرت اتّجاهَها بعد الضربة، فالقوّة غيّرت حركةَ الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a0837d0-8efe-592a-a485-deb053ec5214', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'لماذا تسقط الكرةُ على الأرض إذا تركناها في الهواء؟', '[{"id":"a","text":"لأنّها ثقيلةٌ فقط دون سبب"},{"id":"b","text":"لأنّ جاذبيّةَ الأرض تجذبها إلى الأسفل"},{"id":"c","text":"لأنّ الهواءَ يدفعها لأعلى"},{"id":"d","text":"لأنّ المغناطيسَ يجذبها"}]'::jsonb, 'b', 'كلّ جسمٍ متروكٍ يسقط على الأرض لأنّ جاذبيّةَ الأرض تجذبه إلى الأسفل، لا الهواء ولا المغناطيس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5597dd0f-d091-5671-b3d3-419ee49fd41e', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'هذا المشهد يُظهر قوّةً تجذب المسمارَ عن بُعد. ما نوعُها؟<svg viewBox="0 0 210 100" xmlns="http://www.w3.org/2000/svg"><path d="M20 30 h22 v40 h-22 z" fill="#ef4444" stroke="#1f2937" stroke-width="2"/><path d="M20 30 h22 v14 h-22 z" fill="#3b82f6" stroke="#1f2937" stroke-width="2"/><line x1="50" y1="50" x2="118" y2="50" stroke="#1f2937" stroke-width="2.5" stroke-dasharray="7 5"/><polygon points="58,50 76,42 76,58" fill="#1f2937"/><rect x="130" y="46" width="50" height="8" fill="#64748b" stroke="#1f2937" stroke-width="2"/><polygon points="180,42 196,50 180,58" fill="#64748b" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"قوّة عضليّة من اليد"},{"id":"b","text":"قوّة كهربائيّة"},{"id":"c","text":"قوّة مغناطيسيّة"},{"id":"d","text":"لا توجد قوّة"}]'::jsonb, 'c', 'الصورة تُظهر مغناطيسًا يجذب مسمارَ حديدٍ عن بُعد، وهذه قوّةٌ مغناطيسيّة لا عضليّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a70fcc4-c2e1-5acd-9dc7-346471fcc39d', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'قال طفل: «إذا لم أرَ القوّة فهي غير موجودة». ما الصحيح؟', '[{"id":"a","text":"صحيح، القوّة يجب أن تُرى"},{"id":"b","text":"القوّةُ شيءٌ نلمسه باليد"},{"id":"c","text":"القوّةُ ليست إلّا في المغناطيس"},{"id":"d","text":"لا نرى القوّةَ بل نرى أثرَها في الأجسام"}]'::jsonb, 'd', 'الخطأ الشائع: ظنّ أنّ القوّة تُرى. نحن لا نرى القوّةَ نفسها، بل ندركها من أثرها: حركةٍ أو توقّفٍ أو تغيّرِ شكل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff7c6a8b-ac83-506c-a28b-6d8ecdd9f3fd', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'قال طفل: «الأجسامُ الخفيفةُ ترتفع وحدها إلى أعلى». ما الصحيح؟', '[{"id":"a","text":"صحيح، الخفيفُ يطير دائمًا"},{"id":"b","text":"كلُّ جسمٍ متروكٍ يسقط على الأرض بالجاذبيّة"},{"id":"c","text":"الأجسامُ تبقى معلّقةً في الهواء"},{"id":"d","text":"الخفيفُ يختفي"}]'::jsonb, 'b', 'الخطأ الشائع: ظنّ أنّ الأجسامَ ترتفع وحدها. كلّ جسمٍ نتركه يسقط على الأرض بفعل جاذبيّة الأرض، خفيفًا كان أو ثقيلًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bcf9aec-2028-57aa-b1a7-cab09161650d', 'a9c65e2a-bf32-5201-891b-a2e85832e11d', 'نريد رفعَ صندوقٍ ثقيلٍ جدًّا إلى الشاحنة. ما الأنسب؟', '[{"id":"a","text":"نتركه فيرتفع وحده"},{"id":"b","text":"نقرّب منه مغناطيسًا صغيرًا"},{"id":"c","text":"نُسلّط عليه قوّةً كبيرة (رافع أو عدّة أشخاص)"},{"id":"d","text":"ننتظر حتّى تخفّ الجاذبيّة"}]'::jsonb, 'c', 'رفعُ الأجسام يحتاج قوّة، وكلّما ثقُل الجسم احتجنا قوّةً أكبر، كرافعٍ أو تعاونِ عدّة أشخاص.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1a3290f7-7e35-598c-b60b-ecf912cda704', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', '⭐⭐ تمرين مراجعة: القوى (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('51bace8d-d282-5302-9f74-2eb296d4149a', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'أكملِ الجملة: «نُدركُ القوّةَ من خلال …»', '[{"id":"a","text":"أثرها في الأجسام"},{"id":"b","text":"لونها"},{"id":"c","text":"صوتها"},{"id":"d","text":"رائحتها"}]'::jsonb, 'a', 'لا نرى القوّةَ نفسها، بل ندركها من أثرها: حركةٍ أو توقّفٍ أو تغيّرِ شكل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2eb3f8a4-60cf-5fa3-a968-17df1f5e3e53', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'أيّ مثالٍ يُظهر أنّ القوّةَ توقفُ جسمًا متحرّكًا؟', '[{"id":"a","text":"نركل كرةً واقفةً فتجري"},{"id":"b","text":"حارسُ المرمى يمسك الكرةَ الجاريةَ فتقف"},{"id":"c","text":"نضغط العجينَ فيتسطّح"},{"id":"d","text":"نترك كرةً فتسقط"}]'::jsonb, 'b', 'إمساكُ الكرة الجارية يوقفها، وهذا أثرُ القوّة في إيقاف جسمٍ متحرّك.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56d4067d-bd5c-5d9e-949b-880142a35d1b', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'أيّ جملةٍ صحيحةٌ عن السقوط؟', '[{"id":"a","text":"الأجسامُ تبقى معلّقةً في الهواء"},{"id":"b","text":"الأجسامُ ترتفع وحدها"},{"id":"c","text":"الأجسامُ المتروكةُ تسقط على الأرض"},{"id":"d","text":"الأجسامُ تذهب يمينًا"}]'::jsonb, 'c', 'كلّ جسمٍ نتركه يسقط على الأرض بفعل جاذبيّة الأرض، فهذه حتميّةُ سقوط الأجسام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9abe733-3e57-5b23-9e2a-93b8e74f8cba', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'العاملُ يستعمل عضلاتِه ليدفعَ العربة. ما نوعُ هذه القوّة؟', '[{"id":"a","text":"قوّة كهربائيّة"},{"id":"b","text":"قوّة مغناطيسيّة"},{"id":"c","text":"لا قوّة"},{"id":"d","text":"قوّة عضليّة"}]'::jsonb, 'd', 'العاملُ يدفع بعضلاته، فهذه قوّةٌ عضليّة تحرّك العربة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39c468ad-76af-590c-9839-22b43d359a4c', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'أيّ الأشياء يجذبه المغناطيس؟', '[{"id":"a","text":"كوب الماء"},{"id":"b","text":"ورقة الكرّاس"},{"id":"c","text":"مفتاح من حديد"},{"id":"d","text":"قطعة خشب"}]'::jsonb, 'c', 'المغناطيس يجذب الحديدَ بقوّةٍ مغناطيسيّة، فيجذب المفتاحَ الحديديّ دون الماء أو الورق أو الخشب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd87e424-0eef-5376-b22d-2370aa9326b9', '1a3290f7-7e35-598c-b60b-ecf912cda704', 'صانعُ الفخّار يضغط الطينَ بيديه فيصير كوبًا. ما أثرُ القوّة هنا؟', '[{"id":"a","text":"غيّرت شكلَ الطين"},{"id":"b","text":"أوقفت الطين"},{"id":"c","text":"رفعت الطين إلى السماء"},{"id":"d","text":"غيّرت لون الطين"}]'::jsonb, 'a', 'الطينُ تغيّر شكلُه بالضغط فصار كوبًا، فمن آثار القوّة أنّها تغيّر شكلَ الأجسام.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8da86998-8b34-574d-8e65-e852f0644a99', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل القوى', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('628d5548-757c-5ebe-9bbf-3053aa444c09', '8da86998-8b34-574d-8e65-e852f0644a99', 'في مباراةٍ: ركلتَ الكرةَ الواقفةَ فجرَت، ثمّ أمسكها الحارسُ فوقفت. كم أثرًا للقوّة ظهر؟', '[{"id":"a","text":"أثران: حرّكت ساكنًا ثمّ أوقفت متحرّكًا"},{"id":"b","text":"أثرٌ واحدٌ فقط"},{"id":"c","text":"لا أثر للقوّة"},{"id":"d","text":"غيّرت لونَ الكرة"}]'::jsonb, 'a', 'أوّلًا حرّكتِ القوّةُ كرةً ساكنةً بالرّكل، ثمّ أوقفت قوّةُ الحارسِ كرةً متحرّكة، فهما أثران مختلفان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0612e33d-f880-507f-9e68-6f41d877ddc7', '8da86998-8b34-574d-8e65-e852f0644a99', 'هذه الكرة تُركت في الهواء. إلى أين يشير سهمُ القوّة، ولماذا؟<svg viewBox="0 0 160 130" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="112" x2="150" y2="112" stroke="#1f2937" stroke-width="2"/><rect x="10" y="104" width="140" height="8" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><circle cx="80" cy="30" r="16" fill="#ef4444" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="50" x2="80" y2="88" stroke="#f59e0b" stroke-width="6"/><polygon points="80,104 70,82 90,82" fill="#f59e0b" stroke="#1f2937" stroke-width="1.5"/></svg>', '[{"id":"a","text":"إلى أعلى، لأنّ الكرة ترتفع"},{"id":"b","text":"إلى أسفل، لأنّ جاذبيّةَ الأرض تجذبها فتسقط"},{"id":"c","text":"إلى اليمين، لأنّ الهواء يدفعها"},{"id":"d","text":"لا يشير إلى شيء"}]'::jsonb, 'b', 'السهمُ يشير نحو الأرض لأنّ جاذبيّةَ الأرض تجذب الكرةَ إلى الأسفل، فتسقط حتمًا عند تركها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f8c4f26-5edf-5ffd-b67b-c9cc16460133', '8da86998-8b34-574d-8e65-e852f0644a99', 'رتّبْ آثارَ القوّة على كرةٍ: «أوقفتُها وهي تجري، ثمّ ضغطتُها فتغيّر شكلُها». ما الترتيب الصحيح للأثرين؟', '[{"id":"a","text":"تغييرُ شكلٍ ثمّ تحريكُ ساكن"},{"id":"b","text":"تحريكُ ساكنٍ ثمّ تغييرُ اتّجاه"},{"id":"c","text":"إيقافُ متحرّكٍ ثمّ تغييرُ شكل"},{"id":"d","text":"تغييرُ لونٍ ثمّ سقوط"}]'::jsonb, 'c', 'أوّلًا أوقفتِ القوّةُ كرةً متحرّكة، ثمّ بالضغط غيّرت شكلَها، فالترتيب: إيقافُ متحرّكٍ ثمّ تغييرُ شكل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a46cff3-86b2-58ea-9a0f-0ff6f22ddd96', '8da86998-8b34-574d-8e65-e852f0644a99', 'أمامك: مسمارُ حديد، ملعقةُ خشب، ممحاةُ مطّاط، مفتاحُ حديد. ماذا يجذب المغناطيس؟', '[{"id":"a","text":"كلّ الأشياء الأربعة"},{"id":"b","text":"الخشبَ والمطّاط فقط"},{"id":"c","text":"لا شيء منها"},{"id":"d","text":"المسمارَ والمفتاحَ (الحديد) فقط"}]'::jsonb, 'd', 'المغناطيس يجذب الحديدَ فقط، فيجذب المسمارَ والمفتاحَ الحديديّين، ولا يجذب الخشبَ ولا المطّاط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b42faa9f-4122-5179-92a5-94dfd2d3d376', '8da86998-8b34-574d-8e65-e852f0644a99', 'قال طفل: «المغناطيس يجذب كلَّ المعادن، وحتّى الورق». ما الصحيح؟', '[{"id":"a","text":"صحيح، يجذب كلَّ شيء"},{"id":"b","text":"يجذب الورقَ فقط"},{"id":"c","text":"لا يجذب شيئًا أبدًا"},{"id":"d","text":"يجذب الحديدَ، ولا يجذب الورق"}]'::jsonb, 'd', 'الخطأ الشائع: ظنّ أنّ المغناطيس يجذب كلَّ شيء. هو يجذب الحديدَ بقوّةٍ مغناطيسيّة، أمّا الورقُ فلا يجذبه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62ecf6ea-b89b-5151-b2c6-9c79d27b9e09', '8da86998-8b34-574d-8e65-e852f0644a99', 'آلةٌ كهربائيّةٌ تُشغَّلُ بزرّ، وعاملٌ يرفع صندوقًا بيديه. ما القوّتان المستعملتان بالترتيب؟', '[{"id":"a","text":"مغناطيسيّة ثمّ مغناطيسيّة"},{"id":"b","text":"كهربائيّة ثمّ عضليّة"},{"id":"c","text":"عضليّة ثمّ كهربائيّة"},{"id":"d","text":"لا قوّة في الحالتين"}]'::jsonb, 'b', 'الآلةُ تعمل بقوّةٍ كهربائيّة، والعاملُ يرفع بقوّةٍ عضليّة، فالترتيب: كهربائيّة ثمّ عضليّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', '80c7631d-4f76-5d61-a536-953b1f7a51e9', 'eveil-scientifique-2eme', '📝 تدريب ⭐⭐⭐: آثارُ القوّة وأنواعها', 3, 120, 30, 'boss', 'admin', 5)
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
  ('e00c008c-11c3-553a-b14b-98e856216451', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'دفعنا عربةً واقفةً فسارت إلى الأمام. ما أثرُ القوّة؟', '[{"id":"a","text":"حرّكت جسمًا ساكنًا"},{"id":"b","text":"غيّرت شكلَ العربة"},{"id":"c","text":"أوقفت العربة"},{"id":"d","text":"رفعت العربة إلى أعلى"}]'::jsonb, 'a', 'العربةُ كانت ساكنةً ثمّ سارت بعد الدفع، فالقوّة حرّكت جسمًا ساكنًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('456ebe4f-f145-5181-b1dc-244568ccbaff', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'أيّ هذه قوّةٌ مغناطيسيّة؟', '[{"id":"a","text":"رفعُ حقيبةٍ بالعضلات"},{"id":"b","text":"مغناطيسٌ يجذب مسمارَ حديد"},{"id":"c","text":"تشغيلُ مروحةٍ بالكهرباء"},{"id":"d","text":"ركلُ كرةٍ بالقدم"}]'::jsonb, 'b', 'جذبُ المغناطيس للحديد قوّةٌ مغناطيسيّة، أمّا رفعُ الحقيبة فعضليّة وتشغيلُ المروحة فكهربائيّة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3711687-7fd5-55e0-9c1e-97805daf780e', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'كرةٌ تتدحرج بسرعة، لمسناها فأبطأت ثمّ وقفت. ما أثرُ القوّة؟', '[{"id":"a","text":"حرّكت ساكنًا"},{"id":"b","text":"غيّرت لونَها"},{"id":"c","text":"غيّرت حركتَها حتّى أوقفتها"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'c', 'القوّةُ أبطأت الكرةَ ثمّ أوقفتها، فهي غيّرت حركةَ الجسم (سرعتَه) إلى أن توقّف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a42e1ffa-465d-54f9-847e-63e53bd014a6', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'لماذا لا تبقى الكرةُ معلّقةً في الهواء إذا تركناها؟', '[{"id":"a","text":"لأنّ الهواءَ يدفعها لأعلى"},{"id":"b","text":"لأنّ المغناطيسَ يمسكها"},{"id":"c","text":"لأنّها خفيفة"},{"id":"d","text":"لأنّ جاذبيّةَ الأرض تجذبها فتسقط"}]'::jsonb, 'd', 'جاذبيّةُ الأرض تجذب كلَّ جسمٍ متروكٍ إلى الأسفل، فلا يبقى معلّقًا بل يسقط على الأرض.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6b7db09-97c2-5579-bd96-550fc3e60967', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'صندوقٌ ثقيلٌ وصندوقٌ خفيف. أيّهما يحتاج قوّةً أكبر لرفعه؟', '[{"id":"a","text":"الصندوق الثقيل"},{"id":"b","text":"الصندوق الخفيف"},{"id":"c","text":"كلاهما يرتفع وحده"},{"id":"d","text":"لا يحتاج أيٌّ منهما قوّة"}]'::jsonb, 'a', 'رفعُ الأجسام يحتاج قوّة، وكلّما ثقُل الجسم احتجنا قوّةً أكبر، فالصندوقُ الثقيل يحتاج قوّةً أكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('683f997a-99b0-5dfb-9d69-249e1783a94e', 'c9362d95-4ec4-58e1-9ce4-0ffa35af1fdb', 'أرادت سارة أن تُسطّحَ قطعةَ عجينٍ مدوّرة. ما القوّة وما أثرُها؟', '[{"id":"a","text":"قوّة مغناطيسيّة توقفها"},{"id":"b","text":"قوّة كهربائيّة ترفعها"},{"id":"c","text":"لا قوّة، تتسطّح وحدها"},{"id":"d","text":"قوّة عضليّة تضغطها فتغيّر شكلَها"}]'::jsonb, 'd', 'سارةُ تضغط بعضلاتها (قوّة عضليّة)، فيتغيّر شكلُ العجين من مدوّرٍ إلى مسطّح، وهذا أثرُ تغييرِ الشكل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

