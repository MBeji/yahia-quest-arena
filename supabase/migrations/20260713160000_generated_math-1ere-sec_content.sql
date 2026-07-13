-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-1ere-sec (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-1ere-sec/
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
  ('math-1ere-sec', 'Mathématiques', 'Géométrie (angles, Thalès, trigonométrie, vecteurs et translations, repère, quart de tour, sections planes), activités numériques et algébriques, fonctions linéaires et affines, équations, inéquations et systèmes du premier degré, et exploitation de l''information selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun)', 'Force', 'subject-math', 'Calculator', 1, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'))
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
      AND e.subject_id = 'math-1ere-sec'
      AND e.source = 'admin'
      AND q.id NOT IN ('d285fe0d-a649-59ec-9b9b-260fdfeeaf7b', 'e2413add-c559-5006-9763-b2e6c0ca9c89', '73a94e94-6f1f-5b60-a634-b25f85ed89f9', '6b37fb80-e700-5e9e-8e2e-f1a963e25b35', '9a7a2e73-214f-5f5d-8dad-a8d7919519a0', '670f4bd7-d3ef-5fe7-882c-3caab050f965', '77164441-8214-5d03-aa87-a8790339e0aa', 'e5ab50f1-deb8-55e5-8157-eddd648249d1', 'a8ceb12f-18af-5b44-8a64-aab661bcc934', '6346b5b1-c7a4-57fc-93a7-caea03adc76f', '18bc3295-0937-5961-b296-286a45588f48', '66b5185a-77fc-56b2-bb0c-35bb9da60c8e', '9e8ae2ad-e939-5769-8828-ae1efe8a344a', 'b5607ac8-472a-53ba-9772-b3464358dad7', 'f1abc7bc-5fc9-5b3c-a89a-e0d6e4fff9a0', 'a749ceb8-fb9e-5765-a105-7b1a04b6d50f', '637af2aa-fc0c-5f8e-808a-711d6626a480', '764a693e-3867-5b8a-ad9f-a42528c44dec', '216481af-765a-54ee-af1a-db4150a6eaa9', 'c4b28f7f-bd59-5ed6-becb-9ce4553dc584', '479c92f3-14d0-53ae-9e25-9a1bd0d1f89b', '77890e76-b136-5311-a899-e23395450742', 'd53aebe8-b1fa-5a8b-b4df-93fc9a0ec009', '18b8e0cd-b2a4-575d-95c9-acda7a27760c', '4a668275-6d7c-5465-9021-d137579e6cbf', 'f9c457a2-f786-506e-9305-2479a40da662', 'c005dd7f-adc0-5960-ad84-0a8799f68255', '17592f6d-4d2b-5a43-af4a-20fdbd30811b', '2dae05ea-9009-5914-894d-e75db10699f8', 'acf01e4b-a18c-56a9-b2ab-abdf02df8488', '5783b0b1-59a0-5c39-819f-5d423d584556', 'a918ddb6-255d-534d-ab95-903d4903d01a', '7f3a3309-5193-5bf2-befd-1e43093bc1c8', '1e58bb0d-50f8-5b28-bf82-89e9b7467512', 'd349fe65-986a-5603-ae50-e032deccd78f', '15aab741-a4ca-5292-a15d-7c77c9715783', '240a91a4-545d-55f7-8429-ff6c47d81db0', 'fb2e2b96-6a01-58fd-997f-155f9d682d54', '8c741e82-276f-550f-a42e-efc47a7739ed', '6bda0794-a768-5cad-b7bd-9f861eb5cc0b', '4d977cc2-0e48-55de-b3b5-bf4a0069a1e2', 'ae7e4c95-4ac8-56a7-be58-a32b77c3a037', '78524b2f-03dc-52a8-8325-121282a9fe9e', '62a5aab3-407b-5275-a4c8-6ea8418aeb32', '2852f4a1-2aca-5f72-8797-3d67c83130a6', '18b4ef50-4d0e-5ba3-b133-07dc1c374633', '39d071a2-6674-5bc6-b57f-71c8edb1ede7', '8a82afc1-9f54-5be0-bdb8-5341127e633c', '26308c5b-3f4e-5170-8c1f-e22c01c325a8', '50538a6c-151f-5a1c-b006-1d84127ae939', 'fd5e917d-d34a-51f6-bc8c-22136676df0b', '742071d9-aa0f-50a7-951c-40726423ef50', '18d2aa01-f0cd-5c5a-9df7-c1370f10dd67', '228794f1-d74f-542f-abd5-9b49cd74dabb', 'fbf64f7c-26c4-5098-bb0a-731f57ccccec', '4f04d64c-122e-543c-ad1d-75fe18e109c5', 'd5f421d1-b075-5b4e-9b56-2193091fbd3c', '01376b6b-6a85-5b32-a8cb-fa8f3c43ac89', 'e05154ac-3dd5-5807-9510-4795a06f21f5', '1edd73a8-150f-5640-aa84-693a23908f69', '1fd63e3b-6fd2-5d07-8ae7-f152f10b8104', '9d8cab86-ff23-50a6-b36e-a359c69e0aef', 'eeec4ca2-6208-5d70-aec9-acd383a59131', 'af104644-25ea-517f-aeae-6d94a5a56d30', '3b4077a7-368e-51ee-aec2-ebc68a5f0d9c', 'b3002d5c-00dc-50d8-a8bc-0ed261dd939b', '476256f9-5c92-571a-b0ec-d01eeec4597c', '22666f07-e576-5be3-a257-1573a241cd64', '2ca2c38a-5ff5-53d7-9994-b3ff34ad133e', '33221cb0-a805-5573-b991-c9431a4576e2', 'b175c9eb-b420-5e1d-8e75-a8774ea10d44', 'd9f51e02-2768-5102-8b02-a3c2779c9b43', 'e46cc4c7-87df-5f7b-933f-3bb575b89a14', '33016394-3d88-5ad2-bc29-03239777b857', 'ed3115a2-e9e9-5999-8963-35101d1bf8dc', '27711c10-1af9-511f-9533-ecd73048872a', 'bf8068e1-4471-5c24-941a-976cf5ce3b68', 'c70d130a-ba02-5b79-948a-109ca0cfce37', '9db2a14e-0fbc-55f6-bcca-ce462106d799', '677d5e6e-8a45-501b-8b29-f4a4f1891257', 'b5bc64a1-b3f5-5883-b72b-860cfe585b91', '6ed4ed97-c671-571c-9444-d2c580bc2aa8', '11fd6150-9df6-543e-8334-170cb5cd216a', '367d4b73-2761-56d7-8be6-3ccd492c2244', 'd5cdeb15-6dce-5b96-a6e0-eda23763767e', '8868eb25-bb2b-5764-81ab-8facf461a5a0', 'f269838f-7a4e-5049-89a9-e33c848ead90', '2073a87a-08c4-51b9-84ab-4353738ac3db', '99d2aab2-f3ac-544c-bfa7-0280f1a009b8', '94ea9de4-5a1d-55bc-b6c8-506162a1a36b', 'e002b3ad-cd95-524f-a9b2-7b2255e8a621', '9c778ad3-4947-5cab-acad-05729665f006', '46ad615f-db91-5e1f-93dc-4c42687cd422', 'b9d80c80-a783-5ce0-a71f-00b5e5ab70c1', '5d77dfc0-71c7-5c25-b693-b80357d531f1', '674c73c6-e3f5-5309-a1f7-acd479a161b8', 'c36cf64f-d5db-5158-adb8-4776dc98950e', 'f70277d2-76cb-52d5-9652-604e738e7fa7', 'aa687ed2-ffdf-52ab-a3ac-6bc7412f9739', '9b5b71db-2bfd-5ca1-bd9a-526951e76557', 'c02d34d7-6713-5543-88f8-9b83d1037227', '84cdb95a-2494-5e58-8315-137f2f7552a9', 'c8a7f195-2152-5df6-a7fa-78fd47bc2eb2', '0b4fb9de-dff3-50b8-9c9a-d2a649f53eae', '8e4b1ed1-39bb-5c64-93b8-78c571df145f', '46a5087a-d2a5-5806-9745-77f3b046fa90', '49a128c2-546e-5521-ae79-09874106d9bf', '286709c5-41a9-5c99-a45f-8ced04ee43c7', '986aaec2-89df-53c1-954f-3b8d43c94f57', 'c775c273-5cdf-5c3e-9ca8-6cf44bac3e8c', '9f0421fd-9208-575f-a532-50985239b86a', 'ad9ae393-fece-56b1-920e-a23392f6b9de', '0f7b998b-aae6-591d-9dc3-7a779cd710ab', 'b80c75f4-bacd-519c-a059-21520455ea76', 'e24d444d-47ab-52e2-a389-17e335bd27aa', '30437839-fe0e-5953-893b-585854a682a8', '00ce2958-8e89-502b-842d-b8bb8299673a', '4756e80b-e926-5ba2-81d6-1b378ef7ac40', 'ad16f6e7-ae46-5215-ac5b-99f225b0e42c', 'aa6213c8-10f9-5ea4-a33e-33511d9d29a0', '3ab5c907-5525-5ee6-ba92-df04d8ca0e10', '59ddf653-c38b-5161-a89b-ef94b5ddef50', 'ce96471a-eda7-598d-bec5-fcdccd386a4a', 'adcfa96e-c80f-53af-92a7-74faf541ff96', '483dfe19-e314-5468-943c-2e9627f99ceb', '22d2c6a5-5682-5684-bbb6-49acc0baf219', '224ea4e8-7dff-5049-a05d-31ccff326a46', 'bb398b1a-bd14-5a50-ba8d-0d01cb1da86a', 'a961ae21-9fa0-5ae9-bd47-2450c727dba7', 'c8e4c503-e45e-5742-aeb5-9b3d2058fe4d', 'f7bea53d-da26-5e42-992b-65f6079e9097', '01e2ea4a-93f7-5b1c-bf5b-4ebd9f16b3db', '4cc5d50a-4244-509f-8432-b971594732b3', 'ac8c77a1-f423-54a4-892a-9d40b7fa5017', '09359191-15b2-5e58-bde8-c115ab39447b', '996a51ad-89ac-5c87-8fac-ec8dd293e9cb', '3f8a9087-056d-58d3-b823-7ba16d6ae5ef', '032afe93-c3b1-5fb4-8147-c1bf7df17a41', '577a3c67-c6f0-5186-a2dd-90a967d4ee79', '1833c9c3-09b5-52e2-924c-9764de4e86eb', 'db219caa-7769-5566-bf42-642fac3a4a41', 'f89d6359-4968-5495-9c4a-53b10b7df4f2', '0083d91a-5fc8-588f-975c-26edfb84e067', '2ce298a6-42d4-5688-bb9e-664563e5ce54', 'ecadfc3c-a056-5641-a655-cbd4f4daf403', '00331306-6af8-5477-bd8d-45f77a4d0e41', 'ee301c39-b82d-57f5-bb8d-ef4fb5435ec5', 'f6f903c2-2617-5fe3-83e0-829d019425db', 'c7c04ff1-83e6-51c1-8001-7e9f2264c513', '3847c2bd-13d3-53d5-b5f5-6a4f758a31e8', '62a9623e-86b4-5684-a8e9-cac540a51382', 'e09cd78d-612a-5ad8-9801-e89bf3c28e11', 'efb19e18-975d-550e-9315-adf2ec378b96', '188309f2-54e0-5965-a039-d749c9c668af', 'ca595da3-332e-5c2e-91d8-7c8409d89490', '598cae69-0995-53f1-a831-03fc92bd0812', 'e652c04e-ac68-572e-9a3c-50e14550041a', '60b993bf-78de-555c-9df4-0c47c018b1cb', '40ba0e01-ef1a-52ff-a17c-40e8bc3a7086', '942235aa-fb71-55e8-93ed-27e0588118fd', '6ca24776-dd03-5a59-bf45-5f18d444804e', 'd0ec286d-bc9a-5317-b1c2-3ed263d469aa', '1254fe05-8c48-51b9-83d5-2458f824d733', '517eb5bc-b374-5d04-966c-3cd6793773cc', '27a68635-c1f7-5bc2-893a-af858331e4ee', 'b8207857-bd28-5baa-be12-b7f8aeb74284', '0aa1e83b-dbaa-5b99-9e23-fedc64c458f1', 'c6ca842f-1b5f-5d24-8956-9a1268db576b', 'a0323df0-83f9-5576-84d1-4155ead569cd', '2d3caf22-ee0c-58fd-bf15-41f89dd10556', '23645752-e1e3-59d9-b5fd-2ca96b038265', 'd5250847-4917-52ab-9747-98870e864923', 'b785be37-47be-5cfa-a0f2-b87025fa4cc8', '24b581ad-79a1-5d42-86e5-a2f2cfc96ae5', 'ba0009e9-a895-5741-8f04-64022268dad3', '5c23f250-246f-5616-ae33-5438dad37e9d', '2a3f56d3-7d08-5f4a-8ce9-e713ab18c103', 'f0ac8470-4434-5e56-a0ef-198f8a51401d', '84c84fe7-9b4d-5f4c-b1d0-6f91601009d9', '90674bc4-e1ba-5b96-8e51-7949b85800c0', '900e1f3d-b383-5a6a-b17b-14fa3dc5ed91', 'e4ab5255-6921-5c60-b136-1d8b683a21e8', '2d4d9ffe-a283-505f-967f-1c7dd098c0e1', '179e7bf9-6347-5a78-8ed8-50bc66f49ec5', 'c91d44db-58c3-5a95-83f7-afee7a84938a', '8b847db9-bbf4-51bd-8a89-8f6838a1cfbe', '241c3dec-94ed-5fd4-a196-5b293bbde5b2', 'd1dcd694-0694-58f3-9c0b-211c511c5e33', 'b72a0964-8574-5c7e-8acb-d18e91524a7d', 'e624b099-db58-5324-9f76-40014e97a401', '76710300-64e0-514d-b2cd-5e8f6c4704d7', '57351385-9921-56fd-812f-8221532c8e0e', '926fd80e-1217-594d-bc5f-7ba62e2a38f3', '28b322b5-0ea3-5655-a4d4-da2473ba9b8f', '18e609bc-3e67-5b34-b42d-0cb3a7989e0f', 'a770b159-1a4c-5670-8a10-20ac52eec227', '42935f78-7358-57ea-ab61-46b66d053ae8', '2fbe284a-4942-5fc1-9369-311327cc2d8a', 'dff291d9-c4ff-587e-959d-9b16d5041f2e', '4619fe42-7c85-512c-b019-b84aa1f9f487', 'e519388f-6a1e-5af9-a5b8-42d5dd039002', 'c652a375-c6a2-51dd-8696-a3b1e36d6b99', 'c7f7b30c-8442-5788-9872-b956358743a6', 'e6d6d9c0-f998-59f2-9c13-84755a45b1e0');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-1ere-sec' AND source = 'admin' AND id NOT IN ('d47dc4b0-b18d-51a7-aff1-fd797f002c14', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', '1b380fd3-7beb-5b66-91c9-d04639b46b13', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'e060ac07-2292-5773-ae64-5f97f3f81111', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', '20286657-c01d-5c5f-bffb-f190c619ca1d', '81f6607c-1e3f-5900-bd7d-5115262f428d', '94401368-add4-5917-8fd9-7efd83695dd3', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'd88ae6d1-2229-5595-abf1-d03108ea44b6');
DELETE FROM public.questions WHERE exercise_id IN ('d47dc4b0-b18d-51a7-aff1-fd797f002c14', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', '1b380fd3-7beb-5b66-91c9-d04639b46b13', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'e060ac07-2292-5773-ae64-5f97f3f81111', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', '20286657-c01d-5c5f-bffb-f190c619ca1d', '81f6607c-1e3f-5900-bd7d-5115262f428d', '94401368-add4-5917-8fd9-7efd83695dd3', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'd88ae6d1-2229-5595-abf1-d03108ea44b6') AND id NOT IN ('d285fe0d-a649-59ec-9b9b-260fdfeeaf7b', 'e2413add-c559-5006-9763-b2e6c0ca9c89', '73a94e94-6f1f-5b60-a634-b25f85ed89f9', '6b37fb80-e700-5e9e-8e2e-f1a963e25b35', '9a7a2e73-214f-5f5d-8dad-a8d7919519a0', '670f4bd7-d3ef-5fe7-882c-3caab050f965', '77164441-8214-5d03-aa87-a8790339e0aa', 'e5ab50f1-deb8-55e5-8157-eddd648249d1', 'a8ceb12f-18af-5b44-8a64-aab661bcc934', '6346b5b1-c7a4-57fc-93a7-caea03adc76f', '18bc3295-0937-5961-b296-286a45588f48', '66b5185a-77fc-56b2-bb0c-35bb9da60c8e', '9e8ae2ad-e939-5769-8828-ae1efe8a344a', 'b5607ac8-472a-53ba-9772-b3464358dad7', 'f1abc7bc-5fc9-5b3c-a89a-e0d6e4fff9a0', 'a749ceb8-fb9e-5765-a105-7b1a04b6d50f', '637af2aa-fc0c-5f8e-808a-711d6626a480', '764a693e-3867-5b8a-ad9f-a42528c44dec', '216481af-765a-54ee-af1a-db4150a6eaa9', 'c4b28f7f-bd59-5ed6-becb-9ce4553dc584', '479c92f3-14d0-53ae-9e25-9a1bd0d1f89b', '77890e76-b136-5311-a899-e23395450742', 'd53aebe8-b1fa-5a8b-b4df-93fc9a0ec009', '18b8e0cd-b2a4-575d-95c9-acda7a27760c', '4a668275-6d7c-5465-9021-d137579e6cbf', 'f9c457a2-f786-506e-9305-2479a40da662', 'c005dd7f-adc0-5960-ad84-0a8799f68255', '17592f6d-4d2b-5a43-af4a-20fdbd30811b', '2dae05ea-9009-5914-894d-e75db10699f8', 'acf01e4b-a18c-56a9-b2ab-abdf02df8488', '5783b0b1-59a0-5c39-819f-5d423d584556', 'a918ddb6-255d-534d-ab95-903d4903d01a', '7f3a3309-5193-5bf2-befd-1e43093bc1c8', '1e58bb0d-50f8-5b28-bf82-89e9b7467512', 'd349fe65-986a-5603-ae50-e032deccd78f', '15aab741-a4ca-5292-a15d-7c77c9715783', '240a91a4-545d-55f7-8429-ff6c47d81db0', 'fb2e2b96-6a01-58fd-997f-155f9d682d54', '8c741e82-276f-550f-a42e-efc47a7739ed', '6bda0794-a768-5cad-b7bd-9f861eb5cc0b', '4d977cc2-0e48-55de-b3b5-bf4a0069a1e2', 'ae7e4c95-4ac8-56a7-be58-a32b77c3a037', '78524b2f-03dc-52a8-8325-121282a9fe9e', '62a5aab3-407b-5275-a4c8-6ea8418aeb32', '2852f4a1-2aca-5f72-8797-3d67c83130a6', '18b4ef50-4d0e-5ba3-b133-07dc1c374633', '39d071a2-6674-5bc6-b57f-71c8edb1ede7', '8a82afc1-9f54-5be0-bdb8-5341127e633c', '26308c5b-3f4e-5170-8c1f-e22c01c325a8', '50538a6c-151f-5a1c-b006-1d84127ae939', 'fd5e917d-d34a-51f6-bc8c-22136676df0b', '742071d9-aa0f-50a7-951c-40726423ef50', '18d2aa01-f0cd-5c5a-9df7-c1370f10dd67', '228794f1-d74f-542f-abd5-9b49cd74dabb', 'fbf64f7c-26c4-5098-bb0a-731f57ccccec', '4f04d64c-122e-543c-ad1d-75fe18e109c5', 'd5f421d1-b075-5b4e-9b56-2193091fbd3c', '01376b6b-6a85-5b32-a8cb-fa8f3c43ac89', 'e05154ac-3dd5-5807-9510-4795a06f21f5', '1edd73a8-150f-5640-aa84-693a23908f69', '1fd63e3b-6fd2-5d07-8ae7-f152f10b8104', '9d8cab86-ff23-50a6-b36e-a359c69e0aef', 'eeec4ca2-6208-5d70-aec9-acd383a59131', 'af104644-25ea-517f-aeae-6d94a5a56d30', '3b4077a7-368e-51ee-aec2-ebc68a5f0d9c', 'b3002d5c-00dc-50d8-a8bc-0ed261dd939b', '476256f9-5c92-571a-b0ec-d01eeec4597c', '22666f07-e576-5be3-a257-1573a241cd64', '2ca2c38a-5ff5-53d7-9994-b3ff34ad133e', '33221cb0-a805-5573-b991-c9431a4576e2', 'b175c9eb-b420-5e1d-8e75-a8774ea10d44', 'd9f51e02-2768-5102-8b02-a3c2779c9b43', 'e46cc4c7-87df-5f7b-933f-3bb575b89a14', '33016394-3d88-5ad2-bc29-03239777b857', 'ed3115a2-e9e9-5999-8963-35101d1bf8dc', '27711c10-1af9-511f-9533-ecd73048872a', 'bf8068e1-4471-5c24-941a-976cf5ce3b68', 'c70d130a-ba02-5b79-948a-109ca0cfce37', '9db2a14e-0fbc-55f6-bcca-ce462106d799', '677d5e6e-8a45-501b-8b29-f4a4f1891257', 'b5bc64a1-b3f5-5883-b72b-860cfe585b91', '6ed4ed97-c671-571c-9444-d2c580bc2aa8', '11fd6150-9df6-543e-8334-170cb5cd216a', '367d4b73-2761-56d7-8be6-3ccd492c2244', 'd5cdeb15-6dce-5b96-a6e0-eda23763767e', '8868eb25-bb2b-5764-81ab-8facf461a5a0', 'f269838f-7a4e-5049-89a9-e33c848ead90', '2073a87a-08c4-51b9-84ab-4353738ac3db', '99d2aab2-f3ac-544c-bfa7-0280f1a009b8', '94ea9de4-5a1d-55bc-b6c8-506162a1a36b', 'e002b3ad-cd95-524f-a9b2-7b2255e8a621', '9c778ad3-4947-5cab-acad-05729665f006', '46ad615f-db91-5e1f-93dc-4c42687cd422', 'b9d80c80-a783-5ce0-a71f-00b5e5ab70c1', '5d77dfc0-71c7-5c25-b693-b80357d531f1', '674c73c6-e3f5-5309-a1f7-acd479a161b8', 'c36cf64f-d5db-5158-adb8-4776dc98950e', 'f70277d2-76cb-52d5-9652-604e738e7fa7', 'aa687ed2-ffdf-52ab-a3ac-6bc7412f9739', '9b5b71db-2bfd-5ca1-bd9a-526951e76557', 'c02d34d7-6713-5543-88f8-9b83d1037227', '84cdb95a-2494-5e58-8315-137f2f7552a9', 'c8a7f195-2152-5df6-a7fa-78fd47bc2eb2', '0b4fb9de-dff3-50b8-9c9a-d2a649f53eae', '8e4b1ed1-39bb-5c64-93b8-78c571df145f', '46a5087a-d2a5-5806-9745-77f3b046fa90', '49a128c2-546e-5521-ae79-09874106d9bf', '286709c5-41a9-5c99-a45f-8ced04ee43c7', '986aaec2-89df-53c1-954f-3b8d43c94f57', 'c775c273-5cdf-5c3e-9ca8-6cf44bac3e8c', '9f0421fd-9208-575f-a532-50985239b86a', 'ad9ae393-fece-56b1-920e-a23392f6b9de', '0f7b998b-aae6-591d-9dc3-7a779cd710ab', 'b80c75f4-bacd-519c-a059-21520455ea76', 'e24d444d-47ab-52e2-a389-17e335bd27aa', '30437839-fe0e-5953-893b-585854a682a8', '00ce2958-8e89-502b-842d-b8bb8299673a', '4756e80b-e926-5ba2-81d6-1b378ef7ac40', 'ad16f6e7-ae46-5215-ac5b-99f225b0e42c', 'aa6213c8-10f9-5ea4-a33e-33511d9d29a0', '3ab5c907-5525-5ee6-ba92-df04d8ca0e10', '59ddf653-c38b-5161-a89b-ef94b5ddef50', 'ce96471a-eda7-598d-bec5-fcdccd386a4a', 'adcfa96e-c80f-53af-92a7-74faf541ff96', '483dfe19-e314-5468-943c-2e9627f99ceb', '22d2c6a5-5682-5684-bbb6-49acc0baf219', '224ea4e8-7dff-5049-a05d-31ccff326a46', 'bb398b1a-bd14-5a50-ba8d-0d01cb1da86a', 'a961ae21-9fa0-5ae9-bd47-2450c727dba7', 'c8e4c503-e45e-5742-aeb5-9b3d2058fe4d', 'f7bea53d-da26-5e42-992b-65f6079e9097', '01e2ea4a-93f7-5b1c-bf5b-4ebd9f16b3db', '4cc5d50a-4244-509f-8432-b971594732b3', 'ac8c77a1-f423-54a4-892a-9d40b7fa5017', '09359191-15b2-5e58-bde8-c115ab39447b', '996a51ad-89ac-5c87-8fac-ec8dd293e9cb', '3f8a9087-056d-58d3-b823-7ba16d6ae5ef', '032afe93-c3b1-5fb4-8147-c1bf7df17a41', '577a3c67-c6f0-5186-a2dd-90a967d4ee79', '1833c9c3-09b5-52e2-924c-9764de4e86eb', 'db219caa-7769-5566-bf42-642fac3a4a41', 'f89d6359-4968-5495-9c4a-53b10b7df4f2', '0083d91a-5fc8-588f-975c-26edfb84e067', '2ce298a6-42d4-5688-bb9e-664563e5ce54', 'ecadfc3c-a056-5641-a655-cbd4f4daf403', '00331306-6af8-5477-bd8d-45f77a4d0e41', 'ee301c39-b82d-57f5-bb8d-ef4fb5435ec5', 'f6f903c2-2617-5fe3-83e0-829d019425db', 'c7c04ff1-83e6-51c1-8001-7e9f2264c513', '3847c2bd-13d3-53d5-b5f5-6a4f758a31e8', '62a9623e-86b4-5684-a8e9-cac540a51382', 'e09cd78d-612a-5ad8-9801-e89bf3c28e11', 'efb19e18-975d-550e-9315-adf2ec378b96', '188309f2-54e0-5965-a039-d749c9c668af', 'ca595da3-332e-5c2e-91d8-7c8409d89490', '598cae69-0995-53f1-a831-03fc92bd0812', 'e652c04e-ac68-572e-9a3c-50e14550041a', '60b993bf-78de-555c-9df4-0c47c018b1cb', '40ba0e01-ef1a-52ff-a17c-40e8bc3a7086', '942235aa-fb71-55e8-93ed-27e0588118fd', '6ca24776-dd03-5a59-bf45-5f18d444804e', 'd0ec286d-bc9a-5317-b1c2-3ed263d469aa', '1254fe05-8c48-51b9-83d5-2458f824d733', '517eb5bc-b374-5d04-966c-3cd6793773cc', '27a68635-c1f7-5bc2-893a-af858331e4ee', 'b8207857-bd28-5baa-be12-b7f8aeb74284', '0aa1e83b-dbaa-5b99-9e23-fedc64c458f1', 'c6ca842f-1b5f-5d24-8956-9a1268db576b', 'a0323df0-83f9-5576-84d1-4155ead569cd', '2d3caf22-ee0c-58fd-bf15-41f89dd10556', '23645752-e1e3-59d9-b5fd-2ca96b038265', 'd5250847-4917-52ab-9747-98870e864923', 'b785be37-47be-5cfa-a0f2-b87025fa4cc8', '24b581ad-79a1-5d42-86e5-a2f2cfc96ae5', 'ba0009e9-a895-5741-8f04-64022268dad3', '5c23f250-246f-5616-ae33-5438dad37e9d', '2a3f56d3-7d08-5f4a-8ce9-e713ab18c103', 'f0ac8470-4434-5e56-a0ef-198f8a51401d', '84c84fe7-9b4d-5f4c-b1d0-6f91601009d9', '90674bc4-e1ba-5b96-8e51-7949b85800c0', '900e1f3d-b383-5a6a-b17b-14fa3dc5ed91', 'e4ab5255-6921-5c60-b136-1d8b683a21e8', '2d4d9ffe-a283-505f-967f-1c7dd098c0e1', '179e7bf9-6347-5a78-8ed8-50bc66f49ec5', 'c91d44db-58c3-5a95-83f7-afee7a84938a', '8b847db9-bbf4-51bd-8a89-8f6838a1cfbe', '241c3dec-94ed-5fd4-a196-5b293bbde5b2', 'd1dcd694-0694-58f3-9c0b-211c511c5e33', 'b72a0964-8574-5c7e-8acb-d18e91524a7d', 'e624b099-db58-5324-9f76-40014e97a401', '76710300-64e0-514d-b2cd-5e8f6c4704d7', '57351385-9921-56fd-812f-8221532c8e0e', '926fd80e-1217-594d-bc5f-7ba62e2a38f3', '28b322b5-0ea3-5655-a4d4-da2473ba9b8f', '18e609bc-3e67-5b34-b42d-0cb3a7989e0f', 'a770b159-1a4c-5670-8a10-20ac52eec227', '42935f78-7358-57ea-ab61-46b66d053ae8', '2fbe284a-4942-5fc1-9369-311327cc2d8a', 'dff291d9-c4ff-587e-959d-9b16d5041f2e', '4619fe42-7c85-512c-b019-b84aa1f9f487', 'e519388f-6a1e-5af9-a5b8-42d5dd039002', 'c652a375-c6a2-51dd-8696-a3b1e36d6b99', 'c7f7b30c-8442-5788-9872-b956358743a6', 'e6d6d9c0-f998-59f2-9c13-84755a45b1e0');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-1ere-sec' AND c.id NOT IN ('15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', '1d85914e-62d3-50ce-943e-1b77a49bb180', '7c588ba8-cc30-53da-8702-cd8365c0c879', '911d2611-f232-5e69-b326-4d2b66501742', 'e7fa1c08-f6c0-5b4b-a040-b410d4b0b033', '947437c3-de15-51ca-b0a8-7b0fff092953', '8f37a3b1-c4ff-566b-9985-c7c2d877a56c', 'c65b31e6-7328-5bac-96d5-9410d68d33e8', '8bea7605-27a1-597f-a6ed-f483ba0da928', '80e3789e-822b-542b-939e-bc2ba9538004', 'f2fe4a9f-f282-5ef2-915c-e5828a361fb7', '0a439078-2174-532b-9cc2-aaf496763a2a') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', 'math-1ere-sec', 'Angles — droites parallèles et cercle', 'Somme des angles et angle extérieur d''un triangle, angles formés par une sécante avec deux droites parallèles (correspondants, alternes-internes, intérieurs d''un même côté) et les critères directs et réciproques de parallélisme, angle inscrit et angle au centre associés à un même arc, triangle rectangle inscrit dans un demi-cercle et lieu des points voyant un segment sous un angle droit, tangentes à un cercle issues d''un point', '# ⚔️ Angles — droites parallèles et cercle

> 💡 «Un angle bien lu, c''est une droite qui se trahit ou un cercle qui se dévoile. Apprends à faire parler les angles, et la figure n''aura plus de secret.»

Bienvenue en 1ère année secondaire, héros. Tu connais déjà les angles aigus, obtus, la bissectrice et les angles supplémentaires. Dans cette quête, tu apprends à t''en servir comme d''outils de preuve : montrer que deux droites sont parallèles, calculer un angle inconnu dans un cercle, prouver qu''un triangle est rectangle. C''est le socle de toute la géométrie de l''année.

## 🔺 Somme des angles et angle extérieur d''un triangle

Dans **tout triangle**, la somme des trois angles vaut **180°** :

$$ BAC + ABC + ACB = 180° $$

Un **angle extérieur** d''un triangle est l''angle formé par un côté et le prolongement d''un autre côté. Propriété clé :

> Un angle extérieur d''un triangle est égal à la **somme des deux angles intérieurs qui ne lui sont pas adjacents**.

_Exemple détaillé_ : dans le triangle ABC, on prolonge [BC] au-delà de C jusqu''à un point D. Si BAC = 60° et ABC = 50°, alors l''angle extérieur ACD = 60° + 50° = **110°**. Vérification : l''angle intérieur ACB = 180° − 110° = 70°, et 60° + 50° + 70° = 180° ✓.

> 🗡️ L''angle extérieur et l''angle intérieur au même sommet sont **supplémentaires** (leur somme fait 180°) : c''est une deuxième façon rapide de trouver l''un à partir de l''autre.

## ↔️ Angles, sécante et droites parallèles

Une **sécante** coupe deux droites en deux points. Elle y forme des paires d''angles : **correspondants**, **alternes-internes**, et **intérieurs d''un même côté**. Quand les deux droites sont **parallèles** :

- deux angles **alternes-internes** sont **égaux** ;
- deux angles **correspondants** sont **égaux** ;
- deux angles **intérieurs d''un même côté** sont **supplémentaires** (somme = 180°).

_Exemple détaillé_ : deux droites parallèles (d) et (d'') coupées par une sécante. Un angle mesure 65°. Son alterne-interne mesure aussi 65° ; son correspondant mesure 65° ; l''angle intérieur du même côté mesure 180° − 65° = 115°.

## 🔁 Reconnaître deux droites parallèles

Les propriétés ci-dessus ont une **réciproque** — c''est elle qui sert à **démontrer** un parallélisme :

> Si deux droites coupées par une sécante forment deux angles **alternes-internes égaux** (ou deux angles **correspondants égaux**, ou deux angles **intérieurs d''un même côté supplémentaires**), alors ces deux droites sont **parallèles**.

_Exemple détaillé_ : une sécante coupe (AB) et (CD). Les angles alternes-internes mesurent 48° et 48°. Comme ils sont égaux, on conclut : **(AB) // (CD)**.

> ⚠️ Piège classique : la propriété directe part du parallélisme pour donner l''égalité des angles ; la réciproque part de l''égalité des angles pour donner le parallélisme. Ne mélange pas le sens de la flèche.

## ⭕ Angle inscrit et angle au centre

Sur un cercle de centre O :

- un **angle inscrit** a son **sommet sur le cercle** et ses deux côtés recoupent le cercle ; il **intercepte** l''arc situé entre ses côtés ;
- un **angle au centre** a son **sommet en O**.

Propriété fondamentale, quand les deux angles interceptent le **même arc** :

$$ angle au centre = 2 × angle inscrit $$

Autrement dit, un angle inscrit est égal à la **moitié** de l''angle au centre qui intercepte le même arc.

_Exemple détaillé_ : A, B, M sont sur un cercle de centre O. L''angle au centre AOB = 100°. L''angle inscrit AMB, qui intercepte le même arc [AB], vaut donc 100° / 2 = **50°**.

> 🗡️ Conséquence directe : **deux angles inscrits qui interceptent le même arc sont égaux** (ils valent tous la moitié du même angle au centre). Très utile pour transporter une mesure d''un point à un autre du cercle.

> ⚠️ L''angle inscrit vaut la **moitié**, pas le double, de l''angle au centre — et les deux doivent intercepter **le même arc**. Deux angles inscrits sur des arcs différents n''ont aucune raison d''être égaux.

## 📐 Triangle rectangle inscrit dans un demi-cercle

Cas particulier capital : lorsque l''arc intercepté est un **demi-cercle**, l''angle au centre est un angle plat (180°), donc l''angle inscrit vaut 180° / 2 = 90°. D''où :

> Si l''un des côtés d''un triangle est un **diamètre** de son cercle circonscrit, alors ce triangle est **rectangle**, et l''angle droit est au sommet opposé à ce diamètre.

Réciproquement, on décrit ainsi un **lieu géométrique** : pour deux points fixes A et B, l''ensemble des points P tels que **APB = 90°** est le **cercle de diamètre [AB]** (privé de A et de B).

_Exemple détaillé_ : [BC] est un diamètre du cercle circonscrit au triangle ABC. Alors BAC = 90°. Si de plus ABC = 35°, on obtient ACB = 180° − 90° − 35° = **55°**.

> 🗡️ Application : les **tangentes** à un cercle de centre O menées depuis un point extérieur A touchent le cercle en des points T tels que OTA = 90° (le rayon est perpendiculaire à la tangente). Ces points de contact sont donc sur le cercle de diamètre [OA] — ce qui donne une construction au compas des tangentes.

> 🏆 Première quête franchie, héros : tu sais calculer un angle inconnu, prouver un parallélisme et débusquer un angle droit caché dans un cercle. Ces armes serviront dès le prochain chapitre, avec le théorème de Thalès.', '# 📜 Résumé : Angles — droites parallèles et cercle

- **Somme des angles d''un triangle** : BAC + ABC + ACB = 180°. **Angle extérieur** = somme des deux angles intérieurs non adjacents ; il est supplémentaire de l''angle intérieur au même sommet.
- **Deux parallèles + une sécante** : angles alternes-internes **égaux**, angles correspondants **égaux**, angles intérieurs d''un même côté **supplémentaires** (somme 180°).
- **Réciproques (pour démontrer un parallélisme)** : si une sécante forme des alternes-internes égaux, ou des correspondants égaux, ou des intérieurs d''un même côté supplémentaires, alors les deux droites sont parallèles.
- **Angle inscrit / angle au centre** (même arc) : angle au centre = 2 × angle inscrit, donc angle inscrit = moitié de l''angle au centre. **Deux angles inscrits interceptant le même arc sont égaux.**
- **Triangle rectangle et demi-cercle** : un côté diamètre du cercle circonscrit ⇒ triangle rectangle au sommet opposé. Le lieu des points P tels que APB = 90° est le cercle de diamètre [AB] (privé de A et B) ; les points de contact des tangentes issues de A sont sur le cercle de diamètre [OA].', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('1d85914e-62d3-50ce-943e-1b77a49bb180', 'math-1ere-sec', 'Théorème de Thalès et sa réciproque', 'Droite des milieux dans un triangle et son énoncé réciproque, théorème de Thalès dans un triangle (deux droites sécantes coupées par deux parallèles, égalité des trois rapports de longueurs), réciproque du théorème de Thalès pour démontrer un parallélisme, agrandissement et réduction (échelle k : longueurs et périmètre ×k, aires ×k²), constructions associées (partage d''un segment dans une proportion, quatrième proportionnelle)', '# ⚔️ Théorème de Thalès et sa réciproque

> 💡 «Deux parallèles qui traversent un angle y découpent des longueurs proportionnelles. Cette seule idée mesure la hauteur d''un arbre, la taille de la Lune, et bien plus.»

Tu sais déjà, depuis le collège, que la droite des milieux d''un triangle est parallèle au troisième côté. Le théorème de Thalès en est la version générale : il relie par des **rapports égaux** les longueurs découpées par deux parallèles. Sa réciproque, elle, sert à **démontrer** qu''on a bien deux droites parallèles. C''est l''outil roi de la géométrie proportionnelle.

## 📏 La droite des milieux

Point de départ, à connaître par cœur :

> Dans un triangle, la droite qui joint les **milieux de deux côtés** est **parallèle au troisième côté** (et la longueur qu''elle porte en vaut la moitié).

Et sa réciproque :

> Dans un triangle, la droite qui passe par le **milieu d''un côté** et qui est **parallèle à un deuxième côté** coupe le **troisième côté en son milieu**.

_Exemple détaillé_ : dans le triangle ABC, I est le milieu de [AB] et J le milieu de [AC]. Alors (IJ) // (BC) et IJ = BC / 2. Si BC = 8 cm, alors IJ = 4 cm.

## 🔺 Le théorème de Thalès dans un triangle

On généralise : les points ne sont plus forcément des milieux.

> Soient deux droites (AB) et (AC) sécantes en A, un point M de (AB) et un point N de (AC). **Si (MN) et (BC) sont parallèles**, alors :

$$ AM/AB = AN/AC = MN/BC $$

Les trois rapports sont égaux : ils portent le **même coefficient**, qui compare la petite figure à la grande.

_Exemple détaillé_ : dans le triangle ABC, M est sur [AB] et N sur [AC] avec (MN) // (BC). On donne AB = 6 cm, AM = 4 cm et BC = 9 cm. Le coefficient est AM/AB = 4/6 = 2/3. Donc MN = BC × 2/3 = 9 × 2/3 = **6 cm**, et de même AN = AC × 2/3.

> 🗡️ Méthode sûre : écris d''abord la chaîne des trois rapports **dans le même ordre** (sommet A en haut de chaque fraction : AM/AB, AN/AC, MN/BC), puis remplace ce que tu connais. Tu évites ainsi d''inverser un rapport.

## 🔁 La réciproque du théorème de Thalès

C''est le sens inverse : de l''égalité des rapports, on **déduit** le parallélisme.

> Soient deux droites (AB) et (AC) sécantes en A, M un point de (AB) et N un point de (AC). **Si AM/AB = AN/AC** (les points M et N étant placés dans le même ordre à partir de A), **alors (MN) et (BC) sont parallèles**.

_Exemple détaillé_ : dans le triangle ABC, AB = 6, AM = 4, AC = 7,5 et AN = 5. On compare : AM/AB = 4/6 = 2/3 et AN/AC = 5/7,5 = 2/3. Les deux rapports sont égaux, donc **(MN) // (BC)**.

> ⚠️ La réciproque n''est valable que si M et N sont placés **dans le même ordre** par rapport à A (les deux du même côté, ou les deux de l''autre côté). Si l''un est « au-delà » de A et l''autre non, l''égalité des rapports ne suffit plus : vérifie toujours la disposition des points sur la figure.

## 🔍 Agrandissement, réduction et échelle

Multiplier toutes les longueurs d''une figure par un même nombre **k > 0** donne une figure de même forme : un **agrandissement** si k > 1, une **réduction** si k < 1. Le nombre k est l''**échelle**. Effet de l''échelle :

| grandeur  | est multipliée par |
| --------- | ------------------ |
| longueurs | k                  |
| périmètre | k                  |
| **aire**  | **k²**             |

_Exemple détaillé_ : on agrandit un triangle d''aire 5 cm² à l''échelle k = 3. Les longueurs triplent, le périmètre triple, mais l''aire est multipliée par k² = 9 : la nouvelle aire vaut 5 × 9 = **45 cm²**.

> ⚠️ L''erreur la plus fréquente : multiplier l''aire par k au lieu de k². Une échelle 2 double les longueurs mais **quadruple** l''aire.

## 🛠️ Construire et partager grâce à Thalès

Le théorème sert aussi à **construire** :

- **Partager un segment dans une proportion donnée** : pour placer M sur [AB] tel que AM = (2/5)AB, on trace une demi-droite issue de A, on y reporte 5 segments isométriques, on joint le 5ᵉ point à B, et les parallèles à cette droite découpent [AB] en 5 parts égales — M est au 2ᵉ point.
- **Quatrième proportionnelle** : construire une longueur d inconnue vérifiant une égalité de rapports comme a/b = c/d se fait par la même configuration de deux droites et deux parallèles.

_Exemple détaillé_ : pour placer M tel que AM/MB = 3/2, on partage [AB] en 3 + 2 = 5 parts égales par la méthode ci-dessus, et M tombe après la 3ᵉ part.

> 🏆 Deuxième quête franchie, héros : tu manies les rapports de Thalès dans les deux sens et tu sais qu''une aire se dilate en k². Ces proportions te suivront jusqu''à la trigonométrie du prochain chapitre.', '# 📜 Résumé : Théorème de Thalès et sa réciproque

- **Droite des milieux** : la droite joignant les milieux de deux côtés d''un triangle est parallèle au troisième côté et en vaut la moitié ; réciproquement, la parallèle à un côté passant par le milieu d''un autre coupe le troisième en son milieu.
- **Théorème de Thalès** : (AB) et (AC) sécantes en A, M sur (AB), N sur (AC) ; si (MN) // (BC) alors AM/AB = AN/AC = MN/BC (les trois rapports sont égaux).
- **Réciproque de Thalès** : si AM/AB = AN/AC, avec M et N placés dans le même ordre à partir de A, alors (MN) // (BC) — c''est l''outil pour démontrer un parallélisme.
- **Agrandissement / réduction (échelle k)** : longueurs ×k, périmètre ×k, **aire ×k²** ; agrandissement si k > 1, réduction si k < 1.
- **Constructions** : partager un segment dans une proportion donnée (reporter des segments isométriques + parallèles) et construire une quatrième proportionnelle reposent sur la même configuration de Thalès.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('7c588ba8-cc30-53da-8702-cd8365c0c879', 'math-1ere-sec', 'Rapports trigonométriques et relations métriques', 'Cosinus, sinus et tangente d''un angle aigu dans un triangle rectangle (rapports de longueurs), relations trigonométriques (sin²+cos²=1, tan=sin/cos, angles complémentaires), valeurs remarquables 30°/45°/60°, usage de la calculatrice pour trouver un angle ou une longueur, et relations métriques dans le triangle rectangle (théorème de Pythagore, produit des côtés = hauteur × hypoténuse, relations de la hauteur et des projections)', '# ⚔️ Rapports trigonométriques et relations métriques

> 💡 «Avec un seul angle et une seule longueur, la trigonométrie reconstruit tout le triangle rectangle. C''est l''art de mesurer l''inaccessible : la hauteur d''un immeuble, la pente d''une route, la distance d''un astre.»

Dans un triangle rectangle, les côtés et les angles ne sont pas indépendants : ils sont liés par trois rapports, le **cosinus**, le **sinus** et la **tangente**. Ce chapitre te donne ces outils, leurs valeurs remarquables, et les **relations métriques** qui complètent le théorème de Pythagore. Tu pourras alors résoudre un triangle rectangle presque les yeux fermés.

## 📐 Cosinus, sinus et tangente d''un angle aigu

On se place dans un triangle **ABC rectangle en A**. Pour l''angle aigu en B, on distingue : le côté **adjacent** [AB], le côté **opposé** [AC], et l''**hypoténuse** [BC] (face à l''angle droit). On définit :

$$ cos B = adjacent / hypoténuse = AB/BC $$
$$ sin B = opposé / hypoténuse = AC/BC $$
$$ tan B = opposé / adjacent = AC/AB $$

_Exemple détaillé_ : dans un triangle rectangle où l''adjacent à B vaut 3 cm et l''hypoténuse 5 cm, cos B = 3/5 = 0,6. Si l''opposé vaut 4 cm, alors sin B = 4/5 = 0,8 et tan B = 4/3.

> 🗡️ Moyen mnémotechnique : **CAH – SOH – TOA** (Cosinus = Adjacent/Hypoténuse, Sinus = Opposé/Hypoténuse, Tangente = Opposé/Adjacent). Adjacent et opposé changent selon l''angle aigu choisi ; l''hypoténuse, elle, ne bouge jamais.

## 🧮 Trouver une longueur ou un angle

Ces rapports permettent, connaissant un angle et un côté, de **calculer** un autre côté ; et connaissant deux côtés, de **retrouver** l''angle (avec la calculatrice en mode **DEG**, touches sin/cos/tan, et leurs fonctions inverses).

_Exemple détaillé (longueur)_ : dans un triangle rectangle en A, l''hypoténuse BC = 10 cm et l''angle B = 60°. Alors AB = BC × cos 60° = 10 × 0,5 = **5 cm**.

_Exemple détaillé (angle)_ : si cos B = 0,6, la calculatrice donne B ≈ 53,13°, soit environ **53,1°** au dixième près.

## 🔗 Relations entre cosinus, sinus et tangente

Pour tout angle aigu a, les trois rapports sont reliés :

$$ tan a = sin a / cos a $$
$$ (sin a)² + (cos a)² = 1 $$

De plus, dans un triangle rectangle en A, les angles B et C sont **complémentaires** (B + C = 90°). D''où :

> Si deux angles sont complémentaires, le **sinus de l''un est égal au cosinus de l''autre** : sin B = cos C et cos B = sin C.

_Exemple détaillé_ : si cos a = 3/5, alors (sin a)² = 1 − (3/5)² = 1 − 9/25 = 16/25, donc sin a = 4/5 (positif car a est aigu). On vérifie : (3/5)² + (4/5)² = 9/25 + 16/25 = 1 ✓.

> ⚠️ Le cosinus et le sinus d''un angle aigu sont toujours **compris entre 0 et 1** (ce sont des rapports d''un côté à l''hypoténuse, plus grande). Une valeur de sinus égale à 1,3 est donc forcément une erreur.

## ⭐ Les angles remarquables 30°, 45°, 60°

Ces trois angles ont des valeurs exactes à connaître par cœur :

| angle | sin  | cos  | tan  |
| ----- | ---- | ---- | ---- |
| 30°   | 1/2  | √3/2 | √3/3 |
| 45°   | √2/2 | √2/2 | 1    |
| 60°   | √3/2 | 1/2  | √3   |

_Exemple détaillé_ : dans un triangle rectangle en A, si l''angle B = 30° et BC = 8 cm, alors AC = BC × sin 30° = 8 × 1/2 = **4 cm**.

> 🗡️ Remarque cohérente avec la complémentarité : 30° et 60° sont complémentaires, et l''on retrouve bien sin 30° = cos 60° = 1/2, ainsi que sin 60° = cos 30° = √3/2.

## 📏 Relations métriques dans le triangle rectangle

Soit ABC **rectangle en A** et H le **pied de la hauteur** issue de A sur l''hypoténuse [BC]. Alors :

$$ AB² + AC² = BC² $$
$$ AB × AC = AH × BC $$
$$ AH² = HB × HC $$
$$ AB² = BH × BC $$

La première est le **théorème de Pythagore**. La deuxième traduit l''aire calculée de deux façons. Les deux dernières relient la hauteur et les projections des côtés sur l''hypoténuse (de même, AC² = CH × CB).

_Exemple détaillé_ : ABC rectangle en A avec AB = 6 et AC = 8. Par Pythagore, BC = √(6² + 8²) = √100 = 10. La hauteur vaut AH = AB × AC / BC = 6 × 8 / 10 = **4,8**. La projection BH = AB² / BC = 36 / 10 = **3,6**.

> 🏆 Troisième quête franchie, héros : tu résous n''importe quel triangle rectangle, angle ou côté, et tu maîtrises les relations métriques qui prolongent Pythagore. Change de terrain : le prochain chapitre t''initie aux vecteurs et aux translations.', '# 📜 Résumé : Rapports trigonométriques et relations métriques

- **Définitions (triangle rectangle en A, angle en B)** : cos B = AB/BC (adjacent/hypoténuse), sin B = AC/BC (opposé/hypoténuse), tan B = AC/AB (opposé/adjacent) — mémo CAH-SOH-TOA.
- **Résoudre un triangle rectangle** : connaissant un angle et un côté, on calcule un autre côté (côté = hypoténuse × cos ou sin) ; connaissant deux côtés, la calculatrice (mode DEG, fonctions inverses) rend l''angle.
- **Relations trigonométriques** : tan a = sin a / cos a ; (sin a)² + (cos a)² = 1 ; angles complémentaires ⇒ sin de l''un = cos de l''autre. Pour un angle aigu, 0 < cos a < 1 et 0 < sin a < 1.
- **Angles remarquables** : sin 30° = 1/2, sin 45° = √2/2, sin 60° = √3/2 ; cos 30° = √3/2, cos 45° = √2/2, cos 60° = 1/2 ; tan 30° = √3/3, tan 45° = 1, tan 60° = √3.
- **Relations métriques (rectangle en A, H pied de la hauteur issue de A)** : AB² + AC² = BC² (Pythagore) ; AB × AC = AH × BC ; AH² = HB × HC ; AB² = BH × BC (et AC² = CH × CB).', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('911d2611-f232-5e69-b326-4d2b66501742', 'math-1ere-sec', 'Vecteurs et translations', 'Définition du vecteur par équipollence des bipoints (AB = CD lorsque [AD] et [BC] ont le même milieu), vecteur nul, égalité vectorielle et ses caractérisations (parallélogramme, permutation AC = BD, milieu), translation et image d''un point, d''une droite, d''un segment, d''un cercle et d''un polygone, conservation des distances, des aires, des périmètres et des angles par une translation', '# ⚔️ Vecteurs et translations

> 💡 «Un vecteur, c''est un déplacement pur : une direction, un sens, une longueur — et rien d''autre. Le glisser sur une figure, c''est la translater sans jamais la déformer.»

Jusqu''ici, un point restait à sa place. Le **vecteur** capture l''idée de **déplacement** : aller de A vers B, c''est le vecteur AB. Deux déplacements identiques, partis de points différents, définissent le **même vecteur**. La **translation** applique ce déplacement à toute une figure. C''est le premier outil d''une géométrie nouvelle, qui prépare le calcul dans un repère.

## ➡️ Qu''est-ce qu''un vecteur ?

Un couple ordonné de points (A, B) est un **bipoint**. Le **vecteur AB** possède trois caractères : une **direction** (celle de la droite (AB)), un **sens** (de A vers B) et une **longueur** (la distance AB).

Deux bipoints représentent **le même vecteur** — on dit qu''ils sont **équipollents** — lorsqu''ils ont même direction, même sens et même longueur. On le reconnaît ainsi :

> Le vecteur AB est égal au vecteur CD **si et seulement si les segments [AD] et [BC] ont le même milieu**.

Le **vecteur nul**, noté 0, est celui d''un bipoint (A, A) : direction et sens indéfinis, longueur nulle.

_Exemple détaillé_ : si le milieu de [AD] coïncide avec le milieu de [BC], alors le vecteur AB = le vecteur CD : les deux flèches sont parallèles, de même sens et de même longueur.

## 🟰 Caractériser l''égalité de deux vecteurs

La définition par les milieux se traduit par des critères commodes :

- **Parallélogramme** : si A, B, C ne sont pas alignés, alors « vecteur AB = vecteur CD » équivaut à « **ABDC est un parallélogramme** » (les segments [AD] et [BC] en sont les diagonales, qui se coupent en leur milieu).
- **Permutation** : vecteur AB = vecteur CD équivaut à vecteur AC = vecteur BD.
- **Milieu** : pour trois points distincts, vecteur AB = vecteur BC équivaut à « **B est le milieu de [AC]** ».

_Exemple détaillé_ : ABDC est un parallélogramme. Alors vecteur AB = vecteur CD, et aussi vecteur AC = vecteur BD (les deux autres côtés). C''est la façon la plus rapide de « lire » des vecteurs égaux sur une figure.

> ⚠️ L''ordre des lettres compte. Le vecteur AB et le vecteur BA ont la même direction et la même longueur mais des **sens opposés** : ils ne sont pas égaux (ce sont des vecteurs opposés).

## 🎯 La translation et l''image d''un point

Se donner un vecteur AB, c''est se donner une **translation**.

> L''**image** d''un point M par la translation de vecteur AB est l''unique point M'' tel que **vecteur MM'' = vecteur AB**.

Ainsi l''image de A est B. Tout point suit exactement le même déplacement : même direction, même sens, même longueur.

_Exemple détaillé_ : par la translation de vecteur AB, le point M se déplace « comme A se déplace vers B ». On construit M'' en reportant, à partir de M, un segment parallèle à [AB], de même sens et de même longueur ; alors MABM''... plus simplement, MM'' = AB et ABM''M est un parallélogramme.

## 📐 Images d''une droite, d''un segment, d''un cercle, d''un polygone

Une translation transporte les figures entières, sans les déformer :

| figure de départ | son image par translation                                         |
| ---------------- | ----------------------------------------------------------------- |
| une droite       | une droite **parallèle** à la première                            |
| un segment       | un segment **isométrique** (même longueur)                        |
| un cercle        | un cercle de **même rayon**, dont le centre est l''image du centre |
| un polygone      | un polygone **superposable** (mêmes longueurs, mêmes angles)      |

_Exemple détaillé_ : l''image d''un cercle de centre O et de rayon 3 cm par une translation de vecteur AB est le cercle de rayon 3 cm dont le centre O'' est l''image de O (donc OO'' = AB).

## 🔒 Ce que la translation conserve

Parce qu''elle déplace sans déformer, la translation **conserve** :

- les **distances** (deux points et leurs images sont à la même distance) ;
- les **longueurs** et les **périmètres** ;
- les **aires** ;
- les **angles** (les angles homologues sont égaux).

_Exemple détaillé_ : un triangle et son image par une translation ont exactement le même périmètre, la même aire et les mêmes angles : ils sont superposables (on peut les faire coïncider en glissant l''un sur l''autre).

> 🗡️ Une translation ne fait ni tourner ni agrandir : elle glisse. C''est pourquoi les images sont toujours parallèles aux figures de départ et de même taille — contrairement à un agrandissement (chapitre 2) qui, lui, change les longueurs.

> 🏆 Quatrième quête franchie, héros : tu sais reconnaître deux vecteurs égaux, construire l''image d''une figure par translation et nommer tout ce qu''elle conserve. Au prochain chapitre, tu apprendras à **additionner** les vecteurs et à repérer ceux qui sont colinéaires.', '# 📜 Résumé : Vecteurs et translations

- **Vecteur** : un bipoint (A, B) définit le vecteur AB (direction, sens, longueur). Vecteur AB = vecteur CD ⟺ [AD] et [BC] ont le même milieu (équipollence). Le vecteur nul 0 a une longueur nulle.
- **Caractériser l''égalité** : si A, B, C non alignés, AB = CD ⟺ ABDC est un parallélogramme ; AB = CD ⟺ AC = BD (permutation) ; AB = BC ⟺ B milieu de [AC]. Attention : vecteur AB ≠ vecteur BA (sens opposés).
- **Translation** : l''image de M par la translation de vecteur AB est M'' tel que vecteur MM'' = vecteur AB (l''image de A est B) ; tout point suit le même déplacement.
- **Images de figures** : une droite → droite parallèle ; un segment → segment isométrique ; un cercle → cercle de même rayon (centre = image du centre) ; un polygone → polygone superposable.
- **Conservation** : une translation conserve les distances, les longueurs, les périmètres, les aires et les angles — elle glisse sans déformer (ni rotation, ni agrandissement).', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e7fa1c08-f6c0-5b4b-a040-b410d4b0b033', 'math-1ere-sec', 'Somme de deux vecteurs et vecteurs colinéaires', 'Somme de deux vecteurs et relation de Chasles (AB + BC = AC), règle du parallélogramme (AB + AC = AD), vecteurs opposés, produit d''un vecteur par un réel (sens et longueur selon le signe et la valeur du coefficient), vecteurs colinéaires et leur lien avec le parallélisme de deux droites, et caractérisation vectorielle du milieu d''un segment (IA + IB = 0, AB = 2 AI)', '# ⚔️ Somme de deux vecteurs et vecteurs colinéaires

> 💡 «Deux déplacements enchaînés n''en font qu''un : c''est toute la puissance de l''addition vectorielle. De là naît le calcul des forces, des trajectoires et des alignements.»

Tu sais déjà reconnaître deux vecteurs égaux et translater une figure. Maintenant, tu apprends à **calculer** avec les vecteurs : les additionner, les multiplier par un nombre, reconnaître ceux qui sont **colinéaires**. Ces opérations transforment un problème de géométrie (alignement, milieu, parallélisme) en un petit calcul — la clé du raisonnement vectoriel.

## ➕ La somme de deux vecteurs : la relation de Chasles

Enchaîner le déplacement de A vers B, puis de B vers C, revient à se déplacer directement de A vers C :

$$ vecteur AB + vecteur BC = vecteur AC $$

C''est la **relation de Chasles**. Le secret : le point d''arrivée du premier vecteur est le point de départ du second (ici, B).

_Exemple détaillé_ : vecteur AB + vecteur BC + vecteur CD = vecteur AD (on enchaîne A→B→C→D, il reste A→D). De même, vecteur AC + vecteur CB = vecteur AB.

> 🗡️ Astuce de calcul : pour simplifier une somme de vecteurs, réorganise-la pour que les lettres « se recollent » (…AB + BC…). Quand un vecteur et son opposé se suivent, ils s''annulent.

## ▱ Règle du parallélogramme et vecteurs opposés

Quand les deux vecteurs partent du **même point** A, on utilise la **règle du parallélogramme** :

> Si A, B, C ne sont pas alignés, alors vecteur AB + vecteur AC = vecteur AD **équivaut à « ABDC est un parallélogramme »** (D est le quatrième sommet).

Deux vecteurs sont **opposés** lorsque leur somme est le vecteur nul. C''est le cas de vecteur AB et vecteur BA :

$$ vecteur AB + vecteur BA = vecteur 0 $$

_Exemple détaillé_ : dans un parallélogramme ABDC, la somme des deux côtés issus de A, vecteur AB + vecteur AC, donne la diagonale vecteur AD. C''est la version géométrique de l''addition.

## ✖️ Le produit d''un vecteur par un réel

Multiplier un vecteur u par un réel α donne un nouveau vecteur αu, **colinéaire** à u :

- sa **longueur** est **|α| × (longueur de u)** ;
- son **sens** est **celui de u si α > 0**, l''**opposé si α < 0**.

_Exemple détaillé_ : 2·vecteur AB est deux fois plus long que vecteur AB et de même sens ; −3·vecteur AB est trois fois plus long et de sens contraire. On note aussi (−1)·vecteur AB = −vecteur AB = vecteur BA.

> ⚠️ Ne confonds pas longueur et coefficient. Le vecteur −3·vecteur AB a pour longueur 3 × AB (on prend la **valeur absolue** du coefficient) ; le signe « − » ne change que le sens, pas la longueur.

## ↔️ Vecteurs colinéaires

Deux vecteurs non nuls sont **colinéaires** lorsque l''un est le produit de l''autre par un réel :

> vecteur CD et vecteur AB sont colinéaires **si et seulement s''il existe un réel k tel que vecteur CD = k · vecteur AB.**

Le lien avec le parallélisme est fondamental :

- si vecteur CD = k · vecteur AB, alors les droites (AB) et (CD) sont **parallèles** (ou confondues) ;
- réciproquement, si (AB) // (CD), alors vecteur AB et vecteur CD sont colinéaires.

_Exemple détaillé_ : si vecteur CD = 2 · vecteur AB, les points sont tels que (CD) // (AB), CD = 2 × AB, et les deux vecteurs sont de même sens (k = 2 > 0). C''est **l''outil pour prouver que trois points sont alignés** : A, B, C sont alignés si et seulement si vecteur AB et vecteur AC sont colinéaires.

## 🎯 Milieu d''un segment

Les vecteurs caractérisent aussi le **milieu**. Le point I est le milieu de [AB] lorsque :

$$ vecteur IA + vecteur IB = vecteur 0 $$

ce qui équivaut aussi à :

$$ vecteur AB = 2 · vecteur AI $$

_Exemple détaillé_ : si I est le milieu de [AB], alors vecteur AI et vecteur IB sont égaux, et vecteur AB = 2·vecteur AI. Réciproquement, dès que vecteur AB = 2·vecteur AI avec I sur [AB], I est le milieu.

> 🏆 Cinquième quête franchie, héros : tu additionnes les vecteurs par Chasles, tu les multiplies par un réel et tu détectes la colinéarité — donc l''alignement et le parallélisme. Au prochain chapitre, tu poseras un **repère** pour tout calculer avec des coordonnées.', '# 📜 Résumé : Somme de deux vecteurs et vecteurs colinéaires

- **Relation de Chasles** : vecteur AB + vecteur BC = vecteur AC (le point d''arrivée du premier est le départ du second). Pour simplifier une somme, on recolle les lettres.
- **Règle du parallélogramme et opposés** : si A, B, C non alignés, vecteur AB + vecteur AC = vecteur AD ⟺ ABDC parallélogramme. Deux vecteurs opposés ont pour somme le vecteur nul : vecteur AB + vecteur BA = 0.
- **Produit par un réel** : α·u est colinéaire à u, de longueur |α| × (longueur de u), de même sens si α > 0 et de sens contraire si α < 0. Le signe change le sens, la valeur absolue donne la longueur.
- **Vecteurs colinéaires** : vecteur CD et vecteur AB colinéaires ⟺ il existe un réel k tel que vecteur CD = k·vecteur AB. Alors (AB) // (CD) (et réciproquement). A, B, C alignés ⟺ vecteur AB et vecteur AC colinéaires.
- **Milieu d''un segment** : I milieu de [AB] ⟺ vecteur IA + vecteur IB = 0 ⟺ vecteur AB = 2·vecteur AI.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('947437c3-de15-51ca-b0a8-7b0fff092953', 'math-1ere-sec', 'Activités dans un repère', 'Repère cartésien d''une droite et abscisse d''un point, mesure algébrique d''un vecteur, repère cartésien du plan (coordonnées d''un point, composantes d''un vecteur), coordonnées du milieu d''un segment, critère de colinéarité par proportionnalité des composantes (et alignement de points), distance entre deux points et norme d''un vecteur dans un repère orthonormé, et parallélisme de droites de même coefficient directeur', '# ⚔️ Activités dans un repère

> 💡 «Poser un repère, c''est donner une adresse à chaque point. Dès lors, un problème de géométrie devient un simple calcul sur des nombres : c''est l''idée géniale de Descartes.»

Jusqu''ici, tu raisonnais sur des figures. Avec un **repère**, chaque point reçoit des **coordonnées**, chaque vecteur des **composantes**, et les grandes questions — milieu, alignement, distance, parallélisme — se résolvent par le calcul. Ce chapitre relie la géométrie des chapitres précédents à l''algèbre.

## 📍 Repère et abscisse sur une droite

Un **repère cartésien** d''une droite est un couple (O, I) : O est l''**origine**, et le vecteur OI donne l''unité. Tout point M de la droite a une unique **abscisse** x telle que :

$$ vecteur OM = x · vecteur OI $$

La **mesure algébrique** du vecteur AB est le réel :

$$ AB = xB − xA $$

_Exemple détaillé_ : sur une droite, A a pour abscisse 2 et B pour abscisse 5. La mesure algébrique de vecteur AB vaut xB − xA = 5 − 2 = 3. Si l''abscisse de C est −1, alors la mesure algébrique de vecteur AC vaut −1 − 2 = −3 (le signe indique le sens).

## 🗺️ Repère du plan : coordonnées d''un point

Un **repère cartésien du plan** est un triplet (O, I, J). L''**axe des abscisses** porte OI, l''**axe des ordonnées** porte OJ. Tout point M a un unique couple de **coordonnées** (x ; y) tel que :

$$ vecteur OM = x · vecteur OI + y · vecteur OJ $$

x est l''**abscisse**, y l''**ordonnée**. On note M(x ; y).

_Exemple détaillé_ : le point A(2 ; 3) se lit « 2 vers la droite, 3 vers le haut » à partir de l''origine. L''origine O est le point (0 ; 0).

## ➡️ Composantes d''un vecteur

Un vecteur possède un couple de **composantes**, obtenu en soustrayant les coordonnées « arrivée moins départ » :

$$ vecteur AB (xB − xA ; yB − yA) $$

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6), les composantes de vecteur AB sont (4 − 1 ; 6 − 2) = (3 ; 4). **Deux vecteurs sont égaux si et seulement s''ils ont les mêmes composantes.**

> 🗡️ Ordre à respecter : toujours **coordonnées de l''arrivée moins coordonnées du départ**. Inverser donne le vecteur opposé.

## 🎯 Milieu et colinéarité par le calcul

Deux formules essentielles :

- **Milieu** de [AB] : le point K de coordonnées

$$ K((xA + xB)/2 ; (yA + yB)/2) $$

- **Colinéarité** : vecteur CD et vecteur AB sont colinéaires lorsque leurs composantes sont **proportionnelles**, c''est-à-dire s''il existe un réel k tel que chaque composante de vecteur CD soit k fois celle de vecteur AB. C''est le test d''**alignement** : A, B, C sont alignés si vecteur AB et vecteur AC sont colinéaires.

_Exemple détaillé (milieu)_ : le milieu de [AB] avec A(2 ; 3) et B(6 ; 9) est K((2 + 6)/2 ; (3 + 9)/2) = (4 ; 6).

_Exemple détaillé (colinéarité)_ : vecteur AB(3 ; 4) et vecteur CD(6 ; 8) : on cherche k tel que 6 = k × 3 et 8 = k × 4. Les deux donnent k = 2, donc les vecteurs sont colinéaires (et vecteur CD = 2·vecteur AB).

> ⚠️ Pour la colinéarité, le **même** coefficient k doit convenir aux **deux** composantes. Si 6 = 2 × 3 mais 8 ≠ 3 × 3, les vecteurs ne sont pas colinéaires.

## 📏 Distance dans un repère orthonormé

Un repère est **orthonormé** lorsque ses deux axes sont perpendiculaires et de même unité. On peut alors calculer une **distance** :

$$ AB = √((xB − xA)² + (yB − yA)²) $$

C''est le théorème de Pythagore appliqué aux composantes du vecteur.

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6) dans un repère orthonormé, AB = √((4 − 1)² + (6 − 2)²) = √(9 + 16) = √25 = 5.

> 🗡️ Deux droites qui sont les représentations graphiques de fonctions affines de **même coefficient directeur** sont **parallèles** : par exemple y = 2x + 1 et y = 2x − 3 ont des droites parallèles.

> 🏆 Sixième quête franchie, héros : tu sais placer un point, calculer des composantes, un milieu, une distance, et prouver un alignement par le calcul. Au prochain chapitre, tu découvriras une nouvelle transformation : le quart de tour.', '# 📜 Résumé : Activités dans un repère

- **Repère d''une droite** : (O, I) ; l''abscisse de M vérifie vecteur OM = x·vecteur OI. La mesure algébrique de vecteur AB est AB = xB − xA (le signe donne le sens).
- **Repère du plan** : (O, I, J), axes des abscisses et des ordonnées ; tout point M(x ; y) vérifie vecteur OM = x·vecteur OI + y·vecteur OJ.
- **Composantes d''un vecteur** : vecteur AB(xB − xA ; yB − yA), toujours « arrivée moins départ ». Deux vecteurs sont égaux ⟺ mêmes composantes.
- **Milieu et colinéarité** : milieu de [AB] = ((xA + xB)/2 ; (yA + yB)/2) ; deux vecteurs sont colinéaires ⟺ leurs composantes sont proportionnelles (un même k relie les deux composantes) ⟺ point alignés si les vecteurs le sont.
- **Distance (repère orthonormé)** : AB = √((xB − xA)² + (yB − yA)²) ; deux fonctions affines de même coefficient directeur ont des droites parallèles.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8f37a3b1-c4ff-566b-9985-c7c2d877a56c', 'math-1ere-sec', 'Quart de tour', 'Quart de tour direct et indirect de centre donné (rotation de 90°) : définition par égalité des distances au centre et angle droit, sens direct et indirect, lien avec le triangle rectangle isocèle, conservation des distances, de l''alignement et des angles, image d''un segment (isométrique), d''une droite (perpendiculaire à la droite de départ), d''un cercle (même rayon) et d''un polygone (superposable), et emploi du quart de tour pour démontrer et construire', '# ⚔️ Quart de tour

> 💡 «Fais pivoter le plan d''un quart de tour autour d''un point : les longueurs survivent, les angles aussi, mais toute droite se dresse perpendiculaire à elle-même. Une transformation qui fabrique des angles droits.»

Tu connais déjà la symétrie, la translation et le demi-tour (la symétrie centrale). Voici une nouvelle transformation : le **quart de tour**, une rotation de **90°** autour d''un centre. Sa signature : elle transforme une droite en une droite **perpendiculaire**. C''est un outil redoutable pour démontrer des perpendicularités et des égalités de longueurs.

## 🔄 Le quart de tour direct et indirect

Soit O un point fixe, le **centre**. L''image d''un point M (avec M ≠ O) par le **quart de tour de centre O** est le point M'' tel que :

$$ OM'' = OM $$

et l''angle **MOM'' = 90°**. L''image de O est O lui-même (c''est le seul point fixe).

Il y a deux sens de rotation :

- le **quart de tour direct** tourne dans le **sens direct** (contraire des aiguilles d''une montre) ;
- le **quart de tour indirect** tourne dans le **sens indirect** (celui des aiguilles d''une montre).

_Exemple détaillé_ : si OM = 4 cm, alors son image M'' vérifie OM'' = 4 cm et l''angle MOM'' est droit. Le triangle OMM'' est donc rectangle isocèle en O.

## 📐 Quart de tour et triangle rectangle isocèle

Ce lien est la clé du chapitre :

> Le triangle ABC est **rectangle isocèle en A** si et seulement si **C est l''image de B par un quart de tour de centre A** (direct ou indirect).

En effet, « rectangle isocèle en A » signifie exactement AB = AC (isocèle) et angle BAC = 90° (rectangle) : ce sont les deux conditions de définition du quart de tour de centre A.

_Exemple détaillé_ : si ABC est rectangle isocèle en A, alors AB = AC et l''angle BAC = 90° ; C est donc l''image de B par le quart de tour de centre A. Réciproquement, prendre l''image d''un point par un quart de tour, c''est fabriquer un tel triangle.

## 🔒 Ce que le quart de tour conserve

Comme la translation, le quart de tour est une **isométrie** : il déplace sans déformer. Il **conserve** :

- les **distances** (donc les longueurs et les périmètres) ;
- l''**alignement** des points ;
- les **angles** (les angles homologues sont égaux) ;
- les **aires**.

Un polygone et son image sont donc **superposables**.

_Exemple détaillé_ : un segment [AB] a pour image un segment [A''B''] de **même longueur** : A''B'' = AB. Un triangle et son image ont le même périmètre et la même aire.

## ⊥ Image d''une droite : une perpendiculaire

Voici la propriété qui distingue le quart de tour de la translation :

> L''image d''une **droite** par un quart de tour est une **droite perpendiculaire** à la droite de départ.

À comparer : la translation transforme une droite en une droite **parallèle**. Ici, l''angle de 90° du quart de tour se retrouve entre la droite et son image. Par ailleurs :

- l''image d''un **segment** est un segment **isométrique** ;
- l''image d''un **cercle** est un cercle de **même rayon**, dont le centre est l''image du centre.

> ⚠️ Ne confonds pas les deux transformations. **Translation → droite parallèle** ; **quart de tour → droite perpendiculaire**. C''est souvent ce que teste un exercice.

## 🛠️ Utiliser le quart de tour pour démontrer et construire

Grâce à ses conservations, le quart de tour **prouve** des égalités de longueurs et des perpendicularités d''un seul coup.

_Exemple détaillé_ : soient deux carrés ABCD et AEFG partageant le sommet A. Un quart de tour de centre A qui envoie B sur D envoie aussi E sur G ; il transforme donc le segment [BE] en [DG]. On en déduit d''un seul argument que **BE = DG** (conservation des longueurs) **et que (BE) ⊥ (DG)** (image d''une droite = perpendiculaire).

Il sert aussi à **construire** des figures régulières (par exemple un octogone régulier, par quarts de tour successifs autour du centre) et des triangles rectangles isocèles.

> 🏆 Septième quête franchie, héros : tu maîtrises une transformation qui conserve tout sauf la direction des droites, qu''elle rend perpendiculaires. Au dernier chapitre de géométrie, tu quittes le plan pour l''espace et les sections planes des solides.', '# 📜 Résumé : Quart de tour

- **Définition** : l''image de M (M ≠ O) par le quart de tour de centre O est M'' tel que OM'' = OM et angle MOM'' = 90°. L''image de O est O. Deux sens : direct (sens contraire des aiguilles) et indirect (sens des aiguilles).
- **Triangle rectangle isocèle** : ABC est rectangle isocèle en A ⟺ C est l''image de B par un quart de tour de centre A (les conditions AB = AC et angle BAC = 90° sont exactement celles du quart de tour).
- **Conservations** : le quart de tour conserve les distances (longueurs, périmètres), l''alignement, les angles et les aires ; un polygone et son image sont superposables.
- **Image d''une droite = perpendiculaire** : l''image d''une droite par un quart de tour lui est perpendiculaire (à comparer : la translation donne une parallèle). Image d''un segment → segment isométrique ; image d''un cercle → cercle de même rayon.
- **Outil de preuve et de construction** : le quart de tour démontre d''un coup une égalité de longueurs et une perpendicularité (ex. carrés accolés : BE = DG et (BE) ⊥ (DG)) et sert à construire des figures régulières (octogone) et des triangles rectangles isocèles.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c65b31e6-7328-5bac-96d5-9410d68d33e8', 'math-1ere-sec', 'Sections planes d''un solide', 'Solides usuels (parallélépipède rectangle, cylindre, prisme droit, pyramide, cône de révolution, sphère et boule) et leurs volumes, sections planes : d''un parallélépipède droit (par un plan parallèle à une face → rectangle isométrique, par un plan contenant une arête → rectangle), d''une pyramide et d''un cône par un plan parallèle à la base (polygone de même nature réduit, cercle), d''un cylindre (cercle de même rayon), d''une sphère (cercle, grand cercle si le plan passe par le centre), et propriétés des plans parallèles et de la perpendicularité droite-plan', '# ⚔️ Sections planes d''un solide

> 💡 «Trancher un solide par un plan, c''est révéler la figure cachée à l''intérieur. Un cylindre coupé donne un cercle, une pyramide un polygone réduit : l''espace se lit dans le plan.»

Ce chapitre quitte le plan pour l''**espace**. Tu revois d''abord les **volumes** des solides usuels, puis tu étudies leurs **sections planes** : la figure obtenue quand un plan coupe le solide. Selon le solide et l''orientation du plan, on obtient un rectangle, un cercle ou un polygone réduit — des résultats à connaître par cœur.

## 🧊 Les solides usuels et leurs volumes

Rappel des formules de volume (B désigne l''aire de la base, h la hauteur, R le rayon) :

| solide                    | volume        |
| ------------------------- | ------------- |
| parallélépipède rectangle | a × b × c     |
| prisme droit              | B × h         |
| cylindre                  | π × R² × h    |
| pyramide, cône, tétraèdre | (1/3) × B × h |

Pour la **sphère** de rayon R : son aire vaut 4 × π × R², et le volume de la **boule** vaut (4/3) × π × R³.

_Exemple détaillé_ : un cylindre de rayon 3 cm et de hauteur 10 cm a pour volume π × 3² × 10 = 90π cm³ (soit environ 282,7 cm³).

## ▭ Section d''un parallélépipède rectangle

Deux cas au programme :

> La section d''un parallélépipède droit par un plan **parallèle à une face** est un **rectangle isométrique** (identique) à cette face.

> La section par un plan **contenant une arête** est un **rectangle**.

_Exemple détaillé_ : on coupe une boîte parallélépipédique par un plan parallèle à sa face avant. La tranche obtenue est un rectangle exactement superposable à cette face avant.

## 🔺 Section d''une pyramide et d''un cône

Quand le plan est **parallèle à la base** :

> La section d''une **pyramide** par un plan parallèle à sa base est un **polygone de même nature que la base**, mais **réduit**.

> La section d''un **cône de révolution** par un plan parallèle à sa base est un **cercle** (plus petit) ; la partie basse forme un **cône tronqué**.

Cette réduction suit une **échelle k** (comme au chapitre Thalès) : les longueurs sont multipliées par k, et l''**aire de la section par k²**.

_Exemple détaillé_ : une pyramide à base carrée est coupée à mi-hauteur par un plan parallèle à la base (k = 1/2). La section est un carré dont le côté est la moitié de celui de la base, donc d''aire quatre fois plus petite (k² = 1/4).

## ⭕ Section d''un cylindre et d''une sphère

> La section d''un **cylindre** par un plan **parallèle à une base** est un **cercle de même rayon** que la base.

> La section d''une **sphère** par un plan est un **cercle**. Si le plan passe par le **centre**, ce cercle a le rayon de la sphère : on l''appelle un **grand cercle**.

Pour une sphère de rayon R coupée par un plan situé à la distance d de son centre, le rayon r de la section se calcule par le théorème de Pythagore :

$$ r = √(R² − d²) $$

_Exemple détaillé_ : une sphère de rayon 25 cm est coupée par un plan situé à 20 cm de son centre. Le rayon de la section vaut r = √(25² − 20²) = √(625 − 400) = √225 = **15 cm**.

> ⚠️ Pour la sphère, la section est un cercle **d''autant plus petit que le plan est loin du centre**. Le plus grand cercle possible (le grand cercle) s''obtient quand le plan passe par le centre (d = 0, donc r = R).

## 📐 Plans parallèles et perpendicularité

Deux propriétés d''espace utiles pour justifier la nature d''une section :

- Quand un plan **sécant** coupe **deux plans parallèles**, les **deux droites d''intersection sont parallèles** entre elles.
- Une droite est **perpendiculaire à un plan** lorsqu''elle est perpendiculaire à toutes les droites de ce plan passant par leur point commun ; l''axe d''un cylindre ou la hauteur d''un cône sont perpendiculaires à la base.

_Exemple détaillé_ : la hauteur d''un cône, perpendiculaire à la base, l''est aussi à tout plan de section parallèle à la base — ce qui garantit que la section est bien un cercle centré sur l''axe.

> 🏆 Huitième quête franchie, héros : tu calcules des volumes et tu reconnais la figure cachée dans toute section usuelle. Tu clôtures la géométrie de l''année ; place maintenant aux nombres et à l''algèbre.', '# 📜 Résumé : Sections planes d''un solide

- **Volumes usuels** : parallélépipède rectangle a × b × c ; prisme droit B × h ; cylindre π × R² × h ; pyramide, cône et tétraèdre (1/3) × B × h. Sphère : aire 4πR² ; boule : volume (4/3)πR³.
- **Section d''un parallélépipède droit** : par un plan parallèle à une face → rectangle isométrique à cette face ; par un plan contenant une arête → rectangle.
- **Section d''une pyramide / d''un cône (plan parallèle à la base)** : pyramide → polygone de même nature que la base, réduit ; cône → cercle (cône tronqué en dessous). La réduction suit une échelle k : longueurs ×k, aire ×k².
- **Section d''un cylindre / d''une sphère** : cylindre (plan parallèle à une base) → cercle de même rayon ; sphère → cercle, appelé grand cercle si le plan passe par le centre. Rayon de la section d''une sphère à distance d du centre : r = √(R² − d²).
- **Plans et perpendicularité** : un plan sécant coupant deux plans parallèles y trace deux droites parallèles ; une droite perpendiculaire à un plan (axe, hauteur) l''est à toutes les droites de ce plan issues du point commun.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('8bea7605-27a1-597f-a6ed-f483ba0da928', 'math-1ere-sec', 'Activités numériques I — arithmétique et ensembles de nombres', 'Division euclidienne (a = bq + r avec 0 ≤ r < b), divisibilité, nombres premiers et décomposition en facteurs premiers, plus grand commun diviseur (PGCD) et plus petit commun multiple (PPCM) avec l''algorithme d''Euclide et la relation PGCD × PPCM = a × b, entiers premiers entre eux et fractions irréductibles, ensembles de nombres emboîtés (IN ⊂ ℤ ⊂ D ⊂ Q ⊂ R), et notation scientifique avec ordre de grandeur', '# ⚔️ Activités numériques I — arithmétique et ensembles de nombres

> 💡 «Derrière chaque entier se cache une structure secrète : ses diviseurs, ses facteurs premiers. Savoir la lire, c''est simplifier une fraction, synchroniser deux cycles, ranger tout nombre à sa place.»

Ce chapitre plonge dans le monde des **entiers** et des **nombres**. Tu y apprends la division euclidienne, les nombres premiers, le PGCD et le PPCM (les outils pour simplifier et synchroniser), la grande famille des ensembles de nombres, et la notation scientifique pour manier le très grand et le très petit. Des bases solides pour toute l''algèbre à venir.

## ➗ La division euclidienne

Diviser un entier a (le **dividende**) par un entier b non nul (le **diviseur**), c''est trouver un **quotient** q et un **reste** r tels que :

$$ a = b × q + r, avec 0 ≤ r < b $$

Le reste est toujours **positif et strictement inférieur au diviseur**. Quand r = 0, on dit que **b divise a**.

_Exemple détaillé_ : la division euclidienne de 452 par 6 donne 452 = 6 × 75 + 2 (quotient 75, reste 2). Comme le reste n''est pas nul, 6 ne divise pas 452.

## 🔢 Nombres premiers et facteurs premiers

Un **nombre premier** est un entier supérieur à 1 qui n''a que **deux diviseurs** : 1 et lui-même (2, 3, 5, 7, 11, 13…). Résultat fondamental :

> Tout entier naturel supérieur à 1 se **décompose en produit de facteurs premiers**, et cette décomposition est unique.

_Exemple détaillé_ : 84 = 2 × 42 = 2 × 2 × 21 = 2 × 2 × 3 × 7, donc 84 = 2² × 3 × 7. Cette écriture révèle tous les diviseurs de 84.

> 🗡️ Pour tester si un nombre est premier, il suffit d''essayer de le diviser par les nombres premiers successifs (2, 3, 5, 7…) jusqu''à ce que leur carré dépasse le nombre.

## 🔗 PGCD, PPCM et algorithme d''Euclide

- Le **PGCD** de a et b est leur **plus grand commun diviseur**.
- Le **PPCM** de a et b est leur **plus petit commun multiple** (non nul).
- Ils sont reliés par : **PGCD(a, b) × PPCM(a, b) = a × b**.

L''**algorithme d''Euclide** calcule le PGCD par divisions successives : on remplace (a, b) par (b, reste) jusqu''à un reste nul ; le dernier reste non nul est le PGCD.

_Exemple détaillé_ : PGCD(2430, 756). 2430 = 3 × 756 + 162 ; 756 = 4 × 162 + 108 ; 162 = 1 × 108 + 54 ; 108 = 2 × 54 + 0. Le dernier reste non nul est **54** : PGCD(2430, 756) = 54.

Deux entiers sont **premiers entre eux** si leur seul diviseur commun est 1 (leur PGCD vaut 1). Une **fraction est irréductible** quand son numérateur et son dénominateur sont premiers entre eux.

_Exemple détaillé_ : PGCD(175, 196) = 7 (car 175 = 5² × 7 et 196 = 2² × 7²). Donc 175/196 = 25/28, forme irréductible (25 et 28 n''ont plus de diviseur commun).

## 📚 Les ensembles de nombres

Les nombres se rangent dans des ensembles **emboîtés** :

$$ IN ⊂ ℤ ⊂ D ⊂ Q ⊂ R $$

- **IN** : entiers naturels (0, 1, 2, 3…) ;
- **ℤ** : entiers relatifs (…, −2, −1, 0, 1, 2…) ;
- **D** : décimaux (écriture décimale finie, comme 3,25) ;
- **Q** : rationnels (quotient de deux entiers, comme 1/3) ;
- **R** : réels (tous, y compris √2 et π).

_Exemple détaillé_ : −5 est dans ℤ mais pas dans IN ; 0,25 = 1/4 est dans D ; 1/3 est dans Q mais **pas** dans D (son écriture décimale 0,333… est illimitée) ; √2 est dans R mais pas dans Q.

## 🔬 Notation scientifique et ordre de grandeur

La **notation scientifique** d''un nombre l''écrit sous la forme **a × 10ⁿ**, où **1 ≤ a < 10** et n est un entier relatif. Elle rend lisibles les nombres très grands ou très petits.

_Exemple détaillé_ : le rayon de la Terre, 6 371 km, s''écrit 6,371 × 10³ km. Le nombre 0,0003 s''écrit 3 × 10⁻⁴. L''**ordre de grandeur** est la puissance de 10 dominante : celui de 6 371 est 10³.

> 🏆 Neuvième quête franchie, héros : tu décomposes, tu simplifies, tu synchronises et tu ranges tout nombre à sa place. Au prochain chapitre, tu approfondis le calcul sur les puissances, les racines carrées et les intervalles.', '# 📜 Résumé : Activités numériques I

- **Division euclidienne** : a = b × q + r avec 0 ≤ r < b (reste positif, strictement inférieur au diviseur). Si r = 0, b divise a.
- **Nombres premiers** : diviseurs uniquement 1 et lui-même (2, 3, 5, 7…). Tout entier > 1 se décompose de façon unique en produit de facteurs premiers (ex. 84 = 2² × 3 × 7).
- **PGCD, PPCM, Euclide** : PGCD = plus grand diviseur commun, PPCM = plus petit multiple commun ; PGCD × PPCM = a × b. L''algorithme d''Euclide (divisions successives, dernier reste non nul) donne le PGCD.
- **Premiers entre eux / fraction irréductible** : deux entiers de PGCD 1 sont premiers entre eux ; une fraction est irréductible quand numérateur et dénominateur le sont (on simplifie par le PGCD).
- **Ensembles de nombres et notation scientifique** : IN ⊂ ℤ ⊂ D ⊂ Q ⊂ R (naturels, relatifs, décimaux, rationnels, réels). Notation scientifique : a × 10ⁿ avec 1 ≤ a < 10 (ex. 6 371 = 6,371 × 10³).', 9, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('80e3789e-822b-542b-939e-bc2ba9538004', 'math-1ere-sec', 'Activités numériques II — puissances, racines, valeur absolue', 'Puissances à exposant entier (y compris négatif) et leurs règles de calcul, racines carrées et leurs propriétés (√(ab) = √a × √b, √(a²) = |a|, simplification a√b, expression conjuguée), comparaison de nombres réels (a ≥ b ⟺ a − b ≥ 0, encadrements √a ≤ a ≤ a² selon la position par rapport à 1), valeur absolue d''un réel comme distance à zéro, et intervalles de R avec encadrements d''amplitude', '# ⚔️ Activités numériques II — puissances, racines, valeur absolue

> 💡 «Puissances, racines et valeur absolue sont les trois clés du calcul sur les réels. Les manier avec sûreté, c''est comparer, encadrer et simplifier n''importe quelle expression.»

Ce chapitre muscle ton calcul sur les nombres réels. Tu y consolides les **puissances** (même à exposant négatif), les **racines carrées** et leurs règles, l''art de **comparer** et d''**encadrer** des réels, et deux notions décisives : la **valeur absolue** et les **intervalles**. Ce sont les outils quotidiens de toute l''algèbre.

## 🔟 Puissances et exposants négatifs

Pour un réel a non nul et des entiers m, n, on retient :

$$ aᵐ × aⁿ = aᵐ⁺ⁿ $$
$$ (aᵐ)ⁿ = aᵐⁿ $$
$$ aᵐ / aⁿ = aᵐ⁻ⁿ $$

Un **exposant négatif** désigne l''inverse : a⁻ⁿ = 1/aⁿ. Enfin, (a × b)ⁿ = aⁿ × bⁿ.

_Exemple détaillé_ : 2³ × 2⁵ = 2⁸ = 256 ; (2³)² = 2⁶ = 64 ; 10⁻² = 1/10² = 1/100 = 0,01.

## √ Racines carrées et leurs règles

La racine carrée d''un réel positif a est le réel positif dont le carré vaut a. Règles essentielles :

$$ √a × √b = √(a × b) $$
$$ √(a²) = |a| $$

De la première on tire la **simplification** d''un radical : on sort du radical le plus grand carré parfait.

_Exemple détaillé_ : √50 = √(25 × 2) = √25 × √2 = 5√2. De même, 2√3 + 3√3 = 5√3 (on additionne les coefficients d''un même radical, comme des termes semblables).

> 🗡️ **Rendre rationnel un dénominateur** grâce à l''expression conjuguée : (√a − √b)(√a + √b) = a − b. Ainsi 1/(√2 − 1) = (√2 + 1) / ((√2 − 1)(√2 + 1)) = (√2 + 1) / (2 − 1) = √2 + 1.

> ⚠️ Attention : √(a²) = |a|, **pas** a. Par exemple √((−5)²) = √25 = 5 = |−5|, et non −5.

## ⚖️ Comparer des nombres réels

Pour comparer deux réels, la méthode sûre est d''étudier le **signe de leur différence** :

$$ a ≥ b ⟺ a − b ≥ 0 $$

Autres repères utiles : ranger deux réels revient à comparer, selon les cas, leurs carrés (pour des positifs), leurs racines ou leurs inverses. En particulier, pour un réel **a ≥ 1** :

$$ √a ≤ a ≤ a² $$

et l''ordre s''inverse pour 0 ≤ a ≤ 1 : a² ≤ a ≤ √a.

_Exemple détaillé_ : pour a = 4 (≥ 1), on a √4 = 2, puis 4, puis 4² = 16, donc 2 ≤ 4 ≤ 16. Pour a = 1/4 (entre 0 et 1), (1/4)² = 1/16, puis 1/4, puis √(1/4) = 1/2, donc 1/16 ≤ 1/4 ≤ 1/2.

## 📏 La valeur absolue

La **valeur absolue** d''un réel a, notée |a|, est sa **distance à 0** sur la droite réelle. Elle est toujours positive :

$$ |a| = a si a ≥ 0, et |a| = −a si a < 0 $$

_Exemple détaillé_ : |3| = 3 et |−5| = 5 (les deux nombres 3 et −5 sont respectivement à 3 et à 5 unités de 0). La valeur absolue « efface » le signe.

## 📐 Intervalles et encadrements

Un **intervalle** regroupe tous les réels compris entre deux bornes. Le crochet est **fermé** [ si la borne est incluse, **ouvert** ] ou [ si elle est exclue :

- [2 ; 5] : tous les x tels que 2 ≤ x ≤ 5 (bornes incluses) ;
- ]−1 ; 3] : tous les x tels que −1 < x ≤ 3 ;
- [0 ; +∞[ : tous les x tels que x ≥ 0.

**Encadrer** un réel, c''est le situer entre deux valeurs : l''**amplitude** de l''encadrement est la différence des deux bornes.

_Exemple détaillé_ : 3,1 ≤ x ≤ 3,2 est un encadrement de x d''amplitude 3,2 − 3,1 = 0,1. Plus l''amplitude est petite, plus l''encadrement est précis.

> 🏆 Dixième quête franchie, héros : puissances domptées, radicaux simplifiés, réels comparés et encadrés — ton calcul est prêt pour l''algèbre littérale du prochain chapitre.', '# 📜 Résumé : Activités numériques II

- **Puissances** : aᵐ × aⁿ = aᵐ⁺ⁿ ; (aᵐ)ⁿ = aᵐⁿ ; aᵐ / aⁿ = aᵐ⁻ⁿ ; a⁻ⁿ = 1/aⁿ ; (ab)ⁿ = aⁿbⁿ. Exemple : 10⁻² = 0,01.
- **Racines carrées** : √a × √b = √(ab) ; √(a²) = |a| (jamais a). Simplification : √50 = 5√2 ; addition de radicaux semblables : 2√3 + 3√3 = 5√3. Conjuguée : (√a − √b)(√a + √b) = a − b (rationaliser un dénominateur).
- **Comparer des réels** : a ≥ b ⟺ a − b ≥ 0. Pour a ≥ 1 : √a ≤ a ≤ a² ; pour 0 ≤ a ≤ 1 : a² ≤ a ≤ √a.
- **Valeur absolue** : |a| = distance de a à 0, toujours positive ; |a| = a si a ≥ 0 et |a| = −a si a < 0 (ex. |−5| = 5).
- **Intervalles et encadrements** : crochet fermé [ = borne incluse, ouvert ] ou [ = borne exclue (ex. [2 ; 5], ]−1 ; 3], [0 ; +∞[). Encadrer, c''est situer entre deux bornes ; l''amplitude est la différence des bornes.', 10, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f2fe4a9f-f282-5ef2-915c-e5828a361fb7', 'math-1ere-sec', 'Activités algébriques — développer, factoriser, identités remarquables', 'Calcul littéral (mise en expression et substitution numérique), développement et réduction par la distributivité (a+b)(c+d) = ac+ad+bc+bd, identités remarquables (carré d''une somme et d''une différence, cube d''une somme et d''une différence, différence de deux carrés, somme et différence de deux cubes), factorisation (facteur commun et identités), et notion d''égalité de deux expressions valable pour tout réel ou seulement pour certaines valeurs', '# ⚔️ Activités algébriques — développer, factoriser, identités remarquables

> 💡 «Les identités remarquables sont des raccourcis magiques : elles transforment un produit en somme, une somme en produit, et font tomber les calculs les plus intimidants.»

Le calcul littéral remplace les nombres par des lettres pour raisonner sur **toutes** les valeurs à la fois. Dans ce chapitre, tu apprends à **développer**, **réduire** et **factoriser** une expression, et surtout à maîtriser les **identités remarquables**, qui reviennent partout : équations, géométrie, calculs astucieux. C''est le cœur de l''algèbre.

## 🔤 Développer et réduire

**Développer**, c''est transformer un produit en somme grâce à la **distributivité**. La double distributivité s''écrit :

$$ (a + b)(c + d) = ac + ad + bc + bd $$

**Réduire**, c''est ensuite regrouper les termes semblables.

_Exemple détaillé_ : (x + 2)(x + 3) = x × x + x × 3 + 2 × x + 2 × 3 = x² + 3x + 2x + 6 = **x² + 5x + 6**.

## 🟦 Les identités remarquables

Trois formules à connaître par cœur — elles évitent de tout redévelopper :

$$ (a + b)² = a² + 2ab + b² $$
$$ (a − b)² = a² − 2ab + b² $$
$$ (a + b)(a − b) = a² − b² $$

_Exemple détaillé_ : (x + 3)² = x² + 2 × x × 3 + 3² = **x² + 6x + 9** ; (x − 4)² = x² − 2 × x × 4 + 4² = **x² − 8x + 16**.

Le manuel donne aussi les identités du **cube** et des **cubes** : (a + b)³ = a³ + 3a²b + 3ab² + b³ ; a³ − b³ = (a − b)(a² + ab + b²) ; a³ + b³ = (a + b)(a² − ab + b²).

> ⚠️ Le piège le plus courant : (a + b)² **n''est pas** a² + b². Il manque le double produit **2ab**. Par exemple (x + 5)² = x² + 10x + 25, pas x² + 25.

## ◱ La différence de deux carrés

L''identité a² − b² = (a − b)(a + b) sert surtout à **factoriser** — et à faire des calculs mentaux spectaculaires.

_Exemple détaillé_ : x² − 25 = x² − 5² = **(x − 5)(x + 5)**. Application numérique : 1003 × 997 = (1000 + 3)(1000 − 3) = 1000² − 3² = 1 000 000 − 9 = **999 991**.

## 🧩 Factoriser une expression

**Factoriser**, c''est l''opération inverse du développement : transformer une somme (ou une différence) en **produit**. Deux techniques principales :

- mettre en évidence un **facteur commun** ;
- reconnaître une **identité remarquable**.

_Exemple détaillé (facteur commun)_ : 6x² + 9x = 3x × 2x + 3x × 3 = **3x(2x + 3)**.

_Exemple détaillé (identité)_ : x² + 10x + 25 = x² + 2 × x × 5 + 5² = **(x + 5)²** ; et x² − 16 = **(x − 4)(x + 4)**.

> 🗡️ Pour factoriser, cherche d''abord un facteur commun à tous les termes ; s''il n''y en a pas, regarde si l''expression a la forme d''une identité remarquable (carré parfait, différence de carrés).

## 🎯 Prouver une égalité d''expressions

Une égalité entre deux expressions peut être vraie **pour tout réel x** (c''est une **identité**) ou seulement **pour certaines valeurs**. Pour prouver qu''elle est vraie pour tout x, on **développe et réduit les deux membres** jusqu''à obtenir la même écriture.

_Exemple détaillé_ : (x + 2)² = x² + 4x + 4 est vraie **pour tout x** (en développant le membre de gauche). En revanche, x² = 4 n''est vraie que pour x = 2 ou x = −2 : ce n''est pas une identité.

> 🏆 Onzième quête franchie, héros : tu développes, tu factorises et tu manies les identités remarquables comme des sorts. Elles seront tes meilleures alliées pour résoudre les équations, à quelques chapitres d''ici. Place d''abord aux fonctions.', '# 📜 Résumé : Activités algébriques

- **Développer et réduire** : distributivité (a + b)(c + d) = ac + ad + bc + bd, puis regrouper les termes semblables. Ex. (x + 2)(x + 3) = x² + 5x + 6.
- **Identités remarquables (carrés)** : (a + b)² = a² + 2ab + b² ; (a − b)² = a² − 2ab + b². Ne jamais oublier le double produit 2ab : (a + b)² ≠ a² + b².
- **Différence de deux carrés** : (a + b)(a − b) = a² − b². Sert à factoriser (x² − 25 = (x − 5)(x + 5)) et aux calculs astucieux (1003 × 997 = 1000² − 3² = 999 991).
- **Factoriser** : transformer une somme en produit, soit par facteur commun (6x² + 9x = 3x(2x + 3)), soit par une identité remarquable (x² + 10x + 25 = (x + 5)²).
- **Égalité d''expressions** : une égalité peut être vraie pour tout x (identité, prouvée en développant les deux membres) ou seulement pour certaines valeurs (ex. x² = 4 uniquement pour x = 2 ou x = −2). Identités du cube au programme : (a ± b)³, a³ ± b³.', 11, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0a439078-2174-532b-9cc2-aaf496763a2a', 'math-1ere-sec', 'Fonctions linéaires', 'Fonction linéaire f : x ↦ ax (coefficient, image, antécédent), propriétés caractéristiques (f(0) = 0, f(1) = a, f(x + x'') = f(x) + f(x'')), représentation graphique comme droite passant par l''origine d''équation y = ax, lecture graphique (image, antécédent, coefficient), et applications aux pourcentages (hausses et baisses, éventuellement successives) et à la proportionnalité', '# ⚔️ Fonctions linéaires

> 💡 «Une fonction linéaire, c''est la proportionnalité mise en formule : double l''entrée, tu doubles la sortie. Prix, distances, pourcentages : le monde des grandeurs proportionnelles obéit à f(x) = ax.»

Voici ta première **fonction** : un procédé qui, à chaque nombre x, associe un nombre f(x). La plus simple et la plus utile est la **fonction linéaire**, celle de la proportionnalité. Tu apprends à la reconnaître, à la représenter par une droite, à lire un graphique et à l''utiliser pour les pourcentages. C''est la porte d''entrée d''un thème majeur des mathématiques.

## 📈 Qu''est-ce qu''une fonction linéaire ?

Soit a un réel fixé. La fonction qui, à chaque réel x, associe le réel **ax** est une **fonction linéaire**. On la note :

$$ f : x ↦ ax $$

- **a** est le **coefficient** de f ;
- **f(x) = ax** est l''**image** de x par f ;
- x est un **antécédent** de f(x).

_Exemple détaillé_ : pour f : x ↦ 3x, l''image de 2 est f(2) = 3 × 2 = 6. Pour trouver l''antécédent de 12, on résout 3x = 12, soit x = 4 : l''antécédent de 12 est 4.

## 🔑 Les propriétés caractéristiques

Toute fonction linéaire f : x ↦ ax vérifie :

$$ f(0) = 0 et f(1) = a $$

De plus, elle « respecte l''addition » : pour tous réels x et x'', f(x + x'') = f(x) + f(x'').

_Exemple détaillé_ : le coefficient est l''image de 1. Donc si l''on connaît f(1), on connaît a. Réciproquement, si une fonction vérifie f(0) ≠ 0, elle **n''est pas** linéaire.

> 🗡️ Pour trouver le coefficient à partir d''une image connue : a = f(x) / x. Par exemple, si f(5) = 15, alors a = 15/5 = 3, et f : x ↦ 3x.

## 📉 La représentation graphique

Dans un repère (O, I, J), la représentation graphique de f : x ↦ ax est une **droite qui passe par l''origine O**, d''équation :

$$ y = ax $$

Cette droite passe aussi par le point A(1 ; a). Il suffit donc de deux points — O et A(1 ; a) — pour la tracer.

_Exemple détaillé_ : la fonction f : x ↦ 2x est représentée par la droite d''équation y = 2x, passant par O(0 ; 0) et par A(1 ; 2).

> ⚠️ La droite d''une fonction linéaire passe **toujours** par l''origine (car f(0) = 0). Si une droite ne passe pas par O, elle ne représente pas une fonction linéaire (ce sera une fonction affine, au chapitre 14).

## 🔍 Lire un graphique

Sur la droite d''une fonction linéaire, on lit directement :

- l''**image** d''un nombre : on part de x sur l''axe des abscisses, on monte jusqu''à la droite, on lit y = f(x) ;
- l''**antécédent** d''un nombre : on part de y sur l''axe des ordonnées, on rejoint la droite, on lit x ;
- le **coefficient** a : à partir d''un point M(x ; y) de la droite, a = y/x.

_Exemple détaillé_ : si la droite passe par le point M(4 ; 6), alors a = 6/4 = 1,5, donc f : x ↦ 1,5x.

## 💯 Fonctions linéaires et pourcentages

Augmenter ou diminuer d''un pourcentage, c''est appliquer une fonction linéaire :

- une **hausse de t %** correspond à f : x ↦ (1 + t/100) x ;
- une **baisse de t %** correspond à f : x ↦ (1 − t/100) x.

_Exemple détaillé_ : une hausse de 20 % multiplie par 1,2 (f : x ↦ 1,2x) ; une baisse de 15 % multiplie par 0,85 (f : x ↦ 0,85x). Deux variations **successives** se composent : une baisse de 10 % suivie d''une hausse de 10 % donne × 0,9 × 1,1 = × 0,99, soit une baisse nette de 1 % (et non un retour au prix initial !).

> 🏆 Douzième quête franchie, héros : tu manies la proportionnalité en fonction, tu la lis sur une droite et tu domptes les pourcentages. Bientôt, tu généraliseras avec les fonctions affines. Place d''abord aux équations et inéquations.', '# 📜 Résumé : Fonctions linéaires

- **Définition** : f : x ↦ ax (a = coefficient). f(x) = ax est l''image de x ; x est un antécédent de f(x). Ex. f : x ↦ 3x donne f(2) = 6.
- **Propriétés caractéristiques** : f(0) = 0 et f(1) = a ; f(x + x'') = f(x) + f(x''). Le coefficient se calcule par a = f(x)/x (ex. f(5) = 15 ⟹ a = 3).
- **Représentation graphique** : droite passant par l''origine O, d''équation y = ax, et par le point A(1 ; a). Deux points (O et A) suffisent à la tracer.
- **Lecture graphique** : image (de x vers la droite puis vers y), antécédent (de y vers la droite puis vers x), coefficient a = y/x à partir d''un point M(x ; y) de la droite.
- **Pourcentages** : hausse de t % ⟹ × (1 + t/100) ; baisse de t % ⟹ × (1 − t/100). Deux variations successives se composent (ex. −10 % puis +10 % donne × 0,99, soit −1 % net).', 12, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d47dc4b0-b18d-51a7-aff1-fd797f002c14', '15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', 'math-1ere-sec', 'Test de compréhension ⭐ : Angles', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d285fe0d-a649-59ec-9b9b-260fdfeeaf7b', 'd47dc4b0-b18d-51a7-aff1-fd797f002c14', 'Dans un triangle, un angle extérieur est égal à :', '[{"id":"a","text":"La somme des deux angles intérieurs qui ne lui sont pas adjacents"},{"id":"b","text":"L''angle intérieur qui lui est adjacent"},{"id":"c","text":"La somme des trois angles intérieurs du triangle"},{"id":"d","text":"90° dans tous les cas"}]'::jsonb, 'a', 'Un angle extérieur est égal à la somme des deux angles intérieurs non adjacents ✓. Il est supplémentaire (et non égal) à l''angle intérieur adjacent, donc la réponse b est fausse. La somme des trois angles intérieurs vaut toujours 180°, pas l''angle extérieur (réponse c). Et rien n''impose 90° (réponse d) : cela n''arrive que dans un cas très particulier.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e2413add-c559-5006-9763-b2e6c0ca9c89', 'd47dc4b0-b18d-51a7-aff1-fd797f002c14', 'Deux droites parallèles sont coupées par une sécante. Que peut-on dire de deux angles alternes-internes ?', '[{"id":"a","text":"Ils sont égaux"},{"id":"b","text":"Ils sont supplémentaires (somme 180°)"},{"id":"c","text":"Ils sont complémentaires (somme 90°)"},{"id":"d","text":"Leur somme vaut toujours 360°"}]'::jsonb, 'a', 'Avec deux droites parallèles, les angles alternes-internes sont égaux ✓. Ce sont les angles intérieurs d''un même côté qui sont supplémentaires (réponse b) — à ne pas confondre. La complémentarité (réponse c) et la somme 360° (réponse d) ne correspondent à aucune des trois relations du cours.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73a94e94-6f1f-5b60-a634-b25f85ed89f9', 'd47dc4b0-b18d-51a7-aff1-fd797f002c14', 'Une sécante coupe deux droites en formant deux angles correspondants de même mesure. Que peut-on en conclure ?', '[{"id":"a","text":"Les deux droites sont parallèles"},{"id":"b","text":"Les deux droites sont perpendiculaires"},{"id":"c","text":"Les deux droites sont sécantes"},{"id":"d","text":"On ne peut rien conclure sans mesurer les côtés"}]'::jsonb, 'a', 'C''est la réciproque du cours : des angles correspondants égaux entraînent le parallélisme des deux droites ✓. Rien n''indique un angle droit, donc « perpendiculaires » (réponse b) est faux ; « sécantes » (réponse c) est le contraire de la conclusion ; et l''égalité des angles suffit à conclure, sans mesurer de longueur (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b37fb80-e700-5e9e-8e2e-f1a963e25b35', 'd47dc4b0-b18d-51a7-aff1-fd797f002c14', 'A, B et M sont sur un cercle de centre O. L''angle au centre AOB et l''angle inscrit AMB interceptent le même arc [AB]. Quelle relation les lie ?', '[{"id":"a","text":"AMB = AOB / 2 (l''angle inscrit est la moitié de l''angle au centre)"},{"id":"b","text":"AMB = 2 × AOB (l''angle inscrit est le double de l''angle au centre)"},{"id":"c","text":"AMB = AOB (ils sont toujours égaux)"},{"id":"d","text":"AMB = 90° − AOB"}]'::jsonb, 'a', 'Un angle inscrit vaut la moitié de l''angle au centre qui intercepte le même arc : AMB = AOB / 2 ✓. La réponse b inverse le rapport (c''est l''angle au centre qui est le double). L''égalité de la réponse c ne vaut qu''entre deux angles inscrits d''un même arc, pas entre inscrit et centre. La réponse d invente une relation de complémentarité qui n''existe pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9a7a2e73-214f-5f5d-8dad-a8d7919519a0', 'd47dc4b0-b18d-51a7-aff1-fd797f002c14', 'Le triangle ABC est inscrit dans un cercle et le côté [BC] est un diamètre de ce cercle. Que peut-on affirmer ?', '[{"id":"a","text":"Le triangle ABC est rectangle en A"},{"id":"b","text":"Le triangle ABC est rectangle en B"},{"id":"c","text":"Le triangle ABC est équilatéral"},{"id":"d","text":"Le triangle ABC est isocèle en A"}]'::jsonb, 'a', 'Quand un côté est un diamètre du cercle circonscrit, l''angle droit se trouve au sommet opposé à ce côté : ici [BC] est le diamètre, donc l''angle droit est en A ✓. Les réponses b (angle droit en B, une extrémité du diamètre) et d (isocèle) confondent le sommet concerné ou la nature du triangle ; rien n''impose que les trois côtés soient égaux (réponse c).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5b96fcd8-5d95-5575-85ac-ff19598c617e', '15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', 'math-1ere-sec', '⭐ Exercice : Premières mesures d''angles', 1, 50, 10, 'practice', 'admin', 1)
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
  ('670f4bd7-d3ef-5fe7-882c-3caab050f965', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Dans un triangle ABC, on a BAC = 55° et ABC = 65°. Combien vaut l''angle ACB ?', '[{"id":"a","text":"60°"},{"id":"b","text":"120°"},{"id":"c","text":"125°"},{"id":"d","text":"50°"}]'::jsonb, 'a', 'La somme des angles d''un triangle vaut 180°, donc ACB = 180° − 55° − 65° = 60° ✓. Répondre 120° donne la somme des deux angles connus au lieu du troisième ; 125° revient à ne soustraire que 55° (180° − 55°) ; 50° est une erreur de calcul.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77164441-8214-5d03-aa87-a8790339e0aa', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Dans un triangle ABC, on prolonge le côté [BC] au-delà de C. L''angle extérieur en C est noté ACD. Si BAC = 40° et ABC = 75°, combien vaut ACD ?', '[{"id":"a","text":"115°"},{"id":"b","text":"65°"},{"id":"c","text":"90°"},{"id":"d","text":"35°"}]'::jsonb, 'a', 'Un angle extérieur est la somme des deux angles intérieurs non adjacents : ACD = BAC + ABC = 40° + 75° = 115° ✓. La valeur 65° est l''angle intérieur ACB (= 180° − 115°), pas l''angle extérieur ; 90° et 35° (soit 75° − 40°) ne correspondent à aucune règle du cours.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e5ab50f1-deb8-55e5-8157-eddd648249d1', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Les droites (d) et (d'') sont parallèles et coupées par une sécante. L''un des angles formés vaut 72°. Combien vaut son angle alterne-interne ?', '[{"id":"a","text":"72°"},{"id":"b","text":"108°"},{"id":"c","text":"18°"},{"id":"d","text":"36°"}]'::jsonb, 'a', 'Avec deux droites parallèles, les angles alternes-internes sont égaux : l''alterne-interne vaut aussi 72° ✓. 108° serait le supplémentaire (180° − 72°, c''est l''angle intérieur d''un même côté) ; 18° est le complémentaire ; 36° est la moitié — aucune de ces relations ne s''applique aux alternes-internes.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a8ceb12f-18af-5b44-8a64-aab661bcc934', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Deux droites parallèles sont coupées par une sécante. Un angle intérieur vaut 110°. Combien vaut l''angle intérieur situé du même côté de la sécante ?', '[{"id":"a","text":"70°"},{"id":"b","text":"110°"},{"id":"c","text":"90°"},{"id":"d","text":"55°"}]'::jsonb, 'a', 'Deux angles intérieurs d''un même côté d''une sécante entre deux parallèles sont supplémentaires : 180° − 110° = 70° ✓. Répondre 110° les traite comme égaux (ce qui vaut pour les alternes-internes ou les correspondants, pas ici) ; 90° et 55° (la moitié) ne correspondent à aucune règle.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6346b5b1-c7a4-57fc-93a7-caea03adc76f', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Sur un cercle de centre O, l''angle au centre AOB vaut 84°. Un point M du cercle est tel que l''angle inscrit AMB intercepte le même arc [AB]. Combien vaut AMB ?', '[{"id":"a","text":"42°"},{"id":"b","text":"84°"},{"id":"c","text":"168°"},{"id":"d","text":"138°"}]'::jsonb, 'a', 'L''angle inscrit vaut la moitié de l''angle au centre qui intercepte le même arc : AMB = 84° / 2 = 42° ✓. 84° reprend l''angle au centre sans le diviser par deux ; 168° le double au lieu de le diviser ; 138° (= 180° − 42°) applique une relation de supplémentarité qui n''a pas lieu d''être.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18bc3295-0937-5961-b296-286a45588f48', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'Le triangle ABC est inscrit dans un cercle et le côté [BC] en est un diamètre. On sait que ABC = 28°. Combien vaut l''angle ACB ?', '[{"id":"a","text":"62°"},{"id":"b","text":"152°"},{"id":"c","text":"90°"},{"id":"d","text":"28°"}]'::jsonb, 'a', '[BC] est un diamètre, donc le triangle est rectangle en A : BAC = 90°. D''où ACB = 180° − 90° − 28° = 62° ✓. 152° (= 180° − 28°) oublie de retirer l''angle droit ; 90° place l''angle droit au mauvais sommet ; 28° recopie l''angle donné.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d805ccf7-d0ae-5ae3-985f-31a4bfc87e17', '15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Angles, parallèles et cercle', 2, 75, 15, 'practice', 'admin', 3)
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
  ('66b5185a-77fc-56b2-bb0c-35bb9da60c8e', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'Le triangle ABC est isocèle en A avec BAC = 40°. On prolonge le côté [AB] au-delà de B. Combien vaut l''angle extérieur ainsi formé en B ?', '[{"id":"a","text":"110°"},{"id":"b","text":"70°"},{"id":"c","text":"140°"},{"id":"d","text":"40°"}]'::jsonb, 'a', 'Le triangle étant isocèle en A, les angles de base sont égaux : ABC = ACB = (180° − 40°) / 2 = 70°. L''angle extérieur en B est supplémentaire de ABC : 180° − 70° = 110° ✓ (on retrouve bien BAC + ACB = 40° + 70° = 110°). 70° est l''angle intérieur ABC ; 140° est l''angle extérieur en A (180° − 40°) ; 40° recopie l''angle au sommet.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e8ae2ad-e939-5769-8828-ae1efe8a344a', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'A, B, M et N sont quatre points d''un même cercle. Les angles inscrits AMB et ANB interceptent le même arc [AB]. Si AMB = 37°, combien vaut ANB ?', '[{"id":"a","text":"37°"},{"id":"b","text":"74°"},{"id":"c","text":"53°"},{"id":"d","text":"143°"}]'::jsonb, 'a', 'Deux angles inscrits qui interceptent le même arc sont égaux : ANB = AMB = 37° ✓. 74° double la mesure (confusion avec l''angle au centre) ; 53° (= 90° − 37°) invente une complémentarité ; 143° (= 180° − 37°) invente une supplémentarité.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b5607ac8-472a-53ba-9772-b3464358dad7', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'Sur un cercle de centre O, l''angle inscrit BAC vaut 35° et intercepte l''arc [BC]. Combien vaut l''angle au centre BOC qui intercepte le même arc ?', '[{"id":"a","text":"70°"},{"id":"b","text":"35°"},{"id":"c","text":"17,5°"},{"id":"d","text":"145°"}]'::jsonb, 'a', 'L''angle au centre est le double de l''angle inscrit qui intercepte le même arc : BOC = 2 × 35° = 70° ✓. 35° les prend égaux (relation réservée à deux angles inscrits) ; 17,5° divise encore par deux au lieu de multiplier ; 145° (= 180° − 35°) applique une supplémentarité sans objet.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f1abc7bc-5fc9-5b3c-a89a-e0d6e4fff9a0', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'Le triangle ABC est inscrit dans un cercle dont [AB] est un diamètre. De plus, ce triangle est isocèle avec CA = CB. Combien vaut l''angle ABC ?', '[{"id":"a","text":"45°"},{"id":"b","text":"90°"},{"id":"c","text":"60°"},{"id":"d","text":"30°"}]'::jsonb, 'a', '[AB] est un diamètre, donc le triangle est rectangle en C : ACB = 90°. Comme CA = CB, il est isocèle en C, donc les deux angles à la base sont égaux : ABC = CAB = (180° − 90°) / 2 = 45° ✓. 90° place l''angle droit au mauvais sommet ; 60° supposerait le triangle équilatéral (impossible avec un angle droit) ; 30° est une répartition erronée des 90° restants.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a749ceb8-fb9e-5765-a105-7b1a04b6d50f', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'Depuis un point A extérieur à un cercle de centre O, on trace une tangente qui touche le cercle en T. Que peut-on affirmer ?', '[{"id":"a","text":"OTA = 90° (le rayon [OT] est perpendiculaire à la tangente), donc T voit [OA] sous un angle droit : T appartient au cercle de diamètre [OA]"},{"id":"b","text":"OTA = 45°, car la tangente coupe le rayon en son milieu"},{"id":"c","text":"OTA = 90°, mais le point T n''a aucun lien avec le cercle de diamètre [OA]"},{"id":"d","text":"La mesure de OTA dépend de la longueur OA"}]'::jsonb, 'a', 'Le rayon aboutissant au point de contact est perpendiculaire à la tangente : OTA = 90° ✓. Comme T voit le segment [OA] sous un angle droit, il appartient au cercle de diamètre [OA] — c''est exactement le lieu des points voyant [OA] sous 90°, ce qui fournit la construction des tangentes. La réponse c oublie ce lieu géométrique, b invente un milieu, et d ignore que la perpendicularité est vraie quelle que soit la distance OA.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('637af2aa-fc0c-5f8e-808a-711d6626a480', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', 'Sur un cercle de centre O, l''angle inscrit BAC vaut 50° et intercepte l''arc [BC]. En passant par l''angle au centre BOC, détermine la mesure de l''angle OBC dans le triangle OBC (isocèle en O).', '[{"id":"a","text":"40°"},{"id":"b","text":"50°"},{"id":"c","text":"100°"},{"id":"d","text":"25°"}]'::jsonb, 'a', 'L''angle au centre vaut le double de l''angle inscrit : BOC = 2 × 50° = 100°. Le triangle OBC est isocèle en O (OB = OC, rayons), donc OBC = OCB = (180° − 100°) / 2 = 40° ✓. 100° s''arrête à l''angle au centre ; 50° recopie l''angle inscrit ; 25° prend la moitié de 50° au lieu de mener le calcul dans le triangle isocèle.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('776d1dc2-d59c-5465-8223-e3c1f19c52f9', '1d85914e-62d3-50ce-943e-1b77a49bb180', 'math-1ere-sec', 'Test de compréhension ⭐ : Théorème de Thalès', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('764a693e-3867-5b8a-ad9f-a42528c44dec', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', 'Dans un triangle ABC, I et J sont les milieux respectifs de [AB] et [AC]. Que peut-on affirmer sur la droite (IJ) ?', '[{"id":"a","text":"(IJ) est parallèle à (BC) et IJ = BC / 2"},{"id":"b","text":"(IJ) est perpendiculaire à (BC)"},{"id":"c","text":"IJ = BC"},{"id":"d","text":"(IJ) passe par le milieu de [BC]"}]'::jsonb, 'a', 'C''est le théorème de la droite des milieux : (IJ) // (BC) et IJ vaut la moitié de BC ✓. Rien n''indique un angle droit (réponse b). IJ = BC (réponse c) oublie le facteur 1/2. La droite (IJ) ne rencontre pas [BC] : elle lui est parallèle, donc la réponse d est fausse.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('216481af-765a-54ee-af1a-db4150a6eaa9', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', 'Dans un triangle ABC, M est sur (AB), N est sur (AC) et (MN) // (BC). Quelle égalité traduit le théorème de Thalès ?', '[{"id":"a","text":"AM/AB = AN/AC = MN/BC"},{"id":"b","text":"AM/AB = AN/AC = BC/MN"},{"id":"c","text":"AB/AM = AC/AN = MN/BC"},{"id":"d","text":"AM/AN = AB/AC = MN/BC"}]'::jsonb, 'a', 'Les trois rapports comparent la petite figure à la grande, toujours dans le même sens : AM/AB = AN/AC = MN/BC ✓. La réponse b inverse le dernier rapport (BC/MN) ; la réponse c inverse les deux premiers ; la réponse d mélange des longueurs qui ne se correspondent pas (AM avec AN).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c4b28f7f-bd59-5ed6-becb-9ce4553dc584', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', 'Une figure est reproduite à l''échelle k = 0,5. Que subit-elle ?', '[{"id":"a","text":"Une réduction : ses longueurs sont divisées par 2"},{"id":"b","text":"Un agrandissement : ses longueurs sont multipliées par 2"},{"id":"c","text":"Aucun changement de taille"},{"id":"d","text":"Seule son aire change, pas ses longueurs"}]'::jsonb, 'a', 'Une échelle comprise entre 0 et 1 est une réduction : multiplier par 0,5 revient à diviser les longueurs par 2 ✓. La réponse b décrit une échelle k = 2 (agrandissement) ; k = 0,5 ≠ 1 donc la taille change (réponse c fausse) ; et l''échelle agit d''abord sur les longueurs, pas seulement sur l''aire (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('479c92f3-14d0-53ae-9e25-9a1bd0d1f89b', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', 'Dans un triangle ABC, M appartient à [AB] et N à [AC]. Quelle condition permet d''affirmer que (MN) est parallèle à (BC) ?', '[{"id":"a","text":"AM/AB = AN/AC, avec M et N placés dans le même ordre à partir de A"},{"id":"b","text":"AM = AN"},{"id":"c","text":"MN = BC"},{"id":"d","text":"AM + AN = AB + AC"}]'::jsonb, 'a', 'C''est la réciproque de Thalès : l''égalité des rapports AM/AB = AN/AC (points dans le même ordre) entraîne le parallélisme ✓. L''égalité des longueurs AM = AN (réponse b) ne dit rien sur les rapports si AB ≠ AC ; MN = BC (réponse c) est faux dès qu''il y a réduction ; la somme de la réponse d n''a aucun sens géométrique ici.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77890e76-b136-5311-a899-e23395450742', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', 'On agrandit une figure à l''échelle k = 2. Par combien son aire est-elle multipliée ?', '[{"id":"a","text":"4"},{"id":"b","text":"2"},{"id":"c","text":"8"},{"id":"d","text":"L''aire ne change pas"}]'::jsonb, 'a', 'Une échelle k multiplie les longueurs par k mais l''aire par k² : ici k² = 2² = 4 ✓. Répondre 2 confond l''aire avec les longueurs (facteur k) ; 8 correspondrait à k³ (un volume) ; et l''aire change bien, contrairement à la réponse d.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3f648e0b-bac9-5e26-88c2-f361e5208d9e', '1d85914e-62d3-50ce-943e-1b77a49bb180', 'math-1ere-sec', '⭐ Exercice : Rapports de Thalès en action', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d53aebe8-b1fa-5a8b-b4df-93fc9a0ec009', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Dans un triangle ABC, I et J sont les milieux respectifs de [AB] et [AC]. Si BC = 14 cm, combien vaut IJ ?', '[{"id":"a","text":"7 cm"},{"id":"b","text":"14 cm"},{"id":"c","text":"28 cm"},{"id":"d","text":"3,5 cm"}]'::jsonb, 'a', 'La droite des milieux mesure la moitié du troisième côté : IJ = BC / 2 = 14 / 2 = 7 cm ✓. 14 cm oublie de diviser par deux ; 28 cm double au lieu de diviser ; 3,5 cm divise par quatre.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18b8e0cd-b2a4-575d-95c9-acda7a27760c', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Dans un triangle ABC, M est sur [AB], N sur [AC] et (MN) // (BC). On donne AB = 8 cm, AM = 6 cm et BC = 12 cm. Combien vaut MN ?', '[{"id":"a","text":"9 cm"},{"id":"b","text":"16 cm"},{"id":"c","text":"6 cm"},{"id":"d","text":"8 cm"}]'::jsonb, 'a', 'Le coefficient de Thalès est AM/AB = 6/8 = 3/4, donc MN = BC × 3/4 = 12 × 3/4 = 9 cm ✓. 16 cm vient d''inverser le rapport (12 × 8/6) ; 6 cm recopie AM ; 8 cm recopie AB.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4a668275-6d7c-5465-9021-d137579e6cbf', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Dans un triangle ABC, M est sur [AB], N sur [AC] et (MN) // (BC). On donne AB = 10 cm, AM = 4 cm et AC = 15 cm. Combien vaut AN ?', '[{"id":"a","text":"6 cm"},{"id":"b","text":"37,5 cm"},{"id":"c","text":"9 cm"},{"id":"d","text":"4 cm"}]'::jsonb, 'a', 'Par Thalès, AN/AC = AM/AB, donc AN = AC × AM/AB = 15 × 4/10 = 6 cm ✓. 37,5 cm inverse le rapport (15 × 10/4) ; 9 cm calcule AC − AN au lieu de AN ; 4 cm recopie AM.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9c457a2-f786-506e-9305-2479a40da662', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Un segment de 5 cm est agrandi à l''échelle k = 3. Quelle est sa nouvelle longueur ?', '[{"id":"a","text":"15 cm"},{"id":"b","text":"8 cm"},{"id":"c","text":"45 cm"},{"id":"d","text":"1,67 cm"}]'::jsonb, 'a', 'Une échelle multiplie les longueurs par k : 5 × 3 = 15 cm ✓. 8 cm additionne au lieu de multiplier (5 + 3) ; 45 cm multiplie par k² = 9 (effet réservé aux aires) ; 1,67 cm divise par 3 au lieu de multiplier.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c005dd7f-adc0-5960-ad84-0a8799f68255', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Un rectangle a une aire de 6 cm². On le reproduit à l''échelle k = 2. Quelle est l''aire de la reproduction ?', '[{"id":"a","text":"24 cm²"},{"id":"b","text":"12 cm²"},{"id":"c","text":"6 cm²"},{"id":"d","text":"36 cm²"}]'::jsonb, 'a', 'Une échelle k multiplie l''aire par k² : 6 × 2² = 6 × 4 = 24 cm² ✓. 12 cm² multiplie par k (erreur classique) ; 6 cm² laisse l''aire inchangée ; 36 cm² élève l''aire elle-même au carré, ce qui n''a pas de sens.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('17592f6d-4d2b-5a43-af4a-20fdbd30811b', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', 'Dans un triangle ABC, M est sur [AB] et N sur [AC] avec AB = 12, AM = 8, AC = 9 et AN = 6. Les droites (MN) et (BC) sont-elles parallèles ?', '[{"id":"a","text":"Oui, car AM/AB = AN/AC = 2/3"},{"id":"b","text":"Non, car AM ≠ AN"},{"id":"c","text":"Non, car AB ≠ AC"},{"id":"d","text":"On ne peut pas le savoir sans mesurer les angles"}]'::jsonb, 'a', 'On compare les rapports : AM/AB = 8/12 = 2/3 et AN/AC = 6/9 = 2/3. Ils sont égaux, donc par la réciproque de Thalès (MN) // (BC) ✓. Le parallélisme se lit sur les rapports, pas sur l''égalité des longueurs AM et AN (réponse b) ni sur AB et AC (réponse c) ; il n''est pas nécessaire de mesurer un angle (réponse d).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4b48f1c0-b761-569b-ae0d-e716dbf12bb9', '1d85914e-62d3-50ce-943e-1b77a49bb180', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Thalès, échelles et proportions', 2, 75, 15, 'practice', 'admin', 3)
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
  ('2dae05ea-9009-5914-894d-e75db10699f8', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'Dans un triangle ABC, M est sur [AB] et N sur [AC] avec (MN) // (BC). On donne AM = 3 cm, MB = 2 cm et MN = 6 cm. Combien vaut BC ?', '[{"id":"a","text":"10 cm"},{"id":"b","text":"3,6 cm"},{"id":"c","text":"4 cm"},{"id":"d","text":"15 cm"}]'::jsonb, 'a', 'On a AB = AM + MB = 5, donc le coefficient est AM/AB = 3/5. Comme MN/BC = 3/5, on obtient BC = MN × 5/3 = 6 × 5/3 = 10 cm ✓. 3,6 cm applique le rapport dans le mauvais sens (6 × 3/5) ; 4 cm soustrait MB ; 15 cm utilise le rapport 5/2.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('acf01e4b-a18c-56a9-b2ab-abdf02df8488', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'Dans un triangle ABC, I est le milieu de [AB]. La parallèle à (BC) passant par I coupe [AC] en J. Que peut-on affirmer sur J ?', '[{"id":"a","text":"J est le milieu de [AC]"},{"id":"b","text":"J est tel que AJ = AC / 3"},{"id":"c","text":"J est le milieu de [AB]"},{"id":"d","text":"On ne peut rien conclure sur J"}]'::jsonb, 'a', 'C''est la réciproque de la droite des milieux : une parallèle à un côté passant par le milieu d''un deuxième côté coupe le troisième en son milieu, donc J est le milieu de [AC] ✓. Le rapport 1/3 (réponse b) est inventé ; J est sur [AC], pas sur [AB] (réponse c) ; et le théorème permet bien de conclure (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5783b0b1-59a0-5c39-819f-5d423d584556', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'Un triangle a pour côtés 3 cm, 4 cm et 5 cm ; son aire vaut 6 cm². Un triangle semblable a son plus petit côté égal à 9 cm. Quelle est l''aire de ce grand triangle ?', '[{"id":"a","text":"54 cm²"},{"id":"b","text":"18 cm²"},{"id":"c","text":"6 cm²"},{"id":"d","text":"486 cm²"}]'::jsonb, 'a', 'L''échelle est k = 9/3 = 3 ; l''aire est multipliée par k² = 9, donc 6 × 9 = 54 cm² ✓. 18 cm² multiplie par k = 3 (erreur classique sur les aires) ; 6 cm² oublie l''agrandissement ; 486 cm² multiplie par k⁴ = 81.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a918ddb6-255d-534d-ab95-903d4903d01a', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'On veut placer le point M sur [AB] tel que AM/MB = 3/2. Par la construction de Thalès, en combien de parts égales partage-t-on [AB], et où se trouve M ?', '[{"id":"a","text":"En 5 parts égales ; M est au 3ᵉ point de division depuis A"},{"id":"b","text":"En 5 parts égales ; M est au 2ᵉ point de division depuis A"},{"id":"c","text":"En 6 parts égales ; M est au 3ᵉ point"},{"id":"d","text":"En 3 parts égales ; M est au dernier point"}]'::jsonb, 'a', 'Le rapport 3/2 impose 3 + 2 = 5 parts égales ; M sépare la 3ᵉ de la 4ᵉ part, donc il est au 3ᵉ point depuis A (alors AM = 3 parts et MB = 2 parts) ✓. Le 2ᵉ point (réponse b) donnerait AM/MB = 2/3 ; 6 parts (réponse c) et 3 parts (réponse d) ne respectent pas la somme 3 + 2.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7f3a3309-5193-5bf2-befd-1e43093bc1c8', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'Un bâton vertical de 1,2 m projette une ombre de 0,8 m. Au même instant, un arbre projette une ombre de 15 m. Par proportionnalité (configuration de Thalès), quelle est la hauteur de l''arbre ?', '[{"id":"a","text":"22,5 m"},{"id":"b","text":"10 m"},{"id":"c","text":"18 m"},{"id":"d","text":"12,5 m"}]'::jsonb, 'a', 'Le bâton et l''arbre forment des triangles semblables : hauteur/ombre est constant. Le rapport hauteur/ombre du bâton vaut 1,2/0,8 = 1,5, donc la hauteur de l''arbre = 15 × 1,5 = 22,5 m ✓. 10 m inverse le rapport (15 × 0,8/1,2) ; 18 m multiplie par 1,2 en oubliant l''ombre du bâton ; 12,5 m est une estimation sans calcul.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1e58bb0d-50f8-5b28-bf82-89e9b7467512', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', 'Dans un triangle ABC, M est sur [AB] avec AM = (2/3)AB. La parallèle à (BC) passant par M coupe [AC] en N. Sachant que AC = 12 cm, combien vaut NC ?', '[{"id":"a","text":"4 cm"},{"id":"b","text":"8 cm"},{"id":"c","text":"12 cm"},{"id":"d","text":"6 cm"}]'::jsonb, 'a', 'Par Thalès, AN/AC = AM/AB = 2/3, donc AN = 12 × 2/3 = 8 cm ; il reste NC = AC − AN = 12 − 8 = 4 cm ✓. 8 cm est la longueur AN (on a oublié de retrancher) ; 12 cm recopie AC ; 6 cm prendrait la moitié de AC au lieu du bon rapport.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('84215a2f-6db5-5f6e-ad09-a9f101cd50ab', '7c588ba8-cc30-53da-8702-cd8365c0c879', 'math-1ere-sec', 'Test de compréhension ⭐ : Rapports trigonométriques', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d349fe65-986a-5603-ae50-e032deccd78f', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'Dans un triangle ABC rectangle en A, le cosinus de l''angle B est égal à :', '[{"id":"a","text":"AB/BC"},{"id":"b","text":"AC/BC"},{"id":"c","text":"AC/AB"},{"id":"d","text":"BC/AB"}]'::jsonb, 'a', 'Le cosinus est le rapport du côté adjacent sur l''hypoténuse : pour l''angle B, l''adjacent est [AB] et l''hypoténuse [BC], donc cos B = AB/BC ✓. AC/BC est le sinus de B (opposé/hypoténuse) ; AC/AB est sa tangente (opposé/adjacent) ; BC/AB inverse un rapport (l''hypoténuse ne va jamais au numérateur d''un cosinus).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('15aab741-a4ca-5292-a15d-7c77c9715783', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'Dans un triangle rectangle, le sinus d''un angle aigu est le rapport :', '[{"id":"a","text":"du côté opposé sur l''hypoténuse"},{"id":"b","text":"du côté adjacent sur l''hypoténuse"},{"id":"c","text":"du côté opposé sur le côté adjacent"},{"id":"d","text":"de l''hypoténuse sur le côté opposé"}]'::jsonb, 'a', 'Sinus = Opposé / Hypoténuse (le S du mémo SOH) ✓. Le rapport adjacent/hypoténuse est le cosinus ; opposé/adjacent est la tangente ; et hypoténuse/opposé est l''inverse du sinus, qui n''a pas de nom au programme.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('240a91a4-545d-55f7-8429-ff6c47d81db0', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'Pour tout angle aigu a, quelle égalité est toujours vraie ?', '[{"id":"a","text":"(sin a)² + (cos a)² = 1"},{"id":"b","text":"sin a + cos a = 1"},{"id":"c","text":"(sin a)² − (cos a)² = 1"},{"id":"d","text":"sin a × cos a = 1"}]'::jsonb, 'a', 'C''est la relation fondamentale : (sin a)² + (cos a)² = 1 ✓ (elle découle du théorème de Pythagore). La somme simple sin a + cos a (réponse b) n''est pas constante ; la différence des carrés (réponse c) et le produit (réponse d) ne valent pas 1 en général.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fb2e2b96-6a01-58fd-997f-155f9d682d54', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'Combien vaut cos 60° ?', '[{"id":"a","text":"1/2"},{"id":"b","text":"√3/2"},{"id":"c","text":"√2/2"},{"id":"d","text":"√3"}]'::jsonb, 'a', 'Dans la table des angles remarquables, cos 60° = 1/2 ✓. √3/2 est cos 30° (ou sin 60°) ; √2/2 est cos 45° ; √3 est tan 60°. On peut vérifier par la complémentarité : cos 60° = sin 30° = 1/2.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c741e82-276f-550f-a42e-efc47a7739ed', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'Dans un triangle ABC rectangle en A, H est le pied de la hauteur issue de A sur [BC]. Quelle relation métrique est correcte ?', '[{"id":"a","text":"AB × AC = AH × BC"},{"id":"b","text":"AB × AC = AH × AH"},{"id":"c","text":"AH = AB + AC"},{"id":"d","text":"AH² = HB + HC"}]'::jsonb, 'a', 'L''aire du triangle se calcule de deux façons ((AB × AC)/2 avec l''angle droit, ou (AH × BC)/2 avec l''hypoténuse comme base), d''où AB × AC = AH × BC ✓. La réponse b remplace BC par AH ; la hauteur n''est pas une somme de côtés (réponse c) ; et la bonne relation de la hauteur est AH² = HB × HC (un produit, pas une somme — réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b50207c5-1330-51d4-8cd5-bffd7ee39c4b', '7c588ba8-cc30-53da-8702-cd8365c0c879', 'math-1ere-sec', '⭐ Exercice : Cosinus, sinus, tangente en action', 1, 50, 10, 'practice', 'admin', 1)
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
  ('6bda0794-a768-5cad-b7bd-9f861eb5cc0b', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Dans un triangle ABC rectangle en A, AB = 8 cm et BC = 17 cm. Combien vaut cos B ?', '[{"id":"a","text":"8/17"},{"id":"b","text":"17/8"},{"id":"c","text":"15/17"},{"id":"d","text":"8/15"}]'::jsonb, 'a', 'cos B = adjacent/hypoténuse = AB/BC = 8/17 ✓. 17/8 inverse le rapport ; 15/17 est le sinus de B (AC/BC, avec AC = √(17² − 8²) = 15) ; 8/15 est le rapport des deux côtés de l''angle droit, pas un cosinus.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4d977cc2-0e48-55de-b3b5-bf4a0069a1e2', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Dans un triangle ABC rectangle en A, AC = 15 cm et BC = 17 cm. Combien vaut sin B ?', '[{"id":"a","text":"15/17"},{"id":"b","text":"8/17"},{"id":"c","text":"17/15"},{"id":"d","text":"15/8"}]'::jsonb, 'a', 'sin B = opposé/hypoténuse = AC/BC = 15/17 ✓. 8/17 est le cosinus de B (AB/BC, avec AB = 8) ; 17/15 inverse le rapport ; 15/8 est la tangente de B, pas son sinus.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ae7e4c95-4ac8-56a7-be58-a32b77c3a037', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Dans un triangle rectangle en A, l''hypoténuse BC = 12 cm et l''angle B = 30°. Combien vaut AC, le côté opposé à B ?', '[{"id":"a","text":"6 cm"},{"id":"b","text":"12 cm"},{"id":"c","text":"10,4 cm"},{"id":"d","text":"24 cm"}]'::jsonb, 'a', 'Le côté opposé se calcule avec le sinus : AC = BC × sin 30° = 12 × 1/2 = 6 cm ✓. 10,4 cm utilise cos 30° (12 × √3/2) au lieu du sinus ; 12 cm oublie de multiplier par le rapport ; 24 cm multiplie par 2 au lieu de 1/2.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78524b2f-03dc-52a8-8325-121282a9fe9e', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Dans un triangle ABC rectangle en A, AB = 5 cm et AC = 12 cm. Combien vaut l''hypoténuse BC ?', '[{"id":"a","text":"13 cm"},{"id":"b","text":"17 cm"},{"id":"c","text":"7 cm"},{"id":"d","text":"169 cm"}]'::jsonb, 'a', 'Par le théorème de Pythagore, BC = √(AB² + AC²) = √(25 + 144) = √169 = 13 cm ✓. 17 cm additionne les côtés (5 + 12) ; 7 cm les soustrait ; 169 cm est BC² — on a oublié de prendre la racine carrée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('62a5aab3-407b-5275-a4c8-6ea8418aeb32', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Combien vaut tan 45° ?', '[{"id":"a","text":"1"},{"id":"b","text":"√2/2"},{"id":"c","text":"√3"},{"id":"d","text":"0"}]'::jsonb, 'a', 'Dans la table des angles remarquables, tan 45° = 1 ✓ (le triangle est rectangle isocèle, opposé = adjacent). √2/2 est sin 45° (ou cos 45°) ; √3 est tan 60° ; 0 serait tan 0°.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2852f4a1-2aca-5f72-8797-3d67c83130a6', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'Un angle aigu a vérifie cos a = 0,8. Combien vaut sin a ?', '[{"id":"a","text":"0,6"},{"id":"b","text":"0,2"},{"id":"c","text":"0,36"},{"id":"d","text":"1,25"}]'::jsonb, 'a', 'La relation fondamentale donne (sin a)² = 1 − (cos a)² = 1 − 0,64 = 0,36, donc sin a = √0,36 = 0,6 (positif car a est aigu) ✓. 0,2 fait 1 − 0,8 en oubliant les carrés ; 0,36 est (sin a)² sans racine ; 1,25 est 1/0,8, une valeur impossible (un sinus dépasserait 1).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fa2d2181-fa92-58b6-9f6e-d3256baa78ac', '7c588ba8-cc30-53da-8702-cd8365c0c879', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Résoudre le triangle rectangle', 2, 75, 15, 'practice', 'admin', 3)
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
  ('18b4ef50-4d0e-5ba3-b133-07dc1c374633', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle ABC rectangle en A, AB = 5 cm et BC = 10 cm. Combien vaut l''angle B ?', '[{"id":"a","text":"60°"},{"id":"b","text":"30°"},{"id":"c","text":"45°"},{"id":"d","text":"90°"}]'::jsonb, 'a', 'cos B = AB/BC = 5/10 = 1/2, et l''angle dont le cosinus vaut 1/2 est 60° ✓. 30° confond avec l''angle dont le sinus vaut 1/2 ; 45° donnerait cos = √2/2 ≈ 0,71 ; 90° est exclu car B est un angle aigu.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('39d071a2-6674-5bc6-b57f-71c8edb1ede7', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle rectangle en A, l''angle B = 60° et le côté adjacent AB = 4 cm. Combien vaut l''hypoténuse BC ?', '[{"id":"a","text":"8 cm"},{"id":"b","text":"2 cm"},{"id":"c","text":"6,93 cm"},{"id":"d","text":"6 cm"}]'::jsonb, 'a', 'cos B = AB/BC, donc BC = AB / cos 60° = 4 / (1/2) = 8 cm ✓. 2 cm multiplie par cos 60° au lieu de diviser (4 × 1/2) ; 6,93 cm (soit 4√3) utilise la tangente ; 6 cm est une estimation sans calcul.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8a82afc1-9f54-5be0-bdb8-5341127e633c', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle rectangle en A, l''angle B = 45° et le côté adjacent AB = 7 cm. Combien vaut le côté opposé AC ?', '[{"id":"a","text":"7 cm"},{"id":"b","text":"9,9 cm"},{"id":"c","text":"3,5 cm"},{"id":"d","text":"14 cm"}]'::jsonb, 'a', 'tan B = AC/AB, donc AC = AB × tan 45° = 7 × 1 = 7 cm ✓ (le triangle est rectangle isocèle). 9,9 cm (soit 7√2) est l''hypoténuse BC, pas le côté opposé ; 3,5 cm et 14 cm ne correspondent à aucune relation.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('26308c5b-3f4e-5170-8c1f-e22c01c325a8', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle ABC rectangle en A, on sait que sin B = 0,6. Combien vaut cos C ?', '[{"id":"a","text":"0,6"},{"id":"b","text":"0,8"},{"id":"c","text":"0,4"},{"id":"d","text":"0,36"}]'::jsonb, 'a', 'Les angles B et C sont complémentaires (B + C = 90°), donc le sinus de l''un égale le cosinus de l''autre : cos C = sin B = 0,6 ✓. 0,8 est cos B (= sin C) ; 0,4 fait 1 − 0,6 sans fondement ; 0,36 est (sin B)².', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('50538a6c-151f-5a1c-b006-1d84127ae939', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle ABC rectangle en A, AB = 6 cm et AC = 8 cm. H est le pied de la hauteur issue de A sur [BC]. Combien vaut AH ?', '[{"id":"a","text":"4,8 cm"},{"id":"b","text":"7 cm"},{"id":"c","text":"5 cm"},{"id":"d","text":"2,4 cm"}]'::jsonb, 'a', 'On calcule d''abord BC = √(6² + 8²) = 10, puis la relation AB × AC = AH × BC donne AH = (6 × 8)/10 = 4,8 cm ✓. 7 cm est la moyenne (6 + 8)/2 ; 5 cm est la moitié de l''hypoténuse ; 2,4 cm divise le bon résultat par deux.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fd5e917d-d34a-51f6-bc8c-22136676df0b', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', 'Dans un triangle ABC rectangle en A, l''hypoténuse BC = 25 cm et la projection BH du côté [AB] sur [BC] vaut 9 cm. Combien vaut AB ?', '[{"id":"a","text":"15 cm"},{"id":"b","text":"225 cm"},{"id":"c","text":"16 cm"},{"id":"d","text":"12 cm"}]'::jsonb, 'a', 'La relation métrique AB² = BH × BC donne AB² = 9 × 25 = 225, donc AB = √225 = 15 cm ✓. 225 cm est AB² sans racine carrée ; 16 cm fait 25 − 9 (ce serait la projection CH) ; 12 cm confond avec la hauteur AH.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('64d130ab-91b3-52f1-b923-72eb0d6b6b1d', '911d2611-f232-5e69-b326-4d2b66501742', 'math-1ere-sec', 'Test de compréhension ⭐ : Vecteurs et translations', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('742071d9-aa0f-50a7-951c-40726423ef50', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'Le vecteur AB est égal au vecteur CD si et seulement si :', '[{"id":"a","text":"les segments [AD] et [BC] ont le même milieu"},{"id":"b","text":"les segments [AB] et [CD] ont le même milieu"},{"id":"c","text":"les segments [AC] et [BD] ont le même milieu"},{"id":"d","text":"les longueurs AB et CD sont égales"}]'::jsonb, 'a', 'Par définition de l''équipollence, vecteur AB = vecteur CD ⟺ [AD] et [BC] ont le même milieu ✓. La réponse c (même milieu de [AC] et [BD]) correspond à ABCD parallélogramme, soit vecteur AB = vecteur DC — un autre vecteur. La seule égalité des longueurs (réponse d) ne suffit pas : il faut aussi la même direction et le même sens. La réponse b ne caractérise rien d''utile.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18d2aa01-f0cd-5c5a-9df7-c1370f10dd67', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'A, B, C et D sont quatre points, avec A, B, C non alignés. L''égalité « vecteur AB = vecteur CD » équivaut à :', '[{"id":"a","text":"ABDC est un parallélogramme"},{"id":"b","text":"ABCD est un parallélogramme"},{"id":"c","text":"ACBD est un parallélogramme"},{"id":"d","text":"le quadrilatère formé n''a aucune forme particulière"}]'::jsonb, 'a', 'vecteur AB = vecteur CD signifie que [AD] et [BC] (les diagonales) ont le même milieu, ce qui caractérise le parallélogramme ABDC ✓. ABCD parallélogramme (réponse b) correspondrait à vecteur AB = vecteur DC, avec le sens inversé ; l''ordre des sommets est donc essentiel. Les réponses c et d ignorent cette structure.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('228794f1-d74f-542f-abd5-9b49cd74dabb', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'L''image du point M par la translation de vecteur AB est le point M'' tel que :', '[{"id":"a","text":"vecteur MM'' = vecteur AB"},{"id":"b","text":"vecteur MM'' = vecteur BA"},{"id":"c","text":"M'' est le milieu de [AB]"},{"id":"d","text":"MM'' = AB en longueur, quel que soit le sens"}]'::jsonb, 'a', 'La translation de vecteur AB envoie M sur M'' avec vecteur MM'' = vecteur AB ✓ : même direction, même sens, même longueur. Prendre vecteur BA (réponse b) inverse le sens (c''est la translation opposée) ; M'' n''a rien à voir avec le milieu de [AB] (réponse c) ; et le sens compte, contrairement à la réponse d.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fbf64f7c-26c4-5098-bb0a-731f57ccccec', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'Quelle est, en général, l''image d''une droite (d) par une translation ?', '[{"id":"a","text":"une droite parallèle à (d)"},{"id":"b","text":"une droite perpendiculaire à (d)"},{"id":"c","text":"toujours exactement la droite (d) elle-même"},{"id":"d","text":"un segment"}]'::jsonb, 'a', 'L''image d''une droite par une translation est une droite qui lui est parallèle ✓. Elle n''est pas perpendiculaire (réponse b) ; elle ne reste (d) que dans le cas particulier où le vecteur est dirigé selon (d), donc « toujours » est faux (réponse c) ; et l''image d''une droite reste une droite, pas un segment (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4f04d64c-122e-543c-ad1d-75fe18e109c5', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'Un triangle et son image par une translation ont nécessairement :', '[{"id":"a","text":"le même périmètre, la même aire et les mêmes angles"},{"id":"b","text":"le même périmètre mais une aire différente"},{"id":"c","text":"des angles différents"},{"id":"d","text":"une taille deux fois plus grande"}]'::jsonb, 'a', 'Une translation conserve les distances, donc les longueurs, les périmètres, les aires et les angles : les deux triangles sont superposables ✓. Elle ne modifie ni l''aire (réponse b), ni les angles (réponse c) ; et elle n''agrandit pas la figure (réponse d) — contrairement à un agrandissement d''échelle.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', '911d2611-f232-5e69-b326-4d2b66501742', 'math-1ere-sec', '⭐ Exercice : Reconnaître vecteurs et images', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d5f421d1-b075-5b4e-9b56-2193091fbd3c', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'ABDC est un parallélogramme. Quel vecteur est égal au vecteur AB ?', '[{"id":"a","text":"le vecteur CD"},{"id":"b","text":"le vecteur BA"},{"id":"c","text":"le vecteur DC"},{"id":"d","text":"le vecteur BD"}]'::jsonb, 'a', 'Dans le parallélogramme ABDC, les côtés [AB] et [CD] sont parallèles, de même longueur et de même sens : vecteur AB = vecteur CD ✓. Le vecteur DC a le sens opposé (vecteur DC = −vecteur AB) ; BA est l''opposé de AB ; BD est un autre côté du parallélogramme.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01376b6b-6a85-5b32-a8cb-fa8f3c43ac89', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'Pour trois points distincts A, B et C, l''égalité vecteur AB = vecteur BC signifie que :', '[{"id":"a","text":"B est le milieu de [AC]"},{"id":"b","text":"A est le milieu de [BC]"},{"id":"c","text":"C est le milieu de [AB]"},{"id":"d","text":"ABC est un triangle équilatéral"}]'::jsonb, 'a', 'Le déplacement de A à B est le même que de B à C, donc B est exactement au milieu de [AC] ✓. Les réponses b et c placent le milieu au mauvais sommet ; l''égalité de deux vecteurs n''a rien à voir avec un triangle équilatéral (réponse d), d''autant que A, B, C sont ici alignés.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e05154ac-3dd5-5807-9510-4795a06f21f5', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'Par la translation de vecteur AB, quelle est l''image du point A ?', '[{"id":"a","text":"le point B"},{"id":"b","text":"le point A lui-même"},{"id":"c","text":"le milieu de [AB]"},{"id":"d","text":"le symétrique de B par rapport à A"}]'::jsonb, 'a', 'L''image de A est le point M'' tel que vecteur AM'' = vecteur AB, c''est-à-dire M'' = B ✓. A resterait fixe seulement pour le vecteur nul (réponse b) ; le milieu de [AB] (réponse c) et le symétrique de B (réponse d) correspondraient à d''autres déplacements.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1edd73a8-150f-5640-aa84-693a23908f69', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'Par une translation, l''image d''un cercle de centre O et de rayon 4 cm est :', '[{"id":"a","text":"un cercle de rayon 4 cm dont le centre est l''image de O"},{"id":"b","text":"un cercle de rayon 8 cm"},{"id":"c","text":"un cercle de rayon 2 cm"},{"id":"d","text":"le même cercle, de centre O"}]'::jsonb, 'a', 'Une translation conserve les longueurs : le rayon ne change pas (4 cm), seul le centre se déplace vers l''image de O ✓. Le rayon n''est ni doublé (réponse b) ni divisé par deux (réponse c) ; et le centre bouge (sauf translation nulle), donc ce n''est pas le même cercle (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1fd63e3b-6fd2-5d07-8ae7-f152f10b8104', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'Que peut-on dire des vecteurs AB et BA ?', '[{"id":"a","text":"Ils ont la même direction et la même longueur, mais des sens opposés"},{"id":"b","text":"Ils sont égaux"},{"id":"c","text":"Ils ont des longueurs différentes"},{"id":"d","text":"Ils ont des directions différentes"}]'::jsonb, 'a', 'AB et BA portent la même droite (même direction) et la même longueur, mais on les parcourt en sens contraire : ce sont des vecteurs opposés ✓. Ils ne sont donc pas égaux (réponse b) ; leur longueur commune est AB (réponse c fausse) ; et ils ont bien la même direction (réponse d fausse).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9d8cab86-ff23-50a6-b36e-a359c69e0aef', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', 'M et N sont deux points tels que MN = 5 cm. M'' et N'' sont leurs images par une même translation. Combien vaut M''N'' ?', '[{"id":"a","text":"5 cm"},{"id":"b","text":"10 cm"},{"id":"c","text":"0 cm"},{"id":"d","text":"On ne peut pas le savoir"}]'::jsonb, 'a', 'Une translation conserve les distances, donc M''N'' = MN = 5 cm ✓. La distance n''est ni doublée (réponse b) ni annulée (réponse c) ; et elle est parfaitement déterminée, quel que soit le vecteur de translation (réponse d).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', '911d2611-f232-5e69-b326-4d2b66501742', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Égalités vectorielles et translations', 2, 75, 15, 'practice', 'admin', 3)
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
  ('eeec4ca2-6208-5d70-aec9-acd383a59131', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'ABDC est un parallélogramme. Parmi ces égalités vectorielles, laquelle est vraie ?', '[{"id":"a","text":"vecteur AC = vecteur BD"},{"id":"b","text":"vecteur AC = vecteur DB"},{"id":"c","text":"vecteur AB = vecteur DC"},{"id":"d","text":"vecteur AD = vecteur BC"}]'::jsonb, 'a', 'Dans le parallélogramme ABDC, les côtés [AC] et [BD] sont parallèles, de même longueur et de même sens : vecteur AC = vecteur BD ✓. vecteur DB (réponse b) et vecteur DC (réponse c) prennent le sens opposé ; [AD] et [BC] sont les diagonales, qui ne sont pas des vecteurs égaux (réponse d).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('af104644-25ea-517f-aeae-6d94a5a56d30', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'Par la translation de vecteur AB, quelle est l''image du point B ?', '[{"id":"a","text":"le symétrique de A par rapport à B"},{"id":"b","text":"le point A"},{"id":"c","text":"le milieu de [AB]"},{"id":"d","text":"le point B lui-même"}]'::jsonb, 'a', 'L''image B'' de B vérifie vecteur BB'' = vecteur AB, donc B est le milieu de [AB''] : B'' est le symétrique de A par rapport à B ✓. L''image n''est pas A (réponse b, ce serait la translation opposée), ni le milieu de [AB] (réponse c) ; B ne reste fixe que pour le vecteur nul (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3b4077a7-368e-51ee-aec2-ebc68a5f0d9c', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'On sait que vecteur AB = vecteur CD. Que peut-on en déduire ?', '[{"id":"a","text":"vecteur AC = vecteur BD"},{"id":"b","text":"vecteur AC = vecteur DB"},{"id":"c","text":"vecteur AD = vecteur BC"},{"id":"d","text":"vecteur AB = vecteur DC"}]'::jsonb, 'a', 'La permutation de l''égalité vectorielle donne : vecteur AB = vecteur CD ⟺ vecteur AC = vecteur BD ✓. La réponse b inverse le sens (DB au lieu de BD) ; la réponse c porte sur les diagonales et n''a pas de raison d''être vraie ; la réponse d inverse le second vecteur (DC = −CD).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b3002d5c-00dc-50d8-a8bc-0ed261dd939b', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'Dans un repère, A(2 ; 1) et B(5 ; 3). Par la translation de vecteur AB, quelle est l''image du point C(0 ; −4) ?', '[{"id":"a","text":"(3 ; −2)"},{"id":"b","text":"(−3 ; −6)"},{"id":"c","text":"(3 ; 2)"},{"id":"d","text":"(5 ; −1)"}]'::jsonb, 'a', 'Le déplacement de la translation est le même pour tous les points : de A à B, on ajoute (5 − 2 ; 3 − 1) = (3 ; 2). Appliqué à C(0 ; −4), cela donne C''(0 + 3 ; −4 + 2) = (3 ; −2) ✓. La réponse b soustrait le déplacement, la réponse c donne le déplacement lui-même, et la réponse d ne l''applique qu''à une seule coordonnée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('476256f9-5c92-571a-b0ec-d01eeec4597c', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'Soit ABC un triangle. On note D l''image de C par la translation de vecteur AB. Quelle est la nature du quadrilatère ABDC ?', '[{"id":"a","text":"un parallélogramme"},{"id":"b","text":"un losange"},{"id":"c","text":"un rectangle"},{"id":"d","text":"un quadrilatère quelconque"}]'::jsonb, 'a', 'D est l''image de C, donc vecteur CD = vecteur AB, c''est-à-dire vecteur AB = vecteur CD : c''est exactement la condition pour que ABDC soit un parallélogramme ✓. Rien n''impose des côtés égaux (losange, réponse b) ni des angles droits (rectangle, réponse c) ; et la structure n''est pas quelconque (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('22666f07-e576-5be3-a257-1573a241cd64', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04', 'Dans un repère, A(1 ; 2) et B(4 ; 6). Le point M(3 ; 3) a pour image M'' par la translation de vecteur AB. Quelles sont les coordonnées du milieu de [MM''] ?', '[{"id":"a","text":"(4,5 ; 5)"},{"id":"b","text":"(6 ; 7)"},{"id":"c","text":"(1,5 ; 2)"},{"id":"d","text":"(3 ; 4)"}]'::jsonb, 'a', 'Le déplacement vaut (4 − 1 ; 6 − 2) = (3 ; 4), donc M''(3 + 3 ; 3 + 4) = (6 ; 7). Le milieu de [MM''] est ((3 + 6)/2 ; (3 + 7)/2) = (4,5 ; 5) ✓. La réponse b donne M'' au lieu du milieu ; la réponse d donne le vecteur AB ; la réponse c prend la moitié du seul déplacement.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'e7fa1c08-f6c0-5b4b-a040-b410d4b0b033', 'math-1ere-sec', 'Test de compréhension ⭐ : Somme de vecteurs et colinéarité', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('2ca2c38a-5ff5-53d7-9994-b3ff34ad133e', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'Que vaut la somme vecteur AB + vecteur BC ?', '[{"id":"a","text":"vecteur AC"},{"id":"b","text":"vecteur BA"},{"id":"c","text":"vecteur CA"},{"id":"d","text":"le vecteur nul"}]'::jsonb, 'a', 'C''est la relation de Chasles : le point d''arrivée du premier vecteur (B) est le départ du second, donc vecteur AB + vecteur BC = vecteur AC ✓. vecteur CA (réponse c) est l''opposé du bon résultat ; vecteur BA (réponse b) et le vecteur nul (réponse d) ne s''obtiennent pas ici.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('33221cb0-a805-5573-b991-c9431a4576e2', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'Que vaut la somme vecteur AB + vecteur BA ?', '[{"id":"a","text":"le vecteur nul"},{"id":"b","text":"2 · vecteur AB"},{"id":"c","text":"vecteur AB"},{"id":"d","text":"vecteur BA"}]'::jsonb, 'a', 'vecteur AB et vecteur BA sont opposés : leur somme est le vecteur nul ✓ (par Chasles, vecteur AB + vecteur BA = vecteur AA = 0). On n''obtient ni le double (réponse b) ni l''un des deux vecteurs (réponses c et d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b175c9eb-b420-5e1d-8e75-a8774ea10d44', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'Le vecteur −3 · vecteur AB a pour longueur et pour sens :', '[{"id":"a","text":"une longueur de 3 × AB, et un sens contraire à celui de vecteur AB"},{"id":"b","text":"une longueur de 3 × AB, et le même sens que vecteur AB"},{"id":"c","text":"une longueur de AB, et un sens contraire"},{"id":"d","text":"une longueur « négative », impossible à représenter"}]'::jsonb, 'a', 'La longueur d''un vecteur α·u est |α| × (longueur de u) : ici |−3| = 3, donc la longueur est 3 × AB ; le coefficient étant négatif, le sens est contraire ✓. La réponse b se trompe de sens ; la réponse c oublie de multiplier par 3 ; une longueur est toujours positive, ce qui écarte la réponse d (le « − » agit sur le sens, pas sur la longueur).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d9f51e02-2768-5102-8b02-a3c2779c9b43', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'On sait que vecteur CD = 2 · vecteur AB. Que peut-on dire des droites (AB) et (CD) ?', '[{"id":"a","text":"Elles sont parallèles (ou confondues)"},{"id":"b","text":"Elles sont perpendiculaires"},{"id":"c","text":"Elles sont sécantes sans être perpendiculaires"},{"id":"d","text":"On ne peut rien conclure"}]'::jsonb, 'a', 'Si un vecteur est le produit de l''autre par un réel, les deux vecteurs sont colinéaires, donc les droites (AB) et (CD) sont parallèles (ou confondues) ✓. La colinéarité n''a rien à voir avec la perpendicularité (réponse b) ; elle exclut deux droites sécantes non parallèles (réponse c) ; et elle permet bien de conclure (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e46cc4c7-87df-5f7b-933f-3bb575b89a14', '5ccb314e-407f-570f-8a85-6e6c7e49e4dd', 'Le point I est le milieu du segment [AB] si et seulement si :', '[{"id":"a","text":"vecteur IA + vecteur IB = vecteur 0"},{"id":"b","text":"vecteur IA + vecteur IB = vecteur AB"},{"id":"c","text":"vecteur IA = vecteur IB"},{"id":"d","text":"vecteur AI = vecteur BI"}]'::jsonb, 'a', 'La caractérisation vectorielle du milieu est vecteur IA + vecteur IB = vecteur 0 (les deux vecteurs opposés se compensent) ✓, ce qui équivaut aussi à vecteur AB = 2·vecteur AI. L''égalité vecteur IA = vecteur IB (réponse c) forcerait A = B ; de même vecteur AI = vecteur BI (réponse d) ; et la somme ne vaut pas vecteur AB (réponse b).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bedf09e7-0822-5fa3-8ee9-81082b83b458', 'e7fa1c08-f6c0-5b4b-a040-b410d4b0b033', 'math-1ere-sec', '⭐ Exercice : Additionner et multiplier des vecteurs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('33016394-3d88-5ad2-bc29-03239777b857', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'Simplifie la somme vecteur AB + vecteur BC + vecteur CD.', '[{"id":"a","text":"vecteur AD"},{"id":"b","text":"vecteur DA"},{"id":"c","text":"vecteur AC"},{"id":"d","text":"vecteur BD"}]'::jsonb, 'a', 'Par la relation de Chasles, on enchaîne A→B→C→D : vecteur AB + vecteur BC + vecteur CD = vecteur AD ✓. vecteur DA (réponse b) en est l''opposé ; vecteur AC (réponse c) s''arrête à C ; vecteur BD (réponse d) oublie le départ A.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed3115a2-e9e9-5999-8963-35101d1bf8dc', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'Que vaut la somme vecteur MN + vecteur NP ?', '[{"id":"a","text":"vecteur MP"},{"id":"b","text":"vecteur PM"},{"id":"c","text":"vecteur NM"},{"id":"d","text":"le vecteur nul"}]'::jsonb, 'a', 'Le point d''arrivée du premier vecteur (N) est le départ du second : par Chasles, vecteur MN + vecteur NP = vecteur MP ✓. vecteur PM (réponse b) est l''opposé ; vecteur NM (réponse c) et le vecteur nul (réponse d) ne correspondent pas.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('27711c10-1af9-511f-9533-ecd73048872a', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'Le vecteur AB a une longueur de 5 cm. Quelle est la longueur du vecteur 4 · vecteur AB ?', '[{"id":"a","text":"20 cm"},{"id":"b","text":"9 cm"},{"id":"c","text":"5 cm"},{"id":"d","text":"1,25 cm"}]'::jsonb, 'a', 'La longueur de α·u vaut |α| × (longueur de u) : ici 4 × 5 = 20 cm ✓. 9 cm additionne (5 + 4) au lieu de multiplier ; 5 cm oublie le coefficient ; 1,25 cm divise par 4 au lieu de multiplier.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bf8068e1-4471-5c24-941a-976cf5ce3b68', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'Le vecteur 2 · vecteur AB et le vecteur AB ont-ils le même sens ?', '[{"id":"a","text":"Oui, car le coefficient 2 est positif"},{"id":"b","text":"Non, ils sont de sens contraires"},{"id":"c","text":"Non, ils sont perpendiculaires"},{"id":"d","text":"On ne peut pas le savoir"}]'::jsonb, 'a', 'Multiplier par un réel positif conserve le sens (et ne fait qu''allonger le vecteur) : 2 · vecteur AB a le même sens que vecteur AB ✓. Le sens ne change que pour un coefficient négatif (réponse b) ; la multiplication par un réel ne crée pas de perpendicularité (réponse c) ; et la conclusion est certaine (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c70d130a-ba02-5b79-948a-109ca0cfce37', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'I est le milieu du segment [AB]. Que vaut vecteur AB en fonction de vecteur AI ?', '[{"id":"a","text":"2 · vecteur AI"},{"id":"b","text":"vecteur AI"},{"id":"c","text":"(1/2) · vecteur AI"},{"id":"d","text":"−2 · vecteur AI"}]'::jsonb, 'a', 'Si I est le milieu de [AB], alors vecteur AB = 2 · vecteur AI (le déplacement de A à B est le double de celui de A à I, dans le même sens) ✓. vecteur AI (réponse b) et (1/2)·vecteur AI (réponse c) sont trop courts ; le signe « − » (réponse d) inverserait le sens.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9db2a14e-0fbc-55f6-bcca-ce462106d799', 'bedf09e7-0822-5fa3-8ee9-81082b83b458', 'On a AB = 6 cm et CD = 18 cm, avec vecteur CD et vecteur AB colinéaires et de même sens. Quel réel k vérifie vecteur CD = k · vecteur AB ?', '[{"id":"a","text":"3"},{"id":"b","text":"−3"},{"id":"c","text":"1/3"},{"id":"d","text":"12"}]'::jsonb, 'a', 'Le coefficient k est le rapport des longueurs, avec le signe donné par le sens : k = 18/6 = 3, positif car les deux vecteurs sont de même sens ✓. −3 conviendrait pour des sens contraires ; 1/3 inverse le rapport ; 12 fait la différence 18 − 6 au lieu du quotient.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1b380fd3-7beb-5b66-91c9-d04639b46b13', 'e7fa1c08-f6c0-5b4b-a040-b410d4b0b033', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Chasles, colinéarité et milieu', 2, 75, 15, 'practice', 'admin', 3)
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
  ('677d5e6e-8a45-501b-8b29-f4a4f1891257', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'Simplifie la somme vecteur AB + vecteur CA + vecteur BC.', '[{"id":"a","text":"le vecteur nul"},{"id":"b","text":"vecteur AC"},{"id":"c","text":"vecteur AB"},{"id":"d","text":"2 · vecteur AB"}]'::jsonb, 'a', 'On réorganise pour recoller les lettres : vecteur CA + vecteur AB + vecteur BC = vecteur CB + vecteur BC = vecteur CC = vecteur nul ✓. Les réponses b, c et d ne tiennent pas compte du fait que le déplacement revient à son point de départ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b5bc64a1-b3f5-5883-b72b-860cfe585b91', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'ABDC est un parallélogramme. Que vaut la somme vecteur AB + vecteur AC ?', '[{"id":"a","text":"vecteur AD"},{"id":"b","text":"vecteur BC"},{"id":"c","text":"vecteur BD"},{"id":"d","text":"2 · vecteur AB"}]'::jsonb, 'a', 'C''est la règle du parallélogramme : la somme des deux vecteurs issus de A vaut la diagonale, vecteur AB + vecteur AC = vecteur AD ✓ (D est le quatrième sommet). vecteur BC (réponse b) est une diagonale de l''autre sens ; vecteur BD (réponse c) est un côté ; le double de vecteur AB (réponse d) supposerait vecteur AB = vecteur AC.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6ed4ed97-c671-571c-9444-d2c580bc2aa8', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'Trois points A, B et C vérifient vecteur AC = 3 · vecteur AB. Que peut-on affirmer ?', '[{"id":"a","text":"A, B et C sont alignés"},{"id":"b","text":"ABC est un triangle rectangle"},{"id":"c","text":"B est le milieu de [AC]"},{"id":"d","text":"ABC est un triangle équilatéral"}]'::jsonb, 'a', 'vecteur AC et vecteur AB sont colinéaires (l''un est le produit de l''autre par 3), donc A, B et C sont alignés ✓. Il n''y a pas de triangle (réponses b et d), les trois points étant sur une même droite. B serait le milieu de [AC] si vecteur AC = 2·vecteur AB, pas 3·vecteur AB (réponse c).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('11fd6150-9df6-543e-8334-170cb5cd216a', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'Sur la droite (AB), le point I vérifie vecteur AI = (1/2) · vecteur AB. Que peut-on dire de I ?', '[{"id":"a","text":"I est le milieu de [AB]"},{"id":"b","text":"I est confondu avec A"},{"id":"c","text":"I est confondu avec B"},{"id":"d","text":"I est le symétrique de B par rapport à A"}]'::jsonb, 'a', 'vecteur AI = (1/2)·vecteur AB signifie que I est à mi-chemin de A vers B : I est le milieu de [AB] ✓ (équivaut à vecteur AB = 2·vecteur AI). Les coefficients 0 et 1 donneraient A et B (réponses b et c) ; le symétrique de B par rapport à A correspondrait à vecteur AI = −vecteur AB (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('367d4b73-2761-56d7-8be6-3ccd492c2244', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'ABC est un triangle et I le milieu de [BC]. Exprime la somme vecteur AB + vecteur AC en fonction de vecteur AI.', '[{"id":"a","text":"2 · vecteur AI"},{"id":"b","text":"vecteur AI"},{"id":"c","text":"vecteur BC"},{"id":"d","text":"(1/2) · vecteur AI"}]'::jsonb, 'a', 'On décompose par Chasles : vecteur AB + vecteur AC = (vecteur AI + vecteur IB) + (vecteur AI + vecteur IC) = 2·vecteur AI + (vecteur IB + vecteur IC). Comme I est le milieu de [BC], vecteur IB + vecteur IC = vecteur 0, d''où vecteur AB + vecteur AC = 2·vecteur AI ✓. Les autres réponses oublient ce doublement ou confondent avec un côté.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5cdeb15-6dce-5b96-a6e0-eda23763767e', '1b380fd3-7beb-5b66-91c9-d04639b46b13', 'On donne vecteur EF = −2 · vecteur GH. Que peut-on affirmer sur les droites et les longueurs ?', '[{"id":"a","text":"(EF) // (GH), EF = 2 × GH, et les deux vecteurs sont de sens contraires"},{"id":"b","text":"(EF) // (GH), EF = 2 × GH, et les deux vecteurs sont de même sens"},{"id":"c","text":"(EF) et (GH) sont perpendiculaires"},{"id":"d","text":"EF = −2 × GH, une longueur négative"}]'::jsonb, 'a', 'Un vecteur multiple d''un autre lui est colinéaire, donc (EF) // (GH). La longueur vaut |−2| × GH = 2 × GH, et le coefficient négatif impose des sens contraires ✓. La réponse b se trompe de sens ; la colinéarité n''entraîne pas la perpendicularité (réponse c) ; et une longueur ne peut pas être négative (réponse d) — le « − » agit sur le sens.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('081ccca1-81fc-5bc2-9971-f47a230668a8', '947437c3-de15-51ca-b0a8-7b0fff092953', 'math-1ere-sec', 'Test de compréhension ⭐ : Activités dans un repère', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8868eb25-bb2b-5764-81ab-8facf461a5a0', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'Dans un repère, A(1 ; 2) et B(4 ; 6). Quelles sont les composantes du vecteur AB ?', '[{"id":"a","text":"(3 ; 4)"},{"id":"b","text":"(5 ; 8)"},{"id":"c","text":"(−3 ; −4)"},{"id":"d","text":"(4 ; 6)"}]'::jsonb, 'a', 'Les composantes sont « arrivée moins départ » : (xB − xA ; yB − yA) = (4 − 1 ; 6 − 2) = (3 ; 4) ✓. (5 ; 8) additionne les coordonnées ; (−3 ; −4) calcule « départ moins arrivée » (le vecteur opposé) ; (4 ; 6) recopie les coordonnées de B.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f269838f-7a4e-5049-89a9-e33c848ead90', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'Dans un repère, quelles sont les coordonnées du milieu du segment [AB] ?', '[{"id":"a","text":"((xA + xB)/2 ; (yA + yB)/2)"},{"id":"b","text":"(xB − xA ; yB − yA)"},{"id":"c","text":"(xA + xB ; yA + yB)"},{"id":"d","text":"((xB − xA)/2 ; (yB − yA)/2)"}]'::jsonb, 'a', 'Le milieu est la moyenne des coordonnées : ((xA + xB)/2 ; (yA + yB)/2) ✓. La réponse b donne les composantes de vecteur AB ; la réponse c oublie de diviser par 2 ; la réponse d prend une différence au lieu d''une somme.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2073a87a-08c4-51b9-84ab-4353738ac3db', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'Dans le repère (O, I, J), que représentent les deux nombres du couple (x ; y) d''un point M ?', '[{"id":"a","text":"x est l''abscisse (axe des abscisses) et y l''ordonnée (axe des ordonnées)"},{"id":"b","text":"x est l''ordonnée et y l''abscisse"},{"id":"c","text":"deux distances, toujours positives"},{"id":"d","text":"les composantes du vecteur IJ"}]'::jsonb, 'a', 'Par convention, le premier nombre x est l''abscisse (le long de l''axe des abscisses, porté par OI) et le second y l''ordonnée (axe des ordonnées, porté par OJ) ✓. La réponse b intervertit les deux ; les coordonnées peuvent être négatives (réponse c) ; et elles décrivent le point M, pas le vecteur IJ (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99d2aab2-f3ac-544c-bfa7-0280f1a009b8', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'Dans un repère orthonormé, la distance AB entre A(xA ; yA) et B(xB ; yB) est égale à :', '[{"id":"a","text":"√((xB − xA)² + (yB − yA)²)"},{"id":"b","text":"(xB − xA) + (yB − yA)"},{"id":"c","text":"(xB − xA)² + (yB − yA)²"},{"id":"d","text":"√((xB − xA) + (yB − yA))"}]'::jsonb, 'a', 'C''est le théorème de Pythagore appliqué aux composantes : AB = √((xB − xA)² + (yB − yA)²) ✓. La réponse b additionne sans carrés ni racine ; la réponse c donne AB² (racine oubliée) ; la réponse d met la racine au mauvais endroit (pas de carrés à l''intérieur).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('94ea9de4-5a1d-55bc-b6c8-506162a1a36b', '081ccca1-81fc-5bc2-9971-f47a230668a8', 'Deux vecteurs de composantes (a ; b) et (a'' ; b'') sont colinéaires lorsque :', '[{"id":"a","text":"leurs composantes sont proportionnelles : un même réel k relie a à a'' et b à b''"},{"id":"b","text":"a = b et a'' = b''"},{"id":"c","text":"a + b = a'' + b''"},{"id":"d","text":"a = a'' ou b = b''"}]'::jsonb, 'a', 'La colinéarité se lit sur la proportionnalité des composantes : il existe un même k tel que a'' = k·a et b'' = k·b ✓. L''égalité des deux composantes d''un même vecteur (réponse b) ou l''égalité des sommes (réponse c) n''ont rien à voir ; et une seule composante égale (réponse d) ne suffit pas.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e060ac07-2292-5773-ae64-5f97f3f81111', '947437c3-de15-51ca-b0a8-7b0fff092953', 'math-1ere-sec', '⭐ Exercice : Calculer dans un repère', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e002b3ad-cd95-524f-a9b2-7b2255e8a621', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'Dans un repère, A(2 ; 1) et B(7 ; 4). Quelles sont les composantes du vecteur AB ?', '[{"id":"a","text":"(5 ; 3)"},{"id":"b","text":"(9 ; 5)"},{"id":"c","text":"(−5 ; −3)"},{"id":"d","text":"(7 ; 4)"}]'::jsonb, 'a', 'On calcule « arrivée moins départ » : (7 − 2 ; 4 − 1) = (5 ; 3) ✓. (9 ; 5) additionne les coordonnées ; (−5 ; −3) inverse le sens (départ moins arrivée) ; (7 ; 4) recopie les coordonnées de B.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9c778ad3-4947-5cab-acad-05729665f006', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'Quelles sont les coordonnées du milieu du segment [AB] avec A(2 ; 4) et B(8 ; 10) ?', '[{"id":"a","text":"(5 ; 7)"},{"id":"b","text":"(10 ; 14)"},{"id":"c","text":"(3 ; 3)"},{"id":"d","text":"(6 ; 6)"}]'::jsonb, 'a', 'Le milieu est la moyenne des coordonnées : ((2 + 8)/2 ; (4 + 10)/2) = (5 ; 7) ✓. (10 ; 14) oublie de diviser par 2 ; (6 ; 6) donne les composantes de vecteur AB ; (3 ; 3) divise ces composantes par 2.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('46ad615f-db91-5e1f-93dc-4c42687cd422', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'Dans un repère orthonormé, A(0 ; 0) et B(3 ; 4). Quelle est la distance AB ?', '[{"id":"a","text":"5"},{"id":"b","text":"7"},{"id":"c","text":"25"},{"id":"d","text":"12"}]'::jsonb, 'a', 'AB = √((3 − 0)² + (4 − 0)²) = √(9 + 16) = √25 = 5 ✓. 7 additionne 3 + 4 sans passer par les carrés ; 25 est AB² (racine oubliée) ; 12 multiplie 3 × 4.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b9d80c80-a783-5ce0-a71f-00b5e5ab70c1', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'Sur une droite graduée, A a pour abscisse −2 et B pour abscisse 5. Quelle est la mesure algébrique du vecteur AB ?', '[{"id":"a","text":"7"},{"id":"b","text":"3"},{"id":"c","text":"−7"},{"id":"d","text":"−3"}]'::jsonb, 'a', 'La mesure algébrique vaut xB − xA = 5 − (−2) = 7 ✓ (positive : le sens de A vers B est celui du repère). 3 traite −2 comme +2 ; −7 inverse le calcul (xA − xB) ; −3 combine les deux erreurs.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5d77dfc0-71c7-5c25-b693-b80357d531f1', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'Les vecteurs de composantes vecteur AB(2 ; 3) et vecteur CD(6 ; 9) sont-ils colinéaires ?', '[{"id":"a","text":"Oui, car vecteur CD = 3 · vecteur AB"},{"id":"b","text":"Non, leurs composantes ne sont pas proportionnelles"},{"id":"c","text":"Oui, car vecteur CD = 2 · vecteur AB"},{"id":"d","text":"On ne peut pas le savoir"}]'::jsonb, 'a', 'On cherche un même k : 6 = k × 2 donne k = 3, et 9 = 3 × 3 confirme k = 3 pour la seconde composante. Les composantes sont proportionnelles, donc les vecteurs sont colinéaires avec vecteur CD = 3·vecteur AB ✓. Le coefficient est 3, pas 2 (réponse c) ; la proportionnalité est bien vérifiée (réponses b et d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('674c73c6-e3f5-5309-a1f7-acd479a161b8', 'e060ac07-2292-5773-ae64-5f97f3f81111', 'A(1 ; 2), B(4 ; 3) et C(0 ; 5). On cherche le point D tel que vecteur CD = vecteur AB. Quelles sont les coordonnées de D ?', '[{"id":"a","text":"(3 ; 6)"},{"id":"b","text":"(−3 ; 4)"},{"id":"c","text":"(3 ; 1)"},{"id":"d","text":"(4 ; 8)"}]'::jsonb, 'a', 'vecteur AB = (4 − 1 ; 3 − 2) = (3 ; 1). Comme vecteur CD = vecteur AB, on ajoute ces composantes à C : D(0 + 3 ; 5 + 1) = (3 ; 6) ✓. (−3 ; 4) soustrait les composantes ; (3 ; 1) donne le vecteur lui-même ; (4 ; 8) ajoute mal les valeurs.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('77fc7cf9-fa0d-510b-813e-ed7e692c32a7', '947437c3-de15-51ca-b0a8-7b0fff092953', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Coordonnées, distances et alignement', 2, 75, 15, 'practice', 'admin', 3)
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
  ('c36cf64f-d5db-5158-adb8-4776dc98950e', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'Dans un repère orthonormé, A(−1 ; 2) et B(2 ; 6). Quelle est la distance AB ?', '[{"id":"a","text":"5"},{"id":"b","text":"7"},{"id":"c","text":"√7"},{"id":"d","text":"25"}]'::jsonb, 'a', 'AB = √((2 − (−1))² + (6 − 2)²) = √(3² + 4²) = √(9 + 16) = √25 = 5 ✓. 7 additionne 3 + 4 ; √7 additionne les carrés sans les élever (3 + 4 sous la racine) ; 25 oublie la racine.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f70277d2-76cb-52d5-9652-604e738e7fa7', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'On donne A(1 ; 1), B(3 ; 2) et C(7 ; 4). Les points A, B et C sont-ils alignés ?', '[{"id":"a","text":"Oui, car vecteur AC = 3 · vecteur AB"},{"id":"b","text":"Non, car les composantes ne sont pas proportionnelles"},{"id":"c","text":"Oui, car AB = AC"},{"id":"d","text":"On ne peut pas le savoir sans dessin"}]'::jsonb, 'a', 'vecteur AB = (2 ; 1) et vecteur AC = (6 ; 3). On cherche k : 6 = k × 2 donne k = 3, et 3 = 3 × 1 confirme. Les vecteurs sont colinéaires, donc A, B, C sont alignés ✓. Les composantes SONT proportionnelles (réponse b fausse) ; l''alignement ne suppose pas AB = AC (réponse c) ; le calcul tranche sans dessin (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa687ed2-ffdf-52ab-a3ac-6bc7412f9739', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'ABCD est un parallélogramme avec A(1 ; 1), B(4 ; 2) et C(5 ; 5). Quelles sont les coordonnées de D ?', '[{"id":"a","text":"(2 ; 4)"},{"id":"b","text":"(8 ; 6)"},{"id":"c","text":"(2 ; 2)"},{"id":"d","text":"(6 ; 4)"}]'::jsonb, 'a', 'Dans le parallélogramme ABCD, les diagonales [AC] et [BD] ont le même milieu, donc D = A + C − B : D(1 + 5 − 4 ; 1 + 5 − 2) = (2 ; 4) ✓ (on vérifie vecteur AB = vecteur DC = (3 ; 1)). Les autres réponses ne respectent pas l''égalité des milieux des diagonales.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9b5b71db-2bfd-5ca1-bd9a-526951e76557', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'Le milieu du segment [AB] est M(3 ; 5) et l''on sait que A(1 ; 2). Quelles sont les coordonnées de B ?', '[{"id":"a","text":"(5 ; 8)"},{"id":"b","text":"(2 ; 3)"},{"id":"c","text":"(4 ; 7)"},{"id":"d","text":"(7 ; 12)"}]'::jsonb, 'a', 'De M = ((xA + xB)/2 ; (yA + yB)/2), on tire B = 2M − A : xB = 2 × 3 − 1 = 5 et yB = 2 × 5 − 2 = 8, donc B(5 ; 8) ✓. (2 ; 3) donne les composantes de vecteur AM ; (4 ; 7) additionne M + A ; (7 ; 12) double sans retrancher A.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c02d34d7-6713-5543-88f8-9b83d1037227', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'Dans un repère orthonormé, A(0 ; 0), B(4 ; 0) et C(0 ; 3). Quelle est la nature du triangle ABC ?', '[{"id":"a","text":"Rectangle en A"},{"id":"b","text":"Équilatéral"},{"id":"c","text":"Isocèle en A"},{"id":"d","text":"Quelconque"}]'::jsonb, 'a', 'On calcule AB = 4, AC = 3 et BC = √(4² + 3²) = 5. Comme AB² + AC² = 16 + 9 = 25 = BC², la réciproque du théorème de Pythagore donne un angle droit en A : le triangle est rectangle en A ✓. Les côtés étant inégaux (4, 3, 5), il n''est ni équilatéral (réponse b) ni isocèle (réponse c), et sa nature est bien déterminée (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84cdb95a-2494-5e58-8315-137f2f7552a9', '77fc7cf9-fa0d-510b-813e-ed7e692c32a7', 'On donne A(1 ; 2), B(3 ; 6) et C(5 ; y). Pour quelle valeur de y les points A, B et C sont-ils alignés ?', '[{"id":"a","text":"y = 10"},{"id":"b","text":"y = 8"},{"id":"c","text":"y = 12"},{"id":"d","text":"y = 6"}]'::jsonb, 'a', 'vecteur AB = (2 ; 4) et vecteur AC = (4 ; y − 2). L''alignement exige vecteur AC = k·vecteur AB : la première composante donne 4 = k × 2, soit k = 2 ; alors y − 2 = 2 × 4 = 8, donc y = 10 ✓. y = 8 oublie d''ajouter 2 ; y = 12 et y = 6 ne rendent pas les composantes proportionnelles.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5d52b4ce-ded3-5afb-84c4-d8d783b46f82', '8f37a3b1-c4ff-566b-9985-c7c2d877a56c', 'math-1ere-sec', 'Test de compréhension ⭐ : Quart de tour', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('c8a7f195-2152-5df6-a7fa-78fd47bc2eb2', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'L''image d''un point M (avec M ≠ O) par le quart de tour de centre O est le point M'' tel que :', '[{"id":"a","text":"OM'' = OM et angle MOM'' = 90°"},{"id":"b","text":"OM'' = 2 × OM et angle MOM'' = 90°"},{"id":"c","text":"OM'' = OM et angle MOM'' = 45°"},{"id":"d","text":"M'' est le symétrique de M par rapport à O"}]'::jsonb, 'a', 'Le quart de tour conserve la distance au centre (OM'' = OM) et impose un angle droit MOM'' = 90° ✓. La réponse b double la distance ; la réponse c prend un demi-angle droit ; et le symétrique par rapport à O (réponse d) correspond au demi-tour, une rotation de 180°.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0b4fb9de-dff3-50b8-9c9a-d2a649f53eae', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'Par un quart de tour de centre O, quelle est l''image du centre O ?', '[{"id":"a","text":"O lui-même"},{"id":"b","text":"un point situé à 90° de O"},{"id":"c","text":"le symétrique de O par rapport à M"},{"id":"d","text":"O n''a pas d''image"}]'::jsonb, 'a', 'Le centre est le seul point fixe de la transformation : l''image de O est O ✓. Il ne se déplace pas d''un angle (réponse b), n''a pas de symétrique à considérer (réponse c) et possède bien une image, qui est lui-même (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8e4b1ed1-39bb-5c64-93b8-78c571df145f', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'Que conserve un quart de tour ?', '[{"id":"a","text":"les distances, les angles et les aires"},{"id":"b","text":"les distances, mais pas les angles"},{"id":"c","text":"la direction des droites"},{"id":"d","text":"rien : il déforme les figures"}]'::jsonb, 'a', 'Le quart de tour est une isométrie : il conserve les distances, les angles et les aires (les figures et leurs images sont superposables) ✓. Il conserve bien les angles (réponse b fausse) ; en revanche il ne conserve PAS la direction des droites, qu''il rend perpendiculaires (réponse c) ; il ne déforme donc rien (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('46a5087a-d2a5-5806-9745-77f3b046fa90', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'Quelle est l''image d''une droite par un quart de tour ?', '[{"id":"a","text":"une droite perpendiculaire à la droite de départ"},{"id":"b","text":"une droite parallèle à la droite de départ"},{"id":"c","text":"toujours la même droite"},{"id":"d","text":"un segment"}]'::jsonb, 'a', 'L''angle de 90° du quart de tour se retrouve entre une droite et son image : l''image d''une droite est une droite perpendiculaire ✓. La droite parallèle (réponse b) est le résultat d''une translation, pas d''un quart de tour ; l''image d''une droite reste une droite entière (réponses c et d incorrectes).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49a128c2-546e-5521-ae79-09874106d9bf', '5d52b4ce-ded3-5afb-84c4-d8d783b46f82', 'Le triangle ABC est rectangle isocèle en A. Que peut-on affirmer sur le point C ?', '[{"id":"a","text":"C est l''image de B par un quart de tour de centre A"},{"id":"b","text":"C est l''image de B par une translation"},{"id":"c","text":"C est le milieu de [AB]"},{"id":"d","text":"C est le symétrique de A par rapport à B"}]'::jsonb, 'a', '« Rectangle isocèle en A » signifie AB = AC et angle BAC = 90° : ce sont exactement les conditions du quart de tour de centre A, donc C est l''image de B ✓. Une translation conserverait la direction (pas d''angle droit créé, réponse b) ; C n''est ni un milieu (réponse c) ni un symétrique de A (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bb6bc104-11e0-559c-ba9e-290f3e32f991', '8f37a3b1-c4ff-566b-9985-c7c2d877a56c', 'math-1ere-sec', '⭐ Exercice : Le quart de tour pas à pas', 1, 50, 10, 'practice', 'admin', 1)
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
  ('286709c5-41a9-5c99-a45f-8ced04ee43c7', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'Par un quart de tour de centre O, le segment [AB] a pour image [A''B'']. Si AB = 7 cm, combien vaut A''B'' ?', '[{"id":"a","text":"7 cm"},{"id":"b","text":"14 cm"},{"id":"c","text":"3,5 cm"},{"id":"d","text":"9 cm"}]'::jsonb, 'a', 'Le quart de tour conserve les longueurs : A''B'' = AB = 7 cm ✓. La longueur n''est ni doublée (réponse b), ni divisée par deux (réponse c) ; l''angle de 90° agit sur la direction, pas sur la mesure (réponse d).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('986aaec2-89df-53c1-954f-3b8d43c94f57', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'M'' est l''image de M par un quart de tour de centre O. Si OM = 5 cm, combien vaut OM'' ?', '[{"id":"a","text":"5 cm"},{"id":"b","text":"10 cm"},{"id":"c","text":"2,5 cm"},{"id":"d","text":"7,07 cm"}]'::jsonb, 'a', 'Par définition, le quart de tour conserve la distance au centre : OM'' = OM = 5 cm ✓. Les autres valeurs (double, moitié, ou 5√2 ≈ 7,07) proviennent de calculs qui n''ont pas lieu d''être ici.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c775c273-5cdf-5c3e-9ca8-6cf44bac3e8c', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'M'' est l''image de M (avec M ≠ O) par un quart de tour de centre O. Combien vaut l''angle MOM'' ?', '[{"id":"a","text":"90°"},{"id":"b","text":"45°"},{"id":"c","text":"180°"},{"id":"d","text":"60°"}]'::jsonb, 'a', 'Un quart de tour est une rotation de 90° : l''angle MOM'' est droit ✓. 45° est un demi-angle droit ; 180° correspond à un demi-tour (symétrie centrale) ; 60° n''a aucun rapport avec cette transformation.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9f0421fd-9208-575f-a532-50985239b86a', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'Une droite (d) a pour image (d'') par un quart de tour. Quelle est la position de (d'') par rapport à (d) ?', '[{"id":"a","text":"(d'') est perpendiculaire à (d)"},{"id":"b","text":"(d'') est parallèle à (d)"},{"id":"c","text":"(d'') est confondue avec (d)"},{"id":"d","text":"(d'') est une demi-droite"}]'::jsonb, 'a', 'L''image d''une droite par un quart de tour lui est perpendiculaire ✓. La parallèle (réponse b) est le résultat d''une translation ; l''image reste une droite complète, ni confondue (réponse c) ni réduite à une demi-droite (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ad9ae393-fece-56b1-920e-a23392f6b9de', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'Un cercle de rayon 6 cm a pour image, par un quart de tour, un cercle de rayon :', '[{"id":"a","text":"6 cm"},{"id":"b","text":"12 cm"},{"id":"c","text":"3 cm"},{"id":"d","text":"8,49 cm"}]'::jsonb, 'a', 'Le quart de tour conserve les longueurs, donc le rayon ne change pas : le cercle image a un rayon de 6 cm ✓ (seul son centre se déplace, à l''image du centre initial). Les autres valeurs (double, moitié, ou 6√2) n''ont pas lieu d''être.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0f7b998b-aae6-591d-9dc3-7a779cd710ab', 'bb6bc104-11e0-559c-ba9e-290f3e32f991', 'M'' est l''image de M par un quart de tour de centre O. Quelle est la nature du triangle OMM'' ?', '[{"id":"a","text":"Rectangle isocèle en O"},{"id":"b","text":"Équilatéral"},{"id":"c","text":"Rectangle en M"},{"id":"d","text":"Isocèle en M"}]'::jsonb, 'a', 'On a OM = OM'' (donc isocèle en O) et l''angle MOM'' = 90° (donc rectangle en O) : le triangle OMM'' est rectangle isocèle en O ✓. Il n''est pas équilatéral (l''angle en O est droit, pas 60°) ; l''angle droit est en O, pas en M (réponses c et d).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f80ac6be-fb97-5878-8f89-91a0e50de0e7', '8f37a3b1-c4ff-566b-9985-c7c2d877a56c', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Propriétés du quart de tour', 2, 75, 15, 'practice', 'admin', 3)
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
  ('b80c75f4-bacd-519c-a059-21520455ea76', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'Un triangle ABC de périmètre 20 cm et d''aire 15 cm² a pour image A''B''C'' par un quart de tour. Que valent le périmètre et l''aire de A''B''C'' ?', '[{"id":"a","text":"périmètre 20 cm et aire 15 cm²"},{"id":"b","text":"périmètre 40 cm et aire 60 cm²"},{"id":"c","text":"périmètre 20 cm, mais une aire différente"},{"id":"d","text":"on ne peut pas les déterminer"}]'::jsonb, 'a', 'Le quart de tour est une isométrie : la figure et son image sont superposables, donc même périmètre (20 cm) et même aire (15 cm²) ✓. Rien n''est doublé ou quadruplé (réponse b), l''aire est conservée (réponse c), et tout est parfaitement déterminé (réponse d).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e24d444d-47ab-52e2-a389-17e335bd27aa', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'Une droite (d) subit, dans deux situations distinctes, une translation puis un quart de tour. Quelles sont les positions des deux images par rapport à (d) ?', '[{"id":"a","text":"parallèle pour la translation, perpendiculaire pour le quart de tour"},{"id":"b","text":"perpendiculaire pour la translation, parallèle pour le quart de tour"},{"id":"c","text":"parallèle dans les deux cas"},{"id":"d","text":"perpendiculaire dans les deux cas"}]'::jsonb, 'a', 'La translation transforme une droite en une droite parallèle ; le quart de tour la transforme en une droite perpendiculaire ✓. C''est la différence essentielle entre ces deux transformations — la réponse a est la seule à respecter les deux règles.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('30437839-fe0e-5953-893b-585854a682a8', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'On veut construire un triangle rectangle isocèle en A à partir du point B (avec AB donné). Quelle transformation appliquer à B pour obtenir le troisième sommet C ?', '[{"id":"a","text":"un quart de tour de centre A"},{"id":"b","text":"une translation de vecteur AB"},{"id":"c","text":"une symétrie d''axe (AB)"},{"id":"d","text":"un demi-tour de centre A"}]'::jsonb, 'a', 'Le quart de tour de centre A produit un point C tel que AC = AB et angle BAC = 90° : c''est exactement un triangle rectangle isocèle en A ✓. La translation garderait la même direction ; la symétrie d''axe (AB) laisse un point de (AB) sur place ; le demi-tour donne un angle de 180°, pas 90°.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('00ce2958-8e89-502b-842d-b8bb8299673a', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'Un polygone possède un angle de 130°. Quelle est la mesure de l''angle homologue dans son image par un quart de tour ?', '[{"id":"a","text":"130°"},{"id":"b","text":"40°"},{"id":"c","text":"220°"},{"id":"d","text":"50°"}]'::jsonb, 'a', 'Le quart de tour conserve les angles : l''angle homologue mesure encore 130° ✓. La rotation de 90° oriente la figure autrement, mais ne modifie pas les angles internes. 40° (= 130° − 90°), 220° (= 130° + 90°) et 50° résultent de l''idée fausse qu''on ajoute ou retranche l''angle de rotation.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4756e80b-e926-5ba2-81d6-1b378ef7ac40', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'ABCD et AEFG sont deux carrés ayant le sommet A en commun. Le quart de tour de centre A qui envoie B sur D envoie aussi E sur G. Que peut-on affirmer sur les segments [BE] et [DG] ?', '[{"id":"a","text":"BE = DG et (BE) ⊥ (DG)"},{"id":"b","text":"BE = DG et (BE) // (DG)"},{"id":"c","text":"BE = 2 × DG"},{"id":"d","text":"rien de particulier"}]'::jsonb, 'a', 'Ce quart de tour envoie B sur D et E sur G, donc il transforme le segment [BE] en [DG]. Conservation des longueurs : BE = DG ; image d''une droite par un quart de tour : (BE) ⊥ (DG) ✓. Le quart de tour rend les droites perpendiculaires (pas parallèles, réponse b), conserve les longueurs (pas de facteur 2, réponse c) et permet donc de conclure (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ad16f6e7-ae46-5215-ac5b-99f225b0e42c', 'f80ac6be-fb97-5878-8f89-91a0e50de0e7', 'Trois points A, M, B sont alignés. A'', M'', B'' sont leurs images par un même quart de tour de centre O. Que peut-on affirmer ?', '[{"id":"a","text":"A'', M'', B'' sont alignés et (A''B'') est perpendiculaire à (AB)"},{"id":"b","text":"A'', M'', B'' sont alignés et (A''B'') est parallèle à (AB)"},{"id":"c","text":"A'', M'', B'' ne sont pas nécessairement alignés"},{"id":"d","text":"(A''B'') est confondue avec (AB)"}]'::jsonb, 'a', 'Le quart de tour conserve l''alignement, donc A'', M'', B'' restent alignés ; et l''image d''une droite est une perpendiculaire, donc (A''B'') ⊥ (AB) ✓. L''image d''une droite n''est pas parallèle (réponse b, ce serait une translation), l''alignement est toujours conservé (réponse c) et (A''B'') n''est pas (AB) (réponse d).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d4be667a-e2c9-58c9-9b27-d145f2f4262a', 'c65b31e6-7328-5bac-96d5-9410d68d33e8', 'math-1ere-sec', 'Test de compréhension ⭐ : Sections planes d''un solide', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('aa6213c8-10f9-5ea4-a33e-33511d9d29a0', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', 'La section d''un parallélépipède droit par un plan parallèle à une face est :', '[{"id":"a","text":"un rectangle isométrique à cette face"},{"id":"b","text":"un cercle"},{"id":"c","text":"un triangle"},{"id":"d","text":"un carré, quelle que soit la face"}]'::jsonb, 'a', 'Un plan parallèle à une face « recopie » cette face : la section est un rectangle isométrique (superposable) à celle-ci ✓. Un cercle (réponse b) apparaît pour un cylindre ou une sphère ; un triangle (réponse c) pour d''autres coupes ; et la section n''est un carré que si la face elle-même est carrée (réponse d).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3ab5c907-5525-5ee6-ba92-df04d8ca0e10', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', 'La section d''un cylindre par un plan parallèle à une base est :', '[{"id":"a","text":"un cercle de même rayon que la base"},{"id":"b","text":"un rectangle"},{"id":"c","text":"une ellipse"},{"id":"d","text":"un cercle de rayon plus petit que la base"}]'::jsonb, 'a', 'En coupant un cylindre parallèlement à sa base, on retrouve exactement le disque de base : un cercle de même rayon ✓. Un rectangle (réponse b) s''obtiendrait par une coupe contenant l''axe ; l''ellipse (réponse c) viendrait d''une coupe oblique (hors programme) ; et le rayon ne diminue pas (réponse d), contrairement au cône.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('59ddf653-c38b-5161-a89b-ef94b5ddef50', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', 'Le volume d''un cylindre de rayon R et de hauteur h est :', '[{"id":"a","text":"π × R² × h"},{"id":"b","text":"π × R × h"},{"id":"c","text":"(1/3) × π × R² × h"},{"id":"d","text":"2 × π × R × h"}]'::jsonb, 'a', 'Le volume est l''aire de base (π × R²) multipliée par la hauteur : π × R² × h ✓. π × R × h (réponse b) oublie le carré du rayon ; (1/3)πR²h (réponse c) est le volume d''un cône ; 2πRh (réponse d) est l''aire latérale du cylindre, pas son volume.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ce96471a-eda7-598d-bec5-fcdccd386a4a', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', 'La section d''une sphère par un plan est toujours un cercle. Ce cercle est un « grand cercle » lorsque :', '[{"id":"a","text":"le plan passe par le centre de la sphère"},{"id":"b","text":"le plan est tangent à la sphère"},{"id":"c","text":"le plan est très éloigné du centre"},{"id":"d","text":"le plan est incliné"}]'::jsonb, 'a', 'Le grand cercle est la section la plus grande possible : elle a le rayon de la sphère, ce qui se produit quand le plan passe par le centre (distance d = 0) ✓. Un plan tangent ne touche la sphère qu''en un point (réponse b) ; plus le plan s''éloigne du centre, plus le cercle est petit (réponse c) ; l''inclinaison seule ne change rien (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('adcfa96e-c80f-53af-92a7-74faf541ff96', 'd4be667a-e2c9-58c9-9b27-d145f2f4262a', 'La section d''une pyramide par un plan parallèle à sa base est :', '[{"id":"a","text":"un polygone de même nature que la base, mais réduit"},{"id":"b","text":"un cercle"},{"id":"c","text":"un triangle, quelle que soit la base"},{"id":"d","text":"un polygone plus grand que la base"}]'::jsonb, 'a', 'Le plan parallèle à la base produit une figure semblable à la base, de même nature mais réduite (base carrée → carré plus petit, base triangulaire → triangle plus petit) ✓. Ce n''est pas un cercle (réponse b), ni forcément un triangle (réponse c) ; et la section est plus petite que la base, pas plus grande (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8bb707eb-0ba9-5644-a5c7-2706e253a351', 'c65b31e6-7328-5bac-96d5-9410d68d33e8', 'math-1ere-sec', '⭐ Exercice : Volumes et sections usuelles', 1, 50, 10, 'practice', 'admin', 1)
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
  ('483dfe19-e314-5468-943c-2e9627f99ceb', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'Un parallélépipède rectangle a pour dimensions 4 cm, 5 cm et 3 cm. Quel est son volume ?', '[{"id":"a","text":"60 cm³"},{"id":"b","text":"12 cm³"},{"id":"c","text":"23 cm³"},{"id":"d","text":"120 cm³"}]'::jsonb, 'a', 'Le volume d''un parallélépipède rectangle est le produit de ses trois dimensions : 4 × 5 × 3 = 60 cm³ ✓. 12 cm³ additionne (4 + 5 + 3) ; 23 cm³ calcule 4 × 5 + 3 ; 120 cm³ double le bon résultat.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('22d2c6a5-5682-5684-bbb6-49acc0baf219', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'Un cylindre a pour rayon 5 cm et pour hauteur 4 cm. Quel est son volume (en fonction de π) ?', '[{"id":"a","text":"100π cm³"},{"id":"b","text":"20π cm³"},{"id":"c","text":"40π cm³"},{"id":"d","text":"25π cm³"}]'::jsonb, 'a', 'Le volume vaut π × R² × h = π × 5² × 4 = π × 25 × 4 = 100π cm³ ✓. 20π cm³ oublie le carré du rayon (π × 5 × 4) ; 40π cm³ correspond à l''aire latérale (2πRh) ; 25π cm³ est l''aire de la base seule.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('224ea4e8-7dff-5049-a05d-31ccff326a46', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'On coupe un cylindre de rayon 4 cm par un plan parallèle à sa base. Quel est le rayon du cercle obtenu ?', '[{"id":"a","text":"4 cm"},{"id":"b","text":"2 cm"},{"id":"c","text":"8 cm"},{"id":"d","text":"cela dépend de la hauteur de coupe"}]'::jsonb, 'a', 'La section d''un cylindre par un plan parallèle à une base est un cercle de même rayon que la base : 4 cm ✓, quelle que soit la hauteur de la coupe (réponse d écartée). Le rayon n''est ni divisé (réponse b) ni doublé (réponse c) — contrairement au cône, le cylindre garde son rayon.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bb398b1a-bd14-5a50-ba8d-0d01cb1da86a', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'La section d''un cube par un plan parallèle à une face est :', '[{"id":"a","text":"un carré isométrique à cette face"},{"id":"b","text":"un rectangle non carré"},{"id":"c","text":"un triangle"},{"id":"d","text":"un cercle"}]'::jsonb, 'a', 'La section d''un parallélépipède par un plan parallèle à une face est isométrique à cette face ; comme les faces d''un cube sont des carrés, la section est un carré identique ✓. Elle ne peut pas être un rectangle non carré (réponse b), ni un triangle (réponse c), ni un cercle (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a961ae21-9fa0-5ae9-bd47-2450c727dba7', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'Une pyramide a une base d''aire 12 cm² et une hauteur de 5 cm. Quel est son volume ?', '[{"id":"a","text":"20 cm³"},{"id":"b","text":"60 cm³"},{"id":"c","text":"30 cm³"},{"id":"d","text":"17 cm³"}]'::jsonb, 'a', 'Le volume d''une pyramide est (1/3) × B × h = (1/3) × 12 × 5 = 20 cm³ ✓. 60 cm³ oublie le facteur 1/3 ; 30 cm³ divise par 2 au lieu de 3 ; 17 cm³ additionne 12 + 5.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8e4c503-e45e-5742-aeb5-9b3d2058fe4d', '8bb707eb-0ba9-5644-a5c7-2706e253a351', 'Une sphère de rayon 10 cm est coupée par un plan situé à 6 cm de son centre. Quel est le rayon de la section ?', '[{"id":"a","text":"8 cm"},{"id":"b","text":"4 cm"},{"id":"c","text":"16 cm"},{"id":"d","text":"6 cm"}]'::jsonb, 'a', 'Le rayon de la section vaut r = √(R² − d²) = √(10² − 6²) = √(100 − 36) = √64 = 8 cm ✓ (théorème de Pythagore dans le triangle rectangle centre–pied–point du cercle). 4 cm fait la différence 10 − 6 ; 16 cm additionne les carrés sans racine ni soustraction ; 6 cm recopie la distance d.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d3ca394f-04a4-5363-af4e-86ff33e619e9', 'c65b31e6-7328-5bac-96d5-9410d68d33e8', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Volumes, sections et réductions', 2, 75, 15, 'practice', 'admin', 3)
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
  ('f7bea53d-da26-5e42-992b-65f6079e9097', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Un cône de révolution a une base de rayon 3 cm et une hauteur de 10 cm. Quel est son volume (en fonction de π) ?', '[{"id":"a","text":"30π cm³"},{"id":"b","text":"90π cm³"},{"id":"c","text":"10π cm³"},{"id":"d","text":"30 cm³"}]'::jsonb, 'a', 'Le volume d''un cône est (1/3) × B × h = (1/3) × (π × 3²) × 10 = (1/3) × 90π = 30π cm³ ✓. 90π cm³ oublie le facteur 1/3 (c''est le volume du cylindre correspondant) ; 10π cm³ oublie le carré du rayon ; 30 cm³ oublie le π.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01e2ea4a-93f7-5b1c-bf5b-4ebd9f16b3db', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Quel est le volume d''une boule de rayon 3 cm (en fonction de π) ?', '[{"id":"a","text":"36π cm³"},{"id":"b","text":"27π cm³"},{"id":"c","text":"12π cm³"},{"id":"d","text":"108π cm³"}]'::jsonb, 'a', 'Le volume d''une boule est (4/3) × π × R³ = (4/3) × π × 3³ = (4/3) × π × 27 = 36π cm³ ✓. 27π cm³ oublie le facteur 4/3 ; 12π cm³ utilise 4πR² (l''aire de la sphère) ; 108π cm³ oublie de diviser par 3.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4cc5d50a-4244-509f-8432-b971594732b3', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Une pyramide à base carrée d''aire 36 cm² est coupée à mi-hauteur (échelle k = 1/2) par un plan parallèle à la base. Quelle est l''aire de la section ?', '[{"id":"a","text":"9 cm²"},{"id":"b","text":"18 cm²"},{"id":"c","text":"36 cm²"},{"id":"d","text":"6 cm²"}]'::jsonb, 'a', 'La section est un carré réduit à l''échelle k = 1/2 : l''aire est multipliée par k² = 1/4, donc 36 × 1/4 = 9 cm² ✓. 18 cm² multiplie par k = 1/2 (erreur classique sur les aires) ; 36 cm² oublie la réduction ; 6 cm² prend la racine de l''aire.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ac8c77a1-f423-54a4-892a-9d40b7fa5017', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Une sphère de rayon 13 cm est coupée par un plan situé à 5 cm de son centre. Quel est le rayon de la section ?', '[{"id":"a","text":"12 cm"},{"id":"b","text":"8 cm"},{"id":"c","text":"18 cm"},{"id":"d","text":"144 cm"}]'::jsonb, 'a', 'r = √(R² − d²) = √(13² − 5²) = √(169 − 25) = √144 = 12 cm ✓. 8 cm fait 13 − 5 ; 18 cm fait 13 + 5 ; 144 cm est r² (racine oubliée).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('09359191-15b2-5e58-bde8-c115ab39447b', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Un cube a un volume de 8 cm³. Si l''on double la longueur de son arête, quel est le nouveau volume ?', '[{"id":"a","text":"64 cm³"},{"id":"b","text":"16 cm³"},{"id":"c","text":"32 cm³"},{"id":"d","text":"24 cm³"}]'::jsonb, 'a', 'Multiplier toutes les longueurs par k = 2 multiplie le volume par k³ = 8, donc 8 × 8 = 64 cm³ ✓ (l''arête passe de 2 cm à 4 cm, et 4³ = 64). 16 cm³ multiplie par k ; 32 cm³ multiplie par k² (facteur des aires) ; 24 cm³ multiplie par 3.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('996a51ad-89ac-5c87-8fac-ec8dd293e9cb', 'd3ca394f-04a4-5363-af4e-86ff33e619e9', 'Un solide est formé d''un cylindre de rayon 3 cm et de hauteur 4 cm, surmonté d''une demi-boule de rayon 3 cm. Quel est son volume (en fonction de π) ?', '[{"id":"a","text":"54π cm³"},{"id":"b","text":"72π cm³"},{"id":"c","text":"42π cm³"},{"id":"d","text":"54 cm³"}]'::jsonb, 'a', 'Volume du cylindre : π × 3² × 4 = 36π. Volume de la demi-boule : (1/2) × (4/3) × π × 3³ = (2/3) × 27π = 18π. Total : 36π + 18π = 54π cm³ ✓. 72π cm³ compte une boule entière au lieu d''une demi-boule ; 42π cm³ utilise l''aire latérale du cylindre (2πRh = 24π) ; 54 cm³ oublie le π.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('20286657-c01d-5c5f-bffb-f190c619ca1d', '8bea7605-27a1-597f-a6ed-f483ba0da928', 'math-1ere-sec', 'Test de compréhension ⭐ : Activités numériques I', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('3f8a9087-056d-58d3-b823-7ba16d6ae5ef', '20286657-c01d-5c5f-bffb-f190c619ca1d', 'Dans la division euclidienne d''un entier a par un entier b (b non nul), le reste r vérifie toujours :', '[{"id":"a","text":"0 ≤ r < b"},{"id":"b","text":"0 ≤ r ≤ b"},{"id":"c","text":"r < a"},{"id":"d","text":"r > b"}]'::jsonb, 'a', 'Le reste est positif ou nul et strictement inférieur au diviseur : 0 ≤ r < b ✓. Il ne peut pas être égal à b (réponse b), sinon on pourrait diviser une fois de plus ; la condition porte sur b, pas sur a (réponse c) ; et un reste supérieur au diviseur (réponse d) est impossible.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('032afe93-c3b1-5fb4-8147-c1bf7df17a41', '20286657-c01d-5c5f-bffb-f190c619ca1d', 'Quelle est la décomposition en facteurs premiers de 84 ?', '[{"id":"a","text":"2² × 3 × 7"},{"id":"b","text":"2 × 42"},{"id":"c","text":"4 × 21"},{"id":"d","text":"2³ × 3 × 7"}]'::jsonb, 'a', '84 = 2 × 2 × 3 × 7 = 2² × 3 × 7 ✓ (tous les facteurs sont premiers). 2 × 42 (réponse b) et 4 × 21 (réponse c) ne sont pas décomposés jusqu''aux nombres premiers ; 2³ × 3 × 7 vaut 168 (réponse d), pas 84.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('577a3c67-c6f0-5186-a2dd-90a967d4ee79', '20286657-c01d-5c5f-bffb-f190c619ca1d', 'Pour deux entiers a et b, quelle relation lie leur PGCD et leur PPCM ?', '[{"id":"a","text":"PGCD(a, b) × PPCM(a, b) = a × b"},{"id":"b","text":"PGCD(a, b) + PPCM(a, b) = a + b"},{"id":"c","text":"PGCD(a, b) × PPCM(a, b) = a + b"},{"id":"d","text":"PGCD(a, b) = PPCM(a, b)"}]'::jsonb, 'a', 'Le produit du PGCD et du PPCM est égal au produit des deux nombres : PGCD × PPCM = a × b ✓. Ce n''est pas une somme (réponses b et c) ; et PGCD et PPCM ne sont égaux que si a divise b ou l''inverse (réponse d fausse en général).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1833c9c3-09b5-52e2-924c-9764de4e86eb', '20286657-c01d-5c5f-bffb-f190c619ca1d', 'Une fraction est dite irréductible lorsque :', '[{"id":"a","text":"son numérateur et son dénominateur sont premiers entre eux (PGCD = 1)"},{"id":"b","text":"son numérateur est un nombre premier"},{"id":"c","text":"son dénominateur est pair"},{"id":"d","text":"elle est inférieure à 1"}]'::jsonb, 'a', 'Une fraction est irréductible quand on ne peut plus la simplifier, c''est-à-dire quand numérateur et dénominateur n''ont que 1 comme diviseur commun (PGCD = 1) ✓. Que le numérateur soit premier (réponse b), le dénominateur pair (réponse c) ou la fraction < 1 (réponse d) ne garantit pas l''irréductibilité.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('db219caa-7769-5566-bf42-642fac3a4a41', '20286657-c01d-5c5f-bffb-f190c619ca1d', 'À quel plus petit ensemble de nombres le nombre 1/3 appartient-il ?', '[{"id":"a","text":"Q, les rationnels (son écriture décimale est illimitée)"},{"id":"b","text":"D, les décimaux"},{"id":"c","text":"ℤ, les entiers relatifs"},{"id":"d","text":"IN, les entiers naturels"}]'::jsonb, 'a', '1/3 = 0,333… a une écriture décimale illimitée : ce n''est donc pas un décimal (réponse b), mais c''est un quotient d''entiers, donc un rationnel — il appartient à Q ✓. Ce n''est ni un entier relatif (réponse c) ni un entier naturel (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('81f6607c-1e3f-5900-bd7d-5115262f428d', '8bea7605-27a1-597f-a6ed-f483ba0da928', 'math-1ere-sec', '⭐ Exercice : Diviser, décomposer, ranger', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f89d6359-4968-5495-9c4a-53b10b7df4f2', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'Quel est le reste de la division euclidienne de 100 par 7 ?', '[{"id":"a","text":"2"},{"id":"b","text":"14"},{"id":"c","text":"6"},{"id":"d","text":"0"}]'::jsonb, 'a', '100 = 7 × 14 + 2 : le quotient est 14 et le reste est 2 (avec 0 ≤ 2 < 7) ✓. 14 est le quotient, pas le reste (réponse b) ; 6 et 0 ne vérifient pas l''égalité 100 = 7 × q + r.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0083d91a-5fc8-588f-975c-26edfb84e067', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'Quelle est la décomposition en facteurs premiers de 60 ?', '[{"id":"a","text":"2² × 3 × 5"},{"id":"b","text":"2 × 30"},{"id":"c","text":"6 × 10"},{"id":"d","text":"2 × 3² × 5"}]'::jsonb, 'a', '60 = 2 × 2 × 3 × 5 = 2² × 3 × 5 ✓. 2 × 30 (réponse b) et 6 × 10 (réponse c) contiennent des facteurs non premiers ; 2 × 3² × 5 vaut 90 (réponse d), pas 60.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ce298a6-42d4-5688-bb9e-664563e5ce54', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'Parmi ces nombres, lequel est premier ?', '[{"id":"a","text":"23"},{"id":"b","text":"21"},{"id":"c","text":"27"},{"id":"d","text":"15"}]'::jsonb, 'a', '23 n''a que 1 et 23 comme diviseurs : il est premier ✓. 21 = 3 × 7, 27 = 3³ et 15 = 3 × 5 possèdent d''autres diviseurs, donc ne sont pas premiers.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ecadfc3c-a056-5641-a655-cbd4f4daf403', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'Le nombre 6 divise-t-il 234 ?', '[{"id":"a","text":"Oui, car 234 = 6 × 39"},{"id":"b","text":"Non, le reste n''est pas nul"},{"id":"c","text":"Oui, car 234 est impair"},{"id":"d","text":"Non, car 234 n''est pas divisible par 3"}]'::jsonb, 'a', '234 est pair (divisible par 2) et 2 + 3 + 4 = 9 est divisible par 3, donc 234 est divisible par 6 : 234 = 6 × 39 ✓. 234 est pair, pas impair (réponse c) ; il est bien divisible par 3 (réponse d) ; le reste est donc nul (réponse b).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('00331306-6af8-5477-bd8d-45f77a4d0e41', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'Quelle est l''écriture scientifique de 45 000 ?', '[{"id":"a","text":"4,5 × 10⁴"},{"id":"b","text":"45 × 10³"},{"id":"c","text":"4,5 × 10³"},{"id":"d","text":"0,45 × 10⁵"}]'::jsonb, 'a', 'En notation scientifique, le nombre s''écrit a × 10ⁿ avec 1 ≤ a < 10 : 45 000 = 4,5 × 10⁴ ✓. 45 × 10³ (réponse b) et 0,45 × 10⁵ (réponse d) ont un facteur a hors de l''intervalle [1 ; 10[ ; 4,5 × 10³ (réponse c) ne vaut que 4 500.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ee301c39-b82d-57f5-bb8d-ef4fb5435ec5', '81f6607c-1e3f-5900-bd7d-5115262f428d', 'On sait que 36 = 2² × 3² et 48 = 2⁴ × 3. Quel est le PGCD de 36 et 48 ?', '[{"id":"a","text":"12"},{"id":"b","text":"6"},{"id":"c","text":"144"},{"id":"d","text":"4"}]'::jsonb, 'a', 'Le PGCD prend chaque facteur premier commun avec son plus petit exposant : 2^min(2 ; 4) × 3^min(2 ; 1) = 2² × 3 = 12 ✓. 144 (= 2⁴ × 3²) est le PPCM ; 6 et 4 oublient un facteur commun.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('94401368-add4-5917-8fd9-7efd83695dd3', '8bea7605-27a1-597f-a6ed-f483ba0da928', 'math-1ere-sec', '⭐⭐ Révision (type examen) : PGCD, PPCM et notation scientifique', 2, 75, 15, 'practice', 'admin', 3)
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
  ('f6f903c2-2617-5fe3-83e0-829d019425db', '94401368-add4-5917-8fd9-7efd83695dd3', 'On applique l''algorithme d''Euclide : 84 = 1 × 60 + 24 ; 60 = 2 × 24 + 12 ; 24 = 2 × 12 + 0. Quel est le PGCD de 84 et 60 ?', '[{"id":"a","text":"12"},{"id":"b","text":"24"},{"id":"c","text":"60"},{"id":"d","text":"1"}]'::jsonb, 'a', 'Le PGCD est le dernier reste non nul de la suite des divisions : ici 12 (la division suivante tombe sur un reste 0) ✓. 24 est l''avant-dernier reste ; 60 est un des nombres de départ ; et 1 signifierait des nombres premiers entre eux, ce qui n''est pas le cas.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c7c04ff1-83e6-51c1-8001-7e9f2264c513', '94401368-add4-5917-8fd9-7efd83695dd3', 'Le PGCD de 24 et 36 est 12. Quel est leur PPCM ?', '[{"id":"a","text":"72"},{"id":"b","text":"12"},{"id":"c","text":"864"},{"id":"d","text":"60"}]'::jsonb, 'a', 'On utilise PGCD × PPCM = a × b, donc PPCM = (24 × 36) / 12 = 864 / 12 = 72 ✓. 864 est le produit 24 × 36 (on a oublié de diviser par le PGCD) ; 12 est le PGCD lui-même ; 60 est la somme 24 + 36.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3847c2bd-13d3-53d5-b5f5-6a4f758a31e8', '94401368-add4-5917-8fd9-7efd83695dd3', 'Rends la fraction 42/56 irréductible.', '[{"id":"a","text":"3/4"},{"id":"b","text":"6/8"},{"id":"c","text":"21/28"},{"id":"d","text":"42/56 est déjà irréductible"}]'::jsonb, 'a', 'PGCD(42, 56) = 14 (car 42 = 2 × 3 × 7 et 56 = 2³ × 7). En divisant par 14 : 42/56 = 3/4 ✓, forme irréductible. 21/28 (division par 2) et 6/8 (division par 7) sont des simplifications incomplètes ; la fraction n''était donc pas irréductible (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('62a9623e-86b4-5684-a8e9-cac540a51382', '94401368-add4-5917-8fd9-7efd83695dd3', 'Parmi ces paires, laquelle est formée de deux entiers premiers entre eux ?', '[{"id":"a","text":"8 et 15"},{"id":"b","text":"12 et 18"},{"id":"c","text":"14 et 21"},{"id":"d","text":"10 et 25"}]'::jsonb, 'a', '8 = 2³ et 15 = 3 × 5 n''ont aucun facteur premier commun : leur PGCD vaut 1, ils sont premiers entre eux ✓. Les autres paires ont un diviseur commun : PGCD(12, 18) = 6, PGCD(14, 21) = 7, PGCD(10, 25) = 5.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e09cd78d-612a-5ad8-9801-e89bf3c28e11', '94401368-add4-5917-8fd9-7efd83695dd3', 'Écris en notation scientifique le produit (3 × 10⁵) × (4 × 10⁻²).', '[{"id":"a","text":"1,2 × 10⁴"},{"id":"b","text":"12 × 10³"},{"id":"c","text":"1,2 × 10³"},{"id":"d","text":"7 × 10³"}]'::jsonb, 'a', 'On multiplie les nombres et on additionne les exposants : (3 × 4) × 10^(5 + (−2)) = 12 × 10³. Comme 12 ≥ 10, on réécrit 12 = 1,2 × 10¹, d''où 1,2 × 10⁴ ✓. 12 × 10³ (réponse b) est la bonne valeur mais pas une notation scientifique valable ; 7 × 10³ additionne 3 + 4 au lieu de multiplier.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('efb19e18-975d-550e-9315-adf2ec378b96', '94401368-add4-5917-8fd9-7efd83695dd3', 'Deux phares clignotent : le premier toutes les 12 secondes, le second toutes les 18 secondes. Ils clignotent ensemble à un instant donné. Après combien de secondes clignoteront-ils de nouveau en même temps ?', '[{"id":"a","text":"36 s"},{"id":"b","text":"6 s"},{"id":"c","text":"216 s"},{"id":"d","text":"30 s"}]'::jsonb, 'a', 'Ils coïncident aux multiples communs des deux périodes : le premier instant commun est le PPCM(12, 18). Comme 12 = 2² × 3 et 18 = 2 × 3², PPCM = 2² × 3² = 36 s ✓. 6 s est le PGCD ; 216 s est le produit 12 × 18 ; 30 s est la somme 12 + 18.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ce73825a-4a7f-5edf-8c17-472dae3531c6', '80e3789e-822b-542b-939e-bc2ba9538004', 'math-1ere-sec', 'Test de compréhension ⭐ : Activités numériques II', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('188309f2-54e0-5965-a039-d749c9c668af', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'Que vaut 2³ × 2⁴ ?', '[{"id":"a","text":"2⁷"},{"id":"b","text":"2¹²"},{"id":"c","text":"4⁷"},{"id":"d","text":"2⁻¹"}]'::jsonb, 'a', 'Pour un produit de puissances de même base, on additionne les exposants : 2³ × 2⁴ = 2³⁺⁴ = 2⁷ ✓. 2¹² multiplie les exposants (règle de (aᵐ)ⁿ) ; 4⁷ change aussi la base ; 2⁻¹ soustrait les exposants.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca595da3-332e-5c2e-91d8-7c8409d89490', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'Que vaut 10⁻² ?', '[{"id":"a","text":"0,01"},{"id":"b","text":"−100"},{"id":"c","text":"−0,01"},{"id":"d","text":"100"}]'::jsonb, 'a', 'Un exposant négatif désigne l''inverse : 10⁻² = 1/10² = 1/100 = 0,01 ✓. L''exposant négatif ne rend pas le nombre négatif (réponses b et c) ; 100 serait 10² (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('598cae69-0995-53f1-a831-03fc92bd0812', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'L''intervalle [2 ; 5[ contient :', '[{"id":"a","text":"tous les réels x tels que 2 ≤ x < 5"},{"id":"b","text":"tous les réels x tels que 2 < x ≤ 5"},{"id":"c","text":"tous les réels x tels que 2 < x < 5"},{"id":"d","text":"seulement les entiers 2, 3 et 4"}]'::jsonb, 'a', 'Le crochet fermé en 2 inclut la borne (2 ≤ x) et le crochet ouvert en 5 l''exclut (x < 5) : 2 ≤ x < 5 ✓. Les réponses b et c inversent ou excluent 2 à tort ; un intervalle contient tous les réels concernés, pas seulement les entiers (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e652c04e-ac68-572e-9a3c-50e14550041a', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'Pour tout réel a, l''expression √(a²) est égale à :', '[{"id":"a","text":"|a| (la valeur absolue de a)"},{"id":"b","text":"a"},{"id":"c","text":"a²"},{"id":"d","text":"−a"}]'::jsonb, 'a', 'La racine carrée d''un carré est la valeur absolue : √(a²) = |a| ✓ (le résultat est toujours positif). Écrire a (réponse b) est faux quand a < 0 (par exemple √((−5)²) = 5, pas −5) ; a² (réponse c) et −a (réponse d) ne conviennent pas non plus.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60b993bf-78de-555c-9df4-0c47c018b1cb', 'ce73825a-4a7f-5edf-8c17-472dae3531c6', 'Que vaut |−7| ?', '[{"id":"a","text":"7"},{"id":"b","text":"−7"},{"id":"c","text":"0"},{"id":"d","text":"49"}]'::jsonb, 'a', 'La valeur absolue est la distance à 0 : −7 est à 7 unités de 0, donc |−7| = 7 ✓. La valeur absolue est toujours positive (réponse b) et non nulle ici (réponse c) ; 49 est le carré de 7 (réponse d), pas sa valeur absolue.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fc861c87-4342-56d2-b758-66fb3570eb48', '80e3789e-822b-542b-939e-bc2ba9538004', 'math-1ere-sec', '⭐ Exercice : Puissances, radicaux et valeur absolue', 1, 50, 10, 'practice', 'admin', 1)
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
  ('40ba0e01-ef1a-52ff-a17c-40e8bc3a7086', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Que vaut 3² × 3³ ?', '[{"id":"a","text":"243"},{"id":"b","text":"729"},{"id":"c","text":"216"},{"id":"d","text":"15"}]'::jsonb, 'a', 'On additionne les exposants : 3² × 3³ = 3⁵ = 243 ✓. 729 = 3⁶ multiplie les exposants ; 216 = 6³ change la base ; 15 = 3 × 5 additionne au lieu de manier les puissances.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('942235aa-fb71-55e8-93ed-27e0588118fd', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Simplifie √72.', '[{"id":"a","text":"6√2"},{"id":"b","text":"8√3"},{"id":"c","text":"2√18"},{"id":"d","text":"36√2"}]'::jsonb, 'a', 'On extrait le plus grand carré parfait : 72 = 36 × 2, donc √72 = √36 × √2 = 6√2 ✓. 8√3 est faux (8² × 3 = 192) ; 2√18 n''est pas complètement simplifié ; 36√2 confond le carré 36 avec sa racine 6.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6ca24776-dd03-5a59-bf45-5f18d444804e', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Que vaut 5√2 + 3√2 ?', '[{"id":"a","text":"8√2"},{"id":"b","text":"8√4"},{"id":"c","text":"15√2"},{"id":"d","text":"8"}]'::jsonb, 'a', 'Les deux termes ont le même radical √2 : on additionne les coefficients, 5 + 3 = 8, d''où 8√2 ✓. 8√4 additionne aussi les radicandes (erreur) ; 15√2 multiplie les coefficients ; 8 oublie le radical.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0ec286d-bc9a-5317-b1c2-3ed263d469aa', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Que vaut |−3,5| ?', '[{"id":"a","text":"3,5"},{"id":"b","text":"−3,5"},{"id":"c","text":"3"},{"id":"d","text":"12,25"}]'::jsonb, 'a', 'La valeur absolue efface le signe (c''est la distance à 0) : |−3,5| = 3,5 ✓. Elle est toujours positive (réponse b) ; 3 tronque la partie décimale ; 12,25 est le carré de 3,5.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1254fe05-8c48-51b9-83d5-2458f824d733', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Le nombre 3 appartient-il à l''intervalle ]1 ; 3] ?', '[{"id":"a","text":"Oui, car la borne 3 est incluse (crochet fermé)"},{"id":"b","text":"Non, car 3 est exclu"},{"id":"c","text":"Non, car 3 est supérieur à 1"},{"id":"d","text":"Oui, mais seulement parce que 3 est un entier"}]'::jsonb, 'a', 'Le crochet fermé en 3 (« ; 3] ») inclut cette borne, donc 3 appartient à ]1 ; 3] ✓. Un crochet ouvert l''aurait exclu (réponse b) ; être supérieur à 1 ne pose pas de problème puisque 3 ≤ 3 (réponse c) ; et l''appartenance ne dépend pas du fait que 3 soit entier (réponse d).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('517eb5bc-b374-5d04-966c-3cd6793773cc', 'fc861c87-4342-56d2-b758-66fb3570eb48', 'Que vaut (2√3)² ?', '[{"id":"a","text":"12"},{"id":"b","text":"6"},{"id":"c","text":"2√3"},{"id":"d","text":"36"}]'::jsonb, 'a', 'On élève chaque facteur au carré : (2√3)² = 2² × (√3)² = 4 × 3 = 12 ✓. 6 fait 2 × 3 sans élever le 2 au carré ; 2√3 oublie d''élever au carré ; 36 = (2 × 3)² applique mal la règle.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e920a34c-a1b7-5575-bd9b-51f39ee20165', '80e3789e-822b-542b-939e-bc2ba9538004', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Calcul et comparaison sur les réels', 2, 75, 15, 'practice', 'admin', 3)
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
  ('27a68635-c1f7-5bc2-893a-af858331e4ee', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Que vaut 5⁴ / 5⁶ ?', '[{"id":"a","text":"1/25"},{"id":"b","text":"25"},{"id":"c","text":"5²"},{"id":"d","text":"5¹⁰"}]'::jsonb, 'a', 'On soustrait les exposants : 5⁴ / 5⁶ = 5⁴⁻⁶ = 5⁻² = 1/5² = 1/25 ✓. 25 = 5² oublie le signe de l''exposant ; 5² fait 6 − 4 dans le mauvais sens ; 5¹⁰ additionne les exposants.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b8207857-bd28-5baa-be12-b7f8aeb74284', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Rends le dénominateur rationnel : 1/(√5 − 2).', '[{"id":"a","text":"√5 + 2"},{"id":"b","text":"√5 − 2"},{"id":"c","text":"(√5 + 2)/9"},{"id":"d","text":"1/(√5 + 2)"}]'::jsonb, 'a', 'On multiplie haut et bas par la quantité conjuguée √5 + 2 : le dénominateur devient (√5 − 2)(√5 + 2) = 5 − 4 = 1, donc le résultat est √5 + 2 ✓. La réponse c divise par 9 (erreur : 5 − 4 = 1, pas 9) ; les réponses b et d ne suppriment pas le radical du dénominateur.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0aa1e83b-dbaa-5b99-9e23-fedc64c458f1', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Pour a = 9, range dans l''ordre croissant les nombres √a, a et a².', '[{"id":"a","text":"√a < a < a² (soit 3 < 9 < 81)"},{"id":"b","text":"a² < a < √a"},{"id":"c","text":"a < √a < a²"},{"id":"d","text":"ils sont tous égaux"}]'::jsonb, 'a', 'Pour a ≥ 1, on a toujours √a ≤ a ≤ a² : ici √9 = 3, a = 9 et a² = 81, d''où 3 < 9 < 81 ✓. L''ordre ne s''inverse (réponse b) que pour un réel compris entre 0 et 1 ; les autres rangements sont incorrects.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6ca842f-1b5f-5d24-8956-9a1268db576b', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Que vaut |2 − √9| ?', '[{"id":"a","text":"1"},{"id":"b","text":"−1"},{"id":"c","text":"5"},{"id":"d","text":"0"}]'::jsonb, 'a', 'On calcule d''abord l''intérieur : √9 = 3, donc 2 − √9 = 2 − 3 = −1 ; puis |−1| = 1 ✓. La valeur absolue est positive (réponse b) ; 5 viendrait de 2 + 3 ; 0 est faux.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a0323df0-83f9-5576-84d1-4155ead569cd', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Simplifie l''expression 2√12 − √3.', '[{"id":"a","text":"3√3"},{"id":"b","text":"√3"},{"id":"c","text":"2√9"},{"id":"d","text":"√33"}]'::jsonb, 'a', 'On simplifie d''abord √12 = √(4 × 3) = 2√3, donc 2√12 = 4√3. Puis 4√3 − √3 = 3√3 ✓. √3 oublie le facteur (4 − 1 = 3) ; 2√9 et √33 proviennent de manipulations erronées des radicaux.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d3caf22-ee0c-58fd-bf15-41f89dd10556', 'e920a34c-a1b7-5575-bd9b-51f39ee20165', 'Compare les nombres √10 et 3.', '[{"id":"a","text":"√10 > 3, car 10 > 9 = 3²"},{"id":"b","text":"√10 < 3"},{"id":"c","text":"√10 = 3"},{"id":"d","text":"on ne peut pas les comparer"}]'::jsonb, 'a', 'Les deux nombres sont positifs, on compare donc leurs carrés : (√10)² = 10 et 3² = 9. Comme 10 > 9, on a √10 > 3 ✓ (on peut aussi écrire 3 = √9 < √10). Les réponses b et c contredisent ce calcul, et la comparaison est bien possible (réponse d).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'f2fe4a9f-f282-5ef2-915c-e5828a361fb7', 'math-1ere-sec', 'Test de compréhension ⭐ : Activités algébriques', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('23645752-e1e3-59d9-b5fd-2ca96b038265', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'Quel est le développement de (a + b)² ?', '[{"id":"a","text":"a² + 2ab + b²"},{"id":"b","text":"a² + b²"},{"id":"c","text":"a² + ab + b²"},{"id":"d","text":"2a + 2b"}]'::jsonb, 'a', 'Le carré d''une somme fait apparaître le double produit : (a + b)² = a² + 2ab + b² ✓. Oublier ce double produit donne a² + b² (réponse b, l''erreur la plus fréquente) ; a² + ab + b² (réponse c) ne compte le produit qu''une fois ; 2a + 2b (réponse d) confond carré et double.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5250847-4917-52ab-9747-98870e864923', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'L''expression a² − b² se factorise en :', '[{"id":"a","text":"(a − b)(a + b)"},{"id":"b","text":"(a − b)²"},{"id":"c","text":"(a + b)²"},{"id":"d","text":"elle ne se factorise pas"}]'::jsonb, 'a', 'La différence de deux carrés se factorise en (a − b)(a + b) ✓. (a − b)² = a² − 2ab + b² et (a + b)² = a² + 2ab + b² contiennent un double produit absent ici (réponses b et c) ; et l''expression se factorise bien (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b785be37-47be-5cfa-a0f2-b87025fa4cc8', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'Est-il vrai que (x + 5)² = x² + 25 ?', '[{"id":"a","text":"Non : il manque le double produit, (x + 5)² = x² + 10x + 25"},{"id":"b","text":"Oui, c''est correct"},{"id":"c","text":"Non : (x + 5)² = x² + 5"},{"id":"d","text":"Non : (x + 5)² = 2x + 10"}]'::jsonb, 'a', 'Le carré d''une somme comporte un double produit : (x + 5)² = x² + 2 × x × 5 + 25 = x² + 10x + 25 ✓. Écrire x² + 25 (réponse b) oublie le terme 10x ; x² + 5 (réponse c) et 2x + 10 (réponse d) sont également faux.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24b581ad-79a1-5d42-86e5-a2f2cfc96ae5', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'Factoriser une expression, c''est :', '[{"id":"a","text":"la transformer en un produit"},{"id":"b","text":"la transformer en une somme"},{"id":"c","text":"remplacer la lettre par un nombre"},{"id":"d","text":"supprimer toutes les parenthèses"}]'::jsonb, 'a', 'Factoriser, c''est écrire une somme ou une différence sous forme de produit ✓. Transformer en somme (réponse b) et supprimer les parenthèses (réponse d) décrivent le développement, l''opération inverse ; remplacer la lettre par un nombre (réponse c) est une substitution numérique.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba0009e9-a895-5741-8f04-64022268dad3', '84ea718e-9c46-53e3-8d4d-36baf8b207dc', 'L''égalité (x − 1)² = x² − 2x + 1 est-elle vraie pour tout réel x ?', '[{"id":"a","text":"Oui, c''est une identité (elle découle du développement)"},{"id":"b","text":"Non, elle n''est vraie que pour x = 1"},{"id":"c","text":"Non, elle n''est jamais vraie"},{"id":"d","text":"Elle n''est vraie que pour x = 0"}]'::jsonb, 'a', 'En développant (x − 1)² = x² − 2 × x × 1 + 1² = x² − 2x + 1, on retrouve exactement le membre de droite : l''égalité est vraie pour tout x, c''est une identité ✓. Elle ne se limite pas à une valeur particulière (réponses b et d) et elle est bien toujours vraie (réponse c).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fa22561a-f9bf-5d99-85af-0c46f92504de', 'f2fe4a9f-f282-5ef2-915c-e5828a361fb7', 'math-1ere-sec', '⭐ Exercice : Développer et factoriser', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5c23f250-246f-5616-ae33-5438dad37e9d', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Développe et réduis (x + 4)(x + 2).', '[{"id":"a","text":"x² + 6x + 8"},{"id":"b","text":"x² + 8"},{"id":"c","text":"x² + 8x + 6"},{"id":"d","text":"2x + 6"}]'::jsonb, 'a', 'Par double distributivité : x × x + x × 2 + 4 × x + 4 × 2 = x² + 2x + 4x + 8 = x² + 6x + 8 ✓. x² + 8 (réponse b) oublie les termes en x ; x² + 8x + 6 (réponse c) intervertit somme et produit des constantes ; 2x + 6 (réponse d) ne développe pas le produit.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a3f56d3-7d08-5f4a-8ce9-e713ab18c103', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Développe (x + 3)².', '[{"id":"a","text":"x² + 6x + 9"},{"id":"b","text":"x² + 9"},{"id":"c","text":"x² + 3x + 9"},{"id":"d","text":"x² + 6x + 6"}]'::jsonb, 'a', '(x + 3)² = x² + 2 × x × 3 + 3² = x² + 6x + 9 ✓. x² + 9 (réponse b) oublie le double produit 6x ; x² + 3x + 9 (réponse c) ne double pas le produit ; x² + 6x + 6 (réponse d) se trompe sur 3² = 9.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f0ac8470-4434-5e56-a0ef-198f8a51401d', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Développe (x − 5)².', '[{"id":"a","text":"x² − 10x + 25"},{"id":"b","text":"x² − 25"},{"id":"c","text":"x² + 10x + 25"},{"id":"d","text":"x² − 10x − 25"}]'::jsonb, 'a', '(x − 5)² = x² − 2 × x × 5 + 5² = x² − 10x + 25 ✓. x² − 25 (réponse b) oublie le double produit ; le terme en x est négatif ici (réponse c) ; et le carré 25 est toujours positif (réponse d).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84c84fe7-9b4d-5f4c-b1d0-6f91601009d9', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Factorise x² − 9.', '[{"id":"a","text":"(x − 3)(x + 3)"},{"id":"b","text":"(x − 3)²"},{"id":"c","text":"(x + 3)²"},{"id":"d","text":"(x − 9)(x + 1)"}]'::jsonb, 'a', 'C''est une différence de deux carrés : x² − 9 = x² − 3² = (x − 3)(x + 3) ✓. Les carrés (x − 3)² et (x + 3)² (réponses b et c) auraient un double produit en x ; (x − 9)(x + 1) (réponse d) redonnerait x² − 8x − 9.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('90674bc4-e1ba-5b96-8e51-7949b85800c0', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Factorise 4x² + 6x.', '[{"id":"a","text":"2x(2x + 3)"},{"id":"b","text":"2(2x² + 3x)"},{"id":"c","text":"x(4x + 6)"},{"id":"d","text":"2x(2x + 6)"}]'::jsonb, 'a', 'Le facteur commun aux deux termes est 2x : 4x² + 6x = 2x × 2x + 2x × 3 = 2x(2x + 3) ✓. 2(2x² + 3x) et x(4x + 6) (réponses b et c) ne sortent pas tout le facteur commun ; 2x(2x + 6) (réponse d) redonnerait 4x² + 12x.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('900e1f3d-b383-5a6a-b17b-14fa3dc5ed91', 'fa22561a-f9bf-5d99-85af-0c46f92504de', 'Calcule 102² en utilisant une identité remarquable.', '[{"id":"a","text":"10404"},{"id":"b","text":"10004"},{"id":"c","text":"10204"},{"id":"d","text":"10400"}]'::jsonb, 'a', '102² = (100 + 2)² = 100² + 2 × 100 × 2 + 2² = 10000 + 400 + 4 = 10404 ✓. 10004 (réponse b) oublie le double produit 400 ; 10204 se trompe sur le double produit ; 10400 (réponse d) oublie le 2² = 4.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'f2fe4a9f-f282-5ef2-915c-e5828a361fb7', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Identités et factorisation', 2, 75, 15, 'practice', 'admin', 3)
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
  ('e4ab5255-6921-5c60-b136-1d8b683a21e8', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Développe et réduis (2x + 1)(x − 3).', '[{"id":"a","text":"2x² − 5x − 3"},{"id":"b","text":"2x² − 3"},{"id":"c","text":"2x² + 5x − 3"},{"id":"d","text":"2x² − 5x + 3"}]'::jsonb, 'a', 'Par double distributivité : 2x × x + 2x × (−3) + 1 × x + 1 × (−3) = 2x² − 6x + x − 3 = 2x² − 5x − 3 ✓. 2x² − 3 (réponse b) oublie les termes en x ; le terme en x est négatif (réponse c) ; et 1 × (−3) = −3, pas +3 (réponse d).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d4d9ffe-a283-505f-967f-1c7dd098c0e1', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Développe (3x − 2)².', '[{"id":"a","text":"9x² − 12x + 4"},{"id":"b","text":"9x² − 4"},{"id":"c","text":"9x² + 12x + 4"},{"id":"d","text":"3x² − 12x + 4"}]'::jsonb, 'a', '(3x − 2)² = (3x)² − 2 × 3x × 2 + 2² = 9x² − 12x + 4 ✓. 9x² − 4 (réponse b) oublie le double produit ; le terme en x est négatif (réponse c) ; et (3x)² = 9x², pas 3x² (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('179e7bf9-6347-5a78-8ed8-50bc66f49ec5', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Factorise 9x² − 16.', '[{"id":"a","text":"(3x − 4)(3x + 4)"},{"id":"b","text":"(3x − 4)²"},{"id":"c","text":"(9x − 16)(x + 1)"},{"id":"d","text":"(3x + 16)(3x − 1)"}]'::jsonb, 'a', 'C''est une différence de carrés : 9x² − 16 = (3x)² − 4² = (3x − 4)(3x + 4) ✓. (3x − 4)² (réponse b) ferait apparaître un double produit ; les réponses c et d ne redonnent pas 9x² − 16 par développement.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c91d44db-58c3-5a95-83f7-afee7a84938a', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Factorise x² − 6x + 9.', '[{"id":"a","text":"(x − 3)²"},{"id":"b","text":"(x + 3)²"},{"id":"c","text":"(x − 3)(x + 3)"},{"id":"d","text":"(x − 6)(x − 3)"}]'::jsonb, 'a', 'On reconnaît un carré parfait : x² − 6x + 9 = x² − 2 × 3 × x + 3² = (x − 3)² ✓. (x + 3)² (réponse b) donnerait +6x ; (x − 3)(x + 3) (réponse c) est la différence de carrés x² − 9 ; (x − 6)(x − 3) (réponse d) redonnerait x² − 9x + 18.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b847db9-bbf4-51bd-8a89-8f6838a1cfbe', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Calcule 53² − 47² en utilisant une identité remarquable.', '[{"id":"a","text":"600"},{"id":"b","text":"36"},{"id":"c","text":"100"},{"id":"d","text":"200"}]'::jsonb, 'a', 'On utilise a² − b² = (a − b)(a + b) : 53² − 47² = (53 − 47)(53 + 47) = 6 × 100 = 600 ✓. 36 = 6² et 100 sont les deux facteurs pris séparément ; 200 n''a pas de justification.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('241c3dec-94ed-5fd4-a196-5b293bbde5b2', 'd72dceef-c1e9-52c5-9da8-0a3b226b2c50', 'Factorise complètement 2x² − 8.', '[{"id":"a","text":"2(x − 2)(x + 2)"},{"id":"b","text":"2(x² − 4)"},{"id":"c","text":"(2x − 4)(x + 2)"},{"id":"d","text":"(x − 2)(x + 4)"}]'::jsonb, 'a', 'On sort d''abord le facteur commun 2 : 2x² − 8 = 2(x² − 4), puis on factorise la différence de carrés x² − 4 = (x − 2)(x + 2), d''où 2(x − 2)(x + 2) ✓. 2(x² − 4) (réponse b) n''est pas complètement factorisé ; les réponses c et d ne redonnent pas 2x² − 8.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('79e759bf-79d4-53ea-b527-50afe14da0c7', '0a439078-2174-532b-9cc2-aaf496763a2a', 'math-1ere-sec', 'Test de compréhension ⭐ : Fonctions linéaires', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d1dcd694-0694-58f3-9c0b-211c511c5e33', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'Soit f : x ↦ 5x. Quelle est l''image de 3 par f ?', '[{"id":"a","text":"15"},{"id":"b","text":"8"},{"id":"c","text":"5"},{"id":"d","text":"3/5"}]'::jsonb, 'a', 'L''image de 3 est f(3) = 5 × 3 = 15 ✓. 8 additionne 5 + 3 au lieu de multiplier ; 5 recopie le coefficient ; 3/5 divise au lieu de multiplier.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b72a0964-8574-5c7e-8acb-d18e91524a7d', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'Pour toute fonction linéaire f : x ↦ ax, que vaut f(0) ?', '[{"id":"a","text":"0"},{"id":"b","text":"a"},{"id":"c","text":"1"},{"id":"d","text":"cela dépend de a"}]'::jsonb, 'a', 'f(0) = a × 0 = 0 : toute fonction linéaire vérifie f(0) = 0 ✓, quel que soit le coefficient a. C''est f(1) qui vaut a (réponse b) ; f(0) ne vaut pas 1 (réponse c) et ne dépend pas de a (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e624b099-db58-5324-9f76-40014e97a401', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'Augmenter une quantité de 25 % revient à la multiplier par :', '[{"id":"a","text":"1,25"},{"id":"b","text":"0,25"},{"id":"c","text":"0,75"},{"id":"d","text":"25"}]'::jsonb, 'a', 'Une hausse de 25 % correspond au coefficient 1 + 25/100 = 1,25 ✓. 0,25 est seulement la part ajoutée ; 0,75 correspondrait à une baisse de 25 % ; 25 confond le pourcentage avec le coefficient.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76710300-64e0-514d-b2cd-5e8f6c4704d7', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'Dans un repère, la représentation graphique d''une fonction linéaire est :', '[{"id":"a","text":"une droite passant par l''origine"},{"id":"b","text":"une droite ne passant pas par l''origine"},{"id":"c","text":"une courbe"},{"id":"d","text":"une demi-droite"}]'::jsonb, 'a', 'Comme f(0) = 0, la droite d''équation y = ax passe toujours par l''origine O(0 ; 0) ✓. Une droite ne passant pas par l''origine (réponse b) représente une fonction affine ; ce n''est pas une courbe (réponse c) ni une demi-droite (réponse d).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('57351385-9921-56fd-812f-8221532c8e0e', '79e759bf-79d4-53ea-b527-50afe14da0c7', 'Une fonction linéaire f vérifie f(4) = 12. Quel est son coefficient ?', '[{"id":"a","text":"3"},{"id":"b","text":"48"},{"id":"c","text":"8"},{"id":"d","text":"1/3"}]'::jsonb, 'a', 'Le coefficient se retrouve par a = f(x)/x = 12/4 = 3 ✓ (on vérifie f : x ↦ 3x donne bien f(4) = 12). 48 multiplie 4 × 12 ; 8 fait 12 − 4 ; 1/3 inverse le rapport.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a02ae5f3-21ea-5c49-a26a-ded2f391967c', '0a439078-2174-532b-9cc2-aaf496763a2a', 'math-1ere-sec', '⭐ Exercice : Images, antécédents et coefficient', 1, 50, 10, 'practice', 'admin', 1)
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
  ('926fd80e-1217-594d-bc5f-7ba62e2a38f3', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'Soit f : x ↦ 4x. Calcule f(7).', '[{"id":"a","text":"28"},{"id":"b","text":"11"},{"id":"c","text":"4"},{"id":"d","text":"47"}]'::jsonb, 'a', 'f(7) = 4 × 7 = 28 ✓. 11 additionne 4 + 7 ; 4 recopie le coefficient ; 47 juxtapose les chiffres au lieu de multiplier.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('28b322b5-0ea3-5655-a4d4-da2473ba9b8f', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'Soit f : x ↦ 3x. Quel est l''antécédent de 21 par f ?', '[{"id":"a","text":"7"},{"id":"b","text":"63"},{"id":"c","text":"24"},{"id":"d","text":"18"}]'::jsonb, 'a', 'Chercher l''antécédent de 21, c''est résoudre 3x = 21, soit x = 21/3 = 7 ✓. 63 multiplie au lieu de diviser ; 24 additionne 21 + 3 ; 18 fait 21 − 3.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18e609bc-3e67-5b34-b42d-0cb3a7989e0f', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'Une fonction linéaire vérifie f(2) = 10. Quel est son coefficient ?', '[{"id":"a","text":"5"},{"id":"b","text":"20"},{"id":"c","text":"8"},{"id":"d","text":"12"}]'::jsonb, 'a', 'Le coefficient vaut a = f(2)/2 = 10/2 = 5 ✓ (on a alors f : x ↦ 5x). 20 multiplie 2 × 10 ; 8 fait 10 − 2 ; 12 additionne 10 + 2.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a770b159-1a4c-5670-8a10-20ac52eec227', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'Une fonction linéaire f a pour coefficient 7. Que vaut f(1) ?', '[{"id":"a","text":"7"},{"id":"b","text":"1"},{"id":"c","text":"0"},{"id":"d","text":"8"}]'::jsonb, 'a', 'Pour une fonction linéaire, f(1) = a : ici f(1) = 7 ✓ (l''image de 1 est le coefficient). f(0) vaut 0 (réponse c), pas f(1) ; 1 et 8 ne correspondent à rien.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('42935f78-7358-57ea-ab61-46b66d053ae8', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'Diminuer un prix de 30 % revient à le multiplier par :', '[{"id":"a","text":"0,7"},{"id":"b","text":"0,3"},{"id":"c","text":"1,3"},{"id":"d","text":"30"}]'::jsonb, 'a', 'Une baisse de 30 % correspond au coefficient 1 − 30/100 = 0,7 ✓ (il reste 70 % du prix). 0,3 est la part retirée ; 1,3 correspondrait à une hausse ; 30 confond pourcentage et coefficient.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2fbe284a-4942-5fc1-9369-311327cc2d8a', 'a02ae5f3-21ea-5c49-a26a-ded2f391967c', 'La droite représentant une fonction linéaire passe par le point M(2 ; 6). Quel est le coefficient de cette fonction ?', '[{"id":"a","text":"3"},{"id":"b","text":"12"},{"id":"c","text":"4"},{"id":"d","text":"1/3"}]'::jsonb, 'a', 'Le coefficient se lit à partir d''un point de la droite : a = y/x = 6/2 = 3 ✓. 12 multiplie 2 × 6 ; 4 fait 6 − 2 ; 1/3 inverse le rapport (x/y).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d88ae6d1-2229-5595-abf1-d03108ea44b6', '0a439078-2174-532b-9cc2-aaf496763a2a', 'math-1ere-sec', '⭐⭐ Révision (type examen) : Fonctions linéaires et pourcentages', 2, 75, 15, 'practice', 'admin', 3)
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
  ('dff291d9-c4ff-587e-959d-9b16d5041f2e', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Une fonction linéaire f vérifie f(3) = 12. Calcule f(5).', '[{"id":"a","text":"20"},{"id":"b","text":"14"},{"id":"c","text":"60"},{"id":"d","text":"17"}]'::jsonb, 'a', 'On détermine d''abord le coefficient : a = 12/3 = 4, donc f : x ↦ 4x. Alors f(5) = 4 × 5 = 20 ✓. 14 ajoute simplement 2 à f(3) ; 60 multiplie 12 × 5 ; 17 additionne 12 + 5.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4619fe42-7c85-512c-b019-b84aa1f9f487', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Parmi ces situations, laquelle correspond à une fonction linéaire (proportionnalité) ?', '[{"id":"a","text":"le périmètre d''un carré en fonction de son côté (P = 4x)"},{"id":"b","text":"l''aire d''un carré en fonction de son côté (A = x²)"},{"id":"c","text":"le prix payé = 3 dinars par article + 5 dinars de frais fixes"},{"id":"d","text":"la taille d''une personne en fonction de son âge"}]'::jsonb, 'a', 'Le périmètre P = 4x est de la forme ax (avec a = 4) et vérifie P(0) = 0 : c''est une fonction linéaire ✓. L''aire x² n''est pas proportionnelle (réponse b) ; le prix avec frais fixes est de la forme ax + b (fonction affine, réponse c) ; la taille en fonction de l''âge n''est pas proportionnelle (réponse d).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e519388f-6a1e-5af9-a5b8-42d5dd039002', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Un article coûte 100 dinars. Il subit une hausse de 10 %, puis une baisse de 10 %. Quel est son prix final ?', '[{"id":"a","text":"99 dinars"},{"id":"b","text":"100 dinars"},{"id":"c","text":"101 dinars"},{"id":"d","text":"90 dinars"}]'::jsonb, 'a', 'Les deux variations se composent : × 1,1 puis × 0,9, soit × 0,99. Donc 100 × 0,99 = 99 dinars ✓. On ne revient pas à 100 dinars (réponse b) : une hausse puis une baisse du même pourcentage font toujours perdre un peu.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c652a375-c6a2-51dd-8696-a3b1e36d6b99', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Soit f : x ↦ 2,5x. Quel est l''antécédent de 10 par f ?', '[{"id":"a","text":"4"},{"id":"b","text":"25"},{"id":"c","text":"7,5"},{"id":"d","text":"12,5"}]'::jsonb, 'a', 'On résout 2,5x = 10, soit x = 10/2,5 = 4 ✓. 25 multiplie 2,5 × 10 ; 7,5 fait 10 − 2,5 ; 12,5 additionne 10 + 2,5.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c7f7b30c-8442-5788-9872-b956358743a6', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Une droite passe par l''origine et par le point A(4 ; −2). Quelle est l''équation de la fonction linéaire qu''elle représente ?', '[{"id":"a","text":"y = −0,5x"},{"id":"b","text":"y = 0,5x"},{"id":"c","text":"y = −2x"},{"id":"d","text":"y = 2x"}]'::jsonb, 'a', 'Le coefficient se lit sur le point A : a = y/x = −2/4 = −0,5, d''où l''équation y = −0,5x ✓. Le signe est négatif (réponse b fausse) ; −2 et 2 (réponses c et d) confondent l''ordonnée du point avec le coefficient.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e6d6d9c0-f998-59f2-9c13-84755a45b1e0', 'd88ae6d1-2229-5595-abf1-d03108ea44b6', 'Un ressort s''allonge proportionnellement à la masse suspendue. Une masse de 6 g provoque un allongement de 2 cm. Quel allongement provoque une masse de 15 g ?', '[{"id":"a","text":"5 cm"},{"id":"b","text":"45 cm"},{"id":"c","text":"11 cm"},{"id":"d","text":"4,5 cm"}]'::jsonb, 'a', 'L''allongement est une fonction linéaire de la masse, de coefficient a = 2/6 = 1/3 cm par gramme. Pour 15 g : 15 × 1/3 = 5 cm ✓. 45 cm multiplie 15 × 3 ; 11 cm ajoute 15 − 6 + 2 ; 4,5 cm est une estimation sans le bon coefficient.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'math-1ere-sec'
      AND e.source = 'admin';
  END IF;
END $$;

