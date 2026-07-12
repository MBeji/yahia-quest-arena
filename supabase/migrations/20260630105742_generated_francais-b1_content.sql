-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-b1 (Français — Intermédiaire (B1 · DELF B1))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-b1/
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
  ('francais-b1', 'Français — Intermédiaire (B1 · DELF B1)', 'Atteins le niveau intermédiaire : maîtrise le plus-que-parfait, les pronoms compléments, les pronoms relatifs, le subjonctif présent, le conditionnel et l''hypothèse, le discours indirect, enrichis ton vocabulaire du travail et de la société, et comprends des textes argumentatifs. Niveau intermédiaire (CECRL B1), aligné sur le DELF B1.', 'Agilité', 'subject-french', 'Languages', 3, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-b1'
      AND e.source = 'admin'
      AND q.id NOT IN ('e7066b78-4699-5d36-b438-d67c28c54bf1', '00174f78-8815-5b40-89ca-f40876840013', '432d7db4-6c66-5a8b-a5cb-15d1263b0398', '2e8fec34-83fe-5d13-a046-c846ce6c5001', '91cff74a-b912-5129-a90e-9b4f0f3b1642', '650d639b-40fb-50d6-ae85-9d9280a20b7f', '549ca8b5-a046-5ad9-8a8d-a0fff46232bc', 'b0d75035-5e2c-548e-ae4a-92c98bc349e6', 'eb59fc14-7e29-5fb9-9e33-90e1d20ff816', 'c6f9738a-4b2b-5759-9586-592b4f7908f5', '0ecc993b-4157-5d33-8c67-80ace6f51cf2', '0b5fa377-bc6c-5baa-9bd3-a579fc7678a7', '7541419d-1874-5564-b060-e977f6ca6a96', '77f4fe8b-d83b-5eac-95d0-952ed0ed05f9', 'd743f728-eb5c-59d0-8203-e0b653db0b15', '17713a24-aa1f-505e-94ec-585a5bd7c180', 'da402e23-727f-5ffb-823c-2838ad91e421', '04af33fc-b74f-5d47-b222-d4003e750f79', 'ed154f1d-9b4a-58d8-b221-80170c4d95c2', '2788d99d-86fb-559f-a817-d4efd1f335db', 'c418c79d-ff55-596b-a5cb-672098093d97', 'bbeb4d91-64ed-5c09-a843-f32fd312c2d7', '3dd73b6c-fee7-51b4-8caf-ec365580cd65', 'a30f9ff1-6ea0-5875-9d23-714070f4e322', 'a8a947ca-737e-5a10-ae1e-820550fe359f', '5a8d0e4f-a542-52a3-9eb6-47b378182988', 'ffcf297a-0c37-5fb7-857d-0e81a548ca15', '18ae5fc0-49ad-5834-bce4-af04d90006fa', '5fc2e162-a0b9-593b-8a41-e6458d2beda4', 'a9bbba31-0057-5800-8256-b8c3c2dc83c4', '626cadc3-6432-5cfb-92c5-b2927fb1c199', 'a655eb92-1ef4-5402-88b7-f7feffc20ba6', '36f92d59-757c-5135-be57-aecd7c968c31', 'a1daf221-53e4-5032-9555-fb89459d0f5c', '9718b6fc-02d0-5720-a397-26f22ad76a70', '2decee7b-d1ba-511d-908d-2f5ed5dc38dc', '60c5f2cd-8185-5d25-a18c-5633bc12414e', '167150ce-0980-5630-8ff0-8f76528071e1', 'e8e3b01a-d64d-504d-8961-6216d806bac1', 'b5b7f132-c107-5cff-aade-c84951f46e6d', '701df796-c3a9-52ee-a4c3-445eaedf4657', '8926be0a-4973-5991-b4f7-4e3a6aad52fc', 'eac5b691-f2c8-590f-83f5-b530ae78b446', '8617b190-cba8-541a-a003-d39fc58e6075', 'e2d47d2c-0901-56e2-add6-c4dc1a2063c8', '48679665-867c-59b7-926c-e7e2b8f1c88b', '0ddcc4a5-46c4-5a51-8a07-dff55a5da368', '6641dc2b-1239-50bc-ab3e-393e4191f298', 'd7c99804-1b23-5c03-89fa-39dc4afa4db6', 'dc3b0767-1d52-5a77-9d4b-bf6756184673', 'b8e2ac07-f39a-56f6-b1f5-1443fe992501', '219591c5-55d1-573d-b77e-611e2da452d8', 'bce1c031-127c-5b48-b62a-f7cd9c7a809d', 'f58e3f25-ab65-5add-b699-c486633a73a1', '273d7cc9-c7f1-5458-896c-8cb1ffb3b999', '695e663c-745f-50e5-8fc0-db4d5eaed63a', '53da2871-ad2a-5ef6-9c68-67542a733e65', '6ad153db-6252-55fe-b4fc-310d36a7d969', '0beb83df-6337-5132-8db5-47b1f8593015', '19ca275f-2036-5d0d-a2c2-1a0856e125a2', '31950748-3ed8-56aa-a049-4c693eb12e73', 'a3a16e64-1a66-543d-a6d2-068de9185c4c', 'c8cb74d1-f53b-526f-865e-273fcbe143c6', 'feb84e30-669d-564a-96ac-d435b2e6c48b', '56da2b9e-e6fb-5028-9d6c-4195da6f26d6', '21eb079a-45a9-53e3-9d0a-1364a01716fe', '5599eaa3-c6d6-566d-b9b2-a1893b338c12', 'c8a33bee-3bb6-5f20-b406-f5ddb1ebd079', '7c6130eb-3f0f-50c4-9eef-5466756ea42b', '2c9035e9-5ae1-5cf0-b0d2-f0616ffac199', '098a0efc-79f2-512d-a048-860c85fda97b', '004a8254-8420-526c-bb6d-237275cc6ef9', 'b6e4b0d7-66cd-52c8-98a0-6f806b7224f4', '405fad40-3cd4-541d-b7e2-2fab37c7ce1d', '013fb210-49a1-566f-ba39-f497d18194a7', '28c5f75e-9466-587b-b6b1-bef2b0588364', '84d70d04-dba9-5e67-9e8d-c26058b2939c', '4fa9ce47-4526-5d12-a435-f580681c1b68', 'e8ef617b-0a6e-5a31-8945-e5f23ac8939d', '8c493414-bc73-5a47-b3aa-3a9a015f0cb0', '4c6ea2ca-a736-57e3-9ecd-bdf27d80e57d', '46167fc7-a5a3-5c99-9e7a-76ef821c4ea8', 'f390c8ea-73b4-5b57-b0f4-7bed87121f91', '3b29b1d7-50bf-512d-8e3e-976cc9f6e280', '8cf25378-63e8-54ce-b7e6-8271cf0d3f9a', 'e987c5b5-79b3-58f7-a84b-82c4ccd7d93f', 'eea5a563-2cc4-5640-bd71-5fe114e6af00', '43c32e7a-4280-5175-9756-d96675f1ed2d', 'f367d303-b49f-5faf-a816-113c89e02850', '1da924ac-0d6e-5713-aefc-b0afcf82a907', '03a47dfa-9701-5a93-ac9d-6bc5916c6d24', 'c481ad56-babe-52ed-8a85-369989a3d5b3', '59711c8e-2e5a-5e06-a2f4-371fcfb30a66', 'a85a9e7e-bc4c-5b51-a8bb-795c297f9518', 'f439a3cc-32e1-5774-8455-67312b1d81c8', 'bd0149bb-51fa-5114-9c16-526a6b28e6e7', '9220cabd-860a-5fe0-b831-2db449f66703', '1710e06b-d7bb-5fcd-80bd-61208c742f4a', '50235b05-2d0f-58ff-b16a-40a474c6f355', '475c5383-aa76-56ef-8efa-f23d31ceabfb', '430e0edd-ae62-583d-884f-3c049f997cba', 'afc1e3a2-bb8b-5906-8c68-dee6afb74e1f', '5e584c82-1582-57ad-98fc-8b80c800aacb', '27f32323-db53-54ac-88af-01f168c7fc78', 'f491ab1f-7cb9-539f-ad2b-b7ecef34d672', '3e2db2ab-cd3f-5bed-8e0e-3ae4986fde01', '6cd9358e-7c13-537c-853e-8e405cc9e3a7', 'd8cbf181-2f84-52e1-903d-b7b78ddca284', '58b0005c-7bf4-54ec-a742-ad6809a601cc', '7cdadd45-bdd3-5cae-942e-6511c1334dc3', 'dd7ad022-6c84-5dde-a64e-97ac51e8e01e', 'dd0e1900-6fda-5a60-90e0-96cecf6371b7', 'df743959-8198-593f-be8c-6d84b96143ed', '4515be63-551b-5fdc-bdcf-ec88ba5f09bc', '466096c9-4678-5d5e-a3d7-4f76aa24e579', 'd03fcce5-d888-5250-80e5-290fc41d6c63', 'df2841b4-ecaa-5bf5-89c3-0d85e7a405d6', 'f118db83-abfd-58a6-ad25-c1190004c1d8', 'bc37ceb8-6afa-5259-aa9f-d0ccf83971a6', 'e591e379-9fcb-58ea-b6e4-4b8f2d938bea', '8ba012ca-5a44-5196-a63d-632ec8daa7a1', '146b12da-bb6c-5bea-b9e7-419d1d09ae62', 'b2bea37f-bad7-5c15-9e1f-93abcda70d19', 'a3ab2bd3-009f-50dc-b276-99bd2f3aff24', 'aed780b5-3b00-5a12-9741-1716647602ac', 'f1747c6c-8010-57c3-b938-667a1d8c1bb6', '76710c06-ee2a-59e6-98b7-3cd2757465a4', '01b09cac-1878-52c0-bad4-3032ef420683', 'ff0ab38e-519c-5487-8cf6-9cfc7af83dfd', '88879c4a-a4ca-5308-8804-3c357389e435', '30c40bc1-9b91-5a16-85ac-cddbb17d1550', '3aa5d594-5b76-5b28-bb44-3599e1c78867', '3f11dc3d-034e-53c5-b71a-336f2ec90fbc', '84062536-3032-5fda-8cd8-048cf8a4cf49', 'ebc7b672-cbea-5184-8b45-292e030c7032', 'dd5a9a0c-1db3-51a2-a8f6-2e666574f349', '690330b3-3705-5244-93b5-7a7f0ded499d', '214fc19d-4228-5ec1-b4bf-456689d67fb0', '80b802ea-2476-561b-8158-eca6061a0b1c', '847dacd3-df00-5769-b062-42b335c01cfd', '9ba33431-01ad-590a-8c75-2539bdaaf05c', 'e98d6365-86b6-57b6-a034-e97a93dc43b2', '9bf4c61f-1f30-5e77-bbf2-992d22c050f1', '3dd8bc36-300d-5597-acad-a6aebd60f2f6', '27a490bf-c41f-5d28-bf79-60e31e3cb4f4', '0ed6eb00-98be-5ff7-a7bf-51be10932691', '9d615262-c844-5752-a11b-402198f5ec6c', '0c2bbd9a-11bf-5e52-b01d-7f13dacb53f3', 'fcc8d426-b7eb-5b84-9b9e-33ce10ebc15e', '137fcd26-eb9a-53c0-a723-1a07773fe6e4', '53338972-5071-5cfc-8650-15cb8109305a', '0f3e858b-6cb4-5ca1-a9aa-44af5493ee1b', 'b556aa78-c227-58bc-80a5-98a7c7c9fb41', 'c9fdb666-4dc2-56f3-9c5d-906996974fcb', 'c6eedf60-11bb-5c5a-aee8-38276fb1d3bb', 'aae91432-cbc7-514a-839b-250ba689e772', 'f2a20886-3613-576a-aebb-f85fa86364ef', '69814c04-d27d-569d-a639-096f2de1c2a6', '4770a433-3886-5703-81b6-7e9f3e1fee2c', 'c141ecdb-d6b1-56a1-a947-01d33c149278', '8279d782-3b81-56ab-a862-c164ea60b4b1', '6ed891de-a390-57ab-be2c-4ad971addacb', '040163b8-e671-5ff2-9a54-ed277b54e2de', '5148db3d-1964-574d-8f0e-ca26944c988f', '4b29f0ad-fca6-59ec-9fe5-46969496a368', 'ffa07eb9-980a-5760-a970-cb14bfd33258', '9a8c8e73-de1a-5a29-b2d9-f9e1e36033f7', 'c0e1481d-8da4-55f2-bb90-b4c9de48b412', 'af8627d6-5f1f-5b9c-8fb9-7c0645d491e4', 'd2c05598-67a4-5d70-b96f-a2800ec72ace', 'f10aaa96-9d8b-516e-a769-3e461391c0df', 'f7a029e6-52af-5fe4-843c-48fc59a2ab08', 'd94df869-3946-5ce7-aa3e-0a7ede014eca', '50167193-f094-5445-a91c-3b7511d4522f', 'a665d099-1387-56d0-85e4-7dcee09f8d15', 'aad31943-47a3-5231-b359-0f8db8019b20', 'b4a29b51-8f09-52bd-8100-5e3eb8038bb0', 'dc54610c-db52-5f2e-a218-344d51bec8bd', '2b4969c2-33fb-5630-81a4-d8700fb59501', '33dc7bc7-ee23-54fc-940a-407d6e3b4042', '1898b678-8cab-5403-aac7-6d24a9373849', '42fb7a9b-4eab-5245-9389-4196739e0c08', 'aa39f16e-7a5f-5ef2-9d38-97644da04e3a', 'fa6f555f-59c5-5bdf-b4a1-43a910026ba1', 'f9c00506-4253-5009-9bb8-d5d73b185968', 'd33d6107-cdc1-51bb-9f26-39b192eaee9c', '176323dc-5fee-5c88-a612-e5678ee912fd', 'dc34c4d6-f6e6-5324-8480-5d504fdf553d', '352599cd-5e63-50d8-86f4-fae01a2aa92f', 'a5ad5b35-9dfe-5661-91db-ac45b03ef345', '471c96ef-33e6-50ae-a650-4c8f636f8857', '0f261eda-844c-57a8-8f09-68ddecef8332', '1f98e62c-86d9-511b-9f3a-6d7de15929c4', '64f28a54-b53e-59b1-b1e5-9274dc1a9903', '162d3578-02b3-55a9-ac40-1e60d77a728d', 'b4f9caf6-3c09-50a6-aa4a-faaccdbf3eae', 'e843c297-6b7f-5f1d-91d9-e483b1f0a16a', 'db4bb59a-2a4d-530c-af6d-d0c45583c130', '59c19d0b-5132-5d1e-9fd8-f896de26067b', '1796fdd4-b5e6-551a-ba13-848ee995fde0', 'e046b341-1207-5968-8389-b3ed8c91cd20', 'e81d307c-36b4-57b6-bb49-faab5e97376a', 'cd4791db-8309-5018-bbf1-6f563bb648c1', '9e2739ee-a2ed-5462-9de8-8d12001fac01', '4d7e9a27-c417-5ba2-96e5-635a180f29cf', 'f307463d-ab12-5585-9f70-a9ea2465c7b1', 'c015968d-c9fc-5044-879f-7371aab459ea', 'ab98a58c-07e4-519f-bdeb-ae3211953174', '63da6087-fbb9-5282-8c9e-becb02c3b9b2', '3fb6cb4b-a2a7-57f0-8df1-695235220e3d', '51e02a3a-0345-564a-898c-397d84db993d', 'ffb57c5c-81ec-5657-953f-2094d78871ad', '7f0e8da5-98dd-520a-807b-2c72d24f97f0', '8bf95d2b-a0e4-5004-bd0e-3c716352aa8a', '54e4dc3f-1848-55d9-8dd8-337a76c79468', 'a2e18e23-7ac3-5e1b-b596-59d1ef753971', 'dc3d2f5f-4ae6-50fb-8aff-88363f33046e', '45fc3132-4df2-5bf8-83ce-4bb897b73661', 'a2879ff2-2184-51b5-aa53-ee1a82e88778', 'e1f76367-82ae-5b14-a72e-52ede13373fb', 'f8836777-6edd-5ee9-84ed-b39db4ed15d6', 'bff51d5a-e33d-5a47-b55a-2080baa8b553', '172d7f21-420f-5117-81eb-2744a5fd1452', '6921053f-9eac-5838-b8bd-8620df915f1c', 'e6bdc1f5-d073-5c3b-bd2f-c73239ef5aec', 'cd818406-5bc2-54b2-b95d-0c2e3517ebcc', 'f4888e6e-639c-52a1-a9b4-52d8dbbd6465', '412f8aca-30db-5f69-a7cf-527272928846', '44e34dc8-bcbd-5bda-b995-1649b61efbf6', '6fbe9bc3-f5d4-5258-831c-faef86b9c9b0', '9d54be6f-4671-59e3-ad6a-59f84a190aa4', '58656d3d-e89a-5006-9a46-f996e7a209ae', '78feae4d-328c-58bb-87f2-ac70ecc4483f', '7fbba347-d64b-5373-b843-172ab492c5f7', 'a3ef06c5-a4a0-5872-a764-2a253fc1f327', 'bc40d337-22ce-5959-a651-29040927f2d3', '609fcae9-c62b-5f21-900f-942a4fe9d93b', '2180f398-eca5-5b4d-a57f-9f3f2b9666bd', '628212cb-6a32-5ab1-b14a-5fb6f481bc4b', '5fcf98c2-1b24-5bf9-8361-3d912e599669', 'bc013dbe-4e85-5daa-b965-fec3e6859064', 'c1325c47-8080-5f6b-a08a-0fd8ec422d0c', '70553d09-269d-5bd3-8f2c-fe641a566dca', 'b7392365-61fb-5e35-a13e-2530cb6f8316', '70f13759-b5cd-5eb6-9ec8-6378232ec41a', '8df6a17a-2244-5012-8bdf-4860981a435c', 'f16e303a-0202-59ae-9e47-38624c38e35c', '2b2cb90a-5301-5685-9878-236343b3e08f', 'e133645c-491a-5806-b31d-dcf3d742d134', '00415703-a422-5f89-a771-970e250a0449', '348827a7-a911-5679-8e88-87a14edd3fb3', '88e0fcd1-a30a-5727-b0e9-fd65ca4b69f9', 'b7e2cd9a-bd99-5cf8-90c4-727c489174a0', 'e30eb9e9-0b27-5478-bf19-363d945276ce', 'f1fd5e73-48ae-5ac1-b432-683fdfb924ee', 'f02d6681-4ab8-5941-a079-418c19325737', '5e4a8725-ef47-5338-b07a-78b19d051876', 'cb1cb46f-0612-54c7-a231-e1b2c311e689', '892be656-b934-5bcb-8bc0-80275c81ee22', '6f6006e0-9460-50d6-b342-d2b3c9bbf6bc', '70db6903-d420-5d03-bfae-11576caaba8b', '6a8bb171-a6a1-50b5-a2b2-fcd8629142a2', '30fae1e2-a2f8-5e92-9a44-7202fe5133a7', 'e1266e06-5faa-5169-9c58-831e6b3f1e69', '269b79c9-17b2-5d7f-a77a-e581a11e62a7', 'cb34d288-9b7f-5478-9d12-6827df2e3d9d', 'bcac38ec-586b-50af-a3dd-08a70b96c6ad', 'bbed3291-6143-58d0-9210-3d38148bb2e9', 'd5d08bcc-9436-5f53-bf84-1b59710cdf12', '0b4437b1-0480-5af0-a5b5-779f81013abf', 'dea1e869-0d4b-5edf-b02b-2d2cc50c91b6', '46d23004-c60c-52c2-9c71-30ef98227ec7', '274e6979-e710-5e55-90a4-26654382709f', 'd6cd4183-575d-5dbf-887d-775201a622c7', '59c1ecab-1250-55a7-8604-f9f3b60650f6', '5c45cf56-9514-5019-b22c-62a582529717', '0646374b-628d-5512-856b-8e813afffe76', 'b4884fd9-e82e-5f32-8626-32280b56d57b', 'aed198a4-5dc0-5a8b-8a34-ecc58cd3cdcf', '22a135c2-754b-5a3d-9096-35a25c735c83');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-b1' AND source = 'admin' AND id NOT IN ('5d963c5c-a10f-5eac-a9c4-f38b4de12871', '5efe148d-7a31-5022-a12b-01d2e884157f', '5516257f-236e-5ce7-8c49-124697930e3d', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', '9343f86c-edbb-5b44-bb88-0cdea2add275', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'e9a9f982-93c0-515a-95da-88afe89de37e', '5515752e-9404-5afe-b7a4-21492a49b934', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', '3db222fa-72e6-570e-b833-d9114cee5c56', '1a6ffc86-dac4-5262-bd45-19376f88ae28', '8fc36a0c-c388-548d-900a-17dac34c4170', 'ac46bed4-5196-53f1-beec-35f40378ce05', '9d589881-be62-5aae-ab7c-5766bbf8605d', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', '3f747788-2709-5df2-82cb-6cff48b58b4f', '4c3d13ac-8254-5f48-9343-82b414812363', '797e2b68-f231-5e2a-8446-4cbe49d5e418', '5630104e-a03d-54f3-b6de-ac9786643ad1', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'b1f33379-133f-5a78-8056-ce28027dda29', 'a4ece141-4263-536d-b60c-63150cab66a0', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', '427710ee-3d07-5c78-979f-143f1df48fb8', '8760d010-daa6-549c-b88e-30cc60253cfe', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', '68d3b107-ff40-5d93-955f-07fead20324f', '846da7a1-49b8-5b38-b354-09871b518b71', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', '006b0ced-1808-5f5b-aa3b-df9c12b03511', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'c5d876bc-5124-5e26-8384-ca4800ed534b', '54c057a7-056d-5829-bc60-28e04703bba7');
DELETE FROM public.questions WHERE exercise_id IN ('5d963c5c-a10f-5eac-a9c4-f38b4de12871', '5efe148d-7a31-5022-a12b-01d2e884157f', '5516257f-236e-5ce7-8c49-124697930e3d', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', '9343f86c-edbb-5b44-bb88-0cdea2add275', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'e9a9f982-93c0-515a-95da-88afe89de37e', '5515752e-9404-5afe-b7a4-21492a49b934', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', '3db222fa-72e6-570e-b833-d9114cee5c56', '1a6ffc86-dac4-5262-bd45-19376f88ae28', '8fc36a0c-c388-548d-900a-17dac34c4170', 'ac46bed4-5196-53f1-beec-35f40378ce05', '9d589881-be62-5aae-ab7c-5766bbf8605d', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', '3f747788-2709-5df2-82cb-6cff48b58b4f', '4c3d13ac-8254-5f48-9343-82b414812363', '797e2b68-f231-5e2a-8446-4cbe49d5e418', '5630104e-a03d-54f3-b6de-ac9786643ad1', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'b1f33379-133f-5a78-8056-ce28027dda29', 'a4ece141-4263-536d-b60c-63150cab66a0', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', '427710ee-3d07-5c78-979f-143f1df48fb8', '8760d010-daa6-549c-b88e-30cc60253cfe', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', '68d3b107-ff40-5d93-955f-07fead20324f', '846da7a1-49b8-5b38-b354-09871b518b71', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', '006b0ced-1808-5f5b-aa3b-df9c12b03511', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'c5d876bc-5124-5e26-8384-ca4800ed534b', '54c057a7-056d-5829-bc60-28e04703bba7') AND id NOT IN ('e7066b78-4699-5d36-b438-d67c28c54bf1', '00174f78-8815-5b40-89ca-f40876840013', '432d7db4-6c66-5a8b-a5cb-15d1263b0398', '2e8fec34-83fe-5d13-a046-c846ce6c5001', '91cff74a-b912-5129-a90e-9b4f0f3b1642', '650d639b-40fb-50d6-ae85-9d9280a20b7f', '549ca8b5-a046-5ad9-8a8d-a0fff46232bc', 'b0d75035-5e2c-548e-ae4a-92c98bc349e6', 'eb59fc14-7e29-5fb9-9e33-90e1d20ff816', 'c6f9738a-4b2b-5759-9586-592b4f7908f5', '0ecc993b-4157-5d33-8c67-80ace6f51cf2', '0b5fa377-bc6c-5baa-9bd3-a579fc7678a7', '7541419d-1874-5564-b060-e977f6ca6a96', '77f4fe8b-d83b-5eac-95d0-952ed0ed05f9', 'd743f728-eb5c-59d0-8203-e0b653db0b15', '17713a24-aa1f-505e-94ec-585a5bd7c180', 'da402e23-727f-5ffb-823c-2838ad91e421', '04af33fc-b74f-5d47-b222-d4003e750f79', 'ed154f1d-9b4a-58d8-b221-80170c4d95c2', '2788d99d-86fb-559f-a817-d4efd1f335db', 'c418c79d-ff55-596b-a5cb-672098093d97', 'bbeb4d91-64ed-5c09-a843-f32fd312c2d7', '3dd73b6c-fee7-51b4-8caf-ec365580cd65', 'a30f9ff1-6ea0-5875-9d23-714070f4e322', 'a8a947ca-737e-5a10-ae1e-820550fe359f', '5a8d0e4f-a542-52a3-9eb6-47b378182988', 'ffcf297a-0c37-5fb7-857d-0e81a548ca15', '18ae5fc0-49ad-5834-bce4-af04d90006fa', '5fc2e162-a0b9-593b-8a41-e6458d2beda4', 'a9bbba31-0057-5800-8256-b8c3c2dc83c4', '626cadc3-6432-5cfb-92c5-b2927fb1c199', 'a655eb92-1ef4-5402-88b7-f7feffc20ba6', '36f92d59-757c-5135-be57-aecd7c968c31', 'a1daf221-53e4-5032-9555-fb89459d0f5c', '9718b6fc-02d0-5720-a397-26f22ad76a70', '2decee7b-d1ba-511d-908d-2f5ed5dc38dc', '60c5f2cd-8185-5d25-a18c-5633bc12414e', '167150ce-0980-5630-8ff0-8f76528071e1', 'e8e3b01a-d64d-504d-8961-6216d806bac1', 'b5b7f132-c107-5cff-aade-c84951f46e6d', '701df796-c3a9-52ee-a4c3-445eaedf4657', '8926be0a-4973-5991-b4f7-4e3a6aad52fc', 'eac5b691-f2c8-590f-83f5-b530ae78b446', '8617b190-cba8-541a-a003-d39fc58e6075', 'e2d47d2c-0901-56e2-add6-c4dc1a2063c8', '48679665-867c-59b7-926c-e7e2b8f1c88b', '0ddcc4a5-46c4-5a51-8a07-dff55a5da368', '6641dc2b-1239-50bc-ab3e-393e4191f298', 'd7c99804-1b23-5c03-89fa-39dc4afa4db6', 'dc3b0767-1d52-5a77-9d4b-bf6756184673', 'b8e2ac07-f39a-56f6-b1f5-1443fe992501', '219591c5-55d1-573d-b77e-611e2da452d8', 'bce1c031-127c-5b48-b62a-f7cd9c7a809d', 'f58e3f25-ab65-5add-b699-c486633a73a1', '273d7cc9-c7f1-5458-896c-8cb1ffb3b999', '695e663c-745f-50e5-8fc0-db4d5eaed63a', '53da2871-ad2a-5ef6-9c68-67542a733e65', '6ad153db-6252-55fe-b4fc-310d36a7d969', '0beb83df-6337-5132-8db5-47b1f8593015', '19ca275f-2036-5d0d-a2c2-1a0856e125a2', '31950748-3ed8-56aa-a049-4c693eb12e73', 'a3a16e64-1a66-543d-a6d2-068de9185c4c', 'c8cb74d1-f53b-526f-865e-273fcbe143c6', 'feb84e30-669d-564a-96ac-d435b2e6c48b', '56da2b9e-e6fb-5028-9d6c-4195da6f26d6', '21eb079a-45a9-53e3-9d0a-1364a01716fe', '5599eaa3-c6d6-566d-b9b2-a1893b338c12', 'c8a33bee-3bb6-5f20-b406-f5ddb1ebd079', '7c6130eb-3f0f-50c4-9eef-5466756ea42b', '2c9035e9-5ae1-5cf0-b0d2-f0616ffac199', '098a0efc-79f2-512d-a048-860c85fda97b', '004a8254-8420-526c-bb6d-237275cc6ef9', 'b6e4b0d7-66cd-52c8-98a0-6f806b7224f4', '405fad40-3cd4-541d-b7e2-2fab37c7ce1d', '013fb210-49a1-566f-ba39-f497d18194a7', '28c5f75e-9466-587b-b6b1-bef2b0588364', '84d70d04-dba9-5e67-9e8d-c26058b2939c', '4fa9ce47-4526-5d12-a435-f580681c1b68', 'e8ef617b-0a6e-5a31-8945-e5f23ac8939d', '8c493414-bc73-5a47-b3aa-3a9a015f0cb0', '4c6ea2ca-a736-57e3-9ecd-bdf27d80e57d', '46167fc7-a5a3-5c99-9e7a-76ef821c4ea8', 'f390c8ea-73b4-5b57-b0f4-7bed87121f91', '3b29b1d7-50bf-512d-8e3e-976cc9f6e280', '8cf25378-63e8-54ce-b7e6-8271cf0d3f9a', 'e987c5b5-79b3-58f7-a84b-82c4ccd7d93f', 'eea5a563-2cc4-5640-bd71-5fe114e6af00', '43c32e7a-4280-5175-9756-d96675f1ed2d', 'f367d303-b49f-5faf-a816-113c89e02850', '1da924ac-0d6e-5713-aefc-b0afcf82a907', '03a47dfa-9701-5a93-ac9d-6bc5916c6d24', 'c481ad56-babe-52ed-8a85-369989a3d5b3', '59711c8e-2e5a-5e06-a2f4-371fcfb30a66', 'a85a9e7e-bc4c-5b51-a8bb-795c297f9518', 'f439a3cc-32e1-5774-8455-67312b1d81c8', 'bd0149bb-51fa-5114-9c16-526a6b28e6e7', '9220cabd-860a-5fe0-b831-2db449f66703', '1710e06b-d7bb-5fcd-80bd-61208c742f4a', '50235b05-2d0f-58ff-b16a-40a474c6f355', '475c5383-aa76-56ef-8efa-f23d31ceabfb', '430e0edd-ae62-583d-884f-3c049f997cba', 'afc1e3a2-bb8b-5906-8c68-dee6afb74e1f', '5e584c82-1582-57ad-98fc-8b80c800aacb', '27f32323-db53-54ac-88af-01f168c7fc78', 'f491ab1f-7cb9-539f-ad2b-b7ecef34d672', '3e2db2ab-cd3f-5bed-8e0e-3ae4986fde01', '6cd9358e-7c13-537c-853e-8e405cc9e3a7', 'd8cbf181-2f84-52e1-903d-b7b78ddca284', '58b0005c-7bf4-54ec-a742-ad6809a601cc', '7cdadd45-bdd3-5cae-942e-6511c1334dc3', 'dd7ad022-6c84-5dde-a64e-97ac51e8e01e', 'dd0e1900-6fda-5a60-90e0-96cecf6371b7', 'df743959-8198-593f-be8c-6d84b96143ed', '4515be63-551b-5fdc-bdcf-ec88ba5f09bc', '466096c9-4678-5d5e-a3d7-4f76aa24e579', 'd03fcce5-d888-5250-80e5-290fc41d6c63', 'df2841b4-ecaa-5bf5-89c3-0d85e7a405d6', 'f118db83-abfd-58a6-ad25-c1190004c1d8', 'bc37ceb8-6afa-5259-aa9f-d0ccf83971a6', 'e591e379-9fcb-58ea-b6e4-4b8f2d938bea', '8ba012ca-5a44-5196-a63d-632ec8daa7a1', '146b12da-bb6c-5bea-b9e7-419d1d09ae62', 'b2bea37f-bad7-5c15-9e1f-93abcda70d19', 'a3ab2bd3-009f-50dc-b276-99bd2f3aff24', 'aed780b5-3b00-5a12-9741-1716647602ac', 'f1747c6c-8010-57c3-b938-667a1d8c1bb6', '76710c06-ee2a-59e6-98b7-3cd2757465a4', '01b09cac-1878-52c0-bad4-3032ef420683', 'ff0ab38e-519c-5487-8cf6-9cfc7af83dfd', '88879c4a-a4ca-5308-8804-3c357389e435', '30c40bc1-9b91-5a16-85ac-cddbb17d1550', '3aa5d594-5b76-5b28-bb44-3599e1c78867', '3f11dc3d-034e-53c5-b71a-336f2ec90fbc', '84062536-3032-5fda-8cd8-048cf8a4cf49', 'ebc7b672-cbea-5184-8b45-292e030c7032', 'dd5a9a0c-1db3-51a2-a8f6-2e666574f349', '690330b3-3705-5244-93b5-7a7f0ded499d', '214fc19d-4228-5ec1-b4bf-456689d67fb0', '80b802ea-2476-561b-8158-eca6061a0b1c', '847dacd3-df00-5769-b062-42b335c01cfd', '9ba33431-01ad-590a-8c75-2539bdaaf05c', 'e98d6365-86b6-57b6-a034-e97a93dc43b2', '9bf4c61f-1f30-5e77-bbf2-992d22c050f1', '3dd8bc36-300d-5597-acad-a6aebd60f2f6', '27a490bf-c41f-5d28-bf79-60e31e3cb4f4', '0ed6eb00-98be-5ff7-a7bf-51be10932691', '9d615262-c844-5752-a11b-402198f5ec6c', '0c2bbd9a-11bf-5e52-b01d-7f13dacb53f3', 'fcc8d426-b7eb-5b84-9b9e-33ce10ebc15e', '137fcd26-eb9a-53c0-a723-1a07773fe6e4', '53338972-5071-5cfc-8650-15cb8109305a', '0f3e858b-6cb4-5ca1-a9aa-44af5493ee1b', 'b556aa78-c227-58bc-80a5-98a7c7c9fb41', 'c9fdb666-4dc2-56f3-9c5d-906996974fcb', 'c6eedf60-11bb-5c5a-aee8-38276fb1d3bb', 'aae91432-cbc7-514a-839b-250ba689e772', 'f2a20886-3613-576a-aebb-f85fa86364ef', '69814c04-d27d-569d-a639-096f2de1c2a6', '4770a433-3886-5703-81b6-7e9f3e1fee2c', 'c141ecdb-d6b1-56a1-a947-01d33c149278', '8279d782-3b81-56ab-a862-c164ea60b4b1', '6ed891de-a390-57ab-be2c-4ad971addacb', '040163b8-e671-5ff2-9a54-ed277b54e2de', '5148db3d-1964-574d-8f0e-ca26944c988f', '4b29f0ad-fca6-59ec-9fe5-46969496a368', 'ffa07eb9-980a-5760-a970-cb14bfd33258', '9a8c8e73-de1a-5a29-b2d9-f9e1e36033f7', 'c0e1481d-8da4-55f2-bb90-b4c9de48b412', 'af8627d6-5f1f-5b9c-8fb9-7c0645d491e4', 'd2c05598-67a4-5d70-b96f-a2800ec72ace', 'f10aaa96-9d8b-516e-a769-3e461391c0df', 'f7a029e6-52af-5fe4-843c-48fc59a2ab08', 'd94df869-3946-5ce7-aa3e-0a7ede014eca', '50167193-f094-5445-a91c-3b7511d4522f', 'a665d099-1387-56d0-85e4-7dcee09f8d15', 'aad31943-47a3-5231-b359-0f8db8019b20', 'b4a29b51-8f09-52bd-8100-5e3eb8038bb0', 'dc54610c-db52-5f2e-a218-344d51bec8bd', '2b4969c2-33fb-5630-81a4-d8700fb59501', '33dc7bc7-ee23-54fc-940a-407d6e3b4042', '1898b678-8cab-5403-aac7-6d24a9373849', '42fb7a9b-4eab-5245-9389-4196739e0c08', 'aa39f16e-7a5f-5ef2-9d38-97644da04e3a', 'fa6f555f-59c5-5bdf-b4a1-43a910026ba1', 'f9c00506-4253-5009-9bb8-d5d73b185968', 'd33d6107-cdc1-51bb-9f26-39b192eaee9c', '176323dc-5fee-5c88-a612-e5678ee912fd', 'dc34c4d6-f6e6-5324-8480-5d504fdf553d', '352599cd-5e63-50d8-86f4-fae01a2aa92f', 'a5ad5b35-9dfe-5661-91db-ac45b03ef345', '471c96ef-33e6-50ae-a650-4c8f636f8857', '0f261eda-844c-57a8-8f09-68ddecef8332', '1f98e62c-86d9-511b-9f3a-6d7de15929c4', '64f28a54-b53e-59b1-b1e5-9274dc1a9903', '162d3578-02b3-55a9-ac40-1e60d77a728d', 'b4f9caf6-3c09-50a6-aa4a-faaccdbf3eae', 'e843c297-6b7f-5f1d-91d9-e483b1f0a16a', 'db4bb59a-2a4d-530c-af6d-d0c45583c130', '59c19d0b-5132-5d1e-9fd8-f896de26067b', '1796fdd4-b5e6-551a-ba13-848ee995fde0', 'e046b341-1207-5968-8389-b3ed8c91cd20', 'e81d307c-36b4-57b6-bb49-faab5e97376a', 'cd4791db-8309-5018-bbf1-6f563bb648c1', '9e2739ee-a2ed-5462-9de8-8d12001fac01', '4d7e9a27-c417-5ba2-96e5-635a180f29cf', 'f307463d-ab12-5585-9f70-a9ea2465c7b1', 'c015968d-c9fc-5044-879f-7371aab459ea', 'ab98a58c-07e4-519f-bdeb-ae3211953174', '63da6087-fbb9-5282-8c9e-becb02c3b9b2', '3fb6cb4b-a2a7-57f0-8df1-695235220e3d', '51e02a3a-0345-564a-898c-397d84db993d', 'ffb57c5c-81ec-5657-953f-2094d78871ad', '7f0e8da5-98dd-520a-807b-2c72d24f97f0', '8bf95d2b-a0e4-5004-bd0e-3c716352aa8a', '54e4dc3f-1848-55d9-8dd8-337a76c79468', 'a2e18e23-7ac3-5e1b-b596-59d1ef753971', 'dc3d2f5f-4ae6-50fb-8aff-88363f33046e', '45fc3132-4df2-5bf8-83ce-4bb897b73661', 'a2879ff2-2184-51b5-aa53-ee1a82e88778', 'e1f76367-82ae-5b14-a72e-52ede13373fb', 'f8836777-6edd-5ee9-84ed-b39db4ed15d6', 'bff51d5a-e33d-5a47-b55a-2080baa8b553', '172d7f21-420f-5117-81eb-2744a5fd1452', '6921053f-9eac-5838-b8bd-8620df915f1c', 'e6bdc1f5-d073-5c3b-bd2f-c73239ef5aec', 'cd818406-5bc2-54b2-b95d-0c2e3517ebcc', 'f4888e6e-639c-52a1-a9b4-52d8dbbd6465', '412f8aca-30db-5f69-a7cf-527272928846', '44e34dc8-bcbd-5bda-b995-1649b61efbf6', '6fbe9bc3-f5d4-5258-831c-faef86b9c9b0', '9d54be6f-4671-59e3-ad6a-59f84a190aa4', '58656d3d-e89a-5006-9a46-f996e7a209ae', '78feae4d-328c-58bb-87f2-ac70ecc4483f', '7fbba347-d64b-5373-b843-172ab492c5f7', 'a3ef06c5-a4a0-5872-a764-2a253fc1f327', 'bc40d337-22ce-5959-a651-29040927f2d3', '609fcae9-c62b-5f21-900f-942a4fe9d93b', '2180f398-eca5-5b4d-a57f-9f3f2b9666bd', '628212cb-6a32-5ab1-b14a-5fb6f481bc4b', '5fcf98c2-1b24-5bf9-8361-3d912e599669', 'bc013dbe-4e85-5daa-b965-fec3e6859064', 'c1325c47-8080-5f6b-a08a-0fd8ec422d0c', '70553d09-269d-5bd3-8f2c-fe641a566dca', 'b7392365-61fb-5e35-a13e-2530cb6f8316', '70f13759-b5cd-5eb6-9ec8-6378232ec41a', '8df6a17a-2244-5012-8bdf-4860981a435c', 'f16e303a-0202-59ae-9e47-38624c38e35c', '2b2cb90a-5301-5685-9878-236343b3e08f', 'e133645c-491a-5806-b31d-dcf3d742d134', '00415703-a422-5f89-a771-970e250a0449', '348827a7-a911-5679-8e88-87a14edd3fb3', '88e0fcd1-a30a-5727-b0e9-fd65ca4b69f9', 'b7e2cd9a-bd99-5cf8-90c4-727c489174a0', 'e30eb9e9-0b27-5478-bf19-363d945276ce', 'f1fd5e73-48ae-5ac1-b432-683fdfb924ee', 'f02d6681-4ab8-5941-a079-418c19325737', '5e4a8725-ef47-5338-b07a-78b19d051876', 'cb1cb46f-0612-54c7-a231-e1b2c311e689', '892be656-b934-5bcb-8bc0-80275c81ee22', '6f6006e0-9460-50d6-b342-d2b3c9bbf6bc', '70db6903-d420-5d03-bfae-11576caaba8b', '6a8bb171-a6a1-50b5-a2b2-fcd8629142a2', '30fae1e2-a2f8-5e92-9a44-7202fe5133a7', 'e1266e06-5faa-5169-9c58-831e6b3f1e69', '269b79c9-17b2-5d7f-a77a-e581a11e62a7', 'cb34d288-9b7f-5478-9d12-6827df2e3d9d', 'bcac38ec-586b-50af-a3dd-08a70b96c6ad', 'bbed3291-6143-58d0-9210-3d38148bb2e9', 'd5d08bcc-9436-5f53-bf84-1b59710cdf12', '0b4437b1-0480-5af0-a5b5-779f81013abf', 'dea1e869-0d4b-5edf-b02b-2d2cc50c91b6', '46d23004-c60c-52c2-9c71-30ef98227ec7', '274e6979-e710-5e55-90a4-26654382709f', 'd6cd4183-575d-5dbf-887d-775201a622c7', '59c1ecab-1250-55a7-8604-f9f3b60650f6', '5c45cf56-9514-5019-b22c-62a582529717', '0646374b-628d-5512-856b-8e813afffe76', 'b4884fd9-e82e-5f32-8626-32280b56d57b', 'aed198a4-5dc0-5a8b-8a34-ecc58cd3cdcf', '22a135c2-754b-5a3d-9096-35a25c735c83');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-b1' AND c.id NOT IN ('464c5886-b18e-52e8-99d0-8d9b162cfcfd', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', '8aac7900-13ea-5a11-873f-dce09fae9763', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', 'Le plus-que-parfait', 'Raconte le passé du passé : forme l''auxiliaire (avoir ou être) à l''imparfait + le participe passé pour exprimer une action antérieure à une autre action passée. Maîtrise le choix de l''auxiliaire, l''accord du participe, et le rôle du plus-que-parfait dans l''hypothèse (si + plus-que-parfait) et le discours indirect au passé.', '# ⚔️ Le plus-que-parfait — Le passé du passé

> 💡 «Quand tu arrives à la gare, le train est déjà parti. Le plus-que-parfait, c''est l''arme qui raconte ce qui s''était passé AVANT ton histoire.»

---

## 🏰 1. À quoi sert le plus-que-parfait

Tu sais déjà raconter le passé avec le **passé composé** (action terminée) et l''**imparfait** (décor, habitude). Le **plus-que-parfait** ajoute une troisième couche : il exprime une action **antérieure** à une autre action passée — le « passé du passé ».

> _Quand je suis arrivé, le train **était** déjà **parti**._

L''ordre des événements sur la ligne du temps :

```
Action la plus ancienne (plus-que-parfait) → action passée (passé composé / imparfait) → MAINTENANT
       était parti                                 je suis arrivé
```

---

## ⚡ 2. La formation : auxiliaire à l''IMPARFAIT + participe passé

Le plus-que-parfait se construit comme le passé composé, mais l''auxiliaire est à l''**imparfait** (et non au présent) :

$$ auxiliaire (avoir ou être) à l''imparfait + participe passé $$

| Passé composé        | Plus-que-parfait       |
| -------------------- | ---------------------- |
| j''**ai** mangé       | j''**avais** mangé      |
| il **est** parti     | il **était** parti     |
| elle **s''est** levée | elle **s''était** levée |

C''est la même mécanique : seul l''auxiliaire change de temps. _Présent → imparfait_, et le participe passé ne bouge pas.

---

## 🔮 3. Conjugaison complète (avoir / être)

Rappel des auxiliaires à l''imparfait : **avoir** → j''avais, tu avais, il avait, nous avions, vous aviez, ils avaient · **être** → j''étais, tu étais, il était, nous étions, vous étiez, ils étaient.

| Personne    | Avec **avoir** (manger) | Avec **être** (partir)                     |
| ----------- | ----------------------- | ------------------------------------------ |
| je / j''     | j''avais mangé           | j''étais parti(e)                           |
| tu          | tu avais mangé          | tu étais parti(e)                          |
| il / elle   | il/elle avait mangé     | il était parti / elle était partie         |
| nous        | nous avions mangé       | nous étions parti(e)s                      |
| vous        | vous aviez mangé        | vous étiez parti(e)s                       |
| ils / elles | ils/elles avaient mangé | ils étaient partis / elles étaient parties |

---

## 🛡️ 4. Auxiliaire et accord : exactement comme au passé composé

Le choix de l''auxiliaire et les règles d''accord sont **identiques** à celles du passé composé (niveau A2) :

- La **plupart** des verbes prennent **avoir** : _j''avais vu, nous avions pris._
- Les **verbes de mouvement** de la « maison de être » (aller, venir, partir, arriver, entrer, sortir, monter, descendre, naître, mourir, rester, tomber…) et **tous les verbes pronominaux** prennent **être** : _elle était venue, je m''étais levé._

| Auxiliaire | Accord du participe            | Exemple                                            |
| ---------- | ------------------------------ | -------------------------------------------------- |
| **être**   | s''accorde avec le **sujet**    | _Elles étaient part**ies**. Je m''étais lev**ée**._ |
| **avoir**  | **pas** d''accord avec le sujet | _Elle avait mang**é**. Ils avaient fin**i**._      |

> ⚠️ Piège : avec **avoir**, on n''accorde **jamais** le participe avec le sujet → _Elle avait mang**é**_, jamais _~~Elle avait mangée~~_.

---

## 🧮 5. L''emploi : antériorité dans le passé

Le plus-que-parfait s''utilise dès que **deux actions passées** se suivent et que tu veux montrer **laquelle est arrivée en premier**.

> _Il **avait** déjà **fini** quand je l''ai appelé._ (D''abord il finit, ensuite je l''appelle.)

**Mots-signaux** qui appellent souvent le plus-que-parfait :

| Mot-signal          | Exemple                                          |
| ------------------- | ------------------------------------------------ |
| **déjà**            | Le film avait **déjà** commencé.                 |
| **ne … pas encore** | Elle n''avait **pas encore** mangé.               |
| **quand**           | **Quand** je suis arrivé, il était parti.        |
| **parce que**       | J''étais fatigué **parce que** j''avais mal dormi. |

> 🗡️ Astuce : si tu peux dire « avant cela… », c''est souvent le signe d''un plus-que-parfait.

---

## 🪄 6. Deux emplois B1 à connaître

**L''hypothèse (regret / irréel du passé)** — après **si**, le plus-que-parfait se combine avec le **conditionnel passé** :

> _**Si** j''**avais su**, je **serais venu** plus tôt._ (Mais je ne savais pas → je ne suis pas venu.)

**Le discours indirect au passé** — quand on rapporte des paroles introduites par un verbe au passé, le passé composé devient plus-que-parfait :

> _Il a dit : « J''ai fini. »_ → _Il a dit qu''il **avait fini**._

> 🏆 Porte franchie ! Tu sais maintenant raconter le passé du passé, choisir l''auxiliaire et accorder le participe. Prochaine étape : les **pronoms compléments** pour alléger tes phrases sans rien répéter.', '# 📜 Résumé : Le plus-que-parfait

- **Sens :** une action **antérieure** à une autre action passée — le « passé du passé ».
- **Formation :** auxiliaire (avoir ou être) à l''**imparfait** + participe passé (_j''avais mangé, j''étais parti, elle s''était levée_).
- **Auxiliaire :** même choix qu''au passé composé — _être_ pour les verbes de mouvement (maison de être) et tous les pronominaux, _avoir_ pour les autres.
- **Accord :** avec _être_, le participe s''accorde avec le **sujet** (_elles étaient parties_) ; avec _avoir_, **pas** d''accord avec le sujet (_elle avait mangé_).
- **Emploi :** montrer quelle action passée est arrivée en premier (_Il avait déjà fini quand je l''ai appelé_).
- **Mots-signaux :** _déjà, ne … pas encore, quand, parce que_.
- **Hypothèse (irréel du passé) :** _si_ + plus-que-parfait → conditionnel passé (_Si j''avais su, je serais venu_).
- **Discours indirect au passé :** le passé composé devient plus-que-parfait (_Il a dit qu''il avait fini_).
- **Pièges :** ne pas confondre avec le passé composé (auxiliaire au présent) ; ne pas oublier l''accord avec _être_.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', 'Les pronoms compléments : COD, COI, y, en', 'Évite les répétitions et allège tes phrases : remplace un complément par le bon pronom. Distingue le COD (le, la, les) du COI (lui, leur), maîtrise y (à + chose / lieu) et en (de + chose / quantité), place le pronom correctement (verbe conjugué, infinitif, impératif) et accorde le participe passé avec le COD antéposé.', '# ⚔️ Les pronoms compléments — L''art de ne jamais se répéter

> 💡 «Un bon combattant ne frappe jamais deux fois au même endroit. Un bon locuteur ne répète jamais le même mot : il le remplace par un pronom.»

## 🏰 Pourquoi des pronoms compléments ?

Tu sais déjà conjuguer. Maintenant, tu vas **alléger** tes phrases. Au lieu de répéter un nom, tu le remplaces par un **pronom complément**. C''est le réflexe qui distingue un débutant d''un locuteur de niveau **B1**.

_« Tu connais Marie ? — Oui, je connais Marie. »_ → lourd.
_« Tu connais Marie ? — Oui, je **la** connais. »_ → naturel.

Tout le secret tient en une question : **quel complément** est-ce que je remplace ? Direct, indirect, un lieu, une quantité ? Chaque type a **son** pronom.

## ⚡ La carte des pronoms

Apprends ce tableau par cœur : choisir le mauvais pronom change le sens ou rend la phrase fausse.

| Pronom              | Remplace                           | Exemple                                       |
| ------------------- | ---------------------------------- | --------------------------------------------- |
| **le, la, l'', les** | un COD (nom **sans préposition**)  | _Je vois Marie._ → _Je **la** vois._          |
| **lui, leur**       | un COI = **à + personne**          | _Je parle à Paul._ → _Je **lui** parle._      |
| **y**               | **à + chose** ou un **lieu**       | _Je pense à mon travail._ → _J''**y** pense._  |
| **en**              | **de + chose** ou une **quantité** | _Je parle de mon projet._ → _J''**en** parle._ |

## 🛡️ COD ou COI ? La question décisive

Le **COD** (complément d''objet **direct**) suit le verbe **sans préposition**. On le trouve avec _« qui ? »_ ou _« quoi ? »_.

_J''aime **les fruits**._ → J''aime **quoi** ? → _Je **les** aime._

Le **COI** (complément d''objet **indirect**) est introduit par la préposition **à** quand il s''agit d''une **personne**. On le trouve avec _« à qui ? »_.

_Je téléphone **à ma sœur**._ → à qui ? → _Je **lui** téléphone._

| Verbe + complément direct | → COD | Verbe + « à » + personne | → COI |
| ------------------------- | ----- | ------------------------ | ----- |
| voir **Marie**            | la    | parler **à Marie**       | lui   |
| aider **les élèves**      | les   | écrire **aux élèves**    | leur  |

> ⚠️ Piège classique : ne confonds pas **le/la/les** (COD) et **lui/leur** (COI). On dit _Je **lui** téléphone_ (téléphoner **à** qqn = COI), jamais _~~Je le téléphone~~_. Mais _Je **le** vois_ (voir qqn = COD), jamais _~~Je lui vois~~_.

## 🔮 Y et EN : les deux pronoms spéciaux

**Y** remplace **à + chose** (jamais une personne) ou un **lieu**.

_Je pense **à mes vacances**._ → _J''**y** pense._
_Je vais **à Paris**._ → _J''**y** vais._

**EN** remplace **de + chose** ou une **quantité** (un nombre, _du, de la, des, beaucoup de…_).

_Je parle **de mon projet**._ → _J''**en** parle._
_J''ai **trois livres**._ → _J''**en** ai trois._ (on garde le nombre !)
_Je veux **du café**._ → _J''**en** veux._

> 🗡️ Astuce mémoire : **à → y**, **de → en**. Et avec une quantité, **en** est obligatoire : _Tu as des frères ? — Oui, j''**en** ai deux._, jamais _~~j''ai deux~~_.

## 🧮 La place du pronom

Le pronom se met **juste devant le verbe** dont il dépend.

- Devant le **verbe conjugué** : _Je **le** vois. — Nous **leur** parlons._
- Devant l''**infinitif** : _Je vais **le** voir. — Tu peux **lui** parler._
- À la forme **négative**, le pronom reste collé au verbe : _Je **ne le** vois **pas**._

À l''**impératif affirmatif**, exception ! Le pronom passe **après** le verbe, relié par un **trait d''union** (et _me/te_ deviennent _moi/toi_) :

_Regarde-**le** ! — Parle-**lui** ! — Donne-**moi** le livre ! — Penses-**y** !_

> 🗡️ Mais à l''impératif **négatif**, on revient à l''ordre normal : _Ne **le** regarde pas ! — Ne **lui** parle pas !_

## 🧪 L''accord du participe passé avec le COD antéposé

Voici la finesse de niveau B1. Au passé composé avec **avoir**, le participe passé **s''accorde** avec le COD **s''il est placé AVANT** le verbe (et seulement avec le COD, jamais le COI).

$$ avoir + participe → accord avec le COD placé AVANT $$

_J''ai vu **les filles**._ (COD après → pas d''accord) → _Je **les** ai vu**es**._ (COD avant → accord !)
_Les lettres que j''ai écrit**es**…_ (« que » = les lettres, COD avant → accord)

> ⚠️ Piège : pas d''accord avec un **COI** ! _Je **leur** ai parlé_ (jamais _~~parlés~~_) : « leur » est un COI, donc le participe reste invariable.

## 👑 Bonus élite : l''ordre des doubles pronoms

Quand deux pronoms se suivent devant le verbe, l''ordre est fixe :

$$ me/te/se/nous/vous < le/la/les < lui/leur < y < en $$

_Je **te le** donne. — Il **le lui** explique. — Je **lui en** parle. — Il y **en** a._

> 🏆 Porte franchie ! Tu remplaces désormais n''importe quel complément par le bon pronom, tu le places correctement et tu accordes le participe. Prochaine quête : les **pronoms relatifs** (_qui, que, dont, où_) pour souder deux idées en une phrase élégante.', '# 📜 Résumé : Les pronoms compléments (COD, COI, y, en)

- **COD** — _le, la, l'', les_ : remplace un complément **direct** (sans préposition) : _Je vois Marie → Je **la** vois._
- **COI** — _lui, leur_ : remplace **à + personne** : _Je parle à Paul → Je **lui** parle._
- ⚠️ **COD ≠ COI** — _Je **le** vois_ (voir qqn = direct) mais _Je **lui** parle_ (parler à qqn = indirect). Ne pas confondre.
- **Y** — remplace **à + chose** ou un **lieu** : _Je pense à mon travail → J''**y** pense ; Je vais à Paris → J''**y** vais._
- **EN** — remplace **de + chose** ou une **quantité** : _Je parle de mon projet → J''**en** parle ; J''ai trois livres → J''**en** ai trois._
- **Place** — devant le verbe conjugué ou l''infinitif (_Je le vois ; Je vais le voir_) ; à l''**impératif affirmatif**, après le verbe avec trait d''union (_Regarde-**le** ! Parle-**lui** !_).
- **Accord** — au passé composé avec _avoir_, le participe s''accorde avec le **COD placé avant** (_Je **les** ai vu**es**_), jamais avec le COI (_Je leur ai parlé_).
- **Doubles pronoms** — ordre fixe : _me/te/se/nous/vous < le/la/les < lui/leur < y < en_ (_Je **le lui** donne_).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', 'Les pronoms relatifs : qui, que, où, dont', 'Relie deux idées en une seule phrase grâce aux pronoms relatifs : qui (sujet), que (COD, avec l''accord du participe passé), où (lieu ou temps) et dont (complément introduit par « de »). Maîtrise aussi ce qui / ce que / ce dont pour reprendre une idée entière.', '# ⚔️ Les pronoms relatifs — forge deux phrases en une seule lame

> 💡 «Un bon conteur ne répète jamais un nom : le pronom relatif est la chaîne qui soude deux idées en une phrase fluide.»

## 🏰 À quoi sert un pronom relatif

Un **pronom relatif** ajoute une information sur un nom (l''**antécédent**) sans ouvrir une nouvelle phrase. Au lieu de deux phrases courtes, tu les soudes avec _qui, que, où, dont_.

_Je connais un homme. Cet homme répare les vélos._ → _Je connais un homme **qui** répare les vélos._

Le pronom relatif renvoie au nom placé juste avant et introduit la **proposition relative**.

## ⚡ Les quatre pronoms en un coup d''œil

Le choix du pronom dépend de sa **fonction** dans la relative, pas du nom lui-même. Apprends ce tableau, c''est le cœur du chapitre.

| Pronom   | Fonction dans la relative       | Exemple                                                  |
| -------- | ------------------------------- | -------------------------------------------------------- |
| **qui**  | **sujet** du verbe              | _L''homme **qui** parle est mon voisin._                  |
| **que**  | **COD** du verbe                | _Le livre **que** je lis est passionnant._               |
| **où**   | **lieu** ou **temps**           | _La ville **où** j''habite ; le jour **où** il arrivera._ |
| **dont** | complément introduit par **de** | _Le film **dont** je parle (parler **de**)._             |

> 🗡️ Astuce : après **qui** vient un **verbe** (qui est sujet) ; après **que** vient un **sujet** + verbe (que est COD). _L''ami **qui** vient_ / _l''ami **que** j''invite_.

## 🛡️ QUI contre QUE — le duel central

**Qui** est le **sujet** de la relative : il fait l''action, un verbe le suit directement.

_La femme **qui** chante est ma sœur._ (c''est elle qui chante)

**Que** (ou **qu''** devant voyelle) est le **COD** : un autre sujet fait l''action sur l''antécédent.

_La chanson **que** j''écoute est belle._ (j''écoute la chanson)

> ⚠️ Piège classique : ne dis jamais _~~l''homme que parle~~_. Si un verbe suit, c''est **qui** ; si un sujet suit, c''est **que**.

## 🔮 QUE et l''accord du participe passé

Avec l''auxiliaire **avoir**, le participe passé s''accorde avec le **COD** quand celui-ci est placé **avant** le verbe — et **que** est justement ce COD placé avant. Le participe s''accorde donc avec l''antécédent de **que**.

_Les fleurs **que** j''ai **achetées** sont fanées._ (j''ai acheté quoi ? → les fleurs, féminin pluriel → -ées)

_Les livres **que** tu as **lus**._ (masculin pluriel → -s)

> 🗡️ Réflexe : avec **avoir**, cherche le COD ; s''il est avant (souvent introduit par **que**), accorde. Avec **qui** (sujet), il n''y a pas d''accord de ce type.

## 🧭 OÙ — le lieu et le temps

**Où** marque un **lieu** ou un **moment**. Il remplace _dans lequel, sur lequel, au moment où_.

_La maison **où** je vis est ancienne._ (lieu) — _Le jour **où** tu es né, il neigeait._ (temps)

> ⚠️ Piège : ne confonds pas **où** (lieu/temps) et **que**. _Le pays **où** je vis_ (lieu), mais _le pays **que** je visite_ (COD). On ne dit pas _~~le jour que je suis arrivé~~_ pour le temps : c''est _le jour **où**_.

## 🧪 DONT — le pronom du « de »

**Dont** remplace un complément introduit par **de** : après un **verbe** (parler **de**, rêver **de**, avoir besoin **de**), après un **nom** (le nom **de**, l''auteur **de**), ou après un **adjectif** (fier **de**, content **de**).

| Construction      | Exemple                                            |
| ----------------- | -------------------------------------------------- |
| verbe + **de**    | _Le film **dont** je parle._ (parler de)           |
| nom + **de**      | _L''auteur **dont** je connais le nom._ (le nom de) |
| adjectif + **de** | _Le projet **dont** je suis fier._ (fier de)       |

> ⚠️ Piège : **dont** ne sert qu''avec **de**. Pour _penser **à**, compter **sur**, travailler **pour**_, on n''emploie pas dont : _la personne **à qui** je pense_, _l''outil **avec lequel** je travaille_ — jamais _~~dont je pense~~_.

## 🌌 CE QUI, CE QUE, CE DONT — reprendre une idée entière

Quand l''antécédent n''est pas un nom précis mais une **idée** (ou « cela »), on emploie **ce** + relatif :

_Je ne sais pas **ce qui** se passe._ (ce qui = sujet) — _Dis-moi **ce que** tu veux._ (ce que = COD) — _Voilà **ce dont** j''ai besoin._ (avoir besoin de).

> 🏆 Gate franchie ! Avec _qui, que, où, dont_ tu relies les idées comme un locuteur fluide et tu maîtrises l''accord du participe avec **que**. Prochaine étape : le subjonctif présent. En avant, héros.', '# 📜 Résumé : les pronoms relatifs (qui, que, où, dont)

- **But** — le pronom relatif relie deux phrases en une seule en reprenant un nom (l''antécédent) : _Je connais un homme qui répare les vélos._
- **qui** — **sujet** de la relative ; un verbe le suit : _L''homme qui parle est mon voisin._
- **que** — **COD** de la relative ; un sujet + verbe le suit : _Le livre que je lis._
- **Accord avec que** — avec l''auxiliaire avoir, le participe s''accorde avec ce COD placé avant : _les fleurs que j''ai achetées_.
- **où** — **lieu** ou **temps** : _la ville où j''habite ; le jour où il est arrivé._
- **dont** — remplace un complément en **de** (verbe, nom ou adjectif + de) : _le film dont je parle ; l''auteur dont je connais le nom ; le projet dont je suis fier._
- **ce qui / ce que / ce dont** — reprennent une idée entière : _Je ne sais pas ce qui se passe ; dis-moi ce que tu veux ; voilà ce dont j''ai besoin._
- ⚠️ Pièges — _qui_ (verbe après) ≠ _que_ (sujet après) ; _où_ pour le lieu/temps ≠ _que_ (COD) ; _dont_ uniquement avec **de**, jamais avec à/sur/pour.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', 'Le subjonctif présent', 'Maîtrise le subjonctif présent : sa formation (radical de la 3e personne du pluriel + terminaisons -e, -es, -e, -ions, -iez, -ent), les irréguliers fréquents (être, avoir, aller, faire, pouvoir, savoir, vouloir, falloir) et ses emplois après la volonté, l''obligation, l''émotion, le doute et certaines conjonctions — face à l''indicatif (je pense que, j''espère que, il est certain que).', '# ⚔️ Le subjonctif présent — Le mode du désir et du doute

> 💡 «L''indicatif raconte ce qui est ; le subjonctif murmure ce qu''on veut, ce qu''on craint, ce dont on doute. Apprends à manier cette arme et tu parleras le français des nuances.»

## 🏰 Indicatif ou subjonctif ?

Le **subjonctif** n''est pas un temps mais un **mode**. L''**indicatif** présente un fait comme **réel et certain** (_il vient_) ; le **subjonctif** présente une action comme **souhaitée, redoutée, incertaine ou dépendante d''une volonté** (_je veux qu''il vienne_).

Le subjonctif vit presque toujours dans une **proposition subordonnée introduite par « que »** : _Il faut **que** tu partes. — Je doute **qu''**il réussisse._

## ⚡ La formation : un radical, six terminaisons

On prend le radical de la **3e personne du pluriel du présent de l''indicatif** (la forme « ils »), on enlève **-ent**, puis on ajoute les terminaisons **-e, -es, -e, -ions, -iez, -ent**.

_ils **parl**ent → parl- · ils **finiss**ent → finiss- · ils **prenn**ent → prenn-_

| Pronom        | Terminaison | _parler_              | _finir_                 | _prendre_             |
| ------------- | ----------- | --------------------- | ----------------------- | --------------------- |
| que je        | **-e**      | que je parl**e**      | que je finiss**e**      | que je prenn**e**     |
| que tu        | **-es**     | que tu parl**es**     | que tu finiss**es**     | que tu prenn**es**    |
| qu''il/elle/on | **-e**      | qu''il parl**e**       | qu''il finiss**e**       | qu''il prenn**e**      |
| que nous      | **-ions**   | que nous parl**ions** | que nous finiss**ions** | que nous pren**ions** |
| que vous      | **-iez**    | que vous parl**iez**  | que vous finiss**iez**  | que vous pren**iez**  |
| qu''ils/elles  | **-ent**    | qu''ils parl**ent**    | qu''ils finiss**ent**    | qu''ils prenn**ent**   |

> 🗡️ Astuce : les formes **« nous »** et **« vous »** ressemblent souvent à l''**imparfait** : _que nous parlions, que vous finissiez_. C''est normal — ne t''inquiète pas du doublon, le contexte (« que ») révèle le subjonctif.

> ⚠️ Piège : certains verbes (comme _prendre, venir, boire_) ont **deux radicaux** : un pour je/tu/il/ils (_prenn-_) et un pour nous/vous (_pren-_). _qu''il prenne_ mais _que nous prenions_.

## 🔮 Les irréguliers à connaître par cœur

Quelques verbes très fréquents ont un radical **irrégulier**. Ce sont les plus utilisés — apprends-les comme des sorts.

| Verbe       | que je…        | que nous…          |
| ----------- | -------------- | ------------------ |
| **être**    | que je sois    | que nous soyons    |
| **avoir**   | que j''aie      | que nous ayons     |
| **aller**   | que j''aille    | que nous allions   |
| **faire**   | que je fasse   | que nous fassions  |
| **pouvoir** | que je puisse  | que nous puissions |
| **savoir**  | que je sache   | que nous sachions  |
| **vouloir** | que je veuille | que nous voulions  |
| **falloir** | qu''il faille   | — (impersonnel)    |

> 🗡️ Astuce : _être_ et _avoir_ ne suivent pas la règle des terminaisons : _que je **sois**_ (pas ~~que je suis~~), _que j''**aie**_ (pas ~~que j''ai~~).

## 🛡️ Quand dégainer le subjonctif

Le subjonctif est **déclenché** par certaines expressions dans la principale.

| Déclencheur                                  | Sens                | Exemple                                            |
| -------------------------------------------- | ------------------- | -------------------------------------------------- |
| **il faut que, je veux que**                 | volonté, obligation | _Il faut **que** tu **fasses** tes devoirs._       |
| **il est nécessaire que, exiger que**        | obligation          | _Le chef exige **que** nous **soyons** à l''heure._ |
| **je suis content / triste que**             | émotion, sentiment  | _Je suis content **que** tu **viennes**._          |
| **avoir peur que, regretter que**            | émotion             | _J''ai peur **qu''**il **ne** **soit** en retard._   |
| **je ne pense pas que, il est possible que** | doute, possibilité  | _Je ne pense pas **qu''**il **ait** raison._        |
| **il se peut que**                           | possibilité         | _Il se peut **qu''**il **pleuve**._                 |

Certaines **conjonctions** imposent toujours le subjonctif : **pour que, bien que, avant que, à condition que, jusqu''à ce que**.

_Je t''explique **pour que** tu **comprennes**. — **Bien qu''**il **soit** fatigué, il travaille. — Attends **jusqu''à ce que** je **revienne**._

## 🧭 Indicatif ou subjonctif ? Le duel des opinions

C''est le piège majeur du B1. Une opinion **affirmée** = un fait pour celui qui parle → **indicatif**. La même opinion **niée ou mise en doute** → **subjonctif**.

| Phrase                            | Mode           | Exemple                                 |
| --------------------------------- | -------------- | --------------------------------------- |
| **je pense que** (affirmatif)     | **indicatif**  | _Je pense qu''il **a** raison._          |
| **je ne pense pas que** (négatif) | **subjonctif** | _Je ne pense pas qu''il **ait** raison._ |
| **j''espère que**                  | **indicatif**  | _J''espère qu''il **viendra**._           |
| **il est certain / sûr que**      | **indicatif**  | _Il est certain qu''il **réussira**._    |
| **il est possible que**           | **subjonctif** | _Il est possible qu''il **réussisse**._  |

> ⚠️ Piège : _**espérer que**_ reste à l''**indicatif** même s''il exprime un souhait ! _J''espère que tu **vas** bien_ (et non ~~que tu ailles~~). De même, _je pense / je crois / il est sûr que_ + indicatif.

> 🏆 Porte franchie ! Tu sais désormais former le subjonctif, citer ses irréguliers et choisir entre indicatif et subjonctif selon que tu affirmes un fait ou exprimes un désir, un doute ou une émotion. Prochaine étape : **le conditionnel et l''hypothèse** pour rêver à voix haute.', '# 📜 Résumé : le subjonctif présent

- **Mode, pas temps** — l''indicatif dit le fait réel (_il vient_), le subjonctif dit le souhait, le doute, l''émotion (_je veux qu''il **vienne**_), toujours après « que ».
- **Formation** — radical de la 3e personne du pluriel du présent (ils parlent → parl-, ils finissent → finiss-) + terminaisons **-e, -es, -e, -ions, -iez, -ent** : _que je parle, que nous parlions_.
- **Nous / vous** ressemblent à l''imparfait : _que nous finissions, que vous preniez_ ; les verbes à deux radicaux gardent _pren-_ à nous/vous (_que nous prenions_).
- **Irréguliers** — être (que je sois, que nous soyons), avoir (que j''aie, que nous ayons), aller (que j''aille), faire (que je fasse), pouvoir (que je puisse), savoir (que je sache), vouloir (que je veuille), falloir (qu''il faille).
- **Volonté / obligation** — il faut que, je veux que, il est nécessaire que, exiger que → subjonctif.
- **Émotion / sentiment** — je suis content/triste/surpris que, avoir peur que, regretter que → subjonctif.
- **Doute / possibilité** — je ne pense pas que, il est possible que, il se peut que → subjonctif.
- **Conjonctions** — pour que, bien que, avant que, à condition que, jusqu''à ce que → subjonctif.
- ⚠️ **Indicatif** après l''opinion affirmée et l''espoir : _je pense que, j''espère que, il est certain que_ + indicatif ; mais _je ne pense pas que_ + subjonctif.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', 'Le conditionnel et l''hypothèse', 'Exprime la politesse, le souhait, le conseil et l''information non confirmée avec le conditionnel présent (radical du futur + terminaisons de l''imparfait), puis construis des phrases hypothétiques avec « si » : si + présent → futur (potentiel), si + imparfait → conditionnel présent (irréel du présent), si + plus-que-parfait → conditionnel passé (irréel du passé) — et retiens la règle d''or : jamais de futur ni de conditionnel après « si ».', '# ⚔️ Le conditionnel et l''hypothèse — l''arme des mondes possibles

> 💡 «Le présent dit ce qui est, le conditionnel dit ce qui pourrait être. Maîtrise-le, et tu ouvres la porte de tous les futurs imaginables.»

## 🏰 La porte des possibles

Tu sais déjà parler du réel. Voici maintenant l''arme du **possible** et de l''**imaginaire** : le **conditionnel**. Il sert à demander poliment, à rêver, à conseiller, et surtout à bâtir des **hypothèses** avec « si ». À la fin de ce chapitre, tu sauras dire _je voudrais_ au lieu du brutal _je veux_, et tu construiras des phrases comme _Si j''avais le temps, je voyagerais._

_J''aimerais un café, s''il te plaît. — Si j''étais riche, j''achèterais une maison au bord de la mer._

## ⚡ Former le conditionnel présent

La formule est simple et élégante : **radical du FUTUR + terminaisons de l''IMPARFAIT**. Les terminaisons sont **-ais, -ais, -ait, -ions, -iez, -aient** — exactement celles de l''imparfait.

| Pronom     | Terminaison | _parler_ (rad. parler-) | _finir_ (rad. finir-) |
| ---------- | ----------- | ----------------------- | --------------------- |
| je         | **-ais**    | je parler**ais**        | je finir**ais**       |
| tu         | **-ais**    | tu parler**ais**        | tu finir**ais**       |
| il/elle/on | **-ait**    | il parler**ait**        | il finir**ait**       |
| nous       | **-ions**   | nous parler**ions**     | nous finir**ions**    |
| vous       | **-iez**    | vous parler**iez**      | vous finir**iez**     |
| ils/elles  | **-aient**  | ils parler**aient**     | ils finir**aient**    |

> 🗡️ La clé : le radical est **toujours celui du futur** (il contient le **r** du futur). _Je parle**r**ai_ (futur) → _je parle**r**ais_ (conditionnel). Seule la terminaison change.

## 🔮 Les radicaux irréguliers à connaître

Les verbes irréguliers gardent leur **radical du futur** et prennent les terminaisons de l''imparfait. Apprends-les par cœur : ce sont les plus utilisés.

| Verbe       | Radical futur | Conditionnel présent |
| ----------- | ------------- | -------------------- |
| **être**    | **ser-**      | je **serais**        |
| **avoir**   | **aur-**      | j''**aurais**         |
| **aller**   | **ir-**       | j''**irais**          |
| **faire**   | **fer-**      | je **ferais**        |
| **pouvoir** | **pourr-**    | je **pourrais**      |
| **devoir**  | **devr-**     | je **devrais**       |
| **vouloir** | **voudr-**    | je **voudrais**      |

## 🛡️ À quoi sert le conditionnel ?

Le conditionnel présent a quatre emplois majeurs. Repère l''intention derrière la phrase.

| Emploi                        | Exemple                                                   |
| ----------------------------- | --------------------------------------------------------- |
| **Politesse**                 | _Je **voudrais** un thé. **Pourriez**-vous m''aider ?_     |
| **Souhait / rêve**            | _J''**aimerais** visiter le Japon._                        |
| **Conseil**                   | _Tu **devrais** te reposer. Il **faudrait** partir tôt._  |
| **Information non confirmée** | _Le président **serait** déjà à Paris._ (selon la rumeur) |

> 🗡️ Astuce politesse : _je veux_ est sec, _je **voudrais**_ est poli. En français, demander au conditionnel est un réflexe de bonne éducation.

## 🧮 L''hypothèse avec « si » : les trois systèmes

Une phrase hypothétique a deux parties : la **condition** (avec « si ») et la **conséquence**. Le temps de chaque partie dépend du degré de réalité.

| Système               | Condition (si…)           | Conséquence              | Exemple                                           |
| --------------------- | ------------------------- | ------------------------ | ------------------------------------------------- |
| **Potentiel / réel**  | si + **présent**          | **futur** (ou présent)   | _Si j''**ai** le temps, je **viendrai**._          |
| **Irréel du présent** | si + **imparfait**        | **conditionnel présent** | _Si j''**avais** le temps, je **viendrais**._      |
| **Irréel du passé**   | si + **plus-que-parfait** | **conditionnel passé**   | _Si j''**avais eu** le temps, je **serais venu**._ |

Le premier système parle d''une condition **possible** (j''aurai peut-être le temps). Le deuxième d''une situation **imaginaire au présent** (je n''ai pas le temps, mais j''imagine). Le troisième d''un **regret sur le passé** (je n''ai pas eu le temps, c''est fini).

## 🧪 La règle d''or : jamais de futur ni de conditionnel après « si »

C''est l''erreur n° 1 des apprenants. Après le **« si » d''hypothèse**, on ne met **JAMAIS** ni futur ni conditionnel.

> ⚠️ Pièges classiques à éviter :
>
> - ~~Si je **serais** riche…~~ → **Si j''étais** riche, je serais content. (si + imparfait)
> - ~~Si j''**aurais** le temps…~~ → **Si j''avais** le temps, j''irais. (si + imparfait)
> - ~~Si tu **viendras**…~~ → **Si tu viens**, on dînera ensemble. (si + présent)

Le conditionnel et le futur vont dans la **conséquence**, jamais dans la proposition introduite par « si ».

> 🗡️ Méthode anti-erreur : pour l''irréel du présent, mets l''imparfait après « si » et le conditionnel après. _Si + imparfait_ ↔ _conditionnel_. C''est un couple inséparable.

> 🏆 Porte franchie ! Tu sais désormais demander avec politesse, rêver, conseiller, et bâtir les trois systèmes hypothétiques sans tomber dans le piège du « si je serais ». Prochaine étape : **le discours indirect** pour rapporter les paroles des autres (_Il dit qu''il viendra_).', '# 📜 Résumé : Le conditionnel et l''hypothèse

- **Former le conditionnel présent** — radical du **futur** + terminaisons de l''**imparfait** (-ais, -ais, -ait, -ions, -iez, -aient) : _je parlerais_, _je finirais_.
- **Radicaux irréguliers** — être→**ser-** (je serais), avoir→**aur-** (j''aurais), aller→**ir-** (j''irais), faire→**fer-** (je ferais), pouvoir→**pourr-**, devoir→**devr-**, vouloir→**voudr-**.
- **Emplois** — politesse (_je voudrais_, _pourriez-vous_), souhait (_j''aimerais_), conseil (_tu devrais_, _il faudrait_), information non confirmée (_le président serait à Paris_).
- **Hypothèse — potentiel** : si + **présent** → **futur** (_Si j''ai le temps, je viendrai_).
- **Hypothèse — irréel du présent** : si + **imparfait** → **conditionnel présent** (_Si j''avais le temps, je viendrais_).
- **Hypothèse — irréel du passé** : si + **plus-que-parfait** → **conditionnel passé** (_Si j''avais eu le temps, je serais venu_).
- ⚠️ **Règle d''or** — après « si », **jamais** de futur ni de conditionnel : on dit _Si j''**étais**…_ (pas ~~si je serais~~) et _Si j''**avais**…_ (pas ~~si j''aurais~~).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', 'Le discours indirect', 'Apprends à rapporter les paroles d''autrui : du discours direct au discours indirect, avec QUE, SI, les mots interrogatifs, DE + infinitif, la concordance des temps au passé et la transformation des marqueurs de temps.', '# ⚔️ Le discours indirect — l''art de rapporter les paroles

> 💡 «Répéter les mots d''un autre n''est pas les recopier : c''est les retisser. Maîtrise les fils et tu rapportes tout sans trahir.»

## 🏰 Direct ou indirect : deux façons de rapporter

Quand tu rapportes ce que quelqu''un a dit, tu as deux armes. Le **discours direct** cite les mots exacts entre guillemets : _Il dit : « Je suis fatigué. »_ Le **discours indirect** intègre ces mots dans ta phrase, sans guillemets, à l''aide d''un **verbe introducteur** (dire, demander, répondre, expliquer…) et d''un mot de liaison : _Il dit **qu''**il est fatigué._

Passer du direct à l''indirect, c''est faire trois ajustements : changer le **mot de liaison**, adapter les **pronoms et possessifs**, et — si le verbe introducteur est au passé — appliquer la **concordance des temps**.

## ⚡ Au présent : le bon mot de liaison

Quand le verbe introducteur est au **présent** (ou au futur), les temps de la phrase rapportée **ne changent pas**. Seul change le mot de liaison, selon le type de phrase rapportée.

| Phrase de départ             | Type                       | Mot de liaison      | Exemple rapporté                |
| ---------------------------- | -------------------------- | ------------------- | ------------------------------- |
| « Je suis prêt. »            | déclarative                | **que**             | Il dit **qu''**il est prêt.      |
| « Tu viens ? »               | question fermée (oui/non)  | **si**              | Il demande **si** tu viens.     |
| « Où habites-tu ? »          | question avec mot interro. | **on garde le mot** | Il demande **où** tu habites.   |
| « Qu''est-ce que tu fais ? »  | « qu''est-ce que »          | **ce que**          | Il demande **ce que** tu fais.  |
| « Qu''est-ce qui se passe ? » | « qu''est-ce qui »          | **ce qui**          | Il demande **ce qui** se passe. |
| « Sors ! »                   | impératif (ordre)          | **de + infinitif**  | Il dit **de** sortir.           |

> 🗡️ Mémorise le duo piège : « qu''est-ce **que** » (COD) → **ce que** ; « qu''est-ce **qui** » (sujet) → **ce qui**. Le _que/qui_ d''origine te dit lequel choisir.

Les mots interrogatifs **où, quand, comment, pourquoi, combien, qui** se conservent tels quels : _« Pourquoi pleures-tu ? » → Il demande **pourquoi** tu pleures._ Attention : après le mot interrogatif, on revient à l''ordre **sujet + verbe** (plus d''inversion).

## 🛡️ Les pronoms et possessifs changent de camp

Celui qui rapporte n''est pas celui qui a parlé : les pronoms se réajustent. _Marie dit : « **J''**aime **mon** travail. » → Marie dit qu''**elle** aime **son** travail._ Le « je » de Marie devient « elle » dans ta bouche ; le « mon » devient « son ».

> ⚠️ Piège classique : oublier ce changement et écrire _Marie dit qu''**elle** aime **mon** travail_ — ce qui voudrait dire qu''elle aime **ton** travail à toi. Le sens bascule !

## 🔮 Au passé : la concordance des temps

Si le verbe introducteur est au **passé** (il a dit, il disait, il a demandé), les temps de la phrase rapportée **reculent** d''un cran. C''est la **concordance des temps**.

| Temps au discours direct | devient au discours indirect passé | Exemple                                                    |
| ------------------------ | ---------------------------------- | ---------------------------------------------------------- |
| présent                  | **imparfait**                      | « Je **suis** prêt » → Il a dit qu''il **était** prêt.      |
| passé composé            | **plus-que-parfait**               | « J''**ai fini** » → Il a dit qu''il **avait fini**.         |
| futur simple             | **conditionnel présent**           | « Je **viendrai** » → Il a dit qu''il **viendrait**.        |
| imparfait                | **imparfait** (ne change pas)      | « Il **faisait** beau » → Il a dit qu''il **faisait** beau. |

> 🗡️ Astuce : l''imparfait et le plus-que-parfait ne reculent plus — ils sont déjà « au fond » du passé. Seuls présent, passé composé et futur bougent.

## 🧭 Les marqueurs de temps se déplacent aussi

Quand on rapporte au passé, les repères temporels changent de point de vue : le « aujourd''hui » du locuteur n''est plus ton aujourd''hui.

| Discours direct | Discours indirect (passé) |
| --------------- | ------------------------- |
| aujourd''hui     | **ce jour-là**            |
| hier            | **la veille**             |
| demain          | **le lendemain**          |
| maintenant      | **à ce moment-là**        |

_« Je pars **demain** » → Il a dit qu''il partait **le lendemain**._

> ⚠️ Piège : laisser le marqueur d''origine (_Il a dit qu''il partait **demain**_) crée un contresens temporel si tu rapportes des jours plus tard.

> 🏆 Porte franchie ! Tu sais désormais rapporter une affirmation, une question et un ordre — au présent comme au passé, en réajustant pronoms, temps et marqueurs. Prochaine étape : enchaîner tout cela dans un récit complet sans jamais trahir le sens d''origine.', '# 📜 Résumé : le discours indirect

- **Principe** : rapporter les paroles d''autrui sans guillemets, via un verbe introducteur (dire, demander…) + un mot de liaison ; on adapte pronoms, possessifs et marqueurs de temps.
- **Au présent (mot de liaison)** : déclarative → **que** ; question oui/non → **si** ; mot interrogatif (où, quand, comment, pourquoi) → on le **garde** ; « qu''est-ce que » → **ce que** ; « qu''est-ce qui » → **ce qui** ; impératif → **de + infinitif**.
- **Ordre des mots** : après le mot interrogatif, on revient à sujet + verbe (plus d''inversion).
- **Pronoms/possessifs** : ils changent selon le nouveau locuteur (« j''aime mon travail » → il dit qu''il aime son travail).
- **Concordance des temps (verbe introducteur au passé)** : présent → imparfait ; passé composé → plus-que-parfait ; futur simple → conditionnel présent ; l''imparfait reste imparfait.
- **Marqueurs de temps (au passé)** : aujourd''hui → ce jour-là ; hier → la veille ; demain → le lendemain ; maintenant → à ce moment-là.
- **Pièges** : confondre si/que et ce que/ce qui, oublier le changement de pronom, mauvaise concordance, marqueur de temps non transformé.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', 'Vocabulaire B1 : le travail et la société', 'Enrichis ton lexique de niveau intermédiaire autour de quatre grands thèmes de société : le monde du travail et de l''emploi, l''environnement et l''écologie, les médias et internet, et l''expression de l''opinion. Le vocabulaire utile pour comprendre l''actualité et débattre au niveau B1 (DELF B1).', '# 🗡️ Vocabulaire B1 : le travail et la société — Le lexique du citoyen-héros

> 💡 «Au niveau B1, on ne se contente plus de survivre : on prend la parole, on donne son avis, on débat. Pour cela, il faut les mots de la cité et du monde réel.»

Tu as déjà conquis le vocabulaire de la ville et de la vie quotidienne (A2). Cette quête te fait monter d''un palier : voici les **mots de la société adulte** — le travail, la planète, l''information, l''opinion. Ce sont les mots qui reviennent dans tous les sujets du DELF B1.

## 🏢 Le travail et l''emploi

C''est le champ le plus utile pour parler de ton avenir. Distingue bien **l''emploi** (le fait d''avoir un travail) du **chômage** (le fait de ne pas en avoir).

| Mot                           | Sens                                                        |
| ----------------------------- | ----------------------------------------------------------- |
| **un emploi / un poste**      | un travail, une fonction dans une entreprise                |
| **un entretien (d''embauche)** | la rencontre où l''on est interrogé avant d''être engagé      |
| **un CV**                     | le document qui résume ton parcours et tes compétences      |
| **une lettre de motivation**  | la lettre où tu expliques pourquoi tu veux le poste         |
| **un salaire**                | l''argent que l''on gagne chaque mois en travaillant          |
| **un contrat (CDI / CDD)**    | l''accord signé ; CDI = durée indéterminée, CDD = déterminée |
| **un(e) collègue**            | une personne avec qui tu travailles                         |
| **une entreprise**            | l''organisation, la société où l''on travaille                |
| **le chômage**                | la situation d''une personne sans emploi                     |

Les **verbes** essentiels : **postuler** (à un poste = présenter sa candidature), **embaucher** (= engager un salarié), **licencier** (= renvoyer un salarié, à l''initiative du patron), **démissionner** (= partir de soi-même, à l''initiative du salarié), **gagner sa vie** (= gagner assez d''argent pour vivre).

_« Après mon **entretien d''embauche**, l''**entreprise** a décidé de m''**embaucher** en **CDI**. Mon premier **salaire** arrive à la fin du mois. »_

> ⚠️ Piège classique : **licencier** ≠ **démissionner**. C''est le patron qui **licencie** (il met dehors), c''est l''employé qui **démissionne** (il s''en va lui-même). Ne les inverse jamais.

## 🌍 L''environnement et la planète

Un grand thème de société — et un sujet d''examen fréquent. Apprends à parler de la **protection de la planète**.

| Mot                               | Sens                                                   |
| --------------------------------- | ------------------------------------------------------ |
| **le climat**                     | l''ensemble des conditions météo d''une région           |
| **le réchauffement (climatique)** | la hausse des températures de la planète               |
| **la pollution**                  | la dégradation de l''air, de l''eau, du sol              |
| **le recyclage**                  | le fait de transformer les déchets pour les réutiliser |
| **les déchets**                   | ce que l''on jette (ordures, emballages)                |
| **l''énergie (renouvelable)**      | l''énergie qui ne s''épuise pas (soleil, vent, eau)      |
| **la planète**                    | la Terre, notre environnement commun                   |

Les **verbes** clés : **protéger** (l''environnement), **polluer** (= salir, dégrader), **gaspiller** (= utiliser sans nécessité, perdre), **trier** (= séparer les déchets pour le recyclage), **économiser** (= utiliser moins, garder ; le contraire de gaspiller).

_« Pour **protéger la planète**, il faut **trier** ses **déchets**, **économiser** l''eau et l''électricité, et ne pas **gaspiller**. »_

> 🗡️ Astuce : **gaspiller** et **économiser** sont des contraires. On **gaspille** l''eau quand on la perd inutilement ; on l''**économise** quand on en utilise moins.

## 📱 Les médias et internet

Pour comprendre **l''actualité** et t''**informer**, voici le vocabulaire de l''information moderne.

| Mot                                 | Sens                                                 |
| ----------------------------------- | ---------------------------------------------------- |
| **une information / une actualité** | une nouvelle, un fait récent                         |
| **un journal**                      | un média qui publie l''actualité (papier ou en ligne) |
| **un réseau social**                | un site/une appli pour échanger (messages, photos)   |
| **un article**                      | un texte écrit dans un journal ou un site            |
| **une publicité**                   | un message qui cherche à vendre un produit           |
| **une source**                      | l''origine d''une information (qui la donne)           |

Les **verbes** : **s''informer** (= chercher à savoir ce qui se passe), **partager** (= diffuser à d''autres, surtout en ligne), **publier** (= rendre public un texte, une photo), **se connecter** (= entrer dans un compte, un site).

_« Je **m''informe** chaque matin en lisant les **actualités**. Avant de **partager** un **article** sur un **réseau social**, je vérifie toujours la **source**. »_

> ⚠️ Piège : une **information** est un fait ; une **publicité** cherche à te vendre quelque chose. Ne confonds pas s''**informer** (savoir) et la **publicité** (vendre).

## 💬 Donner son opinion et exprimer ses sentiments

Au niveau B1, tu dois pouvoir **réagir** et **débattre**. Voici les mots de l''opinion et du sentiment.

| Expression                       | Sens                                       |
| -------------------------------- | ------------------------------------------ |
| **être d''accord / pas d''accord** | partager / refuser une idée                |
| **soutenir**                     | défendre, appuyer (une idée, une personne) |
| **critiquer**                    | juger négativement, désapprouver           |
| **s''inquiéter (de)**             | ressentir de la peur, du souci             |
| **espérer**                      | souhaiter que quelque chose de bon arrive  |
| **douter (de)**                  | ne pas être sûr, mettre en question        |

Et des **collocations** que les correcteurs adorent voir : **prendre une décision** (= décider), **faire des efforts** (= se donner du mal), **avoir besoin de** (= nécessiter), **jouer un rôle** (= être important dans une situation).

_« Je suis **d''accord** avec toi : chacun doit **faire des efforts**. Nous devons **prendre une décision** rapidement, car l''environnement **joue un rôle** essentiel. »_

> 🗡️ Astuce : on dit **être d''accord AVEC** quelqu''un, **s''inquiéter DE** quelque chose, **douter DE** quelque chose, et **avoir besoin DE** quelque chose. La bonne préposition fait partie du mot — apprends-la avec le verbe.

> 🏆 Quête accomplie ! Tu disposes maintenant du lexique pour parler du travail, défendre la planète, lire l''actualité avec esprit critique et donner ton avis. Ce sont les mots du citoyen — et de tout candidat au DELF B1. Prochaine étape : t''en servir pour comprendre un texte argumentatif.', '# 📜 Résumé : Vocabulaire B1 — le travail et la société

- **Le travail** : un emploi/poste, un entretien d''embauche, un CV, une lettre de motivation, un salaire, un contrat (CDI/CDD), un collègue, une entreprise, le chômage.
- **Verbes du travail** : postuler, embaucher (engager), licencier (le patron renvoie), démissionner (l''employé part), gagner sa vie.
- **L''environnement** : le climat, le réchauffement, la pollution, le recyclage, les déchets, l''énergie renouvelable, la planète.
- **Verbes de l''écologie** : protéger, polluer, gaspiller ↔ économiser, trier.
- **Les médias** : une information/actualité, un journal, un réseau social, un article, une publicité, une source.
- **Verbes des médias** : s''informer, partager, publier, se connecter.
- **L''opinion** : être d''accord/pas d''accord, soutenir ↔ critiquer, s''inquiéter, espérer, douter.
- **Collocations utiles** : prendre une décision, faire des efforts, avoir besoin de, jouer un rôle.
- **Pièges à retenir** : licencier ≠ démissionner ; gaspiller ≠ économiser ; une information ≠ une publicité ; respecter les prépositions (d''accord avec, s''inquiéter de, besoin de).', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', 'Compréhension écrite : textes argumentatifs et inférence', 'Développe tes compétences de lecture au niveau B1 sur des textes variés et plus longs — articles de presse, courriers formels, témoignages, critiques, forums et textes informatifs. Apprends à dégager la thèse, repérer un détail précis, identifier l''intention et le point de vue de l''auteur, percevoir le ton, distinguer fait et opinion, et deviner le sens d''un mot grâce au contexte.', '# 📖 Compréhension écrite : textes argumentatifs et inférence

> 💡 «Un bon lecteur B1 ne lit pas tous les mots : il _chasse_ l''information utile, devine le non-dit et démasque l''opinion cachée derrière les faits.»

Bienvenue à la Porte des Textes, héros. Ici, les ennemis ne sont pas des monstres mais des **pièges de lecture** : un détail qui se fait passer pour l''idée principale, une opinion déguisée en fait, un mot inconnu qui te bloque. Apprends ces stratégies et tu franchiras chaque texte — article, courrier, témoignage, critique — sans tomber dans le panneau.

## 🏰 Les types de textes au niveau B1

Au DELF B1, tu rencontres des textes plus longs et plus **argumentatifs** qu''au niveau A2 :

| Type de texte         | Ce que c''est                            | Exemple                       |
| --------------------- | --------------------------------------- | ----------------------------- |
| **Article de presse** | informe ou défend une opinion           | article, billet de blog       |
| **Courrier formel**   | demande, réclamation, lettre officielle | lettre de motivation, plainte |
| **Témoignage**        | récit d''une expérience personnelle      | interview, blog perso         |
| **Critique**          | avis argumenté sur une œuvre            | film, livre, restaurant       |
| **Texte informatif**  | explique un sujet, donne des faits      | brochure, page documentaire   |
| **Message de forum**  | échange entre internautes               | question, conseil, débat      |

Tu dois maîtriser plusieurs **compétences** : trouver la **thèse**, repérer un **détail précis**, saisir l''**intention** de l''auteur, percevoir le **ton**, **inférer** le non-dit, deviner un **mot** par le contexte, et **distinguer un fait d''une opinion**.

## ⚡ Stratégie 1 — Lire les questions AVANT le texte

Avant de plonger dans le texte, lis toutes les questions. Elles te disent **quoi chercher** et te font gagner du temps.

> 🗡️ Astuce : souligne les mots-clés de chaque question. Pendant la lecture, tu **balaies** le texte à la recherche de ces mots — tu n''absorbes pas chaque phrase.

## 🔮 Stratégie 2 — La structure d''un texte argumentatif

Un texte argumentatif suit souvent ce plan : une **thèse** (l''idée défendue), des **arguments** qui la soutiennent, des **exemples** qui illustrent, parfois une **objection** puis une **conclusion**.

- La **thèse** = l''idée centrale, ce que l''auteur veut te faire admettre. → repère-la dans le titre, l''introduction et la conclusion.
- Un **argument** = une raison logique qui appuie la thèse.
- Un **exemple** = un cas concret qui illustre un argument (chiffre, anecdote, citation).

> ⚠️ Piège : un mauvais choix « idée principale » prend souvent un détail **vrai mais trop étroit** — il figure bien dans le texte, mais ce n''est pas le cœur du propos.

## 🛡️ Stratégie 3 — Les connecteurs logiques, ces panneaux de signalisation

Les connecteurs t''indiquent la **direction** du raisonnement. Apprends-les : ils sont la carte du texte.

| Relation        | Connecteurs                                 |
| --------------- | ------------------------------------------- |
| **Cause**       | car, parce que, puisque, en effet           |
| **Conséquence** | donc, c''est pourquoi, par conséquent, ainsi |
| **Opposition**  | mais, cependant, pourtant, en revanche      |
| **Concession**  | bien que, malgré, même si, certes… mais     |
| **Addition**    | de plus, en outre, par ailleurs             |

> 🗡️ Astuce : après un connecteur d''opposition (_mais, pourtant, en revanche_), l''auteur dit souvent le **contraire** de ce qui précède — et c''est là que se cache son vrai point de vue.

## 🧭 Stratégie 4 — Distinguer le fait de l''opinion

- Un **fait** est vérifiable : une date, un chiffre, un événement. _« Le musée a ouvert en 2019. »_
- Une **opinion** est un jugement personnel, souvent marqué par des mots évaluatifs (_excellent, décevant, à mon avis, il faudrait_). _« Ce musée est le plus beau de la ville. »_

> ⚠️ Piège : une opinion peut **ressembler** à un fait. Cherche les adjectifs de jugement et les verbes comme _penser, croire, estimer, devoir_ : ils signalent une opinion.

## 🔮 Stratégie 5 — Intention, point de vue et ton de l''auteur

- L''**intention** = pourquoi l''auteur écrit (convaincre, informer, se plaindre, conseiller, remercier).
- Le **point de vue** = est-il pour, contre, ou nuancé sur le sujet ?
- Le **ton** = l''attitude qui transparaît : **positif** (enthousiaste, élogieux), **négatif** (critique, agacé), ou **neutre** (objectif, informatif).

_« Hélas, ce roman traîne en longueur et m''a profondément ennuyé. »_ → ton **négatif** ; intention : critiquer.

> 🗡️ Astuce : le ton se lit dans le **vocabulaire évaluatif** et la ponctuation. _Hélas, malheureusement, quel dommage_ → négatif ; _heureusement, génial, je recommande_ → positif.

## 🧪 Stratégie 6 — Deviner un mot grâce au contexte

Quand un mot t''est inconnu, ne bloque pas : utilise les **indices autour**.

1. Relis toute la phrase qui contient le mot.
2. Cherche les indices : cause-conséquence, mot d''opposition (_mais, pourtant_), synonyme ou exemple proche.
3. Remplace le mot par chaque option et garde celle qui a un **sens logique**.

> ⚔️ Exemple travaillé — démonte le piège
>
> Texte : _« Malgré un budget colossal et des acteurs célèbres, le film s''est révélé un fiasco total : la salle était presque vide et la critique unanimement sévère. Le réalisateur, pourtant chevronné, a manifestement sous-estimé l''attente du public. »_
>
> **Q : Que signifie « fiasco » ici ?**
> Indices : _« la salle était presque vide »_, _« la critique unanimement sévère »_, et le connecteur _« Malgré »_ qui oppose le gros budget au résultat. Tout pointe vers un **échec retentissant**. → _fiasco_ = un échec total. (Pas « un succès » : ce serait ignorer _presque vide_ et _sévère_.)
>
> **Q : Quel est le point de vue de l''auteur sur ce film ?**
> Le vocabulaire (_fiasco total, sévère, sous-estimé_) est entièrement négatif : l''auteur juge le film **raté**. ✓
>
> **Q : « Le réalisateur a sous-estimé l''attente du public » est-ce un fait ou une opinion ?**
> Le mot _manifestement_ et le verbe d''interprétation _sous-estimé_ signalent un **jugement** de l''auteur : c''est une **opinion**, pas un fait vérifiable.

## 🧙 Stratégie 7 — L''élimination, ton arme de secours

Quand tu hésites, élimine les réponses clairement fausses :

1. Barre toute option qui **contredit** le texte.
2. Méfie-toi des mots **extrêmes** (_toujours, jamais, tous, aucun_) absents du texte.
3. Barre les options qui **déforment** le texte (un détail mélangé, exagéré, ou tiré de ta culture générale et non du texte).

> ⚠️ Piège : la bonne réponse vient **du texte seul**, jamais de ce que tu sais par ailleurs. Une « sur-interprétation » qui va plus loin que le texte est un mauvais choix.

> 🏆 Quête accomplie ! Tu disposes maintenant de la panoplie complète du lecteur B1 : thèse, connecteurs, fait vs opinion, ton et point de vue, devinette par le contexte. Applique-les à chaque texte et regarde ta précision grimper jusqu''au DELF B1.', '# 📜 Résumé : Compréhension écrite — textes argumentatifs et inférence

- **Lire les questions d''abord** : souligne les mots-clés, puis balaie le texte pour les retrouver.
- **Structure argumentative** : repère la **thèse** (idée défendue), les **arguments** et les **exemples** ; la thèse se trouve souvent au titre, en intro et en conclusion.
- **Connecteurs logiques** : cause (_car, puisque_), conséquence (_donc, ainsi_), opposition (_mais, pourtant_), concession (_bien que, malgré_) — après une opposition se cache souvent le vrai point de vue.
- **Fait vs opinion** : un fait est vérifiable (date, chiffre) ; une opinion est un jugement (_excellent, à mon avis, il faudrait_).
- **Intention, point de vue, ton** : pourquoi l''auteur écrit (convaincre, informer, se plaindre) et son attitude — **positif**, **négatif** ou **neutre** — lue dans le vocabulaire évaluatif.
- **Mot inconnu** : devine par le contexte (cause, opposition, synonyme proche), puis teste chaque option.
- **Inférence** : conclus à partir des indices, sans rien inventer ; la réponse vient **du texte seul**.
- **Élimination** : barre ce qui contredit, exagère (_toujours, jamais_) ou déforme le texte.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5d963c5c-a10f-5eac-a9c4-f38b4de12871', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7066b78-4699-5d36-b438-d67c28c54bf1', '5d963c5c-a10f-5eac-a9c4-f38b4de12871', 'Complète : « Quand je suis arrivé, le train ___ déjà parti. »', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"a"},{"id":"d","text":"avait"}]'::jsonb, 'b', 'Le verbe « partir » se conjugue avec l''auxiliaire être. Au plus-que-parfait, l''auxiliaire est à l''imparfait : « était parti ». « Est parti » serait du passé composé ; « a / avait » sont des formes de avoir, mauvais auxiliaire pour partir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00174f78-8815-5b40-89ca-f40876840013', '5d963c5c-a10f-5eac-a9c4-f38b4de12871', 'Comment se forme le plus-que-parfait ?', '[{"id":"a","text":"auxiliaire au présent + participe passé"},{"id":"b","text":"auxiliaire au futur + participe passé"},{"id":"c","text":"auxiliaire à l''imparfait + participe passé"},{"id":"d","text":"auxiliaire au passé composé + participe passé"}]'::jsonb, 'c', 'Le plus-que-parfait = auxiliaire (avoir ou être) à l''imparfait + participe passé, par exemple « j''avais mangé ». Avec l''auxiliaire au présent, on obtient le passé composé (« j''ai mangé »), pas le plus-que-parfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('432d7db4-6c66-5a8b-a5cb-15d1263b0398', '5d963c5c-a10f-5eac-a9c4-f38b4de12871', 'Quelle phrase est au plus-que-parfait ?', '[{"id":"a","text":"Elle a mangé une pomme."},{"id":"b","text":"Elle mangeait une pomme."},{"id":"c","text":"Elle avait mangé une pomme."},{"id":"d","text":"Elle mange une pomme."}]'::jsonb, 'c', '« Elle avait mangé » a l''auxiliaire avoir à l''imparfait (avait) + participe passé : c''est le plus-que-parfait. « A mangé » est du passé composé, « mangeait » de l''imparfait, et « mange » du présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e8fec34-83fe-5d13-a046-c846ce6c5001', '5d963c5c-a10f-5eac-a9c4-f38b4de12871', 'Complète : « Elle ___ levée tôt ce matin-là. »', '[{"id":"a","text":"s''était"},{"id":"b","text":"s''avait"},{"id":"c","text":"était"},{"id":"d","text":"avait"}]'::jsonb, 'a', '« Se lever » est un verbe pronominal : il se conjugue toujours avec être. Au plus-que-parfait, on obtient « elle s''était levée », avec l''accord du participe avec le sujet féminin. « S''avait / avait » sont impossibles car les pronominaux ne prennent jamais avoir.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91cff74a-b912-5129-a90e-9b4f0f3b1642', '5d963c5c-a10f-5eac-a9c4-f38b4de12871', 'Le plus-que-parfait exprime une action qui se passe…', '[{"id":"a","text":"après une autre action passée"},{"id":"b","text":"avant une autre action passée"},{"id":"c","text":"en même temps que le moment présent"},{"id":"d","text":"dans le futur"}]'::jsonb, 'b', 'Le plus-que-parfait est le « passé du passé » : il marque l''antériorité, c''est-à-dire une action arrivée avant une autre action passée (« Il avait fini quand je suis arrivé »). Il ne concerne ni le présent ni le futur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5efe148d-7a31-5022-a12b-01d2e884157f', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', '⭐ Entraînement : le plus-que-parfait', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('650d639b-40fb-50d6-ae85-9d9280a20b7f', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Complète : « J''___ déjà mangé quand tu as appelé. »', '[{"id":"a","text":"ai"},{"id":"b","text":"avais"},{"id":"c","text":"étais"},{"id":"d","text":"avait"}]'::jsonb, 'b', '« Manger » prend l''auxiliaire avoir, qui doit être à l''imparfait au plus-que-parfait : « j''avais mangé ». « Ai » donnerait le passé composé ; « étais » est le mauvais auxiliaire ; « avait » ne s''accorde pas avec « je ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('549ca8b5-a046-5ad9-8a8d-a0fff46232bc', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Complète : « Ils ___ partis avant la fin du film. »', '[{"id":"a","text":"avaient"},{"id":"b","text":"ont"},{"id":"c","text":"sont"},{"id":"d","text":"étaient"}]'::jsonb, 'd', '« Partir » se conjugue avec être. Au plus-que-parfait, l''auxiliaire être est à l''imparfait : « ils étaient partis ». « Sont partis » serait du passé composé ; « avaient / ont » sont le mauvais auxiliaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0d75035-5e2c-548e-ae4a-92c98bc349e6', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Quel est le participe passé du verbe « prendre » ?', '[{"id":"a","text":"prendu"},{"id":"b","text":"prené"},{"id":"c","text":"prit"},{"id":"d","text":"pris"}]'::jsonb, 'd', '« Prendre » est irrégulier : son participe passé est « pris » (j''avais pris). « Prendu / prené » n''existent pas, et « prit » est une forme du passé simple, pas le participe passé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb59fc14-7e29-5fb9-9e33-90e1d20ff816', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Complète : « Nous ___ fini nos devoirs avant le dîner. »', '[{"id":"a","text":"avions"},{"id":"b","text":"avons"},{"id":"c","text":"étions"},{"id":"d","text":"avaient"}]'::jsonb, 'a', '« Finir » prend avoir, à l''imparfait pour le plus-que-parfait : « nous avions fini ». « Avons » est le présent (donc passé composé) ; « étions » est le mauvais auxiliaire ; « avaient » va avec « ils », pas « nous ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6f9738a-4b2b-5759-9586-592b4f7908f5', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Complète : « Elle ___ venue à la fête, mais personne ne l''a vue. »', '[{"id":"a","text":"avait"},{"id":"b","text":"était"},{"id":"c","text":"a"},{"id":"d","text":"est"}]'::jsonb, 'b', '« Venir » se conjugue avec être. Au plus-que-parfait : « elle était venue », avec accord du participe au féminin. « Avait / a » sont le mauvais auxiliaire ; « est venue » serait du passé composé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ecc993b-4157-5d33-8c67-80ace6f51cf2', '5efe148d-7a31-5022-a12b-01d2e884157f', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Il avait vu ce film."},{"id":"b","text":"Elle était arrivée en retard."},{"id":"c","text":"Nous avions compris la leçon."},{"id":"d","text":"J''avais parti très tôt."}]'::jsonb, 'd', '« J''avais parti » est incorrect : « partir » se conjugue avec être, donc « j''étais parti(e) ». Les trois autres phrases sont correctes : « voir » et « comprendre » prennent l''auxiliaire avoir, et « arriver » prend être avec accord (« elle était arrivée »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5516257f-236e-5ce7-8c49-124697930e3d', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', '⭐⭐ Révision : le plus-que-parfait', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b5fa377-bc6c-5baa-9bd3-a579fc7678a7', '5516257f-236e-5ce7-8c49-124697930e3d', 'Complète : « Quand nous sommes entrés, le spectacle ___ déjà commencé. »', '[{"id":"a","text":"avait"},{"id":"b","text":"était"},{"id":"c","text":"a"},{"id":"d","text":"avaient"}]'::jsonb, 'a', '« Commencer » prend avoir. Au plus-que-parfait : « avait commencé », pour montrer que le spectacle a débuté avant notre entrée. « Était » est le mauvais auxiliaire ; « a » donnerait le passé composé ; « avaient » ne va pas avec « le spectacle » (singulier).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7541419d-1874-5564-b060-e977f6ca6a96', '5516257f-236e-5ce7-8c49-124697930e3d', 'Mets le verbe au plus-que-parfait : « Elles (se promener) ___ avant l''orage. »', '[{"id":"a","text":"avaient promené"},{"id":"b","text":"s''étaient promenées"},{"id":"c","text":"s''étaient promené"},{"id":"d","text":"étaient promenées"}]'::jsonb, 'b', '« Se promener » est pronominal, donc auxiliaire être + accord avec le sujet féminin pluriel : « elles s''étaient promenées ». « Avaient promené » oublie le pronom et l''auxiliaire être ; « s''étaient promené » oublie l''accord ; « étaient promenées » oublie le pronom réfléchi « se ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77f4fe8b-d83b-5eac-95d0-952ed0ed05f9', '5516257f-236e-5ce7-8c49-124697930e3d', 'Complète : « Tu n''___ pas encore fini quand le professeur a ramassé les copies. »', '[{"id":"a","text":"es"},{"id":"b","text":"étais"},{"id":"c","text":"as"},{"id":"d","text":"avais"}]'::jsonb, 'd', '« Finir » prend avoir, à l''imparfait pour le plus-que-parfait : « tu n''avais pas encore fini ». « Ne … pas encore » est un mot-signal typique du plus-que-parfait. « As » donnerait le passé composé ; « es / étais » sont le mauvais auxiliaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d743f728-eb5c-59d0-8203-e0b653db0b15', '5516257f-236e-5ce7-8c49-124697930e3d', 'Quelle phrase exprime correctement une action antérieure à une autre action passée ?', '[{"id":"a","text":"Je mange parce que j''avais faim."},{"id":"b","text":"Il était content parce qu''il avait réussi l''examen."},{"id":"c","text":"Elle part parce qu''elle est fatiguée."},{"id":"d","text":"Nous rions parce que c''est drôle."}]'::jsonb, 'b', 'Dans la phrase b, « avait réussi » (plus-que-parfait) est antérieur à « était content » (imparfait) : la réussite vient avant le contentement, et tout est au passé. Les autres mélangent un présent avec un passé, ce qui rompt la cohérence des temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17713a24-aa1f-505e-94ec-585a5bd7c180', '5516257f-236e-5ce7-8c49-124697930e3d', 'Complète : « Les invités ___ déjà repartis quand le gâteau est arrivé. »', '[{"id":"a","text":"avaient"},{"id":"b","text":"ont"},{"id":"c","text":"étaient"},{"id":"d","text":"sont"}]'::jsonb, 'c', '« Repartir » se conjugue avec être. Au plus-que-parfait : « étaient repartis », avec accord au masculin pluriel. « Sont repartis » serait du passé composé ; « avaient / ont » sont le mauvais auxiliaire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da402e23-727f-5ffb-823c-2838ad91e421', '5516257f-236e-5ce7-8c49-124697930e3d', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elle avait écrit une lettre."},{"id":"b","text":"Ils étaient descendus à la cave."},{"id":"c","text":"Nous nous étions levés tôt."},{"id":"d","text":"Elle était mangé un sandwich."}]'::jsonb, 'd', '« Elle était mangé » est incorrect : « manger » prend avoir, donc « elle avait mangé ». Les phrases a, b et c sont correctes : « écrire » prend avoir, tandis que « descendre » et le pronominal « se lever » prennent être avec accord.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : le plus-que-parfait', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04af33fc-b74f-5d47-b222-d4003e750f79', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Complète : « La pluie ___ tombée toute la nuit, donc la route était inondée. »', '[{"id":"a","text":"était"},{"id":"b","text":"avait"},{"id":"c","text":"a"},{"id":"d","text":"avaient"}]'::jsonb, 'a', '« Tomber » se conjugue avec être ; au plus-que-parfait : « était tombée », avec accord du participe au féminin singulier (la pluie). « Avait / a » sont le mauvais auxiliaire ; « avaient » ne va pas avec un sujet singulier.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed154f1d-9b4a-58d8-b221-80170c4d95c2', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Complète : « Il m''a raconté qu''il ___ ce livre l''année précédente. »', '[{"id":"a","text":"avait lu"},{"id":"b","text":"a lu"},{"id":"c","text":"lisait"},{"id":"d","text":"était lu"}]'::jsonb, 'a', 'Dans le discours indirect au passé (« il m''a raconté que… »), le passé composé devient plus-que-parfait : « avait lu ». « Lire » prend avoir, participe irrégulier « lu ». « A lu » (passé composé) ne respecte pas la concordance ; « lisait » est de l''imparfait ; « était lu » est un passif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2788d99d-86fb-559f-a817-d4efd1f335db', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Complète l''hypothèse : « Si tu ___ étudié, tu aurais réussi l''examen. »', '[{"id":"a","text":"as"},{"id":"b","text":"avais"},{"id":"c","text":"aurais"},{"id":"d","text":"étais"}]'::jsonb, 'b', 'Pour l''irréel du passé, on emploie « si + plus-que-parfait → conditionnel passé » : « si tu avais étudié, tu aurais réussi ». « As » donne le passé composé ; « aurais » est un conditionnel (jamais après « si ») ; « étais » est le mauvais auxiliaire pour « étudier ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c418c79d-ff55-596b-a5cb-672098093d97', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Mets au plus-que-parfait : « Elle (ouvrir) ___ la fenêtre avant de sortir. »', '[{"id":"a","text":"avait ouvré"},{"id":"b","text":"était ouverte"},{"id":"c","text":"avait ouvert"},{"id":"d","text":"s''était ouvert"}]'::jsonb, 'c', '« Ouvrir » prend avoir et a un participe passé irrégulier : « ouvert ». Donc « elle avait ouvert ». « Ouvré » n''existe pas ; « était ouverte » est un passif ; « s''était ouvert » serait un pronominal, ici inexact.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bbeb4d91-64ed-5c09-a843-f32fd312c2d7', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Quand il est arrivé, nous avions déjà commencé."},{"id":"b","text":"Elle a dit qu''elle avait perdu ses clés."},{"id":"c","text":"Si j''avais su, je serais resté."},{"id":"d","text":"Ils avaient venus en avance."}]'::jsonb, 'd', '« Ils avaient venus » est doublement faux : « venir » prend être (donc « étaient ») et le participe « venu » s''accorderait alors : « ils étaient venus ». Les phrases a, b et c respectent bien l''auxiliaire, la concordance et l''hypothèse.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dd73b6c-fee7-51b4-8caf-ec365580cd65', 'ee6ee5f6-f1b2-573a-adcf-edb2bb22663e', 'Complète : « Nous nous ___ rendu compte trop tard de notre erreur. »', '[{"id":"a","text":"avions"},{"id":"b","text":"avaient"},{"id":"c","text":"étions"},{"id":"d","text":"avons"}]'::jsonb, 'c', '« Se rendre compte » est pronominal, donc auxiliaire être : « nous nous étions rendu compte ». Le piège : « rendu » reste invariable ici car « compte » est le complément. « Avions / avons / avaient » sont impossibles : un pronominal ne prend jamais avoir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a0b69961-2052-581b-a4d8-f1d21d2c506e', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : le plus-que-parfait', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a30f9ff1-6ea0-5875-9d23-714070f4e322', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Il a dit qu''il avait tout compris."},{"id":"b","text":"Si elle était partie plus tôt, elle aurait eu son train."},{"id":"c","text":"Nous étions arrivés avant la pluie."},{"id":"d","text":"Elle s''était lavé les mains et était partie en courant rapidement vite."}]'::jsonb, 'd', 'La phrase d est incorrecte par redondance fautive : « en courant rapidement vite » accumule trois synonymes de manière. Les formes verbales y sont justes, mais le style est fautif. Les phrases a, b et c sont correctes (discours indirect, hypothèse, antériorité avec être).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8a947ca-737e-5a10-ae1e-820550fe359f', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Complète : « Elle pleurait : elle ___ sa montre préférée. »', '[{"id":"a","text":"avait perdu"},{"id":"b","text":"a perdu"},{"id":"c","text":"perdait"},{"id":"d","text":"était perdue"}]'::jsonb, 'a', 'La perte (plus-que-parfait, « avait perdu ») est antérieure aux pleurs (imparfait, « pleurait ») : c''est la cause passée d''un état passé. « Perdre » prend avoir. « A perdu » rompt la concordance ; « perdait » est imparfait ; « était perdue » est un passif au sens différent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a8d0e4f-a542-52a3-9eb6-47b378182988', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Discours indirect : « Marc a déclaré : “Je suis arrivé en retard.” » Transforme-le.', '[{"id":"a","text":"Marc a déclaré qu''il est arrivé en retard."},{"id":"b","text":"Marc a déclaré qu''il arrivait en retard."},{"id":"c","text":"Marc a déclaré qu''il était arrivé en retard."},{"id":"d","text":"Marc a déclaré qu''il avait arrivé en retard."}]'::jsonb, 'c', 'Après un verbe introducteur au passé, le passé composé devient plus-que-parfait. « Arriver » prend être : « il était arrivé ». La réponse d utilise le mauvais auxiliaire (avait) ; a garde le passé composé ; b transforme en imparfait, ce qui change le sens.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffcf297a-0c37-5fb7-857d-0e81a548ca15', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Complète : « Si nous ___ réservé plus tôt, nous aurions eu de meilleures places. »', '[{"id":"a","text":"aurions"},{"id":"b","text":"avions"},{"id":"c","text":"avons"},{"id":"d","text":"étions"}]'::jsonb, 'b', 'Structure de l''irréel du passé : « si + plus-que-parfait, conditionnel passé » → « si nous avions réservé, nous aurions eu ». « Aurions » est un conditionnel, interdit après « si » ; « avons » donne le passé composé ; « étions » est le mauvais auxiliaire pour « réserver ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18ae5fc0-49ad-5834-bce4-af04d90006fa', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Trouve la phrase parfaitement correcte.', '[{"id":"a","text":"Les fleurs qu''elle avait cueillies étaient fanées."},{"id":"b","text":"Les fleurs qu''elle avait cueilli étaient fanées."},{"id":"c","text":"Les fleurs qu''elle était cueillies étaient fanées."},{"id":"d","text":"Les fleurs qu''elle avais cueillies étaient fanées."}]'::jsonb, 'a', 'Avec avoir, le participe s''accorde avec le COD placé avant : « les fleurs qu''elle avait cueillies » (féminin pluriel). La phrase b oublie l''accord ; c utilise le mauvais auxiliaire (être) ; d écrit « avais » au lieu de « avait » pour « elle ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fc2e162-a0b9-593b-8a41-e6458d2beda4', 'a0b69961-2052-581b-a4d8-f1d21d2c506e', 'Complète : « Quand le médecin est entré, le patient s''___ déjà endormi. »', '[{"id":"a","text":"avait"},{"id":"b","text":"avais"},{"id":"c","text":"était"},{"id":"d","text":"est"}]'::jsonb, 'c', '« S''endormir » est pronominal, donc auxiliaire être à l''imparfait : « il s''était endormi », action antérieure à l''entrée du médecin. « Avait / avais » sont impossibles avec un pronominal ; « s''est endormi » serait du passé composé, qui n''exprime pas l''antériorité ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3a83d061-99c8-5137-85e1-6f24635ccf90', '464c5886-b18e-52e8-99d0-8d9b162cfcfd', 'francais-b1', '⭐⭐ Drill : le plus-que-parfait', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9bbba31-0057-5800-8256-b8c3c2dc83c4', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Complète : « Le boulanger ___ vendu tout son pain avant midi. »', '[{"id":"a","text":"avait"},{"id":"b","text":"était"},{"id":"c","text":"a"},{"id":"d","text":"avaient"}]'::jsonb, 'a', '« Vendre » prend avoir, à l''imparfait pour le plus-que-parfait : « avait vendu », action achevée avant midi. « Était » est le mauvais auxiliaire ; « a » donne le passé composé ; « avaient » ne va pas avec un sujet singulier.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('626cadc3-6432-5cfb-92c5-b2927fb1c199', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Quel est le participe passé du verbe « mourir » ?', '[{"id":"a","text":"mouru"},{"id":"b","text":"mort"},{"id":"c","text":"mouri"},{"id":"d","text":"mouré"}]'::jsonb, 'b', '« Mourir » est irrégulier : son participe passé est « mort » (il était mort). « Mouru / mouri / mouré » n''existent pas. « Mourir » se conjugue avec être : « elle était morte ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a655eb92-1ef4-5402-88b7-f7feffc20ba6', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Complète : « Vous ___ déjà rentrés quand l''orage a éclaté. »', '[{"id":"a","text":"aviez"},{"id":"b","text":"aviez été"},{"id":"c","text":"étiez"},{"id":"d","text":"avez"}]'::jsonb, 'c', '« Rentrer » se conjugue avec être ; au plus-que-parfait : « vous étiez rentrés », avec accord au pluriel. « Aviez / avez » sont le mauvais auxiliaire ; « aviez été » signifierait le verbe « être », pas « rentrer ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36f92d59-757c-5135-be57-aecd7c968c31', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Complète l''hypothèse : « Si elle ___ écouté, elle aurait évité cette erreur. »', '[{"id":"a","text":"a"},{"id":"b","text":"aurait"},{"id":"c","text":"était"},{"id":"d","text":"avait"}]'::jsonb, 'd', 'L''irréel du passé suit le schéma « si + plus-que-parfait → conditionnel passé » : « si elle avait écouté, elle aurait évité ». « A » donne le passé composé ; « aurait » est interdit après « si » ; « était » est le mauvais auxiliaire pour « écouter ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1daf221-53e4-5032-9555-fb89459d0f5c', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Discours indirect : « Il a expliqué : “J''ai oublié mon code.” » Choisis la bonne transformation.', '[{"id":"a","text":"Il a expliqué qu''il avait oublié son code."},{"id":"b","text":"Il a expliqué qu''il a oublié son code."},{"id":"c","text":"Il a expliqué qu''il oubliait son code."},{"id":"d","text":"Il a expliqué qu''il était oublié son code."}]'::jsonb, 'a', 'Avec un verbe introducteur au passé, le passé composé devient plus-que-parfait : « il avait oublié ». « Oublier » prend avoir. La réponse b garde le passé composé ; c passe à l''imparfait (sens différent) ; d utilise le mauvais auxiliaire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9718b6fc-02d0-5720-a397-26f22ad76a70', '3a83d061-99c8-5137-85e1-6f24635ccf90', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Nous avions pris le bus de huit heures."},{"id":"b","text":"Elle s''était souvenue de son rendez-vous."},{"id":"c","text":"Ils avaient restés à la maison."},{"id":"d","text":"J''étais descendu chercher le courrier."}]'::jsonb, 'c', '« Ils avaient restés » est faux : « rester » se conjugue avec être, donc « ils étaient restés ». Les phrases a, b et d sont correctes : « prendre » prend avoir, tandis que le pronominal « se souvenir » et « descendre » prennent être avec accord.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a4db0f97-dd15-5de5-8833-6b4d98bea3e0', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2decee7b-d1ba-511d-908d-2f5ed5dc38dc', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', 'Complète : « Tu vois Marie souvent ? — Oui, je ___ vois tous les jours. »', '[{"id":"a","text":"lui"},{"id":"b","text":"la"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« voir quelqu''un » est un complément direct (COD) : on remplace « Marie » par « la ». Je la vois. « lui » serait un COI (à qqn), « y » remplace à + chose ou un lieu, et « en » remplace de + chose.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60c5f2cd-8185-5d25-a18c-5633bc12414e', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', 'Complète : « Tu parles à tes parents ? — Oui, je ___ parle souvent. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'c', '« parler à quelqu''un » est un COI : avec « à + personne » au pluriel, on emploie « leur ». Je leur parle. « les » serait un COD, et « y » ne remplace jamais une personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('167150ce-0980-5630-8ff0-8f76528071e1', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', 'Complète : « Tu vas à la bibliothèque ? — Oui, j''___ vais maintenant. »', '[{"id":"a","text":"y"},{"id":"b","text":"en"},{"id":"c","text":"la"},{"id":"d","text":"lui"}]'::jsonb, 'a', '« y » remplace un complément de lieu introduit par « à » : à la bibliothèque → j''y vais. « en » remplace « de + chose », « la » est un COD et « lui » un COI.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8e3b01a-d64d-504d-8961-6216d806bac1', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', 'Complète : « Tu as combien de frères ? — J''___ ai deux. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'd', 'Avec une quantité, on emploie « en » et on garde le nombre : J''en ai deux. On ne dit pas « j''ai deux » seul. « les » serait un COD défini, « y » remplace à + chose et « leur » est un COI.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5b7f132-c107-5cff-aade-c84951f46e6d', 'a4db0f97-dd15-5de5-8833-6b4d98bea3e0', 'Où se place le pronom ? « Je vais ___ ce soir. » (appeler Paul → l'')', '[{"id":"a","text":"l''appeler"},{"id":"b","text":"appeler l''"},{"id":"c","text":"le appeler"},{"id":"d","text":"appeler-le"}]'::jsonb, 'a', 'Le pronom se place devant l''infinitif dont il dépend : Je vais l''appeler. On élide « le » en « l'' » devant la voyelle. « appeler l'' » et « appeler-le » placent mal le pronom, et « le appeler » oublie l''élision.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9343f86c-edbb-5b44-bb88-0cdea2add275', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', '⭐ Entraînement : les pronoms compléments', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('701df796-c3a9-52ee-a4c3-445eaedf4657', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu connais cette chanson ? — Oui, je ___ connais bien. »', '[{"id":"a","text":"lui"},{"id":"b","text":"la"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« connaître quelque chose » est un complément direct (COD) : « cette chanson » (féminin) se remplace par « la ». Je la connais. « lui » serait un COI, « y » remplace à + chose, et « en » remplace de + chose.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8926be0a-4973-5991-b4f7-4e3a6aad52fc', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu écris à ton ami ? — Oui, je ___ écris ce soir. »', '[{"id":"a","text":"l''"},{"id":"b","text":"y"},{"id":"c","text":"lui"},{"id":"d","text":"en"}]'::jsonb, 'c', '« écrire à quelqu''un » est un COI : « à ton ami » (singulier) devient « lui ». Je lui écris. « l'' » serait un COD, et « y » ne remplace jamais une personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eac5b691-f2c8-590f-83f5-b530ae78b446', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu penses à ton examen ? — Oui, j''___ pense tout le temps. »', '[{"id":"a","text":"y"},{"id":"b","text":"le"},{"id":"c","text":"lui"},{"id":"d","text":"en"}]'::jsonb, 'a', '« penser à quelque chose » : « à + chose » se remplace par « y ». J''y pense. « le » serait un COD, « lui » un COI (personne), et « en » remplace « de + chose ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8617b190-cba8-541a-a003-d39fc58e6075', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu veux du gâteau ? — Oui, j''___ veux un peu. »', '[{"id":"a","text":"le"},{"id":"b","text":"en"},{"id":"c","text":"y"},{"id":"d","text":"lui"}]'::jsonb, 'b', 'Avec un partitif (« du gâteau »), on emploie « en ». J''en veux un peu. « le » remplacerait un nom défini (le gâteau entier), « y » remplace à + chose, et « lui » est un COI.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2d47d2c-0901-56e2-add6-c4dc1a2063c8', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu invites tes cousins ? — Oui, je ___ invite à la fête. »', '[{"id":"a","text":"leur"},{"id":"b","text":"y"},{"id":"c","text":"en"},{"id":"d","text":"les"}]'::jsonb, 'd', '« inviter quelqu''un » est un COD (pas de préposition) : « tes cousins » (pluriel) devient « les ». Je les invite. « leur » serait un COI, ici incorrect car « inviter » se construit sans « à ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48679665-867c-59b7-926c-e7e2b8f1c88b', '9343f86c-edbb-5b44-bb88-0cdea2add275', 'Complète : « Tu habites à Tunis ? — Oui, j''___ habite depuis dix ans. »', '[{"id":"a","text":"en"},{"id":"b","text":"la"},{"id":"c","text":"y"},{"id":"d","text":"lui"}]'::jsonb, 'c', '« y » remplace un complément de lieu : à Tunis → j''y habite. « en » remplacerait « de + lieu » (la provenance), « la » est un COD et « lui » un COI.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('30c73f38-4ef5-5ef6-844c-1abcb8fe640d', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', '⭐⭐ Révision : les pronoms compléments', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ddcc4a5-46c4-5a51-8a07-dff55a5da368', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Complète : « J''ai aidé Sophie hier, et aujourd''hui je ___ aide encore. »', '[{"id":"a","text":"lui"},{"id":"b","text":"l''"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« aider quelqu''un » est un COD (sans préposition) : Sophie → « la », élidé en « l'' » devant la voyelle. Je l''aide. « lui » serait un COI, alors qu''« aider » se construit directement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6641dc2b-1239-50bc-ab3e-393e4191f298', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Complète : « Je téléphone à mes grands-parents chaque dimanche : je ___ téléphone le matin. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'c', '« téléphoner à quelqu''un » est un COI : « à mes grands-parents » (pluriel) devient « leur ». Je leur téléphone. « les » serait un COD, mais le verbe exige « à » : c''est donc un indirect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7c99804-1b23-5c03-89fa-39dc4afa4db6', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Complète : « Elle s''intéresse à la peinture : elle ___ consacre tout son temps libre. »', '[{"id":"a","text":"y"},{"id":"b","text":"la"},{"id":"c","text":"lui"},{"id":"d","text":"en"}]'::jsonb, 'a', '« consacrer du temps à quelque chose » : « à la peinture » est « à + chose », remplacé par « y ». Elle y consacre son temps. « lui » est réservé aux personnes, « la » est un COD et « en » remplace de + chose.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc3b0767-1d52-5a77-9d4b-bf6756184673', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Complète : « As-tu besoin de ces documents ? — Non, je n''___ ai pas besoin. »', '[{"id":"a","text":"y"},{"id":"b","text":"les"},{"id":"c","text":"en"},{"id":"d","text":"leur"}]'::jsonb, 'c', '« avoir besoin de quelque chose » : « de + chose » se remplace par « en ». Je n''en ai pas besoin. « y » remplace « à + chose », et « les » serait un COD, impossible ici car le verbe se construit avec « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8e2ac07-f39a-56f6-b1f5-1443fe992501', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Où placer le pronom ? « Ce livre est intéressant, tu devrais ___ . » (lire le livre → le)', '[{"id":"a","text":"le lire"},{"id":"b","text":"lire le"},{"id":"c","text":"lire-le"},{"id":"d","text":"lui lire"}]'::jsonb, 'a', 'Le pronom se place devant l''infinitif dont il dépend : tu devrais le lire. « lire le » et « lire-le » placent mal le pronom (le trait d''union est réservé à l''impératif affirmatif), et « lui » serait un COI.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('219591c5-55d1-573d-b77e-611e2da452d8', '30c73f38-4ef5-5ef6-844c-1abcb8fe640d', 'Complète : « Combien de stylos as-tu ? — J''___ ai cinq. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'd', 'Avec une quantité chiffrée, on emploie « en » et on conserve le nombre : J''en ai cinq. On ne dit pas « j''ai cinq » seul. « les » s''emploie avec un nom défini, sans nombre exprimé après.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('111fc043-27e7-5a8a-8676-4619a0c210d3', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : les pronoms compléments', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bce1c031-127c-5b48-b62a-f7cd9c7a809d', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Complète à l''impératif affirmatif : « Ces exercices sont importants : ___ ! » (faire les exercices)', '[{"id":"a","text":"les fais"},{"id":"b","text":"leur fais"},{"id":"c","text":"fais-les"},{"id":"d","text":"fais-leur"}]'::jsonb, 'c', 'À l''impératif affirmatif, le pronom passe APRÈS le verbe avec un trait d''union : Fais-les ! « les fais » garde l''ordre du présent (faux à l''impératif affirmatif), et « leur » serait un COI, alors que « faire qqch » exige un COD.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f58e3f25-ab65-5add-b699-c486633a73a1', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Complète : « J''ai rencontré ces actrices au festival. → Je ___ ai ___ . »', '[{"id":"a","text":"les … rencontrées"},{"id":"b","text":"leur … rencontré"},{"id":"c","text":"les … rencontré"},{"id":"d","text":"lui … rencontrées"}]'::jsonb, 'a', '« rencontrer quelqu''un » est un COD : « ces actrices » → « les ». Placé AVANT l''auxiliaire avoir, le COD impose l''accord : Je les ai rencontrées (féminin pluriel). « rencontré » (c) oublie l''accord, et « leur / lui » seraient des COI, faux ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('273d7cc9-c7f1-5458-896c-8cb1ffb3b999', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Je leur ai parlés hier soir."},{"id":"b","text":"Je leur ai parlé hier soir."},{"id":"c","text":"Je les ai parlé hier soir."},{"id":"d","text":"Je leur ai parlées hier soir."}]'::jsonb, 'b', '« parler à quelqu''un » est un COI (« leur »), et le participe ne s''accorde JAMAIS avec un COI : Je leur ai parlé (invariable). « parlés / parlées » accordent à tort, et « les » serait un COD, impossible avec « parler à ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('695e663c-745f-50e5-8fc0-db4d5eaed63a', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Complète avec deux pronoms : « Tu donnes ton adresse à Léa ? — Oui, je ___ donne. »', '[{"id":"a","text":"lui la"},{"id":"b","text":"la lui"},{"id":"c","text":"lui l''"},{"id":"d","text":"y la"}]'::jsonb, 'b', '« donner qqch (COD) à qqn (COI) » : l''adresse → « la », à Léa → « lui ». L''ordre fixe place le/la/les AVANT lui/leur : Je la lui donne. « lui la » inverse l''ordre, et « y » ne remplace pas une personne.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53da2871-ad2a-5ef6-9c68-67542a733e65', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Les fleurs que j''ai achetées sont belles."},{"id":"b","text":"Je l''ai vue partir ce matin."},{"id":"c","text":"Nous leur avons écrit une lettre."},{"id":"d","text":"Cette histoire, je la ai oubliée."}]'::jsonb, 'd', 'L''erreur est (d) : devant la voyelle, « la » doit s''élider → « je l''ai oubliée ». Les autres sont correctes : « que … achetées » (COD avant → accord), « l''ai vue » (COD féminin avant → accord), « leur avons écrit » (COI → pas d''accord).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ad153db-6252-55fe-b4fc-310d36a7d969', '111fc043-27e7-5a8a-8676-4619a0c210d3', 'Complète : « Tu as parlé de ton voyage à tes amis ? — Oui, je ___ ai parlé. »', '[{"id":"a","text":"leur en"},{"id":"b","text":"en leur"},{"id":"c","text":"y leur"},{"id":"d","text":"les en"}]'::jsonb, 'a', '« parler de qqch (en) à qqn (leur) » : de ton voyage → « en », à tes amis → « leur ». L''ordre fixe place lui/leur AVANT en : Je leur en ai parlé. « en leur » inverse l''ordre, et « les » serait un COD, faux avec « parler à ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e46d0999-5f79-58d7-92cb-7c297d76c022', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : les pronoms compléments', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0beb83df-6337-5132-8db5-47b1f8593015', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Complète avec deux pronoms : « Il a offert ces fleurs à sa mère. → Il ___ a offertes. »', '[{"id":"a","text":"lui les"},{"id":"b","text":"les lui"},{"id":"c","text":"les y"},{"id":"d","text":"leur les"}]'::jsonb, 'b', '« offrir qqch (COD) à qqn (COI) » : les fleurs → « les », à sa mère → « lui ». Ordre fixe : le/la/les avant lui/leur → Il les lui a offertes (accord du COD « les » avant avoir). « lui les » inverse, « leur » est pluriel et « y » exclut les personnes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19ca275f-2036-5d0d-a2c2-1a0856e125a2', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Donne l''ordre correct : « Tu me prêtes ton vélo ? — Oui, je ___ prête. »', '[{"id":"a","text":"le te"},{"id":"b","text":"te le"},{"id":"c","text":"toi le"},{"id":"d","text":"te lui"}]'::jsonb, 'b', 'Ordre fixe : me/te/se/nous/vous avant le/la/les → Je te le prête (« te » = à toi, « le » = le vélo). « le te » inverse l''ordre, « toi » s''emploie seulement à l''impératif affirmatif, et « lui » désignerait une 3e personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31950748-3ed8-56aa-a049-4c693eb12e73', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Impératif affirmatif avec deux pronoms : « Tu veux le livre ? ___ ! » (donner le livre à moi)', '[{"id":"a","text":"Donne-moi-le"},{"id":"b","text":"Donne-me-le"},{"id":"c","text":"Donne-le-moi"},{"id":"d","text":"Me le donne"}]'::jsonb, 'c', 'À l''impératif affirmatif, l''ordre s''inverse : le COD vient d''abord, puis le COI, et « me » devient « moi » → Donne-le-moi ! « Donne-me-le » garde « me » (faux), « Donne-moi-le » met le COI avant le COD, et « Me le donne » garde l''ordre du présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3a16e64-1a66-543d-a6d2-068de9185c4c', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Trouve la phrase INCORRECTE (accord du participe).', '[{"id":"a","text":"La voiture, je l''ai lavée ce matin."},{"id":"b","text":"Ces livres, je les ai déjà lus."},{"id":"c","text":"Je lui ai téléphoné deux fois."},{"id":"d","text":"Mes clés, je les ai perdu."}]'::jsonb, 'd', 'L''erreur est (d) : « les » (= les clés) est un COD féminin pluriel placé AVANT avoir, donc accord → « perdues ». Les autres sont correctes : « lavée » (COD fém. avant), « lus » (COD masc. plur. avant), « téléphoné » (COI, invariable).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8cb74d1-f53b-526f-865e-273fcbe143c6', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Complète : « Tu te souviens de cette histoire ? — Oui, je m''___ souviens très bien. »', '[{"id":"a","text":"y"},{"id":"b","text":"la"},{"id":"c","text":"en"},{"id":"d","text":"lui"}]'::jsonb, 'c', '« se souvenir DE quelque chose » : « de + chose » se remplace par « en ». Je m''en souviens. Le piège : « y » remplacerait « à + chose », mais ce verbe se construit avec « de », donc c''est « en ». « la » et « lui » sont exclus.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('feb84e30-669d-564a-96ac-d435b2e6c48b', 'e46d0999-5f79-58d7-92cb-7c297d76c022', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Ne le lui dis pas, c''est un secret."},{"id":"b","text":"Ne lui le dis pas, c''est un secret."},{"id":"c","text":"Dis-le-lui pas, c''est un secret."},{"id":"d","text":"Ne le dis lui pas, c''est un secret."}]'::jsonb, 'a', 'À l''impératif NÉGATIF, on revient à l''ordre normal devant le verbe, avec l''ordre fixe le/la/les avant lui/leur : Ne le lui dis pas. « ne lui le » inverse l''ordre, (c) oublie « ne … pas » et mélange les formes, et (d) sépare mal les pronoms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4c0f68b-8f71-5255-a238-870ec2aefd67', '271ec82b-1ed3-563b-84d2-c32b1ac245b0', 'francais-b1', '⭐⭐ Drill : les pronoms compléments', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56da2b9e-e6fb-5028-9d6c-4195da6f26d6', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Complète : « Tu regardes la télévision ? — Oui, je ___ regarde le soir. »', '[{"id":"a","text":"lui"},{"id":"b","text":"la"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« regarder quelque chose » est un COD : « la télévision » (féminin) → « la ». Je la regarde. « lui » serait un COI, « y » remplace à + chose et « en » remplace de + chose.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21eb079a-45a9-53e3-9d0a-1364a01716fe', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Complète : « Tu réponds à ton professeur ? — Oui, je ___ réponds poliment. »', '[{"id":"a","text":"le"},{"id":"b","text":"y"},{"id":"c","text":"lui"},{"id":"d","text":"en"}]'::jsonb, 'c', '« répondre à quelqu''un » est un COI : « à ton professeur » → « lui ». Je lui réponds. « le » serait un COD, et « y » ne remplace jamais une personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5599eaa3-c6d6-566d-b9b2-a1893b338c12', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Complète : « Tu joues au tennis ? — Oui, j''___ joue chaque semaine. »', '[{"id":"a","text":"y"},{"id":"b","text":"le"},{"id":"c","text":"en"},{"id":"d","text":"lui"}]'::jsonb, 'a', '« jouer à quelque chose » : « au tennis » = « à + chose » → « y ». J''y joue. « en » remplacerait « de + chose » (jouer d''un instrument), « le » est un COD et « lui » un COI.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8a33bee-3bb6-5f20-b406-f5ddb1ebd079', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Complète : « Tu manges des légumes ? — Oui, j''___ mange beaucoup. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'd', 'Avec un partitif ou une quantité (« des légumes », « beaucoup »), on emploie « en ». J''en mange beaucoup. « les » s''emploierait avec un nom défini précis, sans idée de quantité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c6130eb-3f0f-50c4-9eef-5466756ea42b', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Complète : « Cette lettre, je ___ ai écrite hier. »', '[{"id":"a","text":"lui"},{"id":"b","text":"l''"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« cette lettre » est un COD féminin placé avant le verbe : on emploie « la », élidé en « l'' » devant la voyelle, d''où l''accord « écrite ». Je l''ai écrite. « lui » serait un COI (pas d''accord), « y » et « en » sont exclus ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c9035e9-5ae1-5cf0-b0d2-f0616ffac199', 'c4c0f68b-8f71-5255-a238-870ec2aefd67', 'Impératif affirmatif : « Cette idée est bonne : pense ___ ! » (penser à cette idée)', '[{"id":"a","text":"y"},{"id":"b","text":"lui"},{"id":"c","text":"la"},{"id":"d","text":"en"}]'::jsonb, 'a', '« penser à quelque chose » → « y ». À l''impératif affirmatif, le pronom suit le verbe avec un trait d''union : penses-y ! (on ajoute un -s euphonique devant « y »). « lui » exclut les choses, « la » est un COD et « en » remplace « de + chose ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8711d6cf-f13a-5681-b9ea-57677c9b3ed5', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('098a0efc-79f2-512d-a048-860c85fda97b', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'Complète : « L''homme ___ parle est mon voisin. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'a', '« qui » est sujet de la relative : c''est l''homme qui fait l''action de parler, et un verbe le suit directement (qui parle). « que » serait un COD (suivi d''un sujet), « où » marque le lieu, et « dont » remplace un complément en « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('004a8254-8420-526c-bb6d-237275cc6ef9', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'Complète : « Le livre ___ je lis est passionnant. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'b', '« que » est COD : je lis le livre, donc un sujet (je) suit le pronom. « qui » serait suivi d''un verbe (le livre qui plaît), « où » marque le lieu ou le temps, et « dont » s''emploie avec « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6e4b0d7-66cd-52c8-98a0-6f806b7224f4', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'Complète : « La ville ___ j''habite est au bord de la mer. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'c', '« où » marque le lieu (= dans laquelle) : la ville où j''habite. « que » serait un COD (la ville que je visite), « qui » un sujet, et « dont » remplacerait un complément en « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('405fad40-3cd4-541d-b7e2-2fab37c7ce1d', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'Complète : « C''est le film ___ je parle depuis hier. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'd', 'On dit parler DE quelque chose, donc « dont » remplace ce complément en « de » : le film dont je parle. « que » conviendrait à un verbe direct (le film que je regarde), « qui » serait un sujet, et « où » marque le lieu ou le temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('013fb210-49a1-566f-ba39-f497d18194a7', '8711d6cf-f13a-5681-b9ea-57677c9b3ed5', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"L''ami que j''invite arrive ce soir."},{"id":"b","text":"L''ami que vient ce soir est sympathique."},{"id":"c","text":"Le jour où il est né, il neigeait."},{"id":"d","text":"Le projet dont je suis fier est terminé."}]'::jsonb, 'b', 'La phrase incorrecte est la deuxième : un verbe (vient) suit le pronom, il faut donc « qui » (sujet), pas « que » : l''ami qui vient. Les autres sont correctes : « que » COD, « où » temps et « dont » avec l''adjectif fier de.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a11a4d54-92d9-5989-bbe0-a8393b85149b', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', '⭐ Entraînement : les pronoms relatifs', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28c5f75e-9466-587b-b6b1-bef2b0588364', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « Je cherche le stylo ___ écrit en rouge. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'a', '« qui » est sujet : c''est le stylo qui fait l''action d''écrire, et un verbe (écrit) suit le pronom. « que » serait un COD (suivi d''un sujet), « où » marque le lieu, et « dont » s''emploie avec « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84d70d04-dba9-5e67-9e8d-c26058b2939c', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « Le gâteau ___ tu as préparé est délicieux. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'b', '« que » est COD : tu as préparé le gâteau, un sujet (tu) suit donc le pronom. « qui » serait suivi d''un verbe sans sujet exprimé (le gâteau qui plaît), « où » marque le lieu ou le temps, et « dont » s''emploie avec « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fa9ce47-4526-5d12-a435-f580681c1b68', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « Voici le café ___ nous nous retrouvons le samedi. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'c', '« où » marque le lieu (= dans lequel) : le café où nous nous retrouvons. « que » serait un COD (le café que j''aime), « qui » un sujet, et « dont » remplacerait un complément en « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8ef617b-0a6e-5a31-8945-e5f23ac8939d', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « C''est un sujet ___ tout le monde parle en ce moment. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'd', 'On dit parler DE quelque chose, donc « dont » reprend ce complément en « de » : un sujet dont tout le monde parle. « qui » serait un sujet (suivi d''un verbe), « que » un COD direct, et « où » marque le lieu ou le temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c493414-bc73-5a47-b3aa-3a9a015f0cb0', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « Le chien ___ aboie dans la cour est à mon voisin. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'b', '« qui » est sujet : c''est le chien qui aboie, et un verbe (aboie) suit le pronom. « que » serait un COD (suivi d''un sujet), « dont » s''emploie avec « de », et « où » marque le lieu ou le temps.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c6ea2ca-a736-57e3-9ecd-bdf27d80e57d', 'a11a4d54-92d9-5989-bbe0-a8393b85149b', 'Complète : « Je n''oublierai jamais le jour ___ nous avons gagné. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'c', 'Pour marquer le temps, on emploie « où » (= au moment où) : le jour où nous avons gagné. On ne dit pas « le jour que » dans ce sens. « qui » serait un sujet et « dont » un complément en « de ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e9a9f982-93c0-515a-95da-88afe89de37e', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', '⭐⭐ Révision : les pronoms relatifs', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46167fc7-a5a3-5c99-9e7a-76ef821c4ea8', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Complète : « L''actrice ___ tout le monde admire viendra ce soir. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'b', '« que » est COD : tout le monde admire l''actrice, un sujet (tout le monde) suit donc le pronom. « qui » serait suivi d''un verbe sans sujet (l''actrice qui joue), « où » marque le lieu, et « dont » s''emploie avec « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f390c8ea-73b4-5b57-b0f4-7bed87121f91', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Complète : « C''est une amie ___ je connais bien la famille. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'c', 'On dit la famille DE quelqu''un, donc « dont » remplace ce complément du nom : une amie dont je connais la famille (la famille d''elle). « que » serait le COD du verbe (que je connais), mais ici le « de » porte sur le nom famille ; « qui » est sujet et « où » marque le lieu.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b29b1d7-50bf-512d-8e3e-976cc9f6e280', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Complète : « Le village ___ se trouve dans la montagne est isolé. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'a', '« qui » est sujet : c''est le village qui se trouve dans la montagne, un verbe (se trouve) suit le pronom. Attention au piège : ici « où » serait tentant à cause de « montagne », mais le pronom est sujet du verbe se trouver, donc « qui ». « que » serait un COD.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cf25378-63e8-54ce-b7e6-8271cf0d3f9a', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Complète : « La région ___ je suis allé l''été dernier était magnifique. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'c', '« où » marque le lieu : la région où je suis allé. On ne dit pas « la région que je suis allé » car aller n''a pas de COD. « qui » serait un sujet, et « dont » remplacerait un complément en « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e987c5b5-79b3-58f7-a84b-82c4ccd7d93f', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Complète : « Voilà le résultat ___ je suis très fier. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'd', 'On dit être fier DE quelque chose, donc « dont » reprend ce complément de l''adjectif : le résultat dont je suis fier. « que » serait un COD direct (le résultat que j''obtiens), « qui » un sujet, et « où » marque le lieu ou le temps.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eea5a563-2cc4-5640-bd71-5fe114e6af00', 'e9a9f982-93c0-515a-95da-88afe89de37e', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"C''est la maison où mes grands-parents ont vécu."},{"id":"b","text":"Le sport que je préfère est la natation."},{"id":"c","text":"Le livre dont j''ai besoin est épuisé."},{"id":"d","text":"La fille que arrive est ma cousine."}]'::jsonb, 'd', 'La quatrième phrase est incorrecte : un verbe (arrive) suit le pronom, il faut donc « qui » (sujet) : la fille qui arrive. Les autres sont correctes : « où » pour le lieu, « que » COD, et « dont » avec avoir besoin de.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5515752e-9404-5afe-b7a4-21492a49b934', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : les pronoms relatifs', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43c32e7a-4280-5175-9756-d96675f1ed2d', '5515752e-9404-5afe-b7a4-21492a49b934', 'Complète : « Les chaussures que j''ai ___ hier sont déjà sales. »', '[{"id":"a","text":"achetées"},{"id":"b","text":"acheté"},{"id":"c","text":"achetés"},{"id":"d","text":"achetée"}]'::jsonb, 'a', 'Avec l''auxiliaire avoir, le participe s''accorde avec le COD placé avant : « que » reprend « les chaussures » (féminin pluriel), donc « achetées ». ✓ « acheté » oublie l''accord, « achetés » met un masculin, et « achetée » oublie le pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f367d303-b49f-5faf-a816-113c89e02850', '5515752e-9404-5afe-b7a4-21492a49b934', 'Complète : « Je pense à un projet ___ je rêve depuis des années. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'd', 'On dit rêver DE quelque chose, donc « dont » reprend ce complément en « de » : un projet dont je rêve. Le piège courant est « que » (COD direct), mais rêver se construit avec « de », pas directement ; « qui » est sujet et « où » marque le lieu ou le temps.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1da924ac-0d6e-5713-aefc-b0afcf82a907', '5515752e-9404-5afe-b7a4-21492a49b934', 'Complète : « C''est l''écrivain ___ on a publié le dernier roman. »', '[{"id":"a","text":"que"},{"id":"b","text":"dont"},{"id":"c","text":"qui"},{"id":"d","text":"où"}]'::jsonb, 'b', 'On a publié le roman DE l''écrivain : « dont » remplace ce complément du nom (le roman de lui). Le piège est « que », mais le COD de publier est « le dernier roman », pas l''écrivain ; le lien « de » impose « dont ». « qui » serait sujet et « où » marque le lieu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03a47dfa-9701-5a93-ac9d-6bc5916c6d24', '5515752e-9404-5afe-b7a4-21492a49b934', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"La personne à qui je pense habite loin."},{"id":"b","text":"Le moment où tout a changé reste flou."},{"id":"c","text":"L''outil dont je travaille est cassé."},{"id":"d","text":"Les amis que j''ai invités sont arrivés."}]'::jsonb, 'c', 'La troisième phrase est incorrecte : on travaille AVEC un outil, pas « de » un outil, donc « dont » est faux ; il faut « avec lequel » (l''outil avec lequel je travaille). « dont » ne sert qu''avec « de ». Les autres sont correctes : à qui (penser à), où (temps) et que avec accord (invités).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c481ad56-babe-52ed-8a85-369989a3d5b3', '5515752e-9404-5afe-b7a4-21492a49b934', 'Complète : « Les lettres que tu m''as ___ m''ont beaucoup touché. »', '[{"id":"a","text":"écrit"},{"id":"b","text":"écrites"},{"id":"c","text":"écrits"},{"id":"d","text":"écrite"}]'::jsonb, 'b', 'Avec avoir, le participe s''accorde avec le COD placé avant : « que » reprend « les lettres » (féminin pluriel), donc « écrites ». ✓ Le piège courant est « écrit » (sans accord) ; « écrits » est masculin et « écrite » oublie le pluriel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59711c8e-2e5a-5e06-a2f4-371fcfb30a66', '5515752e-9404-5afe-b7a4-21492a49b934', 'Complète : « Le château ___ les tours dominent la vallée date du Moyen Âge. »', '[{"id":"a","text":"où"},{"id":"b","text":"que"},{"id":"c","text":"qui"},{"id":"d","text":"dont"}]'::jsonb, 'd', 'Ce sont les tours DU château : « dont » remplace ce complément du nom (les tours de lui). Le piège est « où » à cause du lieu, mais le pronom relie « les tours » à « château » par « de », donc « dont ». « que » serait un COD et « qui » un sujet.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('af9ef9d7-bf20-55e9-88ac-19822af7e19c', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : les pronoms relatifs', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a85a9e7e-bc4c-5b51-a8bb-795c297f9518', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Complète : « Dis-moi ___ se passe, je vois bien que tu es inquiet. »', '[{"id":"a","text":"ce qui"},{"id":"b","text":"ce que"},{"id":"c","text":"ce dont"},{"id":"d","text":"qui"}]'::jsonb, 'a', 'Sans antécédent précis, on emploie « ce » + relatif. Ici le pronom est sujet de « se passe », donc « ce qui » : dis-moi ce qui se passe. « ce que » serait COD (ce que tu veux), « ce dont » reprendrait un « de », et « qui » seul exige un antécédent nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f439a3cc-32e1-5774-8455-67312b1d81c8', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Complète : « Achète tout ___ tu as besoin pour la recette. »', '[{"id":"a","text":"ce que"},{"id":"b","text":"ce qui"},{"id":"c","text":"que"},{"id":"d","text":"ce dont"}]'::jsonb, 'd', 'On dit avoir besoin DE quelque chose, donc « ce dont » reprend ce « de » : tout ce dont tu as besoin. Le piège courant est « ce que » (COD direct), mais avoir besoin se construit avec « de » ; « ce qui » serait sujet, et « que » seul exige un antécédent nom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd0149bb-51fa-5114-9c16-526a6b28e6e7', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Complète : « Les efforts que cette équipe a ___ ont enfin payé. »', '[{"id":"a","text":"fait"},{"id":"b","text":"faits"},{"id":"c","text":"faite"},{"id":"d","text":"faites"}]'::jsonb, 'b', 'Avec avoir, le participe s''accorde avec le COD placé avant : « que » reprend « les efforts » (masculin pluriel), donc « faits ». ✓ Le piège est « fait » (sans accord, comme si le COD suivait) ; « faite » et « faites » sont féminins, ce qui est faux ici.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9220cabd-860a-5fe0-b831-2db449f66703', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"C''est le collègue sur qui je compte le plus."},{"id":"b","text":"Voilà la raison pour laquelle j''ai refusé."},{"id":"c","text":"Le pays dont je voyage est lointain."},{"id":"d","text":"La fleur que j''ai cueillie a fané."}]'::jsonb, 'c', 'La troisième phrase est fausse : on voyage DANS un pays, pas « de » un pays, donc « dont » est incorrect ; il faut « où » (le pays où je voyage). « dont » ne sert qu''avec « de ». Les autres sont correctes : sur qui (compter sur), pour laquelle, et que avec accord (cueillie).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1710e06b-d7bb-5fcd-80bd-61208c742f4a', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Complète : « Je ne comprends pas ___ tu veux dire par cette remarque. »', '[{"id":"a","text":"ce qui"},{"id":"b","text":"ce que"},{"id":"c","text":"ce dont"},{"id":"d","text":"que"}]'::jsonb, 'b', 'Le pronom est COD de « dire » (tu veux dire quelque chose), sans antécédent nom, donc « ce que » : ce que tu veux dire. « ce qui » serait sujet (ce qui compte), « ce dont » reprendrait un « de », et « que » seul exige un antécédent nom.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50235b05-2d0f-58ff-b16a-40a474c6f355', 'af9ef9d7-bf20-55e9-88ac-19822af7e19c', 'Complète : « C''est une décision ___ les conséquences ___ on ne mesure pas encore seront lourdes. »', '[{"id":"a","text":"dont … que"},{"id":"b","text":"que … qui"},{"id":"c","text":"qui … dont"},{"id":"d","text":"où … que"}]'::jsonb, 'a', 'Les conséquences DE la décision → « dont » (complément du nom) ; puis on mesure les conséquences (COD, suivi du sujet « on ») → « que ». D''où « dont … que ». Les autres paires mélangent les fonctions : « que … qui » et « qui … dont » inversent COD et sujet, et « où » ne convient pas à un complément en « de ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8055bcb1-110f-5d8f-9da7-f2c17ad59a81', '688cff7c-01d9-5a0c-b42e-dba63fd124e3', 'francais-b1', '⭐⭐ Drill : les pronoms relatifs', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('475c5383-aa76-56ef-8efa-f23d31ceabfb', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Complète : « La musicienne ___ joue ce soir est très célèbre. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'b', '« qui » est sujet : c''est la musicienne qui joue, un verbe (joue) suit le pronom. « que » serait un COD (suivi d''un sujet), « dont » s''emploie avec « de », et « où » marque le lieu ou le temps.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('430e0edd-ae62-583d-884f-3c049f997cba', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Complète : « C''est l''hôtel ___ nous avons passé nos vacances. »', '[{"id":"a","text":"où"},{"id":"b","text":"qui"},{"id":"c","text":"que"},{"id":"d","text":"dont"}]'::jsonb, 'a', '« où » marque le lieu : l''hôtel où nous avons passé nos vacances. « que » serait un COD (l''hôtel que je recommande), « qui » un sujet, et « dont » remplacerait un complément en « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afc1e3a2-bb8b-5906-8c68-dee6afb74e1f', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Complète : « Le mot ___ je ne connais pas le sens revient souvent. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'c', 'On dit le sens DU mot, donc « dont » remplace ce complément du nom (le sens de lui) : le mot dont je ne connais pas le sens. « que » serait le COD direct du verbe, « qui » un sujet, et « où » marque le lieu ou le temps.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e584c82-1582-57ad-98fc-8b80c800aacb', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Complète : « Les photos que nous avons ___ sont superbes. »', '[{"id":"a","text":"pris"},{"id":"b","text":"prise"},{"id":"c","text":"prit"},{"id":"d","text":"prises"}]'::jsonb, 'd', 'Avec avoir, le participe s''accorde avec le COD placé avant : « que » reprend « les photos » (féminin pluriel), donc « prises ». ✓ « pris » oublie l''accord, « prise » oublie le pluriel, et « prit » est une forme du passé simple, fausse ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27f32323-db53-54ac-88af-01f168c7fc78', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Complète : « Tu te souviens de l''année ___ on a déménagé ? »', '[{"id":"a","text":"où"},{"id":"b","text":"qui"},{"id":"c","text":"que"},{"id":"d","text":"dont"}]'::jsonb, 'a', 'Pour marquer le temps, on emploie « où » (= pendant laquelle) : l''année où on a déménagé. On ne dit pas « l''année que » dans ce sens temporel. « qui » serait un sujet et « dont » un complément en « de ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f491ab1f-7cb9-539f-ad2b-b7ecef34d672', '8055bcb1-110f-5d8f-9da7-f2c17ad59a81', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"L''élève qui a répondu a gagné un point."},{"id":"b","text":"Le quartier dont j''habite est animé."},{"id":"c","text":"La tarte que ma mère a faite était délicieuse."},{"id":"d","text":"Le jour où je l''ai rencontré, il pleuvait."}]'::jsonb, 'b', 'La deuxième phrase est fausse : on habite DANS un quartier, pas « de » un quartier, donc « dont » est incorrect ; il faut « où » (le quartier où j''habite). « dont » ne sert qu''avec « de ». Les autres sont correctes : qui sujet, que avec accord (faite) et où pour le temps.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3db222fa-72e6-570e-b833-d9114cee5c56', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e2db2ab-cd3f-5bed-8e0e-3ae4986fde01', '3db222fa-72e6-570e-b833-d9114cee5c56', 'Complète : « Il faut que tu ___ tes devoirs ce soir. » (faire)', '[{"id":"a","text":"fais"},{"id":"b","text":"fasses"},{"id":"c","text":"feras"},{"id":"d","text":"faire"}]'::jsonb, 'b', 'Après « il faut que » (obligation), on emploie le subjonctif. Le verbe faire a un radical irrégulier : que tu fasses. « fais » est l''indicatif présent, « feras » le futur, et « faire » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cd9358e-7c13-537c-853e-8e405cc9e3a7', '3db222fa-72e6-570e-b833-d9114cee5c56', 'Quel est le subjonctif présent du verbe parler avec « que je » ?', '[{"id":"a","text":"que je parle"},{"id":"b","text":"que je parlais"},{"id":"c","text":"que je parlerai"},{"id":"d","text":"que je parler"}]'::jsonb, 'a', 'On part du radical de « ils parlent » (parl-) et on ajoute -e : que je parle. « parlais » est l''imparfait, « parlerai » le futur, et « parler » l''infinitif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8cbf181-2f84-52e1-903d-b7b78ddca284', '3db222fa-72e6-570e-b833-d9114cee5c56', 'Choisis le bon mode : « Je pense qu''il ___ raison. » (avoir)', '[{"id":"a","text":"ait"},{"id":"b","text":"a"},{"id":"c","text":"aurait"},{"id":"d","text":"ayant"}]'::jsonb, 'b', '« Je pense que » (opinion affirmée) est suivi de l''indicatif : il a raison. Le subjonctif « ait » ne s''emploierait qu''à la forme négative (je ne pense pas qu''il ait raison).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58b0005c-7bf4-54ec-a742-ad6809a601cc', '3db222fa-72e6-570e-b833-d9114cee5c56', 'Complète : « Je suis content que vous ___ là. » (être)', '[{"id":"a","text":"êtes"},{"id":"b","text":"serez"},{"id":"c","text":"soyez"},{"id":"d","text":"soyiez"}]'::jsonb, 'c', '« Je suis content que » exprime un sentiment et appelle le subjonctif. Le verbe être donne « que vous soyez ». « êtes » est l''indicatif, « serez » le futur, et « soyiez » est une forme inexistante.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cdadd45-bdd3-5cae-942e-6511c1334dc3', '3db222fa-72e6-570e-b833-d9114cee5c56', 'Complète : « Il travaille bien que ___ très fatigué. » (il est)', '[{"id":"a","text":"il est"},{"id":"b","text":"il sera"},{"id":"c","text":"il soit"},{"id":"d","text":"il était"}]'::jsonb, 'c', 'La conjonction « bien que » impose toujours le subjonctif : bien qu''il soit fatigué. « il est » et « il était » sont à l''indicatif, et « il sera » au futur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1a6ffc86-dac4-5262-bd45-19376f88ae28', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', '⭐ Entraînement : le subjonctif présent', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd7ad022-6c84-5dde-a64e-97ac51e8e01e', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Complète : « Il faut que je ___ le bus à huit heures. » (prendre)', '[{"id":"a","text":"prends"},{"id":"b","text":"prenne"},{"id":"c","text":"prendrai"},{"id":"d","text":"prendre"}]'::jsonb, 'b', 'Après « il faut que » (obligation) on emploie le subjonctif. Radical de « ils prennent » + -e : que je prenne. « prends » est l''indicatif présent, « prendrai » le futur, « prendre » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd0e1900-6fda-5a60-90e0-96cecf6371b7', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Complète : « Je veux que tu ___ avec nous au cinéma. » (venir)', '[{"id":"a","text":"viennes"},{"id":"b","text":"viens"},{"id":"c","text":"viendras"},{"id":"d","text":"venir"}]'::jsonb, 'a', '« Je veux que » exprime la volonté et appelle le subjonctif. Radical de « ils viennent » + -es : que tu viennes. « viens » est l''indicatif, « viendras » le futur, « venir » l''infinitif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df743959-8198-593f-be8c-6d84b96143ed', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Quel est le subjonctif présent de finir avec « qu''il » ?', '[{"id":"a","text":"qu''il finit"},{"id":"b","text":"qu''il finira"},{"id":"c","text":"qu''il finisse"},{"id":"d","text":"qu''il finissait"}]'::jsonb, 'c', 'On part du radical de « ils finissent » (finiss-) et on ajoute -e : qu''il finisse. « finit » est l''indicatif présent, « finira » le futur, « finissait » l''imparfait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4515be63-551b-5fdc-bdcf-ec88ba5f09bc', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Complète : « Il est nécessaire que nous ___ tôt demain. » (partir)', '[{"id":"a","text":"partons"},{"id":"b","text":"partirons"},{"id":"c","text":"partons tôt"},{"id":"d","text":"partions"}]'::jsonb, 'd', '« Il est nécessaire que » impose le subjonctif. Radical de « ils partent » + -ions : que nous partions. « partons » est l''indicatif présent, « partirons » le futur ; la forme subjonctive « nous » ressemble à l''imparfait, c''est normal.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('466096c9-4678-5d5e-a3d7-4f76aa24e579', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Complète : « Il faut que vous ___ patients. » (être)', '[{"id":"a","text":"êtes"},{"id":"b","text":"soyez"},{"id":"c","text":"serez"},{"id":"d","text":"soyiez"}]'::jsonb, 'b', '« Il faut que » + subjonctif. Le verbe être est irrégulier : que vous soyez. « êtes » est l''indicatif présent, « serez » le futur, et « soyiez » n''existe pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d03fcce5-d888-5250-80e5-290fc41d6c63', '1a6ffc86-dac4-5262-bd45-19376f88ae28', 'Complète : « Je voudrais que tu ___ la vérité. » (dire)', '[{"id":"a","text":"dis"},{"id":"b","text":"diras"},{"id":"c","text":"dises"},{"id":"d","text":"disais"}]'::jsonb, 'c', '« Je voudrais que » exprime la volonté et appelle le subjonctif. Radical de « ils disent » + -es : que tu dises. « dis » est l''indicatif, « diras » le futur, « disais » l''imparfait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8fc36a0c-c388-548d-900a-17dac34c4170', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', '⭐⭐ Révision : le subjonctif présent', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df2841b4-ecaa-5bf5-89c3-0d85e7a405d6', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Complète : « Je doute qu''il ___ venir ce soir. » (pouvoir)', '[{"id":"a","text":"peut"},{"id":"b","text":"pourra"},{"id":"c","text":"puisse"},{"id":"d","text":"pouvoir"}]'::jsonb, 'c', '« Je doute que » exprime le doute et appelle le subjonctif. Le verbe pouvoir est irrégulier : qu''il puisse. « peut » est l''indicatif, « pourra » le futur, « pouvoir » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f118db83-abfd-58a6-ad25-c1190004c1d8', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Choisis le bon mode : « J''espère que tu ___ bientôt. » (guérir)', '[{"id":"a","text":"guérisses"},{"id":"b","text":"guériras"},{"id":"c","text":"guérisse"},{"id":"d","text":"guérir"}]'::jsonb, 'b', 'Attention : « espérer que » se construit avec l''indicatif (souvent le futur), pas le subjonctif : j''espère que tu guériras. Les formes « guérisses / guérisse » seraient du subjonctif, mais il n''a pas sa place après espérer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc37ceb8-6afa-5259-aa9f-d0ccf83971a6', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Complète : « Je suis triste que vous ___ déjà. » (partir)', '[{"id":"a","text":"partiez"},{"id":"b","text":"partez"},{"id":"c","text":"partirez"},{"id":"d","text":"partez déjà"}]'::jsonb, 'a', '« Je suis triste que » exprime un sentiment et appelle le subjonctif. Radical de « ils partent » + -iez : que vous partiez. « partez » est l''indicatif, « partirez » le futur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e591e379-9fcb-58ea-b6e4-4b8f2d938bea', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Complète : « Bien qu''il ___ jeune, il est très sérieux. » (être)', '[{"id":"a","text":"est"},{"id":"b","text":"soit"},{"id":"c","text":"sera"},{"id":"d","text":"était"}]'::jsonb, 'b', 'La conjonction « bien que » impose toujours le subjonctif : bien qu''il soit jeune. « est » et « était » sont à l''indicatif, « sera » au futur. Le verbe être donne « soit ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ba012ca-5a44-5196-a63d-632ec8daa7a1', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Complète : « Il se peut que nous ___ en retard. » (avoir)', '[{"id":"a","text":"ayons du retard"},{"id":"b","text":"avons"},{"id":"c","text":"aurons"},{"id":"d","text":"ayons"}]'::jsonb, 'd', '« Il se peut que » exprime la possibilité et appelle le subjonctif. Le verbe avoir est irrégulier : que nous ayons. « avons » est l''indicatif, « aurons » le futur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('146b12da-bb6c-5bea-b9e7-419d1d09ae62', '8fc36a0c-c388-548d-900a-17dac34c4170', 'Complète : « Je t''écris pour que tu ___ la nouvelle. » (savoir)', '[{"id":"a","text":"sais"},{"id":"b","text":"sauras"},{"id":"c","text":"saches"},{"id":"d","text":"savais"}]'::jsonb, 'c', 'La conjonction « pour que » impose le subjonctif. Le verbe savoir est irrégulier : que tu saches. « sais » est l''indicatif, « sauras » le futur, « savais » l''imparfait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ac46bed4-5196-53f1-beec-35f40378ce05', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : le subjonctif présent', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2bea37f-bad7-5c15-9e1f-93abcda70d19', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Complète : « Je veux que tu ___ ton travail avant midi. » (finir)', '[{"id":"a","text":"finisses"},{"id":"b","text":"finis"},{"id":"c","text":"finiras"},{"id":"d","text":"finir"}]'::jsonb, 'a', '« Je veux que » exprime la volonté → subjonctif. Radical de « ils finissent » + -es : que tu finisses. « finis » est l''indicatif présent, « finiras » le futur, « finir » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3ab2bd3-009f-50dc-b276-99bd2f3aff24', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Il faut que je vais à l''école."},{"id":"b","text":"Il faut que j''aille à l''école."},{"id":"c","text":"Il faut que j''irai à l''école."},{"id":"d","text":"Il faut que j''allais à l''école."}]'::jsonb, 'b', '« Il faut que » impose le subjonctif et le verbe aller est irrégulier : que j''aille. La (a) garde l''indicatif « vais », la (c) le futur « irai », la (d) l''imparfait « allais » — aucun n''est le subjonctif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aed780b5-3b00-5a12-9741-1716647602ac', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Complète : « Attends ici jusqu''à ce que je ___. » (revenir)', '[{"id":"a","text":"reviens"},{"id":"b","text":"reviendrai"},{"id":"c","text":"revienne"},{"id":"d","text":"revenir"}]'::jsonb, 'c', 'La conjonction « jusqu''à ce que » impose le subjonctif. Radical de « ils reviennent » + -e : que je revienne. « reviens » est l''indicatif, « reviendrai » le futur, « revenir » l''infinitif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1747c6c-8010-57c3-b938-667a1d8c1bb6', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Choisis le bon mode : « Je ne pense pas qu''il ___ raison. » (avoir)', '[{"id":"a","text":"a"},{"id":"b","text":"aura"},{"id":"c","text":"avait"},{"id":"d","text":"ait"}]'::jsonb, 'd', 'À la forme négative, « je ne pense pas que » exprime le doute et appelle le subjonctif : qu''il ait raison. Le piège : à l''affirmatif « je pense que » prend l''indicatif (il a raison), mais ici la négation impose le subjonctif. « aura » est le futur, « avait » l''imparfait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76710c06-ee2a-59e6-98b7-3cd2757465a4', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Complète : « Il est certain qu''il ___ le concours. » (réussir)', '[{"id":"a","text":"réussisse"},{"id":"b","text":"réussira"},{"id":"c","text":"réussisses"},{"id":"d","text":"réussir"}]'::jsonb, 'b', 'Le piège courant : « il est certain que » exprime une certitude → indicatif, pas subjonctif. On dit : il est certain qu''il réussira. La forme « réussisse » serait du subjonctif (qui s''emploierait après « il est possible que »), mais la certitude appelle l''indicatif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01b09cac-1878-52c0-bad4-3032ef420683', 'ac46bed4-5196-53f1-beec-35f40378ce05', 'Complète : « J''ai peur que nous ___ le train. » (manquer)', '[{"id":"a","text":"manquons"},{"id":"b","text":"manquerons"},{"id":"c","text":"manquions"},{"id":"d","text":"manquons le train"}]'::jsonb, 'c', '« Avoir peur que » exprime une émotion et appelle le subjonctif. Radical de « ils manquent » + -ions : que nous manquions. « manquons » est l''indicatif présent, « manquerons » le futur. La forme subjonctive « nous » ressemble à l''imparfait, c''est normal.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9d589881-be62-5aae-ab7c-5766bbf8605d', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : le subjonctif présent', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff0ab38e-519c-5487-8cf6-9cfc7af83dfd', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Complète : « Je suis surpris que tu ___ déjà tout compris. » (avoir)', '[{"id":"a","text":"as"},{"id":"b","text":"auras"},{"id":"c","text":"aies"},{"id":"d","text":"avais"}]'::jsonb, 'c', '« Je suis surpris que » exprime un sentiment → subjonctif. Le verbe avoir est irrégulier : que tu aies. « as » est l''indicatif, « auras » le futur, « avais » l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88879c4a-a4ca-5308-8804-3c357389e435', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je pense qu''il viendra demain."},{"id":"b","text":"Il faut qu''il vienne demain."},{"id":"c","text":"Je ne crois pas qu''il vienne demain."},{"id":"d","text":"J''espère qu''il vienne demain."}]'::jsonb, 'd', '« Espérer que » se construit avec l''indicatif : on dit « j''espère qu''il viendra », pas « qu''il vienne ». Les autres sont correctes : « je pense que » + indicatif (a), « il faut que » + subjonctif (b), « je ne crois pas que » + subjonctif (c).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30c40bc1-9b91-5a16-85ac-cddbb17d1550', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Choisis le bon mode : « Il est probable qu''il ___ malade ; on verra demain. » (être)', '[{"id":"a","text":"soit"},{"id":"b","text":"est"},{"id":"c","text":"sera"},{"id":"d","text":"était"}]'::jsonb, 'b', 'Le piège courant : « il est probable que » exprime une quasi-certitude → indicatif (il est malade), alors que « il est possible que » appellerait le subjonctif. « soit » serait le subjonctif, « sera » le futur, « était » l''imparfait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3aa5d594-5b76-5b28-bb44-3599e1c78867', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Complète : « Nous resterons à condition que vous ___ d''accord. » (être)', '[{"id":"a","text":"êtes"},{"id":"b","text":"serez"},{"id":"c","text":"soyez"},{"id":"d","text":"étiez"}]'::jsonb, 'c', 'La conjonction « à condition que » impose le subjonctif. Le verbe être donne « que vous soyez ». « êtes » est l''indicatif, « serez » le futur, « étiez » l''imparfait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f11dc3d-034e-53c5-b71a-336f2ec90fbc', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Complète : « Pars avant qu''il ne ___ trop tard. » (faire)', '[{"id":"a","text":"fait"},{"id":"b","text":"fera"},{"id":"c","text":"faisait"},{"id":"d","text":"fasse"}]'::jsonb, 'd', 'La conjonction « avant que » impose le subjonctif (avec un « ne » explétif facultatif) : avant qu''il ne fasse trop tard. Le verbe faire est irrégulier : qu''il fasse. « fait » est l''indicatif, « fera » le futur, « faisait » l''imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84062536-3032-5fda-8cd8-048cf8a4cf49', '9d589881-be62-5aae-ab7c-5766bbf8605d', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Je veux que tu sois à l''heure et que tu fasses un effort."},{"id":"b","text":"Je veux que tu es à l''heure et que tu fais un effort."},{"id":"c","text":"Je veux que tu seras à l''heure et que tu feras un effort."},{"id":"d","text":"Je veux que tu soies à l''heure et que tu fais un effort."}]'::jsonb, 'a', '« Je veux que » impose le subjonctif aux deux verbes : que tu sois (être) et que tu fasses (faire). La (b) garde l''indicatif (es, fais), la (c) le futur (seras, feras), et la (d) écrit « soies », forme inexistante (c''est « sois »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('801ead08-9a8d-5fc5-bd16-b45b64acde9e', '3ec0c5f3-c3ca-5a52-8f9b-41afc1beb491', 'francais-b1', '⭐⭐ Drill : le subjonctif présent', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebc7b672-cbea-5184-8b45-292e030c7032', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Complète : « Il faut que tu ___ tes clés. » (chercher)', '[{"id":"a","text":"cherches"},{"id":"b","text":"cherche"},{"id":"c","text":"chercheras"},{"id":"d","text":"chercher"}]'::jsonb, 'a', '« Il faut que » impose le subjonctif. Radical de « ils cherchent » + -es : que tu cherches. « cherche » est la forme de je/il, « chercheras » le futur, « chercher » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd5a9a0c-1db3-51a2-a8f6-2e666574f349', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Choisis le bon mode : « Je crois qu''elle ___ raison. » (avoir)', '[{"id":"a","text":"ait"},{"id":"b","text":"a"},{"id":"c","text":"aie"},{"id":"d","text":"ayant"}]'::jsonb, 'b', '« Je crois que » (opinion affirmée) se construit avec l''indicatif : elle a raison. Le subjonctif « ait/aie » ne s''emploierait qu''à la forme négative (je ne crois pas qu''elle ait raison).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('690330b3-3705-5244-93b5-7a7f0ded499d', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Complète : « Il est possible qu''ils ___ en vacances. » (aller)', '[{"id":"a","text":"aillent"},{"id":"b","text":"vont"},{"id":"c","text":"iront"},{"id":"d","text":"allaient"}]'::jsonb, 'a', '« Il est possible que » exprime la possibilité → subjonctif. Le verbe aller est irrégulier : qu''ils aillent. « vont » est l''indicatif, « iront » le futur, « allaient » l''imparfait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('214fc19d-4228-5ec1-b4bf-456689d67fb0', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Complète : « Je suis content que nous ___ ensemble. » (travailler)', '[{"id":"a","text":"travaillons"},{"id":"b","text":"travaillerons"},{"id":"c","text":"travaillions"},{"id":"d","text":"travaillions ensemble"}]'::jsonb, 'c', '« Je suis content que » exprime un sentiment → subjonctif. Radical de « ils travaillent » + -ions : que nous travaillions. « travaillons » est l''indicatif, « travaillerons » le futur ; la forme subjonctive « nous » ressemble à l''imparfait, c''est normal.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80b802ea-2476-561b-8158-eca6061a0b1c', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Complète : « Il exige que je ___ tout de suite. » (répondre)', '[{"id":"a","text":"réponds"},{"id":"b","text":"répondrai"},{"id":"c","text":"répondais"},{"id":"d","text":"réponde"}]'::jsonb, 'd', '« Exiger que » exprime l''obligation → subjonctif. Radical de « ils répondent » + -e : que je réponde. « réponds » est l''indicatif, « répondrai » le futur, « répondais » l''imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('847dacd3-df00-5769-b062-42b335c01cfd', '801ead08-9a8d-5fc5-bd16-b45b64acde9e', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Bien qu''il pleut, nous sortons."},{"id":"b","text":"Bien qu''il pleuve, nous sortons."},{"id":"c","text":"Bien qu''il pleuvra, nous sortons."},{"id":"d","text":"Bien qu''il pleuvait, nous sortons."}]'::jsonb, 'b', 'La conjonction « bien que » impose le subjonctif : bien qu''il pleuve. La (a) garde l''indicatif « pleut », la (c) le futur « pleuvra », la (d) l''imparfait « pleuvait ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b08bfea7-bea0-561f-ae1e-461b34b91c89', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ba33431-01ad-590a-8c75-2539bdaaf05c', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', 'Complète au conditionnel présent : « J''___ visiter le Japon un jour. »', '[{"id":"a","text":"aimerais"},{"id":"b","text":"aimerai"},{"id":"c","text":"aime"},{"id":"d","text":"aimais"}]'::jsonb, 'a', 'Le conditionnel présent se forme avec le radical du futur (aimer-) + les terminaisons de l''imparfait (-ais) : j''aimerais. « aimerai » est le futur simple, « aime » le présent et « aimais » l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e98d6365-86b6-57b6-a034-e97a93dc43b2', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', 'Quelle phrase exprime une demande polie ?', '[{"id":"a","text":"Je veux un café."},{"id":"b","text":"Je voudrais un café, s''il vous plaît."},{"id":"c","text":"Je voulais un café."},{"id":"d","text":"Je voudrai un café."}]'::jsonb, 'b', 'Le conditionnel « je voudrais » adoucit la demande : c''est la formule de politesse. « je veux » (présent) est trop direct, « je voulais » est l''imparfait, et « je voudrai » est le futur, pas le conditionnel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bf4c61f-1f30-5e77-bbf2-992d22c050f1', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', 'Complète l''hypothèse réelle : « Si tu ___ demain, nous irons au cinéma. »', '[{"id":"a","text":"viendrais"},{"id":"b","text":"viendras"},{"id":"c","text":"viens"},{"id":"d","text":"venais"}]'::jsonb, 'c', 'Dans l''hypothèse potentielle, on a si + présent → futur : Si tu viens, nous irons. Après « si » on ne met jamais de futur (« viendras ») ni de conditionnel (« viendrais ») ; « venais » (imparfait) introduirait l''irréel du présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dd8bc36-300d-5597-acad-a6aebd60f2f6', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', 'Complète l''hypothèse imaginaire : « Si j''avais le temps, je ___ ce livre. »', '[{"id":"a","text":"lirai"},{"id":"b","text":"lis"},{"id":"c","text":"lisais"},{"id":"d","text":"lirais"}]'::jsonb, 'd', 'C''est l''irréel du présent : si + imparfait (avais) → conditionnel présent dans la conséquence, donc « je lirais ». « lirai » est le futur, « lis » le présent et « lisais » l''imparfait, qui ne conviennent pas ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27a490bf-c41f-5d28-bf79-60e31e3cb4f4', 'b08bfea7-bea0-561f-ae1e-461b34b91c89', 'Quelle phrase est correcte ?', '[{"id":"a","text":"Si je serais riche, je voyagerais."},{"id":"b","text":"Si j''étais riche, je voyagerais."},{"id":"c","text":"Si j''aurais le temps, je viendrais."},{"id":"d","text":"Si je voudrais, je partirais."}]'::jsonb, 'b', 'Règle d''or : après « si » d''hypothèse, jamais de conditionnel. L''irréel du présent est si + imparfait → conditionnel : Si j''étais riche, je voyagerais. Les options (a), (c) et (d) commettent la faute classique « si je serais / si j''aurais / si je voudrais ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3f747788-2709-5df2-82cb-6cff48b58b4f', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', '⭐ Entraînement : le conditionnel et l''hypothèse', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ed6eb00-98be-5ff7-a7bf-51be10932691', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Complète au conditionnel présent : « Nous ___ partir plus tôt. »', '[{"id":"a","text":"aimerons"},{"id":"b","text":"aimons"},{"id":"c","text":"aimerions"},{"id":"d","text":"aimions"}]'::jsonb, 'c', 'Conditionnel présent = radical du futur (aimer-) + terminaison de l''imparfait (-ions) : nous aimerions. « aimerons » est le futur, « aimons » le présent et « aimions » l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d615262-c844-5752-a11b-402198f5ec6c', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Complète au conditionnel présent : « Tu ___ te reposer un peu. »', '[{"id":"a","text":"devrais"},{"id":"b","text":"devras"},{"id":"c","text":"dois"},{"id":"d","text":"devais"}]'::jsonb, 'a', 'Le radical du futur de devoir est devr- ; avec la terminaison -ais on obtient « tu devrais », qui exprime le conseil. « devras » est le futur, « dois » le présent et « devais » l''imparfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c2bbd9a-11bf-5e52-b01d-7f13dacb53f3', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Quelle phrase exprime un conseil au conditionnel ?', '[{"id":"a","text":"Il faut partir maintenant."},{"id":"b","text":"Il faudrait partir maintenant."},{"id":"c","text":"Il faudra partir maintenant."},{"id":"d","text":"Il fallait partir maintenant."}]'::jsonb, 'b', '« Il faudrait » est le conditionnel de falloir et adoucit l''ordre en conseil. « Il faut » est le présent (obligation directe), « il faudra » le futur et « il fallait » l''imparfait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcc8d426-b7eb-5b84-9b9e-33ce10ebc15e', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Complète l''hypothèse : « Si tu ___ faim, prends un fruit. »', '[{"id":"a","text":"auras"},{"id":"b","text":"aurais"},{"id":"c","text":"aurai"},{"id":"d","text":"as"}]'::jsonb, 'd', 'Après « si » d''hypothèse, jamais de futur ni de conditionnel : on emploie le présent, « si tu as faim ». « auras » est le futur, « aurais » le conditionnel et « aurai » la 1re personne du futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('137fcd26-eb9a-53c0-a723-1a07773fe6e4', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Complète au conditionnel présent : « ___-vous m''aider, s''il vous plaît ? »', '[{"id":"a","text":"Pourriez"},{"id":"b","text":"Pourrez"},{"id":"c","text":"Pouvez"},{"id":"d","text":"Pouviez"}]'::jsonb, 'a', 'Le radical du futur de pouvoir est pourr- ; avec -iez on a « pourriez-vous », formule de politesse. « pourrez » est le futur, « pouvez » le présent et « pouviez » l''imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53338972-5071-5cfc-8650-15cb8109305a', '3f747788-2709-5df2-82cb-6cff48b58b4f', 'Complète l''irréel du présent : « Si j''étais toi, je ___ à la maison. »', '[{"id":"a","text":"resterai"},{"id":"b","text":"reste"},{"id":"c","text":"resterais"},{"id":"d","text":"restais"}]'::jsonb, 'c', 'Irréel du présent : si + imparfait (étais) → conditionnel présent, donc « je resterais ». « resterai » est le futur, « reste » le présent et « restais » l''imparfait, qui ne suivent pas l''imparfait après « si ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4c3d13ac-8254-5f48-9343-82b414812363', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', '⭐⭐ Révision : le conditionnel et l''hypothèse', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f3e858b-6cb4-5ca1-a9aa-44af5493ee1b', '4c3d13ac-8254-5f48-9343-82b414812363', 'Complète au conditionnel présent : « À ta place, je ___ plus prudent. »', '[{"id":"a","text":"serai"},{"id":"b","text":"serais"},{"id":"c","text":"suis"},{"id":"d","text":"étais"}]'::jsonb, 'b', 'Le radical du futur d''être est ser- ; avec -ais on obtient « je serais » (conseil). « serai » est le futur, « suis » le présent et « étais » l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b556aa78-c227-58bc-80a5-98a7c7c9fb41', '4c3d13ac-8254-5f48-9343-82b414812363', 'Identifie l''emploi : « Selon la radio, le ministre serait à l''étranger. »', '[{"id":"a","text":"Un conseil"},{"id":"b","text":"Une demande polie"},{"id":"c","text":"Un souhait"},{"id":"d","text":"Une information non confirmée"}]'::jsonb, 'd', 'Le conditionnel sert ici à donner une information non vérifiée (« selon la radio »). Ce n''est ni un conseil, ni une demande polie, ni un souhait : c''est le conditionnel d''information journalistique.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9fdb666-4dc2-56f3-9c5d-906996974fcb', '4c3d13ac-8254-5f48-9343-82b414812363', 'Complète l''hypothèse réelle : « Si vous ___ ce soir, on commandera une pizza. »', '[{"id":"a","text":"venez"},{"id":"b","text":"viendrez"},{"id":"c","text":"viendriez"},{"id":"d","text":"veniez"}]'::jsonb, 'a', 'Hypothèse potentielle : si + présent (« si vous venez ») → futur dans la conséquence (« on commandera »). Après « si » on ne met ni futur (« viendrez ») ni conditionnel (« viendriez ») ; « veniez » serait l''irréel du présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6eedf60-11bb-5c5a-aee8-38276fb1d3bb', '4c3d13ac-8254-5f48-9343-82b414812363', 'Complète l''irréel du présent : « Si nous ___ plus d''argent, nous voyagerions. »', '[{"id":"a","text":"aurons"},{"id":"b","text":"aurions"},{"id":"c","text":"avions"},{"id":"d","text":"avons"}]'::jsonb, 'c', 'La conséquence « voyagerions » est au conditionnel : c''est l''irréel du présent, donc si + imparfait → « si nous avions ». « aurons » est le futur, « aurions » le conditionnel (interdit après si) et « avons » le présent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aae91432-cbc7-514a-839b-250ba689e772', '4c3d13ac-8254-5f48-9343-82b414812363', 'Quelle phrase est correcte ?', '[{"id":"a","text":"Si tu auras le temps, appelle-moi."},{"id":"b","text":"Si tu as le temps, appelle-moi."},{"id":"c","text":"Si tu aurais le temps, appelle-moi."},{"id":"d","text":"Si tu aies le temps, appelle-moi."}]'::jsonb, 'b', 'Après « si » d''hypothèse, on emploie le présent : « Si tu as le temps ». Le futur (« auras ») et le conditionnel (« aurais ») sont interdits après « si », et le subjonctif (« aies ») ne s''emploie pas après « si » de condition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2a20886-3613-576a-aebb-f85fa86364ef', '4c3d13ac-8254-5f48-9343-82b414812363', 'Complète au conditionnel : « J''___ bien un verre d''eau. »', '[{"id":"a","text":"prendrai"},{"id":"b","text":"prends"},{"id":"c","text":"prenais"},{"id":"d","text":"prendrais"}]'::jsonb, 'd', 'Pour adoucir une demande, on emploie le conditionnel : « je prendrais bien ». Le radical du futur prendr- + -ais donne prendrais. « prendrai » est le futur, « prends » le présent et « prenais » l''imparfait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('797e2b68-f231-5e2a-8446-4cbe49d5e418', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : le conditionnel et l''hypothèse', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69814c04-d27d-569d-a639-096f2de1c2a6', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Complète l''irréel du présent : « Si elle ___ une voiture, elle irait travailler plus vite. »', '[{"id":"a","text":"aura"},{"id":"b","text":"aurait"},{"id":"c","text":"avait"},{"id":"d","text":"a"}]'::jsonb, 'c', 'La conséquence « elle irait » est au conditionnel : c''est l''irréel du présent, donc si + imparfait → « si elle avait ». « aura » (futur), « aurait » (conditionnel) sont interdits après « si » ; « a » (présent) servirait au potentiel, pas avec « irait ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4770a433-3886-5703-81b6-7e9f3e1fee2c', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Identifie le système hypothétique : « Si j''avais su, je ne serais pas venu. »', '[{"id":"a","text":"Potentiel : si + présent → futur"},{"id":"b","text":"Irréel du passé : si + plus-que-parfait → conditionnel passé"},{"id":"c","text":"Irréel du présent : si + imparfait → conditionnel présent"},{"id":"d","text":"Une phrase incorrecte"}]'::jsonb, 'b', '« avais su » est un plus-que-parfait et « serais venu » un conditionnel passé : c''est l''irréel du passé, qui exprime un regret. Le potentiel (a) emploie le présent et le futur, l''irréel du présent (c) l''imparfait et le conditionnel présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c141ecdb-d6b1-56a1-a947-01d33c149278', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Complète au conditionnel présent : « Avec un peu de chance, nous ___ gagner ce match. »', '[{"id":"a","text":"pourrions"},{"id":"b","text":"pourrons"},{"id":"c","text":"pouvons"},{"id":"d","text":"pouvions"}]'::jsonb, 'a', 'Le conditionnel exprime ici la possibilité : radical du futur de pouvoir (pourr-) + -ions = « nous pourrions ». « pourrons » est le futur, « pouvons » le présent et « pouvions » l''imparfait, qui n''expriment pas cette nuance hypothétique.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8279d782-3b81-56ab-a862-c164ea60b4b1', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Si je serais libre, je viendrais te voir."},{"id":"b","text":"Si j''étais libre, je viendrais te voir."},{"id":"c","text":"Si je suis libre, je viendrai te voir."},{"id":"d","text":"Si j''avais été libre, je serais venu te voir."}]'::jsonb, 'a', 'La faute est en (a) : « si je serais » est interdit car le conditionnel ne s''emploie jamais après « si ». Il faut « si j''étais » (b, irréel du présent). (c) est un potentiel correct (si + présent → futur) et (d) un irréel du passé correct (si + plus-que-parfait → conditionnel passé).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ed891de-a390-57ab-be2c-4ad971addacb', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Complète l''irréel du passé : « Si tu m''avais prévenu, je ___ t''aider. »', '[{"id":"a","text":"pourrai"},{"id":"b","text":"pouvais"},{"id":"c","text":"peux"},{"id":"d","text":"aurais pu"}]'::jsonb, 'd', 'Irréel du passé : si + plus-que-parfait (« avais prévenu ») → conditionnel passé dans la conséquence, donc « j''aurais pu ». « pourrai » (futur), « pouvais » (imparfait) et « peux » (présent) ne respectent pas la concordance du système irréel du passé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('040163b8-e671-5ff2-9a54-ed277b54e2de', '797e2b68-f231-5e2a-8446-4cbe49d5e418', 'Complète le potentiel : « S''il fait beau demain, nous ___ à la plage. »', '[{"id":"a","text":"irions"},{"id":"b","text":"allions"},{"id":"c","text":"irons"},{"id":"d","text":"allons"}]'::jsonb, 'c', 'Hypothèse potentielle : si + présent (« s''il fait ») → futur dans la conséquence, donc « nous irons » (radical du futur d''aller = ir-). « irions » est le conditionnel (réservé à l''irréel), « allions » l''imparfait et « allons » le présent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5630104e-a03d-54f3-b6de-ac9786643ad1', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : le conditionnel et l''hypothèse', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5148db3d-1964-574d-8f0e-ca26944c988f', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Lis : « Karim n''a pas révisé. Il dit : “Si j''avais révisé, j''aurais réussi l''examen.” » Quelle affirmation est VRAIE ?', '[{"id":"a","text":"Karim a réussi l''examen."},{"id":"b","text":"Karim regrette de ne pas avoir révisé."},{"id":"c","text":"Karim est sûr de réussir le prochain examen."},{"id":"d","text":"Karim révise en ce moment."}]'::jsonb, 'b', 'L''irréel du passé (si + plus-que-parfait → conditionnel passé) exprime un regret sur une action non réalisée : Karim n''a pas révisé et le regrette. Il n''a donc pas réussi (a faux), la phrase ne parle ni d''un futur examen (c) ni d''une révision en cours (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b29f0ad-fca6-59ec-9fe5-46969496a368', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Lis : « Le journaliste annonce : “D''après nos sources, l''usine fermerait l''an prochain.” » Que signifie le conditionnel ici ?', '[{"id":"a","text":"Une demande polie de l''usine."},{"id":"b","text":"Un conseil donné à l''usine."},{"id":"c","text":"Un souhait du journaliste."},{"id":"d","text":"Une information non confirmée."}]'::jsonb, 'd', 'Le conditionnel journalistique (« fermerait », « d''après nos sources ») marque une information non vérifiée, présentée avec prudence. Ce n''est ni une demande polie, ni un conseil, ni un souhait : c''est le conditionnel d''information.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffa07eb9-980a-5760-a970-cb14bfd33258', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Si j''avais le temps, je lirais davantage."},{"id":"b","text":"Si tu viens, on ira au cinéma."},{"id":"c","text":"Si elle avait travaillé, elle aurait réussi."},{"id":"d","text":"Si j''aurais de l''argent, je t''aiderais."}]'::jsonb, 'd', 'La faute est en (d) : « si j''aurais » est interdit, car le conditionnel ne suit jamais « si ». Il faut « si j''avais de l''argent ». (a) est un irréel du présent, (b) un potentiel et (c) un irréel du passé, tous corrects.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a8c8e73-de1a-5a29-b2d9-f9e1e36033f7', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Complète l''irréel du passé : « Si nous étions partis plus tôt, nous ___ l''avion. »', '[{"id":"a","text":"n''aurions pas raté"},{"id":"b","text":"ne raterions pas"},{"id":"c","text":"ne raterons pas"},{"id":"d","text":"ne ratons pas"}]'::jsonb, 'a', '« étions partis » est un plus-que-parfait : l''irréel du passé exige le conditionnel passé, donc « nous n''aurions pas raté ». « ne raterions pas » est un conditionnel présent (irréel du présent), « ne raterons pas » un futur et « ne ratons pas » un présent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0e1481d-8da4-55f2-bb90-b4c9de48b412', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Une amie dit : « Je suis épuisée par mon travail. » Quel conseil est correctement formulé au conditionnel ?', '[{"id":"a","text":"Tu devras prendre des vacances."},{"id":"b","text":"Tu dois prendre des vacances."},{"id":"c","text":"Tu devrais prendre des vacances."},{"id":"d","text":"Tu devrais prendras des vacances."}]'::jsonb, 'c', 'Le conseil poli se formule au conditionnel présent : « tu devrais » (radical devr- + -ais). « tu devras » est le futur, « tu dois » le présent (obligation directe), et « tu devrais prendras » accumule deux verbes conjugués, ce qui est agrammatical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af8627d6-5f1f-5b9c-8fb9-7c0645d491e4', '5630104e-a03d-54f3-b6de-ac9786643ad1', 'Complète correctement ce système mixte : « Si tu avais écouté mes conseils, tu ___ aujourd''hui plus tranquille. »', '[{"id":"a","text":"seras"},{"id":"b","text":"serais"},{"id":"c","text":"aurais été"},{"id":"d","text":"étais"}]'::jsonb, 'b', 'Le « si » est au plus-que-parfait (cause passée), mais « aujourd''hui » situe la conséquence dans le présent : on emploie donc le conditionnel présent « tu serais ». « seras » (futur) et « étais » (imparfait) sont interdits, et « aurais été » conviendrait pour une conséquence passée, pas présente.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4dbafb9d-875b-5260-8d09-6dafa33885ce', '8547410e-ae1b-5ede-adc0-96aa33fbb64d', 'francais-b1', '⭐⭐ Drill : le conditionnel et l''hypothèse', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2c05598-67a4-5d70-b96f-a2800ec72ace', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Complète au conditionnel présent : « Je ___ savoir l''heure du train, s''il vous plaît. »', '[{"id":"a","text":"voudrais"},{"id":"b","text":"voudrai"},{"id":"c","text":"veux"},{"id":"d","text":"voulais"}]'::jsonb, 'a', 'La demande polie se fait au conditionnel : radical du futur de vouloir (voudr-) + -ais = « je voudrais ». « voudrai » est le futur, « veux » le présent (trop direct) et « voulais » l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f10aaa96-9d8b-516e-a769-3e461391c0df', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Complète le potentiel : « Si tu finis tes devoirs, tu ___ regarder un film. »', '[{"id":"a","text":"pourrais"},{"id":"b","text":"pouvais"},{"id":"c","text":"pourras"},{"id":"d","text":"peux"}]'::jsonb, 'c', 'Hypothèse potentielle : si + présent (« si tu finis ») → futur dans la conséquence, donc « tu pourras ». « pourrais » est le conditionnel (réservé à l''irréel), « pouvais » l''imparfait et « peux » le présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7a029e6-52af-5fe4-843c-48fc59a2ab08', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Complète l''irréel du présent : « Si on ___ près de la mer, on se baignerait tous les jours. »', '[{"id":"a","text":"habitera"},{"id":"b","text":"habitait"},{"id":"c","text":"habiterait"},{"id":"d","text":"habite"}]'::jsonb, 'b', 'La conséquence « on se baignerait » est au conditionnel : irréel du présent, donc si + imparfait → « si on habitait ». « habitera » est le futur, « habiterait » le conditionnel (interdit après si) et « habite » le présent (potentiel).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d94df869-3946-5ce7-aa3e-0a7ede014eca', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Identifie l''emploi du conditionnel : « Vous devriez consulter un médecin. »', '[{"id":"a","text":"Une information non confirmée"},{"id":"b","text":"Un souhait"},{"id":"c","text":"Un conseil"},{"id":"d","text":"Une hypothèse irréelle"}]'::jsonb, 'c', '« Vous devriez » (conditionnel de devoir) atténue une recommandation : c''est un conseil. Ce n''est ni une information non vérifiée, ni un souhait, ni une hypothèse irréelle introduite par « si ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50167193-f094-5445-a91c-3b7511d4522f', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Si j''avais le temps, je t''aiderais."},{"id":"b","text":"Si tu es prêt, on part."},{"id":"c","text":"Si nous avions su, nous serions restés."},{"id":"d","text":"Si vous seriez d''accord, on commencerait."}]'::jsonb, 'd', 'La faute est en (d) : « si vous seriez » est interdit, le conditionnel ne suit jamais « si ». Il faut « si vous étiez d''accord ». (a) est un irréel du présent, (b) un potentiel et (c) un irréel du passé, tous corrects.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a665d099-1387-56d0-85e4-7dcee09f8d15', '4dbafb9d-875b-5260-8d09-6dafa33885ce', 'Complète l''irréel du passé : « Si elle avait écouté, elle ___ son erreur. »', '[{"id":"a","text":"aurait évité"},{"id":"b","text":"éviterait"},{"id":"c","text":"évitera"},{"id":"d","text":"évitait"}]'::jsonb, 'a', '« avait écouté » est un plus-que-parfait : l''irréel du passé exige le conditionnel passé, donc « elle aurait évité ». « éviterait » est un conditionnel présent (irréel du présent), « évitera » un futur et « évitait » un imparfait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b1f33379-133f-5a78-8056-ce28027dda29', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aad31943-47a3-5231-b359-0f8db8019b20', 'b1f33379-133f-5a78-8056-ce28027dda29', 'Il dit : « Je suis fatigué. » Quelle est la transformation correcte au discours indirect ?', '[{"id":"a","text":"Il dit je suis fatigué."},{"id":"b","text":"Il dit si il est fatigué."},{"id":"c","text":"Il dit qu''il est fatigué."},{"id":"d","text":"Il dit qu''il était fatigué."}]'::jsonb, 'c', 'Une phrase déclarative se rapporte avec « que » : Il dit qu''il est fatigué. Le pronom « je » devient « il ». L''option (b) confond « si » (réservé aux questions oui/non) avec « que ». L''option (d) met un imparfait alors que le verbe introducteur est au présent : aucun recul des temps.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4a29b51-8f09-52bd-8100-5e3eb8038bb0', 'b1f33379-133f-5a78-8056-ce28027dda29', 'Il demande : « Tu viens ? » Quelle est la transformation correcte ?', '[{"id":"a","text":"Il demande que tu viens."},{"id":"b","text":"Il demande si tu viens."},{"id":"c","text":"Il demande ce que tu viens."},{"id":"d","text":"Il demande tu viens ?"}]'::jsonb, 'b', 'Une question fermée (réponse oui/non) se rapporte avec « si » : Il demande si tu viens. L''option (a) emploie « que », réservé aux phrases déclaratives. L''option (c) utilise « ce que », réservé à « qu''est-ce que ». L''option (d) garde la forme interrogative directe, interdite au discours indirect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc54610c-db52-5f2e-a218-344d51bec8bd', 'b1f33379-133f-5a78-8056-ce28027dda29', 'Elle demande : « Où habites-tu ? » Quelle est la transformation correcte ?', '[{"id":"a","text":"Elle demande où tu habites."},{"id":"b","text":"Elle demande si tu habites."},{"id":"c","text":"Elle demande où habites-tu."},{"id":"d","text":"Elle demande que tu habites."}]'::jsonb, 'a', 'Avec un mot interrogatif (où), on garde ce mot et on revient à l''ordre sujet + verbe : Elle demande où tu habites. L''option (c) conserve l''inversion « habites-tu », interdite ici. L''option (b) emploie « si », qui efface l''information « où ». L''option (d) confond avec « que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b4969c2-33fb-5630-81a4-d8700fb59501', 'b1f33379-133f-5a78-8056-ce28027dda29', 'Il dit : « Sortez ! » Quelle est la transformation correcte de cet ordre ?', '[{"id":"a","text":"Il dit que vous sortez."},{"id":"b","text":"Il dit si vous sortez."},{"id":"c","text":"Il dit vous sortez."},{"id":"d","text":"Il dit de sortir."}]'::jsonb, 'd', 'Un ordre (impératif) se rapporte avec « de + infinitif » : Il dit de sortir. L''option (a) emploie « que » + indicatif, ce qui transforme l''ordre en simple constat. L''option (b) utilise « si », réservé aux questions. L''option (c) oublie le mot de liaison.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33dc7bc7-ee23-54fc-940a-407d6e3b4042', 'b1f33379-133f-5a78-8056-ce28027dda29', 'Il a dit : « Je suis prêt. » (verbe introducteur au passé) Quelle est la transformation correcte ?', '[{"id":"a","text":"Il a dit qu''il est prêt."},{"id":"b","text":"Il a dit qu''il était prêt."},{"id":"c","text":"Il a dit qu''il sera prêt."},{"id":"d","text":"Il a dit qu''il a été prêt."}]'::jsonb, 'b', 'Le verbe introducteur étant au passé (a dit), on applique la concordance : le présent « est » devient imparfait « était ». L''option (a) oublie le recul du temps. L''option (c) introduit un futur absent de l''original. L''option (d) met un passé composé au lieu de l''imparfait.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a4ece141-4263-536d-b60c-63150cab66a0', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', '⭐ Entraînement : le discours indirect', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1898b678-8cab-5403-aac7-6d24a9373849', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Elle dit : « Je travaille. » → Elle dit ___ elle travaille.', '[{"id":"a","text":"si"},{"id":"b","text":"qu''"},{"id":"c","text":"ce que"},{"id":"d","text":"de"}]'::jsonb, 'b', 'Une phrase déclarative se rapporte avec « que » (« qu'' » devant voyelle) : Elle dit qu''elle travaille. « Si » est réservé aux questions oui/non, « ce que » à « qu''est-ce que », et « de » à l''impératif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42fb7a9b-4eab-5245-9389-4196739e0c08', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Il demande : « Est-ce que tu pars ? » → Il demande ___ tu pars.', '[{"id":"a","text":"que"},{"id":"b","text":"ce que"},{"id":"c","text":"si"},{"id":"d","text":"où"}]'::jsonb, 'c', 'C''est une question fermée (réponse oui/non) : on la rapporte avec « si ». Il demande si tu pars. « Que » sert aux déclaratives, « ce que » à « qu''est-ce que », et « où » est un lieu absent ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa39f16e-7a5f-5ef2-9d38-97644da04e3a', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Elle demande : « Quand reviens-tu ? » → Elle demande ___ tu reviens.', '[{"id":"a","text":"quand"},{"id":"b","text":"si"},{"id":"c","text":"que"},{"id":"d","text":"ce que"}]'::jsonb, 'a', 'Avec un mot interrogatif, on le conserve : « quand » reste « quand », et on rétablit l''ordre sujet + verbe (tu reviens). « Si » effacerait l''idée de temps ; « que » et « ce que » ne conviennent pas à une question de temps.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa6f555f-59c5-5bdf-b4a1-43a910026ba1', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Le professeur dit : « Écoutez ! » → Le professeur dit ___ écouter.', '[{"id":"a","text":"que"},{"id":"b","text":"si"},{"id":"c","text":"qu''on"},{"id":"d","text":"d''"}]'::jsonb, 'd', 'Un ordre (impératif) se rapporte avec « de + infinitif » (« d'' » devant voyelle) : le professeur dit d''écouter. « Que » et « si » introduiraient un verbe conjugué, pas un ordre transformé en infinitif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9c00506-4253-5009-9bb8-d5d73b185968', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Marie dit : « J''adore mon métier. » → Marie dit qu''elle adore ___ métier.', '[{"id":"a","text":"mon"},{"id":"b","text":"son"},{"id":"c","text":"ton"},{"id":"d","text":"leur"}]'::jsonb, 'b', 'Le possessif change avec le locuteur : le « mon » de Marie devient « son » quand c''est toi qui rapportes. Garder « mon » signifierait que Marie adore TON métier ; « ton » et « leur » désignent d''autres personnes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d33d6107-cdc1-51bb-9f26-39b192eaee9c', 'a4ece141-4263-536d-b60c-63150cab66a0', 'Complète : Il demande : « Qu''est-ce que tu manges ? » → Il demande ___ je mange.', '[{"id":"a","text":"que"},{"id":"b","text":"ce qui"},{"id":"c","text":"ce que"},{"id":"d","text":"si"}]'::jsonb, 'c', '« Qu''est-ce que » (complément d''objet) se transforme en « ce que » : Il demande ce que je mange. « Ce qui » correspondrait à « qu''est-ce qui » (sujet) ; « que » seul et « si » ne conviennent pas.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f68b578e-bfed-53f3-b25e-e8c7bf274278', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', '⭐⭐ Révision : le discours indirect', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('176323dc-5fee-5c88-a612-e5678ee912fd', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Il a dit : « Je suis malade. »', '[{"id":"a","text":"Il a dit qu''il est malade."},{"id":"b","text":"Il a dit qu''il sera malade."},{"id":"c","text":"Il a dit qu''il était malade."},{"id":"d","text":"Il a dit qu''il a été malade."}]'::jsonb, 'c', 'Verbe introducteur au passé : concordance des temps. Le présent « est » devient imparfait « était » : Il a dit qu''il était malade. Garder « est » oublie le recul ; « sera » ajoute un futur ; « a été » met un passé composé au lieu de l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc34c4d6-f6e6-5324-8480-5d504fdf553d', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Elle a expliqué : « J''ai terminé mon rapport. »', '[{"id":"a","text":"Elle a expliqué qu''elle avait terminé son rapport."},{"id":"b","text":"Elle a expliqué qu''elle a terminé son rapport."},{"id":"c","text":"Elle a expliqué qu''elle terminait son rapport."},{"id":"d","text":"Elle a expliqué qu''elle avait terminé mon rapport."}]'::jsonb, 'a', 'Concordance : le passé composé « ai terminé » devient plus-que-parfait « avait terminé », et « mon » devient « son ». L''option (b) oublie le recul du temps ; (c) met un imparfait (concordance du présent) ; (d) garde « mon » et change le sens.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('352599cd-5e63-50d8-86f4-fae01a2aa92f', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Le guide a dit : « Suivez-moi ! »', '[{"id":"a","text":"Le guide a dit de le suivre."},{"id":"b","text":"Le guide a dit qu''on le suit."},{"id":"c","text":"Le guide a dit de me suivre."},{"id":"d","text":"Le guide a dit si on le suit."}]'::jsonb, 'a', 'Un ordre se rapporte avec « de + infinitif » ; le pronom « moi » du guide devient « le » : le guide a dit de le suivre. L''option (b) transforme l''ordre en constat ; (c) garde « me » (le mauvais point de vue) ; (d) emploie « si », réservé aux questions.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5ad5b35-9dfe-5661-91db-ac45b03ef345', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Il a promis : « Je viendrai demain. »', '[{"id":"a","text":"Il a promis qu''il viendra le lendemain."},{"id":"b","text":"Il a promis qu''il viendrait le lendemain."},{"id":"c","text":"Il a promis qu''il venait le lendemain."},{"id":"d","text":"Il a promis qu''il viendrait demain."}]'::jsonb, 'b', 'Deux transformations : le futur « viendrai » devient conditionnel « viendrait », et « demain » devient « le lendemain ». L''option (a) garde le futur ; (c) met un imparfait au lieu du conditionnel ; (d) oublie de transformer le marqueur « demain ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('471c96ef-33e6-50ae-a650-4c8f636f8857', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Elle a demandé : « Est-ce que tu as compris ? »', '[{"id":"a","text":"Elle a demandé que j''avais compris."},{"id":"b","text":"Elle a demandé si j''ai compris."},{"id":"c","text":"Elle a demandé si tu as compris."},{"id":"d","text":"Elle a demandé si j''avais compris."}]'::jsonb, 'd', 'Question fermée → « si » ; verbe au passé → concordance : le passé composé « as compris » devient plus-que-parfait « avais compris », et « tu » devient « je ». L''option (a) emploie « que » ; (b) oublie le recul ; (c) ne change pas le pronom.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f261eda-844c-57a8-8f09-68ddecef8332', 'f68b578e-bfed-53f3-b25e-e8c7bf274278', 'Transforme : Il a demandé : « Qu''est-ce qui ne va pas ? »', '[{"id":"a","text":"Il a demandé ce que ne va pas."},{"id":"b","text":"Il a demandé ce qui n''allait pas."},{"id":"c","text":"Il a demandé qu''est-ce qui n''allait pas."},{"id":"d","text":"Il a demandé si ne va pas."}]'::jsonb, 'b', '« Qu''est-ce qui » (sujet) devient « ce qui », et la concordance fait passer « ne va pas » à l''imparfait « n''allait pas ». L''option (a) confond avec « ce que » (objet) ; (c) garde la forme interrogative directe ; (d) emploie « si » sans sujet.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : le discours indirect', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f98e62c-86d9-511b-9f3a-6d7de15929c4', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Elle a dit : « Aujourd''hui, je me sens bien. »', '[{"id":"a","text":"Elle a dit qu''aujourd''hui elle se sent bien."},{"id":"b","text":"Elle a dit qu''aujourd''hui elle se sentait bien."},{"id":"c","text":"Elle a dit que la veille elle se sentait bien."},{"id":"d","text":"Elle a dit que ce jour-là elle se sentait bien."}]'::jsonb, 'd', 'Au passé, deux transformations : le présent « se sens » devient imparfait « se sentait », et « aujourd''hui » devient « ce jour-là ». L''option (a) ne change rien ; (b) garde « aujourd''hui » ; (c) confond avec « la veille » (transformation de « hier »). Le piège courant : transformer le verbe mais oublier le marqueur de temps.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64f28a54-b53e-59b1-b1e5-9274dc1a9903', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Il a annoncé : « J''ai rencontré le directeur hier. »', '[{"id":"a","text":"Il a annoncé qu''il avait rencontré le directeur le lendemain."},{"id":"b","text":"Il a annoncé qu''il avait rencontré le directeur la veille."},{"id":"c","text":"Il a annoncé qu''il a rencontré le directeur la veille."},{"id":"d","text":"Il a annoncé qu''il rencontrait le directeur la veille."}]'::jsonb, 'b', 'Le passé composé « ai rencontré » devient plus-que-parfait « avait rencontré », et « hier » devient « la veille ». L''option (a) confond « hier » avec « le lendemain » (qui transforme « demain ») ; (c) oublie le recul du temps ; (d) met un imparfait à la place du plus-que-parfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('162d3578-02b3-55a9-ac40-1e60d77a728d', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Elle a demandé : « Pourquoi est-ce que tu pleures ? »', '[{"id":"a","text":"Elle a demandé pourquoi est-ce que je pleurais."},{"id":"b","text":"Elle a demandé si je pleurais."},{"id":"c","text":"Elle a demandé pourquoi je pleurais."},{"id":"d","text":"Elle a demandé ce que je pleurais."}]'::jsonb, 'c', 'Le mot interrogatif « pourquoi » se conserve, « est-ce que » disparaît, on revient à l''ordre sujet + verbe, et le présent « pleures » devient imparfait « pleurais ». L''option (a) garde « est-ce que » ; (b) emploie « si » et perd l''idée de cause ; (d) confond avec « ce que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4f9caf6-3c09-50a6-aa4a-faaccdbf3eae', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Le médecin a dit au patient : « Ne fumez plus ! »', '[{"id":"a","text":"Le médecin a dit au patient de ne plus fumer."},{"id":"b","text":"Le médecin a dit au patient qu''il ne fume plus."},{"id":"c","text":"Le médecin a dit au patient de ne fumer plus."},{"id":"d","text":"Le médecin a dit au patient s''il ne fumait plus."}]'::jsonb, 'a', 'Un ordre négatif se rapporte avec « de + ne plus + infinitif » : de ne plus fumer (la négation entoure l''infinitif). L''option (c) place mal « plus » (on dit « ne plus fumer », pas « ne fumer plus »). L''option (b) transforme l''ordre en constat ; (d) emploie « si », réservé aux questions.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e843c297-6b7f-5f1d-91d9-e483b1f0a16a', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Il a dit : « Mes amis viendront me voir demain. »', '[{"id":"a","text":"Il a dit que ses amis viendront le voir demain."},{"id":"b","text":"Il a dit que mes amis viendraient le voir le lendemain."},{"id":"c","text":"Il a dit que ses amis venaient le voir le lendemain."},{"id":"d","text":"Il a dit que ses amis viendraient le voir le lendemain."}]'::jsonb, 'd', 'Trois transformations : « mes » → « ses », le futur « viendront » → conditionnel « viendraient », « me » → « le », et « demain » → « le lendemain ». L''option (a) garde le futur et « demain » ; (b) garde « mes » ; (c) met un imparfait au lieu du conditionnel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db4bb59a-2a4d-530c-af6d-d0c45583c130', 'ede6ea15-8284-5a97-ab35-4cef2f2e5f0f', 'Transforme : Elle a demandé : « Qu''est-ce que tu feras maintenant ? »', '[{"id":"a","text":"Elle a demandé ce que je ferai maintenant."},{"id":"b","text":"Elle a demandé ce que je ferais à ce moment-là."},{"id":"c","text":"Elle a demandé ce qui je ferais à ce moment-là."},{"id":"d","text":"Elle a demandé si je ferais à ce moment-là."}]'::jsonb, 'b', '« Qu''est-ce que » (objet) → « ce que » ; le futur « feras » → conditionnel « ferais » ; « maintenant » → « à ce moment-là ». L''option (a) garde le futur et « maintenant » ; (c) emploie « ce qui » (sujet) à la place de « ce que » ; (d) emploie « si », réservé aux questions fermées.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : le discours indirect', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59c19d0b-5132-5d1e-9fd8-f896de26067b', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Transforme : Hier, elle m''a dit : « Je t''appellerai demain et nous déjeunerons ensemble. »', '[{"id":"a","text":"Hier, elle m''a dit qu''elle m''appellerait demain et que nous déjeunerions ensemble."},{"id":"b","text":"Hier, elle m''a dit qu''elle m''appellera le lendemain et que nous déjeunerons ensemble."},{"id":"c","text":"Hier, elle m''a dit qu''elle m''appellerait le lendemain et que nous déjeunerions ensemble."},{"id":"d","text":"Hier, elle m''a dit qu''elle m''appelait le lendemain et que nous déjeunions ensemble."}]'::jsonb, 'c', 'Les deux futurs (« appellerai », « déjeunerons ») deviennent des conditionnels (« appellerait », « déjeunerions »), et « demain » devient « le lendemain ». L''option (a) oublie le marqueur ; (b) garde les futurs ; (d) emploie l''imparfait au lieu du conditionnel. Le piège : un seul conditionnel suffit rarement, il faut traiter chaque verbe.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1796fdd4-b5e6-551a-ba13-848ee995fde0', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Transforme : Il a demandé : « Qu''est-ce qui s''est passé et qui a appelé la police ? »', '[{"id":"a","text":"Il a demandé ce que s''était passé et qui avait appelé la police."},{"id":"b","text":"Il a demandé ce qui s''est passé et qui a appelé la police."},{"id":"c","text":"Il a demandé qu''est-ce qui s''était passé et qui avait appelé la police."},{"id":"d","text":"Il a demandé ce qui s''était passé et qui avait appelé la police."}]'::jsonb, 'd', '« Qu''est-ce qui » (sujet) → « ce qui » ; « qui » se conserve ; les deux passés composés reculent en plus-que-parfait (« s''était passé », « avait appelé »). L''option (a) confond avec « ce que » ; (b) oublie la concordance ; (c) garde « qu''est-ce qui ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e046b341-1207-5968-8389-b3ed8c91cd20', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Transforme : La mère a dit à ses enfants : « Rangez votre chambre et ne faites pas de bruit ! »', '[{"id":"a","text":"La mère a dit à ses enfants de ranger leur chambre et de ne pas faire de bruit."},{"id":"b","text":"La mère a dit à ses enfants de ranger votre chambre et de ne pas faire de bruit."},{"id":"c","text":"La mère a dit à ses enfants qu''ils rangent leur chambre et ne font pas de bruit."},{"id":"d","text":"La mère a dit à ses enfants de ranger leur chambre et de ne faire pas de bruit."}]'::jsonb, 'a', 'Deux ordres → « de + infinitif » ; le possessif « votre » devient « leur » (point de vue de la mère qui rapporte) ; la négation correcte est « ne pas faire ». L''option (b) garde « votre » ; (c) transforme les ordres en constats ; (d) place mal la négation (« ne faire pas »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e81d307c-36b4-57b6-bb49-faab5e97376a', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Transforme : Elle a dit : « Aujourd''hui je suis fatiguée, hier j''ai trop travaillé et demain je me reposerai. »', '[{"id":"a","text":"Elle a dit que ce jour-là elle était fatiguée, que la veille elle a trop travaillé et que le lendemain elle se reposerait."},{"id":"b","text":"Elle a dit que ce jour-là elle était fatiguée, que la veille elle avait trop travaillé et que le lendemain elle se reposerait."},{"id":"c","text":"Elle a dit qu''aujourd''hui elle était fatiguée, qu''hier elle avait trop travaillé et que demain elle se reposerait."},{"id":"d","text":"Elle a dit que ce jour-là elle est fatiguée, que la veille elle avait trop travaillé et que le lendemain elle se reposera."}]'::jsonb, 'b', 'Trois temps reculent : présent « suis » → imparfait « était » ; passé composé « ai travaillé » → plus-que-parfait « avait travaillé » ; futur « reposerai » → conditionnel « reposerait ». Et trois marqueurs : aujourd''hui → ce jour-là, hier → la veille, demain → le lendemain. L''option (a) oublie le recul du passé composé ; (c) garde les marqueurs d''origine ; (d) garde un présent et un futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd4791db-8309-5018-bbf1-6f563bb648c1', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Transforme : Le client a demandé : « Est-ce que vous acceptez les cartes et combien coûte la livraison ? »', '[{"id":"a","text":"Le client a demandé si nous acceptions les cartes et combien coûte la livraison."},{"id":"b","text":"Le client a demandé que nous acceptions les cartes et combien coûtait la livraison."},{"id":"c","text":"Le client a demandé si nous acceptions les cartes et combien coûtait la livraison."},{"id":"d","text":"Le client a demandé si nous acceptions les cartes et combien coûte-t-elle la livraison."}]'::jsonb, 'c', 'Question fermée → « si » ; question avec mot interrogatif « combien » → on garde « combien » sans inversion ; les deux présents reculent en imparfait (« acceptions », « coûtait »). L''option (a) oublie le recul de « coûte » ; (b) emploie « que » au lieu de « si » ; (d) garde une inversion (« coûte-t-elle »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e2739ee-a2ed-5462-9de8-8d12001fac01', 'b2a0634d-7fbc-5af6-ae62-8af467fff6fd', 'Quelle phrase rapporte CORRECTEMENT : Il a dit : « Mon frère viendra me chercher maintenant. » ?', '[{"id":"a","text":"Il a dit que son frère viendrait le chercher à ce moment-là."},{"id":"b","text":"Il a dit que mon frère viendrait le chercher à ce moment-là."},{"id":"c","text":"Il a dit que son frère viendra me chercher maintenant."},{"id":"d","text":"Il a dit que son frère venait le chercher à ce moment-là."}]'::jsonb, 'a', 'Quatre ajustements : « mon » → « son », futur « viendra » → conditionnel « viendrait », « me » → « le », « maintenant » → « à ce moment-là ». L''option (b) garde « mon » ; (c) ne transforme rien ; (d) met un imparfait au lieu du conditionnel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('427710ee-3d07-5c78-979f-143f1df48fb8', 'eae30ba7-c7fb-5a93-9b6a-39ea9a3a1d1c', 'francais-b1', '⭐⭐ Drill : le discours indirect', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d7e9a27-c417-5ba2-96e5-635a180f29cf', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Complète : Il demande : « Est-ce que vous êtes prêts ? » → Il demande ___ nous sommes prêts.', '[{"id":"a","text":"que"},{"id":"b","text":"si"},{"id":"c","text":"ce que"},{"id":"d","text":"comment"}]'::jsonb, 'b', 'Question fermée (réponse oui/non) → « si » : Il demande si nous sommes prêts. « Que » sert aux déclaratives, « ce que » à « qu''est-ce que », et « comment » à une question de manière.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f307463d-ab12-5585-9f70-a9ea2465c7b1', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Transforme : Elle a dit : « Je ne comprends pas. » (verbe introducteur au passé)', '[{"id":"a","text":"Elle a dit qu''elle ne comprenait pas."},{"id":"b","text":"Elle a dit qu''elle ne comprend pas."},{"id":"c","text":"Elle a dit qu''elle n''a pas compris."},{"id":"d","text":"Elle a dit qu''elle ne comprendrait pas."}]'::jsonb, 'a', 'Concordance au passé : le présent « comprends » devient imparfait « comprenait » : Elle a dit qu''elle ne comprenait pas. L''option (b) oublie le recul ; (c) met un passé composé (concordance du présent erronée) ; (d) met un conditionnel (concordance du futur).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c015968d-c9fc-5044-879f-7371aab459ea', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Transforme : Le coach a crié : « Courez plus vite ! »', '[{"id":"a","text":"Le coach a crié qu''on court plus vite."},{"id":"b","text":"Le coach a crié si on court plus vite."},{"id":"c","text":"Le coach a crié que courir plus vite."},{"id":"d","text":"Le coach a crié de courir plus vite."}]'::jsonb, 'd', 'Un ordre → « de + infinitif » : Le coach a crié de courir plus vite. L''option (a) transforme l''ordre en constat ; (b) emploie « si », réservé aux questions ; (c) combine « que » et un infinitif, ce qui est incorrect.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab98a58c-07e4-519f-bdeb-ae3211953174', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Transforme : Il a demandé : « Qu''est-ce qui te fait rire ? »', '[{"id":"a","text":"Il a demandé ce que me faisait rire."},{"id":"b","text":"Il a demandé si me faisait rire."},{"id":"c","text":"Il a demandé ce qui me faisait rire."},{"id":"d","text":"Il a demandé ce qui te faisait rire."}]'::jsonb, 'c', '« Qu''est-ce qui » (sujet) → « ce qui » ; concordance : présent « fait » → imparfait « faisait » ; pronom « te » → « me ». L''option (a) confond avec « ce que » (objet) ; (b) emploie « si » sans sujet ; (d) garde « te » au lieu de « me ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63da6087-fbb9-5282-8c9e-becb02c3b9b2', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Transforme : Elle a déclaré : « Je rendrai ma réponse demain. »', '[{"id":"a","text":"Elle a déclaré qu''elle rendrait sa réponse le lendemain."},{"id":"b","text":"Elle a déclaré qu''elle rendra sa réponse le lendemain."},{"id":"c","text":"Elle a déclaré qu''elle rendrait sa réponse demain."},{"id":"d","text":"Elle a déclaré qu''elle rendait sa réponse le lendemain."}]'::jsonb, 'a', 'Le futur « rendrai » devient conditionnel « rendrait », « ma » devient « sa », et « demain » devient « le lendemain ». L''option (b) garde le futur ; (c) oublie de transformer « demain » ; (d) met un imparfait au lieu du conditionnel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fb6cb4b-a2a7-57f0-8df1-695235220e3d', '427710ee-3d07-5c78-979f-143f1df48fb8', 'Transforme : Il a demandé : « Où as-tu mis mes clés ? »', '[{"id":"a","text":"Il a demandé où j''ai mis ses clés."},{"id":"b","text":"Il a demandé si j''avais mis ses clés."},{"id":"c","text":"Il a demandé où as-tu mis ses clés."},{"id":"d","text":"Il a demandé où j''avais mis ses clés."}]'::jsonb, 'd', '« Où » se conserve, on rétablit l''ordre sujet + verbe, le passé composé « as mis » recule en plus-que-parfait « avais mis », « tu » → « je » et « mes » → « ses ». L''option (a) oublie le recul du temps ; (b) emploie « si » et perd « où » ; (c) garde l''inversion « as-tu ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8760d010-daa6-549c-b88e-30cc60253cfe', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51e02a3a-0345-564a-898c-397d84db993d', '8760d010-daa6-549c-b88e-30cc60253cfe', 'Avant d''être engagé, le candidat passe souvent un ___ d''embauche.', '[{"id":"a","text":"entretien"},{"id":"b","text":"salaire"},{"id":"c","text":"contrat"},{"id":"d","text":"chômage"}]'::jsonb, 'a', 'Un « entretien d''embauche » est la rencontre où le candidat est interrogé avant d''être engagé. Le salaire est l''argent gagné, le contrat est l''accord signé, et le chômage est l''absence d''emploi.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffb57c5c-81ec-5657-953f-2094d78871ad', '8760d010-daa6-549c-b88e-30cc60253cfe', 'Pour aider la planète, on doit ___ ses déchets afin de faciliter le recyclage.', '[{"id":"a","text":"gaspiller"},{"id":"b","text":"polluer"},{"id":"c","text":"trier"},{"id":"d","text":"publier"}]'::jsonb, 'c', '« Trier » ses déchets, c''est les séparer pour permettre le recyclage. « Gaspiller » et « polluer » nuisent à l''environnement, et « publier » concerne la diffusion d''un texte, pas les déchets.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f0e8da5-98dd-520a-807b-2c72d24f97f0', '8760d010-daa6-549c-b88e-30cc60253cfe', 'Complétez : « Je suis tout à fait ___ avec toi, tu as raison. »', '[{"id":"a","text":"d''accord"},{"id":"b","text":"inquiet"},{"id":"c","text":"déçu"},{"id":"d","text":"absent"}]'::jsonb, 'a', '« Être d''accord avec quelqu''un » signifie partager son opinion. « Inquiet » exprime le souci, « déçu » la déception, et « absent » l''absence — aucun ne convient pour approuver une idée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bf95d2b-a0e4-5004-bd0e-3c716352aa8a', '8760d010-daa6-549c-b88e-30cc60253cfe', 'Quand le patron décide de renvoyer un salarié, il le ___.', '[{"id":"a","text":"démissionne"},{"id":"b","text":"licencie"},{"id":"c","text":"embauche"},{"id":"d","text":"postule"}]'::jsonb, 'b', '« Licencier », c''est renvoyer un salarié à l''initiative de l''employeur. « Démissionner », au contraire, c''est partir de soi-même. « Embaucher » signifie engager, et « postuler » signifie présenter sa candidature.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54e4dc3f-1848-55d9-8dd8-337a76c79468', '8760d010-daa6-549c-b88e-30cc60253cfe', 'Quel mot désigne l''origine d''une information, c''est-à-dire qui l''a donnée ?', '[{"id":"a","text":"une publicité"},{"id":"b","text":"un article"},{"id":"c","text":"un réseau social"},{"id":"d","text":"une source"}]'::jsonb, 'd', 'Une « source » est l''origine d''une information : qui la fournit et d''où elle vient. Une publicité cherche à vendre, un article est un texte écrit, et un réseau social est une plateforme d''échange.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c5837897-67a8-5bbc-8c4f-3cb401fcaa96', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', '⭐ Entraînement : le travail et la société', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e18e23-7ac3-5e1b-b596-59d1ef753971', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « Pour répondre à cette offre, j''ai envoyé mon ___ et une lettre de motivation. »', '[{"id":"a","text":"CV"},{"id":"b","text":"salaire"},{"id":"c","text":"collègue"},{"id":"d","text":"chômage"}]'::jsonb, 'a', 'Le « CV » (curriculum vitae) est le document qui résume ton parcours et tes compétences, envoyé pour postuler. Le salaire est l''argent gagné, un collègue est une personne avec qui on travaille, et le chômage est l''absence d''emploi.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc3d2f5f-4ae6-50fb-8aff-88363f33046e', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « L''argent que l''on reçoit chaque mois pour son travail s''appelle le ___. »', '[{"id":"a","text":"contrat"},{"id":"b","text":"salaire"},{"id":"c","text":"poste"},{"id":"d","text":"entretien"}]'::jsonb, 'b', 'Le « salaire » est l''argent versé chaque mois en échange du travail. Le contrat est l''accord signé, le poste est la fonction occupée, et l''entretien est la rencontre avant l''embauche.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45fc3132-4df2-5bf8-83ce-4bb897b73661', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « Il faut ___ ses déchets : le verre d''un côté, le papier de l''autre. »', '[{"id":"a","text":"gaspiller"},{"id":"b","text":"polluer"},{"id":"c","text":"embaucher"},{"id":"d","text":"trier"}]'::jsonb, 'd', '« Trier » les déchets, c''est les séparer (verre, papier, plastique) pour le recyclage. « Gaspiller » et « polluer » dégradent l''environnement, et « embaucher » concerne le travail, pas les déchets.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2879ff2-2184-51b5-aa53-ee1a82e88778', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « Chaque matin, je lis le ___ pour connaître les actualités. »', '[{"id":"a","text":"réseau social"},{"id":"b","text":"journal"},{"id":"c","text":"salaire"},{"id":"d","text":"climat"}]'::jsonb, 'b', 'Un « journal » est un média qui publie l''actualité, sur papier ou en ligne. Le réseau social sert surtout à échanger, le salaire concerne le travail, et le climat concerne la météo et l''environnement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1f76367-82ae-5b14-a72e-52ede13373fb', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « Le verbe qui signifie « présenter sa candidature à un poste » est ___. »', '[{"id":"a","text":"démissionner"},{"id":"b","text":"licencier"},{"id":"c","text":"gaspiller"},{"id":"d","text":"postuler"}]'::jsonb, 'd', '« Postuler » à un poste, c''est présenter sa candidature pour l''obtenir. « Démissionner » c''est quitter son emploi, « licencier » c''est renvoyer un salarié, et « gaspiller » concerne le gâchis.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8836777-6edd-5ee9-84ed-b39db4ed15d6', 'c5837897-67a8-5bbc-8c4f-3cb401fcaa96', 'Complétez : « Le soleil et le vent fournissent une énergie ___. »', '[{"id":"a","text":"renouvelable"},{"id":"b","text":"polluée"},{"id":"c","text":"gaspillée"},{"id":"d","text":"publiée"}]'::jsonb, 'a', 'Une énergie « renouvelable » ne s''épuise pas : le soleil, le vent et l''eau en sont des sources. « Polluée » et « gaspillée » ont un sens négatif, et « publiée » se rapporte aux médias.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b5f20ac-9c22-53a4-8be3-f7e193e22762', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', '⭐⭐ Révision : le travail et la société', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bff51d5a-e33d-5a47-b55a-2080baa8b553', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Quel verbe est le contraire de « gaspiller » ?', '[{"id":"a","text":"polluer"},{"id":"b","text":"économiser"},{"id":"c","text":"trier"},{"id":"d","text":"jeter"}]'::jsonb, 'b', '« Économiser », c''est utiliser le moins possible (eau, énergie, argent) ; c''est l''inverse de « gaspiller », qui veut dire perdre ou utiliser inutilement. « Polluer », « trier » et « jeter » ne sont pas l''antonyme de gaspiller.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('172d7f21-420f-5117-81eb-2744a5fd1452', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Complétez : « Mon oncle a perdu son travail : il est au ___ depuis trois mois. »', '[{"id":"a","text":"salaire"},{"id":"b","text":"chômage"},{"id":"c","text":"contrat"},{"id":"d","text":"climat"}]'::jsonb, 'b', '« Être au chômage » signifie ne plus avoir d''emploi. Le salaire est l''argent du travail, le contrat est l''accord signé, et le climat concerne l''environnement — aucun ne décrit l''absence de travail.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6921053f-9eac-5838-b8bd-8620df915f1c', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Trouvez l''intrus : trois de ces mots concernent le travail, lequel n''a aucun rapport ?', '[{"id":"a","text":"un poste"},{"id":"b","text":"un entretien"},{"id":"c","text":"un collègue"},{"id":"d","text":"le recyclage"}]'::jsonb, 'd', '« Le recyclage » appartient au champ de l''environnement, pas du travail. Un poste, un entretien et un collègue sont tous liés au monde de l''emploi. L''intrus est donc le recyclage.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6bdc1f5-d073-5c3b-bd2f-c73239ef5aec', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Quelle est la bonne collocation ? « Nous devons ___ une décision rapidement. »', '[{"id":"a","text":"faire une décision"},{"id":"b","text":"donner une décision"},{"id":"c","text":"prendre une décision"},{"id":"d","text":"jouer une décision"}]'::jsonb, 'c', 'En français, on dit « prendre une décision », jamais « faire » ni « donner » une décision. C''est une collocation fixe. « Jouer un rôle » existe, mais pas « jouer une décision ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd818406-5bc2-54b2-b95d-0c2e3517ebcc', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Complétez : « Avant de ___ cette information, vérifie qu''elle est vraie. »', '[{"id":"a","text":"partager"},{"id":"b","text":"trier"},{"id":"c","text":"embaucher"},{"id":"d","text":"économiser"}]'::jsonb, 'a', '« Partager » une information, c''est la diffuser à d''autres, souvent en ligne. « Trier » concerne les déchets, « embaucher » le travail, et « économiser » l''argent ou l''énergie.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4888e6e-639c-52a1-a9b4-52d8dbbd6465', '6b5f20ac-9c22-53a4-8be3-f7e193e22762', 'Quel verbe signifie « quitter son emploi de sa propre volonté » ?', '[{"id":"a","text":"licencier"},{"id":"b","text":"embaucher"},{"id":"c","text":"postuler"},{"id":"d","text":"démissionner"}]'::jsonb, 'd', '« Démissionner », c''est partir de son emploi par sa propre décision. « Licencier » se fait à l''initiative du patron, « embaucher » c''est engager, et « postuler » c''est se porter candidat.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('68d3b107-ff40-5d93-955f-07fead20324f', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : le travail et la société', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('412f8aca-30db-5f69-a7cf-527272928846', '68d3b107-ff40-5d93-955f-07fead20324f', 'Complétez avec la bonne préposition : « Je m''inquiète ___ l''avenir de la planète. »', '[{"id":"a","text":"de"},{"id":"b","text":"à"},{"id":"c","text":"avec"},{"id":"d","text":"pour à"}]'::jsonb, 'a', 'On dit « s''inquiéter DE quelque chose » : je m''inquiète de l''avenir. ✓ Le piège courant est d''employer « à » ou « avec » par analogie avec d''autres verbes ; ici la seule préposition correcte est « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44e34dc8-bcbd-5bda-b995-1649b61efbf6', '68d3b107-ff40-5d93-955f-07fead20324f', 'Dans « L''entreprise a dû licencier dix salariés à cause de la crise », que signifie « licencier » ?', '[{"id":"a","text":"engager de nouveaux salariés"},{"id":"b","text":"renvoyer des salariés"},{"id":"c","text":"augmenter les salaires"},{"id":"d","text":"former les salariés"}]'::jsonb, 'b', '« Licencier » signifie renvoyer un salarié à l''initiative de l''employeur, souvent pour des raisons économiques. ✓ Le piège : confondre avec « embaucher » (engager) ou avec « démissionner » (l''employé part de lui-même).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fbe9bc3-f5d4-5258-831c-faef86b9c9b0', '68d3b107-ff40-5d93-955f-07fead20324f', 'Quel mot complète le mieux la phrase ? « La ___ cherche surtout à nous faire acheter un produit. »', '[{"id":"a","text":"source"},{"id":"b","text":"actualité"},{"id":"c","text":"publicité"},{"id":"d","text":"information"}]'::jsonb, 'c', 'La « publicité » a pour but de vendre un produit ou un service. ✓ Le piège courant est de répondre « information » ou « actualité » : ces mots désignent un fait, neutre, alors que la publicité cherche à influencer pour vendre.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d54be6f-4671-59e3-ad6a-59f84a190aa4', '68d3b107-ff40-5d93-955f-07fead20324f', 'Complétez : « Grâce au ___, on transforme les vieux emballages en nouveaux objets. »', '[{"id":"a","text":"réchauffement"},{"id":"b","text":"gaspillage"},{"id":"c","text":"recyclage"},{"id":"d","text":"chômage"}]'::jsonb, 'c', 'Le « recyclage » consiste à transformer les déchets pour les réutiliser. ✓ Le piège : « gaspillage » est l''inverse (perdre), « réchauffement » concerne la hausse des températures, et « chômage » l''absence d''emploi.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58656d3d-e89a-5006-9a46-f996e7a209ae', '68d3b107-ff40-5d93-955f-07fead20324f', 'Choisissez la phrase dont la collocation est correcte.', '[{"id":"a","text":"Il faut prendre des efforts pour réussir."},{"id":"b","text":"Il faut donner des efforts pour réussir."},{"id":"c","text":"Il faut jouer des efforts pour réussir."},{"id":"d","text":"Il faut faire des efforts pour réussir."}]'::jsonb, 'd', 'La collocation correcte est « faire des efforts ». ✓ Le piège : on « prend » une décision et on « joue » un rôle, mais avec « efforts » seul le verbe « faire » fonctionne en français standard.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78feae4d-328c-58bb-87f2-ac70ecc4483f', '68d3b107-ff40-5d93-955f-07fead20324f', 'Quel verbe a le sens le plus proche de « défendre, appuyer une idée » ?', '[{"id":"a","text":"critiquer"},{"id":"b","text":"douter"},{"id":"c","text":"soutenir"},{"id":"d","text":"licencier"}]'::jsonb, 'c', '« Soutenir » une idée, c''est la défendre, l''appuyer. ✓ Le piège : « critiquer » signifie l''inverse (juger négativement), « douter » exprime l''incertitude, et « licencier » appartient au monde du travail.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('846da7a1-49b8-5b38-b354-09871b518b71', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : le travail et la société', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fbba347-d64b-5373-b843-172ab492c5f7', '846da7a1-49b8-5b38-b354-09871b518b71', 'Choisissez la phrase dont les prépositions sont toutes correctes.', '[{"id":"a","text":"Je doute de sa sincérité mais j''ai besoin de son aide."},{"id":"b","text":"Je doute à sa sincérité mais j''ai besoin à son aide."},{"id":"c","text":"Je doute sa sincérité mais j''ai besoin son aide."},{"id":"d","text":"Je doute avec sa sincérité mais j''ai besoin avec son aide."}]'::jsonb, 'a', 'On dit « douter DE » et « avoir besoin DE » quelque chose. ✓ Le piège courant est d''omettre la préposition ou d''employer « à »/« avec » : ces deux verbes exigent « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3ef06c5-a4a0-5872-a764-2a253fc1f327', '846da7a1-49b8-5b38-b354-09871b518b71', 'Trouvez l''intrus : trois de ces mots sont synonymes ou très proches, lequel s''en éloigne ?', '[{"id":"a","text":"une information"},{"id":"b","text":"une actualité"},{"id":"c","text":"une nouvelle"},{"id":"d","text":"une publicité"}]'::jsonb, 'd', '« Une publicité » cherche à vendre : elle s''éloigne du groupe. « Une information », « une actualité » et « une nouvelle » désignent toutes un fait récent et neutre. L''intrus est donc la publicité.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc40d337-22ce-5959-a651-29040927f2d3', '846da7a1-49b8-5b38-b354-09871b518b71', 'Dans « Les énergies renouvelables jouent un rôle clé contre le réchauffement », que veut dire « jouer un rôle » ?', '[{"id":"a","text":"faire semblant"},{"id":"b","text":"être important, avoir une fonction"},{"id":"c","text":"s''amuser à un jeu"},{"id":"d","text":"perdre de l''importance"}]'::jsonb, 'b', '« Jouer un rôle » signifie ici être important, avoir une fonction décisive. ✓ Le piège : pris au sens premier, on penserait au théâtre ou au jeu ; dans cette collocation figurée, le sens est « compter, avoir de l''influence ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('609fcae9-c62b-5f21-900f-942a4fe9d93b', '846da7a1-49b8-5b38-b354-09871b518b71', 'Quelle phrase emploie correctement le couple « démissionner / licencier » ?', '[{"id":"a","text":"Mécontent, le salarié a décidé de démissionner ; son patron ne l''a pas licencié."},{"id":"b","text":"Mécontent, le salarié a décidé de licencier ; son patron a démissionné."},{"id":"c","text":"Le salarié a licencié son patron, qui a démissionné l''entreprise."},{"id":"d","text":"Le patron a démissionné le salarié, qui a licencié."}]'::jsonb, 'a', 'L''employé « démissionne » (il part de lui-même) et le patron « licencie » (il renvoie). ✓ La phrase a est la seule cohérente. Le piège des trois autres est d''inverser les deux verbes ou de les rendre transitifs à tort.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2180f398-eca5-5b4d-a57f-9f3f2b9666bd', '846da7a1-49b8-5b38-b354-09871b518b71', 'Complétez avec le mot le plus précis : « Sur internet, il faut vérifier la ___ avant de croire une information. »', '[{"id":"a","text":"publicité"},{"id":"b","text":"source"},{"id":"c","text":"connexion"},{"id":"d","text":"actualité"}]'::jsonb, 'b', 'Vérifier la « source », c''est s''assurer de l''origine fiable de l''information. ✓ Le piège : « actualité » et « publicité » désignent le contenu, non son origine, et « connexion » concerne l''accès technique au réseau.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('628212cb-6a32-5ab1-b14a-5fb6f481bc4b', '846da7a1-49b8-5b38-b354-09871b518b71', 'Quel mot est le contraire de « soutenir » une idée ?', '[{"id":"a","text":"espérer"},{"id":"b","text":"publier"},{"id":"c","text":"critiquer"},{"id":"d","text":"économiser"}]'::jsonb, 'c', '« Critiquer » une idée, c''est la juger négativement : c''est l''inverse de « soutenir » (la défendre). ✓ Le piège : « espérer » exprime un souhait, « publier » la diffusion, et « économiser » l''épargne — aucun n''est l''antonyme de soutenir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc7a5a74-578f-547f-b182-294ff4c3de3d', '8aac7900-13ea-5a11-873f-dce09fae9763', 'francais-b1', '⭐⭐ Drill : le travail et la société', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fcf98c2-1b24-5bf9-8361-3d912e599669', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Complétez : « J''ai signé un ___ : je suis embauché pour une durée indéterminée. »', '[{"id":"a","text":"CDD"},{"id":"b","text":"CV"},{"id":"c","text":"CDI"},{"id":"d","text":"salaire"}]'::jsonb, 'c', 'Le « CDI » est le contrat à durée indéterminée (sans date de fin), contrairement au « CDD » (déterminée). Le CV est le document de candidature, et le salaire est l''argent reçu chaque mois.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc013dbe-4e85-5daa-b965-fec3e6859064', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Quel verbe complète : « Pour protéger la planète, chacun doit ___ ses efforts. »', '[{"id":"a","text":"faire"},{"id":"b","text":"prendre"},{"id":"c","text":"donner"},{"id":"d","text":"jouer"}]'::jsonb, 'a', 'La collocation correcte est « faire des efforts ». On « prend » une décision et on « joue » un rôle, mais avec « efforts » seul le verbe « faire » convient en français standard.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1325c47-8080-5f6b-a08a-0fd8ec422d0c', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Trouvez l''intrus : trois mots concernent l''environnement, lequel n''a aucun rapport ?', '[{"id":"a","text":"la pollution"},{"id":"b","text":"les déchets"},{"id":"c","text":"l''entretien"},{"id":"d","text":"le climat"}]'::jsonb, 'c', '« L''entretien » (d''embauche) appartient au monde du travail, pas à l''environnement. La pollution, les déchets et le climat relèvent tous de l''écologie. L''intrus est donc l''entretien.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70553d09-269d-5bd3-8f2c-fe641a566dca', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Complétez : « Pour utiliser ce site, tu dois d''abord te ___ avec ton mot de passe. »', '[{"id":"a","text":"publier"},{"id":"b","text":"informer"},{"id":"c","text":"connecter"},{"id":"d","text":"soutenir"}]'::jsonb, 'c', '« Se connecter », c''est entrer dans un compte ou un site avec ses identifiants. « Publier » c''est rendre public un contenu, « s''informer » c''est chercher des nouvelles, et « soutenir » c''est défendre une idée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7392365-61fb-5e35-a13e-2530cb6f8316', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Quel mot signifie « espérer » ?', '[{"id":"a","text":"douter de quelque chose"},{"id":"b","text":"souhaiter que quelque chose de bon arrive"},{"id":"c","text":"critiquer une idée"},{"id":"d","text":"renvoyer un salarié"}]'::jsonb, 'b', '« Espérer », c''est souhaiter qu''une bonne chose se réalise. « Douter » exprime au contraire l''incertitude, « critiquer » le jugement négatif, et « licencier » (renvoyer un salarié) appartient au travail.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70f13759-b5cd-5eb6-9ec8-6378232ec41a', 'fc7a5a74-578f-547f-b182-294ff4c3de3d', 'Complétez : « Si tout le monde ___ l''eau, on en aura assez pour tous. »', '[{"id":"a","text":"gaspille"},{"id":"b","text":"pollue"},{"id":"c","text":"licencie"},{"id":"d","text":"économise"}]'::jsonb, 'd', '« Économiser » l''eau, c''est en utiliser le moins possible pour la préserver. « Gaspiller » et « polluer » nuisent à la ressource, et « licencier » concerne le travail — aucun ne convient ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('006b0ced-1808-5f5b-aa3b-df9c12b03511', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8df6a17a-2244-5012-8bdf-4860981a435c', '006b0ced-1808-5f5b-aa3b-df9c12b03511', 'Que faut-il faire AVANT de lire un texte de compréhension au niveau B1 ?', '[{"id":"a","text":"Lire lentement le texte du début à la fin."},{"id":"b","text":"Traduire tout le texte dans sa langue maternelle."},{"id":"c","text":"Lire d''abord les questions pour savoir quoi chercher."},{"id":"d","text":"Chercher chaque mot inconnu dans un dictionnaire."}]'::jsonb, 'c', 'La première stratégie est de lire les questions avant le texte, afin de savoir précisément quelle information chasser. Lire lentement, tout traduire ou chercher chaque mot sont des méthodes lentes et peu efficaces au niveau B1.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f16e303a-0202-59ae-9e47-38624c38e35c', '006b0ced-1808-5f5b-aa3b-df9c12b03511', 'Dans un texte argumentatif, qu''est-ce que la « thèse » ?', '[{"id":"a","text":"L''idée principale que l''auteur défend."},{"id":"b","text":"Un exemple concret donné dans le texte."},{"id":"c","text":"Le titre de l''article."},{"id":"d","text":"Un mot difficile à comprendre."}]'::jsonb, 'a', 'La thèse est l''idée centrale que l''auteur veut faire admettre ; elle se repère souvent au titre, en introduction et en conclusion. Un exemple sert à illustrer un argument, pas à porter l''idée centrale.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b2cb90a-5301-5685-9878-236343b3e08f', '006b0ced-1808-5f5b-aa3b-df9c12b03511', 'Lis la phrase :
« Bien que le restaurant soit cher, j''y retourne souvent. »
Que montre le connecteur « bien que » ?', '[{"id":"a","text":"Une cause : le prix explique les visites."},{"id":"b","text":"Une concession : on y va malgré le prix élevé."},{"id":"c","text":"Une conséquence : le prix entraîne les visites."},{"id":"d","text":"Une addition : on ajoute une nouvelle idée."}]'::jsonb, 'b', '« Bien que » introduit une concession : l''auteur reconnaît un obstacle (le prix élevé) mais agit quand même (il y retourne). Ce n''est ni une cause, ni une conséquence, ni une simple addition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e133645c-491a-5806-b31d-dcf3d742d134', '006b0ced-1808-5f5b-aa3b-df9c12b03511', 'Parmi ces phrases, laquelle exprime une OPINION (et non un fait) ?', '[{"id":"a","text":"Le film dure deux heures."},{"id":"b","text":"Le film est sorti en 2021."},{"id":"c","text":"Le film a été vu par un million de spectateurs."},{"id":"d","text":"Le film est, à mon avis, le meilleur de l''année."}]'::jsonb, 'd', '« À mon avis » et « le meilleur » signalent un jugement personnel : c''est une opinion. La durée, l''année de sortie et le nombre de spectateurs sont des faits vérifiables.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00415703-a422-5f89-a771-970e250a0449', '006b0ced-1808-5f5b-aa3b-df9c12b03511', 'Lis la phrase :
« Malheureusement, ce livre m''a profondément déçu. »
Quel est le ton de l''auteur ?', '[{"id":"a","text":"Positif"},{"id":"b","text":"Négatif"},{"id":"c","text":"Neutre"},{"id":"d","text":"Enthousiaste"}]'::jsonb, 'b', 'Les mots évaluatifs « Malheureusement » et « déçu » expriment une attitude négative. Un ton positif ou enthousiaste utiliserait des mots élogieux, et un ton neutre resterait objectif, sans jugement.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', '⭐ Entraînement : premières lectures B1', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('348827a7-a911-5679-8e88-87a14edd3fb3', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis l''article :
« De plus en plus de villes françaises installent des pistes cyclables. À Strasbourg, la municipalité a doublé le nombre de kilomètres réservés aux vélos en cinq ans. Résultat : aujourd''hui, près d''un habitant sur dix se rend au travail à bicyclette, ce qui réduit les embouteillages et la pollution. »

Quelle est l''idée principale de l''article ?', '[{"id":"a","text":"Les villes françaises développent le vélo, avec des effets positifs."},{"id":"b","text":"Strasbourg est la plus belle ville de France."},{"id":"c","text":"Les embouteillages augmentent partout en France."},{"id":"d","text":"Le vélo coûte cher à entretenir."}]'::jsonb, 'a', 'Le texte décrit l''essor des pistes cyclables et ses bénéfices (moins d''embouteillages et de pollution) : c''est l''idée centrale. La beauté de Strasbourg n''est pas évoquée, et le texte dit que les embouteillages diminuent, pas qu''ils augmentent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88e0fcd1-a30a-5727-b0e9-fd65ca4b69f9', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis le même article :
« À Strasbourg, la municipalité a doublé le nombre de kilomètres réservés aux vélos en cinq ans. »

En combien de temps Strasbourg a-t-elle doublé ses pistes cyclables ?', '[{"id":"a","text":"En dix ans."},{"id":"b","text":"L''article ne le précise pas."},{"id":"c","text":"En un an."},{"id":"d","text":"En cinq ans."}]'::jsonb, 'd', 'La phrase indique clairement « en cinq ans ». C''est un détail précis qu''il suffit de repérer dans le texte ; les autres durées ne sont pas mentionnées.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7e2cd9a-bd99-5cf8-90c4-727c489174a0', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis le message :
« Salut Léa ! Je t''écris vite : on organise un pique-nique au parc samedi à midi. Apporte juste une boisson, on s''occupe du reste. J''espère que tu pourras venir ! Bisous, Karim »

Pourquoi Karim écrit-il ce message ?', '[{"id":"a","text":"Pour annuler un rendez-vous."},{"id":"b","text":"Pour se plaindre du parc."},{"id":"c","text":"Pour inviter Léa à un pique-nique."},{"id":"d","text":"Pour demander de l''argent."}]'::jsonb, 'c', 'Karim annonce un pique-nique et écrit « J''espère que tu pourras venir » : c''est une invitation. Il n''annule rien, ne se plaint pas et ne demande pas d''argent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e30eb9e9-0b27-5478-bf19-363d945276ce', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis l''avis :
« J''ai adoré ce petit restaurant : les plats sont savoureux, le service rapide et les prix très raisonnables. Je le recommande vivement ! »

Quel est le ton de cet avis ?', '[{"id":"a","text":"Négatif"},{"id":"b","text":"Neutre"},{"id":"c","text":"Positif"},{"id":"d","text":"Indifférent"}]'::jsonb, 'c', 'Les mots « adoré », « savoureux », « raisonnables » et « je le recommande » expriment un avis enthousiaste : le ton est positif. Un ton négatif critiquerait, un ton neutre se contenterait de décrire sans juger.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1fd5e73-48ae-5ac1-b432-683fdfb924ee', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis l''annonce :
« BIBLIOTHÈQUE MUNICIPALE — Fermeture exceptionnelle le lundi 5 mai pour travaux. Réouverture normale dès le mardi 6 mai à 9 h. »

La bibliothèque est-elle ouverte le lundi 5 mai ?', '[{"id":"a","text":"Oui, comme d''habitude."},{"id":"b","text":"L''annonce ne le dit pas."},{"id":"c","text":"Oui, mais seulement l''après-midi."},{"id":"d","text":"Non, elle est fermée pour travaux."}]'::jsonb, 'd', 'L''annonce précise « Fermeture exceptionnelle le lundi 5 mai pour travaux » : elle est donc fermée ce jour-là. La réouverture est annoncée pour le mardi 6 mai, pas le lundi.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f02d6681-4ab8-5941-a079-418c19325737', '18324814-f3ae-5d3a-8f83-10d8b9a0e1ec', 'Lis la phrase :
« Les randonneurs étaient épuisés : ils se sont assis et ont refusé de faire un pas de plus. »
Que signifie « épuisés » ici ?', '[{"id":"a","text":"Très contents."},{"id":"b","text":"Très pressés."},{"id":"c","text":"Très en colère."},{"id":"d","text":"Très fatigués."}]'::jsonb, 'd', 'Les indices « ils se sont assis » et « ont refusé de faire un pas de plus » montrent qu''ils n''avaient plus d''énergie : « épuisés » signifie très fatigués. Le contexte ne suggère ni joie, ni hâte, ni colère.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('72739d9b-e4e4-5541-a3a7-07e7838f6b12', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', '⭐⭐ Révision : intention et point de vue', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e4a8725-ef47-5338-b07a-78b19d051876', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis le billet de blog :
« On répète aux jeunes qu''ils doivent absolument décrocher un diplôme. Pourtant, j''ai monté mon entreprise sans diplôme et je m''en sors très bien. Je ne dis pas qu''il faut arrêter l''école, mais qu''un diplôme n''est pas l''unique chemin vers la réussite. »

Quelle est la thèse de l''auteur ?', '[{"id":"a","text":"Il faut absolument quitter l''école pour réussir."},{"id":"b","text":"Le diplôme n''est pas le seul chemin vers la réussite."},{"id":"c","text":"Tous les jeunes devraient créer une entreprise."},{"id":"d","text":"L''école ne sert à rien aujourd''hui."}]'::jsonb, 'b', 'L''auteur conclut « un diplôme n''est pas l''unique chemin vers la réussite » : c''est sa thèse. Il précise même « Je ne dis pas qu''il faut arrêter l''école », ce qui exclut les options extrêmes (a) et (d) ; il ne dit pas non plus que tous doivent créer une entreprise.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb1cb46f-0612-54c7-a231-e1b2c311e689', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis le même billet :
« On répète aux jeunes qu''ils doivent absolument décrocher un diplôme. Pourtant, j''ai monté mon entreprise sans diplôme… »

Que montre le connecteur « Pourtant » dans ce passage ?', '[{"id":"a","text":"Une cause."},{"id":"b","text":"Une opposition entre l''idée courante et l''expérience de l''auteur."},{"id":"c","text":"Une conséquence logique."},{"id":"d","text":"Une simple addition d''idées."}]'::jsonb, 'b', '« Pourtant » oppose l''idée répandue (« il faut un diplôme ») au cas personnel de l''auteur (réussir sans diplôme) : c''est une opposition. Après ce connecteur se trouve justement le vrai point de vue de l''auteur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('892be656-b934-5bcb-8bc0-80275c81ee22', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis le courrier :
« Madame, Monsieur,
Je me permets de vous écrire pour signaler que la livraison de ma commande, prévue lundi, n''est toujours pas arrivée. Je souhaiterais connaître la date de réception ou, à défaut, obtenir un remboursement. »

Quelle est l''intention de l''auteur ?', '[{"id":"a","text":"Remercier le vendeur pour une livraison rapide."},{"id":"b","text":"Commander un nouveau produit."},{"id":"c","text":"Réclamer à propos d''une livraison en retard."},{"id":"d","text":"Recommander le magasin à des amis."}]'::jsonb, 'c', 'L''auteur signale une livraison « toujours pas arrivée » et demande une date ou un remboursement : il s''agit d''une réclamation. Il ne remercie pas, ne passe pas de nouvelle commande et ne recommande rien.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f6006e0-9460-50d6-b342-d2b3c9bbf6bc', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis le témoignage :
« Quand je suis arrivée en France, je ne parlais pas un mot de français. Les premiers mois ont été difficiles, mais aujourd''hui je travaille, j''ai des amis et je me sens chez moi. »

Quel est le point de vue de l''auteure sur son parcours ?', '[{"id":"a","text":"Entièrement négatif et plein de regrets."},{"id":"b","text":"Totalement indifférent à son installation."},{"id":"c","text":"Elle regrette d''être venue en France."},{"id":"d","text":"Globalement positif malgré des débuts difficiles."}]'::jsonb, 'd', 'Elle reconnaît des débuts « difficiles » mais conclut « je me sens chez moi » : son regard est globalement positif. Le connecteur « mais » fait basculer le propos vers une note positive, ce qui exclut les options négatives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70db6903-d420-5d03-bfae-11576caaba8b', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis l''extrait :
« Le maire affirme que la nouvelle taxe est nécessaire. Selon lui, elle financera les écoles. Mais de nombreux habitants estiment qu''elle est injuste pour les familles modestes. »

Dans ce texte, quelle phrase rapporte l''opinion DES HABITANTS ?', '[{"id":"a","text":"« Le maire affirme que la nouvelle taxe est nécessaire. »"},{"id":"b","text":"« La taxe financera les écoles » (présenté comme certain)."},{"id":"c","text":"« De nombreux habitants estiment qu''elle est injuste. »"},{"id":"d","text":"« Une nouvelle taxe a été créée. »"}]'::jsonb, 'c', 'Le verbe « estiment » et l''adjectif de jugement « injuste » signalent une opinion des habitants. La création de la taxe est un fait, et l''avis du maire est rapporté mais la question demande l''opinion exprimée par les habitants.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a8bb171-a6a1-50b5-a2b2-fcd8629142a2', '72739d9b-e4e4-5541-a3a7-07e7838f6b12', 'Lis la phrase :
« Le projet, d''abord jugé irréalisable, a finalement vu le jour grâce à la ténacité de l''équipe. »
Que signifie « irréalisable » ici ?', '[{"id":"a","text":"Impossible à réaliser."},{"id":"b","text":"Facile à terminer."},{"id":"c","text":"Déjà terminé."},{"id":"d","text":"Très rentable."}]'::jsonb, 'a', 'Le préfixe « ir- » indique la négation de « réalisable » : « irréalisable » veut dire impossible à réaliser. L''opposition avec « a finalement vu le jour grâce à la ténacité » confirme qu''on le croyait infaisable au départ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50be9f13-1a1d-5395-ab5b-b160fcc16637', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', '⚔️ Boss du chapitre ⭐⭐⭐ : la Porte des Textes', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30fae1e2-a2f8-5e92-9a44-7202fe5133a7', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis l''article de presse :
« Le télétravail, longtemps réservé à quelques cadres, s''est imposé dans de nombreuses entreprises. Ses partisans vantent un gain de temps et une meilleure qualité de vie. Mais certains spécialistes mettent en garde : travailler chez soi peut isoler les salariés et brouiller la frontière entre vie professionnelle et vie privée. »

Quelle est l''idée principale de l''article ?', '[{"id":"a","text":"Le télétravail présente des avantages mais aussi des risques."},{"id":"b","text":"Le télétravail est réservé aux cadres supérieurs."},{"id":"c","text":"Le télétravail va bientôt disparaître."},{"id":"d","text":"Le télétravail est interdit dans la plupart des entreprises."}]'::jsonb, 'a', 'L''article présente deux côtés : les partisans (gain de temps, qualité de vie) et les spécialistes inquiets (isolement, frontière brouillée). L''idée centrale est donc nuancée : avantages et risques. Le texte dit au contraire qu''il s''est répandu, et non qu''il disparaît ou est interdit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1266e06-5faa-5169-9c58-831e6b3f1e69', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis le même article :
« Mais certains spécialistes mettent en garde : travailler chez soi peut isoler les salariés et brouiller la frontière entre vie professionnelle et vie privée. »

Quel argument les spécialistes avancent-ils CONTRE le télétravail ?', '[{"id":"a","text":"Il fait perdre du temps de transport."},{"id":"b","text":"Il peut isoler les salariés et mélanger vie pro et vie privée."},{"id":"c","text":"Il coûte trop cher aux entreprises."},{"id":"d","text":"Il améliore toujours la qualité de vie."}]'::jsonb, 'b', 'Les spécialistes pointent l''isolement et la frontière brouillée entre vie professionnelle et privée : c''est leur argument négatif. Le gain de temps de transport et l''amélioration de la qualité de vie sont au contraire des arguments des partisans, et le coût n''est pas mentionné.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('269b79c9-17b2-5d7f-a77a-e581a11e62a7', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis la critique de film :
« Visuellement, le film est une réussite : les paysages sont à couper le souffle. Hélas, l''histoire avance trop lentement et certains personnages manquent cruellement d''épaisseur. On ressort de la salle ébloui mais un peu déçu. »

Quel est l''avis global de l''auteur sur le film ?', '[{"id":"a","text":"Entièrement enthousiaste, sans aucune réserve."},{"id":"b","text":"Totalement négatif, il déconseille le film."},{"id":"c","text":"Mitigé : il salue l''image mais regrette le scénario."},{"id":"d","text":"Neutre : il ne donne aucun jugement."}]'::jsonb, 'c', 'L''auteur loue les paysages (« réussite », « à couper le souffle ») mais critique l''histoire (« trop lentement », « manquent d''épaisseur ») et conclut « ébloui mais un peu déçu » : son avis est mitigé. Le connecteur « mais » et le mot « Hélas » écartent un avis purement positif, négatif ou neutre.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb34d288-9b7f-5478-9d12-6827df2e3d9d', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis le texte informatif :
« Selon une étude récente, les adolescents qui dorment moins de sept heures par nuit ont davantage de mal à se concentrer en classe. Les chercheurs recommandent de limiter les écrans le soir, car la lumière des téléphones retarde l''endormissement. »

D''après le texte, pourquoi les chercheurs conseillent-ils de limiter les écrans le soir ?', '[{"id":"a","text":"Parce que les téléphones coûtent cher."},{"id":"b","text":"Parce que la lumière des écrans retarde l''endormissement."},{"id":"c","text":"Parce que les écrans abîment les yeux."},{"id":"d","text":"Parce que les adolescents préfèrent lire."}]'::jsonb, 'b', 'Le connecteur de cause « car » introduit la raison : « la lumière des téléphones retarde l''endormissement ». Le prix, la vue et les préférences de lecture ne sont pas évoqués dans le texte ; il faut s''appuyer sur le texte seul.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcac38ec-586b-50af-a3dd-08a70b96c6ad', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis le témoignage :
« Depuis que j''ai déménagé en banlieue, je passe deux heures par jour dans les transports. Le soir, je rentre vidé, sans énergie pour voir mes amis. Parfois, je me demande si ce grand appartement valait vraiment ce sacrifice. »

Que peut-on INFÉRER de ce témoignage ?', '[{"id":"a","text":"L''auteur adore ses longs trajets quotidiens."},{"id":"b","text":"L''auteur va bientôt déménager à l''étranger."},{"id":"c","text":"L''auteur n''a pas d''amis."},{"id":"d","text":"L''auteur regrette en partie son déménagement."}]'::jsonb, 'd', '« Je me demande si ce grand appartement valait ce sacrifice » suggère un regret partiel : il doute de son choix. Le texte ne dit pas qu''il adore les trajets (il rentre « vidé »), ni qu''il part à l''étranger, ni qu''il n''a pas d''amis — il manque seulement d''énergie pour les voir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bbed3291-6143-58d0-9210-3d38148bb2e9', '50be9f13-1a1d-5395-ab5b-b160fcc16637', 'Lis la phrase :
« Le commerçant, d''ordinaire si affable, s''est montré ce jour-là sec et désagréable avec ses clients. »
Que signifie « affable » ici ?', '[{"id":"a","text":"Aimable et accueillant."},{"id":"b","text":"Pressé et nerveux."},{"id":"c","text":"Malhonnête."},{"id":"d","text":"Distrait."}]'::jsonb, 'a', 'L''opposition « d''ordinaire si affable » / « ce jour-là sec et désagréable » montre que « affable » est le contraire de « sec et désagréable » : cela signifie aimable et accueillant. Le piège courant est d''ignorer le contraste et de choisir un mot lui aussi négatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c5d876bc-5124-5e26-8384-ca4800ed534b', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', '👑 Défi élite ⭐⭐⭐⭐ : maître lecteur du DELF B1', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5d08bcc-9436-5f53-bf84-1b59710cdf12', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis le texte argumentatif :
« Faut-il interdire les téléphones au collège ? Les défenseurs de l''interdiction soulignent qu''elle réduit les distractions et le harcèlement en ligne. Les opposants répliquent qu''un téléphone peut servir d''outil pédagogique et qu''apprendre à s''en servir avec mesure est plus utile qu''une interdiction totale. À mes yeux, ce second argument mérite qu''on l''écoute. »

Quel est le point de vue personnel de l''auteur ?', '[{"id":"a","text":"Il penche plutôt contre l''interdiction totale."},{"id":"b","text":"Il est totalement favorable à l''interdiction."},{"id":"c","text":"Il refuse de donner son avis."},{"id":"d","text":"Il veut supprimer tous les téléphones en France."}]'::jsonb, 'a', 'Après avoir exposé les deux camps, l''auteur conclut « À mes yeux, ce second argument mérite qu''on l''écoute » : or le second argument est celui des opposants à l''interdiction. Il penche donc contre l''interdiction totale, sans pour autant la condamner radicalement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b4437b1-0480-5af0-a5b5-779f81013abf', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis le même texte :
« Les défenseurs de l''interdiction soulignent qu''elle réduit les distractions et le harcèlement en ligne. »

Quelle phrase est un FAIT présenté comme tel, et non une opinion, dans ce passage ?', '[{"id":"a","text":"« L''interdiction est la meilleure solution. »"},{"id":"b","text":"« Les téléphones doivent être supprimés. »"},{"id":"c","text":"« Le harcèlement en ligne n''existe pas. »"},{"id":"d","text":"Aucune : tout le passage rapporte des opinions de partisans."}]'::jsonb, 'd', 'Le passage ne fait que rapporter ce que « soulignent » les défenseurs : ce sont leurs opinions et arguments, pas un fait vérifiable affirmé par l''auteur. Les trois autres options sont des jugements ou des affirmations absentes du texte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dea1e869-0d4b-5edf-b02b-2d2cc50c91b6', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis la critique de restaurant :
« Le cadre est charmant et le personnel adorable, je n''ai rien à redire de ce côté. En revanche, pour des prix aussi élevés, on est en droit d''attendre des assiettes mieux garnies et des plats plus chauds. Dommage, car le potentiel est réel. »

Que reproche surtout l''auteur à ce restaurant ?', '[{"id":"a","text":"L''accueil du personnel, jugé désagréable."},{"id":"b","text":"Le rapport qualité-prix : trop cher pour ce qui est servi."},{"id":"c","text":"La décoration, qu''il trouve laide."},{"id":"d","text":"L''emplacement difficile d''accès."}]'::jsonb, 'b', 'Le connecteur d''opposition « En revanche » introduit le reproche : « pour des prix aussi élevés », il attendait « des assiettes mieux garnies et des plats plus chauds ». C''est donc le rapport qualité-prix. L''auteur loue au contraire le cadre (« charmant ») et le personnel (« adorable »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46d23004-c60c-52c2-9c71-30ef98227ec7', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis la lettre de motivation :
« Actuellement vendeur dans une grande enseigne, je souhaite donner un nouvel élan à ma carrière. Votre poste de responsable de rayon correspond exactement à mon projet : encadrer une équipe et relever des défis. Je serais ravi de vous exposer ma motivation lors d''un entretien. »

Que peut-on INFÉRER sur l''auteur de cette lettre ?', '[{"id":"a","text":"Il veut quitter complètement le secteur de la vente."},{"id":"b","text":"Il a déjà été refusé pour ce poste."},{"id":"c","text":"Il cherche une évolution professionnelle vers un poste à responsabilités."},{"id":"d","text":"Il démissionne sans avoir d''autre projet."}]'::jsonb, 'c', 'Il est déjà vendeur, veut « donner un nouvel élan » et vise un poste où « encadrer une équipe » : on infère une volonté d''évoluer vers des responsabilités. Il reste dans la vente (responsable de rayon), n''évoque aucun refus, et a clairement un projet précis.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('274e6979-e710-5e55-90a4-26654382709f', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis l''extrait :
« On présente souvent les jeux vidéo comme une perte de temps. Or, plusieurs études montrent qu''ils peuvent développer la rapidité de réaction et le travail en équipe. Bien sûr, tout est question de mesure : un excès reste néfaste. »

Comment l''auteur construit-il son raisonnement ?', '[{"id":"a","text":"Il défend l''idée que les jeux vidéo n''ont aucun intérêt."},{"id":"b","text":"Il affirme qu''on doit jouer autant que possible."},{"id":"c","text":"Il se contente de décrire une partie de jeu."},{"id":"d","text":"Il oppose un préjugé courant à des arguments nuancés en faveur des jeux vidéo."}]'::jsonb, 'd', 'Le connecteur « Or » oppose le préjugé (« perte de temps ») à des bénéfices prouvés (« rapidité de réaction », « travail en équipe »), puis « Bien sûr… un excès reste néfaste » nuance le propos. C''est donc une argumentation nuancée, ni un rejet total ni un éloge sans limite.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6cd4183-575d-5dbf-887d-775201a622c7', 'c5d876bc-5124-5e26-8384-ca4800ed534b', 'Lis la phrase :
« Loin d''être un luxe superflu, ces espaces verts sont devenus indispensables au bien-être des citadins. »
Que veut dire l''auteur avec « Loin d''être un luxe superflu » ?', '[{"id":"a","text":"Que les espaces verts ne sont pas un simple luxe inutile, mais une nécessité."},{"id":"b","text":"Que les espaces verts sont un luxe réservé aux riches."},{"id":"c","text":"Que les espaces verts sont trop éloignés du centre-ville."},{"id":"d","text":"Que les espaces verts coûtent beaucoup trop cher."}]'::jsonb, 'a', '« Loin d''être… » nie l''idée de luxe superflu, et la suite « sont devenus indispensables » la remplace par celle de nécessité. L''auteur affirme donc l''utilité vitale des espaces verts. Le piège est de lire « luxe » sans voir que « Loin d''être » le contredit.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('54c057a7-056d-5829-bc60-28e04703bba7', '87ebbe8e-0a5d-5e15-ac4f-bc58a773afa1', 'francais-b1', '⭐⭐ Drill : révision globale de la lecture', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59c1ecab-1250-55a7-8604-f9f3b60650f6', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis l''article :
« La lecture sur papier résiste mieux qu''on ne le pensait. Malgré l''essor des liseuses, la majorité des Français déclarent encore préférer tenir un vrai livre entre les mains, pour le plaisir du toucher et l''absence d''écran. »

Quelle est l''idée principale de l''article ?', '[{"id":"a","text":"Les liseuses ont fait disparaître le livre papier."},{"id":"b","text":"Beaucoup de Français préfèrent encore le livre papier."},{"id":"c","text":"Les Français ne lisent plus du tout."},{"id":"d","text":"Le papier est moins cher que les liseuses."}]'::jsonb, 'b', 'Le texte affirme que « la majorité des Français déclarent encore préférer tenir un vrai livre » : c''est l''idée centrale. Le connecteur « Malgré » montre que le papier résiste à la liseuse, ce qui contredit l''idée d''une disparition ; le prix n''est pas évoqué.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c45cf56-9514-5019-b22c-62a582529717', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis le message de forum :
« Bonjour ! Je pars étudier à Lyon en septembre et je cherche une colocation pas trop chère, proche du campus. Si quelqu''un a un plan ou un bon site à conseiller, je suis preneur. Merci d''avance ! »

Que cherche l''auteur du message ?', '[{"id":"a","text":"Un emploi à Lyon."},{"id":"b","text":"Une colocation près du campus."},{"id":"c","text":"Un cours de français."},{"id":"d","text":"Un billet de train."}]'::jsonb, 'b', 'L''auteur écrit « je cherche une colocation pas trop chère, proche du campus » : c''est sa demande. Il ne cherche ni emploi, ni cours, ni billet de train ; il faut s''en tenir à ce que dit le texte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0646374b-628d-5512-856b-8e813afffe76', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis l''avis :
« Service interminable, plats tièdes et addition salée : je ne remettrai pas les pieds dans ce café. »

Quel est le ton de cet avis ?', '[{"id":"a","text":"Positif"},{"id":"b","text":"Neutre"},{"id":"c","text":"Négatif"},{"id":"d","text":"Enthousiaste"}]'::jsonb, 'c', '« Interminable », « tièdes », « salée » et « je ne remettrai pas les pieds » sont des critiques nettes : le ton est négatif. Un ton positif ou enthousiaste emploierait des mots élogieux ; un ton neutre décrirait sans juger.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4884fd9-e82e-5f32-8626-32280b56d57b', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis le courriel :
« Bonjour,
Suite à votre demande, je vous confirme que l''atelier de poterie aura bien lieu samedi, mais l''horaire change : il commencera à 14 h au lieu de 10 h. Merci de votre compréhension. »

Quelle information l''auteur veut-il surtout transmettre ?', '[{"id":"a","text":"L''atelier est annulé."},{"id":"b","text":"Le lieu de l''atelier a changé."},{"id":"c","text":"L''atelier est complet."},{"id":"d","text":"L''horaire de l''atelier a changé."}]'::jsonb, 'd', 'Le courriel confirme que l''atelier « aura bien lieu » mais que « l''horaire change : il commencera à 14 h au lieu de 10 h » : l''essentiel est le changement d''heure. L''atelier n''est ni annulé ni complet, et le lieu n''est pas mentionné comme modifié.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aed198a4-5dc0-5a8b-8a34-ecc58cd3cdcf', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis le texte informatif :
« Trier ses déchets demande un petit effort, mais le geste compte : recycler une tonne de papier permet d''économiser des arbres et de l''eau. C''est pourquoi de plus en plus de communes facilitent le tri avec des bacs de couleur. »

Pourquoi les communes installent-elles des bacs de couleur ?', '[{"id":"a","text":"Pour décorer les rues."},{"id":"b","text":"Pour faciliter le tri des déchets."},{"id":"c","text":"Pour vendre du papier recyclé."},{"id":"d","text":"Pour interdire le recyclage."}]'::jsonb, 'b', 'Le connecteur de conséquence « C''est pourquoi » relie les bénéfices du tri à l''action des communes qui « facilitent le tri avec des bacs de couleur ». L''objectif est donc de faciliter le tri, non de décorer, de vendre ou d''interdire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22a135c2-754b-5a3d-9096-35a25c735c83', '54c057a7-056d-5829-bc60-28e04703bba7', 'Lis la phrase :
« Le sentier était tellement escarpé que même les marcheurs expérimentés devaient s''aider des mains pour grimper. »
Que signifie « escarpé » ici ?', '[{"id":"a","text":"Très pentu et difficile à gravir."},{"id":"b","text":"Tout plat et facile."},{"id":"c","text":"Très large."},{"id":"d","text":"Couvert de fleurs."}]'::jsonb, 'a', 'L''indice « devaient s''aider des mains pour grimper », même pour des marcheurs expérimentés, montre une forte pente : « escarpé » signifie très pentu et difficile à gravir. Un chemin plat ou large ne demanderait pas un tel effort.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

