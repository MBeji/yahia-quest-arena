-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: arabic-1ere (اللغة العربية)
-- Regenerate with: npm run content:build
-- Source of truth: content/arabic-1ere/
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
  ('arabic-1ere', 'اللغة العربية', 'نتعلّم القراءة والكتابة معًا: نتعرّف على الأصوات والحروف، ونقرأ المقاطع والكلمات، ونرسم الحروف، ونستمع ونتكلّم ونبني جملًا بسيطة، وفق برنامج اللغة العربية (طريقة أنيسي) للسنة الأولى من التعليم الأساسي', 'Esprit', 'subject-arabic', 'Languages', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-base'))
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
      AND e.subject_id = 'arabic-1ere'
      AND e.source = 'admin'
      AND q.id NOT IN ('f30d0d25-4d37-52cf-bd69-f08da894dcf9', '599fc767-30bd-59d0-af3c-1d7d58c9f226', 'dc46e3ba-d74e-5438-a8e7-68776aa0ceee', 'cc991416-2028-5bc8-8ef2-d16e15ab5ab2', 'a82820d0-9eeb-5489-a5bb-502f4bce7ccd', 'd71fefc0-4b8e-55af-a04a-ee0149231bab', '48820f18-d6ff-5bd8-a9fd-6d1929d58164', 'fc07af22-7827-5598-a6f9-f060854767cf', 'c9a47e37-f253-5dd3-ba2d-71159dde9c26', 'ff0a0c58-62ba-5f77-bfc8-364fc95e0c51', 'a5fd055c-149e-55cf-993e-6c411c0df7c2', '802bc4a5-23b2-5872-b4b7-86c5065830b9', 'e93e1fa7-3cee-58d3-ad6b-66f3e2ed550a', '5586e77a-7321-5a9c-ba0e-6656b7943beb', 'e80c3c63-8b94-5e3e-8868-62a421b240e6', '55cb50af-0783-5930-a27b-1ade4e0a1ed2', '5bd84392-65a0-5b3e-bd36-f0f0f7cad4d5', 'dca06bba-974f-5775-8df3-47ea9799331f', 'c950639a-3197-59a0-a812-fe8e1c90e63b', '1fa9a140-0004-5bdf-a8bd-416f8a95c3ba', 'fafb51ad-dd2a-5dc4-b605-b9e344faf89a', 'f9f16cf2-c844-5f9b-88c5-2361cd7946a9', '98d3d804-7cc1-55e6-8251-4de14852d53b', 'b46d0438-84c7-5446-a121-67c09662c670', 'a80c4508-2a0b-55ed-a63d-5e9409ebd883', '11778a3d-ec5a-5663-a608-694b13f46b13', 'a97732c1-39e0-5e70-b32d-e721c24dd268', 'ebabfc8a-f388-51da-b0bb-f2da10ef5946', 'ee3e1e14-0b74-5121-988d-df297de5f3a7', '43700ddd-dd0b-5449-9c7d-eb4b7c27d173', 'a0c9c9f1-5f0b-5950-a227-fd3456915bc2', 'e883d83b-8967-52b1-b80a-938917b20c2f', 'ef935a5b-b0ef-5221-b285-37a41ba1d648', '21259c4c-ea36-54dd-993e-08a61c653352', 'a67255c5-cd9c-5ba9-9f0d-7b65b8a2032d', 'af6753fe-bb69-572c-9cad-2d35b27cfaf9', '326553e3-674b-5d7b-bc0f-230e23428dd0', '31b1fc2a-41f9-5f37-a026-e60e7c4c0325', 'f46b1655-caae-5003-8d4d-f6e7e4b1ba27', 'b87b66fc-2484-566b-9a53-587af37ab1e5', 'fd744f4c-c723-5e00-ad89-4af3613ff685', '1f0758c3-b3de-5625-90d2-4f5b87f70683', 'df8641a7-a315-58b5-b1f4-b05b843ebd95', '76bd6896-b3f7-55b2-b52a-f1867381666f', '9afee316-eed9-5e73-a777-cb5ce5e623de', '98c4519b-75bd-582a-ba8b-5e56bfa5758e', '9a87e285-33e4-59b1-acd1-c90f42fce53f', '8fdac534-0c47-5c2e-a118-44d22345c4d2', '1d468a5b-aa34-5f68-8803-4b07ebb6f303', '3523ab08-ac25-596f-9cda-731b2332674a', '134c1c75-643d-5bc3-85eb-839d865f05ae', '008e7118-7d21-53f9-9f8f-887c7eeaf885', 'f0486a25-d208-59a0-9cf9-738174a83aa2', 'f006cbaa-1ffb-5ae1-8289-4afd00b68b91', 'd78cbabc-7531-5a2f-b988-de27dd837130', '2d5d3394-6588-575a-9153-c9ddfe364a40', '3d3af95d-7a20-5352-a737-c2a57268ea48', 'cba41f21-e38a-5365-a791-f52982a5d1ee', '229062dd-a565-5c75-b2db-dbfdb38097b4', '7f231859-55ed-5bcb-b124-077b0d670e6f', '86fa0ec5-2be2-56eb-9c11-c51b9f245062', '851f1a38-82df-5834-85ec-35d9a2e7788e', 'a1e8b1b0-f782-5da7-93d6-23e0e94687ee', '056c5ee2-3ed4-5c00-a934-d45709746aee', '02233fc1-6132-54ff-a484-b3ea09762e86', '1f08f15d-6423-5ee7-9278-5fbb3228dd3d', 'e7cd28ac-f6b2-5c32-8531-e6845ae44e52', '9b355f5e-7034-5c28-9f80-cf3e68266262', 'faaeea04-f3f6-52f5-8327-f4c17b8874d0', '1ed6b763-bf34-59c4-bc5f-6e09c7d3f318', '33a9edd8-57cf-530a-8aad-1a70920325f5', '3b5f2a48-53f1-5b72-92b6-637e622f0fb9', '9e0e4826-c09e-5b7d-8c4e-2a5606987ed5', '6bcbf905-cf53-54bc-8b39-d3f7b60fc3c5', 'f1c8663b-f84a-5230-9d10-3d78d1afe1dc', '92eb4591-70f0-51a4-b029-b51ec168cef7', '113ad9f9-c829-58db-965c-533e8ceb3673', '991e622d-3bbd-572d-ac09-501a9f0077b6', '402a9800-c8cc-5b20-a44e-f2fcad30c6cf', 'df1ba87b-bfb4-528f-987d-c73b1a9a23ee', '15e2537c-6668-5d8e-aebd-cce119cb3753', '89eb2bb6-b24b-55b8-8cdf-4755683d0680', '44ac39ad-4d93-572d-b5f1-11ef8f36998b', '80297f04-3da5-5f66-913c-78a9ed938d73', '2d0120c6-dd89-52ac-a0fb-b8dce3243f58', '63af78e5-9ee2-5318-9603-35ae0a13e275', 'fb5c9459-ae4f-5023-b830-96acb49ef556', 'b42d191a-8a1f-5285-845c-d233488cc6a6', 'a0726909-bf8e-5481-952d-5a8558eb5260', 'e80c5789-93e6-5812-abd5-56e9fc14deec', '03972102-d480-5b42-996c-be76f666f91c', 'b1e340a0-e09f-5893-a21e-32d48f699b4a', '464dd7e2-e28c-5144-b203-38b7cdd663a0', 'abb6010e-df0a-5c1f-b35e-4bfe3717b953', '8ad03104-2945-58cf-942b-ac03c8d1b79d', 'aed264ae-832f-54a7-b23b-dd3e3cb7585d', '2bf4c9ed-e924-51c0-abbe-e82ee04e406e', '765d490f-f981-549c-a088-2d3d85a1eb6c', '9726f204-5b32-503e-a903-5c9718ce9396', 'ed53ac7a-4e2a-59f8-b994-43536353956b', '92bd14e3-8000-5493-b6a5-ef68678ca1fd', 'b9796748-bada-5330-9018-6af1c5b5d1a5', '77814524-cef6-5693-9b42-048d5d32696c', '75391ab3-ba46-5999-a795-3b608b453965', '0bc9d003-cba2-5c5a-bded-4e702d174799', '3a51c766-2497-5969-8386-07607b13eafd', '00ba5ee9-20cd-5567-9527-e1d51c0667b5', 'bec44fcf-1c1c-519e-8fc2-8c3e34b3449b', 'e598c68b-3bb5-543d-8236-cc25c108042b', '27e505fa-73c0-5e89-ba34-9034a585faac', '4f8159fa-c6d4-5846-be1c-de46b0e1749c', '5faec28f-b80c-55ac-b81e-7d359c4b28c8', '3e17a669-a491-569f-bff9-27ff8c807fee', 'a7ef9a5b-86cb-588b-9cee-45793b54a8d2', 'b747124d-02aa-55c4-b292-1294273e27ec', '10798752-92cc-584f-b749-a55c00d5da30', '3d029ce2-9e92-5c62-9d5f-4feda0558bd8', 'c2bbdfd3-a642-5ddf-9958-5e5d55038e7b', '605691b7-a003-588b-aef1-962d120f83ea', 'fb63c65f-c584-51b4-a161-f5ffeafcc67f', 'df0a321f-a255-5d0e-82d0-e6c6b6d2c80d', '1fe49179-14a9-5f6c-8d17-4a03ba73117d', 'e6c78ebe-d1c5-5c4c-8f73-10b4f0f9efd4', '53f8405f-6590-5bd7-a3bf-855d45690f32', '7bca5948-40b9-5a13-b1b1-0bf58015a46c', '2618ffb2-f987-5178-86c0-4460646663d5', '9d71a6b2-c87f-5fdf-a9fb-fa34e66fafba', 'c3a67fe2-75f6-54f3-a43e-28845bbe9d34', 'c34544f0-27b7-5330-9f5e-9fa7caf2910b', 'f66c746d-acff-50ad-91e1-bf553e16448c', '294ca77c-4466-58d9-93fd-3802a5b56de1', 'cead8c4c-b81a-5fe2-9262-d80b1faf9044', '3e7e6ff4-f415-5237-84e6-cabadd48c265', 'c12c13d1-1653-55fd-be2a-17c1f370a605', '73af3572-4e32-53d3-ac39-18980dd28d27', '022d37a4-bcac-5ffa-8731-1533097f3a2a', '6d45221e-a891-5d5a-a4fe-59908a2ee632', '92cd3391-b458-568f-b6e8-776d863c300c', 'a90a0edd-4063-540d-a77e-34286c741ffb', '51aab555-0343-59ab-a2f0-de135476f472', 'ac4f2f5b-7a7b-5bd3-9169-3b5c5879be8c', '4c217b63-e004-5aca-bf4a-1e093e08a231', '6f3be466-7b1a-5c8a-a5a5-b03e59cc9eb0', 'd1232de4-790a-5e79-ac01-a437b6ff73cc', '2621e1a2-6096-5406-b88f-fbebeeafb5d4', '9933c010-42de-5a27-9964-ad25dbb31276', 'e8cce4f4-428c-53f7-b06d-adf785655bfa', '03901820-29ac-573f-9119-1c03f1d90f1a', 'e4f4f82e-edb6-5f99-98f3-e682037641dc', '8f41ead6-df2f-57b1-aba3-b1ec2ec6b96b', '8ede27c5-d633-597b-93f8-e1291ffd25ad', '31b98056-f392-5101-ab78-fb677f8093d0', '477a078a-edca-54f7-bcce-ab5b346f55c1', 'a6072144-34c3-5e55-85c3-aaee3a6285b9', '98a842e8-c470-5334-b8ed-90d3956b6837', '9f6fe939-a2e4-55da-b8f3-022bc159ede9', 'b78e80e9-369f-5997-8cbe-1ecff581148f', 'af3b3e91-0375-5088-ba93-a16c5dd4d0ce', '826d40c4-d0a9-571d-b89f-d3246628cd3b', '036d0331-507f-59ef-b1a3-ed0712c99d07', '92f1b183-0e32-50a2-84a8-d16ea38d3f34', 'f2375994-0c53-5bf9-800c-b8e39bd9fd33', 'c75f6f6b-c6e7-5af3-8e31-0c0aa08e9b61', 'da763a5d-1fb8-5f6d-a5fe-2f0326fd0b74', 'bc80436d-badc-5604-a137-634d4ca2aec3', 'e2c7449f-5271-5732-9f69-5b8a54512cf8', '363febe8-fe3e-5371-adb6-c7e6c80b9474', '3d367671-e492-512d-93b9-e62c0150fccc', '1209dbb4-3747-5c45-adb7-d692fc5adff2', 'af8799c0-576d-557d-a478-362691a246ee', '977dcdbb-f536-5a31-bf5c-203e78f9544d', '0be656df-984a-5d0e-8f66-c266d854feb6', '52326633-226c-55f5-b983-4bddafb68d95', 'bcf6cae4-9d6d-56a6-a0fb-3796f4890d57', '0c8295ac-98e8-5097-9a6f-ce37e715a845', 'ac0ad1da-7c99-5483-8a81-e8a5be02f0fc', '786babcd-4189-58df-b101-ef8c46b6329f', '42d77a2c-a0a9-568c-a439-06e6ddc24fa6', 'a3bd468c-4be5-5a40-b456-0935dafacfac', 'e87b5886-3900-5956-97ed-5897c8cbbc38', '6ed50abe-360f-594e-a8b2-031c8173d3dd', '0f97acb8-9534-502f-9fff-a4db96027871', '91610a25-e1e6-5ddf-b34c-629877fd7f8d', 'd63def28-aeb7-5aa2-8f0e-41f612f1f397', 'f6524cca-d0cb-54fe-ae90-f8bf28a7e5f0', '1cdfba25-b126-5481-a735-97206a695909', 'd746c22e-8f4d-5062-adb7-637720b759bd', 'bffe59f4-d355-53a9-82f8-7a6692fb6667', '24935e42-43bc-560b-a9a4-ac0eba10837a', '31eebf21-a5ca-594a-bc4e-6c2230c467b3', '9849eb1c-db7e-5784-b3c2-c01f187b585d', '853974ec-050e-5511-b78b-560482c33357', '166213f1-4280-5b0f-8dc6-fcda9b47f50b', 'a3074339-2258-5eeb-b284-c52ed01533a9', 'dcbc0eb2-f1c5-5d8c-8369-c4e631a3c52e', '376ed589-92f9-5adc-9c1a-99a7636950d8', '1dd53d1b-00a3-5110-a77e-65d36a8e6fa2', '642ff382-1ec0-5268-bf77-a5fdfea5b9bb', '67a92767-18ab-50ff-a001-ab75016b0ee2', '5233d09d-6fa3-5a36-b6f2-2cde1ad3bff5', '8a130a15-3cf2-51ad-b9e0-dd28e623abb9', '12a36e10-7ffc-515a-b144-bbdb65bf77d6', '0cb491ef-3d25-590d-bc3e-a0bd53983a88', 'ab27aaea-0db8-51aa-b0f0-9f958729aa07', '45002c85-4c98-5d64-821f-b11df89e1e2e', '94a798af-b5f0-5dea-a2a8-3b9b59f767d6', '1714f76d-b760-5ebf-a32e-fc6254643759', 'b3143e46-1f58-5969-9946-7420b3b69aa5', '13c42b69-7ec7-5ac0-8b76-c183c27a12ea', 'ac5f0136-0e5f-5cb2-acef-9e2422e1eeee', '2a793922-46fb-53cf-95c6-b24f272ab737', 'c53da46c-b79a-5047-b146-8929187e8dde', '5578aed5-ded1-5392-8f07-08c7a0b2cd47', '4148f6c3-6b58-5207-8d41-9787be0e89e2', '44014185-c08b-5b56-a454-1903af61fcc1', '81f9bcea-d995-5ea3-ad54-7019681a960d', '31da48d2-38fc-5b44-9357-ed6f2d477ffc', 'ae2ab424-2290-509a-a268-dd729d6a3f7e', '7e4388ef-8453-583f-b68b-be08fd352ccd', 'eeb329ab-8be3-5a65-912d-a7e3243dc82f', '1008a12f-dabd-5cd2-8def-2e23af503b83', '82b6fc99-6b45-5dd6-8da3-e7701274008e', 'f67de9ae-a39c-5def-9d9c-8e1fc4db6d8e', '0dad2e38-b243-5740-bd9f-cb33b50fd038', 'd3e70373-51c9-52c9-a5b2-700e20869970', '335be1a3-d794-5952-992e-d724d7b7b766', '73c576e0-813d-5c6b-b511-6b50916d715b', 'c792c926-079e-5089-9357-28cdd32b940f', 'dbb7a41c-f7be-5835-948d-56a0e9f708f2', 'dffd03a3-3fba-5bad-abdf-44f76481bdbd', '40b29a89-b7b3-57f1-bd92-c6d10afa4f92', '0c725610-5a73-5ac2-b019-86e6a87cd502', '35b9ec97-dc7d-5d35-b55a-9c20036f6c5d', 'cb2d8086-c421-511c-af4e-73357b77fef1', 'b7c4b40b-dfff-5104-8d67-bb7fd8cfb5d5', 'd789efa1-5841-5612-a909-44ab689345fb', '04192f7f-2f62-51bc-b7f7-efd31f7b32e5', '09596525-59bd-5272-bccc-d37d23af4033', '2cb22a01-978b-51ea-8d9e-5d148fb76775', '2cc6f213-d720-5aeb-8f67-038f0c2a8ef2', 'f28c2c35-f76d-53c1-9449-83fbf6ccc0c3', 'e003702e-1024-5e71-aed2-b8998143e8e5', 'dcca4b18-a3fa-53eb-95c1-962ec7ad815e', '2a5f95ef-0d69-57c3-a8be-d200354d1800', '7e7f15a0-ff0c-587a-8d3d-1c1bd31cb736', '8b2e3a32-65a2-57eb-9e3f-b73677622096', 'dcaa616e-7775-588f-92c8-3835802611be', '15b1af9a-68b2-5ed8-a7ab-3cd845e9a36b', '70a7eb0d-2621-5d53-ac97-4c89734bd93f', 'f27ffaf4-31cc-5a55-842e-06f9b73df29e', '5c36d561-9357-5a99-966f-112b9c1f180a', 'fd6dbd90-5f18-5d75-8917-545d2ebf2195', '49b06dde-002c-53e7-8623-bf4886966c0b', 'c98f9865-7203-552a-8b7a-1dd467a94813', '96eb2dd1-9975-5666-ad51-64b190b9c1ed', 'd80b16e1-e6f8-5c00-bef0-32e361db7e3f', '2f9ae570-68b6-5c0f-979f-4cb5f34ee917', '9f8be5f9-01f4-5138-8e85-0711060f34c0', '1c96874f-d8f3-5395-81a8-233c28b12802', 'daf5e1f7-deff-53ca-a8bf-0d0970b7b81b', '38db23ce-89f0-5d8f-8f39-8a2ca145e311', '610aedb1-85d7-545c-a330-b2424b0c3637', 'b129e063-cf1f-5c49-a581-b286e06bbd02', '33c54600-8e85-529d-af7b-f2a5c495964d', 'c92c654c-524d-54a6-9135-44569e2d0d65', '09c9aa3a-1c35-58ab-ae10-49887427565e', '53b384e8-ec5f-5d3b-9758-d58880dff052', '885cb6d1-7f54-5885-b8a6-eb671f524c72', 'edf2004e-8abf-5b1a-8ec0-8e692558862c', 'a19b844c-7806-5f1a-a645-14435c37bac5', '92f81327-34d4-539e-8204-1b620cb5266d', 'e59bd658-ff62-555f-b424-8f080a791bec', 'c3ff0227-2fff-58dc-a304-126688fbae19', '74ea5a31-a272-5076-a195-1c0bdc638c1c', '8fb355ef-1ae6-5843-a0d9-3fb83d3addee', '9ee0b273-4b6b-587b-b297-81f80fa419c2', 'c7486a1c-d7f6-52bd-98f8-8e066f7f5757', '0e20c477-445e-5477-a1c9-8c625f911719', '1a1949dd-7c8d-55f1-b2cd-4b3f52d98be9', '265e26c1-08be-5d1e-80f9-5fb8a77c4df6');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'arabic-1ere' AND source = 'admin' AND id NOT IN ('9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'b39c9922-136e-5093-b32a-4e1382a26ef7', '0fae725c-0549-5b50-8215-376ae84b771e', 'eebee73f-74a1-5624-a159-eb75a2455812', '124a0815-7431-5645-b0c2-e654e8c5a48f', '062c1e13-d200-5887-ad69-ddcf8b402140', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'b0e5bcce-668b-57bd-9380-672d5aa58053', '74937947-28ae-587e-b282-bf3d53718837', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', '44f59472-a7fe-5711-aedb-e649b52ecbfe', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', '265e811c-8a41-5fd4-ae5e-15181be6c374', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', '006d5192-e40a-569e-9b0c-73945cfcb790', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', '53f25153-d233-5811-a821-3948a78216cd', '5d33a646-1810-5cd4-91c9-226be8bca7e4', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'ddca789a-6a4d-55b6-956a-944f82356b1c', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'd085a744-b762-5d86-9572-c90d9fdf1445', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', '41c45fda-e384-5575-ab75-5da4f020007d', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'b51e3d11-54d8-5161-83b0-2ad100d04021', '96eec3b7-60df-5878-a02b-6dd44655ec82', '5ee41667-dfc3-5685-9e7b-883110426278', '02f95c48-e921-5e4f-9edc-a07b03fecaff', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', '6abb892d-6a62-5629-ae03-c5fd780450d5', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07');
DELETE FROM public.questions WHERE exercise_id IN ('9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'b39c9922-136e-5093-b32a-4e1382a26ef7', '0fae725c-0549-5b50-8215-376ae84b771e', 'eebee73f-74a1-5624-a159-eb75a2455812', '124a0815-7431-5645-b0c2-e654e8c5a48f', '062c1e13-d200-5887-ad69-ddcf8b402140', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'b0e5bcce-668b-57bd-9380-672d5aa58053', '74937947-28ae-587e-b282-bf3d53718837', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', '44f59472-a7fe-5711-aedb-e649b52ecbfe', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', '265e811c-8a41-5fd4-ae5e-15181be6c374', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', '006d5192-e40a-569e-9b0c-73945cfcb790', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', '53f25153-d233-5811-a821-3948a78216cd', '5d33a646-1810-5cd4-91c9-226be8bca7e4', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'ddca789a-6a4d-55b6-956a-944f82356b1c', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'd085a744-b762-5d86-9572-c90d9fdf1445', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', '41c45fda-e384-5575-ab75-5da4f020007d', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'b51e3d11-54d8-5161-83b0-2ad100d04021', '96eec3b7-60df-5878-a02b-6dd44655ec82', '5ee41667-dfc3-5685-9e7b-883110426278', '02f95c48-e921-5e4f-9edc-a07b03fecaff', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', '6abb892d-6a62-5629-ae03-c5fd780450d5', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07') AND id NOT IN ('f30d0d25-4d37-52cf-bd69-f08da894dcf9', '599fc767-30bd-59d0-af3c-1d7d58c9f226', 'dc46e3ba-d74e-5438-a8e7-68776aa0ceee', 'cc991416-2028-5bc8-8ef2-d16e15ab5ab2', 'a82820d0-9eeb-5489-a5bb-502f4bce7ccd', 'd71fefc0-4b8e-55af-a04a-ee0149231bab', '48820f18-d6ff-5bd8-a9fd-6d1929d58164', 'fc07af22-7827-5598-a6f9-f060854767cf', 'c9a47e37-f253-5dd3-ba2d-71159dde9c26', 'ff0a0c58-62ba-5f77-bfc8-364fc95e0c51', 'a5fd055c-149e-55cf-993e-6c411c0df7c2', '802bc4a5-23b2-5872-b4b7-86c5065830b9', 'e93e1fa7-3cee-58d3-ad6b-66f3e2ed550a', '5586e77a-7321-5a9c-ba0e-6656b7943beb', 'e80c3c63-8b94-5e3e-8868-62a421b240e6', '55cb50af-0783-5930-a27b-1ade4e0a1ed2', '5bd84392-65a0-5b3e-bd36-f0f0f7cad4d5', 'dca06bba-974f-5775-8df3-47ea9799331f', 'c950639a-3197-59a0-a812-fe8e1c90e63b', '1fa9a140-0004-5bdf-a8bd-416f8a95c3ba', 'fafb51ad-dd2a-5dc4-b605-b9e344faf89a', 'f9f16cf2-c844-5f9b-88c5-2361cd7946a9', '98d3d804-7cc1-55e6-8251-4de14852d53b', 'b46d0438-84c7-5446-a121-67c09662c670', 'a80c4508-2a0b-55ed-a63d-5e9409ebd883', '11778a3d-ec5a-5663-a608-694b13f46b13', 'a97732c1-39e0-5e70-b32d-e721c24dd268', 'ebabfc8a-f388-51da-b0bb-f2da10ef5946', 'ee3e1e14-0b74-5121-988d-df297de5f3a7', '43700ddd-dd0b-5449-9c7d-eb4b7c27d173', 'a0c9c9f1-5f0b-5950-a227-fd3456915bc2', 'e883d83b-8967-52b1-b80a-938917b20c2f', 'ef935a5b-b0ef-5221-b285-37a41ba1d648', '21259c4c-ea36-54dd-993e-08a61c653352', 'a67255c5-cd9c-5ba9-9f0d-7b65b8a2032d', 'af6753fe-bb69-572c-9cad-2d35b27cfaf9', '326553e3-674b-5d7b-bc0f-230e23428dd0', '31b1fc2a-41f9-5f37-a026-e60e7c4c0325', 'f46b1655-caae-5003-8d4d-f6e7e4b1ba27', 'b87b66fc-2484-566b-9a53-587af37ab1e5', 'fd744f4c-c723-5e00-ad89-4af3613ff685', '1f0758c3-b3de-5625-90d2-4f5b87f70683', 'df8641a7-a315-58b5-b1f4-b05b843ebd95', '76bd6896-b3f7-55b2-b52a-f1867381666f', '9afee316-eed9-5e73-a777-cb5ce5e623de', '98c4519b-75bd-582a-ba8b-5e56bfa5758e', '9a87e285-33e4-59b1-acd1-c90f42fce53f', '8fdac534-0c47-5c2e-a118-44d22345c4d2', '1d468a5b-aa34-5f68-8803-4b07ebb6f303', '3523ab08-ac25-596f-9cda-731b2332674a', '134c1c75-643d-5bc3-85eb-839d865f05ae', '008e7118-7d21-53f9-9f8f-887c7eeaf885', 'f0486a25-d208-59a0-9cf9-738174a83aa2', 'f006cbaa-1ffb-5ae1-8289-4afd00b68b91', 'd78cbabc-7531-5a2f-b988-de27dd837130', '2d5d3394-6588-575a-9153-c9ddfe364a40', '3d3af95d-7a20-5352-a737-c2a57268ea48', 'cba41f21-e38a-5365-a791-f52982a5d1ee', '229062dd-a565-5c75-b2db-dbfdb38097b4', '7f231859-55ed-5bcb-b124-077b0d670e6f', '86fa0ec5-2be2-56eb-9c11-c51b9f245062', '851f1a38-82df-5834-85ec-35d9a2e7788e', 'a1e8b1b0-f782-5da7-93d6-23e0e94687ee', '056c5ee2-3ed4-5c00-a934-d45709746aee', '02233fc1-6132-54ff-a484-b3ea09762e86', '1f08f15d-6423-5ee7-9278-5fbb3228dd3d', 'e7cd28ac-f6b2-5c32-8531-e6845ae44e52', '9b355f5e-7034-5c28-9f80-cf3e68266262', 'faaeea04-f3f6-52f5-8327-f4c17b8874d0', '1ed6b763-bf34-59c4-bc5f-6e09c7d3f318', '33a9edd8-57cf-530a-8aad-1a70920325f5', '3b5f2a48-53f1-5b72-92b6-637e622f0fb9', '9e0e4826-c09e-5b7d-8c4e-2a5606987ed5', '6bcbf905-cf53-54bc-8b39-d3f7b60fc3c5', 'f1c8663b-f84a-5230-9d10-3d78d1afe1dc', '92eb4591-70f0-51a4-b029-b51ec168cef7', '113ad9f9-c829-58db-965c-533e8ceb3673', '991e622d-3bbd-572d-ac09-501a9f0077b6', '402a9800-c8cc-5b20-a44e-f2fcad30c6cf', 'df1ba87b-bfb4-528f-987d-c73b1a9a23ee', '15e2537c-6668-5d8e-aebd-cce119cb3753', '89eb2bb6-b24b-55b8-8cdf-4755683d0680', '44ac39ad-4d93-572d-b5f1-11ef8f36998b', '80297f04-3da5-5f66-913c-78a9ed938d73', '2d0120c6-dd89-52ac-a0fb-b8dce3243f58', '63af78e5-9ee2-5318-9603-35ae0a13e275', 'fb5c9459-ae4f-5023-b830-96acb49ef556', 'b42d191a-8a1f-5285-845c-d233488cc6a6', 'a0726909-bf8e-5481-952d-5a8558eb5260', 'e80c5789-93e6-5812-abd5-56e9fc14deec', '03972102-d480-5b42-996c-be76f666f91c', 'b1e340a0-e09f-5893-a21e-32d48f699b4a', '464dd7e2-e28c-5144-b203-38b7cdd663a0', 'abb6010e-df0a-5c1f-b35e-4bfe3717b953', '8ad03104-2945-58cf-942b-ac03c8d1b79d', 'aed264ae-832f-54a7-b23b-dd3e3cb7585d', '2bf4c9ed-e924-51c0-abbe-e82ee04e406e', '765d490f-f981-549c-a088-2d3d85a1eb6c', '9726f204-5b32-503e-a903-5c9718ce9396', 'ed53ac7a-4e2a-59f8-b994-43536353956b', '92bd14e3-8000-5493-b6a5-ef68678ca1fd', 'b9796748-bada-5330-9018-6af1c5b5d1a5', '77814524-cef6-5693-9b42-048d5d32696c', '75391ab3-ba46-5999-a795-3b608b453965', '0bc9d003-cba2-5c5a-bded-4e702d174799', '3a51c766-2497-5969-8386-07607b13eafd', '00ba5ee9-20cd-5567-9527-e1d51c0667b5', 'bec44fcf-1c1c-519e-8fc2-8c3e34b3449b', 'e598c68b-3bb5-543d-8236-cc25c108042b', '27e505fa-73c0-5e89-ba34-9034a585faac', '4f8159fa-c6d4-5846-be1c-de46b0e1749c', '5faec28f-b80c-55ac-b81e-7d359c4b28c8', '3e17a669-a491-569f-bff9-27ff8c807fee', 'a7ef9a5b-86cb-588b-9cee-45793b54a8d2', 'b747124d-02aa-55c4-b292-1294273e27ec', '10798752-92cc-584f-b749-a55c00d5da30', '3d029ce2-9e92-5c62-9d5f-4feda0558bd8', 'c2bbdfd3-a642-5ddf-9958-5e5d55038e7b', '605691b7-a003-588b-aef1-962d120f83ea', 'fb63c65f-c584-51b4-a161-f5ffeafcc67f', 'df0a321f-a255-5d0e-82d0-e6c6b6d2c80d', '1fe49179-14a9-5f6c-8d17-4a03ba73117d', 'e6c78ebe-d1c5-5c4c-8f73-10b4f0f9efd4', '53f8405f-6590-5bd7-a3bf-855d45690f32', '7bca5948-40b9-5a13-b1b1-0bf58015a46c', '2618ffb2-f987-5178-86c0-4460646663d5', '9d71a6b2-c87f-5fdf-a9fb-fa34e66fafba', 'c3a67fe2-75f6-54f3-a43e-28845bbe9d34', 'c34544f0-27b7-5330-9f5e-9fa7caf2910b', 'f66c746d-acff-50ad-91e1-bf553e16448c', '294ca77c-4466-58d9-93fd-3802a5b56de1', 'cead8c4c-b81a-5fe2-9262-d80b1faf9044', '3e7e6ff4-f415-5237-84e6-cabadd48c265', 'c12c13d1-1653-55fd-be2a-17c1f370a605', '73af3572-4e32-53d3-ac39-18980dd28d27', '022d37a4-bcac-5ffa-8731-1533097f3a2a', '6d45221e-a891-5d5a-a4fe-59908a2ee632', '92cd3391-b458-568f-b6e8-776d863c300c', 'a90a0edd-4063-540d-a77e-34286c741ffb', '51aab555-0343-59ab-a2f0-de135476f472', 'ac4f2f5b-7a7b-5bd3-9169-3b5c5879be8c', '4c217b63-e004-5aca-bf4a-1e093e08a231', '6f3be466-7b1a-5c8a-a5a5-b03e59cc9eb0', 'd1232de4-790a-5e79-ac01-a437b6ff73cc', '2621e1a2-6096-5406-b88f-fbebeeafb5d4', '9933c010-42de-5a27-9964-ad25dbb31276', 'e8cce4f4-428c-53f7-b06d-adf785655bfa', '03901820-29ac-573f-9119-1c03f1d90f1a', 'e4f4f82e-edb6-5f99-98f3-e682037641dc', '8f41ead6-df2f-57b1-aba3-b1ec2ec6b96b', '8ede27c5-d633-597b-93f8-e1291ffd25ad', '31b98056-f392-5101-ab78-fb677f8093d0', '477a078a-edca-54f7-bcce-ab5b346f55c1', 'a6072144-34c3-5e55-85c3-aaee3a6285b9', '98a842e8-c470-5334-b8ed-90d3956b6837', '9f6fe939-a2e4-55da-b8f3-022bc159ede9', 'b78e80e9-369f-5997-8cbe-1ecff581148f', 'af3b3e91-0375-5088-ba93-a16c5dd4d0ce', '826d40c4-d0a9-571d-b89f-d3246628cd3b', '036d0331-507f-59ef-b1a3-ed0712c99d07', '92f1b183-0e32-50a2-84a8-d16ea38d3f34', 'f2375994-0c53-5bf9-800c-b8e39bd9fd33', 'c75f6f6b-c6e7-5af3-8e31-0c0aa08e9b61', 'da763a5d-1fb8-5f6d-a5fe-2f0326fd0b74', 'bc80436d-badc-5604-a137-634d4ca2aec3', 'e2c7449f-5271-5732-9f69-5b8a54512cf8', '363febe8-fe3e-5371-adb6-c7e6c80b9474', '3d367671-e492-512d-93b9-e62c0150fccc', '1209dbb4-3747-5c45-adb7-d692fc5adff2', 'af8799c0-576d-557d-a478-362691a246ee', '977dcdbb-f536-5a31-bf5c-203e78f9544d', '0be656df-984a-5d0e-8f66-c266d854feb6', '52326633-226c-55f5-b983-4bddafb68d95', 'bcf6cae4-9d6d-56a6-a0fb-3796f4890d57', '0c8295ac-98e8-5097-9a6f-ce37e715a845', 'ac0ad1da-7c99-5483-8a81-e8a5be02f0fc', '786babcd-4189-58df-b101-ef8c46b6329f', '42d77a2c-a0a9-568c-a439-06e6ddc24fa6', 'a3bd468c-4be5-5a40-b456-0935dafacfac', 'e87b5886-3900-5956-97ed-5897c8cbbc38', '6ed50abe-360f-594e-a8b2-031c8173d3dd', '0f97acb8-9534-502f-9fff-a4db96027871', '91610a25-e1e6-5ddf-b34c-629877fd7f8d', 'd63def28-aeb7-5aa2-8f0e-41f612f1f397', 'f6524cca-d0cb-54fe-ae90-f8bf28a7e5f0', '1cdfba25-b126-5481-a735-97206a695909', 'd746c22e-8f4d-5062-adb7-637720b759bd', 'bffe59f4-d355-53a9-82f8-7a6692fb6667', '24935e42-43bc-560b-a9a4-ac0eba10837a', '31eebf21-a5ca-594a-bc4e-6c2230c467b3', '9849eb1c-db7e-5784-b3c2-c01f187b585d', '853974ec-050e-5511-b78b-560482c33357', '166213f1-4280-5b0f-8dc6-fcda9b47f50b', 'a3074339-2258-5eeb-b284-c52ed01533a9', 'dcbc0eb2-f1c5-5d8c-8369-c4e631a3c52e', '376ed589-92f9-5adc-9c1a-99a7636950d8', '1dd53d1b-00a3-5110-a77e-65d36a8e6fa2', '642ff382-1ec0-5268-bf77-a5fdfea5b9bb', '67a92767-18ab-50ff-a001-ab75016b0ee2', '5233d09d-6fa3-5a36-b6f2-2cde1ad3bff5', '8a130a15-3cf2-51ad-b9e0-dd28e623abb9', '12a36e10-7ffc-515a-b144-bbdb65bf77d6', '0cb491ef-3d25-590d-bc3e-a0bd53983a88', 'ab27aaea-0db8-51aa-b0f0-9f958729aa07', '45002c85-4c98-5d64-821f-b11df89e1e2e', '94a798af-b5f0-5dea-a2a8-3b9b59f767d6', '1714f76d-b760-5ebf-a32e-fc6254643759', 'b3143e46-1f58-5969-9946-7420b3b69aa5', '13c42b69-7ec7-5ac0-8b76-c183c27a12ea', 'ac5f0136-0e5f-5cb2-acef-9e2422e1eeee', '2a793922-46fb-53cf-95c6-b24f272ab737', 'c53da46c-b79a-5047-b146-8929187e8dde', '5578aed5-ded1-5392-8f07-08c7a0b2cd47', '4148f6c3-6b58-5207-8d41-9787be0e89e2', '44014185-c08b-5b56-a454-1903af61fcc1', '81f9bcea-d995-5ea3-ad54-7019681a960d', '31da48d2-38fc-5b44-9357-ed6f2d477ffc', 'ae2ab424-2290-509a-a268-dd729d6a3f7e', '7e4388ef-8453-583f-b68b-be08fd352ccd', 'eeb329ab-8be3-5a65-912d-a7e3243dc82f', '1008a12f-dabd-5cd2-8def-2e23af503b83', '82b6fc99-6b45-5dd6-8da3-e7701274008e', 'f67de9ae-a39c-5def-9d9c-8e1fc4db6d8e', '0dad2e38-b243-5740-bd9f-cb33b50fd038', 'd3e70373-51c9-52c9-a5b2-700e20869970', '335be1a3-d794-5952-992e-d724d7b7b766', '73c576e0-813d-5c6b-b511-6b50916d715b', 'c792c926-079e-5089-9357-28cdd32b940f', 'dbb7a41c-f7be-5835-948d-56a0e9f708f2', 'dffd03a3-3fba-5bad-abdf-44f76481bdbd', '40b29a89-b7b3-57f1-bd92-c6d10afa4f92', '0c725610-5a73-5ac2-b019-86e6a87cd502', '35b9ec97-dc7d-5d35-b55a-9c20036f6c5d', 'cb2d8086-c421-511c-af4e-73357b77fef1', 'b7c4b40b-dfff-5104-8d67-bb7fd8cfb5d5', 'd789efa1-5841-5612-a909-44ab689345fb', '04192f7f-2f62-51bc-b7f7-efd31f7b32e5', '09596525-59bd-5272-bccc-d37d23af4033', '2cb22a01-978b-51ea-8d9e-5d148fb76775', '2cc6f213-d720-5aeb-8f67-038f0c2a8ef2', 'f28c2c35-f76d-53c1-9449-83fbf6ccc0c3', 'e003702e-1024-5e71-aed2-b8998143e8e5', 'dcca4b18-a3fa-53eb-95c1-962ec7ad815e', '2a5f95ef-0d69-57c3-a8be-d200354d1800', '7e7f15a0-ff0c-587a-8d3d-1c1bd31cb736', '8b2e3a32-65a2-57eb-9e3f-b73677622096', 'dcaa616e-7775-588f-92c8-3835802611be', '15b1af9a-68b2-5ed8-a7ab-3cd845e9a36b', '70a7eb0d-2621-5d53-ac97-4c89734bd93f', 'f27ffaf4-31cc-5a55-842e-06f9b73df29e', '5c36d561-9357-5a99-966f-112b9c1f180a', 'fd6dbd90-5f18-5d75-8917-545d2ebf2195', '49b06dde-002c-53e7-8623-bf4886966c0b', 'c98f9865-7203-552a-8b7a-1dd467a94813', '96eb2dd1-9975-5666-ad51-64b190b9c1ed', 'd80b16e1-e6f8-5c00-bef0-32e361db7e3f', '2f9ae570-68b6-5c0f-979f-4cb5f34ee917', '9f8be5f9-01f4-5138-8e85-0711060f34c0', '1c96874f-d8f3-5395-81a8-233c28b12802', 'daf5e1f7-deff-53ca-a8bf-0d0970b7b81b', '38db23ce-89f0-5d8f-8f39-8a2ca145e311', '610aedb1-85d7-545c-a330-b2424b0c3637', 'b129e063-cf1f-5c49-a581-b286e06bbd02', '33c54600-8e85-529d-af7b-f2a5c495964d', 'c92c654c-524d-54a6-9135-44569e2d0d65', '09c9aa3a-1c35-58ab-ae10-49887427565e', '53b384e8-ec5f-5d3b-9758-d58880dff052', '885cb6d1-7f54-5885-b8a6-eb671f524c72', 'edf2004e-8abf-5b1a-8ec0-8e692558862c', 'a19b844c-7806-5f1a-a645-14435c37bac5', '92f81327-34d4-539e-8204-1b620cb5266d', 'e59bd658-ff62-555f-b424-8f080a791bec', 'c3ff0227-2fff-58dc-a304-126688fbae19', '74ea5a31-a272-5076-a195-1c0bdc638c1c', '8fb355ef-1ae6-5843-a0d9-3fb83d3addee', '9ee0b273-4b6b-587b-b297-81f80fa419c2', 'c7486a1c-d7f6-52bd-98f8-8e066f7f5757', '0e20c477-445e-5477-a1c9-8c625f911719', '1a1949dd-7c8d-55f1-b2cd-4b3f52d98be9', '265e26c1-08be-5d1e-80f9-5fb8a77c4df6');
DELETE FROM public.chapters c WHERE c.subject_id = 'arabic-1ere' AND c.id NOT IN ('69fa5b1f-a2cb-55cf-9146-47a61438845a', 'c61a3396-f412-5e62-a171-517e92af8c10', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'e36f7197-1861-5172-901e-d0621445df55', '03df7071-25b7-5d48-8733-ee0344b7315a', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', 'مملكة الحروف — أتعرّف على الأصوات', 'أتعرّف على الحروف العربية وأصواتها: أرى شكل الحرف وأسمع صوته (أ، ب، ت، م، س، ل، د، ر...)، وأميّز بين الحروف المتشابهة', '# ⚔️ مملكة الحروف — أتعرّف على الأصوات

> 💡 «كلّ حرفٍ صوتٌ ولونٌ وصورة. إذا عرفتُ الحروف، فتحتُ باب القراءة!»

في اللغة العربية **حروفٌ** كثيرة. لكلّ حرفٍ **شكلٌ** أراه و**صوتٌ** أسمعه. هيّا نبدأ المغامرة!

## 🔤 الحرف: شكلٌ وصوت

أنظر إلى الحرف، ثمّ أنطق صوته. هذا هو الحرف **م**، وصوته «مـْ» كما في **موز**.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#b45309" stroke="none">م</text></svg>

## 🍎 كلّ كلمةٍ تبدأ بحرف

كلمة **تفّاحة** أوّل صوتٍ فيها هو **ت**. أنظر إلى التفّاحة الحمراء وقل: «تـْ... تفّاحة».

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>

## 🌞 أصواتٌ في أوّل الكلمة

- **شمس** تبدأ بصوت **ش**.
- **سمكة** تبدأ بصوت **س**.
- **دار** تبدأ بصوت **د**.
- **بطّة** تبدأ بصوت **ب**.

أنطق أوّل صوتٍ في كلّ كلمة، فأعرف بأيّ حرفٍ تبدأ.

## 🛡️ حروفٌ متشابهة، أنتبه!

بعض الحروف تتشابه في الشكل، لكنّ **النقط** تفرّق بينها:

| الحرف | النقط |
| ----- | ----- |
| **ب** | نقطةٌ واحدةٌ تحته |
| **ت** | نقطتان فوقه |
| **ث** | ثلاث نقطٍ فوقه |

> 🗡️ النقطة هي السرّ! نفس الشكل، لكنّ عدد النقط ومكانها يصنع حرفًا جديدًا.

> ⚠️ الفخّ الشائع: لا تخلط بين **د** و**ذ**. حرف **ذ** فوقه نقطةٌ واحدة، أمّا **د** فلا نقطة له.

> 🏆 أحسنت! صرتَ تعرف أنّ لكلّ حرفٍ شكلًا وصوتًا، وتميّز الحروف المتشابهة. أنت الآن على باب القراءة!', '# 📜 ملخّص: مملكة الحروف — أتعرّف على الأصوات

- **الحرف شكلٌ وصوت:** أرى شكل الحرف وأنطق صوته (الحرف **م** صوته «مـْ»).
- **كلّ كلمةٍ تبدأ بحرف:** أوّل صوتٍ في الكلمة يدلّني على حرفها (**تفّاحة** ← **ت**).
- **أصواتٌ في أوّل الكلمة:** شمس ← **ش**، سمكة ← **س**، دار ← **د**، بطّة ← **ب**.
- **حروفٌ متشابهة تفرّقها النقط:** **ب** نقطةٌ تحته، **ت** نقطتان فوقه، **ث** ثلاث نقطٍ فوقه.
- **أنتبه:** **د** بلا نقطة، و**ذ** فوقه نقطةٌ واحدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', 'صائد الأصوات — أوّل صوتٍ في الكلمة', 'أصطاد أوّل صوتٍ في كلّ كلمة فأعرف بأيّ حرفٍ تبدأ، وأتعرّف على حروفٍ جديدة (ن، ج، ح، ع، ك، ف، و، ه) مع مراجعة (ب، ت، م، س، ل، د، ر، ش)', '# ⚔️ صائد الأصوات — أوّل صوتٍ في الكلمة

> 💡 «كلّ كلمةٍ تبدأ بصوت. إذا اصطدتُ أوّل صوتٍ، عرفتُ أوّل حرفٍ، وفتحتُ باب القراءة!»

في الفصل الأوّل تعرّفتُ على الحروف وأصواتها. الآن أصير **صائد الأصوات**: أنطق الكلمة ببطء، وأمسك **أوّل صوتٍ** فيها، فيدلّني على **أوّل حرفٍ**. هيّا نصطاد!

## 🎯 كيف أصطاد أوّل صوت؟

أنطق الكلمة على مَهَلٍ وأشدّ أوّل صوتٍ فيها: «نـ... نجمة». أوّل صوتٍ هو **نـْ**، فالكلمة تبدأ بالحرف **ن**.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M60 12 l13 30 l33 3 l-25 22 l8 33 l-29 -18 l-29 18 l8 -33 l-25 -22 l33 -3 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/></svg>

## 🆕 حروفٌ جديدة أصطاد أصواتها

أتعرّف على حروفٍ جديدةٍ من خلال أوائل الكلمات:

- **نجمة** تبدأ بصوت **ن**.
- **جزر** يبدأ بصوت **ج**.
- **عنب** يبدأ بصوت **ع**.
- **كرة** تبدأ بصوت **ك**.
- **فراشة** تبدأ بصوت **ف**.
- **وردة** تبدأ بصوت **و**.
- **هلال** يبدأ بصوت **ه**.

هذا **عنب**، أوّل صوتٍ فيه «عـْ»، فهو يبدأ بالحرف **ع**:

<svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="58" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="72" cy="58" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="78" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="42" cy="80" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="78" cy="80" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="100" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><path d="M60 46 q4 -16 18 -22" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M64 26 q10 -6 18 0" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>

## 🔤 الحرف وحده

أحيانًا أرى الحرف وحده في بطاقةٍ، فأعرفه من شكله. هذا هو الحرف **ج**، وصوته «جـْ» كما في **جزر**:

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#15803d" stroke="none">ج</text></svg>

## 🛡️ حروفٌ متشابهة، أنتبه!

بعض الحروف الجديدة تتشابه، وتفرّقها **النقطة** أو **مكانها**:

| الحرف | العلامة |
| ----- | ------- |
| **ح** | لا نقطة له |
| **ج** | نقطةٌ واحدةٌ تحته |
| **ع** | لا نقطة له، مفتوحٌ من فوق |
| **ن** | نقطةٌ واحدةٌ فوقه |

> 🗡️ الحيلة: أنطق الكلمة ببطءٍ وكأنّك تمدّ أوّل صوتٍ فيها: «حـ... حـوت»، «عـ... عـنب». الصوت الأطول في البداية هو أوّل حرفٍ.

> ⚠️ الفخّ الشائع: لا تخلط بين **ح** و**ج**. الحرف **ج** تحته نقطةٌ واحدة، أمّا **ح** فلا نقطة له.

> 🏆 أحسنت أيّها الصائد! صرتَ تمسك أوّل صوتٍ في الكلمة وتعرف حرفها، وتميّز الحروف المتشابهة. أنت الآن جاهزٌ لقراءة المقاطع!', '# 📜 ملخّص: صائد الأصوات — أوّل صوتٍ في الكلمة

- **كيف أصطاد أوّل صوت:** أنطق الكلمة ببطءٍ وأمسك أوّل صوتٍ فيها، فيدلّني على أوّل حرف (**نجمة** ← **ن**).
- **حروفٌ جديدة أصطاد أصواتها:** نجمة ← **ن**، جزر ← **ج**، عنب ← **ع**، كرة ← **ك**، فراشة ← **ف**، وردة ← **و**، هلال ← **ه**.
- **الحرف وحده:** أعرف الحرف من شكله في البطاقة (الحرف **ج** صوته «جـْ» كما في جزر).
- **حروفٌ متشابهة تفرّقها النقطة:** **ح** بلا نقطة، **ج** نقطةٌ تحته، **ن** نقطةٌ فوقه؛ فأنتبه ولا أخلط بينها.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', 'بنّاء الكلمات — المقاطع وقراءة الكلمة', 'أجمع الأصوات والمقاطع فأبني كلمةً قصيرة، وأعدّ المقاطع في الكلمة (موز، قَمَر، سَمَكة)، وأقرأ الكلمة وأربطها بصورتها، وأرتّب الحروف لأكوّن كلمة', '# ⚔️ بنّاء الكلمات — المقاطع وقراءة الكلمة

> 💡 «المقطع لَبِنة، والكلمة بناء. إذا جمعتُ المقاطع، قرأتُ الكلمة!»

عرفتُ الأصوات والحروف، والآن أصير **بنّاءً**. أجمع الأصوات في **مقاطع**، وأجمع المقاطع في **كلمة**. هيّا نبني!

## 🧱 المقطع: لَبِنة الكلمة

كلّ **مقطعٍ** فيه **حركة** (نبضة صوت)، فأنطقه دفعةً واحدة. أنطق كلّ مقطعٍ ثمّ أصِلها بسرعة، فتظهر الكلمة:

- **قَ** + **مَر** ← **قَمَر** 🌙
- **قَ** + **لَم** ← **قَلَم**

أنظر إلى القمر في السماء وقل: «قَ... مَر... قَمَر».

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M78 22 a40 40 0 1 0 22 70 a32 32 0 1 1 -22 -70 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/></svg>

## 🔢 أعدّ المقاطع

أضع يدي تحت ذقني وأنطق الكلمة، فأعدّ المقاطع. كلّ نبضةٍ مقطع:

| الكلمة | المقاطع | العدد |
| ------ | ------- | ----- |
| **موز** | «موز» | 1 |
| **قَمَر** | «قَ» + «مَر» | 2 |
| **سَمَكة** | «سَ» + «مَ» + «كة» | 3 |

أنظر إلى السمكة وعُدّ: «سَ... مَ... كة» — ثلاثة مقاطع.

<svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>

## 🖼️ أقرأ الكلمة وأربطها بصورتها

أقرأ الكلمة مقطعًا مقطعًا، ثمّ أبحث عن **صورتها**:

- أقرأ **تُفّاحة** ← أبحث عن التفّاحة الحمراء.
- أقرأ **موز** ← أبحث عن الموزة الصفراء.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>

## 🧩 أبني الكلمة من حروفها

أرتّب الحروف على الترتيب الصحيح فتظهر الكلمة:

- **د** ثمّ **ا** ثمّ **ر** ← **دار**
- **ق** ثمّ **م** ثمّ **ر** ← **قَمَر**

ترتيب الحروف مهمّ: لو بدّلتُ الترتيب، تغيّرت الكلمة أو ضاع معناها.

> 🗡️ السرّ: أنطق المقاطع **ببطءٍ** ثمّ صِلها **بسرعة**. «قَ... مَر» تصير «قَمَر» في نَفَسٍ واحد.

> ⚠️ الفخّ الشائع: لا أعدّ **الحروف** بدل **المقاطع**. كلمة **موز** فيها ثلاثة حروف، لكنّها **مقطعٌ واحد** ننطقه دفعةً واحدة؛ والحرف الساكن في آخر الكلمة لا يكون مقطعًا وحده، بل يُغلق المقطع الذي قبله.

> 🏆 أحسنت أيّها البنّاء! صرتَ تجمع المقاطع وتعدّها وتقرأ الكلمة وتبنيها من حروفها. أنت الآن قارئٌ صغير!', '# 📜 ملخّص: بنّاء الكلمات — المقاطع وقراءة الكلمة

- **المقطع لَبِنة الكلمة:** كلّ مقطعٍ فيه **حركة** (نبضة صوت)؛ أجمع المقاطع فتظهر الكلمة (**قَ** + **مَر** ← **قَمَر**).
- **أعدّ المقاطع:** أنطق الكلمة وأعدّ نبضاتها: **موز** مقطعٌ واحد، **قَمَر** مقطعان («قَ» + «مَر»)، **سَمَكة** ثلاثة مقاطع.
- **أقرأ الكلمة وأربطها بصورتها:** أقرأ الكلمة مقطعًا مقطعًا ثمّ أبحث عن صورتها (**تُفّاحة** ← صورة التفّاحة).
- **أبني الكلمة من حروفها:** أرتّب الحروف على الترتيب الصحيح فتظهر الكلمة (**د** + **ا** + **ر** ← **دار**).
- **أنتبه:** أعدّ المقاطع لا الحروف؛ **موز** ثلاثة حروف لكنّها **مقطعٌ واحد**، والحرف الساكن في آخر الكلمة لا يكون مقطعًا وحده بل يُغلق المقطع الذي قبله.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', 'سيّد الأشكال — الحرف يتبدّل في الكلمة', 'أكتشف أنّ الحرف الواحد يتبدّل شكله حسب موقعه في الكلمة: أوّلها (عـ) ووسطها (ـعـ) وآخرها (ـع)، وأتعرّف على الحرف نفسه في أشكاله الثلاثة، وأحدّد موقع الحرف في الكلمة', '# ⚔️ سيّد الأشكال — الحرف يتبدّل في الكلمة

> 💡 «الحرف بطلٌ يغيّر لباسه! أوّل الكلمة لباس، ووسطها لباس، وآخرها لباس… لكنّه يبقى الحرف نفسه.»

في الكلمة، يلبس الحرف الواحد **ثلاثة أشكال** حسب **موقعه**: أوّل الكلمة، ووسطها، وآخرها. هيّا نتعلّم كيف نعرفه في كلّ شكل!

## 🎭 حرفٌ واحدٌ بثلاثة أشكال

أنظر إلى الحرف **ع**. حين يكون في **أوّل** الكلمة يصير **عـ**، وفي **وسطها** يصير **ـعـ**، وفي **آخرها** يصير **ـع**. هو نفس الحرف، لكنّ شكله تبدّل:

<svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="74" font-size="48" text-anchor="middle" fill="#15803d" stroke="none">عـ</text><text x="50" y="98" font-size="15" text-anchor="middle" fill="#1f2937" stroke="none">أوّل</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="74" font-size="48" text-anchor="middle" fill="#b45309" stroke="none">ـعـ</text><text x="150" y="98" font-size="15" text-anchor="middle" fill="#1f2937" stroke="none">وسط</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="74" font-size="48" text-anchor="middle" fill="#1d4ed8" stroke="none">ـع</text><text x="250" y="98" font-size="15" text-anchor="middle" fill="#1f2937" stroke="none">آخر</text></svg>

## 📍 أين يقع الحرف؟

لأعرف موقع الحرف، أبحث عنه في الكلمة:

- إن كان في **البداية** فهو في **أوّل الكلمة**.
- إن كان في **النصف** فهو في **وسط الكلمة**.
- إن كان في **النهاية** فهو في **آخر الكلمة**.

في كلمة **عَلَم**: الحرف **ع** في الأوّل، و**ل** في الوسط، و**م** في الآخر.

<svg viewBox="0 0 300 110" xmlns="http://www.w3.org/2000/svg"><rect x="206" y="20" width="84" height="70" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="248" y="66" font-size="40" text-anchor="middle" fill="#15803d" stroke="none">عَـ</text><text x="248" y="86" font-size="13" text-anchor="middle" fill="#1f2937" stroke="none">أوّل</text><rect x="108" y="20" width="84" height="70" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="66" font-size="40" text-anchor="middle" fill="#b45309" stroke="none">ـلَـ</text><text x="150" y="86" font-size="13" text-anchor="middle" fill="#1f2937" stroke="none">وسط</text><rect x="10" y="20" width="84" height="70" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="52" y="66" font-size="40" text-anchor="middle" fill="#1d4ed8" stroke="none">ـم</text><text x="52" y="86" font-size="13" text-anchor="middle" fill="#1f2937" stroke="none">آخر</text></svg>

## 🗂️ جدول الأشكال الثلاثة

كلّ حرفٍ له ثلاثة أشكال. أنظر إلى الحرف **م** مثالًا:

| الموقع | الشكل | مثال |
| ------ | ----- | ---- |
| **أوّل الكلمة** | **مـ** | مَوْز |
| **وسط الكلمة** | **ـمـ** | قَمَر |
| **آخر الكلمة** | **ـم** | عَلَم |

## 🔎 الحرف نفسه وإن تبدّل

الشكل يتغيّر، لكنّ **الصوت** و**اسم الحرف** لا يتغيّران. الحرف **س** يبقى «سـْ» سواءٌ كتبناه **سـ** (سَمَك) أو **ـسـ** (مِسْطَرة) أو **ـس** (شَمْس).

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fbcfe8" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#be185d" stroke="none">س</text></svg>

> 🗡️ السرّ: لا تخف من الشكل الجديد! إبحث عن **اسم الحرف**، لا عن لباسه؛ فالحرف نفسه في أشكاله الثلاثة.

> ⚠️ الفخّ الشائع: لا تظنّ أنّ **ـعـ** حرفٌ جديد. إنّه نفس **ع**، لكنّه في **وسط** الكلمة، فاتّصل بما قبله وبما بعده.

> 🏆 أحسنت أيّها البطل! صرتَ تعرف أنّ الحرف يتبدّل شكله حسب موقعه، وتميّزه في أوّل الكلمة ووسطها وآخرها. الآن أنت جاهزٌ لتقرأ كلماتٍ أطول!', '# 📜 ملخّص: سيّد الأشكال — الحرف يتبدّل في الكلمة

- **حرفٌ واحدٌ بثلاثة أشكال:** الحرف يتبدّل شكله حسب موقعه (**ع** ← عـ في الأوّل، ـعـ في الوسط، ـع في الآخر).
- **أين يقع الحرف:** البداية ← أوّل الكلمة، النصف ← وسط الكلمة، النهاية ← آخر الكلمة (في **عَلَم**: ع أوّل، ل وسط، م آخر).
- **جدول الأشكال الثلاثة:** للحرف **م**: مـ (مَوْز) في الأوّل، ـمـ (قَمَر) في الوسط، ـم (عَلَم) في الآخر.
- **الحرف نفسه وإن تبدّل:** الصوت واسم الحرف لا يتغيّران؛ الحرف **س** يبقى «سـْ» في سَمَك وشَمْس.
- **أنتبه:** **ـعـ** ليست حرفًا جديدًا، بل هي **ع** في وسط الكلمة.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', 'خطّاط البطل — أرسم الحرف على السطر', 'أتعلّم رسم الحروف رسمًا جميلًا: أكتب من اليمين إلى اليسار، وأجعل الحرف يجلس على السطر، وأضع النقط في مكانها الصحيح (فوق أو تحت)، وأنسخ الحرف والكلمة بترتيبٍ ونظافة، وأميّز الخطّ الجميل من الخطّ غير المرتّب', '# ⚔️ خطّاط البطل — أرسم الحرف على السطر

> 💡 «القلمُ سيفي، والسطرُ ميدانـي. إذا رسمتُ الحرف جميلًا، صرتُ خطّاطًا بطلًا!»

عرفتُ الحروف وأصواتها، والآن أتعلّم **رسمها** بيدي. الخطّ الجميل سرّه ثلاثة: **الاتّجاه** الصحيح، و**السطر**، و**النقط** في مكانها. هيّا نبدأ التدريب!

## ➡️ أكتب من اليمين إلى اليسار

العربية تُكتب من **اليمين إلى اليسار**. أبدأ قلمي من جهة اليمين، ثمّ أمشي به نحو اليسار. أنظر إلى السهم:

<svg viewBox="0 0 200 70" xmlns="http://www.w3.org/2000/svg"><polyline points="180,35 40,35" fill="none" stroke="#2563eb" stroke-width="6" stroke-linecap="round"/><polygon points="40,35 60,22 60,48" fill="#2563eb" stroke="#1f2937" stroke-width="2"/><text x="150" y="22" font-size="16" text-anchor="middle" fill="#15803d" stroke="none">البداية</text><text x="45" y="22" font-size="16" text-anchor="middle" fill="#b91c1c" stroke="none">النهاية</text></svg>

## 📏 الحرف يجلس على السطر

أرسم الحرف فوق **السطر** كأنّه يجلس عليه، لا يطير فوقه ولا يسقط تحته. السطر هو الخطّ الذي أكتب عليه:

<svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="80" x2="180" y2="80" stroke="#1f2937" stroke-width="3"/><text x="100" y="78" font-size="60" text-anchor="middle" fill="#7c3aed" stroke="none">ب</text></svg>

الحرف **ب** يجلس على السطر، ونقطته الواحدة **تحت** السطر.

## 🎯 النقط في مكانها الصحيح

النقطة هي تاج الحرف! بعض الحروف نقطها **فوق**، وبعضها **تحت**. أنظر: نقطة **ب** تحت، ونقطتا **ت** فوق:

<svg viewBox="0 0 220 110" xmlns="http://www.w3.org/2000/svg"><line x1="15" y1="78" x2="205" y2="78" stroke="#1f2937" stroke-width="3"/><text x="60" y="76" font-size="56" text-anchor="middle" fill="#0d9488" stroke="none">ب</text><text x="160" y="76" font-size="56" text-anchor="middle" fill="#ea580c" stroke="none">ت</text></svg>

| الحرف | النقط | مكانها |
| ----- | ----- | ------ |
| **ب** | نقطةٌ واحدة | **تحت** الحرف |
| **ت** | نقطتان | **فوق** الحرف |
| **ث** | ثلاث نقطٍ | **فوق** الحرف |
| **ن** | نقطةٌ واحدة | **فوق** الحرف |
| **د، ر، س، ل، م** | لا نقطة | — |

## 📝 أنسخ بترتيبٍ ونظافة

النسخ هو نقل الحرف أو الكلمة كما هي. أنسخ بهذه الخطوات:
- أنظر جيّدًا إلى الحرف **قبل** أن أرسمه.
- أبدأ من **اليمين**، وأجعل الحرف على السطر.
- أضع النقط **بعد** رسم الحرف، في مكانها الصحيح.
- أكتب بخطٍّ **نظيفٍ** مرتّب، لا متشابكٍ ولا مائل.

> 🗡️ السرّ: اتّجاهٌ صحيح + سطرٌ + نقطةٌ في مكانها = خطٌّ جميل!

> ⚠️ الفخّ الشائع: لا أكتب من اليسار إلى اليمين (هكذا نكتب الفرنسية، لا العربية)، ولا أضع نقطة **ب** فوقها؛ نقطة **ب** دائمًا **تحتها**.

> 🏆 أحسنت أيّها الخطّاط! صرتَ ترسم الحرف على السطر، من اليمين إلى اليسار، بنقطةٍ في مكانها وخطٍّ نظيف. أنت الآن جاهزٌ لتكتب أوّل كلماتك بنفسك!', '# 📜 ملخّص: خطّاط البطل — أرسم الحرف على السطر

- **الاتّجاه:** أكتب العربية من **اليمين إلى اليسار** (أبدأ من اليمين، وأمشي نحو اليسار).
- **السطر:** الحرف يجلس على **السطر**، لا يطير فوقه ولا يسقط تحته.
- **النقط في مكانها:** نقطة **ب** تحته، ونقطتا **ت** فوقه، وثلاث **ث** فوقه، ونقطة **ن** فوقه، و**د/ر/س/ل/م** بلا نقط.
- **النسخ:** أنظر إلى الحرف، أبدأ من اليمين على السطر، ثمّ أضع النقط بخطٍّ نظيفٍ مرتّب.
- **أنتبه:** لا أكتب من اليسار إلى اليمين، ولا أضع نقطة **ب** فوقها؛ نقطة **ب** دائمًا تحتها.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', 'أُذُن البطل — أُنصِتُ وأفهمُ ما أسمع', 'أُنصِتُ إلى جملةٍ قصيرة، ثمّ أُجيبُ عنها: مَن فعل؟ وأين؟ وماذا؟ وأختارُ الصورة التي تناسب الجملة، وأُرتّبُ أحداثًا بسيطةً حسب وقوعها', '# ⚔️ أُذُن البطل — أُنصِتُ وأفهمُ ما أسمع

> 💡 «البطلُ الذكيّ يُنصِتُ جيّدًا، ثمّ يفهم. مَن أحسنَ الإصغاء، أصابَ الجواب!»

أحيانًا لا أقرأ بنفسي، بل **أسمعُ** جملةً قصيرة. مهمّتي أن **أفهمَ** ما سمعتُ، ثمّ أُجيبَ عن سؤالٍ بسيط. هيّا نتدرّب على الإصغاء!

## 👂 أُنصِتُ ثمّ أفهم

أسمعُ جملةً قصيرةً مرّةً واحدة، فأمسكُ معناها. مثلاً أسمع: «الوَلَدُ يأكلُ تُفّاحة». فأعرفُ أنّ هناك **وَلَدًا**، وأنّه **يأكل**، وأنّ المأكول **تُفّاحة**.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>

## 🧐 مَن؟ وأين؟ وماذا؟

بعد أن أُنصِت، يسألني السؤال عن شيءٍ في الجملة. ثلاثة أسئلةٍ مهمّة:

| السؤال | يبحثُ عن |
| ----- | ----- |
| **مَن؟** | الشخصُ الذي فعلَ الفعل |
| **أين؟** | المكان |
| **ماذا؟** | الشيء |

فإذا سمعتُ: «البِنتُ تلعبُ في الحديقة»، وسُئلتُ **أين تلعب؟**، فجوابي: **في الحديقة**.

## 🖼️ أختارُ الصورةَ التي تناسبُ الجملة

أحيانًا أسمعُ جملةً، ثمّ أختارُ **الصورة** التي تدلّ عليها. أسمع: «السمكةُ تسبحُ في الماء»، فأختارُ صورةَ **السمكة**.

<svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>

## ☀️ أُرتّبُ ما حدث

في الجملة قد يحدثُ شيءٌ **أوّلاً** ثمّ شيءٌ **بعده**. أسمع: «طلعتِ الشمسُ، فاستيقظَ عليّ». الذي حدثَ أوّلاً هو **طلوعُ الشمس**، ثمّ **استيقاظُ عليّ**.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>

## 🛡️ سِرُّ الفهم الجيّد

> 🗡️ السرّ: أُنصِتُ إلى الجملة كاملةً قبل أن أُجيب، وأُمسكُ **الكلمةَ المهمّة** (مَن، أين، ماذا). الجوابُ يكونُ من داخل الجملة لا من خارجها.

> ⚠️ الفخّ الشائع: لا أختارُ كلمةً سمعتُها في الجملة لمجرّد أنّها مذكورة. أسمع: «الوَلَدُ يأكلُ تُفّاحة»، فإذا سُئلتُ **ماذا يأكل؟** فالجوابُ **تُفّاحة** لا **وَلَد**؛ الوَلَدُ هو مَن يأكل، لا ما يُؤكَل.

> 🏆 أحسنت أيّها البطل! صرتَ تُنصِتُ جيّدًا، وتفهمُ الجملة، وتُجيبُ عن مَن وأين وماذا، وتختارُ الصورةَ المناسبة. أُذُنُك الآن أُذُنُ بطل!', '# 📜 ملخّص: أُذُن البطل — أُنصِتُ وأفهمُ ما أسمع

- **أُنصِتُ ثمّ أفهم:** أسمعُ الجملةَ القصيرةَ وأُمسكُ معناها (مَن، وماذا يفعل، وما الشيء).
- **مَن؟ وأين؟ وماذا؟:** **مَن** عن الشخص، و**أين** عن المكان، و**ماذا** عن الشيء («البِنتُ تلعبُ في الحديقة» ← أين؟ في الحديقة).
- **أختارُ الصورةَ المناسبة:** أسمعُ الجملةَ ثمّ أختارُ الصورةَ التي تدلّ عليها («السمكةُ تسبحُ في الماء» ← صورة السمكة).
- **أُرتّبُ ما حدث:** أعرفُ ما حدثَ أوّلاً وما حدثَ بعده («طلعتِ الشمسُ، فاستيقظَ عليّ» ← الشمسُ أوّلاً).
- **سِرُّ الفهم:** أُنصِتُ إلى الجملة كاملةً، والجوابُ من داخلها؛ ولا أختارُ كلمةً لمجرّد أنّها مذكورة.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', 'بطل الكلام — أُسمّي وأُحيّي وأتكلّم', 'أُعبّر بصوتي: أُسمّي ما أرى في الصورة (قطّة، عصفور، وردة)، وأقول كلمات التحيّة والذوق (السلام عليكم، صباح الخير، شكرًا)، وأختار الكلمة المناسبة لأكمل الجملة، وأختار الكلمة التي تصف الشيء (لونه أو حجمه)', '# ⚔️ بطل الكلام — أُسمّي وأُحيّي وأتكلّم

> 💡 «لساني سيفي! إذا سمّيتُ ما أرى وأحسنتُ الكلام، صرتُ بطلًا يفهمه الجميع.»

في هذه المغامرة أتعلّم أن **أُعبّر بصوتي**: أنظر إلى الصورة فأُسمّيها، وأقول كلمة التحيّة المناسبة، وأختار الكلمة التي تُكمل الجملة. هيّا نتكلّم!

## 🐱 أُسمّي ما أرى

أنظر إلى الصورة، ثمّ أقول اسمها بصوتٍ واضح. هذه **قطّةٌ**. أقول: «هذه قطّة».

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><ellipse cx="60" cy="78" rx="30" ry="26" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="44" r="22" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M42 30 l-6 -16 l16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M78 30 l6 -16 l-16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="52" cy="44" r="3" fill="#1f2937" stroke="none"/><circle cx="68" cy="44" r="3" fill="#1f2937" stroke="none"/><path d="M60 50 l-4 5 l8 0 z" fill="#f97316" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="52" x2="24" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="56" x2="24" y2="58" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="52" x2="96" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="56" x2="96" y2="58" stroke="#1f2937" stroke-width="2"/></svg>

كلّ شيءٍ حولي له **اسم**: عصفور، وردة، كرة، تفّاحة، شمس. كلّما عرفتُ أسماء الأشياء، صار كلامي أجمل.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><ellipse cx="58" cy="64" rx="28" ry="22" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><circle cx="84" cy="48" r="14" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><path d="M94 46 l16 -4 l-14 12 z" fill="#f59e0b" stroke="#1f2937" stroke-width="2"/><circle cx="88" cy="45" r="3" fill="#1f2937" stroke="none"/><path d="M34 60 q-18 -6 -26 6 q16 4 26 0 z" fill="#0ea5e9" stroke="#1f2937" stroke-width="3"/><path d="M50 78 l-4 16 M66 78 l4 16" stroke="#f59e0b" stroke-width="3" stroke-linecap="round"/></svg>

## 🌸 الكلمة التي تصف الشيء

بعض الكلمات **تصف** الشيء: لونه أو حجمه. هذه **وردةٌ حمراء**، فلونها **أحمر**. والفيل **كبير**، والفأر **صغير**.

<svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><ellipse cx="60" cy="40" rx="12" ry="16" fill="#ef4444"/><ellipse cx="40" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="80" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="48" cy="66" rx="12" ry="16" fill="#ef4444"/><ellipse cx="72" cy="66" rx="12" ry="16" fill="#ef4444"/></g><circle cx="60" cy="54" r="11" fill="#facc15" stroke="#1f2937" stroke-width="3"/><line x1="60" y1="64" x2="60" y2="108" stroke="#16a34a" stroke-width="4"/><path d="M60 86 q16 -2 22 -14 q-16 0 -22 14 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>

## 🤝 أُحيّي وأشكر

البطل المؤدّب يقول كلمات **التحيّة** و**الذوق** في وقتها. أتعلّم متى أقول كلّ كلمة:

| متى؟ | ماذا أقول؟ |
| ---- | ---------- |
| حين أدخل في الصباح | **صباح الخير** أو **السلام عليكم** |
| حين أنام في الليل | **تصبح على خير** |
| حين أُعطاني أحدٌ شيئًا | **شكرًا** |
| حين أُغادر | **مع السلامة** |

> 🗡️ سرّ البطل: لكلّ موقفٍ كلمته. «صباح الخير» للصباح، و«شكرًا» للهديّة. الكلمة المناسبة في وقتها تصنع صديقًا.

## 🗣️ أُكمل الجملة بالكلمة المناسبة

كلّ شيءٍ يفعل فعله الخاصّ. أختار الكلمة التي **تُكمل** الجملة:

- القطّة **تموء**.
- العصفور **يطير**.
- السمكة **تسبح**.
- التلميذ **يقرأ**.

أنظر إلى الكلمة الأولى، ثمّ أختار ما يناسبها. لا أقول «القطّة تطير»!

> ⚠️ الفخّ الشائع: لا أخلط بين كلمات التحيّة. «تصبح على خير» تُقال عند **النوم** لا عند الدخول صباحًا.

> 🏆 أحسنت! صرتَ تُسمّي ما ترى، وتقول كلمة التحيّة في وقتها، وتختار الكلمة المناسبة. أنت الآن **بطل الكلام**، مستعدٌّ لتبني جملةً كاملة!', '# 📜 ملخّص: بطل الكلام — أُسمّي وأُحيّي وأتكلّم

- **أُسمّي ما أرى:** أنظر إلى الصورة وأقول اسمها بوضوح (هذه **قطّة**، هذا **عصفور**).
- **الكلمة التي تصف الشيء:** أصف لونه أو حجمه (وردةٌ **حمراء**، فيلٌ **كبير**، فأرٌ **صغير**).
- **أُحيّي وأشكر:** لكلّ موقفٍ كلمته — **صباح الخير** عند الدخول، **شكرًا** على الهديّة، **تصبح على خير** عند النوم، **مع السلامة** عند المغادرة.
- **أُكمل الجملة بالكلمة المناسبة:** القطّة **تموء**، العصفور **يطير**، السمكة **تسبح**، التلميذ **يقرأ**.
- **أنتبه:** «تصبح على خير» تُقال عند النوم لا عند الدخول صباحًا.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', 'بطل الجملة — أقرأ وأفهمُ ما أقرأ', 'أجمعُ ما تعلّمتُ: أقرأُ جملةً قصيرةً من ثلاث أو أربع كلمات، وأعرفُ أنّ الكلمات تفصلُ بينها مسافات، وأعدُّ كلمات الجملة، وأختارُ الجملة التي تصفُ الصورة، وأفهمُ مَن فعل وماذا فعل', '# ⚔️ بطل الجملة — أقرأ وأفهمُ ما أقرأ

> 💡 «جمعتُ الحروفَ فصارت كلمات، وجمعتُ الكلماتِ فصارت جملةً تحكي وتفهم!»

في مغامراتي السّابقة تعلّمتُ **الحروف** و**الكلمات**. واليوم أجمعها كلّها في كنزٍ واحد: **الجملة**. الجملةُ كلماتٌ قليلةٌ تعطي **معنى**.

## 🧩 ما هي الجملة؟

الجملةُ هي **عدّة كلماتٍ** نضعها معًا فتعطي معنى. مثال: **«القطّةُ تشربُ الحليبَ»**. هذه جملةٌ تخبرنا بشيء: مَن؟ القطّة. ماذا تفعل؟ تشرب.

<svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="78" cy="84" rx="40" ry="26" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="58" r="22" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M28 42 l-6 -16 l16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 42 l6 -16 l-16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="38" cy="56" r="3" fill="#1f2937" stroke="none"/><circle cx="52" cy="56" r="3" fill="#1f2937" stroke="none"/><path d="M118 96 h44 v-22 h-44 z" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><path d="M120 76 q20 -10 40 0" fill="none" stroke="#38bdf8" stroke-width="6"/></svg>

## ␣ الكلماتُ تفصلُ بينها مسافات

بين كلّ كلمةٍ وكلمةٍ **مسافةٌ** (فراغٌ صغير). المسافةُ تساعدني على معرفة أين تنتهي كلمةٌ وأين تبدأ التي بعدها:

> القطّةُ ␣ تشربُ ␣ الحليبَ

أعدُّ المسافات، ثمّ أعرفُ كم كلمةً في الجملة. في هذه الجملة **3** كلمات.

## 🔢 أعدُّ كلماتِ الجملة

أنظرُ إلى الجملة، وأعدُّ كلماتها واحدةً واحدة:

| الجملة | عدد الكلمات |
| ------ | ----------- |
| البنتُ تقرأ | 2 |
| الطّفلُ يلعبُ بالكرة | 3 |
| العصفورُ يطيرُ فوق الشّجرة | 4 |

> 🗡️ كلّ كلمةٍ يفصلها فراغ. عدد الكلمات = عدد الكلمات بين الفراغات، لا عدد الحروف!

## 🖼️ أُطابقُ الجملةَ بالصورة

أقرأُ الجملةَ، ثمّ أنظرُ إلى الصورة: هل تصفها؟ هنا **«الطّفلُ يلعبُ بالكرة»**، وأرى طفلًا وكرةً حمراء، فالجملةُ تناسبُ الصورة.

<svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="70" cy="40" r="16" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="56" x2="70" y2="92" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="66" x2="52" y2="82" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="66" x2="90" y2="80" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="92" x2="56" y2="116" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="92" x2="84" y2="116" stroke="#1f2937" stroke-width="3"/><circle cx="128" cy="100" r="20" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M128 80 v40 M108 100 h40" stroke="#1f2937" stroke-width="2"/></svg>

## 🌞 أفهمُ مَن فعل وماذا فعل

كلُّ جملةٍ تخبرني: **مَن** الذي فعل، و**ماذا** فعل. في جملة **«الشّمسُ فوق الدّار»**: مَن؟ الشّمس. أين هي؟ فوق الدّار.

<svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="40" r="20" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="48" y1="8" x2="48" y2="18"/><line x1="14" y1="40" x2="24" y2="40"/><line x1="24" y1="20" x2="31" y2="27"/></g><path d="M104 116 v-44 l40 -26 l40 26 v44 z" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><path d="M100 74 l44 -28 l44 28" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><rect x="132" y="92" width="24" height="24" fill="#92400e" stroke="#1f2937" stroke-width="3"/></svg>

> ⚠️ الفخّ الشائع: لا تخلط بين الكلمات. «القطّةُ تشربُ الحليبَ» غير «الطّفلُ يشربُ الحليبَ»؛ تغييرُ كلمةٍ واحدةٍ يغيّرُ مَن يفعل!

> 🏆 أحسنت يا بطل! جمعتَ الحروفَ والكلماتِ، وصرتَ **تقرأُ جملةً قصيرةً وتفهمها**، وتعدُّ كلماتها، وتطابقها بالصورة. أنت الآن قارئٌ حقيقيّ!', '# 📜 ملخّص: بطل الجملة — أقرأ وأفهمُ ما أقرأ

- **ما هي الجملة:** الجملةُ عدّةُ كلماتٍ معًا تعطي معنى (**«القطّةُ تشربُ الحليبَ»** تخبرنا مَن وماذا).
- **المسافاتُ تفصلُ الكلمات:** بين كلّ كلمتين فراغٌ صغير يدلّني على أين تنتهي كلمةٌ وتبدأ الأخرى.
- **أعدُّ كلماتِ الجملة:** أعدُّ الكلمات بين الفراغات (البنتُ تقرأ = 2، الطّفلُ يلعبُ بالكرة = 3، العصفورُ يطيرُ فوق الشّجرة = 4).
- **أطابقُ الجملةَ بالصورة:** أقرأُ الجملة ثمّ أختارُ الصورة التي تصفها، أو الجملةَ التي تصفُ الصورة.
- **أفهمُ مَن فعل وماذا فعل:** كلُّ جملةٍ تخبرني مَن الذي فعل وماذا فعل (**«الشّمسُ فوق الدّار»**: مَن؟ الشّمس).', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f30d0d25-4d37-52cf-bd69-f08da894dcf9', '9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#1d4ed8" stroke="none">م</text></svg>', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف س"}]'::jsonb, 'c', 'هذا هو الحرف م، وصوته «مـْ» كما في كلمة موز.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('599fc767-30bd-59d0-af3c-1d7d58c9f226', '9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'كلمة «تفّاحة» بأيّ حرفٍ تبدأ؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف د"},{"id":"d","text":"الحرف ر"}]'::jsonb, 'b', 'أوّل صوتٍ في كلمة تفّاحة هو «تـْ»، فهي تبدأ بالحرف ت.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc46e3ba-d74e-5438-a8e7-68776aa0ceee', '9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'كلمة «شمس» بأيّ حرفٍ تبدأ؟', '[{"id":"a","text":"الحرف س"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ش"}]'::jsonb, 'd', 'أوّل صوتٍ في كلمة شمس هو «شـْ»، فهي تبدأ بالحرف ش.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc991416-2028-5bc8-8ef2-d16e15ab5ab2', '9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'كم نقطةً للحرف ت، وأين؟', '[{"id":"a","text":"نقطتان فوقه"},{"id":"b","text":"نقطةٌ واحدةٌ تحته"},{"id":"c","text":"ثلاث نقطٍ فوقه"},{"id":"d","text":"لا نقطة له"}]'::jsonb, 'a', 'الحرف ت له نقطتان فوقه. أمّا ب فنقطةٌ واحدةٌ تحته، و ث ثلاث نقطٍ فوقه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a82820d0-9eeb-5489-a5bb-502f4bce7ccd', '9e1040d0-d87f-5cc0-bcd4-ae999f0549f5', 'أيّ حرفٍ ليست له نقطة؟', '[{"id":"a","text":"الحرف ذ"},{"id":"b","text":"الحرف د"},{"id":"c","text":"الحرف ب"},{"id":"d","text":"الحرف ت"}]'::jsonb, 'b', 'الحرف د ليست له نقطة. أمّا ذ ففوقه نقطةٌ واحدة، وهذا هو الفرق بينهما.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eefedd39-ee87-5d83-9750-d6485707dbdd', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', '⭐ تمرين: أتعرّف على الحروف', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d71fefc0-4b8e-55af-a04a-ee0149231bab', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#15803d" stroke="none">س</text></svg>', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف س"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف د"}]'::jsonb, 'b', 'هذا هو الحرف س، وصوته «سـْ» كما في كلمة سمكة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48820f18-d6ff-5bd8-a9fd-6d1929d58164', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fecaca" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#b91c1c" stroke="none">ل</text></svg>', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف ر"}]'::jsonb, 'c', 'هذا هو الحرف ل، وصوته «لـْ» كما في كلمة ليمون.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc07af22-7827-5598-a6f9-f060854767cf', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"الحرف ش"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف ت"},{"id":"d","text":"الحرف د"}]'::jsonb, 'a', 'هذه شمس، وأوّل صوتٍ فيها «شـْ»، فهي تبدأ بالحرف ش.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9a47e37-f253-5dd3-ba2d-71159dde9c26', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'بأيّ حرفٍ تبدأ كلمة «دار»؟', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف س"},{"id":"d","text":"الحرف د"}]'::jsonb, 'd', 'أوّل صوتٍ في كلمة دار هو «دْ»، فهي تبدأ بالحرف د.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff0a0c58-62ba-5f77-bfc8-364fc95e0c51', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف س"},{"id":"d","text":"الحرف ت"}]'::jsonb, 'c', 'هذه سمكة، وأوّل صوتٍ فيها «سـْ»، فهي تبدأ بالحرف س.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5fd055c-149e-55cf-993e-6c411c0df7c2', 'eefedd39-ee87-5d83-9750-d6485707dbdd', 'بأيّ حرفٍ تبدأ كلمة «موز»؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف د"},{"id":"d","text":"الحرف ب"}]'::jsonb, 'a', 'أوّل صوتٍ في كلمة موز هو «مـْ»، فهي تبدأ بالحرف م.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cae4551a-6b38-5008-a089-a3ad12a1e11e', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الحروف المتشابهة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('802bc4a5-23b2-5872-b4b7-86c5065830b9', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'أيّ حرفٍ له نقطةٌ واحدةٌ تحته؟', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ث"},{"id":"c","text":"الحرف ب"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'c', 'الحرف ب له نقطةٌ واحدةٌ تحته. الفخّ الشائع هو الخلط مع ت (نقطتان فوقه) و ث (ثلاث نقطٍ فوقه)؛ والنقطة تحت الحرف علامة ب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e93e1fa7-3cee-58d3-ad6b-66f3e2ed550a', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fef08a" stroke="#1f2937" stroke-width="3"/><text x="60" y="84" font-size="66" text-anchor="middle" fill="#a16207" stroke="none">ث</text></svg>', '[{"id":"a","text":"الحرف ب (نقطةٌ تحته)"},{"id":"b","text":"الحرف ث (ثلاث نقطٍ فوقه)"},{"id":"c","text":"الحرف ت (نقطتان فوقه)"},{"id":"d","text":"الحرف ن (نقطةٌ فوقه)"}]'::jsonb, 'b', 'فوق الحرف ثلاث نقطٍ، فهو الحرف ث. الفخّ الشائع هو عدّ النقط بسرعة والخلط مع ت ذي النقطتين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5586e77a-7321-5a9c-ba0e-6656b7943beb', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'الحرف ذ يختلف عن الحرف د بـ:', '[{"id":"a","text":"أنّه أكبر حجمًا"},{"id":"b","text":"أنّه مقلوب"},{"id":"c","text":"أنّه ملوّن"},{"id":"d","text":"أنّ فوقه نقطةً واحدة"}]'::jsonb, 'd', 'الحرف ذ فوقه نقطةٌ واحدة، أمّا د فلا نقطة له. هذا هو الفرق الوحيد بينهما في الشكل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e80c3c63-8b94-5e3e-8868-62a421b240e6', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="60" cy="78" rx="34" ry="40" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="40" r="20" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><path d="M44 34 l-12 -10" stroke="#f59e0b" stroke-width="6" stroke-linecap="round"/><path d="M76 34 l12 -10" stroke="#f59e0b" stroke-width="6" stroke-linecap="round"/><circle cx="53" cy="40" r="3" fill="#1f2937" stroke="none"/><circle cx="67" cy="40" r="3" fill="#1f2937" stroke="none"/><path d="M86 70 q14 6 0 14" fill="#f97316" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف د"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف س"}]'::jsonb, 'a', 'هذه بطّة، وأوّل صوتٍ فيها «بْ»، فهي تبدأ بالحرف ب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55cb50af-0783-5930-a27b-1ade4e0a1ed2', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'كلمة «رمّان» وكلمة «زهرة»: ما الحرفان اللذان تبدآن بهما على الترتيب؟', '[{"id":"a","text":"ز ثمّ ر"},{"id":"b","text":"ر ثمّ ر"},{"id":"c","text":"ر ثمّ ز"},{"id":"d","text":"ز ثمّ ز"}]'::jsonb, 'c', 'رمّان تبدأ بصوت «رْ» (الحرف ر)، وزهرة تبدأ بصوت «زْ» (الحرف ز). الفرق بينهما نقطةٌ فوق ز.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bd84392-65a0-5b3e-bd36-f0f0f7cad4d5', 'cae4551a-6b38-5008-a089-a3ad12a1e11e', 'أيّ كلمةٍ تبدأ بالحرف م؟', '[{"id":"a","text":"تفّاحة"},{"id":"b","text":"موز"},{"id":"c","text":"دار"},{"id":"d","text":"سمكة"}]'::jsonb, 'b', 'كلمة موز تبدأ بصوت «مـْ»، فهي التي تبدأ بالحرف م. أمّا تفّاحة فبـ ت، ودار بـ د، وسمكة بـ س.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b39c9922-136e-5093-b32a-4e1382a26ef7', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', '⭐⭐ تمرين مراجعة: الحروف وأصواتها', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dca06bba-974f-5775-8df3-47ea9799331f', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#c7d2fe" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#4338ca" stroke="none">د</text></svg>', '[{"id":"a","text":"الحرف د"},{"id":"b","text":"الحرف ر"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف م"}]'::jsonb, 'a', 'هذا هو الحرف د، وصوته «دْ» كما في كلمة دار، وليست له نقطة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c950639a-3197-59a0-a812-fe8e1c90e63b', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'بأيّ حرفٍ تبدأ كلمة «ليمون»؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف س"}]'::jsonb, 'c', 'أوّل صوتٍ في كلمة ليمون هو «لـْ»، فهي تبدأ بالحرف ل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fa9a140-0004-5bdf-a8bd-416f8a95c3ba', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'أيّ حرفٍ له نقطتان فوقه؟', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف د"},{"id":"d","text":"الحرف س"}]'::jsonb, 'b', 'الحرف ت له نقطتان فوقه. أمّا ب فنقطةٌ واحدةٌ تحته، و د و س فلا نقط لهما.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fafb51ad-dd2a-5dc4-b605-b9e344faf89a', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"الحرف س"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف ت"}]'::jsonb, 'd', 'هذه تفّاحة، وأوّل صوتٍ فيها «تـْ»، فهي تبدأ بالحرف ت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9f16cf2-c844-5f9b-88c5-2361cd7946a9', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'أيّ كلمةٍ تبدأ بالحرف س؟', '[{"id":"a","text":"سمكة"},{"id":"b","text":"موز"},{"id":"c","text":"دار"},{"id":"d","text":"ليمون"}]'::jsonb, 'a', 'كلمة سمكة تبدأ بصوت «سـْ»، فهي التي تبدأ بالحرف س.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98d3d804-7cc1-55e6-8251-4de14852d53b', 'b39c9922-136e-5093-b32a-4e1382a26ef7', 'الحرف الذي ليست له نقطة هو:', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'c', 'الحرف ل ليست له نقطة. أمّا ت فنقطتان، و ب فنقطةٌ واحدة، و ث فثلاث نقط.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0fae725c-0549-5b50-8215-376ae84b771e', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الأصوات', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b46d0438-84c7-5446-a121-67c09662c670', '0fae725c-0549-5b50-8215-376ae84b771e', 'أيّ صورةٍ اسمها يبدأ بالحرف س؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'الصورة (ب) سمكة، وتبدأ بصوت «سـْ» (الحرف س). أمّا (أ) تفّاحة بـ ت، و(ج) شمس بـ ش، و(د) قطرة ماء بـ ق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a80c4508-2a0b-55ed-a63d-5e9409ebd883', '0fae725c-0549-5b50-8215-376ae84b771e', 'أيّ صورةٍ اسمها يبدأ بالحرف ت؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'الصورة (د) تفّاحة، وتبدأ بصوت «تـْ» (الحرف ت). أمّا (أ) شمس بـ ش، و(ب) سمكة بـ س، و(ج) قطرة ماء بـ ق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11778a3d-ec5a-5663-a608-694b13f46b13', '0fae725c-0549-5b50-8215-376ae84b771e', 'كلمة «قمر» وكلمة «شمس» في السماء. أيّ الحرفين تبدآن بهما على الترتيب؟', '[{"id":"a","text":"ش ثمّ ق"},{"id":"b","text":"ق ثمّ س"},{"id":"c","text":"ق ثمّ ش"},{"id":"d","text":"ش ثمّ ش"}]'::jsonb, 'c', 'قمر تبدأ بصوت «قْ» (الحرف ق)، وشمس تبدأ بصوت «شـْ» (الحرف ش). الفخّ الشائع هو الخلط بين س و ش؛ والفرق ثلاث نقطٍ فوق ش.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a97732c1-39e0-5e70-b32d-e721c24dd268', '0fae725c-0549-5b50-8215-376ae84b771e', 'اسمٌ فيه ثلاثة حروف: د ثمّ ا ثمّ ر. ما هذه الكلمة؟', '[{"id":"a","text":"دار"},{"id":"b","text":"نار"},{"id":"c","text":"جار"},{"id":"d","text":"بار"}]'::jsonb, 'a', 'الحروف د + ا + ر تكوّن كلمة «دار». أوّل صوتٍ فيها «دْ»، وهو يدلّ على الحرف د.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebabfc8a-f388-51da-b0bb-f2da10ef5946', '0fae725c-0549-5b50-8215-376ae84b771e', 'أيّ مجموعةٍ كلماتها كلّها تبدأ بحروفٍ ليست لها نقط؟', '[{"id":"a","text":"تفّاحة، بطّة"},{"id":"b","text":"دار، ليمون"},{"id":"c","text":"زهرة، تمر"},{"id":"d","text":"بطّة، ثوم"}]'::jsonb, 'b', 'دار تبدأ بـ د، وليمون تبدأ بـ ل، وكلاهما بلا نقط. أمّا ت و ب و ز و ث ففيها نقط، لذلك بقيّة المجموعات خاطئة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee3e1e14-0b74-5121-988d-df297de5f3a7', '0fae725c-0549-5b50-8215-376ae84b771e', 'أكتب أوّل حرفٍ من كلمة «بطّة» ثمّ أوّل حرفٍ من كلمة «تمر». ما هما؟', '[{"id":"a","text":"ت ثمّ ب"},{"id":"b","text":"ب ثمّ ث"},{"id":"c","text":"ت ثمّ ت"},{"id":"d","text":"ب ثمّ ت"}]'::jsonb, 'd', 'بطّة تبدأ بـ ب (نقطةٌ تحته)، وتمر تبدأ بـ ت (نقطتان فوقه). الفخّ الشائع هو الخلط بينهما بسبب تشابه الشكل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eebee73f-74a1-5624-a159-eb75a2455812', '69fa5b1f-a2cb-55cf-9146-47a61438845a', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للحروف', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43700ddd-dd0b-5449-9c7d-eb4b7c27d173', 'eebee73f-74a1-5624-a159-eb75a2455812', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fbcfe8" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#be185d" stroke="none">ب</text></svg>', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ث"},{"id":"c","text":"الحرف ب"},{"id":"d","text":"الحرف م"}]'::jsonb, 'c', 'هذا هو الحرف ب، وله نقطةٌ واحدةٌ تحته، وصوته «بْ» كما في بطّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0c9c9f1-5f0b-5950-a227-fd3456915bc2', 'eebee73f-74a1-5624-a159-eb75a2455812', 'بأيّ حرفٍ تبدأ كلمة «موز»؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف د"},{"id":"d","text":"الحرف س"}]'::jsonb, 'a', 'أوّل صوتٍ في كلمة موز هو «مـْ»، فهي تبدأ بالحرف م.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e883d83b-8967-52b1-b80a-938917b20c2f', 'eebee73f-74a1-5624-a159-eb75a2455812', 'أيّ حرفٍ فوقه ثلاث نقط؟', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف د"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'd', 'الحرف ث فوقه ثلاث نقط. أمّا ب فنقطةٌ واحدةٌ تحته، و ت فنقطتان فوقه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef935a5b-b0ef-5221-b285-37a41ba1d648', 'eebee73f-74a1-5624-a159-eb75a2455812', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"الحرف س"},{"id":"b","text":"الحرف ش"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف د"}]'::jsonb, 'b', 'هذه شمس، وأوّل صوتٍ فيها «شـْ»، فهي تبدأ بالحرف ش. الفخّ الشائع هو الخلط بين س و ش، والفرق ثلاث نقطٍ فوق ش.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21259c4c-ea36-54dd-993e-08a61c653352', 'eebee73f-74a1-5624-a159-eb75a2455812', 'أيّ زوجٍ صحيحٌ بين الكلمة وأوّل حرفٍ فيها؟', '[{"id":"a","text":"ليمون ← س"},{"id":"b","text":"دار ← ر"},{"id":"c","text":"بطّة ← ب"},{"id":"d","text":"سمكة ← م"}]'::jsonb, 'c', 'بطّة تبدأ بصوت «بْ» (الحرف ب)، وهو الزوج الصحيح. أمّا ليمون فبـ ل، ودار فبـ د، وسمكة فبـ س.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a67255c5-cd9c-5ba9-9f0d-7b65b8a2032d', 'eebee73f-74a1-5624-a159-eb75a2455812', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الحرف د ليست له نقطة"},{"id":"b","text":"الحرف ب له نقطةٌ واحدةٌ تحته"},{"id":"c","text":"الحرف ت له نقطتان فوقه"},{"id":"d","text":"الحرف ذ ليست له نقطة"}]'::jsonb, 'd', 'العبارة الخاطئة هي أنّ ذ ليست له نقطة؛ فالحرف ذ فوقه نقطةٌ واحدة، وهو الذي يفرّقه عن د بلا نقطة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('124a0815-7431-5645-b0c2-e654e8c5a48f', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af6753fe-bb69-572c-9cad-2d35b27cfaf9', '124a0815-7431-5645-b0c2-e654e8c5a48f', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#15803d" stroke="none">ج</text></svg>', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ج"},{"id":"c","text":"الحرف ع"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'b', 'هذا هو الحرف ج، وتحته نقطةٌ واحدة، وصوته «جـْ» كما في كلمة جزر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('326553e3-674b-5d7b-bc0f-230e23428dd0', '124a0815-7431-5645-b0c2-e654e8c5a48f', 'بأيّ حرفٍ تبدأ كلمة «نجمة»؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ل"}]'::jsonb, 'c', 'أوّل صوتٍ في كلمة نجمة هو «نـْ»، فهي تبدأ بالحرف ن.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31b1fc2a-41f9-5f37-a026-e60e7c4c0325', '124a0815-7431-5645-b0c2-e654e8c5a48f', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="58" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="72" cy="58" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="78" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="42" cy="80" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="78" cy="80" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="100" r="12" fill="#a855f7" stroke="#1f2937" stroke-width="3"/><path d="M60 46 q4 -16 18 -22" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M64 26 q10 -6 18 0" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"الحرف ع"},{"id":"b","text":"الحرف ح"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ج"}]'::jsonb, 'a', 'هذا عنب، وأوّل صوتٍ فيه «عـْ»، فهو يبدأ بالحرف ع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f46b1655-caae-5003-8d4d-f6e7e4b1ba27', '124a0815-7431-5645-b0c2-e654e8c5a48f', 'بأيّ حرفٍ تبدأ كلمة «كرة»؟', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ك"}]'::jsonb, 'd', 'أوّل صوتٍ في كلمة كرة هو «كـْ»، فهي تبدأ بالحرف ك.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b87b66fc-2484-566b-9a53-587af37ab1e5', '124a0815-7431-5645-b0c2-e654e8c5a48f', 'أيّ حرفٍ له نقطةٌ واحدةٌ تحته؟', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ج"},{"id":"c","text":"الحرف ع"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'b', 'الحرف ج له نقطةٌ واحدةٌ تحته. أمّا ح و ع فلا نقط لهما، و ن ففوقه نقطةٌ واحدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('062c1e13-d200-5887-ad69-ddcf8b402140', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', '⭐ تمرين: أصطاد أوّل صوت', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd744f4c-c723-5e00-ad89-4af3613ff685', '062c1e13-d200-5887-ad69-ddcf8b402140', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#1d4ed8" stroke="none">ن</text></svg>', '[{"id":"a","text":"الحرف ن"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ت"},{"id":"d","text":"الحرف ل"}]'::jsonb, 'a', 'هذا هو الحرف ن، وفوقه نقطةٌ واحدة، وصوته «نـْ» كما في كلمة نجمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f0758c3-b3de-5625-90d2-4f5b87f70683', '062c1e13-d200-5887-ad69-ddcf8b402140', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fed7aa" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#c2410c" stroke="none">ك</text></svg>', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف ك"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'b', 'هذا هو الحرف ك، وصوته «كـْ» كما في كلمة كرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df8641a7-a315-58b5-b1f4-b05b843ebd95', '062c1e13-d200-5887-ad69-ddcf8b402140', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><path d="M52 44 l16 0 l-4 60 q-4 10 -8 0 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 44 q-2 -14 -16 -16" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><path d="M60 44 q2 -16 16 -16" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><line x1="54" y1="60" x2="66" y2="60" stroke="#1f2937" stroke-width="2"/><line x1="53" y1="74" x2="65" y2="74" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف ج"},{"id":"d","text":"الحرف ب"}]'::jsonb, 'c', 'هذا جزر، وأوّل صوتٍ فيه «جـْ»، فهو يبدأ بالحرف ج.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76bd6896-b3f7-55b2-b52a-f1867381666f', '062c1e13-d200-5887-ad69-ddcf8b402140', 'بأيّ حرفٍ تبدأ كلمة «وردة»؟', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف د"},{"id":"c","text":"الحرف ر"},{"id":"d","text":"الحرف و"}]'::jsonb, 'd', 'أوّل صوتٍ في كلمة وردة هو «وْ»، فهي تبدأ بالحرف و.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9afee316-eed9-5e73-a777-cb5ce5e623de', '062c1e13-d200-5887-ad69-ddcf8b402140', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M60 12 l13 30 l33 3 l-25 22 l8 33 l-29 -18 l-29 18 l8 -33 l-25 -22 l33 -3 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"الحرف ن"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف س"},{"id":"d","text":"الحرف ت"}]'::jsonb, 'a', 'هذه نجمة، وأوّل صوتٍ فيها «نـْ»، فهي تبدأ بالحرف ن.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98c4519b-75bd-582a-ba8b-5e56bfa5758e', '062c1e13-d200-5887-ad69-ddcf8b402140', 'بأيّ حرفٍ تبدأ كلمة «هلال»؟', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف ه"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ع"}]'::jsonb, 'b', 'أوّل صوتٍ في كلمة هلال هو «هـْ»، فهي تبدأ بالحرف ه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b7ff0476-7a76-503a-8fb5-91454673b148', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الأصوات الجديدة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a87e285-33e4-59b1-acd1-c90f42fce53f', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'أيّ حرفٍ له نقطةٌ واحدةٌ تحته؟', '[{"id":"a","text":"الحرف ج"},{"id":"b","text":"الحرف ح"},{"id":"c","text":"الحرف ع"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'a', 'الحرف ج له نقطةٌ واحدةٌ تحته. الفخّ الشائع هو الخلط مع ح (لا نقطة له) ومع ن (نقطةٌ فوقه)؛ والنقطة تحت الحرف علامة ج.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fdac534-0c47-5c2e-a118-44d22345c4d2', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fef08a" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#a16207" stroke="none">ع</text></svg>', '[{"id":"a","text":"الحرف ج (نقطةٌ تحته)"},{"id":"b","text":"الحرف ع (لا نقطة له)"},{"id":"c","text":"الحرف ح (لا نقطة له)"},{"id":"d","text":"الحرف ن (نقطةٌ فوقه)"}]'::jsonb, 'b', 'هذا هو الحرف ع، وهو مفتوحٌ من فوق ولا نقطة له، وصوته «عـْ» كما في عنب. الفخّ الشائع هو الخلط بينه وبين ح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d468a5b-aa34-5f68-8803-4b07ebb6f303', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'الحرف ح يختلف عن الحرف ج بـ:', '[{"id":"a","text":"أنّه أكبر حجمًا"},{"id":"b","text":"أنّه ملوّن"},{"id":"c","text":"أنّه لا نقطة له"},{"id":"d","text":"أنّ فوقه نقطةً واحدة"}]'::jsonb, 'c', 'الحرف ح لا نقطة له، أمّا ج فتحته نقطةٌ واحدة. هذا هو الفرق الوحيد بينهما في الشكل، وكلاهما يشبه الآخر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3523ab08-ac25-596f-9cda-731b2332674a', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><line x1="70" y1="30" x2="70" y2="96" stroke="#1f2937" stroke-width="4"/><path d="M70 50 q-36 -32 -52 -6 q-10 18 12 30 q24 12 40 -6 z" fill="#f472b6" stroke="#1f2937" stroke-width="3"/><path d="M70 70 q-32 -10 -48 14 q-8 18 14 22 q22 2 34 -16 z" fill="#fb7185" stroke="#1f2937" stroke-width="3"/><path d="M70 50 q36 -32 52 -6 q10 18 -12 30 q-24 12 -40 -6 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><path d="M70 70 q32 -10 48 14 q8 18 -14 22 q-22 2 -34 -16 z" fill="#818cf8" stroke="#1f2937" stroke-width="3"/><circle cx="70" cy="28" r="6" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"الحرف و"},{"id":"b","text":"الحرف ه"},{"id":"c","text":"الحرف ك"},{"id":"d","text":"الحرف ف"}]'::jsonb, 'd', 'هذه فراشة، وأوّل صوتٍ فيها «فـْ»، فهي تبدأ بالحرف ف.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('134c1c75-643d-5bc3-85eb-839d865f05ae', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'كلمة «جزر» وكلمة «حوت»: ما الحرفان اللذان تبدآن بهما على الترتيب؟', '[{"id":"a","text":"ج ثمّ ح"},{"id":"b","text":"ح ثمّ ج"},{"id":"c","text":"ج ثمّ ج"},{"id":"d","text":"ح ثمّ ح"}]'::jsonb, 'a', 'جزر تبدأ بصوت «جـْ» (الحرف ج)، وحوت تبدأ بصوت «حْ» (الحرف ح). الفخّ الشائع هو الخلط بينهما؛ والفرق نقطةٌ تحت ج.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('008e7118-7d21-53f9-9f8f-887c7eeaf885', 'b7ff0476-7a76-503a-8fb5-91454673b148', 'أيّ كلمةٍ تبدأ بالحرف ن؟', '[{"id":"a","text":"جزر"},{"id":"b","text":"نجمة"},{"id":"c","text":"وردة"},{"id":"d","text":"كرة"}]'::jsonb, 'b', 'كلمة نجمة تبدأ بصوت «نـْ»، فهي التي تبدأ بالحرف ن. أمّا جزر فبـ ج، ووردة فبـ و، وكرة فبـ ك.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', '⭐⭐ تمرين مراجعة: أصوات الحروف الجديدة', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0486a25-d208-59a0-9cf9-738174a83aa2', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#fbcfe8" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#be185d" stroke="none">ه</text></svg>', '[{"id":"a","text":"الحرف ه"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف و"},{"id":"d","text":"الحرف ع"}]'::jsonb, 'a', 'هذا هو الحرف ه، وصوته «هـْ» كما في كلمة هلال.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f006cbaa-1ffb-5ae1-8289-4afd00b68b91', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'بأيّ حرفٍ تبدأ كلمة «عنب»؟', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ع"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ب"}]'::jsonb, 'b', 'أوّل صوتٍ في كلمة عنب هو «عـْ»، فهي تبدأ بالحرف ع. الفخّ الشائع هو الخلط بين ع و ح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d78cbabc-7531-5a2f-b988-de27dd837130', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'أيّ حرفٍ له نقطةٌ واحدةٌ فوقه؟', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ع"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ج"}]'::jsonb, 'c', 'الحرف ن له نقطةٌ واحدةٌ فوقه. أمّا ح و ع فلا نقط لهما، و ج فنقطةٌ واحدةٌ تحته.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d5d3394-6588-575a-9153-c9ddfe364a40', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="42" fill="#22c55e" stroke="#1f2937" stroke-width="3"/><path d="M18 60 q42 -22 84 0" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M18 60 q42 22 84 0" fill="none" stroke="#1f2937" stroke-width="3"/><line x1="60" y1="18" x2="60" y2="102" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف ل"},{"id":"d","text":"الحرف ك"}]'::jsonb, 'd', 'هذه كرة، وأوّل صوتٍ فيها «كـْ»، فهي تبدأ بالحرف ك.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d3af95d-7a20-5352-a737-c2a57268ea48', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'بأيّ حرفٍ تبدأ كلمة «فراشة»؟', '[{"id":"a","text":"الحرف ف"},{"id":"b","text":"الحرف ر"},{"id":"c","text":"الحرف ش"},{"id":"d","text":"الحرف و"}]'::jsonb, 'a', 'أوّل صوتٍ في كلمة فراشة هو «فـْ»، فهي تبدأ بالحرف ف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cba41f21-e38a-5365-a791-f52982a5d1ee', 'c4fdc82c-833d-5135-900e-b0a6a2f317f7', 'أيّ كلمةٍ تبدأ بالحرف و؟', '[{"id":"a","text":"هلال"},{"id":"b","text":"وردة"},{"id":"c","text":"عنب"},{"id":"d","text":"كرة"}]'::jsonb, 'b', 'كلمة وردة تبدأ بصوت «وْ»، فهي التي تبدأ بالحرف و. أمّا هلال فبـ ه، وعنب فبـ ع، وكرة فبـ ك.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0e5bcce-668b-57bd-9380-672d5aa58053', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: صائد الأصوات الماهر', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('229062dd-a565-5c75-b2db-dbfdb38097b4', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'أيّ صورةٍ اسمها يبدأ بالحرف ن؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 12 l13 30 l33 3 l-25 22 l8 33 l-29 -18 l-29 18 l8 -33 l-25 -22 l33 -3 z\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"}]'::jsonb, 'b', 'الصورة (ب) نجمة، وتبدأ بصوت «نـْ» (الحرف ن). أمّا (أ) تفّاحة بـ ت، و(ج) سمكة بـ س، و(د) شمس بـ ش.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f231859-55ed-5bcb-b124-077b0d670e6f', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'أيّ صورةٍ اسمها يبدأ بالحرف ع؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 130\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"48\" cy=\"58\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"72\" cy=\"58\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"60\" cy=\"78\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"80\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"78\" cy=\"80\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"60\" cy=\"100\" r=\"12\" fill=\"#a855f7\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 46 q4 -16 18 -22\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 130\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M52 44 l16 0 l-4 60 q-4 10 -8 0 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 44 q-2 -14 -16 -16\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"2\"/><path d=\"M60 44 q2 -16 16 -16\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"42\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M18 60 q42 -22 84 0\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M18 60 q42 22 84 0\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"60\" y1=\"18\" x2=\"60\" y2=\"102\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'الصورة (أ) عنب، ويبدأ بصوت «عـْ» (الحرف ع). أمّا (ب) جزر بـ ج، و(ج) كرة بـ ك، و(د) قطرة ماء بـ ق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86fa0ec5-2be2-56eb-9c11-c51b9f245062', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'كلمة «وردة» وكلمة «هلال». أيّ الحرفين تبدآن بهما على الترتيب؟', '[{"id":"a","text":"ه ثمّ و"},{"id":"b","text":"و ثمّ و"},{"id":"c","text":"و ثمّ ه"},{"id":"d","text":"ه ثمّ ه"}]'::jsonb, 'c', 'وردة تبدأ بصوت «وْ» (الحرف و)، وهلال يبدأ بصوت «هـْ» (الحرف ه). فالترتيب الصحيح هو و ثمّ ه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('851f1a38-82df-5834-85ec-35d9a2e7788e', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'اسمٌ فيه ثلاثة حروف: ن ثمّ ا ثمّ ر. ما هذه الكلمة؟', '[{"id":"a","text":"دار"},{"id":"b","text":"جار"},{"id":"c","text":"بار"},{"id":"d","text":"نار"}]'::jsonb, 'd', 'الحروف ن + ا + ر تكوّن كلمة «نار». أوّل صوتٍ فيها «نـْ»، وهو يدلّ على الحرف ن.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1e8b1b0-f782-5da7-93d6-23e0e94687ee', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'أيّ مجموعةٍ كلماتها كلّها تبدأ بحروفٍ ليست لها نقط؟', '[{"id":"a","text":"عنب، حوت"},{"id":"b","text":"نجمة، جزر"},{"id":"c","text":"جزر، نار"},{"id":"d","text":"نجمة، عنب"}]'::jsonb, 'a', 'عنب تبدأ بـ ع، وحوت تبدأ بـ ح، وكلاهما بلا نقط. أمّا ن ففوقه نقطة، و ج فتحته نقطة، لذلك بقيّة المجموعات خاطئة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('056c5ee2-3ed4-5c00-a934-d45709746aee', 'b0e5bcce-668b-57bd-9380-672d5aa58053', 'أكتب أوّل حرفٍ من كلمة «جزر» ثمّ أوّل حرفٍ من كلمة «حوت». ما هما؟', '[{"id":"a","text":"ح ثمّ ج"},{"id":"b","text":"ج ثمّ ح"},{"id":"c","text":"ج ثمّ ج"},{"id":"d","text":"ح ثمّ ح"}]'::jsonb, 'b', 'جزر تبدأ بـ ج (نقطةٌ تحته)، وحوت تبدأ بـ ح (لا نقطة له). الفخّ الشائع هو الخلط بينهما بسبب تشابه الشكل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('74937947-28ae-587e-b282-bf3d53718837', 'c61a3396-f412-5e62-a171-517e92af8c10', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لأوّل الأصوات', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02233fc1-6132-54ff-a484-b3ea09762e86', '74937947-28ae-587e-b282-bf3d53718837', 'ما هذا الحرف؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="108" height="108" rx="16" fill="#c7d2fe" stroke="#1f2937" stroke-width="3"/><text x="60" y="86" font-size="72" text-anchor="middle" fill="#4338ca" stroke="none">و</text></svg>', '[{"id":"a","text":"الحرف و"},{"id":"b","text":"الحرف م"},{"id":"c","text":"الحرف ه"},{"id":"d","text":"الحرف ن"}]'::jsonb, 'a', 'هذا هو الحرف و، وصوته «وْ» كما في كلمة وردة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f08f15d-6423-5ee7-9278-5fbb3228dd3d', '74937947-28ae-587e-b282-bf3d53718837', 'بأيّ حرفٍ تبدأ كلمة «هلال»؟', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف ه"},{"id":"c","text":"الحرف ع"},{"id":"d","text":"الحرف و"}]'::jsonb, 'b', 'أوّل صوتٍ في كلمة هلال هو «هـْ»، فهي تبدأ بالحرف ه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7cd28ac-f6b2-5c32-8531-e6845ae44e52', '74937947-28ae-587e-b282-bf3d53718837', 'أيّ حرفٍ فوقه نقطةٌ واحدة؟', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ع"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ك"}]'::jsonb, 'c', 'الحرف ن فوقه نقطةٌ واحدة. أمّا ح و ع و ك فلا نقط لها فوقها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b355f5e-7034-5c28-9f80-cf3e68266262', '74937947-28ae-587e-b282-bf3d53718837', 'بأيّ حرفٍ تبدأ هذه الكلمة؟ <svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><path d="M52 44 l16 0 l-4 60 q-4 10 -8 0 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 44 q-2 -14 -16 -16" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><path d="M60 44 q2 -16 16 -16" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><line x1="54" y1="60" x2="66" y2="60" stroke="#1f2937" stroke-width="2"/><line x1="53" y1="74" x2="65" y2="74" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"الحرف ح"},{"id":"b","text":"الحرف ع"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ج"}]'::jsonb, 'd', 'هذا جزر، وأوّل صوتٍ فيه «جـْ»، فهو يبدأ بالحرف ج. الفخّ الشائع هو الخلط بين ج و ح، والفرق نقطةٌ تحت ج.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('faaeea04-f3f6-52f5-8327-f4c17b8874d0', '74937947-28ae-587e-b282-bf3d53718837', 'أيّ زوجٍ صحيحٌ بين الكلمة وأوّل حرفٍ فيها؟', '[{"id":"a","text":"عنب ← ع"},{"id":"b","text":"وردة ← ه"},{"id":"c","text":"نجمة ← م"},{"id":"d","text":"كرة ← ل"}]'::jsonb, 'a', 'عنب تبدأ بصوت «عـْ» (الحرف ع)، وهو الزوج الصحيح. أمّا وردة فبـ و، ونجمة فبـ ن، وكرة فبـ ك.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ed6b763-bf34-59c4-bc5f-6e09c7d3f318', '74937947-28ae-587e-b282-bf3d53718837', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الحرف ح لا نقطة له"},{"id":"b","text":"الحرف ج لا نقطة له"},{"id":"c","text":"الحرف ن فوقه نقطةٌ واحدة"},{"id":"d","text":"الحرف ع لا نقطة له"}]'::jsonb, 'b', 'العبارة الخاطئة هي أنّ ج لا نقطة له؛ فالحرف ج تحته نقطةٌ واحدة، وهو الذي يفرّقه عن ح بلا نقطة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33a9edd8-57cf-530a-8aad-1a70920325f5', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'كم مقطعًا في كلمة «موز»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/><path d="M30 40 q-4 -8 2 -12" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/><path d="M114 84 q8 0 8 -8" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'كلمة موز مقطعٌ واحد ننطقه دفعةً واحدة، فعددها 1. الحرف الساكن «ز» في آخرها لا يكون مقطعًا وحده، بل يُغلق المقطع. أعدّ المقاطع لا الحروف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b5f2a48-53f1-5b72-92b6-637e622f0fb9', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"رَمَق"},{"id":"b","text":"مَقَر"},{"id":"c","text":"قَمَر"},{"id":"d","text":"قَلَم"}]'::jsonb, 'c', 'نصِل «قَ» بـ «مَر» فنحصل على كلمة قَمَر، وهو الذي يضيء في السماء ليلًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e0e4826-c09e-5b7d-8c4e-2a5606987ed5', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"تُفّاحة"},{"id":"b","text":"سَمَكة"},{"id":"c","text":"موز"},{"id":"d","text":"دار"}]'::jsonb, 'a', 'الصورة تفّاحةٌ حمراء، نقرأ الكلمة «تُفْ + فا + حة» = تُفّاحة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bcbf905-cf53-54bc-8b39-d3f7b60fc3c5', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'كم مقطعًا في كلمة «سَمَكة»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'c', 'كلمة سَمَكة فيها ثلاثة مقاطع: «سَ» + «مَ» + «كة»، فعددها 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1c8663b-f84a-5230-9d10-3d78d1afe1dc', '35fd7ee1-8f3d-57f3-b4a6-d7a0486d9e0a', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"شمس"},{"id":"c","text":"نَجْمة"},{"id":"d","text":"دار"}]'::jsonb, 'b', 'الصورة شمسٌ صفراء بأشعّتها، فاسمها شمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e15644d6-8c7d-5a11-8874-a29eb86fb9bc', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', '⭐ تمرين: أبني الكلمة وأعدّ مقاطعها', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92eb4591-70f0-51a4-b029-b51ec168cef7', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"دار"},{"id":"b","text":"موز"},{"id":"c","text":"تُفّاحة"},{"id":"d","text":"سَمَكة"}]'::jsonb, 'c', 'الصورة تفّاحةٌ حمراء، نقرأ الكلمة «تُفْ + فا + حة» = تُفّاحة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('113ad9f9-c829-58db-965c-533e8ceb3673', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'كم مقطعًا في كلمة «موز»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/><path d="M30 40 q-4 -8 2 -12" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/><path d="M114 84 q8 0 8 -8" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'كلمة موز مقطعٌ واحد ننطقه دفعةً واحدة، فعددها 1. الحرف الساكن في آخرها يُغلق المقطع ولا يكون مقطعًا وحده.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('991e622d-3bbd-572d-ac09-501a9f0077b6', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «لَم»؟', '[{"id":"a","text":"لَقَم"},{"id":"b","text":"قَلَم"},{"id":"c","text":"مَلَق"},{"id":"d","text":"قَمَر"}]'::jsonb, 'b', 'نصِل «قَ» بـ «لَم» فنحصل على كلمة قَلَم نكتب به.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('402a9800-c8cc-5b20-a44e-f2fcad30c6cf', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'كم مقطعًا في كلمة «سَمَكة»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'c', 'كلمة سَمَكة فيها ثلاثة مقاطع: «سَ» + «مَ» + «كة»، فعددها 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df1ba87b-bfb4-528f-987d-c73b1a9a23ee', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"قَلَم"},{"id":"b","text":"مَقَر"},{"id":"c","text":"رَمَق"},{"id":"d","text":"قَمَر"}]'::jsonb, 'd', 'نصِل «قَ» بـ «مَر» على الترتيب فنحصل على كلمة قَمَر، وهو الذي يضيء ليلًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15e2537c-6668-5d8e-aebd-cce119cb3753', 'e15644d6-8c7d-5a11-8874-a29eb86fb9bc', 'كم مقطعًا في كلمة «شمس»؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'كلمة شمس مقطعٌ واحد ننطقه دفعةً واحدة، فعددها 1. الحرفان الساكنان «مْس» يُغلقان المقطع ولا يكوّنان مقطعًا جديدًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('44f59472-a7fe-5711-aedb-e649b52ecbfe', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: بنّاء الكلمات الكبير', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89eb2bb6-b24b-55b8-8cdf-4755683d0680', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'كم مقطعًا في كلمة «تُفّاحة»؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'c', 'كلمة تُفّاحة فيها ثلاثة مقاطع: «تُفْ» + «فا» + «حة»، فعددها 3. الفخّ الشائع هو عدّ الحروف بدل المقاطع.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44ac39ad-4d93-572d-b5f1-11ef8f36998b', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"رَقَم"},{"id":"c","text":"مَقَر"},{"id":"d","text":"قَلَم"}]'::jsonb, 'a', 'نصِل «قَ» بـ «مَر» فنحصل على كلمة قَمَر يضيء ليلًا. الفخّ الشائع هو بعثرة ترتيب الحروف، فتتغيّر الكلمة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80297f04-3da5-5f66-913c-78a9ed938d73', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"نَجْمة"},{"id":"c","text":"نار"},{"id":"d","text":"شمس"}]'::jsonb, 'd', 'الصورة شمسٌ صفراء بأشعّتها، فاسمها شمس. الفخّ الشائع هو الخلط بينها وبين القمر الذي يضيء ليلًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d0120c6-dd89-52ac-a0fb-b8dce3243f58', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'كم مقطعًا في كلمة «بَطّة»؟ <svg viewBox="0 0 120 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="60" cy="78" rx="34" ry="40" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="40" r="20" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><circle cx="53" cy="40" r="3" fill="#1f2937" stroke="none"/><circle cx="67" cy="40" r="3" fill="#1f2937" stroke="none"/><path d="M86 70 q14 6 0 14" fill="#f97316" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'b', 'كلمة بَطّة فيها مقطعان: «بَطْ» + «طة»، فعددها 2. الفخّ الشائع هو عدّ الحروف بدل المقطعين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63af78e5-9ee2-5318-9603-35ae0a13e275', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «لَم»؟', '[{"id":"a","text":"قَلَم"},{"id":"b","text":"قَمَر"},{"id":"c","text":"لَقَم"},{"id":"d","text":"مَلَق"}]'::jsonb, 'a', 'نصِل «قَ» بـ «لَم» فنحصل على قَلَم نكتب به. الفخّ الشائع هو الخلط مع قَمَر لتشابه أوّل مقطع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb5c9459-ae4f-5023-b830-96acb49ef556', '44f59472-a7fe-5711-aedb-e649b52ecbfe', 'أيّ زوجٍ صحيحٌ بين الكلمة وعدد مقاطعها؟', '[{"id":"a","text":"قَمَر ← 3"},{"id":"b","text":"سَمَكة ← 2"},{"id":"c","text":"موز ← 1"},{"id":"d","text":"تُفّاحة ← 2"}]'::jsonb, 'c', 'موز = «موز» = مقطعٌ واحد، فالزوج صحيح. الفخّ الشائع: قَمَر مقطعان (لا 3)، وسَمَكة ثلاثة، وتُفّاحة ثلاثة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', '⭐⭐ تمرين مراجعة: المقاطع والكلمة', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b42d191a-8a1f-5285-845c-d233488cc6a6', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'كم مقطعًا في كلمة «موز»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/><path d="M30 40 q-4 -8 2 -12" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/><path d="M114 84 q8 0 8 -8" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'كلمة موز مقطعٌ واحد ننطقه دفعةً واحدة، فعددها 1. الحرف الساكن في آخرها يُغلق المقطع ولا يكون مقطعًا وحده.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0726909-bf8e-5481-952d-5a8558eb5260', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «لَم»؟', '[{"id":"a","text":"لَقَم"},{"id":"b","text":"قَلَم"},{"id":"c","text":"مَلَق"},{"id":"d","text":"قَمَر"}]'::jsonb, 'b', 'نصِل «قَ» بـ «لَم» فنحصل على كلمة قَلَم نكتب به.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e80c5789-93e6-5812-abd5-56e9fc14deec', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"موز"},{"id":"b","text":"سَمَكة"},{"id":"c","text":"دار"},{"id":"d","text":"تُفّاحة"}]'::jsonb, 'd', 'الصورة تفّاحةٌ حمراء، نقرأ الكلمة «تُفْ + فا + حة» = تُفّاحة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03972102-d480-5b42-996c-be76f666f91c', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'كم مقطعًا في كلمة «سَمَكة»؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'c', 'كلمة سَمَكة فيها ثلاثة مقاطع: «سَ» + «مَ» + «كة»، فعددها 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1e340a0-e09f-5893-a21e-32d48f699b4a', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"مَقَر"},{"id":"c","text":"رَمَق"},{"id":"d","text":"قَلَم"}]'::jsonb, 'a', 'نصِل «قَ» بـ «مَر» على الترتيب فنحصل على كلمة قَمَر، وهو الذي يضيء ليلًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('464dd7e2-e28c-5144-b203-38b7cdd663a0', '9cf8ca36-d260-5ba2-b8ad-aaa9dfdb842b', 'أيّ زوجٍ صحيحٌ بين الكلمة وعدد مقاطعها؟', '[{"id":"a","text":"سَمَكة ← 2"},{"id":"b","text":"قَمَر ← 3"},{"id":"c","text":"تُفّاحة ← 2"},{"id":"d","text":"موز ← 1"}]'::jsonb, 'd', 'موز = «موز» = مقطعٌ واحد، فالزوج صحيح. أمّا سَمَكة فثلاثة، وقَمَر مقطعان، وتُفّاحة ثلاثة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('265e811c-8a41-5fd4-ae5e-15181be6c374', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل بناء الكلمات', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abb6010e-df0a-5c1f-b35e-4bfe3717b953', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'أيّ صورةٍ اسمها «سَمَكة»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M30 40 q-4 -8 2 -12\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\" stroke-linecap=\"round\"/></svg>"}]'::jsonb, 'b', 'الصورة (ب) سمكةٌ برتقالية، نقرأ «سَ + مَ + كة» = سَمَكة. أمّا (أ) تفّاحة و(ج) شمس و(د) موز.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ad03104-2945-58cf-942b-ac03c8d1b79d', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'أيّ صورةٍ اسمها «موز»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M30 40 q-4 -8 2 -12\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\" stroke-linecap=\"round\"/><path d=\"M114 84 q8 0 8 -8\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\" stroke-linecap=\"round\"/></svg>"}]'::jsonb, 'd', 'الصورة (د) موزةٌ صفراء، اسمها موز وهو مقطعٌ واحد. أمّا (أ) شمس و(ب) تفّاحة و(ج) قطرة ماء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aed264ae-832f-54a7-b23b-dd3e3cb7585d', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'أيّ كلمةٍ نحصل عليها من المقاطع: «سَ» + «مَ» + «كة»؟', '[{"id":"a","text":"سَمَكة"},{"id":"b","text":"مَكَسة"},{"id":"c","text":"كَسَمة"},{"id":"d","text":"سَكَمة"}]'::jsonb, 'a', 'نصِل «سَ» + «مَ» + «كة» على الترتيب فنحصل على سَمَكة. الفخّ الشائع هو بعثرة ترتيب المقاطع، فتضيع الكلمة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bf4c9ed-e924-51c0-abbe-e82ee04e406e', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'أيّ صورةٍ اسمها «شمس»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/><line x1=\"28\" y1=\"28\" x2=\"37\" y2=\"37\"/><line x1=\"83\" y1=\"83\" x2=\"92\" y2=\"92\"/><line x1=\"92\" y1=\"28\" x2=\"83\" y2=\"37\"/><line x1=\"37\" y1=\"83\" x2=\"28\" y2=\"92\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'الصورة (ج) شمسٌ صفراء بأشعّتها، فاسمها شمس. أمّا (أ) سمكة و(ب) قطرة ماء و(د) تفّاحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('765d490f-f981-549c-a088-2d3d85a1eb6c', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"رَقَم"},{"id":"c","text":"مَرَق"},{"id":"d","text":"قَرَم"}]'::jsonb, 'a', 'نصِل «قَ» بـ «مَر» على الترتيب فنحصل على قَمَر يضيء ليلًا. الفخّ الشائع هو تبديل ترتيب الحروف فتصير رَقَم أو مَرَق.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9726f204-5b32-503e-a903-5c9718ce9396', '265e811c-8a41-5fd4-ae5e-15181be6c374', 'كلّ هذه الكلمات مقاطعها 2، إلّا واحدة. ما **الكلمة المختلفة**؟', '[{"id":"a","text":"قَمَر"},{"id":"b","text":"قَلَم"},{"id":"c","text":"بَطّة"},{"id":"d","text":"سَمَكة"}]'::jsonb, 'd', 'سَمَكة فيها ثلاثة مقاطع «سَ + مَ + كة»، فهي المختلفة. أمّا قَمَر «قَ + مَر» وقَلَم «قَ + لَم» وبَطّة «بَطْ + طة» فكلٌّ منها مقطعان.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('532f70f2-96f6-537c-b304-80b9507e2ee9', '8afb04d3-f89f-56b2-8767-b6c46a5ef491', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمقاطع والكلمة', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed53ac7a-4e2a-59f8-b994-43536353956b', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'كم مقطعًا في كلمة «دار»؟', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'a', 'كلمة دار مقطعٌ واحدٌ طويل «دار»، فعددها 1. ننطقها في نبضةٍ واحدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92bd14e3-8000-5493-b6a5-ef68678ca1fd', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'أيّ كلمةٍ نحصل عليها من المقطعين: «قَ» + «مَر»؟', '[{"id":"a","text":"مَقَر"},{"id":"b","text":"رَمَق"},{"id":"c","text":"قَمَر"},{"id":"d","text":"قَلَم"}]'::jsonb, 'c', 'نصِل «قَ» بـ «مَر» على الترتيب فنحصل على كلمة قَمَر، وهو الذي يضيء ليلًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9796748-bada-5330-9018-6af1c5b5d1a5', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'كم مقطعًا في كلمة «قَطْرة»؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'b', 'كلمة قَطْرة فيها مقطعان: «قَطْ» + «رة»، فعددها 2.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77814524-cef6-5693-9b42-048d5d32696c', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M30 40 q6 44 44 56 q34 10 44 -6 q-30 6 -54 -16 q-22 -22 -22 -36 z" fill="#facc15" stroke="#1f2937" stroke-width="3"/><path d="M30 40 q-4 -8 2 -12" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/><path d="M114 84 q8 0 8 -8" fill="none" stroke="#1f2937" stroke-width="3" stroke-linecap="round"/></svg>', '[{"id":"a","text":"سَمَكة"},{"id":"b","text":"تُفّاحة"},{"id":"c","text":"قَمَر"},{"id":"d","text":"موز"}]'::jsonb, 'd', 'الصورة موزةٌ صفراء، اسمها موز وهو فاكهة، ومقطعه واحد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75391ab3-ba46-5999-a795-3b608b453965', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'أيّ كلمةٍ نحصل عليها من المقاطع: «سَ» + «مَ» + «كة»؟', '[{"id":"a","text":"سَمَكة"},{"id":"b","text":"مَسَكة"},{"id":"c","text":"كَمَسة"},{"id":"d","text":"سَكَمة"}]'::jsonb, 'a', 'نصِل «سَ» + «مَ» + «كة» على الترتيب فنحصل على سَمَكة. الفخّ الشائع هو تبديل ترتيب المقاطع، فتضيع الكلمة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bc9d003-cba2-5c5a-bded-4e702d174799', '532f70f2-96f6-537c-b304-80b9507e2ee9', 'أيّ زوجٍ صحيحٌ بين الكلمة وعدد مقاطعها؟', '[{"id":"a","text":"موز ← 2"},{"id":"b","text":"قَمَر ← 3"},{"id":"c","text":"تُفّاحة ← 2"},{"id":"d","text":"سَمَكة ← 3"}]'::jsonb, 'd', 'سَمَكة = «سَ + مَ + كة» = 3 مقاطع، فالزوج صحيح. الفخّ الشائع: موز مقطعٌ واحد، وقَمَر مقطعان، وتُفّاحة ثلاثة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed291c14-df62-5082-916a-6ffac485f8ce', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a51c766-2497-5969-8386-07607b13eafd', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'ما هذا الحرف في أشكاله الثلاثة (أوّل الكلمة، وسطها، آخرها)؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#15803d" stroke="none">مـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـمـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـم</text></svg>', '[{"id":"a","text":"الحرف ل"},{"id":"b","text":"الحرف ن"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ب"}]'::jsonb, 'c', 'الأشكال الثلاثة مـ و ـمـ و ـم كلّها للحرف م. هو نفس الحرف، تبدّل شكله حسب موقعه في الكلمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00ba5ee9-20cd-5567-9527-e1d51c0667b5', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'في كلمة «عَلَم»، أين يقع الحرف ع؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'a', 'كلمة عَلَم تبدأ بالحرف ع، فهو يقع في أوّل الكلمة، وشكله فيها عـ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bec44fcf-1c1c-519e-8fc2-8c3e34b3449b', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'في كلمة «قَمَر»، أين يقع الحرف م؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'b', 'في كلمة قَمَر يأتي الحرف م بين ق و ر، فهو في وسط الكلمة، وشكله فيها ـمـ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e598c68b-3bb5-543d-8236-cc25c108042b', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'أيّ شكلٍ للحرف ع حين يكون في أوّل الكلمة؟', '[{"id":"a","text":"ـعـ"},{"id":"b","text":"ـع"},{"id":"c","text":"ع"},{"id":"d","text":"عـ"}]'::jsonb, 'd', 'في أوّل الكلمة يتّصل الحرف ع بما بعده فقط، فيكتب عـ كما في كلمة عَلَم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27e505fa-73c0-5e89-ba34-9034a585faac', 'ed291c14-df62-5082-916a-6ffac485f8ce', 'في كلمة «شَمْس»، أين يقع الحرف س؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'c', 'كلمة شَمْس تنتهي بالحرف س، فهو يقع في آخر الكلمة، وشكله فيها ـس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', '⭐ تمرين: أشكال الحرف الثلاثة', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f8159fa-c6d4-5846-be1c-de46b0e1749c', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'ما هذا الحرف في أشكاله الثلاثة؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#15803d" stroke="none">عـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـعـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـع</text></svg>', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف ع"},{"id":"d","text":"الحرف س"}]'::jsonb, 'c', 'الأشكال عـ و ـعـ و ـع كلّها للحرف ع. هو نفس الحرف، تبدّل شكله حسب موقعه في الكلمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5faec28f-b80c-55ac-b81e-7d359c4b28c8', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'في كلمة «بَطَّة»، أين يقع الحرف ب؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'a', 'كلمة بَطَّة تبدأ بالحرف ب، فهو يقع في أوّل الكلمة، وشكله فيها بـ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e17a669-a491-569f-bff9-27ff8c807fee', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'في كلمة «قَمَر»، أين يقع الحرف ر؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'c', 'كلمة قَمَر تنتهي بالحرف ر، فهو يقع في آخر الكلمة، وشكله فيها ـر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7ef9a5b-86cb-588b-9cee-45793b54a8d2', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'ما هذا الحرف في أشكاله الثلاثة؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#fecaca" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#b91c1c" stroke="none">لـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـلـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـل</text></svg>', '[{"id":"a","text":"الحرف د"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف ب"},{"id":"d","text":"الحرف ر"}]'::jsonb, 'b', 'الأشكال لـ و ـلـ و ـل كلّها للحرف ل. الشكل يتغيّر حسب الموقع، لكنّ الحرف واحد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b747124d-02aa-55c4-b292-1294273e27ec', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'أيّ شكلٍ للحرف م حين يكون في آخر الكلمة؟', '[{"id":"a","text":"مـ"},{"id":"b","text":"ـمـ"},{"id":"c","text":"م"},{"id":"d","text":"ـم"}]'::jsonb, 'd', 'في آخر الكلمة يتّصل الحرف م بما قبله فقط، فيكتب ـم كما في كلمة عَلَم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10798752-92cc-584f-b749-a55c00d5da30', 'fe52c7ac-9a2a-595d-a1e3-44024f84c82b', 'في كلمة «سَمَك»، أين يقع الحرف م؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'b', 'في كلمة سَمَك يأتي الحرف م بين س و ك، فهو في وسط الكلمة، وشكله فيها ـمـ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الأشكال الثلاثة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d029ce2-9e92-5c62-9d5f-4feda0558bd8', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'ما هذا الحرف في أشكاله الثلاثة؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#15803d" stroke="none">بـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـبـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـب</text></svg>', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'b', 'الأشكال بـ و ـبـ و ـب كلّها للحرف ب (نقطةٌ واحدةٌ تحته). الفخّ الشائع هو الخلط مع ت و ث، والنقطة تحت الحرف علامة ب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2bbdfd3-a642-5ddf-9958-5e5d55038e7b', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'أيّ شكلٍ للحرف ع حين يكون في وسط الكلمة؟', '[{"id":"a","text":"ع"},{"id":"b","text":"عـ"},{"id":"c","text":"ـعـ"},{"id":"d","text":"ـع"}]'::jsonb, 'c', 'في وسط الكلمة يتّصل الحرف ع بما قبله وبما بعده، فيكتب ـعـ. الفخّ الشائع هو اختيار عـ (شكل الأوّل) بدل شكل الوسط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('605691b7-a003-588b-aef1-962d120f83ea', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'في كلمة «جَمَل»، أين يقع الحرف ج؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'a', 'كلمة جَمَل تبدأ بالحرف ج، فهو في أوّل الكلمة. أمّا م ففي الوسط، و ل ففي الآخر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb63c65f-c584-51b4-a161-f5ffeafcc67f', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'في أيّ كلمةٍ يقع الحرف س في آخرها؟', '[{"id":"a","text":"سَمَك"},{"id":"b","text":"مِسْطَرة"},{"id":"c","text":"عَلَم"},{"id":"d","text":"شَمْس"}]'::jsonb, 'd', 'كلمة شَمْس تنتهي بالحرف س، فهو في آخرها. الفخّ الشائع هو سَمَك التي يقع فيها س في أوّلها، و مِسْطَرة في وسطها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df0a321f-a255-5d0e-82d0-e6c6b6d2c80d', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'في كلمة «نَهْر»، أين يقع الحرف ه؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'b', 'في كلمة نَهْر يأتي الحرف ه بين ن و ر، فهو في وسط الكلمة. الفخّ الشائع هو ظنّ ه آخر الكلمة، لكنّ الآخر هو ر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fe49179-14a9-5f6c-8d17-4a03ba73117d', '0966b836-4ea7-5aae-b987-8caa21a8b5a0', 'في أيّ كلمةٍ يقع الحرف م في أوّلها؟', '[{"id":"a","text":"مَوْز"},{"id":"b","text":"قَمَر"},{"id":"c","text":"عَلَم"},{"id":"d","text":"سَمَك"}]'::jsonb, 'a', 'كلمة مَوْز تبدأ بالحرف م، فهو في أوّلها. الفخّ الشائع: في قَمَر و سَمَك يقع م في الوسط، وفي عَلَم في الآخر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('006d5192-e40a-569e-9b0c-73945cfcb790', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', '⭐⭐ تمرين مراجعة: مواقع الحرف وأشكاله (نمط امتحان)', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6c78ebe-d1c5-5c4c-8f73-10b4f0f9efd4', '006d5192-e40a-569e-9b0c-73945cfcb790', 'ما هذا الحرف في أشكاله الثلاثة؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#15803d" stroke="none">سـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـسـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـس</text></svg>', '[{"id":"a","text":"الحرف م"},{"id":"b","text":"الحرف ل"},{"id":"c","text":"الحرف ب"},{"id":"d","text":"الحرف س"}]'::jsonb, 'd', 'الأشكال سـ و ـسـ و ـس كلّها للحرف س. الشكل يتغيّر حسب الموقع، لكنّ الحرف واحد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53f8405f-6590-5bd7-a3bf-855d45690f32', '006d5192-e40a-569e-9b0c-73945cfcb790', 'في كلمة «دَار»، أين يقع الحرف د؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'a', 'كلمة دَار تبدأ بالحرف د، فهو في أوّل الكلمة. أمّا ر ففي آخرها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bca5948-40b9-5a13-b1b1-0bf58015a46c', '006d5192-e40a-569e-9b0c-73945cfcb790', 'في كلمة «رَمْل»، أين يقع الحرف م؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'b', 'في كلمة رَمْل يأتي الحرف م بين ر و ل، فهو في وسط الكلمة، وشكله فيها ـمـ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2618ffb2-f987-5178-86c0-4460646663d5', '006d5192-e40a-569e-9b0c-73945cfcb790', 'في كلمة «عَلَم»، أين يقع الحرف م؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'c', 'كلمة عَلَم تنتهي بالحرف م، فهو في آخر الكلمة، وشكله فيها ـم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d71a6b2-c87f-5fdf-a9fb-fa34e66fafba', '006d5192-e40a-569e-9b0c-73945cfcb790', 'أيّ شكلٍ للحرف س حين يكون في أوّل الكلمة؟', '[{"id":"a","text":"سـ"},{"id":"b","text":"ـسـ"},{"id":"c","text":"ـس"},{"id":"d","text":"س"}]'::jsonb, 'a', 'في أوّل الكلمة يتّصل الحرف س بما بعده فقط، فيكتب سـ كما في كلمة سَمَك.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3a67fe2-75f6-54f3-a43e-28845bbe9d34', '006d5192-e40a-569e-9b0c-73945cfcb790', 'في أيّ كلمةٍ يقع الحرف ل في آخرها؟', '[{"id":"a","text":"لَيْمون"},{"id":"b","text":"وَلَد"},{"id":"c","text":"جَمَل"},{"id":"d","text":"عَلَم"}]'::jsonb, 'c', 'كلمة جَمَل تنتهي بالحرف ل، فهو في آخرها. أمّا لَيْمون فـ ل في أوّلها، و وَلَد و عَلَم فـ ل في وسطهما.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل المواقع والأشكال', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c34544f0-27b7-5330-9f5e-9fa7caf2910b', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'أيّ بطاقةٍ تُظهر الحرف ع في أوّل الكلمة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#b45309\" stroke=\"none\">ـعـ</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#bbf7d0\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#15803d\" stroke=\"none\">عـ</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#1d4ed8\" stroke=\"none\">ـع</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#fbcfe8\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#be185d\" stroke=\"none\">ع</text></svg>"}]'::jsonb, 'b', 'البطاقة (ب) فيها عـ، وهو شكل ع في أوّل الكلمة (يتّصل بما بعده فقط). أمّا ـعـ ففي الوسط، و ـع ففي الآخر، و ع منفصل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f66c746d-acff-50ad-91e1-bf553e16448c', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'أيّ بطاقةٍ تُظهر الحرف م في آخر الكلمة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#bbf7d0\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#15803d\" stroke=\"none\">مـ</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#b45309\" stroke=\"none\">ـمـ</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#fbcfe8\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#be185d\" stroke=\"none\">م</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 110 110\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"6\" y=\"6\" width=\"98\" height=\"98\" rx=\"16\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/><text x=\"55\" y=\"74\" font-size=\"54\" text-anchor=\"middle\" fill=\"#1d4ed8\" stroke=\"none\">ـم</text></svg>"}]'::jsonb, 'd', 'البطاقة (د) فيها ـم، وهو شكل م في آخر الكلمة (يتّصل بما قبله فقط) كما في عَلَم. أمّا مـ ففي الأوّل، و ـمـ ففي الوسط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('294ca77c-4466-58d9-93fd-3802a5b56de1', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'في كلمة «بَاب»، أين يقع الحرف ب **الأخير**؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'c', 'كلمة بَاب فيها ب مرّتين: الأوّل في أوّلها، والأخير في آخرها. الفخّ الشائع هو اختيار أوّل الكلمة بسبب الحرف الأوّل، لكنّ السؤال عن الأخير.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cead8c4c-b81a-5fe2-9262-d80b1faf9044', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'في أيّ كلمةٍ يقع الحرف ع في وسطها؟', '[{"id":"a","text":"شَمْعة"},{"id":"b","text":"عَلَم"},{"id":"c","text":"جَمَل"},{"id":"d","text":"قَمَر"}]'::jsonb, 'a', 'في كلمة شَمْعة يأتي الحرف ع بين م و ة، فهو في وسطها. الفخّ الشائع هو عَلَم التي يقع فيها ع في أوّلها؛ أمّا جَمَل و قَمَر فلا ع فيهما.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e7e6ff4-f415-5237-84e6-cabadd48c265', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'أريد الحرف م في أوّل كلمةٍ ثمّ في آخر كلمة. أيّ زوجِ كلماتٍ يحقّق ذلك على الترتيب؟', '[{"id":"a","text":"مَوْز ثمّ عَلَم"},{"id":"b","text":"قَمَر ثمّ سَمَك"},{"id":"c","text":"عَلَم ثمّ مَوْز"},{"id":"d","text":"سَمَك ثمّ قَمَر"}]'::jsonb, 'a', 'في مَوْز يقع م في أوّلها، وفي عَلَم يقع م في آخرها، فالزوج (أ) صحيح. الفخّ الشائع: في قَمَر و سَمَك يقع م في الوسط، وفي عَلَم ثمّ مَوْز انقلب الترتيب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c12c13d1-1653-55fd-be2a-17c1f370a605', 'ee43f47d-ee52-5ba2-8afb-29fcb91b2911', 'في كلمة «سَمَك»، ما موقع الحروف س ثمّ م ثمّ ك على الترتيب؟', '[{"id":"a","text":"أوّل، آخر، وسط"},{"id":"b","text":"وسط، أوّل، آخر"},{"id":"c","text":"أوّل، وسط، آخر"},{"id":"d","text":"آخر، وسط، أوّل"}]'::jsonb, 'c', 'في سَمَك: س في أوّلها، م في وسطها، ك في آخرها، فالترتيب أوّل، وسط، آخر. الفخّ الشائع هو قلب مواقع س و ك في الطرفين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'b38ed736-e1c1-57bf-afb0-e5bd5cf060b9', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمواقع والأشكال', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73af3572-4e32-53d3-ac39-18980dd28d27', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'ما هذا الحرف في أشكاله الثلاثة؟ <svg viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="14" width="84" height="92" rx="14" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="50" y="78" font-size="50" text-anchor="middle" fill="#15803d" stroke="none">نـ</text><rect x="108" y="14" width="84" height="92" rx="14" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="150" y="78" font-size="50" text-anchor="middle" fill="#b45309" stroke="none">ـنـ</text><rect x="208" y="14" width="84" height="92" rx="14" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="250" y="78" font-size="50" text-anchor="middle" fill="#1d4ed8" stroke="none">ـن</text></svg>', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف م"}]'::jsonb, 'c', 'الأشكال نـ و ـنـ و ـن كلّها للحرف ن. الشكل يتغيّر حسب الموقع، لكنّ الحرف واحد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('022d37a4-bcac-5ffa-8731-1533097f3a2a', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'في كلمة «نَهْر»، أين يقع الحرف ن؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'a', 'كلمة نَهْر تبدأ بالحرف ن، فهو في أوّل الكلمة. أمّا ه ففي الوسط، و ر ففي الآخر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d45221e-a891-5d5a-a4fe-59908a2ee632', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'أيّ شكلٍ للحرف ع حين يكون في آخر الكلمة؟', '[{"id":"a","text":"ع"},{"id":"b","text":"عـ"},{"id":"c","text":"ـعـ"},{"id":"d","text":"ـع"}]'::jsonb, 'd', 'في آخر الكلمة يتّصل الحرف ع بما قبله فقط، فيكتب ـع. أمّا عـ ففي الأوّل، و ـعـ ففي الوسط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92cd3391-b458-568f-b6e8-776d863c300c', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'في كلمة «جَمَل»، أين يقع الحرف م؟', '[{"id":"a","text":"أوّل الكلمة"},{"id":"b","text":"وسط الكلمة"},{"id":"c","text":"آخر الكلمة"},{"id":"d","text":"غير موجود"}]'::jsonb, 'b', 'في كلمة جَمَل يأتي الحرف م بين ج و ل، فهو في وسط الكلمة، وشكله فيها ـمـ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a90a0edd-4063-540d-a77e-34286c741ffb', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'في أيّ كلمةٍ يقع الحرف ر في آخرها؟', '[{"id":"a","text":"رَمْل"},{"id":"b","text":"مَوْز"},{"id":"c","text":"جَمَل"},{"id":"d","text":"قَمَر"}]'::jsonb, 'd', 'كلمة قَمَر تنتهي بالحرف ر، فهو في آخرها. الفخّ الشائع هو رَمْل التي يقع فيها ر في أوّلها؛ أمّا مَوْز و جَمَل فلا ر فيهما.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51aab555-0343-59ab-a2f0-de135476f472', '36aaaf16-cfda-5eff-87d3-61e19a3c341c', 'أيّ زوجٍ صحيحٌ بين الحرف وموقعه في كلمته؟', '[{"id":"a","text":"ع في «عَلَم» ← آخر الكلمة"},{"id":"b","text":"م في «مَوْز» ← أوّل الكلمة"},{"id":"c","text":"س في «سَمَك» ← وسط الكلمة"},{"id":"d","text":"د في «وَلَد» ← أوّل الكلمة"}]'::jsonb, 'b', 'م في مَوْز يقع في أوّلها، فالزوج (ب) صحيح. أمّا ع في عَلَم ففي أوّلها لا آخرها، و س في سَمَك ففي أوّلها لا وسطها، و د في وَلَد ففي آخرها لا أوّلها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('53f25153-d233-5811-a821-3948a78216cd', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac4f2f5b-7a7b-5bd3-9169-3b5c5879be8c', '53f25153-d233-5811-a821-3948a78216cd', 'في أيّ اتّجاهٍ نكتب اللغة العربية؟', '[{"id":"a","text":"من الأعلى إلى الأسفل"},{"id":"b","text":"من اليسار إلى اليمين"},{"id":"c","text":"من اليمين إلى اليسار"},{"id":"d","text":"من الأسفل إلى الأعلى"}]'::jsonb, 'c', 'نكتب العربية من اليمين إلى اليسار: نبدأ القلم من جهة اليمين ونمشي به نحو اليسار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c217b63-e004-5aca-bf4a-1e093e08a231', '53f25153-d233-5811-a821-3948a78216cd', 'أين يجلس الحرف عندما نكتبه؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="80" x2="180" y2="80" stroke="#1f2937" stroke-width="3"/><text x="100" y="78" font-size="60" text-anchor="middle" fill="#7c3aed" stroke="none">س</text></svg>', '[{"id":"a","text":"على السطر"},{"id":"b","text":"بعيدًا فوق السطر"},{"id":"c","text":"تحت السطر"},{"id":"d","text":"في زاوية الورقة"}]'::jsonb, 'a', 'الحرف يجلس على السطر، لا يطير فوقه ولا يسقط تحته. في الصورة الحرف س جالسٌ على السطر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f3be466-7b1a-5c8a-a5a5-b03e59cc9eb0', '53f25153-d233-5811-a821-3948a78216cd', 'أين توضع نقطة الحرف ب؟', '[{"id":"a","text":"فوق الحرف"},{"id":"b","text":"تحت الحرف"},{"id":"c","text":"داخل الحرف"},{"id":"d","text":"لا نقطة له"}]'::jsonb, 'b', 'نقطة الحرف ب توضع تحته دائمًا. أمّا ت ففوقه نقطتان، فانتبه للمكان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1232de4-790a-5e79-ac01-a437b6ff73cc', '53f25153-d233-5811-a821-3948a78216cd', 'كم نقطةً نرسم فوق الحرف ت؟', '[{"id":"a","text":"ثلاث نقط"},{"id":"b","text":"لا نقطة"},{"id":"c","text":"نقطة واحدة"},{"id":"d","text":"نقطتان"}]'::jsonb, 'd', 'نرسم فوق الحرف ت نقطتين. أمّا ث ففوقه ثلاث نقط، و ن ففوقه نقطةٌ واحدة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2621e1a2-6096-5406-b88f-fbebeeafb5d4', '53f25153-d233-5811-a821-3948a78216cd', 'متى نضع نقط الحرف عند النسخ؟', '[{"id":"a","text":"بعد رسم الحرف، في مكانها الصحيح"},{"id":"b","text":"قبل رسم الحرف"},{"id":"c","text":"لا نضع نقطًا أبدًا"},{"id":"d","text":"في أيّ مكانٍ على الورقة"}]'::jsonb, 'a', 'نرسم الحرف أوّلًا على السطر، ثمّ نضع نقطه بعد ذلك في مكانها الصحيح فوقه أو تحته.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5d33a646-1810-5cd4-91c9-226be8bca7e4', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', '⭐ تمرين: أرسم على السطر', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9933c010-42de-5a27-9964-ad25dbb31276', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'إلى أيّ جهةٍ يشير هذا السهم؟ هكذا نكتب العربية. <svg viewBox="0 0 200 70" xmlns="http://www.w3.org/2000/svg"><polyline points="180,35 40,35" fill="none" stroke="#2563eb" stroke-width="6" stroke-linecap="round"/><polygon points="40,35 60,22 60,48" fill="#2563eb" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"إلى الأعلى"},{"id":"b","text":"من اليمين إلى اليسار"},{"id":"c","text":"من اليسار إلى اليمين"},{"id":"d","text":"إلى الأسفل"}]'::jsonb, 'b', 'السهم يشير من اليمين إلى اليسار، وهكذا نكتب العربية: نبدأ من اليمين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8cce4f4-428c-53f7-b06d-adf785655bfa', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'أين يجلس هذا الحرف؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="80" x2="180" y2="80" stroke="#1f2937" stroke-width="3"/><text x="100" y="78" font-size="60" text-anchor="middle" fill="#15803d" stroke="none">د</text></svg>', '[{"id":"a","text":"تحت السطر"},{"id":"b","text":"في وسط الورقة بلا سطر"},{"id":"c","text":"على السطر"},{"id":"d","text":"فوق السطر بعيدًا"}]'::jsonb, 'c', 'الحرف د يجلس على السطر، كما نرى في الصورة. الحرف يكتب دائمًا على السطر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03901820-29ac-573f-9119-1c03f1d90f1a', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'أين توضع نقطة الحرف ب؟', '[{"id":"a","text":"تحت الحرف"},{"id":"b","text":"فوق الحرف"},{"id":"c","text":"داخل الحرف"},{"id":"d","text":"بجانب الحرف"}]'::jsonb, 'a', 'نقطة الحرف ب توضع تحته دائمًا، وهذا ما يميّزه عن ت ذي النقطتين فوقه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4f4f82e-edb6-5f99-98f3-e682037641dc', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'كم نقطةً نرسم تحت الحرف ب؟', '[{"id":"a","text":"ثلاث نقط"},{"id":"b","text":"نقطتان"},{"id":"c","text":"لا نقطة"},{"id":"d","text":"نقطة واحدة"}]'::jsonb, 'd', 'نرسم تحت الحرف ب نقطةً واحدة. هي علامته التي نضعها أسفله على السطر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f41ead6-df2f-57b1-aba3-b1ec2ec6b96b', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'أيّ حرفٍ ليست له نقطة، فنرسمه على السطر بلا نقط؟', '[{"id":"a","text":"الحرف ب"},{"id":"b","text":"الحرف ت"},{"id":"c","text":"الحرف م"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'c', 'الحرف م ليست له نقطة، فنرسمه على السطر بلا نقط. أمّا ب و ت و ث فلها نقط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ede27c5-d633-597b-93f8-e1291ffd25ad', '5d33a646-1810-5cd4-91c9-226be8bca7e4', 'عند نسخ حرفٍ جديد، ماذا أفعل أوّلًا؟', '[{"id":"a","text":"أنظر جيّدًا إلى الحرف قبل أن أرسمه"},{"id":"b","text":"أضع النقط قبل رسم الحرف"},{"id":"c","text":"أرسم من اليسار إلى اليمين"},{"id":"d","text":"أرسم الحرف تحت السطر"}]'::jsonb, 'a', 'أوّل خطوةٍ في النسخ هي أن أنظر جيّدًا إلى الحرف قبل أن أرسمه، ثمّ أبدأ من اليمين على السطر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الخطّ والسطر', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31b98056-f392-5101-ab78-fb677f8093d0', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'أيّ جملةٍ صحيحةٌ عن كتابة العربية؟', '[{"id":"a","text":"نكتب من اليمين إلى اليسار"},{"id":"b","text":"نكتب من اليسار إلى اليمين"},{"id":"c","text":"نكتب من الأعلى إلى الأسفل"},{"id":"d","text":"نكتب في أيّ اتّجاهٍ نشاء"}]'::jsonb, 'a', 'نكتب العربية من اليمين إلى اليسار. الفخّ الشائع هو الكتابة من اليسار إلى اليمين، وهكذا تُكتب الفرنسية لا العربية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('477a078a-edca-54f7-bcce-ab5b346f55c1', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'بطلٌ صغير رسم الحرف ب ووضع نقطته فوقه. أين كان يجب أن تكون النقطة؟', '[{"id":"a","text":"فوق الحرف، فما فعله صحيح"},{"id":"b","text":"داخل الحرف"},{"id":"c","text":"تحت الحرف"},{"id":"d","text":"بجانب الحرف"}]'::jsonb, 'c', 'نقطة الحرف ب تكون تحته دائمًا. الفخّ الشائع هو وضعها فوقه كما في ت أو ن، لكنّ ب نقطته تحته.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6072144-34c3-5e55-85c3-aaee3a6285b9', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'أيّ حرفٍ من هذه الحروف نقطته تحته؟ <svg viewBox="0 0 360 90" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="10" width="70" height="70" rx="12" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="41" y="62" font-size="44" text-anchor="middle" fill="#1d4ed8" stroke="none">ت</text><rect x="96" y="10" width="70" height="70" rx="12" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="131" y="62" font-size="44" text-anchor="middle" fill="#15803d" stroke="none">ب</text><rect x="186" y="10" width="70" height="70" rx="12" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="221" y="62" font-size="44" text-anchor="middle" fill="#b45309" stroke="none">ن</text><rect x="276" y="10" width="70" height="70" rx="12" fill="#fbcfe8" stroke="#1f2937" stroke-width="3"/><text x="311" y="62" font-size="44" text-anchor="middle" fill="#be185d" stroke="none">ث</text></svg>', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'b', 'الحرف ب نقطته تحته، أمّا ت و ن و ث فنقطها فوقها. الفخّ الشائع هو النظر إلى الشكل ونسيان أنّ ب وحده نقطته تحت.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98a842e8-c470-5334-b8ed-90d3956b6837', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'حرفٌ نرسمه على السطر بلا أيّ نقطة. أيّ هذه الحروف هو؟', '[{"id":"a","text":"الحرف ن"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ت"},{"id":"d","text":"الحرف ر"}]'::jsonb, 'd', 'الحرف ر ليست له نقطة، فنرسمه على السطر بلا نقط. الفخّ الشائع هو الخلط مع ز التي فوقها نقطةٌ واحدة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f6fe939-a2e4-55da-b8f3-022bc159ede9', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'أيّ ترتيبٍ صحيحٌ لنسخ حرفٍ ذي نقطة؟', '[{"id":"a","text":"أرسم الحرف على السطر، ثمّ أضع نقطته في مكانها"},{"id":"b","text":"أضع النقطة أوّلًا، ثمّ أرسم الحرف فوقها"},{"id":"c","text":"أرسم الحرف تحت السطر، ثمّ أتركه بلا نقطة"},{"id":"d","text":"أرسم من اليسار، ثمّ أضع نقطتين دائمًا"}]'::jsonb, 'a', 'الترتيب الصحيح: أرسم الحرف على السطر من اليمين، ثمّ أضع نقطته في مكانها فوقه أو تحته. الفخّ الشائع هو البدء بالنقطة قبل الحرف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b78e80e9-369f-5997-8cbe-1ecff581148f', '48bc9e8e-b843-5fc9-95cf-9c47c9b7362a', 'الحرف ث كم نقطةً له وأين توضع على الورقة؟', '[{"id":"a","text":"نقطةٌ واحدة تحته"},{"id":"b","text":"نقطتان فوقه"},{"id":"c","text":"لا نقطة له"},{"id":"d","text":"ثلاث نقطٍ فوقه"}]'::jsonb, 'd', 'الحرف ث له ثلاث نقطٍ توضع فوقه. الفخّ الشائع هو عدّ النقط بسرعة والخلط مع ت ذي النقطتين فوقه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ddca789a-6a4d-55b6-956a-944f82356b1c', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', '⭐⭐ تمرين مراجعة: الاتّجاه والسطر والنقط', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af3b3e91-0375-5088-ba93-a16c5dd4d0ce', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'هذا السهم يبيّن اتّجاه الكتابة. ما هو؟ <svg viewBox="0 0 200 70" xmlns="http://www.w3.org/2000/svg"><polyline points="180,35 40,35" fill="none" stroke="#7c3aed" stroke-width="6" stroke-linecap="round"/><polygon points="40,35 60,22 60,48" fill="#7c3aed" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"من اليمين إلى اليسار"},{"id":"b","text":"من اليسار إلى اليمين"},{"id":"c","text":"من الأسفل إلى الأعلى"},{"id":"d","text":"من الأعلى إلى الأسفل"}]'::jsonb, 'a', 'السهم يشير من اليمين إلى اليسار، وهو اتّجاه كتابة العربية: نبدأ من اليمين ونمشي نحو اليسار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('826d40c4-d0a9-571d-b89f-d3246628cd3b', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'أين يجب أن يجلس هذا الحرف؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="80" x2="180" y2="80" stroke="#1f2937" stroke-width="3"/><text x="100" y="78" font-size="60" text-anchor="middle" fill="#b91c1c" stroke="none">ل</text></svg>', '[{"id":"a","text":"فوق السطر بعيدًا"},{"id":"b","text":"تحت السطر"},{"id":"c","text":"على السطر"},{"id":"d","text":"خارج الورقة"}]'::jsonb, 'c', 'الحرف ل يجلس على السطر كما في الصورة. كلّ الحروف نكتبها جالسةً على السطر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('036d0331-507f-59ef-b1a3-ed0712c99d07', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'أين توضع نقطة الحرف ن؟', '[{"id":"a","text":"تحت الحرف"},{"id":"b","text":"داخل الحرف"},{"id":"c","text":"لا نقطة له"},{"id":"d","text":"فوق الحرف"}]'::jsonb, 'd', 'نقطة الحرف ن توضع فوقه. أمّا ب فنقطته تحته، فانتبه للفرق في المكان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92f1b183-0e32-50a2-84a8-d16ea38d3f34', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'أيّ حرفٍ نقطته تحته؟', '[{"id":"a","text":"الحرف ت"},{"id":"b","text":"الحرف ب"},{"id":"c","text":"الحرف ن"},{"id":"d","text":"الحرف ث"}]'::jsonb, 'b', 'الحرف ب نقطته تحته، وهو ما يميّزه. أمّا ت و ن و ث فنقطها فوقها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2375994-0c53-5bf9-800c-b8e39bd9fd33', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'أيّ مجموعةٍ كلّها حروفٌ بلا نقط، نرسمها على السطر بلا نقط؟', '[{"id":"a","text":"د، ر، س"},{"id":"b","text":"ب، ت، ث"},{"id":"c","text":"ن، ز، ذ"},{"id":"d","text":"ب، ن، ت"}]'::jsonb, 'a', 'الحروف د و ر و س ليست لها نقط، فنرسمها على السطر بلا نقط. أمّا بقيّة المجموعات ففيها حروفٌ منقوطة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c75f6f6b-c6e7-5af3-8e31-0c0aa08e9b61', 'ddca789a-6a4d-55b6-956a-944f82356b1c', 'ما علامة الخطّ الجميل المرتّب؟', '[{"id":"a","text":"حروفٌ متشابكةٌ ومائلة"},{"id":"b","text":"حروفٌ تحت السطر وبلا نقط"},{"id":"c","text":"حروفٌ على السطر، نظيفةٌ ونقطها في مكانها"},{"id":"d","text":"حروفٌ مكتوبةٌ من اليسار إلى اليمين"}]'::jsonb, 'c', 'الخطّ الجميل حروفه على السطر، نظيفةٌ غير متشابكة، ونقطها في مكانها الصحيح فوقها أو تحتها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد الخطّ', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da763a5d-1fb8-5f6d-a5fe-2f0326fd0b74', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'أيّ سهمٍ يبيّن الاتّجاه الصحيح لكتابة العربية؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 60\" xmlns=\"http://www.w3.org/2000/svg\"><polyline points=\"20,30 100,30\" fill=\"none\" stroke=\"#2563eb\" stroke-width=\"6\" stroke-linecap=\"round\"/><polygon points=\"100,30 82,19 82,41\" fill=\"#2563eb\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 60 120\" xmlns=\"http://www.w3.org/2000/svg\"><polyline points=\"30,20 30,100\" fill=\"none\" stroke=\"#2563eb\" stroke-width=\"6\" stroke-linecap=\"round\"/><polygon points=\"30,100 19,82 41,82\" fill=\"#2563eb\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 60 120\" xmlns=\"http://www.w3.org/2000/svg\"><polyline points=\"30,100 30,20\" fill=\"none\" stroke=\"#2563eb\" stroke-width=\"6\" stroke-linecap=\"round\"/><polygon points=\"30,20 19,38 41,38\" fill=\"#2563eb\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 60\" xmlns=\"http://www.w3.org/2000/svg\"><polyline points=\"100,30 20,30\" fill=\"none\" stroke=\"#2563eb\" stroke-width=\"6\" stroke-linecap=\"round\"/><polygon points=\"20,30 38,19 38,41\" fill=\"#2563eb\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'd', 'السهم (د) يشير من اليمين إلى اليسار، وهو اتّجاه كتابة العربية. الفخّ الشائع هو اختيار (أ) المتّجه يسارًا كالفرنسية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc80436d-badc-5604-a137-634d4ca2aec3', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'أيّ بطاقةٍ فيها حرفٌ نقطته تحته؟ <svg viewBox="0 0 360 90" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="10" width="70" height="70" rx="12" fill="#bbf7d0" stroke="#1f2937" stroke-width="3"/><text x="41" y="62" font-size="44" text-anchor="middle" fill="#15803d" stroke="none">ب</text><rect x="96" y="10" width="70" height="70" rx="12" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><text x="131" y="62" font-size="44" text-anchor="middle" fill="#1d4ed8" stroke="none">ت</text><rect x="186" y="10" width="70" height="70" rx="12" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="221" y="62" font-size="44" text-anchor="middle" fill="#b45309" stroke="none">ن</text><rect x="276" y="10" width="70" height="70" rx="12" fill="#fbcfe8" stroke="#1f2937" stroke-width="3"/><text x="311" y="62" font-size="44" text-anchor="middle" fill="#be185d" stroke="none">ث</text></svg>', '[{"id":"a","text":"البطاقة الأولى (ب)"},{"id":"b","text":"البطاقة الثانية (ت)"},{"id":"c","text":"البطاقة الثالثة (ن)"},{"id":"d","text":"البطاقة الرابعة (ث)"}]'::jsonb, 'a', 'البطاقة الأولى فيها الحرف ب، ونقطته تحته. الفخّ الشائع هو اختيار ت أو ن أو ث، وكلّها نقطها فوقها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2c7449f-5271-5732-9f69-5b8a54512cf8', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'بطلٌ كتب «ب» نقطتها تحت، و«ت» نقطتاها فوق، و«ن» نقطتها فوق. كم حرفًا منها نقطه فوقه؟', '[{"id":"a","text":"حرفٌ واحد"},{"id":"b","text":"ثلاثة حروف"},{"id":"c","text":"حرفان"},{"id":"d","text":"لا شيء"}]'::jsonb, 'c', 'ت و ن نقطهما فوقهما، فهما حرفان. أمّا ب فنقطته تحته. الفخّ الشائع هو عدّ ب معهما فوق، لكنّ ب نقطته تحت.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('363febe8-fe3e-5371-adb6-c7e6c80b9474', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'لنكتب كلمة «بـ ـا ـب» من حرفين على السطر. من أين نبدأ القلم؟', '[{"id":"a","text":"من وسط السطر"},{"id":"b","text":"من جهة اليمين"},{"id":"c","text":"من جهة اليسار"},{"id":"d","text":"من أسفل السطر"}]'::jsonb, 'b', 'نبدأ القلم من جهة اليمين لأنّ العربية تُكتب من اليمين إلى اليسار. الفخّ الشائع هو البدء من اليسار كالفرنسية.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d367671-e492-512d-93b9-e62c0150fccc', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'أيّ عبارةٍ **خاطئة** عن الخطّ والكتابة؟', '[{"id":"a","text":"الحرف يجلس على السطر"},{"id":"b","text":"نقطة الحرف ب توضع فوقه"},{"id":"c","text":"نكتب العربية من اليمين إلى اليسار"},{"id":"d","text":"الحرف ر ليست له نقطة"}]'::jsonb, 'b', 'العبارة الخاطئة أنّ نقطة ب فوقه؛ فنقطة ب توضع تحته دائمًا. الفخّ الشائع هو وضعها فوقه كما في ت أو ن.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1209dbb4-3747-5c45-adb7-d692fc5adff2', '3630b5d0-3f81-5595-bc4c-f7f4fd76d19a', 'خطٌّ جميلٌ مرتّب يجب أن تكون فيه كلّ هذه الأمور **ما عدا** واحدًا. أيّها لا يكون في الخطّ الجميل؟', '[{"id":"a","text":"الحروف على السطر"},{"id":"b","text":"النقط في مكانها الصحيح"},{"id":"c","text":"الحروف متشابكةٌ ومائلة"},{"id":"d","text":"الكتابة من اليمين إلى اليسار"}]'::jsonb, 'c', 'الحروف المتشابكة المائلة علامة خطٍّ غير مرتّب، فهي لا تكون في الخطّ الجميل. أمّا الباقي فكلّه من صفات الخطّ الجميل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cc02b192-9f9b-5e20-95c5-df28a4eb8a50', '9dff385a-88d0-5e90-a6e0-8f5137efdfe8', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للخطّ', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af8799c0-576d-557d-a478-362691a246ee', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'أين يجلس هذا الحرف على الورقة؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><line x1="20" y1="80" x2="180" y2="80" stroke="#1f2937" stroke-width="3"/><text x="100" y="78" font-size="60" text-anchor="middle" fill="#0d9488" stroke="none">م</text></svg>', '[{"id":"a","text":"تحت السطر"},{"id":"b","text":"فوق السطر بعيدًا"},{"id":"c","text":"على السطر"},{"id":"d","text":"في زاوية الورقة"}]'::jsonb, 'c', 'الحرف م يجلس على السطر كما في الصورة، وهو بلا نقط. كلّ الحروف نكتبها على السطر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('977dcdbb-f536-5a31-bf5c-203e78f9544d', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'في أيّ اتّجاهٍ نكتب العربية؟', '[{"id":"a","text":"من اليسار إلى اليمين"},{"id":"b","text":"من اليمين إلى اليسار"},{"id":"c","text":"من الأعلى إلى الأسفل"},{"id":"d","text":"من الأسفل إلى الأعلى"}]'::jsonb, 'b', 'نكتب العربية من اليمين إلى اليسار: نبدأ القلم من اليمين ونمشي به نحو اليسار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0be656df-984a-5d0e-8f66-c266d854feb6', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'أين توضع نقطة الحرف ب؟', '[{"id":"a","text":"تحت الحرف"},{"id":"b","text":"فوق الحرف"},{"id":"c","text":"داخل الحرف"},{"id":"d","text":"بجانب الحرف"}]'::jsonb, 'a', 'نقطة الحرف ب توضع تحته دائمًا، وهي علامته على السطر التي تفرّقه عن ت ذي النقطتين فوقه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52326633-226c-55f5-b983-4bddafb68d95', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'أيّ زوجٍ صحيحٌ بين الحرف ومكان نقطه؟', '[{"id":"a","text":"الحرف ب ← نقطتان فوقه"},{"id":"b","text":"الحرف ت ← نقطةٌ واحدةٌ تحته"},{"id":"c","text":"الحرف د ← ثلاث نقطٍ فوقه"},{"id":"d","text":"الحرف ث ← ثلاث نقطٍ فوقه"}]'::jsonb, 'd', 'الزوج الصحيح هو ث ← ثلاث نقطٍ فوقه. أمّا ب فنقطةٌ تحته، و ت فنقطتان فوقه، و د فبلا نقط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcf6cae4-9d6d-56a6-a0fb-3796f4890d57', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'ما الترتيب الصحيح لنسخ حرفٍ على السطر؟', '[{"id":"a","text":"أضع النقطة، ثمّ أرسم الحرف فوقها"},{"id":"b","text":"أرسم من اليسار، ثمّ أترك الحرف تحت السطر"},{"id":"c","text":"أنظر إلى الحرف، أرسمه على السطر من اليمين، ثمّ أضع نقطه"},{"id":"d","text":"أرسم الحرف في الهواء بلا سطر"}]'::jsonb, 'c', 'الترتيب الصحيح: أنظر إلى الحرف، ثمّ أرسمه على السطر بادئًا من اليمين، ثمّ أضع نقطه في مكانها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c8295ac-98e8-5097-9a6f-ce37e715a845', 'cc02b192-9f9b-5e20-95c5-df28a4eb8a50', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الحرف يجلس على السطر"},{"id":"b","text":"نقطة ب توضع تحته"},{"id":"c","text":"نكتب العربية من اليمين إلى اليسار"},{"id":"d","text":"الحرف س له ثلاث نقطٍ فوقه"}]'::jsonb, 'd', 'العبارة الخاطئة أنّ س له ثلاث نقط؛ فالحرف س ليست له نقطة، نرسمه على السطر بلا نقط. أمّا الذي له ثلاث نقطٍ فوقه فهو ث.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac0ad1da-7c99-5483-8a81-e8a5be02f0fc', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'اِستمعتُ إلى هذه الجملة: «الوَلَدُ يأكلُ تُفّاحة». ماذا يأكلُ الوَلَد؟', '[{"id":"a","text":"تُفّاحة"},{"id":"b","text":"موزة"},{"id":"c","text":"حليب"},{"id":"d","text":"خبز"}]'::jsonb, 'a', 'في الجملة «الوَلَدُ يأكلُ تُفّاحة»، الشيءُ المأكول هو التُّفّاحة، فجوابُ «ماذا يأكل؟» هو تُفّاحة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('786babcd-4189-58df-b101-ef8c46b6329f', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'اِستمعتُ إلى هذه الجملة: «القِطّةُ تشربُ الحليب». مَن يشربُ الحليب؟', '[{"id":"a","text":"الوَلَد"},{"id":"b","text":"العصفور"},{"id":"c","text":"القِطّة"},{"id":"d","text":"البِنت"}]'::jsonb, 'c', 'في الجملة «القِطّةُ تشربُ الحليب»، الذي يشربُ هو القِطّة، فجوابُ «مَن يشرب؟» هو القِطّة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42d77a2c-a0a9-568c-a439-06e6ddc24fa6', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'اِستمعتُ إلى هذه الجملة: «ذهبَ سعيدٌ إلى المدرسة». أين ذهبَ سعيد؟', '[{"id":"a","text":"إلى الحديقة"},{"id":"b","text":"إلى المدرسة"},{"id":"c","text":"إلى السوق"},{"id":"d","text":"إلى البيت"}]'::jsonb, 'b', 'في الجملة «ذهبَ سعيدٌ إلى المدرسة»، المكانُ هو المدرسة، فجوابُ «أين ذهب؟» هو إلى المدرسة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3bd468c-4be5-5a40-b456-0935dafacfac', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'اِستمعتُ إلى هذه الجملة: «العصفورُ يطيرُ فوق الشجرة». ماذا يفعلُ العصفور؟', '[{"id":"a","text":"يأكل"},{"id":"b","text":"ينام"},{"id":"c","text":"يشرب"},{"id":"d","text":"يطير"}]'::jsonb, 'd', 'في الجملة «العصفورُ يطيرُ فوق الشجرة»، الفعلُ هو الطيران، فجوابُ «ماذا يفعل؟» هو يطير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e87b5886-3900-5956-97ed-5897c8cbbc38', 'bdc103fe-e29e-5d56-bcb9-fd847c7f9294', 'اِستمعتُ إلى هذه الجملة: «السمكةُ تسبحُ في الماء». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'الجملةُ تتحدّثُ عن سمكةٍ تسبح، والصورةُ المناسبةُ هي صورةُ السمكة (ج). أمّا (أ) تفّاحة و(ب) شمس و(د) قطرةُ ماء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', '⭐ تمرين: أُنصِتُ وأُجيب', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ed50abe-360f-594e-a8b2-031c8173d3dd', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «البِنتُ تشربُ الماء». مَن تشربُ الماء؟', '[{"id":"a","text":"الوَلَد"},{"id":"b","text":"البِنت"},{"id":"c","text":"القِطّة"},{"id":"d","text":"الجدّ"}]'::jsonb, 'b', 'في الجملة «البِنتُ تشربُ الماء»، الذي تشربُ هي البِنت، فجوابُ «مَن تشرب؟» هو البِنت.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f97acb8-9534-502f-9fff-a4db96027871', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «القِطّةُ تأكلُ السمكة». ماذا تأكلُ القِطّة؟', '[{"id":"a","text":"تُفّاحة"},{"id":"b","text":"حليب"},{"id":"c","text":"خبز"},{"id":"d","text":"السمكة"}]'::jsonb, 'd', 'في الجملة «القِطّةُ تأكلُ السمكة»، الشيءُ المأكول هو السمكة، فجوابُ «ماذا تأكل؟» هو السمكة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91610a25-e1e6-5ddf-b34c-629877fd7f8d', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «جلسَ الجدُّ على الكرسيّ». أين جلسَ الجدّ؟', '[{"id":"a","text":"على الكرسيّ"},{"id":"b","text":"على السرير"},{"id":"c","text":"على الأرض"},{"id":"d","text":"في السيّارة"}]'::jsonb, 'a', 'في الجملة «جلسَ الجدُّ على الكرسيّ»، المكانُ هو الكرسيّ، فجوابُ «أين جلس؟» هو على الكرسيّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d63def28-aeb7-5aa2-8f0e-41f612f1f397', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «العصفورُ فوقَ الشجرة». أين العصفور؟', '[{"id":"a","text":"تحتَ الكرسيّ"},{"id":"b","text":"في الماء"},{"id":"c","text":"فوقَ الشجرة"},{"id":"d","text":"في البيت"}]'::jsonb, 'c', 'في الجملة «العصفورُ فوقَ الشجرة»، المكانُ هو فوقَ الشجرة، فجوابُ «أين العصفور؟» هو فوقَ الشجرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6524cca-d0cb-54fe-ae90-f8bf28a7e5f0', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «الشمسُ في السماء». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"}]'::jsonb, 'd', 'الجملةُ تتحدّثُ عن الشمس، والصورةُ المناسبةُ هي صورةُ الشمس (د). أمّا (أ) تفّاحة و(ب) سمكة و(ج) قطرةُ ماء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cdfba25-b126-5481-a735-97206a695909', '5cf7ce8c-9468-5d8d-b061-d5ee893b184c', 'اِستمعتُ إلى هذه الجملة: «الوَلَدُ يلعبُ بالكُرة». بماذا يلعبُ الوَلَد؟', '[{"id":"a","text":"بالماء"},{"id":"b","text":"بالكُرة"},{"id":"c","text":"بالحليب"},{"id":"d","text":"بالخبز"}]'::jsonb, 'b', 'في الجملة «الوَلَدُ يلعبُ بالكُرة», الشيءُ الذي يلعبُ به هو الكُرة، فجوابُ «بماذا يلعب؟» هو بالكُرة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('feb6daf0-f54c-5b55-b3aa-fe427b510771', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الجملة المسموعة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d746c22e-8f4d-5062-adb7-637720b759bd', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «الوَلَدُ يأكلُ تُفّاحة». ماذا يأكلُ الوَلَد؟', '[{"id":"a","text":"وَلَد"},{"id":"b","text":"موزة"},{"id":"c","text":"تُفّاحة"},{"id":"d","text":"خبز"}]'::jsonb, 'c', 'الشيءُ المأكولُ في الجملة هو التُّفّاحة. الفخّ الشائع هو اختيار «وَلَد» لأنّه مذكور؛ لكنّ الوَلَدَ هو مَن يأكل، لا ما يُؤكَل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bffe59f4-d355-53a9-82f8-7a6692fb6667', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «نامَ القِطُّ تحتَ الطاولة». أين نامَ القِطّ؟', '[{"id":"a","text":"تحتَ الطاولة"},{"id":"b","text":"فوقَ السرير"},{"id":"c","text":"في الحديقة"},{"id":"d","text":"على الكرسيّ"}]'::jsonb, 'a', 'في الجملة «نامَ القِطُّ تحتَ الطاولة»، المكانُ هو تحتَ الطاولة، فجوابُ «أين نام؟» هو تحتَ الطاولة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24935e42-43bc-560b-a9a4-ac0eba10837a', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «أعطتِ الأمُّ الكتابَ للبِنت». مَن أخذَ الكتاب؟', '[{"id":"a","text":"الأمّ"},{"id":"b","text":"الوَلَد"},{"id":"c","text":"الجدّ"},{"id":"d","text":"البِنت"}]'::jsonb, 'd', 'الأمُّ أعطت، والبِنتُ هي مَن أخذَ الكتاب. الفخّ الشائع هو اختيار «الأمّ» لأنّها فاعلةٌ في الجملة؛ لكنّ الآخذَ هو البِنت.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31eebf21-a5ca-594a-bc4e-6c2230c467b3', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «شربَ الوَلَدُ الحليبَ ثمّ نام». ما الذي حدثَ أوّلاً؟', '[{"id":"a","text":"نامَ الوَلَد"},{"id":"b","text":"شربَ الحليب"},{"id":"c","text":"أكلَ الخبز"},{"id":"d","text":"لعبَ بالكُرة"}]'::jsonb, 'b', 'كلمة «ثمّ» تدلُّ على الترتيب: شربَ الوَلَدُ الحليبَ أوّلاً، ثمّ نام. فالذي حدثَ أوّلاً هو شربُ الحليب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9849eb1c-db7e-5784-b3c2-c01f187b585d', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «ركبَ عليٌّ الدرّاجةَ في الحديقة». مَن ركبَ الدرّاجة؟', '[{"id":"a","text":"الدرّاجة"},{"id":"b","text":"الحديقة"},{"id":"c","text":"عليّ"},{"id":"d","text":"سعيد"}]'::jsonb, 'c', 'الذي ركبَ هو عليّ. الفخّ الشائع هو اختيار «الدرّاجة» لأنّها مذكورة؛ لكنّ الدرّاجةَ هي المركوبة، وعليٌّ هو الراكب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('853974ec-050e-5511-b78b-560482c33357', 'feb6daf0-f54c-5b55-b3aa-fe427b510771', 'اِستمعتُ إلى هذه الجملة: «نزلَ المطرُ، ففتحَ سعيدٌ المظلّة». ماذا فعلَ سعيد؟', '[{"id":"a","text":"فتحَ المظلّة"},{"id":"b","text":"أغلقَ الباب"},{"id":"c","text":"نامَ في البيت"},{"id":"d","text":"ركبَ الدرّاجة"}]'::jsonb, 'a', 'لمّا نزلَ المطر، فتحَ سعيدٌ المظلّة. فالفعلُ الذي قامَ به سعيدٌ هو فتحُ المظلّة، وهو جوابُ «ماذا فعل؟».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', '⭐⭐ تمرين مراجعة: أُنصِتُ وأفهم', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('166213f1-4280-5b0f-8dc6-fcda9b47f50b', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «البِنتُ تقرأُ كتابًا». ماذا تقرأُ البِنت؟', '[{"id":"a","text":"صورة"},{"id":"b","text":"رسالة"},{"id":"c","text":"كتابًا"},{"id":"d","text":"جريدة"}]'::jsonb, 'c', 'في الجملة «البِنتُ تقرأُ كتابًا»، الشيءُ المقروء هو الكتاب، فجوابُ «ماذا تقرأ؟» هو كتابًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3074339-2258-5eeb-b284-c52ed01533a9', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «طارَ العصفورُ إلى العشّ». أين طارَ العصفور؟', '[{"id":"a","text":"إلى العشّ"},{"id":"b","text":"إلى الماء"},{"id":"c","text":"إلى البيت"},{"id":"d","text":"إلى المدرسة"}]'::jsonb, 'a', 'في الجملة «طارَ العصفورُ إلى العشّ», المكانُ هو العشّ، فجوابُ «أين طار؟» هو إلى العشّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcbc0eb2-f1c5-5d8c-8369-c4e631a3c52e', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «يشربُ الجدُّ القهوة». مَن يشربُ القهوة؟', '[{"id":"a","text":"الوَلَد"},{"id":"b","text":"الجدّ"},{"id":"c","text":"البِنت"},{"id":"d","text":"الأمّ"}]'::jsonb, 'b', 'في الجملة «يشربُ الجدُّ القهوة»، الذي يشربُ هو الجدّ، فجوابُ «مَن يشرب؟» هو الجدّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('376ed589-92f9-5adc-9c1a-99a7636950d8', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «الوَلَدُ يأكلُ تُفّاحة». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'الجملةُ تتحدّثُ عن أكلِ تُفّاحة، والصورةُ المناسبةُ هي صورةُ التُّفّاحة (د). أمّا (أ) سمكة و(ب) شمس و(ج) قطرةُ ماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1dd53d1b-00a3-5110-a77e-65d36a8e6fa2', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «خرجتِ البِنتُ من البيتِ إلى المدرسة». من أين خرجتِ البِنت؟', '[{"id":"a","text":"من السوق"},{"id":"b","text":"من الحديقة"},{"id":"c","text":"من البيت"},{"id":"d","text":"من المدرسة"}]'::jsonb, 'c', 'خرجتِ البِنتُ من البيتِ إلى المدرسة، فمكانُ الخروج هو البيت. الفخّ الشائع هو اختيار «المدرسة»؛ لكنّها مكانُ الوصول لا الخروج.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('642ff382-1ec0-5268-bf77-a5fdfea5b9bb', '6db1e729-92bd-58cb-acf9-b3b5a5fa0749', 'اِستمعتُ إلى هذه الجملة: «لعبَ الطفلُ ثمّ نام». ماذا حدثَ بعدَ اللعب؟', '[{"id":"a","text":"نامَ الطفل"},{"id":"b","text":"أكلَ الطفل"},{"id":"c","text":"خرجَ الطفل"},{"id":"d","text":"قرأَ الطفل"}]'::jsonb, 'a', 'كلمة «ثمّ» تدلُّ على الترتيب: لعبَ الطفلُ أوّلاً ثمّ نام. فالذي حدثَ بعدَ اللعب هو النوم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d085a744-b762-5d86-9572-c90d9fdf1445', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الإصغاء', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67a92767-18ab-50ff-a001-ab75016b0ee2', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «السمكةُ تسبحُ في الماء». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'الجملةُ عن سمكةٍ تسبح، والصورةُ المناسبةُ هي السمكة (ب). الفخّ الشائع هو اختيار قطرةِ الماء (د) لأنّ الجملةَ ذكرتِ الماء؛ لكنّ المطلوبَ صورةُ السمكة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5233d09d-6fa3-5a36-b6f2-2cde1ad3bff5', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «الشمسُ طالعةٌ في السماء». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"}]'::jsonb, 'd', 'الجملةُ عن الشمسِ الطالعة، والصورةُ المناسبةُ هي الشمس (د). أمّا (أ) تفّاحة و(ب) قطرةُ ماء و(ج) سمكة، فلا تناسبُ الجملة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a130a15-3cf2-51ad-b9e0-dd28e623abb9', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «أكلَ الوَلَدُ الخبزَ ثمّ شربَ الماء». ما الذي حدثَ أخيرًا؟', '[{"id":"a","text":"شربَ الماء"},{"id":"b","text":"أكلَ الخبز"},{"id":"c","text":"نامَ الوَلَد"},{"id":"d","text":"لعبَ بالكُرة"}]'::jsonb, 'a', 'كلمة «ثمّ» ترتّبُ الحدثين: أكلَ الخبزَ أوّلاً ثمّ شربَ الماء. فالذي حدثَ أخيرًا هو شربُ الماء. الفخّ الشائع هو اختيار «أكلَ الخبز» لأنّه ذُكِر أوّلاً.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12a36e10-7ffc-515a-b144-bbdb65bf77d6', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «طاردتِ القِطّةُ الفأر». مَن طاردَ الآخر؟', '[{"id":"a","text":"الفأرُ طاردَ القِطّة"},{"id":"b","text":"الفأرُ طاردَ الكلب"},{"id":"c","text":"القِطّةُ طاردتِ الفأر"},{"id":"d","text":"الكلبُ طاردَ القِطّة"}]'::jsonb, 'c', 'في الجملة الفاعلُ هو القِطّة، والمفعولُ هو الفأر، فالقِطّةُ طاردتِ الفأر. الفخّ الشائع هو قلبُ الفاعلِ والمفعول واختيار «الفأرُ طاردَ القِطّة».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cb491ef-3d25-590d-bc3e-a0bd53983a88', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «وضعتِ الأمُّ التُّفّاحةَ في السلّة فأكلها الوَلَد». ماذا أكلَ الوَلَد؟', '[{"id":"a","text":"السلّة"},{"id":"b","text":"التُّفّاحة"},{"id":"c","text":"الخبز"},{"id":"d","text":"الموزة"}]'::jsonb, 'b', 'الأمُّ وضعتِ التُّفّاحةَ في السلّة، فأكلَ الوَلَدُ التُّفّاحة. الفخّ الشائع هو اختيار «السلّة» لأنّها مذكورة؛ لكنّها المكانُ لا المأكول.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab27aaea-0db8-51aa-b0f0-9f958729aa07', 'd085a744-b762-5d86-9572-c90d9fdf1445', 'اِستمعتُ إلى هذه الجملة: «الوَلَدُ يشربُ الماء». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"}]'::jsonb, 'c', 'الجملةُ عن شربِ الماء، والصورةُ المناسبةُ هي قطرةُ الماء (ج). أمّا (أ) تفّاحة و(ب) شمس و(د) سمكة، فلا تدلُّ على شربِ الماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'e36f7197-1861-5172-901e-d0621445df55', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للإصغاء', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45002c85-4c98-5d64-821f-b11df89e1e2e', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «الأمُّ تطبخُ الطعام». مَن تطبخُ الطعام؟', '[{"id":"a","text":"البِنت"},{"id":"b","text":"الأمّ"},{"id":"c","text":"الجدّ"},{"id":"d","text":"الوَلَد"}]'::jsonb, 'b', 'في الجملة «الأمُّ تطبخُ الطعام»، الذي تطبخُ هي الأمّ، فجوابُ «مَن تطبخ؟» هو الأمّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94a798af-b5f0-5dea-a2a8-3b9b59f767d6', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «نامَ الطفلُ في السرير». أين نامَ الطفل؟', '[{"id":"a","text":"في الحديقة"},{"id":"b","text":"على الكرسيّ"},{"id":"c","text":"تحتَ الطاولة"},{"id":"d","text":"في السرير"}]'::jsonb, 'd', 'في الجملة «نامَ الطفلُ في السرير»، المكانُ هو السرير، فجوابُ «أين نام؟» هو في السرير.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1714f76d-b760-5ebf-a32e-fc6254643759', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «يقطفُ الفلّاحُ التُّفّاح». ماذا يقطفُ الفلّاح؟', '[{"id":"a","text":"التُّفّاح"},{"id":"b","text":"الزهور"},{"id":"c","text":"الخبز"},{"id":"d","text":"الحطب"}]'::jsonb, 'a', 'في الجملة «يقطفُ الفلّاحُ التُّفّاح», الشيءُ المقطوف هو التُّفّاح، فجوابُ «ماذا يقطف؟» هو التُّفّاح.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3143e46-1f58-5969-9946-7420b3b69aa5', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «التُّفّاحةُ على الطاولة». أيّ صورةٍ تناسبُ الجملة؟', '[{"id":"a","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 30 q-8 14 -8 24 q0 14 16 14 q16 0 16 -14 q0 -10 -8 -24 q-4 -8 -8 -8 q-4 0 -8 8 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'الجملةُ تتحدّثُ عن تُفّاحة، والصورةُ المناسبةُ هي التُّفّاحة (ج). أمّا (أ) سمكة و(ب) شمس و(د) قطرةُ ماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13c42b69-7ec7-5ac0-8b76-c183c27a12ea', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «دخلَ سعيدٌ القسمَ ثمّ جلس». ما الذي حدثَ أوّلاً؟', '[{"id":"a","text":"دخلَ القسم"},{"id":"b","text":"جلسَ سعيد"},{"id":"c","text":"كتبَ الدرس"},{"id":"d","text":"خرجَ من القسم"}]'::jsonb, 'a', 'كلمة «ثمّ» تدلُّ على الترتيب: دخلَ سعيدٌ القسمَ أوّلاً ثمّ جلس. فالذي حدثَ أوّلاً هو دخولُ القسم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac5f0136-0e5f-5cb2-acef-9e2422e1eeee', '24e517ed-a489-56f7-8ffb-143ed8e03eeb', 'اِستمعتُ إلى هذه الجملة: «حملتِ البِنتُ المظلّةَ لأنّ المطرَ ينزل». لماذا حملتِ البِنتُ المظلّة؟', '[{"id":"a","text":"لأنّ الشمسَ طالعة"},{"id":"b","text":"لأنّها ذاهبةٌ إلى المدرسة"},{"id":"c","text":"لأنّ المطرَ ينزل"},{"id":"d","text":"لأنّها تلعبُ بالكُرة"}]'::jsonb, 'c', 'الجملةُ تذكرُ السببَ بـ «لأنّ»: حملتِ البِنتُ المظلّةَ لأنّ المطرَ ينزل. فالسببُ هو نزولُ المطر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d1cc6431-2d53-53ac-a25d-bdb4acdf23d4', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a793922-46fb-53cf-95c6-b24f272ab737', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><ellipse cx="60" cy="78" rx="30" ry="26" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="44" r="22" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M42 30 l-6 -16 l16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M78 30 l6 -16 l-16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="52" cy="44" r="3" fill="#1f2937" stroke="none"/><circle cx="68" cy="44" r="3" fill="#1f2937" stroke="none"/><path d="M60 50 l-4 5 l8 0 z" fill="#f97316" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="52" x2="24" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="56" x2="24" y2="58" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="52" x2="96" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="56" x2="96" y2="58" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"عصفور"},{"id":"b","text":"سمكة"},{"id":"c","text":"قطّة"},{"id":"d","text":"كرة"}]'::jsonb, 'c', 'في الصورة قطّةٌ لها أُذنان وشاربان، فاسمها «قطّة».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c53da46c-b79a-5047-b146-8929187e8dde', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', 'ماذا أقول عندما أدخل القسم في الصباح؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"تصبح على خير"},{"id":"c","text":"مع السلامة"},{"id":"d","text":"إلى اللقاء"}]'::jsonb, 'a', 'عند الدخول في الصباح أُحيّي وأقول «صباح الخير». أمّا «تصبح على خير» فتُقال عند النوم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5578aed5-ded1-5392-8f07-08c7a0b2cd47', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', 'أيّ كلمةٍ تُكمل الجملة: «القطّة ...»؟', '[{"id":"a","text":"تطير"},{"id":"b","text":"تموء"},{"id":"c","text":"تسبح"},{"id":"d","text":"تقرأ"}]'::jsonb, 'b', 'صوت القطّة هو المُواء، فنقول «القطّة تموء». الطيران للعصفور، والسباحة للسمكة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4148f6c3-6b58-5207-8d41-9787be0e89e2', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', 'ما لون الشمس؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"أزرق"},{"id":"b","text":"أخضر"},{"id":"c","text":"أسود"},{"id":"d","text":"أصفر"}]'::jsonb, 'd', 'الشمس في الصورة صفراء، فلونها «أصفر». الكلمة التي تصف الشيء قد تدلّ على لونه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44014185-c08b-5b56-a454-1903af61fcc1', 'd1cc6431-2d53-53ac-a25d-bdb4acdf23d4', 'أعطاك صديقك هديّة. ماذا تقول له؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"شكرًا"},{"id":"c","text":"آسف"},{"id":"d","text":"مع السلامة"}]'::jsonb, 'b', 'عندما يُعطيك أحدٌ شيئًا تقول «شكرًا»، فهي كلمة الذوق المناسبة عند تلقّي الهديّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('41c45fda-e384-5575-ab75-5da4f020007d', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', '⭐ تمرين: أُسمّي وأُحيّي', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81f9bcea-d995-5ea3-ad54-7019681a960d', '41c45fda-e384-5575-ab75-5da4f020007d', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"قطّة"},{"id":"b","text":"سمكة"},{"id":"c","text":"عصفور"},{"id":"d","text":"وردة"}]'::jsonb, 'b', 'في الصورة سمكةٌ لها ذيلٌ وتعيش في الماء، فاسمها «سمكة».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31da48d2-38fc-5b44-9357-ed6f2d477ffc', '41c45fda-e384-5575-ab75-5da4f020007d', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><ellipse cx="60" cy="40" rx="12" ry="16" fill="#ef4444"/><ellipse cx="40" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="80" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="48" cy="66" rx="12" ry="16" fill="#ef4444"/><ellipse cx="72" cy="66" rx="12" ry="16" fill="#ef4444"/></g><circle cx="60" cy="54" r="11" fill="#facc15" stroke="#1f2937" stroke-width="3"/><line x1="60" y1="64" x2="60" y2="108" stroke="#16a34a" stroke-width="4"/><path d="M60 86 q16 -2 22 -14 q-16 0 -22 14 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"كرة"},{"id":"b","text":"شمس"},{"id":"c","text":"وردة"},{"id":"d","text":"سمكة"}]'::jsonb, 'c', 'في الصورة وردةٌ لها أوراقٌ وساقٌ خضراء، فاسمها «وردة».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae2ab424-2290-509a-a268-dd729d6a3f7e', '41c45fda-e384-5575-ab75-5da4f020007d', 'ماذا أقول عندما أُقابل صديقي في الصباح؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"تصبح على خير"},{"id":"c","text":"مع السلامة"},{"id":"d","text":"آسف"}]'::jsonb, 'a', 'تحيّة الصباح هي «صباح الخير». أمّا «تصبح على خير» فتُقال عند النوم في الليل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e4388ef-8453-583f-b68b-be08fd352ccd', '41c45fda-e384-5575-ab75-5da4f020007d', 'أيّ كلمةٍ تُكمل الجملة: «العصفور ...»؟', '[{"id":"a","text":"يموء"},{"id":"b","text":"يسبح"},{"id":"c","text":"يقرأ"},{"id":"d","text":"يطير"}]'::jsonb, 'd', 'العصفور له جناحان فهو «يطير». المُواء للقطّة، والسباحة للسمكة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eeb329ab-8be3-5a65-912d-a7e3243dc82f', '41c45fda-e384-5575-ab75-5da4f020007d', 'ما لون هذه التفّاحة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"أزرق"},{"id":"b","text":"أحمر"},{"id":"c","text":"أصفر"},{"id":"d","text":"أبيض"}]'::jsonb, 'b', 'التفّاحة في الصورة حمراء، فلونها «أحمر». هذه كلمةٌ تصف لون الشيء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1008a12f-dabd-5cd2-8def-2e23af503b83', '41c45fda-e384-5575-ab75-5da4f020007d', 'ساعدك صديقك ثمّ ودّعك. ماذا تقول له؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"تموء"},{"id":"c","text":"نَم"},{"id":"d","text":"شكرًا، مع السلامة"}]'::jsonb, 'd', 'تشكره على مساعدته ثمّ تودّعه، فتقول «شكرًا، مع السلامة». هاتان كلمتا ذوقٍ وتحيّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2120b03-33d8-5789-b20d-5d009b79298a', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الكلمات', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82b6fc99-6b45-5dd6-8da3-e7701274008e', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><ellipse cx="58" cy="64" rx="28" ry="22" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><circle cx="84" cy="48" r="14" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><path d="M94 46 l16 -4 l-14 12 z" fill="#f59e0b" stroke="#1f2937" stroke-width="2"/><circle cx="88" cy="45" r="3" fill="#1f2937" stroke="none"/><path d="M34 60 q-18 -6 -26 6 q16 4 26 0 z" fill="#0ea5e9" stroke="#1f2937" stroke-width="3"/><path d="M50 78 l-4 16 M66 78 l4 16" stroke="#f59e0b" stroke-width="3" stroke-linecap="round"/></svg>', '[{"id":"a","text":"سمكة"},{"id":"b","text":"قطّة"},{"id":"c","text":"عصفور"},{"id":"d","text":"فراشة"}]'::jsonb, 'c', 'في الصورة عصفورٌ له جناحٌ ومنقارٌ وذيل، فاسمه «عصفور». الفخّ الشائع هو الخلط مع الفراشة؛ لكنّ المنقار والرّجلين علامة العصفور.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f67de9ae-a39c-5def-9d9c-8e1fc4db6d8e', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'حان وقت النوم في الليل. ماذا تقول لأهلك؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"تصبحون على خير"},{"id":"c","text":"شكرًا"},{"id":"d","text":"مع السلامة"}]'::jsonb, 'b', 'عند النوم في الليل تقول «تصبحون على خير». الفخّ الشائع هو قول «صباح الخير»، لكنّها تحيّة الصباح لا الليل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dad2e38-b243-5740-bd9f-cb33b50fd038', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'أيّ كلمةٍ تُكمل الجملة: «السمكة ...»؟', '[{"id":"a","text":"تسبح"},{"id":"b","text":"تطير"},{"id":"c","text":"تموء"},{"id":"d","text":"تمشي"}]'::jsonb, 'a', 'السمكة تعيش في الماء فهي «تسبح». الفخّ الشائع هو قول «تطير»، لكنّ الطيران للعصفور لا للسمكة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3e70373-51c9-52c9-a5b2-700e20869970', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'الفيل ضخمٌ والفأر صغير. أيّ كلمةٍ تصف الفيل؟', '[{"id":"a","text":"صغير"},{"id":"b","text":"أصفر"},{"id":"c","text":"سريع"},{"id":"d","text":"كبير"}]'::jsonb, 'd', 'الفيل ضخمٌ في حجمه فنصفه بأنّه «كبير». الفخّ الشائع هو اختيار «صغير»، وهي كلمةٌ تصف الفأر لا الفيل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('335be1a3-d794-5952-992e-d724d7b7b766', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="28" y1="28" x2="37" y2="37"/><line x1="83" y1="83" x2="92" y2="92"/><line x1="92" y1="28" x2="83" y2="37"/><line x1="37" y1="83" x2="28" y2="92"/></g></svg>', '[{"id":"a","text":"قمر"},{"id":"b","text":"كرة"},{"id":"c","text":"شمس"},{"id":"d","text":"وردة"}]'::jsonb, 'c', 'في الصورة شمسٌ صفراء لها أشعّة، فاسمها «شمس». الفخّ الشائع هو قول «قمر»، لكنّ الأشعّة الصفراء حول القرص علامة الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73c576e0-813d-5c6b-b511-6b50916d715b', 'f2120b03-33d8-5789-b20d-5d009b79298a', 'دفعتَ صديقك دون قصدٍ فوقع. ماذا تقول له؟', '[{"id":"a","text":"آسف"},{"id":"b","text":"صباح الخير"},{"id":"c","text":"شكرًا"},{"id":"d","text":"مرحبًا"}]'::jsonb, 'a', 'عندما تُخطئ في حقّ غيرك تعتذر وتقول «آسف». الفخّ الشائع هو قول «شكرًا»، لكنّها تُقال على معروفٍ لا على خطأ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fb0fb2ed-687a-57f5-8132-dd60802f20a8', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', '⭐⭐ تمرين مراجعة: أُسمّي وأصف وأتكلّم', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c792c926-079e-5089-9357-28cdd32b940f', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q2 -14 16 -18" fill="none" stroke="#1f2937" stroke-width="3"/><path d="M60 40 q-6 -10 -18 -8" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"تفّاحة"},{"id":"b","text":"كرة"},{"id":"c","text":"شمس"},{"id":"d","text":"وردة"}]'::jsonb, 'a', 'في الصورة تفّاحةٌ حمراء لها ورقةٌ خضراء، فاسمها «تفّاحة».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbb7a41c-f7be-5835-948d-56a0e9f708f2', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'ماذا أقول لمعلّمتي عند دخول القسم صباحًا؟', '[{"id":"a","text":"مع السلامة"},{"id":"b","text":"تصبحين على خير"},{"id":"c","text":"آسف"},{"id":"d","text":"صباح الخير"}]'::jsonb, 'd', 'تحيّة الصباح عند الدخول هي «صباح الخير». أمّا «مع السلامة» فتُقال عند المغادرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dffd03a3-3fba-5bad-abdf-44f76481bdbd', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'أيّ كلمةٍ تُكمل الجملة: «التلميذ ...»؟', '[{"id":"a","text":"يموء"},{"id":"b","text":"يطير"},{"id":"c","text":"يقرأ"},{"id":"d","text":"يسبح"}]'::jsonb, 'c', 'التلميذ يفتح كتابه فهو «يقرأ». المُواء للقطّة، والطيران للعصفور.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40b29a89-b7b3-57f1-bd92-c6d10afa4f92', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'ما لون قطرة الماء؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M60 24 q-14 24 -14 40 q0 22 28 22 q28 0 28 -22 q0 -16 -14 -40 q-7 -12 -14 -12 q-7 0 -14 12 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"أحمر"},{"id":"b","text":"أزرق"},{"id":"c","text":"أصفر"},{"id":"d","text":"أخضر"}]'::jsonb, 'b', 'قطرة الماء في الصورة زرقاء، فلونها «أزرق». هذه كلمةٌ تصف لون الشيء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c725610-5a73-5ac2-b019-86e6a87cd502', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'أعطتك جدّتك حلوى. ماذا تقول لها؟', '[{"id":"a","text":"آسف"},{"id":"b","text":"تصبحين على خير"},{"id":"c","text":"صباح الخير"},{"id":"d","text":"شكرًا"}]'::jsonb, 'd', 'عندما يُعطيك أحدٌ شيئًا تقول «شكرًا». هي كلمة الذوق المناسبة عند تلقّي الهديّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35b9ec97-dc7d-5d35-b55a-9c20036f6c5d', 'fb0fb2ed-687a-57f5-8132-dd60802f20a8', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><ellipse cx="60" cy="78" rx="30" ry="26" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="60" cy="44" r="22" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M42 30 l-6 -16 l16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><path d="M78 30 l6 -16 l-16 8 z" fill="#fbbf24" stroke="#1f2937" stroke-width="3"/><circle cx="52" cy="44" r="3" fill="#1f2937" stroke="none"/><circle cx="68" cy="44" r="3" fill="#1f2937" stroke="none"/><path d="M60 50 l-4 5 l8 0 z" fill="#f97316" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="52" x2="24" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="40" y1="56" x2="24" y2="58" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="52" x2="96" y2="49" stroke="#1f2937" stroke-width="2"/><line x1="80" y1="56" x2="96" y2="58" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"قطّة"},{"id":"b","text":"عصفور"},{"id":"c","text":"سمكة"},{"id":"d","text":"كلب"}]'::jsonb, 'a', 'في الصورة قطّةٌ لها أُذنان مدبّبتان وشاربان، فاسمها «قطّة».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b51e3d11-54d8-5161-83b0-2ad100d04021', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الكلام الأكبر', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb2d8086-c421-511c-af4e-73357b77fef1', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'أيّ صورةٍ نسمّيها «سمكة»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"78\" rx=\"30\" ry=\"26\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"60\" cy=\"44\" r=\"22\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M42 30 l-6 -16 l16 8 z\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M78 30 l6 -16 l-16 8 z\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"52\" cy=\"44\" r=\"3\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"68\" cy=\"44\" r=\"3\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#1f2937\" stroke-width=\"3\"><ellipse cx=\"60\" cy=\"40\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"40\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"80\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"48\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"72\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/></g><circle cx=\"60\" cy=\"54\" r=\"11\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"60\" y1=\"64\" x2=\"60\" y2=\"106\" stroke=\"#16a34a\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'b', 'الصورة (ب) سمكةٌ لها ذيل، فنسمّيها «سمكة». أمّا (أ) فقطّة، و(ج) شمس، و(د) وردة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7c4b40b-dfff-5104-8d67-bb7fd8cfb5d5', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'أيّ صورةٍ نسمّيها «شمس»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M40 44 q20 -16 40 0 q14 12 8 36 q-6 22 -28 26 q-22 -4 -28 -26 q-6 -24 8 -36 z\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 40 q2 -14 16 -18\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 140 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 44 l24 16 l-24 16 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"54\" r=\"4\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#1f2937\" stroke-width=\"3\"><ellipse cx=\"60\" cy=\"40\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"40\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"80\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"48\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"72\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/></g><circle cx=\"60\" cy=\"54\" r=\"11\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"60\" y1=\"64\" x2=\"60\" y2=\"106\" stroke=\"#16a34a\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"60\" cy=\"60\" r=\"24\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"4\" stroke-linecap=\"round\"><line x1=\"60\" y1=\"16\" x2=\"60\" y2=\"28\"/><line x1=\"60\" y1=\"92\" x2=\"60\" y2=\"104\"/><line x1=\"16\" y1=\"60\" x2=\"28\" y2=\"60\"/><line x1=\"92\" y1=\"60\" x2=\"104\" y2=\"60\"/><line x1=\"28\" y1=\"28\" x2=\"37\" y2=\"37\"/><line x1=\"83\" y1=\"83\" x2=\"92\" y2=\"92\"/><line x1=\"92\" y1=\"28\" x2=\"83\" y2=\"37\"/><line x1=\"37\" y1=\"83\" x2=\"28\" y2=\"92\"/></g></svg>"}]'::jsonb, 'd', 'الصورة (د) قرصٌ أصفر له أشعّة، فنسمّيها «شمس». أمّا (أ) فتفّاحة، و(ب) سمكة، و(ج) وردة. الفخّ الشائع هو الخلط بين الشمس والوردة الصفراء الوسط؛ لكنّ الأشعّة علامة الشمس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d789efa1-5841-5612-a909-44ab689345fb', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'أيّ صورةٍ نسمّيها «وردة»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#1f2937\" stroke-width=\"3\"><ellipse cx=\"60\" cy=\"40\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"40\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"80\" cy=\"50\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"48\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/><ellipse cx=\"72\" cy=\"66\" rx=\"12\" ry=\"16\" fill=\"#ef4444\"/></g><circle cx=\"60\" cy=\"54\" r=\"11\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"60\" y1=\"64\" x2=\"60\" y2=\"106\" stroke=\"#16a34a\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"78\" rx=\"30\" ry=\"26\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"60\" cy=\"44\" r=\"22\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M42 30 l-6 -16 l16 8 z\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M78 30 l6 -16 l-16 8 z\" fill=\"#fbbf24\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"52\" cy=\"44\" r=\"3\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"68\" cy=\"44\" r=\"3\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M60 24 q-14 24 -14 40 q0 22 28 22 q28 0 28 -22 q0 -16 -14 -40 q-7 -12 -14 -12 q-7 0 -14 12 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 120\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"58\" cy=\"64\" rx=\"28\" ry=\"22\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"84\" cy=\"48\" r=\"14\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M94 46 l16 -4 l-14 12 z\" fill=\"#f59e0b\" stroke=\"#1f2937\" stroke-width=\"2\"/><circle cx=\"88\" cy=\"45\" r=\"3\" fill=\"#1f2937\" stroke=\"none\"/></svg>"}]'::jsonb, 'a', 'الصورة (أ) زهرةٌ لها أوراقٌ وساقٌ خضراء، فنسمّيها «وردة». أمّا (ب) فقطّة، و(ج) قطرة ماء، و(د) عصفور.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04192f7f-2f62-51bc-b7f7-efd31f7b32e5', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'أيّ جملةٍ صحيحةٌ تمامًا؟', '[{"id":"a","text":"العصفور يسبح في الماء"},{"id":"b","text":"السمكة تطير في السماء"},{"id":"c","text":"القطّة تموء في البيت"},{"id":"d","text":"التلميذ يموء في القسم"}]'::jsonb, 'c', 'صوت القطّة هو المُواء، فجملة «القطّة تموء في البيت» صحيحة. الفخّ الشائع هو ربط الفعل بغير صاحبه: العصفور يطير لا يسبح، والسمكة تسبح لا تطير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09596525-59bd-5272-bccc-d37d23af4033', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'تخرج من المدرسة آخر النهار وتودّع معلّمتك. ماذا تقول؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"شكرًا على الهديّة"},{"id":"c","text":"آسف"},{"id":"d","text":"مع السلامة"}]'::jsonb, 'd', 'عند المغادرة والوداع تقول «مع السلامة». الفخّ الشائع هو قول «صباح الخير»، لكنّها تحيّة الدخول لا الوداع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cb22a01-978b-51ea-8d9e-5d148fb76775', 'b51e3d11-54d8-5161-83b0-2ad100d04021', 'الفيل ضخمٌ والنملة دقيقة. أيّ زوجٍ من الكلمات يصفهما على الترتيب؟', '[{"id":"a","text":"صغير ثمّ كبير"},{"id":"b","text":"كبير ثمّ صغير"},{"id":"c","text":"أحمر ثمّ أزرق"},{"id":"d","text":"كبير ثمّ كبير"}]'::jsonb, 'b', 'الفيل ضخمٌ فهو «كبير»، والنملة دقيقةٌ فهي «صغيرة»، فالترتيب «كبير ثمّ صغير». الفخّ الشائع هو عكس الكلمتين؛ والحجم لا اللون هو المطلوب هنا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('96eec3b7-60df-5878-a02b-6dd44655ec82', '03df7071-25b7-5d48-8733-ee0344b7315a', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للكلام', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cc6f213-d720-5aeb-8f67-038f0c2a8ef2', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><ellipse cx="60" cy="40" rx="12" ry="16" fill="#ef4444"/><ellipse cx="40" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="80" cy="50" rx="12" ry="16" fill="#ef4444"/><ellipse cx="48" cy="66" rx="12" ry="16" fill="#ef4444"/><ellipse cx="72" cy="66" rx="12" ry="16" fill="#ef4444"/></g><circle cx="60" cy="54" r="11" fill="#facc15" stroke="#1f2937" stroke-width="3"/><line x1="60" y1="64" x2="60" y2="108" stroke="#16a34a" stroke-width="4"/><path d="M60 86 q16 -2 22 -14 q-16 0 -22 14 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"شمس"},{"id":"b","text":"تفّاحة"},{"id":"c","text":"وردة"},{"id":"d","text":"سمكة"}]'::jsonb, 'c', 'في الصورة وردةٌ لها أوراقٌ وساقٌ خضراء وورقة، فاسمها «وردة».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f28c2c35-f76d-53c1-9449-83fbf6ccc0c3', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'ماذا تقول لأصدقائك عند دخول الملعب صباحًا؟', '[{"id":"a","text":"صباح الخير"},{"id":"b","text":"تصبحون على خير"},{"id":"c","text":"مع السلامة"},{"id":"d","text":"آسف"}]'::jsonb, 'a', 'تحيّة الصباح هي «صباح الخير». أمّا «تصبحون على خير» فتُقال عند النوم في الليل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e003702e-1024-5e71-aed2-b8998143e8e5', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'أيّ كلمةٍ تُكمل الجملة: «العصفور ...»؟', '[{"id":"a","text":"يموء"},{"id":"b","text":"يسبح"},{"id":"c","text":"يقرأ"},{"id":"d","text":"يطير"}]'::jsonb, 'd', 'العصفور له جناحان فهو «يطير». المُواء للقطّة، والسباحة للسمكة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcca4b18-a3fa-53eb-95c1-962ec7ad815e', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'ما لون قطرة الماء؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><path d="M60 24 q-14 24 -14 40 q0 22 28 22 q28 0 28 -22 q0 -16 -14 -40 q-7 -12 -14 -12 q-7 0 -14 12 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"أحمر"},{"id":"b","text":"أزرق"},{"id":"c","text":"أصفر"},{"id":"d","text":"أخضر"}]'::jsonb, 'b', 'قطرة الماء في الصورة زرقاء، فلونها «أزرق». الكلمة التي تصف الشيء قد تدلّ على لونه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a5f95ef-0d69-57c3-a8be-d200354d1800', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'ما اسم هذه الصورة؟ <svg viewBox="0 0 140 120" xmlns="http://www.w3.org/2000/svg"><path d="M24 60 q26 -30 70 -16 q22 8 22 16 q0 8 -22 16 q-44 14 -70 -16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M94 44 l24 16 l-24 16 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="54" r="4" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"قطّة"},{"id":"b","text":"عصفور"},{"id":"c","text":"سمكة"},{"id":"d","text":"وردة"}]'::jsonb, 'c', 'في الصورة سمكةٌ لها ذيلٌ تعيش في الماء، فاسمها «سمكة». الفخّ الشائع هو الخلط مع العصفور؛ لكنّ الذيل وغياب الجناح علامة السمكة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e7f15a0-ff0c-587a-8d3d-1c1bd31cb736', '96eec3b7-60df-5878-a02b-6dd44655ec82', 'ساعدك زميلك في حمل حقيبتك. ماذا تقول له؟', '[{"id":"a","text":"شكرًا"},{"id":"b","text":"صباح الخير"},{"id":"c","text":"تصبح على خير"},{"id":"d","text":"آسف"}]'::jsonb, 'a', 'عندما يصنع أحدٌ لك معروفًا تشكره وتقول «شكرًا». الفخّ الشائع هو قول «آسف»، لكنّها تُقال عند الاعتذار لا عند الشكر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5ee41667-dfc3-5685-9e7b-883110426278', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b2e3a32-65a2-57eb-9e3f-b73677622096', '5ee41667-dfc3-5685-9e7b-883110426278', 'كم كلمةً في هذه الجملة: «البنتُ تقرأ»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'a', 'الجملةُ «البنتُ تقرأ» فيها كلمتان بينهما فراغٌ واحد: البنتُ، تقرأ. فعددُ كلماتها 2.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcaa616e-7775-588f-92c8-3835802611be', '5ee41667-dfc3-5685-9e7b-883110426278', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="78" cy="84" rx="40" ry="26" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="58" r="22" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M28 42 l-6 -16 l16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 42 l6 -16 l-16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="38" cy="56" r="3" fill="#1f2937" stroke="none"/><circle cx="52" cy="56" r="3" fill="#1f2937" stroke="none"/><path d="M118 96 h44 v-22 h-44 z" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><path d="M120 76 q20 -10 40 0" fill="none" stroke="#38bdf8" stroke-width="6"/></svg>', '[{"id":"a","text":"الولدُ يلعبُ بالكرة"},{"id":"b","text":"العصفورُ يطيرُ في السّماء"},{"id":"c","text":"القطّةُ تشربُ الحليبَ"},{"id":"d","text":"الأمُّ تطبخُ الطّعامَ"}]'::jsonb, 'c', 'في الصورة قطّةٌ أمام وعاءٍ فيه حليب، فالجملةُ المناسبة هي «القطّةُ تشربُ الحليبَ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15b1af9a-68b2-5ed8-a7ab-3cd845e9a36b', '5ee41667-dfc3-5685-9e7b-883110426278', 'كم كلمةً في هذه الجملة: «الطّفلُ يلعبُ بالكرة»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'أعدُّ الكلمات بين الفراغات: الطّفلُ، يلعبُ، بالكرة. فعددُ كلمات الجملة 3.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70a7eb0d-2621-5d53-ac97-4c89734bd93f', '5ee41667-dfc3-5685-9e7b-883110426278', 'ما الكلمةُ الناقصةُ في الجملة: «الولدُ ... التّفّاحةَ»؟', '[{"id":"a","text":"فوق"},{"id":"b","text":"كبيرة"},{"id":"c","text":"بيتٌ"},{"id":"d","text":"يأكلُ"}]'::jsonb, 'd', 'الجملةُ تحتاجُ فعلًا يدلُّ على ما يفعله الولد بالتّفّاحة، فنقول «الولدُ يأكلُ التّفّاحةَ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f27ffaf4-31cc-5a55-842e-06f9b73df29e', '5ee41667-dfc3-5685-9e7b-883110426278', 'في جملة «الشّمسُ فوق الدّار»، مَن فوق الدّار؟', '[{"id":"a","text":"الشّمس"},{"id":"b","text":"الدّار"},{"id":"c","text":"الولد"},{"id":"d","text":"القطّة"}]'::jsonb, 'a', 'الجملةُ تخبرنا أنّ الشّمسَ فوق الدّار، فالذي فوق الدّار هو الشّمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('02f95c48-e921-5e4f-9edc-a07b03fecaff', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', '⭐ تمرين: أقرأُ الجملةَ القصيرة', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c36d561-9357-5a99-966f-112b9c1f180a', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="78" cy="84" rx="40" ry="26" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="58" r="22" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M28 42 l-6 -16 l16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 42 l6 -16 l-16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="38" cy="56" r="3" fill="#1f2937" stroke="none"/><circle cx="52" cy="56" r="3" fill="#1f2937" stroke="none"/><path d="M118 96 h44 v-22 h-44 z" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><path d="M120 76 q20 -10 40 0" fill="none" stroke="#38bdf8" stroke-width="6"/></svg>', '[{"id":"a","text":"الطّفلُ يلعبُ بالكرة"},{"id":"b","text":"العصفورُ فوق الشّجرة"},{"id":"c","text":"القطّةُ تشربُ الحليبَ"},{"id":"d","text":"الأمُّ تطبخُ الطّعامَ"}]'::jsonb, 'c', 'في الصورة قطّةٌ أمام وعاءٍ فيه حليب، فالجملةُ المناسبة هي «القطّةُ تشربُ الحليبَ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd6dbd90-5f18-5d75-8917-545d2ebf2195', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'كم كلمةً في هذه الجملة: «الأمُّ تطبخ»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'a', 'الجملةُ «الأمُّ تطبخ» فيها كلمتان بينهما فراغٌ واحد: الأمُّ، تطبخ. فعددُ كلماتها 2.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49b06dde-002c-53e7-8623-bf4886966c0b', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="70" cy="40" r="16" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="56" x2="70" y2="92" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="66" x2="52" y2="82" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="66" x2="90" y2="80" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="92" x2="56" y2="116" stroke="#1f2937" stroke-width="3"/><line x1="70" y1="92" x2="84" y2="116" stroke="#1f2937" stroke-width="3"/><circle cx="128" cy="100" r="20" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><path d="M128 80 v40 M108 100 h40" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"القطّةُ تشربُ الحليبَ"},{"id":"b","text":"الشّمسُ فوق الدّار"},{"id":"c","text":"البنتُ تقرأُ الكتابَ"},{"id":"d","text":"الطّفلُ يلعبُ بالكرة"}]'::jsonb, 'd', 'في الصورة طفلٌ بجانبه كرةٌ حمراء، فالجملةُ المناسبة هي «الطّفلُ يلعبُ بالكرة».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c98f9865-7203-552a-8b7a-1dd467a94813', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'في جملة «القطّةُ تشربُ الحليبَ»، مَن يشربُ الحليبَ؟', '[{"id":"a","text":"الولد"},{"id":"b","text":"القطّة"},{"id":"c","text":"الأمّ"},{"id":"d","text":"العصفور"}]'::jsonb, 'b', 'الجملةُ تخبرنا أنّ القطّةَ تشربُ الحليبَ، فالذي يشربُ الحليبَ هو القطّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96eb2dd1-9975-5666-ad51-64b190b9c1ed', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'في جملة «الطّفلُ يلعبُ بالكرة»، ماذا يفعلُ الطّفل؟', '[{"id":"a","text":"ينامُ"},{"id":"b","text":"يأكلُ"},{"id":"c","text":"يلعبُ"},{"id":"d","text":"يشربُ"}]'::jsonb, 'c', 'الجملةُ تقول «يلعبُ بالكرة»، فالفعلُ الذي يفعلُه الطّفلُ هو «يلعبُ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d80b16e1-e6f8-5c00-bef0-32e361db7e3f', '02f95c48-e921-5e4f-9edc-a07b03fecaff', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="40" r="20" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="48" y1="8" x2="48" y2="18"/><line x1="14" y1="40" x2="24" y2="40"/><line x1="24" y1="20" x2="31" y2="27"/></g><path d="M104 116 v-44 l40 -26 l40 26 v44 z" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><path d="M100 74 l44 -28 l44 28" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><rect x="132" y="92" width="24" height="24" fill="#92400e" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"الطّفلُ يلعبُ بالكرة"},{"id":"b","text":"القطّةُ تشربُ الحليبَ"},{"id":"c","text":"البنتُ تقرأُ الكتابَ"},{"id":"d","text":"الشّمسُ فوق الدّار"}]'::jsonb, 'd', 'في الصورة شمسٌ في الأعلى ودارٌ تحتها، فالجملةُ المناسبة هي «الشّمسُ فوق الدّار».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الجملة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f9ae570-68b6-5c0f-979f-4cb5f34ee917', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'كم كلمةً في هذه الجملة: «العصفورُ يطيرُ فوق الشّجرة»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'c', 'أعدُّ الكلمات بين الفراغات: العصفورُ، يطيرُ، فوق، الشّجرة. فعددُ كلمات الجملة 4. الفخّ الشائع هو عدُّ الحروف بدل الكلمات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f8be5f9-01f4-5138-8e85-0711060f34c0', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><path d="M150 118 v-46" stroke="#92400e" stroke-width="8"/><ellipse cx="150" cy="58" rx="40" ry="32" fill="#22c55e" stroke="#1f2937" stroke-width="3"/><path d="M40 50 q12 -12 24 0 q10 -6 14 6 q12 2 6 12 l-52 0 q-8 -10 8 -18 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><circle cx="58" cy="52" r="3" fill="#1f2937" stroke="none"/><path d="M40 56 l-12 6 l12 4 z" fill="#f59e0b" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"العصفورُ يطيرُ فوق الشّجرة"},{"id":"b","text":"القطّةُ تشربُ الحليبَ"},{"id":"c","text":"الطّفلُ يلعبُ بالكرة"},{"id":"d","text":"الشّمسُ فوق الدّار"}]'::jsonb, 'a', 'في الصورة عصفورٌ يطيرُ بجانب شجرةٍ خضراء، فالجملةُ المناسبة هي «العصفورُ يطيرُ فوق الشّجرة».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c96874f-d8f3-5395-81a8-233c28b12802', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'ما الكلمةُ الناقصةُ في الجملة: «العصفورُ ... فوق الشّجرة»؟', '[{"id":"a","text":"كبيرٌ"},{"id":"b","text":"أخضرُ"},{"id":"c","text":"صغيرٌ"},{"id":"d","text":"يطيرُ"}]'::jsonb, 'd', 'الجملةُ تحتاجُ فعلًا يدلُّ على ما يفعله العصفور، فنقول «العصفورُ يطيرُ فوق الشّجرة». الفخّ الشائع اختيارُ صفةٍ مثل «كبيرٌ» بدل الفعل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('daf5e1f7-deff-53ca-a8bf-0d0970b7b81b', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'أيّ جملةٍ تصفُ هذه الصورة بدقّة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="78" cy="84" rx="40" ry="26" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="58" r="22" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M28 42 l-6 -16 l16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 42 l6 -16 l-16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="38" cy="56" r="3" fill="#1f2937" stroke="none"/><circle cx="52" cy="56" r="3" fill="#1f2937" stroke="none"/><path d="M118 96 h44 v-22 h-44 z" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><path d="M120 76 q20 -10 40 0" fill="none" stroke="#38bdf8" stroke-width="6"/></svg>', '[{"id":"a","text":"القطّةُ تأكلُ الحليبَ"},{"id":"b","text":"القطّةُ تشربُ الحليبَ"},{"id":"c","text":"الولدُ يشربُ الحليبَ"},{"id":"d","text":"القطّةُ تشربُ الماءَ"}]'::jsonb, 'b', 'القطّةُ تشربُ ولا تأكلُ الحليبَ، والشّاربُ قطّةٌ لا ولد، والمشروبُ حليبٌ، فالصحيح «القطّةُ تشربُ الحليبَ». الفخّ الشائع تبديلُ كلمةٍ واحدةٍ (الفعل أو مَن يفعل أو ماذا).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38db23ce-89f0-5d8f-8f39-8a2ca145e311', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'كم كلمةً في هذه الجملة: «الطّائرُ يطيرُ في السّماء»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'c', 'أعدُّ الكلمات بين الفراغات: الطّائرُ، يطيرُ، في، السّماء. فعددُ كلمات الجملة 4. الفخّ الشائع نسيانُ عدِّ الكلمة الصغيرة «في».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('610aedb1-85d7-545c-a330-b2424b0c3637', '3081f6b0-ce45-5cd7-ab2a-13f2725c93e0', 'صورةٌ فيها قطّةٌ تشربُ الحليبَ. أيّ جملةٍ صحيحةٌ لها؟', '[{"id":"a","text":"القطّةُ تشربُ الحليبَ"},{"id":"b","text":"الكلبُ يشربُ الحليبَ"},{"id":"c","text":"القطّةُ تنامُ في الدّار"},{"id":"d","text":"القطّةُ تلعبُ بالكرة"}]'::jsonb, 'a', 'مَن يشربُ في الصورة قطّةٌ لا كلب، وهي تشربُ لا تنامُ ولا تلعب، فالصحيح «القطّةُ تشربُ الحليبَ». الفخّ الشائع تغييرُ مَن يفعلُ (الكلب بدل القطّة).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6abb892d-6a62-5629-ae03-c5fd780450d5', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', '⭐⭐ تمرين مراجعة: الجملةُ ومعناها', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b129e063-cf1f-5c49-a581-b286e06bbd02', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'كم كلمةً في هذه الجملة: «القطّةُ تشربُ الحليبَ»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'أعدُّ الكلمات بين الفراغات: القطّةُ، تشربُ، الحليبَ. فعددُ كلمات الجملة 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33c54600-8e85-529d-af7b-f2a5c495964d', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="40" r="20" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="48" y1="8" x2="48" y2="18"/><line x1="14" y1="40" x2="24" y2="40"/><line x1="24" y1="20" x2="31" y2="27"/></g><path d="M104 116 v-44 l40 -26 l40 26 v44 z" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><path d="M100 74 l44 -28 l44 28" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><rect x="132" y="92" width="24" height="24" fill="#92400e" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"العصفورُ فوق الشّجرة"},{"id":"b","text":"القطّةُ تشربُ الحليبَ"},{"id":"c","text":"الطّفلُ يلعبُ بالكرة"},{"id":"d","text":"الشّمسُ فوق الدّار"}]'::jsonb, 'd', 'في الصورة شمسٌ في الأعلى ودارٌ تحتها، فالجملةُ المناسبة هي «الشّمسُ فوق الدّار».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c92c654c-524d-54a6-9135-44569e2d0d65', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'في جملة «الطّفلُ يلعبُ بالكرة»، مَن يلعبُ بالكرة؟', '[{"id":"a","text":"الطّفل"},{"id":"b","text":"الكرة"},{"id":"c","text":"القطّة"},{"id":"d","text":"العصفور"}]'::jsonb, 'a', 'الجملةُ تخبرنا أنّ الطّفلَ يلعبُ بالكرة، فالذي يلعبُ هو الطّفل، والكرةُ هي ما يلعبُ بها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09c9aa3a-1c35-58ab-ae10-49887427565e', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'ما الكلمةُ الناقصةُ في الجملة: «البنتُ ... الكتابَ»؟', '[{"id":"a","text":"فوق"},{"id":"b","text":"صغيرٌ"},{"id":"c","text":"تقرأُ"},{"id":"d","text":"دارٌ"}]'::jsonb, 'c', 'الجملةُ تحتاجُ فعلًا يدلُّ على ما تفعله البنتُ بالكتاب، فنقول «البنتُ تقرأُ الكتابَ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53b384e8-ec5f-5d3b-9758-d58880dff052', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'كم كلمةً في هذه الجملة: «العصفورُ يطيرُ فوق الشّجرة»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'c', 'أعدُّ الكلمات بين الفراغات: العصفورُ، يطيرُ، فوق، الشّجرة. فعددُ كلمات الجملة 4.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('885cb6d1-7f54-5885-b8a6-eb671f524c72', '6abb892d-6a62-5629-ae03-c5fd780450d5', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><ellipse cx="78" cy="84" rx="40" ry="26" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="44" cy="58" r="22" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M28 42 l-6 -16 l16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><path d="M60 42 l6 -16 l-16 8 z" fill="#fb923c" stroke="#1f2937" stroke-width="3"/><circle cx="38" cy="56" r="3" fill="#1f2937" stroke="none"/><circle cx="52" cy="56" r="3" fill="#1f2937" stroke="none"/><path d="M118 96 h44 v-22 h-44 z" fill="#bfdbfe" stroke="#1f2937" stroke-width="3"/><path d="M120 76 q20 -10 40 0" fill="none" stroke="#38bdf8" stroke-width="6"/></svg>', '[{"id":"a","text":"القطّةُ تشربُ الحليبَ"},{"id":"b","text":"الكلبُ يشربُ الحليبَ"},{"id":"c","text":"القطّةُ تأكلُ التّفّاحةَ"},{"id":"d","text":"البنتُ تقرأُ الكتابَ"}]'::jsonb, 'a', 'في الصورة قطّةٌ تشربُ من وعاءٍ فيه حليب، فالجملةُ الصحيحة «القطّةُ تشربُ الحليبَ» وليست الكلب ولا التّفّاحة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('08f940e3-cf03-5540-b95f-b8cf77833e84', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل القراءة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edf2004e-8abf-5b1a-8ec0-8e692558862c', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'أيّ صورةٍ تناسبُ الجملة: «القطّةُ تشربُ الحليبَ»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"40\" cy=\"30\" r=\"14\" fill=\"#fcd34d\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"44\" x2=\"40\" y2=\"76\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"26\" y2=\"66\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"56\" y2=\"64\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"30\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"50\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"86\" cy=\"82\" r=\"16\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M86 100 v-40\" stroke=\"#92400e\" stroke-width=\"7\"/><ellipse cx=\"86\" cy=\"48\" rx=\"30\" ry=\"24\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 44 q10 -10 20 0 q10 -4 12 6 q8 2 2 10 l-42 0 q-6 -8 6 -16 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"36\" cy=\"46\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"70\" rx=\"32\" ry=\"22\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"34\" cy=\"48\" r=\"18\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 34 l-4 -12 l12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M46 34 l4 -12 l-12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"29\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"39\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><path d=\"M92 84 h22 v-16 h-22 z\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"34\" cy=\"32\" r=\"16\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"3\" stroke-linecap=\"round\"><line x1=\"34\" y1=\"8\" x2=\"34\" y2=\"16\"/><line x1=\"10\" y1=\"32\" x2=\"18\" y2=\"32\"/></g><path d=\"M64 100 v-34 l30 -20 l30 20 v34 z\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 68 l34 -22 l34 22\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'الصورة (ج) قطّةٌ أمام وعاءٍ فيه حليب، فهي التي تناسبُ «القطّةُ تشربُ الحليبَ». أمّا (أ) طفلٌ وكرة، و(ب) عصفورٌ وشجرة، و(د) شمسٌ ودار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a19b844c-7806-5f1a-a645-14435c37bac5', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'أيّ صورةٍ تناسبُ الجملة: «الطّفلُ يلعبُ بالكرة»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"40\" cy=\"30\" r=\"14\" fill=\"#fcd34d\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"44\" x2=\"40\" y2=\"76\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"26\" y2=\"66\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"56\" y2=\"64\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"30\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"50\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"86\" cy=\"82\" r=\"16\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"70\" rx=\"32\" ry=\"22\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"34\" cy=\"48\" r=\"18\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 34 l-4 -12 l12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M46 34 l4 -12 l-12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"29\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"39\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><path d=\"M92 84 h22 v-16 h-22 z\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"34\" cy=\"32\" r=\"16\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"3\" stroke-linecap=\"round\"><line x1=\"34\" y1=\"8\" x2=\"34\" y2=\"16\"/><line x1=\"10\" y1=\"32\" x2=\"18\" y2=\"32\"/></g><path d=\"M64 100 v-34 l30 -20 l30 20 v34 z\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 68 l34 -22 l34 22\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M86 100 v-40\" stroke=\"#92400e\" stroke-width=\"7\"/><ellipse cx=\"86\" cy=\"48\" rx=\"30\" ry=\"24\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 44 q10 -10 20 0 q10 -4 12 6 q8 2 2 10 l-42 0 q-6 -8 6 -16 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"36\" cy=\"46\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/></svg>"}]'::jsonb, 'a', 'الصورة (أ) طفلٌ بجانبه كرةٌ حمراء، فهي التي تناسبُ «الطّفلُ يلعبُ بالكرة». أمّا (ب) قطّةٌ ووعاء، و(ج) شمسٌ ودار، و(د) عصفورٌ وشجرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92f81327-34d4-539e-8204-1b620cb5266d', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'أيّ صورةٍ تناسبُ الجملة: «العصفورُ يطيرُ فوق الشّجرة»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"70\" rx=\"32\" ry=\"22\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"34\" cy=\"48\" r=\"18\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 34 l-4 -12 l12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M46 34 l4 -12 l-12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"29\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"39\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><path d=\"M92 84 h22 v-16 h-22 z\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"34\" cy=\"32\" r=\"16\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"3\" stroke-linecap=\"round\"><line x1=\"34\" y1=\"8\" x2=\"34\" y2=\"16\"/><line x1=\"10\" y1=\"32\" x2=\"18\" y2=\"32\"/></g><path d=\"M64 100 v-34 l30 -20 l30 20 v34 z\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 68 l34 -22 l34 22\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"40\" cy=\"30\" r=\"14\" fill=\"#fcd34d\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"44\" x2=\"40\" y2=\"76\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"26\" y2=\"66\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"56\" y2=\"64\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"30\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"50\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"86\" cy=\"82\" r=\"16\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M86 100 v-40\" stroke=\"#92400e\" stroke-width=\"7\"/><ellipse cx=\"86\" cy=\"48\" rx=\"30\" ry=\"24\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 44 q10 -10 20 0 q10 -4 12 6 q8 2 2 10 l-42 0 q-6 -8 6 -16 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"36\" cy=\"46\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/></svg>"}]'::jsonb, 'd', 'الصورة (د) عصفورٌ يطيرُ بجانب شجرةٍ خضراء، فهي التي تناسبُ «العصفورُ يطيرُ فوق الشّجرة». أمّا (أ) قطّةٌ ووعاء، و(ب) شمسٌ ودار، و(ج) طفلٌ وكرة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e59bd658-ff62-555f-b424-8f080a791bec', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'كم كلمةً في هذه الجملة: «الطّائرُ يطيرُ في السّماء»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'c', 'أعدُّ الكلمات بين الفراغات: الطّائرُ، يطيرُ، في، السّماء. فعددُ كلمات الجملة 4. الفخّ الشائع نسيانُ عدِّ الكلمة الصغيرة «في».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3ff0227-2fff-58dc-a304-126688fbae19', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'صورةٌ فيها طفلٌ يلعبُ بكرةٍ حمراء. أيّ جملةٍ تصفها بدقّة؟', '[{"id":"a","text":"الطّفلُ يأكلُ الكرةَ"},{"id":"b","text":"الطّفلُ يلعبُ بالكرة"},{"id":"c","text":"القطّةُ تلعبُ بالكرة"},{"id":"d","text":"الطّفلُ يلعبُ بالكتاب"}]'::jsonb, 'b', 'الذي يلعبُ طفلٌ لا قطّة، وهو يلعبُ لا يأكلُ، وبالكرة لا بالكتاب، فالصحيح «الطّفلُ يلعبُ بالكرة». الفخّ الشائع تبديلُ كلمةٍ واحدةٍ تغيّرُ المعنى.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74ea5a31-a272-5076-a195-1c0bdc638c1c', '08f940e3-cf03-5540-b95f-b8cf77833e84', 'أيّ صورةٍ تناسبُ الجملة: «الشّمسُ فوق الدّار»؟', '[{"id":"a","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"34\" cy=\"32\" r=\"16\" fill=\"#facc15\" stroke=\"#1f2937\" stroke-width=\"3\"/><g stroke=\"#f59e0b\" stroke-width=\"3\" stroke-linecap=\"round\"><line x1=\"34\" y1=\"8\" x2=\"34\" y2=\"16\"/><line x1=\"10\" y1=\"32\" x2=\"18\" y2=\"32\"/></g><path d=\"M64 100 v-34 l30 -20 l30 20 v34 z\" fill=\"#fde68a\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M60 68 l34 -22 l34 22\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"40\" cy=\"30\" r=\"14\" fill=\"#fcd34d\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"44\" x2=\"40\" y2=\"76\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"26\" y2=\"66\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"52\" x2=\"56\" y2=\"64\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"30\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"40\" y1=\"76\" x2=\"50\" y2=\"98\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"86\" cy=\"82\" r=\"16\" fill=\"#ef4444\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><ellipse cx=\"60\" cy=\"70\" rx=\"32\" ry=\"22\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"34\" cy=\"48\" r=\"18\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 34 l-4 -12 l12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M46 34 l4 -12 l-12 6 z\" fill=\"#fb923c\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"29\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><circle cx=\"39\" cy=\"47\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/><path d=\"M92 84 h22 v-16 h-22 z\" fill=\"#bfdbfe\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 120 110\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M86 100 v-40\" stroke=\"#92400e\" stroke-width=\"7\"/><ellipse cx=\"86\" cy=\"48\" rx=\"30\" ry=\"24\" fill=\"#22c55e\" stroke=\"#1f2937\" stroke-width=\"3\"/><path d=\"M22 44 q10 -10 20 0 q10 -4 12 6 q8 2 2 10 l-42 0 q-6 -8 6 -16 z\" fill=\"#38bdf8\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"36\" cy=\"46\" r=\"2\" fill=\"#1f2937\" stroke=\"none\"/></svg>"}]'::jsonb, 'a', 'الصورة (أ) شمسٌ فوق دارٍ لها سقفٌ أحمر، فهي التي تناسبُ «الشّمسُ فوق الدّار». أمّا (ب) طفلٌ وكرة، و(ج) قطّةٌ ووعاء، و(د) عصفورٌ وشجرة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f51beb5c-805e-53a1-ad8d-dcb785a5ca07', '7ec6b181-5a05-5ac7-9de0-ddcefa6031a9', 'arabic-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للجملة', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fb355ef-1ae6-5843-a0d9-3fb83d3addee', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'كم كلمةً في هذه الجملة: «البنتُ تقرأ»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'a', 'الجملةُ «البنتُ تقرأ» فيها كلمتان بينهما فراغٌ واحد: البنتُ، تقرأ. فعددُ كلماتها 2.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ee0b273-4b6b-587b-b297-81f80fa419c2', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><circle cx="48" cy="40" r="20" fill="#facc15" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="48" y1="8" x2="48" y2="18"/><line x1="14" y1="40" x2="24" y2="40"/><line x1="24" y1="20" x2="31" y2="27"/></g><path d="M104 116 v-44 l40 -26 l40 26 v44 z" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><path d="M100 74 l44 -28 l44 28" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><rect x="132" y="92" width="24" height="24" fill="#92400e" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"القطّةُ تشربُ الحليبَ"},{"id":"b","text":"الطّفلُ يلعبُ بالكرة"},{"id":"c","text":"العصفورُ يطيرُ فوق الشّجرة"},{"id":"d","text":"الشّمسُ فوق الدّار"}]'::jsonb, 'd', 'في الصورة شمسٌ في الأعلى ودارٌ تحتها، فالجملةُ المناسبة هي «الشّمسُ فوق الدّار».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7486a1c-d7f6-52bd-98f8-8e066f7f5757', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'في جملة «العصفورُ يطيرُ فوق الشّجرة»، مَن يطيرُ؟', '[{"id":"a","text":"الشّجرة"},{"id":"b","text":"العصفور"},{"id":"c","text":"القطّة"},{"id":"d","text":"الطّفل"}]'::jsonb, 'b', 'الجملةُ تخبرنا أنّ العصفورَ يطيرُ فوق الشّجرة، فالذي يطيرُ هو العصفور، والشّجرةُ ثابتةٌ تحته.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e20c477-445e-5477-a1c9-8c625f911719', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'كم كلمةً في هذه الجملة: «الطّفلُ يلعبُ بالكرة»؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'أعدُّ الكلمات بين الفراغات: الطّفلُ، يلعبُ، بالكرة. فعددُ كلمات الجملة 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a1949dd-7c8d-55f1-b2cd-4b3f52d98be9', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'أيّ جملةٍ تصفُ هذه الصورة؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><path d="M150 118 v-46" stroke="#92400e" stroke-width="8"/><ellipse cx="150" cy="58" rx="40" ry="32" fill="#22c55e" stroke="#1f2937" stroke-width="3"/><path d="M40 50 q12 -12 24 0 q10 -6 14 6 q12 2 6 12 l-52 0 q-8 -10 8 -18 z" fill="#38bdf8" stroke="#1f2937" stroke-width="3"/><circle cx="58" cy="52" r="3" fill="#1f2937" stroke="none"/><path d="M40 56 l-12 6 l12 4 z" fill="#f59e0b" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"القطّةُ تطيرُ فوق الشّجرة"},{"id":"b","text":"العصفورُ فوق الدّار"},{"id":"c","text":"العصفورُ يطيرُ فوق الشّجرة"},{"id":"d","text":"العصفورُ يشربُ الحليبَ"}]'::jsonb, 'c', 'الذي يطيرُ عصفورٌ لا قطّة، وهو فوق الشّجرة لا الدّار، فالصحيح «العصفورُ يطيرُ فوق الشّجرة». الفخّ الشائع تبديلُ مَن يفعلُ أو المكان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('265e26c1-08be-5d1e-80f9-5fb8a77c4df6', 'f51beb5c-805e-53a1-ad8d-dcb785a5ca07', 'أيّ زوجٍ صحيحٌ بين الجملة وعدد كلماتها؟', '[{"id":"a","text":"البنتُ تقرأ ← 3"},{"id":"b","text":"العصفورُ يطيرُ فوق الشّجرة ← 3"},{"id":"c","text":"القطّةُ تشربُ الحليبَ ← 3"},{"id":"d","text":"الطّفلُ يلعبُ بالكرة ← 2"}]'::jsonb, 'c', '«القطّةُ تشربُ الحليبَ» فيها 3 كلمات، فالزوجُ صحيح. أمّا «البنتُ تقرأ» ففيها 2، و«العصفورُ يطيرُ فوق الشّجرة» ففيها 4، و«الطّفلُ يلعبُ بالكرة» ففيها 3.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

