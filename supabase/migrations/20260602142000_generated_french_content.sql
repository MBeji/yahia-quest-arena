-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: french (Français)
-- Regenerate with: npm run content:build
-- Source of truth: content/french/
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
  ('french', 'Français', 'Grammaire, conjugaison, lexique, compréhension et production écrite — programme de 9ème année de base', 'Sagesse', 'subject-french', 'BookOpen', 2, 'fr', false)
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
      AND e.subject_id = 'french'
      AND e.source = 'admin'
      AND q.id NOT IN ('7a3d666a-ae97-5cca-b650-d0d8ab427c72', 'b2ff9a73-4e3e-5480-8908-65ac415b84b9', 'd6a3e46e-b0b6-54a7-b112-b02150981080', 'b54bb455-90a0-51f8-85a9-bd1a7c6490b4', '1f97d038-415e-5681-996d-bbb0881e4026', 'd7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', '50cce373-29a3-50c2-8dfb-6b123b7c0f09', '37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'eccc5914-b0d5-5035-804e-16a2cefc1af6', 'fd092ac9-1a1b-5654-a751-1f1f28f5548a', '6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', '11d792cc-0455-56d3-b00b-9145225ca97b', '9044bfb1-eeb6-54e1-a7d8-10408624f911', '8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '079d8ed9-845f-5b08-9391-5984479ec84f', '276a92b0-0c54-5381-b57c-d86ad57b021e', 'aabce6d4-f8ce-58d2-8737-80d73b3f05c8', '9d9b6ed5-2ef5-5fff-ac60-55e0b8b2fad9', '5681cba6-16a7-5d6d-82d8-c3818931e1be', '3f75e68a-b3b0-55c3-9382-e5492e615843', '867877d2-a50f-5b3d-802b-ab2e9ce8500d', '82fdcaf9-70ee-54db-9304-ea970a6d626e', 'bfcac64e-20bb-5243-b94e-f9ca32b9656e', '88975673-9739-5d79-8e8d-d2d7134aa3db', 'e2146fe9-522d-579e-8126-78cb344ed44d', '593810f6-c884-519f-9a58-a9c23081bbd4', 'e3833318-8711-50e7-ab12-5d09fc7a0c34', 'c43ebd4e-b373-5147-8a23-30bd9aed1145', 'fc9408ca-e18d-50e5-b964-ffc8acadf596', 'cd3e5a8a-d94f-58a0-8c6f-8838b820e67a', 'ef679ede-b207-51a6-b679-e6d7ec83f53a', '3e6d1a0e-ebba-5662-9b50-235bc8111b80', '051afec1-27e6-5b01-a35c-113fd8d1d9cc', '940021d7-b5b4-5449-83ea-ce2fbc279ff3', 'd645eccd-a5d0-5aeb-9284-79aab3b2de20', '4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '07e8045b-b474-56cb-88ee-a5cc0e713ffa', 'cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '1e3fc6c2-7f49-579a-9766-20a7860eca17', '308d579a-062a-5895-abfd-e1a05a0356de', 'c19c1f96-69fa-5f06-a875-55bcfda850ce', '98016972-94e1-5f90-9b1e-f59b43d6b0ae', '851ee672-a02e-5b39-85ab-663ccff5fccd', '78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '67a0c11d-ab91-59df-b1f1-e411d1e2cb95', 'b8697075-71ce-56a1-987c-a1f9cc79846a', '6d3ba807-5296-5b3b-b100-06baba0b4726', 'de3152a5-2625-51bc-97a3-b2ee29cbb5a6', 'cb5483c3-b3c7-58be-8735-6e1c7d30764b', 'a600da65-51d7-52b5-aa7f-11fa86b62d26', '7a99cc03-d6f9-52f4-bdc4-9f531267885c', '52a2766e-fcf5-56ae-8559-494d2b9907ec', '7b544c55-62e7-53a6-8c54-030638b09322', 'b0d6bad5-c558-5387-b3c9-4a8b167cc412', '348dc8e4-92e9-52f8-a85a-8fc5dfb3dfdb', 'b356e2bc-7641-5bd1-973a-cf751b424915', '27b8f517-f017-58a8-a0a8-0e44ba9ca0cd', '4a4ba085-73fa-5f77-bfdc-a81caab9b51e', '75e4d82d-47e0-5432-b840-67558c7322b8', '9fec6335-9472-5469-846a-75981fedeba3', '19564ab9-63a3-530c-a139-4913f70fcd20', '783bb08e-d6a7-5d72-ae16-851a5e696425', '96225451-0ff2-5e30-ab72-ea01d8573838', 'ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', 'c3e2ab45-089e-5a99-b92a-87cbb5576dde', '36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', 'fde829bd-4a35-5b7a-980b-d9373c4bb855', '6d7569dc-adcd-5490-8ab4-9e1252876fbc', '3b271bbf-7019-55aa-93bb-583c3fbb407a', '332e1995-cf27-5529-9e9c-87c94efb4982', '4c1cd36e-d806-5894-a665-34368ab1f4bc', '6abd4b21-6d1c-51e3-9607-d615dae991a3', '3d1e84a5-a743-5748-b970-cc7eda950ebc', 'f22c973f-b551-5ada-b930-ce0801010307', '47c9ba09-be77-5e69-9af8-8b89d56d6402', '6bb46e0f-1ca3-5dfc-bab0-c7a2e1f611e3', '1061e3a4-4d8c-545b-a98c-2dd987472eaa', '8a6d6d54-fab2-5da9-b165-6880b7d6dfde', '769e9ea5-33a5-5482-b19c-3ff5205cac01', '4357bc16-e6fd-5663-8d0e-ac9d2bfafdea', 'bf62eaa6-0c73-5b2a-8820-7237bce83c21', 'a7973a25-f7ad-54f7-889a-fb32afb22a8c', 'c1c02ada-a91d-5c2a-9dcf-707291fa4620', '0cfc8ea9-1e3c-5004-8105-4860681f369f', '260c5f3f-a766-5a3e-a740-dd0f00f33d3d', '23cc5062-223d-5494-94eb-9830da75d3e0', '6d1bf493-f6d4-5de2-8d8f-4e728127758b', 'd54d5b3a-c34c-5314-8b03-d3350d485dcd', '633f9e2a-6695-5ff9-b6f6-934cbe3e687f', '0a8d594c-bdec-5df8-a62e-51a618c211c4', 'e076c07d-7d92-5511-a4ab-c5711a2c73cd', 'c124cc25-0734-5a92-811e-669baf60fa4b', 'a365e428-06ba-5c4e-b3fb-3b1eb755b102', '69045ed1-0311-55cc-a9d1-5ff08b74073c', '103b3b98-c5ec-5850-b280-83a2c4488045', 'b56fc225-0884-57fe-9604-a5f47069571c', 'eed4181b-dcbb-5ee2-b6e2-44685205a62e', 'd53a306c-aa47-55c3-b52a-3b76f508e771', '789d8fb4-ef9b-57a5-971b-67821be37f1a', '927e93ec-4461-53b5-9378-38ef71fbb9b2', '03c3a61a-f9aa-5183-a4e0-994f72750e44', '7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'b4beed3e-de76-5a9d-b807-84d386df921d', '1de99ec2-2a17-58f7-9114-ec649edef3b9', 'b262a7f4-2c4a-5516-b86f-a4364a2f19cd', 'bf2f5e39-a69b-57db-bf3b-7ad4944e8af1', '743f0cfa-5ea6-5f79-b14e-37765de428fd', '17aa026e-8a88-58d5-a5c0-affd7e4f59da', '31d88445-55ae-5ab5-a019-4e8421185606', '70cae8ac-91e9-5ebd-8a9e-99137922c50e', '90a52a14-dddc-5c1f-9ae2-e046a6a3bf36', '89272a98-c361-59d6-9769-0f446eec2791', '84cc4ad9-5b0a-5abf-94ac-0ef213a39e00', '7fed4144-3d84-5e12-9241-90c61b17bc16', 'e6d69941-cc45-5d67-a596-939ffc03da9f', '860343a5-fe3b-56a4-943f-74ea5732b0ef', '6f9f38b1-0cf8-50cf-97b9-f7484f39aac2', 'f7705088-66ed-5e8d-b23e-63a1f2eb6260', '6d2559a3-989d-53df-8054-651a6ed1b9f6', '358f2069-51cf-5a2a-be86-9b7f5e9ef89a', '6d3e559b-0449-57de-89b2-0ff23b9fd893', 'f2f3c849-25e9-53d0-b09e-4eff720714b2', '3ee10a83-a4d9-5855-bb7d-79425521b890', '2329c69b-07a0-5905-8d3b-82a269887104', '815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'a2241625-9fa9-504f-841d-0b346289ca00', '1b86b32d-c59d-5d28-a86e-a87b3cd41919', '3fadd44b-aca0-5ece-b1a4-02766d4517e3', 'cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '83dfacbc-3c11-55bf-ad09-cc214abb3711', '1f4296d8-c07e-5e6d-b599-0022c8f72118', '3a935e4d-91f9-59c5-aed2-fbaedff745b6', '8c70b94d-f217-58bc-a0a0-0bf5cc8d027c', 'f07596c5-b4cf-56a0-aedb-85e25a439600', 'b188b3ad-3e88-5b36-9912-e9150f3c8998', '3e79728f-c65b-539a-a096-2ed061f3addd', '508d24d2-5250-505a-a83b-7c7c80b29b95', '3476945b-e660-5149-b6af-990f68a221c7', 'fa4da252-76b0-5bbe-8764-979312b45f75', '0a29a5f8-19d1-5d00-8acd-762144ca1245', '76b6593e-ee1c-5a91-b24e-e0d073a5bebb', '1cfec379-8300-5b53-b683-971a9cb396c4', '33967eca-c9b5-5f4f-84e3-9519064494aa', '9c6a44dd-b158-5d39-8636-2da68a6b6d9c', 'a07afd33-a11b-52b9-b5ba-343427b0bc84', 'dbd55b7e-bb3e-5706-9186-e833923ce87d', '5aeed1da-a9ed-53f3-9f19-b9f22a1abc0d', '33b4e382-cde8-5e40-8398-c5e311c1ccf4', 'd6e6c9bc-90d2-5532-9fcf-52ddef7681b1', 'e91167fb-6b84-515a-9848-d07949d71c90', '28997c99-1b74-5330-8272-d08f4682b8c8', 'ee97c631-820f-50c1-9de3-58f140893afa', '5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '676a25e8-1769-5b86-945f-06f2bf2d8548', 'cc3b9212-5768-5113-ad7b-2ba9128d740f', '0b03e40f-b428-588f-8ccc-c9431e9e0fda', 'ba963d3c-68cf-5c49-b62e-344049caab0e', 'c394033c-66d8-548c-951c-5472f4c41c30', 'efa163b4-a341-5c43-9bfb-142a7b277fa7', 'a467a610-6abe-5eac-ba05-83a1fa8608f7', '1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', 'e67df23c-e9ee-54fe-b2ab-bc1529b38436', '2a0919b3-712a-5d61-91f9-2a023e33b085', '3d69fe82-436d-59e4-96c0-9dbabc7728e9', '28178fc6-48da-5f7a-833e-d9fe334c8358', '10762f40-915a-5ccf-8f2a-9532db6b3023', 'eb19b45f-4918-50fc-afa4-47655504df12', 'bdad7adc-e019-5996-a87e-6409a86248d0', 'dae86223-f3ac-578b-8d7c-9dcbb14108e1', '070508f4-ab03-5873-a546-2d8e0bf52886', '8442fd5f-a8a3-5bd8-a9cd-488177b76852', '550725f1-73d7-513e-956b-cabad8c09180', '1fc3ea14-1df5-5242-b3f3-b309c23e2746', '5f8ad45d-b161-562e-b38c-3524e78b7214', '26d2e999-0836-52ea-beac-d55e58bce05d', 'ca5f29a5-a523-5a3a-b6b2-f40db9ee0548', 'f43f9ef9-486d-5151-9ec5-2c5f7ad19738', '0adce953-7057-5641-b1cb-337665f8da31', 'b7b276c1-df61-5015-a396-ac06265465c7', '1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', '120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'e29bdbfe-677e-5173-8a30-dc1ddc813fe8', '9e3d2494-fea2-5244-b1a6-622c5560913b', 'a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', '5e344432-2f71-56d6-abf1-5c8c31d537c9', '24a82297-67c0-5306-9121-6efc815a919e', '9bfeec0f-5f54-5365-9c20-356635d68e1c', '73d9a740-8761-50f2-a74c-f66483150482', 'a08dc674-1ad0-5709-ac2a-91fb09b03e23', '1a654666-d0cf-5a81-9244-aad9397d5ddb', '7f3ed481-20e3-5434-bc4b-65cadb9635ea', 'a19b37f7-b80e-5ae9-bbcf-129d2677cdb6', 'f5ce42e1-de4b-5b66-b8a0-880ca8b71616', '1665f4a2-f2d4-5b90-a73f-cfd8ebc25d82', 'aca78fb2-be94-515e-93e9-07de78b76084', 'fe2204e3-3db5-5b36-9d8c-58bb455001d2', '7c5c580c-f674-5b9e-a61a-fa3b441de12e', '53bfe9eb-7729-5bb4-8122-c4019895f276', 'acd5d4f4-3238-5d8b-8c16-1ba4346feb72', '30e3f6ac-866e-5a8e-8102-b6096ae5e4e5', 'c2cd69bc-3db3-5827-8a83-57bcf033de86', 'fe6bf775-0956-5d95-956d-e49d795a9617', 'ee69c6c1-c5df-5cd9-9da9-046389fb356f', 'd5881556-ec1e-57f7-9dde-d113d29c8710', '17071935-7310-51c2-a8d6-00bbac4c3e23', '72632bce-eb90-5864-8b0a-fd10908fafe1', 'e4bf56ff-2ae1-5126-9019-5800347aa34a', '1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '00a19639-3883-5d3c-8924-c94faf49d549', 'db7ecffa-12db-5ebe-a71f-0b59145133eb', '4032fad4-617f-58e6-b390-53e4b2c6c1c6', '61ccedd3-9052-5b32-ab73-cd1879d56ae7', '6cc0e08b-af9c-5dce-b02f-5bd6587bd103', 'ed57c56c-2714-58cf-b436-afc5b1f0fb55', 'a704ca25-4e84-5194-ae74-d707994df17e', '3088ed38-3f25-5167-aa73-a51d2fb61486', '16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '64e55faa-0a53-52af-8b05-97dd07023788', '29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb', 'ef5d7171-95a0-578b-bc28-53b6fe14dad2', '588ccf1f-d83f-5cb6-91a3-1d26330db329', 'e33bc694-7409-5ed9-b465-5dafa064edd3', 'd023279e-7134-5bd4-becb-6322f8306d5f', 'ff0ae26c-d6d6-5f50-ba1c-9976a19069be', '9c7803ee-0d85-57e7-ba51-8abe476a5058', '04989013-8b32-54af-9f7c-bfda1f5b94c3', 'b78c3fb5-fcde-5273-a96f-d92327df9696', '3cc97403-7633-5b14-a33a-bbaf609673fe', '1ef3f634-b2aa-5389-83a4-70599facfb28', '16c1a42e-8fb9-5626-bedc-2fe32244e119', '6c9ed809-1bc2-594e-8afc-b4b3607537a4', '88c1f48a-2a35-5d6c-874a-6cec41778111', '077020c3-a4f1-5622-8cb0-aec77f757230', 'cda55e3c-d0ae-5f6b-a367-0665f55d4452', '67dff524-0781-58b6-8b30-fd200e7d0b94', '6037748e-1848-57f4-913d-e039fdf1f606', '6164593c-8c3a-5c0b-ac23-a2fc17bfa4b2', 'da81e1c3-f253-583b-99f4-a6da7ad2cc84', '5e019169-bdbe-5788-9b5e-13db4ae7b22f', 'b72b8ada-ccf2-5bf3-9765-42edf26bab42', '6f1c8665-d1c0-5ed3-8519-bcfa7acab159', '848ed66c-2d55-5f47-8712-32262aa46735', 'f8aae127-a29c-5649-b8cf-3904e0c38fae', 'c1c1ffd4-400a-594b-9408-521f081076f6', '63482caa-22d4-592a-b78f-a4be32dfe9ed', '0714313c-d0bd-5997-af4d-ff5c4c6ef2fa', 'a849745d-22e2-5d25-a391-5993cf4a12b9', 'ae6d3414-72ac-5ec1-8a0d-2a2bafdfdbfb', 'a381c43d-3ee3-5596-8c42-6530377c5810', '99c7d327-4658-5405-81d2-3c44b00ce441', '48881931-78d7-5e4a-a742-a3d4d7e8ef95', 'cc114016-dacc-5dd5-87e4-6b7b5f2af178', 'ab06e97b-51fd-59b0-a4d9-cde2df12c486', '2c4105f3-590a-55c7-80ce-95b8f1d62296', '4d77f78a-4ba0-56fd-9efc-bdc72e22fd0f', 'db658899-ea60-5a21-978d-2adcde0df690', 'c73cdfba-e320-5ce3-a0ba-eec42fb6c3ac', 'b85ff5e5-4e6e-50d5-ac36-f62c86ac135f', '4bcfa2d5-699a-5915-9ed7-a5fdf50ee301', '7718a410-1ad0-557d-b059-869541cb0241', '996c1e06-7a10-5972-bd28-3db55e8234bd', '1b0196a9-14d1-53f3-8931-9f5b3bed0f57', '390010fb-85c6-5acf-973f-8c390cce218d', '533df0ee-78f7-57bc-8a57-dd9eab28fed3', '3546773d-9c4c-56d2-8943-39401375c3fb', '7870668f-8f7e-5437-9372-0c3b6dce796b', '7d312960-34cc-5bc3-9b68-afcd570ad6e3', 'a6f3d8bc-773e-5241-9dfc-c92258736bc4', 'ee955f83-405f-51c7-8fca-9267645d771e', '8454304f-896c-57e2-9d6c-9404795453d2', '7e701876-a9d1-514d-848b-7567488fc2d4', '3d0f128d-cdce-5d9d-997c-047d2da2e2bc', 'c6e0e1ee-d878-5008-8460-52fdbcdb11a2', '9d520596-be86-5bf9-9986-236f642e3ee5', '3861e039-b9dc-5a7f-a1f7-4ade27282a2c', '11b23003-7011-5d40-98b3-7061425c7315', '69d3b8fa-3457-5297-82c9-f50c644c0a4e', 'd561c284-fe77-5304-8add-50b795fa84bc', 'e00b002a-d567-56b1-b788-173342c1ee53', '004290f5-18df-5e0f-9504-ef5bc050a921', '0bb3b44d-55e9-58ca-885b-33843190e4c5', '91ed9dac-19cb-5076-a268-295420d3a3e8', 'feb5008a-c62f-50e4-96c1-ef21827d5d14', '68e457c7-1d2e-5612-b531-d79d2acf9d4d', 'f36ef462-d7e1-59ac-a84b-4393c5c8ccda', '62e98c7b-be98-5da5-8c08-91d360b2614e', '820ea5b8-ff8b-55ea-8289-b9b0b85999b6', 'de91684c-3e02-5bff-8675-478d9fd09ccf', 'afa723fa-bea9-571b-a885-97d7cef1e780', 'a1919ea5-25b0-53d3-86b7-f818b632d084', 'a1faf598-b829-53af-92cf-50f1ecdd875f', 'e70e2c64-52ce-5e05-9fd2-3ddb7237d2ad', 'd1be344e-f76b-520e-b29a-16a7eeca0cda', '8dd987cc-488a-5181-95cc-a03f05f04878', '63895d39-b503-5006-ad86-24e4f220feef');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'french' AND source = 'admin' AND id NOT IN ('1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', '3b342ef2-05e7-53d3-bded-effe80517ef5', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'fdef87db-3a52-50ab-8803-b009147266cb', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', '03ebf9d6-a2d7-5967-b86c-70019206e357', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', '12f9cc53-1641-5e87-9958-ae1375000007', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '6964cb06-f67d-56f4-a779-bbbe567f265c', '239989ee-497a-589e-8483-558788dd504d', '06501a61-9965-5426-8256-57479f8c4308', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'b89d641c-95d4-5820-875a-3bac22a2add4', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', '390674fc-7d19-5cd5-a9db-018176765203', '6935b49a-94bb-5e55-958b-077f8392251d', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', '4758ebaf-51ff-5d37-b504-914009e31959', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'b3042e50-068f-5b9f-91d5-e64df884f924', '25f31af7-de92-57ff-93ce-e6dc3127c707', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'a915ce86-0073-5030-8656-f315f5857408', 'd49bcd74-d20a-552c-9658-c0d86e053975', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '981642c4-6f55-5171-897c-bdf40e984522', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', '8ce9c4aa-e64f-5a76-9812-ada88908a485', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'cc6100ec-d480-5f4c-a6b1-931442e93632', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', '92e19205-ad69-502c-9e68-9cb60a80c9a6');
DELETE FROM public.questions WHERE exercise_id IN ('1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', '3b342ef2-05e7-53d3-bded-effe80517ef5', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'fdef87db-3a52-50ab-8803-b009147266cb', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', '03ebf9d6-a2d7-5967-b86c-70019206e357', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', '12f9cc53-1641-5e87-9958-ae1375000007', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '6964cb06-f67d-56f4-a779-bbbe567f265c', '239989ee-497a-589e-8483-558788dd504d', '06501a61-9965-5426-8256-57479f8c4308', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'b89d641c-95d4-5820-875a-3bac22a2add4', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', '390674fc-7d19-5cd5-a9db-018176765203', '6935b49a-94bb-5e55-958b-077f8392251d', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', '4758ebaf-51ff-5d37-b504-914009e31959', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'b3042e50-068f-5b9f-91d5-e64df884f924', '25f31af7-de92-57ff-93ce-e6dc3127c707', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'a915ce86-0073-5030-8656-f315f5857408', 'd49bcd74-d20a-552c-9658-c0d86e053975', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '981642c4-6f55-5171-897c-bdf40e984522', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', '8ce9c4aa-e64f-5a76-9812-ada88908a485', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'cc6100ec-d480-5f4c-a6b1-931442e93632', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', '92e19205-ad69-502c-9e68-9cb60a80c9a6') AND id NOT IN ('7a3d666a-ae97-5cca-b650-d0d8ab427c72', 'b2ff9a73-4e3e-5480-8908-65ac415b84b9', 'd6a3e46e-b0b6-54a7-b112-b02150981080', 'b54bb455-90a0-51f8-85a9-bd1a7c6490b4', '1f97d038-415e-5681-996d-bbb0881e4026', 'd7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', '50cce373-29a3-50c2-8dfb-6b123b7c0f09', '37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'eccc5914-b0d5-5035-804e-16a2cefc1af6', 'fd092ac9-1a1b-5654-a751-1f1f28f5548a', '6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', '11d792cc-0455-56d3-b00b-9145225ca97b', '9044bfb1-eeb6-54e1-a7d8-10408624f911', '8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '079d8ed9-845f-5b08-9391-5984479ec84f', '276a92b0-0c54-5381-b57c-d86ad57b021e', 'aabce6d4-f8ce-58d2-8737-80d73b3f05c8', '9d9b6ed5-2ef5-5fff-ac60-55e0b8b2fad9', '5681cba6-16a7-5d6d-82d8-c3818931e1be', '3f75e68a-b3b0-55c3-9382-e5492e615843', '867877d2-a50f-5b3d-802b-ab2e9ce8500d', '82fdcaf9-70ee-54db-9304-ea970a6d626e', 'bfcac64e-20bb-5243-b94e-f9ca32b9656e', '88975673-9739-5d79-8e8d-d2d7134aa3db', 'e2146fe9-522d-579e-8126-78cb344ed44d', '593810f6-c884-519f-9a58-a9c23081bbd4', 'e3833318-8711-50e7-ab12-5d09fc7a0c34', 'c43ebd4e-b373-5147-8a23-30bd9aed1145', 'fc9408ca-e18d-50e5-b964-ffc8acadf596', 'cd3e5a8a-d94f-58a0-8c6f-8838b820e67a', 'ef679ede-b207-51a6-b679-e6d7ec83f53a', '3e6d1a0e-ebba-5662-9b50-235bc8111b80', '051afec1-27e6-5b01-a35c-113fd8d1d9cc', '940021d7-b5b4-5449-83ea-ce2fbc279ff3', 'd645eccd-a5d0-5aeb-9284-79aab3b2de20', '4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '07e8045b-b474-56cb-88ee-a5cc0e713ffa', 'cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '1e3fc6c2-7f49-579a-9766-20a7860eca17', '308d579a-062a-5895-abfd-e1a05a0356de', 'c19c1f96-69fa-5f06-a875-55bcfda850ce', '98016972-94e1-5f90-9b1e-f59b43d6b0ae', '851ee672-a02e-5b39-85ab-663ccff5fccd', '78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '67a0c11d-ab91-59df-b1f1-e411d1e2cb95', 'b8697075-71ce-56a1-987c-a1f9cc79846a', '6d3ba807-5296-5b3b-b100-06baba0b4726', 'de3152a5-2625-51bc-97a3-b2ee29cbb5a6', 'cb5483c3-b3c7-58be-8735-6e1c7d30764b', 'a600da65-51d7-52b5-aa7f-11fa86b62d26', '7a99cc03-d6f9-52f4-bdc4-9f531267885c', '52a2766e-fcf5-56ae-8559-494d2b9907ec', '7b544c55-62e7-53a6-8c54-030638b09322', 'b0d6bad5-c558-5387-b3c9-4a8b167cc412', '348dc8e4-92e9-52f8-a85a-8fc5dfb3dfdb', 'b356e2bc-7641-5bd1-973a-cf751b424915', '27b8f517-f017-58a8-a0a8-0e44ba9ca0cd', '4a4ba085-73fa-5f77-bfdc-a81caab9b51e', '75e4d82d-47e0-5432-b840-67558c7322b8', '9fec6335-9472-5469-846a-75981fedeba3', '19564ab9-63a3-530c-a139-4913f70fcd20', '783bb08e-d6a7-5d72-ae16-851a5e696425', '96225451-0ff2-5e30-ab72-ea01d8573838', 'ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', 'c3e2ab45-089e-5a99-b92a-87cbb5576dde', '36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', 'fde829bd-4a35-5b7a-980b-d9373c4bb855', '6d7569dc-adcd-5490-8ab4-9e1252876fbc', '3b271bbf-7019-55aa-93bb-583c3fbb407a', '332e1995-cf27-5529-9e9c-87c94efb4982', '4c1cd36e-d806-5894-a665-34368ab1f4bc', '6abd4b21-6d1c-51e3-9607-d615dae991a3', '3d1e84a5-a743-5748-b970-cc7eda950ebc', 'f22c973f-b551-5ada-b930-ce0801010307', '47c9ba09-be77-5e69-9af8-8b89d56d6402', '6bb46e0f-1ca3-5dfc-bab0-c7a2e1f611e3', '1061e3a4-4d8c-545b-a98c-2dd987472eaa', '8a6d6d54-fab2-5da9-b165-6880b7d6dfde', '769e9ea5-33a5-5482-b19c-3ff5205cac01', '4357bc16-e6fd-5663-8d0e-ac9d2bfafdea', 'bf62eaa6-0c73-5b2a-8820-7237bce83c21', 'a7973a25-f7ad-54f7-889a-fb32afb22a8c', 'c1c02ada-a91d-5c2a-9dcf-707291fa4620', '0cfc8ea9-1e3c-5004-8105-4860681f369f', '260c5f3f-a766-5a3e-a740-dd0f00f33d3d', '23cc5062-223d-5494-94eb-9830da75d3e0', '6d1bf493-f6d4-5de2-8d8f-4e728127758b', 'd54d5b3a-c34c-5314-8b03-d3350d485dcd', '633f9e2a-6695-5ff9-b6f6-934cbe3e687f', '0a8d594c-bdec-5df8-a62e-51a618c211c4', 'e076c07d-7d92-5511-a4ab-c5711a2c73cd', 'c124cc25-0734-5a92-811e-669baf60fa4b', 'a365e428-06ba-5c4e-b3fb-3b1eb755b102', '69045ed1-0311-55cc-a9d1-5ff08b74073c', '103b3b98-c5ec-5850-b280-83a2c4488045', 'b56fc225-0884-57fe-9604-a5f47069571c', 'eed4181b-dcbb-5ee2-b6e2-44685205a62e', 'd53a306c-aa47-55c3-b52a-3b76f508e771', '789d8fb4-ef9b-57a5-971b-67821be37f1a', '927e93ec-4461-53b5-9378-38ef71fbb9b2', '03c3a61a-f9aa-5183-a4e0-994f72750e44', '7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'b4beed3e-de76-5a9d-b807-84d386df921d', '1de99ec2-2a17-58f7-9114-ec649edef3b9', 'b262a7f4-2c4a-5516-b86f-a4364a2f19cd', 'bf2f5e39-a69b-57db-bf3b-7ad4944e8af1', '743f0cfa-5ea6-5f79-b14e-37765de428fd', '17aa026e-8a88-58d5-a5c0-affd7e4f59da', '31d88445-55ae-5ab5-a019-4e8421185606', '70cae8ac-91e9-5ebd-8a9e-99137922c50e', '90a52a14-dddc-5c1f-9ae2-e046a6a3bf36', '89272a98-c361-59d6-9769-0f446eec2791', '84cc4ad9-5b0a-5abf-94ac-0ef213a39e00', '7fed4144-3d84-5e12-9241-90c61b17bc16', 'e6d69941-cc45-5d67-a596-939ffc03da9f', '860343a5-fe3b-56a4-943f-74ea5732b0ef', '6f9f38b1-0cf8-50cf-97b9-f7484f39aac2', 'f7705088-66ed-5e8d-b23e-63a1f2eb6260', '6d2559a3-989d-53df-8054-651a6ed1b9f6', '358f2069-51cf-5a2a-be86-9b7f5e9ef89a', '6d3e559b-0449-57de-89b2-0ff23b9fd893', 'f2f3c849-25e9-53d0-b09e-4eff720714b2', '3ee10a83-a4d9-5855-bb7d-79425521b890', '2329c69b-07a0-5905-8d3b-82a269887104', '815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'a2241625-9fa9-504f-841d-0b346289ca00', '1b86b32d-c59d-5d28-a86e-a87b3cd41919', '3fadd44b-aca0-5ece-b1a4-02766d4517e3', 'cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '83dfacbc-3c11-55bf-ad09-cc214abb3711', '1f4296d8-c07e-5e6d-b599-0022c8f72118', '3a935e4d-91f9-59c5-aed2-fbaedff745b6', '8c70b94d-f217-58bc-a0a0-0bf5cc8d027c', 'f07596c5-b4cf-56a0-aedb-85e25a439600', 'b188b3ad-3e88-5b36-9912-e9150f3c8998', '3e79728f-c65b-539a-a096-2ed061f3addd', '508d24d2-5250-505a-a83b-7c7c80b29b95', '3476945b-e660-5149-b6af-990f68a221c7', 'fa4da252-76b0-5bbe-8764-979312b45f75', '0a29a5f8-19d1-5d00-8acd-762144ca1245', '76b6593e-ee1c-5a91-b24e-e0d073a5bebb', '1cfec379-8300-5b53-b683-971a9cb396c4', '33967eca-c9b5-5f4f-84e3-9519064494aa', '9c6a44dd-b158-5d39-8636-2da68a6b6d9c', 'a07afd33-a11b-52b9-b5ba-343427b0bc84', 'dbd55b7e-bb3e-5706-9186-e833923ce87d', '5aeed1da-a9ed-53f3-9f19-b9f22a1abc0d', '33b4e382-cde8-5e40-8398-c5e311c1ccf4', 'd6e6c9bc-90d2-5532-9fcf-52ddef7681b1', 'e91167fb-6b84-515a-9848-d07949d71c90', '28997c99-1b74-5330-8272-d08f4682b8c8', 'ee97c631-820f-50c1-9de3-58f140893afa', '5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '676a25e8-1769-5b86-945f-06f2bf2d8548', 'cc3b9212-5768-5113-ad7b-2ba9128d740f', '0b03e40f-b428-588f-8ccc-c9431e9e0fda', 'ba963d3c-68cf-5c49-b62e-344049caab0e', 'c394033c-66d8-548c-951c-5472f4c41c30', 'efa163b4-a341-5c43-9bfb-142a7b277fa7', 'a467a610-6abe-5eac-ba05-83a1fa8608f7', '1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', 'e67df23c-e9ee-54fe-b2ab-bc1529b38436', '2a0919b3-712a-5d61-91f9-2a023e33b085', '3d69fe82-436d-59e4-96c0-9dbabc7728e9', '28178fc6-48da-5f7a-833e-d9fe334c8358', '10762f40-915a-5ccf-8f2a-9532db6b3023', 'eb19b45f-4918-50fc-afa4-47655504df12', 'bdad7adc-e019-5996-a87e-6409a86248d0', 'dae86223-f3ac-578b-8d7c-9dcbb14108e1', '070508f4-ab03-5873-a546-2d8e0bf52886', '8442fd5f-a8a3-5bd8-a9cd-488177b76852', '550725f1-73d7-513e-956b-cabad8c09180', '1fc3ea14-1df5-5242-b3f3-b309c23e2746', '5f8ad45d-b161-562e-b38c-3524e78b7214', '26d2e999-0836-52ea-beac-d55e58bce05d', 'ca5f29a5-a523-5a3a-b6b2-f40db9ee0548', 'f43f9ef9-486d-5151-9ec5-2c5f7ad19738', '0adce953-7057-5641-b1cb-337665f8da31', 'b7b276c1-df61-5015-a396-ac06265465c7', '1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', '120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'e29bdbfe-677e-5173-8a30-dc1ddc813fe8', '9e3d2494-fea2-5244-b1a6-622c5560913b', 'a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', '5e344432-2f71-56d6-abf1-5c8c31d537c9', '24a82297-67c0-5306-9121-6efc815a919e', '9bfeec0f-5f54-5365-9c20-356635d68e1c', '73d9a740-8761-50f2-a74c-f66483150482', 'a08dc674-1ad0-5709-ac2a-91fb09b03e23', '1a654666-d0cf-5a81-9244-aad9397d5ddb', '7f3ed481-20e3-5434-bc4b-65cadb9635ea', 'a19b37f7-b80e-5ae9-bbcf-129d2677cdb6', 'f5ce42e1-de4b-5b66-b8a0-880ca8b71616', '1665f4a2-f2d4-5b90-a73f-cfd8ebc25d82', 'aca78fb2-be94-515e-93e9-07de78b76084', 'fe2204e3-3db5-5b36-9d8c-58bb455001d2', '7c5c580c-f674-5b9e-a61a-fa3b441de12e', '53bfe9eb-7729-5bb4-8122-c4019895f276', 'acd5d4f4-3238-5d8b-8c16-1ba4346feb72', '30e3f6ac-866e-5a8e-8102-b6096ae5e4e5', 'c2cd69bc-3db3-5827-8a83-57bcf033de86', 'fe6bf775-0956-5d95-956d-e49d795a9617', 'ee69c6c1-c5df-5cd9-9da9-046389fb356f', 'd5881556-ec1e-57f7-9dde-d113d29c8710', '17071935-7310-51c2-a8d6-00bbac4c3e23', '72632bce-eb90-5864-8b0a-fd10908fafe1', 'e4bf56ff-2ae1-5126-9019-5800347aa34a', '1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '00a19639-3883-5d3c-8924-c94faf49d549', 'db7ecffa-12db-5ebe-a71f-0b59145133eb', '4032fad4-617f-58e6-b390-53e4b2c6c1c6', '61ccedd3-9052-5b32-ab73-cd1879d56ae7', '6cc0e08b-af9c-5dce-b02f-5bd6587bd103', 'ed57c56c-2714-58cf-b436-afc5b1f0fb55', 'a704ca25-4e84-5194-ae74-d707994df17e', '3088ed38-3f25-5167-aa73-a51d2fb61486', '16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '64e55faa-0a53-52af-8b05-97dd07023788', '29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb', 'ef5d7171-95a0-578b-bc28-53b6fe14dad2', '588ccf1f-d83f-5cb6-91a3-1d26330db329', 'e33bc694-7409-5ed9-b465-5dafa064edd3', 'd023279e-7134-5bd4-becb-6322f8306d5f', 'ff0ae26c-d6d6-5f50-ba1c-9976a19069be', '9c7803ee-0d85-57e7-ba51-8abe476a5058', '04989013-8b32-54af-9f7c-bfda1f5b94c3', 'b78c3fb5-fcde-5273-a96f-d92327df9696', '3cc97403-7633-5b14-a33a-bbaf609673fe', '1ef3f634-b2aa-5389-83a4-70599facfb28', '16c1a42e-8fb9-5626-bedc-2fe32244e119', '6c9ed809-1bc2-594e-8afc-b4b3607537a4', '88c1f48a-2a35-5d6c-874a-6cec41778111', '077020c3-a4f1-5622-8cb0-aec77f757230', 'cda55e3c-d0ae-5f6b-a367-0665f55d4452', '67dff524-0781-58b6-8b30-fd200e7d0b94', '6037748e-1848-57f4-913d-e039fdf1f606', '6164593c-8c3a-5c0b-ac23-a2fc17bfa4b2', 'da81e1c3-f253-583b-99f4-a6da7ad2cc84', '5e019169-bdbe-5788-9b5e-13db4ae7b22f', 'b72b8ada-ccf2-5bf3-9765-42edf26bab42', '6f1c8665-d1c0-5ed3-8519-bcfa7acab159', '848ed66c-2d55-5f47-8712-32262aa46735', 'f8aae127-a29c-5649-b8cf-3904e0c38fae', 'c1c1ffd4-400a-594b-9408-521f081076f6', '63482caa-22d4-592a-b78f-a4be32dfe9ed', '0714313c-d0bd-5997-af4d-ff5c4c6ef2fa', 'a849745d-22e2-5d25-a391-5993cf4a12b9', 'ae6d3414-72ac-5ec1-8a0d-2a2bafdfdbfb', 'a381c43d-3ee3-5596-8c42-6530377c5810', '99c7d327-4658-5405-81d2-3c44b00ce441', '48881931-78d7-5e4a-a742-a3d4d7e8ef95', 'cc114016-dacc-5dd5-87e4-6b7b5f2af178', 'ab06e97b-51fd-59b0-a4d9-cde2df12c486', '2c4105f3-590a-55c7-80ce-95b8f1d62296', '4d77f78a-4ba0-56fd-9efc-bdc72e22fd0f', 'db658899-ea60-5a21-978d-2adcde0df690', 'c73cdfba-e320-5ce3-a0ba-eec42fb6c3ac', 'b85ff5e5-4e6e-50d5-ac36-f62c86ac135f', '4bcfa2d5-699a-5915-9ed7-a5fdf50ee301', '7718a410-1ad0-557d-b059-869541cb0241', '996c1e06-7a10-5972-bd28-3db55e8234bd', '1b0196a9-14d1-53f3-8931-9f5b3bed0f57', '390010fb-85c6-5acf-973f-8c390cce218d', '533df0ee-78f7-57bc-8a57-dd9eab28fed3', '3546773d-9c4c-56d2-8943-39401375c3fb', '7870668f-8f7e-5437-9372-0c3b6dce796b', '7d312960-34cc-5bc3-9b68-afcd570ad6e3', 'a6f3d8bc-773e-5241-9dfc-c92258736bc4', 'ee955f83-405f-51c7-8fca-9267645d771e', '8454304f-896c-57e2-9d6c-9404795453d2', '7e701876-a9d1-514d-848b-7567488fc2d4', '3d0f128d-cdce-5d9d-997c-047d2da2e2bc', 'c6e0e1ee-d878-5008-8460-52fdbcdb11a2', '9d520596-be86-5bf9-9986-236f642e3ee5', '3861e039-b9dc-5a7f-a1f7-4ade27282a2c', '11b23003-7011-5d40-98b3-7061425c7315', '69d3b8fa-3457-5297-82c9-f50c644c0a4e', 'd561c284-fe77-5304-8add-50b795fa84bc', 'e00b002a-d567-56b1-b788-173342c1ee53', '004290f5-18df-5e0f-9504-ef5bc050a921', '0bb3b44d-55e9-58ca-885b-33843190e4c5', '91ed9dac-19cb-5076-a268-295420d3a3e8', 'feb5008a-c62f-50e4-96c1-ef21827d5d14', '68e457c7-1d2e-5612-b531-d79d2acf9d4d', 'f36ef462-d7e1-59ac-a84b-4393c5c8ccda', '62e98c7b-be98-5da5-8c08-91d360b2614e', '820ea5b8-ff8b-55ea-8289-b9b0b85999b6', 'de91684c-3e02-5bff-8675-478d9fd09ccf', 'afa723fa-bea9-571b-a885-97d7cef1e780', 'a1919ea5-25b0-53d3-86b7-f818b632d084', 'a1faf598-b829-53af-92cf-50f1ecdd875f', 'e70e2c64-52ce-5e05-9fd2-3ddb7237d2ad', 'd1be344e-f76b-520e-b29a-16a7eeca0cda', '8dd987cc-488a-5181-95cc-a03f05f04878', '63895d39-b503-5006-ad86-24e4f220feef');
DELETE FROM public.chapters c WHERE c.subject_id = 'french' AND c.id NOT IN ('5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', '383392ce-53c3-5d10-b090-6f6f48124bee', '7dfc8206-be90-514b-9490-54149fa1f43d', '468647c4-f2b2-521f-a02c-d2d52d4c49b1') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', 'Les types et les formes de phrases', 'Les quatre types de phrases et les formes (affirmative/négative, active/passive, neutre/emphatique)', '# ⚔️ Les types et les formes de phrases

> 💡 « Maîtriser la phrase, c''est choisir l''arme exacte pour chaque intention : informer, questionner, ordonner ou s''exclamer. »

## 🏰 Les quatre types de phrases

Toute phrase appartient à **un seul** type, selon l''intention de celui qui parle.

| Type                  | Intention                   | Ponctuation | Exemple                     |
| --------------------- | --------------------------- | ----------- | --------------------------- |
| Déclaratif            | informer, raconter          | .           | Le héros franchit la porte. |
| Interrogatif          | poser une question          | ?           | Qui franchit la porte ?     |
| Impératif (injonctif) | donner un ordre, un conseil | . ou !      | Franchis la porte !         |
| Exclamatif            | exprimer une émotion        | !           | Quelle porte immense !      |

> 🗡️ La phrase **impérative** n''a pas de sujet exprimé : le verbe est à l''impératif (« Avance. », « Écoutons. »).

## ⚡ La phrase interrogative

On distingue deux constructions :

- **Interrogation totale** : la réponse est _oui / non_.
  _Viens-tu ? / Est-ce que tu viens ? / Tu viens ?_
- **Interrogation partielle** : elle porte sur un élément précis et utilise un mot interrogatif (_qui, que, où, quand, comment, pourquoi, combien_).
  _Où vas-tu ?_

L''**inversion du sujet** (_Viens-tu ?_) appartient au registre soutenu ; _est-ce que_ au registre courant.

## 🛡️ Les formes de la phrase

À son type, chaque phrase combine plusieurs **formes** :

### Forme affirmative / négative

- Affirmative : _Le dragon dort._
- Négative : _Le dragon **ne** dort **pas**._ (négation en deux mots : _ne… pas, ne… jamais, ne… plus, ne… rien_)

### Forme active / passive

- Active : _Le chevalier ouvre la porte._
- Passive : _La porte **est ouverte** par le chevalier._

### Forme neutre / emphatique

La forme **emphatique** met un élément en relief :

- par un présentatif : **\*C''est** le chevalier **qui** ouvre la porte.\*
- par un détachement : _Le chevalier, **il** ouvre la porte._

## 📐 Type et formes se combinent

Une même phrase a **un type** et **plusieurs formes** en même temps :

> _« N''avance pas ! »_ → type **impératif**, forme **négative**.
> _« Est-ce que cette porte n''est pas ouverte par le gardien ? »_ → type **interrogatif**, formes **négative** et **passive**.

## 🧪 Méthode : reconnaître une phrase

1. Je regarde la **ponctuation finale** et l''**intention** → je trouve le **type**.
2. Je cherche la **négation**, le verbe **passif**, l''**emphase** → je trouve les **formes**.

> 🏆 Tu sais maintenant identifier et transformer toute phrase : c''est la base de la grammaire et de la production écrite.', '# 📜 Résumé : Les types et les formes de phrases

- **4 types** (selon l''intention) : déclaratif (.), interrogatif (?), impératif/injonctif (. ou !), exclamatif (!).
- L''impératif n''a **pas de sujet exprimé**.
- **Interrogation** : totale (réponse oui/non) ou partielle (mot interrogatif : qui, où, quand, comment…). Inversion = soutenu ; _est-ce que_ = courant.
- **Formes** (cumulables) : affirmative / **négative** (ne… pas/jamais/plus/rien) ; active / **passive** (être + participe passé + _par_) ; neutre / **emphatique** (c''est… qui / détachement).
- Une phrase a **un seul type** mais **plusieurs formes** à la fois.
- Méthode : ponctuation + intention ⇒ type ; négation/passif/emphase ⇒ formes.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', 'Les propositions subordonnées', 'Proposition principale vs subordonnée et le subordonnant ; subordonnées relatives, complétives et circonstancielles avec leurs conjonctions.', '# ⚔️ Les propositions subordonnées

> 💡 « Comprendre la subordination, c''est apprendre à tisser des phrases complexes — l''arme secrète d''un guerrier de l''écrit. »

## 🏰 Proposition principale et proposition subordonnée

Une **phrase complexe** contient au moins deux propositions. La **proposition principale** (PP) est autonome : elle a un sens complet. La **proposition subordonnée** (PS) dépend de la principale ; elle ne peut pas se lire seule sans perdre son sens.

| Rôle        | Définition                                             | Exemple               |
| ----------- | ------------------------------------------------------ | --------------------- |
| Principale  | Proposition autonome, chef de la phrase                | _Je sais_ …           |
| Subordonnée | Proposition dépendante, introduite par un subordonnant | … _que tu réussiras._ |

Le **subordonnant** (conjonction de subordination, pronom relatif, etc.) est le mot qui relie la subordonnée à la principale et en indique la nature.

> 🗡️ Pour trouver la principale, supprime la subordonnée : la phrase qui reste a encore un sens = c''est la principale.

## ⚡ La subordonnée relative

La subordonnée relative **qualifie un nom** (ou un pronom) appelé **antécédent**. Elle est introduite par un **pronom relatif** :

| Pronom relatif | Fonction dans la subordonnée   | Exemple                                        |
| -------------- | ------------------------------ | ---------------------------------------------- |
| **qui**        | sujet                          | Le héros _qui combat_ le dragon est courageux. |
| **que / qu''**  | COD                            | Le livre _que tu lis_ est passionnant.         |
| **dont**       | complément (de, du, des…)      | L''épée _dont il se sert_ est magique.          |
| **où**         | complément de lieu ou de temps | La forêt _où il entra_ était sombre.           |

> 🛡️ **Astuce** : « dont » remplace toujours un groupe introduit par _de_ : _il se sert de l''épée_ → l''épée _dont_ il se sert.

### Accord du participe passé avec « que »

Quand la relative contient un verbe à un temps composé avec _avoir_, le participe passé s''accorde avec l''antécédent de _que_ :

- _Les batailles **que** nous avons **livrées**._ (féminin pluriel)

## 🛡️ La subordonnée complétive (conjonctive en « que »)

La subordonnée complétive est **COD du verbe principal**. Elle est introduite par la conjonction de subordination **que** (qu''). On peut souvent la remplacer par un groupe nominal ou le pronom _cela_.

- _Je crois **que le héros vaincra**._ → _Je crois cela._
- Verbes introducteurs fréquents : _dire, penser, croire, savoir, espérer, vouloir, sentir, voir, comprendre…_

> 💡 La complétive répond à la question « quoi ? » posée après le verbe principal.

## 🧪 Les subordonnées circonstancielles

Les subordonnées **circonstancielles** indiquent les circonstances de l''action principale (temps, cause, conséquence…). Chaque type a ses conjonctions propres.

### ⏱️ La subordonnée de temps

Elle indique _quand_ se déroule l''action principale.

| Conjonction                  | Nuance                     | Exemple                                       |
| ---------------------------- | -------------------------- | --------------------------------------------- |
| **quand / lorsque**          | simultanéité, postériorité | _Quand le soleil se lève_, le héros part.     |
| **avant que** (+ subjonctif) | antériorité                | _Avant qu''il parte_, elle lui remet l''épée.   |
| **après que** (+ indicatif)  | postériorité               | _Après qu''il eut vaincu_, la foule l''acclama. |
| **dès que / aussitôt que**   | simultanéité immédiate     | _Dès qu''il arriva_, le combat commença.       |
| **pendant que / tandis que** | simultanéité               | _Pendant qu''il dort_, les ennemis avancent.   |

### 🔥 La subordonnée de cause

Elle explique _pourquoi_ se produit l''action principale.

- **parce que** : cause directe — _Il a gagné **parce qu''il s''était entraîné**._
- **puisque** : cause connue des deux interlocuteurs — _**Puisque tu es là**, commençons._
- **comme** (en tête de phrase) : cause — _**Comme il pleuvait**, il prit son bouclier._

### 💥 La subordonnée de conséquence

Elle exprime _le résultat_ de l''action principale.

- **si bien que / de sorte que** (+ indicatif) — _Il s''entraîna si bien **que nul ne pouvait le battre**._
- **tellement… que / si… que** — _Il était **tellement** rapide **qu''on ne le voyait pas**._

### 🎯 La subordonnée de but

Elle exprime l''objectif visé. Toujours au **subjonctif**.

- **pour que / afin que** — _Il s''entraîne **pour que** son équipe **gagne**._
- **de peur que** (+ subjonctif + _ne_ explétif) — _Elle chuchote **de peur qu''on ne l''entende**._

### 🌀 La subordonnée de condition (hypothèse)

Elle pose une condition dont dépend la réalisation de l''action principale.

| Conjonction         | Mode et temps                                           | Exemple                                         |
| ------------------- | ------------------------------------------------------- | ----------------------------------------------- |
| **si**              | présent → futur (réel)                                  | _Si tu t''entraînes_, tu **vaincras**.           |
| **si**              | imparfait → conditionnel présent (éventuel)             | _Si tu t''entraînais_, tu **vaincrais**.         |
| **si**              | plus-que-parfait → conditionnel passé (irréel du passé) | _Si tu t''étais entraîné_, tu **aurais vaincu**. |
| **à condition que** | subjonctif                                              | _Il part **à condition que** tu **viennes**._   |

> 🗡️ Attention : après **si** de condition, on n''emploie jamais le futur ni le conditionnel.

### 🌿 La subordonnée de concession (opposition)

Elle exprime un fait qui devrait empêcher l''action principale, mais ne le fait pas.

- **bien que / quoique** (+ **subjonctif**) — _**Bien qu''il soit blessé**, il continue de combattre._
- **même si** (+ indicatif) — _**Même s''il pleut**, il partira._

## 📐 Tableau récapitulatif des circonstancielles

| Type        | Conjonctions principales                      | Mode habituel     |
| ----------- | --------------------------------------------- | ----------------- |
| Temps       | quand, lorsque, dès que, avant que, après que | Ind. / Subj.      |
| Cause       | parce que, puisque, comme                     | Indicatif         |
| Conséquence | si bien que, de sorte que, tellement… que     | Indicatif         |
| But         | pour que, afin que, de peur que               | Subjonctif        |
| Condition   | si, à condition que, pourvu que               | Ind. / Subj.      |
| Concession  | bien que, quoique, même si                    | Subj. / Indicatif |

> 🏆 Tu maîtrises maintenant la phrase complexe : principale + subordonnées relative, complétive et circonstancielles. C''est le cœur de la rédaction en 9ème !', '# 📜 Résumé : Les propositions subordonnées

- **Phrase complexe** = proposition principale (autonome) + proposition(s) subordonnée(s) (dépendantes, reliées par un **subordonnant**).
- **Subordonnée relative** : qualifie un antécédent ; pronoms relatifs : **qui** (sujet), **que** (COD), **dont** (compl. de), **où** (lieu/temps). Le participe passé s''accorde avec l''antécédent de _que_.
- **Subordonnée complétive** : COD du verbe principal, introduite par **que** ; remplaçable par _cela_.
- **Subordonnées circonstancielles** (indiquent les circonstances) :
  - **Temps** : _quand, lorsque, dès que, avant que_ (subj.), _après que_ (ind.)
  - **Cause** : _parce que, puisque, comme_ → indicatif
  - **Conséquence** : _si bien que, tellement… que_ → indicatif
  - **But** : _pour que, afin que_ → **subjonctif**
  - **Condition** : _si_ + présent/imparfait/plus-que-parfait (jamais futur ni conditionnel après _si_)
  - **Concession** : _bien que, quoique_ → **subjonctif** ; _même si_ → indicatif', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', 'La voix active et la voix passive', 'Définition des voix active et passive, règles de transformation, conservation des temps, complément d''agent et intérêt stylistique.', '# ⚔️ La voix active et la voix passive

> 💡 « Choisir entre la voix active et la voix passive, c''est décider qui prend la lumière : le héros qui agit, ou la cible qui subit l''action. »

## 🏰 Définitions : voix active et voix passive

Tout verbe d''action transitif peut être employé à deux **voix** :

| Voix        | Qui fait l''action ?     | Structure du GV                         | Exemple                                  |
| ----------- | ----------------------- | --------------------------------------- | ---------------------------------------- |
| **Active**  | Le sujet agit lui-même  | verbe conjugué normalement              | _Le chevalier frappe le dragon._         |
| **Passive** | Le sujet subit l''action | **être** conjugué + **participe passé** | _Le dragon est frappé par le chevalier._ |

> 🗡️ Seuls les verbes **transitifs directs** (qui ont un COD) peuvent se mettre à la voix passive. _Dormir_, _partir_, _ressembler à_ ne se mettent pas au passif.

## ⚡ La transformation active → passive

La règle en trois étapes :

1. Le **COD** de la phrase active devient le **sujet** de la phrase passive.
2. Le **sujet** de la phrase active devient le **complément d''agent** (introduit par **par** ou parfois **de**).
3. Le verbe est remplacé par **être (conjugué au même temps) + participe passé (accordé avec le nouveau sujet)**.

**Exemple au présent :**

- Active : _Le maître corrige **les copies**._
  - COD = « les copies » → nouveau sujet
  - Sujet = « le maître » → complément d''agent
- Passive : _**Les copies** sont corrigées **par le maître**._

> 🛡️ Le participe passé s''accorde **toujours** en genre et en nombre avec le sujet du verbe passif (nouveau sujet = ancien COD).

## 🛡️ La conservation du temps

Le temps du verbe ne change pas lors de la transformation. C''est le verbe **être** qui prend le temps de la phrase active :

| Temps de la phrase active | Forme passive correspondante    | Exemple                                    |
| ------------------------- | ------------------------------- | ------------------------------------------ |
| Présent                   | être au présent + p.p.          | _Le dragon est vaincu par le héros._       |
| Imparfait                 | être à l''imparfait + p.p.       | _Le dragon était vaincu par le héros._     |
| Passé composé             | être au passé composé + p.p.    | _Le dragon a été vaincu par le héros._     |
| Passé simple              | être au passé simple + p.p.     | _Le dragon fut vaincu par le héros._       |
| Plus-que-parfait          | être au plus-que-parfait + p.p. | _Le dragon avait été vaincu par le héros._ |
| Futur simple              | être au futur simple + p.p.     | _Le dragon sera vaincu par le héros._      |
| Conditionnel présent      | être au cond. présent + p.p.    | _Le dragon serait vaincu par le héros._    |

> 💡 Au passé composé et au plus-que-parfait passifs, l''auxiliaire est **avoir** pour conjuguer **être** : _a été_, _avait été_.

## 🧪 Le complément d''agent

Le **complément d''agent** désigne celui qui accomplit l''action dans une phrase passive. Il est introduit par :

- **par** : dans la majorité des cas — _détruite **par** l''armée_
- **de** : avec certains verbes d''état ou de sentiment (_aimé de tous_, _entouré de ses amis_, _connu de tout le village_)

### Quand le complément d''agent est absent

Il arrive que la phrase passive **n''ait pas de complément d''agent** : on ne sait pas (ou on ne veut pas dire) qui fait l''action.

- _La ville a été détruite._ (on ne précise pas qui a détruit)
- _Ce texte est souvent lu._ (le lecteur reste indéfini)

> 🗡️ L''absence de complément d''agent est fréquente quand l''agent est inconnu, sans importance ou volontairement tu.

## 📐 La transformation passive → active

Pour revenir à la voix active, on inverse les étapes :

1. Le **sujet** de la phrase passive devient le **COD**.
2. Le **complément d''agent** devient le **sujet**.
3. On remplace **être + p.p.** par le verbe conjugué au même temps.

**Exemple :**

- Passive : _La porte a été fermée par la sentinelle._
- Active : _La sentinelle a fermé la porte._

> ⚠️ Si la phrase passive n''a pas de complément d''agent, on utilise le sujet indéfini **on** à la voix active : _La porte a été fermée._ → _**On** a fermé la porte._

## 🌟 L''intérêt stylistique de la voix passive

Le choix entre voix active et voix passive n''est pas neutre : il sert à mettre en valeur l''information que l''on juge la plus importante.

- **Voix active** : met en avant **celui qui agit** (le sujet-agent).
  _Le journaliste révèle la vérité._ → l''accent est sur le journaliste.

- **Voix passive** : met en avant **celui qui subit** (l''objet devenu sujet).
  _La vérité est révélée par le journaliste._ → l''accent est sur la vérité.

- **Voix passive sans agent** : utile pour **dépersonnaliser** ou **présenter un fait général**.
  _Les règles doivent être respectées._ → peu importe qui respecte.

> 🏆 Tu connais maintenant les deux voix : active pour mettre l''agent au premier plan, passive pour mettre la cible en lumière. Maîtriser ce choix, c''est maîtriser le style !

## 🧩 Récapitulatif visuel

| Élément            | Voix active               | Voix passive                       |
| ------------------ | ------------------------- | ---------------------------------- |
| Sujet              | Fait l''action (agent)     | Subit l''action (patient)           |
| Verbe              | Conjugué normalement      | **être** + participe passé accordé |
| Complément d''agent | Absent (c''est le sujet)   | Introduit par **par** ou **de**    |
| Accord du p.p.     | Avec le COD (règle avoir) | Avec le sujet (toujours)           |', '# 📜 Résumé : La voix active et la voix passive

- **Voix active** : le sujet fait l''action — _Le héros frappe le dragon._
- **Voix passive** : le sujet subit l''action — structure **être (conjugué) + participe passé accordé** — _Le dragon est frappé par le héros._
- Seuls les verbes **transitifs directs** (avec un COD) peuvent se mettre au passif.
- **Transformation active → passive** : COD → sujet ; sujet → complément d''agent (par/de) ; même temps du verbe (porté par être).
- Le **participe passé s''accorde** toujours en genre et en nombre avec le sujet du verbe passif.
- **Complément d''agent** : introduit par **par** (cas général) ou **de** (verbes d''état/sentiment). Il peut être **absent** (agent inconnu ou tu → on à la voix active).
- **Intérêt stylistique** : la voix active met l''agent en avant ; la voix passive met la cible en avant ou dépersonnalise.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', 'Le discours direct et le discours indirect', 'Rapporter les paroles de quelqu''un : ponctuation du discours direct, passage au discours indirect (subordination, concordance des temps, changements de pronoms et d''indicateurs spatio-temporels) et l''interrogation indirecte.', '# ⚔️ Le discours direct et le discours indirect

> 💡 « Rapporter les paroles d''un autre, c''est une arme rhétorique : maîtrise la transmission pour ne jamais trahir le message. »

## 🏰 Le discours direct — définition et ponctuation

Le **discours direct** reproduit les paroles telles qu''elles ont été prononcées, sans les modifier.

**Signes distinctifs :**

| Signe              | Rôle                                    | Exemple                                  |
| ------------------ | --------------------------------------- | ---------------------------------------- |
| Deux-points ( : )  | annonce les paroles                     | Il dit :                                 |
| Guillemets (« … ») | encadrent les paroles                   | « Je suis prêt. »                        |
| Tiret ( — )        | change d''interlocuteur dans un dialogue | — Où vas-tu ?                            |
| Verbe introducteur | indique qui parle et sur quel ton       | dit, répondit, s''écria, demanda, affirma |

**Exemple de dialogue :**

> Le héros s''écria : « Je vaincrai le dragon ! »
> — Impossible ! répondit le garde. — Je suis le plus fort ! rétorqua le héros.

> 🗡️ Les **verbes introducteurs** les plus courants : _dire, affirmer, répondre, demander, s''écrier, chuchoter, répliquer, annoncer, ajouter, déclarer_.

## ⚡ Le discours indirect — définition et subordination

Le **discours indirect** intègre les paroles dans la phrase principale à l''aide d''une **proposition subordonnée**.

| Type de phrase rapportée    | Outil de subordination            | Exemple                                 |
| --------------------------- | --------------------------------- | --------------------------------------- |
| Phrase déclarative          | **que**                           | Il dit qu''il est prêt.                  |
| Question totale (oui/non)   | **si**                            | Il demande si tu viens.                 |
| Question partielle (mot Q.) | **ce que / ce qui / où / quand…** | Il demande où tu vas. / ce que tu fais. |
| Ordre (impératif)           | **de** + infinitif                | Il lui ordonne de partir.               |

> 🛡️ Attention : après un verbe introducteur à la forme négative ou interrogative, l''outil reste identique — c''est la subordonnée qui change de sens.

## 🧪 Les changements de pronoms personnels

Passer au discours indirect oblige à **adapter les pronoms** selon le contexte :

- **1re personne → 3e personne** (si le narrateur ≠ personnage) :
  - DD : « **Je** suis fatigué. » → DI : Il dit qu''**il** est fatigué.
- **2e personne → 3e personne** (si l''interlocuteur change de rôle) :
  - DD : « **Tu** dois étudier. » → DI : Il lui dit qu''**il** doit étudier.

> ⚡ Règle d''or : relis la phrase au DI pour vérifier qu''on sait toujours **qui** fait l''action et **à qui** on parle.

## 📐 La concordance des temps (changements verbaux)

Quand le verbe introducteur est au **passé**, les temps de la subordonnée changent :

| Discours direct | Discours indirect (verbe introducteur au passé) |
| --------------- | ----------------------------------------------- |
| Présent         | → Imparfait                                     |
| Passé composé   | → Plus-que-parfait                              |
| Futur simple    | → Conditionnel présent                          |
| Futur antérieur | → Conditionnel passé                            |
| Impératif       | → de + infinitif                                |

**Exemples :**

- « Je **travaille**. » → Il dit qu''il **travaillait**.
- « J''**ai fini**. » → Il dit qu''il **avait fini**.
- « Je **viendrai**. » → Il dit qu''il **viendrait**.

> 💡 Si le verbe introducteur est au **présent**, les temps ne changent **pas**.
> _Il dit qu''il **est** fatigué._ (présent → présent)

## 🌐 Les changements d''indicateurs de temps et de lieu

Les expressions de temps et de lieu doivent également s''adapter :

| Discours direct      | Discours indirect               |
| -------------------- | ------------------------------- |
| aujourd''hui          | ce jour-là                      |
| hier                 | la veille                       |
| avant-hier           | l''avant-veille                  |
| demain               | le lendemain                    |
| après-demain         | le surlendemain                 |
| la semaine prochaine | la semaine suivante             |
| la semaine dernière  | la semaine précédente / d''avant |
| maintenant           | alors / à ce moment-là          |
| ici                  | là / là-bas                     |
| ce matin / ce soir   | ce matin-là / ce soir-là        |

**Exemple :**

- DD : « **Demain**, nous partons **ici**. »
- DI : Il annonça que **le lendemain**, ils partiraient **là**.

## 🔎 L''interrogation indirecte

Transformer une **question directe** en question indirecte :

- La phrase perd le **point d''interrogation**.
- Pas d''inversion du sujet après le mot interrogatif.
- On utilise les outils : **si** (question totale), **ce qui / ce que / où / quand / comment / pourquoi / combien** (questions partielles).

| Question directe             | Question indirecte                   |
| ---------------------------- | ------------------------------------ |
| « Viens-tu ? »               | Il demande **si** tu viens.          |
| « Qu''est-ce que tu fais ? »  | Il demande **ce que** tu fais.       |
| « Qu''est-ce qui se passe ? » | Il demande **ce qui** se passe.      |
| « Où vas-tu ? »              | Il demande **où** tu vas.            |
| « Pourquoi pleure-t-il ? »   | Il demande **pourquoi** il pleure.   |
| « Comment s''appelle-t-il ? » | Il demande **comment** il s''appelle. |

> 🗡️ Attention à « qu''est-ce que » → **ce que** et « qu''est-ce qui » → **ce qui** : ne jamais garder « est-ce que » au discours indirect.

## 🏆 Méthode : passer du DD au DI en 4 étapes

1. **Repère** le verbe introducteur et son temps.
2. **Choisis** l''outil de subordination selon le type de phrase rapportée.
3. **Adapte** les pronoms personnels (qui parle ? à qui ?).
4. **Applique** la concordance des temps et change les indicateurs de temps/lieu si nécessaire.

> 🏆 En maîtrisant ces quatre étapes, tu transformes n''importe quelle parole rapportée sans faute. C''est la compétence clé de la production écrite au niveau 9ème !', '# 📜 Résumé : Le discours direct et le discours indirect

- **Discours direct (DD)** : paroles reproduites telles quelles — annoncées par un verbe introducteur, encadrées par des guillemets « … » ou introduites par un tiret (—) dans un dialogue.
- **Verbes introducteurs** courants : _dire, affirmer, demander, répondre, s''écrier, ordonner, chuchoter_.
- **Passage au DI** : on intègre les paroles dans une subordonnée introduite par :
  - **que** → phrase déclarative
  - **si** → question totale (oui/non)
  - **ce que / ce qui / où / quand / comment / pourquoi / combien** → question partielle
  - **de + infinitif** → ordre (impératif)
- **Changements de pronoms** : adapter selon qui parle et à qui (souvent 1re/2e personne → 3e personne).
- **Concordance des temps** (verbe introducteur au passé) :
  - présent → imparfait
  - passé composé → plus-que-parfait
  - futur simple → conditionnel présent
  - impératif → de + infinitif
- **Indicateurs de temps/lieu** : aujourd''hui → ce jour-là ; demain → le lendemain ; hier → la veille ; ici → là ; maintenant → alors.
- **Interrogation indirecte** : pas de point d''interrogation, pas d''inversion du sujet ; « qu''est-ce que » → ce que ; « qu''est-ce qui » → ce qui.
- Méthode en 4 étapes : verbe introducteur → outil de subordination → pronoms → temps et indicateurs.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', 'Les modes et les temps verbaux', 'Les modes personnels (indicatif, subjonctif, conditionnel, impératif) et leurs valeurs ; les principaux temps de l''indicatif et leurs emplois ; le subjonctif présent et le conditionnel présent ; distinction temps simples / temps composés.', '# ⚔️ Les modes et les temps verbaux

> 💡 « Le verbe est le cœur de la phrase : choisir le bon mode et le bon temps, c''est donner à tes mots leur pleine puissance. »

## 🏰 Les modes personnels — vue d''ensemble

Un **mode** exprime la manière dont le locuteur envisage l''action. Les modes **personnels** se conjuguent avec un sujet.

| Mode         | Valeur principale                            | Exemple                    |
| ------------ | -------------------------------------------- | -------------------------- |
| Indicatif    | fait réel, certain ou daté                   | Il part. / Il partira.     |
| Subjonctif   | fait envisagé, souhaité, douteux             | Il faut qu''il parte.       |
| Conditionnel | fait soumis à une condition, hypothèse, poli | Il partirait s''il pouvait. |
| Impératif    | ordre, conseil, prière                       | Pars maintenant !          |

> 🗡️ Les modes **impersonnels** (infinitif, participe, gérondif) n''ont pas de sujet propre et ne varient pas en personne — on les étudiera en détail dans un prochain chapitre.

## ⚡ Les temps simples et les temps composés

- **Temps simple** : une seule forme verbale. _Il chante. / Il chantait. / Il chantera._
- **Temps composé** : auxiliaire (**avoir** ou **être**) + participe passé. _Il a chanté. / Il avait chanté._

| Temps simple | Temps composé correspondant |
| ------------ | --------------------------- |
| Présent      | Passé composé               |
| Imparfait    | Plus-que-parfait            |
| Passé simple | Passé antérieur             |
| Futur simple | Futur antérieur             |

> 🛡️ Le temps composé exprime une action **antérieure** et **accomplie** par rapport au temps simple de la même série.

## 🧪 L''indicatif — les principaux temps et leurs emplois

### Le présent de l''indicatif

- Action qui se déroule **au moment** où on parle : _Le dragon **rugit**._
- Vérité générale, habitude : _L''eau **bout** à 100 °C. / Il **lit** chaque soir._
- Présent de narration (récit) : rend un événement passé plus vivant : _Soudain, le héros **lève** son épée._

### L''imparfait

- Action **en cours** dans le passé (durée, habitude répétée) : _Chaque matin, il **s''entraînait**._
- Description, contexte dans un récit : _Le ciel **était** gris. Les arbres **bruissaient**._
- Imparfait de simultanéité avec une action soudaine au passé simple : _Il **dormait** quand le monstre **surgit**._

### Le passé simple

- Action **ponctuelle**, **achevée**, qui fait avancer le récit (littéraire) : _Il **saisit** l''épée et **frappa**._
- S''oppose à l''imparfait (fond / événement) dans la narration.

### Le passé composé

- Action **achevée** dont les effets restent présents, ou situées dans un temps **non révolu** : _J''**ai terminé** ma quête. / Ce matin, il **a gagné**._
- Remplace souvent le passé simple à l''oral et dans les textes courants.

### Le futur simple

- Action à venir, certaine ou probable : _Demain, nous **affronterons** le boss final._
- Expression d''un ordre poli : _Tu **feras** tes devoirs ce soir._

### Le plus-que-parfait

- Action **antérieure** à une autre action passée : _Elle **avait étudié** avant qu''il arrive._
- Complète l''imparfait ou le passé simple dans un récit.

> 💡 Astuce mémo : imparfait = décor (fond) ; passé simple = flash (action) ; plus-que-parfait = encore plus loin dans le passé.

## 📐 Le subjonctif présent — emplois

Le subjonctif exprime le **possible**, le **souhaité**, le **douteux** ou l''**exigé**.

**Constructions déclenchantes :**

- **Il faut que** + subjonctif : _Il faut que tu **finisses** ce niveau._
- **Pour que** + subjonctif : _Je t''explique pour que tu **comprennes**._
- **Bien que / quoique** + subjonctif : _Bien qu''il **soit** fatigué, il continue._
- **à moins que** + subjonctif : _À moins qu''il **vienne**, nous partirons._
- **Vouloir que, souhaiter que, craindre que** + subjonctif.
- **Douter que, ne pas croire que** + subjonctif.

**Formation :** radical de la 3e personne du pluriel du présent de l''indicatif + terminaisons : _-e, -es, -e, -ions, -iez, -ent_.

| Infinitif | Radical (ils finissent) | Subjonctif présent (il) |
| --------- | ----------------------- | ----------------------- |
| finir     | finiss-                 | qu''il finisse           |
| venir     | vienn-                  | qu''il vienne            |
| faire     | fass-                   | qu''il fasse             |
| être      | (irrég.)                | qu''il soit              |
| avoir     | (irrég.)                | qu''il ait               |

> 🗡️ Attention : **être** → _soit, sois, soit, soyons, soyez, soient_ ; **avoir** → _aie, aies, ait, ayons, ayez, aient_.

## 🌐 Le conditionnel présent — valeurs

Le conditionnel présent se forme sur le **radical du futur simple** + les terminaisons de l''**imparfait** : _-ais, -ais, -ait, -ions, -iez, -aient_.

| Valeur                                    | Exemple                                               |
| ----------------------------------------- | ----------------------------------------------------- |
| Hypothèse (si + imparfait → conditionnel) | Si j''étudiais plus, j''**aurais** de meilleures notes. |
| Politesse                                 | Je **voudrais** un conseil, s''il vous plaît.          |
| Information non confirmée                 | Le champion **serait** blessé.                        |
| Futur dans le passé (DI)                  | Il dit qu''il **viendrait** demain.                    |

> ⚡ Structure clé : **Si** + imparfait → conditionnel présent (jamais « si » + conditionnel !).

## 🔎 L''impératif — emplois et formes

L''impératif exprime **l''ordre**, le **conseil** ou la **prière**. Il n''a que **3 personnes** (sans sujet exprimé) : 2e sg., 1re pl., 2e pl.

| Personne | Exemple (aller) | Exemple (finir) |
| -------- | --------------- | --------------- |
| 2e sg.   | Va !            | Finis !         |
| 1re pl.  | Allons !        | Finissons !     |
| 2e pl.   | Allez !         | Finissez !      |

> 🛡️ Les verbes du 1er groupe et **aller** perdent le **-s** à la 2e personne du singulier : _Mange ! / Va !_ — sauf devant _-y_ ou _-en_ : _Vas-y ! Manges-en !_

## 🏆 Méthode : choisir le bon mode et le bon temps

1. Quel est le **mode** ? → Indicatif (réel/certain), subjonctif (subordonnée exigeante), conditionnel (hypothèse/politesse), impératif (ordre).
2. Quel est le **rapport au temps** ? → présent / passé / futur.
3. L''action est-elle **simple** (en cours / habituelle) ou **composée** (accomplie / antérieure) ?
4. **Concordance** : dans une subordonnée ou un DI, vérifie que le temps de la subordonnée correspond bien au verbe principal.

> 🏆 Maîtriser modes et temps, c''est écrire et parler avec précision — la marque du guerrier de la langue française !', '# 📜 Résumé : Les modes et les temps verbaux

- **4 modes personnels** : indicatif (fait réel/certain), subjonctif (fait envisagé/douteux/exigé), conditionnel (hypothèse/politesse), impératif (ordre/conseil — 3 personnes sans sujet).
- **Temps simples / composés** : composé = auxiliaire + participe passé ; exprime l''antériorité et l''accompli par rapport au temps simple correspondant.
- **Principaux temps de l''indicatif** :
  - Présent : action en cours, habitude, vérité générale, présent de narration.
  - Imparfait : durée/habitude dans le passé, description, contexte (fond du récit).
  - Passé simple : action ponctuelle et achevée qui fait avancer le récit (littéraire).
  - Passé composé : action achevée dans un temps non révolu, emploi oral/courant.
  - Futur simple : action à venir certaine ou probable ; ordre poli.
  - Plus-que-parfait : action antérieure à une autre action passée.
- **Subjonctif présent** : après _il faut que, pour que, bien que, à moins que, vouloir que, craindre que, douter que_… Formation : radical de _ils_ au présent + _-e, -es, -e, -ions, -iez, -ent_. Irréguliers clés : _soit, ait_.
- **Conditionnel présent** : radical du futur + terminaisons de l''imparfait (_-ais…_). Valeurs : hypothèse (si + imparfait → conditionnel), politesse, information non confirmée, futur dans le passé (DI).
- **Règle du « si »** : _si_ + imparfait → conditionnel présent (jamais _si_ + conditionnel).
- **Impératif** : 2e sg. (sans _-s_ pour les verbes en _-er_ et _aller_), 1re pl., 2e pl. Exceptions : _vas-y, manges-en_.
- Méthode : mode → rapport au temps → simple/composé → concordance.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', 'La concordance des temps', 'Maîtriser l''enchaînement des temps verbaux dans le récit au passé, dans la subordonnée au subjonctif et dans le discours indirect.', '# ⚔️ La concordance des temps

> 💡 « Chaque temps verbal est une pièce d''armure : bien les assembler, c''est construire un récit sans faille. »

## 🏰 Qu''est-ce que la concordance des temps ?

La **concordance des temps** est la règle qui impose d''adapter le temps du verbe d''une proposition subordonnée au temps du verbe de la proposition principale (ou du verbe introducteur). Elle assure la cohérence temporelle du texte.

On l''applique principalement dans trois contextes :

- le **récit au passé** (temps du récit : passé simple, imparfait, plus-que-parfait) ;
- les **subordonnées au subjonctif** (après certains verbes ou expressions) ;
- le **discours indirect** (transformation des paroles rapportées).

## ⚡ Les temps du récit au passé

Dans un texte narratif au passé, trois temps se partagent les rôles :

| Temps                | Rôle dans le récit                                     | Exemple                                            |
| -------------------- | ------------------------------------------------------ | -------------------------------------------------- |
| **Passé simple**     | Action principale, événement bref et délimité          | Le chevalier _franchit_ la porte.                  |
| **Imparfait**        | Description, action de fond, action répétée ou durable | La salle _était_ sombre ; des torches _brûlaient_. |
| **Plus-que-parfait** | Action antérieure à une autre action passée            | Il avait _entraîné_ ses troupes avant la bataille. |

> 🗡️ Le **plus-que-parfait** est formé de l''auxiliaire à l''imparfait (_avait_, _était_) + participe passé. Il marque toujours une **antériorité** par rapport à une autre action passée.

## 🛡️ Antériorité, simultanéité, postériorité

Les relations temporelles entre deux actions se marquent ainsi :

- **Simultanéité** (les deux actions se passent en même temps) :
  _Pendant qu''il **courait**, la tempête **faisait** rage._ (imparfait + imparfait)

- **Antériorité** (une action avant l''autre) :
  _Quand il **eut fini** son discours, les guerriers **partirent**._ (passé antérieur + passé simple)
  _Il **avait préparé** son plan avant de **lancer** l''attaque._ (plus-que-parfait + passé simple)

- **Postériorité** (une action après l''autre) :
  _Il **décida** qu''il **allait** affronter le dragon._ (passé simple + imparfait)

> 💡 Le **passé antérieur** (auxiliaire au passé simple + participe passé) s''emploie dans les subordonnées introduites par _quand_, _lorsque_, _dès que_, _après que_ pour marquer l''antériorité immédiate par rapport à un verbe au passé simple.

## 🔮 La concordance dans la subordonnée au subjonctif

Quand la principale est au présent ou au futur, la subordonnée au subjonctif se met au **subjonctif présent** :

_Je veux que tu **viennes** me rejoindre._

Quand la principale est au passé ou au conditionnel, la subordonnée se met au **subjonctif imparfait** (registre soutenu) :

_Il voulait que tu **vinsses** me rejoindre._ (langue littéraire)

> 🏆 Au collège, le subjonctif imparfait reste réservé aux textes littéraires ; dans les écrits courants, on préfère le subjonctif présent même quand la principale est au passé.

## 🌀 La concordance dans le discours indirect

Quand on passe du **discours direct** au **discours indirect** avec un verbe introducteur au **passé**, les temps changent selon ce tableau :

| Discours direct | Discours indirect (verbe introducteur au passé) |
| --------------- | ----------------------------------------------- |
| Présent         | Imparfait                                       |
| Passé composé   | Plus-que-parfait                                |
| Futur simple    | Conditionnel présent                            |
| Futur antérieur | Conditionnel passé                              |
| Impératif       | Infinitif (ou subjonctif)                       |

**Exemples :**

- _Il dit : « Je **suis** prêt. »_ → _Il dit qu''il **était** prêt._
- _Il dit : « J''**ai vaincu** le dragon. »_ → _Il dit qu''il **avait vaincu** le dragon._
- _Il dit : « Je **partirai** demain. »_ → _Il dit qu''il **partirait** le lendemain._
- _Il dit : « **Viens** ici ! »_ → _Il lui dit de **venir** là._

> 🗡️ Les indicateurs de temps et de lieu changent aussi : _maintenant_ → _alors_ ; _aujourd''hui_ → _ce jour-là_ ; _demain_ → _le lendemain_ ; _hier_ → _la veille_ ; _ici_ → _là_.

## 🧪 Méthode : appliquer la concordance

1. **Identifier le verbe introducteur** (principal) et son temps.
2. **Déterminer la relation temporelle** entre les deux actions (simultanée, antérieure, postérieure).
3. **Choisir le temps** de la subordonnée selon le tableau.
4. **Vérifier** la cohérence des indicateurs temporels et spatiaux.

> 🏆 La maîtrise de la concordance des temps, c''est le niveau légendaire du récit : chaque temps à sa place, l''histoire coule sans accroc.

## 📐 Récapitulatif visuel

```
Verbe principal au PASSÉ
  ├── action simultanée      →  IMPARFAIT
  ├── action antérieure      →  PLUS-QUE-PARFAIT
  └── action postérieure     →  CONDITIONNEL PRÉSENT (discours indirect)
                               IMPARFAIT (récit : allait + infinitif)

Discours direct → indirect (verbe introducteur au passé)
  présent        →  imparfait
  passé composé  →  plus-que-parfait
  futur          →  conditionnel
```', '# 📜 Résumé : La concordance des temps

- **Récit au passé** : passé simple (action principale), imparfait (description/fond), plus-que-parfait (antériorité).
- **Antériorité** : plus-que-parfait (ou passé antérieur dans les subordonnées avec _quand/dès que_) avant un passé simple.
- **Simultanéité** : imparfait + imparfait (_pendant que…_).
- **Postériorité** : passé simple + imparfait (_allait + infinitif_) dans le récit.
- **Subjonctif** : principale au présent/futur → subjonctif présent ; principale au passé → subjonctif imparfait (registre soutenu).
- **Discours indirect** (verbe introducteur au passé) :
  - présent → **imparfait**
  - passé composé → **plus-que-parfait**
  - futur → **conditionnel présent**
  - futur antérieur → **conditionnel passé**
  - impératif → **infinitif**
- Les indicateurs de temps/lieu changent aussi : _demain_ → _le lendemain_, _hier_ → _la veille_, _ici_ → _là_, etc.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', 'Le lexique et les figures de style', 'Former les mots, enrichir son vocabulaire et reconnaître les principales figures de style pour lire et écrire avec précision.', '# ⚔️ Le lexique et les figures de style

> 💡 « Les mots sont les armes du guerrier de l''écriture : en connaître la formation, le sens et les ornements, c''est forger une lame invincible. »

## 🏰 La formation des mots

Un mot est souvent composé de plusieurs éléments :

| Élément     | Définition                                                              | Exemple                                          |
| ----------- | ----------------------------------------------------------------------- | ------------------------------------------------ |
| **Radical** | La partie centrale qui porte le sens de base                            | _port_ dans _porter_, _transport_, _apport_      |
| **Préfixe** | Élément placé **avant** le radical pour modifier le sens                | _im-_ dans _impossible_ ; _re-_ dans _relire_    |
| **Suffixe** | Élément placé **après** le radical pour changer la catégorie ou le sens | _-eur_ dans _nageur_ ; _-ment_ dans _rapidement_ |

> 🗡️ La **famille de mots** regroupe tous les mots qui partagent le même radical : _terre_, _enterrer_, _terrestre_, _territoire_, _déterrer_ forment une famille.

### Quelques préfixes courants

- _in-_ / _im-_ / _il-_ / _ir-_ = privatif : _inégal_, _impossible_, _illisible_, _irréel_
- _re-_ / _ré-_ = répétition ou retour : _relire_, _réorganiser_
- _pré-_ = avant : _prévoir_, _préhistoire_
- _sur-_ = au-dessus / excès : _surpasser_, _surévaluer_
- _sous-_ = insuffisance : _sous-estimer_, _souterrain_

### Quelques suffixes courants

- _-eur_ / _-rice_ : nom d''agent (personne qui fait) → _nageur_, _actrice_
- _-tion_ / _-sion_ : nom d''action → _construction_, _décision_
- _-ment_ : adverbe de manière → _rapidement_, _doucement_
- _-able_ / _-ible_ : possibilité → _lisible_, _aimable_

## ⚡ Champ lexical et champ sémantique

- Le **champ lexical** d''un thème regroupe tous les mots (de catégories grammaticales variées) qui s''y rapportent.
  _Champ lexical de la guerre_ : combat, ennemi, bataille, vaincre, guerrier, assaut, victoire…

- Le **champ sémantique** d''un mot regroupe tous les sens différents que ce mot peut prendre selon le contexte.
  _Le mot « feu »_ : incendie (sens courant) ; passion (sens figuré) ; signal lumineux (sens technique).

> 💡 Pour analyser un texte, repérer le champ lexical dominant permet d''identifier le thème principal.

## 🛡️ Synonymes, antonymes, homonymes, paronymes

| Relation      | Définition                                             | Exemple                                                                  |
| ------------- | ------------------------------------------------------ | ------------------------------------------------------------------------ |
| **Synonymes** | Mots de sens voisin ou équivalent                      | _courageux_ / _vaillant_ / _intrépide_                                   |
| **Antonymes** | Mots de sens contraire                                 | _victoire_ / _défaite_ ; _fort_ / _faible_                               |
| **Homonymes** | Mots de prononciation identique mais de sens différent | _verre_ (récipient) / _vers_ (poème) / _vert_ (couleur) / _ver_ (animal) |
| **Paronymes** | Mots de forme proche mais de sens différent            | _éruption_ / _irruption_ ; _collision_ / _collusion_                     |

> 🗡️ Attention aux paronymes : confondre _accepter_ et _excepter_, ou _éminent_ et _imminent_, est une erreur fréquente à l''examen.

## 🔮 Sens propre, sens figuré — dénotation et connotation

- Le **sens propre** (ou littéral) est le sens premier, concret et objectif d''un mot.
  _Les flammes dévoraient la forêt._ (sens propre de « dévorer »)

- Le **sens figuré** est un sens second, imagé ou métaphorique.
  _La jalousie dévorait son cœur._ (sens figuré de « dévorer »)

- La **dénotation** est le sens objectif et neutre d''un mot, partagé par tous.
  Le mot _serpent_ → reptile sans pattes.

- La **connotation** est l''ensemble des valeurs subjectives, culturelles ou émotionnelles associées à un mot.
  Le mot _serpent_ → trahison, danger, ruse (connotations négatives dans la culture occidentale).

> 💡 En production écrite, choisir un mot pour ses connotations permet d''influencer le lecteur sans l''affirmer directement.

## 🌀 Les figures de style : comparaison et métaphore

Les figures de style embellissent le langage et lui donnent une force expressive particulière.

### La comparaison

Elle établit un rapprochement explicite entre deux éléments à l''aide d''un **outil comparatif** (_comme_, _tel_, _pareil à_, _semblable à_, _plus… que_).

_Le guerrier était **fort comme** un lion._

Éléments : le **comparé** (guerrier), l''**outil** (_comme_), le **comparant** (lion). Le **point commun** est la force.

### La métaphore

Elle établit le même rapprochement, mais **sans outil comparatif** : elle identifie directement le comparé au comparant.

- _Ce guerrier **est un lion**._ (métaphore nominale)
- _Il **rugit** de colère._ (métaphore verbale)

> 🗡️ La métaphore **filée** est une métaphore développée sur plusieurs phrases ou sur tout un texte.

## 🧪 Les autres figures de style

| Figure               | Définition                                                                         | Exemple                                                   |
| -------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------- |
| **Personnification** | Attribuer des caractéristiques humaines à un animal, un objet ou une abstraction   | _La tempête **hurlait** sa fureur._                       |
| **Hyperbole**        | Exagération à des fins expressives                                                 | _Je t''ai **attendu mille ans**._                          |
| **Énumération**      | Suite de termes appartenant à la même catégorie                                    | _Des épées, des boucliers, des lances jonchaient le sol._ |
| **Gradation**        | Énumération dont les termes sont ordonnés par intensité croissante ou décroissante | _Il frémit, tremblait, criait de peur._                   |

> 🏆 Pour identifier une figure de style à l''examen : 1) nommer la figure ; 2) citer les mots qui la constituent ; 3) expliquer son effet.

## 📐 Méthode : analyser le vocabulaire d''un texte

1. **Repérer le champ lexical dominant** → thème principal.
2. **Identifier les figures de style** → effet recherché.
3. **Distinguer sens propre et sens figuré** → intention de l''auteur.
4. **Relever les connotations** → valeur expressive ou argumentative.

> 🏆 Vocabulaire maîtrisé + figures reconnues = textes déchiffrés et écriture affinée. Tu es désormais un guerrier du langage !', '# 📜 Résumé : Le lexique et les figures de style

- **Formation des mots** : radical (sens de base) + préfixe (avant) + suffixe (après). Les mots partageant le même radical forment une **famille de mots**.
- **Préfixes courants** : _in-/im-_ (privatif), _re-_ (répétition), _pré-_ (avant), _sur-_ (excès), _sous-_ (insuffisance).
- **Suffixes courants** : _-eur/-rice_ (agent), _-tion/-sion_ (action), _-ment_ (adverbe), _-able/-ible_ (possibilité).
- **Champ lexical** : tous les mots qui se rapportent à un même thème. **Champ sémantique** : tous les sens d''un même mot.
- **Synonymes** : sens voisin. **Antonymes** : sens contraire. **Homonymes** : même son, sens différent (_verre/vers/vert/ver_). **Paronymes** : forme proche, sens différent (_éruption/irruption_).
- **Sens propre** (concret/littéral) vs **sens figuré** (imagé/métaphorique).
- **Dénotation** : sens objectif partagé. **Connotation** : valeurs subjectives et culturelles associées.
- **Comparaison** : rapprochement avec outil comparatif (_comme_, _tel_). Trois éléments : comparé, outil, comparant.
- **Métaphore** : rapprochement sans outil comparatif. Métaphore filée = développée sur tout un passage.
- **Personnification** : attributs humains donnés à un non-humain. **Hyperbole** : exagération expressive. **Énumération** : suite de termes de même catégorie. **Gradation** : énumération par intensité croissante ou décroissante.
- Méthode d''analyse : champ lexical → figures → sens propre/figuré → connotations.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('383392ce-53c3-5d10-b090-6f6f48124bee', 'french', 'Les types de textes et la production écrite', 'Identifier les quatre types de textes et leurs indices, maîtriser le schéma narratif, les connecteurs et les techniques de la production écrite.', '# ⚔️ Les types de textes et la production écrite

> 💡 « Connaître le type d''un texte, c''est lire la carte du donjon avant d''y entrer ; savoir le produire, c''est en devenir le maître. »

## 🏰 Les quatre types de textes

Tout texte appartient principalement à l''un de ces quatre types, reconnaissables à leurs **indices** :

| Type             | But principal                            | Indices caractéristiques                                                                                                              |
| ---------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Narratif**     | Raconter des événements                  | Verbes d''action, temps du récit (passé simple, imparfait), personnages, lieu, chronologie                                             |
| **Descriptif**   | Décrire un lieu, un personnage, un objet | Adjectifs qualificatifs, verbes d''état (_être_, _paraître_, _sembler_), imparfait, comparaisons                                       |
| **Explicatif**   | Expliquer un phénomène, informer         | Présent de vérité générale, connecteurs logiques (_parce que_, _en effet_, _ainsi_), vocabulaire spécialisé, organisation cause/effet |
| **Argumentatif** | Convaincre, défendre une thèse           | Thèse, arguments, exemples, connecteurs logiques (_cependant_, _donc_, _or_), verbes d''opinion (_je pense que_, _il est vrai que_)    |

> 🗡️ Un même texte peut mêler plusieurs types : un roman contient des passages narratifs ET descriptifs. Il faut identifier le **type dominant**.

## ⚡ Le schéma narratif

Tout récit complet suit un schéma en cinq étapes :

1. **Situation initiale** : présentation de l''univers, des personnages et de l''état d''équilibre.
   _Éléments : imparfait, descriptions, informations sur le lieu et les protagonistes._

2. **Élément perturbateur** (= déclencheur) : un événement rompt l''équilibre initial.
   _Éléments : passé simple, changement brutal, arrivée d''un problème._

3. **Péripéties** (= actions) : suite d''événements et d''obstacles que les personnages traversent pour rétablir l''équilibre.
   _Éléments : verbes d''action au passé simple, rebondissements._

4. **Dénouement** (= résolution) : l''équilibre est rétabli, le problème est résolu (ou non).
   _Éléments : passé simple, tournant décisif._

5. **Situation finale** : nouvel état d''équilibre, bilan de la situation.
   _Éléments : présent ou imparfait, description du nouvel état._

> 💡 L''élément perturbateur et le dénouement sont souvent au **passé simple** ; la situation initiale et finale, à l''**imparfait** ou au **présent**.

## 🛡️ Les connecteurs logiques et temporels

Les connecteurs assurent la cohérence du texte. Il en existe deux grandes familles :

### Connecteurs temporels (pour les récits)

| Valeur       | Exemples                                                |
| ------------ | ------------------------------------------------------- |
| Antériorité  | _avant que_, _auparavant_, _la veille_                  |
| Simultanéité | _pendant que_, _tandis que_, _en même temps_, _alors_   |
| Postériorité | _ensuite_, _puis_, _après que_, _le lendemain_, _enfin_ |

### Connecteurs logiques (pour l''explication et l''argumentation)

| Valeur                | Exemples                                            |
| --------------------- | --------------------------------------------------- |
| Cause                 | _parce que_, _car_, _en effet_, _puisque_           |
| Conséquence           | _donc_, _ainsi_, _c''est pourquoi_, _par conséquent_ |
| Opposition/concession | _mais_, _cependant_, _néanmoins_, _pourtant_, _or_  |
| Addition              | _de plus_, _en outre_, _par ailleurs_, _également_  |
| Illustration          | _par exemple_, _notamment_, _c''est le cas de_       |

> 🗡️ Dans une copie d''examen, utiliser des connecteurs variés est un critère de qualité évalué par le correcteur.

## 🔮 La production écrite : le récit

Pour rédiger un récit réussi :

- **Respecter le schéma narratif** en cinq étapes.
- **Employer les temps du récit** : passé simple (actions), imparfait (descriptions/fond), plus-que-parfait (antériorité).
- **Varier les types de phrases** et intégrer des **dialogues** (discours direct ou indirect).
- **Insérer des passages descriptifs** pour ancrer le récit dans un espace vivant.
- **Utiliser des figures de style** (comparaisons, métaphores) pour enrichir l''expression.

## 🌀 La production écrite : la description et l''argumentation

### La description

- Organiser la description selon un **plan spatial** : de loin à près, de haut en bas, de gauche à droite.
- Faire appel aux **cinq sens** : vue, ouïe, odorat, toucher, goût.
- Employer l''**imparfait** (description dans un récit) ou le **présent** (description autonome).
- Choisir des **adjectifs précis** et des **comparaisons** ou **métaphores** évocatrices.

### L''argumentation : thèse, arguments, exemples

Un texte argumentatif suit ce plan :

1. **Introduction** : présenter le sujet et annoncer la thèse (position défendue).
2. **Développement** : chaque paragraphe = un **argument** + un **exemple** concret.
   _Structure d''un paragraphe : affirmation → explication → exemple → conclusion partielle._
3. **Conclusion** : reformuler la thèse et ouvrir une perspective.

> 💡 L''**argument** répond à la question « pourquoi ? » ; l''**exemple** répond à « par exemple ? ».

### La lettre

- **Lettre formelle** : lieu et date en haut à droite, formule d''appel (_Monsieur_, _Madame_), corps structuré, formule de politesse finale, signature.
- **Lettre informelle** : registre courant ou familier, formule d''appel simple (_Cher ami_), ton personnel.

> 🗡️ Ne pas oublier la formule de politesse dans une lettre formelle : c''est souvent un critère noté à l''examen.

## 🧪 Méthode : lire et produire un texte à l''examen

1. **Lire** → identifier le type dominant (narratif, descriptif, explicatif, argumentatif).
2. **Analyser** → repérer les indices (temps verbaux, connecteurs, figures).
3. **Planifier** avant d''écrire → schéma narratif ou plan argumentatif.
4. **Rédiger** → employer les bons temps, connecteurs et figures.
5. **Relire** → vérifier la cohérence temporelle, l''orthographe, la ponctuation.

> 🏆 Maîtriser les types de textes et les techniques de production écrite, c''est détenir la clé de toutes les épreuves du brevet !

## 📐 Récapitulatif : indices rapides

```
Type NARRATIF     → verbes d''action, passé simple, personnages, chronologie
Type DESCRIPTIF   → adjectifs, imparfait, sens, verbes d''état
Type EXPLICATIF   → présent de vérité, cause/conséquence, vocabulaire spécialisé
Type ARGUMENTATIF → thèse, arguments, exemples, connecteurs logiques, opinions
```', '# 📜 Résumé : Les types de textes et la production écrite

- **4 types de textes** : narratif (raconter), descriptif (décrire), explicatif (expliquer), argumentatif (convaincre).
- **Indices narratifs** : verbes d''action, passé simple, personnages, chronologie.
- **Indices descriptifs** : adjectifs, imparfait, verbes d''état, comparaisons, cinq sens.
- **Indices explicatifs** : présent de vérité générale, connecteurs cause/conséquence, vocabulaire spécialisé.
- **Indices argumentatifs** : thèse, arguments, exemples, connecteurs logiques, verbes d''opinion.
- **Schéma narratif** (5 étapes) : situation initiale → élément perturbateur → péripéties → dénouement → situation finale.
- **Connecteurs temporels** : _avant que_ (antériorité), _pendant que_ (simultanéité), _ensuite/enfin_ (postériorité).
- **Connecteurs logiques** : cause (_parce que_, _car_), conséquence (_donc_, _ainsi_), opposition (_mais_, _cependant_), addition (_de plus_, _en outre_).
- **Récit** : passé simple (actions) + imparfait (description/fond) + plus-que-parfait (antériorité).
- **Description** : plan spatial, cinq sens, adjectifs précis, figures de style.
- **Argumentation** : introduction (thèse) + développement (argument + exemple) + conclusion.
- **Lettre formelle** : lieu/date, formule d''appel, corps, formule de politesse, signature.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Compréhension de texte & production écrite', 'Lire activement un texte (idée directrice, type de texte, connecteurs, ton, inférence, lexique en contexte) et maîtriser les bases de la production écrite : phrase de thèse, amorce, paragraphe argumentatif et enchaînement logique.', '# Compréhension de texte & production écrite

> « Bien lire, c''est interroger un texte ; bien écrire, c''est répondre avec ordre. »

Ce chapitre relie deux compétences inséparables de l''examen : **comprendre** un texte (en saisir le sens explicite et implicite) et **produire** à votre tour un écrit clair, organisé et argumenté.

---

## Partie A — Comprendre un texte

### 1. Repérer l''idée directrice (ou la thèse)

L''**idée directrice** est l''idée principale autour de laquelle tout le texte s''organise. Dans un texte argumentatif, on parle de **thèse** : c''est la position que l''auteur défend.

- Elle se trouve souvent dans la **première** ou la **dernière** phrase.
- Pour la trouver, demandez-vous : « De quoi parle le texte, et que veut-il me faire admettre ? »
- Ne confondez pas l''idée directrice (générale, englobante) avec un simple **détail** ou un **exemple**.

### 2. Identifier le type de texte

Reconnaître le type d''un texte permet d''anticiper son organisation.

| Type                        | Ce qu''il fait                          | Indices                                                        |
| --------------------------- | -------------------------------------- | -------------------------------------------------------------- |
| **Narratif**                | Raconte des événements qui se suivent  | verbes d''action, temps du récit, personnages, repères de temps |
| **Descriptif**              | Peint un lieu, un objet, une personne  | adjectifs, verbes d''état, notations sensorielles (vue, ouïe…)  |
| **Informatif / explicatif** | Donne des faits, explique un phénomène | chiffres, présent de vérité générale, ton neutre               |
| **Argumentatif**            | Défend une opinion, convainc           | thèse, arguments, connecteurs logiques, marques de jugement    |

### 3. Comprendre le rôle des connecteurs logiques

Les **connecteurs** révèlent le lien logique entre les idées. Les reconnaître, c''est comprendre le raisonnement.

| Relation                    | Connecteurs                                     | Exemple                                  |
| --------------------------- | ----------------------------------------------- | ---------------------------------------- |
| **Addition**                | de plus, par ailleurs, en outre                 | « Il est tard ; de plus, il pleut. »     |
| **Cause**                   | car, parce que, puisque, en effet               | « Je reste, car il pleut. »              |
| **Conséquence**             | donc, ainsi, c''est pourquoi, par conséquent     | « Il pleut, donc je reste. »             |
| **Opposition / concession** | mais, cependant, or, pourtant, malgré, bien que | « Il pleut, pourtant il sort. »          |
| **But**                     | afin de, pour que                               | « Il révise pour réussir. »              |
| **Illustration**            | par exemple, ainsi, notamment                   | « Des sports, par exemple le football. » |

### 4. Repérer le ton et le sentiment

Le **ton** trahit l''attitude de l''auteur ou du personnage : joie, tristesse, colère, ironie, admiration, résignation, inquiétude… On le repère grâce :

- au **champ lexical** dominant (les mots qui reviennent) ;
- aux **répétitions**, à la **ponctuation** (! …), aux figures de style ;
- aux **modalisateurs** (peut-être, hélas, certainement).

### 5. Lire entre les lignes : l''inférence

Un texte ne dit pas tout. **Inférer**, c''est déduire une information non écrite à partir d''indices.

- _« Elle ferma son parapluie en entrant. »_ → on déduit qu''**il pleuvait**.
- L''inférence s''appuie toujours sur le texte, jamais sur une simple opinion personnelle.

### 6. Le lexique en contexte

Le sens d''un mot dépend de son **entourage**. Pour deviner un mot inconnu :

1. lisez la phrase entière (et la suivante) ;
2. cherchez un synonyme, un contraire ou un exemple proche ;
3. vérifiez que le sens choisi reste cohérent avec la phrase.

---

## Partie B — Produire un écrit

### 1. Faire un plan avant d''écrire

Ne rédigez jamais sans plan. Un plan simple :

1. **Introduction** : une phrase d''amorce + l''annonce de votre position (thèse).
2. **Développement** : un ou deux paragraphes, chacun = **un argument** illustré d''un exemple.
3. **Conclusion** : bilan + une ouverture éventuelle.

### 2. La phrase de thèse

C''est la phrase qui **annonce clairement votre position**. Une bonne phrase de thèse est :

- **précise** (pas vague comme « je vais parler de la lecture ») ;
- **affirmée** (« La lecture est essentielle parce qu''elle nourrit l''imagination ») ;
- **orientée** vers ce que le paragraphe va prouver.

### 3. La phrase d''amorce

L''**amorce** est la toute première phrase : elle attire l''attention et introduit le sujet **sans le traiter encore**. On peut amorcer par :

- un **constat** général (« Aujourd''hui, les écrans occupent une grande place… ») ;
- une **question** ;
- une **citation** ou un fait frappant.

Une amorce réussie est **liée au sujet** : elle n''est ni hors sujet ni déjà la conclusion.

### 4. Le paragraphe argumentatif

Un paragraphe argumentatif efficace suit cet ordre :

1. **Idée / argument** (phrase qui annonce l''argument) ;
2. **Explication** (on développe le pourquoi) ;
3. **Exemple** (un cas concret qui prouve) ;
4. **Mini-conclusion** ou transition vers la suite.

> Mémo de l''ordre logique : **annoncer → expliquer → illustrer → conclure**.

### 5. Choisir le bon connecteur

Le connecteur doit correspondre au **lien réel** entre vos idées :

- pour ajouter un argument : _de plus, par ailleurs_ ;
- pour opposer un contre-argument : _certes… mais, cependant_ ;
- pour conclure : _donc, en somme, ainsi_.

Un connecteur mal choisi rend le texte **incohérent**, même si chaque phrase est correcte.

### 6. Argument et contre-argument

- L''**argument** soutient votre thèse.
- Le **contre-argument** est l''objection adverse ; un bon texte le **reconnaît** (« Certes… ») puis le **réfute** (« … mais »).

### 7. Vérifier la cohérence

Avant de rendre, relisez : les phrases s''enchaînent-elles logiquement ? Les connecteurs sont-ils justes ? Y a-t-il une idée hors sujet ou une contradiction ? Un texte **cohérent** progresse sans rupture ni répétition inutile.

> En résumé : on **lit** en cherchant des preuves dans le texte, et on **écrit** en organisant ses idées avec des connecteurs justes.', '# Résumé — Compréhension de texte & production écrite

## Lire (comprendre)

- **Idée directrice / thèse** : l''idée centrale que défend le texte ; souvent en tête ou en fin. À distinguer d''un simple détail ou exemple.
- **Type de texte** : narratif (raconte), descriptif (peint), informatif (explique des faits), argumentatif (défend une opinion).
- **Connecteurs logiques** : révèlent le lien entre les idées — addition (de plus), cause (car), conséquence (donc), opposition (mais, pourtant, malgré), but (afin de).
- **Ton / sentiment** : attitude de l''auteur (joie, ironie, résignation…), repérée via le champ lexical, les répétitions et la ponctuation.
- **Inférence** : déduire une information non écrite à partir d''indices du texte, sans inventer.
- **Lexique en contexte** : deviner le sens d''un mot grâce à la phrase qui l''entoure (synonyme, contraire, exemple).

## Écrire (produire)

- **Plan** : introduction (amorce + thèse) → développement (un argument + exemple par paragraphe) → conclusion.
- **Phrase de thèse** : précise, affirmée, orientée vers ce qu''on va prouver.
- **Phrase d''amorce** : première phrase qui introduit le sujet sans le traiter ; liée au sujet (constat, question, fait frappant).
- **Paragraphe argumentatif** : annoncer l''argument → expliquer → illustrer par un exemple → conclure / faire la transition.
- **Bon connecteur** : doit correspondre au lien réel entre les idées ; un mauvais choix rend le texte incohérent.
- **Argument vs contre-argument** : l''argument soutient la thèse ; le contre-argument est l''objection, qu''on reconnaît (« certes ») puis réfute (« mais »).
- **Cohérence** : relire pour vérifier l''enchaînement logique, la justesse des connecteurs et l''absence de hors-sujet ou de contradiction.', 9)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Annales & sujets types', 'S''entraîner sur des sujets façon épreuve de fin d''études (ختم التعليم الأساسي) : lire un texte (récit, description, texte informatif ou argumentatif), répondre aux questions de compréhension, traiter les questions de langue (temps verbaux, voix passive, discours rapporté, subordonnées, lexique) portant sur ce texte, et préparer la production écrite (thèse, amorce, connecteurs, cohérence).', '# Annales & sujets types — Méthodologie de l''épreuve

L''épreuve de français de fin d''études de base (ختم التعليم الأساسي) repose sur **un texte** suivi de trois grandes parties. Le temps est limité : il faut donc une méthode pour répartir son effort. Ce chapitre te propose des **sujets types** complets, décomposés en QCM, pour t''entraîner exactement comme le jour de l''examen.

## 1. Lire le texte intelligemment (5 à 10 min)

Avant de répondre, lis le texte **deux fois** :

- **Première lecture** : pour comprendre globalement de quoi il parle (le thème, qui parle, où, quand).
- **Deuxième lecture, crayon en main** : repère le **type de texte** (récit, descriptif, informatif, argumentatif), l''**idée directrice** ou la **thèse**, les **connecteurs logiques** (mais, donc, car, pourtant…) et les **mots difficiles** à comprendre dans leur contexte.

Astuce : le **titre**, le **premier** et le **dernier** paragraphe contiennent souvent l''essentiel.

## 2. La compréhension du texte (≈ 40 % de la note)

Les questions de compréhension testent ta lecture, pas ton imagination. Trois règles d''or :

- **Réponds avec le texte** : la bonne réponse s''appuie sur un indice précis (un mot, une phrase). Ne réponds jamais « au feeling ».
- **Distingue l''explicite et l''implicite** : certaines questions demandent une information écrite noir sur blanc ; d''autres demandent d''**inférer** (déduire) à partir d''indices, sans rien inventer.
- **Méfie-toi des pièges** : un distracteur déforme souvent un détail vrai, ou exagère (« toujours », « jamais »), ou dit le contraire du texte.

On te demandera typiquement : l''idée directrice / la thèse, le type ou le ton du texte, le rôle d''un connecteur, le sens d''un mot **en contexte**, ou une inférence sur un personnage ou une situation.

## 3. Les questions de langue (≈ 30 % de la note)

Cette partie applique la grammaire **au texte étudié**. Les notions les plus fréquentes en 9e :

- **Temps et modes verbaux** : valeur du présent, opposition imparfait / passé simple dans le récit, futur, conditionnel.
- **Voix active / voix passive** : transformer une phrase, identifier le complément d''agent (introduit par « par » ou « de »), comprendre pourquoi l''auteur choisit le passif.
- **Discours direct / indirect** (discours rapporté) : passer du direct à l''indirect, repérer les changements de pronoms, de temps et de ponctuation.
- **Propositions subordonnées** : relatives (qui, que, dont, où), complétives (que…), circonstancielles de cause, de but, de conséquence, de condition, de temps.
- **Lexique** : famille de mots, synonymes / antonymes, sens propre / sens figuré, champ lexical.

Conseil : **relis la phrase exacte du texte** citée par la question avant de transformer ou d''analyser.

## 4. La production écrite (≈ 30 % de la note)

C''est l''épreuve qui rapporte le plus de points perdus. Quelques réflexes qui font la différence :

- **Lis bien la consigne** : type de texte demandé (récit, description, lettre, paragraphe argumentatif), sujet précis, longueur attendue.
- **Construis un plan** avant de rédiger : introduction (amorce + thèse) → développement (un argument et un exemple par paragraphe) → conclusion.
- **Soigne l''amorce** : la première phrase introduit le sujet sans le traiter (un constat, une question, un fait frappant).
- **Choisis le bon connecteur** : il doit traduire le **vrai** lien entre les idées (addition, cause, conséquence, opposition). Un mauvais connecteur rend le texte incohérent.
- **Vérifie la cohérence** : pas de hors-sujet, pas de contradiction, un enchaînement logique du début à la fin.
- **Relis** pour corriger l''orthographe, la conjugaison et la ponctuation : ces points sont notés.

## Gérer les trois parties ensemble

Le secret de l''épreuve n''est pas de tout savoir, mais de bien **répartir son temps** :

1. Lecture active du texte.
2. Compréhension (réponses courtes et précises, appuyées sur le texte).
3. Langue (appliquer les règles à des phrases du texte).
4. Production écrite : garder **assez de temps** (souvent un tiers du total) pour planifier, rédiger et relire.

Dans ce chapitre, chaque exercice est un **mini-sujet complet** : un texte, puis des questions de compréhension, de langue et de production qui portent **toutes sur ce même texte**. Entraîne-toi comme le jour J : lis d''abord le texte en entier, puis réponds.', '# Résumé — Annales & sujets types

## Structure de l''épreuve

- **Un texte** (récit, descriptif, informatif ou argumentatif) suivi de trois parties : **compréhension**, **langue**, **production écrite**.
- Répartir son temps : lecture active → compréhension → langue → production écrite (garder ≈ 1/3 du temps pour produire et relire).

## Lire le texte

- Lire **deux fois** : globalement, puis crayon en main.
- Repérer le **type de texte**, l''**idée directrice / thèse**, les **connecteurs**, les **mots difficiles** en contexte.

## Compréhension

- **Répondre avec le texte** : chaque réponse s''appuie sur un indice précis.
- Distinguer l''**explicite** (écrit) de l''**implicite** (inférer sans inventer).
- Pièges fréquents : détail déformé, exagération (« toujours », « jamais »), contraire du texte.

## Langue (appliquée au texte)

- **Temps / modes** : présent, imparfait vs passé simple dans le récit, futur, conditionnel.
- **Voix passive** : transformer, repérer le **complément d''agent** (par / de).
- **Discours rapporté** : passer du direct à l''indirect (pronoms, temps, ponctuation).
- **Subordonnées** : relatives (qui, que, dont, où), complétives, circonstancielles (cause, but, conséquence, condition, temps).
- **Lexique** : synonymes / antonymes, sens propre / figuré, champ lexical, famille de mots.

## Production écrite

- **Plan** : introduction (amorce + thèse) → développement (argument + exemple par paragraphe) → conclusion.
- **Amorce** : introduit le sujet sans le traiter.
- **Thèse** : claire, affirmée, orientée vers ce qu''on va prouver.
- **Bon connecteur** : traduit le vrai lien entre les idées ; un mauvais choix nuit à la cohérence.
- **Cohérence** : pas de hors-sujet ni de contradiction ; relire (orthographe, conjugaison, ponctuation).', 10)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a3d666a-ae97-5cca-b650-d0d8ab427c72', '1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'Combien de types de phrases existe-t-il en français ?', '[{"id":"a","text":"Deux (affirmatif et négatif)"},{"id":"b","text":"Trois (déclaratif, interrogatif, exclamatif)"},{"id":"c","text":"Quatre (déclaratif, interrogatif, impératif, exclamatif)"},{"id":"d","text":"Cinq (déclaratif, interrogatif, impératif, exclamatif, emphatique)"}]'::jsonb, 'c', 'Il existe exactement quatre types de phrases : déclaratif (informer), interrogatif (questionner), impératif (ordonner/conseiller) et exclamatif (exprimer une émotion).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2ff9a73-4e3e-5480-8908-65ac415b84b9', '1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'Quelle est la caractéristique principale de la phrase impérative ?', '[{"id":"a","text":"Elle se termine toujours par un point d''exclamation."},{"id":"b","text":"Le sujet n''est pas exprimé et le verbe est à l''impératif."},{"id":"c","text":"Elle contient obligatoirement une négation."},{"id":"d","text":"Elle commence toujours par un mot interrogatif."}]'::jsonb, 'b', 'La phrase impérative se reconnaît à l''absence de sujet exprimé et au verbe conjugué à l''impératif (ex. : « Avance. », « Écoutons. »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6a3e46e-b0b6-54a7-b112-b02150981080', '1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'Parmi les négations suivantes, laquelle est incorrecte selon les règles de la négation en deux mots ?', '[{"id":"a","text":"ne… pas"},{"id":"b","text":"ne… jamais"},{"id":"c","text":"ne… rien"},{"id":"d","text":"ne… oui"}]'::jsonb, 'd', 'La négation fonctionne toujours en deux mots encadrant le verbe : ne… pas, ne… jamais, ne… plus, ne… rien. « ne… oui » n''est pas une négation française.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b54bb455-90a0-51f8-85a9-bd1a7c6490b4', '1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'Quelle est la différence entre une interrogation totale et une interrogation partielle ?', '[{"id":"a","text":"L''interrogation totale utilise un mot interrogatif ; la partielle n''en utilise pas."},{"id":"b","text":"L''interrogation totale appelle une réponse oui/non ; la partielle porte sur un élément précis."},{"id":"c","text":"L''interrogation totale est au registre soutenu ; la partielle est familière."},{"id":"d","text":"L''interrogation totale utilise l''inversion du sujet ; la partielle utilise « est-ce que »."}]'::jsonb, 'b', 'L''interrogation totale appelle une réponse par oui ou non (ex. : « Viens-tu ? »). L''interrogation partielle porte sur un élément précis et utilise un mot interrogatif (qui, où, quand…).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f97d038-415e-5681-996d-bbb0881e4026', '1368c9b4-7ea9-5818-ad62-b7c96b0dbda1', 'Dans la phrase « C''est la reine qui décide. », quelle forme particulière est utilisée ?', '[{"id":"a","text":"La forme négative"},{"id":"b","text":"La forme passive"},{"id":"c","text":"La forme interrogative"},{"id":"d","text":"La forme emphatique"}]'::jsonb, 'd', 'Le présentatif « c''est… qui » met le sujet en relief : c''est la forme emphatique. Elle souligne l''importance d''un élément de la phrase.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8b74863-3fe8-5aad-a426-621ef75ec7ef', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', 'Exercice : reconnaître types et formes', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7f2f2b1-7a71-5c8f-8684-6fe8a2a5b9f3', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quel est le type de la phrase : « Quelle aventure extraordinaire ! »', '[{"id":"a","text":"Déclaratif"},{"id":"b","text":"Interrogatif"},{"id":"c","text":"Exclamatif"},{"id":"d","text":"Impératif"}]'::jsonb, 'c', 'La phrase exprime une émotion et se termine par un point d''exclamation : elle est exclamative.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50cce373-29a3-50c2-8dfb-6b123b7c0f09', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', '« Ferme la porte. » est une phrase de type :', '[{"id":"a","text":"Déclaratif"},{"id":"b","text":"Exclamatif"},{"id":"c","text":"Interrogatif"},{"id":"d","text":"Impératif"}]'::jsonb, 'd', 'Elle donne un ordre, le verbe est à l''impératif et le sujet n''est pas exprimé : phrase impérative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37b194e0-3e8e-55f3-ab43-d7de67825e3a', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quelle phrase est à la forme négative ?', '[{"id":"a","text":"Il comprend tout."},{"id":"b","text":"Comprend-il la leçon ?"},{"id":"c","text":"Il ne comprend rien."},{"id":"d","text":"Quelle compréhension !"}]'::jsonb, 'c', 'La négation « ne… rien » encadre le verbe : la phrase est à la forme négative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eccc5914-b0d5-5035-804e-16a2cefc1af6', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'L''interrogation « Est-ce que tu viens ? » est une interrogation :', '[{"id":"a","text":"Partielle"},{"id":"b","text":"Exclamative"},{"id":"c","text":"Emphatique"},{"id":"d","text":"Totale (réponse oui/non)"}]'::jsonb, 'd', 'On peut répondre par oui ou non : c''est une interrogation totale.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd092ac9-1a1b-5654-a751-1f1f28f5548a', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Quelle phrase est à la forme passive ?', '[{"id":"a","text":"La porte est ouverte par le gardien."},{"id":"b","text":"Le gardien ouvre la porte."},{"id":"c","text":"Ouvre la porte !"},{"id":"d","text":"Le gardien ouvrira la porte."}]'::jsonb, 'a', 'Le sujet subit l''action : « être + participe passé + par (complément d''agent) » = voix passive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fbb7ffb-02e9-5d41-a1b1-80ebf9561872', 'e8b74863-3fe8-5aad-a426-621ef75ec7ef', 'Dans « C''est le chevalier qui gagne. », la phrase est à la forme :', '[{"id":"a","text":"Négative"},{"id":"b","text":"Passive"},{"id":"c","text":"Emphatique"},{"id":"d","text":"Interrogative"}]'::jsonb, 'c', 'Le présentatif « c''est… qui » met le sujet en relief : c''est la forme emphatique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b342ef2-05e7-53d3-bded-effe80517ef5', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', '⚔️ Boss : transformer les phrases', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11d792cc-0455-56d3-b00b-9145225ca97b', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Transforme à la voix passive : « Le maître corrige les copies. »', '[{"id":"a","text":"Les copies corrigent le maître."},{"id":"b","text":"Le maître est corrigé par les copies."},{"id":"c","text":"Les copies sont corrigées par le maître."},{"id":"d","text":"Les copies ont été corrigées par le maître."}]'::jsonb, 'c', 'Le COD « les copies » devient sujet, et on garde le présent : « sont corrigées par le maître ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9044bfb1-eeb6-54e1-a7d8-10408624f911', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Quelle phrase est une interrogation partielle ?', '[{"id":"a","text":"Quand pars-tu ?"},{"id":"b","text":"Pars-tu ?"},{"id":"c","text":"Est-ce que tu pars ?"},{"id":"d","text":"Tu pars ?"}]'::jsonb, 'a', 'L''interrogation porte sur un élément précis (le moment) grâce au mot interrogatif « quand » : elle est partielle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8499fe2e-7b46-5dd1-a7e8-c679eb7bf64c', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Dans « Le dragon ne dort plus. », la négation « ne… plus » exprime :', '[{"id":"a","text":"L''arrêt d''une action qui durait"},{"id":"b","text":"Une quantité nulle"},{"id":"c","text":"Une question"},{"id":"d","text":"Une exclamation"}]'::jsonb, 'a', '« ne… plus » indique qu''une action a cessé : le dragon dormait, mais ce n''est plus le cas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('079d8ed9-845f-5b08-9391-5984479ec84f', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets à la forme négative : « Il voit quelqu''un. »', '[{"id":"a","text":"Il ne voit pas quelqu''un."},{"id":"b","text":"Il ne voit rien."},{"id":"c","text":"Il voit personne."},{"id":"d","text":"Il ne voit personne."}]'::jsonb, 'd', 'Le contraire de « quelqu''un » (une personne) est « ne… personne ». « ne… rien » s''emploie pour une chose.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('276a92b0-0c54-5381-b57c-d86ad57b021e', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets à la voix active : « La ville fut détruite par l''armée. »', '[{"id":"a","text":"L''armée détruit la ville."},{"id":"b","text":"L''armée détruisit la ville."},{"id":"c","text":"La ville détruisit l''armée."},{"id":"d","text":"La ville a détruit l''armée."}]'::jsonb, 'b', 'Le complément d''agent « l''armée » devient sujet et on conserve le passé simple : « détruisit ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aabce6d4-f8ce-58d2-8737-80d73b3f05c8', '3b342ef2-05e7-53d3-bded-effe80517ef5', 'Mets le sujet en relief : « Le héros sauve le village. »', '[{"id":"a","text":"C''est le village que le héros sauve."},{"id":"b","text":"C''est le héros qui sauve le village."},{"id":"c","text":"Le village est sauvé par le héros."},{"id":"d","text":"Le héros sauve-t-il le village ?"}]'::jsonb, 'b', 'Pour mettre le SUJET en relief, on emploie le présentatif « c''est… qui » : « C''est le héros qui sauve le village. » L''option a (« c''est… que ») met en relief le COD ; l''option c est une transformation passive ; l''option d est une interrogation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('61b4c2bb-00ff-5be2-8149-7fe96cebfae4', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', '👑 Défi élite : types, formes et transformations', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d9b6ed5-2ef5-5fff-ac60-55e0b8b2fad9', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Identifie le TYPE et TOUTES les formes de la phrase : « N''est-ce pas cette légende qui fut racontée par les anciens ? »', '[{"id":"a","text":"Type déclaratif — formes : négative et passive"},{"id":"b","text":"Type interrogatif — formes : négative, passive et emphatique"},{"id":"c","text":"Type interrogatif — formes : négative et emphatique seulement"},{"id":"d","text":"Type exclamatif — formes : passive et emphatique"}]'::jsonb, 'b', 'La phrase se termine par « ? » et pose une question → type INTERROGATIF. Elle contient « ne… pas » → forme NÉGATIVE. Le verbe « fut racontée par les anciens » est au passif → forme PASSIVE. La structure « c''est… qui » (ici intégrée à l''interrogation) met un élément en relief → forme EMPHATIQUE. Les quatre caractéristiques coexistent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5681cba6-16a7-5d6d-82d8-c3818931e1be', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Transforme à la voix PASSIVE en conservant le temps grammatical : « Les élèves lisaient attentivement le texte. »', '[{"id":"a","text":"Le texte est lu attentivement par les élèves."},{"id":"b","text":"Le texte a été lu attentivement par les élèves."},{"id":"c","text":"Le texte était lu attentivement par les élèves."},{"id":"d","text":"Le texte sera lu attentivement par les élèves."}]'::jsonb, 'c', 'Le verbe actif est à l''IMPARFAIT (« lisaient »). Au passif, l''auxiliaire « être » doit rester à l''imparfait : « était lu ». Le COD « le texte » devient sujet et le participe passé s''accorde avec lui (masculin singulier → « lu »). Le complément d''agent « par les élèves » conserve l''agent original.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f75e68a-b3b0-55c3-9382-e5492e615843', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Mets le COMPLÉMENT D''OBJET DIRECT en relief : « La tempête a détruit le pont. »', '[{"id":"a","text":"C''est le pont que la tempête a détruit."},{"id":"b","text":"C''est le pont qui a détruit la tempête."},{"id":"c","text":"C''est la tempête qui a détruit le pont."},{"id":"d","text":"Le pont a été détruit par la tempête."}]'::jsonb, 'a', 'Pour mettre un COD en relief, on emploie « C''est… QUE » (et non « qui »). Le pont est COD → « C''est le pont QUE la tempête a détruit. » L''option b est agrammaticale (inversion des rôles). L''option c met le SUJET en relief (c''est…qui). L''option d est une transformation au passif, pas une mise en relief emphatique.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('867877d2-a50f-5b3d-802b-ab2e9ce8500d', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Mets à la forme NÉGATIVE en utilisant la négation correspondant au sens exact : « Elle parle encore à quelqu''un. »', '[{"id":"a","text":"Elle ne parle pas encore à quelqu''un."},{"id":"b","text":"Elle ne parle jamais à personne."},{"id":"c","text":"Elle ne parle plus à quelqu''un."},{"id":"d","text":"Elle ne parle plus à personne."}]'::jsonb, 'd', '« encore » (continuité d''une action) s''oppose à « ne… plus » (cessation). « quelqu''un » (une personne) s''oppose à « ne… personne » (aucune personne). Il faut donc COMBINER les deux négations pour rendre fidèlement le sens contraire : « Elle ne parle PLUS à PERSONNE. » L''option a conserve « encore » et n''est pas pleinement négative. L''option b introduit « jamais » qui ne correspond pas à l''opposition de « encore ». L''option c oublie de nier « quelqu''un ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82fdcaf9-70ee-54db-9304-ea970a6d626e', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Laquelle de ces phrases est à la FORME IMPERSONNELLE ?', '[{"id":"a","text":"Il est arrivé tard ce matin."},{"id":"b","text":"Il faut travailler davantage pour réussir."},{"id":"c","text":"Il ne sait pas répondre à la question."},{"id":"d","text":"Il a dit la vérité à ses parents."}]'::jsonb, 'b', 'La forme impersonnelle se reconnaît à un « il » SUJET APPARENT qui ne renvoie à aucune personne ou chose réelle — le vrai sujet est logique (infinitif ou proposition). « Il faut travailler » : « il » est sujet apparent, « travailler » est le vrai sujet logique. Options a, c et d : « il » désigne une personne réelle ou remplace un sujet identifiable — ces phrases sont à la forme personnelle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfcac64e-20bb-5243-b94e-f9ca32b9656e', '61b4c2bb-00ff-5be2-8149-7fe96cebfae4', 'Transforme à la voix PASSIVE (le complément d''agent doit être supprimé si la règle l''exige) : « On a réparé la route après la tempête. »', '[{"id":"a","text":"La route a été réparée après la tempête par on."},{"id":"b","text":"La route fut réparée après la tempête."},{"id":"c","text":"La route a été réparée après la tempête."},{"id":"d","text":"La route est réparée après la tempête par on."}]'::jsonb, 'c', 'Quand le sujet actif est « ON », la transformation au passif SUPPRIME le complément d''agent (on ne dit pas « par on »). Le verbe actif est au PASSÉ COMPOSÉ (« a réparé ») → le passif se forme avec « avoir été » : « a été réparée ». Le participe passé s''accorde avec le nouveau sujet féminin singulier « la route » → « réparée ». Option b utilise le passé simple (changement de temps injustifié). Options a et d conservent « par on », ce qui est agrammatical.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fdef87db-3a52-50ab-8803-b009147266cb', '5abb4fbd-3a97-5ce3-b0c4-90a84acfcbe2', 'french', '🛡️ Entraînement examen : types et formes de phrases', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88975673-9739-5d79-8e8d-d2d7134aa3db', 'fdef87db-3a52-50ab-8803-b009147266cb', 'À quel type appartient la phrase : « Quel courage tu as montré ! » ?', '[{"id":"a","text":"Type déclaratif"},{"id":"b","text":"Type interrogatif"},{"id":"c","text":"Type exclamatif"},{"id":"d","text":"Type injonctif"}]'::jsonb, 'c', 'Le point d''exclamation et la tournure « Quel… » expriment un sentiment fort : c''est une phrase exclamative. Le type déclaratif (a) se termine par un point et énonce un fait ; l''interrogatif (b) pose une question ; l''injonctif (d) donne un ordre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2146fe9-522d-579e-8126-78cb344ed44d', 'fdef87db-3a52-50ab-8803-b009147266cb', 'Quelle phrase est une phrase emphatique (de forme emphatique) ?', '[{"id":"a","text":"Le héros a vaincu le dragon."},{"id":"b","text":"C''est le héros qui a vaincu le dragon."},{"id":"c","text":"Le héros a-t-il vaincu le dragon ?"},{"id":"d","text":"Le dragon a été vaincu par le héros."}]'::jsonb, 'b', 'La forme emphatique met un élément en relief, ici grâce au présentatif « c''est… qui ». L''option a est neutre, c est interrogative, d est passive (donc une voix, non une forme emphatique).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('593810f6-c884-519f-9a58-a9c23081bbd4', 'fdef87db-3a52-50ab-8803-b009147266cb', 'Transforme en interrogation totale par inversion : « Vous partez demain. »', '[{"id":"a","text":"Quand partez-vous ?"},{"id":"b","text":"Est-ce que vous partez demain."},{"id":"c","text":"Partez-vous demain ?"},{"id":"d","text":"Vous partez demain ?"}]'::jsonb, 'c', 'L''interrogation totale appelle une réponse oui/non et l''inversion place le sujet après le verbe avec un trait d''union : « Partez-vous demain ? ». L''option a est partielle (mot interrogatif « quand ») ; b emploie « est-ce que » et finit par un point ; d garde l''ordre déclaratif (interrogation par intonation, sans inversion).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3833318-8711-50e7-ab12-5d09fc7a0c34', 'fdef87db-3a52-50ab-8803-b009147266cb', 'Quelle phrase est de type injonctif ?', '[{"id":"a","text":"Tu fermes la porte."},{"id":"b","text":"Ferme la porte."},{"id":"c","text":"As-tu fermé la porte ?"},{"id":"d","text":"La porte est fermée."}]'::jsonb, 'b', 'La phrase injonctive donne un ordre ou un conseil, souvent à l''impératif : « Ferme la porte. ». L''option a est déclarative (verbe à l''indicatif présent), c est interrogative, d est déclarative.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c43ebd4e-b373-5147-8a23-30bd9aed1145', 'fdef87db-3a52-50ab-8803-b009147266cb', 'Mets à la forme négative : « Tout le monde est venu. »', '[{"id":"a","text":"Tout le monde n''est pas venu."},{"id":"b","text":"Personne n''est venu."},{"id":"c","text":"Tout le monde est venu pas."},{"id":"d","text":"Rien n''est venu."}]'::jsonb, 'b', 'Le contraire de « tout le monde » (toutes les personnes) est « personne n''… » : « Personne n''est venu. » L''option a signifie « pas tous », ce qui n''est pas la négation totale attendue ; c est agrammaticale ; « rien » (d) désigne une chose, pas une personne.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc9408ca-e18d-50e5-b964-ffc8acadf596', 'fdef87db-3a52-50ab-8803-b009147266cb', 'Identifie le type ET la forme de : « N''as-tu jamais lu ce livre ? »', '[{"id":"a","text":"Interrogative et négative"},{"id":"b","text":"Déclarative et négative"},{"id":"c","text":"Interrogative et affirmative"},{"id":"d","text":"Exclamative et négative"}]'::jsonb, 'a', 'Le point d''interrogation et l''inversion (« as-tu ») marquent le type interrogatif ; « ne… jamais » marque la forme négative : la phrase est interrogative et négative. Elle n''est ni déclarative (b), ni affirmative (c, contredit par « ne… jamais »), ni exclamative (d, pas de point d''exclamation).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd3e5a8a-d94f-58a0-8c6f-8838b820e67a', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'Qu''est-ce qu''une proposition subordonnée ?', '[{"id":"a","text":"Une proposition autonome qui a un sens complet."},{"id":"b","text":"Une proposition qui dépend de la principale et ne peut pas se lire seule sans perdre son sens."},{"id":"c","text":"Une proposition qui contient toujours un pronom relatif."},{"id":"d","text":"Une proposition qui exprime toujours une condition."}]'::jsonb, 'b', 'La proposition subordonnée dépend de la principale : supprimée, la principale garde son sens ; mais la subordonnée seule perd le sien. Elle est introduite par un subordonnant.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef679ede-b207-51a6-b679-e6d7ec83f53a', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'Quel pronom relatif est employé lorsque la subordonnée relative a la fonction de sujet ?', '[{"id":"a","text":"que"},{"id":"b","text":"dont"},{"id":"c","text":"qui"},{"id":"d","text":"où"}]'::jsonb, 'c', '« qui » est le pronom relatif sujet : « Le héros qui combat le dragon est courageux. » Le pronom relatif COD est « que », et « dont » remplace un groupe introduit par « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e6d1a0e-ebba-5662-9b50-235bc8111b80', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'La subordonnée complétive est introduite par la conjonction « que » et a la fonction de :', '[{"id":"a","text":"Complément circonstanciel de cause"},{"id":"b","text":"COD du verbe principal"},{"id":"c","text":"Sujet de la proposition principale"},{"id":"d","text":"Complément d''agent"}]'::jsonb, 'b', 'La subordonnée complétive est COD du verbe principal et peut être remplacée par « cela » : « Je crois que le héros vaincra. » → « Je crois cela. »', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('051afec1-27e6-5b01-a35c-113fd8d1d9cc', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'Quelle conjonction introduit une subordonnée de but et exige le subjonctif ?', '[{"id":"a","text":"parce que"},{"id":"b","text":"si bien que"},{"id":"c","text":"pour que"},{"id":"d","text":"après que"}]'::jsonb, 'c', '« pour que » (ainsi qu''« afin que ») introduit une subordonnée de but, toujours au subjonctif : « Il s''entraîne pour que son équipe gagne. »', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('940021d7-b5b4-5449-83ea-ce2fbc279ff3', '28b6e6d9-1123-5ff7-8652-ff24bca1258a', 'Dans la phrase conditionnelle « Si tu t''entraînais, tu vaincrais. », quel est le temps du verbe dans la subordonnée introduite par « si » ?', '[{"id":"a","text":"Le futur simple"},{"id":"b","text":"Le conditionnel présent"},{"id":"c","text":"L''imparfait"},{"id":"d","text":"Le subjonctif présent"}]'::jsonb, 'c', 'Après « si » de condition exprimant un fait éventuel (hypothèse), on emploie l''imparfait dans la subordonnée et le conditionnel présent dans la principale. On n''emploie jamais le futur ni le conditionnel après « si ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('03ebf9d6-a2d7-5967-b86c-70019206e357', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', 'Exercice : reconnaître les propositions subordonnées', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d645eccd-a5d0-5aeb-9284-79aab3b2de20', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « La forêt où il entra était sombre. », le pronom relatif « où » a la fonction de :', '[{"id":"a","text":"Sujet"},{"id":"b","text":"COD"},{"id":"c","text":"Complément d''agent"},{"id":"d","text":"Complément de lieu"}]'::jsonb, 'd', '« où » reprend « la forêt » (lieu) et joue le rôle de complément de lieu dans la subordonnée relative.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b8817ab-0b1e-5d97-9a7b-8fd6753ca908', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « Je sais que tu réussiras. », la proposition « que tu réussiras » est :', '[{"id":"a","text":"Une subordonnée relative qualifiant « tu »"},{"id":"b","text":"Une subordonnée complétive, COD de « sais »"},{"id":"c","text":"Une subordonnée circonstancielle de cause"},{"id":"d","text":"Une proposition principale"}]'::jsonb, 'b', 'La proposition est introduite par « que », COD du verbe « savoir » : c''est une subordonnée complétive.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07e8045b-b474-56cb-88ee-a5cc0e713ffa', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Quel pronom relatif complète correctement la phrase : « L''épée ___ il se sert est magique. »', '[{"id":"a","text":"dont"},{"id":"b","text":"que"},{"id":"c","text":"qui"},{"id":"d","text":"où"}]'::jsonb, 'a', '« se servir de » → on remplace le groupe « de l''épée » par « dont » : « l''épée dont il se sert ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cff983e1-a078-56c3-96fc-1bc3c9f70b8e', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Quelle conjonction introduit une subordonnée de but ?', '[{"id":"a","text":"parce que"},{"id":"b","text":"si bien que"},{"id":"c","text":"pour que"},{"id":"d","text":"bien que"}]'::jsonb, 'c', '« pour que » exprime le but et introduit une subordonnée au subjonctif. « parce que » = cause, « si bien que » = conséquence, « bien que » = concession.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e3fc6c2-7f49-579a-9766-20a7860eca17', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Dans « Bien qu''il soit fatigué, il continue. », la subordonnée est une circonstancielle de :', '[{"id":"a","text":"Cause"},{"id":"b","text":"Temps"},{"id":"c","text":"Condition"},{"id":"d","text":"Concession"}]'::jsonb, 'd', '« bien que » + subjonctif exprime un obstacle qui ne bloque pas l''action : c''est la concession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('308d579a-062a-5895-abfd-e1a05a0356de', '03ebf9d6-a2d7-5967-b86c-70019206e357', 'Choisissez la forme correcte : « Les batailles ___ nous avons livrées ont forgé notre courage. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'a', 'Le pronom relatif est COD du verbe « livrer » (on a livré les batailles) : on emploie « que ». Le participe « livrées » s''accorde avec l''antécédent féminin pluriel « batailles ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', '⚔️ Boss : maîtriser la phrase complexe', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c19c1f96-69fa-5f06-a875-55bcfda850ce', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Dans « Dès qu''il arriva, le combat commença. », la subordonnée est une circonstancielle de :', '[{"id":"a","text":"Cause"},{"id":"b","text":"Temps (simultanéité immédiate)"},{"id":"c","text":"Conséquence"},{"id":"d","text":"Concession"}]'::jsonb, 'b', '« dès que » indique que les deux actions se suivent immédiatement : c''est une circonstancielle de temps.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98016972-94e1-5f90-9b1e-f59b43d6b0ae', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Complétez : « Il s''entraîne tous les jours ___ son équipe remporte la victoire. »', '[{"id":"a","text":"pour que"},{"id":"b","text":"parce que"},{"id":"c","text":"si bien que"},{"id":"d","text":"quand"}]'::jsonb, 'a', 'L''entraînement vise un résultat futur (la victoire de l''équipe) : on exprime le but avec « pour que » + subjonctif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('851ee672-a02e-5b39-85ab-663ccff5fccd', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Identifiez la proposition principale dans : « Comme il pleuvait, il prit son bouclier. »', '[{"id":"a","text":"Comme il pleuvait"},{"id":"b","text":"il pleuvait"},{"id":"c","text":"son bouclier"},{"id":"d","text":"il prit son bouclier"}]'::jsonb, 'd', '« Comme il pleuvait » est la subordonnée de cause. La proposition principale, autonome et porteuse de l''information principale, est « il prit son bouclier ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78994701-0a13-5aa5-b908-e0dc7fa8fd7a', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Dans « Le guerrier que la foule acclame lève son épée. », quel est l''antécédent du pronom relatif « que » ?', '[{"id":"a","text":"la foule"},{"id":"b","text":"son épée"},{"id":"c","text":"Le guerrier"},{"id":"d","text":"acclame"}]'::jsonb, 'c', '« que » reprend le nom qui précède immédiatement la relative : « le guerrier » — c''est lui qui est acclamé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('733b88c0-3f49-56a9-a7a5-beb1ccab73cf', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Quelle phrase utilise correctement « si » de condition ?', '[{"id":"a","text":"Si tu t''entraîneras, tu vaincras."},{"id":"b","text":"Si tu t''entraînerais, tu vaincrais."},{"id":"c","text":"Si tu t''entraînes, tu vaincrais."},{"id":"d","text":"Si tu t''entraînes, tu vaincras."}]'::jsonb, 'd', 'Avec « si » de condition (réel), la subordonnée est au présent et la principale au futur : « Si tu t''entraînes, tu vaincras. » On n''emploie jamais futur ni conditionnel après « si ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67a0c11d-ab91-59df-b1f1-e411d1e2cb95', '2eac0b4b-84dd-5f90-a06c-9eb9e6d1eec3', 'Choisissez la forme verbale correcte : « Il parle doucement de peur qu''on ne l''___ . »', '[{"id":"a","text":"entend"},{"id":"b","text":"entendra"},{"id":"c","text":"entende"},{"id":"d","text":"entendrait"}]'::jsonb, 'c', '« de peur que » exprime le but (crainte) et impose le subjonctif présent : « entende ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', '👑 Défi élite : propositions subordonnées', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8697075-71ce-56a1-987c-a1f9cc79846a', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Dans « Je me souviens des leçons que le maître nous a enseignées », quelle est la nature de la proposition soulignée « que le maître nous a enseignées » et quelle est la fonction de « que » dans cette proposition ?', '[{"id":"a","text":"Subordonnée complétive – « que » est conjonction de subordination, sans fonction propre"},{"id":"b","text":"Subordonnée relative – « que » est pronom relatif, COD du verbe « a enseignées »"},{"id":"c","text":"Subordonnée relative – « que » est pronom relatif, sujet du verbe « a enseignées »"},{"id":"d","text":"Subordonnée complétive – « que » est pronom relatif, COD du verbe « a enseignées »"}]'::jsonb, 'b', 'La proposition qualifie l''antécédent « les leçons » : c''est une subordonnée relative. Dans cette relative, « que » est pronom relatif et remplace « les leçons », qui est l''objet de « a enseignées » (COD). La preuve : le participe passé s''accorde au féminin pluriel avec cet antécédent, ce qui est propre à la relative avec « avoir », jamais à la complétive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d3ba807-5296-5b3b-b100-06baba0b4726', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Dans « Le roman dont les personnages me fascinent est un chef-d''œuvre », quelle est la fonction de « dont » à l''intérieur de la proposition subordonnée relative ?', '[{"id":"a","text":"Complément d''objet direct du verbe « fascinent »"},{"id":"b","text":"Sujet du verbe « fascinent »"},{"id":"c","text":"Complément du nom « personnages »"},{"id":"d","text":"Complément d''objet indirect du verbe « fascinent »"}]'::jsonb, 'c', 'Dans cette relative, « dont » équivaut à « de ce roman » et se rattache au nom « personnages » : « les personnages de ce roman ». Il occupe donc la fonction de complément du nom (déterminatif), et non de complément du verbe. C''est une construction fréquente avec « dont » qui piège les candidats.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de3152a5-2625-51bc-97a3-b2ee29cbb5a6', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Choisissez la forme verbale grammaticalement correcte : « Après qu''il ___ la forteresse, l''armée célébra sa victoire. »', '[{"id":"a","text":"ait pris"},{"id":"b","text":"eût pris"},{"id":"c","text":"eut pris"},{"id":"d","text":"prenne"}]'::jsonb, 'c', '« Après que » exprime la postériorité et se construit avec l''indicatif (jamais le subjonctif). Comme la principale est au passé simple, la subordonnée exprime une action antérieure : on emploie le passé antérieur de l''indicatif : « eut pris ». Le subjonctif passé (« ait pris ») ou plus-que-parfait du subjonctif (« eût pris ») sont fautifs après « après que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb5483c3-b3c7-58be-8735-6e1c7d30764b', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Dans la phrase complexe « Le général croit que l''armée qui le suit vaincra l''ennemi », combien de propositions compte-t-on et laquelle est la proposition principale ?', '[{"id":"a","text":"Deux propositions ; principale : « le général croit »"},{"id":"b","text":"Trois propositions ; principale : « Le général croit »"},{"id":"c","text":"Trois propositions ; principale : « que l''armée qui le suit vaincra l''ennemi »"},{"id":"d","text":"Deux propositions ; principale : « l''armée vaincra l''ennemi »"}]'::jsonb, 'b', 'La phrase contient trois propositions : (1) « Le général croit » — principale ; (2) « que l''armée… vaincra l''ennemi » — subordonnée complétive, COD de « croit » ; (3) « qui le suit » — subordonnée relative enchâssée dans la complétive, qualifiant « l''armée ». La principale est bien « Le général croit » : c''est la seule qui soit autonome.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a600da65-51d7-52b5-aa7f-11fa86b62d26', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Dans « Les épreuves que ces élèves ont surmontées les ont rendus plus forts », le participe passé « surmontées » est au féminin pluriel. Pourquoi ?', '[{"id":"a","text":"Parce qu''il s''accorde avec « élèves », sujet du verbe de la relative"},{"id":"b","text":"Parce qu''il s''accorde avec « que », pronom relatif qui représente « les épreuves » (féminin pluriel), antécédent placé avant l''auxiliaire « avoir »"},{"id":"c","text":"Parce que le participe passé s''accorde toujours avec le sujet de la proposition principale"},{"id":"d","text":"Parce qu''il s''accorde avec « elles » (les épreuves), sujet sous-entendu de la principale"}]'::jsonb, 'b', 'Avec l''auxiliaire « avoir », le participe passé s''accorde avec le COD lorsque celui-ci est placé avant le verbe. Ici, « que » est le pronom relatif COD de « ont surmontées » ; il représente son antécédent « les épreuves » (féminin pluriel). Le participe prend donc la marque du féminin pluriel : « surmontées ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a99cc03-d6f9-52f4-bdc4-9f531267885c', 'e98faad8-fe63-51d3-93ec-1a7da7198b3a', 'Laquelle de ces quatre phrases emploie correctement et avec la nuance la plus précise la conjonction de subordination causale en contexte d''examen ?', '[{"id":"a","text":"« Puisqu''il n''avait pas révisé, il échoua à l''examen. » (la cause est ignorée de l''interlocuteur)"},{"id":"b","text":"« Comme il avait bien révisé, il obtint une excellente note. » (la cause est placée en tête de phrase et présentée comme un fait connu ou évident)"},{"id":"c","text":"« Parce que tu es intelligent, tu réussiras sûrement. » (la cause est inconnue de l''interlocuteur et présentée pour la première fois)"},{"id":"d","text":"« Puisqu''il pleuvait, personne ne savait encore pourquoi il était rentré. » (la cause est présentée comme nouvelle et surprenante)"}]'::jsonb, 'b', '« Comme » causal se place obligatoirement en tête de phrase et introduit une cause présentée comme un fait établi ou évident : c''est son emploi correct et précis. — « Puisque » s''emploie pour une cause déjà connue des deux interlocuteurs : la phrase (a) l''utilise à tort pour une cause ignorée. — La phrase (c) confond « parce que » (cause directe et nouvelle) avec le compliment implicite : l''usage n''est pas fautif mais la description « inconnue » est inexacte ici. — La phrase (d) est incorrecte : « puisque » ne peut pas introduire une cause « nouvelle et surprenante ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'a6b09d55-6979-5a0c-99a4-248f315de0e4', 'french', '🛡️ Entraînement examen : les propositions subordonnées', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52a2766e-fcf5-56ae-8559-494d2b9907ec', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Dans « Je connais l''élève qui a gagné le concours. », la proposition subordonnée est :', '[{"id":"a","text":"Une subordonnée relative"},{"id":"b","text":"Une subordonnée complétive"},{"id":"c","text":"Une subordonnée circonstancielle de temps"},{"id":"d","text":"Une proposition indépendante"}]'::jsonb, 'a', '« qui a gagné le concours » est introduite par le pronom relatif « qui » et complète le nom « élève » (son antécédent) : c''est une subordonnée relative. Une complétive (b) est introduite par « que » et complète un verbe ; une circonstancielle de temps (c) répond à « quand ? » ; ce n''est pas une indépendante (d) car elle dépend de la principale.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b544c55-62e7-53a6-8c54-030638b09322', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Quelle phrase contient une subordonnée complétive (conjonctive par « que ») ?', '[{"id":"a","text":"Le livre que tu lis est passionnant."},{"id":"b","text":"Je pense que tu as raison."},{"id":"c","text":"Il viendra quand il pourra."},{"id":"d","text":"C''est la maison où je suis né."}]'::jsonb, 'b', '« que tu as raison » complète le verbe « pense » et joue le rôle de COD : c''est une complétive. Dans a, « que » est pronom relatif (antécédent « livre ») ; dans c, « quand » introduit une circonstancielle de temps ; dans d, « où » est un pronom relatif (subordonnée relative).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0d6bad5-c558-5387-b3c9-4a8b167cc412', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Quel subordonnant introduit une subordonnée circonstancielle de but ?', '[{"id":"a","text":"parce que"},{"id":"b","text":"afin que"},{"id":"c","text":"lorsque"},{"id":"d","text":"si bien que"}]'::jsonb, 'b', '« afin que » (suivi du subjonctif) exprime le but, l''objectif visé. « parce que » introduit la cause (a), « lorsque » le temps (c), « si bien que » la conséquence (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('348dc8e4-92e9-52f8-a85a-8fc5dfb3dfdb', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Dans « Bien qu''il soit fatigué, il continue de courir. », quelle est la nature de la subordonnée ?', '[{"id":"a","text":"Subordonnée circonstancielle de cause"},{"id":"b","text":"Subordonnée circonstancielle de but"},{"id":"c","text":"Subordonnée circonstancielle de concession (opposition)"},{"id":"d","text":"Subordonnée relative"}]'::jsonb, 'c', '« Bien que » introduit une concession : on exprime un obstacle qui n''empêche pourtant pas l''action (il court malgré la fatigue). « Parce que » marquerait la cause (a), « pour que » le but (b), un pronom relatif une relative (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b356e2bc-7641-5bd1-973a-cf751b424915', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Dans « La ville où je vis est ancienne. », quelle est la fonction du pronom relatif « où » ?', '[{"id":"a","text":"Complément circonstanciel de lieu (dans la subordonnée)"},{"id":"b","text":"Sujet de « vis »"},{"id":"c","text":"COD de « vis »"},{"id":"d","text":"Attribut du sujet"}]'::jsonb, 'a', '« où » remplace « dans la ville » et indique le lieu où se déroule l''action « je vis » : il est complément circonstanciel de lieu. Le sujet de « vis » est « je » (b) ; « vivre » ici est intransitif, donc pas de COD (c) ; « où » n''est pas un attribut (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27b8f517-f017-58a8-a0a8-0e44ba9ca0cd', 'b0b98885-5cc3-53b6-bbf4-42a6fbd10edd', 'Quelle phrase ne contient AUCUNE proposition subordonnée ?', '[{"id":"a","text":"Il pleut, mais nous sortons quand même."},{"id":"b","text":"J''espère que tu réussiras."},{"id":"c","text":"Je lis le roman que tu m''as offert."},{"id":"d","text":"Comme il pleut, nous restons."}]'::jsonb, 'a', 'Dans a, « mais » coordonne deux propositions indépendantes : il n''y a pas de subordination. En b, « que tu réussiras » est une complétive ; en c, « que tu m''as offert » est une relative ; en d, « Comme il pleut » est une circonstancielle de cause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a4ba085-73fa-5f77-bfdc-a81caab9b51e', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', 'Quelle est la structure du groupe verbal à la voix passive ?', '[{"id":"a","text":"Verbe conjugué normalement"},{"id":"b","text":"Auxiliaire « avoir » + participe passé"},{"id":"c","text":"Auxiliaire « être » conjugué + participe passé accordé avec le sujet"},{"id":"d","text":"Verbe à l''infinitif précédé de « faire »"}]'::jsonb, 'c', 'La voix passive se construit avec l''auxiliaire « être » conjugué au temps voulu, suivi du participe passé qui s''accorde en genre et en nombre avec le sujet.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75e4d82d-47e0-5432-b840-67558c7322b8', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', 'Lors de la transformation active → passive, que devient le COD de la phrase active ?', '[{"id":"a","text":"Le complément d''agent de la phrase passive"},{"id":"b","text":"Le sujet de la phrase passive"},{"id":"c","text":"Il disparaît de la phrase"},{"id":"d","text":"L''attribut du sujet passif"}]'::jsonb, 'b', 'Règle de transformation : le COD de la phrase active devient le sujet de la phrase passive ; l''ancien sujet actif devient le complément d''agent introduit par « par » ou « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fec6335-9472-5469-846a-75981fedeba3', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', 'Quel type de verbe NE peut PAS se mettre à la voix passive ?', '[{"id":"a","text":"Un verbe transitif direct comme « corriger »"},{"id":"b","text":"Un verbe transitif direct comme « frapper »"},{"id":"c","text":"Un verbe intransitif comme « dormir »"},{"id":"d","text":"Un verbe transitif direct comme « lire »"}]'::jsonb, 'c', 'Seuls les verbes transitifs directs (qui ont un COD) peuvent se mettre à la voix passive. Les verbes intransitifs comme « dormir », « partir » ou « ressembler à » ne le peuvent pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19564ab9-63a3-530c-a139-4913f70fcd20', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', 'Comment transforme-t-on à la voix active la phrase passive « La porte a été fermée. » quand il n''y a pas de complément d''agent ?', '[{"id":"a","text":"Ils ont fermé la porte."},{"id":"b","text":"La porte ferme."},{"id":"c","text":"On a fermé la porte."},{"id":"d","text":"La porte fermait."}]'::jsonb, 'c', 'Quand la phrase passive n''a pas de complément d''agent, on utilise le sujet indéfini « on » à la voix active : « La porte a été fermée. » → « On a fermé la porte. »', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('783bb08e-d6a7-5d72-ae16-851a5e696425', 'a5ad7b9f-577b-53bd-a84c-f6b7fb550adc', 'Quel est l''intérêt stylistique principal de la voix passive ?', '[{"id":"a","text":"Elle met en avant celui qui agit (le sujet-agent)."},{"id":"b","text":"Elle met en avant celui qui subit l''action (l''objet devenu sujet)."},{"id":"c","text":"Elle simplifie toujours la phrase."},{"id":"d","text":"Elle exprime une hypothèse."}]'::jsonb, 'b', 'La voix passive met en lumière celui qui subit l''action. Ex. : « La vérité est révélée par le journaliste. » → l''accent est sur la vérité, pas sur le journaliste.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('12f9cc53-1641-5e87-9958-ae1375000007', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', 'Exercice : reconnaître et transformer les voix', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96225451-0ff2-5e30-ab72-ea01d8573838', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quelle phrase est à la voix passive ?', '[{"id":"a","text":"La secrétaire rédige le rapport."},{"id":"b","text":"Le rapport est rédigé par la secrétaire."},{"id":"c","text":"La secrétaire a rédigé un long rapport."},{"id":"d","text":"Rédige ce rapport !"}]'::jsonb, 'b', 'La structure « être conjugué + participe passé + complément d''agent (par la secrétaire) » caractérise la voix passive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad7aa3eb-7915-51a2-8ad8-f71a33b99fb1', '12f9cc53-1641-5e87-9958-ae1375000007', 'Dans « Le gâteau est mangé. », le complément d''agent est :', '[{"id":"a","text":"« le gâteau »"},{"id":"b","text":"Absent : on ne sait pas qui mange le gâteau."},{"id":"c","text":"« est »"},{"id":"d","text":"« mangé »"}]'::jsonb, 'b', 'La phrase passive ne contient aucun groupe introduit par « par » ou « de » : le complément d''agent est absent. L''agent est inconnu ou sans importance.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3e2ab45-089e-5a99-b92a-87cbb5576dde', '12f9cc53-1641-5e87-9958-ae1375000007', 'Transforme à la voix passive : « Le vent renverse les arbres. »', '[{"id":"a","text":"Les arbres renversent le vent."},{"id":"b","text":"Le vent est renversé par les arbres."},{"id":"c","text":"Les arbres ont été renversés par le vent."},{"id":"d","text":"Les arbres sont renversés par le vent."}]'::jsonb, 'd', 'Le COD « les arbres » devient sujet ; le sujet « le vent » devient complément d''agent ; le présent est conservé : « sont renversés ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36a444de-1993-5b9a-8fb0-9a5cfe7f77b6', '12f9cc53-1641-5e87-9958-ae1375000007', 'Transforme à la voix active : « La lettre a été écrite par Marie. »', '[{"id":"a","text":"Marie a écrit la lettre."},{"id":"b","text":"Marie écrit la lettre."},{"id":"c","text":"La lettre a écrit Marie."},{"id":"d","text":"Marie avait écrit la lettre."}]'::jsonb, 'a', 'Le complément d''agent « Marie » devient sujet et on conserve le passé composé : « a écrit ». Le sujet passif « la lettre » devient COD.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fde829bd-4a35-5b7a-980b-d9373c4bb855', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quel est le temps de la phrase passive « Le château sera reconstruit par les habitants. » ?', '[{"id":"a","text":"Présent"},{"id":"b","text":"Passé composé"},{"id":"c","text":"Futur simple"},{"id":"d","text":"Conditionnel présent"}]'::jsonb, 'c', 'L''auxiliaire « être » est conjugué au futur simple (« sera »), ce qui donne la voix passive au futur : « sera reconstruit ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d7569dc-adcd-5490-8ab4-9e1252876fbc', '12f9cc53-1641-5e87-9958-ae1375000007', 'Quel participe passé s''accorde correctement dans : « Les victoires ___ (remporter) par notre équipe nous rendent fiers. » ?', '[{"id":"a","text":"remportées"},{"id":"b","text":"remporté"},{"id":"c","text":"remportés"},{"id":"d","text":"remporter"}]'::jsonb, 'a', 'Le sujet du verbe passif est « les victoires » (féminin pluriel) : le participe passé s''accorde en genre et en nombre → « remportées ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', '⚔️ Boss : maîtriser la voix passive', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b271bbf-7019-55aa-93bb-583c3fbb407a', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Transforme à la voix active : « Le vainqueur était acclamé de toute la foule. »', '[{"id":"a","text":"Toute la foule a acclamé le vainqueur."},{"id":"b","text":"Toute la foule acclamait le vainqueur."},{"id":"c","text":"Le vainqueur acclamait toute la foule."},{"id":"d","text":"On acclamait le vainqueur."}]'::jsonb, 'b', 'Le complément d''agent « de toute la foule » (introduit par « de ») devient sujet ; on conserve l''imparfait : « acclamait ». Le sujet passif « le vainqueur » devient COD.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('332e1995-cf27-5529-9e9c-87c94efb4982', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Dans quelle phrase l''accord du participe passé est-il correct ?', '[{"id":"a","text":"Les lois ont été respectées par tous les citoyens."},{"id":"b","text":"Les lois ont été respecté par tous les citoyens."},{"id":"c","text":"Les lois ont été respectés par tous les citoyens."},{"id":"d","text":"Les lois ont été respectée par tous les citoyens."}]'::jsonb, 'a', 'Le sujet du verbe passif est « les lois » (féminin pluriel) : le participe passé s''accorde → « respectées ». Les options b, c, d sont mal accordées.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c1cd36e-d806-5894-a665-34368ab1f4bc', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Pourquoi la phrase « Cette forêt est traversée. » est-elle stylistiquement intéressante sans complément d''agent ?', '[{"id":"a","text":"Elle indique que la forêt fait l''action."},{"id":"b","text":"Elle est incorrecte : la voix passive exige un complément d''agent."},{"id":"c","text":"Elle met l''accent sur la forêt et dépersonnalise l''action."},{"id":"d","text":"Elle exprime une condition."}]'::jsonb, 'c', 'Sans complément d''agent, la voix passive met en avant l''objet de l''action (« cette forêt ») et efface volontairement l''agent : c''est un effet stylistique de dépersonnalisation ou de généralisation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6abd4b21-6d1c-51e3-9607-d615dae991a3', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Transforme à la voix passive en conservant le temps : « Les soldats avaient défendu la forteresse. »', '[{"id":"a","text":"La forteresse avait été défendue par les soldats."},{"id":"b","text":"La forteresse a été défendue par les soldats."},{"id":"c","text":"La forteresse était défendue par les soldats."},{"id":"d","text":"La forteresse fut défendue par les soldats."}]'::jsonb, 'a', 'La phrase active est au plus-que-parfait : l''auxiliaire « être » se met au plus-que-parfait (« avait été ») + participe passé accordé au féminin singulier → « avait été défendue ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d1e84a5-a743-5748-b970-cc7eda950ebc', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Quelle transformation est correcte ? Phrase de départ : « On a détruit ce pont pendant la guerre. »', '[{"id":"a","text":"Ce pont a été détruit par on pendant la guerre."},{"id":"b","text":"Ce pont est détruit pendant la guerre."},{"id":"c","text":"Ce pont avait été détruit pendant la guerre."},{"id":"d","text":"Ce pont a été détruit pendant la guerre."}]'::jsonb, 'd', 'Quand le sujet actif est « on », on le supprime à la voix passive : le complément d''agent est absent. Le passé composé passif donne « a été détruit ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f22c973f-b551-5ada-b930-ce0801010307', '0cec718c-9b55-5aa5-b40e-ad20fffbe4ed', 'Quelle phrase contient une erreur dans la transformation active → passive ?', '[{"id":"a","text":"Le chien a mordu Paul. → Paul a été mordu par le chien. ✓"},{"id":"b","text":"Les élèves ont applaudi la pièce. → La pièce a été applaudi par les élèves."},{"id":"c","text":"La pluie abîme les récoltes. → Les récoltes sont abîmées par la pluie. ✓"},{"id":"d","text":"Le professeur punira l''élève. → L''élève sera puni par le professeur. ✓"}]'::jsonb, 'b', 'Le sujet passif est « la pièce » (féminin singulier) : le participe passé doit s''accorder → « applaudie ». C''est donc l''option b qui comporte l''erreur d''accord (« applaudi » au lieu de « applaudie ») ; les options a, c et d sont correctes.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6964cb06-f67d-56f4-a779-bbbe567f265c', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', '👑 Défi élite : voix active et passive', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47c9ba09-be77-5e69-9af8-8b89d56d6402', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'Transforme à la voix passive en conservant le temps : « Les archéologues auront découvert ces vestiges avant la fin du chantier. »', '[{"id":"a","text":"Ces vestiges auront été découverts par les archéologues avant la fin du chantier."},{"id":"b","text":"Ces vestiges ont été découverts par les archéologues avant la fin du chantier."},{"id":"c","text":"Ces vestiges avaient été découverts par les archéologues avant la fin du chantier."},{"id":"d","text":"Ces vestiges seront découverts par les archéologues avant la fin du chantier."}]'::jsonb, 'a', 'La phrase active est au futur antérieur (« auront découvert »). Au passif, l''auxiliaire « être » se met au futur antérieur : « auront été » + participe passé accordé avec le nouveau sujet « ces vestiges » (masculin pluriel) → « découverts ». Les options b (passé composé), c (plus-que-parfait) et d (futur simple) ne conservent pas le futur antérieur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bb46e0f-1ca3-5dfc-bab0-c7a2e1f611e3', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'Transforme à la voix active en rétablissant l''agent comme sujet : « Ce roman aurait été apprécié des lecteurs avertis. »', '[{"id":"a","text":"Des lecteurs avertis ont apprécié ce roman."},{"id":"b","text":"Les lecteurs avertis apprécient ce roman."},{"id":"c","text":"Les lecteurs avertis auraient apprécié ce roman."},{"id":"d","text":"On aurait apprécié ce roman."}]'::jsonb, 'c', 'Le complément d''agent « des lecteurs avertis » (introduit ici par « de », usage des verbes de sentiment) devient sujet à la voix active. Le temps est le conditionnel présent (« aurait été apprécié ») : à la voix active, le verbe se met donc au conditionnel présent → « auraient apprécié ». L''option a fausse le temps (passé composé), b fausse le temps (présent), d efface l''agent au lieu de le rétablir.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1061e3a4-4d8c-545b-a98c-2dd987472eaa', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'Laquelle de ces phrases ne peut PAS être mise à la voix passive, et pourquoi ?', '[{"id":"a","text":"« La foule a applaudi le discours. » — ne peut pas se mettre au passif car le sujet est indéfini."},{"id":"b","text":"« Le directeur a renoncé à ce projet. » — ne peut pas se mettre au passif car « renoncer à » est un verbe transitif indirect (son complément est introduit par « à », pas un COD)."},{"id":"c","text":"« L''arbitre a sifflé la faute. » — ne peut pas se mettre au passif car « siffler » est un verbe intransitif."},{"id":"d","text":"« Les élèves avaient préparé l''exposé. » — ne peut pas se mettre au passif car le sujet est pluriel."}]'::jsonb, 'b', 'Seuls les verbes transitifs directs (ayant un COD) peuvent se mettre à la voix passive. « Renoncer à » est un verbe transitif indirect : son complément est introduit par la préposition « à » et ne constitue pas un COD — la transformation au passif est donc impossible. « Applaudir » (option a) et « siffler » (option c) sont bien transitifs directs et se mettent au passif ; le pluriel du sujet (option d) n''empêche jamais la transformation passive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a6d6d54-fab2-5da9-b165-6880b7d6dfde', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'Quelle est la transformation passive correcte de : « Le jury a condamné les accusées » ?', '[{"id":"a","text":"Les accusées ont été condamnés par le jury."},{"id":"b","text":"Les accusées ont été condamnées par le jury."},{"id":"c","text":"Les accusées ont été condamné par le jury."},{"id":"d","text":"Les accusées avaient été condamnées par le jury."}]'::jsonb, 'b', 'Le COD « les accusées » (féminin pluriel) devient sujet du verbe passif. Le participe passé doit donc s''accorder en féminin pluriel → « condamnées ». L''option a accorde en masculin pluriel (« condamnés »), l''option c laisse le participe invariable (« condamné »), l''option d fausse le temps (plus-que-parfait au lieu du passé composé).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('769e9ea5-33a5-5482-b19c-3ff5205cac01', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'La phrase « La salle est éclairée. » est-elle à la voix passive ou exprime-t-elle un état résultant ? Quelle option explique correctement la distinction ?', '[{"id":"a","text":"C''est nécessairement une voix passive, car elle contient « être » + participe passé."},{"id":"b","text":"C''est nécessairement un état résultant, car aucun complément d''agent n''est exprimé."},{"id":"c","text":"Elle est ambiguë hors contexte : elle peut décrire l''état résultant d''une action passée (« la salle se trouve dans un état éclairé ») ou une voix passive réelle si un agent est sous-entendu ou exprimable (« La salle est éclairée par des spots »). Le contexte seul permet de trancher."},{"id":"d","text":"C''est une voix passive sans complément d''agent, ce qui la rend grammaticalement incorrecte."}]'::jsonb, 'c', 'La construction « être + participe passé » peut exprimer soit la voix passive (l''action est en cours ou accomplie par un agent), soit un état résultant (adjectif attribut issu d''un participe, décrivant le résultat d''une action antérieure). Sans contexte, « La salle est éclairée » est ambiguë : si l''on peut ajouter « par quelqu''un/quelque chose », c''est une voix passive ; si la phrase décrit un état figé, c''est un emploi attributif. L''absence du complément d''agent (option b) ne suffit pas à trancher, et la voix passive sans agent est grammaticalement correcte (option d est fausse).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4357bc16-e6fd-5663-8d0e-ac9d2bfafdea', '6964cb06-f67d-56f4-a779-bbbe567f265c', 'Transforme à la voix passive en conservant exactement le temps : « Le tribunal prononça les peines. »', '[{"id":"a","text":"Les peines furent prononcées par le tribunal."},{"id":"b","text":"Les peines ont été prononcées par le tribunal."},{"id":"c","text":"Les peines étaient prononcées par le tribunal."},{"id":"d","text":"Les peines furent prononcés par le tribunal."}]'::jsonb, 'a', 'La phrase active est au passé simple (« prononça »). Au passif, l''auxiliaire « être » se conjugue au passé simple → « furent » + participe passé accordé avec le nouveau sujet « les peines » (féminin pluriel) → « prononcées ». L''option b utilise le passé composé, l''option c l''imparfait, et l''option d commet une faute d''accord (masculin pluriel « prononcés » au lieu de féminin pluriel « prononcées »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('239989ee-497a-589e-8483-558788dd504d', '6e167f5c-fcde-5d6f-8695-e18a0b556cc7', 'french', '🛡️ Entraînement examen : voix active et voix passive', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf62eaa6-0c73-5b2a-8820-7237bce83c21', '239989ee-497a-589e-8483-558788dd504d', 'Mets à la voix passive : « Les élèves respectent leur professeur. »', '[{"id":"a","text":"Le professeur respecte ses élèves."},{"id":"b","text":"Le professeur est respecté par les élèves."},{"id":"c","text":"Le professeur a été respecté par les élèves."},{"id":"d","text":"Les élèves sont respectés par le professeur."}]'::jsonb, 'b', 'Le COD « leur professeur » devient sujet et le présent est conservé : « est respecté par les élèves ». L''option c change le temps (passé composé), a inverse le sens, d inverse les rôles.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7973a25-f7ad-54f7-889a-fb32afb22a8c', '239989ee-497a-589e-8483-558788dd504d', 'Mets à la voix active : « Ce roman a été écrit par un jeune auteur. »', '[{"id":"a","text":"Un jeune auteur écrit ce roman."},{"id":"b","text":"Un jeune auteur a écrit ce roman."},{"id":"c","text":"Ce roman écrit un jeune auteur."},{"id":"d","text":"Un jeune auteur écrivait ce roman."}]'::jsonb, 'b', 'Le complément d''agent « un jeune auteur » devient sujet et on conserve le temps de la voix passive : « a été écrit » (passé composé) donne « a écrit ». L''option a est au présent, d à l''imparfait, c inverse les rôles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1c02ada-a91d-5c2a-9dcf-707291fa4620', '239989ee-497a-589e-8483-558788dd504d', 'Dans « La porte a été ouverte par le vent. », quel est le complément d''agent ?', '[{"id":"a","text":"La porte"},{"id":"b","text":"a été ouverte"},{"id":"c","text":"le vent"},{"id":"d","text":"par"}]'::jsonb, 'c', 'Le complément d''agent désigne celui qui fait l''action ; introduit par « par », c''est ici « le vent ». « La porte » est le sujet (a), « a été ouverte » le verbe passif (b), « par » la simple préposition (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cfc8ea9-1e3c-5004-8105-4860681f369f', '239989ee-497a-589e-8483-558788dd504d', 'Quelle phrase est correctement à la voix passive ?', '[{"id":"a","text":"Le voleur a arrêté par la police."},{"id":"b","text":"Le voleur a été arrêté par la police."},{"id":"c","text":"Le voleur est arrêté la police."},{"id":"d","text":"La police a été arrêté le voleur."}]'::jsonb, 'b', 'La voix passive se forme avec l''auxiliaire « être » conjugué + participe passé accordé : « a été arrêté par la police ». L''option a oublie « été », c oublie « par », d mélange sujet et complément.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('260c5f3f-a766-5a3e-a740-dd0f00f33d3d', '239989ee-497a-589e-8483-558788dd504d', 'Mets à la voix passive en respectant l''accord : « La directrice félicite les lauréates. »', '[{"id":"a","text":"Les lauréates sont félicité par la directrice."},{"id":"b","text":"Les lauréates sont félicitées par la directrice."},{"id":"c","text":"Les lauréates ont félicité la directrice."},{"id":"d","text":"La directrice est félicitée par les lauréates."}]'::jsonb, 'b', 'Le participe passé s''accorde avec le sujet « les lauréates » (féminin pluriel) : « félicitées ». L''option a oublie l''accord, c et d inversent les rôles.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23cc5062-223d-5494-94eb-9830da75d3e0', '239989ee-497a-589e-8483-558788dd504d', 'Pourquoi emploie-t-on souvent la voix passive dans la phrase « Le coupable a été condamné. » ?', '[{"id":"a","text":"Pour poser une question."},{"id":"b","text":"Pour mettre en valeur l''objet de l''action quand l''agent est inconnu ou peu important."},{"id":"c","text":"Pour donner un ordre."},{"id":"d","text":"Parce que la voix passive est interdite à l''écrit."}]'::jsonb, 'b', 'La voix passive permet de mettre l''accent sur celui qui subit l''action (« le coupable ») et d''effacer l''agent quand il est inconnu ou secondaire. Elle ne sert ni à interroger (a), ni à ordonner (c), et elle est tout à fait correcte à l''écrit (d est faux).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('06501a61-9965-5426-8256-57479f8c4308', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d1bf493-f6d4-5de2-8d8f-4e728127758b', '06501a61-9965-5426-8256-57479f8c4308', 'Quels signes de ponctuation caractérisent le discours direct ?', '[{"id":"a","text":"Des parenthèses et des crochets"},{"id":"b","text":"Des deux-points, des guillemets (« … ») et éventuellement des tirets"},{"id":"c","text":"Uniquement des virgules et des points-virgules"},{"id":"d","text":"Des astérisques et des points de suspension"}]'::jsonb, 'b', 'Le discours direct se reconnaît aux deux-points annonçant les paroles, aux guillemets les encadrant et aux tirets marquant les changements d''interlocuteur dans un dialogue.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d54d5b3a-c34c-5314-8b03-d3350d485dcd', '06501a61-9965-5426-8256-57479f8c4308', 'Pour transposer au discours indirect une question totale du type « Viens-tu ? », quel outil de subordination utilise-t-on ?', '[{"id":"a","text":"que"},{"id":"b","text":"ce que"},{"id":"c","text":"si"},{"id":"d","text":"de + infinitif"}]'::jsonb, 'c', 'Une question totale (réponse oui/non) est introduite au discours indirect par « si » : « Viens-tu ? » → Il demande si tu viens.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('633f9e2a-6695-5ff9-b6f6-934cbe3e687f', '06501a61-9965-5426-8256-57479f8c4308', 'Le verbe introducteur est au passé : « Elle dit : ''Je travaille.'' » Quel temps prend le verbe au discours indirect ?', '[{"id":"a","text":"Le présent"},{"id":"b","text":"L''imparfait"},{"id":"c","text":"Le plus-que-parfait"},{"id":"d","text":"Le conditionnel présent"}]'::jsonb, 'b', 'Quand le verbe introducteur est au passé, le présent du discours direct devient l''imparfait au discours indirect : « Je travaille. » → Elle dit qu''elle travaillait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a8d594c-bdec-5df8-a62e-51a618c211c4', '06501a61-9965-5426-8256-57479f8c4308', 'Comment transforme-t-on « aujourd''hui » du discours direct en discours indirect (verbe introducteur au passé) ?', '[{"id":"a","text":"demain"},{"id":"b","text":"la veille"},{"id":"c","text":"le lendemain"},{"id":"d","text":"ce jour-là"}]'::jsonb, 'd', 'Les indicateurs de temps s''adaptent au discours indirect : « aujourd''hui » devient « ce jour-là », « hier » devient « la veille », « demain » devient « le lendemain ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e076c07d-7d92-5511-a4ab-c5711a2c73cd', '06501a61-9965-5426-8256-57479f8c4308', 'Au discours indirect, un ordre à l''impératif est transposé grâce à :', '[{"id":"a","text":"la conjonction « que » + subjonctif présent"},{"id":"b","text":"la préposition « de » + infinitif"},{"id":"c","text":"la conjonction « si » + indicatif"},{"id":"d","text":"le pronom relatif « qui » + verbe conjugué"}]'::jsonb, 'b', 'Un impératif se transforme au discours indirect en « de + infinitif » : « Pars ! » → Il lui ordonne de partir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7a24537c-05b2-5498-864c-768a4f7b3ee8', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', 'Exercice : discours direct et indirect', 2, 60, 12, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c124cc25-0734-5a92-811e-669baf60fa4b', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Laquelle de ces phrases est au discours direct ?', '[{"id":"a","text":"Le professeur dit qu''ils ouvrent leurs cahiers."},{"id":"b","text":"Le professeur leur ordonne d''ouvrir leurs cahiers."},{"id":"c","text":"Le professeur dit : « Ouvrez vos cahiers. »"},{"id":"d","text":"Le professeur demande si les cahiers sont ouverts."}]'::jsonb, 'c', 'Le discours direct reproduit les paroles telles quelles, annoncées par les deux-points et encadrées par des guillemets : c''est l''option c. Les options a, b et d intègrent les paroles dans une subordonnée (« qu''ils ouvrent », « d''ouvrir », « si… ») : ce sont des discours indirects.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a365e428-06ba-5c4e-b3fb-3b1eb755b102', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Transforme au discours indirect : Le héros cria : « Je reviendrai demain ! »
Le héros cria qu''il ___.', '[{"id":"a","text":"reviendrait le lendemain"},{"id":"b","text":"reviendra demain"},{"id":"c","text":"revient le lendemain"},{"id":"d","text":"reviendrait demain"}]'::jsonb, 'a', 'Le verbe introducteur « cria » est au passé : le futur simple « reviendrai » devient conditionnel présent « reviendrait ». De plus, l''indicateur de temps « demain » se transforme en « le lendemain » au discours indirect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69045ed1-0311-55cc-a9d1-5ff08b74073c', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Quel outil de subordination utilise-t-on pour rapporter une question totale (réponse oui/non) au discours indirect ?', '[{"id":"a","text":"que"},{"id":"b","text":"ce que"},{"id":"c","text":"si"},{"id":"d","text":"de"}]'::jsonb, 'c', 'Une question totale (à laquelle on répond par oui ou non) se rapporte au discours indirect avec « si » : « Viens-tu ? » → Il demande si tu viens. On n''utilise « que » que pour les phrases déclaratives, « ce que » pour les questions partielles portant sur le COD, et « de » pour rapporter un ordre.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('103b3b98-c5ec-5850-b280-83a2c4488045', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Au discours indirect, « Qu''est-ce que tu cherches ? » devient :', '[{"id":"a","text":"Il demande qu''est-ce que tu cherches."},{"id":"b","text":"Il demande si tu cherches."},{"id":"c","text":"Il demande ce que tu cherches."},{"id":"d","text":"Il demande ce qui cherche."}]'::jsonb, 'c', 'Au discours indirect, « qu''est-ce que » se transforme en « ce que » (jamais « qu''est-ce que », qui est réservé au discours direct). La phrase perd le point d''interrogation et il n''y a pas d''inversion du sujet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b56fc225-0884-57fe-9604-a5f47069571c', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Quelle transformation de l''indicateur de lieu est correcte au passage au discours indirect ?', '[{"id":"a","text":"« ici » → « aujourd''hui »"},{"id":"b","text":"« demain » → « ici »"},{"id":"c","text":"« ici » → « là »"},{"id":"d","text":"« hier » → « demain »"}]'::jsonb, 'c', 'L''indicateur de lieu « ici » (point de vue du locuteur au moment où il parle) devient « là » au discours indirect (point de vue du narrateur). Les autres options mélangent indicateurs de temps et de lieu, ou inversent le sens.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eed4181b-dcbb-5ee2-b6e2-44685205a62e', '7a24537c-05b2-5498-864c-768a4f7b3ee8', 'Dans la phrase : « Elle annonça qu''elle avait réussi son examen. », quel était le temps verbal dans le discours direct d''origine ?', '[{"id":"a","text":"Le présent : « Je réussis... »"},{"id":"b","text":"L''imparfait : « Je réussissais... »"},{"id":"c","text":"Le futur simple : « Je réussirai... »"},{"id":"d","text":"Le passé composé : « J''ai réussi... »"}]'::jsonb, 'd', 'Au discours indirect avec un verbe introducteur au passé (« annonça »), le plus-que-parfait « avait réussi » correspond à un passé composé dans le discours direct d''origine : « J''ai réussi mon examen. »', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a929d5d0-6d99-542b-8482-d7e65feeb3b3', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', '⚔️ Boss : maîtriser le discours rapporté', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d53a306c-aa47-55c3-b52a-3b76f508e771', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
L''entraîneur ordonna : « Courez plus vite ! »
L''entraîneur ordonna ___.', '[{"id":"a","text":"qu''ils couraient plus vite"},{"id":"b","text":"si on court plus vite"},{"id":"c","text":"de courir plus vite"},{"id":"d","text":"que courir plus vite"}]'::jsonb, 'c', 'Un ordre à l''impératif se rapporte au discours indirect par « de + infinitif » : « Courez ! » → ordonna de courir. On n''utilise pas « que » + indicatif pour un ordre, ni « si » qui est réservé aux questions totales.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('789d8fb4-ef9b-57a5-971b-67821be37f1a', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme entièrement au discours indirect :
Le chevalier dit : « Je partirai demain à l''aube. »
Le chevalier dit qu''il ___.', '[{"id":"a","text":"partira demain à l''aube"},{"id":"b","text":"partirait demain à l''aube"},{"id":"c","text":"partait le lendemain à l''aube"},{"id":"d","text":"partirait le lendemain à l''aube"}]'::jsonb, 'd', 'Le verbe introducteur « dit » est au passé simple : le futur simple « partirai » devient conditionnel présent « partirait », et l''indicateur de temps « demain » se transforme en « le lendemain » au discours indirect. D''où la réponse d (« partirait le lendemain à l''aube »). L''option a n''opère aucun des deux changements ; l''option b change le temps mais garde « demain » ; l''option c change l''indicateur mais emploie l''imparfait au lieu du conditionnel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('927e93ec-4461-53b5-9378-38ef71fbb9b2', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
Elle demanda : « Qu''est-ce qui fait ce bruit ? »
Elle demanda ___.', '[{"id":"a","text":"ce que faisait ce bruit"},{"id":"b","text":"ce qui faisait ce bruit"},{"id":"c","text":"qu''est-ce qui faisait ce bruit"},{"id":"d","text":"si quelque chose faisait ce bruit"}]'::jsonb, 'b', '« Qu''est-ce qui » (sujet) se transforme en « ce qui » au discours indirect, d''où la réponse b. Le verbe introducteur « demanda » étant au passé, le présent « fait » devient imparfait « faisait ». L''option a emploie « ce que », réservé au COD (et non au sujet) ; l''option c conserve « qu''est-ce qui », forme directe interdite au DI ; l''option d (« si ») transforme à tort la question partielle en question totale et altère le sens.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03c3a61a-f9aa-5183-a4e0-994f72750e44', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Laquelle de ces transformations est entièrement correcte ?
DD : La sorcière murmura : « Je serai là ce soir. »', '[{"id":"a","text":"La sorcière murmura qu''elle serait là ce soir-là."},{"id":"b","text":"La sorcière murmura qu''elle sera là ce soir."},{"id":"c","text":"La sorcière murmura qu''elle serait là ce soir."},{"id":"d","text":"La sorcière murmura qu''elle était là ce soir-là."}]'::jsonb, 'a', '« murmura » est au passé → le futur « serai » devient conditionnel présent « serait » (✓ a et c). L''indicateur « ce soir » devient « ce soir-là » au DI (✓ a seulement). L''option c oublie de changer l''indicateur ; b oublie la concordance des temps ; d utilise l''imparfait au lieu du conditionnel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b7368b8-68e7-5388-a30c-503e4d1dc5dd', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Dans la phrase au discours indirect : « Le guide nous expliqua qu''il avait visité ce site l''année précédente. », quel était le discours direct d''origine ?', '[{"id":"a","text":"« J''avais visité ce site l''année précédente. »"},{"id":"b","text":"« Je visiterai ce site l''année prochaine. »"},{"id":"c","text":"« J''ai visité ce site l''année dernière. »"},{"id":"d","text":"« Je visite ce site l''année dernière. »"}]'::jsonb, 'c', 'Au DI, le verbe introducteur « expliqua » est au passé : le plus-que-parfait « avait visité » remonte au passé composé « a visité » dans le DD, et l''indicateur « l''année précédente » redevient « l''année dernière ». La réponse est donc c. L''option a reprend telle quelle la forme du DI (plus-que-parfait + « l''année précédente »), au lieu de restituer le DD ; l''option b emploie le futur, qui aurait donné un conditionnel au DI ; l''option d emploie le présent, incompatible avec « avait visité ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4beed3e-de76-5a9d-b807-84d386df921d', 'a929d5d0-6d99-542b-8482-d7e65feeb3b3', 'Transforme au discours indirect :
Il s''écria : « Où étais-tu hier ? »
Il s''écria ___.', '[{"id":"a","text":"où il avait été la veille"},{"id":"b","text":"où tu avais été hier"},{"id":"c","text":"si tu étais là hier"},{"id":"d","text":"où j''avais été la veille"}]'::jsonb, 'a', 'La question partielle « où » se maintient au DI. « s''écria » est au passé → l''imparfait « étais » devient plus-que-parfait « avait été ». Le pronom « tu » (interlocuteur) devient « il » (3e personne). L''indicateur « hier » → « la veille ». L''option b ne change pas le pronom ; c transforme en question totale avec « si » ; d garde le pronom de 1re personne.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', '👑 Défi élite : transposition experte', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1de99ec2-2a17-58f7-9114-ec649edef3b9', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Transforme entièrement au discours indirect :
Il promit : « Avant demain soir, j''aurai tout réparé. »
Il promit qu''avant ___, il ___ tout réparé.', '[{"id":"a","text":"le lendemain soir / aurait"},{"id":"b","text":"demain soir / aurait"},{"id":"c","text":"le lendemain soir / avait"},{"id":"d","text":"le soir suivant / aura"}]'::jsonb, 'a', 'Le verbe introducteur « promit » est au passé simple. Le futur antérieur « aurai réparé » (qui marque un fait accompli avant un moment futur) se transforme en conditionnel passé « aurait réparé » selon la concordance des temps. L''indicateur « demain » devient « le lendemain » au discours indirect. L''option b conserve « demain » sans le transformer ; c utilise le plus-que-parfait, réservé à la transposition du passé composé ; d invente « le soir suivant » qui ne correspond à aucune règle et conserve le futur simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b262a7f4-2c4a-5516-b86f-a4364a2f19cd', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Retrouve le discours direct d''origine à partir de cette phrase au discours indirect :
Elle confia qu''elle avait terminé son rapport l''avant-veille.
Quel était le discours direct ?', '[{"id":"a","text":"« J''avais terminé mon rapport avant-hier. »"},{"id":"b","text":"« J''ai terminé mon rapport avant-hier. »"},{"id":"c","text":"« J''ai terminé mon rapport hier. »"},{"id":"d","text":"« Je terminerai mon rapport avant-hier. »"}]'::jsonb, 'b', 'Le verbe introducteur « confia » est au passé. Dans le discours indirect, le plus-que-parfait « avait terminé » provient d''un passé composé « a terminé » dans le discours direct (passé composé → plus-que-parfait). L''indicateur « l''avant-veille » remonte à « avant-hier » dans le discours direct. L''option a conserve le plus-que-parfait dans le DD, ce qui est incorrect (le plus-que-parfait dans le DI correspond au passé composé dans le DD) ; c utilise « hier » qui correspondrait à « la veille », non à « l''avant-veille » ; d utilise le futur, qui donnerait un conditionnel présent dans le DI.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf2f5e39-a69b-57db-bf3b-7ad4944e8af1', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Transforme au discours indirect en choisissant la version entièrement correcte :
Le professeur demanda : « Qu''est-ce que vous avez compris hier ? »', '[{"id":"a","text":"Le professeur demanda qu''est-ce que les élèves avaient compris hier."},{"id":"b","text":"Le professeur demanda ce que les élèves avaient compris la veille."},{"id":"c","text":"Le professeur demanda ce que les élèves ont compris hier."},{"id":"d","text":"Le professeur demanda si les élèves avaient compris la veille."}]'::jsonb, 'b', '« Qu''est-ce que » (mis pour le COD de la question) se transforme en « ce que » au discours indirect — on ne conserve jamais la forme « qu''est-ce que » dans une interrogation indirecte. Le verbe introducteur « demanda » est au passé : le passé composé « avez compris » devient plus-que-parfait « avaient compris ». L''indicateur « hier » devient « la veille ». Le pronom « vous » (les élèves interrogés) passe à la 3e personne « les élèves ». L''option a conserve la forme directe interdite au DI ; c oublie la concordance des temps et ne transforme pas « hier » ; d substitue incorrectement « si » (réservé aux questions totales oui/non) à la place d''une question partielle portant sur le COD.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('743f0cfa-5ea6-5f79-b14e-37765de428fd', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Identifie la seule transformation entièrement correcte au discours indirect :
DD : Le médecin lui dit : « Tu dois maintenant prendre ce médicament chaque jour. »', '[{"id":"a","text":"Le médecin lui dit qu''il devait maintenant prendre ce médicament chaque jour."},{"id":"b","text":"Le médecin lui dit qu''il doit alors prendre ce médicament chaque jour."},{"id":"c","text":"Le médecin lui dit qu''il devait alors prendre ce médicament chaque jour."},{"id":"d","text":"Le médecin lui dit de prendre maintenant ce médicament chaque jour."}]'::jsonb, 'c', 'Le verbe introducteur « dit » est ici au passé simple (passé narratif). Le présent « dois » devient imparfait « devait » selon la concordance des temps. Le pronom « tu » (l''interlocuteur, le patient) passe à la 3e personne « il ». L''indicateur « maintenant » se transforme en « alors » au discours indirect. L''option a transforme correctement le pronom et le temps, mais oublie de changer « maintenant » en « alors » ; b transforme correctement l''indicateur mais garde le présent « doit » au lieu de l''imparfait « devait » ; d interprète la phrase comme un ordre à l''impératif (de + infinitif), alors qu''il s''agit ici d''un présent indicatif (obligation déclarative), et ne change pas « maintenant ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17aa026e-8a88-58d5-a5c0-affd7e4f59da', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Transforme entièrement au discours indirect en choisissant la version sans faute :
DD : Le directeur annonça : « Nous signerons le contrat après-demain. »', '[{"id":"a","text":"Le directeur annonça qu''ils signeraient le contrat après-demain."},{"id":"b","text":"Le directeur annonça qu''ils signeront le contrat le surlendemain."},{"id":"c","text":"Le directeur annonça qu''ils signeraient le contrat le surlendemain."},{"id":"d","text":"Le directeur annonça qu''ils signeraient le contrat le lendemain."}]'::jsonb, 'c', 'Le verbe introducteur « annonça » est au passé simple. Le futur simple « signerons » devient conditionnel présent « signeraient ». Le pronom « nous » (qui inclut le directeur et son groupe) passe à la 3e personne « ils ». L''indicateur « après-demain » se transforme en « le surlendemain » au discours indirect. L''option a applique la concordance des temps (conditionnel) et le changement de pronom, mais oublie de transformer « après-demain » ; b transforme correctement l''indicateur et le pronom, mais garde le futur simple au lieu du conditionnel ; d confond « après-demain » (surlendemain) avec « demain » (lendemain).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31d88445-55ae-5ab5-a019-4e8421185606', '61bb4f2d-caf9-530c-bf07-7db1eaf72f8e', 'Transforme au discours indirect en choisissant la version entièrement correcte :
DD : La reine s''interrogea : « Comment mes soldats ont-ils gagné cette bataille hier ? »', '[{"id":"a","text":"La reine s''interrogea comment est-ce que ses soldats avaient gagné cette bataille la veille."},{"id":"b","text":"La reine s''interrogea comment ses soldats avaient gagné cette bataille hier."},{"id":"c","text":"La reine s''interrogea si ses soldats avaient gagné cette bataille la veille."},{"id":"d","text":"La reine s''interrogea comment ses soldats avaient gagné cette bataille la veille."}]'::jsonb, 'd', 'La question partielle introduite par « comment » conserve ce mot interrogatif au discours indirect, sans inversion du sujet et sans point d''interrogation. Le pronom « mes » (soldats de la reine, 1re personne) passe à la 3e personne « ses ». Le verbe introducteur « s''interrogea » est au passé simple : le passé composé « ont gagné » devient plus-que-parfait « avaient gagné ». L''indicateur « hier » se transforme en « la veille ». L''option a conserve la forme « est-ce que » interdite au discours indirect ; b transforme correctement tous les éléments sauf l''indicateur « hier » qui doit devenir « la veille » ; c substitue incorrectement « si » (question totale) à la place de « comment » (question partielle), ce qui change le sens de la question.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a79b3af3-ff27-5c55-9c31-e08d4da2b120', '1a062e5a-ea6f-50ea-b0e9-80f9f0180d28', 'french', '🛡️ Entraînement examen : discours direct et indirect', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70cae8ac-91e9-5ebd-8a9e-99137922c50e', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Quelle est la ponctuation correcte du discours direct ?', '[{"id":"a","text":"Il dit que « je viens »."},{"id":"b","text":"Il dit : « Je viens. »"},{"id":"c","text":"Il dit, Je viens."},{"id":"d","text":"Il dit Je viens"}]'::jsonb, 'b', 'Le discours direct s''introduit par un deux-points puis des guillemets entourant les paroles exactes : « Je viens. ». L''option a mélange « que » (indirect) et guillemets ; c et d n''emploient ni deux-points ni guillemets.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a52a14-dddc-5c1f-9ae2-e046a6a3bf36', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Mets au discours indirect : Il dit : « Je suis fatigué. »', '[{"id":"a","text":"Il dit qu''il est fatigué."},{"id":"b","text":"Il dit que je suis fatigué."},{"id":"c","text":"Il dit : il est fatigué."},{"id":"d","text":"Il dit qu''il était fatigué."}]'::jsonb, 'a', 'Le verbe introducteur est au présent : on subordonne avec « que » et on change le pronom « je » en « il », sans changer le temps : « Il dit qu''il est fatigué. ». L''option b garde « je » (faux), c oublie « que », d change le temps alors que le verbe introducteur est au présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89272a98-c361-59d6-9769-0f446eec2791', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Mets au discours indirect : Le maître ordonna : « Sortez ! »', '[{"id":"a","text":"Le maître ordonna que sortez."},{"id":"b","text":"Le maître ordonna de sortir."},{"id":"c","text":"Le maître ordonna sortez."},{"id":"d","text":"Le maître ordonna s''ils sortent."}]'::jsonb, 'b', 'Un ordre (impératif) au discours indirect se rend par « de + infinitif » : « ordonna de sortir ». L''option a garde l''impératif après « que », c oublie la subordination, d transforme l''ordre en interrogation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84cc4ad9-5b0a-5abf-94ac-0ef213a39e00', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Mets au discours indirect : Elle a demandé : « Est-ce que tu viens ? »', '[{"id":"a","text":"Elle a demandé que tu viens."},{"id":"b","text":"Elle a demandé si je venais."},{"id":"c","text":"Elle a demandé est-ce que je viens."},{"id":"d","text":"Elle a demandé que je venais."}]'::jsonb, 'b', 'L''interrogation totale au discours indirect est introduite par « si » (et non « que »), le pronom devient « je » et, le verbe introducteur étant au passé, le présent passe à l''imparfait : « si je venais ». L''option a et d utilisent « que » (faux), c garde « est-ce que ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fed4144-3d84-5e12-9241-90c61b17bc16', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Mets au discours indirect : Il déclara : « J''ai fini mon travail hier. »', '[{"id":"a","text":"Il déclara qu''il a fini son travail hier."},{"id":"b","text":"Il déclara qu''il avait fini son travail la veille."},{"id":"c","text":"Il déclara qu''il avait fini mon travail hier."},{"id":"d","text":"Il déclara qu''il finit son travail la veille."}]'::jsonb, 'b', 'Verbe introducteur au passé : le passé composé devient plus-que-parfait (« avait fini »), le possessif « mon » devient « son » et l''indicateur de temps « hier » devient « la veille ». L''option a ne fait pas la concordance, c garde « mon », d change le sens du verbe.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6d69941-cc45-5d67-a596-939ffc03da9f', 'a79b3af3-ff27-5c55-9c31-e08d4da2b120', 'Mets au discours indirect : Elle demanda : « Où vas-tu ? »', '[{"id":"a","text":"Elle demanda où je vais."},{"id":"b","text":"Elle demanda que j''allais."},{"id":"c","text":"Elle demanda où j''allais."},{"id":"d","text":"Elle demanda si j''allais où."}]'::jsonb, 'c', 'L''interrogation partielle conserve son mot interrogatif (« où »), le pronom devient « je » et le présent passe à l''imparfait (verbe introducteur au passé) : « où j''allais ». L''option a ne fait pas la concordance, b remplace « où » par « que », d mal place le mot interrogatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ad167a20-ae28-5904-9ce3-00d98dc0577e', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('860343a5-fe3b-56a4-943f-74ea5732b0ef', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'Quel mode exprime un fait réel, certain ou daté ?', '[{"id":"a","text":"Le subjonctif"},{"id":"b","text":"Le conditionnel"},{"id":"c","text":"L''impératif"},{"id":"d","text":"L''indicatif"}]'::jsonb, 'd', 'L''indicatif exprime les faits réels, certains ou datés (ex. : « Il part. / Il partira. »). Le subjonctif exprime le possible ou le souhaité, le conditionnel l''hypothèse.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f9f38b1-0cf8-50cf-97b9-f7484f39aac2', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'Comment se forme un temps composé en français ?', '[{"id":"a","text":"Par la répétition du verbe principal"},{"id":"b","text":"Par l''auxiliaire « avoir » ou « être » + participe passé"},{"id":"c","text":"Par le verbe « faire » + infinitif"},{"id":"d","text":"Par l''ajout du suffixe -ait au verbe"}]'::jsonb, 'b', 'Un temps composé est formé d''un auxiliaire (« avoir » ou « être ») conjugué au temps simple correspondant, suivi du participe passé. Ex. : passé composé = avoir/être au présent + participe passé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7705088-66ed-5e8d-b23e-63a1f2eb6260', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'Dans un récit au passé, quel temps est utilisé pour les descriptions et les actions de fond ?', '[{"id":"a","text":"Le passé simple"},{"id":"b","text":"Le futur simple"},{"id":"c","text":"L''imparfait"},{"id":"d","text":"Le passé antérieur"}]'::jsonb, 'c', 'L''imparfait sert au décor, à la description et aux actions de fond ou habituelles dans un récit au passé. Le passé simple, lui, exprime les actions ponctuelles qui font avancer le récit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d2559a3-989d-53df-8054-651a6ed1b9f6', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'Quelle valeur exprime le conditionnel présent dans la phrase « Il partirait s''il pouvait. » ?', '[{"id":"a","text":"Un ordre poli"},{"id":"b","text":"Une vérité générale"},{"id":"c","text":"Un fait soumis à une condition (hypothèse)"},{"id":"d","text":"Une action accomplie avant une autre"}]'::jsonb, 'c', 'Le conditionnel présent exprime ici une hypothèse : l''action dépend d''une condition (si + imparfait → conditionnel présent). Il peut aussi exprimer la politesse ou une information non confirmée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('358f2069-51cf-5a2a-be86-9b7f5e9ef89a', 'ad167a20-ae28-5904-9ce3-00d98dc0577e', 'Quelle est la règle de formation du subjonctif présent ?', '[{"id":"a","text":"Radical du futur simple + terminaisons de l''imparfait"},{"id":"b","text":"Radical de la 3e personne du pluriel du présent de l''indicatif + terminaisons -e, -es, -e, -ions, -iez, -ent"},{"id":"c","text":"Infinitif sans -er + terminaisons -ais, -ais, -ait, -ions, -iez, -aient"},{"id":"d","text":"Participe présent + terminaisons du présent"}]'::jsonb, 'b', 'Le subjonctif présent se forme sur le radical de la 3e personne du pluriel du présent de l''indicatif, auquel on ajoute les terminaisons -e, -es, -e, -ions, -iez, -ent (ex. : ils finissent → qu''il finisse).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b89d641c-95d4-5820-875a-3bac22a2add4', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', 'Exercice : modes et temps verbaux', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d3e559b-0449-57de-89b2-0ff23b9fd893', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel mode exprime un fait soumis à une condition ou une hypothèse ?', '[{"id":"a","text":"Le conditionnel"},{"id":"b","text":"L''impératif"},{"id":"c","text":"Le subjonctif"},{"id":"d","text":"L''indicatif"}]'::jsonb, 'a', 'Le conditionnel exprime un fait soumis à une condition (hypothèse), la politesse ou une information non confirmée. L''impératif donne des ordres ; le subjonctif exprime le souhaité ou le douteux ; l''indicatif énonce un fait réel ou certain.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2f3c849-25e9-53d0-b09e-4eff720714b2', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel emploi de l''impératif est illustré dans : « Prends soin de toi. » ?', '[{"id":"a","text":"Un fait réel"},{"id":"b","text":"Une hypothèse"},{"id":"c","text":"Un conseil"},{"id":"d","text":"Un doute"}]'::jsonb, 'c', 'Le ton de « Prends soin de toi » est bienveillant : c''est un conseil (réponse c), pas un ordre autoritaire. L''impératif peut exprimer un ordre, un conseil ou une prière. Les autres valeurs proposées relèvent d''autres modes : le fait réel (a) de l''indicatif, l''hypothèse (b) du conditionnel et le doute (d) du subjonctif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ee10a83-a4d9-5855-bb7d-79425521b890', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Dans la phrase « Il lisait quand le tonnerre éclata. », les deux temps utilisés sont :', '[{"id":"a","text":"L''imparfait (lisait) et le passé simple (éclata)"},{"id":"b","text":"Le passé composé (lisait) et l''imparfait (éclata)"},{"id":"c","text":"Le passé simple (lisait) et le passé simple (éclata)"},{"id":"d","text":"Le présent (lisait) et le futur (éclata)"}]'::jsonb, 'a', '« Lisait » est à l''imparfait (action de fond, en cours) et « éclata » est au passé simple (action soudaine et ponctuelle). Ce couple imparfait/passé simple est la structure narrative fondamentale du récit littéraire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2329c69b-07a0-5905-8d3b-82a269887104', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Laquelle de ces phrases contient un verbe au subjonctif présent ?', '[{"id":"a","text":"Il faut que tu finisses cet exercice."},{"id":"b","text":"Tu finiras cet exercice."},{"id":"c","text":"Tu finissais cet exercice."},{"id":"d","text":"Tu as fini cet exercice."}]'::jsonb, 'a', 'Après « il faut que », le verbe est obligatoirement au subjonctif : « finisses » est bien le subjonctif présent de « finir » (2e personne du singulier). Les options b (futur), c (imparfait) et d (passé composé) sont à l''indicatif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('815783b6-b7f5-5dea-9eea-baaa8f7a3382', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quel est le temps composé correspondant à l''imparfait ?', '[{"id":"a","text":"Le passé composé"},{"id":"b","text":"Le futur antérieur"},{"id":"c","text":"Le passé antérieur"},{"id":"d","text":"Le plus-que-parfait"}]'::jsonb, 'd', 'Le plus-que-parfait (ex. : « avait chanté ») est le temps composé qui correspond à l''imparfait (même série temporelle passée). Il exprime une action antérieure et accomplie par rapport à une action à l''imparfait ou au passé simple.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2241625-9fa9-504f-841d-0b346289ca00', 'b89d641c-95d4-5820-875a-3bac22a2add4', 'Quelle forme verbale est correcte dans : « Si tu ___ davantage, tu réussirais. » ?', '[{"id":"a","text":"travaillerais"},{"id":"b","text":"travaillais"},{"id":"c","text":"travailleras"},{"id":"d","text":"travailles"}]'::jsonb, 'b', 'Après « si » dans une hypothèse, on emploie l''imparfait (jamais le conditionnel) : « si tu travaillais → tu réussirais ». La structure est : si + imparfait → conditionnel présent ; la réponse est donc b (« travaillais »). Les options a (conditionnel), c (futur) et d (présent) sont toutes interdites après « si » dans ce contexte.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7efc2dc4-09b3-576b-b2f2-78e7a6288526', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', '⚔️ Boss : identifier et manier modes et temps', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b86b32d-c59d-5d28-a86e-a87b3cd41919', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Quelle phrase illustre correctement l''emploi du conditionnel de politesse ?', '[{"id":"a","text":"Je veux un renseignement, s''il vous plaît."},{"id":"b","text":"Je voudrais un renseignement, s''il vous plaît."},{"id":"c","text":"Je voulus un renseignement, s''il vous plaît."},{"id":"d","text":"Je veuille un renseignement, s''il vous plaît."}]'::jsonb, 'b', '« Je voudrais » est le conditionnel présent de « vouloir » : il adoucit la demande et exprime la politesse (réponse b). L''option a (« je veux », présent de l''indicatif) est plus directe et moins polie ; c (« je voulus », passé simple) est inapproprié ici ; d (« je veuille ») emploie à tort le subjonctif dans un contexte où le conditionnel s''impose.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fadd44b-aca0-5ece-b1a4-02766d4517e3', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Dans le récit suivant, quel temps manque-t-il pour exprimer l''action qui fait avancer l''histoire ?
« Le guerrier ___ son épée, ___ un cri et ___ sur l''ennemi. » (actions ponctuelles et successives, style littéraire)', '[{"id":"a","text":"Le passé simple"},{"id":"b","text":"L''imparfait"},{"id":"c","text":"Le présent"},{"id":"d","text":"Le plus-que-parfait"}]'::jsonb, 'a', 'Les actions ponctuelles et successives qui font avancer le récit en style littéraire sont exprimées au passé simple : « saisit, poussa, se rua ». L''imparfait décrit le fond ou les habitudes ; le présent s''emploie dans un récit oral courant ou pour un présent de narration ; le plus-que-parfait exprime l''antériorité.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbaa9f7f-4a56-5d1f-b53d-df4861ef1871', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Laquelle de ces formes verbales est au conditionnel présent ?', '[{"id":"a","text":"Elle partait"},{"id":"b","text":"Elle est partie"},{"id":"c","text":"Elle partirait"},{"id":"d","text":"Elle parte"}]'::jsonb, 'c', '« Partirait » = radical du futur (partir-) + terminaison de l''imparfait (-ait) → conditionnel présent. « Partait » est l''imparfait de l''indicatif ; « est partie » est le passé composé ; « parte » est le subjonctif présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83dfacbc-3c11-55bf-ad09-cc214abb3711', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Identifie le temps et le mode du verbe souligné :
« À peine avait-il franchi la porte qu''une flèche siffla. »
(verbe : avait franchi)', '[{"id":"a","text":"Passé composé de l''indicatif"},{"id":"b","text":"Passé antérieur de l''indicatif"},{"id":"c","text":"Imparfait de l''indicatif"},{"id":"d","text":"Plus-que-parfait de l''indicatif"}]'::jsonb, 'd', '« Avait franchi » = auxiliaire avoir à l''imparfait + participe passé → c''est le plus-que-parfait de l''indicatif. Il exprime une action antérieure à une autre action passée (« siffla », passé simple). Le passé antérieur utiliserait « eut franchi » (auxiliaire au passé simple).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f4296d8-c07e-5e6d-b599-0022c8f72118', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Conjugue correctement au subjonctif présent (3e personne du singulier) :
« Il est indispensable que le groupe ___ à l''heure. »
(verbe : venir)', '[{"id":"a","text":"vient"},{"id":"b","text":"viendra"},{"id":"c","text":"vienne"},{"id":"d","text":"venait"}]'::jsonb, 'c', 'Après « il est indispensable que », on emploie le subjonctif présent. Le radical se prend sur la 3e personne du pluriel du présent de l''indicatif (« ils viennent » → « vienn- ») : qu''il vienne (réponse c). L''option a (« vient ») est le présent de l''indicatif, b (« viendra ») le futur, d (« venait ») l''imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a935e4d-91f9-59c5-aed2-fbaedff745b6', '7efc2dc4-09b3-576b-b2f2-78e7a6288526', 'Complète avec la forme correcte :
« Il faut que vous ___ la vérité. » (verbe : dire)', '[{"id":"a","text":"disiez"},{"id":"b","text":"direz"},{"id":"c","text":"dites"},{"id":"d","text":"diriez"}]'::jsonb, 'a', 'Après « il faut que », on emploie le subjonctif présent. Pour « dire » à la 2e personne du pluriel, le radical est « dis- » (ils disent → dis-) et la terminaison est « -iez » → disiez. L''option b est le futur de l''indicatif ; c est le présent de l''indicatif ou l''impératif ; d est le conditionnel présent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('390674fc-7d19-5cd5-a9db-018176765203', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', '👑 Défi élite : modes et temps au sommet', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c70b94d-f217-58bc-a0a0-0bf5cc8d027c', '390674fc-7d19-5cd5-a9db-018176765203', 'Choisir le mode correct dans la phrase suivante :
« Après qu''il ___ (terminer) l''épreuve, le jury rendit son verdict. »
Quelle est la forme verbale attendue ?', '[{"id":"a","text":"eut terminé (passé antérieur de l''indicatif)"},{"id":"b","text":"ait terminé (subjonctif passé)"},{"id":"c","text":"terminât (subjonctif imparfait)"},{"id":"d","text":"aurait terminé (conditionnel passé)"}]'::jsonb, 'a', 'La conjonction « après que » introduit un fait accompli et réel : elle exige l''indicatif (ici le passé antérieur « eut terminé », temps littéraire exprimant l''antériorité par rapport au passé simple « rendit »). C''est un piège classique : on confond souvent « après que » (indicatif) avec « avant que » (subjonctif). Les options b et c relèvent du subjonctif, réservé à « avant que » ou « bien que » ; d est le conditionnel passé, inapproprié ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f07596c5-b4cf-56a0-aedb-85e25a439600', '390674fc-7d19-5cd5-a9db-018176765203', 'Conjugue correctement le verbe entre parenthèses au subjonctif présent :
« Il est peu probable que nous ___ (pouvoir) finir avant minuit. »', '[{"id":"a","text":"pouvions"},{"id":"b","text":"puissions"},{"id":"c","text":"pourrons"},{"id":"d","text":"pourrions"}]'::jsonb, 'b', 'Après « il est peu probable que », le subjonctif présent est obligatoire. Pour « pouvoir », le radical du subjonctif est irrégulier : à la 1re personne du pluriel, il se forme sur « puiss- » (cf. ils peuvent → puiss- au subjonctif) → nous puissions. L''option a (pouvions) est l''imparfait de l''indicatif ; c (pourrons) est le futur simple ; d (pourrions) est le conditionnel présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b188b3ad-3e88-5b36-9912-e9150f3c8998', '390674fc-7d19-5cd5-a9db-018176765203', 'Identifie la valeur du conditionnel dans cette phrase journalistique :
« Selon des sources proches du dossier, le ministre aurait signé l''accord hier soir. »', '[{"id":"a","text":"Hypothèse liée à une condition (si + imparfait)"},{"id":"b","text":"Politesse ou atténuation d''une demande"},{"id":"c","text":"Information non confirmée ou rapportée sous réserve"},{"id":"d","text":"Futur dans le passé en discours indirect"}]'::jsonb, 'c', 'Le conditionnel passé « aurait signé » est ici employé avec valeur de conditionnel journalistique : il signale que l''information est rapportée mais non vérifiée, ce qui engage la responsabilité de la source et non du locuteur. Ce n''est pas une hypothèse avec « si » (a), ni une politesse (b), ni un futur dans le passé en discours indirect (d), car il n''y a aucun verbe principal de déclaration au passé dont dépendrait une subordonnée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e79728f-c65b-539a-a096-2ed061f3addd', '390674fc-7d19-5cd5-a9db-018176765203', 'Complète avec la structure si-conditionnel correcte :
« Si tu ___ davantage à l''entraînement l''année dernière, tu ___ le concours cette année. »', '[{"id":"a","text":"travaillais … réussirais"},{"id":"b","text":"avais travaillé … aurais réussi"},{"id":"c","text":"aurais travaillé … aurais réussi"},{"id":"d","text":"travaillais … aurais réussi"}]'::jsonb, 'b', 'Lorsque la condition est irréelle dans le passé (« l''année dernière »), la structure correcte est : si + plus-que-parfait → conditionnel passé. Soit : « Si tu avais travaillé … tu aurais réussi. » L''option a (imparfait → conditionnel présent) exprime une hypothèse irréelle dans le présent, non dans le passé. L''option c est agrammaticale : on ne met jamais le conditionnel dans la proposition introduite par « si ». L''option d mélange les deux registres temporels de façon incohérente.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('508d24d2-5250-505a-a83b-7c7c80b29b95', '390674fc-7d19-5cd5-a9db-018176765203', 'Quelle valeur précise exprime le futur antérieur dans cette phrase ?
« Dès que tu auras rendu ta copie, tu pourras sortir. »', '[{"id":"a","text":"Une action future certaine et simultanée à une autre action future"},{"id":"b","text":"Une action future accomplie et antérieure à une autre action future"},{"id":"c","text":"Une action passée antérieure à une autre action passée"},{"id":"d","text":"Un ordre exprimé de façon atténuée"}]'::jsonb, 'b', 'Le futur antérieur « auras rendu » exprime une action qui sera accomplie avant une autre action future (« pourras sortir »). C''est sa valeur principale : antériorité et accomplissement par rapport à un point de référence futur. Les conjonctions de temps « dès que, aussitôt que, quand, lorsque » exigent le futur antérieur quand l''action de la subordonnée doit être achevée avant celle de la principale. L''option c décrit le plus-que-parfait ; a est inexact car les deux actions ne sont pas simultanées ; d décrit le futur simple à valeur d''ordre.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3476945b-e660-5149-b6af-990f68a221c7', '390674fc-7d19-5cd5-a9db-018176765203', 'Laquelle de ces conjonctions impose le mode subjonctif dans la proposition subordonnée qu''elle introduit ?', '[{"id":"a","text":"puisque"},{"id":"b","text":"parce que"},{"id":"c","text":"quoique"},{"id":"d","text":"pendant que"}]'::jsonb, 'c', '« Quoique » (synonyme de « bien que ») est une conjonction de concession qui exige le subjonctif : « Quoiqu''il soit épuisé, il continue. » En revanche, « puisque » (cause certaine), « parce que » (cause) et « pendant que » (simultanéité temporelle) introduisent toutes des faits réels ou certains : elles exigent l''indicatif. Cette distinction mode/conjonction est un point clé du programme de 9e année.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6935b49a-94bb-5e55-958b-077f8392251d', '8bea53f8-1edb-5ba6-ba7f-320bea5fe7d3', 'french', '🛡️ Entraînement examen : modes et temps verbaux', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa4da252-76b0-5bbe-8764-979312b45f75', '6935b49a-94bb-5e55-958b-077f8392251d', 'À quel mode et temps est le verbe dans « Il faut que tu finisses tes devoirs. » ?', '[{"id":"a","text":"Indicatif présent"},{"id":"b","text":"Subjonctif présent"},{"id":"c","text":"Conditionnel présent"},{"id":"d","text":"Impératif présent"}]'::jsonb, 'b', 'Après « il faut que », le verbe se met au subjonctif présent : « que tu finisses ». À l''indicatif on aurait « tu finis » (a) ; le conditionnel donnerait « tu finirais » (c) ; l''impératif (d) n''a pas de « que » ni de sujet exprimé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a29a5f8-19d1-5d00-8acd-762144ca1245', '6935b49a-94bb-5e55-958b-077f8392251d', 'Quelle phrase emploie le conditionnel présent pour exprimer la politesse ?', '[{"id":"a","text":"Je veux un verre d''eau."},{"id":"b","text":"Je voudrais un verre d''eau."},{"id":"c","text":"Je voulais un verre d''eau."},{"id":"d","text":"Je voudrai un verre d''eau."}]'::jsonb, 'b', '« voudrais » est le conditionnel présent, employé ici pour atténuer la demande (politesse). « veux » est l''indicatif présent (a), « voulais » l''imparfait (c), « voudrai » le futur simple (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76b6593e-ee1c-5a91-b24e-e0d073a5bebb', '6935b49a-94bb-5e55-958b-077f8392251d', 'Dans « Quand j''étais petit, je jouais dans le jardin. », quelle est la valeur de l''imparfait ?', '[{"id":"a","text":"Une action soudaine et ponctuelle"},{"id":"b","text":"Une habitude ou une action répétée dans le passé"},{"id":"c","text":"Un ordre"},{"id":"d","text":"Une action future"}]'::jsonb, 'b', 'L''imparfait exprime ici une action habituelle/répétée du passé (« je jouais » régulièrement). L''action soudaine relèverait du passé simple (a), l''ordre de l''impératif (c), le futur d''un temps du futur (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cfec379-8300-5b53-b683-971a9cb396c4', '6935b49a-94bb-5e55-958b-077f8392251d', 'Identifie le temps composé dans la liste suivante :', '[{"id":"a","text":"Je mangeais"},{"id":"b","text":"Je mangerai"},{"id":"c","text":"J''avais mangé"},{"id":"d","text":"Je mange"}]'::jsonb, 'c', 'Un temps composé se forme avec un auxiliaire (avoir/être) + participe passé : « j''avais mangé » (plus-que-parfait). « mangeais » (imparfait), « mangerai » (futur simple) et « mange » (présent) sont des temps simples.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33967eca-c9b5-5f4f-84e3-9519064494aa', '6935b49a-94bb-5e55-958b-077f8392251d', 'Quel verbe est correctement conjugué au subjonctif présent ?', '[{"id":"a","text":"Je veux que tu fais attention."},{"id":"b","text":"Je veux que tu fasses attention."},{"id":"c","text":"Je veux que tu feras attention."},{"id":"d","text":"Je veux que tu ferais attention."}]'::jsonb, 'b', 'Après « je veux que », on emploie le subjonctif présent : « que tu fasses ». « tu fais » est l''indicatif (a), « tu feras » le futur (c), « tu ferais » le conditionnel (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c6a44dd-b158-5d39-8636-2da68a6b6d9c', '6935b49a-94bb-5e55-958b-077f8392251d', 'Dans « Si tu travailles, tu réussiras. », quel est le mode et le temps de « réussiras » ?', '[{"id":"a","text":"Conditionnel présent"},{"id":"b","text":"Indicatif futur simple"},{"id":"c","text":"Subjonctif présent"},{"id":"d","text":"Indicatif imparfait"}]'::jsonb, 'b', 'Avec « si + présent » dans la subordonnée, la principale se met à l''indicatif futur simple : « tu réussiras ». Le conditionnel (a, « réussirais ») irait avec « si + imparfait » ; ce n''est ni un subjonctif (c) ni un imparfait (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a07afd33-a11b-52b9-b5ba-343427b0bc84', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', 'Qu''est-ce que la concordance des temps ?', '[{"id":"a","text":"Une règle qui impose d''adapter le temps du verbe subordonné au temps du verbe principal pour assurer la cohérence temporelle."},{"id":"b","text":"Une règle qui impose d''accorder le participe passé avec le sujet."},{"id":"c","text":"Une règle qui oblige à employer le passé simple dans tous les récits littéraires."},{"id":"d","text":"Une règle qui interdit l''emploi du subjonctif dans une subordonnée."}]'::jsonb, 'a', 'La concordance des temps est la règle qui impose d''adapter le temps du verbe de la subordonnée au temps du verbe principal afin d''assurer la cohérence temporelle du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbd55b7e-bb3e-5706-9186-e833923ce87d', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', 'Dans un récit au passé, quel temps exprime une action antérieure à une autre action passée ?', '[{"id":"a","text":"Le passé simple"},{"id":"b","text":"L''imparfait"},{"id":"c","text":"Le plus-que-parfait"},{"id":"d","text":"Le futur antérieur"}]'::jsonb, 'c', 'Le plus-que-parfait (auxiliaire à l''imparfait + participe passé) marque une action antérieure à une autre action passée. Ex. : « Il avait préparé son plan avant de lancer l''attaque. »', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5aeed1da-a9ed-53f3-9f19-b9f22a1abc0d', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', 'Dans la phrase « Pendant qu''il courait, la tempête faisait rage. », quelle relation temporelle unit les deux actions ?', '[{"id":"a","text":"Antériorité : la course précède la tempête."},{"id":"b","text":"Postériorité : la tempête suit la course."},{"id":"c","text":"Simultanéité : les deux actions se déroulent en même temps."},{"id":"d","text":"Hypothèse : la course est une condition de la tempête."}]'::jsonb, 'c', 'L''emploi de l''imparfait dans les deux propositions exprime la simultanéité : les deux actions se déroulent en même temps. « Pendant que » renforce cette idée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33b4e382-cde8-5e40-8398-c5e311c1ccf4', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', 'Dans le discours indirect, quand le verbe introducteur est au passé, le futur simple du discours direct devient :', '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le plus-que-parfait"},{"id":"c","text":"Le conditionnel présent"},{"id":"d","text":"Le subjonctif présent"}]'::jsonb, 'c', 'Règle de concordance au discours indirect (verbe introducteur au passé) : futur simple → conditionnel présent. Ex. : « Je partirai. » → Il dit qu''il partirait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6e6c9bc-90d2-5532-9fcf-52ddef7681b1', 'c4e4212c-8f83-5e3b-aa43-0d6d3e5a9fba', 'Le passé antérieur s''emploie principalement dans les subordonnées introduites par « dès que », « quand », « lorsque » pour indiquer :', '[{"id":"a","text":"Une action simultanée à un verbe au passé simple."},{"id":"b","text":"Une habitude répétée dans le passé."},{"id":"c","text":"Une action postérieure à un verbe à l''imparfait."},{"id":"d","text":"Une antériorité immédiate par rapport à un verbe au passé simple."}]'::jsonb, 'd', 'Le passé antérieur (auxiliaire au passé simple + participe passé) exprime une antériorité immédiate par rapport à un verbe principal au passé simple. Ex. : « Quand il eut fini son discours, les guerriers partirent. »', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4758ebaf-51ff-5d37-b504-914009e31959', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', 'Exercice : la concordance des temps', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e91167fb-6b84-515a-9848-d07949d71c90', '4758ebaf-51ff-5d37-b504-914009e31959', 'Quel temps emploie-t-on pour une action antérieure à une autre action au passé simple ?', '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le plus-que-parfait"},{"id":"c","text":"Le passé simple"},{"id":"d","text":"Le conditionnel présent"}]'::jsonb, 'b', 'Le plus-que-parfait (auxiliaire à l''imparfait + participe passé) exprime l''antériorité par rapport à une autre action au passé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28997c99-1b74-5330-8272-d08f4682b8c8', '4758ebaf-51ff-5d37-b504-914009e31959', 'Dans « La forêt _____ silencieuse, mais soudain un cri déchira l''air. », quel temps convient ?', '[{"id":"a","text":"fut"},{"id":"b","text":"avait été"},{"id":"c","text":"sera"},{"id":"d","text":"était"}]'::jsonb, 'd', 'L''imparfait « était » décrit un état de fond, tandis que le passé simple « déchira » exprime l''événement principal qui surgit.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee97c631-820f-50c1-9de3-58f140893afa', '4758ebaf-51ff-5d37-b504-914009e31959', 'Dans « Pendant qu''il _____ , ses compagnons attendaient. », quel temps convient pour marquer la simultanéité ?', '[{"id":"a","text":"dormit"},{"id":"b","text":"avait dormi"},{"id":"c","text":"dormait"},{"id":"d","text":"dormira"}]'::jsonb, 'c', 'La simultanéité dans un récit au passé s''exprime par deux imparfaits : « dormait » correspond à « attendaient ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f51a382-45ef-51f7-a25b-2e95a78d6c1f', '4758ebaf-51ff-5d37-b504-914009e31959', 'Complète au discours indirect : « Il annonça qu''il _____ le lendemain. » (discours direct : « Je partirai demain. »)', '[{"id":"a","text":"partira"},{"id":"b","text":"était parti"},{"id":"c","text":"partirait"},{"id":"d","text":"part"}]'::jsonb, 'c', 'Quand le verbe introducteur est au passé, le futur du discours direct devient conditionnel présent au discours indirect.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('676a25e8-1769-5b86-945f-06f2bf2d8548', '4758ebaf-51ff-5d37-b504-914009e31959', 'Choisis la phrase correctement construite dans un récit au passé :', '[{"id":"a","text":"Il a préparé son plan avant de lancer l''attaque."},{"id":"b","text":"Il prépara son plan avant d''avoir lancé l''attaque."},{"id":"c","text":"Il avait préparé son plan avant de lancer l''attaque."},{"id":"d","text":"Il préparait son plan avant de lancer l''attaque."}]'::jsonb, 'c', 'Dans un récit au passé, l''action antérieure s''exprime au plus-que-parfait (« avait préparé ») par rapport à l''action postérieure au passé simple.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc3b9212-5768-5113-ad7b-2ba9128d740f', '4758ebaf-51ff-5d37-b504-914009e31959', 'Transforme au discours indirect : « Elle dit : ‹ J''ai terminé mon travail. › »', '[{"id":"a","text":"Elle dit qu''elle avait terminé son travail."},{"id":"b","text":"Elle dit qu''elle terminait son travail."},{"id":"c","text":"Elle dit qu''elle a terminé son travail."},{"id":"d","text":"Elle dit qu''elle terminerait son travail."}]'::jsonb, 'a', 'Le passé composé du discours direct devient plus-que-parfait au discours indirect quand le verbe introducteur est au passé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7e38a684-6fa6-5bf2-ac76-40bf6085e469', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', '⚔️ Boss : maîtriser la concordance des temps', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b03e40f-b428-588f-8ccc-c9431e9e0fda', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect : « Le général cria : ‹ Avancez sans tarder ! › »', '[{"id":"a","text":"Le général cria que ses soldats avançaient sans tarder."},{"id":"b","text":"Le général cria à ses soldats d''avancer sans tarder."},{"id":"c","text":"Le général cria qu''ils avanceraient sans tarder."},{"id":"d","text":"Le général cria que ses soldats avancèrent sans tarder."}]'::jsonb, 'b', 'L''impératif du discours direct devient un infinitif introduit par « de » au discours indirect : « cria de + infinitif ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba963d3c-68cf-5c49-b62e-344049caab0e', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Quelle phrase respecte la concordance des temps dans le récit au passé ?', '[{"id":"a","text":"Le village est calme : les habitants avaient fui la veille."},{"id":"b","text":"Le village était calme : les habitants avaient fui la veille."},{"id":"c","text":"Le village était calme : les habitants fuiront la veille."},{"id":"d","text":"Le village était calme : les habitants fuyaient la veille avant."}]'::jsonb, 'b', 'L''imparfait « était » décrit l''état de fond ; le plus-que-parfait « avaient fui » exprime correctement l''antériorité par rapport à l''état présent du village.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c394033c-66d8-548c-951c-5472f4c41c30', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect (verbe introducteur au passé) : « Il murmura : ‹ Je reviendrai demain. › »', '[{"id":"a","text":"Il murmura qu''il reviendrait le lendemain."},{"id":"b","text":"Il murmura qu''il reviendra demain."},{"id":"c","text":"Il murmura qu''il était revenu le lendemain."},{"id":"d","text":"Il murmura qu''il revenait demain."}]'::jsonb, 'a', 'Le futur simple du discours direct devient conditionnel présent (« reviendrait ») et « demain » devient « le lendemain » au discours indirect avec verbe introducteur au passé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efa163b4-a341-5c43-9bfb-142a7b277fa7', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Complète : « Dès qu''il _____ son discours, les guerriers s''élancèrent. » (action antérieure immédiate)', '[{"id":"a","text":"avait terminé"},{"id":"b","text":"termina"},{"id":"c","text":"terminait"},{"id":"d","text":"eut terminé"}]'::jsonb, 'd', 'Après « dès que » suivi d''un verbe au passé simple, l''action antérieure immédiate s''exprime au passé antérieur (auxiliaire au passé simple + participe passé) : « eut terminé ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a467a610-6abe-5eac-ba05-83a1fa8608f7', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Dans « Il voulait que le héros _____ la quête avant la nuit. », quel temps convient au registre soutenu ?', '[{"id":"a","text":"accomplît"},{"id":"b","text":"accomplisse"},{"id":"c","text":"accomplit"},{"id":"d","text":"accomplissait"}]'::jsonb, 'a', 'Quand la principale est au passé (« voulait »), la subordonnée au subjonctif se met au subjonctif imparfait en registre soutenu : « accomplît » (3e pers. sing. du subjonctif imparfait d''« accomplir »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ba1108b-cd4f-590a-b3ce-0e1bb8b0a251', '7e38a684-6fa6-5bf2-ac76-40bf6085e469', 'Transforme au discours indirect : « La sorcière avoua : ‹ J''ai caché la clé hier. › »', '[{"id":"a","text":"La sorcière avoua qu''elle cachait la clé la veille."},{"id":"b","text":"La sorcière avoua qu''elle avait caché la clé la veille."},{"id":"c","text":"La sorcière avoua qu''elle a caché la clé hier."},{"id":"d","text":"La sorcière avoua qu''elle cacherait la clé la veille."}]'::jsonb, 'b', 'Le passé composé « ai caché » devient plus-que-parfait « avait caché » au discours indirect (verbe introducteur au passé), et « hier » devient « la veille ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7095b9e0-8e62-5384-8408-e05fd85503ef', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', '👑 Défi élite : concordance et systèmes hypothétiques', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e67df23c-e9ee-54fe-b2ab-bc1529b38436', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Laquelle de ces phrases illustre correctement l''hypothèse irréelle du passé ?', '[{"id":"a","text":"Si le chevalier saurait la vérité, il n''accepterait pas la mission."},{"id":"b","text":"Si le chevalier avait su la vérité, il n''aurait pas accepté la mission."},{"id":"c","text":"Si le chevalier savait la vérité, il n''accepterait pas la mission."},{"id":"d","text":"Si le chevalier avait su la vérité, il n''accepte pas la mission."}]'::jsonb, 'b', 'L''hypothèse irréelle du passé se construit avec « si » + plus-que-parfait dans la subordonnée, et conditionnel passé dans la principale : « si… avait su… n''aurait pas accepté ». L''option (a) est impossible car on ne met jamais le conditionnel après « si » hypothétique. L''option (c) exprime l''irréel du présent, pas du passé. L''option (d) mélange deux systèmes incompatibles.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a0919b3-712a-5d61-91f9-2a023e33b085', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Transforme au discours indirect : « Il promit : ‹ Quand j''aurai vaincu le dragon, je reviendrai. › »', '[{"id":"a","text":"Il promit que quand il aurait vaincu le dragon, il reviendrait."},{"id":"b","text":"Il promit que quand il avait vaincu le dragon, il reviendrait."},{"id":"c","text":"Il promit que quand il vaincrait le dragon, il reviendrait."},{"id":"d","text":"Il promit que quand il avait vaincu le dragon, il revenait."}]'::jsonb, 'a', 'Au discours indirect avec verbe introducteur au passé, le futur antérieur (« aurai vaincu ») devient conditionnel passé (« aurait vaincu »), et le futur simple (« reviendrai ») devient conditionnel présent (« reviendrait »). L''option (b) confond le conditionnel passé avec le plus-que-parfait (transformation du passé composé). L''option (c) omet la marque d''antériorité. L''option (d) transforme incorrectement la principale en imparfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d69fe82-436d-59e4-96c0-9dbabc7728e9', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Complète la phrase au registre soutenu : « Le général exigea que ses troupes _____ au camp avant l''aube. » (verbe : revenir, subjonctif imparfait, 3e pers. pl.)', '[{"id":"a","text":"revinssent"},{"id":"b","text":"reviendraient"},{"id":"c","text":"revinrent"},{"id":"d","text":"reviennent"}]'::jsonb, 'a', 'Quand la principale est au passé (« exigea »), la subordonnée au subjonctif prend le subjonctif imparfait en registre soutenu. La 3e personne du pluriel du subjonctif imparfait de « revenir » est « revinssent » (radical du passé simple : « revinrent » → base « revins- » + désinences du subjonctif imparfait). L''option (b) est le conditionnel, l''option (c) est le passé simple, et l''option (d) est le subjonctif présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28178fc6-48da-5f7a-833e-d9fe334c8358', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Laquelle de ces phrases contient une erreur de concordance des temps ?', '[{"id":"a","text":"Dès qu''il eut prononcé le serment, les portes s''ouvrirent."},{"id":"b","text":"Il craignait que la reine ne vînt trop tard."},{"id":"c","text":"Pendant qu''il traversait le désert, une tempête éclata soudain."},{"id":"d","text":"Il décida qu''il partirait le lendemain et qu''il avait emporté ses armes."}]'::jsonb, 'd', 'Dans la phrase (d), les deux subordonnées dépendent du même verbe « décida » et expriment toutes deux des actions postérieures à cette décision. La première subordonnée est correcte (« partirait » = conditionnel présent pour la postériorité), mais la seconde utilise le plus-que-parfait « avait emporté », qui exprime une antériorité — erreur de cohérence. Il faudrait « emporterait » ou « aurait emporté » selon le sens voulu. Les phrases (a), (b) et (c) sont toutes correctes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10762f40-915a-5ccf-8f2a-9532db6b3023', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Quelle phrase exprime une hypothèse réalisable (système du potentiel), et non un irréel ?', '[{"id":"a","text":"Si j''avais eu le temps, j''aurais étudié ce chapitre."},{"id":"b","text":"Si j''avais le temps, j''étudierais ce chapitre."},{"id":"c","text":"Si j''ai le temps, j''étudierai ce chapitre."},{"id":"d","text":"Si j''aurais le temps, j''étudierais ce chapitre."}]'::jsonb, 'c', 'Le système du potentiel (hypothèse réalisable) se construit avec « si » + présent de l''indicatif → futur simple dans la principale : « si j''ai le temps, j''étudierai ». L''option (a) est l''irréel du passé (si + PQP → conditionnel passé). L''option (b) est l''irréel du présent (si + imparfait → conditionnel présent). L''option (d) est une construction impossible : on ne place jamais le conditionnel directement après « si » hypothétique.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb19b45f-4918-50fc-afa4-47655504df12', '7095b9e0-8e62-5384-8408-e05fd85503ef', 'Transforme l''interrogation au discours indirect : « Le sage demanda : ‹ Avez-vous compris pourquoi le royaume a été détruit ? › »', '[{"id":"a","text":"Le sage demanda s''ils avaient compris pourquoi le royaume avait été détruit."},{"id":"b","text":"Le sage demanda s''ils comprenaient pourquoi le royaume était détruit."},{"id":"c","text":"Le sage demanda s''ils ont compris pourquoi le royaume a été détruit."},{"id":"d","text":"Le sage demanda qu''ils comprennent pourquoi le royaume avait été détruit."}]'::jsonb, 'a', 'L''interrogation totale (oui/non) devient une subordonnée introduite par « si » au discours indirect. Le passé composé « avez-vous compris » devient plus-que-parfait « avaient compris », et « a été détruit » (passé composé passif) devient « avait été détruit » (plus-que-parfait passif), conformément à la règle de concordance avec le verbe introducteur au passé. L''option (b) traduit incorrectement les passés composés en imparfait et en présent. L''option (c) ne fait aucun changement de temps. L''option (d) utilise « que » + subjonctif, ce qui transforme la question en ordre.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6f2e772-c6cf-51e0-aa37-472c24c0db05', '139a1fb4-9bc1-5c2d-b0cc-abd4941a13a7', 'french', '🛡️ Entraînement examen : la concordance des temps', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdad7adc-e019-5996-a87e-6409a86248d0', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Complète correctement : « Il dormait quand le téléphone … . »', '[{"id":"a","text":"sonnait"},{"id":"b","text":"sonna"},{"id":"c","text":"sonnera"},{"id":"d","text":"sonne"}]'::jsonb, 'b', 'Dans un récit au passé, l''imparfait (« dormait ») décrit l''action en cours et le passé simple (« sonna ») marque l''action soudaine qui s''y produit. « sonnait » (a) décrirait une action durable, « sonnera » (c) est au futur, « sonne » (d) au présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dae86223-f3ac-578b-8d7c-9dcbb14108e1', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Complète : « Je voulais que tu … plus tôt. »', '[{"id":"a","text":"viens"},{"id":"b","text":"viennes"},{"id":"c","text":"viendras"},{"id":"d","text":"venais"}]'::jsonb, 'b', 'Après un verbe de volonté (« je voulais que »), la subordonnée se met au subjonctif : « que tu viennes ». « viens » est l''indicatif présent (a), « viendras » le futur (c), « venais » l''imparfait de l''indicatif (d) — aucun n''est le subjonctif attendu.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('070508f4-ab03-5873-a546-2d8e0bf52886', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Complète : « Quand il eut terminé son repas, il … la table. »', '[{"id":"a","text":"débarrasse"},{"id":"b","text":"débarrassera"},{"id":"c","text":"débarrassa"},{"id":"d","text":"débarrassait"}]'::jsonb, 'c', 'Le passé antérieur (« eut terminé ») exprime une action achevée juste avant une autre au passé simple : « il débarrassa la table ». Le présent (a) et le futur (b) rompent la concordance au passé ; l''imparfait (d) ne marque pas l''action ponctuelle qui suit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8442fd5f-a8a3-5bd8-a9cd-488177b76852', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Au discours indirect passé : « Il a dit qu''il … le lendemain. » (parole d''origine : « Je partirai demain. »)', '[{"id":"a","text":"partira"},{"id":"b","text":"partait"},{"id":"c","text":"partirait"},{"id":"d","text":"part"}]'::jsonb, 'c', 'Au discours indirect avec un verbe introducteur au passé, le futur de la parole d''origine devient conditionnel présent : « qu''il partirait ». « partira » garde le futur (a), « partait » est l''imparfait (b), « part » le présent (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('550725f1-73d7-513e-956b-cabad8c09180', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Complète : « J''avais déjà fini mes devoirs lorsque mes amis … . »', '[{"id":"a","text":"arrivent"},{"id":"b","text":"arriveront"},{"id":"c","text":"sont arrivés"},{"id":"d","text":"arrivèrent"}]'::jsonb, 'd', 'Le plus-que-parfait (« j''avais fini ») marque l''antériorité par rapport à une action au passé simple dans un récit : « lorsque mes amis arrivèrent ». Le présent (a) et le futur (b) brisent la concordance au passé ; le passé composé (c) appartient plutôt au récit oral, alors que le récit ici est au passé simple.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fc3ea14-1df5-5242-b3f3-b309c23e2746', 'c6f2e772-c6cf-51e0-aa37-472c24c0db05', 'Complète : « Il pensait qu''elle … déjà partie. »', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"sera"},{"id":"d","text":"soit"}]'::jsonb, 'b', 'Le verbe introducteur « pensait » étant au passé, on emploie le plus-que-parfait « était déjà partie » (auxiliaire « être » à l''imparfait + participe « partie ») pour marquer l''antériorité de son départ par rapport au moment de la pensée. « est » (présent, a) et « sera » (futur, c) ne respectent pas la concordance ; « soit » (d) est un subjonctif, non requis après « penser » à la forme affirmative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8d1de601-0c73-557f-a3b4-d45a964a2872', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f8ad45d-b161-562e-b38c-3524e78b7214', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'Qu''est-ce qu''un préfixe ?', '[{"id":"a","text":"La partie centrale d''un mot qui porte le sens de base."},{"id":"b","text":"Un élément placé après le radical pour changer la catégorie ou le sens du mot."},{"id":"c","text":"Un élément placé avant le radical pour modifier le sens du mot."},{"id":"d","text":"Un mot appartenant au même champ lexical qu''un autre."}]'::jsonb, 'c', 'Le préfixe est un élément placé avant le radical pour modifier le sens du mot. Ex. : « im- » dans « impossible » ; « re- » dans « relire ». Le suffixe, lui, se place après le radical.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26d2e999-0836-52ea-beac-d55e58bce05d', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'Les mots « verre » (récipient), « vers » (poème), « vert » (couleur) et « ver » (animal) sont des :', '[{"id":"a","text":"Synonymes"},{"id":"b","text":"Antonymes"},{"id":"c","text":"Paronymes"},{"id":"d","text":"Homonymes"}]'::jsonb, 'd', 'Les homonymes sont des mots de prononciation identique mais de sens différents. « verre », « vers », « vert » et « ver » se prononcent tous [vɛʁ] mais n''ont pas le même sens.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca5f29a5-a523-5a3a-b6b2-f40db9ee0548', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'La figure de style qui consiste à attribuer des caractéristiques humaines à un objet, un animal ou une abstraction s''appelle :', '[{"id":"a","text":"Une hyperbole"},{"id":"b","text":"Une gradation"},{"id":"c","text":"Une personnification"},{"id":"d","text":"Une énumération"}]'::jsonb, 'c', 'La personnification attribue des caractéristiques humaines à ce qui n''est pas humain. Ex. : « La tempête hurlait sa fureur. » L''hyperbole est une exagération expressive ; la gradation est une suite ordonnée par intensité.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f43f9ef9-486d-5151-9ec5-2c5f7ad19738', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'Quelle est la différence entre une comparaison et une métaphore ?', '[{"id":"a","text":"La comparaison est toujours plus courte que la métaphore."},{"id":"b","text":"La comparaison utilise un outil comparatif explicite (comme, tel…) ; la métaphore identifie directement le comparé au comparant sans outil."},{"id":"c","text":"La métaphore utilise un outil comparatif ; la comparaison n''en utilise pas."},{"id":"d","text":"La comparaison s''applique uniquement aux personnes ; la métaphore aux objets."}]'::jsonb, 'b', 'La comparaison rapproche deux éléments à l''aide d''un outil comparatif (comme, tel, pareil à…). La métaphore fait le même rapprochement mais sans outil : elle identifie directement le comparé au comparant. Ex. : « fort comme un lion » (comparaison) vs « ce guerrier est un lion » (métaphore).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0adce953-7057-5641-b1cb-337665f8da31', '8d1de601-0c73-557f-a3b4-d45a964a2872', 'Quelle est la différence entre le champ lexical et le champ sémantique ?', '[{"id":"a","text":"Le champ lexical regroupe les différents sens d''un mot ; le champ sémantique regroupe tous les mots liés à un thème."},{"id":"b","text":"Le champ lexical regroupe tous les mots liés à un thème ; le champ sémantique regroupe les différents sens d''un même mot selon le contexte."},{"id":"c","text":"Le champ lexical est synonyme du champ sémantique."},{"id":"d","text":"Le champ lexical concerne uniquement les adjectifs ; le champ sémantique concerne les verbes."}]'::jsonb, 'b', 'Le champ lexical regroupe tous les mots (de catégories variées) se rapportant à un même thème. Le champ sémantique d''un mot regroupe tous les sens différents que ce mot peut avoir selon le contexte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b3042e50-068f-5b9f-91d5-e64df884f924', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', 'Exercice : vocabulaire et figures de style', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7b276c1-df61-5015-a396-ac06265465c7', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans le mot « impossible », quel est le rôle du préfixe « im- » ?', '[{"id":"a","text":"Il exprime le contraire (sens privatif)."},{"id":"b","text":"Il exprime la répétition."},{"id":"c","text":"Il indique une action passée."},{"id":"d","text":"Il transforme le mot en adverbe."}]'::jsonb, 'a', 'Le préfixe « im- » (variante de « in- » devant p/b/m) est privatif : il donne le sens contraire, ici « non possible ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cd7fbf9-2cc6-5eb7-879f-94d9ee76d569', 'b3042e50-068f-5b9f-91d5-e64df884f924', '« Verre » (récipient) et « ver » (animal) sont des :', '[{"id":"a","text":"Homonymes"},{"id":"b","text":"Synonymes"},{"id":"c","text":"Antonymes"},{"id":"d","text":"Paronymes"}]'::jsonb, 'a', 'Ces mots se prononcent de manière identique mais ont des sens et des orthographes différents : ce sont des homonymes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('120db6b4-7f11-50e3-bbd3-e8ab5cbe63ff', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans « La peur dévorait le guerrier », le mot « dévorait » est employé au :', '[{"id":"a","text":"Sens figuré"},{"id":"b","text":"Sens propre"},{"id":"c","text":"Sens technique"},{"id":"d","text":"Sens dénotatif uniquement"}]'::jsonb, 'a', 'La peur ne peut pas manger au sens propre : « dévorait » est ici employé au sens figuré pour exprimer l''intensité de la peur qui ronge le guerrier.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e29bdbfe-677e-5173-8a30-dc1ddc813fe8', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Lequel de ces mots n''appartient PAS à la famille du mot « terre » ?', '[{"id":"a","text":"terrestre"},{"id":"b","text":"enterrer"},{"id":"c","text":"terrible"},{"id":"d","text":"territoire"}]'::jsonb, 'c', '« terrible » vient du latin « terrere » (effrayer) et n''a pas le même radical que « terre ». Les trois autres partagent le radical « terr- » lié à la terre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e3d2494-fea2-5244-b1a6-622c5560913b', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Identifie la figure de style dans : « Il tremblait, frissonnait, grelottait de terreur. »', '[{"id":"a","text":"Métaphore"},{"id":"b","text":"Hyperbole"},{"id":"c","text":"Personnification"},{"id":"d","text":"Gradation"}]'::jsonb, 'd', 'Les trois verbes expriment le même état (le froid/la peur) avec une intensité croissante : c''est une gradation (ascendante).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8a55df7-3f25-5d5b-8ea5-5f14e3c12204', 'b3042e50-068f-5b9f-91d5-e64df884f924', 'Dans « Le vent **hurlait** entre les ruines », quelle figure de style reconnaît-on ?', '[{"id":"a","text":"Comparaison"},{"id":"b","text":"Hyperbole"},{"id":"c","text":"Énumération"},{"id":"d","text":"Personnification"}]'::jsonb, 'd', 'Attribuer au vent l''action « hurler » (cri humain) lui confère une caractéristique humaine : c''est une personnification.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25f31af7-de92-57ff-93ce-e6dc3127c707', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', '⚔️ Boss : lexique et figures de style', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e344432-2f71-56d6-abf1-5c8c31d537c9', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Dans ce passage, quel est le champ lexical dominant ? « Les lames claquaient, les boucliers résonnaient, les flèches sifflaient, le sang coulait. »', '[{"id":"a","text":"La nature"},{"id":"b","text":"Le combat / la guerre"},{"id":"c","text":"La musique"},{"id":"d","text":"Le voyage"}]'::jsonb, 'b', 'Les mots « lames », « boucliers », « flèches », « sang » appartiennent tous au champ lexical du combat et de la guerre, qui est le thème dominant du passage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24a82297-67c0-5306-9121-6efc815a919e', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Dans « La victoire sourit à ceux qui persévèrent », quelle figure reconnaît-on ?', '[{"id":"a","text":"Hyperbole"},{"id":"b","text":"Comparaison"},{"id":"c","text":"Personnification"},{"id":"d","text":"Gradation"}]'::jsonb, 'c', 'La victoire (abstraction) accomplit l''action humaine de « sourire » : on lui attribue une caractéristique humaine, c''est une personnification.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bfeec0f-5f54-5365-9c20-356635d68e1c', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quel mot a une connotation POSITIVE dans tous les contextes culturels courants ?', '[{"id":"a","text":"ténèbres"},{"id":"b","text":"aurore"},{"id":"c","text":"vautour"},{"id":"d","text":"rouille"}]'::jsonb, 'b', '« Aurore » (aube, début du jour) est universellement associée à l''espoir, au renouveau, au début positif. Les autres ont des connotations négatives (ténèbres = obscurité/mal ; vautour = prédateur/opportuniste ; rouille = dégradation).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73d9a740-8761-50f2-a74c-f66483150482', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quelle phrase contient une comparaison (et non une métaphore) ?', '[{"id":"a","text":"Ses yeux étaient des étoiles."},{"id":"b","text":"Ses yeux brillaient comme des étoiles."},{"id":"c","text":"Des étoiles l''observaient."},{"id":"d","text":"Ses étoiles-yeux scintillaient."}]'::jsonb, 'b', 'La présence de l''outil comparatif « comme » fait de cette phrase une comparaison. Sans cet outil, « ses yeux étaient des étoiles » serait une métaphore.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a08dc674-1ad0-5709-ac2a-91fb09b03e23', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Quelle est la différence entre « éruption » et « irruption » ?', '[{"id":"a","text":"Ce sont des synonymes qui désignent tous les deux une explosion."},{"id":"b","text":"« Éruption » = jaillissement (volcan) ; « irruption » = entrée brusque et violente."},{"id":"c","text":"« Irruption » = jaillissement (volcan) ; « éruption » = entrée brusque."},{"id":"d","text":"« Éruption » est le sens figuré de « irruption »."}]'::jsonb, 'b', 'Ce sont des paronymes : « éruption » désigne le jaillissement (volcan, peau) ; « irruption » désigne une entrée soudaine et non autorisée (« faire irruption »). Les confondre est une erreur de paronyme classique.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a654666-d0cf-5a81-9244-aad9397d5ddb', '25f31af7-de92-57ff-93ce-e6dc3127c707', 'Identifie la figure de style dans : « Ce général, c''était un roc, une montagne, un géant. »', '[{"id":"a","text":"Gradation et métaphores"},{"id":"b","text":"Comparaison et énumération"},{"id":"c","text":"Hyperbole et personnification"},{"id":"d","text":"Énumération et comparaisons"}]'::jsonb, 'a', 'Trois métaphores (sans outil comparatif : « un roc », « une montagne », « un géant ») s''enchaînent avec une intensité croissante : c''est une gradation de métaphores.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', '👑 Défi élite : figures et effets stylistiques', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f3ed481-20e3-5434-bc4b-65cadb9635ea', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Identifie la figure de style et son effet dans : « Le Tout-Paris s''était donné rendez-vous pour applaudir la prima donna. »', '[{"id":"a","text":"Hyperbole : l''auteur exagère le nombre de spectateurs pour souligner le succès."},{"id":"b","text":"Métonymie : « le Tout-Paris » désigne l''élite parisienne par le nom de la ville, créant un effet de mondanité et d''exclusivité."},{"id":"c","text":"Personnification : Paris est présenté comme un être vivant capable de se déplacer."},{"id":"d","text":"Synecdoque : la partie (Paris) représente le tout (la France entière)."}]'::jsonb, 'b', '« Le Tout-Paris » est une métonymie : on désigne un groupe social (l''élite, le gratin parisien) par le nom du lieu associé à ce groupe. Ce procédé crée un effet d''exclusivité et de prestige. Ce n''est pas une synecdoque (qui substitue la partie au tout ou inversement à l''intérieur du même référent), ni une hyperbole (il n''y a pas d''exagération chiffrée), ni une personnification (Paris n''accomplit pas d''action proprement humaine).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a19b37f7-b80e-5ae9-bbcf-129d2677cdb6', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Quelle figure de style domine dans ce passage, et quel est son effet ? « Il faisait grand jour dehors ; dans son âme régnait une nuit éternelle. »', '[{"id":"a","text":"Métaphore : « nuit éternelle » remplace directement « tristesse » sans outil comparatif, créant une image sombre."},{"id":"b","text":"Comparaison : l''auteur compare l''âme au jour et à la nuit pour montrer le contraste."},{"id":"c","text":"Antithèse : l''opposition entre « grand jour » et « nuit éternelle » / entre le dehors et l''âme met en relief le désespoir intérieur du personnage."},{"id":"d","text":"Oxymore : deux termes contradictoires sont juxtaposés dans la même expression pour créer un paradoxe."}]'::jsonb, 'c', 'La figure dominante est l''antithèse : deux idées contraires (grand jour / nuit éternelle ; dehors / âme) sont placées en opposition dans deux propositions symétriques. L''effet est de souligner le fossé entre la réalité extérieure lumineuse et le désespoir intérieur du personnage. L''oxymore exige que les deux termes contraires soient juxtaposés dans une seule expression (ex. : « obscure clarté ») ; ce n''est pas le cas ici. La métaphore est bien présente (« nuit éternelle »), mais elle est au service de l''antithèse, qui est la figure structurante de la phrase.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5ce42e1-de4b-5b66-b8a0-880ca8b71616', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Dans « Un souffle, une ombre, un rien lui faisait peur », quelle figure précise reconnaît-on et quel est son effet ?', '[{"id":"a","text":"Énumération : une liste de trois éléments sans ordre particulier renforce l''idée de la peur."},{"id":"b","text":"Hyperbole : l''accumulation exagère la peur du personnage pour la rendre comique."},{"id":"c","text":"Gradation décroissante : les termes (souffle → ombre → rien) diminuent en substance, suggérant que la peur du personnage est si intense qu''elle n''a besoin d''aucun objet réel pour exister."},{"id":"d","text":"Comparaison : le personnage est comparé implicitement à quelqu''un d''aussi léger qu''un souffle."}]'::jsonb, 'c', 'Les trois termes forment une gradation décroissante : « un souffle » (quelque chose de très léger), « une ombre » (une forme à peine perceptible), « un rien » (l''absence totale d''objet réel). L''intensité de la peur est ainsi exaltée par le paradoxe : même le néant terrifie le personnage. Ce n''est pas une simple énumération, car les termes sont ordonnés par intensité décroissante — c''est précisément ce critère d''ordre qui définit la gradation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1665f4a2-f2d4-5b90-a73f-cfd8ebc25d82', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Identifie la figure de style dans ce passage et explique sa construction : « La vie est un voyage : nous embarquons à la naissance, naviguons à travers les tempêtes du destin, et jetons enfin l''ancre au seuil de la mort. »', '[{"id":"a","text":"Comparaison filée : la vie est comparée à un voyage grâce à l''outil implicite « est »."},{"id":"b","text":"Métaphore filée : la métaphore initiale (« la vie est un voyage ») est développée et entretenue sur toute la phrase par un réseau cohérent de termes maritimes (embarquer, naviguer, ancre)."},{"id":"c","text":"Personnification : la vie, le destin et la mort accomplissent des actions humaines tout au long du passage."},{"id":"d","text":"Gradation : les étapes de la vie (naissance, destin, mort) sont énumérées par ordre chronologique croissant."}]'::jsonb, 'b', 'Il s''agit d''une métaphore filée : la métaphore inaugurale (« la vie est un voyage ») est prolongée et cohérente sur l''ensemble du passage grâce à un réseau lexical maritime (embarquons, naviguons, tempêtes, ancre). C''est une métaphore et non une comparaison, car aucun outil comparatif (comme, tel que…) n''est employé. La gradation suppose un ordre d''intensité croissante ou décroissante, non une simple succession chronologique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aca78fb2-be94-515e-93e9-07de78b76084', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Quelle figure de style est employée dans « La forêt retenait son souffle », et quel effet produit-elle ?', '[{"id":"a","text":"Métaphore : la forêt est présentée directement comme un être vivant équivalent à un animal."},{"id":"b","text":"Hyperbole : l''expression exagère le silence de la forêt pour créer un effet de grandeur."},{"id":"c","text":"Comparaison : la forêt est comparée implicitement à un être humain qui retient son souffle."},{"id":"d","text":"Personnification : on attribue à la forêt (élément naturel) un geste proprement humain (retenir son souffle), créant une atmosphère de tension et de silence angoissant."}]'::jsonb, 'd', '« Retenir son souffle » est un comportement humain attribué à la forêt (un élément de la nature) : c''est bien une personnification. L''effet est double : il crée une atmosphère de tension suspendue et il invite le lecteur à percevoir la forêt comme une présence consciente et inquiète. Ce n''est pas une comparaison (absence d''outil comparatif), ni une simple métaphore nominale (la forêt n''est pas identifiée à un être précis), ni une hyperbole (l''expression ne repose pas sur l''exagération mais sur l''attribution d''une faculté humaine).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe2204e3-3db5-5b36-9d8c-58bb455001d2', '187b2c98-92ea-540b-a7e7-5dd9c2fa383a', 'Dans la phrase « Il dévora les pages de ce roman en une nuit, assoiffé de mots », quel procédé stylistique est à l''œuvre et qu''apporte-t-il au sens ?', '[{"id":"a","text":"Hyperbole : « en une nuit » exagère la rapidité de lecture pour montrer l''enthousiasme du lecteur."},{"id":"b","text":"Comparaison : le lecteur est comparé à un animal affamé grâce à l''image implicite de la dévoration."},{"id":"c","text":"Métaphore verbale : « dévorer » (manger avidement) est employé au sens figuré pour désigner une lecture intense et passionnée, faisant du livre un aliment spirituel."},{"id":"d","text":"Personnification : les pages sont présentées comme des êtres vivants que l''on peut consommer."}]'::jsonb, 'c', 'Le verbe « dévorer » est ici employé au sens figuré : il transpose l''action de manger (sens propre, physique) à l''acte de lire (sens figuré, intellectuel). C''est une métaphore verbale — aucun outil comparatif n''est présent — qui assimile la lecture à une ingestion avide et crée l''image du livre comme nourriture de l''esprit. L''expression « assoiffé de mots » prolonge cette métaphore en ajoutant la soif au réseau sensoriel. Ce n''est pas une hyperbole, car l''effet ne repose pas sur une exagération quantitative mais sur le transfert de sens d''un verbe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a915ce86-0073-5030-8656-f315f5857408', 'cca88b2d-cbd8-5e2a-a496-e9c176a67244', 'french', '🛡️ Entraînement examen : lexique et figures de style', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c5c580c-f674-5b9e-a61a-fa3b441de12e', 'a915ce86-0073-5030-8656-f315f5857408', 'Quelle figure de style reconnaît-on dans « Cet homme est un lion au combat. » ?', '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une hyperbole"},{"id":"d","text":"Une personnification"}]'::jsonb, 'b', 'On identifie l''homme à un lion SANS outil de comparaison (« comme », « tel ») : c''est une métaphore. Avec « comme un lion », ce serait une comparaison (a) ; l''hyperbole exagère (c) ; la personnification prête des traits humains à une chose (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53bfe9eb-7729-5bb4-8122-c4019895f276', 'a915ce86-0073-5030-8656-f315f5857408', 'Quelle figure de style est employée dans « Le vent murmurait dans les arbres. » ?', '[{"id":"a","text":"Une métaphore"},{"id":"b","text":"Une comparaison"},{"id":"c","text":"Une personnification"},{"id":"d","text":"Une antithèse"}]'::jsonb, 'c', 'On attribue au vent une action humaine (« murmurer ») : c''est une personnification. Ce n''est pas une identification imagée (métaphore, a), il n''y a pas d''outil de comparaison (b), ni d''opposition de deux idées (antithèse, d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acd5d4f4-3238-5d8b-8c16-1ba4346feb72', 'a915ce86-0073-5030-8656-f315f5857408', 'Dans « Je t''ai dit mille fois de ranger ta chambre ! », quelle figure exprime l''exagération ?', '[{"id":"a","text":"L''hyperbole"},{"id":"b","text":"La litote"},{"id":"c","text":"La métaphore"},{"id":"d","text":"L''euphémisme"}]'::jsonb, 'a', '« mille fois » exagère volontairement le nombre : c''est une hyperbole. La litote dit moins pour suggérer plus (b), l''euphémisme atténue (d), la métaphore est une image (c).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30e3f6ac-866e-5a8e-8102-b6096ae5e4e5', 'a915ce86-0073-5030-8656-f315f5857408', 'Quel est le sens du préfixe « in- / im- » dans « impossible », « invisible » ?', '[{"id":"a","text":"Il indique la répétition"},{"id":"b","text":"Il exprime la négation, le contraire"},{"id":"c","text":"Il indique le lieu"},{"id":"d","text":"Il exprime le superlatif"}]'::jsonb, 'b', 'Le préfixe « in-/im- » exprime la négation : impossible = qui n''est pas possible, invisible = qui n''est pas visible. La répétition est marquée par « re- » (a) ; ce préfixe n''indique ni un lieu (c) ni un degré superlatif (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2cd69bc-3db3-5827-8a83-57bcf033de86', 'a915ce86-0073-5030-8656-f315f5857408', 'Quelle phrase contient une antithèse ?', '[{"id":"a","text":"Il marche lentement vers la maison."},{"id":"b","text":"Cet enfant est vif comme l''éclair."},{"id":"c","text":"Ici tout n''est qu''ombre et lumière."},{"id":"d","text":"La rivière chantait doucement."}]'::jsonb, 'c', 'L''antithèse rapproche deux mots de sens opposés : « ombre » et « lumière ». L''option b est une comparaison, d une personnification, a une phrase ordinaire sans figure d''opposition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe6bf775-0956-5d95-956d-e49d795a9617', 'a915ce86-0073-5030-8656-f315f5857408', 'Lisez la phrase : « Après l''examen, il n''était pas mécontent de sa note. »

Quelle figure de style et quel sens véhicule « n''était pas mécontent » ?', '[{"id":"a","text":"Une hyperbole : il était extrêmement déçu."},{"id":"b","text":"Une litote : il était en réalité plutôt satisfait."},{"id":"c","text":"Une métaphore : sa note était un trésor."},{"id":"d","text":"Une personnification : la note ressentait quelque chose."}]'::jsonb, 'b', '« n''était pas mécontent » est une litote : on dit moins (forme atténuée et négative) pour suggérer plus (il était en fait content). Ce n''est pas une exagération (a), il n''y a aucune image (c) ni objet humanisé (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d49bcd74-d20a-552c-9658-c0d86e053975', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', 'Quiz de compréhension', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee69c6c1-c5df-5cd9-9da9-046389fb356f', 'd49bcd74-d20a-552c-9658-c0d86e053975', 'Quel est le but principal d''un texte argumentatif ?', '[{"id":"a","text":"Raconter une suite d''événements."},{"id":"b","text":"Décrire un personnage ou un lieu."},{"id":"c","text":"Expliquer un phénomène de façon neutre."},{"id":"d","text":"Convaincre le lecteur et défendre une thèse."}]'::jsonb, 'd', 'Le texte argumentatif a pour but de convaincre le lecteur en défendant une thèse. On y trouve des arguments, des exemples et des connecteurs logiques (cependant, donc, or…).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5881556-ec1e-57f7-9dde-d113d29c8710', 'd49bcd74-d20a-552c-9658-c0d86e053975', 'Dans le schéma narratif, quel élément rompt l''équilibre initial et déclenche l''histoire ?', '[{"id":"a","text":"La situation initiale"},{"id":"b","text":"Les péripéties"},{"id":"c","text":"L''élément perturbateur"},{"id":"d","text":"La situation finale"}]'::jsonb, 'c', 'L''élément perturbateur (ou déclencheur) rompt l''équilibre de la situation initiale et lance les péripéties. Il est généralement exprimé par un verbe d''action au passé simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17071935-7310-51c2-a8d6-00bbac4c3e23', 'd49bcd74-d20a-552c-9658-c0d86e053975', 'Dans un texte narratif, quel temps est principalement utilisé pour les actions ponctuelles qui font avancer le récit ?', '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le présent de vérité générale"},{"id":"c","text":"Le plus-que-parfait"},{"id":"d","text":"Le passé simple"}]'::jsonb, 'd', 'Dans un récit littéraire, le passé simple exprime les actions ponctuelles et délimitées qui font progresser l''histoire. L''imparfait, lui, est réservé aux descriptions et aux actions de fond.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72632bce-eb90-5864-8b0a-fd10908fafe1', 'd49bcd74-d20a-552c-9658-c0d86e053975', 'Quels temps verbaux caractérisent avant tout le texte descriptif ?', '[{"id":"a","text":"Le passé simple et le passé antérieur"},{"id":"b","text":"L''imparfait (dans un récit) ou le présent (description autonome)"},{"id":"c","text":"Le futur simple et le conditionnel présent"},{"id":"d","text":"Le subjonctif présent et l''impératif"}]'::jsonb, 'b', 'Le texte descriptif emploie l''imparfait (description insérée dans un récit) ou le présent (description autonome), avec des adjectifs qualificatifs, des verbes d''état et des comparaisons.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4bf56ff-2ae1-5126-9019-5800347aa34a', 'd49bcd74-d20a-552c-9658-c0d86e053975', 'Quel connecteur logique exprime une relation de conséquence ?', '[{"id":"a","text":"cependant"},{"id":"b","text":"par exemple"},{"id":"c","text":"donc"},{"id":"d","text":"auparavant"}]'::jsonb, 'c', '« donc » (ainsi que « c''est pourquoi », « par conséquent ») est un connecteur de conséquence. « cependant » exprime l''opposition, « par exemple » l''illustration, et « auparavant » l''antériorité temporelle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('216407d2-5ccf-54fb-bd5c-03550dcaa2e1', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', 'Exercice : types de textes et production écrite', 2, 75, 15, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cfa6dc4-e445-543e-9cdf-1baae0c8f842', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel type de texte cherche principalement à convaincre le lecteur d''adopter une opinion ?', '[{"id":"a","text":"Argumentatif"},{"id":"b","text":"Narratif"},{"id":"c","text":"Descriptif"},{"id":"d","text":"Explicatif"}]'::jsonb, 'a', 'Le texte argumentatif vise à défendre une thèse et à convaincre le lecteur à l''aide d''arguments et d''exemples.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00a19639-3883-5d3c-8924-c94faf49d549', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans le schéma narratif, quel est l''élément qui rompt l''équilibre initial et déclenche l''action ?', '[{"id":"a","text":"L''élément perturbateur"},{"id":"b","text":"La situation finale"},{"id":"c","text":"Le dénouement"},{"id":"d","text":"Les péripéties"}]'::jsonb, 'a', 'L''élément perturbateur (ou déclencheur) est l''événement qui brise l''équilibre de la situation initiale et met le récit en mouvement.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db7ecffa-12db-5ebe-a71f-0b59145133eb', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel connecteur exprime une relation de CAUSE ?', '[{"id":"a","text":"donc"},{"id":"b","text":"cependant"},{"id":"c","text":"ensuite"},{"id":"d","text":"car"}]'::jsonb, 'd', '« Car » est un connecteur de cause (il introduit la raison d''un fait). « Donc » exprime la conséquence, « cependant » l''opposition, « ensuite » la succession temporelle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4032fad4-617f-58e6-b390-53e4b2c6c1c6', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Quel indice est caractéristique d''un texte DESCRIPTIF ?', '[{"id":"a","text":"Une thèse et des arguments"},{"id":"b","text":"Des verbes d''action au passé simple"},{"id":"c","text":"Des connecteurs cause/conséquence"},{"id":"d","text":"De nombreux adjectifs qualificatifs et des verbes d''état"}]'::jsonb, 'd', 'Le texte descriptif se reconnaît à l''abondance d''adjectifs qualificatifs, de verbes d''état (être, paraître, sembler) et de l''imparfait, qui peignent une réalité sans la faire évoluer.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61ccedd3-9052-5b32-ab73-cd1879d56ae7', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans quel ordre se succèdent les étapes du schéma narratif ?', '[{"id":"a","text":"Élément perturbateur → situation initiale → péripéties → situation finale → dénouement"},{"id":"b","text":"Situation initiale → élément perturbateur → péripéties → dénouement → situation finale"},{"id":"c","text":"Situation initiale → péripéties → élément perturbateur → dénouement → situation finale"},{"id":"d","text":"Situation initiale → dénouement → péripéties → élément perturbateur → situation finale"}]'::jsonb, 'b', 'Le schéma narratif canonique comporte cinq étapes dans cet ordre précis : situation initiale, élément perturbateur, péripéties, dénouement, situation finale.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cc0e08b-af9c-5dce-b02f-5bd6587bd103', '216407d2-5ccf-54fb-bd5c-03550dcaa2e1', 'Dans une lettre formelle, où place-t-on habituellement le lieu et la date ?', '[{"id":"a","text":"En bas de la lettre, après la signature"},{"id":"b","text":"Au centre, comme titre"},{"id":"c","text":"En haut à gauche, sous le destinataire"},{"id":"d","text":"En haut à droite, avant la formule d''appel"}]'::jsonb, 'd', 'Dans une lettre formelle française, le lieu et la date se placent en haut à droite, avant la formule d''appel (ex. : « Tunis, le 2 juin 2026 »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('981642c4-6f55-5171-897c-bdf40e984522', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', '⚔️ Boss : types de textes et production écrite', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed57c56c-2714-58cf-b436-afc5b1f0fb55', '981642c4-6f55-5171-897c-bdf40e984522', 'Lis ce passage : « Le volcan entre en éruption lorsque la pression des gaz et du magma dépasse la résistance de la roche. La lave jaillit alors par le cratère et dévale les pentes. » Quel est le type dominant ?', '[{"id":"a","text":"Explicatif"},{"id":"b","text":"Narratif"},{"id":"c","text":"Descriptif"},{"id":"d","text":"Argumentatif"}]'::jsonb, 'a', 'Le passage explique un phénomène naturel (l''éruption) à l''aide d''une relation cause/effet et du présent de vérité générale : c''est un texte explicatif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a704ca25-4e84-5194-ae74-d707994df17e', '981642c4-6f55-5171-897c-bdf40e984522', 'Un élève écrit : « Les jeux vidéo sont néfastes pour les jeunes. En effet, ils réduisent le temps consacré aux devoirs. Par exemple, une étude montre que les joueurs réguliers ont de moins bonnes notes. » Quelle structure reconnaît-on ?', '[{"id":"a","text":"Thèse + argument + exemple"},{"id":"b","text":"Situation initiale + élément perturbateur"},{"id":"c","text":"Description spatiale + cinq sens"},{"id":"d","text":"Cause + conséquence + opposition"}]'::jsonb, 'a', 'La première phrase est la thèse (position défendue), « En effet » introduit un argument (raison), et « Par exemple » illustre par un exemple concret : c''est la structure argumentative classique.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3088ed38-3f25-5167-aa73-a51d2fb61486', '981642c4-6f55-5171-897c-bdf40e984522', 'Quelle étape du schéma narratif correspond à ce passage : « Enfin, le héros retrouva son village en paix et ses amis l''accueillirent avec joie. » ?', '[{"id":"a","text":"Élément perturbateur"},{"id":"b","text":"Situation finale"},{"id":"c","text":"Péripéties"},{"id":"d","text":"Situation initiale"}]'::jsonb, 'b', 'Ce passage décrit le nouvel état d''équilibre atteint après la résolution du conflit : c''est la situation finale, dernière étape du schéma narratif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16ef4fd9-0bf8-5dcc-bcee-af59ae8bdb12', '981642c4-6f55-5171-897c-bdf40e984522', 'Quelle formule de politesse convient à la clôture d''une lettre formelle adressée à un directeur ?', '[{"id":"a","text":"« Veuillez agréer, Monsieur le Directeur, l''expression de mes salutations distinguées. »"},{"id":"b","text":"« Bisous et à bientôt ! »"},{"id":"c","text":"« Cordialement, ton ami. »"},{"id":"d","text":"« En espérant une réponse rapide. »"}]'::jsonb, 'a', 'La lettre formelle exige une formule de politesse complète reprenant le titre du destinataire. Les options b, c et d appartiennent au registre familier ou sont incomplètes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64e55faa-0a53-52af-8b05-97dd07023788', '981642c4-6f55-5171-897c-bdf40e984522', 'Quel connecteur logique complète le mieux cette phrase argumentative : « Ce projet est ambitieux ; _____, il est tout à fait réalisable. » ?', '[{"id":"a","text":"car"},{"id":"b","text":"donc"},{"id":"c","text":"ensuite"},{"id":"d","text":"cependant"}]'::jsonb, 'd', '« Cependant » exprime la concession/opposition : on admet une limite (projet ambitieux) tout en la nuançant (mais réalisable). C''est le connecteur d''opposition qui convient ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29b2923e-5b05-5c0d-abd3-f0e7bb7dd6eb', '981642c4-6f55-5171-897c-bdf40e984522', 'Pour décrire une salle de château de façon méthodique, quelle organisation est la plus adaptée ?', '[{"id":"a","text":"Un plan chronologique (du passé au présent)"},{"id":"b","text":"Un plan thèse/antithèse/synthèse"},{"id":"c","text":"Un plan spatial (par exemple : de l''entrée vers le fond, puis de gauche à droite)"},{"id":"d","text":"Un plan cause/conséquence"}]'::jsonb, 'c', 'La description d''un lieu s''organise selon un plan spatial (point de vue du regard qui se déplace) pour guider le lecteur de manière cohérente et vivante.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', '👑 Défi élite : maîtrise des types de textes', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef5d7171-95a0-578b-bc28-53b6fe14dad2', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Lis attentivement cet extrait : « La déforestation s''accélère en raison de l''expansion agricole et de l''exploitation du bois. Par conséquent, des millions d''animaux perdent leur habitat chaque année. Les forêts, vastes étendues verdoyantes aux arbres centenaires, disparaissent à un rythme alarmant. » Le passage contient des éléments descriptifs ET explicatifs. Quel est le TYPE DOMINANT et pourquoi ?', '[{"id":"a","text":"Descriptif, car les « vastes étendues verdoyantes » prouvent que la description prime sur tout."},{"id":"b","text":"Explicatif, car la structure cause/conséquence (« en raison de » / « par conséquent ») organise le sens du passage ; la description est au service de l''explication."},{"id":"c","text":"Narratif, car le texte relate des événements dans le temps grâce aux verbes d''action."},{"id":"d","text":"Argumentatif, car l''auteur dénonce la déforestation et cherche à convaincre le lecteur."}]'::jsonb, 'b', 'Le squelette du passage repose sur une relation cause/conséquence (« en raison de » → cause ; « par conséquent » → conséquence) et sur le présent de vérité générale : ce sont les marques de l''explicatif. L''adjectif descriptif « verdoyantes » est un élément secondaire qui illustre, mais ne gouverne pas la logique du texte. L''option d est un piège : dénoncer n''est pas argumenter si aucune thèse personnelle ni structure thèse/argument n''est présente.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('588ccf1f-d83f-5cb6-91a3-1d26330db329', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Dans cet extrait : « Il me semble évident que les écrans nuisent à la concentration des élèves. Certes, certains outils numériques peuvent faciliter l''apprentissage ; néanmoins, leur usage excessif demeure préjudiciable. » — quel procédé argumentatif est à l''œuvre dans la deuxième phrase ?', '[{"id":"a","text":"Une relation cause/effet introduite par « certes » et « néanmoins »."},{"id":"b","text":"Une concession suivie d''une réfutation partielle : on accorde un point à l''adversaire (« certes ») avant de maintenir sa thèse (« néanmoins »)."},{"id":"c","text":"Une illustration par l''exemple, car on cite le cas des outils numériques."},{"id":"d","text":"Une définition du terme « usage excessif » pour clarifier la thèse."}]'::jsonb, 'b', '« Certes » introduit une concession : l''énonciateur reconnaît une vérité partielle favorable à l''opposant. « Néanmoins » est un connecteur d''opposition/réfutation qui permet de maintenir la thèse initiale malgré cette concession. Ce procédé — concession + réfutation — est une figure argumentative avancée distincte de la simple cause/effet ou de l''illustration.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e33bc694-7409-5ed9-b465-5dafa064edd3', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Quel est le rôle du connecteur « or » dans cette phrase extraite d''un texte argumentatif : « Tout le monde admet que l''eau est une ressource inépuisable. Or, les nappes phréatiques s''épuisent à vue d''œil. » ?', '[{"id":"a","text":"Il exprime la postériorité temporelle, comme « ensuite » ou « puis »."},{"id":"b","text":"Il introduit une conséquence logique découlant de la première proposition."},{"id":"c","text":"Il introduit un fait qui contredit ou nuance la prémisse précédente, créant un retournement argumentatif."},{"id":"d","text":"Il indique une addition d''information, équivalent à « de plus »."}]'::jsonb, 'c', '« Or » est un connecteur logique d''opposition/retournement : il présente un fait nouveau qui infirme ou nuance ce qui vient d''être posé comme acquis. Ici, il invalide la croyance commune (« eau inépuisable ») par un constat contraire (nappes phréatiques qui s''épuisent). Il ne faut pas le confondre avec les connecteurs temporels (ensuite, puis) ni avec les connecteurs de conséquence (donc, ainsi).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d023279e-7134-5bd4-becb-6322f8306d5f', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Lis cet extrait : « Léa vivait paisiblement dans son village au bord de la rivière. Elle connaissait chaque habitant et passait ses journées à lire sous le grand chêne. Un matin, une lettre anonyme arriva et bouleversa son existence. » À quelle étape du schéma narratif correspond précisément la DERNIÈRE phrase ?', '[{"id":"a","text":"Situation initiale, car elle présente encore le cadre de vie de Léa."},{"id":"b","text":"Péripéties, car la lettre déclenche une série d''actions et d''aventures."},{"id":"c","text":"Élément perturbateur, car un événement soudain (passé simple « arriva ») rompt l''équilibre décrit dans les phrases précédentes."},{"id":"d","text":"Dénouement, car la situation de Léa est résolue après la réception de la lettre."}]'::jsonb, 'c', 'Les deux premières phrases (imparfait : « vivait », « connaissait », « passait ») décrivent l''état d''équilibre initial : c''est la situation initiale. La dernière phrase bascule au passé simple (« arriva », « bouleversa »), signalant un événement brusque qui rompt cet équilibre : c''est l''élément perturbateur. Le piège de l''option b est réel : les péripéties viennent APRÈS l''élément perturbateur, elles ne le constituent pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff0ae26c-d6d6-5f50-ba1c-9976a19069be', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Parmi ces quatre débuts de paragraphe de production écrite argumentative, lequel présente la structure la plus complète et la plus conforme aux exigences de l''examen du concours ?', '[{"id":"a","text":"« Premièrement, les réseaux sociaux sont dangereux pour les jeunes. »"},{"id":"b","text":"« De plus, il existe de nombreux problèmes liés à Internet, comme les virus et les arnaques, ce qui est très grave. »"},{"id":"c","text":"« En premier lieu, les réseaux sociaux favorisent l''isolement social. En effet, une étude menée en 2022 révèle que les adolescents utilisant ces plateformes plus de trois heures par jour déclarent se sentir plus seuls. Ainsi, l''usage intensif du numérique fragilise les liens réels. »"},{"id":"d","text":"« Les réseaux sociaux ont des avantages et des inconvénients, c''est pourquoi il faut en parler davantage. »"}]'::jsonb, 'c', 'L''option c respecte la structure attendue du paragraphe argumentatif : connecteur d''ordre (« en premier lieu ») + affirmation (argument) + connecteur de cause/preuve (« en effet ») + exemple concret et chiffré + connecteur de conséquence (« ainsi ») + conclusion partielle. Les options a et b manquent d''exemple et de conclusion partielle ; l''option d est vague et n''avance aucun argument réel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c7803ee-0d85-57e7-ba51-8abe476a5058', '1e8573c3-f5b0-53c4-afdf-0b71b3a6dd27', 'Lis cet extrait mixte : « La forêt était silencieuse et sombre, ses arbres tordus ressemblant à des géants endormis. Soudain, Karim entendit un craquement et se retourna brusquement. Il aperçut une silhouette qui disparaissait entre les troncs. » Quel indice prouve que le type NARRATIF est dominant malgré la forte présence descriptive ?', '[{"id":"a","text":"La comparaison « ressemblant à des géants endormis » montre que la description domine le récit."},{"id":"b","text":"L''imparfait (« était », « ressemblant ») et le passé simple (« entendit », « se retourna », « aperçut ») coexistent : l''imparfait assure le fond descriptif, mais c''est la chaîne de passés simples qui fait avancer l''action et structure le texte — signe que le narratif est dominant."},{"id":"c","text":"Le mot « Soudain » est un adjectif qualificatif qui renforce la description de l''atmosphère."},{"id":"d","text":"Le texte est descriptif, car il ne contient aucun connecteur logique de type argumentatif."}]'::jsonb, 'b', 'Dans un texte mixte narratif-descriptif, le type dominant se repère à la fonction des temps : l''imparfait crée le décor (arrière-plan descriptif), tandis que le passé simple fait progresser la séquence d''actions (premier plan narratif). Ici, « entendit », « se retourna », « aperçut » forment une chaîne d''événements successifs qui constituent le moteur du passage : le narratif est donc dominant. « Soudain » est un adverbe de temps (connecteur temporel), non un adjectif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ce9c4aa-e64f-5a76-9812-ada88908a485', '383392ce-53c3-5d10-b090-6f6f48124bee', 'french', '🛡️ Entraînement examen : types de textes et production écrite', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04989013-8b32-54af-9f7c-bfda1f5b94c3', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Lisez ce passage :

« La girafe est un mammifère herbivore. Elle possède un long cou qui lui permet d''atteindre les feuilles des arbres les plus hauts. On la trouve principalement dans les savanes d''Afrique. »

À quel type de texte appartient ce passage ?', '[{"id":"a","text":"Texte narratif"},{"id":"b","text":"Texte explicatif (informatif)"},{"id":"c","text":"Texte argumentatif"},{"id":"d","text":"Texte injonctif"}]'::jsonb, 'b', 'Le passage donne des informations objectives pour faire connaître un animal : c''est un texte explicatif/informatif. Il ne raconte pas d''histoire (a), ne défend pas d''opinion (c) et ne donne pas d''instructions (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b78c3fb5-fcde-5273-a96f-d92327df9696', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Quel texte est de type injonctif ?', '[{"id":"a","text":"Il était une fois un roi qui vivait dans un grand château."},{"id":"b","text":"Mélangez la farine et les œufs, puis ajoutez le lait."},{"id":"c","text":"À mon avis, lire est le meilleur des loisirs."},{"id":"d","text":"Le ciel était gris et la mer agitée."}]'::jsonb, 'b', 'Le texte injonctif donne des consignes, souvent à l''impératif : « Mélangez… ajoutez… » (recette). L''option a est narrative, c argumentative, d descriptive.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3cc97403-7633-5b14-a33a-bbaf609673fe', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Dans le schéma narratif, comment appelle-t-on l''événement qui rompt l''équilibre initial et lance l''action ?', '[{"id":"a","text":"La situation finale"},{"id":"b","text":"L''élément perturbateur (déclencheur)"},{"id":"c","text":"La situation initiale"},{"id":"d","text":"Le dénouement"}]'::jsonb, 'b', 'L''élément perturbateur (ou déclencheur) brise l''équilibre de la situation initiale et met l''histoire en mouvement. La situation initiale (c) présente l''équilibre de départ, les péripéties suivent, et le dénouement (d) puis la situation finale (a) closent le récit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ef3f634-b2aa-5389-83a4-70599facfb28', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Quel connecteur logique exprime une CONSÉQUENCE ?', '[{"id":"a","text":"parce que"},{"id":"b","text":"par conséquent"},{"id":"c","text":"cependant"},{"id":"d","text":"d''abord"}]'::jsonb, 'b', '« par conséquent » introduit la conséquence d''un fait. « parce que » exprime la cause (a), « cependant » l''opposition (c), « d''abord » l''ordre/le temps (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16c1a42e-8fb9-5626-bedc-2fe32244e119', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Lisez ce passage :

« Je pense que les jeux vidéo ne sont pas seulement une perte de temps. En effet, certains développent la réflexion et la rapidité. C''est pourquoi il faut savoir les utiliser avec mesure. »

À quel type de texte appartient ce passage ?', '[{"id":"a","text":"Texte descriptif"},{"id":"b","text":"Texte argumentatif"},{"id":"c","text":"Texte narratif"},{"id":"d","text":"Texte explicatif"}]'::jsonb, 'b', 'L''auteur défend une opinion (« Je pense que… ») avec un argument (« En effet… ») et une conclusion (« C''est pourquoi… ») : c''est un texte argumentatif. Il ne décrit pas (a), ne raconte pas (c) et ne se contente pas d''informer objectivement (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c9ed809-1bc2-594e-8afc-b4b3607537a4', '8ce9c4aa-e64f-5a76-9812-ada88908a485', 'Dans un paragraphe argumentatif, quel est le rôle de la phrase introduite par « Par exemple » ?', '[{"id":"a","text":"Annoncer l''idée principale de l''auteur."},{"id":"b","text":"Illustrer l''argument par un cas concret."},{"id":"c","text":"Réfuter l''opinion adverse."},{"id":"d","text":"Conclure le paragraphe."}]'::jsonb, 'b', '« Par exemple » introduit une illustration : un cas concret qui appuie l''argument. L''idée principale s''annonce sans connecteur d''exemple (a), la réfutation emploie « certes… mais » (c), et la conclusion utilise « ainsi », « donc » (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('357f5e8d-e17d-5fd3-a688-7a04622ccff7', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Diagnostic — Compréhension & production', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88c1f48a-2a35-5d6c-874a-6cec41778111', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce passage :

« La lecture n''est pas un simple passe-temps. En ouvrant un livre, l''élève enrichit son vocabulaire, voyage dans d''autres mondes et apprend à mieux comprendre les autres. Voilà pourquoi lire devrait accompagner chaque jeune tout au long de ses études. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"La lecture fait perdre du temps aux élèves."},{"id":"b","text":"La lecture est précieuse et devrait accompagner toute la scolarité."},{"id":"c","text":"Les livres parlent surtout de voyages lointains."},{"id":"d","text":"Le vocabulaire est la seule chose qu''on apprend en lisant."}]'::jsonb, 'b', 'Le texte énumère les bienfaits de la lecture puis conclut qu''elle « devrait accompagner chaque jeune » : c''est son idée directrice. (a) dit le contraire du texte (« n''est pas un simple passe-temps » la valorise). (c) n''est qu''un détail imagé (« voyage dans d''autres mondes »). (d) réduit le texte à un seul de ses arguments, alors qu''il en cite plusieurs.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('077020c3-a4f1-5622-8cb0-aec77f757230', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce passage :

« Le vieux pêcheur poussa sa barque dans l''eau noire, saisit ses rames et s''éloigna lentement du rivage. Au loin, une lumière clignotait. Il rama jusqu''à ce que le village disparût derrière lui. »

De quel type de texte s''agit-il ?', '[{"id":"a","text":"Narratif : il raconte une suite d''actions accomplies par un personnage."},{"id":"b","text":"Argumentatif : il défend l''idée que la pêche est un métier difficile."},{"id":"c","text":"Informatif : il explique comment fabriquer une barque."},{"id":"d","text":"Descriptif : il se contente de peindre un paysage immobile."}]'::jsonb, 'a', 'Le texte enchaîne des actions (poussa, saisit, s''éloigna, rama) accomplies par un personnage : c''est un récit, donc un texte narratif. (b) : aucune thèse n''est défendue. (c) : rien n''explique une fabrication. (d) est le piège classique — il y a bien quelques notations de décor, mais ce sont les verbes d''action qui dominent, et le paysage n''est pas immobile puisqu''il y a mouvement et progression.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cda55e3c-d0ae-5f6b-a367-0665f55d4452', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cet extrait :

« Beaucoup pensent que protéger l''environnement coûte trop cher. Pourtant, ne rien faire coûtera bien plus encore : inondations, sécheresses et récoltes perdues pèseront lourd sur les générations futures. »

Quel est le rôle du connecteur « Pourtant » dans ce passage ?', '[{"id":"a","text":"Il ajoute un argument de même sens que le précédent."},{"id":"b","text":"Il oppose à l''idée précédente une objection qui la corrige."},{"id":"c","text":"Il introduit la cause de ce qui vient d''être dit."},{"id":"d","text":"Il donne un exemple illustrant l''idée précédente."}]'::jsonb, 'b', '« Pourtant » est un connecteur d''opposition : il oppose à l''opinion répandue (« protéger coûte trop cher ») l''idée contraire de l''auteur (« ne rien faire coûtera plus »). (a) confondrait avec une addition (de plus). (c) serait le rôle de « car » ou « parce que ». (d) serait celui de « par exemple ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67dff524-0781-58b6-8b30-fd200e7d0b94', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez ce court texte :

« Layla relisait sa copie pour la dixième fois. Ses mains tremblaient, son cœur battait fort, et elle n''osait pas regarder le professeur qui distribuait les résultats. »

Quel sentiment domine chez Layla ?', '[{"id":"a","text":"L''ennui d''une journée trop longue."},{"id":"b","text":"La fierté d''avoir bien travaillé."},{"id":"c","text":"L''anxiété avant l''annonce des résultats."},{"id":"d","text":"La colère contre son professeur."}]'::jsonb, 'c', 'Les indices physiques (mains qui tremblent, cœur qui bat fort, n''ose pas regarder) expriment clairement l''anxiété au moment des résultats. (a) : rien ne marque l''ennui, au contraire tout est tendu. (b) : la fierté supposerait de l''assurance, absente ici. (d) : aucun signe d''hostilité envers le professeur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6037748e-1848-57f4-913d-e039fdf1f606', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cet extrait :

« Quand Karim rentra, il secoua son manteau trempé, ôta ses bottes pleines de boue et alla vite se réchauffer près du poêle. »

Que peut-on déduire (inférer) de ce passage ?', '[{"id":"a","text":"Karim revient de vacances au bord de la mer."},{"id":"b","text":"Il faisait mauvais temps dehors (pluie et froid)."},{"id":"c","text":"Karim n''aime pas marcher."},{"id":"d","text":"Le poêle était en panne."}]'::jsonb, 'b', 'Le manteau « trempé », les bottes « pleines de boue » et le besoin de « se réchauffer » sont des indices qui permettent d''inférer un temps pluvieux et froid, bien que ce ne soit jamais écrit. (a), (c) et (d) ne reposent sur aucun indice du texte : ce sont des suppositions gratuites, pas des inférences.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6164593c-8c3a-5c0b-ac23-a2fc17bfa4b2', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Lisez cette phrase :

« Devant la difficulté, beaucoup baissent les bras, mais les plus tenaces persévèrent jusqu''au bout. »

Dans ce contexte, que signifie le mot « tenaces » ?', '[{"id":"a","text":"Des personnes paresseuses."},{"id":"b","text":"Des personnes qui ne renoncent pas facilement."},{"id":"c","text":"Des personnes très riches."},{"id":"d","text":"Des personnes distraites."}]'::jsonb, 'b', 'Le mot s''oppose, grâce à « mais », à ceux qui « baissent les bras », et il est associé à « persévèrent jusqu''au bout » : « tenaces » désigne donc ceux qui ne renoncent pas. Le contexte (opposition + synonyme proche) guide le sens. (a) est l''inverse, (c) et (d) n''ont aucun lien avec la persévérance évoquée.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da81e1c3-f253-583b-99f4-a6da7ad2cc84', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Vous devez écrire un texte pour défendre l''idée que le travail en équipe est utile. Laquelle de ces phrases est la meilleure phrase de thèse ?', '[{"id":"a","text":"Je vais parler un peu du travail en équipe dans ce texte."},{"id":"b","text":"Le travail en équipe existe depuis très longtemps."},{"id":"c","text":"Le travail en équipe est précieux, car il permet de partager les idées et de réussir ensemble."},{"id":"d","text":"Certaines personnes travaillent seules, d''autres en groupe."}]'::jsonb, 'c', 'Une bonne phrase de thèse affirme clairement une position et annonce ce qu''on va prouver : (c) défend l''utilité du travail en équipe et donne déjà l''orientation (partage, réussite). (a) annonce seulement le sujet sans prendre position. (b) est un constat général qui ne défend rien. (d) présente deux possibilités sans choisir, donc ne défend aucune thèse.', 7)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e019169-bdbe-5788-9b5e-13db4ae7b22f', '357f5e8d-e17d-5fd3-a688-7a04622ccff7', 'Vous écrivez un paragraphe pour montrer que les écrans nuisent au sommeil des jeunes. Quel est l''ordre logique correct des phrases d''un paragraphe argumentatif ?

1) Par exemple, beaucoup d''élèves regardent leur téléphone tard le soir et dorment mal.
2) Les écrans nuisent au sommeil des jeunes.
3) En effet, la lumière des écrans retarde l''endormissement.', '[{"id":"a","text":"1 puis 2 puis 3"},{"id":"b","text":"2 puis 3 puis 1"},{"id":"c","text":"3 puis 1 puis 2"},{"id":"d","text":"1 puis 3 puis 2"}]'::jsonb, 'b', 'Un paragraphe argumentatif suit l''ordre : annoncer l''argument (2), expliquer (3, introduit par « en effet »), illustrer par un exemple (1, introduit par « par exemple »). L''ordre 2-3-1 respecte cette progression. Les autres ordres placent l''exemple ou l''explication avant l''idée qu''ils sont censés soutenir, ce qui brise la logique.', 8)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('09b2c180-a0bd-5852-9b7d-18c86c4d4167', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Exercice 1 — Lire et repérer', 2, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b72b8ada-ccf2-5bf3-9765-42edf26bab42', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce passage :

« Trier ses déchets demande peu d''efforts, mais ce petit geste a de grands effets. Le verre, le plastique et le papier triés sont recyclés au lieu d''être brûlés. Chaque famille qui trie aide ainsi à protéger sa ville. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"Le tri des déchets est compliqué et fatigant."},{"id":"b","text":"Le verre est le déchet le plus facile à recycler."},{"id":"c","text":"Le tri des déchets est un geste simple aux grands effets utiles."},{"id":"d","text":"Brûler les déchets est la meilleure solution."}]'::jsonb, 'c', 'Le texte affirme dès la première phrase que trier « demande peu d''efforts, mais a de grands effets », puis le prouve : c''est l''idée directrice. (a) dit le contraire (« peu d''efforts »). (b) n''est qu''un exemple parmi le verre, le plastique et le papier. (d) est rejeté par le texte, qui oppose le recyclage au fait de brûler.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f1c8665-d1c0-5ed3-8519-bcfa7acab159', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce passage :

« Le matin se levait sur le marché. Les étals débordaient d''oranges luisantes, de menthe fraîche et de piments rouges. Une odeur de pain chaud flottait dans l''air tiède. »

De quel type de texte s''agit-il ?', '[{"id":"a","text":"Descriptif : il peint un lieu à l''aide de notations sensorielles."},{"id":"b","text":"Narratif : il raconte une suite d''aventures au marché."},{"id":"c","text":"Argumentatif : il défend l''idée qu''il faut acheter local."},{"id":"d","text":"Informatif : il explique l''organisation d''un marché."}]'::jsonb, 'a', 'Le texte fait appel à la vue (oranges luisantes, piments rouges), à l''odorat (odeur de pain) et au toucher (air tiède) pour peindre un tableau : c''est descriptif. (b) : il n''y a pas d''actions enchaînées ni de personnage agissant. (c) : aucune opinion n''est défendue. (d) : rien n''explique un fonctionnement.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('848ed66c-2d55-5f47-8712-32262aa46735', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Vous écrivez un texte qui commence par cette amorce :

« Aujourd''hui, beaucoup de jeunes passent des heures sur leur téléphone… »

Quelle phrase de thèse continue le mieux cette introduction sur le thème : faut-il limiter le temps d''écran ?', '[{"id":"a","text":"Le téléphone a été inventé il y a longtemps."},{"id":"b","text":"Je ne sais pas trop quoi penser de ce sujet."},{"id":"c","text":"Il est nécessaire de limiter ce temps d''écran pour protéger leur santé et leurs études."},{"id":"d","text":"Les téléphones existent en plusieurs couleurs."}]'::jsonb, 'c', 'Après l''amorce, la thèse doit annoncer clairement la position défendue : (c) prend position (limiter) et annonce les raisons (santé, études). (a) est un fait sans rapport avec la question posée. (b) ne défend aucune position. (d) est hors sujet.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8aae127-a29c-5649-b8cf-3904e0c38fae', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez cet extrait :

« Internet permet de trouver des informations en quelques secondes. Cependant, toutes ces informations ne sont pas fiables : il faut vérifier ses sources. »

Quel est le rôle du connecteur « Cependant » ?', '[{"id":"a","text":"Il ajoute une idée de même sens à la précédente."},{"id":"b","text":"Il introduit une réserve qui nuance l''idée précédente."},{"id":"c","text":"Il exprime la conséquence de la phrase précédente."},{"id":"d","text":"Il donne la cause de la première phrase."}]'::jsonb, 'b', '« Cependant » est un connecteur d''opposition : après avoir reconnu un avantage d''Internet (rapidité), il introduit une réserve (les informations ne sont pas toutes fiables). (a) confondrait avec une addition. (c) serait « donc » ou « ainsi ». (d) serait « car » ou « parce que ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1c1ffd4-400a-594b-9408-521f081076f6', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez ce court texte :

« Sami regardait la photo de son grand-père. Il sourit doucement, puis ses yeux se remplirent de larmes. Cet homme lui manquait tant. »

Quel sentiment l''auteur cherche-t-il à transmettre ?', '[{"id":"a","text":"La peur face à un danger."},{"id":"b","text":"La colère contre sa famille."},{"id":"c","text":"L''indifférence totale de Sami."},{"id":"d","text":"Une émotion mêlée de tendresse et de tristesse."}]'::jsonb, 'd', 'Le sourire (tendresse), les larmes et la phrase « cet homme lui manquait tant » (tristesse, manque) traduisent une émotion mêlée : c''est le sentiment visé. (a) : aucun danger. (b) : aucune trace de colère. (c) est contredit par les larmes et le manque exprimés.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63482caa-22d4-592a-b78f-a4be32dfe9ed', '09b2c180-a0bd-5852-9b7d-18c86c4d4167', 'Lisez cet extrait :

« Quand la cloche sonna, les élèves rangèrent précipitamment leurs cahiers, attrapèrent leurs sacs et se ruèrent vers la porte. »

Que peut-on inférer de ce passage ?', '[{"id":"a","text":"Les élèves détestent leur professeur."},{"id":"b","text":"La cloche a marqué la fin du cours et la sortie."},{"id":"c","text":"Le cours venait juste de commencer."},{"id":"d","text":"Il n''y avait personne dans la classe."}]'::jsonb, 'b', 'Ranger ses affaires, attraper son sac et se ruer vers la porte après la cloche permet d''inférer que le cours est terminé, même si ce n''est pas écrit. (a) est une supposition sans indice. (c) contredit le rangement des affaires. (d) est absurde : on parle bien d''élèves présents.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f7331495-eabf-5d6b-b33b-4d012d11c3c3', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', 'Exercice 2 — Vers la production écrite', 2, 50, 10, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0714313c-d0bd-5997-af4d-ff5c4c6ef2fa', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez ce passage :

« Le travail manuel est trop souvent méprisé. Pourtant, sans le menuisier, le plombier ou l''électricien, nos maisons ne tiendraient pas debout. Ces métiers méritent autant de respect que les autres. »

Quelle est la thèse défendue par l''auteur ?', '[{"id":"a","text":"Les métiers manuels sont inutiles aujourd''hui."},{"id":"b","text":"Les métiers manuels méritent le respect au même titre que les autres."},{"id":"c","text":"Le menuisier gagne plus que l''électricien."},{"id":"d","text":"Il faut interdire les études longues."}]'::jsonb, 'b', 'La thèse est annoncée et confirmée en dernière phrase : ces métiers « méritent autant de respect que les autres ». (a) est le préjugé que l''auteur combat (« trop souvent méprisé »). (c) n''est pas évoqué. (d) n''a aucun lien avec le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a849745d-22e2-5d25-a391-5993cf4a12b9', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez cette phrase :

« Grâce à la solidarité des voisins, la vieille dame put réparer son toit avant l''hiver. »

Dans ce contexte, que signifie le mot « solidarité » ?', '[{"id":"a","text":"Le fait que les voisins s''entraident et se soutiennent."},{"id":"b","text":"Le fait que les voisins se disputent souvent."},{"id":"c","text":"Le prix très élevé des réparations."},{"id":"d","text":"La solitude de la vieille dame."}]'::jsonb, 'a', '« Grâce à » indique une aide positive, et le résultat (le toit réparé) montre que les voisins ont soutenu la dame : « solidarité » désigne l''entraide. (b) est le contraire d''une entraide. (c) parle d''argent, absent ici. (d) contredit l''idée même de voisins qui aident.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae6d3414-72ac-5ec1-8a0d-2a2bafdfdbfb', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Vous voulez ajouter un deuxième argument dans votre texte. Vous venez d''écrire : « La lecture enrichit le vocabulaire. » Quel connecteur convient le mieux pour introduire un nouvel argument allant dans le même sens ?', '[{"id":"a","text":"Cependant, la lecture développe aussi l''imagination."},{"id":"b","text":"De plus, la lecture développe l''imagination."},{"id":"c","text":"Car la lecture développe l''imagination."},{"id":"d","text":"Donc la lecture développe l''imagination."}]'::jsonb, 'b', 'Pour ajouter un argument de même sens, on emploie un connecteur d''addition : « De plus ». (a) « Cependant » marquerait une opposition, ce qui serait faux ici. (c) « Car » introduirait une cause, pas un nouvel argument. (d) « Donc » exprimerait une conséquence, ce qui ne convient pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a381c43d-3ee3-5596-8c42-6530377c5810', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Sujet de rédaction : « Faut-il aider les autres ? » Laquelle de ces phrases est la meilleure phrase d''amorce pour commencer l''introduction ?', '[{"id":"a","text":"En conclusion, aider les autres est toujours bon."},{"id":"b","text":"Mon plat préféré est le couscous."},{"id":"c","text":"Dans la vie de tous les jours, nous croisons souvent des personnes qui ont besoin d''un coup de main."},{"id":"d","text":"Voici mon premier argument sur l''entraide."}]'::jsonb, 'c', 'Une bonne amorce introduit le sujet par un constat général, sans encore le traiter : (c) ouvre sur l''entraide quotidienne, en lien direct avec le sujet. (a) est une conclusion, pas une amorce. (b) est hors sujet. (d) saute directement à l''argument sans introduire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99c7d327-4658-5405-81d2-3c44b00ce441', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Lisez ce passage :

« On dit parfois que la télévision rend les enfants paresseux. Certes, trop d''écran peut nuire. Mais bien choisis, certains documentaires éveillent leur curiosité et les instruisent. »

Quelle phrase joue le rôle du contre-argument que l''auteur reconnaît avant de le nuancer ?', '[{"id":"a","text":"« certains documentaires éveillent leur curiosité »"},{"id":"b","text":"« Certes, trop d''écran peut nuire. »"},{"id":"c","text":"« et les instruisent »"},{"id":"d","text":"« bien choisis »"}]'::jsonb, 'b', 'Le contre-argument est l''objection adverse que l''auteur admet d''abord (« Certes… ») avant de la dépasser par « Mais ». Ici, « Certes, trop d''écran peut nuire » est cette concession. (a) et (c) sont au contraire les arguments de l''auteur. (d) n''est qu''une condition (« bien choisis ») à l''intérieur de son argument.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48881931-78d7-5e4a-a742-a3d4d7e8ef95', 'f7331495-eabf-5d6b-b33b-4d012d11c3c3', 'Vous rédigez sur le thème « le sport est bon pour la santé ». Laquelle de ces suites de deux phrases est COHÉRENTE ?', '[{"id":"a","text":"Le sport renforce le cœur. Par exemple, marcher chaque jour fait du bien au cœur."},{"id":"b","text":"Le sport renforce le cœur. Pourtant, marcher chaque jour fait du bien au cœur."},{"id":"c","text":"Le sport renforce le cœur. Le couscous est un plat tunisien."},{"id":"d","text":"Le sport renforce le cœur. Donc il est dangereux pour la santé."}]'::jsonb, 'a', 'En (a), l''exemple (« marcher chaque jour ») illustre logiquement l''idée annoncée, et le connecteur « par exemple » est juste : c''est cohérent. (b) emploie « Pourtant » alors que les deux phrases vont dans le même sens : connecteur mal choisi. (c) introduit une idée hors sujet. (d) se contredit (« bon pour la santé » puis « dangereux »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', '⚔️ Boss — Lecture fine & argumentation', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc114016-dacc-5dd5-87e4-6b7b5f2af178', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez ce passage :

« Certains affirment que la technologie isole les gens. C''est oublier qu''un simple appel vidéo réunit aujourd''hui des familles séparées par des milliers de kilomètres. La technologie ne sépare pas : tout dépend de l''usage qu''on en fait. »

Quelle est la thèse exacte de l''auteur ?', '[{"id":"a","text":"La technologie isole toujours les gens."},{"id":"b","text":"La technologie relie ou sépare selon l''usage qu''on en fait."},{"id":"c","text":"Les appels vidéo sont gratuits partout dans le monde."},{"id":"d","text":"Il faut interdire la technologie dans les familles."}]'::jsonb, 'b', 'La dernière phrase nuance : « tout dépend de l''usage qu''on en fait ». L''auteur ne dit ni que la technologie isole (a, l''opinion qu''il réfute), ni qu''elle est toujours bonne, mais que l''effet dépend de l''usage. (c) déforme un détail (l''appel vidéo n''est jamais dit gratuit). (d) propose une interdiction absente du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab06e97b-51fd-59b0-a4d9-cde2df12c486', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez cet extrait :

« Il prétendait n''avoir jamais eu peur de rien. Pourtant, ce soir-là, sa voix tremblait et il vérifia trois fois que la porte était bien fermée. »

Que suggère implicitement l''auteur à propos de ce personnage ?', '[{"id":"a","text":"Le personnage est, en réalité, effrayé malgré ce qu''il dit."},{"id":"b","text":"Le personnage est parfaitement courageux."},{"id":"c","text":"Le personnage a oublié de fermer sa porte."},{"id":"d","text":"Le personnage déteste les portes."}]'::jsonb, 'a', 'Le « Pourtant » oppose les paroles du personnage (« jamais eu peur ») à ses gestes (voix tremblante, vérification répétée) : l''auteur laisse ainsi entendre qu''il a peur, contrairement à ce qu''il prétend. (b) prend ses paroles pour argent comptant et ignore les indices. (c) contredit « vérifia trois fois que la porte était bien fermée ». (d) est absurde.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c4105f3-590a-55c7-80ce-95b8f1d62296', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez ce passage :

« La pluie n''avait pas cessé depuis trois jours. Les rues étaient désertes, les rivières montaient, et dans chaque maison on guettait le ciel avec inquiétude. »

Quelle est la double fonction dominante de ce passage ?', '[{"id":"a","text":"Argumenter en faveur de la construction de barrages."},{"id":"b","text":"Décrire une atmosphère tout en suggérant une menace d''inondation."},{"id":"c","text":"Expliquer scientifiquement le cycle de l''eau."},{"id":"d","text":"Raconter le voyage d''un personnage principal."}]'::jsonb, 'b', 'Le passage est descriptif (rues désertes, rivières qui montent, ciel guetté) mais ces notations créent aussi une tension : on infère une menace d''inondation. (a) ne défend aucune thèse. (c) n''explique aucun phénomène scientifique. (d) : il n''y a pas de personnage qui agit ni de voyage, seulement un décor inquiétant.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d77f78a-4ba0-56fd-9efc-bdc72e22fd0f', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Vous rédigez un paragraphe argumentatif. Vous avez ces trois phrases :

1) Ainsi, lire un peu chaque jour aide vraiment à mieux écrire.
2) En effet, en lisant on rencontre sans cesse de nouvelles tournures de phrases.
3) La lecture régulière améliore l''expression écrite.

Quel est le bon ordre logique du paragraphe ?', '[{"id":"a","text":"3 puis 2 puis 1"},{"id":"b","text":"1 puis 2 puis 3"},{"id":"c","text":"2 puis 3 puis 1"},{"id":"d","text":"3 puis 1 puis 2"}]'::jsonb, 'a', 'Le paragraphe doit annoncer l''argument (3), l''expliquer avec « En effet » (2), puis conclure avec « Ainsi » (1) : l''ordre 3-2-1 respecte « annoncer → expliquer → conclure ». Les autres ordres placent la conclusion (« Ainsi ») ou l''explication (« En effet ») avant l''idée annoncée, ce qui rend le raisonnement illogique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db658899-ea60-5a21-978d-2adcde0df690', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Vous défendez l''idée que protéger l''environnement est l''affaire de tous. Vous voulez réfuter le contre-argument « c''est à l''État de tout faire ». Quelle phrase réfute correctement ce contre-argument ?', '[{"id":"a","text":"Certes, l''État a un rôle ; mais chaque citoyen peut agir par de petits gestes quotidiens."},{"id":"b","text":"L''État doit s''occuper de tout, c''est évident."},{"id":"c","text":"Par exemple, l''État construit des routes et des écoles."},{"id":"d","text":"De plus, l''État est responsable de l''environnement."}]'::jsonb, 'a', 'Réfuter un contre-argument, c''est le reconnaître (« Certes… ») puis le dépasser (« mais… »). (a) admet le rôle de l''État puis montre que le citoyen agit aussi : c''est une réfutation. (b) ne fait que répéter le contre-argument. (c) l''illustre au lieu de le réfuter. (d) le renforce encore avec « De plus ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c73cdfba-e320-5ce3-a0ba-eec42fb6c3ac', '3c08767d-2ee3-50e7-b7bc-f76bfd5c7125', 'Lisez cette phrase :

« Loin de freiner les élèves, ces difficultés les ont aiguillonnés : ils ont travaillé plus dur que jamais. »

Dans ce contexte, que signifie le verbe « aiguillonner » ?', '[{"id":"a","text":"Décourager, faire abandonner."},{"id":"b","text":"Stimuler, pousser à agir davantage."},{"id":"c","text":"Endormir, rendre paresseux."},{"id":"d","text":"Tromper, induire en erreur."}]'::jsonb, 'b', '« Loin de freiner » annonce un sens opposé à « freiner », et la suite (« ils ont travaillé plus dur ») confirme : aiguillonner = stimuler, pousser à agir. (a) et (c) vont dans le sens du frein, contredit par la phrase. (d) (« tromper ») n''a aucun rapport avec l''effort accru décrit.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', '👑 Défi élite — Maîtrise compréhension & rédaction', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b85ff5e5-4e6e-50d5-ac36-f62c86ac135f', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« On vante sans cesse les progrès de la médecine moderne. Soit. Mais à quoi servent les hôpitaux les plus modernes si les plus pauvres n''y ont jamais accès ? Le vrai progrès n''est pas seulement technique : il est aussi celui de la justice. »

Quelle est l''idée directrice, formulée avec précision ?', '[{"id":"a","text":"La médecine moderne n''a fait aucun progrès."},{"id":"b","text":"Le progrès médical n''a de valeur que s''il est accessible à tous, donc juste."},{"id":"c","text":"Les hôpitaux modernes sont trop nombreux."},{"id":"d","text":"Les pauvres ne tombent jamais malades."}]'::jsonb, 'b', 'L''auteur concède les progrès techniques (« Soit »), puis affirme par une question rhétorique et la dernière phrase que le vrai progrès suppose la justice et l''accès de tous : c''est l''idée directrice. (a) déforme : l''auteur reconnaît les progrès. (c) n''est pas dit. (d) contredit l''idée même d''accès aux soins.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bcfa2d5-699a-5915-9ed7-a5fdf50ee301', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez cet extrait :

« — Bravo, vraiment, lança-t-il en regardant le vase brisé. Tu as encore fait un travail magnifique. »

Quel est le ton employé par le personnage ?', '[{"id":"a","text":"Un ton sincèrement admiratif."},{"id":"b","text":"Un ton ironique : il dit le contraire de ce qu''il pense."},{"id":"c","text":"Un ton neutre et informatif."},{"id":"d","text":"Un ton triste et résigné."}]'::jsonb, 'b', 'Le décalage entre les paroles élogieuses (« Bravo », « magnifique ») et la situation réelle (un vase brisé) signale l''ironie : le personnage dit le contraire de ce qu''il pense pour reprocher la maladresse. (a) prend les mots au premier degré, ignorant le contexte. (c) : l''exclamation et l''éloge ne sont pas neutres. (d) : aucune tristesse, plutôt un reproche moqueur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7718a410-1ad0-557d-b059-869541cb0241', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« Elle rangea les jouets un à un, plia la petite couverture et resta longtemps assise dans la chambre devenue trop silencieuse. »

Que peut-on inférer du sentiment de ce personnage, sans qu''il soit nommé ?', '[{"id":"a","text":"Une joie débordante et bruyante."},{"id":"b","text":"Une indifférence totale envers l''enfant."},{"id":"c","text":"Une mélancolie liée à l''absence de l''enfant."},{"id":"d","text":"Une colère contre le désordre de la chambre."}]'::jsonb, 'c', 'La chambre « devenue trop silencieuse », les gestes lents et la longue immobilité laissent inférer une mélancolie liée au vide laissé par l''enfant, sans que le mot soit écrit. (a) est contredit par le silence et l''immobilité. (b) est démentie par le soin des gestes. (d) : elle range avec douceur, rien n''évoque la colère.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('996c1e06-7a10-5972-bd28-3db55e8234bd', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Sujet : « Le bénévolat est-il utile aux jeunes ? » Vous voulez une introduction où l''amorce et la thèse s''enchaînent parfaitement. Quel couple amorce + thèse est le mieux construit ?', '[{"id":"a","text":"Amorce : « De nos jours, beaucoup de jeunes cherchent à se rendre utiles autour d''eux. » Thèse : « Le bénévolat leur apporte beaucoup, car il développe leur sens des responsabilités et leur confiance. »"},{"id":"b","text":"Amorce : « Le bénévolat développe la confiance. » Thèse : « De nos jours, les jeunes cherchent à se rendre utiles. »"},{"id":"c","text":"Amorce : « En conclusion, le bénévolat est très utile. » Thèse : « Voici pourquoi je le pense. »"},{"id":"d","text":"Amorce : « J''aime beaucoup le sport. » Thèse : « Le bénévolat est utile. »"}]'::jsonb, 'a', 'En (a), l''amorce introduit le thème par un constat général lié au sujet, puis la thèse prend position en annonçant les raisons : l''enchaînement est correct. (b) inverse les rôles (l''amorce affirme déjà un argument, la thèse n''est qu''un constat). (c) commence par une conclusion, ce qui n''est pas une amorce. (d) ouvre sur un sujet sans rapport (le sport).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b0196a9-14d1-53f3-8931-9f5b3bed0f57', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Lisez ce passage :

« Bien sûr, voyager coûte cher et fatigue. Toutefois, découvrir d''autres cultures ouvre l''esprit comme aucun livre ne le pourrait. »

Analysez la structure argumentative : quel est le statut de chaque partie ?', '[{"id":"a","text":"Première phrase = thèse de l''auteur ; seconde = exemple."},{"id":"b","text":"Première phrase = contre-argument concédé ; seconde = argument principal de l''auteur."},{"id":"c","text":"Les deux phrases défendent exactement la même idée."},{"id":"d","text":"Première phrase = conclusion ; seconde = amorce."}]'::jsonb, 'b', '« Bien sûr… » concède une objection (voyager coûte cher et fatigue) ; puis « Toutefois » introduit l''argument que l''auteur défend réellement (le voyage ouvre l''esprit). C''est le schéma concession + réfutation. (a) confond la concession avec la thèse. (c) ignore l''opposition marquée par « Toutefois ». (d) inverse l''ordre logique d''une argumentation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('390010fb-85c6-5acf-973f-8c390cce218d', 'a89ce8f2-df45-5a06-bcbb-8c3b9182cbf8', 'Vous écrivez sur « l''importance de l''eau ». Laquelle de ces suites de phrases est INCOHÉRENTE (à éviter dans une production écrite) ?', '[{"id":"a","text":"L''eau est indispensable à la vie. En effet, aucun être vivant ne peut survivre longtemps sans elle."},{"id":"b","text":"L''eau est indispensable à la vie. C''est pourquoi il faut éviter de la gaspiller."},{"id":"c","text":"L''eau est indispensable à la vie. Pourtant, sans elle, aucun être vivant ne survivrait."},{"id":"d","text":"L''eau est indispensable à la vie. Par exemple, sans eau, les plantes se dessèchent."}]'::jsonb, 'c', 'En (c), « Pourtant » annonce une opposition, mais la suite confirme au contraire la première idée : le connecteur contredit le sens, ce qui rend la phrase incohérente. (a) (« En effet » = explication), (b) (« C''est pourquoi » = conséquence) et (d) (« Par exemple » = illustration) emploient tous un connecteur en accord avec la logique des idées.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e2fae353-834e-5ce1-8da2-b79f02a9dfe0', '7dfc8206-be90-514b-9490-54149fa1f43d', 'french', '🛡️ Entraînement examen : compréhension de texte & production écrite', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('533df0ee-78f7-57bc-8a57-dd9eab28fed3', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Lisez ce texte :

« Karim avait toujours détesté la mer. Pourtant, ce matin-là, debout sur la plage, il sentit son cœur s''apaiser au rythme des vagues. Pour la première fois, l''eau ne lui faisait plus peur. »

Quelle est l''idée essentielle du texte ?', '[{"id":"a","text":"Karim a toujours adoré la mer."},{"id":"b","text":"Karim, qui craignait la mer, commence à l''apprécier."},{"id":"c","text":"Karim se noie dans les vagues."},{"id":"d","text":"Karim part en voyage très loin."}]'::jsonb, 'b', 'Le « Pourtant » oppose son ancienne aversion (« avait toujours détesté ») à son apaisement présent (« ne lui faisait plus peur ») : Karim, qui craignait la mer, commence à l''apprécier. L''option a contredit « détesté », c et d ajoutent des faits absents du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3546773d-9c4c-56d2-8943-39401375c3fb', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Lisez ce texte :

« Les abeilles ne sont pas de simples insectes. En butinant les fleurs, elles transportent le pollen et permettent ainsi aux plantes de se reproduire. Sans elles, de nombreuses cultures disparaîtraient. »

À quel type de texte appartient ce passage ?', '[{"id":"a","text":"Texte narratif"},{"id":"b","text":"Texte explicatif"},{"id":"c","text":"Texte injonctif"},{"id":"d","text":"Texte poétique"}]'::jsonb, 'b', 'Le passage explique objectivement le rôle des abeilles (pollinisation, reproduction des plantes) pour informer le lecteur : c''est un texte explicatif. Il ne raconte pas d''histoire (a), ne donne pas d''ordres (c) et n''a pas de visée poétique (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7870668f-8f7e-5437-9372-0c3b6dce796b', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Lisez cette phrase :

« Le voyageur, exténué, posa enfin son sac : il n''en pouvait plus. »

Dans ce contexte, que signifie le mot « exténué » ?', '[{"id":"a","text":"Très en colère"},{"id":"b","text":"Extrêmement fatigué, épuisé"},{"id":"c","text":"Très heureux"},{"id":"d","text":"Surpris"}]'::jsonb, 'b', 'La suite « il n''en pouvait plus » et le geste de poser son sac confirment qu''« exténué » signifie épuisé, extrêmement fatigué. La colère (a), la joie (c) et la surprise (d) ne correspondent pas à l''idée d''épuisement décrite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d312960-34cc-5bc3-9b68-afcd570ad6e3', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Lisez cette phrase tirée d''un texte :

« Malgré ses nombreux échecs, elle refusait d''abandonner. »

Que suggère le connecteur « Malgré » sur le caractère du personnage ?', '[{"id":"a","text":"Le personnage est paresseux et renonce vite."},{"id":"b","text":"Le personnage est persévérant et déterminé."},{"id":"c","text":"Le personnage n''a jamais connu d''échec."},{"id":"d","text":"Le personnage est indifférent à tout."}]'::jsonb, 'b', '« Malgré ses nombreux échecs » introduit un obstacle qui n''empêche pas l''action « elle refusait d''abandonner » : on infère un personnage persévérant. L''option a est contredite par « refusait d''abandonner », c par « nombreux échecs », d ne correspond à aucun indice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6f3d8bc-773e-5241-9dfc-c92258736bc4', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Vous rédigez l''introduction d''un texte argumentatif sur l''importance du sport. Quelle phrase constitue la meilleure phrase de thèse ?', '[{"id":"a","text":"Le sport, c''est quand on bouge."},{"id":"b","text":"Selon moi, pratiquer un sport régulièrement est essentiel pour la santé et le bien-être."},{"id":"c","text":"Est-ce que le sport est utile ?"},{"id":"d","text":"Un jour, je suis allé courir au parc."}]'::jsonb, 'b', 'Une phrase de thèse annonce clairement l''opinion que l''on va défendre : « pratiquer un sport… est essentiel pour la santé et le bien-être ». L''option a n''est qu''une définition vague, c une question (non une prise de position), d le début d''un récit.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee955f83-405f-51c7-8fca-9267645d771e', 'e2fae353-834e-5ce1-8da2-b79f02a9dfe0', 'Vous voulez enchaîner deux arguments dans un paragraphe. Vous avez ces phrases :

1) De plus, le sport apprend à respecter des règles et les autres joueurs.
2) Tout d''abord, le sport renforce le corps et protège de nombreuses maladies.

Quel est le bon ordre logique ?', '[{"id":"a","text":"1 puis 2"},{"id":"b","text":"2 puis 1"},{"id":"c","text":"Les deux ordres se valent."},{"id":"d","text":"Aucun des deux n''est correct."}]'::jsonb, 'b', 'Le connecteur « Tout d''abord » (2) ouvre la série d''arguments, et « De plus » (1) ajoute un argument supplémentaire : l''ordre logique est 2 puis 1. Placer « De plus » en premier (a) serait incohérent, car il suppose qu''un argument précède déjà ; les ordres ne se valent donc pas (c, d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Quiz — Maîtriser le sujet type d''examen', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8454304f-896c-57e2-9d6c-9404795453d2', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Dans l''épreuve de français de fin d''études de base, sur quoi reposent les questions de compréhension, de langue et de production ?', '[{"id":"a","text":"Sur trois textes différents, un par partie."},{"id":"b","text":"Sur un même texte support, lu au début de l''épreuve."},{"id":"c","text":"Sur les souvenirs personnels de l''élève."},{"id":"d","text":"Sur une liste de règles de grammaire sans texte."}]'::jsonb, 'b', 'L''épreuve s''organise autour d''UN texte support : compréhension, langue et production écrite portent sur ce texte. (a) est faux : il n''y a qu''un texte. (c) : on doit s''appuyer sur le texte, pas sur des souvenirs. (d) : la langue est testée à partir de phrases du texte, pas hors contexte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e701876-a9d1-514d-848b-7567488fc2d4', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Combien de fois est-il conseillé de lire le texte avant de répondre aux questions ?', '[{"id":"a","text":"Une seule fois, en diagonale."},{"id":"b","text":"Deux fois : une lecture globale, puis une lecture crayon en main."},{"id":"c","text":"Jamais : il faut lire directement les questions."},{"id":"d","text":"Cinq fois au minimum, mot à mot."}]'::jsonb, 'b', 'On lit deux fois : d''abord pour saisir le sens global, puis crayon en main pour repérer type de texte, idée directrice, connecteurs et mots difficiles. (a) : la diagonale fait manquer les indices. (c) : sans lire le texte, on répond au hasard. (d) : cinq lectures complètes feraient perdre un temps précieux.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d0f128d-cdce-5d9d-997c-047d2da2e2bc', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Pourquoi est-il important de garder environ un tiers du temps pour la production écrite ?', '[{"id":"a","text":"Parce que la production écrite ne compte presque rien dans la note."},{"id":"b","text":"Parce qu''il faut planifier, rédiger ET relire, ce qui demande du temps."},{"id":"c","text":"Parce qu''il faut absolument finir avant tout le monde."},{"id":"d","text":"Parce que la compréhension ne demande aucune réflexion."}]'::jsonb, 'b', 'La production écrite pèse lourd et exige un plan, une rédaction soignée et une relecture (orthographe, conjugaison, cohérence) : il faut donc lui réserver assez de temps. (a) est faux : elle représente une grande part de la note. (c) : la vitesse n''est pas un but en soi. (d) : la compréhension demande au contraire de la réflexion.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6e0e1ee-d878-5008-8460-52fdbcdb11a2', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Que signifie « inférer » dans une question de compréhension ?', '[{"id":"a","text":"Recopier mot pour mot une phrase du texte."},{"id":"b","text":"Inventer une information qui n''a aucun lien avec le texte."},{"id":"c","text":"Déduire une information non écrite à partir d''indices du texte."},{"id":"d","text":"Traduire le texte dans une autre langue."}]'::jsonb, 'c', 'Inférer, c''est déduire ce qui n''est pas écrit noir sur blanc, mais que les indices du texte permettent de comprendre. (a) décrit le simple relevé explicite, pas l''inférence. (b) : inférer n''est jamais inventer librement. (d) n''a aucun rapport avec la compréhension.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d520596-be86-5bf9-9986-236f642e3ee5', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Quel élément introduit le complément d''agent dans une phrase à la voix passive ?', '[{"id":"a","text":"La préposition « par » (ou parfois « de »)."},{"id":"b","text":"Le pronom relatif « qui »."},{"id":"c","text":"La conjonction « parce que »."},{"id":"d","text":"L''article défini « le »."}]'::jsonb, 'a', 'À la voix passive, le complément d''agent (celui qui fait l''action) est introduit par « par » (« mangé par le chat ») ou parfois « de » (« aimé de tous »). (b) introduit une subordonnée relative. (c) introduit une cause. (d) est un simple article, sans rôle d''agent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3861e039-b9dc-5a7f-a1f7-4ade27282a2c', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Dans un récit, quelle opposition de temps est la plus fréquente entre le décor (l''arrière-plan) et les actions principales (le premier plan) ?', '[{"id":"a","text":"Présent pour le décor, futur pour les actions."},{"id":"b","text":"Imparfait pour le décor, passé simple pour les actions."},{"id":"c","text":"Conditionnel pour le décor, impératif pour les actions."},{"id":"d","text":"Futur pour le décor, présent pour les actions."}]'::jsonb, 'b', 'Dans le récit au passé, l''imparfait pose le décor et la durée (« il faisait nuit »), tandis que le passé simple marque les actions soudaines de premier plan (« il entra »). (a), (c) et (d) associent des temps qui ne correspondent pas à ce rôle dans le récit classique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11b23003-7011-5d40-98b3-7061425c7315', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Quel est le rôle de la phrase d''amorce au début d''une production écrite ?', '[{"id":"a","text":"Donner directement la conclusion du devoir."},{"id":"b","text":"Introduire le sujet sans le traiter, pour amener l''idée."},{"id":"c","text":"Énumérer tous les arguments du développement."},{"id":"d","text":"Corriger les fautes d''orthographe du texte."}]'::jsonb, 'b', 'L''amorce est la première phrase qui présente le sujet (un constat, une question, un fait frappant) sans le traiter encore : elle prépare la thèse. (a) : la conclusion vient à la fin. (c) : les arguments se développent ensuite, paragraphe par paragraphe. (d) n''est pas le rôle d''une amorce.', 7)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69d3b8fa-3457-5297-82c9-f50c644c0a4e', 'f5fc9505-1c9b-5f48-9b2a-e3428ee6be1f', 'Lisez cette phrase au discours direct :

« Le professeur dit : “Vous avez bien travaillé.” »

Quelle est la transposition correcte au discours indirect ?', '[{"id":"a","text":"Le professeur dit qu''ils avaient bien travaillé."},{"id":"b","text":"Le professeur dit : ils ont bien travaillé."},{"id":"c","text":"Le professeur dit qu''avez-vous bien travaillé ?"},{"id":"d","text":"Le professeur dit vous avez bien travaillé."}]'::jsonb, 'a', 'Au discours indirect, on supprime les guillemets, on introduit par « que », et on adapte le pronom (« vous » → « ils ») et le temps (« avez travaillé » → « avaient travaillé ») : « qu''ils avaient bien travaillé ». (b) garde une ponctuation de discours direct. (c) introduit une question inexistante. (d) oublie le subordonnant « que » et l''accord des pronoms.', 8)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cc6100ec-d480-5f4c-a6b1-931442e93632', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', 'Sujet 1 — Texte narratif : le retour au village', 2, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d561c284-fe77-5304-8add-50b795fa84bc', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quel est le type dominant de ce texte ?', '[{"id":"a","text":"Argumentatif : il défend une opinion sur la vie au village."},{"id":"b","text":"Narratif : il raconte une suite d''actions situées dans le temps."},{"id":"c","text":"Informatif : il explique le fonctionnement d''un autocar."},{"id":"d","text":"Injonctif : il donne des ordres au lecteur."}]'::jsonb, 'b', 'Le texte raconte des actions qui se suivent (l''autocar s''arrêta, Karim descendit, marcha…) avec un personnage et un cadre : c''est narratif. (a) : aucune thèse n''est défendue. (c) : rien n''explique le fonctionnement d''un autocar. (d) : il n''y a aucun ordre adressé au lecteur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e00b002a-d567-56b1-b788-173342c1ee53', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quel sentiment éprouve Karim en arrivant au village ?', '[{"id":"a","text":"De l''indifférence : le village ne lui inspire rien."},{"id":"b","text":"De la peur d''être perdu dans un lieu inconnu."},{"id":"c","text":"Une émotion forte, faite d''attachement et d''impatience."},{"id":"d","text":"De la colère contre sa grand-mère."}]'::jsonb, 'c', '« Le cœur battant » et le fait qu''il remarque avec tendresse que « rien n''avait changé » traduisent un attachement ému et l''impatience de retrouver les lieux. (a) est contredit par l''émotion décrite. (b) : le village ne lui est pas inconnu, « rien n''avait changé ». (d) : aucune trace de colère, il marche vers sa grand-mère avec émotion.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('004290f5-18df-5e0f-9504-ef5bc050a921', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Dans la phrase « le vieux figuier veillait toujours sur la place », quelle est la valeur de l''imparfait ?', '[{"id":"a","text":"Il décrit l''arrière-plan, un état qui dure dans le passé."},{"id":"b","text":"Il exprime une action brève et soudaine de premier plan."},{"id":"c","text":"Il indique une action qui se passera dans le futur."},{"id":"d","text":"Il donne un ordre au lecteur."}]'::jsonb, 'a', '« Veillait » est à l''imparfait : il peint le décor et un état qui dure (le figuier est toujours là), c''est l''arrière-plan du récit. (b) : l''action brève de premier plan serait au passé simple, comme « descendit ». (c) : l''imparfait est un temps du passé, pas du futur. (d) : ce n''est pas un impératif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bb3b44d-55e9-58ca-885b-33843190e4c5', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Dans « le cœur battant », quel est le sens de l''expression ?', '[{"id":"a","text":"Karim est malade du cœur."},{"id":"b","text":"Karim ressent une forte émotion (joie, impatience)."},{"id":"c","text":"Karim entend des tambours dans le village."},{"id":"d","text":"Karim a très froid au village."}]'::jsonb, 'b', '« Le cœur battant » est une expression imagée qui désigne l''émotion : le cœur s''accélère sous le coup de l''impatience ou de la joie. Le contexte (retour attendu, « rien n''avait changé ») le confirme. (a) prend l''expression au sens propre médical, à tort. (c) et (d) n''ont aucun rapport avec le sens de l''expression.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91ed9dac-19cb-5076-a268-295420d3a3e8', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Vous devez raconter la suite de cette scène (Karim retrouve sa grand-mère). Quelle phrase d''amorce convient le mieux pour commencer votre paragraphe de récit ?', '[{"id":"a","text":"En conclusion, Karim était très heureux de ce voyage."},{"id":"b","text":"Devant la porte bleue, Karim s''arrêta un instant, le souffle court."},{"id":"c","text":"Le figuier est un arbre qui pousse en région méditerranéenne."},{"id":"d","text":"Je pense qu''il faut visiter sa famille plus souvent."}]'::jsonb, 'b', 'Pour continuer un récit, l''amorce doit relancer l''action dans le même registre narratif : (b) plante le décor et le geste du personnage, et amène la rencontre. (a) est une formule de conclusion, pas un début. (c) est une information encyclopédique hors récit. (d) bascule dans l''argumentatif (« je pense que »), hors sujet pour un récit.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('feb5008a-c62f-50e4-96c1-ef21827d5d14', 'cc6100ec-d480-5f4c-a6b1-931442e93632', 'Lisez le texte :

« Quand l''autocar s''arrêta enfin à l''entrée du village, Karim descendit le premier. La poussière retombait lentement sur la route. Rien n''avait changé : le vieux figuier veillait toujours sur la place, et l''odeur du pain chaud sortait encore de la petite boulangerie. Le cœur battant, le garçon serra son sac contre lui et marcha vers la maison de sa grand-mère. »

Quelle est la transformation correcte de la phrase « Karim descendit le premier » à la voix passive ?', '[{"id":"a","text":"Le premier fut descendu par Karim."},{"id":"b","text":"Cette phrase ne peut pas se mettre à la voix passive."},{"id":"c","text":"Karim était descendu le premier."},{"id":"d","text":"Le premier descendait Karim."}]'::jsonb, 'b', '« Descendre » est ici intransitif : « le premier » n''est pas un complément d''objet direct mais un attribut, donc la phrase n''a pas de voix passive. (a) et (d) inventent un COD qui n''existe pas et produisent un non-sens. (c) n''est pas une voix passive mais un simple changement de temps (plus-que-parfait).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1d1ca79e-04f6-5f75-84b4-ab412ba348aa', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', '⚔️ Sujet 2 (Boss) — Texte informatif : l''eau, une ressource précieuse', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68e457c7-1d2e-5612-b531-d79d2acf9d4d', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Quelle est l''idée directrice de ce texte ?', '[{"id":"a","text":"L''eau douce est très abondante sur la planète."},{"id":"b","text":"Le gaspillage de l''eau ne peut pas être évité."},{"id":"c","text":"L''eau douce est rare et gaspillée, mais des gestes simples permettent de l''économiser."},{"id":"d","text":"Il faut interdire totalement l''usage de l''eau."}]'::jsonb, 'c', 'Le texte enchaîne trois idées : l''eau douce est rare (« une très petite partie »), elle est gaspillée, et des gestes simples permettent de l''économiser : c''est l''idée directrice. (a) contredit « une très petite partie ». (b) est contredit par « des gestes simples suffisent ». (d) exagère : le texte parle d''économie, pas d''interdiction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f36ef462-d7e1-59ac-a84b-4393c5c8ccda', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Quel est le rôle du connecteur « Pourtant » au début de la deuxième phrase ?', '[{"id":"a","text":"Il ajoute une idée de même sens que la précédente."},{"id":"b","text":"Il marque une opposition entre la rareté de l''eau et son gaspillage."},{"id":"c","text":"Il exprime la cause de la première phrase."},{"id":"d","text":"Il introduit un exemple chiffré."}]'::jsonb, 'b', '« Pourtant » oppose deux idées contradictoires : l''eau est rare, et POURTANT on la gaspille. (a) confondrait avec une addition (« de plus »). (c) serait « car » ou « parce que ». (d) : l''exemple chiffré (« des milliers de litres ») vient plus loin et n''est pas introduit par « pourtant ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62e98c7b-be98-5da5-8c08-91d360b2614e', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans ce contexte, quel est le sens du mot « préservés » ?', '[{"id":"a","text":"Gaspillés, perdus inutilement."},{"id":"b","text":"Protégés, économisés, donc non perdus."},{"id":"c","text":"Vendus à un prix élevé."},{"id":"d","text":"Salis, rendus impropres à la consommation."}]'::jsonb, 'b', '« Préservés » s''oppose ici à « gaspillés » et « perdus » du début : ces litres seraient sauvegardés, économisés. Le contexte (« économiser cette ressource ») le confirme. (a) dit l''inverse exact. (c) introduit une idée de vente absente. (d) confond avec « pollués », ce que le texte ne dit pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('820ea5b8-ff8b-55ea-8289-b9b0b85999b6', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans la phrase « des cultures sont mal arrosées », à quelle voix est le verbe, et quelle serait la phrase à la voix active ?', '[{"id":"a","text":"Voix passive ; à l''actif : « on arrose mal des cultures »."},{"id":"b","text":"Voix active ; elle ne peut pas devenir passive."},{"id":"c","text":"Voix passive ; à l''actif : « des cultures arrosent mal »."},{"id":"d","text":"Voix active ; à l''actif : « des cultures sont arrosées »."}]'::jsonb, 'a', '« sont arrosées » (auxiliaire être + participe passé) est une voix passive sans complément d''agent exprimé ; à l''actif, on rétablit un sujet indéfini : « on arrose mal des cultures ». (b) est faux : la phrase EST déjà passive. (c) inverse le sens (les cultures n''arrosent pas). (d) répète une forme passive en la présentant à tort comme active.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de91684c-3e02-5bff-8675-478d9fd09ccf', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Lisez le texte :

« L''eau douce ne représente qu''une très petite partie de l''eau de la planète. Pourtant, elle est gaspillée chaque jour : des robinets fuient, des cultures sont mal arrosées et des litres entiers sont perdus. Les spécialistes rappellent que des gestes simples suffisent à économiser cette ressource. Si chacun fermait le robinet en se brossant les dents, des milliers de litres seraient préservés. »

Dans « Si chacun fermait le robinet…, des milliers de litres seraient préservés », quel rapport logique exprime la subordonnée introduite par « Si » ?', '[{"id":"a","text":"Une cause déjà réalisée dans le passé."},{"id":"b","text":"Une hypothèse (condition) dont dépend la conséquence."},{"id":"c","text":"Un but à atteindre absolument."},{"id":"d","text":"Une simple comparaison entre deux quantités."}]'::jsonb, 'b', '« Si chacun fermait… » + conditionnel « seraient préservés » exprime une hypothèse : une condition imaginée et sa conséquence probable. (a) : ce n''est pas une cause réelle passée. (c) : le but s''introduirait par « afin que / pour que ». (d) : aucune comparaison n''est faite, mais une condition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afa723fa-bea9-571b-a885-97d7cef1e780', '1d1ca79e-04f6-5f75-84b4-ab412ba348aa', 'Vous rédigez un court texte pour convaincre vos camarades d''économiser l''eau. Vous disposez de trois phrases :

1) Par exemple, fermer le robinet en se brossant les dents économise des litres d''eau.
2) Il est donc urgent d''adopter des gestes simples au quotidien.
3) L''eau douce est une ressource rare qu''il faut protéger.

Quel est le bon ordre logique du paragraphe ?', '[{"id":"a","text":"3 puis 1 puis 2"},{"id":"b","text":"1 puis 2 puis 3"},{"id":"c","text":"2 puis 3 puis 1"},{"id":"d","text":"1 puis 3 puis 2"}]'::jsonb, 'a', 'On annonce d''abord l''idée (3 : l''eau est rare), on l''illustre par un exemple (1 : « Par exemple… »), puis on conclut avec « donc » (2) : l''ordre 3-1-2 respecte annoncer → illustrer → conclure. Les autres ordres placent l''exemple (« Par exemple ») ou la conclusion (« donc ») avant l''idée annoncée, ce qui rompt la logique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('92e19205-ad69-502c-9e68-9cb60a80c9a6', '468647c4-f2b2-521f-a02c-d2d52d4c49b1', 'french', '🔥 Sujet 3 (Défi) — Texte argumentatif : faut-il garder le livre papier ?', 4, 300, 60, 'challenge', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1919ea5-25b0-53d3-86b7-f818b632d084', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Quelle est la thèse défendue par l''auteur ?', '[{"id":"a","text":"Le livre papier est condamné à disparaître à cause des écrans."},{"id":"b","text":"Le livre papier garde toute sa valeur et coexiste avec le numérique."},{"id":"c","text":"Il faut interdire les livres numériques."},{"id":"d","text":"Les écrans sont toujours meilleurs que le papier."}]'::jsonb, 'b', 'La conclusion l''énonce clairement : le papier « n''est donc pas un objet du passé » et reste « à côté du numérique, un compagnon fidèle » : il garde sa valeur et coexiste avec le numérique. (a) est l''opinion que l''auteur réfute (« C''est aller un peu vite »). (c) propose une interdiction absente du texte. (d) renverse la thèse en dévalorisant le papier.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1faf598-b829-53af-92cf-50f1ecdd875f', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Dans la dernière phrase, l''expression « un compagnon fidèle de la lecture » est employée au sens figuré. Que veut dire l''auteur ?', '[{"id":"a","text":"Le livre est une personne qui accompagne réellement le lecteur."},{"id":"b","text":"Le livre reste un objet précieux et constant, qui ne déçoit pas le lecteur."},{"id":"c","text":"Le livre est un animal domestique."},{"id":"d","text":"Le livre trahit souvent ceux qui le lisent."}]'::jsonb, 'b', '« Compagnon fidèle » est une métaphore : le livre est présenté comme un objet précieux, constant, sur lequel on peut compter (il ne tombe pas en panne de batterie). (a) prend l''image au sens propre (le livre n''est pas une personne). (c) confond avec un animal de compagnie. (d) dit l''inverse de « fidèle ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e70e2c64-52ce-5e05-9fd2-3ddb7237d2ad', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Quel est le rôle de la phrase « Certains pensent que le livre papier va bientôt disparaître » dans l''argumentation ?', '[{"id":"a","text":"C''est la thèse personnelle de l''auteur."},{"id":"b","text":"C''est le contre-argument (la thèse adverse) que l''auteur va réfuter."},{"id":"c","text":"C''est un simple exemple chiffré."},{"id":"d","text":"C''est la conclusion du texte."}]'::jsonb, 'b', 'L''auteur présente d''abord l''opinion adverse (« Certains pensent que… »), aussitôt rejetée par « C''est aller un peu vite » : c''est le contre-argument qu''il réfute. (a) est faux : c''est l''avis des autres, pas le sien. (c) : ce n''est pas un exemple chiffré. (d) : la conclusion arrive à la fin (« il reste… un compagnon fidèle »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1be344e-f76b-520e-b29a-16a7eeca0cda', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

La phrase au discours direct est : « Je garde encore les romans de mon père », confiait une lectrice. Quelle est sa transposition correcte au discours indirect ?', '[{"id":"a","text":"Une lectrice confiait qu''elle gardait encore les romans de son père."},{"id":"b","text":"Une lectrice confiait que je garde encore les romans de mon père."},{"id":"c","text":"Une lectrice confiait : elle gardait encore les romans de son père."},{"id":"d","text":"Une lectrice confiait qu''est-ce que je garde les romans de mon père ?"}]'::jsonb, 'a', 'Au discours indirect, on supprime les guillemets, on introduit par « que », et on adapte pronoms et temps : « je garde » → « elle gardait », « mon père » → « son père ». (b) garde les pronoms de la 1re personne, incohérents. (c) garde une ponctuation de discours direct (les deux-points). (d) transforme à tort l''énoncé en question.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dd987cc-488a-5181-95cc-a03f05f04878', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Lisez le texte :

« Certains pensent que le livre papier va bientôt disparaître au profit des écrans. C''est aller un peu vite. Un livre ne s''éteint jamais faute de batterie ; il se prête, s''annote, se transmet d''une génération à l''autre. “Je garde encore les romans de mon père”, confiait récemment une lectrice. Le papier n''est donc pas un objet du passé : il reste, à côté du numérique, un compagnon fidèle de la lecture. »

Dans « il se transmet d''une génération à l''autre », quelle est la nature de la proposition « qui ne s''éteint jamais faute de batterie » si on l''ajoutait après « Un livre » ?', '[{"id":"a","text":"Une proposition subordonnée relative, complément du nom « livre »."},{"id":"b","text":"Une proposition subordonnée circonstancielle de but."},{"id":"c","text":"Une proposition indépendante coordonnée."},{"id":"d","text":"Une proposition subordonnée complétive, COD du verbe."}]'::jsonb, 'a', 'Introduite par le pronom relatif « qui » et précisant le nom « livre » qui la précède, « qui ne s''éteint jamais… » est une subordonnée relative (complément de l''antécédent « livre »). (b) : une circonstancielle de but commencerait par « pour que / afin que ». (c) : une relative n''est pas indépendante, elle dépend d''un antécédent. (d) : une complétive COD serait introduite par « que » après un verbe (ex. « il dit que… »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63895d39-b503-5006-ad86-24e4f220feef', '92e19205-ad69-502c-9e68-9cb60a80c9a6', 'Vous voulez réfuter le contre-argument « le livre papier prend trop de place ». Quelle phrase réfute correctement ce contre-argument ?', '[{"id":"a","text":"Certes, un livre occupe de l''espace ; mais une bibliothèque se range et se partage facilement."},{"id":"b","text":"C''est vrai, les livres prennent vraiment trop de place chez soi."},{"id":"c","text":"Par exemple, les écrans prennent eux aussi de la place."},{"id":"d","text":"De plus, les livres encombrent énormément les maisons."}]'::jsonb, 'a', 'Réfuter, c''est concéder (« Certes… ») puis dépasser l''objection (« mais… ») : (a) reconnaît que le livre occupe de l''espace, puis montre que ce n''est pas un vrai problème. (b) ne fait que répéter et valider le contre-argument. (c) change de sujet (les écrans) sans réfuter. (d) renforce encore l''objection avec « De plus ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

