-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-1ere (Éveil scientifique)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-1ere/
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
  ('eveil-scientifique-1ere', 'Éveil scientifique', 'نكتشفُ معًا حواسّنا الخمس، وكيف نتغذّى وننمو، ونتعرّف على تنقّل الحيوانات وتنفّسها، ونستكشف الفضاء من حولنا والزمن والمادّة والقوّة، وفق برنامج الإيقاظ العلمي للسنة الأولى من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-base'))
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
      AND e.subject_id = 'eveil-scientifique-1ere'
      AND e.source = 'admin'
      AND q.id NOT IN ('797319f7-7f22-5856-af62-1552fc6c4b1b', 'ab69a8ee-fb29-5667-8418-ec0c4beed5dd', 'c4b47907-e10c-59e1-b875-fc0a59dc42d2', '45718328-5719-59e3-ae8e-62a35906f7c3', 'c380b912-8be4-50ae-b486-7569374813b4', '8a122abb-e6a8-5d66-94cf-bb0c851f9aa1', '544cafba-40eb-5a67-b218-87c905659ddf', 'd0c0f22b-18eb-55b8-a6be-d7b3fc2bde30', 'f41cb187-bdf0-513f-97e6-79070f892b5a', '5903e17e-8a09-5567-b07f-a323d5b1217e', '4987499b-a93d-58df-ba18-903291aa02d4', '5caa6a9d-349a-5d4c-ade6-ef593b795f35', '711bf5b7-b016-5416-8b79-25c27d7a409a', 'd3d8d763-b88b-5b98-b7ef-5b260488e462', '32de641c-093d-5116-b356-62fcabbfc123', 'fc57cd18-c360-5817-a45f-1095fd54f183', '568e7168-dd21-5cb8-87f5-79bba891d2de', '928b243d-3cb2-55ad-aa83-bc90b9bd0d5a', 'e5200ce7-f619-56e3-aedd-9763d8e60e26', 'e2c5647b-76cc-5ea7-bffb-5d86a427bf16', '53aec606-ae0d-5a24-b433-e050ae8421aa', '2e01689e-d565-5f86-85b2-f658353ac655', '6341a1af-8618-5f92-b9ba-5ac4e6643579', '2efaf06d-c8bc-53c5-9d36-aff8e965bb19', 'd95a3cfc-9f2f-5f59-855c-c860d7a94af6', '15931e82-6bf9-5b16-9caa-1b70278ce52e', '10ce34af-88d3-5b08-becb-3a52e50b7f8b', 'e513d31f-ec0f-5fd0-9931-09cc09e7523c', '7ef46df6-3772-5ed4-90bf-e099cdb90525', 'db6a7502-cec0-56d0-a518-a402de5f0e48', '417182cf-b75e-5488-81a9-c6767ca24473', '95a63249-562e-5df0-9822-4d963203b62f', '5e42ff1d-52f7-5932-a1d3-e462d2f35e9f', '3e7d6f65-0afc-54b4-827c-78a81b40b1a9', '9fdf6303-70c5-5afb-a2d4-b3b29a6009a8', 'dede595f-1fbc-583d-81a8-bbf4e38f7d56', '5477f5a2-1880-5780-b6ba-9516605f2775', '79955424-4520-527f-b94d-40280f20fcf0', '72b759a9-8c79-52f2-b194-66cc5fc82ac8', 'd32fa483-3241-59b2-bd5a-9bd25c28acad', '425a1532-9be3-5816-a571-16424a444fa1', '535a6607-ebc6-5d2f-aa1c-15e0cefb8fe3', '1eb99c84-2ba0-557b-903f-0d11f58b9af4', '0797ce16-ece6-5342-b34d-f47a45151057', '5a88255a-4d0c-58bc-b72c-3d4c7affd81b', '14fff29c-44c1-59f1-9939-ed4893bc1e1b', '16c5d340-49e1-54ef-917f-3553284f0b47', 'db9f3234-7a98-570c-9327-c57f53dae62d', '989ab666-f024-5cb5-b9ea-58ac7318d205', '4763d1d3-1e4a-5b67-8eca-f45848a80d7c', '2d35aeba-4a1f-56f0-a495-9b74fc5c3c28', 'df8d971a-f9f0-53af-8e8b-54a74d876a5f', 'd5cff833-47c9-52c2-8235-4e1c8b07154f', '62c0e7e7-6660-5af0-b8d3-82d7ed78276b', '575f5bae-afd5-53d6-aaaa-23c040132a24', '907c59f0-253f-556d-9d75-46771ec2ed4c', 'e696d96b-0ccb-5a94-822b-c3f51a71887c', 'e323ad46-f321-5340-bd37-1f8fdb40c835', '1c6d8cc8-175b-542d-a070-cc3803be9b8a', '97b24f01-d38b-54ea-9c55-3030da465a65', '85acc4f0-056d-5446-922a-07b3837bdf50', 'a6c8e750-d105-56f2-a2e6-e51789bad687', '38cb59dc-8f09-5c6f-9a2a-a550c2c7ced7', '5b52df6e-5d69-57ae-95a7-16f104e2665b', '2a3909ef-4dc5-582e-b179-0ac90a2bf918', '41d1c8dc-935e-5153-b791-ba245f593319', '0639626b-3843-5f24-8374-39bcf1859b25', '6fb58601-b733-5053-b7a5-7eb742e68b5e', 'c113df68-b9ef-5d85-a6f3-965be0f6725e', 'a357ab76-3be4-5307-a12c-b6932e957cb9', '3ca17ae0-68c1-5c56-b189-0d99cd949fde', '4c33ee31-d583-5077-84e2-7ff75d13368e', '51624af3-f875-527b-960e-11d23ba0e9ba', '0a51fc1f-dcfc-559c-9634-3f498357058e', '4d689817-8815-59f2-a45d-e2ecdd48b847', '32196fdf-727e-58cf-9219-8f6aff9d126b', '3cfd59be-d840-5fa6-b00f-5da5fd42cfc1', 'b0ab3549-ed38-5814-9462-f67584b12c5d', '9fdbda12-69a4-508f-957b-88f55a087174', '28910768-07f4-58c1-adfc-4ecc82b5611c', '0a59eb49-a350-5514-8c75-9cdfadf87c25', '75b558bc-af93-581a-8fcf-1cef9a3bb76f', '63f625e0-4d4c-56e1-8d29-7004d1430ea7', '79fa8c15-2a43-5728-be12-44cb413412c8', 'e6581d27-5bc3-59a1-b009-6b0fcea1c5e2', '2d3e913a-75fe-5023-9350-fc322fc586a7', '4ddcc60f-ca3a-52f3-94d9-a3d5db8fa6cd', '9cf647d0-8336-5b69-94ac-839c37093388', 'd9ae7e22-7f5b-5820-8091-5963c44e9aa8', 'd396bb9e-edd6-5357-b8f5-a83c690836d2', 'd86311f3-99f8-5b4f-8948-ae1f60e34e80', '82b52e53-ecef-5afb-89d5-8ab104df5083', 'ff8cd75d-dc37-5d2e-b5cf-b6d1472c0c04', 'bb8163d3-26d3-5fa4-88f3-df23cb9e6665', 'a2e69cbb-305a-54b2-aecc-2862ea2860f1', 'c2e1bd32-2c18-59ac-b4bd-1b8bf3776e02', 'b0c9252e-2539-55a6-a0df-c49ea64b04ce', 'ea358620-f1d0-5876-95bd-95eeb942ffb8', '3ee4bd48-9602-5c78-b33f-3330dfadff1e', 'ee4418f5-5318-5d79-adde-3fadfecbcc81', 'b203bfe5-a091-5507-a519-f7cfd287383c', '3379f810-e8ae-51ea-9846-31369f3ca0da', '0485c94e-14c8-587a-ad48-849faa10ba34', 'c3385d95-7f83-5220-a550-81227cd1cecd', 'f437b206-4722-50f4-bdb5-4bdbeb6ed0a7', 'fd6f02ac-b2ec-51b4-9e9e-c60d9c647e62', 'c09d0a17-ce41-55b6-b54f-63f77b286ba3', '62685c61-684e-5dd5-b9ce-64798d662f03', 'cb29af42-583b-56b9-b015-6570aecfb89e', '186e97df-d285-5e20-a42f-39c3f9efe2c1', '0a896ded-fa4b-5cd9-b5a6-d22b4ff6b8be', 'b9d00ea5-1e13-56b2-86c5-1de167388f64', 'cbe27dd8-16b5-5294-bc39-546c7be28549', '93e093a8-ff31-5434-a023-baa96f6344b4', '21e343f6-1585-5256-9b98-e2f9ee4fe815', '7bd99a7d-1f8e-5484-a939-8242f67d9159', '3cfbe065-f095-5a5f-8dc4-318ee1c2f1b8', '2c12e5b2-1d6b-568a-8670-e10b3061842e', 'a842e350-82b0-5796-a1e6-830ed992c02a', '79be4f57-3962-5e0e-8b81-9f72bc2f86e0', '717bc64a-aa2e-5713-99a4-4f9c80d5b760', '20069a38-419e-5d15-bb12-d99e874f0898', 'c1ccfe24-9ca0-5a08-96ce-18afddbd3364', '74aeb754-7b12-5e43-826c-ce65251820b5', '05a556d9-f0b2-5e94-bb9b-708fe18df81c', '9fd94ced-b5e7-5a1f-b208-c046f2f4d8ea', '12cfd730-8709-51e6-8866-5e6a985bdb0e', '29e84b83-483a-5d8d-ab2e-685b06a3c51b', 'e0f2b703-8433-58f0-ac4e-ed318ce4e84a', 'ba2067bb-88df-5f6b-b143-213a20c5837e', 'b2f32a0b-f0e9-5f1f-bd3d-8295f6af267f', '0a33ece8-cd5d-5146-93b3-8a7a20a6418e', '099d110e-004c-57cd-838e-e909fa83b546', 'd3b1c085-ed4a-56df-b0c0-b34cda092539', 'da256338-16c1-54b8-b235-e56a2ed73f3a', 'ef0e72af-1bca-56b8-93ea-366225d9d9b9', '3ba18e4f-02a7-5373-b09a-6a53ed6cdab6', '094ed7c2-d75e-5124-bcff-acc1eb8e81ec', 'ec56f592-45f2-5e9d-a26b-553bbdd4222e', 'd7082da6-175a-5b9b-b993-867b2d5c23b5', 'bc6acf37-135e-5979-a448-e53e5454c22f', 'f03e3368-bb0c-5ce9-80b4-fb4d54f326ab', 'aef52862-070e-50d9-a94c-4ff2b1bd89fd', 'aa5f38f6-a497-5036-8c92-969c46a07545', '31f63f0f-4451-5d0c-bed7-4270c7c400cd', '269dbfe8-b49b-5827-9326-bc61575780f6', '14185041-c3ab-5327-b103-05ab21644d70', 'de3af131-e549-5968-8640-61c9d464c338', '0568aa2d-a328-54c8-aea1-01ab83c33474', 'ae579ff4-7e1f-5047-a08d-e584f2caeb0a', 'ca591b40-d02d-5b40-95a5-6aa9ffeee25f', '629cf0d0-c3fe-5f74-94fc-370f55ac0276', 'd9c4b74b-8b3f-5ee0-97df-fb06a25e50b1', '49643a1b-8b29-5a41-a622-3c251eb59afb', '5bb5591d-2d6f-597d-845e-768a2b9ee2bf', '7e116f7d-6da9-5de8-881f-c50bcb569ec3', '62b5a971-c42e-50f9-bdb1-28800bf4cc21', 'c06ece7a-eecc-5598-8a23-45c5ae12edf9', '295935b0-5e8b-59b0-9f6d-8f55eb12d54e', 'acc9cce4-21e5-5d78-876b-fd8374569f6a', 'f40d9dd6-b771-535e-b3d1-a92cde2baf8a', '1c516ddb-88d5-56fa-bcbf-7dc9e606bd2d', 'd64490a4-fbdd-59bd-9441-96aa63a1106a', '08075f6e-06d8-5a08-9cc5-4c1bc4cf1c6b', 'c47e682f-586a-5f7b-83eb-21fbbd0b64a6', '3c9011be-756c-5a49-851f-de92caad83d0', '73e65a62-d986-59d2-a69e-0bb985f46934', 'dbbbcb4c-6e1e-5f3e-8a6a-40b5cbfa77f9', 'ed9392e8-b14f-5b75-b6a6-724355b737c7', 'ea9c85a3-1968-5eae-b70f-22da847ba7a3', '711e7cd1-29db-5679-ba0a-fc0c53035615', '831a11e3-47f8-5e86-858a-f3304425242e', 'd4e147d2-623b-5f86-a055-167395826c4b', '5c5b7cc7-0f72-59de-b3dd-e86e5de5c5ed', 'f441a204-f233-5913-aae9-97c7c89f499c', '1b98ce4d-ea2c-5169-ba88-14164bf3c0af', 'db8a4c7e-31f2-568a-8e18-c21142457d6b', 'c53685d5-cda7-54a1-a33a-c6aa1759a256', 'd1d2328a-7990-544c-b9d9-e5031001c09b', '821843c3-49bf-58f1-a34a-4b197e1e921c', '2c19d3f9-3543-5308-a9df-044fc8a7887c', 'd3b9a6d3-4ad5-5866-ab1c-743e449c0561', 'fabefb1c-489d-5cc7-8e77-682ab9c43b7e', 'dfdd137d-8d52-5f10-bddc-c2ca09e98ab6', '08888205-c2bc-5051-b587-1e528586d2f8', '427209d2-cfa1-5261-a9e2-85654f3d6f3e', '5e4270c9-2cf0-561b-a72c-85f73df6744f', '0df2c68e-fc8d-5ca7-a660-db09b3a59069', '0411bd04-a779-5102-9f5f-89704e42d82c', '42fa89e9-108f-55a5-a951-5d184fef9c5d', 'f2ee472a-16c8-57d6-9c4c-8cfcdf72b7de', '767421b3-737c-56e3-88c7-298311dd79ac', 'abff07eb-7ace-53c9-bbf3-c48fb52b6a2e', '415c6e98-f18e-5b31-a8b8-66e64f7e83f2', '9671a08e-b37d-5337-8cfb-b149e4c1f619', 'fe5e1493-78a4-541a-84dc-f3044fc94253', '7a8230da-9bd3-5fe8-80b8-af2b65a99222', 'b9c5631d-0ee5-5833-8c7a-759a586952fb', 'fca52412-4577-504b-978e-23de1b3ef009', '866a7f37-4e5e-541f-8c86-20afcc42006a', '0b288b2f-45a1-59c9-8b87-0e812e8844cd', '02b6fcc4-437e-5a3a-8349-cf4558a493f8', 'c91d2420-5869-5a94-83a3-d13dbf1da394', 'adabc82b-0222-5b94-9c3b-66896f4cc79e', '16030d28-1dbd-5b65-987d-a0336adfd3e1', '52b2aec1-4079-5854-9315-189d385802b7', '25f155be-a82b-52e6-be3f-1c4103d2f165', '49fb47a0-0c46-5fd0-ba48-be60466395f1', '0d310dc6-62fa-55fd-a515-1d774c6921f6', 'c18a8e37-8a64-5584-b11b-31f2247d232f', '174b1519-4dab-5ade-a5ce-4ccecc04e904', '07193cce-2acd-53ab-a989-8d2cce09ad61', 'da64eb0b-e7e9-55d4-914f-0aaf2a9507fe', 'bc52b3fd-1ee7-52eb-a98e-b40757e316e2', 'b3ab0a3a-373d-5fe4-9ee8-75984cdfb447', '08994c8b-9274-524b-9896-e67a77f68508', 'f8ed5544-dd26-5ee6-a976-356da6d9b541', '02832354-eca4-521a-ad1f-a8e68b60d030', '21432594-79bb-51ba-8e4d-ee75dd7d10cf', '39c2007b-fc91-57ec-a5ea-7b6af84de5df', 'e706b869-a2ab-5f6a-bbc0-9ae91850043e', '891ebc92-8c18-5b7a-8d95-16932c0c6dff', '6ee1db43-0a97-564e-8e70-b9e62a54aa70', '431b438c-ed06-585a-8279-ce50dca147af', '97030cf3-2983-557d-a78b-c515a289d1d8', '0916f908-10cd-5c5a-b1c8-e228378782ec', 'e2dc42dd-103b-5dcd-b440-220cc821b0b8', '6dd51389-6b7b-5a95-998a-7089153573f1', '90c14001-7347-5d07-8fc5-1b69654f7e37', 'f07878c2-3aa6-59c7-a8d3-0c094c51d34b', '1dadd40a-d02b-5eb5-91ca-c07decb413b2', '863915cb-ac46-5b89-81d2-f46caed381d6', 'f5e1d19f-677b-5bb6-9f72-cd348b8f10a6', 'b7fd4fe8-766b-5abe-b6e0-ebda5cdcb51b', 'b5bb896b-7ace-5143-9598-74093ea23443', '26d70cc3-0eb7-57c6-880d-20c7d8cc7659', '1b4f940b-f5ee-52c9-89e0-07c484dba278', '13160121-5a28-5446-82e9-1c2319288b24', '9c4017cc-7a82-5e8c-af83-3f376baad912', '2d9263cc-3232-5773-b6a1-5d6f79d743ff', '87d216fb-f43a-5a1b-b623-e2b1e42d40b3', '2b9de268-c62a-5346-bce1-1d806f5accd2', '2acb401b-1062-512b-8858-3f887dcf7dd1', 'ca9f764f-6251-5e87-819d-bd4d18708bbd', 'db1de0c3-5414-5bbf-b11a-9400f348e1b7', '4f9aa716-95a6-5cac-bb00-766462a27af7', '475f3162-53e7-5959-ad5f-638a6dca4959', '73247af3-85b3-577c-a75e-0baeb09d2ad1', '87ae2b6e-47b7-5c0d-a841-08d329fb09d9', 'b1bfa687-6303-5625-9a0a-fb024e156dba', '06cf6271-dbea-5a07-b4db-d09b9e5edb26', '24d7c1a7-5101-51de-87d4-1760fa2cbcaa', '13e83993-71bb-554c-b652-bbf5c0bb88ae', '9cd46491-d26e-5755-b185-0ac3a7049582', 'fc7d242a-c0a5-5b8b-a25b-38d9c5cff240', 'e6241c3a-dc32-59c7-bed1-5cbe21d62ac9', '3f27e8c6-07e0-53c8-9982-68b12de63c74', '7dfef970-3a49-5389-8f94-c82d0017cfa7', '5ebb29ba-20da-547f-b6ca-f57c824a4676', '8130e195-ae33-534f-a784-42e3084621d9', '1a291177-9aa3-5ec7-9d5f-9678f35b7863', '6825685c-555f-501d-b6af-f69caa238a00', '499dc4ab-763b-5ccd-9d25-a2710aa43c36', '8a5c7527-a90e-5591-a284-5b2084d0bbcc', '36eba76c-9c7c-5534-842c-66f794b02988', '9a570eae-3dbf-57a9-a56f-84a918418d9f', '314c032f-2d36-585b-86c6-723ff6172c92', 'b4cfd316-b4f3-55b2-82a6-cfe347a53b94', '4554c0c9-744c-5e86-a493-ebb4724956f5', '1fbb6c15-9bb9-5377-9ecb-9215c9b27e0f', 'cbeca6e4-5284-5dea-b407-813ba3943818', '5c839926-b29d-54aa-8e15-c886614b0ee3', 'a7c74f82-3464-5e8e-af7d-2e2602c69c0c', '0cf56648-0495-5375-ad9f-691eb1bba319', '9f9e8daf-2460-55ec-ab66-93d14e029712', 'd4e9bdf5-81a4-53fb-b544-1130bb343731', 'c1662f91-3a03-56a3-8461-1cd8f5f01ab8', '9d2da62f-297d-56fd-a9be-66f7f29cecd0', '3e6dec99-ddfc-56ef-889d-d9986ac9dda5', '19152c92-32aa-537a-b3ae-0ede95e1fee9', 'af31b799-7456-5b03-807d-faa9bdfbeede', '4d61bfc7-433b-56eb-91dc-09efaa3efa01', '2571bfc7-51dd-5564-9bb7-177941ffcbed', '07bedab2-364f-50f2-9f8a-0c915a8212e4', 'a2ddf4b5-c725-5070-8654-a2613379644d', '5e14ab6a-e6d5-5d75-a0b8-ff750f8db2c5', '7e689ac4-4ef5-5810-8411-e783f1b7f92f', '8924dfc6-0ea3-5107-aaed-68f260a08ecc', 'a81df5bf-0dd2-57b5-9a94-07a798efbe84', '28a11ba1-53e7-5a4b-b4ec-a125322c9330', 'a9542377-7294-5a22-b249-691a7c484c22', '09e1a8d0-68ed-5a9e-9738-af8e41841e87', '44982a7b-fd3b-5dde-b7ff-87ab89b1c6a0', 'deb82226-91c4-52fb-b9f8-caa97f47e3c9', 'fe77f144-e1f6-5cbc-964c-ca8e9902268e', '074a7021-0c82-5462-8fca-8f52e4fc45be', 'a139fc07-8bf3-556c-9291-7eb6cad82d22', '1095b355-d884-52da-9417-0eea2805e295', 'f2b67856-e265-5b1b-8243-9905d4f9153f', 'a0a4af51-5bf8-5b95-9374-6c8a725bb5e1', '7ac7dd14-badd-58b0-8ef1-2fcc8705d14a', 'ec539215-7689-5e81-814a-a31147f4e693', 'b9d5d51e-2684-5a67-859c-303fca0092bf', 'aba16f54-30bb-51e8-8cad-d473f0e62f56', 'c7424a1c-0aca-5b08-9593-7e5f39ffb976', 'c13d3efe-8d56-56c3-a228-9f6cad07b2a0', '1c7020f5-ae32-52ef-8112-03bfb5d2ddc9', 'be6aa327-d4b5-520c-b04f-ed3ece04d821', 'b5a8a8a9-7b02-5356-bbbc-dcb645452669', 'def2cb5e-a743-5083-be68-f86fa31d7ad5', '8d47354b-6a7b-527c-8552-40cac821d0d7', '8594b6c3-7679-535c-865f-845437620145', '113c03f6-bd3b-5d41-8d97-13c83e19dbc5', '8deb5611-2b38-5b0f-9cfa-b2d05387f66b', '86b110c6-223b-574a-91d0-7ba1ff583af5');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-1ere' AND source = 'admin' AND id NOT IN ('5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', '621ad1be-b425-511d-9b81-b13da8c3f781', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', '4251deb9-6825-5322-a8f5-a762114f78a0', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', '63d4ed85-5e8d-5322-b384-cb255cebcf61', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', '877b7a09-423f-5a53-b947-185e6c436a6e', 'bff82117-2328-55f2-b273-339abd04085d', '358382e3-6553-5530-9530-c3f62332526e', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', '17138a5a-d046-5c49-a475-686c0b62ce2d', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', '745203dd-7d5a-515d-9443-13c682737452', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'bb77b11c-f539-532c-ac66-9510eba496a7', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', '49b9ca98-e7c9-5282-98a2-84559e213f57', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', '750d65d7-e756-5366-afb7-d580126d0cfb', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', '9e6f9d1a-5379-5212-b8d1-c6818332045e', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'b65ac10b-432b-5f12-8927-a48cde89dc32', '9a5041e8-ab21-5488-abee-7fa9cb69950e', '124e4093-9b3c-5854-a21c-78eff4543c23', 'b82fd46b-6422-5076-8157-a936d77db82e', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'a5a18068-dd08-5595-908c-1485678cf15a', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9');
DELETE FROM public.questions WHERE exercise_id IN ('5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', '621ad1be-b425-511d-9b81-b13da8c3f781', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', '4251deb9-6825-5322-a8f5-a762114f78a0', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', '63d4ed85-5e8d-5322-b384-cb255cebcf61', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', '877b7a09-423f-5a53-b947-185e6c436a6e', 'bff82117-2328-55f2-b273-339abd04085d', '358382e3-6553-5530-9530-c3f62332526e', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', '17138a5a-d046-5c49-a475-686c0b62ce2d', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', '745203dd-7d5a-515d-9443-13c682737452', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'bb77b11c-f539-532c-ac66-9510eba496a7', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', '49b9ca98-e7c9-5282-98a2-84559e213f57', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', '750d65d7-e756-5366-afb7-d580126d0cfb', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', '9e6f9d1a-5379-5212-b8d1-c6818332045e', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'b65ac10b-432b-5f12-8927-a48cde89dc32', '9a5041e8-ab21-5488-abee-7fa9cb69950e', '124e4093-9b3c-5854-a21c-78eff4543c23', 'b82fd46b-6422-5076-8157-a936d77db82e', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'a5a18068-dd08-5595-908c-1485678cf15a', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9') AND id NOT IN ('797319f7-7f22-5856-af62-1552fc6c4b1b', 'ab69a8ee-fb29-5667-8418-ec0c4beed5dd', 'c4b47907-e10c-59e1-b875-fc0a59dc42d2', '45718328-5719-59e3-ae8e-62a35906f7c3', 'c380b912-8be4-50ae-b486-7569374813b4', '8a122abb-e6a8-5d66-94cf-bb0c851f9aa1', '544cafba-40eb-5a67-b218-87c905659ddf', 'd0c0f22b-18eb-55b8-a6be-d7b3fc2bde30', 'f41cb187-bdf0-513f-97e6-79070f892b5a', '5903e17e-8a09-5567-b07f-a323d5b1217e', '4987499b-a93d-58df-ba18-903291aa02d4', '5caa6a9d-349a-5d4c-ade6-ef593b795f35', '711bf5b7-b016-5416-8b79-25c27d7a409a', 'd3d8d763-b88b-5b98-b7ef-5b260488e462', '32de641c-093d-5116-b356-62fcabbfc123', 'fc57cd18-c360-5817-a45f-1095fd54f183', '568e7168-dd21-5cb8-87f5-79bba891d2de', '928b243d-3cb2-55ad-aa83-bc90b9bd0d5a', 'e5200ce7-f619-56e3-aedd-9763d8e60e26', 'e2c5647b-76cc-5ea7-bffb-5d86a427bf16', '53aec606-ae0d-5a24-b433-e050ae8421aa', '2e01689e-d565-5f86-85b2-f658353ac655', '6341a1af-8618-5f92-b9ba-5ac4e6643579', '2efaf06d-c8bc-53c5-9d36-aff8e965bb19', 'd95a3cfc-9f2f-5f59-855c-c860d7a94af6', '15931e82-6bf9-5b16-9caa-1b70278ce52e', '10ce34af-88d3-5b08-becb-3a52e50b7f8b', 'e513d31f-ec0f-5fd0-9931-09cc09e7523c', '7ef46df6-3772-5ed4-90bf-e099cdb90525', 'db6a7502-cec0-56d0-a518-a402de5f0e48', '417182cf-b75e-5488-81a9-c6767ca24473', '95a63249-562e-5df0-9822-4d963203b62f', '5e42ff1d-52f7-5932-a1d3-e462d2f35e9f', '3e7d6f65-0afc-54b4-827c-78a81b40b1a9', '9fdf6303-70c5-5afb-a2d4-b3b29a6009a8', 'dede595f-1fbc-583d-81a8-bbf4e38f7d56', '5477f5a2-1880-5780-b6ba-9516605f2775', '79955424-4520-527f-b94d-40280f20fcf0', '72b759a9-8c79-52f2-b194-66cc5fc82ac8', 'd32fa483-3241-59b2-bd5a-9bd25c28acad', '425a1532-9be3-5816-a571-16424a444fa1', '535a6607-ebc6-5d2f-aa1c-15e0cefb8fe3', '1eb99c84-2ba0-557b-903f-0d11f58b9af4', '0797ce16-ece6-5342-b34d-f47a45151057', '5a88255a-4d0c-58bc-b72c-3d4c7affd81b', '14fff29c-44c1-59f1-9939-ed4893bc1e1b', '16c5d340-49e1-54ef-917f-3553284f0b47', 'db9f3234-7a98-570c-9327-c57f53dae62d', '989ab666-f024-5cb5-b9ea-58ac7318d205', '4763d1d3-1e4a-5b67-8eca-f45848a80d7c', '2d35aeba-4a1f-56f0-a495-9b74fc5c3c28', 'df8d971a-f9f0-53af-8e8b-54a74d876a5f', 'd5cff833-47c9-52c2-8235-4e1c8b07154f', '62c0e7e7-6660-5af0-b8d3-82d7ed78276b', '575f5bae-afd5-53d6-aaaa-23c040132a24', '907c59f0-253f-556d-9d75-46771ec2ed4c', 'e696d96b-0ccb-5a94-822b-c3f51a71887c', 'e323ad46-f321-5340-bd37-1f8fdb40c835', '1c6d8cc8-175b-542d-a070-cc3803be9b8a', '97b24f01-d38b-54ea-9c55-3030da465a65', '85acc4f0-056d-5446-922a-07b3837bdf50', 'a6c8e750-d105-56f2-a2e6-e51789bad687', '38cb59dc-8f09-5c6f-9a2a-a550c2c7ced7', '5b52df6e-5d69-57ae-95a7-16f104e2665b', '2a3909ef-4dc5-582e-b179-0ac90a2bf918', '41d1c8dc-935e-5153-b791-ba245f593319', '0639626b-3843-5f24-8374-39bcf1859b25', '6fb58601-b733-5053-b7a5-7eb742e68b5e', 'c113df68-b9ef-5d85-a6f3-965be0f6725e', 'a357ab76-3be4-5307-a12c-b6932e957cb9', '3ca17ae0-68c1-5c56-b189-0d99cd949fde', '4c33ee31-d583-5077-84e2-7ff75d13368e', '51624af3-f875-527b-960e-11d23ba0e9ba', '0a51fc1f-dcfc-559c-9634-3f498357058e', '4d689817-8815-59f2-a45d-e2ecdd48b847', '32196fdf-727e-58cf-9219-8f6aff9d126b', '3cfd59be-d840-5fa6-b00f-5da5fd42cfc1', 'b0ab3549-ed38-5814-9462-f67584b12c5d', '9fdbda12-69a4-508f-957b-88f55a087174', '28910768-07f4-58c1-adfc-4ecc82b5611c', '0a59eb49-a350-5514-8c75-9cdfadf87c25', '75b558bc-af93-581a-8fcf-1cef9a3bb76f', '63f625e0-4d4c-56e1-8d29-7004d1430ea7', '79fa8c15-2a43-5728-be12-44cb413412c8', 'e6581d27-5bc3-59a1-b009-6b0fcea1c5e2', '2d3e913a-75fe-5023-9350-fc322fc586a7', '4ddcc60f-ca3a-52f3-94d9-a3d5db8fa6cd', '9cf647d0-8336-5b69-94ac-839c37093388', 'd9ae7e22-7f5b-5820-8091-5963c44e9aa8', 'd396bb9e-edd6-5357-b8f5-a83c690836d2', 'd86311f3-99f8-5b4f-8948-ae1f60e34e80', '82b52e53-ecef-5afb-89d5-8ab104df5083', 'ff8cd75d-dc37-5d2e-b5cf-b6d1472c0c04', 'bb8163d3-26d3-5fa4-88f3-df23cb9e6665', 'a2e69cbb-305a-54b2-aecc-2862ea2860f1', 'c2e1bd32-2c18-59ac-b4bd-1b8bf3776e02', 'b0c9252e-2539-55a6-a0df-c49ea64b04ce', 'ea358620-f1d0-5876-95bd-95eeb942ffb8', '3ee4bd48-9602-5c78-b33f-3330dfadff1e', 'ee4418f5-5318-5d79-adde-3fadfecbcc81', 'b203bfe5-a091-5507-a519-f7cfd287383c', '3379f810-e8ae-51ea-9846-31369f3ca0da', '0485c94e-14c8-587a-ad48-849faa10ba34', 'c3385d95-7f83-5220-a550-81227cd1cecd', 'f437b206-4722-50f4-bdb5-4bdbeb6ed0a7', 'fd6f02ac-b2ec-51b4-9e9e-c60d9c647e62', 'c09d0a17-ce41-55b6-b54f-63f77b286ba3', '62685c61-684e-5dd5-b9ce-64798d662f03', 'cb29af42-583b-56b9-b015-6570aecfb89e', '186e97df-d285-5e20-a42f-39c3f9efe2c1', '0a896ded-fa4b-5cd9-b5a6-d22b4ff6b8be', 'b9d00ea5-1e13-56b2-86c5-1de167388f64', 'cbe27dd8-16b5-5294-bc39-546c7be28549', '93e093a8-ff31-5434-a023-baa96f6344b4', '21e343f6-1585-5256-9b98-e2f9ee4fe815', '7bd99a7d-1f8e-5484-a939-8242f67d9159', '3cfbe065-f095-5a5f-8dc4-318ee1c2f1b8', '2c12e5b2-1d6b-568a-8670-e10b3061842e', 'a842e350-82b0-5796-a1e6-830ed992c02a', '79be4f57-3962-5e0e-8b81-9f72bc2f86e0', '717bc64a-aa2e-5713-99a4-4f9c80d5b760', '20069a38-419e-5d15-bb12-d99e874f0898', 'c1ccfe24-9ca0-5a08-96ce-18afddbd3364', '74aeb754-7b12-5e43-826c-ce65251820b5', '05a556d9-f0b2-5e94-bb9b-708fe18df81c', '9fd94ced-b5e7-5a1f-b208-c046f2f4d8ea', '12cfd730-8709-51e6-8866-5e6a985bdb0e', '29e84b83-483a-5d8d-ab2e-685b06a3c51b', 'e0f2b703-8433-58f0-ac4e-ed318ce4e84a', 'ba2067bb-88df-5f6b-b143-213a20c5837e', 'b2f32a0b-f0e9-5f1f-bd3d-8295f6af267f', '0a33ece8-cd5d-5146-93b3-8a7a20a6418e', '099d110e-004c-57cd-838e-e909fa83b546', 'd3b1c085-ed4a-56df-b0c0-b34cda092539', 'da256338-16c1-54b8-b235-e56a2ed73f3a', 'ef0e72af-1bca-56b8-93ea-366225d9d9b9', '3ba18e4f-02a7-5373-b09a-6a53ed6cdab6', '094ed7c2-d75e-5124-bcff-acc1eb8e81ec', 'ec56f592-45f2-5e9d-a26b-553bbdd4222e', 'd7082da6-175a-5b9b-b993-867b2d5c23b5', 'bc6acf37-135e-5979-a448-e53e5454c22f', 'f03e3368-bb0c-5ce9-80b4-fb4d54f326ab', 'aef52862-070e-50d9-a94c-4ff2b1bd89fd', 'aa5f38f6-a497-5036-8c92-969c46a07545', '31f63f0f-4451-5d0c-bed7-4270c7c400cd', '269dbfe8-b49b-5827-9326-bc61575780f6', '14185041-c3ab-5327-b103-05ab21644d70', 'de3af131-e549-5968-8640-61c9d464c338', '0568aa2d-a328-54c8-aea1-01ab83c33474', 'ae579ff4-7e1f-5047-a08d-e584f2caeb0a', 'ca591b40-d02d-5b40-95a5-6aa9ffeee25f', '629cf0d0-c3fe-5f74-94fc-370f55ac0276', 'd9c4b74b-8b3f-5ee0-97df-fb06a25e50b1', '49643a1b-8b29-5a41-a622-3c251eb59afb', '5bb5591d-2d6f-597d-845e-768a2b9ee2bf', '7e116f7d-6da9-5de8-881f-c50bcb569ec3', '62b5a971-c42e-50f9-bdb1-28800bf4cc21', 'c06ece7a-eecc-5598-8a23-45c5ae12edf9', '295935b0-5e8b-59b0-9f6d-8f55eb12d54e', 'acc9cce4-21e5-5d78-876b-fd8374569f6a', 'f40d9dd6-b771-535e-b3d1-a92cde2baf8a', '1c516ddb-88d5-56fa-bcbf-7dc9e606bd2d', 'd64490a4-fbdd-59bd-9441-96aa63a1106a', '08075f6e-06d8-5a08-9cc5-4c1bc4cf1c6b', 'c47e682f-586a-5f7b-83eb-21fbbd0b64a6', '3c9011be-756c-5a49-851f-de92caad83d0', '73e65a62-d986-59d2-a69e-0bb985f46934', 'dbbbcb4c-6e1e-5f3e-8a6a-40b5cbfa77f9', 'ed9392e8-b14f-5b75-b6a6-724355b737c7', 'ea9c85a3-1968-5eae-b70f-22da847ba7a3', '711e7cd1-29db-5679-ba0a-fc0c53035615', '831a11e3-47f8-5e86-858a-f3304425242e', 'd4e147d2-623b-5f86-a055-167395826c4b', '5c5b7cc7-0f72-59de-b3dd-e86e5de5c5ed', 'f441a204-f233-5913-aae9-97c7c89f499c', '1b98ce4d-ea2c-5169-ba88-14164bf3c0af', 'db8a4c7e-31f2-568a-8e18-c21142457d6b', 'c53685d5-cda7-54a1-a33a-c6aa1759a256', 'd1d2328a-7990-544c-b9d9-e5031001c09b', '821843c3-49bf-58f1-a34a-4b197e1e921c', '2c19d3f9-3543-5308-a9df-044fc8a7887c', 'd3b9a6d3-4ad5-5866-ab1c-743e449c0561', 'fabefb1c-489d-5cc7-8e77-682ab9c43b7e', 'dfdd137d-8d52-5f10-bddc-c2ca09e98ab6', '08888205-c2bc-5051-b587-1e528586d2f8', '427209d2-cfa1-5261-a9e2-85654f3d6f3e', '5e4270c9-2cf0-561b-a72c-85f73df6744f', '0df2c68e-fc8d-5ca7-a660-db09b3a59069', '0411bd04-a779-5102-9f5f-89704e42d82c', '42fa89e9-108f-55a5-a951-5d184fef9c5d', 'f2ee472a-16c8-57d6-9c4c-8cfcdf72b7de', '767421b3-737c-56e3-88c7-298311dd79ac', 'abff07eb-7ace-53c9-bbf3-c48fb52b6a2e', '415c6e98-f18e-5b31-a8b8-66e64f7e83f2', '9671a08e-b37d-5337-8cfb-b149e4c1f619', 'fe5e1493-78a4-541a-84dc-f3044fc94253', '7a8230da-9bd3-5fe8-80b8-af2b65a99222', 'b9c5631d-0ee5-5833-8c7a-759a586952fb', 'fca52412-4577-504b-978e-23de1b3ef009', '866a7f37-4e5e-541f-8c86-20afcc42006a', '0b288b2f-45a1-59c9-8b87-0e812e8844cd', '02b6fcc4-437e-5a3a-8349-cf4558a493f8', 'c91d2420-5869-5a94-83a3-d13dbf1da394', 'adabc82b-0222-5b94-9c3b-66896f4cc79e', '16030d28-1dbd-5b65-987d-a0336adfd3e1', '52b2aec1-4079-5854-9315-189d385802b7', '25f155be-a82b-52e6-be3f-1c4103d2f165', '49fb47a0-0c46-5fd0-ba48-be60466395f1', '0d310dc6-62fa-55fd-a515-1d774c6921f6', 'c18a8e37-8a64-5584-b11b-31f2247d232f', '174b1519-4dab-5ade-a5ce-4ccecc04e904', '07193cce-2acd-53ab-a989-8d2cce09ad61', 'da64eb0b-e7e9-55d4-914f-0aaf2a9507fe', 'bc52b3fd-1ee7-52eb-a98e-b40757e316e2', 'b3ab0a3a-373d-5fe4-9ee8-75984cdfb447', '08994c8b-9274-524b-9896-e67a77f68508', 'f8ed5544-dd26-5ee6-a976-356da6d9b541', '02832354-eca4-521a-ad1f-a8e68b60d030', '21432594-79bb-51ba-8e4d-ee75dd7d10cf', '39c2007b-fc91-57ec-a5ea-7b6af84de5df', 'e706b869-a2ab-5f6a-bbc0-9ae91850043e', '891ebc92-8c18-5b7a-8d95-16932c0c6dff', '6ee1db43-0a97-564e-8e70-b9e62a54aa70', '431b438c-ed06-585a-8279-ce50dca147af', '97030cf3-2983-557d-a78b-c515a289d1d8', '0916f908-10cd-5c5a-b1c8-e228378782ec', 'e2dc42dd-103b-5dcd-b440-220cc821b0b8', '6dd51389-6b7b-5a95-998a-7089153573f1', '90c14001-7347-5d07-8fc5-1b69654f7e37', 'f07878c2-3aa6-59c7-a8d3-0c094c51d34b', '1dadd40a-d02b-5eb5-91ca-c07decb413b2', '863915cb-ac46-5b89-81d2-f46caed381d6', 'f5e1d19f-677b-5bb6-9f72-cd348b8f10a6', 'b7fd4fe8-766b-5abe-b6e0-ebda5cdcb51b', 'b5bb896b-7ace-5143-9598-74093ea23443', '26d70cc3-0eb7-57c6-880d-20c7d8cc7659', '1b4f940b-f5ee-52c9-89e0-07c484dba278', '13160121-5a28-5446-82e9-1c2319288b24', '9c4017cc-7a82-5e8c-af83-3f376baad912', '2d9263cc-3232-5773-b6a1-5d6f79d743ff', '87d216fb-f43a-5a1b-b623-e2b1e42d40b3', '2b9de268-c62a-5346-bce1-1d806f5accd2', '2acb401b-1062-512b-8858-3f887dcf7dd1', 'ca9f764f-6251-5e87-819d-bd4d18708bbd', 'db1de0c3-5414-5bbf-b11a-9400f348e1b7', '4f9aa716-95a6-5cac-bb00-766462a27af7', '475f3162-53e7-5959-ad5f-638a6dca4959', '73247af3-85b3-577c-a75e-0baeb09d2ad1', '87ae2b6e-47b7-5c0d-a841-08d329fb09d9', 'b1bfa687-6303-5625-9a0a-fb024e156dba', '06cf6271-dbea-5a07-b4db-d09b9e5edb26', '24d7c1a7-5101-51de-87d4-1760fa2cbcaa', '13e83993-71bb-554c-b652-bbf5c0bb88ae', '9cd46491-d26e-5755-b185-0ac3a7049582', 'fc7d242a-c0a5-5b8b-a25b-38d9c5cff240', 'e6241c3a-dc32-59c7-bed1-5cbe21d62ac9', '3f27e8c6-07e0-53c8-9982-68b12de63c74', '7dfef970-3a49-5389-8f94-c82d0017cfa7', '5ebb29ba-20da-547f-b6ca-f57c824a4676', '8130e195-ae33-534f-a784-42e3084621d9', '1a291177-9aa3-5ec7-9d5f-9678f35b7863', '6825685c-555f-501d-b6af-f69caa238a00', '499dc4ab-763b-5ccd-9d25-a2710aa43c36', '8a5c7527-a90e-5591-a284-5b2084d0bbcc', '36eba76c-9c7c-5534-842c-66f794b02988', '9a570eae-3dbf-57a9-a56f-84a918418d9f', '314c032f-2d36-585b-86c6-723ff6172c92', 'b4cfd316-b4f3-55b2-82a6-cfe347a53b94', '4554c0c9-744c-5e86-a493-ebb4724956f5', '1fbb6c15-9bb9-5377-9ecb-9215c9b27e0f', 'cbeca6e4-5284-5dea-b407-813ba3943818', '5c839926-b29d-54aa-8e15-c886614b0ee3', 'a7c74f82-3464-5e8e-af7d-2e2602c69c0c', '0cf56648-0495-5375-ad9f-691eb1bba319', '9f9e8daf-2460-55ec-ab66-93d14e029712', 'd4e9bdf5-81a4-53fb-b544-1130bb343731', 'c1662f91-3a03-56a3-8461-1cd8f5f01ab8', '9d2da62f-297d-56fd-a9be-66f7f29cecd0', '3e6dec99-ddfc-56ef-889d-d9986ac9dda5', '19152c92-32aa-537a-b3ae-0ede95e1fee9', 'af31b799-7456-5b03-807d-faa9bdfbeede', '4d61bfc7-433b-56eb-91dc-09efaa3efa01', '2571bfc7-51dd-5564-9bb7-177941ffcbed', '07bedab2-364f-50f2-9f8a-0c915a8212e4', 'a2ddf4b5-c725-5070-8654-a2613379644d', '5e14ab6a-e6d5-5d75-a0b8-ff750f8db2c5', '7e689ac4-4ef5-5810-8411-e783f1b7f92f', '8924dfc6-0ea3-5107-aaed-68f260a08ecc', 'a81df5bf-0dd2-57b5-9a94-07a798efbe84', '28a11ba1-53e7-5a4b-b4ec-a125322c9330', 'a9542377-7294-5a22-b249-691a7c484c22', '09e1a8d0-68ed-5a9e-9738-af8e41841e87', '44982a7b-fd3b-5dde-b7ff-87ab89b1c6a0', 'deb82226-91c4-52fb-b9f8-caa97f47e3c9', 'fe77f144-e1f6-5cbc-964c-ca8e9902268e', '074a7021-0c82-5462-8fca-8f52e4fc45be', 'a139fc07-8bf3-556c-9291-7eb6cad82d22', '1095b355-d884-52da-9417-0eea2805e295', 'f2b67856-e265-5b1b-8243-9905d4f9153f', 'a0a4af51-5bf8-5b95-9374-6c8a725bb5e1', '7ac7dd14-badd-58b0-8ef1-2fcc8705d14a', 'ec539215-7689-5e81-814a-a31147f4e693', 'b9d5d51e-2684-5a67-859c-303fca0092bf', 'aba16f54-30bb-51e8-8cad-d473f0e62f56', 'c7424a1c-0aca-5b08-9593-7e5f39ffb976', 'c13d3efe-8d56-56c3-a228-9f6cad07b2a0', '1c7020f5-ae32-52ef-8112-03bfb5d2ddc9', 'be6aa327-d4b5-520c-b04f-ed3ece04d821', 'b5a8a8a9-7b02-5356-bbbc-dcb645452669', 'def2cb5e-a743-5083-be68-f86fa31d7ad5', '8d47354b-6a7b-527c-8552-40cac821d0d7', '8594b6c3-7679-535c-865f-845437620145', '113c03f6-bd3b-5d41-8d97-13c83e19dbc5', '8deb5611-2b38-5b0f-9cfa-b2d05387f66b', '86b110c6-223b-574a-91d0-7ba1ff583af5');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-1ere' AND c.id NOT IN ('ffc18441-92a2-5f69-b05e-1ed2812a7633', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', '3ed5189a-ea41-530c-9617-e664af6f607e', 'e44362de-d055-5aaa-994a-65de62559675', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', 'الحواسّ الخمس', 'حواسّنا الخمس وأعضاؤها: البصر (العين)، السمع (الأذن)، الشمّ (الأنف)، الذوق (اللسان)، اللمس (الجلد واليدان)، وكيف نحافظ عليها', '# ⚔️ الحواسّ الخمس — نوافذي على العالم

> 💡 «بحواسّي أعرفُ كلّ شيءٍ حولي: أرى، وأسمع، وأشمّ، وأذوق، وألمس.»

عندي **خمس حواسّ**. بها أعرف ما حولي. لكلّ حاسّةٍ **عضوٌ** في جسمي. هيّا نتعرّف عليها.

انظر إلى الصورة: العين، والأذن، والأنف، واللسان في الوجه، واليد للمس.

<svg viewBox="0 0 260 200" xmlns="http://www.w3.org/2000/svg">
  <g fill="none" stroke="currentColor" stroke-width="2">
    <ellipse cx="110" cy="95" rx="60" ry="72" fill="#ffffff"/>
    <circle cx="88" cy="80" r="9" fill="#ffffff"/>
    <circle cx="132" cy="80" r="9" fill="#ffffff"/>
    <circle cx="88" cy="80" r="3" fill="currentColor" stroke="none"/>
    <circle cx="132" cy="80" r="3" fill="currentColor" stroke="none"/>
    <path d="M108 92 q6 12 0 22"/>
    <path d="M95 132 q15 12 30 0"/>
    <path d="M50 92 q-12 4 -10 18 q2 10 12 8"/>
  </g>
  <g fill="none" stroke="currentColor" stroke-width="2">
    <path d="M205 120 q-14 -2 -14 12 q0 14 14 16 l0 22 q14 -4 14 -30 q0 -22 -14 -32 z"/>
  </g>
  <g font-size="11" fill="currentColor" stroke="none">
    <text x="70" y="56">العين</text>
    <text x="22" y="118">الأذن</text>
    <text x="118" y="108">الأنف</text>
    <text x="100" y="158">اللسان</text>
    <text x="196" y="112">اليد</text>
  </g>
</svg>

## 👁️ البصر — العين

بـ**العين** أرى. أرى الألوان والأشكال والناس. عضو حاسّة البصر هو **العين**.

*مثال: أرى لون التفاحة الأحمر بعيني.*

## 👂 السمع — الأذن

بـ**الأذن** أسمع. أسمع الأصوات: العصفور، والموسيقى، وكلام أمّي. عضو حاسّة السمع هو **الأذن**.

*مثال: أسمع صوت الجرس بأذني.*

## 👃 الشمّ — الأنف

بـ**الأنف** أشمّ. أشمّ الروائح: رائحة الوردة، ورائحة الخبز. عضو حاسّة الشمّ هو **الأنف**.

*مثال: أشمّ رائحة الزهرة بأنفي.*

## 👅 الذوق — اللسان

بـ**اللسان** أذوق الطعام. أعرف طعمه: **حلوٌ** كالعسل، أو **مالحٌ** كالملح، أو **حامضٌ** كالليمون. عضو حاسّة الذوق هو **اللسان**.

*مثال: أعرف أنّ العسل حلوٌ بلساني.*

## ✋ اللمس — الجلد واليدان

بـ**جلدي** و**يديّ** ألمس الأشياء. أعرف الناعم والخشن، والحارّ والبارد. عضو حاسّة اللمس هو **الجلد**.

*مثال: ألمس الثلج بيدي فأعرف أنّه بارد.*

## 🛡️ أحافظ على حواسّي

أعضاء حواسّي غالية، فأحافظ عليها:

- لا أنظر إلى الشمس مباشرة.
- لا أُدخل أشياء في أذني.
- أغسل يديّ ووجهي دائمًا.

> ⚠️ الفخّ الشائع: لا تخلط بين **الحاسّة** و**العضو**. الحاسّة هي ما أفعله (الشمّ)، والعضو هو الجزء من جسمي (الأنف). ولا تخلط بين الشمّ والذوق: الشمّ بالأنف، والذوق باللسان.

> 🏆 أحسنت! صرتَ تعرف حواسّك الخمس، وعضو كلّ حاسّة، وكيف تحافظ عليها. أنت بطل الحواسّ!', '# 📜 ملخّص: الحواسّ الخمس

- **عندي خمس حواسّ**، ولكلّ حاسّةٍ عضوٌ في جسمي.
- **البصر:** أرى به الألوان والأشكال، وعضوه **العين**.
- **السمع:** أسمع به الأصوات، وعضوه **الأذن**.
- **الشمّ:** أشمّ به الروائح، وعضوه **الأنف**.
- **الذوق:** أعرف به طعم الطعام (حلو، مالح، حامض)، وعضوه **اللسان**.
- **اللمس:** أعرف به الناعم والخشن والحارّ والبارد، وعضوه **الجلد واليدان**.
- **أحافظ على حواسّي:** لا أنظر إلى الشمس، ولا أُدخل أشياء في أذني، وأغسل يديّ ووجهي.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', 'التغذية', 'نتعرّف على أهمّ الأغذية التي نأكلها، ولماذا نأكل طعامًا متنوّعًا لينمو جسمنا، وقواعد النظافة عند الأكل', '# ⚔️ التغذية — طعامٌ يجعلني قويًّا

> 💡 «آكلُ جيّدًا، فأكبرُ وألعبُ وأبقى في صحّة.»

كلُّ يومٍ نأكلُ ونشربُ. الطعامُ يعطي جسمَنا **قوّةً**، ويساعدُه على **النموّ**. لكي نبقى أصحّاء نأكلُ **طعامًا متنوّعًا**، ونغسلُ أيدينا قبلَ الأكل.

## 🍽️ لماذا نأكل؟

نأكلُ لأنّ الطعامَ يعطينا **قوّةً** لنلعبَ ونتعلّم.
والطعامُ يساعدُ جسمَنا على **النموّ** فنكبر.
عندما نجوعُ نشعرُ بالتعب، لذلك نأكلُ في كلِّ يوم.

## 🥗 ماذا نأكل؟

نأكلُ أنواعًا كثيرةً من الطعام:

- **الخبزُ** يعطي قوّة.
- **الحليبُ** مفيدٌ للعظامِ والأسنان.
- **اللحمُ والسمكُ والبيضُ** تساعدُ على النموّ.
- **الخضرُ والغلالُ** (مثلَ الطماطم والتفّاح) مفيدةٌ للجسم.
- **الماءُ** نشربُه كلَّ يوم.

## 🌈 نأكلُ طعامًا متنوّعًا

لا نأكلُ نوعًا واحدًا فقط.
نأكلُ **من كلِّ نوعٍ قليلًا**: خبزًا وخضرًا وفاكهةً وحليبًا.
هكذا يأخذُ جسمُنا كلَّ ما يحتاجُه لينمو ويبقى قويًّا.

هذا صحنٌ متنوّع وصحّي:

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
  <circle cx="60" cy="60" r="50" fill="none" stroke="#1f2937" stroke-width="3"/>
  <circle cx="60" cy="60" r="38" fill="none" stroke="#1f2937" stroke-width="1.5"/>
  <line x1="60" y1="22" x2="60" y2="98" stroke="#1f2937" stroke-width="1.5"/>
  <line x1="22" y1="60" x2="98" y2="60" stroke="#1f2937" stroke-width="1.5"/>
  <circle cx="44" cy="44" r="7" fill="#1f2937"/>
  <rect x="68" y="38" width="16" height="10" rx="2" fill="#1f2937"/>
  <path d="M40 74 l8 -12 l8 12 z" fill="#1f2937"/>
  <circle cx="76" cy="76" r="7" fill="none" stroke="#1f2937" stroke-width="2"/>
</svg>

## 🧼 نظافةُ الأكل

قبلَ الأكل وبعدَه نتّبعُ قواعدَ مهمّة:

- **نغسلُ أيدينا بالماءِ والصابون** قبلَ الأكل.
- **نغسلُ الفواكهَ والخضرَ** قبلَ أكلِها.
- **لا نُكثرُ من الحلويات**؛ فهي تضرُّ الأسنان.

> ⚠️ الفخّ الشائع: الظنُّ أنّ الحلوى «طعامٌ جيّد لأنّها لذيذة». اللذيذُ ليس دائمًا مفيدًا؛ الأفضلُ أن نأكلَ الخضرَ والفاكهةَ ونقلّلَ من الحلوى.

> 🏆 رائع! صرتَ تعرفُ كيف تختارُ طعامًا متنوّعًا، وكيف تغسلُ يديكَ، لتبقى قويًّا وفي صحّة.', '# 📜 ملخّص: التغذية

- **لماذا نأكل:** الطعامُ يعطينا قوّةً ويساعدُ جسمَنا على النموّ.
- **ماذا نأكل:** الخبز، الحليب، اللحم والسمك والبيض، الخضر والغلال، والماء.
- **طعامٌ متنوّع:** نأكلُ من كلِّ نوعٍ قليلًا لينمو الجسمُ ويبقى قويًّا.
- **النظافة:** نغسلُ أيدينا قبلَ الأكل، ونغسلُ الفواكهَ والخضر.
- **الحلويات:** لا نُكثرُ منها لأنّها تضرُّ الأسنان.
- **القاعدة:** الطعامُ اللذيذ ليس دائمًا مفيدًا؛ نأكلُ الخضرَ والفاكهة.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', 'النموّ', 'الكائنات الحيّة تنمو وتكبر مع الوقت: نموّ الإنسان (رضيع ← طفل ← شابّ ← كهل)، ونموّ الحيوان (صغير ← بالغ)، ونموّ النبات (بذرة ← نبتة)، والتمييز بين ما ينمو وما لا ينمو', '# ⚔️ النموّ — كلّ كائنٍ حيٍّ يكبر

> 💡 «كنتَ صغيرًا فصرتَ أكبر: هكذا تنمو كلّ الكائنات الحيّة.»

أنت تعرف أنّك كنتَ **رضيعًا صغيرًا**، والآن صرتَ طفلًا أكبر. هذا هو **النموّ**: الكائن الحيّ يكبر مع الوقت. في هذا الدرس نتعلّم كيف ينمو الإنسان والحيوان والنبات، ونميّز بين ما ينمو وما لا ينمو.

## 🌱 الكائن الحيّ ينمو

**الكائن الحيّ** هو ما يأكل ويكبر، مثل الإنسان والحيوان والنبات.

كلّ كائنٍ حيّ **ينمو**: أي يكبر شيئًا فشيئًا مع مرور الوقت. هو لا يبقى صغيرًا دائمًا، بل **يزداد طوله ويزداد وزنه**.

أمّا **الجماد** مثل الحجر والكرسيّ والكأس فهو **لا ينمو**: يبقى كما هو، لا يكبر ولا يأكل.

## 👶 كيف ينمو الإنسان؟

ينمو الإنسان على مراحل، من الأصغر إلى الأكبر:

| المرحلة | الوصف |
| --- | --- |
| **رضيع** | صغيرٌ جدًّا، يشرب الحليب |
| **طفل** | يمشي ويلعب ويذهب إلى المدرسة |
| **شابّ** | كبر وصار قويًّا |
| **كهل** | كبر في السنّ |

كلّما كبر الإنسان **زاد طوله وزاد وزنه**. وهذه صورة تبيّن نموّ الإنسان من الأصغر إلى الأكبر:

<svg viewBox="0 0 320 120" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="105" x2="310" y2="105" stroke="#1f2937" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2" fill="none">
    <circle cx="45" cy="88" r="7"/>
    <line x1="45" y1="95" x2="45" y2="104"/>
    <circle cx="120" cy="72" r="9"/>
    <line x1="120" y1="81" x2="120" y2="104"/>
    <circle cx="200" cy="55" r="11"/>
    <line x1="200" y1="66" x2="200" y2="104"/>
    <circle cx="285" cy="42" r="12"/>
    <line x1="285" y1="54" x2="285" y2="104"/>
  </g>
  <polyline points="20,100 300,30" stroke="#1f2937" stroke-width="1" fill="none" stroke-dasharray="4 4"/>
</svg>

## 🐤 كيف ينمو الحيوان؟

الحيوان أيضًا **يولد صغيرًا ثمّ يكبر** ويصير **بالغًا** مثل أبيه وأمّه:

- **الكتكوت** الصغير يكبر فيصير **دجاجة**.
- **العجل** الصغير يكبر فيصير **بقرة**.
- **الجَرْو** الصغير يكبر فيصير **كلبًا**.

فالصغير يشبه الكبير، لكنّه يكبر مع الوقت في الطول والوزن.

## 🌳 كيف ينمو النبات؟

النبات كائنٌ حيّ، وهو أيضًا ينمو. تبدأ حياته من **بذرة** صغيرة:

نضع **البذرة** في التربة ونسقيها بالماء، فتنبت **نبتة صغيرة** وتطلع لها **أوراق**، ثمّ تكبر شيئًا فشيئًا حتّى تصير **نبتة كبيرة**.

<svg viewBox="0 0 300 110" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="92" x2="290" y2="92" stroke="#1f2937" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2" fill="none">
    <ellipse cx="50" cy="84" rx="9" ry="6"/>
    <line x1="150" y1="92" x2="150" y2="68"/>
    <path d="M150 74 q-10 -6 -16 -2"/>
    <path d="M150 70 q10 -6 16 -2"/>
    <line x1="250" y1="92" x2="250" y2="38"/>
    <path d="M250 60 q-16 -8 -26 -2"/>
    <path d="M250 54 q16 -8 26 -2"/>
    <path d="M250 46 q-12 -8 -20 -3"/>
    <circle cx="250" cy="34" r="7"/>
  </g>
</svg>

> 🗡️ تذكّر الترتيب الصحيح للنبات: **بذرة ← نبتة صغيرة ← نبتة كبيرة**. هكذا يكبر النبات، خطوةً بعد خطوة.

## 🪨 ما ينمو وما لا ينمو

نميّز بسهولة:

- **ينمو** (كائن حيّ): الإنسان، الحيوان، النبات.
- **لا ينمو** (جماد): الحجر، الكرسيّ، السيّارة، اللعبة.

الحجر يبقى حجرًا ولا يكبر، أمّا الشجرة فتكبر لأنّها حيّة.

> ⚠️ الفخّ الشائع: الظنّ أنّ الكبير يصير صغيرًا. الصحيح أنّ النموّ يكون **من الصغير إلى الكبير**: الرضيع يصير طفلًا، والبذرة تصير نبتة، لا العكس.

> 🏆 ممتاز! صرتَ تعرف أنّ كلّ كائنٍ حيٍّ ينمو، وكيف يكبر الإنسان والحيوان والنبات. في الفصل القادم نكتشف أشياء جديدة من حولنا.', '# 📜 ملخّص: النموّ

- **النموّ:** كلّ كائنٍ حيٍّ يكبر مع الوقت، يزداد طوله ووزنه.
- **الكائن الحيّ ينمو، والجماد لا ينمو:** الإنسان والحيوان والنبات يكبرون، أمّا الحجر والكرسيّ فيبقيان كما هما.
- **نموّ الإنسان:** رضيع ← طفل ← شابّ ← كهل، ويزداد طوله ووزنه.
- **نموّ الحيوان:** يولد صغيرًا ثمّ يكبر ويصير بالغًا (الكتكوت ← دجاجة، العجل ← بقرة).
- **نموّ النبات:** بذرة ← نبتة صغيرة (تطلع لها أوراق) ← نبتة كبيرة.
- **الفخّ الشائع:** النموّ من الصغير إلى الكبير، لا العكس.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', 'تنقّل الحيوانات', 'نتعرّف كيف تتنقّل الحيوانات: الطيران، والسباحة، والزحف، والمشي والقفز، ونصنّفها حسب طريقة تنقّلها.', '# ⚔️ تنقّل الحيوانات — كلٌّ يمشي على طريقته

> 💡 «العصفور يطير، والسمكة تسبح، والأرنب يقفز… كلّ حيوانٍ يتنقّل بطريقته!»

الحيوانات تتحرّك من مكانٍ إلى مكان. هذا اسمه **التنقّل**. لكنّها لا تتنقّل كلّها بنفس الطريقة. هيّا نتعرّف على طُرُق التنقّل.

## 🐦 الطيران

بعض الحيوانات **تطير** في الهواء. تستعمل **أجنحتها**. مثل: **العصفور** و**الحمامة**.

انظر: للطائر جناحان يطير بهما.

<svg viewBox="0 0 120 90" xmlns="http://www.w3.org/2000/svg">
  <g stroke="currentColor" stroke-width="2" fill="#e5e7eb">
    <ellipse cx="62" cy="55" rx="26" ry="14"/>
    <circle cx="88" cy="46" r="11"/>
    <path d="M97 44 l12 -3 l-11 7 z" fill="currentColor" stroke="none"/>
    <circle cx="90" cy="44" r="2" fill="currentColor" stroke="none"/>
    <path d="M50 50 q-22 -28 -34 -16 q14 6 30 22 z"/>
    <path d="M44 62 l-10 16 M58 64 l-4 18"/>
  </g>
</svg>

*مثال: العصفور يطير فوق الشجرة بجناحيه.*

## 🐟 السباحة

بعض الحيوانات **تسبح** في الماء. مثل: **السمكة**. تعيش في الماء وتتنقّل فيه بالسباحة.

انظر: السمكة لها ذيلٌ وزعانف تسبح بها.

<svg viewBox="0 0 120 80" xmlns="http://www.w3.org/2000/svg">
  <g stroke="currentColor" stroke-width="2" fill="#e5e7eb">
    <path d="M30 40 q26 -22 56 0 q-26 22 -56 0 z"/>
    <path d="M30 40 l-16 -12 l0 24 z"/>
    <path d="M58 22 q6 8 0 14 M58 44 q6 8 0 14" fill="none"/>
    <circle cx="78" cy="36" r="2.5" fill="currentColor" stroke="none"/>
  </g>
  <line x1="10" y1="68" x2="112" y2="68" stroke="currentColor" stroke-width="2" stroke-dasharray="5 5"/>
</svg>

*مثال: السمكة تسبح في الماء طوال اليوم.*

## 🐍 الزحف

بعض الحيوانات **تزحف**. تزحف على **بطنها** قريبًا من الأرض. مثل: **الثعبان** (الحيّة) و**الحلزون**.

انظر: الثعبان طويلٌ ولا أرجل له، يزحف على بطنه.

<svg viewBox="0 0 130 70" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 50 q18 -26 36 0 q18 26 36 0 q12 -18 28 -8" fill="none" stroke="currentColor" stroke-width="6" stroke-linecap="round"/>
  <circle cx="116" cy="36" r="2" fill="currentColor" stroke="none"/>
</svg>

*مثال: الثعبان يزحف على الأرض بين الأعشاب.*

## 🐇 المشي والقفز

كثيرٌ من الحيوانات تتنقّل **بأرجلها**: تمشي، أو تجري، أو **تقفز**. مثل: **الأرنب** (يقفز)، و**القطّ** و**الحصان** (يمشيان ويجريان).

انظر: للأرنب أربع أرجل، يقفز بها.

<svg viewBox="0 0 110 100" xmlns="http://www.w3.org/2000/svg">
  <g stroke="currentColor" stroke-width="2" fill="#e5e7eb">
    <ellipse cx="55" cy="62" rx="24" ry="18"/>
    <circle cx="78" cy="46" r="12"/>
    <path d="M72 36 q-4 -22 4 -22 q6 6 4 24 z"/>
    <path d="M82 36 q4 -20 11 -18 q3 8 -5 22 z"/>
    <circle cx="82" cy="46" r="2" fill="currentColor" stroke="none"/>
    <path d="M40 78 q-6 10 2 12 M58 80 q-2 10 6 10" fill="none"/>
  </g>
</svg>

*مثال: الأرنب يقفز في الحديقة بأرجله.*

## 🦆 حيوانات تتنقّل بأكثر من طريقة

بعض الحيوانات تتنقّل **بأكثر من طريقة**! مثل **البطّة**:

| الحيوان | كيف يتنقّل؟ |
| --- | --- |
| البطّة | **تمشي** على الأرض، و**تسبح** في الماء، و**تطير** أيضًا |

فالبطّة تجمع بين ثلاث طرق: المشي والسباحة والطيران.

> 🗡️ حِيلة سريعة: انظر **أين يعيش** الحيوان و**ما في جسمه**. أجنحة ← يطير. في الماء ← يسبح. لا أرجل ويزحف على بطنه ← يزحف. أرجلٌ يمشي بها ← يمشي ويقفز.

> ⚠️ الفخّ الشائع: لا تخلط بين الطُرُق! السمكة **تسبح** ولا تطير، والثعبان **يزحف** ولا يمشي. وتذكّر أنّ بعض الحيوانات مثل البطّة تتنقّل بأكثر من طريقة.

> 🏆 أحسنت! صرتَ تعرف كيف تتنقّل الحيوانات: الطيران، والسباحة، والزحف، والمشي والقفز. أنت بطل عالم الحيوان!', '# 📜 ملخّص: تنقّل الحيوانات

- **التنقّل:** انتقال الحيوان من مكانٍ إلى مكان؛ ولكلّ حيوانٍ طريقته.
- **الطيران:** بالأجنحة في الهواء، مثل العصفور والحمامة.
- **السباحة:** في الماء، مثل السمكة.
- **الزحف:** على البطن قريبًا من الأرض، مثل الثعبان والحلزون.
- **المشي والقفز:** بالأرجل، مثل الأرنب (يقفز) والقطّ والحصان (يمشيان).
- **أكثر من طريقة:** بعض الحيوانات تجمع بين طرق، مثل البطّة (تمشي وتسبح وتطير).
- **القاعدة:** ننظر إلى مكان العيش وجسم الحيوان لنعرف كيف يتنقّل.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', 'التنفّس', 'كيف نتنفّس: ندخل الهواء (شهيق) ونخرجه (زفير) عبر الأنف، والصدر يرتفع وينخفض، وتتغيّر سرعة التنفّس في الراحة وبعد الجري، والحيوانات تتنفّس أيضًا', '# ⚔️ التنفّس — نفَسُ الحياة

> 💡 «أتنفّسُ في كلّ لحظة: أُدخِل الهواء وأُخرِجه، فأبقى حيًّا ونشيطًا.»

أنت تعرف أنفك من درس الحواسّ. اليوم نتعلّم أنّ الأنف يساعدنا أيضًا على **التنفّس**. نحن نتنفّس دائمًا: في النوم، وفي اللعب، وفي كلّ لحظة. لنكتشف كيف.

## 🌬️ الشهيق والزفير

نحن **نتنفّس** عن طريق **الأنف**. التنفّس مرّتان:

- **الشهيق:** نُدخِل الهواء إلى داخل الجسم.
- **الزفير:** نُخرِج الهواء إلى الخارج.

*مثال:* ضع يدك أمام أنفك. عند الزفير تحسّ بالهواء يخرج دافئًا.

## 🫁 الصدر يرتفع وينخفض

عندما نتنفّس، يتحرّك **الصدر**:

- في **الشهيق** يمتلئ الصدر بالهواء و**يرتفع** (ينتفخ).
- في **الزفير** يخرج الهواء و**ينخفض** الصدر (يعود صغيرًا).

ضع يدك على صدرك وتنفّس: تحسّ به يرتفع وينخفض.

<svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg">
  <text x="50" y="16" font-size="11" fill="#1f2937" text-anchor="middle">شهيق</text>
  <ellipse cx="50" cy="70" rx="34" ry="38" fill="none" stroke="#1f2937" stroke-width="2.5"/>
  <polyline points="50,30 44,40 56,40 50,30" fill="#1f2937" stroke="#1f2937" stroke-width="1.5"/>
  <line x1="50" y1="40" x2="50" y2="26" stroke="#1f2937" stroke-width="2"/>
  <text x="150" y="16" font-size="11" fill="#1f2937" text-anchor="middle">زفير</text>
  <ellipse cx="150" cy="80" rx="28" ry="26" fill="none" stroke="#1f2937" stroke-width="2.5"/>
  <polyline points="150,108 144,98 156,98 150,108" fill="#1f2937" stroke="#1f2937" stroke-width="1.5"/>
  <line x1="150" y1="98" x2="150" y2="112" stroke="#1f2937" stroke-width="2"/>
</svg>

## 🏃 سرعة التنفّس تتغيّر

سرعة التنفّس لا تبقى نفسها دائمًا:

- في **الراحة** (الجلوس أو النوم): نتنفّس **بهدوء وببطء**.
- بعد **الجري واللعب**: نتنفّس **بسرعة** ونلهث، لأنّ جسمنا يحتاج هواءً أكثر.

*مثال:* بعد أن تجري في الملعب، تحسّ بصدرك يرتفع وينخفض بسرعة.

## 🐾 الحيوانات تتنفّس أيضًا

ليس الإنسان وحده من يتنفّس. **الحيوانات تتنفّس أيضًا** لتبقى حيّة: القطّ، والعصفور، والأرنب، وكلّ الحيوانات تحتاج إلى الهواء مثلنا.

## 🌳 نحبّ الهواء النقيّ

نتنفّس لنبقى أحياء، لذلك نحبّ **الهواء النقيّ** (النظيف):

- نلعب في الهواء الطلق وبين الأشجار.
- نفتح النافذة ليدخل الهواء النظيف.

> ⚠️ الفخّ الشائع: لا تخلط بين **الشهيق** و**الزفير**. الشهيق = الهواء **يدخل** والصدر **يرتفع**. الزفير = الهواء **يخرج** والصدر **ينخفض**.

> 🏆 أحسنت! صرت تعرف كيف تتنفّس بالشهيق والزفير، وأنّ صدرك يرتفع وينخفض، وأنّ الحيوانات تتنفّس مثلك.', '# 📜 ملخّص: التنفّس

- **نتنفّس عن طريق الأنف**، ونحن نتنفّس دائمًا لنبقى أحياء.
- **الشهيق:** نُدخِل الهواء إلى داخل الجسم.
- **الزفير:** نُخرِج الهواء إلى الخارج.
- **الصدر يتحرّك:** يرتفع في الشهيق، وينخفض في الزفير.
- **سرعة التنفّس تتغيّر:** بهدوء في الراحة، وبسرعة بعد الجري واللعب.
- **الحيوانات تتنفّس أيضًا** وتحتاج إلى الهواء مثلنا.
- **نحبّ الهواء النقيّ** ونلعب في الهواء الطلق.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', 'الفضاء: المواقع والمقارنات', 'نتعلّم تعيين موقع الشيء بالنسبة إلى شيءٍ آخر: فوق/تحت، أمام/خلف، يمين/يسار، قرب/بعد، داخل/خارج، ونقارن بين الأشياء: أكبر/أصغر، أطول/أقصر، أعلى/أوطأ، ونصف موقع الأشياء في صورة', '# ⚔️ الفضاء: المواقع والمقارنات — أين الشيء؟ ومن الأكبر؟

> 💡 «الكرة فوق الطاولة أم تحتها؟ القطّ كبيرٌ أم صغير؟ تعلّم أين توجد الأشياء وكيف نقارنها.»

أنت تعرف مكانك جيّدًا: القلم **فوق** المكتب، والحقيبة **تحت** الكرسيّ. في هذا الدرس نتعلّم كيف نقول **أين** يوجد الشيء بالنسبة إلى شيءٍ آخر، وكيف **نقارن** بين الأشياء: من الأكبر؟ من الأطول؟

## ⬆️ فوق وتحت

نقول أين الشيء بالنسبة إلى شيءٍ آخر. **فوق** تعني في الأعلى، و**تحت** تعني في الأسفل.

في الصورة: الكرة **فوق** الصندوق، والنجمة **تحت** الصندوق.

<svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg">
  <circle cx="60" cy="22" r="14" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <rect x="38" y="52" width="44" height="30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <polygon points="60,98 66,112 80,112 69,121 73,124 60,116 47,124 51,121 40,112 54,112" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
</svg>

## ⬅️ يمين ويسار

يدُك **اليمين** ويدُك **اليسار**. الشيء يكون على اليمين أو على اليسار.

في الصورة: المثلّث على **اليسار**، والقلب على **اليمين**.

<svg viewBox="0 0 160 80" xmlns="http://www.w3.org/2000/svg">
  <polygon points="35,58 20,30 50,30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <path d="M125 30 q-12 -14 -22 0 q-10 12 22 28 q32 -16 22 -28 q-10 -14 -22 0 z" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
</svg>

> 🗡️ تذكّر: عندما تكتب بيدك، تلك هي يدك **اليمين**. اليمين جهة، واليسار الجهة الأخرى.

## ➡️ أمام وخلف

**أمام** تعني في المقدّمة، و**خلف** تعني في الوراء. الطفل يمشي والكلب **خلفه**.

في الصورة: الدائرة الكبيرة في **الأمام**، والمربّع **خلفها**.

<svg viewBox="0 0 140 90" xmlns="http://www.w3.org/2000/svg">
  <rect x="58" y="14" width="44" height="44" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <circle cx="50" cy="56" r="26" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/>
</svg>

## 🎯 قرب وبعد

**قرب** تعني قريبٌ جدًّا، و**بعد** تعني بعيد. البيت قريبٌ منك، والجبل بعيد.

في الصورة: النجمة الصغيرة **قرب** المنزل، والنجمة الأخرى **بعيدة** عنه.

<svg viewBox="0 0 200 70" xmlns="http://www.w3.org/2000/svg">
  <rect x="20" y="30" width="34" height="28" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <polygon points="37,12 54,30 20,30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <circle cx="70" cy="44" r="6" stroke="#1f2937" stroke-width="2" fill="#1f2937"/>
  <circle cx="180" cy="44" r="6" stroke="#1f2937" stroke-width="2" fill="#1f2937"/>
</svg>

## 📦 داخل وخارج

**داخل** تعني في الدّاخل، و**خارج** تعني في الخارج. السمكة **داخل** الحوض، والقطّ **خارجه**.

في الصورة: الدائرة السوداء **داخل** الصندوق، والدائرة الأخرى **خارجه**.

<svg viewBox="0 0 170 80" xmlns="http://www.w3.org/2000/svg">
  <rect x="20" y="20" width="60" height="50" stroke="#1f2937" stroke-width="2" fill="none"/>
  <circle cx="50" cy="45" r="11" stroke="#1f2937" stroke-width="2" fill="#1f2937"/>
  <circle cx="135" cy="45" r="11" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/>
</svg>

## 🔍 نقارن: أكبر وأصغر، أطول وأقصر

نقارن بين شيئين: أيّهما **أكبر** وأيّهما **أصغر**؟ أيّهما **أطول** وأيّهما **أقصر**؟

في هذه الصورة: الدائرة على اليسار **أكبر**، والدائرة على اليمين **أصغر**.

<svg viewBox="0 0 160 80" xmlns="http://www.w3.org/2000/svg">
  <circle cx="45" cy="40" r="30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <circle cx="125" cy="48" r="14" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
</svg>

وفي هذه الصورة: العمود على اليسار **أطول** (وهو **أعلى**)، والعمود على اليمين **أقصر** (وهو **أوطأ**).

<svg viewBox="0 0 140 100" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="90" x2="130" y2="90" stroke="#1f2937" stroke-width="2"/>
  <rect x="35" y="20" width="22" height="70" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
  <rect x="90" y="58" width="22" height="32" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/>
</svg>

نقول كذلك **أعلى** للأطول و**أوطأ** للأقصر عندما يقفان على الأرض.

> ⚠️ الفخّ الشائع: الخلط بين الكلمات المتعاكسة. **فوق** عكس **تحت**، و**يمين** عكس **يسار**، و**أكبر** عكس **أصغر**. تأمّل الصورة جيّدًا قبل أن تجيب.

> 🏆 رائع! صرتَ تعرف كيف تقول أين يوجد الشيء (فوق، تحت، يمين، يسار، أمام، خلف، قرب، بعد، داخل، خارج)، وكيف تقارن (أكبر، أصغر، أطول، أقصر). في الفصل القادم نكتشف أشياء جديدة.', '# 📜 ملخّص: الفضاء

- **فوق وتحت:** فوق في الأعلى، وتحت في الأسفل.
- **يمين ويسار:** اليمين جهة يدك التي تكتب بها، واليسار الجهة الأخرى.
- **أمام وخلف:** أمام في المقدّمة، وخلف في الوراء.
- **قرب وبعد:** قرب أي قريب، وبعد أي بعيد.
- **داخل وخارج:** داخل في الدّاخل، وخارج في الخارج.
- **المقارنة:** نقارن بين شيئين: أكبر/أصغر، أطول/أقصر، أعلى/أوطأ.
- **الفخّ الشائع:** لا تخلط بين المتعاكسات (فوق↔تحت، يمين↔يسار، أكبر↔أصغر)؛ تأمّل الصورة جيّدًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', 'الزمن: اليوم والأسبوع', 'نتعرّف على النهار والليل، ولحظات اليوم وأنشطته بالترتيب، وأنّ اليوم وحدة زمنية، وأيّام الأسبوع السبعة وترتيبها، ونميّز المدّة الطويلة من القصيرة.', '# ⚔️ الزمن — رحلةُ اليوم والأسبوع

> 💡 «بعد النهار يأتي الليل، وبعد يومٍ يأتي يوم: هكذا يمرّ الزمن.»

أنت تعرف أنّك تستيقظ في الصباح وتنام في الليل. الوقت يمرّ دائمًا: نهارٌ ثمّ ليل، ويومٌ بعد يوم. في هذا الدرس نتعرّف على **النهار والليل**، وعلى **لحظات اليوم** و**أنشطته** بالترتيب، وعلى **أيّام الأسبوع**، ونميّز المدّة الطويلة من القصيرة.

## ☀️ النهار والليل

في **النهار** تكون **الشمس** في السماء، فيصير الجوّ مضيئًا. نلعب ونذهب إلى المدرسة.

في **الليل** تغيب الشمس ويصير الجوّ **مظلمًا**، ويظهر **القمر** والنجوم. في الليل ننام.

<svg viewBox="0 0 300 110" xmlns="http://www.w3.org/2000/svg">
  <line x1="10" y1="92" x2="290" y2="92" stroke="#1f2937" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2" fill="none">
    <circle cx="80" cy="45" r="16"/>
    <line x1="80" y1="18" x2="80" y2="10"/>
    <line x1="80" y1="72" x2="80" y2="80"/>
    <line x1="53" y1="45" x2="45" y2="45"/>
    <line x1="107" y1="45" x2="115" y2="45"/>
    <line x1="61" y1="26" x2="55" y2="20"/>
    <line x1="99" y1="26" x2="105" y2="20"/>
    <path d="M232 30 a18 18 0 1 0 14 33 a14 14 0 0 1 -14 -33 z"/>
  </g>
</svg>

النهار للشمس، والليل للقمر والظلام.

## 🕗 لحظات اليوم بالترتيب

ينقسم اليوم إلى لحظات تأتي **واحدةً بعد الأخرى** بهذا الترتيب:

| اللحظة | متى |
| --- | --- |
| **الصباح** | أوّل النهار، نستيقظ |
| **الظهر** | وسط النهار، نأكل الغداء |
| **المساء** | آخر النهار، تغيب الشمس |
| **الليل** | يصير الجوّ مظلمًا، ننام |

الترتيب الثابت هو: **الصباح ← الظهر ← المساء ← الليل**.

## 🧒 أنشطة اليوم بالترتيب

في كلّ يومٍ نقوم بأعمالٍ بترتيب: أوّلًا **نستيقظ** في الصباح، ثمّ **نذهب إلى المدرسة**، ثمّ **نأكل**، وفي آخر اليوم **ننام**.

> 🗡️ تذكّر: أوّلًا نستيقظ وآخرًا ننام. لا ننام أوّلًا ثمّ نستيقظ في نفس اليوم!

## 📅 اليوم وحدة زمنية

**اليوم** وحدةٌ نقيس بها الزمن. يبدأ اليوم في الصباح وينتهي في الليل، وبعده يأتي **يومٌ جديد**.

نعدّ الأيّام: اليوم، ثمّ غدًا، ثمّ بعد غد. كلّ يومٍ يأتي بعد الذي قبله.

## 🗓️ أيّام الأسبوع السبعة

يتكوّن **الأسبوع** من **7 أيّام** تأتي بالترتيب:

| الترتيب | اليوم |
| --- | --- |
| 1 | **الاثنين** |
| 2 | **الثلاثاء** |
| 3 | **الأربعاء** |
| 4 | **الخميس** |
| 5 | **الجمعة** |
| 6 | **السبت** |
| 7 | **الأحد** |

بعد الأحد يبدأ أسبوعٌ جديد بالاثنين من جديد. عددها دائمًا **7 أيّام**.

## ⏳ المدّة: طويلة أم قصيرة

بعض الأعمال تدوم **وقتًا طويلًا**، وبعضها يدوم **وقتًا قصيرًا**.

- **مدّة قصيرة:** نغمض أعيننا، نصفّق بأيدينا.
- **مدّة طويلة:** يومٌ كامل، أسبوعٌ كامل، النوم في الليل.

النوم ليلةً كاملة **أطول** من تصفيقةٍ واحدة.

> ⚠️ الفخّ الشائع: الخلط بين ترتيب اللحظات. الصحيح أنّ **الصباح أوّلًا ثمّ الظهر ثمّ المساء ثمّ الليل**، ونستيقظ قبل أن ننام، لا العكس.

> 🏆 ممتاز! صرتَ تعرف النهار والليل، ولحظات اليوم وأنشطته بالترتيب، وأيّام الأسبوع السبعة، وتميّز المدّة الطويلة من القصيرة. في الفصل القادم نكتشف أشياء جديدة.', '# 📜 ملخّص: الزمن

- **النهار والليل:** في النهار شمسٌ وضياء، وفي الليل قمرٌ وظلامٌ وننام.
- **لحظات اليوم بالترتيب:** الصباح ← الظهر ← المساء ← الليل.
- **أنشطة اليوم بالترتيب:** نستيقظ ← نذهب إلى المدرسة ← نأكل ← ننام.
- **اليوم وحدة زمنية:** يبدأ صباحًا وينتهي ليلًا، وبعده يأتي يومٌ جديد.
- **أيّام الأسبوع:** 7 أيّام بالترتيب: الاثنين، الثلاثاء، الأربعاء، الخميس، الجمعة، السبت، الأحد.
- **المدّة:** قصيرة (تصفيقة، إغماض العين) أو طويلة (يوم كامل، أسبوع، نوم الليل).
- **القاعدة:** الزمن يمرّ بترتيب ثابت؛ نستيقظ قبل أن ننام، والصباح قبل الليل.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', 'المادّة وخصائصها', 'نتعرّف على خصائص الأشياء حولنا: الشكل واللون والملمس والحالة (صلب أو سائل)، ونصنّفها حسب كلّ خاصّية.', '# ⚔️ المادّة وخصائصها — مستكشفُ الأشياء

> 💡 «كلّ شيءٍ حولك له شكلٌ ولونٌ وملمس: انظر، والمس، واكتشف!»

كلّ الأشياء من حولك مصنوعةٌ من **مادّة**: الكرسيّ، والكوب، والماء، والحجر. ولكلّ شيءٍ **خصائص** تميّزه: شكله، ولونه، وملمسه، وهل هو صلبٌ أم سائل. تعالَ نتعلّم كيف ننظر إلى الأشياء ونصنّفها.

## 🔷 الشكل

لكلّ شيءٍ **شكل**. بعض الأشكال مألوفة:

- **المكعّب:** مثل حبّة النرد وعلبة صغيرة.
- **الكرة:** مثل كرة القدم والبرتقالة.
- **الأسطوانة:** مثل العلبة والقلم.

نتعرّف على الشكل بحاسّة **البصر** (العين).

## 🎨 اللون

لكلّ شيءٍ **لون**: الموزة **صفراء**، والعشب **أخضر**، والسماء **زرقاء**، والفحم **أسود**. نعرف اللون بالعين أيضًا. ويمكن أن نصنّف الأشياء حسب لونها: كلّ الأشياء الحمراء معًا، وكلّ الزرقاء معًا.

## ✋ الملمس

الملمس هو ما نحسّ به عندما **نلمس** الشيء بيدنا (الجلد):

- **أملس:** ناعمٌ تحت اليد، مثل الزجاج والمرآة.
- **خشن:** فيه نتوءاتٌ تحت اليد، مثل الحجر وورق الصنفرة.
- **صلب:** قاسٍ لا ينضغط، مثل الخشب والحجر.
- **ليّن:** طريٌّ ينضغط بسهولة، مثل الإسفنج والعجين.

## 🧊 الحالة: صلب أم سائل

نرى المادّة في حالتين بسيطتين:

- **الصلب:** له شكلٌ ثابت، نمسكه بيدنا. *مثل: الحجر، والخشب، والكتاب.*
- **السائل:** يجري ويأخذ شكل الإناء، لا نمسكه بيدنا. *مثل: الماء، والحليب، والزيت.*

> 🗡️ حيلة سريعة: إن استطعت أن تمسك الشيء بيدك فهو **صلب**، وإن جرى وسال فهو **سائل**.

## 🗂️ نصنّف الأشياء

نستطيع أن نجمع الأشياء حسب خاصّيةٍ واحدة:

- حسب **الشكل:** كلّ الكرات معًا.
- حسب **اللون:** كلّ الأشياء الصفراء معًا.
- حسب **الحالة:** كلّ السوائل معًا.

> ⚠️ الفخّ الشائع: الخلط بين **اللون** و**الشكل** و**الحالة**. اللون نراه (أحمر، أزرق)، والشكل صورة الشيء (كرة، مكعّب)، والحالة هي صلبٌ أو سائل. الماء **سائل** مهما كان لونه، والحجر **صلب** مهما كان شكله.

> 🏆 رائع! صرت مستكشفًا تعرف خصائص الأشياء وتصنّفها حسب شكلها ولونها وملمسها وحالتها. في الفصل القادم اكتشافٌ جديد ينتظرك!', '# 📜 ملخّص: المادّة

- **المادّة:** كلّ الأشياء حولنا مصنوعة من مادّة، ولكلّ شيءٍ خصائص تميّزه.
- **الشكل:** صورة الشيء، مثل **المكعّب** و**الكرة** و**الأسطوانة**، نراه بالعين.
- **اللون:** مثل الأصفر والأخضر والأزرق، نعرفه بالعين ونصنّف به الأشياء.
- **الملمس:** نحسّ به باليد: **أملس** أو **خشن**، **صلب** أو **ليّن**.
- **الحالة:** **صلب** له شكلٌ ثابت نمسكه (حجر، خشب)، و**سائل** يجري ويأخذ شكل الإناء (ماء، حليب، زيت).
- **التصنيف:** نجمع الأشياء حسب خاصّيةٍ واحدة (الشكل أو اللون أو الحالة).
- **القاعدة:** لا نخلط بين اللون والشكل والحالة؛ الماء سائلٌ والحجر صلبٌ دائمًا.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', 'القوّة: الدفع والجذب', 'القوّة تحرّك الأشياء أو توقفها أو تغيّر اتّجاهها: ندفع الجسم فيبتعد، ونجذبه فيقترب، وذلك بالاتّصال عند اللمس أو عن بُعد كما يجذب المغناطيس الحديد', '# ⚔️ القوّة — أُحرّك العالم بيديّ

> 💡 «أدفعُ فيبتعد، وأجذبُ فيقترب: بالقوّة أُحرّك الأشياء كما أريد!»

أنت تلعب كلّ يوم: تدفع عربةً، تركل كرةً، وتفتح بابًا. في كلّ مرّة تستعمل **قوّة**. اليوم نتعلّم ما هي القوّة، وكيف نَدفع ونَجذب الأشياء من حولنا.

## 💪 القوّة تحرّك الأشياء

عندما نريد أن نحرّك شيئًا، نستعمل **قوّة** من أيدينا أو أرجلنا. القوّة تفعل ثلاثة أشياء:

- **تحرّك** الجسم الواقف (الكرة الواقفة تتدحرج عندما نركلها).
- **توقف** الجسم المتحرّك (نمسك الكرة المتدحرجة فتقف).
- **تغيّر اتّجاه** الجسم (نضرب الكرة فتغيّر طريقها).

*مثال:* الكرة لا تتحرّك وحدها، نحن نحرّكها بقوّتنا.

## ➡️ الدفع: نَدفع فيَبتعد

**الدفع** هو أن نُبعِد الجسم عنّا. ندفع فيذهب بعيدًا إلى الأمام.

<svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg">
  <text x="100" y="16" font-size="12" fill="#1f2937" text-anchor="middle">دفع</text>
  <rect x="30" y="45" width="34" height="28" fill="none" stroke="#1f2937" stroke-width="2.5"/>
  <line x1="74" y1="59" x2="150" y2="59" stroke="#1f2937" stroke-width="3"/>
  <polygon points="150,59 138,51 138,67" fill="#1f2937"/>
</svg>

*أمثلة:* ندفع عربة التسوّق فتبتعد، ندفع الباب فينفتح، نركل الكرة فتذهب بعيدًا.

## ⬅️ الجذب: نَجذب فيَقترب

**الجذب** هو أن نُقرِّب الجسم إلينا. نجذب فيأتي نحونا.

<svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg">
  <text x="100" y="16" font-size="12" fill="#1f2937" text-anchor="middle">جذب</text>
  <rect x="136" y="45" width="34" height="28" fill="none" stroke="#1f2937" stroke-width="2.5"/>
  <line x1="126" y1="59" x2="50" y2="59" stroke="#1f2937" stroke-width="3"/>
  <polygon points="50,59 62,51 62,67" fill="#1f2937"/>
</svg>

*أمثلة:* نجذب الحبل في اللعب فيقترب، نجذب الدُّرج فيخرج، نجذب الباب فينغلق نحونا.

## 🤝 قوّة بالاتّصال: نلمس الجسم

في الدفع والجذب، نحن **نلمس** الجسم بأيدينا أو أرجلنا. هذه قوّة **بالاتّصال**: لا تعمل إلّا إذا لمسنا الجسم.

*مثال:* لتدفع العربة يجب أن تضع يدك عليها وتلمسها.

## 🧲 قوّة عن بُعد: المغناطيس

هناك قوّة عجيبة تعمل **دون لمس**! **المغناطيس** يَجذب **الحديد** إليه من بعيد، دون أن نلمسه بأيدينا.

<svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg">
  <text x="40" y="20" font-size="11" fill="#1f2937" text-anchor="middle">مغناطيس</text>
  <text x="165" y="20" font-size="11" fill="#1f2937" text-anchor="middle">حديد</text>
  <path d="M28 40 v26 h10 v-26 M52 40 v26 h-10" fill="none" stroke="#1f2937" stroke-width="3"/>
  <circle cx="165" cy="58" r="9" fill="none" stroke="#1f2937" stroke-width="2.5"/>
  <line x1="70" y1="58" x2="150" y2="58" stroke="#1f2937" stroke-width="2.5" stroke-dasharray="6 5"/>
  <polygon points="70,58 82,51 82,65" fill="#1f2937"/>
</svg>

*مثال:* قرّب مغناطيسًا من مِشبك حديد، فيقفز المِشبك نحوه دون أن تلمسه. أمّا الورق والخشب فلا يجذبهما المغناطيس.

> 🗡️ تذكّر القاعدة: **ندفع فيبتعد** الجسم، و**نجذب فيقترب** الجسم.

> ⚠️ الفخّ الشائع: لا تخلط بين **الدفع** و**الجذب**. الدفع = الجسم **يبتعد** عنّا. الجذب = الجسم **يقترب** إلينا.

> 🏆 أحسنت يا بطل! صرت تعرف أنّ القوّة تحرّك الأشياء، وأنّك **تدفع فيبتعد** الجسم و**تجذب فيقترب**، وأنّ المغناطيس يجذب الحديد عن بُعد. بهذا تكون قد أتممت كلّ رحلة الإيقاظ العلميّ للسنة الأولى — مبروك، أنت الآن عالِمٌ صغير حقيقيّ! 🎉', '# 📜 ملخّص: القوّة

- **القوّة تحرّك الأشياء:** تحرّك الجسم الواقف، أو توقف المتحرّك، أو تغيّر اتّجاهه.
- **الدفع:** نَدفع الجسم فيَبتعد عنّا (ندفع عربة، نركل كرة، نفتح بابًا).
- **الجذب:** نَجذب الجسم فيَقترب إلينا (نجذب حبلًا، نجذب دُرجًا، نغلق بابًا نحونا).
- **قوّة بالاتّصال:** في الدفع والجذب نَلمس الجسم بأيدينا أو أرجلنا.
- **قوّة عن بُعد:** **المغناطيس** يجذب **الحديد** دون لمس، أمّا الورق والخشب فلا.', 9)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('797319f7-7f22-5856-af62-1552fc6c4b1b', '5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'كم عدد حواسّي؟', '[{"id":"a","text":"خمس حواسّ"},{"id":"b","text":"ثلاث حواسّ"},{"id":"c","text":"حاسّتان"},{"id":"d","text":"حاسّة واحدة"}]'::jsonb, 'a', 'عندي خمس حواسّ: البصر والسمع والشمّ والذوق واللمس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab69a8ee-fb29-5667-8418-ec0c4beed5dd', '5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'بأيّ عضوٍ أرى الألوان؟', '[{"id":"a","text":"الأذن"},{"id":"b","text":"الأنف"},{"id":"c","text":"العين"},{"id":"d","text":"اللسان"}]'::jsonb, 'c', 'أرى الألوان بحاسّة البصر، وعضوها العين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4b47907-e10c-59e1-b875-fc0a59dc42d2', '5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'بأيّ عضوٍ أسمع الأصوات؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"اليد"}]'::jsonb, 'b', 'أسمع الأصوات بحاسّة السمع، وعضوها الأذن.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45718328-5719-59e3-ae8e-62a35906f7c3', '5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'بأيّ عضوٍ أعرف أنّ العسل حلو؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"اللسان"}]'::jsonb, 'd', 'أعرف طعم العسل الحلو بحاسّة الذوق، وعضوها اللسان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c380b912-8be4-50ae-b486-7569374813b4', '5c5fb328-49d6-5d73-b5f9-6641d90a3ed1', 'في الصورة، أين العضو الذي أشمّ به؟ <svg viewBox="0 0 160 180" xmlns="http://www.w3.org/2000/svg"><g fill="none" stroke="currentColor" stroke-width="2"><ellipse cx="80" cy="90" rx="55" ry="66" fill="#ffffff"/><circle cx="60" cy="76" r="6" fill="currentColor" stroke="none"/><circle cx="100" cy="76" r="6" fill="currentColor" stroke="none"/><path d="M78 88 q6 12 0 22"/><path d="M66 128 q14 10 28 0"/></g><g font-size="11" fill="currentColor" stroke="none"><text x="96" y="104">1</text><text x="40" y="72">2</text><text x="86" y="146">3</text></g></svg>', '[{"id":"a","text":"العضو رقم 1 (الأنف)"},{"id":"b","text":"العضو رقم 2 (العين)"},{"id":"c","text":"العضو رقم 3 (الفم)"},{"id":"d","text":"لا يوجد عضو للشمّ"}]'::jsonb, 'a', 'أشمّ الروائح بحاسّة الشمّ، وعضوها الأنف، وهو رقم 1 في الوسط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', '⭐ تمرين: أتعرّف على حواسّي', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a122abb-e6a8-5d66-94cf-bb0c851f9aa1', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'بأيّ عضوٍ أشمّ رائحة الوردة؟', '[{"id":"a","text":"العين"},{"id":"b","text":"الأنف"},{"id":"c","text":"الأذن"},{"id":"d","text":"اللسان"}]'::jsonb, 'b', 'أشمّ الروائح بحاسّة الشمّ، وعضوها الأنف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('544cafba-40eb-5a67-b218-87c905659ddf', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'عضو حاسّة البصر هو:', '[{"id":"a","text":"اللسان"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"الجلد"}]'::jsonb, 'c', 'بحاسّة البصر أرى، وعضوها العين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0c0f22b-18eb-55b8-a6be-d7b3fc2bde30', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'بأيّ عضوٍ أسمع صوت العصفور؟', '[{"id":"a","text":"الأذن"},{"id":"b","text":"العين"},{"id":"c","text":"اللسان"},{"id":"d","text":"الأنف"}]'::jsonb, 'a', 'أسمع صوت العصفور بحاسّة السمع، وعضوها الأذن.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f41cb187-bdf0-513f-97e6-79070f892b5a', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'بأيّ عضوٍ أتذوّق الطعام؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"العين"},{"id":"c","text":"الأذن"},{"id":"d","text":"اللسان"}]'::jsonb, 'd', 'أتذوّق الطعام بحاسّة الذوق، وعضوها اللسان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5903e17e-8a09-5567-b07f-a323d5b1217e', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'ألمس الثلج فأعرف أنّه بارد. بأيّ عضوٍ لمستُه؟', '[{"id":"a","text":"اليد (الجلد)"},{"id":"b","text":"العين"},{"id":"c","text":"الأذن"},{"id":"d","text":"الأنف"}]'::jsonb, 'a', 'ألمس الثلج بيدي، فأعرف أنّه بارد بحاسّة اللمس، وعضوها الجلد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4987499b-a93d-58df-ba18-903291aa02d4', 'd1249a1f-a1e1-51b4-bd53-032b2eb52f4d', 'أيّ حاسّةٍ أستعملها لأعرف لون السماء؟', '[{"id":"a","text":"حاسّة الشمّ"},{"id":"b","text":"حاسّة البصر"},{"id":"c","text":"حاسّة السمع"},{"id":"d","text":"حاسّة الذوق"}]'::jsonb, 'b', 'أعرف الألوان بحاسّة البصر عن طريق العين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الحواسّ', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5caa6a9d-349a-5d4c-ade6-ef593b795f35', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'أغمضتُ عينيّ وعرفتُ الموزة من رائحتها. أيّ حاسّةٍ استعملتُ؟', '[{"id":"a","text":"حاسّة البصر"},{"id":"b","text":"حاسّة السمع"},{"id":"c","text":"حاسّة الشمّ"},{"id":"d","text":"حاسّة الذوق"}]'::jsonb, 'c', 'عرفتُ الموزة من رائحتها، فاستعملتُ حاسّة الشمّ عن طريق الأنف. الفخّ الشائع هنا اختيار الذوق، لكنّي لم أذقها، بل شممتُها فقط.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('711bf5b7-b016-5416-8b79-25c27d7a409a', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'في الظلام لا أرى شيئًا. أيّ حاسّةٍ لا تعمل جيّدًا في الظلام؟', '[{"id":"a","text":"حاسّة السمع"},{"id":"b","text":"حاسّة البصر"},{"id":"c","text":"حاسّة اللمس"},{"id":"d","text":"حاسّة الذوق"}]'::jsonb, 'b', 'حاسّة البصر تحتاج إلى الضوء، لذلك لا أرى في الظلام. أمّا السمع واللمس فيعملان حتّى في الظلام.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3d8d763-b88b-5b98-b7ef-5b260488e462', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'أيّ زوجٍ صحيحٌ بين الحاسّة وعضوها؟', '[{"id":"a","text":"السمع ← العين"},{"id":"b","text":"الذوق ← الأنف"},{"id":"c","text":"البصر ← الأذن"},{"id":"d","text":"اللمس ← الجلد"}]'::jsonb, 'd', 'حاسّة اللمس عضوها الجلد، وهو الزوج الصحيح الوحيد. الفخّ الشائع هو الخلط بين الحاسّة وعضوها، مثل وصل الذوق بالأنف بدل اللسان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32de641c-093d-5116-b356-62fcabbfc123', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'آكل قطعة شوكولاتة فأعرف أنّها حلوة وأنّها ناعمة. أيّ حاسّتين استعملتُ؟', '[{"id":"a","text":"الذوق واللمس"},{"id":"b","text":"البصر والسمع"},{"id":"c","text":"الشمّ والسمع"},{"id":"d","text":"البصر والشمّ"}]'::jsonb, 'a', 'أعرف الطعم الحلو بالذوق (اللسان)، وأعرف أنّها ناعمة باللمس (الجلد)، فهما حاسّتان معًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc57cd18-c360-5817-a45f-1095fd54f183', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'أيّ سلوكٍ يحافظ على حاسّة السمع؟', '[{"id":"a","text":"عدم رفع صوت الموسيقى كثيرًا في الأذن"},{"id":"b","text":"النظر إلى الشمس مباشرة"},{"id":"c","text":"إدخال قلمٍ في الأذن"},{"id":"d","text":"عدم غسل اليدين"}]'::jsonb, 'a', 'الصوت العالي جدًّا يضرّ الأذن، فأحافظ على حاسّة السمع بعدم رفع الصوت كثيرًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('568e7168-dd21-5cb8-87f5-79bba891d2de', 'a06101f2-7e8f-5cbd-baa6-16c83a878e17', 'أيّ حاسّةٍ تساعدني على معرفة أنّ سيّارةً تقترب من خلفي دون أن أراها؟', '[{"id":"a","text":"حاسّة الذوق"},{"id":"b","text":"حاسّة الشمّ"},{"id":"c","text":"حاسّة البصر"},{"id":"d","text":"حاسّة السمع"}]'::jsonb, 'd', 'أسمع صوت السيّارة بحاسّة السمع فأعرف أنّها تقترب، وإن لم أرها بعيني.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('621ad1be-b425-511d-9b81-b13da8c3f781', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: الحواسّ الخمس', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('928b243d-3cb2-55ad-aa83-bc90b9bd0d5a', '621ad1be-b425-511d-9b81-b13da8c3f781', 'عضو حاسّة الشمّ هو:', '[{"id":"a","text":"الأنف"},{"id":"b","text":"العين"},{"id":"c","text":"الأذن"},{"id":"d","text":"اللسان"}]'::jsonb, 'a', 'أشمّ الروائح بحاسّة الشمّ، وعضوها الأنف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5200ce7-f619-56e3-aedd-9763d8e60e26', '621ad1be-b425-511d-9b81-b13da8c3f781', 'أيّ هذه نفعله بحاسّة الذوق؟', '[{"id":"a","text":"نرى لون الوردة"},{"id":"b","text":"نعرف أنّ الحلوى حلوة"},{"id":"c","text":"نسمع صوت الباب"},{"id":"d","text":"نشمّ رائحة الخبز"}]'::jsonb, 'b', 'معرفة أنّ الحلوى حلوة تكون بحاسّة الذوق عن طريق اللسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2c5647b-76cc-5ea7-bffb-5d86a427bf16', '621ad1be-b425-511d-9b81-b13da8c3f781', 'بأيّ حاسّةٍ نعرف ألوان الزهور؟', '[{"id":"a","text":"حاسّة اللمس"},{"id":"b","text":"حاسّة الذوق"},{"id":"c","text":"حاسّة البصر"},{"id":"d","text":"حاسّة السمع"}]'::jsonb, 'c', 'نعرف الألوان بحاسّة البصر عن طريق العين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53aec606-ae0d-5a24-b433-e050ae8421aa', '621ad1be-b425-511d-9b81-b13da8c3f781', 'اللسان هو عضو حاسّة:', '[{"id":"a","text":"البصر"},{"id":"b","text":"السمع"},{"id":"c","text":"الشمّ"},{"id":"d","text":"الذوق"}]'::jsonb, 'd', 'اللسان هو عضو حاسّة الذوق، نعرف به الحلو والمالح والحامض.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e01689e-d565-5f86-85b2-f658353ac655', '621ad1be-b425-511d-9b81-b13da8c3f781', 'كيف نحافظ على حاسّة البصر؟', '[{"id":"a","text":"بالنظر إلى الشمس مباشرة"},{"id":"b","text":"بفرك العينين بقوّة"},{"id":"c","text":"بالقراءة في الظلام"},{"id":"d","text":"بعدم النظر إلى الشمس وإراحة العينين"}]'::jsonb, 'd', 'نحافظ على البصر بعدم النظر إلى الشمس مباشرة وإراحة العينين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6341a1af-8618-5f92-b9ba-5ac4e6643579', '621ad1be-b425-511d-9b81-b13da8c3f781', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"الحاسّة هي العضو نفسه"},{"id":"b","text":"لكلّ حاسّةٍ عضوٌ خاصّ بها"},{"id":"c","text":"البصر عضوه الأنف"},{"id":"d","text":"السمع عضوه اللسان"}]'::jsonb, 'b', 'لكلّ حاسّةٍ عضوٌ خاصّ بها؛ البصر للعين، والسمع للأذن، وهكذا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الحواسّ', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2efaf06d-c8bc-53c5-9d36-aff8e965bb19', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'شخصٌ لا يسمع الأصوات. أيّ حاسّةٍ لا تعمل عنده؟', '[{"id":"a","text":"حاسّة البصر"},{"id":"b","text":"حاسّة الذوق"},{"id":"c","text":"حاسّة اللمس"},{"id":"d","text":"حاسّة السمع"}]'::jsonb, 'd', 'من لا يسمع الأصوات لا تعمل عنده حاسّة السمع التي عضوها الأذن.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d95a3cfc-9f2f-5f59-855c-c860d7a94af6', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'وضعتُ يدي على كوبٍ فسحبتُها بسرعة لأنّه ساخن. أيّ حاسّةٍ حمتني؟', '[{"id":"a","text":"حاسّة الشمّ"},{"id":"b","text":"حاسّة البصر"},{"id":"c","text":"حاسّة اللمس"},{"id":"d","text":"حاسّة الذوق"}]'::jsonb, 'c', 'حاسّة اللمس عن طريق الجلد أحسّت بالحرارة فسحبتُ يدي وحميتُها من الحرق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15931e82-6bf9-5b16-9caa-1b70278ce52e', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'آكل وأنفي مسدودٌ (مزكوم) فلا أحسّ بطعم الطعام جيّدًا. ماذا يعني هذا؟', '[{"id":"a","text":"الشمّ يساعد على معرفة طعم الطعام"},{"id":"b","text":"السمع يساعد على الذوق"},{"id":"c","text":"البصر هو الذي يتذوّق"},{"id":"d","text":"الحواسّ لا علاقة بينها"}]'::jsonb, 'a', 'عند انسداد الأنف يضعف الشمّ فلا أحسّ بالطعم جيّدًا؛ إذن الشمّ يساعد الذوق. الفخّ الشائع هو الظنّ أنّ اللسان وحده يكفي، لكنّ الأنف يساعده.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10ce34af-88d3-5b08-becb-3a52e50b7f8b', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'أيّ مجموعةٍ تجمع كلّ أعضاء الحواسّ الخمس بشكلٍ صحيح؟', '[{"id":"a","text":"العين، اليد، الرّجل، الأنف، الفم"},{"id":"b","text":"العين، الأذن، الأنف، اللسان، الجلد"},{"id":"c","text":"الأذن، القلب، اللسان، العين، الجلد"},{"id":"d","text":"الأنف، المعدة، العين، الأذن، اللسان"}]'::jsonb, 'b', 'أعضاء الحواسّ الخمس هي: العين، الأذن، الأنف، اللسان، الجلد. الفخّ الشائع هو إضافة عضوٍ ليس للحسّ مثل القلب أو المعدة أو الرّجل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e513d31f-ec0f-5fd0-9931-09cc09e7523c', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'أردتُ أن أعرف هل الخبز طازجٌ دون أن آكله. أيّ حاسّتين أستعمل غالبًا؟', '[{"id":"a","text":"السمع والذوق"},{"id":"b","text":"البصر والشمّ"},{"id":"c","text":"السمع وحده"},{"id":"d","text":"اللمس والسمع"}]'::jsonb, 'b', 'أنظر إلى لون الخبز (البصر) وأشمّ رائحته (الشمّ) لأعرف إن كان طازجًا، دون أن أذوقه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ef46df6-3772-5ed4-90bf-e099cdb90525', '459b18d5-c159-5e0f-81cb-ea7ea69c4966', 'أيّ سلوكٍ يحافظ على أكثر من عضوٍ من أعضاء الحواسّ؟', '[{"id":"a","text":"النظر إلى الشمس مباشرة"},{"id":"b","text":"رفع صوت الموسيقى جدًّا"},{"id":"c","text":"غسل اليدين والوجه بانتظام"},{"id":"d","text":"إدخال أشياء في الأذن"}]'::jsonb, 'c', 'غسل اليدين والوجه يحافظ على الجلد والعينين والأنف معًا، أي على أكثر من عضو.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'ffc18441-92a2-5f69-b05e-1ed2812a7633', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للحواسّ الخمس', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db6a7502-cec0-56d0-a518-a402de5f0e48', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'أسمع صوت الجرس بحاسّة:', '[{"id":"a","text":"السمع"},{"id":"b","text":"البصر"},{"id":"c","text":"الشمّ"},{"id":"d","text":"الذوق"}]'::jsonb, 'a', 'صوت الجرس أسمعه بحاسّة السمع عن طريق الأذن.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('417182cf-b75e-5488-81a9-c6767ca24473', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'أعرف أنّ الليمون حامضٌ بحاسّة:', '[{"id":"a","text":"اللمس"},{"id":"b","text":"الذوق"},{"id":"c","text":"السمع"},{"id":"d","text":"البصر"}]'::jsonb, 'b', 'الطعم الحامض أعرفه بحاسّة الذوق عن طريق اللسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95a63249-562e-5df0-9822-4d963203b62f', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'أشمّ رائحة الطبخ بحاسّة الشمّ، وعضوها:', '[{"id":"a","text":"اللسان"},{"id":"b","text":"العين"},{"id":"c","text":"الأنف"},{"id":"d","text":"الأذن"}]'::jsonb, 'c', 'حاسّة الشمّ عضوها الأنف، وبه أشمّ رائحة الطبخ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e42ff1d-52f7-5932-a1d3-e462d2f35e9f', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'أعرف أنّ الصوف ناعمٌ والحجر خشنٌ بحاسّة:', '[{"id":"a","text":"السمع"},{"id":"b","text":"الشمّ"},{"id":"c","text":"الذوق"},{"id":"d","text":"اللمس"}]'::jsonb, 'd', 'الناعم والخشن أعرفه بحاسّة اللمس عن طريق الجلد واليدين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e7d6f65-0afc-54b4-827c-78a81b40b1a9', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'صديقي معصوب العينين وعرفني من صوتي. أيّ حاسّةٍ استعمل؟', '[{"id":"a","text":"حاسّة السمع"},{"id":"b","text":"حاسّة البصر"},{"id":"c","text":"حاسّة الشمّ"},{"id":"d","text":"حاسّة الذوق"}]'::jsonb, 'a', 'عرفني من صوتي، فاستعمل حاسّة السمع عن طريق الأذن، لأنّ عينيه كانتا مغطّاتين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fdf6303-70c5-5afb-a2d4-b3b29a6009a8', '82f07c67-63a5-5ab5-b3ef-909720e0c36b', 'أيّ عبارةٍ **خاطئة** عن الحواسّ؟', '[{"id":"a","text":"البصر عضوه العين"},{"id":"b","text":"اللمس عضوه الجلد"},{"id":"c","text":"الذوق عضوه الأذن"},{"id":"d","text":"الشمّ عضوه الأنف"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ الذوق عضوه الأذن؛ فالذوق عضوه اللسان، والأذن عضو السمع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dca78f55-5431-5803-a33b-fc3c458e8b7c', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dede595f-1fbc-583d-81a8-bbf4e38f7d56', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'لماذا نأكل الطعام؟', '[{"id":"a","text":"ليعطينا قوّةً وينمو جسمنا"},{"id":"b","text":"لنتعب"},{"id":"c","text":"لنشعر بالنعاس"},{"id":"d","text":"بلا فائدة"}]'::jsonb, 'a', 'نأكل لأنّ الطعام يعطينا قوّةً لنلعب ونتعلّم، ويساعد جسمنا على النموّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5477f5a2-1880-5780-b6ba-9516605f2775', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'أيّ هذه طعامٌ مفيد؟', '[{"id":"a","text":"الحلوى بكثرة"},{"id":"b","text":"الخضر والفاكهة"},{"id":"c","text":"المشروب الغازي"},{"id":"d","text":"الشيبس"}]'::jsonb, 'b', 'الخضر والفاكهة طعامٌ مفيد لجسمنا، أمّا الحلوى فنقلّل منها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79955424-4520-527f-b94d-40280f20fcf0', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'ماذا نفعل قبل الأكل؟', '[{"id":"a","text":"نلعب"},{"id":"b","text":"ننام"},{"id":"c","text":"نغسل أيدينا"},{"id":"d","text":"لا شيء"}]'::jsonb, 'c', 'قبل الأكل نغسل أيدينا بالماء والصابون لتبقى نظيفة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72b759a9-8c79-52f2-b194-66cc5fc82ac8', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'ما الذي يفيد العظام والأسنان؟', '[{"id":"a","text":"الحليب"},{"id":"b","text":"الحلوى"},{"id":"c","text":"المشروب الغازي"},{"id":"d","text":"الشيبس"}]'::jsonb, 'a', 'الحليب مفيدٌ للعظام والأسنان فنشربه ليكبر جسمنا قويًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d32fa483-3241-59b2-bd5a-9bd25c28acad', 'dca78f55-5431-5803-a33b-fc3c458e8b7c', 'لماذا نأكل أنواعًا مختلفة من الطعام؟', '[{"id":"a","text":"لنأكل أقلّ"},{"id":"b","text":"لنتعب أكثر"},{"id":"c","text":"بلا سبب"},{"id":"d","text":"ليأخذ الجسم كلّ ما يحتاجه"}]'::jsonb, 'd', 'الطعام المتنوّع يعطي الجسم كلّ ما يحتاجه لينمو ويبقى قويًّا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ba8eed8c-9a17-5dc9-93e6-942fda617265', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', '⭐ تمرين: نتعرّف على غذائنا', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('425a1532-9be3-5816-a571-16424a444fa1', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'الطعام يعطي جسمنا...', '[{"id":"a","text":"تعبًا"},{"id":"b","text":"قوّةً"},{"id":"c","text":"نعاسًا"},{"id":"d","text":"مرضًا"}]'::jsonb, 'b', 'الطعام يعطي جسمنا قوّةً لنلعب ونتعلّم وننمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('535a6607-ebc6-5d2f-aa1c-15e0cefb8fe3', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'أيّ هذه شرابٌ مفيد نشربه كلّ يوم؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"المشروب الغازي"},{"id":"c","text":"العصير السكّري بكثرة"},{"id":"d","text":"الشراب الحلو بكثرة"}]'::jsonb, 'a', 'الماء شرابٌ مفيد ونظيف نشربه كلّ يوم خاصّةً عند العطش.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eb99c84-2ba0-557b-903f-0d11f58b9af4', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'أيّ هذه فاكهة؟', '[{"id":"a","text":"الخبز"},{"id":"b","text":"اللحم"},{"id":"c","text":"التفّاح"},{"id":"d","text":"السمك"}]'::jsonb, 'c', 'التفّاح فاكهة، وهي من الغلال المفيدة لجسمنا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0797ce16-ece6-5342-b34d-f47a45151057', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'ماذا نفعل قبل أكل الفاكهة؟', '[{"id":"a","text":"نرميها"},{"id":"b","text":"نلعب بها"},{"id":"c","text":"نتركها"},{"id":"d","text":"نغسلها"}]'::jsonb, 'd', 'نغسل الفاكهة قبل أكلها لتكون نظيفةً وآمنة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a88255a-4d0c-58bc-b72c-3d4c7affd81b', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'أيّ طعامٍ يساعد جسمنا على النموّ؟', '[{"id":"a","text":"اللحم والسمك والبيض"},{"id":"b","text":"الحلوى فقط"},{"id":"c","text":"المشروب الغازي"},{"id":"d","text":"الشيبس"}]'::jsonb, 'a', 'اللحم والسمك والبيض تساعد الجسم على النموّ فنكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14fff29c-44c1-59f1-9939-ed4893bc1e1b', 'ba8eed8c-9a17-5dc9-93e6-942fda617265', 'لماذا لا نُكثر من الحلوى؟', '[{"id":"a","text":"لأنّها مفيدة جدًّا"},{"id":"b","text":"لأنّها تضرّ الأسنان"},{"id":"c","text":"لأنّها تقوّي العظام"},{"id":"d","text":"لأنّها مثل الماء"}]'::jsonb, 'b', 'الإكثار من الحلوى يضرّ الأسنان، لذلك نقلّل منها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4251deb9-6825-5322-a8f5-a762114f78a0', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الصحن', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16c5d340-49e1-54ef-917f-3553284f0b47', '4251deb9-6825-5322-a8f5-a762114f78a0', 'طفلٌ يأكل الحلوى فقط طوال اليوم. ماذا يحدث لجسمه؟', '[{"id":"a","text":"قد يضعف ويمرض لأنّه لا يأكل طعامًا متنوّعًا"},{"id":"b","text":"يصبح أقوى"},{"id":"c","text":"تتحسّن أسنانه"},{"id":"d","text":"لا شيء، الحلوى تكفي"}]'::jsonb, 'a', 'الطعام غير المتنوّع يحرم الجسم ممّا يحتاجه، فيضعف الطفل وقد يمرض.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db9f3234-7a98-570c-9327-c57f53dae62d', '4251deb9-6825-5322-a8f5-a762114f78a0', 'أمامك: تفّاحة ومشروب غازي. أيّهما تختار لصحّتك؟', '[{"id":"a","text":"المشروب الغازي"},{"id":"b","text":"التفّاحة"},{"id":"c","text":"كلاهما متساويان"},{"id":"d","text":"لا أحد منهما"}]'::jsonb, 'b', 'التفّاحة فاكهة مفيدة، أمّا المشروب الغازي ففيه سكّر كثير ونقلّل منه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('989ab666-f024-5cb5-b9ea-58ac7318d205', '4251deb9-6825-5322-a8f5-a762114f78a0', 'نسيتَ أن تغسل يديك ثمّ أكلتَ بيدٍ متّسخة. ما الخطر؟', '[{"id":"a","text":"لا خطر"},{"id":"b","text":"أصبح الطعام ألذّ"},{"id":"c","text":"تقوى الأسنان"},{"id":"d","text":"قد يدخل الوسخ إلى جسمي فأمرض"}]'::jsonb, 'd', 'اليد المتّسخة تنقل الوسخ إلى الطعام فقد نمرض، لذلك نغسل أيدينا قبل الأكل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4763d1d3-1e4a-5b67-8eca-f45848a80d7c', '4251deb9-6825-5322-a8f5-a762114f78a0', 'أيّ صحنٍ هو الأكثر تنوّعًا وفائدة؟', '[{"id":"a","text":"حلوى ومشروب غازي"},{"id":"b","text":"شيبس فقط"},{"id":"c","text":"خبز وخضر وقطعة سمك وتفّاحة"},{"id":"d","text":"حلوى فقط"}]'::jsonb, 'c', 'الصحن المتنوّع يجمع الخبز والخضر والسمك والفاكهة، فهو صحّيّ ومفيد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d35aeba-4a1f-56f0-a495-9b74fc5c3c28', '4251deb9-6825-5322-a8f5-a762114f78a0', 'لماذا نأكل من كلّ نوعٍ قليلًا بدل نوعٍ واحد فقط؟', '[{"id":"a","text":"لأنّ كلّ نوعٍ يعطي الجسم فائدةً يحتاجها"},{"id":"b","text":"لنأكل أقلّ"},{"id":"c","text":"بلا سبب"},{"id":"d","text":"لنتعب أكثر"}]'::jsonb, 'a', 'كلّ نوعٍ من الطعام يعطي الجسم فائدةً مختلفة، لذلك نأكل طعامًا متنوّعًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df8d971a-f9f0-53af-8e8b-54a74d876a5f', '4251deb9-6825-5322-a8f5-a762114f78a0', 'قال طفل: «الحلوى طعامٌ جيّد لأنّها لذيذة». لماذا هذا هو الفخّ الشائع؟', '[{"id":"a","text":"لأنّ الحلوى تقوّي العظام"},{"id":"b","text":"لأنّ اللذيذ ليس دائمًا مفيدًا؛ الحلوى تضرّ الأسنان"},{"id":"c","text":"بل العبارة صحيحة تمامًا"},{"id":"d","text":"لأنّ الحلوى مثل الماء"}]'::jsonb, 'b', 'الفخّ الشائع هو الخلط بين اللذيذ والمفيد؛ الحلوى لذيذة لكنّها تضرّ الأسنان، فنقلّل منها ونُكثر من الخضر والفاكهة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('01059b1f-0086-55b1-bdee-2f944d6b1a23', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: غذائي وصحّتي', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5cff833-47c9-52c2-8235-4e1c8b07154f', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'عندما نجوع نشعر بـ...', '[{"id":"a","text":"القوّة"},{"id":"b","text":"الفرح"},{"id":"c","text":"التعب"},{"id":"d","text":"النموّ"}]'::jsonb, 'c', 'عندما نجوع يشعر الجسم بالتعب، لذلك نأكل لنحصل على القوّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62c0e7e7-6660-5af0-b8d3-82d7ed78276b', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'أيّ هذه يعطي قوّة (طاقة)؟', '[{"id":"a","text":"الماء فقط"},{"id":"b","text":"الخبز"},{"id":"c","text":"الهواء"},{"id":"d","text":"النوم"}]'::jsonb, 'b', 'الخبز يعطي الجسم قوّةً (طاقة) ليتحرّك ويلعب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('575f5bae-afd5-53d6-aaaa-23c040132a24', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'ماذا نفعل بالخضر قبل أكلها؟', '[{"id":"a","text":"نغسلها"},{"id":"b","text":"نرميها"},{"id":"c","text":"نلوّنها"},{"id":"d","text":"نتركها متّسخة"}]'::jsonb, 'a', 'نغسل الخضر قبل أكلها لتكون نظيفةً فلا نمرض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('907c59f0-253f-556d-9d75-46771ec2ed4c', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'ما الشراب الأفضل عند العطش بعد اللعب؟', '[{"id":"a","text":"مشروب غازي"},{"id":"b","text":"شراب حلو كثير"},{"id":"c","text":"لا نشرب شيئًا"},{"id":"d","text":"ماء نظيف"}]'::jsonb, 'd', 'بعد اللعب نشرب ماءً نظيفًا لأنّ الماء مفيدٌ لجسمنا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e696d96b-0ccb-5a94-822b-c3f51a71887c', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'أيّ هذه وجبةٌ متنوّعة؟', '[{"id":"a","text":"حلوى فقط"},{"id":"b","text":"خبز وخضر وفاكهة"},{"id":"c","text":"شيبس فقط"},{"id":"d","text":"مشروب غازي فقط"}]'::jsonb, 'b', 'الوجبة المتنوّعة تجمع الخبز والخضر والفاكهة، فهي صحّية ومفيدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e323ad46-f321-5340-bd37-1f8fdb40c835', '01059b1f-0086-55b1-bdee-2f944d6b1a23', 'ما الذي يفيد العظام والأسنان فنشربه؟', '[{"id":"a","text":"الحليب"},{"id":"b","text":"المشروب الغازي"},{"id":"c","text":"الشراب الحلو"},{"id":"d","text":"لا شيء"}]'::jsonb, 'a', 'الحليب مفيدٌ للعظام والأسنان، فنشربه لينمو جسمنا قويًّا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a0bd14d3-751b-5f81-9468-12d2dacfa052', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الغذاء الصحّي', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c6d8cc8-175b-542d-a070-cc3803be9b8a', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'صديقك يأكل في الصباح حلوى فقط ويشعر بالتعب في القسم. ما الأفضل أن يأكل؟', '[{"id":"a","text":"حلوى أكثر"},{"id":"b","text":"طعامًا متنوّعًا مثل الخبز والحليب والفاكهة"},{"id":"c","text":"مشروبًا غازيًّا"},{"id":"d","text":"لا يأكل شيئًا"}]'::jsonb, 'b', 'الطعام المتنوّع (خبز وحليب وفاكهة) يعطي الجسم قوّةً وفائدة، أمّا الحلوى وحدها فلا تكفي.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97b24f01-d38b-54ea-9c55-3030da465a65', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'أمامك صحنان: الأوّل فيه خضر وسمك وفاكهة، والثاني حلوى وشيبس. أيّهما أصحّ؟', '[{"id":"a","text":"الصحن الأوّل"},{"id":"b","text":"الصحن الثاني"},{"id":"c","text":"كلاهما متساويان"},{"id":"d","text":"لا أحد منهما طعام"}]'::jsonb, 'a', 'الصحن الأوّل متنوّع وصحّي (خضر وسمك وفاكهة)، أمّا الثاني فحلوى ودهون نقلّل منها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85acc4f0-056d-5446-922a-07b3837bdf50', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'لماذا نغسل أيدينا والفاكهة قبل الأكل؟', '[{"id":"a","text":"لنلعب أكثر"},{"id":"b","text":"ليصبح الطعام ألذّ"},{"id":"c","text":"لتقوى الأسنان"},{"id":"d","text":"لإزالة الوسخ حتّى لا نمرض"}]'::jsonb, 'd', 'غسل اليدين والفاكهة يزيل الوسخ والجراثيم، فنبقى أصحّاء ولا نمرض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6c8e750-d105-56f2-a2e6-e51789bad687', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'كيف نختار غداءً متوازنًا؟', '[{"id":"a","text":"نأكل نوعًا واحدًا فقط"},{"id":"b","text":"نأكل حلوى ومشروبًا غازيًّا"},{"id":"c","text":"نجمع خبزًا وخضرًا ولحمًا أو سمكًا وفاكهة"},{"id":"d","text":"نترك الغداء"}]'::jsonb, 'c', 'الغداء المتوازن يجمع نوعًا للقوّة (خبز) ونوعًا للنموّ (لحم أو سمك) مع الخضر والفاكهة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38cb59dc-8f09-5c6f-9a2a-a550c2c7ced7', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'قال طفل: «المشروب الغازي مثل الماء، كلاهما سائل». لماذا هذا غير صحيح؟', '[{"id":"a","text":"لأنّ الماء فيه سكّر كثير"},{"id":"b","text":"لأنّ المشروب الغازي فيه سكّر كثير وليس مفيدًا كالماء"},{"id":"c","text":"لأنّهما ليسا سائلين"},{"id":"d","text":"بل العبارة صحيحة"}]'::jsonb, 'b', 'الفخّ الشائع هو الظنّ أنّ كلّ سائلٍ مفيد؛ المشروب الغازي فيه سكّر كثير، أمّا الماء فنظيف ومفيد لجسمنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b52df6e-5d69-57ae-95a7-16f104e2665b', 'a0bd14d3-751b-5f81-9468-12d2dacfa052', 'طفل يحبّ الحلوى كثيرًا. ما النصيحة الصحّية له؟', '[{"id":"a","text":"يأكل الحلوى في كلّ وجبة"},{"id":"b","text":"يترك الخضر والفاكهة"},{"id":"c","text":"يشرب مشروبًا غازيًّا بدل الماء"},{"id":"d","text":"يقلّل من الحلوى ويُكثر من الخضر والفاكهة"}]'::jsonb, 'd', 'الفخّ الشائع هو الخلط بين اللذيذ والمفيد؛ النصيحة أن نقلّل من الحلوى التي تضرّ الأسنان ونُكثر من الخضر والفاكهة المفيدة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('63d4ed85-5e8d-5322-b384-cb255cebcf61', 'ae77688a-d0f1-5fa3-aa4b-e3d2c3b30ef7', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ مراجعة شاملة: التغذية', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a3909ef-4dc5-582e-b179-0ac90a2bf918', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'ما فائدة الطعام لجسمنا؟', '[{"id":"a","text":"يعطينا قوّةً ويساعدنا على النموّ"},{"id":"b","text":"يُتعبنا"},{"id":"c","text":"يُمرضنا"},{"id":"d","text":"لا فائدة له"}]'::jsonb, 'a', 'الطعام يعطي الجسم قوّةً ليتحرّك ويلعب، ويساعده على النموّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41d1c8dc-935e-5153-b791-ba245f593319', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'أيّ مجموعةٍ كلّها أطعمةٌ مفيدة؟', '[{"id":"a","text":"حلوى، شيبس، مشروب غازي"},{"id":"b","text":"حلوى، خبز، مشروب غازي"},{"id":"c","text":"خبز، حليب، خضر، فاكهة"},{"id":"d","text":"شيبس، حلوى، شراب حلو"}]'::jsonb, 'c', 'الخبز والحليب والخضر والفاكهة كلّها أطعمة مفيدة ومتنوّعة لجسمنا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0639626b-3843-5f24-8374-39bcf1859b25', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'متى نغسل أيدينا؟', '[{"id":"a","text":"بعد أسبوع"},{"id":"b","text":"قبل الأكل"},{"id":"c","text":"لا نغسلها أبدًا"},{"id":"d","text":"أثناء النوم"}]'::jsonb, 'b', 'نغسل أيدينا بالماء والصابون قبل الأكل لتبقى نظيفةً فلا نمرض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fb58601-b733-5053-b7a5-7eb742e68b5e', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'لماذا لا نُكثر من المشروبات الغازية والحلويات؟', '[{"id":"a","text":"لأنّها مثل الماء"},{"id":"b","text":"لأنّها تقوّي الأسنان"},{"id":"c","text":"لأنّها مفيدة جدًّا"},{"id":"d","text":"لأنّها تضرّ الأسنان والجسم"}]'::jsonb, 'd', 'الإكثار من الحلويات والمشروبات الغازية يضرّ الأسنان والجسم، لذلك نقلّل منها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c113df68-b9ef-5d85-a6f3-965be0f6725e', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'طفل يأكل خبزًا فقط في كلّ الوجبات. ما الأفضل له؟', '[{"id":"a","text":"يأكل أيضًا خضرًا وفاكهةً وحليبًا"},{"id":"b","text":"يأكل خبزًا أكثر فقط"},{"id":"c","text":"يترك الأكل"},{"id":"d","text":"يأكل حلوى بدل الخبز"}]'::jsonb, 'a', 'الطعام يجب أن يكون متنوّعًا؛ يضيف الطفل خضرًا وفاكهةً وحليبًا ليأخذ جسمه كلّ فائدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a357ab76-3be4-5307-a12c-b6932e957cb9', '63d4ed85-5e8d-5322-b384-cb255cebcf61', 'أيّ تصرّفٍ صحّيّ تمامًا عند الأكل؟', '[{"id":"a","text":"نأكل بيدٍ متّسخة"},{"id":"b","text":"نأكل فاكهةً دون غسلها"},{"id":"c","text":"نغسل أيدينا ونأكل طعامًا متنوّعًا"},{"id":"d","text":"نُكثر من الحلوى"}]'::jsonb, 'c', 'التصرّف الصحّي هو غسل اليدين وأكل طعامٍ متنوّع ونظيف، لنبقى أقوياء وفي صحّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ca17ae0-68c1-5c56-b189-0d99cd949fde', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', 'ماذا يعني أنّ الكائن الحيّ ينمو؟', '[{"id":"a","text":"يكبر مع الوقت"},{"id":"b","text":"يبقى صغيرًا دائمًا"},{"id":"c","text":"يصير حجرًا"},{"id":"d","text":"يختفي"}]'::jsonb, 'a', 'النموّ يعني أنّ الكائن الحيّ يكبر شيئًا فشيئًا مع مرور الوقت.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c33ee31-d583-5077-84e2-7ff75d13368e', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', 'أيّ هذه كائنٌ حيٌّ ينمو؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الشجرة"},{"id":"c","text":"الكرسيّ"},{"id":"d","text":"الكأس"}]'::jsonb, 'b', 'الشجرة كائنٌ حيٌّ ينمو ويكبر، أمّا الحجر والكرسيّ والكأس فجماد لا ينمو.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51624af3-f875-527b-960e-11d23ba0e9ba', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', 'ما الترتيب الصحيح لنموّ الإنسان؟', '[{"id":"a","text":"كهل ← شابّ ← طفل ← رضيع"},{"id":"b","text":"طفل ← رضيع ← شابّ ← كهل"},{"id":"c","text":"رضيع ← طفل ← شابّ ← كهل"},{"id":"d","text":"شابّ ← رضيع ← كهل ← طفل"}]'::jsonb, 'c', 'ينمو الإنسان من الأصغر إلى الأكبر: رضيع ثمّ طفل ثمّ شابّ ثمّ كهل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a51fc1f-dcfc-559c-9634-3f498357058e', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', 'الكتكوت الصغير عندما يكبر يصير:', '[{"id":"a","text":"بقرة"},{"id":"b","text":"قطّة"},{"id":"c","text":"سمكة"},{"id":"d","text":"دجاجة"}]'::jsonb, 'd', 'الكتكوت صغير الدجاجة؛ فإذا كبر صار دجاجة مثل أمّه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d689817-8815-59f2-a45d-e2ecdd48b847', '7fab7d84-c250-5d9e-ad5d-d6e27bf21e35', 'من أين تبدأ حياة النبات؟', '[{"id":"a","text":"من حجرٍ صغير"},{"id":"b","text":"من بذرة"},{"id":"c","text":"من نبتة كبيرة جاهزة"},{"id":"d","text":"من قطعة حديد"}]'::jsonb, 'b', 'تبدأ حياة النبات من بذرة نضعها في التربة ونسقيها فتنبت وتكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('877b7a09-423f-5a53-b947-185e6c436a6e', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', '⭐ تمرين: نتعلّم النموّ', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32196fdf-727e-58cf-9219-8f6aff9d126b', '877b7a09-423f-5a53-b947-185e6c436a6e', 'أيّ هذه كائنٌ حيٌّ يكبر؟', '[{"id":"a","text":"طفل"},{"id":"b","text":"حجر"},{"id":"c","text":"كرسيّ"},{"id":"d","text":"كأس"}]'::jsonb, 'a', 'الطفل كائنٌ حيٌّ ينمو ويكبر، أمّا الحجر والكرسيّ والكأس فلا تنمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3cfd59be-d840-5fa6-b00f-5da5fd42cfc1', '877b7a09-423f-5a53-b947-185e6c436a6e', 'الرضيع صغيرٌ جدًّا، وهو يشرب:', '[{"id":"a","text":"القهوة"},{"id":"b","text":"الحليب"},{"id":"c","text":"الماء المالح"},{"id":"d","text":"العصير الحارّ"}]'::jsonb, 'b', 'الرضيع صغيرٌ جدًّا فيشرب الحليب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0ab3549-ed38-5814-9462-f67584b12c5d', '877b7a09-423f-5a53-b947-185e6c436a6e', 'كلّما كبر الإنسان:', '[{"id":"a","text":"نقص طوله"},{"id":"b","text":"صار حجرًا"},{"id":"c","text":"زاد طوله ووزنه"},{"id":"d","text":"بقي رضيعًا"}]'::jsonb, 'c', 'كلّما كبر الإنسان زاد طوله وزاد وزنه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fdbda12-69a4-508f-957b-88f55a087174', '877b7a09-423f-5a53-b947-185e6c436a6e', 'العجل الصغير عندما يكبر يصير:', '[{"id":"a","text":"حصانًا"},{"id":"b","text":"خروفًا"},{"id":"c","text":"دجاجة"},{"id":"d","text":"بقرة"}]'::jsonb, 'd', 'العجل صغير البقرة؛ فإذا كبر صار بقرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28910768-07f4-58c1-adfc-4ecc82b5611c', '877b7a09-423f-5a53-b947-185e6c436a6e', 'ماذا نضع في التربة لتنبت نبتة جديدة؟', '[{"id":"a","text":"حجرًا"},{"id":"b","text":"بذرة"},{"id":"c","text":"مسمارًا"},{"id":"d","text":"كأسًا"}]'::jsonb, 'b', 'نضع البذرة في التربة ونسقيها فتنبت نبتة جديدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a59eb49-a350-5514-8c75-9cdfadf87c25', '877b7a09-423f-5a53-b947-185e6c436a6e', 'أيّ شيءٍ لا ينمو ولا يكبر؟', '[{"id":"a","text":"القطّة"},{"id":"b","text":"الشجرة"},{"id":"c","text":"الحجر"},{"id":"d","text":"الطفل"}]'::jsonb, 'c', 'الحجر جماد لا ينمو، أمّا القطّة والشجرة والطفل فكائنات حيّة تنمو.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bff82117-2328-55f2-b273-339abd04085d', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس النموّ', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75b558bc-af93-581a-8fcf-1cef9a3bb76f', 'bff82117-2328-55f2-b273-339abd04085d', 'لماذا نقول إنّ الشجرة كائنٌ حيّ والحجر ليس كذلك؟', '[{"id":"a","text":"لأنّ الحجر أكبر"},{"id":"b","text":"لأنّ الشجرة لا تتغيّر"},{"id":"c","text":"لأنّ الشجرة تنمو وتكبر والحجر يبقى كما هو"},{"id":"d","text":"لأنّ الحجر يأكل"}]'::jsonb, 'c', 'الشجرة تنمو وتكبر لأنّها حيّة، أمّا الحجر فجماد يبقى كما هو ولا ينمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63f625e0-4d4c-56e1-8d29-7004d1430ea7', 'bff82117-2328-55f2-b273-339abd04085d', 'ولدت قطّةٌ صغيرة. ماذا تصير عندما تكبر؟', '[{"id":"a","text":"قطّة كبيرة"},{"id":"b","text":"كلبًا"},{"id":"c","text":"عصفورًا"},{"id":"d","text":"تبقى صغيرة دائمًا"}]'::jsonb, 'a', 'القطّة الصغيرة تكبر فتصير قطّة كبيرة مثل أمّها، ولا تتحوّل إلى حيوانٍ آخر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79fa8c15-2a43-5728-be12-44cb413412c8', 'bff82117-2328-55f2-b273-339abd04085d', 'ما الترتيب الصحيح لنموّ النبات؟', '[{"id":"a","text":"نبتة كبيرة ← نبتة صغيرة ← بذرة"},{"id":"b","text":"نبتة صغيرة ← بذرة ← نبتة كبيرة"},{"id":"c","text":"أوراق ← بذرة ← لا شيء"},{"id":"d","text":"بذرة ← نبتة صغيرة ← نبتة كبيرة"}]'::jsonb, 'd', 'ينمو النبات من البذرة: بذرة ← نبتة صغيرة ← نبتة كبيرة. الخطأ الشائع هو عكس الترتيب والبدء من النبتة الكبيرة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6581d27-5bc3-59a1-b009-6b0fcea1c5e2', 'bff82117-2328-55f2-b273-339abd04085d', 'انظر إلى مراحل نموّ النبات في الصورة. ما المرحلة الأخيرة (الأكبر)؟ <svg viewBox="0 0 300 90" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="78" x2="290" y2="78" stroke="#1f2937" stroke-width="2"/><g stroke="#1f2937" stroke-width="2" fill="none"><ellipse cx="50" cy="70" rx="8" ry="5"/><line x1="150" y1="78" x2="150" y2="58"/><path d="M150 62 q-9 -5 -14 -2"/><line x1="250" y1="78" x2="250" y2="32"/><path d="M250 52 q-14 -7 -22 -2"/><path d="M250 46 q14 -7 22 -2"/><circle cx="250" cy="28" r="6"/></g></svg>', '[{"id":"a","text":"البذرة وحدها"},{"id":"b","text":"النبتة الكبيرة ذات الأوراق والزهرة"},{"id":"c","text":"لا توجد مرحلة أخيرة"},{"id":"d","text":"النبتة الصغيرة"}]'::jsonb, 'b', 'في الصورة تبدأ البذرة صغيرة ثمّ تكبر، والمرحلة الأخيرة هي النبتة الكبيرة ذات الأوراق والزهرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d3e913a-75fe-5023-9350-fc322fc586a7', 'bff82117-2328-55f2-b273-339abd04085d', 'قال طفل: «جدّي كان كهلًا ثمّ صار رضيعًا». لماذا هذا غير صحيح؟', '[{"id":"a","text":"لأنّ الكهل لا يكبر في السنّ"},{"id":"b","text":"لأنّ الرضيع أكبر من الكهل"},{"id":"c","text":"العبارة صحيحة"},{"id":"d","text":"لأنّ النموّ من الصغير إلى الكبير، لا العكس"}]'::jsonb, 'd', 'الخطأ الشائع هو عكس النموّ. الإنسان ينمو من الصغير إلى الكبير: رضيع ثمّ طفل ثمّ شابّ ثمّ كهل، ولا يعود رضيعًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ddcc60f-ca3a-52f3-94d9-a3d5db8fa6cd', 'bff82117-2328-55f2-b273-339abd04085d', 'أيّ مجموعةٍ كلّها كائناتٌ حيّة تنمو؟', '[{"id":"a","text":"حجر، كرسيّ، سيّارة"},{"id":"b","text":"طفل، شجرة، عصفور"},{"id":"c","text":"كأس، لعبة، حجر"},{"id":"d","text":"طفل، حجر، كرسيّ"}]'::jsonb, 'b', 'الطفل والشجرة والعصفور كلّها كائنات حيّة تنمو. الخطأ الشائع هو خلط الجماد (الحجر، الكرسيّ) بالكائنات الحيّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('358382e3-6553-5530-9530-c3f62332526e', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: نكبر مثل كلّ الكائنات', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cf647d0-8336-5b69-94ac-839c37093388', '358382e3-6553-5530-9530-c3f62332526e', 'أيّ هذه يبقى كما هو ولا يكبر أبدًا؟', '[{"id":"a","text":"النبتة"},{"id":"b","text":"الكرسيّ"},{"id":"c","text":"الكتكوت"},{"id":"d","text":"الطفل"}]'::jsonb, 'b', 'الكرسيّ جماد يبقى كما هو ولا يكبر، أمّا النبتة والكتكوت والطفل فتنمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9ae7e22-7f5b-5820-8091-5963c44e9aa8', '358382e3-6553-5530-9530-c3f62332526e', 'من هو الأصغر بين هؤلاء؟', '[{"id":"a","text":"الرضيع"},{"id":"b","text":"الشابّ"},{"id":"c","text":"الكهل"},{"id":"d","text":"الطفل"}]'::jsonb, 'a', 'الرضيع هو الأصغر، ثمّ يكبر فيصير طفلًا ثمّ شابًّا ثمّ كهلًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d396bb9e-edd6-5357-b8f5-a83c690836d2', '358382e3-6553-5530-9530-c3f62332526e', 'ماذا يحدث للبذرة إذا وضعناها في التربة وسقيناها؟', '[{"id":"a","text":"تصير حجرًا"},{"id":"b","text":"تختفي"},{"id":"c","text":"تبقى بذرة دائمًا"},{"id":"d","text":"تنبت وتكبر نبتة"}]'::jsonb, 'd', 'البذرة في التربة المسقيّة تنبت وتكبر شيئًا فشيئًا حتّى تصير نبتة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d86311f3-99f8-5b4f-8948-ae1f60e34e80', '358382e3-6553-5530-9530-c3f62332526e', 'الجَرْو الصغير عندما يكبر يصير:', '[{"id":"a","text":"قطًّا"},{"id":"b","text":"حصانًا"},{"id":"c","text":"كلبًا"},{"id":"d","text":"دجاجة"}]'::jsonb, 'c', 'الجَرْو صغير الكلب؛ فإذا كبر صار كلبًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82b52e53-ecef-5afb-89d5-8ab104df5083', '358382e3-6553-5530-9530-c3f62332526e', 'لماذا يصير ثوبُ الطفل صغيرًا عليه بعد سنوات؟', '[{"id":"a","text":"لأنّ الطفل كبر وزاد طوله"},{"id":"b","text":"لأنّ الثوب يكبر"},{"id":"c","text":"لأنّ الطفل صار أصغر"},{"id":"d","text":"لأنّ الثوب صار حجرًا"}]'::jsonb, 'a', 'الطفل ينمو ويزداد طوله، فيصير الثوب القديم صغيرًا عليه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff8cd75d-dc37-5d2e-b5cf-b6d1472c0c04', '358382e3-6553-5530-9530-c3f62332526e', 'ما الشيء المشترك بين الإنسان والحيوان والنبات؟', '[{"id":"a","text":"كلّها تمشي"},{"id":"b","text":"كلّها جماد"},{"id":"c","text":"كلّها تطير"},{"id":"d","text":"كلّها كائنات حيّة تنمو"}]'::jsonb, 'd', 'الإنسان والحيوان والنبات كائنات حيّة تشترك في أنّها تنمو وتكبر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل عالم النموّ', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb8163d3-26d3-5fa4-88f3-df23cb9e6665', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'نبتةٌ صغيرة وضعناها في الضوء وسقيناها، ونبتةٌ مثلها تركناها بلا ماء. ما المتوقّع بعد أيّام؟', '[{"id":"a","text":"كلتاهما تكبران بالتساوي"},{"id":"b","text":"التي بلا ماء تكبر أكثر"},{"id":"c","text":"المسقيّة تكبر وتنمو والأخرى تذبل"},{"id":"d","text":"كلتاهما تصيران حجرًا"}]'::jsonb, 'c', 'النبتة تحتاج الماء لتنمو؛ فالمسقيّة تكبر وتنمو، والتي بلا ماء تذبل ولا تنمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e69cbb-305a-54b2-aecc-2862ea2860f1', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'انظر إلى صورة نموّ الإنسان. ما المرحلة الأولى (الأصغر)؟ <svg viewBox="0 0 300 110" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="96" x2="290" y2="96" stroke="#1f2937" stroke-width="2"/><g stroke="#1f2937" stroke-width="2" fill="none"><circle cx="45" cy="82" r="6"/><line x1="45" y1="88" x2="45" y2="95"/><circle cx="130" cy="68" r="8"/><line x1="130" y1="76" x2="130" y2="95"/><circle cx="215" cy="52" r="10"/><line x1="215" y1="62" x2="215" y2="95"/><circle cx="285" cy="40" r="11"/><line x1="285" y1="51" x2="285" y2="95"/></g></svg>', '[{"id":"a","text":"أكبر شخصٍ على اليمين"},{"id":"b","text":"أصغر شخصٍ على اليسار"},{"id":"c","text":"الشخص الذي في الوسط"},{"id":"d","text":"لا توجد مرحلة أولى"}]'::jsonb, 'b', 'في الصورة يكبر الطول من اليسار إلى اليمين، فالمرحلة الأولى (الأصغر) هي أصغر شخصٍ على اليسار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2e1bd32-2c18-59ac-b4bd-1b8bf3776e02', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'قال طفل: «الحجر ينمو ويكبر مثل الشجرة». ما الخطأ في كلامه؟', '[{"id":"a","text":"الحجر يكبر أسرع من الشجرة"},{"id":"b","text":"الشجرة لا تنمو"},{"id":"c","text":"الكلام صحيح"},{"id":"d","text":"الحجر جماد لا ينمو، والشجرة وحدها هي الحيّة التي تنمو"}]'::jsonb, 'd', 'الخطأ الشائع هو ظنّ أنّ الجماد ينمو. الحجر جماد يبقى كما هو، والشجرة وحدها كائنٌ حيٌّ ينمو.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0c9252e-2539-55a6-a0df-c49ea64b04ce', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'رأينا دجاجة كبيرة وبجانبها كتكوت صغير. ما العلاقة الصحيحة؟', '[{"id":"a","text":"الكتكوت يكبر فيصير دجاجة"},{"id":"b","text":"الدجاجة تصغر فتصير كتكوتًا"},{"id":"c","text":"لا علاقة بينهما"},{"id":"d","text":"الكتكوت يصير بقرة"}]'::jsonb, 'a', 'الكتكوت صغير الدجاجة؛ فهو يكبر فيصير دجاجة. الخطأ الشائع هو عكس النموّ (أن تصغر الدجاجة).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea358620-f1d0-5876-95bd-95eeb942ffb8', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'ثلاثة أشياء: حجر، شتلة (نبتة صغيرة)، كتكوت. أيّها سيكبر بعد مدّة؟', '[{"id":"a","text":"الحجر فقط"},{"id":"b","text":"لا شيء منها"},{"id":"c","text":"الشتلة والكتكوت فقط"},{"id":"d","text":"الحجر والشتلة فقط"}]'::jsonb, 'c', 'الشتلة والكتكوت كائنان حيّان ينموان ويكبران، أمّا الحجر فجماد لا يكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ee4bd48-9602-5c78-b33f-3330dfadff1e', '0a4b1a12-9f5e-51f4-ac44-86bbc4e529c7', 'كيف نرتّب نموّ الإنسان من الأصغر إلى الأكبر؟', '[{"id":"a","text":"شابّ ← طفل ← رضيع ← كهل"},{"id":"b","text":"رضيع ← طفل ← شابّ ← كهل"},{"id":"c","text":"كهل ← شابّ ← طفل ← رضيع"},{"id":"d","text":"طفل ← كهل ← رضيع ← شابّ"}]'::jsonb, 'b', 'النموّ من الصغير إلى الكبير: رضيع ← طفل ← شابّ ← كهل. الخطأ الشائع هو عكس الترتيب أو خلط المراحل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('17138a5a-d046-5c49-a475-686c0b62ce2d', '62977a64-a2b5-58b5-ba5c-059737a2f06b', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ النموّ (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee4418f5-5318-5d79-adde-3fadfecbcc81', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'ما الفرق بين الكائن الحيّ والجماد؟', '[{"id":"a","text":"الكائن الحيّ يكبر وينمو، والجماد يبقى كما هو"},{"id":"b","text":"الجماد يكبر والكائن الحيّ لا يكبر"},{"id":"c","text":"كلاهما لا يتغيّر"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'a', 'الكائن الحيّ (إنسان، حيوان، نبات) يكبر وينمو، أمّا الجماد (حجر، كرسيّ) فيبقى كما هو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b203bfe5-a091-5507-a519-f7cfd287383c', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'ما الذي يدلّ على أنّ الطفل ينمو؟', '[{"id":"a","text":"لونه يتغيّر إلى الأزرق"},{"id":"b","text":"يصير أصغر كلّ سنة"},{"id":"c","text":"يزداد طوله ووزنه"},{"id":"d","text":"يبقى نفس الطول دائمًا"}]'::jsonb, 'c', 'علامة نموّ الطفل أنّه يزداد طولًا ووزنًا مع مرور الوقت.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3379f810-e8ae-51ea-9846-31369f3ca0da', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'ما الترتيب الصحيح من الأصغر إلى الأكبر؟', '[{"id":"a","text":"نبتة كبيرة ← نبتة صغيرة ← بذرة"},{"id":"b","text":"بذرة ← نبتة صغيرة ← نبتة كبيرة"},{"id":"c","text":"نبتة صغيرة ← نبتة كبيرة ← بذرة"},{"id":"d","text":"نبتة كبيرة ← بذرة ← نبتة صغيرة"}]'::jsonb, 'b', 'ينمو النبات من البذرة إلى النبتة الصغيرة ثمّ النبتة الكبيرة، من الأصغر إلى الأكبر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0485c94e-14c8-587a-ad48-849faa10ba34', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'أيّ جملةٍ صحيحة عن نموّ الحيوان؟', '[{"id":"a","text":"الحيوان يولد كبيرًا ثمّ يصغر"},{"id":"b","text":"الحيوان لا يتغيّر أبدًا"},{"id":"c","text":"الكتكوت يصير قطًّا"},{"id":"d","text":"الحيوان يولد صغيرًا ثمّ يكبر ويصير بالغًا"}]'::jsonb, 'd', 'الحيوان يولد صغيرًا ثمّ يكبر مع الوقت حتّى يصير بالغًا مثل أبيه وأمّه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3385d95-7f83-5220-a550-81227cd1cecd', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'وجدنا في الحديقة: حجرًا وشجرة وقطّة. أيّها سيكبر بعد سنوات؟', '[{"id":"a","text":"الشجرة والقطّة"},{"id":"b","text":"الحجر فقط"},{"id":"c","text":"الحجر والشجرة"},{"id":"d","text":"لا شيء"}]'::jsonb, 'a', 'الشجرة والقطّة كائنان حيّان يكبران، أمّا الحجر فجماد لا يكبر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f437b206-4722-50f4-bdb5-4bdbeb6ed0a7', '17138a5a-d046-5c49-a475-686c0b62ce2d', 'لماذا نحتاج إلى طعامٍ ونحن نكبر؟', '[{"id":"a","text":"لأنّنا جماد"},{"id":"b","text":"كي نصغر"},{"id":"c","text":"لأنّنا كائنات حيّة ننمو ونحتاج الغذاء لنكبر"},{"id":"d","text":"لا حاجة للطعام أبدًا"}]'::jsonb, 'c', 'الإنسان كائنٌ حيٌّ ينمو، ويحتاج الغذاء ليكبر ويبقى قويًّا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('348b2ff0-06df-5c34-946b-6ad38b0f0485', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd6f02ac-b2ec-51b4-9e9e-c60d9c647e62', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'كيف تتنقّل السمكة في الماء؟', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالسباحة"},{"id":"c","text":"بالزحف"},{"id":"d","text":"بالقفز"}]'::jsonb, 'b', 'السمكة تعيش في الماء وتتنقّل فيه بالسباحة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c09d0a17-ce41-55b6-b54f-63f77b286ba3', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'العصفور له جناحان. كيف يتنقّل؟', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالزحف"},{"id":"c","text":"بالطيران"},{"id":"d","text":"لا يتحرّك"}]'::jsonb, 'c', 'العصفور يطير في الهواء باستعمال جناحيه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62685c61-684e-5dd5-b9ce-64798d662f03', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'الثعبان ليس له أرجل. كيف يتنقّل؟', '[{"id":"a","text":"بالزحف على بطنه"},{"id":"b","text":"بالطيران"},{"id":"c","text":"بالمشي"},{"id":"d","text":"بالسباحة فقط"}]'::jsonb, 'a', 'الثعبان ليس له أرجل، فهو يزحف على بطنه قريبًا من الأرض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb29af42-583b-56b9-b015-6570aecfb89e', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'أيّ حيوانٍ يتنقّل بالطيران؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الأرنب"},{"id":"c","text":"الثعبان"},{"id":"d","text":"الحمامة"}]'::jsonb, 'd', 'الحمامة لها أجنحة تطير بها في الهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('186e97df-d285-5e20-a42f-39c3f9efe2c1', '348b2ff0-06df-5c34-946b-6ad38b0f0485', 'البطّة حيوانٌ مميّز. ماذا تستطيع أن تفعل؟', '[{"id":"a","text":"تزحف فقط على بطنها"},{"id":"b","text":"تمشي وتسبح وتطير"},{"id":"c","text":"تسبح فقط ولا شيء غير ذلك"},{"id":"d","text":"لا تتحرّك أبدًا"}]'::jsonb, 'b', 'البطّة تتنقّل بأكثر من طريقة: تمشي على الأرض، وتسبح في الماء، وتطير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', '⭐ تمرين: كيف يتنقّل هذا الحيوان؟', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a896ded-fa4b-5cd9-b5a6-d22b4ff6b8be', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'كيف يتنقّل الأرنب؟', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالقفز بأرجله"},{"id":"c","text":"بالطيران"},{"id":"d","text":"بالزحف"}]'::jsonb, 'b', 'الأرنب له أربع أرجل قويّة يقفز بها على الأرض.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9d00ea5-1e13-56b2-86c5-1de167388f64', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'كيف يتنقّل العصفور؟', '[{"id":"a","text":"بالزحف"},{"id":"b","text":"بالسباحة"},{"id":"c","text":"بالطيران"},{"id":"d","text":"بالمشي فقط"}]'::jsonb, 'c', 'العصفور يطير في الهواء بجناحيه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbe27dd8-16b5-5294-bc39-546c7be28549', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'ما الحيوان الذي يتنقّل بالزحف؟', '[{"id":"a","text":"الثعبان"},{"id":"b","text":"الحصان"},{"id":"c","text":"العصفور"},{"id":"d","text":"البطّة"}]'::jsonb, 'a', 'الثعبان ليس له أرجل، فهو يزحف على بطنه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93e093a8-ff31-5434-a023-baa96f6344b4', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'بماذا تطير الحمامة؟', '[{"id":"a","text":"بذيلها"},{"id":"b","text":"بأرجلها"},{"id":"c","text":"ببطنها"},{"id":"d","text":"بجناحيها"}]'::jsonb, 'd', 'الحمامة تطير بجناحيها في الهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21e343f6-1585-5256-9b98-e2f9ee4fe815', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'أيّ حيوانٍ يتنقّل بالسباحة في الماء؟', '[{"id":"a","text":"القطّ"},{"id":"b","text":"الأرنب"},{"id":"c","text":"السمكة"},{"id":"d","text":"الثعبان"}]'::jsonb, 'c', 'السمكة تعيش في الماء وتتنقّل فيه بالسباحة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bd99a7d-1f8e-5484-a939-8242f67d9159', 'd7823ef1-fe8b-5551-b0cc-af80e9ebbd84', 'انظر إلى هذا الحيوان. كيف يتنقّل؟ <svg viewBox="0 0 120 80" xmlns="http://www.w3.org/2000/svg"><g stroke="currentColor" stroke-width="2" fill="#e5e7eb"><path d="M30 40 q26 -22 56 0 q-26 22 -56 0 z"/><path d="M30 40 l-16 -12 l0 24 z"/><circle cx="78" cy="36" r="2.5" fill="currentColor" stroke="none"/></g><line x1="10" y1="68" x2="112" y2="68" stroke="currentColor" stroke-width="2" stroke-dasharray="5 5"/></svg>', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالطيران"},{"id":"c","text":"بالزحف"},{"id":"d","text":"بالقفز"}]'::jsonb, 'a', 'الصورة سمكة لها ذيلٌ وتعيش في الماء، فهي تتنقّل بالسباحة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس التنقّل', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3cfbe065-f095-5a5f-8dc4-318ee1c2f1b8', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'حيوانٌ له جناحان ويعيش في الهواء. كيف يتنقّل؟', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالطيران"},{"id":"c","text":"بالزحف"},{"id":"d","text":"بالمشي فقط"}]'::jsonb, 'b', 'من له جناحان ويعيش في الهواء يتنقّل بالطيران، مثل العصفور.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c12e5b2-1d6b-568a-8670-e10b3061842e', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'أيّ مجموعةٍ كلّها حيوانات تطير؟', '[{"id":"a","text":"السمكة، الأرنب، الثعبان"},{"id":"b","text":"الأرنب، القطّ، الحصان"},{"id":"c","text":"السمكة، الثعبان، الحلزون"},{"id":"d","text":"العصفور، الحمامة"}]'::jsonb, 'd', 'العصفور والحمامة لهما أجنحة فيطيران. أمّا الباقي فلا يطير.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a842e350-82b0-5796-a1e6-830ed992c02a', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'الحلزون يمشي ببطءٍ على بطنه قريبًا من الأرض. كيف نصنّف تنقّله؟', '[{"id":"a","text":"طيران"},{"id":"b","text":"سباحة"},{"id":"c","text":"زحف"},{"id":"d","text":"قفز"}]'::jsonb, 'c', 'الحلزون يتحرّك على بطنه قريبًا من الأرض، وهذا هو الزحف، مثل الثعبان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79be4f57-3962-5e0e-8b81-9f72bc2f86e0', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'قال طفل: «السمكة تطير في الماء». ما الصحيح؟', '[{"id":"a","text":"خطأ، السمكة تسبح في الماء ولا تطير"},{"id":"b","text":"صحيح، السمكة تطير"},{"id":"c","text":"السمكة تزحف في الماء"},{"id":"d","text":"السمكة تمشي في الماء"}]'::jsonb, 'a', 'الخطأ الشائع: الخلط بين الطيران والسباحة. الطيران في الهواء، أمّا السمكة فتسبح في الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('717bc64a-aa2e-5713-99a4-4f9c80d5b760', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'وجدنا حيوانًا له أربع أرجل ويقفز في الحديقة. أيّها يناسب؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الثعبان"},{"id":"c","text":"العصفور"},{"id":"d","text":"الأرنب"}]'::jsonb, 'd', 'الأرنب له أربع أرجل قويّة يقفز بها، فهو يناسب الوصف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20069a38-419e-5d15-bb12-d99e874f0898', 'b4bd9577-dade-5dfd-8da7-7c0fafb00f56', 'البطّة في البِركة تخرج إلى اليابسة وتمشي. ماذا نستنتج؟', '[{"id":"a","text":"البطّة تزحف ولا تمشي"},{"id":"b","text":"البطّة تتنقّل بأكثر من طريقة: تسبح وتمشي (وتطير)"},{"id":"c","text":"البطّة تطير فقط"},{"id":"d","text":"البطّة لا تستطيع السباحة"}]'::jsonb, 'b', 'الخطأ الشائع: الظنّ أنّ كلّ حيوانٍ يتنقّل بطريقةٍ واحدة. البطّة تسبح وتمشي وتطير.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d9615386-657a-5631-bb57-3335d4b79c1b', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: أصنّف تنقّل الحيوانات', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1ccfe24-9ca0-5a08-96ce-18afddbd3364', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'كيف يتنقّل الحصان؟', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالسباحة"},{"id":"c","text":"بالمشي والجري بأرجله"},{"id":"d","text":"بالزحف"}]'::jsonb, 'c', 'الحصان له أربع أرجل يمشي ويجري بها على الأرض.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74aeb754-7b12-5e43-826c-ce65251820b5', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'ما الذي يساعد الطائر على الطيران؟', '[{"id":"a","text":"ذيله"},{"id":"b","text":"جناحاه"},{"id":"c","text":"بطنه"},{"id":"d","text":"أسنانه"}]'::jsonb, 'b', 'الطائر يطير بجناحيه، مثل العصفور والحمامة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05a556d9-f0b2-5e94-bb9b-708fe18df81c', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'أيّ حيوانٍ يتنقّل بالزحف؟', '[{"id":"a","text":"الأرنب"},{"id":"b","text":"العصفور"},{"id":"c","text":"السمكة"},{"id":"d","text":"الثعبان"}]'::jsonb, 'd', 'الثعبان ليس له أرجل، فهو يزحف على بطنه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fd94ced-b5e7-5a1f-b208-c046f2f4d8ea', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'حيوانٌ يعيش في الماء ويتنقّل فيه. كيف يتنقّل؟', '[{"id":"a","text":"بالسباحة"},{"id":"b","text":"بالطيران"},{"id":"c","text":"بالقفز"},{"id":"d","text":"بالمشي"}]'::jsonb, 'a', 'من يعيش في الماء ويتنقّل فيه يسبح، مثل السمكة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12cfd730-8709-51e6-8866-5e6a985bdb0e', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'أيّ مجموعةٍ كلّها حيوانات تمشي بأرجلها؟', '[{"id":"a","text":"السمكة، الثعبان"},{"id":"b","text":"القطّ، الحصان، الأرنب"},{"id":"c","text":"العصفور، الحمامة"},{"id":"d","text":"السمكة، الحلزون"}]'::jsonb, 'b', 'القطّ والحصان والأرنب لها أرجل تمشي وتجري وتقفز بها على الأرض.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29e84b83-483a-5d8d-ab2e-685b06a3c51b', 'd9615386-657a-5631-bb57-3335d4b79c1b', 'انظر إلى هذا الحيوان. كيف يتنقّل؟ <svg viewBox="0 0 130 70" xmlns="http://www.w3.org/2000/svg"><path d="M14 50 q18 -26 36 0 q18 26 36 0 q12 -18 28 -8" fill="none" stroke="currentColor" stroke-width="6" stroke-linecap="round"/><circle cx="116" cy="36" r="2" fill="currentColor" stroke="none"/></svg>', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالسباحة"},{"id":"c","text":"بالزحف على بطنه"},{"id":"d","text":"بالقفز"}]'::jsonb, 'c', 'الصورة ثعبان طويل لا أرجل له، فهو يتنقّل بالزحف على بطنه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل عالم التنقّل', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0f2b703-8433-58f0-ac4e-ed318ce4e84a', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'حيوانٌ يعيش في الماء وله ذيلٌ ولا أرجل له. كيف يتنقّل؟', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالمشي"},{"id":"c","text":"بالسباحة"},{"id":"d","text":"بالقفز"}]'::jsonb, 'c', 'من يعيش في الماء وله ذيلٌ ولا أرجل له يتنقّل بالسباحة، مثل السمكة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba2067bb-88df-5f6b-b143-213a20c5837e', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'أمامك: عصفور، سمكة، ثعبان، أرنب. كم منها يتنقّل بالطيران؟', '[{"id":"a","text":"ثلاثة"},{"id":"b","text":"واحد فقط: العصفور"},{"id":"c","text":"كلّها"},{"id":"d","text":"ولا واحد"}]'::jsonb, 'b', 'العصفور وحده يطير. السمكة تسبح، والثعبان يزحف، والأرنب يقفز.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2f32a0b-f0e9-5f1f-bd3d-8295f6af267f', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'قال طفل: «الثعبان يمشي مثل القطّ». ما الردّ الصحيح؟', '[{"id":"a","text":"صحيح، كلاهما يمشي بأرجله"},{"id":"b","text":"الثعبان يطير والقطّ يمشي"},{"id":"c","text":"كلاهما يزحف"},{"id":"d","text":"خطأ، الثعبان يزحف على بطنه والقطّ يمشي بأرجله"}]'::jsonb, 'd', 'الخطأ الشائع: الخلط بين الزحف والمشي. الثعبان لا أرجل له فيزحف، والقطّ يمشي بأرجله.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a33ece8-cd5d-5146-93b3-8a7a20a6418e', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'البطّة تخرج من الماء وتمشي ثمّ تطير. ماذا نتعلّم منها؟', '[{"id":"a","text":"حيوانٌ واحدٌ قد يتنقّل بأكثر من طريقة"},{"id":"b","text":"كلّ حيوانٍ يتنقّل بطريقةٍ واحدةٍ فقط"},{"id":"c","text":"البطّة تزحف على بطنها"},{"id":"d","text":"البطّة لا تطير أبدًا"}]'::jsonb, 'a', 'الخطأ الشائع: الظنّ أنّ كلّ حيوانٍ له طريقةٌ واحدة. البطّة تسبح وتمشي وتطير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('099d110e-004c-57cd-838e-e909fa83b546', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'أيّ تطابقٍ صحيحٍ تمامًا بين الحيوان وطريقة تنقّله؟', '[{"id":"a","text":"السمكة ← تطير"},{"id":"b","text":"العصفور ← يزحف"},{"id":"c","text":"الأرنب ← يقفز"},{"id":"d","text":"الثعبان ← يسبح في الهواء"}]'::jsonb, 'c', 'الأرنب يقفز بأرجله، وهو التطابق الصحيح. السمكة تسبح، والعصفور يطير، والثعبان يزحف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3b1c085-ed4a-56df-b0c0-b34cda092539', 'cf2ec6c9-b6b9-5b15-9fd1-90018a78e2e7', 'حيوانٌ له أربع أرجل ويعيش في البرّ ويجري بسرعة. أيّها يناسب الوصف؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الحصان"},{"id":"c","text":"الثعبان"},{"id":"d","text":"الحمامة"}]'::jsonb, 'b', 'الحصان له أربع أرجل يعيش في البرّ ويجري بسرعة، فهو يناسب الوصف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'acd3758d-8d53-506a-88f3-2dbd5f21d8ed', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ مراجعة شاملة على التنقّل', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da256338-16c1-54b8-b235-e56a2ed73f3a', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'كيف تتنقّل الحمامة؟', '[{"id":"a","text":"بالزحف"},{"id":"b","text":"بالطيران"},{"id":"c","text":"بالسباحة"},{"id":"d","text":"بالمشي فقط"}]'::jsonb, 'b', 'الحمامة لها أجنحة تطير بها في الهواء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef0e72af-1bca-56b8-93ea-366225d9d9b9', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'أيّ حيوانٍ يتنقّل بالقفز؟', '[{"id":"a","text":"الأرنب"},{"id":"b","text":"السمكة"},{"id":"c","text":"الثعبان"},{"id":"d","text":"العصفور"}]'::jsonb, 'a', 'الأرنب له أرجل قويّة يقفز بها على الأرض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ba18e4f-02a7-5373-b09a-6a53ed6cdab6', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'أيّ مجموعةٍ كلّها حيوانات تزحف؟', '[{"id":"a","text":"الأرنب، الحصان"},{"id":"b","text":"العصفور، الحمامة"},{"id":"c","text":"السمكة، القطّ"},{"id":"d","text":"الثعبان، الحلزون"}]'::jsonb, 'd', 'الثعبان والحلزون يتحرّكان على بطنهما قريبًا من الأرض، وهذا هو الزحف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('094ed7c2-d75e-5124-bcff-acc1eb8e81ec', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'حيوانٌ ليس له أرجل ولا أجنحة، يتحرّك على بطنه. كيف يتنقّل؟', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالقفز"},{"id":"c","text":"بالزحف"},{"id":"d","text":"بالمشي"}]'::jsonb, 'c', 'من لا أرجل له ولا أجنحة ويتحرّك على بطنه يزحف، مثل الثعبان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec56f592-45f2-5e9d-a26b-553bbdd4222e', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'أيّ زوجٍ صحيحٍ بين الحيوان وطريقة تنقّله؟', '[{"id":"a","text":"السمكة ← السباحة"},{"id":"b","text":"العصفور ← الزحف"},{"id":"c","text":"الأرنب ← الطيران"},{"id":"d","text":"الثعبان ← المشي"}]'::jsonb, 'a', 'السمكة تتنقّل بالسباحة في الماء، وهو الزوج الصحيح. الباقي خطأ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7082da6-175a-5b9b-b993-867b2d5c23b5', 'eaf19c91-b53f-5e95-9d32-1d2fdacd33a1', 'أيّ حيوانٍ يستطيع أن يمشي ويسبح ويطير معًا؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الثعبان"},{"id":"c","text":"الأرنب"},{"id":"d","text":"البطّة"}]'::jsonb, 'd', 'البطّة تتنقّل بأكثر من طريقة: تمشي على الأرض، وتسبح في الماء، وتطير.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5160975e-b17e-5dd8-975b-f902a557fcaf', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc6acf37-135e-5979-a448-e53e5454c22f', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'بأيّ عضوٍ نتنفّس؟', '[{"id":"a","text":"العين"},{"id":"b","text":"الأنف"},{"id":"c","text":"اليد"},{"id":"d","text":"الأذن"}]'::jsonb, 'b', 'نتنفّس عن طريق الأنف: ندخل الهواء ونخرجه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f03e3368-bb0c-5ce9-80b4-fb4d54f326ab', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'ماذا نسمّي دخول الهواء إلى داخل الجسم؟', '[{"id":"a","text":"الزفير"},{"id":"b","text":"الشهيق"},{"id":"c","text":"الأكل"},{"id":"d","text":"النوم"}]'::jsonb, 'b', 'الشهيق هو دخول الهواء إلى داخل الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aef52862-070e-50d9-a94c-4ff2b1bd89fd', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'ماذا يحدث للصدر عند الشهيق؟', '[{"id":"a","text":"يبقى ثابتًا لا يتحرّك"},{"id":"b","text":"ينخفض ويصغر"},{"id":"c","text":"يرتفع وينتفخ"},{"id":"d","text":"يختفي"}]'::jsonb, 'c', 'عند الشهيق يمتلئ الصدر بالهواء فيرتفع وينتفخ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa5f38f6-a497-5036-8c92-969c46a07545', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'كيف نتنفّس بعد أن نجري ونلعب كثيرًا؟', '[{"id":"a","text":"بسرعة ونلهث"},{"id":"b","text":"ببطء شديد"},{"id":"c","text":"نتوقّف عن التنفّس"},{"id":"d","text":"لا يتغيّر شيء"}]'::jsonb, 'a', 'بعد الجري واللعب يحتاج جسمنا هواءً أكثر، فنتنفّس بسرعة ونلهث.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31f63f0f-4451-5d0c-bed7-4270c7c400cd', '5160975e-b17e-5dd8-975b-f902a557fcaf', 'هل الحيوانات تتنفّس؟', '[{"id":"a","text":"لا، الإنسان وحده يتنفّس"},{"id":"b","text":"تتنفّس النباتات فقط"},{"id":"c","text":"نعم، الحيوانات تتنفّس مثلنا"},{"id":"d","text":"الأسماك فقط لا تتنفّس"}]'::jsonb, 'c', 'الحيوانات تتنفّس أيضًا وتحتاج إلى الهواء لتبقى حيّة مثلنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', '⭐ تمرين: أتنفّس', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('269dbfe8-b49b-5827-9326-bc61575780f6', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'عن طريق أيّ عضوٍ ندخل الهواء ونخرجه؟', '[{"id":"a","text":"اللسان"},{"id":"b","text":"الأنف"},{"id":"c","text":"العين"},{"id":"d","text":"الرجل"}]'::jsonb, 'b', 'نتنفّس عن طريق الأنف: ندخل الهواء ونخرجه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14185041-c3ab-5327-b103-05ab21644d70', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'إخراج الهواء إلى الخارج نسمّيه:', '[{"id":"a","text":"الشهيق"},{"id":"b","text":"الأكل"},{"id":"c","text":"الزفير"},{"id":"d","text":"الشرب"}]'::jsonb, 'c', 'الزفير هو إخراج الهواء من الجسم إلى الخارج.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de3af131-e549-5968-8640-61c9d464c338', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'في أيّ وقتٍ نتنفّس؟', '[{"id":"a","text":"في كلّ لحظة، حتّى في النوم"},{"id":"b","text":"عند الأكل فقط"},{"id":"c","text":"عند اللعب فقط"},{"id":"d","text":"مرّة واحدة في اليوم"}]'::jsonb, 'a', 'نتنفّس دائمًا في كلّ لحظة، حتّى ونحن نائمون، لنبقى أحياء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0568aa2d-a328-54c8-aea1-01ab83c33474', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'ماذا يحدث للصدر عند الزفير؟', '[{"id":"a","text":"يرتفع وينتفخ"},{"id":"b","text":"يبقى مرتفعًا"},{"id":"c","text":"يكبر أكثر"},{"id":"d","text":"ينخفض ويعود صغيرًا"}]'::jsonb, 'd', 'عند الزفير يخرج الهواء من الصدر فينخفض ويعود صغيرًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae579ff4-7e1f-5047-a08d-e584f2caeb0a', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'كيف نتنفّس ونحن جالسون نرتاح؟', '[{"id":"a","text":"بسرعة كبيرة ونلهث"},{"id":"b","text":"بهدوء وببطء"},{"id":"c","text":"لا نتنفّس أبدًا"},{"id":"d","text":"بأرجلنا"}]'::jsonb, 'b', 'في الراحة نتنفّس بهدوء وببطء لأنّ الجسم لا يحتاج هواءً كثيرًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca591b40-d02d-5b40-95a5-6aa9ffeee25f', 'a872d4e2-d0a6-57b9-b0e8-7aa1b9d2b207', 'أيّ حيوانٍ يتنفّس مثلنا؟', '[{"id":"a","text":"لا حيوان يتنفّس"},{"id":"b","text":"الحجر"},{"id":"c","text":"القطّ"},{"id":"d","text":"الكرسيّ"}]'::jsonb, 'c', 'القطّ حيوانٌ يتنفّس مثلنا ويحتاج إلى الهواء ليبقى حيًّا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('745203dd-7d5a-515d-9443-13c682737452', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس النفَس', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('629cf0d0-c3fe-5f74-94fc-370f55ac0276', '745203dd-7d5a-515d-9443-13c682737452', 'وضع طفلٌ يده على صدره فأحسّ به يرتفع. ماذا يفعل في هذه اللحظة؟', '[{"id":"a","text":"يخرج الهواء (زفير)"},{"id":"b","text":"يأكل"},{"id":"c","text":"يدخل الهواء (شهيق)"},{"id":"d","text":"يتوقّف عن التنفّس"}]'::jsonb, 'c', 'الصدر يرتفع عندما يمتلئ بالهواء، أي عند الشهيق (دخول الهواء).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9c4b74b-8b3f-5ee0-97df-fb06a25e50b1', '745203dd-7d5a-515d-9443-13c682737452', 'قال طفل: «الحيوانات لا تتنفّس». ما الردّ الصحيح؟', '[{"id":"a","text":"صحيح، الإنسان وحده يتنفّس"},{"id":"b","text":"صحيح، الحيوانات لا تحتاج هواءً"},{"id":"c","text":"خطأ، الحيوانات تتنفّس وتحتاج الهواء مثلنا"},{"id":"d","text":"خطأ، النباتات وحدها تتنفّس"}]'::jsonb, 'c', 'الكلام خطأ: الحيوانات تتنفّس أيضًا وتحتاج إلى الهواء لتبقى حيّة مثلنا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49643a1b-8b29-5a41-a622-3c251eb59afb', '745203dd-7d5a-515d-9443-13c682737452', 'الخطأ الشائع هو الخلط بين الشهيق والزفير. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الشهيق إخراج الهواء والصدر ينخفض"},{"id":"b","text":"الشهيق إدخال الهواء والصدر يرتفع"},{"id":"c","text":"الزفير إدخال الهواء والصدر يرتفع"},{"id":"d","text":"الشهيق والزفير شيء واحد"}]'::jsonb, 'b', 'الخطأ الشائع هو عكس الكلمتين. الصحيح: الشهيق إدخال الهواء والصدر يرتفع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bb5591d-2d6f-597d-845e-768a2b9ee2bf', '745203dd-7d5a-515d-9443-13c682737452', 'جرى أحمد في الملعب فصار صدره يرتفع وينخفض بسرعة. لماذا؟', '[{"id":"a","text":"لأنّه توقّف عن التنفّس"},{"id":"b","text":"لأنّه يأكل"},{"id":"c","text":"لأنّه نائم"},{"id":"d","text":"لأنّ جسمه يحتاج هواءً أكثر بعد الجري"}]'::jsonb, 'd', 'بعد الجري يحتاج الجسم هواءً أكثر، فيتنفّس بسرعة ويرتفع الصدر وينخفض بسرعة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e116f7d-6da9-5de8-881f-c50bcb569ec3', '745203dd-7d5a-515d-9443-13c682737452', 'أيّ ترتيبٍ صحيحٍ لما يحدث عند الشهيق؟', '[{"id":"a","text":"يدخل الهواء ← يرتفع الصدر"},{"id":"b","text":"يخرج الهواء ← يرتفع الصدر"},{"id":"c","text":"يخرج الهواء ← ينخفض الصدر"},{"id":"d","text":"يدخل الهواء ← ينخفض الصدر"}]'::jsonb, 'a', 'عند الشهيق يدخل الهواء أوّلًا فيمتلئ الصدر ويرتفع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62b5a971-c42e-50f9-bdb1-28800bf4cc21', '745203dd-7d5a-515d-9443-13c682737452', 'أين نتنفّس هواءً نقيًّا أفضل؟', '[{"id":"a","text":"في غرفة مغلقة مليئة بالدخان"},{"id":"b","text":"في الهواء الطلق بين الأشجار"},{"id":"c","text":"قرب النار والدخان"},{"id":"d","text":"في مكانٍ بلا هواء"}]'::jsonb, 'b', 'الهواء النقيّ النظيف يكون في الهواء الطلق بين الأشجار، وهو الأفضل للتنفّس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: أراجع درس التنفّس', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c06ece7a-eecc-5598-8a23-45c5ae12edf9', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'التنفّس مرّتان: ندخل الهواء وندعوه الشهيق، ونخرجه وندعوه:', '[{"id":"a","text":"الزفير"},{"id":"b","text":"الشهيق"},{"id":"c","text":"الأكل"},{"id":"d","text":"النوم"}]'::jsonb, 'a', 'ندخل الهواء بالشهيق ونخرجه بالزفير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('295935b0-5e8b-59b0-9f6d-8f55eb12d54e', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'ضع يدك أمام أنفك وأخرج الهواء. بماذا تحسّ؟', '[{"id":"a","text":"بالماء يخرج"},{"id":"b","text":"بلا شيء"},{"id":"c","text":"بالهواء يخرج دافئًا"},{"id":"d","text":"بالطعام يخرج"}]'::jsonb, 'c', 'عند الزفير يخرج الهواء من الأنف فنحسّ به دافئًا على يدنا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acc9cce4-21e5-5d78-876b-fd8374569f6a', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'متى يرتفع الصدر؟', '[{"id":"a","text":"عند الزفير"},{"id":"b","text":"عند الشهيق"},{"id":"c","text":"عند النوم فقط"},{"id":"d","text":"لا يرتفع أبدًا"}]'::jsonb, 'b', 'الصدر يرتفع عند الشهيق لأنّه يمتلئ بالهواء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f40d9dd6-b771-535e-b3d1-a92cde2baf8a', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'أيّ هذه الحالات نتنفّس فيها بهدوء وببطء؟', '[{"id":"a","text":"بعد الجري السريع"},{"id":"b","text":"بعد القفز كثيرًا"},{"id":"c","text":"بعد لعب كرة القدم"},{"id":"d","text":"عند الجلوس والراحة"}]'::jsonb, 'd', 'في الراحة والجلوس نتنفّس بهدوء وببطء، أمّا بعد الجري فبسرعة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c516ddb-88d5-56fa-bcbf-7dc9e606bd2d', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'أيّ مجموعةٍ كلّها تتنفّس؟', '[{"id":"a","text":"الحجر، الكرسيّ، الباب"},{"id":"b","text":"الطاولة، القلم، الحجر"},{"id":"c","text":"الإنسان، القطّ، العصفور"},{"id":"d","text":"الكتاب، الكرة، الحذاء"}]'::jsonb, 'c', 'الإنسان والقطّ والعصفور كائنات حيّة تتنفّس، أمّا الأشياء فلا تتنفّس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d64490a4-fbdd-59bd-9441-96aa63a1106a', 'dae8593b-2478-55d6-a5ef-9a7e9e9b4ba5', 'لماذا نفتح النافذة في الغرفة؟', '[{"id":"a","text":"ليدخل الهواء النقيّ النظيف"},{"id":"b","text":"لنتوقّف عن التنفّس"},{"id":"c","text":"ليخرج كلّ الهواء فلا يبقى شيء"},{"id":"d","text":"لأنّنا لا نحتاج الهواء"}]'::jsonb, 'a', 'نفتح النافذة ليدخل الهواء النقيّ النظيف فنتنفّس هواءً جيّدًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل النفَس', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08075f6e-06d8-5a08-9cc5-4c1bc4cf1c6b', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'صدر سعاد ينخفض ويعود صغيرًا. ماذا يحدث الآن؟', '[{"id":"a","text":"تدخل الهواء (شهيق)"},{"id":"b","text":"صدرها ممتلئ بالهواء"},{"id":"c","text":"توقّفت عن التنفّس"},{"id":"d","text":"تخرج الهواء (زفير)"}]'::jsonb, 'd', 'الصدر ينخفض عندما يخرج الهواء منه، أي عند الزفير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c47e682f-586a-5f7b-83eb-21fbbd0b64a6', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'الخطأ الشائع هو عكس الشهيق والزفير. أيّ تطابقٍ صحيحٍ تمامًا؟', '[{"id":"a","text":"شهيق ← يخرج الهواء ← الصدر ينخفض"},{"id":"b","text":"زفير ← يخرج الهواء ← الصدر ينخفض"},{"id":"c","text":"زفير ← يدخل الهواء ← الصدر يرتفع"},{"id":"d","text":"شهيق ← يخرج الهواء ← الصدر يرتفع"}]'::jsonb, 'b', 'الخطأ الشائع هو قلب الكلمتين. الصحيح: الزفير يخرج فيه الهواء فينخفض الصدر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c9011be-756c-5a49-851f-de92caad83d0', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'أيّ ترتيبٍ يصف ما يحدث عند الزفير من البداية إلى النهاية؟', '[{"id":"a","text":"يخرج الهواء ← ينخفض الصدر ← يعود صغيرًا"},{"id":"b","text":"يدخل الهواء ← يرتفع الصدر ← ينتفخ"},{"id":"c","text":"يخرج الهواء ← يرتفع الصدر ← ينتفخ"},{"id":"d","text":"يدخل الهواء ← ينخفض الصدر ← يعود صغيرًا"}]'::jsonb, 'a', 'عند الزفير يخرج الهواء أوّلًا، فينخفض الصدر ويعود صغيرًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73e65a62-d986-59d2-a69e-0bb985f46934', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'طفلان: واحد نائم وواحد انتهى من الجري. من يتنفّس أسرع؟', '[{"id":"a","text":"النائم يتنفّس أسرع"},{"id":"b","text":"كلاهما يتوقّف عن التنفّس"},{"id":"c","text":"الذي انتهى من الجري يتنفّس أسرع"},{"id":"d","text":"كلاهما يتنفّس بالسرعة نفسها"}]'::jsonb, 'c', 'بعد الجري يحتاج الجسم هواءً أكثر، فيتنفّس أسرع من النائم المرتاح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbbbcb4c-6e1e-5f3e-8a6a-40b5cbfa77f9', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'أمامك: إنسان، قطّ، شجرة... لا، حجر. أيّها يتنفّس ليبقى حيًّا؟', '[{"id":"a","text":"الحجر فقط"},{"id":"b","text":"الإنسان والقطّ"},{"id":"c","text":"الحجر والإنسان"},{"id":"d","text":"لا أحد يتنفّس"}]'::jsonb, 'b', 'الإنسان والقطّ كائنان حيّان يتنفّسان، أمّا الحجر فجمادٌ لا يتنفّس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed9392e8-b14f-5b75-b6a6-724355b737c7', '566ad9cd-4c7d-53d0-aeb3-77b6a31b1e97', 'لماذا من الأفضل أن نلعب في الحديقة لا في غرفة مليئة بالدخان؟', '[{"id":"a","text":"لأنّ الدخان هواءٌ نقيّ"},{"id":"b","text":"لأنّنا لا نتنفّس في الحديقة"},{"id":"c","text":"لا فرق بين المكانين"},{"id":"d","text":"لأنّ هواء الحديقة نقيّ ونظيف وأفضل للتنفّس"}]'::jsonb, 'd', 'هواء الحديقة نقيٌّ ونظيف، أمّا الدخان فيلوّث الهواء، لذلك الحديقة أفضل للتنفّس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bb77b11c-f539-532c-ac66-9510eba496a7', 'fd26fe79-721a-5f4a-b4b9-176dbf9c75e7', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ على التنفّس (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea9c85a3-1968-5eae-b70f-22da847ba7a3', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'نتنفّس عن طريق الأنف. ماذا نفعل بالهواء؟', '[{"id":"a","text":"ندخله فقط ولا نخرجه"},{"id":"b","text":"نخرجه فقط ولا ندخله"},{"id":"c","text":"ندخله (شهيق) ونخرجه (زفير)"},{"id":"d","text":"نأكله"}]'::jsonb, 'c', 'في التنفّس ندخل الهواء بالشهيق ونخرجه بالزفير.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('711e7cd1-29db-5679-ba0a-fc0c53035615', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'متى نتنفّس بسرعة ونلهث؟', '[{"id":"a","text":"عند النوم"},{"id":"b","text":"بعد الجري واللعب كثيرًا"},{"id":"c","text":"عند الجلوس الهادئ"},{"id":"d","text":"لا نتنفّس بسرعة أبدًا"}]'::jsonb, 'b', 'بعد الجري واللعب يحتاج الجسم هواءً أكثر، فنتنفّس بسرعة ونلهث.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('831a11e3-47f8-5e86-858a-f3304425242e', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'أيّ كائنٍ من هذه يتنفّس؟', '[{"id":"a","text":"الطاولة"},{"id":"b","text":"الحجر"},{"id":"c","text":"الأرنب"},{"id":"d","text":"الكرسيّ"}]'::jsonb, 'c', 'الأرنب حيوانٌ حيّ يتنفّس، أمّا الطاولة والحجر والكرسيّ فجماد لا يتنفّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4e147d2-623b-5f86-a055-167395826c4b', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'أيّ جملةٍ صحيحة عن الشهيق؟', '[{"id":"a","text":"يدخل الهواء فيرتفع الصدر"},{"id":"b","text":"يخرج الهواء فيرتفع الصدر"},{"id":"c","text":"يدخل الهواء فينخفض الصدر"},{"id":"d","text":"يخرج الهواء فينخفض الصدر"}]'::jsonb, 'a', 'في الشهيق يدخل الهواء فيمتلئ الصدر ويرتفع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c5b7cc7-0f72-59de-b3dd-e86e5de5c5ed', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'أيّ جملةٍ صحيحة عن الزفير؟', '[{"id":"a","text":"يدخل الهواء فيرتفع الصدر"},{"id":"b","text":"يدخل الهواء فينخفض الصدر"},{"id":"c","text":"يخرج الهواء فيرتفع الصدر"},{"id":"d","text":"يخرج الهواء فينخفض الصدر"}]'::jsonb, 'd', 'في الزفير يخرج الهواء من الصدر فينخفض ويعود صغيرًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f441a204-f233-5913-aae9-97c7c89f499c', 'bb77b11c-f539-532c-ac66-9510eba496a7', 'كيف نحافظ على هواءٍ نقيٍّ نتنفّسه؟', '[{"id":"a","text":"نلعب في الهواء الطلق ونفتح النافذة"},{"id":"b","text":"نملأ الغرفة بالدخان"},{"id":"c","text":"نغلق كلّ النوافذ دائمًا"},{"id":"d","text":"نجلس قرب النار والدخان"}]'::jsonb, 'a', 'نحافظ على هواءٍ نقيٍّ باللعب في الهواء الطلق وفتح النافذة ليدخل الهواء النظيف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5c36fc08-f4a6-50dc-85e3-c7c5712537b5', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b98ce4d-ea2c-5169-ba88-14164bf3c0af', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', 'أين توجد الكرة بالنسبة إلى الصندوق؟ <svg viewBox="0 0 110 110" xmlns="http://www.w3.org/2000/svg"><circle cx="55" cy="22" r="14" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="33" y="55" width="44" height="32" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"تحت الصندوق"},{"id":"b","text":"داخل الصندوق"},{"id":"c","text":"فوق الصندوق"},{"id":"d","text":"خلف الصندوق"}]'::jsonb, 'c', 'في الصورة الكرة في الأعلى والصندوق في الأسفل، فالكرة فوق الصندوق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db8a4c7e-31f2-568a-8e18-c21142457d6b', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', 'أيّ شكلٍ على اليسار؟ <svg viewBox="0 0 160 70" xmlns="http://www.w3.org/2000/svg"><polygon points="35,52 22,26 48,26" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><circle cx="125" cy="38" r="14" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"المثلّث"},{"id":"b","text":"الدائرة"},{"id":"c","text":"لا يوجد شكل"},{"id":"d","text":"الاثنان معًا"}]'::jsonb, 'a', 'اليسار هو الجهة المقابلة لليمين. في الصورة المثلّث على اليسار والدائرة على اليمين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c53685d5-cda7-54a1-a33a-c6aa1759a256', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', 'أين توجد الدائرة السوداء بالنسبة إلى الصندوق؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><rect x="25" y="22" width="60" height="50" stroke="#1f2937" stroke-width="2" fill="none"/><circle cx="55" cy="47" r="12" stroke="#1f2937" stroke-width="2" fill="#1f2937"/></svg>', '[{"id":"a","text":"خارج الصندوق"},{"id":"b","text":"فوق الصندوق"},{"id":"c","text":"خلف الصندوق"},{"id":"d","text":"داخل الصندوق"}]'::jsonb, 'd', 'الدائرة السوداء محاطة بجوانب الصندوق، فهي داخل الصندوق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1d2328a-7990-544c-b9d9-e5031001c09b', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', 'أيّ دائرةٍ أكبر؟ <svg viewBox="0 0 160 80" xmlns="http://www.w3.org/2000/svg"><circle cx="42" cy="42" r="30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><circle cx="126" cy="50" r="13" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"الدائرة الصغيرة على اليمين"},{"id":"b","text":"الدائرة الكبيرة على اليسار"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا توجد دائرة كبيرة"}]'::jsonb, 'b', 'الدائرة على اليسار أوسع وأكبر من الدائرة على اليمين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('821843c3-49bf-58f1-a34a-4b197e1e921c', '5c36fc08-f4a6-50dc-85e3-c7c5712537b5', 'أيّ عمودٍ أطول؟ <svg viewBox="0 0 140 100" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="90" x2="130" y2="90" stroke="#1f2937" stroke-width="2"/><rect x="35" y="22" width="22" height="68" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="90" y="58" width="22" height="32" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"العمود القصير على اليمين"},{"id":"b","text":"لا فرق بينهما"},{"id":"c","text":"العمود الطويل على اليسار"},{"id":"d","text":"لا يوجد عمود"}]'::jsonb, 'c', 'العمود على اليسار يرتفع أكثر، فهو أطول وأعلى من العمود على اليمين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('49b9ca98-e7c9-5282-98a2-84559e213f57', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', '⭐ تمرين: أين الشيء؟', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c19d3f9-3543-5308-a9df-044fc8a7887c', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أين توجد النجمة بالنسبة إلى الصندوق؟ <svg viewBox="0 0 110 120" xmlns="http://www.w3.org/2000/svg"><rect x="33" y="20" width="44" height="32" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><polygon points="55,72 61,86 75,86 64,95 68,108 55,100 42,108 46,95 35,86 49,86" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"فوق الصندوق"},{"id":"b","text":"تحت الصندوق"},{"id":"c","text":"داخل الصندوق"},{"id":"d","text":"يمين الصندوق"}]'::jsonb, 'b', 'في الصورة النجمة في الأسفل والصندوق في الأعلى، فالنجمة تحت الصندوق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3b9a6d3-4ad5-5866-ab1c-743e449c0561', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أيّ شكلٍ على اليمين؟ <svg viewBox="0 0 160 70" xmlns="http://www.w3.org/2000/svg"><circle cx="35" cy="38" r="14" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="108" y="24" width="30" height="30" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"الدائرة"},{"id":"b","text":"لا يوجد شكل"},{"id":"c","text":"المربّع"},{"id":"d","text":"الاثنان معًا"}]'::jsonb, 'c', 'اليمين هو الجهة المقابلة لليسار. في الصورة المربّع على اليمين والدائرة على اليسار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fabefb1c-489d-5cc7-8e77-682ab9c43b7e', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أين توجد السمكة بالنسبة إلى الحوض؟ <svg viewBox="0 0 110 90" xmlns="http://www.w3.org/2000/svg"><rect x="22" y="20" width="66" height="52" stroke="#1f2937" stroke-width="2" fill="none"/><g stroke="#1f2937" stroke-width="2" fill="#9ca3af"><path d="M40 46 q14 -12 30 0 q-14 12 -30 0 z"/><polygon points="40,46 30,38 30,54"/></g></svg>', '[{"id":"a","text":"داخل الحوض"},{"id":"b","text":"خارج الحوض"},{"id":"c","text":"فوق الحوض"},{"id":"d","text":"خلف الحوض"}]'::jsonb, 'a', 'السمكة محاطة بجوانب الحوض من كلّ جهة، فهي داخل الحوض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfdd137d-8d52-5f10-bddc-c2ca09e98ab6', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أيّ شجرةٍ قريبةٌ من المنزل؟ <svg viewBox="0 0 200 80" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="66" x2="195" y2="66" stroke="#1f2937" stroke-width="2"/><rect x="24" y="38" width="30" height="28" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><polygon points="39,20 56,38 22,38" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><g stroke="#1f2937" stroke-width="2"><line x1="72" y1="66" x2="72" y2="46"/><circle cx="72" cy="40" r="8" fill="#9ca3af"/></g><g stroke="#1f2937" stroke-width="2"><line x1="178" y1="66" x2="178" y2="46"/><circle cx="178" cy="40" r="8" fill="#9ca3af"/></g></svg>', '[{"id":"a","text":"الشجرة البعيدة على اليمين"},{"id":"b","text":"لا توجد شجرة قريبة"},{"id":"c","text":"الشجرتان قريبتان"},{"id":"d","text":"الشجرة الملاصقة للمنزل"}]'::jsonb, 'd', 'الشجرة الملاصقة للمنزل قريبة منه، أمّا الشجرة الأخرى فبعيدة على الجهة الأخرى.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08888205-c2bc-5051-b587-1e528586d2f8', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أين توجد الدائرة بالنسبة إلى المربّع الكبير؟ <svg viewBox="0 0 140 90" xmlns="http://www.w3.org/2000/svg"><rect x="55" y="14" width="46" height="46" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><circle cx="46" cy="58" r="24" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/></svg>', '[{"id":"a","text":"داخل المربّع"},{"id":"b","text":"أمام المربّع (تغطّي جزءًا منه)"},{"id":"c","text":"تحت المربّع تمامًا"},{"id":"d","text":"بعيدة عن المربّع"}]'::jsonb, 'b', 'الدائرة تغطّي جزءًا من المربّع، فهي أمامه. ما يغطّي غيره يكون في الأمام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('427209d2-cfa1-5261-a9e2-85654f3d6f3e', '49b9ca98-e7c9-5282-98a2-84559e213f57', 'أيّ قلمٍ أقصر؟ <svg viewBox="0 0 140 90" xmlns="http://www.w3.org/2000/svg"><rect x="30" y="42" width="90" height="12" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="30" y="66" width="42" height="12" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"القلم الطويل في الأعلى"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"القلم القصير في الأسفل"},{"id":"d","text":"لا يوجد قلم"}]'::jsonb, 'c', 'القلم في الأسفل أقصر لأنّه أقلّ طولًا من القلم الذي في الأعلى.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2ba9f078-c1e0-521b-8b96-b7f52631a5f6', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس المواقع', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e4270c9-2cf0-561b-a72c-85f73df6744f', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'العصفور فوق الغصن، والقطّ تحت الغصن. أين القطّ بالنسبة إلى العصفور؟', '[{"id":"a","text":"فوقه"},{"id":"b","text":"داخله"},{"id":"c","text":"تحته"},{"id":"d","text":"أمامه"}]'::jsonb, 'c', 'العصفور في الأعلى والقطّ في الأسفل، فالقطّ تحت العصفور. الخطأ الشائع هو الخلط بين فوق وتحت.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0df2c68e-fc8d-5ca7-a660-db09b3a59069', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'أين الدائرة السوداء بالنسبة إلى الصندوق؟ <svg viewBox="0 0 180 90" xmlns="http://www.w3.org/2000/svg"><rect x="30" y="24" width="58" height="48" stroke="#1f2937" stroke-width="2" fill="none"/><circle cx="140" cy="48" r="13" stroke="#1f2937" stroke-width="2" fill="#1f2937"/></svg>', '[{"id":"a","text":"داخل الصندوق"},{"id":"b","text":"فوق الصندوق"},{"id":"c","text":"تحت الصندوق"},{"id":"d","text":"خارج الصندوق"}]'::jsonb, 'd', 'الدائرة السوداء واقعة جانب الصندوق وليست محاطة بجوانبه، فهي خارج الصندوق. الخطأ الشائع هو الخلط بين داخل وخارج.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0411bd04-a779-5102-9f5f-89704e42d82c', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'أيّ الدائرتين أمام الأخرى؟ <svg viewBox="0 0 150 90" xmlns="http://www.w3.org/2000/svg"><circle cx="58" cy="42" r="28" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/><circle cx="96" cy="54" r="24" stroke="#1f2937" stroke-width="2" fill="#1f2937"/></svg>', '[{"id":"a","text":"الدائرة السوداء التي تغطّي الأخرى"},{"id":"b","text":"الدائرة الرماديّة المغطّاة"},{"id":"c","text":"كلتاهما خلف"},{"id":"d","text":"لا توجد دائرة في الأمام"}]'::jsonb, 'a', 'الدائرة السوداء تغطّي جزءًا من الرماديّة، فهي في الأمام والرماديّة خلفها. الخطأ الشائع هو ظنّ أنّ المغطّاة هي الأمام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42fa89e9-108f-55a5-a951-5d184fef9c5d', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'أيّ شجرةٍ أعلى (أطول)؟ <svg viewBox="0 0 150 110" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="98" x2="140" y2="98" stroke="#1f2937" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><line x1="40" y1="98" x2="40" y2="42"/><circle cx="40" cy="34" r="14" fill="#9ca3af"/></g><g stroke="#1f2937" stroke-width="2"><line x1="108" y1="98" x2="108" y2="70"/><circle cx="108" cy="64" r="10" fill="#9ca3af"/></g></svg>', '[{"id":"a","text":"الشجرة القصيرة على اليمين"},{"id":"b","text":"الشجرة الطويلة على اليسار"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا توجد شجرة عالية"}]'::jsonb, 'b', 'الشجرة على اليسار تصل إلى ارتفاعٍ أعلى، فهي الأطول والأعلى. الخطأ الشائع هو الخلط بين أعلى وأوطأ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2ee472a-16c8-57d6-9c4c-8cfcdf72b7de', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'كرةٌ داخل صندوق، وكرةٌ فوق الصندوق. أين توجد الكرة التي ليست داخله؟', '[{"id":"a","text":"تحت الصندوق"},{"id":"b","text":"داخل الصندوق أيضًا"},{"id":"c","text":"خلف الصندوق"},{"id":"d","text":"فوق الصندوق"}]'::jsonb, 'd', 'كرةٌ ذُكر أنّها داخل الصندوق، والأخرى فوقه. فالكرة التي ليست داخله هي التي فوق الصندوق. الخطأ الشائع هو الخلط بين داخل وفوق.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('767421b3-737c-56e3-88c7-298311dd79ac', '2ba9f078-c1e0-521b-8b96-b7f52631a5f6', 'أيّ الشكلين أصغر؟ <svg viewBox="0 0 160 80" xmlns="http://www.w3.org/2000/svg"><rect x="18" y="14" width="52" height="52" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="110" y="38" width="24" height="24" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"المربّع الكبير على اليسار"},{"id":"b","text":"المربّع الصغير على اليمين"},{"id":"c","text":"هما متساويان"},{"id":"d","text":"لا يوجد مربّع صغير"}]'::jsonb, 'b', 'المربّع على اليمين أقلّ اتّساعًا، فهو الأصغر. الخطأ الشائع هو الخلط بين أكبر وأصغر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('750d65d7-e756-5366-afb7-d580126d0cfb', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: المواقع والمقارنات', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abff07eb-7ace-53c9-bbf3-c48fb52b6a2e', '750d65d7-e756-5366-afb7-d580126d0cfb', 'القلم فوق المكتب. أين المكتب بالنسبة إلى القلم؟', '[{"id":"a","text":"فوقه"},{"id":"b","text":"تحته"},{"id":"c","text":"داخله"},{"id":"d","text":"أمامه"}]'::jsonb, 'b', 'إذا كان القلم فوق المكتب، فالمكتب تحت القلم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('415c6e98-f18e-5b31-a8b8-66e64f7e83f2', '750d65d7-e756-5366-afb7-d580126d0cfb', 'أين توجد الكرة بالنسبة إلى الكرسيّ؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2" fill="none"><rect x="40" y="34" width="40" height="8"/><line x1="44" y1="42" x2="44" y2="86"/><line x1="76" y1="42" x2="76" y2="86"/><line x1="76" y1="34" x2="76" y2="14"/></g><circle cx="60" cy="100" r="12" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/></svg>', '[{"id":"a","text":"تحت الكرسيّ"},{"id":"b","text":"فوق الكرسيّ"},{"id":"c","text":"خلف الكرسيّ"},{"id":"d","text":"يمين الكرسيّ"}]'::jsonb, 'a', 'الكرة في الأسفل بين أرجل الكرسيّ، فهي تحت الكرسيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9671a08e-b37d-5337-8cfb-b149e4c1f619', '750d65d7-e756-5366-afb7-d580126d0cfb', 'أيّ بيتٍ بعيدٌ عن الطفل؟ <svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="76" x2="195" y2="76" stroke="#1f2937" stroke-width="2"/><g stroke="#1f2937" stroke-width="2" fill="none"><circle cx="40" cy="50" r="7"/><line x1="40" y1="57" x2="40" y2="74"/></g><rect x="58" y="48" width="28" height="28" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="160" y="48" width="28" height="28" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"البيت القريب من الطفل"},{"id":"b","text":"الطفل نفسه"},{"id":"c","text":"البيتان قريبان"},{"id":"d","text":"البيت البعيد على اليمين"}]'::jsonb, 'd', 'الطفل على اليسار، والبيت على اليمين بعيدٌ عنه، أمّا البيت الملاصق له فقريب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe5e1493-78a4-541a-84dc-f3044fc94253', '750d65d7-e756-5366-afb7-d580126d0cfb', 'أيّ كأسٍ فيه ماءٌ أعلى (أكثر ارتفاعًا)؟ <svg viewBox="0 0 150 100" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="2" fill="none"><rect x="30" y="20" width="34" height="70"/><rect x="96" y="20" width="34" height="70"/></g><rect x="32" y="34" width="30" height="54" fill="#9ca3af" stroke="none"/><rect x="98" y="66" width="30" height="22" fill="#9ca3af" stroke="none"/></svg>', '[{"id":"a","text":"الكأس القليل على اليمين"},{"id":"b","text":"الكأسان متساويان"},{"id":"c","text":"الكأس الممتلئ على اليسار"},{"id":"d","text":"لا يوجد ماء"}]'::jsonb, 'c', 'الماء في الكأس على اليسار يصل إلى ارتفاعٍ أعلى، فهو الأكثر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a8230da-9bd3-5fe8-80b8-af2b65a99222', '750d65d7-e756-5366-afb7-d580126d0cfb', 'في صفّ المدرسة، سعيد أمام أمين. من خلف سعيد؟', '[{"id":"a","text":"أمين"},{"id":"b","text":"سعيد نفسه"},{"id":"c","text":"لا أحد"},{"id":"d","text":"المعلّم فقط"}]'::jsonb, 'a', 'إذا كان سعيد أمام أمين، فأمين خلف سعيد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9c5631d-0ee5-5833-8c7a-759a586952fb', '750d65d7-e756-5366-afb7-d580126d0cfb', 'أيّ خطٍّ أطول؟ <svg viewBox="0 0 150 80" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="34" x2="130" y2="34" stroke="#1f2937" stroke-width="3"/><line x1="20" y1="58" x2="68" y2="58" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"الخطّ القصير في الأسفل"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"لا يوجد خطّ"},{"id":"d","text":"الخطّ الطويل في الأعلى"}]'::jsonb, 'd', 'الخطّ في الأعلى يمتدّ أكثر، فهو أطول من الخطّ الذي في الأسفل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('13f5fa65-dabf-5b52-8c38-b7f1652fe639', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل عالم المواقع', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fca52412-4577-504b-978e-23de1b3ef009', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'صف موقع كلّ شكل. أين النجمة، وأين الدائرة، بالنسبة إلى الصندوق؟ <svg viewBox="0 0 130 140" xmlns="http://www.w3.org/2000/svg"><polygon points="65,12 71,26 86,26 74,35 78,48 65,40 52,48 56,35 44,26 59,26" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="40" y="58" width="50" height="36" stroke="#1f2937" stroke-width="2" fill="none"/><circle cx="65" cy="118" r="13" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/></svg>', '[{"id":"a","text":"النجمة تحت الصندوق والدائرة فوقه"},{"id":"b","text":"كلاهما داخل الصندوق"},{"id":"c","text":"النجمة فوق الصندوق والدائرة تحته"},{"id":"d","text":"النجمة يمين الصندوق والدائرة يساره"}]'::jsonb, 'c', 'النجمة في الأعلى فهي فوق الصندوق، والدائرة في الأسفل فهي تحته. الخطأ الشائع هو عكس فوق وتحت.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('866a7f37-4e5e-541f-8c86-20afcc42006a', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'ثلاث كرات في صفّ: الكبيرة على اليسار، والوسطى، والصغيرة على اليمين. أيّ كرةٍ أكبر من الوسطى؟ <svg viewBox="0 0 170 70" xmlns="http://www.w3.org/2000/svg"><circle cx="34" cy="40" r="24" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><circle cx="92" cy="44" r="16" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><circle cx="140" cy="48" r="9" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"الكرة الكبيرة على اليسار"},{"id":"b","text":"الكرة الصغيرة على اليمين"},{"id":"c","text":"لا توجد كرة أكبر"},{"id":"d","text":"الكرات كلّها متساوية"}]'::jsonb, 'a', 'الكرة على اليسار أوسع من الوسطى، فهي أكبر منها. الخطأ الشائع هو ظنّ أنّ الصغيرة على اليمين هي الأكبر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b288b2f-45a1-59c9-8b87-0e812e8844cd', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'قال طفل: «الكتاب داخل المحفظة، إذن المحفظة داخل الكتاب». ما الخطأ في كلامه؟', '[{"id":"a","text":"لا خطأ، الكلام صحيح"},{"id":"b","text":"الكتاب فوق المحفظة"},{"id":"c","text":"المحفظة والكتاب متساويان"},{"id":"d","text":"الكبير لا يدخل في الصغير: المحفظة تحوي الكتاب، لا العكس"}]'::jsonb, 'd', 'الكتاب داخل المحفظة لأنّ المحفظة أكبر وتحويه؛ ولا يمكن أن تكون المحفظة الكبيرة داخل الكتاب الصغير. الخطأ الشائع هو عكس داخل وخارج.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02b6fcc4-437e-5a3a-8349-cf4558a493f8', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'أين الدائرة السوداء بالنسبة إلى الخطّ، وأين الدائرة الرماديّة؟ <svg viewBox="0 0 150 90" xmlns="http://www.w3.org/2000/svg"><line x1="15" y1="45" x2="135" y2="45" stroke="#1f2937" stroke-width="2"/><circle cx="55" cy="22" r="12" stroke="#1f2937" stroke-width="2" fill="#1f2937"/><circle cx="95" cy="68" r="12" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/></svg>', '[{"id":"a","text":"كلتاهما فوق الخطّ"},{"id":"b","text":"السوداء فوق الخطّ والرماديّة تحته"},{"id":"c","text":"السوداء تحت الخطّ والرماديّة فوقه"},{"id":"d","text":"كلتاهما تحت الخطّ"}]'::jsonb, 'b', 'الدائرة السوداء في الأعلى فهي فوق الخطّ، والرماديّة في الأسفل فهي تحته. الخطأ الشائع هو الخلط بين فوق وتحت لكلّ دائرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c91d2420-5869-5a94-83a3-d13dbf1da394', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'في صورة: شجرةٌ طويلة وبجانبها شجيرةٌ قصيرة. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الشجيرة أعلى من الشجرة"},{"id":"b","text":"الشجرتان متساويتان في الطول"},{"id":"c","text":"الشجرة أطول وأعلى، والشجيرة أقصر وأوطأ"},{"id":"d","text":"الشجرة أقصر من الشجيرة"}]'::jsonb, 'c', 'الشجرة الطويلة أعلى، والشجيرة القصيرة أوطأ. الخطأ الشائع هو الخلط بين أطول وأقصر أو بين أعلى وأوطأ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adabc82b-0222-5b94-9c3b-66896f4cc79e', '13f5fa65-dabf-5b52-8c38-b7f1652fe639', 'قطٌّ خلف الباب وكلبٌ أمام الباب. أنت تقف عند الكلب. أيّهما تراه أوّلًا؟', '[{"id":"a","text":"الكلب، لأنّه أمام الباب قريبٌ منك"},{"id":"b","text":"القطّ، لأنّه خلف الباب"},{"id":"c","text":"لا أرى شيئًا"},{"id":"d","text":"الباب يختفي"}]'::jsonb, 'a', 'أنت عند الكلب وهو أمام الباب، فتراه أوّلًا؛ أمّا القطّ فخلف الباب مختفٍ عنك. الخطأ الشائع هو الخلط بين أمام وخلف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9e6f9d1a-5379-5212-b8d1-c6818332045e', '3ed5189a-ea41-530c-9617-e664af6f607e', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ المواقع والمقارنات (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16030d28-1dbd-5b65-987d-a0336adfd3e1', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'ما عكس كلمة «فوق»؟', '[{"id":"a","text":"أمام"},{"id":"b","text":"تحت"},{"id":"c","text":"يمين"},{"id":"d","text":"قرب"}]'::jsonb, 'b', 'عكس فوق هو تحت: فوق في الأعلى، وتحت في الأسفل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52b2aec1-4079-5854-9315-189d385802b7', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'ما عكس كلمة «داخل»؟', '[{"id":"a","text":"أعلى"},{"id":"b","text":"أطول"},{"id":"c","text":"خارج"},{"id":"d","text":"يسار"}]'::jsonb, 'c', 'عكس داخل هو خارج: داخل في الدّاخل، وخارج في الخارج.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25f155be-a82b-52e6-be3f-1c4103d2f165', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'أين النجمة بالنسبة إلى الصندوق؟ <svg viewBox="0 0 130 90" xmlns="http://www.w3.org/2000/svg"><rect x="30" y="24" width="54" height="46" stroke="#1f2937" stroke-width="2" fill="none"/><polygon points="57,30 61,40 72,40 63,47 66,58 57,51 48,58 51,47 42,40 53,40" stroke="#1f2937" stroke-width="2" fill="#1f2937"/></svg>', '[{"id":"a","text":"داخل الصندوق"},{"id":"b","text":"خارج الصندوق"},{"id":"c","text":"فوق الصندوق"},{"id":"d","text":"تحت الصندوق"}]'::jsonb, 'a', 'النجمة محاطة بجوانب الصندوق، فهي داخل الصندوق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49fb47a0-0c46-5fd0-ba48-be60466395f1', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'أيّ شكلٍ أكبر؟ <svg viewBox="0 0 150 80" xmlns="http://www.w3.org/2000/svg"><rect x="16" y="40" width="24" height="24" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="86" y="14" width="52" height="52" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/></svg>', '[{"id":"a","text":"المربّع الصغير على اليسار"},{"id":"b","text":"هما متساويان"},{"id":"c","text":"لا يوجد مربّع كبير"},{"id":"d","text":"المربّع الكبير على اليمين"}]'::jsonb, 'd', 'المربّع على اليمين أوسع، فهو الأكبر، والمربّع على اليسار أصغر منه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d310dc6-62fa-55fd-a515-1d774c6921f6', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'أين القلم بالنسبة إلى الكتاب؟ <svg viewBox="0 0 150 90" xmlns="http://www.w3.org/2000/svg"><rect x="30" y="30" width="50" height="38" stroke="#1f2937" stroke-width="2" fill="#e5e7eb"/><rect x="96" y="42" width="40" height="10" stroke="#1f2937" stroke-width="2" fill="#9ca3af"/></svg>', '[{"id":"a","text":"يسار الكتاب"},{"id":"b","text":"يمين الكتاب"},{"id":"c","text":"فوق الكتاب"},{"id":"d","text":"تحت الكتاب"}]'::jsonb, 'b', 'القلم على الجهة اليمنى من الكتاب، فهو يمين الكتاب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c18a8e37-8a64-5584-b11b-31f2247d232f', '9e6f9d1a-5379-5212-b8d1-c6818332045e', 'بيتٌ قريبٌ منك وبيتٌ بعيد. إلى أيّهما تصل أسرع مشيًا؟', '[{"id":"a","text":"البيت البعيد"},{"id":"b","text":"لا فرق بينهما"},{"id":"c","text":"البيت القريب"},{"id":"d","text":"لا أصل إلى أيّ بيت"}]'::jsonb, 'c', 'البيت القريب أقصر مسافةً، فتصل إليه أسرع من البيت البعيد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3f5aacec-be92-5599-bf37-253d3cfa4495', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('174b1519-4dab-5ade-a5ce-4ccecc04e904', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'متى تكون الشمس في السماء ويصير الجوّ مضيئًا؟', '[{"id":"a","text":"في النهار"},{"id":"b","text":"في الليل"},{"id":"c","text":"عند النوم"},{"id":"d","text":"لا وقت"}]'::jsonb, 'a', 'في النهار تكون الشمس في السماء فيصير الجوّ مضيئًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07193cce-2acd-53ab-a989-8d2cce09ad61', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'ماذا نرى في السماء في الليل؟', '[{"id":"a","text":"الشمس فقط"},{"id":"b","text":"القمر والنجوم"},{"id":"c","text":"لا شيء أبدًا"},{"id":"d","text":"المدرسة"}]'::jsonb, 'b', 'في الليل تغيب الشمس ويظهر القمر والنجوم ويصير الجوّ مظلمًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da64eb0b-e7e9-55d4-914f-0aaf2a9507fe', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'ما أوّل لحظةٍ في اليوم نستيقظ فيها؟', '[{"id":"a","text":"الليل"},{"id":"b","text":"المساء"},{"id":"c","text":"الصباح"},{"id":"d","text":"الظهر"}]'::jsonb, 'c', 'الصباح أوّل النهار، وفيه نستيقظ من النوم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc52b3fd-1ee7-52eb-a98e-b40757e316e2', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'كم عدد أيّام الأسبوع؟', '[{"id":"a","text":"5 أيّام"},{"id":"b","text":"10 أيّام"},{"id":"c","text":"3 أيّام"},{"id":"d","text":"7 أيّام"}]'::jsonb, 'd', 'الأسبوع 7 أيّام: الاثنين والثلاثاء والأربعاء والخميس والجمعة والسبت والأحد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3ab0a3a-373d-5fe4-9ee8-75984cdfb447', '3f5aacec-be92-5599-bf37-253d3cfa4495', 'أيّ هذه الأعمال مدّته قصيرة؟', '[{"id":"a","text":"تصفيقة واحدة بأيدينا"},{"id":"b","text":"يوم كامل"},{"id":"c","text":"أسبوع كامل"},{"id":"d","text":"النوم كلّ الليل"}]'::jsonb, 'a', 'التصفيقة تدوم وقتًا قصيرًا، أمّا اليوم والأسبوع والنوم فمدّتها طويلة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b65ac10b-432b-5f12-8927-a48cde89dc32', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', '⭐ تمرين: النهار والليل ولحظات اليوم', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08994c8b-9274-524b-9896-e67a77f68508', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'متى ننام عادةً؟', '[{"id":"a","text":"في النهار"},{"id":"b","text":"في الصباح"},{"id":"c","text":"في الليل"},{"id":"d","text":"عند الظهر"}]'::jsonb, 'c', 'في الليل يصير الجوّ مظلمًا فننام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8ed5544-dd26-5ee6-a976-356da6d9b541', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'أيّ نجمٍ نراه في النهار يضيء السماء؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"القمر"},{"id":"c","text":"المصباح"},{"id":"d","text":"النجوم"}]'::jsonb, 'a', 'في النهار تضيء الشمس السماء، أمّا القمر فنراه في الليل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02832354-eca4-521a-ad1f-a8e68b60d030', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'في الظهر، وسط النهار، ماذا نأكل؟', '[{"id":"a","text":"نشرب الحليب فقط"},{"id":"b","text":"الغداء"},{"id":"c","text":"لا نأكل"},{"id":"d","text":"ننام"}]'::jsonb, 'b', 'الظهر وسط النهار، وفيه نأكل الغداء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21432594-79bb-51ba-8e4d-ee75dd7d10cf', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'ما اللحظة التي تأتي قبل الليل مباشرةً؟', '[{"id":"a","text":"الصباح"},{"id":"b","text":"الظهر"},{"id":"c","text":"النهار التالي"},{"id":"d","text":"المساء"}]'::jsonb, 'd', 'ترتيب اللحظات: الصباح ثمّ الظهر ثمّ المساء ثمّ الليل، فالمساء قبل الليل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39c2007b-fc91-57ec-a5ea-7b6af84de5df', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'أيّ هذه نراه في الليل؟', '[{"id":"a","text":"القمر"},{"id":"b","text":"الشمس الساطعة"},{"id":"c","text":"ضياء النهار"},{"id":"d","text":"شمس الظهر"}]'::jsonb, 'a', 'في الليل نرى القمر والنجوم، وتغيب الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e706b869-a2ab-5f6a-bbc0-9ae91850043e', 'b65ac10b-432b-5f12-8927-a48cde89dc32', 'ما أوّل عملٍ نقوم به في الصباح؟', '[{"id":"a","text":"ننام"},{"id":"b","text":"نستيقظ"},{"id":"c","text":"نأكل العشاء"},{"id":"d","text":"نرى القمر"}]'::jsonb, 'b', 'في الصباح نستيقظ أوّلًا، ثمّ نذهب إلى المدرسة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a5041e8-ab21-5488-abee-7fa9cb69950e', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الزمن', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('891ebc92-8c18-5b7a-8d95-16932c0c6dff', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'قال طفلٌ: «ننام أوّلًا في الصباح ثمّ نستيقظ في الليل». ما الخطأ؟', '[{"id":"a","text":"نستيقظ في الصباح وننام في الليل، لا العكس"},{"id":"b","text":"لا خطأ، العبارة صحيحة"},{"id":"c","text":"يجب أن ننام في النهار دائمًا"},{"id":"d","text":"الصباح والليل نفس الشيء"}]'::jsonb, 'a', 'الفخّ الشائع هو قلب الترتيب: الصحيح أن نستيقظ في الصباح وننام في الليل، لا العكس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ee1db43-0a97-564e-8e70-b9e62a54aa70', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'نستيقظ ونذهب إلى المدرسة، ثمّ نأكل، ثمّ ننام. ما العمل الأخير في اليوم؟', '[{"id":"a","text":"نستيقظ"},{"id":"b","text":"ننام"},{"id":"c","text":"نذهب إلى المدرسة"},{"id":"d","text":"نأكل الفطور"}]'::jsonb, 'b', 'في آخر اليوم ننام، وهو آخر عملٍ بعد الاستيقاظ والمدرسة والأكل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('431b438c-ed06-585a-8279-ce50dca147af', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'ما الترتيب الصحيح للحظات اليوم؟', '[{"id":"a","text":"الليل ← المساء ← الظهر ← الصباح"},{"id":"b","text":"الظهر ← الصباح ← الليل ← المساء"},{"id":"c","text":"الصباح ← الظهر ← المساء ← الليل"},{"id":"d","text":"المساء ← الصباح ← الظهر ← الليل"}]'::jsonb, 'c', 'تأتي اللحظات بترتيب ثابت: الصباح ثمّ الظهر ثمّ المساء ثمّ الليل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97030cf3-2983-557d-a78b-c515a289d1d8', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'الجوّ مظلم ونرى القمر والنجوم. أيّ وقتٍ هذا؟', '[{"id":"a","text":"الصباح"},{"id":"b","text":"الظهر"},{"id":"c","text":"لا يمكن معرفة ذلك"},{"id":"d","text":"الليل"}]'::jsonb, 'd', 'الظلام والقمر والنجوم كلّها علامات الليل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0916f908-10cd-5c5a-b1c8-e228378782ec', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'كم يومًا في الأسبوع، وما أوّلها في الترتيب؟', '[{"id":"a","text":"7 أيّام، أوّلها الاثنين"},{"id":"b","text":"5 أيّام، أوّلها الأحد"},{"id":"c","text":"7 أيّام، أوّلها الجمعة"},{"id":"d","text":"10 أيّام، أوّلها السبت"}]'::jsonb, 'a', 'الأسبوع 7 أيّام بالترتيب: الاثنين أوّلها ثمّ الثلاثاء فالأربعاء فالخميس فالجمعة فالسبت فالأحد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2dc42dd-103b-5dcd-b440-220cc821b0b8', '9a5041e8-ab21-5488-abee-7fa9cb69950e', 'أيّ هذه العبارات صحيحة عن المدّة؟', '[{"id":"a","text":"التصفيقة أطول من يومٍ كامل"},{"id":"b","text":"اليوم والأسبوع مدّتهما قصيرة جدًّا"},{"id":"c","text":"النوم كلّ الليل أطول من إغماض العين لحظة"},{"id":"d","text":"الأسبوع أقصر من تصفيقة"}]'::jsonb, 'c', 'النوم ليلةً كاملة مدّةٌ طويلة، وإغماض العين مدّةٌ قصيرة، فالنوم أطول.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('124e4093-9b3c-5854-a21c-78eff4543c23', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: اليوم والأسبوع', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6dd51389-6b7b-5a95-998a-7089153573f1', '124e4093-9b3c-5854-a21c-78eff4543c23', 'في النهار تكون الشمس في السماء. ماذا يصير الجوّ؟', '[{"id":"a","text":"مظلمًا"},{"id":"b","text":"مضيئًا"},{"id":"c","text":"فيه نجوم"},{"id":"d","text":"فيه قمر"}]'::jsonb, 'b', 'وجود الشمس في النهار يجعل الجوّ مضيئًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90c14001-7347-5d07-8fc5-1b69654f7e37', '124e4093-9b3c-5854-a21c-78eff4543c23', 'ما اللحظة التي تأتي بعد الصباح مباشرةً؟', '[{"id":"a","text":"الليل"},{"id":"b","text":"المساء"},{"id":"c","text":"صباح الغد"},{"id":"d","text":"الظهر"}]'::jsonb, 'd', 'بعد الصباح يأتي الظهر حسب ترتيب لحظات اليوم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f07878c2-3aa6-59c7-a8d3-0c094c51d34b', '124e4093-9b3c-5854-a21c-78eff4543c23', 'بعد يوم اليوم، أيّ يومٍ يأتي؟', '[{"id":"a","text":"يومٌ جديد (غدًا)"},{"id":"b","text":"نفس اليوم لا يتغيّر"},{"id":"c","text":"لا يأتي يوم"},{"id":"d","text":"أمس"}]'::jsonb, 'a', 'اليوم وحدة زمنية، وبعد كلّ يومٍ يأتي يومٌ جديد هو الغد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1dadd40a-d02b-5eb5-91ca-c07decb413b2', '124e4093-9b3c-5854-a21c-78eff4543c23', 'أيّ هذه الأيّام من أيّام الأسبوع؟', '[{"id":"a","text":"الصباح"},{"id":"b","text":"الظهر"},{"id":"c","text":"الجمعة"},{"id":"d","text":"الليل"}]'::jsonb, 'c', 'الجمعة يومٌ من أيّام الأسبوع السبعة، أمّا الصباح والظهر والليل فهي لحظاتٌ في اليوم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('863915cb-ac46-5b89-81d2-f46caed381d6', '124e4093-9b3c-5854-a21c-78eff4543c23', 'أيّ هذه مدّته طويلة؟', '[{"id":"a","text":"نفخة شمعة"},{"id":"b","text":"أسبوع كامل"},{"id":"c","text":"قفزة واحدة"},{"id":"d","text":"تصفيقة"}]'::jsonb, 'b', 'الأسبوع الكامل مدّةٌ طويلة، أمّا النفخة والقفزة والتصفيقة فمدّتها قصيرة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5e1d19f-677b-5bb6-9f72-cd348b8f10a6', '124e4093-9b3c-5854-a21c-78eff4543c23', 'ما اليوم الذي يأتي بعد الأحد ليبدأ أسبوعٌ جديد؟', '[{"id":"a","text":"الجمعة"},{"id":"b","text":"السبت"},{"id":"c","text":"الخميس"},{"id":"d","text":"الاثنين"}]'::jsonb, 'd', 'بعد الأحد يبدأ أسبوعٌ جديد بالاثنين من جديد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b82fd46b-6422-5076-8157-a936d77db82e', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الزمن', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7fd4fe8-766b-5abe-b6e0-ebda5cdcb51b', 'b82fd46b-6422-5076-8157-a936d77db82e', 'وصف طفلٌ وقتًا: «الجوّ مظلم، القمر في السماء، الناس نائمون». أيّ وقتٍ يصف؟', '[{"id":"a","text":"الصباح"},{"id":"b","text":"الظهر"},{"id":"c","text":"الليل"},{"id":"d","text":"وسط النهار"}]'::jsonb, 'c', 'الظلام والقمر والنوم كلّها علامات الليل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5bb896b-7ace-5143-9598-74093ea23443', 'b82fd46b-6422-5076-8157-a936d77db82e', 'قال طفل: «الصباح يأتي بعد الليل، ثمّ نأكل الغداء عند الظهر». رتّب يومه: نستيقظ، نأكل الغداء، ننام. ما الترتيب الصحيح؟', '[{"id":"a","text":"نأكل الغداء ← ننام ← نستيقظ"},{"id":"b","text":"نستيقظ ← نأكل الغداء ← ننام"},{"id":"c","text":"ننام ← نستيقظ ← نأكل الغداء"},{"id":"d","text":"نأكل الغداء ← نستيقظ ← ننام"}]'::jsonb, 'b', 'في اليوم نستيقظ أوّلًا في الصباح، ثمّ نأكل الغداء عند الظهر، وآخرًا ننام في الليل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26d70cc3-0eb7-57c6-880d-20c7d8cc7659', 'b82fd46b-6422-5076-8157-a936d77db82e', 'قال طفل: «أيّام الأسبوع 5 فقط». لماذا هذا غير صحيح؟', '[{"id":"a","text":"لأنّها 3 أيّام فقط"},{"id":"b","text":"لأنّها 10 أيّام"},{"id":"c","text":"لأنّ الأسبوع فصلٌ من فصول السنة"},{"id":"d","text":"لأنّ أيّام الأسبوع 7 لا 5"}]'::jsonb, 'd', 'الأسبوع 7 أيّام لا 5: الاثنين والثلاثاء والأربعاء والخميس والجمعة والسبت والأحد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b4f940b-f5ee-52c9-89e0-07c484dba278', 'b82fd46b-6422-5076-8157-a936d77db82e', 'خطأ شائع: قال طفل «المساء يأتي قبل الظهر». ما الصحيح؟', '[{"id":"a","text":"الظهر يأتي قبل المساء"},{"id":"b","text":"المساء يأتي قبل الصباح"},{"id":"c","text":"المساء والظهر نفس اللحظة"},{"id":"d","text":"لا ترتيب للحظات"}]'::jsonb, 'a', 'الفخّ الشائع هو قلب الترتيب: الصحيح أنّ الظهر يأتي قبل المساء (الصباح ← الظهر ← المساء ← الليل).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13160121-5a28-5446-82e9-1c2319288b24', 'b82fd46b-6422-5076-8157-a936d77db82e', 'أردنا اختيار عملٍ مدّته قصيرة جدًّا من بين هذه. ما هو؟', '[{"id":"a","text":"النوم كلّ الليل"},{"id":"b","text":"إغماض العين لحظة"},{"id":"c","text":"يوم كامل"},{"id":"d","text":"أسبوع كامل"}]'::jsonb, 'b', 'إغماض العين لحظة مدّته قصيرة جدًّا، أمّا النوم والليل واليوم والأسبوع فمدّتها طويلة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c4017cc-7a82-5e8c-af83-3f376baad912', 'b82fd46b-6422-5076-8157-a936d77db82e', 'إذا كان اليوم هو الخميس، فأيّ يومٍ يأتي بعده مباشرةً؟', '[{"id":"a","text":"الأربعاء"},{"id":"b","text":"الاثنين"},{"id":"c","text":"الجمعة"},{"id":"d","text":"الأحد"}]'::jsonb, 'c', 'حسب ترتيب الأسبوع، يأتي بعد الخميس يوم الجمعة مباشرةً.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'e44362de-d055-5aaa-994a-65de62559675', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ مراجعة شاملة للزمن', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d9263cc-3232-5773-b6a1-5d6f79d743ff', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'في الليل تغيب الشمس. ماذا يظهر في السماء؟', '[{"id":"a","text":"شمسٌ أكبر"},{"id":"b","text":"ضياءٌ قويّ"},{"id":"c","text":"نهارٌ جديد"},{"id":"d","text":"القمر والنجوم"}]'::jsonb, 'd', 'عند غياب الشمس في الليل يظهر القمر والنجوم ويصير الجوّ مظلمًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87d216fb-f43a-5a1b-b623-e2b1e42d40b3', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'ما اللحظة التي تكون في وسط النهار ونأكل فيها الغداء؟', '[{"id":"a","text":"الظهر"},{"id":"b","text":"الليل"},{"id":"c","text":"المساء"},{"id":"d","text":"منتصف الليل"}]'::jsonb, 'a', 'الظهر هو وسط النهار، وفيه نأكل الغداء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b9de268-c62a-5346-bce1-1d806f5accd2', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'ما الترتيب الصحيح لأنشطة اليوم؟', '[{"id":"a","text":"ننام ← نأكل ← نستيقظ"},{"id":"b","text":"نستيقظ ← نذهب للمدرسة ← نأكل ← ننام"},{"id":"c","text":"نأكل ← ننام ← نذهب للمدرسة"},{"id":"d","text":"نذهب للمدرسة ← ننام ← نستيقظ"}]'::jsonb, 'b', 'نبدأ اليوم بالاستيقاظ ثمّ الذهاب للمدرسة ثمّ الأكل، وننهيه بالنوم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2acb401b-1062-512b-8858-3f887dcf7dd1', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'أيّ هذه من أيّام الأسبوع وليست لحظةً في اليوم؟', '[{"id":"a","text":"الصباح"},{"id":"b","text":"المساء"},{"id":"c","text":"الثلاثاء"},{"id":"d","text":"الظهر"}]'::jsonb, 'c', 'الثلاثاء يومٌ من أيّام الأسبوع، أمّا الصباح والمساء والظهر فهي لحظاتٌ في اليوم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca9f764f-6251-5e87-819d-bd4d18708bbd', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'رتّب من الأقصر إلى الأطول: تصفيقة، يوم، أسبوع. ما الترتيب الصحيح؟', '[{"id":"a","text":"أسبوع ← يوم ← تصفيقة"},{"id":"b","text":"يوم ← تصفيقة ← أسبوع"},{"id":"c","text":"أسبوع ← تصفيقة ← يوم"},{"id":"d","text":"تصفيقة ← يوم ← أسبوع"}]'::jsonb, 'd', 'التصفيقة أقصر، ثمّ اليوم أطول منها، ثمّ الأسبوع أطول من اليوم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db1de0c3-5414-5bbf-b11a-9400f348e1b7', 'f5ce2500-c2bf-5e00-9d95-33e4e9ab88e2', 'كم عدد أيّام الأسبوع، وما اليوم الذي يأتي قبل السبت؟', '[{"id":"a","text":"7 أيّام، وقبل السبت الجمعة"},{"id":"b","text":"5 أيّام، وقبل السبت الأحد"},{"id":"c","text":"7 أيّام، وقبل السبت الأحد"},{"id":"d","text":"3 أيّام، وقبل السبت الاثنين"}]'::jsonb, 'a', 'الأسبوع 7 أيّام، وحسب الترتيب يأتي قبل السبت يوم الجمعة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2036e70b-2c2a-5ed5-8d36-a83857c72b4e', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f9aa716-95a6-5cac-bb00-766462a27af7', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'بأيّ حاسّةٍ نعرف شكل الشيء ولونه؟', '[{"id":"a","text":"البصر (العين)"},{"id":"b","text":"السمع (الأذن)"},{"id":"c","text":"الذوق (اللسان)"},{"id":"d","text":"الشمّ (الأنف)"}]'::jsonb, 'a', 'نعرف شكل الشيء ولونه بحاسّة البصر، أي بالعين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('475f3162-53e7-5959-ad5f-638a6dca4959', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'أيّ هذه الأشياء سائل؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الماء"},{"id":"c","text":"الخشب"},{"id":"d","text":"الكتاب"}]'::jsonb, 'b', 'الماء سائلٌ يجري ويأخذ شكل الإناء، أمّا الحجر والخشب والكتاب فأشياء صلبة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73247af3-85b3-577c-a75e-0baeb09d2ad1', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'ما اسم هذا الشكل؟<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="34" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/><ellipse cx="40" cy="40" rx="9" ry="5" fill="#ffffff"/></svg>', '[{"id":"a","text":"مكعّب"},{"id":"b","text":"أسطوانة"},{"id":"c","text":"كرة"},{"id":"d","text":"مثلّث"}]'::jsonb, 'c', 'الشكل المستدير مثل كرة القدم والبرتقالة يسمّى كرة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87ae2b6e-47b7-5c0d-a841-08d329fb09d9', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'الزجاج ناعمٌ تحت اليد، فملمسه:', '[{"id":"a","text":"خشن"},{"id":"b","text":"ليّن"},{"id":"c","text":"سائل"},{"id":"d","text":"أملس"}]'::jsonb, 'd', 'ما كان ناعمًا تحت اليد ملمسه أملس، مثل الزجاج والمرآة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1bfa687-6303-5625-9a0a-fb024e156dba', '2036e70b-2c2a-5ed5-8d36-a83857c72b4e', 'نريد أن نجمع كلّ الأشياء الحمراء معًا. حسب أيّ خاصّيةٍ نصنّف؟', '[{"id":"a","text":"حسب الشكل"},{"id":"b","text":"حسب اللون"},{"id":"c","text":"حسب الحالة"},{"id":"d","text":"حسب الصوت"}]'::jsonb, 'b', 'جمع الأشياء الحمراء معًا تصنيفٌ حسب اللون.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a5a18068-dd08-5595-908c-1485678cf15a', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', '⭐ تمرين: أتعرّف على خصائص الأشياء', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06cf6271-dbea-5a07-b4db-d09b9e5edb26', 'a5a18068-dd08-5595-908c-1485678cf15a', 'البرتقالة شكلها:', '[{"id":"a","text":"كرة"},{"id":"b","text":"مكعّب"},{"id":"c","text":"أسطوانة"},{"id":"d","text":"مربّع"}]'::jsonb, 'a', 'البرتقالة مستديرة، فشكلها كرة مثل كرة القدم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24d7c1a7-5101-51de-87d4-1760fa2cbcaa', 'a5a18068-dd08-5595-908c-1485678cf15a', 'انظر إلى الشكل. ما اسمه؟<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="30,40 70,40 70,80 30,80" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/><polygon points="30,40 45,25 85,25 70,40" fill="#d1d5db" stroke="#1f2937" stroke-width="3"/><polygon points="70,40 85,25 85,65 70,80" fill="#cbd1d9" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"كرة"},{"id":"b","text":"مكعّب"},{"id":"c","text":"أسطوانة"},{"id":"d","text":"دائرة"}]'::jsonb, 'b', 'هذا الشكل له ستّة وجوهٍ مربّعة مثل حبّة النرد، فهو مكعّب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13e83993-71bb-554c-b652-bbf5c0bb88ae', 'a5a18068-dd08-5595-908c-1485678cf15a', 'الحليب الذي نشربه في الصباح هو:', '[{"id":"a","text":"صلب"},{"id":"b","text":"حجر"},{"id":"c","text":"سائل"},{"id":"d","text":"خشب"}]'::jsonb, 'c', 'الحليب يجري ويأخذ شكل الكوب، فهو سائل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cd46491-d26e-5755-b185-0ac3a7049582', 'a5a18068-dd08-5595-908c-1485678cf15a', 'أيّ هذه الأشياء لونه أخضر عادةً؟', '[{"id":"a","text":"الفحم"},{"id":"b","text":"الثلج"},{"id":"c","text":"الموزة"},{"id":"d","text":"العشب"}]'::jsonb, 'd', 'العشب لونه أخضر، والفحم أسود، والثلج أبيض، والموزة صفراء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc7d242a-c0a5-5b8b-a25b-38d9c5cff240', 'a5a18068-dd08-5595-908c-1485678cf15a', 'الإسفنج طريٌّ ينضغط بسهولة، فهو:', '[{"id":"a","text":"ليّن"},{"id":"b","text":"صلب"},{"id":"c","text":"خشن"},{"id":"d","text":"سائل"}]'::jsonb, 'a', 'ما ينضغط بسهولة تحت اليد يكون ليّنًا، مثل الإسفنج والعجين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6241c3a-dc32-59c7-bed1-5cbe21d62ac9', 'a5a18068-dd08-5595-908c-1485678cf15a', 'الحجر قاسٍ لا ينضغط، فهو:', '[{"id":"a","text":"ليّن"},{"id":"b","text":"صلب"},{"id":"c","text":"سائل"},{"id":"d","text":"أملس دائمًا"}]'::jsonb, 'b', 'الحجر قاسٍ لا ينضغط، فهو صلب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('83f28d28-21c4-5b55-b2dd-1131b1831034', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الأشياء', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f27e8c6-07e0-53c8-9982-68b12de63c74', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'ما اسم الشكل في الصورة؟<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="35" y="28" width="30" height="48" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/><ellipse cx="50" cy="28" rx="15" ry="6" fill="#d1d5db" stroke="#1f2937" stroke-width="3"/><ellipse cx="50" cy="76" rx="15" ry="6" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"أسطوانة"},{"id":"b","text":"كرة"},{"id":"c","text":"مكعّب"},{"id":"d","text":"مثلّث"}]'::jsonb, 'a', 'هذا الشكل مثل العلبة والقلم، طرفاه دائرتان، فهو أسطوانة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7dfef970-3a49-5389-8f94-c82d0017cfa7', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'وضعنا ماءً في كوبٍ ثمّ في صحن. أخذ الماء شكل الإناء في كلّ مرّة. ماذا نستنتج؟', '[{"id":"a","text":"الماء صلب"},{"id":"b","text":"الماء سائل لأنّه يأخذ شكل الإناء"},{"id":"c","text":"الماء له شكل ثابت"},{"id":"d","text":"الماء حجر"}]'::jsonb, 'b', 'السائل يأخذ شكل الإناء الذي نضعه فيه، فالماء سائل وليس له شكل ثابت.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ebb29ba-20da-547f-b6ca-f57c824a4676', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'كوبٌ زجاجيٌّ شفّافٌ مملوءٌ بالحليب الأبيض. أيّ خاصّيةٍ هنا صلبة؟', '[{"id":"a","text":"الحليب"},{"id":"b","text":"لون الحليب الأبيض"},{"id":"c","text":"الكوب الزجاجيّ"},{"id":"d","text":"لا شيء صلب"}]'::jsonb, 'c', 'الكوب الزجاجيّ صلبٌ نمسكه، أمّا الحليب فسائل. الفخّ الشائع هو الخلط بين الإناء الصلب وما بداخله من سائل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8130e195-ae33-534f-a784-42e3084621d9', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'نريد أن نجمع كرة القدم والبرتقالة والبطّيخة معًا. حسب أيّ خاصّيةٍ صنّفناها؟', '[{"id":"a","text":"حسب اللون"},{"id":"b","text":"حسب الحالة"},{"id":"c","text":"حسب الصوت"},{"id":"d","text":"حسب الشكل (كرة)"}]'::jsonb, 'd', 'كرة القدم والبرتقالة والبطّيخة كلّها شكلها كرة، فالتصنيف حسب الشكل. الفخّ الشائع هو النظر إلى اللون، لكنّ ألوانها مختلفة والشكل هو المشترك بينها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a291177-9aa3-5ec7-9d5f-9678f35b7863', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'ماءٌ أزرق اللون وحجرٌ أزرق اللون. أيّهما السائل؟', '[{"id":"a","text":"الماء سائل والحجر صلب"},{"id":"b","text":"كلاهما سائل لأنّ لونهما أزرق"},{"id":"c","text":"كلاهما صلب"},{"id":"d","text":"الحجر سائل والماء صلب"}]'::jsonb, 'a', 'اللون لا يحدّد الحالة. الماء سائلٌ يجري، والحجر صلبٌ نمسكه، مهما كان لونهما. الفخّ الشائع هو الظنّ أنّ اللون نفسه يعني الحالة نفسها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6825685c-555f-501d-b6af-f69caa238a00', '83f28d28-21c4-5b55-b2dd-1131b1831034', 'ورقة صنفرةٍ فيها نتوءاتٌ تخدش اليد. ملمسها:', '[{"id":"a","text":"أملس"},{"id":"b","text":"خشن"},{"id":"c","text":"ليّن"},{"id":"d","text":"سائل"}]'::jsonb, 'b', 'ما فيه نتوءاتٌ تحت اليد يكون خشنًا، مثل ورق الصنفرة والحجر. الفخّ الشائع هو الخلط بين الخشن (فيه نتوءات) والصلب (قاسٍ لا ينضغط).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('efe16c5a-0ede-5792-90f6-eb8d127a1f27', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: خصائص المادّة', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('499dc4ab-763b-5ccd-9d25-a2710aa43c36', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'الزيت الذي نستعمله في الطبخ هو:', '[{"id":"a","text":"سائل"},{"id":"b","text":"صلب"},{"id":"c","text":"حجر"},{"id":"d","text":"خشب"}]'::jsonb, 'a', 'الزيت يجري ويأخذ شكل الإناء، فهو سائل مثل الماء والحليب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a5c7527-a90e-5591-a284-5b2084d0bbcc', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'حبّة النرد لها ستّة وجوهٍ مربّعة. شكلها:', '[{"id":"a","text":"كرة"},{"id":"b","text":"مكعّب"},{"id":"c","text":"أسطوانة"},{"id":"d","text":"دائرة"}]'::jsonb, 'b', 'ما له ستّة وجوهٍ مربّعة يسمّى مكعّبًا، مثل حبّة النرد والعلبة المربّعة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36eba76c-9c7c-5534-842c-66f794b02988', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'أيّ مجموعةٍ كلّها أشياء صلبة؟', '[{"id":"a","text":"الماء، الحليب، الزيت"},{"id":"b","text":"الماء، الحجر، الحليب"},{"id":"c","text":"الحجر، الخشب، الكتاب"},{"id":"d","text":"الزيت، الخشب، الماء"}]'::jsonb, 'c', 'الحجر والخشب والكتاب أشياء صلبة لها شكلٌ ثابت نمسكها بأيدينا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a570eae-3dbf-57a9-a56f-84a918418d9f', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'المرآة ناعمةٌ تحت اليد، فملمسها:', '[{"id":"a","text":"خشن"},{"id":"b","text":"ليّن"},{"id":"c","text":"سائل"},{"id":"d","text":"أملس"}]'::jsonb, 'd', 'المرآة ناعمةٌ تحت اليد، فملمسها أملس مثل الزجاج.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('314c032f-2d36-585b-86c6-723ff6172c92', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'الموزة لونها:', '[{"id":"a","text":"صفراء"},{"id":"b","text":"زرقاء"},{"id":"c","text":"سوداء"},{"id":"d","text":"خضراء دائمًا"}]'::jsonb, 'a', 'الموزة الناضجة لونها أصفر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4cfd316-b4f3-55b2-82a6-cfe347a53b94', 'efe16c5a-0ede-5792-90f6-eb8d127a1f27', 'نريد أن نضع كلّ السوائل في جهةٍ واحدة. أيّها نختار؟', '[{"id":"a","text":"الحجر والخشب"},{"id":"b","text":"الماء والحليب والزيت"},{"id":"c","text":"الكتاب والقلم"},{"id":"d","text":"الكرة والمكعّب"}]'::jsonb, 'b', 'الماء والحليب والزيت كلّها سوائل تجري وتأخذ شكل الإناء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل المادّة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4554c0c9-744c-5e86-a493-ebb4724956f5', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'كرةٌ حمراء وكرةٌ زرقاء وكرةٌ صفراء. ما المشترك بينها كلّها؟', '[{"id":"a","text":"الشكل (كرة)"},{"id":"b","text":"اللون"},{"id":"c","text":"الحجم"},{"id":"d","text":"الحالة سائلة"}]'::jsonb, 'a', 'ألوانها مختلفة لكنّها كلّها كرات، فالمشترك بينها هو الشكل. الفخّ الشائع هو النظر إلى اللون أوّلًا، لكنّ الألوان مختلفة هنا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fbb6c15-9bb9-5377-9ecb-9215c9b27e0f', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'علبةٌ صلبة بداخلها عصيرٌ سائل. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"العلبة سائلة والعصير صلب"},{"id":"b","text":"العلبة صلبة والعصير سائل"},{"id":"c","text":"كلاهما صلب"},{"id":"d","text":"كلاهما سائل"}]'::jsonb, 'b', 'العلبة نمسكها ولها شكلٌ ثابت فهي صلبة، والعصير يجري فهو سائل. الفخّ الشائع هو الخلط بين الإناء الصلب وما بداخله من سائل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbeca6e4-5284-5dea-b407-813ba3943818', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'حجرٌ أملس من النهر وحجرٌ خشنٌ من الجبل. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الأملس سائل والخشن صلب"},{"id":"b","text":"الأملس ليس حجرًا"},{"id":"c","text":"كلاهما صلب، لكن ملمسهما مختلف"},{"id":"d","text":"كلاهما سائل"}]'::jsonb, 'c', 'الحجران صلبان نمسكهما، لكنّ أحدهما أملس والآخر خشن. الفخّ الشائع هو الظنّ أنّ الأملس يعني سائلًا، والملمس شيءٌ والحالة شيءٌ آخر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c839926-b29d-54aa-8e15-c886614b0ee3', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'أردنا تصنيف أشياء حسب الحالة (صلب أو سائل). أيّ شيءٍ يذهب مع الماء؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الخشب"},{"id":"c","text":"الكتاب"},{"id":"d","text":"الحليب"}]'::jsonb, 'd', 'الماء سائل، والحليب سائلٌ مثله فيذهب معه. أمّا الحجر والخشب والكتاب فأشياء صلبة. الفخّ الشائع هو التصنيف حسب اللون بدل الحالة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7c74f82-3464-5e8e-af7d-2e2602c69c0c', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'إسفنجةٌ ليّنة وحجرٌ صلب، كلاهما لونه رماديّ. كيف نفرّق بينهما باليد؟', '[{"id":"a","text":"الإسفنج ينضغط والحجر لا ينضغط"},{"id":"b","text":"نعرف باللون فقط"},{"id":"c","text":"كلاهما ينضغط بنفس القدر"},{"id":"d","text":"لا يمكن التفريق بينهما"}]'::jsonb, 'a', 'نضغط بيدنا: الإسفنج ليّنٌ ينضغط، والحجر صلبٌ لا ينضغط. الفخّ الشائع هو الاعتماد على اللون، لكنّ اللون واحدٌ والملمس يفرّق بينهما.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cf56648-0495-5375-ad9f-691eb1bba319', 'cd83cbe2-daca-5f1e-b1cf-27ae4dfc7193', 'أيّ مجموعةٍ رتّبت الأشياء ترتيبًا صحيحًا من حيث الحالة: صلب ثمّ سائل؟', '[{"id":"a","text":"الماء صلب، الحجر سائل"},{"id":"b","text":"الخشب صلب، الزيت سائل"},{"id":"c","text":"الحليب صلب، الكتاب سائل"},{"id":"d","text":"الحجر سائل، الماء صلب"}]'::jsonb, 'b', 'الخشب صلبٌ نمسكه، والزيت سائلٌ يجري، فهذا ترتيبٌ صحيح. الفخّ الشائع هو عكس الحالة، كأن نقول الماء صلب أو الحجر سائل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('364cc3ad-70a0-5c66-8964-f1cdcde98549', '3e0a6cb6-60b7-517d-ab1b-b2b5dfab0f95', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ على خصائص المادّة', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f9e8daf-2460-55ec-ab66-93d14e029712', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'العلبة والقلم شكلهما:', '[{"id":"a","text":"أسطوانة"},{"id":"b","text":"كرة"},{"id":"c","text":"مكعّب"},{"id":"d","text":"مربّع"}]'::jsonb, 'a', 'العلبة المستديرة والقلم شكلهما أسطوانة، طرفاها دائرتان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4e9bdf5-81a4-53fb-b544-1130bb343731', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'أيّ شيءٍ يأخذ شكل الإناء الذي نضعه فيه؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الماء"},{"id":"c","text":"الخشب"},{"id":"d","text":"الكتاب"}]'::jsonb, 'b', 'الماء سائلٌ يأخذ شكل الإناء، أمّا الأشياء الصلبة فلها شكلٌ ثابت.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1662f91-3a03-56a3-8461-1cd8f5f01ab8', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'حبّة النرد هذه شكلها:<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="30,42 66,42 66,78 30,78" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/><polygon points="30,42 46,26 82,26 66,42" fill="#d1d5db" stroke="#1f2937" stroke-width="3"/><polygon points="66,42 82,26 82,62 66,78" fill="#cbd1d9" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"كرة"},{"id":"b","text":"أسطوانة"},{"id":"c","text":"مكعّب"},{"id":"d","text":"دائرة"}]'::jsonb, 'c', 'هذا الشكل له وجوهٌ مربّعة مثل حبّة النرد، فهو مكعّب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d2da62f-297d-56fd-a9be-66f7f29cecd0', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'أيّ مجموعةٍ كلّها سوائل؟', '[{"id":"a","text":"الحجر، الماء، الخشب"},{"id":"b","text":"الكتاب، الحليب، القلم"},{"id":"c","text":"الزيت، الحجر، الكرسيّ"},{"id":"d","text":"الماء، الحليب، الزيت"}]'::jsonb, 'd', 'الماء والحليب والزيت كلّها سوائل تجري وتأخذ شكل الإناء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e6dec99-ddfc-56ef-889d-d9986ac9dda5', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'كأسٌ زجاجيٌّ أملس فيه ماءٌ سائل. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الكأس صلبٌ أملس والماء سائل"},{"id":"b","text":"الكأس سائل والماء صلب"},{"id":"c","text":"كلاهما سائل"},{"id":"d","text":"الماء خشن"}]'::jsonb, 'a', 'الكأس الزجاجيّ صلبٌ وملمسه أملس، والماء بداخله سائل. الفخّ الشائع هو الخلط بين الإناء الصلب والسائل الذي بداخله.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19152c92-32aa-537a-b3ae-0ede95e1fee9', '364cc3ad-70a0-5c66-8964-f1cdcde98549', 'أردنا تصنيف أشياء حسب اللون. أيّ شيءٍ يذهب مع الموزة الصفراء؟', '[{"id":"a","text":"العشب الأخضر"},{"id":"b","text":"الليمونة الصفراء"},{"id":"c","text":"الفحم الأسود"},{"id":"d","text":"السماء الزرقاء"}]'::jsonb, 'b', 'التصنيف حسب اللون، والموزة صفراء فتذهب معها الليمونة الصفراء. الفخّ الشائع هو التصنيف حسب الشكل بدل اللون.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af31b799-7456-5b03-807d-faa9bdfbeede', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'ماذا نسمّي عندما نُبعِد الجسم عنّا؟', '[{"id":"a","text":"الجذب"},{"id":"b","text":"الدفع"},{"id":"c","text":"الأكل"},{"id":"d","text":"النوم"}]'::jsonb, 'b', 'الدفع هو أن نُبعِد الجسم عنّا، فيذهب بعيدًا إلى الأمام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d61bfc7-433b-56eb-91dc-09efaa3efa01', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'عندما نَجذب الجسم، ماذا يحدث له؟', '[{"id":"a","text":"يبتعد عنّا"},{"id":"b","text":"يختفي"},{"id":"c","text":"يقترب إلينا"},{"id":"d","text":"يبقى مكانه لا يتحرّك"}]'::jsonb, 'c', 'الجذب هو أن نُقرِّب الجسم إلينا، فيأتي نحونا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2571bfc7-51dd-5564-9bb7-177941ffcbed', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'عندما نركل الكرة الواقفة فتتدحرك، ماذا استعملنا؟', '[{"id":"a","text":"قوّة حرّكتها"},{"id":"b","text":"لا شيء، تحرّكت وحدها"},{"id":"c","text":"الماء"},{"id":"d","text":"الصوت"}]'::jsonb, 'a', 'الكرة لا تتحرّك وحدها؛ نحن نحرّكها بقوّةٍ من رِجلنا عندما نركلها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07bedab2-364f-50f2-9f8a-0c915a8212e4', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'ماذا يجذب المغناطيس دون أن نلمس؟', '[{"id":"a","text":"الورق"},{"id":"b","text":"الخشب"},{"id":"c","text":"الماء"},{"id":"d","text":"الحديد"}]'::jsonb, 'd', 'المغناطيس يجذب الحديد إليه عن بُعد، أمّا الورق والخشب فلا يجذبهما.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2ddf4b5-c725-5070-8654-a2613379644d', 'e038d9e0-449a-53b6-9507-ba7d20a9bf5e', 'نفتح الباب فيبتعد عنّا. أيّ قوّةٍ استعملنا؟', '[{"id":"a","text":"الجذب"},{"id":"b","text":"الدفع"},{"id":"c","text":"لا قوّة"},{"id":"d","text":"السمع"}]'::jsonb, 'b', 'نفتح الباب بدفعه بعيدًا عنّا، فهذه قوّة دفع لأنّ الباب يبتعد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', '⭐ تمرين: أَدفع وأَجذب', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e14ab6a-e6d5-5d75-a0b8-ff750f8db2c5', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'نَدفع الجسم فيَذهب:', '[{"id":"a","text":"نحونا (يقترب)"},{"id":"b","text":"بعيدًا عنّا (يبتعد)"},{"id":"c","text":"إلى الأعلى فقط"},{"id":"d","text":"لا يتحرّك"}]'::jsonb, 'b', 'الدفع يُبعِد الجسم عنّا، فيذهب بعيدًا إلى الأمام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e689ac4-4ef5-5810-8411-e783f1b7f92f', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'نَجذب الحبل في اللعب فماذا يحدث له؟', '[{"id":"a","text":"يبتعد عنّا"},{"id":"b","text":"يطير في الهواء"},{"id":"c","text":"يقترب إلينا"},{"id":"d","text":"يبقى ثابتًا"}]'::jsonb, 'c', 'الجذب يُقرِّب الجسم إلينا، فالحبل يأتي نحونا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8924dfc6-0ea3-5107-aaed-68f260a08ecc', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'الكرة الواقفة على الأرض، متى تتحرّك؟', '[{"id":"a","text":"عندما نركلها بقوّة"},{"id":"b","text":"تتحرّك وحدها بلا قوّة"},{"id":"c","text":"عندما ننظر إليها"},{"id":"d","text":"عندما نسمّيها"}]'::jsonb, 'a', 'الكرة لا تتحرّك وحدها؛ تتحرّك عندما نعطيها قوّة بركلها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a81df5bf-0dd2-57b5-9a94-07a798efbe84', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'أيّ هذه الأفعال فيه دفع؟', '[{"id":"a","text":"نجذب الدُّرج ليخرج"},{"id":"b","text":"نجذب الحبل نحونا"},{"id":"c","text":"نجذب الباب لنغلقه"},{"id":"d","text":"ندفع عربة التسوّق لتبتعد"}]'::jsonb, 'd', 'دفع العربة يُبعِدها عنّا، فهو دفع. أمّا جذب الدُّرج والحبل والباب فكلّها جذب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28a11ba1-53e7-5a4b-b4ec-a125322c9330', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'في الدفع والجذب، هل نلمس الجسم؟', '[{"id":"a","text":"لا، لا نلمسه أبدًا"},{"id":"b","text":"نلمسه بأذننا"},{"id":"c","text":"نعم، نلمسه بأيدينا أو أرجلنا"},{"id":"d","text":"نلمسه بأعيننا"}]'::jsonb, 'c', 'الدفع والجذب قوّة بالاتّصال: نلمس الجسم بأيدينا أو أرجلنا لنحرّكه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9542377-7294-5a22-b249-691a7c484c22', '09f33841-bde7-5ec3-a9ad-bf07b8eeaa10', 'نَجذب الباب نحونا فماذا يفعل؟', '[{"id":"a","text":"يبتعد عنّا"},{"id":"b","text":"يقترب ويُغلَق نحونا"},{"id":"c","text":"يطير بعيدًا"},{"id":"d","text":"يبقى مفتوحًا"}]'::jsonb, 'b', 'عندما نجذب الباب نحونا فإنّه يقترب ويُغلَق، لأنّ الجذب يُقرِّب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس القوّة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09e1a8d0-68ed-5a9e-9738-af8e41841e87', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'رأى طفلٌ صديقَه يبتعد عنه على دراجة بعد أن دفعها. أيّ قوّةٍ استعمل؟', '[{"id":"a","text":"جذب، لأنّ الدراجة اقتربت"},{"id":"b","text":"لا قوّة، تحرّكت وحدها"},{"id":"c","text":"دفع، لأنّ الدراجة ابتعدت"},{"id":"d","text":"صوت"}]'::jsonb, 'c', 'الدراجة ابتعدت، والابتعاد علامة الدفع. فهو دفعٌ لا جذب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44982a7b-fd3b-5dde-b7ff-87ab89b1c6a0', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'الخطأ الشائع هو الخلط بين الدفع والجذب. أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الدفع يُقرِّب الجسم والجذب يُبعِده"},{"id":"b","text":"الدفع يُبعِد الجسم والجذب يُقرِّبه"},{"id":"c","text":"الدفع والجذب شيء واحد"},{"id":"d","text":"الدفع والجذب لا يحرّكان الجسم"}]'::jsonb, 'b', 'الخطأ الشائع هو عكس الكلمتين. الصحيح: الدفع يُبعِد الجسم، والجذب يُقرِّبه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb82226-91c4-52fb-b9f8-caa97f47e3c9', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'كرةٌ تتدحرج نحوك، فمددتَ يدك وأوقفتَها. ماذا فعلت القوّة؟', '[{"id":"a","text":"أوقفت الجسم المتحرّك"},{"id":"b","text":"جعلت الكرة تختفي"},{"id":"c","text":"حرّكت كرةً واقفة"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'a', 'القوّة لا تحرّك فقط؛ هنا أوقفت الكرة المتحرّكة عندما أمسكتها بيدك.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe77f144-e1f6-5cbc-964c-ca8e9902268e', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'قرّبتَ مغناطيسًا من مِشبكٍ حديديٍّ دون أن تلمسه، فقفز المِشبك نحو المغناطيس. لماذا؟', '[{"id":"a","text":"لأنّ المِشبك دفعه بعيدًا"},{"id":"b","text":"لأنّ المِشبك خفيف فطار"},{"id":"c","text":"لأنّ الورق يجذب الحديد"},{"id":"d","text":"لأنّ المغناطيس يجذب الحديد عن بُعد"}]'::jsonb, 'd', 'المغناطيس يجذب الحديد إليه دون لمس، فاقترب المِشبك منه. هذه قوّة عن بُعد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('074a7021-0c82-5462-8fca-8f52e4fc45be', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'أردتَ أن يقترب الدُّرج المغلق ويخرج نحوك. ماذا تفعل؟', '[{"id":"a","text":"أدفعه إلى الداخل"},{"id":"b","text":"أنظر إليه فقط"},{"id":"c","text":"أجذبه نحوي"},{"id":"d","text":"أتركه دون أن ألمسه"}]'::jsonb, 'c', 'لأُقرِّب الدُّرج وأُخرِجه نحوي أَجذبه، لأنّ الجذب يُقرِّب. الدفع يُبعِده إلى الداخل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a139fc07-8bf3-556c-9291-7eb6cad82d22', 'c8e0a1ef-f990-5d11-ada5-44ffefe5d0b1', 'أيّ هذه الأشياء لا يجذبه المغناطيس؟', '[{"id":"a","text":"قطعة خشبٍ صغيرة"},{"id":"b","text":"مسمار حديد"},{"id":"c","text":"مِشبك حديد"},{"id":"d","text":"مفتاح حديد"}]'::jsonb, 'a', 'المغناطيس يجذب الحديد فقط (المسمار والمِشبك والمفتاح). أمّا الخشب فلا يجذبه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('db856ad5-4597-53a3-a202-e1ca6f4f784a', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', '⭐⭐ تمرين مراجعة: أراجع درس القوّة', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1095b355-d884-52da-9417-0eea2805e295', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'القوّة تستطيع أن:', '[{"id":"a","text":"تجعل الحجر يأكل"},{"id":"b","text":"تحرّك الجسم أو توقفه أو تغيّر اتّجاهه"},{"id":"c","text":"تجعل الجسم يتكلّم"},{"id":"d","text":"لا تفعل شيئًا"}]'::jsonb, 'b', 'القوّة تحرّك الجسم الواقف، أو توقف المتحرّك، أو تغيّر اتّجاهه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2b67856-e265-5b1b-8243-9905d4f9153f', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'ندفع العربة فماذا يحدث؟', '[{"id":"a","text":"تبتعد عنّا"},{"id":"b","text":"تقترب إلينا"},{"id":"c","text":"تختفي"},{"id":"d","text":"تبقى ثابتة"}]'::jsonb, 'a', 'الدفع يُبعِد الجسم، فالعربة تبتعد عنّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0a4af51-5bf8-5b95-9374-6c8a725bb5e1', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'أيّ مجموعةٍ كلّها أفعال جذب؟', '[{"id":"a","text":"ندفع الباب، نركل الكرة"},{"id":"b","text":"ندفع العربة، ندفع الكرسيّ"},{"id":"c","text":"نركل الكرة، ندفع الباب"},{"id":"d","text":"نجذب الحبل، نجذب الدُّرج"}]'::jsonb, 'd', 'جذب الحبل وجذب الدُّرج يُقرِّبان الجسم إلينا، فهما جذب. أمّا الدفع والركل فيُبعِدان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ac7dd14-badd-58b0-8ef1-2fcc8705d14a', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'في أيّ قوّةٍ نلمس الجسم بأيدينا؟', '[{"id":"a","text":"جذب المغناطيس للحديد"},{"id":"b","text":"لا نلمس الجسم أبدًا"},{"id":"c","text":"الدفع والجذب بأيدينا"},{"id":"d","text":"النظر إلى الجسم"}]'::jsonb, 'c', 'الدفع والجذب قوّة بالاتّصال: نلمس فيها الجسم بأيدينا أو أرجلنا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec539215-7689-5e81-814a-a31147f4e693', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'أيّ شيءٍ يجذبه المغناطيس؟', '[{"id":"a","text":"مسمار من حديد"},{"id":"b","text":"ورقة"},{"id":"c","text":"قطعة خشب"},{"id":"d","text":"كوب ماء"}]'::jsonb, 'a', 'المغناطيس يجذب الحديد، فيجذب المسمار. أمّا الورق والخشب والماء فلا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9d5d51e-2684-5a67-859c-303fca0092bf', 'db856ad5-4597-53a3-a202-e1ca6f4f784a', 'نضرب الكرة المتدحرجة بأرجلنا فتغيّر طريقها. ماذا فعلت القوّة؟', '[{"id":"a","text":"أوقفتها تمامًا"},{"id":"b","text":"غيّرت اتّجاهها"},{"id":"c","text":"جعلتها تختفي"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'b', 'القوّة هنا غيّرت اتّجاه الكرة، فبدّلت طريقها إلى جهةٍ أخرى.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل القوّة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aba16f54-30bb-51e8-8cad-d473f0e62f56', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'لعب وليد وسعاد شدّ الحبل، فاقترب الحبل من سعاد وابتعد عن وليد. من جَذب أقوى؟', '[{"id":"a","text":"وليد، لأنّ الحبل ابتعد عنه"},{"id":"b","text":"لا أحد جذب"},{"id":"c","text":"كلاهما دفع الحبل"},{"id":"d","text":"سعاد، لأنّ الحبل اقترب منها"}]'::jsonb, 'd', 'الجذب يُقرِّب الجسم. الحبل اقترب من سعاد، فجذبها هو الأقوى.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7424a1c-0aca-5b08-9593-7e5f39ffb976', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'الخطأ الشائع هو عكس الدفع والجذب. أيّ تطابقٍ صحيحٌ تمامًا؟', '[{"id":"a","text":"دفع ← الجسم يقترب إلينا"},{"id":"b","text":"جذب ← الجسم يقترب إلينا"},{"id":"c","text":"جذب ← الجسم يبتعد عنّا"},{"id":"d","text":"دفع ← الجسم يبقى مكانه"}]'::jsonb, 'b', 'الخطأ الشائع هو قلب الكلمتين. الصحيح: الجذب يجعل الجسم يقترب إلينا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c13d3efe-8d56-56c3-a228-9f6cad07b2a0', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'أمامك: مغناطيس، مسمار حديد، ورقة، قطعة خشب. ماذا يجذب المغناطيس وحده؟', '[{"id":"a","text":"الورقة والخشب"},{"id":"b","text":"كلّ الأشياء"},{"id":"c","text":"المسمار الحديديّ فقط"},{"id":"d","text":"لا شيء"}]'::jsonb, 'c', 'المغناطيس يجذب الحديد فقط، فيجذب المسمار. الورق والخشب لا يجذبهما.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c7020f5-ae32-52ef-8112-03bfb5d2ddc9', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'أردتَ أن تُبعِد الكرسيّ عنك دون أن تجرّه نحوك. ماذا تفعل؟', '[{"id":"a","text":"أدفعه فيبتعد"},{"id":"b","text":"أجذبه فيقترب"},{"id":"c","text":"أنظر إليه"},{"id":"d","text":"أتركه دون قوّة"}]'::jsonb, 'a', 'لأُبعِد الكرسيّ أَدفعه، لأنّ الدفع يُبعِد. الجذب يُقرِّبه نحوي.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be6aa327-d4b5-520c-b04f-ed3ece04d821', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'ما الفرق بين جذب الحبل وجذب المغناطيس للحديد؟', '[{"id":"a","text":"لا فرق بينهما أبدًا"},{"id":"b","text":"كلاهما دون لمس"},{"id":"c","text":"كلاهما يُبعِد الجسم"},{"id":"d","text":"الحبل نلمسه، والمغناطيس يجذب دون لمس"}]'::jsonb, 'd', 'جذب الحبل قوّة بالاتّصال (نلمسه)، أمّا المغناطيس فيجذب الحديد عن بُعد دون لمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5a8a8a9-7b02-5356-bbbc-dcb645452669', '10cb46ec-7803-5ae2-8b05-dffbe9f7e0ba', 'كرةٌ متدحرجة نحوك: أوقفتَها ثمّ دفعتَها فابتعدت. ماذا فعلت القوّة في المرّتين؟', '[{"id":"a","text":"حرّكت كرةً واقفة ثمّ أوقفتها"},{"id":"b","text":"جعلت الكرة تختفي مرّتين"},{"id":"c","text":"أوّلًا أوقفت المتحرّك، ثمّ حرّكته بعيدًا"},{"id":"d","text":"لم تفعل شيئًا"}]'::jsonb, 'c', 'القوّة أوّلًا أوقفت الكرة المتحرّكة، ثمّ بالدفع حرّكتها وأبعدتها عنك.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'b73733c7-2c1b-58e1-9a56-9bd59cc0378b', 'eveil-scientifique-1ere', '📝 تدريب ⭐⭐⭐ على القوّة (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('def2cb5e-a743-5083-be68-f86fa31d7ad5', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'ماذا تفعل القوّة بالأشياء؟', '[{"id":"a","text":"تجعلها تتكلّم وتأكل"},{"id":"b","text":"تحرّكها أو توقفها أو تغيّر اتّجاهها"},{"id":"c","text":"لا تفعل بها شيئًا"},{"id":"d","text":"تجعلها تختفي"}]'::jsonb, 'b', 'القوّة تحرّك الجسم الواقف، أو توقف المتحرّك، أو تغيّر اتّجاهه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d47354b-6a7b-527c-8552-40cac821d0d7', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'أيّ جملةٍ صحيحة عن الدفع؟', '[{"id":"a","text":"الدفع يُقرِّب الجسم إلينا"},{"id":"b","text":"الدفع يجعل الجسم يختفي"},{"id":"c","text":"الدفع يُبعِد الجسم عنّا"},{"id":"d","text":"الدفع لا يحرّك الجسم"}]'::jsonb, 'c', 'الدفع يُبعِد الجسم، فيذهب بعيدًا عنّا إلى الأمام.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8594b6c3-7679-535c-865f-845437620145', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'أيّ جملةٍ صحيحة عن الجذب؟', '[{"id":"a","text":"الجذب يُقرِّب الجسم إلينا"},{"id":"b","text":"الجذب يُبعِد الجسم عنّا"},{"id":"c","text":"الجذب يجعل الجسم يطير"},{"id":"d","text":"الجذب لا يحرّك الجسم"}]'::jsonb, 'a', 'الجذب يُقرِّب الجسم، فيأتي نحونا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('113c03f6-bd3b-5d41-8d97-13c83e19dbc5', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'الخطأ الشائع هو الخلط بين الدفع والجذب. أيّ مثالٍ هو جذب؟', '[{"id":"a","text":"نركل الكرة فتذهب بعيدًا"},{"id":"b","text":"ندفع الباب فينفتح بعيدًا"},{"id":"c","text":"ندفع العربة فتبتعد"},{"id":"d","text":"نجذب الحبل فيقترب"}]'::jsonb, 'd', 'الخطأ الشائع هو الخلط بينهما. جذب الحبل يُقرِّبه، فهو جذب. أمّا الركل والدفع فيُبعِدان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8deb5611-2b38-5b0f-9cfa-b2d05387f66b', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'المغناطيس يجذب الحديد دون لمس. هذه قوّة:', '[{"id":"a","text":"بالاتّصال (نلمس الجسم)"},{"id":"b","text":"عن بُعد (دون لمس)"},{"id":"c","text":"لا قوّة فيها"},{"id":"d","text":"بالصوت"}]'::jsonb, 'b', 'المغناطيس يجذب الحديد من بعيد دون أن نلمسه، فهي قوّة عن بُعد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86b110c6-223b-574a-91d0-7ba1ff583af5', '8406c8b0-b6e6-5c21-a2a9-e29da4da0aa9', 'أردتَ أن توقف كرةً تتدحرج نحوك. ماذا تستعمل؟', '[{"id":"a","text":"قوّة من يدك توقفها"},{"id":"b","text":"الصوت توقفها"},{"id":"c","text":"لا شيء، تقف وحدها"},{"id":"d","text":"النظر إليها يوقفها"}]'::jsonb, 'a', 'الكرة المتحرّكة لا تقف وحدها؛ نوقفها بقوّةٍ من يدنا عندما نمسكها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

