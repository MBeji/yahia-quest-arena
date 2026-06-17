-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-donjon (Français — Donjon (tout le thème))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-donjon/
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
  ('francais-donjon', 'Français — Donjon (tout le thème)', 'Le Donjon du français : un défi mêlé où chaque question vient d''un domaine différent — grammaire, conjugaison, vocabulaire, lecture, orthographe — du plus simple au plus redoutable. Teste toute la langue d''un coup, et plus seulement un chapitre.', 'Polyvalence', 'subject-french', 'Swords', 9, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-donjon'
      AND e.source = 'admin'
      AND q.id NOT IN ('9897dddd-2e2e-561d-ac6c-8fec202924d5', '0442671f-2a83-5671-b125-d38235574d28', 'c7b63704-a828-5857-b225-759953ef75db', '6af5ef55-d0c7-575e-9496-87593cec23ad', '48ef472a-1512-5352-8e10-5f44663fc7d0', '5c3b82c9-abd7-5753-a9ba-ff7c77c09c58', '2418ebf3-a0ea-5522-ab4b-47961b09d5c3', '2a98ba23-4bf6-5e87-a4e5-43f88d0543d0', '202fb2b1-8748-57f5-8c5d-4901a13ea1ec', '4561aabf-f268-544c-b10e-86afd790220b', 'f1fc7541-15d6-5fb5-9924-f1d50ef696a0', 'b5a79206-7503-5ed2-bfa2-3cf1c5b20f3d', 'b1e96015-efec-5db0-80c6-bd9522f9376e', '66839583-6b13-5b80-aa68-587ae9f51318', '5b1f717e-51f1-5758-bf14-68cb9f534e0e', '6fe06495-f742-5fcc-878d-7a20151df2cd', 'b11843c1-b24f-5fed-9f60-1286c500bf57', 'f489f73d-f108-5b77-9011-581169475dd1', '9505d6c7-ae76-5e4d-866c-15358dab8e59', '2ca9667a-126f-5552-a4d8-95b7ed2c7e03', '4ade9933-5842-5c7b-8348-4d6427995073', '3dff5df0-f3d2-573a-b7dd-f531f94d79d2', '8aa07cb7-ef84-5df2-8010-f027e0c2e010', '6bd6fb25-8e84-5f60-9931-0333b7efb125', '34d9b431-cbf7-59fc-89d9-6bca175de14c', 'd07b9f9b-4a95-535f-bef4-db30e7f722a2', '1b7ce9d4-eef5-5c93-996d-ae29efee0f0d', 'c08f9c8f-f10c-5aeb-9190-c6c0aa1e3529', '8bfadf5d-ebbc-59a6-b2ca-11c6cc318e01', '0d840d6e-6243-5fef-97ff-d6dac6949e1a', 'a3f82017-4906-5dae-b63b-bd3c04607d1b', '82122b91-377e-5139-bc5a-0c5c068bb7f4', '738cc643-b8ac-5f9c-9888-cdec2643bf4b', 'b1e9b1d1-8ecf-5e8c-ba22-bf610d520720', '698cddaf-cbc9-5c7c-b474-ac55e409192f', '9692f65b-ff39-5681-8485-e448dc0b3a13', '916187ab-c8c6-5b57-a93a-f3c82b326100', '85f84cbc-07db-5b58-a4d8-4bfc5e4c11b0', '61c15f09-9adf-530c-8c87-ee862ae97075', 'cfb4938f-5864-5cdd-9103-1295d03172bf', '77fd30e7-c12e-5d53-8989-51ffae10e68a', 'ada904f9-49e1-5f8e-a4dd-82df71c70d7e', 'd53dfa5c-7fb6-5a54-87fa-177f495407c5', '6949f7c4-f254-52e8-aa88-de896bf61bf1', '4d057f03-5dd9-5a13-9e8d-310855501181', 'dec82553-f7aa-56c1-9066-c4add8b804ee', 'd83fc96b-26ed-5f0c-86ae-e038fec503d8', 'bb6c1415-e0e8-53a4-bf70-f58dcedeb0a8', '5635ba76-fac8-5cd7-a84e-9fd5a8d41ed3', 'a459cbd9-70cd-521f-9d73-42f432e33049', 'de67ec42-2cca-5cb6-ba92-159da9636de4', '412196f3-35e7-59c5-a2ef-f95aa0dbbce8', 'd290241e-cfb7-5fec-9106-e15a2dde0e83', '1b50a54f-3c82-5313-898f-684ed580b7d9', '7d0d05a7-a4b6-56ec-9c02-63e7161d8524', '3cd46f4d-b126-5f8f-b73a-e037cb5cbad1', 'cc2d2a36-24a1-5600-aa3a-26a656d1b10f', 'c38227d9-b30e-516b-b058-fa91c6cc6b2e', '8bfe9cb4-6f0c-5d57-bd71-a6be8622cc6d', 'ed5966f6-b646-5ed3-903a-73cdfe48cf04', 'a0f9849f-015a-5a52-a8a0-31a89bc25329', '01ac7789-4194-58a2-a4f2-3608b41b6dbb', '147d53e9-9d96-5ad5-921e-d152d30d26c5', 'aeb2b991-d21a-549d-87a1-a45f2196756b', 'a8ddcb36-0755-566d-b4c6-bd71db27e59c', '85f52a7b-7c60-5ddd-ad71-b25ba8b6b67e', 'f31096e0-7f48-5ae5-ae49-3d3292f8f76d', 'fafa8517-0e08-57a1-bc36-ce8397c0a266', '346eb26c-bc2c-5142-8d5a-95a6d16af470', 'fbb5c5ea-ac20-5c28-a5ec-c2e5f64e2e89', 'b838bd8e-f98a-5e07-b641-c66b8b4865a1', '76a8841e-6fc8-5c0e-a9c0-4202611b7ed2', 'f4a0189c-f905-5b00-a4a4-2f2376af88c3', 'a5bc1a63-cf00-579c-8fcc-c689c96af150', '30792b3b-04e2-5ea6-808b-d3f39556d54d', '506eab54-cd1a-5d73-9a28-d931b9750276', '5c1de1cb-74b8-54fd-ba20-19bec74d4c63', '3507030f-6c8b-5b68-9216-745d30fddbe7', '89f86bda-d40c-5e03-930d-87b63db44000', '9e43af1f-12a1-5fa0-b553-eac020b6a873', '4424c179-2ed0-5b40-b12c-539029761b67', '9c2beb0c-73e2-520b-8c9e-aeeb65c48c54', '6b101920-9662-59a2-9bbe-7a89458ab0fa', 'f0247e9f-9b77-5f27-bf94-d216d83d3a26', '0576dd35-263e-5486-8ee4-b821d7777fe5', '0a6a9efb-c8c4-5acb-b7ec-0fd44c9f2403', '39b39c02-a6b9-5747-963c-0e8d1ba79f48', 'b0d09024-291a-5b3f-b681-c5214358900c', '03cc0c18-b3b6-5e0e-bc49-d74e295863ca', 'a5c98060-fc2c-516d-b5b2-673fef901ff9', '70511aba-0b65-577c-84e7-cd66615cfa8c', '9a38af0d-6a61-520e-b5e6-f1d6fc1c011f', '4be7aa6b-bd42-5436-87d9-ed612142a74e', '3dfba2c3-fcbb-5ab0-a99b-24763438afe7', 'eec301d4-5b01-5fc4-b316-ac3ec1e3f115', '2022237c-7d13-5cb8-87e2-f11d3004db69', '9eb52327-4d87-5aff-b810-16aa3e0e4623', '0d387fbc-ffdd-5454-b468-b107352c6776', '14fcfeab-69d1-50fa-a79c-5e22d984efbd', 'd98df212-90cc-5f2e-9741-4360340f518a', '0e15bfd1-ce2a-5c65-9eb3-1cca79c0807c', '2ba174a4-43a8-58ae-9a2a-0fcab0b92949', '08fdae41-28f9-5d13-ba34-d4babca6302e', '53944c69-cf4e-59c0-be10-6ca785ff6fa6', '9d26595d-cfda-5bca-9501-2423fd62464a', '7a2a1fed-1935-5417-9fe7-6d841def4879', '35deabcd-ae19-5e50-a756-515fb12f3acd', '1372d6b2-c3b9-5fc5-a274-b8acbfe34b8b', 'ffdbdbb7-b4e8-50ba-a017-bcec81b53f67', '99c9a2a8-c466-5447-a256-f0e8783079a5', 'ce080795-34ef-57d7-88c9-868aa56f24a7', '4d3a13a9-1c72-53fa-b6da-fa88292da9d4', '22829ffa-3df8-5a9e-b321-c7e15a9b7030', '238f648c-fab7-59c7-a0b4-49bc5620a8b9', '9bb83183-32c4-5d4b-ad3d-eae1b248b625', '76081722-51e8-51ab-9628-3c66e49f2543', '2996d56d-dc78-592c-8506-5a8aa6a5bebb', 'ff18f17a-f90b-52a2-9916-6f7104ed2740', '67115058-178a-5ef6-8df3-a5cff0757372', '7aed6e94-8ccc-5ca8-a8f6-de4ebf2f55c7', 'ae1cd5f1-eae2-5348-9c48-79490a22be1b', '3967c0f6-c21e-57f5-9fc2-66141deff268', '771caec2-7bef-500f-8229-8b9a091c7c0f', '3f7a3249-d669-5161-bb8d-3563b24701cd', '9488c2df-6ee2-5ca4-bb4d-fd39036a2e0c', '896f0670-2bb8-592f-83cd-ac2910ceb077', 'b0e6f9d9-be29-59b4-82c7-980d9e018637', '87f125db-2dcc-5a21-a4ac-9c728a14f25e', '4d7d85df-9f82-5faf-9385-0bdabd918d0e', 'f8f81a58-5562-50af-83a5-1eb937ab741b', '0f1b33d3-fa61-5843-a7e7-c0c4bfc4ba2d', 'a15bb4f6-575e-53dc-9211-bd5c5c82cb5f', 'b4c8d374-0391-59db-a0ed-4e98e5c7b786', 'c98ee0ba-0135-5845-807b-bb01984a467f', 'a84a992b-d518-5600-b637-9a3475d2be3f', '1b5265b4-3477-5895-b97a-8f71d1e30017', '6d3234fb-cf35-51dc-9dc6-5a41cefdc963', '9d2ee91b-cf66-5cc7-8232-843710077897', '0812913d-aa53-516f-abf3-a9ae32759dfe', '81634805-20fc-5872-ac1a-a3695f9ed6a0', '370094d2-2b1f-5145-a528-fe29178b1261', '3998c24c-633b-5263-95d4-290e1e0a774b', 'd7293bdf-be73-5236-92d9-d7a011d58753', '5eeb6d10-bb0f-5a8c-bab0-bf4cb829e169', '166653af-8371-57a1-b2aa-18e659733fc5', 'ce760051-d95f-59b4-87fa-59a7287172ef', '1a4c6a0a-e673-58a4-bd54-37b601236aa4', '35b507cb-a59e-52ee-ad3f-5ddd876b176d', '67fa567b-26c0-5581-b5d4-fa7327fbdb90', '48195103-ef34-5d73-b7ff-884935a9081c', '96e20119-faff-5eb3-be5d-17187f666c66', '7a1dcaaf-d1bb-5f04-ad07-8be87de11b10', 'c2347bfb-7fa9-5fb2-b9e4-f18a60e9e311', '086c7f74-a0f5-542a-876c-a0b732f1c5f4', '4fa1986c-9c1c-52f6-aeef-0e3a2c774a4c', 'b5d401eb-9571-5185-878a-430186686928', 'fd188234-442f-557d-a44e-0d241f5497f3', '2a67ec93-91de-587c-a18c-48e5c4ecd0c2', '0e7f95ed-c24b-54b7-9a97-8a3972f7b6c7', '482529af-6abe-51cf-b8e3-fa0a317e49be', '37565735-845c-58f2-bf40-5066c2881b38', 'f84f36f0-17cf-5681-9fac-1349b8eb4380', '57df18d0-83f1-5e0d-ace2-9745634bd23b', 'aa501982-25f2-5535-b5f9-513e6f201dcd', '6894feb1-7b5a-5081-a9c6-d2ae9ef493c5', 'effd87cf-38d1-5821-8327-62a49aa1ea14', '5f03d200-1d39-56bf-b344-5326225258ff', 'ea66ac54-a717-5a71-9139-78beb085aa00', '0d7f0220-3ef0-50ca-be28-cbdde2200592', '65a99593-855f-556c-8eb8-64a486be7c3e', 'b7e70713-91bf-5fba-a1e4-0f0d5447b78b', '0fec5bb3-6dd5-56ce-8c1e-5bcf870c6e0f', 'fc9ba7cf-d2bf-59cc-b18f-7776fb65a00a', 'ac0fc8f5-5c98-536f-a4d1-eb694aee43d2');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-donjon' AND source = 'admin' AND id NOT IN ('d199908b-5870-56bb-9758-21c1669afac7', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', '0ca075bf-dad3-557f-a300-b11cd172686d', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', '8462bafc-fca5-5542-82c6-f6ab0070b005', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'faa33f79-933d-5774-a6fd-1ae54d170732', '16e510d1-2e86-54c8-b241-0f39285d815a', '372a6c15-10de-5fb9-8037-b5db1127c79c', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', '334107c5-53de-5cf9-a526-984ea95e4a05', '6b5909b0-5eea-5d3e-852f-4a5327d12691', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', '293422ec-ede5-5a26-87c3-74af11730ddb', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'be32c75d-9afb-5a22-8513-0205af532c28', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'bc657621-3783-532a-8b6b-151fcb125b9e', '9a8c073e-bba8-530c-8f26-c88d84ae3354', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f');
DELETE FROM public.questions WHERE exercise_id IN ('d199908b-5870-56bb-9758-21c1669afac7', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', '0ca075bf-dad3-557f-a300-b11cd172686d', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', '8462bafc-fca5-5542-82c6-f6ab0070b005', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'faa33f79-933d-5774-a6fd-1ae54d170732', '16e510d1-2e86-54c8-b241-0f39285d815a', '372a6c15-10de-5fb9-8037-b5db1127c79c', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', '334107c5-53de-5cf9-a526-984ea95e4a05', '6b5909b0-5eea-5d3e-852f-4a5327d12691', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', '293422ec-ede5-5a26-87c3-74af11730ddb', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'be32c75d-9afb-5a22-8513-0205af532c28', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'bc657621-3783-532a-8b6b-151fcb125b9e', '9a8c073e-bba8-530c-8f26-c88d84ae3354', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f') AND id NOT IN ('9897dddd-2e2e-561d-ac6c-8fec202924d5', '0442671f-2a83-5671-b125-d38235574d28', 'c7b63704-a828-5857-b225-759953ef75db', '6af5ef55-d0c7-575e-9496-87593cec23ad', '48ef472a-1512-5352-8e10-5f44663fc7d0', '5c3b82c9-abd7-5753-a9ba-ff7c77c09c58', '2418ebf3-a0ea-5522-ab4b-47961b09d5c3', '2a98ba23-4bf6-5e87-a4e5-43f88d0543d0', '202fb2b1-8748-57f5-8c5d-4901a13ea1ec', '4561aabf-f268-544c-b10e-86afd790220b', 'f1fc7541-15d6-5fb5-9924-f1d50ef696a0', 'b5a79206-7503-5ed2-bfa2-3cf1c5b20f3d', 'b1e96015-efec-5db0-80c6-bd9522f9376e', '66839583-6b13-5b80-aa68-587ae9f51318', '5b1f717e-51f1-5758-bf14-68cb9f534e0e', '6fe06495-f742-5fcc-878d-7a20151df2cd', 'b11843c1-b24f-5fed-9f60-1286c500bf57', 'f489f73d-f108-5b77-9011-581169475dd1', '9505d6c7-ae76-5e4d-866c-15358dab8e59', '2ca9667a-126f-5552-a4d8-95b7ed2c7e03', '4ade9933-5842-5c7b-8348-4d6427995073', '3dff5df0-f3d2-573a-b7dd-f531f94d79d2', '8aa07cb7-ef84-5df2-8010-f027e0c2e010', '6bd6fb25-8e84-5f60-9931-0333b7efb125', '34d9b431-cbf7-59fc-89d9-6bca175de14c', 'd07b9f9b-4a95-535f-bef4-db30e7f722a2', '1b7ce9d4-eef5-5c93-996d-ae29efee0f0d', 'c08f9c8f-f10c-5aeb-9190-c6c0aa1e3529', '8bfadf5d-ebbc-59a6-b2ca-11c6cc318e01', '0d840d6e-6243-5fef-97ff-d6dac6949e1a', 'a3f82017-4906-5dae-b63b-bd3c04607d1b', '82122b91-377e-5139-bc5a-0c5c068bb7f4', '738cc643-b8ac-5f9c-9888-cdec2643bf4b', 'b1e9b1d1-8ecf-5e8c-ba22-bf610d520720', '698cddaf-cbc9-5c7c-b474-ac55e409192f', '9692f65b-ff39-5681-8485-e448dc0b3a13', '916187ab-c8c6-5b57-a93a-f3c82b326100', '85f84cbc-07db-5b58-a4d8-4bfc5e4c11b0', '61c15f09-9adf-530c-8c87-ee862ae97075', 'cfb4938f-5864-5cdd-9103-1295d03172bf', '77fd30e7-c12e-5d53-8989-51ffae10e68a', 'ada904f9-49e1-5f8e-a4dd-82df71c70d7e', 'd53dfa5c-7fb6-5a54-87fa-177f495407c5', '6949f7c4-f254-52e8-aa88-de896bf61bf1', '4d057f03-5dd9-5a13-9e8d-310855501181', 'dec82553-f7aa-56c1-9066-c4add8b804ee', 'd83fc96b-26ed-5f0c-86ae-e038fec503d8', 'bb6c1415-e0e8-53a4-bf70-f58dcedeb0a8', '5635ba76-fac8-5cd7-a84e-9fd5a8d41ed3', 'a459cbd9-70cd-521f-9d73-42f432e33049', 'de67ec42-2cca-5cb6-ba92-159da9636de4', '412196f3-35e7-59c5-a2ef-f95aa0dbbce8', 'd290241e-cfb7-5fec-9106-e15a2dde0e83', '1b50a54f-3c82-5313-898f-684ed580b7d9', '7d0d05a7-a4b6-56ec-9c02-63e7161d8524', '3cd46f4d-b126-5f8f-b73a-e037cb5cbad1', 'cc2d2a36-24a1-5600-aa3a-26a656d1b10f', 'c38227d9-b30e-516b-b058-fa91c6cc6b2e', '8bfe9cb4-6f0c-5d57-bd71-a6be8622cc6d', 'ed5966f6-b646-5ed3-903a-73cdfe48cf04', 'a0f9849f-015a-5a52-a8a0-31a89bc25329', '01ac7789-4194-58a2-a4f2-3608b41b6dbb', '147d53e9-9d96-5ad5-921e-d152d30d26c5', 'aeb2b991-d21a-549d-87a1-a45f2196756b', 'a8ddcb36-0755-566d-b4c6-bd71db27e59c', '85f52a7b-7c60-5ddd-ad71-b25ba8b6b67e', 'f31096e0-7f48-5ae5-ae49-3d3292f8f76d', 'fafa8517-0e08-57a1-bc36-ce8397c0a266', '346eb26c-bc2c-5142-8d5a-95a6d16af470', 'fbb5c5ea-ac20-5c28-a5ec-c2e5f64e2e89', 'b838bd8e-f98a-5e07-b641-c66b8b4865a1', '76a8841e-6fc8-5c0e-a9c0-4202611b7ed2', 'f4a0189c-f905-5b00-a4a4-2f2376af88c3', 'a5bc1a63-cf00-579c-8fcc-c689c96af150', '30792b3b-04e2-5ea6-808b-d3f39556d54d', '506eab54-cd1a-5d73-9a28-d931b9750276', '5c1de1cb-74b8-54fd-ba20-19bec74d4c63', '3507030f-6c8b-5b68-9216-745d30fddbe7', '89f86bda-d40c-5e03-930d-87b63db44000', '9e43af1f-12a1-5fa0-b553-eac020b6a873', '4424c179-2ed0-5b40-b12c-539029761b67', '9c2beb0c-73e2-520b-8c9e-aeeb65c48c54', '6b101920-9662-59a2-9bbe-7a89458ab0fa', 'f0247e9f-9b77-5f27-bf94-d216d83d3a26', '0576dd35-263e-5486-8ee4-b821d7777fe5', '0a6a9efb-c8c4-5acb-b7ec-0fd44c9f2403', '39b39c02-a6b9-5747-963c-0e8d1ba79f48', 'b0d09024-291a-5b3f-b681-c5214358900c', '03cc0c18-b3b6-5e0e-bc49-d74e295863ca', 'a5c98060-fc2c-516d-b5b2-673fef901ff9', '70511aba-0b65-577c-84e7-cd66615cfa8c', '9a38af0d-6a61-520e-b5e6-f1d6fc1c011f', '4be7aa6b-bd42-5436-87d9-ed612142a74e', '3dfba2c3-fcbb-5ab0-a99b-24763438afe7', 'eec301d4-5b01-5fc4-b316-ac3ec1e3f115', '2022237c-7d13-5cb8-87e2-f11d3004db69', '9eb52327-4d87-5aff-b810-16aa3e0e4623', '0d387fbc-ffdd-5454-b468-b107352c6776', '14fcfeab-69d1-50fa-a79c-5e22d984efbd', 'd98df212-90cc-5f2e-9741-4360340f518a', '0e15bfd1-ce2a-5c65-9eb3-1cca79c0807c', '2ba174a4-43a8-58ae-9a2a-0fcab0b92949', '08fdae41-28f9-5d13-ba34-d4babca6302e', '53944c69-cf4e-59c0-be10-6ca785ff6fa6', '9d26595d-cfda-5bca-9501-2423fd62464a', '7a2a1fed-1935-5417-9fe7-6d841def4879', '35deabcd-ae19-5e50-a756-515fb12f3acd', '1372d6b2-c3b9-5fc5-a274-b8acbfe34b8b', 'ffdbdbb7-b4e8-50ba-a017-bcec81b53f67', '99c9a2a8-c466-5447-a256-f0e8783079a5', 'ce080795-34ef-57d7-88c9-868aa56f24a7', '4d3a13a9-1c72-53fa-b6da-fa88292da9d4', '22829ffa-3df8-5a9e-b321-c7e15a9b7030', '238f648c-fab7-59c7-a0b4-49bc5620a8b9', '9bb83183-32c4-5d4b-ad3d-eae1b248b625', '76081722-51e8-51ab-9628-3c66e49f2543', '2996d56d-dc78-592c-8506-5a8aa6a5bebb', 'ff18f17a-f90b-52a2-9916-6f7104ed2740', '67115058-178a-5ef6-8df3-a5cff0757372', '7aed6e94-8ccc-5ca8-a8f6-de4ebf2f55c7', 'ae1cd5f1-eae2-5348-9c48-79490a22be1b', '3967c0f6-c21e-57f5-9fc2-66141deff268', '771caec2-7bef-500f-8229-8b9a091c7c0f', '3f7a3249-d669-5161-bb8d-3563b24701cd', '9488c2df-6ee2-5ca4-bb4d-fd39036a2e0c', '896f0670-2bb8-592f-83cd-ac2910ceb077', 'b0e6f9d9-be29-59b4-82c7-980d9e018637', '87f125db-2dcc-5a21-a4ac-9c728a14f25e', '4d7d85df-9f82-5faf-9385-0bdabd918d0e', 'f8f81a58-5562-50af-83a5-1eb937ab741b', '0f1b33d3-fa61-5843-a7e7-c0c4bfc4ba2d', 'a15bb4f6-575e-53dc-9211-bd5c5c82cb5f', 'b4c8d374-0391-59db-a0ed-4e98e5c7b786', 'c98ee0ba-0135-5845-807b-bb01984a467f', 'a84a992b-d518-5600-b637-9a3475d2be3f', '1b5265b4-3477-5895-b97a-8f71d1e30017', '6d3234fb-cf35-51dc-9dc6-5a41cefdc963', '9d2ee91b-cf66-5cc7-8232-843710077897', '0812913d-aa53-516f-abf3-a9ae32759dfe', '81634805-20fc-5872-ac1a-a3695f9ed6a0', '370094d2-2b1f-5145-a528-fe29178b1261', '3998c24c-633b-5263-95d4-290e1e0a774b', 'd7293bdf-be73-5236-92d9-d7a011d58753', '5eeb6d10-bb0f-5a8c-bab0-bf4cb829e169', '166653af-8371-57a1-b2aa-18e659733fc5', 'ce760051-d95f-59b4-87fa-59a7287172ef', '1a4c6a0a-e673-58a4-bd54-37b601236aa4', '35b507cb-a59e-52ee-ad3f-5ddd876b176d', '67fa567b-26c0-5581-b5d4-fa7327fbdb90', '48195103-ef34-5d73-b7ff-884935a9081c', '96e20119-faff-5eb3-be5d-17187f666c66', '7a1dcaaf-d1bb-5f04-ad07-8be87de11b10', 'c2347bfb-7fa9-5fb2-b9e4-f18a60e9e311', '086c7f74-a0f5-542a-876c-a0b732f1c5f4', '4fa1986c-9c1c-52f6-aeef-0e3a2c774a4c', 'b5d401eb-9571-5185-878a-430186686928', 'fd188234-442f-557d-a44e-0d241f5497f3', '2a67ec93-91de-587c-a18c-48e5c4ecd0c2', '0e7f95ed-c24b-54b7-9a97-8a3972f7b6c7', '482529af-6abe-51cf-b8e3-fa0a317e49be', '37565735-845c-58f2-bf40-5066c2881b38', 'f84f36f0-17cf-5681-9fac-1349b8eb4380', '57df18d0-83f1-5e0d-ace2-9745634bd23b', 'aa501982-25f2-5535-b5f9-513e6f201dcd', '6894feb1-7b5a-5081-a9c6-d2ae9ef493c5', 'effd87cf-38d1-5821-8327-62a49aa1ea14', '5f03d200-1d39-56bf-b344-5326225258ff', 'ea66ac54-a717-5a71-9139-78beb085aa00', '0d7f0220-3ef0-50ca-be28-cbdde2200592', '65a99593-855f-556c-8eb8-64a486be7c3e', 'b7e70713-91bf-5fba-a1e4-0f0d5447b78b', '0fec5bb3-6dd5-56ce-8c1e-5bcf870c6e0f', 'fc9ba7cf-d2bf-59cc-b18f-7776fb65a00a', 'ac0fc8f5-5c98-536f-a4d1-eb694aee43d2');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-donjon' AND c.id NOT IN ('11180427-1ea0-544f-9b80-ed236bcb2538', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', '5b01551b-ac98-568c-a147-d7fa184db75f', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'e4775584-3005-5679-9cf4-28828479b462') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', 'Le Donjon du français', 'Un défi mêlé où chaque question vient d''un domaine différent — grammaire, conjugaison, vocabulaire, lecture, orthographe — et où la difficulté grimpe du plus simple au plus redoutable, du niveau débutant (A1) à la maîtrise experte (C2).', '# ⚔️ Le Donjon du français — Toute la langue, une seule épreuve

> 💡 « Le héros qui maîtrise une salle est fort ; celui qui maîtrise toutes les salles est invincible. »

Bienvenue, aventurier. Ici, pas de chapitre tranquille consacré à une seule règle. Le Donjon est une **épreuve mêlée** qui te jette _toute la langue_ à la figure d''un coup. Une salle teste un verbe, la suivante un mot, une autre une courte histoire, une autre encore une orthographe piégée — et tu ne sais jamais quelle porte s''ouvrira ensuite. Ta seule armure : une connaissance large et solide de tout, du niveau débutant à la maîtrise.

## 🏰 La règle du Donjon

Chaque combat **entremêle cinq domaines**. Tu passes d''une forme d''_être_ à un accord du participe, d''un texte court à un paronyme savant, sans transition. C''est tout l''enjeu : le vrai français ne se présente pas trié par leçon. Pour survivre, il faut être **polyvalent** — prêt à tout, dans n''importe quel ordre.

Chaque énoncé est **étiqueté** par son domaine, pour que tu saches toujours quelle arme dégainer.

## 📜 Les cinq portes (tes domaines)

| Porte | Domaine     | Ce qui t''attend                                                             |
| ----- | ----------- | --------------------------------------------------------------------------- |
| 🗡️    | Grammaire   | la bonne structure : articles, pronoms, voix passive, accords difficiles    |
| ⚡    | Conjugaison | le bon temps et le bon mode : présent, passé composé, subjonctif, condition |
| 💎    | Vocabulaire | le sens juste : synonymes, paronymes savants, expressions, registres        |
| 📖    | Lecture     | un texte court, puis une question dont la réponse est dans le texte         |
| ✒️    | Orthographe | la forme écrite correcte : accords, homophones, participes, lettres muettes |

## 🗡️ Grammaire — la colonne vertébrale

Ces salles règlent la mécanique de la phrase. Choisis l''article qui s''accorde en genre et en nombre (_**le** soleil_, _**une** maison_), place le bon pronom complément (_je **lui** parle_), construis la voix passive (_la lettre **est écrite** par Léa_) et, plus haut, maîtrise l''accord du participe passé avec le COD antéposé (_les fleurs que j''ai **cueillies**_).

## ⚡ Conjugaison — le moteur du temps

Ici tu domptes le temps. Au présent et au passé composé pour commencer (_il **a fini**_), puis l''imparfait et le futur, jusqu''au **subjonctif** après _il faut que_ (_que tu **fasses**_) et au **conditionnel** dans l''hypothèse (_si j''avais su, je **serais venu**_). La concordance des temps verrouille le tout.

## 💎 Vocabulaire — ton trésor de mots

Tu prouves ici ta richesse lexicale. Trouve l''intrus d''une série, le synonyme exact, ou distingue deux **paronymes** que tout oppose (_éminent_ ≠ _imminent_). Aux niveaux experts, choisis le mot **savant** précis et le bon **registre** (familier, courant, soutenu). Les distracteurs viennent de la _même famille_ : lis chaque option.

## 📖 Lecture — trouver l''indice

Un texte court apparaît, puis une question. La réponse est **toujours dans le texte** — ne devine pas d''après ce que tu sais par ailleurs. Lis les quelques lignes, retiens les faits, et choisis l''option que le passage soutient réellement, fût-ce par déduction.

## ✒️ Orthographe — écrire juste

Le français regorge de pièges écrits : homophones (_a / à_, _ces / ses_, _quel / qu''elle_), accords du participe, lettres muettes. Ces salles récompensent l''œil qui repère le piège silencieux.

> 🗡️ Conseil du héros : avant de répondre, **nomme le domaine** de l''énoncé. Un piège de grammaire et un piège d''orthographe se déjouent par des règles différentes — savoir quel combat tu mènes, c''est déjà la moitié de la victoire.

> ⚠️ Piège classique : ne transporte pas la logique d''une salle dans la suivante. _Fasses_ est juste dans une salle de conjugaison sur le subjonctif, mais _imminent_ ne remplace jamais _éminent_ dans une salle de vocabulaire — chaque domaine a sa loi.

> 🏆 Tu connais désormais les règles du Donjon. Franchis l''entraînement, mène la révision, terrasse le Boss, puis ose le Défi élite — et prouve que ton français n''a aucune salle faible.', '# 📜 Résumé : Le Donjon du français

- **But** — une seule épreuve mêlée qui teste toute la langue d''un coup (A1 → C2), pas un chapitre isolé.
- **Grammaire** — la bonne structure : articles accordés, pronoms compléments, voix passive, accord du participe.
- **Conjugaison** — le bon temps et le bon mode : présent, passé composé, imparfait, futur, subjonctif, conditionnel.
- **Vocabulaire** — le sens juste : synonymes, intrus d''une série, paronymes savants, expressions et registres.
- **Lecture** — lire un texte court, puis répondre uniquement avec ce que le texte dit ou laisse déduire.
- **Orthographe** — écrire juste : homophones (_a / à_, _ces / ses_), accords, participes, lettres muettes.
- **Méthode** — chaque énoncé nomme son domaine ; dégaine la règle correspondante, élimine le piège, puis choisis.
- 🏆 La polyvalence l''emporte : un héros prêt dans chaque salle n''a aucun point faible.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', 'Le défi A2', 'Un défi mêlé de niveau élémentaire qui brasse toute la bande A2 — présent (être, avoir, verbes en -er), articles et accords, interrogation et négation, passé composé, imparfait, futur (proche et simple), verbes pronominaux, comparatif et superlatif, prépositions de lieu et de temps, et le vocabulaire du quotidien et de la ville — à travers les domaines grammaire, conjugaison, vocabulaire, lecture et orthographe, du simple échauffement à l''épreuve d''élite.', '# ⚔️ Le défi A2 — Toute la bande élémentaire, un seul donjon

> 💡 «Le A1 t''a appris à tenir debout. Le A2 t''apprend à bouger — dans le temps, la comparaison et l''espace. Dompte chaque salle, et plus rien dans cette bande ne pourra te surprendre.»

Te revoilà, aventurier. Tu as franchi la première porte ; le donjon, lui, s''est agrandi. Voici **Le défi A2** — un labyrinthe plus profond, plus rude, qui te lance _toute la bande élémentaire_ d''un seul coup. Une salle te demande d''envoyer un verbe au **passé**, la suivante saisit une action **dans le présent**, une autre bondit vers le **futur**, puis une salle pèse deux choses l''une contre l''autre, et une dernière mesure _où_ et _quand_. Tu ne sais jamais quelle porte s''ouvrira ensuite.

## 🏰 La règle du donjon

Chaque combat **entremêle cinq domaines**. Tu passes d''un passé composé à une terminaison piégeuse, d''un petit récit de deux lignes à un comparatif, sans prévenir. C''est tout le principe : le vrai français ne se range jamais par thème. Pour survivre ici, il faut être **polyvalent** — prêt pour n''importe quel temps, n''importe quelle comparaison, n''importe quelle orthographe, dans n''importe quel ordre.

Chaque consigne est **étiquetée** par le domaine dont elle vient, pour que tu saches toujours quelle arme tirer : **Grammaire —**, **Conjugaison —**, **Vocabulaire —**, **Lecture —** ou **Orthographe —**.

## 🗡️ Conjugaison — le moteur du A2

Ces salles font tourner toute la machinerie de la bande. Choisis la bonne forme : le **présent** de _être_ et _avoir_ et des verbes en **-er** (_je parle, tu manges_), le **passé composé** (auxiliaire _avoir_ ou _être_ + participe passé : _j''ai mangé, je suis allé_), l''**imparfait** du décor et de l''habitude (_il faisait beau, je jouais_), et le **futur** : le **futur proche** (_aller_ + infinitif : _je vais partir_) pour un projet, le **futur simple** (_je partirai_) pour une prévision. N''oublie pas les **verbes pronominaux** (_je me lève, ils se lavent_).

## 💎 Grammaire — la charpente de la phrase

Ici tu prouves ta maîtrise des règles : les **articles** (_le, la, les, un, une, des_) et l''**accord** en genre et en nombre, l''**interrogation** (_est-ce que…, où, quand, combien_) et la **négation** (_ne… pas, ne… jamais, ne… plus_), le **comparatif** et le **superlatif** (_plus… que, moins… que, le plus…_), et les **prépositions** de lieu et de temps (_à, en, dans, sur, sous, depuis, pendant_).

## 📖 Lecture — trouve le détail

Un court texte apparaît — un petit récit au passé ou une scène du présent — puis une seule question. La réponse est **toujours dans le texte** : ne devine pas d''après tes connaissances extérieures. Lis les deux ou trois lignes, garde les faits en tête, parfois combine-les, et choisis l''option que le passage soutient vraiment.

## ✒️ Orthographe & Vocabulaire — écris juste, choisis le bon mot

Le A2 a ses propres pièges. Les **accords du participe passé** (_elle est allée_, _les fleurs que j''ai achetées_), les **terminaisons** des verbes en -er (_je mange_, _il mangeait_, _nous mangeons_), et les **accents** qui changent le sens (_a / à_, _ou / où_). Côté mots, repère l''**intrus** d''une série, trouve le **contraire**, ou choisis le seul mot qui complète une phrase naturelle — les distracteurs viennent de la _même famille_, alors lis tout avant de frapper.

> 🗡️ Conseil du héros : avant de répondre, **nomme le domaine et la règle**. Un piège de temps, un piège d''accord et un piège de comparaison se battent chacun avec une _loi différente_ — savoir dans quel combat tu es, c''est déjà la moitié de la victoire.

> ⚠️ Piège classique : ne transporte **pas** la logique d''une salle dans la suivante. _Plus rapide_ est juste quand tu compares deux choses, mais jamais _plus mieux_ ; le futur proche convient à un projet, mais une prévision lointaine demande le futur simple. Chaque domaine, et chaque temps, a sa propre règle.

> 🏆 Tu connais désormais les règles du défi A2. Franchis l''échauffement, enchaîne la révision, terrasse le Boss, puis ose l''épreuve d''Élite — et prouve que ton français élémentaire n''a aucune salle faible.', '# 📜 Résumé : Le défi A2

- **But** — un donjon mêlé qui teste toute la bande A2 d''un coup, et pas un seul chapitre.
- **Conjugaison** — présent (_être_, _avoir_, verbes en -er), passé composé (_j''ai mangé_, _je suis allé_), imparfait (_je jouais_), futur proche (_je vais partir_) vs futur simple (_je partirai_), et verbes pronominaux (_je me lève_).
- **Grammaire** — articles et accord en genre/nombre, interrogation (_est-ce que… ?_) et négation (_ne… pas / jamais / plus_), comparatif et superlatif (_plus… que_, _le plus…_), prépositions de lieu et de temps (_à, en, dans, sur, depuis, pendant_).
- **Vocabulaire** — l''**intrus** d''une série, les **contraires**, et le mot qui complète la phrase (vie quotidienne, ville).
- **Lecture** — lis un court récit au passé ou une scène du présent, puis réponds en utilisant seulement ce que dit le texte.
- **Orthographe** — accord du participe passé (_elle est allée_), terminaisons en -er, accents qui changent le sens (_a/à_, _ou/où_).
- **Méthode** — chaque consigne nomme son domaine : tire la règle qui correspond, élimine le piège sosie, puis choisis.
- 🏆 La polyvalence gagne : un héros prêt dans chaque temps, chaque comparaison et chaque accord n''a aucun point faible.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', 'Le Donjon B1', 'Un défi mêlé de niveau intermédiaire qui brasse toute la bande B1 — plus-que-parfait, pronoms compléments (COD/COI/y/en), pronoms relatifs (qui/que/où/dont), subjonctif présent, conditionnel et hypothèse (si), discours indirect et vocabulaire du travail et de la société — à travers les strates grammaire, conjugaison, vocabulaire, lecture et orthographe, de l''échauffement au défi élite.', '# ⚔️ Le Donjon B1 — Toute la bande intermédiaire en un seul labyrinthe

> 💡 «A1 t''a appris à tenir debout, A2 à marcher. B1 t''apprend à relier — le passé au présent, la cause à l''effet, une idée à une autre. Franchis chaque salle, et la porte intermédiaire est à toi.»

Te revoilà, challenger. Tu as nettoyé les Donjons A1 et A2 ; le labyrinthe s''est encore agrandi. Voici le **Donjon B1** — un dédale plus profond qui te jette _toute la bande intermédiaire_ à la fois. Une salle empile deux actions passées dans le bon ordre, la suivante remplace un nom par un **pronom**, une autre relie deux phrases en une seule, une autre exige le **subjonctif**, une autre plie le réel avec un **si**, et la dernière rapporte les paroles d''un autre. Tu ne sais jamais quelle porte s''ouvrira ensuite.

## 🏰 La règle du Donjon

Chaque combat **entrelace cinq strates**. Tu sautes d''un plus-que-parfait à un pronom relatif, d''un court récit à un accord de participe, sans prévenir. C''est tout l''enjeu : le vrai français ne se trie jamais par thème. Pour survivre ici, sois **polyvalent** — prêt pour tout temps, toute structure, toute orthographe, dans n''importe quel ordre.

Chaque consigne est **étiquetée** par sa strate, pour savoir quelle arme dégainer : **Grammaire —**, **Conjugaison —**, **Vocabulaire —**, **Lecture —** ou **Orthographe —**.

## 🗡️ Conjugaison & grammaire — le moteur du B1

Le **plus-que-parfait** = auxiliaire à l''**imparfait** + participe passé, pour montrer le « passé du passé » (_il **avait** déjà **fini** quand je suis arrivé_). Les **pronoms compléments** allègent la phrase : _le/la/les_ (COD direct), _lui/leur_ (COI = à quelqu''un), _y_ (à + chose / lieu), _en_ (de + chose / quantité). Le **subjonctif présent** suit la volonté, le doute ou l''émotion après _que_ (_il faut que tu **viennes**_), formé sur le radical de la 3e personne du pluriel + _-e, -es, -e, -ions, -iez, -ent_. Le **conditionnel** = radical du futur + terminaisons de l''imparfait, pour la politesse et l''hypothèse.

## 🔮 L''hypothèse avec « si » — la règle d''or

Trois systèmes à ne jamais mélanger : **si + présent → futur** (_si j''ai le temps, je viendrai_), **si + imparfait → conditionnel présent** (_si j''avais le temps, je viendrais_), **si + plus-que-parfait → conditionnel passé** (_si j''avais eu le temps, je serais venu_).

> 🗡️ Conseil du héros : **après « si », jamais de futur ni de conditionnel.** On dit _si j''**étais**_ (pas ~~si je serais~~) et _si j''**avais**_ (pas ~~si j''aurais~~). C''est le piège n°1 du niveau.

## 🔗 Pronoms relatifs & discours indirect — souder les idées

Le **pronom relatif** colle deux phrases : **qui** (sujet, un verbe suit), **que** (COD, un sujet + verbe suit), **où** (lieu ou temps), **dont** (complément en **de**). Le **discours indirect** rapporte sans guillemets : déclarative → _que_, question oui/non → _si_, et au passé la concordance recule d''un cran (présent → imparfait, futur → conditionnel, _hier_ → _la veille_).

## 💎 Vocabulaire — travail & société

Tu prouves ton trésor de mots B1 : _postuler, embaucher, **licencier** (le patron renvoie) ≠ **démissionner** (l''employé part)_, _gaspiller ≠ économiser_, _une information ≠ une publicité_. Les collocations valent de l''or : _prendre une décision, faire des efforts, jouer un rôle_.

## 📖 Lecture — trouve le détail

Un court texte apparaît, puis une question. La réponse est **toujours dans le texte** : ne devine pas de l''extérieur. Lis les deux à quatre lignes, retiens les faits, **déduis** parfois ce qu''ils impliquent, et choisis l''option que le passage soutient vraiment.

> ⚠️ Piège classique : ne reporte pas la logique d''une salle dans la suivante. _Licencier_ vise le patron, _démissionner_ l''employé ; _qui_ a un verbe après, _que_ a un sujet après ; _dont_ ne sert qu''avec **de**, jamais avec à/sur/pour. Chaque strate a sa loi.

> 🏆 Tu connais désormais les règles du Donjon B1. Réussis l''échauffement, enchaîne la révision, terrasse le Boss, puis ose le Défi élite — et prouve que ton français intermédiaire n''a aucune salle faible.', '# 📜 Résumé : Le Donjon B1

- **But** — un donjon mêlé qui teste toute la bande B1 d''un coup, et non un seul chapitre ; chaque consigne nomme sa strate.
- **Plus-que-parfait** — auxiliaire à l''**imparfait** + participe passé : le « passé du passé » (_il avait fini quand je suis arrivé_).
- **Pronoms compléments** — _le/la/les_ (COD), _lui/leur_ (COI = à qqn), _y_ (à + chose/lieu), _en_ (de + chose/quantité).
- **Pronoms relatifs** — **qui** (sujet, verbe après), **que** (COD, sujet+verbe après), **où** (lieu/temps), **dont** (complément en _de_).
- **Subjonctif présent** — après _que_ pour la volonté, le doute, l''émotion (_il faut que tu viennes_) ; irréguliers : sois, aie, aille, fasse, puisse.
- **Conditionnel & hypothèse** — si + présent → futur ; si + imparfait → conditionnel ; si + plus-que-parfait → conditionnel passé. **Jamais de futur/conditionnel après « si ».**
- **Discours indirect** — déclarative → _que_, oui/non → _si_ ; au passé : présent → imparfait, futur → conditionnel, _hier_ → _la veille_.
- **Vocabulaire travail & société** — licencier ≠ démissionner, gaspiller ≠ économiser, collocations (_prendre une décision, faire des efforts_).
- 🏆 La polyvalence gagne : un héros prêt dans chaque temps, structure et orthographe n''a aucun point faible.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', 'La bande B2', 'Un défi mêlé du niveau intermédiaire avancé qui brasse toute la bande B2 — voix passive, subjonctif passé et emplois avancés, expression de la cause/conséquence/but, opposition et concession, pronoms relatifs composés (lequel, auquel, duquel), gérondif et participe présent, vocabulaire des opinions et du débat (avec ses paronymes piégeux) et compréhension argumentative — à travers les domaines grammaire, conjugaison, vocabulaire, lecture et orthographe, en grimpant de l''échauffement à l''épreuve d''élite la plus redoutable.', '# ⚔️ La bande B2 — l''arène des maîtres-mots

> 💡 « Au niveau B2, tu ne récites plus la langue : tu la manœuvres. Chaque tournure est une arme — apprends à dégainer la bonne. »

Bienvenue dans la bande B2 du Donjon, héros. Ici, plus de question isolée : chaque salle mêle **grammaire, conjugaison, vocabulaire, lecture et orthographe**. Pour franchir la porte, tu dois manier toute la palette du niveau intermédiaire avancé. Ce parchemin réunit les sortilèges que tu vas affronter.

## 🏰 La voix passive — renverser le projecteur

À la voix passive, le **sujet subit** l''action au lieu de la faire. On forme : **être** (au temps voulu) **+ participe passé accordé** avec le sujet.

> _La loi a été votée._ (passé composé passif) — _Les portes seront fermées._ (futur passif)

Le **complément d''agent** s''introduit le plus souvent par **par** (_écrit par l''auteur_), mais par **de** après les verbes de sentiment ou de description (_respecté de tous, couvert de neige_).

> 🗡️ Astuce : le participe passé passif s''accorde **toujours** avec le sujet, car l''auxiliaire est _être_ — _Elles ont été récompensées._

## ⚡ Le subjonctif passé et ses emplois avancés

Le **subjonctif passé** marque l''**antériorité** : il dit qu''une action est déjà accomplie. On forme : **aie / sois** (subjonctif présent) **+ participe passé**.

> _Je doute qu''il ait fini._ — _Bien qu''elle soit partie tôt, elle est arrivée en retard._

Le subjonctif est exigé après **bien que, à moins que, avant que, sans que, pour que**, après un **superlatif** ou « **le seul, le premier, le dernier** » (_C''est le seul livre qui m''ait plu_).

> ⚠️ Piège : _après que_ commande l''**indicatif**, pas le subjonctif (_après qu''il a fini_).

## 🛡️ Cause, conséquence, but — l''architecture du raisonnement

| Rapport         | Articulateurs                                       | Mode           |
| --------------- | --------------------------------------------------- | -------------- |
| **Cause**       | parce que, puisque, comme, étant donné que, grâce à | indicatif      |
| **Conséquence** | si bien que, de sorte que, tellement… que           | indicatif      |
| **But**         | pour que, afin que, de peur que                     | **subjonctif** |

Distingue **car** (cause, jamais en tête de phrase) de **parce que**, et **puisque** (cause connue, admise) de **parce que** (cause nouvelle).

## 🔮 Opposition et concession — résister à l''argument adverse

L''**opposition** met deux faits face à face (_Lui travaille, elle se repose_) ; la **concession** admet un fait qui devrait empêcher l''autre (_Bien qu''il pleuve, nous sortons_).

> Concession + subjonctif : **bien que, quoique, encore que**. Concession + indicatif : **même si, alors que, tandis que**.

> 🗡️ Ne confonds pas **quoique** (= bien que, en un mot) et **quoi que** (= quelle que soit la chose que, en deux mots) : _Quoiqu''il soit tard… / Quoi que tu dises…_

## 🧮 Les pronoms relatifs composés

Après une **préposition**, on emploie **lequel, laquelle, lesquels, lesquelles** (souvent pour les choses).

> _La table sur **laquelle** j''écris_ — _Les outils avec **lesquels** il travaille._

Avec **à** et **de**, contractions obligatoires : **auquel / auxquels / auxquelles** ; **duquel / desquels / desquelles**.

> _Le projet **auquel** je pense_ — _Le toit **au-dessus duquel** vole l''oiseau._ Après une locution prépositionnelle (au milieu de, à côté de), on emploie **duquel/de laquelle**, pas _dont_.

## 📐 Gérondif et participe présent

Toutes les formes en **-ant**, mais trois usages :

- **Participe présent** (invariable) : _Les élèves **travaillant** dur réussissent._
- **Gérondif** = **en + -ant**, exprime simultanéité, cause, moyen, condition : _Il chante **en marchant**._
- **Adjectif verbal** (s''accorde) : _une histoire **fascinante**._

> ⚠️ Le sujet du gérondif doit être celui de la principale : _En entrant, j''ai vu…_ (c''est **moi** qui entre).

## 🧪 Vocabulaire du débat et paronymes

Argumenter : **affirmer, soutenir, concéder, réfuter, nuancer** ; les pièces du débat : **un argument, une objection, un enjeu, un consensus**. Les articulateurs : **en revanche, par ailleurs, certes… mais**.

Les **paronymes** B2 qui font tomber les héros pressés : **compréhensif** (indulgent) / **compréhensible** (clair) ; **éminent** (remarquable) / **imminent** (très proche) ; **notable** (important) / **notoire** (connu de tous).

> 🏆 Tu connais désormais l''arsenal complet de la bande B2. Affûte chaque tournure, traque les paronymes, et que ta logique tranche net : le boss du chapitre t''attend. En avant, héros !', '# 📜 Résumé : La bande B2

- **Voix passive** : être + participe passé accordé au sujet ; agent par _par_ (ou _de_ après sentiment/description).
- **Subjonctif passé** : aie/sois + participe passé, marque l''antériorité ; exigé après _bien que, avant que, pour que_, un superlatif ou _le seul_.
- **Cause / conséquence / but** : cause et conséquence à l''indicatif ; le **but** (_pour que, afin que_) au **subjonctif**.
- **Opposition / concession** : _bien que, quoique_ + subjonctif ; _même si, alors que_ + indicatif ; ne pas confondre _quoique_ et _quoi que_.
- **Relatifs composés** : _lequel_ après préposition ; contractions _auquel_, _duquel_ ; après une locution prépositionnelle, _duquel_ et non _dont_.
- **Gérondif / participe présent** : gérondif = _en_ + -ant ; participe présent invariable ; adjectif verbal accordé ; le sujet du gérondif = sujet de la principale.
- **Vocabulaire du débat** : affirmer, réfuter, nuancer, un enjeu, un consensus ; articulateurs _en revanche, par ailleurs_.
- **Paronymes** : compréhensif/compréhensible, éminent/imminent, notable/notoire.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', 'Le défi C1', 'Un défi mêlé de niveau autonome qui brasse toute la bande C1 — accord du participe passé dans les cas difficiles, concordance des temps, mise en relief et emphase, nominalisation, connecteurs avancés et articulation du discours, registres de langue, expressions idiomatiques et lexique soutenu, et compréhension de l''implicite — à travers les domaines grammaire, conjugaison, vocabulaire, lecture, orthographe et stylistique, du simple échauffement à l''épreuve d''élite.', '# ⚔️ Le défi C1 — toute la bande experte, un seul donjon

> 💡 « Le niveau B2 t''a donné les armes. Le niveau C1 t''apprend à les manier avec précision et élégance : accorder ce que les autres oublient, ordonner les temps comme un horloger, déplacer un mot pour le mettre en pleine lumière, condenser une idée en un seul nom, et guider ton lecteur sans qu''il voie les fils. Entre dans le donjon avancé. »

Bienvenue, champion. Tu as franchi le défi B2 ; le donjon ouvre maintenant son niveau le plus profond. Voici **le défi C1** — un labyrinthe où chaque salle réclame une arme différente du français soutenu. Une salle exige l''accord d''un participe passé piégeux, la suivante la concordance exacte des temps, la troisième une mise en relief élégante, la quatrième une nominalisation impeccable, la dernière un connecteur logique d''orfèvre. Tu ne sais jamais quelle porte s''ouvrira.

## 🏰 La règle du donjon

Chaque combat **entremêle plusieurs domaines**. Tu sautes sans prévenir d''un participe pronominal à une concordance au subjonctif, d''une phrase clivée à un lexème soutenu. C''est tout le but : le français avancé n''est pas rangé en cases — il est polyvalent, et la maîtrise, c''est d''être redoutable dans chaque coin.

Chaque énoncé est **étiqueté** par son domaine : **Grammaire —**, **Conjugaison —**, **Vocabulaire —**, **Lecture —**, **Orthographe —** ou **Stylistique —**.

## 🗡️ Grammaire et conjugaison — le moteur du C1

### L''accord du participe passé (cas difficiles)

| Cas                                       | Règle                           | Exemple                                         |
| ----------------------------------------- | ------------------------------- | ----------------------------------------------- |
| Pronominal réfléchi (COD avant)           | accord avec le COD placé avant  | _elle s''est **lavée**_                          |
| Pronominal + COD après (parties du corps) | invariable                      | _elle s''est **lavé** les mains_                 |
| Participe + infinitif                     | accord si le COD fait l''action  | _les chanteuses que j''ai **entendues** chanter_ |
| COD = « en »                              | invariable                      | _des fautes, j''en ai **fait**_                  |
| _fait_ / _laissé_ + infinitif             | invariable (réforme : _laissé_) | _elle s''est **fait** belle_                     |

### La concordance des temps

Quand la principale est au passé, la subordonnée recule d''un cran : simultanéité → **imparfait**, antériorité → **plus-que-parfait**, postériorité → **conditionnel présent** (futur du passé).

- _Il pensait que tu **venais**._ (simultanéité)
- _Il croyait que tu **étais venu**._ (antériorité)
- _Il espérait que tu **viendrais**._ (postériorité)

Après un verbe de souhait/doute au passé, le subjonctif **présent** reste correct en français courant ; le subjonctif imparfait est purement littéraire.

## 🔮 Stylistique — mise en relief et nominalisation

**Mise en relief** : on extrait un élément avec _c''est … qui / c''est … que_, ou avec _ce qui / ce que / ce dont … c''est_.

- _**C''est** ton silence **qui** m''inquiète._ (extraction du sujet)
- _**Ce que** je crains, **c''est** l''oubli._ (pseudo-clivée)

Accord après _c''est … qui_ : le verbe s''accorde avec le pronom repris — _c''est moi **qui suis**_, _c''est nous **qui sommes**_.

**Nominalisation** : on transforme un verbe ou un adjectif en groupe nominal pour condenser et hausser le registre.

- _Le prix a augmenté_ → _l''**augmentation** du prix_
- _Les rues sont propres_ → _la **propreté** des rues_

## 💎 Vocabulaire et registres

Au C1 on exploite un lexique précis et soutenu (_la mansuétude, fallacieux, exacerber, pallier (qqch), s''avérer, déroger à_) et on adapte le **registre** : _bagnole / voiture / automobile_, _bosser / travailler / œuvrer_. On décode aussi les **locutions figées** : _tomber dans le panneau_ (se faire piéger), _avoir le bras long_ (être influent), _mettre la charrue avant les bœufs_ (faire les choses dans le désordre).

## ✒️ Orthographe et connecteurs — les pièges du C1

Les **connecteurs soutenus** articulent l''argument : addition (_en outre, qui plus est, voire_), reformulation (_autrement dit, à savoir_), concession (_certes… néanmoins, il n''en demeure pas moins que_), conséquence (_dès lors, partant, de sorte que_). Côté orthographe, méfie-toi des locutions correctes : on dit _**pallier** un manque_ (sans « à »), _il s''est avéré **exact**_ (pas « avéré vrai »).

> 🗡️ Conseil du héros : pour le participe passé, cherche d''abord le COD et sa position. Pour la concordance, repère le temps de la principale, puis le rapport (avant / pendant / après). Pour la mise en relief, demande-toi quel élément tu veux éclairer. Pour le registre, identifie le destinataire.

> ⚠️ Piège classique : ne dis jamais « pallier à » ni « au jour d''aujourd''hui ». Et n''accorde pas le participe quand le COD est « en » ou quand il suit « fait + infinitif ».

> 🏆 Tu connais désormais les règles du défi C1. Franchis l''échauffement, drille les manches mêlées, terrasse le Boss, puis ose l''épreuve d''élite — et prouve que ton français soutenu maîtrise chaque arme de l''arsenal.', '# 📜 Résumé : Le défi C1

- **But** — un donjon mêlé qui teste toute la bande C1 d''un coup, et non un seul chapitre.
- **Grammaire / Conjugaison** — accord du participe passé difficile (pronominaux, _les mains_ invariable, COD « en », _fait/laissé_ + infinitif) ; concordance des temps (passé → imparfait / plus-que-parfait / conditionnel ; subjonctif présent en français courant).
- **Stylistique** — mise en relief (_c''est … qui/que_, _ce que … c''est_, accord _c''est moi qui suis_) et nominalisation (_augmenter → l''augmentation_, _propre → la propreté_).
- **Vocabulaire / Registres** — lexique soutenu (_mansuétude, fallacieux, exacerber, pallier qqch, s''avérer_), locutions figées (_tomber dans le panneau, avoir le bras long_), et adaptation du registre (_bagnole / voiture / automobile_).
- **Connecteurs / Orthographe** — articulation soutenue (_en outre, néanmoins, dès lors, autrement dit_) ; pièges (_pallier un manque_ sans « à », _s''avérer exact_).
- **Méthode** — chaque énoncé nomme son domaine ; repère l''indice (COD et sa place → accord ; temps de la principale → concordance ; élément à éclairer → mise en relief ; verbe à condenser → nominalisation), élimine les sosies, puis choisis.
- 🏆 Précision et polyvalence font le vainqueur : un héros qui maîtrise la forme et l''effet n''a aucune salle faible.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', 'Gantelet C2 : la bande C2', 'L''épreuve de maîtrise du Donjon : un gantelet mêlé qui brasse toute la bande C2 — temps littéraires (passé simple, passé antérieur, subjonctif imparfait), figures de style, syntaxe expressive et stylistique, nuances lexicales et paronymes savants, expressions rares, proverbes et locutions latines, rhétorique et argumentation (procédés, sophismes), vocabulaire savant et lecture critique experte. On y croise les fils grammaire, conjugaison, vocabulaire, lecture, stylistique et rhétorique, du simple échauffement jusqu''à l''ultime défi élite.', '# ⚔️ Gantelet C2 — l''ultime épreuve du Donjon

> 💡 « Au sommet de la tour, la langue ne pardonne plus l''à-peu-près : ici, chaque mot pèse son poids d''or. »

Héros, te voici devant la dernière salle du Donjon. Les bandes A2, B1, B2 et C1 sont tombées : il ne reste que **la bande C2**, la plus redoutable. Ce gantelet ne te ré-explique pas chaque domaine — il les **mêle** : une question de temps littéraire, puis une figure de style, puis un paronyme savant, puis un sophisme à démasquer. Pour le franchir, il te faut la **maîtrise**, pas la mémoire d''un seul chapitre.

## 🏰 Les temps littéraires — l''arme du récit

Le **passé simple** porte les actions ponctuelles de premier plan dans un récit écrit : _il entra, vit, vainquit_. Le **passé antérieur** (auxiliaire au passé simple + participe) marque l''antériorité immédiate dans ce même registre : _quand il **eut achevé**, il sortit_. Le **subjonctif imparfait** (_qu''il chantât, qu''il fût_) appartient à la concordance des temps soutenue : \*je voulais qu''il **vînt\***. Bold les terminaisons : 3ᵉ pers. sing. du subj. imparfait toujours en **-ât / -ît / -ût** avec accent circonflexe.

| Temps                    | Exemple                      | Emploi                                          |
| ------------------------ | ---------------------------- | ----------------------------------------------- |
| **Passé simple**         | _il parla, il finit, il fut_ | action ponctuelle, récit écrit                  |
| **Passé antérieur**      | _il eut parlé, il fut parti_ | antériorité immédiate (avant un passé simple)   |
| **Subjonctif imparfait** | _qu''il parlât, qu''il fût_    | concordance soutenue, après principale au passé |

## ⚡ Les figures de style — frapper l''imaginaire

> 🗡️ Distingue les voisines : la **comparaison** affiche son outil (_comme, tel_) ; la **métaphore** le supprime (_cet homme est un lion_). La **litote** dit moins pour suggérer plus (_il n''est pas mauvais_ = il est excellent) ; l''**euphémisme** adoucit (_il nous a quittés_). L''**oxymore** soude deux contraires (_un silence éloquent_) ; l''**hyperbole** exagère (_mourir de soif_). La **métonymie** prend le contenant pour le contenu (_boire un verre_).

## 🛡️ La syntaxe expressive et stylistique

Le **chiasme** croise l''ordre (AB / BA : _il faut manger pour vivre et non vivre pour manger_). L''**anaphore** répète en tête (_Paris ! Paris outragé ! Paris brisé !_). L''**inversion** du sujet crée le relief (_ainsi parla le sage_). L''**antéposition de l''adjectif** change le sens : _un grand homme_ (illustre) ≠ _un homme grand_ (de haute taille).

## 🔮 Nuances lexicales et paronymes savants

> ⚠️ Le piège favori du C2 : les **paronymes**. _Infliger_ une peine (≠ _infOliger_ n''existe pas ; ne pas confondre avec _affliger_ = attrister). _Éminent_ (remarquable) ≠ _imminent_ (tout proche). _Conjecture_ (hypothèse) ≠ _conjoncture_ (situation). _Acception_ (sens d''un mot) ≠ _acceptation_ (fait d''accepter). Un seul phonème, et la phrase bascule.

## 🧪 Expressions rares, proverbes et locutions latines

_A priori_ = avant tout examen ; _a posteriori_ = après l''expérience. _De facto_ = dans les faits ; _ipso facto_ = par le fait même. _Un talon d''Achille_ = le point faible. _Qui trop embrasse mal étreint_ = à vouloir tout faire, on échoue partout. _Jeter l''éponge_ = renoncer.

## 🧮 Rhétorique et argumentation — démasquer le faux

La **concession** (_certes… mais…_) reconnaît pour mieux réfuter. La **question rhétorique** affirme sans interroger vraiment. Mais gare aux **sophismes** : l''**attaque ad hominem** vise l''adversaire au lieu de l''argument ; l''**homme de paille** déforme la thèse pour la démolir plus facilement ; la **pente glissante** enchaîne des conséquences improbables. _Convaincre_ s''adresse à la raison (preuves) ; _persuader_ touche les sentiments.

> 🏆 Si tu réponds juste à travers tous ces fils — temps, figures, syntaxe, lexique, latinismes, rhétorique — alors le Donjon est dompté. Ce gantelet est le test du maître : franchis-le, et plus aucune porte du français ne te résistera.', '# 📜 Résumé : Gantelet C2 — la bande C2

- **Temps littéraires** : passé simple (action ponctuelle écrite), passé antérieur (antériorité immédiate, _il eut achevé_), subjonctif imparfait (_qu''il vînt_, -ât/-ît/-ût).
- **Figures de style** : comparaison (avec outil) vs métaphore (sans) ; litote (dire moins), euphémisme (adoucir), oxymore (contraires soudés), métonymie (contenant/contenu).
- **Syntaxe expressive** : chiasme (AB/BA), anaphore (répétition en tête), inversion du sujet, antéposition de l''adjectif (_grand homme_ ≠ _homme grand_).
- **Paronymes savants** : infliger/affliger, éminent/imminent, conjecture/conjoncture, acception/acceptation.
- **Expressions & latinismes** : a priori / a posteriori, de facto / ipso facto, talon d''Achille, _qui trop embrasse mal étreint_.
- **Rhétorique** : concession (_certes… mais…_), question rhétorique ; sophismes (ad hominem, homme de paille, pente glissante) ; convaincre (raison) ≠ persuader (sentiments).
- **Vocabulaire savant & lecture critique** : mots rares (idoine, laconique), précision lexicale, repérage de la thèse et des procédés dans un texte exigeant.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d199908b-5870-56bb-9758-21c1669afac7', '11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9897dddd-2e2e-561d-ac6c-8fec202924d5', 'd199908b-5870-56bb-9758-21c1669afac7', 'Conjugaison — Complétez : « Hier, nous ___ au cinéma. »', '[{"id":"a","text":"allons"},{"id":"b","text":"sommes allés"},{"id":"c","text":"irons"},{"id":"d","text":"allions"}]'::jsonb, 'b', '« Hier » situe l''action dans le passé : on emploie le passé composé, « nous sommes allés » (auxiliaire être + participe). « Allons » est le présent, « irons » le futur, et « allions » l''imparfait, qui exprimerait une habitude, pas un fait ponctuel daté.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0442671f-2a83-5671-b125-d38235574d28', 'd199908b-5870-56bb-9758-21c1669afac7', 'Vocabulaire — Quel est l''intrus de cette série ?', '[{"id":"a","text":"joyeux"},{"id":"b","text":"content"},{"id":"c","text":"heureux"},{"id":"d","text":"triste"}]'::jsonb, 'd', '« Joyeux », « content » et « heureux » expriment tous le bonheur, alors que « triste » exprime le contraire : c''est l''intrus. Le piège est qu''il s''agit aussi d''une émotion ; il faut trier par le sens (positif/négatif), pas par la catégorie générale.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7b63704-a828-5857-b225-759953ef75db', 'd199908b-5870-56bb-9758-21c1669afac7', 'Lecture — Lisez : « Léa habite à Tunis. Elle travaille dans une banque et rentre chez elle à dix-huit heures. »
Où travaille Léa ?', '[{"id":"a","text":"Dans une banque."},{"id":"b","text":"À Tunis."},{"id":"c","text":"À l''école."},{"id":"d","text":"À dix-huit heures."}]'::jsonb, 'a', 'Le texte dit explicitement « Elle travaille dans une banque » : c''est le lieu de travail. « À Tunis » est son lieu d''habitation, « à dix-huit heures » est une heure (pas un lieu), et « à l''école » n''est jamais mentionné — la réponse doit venir du texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6af5ef55-d0c7-575e-9496-87593cec23ad', 'd199908b-5870-56bb-9758-21c1669afac7', 'Grammaire — Choisissez le bon article : « Je voudrais ___ eau, s''il vous plaît. »', '[{"id":"a","text":"le"},{"id":"b","text":"un"},{"id":"c","text":"de l''"},{"id":"d","text":"des"}]'::jsonb, 'c', '« Eau » est ici une quantité indéterminée d''un nom non comptable : on emploie l''article partitif « de l'' » (devant voyelle). « Le » désigne une eau précise, « un » suppose un objet comptable, et « des » est le partitif pluriel, qui ne convient pas à « eau » au singulier.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48ef472a-1512-5352-8e10-5f44663fc7d0', 'd199908b-5870-56bb-9758-21c1669afac7', 'Orthographe — Choisissez la forme correcte : « Il ___ allé à Paris. »', '[{"id":"a","text":"à"},{"id":"b","text":"a"},{"id":"c","text":"as"},{"id":"d","text":"ah"}]'::jsonb, 'b', 'Ici « a » est le verbe avoir (auxiliaire du passé composé) : on peut le remplacer par « avait ». « À » avec accent est une préposition, « as » est la 2ᵉ personne (tu as), et « ah » est une interjection : aucun ne convient avec « il ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4de8438-90db-5b0b-a62a-ed48ccb65ebf', '11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', '⭐ Entraînement : tout le français', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c3b82c9-abd7-5753-a9ba-ff7c77c09c58', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Conjugaison — Complétez : « Je ___ étudiant. »', '[{"id":"a","text":"suis"},{"id":"b","text":"es"},{"id":"c","text":"est"},{"id":"d","text":"sont"}]'::jsonb, 'a', 'Avec le sujet « je », le verbe être se conjugue « suis » : je suis étudiant. « Es » va avec tu, « est » avec il/elle, et « sont » avec ils/elles ; aucune de ces formes ne s''accorde avec « je ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2418ebf3-a0ea-5522-ab4b-47961b09d5c3', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Vocabulaire — Quel est l''intrus de cette série ?', '[{"id":"a","text":"chien"},{"id":"b","text":"chat"},{"id":"c","text":"table"},{"id":"d","text":"cheval"}]'::jsonb, 'c', '« Chien », « chat » et « cheval » sont des animaux, tandis que « table » est un objet : c''est l''intrus. Il faut trier les mots par leur sens, et non par la lettre initiale qui pourrait faire hésiter.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a98ba23-4bf6-5e87-a4e5-43f88d0543d0', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Grammaire — Choisissez le bon article : « ___ soleil brille aujourd''hui. »', '[{"id":"a","text":"Le"},{"id":"b","text":"La"},{"id":"c","text":"Un"},{"id":"d","text":"Les"}]'::jsonb, 'a', '« Soleil » est un nom masculin singulier unique, donc on emploie l''article défini « le » : le soleil. « La » est le féminin, « les » le pluriel, et « un » présenterait un soleil parmi d''autres, ce qui ne convient pas pour l''astre unique.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('202fb2b1-8748-57f5-8c5d-4901a13ea1ec', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Lecture — Lisez : « Marc a deux frères et une sœur. Il aime jouer au football. »
Combien de frères a Marc ?', '[{"id":"a","text":"Un frère."},{"id":"b","text":"Trois frères."},{"id":"c","text":"Une sœur."},{"id":"d","text":"Deux frères."}]'::jsonb, 'd', 'Le texte dit « Marc a deux frères » : la réponse est donc deux. « Une sœur » répond à une autre question, et « un » ou « trois » modifient le nombre exact donné par le texte — il faut lire le détail précis.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4561aabf-f268-544c-b10e-86afd790220b', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Conjugaison — Complétez au présent : « Elle ___ la télévision le soir. »', '[{"id":"a","text":"regarde"},{"id":"b","text":"regardes"},{"id":"c","text":"regardons"},{"id":"d","text":"regardez"}]'::jsonb, 'a', 'Pour un verbe en -er au présent, la 3ᵉ personne du singulier (elle) prend la terminaison -e : elle regarde. « Regardes » est pour tu, « regardons » pour nous, et « regardez » pour vous : aucune ne s''accorde avec « elle ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1fc7541-15d6-5fb5-9924-f1d50ef696a0', 'e4de8438-90db-5b0b-a62a-ed48ccb65ebf', 'Orthographe — Choisissez la forme correcte : « J''aime ___ chiens. »', '[{"id":"a","text":"ses"},{"id":"b","text":"ces"},{"id":"c","text":"c''est"},{"id":"d","text":"s''est"}]'::jsonb, 'b', '« Ces » est l''adjectif démonstratif pluriel : il désigne ces chiens-là (que l''on montre). « Ses » marque la possession (les siens), « c''est » signifie « cela est », et « s''est » appartient à un verbe pronominal : aucun ne convient ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a6c9d258-c161-5a2d-874c-0a71b16b5ef2', '11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', '⭐⭐ Révision : tout le français', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5a79206-7503-5ed2-bfa2-3cf1c5b20f3d', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Conjugaison — Complétez à l''imparfait : « Quand j''étais petit, je ___ souvent chez ma grand-mère. »', '[{"id":"a","text":"vais"},{"id":"b","text":"suis allé"},{"id":"c","text":"allais"},{"id":"d","text":"irai"}]'::jsonb, 'c', '« Souvent » et le cadre « quand j''étais petit » décrivent une habitude passée : on emploie l''imparfait, « j''allais ». « Vais » est le présent, « irai » le futur, et « suis allé » (passé composé) exprimerait un fait unique, pas une habitude répétée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1e96015-efec-5db0-80c6-bd9522f9376e', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Vocabulaire — Quel mot est le synonyme de « rapide » ?', '[{"id":"a","text":"lent"},{"id":"b","text":"véloce"},{"id":"c","text":"lourd"},{"id":"d","text":"calme"}]'::jsonb, 'b', '« Véloce » signifie « qui va vite » : c''est le synonyme de rapide. « Lent » en est l''antonyme, tandis que « lourd » et « calme » désignent d''autres qualités sans rapport avec la vitesse.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66839583-6b13-5b80-aa68-587ae9f51318', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Grammaire — Remplacez le complément : « Je donne le livre à Paul. » →', '[{"id":"a","text":"Je le donne."},{"id":"b","text":"Je lui donne le livre."},{"id":"c","text":"Je le lui donne."},{"id":"d","text":"Je leur donne."}]'::jsonb, 'c', '« Le livre » (COD) devient « le » et « à Paul » (COI singulier) devient « lui » : Je le lui donne. « Je le donne » oublie Paul, « je lui donne le livre » garde le COD, et « leur » serait un pluriel, alors que Paul est une seule personne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b1f717e-51f1-5758-bf14-68cb9f534e0e', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Grammaire — Choisissez le bon pronom relatif : « Voici la ville ___ je suis né. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'd', '« Où » introduit un complément de lieu : la ville où je suis né. « Qui » remplace un sujet, « que » un COD, et « dont » remplace un complément introduit par « de » — aucun n''exprime le lieu attendu ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fe06495-f742-5fcc-878d-7a20151df2cd', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Conjugaison — Complétez : « Il faut que tu ___ tes devoirs. »', '[{"id":"a","text":"fais"},{"id":"b","text":"fasses"},{"id":"c","text":"feras"},{"id":"d","text":"ferais"}]'::jsonb, 'b', '« Il faut que » exige le subjonctif présent : que tu fasses. « Fais » est l''indicatif présent, « feras » le futur, et « ferais » le conditionnel ; après une expression de nécessité, seul le subjonctif est correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b11843c1-b24f-5fed-9f60-1286c500bf57', 'a6c9d258-c161-5a2d-874c-0a71b16b5ef2', 'Lecture — Lisez : « Sofiane est arrivé en retard parce que son train avait été annulé. Il s''est excusé auprès de son chef. »
Pourquoi Sofiane était-il en retard ?', '[{"id":"a","text":"Son train avait été annulé."},{"id":"b","text":"Il s''est excusé."},{"id":"c","text":"Son chef était absent."},{"id":"d","text":"Il a oublié l''heure."}]'::jsonb, 'a', 'Le texte donne la cause avec « parce que son train avait été annulé » : c''est la raison du retard. « Il s''est excusé » est une conséquence, et l''absence du chef ou l''oubli de l''heure ne sont jamais mentionnés dans le passage.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', '11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : tout le français', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f489f73d-f108-5b77-9011-581169475dd1', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Conjugaison — Complétez : « Si j''avais plus de temps, je ___ davantage. »', '[{"id":"a","text":"voyage"},{"id":"b","text":"voyagerai"},{"id":"c","text":"voyagerait"},{"id":"d","text":"voyagerais"}]'::jsonb, 'd', 'Dans une hypothèse « si + imparfait », la principale se met au conditionnel présent : je voyagerais. « Voyagerai » est le futur (employé après « si + présent »), « voyage » le présent, et « voyagerait » s''accorderait avec il/elle, pas avec « je ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9505d6c7-ae76-5e4d-866c-15358dab8e59', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Vocabulaire — Choisissez le connecteur logique correct : « Il a beaucoup travaillé ; ___, il a réussi son examen. »', '[{"id":"a","text":"par conséquent"},{"id":"b","text":"pourtant"},{"id":"c","text":"en revanche"},{"id":"d","text":"néanmoins"}]'::jsonb, 'a', 'Le travail est la cause et la réussite la conséquence logique : « par conséquent » exprime cette relation. « Pourtant », « en revanche » et « néanmoins » marquent l''opposition, ce qui contredirait le lien naturel cause → effet de la phrase.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ca9667a-126f-5552-a4d8-95b7ed2c7e03', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Grammaire — Mettez à la voix passive : « Le jury a récompensé les meilleurs élèves. » →', '[{"id":"a","text":"Les meilleurs élèves ont récompensé le jury."},{"id":"b","text":"Les meilleurs élèves ont été récompensés par le jury."},{"id":"c","text":"Les meilleurs élèves sont récompensés le jury."},{"id":"d","text":"Le jury a été récompensé par les élèves."}]'::jsonb, 'b', 'À la voix passive, le COD devient sujet et l''auxiliaire être garde le temps de l''actif (passé composé) : « ont été récompensés par le jury », avec accord du participe au masculin pluriel. (a) et (d) inversent les rôles, et (c) oublie « par » et le bon auxiliaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ade9933-5842-5c7b-8348-4d6427995073', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Conjugaison — Transposez au discours indirect : « Elle a dit : “Je viendrai demain.” » →', '[{"id":"a","text":"Elle a dit qu''elle viendra demain."},{"id":"b","text":"Elle a dit qu''elle viendrait le lendemain."},{"id":"c","text":"Elle a dit qu''elle vient demain."},{"id":"d","text":"Elle a dit qu''elle est venue demain."}]'::jsonb, 'b', 'Après un verbe introducteur au passé, le futur devient conditionnel et « demain » devient « le lendemain » : qu''elle viendrait le lendemain. (a) garde le futur, (c) le présent, et (d) introduit un passé composé incohérent avec une action à venir.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dff5df0-f3d2-573a-b7dd-f531f94d79d2', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Grammaire — Choisissez le pronom relatif composé correct : « C''est le projet ___ je pense depuis des mois. »', '[{"id":"a","text":"duquel"},{"id":"b","text":"laquelle"},{"id":"c","text":"auquel"},{"id":"d","text":"lequel"}]'::jsonb, 'c', 'On dit « penser à quelque chose », donc le relatif reprend « à » : à + lequel = auquel (projet, masculin singulier). « Duquel » correspond à « de », « lequel » seul oublie la préposition, et « laquelle » serait féminin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8aa07cb7-ef84-5df2-8010-f027e0c2e010', '6cf88dc3-acc5-5913-bb0c-ea563cc12e7e', 'Orthographe — Choisissez la phrase correctement orthographiée.', '[{"id":"a","text":"Quel que soit ton choix, je te soutiendrai."},{"id":"b","text":"Quelque soit ta décision, je t''accompagnerai."},{"id":"c","text":"Quelle que soit ton objectif, je t''épaulerai."},{"id":"d","text":"Quels que soit tes projets, je te suivrai."}]'::jsonb, 'a', 'Devant le verbe « être », « quel que » s''écrit en deux mots et s''accorde avec le sujet qui suit : « choix » étant masculin singulier, on écrit « quel que soit ton choix » (a). « Quelque » en un seul mot est un déterminant et ne convient pas ; « quelle que » exigerait un nom féminin (or « objectif » est masculin) ; « quels que soit » ne respecte pas l''accord du verbe, qui devrait être « soient ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ca075bf-dad3-557f-a300-b11cd172686d', '11180427-1ea0-544f-9b80-ed236bcb2538', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : tout le français', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bd6fb25-8e84-5f60-9931-0333b7efb125', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Orthographe — Choisissez l''accord correct du participe : « Les efforts qu''elle a ___ ont payé. »', '[{"id":"a","text":"faits"},{"id":"b","text":"fait"},{"id":"c","text":"faite"},{"id":"d","text":"faites"}]'::jsonb, 'a', 'Avec l''auxiliaire avoir, le participe s''accorde avec le COD placé avant : « qu'' » reprend « les efforts » (masculin pluriel), donc « faits ». Le piège est d''oublier l''accord (« fait ») ou de croire le COD féminin (« faite », « faites ») — il faut identifier que le COD est antéposé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34d9b431-cbf7-59fc-89d9-6bca175de14c', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Vocabulaire — Choisissez le mot juste : « C''est un savant ___, respecté du monde entier. »', '[{"id":"a","text":"émergent"},{"id":"b","text":"immanent"},{"id":"c","text":"imminent"},{"id":"d","text":"éminent"}]'::jsonb, 'd', '« Éminent » signifie « remarquable, supérieur par le mérite » : un savant éminent. « Émergent » désigne ce qui apparaît, « immanent » relève de la philosophie, et « imminent » qualifie ce qui va arriver très bientôt : seul « éminent » convient au sens de prestige.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d07b9f9b-4a95-535f-bef4-db30e7f722a2', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Conjugaison — Choisissez la forme respectant la concordance des temps : « Je croyais qu''il ___ déjà parti. »', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"soit"},{"id":"d","text":"sera"}]'::jsonb, 'b', '« Je croyais » est à l''imparfait : l''antériorité dans le passé se rend par l''imparfait de l''auxiliaire, « était déjà parti » (plus-que-parfait). « Est » (présent) et « sera » (futur) rompent la concordance, et « soit » (subjonctif) n''est pas appelé après « croire » à la forme affirmative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b7ce9d4-eef5-5c93-996d-ae29efee0f0d', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Vocabulaire — Identifiez la figure de style : « Cette nouvelle m''a fait verser des torrents de larmes. »', '[{"id":"a","text":"une litote"},{"id":"b","text":"un euphémisme"},{"id":"c","text":"une hyperbole"},{"id":"d","text":"une métonymie"}]'::jsonb, 'c', '« Des torrents de larmes » exagère volontairement l''ampleur des pleurs : c''est une hyperbole. La litote dit moins pour suggérer plus, l''euphémisme atténue une réalité dure, et la métonymie remplace un terme par un autre lié — aucun ne correspond à cette amplification.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c08f9c8f-f10c-5aeb-9190-c6c0aa1e3529', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Grammaire — Choisissez la tournure de mise en relief correcte : « ___ je veux te parler, pas de tes excuses. »', '[{"id":"a","text":"C''est de ton avenir que"},{"id":"b","text":"C''est de ton avenir dont"},{"id":"c","text":"C''est ton avenir que"},{"id":"d","text":"C''est ton avenir dont"}]'::jsonb, 'a', 'On dit « parler de quelque chose » : la préposition « de » figure déjà dans « de ton avenir », donc on reprend par « que », jamais par « dont » qui contiendrait un second « de ». « C''est de ton avenir dont » est un pléonasme fautif, et les options sans « de » suppriment la préposition que le verbe exige.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bfadf5d-ebbc-59a6-b2ca-11c6cc318e01', '0ca075bf-dad3-557f-a300-b11cd172686d', 'Vocabulaire — Choisissez le registre soutenu équivalent à « Il s''est mis en colère ».', '[{"id":"a","text":"Il a pété un câble."},{"id":"b","text":"Il a piqué une crise."},{"id":"c","text":"Il a entré en fureur."},{"id":"d","text":"Il est entré dans une vive colère."}]'::jsonb, 'd', '« Il est entré dans une vive colère » appartient au registre soutenu et est grammaticalement correct (entrer se conjugue avec être). « Pété un câble » et « piqué une crise » sont familiers, et « a entré en fureur » est fautif : « entrer » prend l''auxiliaire être, non avoir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('24dc717f-91e6-525f-a9e6-d1009fb58beb', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d840d6e-6243-5fef-97ff-d6dac6949e1a', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'Conjugaison — Complète au passé composé : « Hier soir, nous ___ un bon film au cinéma. »', '[{"id":"a","text":"avons regardé"},{"id":"b","text":"avons regardés"},{"id":"c","text":"sommes regardé"},{"id":"d","text":"regardons"}]'::jsonb, 'a', 'Le passé composé de « regarder » se forme avec l''auxiliaire avoir + participe passé : nous avons regardé. Avec avoir, le participe ne s''accorde pas avec le sujet, donc pas de -s (b). « être » (c) est faux ici, et « regardons » (d) est le présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3f82017-4906-5dae-b63b-bd3c04607d1b', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'Grammaire — Choisis le bon article : « J''achète ___ pommes au marché. »', '[{"id":"a","text":"le"},{"id":"b","text":"des"},{"id":"c","text":"la"},{"id":"d","text":"un"}]'::jsonb, 'b', '« pommes » est au pluriel, donc l''article indéfini pluriel est des : des pommes. « le » et « la » sont des articles définis singuliers, et « un » est l''indéfini masculin singulier — aucun ne convient à un nom pluriel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82122b91-377e-5139-bc5a-0c5c068bb7f4', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'Grammaire — Mets cette phrase à la forme négative : « Je mange de la viande. »', '[{"id":"a","text":"Je ne mange de la viande."},{"id":"b","text":"Je mange ne pas de la viande."},{"id":"c","text":"Je ne mange pas."},{"id":"d","text":"Je ne mange pas de viande."}]'::jsonb, 'd', 'La négation encadre le verbe (ne… pas) et, après une négation, l''article partitif « de la » devient « de » : Je ne mange pas de viande. L''option (a) oublie « pas », (b) place mal « ne… pas », et (c) supprime le complément.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('738cc643-b8ac-5f9c-9888-cdec2643bf4b', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'Conjugaison — Complète à l''imparfait : « Quand j''étais petit, je ___ souvent au parc. »', '[{"id":"a","text":"joue"},{"id":"b","text":"ai joué"},{"id":"c","text":"jouais"},{"id":"d","text":"jouerai"}]'::jsonb, 'c', '« souvent » et « quand j''étais petit » marquent une habitude dans le passé : on emploie l''imparfait, jouais. « joue » est le présent, « ai joué » le passé composé (action unique), et « jouerai » le futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1e9b1d1-8ecf-5e8c-ba22-bf610d520720', '24dc717f-91e6-525f-a9e6-d1009fb58beb', 'Lecture — Lis : « Samedi, Lina a rangé sa chambre. Le matin, elle a trié ses livres, et l''après-midi, elle a passé l''aspirateur. » Qu''a fait Lina l''après-midi ?', '[{"id":"a","text":"Elle a passé l''aspirateur."},{"id":"b","text":"Elle a trié ses livres."},{"id":"c","text":"Elle a lu des livres."},{"id":"d","text":"Elle a fait la cuisine."}]'::jsonb, 'a', 'Le texte dit qu''« l''après-midi, elle a passé l''aspirateur », donc (a) est correct. Trier les livres (b) était le matin, et (c) et (d) ne sont jamais mentionnés : on répond avec le seul détail donné par le texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e590ae0e-4085-5e00-9521-4e4167713f58', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', '⭐ Entraînement : la bande A2', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('698cddaf-cbc9-5c7c-b474-ac55e409192f', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Conjugaison — Complète au présent : « Tu ___ une grande maison. »', '[{"id":"a","text":"a"},{"id":"b","text":"as"},{"id":"c","text":"es"},{"id":"d","text":"ai"}]'::jsonb, 'b', 'Au présent, le verbe avoir avec « tu » fait as : tu as une grande maison. « a » va avec il/elle, « ai » avec je, et « es » est le verbe être (tu es).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9692f65b-ff39-5681-8485-e448dc0b3a13', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Conjugaison — Complète au présent : « Nous ___ le français à l''école. »', '[{"id":"a","text":"parle"},{"id":"b","text":"parles"},{"id":"c","text":"parlons"},{"id":"d","text":"parlent"}]'::jsonb, 'c', 'Un verbe en -er avec « nous » prend la terminaison -ons : nous parlons. « parle » va avec je/il, « parles » avec tu, et « parlent » avec ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('916187ab-c8c6-5b57-a93a-f3c82b326100', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Grammaire — Choisis le bon article : « ___ soleil brille aujourd''hui. »', '[{"id":"a","text":"Le"},{"id":"b","text":"La"},{"id":"c","text":"Les"},{"id":"d","text":"Des"}]'::jsonb, 'a', '« soleil » est un nom masculin singulier, donc l''article défini est le : le soleil brille. « la » est féminin, « les » et « des » sont pluriels.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85f84cbc-07db-5b58-a4d8-4bfc5e4c11b0', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Vocabulaire — Quel mot est l''intrus ?', '[{"id":"a","text":"lundi"},{"id":"b","text":"mardi"},{"id":"c","text":"jeudi"},{"id":"d","text":"janvier"}]'::jsonb, 'd', 'Lundi, mardi et jeudi sont des jours de la semaine, mais janvier est un mois de l''année : c''est l''intrus. On classe par catégorie de sens, pas par le simple fait que ce sont des mots de temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61c15f09-9adf-530c-8c87-ee862ae97075', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Grammaire — Pose la question avec « est-ce que » : « ___ tu aimes le chocolat ? »', '[{"id":"a","text":"Qu''est-ce que"},{"id":"b","text":"Est-ce que"},{"id":"c","text":"Où est-ce que"},{"id":"d","text":"Quand est-ce que"}]'::jsonb, 'b', 'Pour une question fermée (réponse oui/non), on emploie Est-ce que en début de phrase : Est-ce que tu aimes le chocolat ? « Qu''est-ce que » demande une chose, « Où » un lieu, et « Quand » un moment.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfb4938f-5864-5cdd-9103-1295d03172bf', 'e590ae0e-4085-5e00-9521-4e4167713f58', 'Conjugaison — Complète au futur proche : « Demain, je ___ mes grands-parents. »', '[{"id":"a","text":"vais visité"},{"id":"b","text":"va visiter"},{"id":"c","text":"vais visiter"},{"id":"d","text":"visite"}]'::jsonb, 'c', 'Le futur proche se forme avec aller (au présent) + infinitif : je vais visiter. On garde l''infinitif « visiter » (pas le participe « visité », b), « va » va avec il/elle (c), et « visite » est le présent (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e85cbd10-49a3-5b59-a636-c0c223e2706e', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', '⭐⭐ Révision : la bande A2', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77fd30e7-c12e-5d53-8989-51ffae10e68a', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Conjugaison — Complète au passé composé : « Elle ___ à la maison à huit heures. »', '[{"id":"a","text":"a rentré"},{"id":"b","text":"est rentrée"},{"id":"c","text":"est rentré"},{"id":"d","text":"a rentrée"}]'::jsonb, 'b', '« rentrer » se conjugue avec l''auxiliaire être au passé composé, et le participe s''accorde avec le sujet : Elle est rentrée (féminin, donc -e). Avec avoir (a, d) c''est faux, et « est rentré » (c) oublie l''accord féminin.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ada904f9-49e1-5f8e-a4dd-82df71c70d7e', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Vocabulaire — Quel est le contraire de « grand » ?', '[{"id":"a","text":"haut"},{"id":"b","text":"petit"},{"id":"c","text":"large"},{"id":"d","text":"long"}]'::jsonb, 'b', 'Le contraire de « grand » est petit. « haut » s''oppose à « bas », « large » à « étroit », et « long » à « court » : ce sont des antonymes d''autres adjectifs, pas de « grand ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d53dfa5c-7fb6-5a54-87fa-177f495407c5', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Grammaire — Choisis le bon comparatif : « Le train est ___ rapide ___ le vélo. »', '[{"id":"a","text":"plus … de"},{"id":"b","text":"aussi … de"},{"id":"c","text":"plus … que"},{"id":"d","text":"le plus … que"}]'::jsonb, 'c', 'Le comparatif de supériorité est plus + adjectif + que : plus rapide que le vélo. On utilise « que » (et non « de »), « le plus… » est le superlatif, et « aussi… que » exprime l''égalité, pas la supériorité.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6949f7c4-f254-52e8-aa88-de896bf61bf1', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Conjugaison — Complète à l''imparfait : « Tous les étés, nous ___ à la mer. »', '[{"id":"a","text":"allions"},{"id":"b","text":"allons"},{"id":"c","text":"sommes allés"},{"id":"d","text":"irons"}]'::jsonb, 'a', '« tous les étés » marque une habitude passée : on emploie l''imparfait, et avec « nous » la terminaison est -ions → allions. « allons » est le présent, « sommes allés » le passé composé (action unique), et « irons » le futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d057f03-5dd9-5a13-9e8d-310855501181', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Grammaire — Complète avec la bonne préposition : « Le chat dort ___ le canapé. »', '[{"id":"a","text":"en"},{"id":"b","text":"à"},{"id":"c","text":"depuis"},{"id":"d","text":"sur"}]'::jsonb, 'd', 'Pour indiquer une position au-dessus d''une surface, on emploie sur : sur le canapé. « en » et « à » ne marquent pas cette position, et « depuis » est une préposition de temps (depuis hier).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dec82553-f7aa-56c1-9066-c4add8b804ee', 'e85cbd10-49a3-5b59-a636-c0c223e2706e', 'Lecture — Lis : « Karim s''est levé tôt, il a pris son petit-déjeuner, puis il est parti au travail à pied. » Comment Karim est-il allé au travail ?', '[{"id":"a","text":"En bus."},{"id":"b","text":"En voiture."},{"id":"c","text":"À pied."},{"id":"d","text":"À vélo."}]'::jsonb, 'c', 'Le texte dit qu''il « est parti au travail à pied », donc (c) est correct. Le bus, la voiture et le vélo ne sont jamais mentionnés : on choisit le seul moyen de transport indiqué par le texte.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8462bafc-fca5-5542-82c6-f6ab0070b005', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : la bande A2', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d83fc96b-26ed-5f0c-86ae-e038fec503d8', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Conjugaison — Complète au passé composé avec un verbe pronominal : « Ce matin, ils ___ très tôt. »', '[{"id":"a","text":"se sont levés"},{"id":"b","text":"s''ont levés"},{"id":"c","text":"se sont levé"},{"id":"d","text":"se sont levées"}]'::jsonb, 'a', 'Les verbes pronominaux se conjuguent avec être, et le participe s''accorde avec le sujet : « ils » est masculin pluriel → se sont levés. « s''ont » (b) est faux (l''auxiliaire est être, pas avoir), « levé » (c) oublie l''accord pluriel, et « levées » (d) est le féminin pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb6c1415-e0e8-53a4-bf70-f58dcedeb0a8', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Grammaire — Mets à la forme négative avec « ne… jamais » : « Il regarde la télévision. »', '[{"id":"a","text":"Il ne regarde la télévision."},{"id":"b","text":"Il regarde jamais la télévision."},{"id":"c","text":"Il ne regarde jamais la télévision."},{"id":"d","text":"Il ne jamais regarde la télévision."}]'::jsonb, 'c', 'La négation « ne… jamais » encadre le verbe conjugué : Il ne regarde jamais la télévision. (a) oublie « jamais », (b) supprime « ne », et (d) place mal « jamais » avant le verbe au lieu de l''après.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5635ba76-fac8-5cd7-a84e-9fd5a8d41ed3', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Orthographe — Trouve la phrase SANS faute.', '[{"id":"a","text":"Elle va a l''école."},{"id":"b","text":"Il a manger une pomme."},{"id":"c","text":"Ou est ta sœur ?"},{"id":"d","text":"Où vas-tu ce soir ?"}]'::jsonb, 'd', '« Où vas-tu ce soir ? » est correcte : « où » (avec accent) interroge sur le lieu. (a) confond « a » (verbe) et « à » (préposition), (b) met l''infinitif « manger » au lieu du participe « mangé », et (c) écrit « ou » (conjonction) au lieu de « où » (lieu).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a459cbd9-70cd-521f-9d73-42f432e33049', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Grammaire — Complète au superlatif : « C''est ___ haute montagne du pays. »', '[{"id":"a","text":"plus"},{"id":"b","text":"très"},{"id":"c","text":"la plus"},{"id":"d","text":"le plus"}]'::jsonb, 'c', 'Le superlatif s''accorde avec le nom : « montagne » est féminin singulier → la plus haute montagne. « plus » seul est un comparatif incomplet, « très » est un intensif (pas un superlatif), et « le plus » est la forme masculine.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de67ec42-2cca-5cb6-ba92-159da9636de4', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Conjugaison — Complète au futur simple : « Quand tu seras grand, tu ___ médecin. »', '[{"id":"a","text":"es"},{"id":"b","text":"seras"},{"id":"c","text":"vas être"},{"id":"d","text":"étais"}]'::jsonb, 'b', 'Une prévision lointaine, après « quand tu seras grand », demande le futur simple du verbe être : tu seras médecin. « es » est le présent, « étais » l''imparfait, et le futur proche « vas être » (c) conviendrait à un projet immédiat, pas à une prévision lointaine.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('412196f3-35e7-59c5-a2ef-f95aa0dbbce8', '8462bafc-fca5-5542-82c6-f6ab0070b005', 'Lecture — Lis : « Sofia voulait offrir un cadeau à son frère. Elle avait peu d''argent, juste assez pour un livre, mais pas assez pour le jeu vidéo qu''il aimait. » Que pouvait acheter Sofia ?', '[{"id":"a","text":"Un livre."},{"id":"b","text":"Le jeu vidéo."},{"id":"c","text":"Le livre et le jeu vidéo."},{"id":"d","text":"Rien du tout."}]'::jsonb, 'a', 'Le texte dit qu''elle avait « juste assez pour un livre, mais pas assez pour le jeu vidéo », donc elle pouvait acheter un livre (a). Elle ne pouvait pas s''offrir le jeu (b et c sont exclus), et « peu d''argent » signifie qu''elle en avait un peu, donc pas « rien du tout » (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('95bca5a9-b300-547e-b4c8-560b08dcec4d', '6eb4704d-dad1-5829-90a7-dffa5aff835c', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : la bande A2', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d290241e-cfb7-5fec-9106-e15a2dde0e83', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Grammaire — Pose la question correspondant à la réponse soulignée : « Je pars __à la gare__. »', '[{"id":"a","text":"Où est-ce que tu pars ?"},{"id":"b","text":"Quand est-ce que tu pars ?"},{"id":"c","text":"Comment est-ce que tu pars ?"},{"id":"d","text":"Pourquoi est-ce que tu pars ?"}]'::jsonb, 'a', 'La réponse « à la gare » indique un lieu, donc on interroge avec où : Où est-ce que tu pars ? « Quand » demande un moment, « Comment » un moyen, et « Pourquoi » une cause — aucun ne correspond à un lieu.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b50a54f-3c82-5313-898f-684ed580b7d9', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Vocabulaire — Choisis le mot juste : « Pour acheter du pain, je vais à la ___. »', '[{"id":"a","text":"pharmacie"},{"id":"b","text":"librairie"},{"id":"c","text":"banque"},{"id":"d","text":"boulangerie"}]'::jsonb, 'd', 'On achète le pain à la boulangerie. La pharmacie vend des médicaments, la librairie des livres, et la banque gère l''argent : ce sont de faux amis du quotidien, mais seule la boulangerie vend du pain.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d0d05a7-a4b6-56ec-9c02-63e7161d8524', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Orthographe — Choisis la phrase où l''accord du participe passé est CORRECT.', '[{"id":"a","text":"Les lettres que j''ai écrit sont longues."},{"id":"b","text":"Les lettres que j''ai écrites sont longue."},{"id":"c","text":"Les lettres que j''ai écrit sont longue."},{"id":"d","text":"Les lettres que j''ai écrites sont longues."}]'::jsonb, 'd', 'Avec avoir, le participe passé s''accorde avec le COD placé avant : « les lettres » (féminin pluriel) → écrites ; et l''adjectif « longues » s''accorde aussi (féminin pluriel). (a) et (c) oublient l''accord du participe, (b) oublie l''accord de l''adjectif. Piège courant : avec avoir on n''accorde que si le COD précède le verbe.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3cd46f4d-b126-5f8f-b73a-e037cb5cbad1', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Conjugaison — Complète : « Hier, pendant que je ___ , le téléphone ___. »', '[{"id":"a","text":"lisais … sonnait"},{"id":"b","text":"ai lu … a sonné"},{"id":"c","text":"lisais … a sonné"},{"id":"d","text":"ai lu … sonnait"}]'::jsonb, 'c', 'L''action en cours qui sert de décor va à l''imparfait (je lisais), et l''action brève qui survient va au passé composé (a sonné). Tout à l''imparfait (a) efface l''événement soudain ; tout au passé composé (b) supprime le décor ; (d) inverse les deux temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc2d2a36-24a1-5600-aa3a-26a656d1b10f', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Grammaire — Complète avec la bonne préposition de temps : « J''habite à Tunis ___ trois ans. »', '[{"id":"a","text":"pendant"},{"id":"b","text":"depuis"},{"id":"c","text":"dans"},{"id":"d","text":"il y a"}]'::jsonb, 'b', 'Pour une action commencée dans le passé et qui dure encore, on emploie depuis : depuis trois ans. « pendant » indique une durée terminée, « dans » un moment futur (dans trois ans), et « il y a » un point passé achevé (il y a trois ans).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c38227d9-b30e-516b-b058-fa91c6cc6b2e', '95bca5a9-b300-547e-b4c8-560b08dcec4d', 'Lecture — Lis : « Mercredi, Nora a eu une longue journée. Le matin, elle a passé un examen ; à midi, elle a déjeuné avec une amie ; et le soir, fatiguée, elle s''est couchée très tôt. » Pourquoi Nora s''est-elle couchée tôt ?', '[{"id":"a","text":"Parce qu''elle avait un examen le lendemain."},{"id":"b","text":"Parce qu''elle était fatiguée."},{"id":"c","text":"Parce qu''elle a déjeuné tard."},{"id":"d","text":"Parce qu''elle n''aimait pas son amie."}]'::jsonb, 'b', 'Le texte précise « le soir, fatiguée, elle s''est couchée très tôt » : la cause donnée est la fatigue (b). Un examen le lendemain (a) n''est pas mentionné, l''heure du déjeuner (c) n''est pas en cause, et rien n''indique un problème avec l''amie (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('faa33f79-933d-5774-a6fd-1ae54d170732', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bfe9cb4-6f0c-5d57-bd71-a6be8622cc6d', 'faa33f79-933d-5774-a6fd-1ae54d170732', 'Conjugaison — Plus-que-parfait : « Quand je suis arrivé, le train ___ déjà parti. »', '[{"id":"a","text":"a"},{"id":"b","text":"était"},{"id":"c","text":"est"},{"id":"d","text":"avait"}]'::jsonb, 'b', 'Une action antérieure à une autre action passée se met au plus-que-parfait : auxiliaire à l''imparfait + participe. « Partir » se conjugue avec être, donc « le train était parti ». « a » et « est » sont au présent, et « avait parti » utilise le mauvais auxiliaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed5966f6-b646-5ed3-903a-73cdfe48cf04', 'faa33f79-933d-5774-a6fd-1ae54d170732', 'Grammaire — Pronoms compléments : « Tu parles à tes voisins ? — Oui, je ___ parle souvent. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'c', '« Parler à quelqu''un » est un complément indirect : on remplace « à tes voisins » par le pronom COI « leur ». « les » serait un COD, « y » remplace « à + chose », et « en » remplace « de + chose ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0f9849f-015a-5a52-a8a0-31a89bc25329', 'faa33f79-933d-5774-a6fd-1ae54d170732', 'Grammaire — Pronoms relatifs : « C''est le livre ___ je t''ai parlé hier. »', '[{"id":"a","text":"dont"},{"id":"b","text":"que"},{"id":"c","text":"qui"},{"id":"d","text":"où"}]'::jsonb, 'a', '« Parler de quelque chose » : le complément est introduit par « de », donc on emploie « dont ». « que » remplacerait un COD direct, « qui » un sujet, et « où » un lieu ou un temps.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ac7789-4194-58a2-a4f2-3608b41b6dbb', 'faa33f79-933d-5774-a6fd-1ae54d170732', 'Conjugaison — Subjonctif présent : « Il faut que tu ___ à l''heure demain. »', '[{"id":"a","text":"es"},{"id":"b","text":"seras"},{"id":"c","text":"serais"},{"id":"d","text":"sois"}]'::jsonb, 'd', '« Il faut que » exprime l''obligation et entraîne le subjonctif. Le subjonctif du verbe être à la 2e personne est « que tu sois ». « es » est l''indicatif présent, « seras » le futur, et « serais » le conditionnel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('147d53e9-9d96-5ad5-921e-d152d30d26c5', 'faa33f79-933d-5774-a6fd-1ae54d170732', 'Conjugaison — Hypothèse : « Si j''avais plus de temps, je ___ une nouvelle langue. »', '[{"id":"a","text":"apprendrai"},{"id":"b","text":"apprendrais"},{"id":"c","text":"apprenais"},{"id":"d","text":"apprends"}]'::jsonb, 'b', '« Si » + imparfait exprime l''irréel du présent et appelle le conditionnel présent dans la principale : « j''apprendrais ». « apprendrai » est le futur, « apprenais » l''imparfait, et « apprends » le présent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('16e510d1-2e86-54c8-b241-0f39285d815a', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', '⭐ Entraînement : la bande B1', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aeb2b991-d21a-549d-87a1-a45f2196756b', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Grammaire — Pronoms compléments : « Tu vois Marie aujourd''hui ? — Oui, je ___ vois ce soir. »', '[{"id":"a","text":"lui"},{"id":"b","text":"en"},{"id":"c","text":"la"},{"id":"d","text":"y"}]'::jsonb, 'c', '« Voir quelqu''un » est un complément direct (sans préposition), donc on remplace « Marie » par le COD « la » : je la vois. « lui » serait un COI, « en » remplace « de + chose », et « y » remplace « à + chose » ou un lieu.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8ddcb36-0755-566d-b4c6-bd71db27e59c', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Conjugaison — Plus-que-parfait : « Elle ___ déjà mangé quand ses amis sont arrivés. »', '[{"id":"a","text":"a"},{"id":"b","text":"avait"},{"id":"c","text":"était"},{"id":"d","text":"avais"}]'::jsonb, 'b', 'Le plus-que-parfait = auxiliaire à l''imparfait + participe. « Manger » se conjugue avec avoir, donc « elle avait mangé ». « a mangé » est le passé composé, « était » serait le mauvais auxiliaire, et « avais » est la 1re/2e personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85f52a7b-7c60-5ddd-ad71-b25ba8b6b67e', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Vocabulaire — Quel mot est l''intrus ?', '[{"id":"a","text":"le chômage"},{"id":"b","text":"un salaire"},{"id":"c","text":"un entretien"},{"id":"d","text":"un collègue"}]'::jsonb, 'a', 'Un salaire, un entretien et un collègue font partie de la vie en emploi, tandis que le chômage désigne l''absence d''emploi : c''est l''intrus. On trie par sens : trois mots tournent autour du travail qu''on a, le quatrième de sa perte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f31096e0-7f48-5ae5-ae49-3d3292f8f76d', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Grammaire — Pronoms relatifs : « Voici la maison ___ j''ai grandi. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'd', '« Grandir dans un lieu » : le relatif marque le lieu, donc « où » : la maison où j''ai grandi. « qui » serait sujet, « que » un COD, et « dont » un complément introduit par « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fafa8517-0e08-57a1-bc36-ce8397c0a266', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Lecture — Lis : « Hier, Sami est rentré tard. Il avait raté son bus, puis il avait dû marcher sous la pluie. »
Pourquoi Sami est-il rentré tard ?', '[{"id":"a","text":"Parce qu''il s''est réveillé en retard."},{"id":"b","text":"Parce qu''il avait raté son bus."},{"id":"c","text":"Parce qu''il a perdu ses clés."},{"id":"d","text":"Parce qu''il a oublié son travail."}]'::jsonb, 'b', 'Le texte dit qu''il « avait raté son bus » puis « dû marcher sous la pluie », ce qui explique le retard (b). Une réponse de lecture vient du texte : le réveil, les clés et l''oubli ne sont jamais mentionnés.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('346eb26c-bc2c-5142-8d5a-95a6d16af470', '16e510d1-2e86-54c8-b241-0f39285d815a', 'Orthographe — Choisis le participe passé correct : « Les lettres que j''ai ___ sont parties ce matin. »', '[{"id":"a","text":"écrites"},{"id":"b","text":"écrit"},{"id":"c","text":"écris"},{"id":"d","text":"écrient"}]'::jsonb, 'a', 'Avec l''auxiliaire avoir, le participe s''accorde avec le COD placé avant : « les lettres » (féminin pluriel) → écrites. « écrit » oublie l''accord, « écris » est une forme conjuguée du présent, et « écrient » n''existe pas.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('372a6c15-10de-5fb9-8037-b5db1127c79c', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', '⭐⭐ Révision : la bande B1', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbb5c5ea-ac20-5c28-a5ec-c2e5f64e2e89', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Grammaire — Pronoms compléments : « Tu as besoin de ces documents ? — Oui, j''___ ai besoin. »', '[{"id":"a","text":"les"},{"id":"b","text":"y"},{"id":"c","text":"leur"},{"id":"d","text":"en"}]'::jsonb, 'd', '« Avoir besoin de » se construit avec « de », donc on remplace par « en » : j''en ai besoin. « les » serait un COD, « leur » un COI personne, et « y » remplace « à + chose ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b838bd8e-f98a-5e07-b641-c66b8b4865a1', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Vocabulaire — Complète : « Le patron a décidé de ___ trois employés à cause de la crise. »', '[{"id":"a","text":"démissionner"},{"id":"b","text":"licencier"},{"id":"c","text":"postuler"},{"id":"d","text":"embaucher"}]'::jsonb, 'b', 'C''est le patron qui renvoie ses employés : on emploie « licencier ». « démissionner », c''est l''employé qui part de lui-même ; « postuler », c''est candidater ; « embaucher », c''est engager — l''inverse de licencier.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76a8841e-6fc8-5c0e-a9c0-4202611b7ed2', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Conjugaison — Subjonctif présent : « Je suis content que vous ___ venir à la fête. »', '[{"id":"a","text":"pouvez"},{"id":"b","text":"pourrez"},{"id":"c","text":"puissiez"},{"id":"d","text":"pouviez"}]'::jsonb, 'c', '« Être content que » exprime une émotion et appelle le subjonctif. Le subjonctif de pouvoir à « vous » est « que vous puissiez ». « pouvez » est l''indicatif présent, « pourrez » le futur, et « pouviez » l''imparfait de l''indicatif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4a0189c-f905-5b00-a4a4-2f2376af88c3', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Conjugaison — Plus-que-parfait : « Nous étions fatigués car nous ___ toute la nuit. »', '[{"id":"a","text":"avions travaillé"},{"id":"b","text":"avons travaillé"},{"id":"c","text":"travaillions"},{"id":"d","text":"étions travaillé"}]'::jsonb, 'a', 'La fatigue est postérieure au travail de la nuit : l''action antérieure se met au plus-que-parfait, « nous avions travaillé ». « avons travaillé » est le passé composé, « travaillions » l''imparfait, et « étions travaillé » utilise le mauvais auxiliaire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5bc1a63-cf00-579c-8fcc-c689c96af150', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Grammaire — Discours indirect : « Léa demande : “Où vas-tu ?” → Léa demande ___ je vais. »', '[{"id":"a","text":"que"},{"id":"b","text":"si"},{"id":"c","text":"où"},{"id":"d","text":"ce que"}]'::jsonb, 'c', 'Dans le discours indirect, le mot interrogatif « où » se conserve, et l''inversion disparaît : Léa demande où je vais. « que » introduit une déclarative, « si » une question oui/non, et « ce que » correspond à « qu''est-ce que ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30792b3b-04e2-5ea6-808b-d3f39556d54d', '372a6c15-10de-5fb9-8037-b5db1127c79c', 'Orthographe — Choisis la forme correcte : « Les décisions qu''ils ont ___ étaient justes. »', '[{"id":"a","text":"pris"},{"id":"b","text":"prit"},{"id":"c","text":"prient"},{"id":"d","text":"prises"}]'::jsonb, 'd', 'Avec avoir, le participe s''accorde avec le COD placé avant : « les décisions » (féminin pluriel) → prises. « pris » oublie l''accord, « prit » est le passé simple, et « prient » est une forme du verbe prier.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1a0818e0-883e-59a5-84bb-7c17bff1de69', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : la bande B1', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('506eab54-cd1a-5d73-9a28-d931b9750276', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Vocabulaire — Complète la collocation : « Avant l''examen, il faut ___ des efforts pour réviser. »', '[{"id":"a","text":"prendre"},{"id":"b","text":"donner"},{"id":"c","text":"faire"},{"id":"d","text":"mettre"}]'::jsonb, 'c', 'La collocation figée est « faire des efforts ». On dit « prendre une décision » mais « faire des efforts » : le verbe n''est pas interchangeable. « donner » et « mettre » ne s''emploient pas avec « efforts » dans ce sens.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c1de1cb-74b8-54fd-ba20-19bec74d4c63', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Conjugaison — Hypothèse, irréel du passé : « Si tu m''avais prévenu, je ___ t''aider. »', '[{"id":"a","text":"aurais pu"},{"id":"b","text":"pourrais"},{"id":"c","text":"aurai pu"},{"id":"d","text":"pouvais"}]'::jsonb, 'a', 'Si + plus-que-parfait (« avais prévenu ») exprime l''irréel du passé et appelle le conditionnel passé : « j''aurais pu ». « pourrais » est le conditionnel présent (irréel du présent), « aurai pu » est le futur antérieur, et « pouvais » l''imparfait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3507030f-6c8b-5b68-9216-745d30fddbe7', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Conjugaison — Subjonctif présent : « Bien qu''il ___ malade, il est venu travailler. »', '[{"id":"a","text":"est"},{"id":"b","text":"soit"},{"id":"c","text":"était"},{"id":"d","text":"serait"}]'::jsonb, 'b', 'La conjonction « bien que » entraîne toujours le subjonctif : « bien qu''il soit malade ». « est » et « était » sont à l''indicatif (présent et imparfait), et « serait » est le conditionnel — aucun n''est admis après « bien que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89f86bda-d40c-5e03-930d-87b63db44000', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Grammaire — Doubles pronoms : « Tu donnes ce cadeau à Paul ? — Oui, je ___ donne. »', '[{"id":"a","text":"lui le"},{"id":"b","text":"le lui en"},{"id":"c","text":"y le"},{"id":"d","text":"le lui"}]'::jsonb, 'd', '« Le cadeau » est COD (le) et « à Paul » est COI (lui) ; l''ordre fixe place le COD avant le COI de 3e personne : « je le lui donne ». « lui le » inverse l''ordre, « y » remplacerait une chose, et « en » n''a pas lieu d''être ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e43af1f-12a1-5fa0-b553-eac020b6a873', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Lecture — Lis : « Karim avait économisé pendant deux ans. Quand il a enfin acheté sa voiture, il n''a pas eu besoin d''emprunter. »
Qu''est-ce qui est VRAI ?', '[{"id":"a","text":"Karim a emprunté de l''argent à la banque."},{"id":"b","text":"Karim a acheté sa voiture sans avoir épargné."},{"id":"c","text":"Karim a payé sa voiture grâce à ses économies."},{"id":"d","text":"Karim a renoncé à acheter une voiture."}]'::jsonb, 'c', 'Le texte dit qu''il « avait économisé pendant deux ans » et n''a « pas eu besoin d''emprunter » : il a donc payé avec ses économies (c). Il n''a pas emprunté (a faux), il avait bien épargné (b faux), et il a acheté la voiture (d faux).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4424c179-2ed0-5b40-b12c-539029761b67', '1a0818e0-883e-59a5-84bb-7c17bff1de69', 'Orthographe — Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Si j''aurais su, je serais resté."},{"id":"b","text":"Je voudrais un café, s''il vous plaît."},{"id":"c","text":"Quand il sera prêt, nous partirons."},{"id":"d","text":"Il faut que nous fassions vite."}]'::jsonb, 'a', 'L''erreur est (a) : après « si », jamais de conditionnel — il faut « Si j''avais su, je serais resté ». (b) est un conditionnel de politesse correct, (c) un futur après « quand » correct, et (d) un subjonctif correct après « il faut que ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'db17704d-40d6-5d56-949b-cb44b1eaaf77', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : la bande B1', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c2beb0c-73e2-520b-8c9e-aeeb65c48c54', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Lecture — Lis : « Avant de déménager, Nora avait vécu dix ans à Lyon. Aujourd''hui, elle habite à Tunis, mais elle pense souvent à ses anciens voisins. »
Qu''est-ce qui est VRAI ?', '[{"id":"a","text":"Nora habite encore à Lyon."},{"id":"b","text":"Nora a habité à Lyon avant Tunis."},{"id":"c","text":"Nora n''a jamais quitté Tunis."},{"id":"d","text":"Nora a oublié ses anciens voisins."}]'::jsonb, 'b', 'Le plus-que-parfait « avait vécu dix ans à Lyon » place ce séjour avant le déménagement à Tunis (b). Elle habite désormais à Tunis (a faux), elle a donc bien vécu ailleurs (c faux), et elle pense « souvent » à ses voisins (d faux).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b101920-9662-59a2-9bbe-7a89458ab0fa', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Grammaire — Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Le projet dont je suis fier est terminé."},{"id":"b","text":"Si j''avais le temps, je voyagerais davantage."},{"id":"c","text":"Il faut que tu prennes une décision."},{"id":"d","text":"Je cherche la personne que m''a aidé."}]'::jsonb, 'd', 'L''erreur est (d) : la personne fait l''action d''aider, c''est le sujet de la relative, donc il faut « qui m''a aidé », pas « que ». (a) emploie correctement « dont » (être fier de), (b) est une hypothèse correcte, et (c) un subjonctif correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0247e9f-9b77-5f27-bf94-d216d83d3a26', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Grammaire — Discours indirect au passé : « Il a dit : “Je finirai demain.” → Il a dit qu''il ___ le lendemain. »', '[{"id":"a","text":"finirait"},{"id":"b","text":"finira"},{"id":"c","text":"finissait"},{"id":"d","text":"avait fini"}]'::jsonb, 'a', 'Avec un verbe introducteur au passé, le futur devient conditionnel présent : « finira » → « finirait ». De plus, « demain » devient « le lendemain ». « finira » garde le futur (faux), « finissait » est l''imparfait, et « avait fini » correspond à un passé composé rapporté.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0576dd35-263e-5486-8ee4-b821d7777fe5', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Conjugaison — Hypothèse : « Si nous ___ tôt, nous éviterions les embouteillages. »', '[{"id":"a","text":"partirons"},{"id":"b","text":"partirions"},{"id":"c","text":"partions"},{"id":"d","text":"serions partis"}]'::jsonb, 'c', 'La principale « nous éviterions » est au conditionnel présent (irréel du présent), donc la subordonnée en « si » prend l''imparfait : « si nous partions ». « partirons » est le futur (interdit après si), « partirions » un conditionnel (interdit après si), et « serions partis » l''irréel du passé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a6a9efb-c8c4-5acb-b7ec-0fd44c9f2403', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Conjugaison — Subjonctif présent : « Je ne pense pas qu''il ___ raison sur ce point. »', '[{"id":"a","text":"a"},{"id":"b","text":"ait"},{"id":"c","text":"aura"},{"id":"d","text":"aurait"}]'::jsonb, 'b', '« Je ne pense pas que » exprime le doute et appelle le subjonctif : « qu''il ait raison ». Le piège : à la forme affirmée « je pense qu''il a raison » garde l''indicatif, mais la négation impose le subjonctif. « aura » est le futur, « aurait » le conditionnel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39b39c02-a6b9-5747-963c-0e8d1ba79f48', 'a4650d30-ed13-5e1e-b35a-e3b87a2a1768', 'Vocabulaire — Choisis le mot qui complète le mieux : « Pour réduire ses déchets, la ville encourage les habitants à ___ leurs ordures. »', '[{"id":"a","text":"gaspiller"},{"id":"b","text":"polluer"},{"id":"c","text":"embaucher"},{"id":"d","text":"trier"}]'::jsonb, 'd', 'Pour réduire les déchets, on les « trie » afin de les recycler : c''est le verbe attendu. « gaspiller » (jeter en pure perte) et « polluer » aggraveraient le problème, et « embaucher » appartient au champ du travail, pas de l''écologie.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fe453eaa-4fc3-57ed-99d5-a17b44131146', '5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0d09024-291a-5b3f-b681-c5214358900c', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', 'Grammaire — Voix passive : mets à la voix passive « Le jury récompensera les lauréats. »', '[{"id":"a","text":"Les lauréats seront récompensés par le jury."},{"id":"b","text":"Les lauréats sont récompensés par le jury."},{"id":"c","text":"Les lauréats ont été récompensés par le jury."},{"id":"d","text":"Les lauréats seraient récompensés par le jury."}]'::jsonb, 'a', 'Le verbe actif est au futur (récompensera), donc le passif garde le futur : seront récompensés. (b) est au présent, (c) au passé composé, (d) au conditionnel — tous changent le temps de la phrase d''origine.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03cc0c18-b3b6-5e0e-bc49-d74e295863ca', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', 'Grammaire — Cause, conséquence ou but : « Il s''entraîne dur ___ remporter le tournoi. » Quel mot exprime le but ?', '[{"id":"a","text":"parce qu''il veut"},{"id":"b","text":"afin de"},{"id":"c","text":"si bien qu''il"},{"id":"d","text":"puisqu''il veut"}]'::jsonb, 'b', 'Le but se marque par « afin de + infinitif » (même sujet) : afin de remporter. (a) « parce que » et (d) « puisque » expriment la cause ; (c) « si bien que » exprime la conséquence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5c98060-fc2c-516d-b5b2-673fef901ff9', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', 'Grammaire — Gérondif : « ___ ses devoirs, Léa écoute de la musique. » (action simultanée)', '[{"id":"a","text":"Faisant"},{"id":"b","text":"Fait"},{"id":"c","text":"En faisant"},{"id":"d","text":"Pour faire"}]'::jsonb, 'c', 'La simultanéité de deux actions du même sujet s''exprime par le gérondif « en + -ant » : En faisant ses devoirs. (a) « Faisant » est un participe présent (plutôt cause/circonstance) ; (b) « Fait » est un participe passé ; (d) « Pour faire » exprime le but.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70511aba-0b65-577c-84e7-cd66615cfa8c', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', 'Conjugaison — Subjonctif passé : « Je suis content qu''il ___ son examen. »', '[{"id":"a","text":"réussit"},{"id":"b","text":"réussira"},{"id":"c","text":"ait réussi"},{"id":"d","text":"a réussi"}]'::jsonb, 'c', '« Être content que » exige le subjonctif, et l''action est accomplie (antériorité) : subjonctif passé « qu''il ait réussi ». (a) « réussit » et (d) « a réussi » sont à l''indicatif ; (b) « réussira » est un futur de l''indicatif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a38af0d-6a61-520e-b5e6-f1d6fc1c011f', 'fe453eaa-4fc3-57ed-99d5-a17b44131146', 'Grammaire — Pronom relatif composé : « C''est l''entreprise pour ___ je travaille. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"dont"},{"id":"d","text":"laquelle"}]'::jsonb, 'd', 'Après la préposition « pour » et pour une chose (l''entreprise), on emploie le relatif composé « laquelle » : pour laquelle je travaille. « qui » s''emploie surtout pour les personnes après préposition ; « que » est COD sans préposition ; « dont » remplace « de » et ne suit pas « pour ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('334107c5-53de-5cf9-a526-984ea95e4a05', '5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', '⭐ Entraînement : la bande B2', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4be7aa6b-bd42-5436-87d9-ed612142a74e', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Grammaire — Voix passive : choisis la forme passive correcte. « Ce roman ___ par des millions de lecteurs. »', '[{"id":"a","text":"lit"},{"id":"b","text":"a lu"},{"id":"c","text":"est lu"},{"id":"d","text":"lisant"}]'::jsonb, 'c', 'Le roman subit l''action (il est lu), donc passif présent : être + participe passé = « est lu ». « lit » et « a lu » sont actifs (le roman lirait lui-même) ; « lisant » est un participe présent, pas une forme conjuguée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dfba2c3-fcbb-5ab0-a99b-24763438afe7', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Conjugaison — Subjonctif : après « bien que », quel mode emploie-t-on ? « Bien qu''il ___ fatigué, il continue. »', '[{"id":"a","text":"soit"},{"id":"b","text":"est"},{"id":"c","text":"sera"},{"id":"d","text":"serait"}]'::jsonb, 'a', '« Bien que » commande toujours le subjonctif : « bien qu''il soit fatigué ». « est » (indicatif présent), « sera » (futur) et « serait » (conditionnel) sont des modes incorrects après cette conjonction de concession.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eec301d4-5b01-5fc4-b316-ac3ec1e3f115', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Grammaire — Cause : quel mot introduit une cause connue et admise ? « ___ tu es là, aide-moi. »', '[{"id":"a","text":"Pour que"},{"id":"b","text":"Afin que"},{"id":"c","text":"Si bien que"},{"id":"d","text":"Puisque"}]'::jsonb, 'd', '« Puisque » introduit une cause déjà connue de l''interlocuteur : « Puisque tu es là ». « Pour que » et « Afin que » expriment le but ; « si bien que » exprime la conséquence.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2022237c-7d13-5cb8-87e2-f11d3004db69', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Grammaire — Concession : complète. « ___ il pleuve, nous partirons en randonnée. »', '[{"id":"a","text":"Parce qu''"},{"id":"b","text":"Bien qu''"},{"id":"c","text":"Puisqu''"},{"id":"d","text":"Étant donné qu''"}]'::jsonb, 'b', 'La concession (un obstacle qu''on ignore) se marque par « bien que » + subjonctif : « Bien qu''il pleuve ». Les trois autres (« parce que », « puisque », « étant donné que ») introduisent une cause, pas une concession.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9eb52327-4d87-5aff-b810-16aa3e0e4623', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Grammaire — Pronom relatif composé : « Voici le stylo avec ___ j''écris. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"lequel"},{"id":"d","text":"dont"}]'::jsonb, 'c', 'Après la préposition « avec » et pour une chose (le stylo), on emploie « lequel » : « avec lequel j''écris ». « qui » sert surtout aux personnes après préposition ; « que » est COD sans préposition ; « dont » remplace « de ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d387fbc-ffdd-5454-b468-b107352c6776', '334107c5-53de-5cf9-a526-984ea95e4a05', 'Vocabulaire — Paronymes : choisis le mot juste. « Mon professeur est très ___ : il accepte mes retards. »', '[{"id":"a","text":"compréhensif"},{"id":"b","text":"compréhensible"},{"id":"c","text":"compréhension"},{"id":"d","text":"incompris"}]'::jsonb, 'a', '« Compréhensif » qualifie une personne indulgente, tolérante : un professeur compréhensif. « Compréhensible » signifie « clair, facile à comprendre » (un texte compréhensible) ; « compréhension » est un nom ; « incompris » signifie « non compris ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b5909b0-5eea-5d3e-852f-4a5327d12691', '5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', '⭐⭐ Révision : la bande B2', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14fcfeab-69d1-50fa-a79c-5e22d984efbd', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Grammaire — Voix passive : quel complément d''agent est correct ? « Le sommet était couvert ___ neige. »', '[{"id":"a","text":"par la"},{"id":"b","text":"de"},{"id":"c","text":"avec la"},{"id":"d","text":"à la"}]'::jsonb, 'b', 'Après un verbe de description ou d''état (couvert, entouré, rempli), le complément d''agent s''introduit par « de » : couvert de neige. « par la » convient pour une action réelle (couvert par un drap), mais ici c''est un état descriptif ; « avec » et « à » ne sont pas des compléments d''agent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d98df212-90cc-5f2e-9741-4360340f518a', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Conjugaison — Subjonctif passé : « C''est le meilleur film que j''___ jamais vu. »', '[{"id":"a","text":"ai"},{"id":"b","text":"avais"},{"id":"c","text":"aurai"},{"id":"d","text":"aie"}]'::jsonb, 'd', 'Après un superlatif (« le meilleur »), on emploie le subjonctif ; l''action étant accomplie, c''est le subjonctif passé : « que j''aie jamais vu ». « ai » (indicatif), « avais » (plus-que-parfait) et « aurai » (futur antérieur) sont des temps de l''indicatif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e15bfd1-ce2a-5c65-9eb3-1cca79c0807c', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Grammaire — Conséquence : complète. « Il a tellement crié ___ il a perdu sa voix. »', '[{"id":"a","text":"qu''"},{"id":"b","text":"pour qu''"},{"id":"c","text":"bien qu''"},{"id":"d","text":"afin qu''"}]'::jsonb, 'a', '« Tellement… que » exprime la conséquence et se construit avec l''indicatif : « tellement crié qu''il a perdu sa voix ». « pour que » et « afin que » marquent le but (+ subjonctif) ; « bien que » marque la concession.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ba174a4-43a8-58ae-9a2a-0fcab0b92949', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Orthographe — Dans « ___ tu fasses, fais-le avec soin », quelle forme convient et pourquoi ?', '[{"id":"a","text":"« Quoique », car il signifie « bien que »."},{"id":"b","text":"« Quoi que », car il signifie « quelle que soit la chose que »."},{"id":"c","text":"« Quoi-que », forme avec trait d''union."},{"id":"d","text":"« Quoiqu'' », forme élidée obligatoire ici."}]'::jsonb, 'b', '« Quoi que » en deux mots signifie « quelle que soit la chose que » : « Quoi que tu fasses » = peu importe ce que tu fais (b). « Quoique » en un mot signifie « bien que » (concession) et ne convient pas ; « quoi-que » avec trait d''union n''existe pas ; l''élision « quoiqu'' » ne se fait que devant une voyelle (quoiqu''il…), pas devant « tu ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08fdae41-28f9-5d13-ba34-d4babca6302e', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Vocabulaire — Débat : quel verbe signifie « rejeter un argument par un raisonnement contraire » ?', '[{"id":"a","text":"concéder"},{"id":"b","text":"nuancer"},{"id":"c","text":"soutenir"},{"id":"d","text":"réfuter"}]'::jsonb, 'd', '« Réfuter » signifie démontrer qu''un argument est faux : réfuter une thèse. « Concéder » = admettre un point adverse ; « nuancer » = atténuer une affirmation ; « soutenir » = défendre une opinion. Ce sont les pièces clés du vocabulaire argumentatif B2.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53944c69-cf4e-59c0-be10-6ca785ff6fa6', '6b5909b0-5eea-5d3e-852f-4a5327d12691', 'Grammaire — Pronom relatif composé : « Le sujet ___ je m''intéresse est complexe. » (s''intéresser à)', '[{"id":"a","text":"dont"},{"id":"b","text":"que"},{"id":"c","text":"auquel"},{"id":"d","text":"duquel"}]'::jsonb, 'c', '« S''intéresser à » se construit avec « à » ; pour une chose, « à + lequel » se contracte en « auquel » : le sujet auquel je m''intéresse. « dont » et « duquel » correspondraient à « de » (s''intéresser de est incorrect) ; « que » ne reprend aucune préposition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', '5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : la bande B2', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d26595d-cfda-5bca-9501-2423fd62464a', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Conjugaison — Subjonctif passé : « Pars avant qu''il ne ___ trop tard. »', '[{"id":"a","text":"est"},{"id":"b","text":"sera"},{"id":"c","text":"serait"},{"id":"d","text":"soit"}]'::jsonb, 'd', '« Avant que » impose le subjonctif présent ici : « avant qu''il ne soit trop tard ». ✓ Le piège courant est de mettre l''indicatif « est » ou le futur « sera » par analogie avec le sens futur, mais la conjonction « avant que » bloque l''indicatif. « serait » est un conditionnel, exclu lui aussi.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a2a1fed-1935-5417-9fe7-6d841def4879', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Grammaire — Voix passive (temps composé) : « Les résultats ___ par le comité depuis ce matin. »', '[{"id":"a","text":"ont été publiés"},{"id":"b","text":"ont publié"},{"id":"c","text":"sont publiant"},{"id":"d","text":"avaient publié"}]'::jsonb, 'a', '« Depuis ce matin » appelle le passé composé, et les résultats subissent l''action : passif au passé composé = avoir été + participe = « ont été publiés ». ✓ « ont publié » et « avaient publié » sont actifs (les résultats ne publient pas) ; « sont publiant » n''existe pas en français.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35deabcd-ae19-5e50-a756-515fb12f3acd', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Grammaire — Pronom relatif composé : « La colline au sommet ___ se dresse un château. »', '[{"id":"a","text":"dont"},{"id":"b","text":"que"},{"id":"c","text":"de laquelle"},{"id":"d","text":"à laquelle"}]'::jsonb, 'c', 'Après une locution prépositionnelle en « de » (au sommet de), on emploie le relatif composé, pas « dont » : « au sommet de laquelle ». ✓ Le piège courant est de mettre « dont », mais « dont » est interdit quand la préposition « de » est déjà incluse dans une locution. « à laquelle » correspondrait à « à », non à « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1372d6b2-c3b9-5fc5-a274-b8acbfe34b8b', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Grammaire — Gérondif vs participe présent : « ___ très matinale, elle est rarement fatiguée le soir. » (cause)', '[{"id":"a","text":"En étant"},{"id":"b","text":"Étant"},{"id":"c","text":"Été"},{"id":"d","text":"Pour être"}]'::jsonb, 'b', 'Pour exprimer la cause par une circonstance, on emploie le participe présent seul : « Étant très matinale, elle… ». ✓ Le gérondif « en étant » insisterait sur la simultanéité, pas sur la cause ; « Été » est un participe passé ; « Pour être » exprimerait le but.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffdbdbb7-b4e8-50ba-a017-bcec81b53f67', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Vocabulaire — Paronymes : choisis le mot juste. « Un danger ___ menace la ville : l''éruption est attendue d''une heure à l''autre. »', '[{"id":"a","text":"éminent"},{"id":"b","text":"imminent"},{"id":"c","text":"immanent"},{"id":"d","text":"éminemment"}]'::jsonb, 'b', '« Imminent » signifie « sur le point de se produire » : un danger imminent. ✓ Le piège courant est « éminent », qui veut dire « remarquable, supérieur » (un savant éminent). « Immanent » est un terme philosophique (présent dans la nature même), et « éminemment » est un adverbe.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99c9a2a8-c466-5447-a256-f0e8783079a5', '9fbe386b-b94c-5c70-aac9-59ffdaabc4cb', 'Lecture — Compréhension argumentative : « Certes, la mesure coûte cher ; en revanche, elle sauve des vies. » Quelle est la position du locuteur ?', '[{"id":"a","text":"Il défend la mesure tout en admettant un inconvénient."},{"id":"b","text":"Il rejette totalement la mesure."},{"id":"c","text":"Il reste neutre, sans prendre parti."},{"id":"d","text":"Il pense que la mesure est inutile et coûteuse."}]'::jsonb, 'a', '« Certes… en revanche » est un mouvement de concession-opposition : on admet d''abord un point (le coût) pour mieux faire valoir l''argument fort (sauver des vies). ✓ Le locuteur soutient donc la mesure. Le piège est de s''arrêter au « coûte cher » et de croire qu''il la rejette, alors que « en revanche » renverse l''argumentation en sa faveur.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8e529f8-2fdf-5e96-9275-98c4789e9ff4', '5b01551b-ac98-568c-a147-d7fa184db75f', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : la bande B2', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce080795-34ef-57d7-88c9-868aa56f24a7', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Grammaire — Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Bien qu''elle soit partie, son parfum flotte encore."},{"id":"b","text":"Après qu''il ait terminé, nous sommes sortis."},{"id":"c","text":"Je doute qu''ils aient compris la consigne."},{"id":"d","text":"Pour qu''il réussisse, aidons-le."}]'::jsonb, 'b', 'L''erreur est en (b) : « après que » exige l''indicatif, pas le subjonctif — il faut « après qu''il a terminé ». ✓ Le piège courant est d''aligner « après que » sur « avant que » (qui, lui, demande le subjonctif). (a) « bien que » + subjonctif, (c) « douter que » + subjonctif, (d) « pour que » + subjonctif sont corrects.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d3a13a9-1c72-53fa-b6da-fa88292da9d4', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Grammaire — Pronom relatif composé : « Les principes au nom ___ il se bat sont nobles. »', '[{"id":"a","text":"dont"},{"id":"b","text":"auxquels"},{"id":"c","text":"desquels"},{"id":"d","text":"lesquels"}]'::jsonb, 'c', 'Après la locution prépositionnelle « au nom de », on emploie « de + lesquels » contracté en « desquels » : au nom desquels. ✓ Le piège est « dont », interdit quand « de » fait déjà partie de la locution. « auxquels » correspondrait à « à » ; « lesquels » sans contraction ne reprend pas le « de » de la locution.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22829ffa-3df8-5a9e-b321-c7e15a9b7030', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Orthographe — Adjectif verbal ou participe présent : « Les enfants, ___ dans le jardin, n''ont rien entendu. » (= qui jouaient)', '[{"id":"a","text":"joueurs"},{"id":"b","text":"jouants"},{"id":"c","text":"joueront"},{"id":"d","text":"jouant"}]'::jsonb, 'd', 'Ici la forme exprime une action en cours équivalant à « qui jouaient » : c''est le participe présent, invariable = « jouant ». ✓ Le piège courant est de l''accorder en « jouants » par attraction du pluriel, mais le participe présent ne s''accorde jamais. « joueurs » est un nom ; « joueront » est un futur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('238f648c-fab7-59c7-a0b4-49bc5620a8b9', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Grammaire — Voix passive : trouve la phrase INCORRECTE.', '[{"id":"a","text":"La nouvelle a été appartenue à tous."},{"id":"b","text":"La décision sera prise demain."},{"id":"c","text":"Ce monument est admiré de tous."},{"id":"d","text":"Les lettres ont été envoyées hier."}]'::jsonb, 'a', 'L''erreur est en (a) : « appartenir » est un verbe intransitif (il n''a pas de COD) et ne peut donc pas se mettre au passif. ✓ Le piège est de croire que tout verbe se passive. (b), (c) et (d) reposent sur des verbes transitifs (prendre, admirer, envoyer) et leur passif est correct ; en (c), l''agent suit « de » après un verbe de sentiment.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bb83183-32c4-5d4b-ad3d-eae1b248b625', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Vocabulaire — Paronymes : choisis le mot juste. « Cette affaire de corruption est désormais ___ : tout le monde en parle. »', '[{"id":"a","text":"notable"},{"id":"b","text":"notarié"},{"id":"c","text":"notamment"},{"id":"d","text":"notoire"}]'::jsonb, 'd', '« Notoire » signifie « connu de tous, public » : une affaire notoire. ✓ Le piège courant est « notable », qui signifie « digne d''être remarqué, important » (un progrès notable) — proche mais distinct. « Notarié » concerne un acte établi par un notaire ; « notamment » est un adverbe (= en particulier).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76081722-51e8-51ab-9628-3c66e49f2543', 'e8e529f8-2fdf-5e96-9275-98c4789e9ff4', 'Lecture — Compréhension argumentative : « Loin de nuire à l''économie, cette réforme la stimulera. » Que veut dire le locuteur ?', '[{"id":"a","text":"La réforme risque de nuire à l''économie."},{"id":"b","text":"La réforme aidera l''économie, contrairement à ce qu''on pourrait craindre."},{"id":"c","text":"La réforme est sans effet sur l''économie."},{"id":"d","text":"La réforme nuira d''abord puis aidera l''économie."}]'::jsonb, 'b', '« Loin de + infinitif » nie fortement l''idée qu''il introduit : « loin de nuire » signifie « non seulement elle ne nuit pas, mais au contraire elle stimulera ». ✓ Le piège courant est de retenir le mot « nuire » et d''y voir un danger, alors que « loin de » l''écarte catégoriquement et annonce l''effet inverse, positif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('293422ec-ede5-5a26-87c3-74af11730ddb', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2996d56d-dc78-592c-8506-5a8aa6a5bebb', '293422ec-ede5-5a26-87c3-74af11730ddb', 'Grammaire — Accord du participe passé : « Les lettres qu''elle a ___ hier sont déjà parties. »', '[{"id":"a","text":"écrit"},{"id":"b","text":"écrites"},{"id":"c","text":"écrite"},{"id":"d","text":"écrits"}]'::jsonb, 'b', 'Avec l''auxiliaire « avoir », le participe s''accorde avec le COD placé avant : ici « que » reprend « les lettres » (féminin pluriel), donc « écrites ». « écrit » oublie l''accord, « écrite » oublie le pluriel, « écrits » met un masculin alors que « lettres » est féminin.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff18f17a-f90b-52a2-9916-6f7104ed2740', '293422ec-ede5-5a26-87c3-74af11730ddb', 'Stylistique — Mise en relief : « ___ je redoute le plus, c''est l''échec. »', '[{"id":"a","text":"Ce que"},{"id":"b","text":"Ce qui"},{"id":"c","text":"Ce dont"},{"id":"d","text":"Qu''est-ce que"}]'::jsonb, 'a', '« redouter » est transitif direct : son objet est repris par « ce que » (COD) : « Ce que je redoute, c''est… ». « Ce qui » serait sujet (ce qui me fait peur), « ce dont » remplacerait un complément en « de » (avoir peur DE), « Qu''est-ce que » est une tournure interrogative, pas une mise en relief.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67115058-178a-5ef6-8df3-a5cff0757372', '293422ec-ede5-5a26-87c3-74af11730ddb', 'Vocabulaire — Nominalisation : quel groupe nominal correspond à « les prix ont augmenté » ?', '[{"id":"a","text":"l''augmentage des prix"},{"id":"b","text":"l''augmentement des prix"},{"id":"c","text":"l''augmentition des prix"},{"id":"d","text":"l''augmentation des prix"}]'::jsonb, 'd', 'Le verbe « augmenter » se nominalise en « augmentation » (suffixe -tion) : « l''augmentation des prix ». Les autres formes sont des suffixes inexistants pour ce verbe : « -age », « -ement » et « -ition » ne s''appliquent pas ici et ne figurent dans aucun dictionnaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7aed6e94-8ccc-5ca8-a8f6-de4ebf2f55c7', '293422ec-ede5-5a26-87c3-74af11730ddb', 'Conjugaison — Concordance des temps : « Il m''a affirmé hier qu''il ___ le lendemain. »', '[{"id":"a","text":"viendra"},{"id":"b","text":"vienne"},{"id":"c","text":"viendrait"},{"id":"d","text":"venait"}]'::jsonb, 'c', 'La principale est au passé (« a affirmé ») et la subordonnée exprime un fait postérieur : on emploie le conditionnel présent, futur du passé, soit « viendrait ». « viendra » (futur) ne suit pas un passé, « vienne » est un subjonctif injustifié, « venait » (imparfait) dirait la simultanéité, pas la postériorité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae1cd5f1-eae2-5348-9c48-79490a22be1b', '293422ec-ede5-5a26-87c3-74af11730ddb', 'Vocabulaire — Connecteur logique : « Le projet est coûteux ; ___, le conseil l''a approuvé. »', '[{"id":"a","text":"par conséquent"},{"id":"b","text":"néanmoins"},{"id":"c","text":"en outre"},{"id":"d","text":"à savoir"}]'::jsonb, 'b', 'Les deux faits s''opposent (coûteux MAIS approuvé) : il faut un connecteur de concession, « néanmoins ». « par conséquent » marque la conséquence (l''approbation serait due au coût, ce qui inverse la logique), « en outre » ajoute un argument, « à savoir » introduit une précision.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bc090c07-0eef-5e81-b14b-510ee60169f9', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', '⭐ Entraînement : le défi C1', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3967c0f6-c21e-57f5-9fc2-66141deff268', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Conjugaison — Concordance des temps : « Elle savait qu''il ___ très occupé ce jour-là. »', '[{"id":"a","text":"est"},{"id":"b","text":"sera"},{"id":"c","text":"était"},{"id":"d","text":"soit"}]'::jsonb, 'c', 'La principale est au passé (« savait ») et la subordonnée exprime un fait simultané : on emploie l''imparfait, « était ». « est » (présent) et « sera » (futur) ne suivent pas un verbe au passé, et « soit » est un subjonctif que « savoir » affirmatif n''exige pas.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('771caec2-7bef-500f-8229-8b9a091c7c0f', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Grammaire — Accord du participe passé : « La voiture qu''il a ___ est neuve. »', '[{"id":"a","text":"acheté"},{"id":"b","text":"achetée"},{"id":"c","text":"achetés"},{"id":"d","text":"achetées"}]'::jsonb, 'b', 'Avec « avoir », le participe s''accorde avec le COD placé avant : « que » reprend « la voiture » (féminin singulier), d''où « achetée ». « acheté » oublie l''accord, « achetés » et « achetées » mettent un pluriel injustifié.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f7a3249-d669-5161-bb8d-3563b24701cd', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Vocabulaire — Registre soutenu : quel mot appartient au registre soutenu pour dire « manger » ?', '[{"id":"a","text":"bouffer"},{"id":"b","text":"becter"},{"id":"c","text":"grailler"},{"id":"d","text":"se restaurer"}]'::jsonb, 'd', '« se restaurer » relève du registre soutenu. « bouffer », « becter » et « grailler » sont familiers ou argotiques et seraient déplacés dans un écrit formel. Le registre courant neutre serait simplement « manger ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9488c2df-6ee2-5ca4-bb4d-fd39036a2e0c', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Stylistique — Mise en relief : « ___ ton courage qui force l''admiration. »', '[{"id":"a","text":"C''est"},{"id":"b","text":"Ce que"},{"id":"c","text":"Ce dont"},{"id":"d","text":"Il est"}]'::jsonb, 'a', 'L''extraction d''un élément (le sujet « ton courage ») se fait avec « c''est … qui » : « C''est ton courage qui force l''admiration. » « Ce que » et « ce dont » introduisent une pseudo-clivée qui se referme par « c''est », « Il est » serait une tournure impersonnelle inadaptée ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('896f0670-2bb8-592f-83cd-ac2910ceb077', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Vocabulaire — Connecteur logique : « Il a beaucoup travaillé ; ___, il a réussi son examen. »', '[{"id":"a","text":"néanmoins"},{"id":"b","text":"en outre"},{"id":"c","text":"par conséquent"},{"id":"d","text":"autrement dit"}]'::jsonb, 'c', 'Le travail entraîne logiquement la réussite : c''est un rapport de conséquence, « par conséquent ». « néanmoins » marquerait une opposition, « en outre » une addition, « autrement dit » une reformulation — aucun ne convient à un lien de cause à effet.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0e6f9d9-be29-59b4-82c7-980d9e018637', 'bc090c07-0eef-5e81-b14b-510ee60169f9', 'Orthographe — Lexique soutenu : « Pour combler ce manque, il faut ___ ce défaut. »', '[{"id":"a","text":"pallier à"},{"id":"b","text":"pallier"},{"id":"c","text":"palier"},{"id":"d","text":"pallié"}]'::jsonb, 'b', '« pallier » est transitif direct : on pallie quelque chose, sans préposition — « pallier ce défaut ». « pallier à » est une faute fréquente, « palier » (un seul l) désigne une marche d''escalier, et « pallié » serait un participe passé, ici injustifié.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('be32c75d-9afb-5a22-8513-0205af532c28', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', '⭐⭐ Révision : le défi C1', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87f125db-2dcc-5a21-a4ac-9c728a14f25e', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Grammaire — Accord du participe passé (pronominal) : « Elle s''est ___ les cheveux ce matin. »', '[{"id":"a","text":"lavé"},{"id":"b","text":"lavée"},{"id":"c","text":"lavés"},{"id":"d","text":"lavées"}]'::jsonb, 'a', 'Le COD « les cheveux » est placé APRÈS le participe, donc pas d''accord : « elle s''est lavé les cheveux ». « lavée » accorderait avec le sujet (faux pour un pronominal à COD postposé), « lavés » accorderait à tort avec « cheveux » qui suit, « lavées » est doublement faux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d7d85df-9f82-5faf-9385-0bdabd918d0e', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Conjugaison — Concordance des temps : « Il croyait que tu ___ déjà parti avant son arrivée. »', '[{"id":"a","text":"es"},{"id":"b","text":"seras"},{"id":"c","text":"sois"},{"id":"d","text":"étais"}]'::jsonb, 'd', 'La subordonnée exprime une antériorité par rapport à un passé (« croyait ») : il faut le plus-que-parfait, « tu étais déjà parti ». « es » (présent) et « seras » (futur) brisent la concordance, « sois » est un subjonctif que « croire » affirmatif n''appelle pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8f81a58-5562-50af-83a5-1eb937ab741b', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Vocabulaire — Expression idiomatique : que signifie « avoir le bras long » ?', '[{"id":"a","text":"être très grand"},{"id":"b","text":"avoir de l''influence"},{"id":"c","text":"être généreux"},{"id":"d","text":"travailler dur"}]'::jsonb, 'b', '« Avoir le bras long » signifie disposer d''influence, de relations puissantes. Le sens littéral (être grand) est un piège classique, « être généreux » se dirait « avoir le cœur sur la main », et « travailler dur » n''a aucun rapport avec cette locution.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f1b33d3-fa61-5843-a7e7-c0c4bfc4ba2d', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Stylistique — Mise en relief (accord) : « C''est nous qui ___ responsables de cette décision. »', '[{"id":"a","text":"est"},{"id":"b","text":"sont"},{"id":"c","text":"sommes"},{"id":"d","text":"êtes"}]'::jsonb, 'c', 'Après « c''est … qui », le verbe s''accorde avec le pronom repris : « nous » → « sommes ». « est » s''accorde à tort avec « ce », « sont » avec une 3e personne du pluriel inexistante ici, « êtes » correspondrait à « vous », pas à « nous ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a15bb4f6-575e-53dc-9211-bd5c5c82cb5f', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Vocabulaire — Lexique soutenu : « Cette mesure risque d''___ les tensions au lieu de les apaiser. »', '[{"id":"a","text":"exacerber"},{"id":"b","text":"exhorter"},{"id":"c","text":"exhumer"},{"id":"d","text":"exonérer"}]'::jsonb, 'a', '« Exacerber » signifie aggraver, rendre plus aigu — il s''oppose à « apaiser ». « exhorter » c''est encourager vivement, « exhumer » déterrer, « exonérer » dispenser d''une charge : aucun ne convient au sens d''aggraver des tensions.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4c8d374-0391-59db-a0ed-4e98e5c7b786', 'be32c75d-9afb-5a22-8513-0205af532c28', 'Orthographe — Connecteur de reformulation : « Le PIB recule depuis deux trimestres ; ___, le pays entre en récession. »', '[{"id":"a","text":"néanmoins"},{"id":"b","text":"en revanche"},{"id":"c","text":"par ailleurs"},{"id":"d","text":"autrement dit"}]'::jsonb, 'd', 'La seconde proposition redit la première en d''autres termes (deux trimestres de recul = définition d''une récession) : c''est une reformulation, « autrement dit ». « néanmoins » et « en revanche » marquent l''opposition, « par ailleurs » ajoute un point distinct.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a2a80117-39f8-5a4d-84ab-eda70941e7fe', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : le défi C1', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c98ee0ba-0135-5845-807b-bb01984a467f', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Grammaire — Accord du participe passé (avec « en ») : « Des erreurs, j''en ai ___ beaucoup dans ma jeunesse. »', '[{"id":"a","text":"faites"},{"id":"b","text":"fait"},{"id":"c","text":"faite"},{"id":"d","text":"faits"}]'::jsonb, 'b', 'Quand le COD est le pronom « en », le participe reste invariable : « j''en ai fait beaucoup ». Le piège est d''accorder avec « erreurs » : mais « en » a une valeur partitive et bloque l''accord. « faites », « faite » et « faits » sont donc tous fautifs.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a84a992b-d518-5600-b637-9a3475d2be3f', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Grammaire — Participe passé + infinitif : « Les musiciennes que j''ai ___ jouer étaient remarquables. »', '[{"id":"a","text":"entendues"},{"id":"b","text":"entendu"},{"id":"c","text":"entendue"},{"id":"d","text":"entendus"}]'::jsonb, 'a', 'Le COD « que » (= les musiciennes) fait l''action de l''infinitif (ce sont elles qui jouent) : le participe s''accorde, « entendues ». Si le COD subissait l''action, il resterait invariable (« la sonate que j''ai entendu jouer »). « entendu » oublie l''accord, « entendue » oublie le pluriel, « entendus » met un masculin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b5265b4-3477-5895-b97a-8f71d1e30017', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Conjugaison — Concordance des temps : « Je doutais qu''il ___ la vérité. »', '[{"id":"a","text":"dit"},{"id":"b","text":"dira"},{"id":"c","text":"dise"},{"id":"d","text":"disait"}]'::jsonb, 'c', '« douter que » exige le subjonctif ; en français courant, on garde le subjonctif présent même après un passé : « qu''il dise ». Le subjonctif imparfait (« dît ») serait purement littéraire. « dit » (indicatif), « dira » (futur) et « disait » (imparfait) ne sont pas des subjonctifs et brisent la règle après « douter ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d3234fb-cf35-51dc-9dc6-5a41cefdc963', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Stylistique — Mise en relief : « ___ il se plaint sans cesse, c''est de son salaire. »', '[{"id":"a","text":"Ce que"},{"id":"b","text":"Ce qui"},{"id":"c","text":"Qu''est-ce que"},{"id":"d","text":"Ce dont"}]'::jsonb, 'd', '« se plaindre DE quelque chose » : l''objet introduit par « de » se reprend par « ce dont » : « Ce dont il se plaint, c''est de son salaire. » « Ce que » conviendrait à un verbe transitif direct, « Ce qui » à un sujet, « Qu''est-ce que » est interrogatif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d2ee91b-cf66-5cc7-8232-843710077897', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Vocabulaire — Lexique soutenu : « Faute de preuves, l''accusation s''est ___ infondée. »', '[{"id":"a","text":"avérée vraie"},{"id":"b","text":"avérée"},{"id":"c","text":"avérée fausse"},{"id":"d","text":"averée"}]'::jsonb, 'b', '« s''avérer » signifie déjà « se révéler vrai/exact » : on dit « s''est avérée infondée » (avec l''attribut qui suit), jamais « s''avérer vrai » (pléonasme) ni « s''avérer faux » (contradiction interne). « averée » est une faute d''orthographe (il faut deux fois la même voyelle accentuée : avérée).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0812913d-aa53-516f-abf3-a9ae32759dfe', 'a2a80117-39f8-5a4d-84ab-eda70941e7fe', 'Stylistique — Connecteur de concession soutenu : « Le rapport est incomplet ; ___ qu''il pose les bonnes questions. »', '[{"id":"a","text":"par conséquent il reste"},{"id":"b","text":"en outre il reste"},{"id":"c","text":"il n''en demeure pas moins"},{"id":"d","text":"autrement dit il reste"}]'::jsonb, 'c', '« il n''en demeure pas moins que » est une locution concessive soutenue : malgré le défaut, le mérite subsiste. « par conséquent » marque la conséquence, « en outre » l''addition, « autrement dit » la reformulation — aucun n''exprime la concession attendue ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5c7686a3-b152-55e1-845d-f3b696e4ba81', '145fcdcc-08b7-5bcd-a0f0-a66b74a90d74', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : le défi C1', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81634805-20fc-5872-ac1a-a3695f9ed6a0', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Grammaire — Accord du participe passé (fait + infinitif) : « Elle s''est ___ confectionner une robe par une couturière. »', '[{"id":"a","text":"faite"},{"id":"b","text":"faits"},{"id":"c","text":"faîtes"},{"id":"d","text":"fait"}]'::jsonb, 'd', '« fait » suivi d''un infinitif reste toujours invariable : « elle s''est fait confectionner une robe ». Le pronom « se » n''est pas le COD (elle ne se confectionne pas elle-même), il marque l''intérêt. Toute forme accordée (« faite », « faits ») ou la graphie « faîtes » (qui désigne le sommet d''un toit) est donc fautive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('370094d2-2b1f-5145-a528-fe29178b1261', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Conjugaison — Concordance des temps : « Choisis la phrase dont la concordance est correcte. »', '[{"id":"a","text":"Je pensais qu''il viendra demain."},{"id":"b","text":"J''espérais qu''il vienne le lendemain."},{"id":"c","text":"Je pensais qu''il viendrait le lendemain."},{"id":"d","text":"Je pensais qu''il était venu le lendemain."}]'::jsonb, 'c', 'Après une principale au passé (« pensais »), un fait postérieur se met au conditionnel présent, futur du passé : « qu''il viendrait le lendemain » ✓. (a) mêle un passé à un futur (« viendra »). (b) emploie un subjonctif après « espérer » à l''indicatif (faux : espérer + indicatif). (d) « était venu » + « le lendemain » est contradictoire (antériorité avec un repère postérieur).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3998c24c-633b-5263-95d4-290e1e0a774b', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Stylistique — Nominalisation : « Choisis la reformulation nominalisée et correcte de “Le gouvernement a réformé les retraites.” »', '[{"id":"a","text":"La réforme des retraites par le gouvernement a fait débat."},{"id":"b","text":"Le gouvernement a fait une chose de réforme aux retraites."},{"id":"c","text":"Le réformement des retraites a fait débat."},{"id":"d","text":"Que le gouvernement réforme, ça a fait débat."}]'::jsonb, 'a', 'Le verbe « réformer » se nominalise en « la réforme » : « La réforme des retraites par le gouvernement… » ✓ — compact et soutenu. (b) utilise le verbe support « faire une chose » sans nominaliser. (c) « réformement » n''existe pas (le nom est « réforme »). (d) reste verbale et familière (« ça a fait débat »), sans groupe nominal.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7293bdf-be73-5236-92d9-d7a011d58753', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Vocabulaire — Expression idiomatique : « Vouloir décorer avant même d''avoir construit les murs, c''est ___. »', '[{"id":"a","text":"tomber dans le panneau"},{"id":"b","text":"mettre la charrue avant les bœufs"},{"id":"c","text":"mener en bateau"},{"id":"d","text":"avoir le bras long"}]'::jsonb, 'b', '« Mettre la charrue avant les bœufs », c''est faire les choses dans le mauvais ordre, commencer par la fin — exactement décorer avant de bâtir. « tomber dans le panneau » = se faire piéger, « mener en bateau » = tromper, « avoir le bras long » = être influent : aucun ne décrit une inversion d''étapes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eeb6d10-bb0f-5a8c-bab0-bf4cb829e169', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Lecture — Compréhension de l''implicite : « “Bien sûr, son discours était d''une originalité confondante : on l''avait déjà entendu mille fois.” Quel est le ton de l''auteur ? »', '[{"id":"a","text":"ironique"},{"id":"b","text":"neutre et descriptif"},{"id":"c","text":"indigné"},{"id":"d","text":"admiratif"}]'::jsonb, 'a', 'La seconde partie (« déjà entendu mille fois ») contredit l''éloge apparent (« originalité confondante ») : ce décalage signale l''ironie, l''auteur dit le contraire de ce qu''il pense. Le ton n''est ni admiratif (l''éloge est feint), ni neutre (il y a un jugement caché), ni indigné (le procédé est moqueur, non révolté).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('166653af-8371-57a1-b2aa-18e659733fc5', '5c7686a3-b152-55e1-845d-f3b696e4ba81', 'Stylistique — Articulation du discours : « Choisis la phrase dont les connecteurs sont tous corrects. »', '[{"id":"a","text":"Bien que le budget soit serré, mais l''équipe a tenu ses objectifs."},{"id":"b","text":"Le test était limité ; par conséquent, ses résultats étaient surprenants."},{"id":"c","text":"Les ventes ont chuté ; en outre, la marque reste rentable."},{"id":"d","text":"L''étude était brève ; dès lors, ses conclusions restent provisoires."}]'::jsonb, 'd', '(d) est correct : « dès lors » introduit une conséquence logique (la brièveté entraîne des conclusions provisoires) ✓. (a) cumule « bien que » et « mais » (double concession fautive) — il faut supprimer « mais ». (b) « par conséquent » suppose un lien de cause à effet absent ici (« néanmoins » conviendrait). (c) « en outre » ajoute, alors que la phrase oppose chute et rentabilité (il faudrait « néanmoins »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bc657621-3783-532a-8b6b-151fcb125b9e', 'e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce760051-d95f-59b4-87fa-59a7287172ef', 'bc657621-3783-532a-8b6b-151fcb125b9e', 'Conjugaison — Temps littéraires : quel est le passé simple du verbe « venir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il venait"},{"id":"b","text":"il vint"},{"id":"c","text":"il viendra"},{"id":"d","text":"il est venu"}]'::jsonb, 'b', 'Le passé simple de « venir » à la 3ᵉ personne du singulier est « il vint » (radical en -in-). « il venait » est l''imparfait. « il viendra » est le futur. « il est venu » est le passé composé, temps du discours et non du récit littéraire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a4c6a0a-e673-58a4-bd54-37b601236aa4', 'bc657621-3783-532a-8b6b-151fcb125b9e', 'Stylistique — Figures de style : quelle figure reconnaît-on dans « Cette épée est un éclair » (sans outil de comparaison) ?', '[{"id":"a","text":"une comparaison"},{"id":"b","text":"une métaphore"},{"id":"c","text":"une litote"},{"id":"d","text":"une hyperbole"}]'::jsonb, 'b', 'C''est une métaphore : on identifie l''épée à un éclair sans mot-outil (« comme », « tel »). La comparaison, elle, garderait l''outil : « rapide comme l''éclair ». La litote dit moins pour suggérer plus ; l''hyperbole exagère.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35b507cb-a59e-52ee-ad3f-5ddd876b176d', 'bc657621-3783-532a-8b6b-151fcb125b9e', 'Rhétorique — Procédés : dans « Certes, ce plan est audacieux, mais il est trop risqué », quel procédé argumentatif l''auteur emploie-t-il d''abord ?', '[{"id":"a","text":"la concession"},{"id":"b","text":"l''hyperbole"},{"id":"c","text":"la question rhétorique"},{"id":"d","text":"l''anaphore"}]'::jsonb, 'a', '« Certes… mais… » est une concession : on admet un point adverse (l''audace) pour mieux le réfuter ensuite. L''hyperbole est une exagération ; la question rhétorique n''attend pas de réponse ; l''anaphore est une répétition en tête de phrases.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67fa567b-26c0-5581-b5d4-fa7327fbdb90', 'bc657621-3783-532a-8b6b-151fcb125b9e', 'Vocabulaire — Paronymes savants : « Le juge lui a ___ une lourde peine. » Quel verbe convient ?', '[{"id":"a","text":"affligé"},{"id":"b","text":"infligé"},{"id":"c","text":"infligée"},{"id":"d","text":"infligeait"}]'::jsonb, 'b', 'On « inflige » une peine (imposer une punition) : « le juge lui a infligé une peine ». « affliger » signifie attrister, ce qui ne convient pas ici. La forme « infligée » serait un accord fautif (le COD « peine » est placé après le verbe). « infligeait » est un imparfait incompatible avec « a ___ ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48195103-ef34-5d73-b7ff-884935a9081c', 'bc657621-3783-532a-8b6b-151fcb125b9e', 'Lecture — Expressions : que signifie le proverbe « Qui trop embrasse mal étreint » ?', '[{"id":"a","text":"Qui aime sincèrement réussit toujours."},{"id":"b","text":"À vouloir tout faire à la fois, on échoue partout."},{"id":"c","text":"Il faut se montrer affectueux pour être aimé."},{"id":"d","text":"Mieux vaut agir tard que jamais."}]'::jsonb, 'b', 'Le proverbe signifie qu''en entreprenant trop de choses à la fois, on ne réussit aucune : il faut concentrer ses efforts. « embrasser » y a son sens ancien de « saisir, entourer ». Les autres propositions détournent le sens vers l''affection, sans rapport avec l''idée de dispersion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a8c073e-bba8-530c-8f26-c88d84ae3354', 'e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', '⭐ Entraînement : la bande C2', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96e20119-faff-5eb3-be5d-17187f666c66', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Conjugaison — Temps littéraires : quel est le passé simple de « finir » à la 3ᵉ personne du singulier ?', '[{"id":"a","text":"il finit"},{"id":"b","text":"il finissait"},{"id":"c","text":"il finira"},{"id":"d","text":"il a fini"}]'::jsonb, 'a', 'Le passé simple de « finir » (2ᵉ groupe) à la 3ᵉ personne du singulier est « il finit ». « il finissait » est l''imparfait. « il finira » est le futur. « il a fini » est le passé composé, temps du discours et non du récit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a1dcaaf-d1bb-5f04-ad07-8be87de11b10', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Stylistique — Figures de style : « Il n''est pas mécontent du résultat » pour dire qu''il en est très satisfait. De quelle figure s''agit-il ?', '[{"id":"a","text":"une hyperbole"},{"id":"b","text":"une métaphore"},{"id":"c","text":"une litote"},{"id":"d","text":"une comparaison"}]'::jsonb, 'c', 'La litote consiste à dire moins pour faire entendre plus, souvent par une double négation atténuée : « pas mécontent » = très content. L''hyperbole, au contraire, exagère. La métaphore identifie deux réalités ; la comparaison utilise un outil (« comme »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2347bfb-7fa9-5fb2-b9e4-f18a60e9e311', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Vocabulaire — Paronymes savants : « Un savant ___ a présidé le colloque. » Quel adjectif convient pour dire « remarquable » ?', '[{"id":"a","text":"imminent"},{"id":"b","text":"immanent"},{"id":"c","text":"émanent"},{"id":"d","text":"éminent"}]'::jsonb, 'd', '« éminent » signifie remarquable, supérieur : « un savant éminent ». « imminent » signifie tout proche (un danger imminent). « immanent » est un terme philosophique (qui est contenu dans la nature même d''un être). « émanent » n''est pas un adjectif usuel ici. C''est un paronyme classique du C2.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('086c7f74-a0f5-542a-876c-a0b732f1c5f4', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Lecture — Locutions latines : dans « Il a jugé l''affaire a priori, sans étudier le dossier », que signifie « a priori » ?', '[{"id":"a","text":"d''après l''expérience acquise"},{"id":"b","text":"avant tout examen des faits"},{"id":"c","text":"en dernier recours"},{"id":"d","text":"de manière définitive"}]'::jsonb, 'b', '« a priori » signifie « avant tout examen », au départ, sur la base d''idées préconçues : ici, juger sans avoir lu le dossier. Son opposé est « a posteriori » (après l''expérience), ce qui correspond à la proposition (a). Les autres sens ne conviennent pas à la locution.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fa1986c-9c1c-52f6-aeef-0e3a2c774a4c', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Grammaire — Syntaxe expressive : que désigne l''expression « un grand homme » (adjectif antéposé) ?', '[{"id":"a","text":"un homme illustre, remarquable"},{"id":"b","text":"un homme de haute taille"},{"id":"c","text":"un homme âgé"},{"id":"d","text":"un homme corpulent"}]'::jsonb, 'a', 'Antéposé, l''adjectif « grand » prend un sens figuré, moral : « un grand homme » est un homme illustre. Postposé, « un homme grand » désigne sa taille. La place de l''adjectif modifie le sens : c''est un point de stylistique essentiel au C2.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5d401eb-9571-5185-878a-430186686928', '9a8c073e-bba8-530c-8f26-c88d84ae3354', 'Rhétorique — Procédés : « Faut-il vraiment rappeler que la liberté est précieuse ? » Quel procédé l''auteur utilise-t-il ?', '[{"id":"a","text":"une concession"},{"id":"b","text":"une litote"},{"id":"c","text":"un chiasme"},{"id":"d","text":"une question rhétorique"}]'::jsonb, 'd', 'C''est une question rhétorique : elle n''attend pas de réponse et affirme avec force une évidence (la liberté est précieuse). La concession admet un point adverse ; la litote atténue ; le chiasme croise l''ordre des termes (AB/BA).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', '⭐⭐ Révision : la bande C2', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd188234-442f-557d-a44e-0d241f5497f3', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Conjugaison — Temps littéraires : complétez au passé antérieur (antériorité immédiate) : « Quand il ___ son armure, il s''élança au combat. »', '[{"id":"a","text":"endossait"},{"id":"b","text":"avait endossé"},{"id":"c","text":"endossa"},{"id":"d","text":"eut endossé"}]'::jsonb, 'd', 'Le passé antérieur (auxiliaire au passé simple + participe) marque l''antériorité immédiate dans un récit avant une action au passé simple : « quand il eut endossé son armure, il s''élança ». « avait endossé » est le plus-que-parfait (registre du discours/imparfait). « endossait » et « endossa » n''expriment pas l''antériorité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a67ec93-91de-587c-a18c-48e5c4ecd0c2', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Stylistique — Figures de style : « un silence assourdissant » réunit deux termes contradictoires. De quelle figure s''agit-il ?', '[{"id":"a","text":"une hyperbole"},{"id":"b","text":"une métonymie"},{"id":"c","text":"un oxymore"},{"id":"d","text":"une périphrase"}]'::jsonb, 'c', 'L''oxymore soude deux termes de sens opposé (« silence » et « assourdissant ») pour créer un effet saisissant. L''hyperbole exagère ; la métonymie désigne par un terme associé (le contenant pour le contenu) ; la périphrase remplace un mot par une expression équivalente.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e7f95ed-c24b-54b7-9a97-8a3972f7b6c7', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Vocabulaire — Paronymes savants : « Cette ___ économique défavorable a freiné les investissements. » Quel mot désigne la situation d''ensemble ?', '[{"id":"a","text":"conjoncture"},{"id":"b","text":"conjecture"},{"id":"c","text":"concision"},{"id":"d","text":"conjonction"}]'::jsonb, 'a', 'La « conjoncture » est la situation économique d''ensemble à un moment donné. La « conjecture » est une hypothèse, une supposition (paronyme piège). La « concision » est la brièveté ; la « conjonction » est un mot de liaison grammatical.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('482529af-6abe-51cf-b8e3-fa0a317e49be', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Lecture — Locutions latines : que signifie « de facto » dans « Il est de facto le dirigeant du groupe » ?', '[{"id":"a","text":"selon la loi, officiellement"},{"id":"b","text":"dans les faits, en pratique"},{"id":"c","text":"par conséquent"},{"id":"d","text":"depuis toujours"}]'::jsonb, 'b', '« de facto » signifie « dans les faits », en pratique, par opposition à « de jure » (en droit, officiellement), qui correspond à la proposition (a). Il dirige réellement, même sans titre officiel. Les autres sens ne traduisent pas la locution.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37565735-845c-58f2-bf40-5066c2881b38', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Grammaire — Syntaxe expressive : « Il faut manger pour vivre et non vivre pour manger. » Quel procédé croise l''ordre des mots ?', '[{"id":"a","text":"l''anaphore"},{"id":"b","text":"l''inversion du sujet"},{"id":"c","text":"le chiasme"},{"id":"d","text":"l''apposition"}]'::jsonb, 'c', 'Le chiasme croise les termes en miroir (manger-vivre / vivre-manger : structure AB/BA). L''anaphore répète un mot en tête de plusieurs propositions ; l''inversion du sujet le place après le verbe ; l''apposition juxtapose un groupe nominal explicatif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f84f36f0-17cf-5681-9fac-1349b8eb4380', '014c9c82-2682-5221-96f5-0bca6e3fa0f3', 'Rhétorique — Sophismes : « Tu défends ce projet, mais tu n''es qu''un menteur, donc ton projet est mauvais. » Quel sophisme est commis ?', '[{"id":"a","text":"l''attaque ad hominem"},{"id":"b","text":"la pente glissante"},{"id":"c","text":"l''homme de paille"},{"id":"d","text":"la généralisation hâtive"}]'::jsonb, 'a', 'L''attaque ad hominem vise la personne (« tu n''es qu''un menteur ») au lieu de réfuter l''argument lui-même. La pente glissante enchaîne des conséquences improbables ; l''homme de paille déforme la thèse adverse ; la généralisation hâtive conclut d''un cas isolé. Ici, la cible est l''individu, donc ad hominem.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b47dfa18-e827-5737-943f-5c529ae23cf6', 'e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', '⚔️ Boss du chapitre ⭐⭐⭐ : la bande C2', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57df18d0-83f1-5e0d-ace2-9745634bd23b', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Conjugaison — Subjonctif imparfait : complétez selon la concordance soutenue : « Le roi exigea que son armée ___ sans délai. »', '[{"id":"a","text":"parte"},{"id":"b","text":"partait"},{"id":"c","text":"partit"},{"id":"d","text":"partît"}]'::jsonb, 'd', 'Après une principale au passé simple (« exigea »), la concordance soutenue impose le subjonctif imparfait : « qu''elle partît » (3ᵉ pers. sing. en -ît avec accent circonflexe). « parte » est le subjonctif présent (registre courant). « partit » est l''indicatif passé simple, sans accent (le piège typographique). « partait » est l''imparfait de l''indicatif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa501982-25f2-5535-b5f9-513e6f201dcd', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Stylistique — Figures de style : « Boire un verre » pour dire « boire le contenu du verre ». Quelle figure est employée ?', '[{"id":"a","text":"une métaphore"},{"id":"b","text":"une métonymie"},{"id":"c","text":"une litote"},{"id":"d","text":"un oxymore"}]'::jsonb, 'b', 'La métonymie désigne une réalité par un terme qui lui est associé : ici le contenant (« verre ») pour le contenu (la boisson). La métaphore identifie deux réalités par ressemblance ; la litote atténue ; l''oxymore réunit des contraires. Le rapport contenant/contenu est la marque de la métonymie.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6894feb1-7b5a-5081-a9c6-d2ae9ef493c5', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Vocabulaire — Paronymes savants : « Le dictionnaire donne plusieurs ___ de ce mot. » Quel terme désigne les différents sens d''un mot ?', '[{"id":"a","text":"acceptations"},{"id":"b","text":"acceptions"},{"id":"c","text":"exceptions"},{"id":"d","text":"assertions"}]'::jsonb, 'b', 'Une « acception » est le sens particulier dans lequel un mot est employé : un dictionnaire en donne plusieurs. L''« acceptation » est le fait d''accepter (paronyme piège). Une « exception » est ce qui échappe à la règle ; une « assertion » est une affirmation. C''est un paronyme savant classique du C2.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('effd87cf-38d1-5821-8327-62a49aa1ea14', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Rhétorique — Sophismes : « Si on autorise ce petit aménagement, bientôt tout sera permis et la société s''effondrera. » Quel raisonnement fallacieux est-ce ?', '[{"id":"a","text":"l''attaque ad hominem"},{"id":"b","text":"l''argument d''autorité"},{"id":"c","text":"la pente glissante"},{"id":"d","text":"le faux dilemme"}]'::jsonb, 'c', 'La pente glissante (ou effet boule de neige) enchaîne une série de conséquences de plus en plus graves et improbables à partir d''un acte anodin. L''attaque ad hominem vise la personne ; l''argument d''autorité invoque une célébrité ; le faux dilemme réduit le choix à deux options. Ici, c''est la chaîne catastrophiste qui trahit le sophisme.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f03d200-1d39-56bf-b344-5326225258ff', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Lecture — Locutions latines : que signifie « ipso facto » dans « En signant, il accepte ipso facto le règlement » ?', '[{"id":"a","text":"par le fait même, automatiquement"},{"id":"b","text":"à contrecœur, sous la contrainte"},{"id":"c","text":"en théorie seulement"},{"id":"d","text":"après mûre réflexion"}]'::jsonb, 'a', '« ipso facto » signifie « par le fait même », automatiquement, comme conséquence directe : signer entraîne d''office l''acceptation. À ne pas confondre avec « de facto » (dans les faits). Les autres propositions introduisent une nuance de contrainte ou de doute absente de la locution.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea66ac54-a717-5a71-9139-78beb085aa00', 'b47dfa18-e827-5737-943f-5c529ae23cf6', 'Grammaire — Syntaxe expressive : dans « Telle est ma décision », comment se nomme la construction qui place l''attribut en tête ?', '[{"id":"a","text":"une anaphore"},{"id":"b","text":"une apostrophe"},{"id":"c","text":"une inversion (mise en relief de l''attribut)"},{"id":"d","text":"une ellipse"}]'::jsonb, 'c', 'Placer l''attribut « telle » en tête, avant le verbe et le sujet (« Telle est ma décision »), est une inversion stylistique qui met l''attribut en relief. L''anaphore est une répétition en tête ; l''apostrophe interpelle un destinataire ; l''ellipse supprime un élément récupérable. Ici, c''est l''ordre inversé qui crée l''emphase.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'e4775584-3005-5679-9cf4-28828479b462', 'francais-donjon', '👑 Défi élite ⭐⭐⭐⭐ : la bande C2', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d7f0220-3ef0-50ca-be28-cbdde2200592', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Conjugaison — Temps littéraires : trouvez la phrase où le temps du récit est employé de façon FAUTIVE.', '[{"id":"a","text":"Il ouvrit la porte, entra, puis referma derrière lui."},{"id":"b","text":"Quand il eut terminé son repas, il se leva de table."},{"id":"c","text":"Le héros saisit son épée et frappa l''adversaire."},{"id":"d","text":"Dès qu''il eut fini, il avait quitté la pièce aussitôt."}]'::jsonb, 'd', 'L''erreur est en (d) : après le passé antérieur « eut fini », l''action principale doit être au passé simple (« il quitta »), non au plus-que-parfait « avait quitté », qui rompt la chronologie du récit. (a) et (c) enchaînent correctement des passés simples. (b) emploie correctement passé antérieur + passé simple pour l''antériorité immédiate.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65a99593-855f-556c-8eb8-64a486be7c3e', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Stylistique — Figures de style : « Paris ! Paris outragé ! Paris brisé ! Paris martyrisé ! » Quelle figure domine ce passage ?', '[{"id":"a","text":"l''anaphore"},{"id":"b","text":"le chiasme"},{"id":"c","text":"la litote"},{"id":"d","text":"l''euphémisme"}]'::jsonb, 'a', 'L''anaphore répète un même mot (« Paris ») en tête de segments successifs pour marteler l''idée et amplifier l''émotion. Le chiasme croise l''ordre des termes en miroir ; la litote atténue pour suggérer davantage ; l''euphémisme adoucit une réalité pénible. Ici, c''est la répétition initiale insistante qui caractérise la figure.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7e70713-91bf-5fba-a1e4-0f0d5447b78b', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Vocabulaire — Paronymes savants : choisissez la phrase où le paronyme est employé CORRECTEMENT.', '[{"id":"a","text":"Le séisme a affligé de lourdes pertes à la région."},{"id":"b","text":"Sa nomination est immanente : elle sera annoncée demain."},{"id":"c","text":"Ces deux acceptions du mot figurent dans le dictionnaire."},{"id":"d","text":"Le médecin a conjecturé un nouveau diagnostic au patient."}]'::jsonb, 'c', '(c) est correct : « acceptions » désigne bien les sens d''un mot recensés dans un dictionnaire. (a) confond « affliger » (attrister) et « infliger » (imposer) : on inflige des pertes. (b) confond « immanente » (philosophie) et « imminente » (toute proche). (d) emploie « conjecturer » (former une hypothèse) de façon impropre : on « pose » ou « formule » un diagnostic.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fec5bb3-6dd5-56ce-8c1e-5bcf870c6e0f', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Rhétorique — Procédés : « Mon adversaire prétend qu''il faut réduire un peu les dépenses ; il veut donc supprimer tous les services publics ! » Quel sophisme est employé ?', '[{"id":"a","text":"l''argument d''autorité"},{"id":"b","text":"la pente glissante"},{"id":"c","text":"le faux dilemme"},{"id":"d","text":"l''homme de paille"}]'::jsonb, 'd', 'L''homme de paille déforme et exagère la thèse adverse (« réduire un peu » devient « supprimer tous les services ») pour la réfuter plus aisément. L''argument d''autorité invoque une célébrité ; la pente glissante enchaîne des conséquences improbables ; le faux dilemme limite le choix à deux options. Ici, c''est la caricature de la position adverse qui révèle le sophisme.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc9ba7cf-d2bf-59cc-b18f-7776fb65a00a', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Vocabulaire — Mots savants : que signifie l''adjectif « laconique » ?', '[{"id":"a","text":"qui parle abondamment, prolixe"},{"id":"b","text":"qui s''exprime en très peu de mots, concis"},{"id":"c","text":"qui est plein d''amertume, acerbe"},{"id":"d","text":"qui manque de logique, confus"}]'::jsonb, 'b', '« laconique » qualifie une expression réduite à l''essentiel, brève jusqu''à la sécheresse (du nom des Laconiens, réputés pour leur concision). « prolixe » en est l''antonyme (qui parle trop). « confus » et « acerbe » désignent d''autres défauts, sans rapport avec la brièveté.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac0fc8f5-5c98-536f-a4d1-eb694aee43d2', 'a3a5e00a-0724-52c2-bd94-ae5c91319b8f', 'Lecture — Analyse critique : « Certes, la réforme paraît coûteuse ; mais peut-on vraiment chiffrer le prix de la justice ? » Comment l''auteur articule-t-il son raisonnement ?', '[{"id":"a","text":"une généralisation hâtive suivie d''un exemple"},{"id":"b","text":"une définition suivie d''une énumération"},{"id":"c","text":"une concession suivie d''une question rhétorique"},{"id":"d","text":"une hyperbole suivie d''une litote"}]'::jsonb, 'c', 'L''auteur concède d''abord un point adverse (« certes… coûteuse ») puis renverse l''argument par une question rhétorique (« peut-on chiffrer le prix de la justice ? ») qui suggère que la valeur défendue dépasse tout coût. Il n''y a ni généralisation, ni définition, ni couple hyperbole/litote : c''est bien l''enchaînement concession + question rhétorique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

