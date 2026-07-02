-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-b2 (English — Upper-Intermediate (B2))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-b2/
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
  ('anglais-b2', 'English — Upper-Intermediate (B2)', 'Master upper-intermediate English: the past perfect, the passive voice, reported speech, advanced conditionals, and gerunds vs infinitives. Upper-intermediate level (CEFR B2), building on A1, A2, and B1.', 'Agilité', 'subject-english', 'Globe', 4, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-b2'
      AND e.source = 'admin'
      AND q.id NOT IN ('5851e410-038c-59a9-bb73-9630f75d4464', '19e70bad-ed9a-5064-877d-1835d3e8656b', '59713fcd-63f0-5273-ade8-c27cc7d32b1a', '618555be-0df5-5331-bccf-1b5cf23ca0f3', 'adff794d-7ae7-57d0-9ac6-4f86dbc1d4c5', '70b6d97e-6e56-5608-b0b8-220f8a148fed', '318db386-95a2-5619-95cd-f9488c052022', '5e3f7614-84e2-5330-8235-2bc76a2ab4b4', '7a9231e5-e509-5a6c-80a9-fe506ec2ce8c', '7997e375-25f1-572b-b169-47623a520730', '8d8025a3-5754-5140-b0d4-01d786c8c227', '6d690fad-10ea-5e60-b060-268adf829f55', '7b7557ee-b77b-54de-b0f3-47fc69f54e37', 'e3f9816f-eae7-52ef-92be-312744d8127d', '11ac386a-f1d1-5b43-903a-a750a742e8a2', '6938fd06-3daf-5e4e-bbb5-71be53d9d426', '399b7d58-831b-59da-a9a4-cbad799ec8e1', 'e4a6d6e3-adb2-5a4d-b493-082e668b8415', '9e824950-b8c3-5896-916e-8ecbbb662c60', '057bba00-df23-5587-8781-9fc5ae3c4475', 'd4d700a2-b62e-5d21-9bfb-30d6bfba780e', 'cc348641-b452-5d06-938b-cf7a759510d8', '07368752-2ee9-56ae-8179-417be7f0fea9', '841e1511-57a0-5984-935b-10b6fa9698c5', 'b7a62494-dc4b-5015-b7d1-7dadd66108b6', '79242a59-96f6-592e-9e1a-554a9a700fe8', '49c6663c-5a48-51a8-b88d-2bc5d34259ba', 'c57e0b6d-f59a-5ea6-b69c-b60f748f0857', '4360449a-331f-5b8b-b202-92a4a9e468b6', '8d9db4ff-46bf-54ca-92c8-f03f7a9bde64', 'cd468a0e-119d-5619-a4fb-aa7e3b4f31f7', 'd10e1bba-47f2-5a83-96f3-2bf446f48f17', '03e84f0f-bed5-5edc-bfbe-7320e987f4f0', '52f84632-d84f-5ed5-98f7-5bfd038bac75', 'c312d090-353b-5f8f-83d5-f969852ada06', 'bfbf01b7-8c97-5c4f-961e-bab30fa864a8', 'de804372-bb4c-57a6-98a4-2a47f6812aba', '500e99a8-ea9a-5b3a-883e-b3a3fc53443a', '579c0696-a623-55ab-b298-0230c3f37ffb', '28472161-6ef3-5ef5-9a81-c39394752fec', '21f46f9e-5fcf-5040-91a0-f1ee296d4d7a', '228a883c-2f11-5d01-bda4-1d8ed98c5101', 'e42b7147-c6f9-5d87-a73b-ef3c3e1e4758', 'dca8ee9c-972a-5a61-b96a-a5aecb554bd0', '9cf84817-294f-55aa-87ff-f0db0ce53b98', '69d86f79-c3dd-505e-ae3a-4fcd51cb0dd4', '75df6ba2-d4bb-56f8-a60c-d9a0e8e3c992', 'dd2d5030-824e-56cc-bdbe-c86c78fc9f7b', '6b19dc9d-d751-567d-b24e-0f16a4ebad98', 'a0cd93fc-1d19-5e38-bccf-6cd1d1b75112', 'fcb16eea-9c34-54a8-bff2-8a07f4543019', 'f0422ea5-a6c5-5740-83f6-76b1d508da32', '0e166466-803c-5e9e-bf1d-88836f574678', '5eee1d31-2bc3-53ef-8468-322587035261', 'bf63d2f1-0120-57f7-ad68-3b9a808536ab', '0fb001ab-0ebc-506a-99d4-8ca28dc3b6e6', '4900138a-cede-5afb-ab03-336200f7034d', '609a571b-0bc4-5f81-8383-75bee8ec3f28', '19df378d-06f5-543e-8ccd-3516be8aa95f', '3f679d74-c0bf-55a7-9038-0a1cea5d75d0', '976ef78a-e033-5be7-be8f-daaf7b61a3bf', '8143aa33-b2d2-5a65-bb5d-14ce3488b394', '14bc1dfa-6f9b-58df-b740-a30515d5fdb0', '533d2b53-f1c8-5919-b8e0-cabf3adfba5c', '41886f93-da6f-5a35-9eaf-7ec498b95338', 'e84d21ec-08ab-5892-bf31-943107758a76', 'a6968581-2d44-50d2-b886-33f9f1177a04', '8ab48945-8e02-5d57-906e-01910b976420', 'b0249db9-af0c-5c54-8455-16d0a28eb90f', 'f5410571-14a5-5778-b7e2-b2f31c748e78', '5c68cd28-5863-57c5-bd91-69a6811769c1', '70efc4dc-32e6-5a6d-9824-322e5102ad91', '57c5d733-7e7e-5c1e-9ef3-6215b8edd27f', 'c08e0e8c-91e8-5923-8434-a7cdfcec2118', '303b21b7-c275-54d8-bccc-9903396e05cd', '4674ab60-aee2-52f4-84d7-bb919b00e829', '01868afd-a8e3-5fe7-bced-da0c7cae86f3', '3e355305-1953-5862-a4c1-81ed5a20b2c8', 'd9f98fe4-acbb-59b0-ad9c-3fa389b27c1f', 'e4af21f6-8c3e-5e81-a33d-e6943a1a959a', '74177d64-0bd4-5bdd-9dd9-0994cc7c9151', '91d38468-c670-5586-b080-f076a69f17f9', '1f9985d7-8b9f-516c-960b-e4ece66233c7', '26b6b4eb-d75a-5ecc-a2bf-19c83920cc6c', '257a5383-a5f6-5014-b1b6-8df792320b90', '41deca32-3341-5a4c-926f-62439ecae4b4', 'a88e9ad7-4981-5ce2-9c4c-585ca204d1b1', 'af56a5ce-f09b-50c5-9f83-e52d5d9c5498', 'b654dfcf-ad08-5c66-a089-2b6b40f80538', '51280439-47af-54d6-b6fd-3c2f7703d1ef', 'f3c7e371-d784-53f0-a75f-3d2599b31aa9', '57e192b8-5c55-575d-976e-90fd56768d6a', '236959ed-d38a-52dd-8edd-e6ea00045220', 'fa13c14b-bc5c-5d6e-b3e0-8e2bdb10f1a6', '31e49d70-38d9-558a-af1e-f1bb85fa8d9d', 'a741c645-b97c-51ee-a435-b399ecf3a6f7', '816edd55-4bef-56e3-a706-b6677ed43b77', '11f6efae-76fa-56f5-8e72-44dafe463bc0', '0cc25702-b41d-5609-904b-35e43606011b', '94b938d8-b070-5159-b85f-0d25aacfa046', '96e390d1-778f-5504-a445-ef6d5e40ea84', '83469044-f7ef-5bf6-9bc1-adbf9dd079ab', '9dc44034-06ca-511b-a18c-2d4940c4c283', '53ab1af4-9867-5834-bd4a-586abc80154b', 'b4196f97-2382-59e6-a67a-db4123dc878c', '70dea884-eb1d-5e12-95e5-431bee412d1b', '93db20f8-1d02-5bb5-9b85-918e9ff25b4d', '86b33a6e-9afb-5223-8302-c89479029fb9', '2f55b843-dc66-5813-84b3-56afa33718a2', '1b84d883-c8d8-5f28-8d20-97260981c81e', '77954a38-d8db-54e9-ad66-182962063d7a', '090158c5-b48f-52e5-949d-ae0d176e9ed7', 'd251c40e-dd9a-5fbd-9496-3a0c6542462b', '8268d822-ecb3-544e-8edc-c771f6bd3d7e', 'aa810e30-cdc5-59c7-bc63-1c5325c89df1', 'd811d8c3-ff1e-5c2f-8862-de5c9c74bb7b', 'f7282186-1bc6-5ae3-a8e0-a9c6f6e0d48a', '9350d6b8-b8ad-527f-80d8-d0313a4c6ec0', '7a19830a-c885-50ed-bdf3-3205a945b3b8', 'fe8dbfab-f756-59ed-8fc1-da02f2b95e1c', '5c61d2ca-f74d-5a41-a7e0-686ad9208771', '0319e8e2-ed4d-503f-97af-85b9a1ad3382', 'c4659e16-8104-5126-b6a7-539b94f346c4', '895af5ae-bccc-5e1d-baf0-bfc43295a3f9', 'cea4ef09-d325-52d5-952a-4cfd1bd1c80a', '8bd5b80e-348b-5d29-b87b-c392eddeff2b', '6a335c57-439a-5060-9931-8474bdb35f0f', '473eb531-637f-555e-91b1-fd2efee5fe50', '85a28e0b-1ccd-539a-b287-93c6357ce2d8', '55af0f40-9499-53d9-941b-e2288aa43673', 'e559d125-04bb-5873-9f15-1a8ac896908d', 'ea5499af-df25-58a3-b5f3-fa04f7bc4cf4', 'ab81e1c8-26cb-5f16-ba70-1e6d5fdea4ac', '48ecfa79-3b65-5814-a0d5-2459e52802af', '094778b8-4591-5b96-bc6a-3767f97533f7', '94686c5b-fba9-5d41-a888-21df675aa5e6', '42dd4efb-95e3-58db-abc6-3b5c9e3e3aa3', 'c9d62739-3f6c-5cfa-b110-115a1f26128d', '224a4aaa-dde6-58de-9140-5ac1e47c0690', '27633569-ab01-596a-a472-1142dbb9b29a', '95f05ac2-ab58-5e32-8bdb-38c658a3e036', '14dae91b-2d6b-5339-811b-72e65204b5f6', 'f10a50bc-f57a-5a10-80a9-ef8a32a80420', '5906b752-c97f-5f04-b7bf-bc01691934a4', 'e341500f-4941-59ce-a090-f2c8ed745ffa', 'cda565c5-bf38-5227-b692-ba8046a517f9', '18e47bb7-c79e-55ef-9620-90df1e79065f', '4bd6af41-5ee8-5f14-babf-636e5046cf9f', '65e62480-1cb3-5218-abd8-04559ba3e166', 'c1335d5b-48e7-50aa-99e2-baa60fe8c979', 'f840ab5d-2eb2-531a-bc1f-f56fbd48f7e2', '3e71810a-aae4-5521-9b4c-06a0e4bb2470', 'a09fe17a-eb6e-500e-a76c-c48fbabb94f7', '09b8a4ed-4f81-5bc2-a9e6-2bbcc5cde072', '3ce16ecb-7b24-5896-ba92-47bab473492f', '9bed76d6-5c0f-574c-a110-ddf4911df809', '1c5ecc2c-64fb-5559-9dce-bfd837aab012', 'a5d14885-c4ff-5bf8-af08-a2743f78c86e', '28b3bd68-4abd-5a97-8b3a-5f6afd4ec053', 'c8445449-8f48-5808-b0e8-186cdd1246c1', '40b3c2af-58d7-5d29-a5e5-60d71c3c010a', 'cfdd860b-ae76-5596-be6b-1701f665c13e', '8e725d3c-f9ca-5d7e-aaff-35199459d97b', 'b8329f4a-ca50-5b49-8d39-4cc0da9bd88c', 'b4c02a7b-e975-52c5-aa25-14639e542e22', '8abe6623-b4d1-56db-8a60-037642c73fc6', 'edf7b1af-b64a-5eb2-bb81-cfb89f60ba4f', 'fa4ab25f-e146-5b3e-9b41-99402f8d5f31', '7900574f-3300-505c-a582-c50c0fa3485c', 'd8c1b5bf-347a-5ea6-a86d-1cd66fd23c79', '0568a678-61a4-5359-a27a-377e460397eb', 'be40a3a0-828c-5adf-af78-0b1967acedb2', '29658aed-2279-5eed-afb8-b7f5be0b3e63', 'cda7d72b-56c6-55ae-9989-e2f3fb503977', '4f13e289-ca2c-5a1c-b2c6-b87c94d7c6ea', 'ef867e09-84d8-517b-b393-386508891223', 'df57f1f9-c31e-57d0-93c5-360c440d8507', 'cbaada48-a36c-516d-8e98-a440913a9b7a', '6ad7da72-9445-51d3-b082-9f773c3ae341', '694f1c14-3b25-5230-9f44-db258e2b7d26', '5c03b5b7-98ed-54d9-909d-7beb8f64027c', 'afb469b2-0350-5baf-a2a4-2e488d8fc3e2', '5945e582-fb19-5d94-bf77-365d7d07dfbe', '6f953bd7-0861-59d1-ab24-fe12e0f0775b', '0899db8e-4eaa-5a56-9633-af5577869217', '65997d0a-0cd7-589e-9ff3-91787a327f3b', 'd8d468b8-bfe9-5174-b0c0-d90998b2e829', '12b5ca61-1b0b-543d-b41d-aab0bcd11825', '4ec8168a-f0b2-52af-97c6-cb817c742968', '18ccdaeb-c053-5614-a431-262d2af6fa9e', 'e5b10cc1-0c08-5ab8-b1d5-a4066fb92ed8', '72c8dee9-7ba0-5ded-bd4d-050ce0cca042', '2b0690a2-d572-57e5-9aee-9d129d44088f', 'f46e4cec-bddb-5a32-85c7-586465875e53', '3bf69861-2deb-5838-9443-ead315ac0b33', '0231fbba-cfca-5b77-a3c4-83477a2246fa', '4a163ce3-88bb-5433-8006-e8f65e46c1d3', 'ee334b72-2210-5c71-aa1c-58eae3c3992e', '41ac6924-cf41-5d8a-bf0e-5f652662f4dc', 'd3789d92-d4ab-5f42-bd97-e019adcd8eec', 'a848bdfb-f69a-5aa7-9b0e-1a67a30c39d9', '8ddcc3d7-2df3-5b40-82d4-5aa92416327d', '14c254f5-0709-5091-b64c-b95b83442918', 'd5740b77-3b50-54cd-9989-c40865f530ba', '526188ef-cd1b-5579-84d9-193419472057', '78cc4c39-9842-5a71-aee0-07df55eb0e1a', '116e3ba9-054e-50cb-9e7c-c5a73e2c6e9b', '5a53b96e-5791-519f-9325-9279cd0aa635', '1e611299-3dd8-53fb-95f0-9dc5f9124be1', '87302b7b-9742-5066-8836-25ad9170d964', '98dc70f6-1335-507d-9c11-e5ff98ac3fcb', '86a3a201-db7b-5398-9d74-7cd8ac21588d', '18f7c4e7-e095-5d50-85ad-aef6905a3231', '885a7032-b56f-5519-8b6b-b9eb3dc8944d', '0dc90b1e-f96c-5f8e-9963-2d597aee766f', 'd7fd5ec4-6e49-5074-802f-78b198c69ba3', '589a01cb-a142-5e69-9932-e494b64bdf5d', '687685cd-742d-575a-aded-d44b5d03f8dd', '40971d03-98bc-5426-92b2-f59a7d975235', 'c85872a4-9817-5495-9972-56c0a47e756c', '97401b8c-5716-5bbf-b429-5a5667be9109', 'c89c5a7e-546f-5fee-93f4-e5e5515c8fa5', '0374fe65-254f-5ae7-8fe7-7fb64de0590d', 'fde0a474-3692-5806-89c1-9d193b5231fd', '92e972aa-3229-56ba-9929-47685626a17d', '48924f7e-3bba-5f0c-ae13-2607f724a283', 'eeb3a38d-5f46-571f-8ca4-881687ae073d', '4b2e9ef7-fe1b-5bce-869c-c062531b9ee3', 'ac9770aa-2336-5634-9523-ccc7706567b4', '14300102-b92d-569e-aa52-eb37143da473', '133b0305-7d62-5eef-8f2b-dc8837216ef1', 'a944af9a-8ec5-5f4e-9521-d9b90d22c78b', '4c627902-1a5b-5733-ae67-c253a983de81', '9179122a-568c-5647-ba40-b02047f0f7a0', '6cf7fc41-b616-51dc-beb1-bd4336a849ac', 'e5f92aaf-1fa8-540f-a29d-f3fe649a333c', '896659d6-5625-58e3-81b8-0472990c41bf', 'b732e761-a077-54b3-bf82-c01cd823722d', '94edd6f7-c45f-54ab-876c-bf610accee7f', 'e6d4fbb6-a5b0-5345-b867-75447ca7da35', '1ddf6173-9491-5213-a5ea-8b55c7da9159', '3695354e-43d8-5d7c-9c2f-668639431057', '4122eb41-2e19-5773-8a3a-d3a04d761fd5', '9f1b77b3-1708-5928-bb46-24d44bf4d8c8', '7c140cea-a6de-5cdb-ae80-5a7ee79760ad');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-b2' AND source = 'admin' AND id NOT IN ('ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', '370c724f-1b0c-5e2f-a87c-b77002e4730e', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'c7bee59c-5269-5887-b368-9364cb8382ac', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', '580be676-fcda-57e9-b1ce-c7e90a87645d', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', '47a9669b-59e3-560a-9c0d-b665ced19277', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'bd900608-00a7-5ec0-b193-9054092e3db2', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', '760121e7-3470-5fc5-a64a-2c39e7c38729', '053b4c2b-c691-5fc7-83b5-933a2395c16d', '5527b612-be00-554f-9940-597f2c988fef', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'da08d717-b872-539d-810e-512716687ca0', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'ab523941-55ea-5448-9e3c-343a105141d1', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', '875bf9ba-a8fa-53d3-a982-04b227d743a2', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'c41bdc79-33dd-5b32-aa67-d6022d422825', '28e1814a-6011-50d0-be81-ab7143de045d', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', '40fd3e66-f98d-5093-85a2-d24753ecbd31', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', '35c2571d-a904-519d-aca6-b1c9da067830', '1a5addba-96a4-5193-aaa9-873fa2d68182');
DELETE FROM public.questions WHERE exercise_id IN ('ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', '370c724f-1b0c-5e2f-a87c-b77002e4730e', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'c7bee59c-5269-5887-b368-9364cb8382ac', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', '580be676-fcda-57e9-b1ce-c7e90a87645d', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', '47a9669b-59e3-560a-9c0d-b665ced19277', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'bd900608-00a7-5ec0-b193-9054092e3db2', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', '760121e7-3470-5fc5-a64a-2c39e7c38729', '053b4c2b-c691-5fc7-83b5-933a2395c16d', '5527b612-be00-554f-9940-597f2c988fef', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'da08d717-b872-539d-810e-512716687ca0', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'ab523941-55ea-5448-9e3c-343a105141d1', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', '875bf9ba-a8fa-53d3-a982-04b227d743a2', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'c41bdc79-33dd-5b32-aa67-d6022d422825', '28e1814a-6011-50d0-be81-ab7143de045d', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', '40fd3e66-f98d-5093-85a2-d24753ecbd31', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', '35c2571d-a904-519d-aca6-b1c9da067830', '1a5addba-96a4-5193-aaa9-873fa2d68182') AND id NOT IN ('5851e410-038c-59a9-bb73-9630f75d4464', '19e70bad-ed9a-5064-877d-1835d3e8656b', '59713fcd-63f0-5273-ade8-c27cc7d32b1a', '618555be-0df5-5331-bccf-1b5cf23ca0f3', 'adff794d-7ae7-57d0-9ac6-4f86dbc1d4c5', '70b6d97e-6e56-5608-b0b8-220f8a148fed', '318db386-95a2-5619-95cd-f9488c052022', '5e3f7614-84e2-5330-8235-2bc76a2ab4b4', '7a9231e5-e509-5a6c-80a9-fe506ec2ce8c', '7997e375-25f1-572b-b169-47623a520730', '8d8025a3-5754-5140-b0d4-01d786c8c227', '6d690fad-10ea-5e60-b060-268adf829f55', '7b7557ee-b77b-54de-b0f3-47fc69f54e37', 'e3f9816f-eae7-52ef-92be-312744d8127d', '11ac386a-f1d1-5b43-903a-a750a742e8a2', '6938fd06-3daf-5e4e-bbb5-71be53d9d426', '399b7d58-831b-59da-a9a4-cbad799ec8e1', 'e4a6d6e3-adb2-5a4d-b493-082e668b8415', '9e824950-b8c3-5896-916e-8ecbbb662c60', '057bba00-df23-5587-8781-9fc5ae3c4475', 'd4d700a2-b62e-5d21-9bfb-30d6bfba780e', 'cc348641-b452-5d06-938b-cf7a759510d8', '07368752-2ee9-56ae-8179-417be7f0fea9', '841e1511-57a0-5984-935b-10b6fa9698c5', 'b7a62494-dc4b-5015-b7d1-7dadd66108b6', '79242a59-96f6-592e-9e1a-554a9a700fe8', '49c6663c-5a48-51a8-b88d-2bc5d34259ba', 'c57e0b6d-f59a-5ea6-b69c-b60f748f0857', '4360449a-331f-5b8b-b202-92a4a9e468b6', '8d9db4ff-46bf-54ca-92c8-f03f7a9bde64', 'cd468a0e-119d-5619-a4fb-aa7e3b4f31f7', 'd10e1bba-47f2-5a83-96f3-2bf446f48f17', '03e84f0f-bed5-5edc-bfbe-7320e987f4f0', '52f84632-d84f-5ed5-98f7-5bfd038bac75', 'c312d090-353b-5f8f-83d5-f969852ada06', 'bfbf01b7-8c97-5c4f-961e-bab30fa864a8', 'de804372-bb4c-57a6-98a4-2a47f6812aba', '500e99a8-ea9a-5b3a-883e-b3a3fc53443a', '579c0696-a623-55ab-b298-0230c3f37ffb', '28472161-6ef3-5ef5-9a81-c39394752fec', '21f46f9e-5fcf-5040-91a0-f1ee296d4d7a', '228a883c-2f11-5d01-bda4-1d8ed98c5101', 'e42b7147-c6f9-5d87-a73b-ef3c3e1e4758', 'dca8ee9c-972a-5a61-b96a-a5aecb554bd0', '9cf84817-294f-55aa-87ff-f0db0ce53b98', '69d86f79-c3dd-505e-ae3a-4fcd51cb0dd4', '75df6ba2-d4bb-56f8-a60c-d9a0e8e3c992', 'dd2d5030-824e-56cc-bdbe-c86c78fc9f7b', '6b19dc9d-d751-567d-b24e-0f16a4ebad98', 'a0cd93fc-1d19-5e38-bccf-6cd1d1b75112', 'fcb16eea-9c34-54a8-bff2-8a07f4543019', 'f0422ea5-a6c5-5740-83f6-76b1d508da32', '0e166466-803c-5e9e-bf1d-88836f574678', '5eee1d31-2bc3-53ef-8468-322587035261', 'bf63d2f1-0120-57f7-ad68-3b9a808536ab', '0fb001ab-0ebc-506a-99d4-8ca28dc3b6e6', '4900138a-cede-5afb-ab03-336200f7034d', '609a571b-0bc4-5f81-8383-75bee8ec3f28', '19df378d-06f5-543e-8ccd-3516be8aa95f', '3f679d74-c0bf-55a7-9038-0a1cea5d75d0', '976ef78a-e033-5be7-be8f-daaf7b61a3bf', '8143aa33-b2d2-5a65-bb5d-14ce3488b394', '14bc1dfa-6f9b-58df-b740-a30515d5fdb0', '533d2b53-f1c8-5919-b8e0-cabf3adfba5c', '41886f93-da6f-5a35-9eaf-7ec498b95338', 'e84d21ec-08ab-5892-bf31-943107758a76', 'a6968581-2d44-50d2-b886-33f9f1177a04', '8ab48945-8e02-5d57-906e-01910b976420', 'b0249db9-af0c-5c54-8455-16d0a28eb90f', 'f5410571-14a5-5778-b7e2-b2f31c748e78', '5c68cd28-5863-57c5-bd91-69a6811769c1', '70efc4dc-32e6-5a6d-9824-322e5102ad91', '57c5d733-7e7e-5c1e-9ef3-6215b8edd27f', 'c08e0e8c-91e8-5923-8434-a7cdfcec2118', '303b21b7-c275-54d8-bccc-9903396e05cd', '4674ab60-aee2-52f4-84d7-bb919b00e829', '01868afd-a8e3-5fe7-bced-da0c7cae86f3', '3e355305-1953-5862-a4c1-81ed5a20b2c8', 'd9f98fe4-acbb-59b0-ad9c-3fa389b27c1f', 'e4af21f6-8c3e-5e81-a33d-e6943a1a959a', '74177d64-0bd4-5bdd-9dd9-0994cc7c9151', '91d38468-c670-5586-b080-f076a69f17f9', '1f9985d7-8b9f-516c-960b-e4ece66233c7', '26b6b4eb-d75a-5ecc-a2bf-19c83920cc6c', '257a5383-a5f6-5014-b1b6-8df792320b90', '41deca32-3341-5a4c-926f-62439ecae4b4', 'a88e9ad7-4981-5ce2-9c4c-585ca204d1b1', 'af56a5ce-f09b-50c5-9f83-e52d5d9c5498', 'b654dfcf-ad08-5c66-a089-2b6b40f80538', '51280439-47af-54d6-b6fd-3c2f7703d1ef', 'f3c7e371-d784-53f0-a75f-3d2599b31aa9', '57e192b8-5c55-575d-976e-90fd56768d6a', '236959ed-d38a-52dd-8edd-e6ea00045220', 'fa13c14b-bc5c-5d6e-b3e0-8e2bdb10f1a6', '31e49d70-38d9-558a-af1e-f1bb85fa8d9d', 'a741c645-b97c-51ee-a435-b399ecf3a6f7', '816edd55-4bef-56e3-a706-b6677ed43b77', '11f6efae-76fa-56f5-8e72-44dafe463bc0', '0cc25702-b41d-5609-904b-35e43606011b', '94b938d8-b070-5159-b85f-0d25aacfa046', '96e390d1-778f-5504-a445-ef6d5e40ea84', '83469044-f7ef-5bf6-9bc1-adbf9dd079ab', '9dc44034-06ca-511b-a18c-2d4940c4c283', '53ab1af4-9867-5834-bd4a-586abc80154b', 'b4196f97-2382-59e6-a67a-db4123dc878c', '70dea884-eb1d-5e12-95e5-431bee412d1b', '93db20f8-1d02-5bb5-9b85-918e9ff25b4d', '86b33a6e-9afb-5223-8302-c89479029fb9', '2f55b843-dc66-5813-84b3-56afa33718a2', '1b84d883-c8d8-5f28-8d20-97260981c81e', '77954a38-d8db-54e9-ad66-182962063d7a', '090158c5-b48f-52e5-949d-ae0d176e9ed7', 'd251c40e-dd9a-5fbd-9496-3a0c6542462b', '8268d822-ecb3-544e-8edc-c771f6bd3d7e', 'aa810e30-cdc5-59c7-bc63-1c5325c89df1', 'd811d8c3-ff1e-5c2f-8862-de5c9c74bb7b', 'f7282186-1bc6-5ae3-a8e0-a9c6f6e0d48a', '9350d6b8-b8ad-527f-80d8-d0313a4c6ec0', '7a19830a-c885-50ed-bdf3-3205a945b3b8', 'fe8dbfab-f756-59ed-8fc1-da02f2b95e1c', '5c61d2ca-f74d-5a41-a7e0-686ad9208771', '0319e8e2-ed4d-503f-97af-85b9a1ad3382', 'c4659e16-8104-5126-b6a7-539b94f346c4', '895af5ae-bccc-5e1d-baf0-bfc43295a3f9', 'cea4ef09-d325-52d5-952a-4cfd1bd1c80a', '8bd5b80e-348b-5d29-b87b-c392eddeff2b', '6a335c57-439a-5060-9931-8474bdb35f0f', '473eb531-637f-555e-91b1-fd2efee5fe50', '85a28e0b-1ccd-539a-b287-93c6357ce2d8', '55af0f40-9499-53d9-941b-e2288aa43673', 'e559d125-04bb-5873-9f15-1a8ac896908d', 'ea5499af-df25-58a3-b5f3-fa04f7bc4cf4', 'ab81e1c8-26cb-5f16-ba70-1e6d5fdea4ac', '48ecfa79-3b65-5814-a0d5-2459e52802af', '094778b8-4591-5b96-bc6a-3767f97533f7', '94686c5b-fba9-5d41-a888-21df675aa5e6', '42dd4efb-95e3-58db-abc6-3b5c9e3e3aa3', 'c9d62739-3f6c-5cfa-b110-115a1f26128d', '224a4aaa-dde6-58de-9140-5ac1e47c0690', '27633569-ab01-596a-a472-1142dbb9b29a', '95f05ac2-ab58-5e32-8bdb-38c658a3e036', '14dae91b-2d6b-5339-811b-72e65204b5f6', 'f10a50bc-f57a-5a10-80a9-ef8a32a80420', '5906b752-c97f-5f04-b7bf-bc01691934a4', 'e341500f-4941-59ce-a090-f2c8ed745ffa', 'cda565c5-bf38-5227-b692-ba8046a517f9', '18e47bb7-c79e-55ef-9620-90df1e79065f', '4bd6af41-5ee8-5f14-babf-636e5046cf9f', '65e62480-1cb3-5218-abd8-04559ba3e166', 'c1335d5b-48e7-50aa-99e2-baa60fe8c979', 'f840ab5d-2eb2-531a-bc1f-f56fbd48f7e2', '3e71810a-aae4-5521-9b4c-06a0e4bb2470', 'a09fe17a-eb6e-500e-a76c-c48fbabb94f7', '09b8a4ed-4f81-5bc2-a9e6-2bbcc5cde072', '3ce16ecb-7b24-5896-ba92-47bab473492f', '9bed76d6-5c0f-574c-a110-ddf4911df809', '1c5ecc2c-64fb-5559-9dce-bfd837aab012', 'a5d14885-c4ff-5bf8-af08-a2743f78c86e', '28b3bd68-4abd-5a97-8b3a-5f6afd4ec053', 'c8445449-8f48-5808-b0e8-186cdd1246c1', '40b3c2af-58d7-5d29-a5e5-60d71c3c010a', 'cfdd860b-ae76-5596-be6b-1701f665c13e', '8e725d3c-f9ca-5d7e-aaff-35199459d97b', 'b8329f4a-ca50-5b49-8d39-4cc0da9bd88c', 'b4c02a7b-e975-52c5-aa25-14639e542e22', '8abe6623-b4d1-56db-8a60-037642c73fc6', 'edf7b1af-b64a-5eb2-bb81-cfb89f60ba4f', 'fa4ab25f-e146-5b3e-9b41-99402f8d5f31', '7900574f-3300-505c-a582-c50c0fa3485c', 'd8c1b5bf-347a-5ea6-a86d-1cd66fd23c79', '0568a678-61a4-5359-a27a-377e460397eb', 'be40a3a0-828c-5adf-af78-0b1967acedb2', '29658aed-2279-5eed-afb8-b7f5be0b3e63', 'cda7d72b-56c6-55ae-9989-e2f3fb503977', '4f13e289-ca2c-5a1c-b2c6-b87c94d7c6ea', 'ef867e09-84d8-517b-b393-386508891223', 'df57f1f9-c31e-57d0-93c5-360c440d8507', 'cbaada48-a36c-516d-8e98-a440913a9b7a', '6ad7da72-9445-51d3-b082-9f773c3ae341', '694f1c14-3b25-5230-9f44-db258e2b7d26', '5c03b5b7-98ed-54d9-909d-7beb8f64027c', 'afb469b2-0350-5baf-a2a4-2e488d8fc3e2', '5945e582-fb19-5d94-bf77-365d7d07dfbe', '6f953bd7-0861-59d1-ab24-fe12e0f0775b', '0899db8e-4eaa-5a56-9633-af5577869217', '65997d0a-0cd7-589e-9ff3-91787a327f3b', 'd8d468b8-bfe9-5174-b0c0-d90998b2e829', '12b5ca61-1b0b-543d-b41d-aab0bcd11825', '4ec8168a-f0b2-52af-97c6-cb817c742968', '18ccdaeb-c053-5614-a431-262d2af6fa9e', 'e5b10cc1-0c08-5ab8-b1d5-a4066fb92ed8', '72c8dee9-7ba0-5ded-bd4d-050ce0cca042', '2b0690a2-d572-57e5-9aee-9d129d44088f', 'f46e4cec-bddb-5a32-85c7-586465875e53', '3bf69861-2deb-5838-9443-ead315ac0b33', '0231fbba-cfca-5b77-a3c4-83477a2246fa', '4a163ce3-88bb-5433-8006-e8f65e46c1d3', 'ee334b72-2210-5c71-aa1c-58eae3c3992e', '41ac6924-cf41-5d8a-bf0e-5f652662f4dc', 'd3789d92-d4ab-5f42-bd97-e019adcd8eec', 'a848bdfb-f69a-5aa7-9b0e-1a67a30c39d9', '8ddcc3d7-2df3-5b40-82d4-5aa92416327d', '14c254f5-0709-5091-b64c-b95b83442918', 'd5740b77-3b50-54cd-9989-c40865f530ba', '526188ef-cd1b-5579-84d9-193419472057', '78cc4c39-9842-5a71-aee0-07df55eb0e1a', '116e3ba9-054e-50cb-9e7c-c5a73e2c6e9b', '5a53b96e-5791-519f-9325-9279cd0aa635', '1e611299-3dd8-53fb-95f0-9dc5f9124be1', '87302b7b-9742-5066-8836-25ad9170d964', '98dc70f6-1335-507d-9c11-e5ff98ac3fcb', '86a3a201-db7b-5398-9d74-7cd8ac21588d', '18f7c4e7-e095-5d50-85ad-aef6905a3231', '885a7032-b56f-5519-8b6b-b9eb3dc8944d', '0dc90b1e-f96c-5f8e-9963-2d597aee766f', 'd7fd5ec4-6e49-5074-802f-78b198c69ba3', '589a01cb-a142-5e69-9932-e494b64bdf5d', '687685cd-742d-575a-aded-d44b5d03f8dd', '40971d03-98bc-5426-92b2-f59a7d975235', 'c85872a4-9817-5495-9972-56c0a47e756c', '97401b8c-5716-5bbf-b429-5a5667be9109', 'c89c5a7e-546f-5fee-93f4-e5e5515c8fa5', '0374fe65-254f-5ae7-8fe7-7fb64de0590d', 'fde0a474-3692-5806-89c1-9d193b5231fd', '92e972aa-3229-56ba-9929-47685626a17d', '48924f7e-3bba-5f0c-ae13-2607f724a283', 'eeb3a38d-5f46-571f-8ca4-881687ae073d', '4b2e9ef7-fe1b-5bce-869c-c062531b9ee3', 'ac9770aa-2336-5634-9523-ccc7706567b4', '14300102-b92d-569e-aa52-eb37143da473', '133b0305-7d62-5eef-8f2b-dc8837216ef1', 'a944af9a-8ec5-5f4e-9521-d9b90d22c78b', '4c627902-1a5b-5733-ae67-c253a983de81', '9179122a-568c-5647-ba40-b02047f0f7a0', '6cf7fc41-b616-51dc-beb1-bd4336a849ac', 'e5f92aaf-1fa8-540f-a29d-f3fe649a333c', '896659d6-5625-58e3-81b8-0472990c41bf', 'b732e761-a077-54b3-bf82-c01cd823722d', '94edd6f7-c45f-54ab-876c-bf610accee7f', 'e6d4fbb6-a5b0-5345-b867-75447ca7da35', '1ddf6173-9491-5213-a5ea-8b55c7da9159', '3695354e-43d8-5d7c-9c2f-668639431057', '4122eb41-2e19-5773-8a3a-d3a04d761fd5', '9f1b77b3-1708-5928-bb46-24d44bf4d8c8', '7c140cea-a6de-5cdb-ae80-5a7ee79760ad');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-b2' AND c.id NOT IN ('92b7bde5-46f4-56dd-a893-a4f675f7281d', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'eb250c85-5c0b-59c4-9333-c98d07d14452', '2a050abc-34ca-5d61-bdc3-79bded379059', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', '61e6d0ae-1f90-5d11-975f-2fbc00124c41') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', 'The Past Perfect', 'Sequence events in the past: use had + past participle to express what happened before another past action, and past perfect continuous for ongoing earlier actions.', '# ⏳ The Past Perfect: Mastering the "Earlier Past"

> _You arrive at the station. The train is gone. You missed it — but WHY?_
> _Because it **had already left** when you arrived. Welcome to the past perfect: the tense that tells the story BEFORE the story._

---

## 🗡️ 1. Form: How to Build the Past Perfect

The past perfect is the same for **all subjects**: `had + past participle`.

| Subject                             | Affirmative      | Negative            | Question            |
| ----------------------------------- | ---------------- | ------------------- | ------------------- |
| I / You / He / She / It / We / They | **had** finished | **hadn''t** finished | **Had** … finished? |

- _She **had left** before I arrived._
- _They **hadn''t eaten** anything all day._
- **\*Had** you ever visited Paris before that trip?\*

> **Contraction:** `had not` → `hadn''t`. The subject contraction: `I''d`, `she''d`, `they''d`, etc. (same as `would` — context tells you which).

---

## 🏰 2. Core Use: The "Earlier Past"

Use the past perfect for an action that happened **before** another action in the past. Think of it as the "past of the past."

The timeline looks like this:

```
Earlier action (past perfect)  →  Later action (past simple)  →  NOW
      had left                         arrived
```

**Signal words that love the past perfect:**

| Signal word     | Example                                   |
| --------------- | ----------------------------------------- |
| **already**     | He had **already** gone.                  |
| **just**        | She had **just** finished.                |
| **never**       | I had **never** seen snow.                |
| **before**      | We left **before** it started.            |
| **after**       | **After** they had eaten, they walked.    |
| **by the time** | **By the time** she called, I had left.   |
| **when**        | **When** I arrived, the film had started. |

---

## ⚔️ 3. Past Perfect vs. Past Simple — The Key Distinction

**Use past perfect when you need to show WHICH event came first.**

> _When I got home, I realised I **had forgotten** my keys._
> (First: I forgot my keys. Second: I got home and realised it.)

> _When I got home, I **made** dinner._
> (Sequential — both actions happen after each other in order. No need for past perfect.)

**With "before" / "after" — past perfect is optional but preferred for clarity:**

- _She left **before** he arrived._ (clear order — past simple acceptable)
- _She **had** already left **before** he arrived._ (more emphatic — past perfect preferred)

**Without a time marker — past perfect is NECESSARY:**

- _He was tired because he **had worked** all night._ (not: _had work_, not: _worked_ — "worked" would suggest two simultaneous events)

---

## 🌀 4. Past Perfect Continuous: Duration in the Earlier Past

Form: `had + been + verb-ing`

Use it to emphasise that an activity **was ongoing** over a period of time before another past event.

- _She was exhausted because she **had been running** for two hours._
- _They **had been waiting** for an hour before the bus finally came._
- _He smelled of paint — he **had been decorating** his flat all day._

**Continuous vs. simple — the nuance:**

| Past Perfect Simple                    | Past Perfect Continuous                              |
| -------------------------------------- | ---------------------------------------------------- |
| Emphasises completion                  | Emphasises duration / process                        |
| _She had read the book._ (finished it) | _She had been reading for hours._ (ongoing activity) |

---

## ⚠️ 5. Common Traps to Avoid

**Trap 1 — Past perfect in isolation.**
Never use the past perfect without a reference point in the past. It must link to another past event.

- WRONG: _I had eaten pizza yesterday._
- RIGHT: _I had already eaten when she arrived._

**Trap 2 — Confusing with present perfect.**
Present perfect (`have + past participle`) connects to NOW. Past perfect connects to ANOTHER PAST MOMENT.

- _I **have lost** my keys._ → I can''t find them now.
- _I **had lost** my keys, so I couldn''t get in._ → This happened in the past, before another past event.

**Trap 3 — Using past perfect for both actions.**
When two past events are linked, the LATER one uses past simple, not past perfect.

- WRONG: _After she had finished, she had gone home._
- RIGHT: _After she had finished, she went home._

**Trap 4 — "It was the first time…" pattern.**
After _it was the first time / it was the only time_ in a past context, use the **past perfect**:

- _It was the first time Anna **had ever performed** on stage._ (Compare: _It IS the first time she HAS performed_ — present context uses present perfect.)

> 🗡️ Tip: The tense of the main clause controls what follows: **was → had** (past perfect); **is → has** (present perfect).

---

## 🏆 Boss Preview

In the next exercises, you will sequence complex past narratives, choose between past perfect and past simple in context, and use past perfect continuous to describe interrupted or prolonged earlier activities. The boss challenge will test your ability to read a short passage and identify the correct temporal order of events. Train hard, hero — time itself is your battlefield!', '# 📜 Résumé: The Past Perfect

- **Form:** `had + past participle` (all subjects). Negative: `hadn''t + past participle`. Question: `Had + subject + past participle?`
- **Core meaning:** An action that happened **before** another action in the past ("the past of the past").
- **Timeline:** Earlier action (past perfect) → later action (past simple) → now.
- **Key signal words:** _already, just, never, before, after, when, by the time_.
- **Past perfect continuous:** `had + been + verb-ing` — stresses the **duration** or ongoing nature of the earlier activity (e.g. _She had been waiting for an hour._).
- **With before/after:** Past perfect is optional when the order is already clear, but preferred for emphasis and clarity.
- **Without a time marker:** Past perfect is **necessary** to show which event came first.
- **Trap 1 — No isolation:** Never use past perfect without a reference point in the past. Always pair it with a past simple anchor.
- **Trap 2 — Not the same as present perfect:** Present perfect (`have + past participle`) links to NOW; past perfect links to another past moment.
- **Trap 3 — Don''t double up:** The later action takes the past simple, not the past perfect (_After she had eaten, she **went** home_ — not _had gone_).
- **Trap 4 — "First time" pattern:** _It **was** the first time she **had** performed_ (past context → past perfect). Compare: _It **is** the first time she **has** performed_ (present context → present perfect).', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', 'The Passive Voice', 'Shift the focus from doer to receiver: form the passive with be + past participle across all key tenses, understand when and why to use it, and master the get-passive for informal contexts.', '# 🛡️ The Passive Voice: Shifting the Spotlight

> _Who built the pyramids? Who discovered penicillin? Sometimes we don''t know. Sometimes it doesn''t matter. Sometimes the RECEIVER of the action is what counts._
> _The passive voice is your tool to put the RESULT at the centre of the story._

---

## ⚔️ 1. Form: be + Past Participle

The passive is built with the verb **be** (in any tense) + **past participle**.

The object of the active sentence becomes the **subject** of the passive sentence.

**Active → Passive transformation pattern:**

| Tense                  | Active                             | Passive                                |
| ---------------------- | ---------------------------------- | -------------------------------------- |
| **Present simple**     | _They clean the office every day._ | _The office **is cleaned** every day._ |
| **Past simple**        | _Someone stole my bike._           | _My bike **was stolen**._              |
| **Present perfect**    | _They have built a new bridge._    | _A new bridge **has been built**._     |
| **Future (will)**      | _They will deliver the package._   | _The package **will be delivered**._   |
| **Present continuous** | _They are repairing the road._     | _The road **is being repaired**._      |

> **Key rule:** The past participle NEVER changes — only the tense of **be** changes.

**Negative and question forms:**

- _The window **wasn''t broken** by the children._ (negative: was not + past participle)
- **\*Was** the report **submitted** on time?\* (question: be + subject + past participle)
- **\*Has** the letter **been sent** yet?\* (present perfect question)

---

## 🗡️ 2. The By-Agent: Who Did It?

To mention WHO performed the action, use **by + agent** at the end of the sentence.

- _This painting was created **by Picasso**._
- _The new law was passed **by the government**._

**When to INCLUDE the by-agent:**

- When the agent is **important** or **surprising** information.
- When the agent is **new information** (not already known to the reader).

**When to OMIT the by-agent (most common!):**

- When the agent is **unknown**: _My wallet was stolen._ (We don''t know who did it.)
- When the agent is **obvious** or **unimportant**: _The rubbish is collected on Fridays._ (by the rubbish collectors — obvious)
- When the sentence already focuses on the result: _The road has been repaired._

---

## 🏰 3. When and Why to Use the Passive

There are four key reasons to choose the passive over the active:

**Reason 1 — Unknown agent:** The doer is unknown or unidentified.

- _The ancient tomb was discovered in 1922._ (We may not know — or not care — who found it first.)

**Reason 2 — Unimportant agent:** The focus is on what happened, not who did it.

- _The report will be submitted by Friday._

**Reason 3 — Formal or impersonal style:** Common in academic writing, news, and official documents.

- _It has been decided that the meeting will be postponed._
- _Mistakes were made._

**Reason 4 — Keeping the topic as subject:** To maintain the same subject across sentences for better flow.

- _Einstein developed the theory of relativity. It was later confirmed by experiments._
  (We keep "It" — the theory — as the subject rather than switching to "Experiments confirmed it".)

---

## 🌀 4. The Get-Passive: Informal Contexts

In informal spoken and written English, **get** replaces **be** as the auxiliary:

`get + past participle`

- _She **got fired** last week._ (= She was fired.)
- _The window **got broken** during the storm._ (= The window was broken.)
- _He **got stopped** by the police._ (= He was stopped.)

**Get-passive key features:**

- More informal and conversational than be-passive.
- Often implies something **unexpected**, **accidental**, or **unwanted**.
- Common with: _get hurt, get lost, get paid, get invited, get promoted, get arrested._

> **Note:** The get-passive is NOT used in formal writing. Use be-passive in academic or official contexts.

---

## ⚠️ 5. Common Trap: Intransitive Verbs Cannot Be Passivised

A verb can only become passive if it has an **object** in the active form (transitive verbs).

**Intransitive verbs** (no object) **cannot form the passive:**

| Intransitive active      | WRONG passive attempt          | Why?                   |
| ------------------------ | ------------------------------ | ---------------------- |
| _He arrived._            | ~~He was arrived.~~            | ''arrive'' has no object |
| _The accident happened._ | ~~The accident was happened.~~ | ''happen'' has no object |
| _She fell._              | ~~She was fallen.~~            | ''fall'' has no object   |
| _They slept._            | ~~They were slept.~~           | ''sleep'' has no object  |

**Rule:** If there is no object in the active sentence, there is no passive.

---

## 🏆 Boss Preview

Ahead, you will match active sentences to their passive equivalents across tenses, decide when to include or drop the by-agent, spot errors in passive construction, and read authentic-style passages to identify the passive voice in context. Elite heroes will face complex tense transformations and nuanced choices between be-passive and get-passive. The spotlight awaits — will you control it?', '# 📜 Résumé: The Passive Voice

- **Form:** `be (any tense) + past participle`. The past participle never changes — only the tense of _be_ changes.
- **5 key tenses in passive form:**
  - Present simple: _is/are + past participle_ → _The office is cleaned daily._
  - Past simple: _was/were + past participle_ → _My bike was stolen._
  - Present perfect: _has/have been + past participle_ → _A bridge has been built._
  - Future (will): _will be + past participle_ → _The package will be delivered._
  - Present continuous: _is/are being + past participle_ → _The road is being repaired._
- **The by-agent:** Use `by + agent` only when the doer is important or new information. Omit when the agent is unknown, obvious, or unimportant.
- **4 reasons to use the passive:** (1) unknown agent, (2) unimportant agent, (3) formal/impersonal style, (4) to keep the topic as subject for sentence flow.
- **Get-passive:** `get + past participle` — informal register only; often implies something unexpected or unwanted (_She got fired. He got stopped._). Not used in formal writing.
- **Trap — intransitive verbs:** Verbs with no object (arrive, happen, fall, sleep) **cannot** be passivised. There must be an object in the active sentence to create a passive subject.
- **Negative:** `was/were not + past participle` (_It wasn''t approved._).
- **Question:** `Was/Were + subject + past participle?` (_Was the report submitted?_).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', 'Reported Speech', 'Transform direct speech into reported speech: backshift tenses, shift pronouns and time expressions, and master the difference between say and tell.', '# 🗣️ Reported Speech — The Art of the Second-Hand Story

> 💡 «A true warrior doesn''t just fight — they report intel. In English, mastering reported speech means you can relay any message without losing its meaning.»

## 🏰 1. What is Reported Speech?

**Reported speech** (also called **indirect speech**) is how we tell someone else what another person said, without quoting their exact words. We shift from the original speaker''s viewpoint to ours.

_Direct:_ \*She said, **"I am tired."\***
_Reported:_ _She said (that) **she was tired**._

The word **that** is optional after _say_ and _tell_ — both forms are correct:
_He told me that he was hungry. / He told me he was hungry._

## ⚡ 2. Tense Backshift

When the reporting verb (_said_, _told_, _asked_) is in the **past**, the verb inside the reported clause shifts **one tense back** into the past.

| Direct speech tense                   | Reported speech tense                                |
| ------------------------------------- | ---------------------------------------------------- |
| present simple (_"I work"_)           | → past simple (\*she said she **worked\***)          |
| present continuous (_"I am working"_) | → past continuous (\*she said she **was working\***) |
| past simple (_"I worked"_)            | → past perfect (\*she said she **had worked\***)     |
| present perfect (_"I have worked"_)   | → past perfect (\*she said she **had worked\***)     |
| _will_ (_"I will go"_)                | → _would_ (\*she said she **would go\***)            |
| _can_ (_"I can help"_)                | → _could_ (\*she said she **could help\***)          |
| _must_ (_"I must leave"_)             | → _had to_ (\*she said she **had to leave\***)       |

> 🗡️ Tip: Think of backshift as rewinding one step. _Will → would_, _can → could_, _must → had to_. The tense slides back, but the meaning stays the same.

## 🔮 3. Pronoun and Time-Word Changes

Pronouns and time expressions must shift to reflect the reporter''s viewpoint, not the original speaker''s.

**Pronouns:** _I → he / she_, _we → they_, _my → his / her_, _our → their_, _you → I / we_ (context-dependent).

**Time expressions:**

| Direct      | Reported                                |
| ----------- | --------------------------------------- |
| _now_       | → _then_                                |
| _today_     | → _that day_                            |
| _yesterday_ | → _the day before / the previous day_   |
| _tomorrow_  | → _the next day / the following day_    |
| _here_      | → _there_                               |
| _this_      | → _that_                                |
| _these_     | → _those_                               |
| _last week_ | → _the week before / the previous week_ |

_Direct:_ _"I''ll finish **this** report **today**."_
_Reported:_ _He said he would finish **that** report **that day**._

## 🛡️ 4. Reported Statements: say vs. tell

These two verbs are the workhorses of reported speech — but they follow different patterns.

- **say** — no object needed: _She **said** (that) she was ready._
- **tell** — always needs a personal object: _She **told me** (that) she was ready._ / _He **told her** he would call._

> ⚠️ Trap: _~~She said me~~_ is **wrong**. \*She **told me\*** is right. _Say_ never takes a personal object directly — use _say to me_ if you need to specify.

## 🧭 5. Reported Questions

When reporting a question, **remove the question word order** (no inversion) and **drop the question mark**.

**Yes/No questions** → use _if_ or _whether_:
_Direct:_ _"Have you eaten?"_
_Reported:_ _He asked me **if I had eaten**._ (NOT: _~~if had I eaten~~_)

**Wh- questions** → keep the question word, but invert back to statement order:
_Direct:_ _"Where do you live?"_
_Reported:_ _He asked me **where I lived**._ (NOT: _~~where did I live~~_)

> ⚠️ Trap: The word order inside a reported question is **subject → verb**, just like a normal statement. Never keep the inverted _did/does/was_ structure.

## 🔮 6. Reporting Conditionals

When a conditional is embedded in reported speech, the **same backshift rules apply** to each verb:

| Direct speech                               | Reported speech                                                                    |
| ------------------------------------------- | ---------------------------------------------------------------------------------- |
| _"If you work hard, you **will** succeed."_ | _He said if I **worked** hard, I **would** succeed._                               |
| _"If she **studied**, she **would** pass."_ | _He said if she **studied**, she **would** pass._ (no change — already past forms) |

> 🗡️ Tip: The first conditional (_if + present, will_) backshifts to a second-conditional pattern (_if + past, would_) in reported speech.

## ⚔️ 7. Reported Commands

For orders, requests and advice, use a **to-infinitive** (or **not to + infinitive** for negatives):

- _"Sit down."_ → _He **told me to sit down**._
- _"Don''t shout."_ → _He **told me not to shout**._
- _"Please open the window."_ → _She **asked me to open the window**._

**tell** is used for direct commands; **ask** is used for polite requests.

## 🌀 8. When NOT to Backshift

If the reported information is **still true at the time of reporting**, you may keep the original tense:

_She said the Earth **is** round._ (still true — no need to backshift)
_He told me he **lives** in Tunis._ (he still lives there now)

This is especially common with **general facts, laws of nature**, or information that has **not changed**.

> 🗡️ Tip: If in doubt, backshifting is always grammatically acceptable — the no-backshift option is simply more natural when the fact is still current.

> 🏆 Gate cleared! You can now relay intel from any source. Next on the quest: **Advanced Conditionals** — where you''ll explore past regrets, present wishes, and the art of the hypothetical.', '# 📜 Résumé: Reported Speech

- **Definition** — Reported speech relays what someone said without quoting them directly; the optional word _that_ links the clauses (_He said (that) he was tired_).
- **Tense backshift** — when the reporting verb is past (_said / told / asked_), shift the reported verb one tense back: present simple → past simple, present continuous → past continuous, past simple → past perfect, present perfect → past perfect, _will_ → _would_, _can_ → _could_, _must_ → _had to_.
- **Pronoun shifts** — _I → he/she_, _we → they_, _my → his/her_, _you → I/we_ (context-dependent).
- **Time-word shifts** — _now → then_, _today → that day_, _yesterday → the day before_, _tomorrow → the next day_, _here → there_, _this → that_.
- **say vs. tell** — _say_ takes no personal object (_she said she was ready_); _tell_ always needs one (_she told me she was ready_). ⚠️ Never _~~she said me~~_.
- **Reported questions** — use _if/whether_ for yes/no questions; keep the wh-word for open questions; always restore **subject → verb** order, no inversion, no question mark (_He asked me where I lived_).
- **Reporting conditionals** — backshift applies to each verb: first conditional (_if + present, will_) becomes second-conditional pattern (_if + past, would_) in reported speech (_"If you work, you will pass" → he said if I worked, I would pass_).
- **Reported commands** — use **tell/ask + object + to-infinitive**: _He told me to sit down. She asked me not to shout._
- ⚠️ **No-backshift exception** — if the reported fact is still true now, you may keep the original tense (_She said the Earth is round_). When in doubt, backshift is always correct.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', 'Advanced Conditionals', 'Unlock complex hypotheticals: form the third conditional for past regrets, navigate mixed conditionals, express wishes with I wish and if only, and use unless and provided that.', '# 🔮 Advanced Conditionals — Beyond the Possible

> 💡 «The heroes who shape history aren''t just those who act — they''re those who understand what _could have been_. Master the third conditional, and you master regret, redemption, and hypothetical glory.»

## 🏰 1. The Third Conditional — Past Regrets & Missed Possibilities

The **third conditional** describes an **imaginary past** — something that _did not happen_, and its imaginary result.

**Form:** _If + past perfect, … would / could / might + have + past participle_

| If-clause                    | Result clause                                |
| ---------------------------- | -------------------------------------------- |
| _If + had + past participle_ | _would/could/might + have + past participle_ |

_*If she **had studied** harder, she **would have passed** the exam.*_ (She didn''t study hard; she didn''t pass.)
_*If I **had taken** that job, I **could have earned** more.*_ (I didn''t take it.)
_*If we **hadn''t left** so late, we **might have caught** the train.*_ (We left late; we missed it.)

> 🗡️ Tip: Use _could have_ for ability and _might have_ for possibility. Both replace _would have_ when the meaning calls for it.

## ⚡ 2. Mixed Conditionals — Bridging Past and Present

A **mixed conditional** combines clauses from different time zones to express a link between a past situation and a present result (or vice versa).

**Type A — Past condition, present result:**
_If + past perfect (if-clause) → would + base verb (result)_

_*If I **had taken** that job, I **would be** rich now.*_ (I didn''t take the job → that''s why I''m not rich today.)

**Type B — Present condition, past result:**
_If + past simple (if-clause) → would + have + past participle (result)_

_*If I **weren''t** so lazy, I **would have finished** it yesterday.*_ (I am lazy now → that''s why I didn''t finish yesterday.)

| Type     | If-clause    | Result clause                 | Time link      |
| -------- | ------------ | ----------------------------- | -------------- |
| Pure 3rd | past perfect | would/could/might + have + pp | past → past    |
| Mixed A  | past perfect | would + base                  | past → present |
| Mixed B  | past simple  | would + have + pp             | present → past |

> ⚠️ Trap: Mixed conditionals can feel strange at first — one half looks like the third conditional, the other like the second. That''s intentional: each half anchors its own time frame.

## 🛡️ 3. I Wish / If Only — Expressing Wishes and Regrets

**I wish** and **if only** (stronger / more dramatic) express wishes about things that are **not true**.

**Present wish (something untrue now)** → wish + **past simple**:
_*I **wish** I **knew** the answer.* (I don''t know it.)_
_*If only she **were** here.* (She isn''t here.) — use **were** for all subjects in formal/standard English_

**Past regret (something that didn''t happen)** → wish + **past perfect**:
_*I **wish** I **had listened** to her advice.* (I didn''t listen — I regret it.)_
_*If only we **hadn''t left** so early.* (We left early — we regret it.)_

**Wish for change in someone''s behaviour (annoyance)** → wish + **would** + base:
_*I **wish** he **would stop** talking.* (He keeps talking and it annoys me.)_
_*If only the bus **would come** on time.*_

> ⚠️ Trap — the three wish patterns are easy to confuse:
>
> - \*I wish I **knew\*** (present untrue) ✓
> - \*I wish I **had known\*** (past regret) ✓
> - \*I wish I **would know\*** — **WRONG**: _would_ is not used with the same subject as _wish_ (except for stubborn habits/annoyance directed at _someone else_).

## ⚔️ 4. Unless, Provided That, As Long As

These connectors add precision to conditional sentences.

**Unless** = _if … not_. It introduces a **negative condition**:
_*Unless you hurry, you''ll be late.* = *If you **don''t** hurry, you''ll be late.*_
_*I won''t go unless she invites me.* = *I won''t go if she **doesn''t** invite me.*_

> 🗡️ Tip: _Unless_ already contains the negative — never add _not_ inside the unless-clause: _~~Unless you don''t hurry~~_ is wrong.

**Provided that / as long as / on condition that** = a **strong or strict _if_**. They suggest that the condition is essential:
_*I''ll help you, **provided that** you pay me back.*_
_*You can borrow my car **as long as** you''re careful.*_
_*I''ll agree, **on condition that** everyone is informed.*_

## 🌀 5. Forms at a Glance

| Structure                             | Example                                                  |
| ------------------------------------- | -------------------------------------------------------- |
| 3rd conditional                       | _If she had worked harder, she would have passed._       |
| Mixed A (past cond. → present result) | _If I had taken that job, I would be rich now._          |
| Mixed B (present cond. → past result) | _If I weren''t so lazy, I would have finished yesterday._ |
| I wish + past simple                  | _I wish I knew the answer._                              |
| I wish + past perfect                 | _I wish I had listened._                                 |
| I wish + would                        | _I wish he would stop._                                  |
| Unless                                | _Unless you hurry, you''ll be late._                      |
| Provided that                         | _I''ll help, provided that you help back._                |

> 🏆 Gate cleared! You''ve mastered the art of the hypothetical. From past regrets to present wishes to strict conditions — your conditional toolkit is complete. The path ahead: **Reported Speech** in complex narrative contexts and **Modal Verbs** at advanced level await.', '# 📜 Résumé: Advanced Conditionals

- **Third conditional** — imaginary past: _if + past perfect, … would/could/might + have + past participle_ (_If she had studied, she would have passed_ — she didn''t study, she didn''t pass).
- **Mixed conditional A** — past condition → present result: _if + past perfect, … would + base_ (_If I had taken that job, I would be rich now_).
- **Mixed conditional B** — present condition → past result: _if + past simple, … would + have + past participle_ (_If I weren''t so lazy, I would have finished yesterday_).
- **I wish / if only** — three patterns:
  - Present wish (untrue now): _wish + past simple_ (_I wish I knew_ — I don''t know).
  - Past regret: _wish + past perfect_ (_I wish I had listened_ — I didn''t listen).
  - Annoyance / change in behaviour: _wish + would + base_ (_I wish he would stop_ — directed at someone else).
- ⚠️ **Wish trap** — never _~~I wish I would know~~_ (same subject + would for a state is wrong). Use _I wish I knew_ for present, _I wish I had known_ for past.
- **Unless** = _if … not_ — already negative, so never add _not_ inside the clause (_Unless you hurry_ = _If you don''t hurry_).
- **Provided that / as long as / on condition that** — strong conditional connectors meaning "only if this strict condition is met".', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', 'Gerunds and Infinitives', 'Navigate one of English''s trickiest choices: when to use verb + -ing versus verb + to, how certain verbs change meaning with each form, and why prepositions always take the gerund.', '# 🗺️ Gerunds and Infinitives — Choosing the Right Verb Form

> 💡 «Two paths, one junction. Knowing which to take can change the meaning of a whole sentence — or make it grammatically impossible.»

## 🏰 What are they?

A **gerund** is a verb ending in **-ing** that functions as a noun.
A **to-infinitive** is **to + base verb**, also used as a noun or to show purpose.

_**Swimming** is excellent exercise._ — _I enjoy **reading** before bed._ (gerund as subject / object)

_**To succeed**, you need to work hard._ — _I want **to go** home._ (infinitive showing purpose / as object)

## 🛡️ Verbs followed by GERUND only

These verbs always take -ing. There is no option for a to-infinitive:

**enjoy, finish, mind, avoid, imagine, suggest, consider, keep, deny, admit, miss, practise, risk, can''t help**

_She **finished writing** the report at midnight._
_I **avoid driving** during rush hour._
_He **admitted stealing** the money._
_Do you **mind waiting** for five minutes?_

## ⚡ Verbs followed by INFINITIVE only

These verbs always take to + base verb:

**want, need, decide, hope, plan, seem, manage, refuse, offer, agree, expect, promise, tend, appear**

_They **decided to move** to a new city._
_She **managed to pass** the exam despite being ill._
_He **refused to answer** the question._
_We **tend to underestimate** how long things take._

## 🔮 Verbs followed by BOTH (same meaning)

These verbs can take either form with no difference in meaning:

**like, love, hate, prefer, begin, start, continue**

_I **love swimming**. / I **love to swim**._ (both are correct)
_It began **raining** / It began **to rain**._ (both are correct)

> 🗡️ Tip: With **like/love/hate/prefer**, both forms are equally acceptable. At B2, prefer the gerund after a preposition and the infinitive to express a specific occasion.

## 🎯 Verbs that CHANGE MEANING — the critical B2 distinction

This is where B2 candidates lose points. The same verb means something different depending on which form follows it.

| Verb         | + gerund                                      | + infinitive                                              |
| ------------ | --------------------------------------------- | --------------------------------------------------------- |
| **stop**     | stop doing (cease an activity)                | stop to do (pause in order to do something else)          |
| **remember** | remember doing (recall a past event)          | remember to do (not forget to do a future/scheduled task) |
| **try**      | try doing (experiment with something)         | try to do (make an effort, attempt)                       |
| **forget**   | forget doing (fail to recall a past event)    | forget to do (fail to remember to do something)           |
| **regret**   | regret doing (feel sorry about a past action) | regret to do (formal: be sorry to say/inform)             |
| **go on**    | go on doing (continue the same activity)      | go on to do (move on to a new activity)                   |

_He **stopped smoking** last year._ (he no longer smokes)
_He **stopped to smoke** outside._ (he paused what he was doing in order to have a cigarette)

_**I remember locking** the door._ (I have a memory of doing it)
_**Remember to lock** the door!_ (don''t forget — it''s a future task)

_**Try adding** more salt._ (experiment — see if it improves things)
_**I tried to open** the jar but I couldn''t._ (I made an effort but failed)

_She **forgot meeting** him before._ (she has no memory of the past event)
_She **forgot to meet** him._ (she was supposed to meet him but didn''t)

_I **regret saying** that — it was cruel._ (sorry about a past action)
_We **regret to inform** you that your application was unsuccessful._ (formal, present bad news)

_She **went on talking** for an hour._ (continued the same activity)
_After the speech, she **went on to answer** questions._ (moved to the next activity)

## 🌍 Prepositions always take the gerund

After **any preposition**, you must use the gerund. This is a hard rule.

_She is good **at solving** problems._
_He left **without saying** goodbye._
_I''m interested **in learning** more._
_Thank you **for helping** me._

> ⚠️ Trap: **to** can be a preposition (not an infinitive marker) — in this case it ALSO takes the gerund, not the base verb:
>
> - **look forward to seeing** you _(not: look forward to see)_
> - **be used to working** hard _(not: be used to work)_
> - **object to paying** _(not: object to pay)_

## 🗡️ Tips and traps

> 🗡️ Tip: After **make**, **let**, and **would rather**, use the **bare infinitive** (no _to_): _She made me **wait**._ _Let him **go**._ _I would rather **stay** home than go out._ But after **be made to**, the _to_ returns: _I was made **to wait**._

> ⚠️ Trap: Don''t confuse **used to do** (past habit, no longer true: _I used to play tennis_) with **be/get used to doing** (be accustomed to: _I''m used to working nights_). The second one is a preposition phrase → always gerund.

> 🏆 Chapter 5 mastered! Gerunds and infinitives are the gateway to truly fluent B2 grammar. With this under your belt, you have command of the full B2 verb system. The quest continues — you are ready for the final challenges ahead.', '# 📜 Résumé: Gerunds and Infinitives

- **Gerund** — verb + -ing used as a noun (_Swimming is fun, I enjoy reading_).
- **To-infinitive** — to + base verb (_I want to go, She hopes to pass_).
- **Gerund-only verbs** — enjoy, finish, mind, avoid, imagine, suggest, consider, keep, deny, admit, miss, practise, risk, can''t help → always followed by -ing.
- **Infinitive-only verbs** — want, need, decide, hope, plan, seem, manage, refuse, offer, agree, expect, promise, tend, appear → always followed by to + verb.
- **Both, same meaning** — like, love, hate, prefer, begin, start, continue → _I love swimming_ = _I love to swim_.
- **Meaning-change verbs** (critical B2):
  - **stop doing** (cease) vs **stop to do** (pause in order to)
  - **remember doing** (recall past) vs **remember to do** (not forget future task)
  - **try doing** (experiment) vs **try to do** (make an effort)
  - **forget doing** (no memory of past) vs **forget to do** (fail to do future task)
  - **regret doing** (sorry about past) vs **regret to do** (formal: sorry to inform)
  - **go on doing** (continue same activity) vs **go on to do** (move to next activity)
- **Prepositions always take the gerund** — _good at solving, without saying, interested in learning, thank you for helping_.
- ⚠️ **"to" as a preposition** also takes the gerund: _look forward to seeing_ (NOT _to see_), _be used to working_ (NOT _to work_), _object to paying_.
- **make / let / would rather** → bare infinitive (no _to_): _She made me wait. Let him go. I would rather stay home._
- ⚠️ **used to do** (past habit) ≠ **be used to doing** (be accustomed to) — the second is a preposition phrase and takes the gerund.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', 'Future Continuous and Future Perfect', 'Master two advanced future tenses: will be + -ing for actions in progress at a specific future moment, will have + past participle for actions completed by a future point, the future perfect continuous, and precise contrasts with will and going to.', '# 🚀 Future Continuous and Future Perfect — Pinning Actions in Future Time

> 💡 «will and going to tell you what happens. The future continuous and future perfect tell you _exactly where_ in time it happens — whether it will be in progress or already finished.»

## ⚔️ Future Continuous — an action in progress at a future moment

Form: **will be + verb-ing**

Use the future continuous to describe an action that will be _in progress_ at a particular moment in the future — like a camera freeze-frame.

| Subject | Form                           | Example                                      |
| ------- | ------------------------------ | -------------------------------------------- |
| I / he  | **will be** + _-ing_           | _I **will be working** at 9 a.m. tomorrow._  |
| she/we  | **won''t be** + _-ing_          | _She **won''t be sleeping** when you arrive._ |
| they    | **Will** + S + **be** + _-ing_ | **\*Will** they **be waiting** for us?\*     |

_At this time next week, I **will be flying** over the Atlantic._
_Don''t call at noon — he **will be giving** his presentation._

> 🗡️ Tip: use the future continuous to politely ask about someone''s plans (it sounds less demanding): _Will you be using the car tonight?_ vs the more direct _Are you going to use the car tonight?_

## 🏆 Future Perfect — completed before a future point

Form: **will have + past participle**

Use the future perfect to show that an action will be _finished_ before or by a specific future moment. Key signal words: **by, by the time, before, by then**.

| Subject | Form                           | Example                                             |
| ------- | ------------------------------ | --------------------------------------------------- |
| I / he  | **will have** + _past part._   | _I **will have finished** by 6 p.m._                |
| she/we  | **won''t have** + _past part._  | _She **won''t have left** by the time you get here._ |
| they    | **Will** + S + **have** + _pp_ | **\*Will** you **have eaten** before we arrive?\*   |

_By this time next year, she **will have graduated**._ ✓
_They **will have been** together for ten years by July._ ✓

> 🗡️ Tip: **by** is the most common trigger — it means "at some point no later than": _by Monday, by the time she calls, by 2030_.

## ⚡ Future Perfect Continuous — ongoing up to a future point

Form: **will have been + verb-ing**

Use it to emphasise _how long_ something will have been going on by a future point.

_By June, I **will have been studying** English for five years._
_When they land, the pilot **will have been flying** for eight hours._

> ⚠️ Trap: do not confuse _will have been working_ (future perfect continuous — duration up to a point) with _will be working_ (future continuous — in progress at that moment).

## 🛡️ Contrast: will vs going to vs future continuous

| Form               | Use                                            | Example                          |
| ------------------ | ---------------------------------------------- | -------------------------------- |
| **will**           | instant decision, prediction, offer            | _I''ll get the door._             |
| **going to**       | intention, evidence-based prediction           | _She''s going to miss her train._ |
| **will be + -ing** | in progress at a future moment; polite enquiry | _I''ll be working at 8 tomorrow._ |
| **will have + pp** | finished before a future point                 | _I''ll have done it by Monday._   |

_She **will be presenting** her project at 3 p.m._ (in progress at that moment)
_She **will have presented** her project by 4 p.m._ (finished before that time)

> ⚠️ Trap: with _by the time_ the subordinate clause uses the **present simple**, not a future form: _By the time you **arrive**, I **will have cooked** dinner._ (NOT: _~~by the time you will arrive~~_)

## 🧭 Choosing the right form — quick test

1. Will it be happening _at_ that future time? → **future continuous**
2. Will it be _finished_ before/by that future time? → **future perfect**
3. Do you want to stress _how long_ it will have lasted? → **future perfect continuous**

_At 9 tonight I **will be watching** the match._ (in progress)
_By 11 tonight I **will have watched** the match._ (finished)
_By then, I **will have been watching** football for three hours._ (duration)

> 🏆 Gate cleared! You can now place any action precisely in future time — in progress, completed, or ongoing. Next challenge: **Reading Comprehension**, where you decode how arguments are built and what writers really mean.', '# 📜 Résumé: Future Continuous and Future Perfect

- **Future continuous** — _will be + verb-ing_: action in progress at a specific future moment. _At 9 a.m. tomorrow I will be working._
- **Future perfect** — _will have + past participle_: action completed before/by a future point. _By 6 p.m. I will have finished._
- **Future perfect continuous** — _will have been + verb-ing_: stresses duration up to a future point. _By June I will have been studying English for five years._
- **Key signal words** — by, by the time, before, by then → future perfect. At this time tomorrow / at 3 p.m. → future continuous.
- **Contrast will / going to**: will = instant decision or offer; going to = intention or evidence-based prediction. Future continuous / perfect add _temporal precision_, not just intention.
- **Polite enquiry** — future continuous softens a question about plans: _Will you be using the car tonight?_
- ⚠️ After _by the time_, use the **present simple** in the subordinate clause, not a future form: _By the time you **arrive**, I will have cooked dinner._
- ⚠️ Do not mix _will be working_ (in progress at that moment) with _will have been working_ (duration up to that point) — they express different things.
- **Quick test**: happening _at_ a future time → continuous; _finished by_ a future time → perfect; _how long_ by a future time → perfect continuous.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', 'Reading Comprehension: Argument and Inference', 'Decode B2 texts — opinion pieces and reports — by identifying the main argument, recognising the writer''s attitude and tone, making inferences, understanding vocabulary in context, and distinguishing fact from opinion.', '# 🔍 Reading Comprehension: Argument and Inference — Decode What Writers Really Mean

> 💡 «A B2 reader doesn''t just understand the words on the page — they understand the _mind behind_ the words: what the writer argues, how they feel about it, and what they imply without saying.»

## 🏰 The five core skills

At B2, every reading task tests one or more of these five skills. Know what each one demands.

| Skill                     | Question clue                         | What to do                                                    |
| ------------------------- | ------------------------------------- | ------------------------------------------------------------- |
| **Main argument**         | "What is the writer''s main point?"    | Find the idea the whole text supports                         |
| **Attitude / tone**       | "How does the writer feel about…?"    | Read word choice — is it positive, critical, ironic, neutral? |
| **Inference**             | "What does the writer suggest/imply?" | Read between the lines — the answer is not stated directly    |
| **Vocabulary in context** | "The word X in line 4 means…"         | Use surrounding words and logic, not memory alone             |
| **Fact vs opinion**       | "Which statement is a fact?"          | Facts can be verified; opinions use evaluative language       |

## ⚔️ Finding the main argument

The **main argument** is the central claim the writer builds the entire text around. It is usually:

- stated early (thesis statement in an opinion piece)
- restated at the end (conclusion)
- supported by every paragraph in between

> 🗡️ Tip: the main argument is _not_ just the topic. "Social media" is a topic. "Social media has made genuine human connection harder" is a main argument.

_Example:_ A writer spends three paragraphs showing how remote work boosts productivity, reduces commuting stress, and saves companies money. The main argument is: _remote work is beneficial for both employees and employers_.

## 🛡️ Recognising attitude and tone

Writers reveal their attitude through **word choice (diction)**. Compare:

- _The policy **failed** to address the core problem._ → **critical**
- _The policy **partially addressed** the core problem._ → **neutral / measured**
- _Remarkably, the policy **managed** to address the core problem._ → **surprised but positive**

Key tone words to recognise:

| Tone                    | Signal words                                                             |
| ----------------------- | ------------------------------------------------------------------------ |
| **Sceptical**           | questions whether, remains unconvinced, dubious                          |
| **Enthusiastic**        | remarkable, groundbreaking, transformative                               |
| **Ironic / sardonic**   | supposed benefit, so-called experts, naturally (when things go wrong)    |
| **Cautious / balanced** | while … nevertheless, it could be argued that, not without its drawbacks |

> ⚠️ Trap: irony means the writer says the _opposite_ of what they mean. _"The plan was, of course, a resounding success"_ — if the context is disaster, the writer is being sarcastic. Look at context, not isolated words.

## 🔮 Making inferences

An **inference** question asks what the writer _implies_ — something true but not directly stated.

**Strategy: the three-step inference method**

1. Re-read the relevant paragraph carefully.
2. Ask: what does the writer assume the reader will understand, even though it isn''t written?
3. Eliminate options that are directly stated (too obvious), directly contradicted, or completely unsupported.

_Example passage:_ _"Despite its headline figures, the city''s unemployment rate tells only part of the story — many residents have given up searching for work entirely."_

_Inference question:_ What does the writer imply about the unemployment figures?
→ The official figures **underestimate** the true level of unemployment. (implied — not stated directly)

> 🗡️ Tip: a correct inference is _supported by_ the text, even if it isn''t stated in so many words. A wrong option is either directly stated (not an inference), directly denied, or a wild guess with no textual basis.

## 🧭 Vocabulary in context

Do not rely on knowing the word in isolation — the **surrounding sentence or paragraph** tells you its meaning.

**Strategy:**

1. Cover the word and read the sentence around it.
2. Decide what _kind_ of meaning fits (positive/negative? noun/verb? cause/result?).
3. Substitute each option and check it makes sense in context.

_"The new regulation was met with widespread **consternation** among business owners."_
Even if you don''t know _consternation_, the clue is "met with … among business owners" reacting to regulation — likely negative (alarm, dismay). Eliminate neutral or positive options.

## ⚡ Fact vs opinion

| Fact                             | Opinion                                             |
| -------------------------------- | --------------------------------------------------- |
| Can be verified with evidence    | Reflects a judgment or evaluation                   |
| Uses neutral, objective language | Uses evaluative language                            |
| _"Sales fell by 12% in Q3."_     | _"The company made a terrible strategic error."_    |
| _"The law was passed in 2019."_  | _"This is the most significant reform in decades."_ |

> ⚠️ Trap: a **statistic** is a fact, but a **conclusion drawn from it** is often an opinion. _"Prices rose 8%"_ is a fact; _"the government''s policy caused this rise"_ is an opinion (it is an interpretation).

## 🌍 Strategy summary — the B2 reading workflow

1. **Skim** the whole text first (30 seconds) — get the topic, structure, and tone.
2. **Read each question** before you re-read the relevant section.
3. **Locate and re-read** the relevant paragraph carefully.
4. **Eliminate** answers that are directly stated (for inference), directly contradicted, or off-topic.
5. **Choose** the option best supported by the text — not by your personal knowledge.

> ⚠️ Trap: never use outside knowledge to answer a reading question. The answer must come from the text itself.

> 🏆 Gate cleared! You can now identify what a writer argues, how they feel, what they imply, and whether they are stating facts or opinions. These skills unlock every B2 reading task — and beyond.', '# 📜 Résumé: Reading Comprehension: Argument and Inference

- **Main argument** — the central claim the whole text supports; usually stated early and restated at the end. Distinguish topic (what it''s about) from argument (what the writer claims about it).
- **Attitude / tone** — revealed by word choice: sceptical (questions whether, dubious), enthusiastic (remarkable, transformative), ironic (so-called, of course — when context is negative), cautious/balanced (while … nevertheless).
- **Inference** — what the writer implies but does not state directly. Re-read the paragraph, ask what is assumed, then eliminate options that are directly stated, directly contradicted, or unsupported.
- **Vocabulary in context** — cover the target word, decide its register and polarity from context, substitute each option, pick the best fit. Never rely on the isolated word alone.
- **Fact vs opinion** — facts are verifiable and use neutral language; opinions use evaluative language. A statistic is a fact; a conclusion drawn from it is often an opinion.
- **B2 reading workflow**: skim → read questions → locate and re-read → eliminate → choose what the text supports.
- ⚠️ Irony: the writer says the opposite of what they mean — read context, not just isolated words.
- ⚠️ Never use outside knowledge to answer a reading question — the answer must come from the text.
- ⚠️ A correct inference is _supported by_ the text even if not stated; a wrong option is directly stated (not an inference), directly denied, or a baseless guess.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', 'The Past Perfect', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5851e410-038c-59a9-bb73-9630f75d4464', 'ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'Fill in the gap: ''By the time she arrived, he ___ already left.''', '[{"id":"a","text":"has"},{"id":"b","text":"was"},{"id":"c","text":"have"},{"id":"d","text":"had"}]'::jsonb, 'd', 'The past perfect is formed with ''had + past participle''. ''By the time'' signals that one past action (leaving) happened before another (arriving). ''Has'' and ''have'' are present perfect forms; ''was'' is the past simple of ''be''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19e70bad-ed9a-5064-877d-1835d3e8656b', 'ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'Which combination of words correctly forms the past perfect?', '[{"id":"a","text":"was + past participle"},{"id":"b","text":"had + past participle"},{"id":"c","text":"have + past participle"},{"id":"d","text":"did + base verb"}]'::jsonb, 'b', '''Had + past participle'' is the only correct form of the past perfect for all subjects. ''Was + past participle'' forms the passive; ''have + past participle'' is the present perfect; ''did + base verb'' is used for past simple questions and negatives.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59713fcd-63f0-5273-ade8-c27cc7d32b1a', 'ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'Fill in the gap: ''They ___ been waiting for an hour before the bus came.''', '[{"id":"a","text":"had"},{"id":"b","text":"have"},{"id":"c","text":"was"},{"id":"d","text":"were"}]'::jsonb, 'a', 'The past perfect continuous is formed with ''had + been + verb-ing''. ''Had been waiting'' shows that the waiting was ongoing over a period of time before another past event (the bus arriving). ''Have'' is present; ''was/were'' are past simple forms of ''be''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('618555be-0df5-5331-bccf-1b5cf23ca0f3', 'ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'Which sentence most clearly benefits from the past perfect (rather than two past simples)?', '[{"id":"a","text":"I woke up and then I had a shower."},{"id":"b","text":"She cooked dinner and then she ate it."},{"id":"c","text":"He was tired because he had worked all night."},{"id":"d","text":"They arrived and then they left immediately."}]'::jsonb, 'c', 'Without ''had worked'', the sentence would read ''he was tired because he worked all night'', which could imply simultaneous actions. The past perfect ''had worked'' clearly shows the working happened first and caused the tiredness. In options A, B, and D, the sequence is already obvious from context or ''and then''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adff794d-7ae7-57d0-9ac6-4f86dbc1d4c5', 'ecc4d8f6-ad7d-5b31-bbd6-8388f24a3b3a', 'Find the INCORRECT use of the past perfect in the following sentences.', '[{"id":"a","text":"When I got there, everyone had already eaten."},{"id":"b","text":"She had never visited Rome before that holiday."},{"id":"c","text":"I had eaten pizza last night."},{"id":"d","text":"After he had finished the report, he went home."}]'::jsonb, 'c', '''I had eaten pizza last night'' is incorrect because ''last night'' is a finished time reference with no other past event to connect to — the past simple ''I ate pizza last night'' is correct here. The past perfect requires a reference point in the past (another past event or time marker like ''by the time / when / before / after''). Options A, B, and D all correctly link the past perfect to another past anchor.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c67ac08d-3246-51ff-b0e3-e390eb153e06', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', '⭐ Practice: Past Perfect Form', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70b6d97e-6e56-5608-b0b8-220f8a148fed', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Complete the sentence: ''When I arrived, the film ___ already started.''', '[{"id":"a","text":"was"},{"id":"b","text":"had"},{"id":"c","text":"has"},{"id":"d","text":"were"}]'::jsonb, 'b', '''Had already started'' is the past perfect. The film''s starting happened BEFORE I arrived — that earlier past event requires ''had + past participle''. ''Was'' is past simple of ''be''; ''has'' is present perfect (wrong tense); ''were'' does not fit the singular ''film''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('318db386-95a2-5619-95cd-f9488c052022', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Complete the sentence: ''She ___ never flown before that trip.''', '[{"id":"a","text":"has"},{"id":"b","text":"have"},{"id":"c","text":"hadn''t"},{"id":"d","text":"had"}]'::jsonb, 'd', '''Had never flown'' is the affirmative past perfect with ''never''. The reference point is ''that trip'' (a past event), so we need past perfect, not present perfect (''has/have''). ''Hadn''t'' would make the sentence ''she hadn''t never flown'' — a double negative, which is incorrect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e3f7614-84e2-5330-8235-2bc76a2ab4b4', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Complete the sentence: ''They ___ finished dinner before the guests arrived.''', '[{"id":"a","text":"have"},{"id":"b","text":"had"},{"id":"c","text":"were"},{"id":"d","text":"has"}]'::jsonb, 'b', '''Had finished'' is the past perfect. ''Before the guests arrived'' tells us the dinner was completed first — ''had + past participle'' shows this earlier-past action. ''Have/has'' are present perfect; ''were'' is past simple of ''be''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a9231e5-e509-5a6c-80a9-fe506ec2ce8c', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Find the INCORRECT sentence.', '[{"id":"a","text":"By the time we left, she had already called."},{"id":"b","text":"He had never tried sushi before that evening."},{"id":"c","text":"I had visited London last summer."},{"id":"d","text":"After they had spoken, he felt much better."}]'::jsonb, 'c', '''I had visited London last summer'' is incorrect. ''Last summer'' is a simple past time reference with no other past event to connect to — the past perfect cannot stand alone. The correct form is ''I visited London last summer''. Options A, B, and D all correctly anchor the past perfect to another past event or reference point.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7997e375-25f1-572b-b169-47623a520730', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Complete the sentence: ''He realised he ___ forgotten his passport.''', '[{"id":"a","text":"had"},{"id":"b","text":"have"},{"id":"c","text":"was"},{"id":"d","text":"has"}]'::jsonb, 'a', '''Had forgotten'' is the past perfect. The forgetting happened BEFORE he realised — ''had + past participle'' shows this sequence. ''Have/has'' are present perfect forms; ''was'' is the past simple of ''be'' and cannot combine with ''forgotten'' to form the past perfect.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d8025a3-5754-5140-b0d4-01d786c8c227', 'c67ac08d-3246-51ff-b0e3-e390eb153e06', 'Complete the sentence: ''She was tired because she ___ been working all night.''', '[{"id":"a","text":"had"},{"id":"b","text":"was"},{"id":"c","text":"has"},{"id":"d","text":"is"}]'::jsonb, 'a', '''Had been working'' is the past perfect continuous: ''had + been + verb-ing''. It emphasises the duration of the working (all night) as an ongoing activity that happened before another past state (''she was tired''). ''Has been working'' is present perfect continuous; ''was'' and ''is'' cannot form the past perfect continuous.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('370c724f-1b0c-5e2f-a87c-b77002e4730e', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', '⭐⭐ Review: Past Perfect vs Past Simple', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d690fad-10ea-5e60-b060-268adf829f55', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'Choose the correct form: ''When the police arrived, the thief ___ (escape).''', '[{"id":"a","text":"escaped"},{"id":"b","text":"had escaped"},{"id":"c","text":"has escaped"},{"id":"d","text":"was escaping"}]'::jsonb, 'b', '''Had escaped'' (past perfect) shows the thief left BEFORE the police arrived — two separate past events in sequence. ''Escaped'' (past simple) would suggest they happened simultaneously or in unclear order. ''Has escaped'' is present perfect (wrong tense context). ''Was escaping'' (past continuous) implies the escape was still in progress when the police arrived, which changes the meaning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b7557ee-b77b-54de-b0f3-47fc69f54e37', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'Which sentence uses BOTH tenses correctly to show a clear sequence?', '[{"id":"a","text":"After she had eaten, she had gone to sleep."},{"id":"b","text":"After she ate, she had gone to sleep."},{"id":"c","text":"After she had eaten, she went to sleep."},{"id":"d","text":"After she was eating, she went to sleep."}]'::jsonb, 'c', 'When using ''after + past perfect'', the later (second) action takes the past simple: ''After she had eaten (earlier action), she went to sleep (later action)''. Option A incorrectly uses past perfect for both actions. Option B is less natural because ''after'' already signals sequence. Option D (past continuous) changes the meaning — she would still be eating when she went to sleep.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3f9816f-eae7-52ef-92be-312744d8127d', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'Choose the BEST sentence to describe these events in order: [1] He lost his wallet. [2] He couldn''t pay for dinner.', '[{"id":"a","text":"He couldn''t pay for dinner because he had lost his wallet."},{"id":"b","text":"He couldn''t pay for dinner because he lost his wallet."},{"id":"c","text":"He couldn''t pay for dinner because he has lost his wallet."},{"id":"d","text":"He couldn''t pay for dinner because he was losing his wallet."}]'::jsonb, 'a', '''Had lost'' (past perfect) clearly signals that the wallet loss (event 1) happened BEFORE the dinner problem (event 2). Option B (''lost'' — past simple) is grammatically possible but less precise — the sequence is ambiguous. Option C (''has lost'' — present perfect) is incorrect in a fully past narrative. Option D (''was losing'' — past continuous) changes the meaning entirely — losing would be in progress, which is illogical.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11ac386a-f1d1-5b43-903a-a750a742e8a2', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'Fill in the gap: ''I ___ (not/eat) anything that day, so I was starving by evening.''', '[{"id":"a","text":"didn''t eat"},{"id":"b","text":"haven''t eaten"},{"id":"c","text":"hadn''t eaten"},{"id":"d","text":"wasn''t eating"}]'::jsonb, 'c', '''Hadn''t eaten'' (past perfect negative) shows that the not-eating covered the period BEFORE being starving by evening — both events are in the past. ''Didn''t eat'' (past simple) is less precise about the connection between cause and effect. ''Haven''t eaten'' (present perfect) is incorrect in a past context. ''Wasn''t eating'' (past continuous negative) implies a single moment, not the whole day.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6938fd06-3daf-5e4e-bbb5-71be53d9d426', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'The events in order are: [1] She studied hard. [2] She passed the exam. Choose the correct sentence.', '[{"id":"a","text":"She had passed the exam because she had studied hard."},{"id":"b","text":"She had passed the exam because she studied hard."},{"id":"c","text":"She passed the exam because she studied hard."},{"id":"d","text":"She passed the exam because she had studied hard."}]'::jsonb, 'd', 'The earlier action (studying) takes the past perfect ''had studied''; the later result (passing) takes the past simple ''passed''. This is the standard pattern: past perfect for the first event, past simple for the second. Option A (''had passed… had studied'') uses past perfect for both actions — incorrect, the later action (passing) should be past simple. Option B (''had passed… studied'') also uses past perfect for the later action (passing) — wrong. Option C (''passed… studied'') uses past simple for both — grammatically acceptable but less precise about cause and effect.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('399b7d58-831b-59da-a9a4-cbad799ec8e1', '370c724f-1b0c-5e2f-a87c-b77002e4730e', 'Read the mini-story and choose the correct version: ''Tom got to the cinema at 7:00. The film started at 6:45.''', '[{"id":"a","text":"When Tom arrived, the film started."},{"id":"b","text":"When Tom arrived, the film had already started."},{"id":"c","text":"When Tom arrived, the film has already started."},{"id":"d","text":"When Tom arrived, the film was starting."}]'::jsonb, 'b', 'The film started at 6:45 — BEFORE Tom arrived at 7:00. The past perfect ''had already started'' correctly shows this earlier-past event. Option A (''started'') implies the film began at the exact moment Tom walked in — wrong according to the timeline. Option C (''has started'') is present perfect — incorrect in a past narrative. Option D (''was starting'') implies the film was just beginning when he arrived, which contradicts the timeline.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: The Past Perfect', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4a6d6e3-adb2-5a4d-b493-082e668b8415', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Read the passage: ''Maya opened the fridge. There was nothing inside. She ___  forgotten to go shopping.'' Which form best completes the sentence?', '[{"id":"a","text":"had forgotten"},{"id":"b","text":"has forgotten"},{"id":"c","text":"forgot"},{"id":"d","text":"was forgetting"}]'::jsonb, 'a', '''Had forgotten'' (past perfect) is correct. The forgetting happened BEFORE she opened the fridge and found it empty — the past perfect explains the cause of the earlier situation. ''Forgot'' (past simple) would suggest the forgetting happened at the same moment as opening the fridge. ''Has forgotten'' is present perfect — wrong in a fully past narrative. ''Was forgetting'' (past continuous) implies an ongoing process of forgetting, which is illogical here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e824950-b8c3-5896-916e-8ecbbb662c60', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Which sentence uses the past perfect continuous CORRECTLY?', '[{"id":"a","text":"He had been understood the problem for years."},{"id":"b","text":"She had been running for 30 minutes when it started to rain."},{"id":"c","text":"They had been arrive late to every meeting."},{"id":"d","text":"I had been known him since childhood."}]'::jsonb, 'b', '''Had been running for 30 minutes'' correctly uses past perfect continuous (had + been + -ing) to show an ongoing activity before another past event (rain starting). Option A is wrong: ''understand'' is a stative verb and cannot be used in continuous form. Option C misuses ''arrive'' — the base form after ''been'' must end in -ing (''had been arriving''). Option D: ''know'' is stative and cannot be continuous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('057bba00-df23-5587-8781-9fc5ae3c4475', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Passage: ''The concert hall was empty when we got there. We checked our tickets — the event ___ the previous evening.'' What is the correct form?', '[{"id":"a","text":"was"},{"id":"b","text":"took place"},{"id":"c","text":"has taken place"},{"id":"d","text":"had taken place"}]'::jsonb, 'd', '''Had taken place'' (past perfect) is correct. The concert happened the previous evening — BEFORE the moment when ''we got there''. The past perfect links this earlier event to the discovery. ''Was'' doesn''t convey the completed earlier event. ''Took place'' (past simple) is possible but less precise — it does not clearly signal the relationship between the two past events. ''Has taken place'' (present perfect) is incorrect in a fully past context.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4d700a2-b62e-5d21-9bfb-30d6bfba780e', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Transform to correctly express sequence: ''First she wrote the email. Then she sent it.'' Choose the best single sentence.', '[{"id":"a","text":"She sent the email after she had written it."},{"id":"b","text":"She had sent the email after she had written it."},{"id":"c","text":"She had written the email after she sent it."},{"id":"d","text":"She sent the email after she wrote it."}]'::jsonb, 'a', 'The earlier action (writing) takes the past perfect ''had written''; the later action (sending) takes the past simple ''sent''. This correctly follows the rule: past perfect for the first event, past simple for the second. Option B (''had sent… had written'') uses past perfect for the LATER action (sending) — wrong. Option C reverses the logic: ''had written AFTER she sent it'' — the order is impossible here. Option D (both past simple: ''sent… wrote'') is grammatically possible but less precise about sequence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc348641-b452-5d06-938b-cf7a759510d8', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Spot the error: ''By the time the ambulance had arrived, the patient had recovered.'' What is wrong?', '[{"id":"a","text":"Nothing is wrong — both past perfects are correct."},{"id":"b","text":"''had recovered'' should be ''has recovered'' — it refers to a current state."},{"id":"c","text":"''had arrived'' should be ''has arrived'' — ambulances are present-perfect subjects."},{"id":"d","text":"''had arrived'' should be ''arrived'' — the arrival is the later reference point, not the earlier event."}]'::jsonb, 'd', '''By the time'' introduces the reference point (the later past event) — which should be in the PAST SIMPLE: ''By the time the ambulance arrived''. The past perfect ''had recovered'' correctly shows the earlier event (the patient recovering before the ambulance got there). Using past perfect for the reference point (''by the time + past perfect'') is a common learner error. Options A, B, and C are all incorrect diagnoses: A claims both past perfects are fine; B wrongly changes ''had recovered''; C invents a rule about ambulances.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07368752-2ee9-56ae-8179-417be7f0fea9', '90d3a2b3-fe1c-5401-8a4b-796df2a1ee5f', 'Read: ''James looked at the whiteboard. The teacher ___ already ___ the answer, but James had missed the explanation.'' Which form fills both gaps?', '[{"id":"a","text":"was / writing"},{"id":"b","text":"has / written"},{"id":"c","text":"had / written"},{"id":"d","text":"did / write"}]'::jsonb, 'c', '''Had already written'' (past perfect) shows that the teacher finished writing the answer BEFORE James looked at the board. The word ''already'' is a strong signal for the past perfect. ''Was writing'' (past continuous) would imply the teacher was still in the process of writing — but ''already'' suggests completion. ''Has written'' is present perfect — wrong tense. ''Did write'' is a past simple emphatic form that doesn''t work with ''already'' in this structure.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('517d7d93-c537-5e72-8b71-9a9f4ab79232', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: The Past Perfect', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('841e1511-57a0-5984-935b-10b6fa9698c5', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Read: ''The detective noticed the window ___ been broken from the inside, which meant the intruder ___ already in the house.'' Choose the pair that fills both gaps correctly.', '[{"id":"a","text":"has / was"},{"id":"b","text":"had / had been"},{"id":"c","text":"was / has been"},{"id":"d","text":"had / was"}]'::jsonb, 'b', 'Both gaps require past perfect to show events that occurred BEFORE the detective''s discovery. ''Had been broken'' (past perfect passive) and ''had been'' (past perfect of ''be'') correctly sequence both facts as earlier-past. Option D (''had / was'') is almost correct but ''was already in the house'' (past simple) doesn''t clearly show the intruder was inside BEFORE the detective arrived — past perfect ''had been'' is more precise. Options A and C mix tenses incorrectly.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7a62494-dc4b-5015-b7d1-7dadd66108b6', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Four students describe a past experience. Which student uses the past perfect INCORRECTLY?', '[{"id":"a","text":"Ana: ''I had already submitted my essay when the teacher extended the deadline.''"},{"id":"b","text":"Ben: ''By the time I learned to drive, my brother had owned a car for three years.''"},{"id":"c","text":"Cara: ''I had studied French for ten years ago.''"},{"id":"d","text":"Dan: ''When she called, I had just stepped out of the shower.''"}]'::jsonb, 'c', 'Cara''s sentence is wrong: ''I had studied French for ten years ago'' combines the past perfect with ''ago'', which always requires the past simple (''I studied French ten years ago''). The past perfect cannot be used with ''ago'' — it needs a past event anchor, not a time-ago reference. Ana (A), Ben (B), and Dan (D) all correctly anchor their past perfects to another past event or time reference.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79242a59-96f6-592e-9e1a-554a9a700fe8', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Read the passage: ''Sarah felt terrible. She realised she ___ been rude to her colleague earlier, and he ___ already left the office without speaking to her.'' Which pair is correct?', '[{"id":"a","text":"had / had"},{"id":"b","text":"has / had"},{"id":"c","text":"had / has"},{"id":"d","text":"was / had"}]'::jsonb, 'a', 'Both gaps need ''had'': ''had been rude'' (past perfect — the rudeness happened before she realised it) and ''had already left'' (past perfect — the colleague left before she realised). Both earlier-past events require past perfect in this fully past narrative. Options B and C mix in the present perfect ''has'', which is wrong in a past context. Option D (''was rude'') would be past simple/continuous and doesn''t fit the ''realised'' structure.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49c6663c-5a48-51a8-b88d-2bc5d34259ba', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Which of the following sentences is AMBIGUOUS without the past perfect — i.e., the past perfect is NECESSARY to avoid misunderstanding?', '[{"id":"a","text":"She woke up and then she got dressed."},{"id":"b","text":"After the rain stopped, they went outside."},{"id":"c","text":"He was nervous because he spoke in public."},{"id":"d","text":"Before she left, she locked the door."}]'::jsonb, 'c', '''He was nervous because he spoke in public'' is ambiguous: did he speak (causing his nervousness), or was he nervous at the moment of speaking? ''Had spoken'' would clarify he was nervous AFTER the speaking event. Options A and D are ordered sequentially with connectors (then/before) that already make the order clear. Option B uses ''after'' which signals sequence — past perfect is optional but not necessary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c57e0b6d-f59a-5ea6-b69c-b60f748f0857', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Complete with the correct form: ''The athletes ___ been training for months, so they were confident when the competition finally arrived.''', '[{"id":"a","text":"were"},{"id":"b","text":"had"},{"id":"c","text":"have"},{"id":"d","text":"has"}]'::jsonb, 'b', '''Had been training'' is the past perfect continuous: ''had + been + verb-ing''. It emphasises the extended duration of training (for months) as a process that happened BEFORE the competition arrived. ''Were been training'' is impossible (''were'' + ''been'' is not a valid English structure). ''Have/has been training'' is present perfect continuous — wrong in a past narrative anchored to ''the competition finally arrived''.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4360449a-331f-5b8b-b202-92a4a9e468b6', '517d7d93-c537-5e72-8b71-9a9f4ab79232', 'Read: ''It was the first time Anna ___ ever performed on stage.'' Which form is correct?', '[{"id":"a","text":"had ever performed"},{"id":"b","text":"has ever performed"},{"id":"c","text":"ever performed"},{"id":"d","text":"was ever performing"}]'::jsonb, 'a', 'After ''It was the first time…'' in a past context, the past perfect ''had ever performed'' is required — it refers to her entire experience up to that past moment. Compare: ''It IS the first time she HAS performed'' (present). When the main verb is ''was'', the subordinate clause takes past perfect. Options B (''has performed'') is present perfect — wrong when the main verb is ''was''. Option C (bare past simple) is a common learner error. Option D (past continuous) changes the meaning.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c7bee59c-5269-5887-b368-9364cb8382ac', '92b7bde5-46f4-56dd-a893-a4f675f7281d', 'anglais-b2', '⭐⭐ Drill: Past Perfect', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d9db4ff-46bf-54ca-92c8-f03f7a9bde64', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Choose the correct form: ''By the time we reached the station, the last train ___ already left.''', '[{"id":"a","text":"has"},{"id":"b","text":"had"},{"id":"c","text":"was"},{"id":"d","text":"have"}]'::jsonb, 'b', 'The past perfect ''had already left'' shows the train''s departure happened before we reached the station. ''Has'' and ''have'' are present perfect auxiliaries — wrong in a past narrative. ''Was'' is the past simple of ''be'' and cannot combine with a past participle to form the past perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd468a0e-119d-5619-a4fb-aa7e3b4f31f7', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Which sentence uses the past perfect INCORRECTLY?', '[{"id":"a","text":"She had never eaten Thai food before that evening."},{"id":"b","text":"When the fire started, everyone had evacuated safely."},{"id":"c","text":"After he had locked the door, he realised he''d left his keys inside."},{"id":"d","text":"I had visited my aunt last weekend."}]'::jsonb, 'd', '''Last weekend'' is a finished time reference with no second past event to connect to, so the past simple ''I visited my aunt last weekend'' is correct. The past perfect cannot stand alone — it needs an anchor in another past event or a time connector like ''before'', ''when'', or ''by the time''. Options A, B, and D all correctly link the past perfect to another past reference point.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d10e1bba-47f2-5a83-96f3-2bf446f48f17', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Choose the BEST sentence: The events in order are: [1] He read the script. [2] He agreed to do the film.', '[{"id":"a","text":"He agreed to do the film because he had read the script."},{"id":"b","text":"He had agreed to do the film because he read the script."},{"id":"c","text":"He agreed to do the film because he has read the script."},{"id":"d","text":"He had agreed to do the film because he had read the script."}]'::jsonb, 'a', 'The earlier action (reading the script) takes the past perfect ''had read''; the later result (agreeing) takes the past simple ''agreed''. This is the standard pattern for sequencing two past events with a causal link. Option B wrongly puts the later event (agreeing) in the past perfect. Option C uses the present perfect ''has read'' — incorrect in a past narrative. Option D uses past perfect for both — the later event ''agreed'' should be past simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03e84f0f-bed5-5edc-bfbe-7320e987f4f0', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Complete: ''It was the first time she ___ ever spoken in front of such a large audience.''', '[{"id":"a","text":"was ever speaking"},{"id":"b","text":"has ever spoken"},{"id":"c","text":"had ever spoken"},{"id":"d","text":"ever spoke"}]'::jsonb, 'c', 'After ''It was the first time…'' in a past context, the past perfect ''had ever spoken'' is required — it covers all her experience up to that past moment. Compare: ''It IS the first time she HAS spoken'' (present). When the main clause uses ''was'', the subordinate clause takes the past perfect. ''Has ever spoken'' is present perfect — wrong when the main verb is ''was''. ''Ever spoke'' (bare past simple) is a common learner error.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52f84632-d84f-5ed5-98f7-5bfd038bac75', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Fill in the gap: ''The journalist discovered that the company ___ been hiding the data for over a year.''', '[{"id":"a","text":"was"},{"id":"b","text":"had"},{"id":"c","text":"has"},{"id":"d","text":"were"}]'::jsonb, 'b', '''Had been hiding'' is the past perfect continuous, formed with ''had + been + verb-ing''. It emphasises the extended duration (over a year) of the ongoing concealment, which preceded the journalist''s discovery. ''Was been hiding'' and ''were been hiding'' are impossible structures. ''Has been hiding'' is present perfect continuous — wrong in a past narrative anchored to ''the journalist discovered''.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c312d090-353b-5f8f-83d5-f969852ada06', 'c7bee59c-5269-5887-b368-9364cb8382ac', 'Spot the error: ''By the time the ambulance had arrived, the situation had already stabilised.'' What is wrong?', '[{"id":"a","text":"Nothing — using past perfect for both events is always correct."},{"id":"b","text":"''had stabilised'' should be ''has stabilised'' — the situation affects the present."},{"id":"c","text":"''had arrived'' should be ''arrived'' — the arrival is the later reference point, not the earlier event."},{"id":"d","text":"''had arrived'' should be ''has arrived'' — ambulances are present-tense subjects."}]'::jsonb, 'c', '''By the time'' introduces the later reference point, which must be in the past simple: ''By the time the ambulance arrived''. The past perfect ''had already stabilised'' correctly shows the earlier event (stabilising before the ambulance got there). Using past perfect for the ''by the time'' clause is a very common B2 error. Options B and D suggest incorrect tense changes that do not fix the actual problem; option A wrongly claims both past perfects are fine.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ae4fa2b-4879-5dfa-adf5-96b9c353d213', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', 'The Passive Voice', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfbf01b7-8c97-5c4f-961e-bab30fa864a8', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', 'What is the correct passive form of ''They build new houses every year''?', '[{"id":"a","text":"New houses are built every year."},{"id":"b","text":"New houses were built every year."},{"id":"c","text":"New houses have been built every year."},{"id":"d","text":"New houses are being built every year."}]'::jsonb, 'a', 'The active sentence is in the present simple (''build''), so the passive uses ''is/are + past participle'': ''are built''. Option B (past simple passive) would be for ''They built...''. Option C (present perfect passive) would be for ''They have built...''. Option D (present continuous passive) would be for ''They are building...''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de804372-bb4c-57a6-98a4-2a47f6812aba', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', 'Which sentence is an example of the GET-passive?', '[{"id":"a","text":"The window was broken during the storm."},{"id":"b","text":"The decision has been made by the committee."},{"id":"c","text":"She got promoted last month."},{"id":"d","text":"The letter will be sent tomorrow."}]'::jsonb, 'c', '''Got promoted'' is the get-passive (get + past participle) — informal register, often used for unexpected or significant personal events. Options A and D use ''was/will be'' (be-passive). Option B uses ''has been'' (present perfect passive). The get-passive is only option C.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('500e99a8-ea9a-5b3a-883e-b3a3fc53443a', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', 'Which passive transformation is CORRECT for: ''They are building a new hospital''?', '[{"id":"a","text":"A new hospital is built."},{"id":"b","text":"A new hospital was being built."},{"id":"c","text":"A new hospital is being built."},{"id":"d","text":"A new hospital has been built."}]'::jsonb, 'c', 'The active is in the present continuous (''are building''), so the passive is ''is/are being + past participle'': ''A new hospital is being built''. Option A (present simple passive) would correspond to ''They build''. Option B (past continuous passive) would be for ''They were building''. Option D (present perfect passive) would be for ''They have built''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('579c0696-a623-55ab-b298-0230c3f37ffb', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', 'Choose the sentence where the by-agent is BEST omitted.', '[{"id":"a","text":"The Mona Lisa was painted by Leonardo da Vinci."},{"id":"b","text":"The package was delivered by the courier."},{"id":"c","text":"The new law was proposed by the president."},{"id":"d","text":"The play was written by Shakespeare."}]'::jsonb, 'b', '''By the courier'' is the most expendable by-agent: it is obvious that a delivery person delivers packages, so the agent adds no new information. In options A and D, the author (da Vinci / Shakespeare) is the crucial new information. In option C, the president as proposer is important political context.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28472161-6ef3-5ef5-9a81-c39394752fec', '8ae4fa2b-4879-5dfa-adf5-96b9c353d213', 'Which of the following sentences uses the passive voice INCORRECTLY?', '[{"id":"a","text":"The report was submitted on time."},{"id":"b","text":"The accident was happened near the school."},{"id":"c","text":"The film has been released in three countries."},{"id":"d","text":"The road is being repaired this week."}]'::jsonb, 'b', '''The accident was happened'' is incorrect because ''happen'' is an intransitive verb — it has no object, so it cannot be passivised. The correct sentence is simply ''The accident happened near the school'' (active). Options A, C, and D all correctly passivise transitive verbs (submit, release, repair).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('580be676-fcda-57e9-b1ce-c7e90a87645d', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', '⭐ Practice: Passive Forms', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21f46f9e-5fcf-5040-91a0-f1ee296d4d7a', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Choose the correct passive form: ''Someone cleans this room every day.'' → ''This room ___ every day.''', '[{"id":"a","text":"is cleaned"},{"id":"b","text":"was cleaned"},{"id":"c","text":"is being cleaned"},{"id":"d","text":"has been cleaned"}]'::jsonb, 'a', 'The active verb is in the present simple (''cleans''), so the passive uses ''is/are + past participle'': ''is cleaned''. ''Was cleaned'' (past simple passive) would correspond to ''cleaned''. ''Is being cleaned'' is present continuous passive. ''Has been cleaned'' is present perfect passive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('228a883c-2f11-5d01-bda4-1d8ed98c5101', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Transform to passive: ''The police arrested three people last night.'' → ''Three people ___ last night.''', '[{"id":"a","text":"are arrested"},{"id":"b","text":"were arrested"},{"id":"c","text":"have been arrested"},{"id":"d","text":"were being arrested"}]'::jsonb, 'b', 'The active uses the past simple (''arrested''), so the passive is ''were + past participle'': ''were arrested''. ''Are arrested'' is present simple passive. ''Have been arrested'' is present perfect passive. ''Were being arrested'' is past continuous passive.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e42b7147-c6f9-5d87-a73b-ef3c3e1e4758', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Choose the correct passive: ''They have launched a new app.'' → ''A new app ___.''', '[{"id":"a","text":"was launched"},{"id":"b","text":"is launched"},{"id":"c","text":"has been launched"},{"id":"d","text":"will be launched"}]'::jsonb, 'c', 'The active is in the present perfect (''have launched''), so the passive is ''has/have been + past participle'': ''has been launched''. ''Was launched'' is past simple passive. ''Is launched'' is present simple passive. ''Will be launched'' is future passive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dca8ee9c-972a-5a61-b96a-a5aecb554bd0', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Fill in the gap: ''The new bridge ___ by the end of next year.'' (complete — future passive)', '[{"id":"a","text":"is completed"},{"id":"b","text":"was completed"},{"id":"c","text":"has been completed"},{"id":"d","text":"will be completed"}]'::jsonb, 'd', '''Will be completed'' is the future passive (will + be + past participle). The phrase ''by the end of next year'' confirms this is future. ''Is completed'' (present simple passive) and ''was completed'' (past simple passive) refer to the present and past respectively. ''Has been completed'' (present perfect passive) refers to a completed action up to now.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cf84817-294f-55aa-87ff-f0db0ce53b98', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Which sentence is CORRECTLY formed in the passive?', '[{"id":"a","text":"The road is repair by workers."},{"id":"b","text":"The road is being repaired by workers."},{"id":"c","text":"The road is being repair by workers."},{"id":"d","text":"The road being repaired by workers."}]'::jsonb, 'b', '''Is being repaired'' is the correct present continuous passive (is + being + past participle). Option A uses the base form ''repair'' instead of the past participle ''repaired''. Option C also uses ''repair'' instead of ''repaired'' after ''being''. Option D omits the auxiliary verb ''is'' entirely.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69d86f79-c3dd-505e-ae3a-4fcd51cb0dd4', '580be676-fcda-57e9-b1ce-c7e90a87645d', 'Find the passive sentence where the by-agent is NECESSARY (removing it would lose important information).', '[{"id":"a","text":"The stadium was cleaned by the maintenance team after the match."},{"id":"b","text":"The letter was delivered by a postman."},{"id":"c","text":"Hamlet was written by Shakespeare."},{"id":"d","text":"Dinner was prepared by the kitchen staff."}]'::jsonb, 'c', '''By Shakespeare'' is essential information — it identifies the famous author of Hamlet, which is not obvious or trivial. In option A, it is obvious that maintenance staff clean stadiums — the agent can be dropped. In option B, a postman delivering mail is expected. In option D, the kitchen staff preparing dinner is self-evident in most contexts.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('279aad4c-0118-54e1-bb0d-b9e7781b9551', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', '⭐⭐ Review: Active vs Passive & By-Agent', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75df6ba2-d4bb-56f8-a60c-d9a0e8e3c992', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Why is the passive voice MORE APPROPRIATE here? ''The ancient scrolls ___ in a desert cave in 1947.''', '[{"id":"a","text":"The passive is used because we want to focus on what was found, not who found it."},{"id":"b","text":"Archaeologists discovered the ancient scrolls — the active is always clearer."},{"id":"c","text":"The passive is used because the scrolls performed the action."},{"id":"d","text":"The passive is required after ''in 1947''."}]'::jsonb, 'a', 'The passive ''were discovered'' focuses on the scrolls (the topic) rather than on the discoverers. This is a classic reason for using the passive: the receiver of the action is more important than the agent. Option B is incorrect — the active is not always clearer; when the topic is the scrolls, passive keeps the focus. Option C is wrong — the scrolls are passive recipients of the finding action, not performers. Option D is false — no tense is ''required'' by a time expression alone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd2d5030-824e-56cc-bdbe-c86c78fc9f7b', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Choose the correct PASSIVE version of: ''The committee has approved the new budget.''', '[{"id":"a","text":"The new budget was approved by the committee."},{"id":"b","text":"The new budget will be approved by the committee."},{"id":"c","text":"The new budget has been approved by the committee."},{"id":"d","text":"The new budget is approved by the committee."}]'::jsonb, 'c', 'The active ''The committee has approved'' (present perfect active) becomes ''The new budget has been approved by the committee'' in the passive (has/have been + past participle). Option A (''was approved'') is past simple passive — would correspond to ''The committee approved''. Option B (''will be approved'') is future passive. Option D (''is approved'') is present simple passive.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b19dc9d-d751-567d-b24e-0f16a4ebad98', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Read: ''Our roof ___ during the storm last night.'' Which form fits BEST, and why?', '[{"id":"a","text":"was damaged — formal written style is needed here."},{"id":"b","text":"got damaged — informal register, implies an unwanted accidental event."},{"id":"c","text":"is damaged — present simple is always neutral."},{"id":"d","text":"has been damaged — present perfect because we can see it now."}]'::jsonb, 'b', '''Got damaged'' (get-passive) is the most natural spoken choice: it implies the damage was unexpected and unwanted, and it fits the informal/conversational register of talking about your own home. Option A (''was damaged'') is correct but more formal. Option C (''is damaged'') is present simple — wrong tense for last night. Option D (''has been damaged'') could work to emphasise the current result, but ''last night'' as a specific past time reference makes past forms more natural.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0cd93fc-1d19-5e38-bccf-6cd1d1b75112', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Find the sentence where the passive voice is UNNECESSARY and the active would be more natural.', '[{"id":"a","text":"Mistakes were made during the project."},{"id":"b","text":"The parcel was lost in transit."},{"id":"c","text":"English is spoken in over 50 countries."},{"id":"d","text":"The article was written by Maria for the school magazine."}]'::jsonb, 'd', 'In ''The article was written by Maria'', we already know who did it (Maria is named as the agent). The active ''Maria wrote the article for the school magazine'' is more direct and natural. When the agent is identified and important, the active voice is usually preferred. Options A, B, and C all have good reasons for the passive: A uses passive because the responsible party is unnamed; B uses passive because the parcel''s fate (lost in transit) is the focus; C uses passive because no single doer exists for a general truth.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcb16eea-9c34-54a8-bff2-8a07f4543019', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Which sentence correctly uses passive voice to maintain topic continuity?', '[{"id":"a","text":"The drug was developed in the 1980s. Doctors tested it in clinical trials. Patients benefited from it."},{"id":"b","text":"The drug was developed in the 1980s. It was tested in clinical trials. It is now used worldwide."},{"id":"c","text":"Researchers developed the drug. Doctors tested it. Patients benefited."},{"id":"d","text":"The drug was developed. Researchers then tested it. Patients took it."}]'::jsonb, 'b', 'Option B maintains ''the drug / it'' as the consistent subject throughout all three sentences, using passives (''was developed'', ''was tested'', ''is used''). This is the key paragraph-level reason to use passive: keeping the same topic as subject for coherence. Options A and D switch subjects mid-paragraph (doctors, patients). Option C uses active throughout but shifts agents each sentence, which is less coherent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0422ea5-a6c5-5740-83f6-76b1d508da32', '279aad4c-0118-54e1-bb0d-b9e7781b9551', 'Which sentence is INCORRECT?', '[{"id":"a","text":"The winner was announced at midnight."},{"id":"b","text":"The documents will be signed tomorrow."},{"id":"c","text":"The meeting was happened in the conference room."},{"id":"d","text":"A new policy has been introduced by the government."}]'::jsonb, 'c', '''Was happened'' is grammatically impossible — ''happen'' is an intransitive verb with no object, so it cannot be passivised. The correct sentence is ''The meeting happened in the conference room'' (active). Options A, B, and D all correctly passivise transitive verbs: announce (A), sign (B), introduce (D).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ef36702c-ba43-540c-a356-87ecc043fce7', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: The Passive Voice', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e166466-803c-5e9e-bf1d-88836f574678', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Read: ''The famous painting ___ from the museum last Tuesday, and so far no suspects have been identified.'' Which passive form is correct?', '[{"id":"a","text":"has been stolen"},{"id":"b","text":"is stolen"},{"id":"c","text":"had been stolen"},{"id":"d","text":"was stolen"}]'::jsonb, 'd', '''Was stolen'' (past simple passive) is correct because ''last Tuesday'' is a specific past time reference, which requires the past simple tense. ''Has been stolen'' (present perfect passive) cannot be used with a specific past time marker like ''last Tuesday''. ''Is stolen'' (present simple) is wrong tense. ''Had been stolen'' (past perfect passive) would need an additional earlier reference point.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eee1d31-2bc3-53ef-8468-322587035261', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Which of the following correctly transforms the sentence into passive? ''Workers are currently renovating the old theatre.''', '[{"id":"a","text":"The old theatre is renovated currently."},{"id":"b","text":"The old theatre has been renovated currently."},{"id":"c","text":"The old theatre is being renovated."},{"id":"d","text":"The old theatre was renovated."}]'::jsonb, 'c', 'The active is in the present continuous (''are renovating''), so the passive is ''is being + past participle'': ''is being renovated''. Option A uses present simple passive (''is renovated'') — wrong tense. Option B (''has been renovated'') is present perfect passive. Option D (''was renovated'') is past simple passive. ''Currently'' is a signal that the continuous form is needed.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf63d2f1-0120-57f7-ad68-3b9a808536ab', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Read the passage: ''The prize ___ to the winner at a ceremony next week. The ceremony ___ by the mayor.'' Choose the pair of passive forms.', '[{"id":"a","text":"will be presented / will be opened"},{"id":"b","text":"was presented / will be opened"},{"id":"c","text":"is presented / has been opened"},{"id":"d","text":"has been presented / was opened"}]'::jsonb, 'a', 'Both actions are in the future (''next week''), so both require the future passive ''will be + past participle'': ''will be presented'' and ''will be opened''. Option B (''was presented / will be opened'') mixes past passive with future for the first gap. Option C (''is presented / has been opened'') uses present and present perfect — wrong for a future event. Option D (''has been presented / was opened'') uses present perfect and past — neither matches a future ceremony.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fb001ab-0ebc-506a-99d4-8ca28dc3b6e6', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Identify the sentence that CORRECTLY uses the get-passive in a natural context.', '[{"id":"a","text":"The annual budget is got approved every March."},{"id":"b","text":"The championship trophy was got displayed in the lobby."},{"id":"c","text":"He got stung by a bee at the picnic."},{"id":"d","text":"The bridge has got been repaired last month."}]'::jsonb, 'c', '''Got stung'' is a natural, correct use of the get-passive — it describes an accidental, unwanted event (being stung by a bee). Option A incorrectly uses ''is got approved'' — you cannot combine ''be'' and ''get'' like this. Option B similarly uses ''was got displayed'' — another impossible hybrid. Option D invents a non-existent form ''has got been'' — the correct form would be ''has been repaired'' (be-passive) or simply ''got repaired'' (get-passive).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4900138a-cede-5afb-ab03-336200f7034d', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Spot the error: ''It is widely believed that the decision was took without proper consultation.''', '[{"id":"a","text":"No error — ''was took'' is an acceptable informal passive form."},{"id":"b","text":"''was took'' should be ''was taken'' — ''take'' has an irregular past participle."},{"id":"c","text":"''is widely believed'' should be ''was widely believed'' — both verbs must be past."},{"id":"d","text":"''without proper consultation'' should be ''without by proper consultation''."}]'::jsonb, 'b', 'The error is ''was took'' — ''take'' is an irregular verb whose past participle is ''taken'', not ''took'' (''took'' is the simple past). The passive requires ''was/were + past participle'', so the correct form is ''was taken''. Option C is wrong — ''it is widely believed'' (present passive) is acceptable as a general present-time assertion even in a sentence about a past decision. Option D is nonsensical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('609a571b-0bc4-5f81-8383-75bee8ec3f28', 'ef36702c-ba43-540c-a356-87ecc043fce7', 'Read: ''In recent decades, great advances ___ in medical research, and millions of lives ___ as a result.'' Which pair is correct?', '[{"id":"a","text":"were made / were saved"},{"id":"b","text":"are made / are saved"},{"id":"c","text":"had been made / had been saved"},{"id":"d","text":"have been made / have been saved"}]'::jsonb, 'd', '''Have been made'' and ''have been saved'' (present perfect passive) are correct. ''In recent decades'' refers to a period continuing up to now — the present perfect is the natural tense for recent changes with relevance to the present. Option A (''were made / were saved'' — past simple passive) would work with a finished time expression (''last decade'') but not ''in recent decades''. Option B (''are made / are saved'' — present simple) does not match the sense of ongoing change from the past. Option C (''had been made / had been saved'' — past perfect) would require a further past reference point and is too remote.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa719454-fb2c-5cbb-a169-62311364d12f', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: The Passive Voice', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19df378d-06f5-543e-8ccd-3516be8aa95f', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Read: ''Penicillin ___ (discover) by Alexander Fleming in 1928. Since then, countless lives ___ (save) by antibiotics.'' Choose the correct pair.', '[{"id":"a","text":"was discovered / have been saved"},{"id":"b","text":"was discovered / were saved"},{"id":"c","text":"has been discovered / have been saved"},{"id":"d","text":"is discovered / are saved"}]'::jsonb, 'a', '''Was discovered'' (past simple passive) is correct for 1928 — a specific past date. ''Have been saved'' (present perfect passive) is correct for ''since then'' — a period from the past continuing to now. Option B uses past simple for both, but ''since then'' requires present perfect. Option C uses present perfect for the discovery in 1928 — wrong, since ''in 1928'' forces past simple. Option D uses present tenses — completely wrong for historical facts.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f679d74-c0bf-55a7-9038-0a1cea5d75d0', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Four journalists wrote headlines. Which uses the passive MOST appropriately for a formal news headline?', '[{"id":"a","text":"Scientists discover new planet."},{"id":"b","text":"Someone hacked the national database last night."},{"id":"c","text":"New planet discovered by science team."},{"id":"d","text":"The national database got hacked last night."}]'::jsonb, 'c', '''New planet discovered'' is the most appropriate formal passive headline — it puts the discovery (the topic) first and names the agent only if useful. Option A (active) is also acceptable in news writing but puts the scientists first, which is less common for major discoveries. Option B names ''someone'' — vague agent, so passive would be more appropriate here. Option D uses the get-passive (''got hacked'') which is too informal for a formal news outlet.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('976ef78a-e033-5be7-be8f-daaf7b61a3bf', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Which sentence contains a HIDDEN ERROR in passive construction?', '[{"id":"a","text":"The results will be published next Monday."},{"id":"b","text":"Several complaints have been made by customers."},{"id":"c","text":"The data was being analysed when the system crashed."},{"id":"d","text":"The suspect was saw entering the building on camera."}]'::jsonb, 'd', '''Was saw'' is incorrect — ''see'' has the irregular past participle ''seen'', not ''saw'' (''saw'' is the simple past). The correct form is ''was seen entering the building''. This is a common learner error: confusing the past simple form (''saw'') with the past participle (''seen'') needed for the passive. Options A, B, and C all use correct passive forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8143aa33-b2d2-5a65-bb5d-14ce3488b394', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Read: ''The charity ___ by three volunteers in a small flat. Today it ___ by a team of 200 people worldwide.'' What pair best completes this contrast?', '[{"id":"a","text":"is founded / is run"},{"id":"b","text":"was founded / is run"},{"id":"c","text":"had been founded / has been run"},{"id":"d","text":"was founded / was run"}]'::jsonb, 'b', '''Was founded'' (past simple passive) describes the historical founding event. ''Is run'' (present simple passive) describes the current ongoing situation (''today''). This combination perfectly expresses the contrast between past origin and present state. Option A uses present for both — wrong, as the founding is historical. Option C uses past perfect and present perfect — awkward and overly complex. Option D uses past tense for ''today'' — contradicts ''today''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14bc1dfa-6f9b-58df-b740-a30515d5fdb0', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Which explanation CORRECTLY describes why the passive is used in academic writing?', '[{"id":"a","text":"The passive is used because academic writers prefer longer sentences."},{"id":"b","text":"The passive creates an impersonal, objective tone by removing the agent (''I'', ''we'') from the sentence."},{"id":"c","text":"The passive is required by grammar rules whenever writing about science."},{"id":"d","text":"The passive is used to make the reader do more work to understand."}]'::jsonb, 'b', 'In academic writing, the passive ''The results were analysed'' is preferred over ''We analysed the results'' because it creates impersonal, objective-sounding prose — the focus is on the process, not on the researchers. This is the standard convention in scientific reporting. Option A is a misunderstanding — length is not the goal. Option C is false — the passive is a stylistic choice, not a grammar rule. Option D is incorrect — good academic writing aims for clarity.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('533d2b53-f1c8-5919-b8e0-cabf3adfba5c', 'aa719454-fb2c-5cbb-a169-62311364d12f', 'Read the error-correction task: ''The new shopping centre was opened last week. It was visited by thousands of people on the first day. The car park was become full within an hour.'' What needs fixing?', '[{"id":"a","text":"''was visited'' should be ''has been visited'' — it connects to the present."},{"id":"b","text":"''was opened'' should be ''has been opened'' — last week is recent."},{"id":"c","text":"''was become'' is incorrect — ''become'' is intransitive and cannot be passivised. Use ''became'' instead."},{"id":"d","text":"No errors — all three sentences use the passive correctly."}]'::jsonb, 'c', '''Was become'' is the error: ''become'' is an intransitive verb (it has no object) and cannot be passivised. The correct sentence is ''The car park became full within an hour'' (active, past simple). Options A and B incorrectly suggest switching tenses — ''last week'' requires past simple, so ''was visited'' and ''was opened'' are both correct. Option D is wrong because the third sentence does contain an error.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b8d8da06-4da3-5ebb-88cd-fb414871955c', '38ef0572-3183-5e39-9dbb-9c42c3bbdbc2', 'anglais-b2', '⭐⭐ Drill: Passive Voice', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41886f93-da6f-5a35-9eaf-7ec498b95338', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Choose the correct passive transformation: ''The government is currently reviewing the tax law.'' →', '[{"id":"a","text":"The tax law is reviewed currently."},{"id":"b","text":"The tax law was being reviewed."},{"id":"c","text":"The tax law is being reviewed."},{"id":"d","text":"The tax law has been reviewed."}]'::jsonb, 'c', 'The active verb ''is reviewing'' is present continuous, so the passive is ''is being + past participle'': ''is being reviewed''. ''Is reviewed'' is present simple passive — wrong tense. ''Was being reviewed'' is past continuous passive. ''Has been reviewed'' is present perfect passive. The word ''currently'' also signals an ongoing action, confirming the continuous form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e84d21ec-08ab-5892-bf31-943107758a76', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Which sentence correctly uses the FUTURE passive?', '[{"id":"a","text":"The results are announced next week."},{"id":"b","text":"The results are being announced next week."},{"id":"c","text":"The results have been announced next week."},{"id":"d","text":"The results will be announced next week."}]'::jsonb, 'd', '''Will be announced'' is the future passive (will + be + past participle). ''Are announced'' is present simple passive — it could suggest a routine but does not convey the future sense of ''next week'' as clearly. ''Have been announced'' is present perfect passive — incompatible with ''next week''. ''Are being announced'' is present continuous passive, which can suggest a future arrangement but is less standard for a future event than ''will be''.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6968581-2d44-50d2-b886-33f9f1177a04', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Identify the sentence where the by-agent should be KEPT (it carries essential information).', '[{"id":"a","text":"The fire was extinguished by firefighters."},{"id":"b","text":"The speed record was broken by Usain Bolt in 2009."},{"id":"c","text":"The packages were sorted by the warehouse staff overnight."},{"id":"d","text":"The report was typed by a secretary."}]'::jsonb, 'b', '''By Usain Bolt'' is essential — the identity of the record holder is the key information, and omitting it would lose a significant fact. In option A, stating ''by firefighters'' is expected and adds little. In option C, warehouse staff sorting packages is self-evident. In option D, secretaries typing documents is obvious in an office context.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ab48945-8e02-5d57-906e-01910b976420', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Read: ''The new product line ___ in Asia in 2019 and ___ to Europe two years later.'' Choose the correct pair of passive forms.', '[{"id":"a","text":"is launched / is introduced"},{"id":"b","text":"has been launched / has been introduced"},{"id":"c","text":"was launched / was introduced"},{"id":"d","text":"was launched / has been introduced"}]'::jsonb, 'c', 'Both events have specific past dates (2019 and two years later — both finished), so both require past simple passive: ''was launched / was introduced''. ''Is launched / is introduced'' are present simple — wrong for past events. ''Has been launched / has been introduced'' are present perfect — incompatible with specific finished past dates. The mixed option D incorrectly uses present perfect for the second event despite its equally specific past time.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0249db9-af0c-5c54-8455-16d0a28eb90f', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Which sentence is INCORRECT?', '[{"id":"a","text":"The bridge was designed by a team of engineers."},{"id":"b","text":"The accident was happened on the motorway."},{"id":"c","text":"Three suspects have been arrested so far."},{"id":"d","text":"The proposal will be considered at the next meeting."}]'::jsonb, 'b', '''Was happened'' is impossible — ''happen'' is an intransitive verb with no object, so it cannot be passivised. The correct sentence is ''The accident happened on the motorway'' (active, past simple). Options A, C, and D all correctly passivise transitive verbs: design, arrest, and consider.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5410571-14a5-5778-b7e2-b2f31c748e78', 'b8d8da06-4da3-5ebb-88cd-fb414871955c', 'Read: ''The vaccine ___ by a team of international researchers over five years, and millions of doses ___ since its approval.'' Which pair correctly contrasts the historical event with the ongoing result?', '[{"id":"a","text":"was developed / have been administered"},{"id":"b","text":"was developed / were administered"},{"id":"c","text":"has been developed / have been administered"},{"id":"d","text":"is developed / are administered"}]'::jsonb, 'a', 'The development is a completed historical event (past simple passive ''was developed''). The administration is an ongoing result from that point until now, signalled by ''since its approval'' (present perfect passive ''have been administered''). Option B uses past simple for both — ''were administered'' cannot follow ''since''. Option C applies present perfect to the development, but a completed historical process without a present-time focus takes past simple. Option D uses present tenses — wrong for historical events.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('47a9669b-59e3-560a-9c0d-b665ced19277', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c68cd28-5863-57c5-bd91-69a6811769c1', '47a9669b-59e3-560a-9c0d-b665ced19277', 'She said, "I am tired." What is the correct reported form?', '[{"id":"a","text":"She said she is tired."},{"id":"b","text":"She said she was tired."},{"id":"c","text":"She told she was tired."},{"id":"d","text":"She said she were tired."}]'::jsonb, 'b', 'Tense backshift: present simple ''am'' shifts to past simple ''was'' in reported speech. Option (a) forgets to backshift. Option (c) uses ''told'' without a personal object, which is wrong. Option (d) uses ''were'' with a singular subject, which is incorrect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70efc4dc-32e6-5a6d-9824-322e5102ad91', '47a9669b-59e3-560a-9c0d-b665ced19277', 'Which sentence correctly uses ''say'' and ''tell''?', '[{"id":"a","text":"She told me that she was ready."},{"id":"b","text":"She said me that she was ready."},{"id":"c","text":"She told that she was ready."},{"id":"d","text":"She said to told me she was ready."}]'::jsonb, 'a', '''Tell'' requires a personal object: ''told me'' is correct. Option (c) is wrong because ''told'' needs an object before ''that''. Option (b) is wrong because ''said'' cannot take a direct personal object — ''said me'' is not English. Option (d) is grammatically incoherent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57c5d733-7e7e-5c1e-9ef3-6215b8edd27f', '47a9669b-59e3-560a-9c0d-b665ced19277', 'He asked, "Where do you live?" What is the correct reported form?', '[{"id":"a","text":"He asked me where did I live."},{"id":"b","text":"He asked me where I live."},{"id":"c","text":"He asked me where I lived."},{"id":"d","text":"He asked me where do I lived."}]'::jsonb, 'c', 'In reported wh-questions, restore subject-verb order (no inversion) and backshift the tense: ''where I lived''. Option (a) keeps the inverted question form, which is wrong. Option (b) forgets to backshift to past. Option (d) mixes question inversion with the wrong form ''lived''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c08e0e8c-91e8-5923-8434-a7cdfcec2118', '47a9669b-59e3-560a-9c0d-b665ced19277', 'She said, "I''ll do it tomorrow." What does ''tomorrow'' become in reported speech?', '[{"id":"a","text":"today"},{"id":"b","text":"yesterday"},{"id":"c","text":"the next day"},{"id":"d","text":"that day"}]'::jsonb, 'c', 'Time expressions shift in reported speech: ''tomorrow'' becomes ''the next day'' (or ''the following day''). ''Today'' shifts to ''that day'', ''yesterday'' shifts to ''the day before'', so (a) and (b) are wrong. ''That day'' is the shift for ''today'', not ''tomorrow''.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('303b21b7-c275-54d8-bccc-9903396e05cd', '47a9669b-59e3-560a-9c0d-b665ced19277', 'Find the INCORRECT reported sentence.', '[{"id":"a","text":"He said he would call the next day."},{"id":"b","text":"She told me she had already finished."},{"id":"c","text":"They asked me if I had seen the film."},{"id":"d","text":"He said me he was hungry."}]'::jsonb, 'd', '''Said me'' is incorrect — ''say'' cannot take a direct personal object. The correct forms are ''He said he was hungry'' or ''He told me he was hungry''. Options (a), (b), and (c) are all correctly formed reported statements and questions.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', '⭐ Practice: Tense Backshift', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4674ab60-aee2-52f4-84d7-bb919b00e829', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Complete the reported statement: She said, "I work in a hospital." → She said she ___ in a hospital.', '[{"id":"a","text":"worked"},{"id":"b","text":"work"},{"id":"c","text":"works"},{"id":"d","text":"has worked"}]'::jsonb, 'a', 'Backshift rule: present simple (''work'') shifts to past simple (''worked'') in reported speech. ''Works'' keeps the present tense, which is not backshifted. ''Work'' is the base form without the past ending. ''Has worked'' is present perfect, not the correct backshift of present simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01868afd-a8e3-5fe7-bced-da0c7cae86f3', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Complete the reported statement: He said, "I can drive." → He said he ___ drive.', '[{"id":"a","text":"can"},{"id":"b","text":"could"},{"id":"c","text":"would"},{"id":"d","text":"should"}]'::jsonb, 'b', 'Modal backshift: ''can'' shifts to ''could'' in reported speech. ''Can'' keeps the original modal without backshifting. ''Would'' is the backshift of ''will'', not ''can''. ''Should'' is a different modal entirely and doesn''t result from backshifting ''can''.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e355305-1953-5862-a4c1-81ed5a20b2c8', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Complete the reported statement: They said, "We will leave tomorrow." → They said they ___ leave the next day.', '[{"id":"a","text":"will"},{"id":"b","text":"shall"},{"id":"c","text":"could"},{"id":"d","text":"would"}]'::jsonb, 'd', '''Will'' shifts to ''would'' in reported speech. ''Will'' is the unbackshifted original. ''Shall'' is a different modal that doesn''t result from backshifting ''will''. ''Could'' is the backshift of ''can'', not ''will''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9f98fe4-acbb-59b0-ad9c-3fa389b27c1f', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Complete the reported statement: She said, "I am studying for the exam." → She said she ___ for the exam.', '[{"id":"a","text":"is studying"},{"id":"b","text":"was studying"},{"id":"c","text":"has been studying"},{"id":"d","text":"studied"}]'::jsonb, 'b', 'Present continuous (''am studying'') shifts to past continuous (''was studying'') in reported speech. ''Is studying'' keeps the present continuous without backshifting. ''Has been studying'' is present perfect continuous, which is not the direct backshift here. ''Studied'' is past simple, the backshift of present simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4af21f6-8c3e-5e81-a33d-e6943a1a959a', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Find the correctly backshifted reported sentence.', '[{"id":"a","text":"He said he had to go home immediately."},{"id":"b","text":"He said he musted go home immediately."},{"id":"c","text":"He said he must go home immediately."},{"id":"d","text":"He said he has to go home immediately."}]'::jsonb, 'a', '''Must'' shifts to ''had to'' in reported speech. Option (c) keeps ''must'' without backshifting. Option (b) incorrectly adds ''-ed'' to ''must'', which is not a word. Option (d) uses ''has to'' (present), which is not the backshifted form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74177d64-0bd4-5bdd-9dd9-0994cc7c9151', '31aa4e2f-c9f5-5b7e-bf53-26d65d580eca', 'Complete the reported statement: She said, "I have never been to Paris." → She said she ___ never been to Paris.', '[{"id":"a","text":"has"},{"id":"b","text":"have"},{"id":"c","text":"had"},{"id":"d","text":"was"}]'::jsonb, 'c', 'Present perfect (''have been'') shifts to past perfect (''had been'') in reported speech. ''Has'' and ''have'' keep the present perfect without backshifting. ''Was'' is the auxiliary for past continuous or past simple passive, not for past perfect.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ae143677-2635-5aff-b34d-7d9b0e8948a4', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', '⭐⭐ Review: Reported Questions & Commands', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91d38468-c670-5586-b080-f076a69f17f9', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Report the question: "Do you like coffee?" → She asked me ___ coffee.', '[{"id":"a","text":"do I like"},{"id":"b","text":"whether did I like"},{"id":"c","text":"if I like"},{"id":"d","text":"if I liked"}]'::jsonb, 'd', 'Yes/no reported questions use ''if'' or ''whether'' and restore subject-verb order with tense backshift: ''if I liked''. Option (a) keeps the question inversion and present tense. Option (c) keeps the present tense ''like'' and so misses the required backshift to ''liked''. Option (b) wrongly keeps the auxiliary ''did'' after ''whether''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f9985d7-8b9f-516c-960b-e4ece66233c7', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Report the command: "Sit down!" → The teacher told the students ___.', '[{"id":"a","text":"to sit down"},{"id":"b","text":"sit down"},{"id":"c","text":"that sit down"},{"id":"d","text":"sitting down"}]'::jsonb, 'a', 'Reported commands use ''tell/ask + object + to-infinitive'': ''told the students to sit down''. Option (b) keeps the bare imperative form, which is only correct in direct speech. Option (c) uses ''that'' before a bare imperative, which is wrong. Option (d) uses the gerund, which doesn''t report a command.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26b6b4eb-d75a-5ecc-a2bf-19c83920cc6c', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Report the question: "What time does the film start?" → He asked me ___.', '[{"id":"a","text":"what time did the film start"},{"id":"b","text":"what time the film started"},{"id":"c","text":"what time does the film start"},{"id":"d","text":"what time started the film"}]'::jsonb, 'b', 'Reported wh-questions restore subject-verb order and backshift: ''what time the film started''. Option (a) keeps the auxiliary ''did'' after the wh-word, which is not used in reported questions. Option (c) keeps the present tense and auxiliary ''does'' — no backshift, no statement order. Option (d) inverts the subject and verb incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('257a5383-a5f6-5014-b1b6-8df792320b90', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Report the request: "Please don''t make any noise." → She asked them ___.', '[{"id":"a","text":"don''t make any noise"},{"id":"b","text":"to not make any noise"},{"id":"c","text":"not to make any noise"},{"id":"d","text":"that they don''t make noise"}]'::jsonb, 'c', 'Negative reported commands use ''ask/tell + object + not to + infinitive'': ''asked them not to make any noise''. The ''not'' comes before ''to'', not after. Option (a) keeps the direct imperative form. Option (b) incorrectly splits the infinitive by placing ''not'' between ''to'' and ''make''. Option (d) uses a ''that'' clause which loses the command structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41deca32-3341-5a4c-926f-62439ecae4b4', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Report the question: "Are you coming to the party?" → He asked her ___.', '[{"id":"a","text":"if she was coming to the party"},{"id":"b","text":"was she coming to the party"},{"id":"c","text":"if was she coming to the party"},{"id":"d","text":"whether she comes to the party"}]'::jsonb, 'a', 'Yes/no reported questions use ''if/whether'' + subject-verb order + backshift: ''if she was coming to the party''. Option (b) is missing ''if/whether'' and keeps the inverted order. Option (c) keeps the inverted word order after ''if''. Option (d) has the correct structure but forgets to backshift (''comes'' should be ''was coming'').', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a88e9ad7-4981-5ce2-9c4c-585ca204d1b1', 'ae143677-2635-5aff-b34d-7d9b0e8948a4', 'Find the INCORRECT reported sentence.', '[{"id":"a","text":"She asked me if I had finished my homework."},{"id":"b","text":"He asked me where I had been all day."},{"id":"c","text":"The coach told us not to give up."},{"id":"d","text":"She asked me did I want some tea."}]'::jsonb, 'd', 'Option (d) is wrong: after ''asked me'', the reported question must use ''if/whether'' and restore statement order — ''She asked me if I wanted some tea''. Keeping ''did'' with inverted order is a direct speech structure and cannot appear in reported speech. Options (a), (b), and (c) are all correctly formed.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd900608-00a7-5ec0-b193-9054092e3db2', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: Reported Speech', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af56a5ce-f09b-50c5-9f83-e52d5d9c5498', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Direct: "I finished the report yesterday." → She told her boss she ___ the report the day before.', '[{"id":"a","text":"finished"},{"id":"b","text":"has finished"},{"id":"c","text":"had finished"},{"id":"d","text":"was finishing"}]'::jsonb, 'c', 'Past simple (''finished'') shifts to past perfect (''had finished'') in reported speech. Note also that ''yesterday'' becomes ''the day before''. Option (a) keeps past simple without backshifting. Option (b) is present perfect — not the result of backshifting past simple. Option (d) is past continuous, which would backshift ''was finishing'', not ''finished''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b654dfcf-ad08-5c66-a089-2b6b40f80538', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Direct: "Don''t open the window." → The teacher asked the students ___.', '[{"id":"a","text":"to not open the window"},{"id":"b","text":"not to open the window"},{"id":"c","text":"don''t open the window"},{"id":"d","text":"that they don''t open the window"}]'::jsonb, 'b', 'Negative reported commands use ''not to + infinitive''. The ''not'' must come before ''to''. Option (a) splits the infinitive by placing ''not'' between ''to'' and ''open'' — this is an error in standard reported command structure. Option (c) is the bare imperative from direct speech. Option (d) uses a ''that'' clause with a present tense, losing the command form entirely.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51280439-47af-54d6-b6fd-3c2f7703d1ef', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Direct: "I have been waiting here for an hour." → He said he ___ there for an hour.', '[{"id":"a","text":"has been waiting"},{"id":"b","text":"was waiting"},{"id":"c","text":"had been waiting"},{"id":"d","text":"had waited"}]'::jsonb, 'c', 'Present perfect continuous (''have been waiting'') shifts to past perfect continuous (''had been waiting'') in reported speech. Note also ''here'' shifts to ''there''. Option (a) keeps present perfect continuous without backshifting. Option (b) is past continuous — the direct backshift of present continuous, not present perfect continuous. Option (d) drops the continuous aspect entirely.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3c7e371-d784-53f0-a75f-3d2599b31aa9', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Which sentence contains BOTH a correct time-word change AND correct backshift?', '[{"id":"a","text":"She said she would call me tomorrow."},{"id":"b","text":"She said she goes there today."},{"id":"c","text":"They said they will come here the next day."},{"id":"d","text":"He said he had seen the film the previous night."}]'::jsonb, 'd', '''Had seen'' correctly backshifts past simple, and ''the previous night'' correctly shifts ''last night''. Option (a) keeps ''tomorrow'' instead of shifting it to ''the next day''. Option (c) keeps ''will'' (not backshifted) and ''here'' (should be ''there''). Option (b) keeps ''goes'' (present) and ''today'' (should be ''that day'').', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57e192b8-5c55-575d-976e-90fd56768d6a', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Direct: "Why didn''t you call me?" → She asked him ___.', '[{"id":"a","text":"why he hadn''t called her"},{"id":"b","text":"why didn''t he call her"},{"id":"c","text":"why he didn''t call her"},{"id":"d","text":"why hadn''t he called her"}]'::jsonb, 'a', 'Reported wh-questions use statement order and backshift: ''why he hadn''t called her'' (past simple → past perfect; ''you'' → ''he''; ''me'' → ''her''). Option (b) keeps the inverted question form with ''didn''t''. Option (c) has correct order but doesn''t backshift — ''didn''t call'' should become ''hadn''t called''. Option (d) keeps the inverted form after the wh-word.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('236959ed-d38a-52dd-8edd-e6ea00045220', 'bd900608-00a7-5ec0-b193-9054092e3db2', 'Read the context: Omar has just come back from meeting Leila. He tells his friend: "Leila told me she ___ in Tunis all week because her company ___ a big conference."
Which option correctly fills both gaps?', '[{"id":"a","text":"was staying / was organising"},{"id":"b","text":"stays / organises"},{"id":"c","text":"had stayed / organised"},{"id":"d","text":"is staying / organises"}]'::jsonb, 'a', 'Leila''s original words were likely ''I am staying in Tunis all week because my company is organising a big conference.'' Both present continuous verbs backshift to past continuous in reported speech: ''was staying / was organising''. Option (b) keeps present tenses. Option (c) uses past perfect, suggesting the stay was completed before Leila spoke, which contradicts ''all week''. Option (d) keeps present tenses without backshifting.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: Reported Speech', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa13c14b-bc5c-5d6e-b3e0-8e2bdb10f1a6', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'Read: The teacher announced: "The Earth orbits the Sun." Which reported form is MOST appropriate?', '[{"id":"a","text":"The teacher said the Earth orbited the Sun."},{"id":"b","text":"The teacher said the Earth orbits the Sun."},{"id":"c","text":"The teacher said the Earth had orbited the Sun."},{"id":"d","text":"The teacher said the Earth will orbit the Sun."}]'::jsonb, 'b', 'This is a scientific fact (still true now), so no backshift is needed — ''the Earth orbits the Sun'' is the most natural and correct form. Option (a) applies backshift, which is grammatically acceptable but less natural for a permanent truth. Option (c) uses past perfect, implying the Earth no longer orbits — wrong. Option (d) uses future will, which distorts the meaning entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31e49d70-38d9-558a-af1e-f1bb85fa8d9d', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'Direct: "If you work hard, you will succeed." → My mentor told me that if I ___ hard, I ___ succeed.', '[{"id":"a","text":"worked / would"},{"id":"b","text":"work / will"},{"id":"c","text":"had worked / would have"},{"id":"d","text":"worked / will"}]'::jsonb, 'a', 'In reported speech, the first conditional backshifts: ''work'' → ''worked'' (past simple) and ''will succeed'' → ''would succeed''. Option (b) keeps both tenses in the present/future — no backshift. Option (c) uses past perfect and ''would have'', which reports a third conditional (past regret), not the original first conditional. Option (d) mixes backshifted ''worked'' with unbackshifted ''will'' — inconsistent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a741c645-b97c-51ee-a435-b399ecf3a6f7', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'Find the sentence where the choice between ''say'' and ''tell'' is WRONG.', '[{"id":"a","text":"He told us the meeting was cancelled."},{"id":"b","text":"She said nothing for a long time."},{"id":"c","text":"They told that the price had increased."},{"id":"d","text":"He said he would think about it."}]'::jsonb, 'c', '''Tell'' always requires a personal object before ''that'': ''They told us that the price had increased'' or ''They said that the price had increased''. ''Told that…'' without an object is grammatically wrong. Option (a) correctly uses ''told us''. Option (b) correctly uses ''said'' without an object. Option (d) correctly uses ''said'' followed by a clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('816edd55-4bef-56e3-a706-b6677ed43b77', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'Read: "Omar called Sana last night. He said: ''I spoke to the director here today and he told me I can start the new job this week.''" What is the correctly reported version of Omar''s words?', '[{"id":"a","text":"Omar said he had spoken to the director there today and that the director told him he could start the new job this week."},{"id":"b","text":"Omar said he spoke to the director here today and he told him he can start the new job this week."},{"id":"c","text":"Omar said he had spoken to the director there that day and that the director had told him he could start the new job that week."},{"id":"d","text":"Omar told he had spoken to the director and he can start the job that week."}]'::jsonb, 'c', 'Option (c) applies all backshifts correctly: ''spoke'' → ''had spoken'', ''told'' → ''had told'', ''can'' → ''could''; and all time/place shifts: ''here'' → ''there'', ''today'' → ''that day'', ''this week'' → ''that week''. Option (b) applies no changes at all. Option (a) shifts ''here'' → ''there'' but inconsistently keeps ''today'' and ''this week'' unshifted, and ''told'' stays in past simple. Option (d) uses ''told'' without an object and skips the full backshift.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11f6efae-76fa-56f5-8e72-44dafe463bc0', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'Direct: "Where have you put my keys?" → She asked him ___.', '[{"id":"a","text":"where did he put her keys"},{"id":"b","text":"where had he put her keys"},{"id":"c","text":"where he has put her keys"},{"id":"d","text":"where he had put her keys"}]'::jsonb, 'd', 'Present perfect (''have put'') backshifts to past perfect (''had put''); pronouns shift: ''you'' → ''he'', ''my'' → ''her''; statement order is restored. Option (b) keeps inverted order (''had he''). Option (c) keeps present perfect without backshift. Option (a) uses ''did'' — the auxiliary for past simple questions — and inverted order, both wrong in reported speech.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cc25702-b41d-5609-904b-35e43606011b', '6423a2b1-a4ec-59c1-bc14-8f2c31b07039', 'A journalist writes: "The minister ___ that the new law ___ jobs and ___ the economy." (direct: "This law will create jobs and boost the economy.")
Which option fills all three gaps correctly?', '[{"id":"a","text":"said / will create / will boost"},{"id":"b","text":"said / would create / would boost"},{"id":"c","text":"told / would create / would boost"},{"id":"d","text":"told that / would create / would boost"}]'::jsonb, 'b', '''Said'' takes no personal object and is correct here (no ''us/them'' follows). ''Will'' backshifts to ''would'' for both verbs. Option (a) keeps ''will'' — no backshift. Option (c) uses ''told'' without a personal object, which is wrong. Option (d) uses ''told that'' — ''told'' needs an object (''told us that''), not a direct ''that'' clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'eb250c85-5c0b-59c4-9333-c98d07d14452', 'anglais-b2', '⭐⭐ Drill: Reported Speech', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94b938d8-b070-5159-b85f-0d25aacfa046', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Report the statement: She said, "I am reading a fascinating book." → She said she ___.', '[{"id":"a","text":"is reading a fascinating book"},{"id":"b","text":"was reading a fascinating book"},{"id":"c","text":"had reading a fascinating book"},{"id":"d","text":"reads a fascinating book"}]'::jsonb, 'b', 'Present continuous ''am reading'' backshifts to past continuous ''was reading'' in reported speech. ''Is reading'' keeps the original present tense without backshifting — a common error. ''Had reading'' is not a grammatical form. ''Reads'' is the backshift of present simple, not present continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96e390d1-778f-5504-a445-ef6d5e40ea84', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Which sentence correctly uses ''say'' and ''tell''?', '[{"id":"a","text":"He told that the meeting was postponed."},{"id":"b","text":"She said me the news immediately."},{"id":"c","text":"They told us the flight had been cancelled."},{"id":"d","text":"He said to me told her the truth."}]'::jsonb, 'c', '''Tell'' requires a personal object: ''told us'' is correct. Option A uses ''told that'' without a personal object — ''told'' must be followed by a person before ''that''. Option B uses ''said me'' — ''say'' cannot take a direct personal object; the correct form would be ''She told me the news'' or ''She said the news to me''. Option D is grammatically incoherent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83469044-f7ef-5bf6-9bc1-adbf9dd079ab', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Report the question: "Have you ever been to Morocco?" → He asked me ___.', '[{"id":"a","text":"had I ever been to Morocco"},{"id":"b","text":"if I had ever been to Morocco"},{"id":"c","text":"if I have ever been to Morocco"},{"id":"d","text":"whether had I ever been to Morocco"}]'::jsonb, 'b', 'Yes/no questions in reported speech use ''if'' or ''whether'', restore statement word order, and backshift: present perfect ''have been'' shifts to past perfect ''had been''. Option A omits ''if/whether'' and keeps inverted order. Option C keeps the present perfect without backshifting. Option D uses ''whether'' but then keeps inverted order — the verb ''had'' must come after ''I'', not before.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9dc44034-06ca-511b-a18c-2d4940c4c283', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Report the command: "Please don''t use your phones during the exam." → The invigilator told the students ___.', '[{"id":"a","text":"to not use their phones during the exam"},{"id":"b","text":"don''t use their phones during the exam"},{"id":"c","text":"not to use their phones during the exam"},{"id":"d","text":"that they didn''t use their phones during the exam"}]'::jsonb, 'c', 'Negative reported commands use ''not to + infinitive'', with ''not'' placed before ''to'': ''not to use''. Option A splits the infinitive by inserting ''not'' between ''to'' and ''use'' — this is incorrect for reported commands. Option B keeps the bare imperative from direct speech. Option D changes the command into a past statement, losing the imperative force.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53ab1af4-9867-5834-bd4a-586abc80154b', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Which reported sentence contains BOTH a correct backshift AND a correct time-word change?', '[{"id":"a","text":"She said she would finish the project the next day."},{"id":"b","text":"She said she will finish the project the next day."},{"id":"c","text":"She said she would finish the project tomorrow."},{"id":"d","text":"She said she finishes the project the next day."}]'::jsonb, 'a', '''Will'' backshifts to ''would'', and ''tomorrow'' shifts to ''the next day'' — both changes are correctly applied in option A. Option B keeps ''will'' unbackshifted. Option C correctly backshifts ''will'' to ''would'' but fails to shift ''tomorrow'' to ''the next day''. Option D uses the present simple ''finishes'' — neither the modal nor the time word is correctly transformed.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4196f97-2382-59e6-a67a-db4123dc878c', '3e7018e2-a2b0-5412-8bae-18da5b189a0f', 'Direct: "I was waiting for the bus when I saw the accident." → He told me he ___ for the bus when he ___ the accident.', '[{"id":"a","text":"was waiting / saw"},{"id":"b","text":"had been waiting / had seen"},{"id":"c","text":"was waiting / had seen"},{"id":"d","text":"had been waiting / saw"}]'::jsonb, 'b', 'In backshift, both verbs move one tense back: past continuous ''was waiting'' → past perfect continuous ''had been waiting'', and past simple ''saw'' → past perfect ''had seen''. So: he had been waiting for the bus when he had seen the accident. The other options each leave a verb un-backshifted: ''was waiting / saw'' shifts neither; ''was waiting / had seen'' keeps the first in the present-tense-area; ''had been waiting / saw'' leaves ''saw'' un-backshifted.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('760121e7-3470-5fc5-a64a-2c39e7c38729', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70dea884-eb1d-5e12-95e5-431bee412d1b', '760121e7-3470-5fc5-a64a-2c39e7c38729', 'Complete the third conditional: "If she ___ harder, she would have passed."', '[{"id":"a","text":"studied"},{"id":"b","text":"would have studied"},{"id":"c","text":"has studied"},{"id":"d","text":"had studied"}]'::jsonb, 'd', 'The third conditional uses ''if + past perfect'' in the if-clause: ''had studied''. Option (a) uses past simple, which is correct for the second conditional (unreal present), not the third. Option (c) uses present perfect, which has no place in a conditional if-clause. Option (b) uses ''would have'', which belongs in the result clause, never in the if-clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93db20f8-1d02-5bb5-9b85-918e9ff25b4d', '760121e7-3470-5fc5-a64a-2c39e7c38729', 'Complete the wish: "I wish I ___ the answer." (The speaker doesn''t know the answer right now.)', '[{"id":"a","text":"know"},{"id":"b","text":"have known"},{"id":"c","text":"knew"},{"id":"d","text":"had known"}]'::jsonb, 'c', 'For a present wish about something untrue now, use ''wish + past simple'': ''I wish I knew''. Option (a) keeps the present tense — ''I wish I know'' is grammatically wrong. Option (b) uses present perfect, which is not standard after ''wish'' for a present state. Option (d) uses past perfect, which would express a past regret (''I wish I had known''), not a present wish.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86b33a6e-9afb-5223-8302-c89479029fb9', '760121e7-3470-5fc5-a64a-2c39e7c38729', '"Unless you hurry, you''ll be late." This means the same as:', '[{"id":"a","text":"If you hurry, you''ll be late."},{"id":"b","text":"If you hurry, you won''t be late."},{"id":"c","text":"Unless you don''t hurry, you''ll be late."},{"id":"d","text":"If you don''t hurry, you''ll be late."}]'::jsonb, 'd', '''Unless'' means ''if … not'', so ''Unless you hurry'' = ''If you don''t hurry, you''ll be late''. Option (a) reverses the condition — ''if you hurry'' would mean being on time. Option (c) doubles the negative (''unless … don''t''), which is incorrect. Option (b) changes both the condition and the result.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f55b843-dc66-5813-84b3-56afa33718a2', '760121e7-3470-5fc5-a64a-2c39e7c38729', 'Which sentence is a MIXED conditional (past condition, present result)?', '[{"id":"a","text":"If she had studied harder, she would have passed."},{"id":"b","text":"If I had taken that job, I would be rich now."},{"id":"c","text":"If I weren''t so tired, I would have gone yesterday."},{"id":"d","text":"If it rains, I will stay in."}]'::jsonb, 'b', 'Option (b) is Mixed A: past condition (if + past perfect ''had taken'') → present result (would + base ''would be… now''). Option (a) is a pure third conditional (past → past). Option (c) is Mixed B: present condition (if + past simple ''weren''t'') → past result (would + have + pp ''would have gone''). Option (d) is a first conditional (real future).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b84d883-c8d8-5f28-8d20-97260981c81e', '760121e7-3470-5fc5-a64a-2c39e7c38729', 'Find the INCORRECT ''I wish'' sentence.', '[{"id":"a","text":"I wish I had arrived earlier."},{"id":"b","text":"I wish he would stop making that noise."},{"id":"c","text":"I wish I went to the concert last night."},{"id":"d","text":"I wish I were taller."}]'::jsonb, 'c', 'Option (c) is wrong: past simple after ''wish'' expresses a present wish about something untrue now, not a past regret. To express regret about last night, you need past perfect: ''I wish I had gone to the concert last night''. Option (a) correctly uses past perfect for a past regret. Option (b) correctly uses ''would'' for an annoyance directed at someone else. Option (d) correctly uses past simple (''were'') for a present wish.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('053b4c2b-c691-5fc7-83b5-933a2395c16d', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', '⭐ Practice: The Third Conditional', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77954a38-d8db-54e9-ad66-182962063d7a', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Complete the third conditional: "If I ___ earlier, I would have caught the train."', '[{"id":"a","text":"left"},{"id":"b","text":"had left"},{"id":"c","text":"have left"},{"id":"d","text":"would leave"}]'::jsonb, 'b', 'The third conditional requires ''if + past perfect'' in the if-clause: ''had left''. Option (a) uses past simple, which belongs in the second conditional (imaginary present). Option (c) uses present perfect, which cannot be used in a third conditional if-clause. Option (d) uses ''would'', which belongs only in the result clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('090158c5-b48f-52e5-949d-ae0d176e9ed7', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Complete the third conditional result: "If she had asked for help, we ___  her."', '[{"id":"a","text":"helped"},{"id":"b","text":"would help"},{"id":"c","text":"would have helped"},{"id":"d","text":"had helped"}]'::jsonb, 'c', 'In the third conditional, the result clause is ''would/could/might + have + past participle'': ''would have helped''. Option (a) uses past simple without the modal. Option (b) uses ''would + base'', which is the second conditional result. Option (d) uses past perfect, which belongs in the if-clause, not the result.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d251c40e-dd9a-5fbd-9496-3a0c6542462b', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Which sentence is a correct third conditional?', '[{"id":"a","text":"If he worked harder, he would pass."},{"id":"b","text":"If he had worked harder, he would have passed."},{"id":"c","text":"If he works harder, he will pass."},{"id":"d","text":"If he would work harder, he would pass."}]'::jsonb, 'b', '''If he had worked harder, he would have passed'' is the third conditional: past perfect + would have + past participle. Option (a) is the second conditional (imaginary present). Option (c) is the first conditional (real future). Option (d) is wrong because ''would'' must never go inside the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8268d822-ecb3-544e-8edc-c771f6bd3d7e', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Complete with the correct result: "If they hadn''t missed the meeting, the deal ___."', '[{"id":"a","text":"might have been closed"},{"id":"b","text":"was closed"},{"id":"c","text":"might close"},{"id":"d","text":"would close"}]'::jsonb, 'a', 'The third conditional result can use ''could/might/would + have + past participle'': ''might have been closed'' correctly uses a passive past participle. Option (c) drops ''have'' — ''might close'' is present/future. Option (b) is a simple past passive with no modal. Option (d) uses ''would + base'', which is the second conditional.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa810e30-cdc5-59c7-bc63-1c5325c89df1', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Choose the sentence that expresses a PAST regret using the third conditional.', '[{"id":"a","text":"If I had had more money, I would have bought a car."},{"id":"b","text":"If I have more money, I will buy a car."},{"id":"c","text":"If I had more money, I would buy a car."},{"id":"d","text":"If I would have money, I would buy a car."}]'::jsonb, 'a', 'A past regret uses the third conditional: ''If I had had more money, I would have bought a car.'' Option (c) is the second conditional (present/future hypothetical). Option (b) is the first conditional (real future). Option (d) is wrong because ''would'' cannot go in the if-clause.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d811d8c3-ff1e-5c2f-8862-de5c9c74bb7b', '053b4c2b-c691-5fc7-83b5-933a2395c16d', 'Complete: "If the weather ___ better, we could have had the picnic outside."', '[{"id":"a","text":"was"},{"id":"b","text":"were"},{"id":"c","text":"had been"},{"id":"d","text":"would have been"}]'::jsonb, 'c', 'The third conditional if-clause uses past perfect: ''had been''. The result ''could have had'' confirms this is a past hypothetical. Option (a) uses past simple — correct for the second conditional (present unreal), not the third. Option (b) is the formal past simple subjunctive — also second conditional. Option (d) uses ''would have been'', which belongs in the result clause, never the if-clause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5527b612-be00-554f-9940-597f2c988fef', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', '⭐⭐ Review: I Wish, If Only & Unless', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7282186-1bc6-5ae3-a8e0-a9c6f6e0d48a', '5527b612-be00-554f-9940-597f2c988fef', 'Choose the correct wish: The speaker can''t speak French now.', '[{"id":"a","text":"I wish I had spoken French."},{"id":"b","text":"I wish I spoke French."},{"id":"c","text":"I wish I would speak French."},{"id":"d","text":"I wish I speak French."}]'::jsonb, 'b', 'For a present wish about something untrue now, use ''wish + past simple'': ''I wish I spoke French''. Option (a) uses past perfect — this would express a past regret (''I didn''t speak French then''). Option (c) uses ''would'' with the same subject as ''wish'' for a state verb, which is wrong. Option (d) keeps the present tense — ''I wish I speak'' is not grammatical.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9350d6b8-b8ad-527f-80d8-d0313a4c6ec0', '5527b612-be00-554f-9940-597f2c988fef', 'Complete the past regret: "If only I ___ to her advice — everything would be different now."', '[{"id":"a","text":"listened"},{"id":"b","text":"had listened"},{"id":"c","text":"would listen"},{"id":"d","text":"was listening"}]'::jsonb, 'b', '''If only'' + past perfect expresses a past regret: ''If only I had listened''. Option (a) uses past simple — this would be a present wish (something untrue now), but the phrase ''everything would be different now'' confirms we are talking about a past action with present consequence. Option (c) uses ''would listen'' — wrong with ''if only'' for the same subject. Option (d) uses past continuous — not the standard form for expressing regret.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a19830a-c885-50ed-bdf3-3205a945b3b8', '5527b612-be00-554f-9940-597f2c988fef', 'Which sentence correctly uses ''wish'' to express annoyance at someone else''s behaviour?', '[{"id":"a","text":"I wish he stopped talking."},{"id":"b","text":"I wish he had stopped talking."},{"id":"c","text":"I wish he stops talking."},{"id":"d","text":"I wish he would stop talking."}]'::jsonb, 'd', 'To express annoyance at someone''s repeated behaviour, use ''wish + would + base verb'': ''I wish he would stop talking''. Option (a) uses past simple — this expresses a present wish (I want him to be a non-talker), but for annoyance about an ongoing habit, ''would'' is the natural choice. Option (c) keeps the present tense — grammatically wrong. Option (b) uses past perfect — this expresses regret that he didn''t stop in the past.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe8dbfab-f756-59ed-8fc1-da02f2b95e1c', '5527b612-be00-554f-9940-597f2c988fef', 'Complete with ''unless'' or the correct alternative: "___ you have a ticket, you won''t get in."', '[{"id":"a","text":"Unless you don''t have"},{"id":"b","text":"If you have"},{"id":"c","text":"Unless you have"},{"id":"d","text":"Provided that you don''t have"}]'::jsonb, 'c', '''Unless you have a ticket'' = ''If you don''t have a ticket'' — the negative is already inside ''unless''. Option (a) is wrong: ''unless … don''t'' doubles the negative and reverses the meaning. Option (b) reverses the logic — ''if you have a ticket, you won''t get in'' means the opposite. Option (d) ''provided that you don''t have'' is grammatically possible but means the same as option (c), making it redundant; and the phrasing is less natural here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c61d2ca-f74d-5a41-a7e0-686ad9208771', '5527b612-be00-554f-9940-597f2c988fef', 'Which sentence correctly uses ''provided that''?', '[{"id":"a","text":"I will lend you the money provided that you will pay me back."},{"id":"b","text":"I would lend you the money provided that you paid me back."},{"id":"c","text":"I will lend you the money provided that you pay me back."},{"id":"d","text":"I lend you the money provided that you paid me back."}]'::jsonb, 'c', '''Provided that'' introduces a condition with the present simple in the condition clause: ''provided that you pay me back''. Option (a) wrongly puts ''will'' inside the condition clause — just like ''if'', ''provided that'' takes present simple for future conditions. Option (b) is a second conditional — grammatically possible, but the question asks about the standard ''provided that'' construction. Option (d) drops ''will'' from the result clause, making it a statement rather than a conditional promise.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0319e8e2-ed4d-503f-97af-85b9a1ad3382', '5527b612-be00-554f-9940-597f2c988fef', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I wish I hadn''t said that — I feel terrible."},{"id":"b","text":"If only it would stop raining!"},{"id":"c","text":"Unless she calls first, I won''t answer."},{"id":"d","text":"I wish I would have more free time."}]'::jsonb, 'd', '''I wish I would have more free time'' is wrong: ''would'' is not used after ''wish'' when the subject of ''wish'' and the subject of ''would'' are the same (except for annoying habits directed at another person). The correct form is ''I wish I had more free time'' (past simple for a present wish). Option (a) correctly uses past perfect for a past regret. Option (b) correctly uses ''would'' with ''if only'' for a present annoyance (the rain). Option (c) correctly uses ''unless''.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d9bb9928-aac2-5cb1-ba82-22f35700b3a3', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: Advanced Conditionals', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4659e16-8104-5126-b6a7-539b94f346c4', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Complete the mixed conditional: "If I had taken that scholarship, I ___ in Paris right now."', '[{"id":"a","text":"would be"},{"id":"b","text":"would have been"},{"id":"c","text":"had been"},{"id":"d","text":"was"}]'::jsonb, 'a', 'This is Mixed Conditional A: past condition (if + past perfect) → present result (would + base verb). ''Would be'' correctly expresses the present consequence of a past unchosen action. Option (b) ''would have been'' is the pure third conditional result — it implies a past consequence, but ''right now'' signals a present one. Option (c) is past perfect — wrong in the result clause. Option (d) is past simple — no modal, no conditional meaning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('895af5ae-bccc-5e1d-baf0-bfc43295a3f9', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Identify the Mixed Conditional B sentence (present condition → past result).', '[{"id":"a","text":"If she had known, she would have told us."},{"id":"b","text":"If he weren''t so stubborn, he would have agreed yesterday."},{"id":"c","text":"If you study hard, you''ll pass."},{"id":"d","text":"If she had a car, she would drive to work."}]'::jsonb, 'b', 'Mixed B has a present condition (if + past simple: ''weren''t so stubborn'' — he IS stubborn now) and a past result (would + have + pp: ''would have agreed yesterday''). Option (a) is a pure third conditional (past → past). Option (c) is a first conditional (real future). Option (d) is a second conditional (present hypothetical).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cea4ef09-d325-52d5-952a-4cfd1bd1c80a', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Complete: "I wish I ___ to the dentist last month — the pain is terrible now."', '[{"id":"a","text":"went"},{"id":"b","text":"would go"},{"id":"c","text":"had gone"},{"id":"d","text":"have gone"}]'::jsonb, 'c', 'The reference to ''last month'' marks this as a past regret: ''wish + past perfect'' is required — ''I wish I had gone''. Option (a) uses past simple — this pattern (''I wish I went'') expresses a present wish, not a past regret. Option (b) uses ''would go'' — ''would'' with the same subject as ''wish'' for a state/action is wrong. Option (d) uses present perfect — not a valid ''wish'' pattern.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bd5b80e-348b-5d29-b87b-c392eddeff2b', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Read: "Sara is brilliant but very disorganised. She didn''t submit her project on time and failed the module." Which sentence BEST describes the situation?', '[{"id":"a","text":"If she were more organised, she would pass the module."},{"id":"b","text":"If she had been more organised, she would pass the module now."},{"id":"c","text":"If she had been more organised, she would have passed the module."},{"id":"d","text":"Unless she is organised, she will fail."}]'::jsonb, 'c', 'The text describes a past event (she failed) caused by a past condition (she wasn''t organised then). A pure third conditional captures this: ''If she had been more organised, she would have passed.'' Option (a) is a second conditional — implies she''s not organised now and would pass in the future, missing the past event. Option (b) is a mixed conditional A — implies she''s not organised now with a present result, but the text says she already failed. Option (d) is a first conditional about the future, which doesn''t reflect the past situation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a335c57-439a-5060-9931-8474bdb35f0f', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Find the INCORRECT sentence.', '[{"id":"a","text":"If only I had checked my email sooner!"},{"id":"b","text":"Unless he studies, he won''t pass."},{"id":"c","text":"I wish he would arrive on time for once."},{"id":"d","text":"If I would have studied more, I would have passed."}]'::jsonb, 'd', '''Would'' must never go inside the if-clause of any conditional: ''If I would have studied'' is wrong. The correct form is ''If I had studied more, I would have passed'' (third conditional). Option (a) correctly uses past perfect with ''if only'' for a past regret. Option (b) correctly uses ''unless''. Option (c) correctly uses ''would'' with ''wish'' to express annoyance at someone else''s behaviour.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('473eb531-637f-555e-91b1-fd2efee5fe50', 'd9bb9928-aac2-5cb1-ba82-22f35700b3a3', 'Complete both gaps: "___ you promise to be careful, you can borrow my camera; ___ you damage it, you''ll have to replace it."', '[{"id":"a","text":"Provided that / unless"},{"id":"b","text":"Unless / provided that"},{"id":"c","text":"If only / unless"},{"id":"d","text":"Provided that / if only"}]'::jsonb, 'a', '''Provided that you promise'' sets a strict positive condition for borrowing. ''Unless you damage it'' = ''If you don''t damage it, you won''t need to replace it'' — a negative condition. Option (b) reverses them: ''Unless you promise'' would mean ''if you don''t promise'', making the sentence block borrowing unless refused, which contradicts the offer. Option (c) uses ''if only'' — this expresses a wish, not a condition. Option (d) uses ''if only'' in the second clause — wrong register and meaning.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('da08d717-b872-539d-810e-512716687ca0', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: Advanced Conditionals', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85a28e0b-1ccd-539a-b287-93c6357ce2d8', 'da08d717-b872-539d-810e-512716687ca0', 'Read: "Malik trained for years, but he injured his knee the day before the final. He says: ''If I ___ my knee, I ___ the gold medal that day.''" Which option correctly fills both gaps?', '[{"id":"a","text":"didn''t injure / would win"},{"id":"b","text":"hadn''t injured / would have won"},{"id":"c","text":"hadn''t injured / would win"},{"id":"d","text":"didn''t injure / would have won"}]'::jsonb, 'b', 'Malik is expressing a past regret about a specific past event (the day before the final). The third conditional is required: ''if + past perfect → would have + past participle''. Option (a) uses past simple and ''would win'' — a second conditional about the present. Option (c) mixes past perfect (correct) with ''would win'' (a present/future result — Mixed A, not appropriate here since ''that day'' anchors the result in the past too). Option (d) uses past simple in the if-clause (second conditional) but past result — an inconsistent mix.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55af0f40-9499-53d9-941b-e2288aa43673', 'da08d717-b872-539d-810e-512716687ca0', 'Complete the wish: "If only the bus ___ on time — I''ve been waiting for 40 minutes!"', '[{"id":"a","text":"came"},{"id":"b","text":"had come"},{"id":"c","text":"would come"},{"id":"d","text":"comes"}]'::jsonb, 'c', 'The speaker is expressing frustration about the bus''s ongoing failure to arrive — a wish for a change in an external situation''s behaviour. ''If only + would + base'' is used for present annoyance or wish for a change: ''If only the bus would come''. Option (a) uses past simple — this expresses a present wish (I want a bus-that-comes), which is plausible, but ''would come'' better captures the annoyance. Option (b) uses past perfect — this would express a regret that the bus didn''t come (already past), but the speaker is still waiting, so the situation is ongoing. Option (d) keeps the present tense — grammatically wrong after ''if only''.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e559d125-04bb-5873-9f15-1a8ac896908d', 'da08d717-b872-539d-810e-512716687ca0', 'Which sentence demonstrates the most natural use of a mixed conditional (past condition → present consequence)?', '[{"id":"a","text":"If I had learnt to code at school, I would be earning more money now."},{"id":"b","text":"If I had learnt to code at school, I would have got a better job."},{"id":"c","text":"If I learn to code, I will get a better job."},{"id":"d","text":"If I learned to code, I would get a better job."}]'::jsonb, 'a', 'Mixed Conditional A links a past unrealised condition (if + past perfect: ''had learnt… at school'') to a present result (would + base: ''would be… now''). ''Now'' is the key signal. Option (b) is a pure third conditional — past condition, past result (''would have got''). Option (c) is a first conditional (real future). Option (d) is a second conditional (present hypothetical).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5499af-df25-58a3-b5f3-fa04f7bc4cf4', 'da08d717-b872-539d-810e-512716687ca0', 'Read: "Nour is a night owl — she never goes to bed before midnight. Yesterday she overslept and missed her 8am lecture." Which sentence BEST captures her Mixed B situation?', '[{"id":"a","text":"If she hadn''t overslept, she would have attended the lecture."},{"id":"b","text":"If she had gone to bed earlier, she would have attended the lecture."},{"id":"c","text":"If she goes to bed earlier, she will make it to her lectures."},{"id":"d","text":"If she went to bed earlier, she would have made it to the lecture yesterday."}]'::jsonb, 'd', 'Mixed B captures a present habit/state (she doesn''t go to bed early — present condition: ''if + past simple'') that caused a past result (she missed the lecture: ''would + have + pp''). Option (a) is a pure third conditional focusing on the oversleeping event, not her general night-owl nature. Option (c) is a first conditional — a real future suggestion, not a mixed conditional about what happened. Option (b) is a pure third conditional: both condition (''had gone'') and result (''would have attended'') are past — this doesn''t highlight her ongoing habit as the cause.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab81e1c8-26cb-5f16-ba70-1e6d5fdea4ac', 'da08d717-b872-539d-810e-512716687ca0', 'Choose the sentence where ''unless'' is used INCORRECTLY.', '[{"id":"a","text":"Unless you apologise, she won''t forgive you."},{"id":"b","text":"I''ll come to the party unless I feel too tired."},{"id":"c","text":"Unless you don''t submit by Friday, the application will be rejected."},{"id":"d","text":"He won''t sign the contract unless the terms are changed."}]'::jsonb, 'c', '''Unless you don''t submit'' is wrong: ''unless'' already contains the negative, so adding ''don''t'' creates a double negative and reverses the meaning — it now means ''if you do submit, it will be rejected'', which is illogical. The correct form is ''Unless you submit by Friday…''. Options (a), (b), and (d) all use ''unless'' correctly with a positive verb inside the clause.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48ecfa79-3b65-5814-a0d5-2459e52802af', 'da08d717-b872-539d-810e-512716687ca0', 'Three friends discuss a past project failure. Friend A: "We didn''t plan enough." Friend B: "And we didn''t ask for help." Friend C: "And now none of us have jobs."
Which sentence CORRECTLY uses a mixed conditional to link B''s statement to C''s?', '[{"id":"a","text":"If we had asked for help, we would have jobs now."},{"id":"b","text":"If we asked for help, we would have jobs now."},{"id":"c","text":"If we had asked for help, we would have had jobs."},{"id":"d","text":"If we ask for help, we will have jobs."}]'::jsonb, 'a', 'Mixed Conditional A: past condition (we didn''t ask for help → ''if + past perfect: had asked'') → present result (we don''t have jobs now → ''would + base: would have''). The word ''now'' confirms the present consequence. Option (b) uses past simple in the if-clause — second conditional (present hypothetical), not linking to a past event. Option (c) is a pure third conditional — ''would have had'' is a past result, but Friend C says they don''t have jobs now, so the present ''would have'' is more accurate. Option (d) is first conditional — real future, inappropriate for a past failure.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d1631f4c-13fb-52ac-ad9b-fd748d38cbb9', '2a050abc-34ca-5d61-bdc3-79bded379059', 'anglais-b2', '⭐⭐ Drill: Advanced Conditionals', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('094778b8-4591-5b96-bc6a-3767f97533f7', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Complete the third conditional: ''If they ___ the warning signs earlier, the accident could have been prevented.''', '[{"id":"a","text":"noticed"},{"id":"b","text":"would notice"},{"id":"c","text":"had noticed"},{"id":"d","text":"have noticed"}]'::jsonb, 'c', 'The third conditional requires ''if + past perfect'' in the if-clause: ''had noticed''. The result clause ''could have been prevented'' confirms this is a past hypothetical. ''Noticed'' is past simple — correct for the second conditional (unreal present), not the third. ''Would notice'' belongs in result clauses, never in the if-clause. ''Have noticed'' is present perfect, which cannot be used in a conditional if-clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94686c5b-fba9-5d41-a888-21df675aa5e6', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Complete the wish: ''I wish I ___ the opportunity to study abroad when I was younger.'' (The speaker did not study abroad.)', '[{"id":"a","text":"have"},{"id":"b","text":"had"},{"id":"c","text":"would have"},{"id":"d","text":"had had"}]'::jsonb, 'd', 'This is a past regret — the speaker missed the opportunity. ''Wish + past perfect'' expresses regret about the past: ''I wish I had had the opportunity''. Note the double ''had'': the first is the ''wish'' auxiliary; the second is part of the past perfect of ''have''. Option B uses a single ''had'' — this pattern (''I wish I had…'') expresses a present wish, not a past regret. Option A keeps the present tense. Option C uses ''would have'' — not a valid ''wish'' pattern.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42dd4efb-95e3-58db-abc6-3b5c9e3e3aa3', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Which sentence correctly uses ''if only'' to express a present annoyance?', '[{"id":"a","text":"If only he had stopped interrupting me!"},{"id":"b","text":"If only he would stop interrupting me!"},{"id":"c","text":"If only he stops interrupting me!"},{"id":"d","text":"If only he has stopped interrupting me!"}]'::jsonb, 'b', '''If only + would + base verb'' is used for present annoyance directed at someone else''s ongoing behaviour: ''If only he would stop interrupting me!'' Option A uses past perfect — this expresses a past regret that he didn''t stop at some earlier point. Option C uses the present simple, which is not grammatical after ''if only''. Option D uses present perfect, which is also incorrect after ''if only'' for an ongoing frustration.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9d62739-3f6c-5cfa-b110-115a1f26128d', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Identify the MIXED conditional sentence (past condition → present result).', '[{"id":"a","text":"If she hadn''t missed the deadline, she would have kept her job."},{"id":"b","text":"If he studied more, he would pass his exams."},{"id":"c","text":"If he had chosen a different career path, he would be a lot happier now."},{"id":"d","text":"Unless she apologises, I won''t speak to her again."}]'::jsonb, 'c', 'Option C is Mixed Conditional A: the if-clause has a past condition (''had chosen'' — past perfect, referring to a past decision) and the result clause has a present consequence (''would be a lot happier now'' — ''now'' signals a present state). Option A is a pure third conditional (past condition → past result: ''would have kept''). Option B is a second conditional (present hypothetical). Option D uses ''unless'' — a first conditional about the future.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('224a4aaa-dde6-58de-9140-5ac1e47c0690', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I wish he would be quieter in the mornings."},{"id":"b","text":"If only I had listened to your advice!"},{"id":"c","text":"Provided that you leave now, you''ll catch the last bus."},{"id":"d","text":"If I would have more time, I would travel the world."}]'::jsonb, 'd', '''Would'' must never appear in the if-clause of any conditional. The correct second conditional form is ''If I had more time, I would travel the world''. Option A correctly uses ''would'' with ''wish'' to express annoyance at someone else''s behaviour. Option B correctly uses past perfect with ''if only'' for a past regret. Option C correctly uses ''provided that'' with the present simple in the condition clause.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27633569-ab01-596a-a472-1142dbb9b29a', 'd1631f4c-13fb-52ac-ad9b-fd748d38cbb9', 'Read: ''Sofia is naturally disorganised. Last year she missed a crucial client meeting because she forgot to check her calendar.'' Which sentence BEST uses a mixed conditional to describe her situation?', '[{"id":"a","text":"If she had been more organised, she would have attended the meeting."},{"id":"b","text":"If she were more organised, she would attend more meetings."},{"id":"c","text":"If she were more organised, she would have attended that meeting."},{"id":"d","text":"If she had been more organised, she would be more successful now."}]'::jsonb, 'c', 'Mixed Conditional B links a present condition to a past result: her current trait (disorganised — ''if + past simple: were more organised'') caused the past missed meeting (''would + have + pp: would have attended''). Option A is a pure third conditional — it focuses on a past condition causing a past result, without highlighting her enduring character trait. Option B is a second conditional about a present/future hypothetical. Option D is Mixed A (past condition → present result), but the text gives no present consequence to describe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bcf2e211-12da-59b0-a1d4-81d4a880af84', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95f05ac2-ab58-5e32-8bdb-38c658a3e036', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'Complete: "I enjoy ___ music late at night."', '[{"id":"a","text":"listen"},{"id":"b","text":"to listen"},{"id":"c","text":"listening"},{"id":"d","text":"listened"}]'::jsonb, 'c', '"enjoy" is a gerund-only verb — it must be followed by verb + -ing: I enjoy listening. "to listen" (infinitive) cannot follow enjoy, "listen" is the bare base form, and "listened" is the past tense.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14dae91b-2d6b-5339-811b-72e65204b5f6', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'Complete: "She decided ___ a new laptop."', '[{"id":"a","text":"buying"},{"id":"b","text":"to buy"},{"id":"c","text":"buy"},{"id":"d","text":"bought"}]'::jsonb, 'b', '"decide" is an infinitive-only verb: She decided to buy. "buying" (gerund) cannot follow decide, "buy" is the bare infinitive without "to", and "bought" is the past tense.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f10a50bc-f57a-5a10-80a9-ef8a32a80420', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'Which sentence means "She paused what she was doing in order to have a cigarette"?', '[{"id":"a","text":"She stopped smoking."},{"id":"b","text":"She quit to smoke."},{"id":"c","text":"She gave up smoking."},{"id":"d","text":"She stopped to smoke."}]'::jsonb, 'd', '"stop to do" means pause an activity in order to do something else: stopped to smoke = paused in order to smoke. "stopped smoking" means she quit smoking permanently. "quit to smoke" is not a natural English construction, and "gave up smoking" also means she ceased permanently.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5906b752-c97f-5f04-b7bf-bc01691934a4', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'Complete: "I''m looking forward ___ you next week."', '[{"id":"a","text":"to see"},{"id":"b","text":"seeing"},{"id":"c","text":"to seeing"},{"id":"d","text":"see"}]'::jsonb, 'c', 'In "look forward to", the word "to" is a preposition, not an infinitive marker, so it must be followed by a gerund: look forward to seeing. "to see" treats "to" as an infinitive marker (wrong here), and "seeing" alone is missing the required preposition "to".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e341500f-4941-59ce-a090-f2c8ed745ffa', 'bcf2e211-12da-59b0-a1d4-81d4a880af84', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I remember posting the letter — I was at the post office at noon."},{"id":"b","text":"Please remember posting the letter before you leave."},{"id":"c","text":"She avoided making eye contact during the interview."},{"id":"d","text":"They agreed to meet outside the cinema."}]'::jsonb, 'b', 'Sentence (b) is incorrect. "Remember to do" (infinitive) means don''t forget a future task, so it should be "remember to post the letter". "Remember doing" (gerund) recalls a past event — but posting the letter hasn''t happened yet here. (a), (c) and (d) all follow the correct gerund/infinitive rules.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', '⭐ Practice: Gerund or Infinitive?', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cda565c5-bf38-5227-b692-ba8046a517f9', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Complete: "I don''t mind ___ late if it helps the team."', '[{"id":"a","text":"staying"},{"id":"b","text":"to stay"},{"id":"c","text":"stay"},{"id":"d","text":"stayed"}]'::jsonb, 'a', '"mind" is a gerund-only verb: I don''t mind staying. Using the infinitive "to stay" after "mind" is a classic learner error. "stay" (bare infinitive) and "stayed" (past tense) are also incorrect after "mind".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18e47bb7-c79e-55ef-9620-90df1e79065f', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Complete: "We decided ___ a completely new approach to the problem."', '[{"id":"a","text":"trying"},{"id":"b","text":"try"},{"id":"c","text":"to try"},{"id":"d","text":"tried"}]'::jsonb, 'c', '"decide" is an infinitive-only verb: We decided to try. "trying" (gerund) cannot follow decide, "try" (bare infinitive without to) is also wrong after decide, and "tried" is a past tense form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bd6af41-5ee8-5f14-babf-636e5046cf9f', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Complete: "Can you imagine ___ in a city with no internet?"', '[{"id":"a","text":"live"},{"id":"b","text":"to live"},{"id":"c","text":"lived"},{"id":"d","text":"living"}]'::jsonb, 'd', '"imagine" is a gerund-only verb: Can you imagine living? "to live" (infinitive) is not used after imagine, "live" is the bare base form, and "lived" is the past tense — neither is acceptable after imagine.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65e62480-1cb3-5218-abd8-04559ba3e166', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Complete: "She managed ___ the final exam despite being ill for a week."', '[{"id":"a","text":"passing"},{"id":"b","text":"to pass"},{"id":"c","text":"pass"},{"id":"d","text":"to passing"}]'::jsonb, 'b', '"manage" is an infinitive-only verb: She managed to pass. "passing" (gerund) cannot follow manage, "pass" is missing the required "to", and "to passing" mixes both forms incorrectly.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1335d5b-48e7-50aa-99e2-baa60fe8c979', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Complete: "They denied ___ any money from the company accounts."', '[{"id":"a","text":"to take"},{"id":"b","text":"take"},{"id":"c","text":"taking"},{"id":"d","text":"taken"}]'::jsonb, 'c', '"deny" is a gerund-only verb: They denied taking. The infinitive "to take" cannot follow deny — this is a frequent B2 error. "take" and "taken" are also grammatically incorrect after deny.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f840ab5d-2eb2-531a-bc1f-f56fbd48f7e2', 'bd1eee2d-4b0b-5627-8a0d-17019874ac7a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She finished writing the report before noon."},{"id":"b","text":"They plan to renovate the kitchen next month."},{"id":"c","text":"I avoid using my phone while driving."},{"id":"d","text":"He hopes passing the driving test on his first attempt."}]'::jsonb, 'd', 'Sentence (d) is incorrect. "hope" is an infinitive-only verb, so it must be: He hopes to pass. "Passing" (gerund) cannot follow hope. (a) is correct (finish + gerund), (b) is correct (plan + infinitive), and (c) is correct (avoid + gerund).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', '⭐⭐ Review: Verbs That Change Meaning', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e71810a-aae4-5521-9b4c-06a0e4bb2470', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'What does the sentence "I remember meeting her at the conference" mean?', '[{"id":"a","text":"I have a memory of meeting her at the conference."},{"id":"b","text":"I must not forget to meet her at the conference."},{"id":"c","text":"I arranged to meet her at the conference."},{"id":"d","text":"I regret meeting her at the conference."}]'::jsonb, 'a', '"remember doing" (gerund) refers to a memory of a past event: I have a memory of meeting her. "remember to do" (infinitive) means not forgetting a future task. (b) describes a future obligation, (c) is a different meaning, and (d) confuses remember with regret.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a09fe17a-eb6e-500e-a76c-c48fbabb94f7', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'Complete: "I tried ___ the window but it was stuck fast."', '[{"id":"a","text":"opening"},{"id":"b","text":"to open"},{"id":"c","text":"open"},{"id":"d","text":"to opening"}]'::jsonb, 'b', '"try to do" means make an effort or attempt, often without success: I tried to open it but couldn''t. "try doing" (gerund) means experimenting with something as a possible solution — that meaning doesn''t fit here since the context shows a failed attempt. "open" and "to opening" are both grammatically incorrect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09b8a4ed-4f81-5bc2-a9e6-2bbcc5cde072', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'Complete: "We regret ___ you that your application has been unsuccessful."', '[{"id":"a","text":"telling"},{"id":"b","text":"to telling"},{"id":"c","text":"tell"},{"id":"d","text":"to tell"}]'::jsonb, 'd', '"regret to do" (infinitive) is used formally to introduce bad news: We regret to tell you. "regret doing" (gerund) expresses sorrow about a past action, but here the news is being given now. "tell" (bare infinitive) is missing "to", and "to telling" wrongly combines both forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ce16ecb-7b24-5896-ba92-47bab473492f', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Please remember to submit your assignment by Friday."},{"id":"b","text":"I tried adding more salt and the soup was much better."},{"id":"c","text":"He regretted to say such a cruel thing to his friend."},{"id":"d","text":"She forgot to lock the door before leaving."}]'::jsonb, 'c', 'Sentence (c) is incorrect. "regret to do" (infinitive) is used formally to deliver bad news in the present, e.g. "We regret to inform you". To express sorrow about a past action, use the gerund: He regretted saying such a cruel thing. (a) is correct (remember to do = future task), (b) is correct (try doing = experiment), and (d) is correct (forget to do = failed future task).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bed76d6-5c0f-574c-a110-ddf4911df809', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'Complete: "After introducing the project, the director went on ___ the financial results."', '[{"id":"a","text":"discussing"},{"id":"b","text":"to discuss"},{"id":"c","text":"discuss"},{"id":"d","text":"to discussing"}]'::jsonb, 'b', '"go on to do" (infinitive) means move on to a new or next activity: went on to discuss the results. "go on doing" (gerund) means continue the same activity — but here the director moves from introducing to a new topic (results). "discuss" is missing "to", and "to discussing" wrongly combines both forms.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c5ecc2c-64fb-5559-9dce-bfd837aab012', '4f99d53d-597e-57f1-ae84-7ea20f1c1bfe', 'Read: "Tom was walking home. He saw a café and decided to go in. He ordered a coffee and sat by the window."
Which sentence best describes Tom''s action?', '[{"id":"a","text":"Tom stopped drinking coffee."},{"id":"b","text":"Tom tried to stop walking for coffee."},{"id":"c","text":"Tom forgot stopping for coffee."},{"id":"d","text":"Tom stopped walking to get a coffee."}]'::jsonb, 'd', 'Tom paused his walk in order to get a coffee, which is exactly "stop to do": stopped walking to get a coffee. (a) "stopped drinking coffee" implies he quit, which contradicts the passage. (b) "tried to stop walking" implies difficulty or failure, not shown here. (c) "forgot stopping" is not a natural construction in this context.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d3edc675-da3e-51d5-af79-48c9a346f63d', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: Gerunds and Infinitives', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5d14885-c4ff-5bf8-af08-a2743f78c86e', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Complete: "I''m thinking of ___ a cooking class this autumn."', '[{"id":"a","text":"to join"},{"id":"b","text":"join"},{"id":"c","text":"joining"},{"id":"d","text":"joined"}]'::jsonb, 'c', 'After the preposition "of", you must use the gerund: thinking of joining. Any preposition (of, about, in, at, without) always takes the -ing form. "to join" (infinitive) cannot follow a preposition, "join" is the bare base form, and "joined" is the past tense.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28b3bd68-4abd-5a97-8b3a-5f6afd4ec053', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Complete: "She is very good ___ other people''s feelings."', '[{"id":"a","text":"at understanding"},{"id":"b","text":"to understand"},{"id":"c","text":"in understanding"},{"id":"d","text":"for understand"}]'::jsonb, 'a', 'The fixed expression is "good at" + gerund: good at understanding. The preposition after "good" is always "at", not "to" or "in" or "for". And after any preposition the form must be the gerund (-ing), making (a) the only correct answer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8445449-8f48-5808-b0e8-186cdd1246c1', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Complete: "Do you remember ___ the post office on the way home?"', '[{"id":"a","text":"to pass"},{"id":"b","text":"pass"},{"id":"c","text":"to passing"},{"id":"d","text":"passing"}]'::jsonb, 'd', '"remember doing" (gerund) asks about a memory of a past event: Do you remember passing the post office? The context refers to something that already happened on the way home. "remember to do" (infinitive) is for future tasks you must not forget — that meaning does not fit here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40b3c2af-58d7-5d29-a5e5-60d71c3c010a', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Complete: "He left the meeting ___ a single word."', '[{"id":"a","text":"without saying"},{"id":"b","text":"without to say"},{"id":"c","text":"without say"},{"id":"d","text":"not to say"}]'::jsonb, 'a', 'After the preposition "without", only the gerund is possible: without saying. "without to say" incorrectly uses an infinitive after a preposition, "without say" uses the bare base form, and "not to say" changes the meaning entirely (it would suggest a deliberate choice not to speak).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfdd860b-ae76-5596-be6b-1701f665c13e', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Read: "After dinner, Layla washed the dishes and then moved to the living room to read."
Which best describes what Layla did after dinner?', '[{"id":"a","text":"Layla went on washing the dishes in the living room."},{"id":"b","text":"Layla stopped reading to do the dishes."},{"id":"c","text":"Layla went on to read after finishing the dishes."},{"id":"d","text":"Layla kept on reading while washing the dishes."}]'::jsonb, 'c', '"go on to do" (infinitive) means move on to a new activity: she went on to read after finishing the dishes. (a) "went on washing in the living room" doesn''t match — washing was done in the kitchen. (b) reverses the order of events. (d) implies she read while washing, which contradicts the passage.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e725d3c-f9ca-5d7e-aaff-35199459d97b', 'd3edc675-da3e-51d5-af79-48c9a346f63d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I''m interested in applying for the position."},{"id":"b","text":"She is looking forward to hear the results."},{"id":"c","text":"He objects to being treated like a child."},{"id":"d","text":"Thank you for helping me move the furniture."}]'::jsonb, 'b', 'Sentence (b) is incorrect. In "look forward to", the word "to" is a preposition, not an infinitive marker — so it must be followed by the gerund: looking forward to hearing. (a) is correct (interested in + gerund), (c) is correct (object to + gerund), and (d) is correct (thank you for + gerund).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ab523941-55ea-5448-9e3c-343a105141d1', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: Gerunds and Infinitives', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8329f4a-ca50-5b49-8d39-4cc0da9bd88c', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Complete: "The teacher made all the students ___ their essays again."', '[{"id":"a","text":"to rewrite"},{"id":"b","text":"rewriting"},{"id":"c","text":"rewrite"},{"id":"d","text":"to rewriting"}]'::jsonb, 'c', 'After "make" (causative), use the bare infinitive — no "to": made the students rewrite. "to rewrite" is the to-infinitive, which cannot follow make in an active sentence. Note: in the passive, "to" returns (The students were made to rewrite). "rewriting" is a gerund, and "to rewriting" is never correct.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4c02a7b-e975-52c5-aa25-14639e542e22', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Complete: "I''m not used to ___ up before six in the morning."', '[{"id":"a","text":"get"},{"id":"b","text":"getting"},{"id":"c","text":"to get"},{"id":"d","text":"got"}]'::jsonb, 'b', 'In "be used to", the word "to" is a preposition meaning accustomed to — so it must be followed by the gerund: used to getting up. Don''t confuse this with "used to do" (past habit) where "to" is an infinitive marker. "get" and "to get" treat "to" as an infinitive marker (wrong here), and "got" is the past tense.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8abe6623-b4d1-56db-8a60-037642c73fc6', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Complete: "She tried ___ earlier, but the traffic was just as bad."', '[{"id":"a","text":"to leave"},{"id":"b","text":"leaving"},{"id":"c","text":"leave"},{"id":"d","text":"to leaving"}]'::jsonb, 'b', '"try doing" (gerund) means experiment with something as a possible solution: she tried leaving earlier (as an experiment to avoid traffic). "try to do" (infinitive) means make an effort — but if she succeeded in leaving earlier and it still didn''t help, the gerund fits. The context implies she experimented. "leave" and "to leaving" are both grammatically incorrect here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edf7b1af-b64a-5eb2-bb81-cfb89f60ba4f', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Complete: "The company regrets ___ that this product line has been discontinued."', '[{"id":"a","text":"to announce"},{"id":"b","text":"announcing"},{"id":"c","text":"announce"},{"id":"d","text":"having announced"}]'::jsonb, 'a', '"regret to do" (infinitive) is used in formal or official contexts to introduce bad news being delivered now: regrets to announce. "regret doing" (gerund) expresses sorrow about something already done in the past, which doesn''t fit — the announcement is happening in the present statement. "announce" is missing "to", and "having announced" refers to a past completed action.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa4ab25f-e146-5b3e-9b41-99402f8d5f31', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Let the children play in the garden for an hour."},{"id":"b","text":"I would rather stay home than go out tonight."},{"id":"c","text":"They helped us move all the boxes upstairs."},{"id":"d","text":"She made her assistant to send all the emails."}]'::jsonb, 'd', 'Sentence (d) is incorrect. After "make" (causative) in the active, use the bare infinitive — no "to": She made her assistant send all the emails. (a) is correct: after "let", use the bare infinitive (let the children play). (b) is correct: "would rather" takes the bare infinitive. (c) is correct: "help" can take the bare infinitive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7900574f-3300-505c-a582-c50c0fa3485c', 'ab523941-55ea-5448-9e3c-343a105141d1', 'Read: "Mia had been running her own business for years. After winning an award, she went on to expand into three new markets and later gave a TED Talk about her journey."
What is the best interpretation of Mia''s actions?', '[{"id":"a","text":"Mia continued expanding into the same markets after the award."},{"id":"b","text":"Mia stopped expanding when she gave the TED Talk."},{"id":"c","text":"Mia moved on to new activities after winning the award."},{"id":"d","text":"Mia regretted expanding into three new markets."}]'::jsonb, 'c', '"went on to expand" (go on + infinitive) means she moved on to a new activity — expanding into new markets — after the award. This is distinct from "went on expanding" (continuing the same activity). (a) wrongly implies the same markets, (b) contradicts the text (she gave a talk after expanding, not instead), and (d) introduces regret not mentioned in the passage.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'c0fe3d29-4a59-5ebc-b60b-8935f1afba35', 'anglais-b2', '⭐⭐ Drill: Gerunds and Infinitives', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8c1b5bf-347a-5ea6-a86d-1cd66fd23c79', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'Complete: ''She suggested ___ the meeting until everyone had received the documents.''', '[{"id":"a","text":"postponing"},{"id":"b","text":"to postpone"},{"id":"c","text":"postpone"},{"id":"d","text":"to postponing"}]'::jsonb, 'a', '''Suggest'' is a gerund-only verb: suggest postponing. Using the infinitive ''to postpone'' after ''suggest'' is a classic learner error — ''suggest to do'' is not standard English. ''Postpone'' (bare base form) and ''to postponing'' (a hybrid form) are both grammatically incorrect after ''suggest''.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0568a678-61a4-5359-a27a-377e460397eb', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'Complete: ''He offered ___ us move all the heavy furniture into the new flat.''', '[{"id":"a","text":"helping"},{"id":"b","text":"help"},{"id":"c","text":"to help"},{"id":"d","text":"to helping"}]'::jsonb, 'c', '''Offer'' is an infinitive-only verb: He offered to help. ''Helping'' (gerund) cannot follow ''offer''. ''Help'' is the bare infinitive without ''to'' — wrong after ''offer''. ''To helping'' wrongly combines both forms and is never correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be40a3a0-828c-5adf-af78-0b1967acedb2', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'What does ''She remembered to call her mother on Sunday'' mean?', '[{"id":"a","text":"She has a memory of calling her mother on Sunday."},{"id":"b","text":"She did not forget to make the call."},{"id":"c","text":"She regretted calling her mother on Sunday."},{"id":"d","text":"She tried to call her mother but failed."}]'::jsonb, 'b', '''Remember to do'' (infinitive) means not forgetting a future task — she had it in mind and did it. ''Remember doing'' (gerund) would mean she has a memory of the past event. Option A describes the gerund meaning (''She remembered calling…''), not the infinitive. Option C confuses ''remember'' with ''regret''. Option D confuses it with ''try to do''.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29658aed-2279-5eed-afb8-b7f5be0b3e63', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'Complete: ''He insisted on ___ the bill despite everyone''s protests.''', '[{"id":"a","text":"to pay"},{"id":"b","text":"pay"},{"id":"c","text":"paid"},{"id":"d","text":"paying"}]'::jsonb, 'd', 'After the preposition ''on'', only the gerund is possible: insisted on paying. Any preposition (on, in, of, at, about, without) must be followed by the -ing form. ''To pay'' incorrectly treats ''on'' as an infinitive marker. ''Pay'' is the bare base form. ''Paid'' is the past tense — neither fits after a preposition.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cda7d72b-56c6-55ae-9989-e2f3fb503977', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I''m used to working long hours — it doesn''t bother me anymore."},{"id":"b","text":"She is looking forward to receiving her exam results."},{"id":"c","text":"The coach made the players to train twice a day."},{"id":"d","text":"He gave up smoking after his doctor''s warning."}]'::jsonb, 'c', 'After ''make'' (causative) in the active voice, the bare infinitive is required — no ''to'': ''The coach made the players train twice a day''. Adding ''to'' after ''make'' is a very common B2 error. Note: in the passive, ''to'' returns (''The players were made to train''). Options A and B correctly use the gerund after prepositional ''to'' (used to / looking forward to). Option D correctly uses ''gave up + gerund''.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f13e289-ca2c-5a1c-b2c6-b87c94d7c6ea', '4b2d100c-0ffa-57b5-8a79-6dc2afeedf3a', 'Read: ''Rania had been cooking the same recipe for years. One evening she tried adding a pinch of saffron and the result was extraordinary.'' What does ''tried adding'' mean here?', '[{"id":"a","text":"She made an effort to add saffron but could not manage it."},{"id":"b","text":"She experimented with adding saffron as a possible improvement."},{"id":"c","text":"She regretted adding saffron to the recipe."},{"id":"d","text":"She stopped her usual routine in order to add saffron."}]'::jsonb, 'b', '''Try doing'' (gerund) means experimenting with something as a possible solution or improvement — Rania tested adding saffron to see what would happen, and it worked. ''Try to do'' (infinitive) would mean making an effort, often implying difficulty or failure — but the text shows she did add it and succeeded. Option C confuses ''try'' with ''regret''. Option D describes ''stop to do'', not ''try doing''.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2550bdba-0ed6-5398-8dfb-081dff9c81e8', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef867e09-84d8-517b-b393-386508891223', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', 'Complete: "Don''t call at noon — she ___ her presentation then."', '[{"id":"a","text":"will give"},{"id":"b","text":"is going to give"},{"id":"c","text":"will be giving"},{"id":"d","text":"will have given"}]'::jsonb, 'c', 'The action will be in progress at a specific future moment (noon), so we use the future continuous: will be giving. "will give" is a simple prediction with no sense of being in progress at that exact moment, "going to give" expresses intention, and "will have given" means it will be finished by then — the opposite of what the sentence implies.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df57f1f9-c31e-57d0-93c5-360c440d8507', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', 'Complete: "By the time the guests arrive, I ___ dinner."', '[{"id":"a","text":"will cook"},{"id":"b","text":"will be cooking"},{"id":"c","text":"am going to cook"},{"id":"d","text":"will have cooked"}]'::jsonb, 'd', '"By the time" signals that the action will be finished before a future point, so we use the future perfect: will have cooked. "will be cooking" means in progress at that moment, "will cook" is a bare future prediction, and "am going to cook" expresses intention without the sense of completion by a deadline.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbaada48-a36c-516d-8e98-a440913a9b7a', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', 'Which sentence uses the future perfect continuous CORRECTLY?', '[{"id":"a","text":"By next month, I will have been working here for two years."},{"id":"b","text":"By next month, I will be working here for two years."},{"id":"c","text":"By next month, I will have work here for two years."},{"id":"d","text":"By next month, I will working here for two years."}]'::jsonb, 'a', 'The future perfect continuous is will have been + verb-ing to emphasise duration up to a future point: will have been working. "will be working" is the future continuous (in progress at that moment, not duration). "will have work" is missing the participle and auxiliary been, and "will working" is missing have been.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ad7da72-9445-51d3-b082-9f773c3ae341', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', 'Complete: "___ you be using the printer this afternoon? I need it urgently."', '[{"id":"a","text":"Are"},{"id":"b","text":"Do"},{"id":"c","text":"Will"},{"id":"d","text":"Have"}]'::jsonb, 'c', 'A polite enquiry about someone''s future plans uses the future continuous: Will you be using…? "Are" makes a present-continuous question, "Do" makes a present-simple question, and "Have" would start a present-perfect question — none of those ask about a future plan politely.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('694f1c14-3b25-5230-9f44-db258e2b7d26', '2550bdba-0ed6-5398-8dfb-081dff9c81e8', 'Complete: "By the time you ___, the film will have started."', '[{"id":"a","text":"will arrive"},{"id":"b","text":"arrive"},{"id":"c","text":"are arriving"},{"id":"d","text":"will have arrived"}]'::jsonb, 'b', 'After "by the time" in a future context, the subordinate clause uses the present simple, not a future form: by the time you arrive. Using "will arrive" or "will have arrived" in the subordinate clause is a common error — future meaning is already carried by "by the time" plus the main clause future perfect.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('875bf9ba-a8fa-53d3-a982-04b227d743a2', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', '⭐ Practice: Future Continuous and Future Perfect Forms', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c03b5b7-98ed-54d9-909d-7beb8f64027c', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "This time tomorrow, she ___ on the beach."', '[{"id":"a","text":"will relax"},{"id":"b","text":"will be relaxing"},{"id":"c","text":"will have relaxed"},{"id":"d","text":"is relaxing"}]'::jsonb, 'b', '"This time tomorrow" points to a moment when the action will be in progress, so we use the future continuous: will be relaxing. "will relax" is a simple prediction without the in-progress meaning, "will have relaxed" means it will be finished by then, and "is relaxing" is the present continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afb469b2-0350-5baf-a2a4-2e488d8fc3e2', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "By Friday, the team ___ the report."', '[{"id":"a","text":"will be finishing"},{"id":"b","text":"finishes"},{"id":"c","text":"will have finished"},{"id":"d","text":"is going to finish"}]'::jsonb, 'c', '"By Friday" is a deadline — the action will be completed before that point, so we use the future perfect: will have finished. "will be finishing" means in progress at that moment (not done), "finishes" is present simple, and "is going to finish" states intention without the by-deadline completion sense.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5945e582-fb19-5d94-bf77-365d7d07dfbe', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "___ he be waiting for us when we land?"', '[{"id":"a","text":"Does"},{"id":"b","text":"Is"},{"id":"c","text":"Will"},{"id":"d","text":"Has"}]'::jsonb, 'c', 'The future continuous question form is Will + subject + be + verb-ing: Will he be waiting? "Does" makes a present-simple question, "Is" makes a present-continuous question, and "Has" starts a present-perfect question — none are future continuous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f953bd7-0861-59d1-ab24-fe12e0f0775b', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "I ___ this city for ten years by the time I retire."', '[{"id":"a","text":"will have been living in"},{"id":"b","text":"will be living in"},{"id":"c","text":"have lived in"},{"id":"d","text":"lived in"}]'::jsonb, 'a', 'The sentence stresses how long a continuous action will have lasted by a future point (retirement), so we use the future perfect continuous: will have been living in. "will be living in" only says it will be in progress at that moment without stressing duration, "have lived in" is the present perfect, and "lived in" is past simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0899db8e-4eaa-5a56-9633-af5577869217', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "She ___ arrive at noon — she''s still at work."', '[{"id":"a","text":"won''t"},{"id":"b","text":"won''t have"},{"id":"c","text":"isn''t going"},{"id":"d","text":"won''t be"}]'::jsonb, 'd', 'The negative future continuous is won''t be + verb-ing: She won''t be arriving at noon. "won''t" alone needs the base verb (won''t arrive), which changes the meaning to a simple negative prediction. "won''t have" starts the future perfect negative, and "isn''t going" is present continuous used for the future — different structure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65997d0a-0cd7-589e-9ff3-91787a327f3b', '875bf9ba-a8fa-53d3-a982-04b227d743a2', 'Complete: "By midnight, the surgeons ___ for twelve hours straight."', '[{"id":"a","text":"will operate"},{"id":"b","text":"will have been operating"},{"id":"c","text":"will be operated"},{"id":"d","text":"will have operated"}]'::jsonb, 'b', 'The focus is on *how long* the continuous action will have lasted by midnight — that''s the future perfect continuous: will have been operating. "will operate" is a simple future prediction, "will be operated" is a passive future continuous (wrong meaning — the surgeons are doing the operating), and "will have operated" (future perfect) stresses completion but not duration.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4849c945-ef8c-5847-94f3-4a833c47a24d', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', '⭐⭐ Review: Contrast and Signal Words', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8d468b8-bfe9-5174-b0c0-d90998b2e829', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Complete: "Don''t worry — by the time you arrive, I ___ everything."', '[{"id":"a","text":"will prepare"},{"id":"b","text":"will be preparing"},{"id":"c","text":"will have prepared"},{"id":"d","text":"am preparing"}]'::jsonb, 'c', '"By the time you arrive" signals a deadline, so the action will be completed before then: will have prepared (future perfect). "will be preparing" means it will still be in progress, "will prepare" is a bare future prediction, and "am preparing" is the present continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12b5ca61-1b0b-543d-b41d-aab0bcd11825', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Choose the sentence that uses will be + -ing to make a POLITE enquiry.', '[{"id":"a","text":"Will you use the car tomorrow?"},{"id":"b","text":"Are you going to use the car tomorrow?"},{"id":"c","text":"Will you be using the car tomorrow?"},{"id":"d","text":"Do you use the car tomorrow?"}]'::jsonb, 'c', 'The future continuous (will you be using?) softens the question by framing it as asking about someone''s plans rather than making a demand. "Will you use?" is more direct, "Are you going to use?" asks about intention, and "Do you use?" is present simple — none are the future continuous polite form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ec8168a-f0b2-52af-97c6-cb817c742968', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Complete: "At 10 tomorrow morning, the board ___ the results."', '[{"id":"a","text":"will be discussing"},{"id":"b","text":"will have discussed"},{"id":"c","text":"discusses"},{"id":"d","text":"will discuss having"}]'::jsonb, 'a', '"At 10 tomorrow morning" is a moment when the action will be in progress, so we use the future continuous: will be discussing. "will have discussed" means finished by then (but at 10 it is ongoing), "discusses" is present simple, and "will discuss having" is not a grammatical future form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18ccdaeb-c053-5614-a431-262d2af6fa9e', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Complete: "By the time she ___, the train will have left."', '[{"id":"a","text":"will arrive"},{"id":"b","text":"arrives"},{"id":"c","text":"is arriving"},{"id":"d","text":"will have arrived"}]'::jsonb, 'b', 'After "by the time" in a future sentence, the subordinate clause takes the present simple: by the time she arrives. This is the same rule as with when/if in future sentences. Using "will arrive" or "will have arrived" in the subordinate clause is a very common error at B2.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5b10cc1-0c08-5ab8-b1d5-a4066fb92ed8', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"By noon, she will have submitted her application."},{"id":"b","text":"This time next week, I will be flying to Tokyo."},{"id":"c","text":"By the time he will arrive, we will have eaten."},{"id":"d","text":"They will have been renovating the house for a year by June."}]'::jsonb, 'c', 'The error is in the third option: after "by the time" the subordinate clause must use the present simple, not a future form — it should be "by the time he arrives". The other sentences correctly use the future perfect (a), future continuous (b), and future perfect continuous (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72c8dee9-7ba0-5ded-bd4d-050ce0cca042', '4849c945-ef8c-5847-94f3-4a833c47a24d', 'Complete: "In six months, she ___ this company for a decade."', '[{"id":"a","text":"will run"},{"id":"b","text":"will be running"},{"id":"c","text":"will have run"},{"id":"d","text":"will have been running"}]'::jsonb, 'd', 'The sentence focuses on the *duration* of a continuous activity up to a future point (six months from now), which is the future perfect continuous: will have been running. "will run" is a bare future prediction, "will be running" says in progress at that moment without stressing duration, and "will have run" (future perfect) stresses completion, not ongoing duration.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c41bdc79-33dd-5b32-aa67-d6022d422825', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: Future Continuous and Future Perfect', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b0690a2-d572-57e5-9aee-9d129d44088f', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Complete: "When you get home tonight, I ___ dinner — don''t bring takeaway."', '[{"id":"a","text":"will be cooking"},{"id":"b","text":"will have been cooking"},{"id":"c","text":"will cook"},{"id":"d","text":"have cooked"}]'::jsonb, 'a', 'The action (cooking dinner) will be in progress at the moment you get home, so the future continuous is correct: will be cooking. "will cook" is a bare prediction without the in-progress frame, "will have been cooking" stresses duration up to that point (plausible but not the primary meaning here), and "have cooked" is the present perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f46e4cec-bddb-5a32-85c7-586465875e53', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I''ll have finished the project by Monday morning."},{"id":"b","text":"Will you be attending the conference next week?"},{"id":"c","text":"By the time she will call, I will have left."},{"id":"d","text":"They''ll be travelling through Spain at this time tomorrow."}]'::jsonb, 'c', 'The error is using "will call" after "by the time" — the subordinate clause after "by the time" takes the present simple: by the time she calls. The other sentences are correct: (a) future perfect with a deadline, (b) future continuous question, (d) future continuous for an in-progress future action.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3bf69861-2deb-5838-9443-ead315ac0b33', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Complete: "By next spring, our research team ___ the vaccine for three years."', '[{"id":"a","text":"will develop"},{"id":"b","text":"will be developing"},{"id":"c","text":"will have developed"},{"id":"d","text":"will have been developing"}]'::jsonb, 'd', 'The emphasis is on the continuous duration (three years) of ongoing development up to a future point (next spring) — that''s the future perfect continuous: will have been developing. "will develop" is a bare future, "will be developing" only says it''s in progress at that moment, and "will have developed" stresses completion not duration.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0231fbba-cfca-5b77-a3c4-83477a2246fa', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Two sentences describe a flight landing at 6 p.m. Choose the sentence that means the pilot FINISHED flying at exactly 6 p.m.', '[{"id":"a","text":"The pilot will be landing at 6 p.m."},{"id":"b","text":"The pilot will land at 6 p.m."},{"id":"c","text":"The pilot will have landed by 6 p.m."},{"id":"d","text":"The pilot will have been landing at 6 p.m."}]'::jsonb, 'c', '"Will have landed by 6 p.m." means the landing will be completed no later than 6 p.m. — the future perfect stresses the completion before/by that point. "Will be landing at 6 p.m." means it will be in progress at that moment, "will land at 6 p.m." is a scheduled future event, and "will have been landing" is a duration form that doesn''t fit a momentary action like landing.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a163ce3-88bb-5433-8006-e8f65e46c1d3', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Complete: "I promise I ___ the documents before the meeting starts."', '[{"id":"a","text":"will review"},{"id":"b","text":"will be reviewing"},{"id":"c","text":"will have reviewed"},{"id":"d","text":"am going to be reviewing"}]'::jsonb, 'c', 'The context is a promise that the action will be completed *before* a future event (the meeting), so the future perfect is correct: will have reviewed. "will review" is a plain promise without the before-deadline sense, "will be reviewing" means it will still be in progress when the meeting starts (contradicting the promise), and "am going to be reviewing" is not idiomatic here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee334b72-2210-5c71-aa1c-58eae3c3992e', 'c41bdc79-33dd-5b32-aa67-d6022d422825', 'Read: "The conference starts at 9 a.m. It lasts four hours. It is now 8:50 a.m."
Which sentence is TRUE at 11 a.m.?', '[{"id":"a","text":"The delegates will have left the conference."},{"id":"b","text":"The delegates will be attending the conference at 11 a.m."},{"id":"c","text":"The conference will have finished by 11 a.m."},{"id":"d","text":"The conference will begin at 11 a.m."}]'::jsonb, 'b', 'The conference runs 9 a.m. to 1 p.m. (four hours). At 11 a.m. it is still ongoing, so the delegates will be attending — the future continuous correctly captures an action in progress at that future moment. It has not finished by 11 a.m. (c and a are false), and it started at 9 a.m., not 11 a.m. (d is false).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28e1814a-6011-50d0-be81-ab7143de045d', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: Future Continuous and Future Perfect', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41ac6924-cf41-5d8a-bf0e-5f652662f4dc', '28e1814a-6011-50d0-be81-ab7143de045d', 'Read: "The surgery is scheduled for 8 a.m. and takes about five hours. The family is waiting in the hospital. It is now 11:30 a.m."
Which statement is most likely TRUE at 11:30 a.m.?', '[{"id":"a","text":"The surgeons will have completed the operation."},{"id":"b","text":"The surgeons will be operating on the patient."},{"id":"c","text":"The surgeons will have been resting for two hours."},{"id":"d","text":"The surgeons will start the operation at 11:30 a.m."}]'::jsonb, 'b', 'The surgery started at 8 a.m. and takes five hours, so it runs until roughly 1 p.m. At 11:30 a.m. it is still in progress — the future continuous (will be operating) correctly describes an action ongoing at that future moment. It will not be complete yet (a is false), the surgeons won''t be resting at this point (c), and they already started hours ago (d is false).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3789d92-d4ab-5f42-bd97-e019adcd8eec', '28e1814a-6011-50d0-be81-ab7143de045d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"By the time you read this, I will have left the country."},{"id":"b","text":"Will you be needing a lift to the airport tomorrow?"},{"id":"c","text":"She will have been working on this thesis since three years by May."},{"id":"d","text":"At this time next month, we''ll be sailing across the Atlantic."}]'::jsonb, 'c', 'The error is "since three years" — since takes a starting point in time, not a duration. The correct word for a length of time is for: she will have been working on this thesis for three years by May. The other sentences correctly use the future perfect (a), future continuous for polite enquiry (b), and future continuous for an in-progress future action (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a848bdfb-f69a-5aa7-9b0e-1a67a30c39d9', '28e1814a-6011-50d0-be81-ab7143de045d', 'Complete: "By 2030, scientists hope they ___ a cure for the disease."', '[{"id":"a","text":"will be discovering"},{"id":"b","text":"will discover"},{"id":"c","text":"will have discovered"},{"id":"d","text":"will have been discovering"}]'::jsonb, 'c', '"By 2030" is a deadline before which the discovery should be complete — that''s the future perfect: will have discovered. "will be discovering" means in progress at that moment (discovery is a result, not a continuous process here), "will discover" is a plain future prediction without the by-deadline sense, and "will have been discovering" stresses ongoing duration, not the completion of the discovery.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ddcc3d7-2df3-5b40-82d4-5aa92416327d', '28e1814a-6011-50d0-be81-ab7143de045d', 'A colleague asks for your parking space. Choose the response that uses the future continuous to express that you will NOT need it — and sounds most natural.', '[{"id":"a","text":"I won''t use it tomorrow."},{"id":"b","text":"I''m not going to use it tomorrow."},{"id":"c","text":"I won''t be using it tomorrow, so you''re welcome to it."},{"id":"d","text":"I will not have used it by tomorrow."}]'::jsonb, 'c', 'The future continuous negative (won''t be using) is the most natural way to say your plans don''t include using the space — it frames it as an absence from your schedule rather than a refusal. "Won''t use" and "not going to use" are grammatically fine but sound more like decisions/refusals than schedule descriptions. "Will not have used it by tomorrow" (future perfect) implies a deadline sense that doesn''t fit the context.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14c254f5-0709-5091-b64c-b95b83442918', '28e1814a-6011-50d0-be81-ab7143de045d', 'Complete: "By the time this documentary ___, the viewers ___ more than two hours of footage."', '[{"id":"a","text":"ends / will watch"},{"id":"b","text":"will end / will be watching"},{"id":"c","text":"will have ended / watch"},{"id":"d","text":"ends / will have watched"}]'::jsonb, 'd', '"By the time" takes the present simple in the subordinate clause (ends), and the main clause needs the future perfect to show completion before that point (will have watched). "ends / will watch" gets the subordinate right but uses a bare future instead of the future perfect. "will end / will be watching" has a future in the subordinate clause (wrong) and uses the continuous (in progress) instead of the perfect (finished). "will have ended / watch" reverses the logic entirely.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5740b77-3b50-54cd-9989-c40865f530ba', '28e1814a-6011-50d0-be81-ab7143de045d', 'Read: "Laila joined the company in 2020. She was promoted to team lead in 2022. In 2025 she plans to move abroad."
Which sentence is TRUE in 2025?', '[{"id":"a","text":"By 2025, Laila will have been working at the company for five years."},{"id":"b","text":"By 2025, Laila will be promoted to team lead."},{"id":"c","text":"In 2025, Laila will have been moving abroad."},{"id":"d","text":"In 2025, Laila will have joined the company."}]'::jsonb, 'a', 'Laila joined in 2020, so by 2025 she will have worked there for five years — the future perfect continuous correctly emphasises that duration: will have been working for five years. Her promotion already happened in 2022 (b uses future, wrong). "Will have been moving" is incorrect — moving abroad is not a continuous activity to measure duration. "Will have joined" implies the joining happens by 2025, but she already joined in 2020.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', '3b97bbaa-ee21-5581-a382-40ec409fdaa4', 'anglais-b2', '⭐⭐ Drill: Future Forms', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('526188ef-cd1b-5579-84d9-193419472057', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Complete: ''At 3 p.m. tomorrow, the committee ___ the candidates.''', '[{"id":"a","text":"will interview"},{"id":"b","text":"will have interviewed"},{"id":"c","text":"will be interviewing"},{"id":"d","text":"is going to interview"}]'::jsonb, 'c', '''At 3 p.m. tomorrow'' is a specific future moment when the action will be in progress, so the future continuous ''will be interviewing'' is correct. ''Will interview'' is a simple future prediction without the in-progress meaning. ''Will have interviewed'' (future perfect) means the interviews will be finished by 3 p.m. — the opposite of what the sentence implies. ''Is going to interview'' expresses intention but does not capture the in-progress sense at that moment.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78cc4c39-9842-5a71-aee0-07df55eb0e1a', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Complete: ''By the end of this month, the construction team ___ the new pedestrian bridge.''', '[{"id":"a","text":"will be completing"},{"id":"b","text":"will have completed"},{"id":"c","text":"is completing"},{"id":"d","text":"will complete"}]'::jsonb, 'b', '''By the end of this month'' is a deadline — the action will be finished before that point, so the future perfect ''will have completed'' is correct. ''Will be completing'' means the action will still be in progress at that deadline, contradicting the sense of completion. ''Is completing'' is present continuous. ''Will complete'' is a bare future prediction without the before-deadline sense.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('116e3ba9-054e-50cb-9e7c-c5a73e2c6e9b', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Choose the future continuous question that sounds most NATURAL as a polite enquiry.', '[{"id":"a","text":"Will you drive to the conference tomorrow?"},{"id":"b","text":"Are you driving to the conference tomorrow?"},{"id":"c","text":"Will you be driving to the conference tomorrow?"},{"id":"d","text":"Do you drive to the conference tomorrow?"}]'::jsonb, 'c', '''Will you be driving…?'' uses the future continuous to make a polite enquiry about plans — it feels like asking about someone''s schedule rather than making a demand or pressing for a commitment. ''Will you drive?'' is more direct and sounds like a request. ''Are you driving?'' (present continuous for future) asks about intention but is less formal than the future continuous. ''Do you drive?'' is present simple and does not refer to the future.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a53b96e-5791-519f-9325-9279cd0aa635', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Complete: ''By next autumn, she ___ this language school for exactly ten years.''', '[{"id":"a","text":"will run"},{"id":"b","text":"will be running"},{"id":"c","text":"will have run"},{"id":"d","text":"will have been running"}]'::jsonb, 'd', 'The sentence emphasises the continuous duration (ten years) of an ongoing activity up to a future point (next autumn) — this is the future perfect continuous ''will have been running''. ''Will run'' is a bare future prediction. ''Will be running'' only says the action is in progress at that moment without stressing accumulated duration. ''Will have run'' (future perfect) stresses completion but not ongoing process over time.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e611299-3dd8-53fb-95f0-9dc5f9124be1', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Find the INCORRECT sentence.', '[{"id":"a","text":"This time next week, we''ll be cruising through the Mediterranean."},{"id":"b","text":"By the time you finish reading this, I will have left."},{"id":"c","text":"By the time you will finish reading this, I will have left."},{"id":"d","text":"In two years, she will have been studying medicine for six years."}]'::jsonb, 'c', 'After ''by the time'', the subordinate clause takes the present simple — not a future form. ''By the time you will finish'' is wrong; the correct form is ''by the time you finish''. This rule parallels future time clauses with ''when'' and ''if''. Options A (future continuous for an in-progress action), B (future perfect with correct present simple in the subordinate clause), and D (future perfect continuous for duration) are all correct.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87302b7b-9742-5066-8836-25ad9170d964', 'a8d3f3c4-ea37-54eb-9c24-0e9e12cfa100', 'Read: ''The surgeon started operating at 7 a.m. The procedure takes around six hours.'' Which sentence is TRUE at 10 a.m.?', '[{"id":"a","text":"The surgeon will have finished operating by 10 a.m."},{"id":"b","text":"The surgeon will have been operating for three hours at 10 a.m."},{"id":"c","text":"The surgeon will start operating at 10 a.m."},{"id":"d","text":"The surgeon will be resting at 10 a.m."}]'::jsonb, 'b', 'The surgery started at 7 a.m. and lasts six hours, so at 10 a.m. it will have been running for three hours — still in progress. The future perfect continuous ''will have been operating for three hours'' correctly emphasises the duration elapsed up to that future moment. Option A is false — the surgery ends around 1 p.m., not by 10 a.m. Option C is false — the surgery already started at 7 a.m. Option D is false — the surgeon is still operating at 10 a.m.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('40fd3e66-f98d-5093-85a2-d24753ecbd31', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98dc70f6-1335-507d-9c11-e5ff98ac3fcb', '40fd3e66-f98d-5093-85a2-d24753ecbd31', 'According to the lesson, what is the difference between a topic and a main argument?', '[{"id":"a","text":"A topic is what the text is about; a main argument is what the writer claims about it."},{"id":"b","text":"A topic is always longer than a main argument."},{"id":"c","text":"A main argument only appears in the conclusion."},{"id":"d","text":"A topic and a main argument are the same thing."}]'::jsonb, 'a', 'The lesson distinguishes topic (the subject matter) from main argument (the writer''s central claim about that subject). The main argument is usually stated early and restated at the end, not only in the conclusion — and length has nothing to do with the difference.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86a3a201-db7b-5398-9d74-7cd8ac21588d', '40fd3e66-f98d-5093-85a2-d24753ecbd31', 'A writer uses the phrase "so-called experts" when describing people who support a policy. What tone does this suggest?', '[{"id":"a","text":"Enthusiastic"},{"id":"b","text":"Ironic or sceptical"},{"id":"c","text":"Cautious and balanced"},{"id":"d","text":"Neutral and objective"}]'::jsonb, 'b', '"So-called" signals that the writer is questioning whether those people really deserve the label "experts" — this is ironic or sceptical language. Enthusiastic writers use words like "remarkable", balanced writers use "while… nevertheless", and neutral writers avoid evaluative phrases like "so-called".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18f7c4e7-e095-5d50-85ad-aef6905a3231', '40fd3e66-f98d-5093-85a2-d24753ecbd31', 'Which of the following is an example of an INFERENCE question?', '[{"id":"a","text":"\"According to the text, how many people lost their jobs?\""},{"id":"b","text":"\"What does the word ''consternation'' mean in line 5?\""},{"id":"c","text":"\"What does the writer suggest about the reliability of official figures?\""},{"id":"d","text":"\"In which paragraph does the writer mention the government?\""}]'::jsonb, 'c', '"What does the writer suggest" is the classic phrasing for an inference question — the answer is implied, not directly stated. "According to the text" (a) asks for directly stated information, "what does the word mean" (b) is vocabulary in context, and "in which paragraph" (d) is a locating task.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('885a7032-b56f-5519-8b6b-b9eb3dc8944d', '40fd3e66-f98d-5093-85a2-d24753ecbd31', 'Read: "Sales fell by 12% in Q3. This proves that the government''s tax policy has been a catastrophic failure."
Which part is a FACT?', '[{"id":"a","text":"The government''s tax policy has been a catastrophic failure."},{"id":"b","text":"Both statements are facts."},{"id":"c","text":"Neither statement is a fact."},{"id":"d","text":"Sales fell by 12% in Q3."}]'::jsonb, 'd', '"Sales fell by 12% in Q3" is a verifiable statistic — a fact. "The government''s tax policy has been a catastrophic failure" is a judgment drawn from that statistic — an opinion. The lesson specifically warns that a statistic is a fact but a conclusion drawn from it is often an opinion.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dc90b1e-f96c-5f8e-9963-2d597aee766f', '40fd3e66-f98d-5093-85a2-d24753ecbd31', 'According to the B2 reading workflow in the lesson, what should you do FIRST when you open a reading text?', '[{"id":"a","text":"Read every word carefully from start to finish."},{"id":"b","text":"Look up unknown vocabulary."},{"id":"c","text":"Skim the whole text to get the topic, structure, and tone."},{"id":"d","text":"Answer the easiest question first, then read the text."}]'::jsonb, 'c', 'The five-step workflow starts with skimming the whole text (about 30 seconds) to get the topic, structure, and tone before doing anything else. Reading every word carefully comes later when you re-read relevant sections; looking up vocabulary is not part of exam strategy; and answering without reading is the opposite of the workflow.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2867c39e-2469-54b7-a72c-0a3a1641e014', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', '⭐ Practice: Main Argument and Tone', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7fd5ec4-6e49-5074-802f-78b198c69ba3', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"Urban cycling infrastructure has expanded rapidly in many cities over the past decade. Dedicated lanes, rental schemes and safer junctions have encouraged millions of people to commute by bike. The health benefits are well documented, and the reduction in car traffic eases congestion for everyone. There is, quite simply, no smarter investment a city can make."

What is the writer''s main argument?', '[{"id":"a","text":"Investing in cycling infrastructure is the best use of city funds."},{"id":"b","text":"Urban cycling is popular in many cities."},{"id":"c","text":"Cycling is healthier than driving."},{"id":"d","text":"Dedicated lanes reduce congestion."}]'::jsonb, 'a', 'The final sentence — "There is, quite simply, no smarter investment a city can make" — is the writer''s central claim that the whole paragraph builds towards: cycling infrastructure is the best investment. Options about popularity (b), health (c), and congestion (d) are supporting points, not the main argument.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('589a01cb-a142-5e69-9932-e494b64bdf5d', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"The new sports complex opened last spring to considerable fanfare. Officials praised its state-of-the-art facilities and predicted record visitor numbers. By summer, however, the car park was consistently empty on weekday mornings, the café had closed due to low demand, and the swimming pool was running at a third of its capacity."

What tone does the writer use?', '[{"id":"a","text":"Enthusiastic and supportive"},{"id":"b","text":"Neutral and purely descriptive"},{"id":"c","text":"Sceptical and implicitly critical"},{"id":"d","text":"Ironic but ultimately positive"}]'::jsonb, 'c', 'The writer contrasts the officials'' optimistic promises with the reality of low usage (empty car park, closed café, low pool capacity). The contrast between the fanfare and the facts implies the promises were wrong — a sceptical, implicitly critical tone. The writer does not cheer for the complex (not enthusiastic), and while factual details are given, their selection and contrast are not purely neutral.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('687685cd-742d-575a-aded-d44b5d03f8dd', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"Teenagers today are often accused of spending too much time on screens. Yet research consistently shows that most young people are well aware of the risks and actively manage their digital habits. Perhaps the real problem is not the teenagers themselves but the adults who designed the addictive systems they navigate."

What is the writer''s main argument?', '[{"id":"a","text":"Teenagers spend too much time on screens."},{"id":"b","text":"Screen time research is unreliable."},{"id":"c","text":"Adults, not teenagers, are responsible for the problem."},{"id":"d","text":"Digital habits should be managed more strictly."}]'::jsonb, 'c', 'The paragraph opens by stating the common accusation, then counters it with research, and ends by redirecting blame to adults who designed addictive systems. The main argument is that adults are responsible, not teenagers. Options about screen time (a) and strict management (d) echo what the writer argues against, and the writer does not question research reliability (b).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40971d03-98bc-5426-92b2-f59a7d975235', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"The report concludes that the programme delivered measurable improvements in literacy rates, reduced school dropout figures, and demonstrably better employment outcomes for participants. While the cost per student was higher than conventional programmes, the long-term savings to the state in reduced welfare spending more than offset the initial investment."

How does the writer present the cost of the programme?', '[{"id":"a","text":"As an unacceptable burden on taxpayers"},{"id":"b","text":"As a drawback outweighed by long-term financial benefits"},{"id":"c","text":"As proof the programme should be cancelled"},{"id":"d","text":"As a reason to question the report''s findings"}]'::jsonb, 'b', 'The writer acknowledges the higher cost per student (a concession — "while the cost was higher") but immediately shows it is offset by long-term savings, presenting cost as a drawback that is outweighed by benefits. This is a balanced, cautious tone. The writer does not call the cost unacceptable, does not suggest cancellation, and does not doubt the report.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c85872a4-9817-5495-9972-56c0a47e756c', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"The minister confidently declared the housing crisis ''over'' in March. By June, rough sleeping in the capital had risen by 18%. Shelter groups reported the longest waiting lists in a decade. The minister, meanwhile, had moved on to a new portfolio."

What tone best describes the final sentence?', '[{"id":"a","text":"Sympathetic toward the minister"},{"id":"b","text":"Ironic and critical"},{"id":"c","text":"Factual and supportive of the government"},{"id":"d","text":"Cautious and balanced"}]'::jsonb, 'b', '"The minister, meanwhile, had moved on to a new portfolio" appears immediately after damning statistics, implying the minister left the crisis unresolved without consequence — a sharp ironic and critical comment. It is not sympathetic, not supportive, and not balanced: the juxtaposition is deliberately pointed.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97401b8c-5716-5bbf-b429-5a5667be9109', '2867c39e-2469-54b7-a72c-0a3a1641e014', 'Read:
"Proponents of the four-day working week argue that productivity rises when employees are less fatigued. Critics counter that the model suits office-based knowledge workers but is impractical for shift-based industries such as healthcare and retail. Both sides agree, however, that the current conversation is long overdue."

What is the writer''s stance?', '[{"id":"a","text":"Strongly in favour of the four-day week"},{"id":"b","text":"Strongly opposed to the four-day week"},{"id":"c","text":"Dismissive of the debate"},{"id":"d","text":"Balanced, presenting both sides without taking a clear position"}]'::jsonb, 'd', 'The writer presents the arguments of both proponents and critics using neutral reporting language ("argue that", "counter that"), then notes a point of agreement. No evaluative language signals personal support or opposition — this is a balanced, measured stance. The writer is clearly engaged with the debate, not dismissive (c).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c3207e20-7eb4-50bb-876c-aa0673fdb224', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', '⭐⭐ Review: Inference and Vocabulary in Context', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c89c5a7e-546f-5fee-93f4-e5e5515c8fa5', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"The committee''s report ran to four hundred pages. Its recommendations were described by the Prime Minister as ''interesting''. No legislation followed."

What does the writer imply about the government''s response to the report?', '[{"id":"a","text":"The government found the report genuinely fascinating."},{"id":"b","text":"The government effectively ignored the report''s recommendations."},{"id":"c","text":"The government was planning future legislation based on the report."},{"id":"d","text":"The Prime Minister disagreed with the committee''s findings."}]'::jsonb, 'b', 'The word "interesting" from a politician, followed immediately by "No legislation followed", implies the government gave the report a non-committal compliment and then did nothing — effectively ignoring it. The writer does not state this directly but the sequence implies it clearly. "Fascinating" (a) takes the word at face value, future legislation (c) contradicts the final sentence, and personal disagreement (d) is not implied.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0374fe65-254f-5ae7-8fe7-7fb64de0590d', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"The new exhibition was met with widespread **consternation** among art critics, many of whom had expected something far more conventional from the gallery."

The word "consternation" most likely means:', '[{"id":"a","text":"delight and admiration"},{"id":"b","text":"alarm and dismay"},{"id":"c","text":"mild curiosity"},{"id":"d","text":"boredom and indifference"}]'::jsonb, 'b', 'The critics "had expected something far more conventional" — the exhibition surprised and unsettled them. "Consternation" is used for a reaction of alarm or dismay at something unexpected. Delight (a) would not follow a negative surprise, mild curiosity (c) is too weak, and boredom/indifference (d) is the opposite of a strong reaction to surprise.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fde0a474-3692-5806-89c1-9d193b5231fd', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"Organic food sales have tripled over the past decade. Many consumers believe organic produce is healthier. However, multiple large-scale studies have found no consistent evidence that organic food provides greater nutritional benefits than conventionally grown food."

What does the writer imply?', '[{"id":"a","text":"Organic food is definitely healthier than conventional food."},{"id":"b","text":"Consumer belief in organic food''s health benefits may not be supported by evidence."},{"id":"c","text":"People should stop buying organic food immediately."},{"id":"d","text":"The studies on organic food were poorly conducted."}]'::jsonb, 'b', 'The writer contrasts consumer belief ("believe organic produce is healthier") with scientific findings ("no consistent evidence"). The implication is that the popular belief may not be backed by evidence — an inference the reader draws from the contrast. The writer does not say organic food is healthier (a), does not recommend stopping purchases (c), and does not criticise the studies (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92e972aa-3229-56ba-9929-47685626a17d', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"Despite initial **scepticism** from investors, the start-up secured three rounds of funding within eighteen months and expanded to twelve countries."

The word "scepticism" most likely means:', '[{"id":"a","text":"doubt and lack of confidence"},{"id":"b","text":"enthusiasm and support"},{"id":"c","text":"anger and hostility"},{"id":"d","text":"confusion and misunderstanding"}]'::jsonb, 'a', '"Despite" signals that the start-up succeeded in spite of the investors'' attitude — so their attitude was negative. "Scepticism" here means doubt or lack of confidence, which contrasts with the eventual success. Enthusiasm (b) would not need "despite", anger/hostility (c) is too strong and emotional, and confusion (d) does not fit the investor context of evaluating a business.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48924f7e-3bba-5f0c-ae13-2607f724a283', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"The government announced that patient waiting times had fallen. What it did not announce was that the figures excluded patients who had been removed from lists after failing to attend a single appointment — a group that had grown substantially that year."

What does the writer imply about the government''s announcement?', '[{"id":"a","text":"The government''s statistics were completely fabricated."},{"id":"b","text":"The improvement in waiting times was genuine and significant."},{"id":"c","text":"The figures were misleading because they omitted an important group."},{"id":"d","text":"Patients who missed appointments were treated unfairly."}]'::jsonb, 'c', 'The writer reveals that the figures excluded a growing group, implying the announced improvement was achieved partly by removing that group from the data rather than by actually treating more people faster. This is an implication of misleading statistics (c). The writer does not say the figures were invented (a — they may be technically accurate), does not confirm the improvement was genuine (b — in fact the opposite is implied), and does not comment on the fairness of the policy toward patients (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eeb3a38d-5f46-571f-8ca4-881687ae073d', 'c3207e20-7eb4-50bb-876c-aa0673fdb224', 'Read:
"The **proliferation** of social media platforms over the past fifteen years has transformed how people consume news, communicate with friends, and present themselves to the world."

The word "proliferation" most likely means:', '[{"id":"a","text":"decline and disappearance"},{"id":"b","text":"improvement in quality"},{"id":"c","text":"regulation and control"},{"id":"d","text":"rapid increase in number"}]'::jsonb, 'd', 'The sentence describes how platforms have "transformed" many aspects of life "over the past fifteen years" — suggesting a large-scale change driven by growth. "Proliferation" means a rapid increase in number, which fits a context where many new platforms emerged. Decline (a) is the opposite, quality improvement (b) is a different dimension, and regulation (c) contradicts the context of rapid, largely uncontrolled growth.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('99407e9d-709e-5fcc-bd4f-5e1470e979d2', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', '⚔️ Chapter Boss ⭐⭐⭐: Reading Comprehension: Argument and Inference', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b2e9ef7-fe1b-5bce-869c-c062531b9ee3', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"Remote work was once a privilege reserved for a fortunate few. The pandemic forced organisations worldwide to abandon that assumption overnight. What followed surprised even the most ardent sceptics: productivity held firm, collaboration adapted, and in many sectors, output actually increased. The office, it seems, was never quite as indispensable as its architects imagined."

What is the writer''s main argument?', '[{"id":"a","text":"Remote work proves that the traditional office is less necessary than believed."},{"id":"b","text":"The pandemic caused enormous disruption to the workplace."},{"id":"c","text":"Productivity always increases when people work from home."},{"id":"d","text":"Sceptics were right to doubt remote working."}]'::jsonb, 'a', 'The final sentence — "The office was never quite as indispensable as its architects imagined" — is the central claim the paragraph builds towards: the traditional office is less essential than assumed. The pandemic''s disruption (b) is context, not the argument. "Always increases" (c) overstates what the text says ("in many sectors", "actually increased"). The sceptics were proved wrong, not right (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac9770aa-2336-5634-9523-ccc7706567b4', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"The charity''s annual report celebrated a record year for donations. Buried on page 47, however, was a table showing that administrative costs had risen by 34% and that the proportion of funds reaching front-line services had fallen for the third consecutive year."

What does the writer imply?', '[{"id":"a","text":"The charity is fraudulent and should be investigated."},{"id":"b","text":"Record donations automatically improve front-line services."},{"id":"c","text":"The charity''s public messaging obscures a less favourable financial picture."},{"id":"d","text":"Administrative costs are unimportant compared to total donations."}]'::jsonb, 'c', 'The contrast between the celebrated headline (record donations) and the buried table (rising admin costs, falling proportion to services) implies the charity''s public face conceals a less flattering reality. The writer does not accuse the charity of fraud (a — this is an inference too far), does not suggest donations automatically help services (b — the text implies the opposite), and does not minimise admin costs (d — the detail about them rising is presented as significant).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14300102-b92d-569e-aa52-eb37143da473', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"A leading nutritionist recently declared sugar ''the tobacco of our time''. The comparison is **arresting** but imprecise: tobacco has no safe level of consumption and no nutritional value, whereas moderate sugar intake is both harmless and, for active individuals, necessary."

The word "arresting" most likely means:', '[{"id":"a","text":"legally problematic"},{"id":"b","text":"striking and attention-grabbing"},{"id":"c","text":"factually accurate"},{"id":"d","text":"deeply irresponsible"}]'::jsonb, 'b', 'The writer says the comparison is "arresting but imprecise" — acknowledging it has impact while pointing out it is inaccurate. "Arresting" here means striking or attention-grabbing (it catches your attention), not legally problematic (a — wrong register entirely), not accurate (c — the writer immediately calls it imprecise), and not irresponsible (d — the writer''s tone is analytical, not moral).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('133b0305-7d62-5eef-8f2b-dc8837216ef1', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"Tech companies insist their recommendation algorithms simply reflect what users want to see. What this framing conveniently omits is that users'' preferences were themselves shaped by years of exposure to those same algorithms. Calling the result ''user choice'' is a little like crediting a riverbank for the shape of the river."

What does the writer imply about the tech companies'' claim?', '[{"id":"a","text":"The claim is straightforwardly true."},{"id":"b","text":"The claim is circular: algorithms shaped the preferences they now claim to reflect."},{"id":"c","text":"Users genuinely prefer the content the algorithms select."},{"id":"d","text":"Rivers are a poor analogy for technology."}]'::jsonb, 'b', 'The writer argues that the companies'' claim is circular: they say they reflect user preferences, but those preferences were created by the algorithms in the first place. The river analogy makes this concrete — the riverbank shapes the river, then takes credit for the river''s shape. The claim is not straightforwardly true (a — the writer''s whole point is to challenge it), users do not "genuinely" prefer content in a free sense (c — their preferences were manufactured), and the writer endorses the river analogy rather than criticising it (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a944af9a-8ec5-5f4e-9521-d9b90d22c78b', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"Critics of standardised testing argue that it rewards rote memorisation over genuine understanding. Supporters counter that it provides a consistent, objective benchmark that reduces the influence of teacher bias. Both positions have merit. What neither camp adequately addresses is the question of what, precisely, education is for."

What is the writer''s implied criticism of the debate?', '[{"id":"a","text":"Standardised tests are clearly superior to teacher assessment."},{"id":"b","text":"Both sides in the debate miss the more fundamental question about the purpose of education."},{"id":"c","text":"Teacher bias is not a real problem in education."},{"id":"d","text":"Rote memorisation is an effective learning strategy."}]'::jsonb, 'b', 'The final sentence — "What neither camp adequately addresses is the question of what, precisely, education is for" — is the writer''s implicit criticism: both sides argue about method while ignoring the deeper question of purpose. The writer does not favour tests (a — "both positions have merit" is balanced), does not dismiss teacher bias (c — it is presented as a real concern), and does not endorse rote memorisation (d — it is mentioned as a criticism of tests).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c627902-1a5b-5733-ae67-c253a983de81', '99407e9d-709e-5fcc-bd4f-5e1470e979d2', 'Read:
"The study found that students who slept fewer than six hours performed significantly worse on memory tasks than those who slept eight hours. The researchers concluded that sleep deprivation impairs academic performance. Schools should therefore abolish early morning start times."

Which statement identifies a FACT in the passage?', '[{"id":"a","text":"Sleep deprivation impairs academic performance."},{"id":"b","text":"Schools should abolish early morning start times."},{"id":"c","text":"Early morning start times cause sleep deprivation."},{"id":"d","text":"Students sleeping under six hours performed worse on memory tasks than those sleeping eight hours."}]'::jsonb, 'd', '"Students who slept fewer than six hours performed significantly worse on memory tasks" is the directly measured, verifiable finding from the study — a fact. The conclusion that "sleep deprivation impairs academic performance" (a) is an interpretation of the data. "Schools should abolish early morning start times" (b) is a policy opinion. "Early morning start times cause sleep deprivation" (c) is an assumed causal link not established in the passage.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35c2571d-a904-519d-aca6-b1c9da067830', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', '👑 Elite Challenge ⭐⭐⭐⭐: Reading Comprehension: Argument and Inference', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9179122a-568c-5647-ba40-b02047f0f7a0', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"The city''s new museum attracted 400,000 visitors in its first year — a figure the mayor called ''proof that culture pays''. What the press release omitted was that the museum had spent £12 million on a marketing campaign targeting tourists, and that local residents, priced out by the £18 entry fee, accounted for fewer than 8% of visitors."

What does the writer imply about the mayor''s claim?', '[{"id":"a","text":"The visitor figures are inaccurate and were invented for political purposes."},{"id":"b","text":"The success was bought rather than organic, and excluded the local community it was meant to serve."},{"id":"c","text":"A £12 million marketing budget is always justified by high visitor numbers."},{"id":"d","text":"The mayor was correct: 400,000 visitors proves culture is financially viable."}]'::jsonb, 'b', 'The writer does not question the 400,000 figure — but reveals what it cost (a £12m campaign) and who it excluded (locals at 8%). The implication is that the "success" was manufactured by heavy spending and bypassed the community, undermining the mayor''s framing. The figures are not called inaccurate (a), the budget is presented as problematic not justified (c), and the writer clearly challenges the mayor''s conclusion (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cf7fc41-b616-51dc-beb1-bd4336a849ac', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"Automation, its champions tell us, will liberate workers from dangerous and repetitive tasks, freeing them for creative, fulfilling roles. History, however, has a habit of being less tidy than economic models. The textile workers of nineteenth-century England were not, in the main, redeployed as artists."

What does the writer imply by referring to nineteenth-century textile workers?', '[{"id":"a","text":"The nineteenth century is a perfect model for understanding modern automation."},{"id":"b","text":"Historical evidence suggests displaced workers do not automatically find better jobs."},{"id":"c","text":"Automation in the nineteenth century was more disruptive than today''s automation."},{"id":"d","text":"Artists benefit most from economic disruption."}]'::jsonb, 'b', 'The ironic remark — "were not, in the main, redeployed as artists" — implies that the optimistic promise of workers moving to creative roles did not materialise historically, casting doubt on whether it will this time. This is an inference: the writer does not say modern automation is identical to historical cases (a — history is invoked as a caution, not a perfect model), does not compare the degree of disruption (c), and says nothing about artists benefiting (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f92aaf-1fa8-540f-a29d-f3fe649a333c', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"The **equivocal** results of the trial left investors uncertain about the drug''s future. Some analysts argued the data warranted further study; others felt it was sufficient for regulatory approval."

The word "equivocal" most likely means:', '[{"id":"a","text":"ambiguous and open to different interpretations"},{"id":"b","text":"clearly positive and promising"},{"id":"c","text":"deliberately falsified"},{"id":"d","text":"highly technical and difficult to understand"}]'::jsonb, 'a', 'The results left investors "uncertain" and analysts split — some wanted more study, others thought the data was enough. This division shows the results could be read either way: ambiguous, or equivocal. Clearly positive results (b) would not leave analysts divided. Falsified (c) is not implied — the debate is about interpretation, not integrity. Technical difficulty (d) is a different reason for uncertainty not supported by the text.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('896659d6-5625-58e3-81b8-0472990c41bf', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"Commentators have praised the reform as bold and necessary. Bold it may be. Whether it is necessary depends entirely on what problem one believes the education system faces — and on that question, the commentators are conspicuously silent."

What is the writer''s implied criticism of the commentators?', '[{"id":"a","text":"They are paid by the government to support the reform."},{"id":"b","text":"They use the word ''bold'' incorrectly."},{"id":"c","text":"They endorse the reform without establishing what problem it is meant to solve."},{"id":"d","text":"They are too cautious in their praise of the reform."}]'::jsonb, 'c', 'The writer concedes "bold it may be" but says "necessary" depends on identifying the problem — and the commentators are "conspicuously silent" on that question. The implication is they have praised the solution without examining what it is a solution to. There is no suggestion of being paid (a), no claim of misusing "bold" (b), and the criticism is that they are too uncritical, not too cautious (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b732e761-a077-54b3-bf82-c01cd823722d', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"Reported crime fell for the fifth consecutive year, according to official police figures. Separately, the Crime Survey of England and Wales — which asks households directly about their experiences — recorded a 9% rise in incidents over the same period."

Which conclusion is best supported by BOTH sets of figures together?', '[{"id":"a","text":"Crime has fallen significantly over five years."},{"id":"b","text":"Police figures and victim surveys measure the same thing and produce consistent results."},{"id":"c","text":"The official police figures are fraudulent."},{"id":"d","text":"There is a discrepancy between reported crime and experienced crime, suggesting under-reporting to police."}]'::jsonb, 'd', 'Police figures record reported crime; the household survey records experienced crime. A fall in one and a rise in the other most logically implies that more crimes are occurring but fewer are being reported to police — under-reporting. Crime has not clearly fallen (a — one measure rose). The two measures produce contradictory, not consistent, results (b). The text gives no basis for calling the figures fraudulent (c — discrepancy has an innocent explanation).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94edd6f7-c45f-54ab-876c-bf610accee7f', '35c2571d-a904-519d-aca6-b1c9da067830', 'Read:
"The novelist''s latest work has been described by reviewers as ''challenging'', ''uncompromising'', and ''not for the casual reader''. Sales figures suggest these descriptions were accurate: the book sold 1,200 copies in its first three months — a fraction of her previous novel''s 85,000."

What tone does the writer adopt toward the novel''s commercial failure?', '[{"id":"a","text":"Openly dismissive of the novel''s literary quality"},{"id":"b","text":"Sympathetic and defensive of the author"},{"id":"c","text":"Drily ironic — presenting facts that speak for themselves"},{"id":"d","text":"Enthusiastic about the novel''s artistic ambition"}]'::jsonb, 'c', 'The writer quotes the reviews ("challenging", "uncompromising", "not for the casual reader") and then notes that the sales numbers confirmed these labels — letting the juxtaposition make the point without explicit comment. This is a dry, ironic tone: the facts are arranged to speak for themselves. The writer does not call the novel bad (a), does not defend the author (b), and does not praise the ambition (d) — the register is detached and wry.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1a5addba-96a4-5193-aaa9-873fa2d68182', '61e6d0ae-1f90-5d11-975f-2fbc00124c41', 'anglais-b2', '⭐⭐ Drill: Reading Comprehension', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6d4fbb6-a5b0-5345-b867-75447ca7da35', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage:
''Sleep researchers have long argued that teenagers need more sleep than adults, yet most secondary schools begin before 8 a.m. A recent trial in which start times were pushed back to 9 a.m. found that student attendance improved by 12%, exam scores rose in every subject measured, and reports of anxiety and depression fell significantly. The findings were described by the lead researcher as "striking". The Department of Education said it would "take note".

What is the writer''s MAIN ARGUMENT?', '[{"id":"a","text":"Teenagers are lazier than adults and need more sleep as a result."},{"id":"b","text":"The evidence strongly supports later school start times, but the government response is non-committal."},{"id":"c","text":"Sleep researchers are more reliable than government officials."},{"id":"d","text":"Exam scores are the most important measure of a school''s success."}]'::jsonb, 'b', 'The passage presents compelling trial evidence (attendance, scores, wellbeing all improved) and then contrasts it with a lukewarm government response (''take note''). The main argument is that the evidence backs later start times but the authorities are not acting on it decisively. The text does not say teenagers are lazy (that is a distorted reading), does not compare the reliability of researchers versus officials, and does not rank exam scores above other outcomes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ddf6173-9491-5213-a5ea-8b55c7da9159', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage again:
''Sleep researchers have long argued that teenagers need more sleep than adults, yet most secondary schools begin before 8 a.m. A recent trial in which start times were pushed back to 9 a.m. found that student attendance improved by 12%, exam scores rose in every subject measured, and reports of anxiety and depression fell significantly. The findings were described by the lead researcher as "striking". The Department of Education said it would "take note".

What does ''take note'' most likely IMPLY in this context?', '[{"id":"a","text":"The government is expressing polite acknowledgement without committing to action."},{"id":"b","text":"The government will study the findings in detail before making any decision."},{"id":"c","text":"The government plans to implement the findings nationwide immediately."},{"id":"d","text":"The government strongly endorses the research conclusions."}]'::jsonb, 'a', 'In political and official language, ''take note'' is a classic non-committal phrase — it acknowledges something without promising action. Placed directly after ''striking'' findings, the contrast implies the government is being evasive. ''Implement immediately'' (option A) is far too strong a reading. ''Study in detail'' (option B) reads more into the phrase than is stated. ''Strongly endorses'' (option D) contradicts the cautious, minimal phrasing.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3695354e-43d8-5d7c-9c2f-668639431057', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage:
''The forest cover of the region had declined by 40% over the previous two decades, yet local wildlife populations remained relatively stable. Conservation groups pointed to the network of wildlife corridors — narrow strips of protected vegetation linking isolated forest patches — as the likely explanation. Critics, however, noted that the corridors had only been in place for five years, and questioned whether they could account for a trend spanning twenty years.

What does the writer IMPLY about the conservation groups'' explanation?', '[{"id":"a","text":"The wildlife corridor explanation is definitely correct."},{"id":"b","text":"The wildlife corridors have been a complete failure."},{"id":"c","text":"The explanation is plausible but may not fully account for the long-term trend."},{"id":"d","text":"Wildlife populations have not actually remained stable."}]'::jsonb, 'c', 'The writer presents the conservation groups'' explanation and then immediately adds the critics'' challenge: corridors have only been in place five years but the stable trend spans twenty years — an obvious mismatch. This implies the corridor explanation is incomplete or uncertain. The writer does not confirm the explanation is correct (the word ''likely'' already hedges it), does not say corridors have failed, and does not question the stability of wildlife populations — that fact is stated as given.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4122eb41-2e19-5773-8a3a-d3a04d761fd5', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage:
''The **precipitous** decline in insect populations recorded across Western Europe over the past three decades has alarmed ecologists. Insects underpin almost every terrestrial food chain, pollinate the majority of flowering plants, and decompose organic matter at a rate that no human technology can replicate.

The word ''precipitous'' most likely means:', '[{"id":"a","text":"gradual and barely noticeable"},{"id":"b","text":"steep and dramatic"},{"id":"c","text":"carefully studied and measured"},{"id":"d","text":"recently discovered and surprising"}]'::jsonb, 'b', 'The sentence says the decline has ''alarmed ecologists'' — a strong emotional response suggesting the change is serious. ''Precipitous'' derives from ''precipice'' (a steep cliff) and means abrupt or steep. A gradual, barely noticeable decline (option A) would not alarm anyone. ''Carefully studied'' (option C) and ''recently discovered'' (option D) describe the research process, not the nature of the decline itself.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f1b77b3-1708-5928-bb46-24d44bf4d8c8', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage:
''The council''s report praised the new transport scheme as "transformative" and cited a 15% reduction in peak-hour car journeys. What the executive summary omitted was that the data was collected during a period when two major roads were closed for resurfacing, meaning many drivers had been forced off their usual routes regardless of the new scheme. A footnote on page 63 acknowledged this limitation.

Which conclusion is BEST supported by both pieces of information?', '[{"id":"a","text":"The transport scheme has definitely reduced car journeys by 15%."},{"id":"b","text":"The council deliberately falsified the 15% figure."},{"id":"c","text":"Page 63 footnotes are the most reliable part of any council report."},{"id":"d","text":"The 15% reduction may be partly or wholly due to the road closures rather than the scheme."}]'::jsonb, 'd', 'The writer reveals a confounding factor (road closures) that could explain the reduced car journeys independently of the scheme. This casts doubt on attributing the 15% reduction to the scheme alone. The writer does not say the scheme definitely worked (option A — the confounding factor undermines this). The writer does not accuse the council of deliberate falsification (option B — the limitation was acknowledged in a footnote, just buried). Option D is an absurd generalisation not implied by the text.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c140cea-a6de-5cdb-ae80-5a7ee79760ad', '1a5addba-96a4-5193-aaa9-873fa2d68182', 'Read the passage:
''Philosophers have debated the nature of happiness for millennia. The ancient Greek concept of eudaimonia — often translated as "flourishing" — differs fundamentally from modern hedonic theories that equate happiness with pleasure and the absence of pain. For Aristotle, happiness was not a feeling but an activity: living and faring well, exercised over a complete life. Whether this distinction has any practical relevance in an age of antidepressants and self-help apps remains, to say the least, an open question.

What is the writer''s TONE in the final sentence?', '[{"id":"a","text":"Enthusiastic about the practical applications of Aristotle''s philosophy"},{"id":"b","text":"Dismissive of ancient philosophy as irrelevant"},{"id":"c","text":"Drily sceptical — gently questioning whether ancient ideas translate into modern life"},{"id":"d","text":"Hostile toward modern medicine and self-help culture"}]'::jsonb, 'c', 'The phrase ''to say the least, an open question'' is understatement used for ironic effect — the writer implies the practical relevance is far from obvious without dismissing ancient philosophy or attacking modern approaches. This is a dry, gently sceptical tone. ''Enthusiastic'' (option A) would require positive evaluative language, not cautious hedging. ''Dismissive'' (option B) overstates the critique — the writer presents both frameworks respectfully. ''Hostile toward modern medicine'' (option D) reads far too much aggression into a measured, understated observation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

