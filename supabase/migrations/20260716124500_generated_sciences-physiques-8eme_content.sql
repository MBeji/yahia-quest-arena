-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: sciences-physiques-8eme (العلوم الفيزيائية)
-- Regenerate with: npm run content:build
-- Source of truth: content/sciences-physiques-8eme/
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
  ('sciences-physiques-8eme', 'العلوم الفيزيائية', 'الخلائط والذوبان والكتلة الحجمية والدارة الكهربائية والتيار والتوتّر وفق برنامج السنة الثامنة من التعليم الأساسي', 'Observation', 'subject-svt', 'Atom', 4, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '8eme-base'))
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
      AND e.subject_id = 'sciences-physiques-8eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('92d2d0c9-9e2f-59f1-b4c5-25d4c87a350d', 'ef121adf-facc-5c57-bf1d-0d790967bed6', '6b3ae64c-17ba-55ad-bb9c-debccf317819', '6143b8f2-695a-5943-a326-804ad37bfa5a', '5c3adcb5-8444-5204-9cc0-709403bee79e', 'b7b15f39-5ad5-560b-a97d-d48ca1ed9bb8', '2a847e44-2edd-5c07-abb0-e027eaa9245a', 'f7a8007a-0a1b-5dd4-b7c1-8c779deca5c8', '11c5289a-2979-59b0-9c63-55ceb3b483fb', '2402e398-2947-5e15-a5f3-548070c9f966', '6bf4c3c9-2c25-5cb2-aa04-bc9efeb7af3c', '344bea5f-a3a7-5cc7-b235-02e6910f9916', '57e893d3-dc0c-562d-b8dc-945ad697a14c', '12cd22d8-2793-5cda-8053-d2dfd0a25557', '7d979e72-dd3e-5f2a-aedb-aea243e04f3f', '1c2b1c7a-dd06-5921-bbee-9b4c6b684ad3', 'a4655089-78b1-5da1-b0df-d4ea21b17f3b', '391f5a09-0936-59cc-a2c3-7cf8dafdca54', '7f0032aa-3294-5091-9fe8-715a6cd41f85', '4ee85a30-742b-561c-b968-3e3495c56ea4', 'a073a6c8-1544-5915-bb01-162cd6598de8', 'e78bf373-908f-5a12-9b96-38867e1eef9e', '25b27d8e-ff9b-52e2-b21e-e58124a1a4dd', 'cad56b6d-59cf-5ad0-aea1-e6f96d2d67f0', '8f22107e-5463-51c4-9cb8-012dad188be3', 'dac99671-31c7-54fe-8ea8-79149e37089a', 'e7430c4d-8abf-520b-84d9-0cf136b92d96', 'fc04d886-30c9-5b44-a069-614b1c5ac8c0', '39baa053-4eeb-5ac8-acae-56444baf014e', 'f824fa16-d54d-5e4e-8f8f-0d06c60a9642', 'f6d7c321-d555-5635-9c2d-e9c24ff068c2', '87e23db1-1297-5357-bf4b-491a24544df1', 'f90ac73d-eff0-5aab-a1ca-722b2022b3e0', '2448311e-082b-5bfa-bee1-43282032d170', 'fd9cb7dd-fadd-5d96-9afc-0c4d2836f7a6', '625cd172-603d-5904-9ba4-b62754435bf9', '459f5c71-c69a-540c-a204-c3c3ac71612b', '23a0b4f5-8f0f-5419-af9e-5b6a2f18f60d', '11ee4fbb-db6f-5ce7-925b-305f2e166316', 'a0d28a2b-8cc4-5abf-a509-b7af2935f479', '1529c04e-4624-57ab-9fd8-5ca9c88b402e', '6935914b-5a5a-526f-84d4-cf17068c4db5', '28a766b9-e129-5660-a535-f32de7cd0585', '776e7506-6fcd-57af-9e71-a311726140f9', '0e89a901-8f89-569f-ad75-d92529853565', '020773d0-7bee-5580-b77f-82f5acc31887', '07bdac97-a25b-5055-9516-e439873fd90b', '70e355d3-bf51-5488-a04d-f979e3ade1c3', 'b13a1a8a-314f-5bf7-bf0c-f88d71b94195', '941bdbf8-0d16-524c-b062-0c95d5e16744', '24e261a9-d494-59b1-876d-818ef4938aee', 'a000b83d-6c3e-5267-a244-bc5d3ec667e0', '9dc0eca9-3a8c-53cb-8662-866e8064a558', 'dddf2d7c-63e9-5ef3-a11e-0fac32a166f3', '498cde4f-508a-598a-b0af-e441dba207a7', '8d7f02d0-ef2c-5686-b05e-a84b787878ab', '6c23180b-e37b-51ee-8aca-f32a6d13ea88', 'c0c7bd99-28f4-53af-a9ab-58b5a37a49e0', 'f40c41a7-79c9-55a7-ac9c-209723731667', '7538d4ed-478d-573f-bb59-df41793a4d91', '9767a970-8040-5d5f-a7dc-cabacc99d548', 'c7704e6e-60c4-562a-af47-b655d6777798', '12c9283a-0e88-560e-ab5d-fd3409c283d5', '252ec7bb-a89e-5ba3-ab53-505955993cb8', 'e1cc3e46-8cdb-59de-af12-28aefddaff75', '6c6e7d2f-6ff3-5f4f-89d3-89b846617eb3', '76ace142-02e5-55aa-9468-8e6850185c19', 'db8d9f46-6b54-5238-9665-1d69daff3c77', '8149c9f5-5643-51b6-89cd-71477e309f37', '49095db0-9260-58a2-b3ae-8cd1faa75b57', '64924cd7-82e7-5e3a-ab77-6a372e74d6cf', 'd36c8cd5-2df1-59d8-b7c2-34ff01eb1684', '1c6695c7-08e8-59d7-b43e-2613f05e0f3e', 'db839e05-c7ca-5d03-8f22-c43563c748d2', 'bb9d3b5d-6cf4-52aa-be4b-ac76464242da', '7640b699-5b98-5309-9d39-6c20848a7c3f', '12c06678-7230-5c95-94e1-f1a6ea26bd98', '07006037-4438-5c0b-8029-ed3436ba8b7f', 'af910b24-9ecb-58c5-bcc4-3ca17b8b8858', '8bdbc008-2952-51d1-aecd-86f037575f6c', 'acc1529d-7a32-52b9-bf68-64a28c9f0057', 'e85ca1fe-224d-548f-95db-84583779f7ff', '0bde65de-0988-5b61-9d9c-5836202eaed8', '873226e1-fb3d-5c7c-a880-0c7ab04607c1', 'b6f3e895-7b43-5493-9105-2f71093dfc85', '77af8d7e-371d-580e-b8e2-e37e07040598', '620e72f4-d3d3-5d30-963b-d1c02bfe3807', '842cbf11-8eb2-5e0e-8aea-fc41e523f516', 'a92ae904-9560-5aa8-afbe-7f6355681b81', '2c292172-c3e9-5e2e-b0a0-842d9e4dc728', '412951c8-1e1b-5bdf-8098-31ef94f82dcb', '8df39f3f-1bfe-5e02-b76b-d47bbc4f45c4', '133790bb-772b-5e35-bade-cd16ef09121c', 'fb41b9f6-144b-51f5-9ebf-5b9e8252548f', '4bd9d48b-dc39-5060-9379-7114100efd8c', '5a13c6c8-120c-5f60-8873-75ad70591caf', '102dc1f3-d7b7-5be3-a84e-6210666a2524', 'fd2c873d-3efa-5152-9428-bc43f56776c9', '0241bd0e-8185-5d7b-86b8-533a2b9e8270', 'fc862229-f738-5939-8684-b1c1b2069b29', '650a7239-f331-51fa-9e34-32ffed907b29', '7e0394c6-f8d8-5be8-8acd-aca9088f34b7', '31cb9e0a-2b13-517d-b7f0-9272f2132429', '62905467-484e-5df0-a386-0826be46127f', 'bf26d0a7-d129-5676-b618-ae43a243961f', '1b32af39-9823-5a51-99c4-8fc096d0c78f', '5942ea1b-5aca-5853-8208-47ddde86183a', '96554ca5-c4fe-5e3c-9420-75bc70b96878', '7ca0d54a-fc96-57c1-9354-399b8a013964', 'dbdfe332-14c6-5647-93dd-731049981f4f', 'b8c2789d-fc0d-5c4e-870c-f64615ac583c', '57fba02d-8ab7-51e3-bf84-3cecbfa128b4', '253e4efa-383f-5e13-a984-8adeb1f3a4c5', '10b10e38-6e87-5410-9746-351d17e5ad34', 'f927dc22-31e4-5d0c-a788-14ef07429cdc', '8f197ba9-afb7-563d-a438-6a2882dd72ca', '4bce9599-314c-5f32-9c0e-5b8f7be11244', 'af653de9-33ac-5907-906b-f5dee8afcee3', '61c036b0-210f-506c-82dd-1adacf13e97c', 'c291c0c4-e037-5732-a3f8-09d73d5d2db8', '168b00f3-0145-5bbf-a5f5-1f50bf2a5534', '8fba674b-e01f-54c5-a124-2fb62ca9a920', '1ddecf43-395e-52bb-b923-89182b78e477', 'a50a1c2b-4681-551a-94ee-7c130243fba3', 'f8022285-128f-5e7f-8595-98d95af75ebb', 'cd1e8e59-dd67-538d-98c3-2638008ff68c', '266710e1-5c1f-5ffc-bb1d-f4db1787b43b', 'bcf1be1b-2e12-59c3-b8da-9b1937ea64dd', 'fc191a28-350f-5797-91b0-dc17fc2bef70', '895f2579-d977-562d-9a45-e242b6d37fb9', '86d09f02-4936-584b-b703-6ef2b2636c10', '98a6eb19-114e-5464-990d-079a750dcfc6', '3dadbec2-5efa-5ddb-a306-2b05e0cf6083', 'a9f19831-ac0b-59a1-aad0-3be3405e7bf1', '10a19083-6cba-5056-b5f7-3c06ac8405fe', '553f23d2-3f1a-5a6f-a385-fdd8efd903e0', '63a7816d-5637-5a8d-b202-1f0291b945f3', '4b6ec99c-3f48-513f-a532-8b9cfc91ef71', '9b355ce8-ccb7-5d4d-849f-5c2df0e599f2', 'e98cb802-4d13-5c59-9a57-a1d4622d5c83', '6e5409f2-f31e-54ce-9665-3a1c0e513b9d', '76d21ed2-8667-50da-8709-fbb6773f23a1', '8234c0f0-1eb7-5bca-85dd-ac93f5915741', '614f929c-cbbb-5cbc-8750-ee202eb86956', 'fc0e0d5c-95c6-57a4-ad40-95c3cd0cef49', '08f73ec8-f95b-5f30-a510-1eda3a29c5cc', '5d60f279-3f7d-54f8-b30c-22bb1e9c5348', 'ffee084f-1a4c-57e5-889c-d5a95984cdcd', 'e5f3078b-ed63-55e8-9ee9-1a6cf389f9e0', '002a64bc-7c4f-5fa4-bdb2-3dc63c168176', '92a509e3-d02f-57ad-897c-9a16e44189a3', 'f6694c76-3b63-5897-91e1-955238e323a2', 'a48e74cc-d57a-5e1e-8730-6668d8baf236', '781ba196-7c93-52e4-a207-f479e8cf1c53', '00b18781-2f37-553d-b07c-b0270412011e', '7a87cda9-e3b8-57d9-9b3c-4cf477794e51', 'a6836676-f716-540b-880e-4fec2a8a4aae', 'c8be1a71-1acc-5897-bfc2-545904cd8615', 'f12c62f6-4e21-5699-aed6-c734c7aa357d', '646ef569-e6d1-5168-b9c7-ea34b045aa6a', '2781e798-8fdb-5224-98df-7b581fb86c58', '6da31707-ed07-5129-b890-cf159165f4c7', '8ec10b45-5e16-5f52-a45d-74b2afdba4ab', '943d7d36-dbfa-5efd-9274-afd555c5baf8', '981fc3ce-7139-57a2-b646-4c21c827b2a3', '11d3a0ba-175f-544c-b2f1-3c2c69cace19', '231ac4f6-d58f-55fc-b2ed-28654b25a452', 'a69bea1b-6e9b-557f-9380-07194fa14b03', '28486cbc-7317-505d-9110-2c54ce7b95da', '9e8def54-2d94-537d-ba9c-9e174c3148ca', 'f0c4a753-1567-5ade-847d-8331025a2a0e', '401b0318-9356-5252-a4ad-093fc54e9f4b', 'dd294748-e29f-5453-8649-c6d586e6127d', '67a24a8b-f305-57f8-a3ee-ad188f275cd1', 'b4393e85-f78a-5de0-814d-ea47ac08f07c', '21626603-3fa2-5c97-bc2b-0519be4d35f1', 'e47f397b-b58d-52e5-935d-f9315dbf2c70', '51ae34f7-f5e3-54b9-88f8-0f5f4dcbd400', 'e37d8068-2243-5989-a73e-e1be4f55c9a0', 'ff9e8f56-a310-5879-bed2-c0bbbb069b81', 'dc306be7-0210-5a46-90a0-f32c11c2a22c', '83544320-e797-5ded-8991-6862e088ac2c', '67706db9-c346-5641-b87c-b9ff1d33a68c', '6a7962eb-b1c0-5c1c-b8b0-f02a45b5a5eb', '380a3f96-aac2-584c-9c0b-a623b523ed60', '2335cada-9e64-53d5-9d06-cbff2051e9c2', 'e344fa6d-31a1-5e3c-b0f0-a9c72751fc9a', 'cd0d1195-fbe4-5248-8173-912f6788e3af', '6b892166-ee0a-5f15-8fac-62db7b96f65b', 'f0159069-2b29-5857-b9ad-ba0205ceb0d4', 'f5fef651-89a4-5704-bba9-e5bf3cc42b87', 'c85fd007-93cc-5a95-a0f4-35ee95e1e5ff', '7ff7822c-3558-583b-91cd-14b7d2de349b', '57d1d739-6285-5798-8ca2-1f3d36be811b', '01ebf836-3636-57ab-b737-e8143b0b0026', 'b66485be-fedc-5f46-acd6-2c081af1c95b', '1ee3cafa-014e-5894-8e47-c47c3a41e5ef', 'e6cd7c28-c6cc-5dd6-ac90-1ffad838d8a1', '404fadbb-a4db-50b3-ad47-f0e0ed20ffea', '68534bc2-8ed4-5bfa-8396-46ef25d49379', '9ef39aa6-1d67-5301-b0e3-7fefc8080fcd', 'ca5247b2-d960-5455-aa30-889cc53cde2d', '28835fa8-35e9-5144-92ca-0ef9b61cff56', 'd72540ca-2359-5366-85c8-e1254adca984', '62319a38-64b6-540b-a566-19c9e94473c0', '93011218-bb20-56b3-aedd-5488272b8df5', '13e45d71-984a-5f78-a42f-11bcc10665c0', '0b1858bb-480a-570a-b31b-48dd9ead6525', 'bb032b17-6311-5472-b8ea-6c5a0272fa60', 'ff42a681-8223-59e6-9327-87b4d0ea972d', 'eaf884b8-2fd0-57cc-9225-758559f79e7a', '655c8280-3f65-5cd2-96a8-50625061be62', 'b6c68624-bd0c-56a7-a83d-99fa99691468', 'dc6e636f-c8f6-568d-9b1b-0733076cc23d', '5e8612c7-49aa-5779-89f5-1f70cc138e26', 'c92113ce-ba70-5329-a5e3-bff12dedf092', 'ea343d3b-73b3-52f4-b41c-3dffe5a52ed0', 'de45771e-48be-5845-b61c-381011e94faf', 'b5425926-b287-5877-873d-47062066e50d', '1b8f5b05-ffc3-55e3-9228-aa4c871ae18e', 'd5d44f27-b37d-5476-8bd6-409f3e7623f0', '7b2b30b6-8d54-548c-a175-fb898d361371', '226e84e8-26ce-5ea4-816b-4e6d2e114e8a', '3de319e6-1625-53cd-8c41-9e12738d7711', 'de45ea72-709a-50d3-afca-89ec774455ad', '75481405-1d91-50ac-b5bd-ba608e701122', 'dfa5555e-66c0-57f1-9f1e-348e47f18977', 'ceb76991-d3c9-55e8-879a-a2574ae83353', '380ebfab-f0c5-5f6f-9165-3193b0f3b8d7', '5d6b96d6-87bd-58a7-936c-922965e929cd', 'e1efa255-c9b6-5f28-b879-9894f148605a', '3b096c27-d89c-5b3c-8fc6-f198ad8195cc', '598fe436-ee3e-59e6-978b-987291208c3d', '7a6075c9-f142-50d4-9edd-8a0b2bc29f87', '5dd0313a-af21-5942-86b5-c72af132785d', '7ab11d45-39d9-548f-ac77-f009eb8409eb', '34c28d42-a214-5aba-abb3-c4014731b4b0', '0d487d56-1d9f-5e95-b2d7-16d2be004253', '234f57d4-4784-53a3-af91-5c75bf7857ea', '7edcefca-2b92-5062-9583-058ca7ea0657', '90727243-3522-5a56-b84a-7440ceef20fc', '51bbaf04-c17f-54a0-96b9-f481f0da1d98', 'd0bb6f39-1caa-58c0-9b93-fa07a2427c3c', '3d94fc18-a0d4-5248-bdc0-32b9f0527b96', 'c5f80086-dd58-5f6a-9c54-0d907e854459', '7cbe491f-d5f9-5865-8b70-ffe0920de9f7');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'sciences-physiques-8eme' AND source = 'admin' AND id NOT IN ('149ff0b0-1897-54bd-ba40-c6a6b26c8655', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'e13d7a29-84cc-5363-a046-b776d28bad6d', '9dea259c-cb54-52b9-9170-0dfc904e28bf', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', '40b32f15-0662-5e43-bcac-5230ce75474a', 'e1693509-033d-5e75-abe6-fddbd39a7103', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', '43e62201-c1fd-557c-95be-8360c855b0f8', '336c59e7-ade7-5ce9-a32c-66ef35321194', '0f13b6c8-9891-5c2b-8604-008b188405c2', '712a6d00-2946-5c71-8a22-8c41eb980c61', '6e0fd560-ecfd-551e-8341-f2bc601488bb', '660e79bd-5b7c-556f-aec4-db848c35e854', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', '639329d4-932e-54ad-881b-9700d5bd3790', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', '40d77d53-30ce-54a0-ac62-242df9edfa69', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', '3aa750a3-e085-512c-af1e-00573ae9b8f2', '70946f62-dfe4-50c4-bc18-420950be7f1a', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', '16442953-9c4b-5c71-b160-33c82e680c6a', '80eb7153-04ea-50ca-9e89-7fd6343a4048', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'f2c69168-2631-575a-8c53-a077ade8ac39', '069f92c3-acce-5a32-9906-4bba512e1479', 'b10099c5-70b1-51c4-bced-13e914936a28', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'dec94a5b-949d-527e-8a07-6272b058c4f9', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'eb085b0e-3166-59c3-9e33-c4ef45e97440');
DELETE FROM public.questions WHERE exercise_id IN ('149ff0b0-1897-54bd-ba40-c6a6b26c8655', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'e13d7a29-84cc-5363-a046-b776d28bad6d', '9dea259c-cb54-52b9-9170-0dfc904e28bf', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', '40b32f15-0662-5e43-bcac-5230ce75474a', 'e1693509-033d-5e75-abe6-fddbd39a7103', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', '43e62201-c1fd-557c-95be-8360c855b0f8', '336c59e7-ade7-5ce9-a32c-66ef35321194', '0f13b6c8-9891-5c2b-8604-008b188405c2', '712a6d00-2946-5c71-8a22-8c41eb980c61', '6e0fd560-ecfd-551e-8341-f2bc601488bb', '660e79bd-5b7c-556f-aec4-db848c35e854', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', '639329d4-932e-54ad-881b-9700d5bd3790', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', '40d77d53-30ce-54a0-ac62-242df9edfa69', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', '3aa750a3-e085-512c-af1e-00573ae9b8f2', '70946f62-dfe4-50c4-bc18-420950be7f1a', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', '16442953-9c4b-5c71-b160-33c82e680c6a', '80eb7153-04ea-50ca-9e89-7fd6343a4048', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'f2c69168-2631-575a-8c53-a077ade8ac39', '069f92c3-acce-5a32-9906-4bba512e1479', 'b10099c5-70b1-51c4-bced-13e914936a28', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'dec94a5b-949d-527e-8a07-6272b058c4f9', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'eb085b0e-3166-59c3-9e33-c4ef45e97440') AND id NOT IN ('92d2d0c9-9e2f-59f1-b4c5-25d4c87a350d', 'ef121adf-facc-5c57-bf1d-0d790967bed6', '6b3ae64c-17ba-55ad-bb9c-debccf317819', '6143b8f2-695a-5943-a326-804ad37bfa5a', '5c3adcb5-8444-5204-9cc0-709403bee79e', 'b7b15f39-5ad5-560b-a97d-d48ca1ed9bb8', '2a847e44-2edd-5c07-abb0-e027eaa9245a', 'f7a8007a-0a1b-5dd4-b7c1-8c779deca5c8', '11c5289a-2979-59b0-9c63-55ceb3b483fb', '2402e398-2947-5e15-a5f3-548070c9f966', '6bf4c3c9-2c25-5cb2-aa04-bc9efeb7af3c', '344bea5f-a3a7-5cc7-b235-02e6910f9916', '57e893d3-dc0c-562d-b8dc-945ad697a14c', '12cd22d8-2793-5cda-8053-d2dfd0a25557', '7d979e72-dd3e-5f2a-aedb-aea243e04f3f', '1c2b1c7a-dd06-5921-bbee-9b4c6b684ad3', 'a4655089-78b1-5da1-b0df-d4ea21b17f3b', '391f5a09-0936-59cc-a2c3-7cf8dafdca54', '7f0032aa-3294-5091-9fe8-715a6cd41f85', '4ee85a30-742b-561c-b968-3e3495c56ea4', 'a073a6c8-1544-5915-bb01-162cd6598de8', 'e78bf373-908f-5a12-9b96-38867e1eef9e', '25b27d8e-ff9b-52e2-b21e-e58124a1a4dd', 'cad56b6d-59cf-5ad0-aea1-e6f96d2d67f0', '8f22107e-5463-51c4-9cb8-012dad188be3', 'dac99671-31c7-54fe-8ea8-79149e37089a', 'e7430c4d-8abf-520b-84d9-0cf136b92d96', 'fc04d886-30c9-5b44-a069-614b1c5ac8c0', '39baa053-4eeb-5ac8-acae-56444baf014e', 'f824fa16-d54d-5e4e-8f8f-0d06c60a9642', 'f6d7c321-d555-5635-9c2d-e9c24ff068c2', '87e23db1-1297-5357-bf4b-491a24544df1', 'f90ac73d-eff0-5aab-a1ca-722b2022b3e0', '2448311e-082b-5bfa-bee1-43282032d170', 'fd9cb7dd-fadd-5d96-9afc-0c4d2836f7a6', '625cd172-603d-5904-9ba4-b62754435bf9', '459f5c71-c69a-540c-a204-c3c3ac71612b', '23a0b4f5-8f0f-5419-af9e-5b6a2f18f60d', '11ee4fbb-db6f-5ce7-925b-305f2e166316', 'a0d28a2b-8cc4-5abf-a509-b7af2935f479', '1529c04e-4624-57ab-9fd8-5ca9c88b402e', '6935914b-5a5a-526f-84d4-cf17068c4db5', '28a766b9-e129-5660-a535-f32de7cd0585', '776e7506-6fcd-57af-9e71-a311726140f9', '0e89a901-8f89-569f-ad75-d92529853565', '020773d0-7bee-5580-b77f-82f5acc31887', '07bdac97-a25b-5055-9516-e439873fd90b', '70e355d3-bf51-5488-a04d-f979e3ade1c3', 'b13a1a8a-314f-5bf7-bf0c-f88d71b94195', '941bdbf8-0d16-524c-b062-0c95d5e16744', '24e261a9-d494-59b1-876d-818ef4938aee', 'a000b83d-6c3e-5267-a244-bc5d3ec667e0', '9dc0eca9-3a8c-53cb-8662-866e8064a558', 'dddf2d7c-63e9-5ef3-a11e-0fac32a166f3', '498cde4f-508a-598a-b0af-e441dba207a7', '8d7f02d0-ef2c-5686-b05e-a84b787878ab', '6c23180b-e37b-51ee-8aca-f32a6d13ea88', 'c0c7bd99-28f4-53af-a9ab-58b5a37a49e0', 'f40c41a7-79c9-55a7-ac9c-209723731667', '7538d4ed-478d-573f-bb59-df41793a4d91', '9767a970-8040-5d5f-a7dc-cabacc99d548', 'c7704e6e-60c4-562a-af47-b655d6777798', '12c9283a-0e88-560e-ab5d-fd3409c283d5', '252ec7bb-a89e-5ba3-ab53-505955993cb8', 'e1cc3e46-8cdb-59de-af12-28aefddaff75', '6c6e7d2f-6ff3-5f4f-89d3-89b846617eb3', '76ace142-02e5-55aa-9468-8e6850185c19', 'db8d9f46-6b54-5238-9665-1d69daff3c77', '8149c9f5-5643-51b6-89cd-71477e309f37', '49095db0-9260-58a2-b3ae-8cd1faa75b57', '64924cd7-82e7-5e3a-ab77-6a372e74d6cf', 'd36c8cd5-2df1-59d8-b7c2-34ff01eb1684', '1c6695c7-08e8-59d7-b43e-2613f05e0f3e', 'db839e05-c7ca-5d03-8f22-c43563c748d2', 'bb9d3b5d-6cf4-52aa-be4b-ac76464242da', '7640b699-5b98-5309-9d39-6c20848a7c3f', '12c06678-7230-5c95-94e1-f1a6ea26bd98', '07006037-4438-5c0b-8029-ed3436ba8b7f', 'af910b24-9ecb-58c5-bcc4-3ca17b8b8858', '8bdbc008-2952-51d1-aecd-86f037575f6c', 'acc1529d-7a32-52b9-bf68-64a28c9f0057', 'e85ca1fe-224d-548f-95db-84583779f7ff', '0bde65de-0988-5b61-9d9c-5836202eaed8', '873226e1-fb3d-5c7c-a880-0c7ab04607c1', 'b6f3e895-7b43-5493-9105-2f71093dfc85', '77af8d7e-371d-580e-b8e2-e37e07040598', '620e72f4-d3d3-5d30-963b-d1c02bfe3807', '842cbf11-8eb2-5e0e-8aea-fc41e523f516', 'a92ae904-9560-5aa8-afbe-7f6355681b81', '2c292172-c3e9-5e2e-b0a0-842d9e4dc728', '412951c8-1e1b-5bdf-8098-31ef94f82dcb', '8df39f3f-1bfe-5e02-b76b-d47bbc4f45c4', '133790bb-772b-5e35-bade-cd16ef09121c', 'fb41b9f6-144b-51f5-9ebf-5b9e8252548f', '4bd9d48b-dc39-5060-9379-7114100efd8c', '5a13c6c8-120c-5f60-8873-75ad70591caf', '102dc1f3-d7b7-5be3-a84e-6210666a2524', 'fd2c873d-3efa-5152-9428-bc43f56776c9', '0241bd0e-8185-5d7b-86b8-533a2b9e8270', 'fc862229-f738-5939-8684-b1c1b2069b29', '650a7239-f331-51fa-9e34-32ffed907b29', '7e0394c6-f8d8-5be8-8acd-aca9088f34b7', '31cb9e0a-2b13-517d-b7f0-9272f2132429', '62905467-484e-5df0-a386-0826be46127f', 'bf26d0a7-d129-5676-b618-ae43a243961f', '1b32af39-9823-5a51-99c4-8fc096d0c78f', '5942ea1b-5aca-5853-8208-47ddde86183a', '96554ca5-c4fe-5e3c-9420-75bc70b96878', '7ca0d54a-fc96-57c1-9354-399b8a013964', 'dbdfe332-14c6-5647-93dd-731049981f4f', 'b8c2789d-fc0d-5c4e-870c-f64615ac583c', '57fba02d-8ab7-51e3-bf84-3cecbfa128b4', '253e4efa-383f-5e13-a984-8adeb1f3a4c5', '10b10e38-6e87-5410-9746-351d17e5ad34', 'f927dc22-31e4-5d0c-a788-14ef07429cdc', '8f197ba9-afb7-563d-a438-6a2882dd72ca', '4bce9599-314c-5f32-9c0e-5b8f7be11244', 'af653de9-33ac-5907-906b-f5dee8afcee3', '61c036b0-210f-506c-82dd-1adacf13e97c', 'c291c0c4-e037-5732-a3f8-09d73d5d2db8', '168b00f3-0145-5bbf-a5f5-1f50bf2a5534', '8fba674b-e01f-54c5-a124-2fb62ca9a920', '1ddecf43-395e-52bb-b923-89182b78e477', 'a50a1c2b-4681-551a-94ee-7c130243fba3', 'f8022285-128f-5e7f-8595-98d95af75ebb', 'cd1e8e59-dd67-538d-98c3-2638008ff68c', '266710e1-5c1f-5ffc-bb1d-f4db1787b43b', 'bcf1be1b-2e12-59c3-b8da-9b1937ea64dd', 'fc191a28-350f-5797-91b0-dc17fc2bef70', '895f2579-d977-562d-9a45-e242b6d37fb9', '86d09f02-4936-584b-b703-6ef2b2636c10', '98a6eb19-114e-5464-990d-079a750dcfc6', '3dadbec2-5efa-5ddb-a306-2b05e0cf6083', 'a9f19831-ac0b-59a1-aad0-3be3405e7bf1', '10a19083-6cba-5056-b5f7-3c06ac8405fe', '553f23d2-3f1a-5a6f-a385-fdd8efd903e0', '63a7816d-5637-5a8d-b202-1f0291b945f3', '4b6ec99c-3f48-513f-a532-8b9cfc91ef71', '9b355ce8-ccb7-5d4d-849f-5c2df0e599f2', 'e98cb802-4d13-5c59-9a57-a1d4622d5c83', '6e5409f2-f31e-54ce-9665-3a1c0e513b9d', '76d21ed2-8667-50da-8709-fbb6773f23a1', '8234c0f0-1eb7-5bca-85dd-ac93f5915741', '614f929c-cbbb-5cbc-8750-ee202eb86956', 'fc0e0d5c-95c6-57a4-ad40-95c3cd0cef49', '08f73ec8-f95b-5f30-a510-1eda3a29c5cc', '5d60f279-3f7d-54f8-b30c-22bb1e9c5348', 'ffee084f-1a4c-57e5-889c-d5a95984cdcd', 'e5f3078b-ed63-55e8-9ee9-1a6cf389f9e0', '002a64bc-7c4f-5fa4-bdb2-3dc63c168176', '92a509e3-d02f-57ad-897c-9a16e44189a3', 'f6694c76-3b63-5897-91e1-955238e323a2', 'a48e74cc-d57a-5e1e-8730-6668d8baf236', '781ba196-7c93-52e4-a207-f479e8cf1c53', '00b18781-2f37-553d-b07c-b0270412011e', '7a87cda9-e3b8-57d9-9b3c-4cf477794e51', 'a6836676-f716-540b-880e-4fec2a8a4aae', 'c8be1a71-1acc-5897-bfc2-545904cd8615', 'f12c62f6-4e21-5699-aed6-c734c7aa357d', '646ef569-e6d1-5168-b9c7-ea34b045aa6a', '2781e798-8fdb-5224-98df-7b581fb86c58', '6da31707-ed07-5129-b890-cf159165f4c7', '8ec10b45-5e16-5f52-a45d-74b2afdba4ab', '943d7d36-dbfa-5efd-9274-afd555c5baf8', '981fc3ce-7139-57a2-b646-4c21c827b2a3', '11d3a0ba-175f-544c-b2f1-3c2c69cace19', '231ac4f6-d58f-55fc-b2ed-28654b25a452', 'a69bea1b-6e9b-557f-9380-07194fa14b03', '28486cbc-7317-505d-9110-2c54ce7b95da', '9e8def54-2d94-537d-ba9c-9e174c3148ca', 'f0c4a753-1567-5ade-847d-8331025a2a0e', '401b0318-9356-5252-a4ad-093fc54e9f4b', 'dd294748-e29f-5453-8649-c6d586e6127d', '67a24a8b-f305-57f8-a3ee-ad188f275cd1', 'b4393e85-f78a-5de0-814d-ea47ac08f07c', '21626603-3fa2-5c97-bc2b-0519be4d35f1', 'e47f397b-b58d-52e5-935d-f9315dbf2c70', '51ae34f7-f5e3-54b9-88f8-0f5f4dcbd400', 'e37d8068-2243-5989-a73e-e1be4f55c9a0', 'ff9e8f56-a310-5879-bed2-c0bbbb069b81', 'dc306be7-0210-5a46-90a0-f32c11c2a22c', '83544320-e797-5ded-8991-6862e088ac2c', '67706db9-c346-5641-b87c-b9ff1d33a68c', '6a7962eb-b1c0-5c1c-b8b0-f02a45b5a5eb', '380a3f96-aac2-584c-9c0b-a623b523ed60', '2335cada-9e64-53d5-9d06-cbff2051e9c2', 'e344fa6d-31a1-5e3c-b0f0-a9c72751fc9a', 'cd0d1195-fbe4-5248-8173-912f6788e3af', '6b892166-ee0a-5f15-8fac-62db7b96f65b', 'f0159069-2b29-5857-b9ad-ba0205ceb0d4', 'f5fef651-89a4-5704-bba9-e5bf3cc42b87', 'c85fd007-93cc-5a95-a0f4-35ee95e1e5ff', '7ff7822c-3558-583b-91cd-14b7d2de349b', '57d1d739-6285-5798-8ca2-1f3d36be811b', '01ebf836-3636-57ab-b737-e8143b0b0026', 'b66485be-fedc-5f46-acd6-2c081af1c95b', '1ee3cafa-014e-5894-8e47-c47c3a41e5ef', 'e6cd7c28-c6cc-5dd6-ac90-1ffad838d8a1', '404fadbb-a4db-50b3-ad47-f0e0ed20ffea', '68534bc2-8ed4-5bfa-8396-46ef25d49379', '9ef39aa6-1d67-5301-b0e3-7fefc8080fcd', 'ca5247b2-d960-5455-aa30-889cc53cde2d', '28835fa8-35e9-5144-92ca-0ef9b61cff56', 'd72540ca-2359-5366-85c8-e1254adca984', '62319a38-64b6-540b-a566-19c9e94473c0', '93011218-bb20-56b3-aedd-5488272b8df5', '13e45d71-984a-5f78-a42f-11bcc10665c0', '0b1858bb-480a-570a-b31b-48dd9ead6525', 'bb032b17-6311-5472-b8ea-6c5a0272fa60', 'ff42a681-8223-59e6-9327-87b4d0ea972d', 'eaf884b8-2fd0-57cc-9225-758559f79e7a', '655c8280-3f65-5cd2-96a8-50625061be62', 'b6c68624-bd0c-56a7-a83d-99fa99691468', 'dc6e636f-c8f6-568d-9b1b-0733076cc23d', '5e8612c7-49aa-5779-89f5-1f70cc138e26', 'c92113ce-ba70-5329-a5e3-bff12dedf092', 'ea343d3b-73b3-52f4-b41c-3dffe5a52ed0', 'de45771e-48be-5845-b61c-381011e94faf', 'b5425926-b287-5877-873d-47062066e50d', '1b8f5b05-ffc3-55e3-9228-aa4c871ae18e', 'd5d44f27-b37d-5476-8bd6-409f3e7623f0', '7b2b30b6-8d54-548c-a175-fb898d361371', '226e84e8-26ce-5ea4-816b-4e6d2e114e8a', '3de319e6-1625-53cd-8c41-9e12738d7711', 'de45ea72-709a-50d3-afca-89ec774455ad', '75481405-1d91-50ac-b5bd-ba608e701122', 'dfa5555e-66c0-57f1-9f1e-348e47f18977', 'ceb76991-d3c9-55e8-879a-a2574ae83353', '380ebfab-f0c5-5f6f-9165-3193b0f3b8d7', '5d6b96d6-87bd-58a7-936c-922965e929cd', 'e1efa255-c9b6-5f28-b879-9894f148605a', '3b096c27-d89c-5b3c-8fc6-f198ad8195cc', '598fe436-ee3e-59e6-978b-987291208c3d', '7a6075c9-f142-50d4-9edd-8a0b2bc29f87', '5dd0313a-af21-5942-86b5-c72af132785d', '7ab11d45-39d9-548f-ac77-f009eb8409eb', '34c28d42-a214-5aba-abb3-c4014731b4b0', '0d487d56-1d9f-5e95-b2d7-16d2be004253', '234f57d4-4784-53a3-af91-5c75bf7857ea', '7edcefca-2b92-5062-9583-058ca7ea0657', '90727243-3522-5a56-b84a-7440ceef20fc', '51bbaf04-c17f-54a0-96b9-f481f0da1d98', 'd0bb6f39-1caa-58c0-9b93-fa07a2427c3c', '3d94fc18-a0d4-5248-bdc0-32b9f0527b96', 'c5f80086-dd58-5f6a-9c54-0d907e854459', '7cbe491f-d5f9-5865-8b70-ffe0920de9f7');
DELETE FROM public.chapters c WHERE c.subject_id = 'sciences-physiques-8eme' AND c.id NOT IN ('cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', '9be74608-8e42-5e5f-bd83-8154e81cf237', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', 'الخلائط والذوبان في الماء', 'الماء في الطبيعة ومكوّناته، الخليط المتجانس والخليط غير المتجانس، الذوبان في الماء (المذاب والمذيب والمحلول المائي)، حفظ كتلة المذاب أثناء الذوبان، وظاهرة التشبّع وتأثير الحرارة والكمّية فيها', '# ⚗️ الخلائط والذوبان في الماء — أين يختفي السكّر في كأس الشاي؟

> 💡 «تضع ملعقة سكّر في كأس شاي ساخن، تحرّكها قليلًا، فيختفي السكّر عن عينيك… لكنّك تتذوّق حلاوته في كلّ رشفة. إلى أين ذهب السكّر إذن؟ هل زال حقًّا؟ في هذا الفصل نكشف سرّ الذوبان في الماء.»

## 🌊 الماء في الطبيعة

الماء الذي نجده في الطبيعة — ماء العيون والوديان والبحر والمياه الجوفية — **ليس ماءً نقيًّا** أبدًا. فهو يحمل معه موادّ أخرى مخلوطة به:

- **موادّ مذابة** لا نراها بالعين المجرّدة، مثل الأملاح المعدنية في المياه المعدنية، والملح الكثير في ماء البحر، وغازات مذابة كالأكسجين الذي تتنفّسه الأسماك.
- **موادّ عالقة** أحيانًا نراها بالعين المجرّدة، مثل حبيبات الطين في ماء الوادي العكر.

فماء البحر مالح لأنّه يحتوي على ملح مذاب، وماء «صفاقس» أو أيّ مياه معدنية يحتوي على أملاح مذابة تمنحه طعمه. الماء إذن، في الطبيعة، هو في الغالب **خليط**.

## 🥤 الخليط: متجانس أم غير متجانس؟

عندما نمزج جسمين أو أكثر نحصل على **خليط**. ونميّز نوعين حسب مظهره بالعين المجرّدة:

| نوع الخليط          | تعريفه                                                 | أمثلة تونسية                                |
| ------------------- | ------------------------------------------------------ | ------------------------------------------- |
| **خليط متجانس**     | موحّد المظهر تمامًا، لا نميّز مكوّناته بالعين المجرّدة | ماء + سكّر مذاب، شاي مُحلّى، ماء + ملح مذاب |
| **خليط غير متجانس** | نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة          | ماء + زيت، ماء + رمل، عصير برتقال بلبّه     |

> 🗡️ الخليط المتجانس يبدو **صافيًا شفّافًا**، لكنّه قد يكون **ملوّنًا** (كالشاي أو عصير الليمون): اللون لا يعني أنّه غير متجانس، فما دام موحّد المظهر في كلّ نقطة فهو متجانس.

<svg viewBox="0 0 300 205">
<title>خليط متجانس مقابل خليط غير متجانس</title>
<polygon points="40,58 48,163 112,163 120,58" fill="#fde3b3"/><polyline points="40,58 48,163 112,163 120,58" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="40" y1="58" x2="120" y2="58" stroke="#2563eb" stroke-width="1.6"/><polygon points="190,108 193,163 257,163 260,108" fill="#dbeafe"/><polygon points="186,58 190,108 260,108 264,58" fill="#fde3b3"/><polyline points="186,58 193,163 257,163 264,58" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="186" y1="58" x2="264" y2="58" stroke="#64748b" stroke-width="1.4"/><line x1="190" y1="108" x2="260" y2="108" stroke="#0f172a" stroke-width="2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="80" y="40" text-anchor="middle" fill="#0f172a" font-size="13">متجانس</text><text x="80" y="185" text-anchor="middle" fill="#0f172a" font-size="11">مظهر موحّد في كلّ نقطة</text><text x="225" y="40" text-anchor="middle" fill="#0f172a" font-size="13">غير متجانس</text><text x="268" y="90" text-anchor="start" fill="#0f172a" font-size="11">زيت</text><text x="268" y="140" text-anchor="start" fill="#0f172a" font-size="11">ماء</text><text x="225" y="185" text-anchor="middle" fill="#0f172a" font-size="11">طبقتان متمايزتان</text></g>
</svg>

## 🧂 الذوبان في الماء: المذاب والمذيب والمحلول

حين نضيف قليلًا من الملح إلى ماء ونحرّكه، يختفي الملح عن العين ويصبح الخليط متجانسًا: نقول إنّ الملح **ذاب** في الماء. لهذه الظاهرة مصطلحات دقيقة يجب حفظها:

- **المذاب**: الجسم الذي يذوب فيختفي عن العين المجرّدة (السكّر، الملح).
- **المذيب**: السائل الذي يُذيب المذاب. هنا **الماء هو المذيب**، ولهذا يُلقّب بـ«المذيب الشامل».
- **المحلول المائي**: الخليط المتجانس الناتج عن الذوبان = مذيب (ماء) + مذاب.

فكأس الشاي المُحلّى محلول مائي: مذيبه الماء، ومذابه السكّر.

<svg viewBox="0 0 300 205">
<title>نموذج جسيمي للذوبان: تشتّت المذاب في المذيب</title>
<rect x="24" y="74" width="78" height="92.5" fill="#dbeafe"/><polyline points="22,52 22,168 104,168 104,52" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="22" y1="74" x2="104" y2="74" stroke="#2563eb" stroke-width="1.6"/><circle cx="40" cy="92" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="70" cy="100" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="88" cy="128" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="34" cy="140" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="58" cy="150" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="80" cy="108" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="50" cy="150" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="61" cy="150" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="72" cy="150" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="50" cy="160" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="61" cy="160" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="72" cy="160" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><rect x="198" y="74" width="78" height="92.5" fill="#dbeafe"/><polyline points="196,52 196,168 278,168 278,52" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="196" y1="74" x2="278" y2="74" stroke="#2563eb" stroke-width="1.6"/><circle cx="212" cy="95" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="244" cy="92" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="268" cy="118" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="208" cy="132" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="252" cy="150" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="230" cy="112" r="3.4" fill="#bfdbfe" stroke="#2563eb" stroke-width="1"/><circle cx="222" cy="100" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="258" cy="108" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="210" cy="118" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="240" cy="132" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="268" cy="148" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><circle cx="226" cy="156" r="4.6" fill="#d97706" stroke="#0f172a" stroke-width="1.2"/><line x1="126" y1="110" x2="168" y2="110" stroke="#0f172a" stroke-width="2.5"/><polygon points="168,110 158,115 158,105" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="110" y="42" text-anchor="middle" fill="#0f172a" font-size="12">قبل الذوبان</text><text x="237" y="42" text-anchor="middle" fill="#0f172a" font-size="12">بعد الذوبان</text><text x="147" y="102" text-anchor="middle" fill="#0f172a" font-size="11">تحريك</text><text x="147" y="190" text-anchor="middle" fill="#0f172a" font-size="11">المذاب يتوزّع جسيماتٍ دقيقةً في كامل المذيب</text></g>
</svg>

> ⚠️ لا تقلب المذاب والمذيب: **المذيب هو السائل الذي يُذيب** (الماء)، و**المذاب هو ما يذوب فيه ويختفي** (السكّر). الماء يُذيب السكّر، لا العكس.

> 🗡️ لا تخلط بين **الذوبان** و**الانصهار**: الذوبان اختفاء مذاب داخل مذيب سائل (سكّر في ماء)، أمّا الانصهار فتحوّل جسم صلب إلى سائل بالتسخين (جليد يصير ماءً). ذوبان السكّر لا يحتاج بالضرورة إلى تسخين.

## ⚖️ المذاب لا يختفي: حفظ الكتلة

هل زال السكّر فعلًا حين اختفى عن العين؟ **كلّا**. المذاب لا يُعدم، بل يتوزّع في كامل الماء على شكل جسيمات دقيقة جدًّا لا تراها العين. والدليل:

- **نتذوّقه**: طعم الحلاوة أو الملوحة يبقى في كلّ الكأس.
- **نسترجعه**: بتبخير الماء بالتسخين يبقى المذاب الجافّ في الإناء (كما في التقطير).
- **الكتلة تُحفظ**: كتلة المحلول = كتلة الماء + كتلة المذاب. فإذا أذبنا 20 g من السكّر في 200 g من الماء، كانت كتلة المحلول 220 g بالضبط.

> ⚠️ خطأ شائع: الظنّ أنّ السكّر «يزول» أو «يتحوّل إلى ماء» عند الذوبان. لا شيء من ذلك: الكتلة محفوظة، والمذاب موجود ويمكن استرجاعه.

## 🧪 التشبّع: حدّ لا يُتجاوز

هل يذوب الملح في الماء بلا حدود؟ **لا**. لكمّية معيّنة من الماء وعند درجة حرارة معيّنة، **حدّ أقصى** من المذاب يمكن أن يذوب. فإذا واصلنا إضافة الملح بعد هذا الحدّ، **لم يعد يذوب** وتراكم الفائض في القاع: يصبح المحلول عندئذ **مشبعًا**.

عاملان يؤثّران في هذا الحدّ:

- **درجة الحرارة**: كلّما ارتفعت حرارة الماء، ذاب فيه قدرٌ أكبر من أغلب المواد الصلبة (يذوب السكّر في الشاي الساخن أكثر ممّا يذوب في الماء البارد).
- **كمّية الماء**: كلّما زادت كمّية المذيب، ذاب قدرٌ أكبر من المذاب.

> ⚠️ التحريك (الخلط بالملعقة) **يُسرّع** الذوبان فقط، لكنّه **لا يزيد** الكمّية القصوى التي يمكن أن تذوب؛ فإذا كان المحلول مشبعًا لن يذيب التحريك الفائض المتراكم في القاع.

> 🏆 صرت الآن تعرف أنّ ماء الطبيعة خليط، وتميّز الخليط المتجانس من غير المتجانس، وتسمّي المذاب والمذيب والمحلول المائي، وتدرك أنّ المذاب لا يزول بل تُحفظ كتلته، وتفهم متى يصبح المحلول مشبعًا. في الفصل القادم ستتعلّم كيف تفصل مكوّنات هذه الخلائط وتعالج المياه!', '# 📜 ملخّص: الخلائط والذوبان في الماء

- **الماء في الطبيعة**: ليس نقيًّا، بل خليط يحمل موادّ مذابة (أملاح ماء البحر والمياه المعدنية، غازات مذابة) وأحيانًا موادّ عالقة (طين ماء الوادي).
- **الخليط المتجانس**: موحّد المظهر، لا نميّز مكوّناته بالعين المجرّدة (ماء + سكّر مذاب)؛ قد يكون شفّافًا **ملوّنًا** (شاي) ويظلّ متجانسًا.
- **الخليط غير المتجانس**: نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة (ماء + زيت، ماء + رمل).
- **الذوبان في الماء**: **المذاب** = الجسم الذي يذوب ويختفي (سكّر)؛ **المذيب** = السائل الذي يُذيب (الماء)؛ **المحلول المائي** = الخليط المتجانس الناتج = مذيب + مذاب.
- **الذوبان ≠ الانصهار**: الذوبان اختفاء مذاب في مذيب سائل؛ الانصهار تحوّل صلب إلى سائل بالتسخين.
- **حفظ الكتلة**: المذاب لا يزول، بل يتوزّع في الماء ويُسترجع بالتبخير؛ كتلة المحلول = كتلة الماء + كتلة المذاب (20 g سكّر في 200 g ماء ← محلول 220 g).
- **التشبّع**: لكمّية ماء وحرارة معيّنتين حدٌّ أقصى للمذاب؛ بعده لا يذوب الفائض ويتراكم في القاع (**محلول مشبع**). رفع الحرارة أو زيادة الماء يرفع الحدّ؛ التحريك **يُسرّع** الذوبان فقط ولا يزيد الكمّية القصوى.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', 'فصل مكوّنات خليط ومعالجة المياه', 'تقنيات فصل مكوّنات خليط غير متجانس (الترسيب، الترشيح، الفرز المغناطيسي) وخليط متجانس (التبخير، التقطير) ومبدأ كلّ تقنية والفرق بينها، ثمّ رحلة الماء الطبيعي عبر محطّة المعالجة ليصبح صالحًا للشرب، ومعالجة مياه الصرف في محطّة التطهير قبل إعادتها إلى الطبيعة', '# ⚗️ فصل مكوّنات خليط ومعالجة المياه — رحلة الماء من الوادي إلى الصنبور ثمّ العودة نظيفًا

> 💡 «تسحب دلوًا من ماء أحد الأودية فتجده عكرًا مملوءًا بالطين وبرادة الحديد وقليل من الملح الذائب. كيف تفصل هذه المكوّنات واحدًا واحدًا؟ وكيف تحوّل محطّات المعالجة هذا الماء إلى ماء صالح للشرب في صنبورك، ثمّ تعيد ماء الصرف نظيفًا إلى الطبيعة؟ هذا الفصل هو دليلك إلى فنّ فصل الخلائط.»

## 🏰 نوعا الخليط: متجانس وغير متجانس

عندما نمزج جسمين أو أكثر نحصل على **خليط**. اختيار تقنية الفصل المناسبة يبدأ دائمًا بتحديد **نوع الخليط**:

| نوع الخليط          | تعريفه                                                                | أمثلة                                       |
| ------------------- | --------------------------------------------------------------------- | ------------------------------------------- |
| **خليط متجانس**     | لا نميّز مكوّناته بالعين المجرّدة، فيبدو موحّد المظهر في كلّ نقطة منه | ماء + ملح مذاب، ماء + سكّر مذاب، ماء + كحول |
| **خليط غير متجانس** | نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة (حبيبات، طبقات، رواسب)  | ماء + رمل، ماء + زيت، ماء + برادة الحديد    |

> 🗡️ قاعدة ذهبية: **نوع الخليط يحدّد التقنية**. الخليط غير المتجانس نفصله بالترسيب أو الترشيح أو الفرز المغناطيسي؛ أمّا الخليط المتجانس فلا تفيد فيه هذه الطرق لأنّ المذاب اختفى تمامًا، فنلجأ إلى التبخير أو التقطير.

## ⚙️ فصل مكوّنات خليط غير متجانس

في الخليط غير المتجانس تبقى المكوّنات منفصلة فيزيائيًّا، فيكفي استغلال خاصّية تميّز أحد المكوّنات لفصله.

### 💧 الترسيب

**الترسيب** هو ترك الخليط غير المتجانس ساكنًا مدّة من الزمن، فتسقط الحبيبات الصلبة الثقيلة نحو القاع بفعل ثقلها، ويعلوها سائل أصفى.

- الجسم الصلب المستقرّ في القاع يُسمّى **الراسب**.
- لا يحتاج الترسيب إلى أيّة أداة: يكفي الانتظار.

> ⚠️ الترسيب لا يزيل الحبيبات الدقيقة جدًّا؛ تبقى عالقة في السائل فوق الراسب، فنحتاج بعده إلى الترشيح لإتمام التنقية.

### 🧪 الترشيح

**الترشيح** هو سكب الخليط غير المتجانس على **ورقة ترشيح** موضوعة في قمع: يمرّ السائل عبر مسامّها الدقيقة ويتساقط صافيًا، بينما تبقى الحبيبات الصلبة محتجزة فوق الورقة.

<svg viewBox="0 0 300 215">
<title>الترشيح: القمع وورقة الترشيح والراشح</title>
<line x1="48" y1="26" x2="48" y2="200" stroke="#64748b" stroke-width="3"/><line x1="30" y1="200" x2="90" y2="200" stroke="#64748b" stroke-width="3"/><line x1="48" y1="70" x2="96" y2="70" stroke="#64748b" stroke-width="3"/><polyline points="96,60 143,112 143,140 157,140 157,112 206,60" fill="none" stroke="#0f172a" stroke-width="2.5"/><polygon points="110,68 150,114 192,68" fill="#fff" stroke="#64748b" stroke-width="1.8"/><polygon points="122,82 150,112 180,82" fill="#dbeafe"/><line x1="122" y1="82" x2="180" y2="82" stroke="#2563eb" stroke-width="1.6"/><circle cx="140" cy="104" r="2.8" fill="#0f172a"/><circle cx="150" cy="100" r="2.8" fill="#0f172a"/><circle cx="160" cy="104" r="2.8" fill="#0f172a"/><circle cx="148" cy="108" r="2.8" fill="#0f172a"/><circle cx="156" cy="96" r="2.8" fill="#0f172a"/><ellipse cx="150" cy="150" rx="2.6" ry="4" fill="#2563eb"/><ellipse cx="150" cy="162" rx="2.4" ry="3.6" fill="#2563eb"/><polyline points="118,172 118,206 184,206 184,172" fill="none" stroke="#0f172a" stroke-width="2.5"/><rect x="120" y="186" width="62" height="18" fill="#dbeafe"/><line x1="120" y1="186" x2="182" y2="186" stroke="#2563eb" stroke-width="1.6"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="44" text-anchor="middle" fill="#0f172a" font-size="11">خليط غير متجانس</text><text x="150" y="55" text-anchor="middle" fill="#0f172a" font-size="10">(ماء + حبيبات)</text><text x="214" y="74" text-anchor="start" fill="#0f172a" font-size="11">قمع</text><text x="210" y="96" text-anchor="start" fill="#0f172a" font-size="11">ورقة الترشيح</text><text x="206" y="108" text-anchor="start" fill="#0f172a" font-size="10">تحجز الحبيبات</text><text x="151" y="200" text-anchor="middle" fill="#0f172a" font-size="12">الراشح</text></g>
</svg>

- السائل الصافي النافذ عبر الورقة يُسمّى **الراشح**.
- يفصل الترشيح حبيبات أدقّ ممّا يفصله الترسيب وحده، وفي درجة حرارة عادية دون أيّ تسخين.

> ⚠️ لا يفصل الترشيح جسمًا **مذابًا**: لو رشّحت ماءً مالحًا لمرّ الملح مع الماء عبر الورقة، لأنّ الملح ذاب ولم يعد حبيبات صلبة يمكن حجزها.

### 🧲 الفرز المغناطيسي

**الفرز المغناطيسي** هو استعمال **مغنطيس** لجذب المكوّنات الحديدية من خليط غير متجانس. نقرّب المغنطيس من الخليط فتلتصق به الأجسام الممغنطة (برادة الحديد، مسامير الحديد) بينما تبقى بقيّة المكوّنات في مكانها.

- يعتمد على خاصّية فيزيائية مميّزة: **الانجذاب إلى المغنطيس**.

> 🗡️ حذارِ من الخطأ الشائع: الفرز المغناطيسي يجذب **الأجسام الحديدية فقط** (الحديد، الفولاذ، بعض المعادن كالنيكل). لا يجذب الرمل ولا النحاس ولا الألمنيوم ولا الملح ولا السكّر. لو كان الخليط رملًا وملحًا فلا نفع للمغنطيس فيه إطلاقًا.

## 🔥 فصل مكوّنات خليط متجانس: التبخير والتقطير

في الخليط المتجانس (كماء وملح مذاب) اختفت الحبيبات الصلبة، فلا يفيد الترسيب ولا الترشيح ولا الفرز المغناطيسي. نلجأ حينئذ إلى تقنيتين تعتمدان على **التسخين** واختلاف قابلية المكوّنات للتبخّر: **التبخير** و**التقطير**. والفرق بينهما جوهريّ في **ما نسترجعه**.

### ☀️ التبخير

**التبخير** هو تسخين الخليط المتجانس (أو تركه في الهواء والشمس) حتّى يتبخّر الماء كلّه شيئًا فشيئًا، فيبقى في الإناء الجسم الصلب المذاب.

- نسترجع بالتبخير **الجسم الصلب المذاب** (الملح مثلًا).
- **نفقد الماء** إذ يتصاعد بخارًا في الهواء ولا نجمعه.
- هذه هي طريقة استخراج ملح الطعام من ماء البحر في السّبخات المالحة (المِلّاحات).

### 💠 التقطير

**التقطير** هو تسخين الخليط المتجانس حتّى الغليان فيتبخّر الماء، ثمّ **تمرير البخار عبر مبرّد** فيبرد ويتكاثف عائدًا ماءً سائلًا نقيًّا يُجمع في إناء آخر.

1. نسخّن حتّى الغليان ← يتصاعد بخار الماء تاركًا المذاب في الإناء.
2. يمرّ البخار في المبرّد ← يبرد ويتكاثف.
3. يتساقط الماء المقطّر النقيّ في إناء التجميع.

- نسترجع بالتقطير **الماء النقيّ (المذيب)**؛ ويبقى الجسم الصلب المذاب في إناء التسخين.

> 🗡️ الفرق الحاسم بين التبخير والتقطير: كلاهما يسخّن خليطًا متجانسًا، لكن **التبخير يسترجع الجسم الصلب المذاب ويهدر الماء**، بينما **التقطير يسترجع الماء النقيّ** بفضل تكاثف البخار في المبرّد. اسأل نفسك دائمًا: هل أريد الملح أم أريد الماء؟

## 🚰 معالجة المياه الصالحة للشرب

ماء الأودية والسدود عكر غير صالح للشرب مباشرة. تعالجه محطّات المعالجة عبر خطوات مرتّبة **وجوبًا** قبل توزيعه على المنازل:

| الترتيب | الخطوة              | الهدف                                                                   |
| ------- | ------------------- | ----------------------------------------------------------------------- |
| 1       | **الترسيب**         | تستقرّ حبيبات الطين والأوحال الثقيلة في أحواض واسعة                     |
| 2       | **الترشيح بالرمل**  | تُزال الحبيبات الدقيقة المتبقّية بتمرير الماء عبر طبقات من الرمل والحصى |
| 3       | **التعقيم بالكلور** | تُضاف كمّية صغيرة من الكلور للقضاء على الجراثيم والميكروبات             |

بعد هذه الخطوات يصبح الماء صالحًا للشرب، فيُوزَّع عبر شبكة الأنابيب إلى الصنابير في البيوت.

> ⚠️ لا تُقلب هذه الخطوات: البدء بالترشيح قبل الترسيب يسدّ طبقات الرمل بسرعة بكمّية الطين الكبيرة؛ والتعقيم قبل الترسيب يجعل الكلور يستهلك في مقاومة الأوساخ بدل الجراثيم فيضعف مفعوله. الترتيب: **ترسيب ← ترشيح ← تعقيم**.

## 🌊 معالجة مياه الصرف

بعد استعمال الماء في البيوت والمصانع يصبح **ماء صرف** ملوّثًا لا يجوز إعادته مباشرة إلى الأودية والبحر. تنقله شبكة التطهير إلى **محطّة تطهير** تنقّيه على مراحل مبسّطة قبل إعادته إلى الطبيعة:

1. **التصفية**: حواجز شبكية توقف الأجسام الكبيرة (خرق، أوراق، بقايا صلبة).
2. **الترسيب**: تستقرّ الموادّ العالقة الثقيلة في أحواض التصفيق.
3. **المعالجة البيولوجية**: بكتيريا نافعة تحلّل الموادّ العضوية الملوّثة.

بعد هذه المراحل يصبح الماء أنظف بكثير، فيُعاد إلى الوادي أو البحر أو يُستعمل في سقي المساحات الخضراء، دون أن يلوّث الطبيعة.

> ⚠️ لا تخلط بين المحطّتين: **محطّة معالجة المياه** تحوّل ماء الطبيعة إلى ماء **صالح للشرب** يدخل بيوتنا؛ أمّا **محطّة التطهير** فتنقّي ماء الصرف **الخارج** من بيوتنا لتحمي الطبيعة من التلوّث. الاتّجاه معاكس والهدف مختلف.

> 🏆 صرت الآن تختار التقنية المناسبة لكلّ خليط: الترسيب والترشيح والفرز المغناطيسي لغير المتجانس، والتبخير والتقطير للمتجانس، وتعرف الفرق بين استرجاع الملح واسترجاع الماء، وترتّب خطوات معالجة الماء الصالح للشرب، وتميّز محطّة المعالجة عن محطّة التطهير. في الفصل القادم ستدخل عالم **الكتلة الحجمية** وتكتشف لماذا يطفو جسم ويغرق آخر!', '# 📜 ملخّص: فصل مكوّنات خليط ومعالجة المياه

- **نوع الخليط يحدّد التقنية**: خليط غير متجانس (نميّز مكوّناته: ماء + رمل، ماء + برادة حديد) نفصله بالترسيب أو الترشيح أو الفرز المغناطيسي؛ خليط متجانس (لا نميّز مكوّناته: ماء + ملح مذاب) نفصله بالتبخير أو التقطير.

## فصل خليط غير متجانس

- **الترسيب**: ترك الخليط ساكنًا حتّى تستقرّ الحبيبات الثقيلة في القاع (الراسب)؛ لا يزيل الحبيبات الدقيقة جدًّا.
- **الترشيح**: تمرير الخليط على ورقة ترشيح في قمع، فتُحجز الحبيبات الصلبة ويمرّ السائل الصافي (الراشح) بلا تسخين؛ لا يفصل مذابًا.
- **الفرز المغناطيسي**: مغنطيس يجذب المكوّنات الحديدية فقط (حديد، فولاذ)؛ لا يجذب الرمل ولا النحاس ولا الملح ولا السكّر.

## فصل خليط متجانس

- **التبخير**: تسخين حتّى يتبخّر الماء كلّه فيبقى الجسم الصلب المذاب؛ نسترجع **الملح** ونفقد الماء (طريقة استخراج ملح البحر).
- **التقطير**: تسخين ثمّ تبريد البخار في مبرّد ليتكاثف؛ نسترجع **الماء النقيّ (المذيب)** ويبقى المذاب في إناء التسخين.
- **الفرق**: التبخير يسترجع الجسم الصلب ويهدر الماء، والتقطير يسترجع الماء النقيّ.

## معالجة المياه

- **الماء الصالح للشرب**: ثلاث خطوات مرتّبة وجوبًا — الترسيب ← الترشيح بالرمل ← التعقيم بالكلور — ثمّ التوزيع للمنازل.
- **مياه الصرف**: محطّة تطهير تنقّي الماء الخارج من البيوت والمصانع (تصفية ← ترسيب ← معالجة بيولوجية) قبل إعادته إلى الطبيعة.
- **لا تخلط**: محطّة المعالجة تصنع ماءً صالحًا للشرب يدخل البيوت؛ محطّة التطهير تنقّي ماء الصرف الخارج لتحمي الطبيعة.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', 'الكتلة الحجمية', 'قيس الحجم بالمخبار المدرّج وطريقة الإزاحة، قيس الكتلة بالميزان، الكتلة الحجمية ρ = m/V ووحداتها g/cm³ و kg/m³، التحديد العملي للكتلة الحجمية، والأجسام الطافية والمغمورة حسب مقارنة كتلتها الحجمية بكتلة الماء الحجمية', '# ⚔️ الكتلة الحجمية — لماذا يطفو الزيت ويرسب الحجر؟

> 💡 «قطعة صغيرة من الرصاص ترسب بسرعة في الماء، بينما لوح خشبيّ ضخم يطفو فوقه بسهولة. ليس الحجم ولا الكتلة وحدهما ما يقرّر ذلك، بل مقدار جديد يجمع بينهما: الكتلة الحجمية. تعلّم كيف تحسبها بالعلاقة ρ = m/V، وكيف تتنبّأ بها هل يطفو الجسم أم يغوص!»

## 📏 قيس الحجم

**الحجم** هو المقدار الذي يقيس الحيّز الذي يشغله الجسم في الفضاء. وحدته الدولية هي **المتر المكعّب** (m³)، لكنّنا في المخبر نستعمل غالبًا وحدات أصغر: **السنتيمتر المكعّب** (cm³) و**المِلّيلتر** (mL) و**اللتر** (L).

روابط التحويل التي يجب حفظها:

| التحويل | القيمة        |
| ------- | ------------- |
| 1 mL    | = 1 cm³       |
| 1 L     | = 1000 mL     |
| 1 L     | = 1000 cm³    |
| 1 m³    | = 1000000 cm³ |

- **قيس حجم سائل**: نستعمل **المخبار المدرّج** (الكأس المدرّج) ونقرأ الحجم عند مستوى سطح السائل.
- **قيس حجم جسم صلب غير منتظم الشكل** (كحجر أو مفتاح): نستعمل **طريقة الإزاحة**. نضع كمّية من الماء في المخبار ونقرأ الحجم الابتدائي V1؛ ثمّ نغمر الجسم بالكامل فيرتفع مستوى الماء إلى V2؛ فيكون حجم الجسم:

> 🗡️ **حجم الجسم الصلب = V2 − V1** ; أي الفرق بين الحجم بعد الغمر والحجم قبله. هذا الفرق يساوي بالضبط حجم الماء الذي «أزاحه» الجسم.

<svg viewBox="0 0 300 210">
<title>طريقة الإزاحة: حجم الجسم = V2 − V1</title>
<rect x="48" y="136.67" width="42" height="43.83" fill="#cfe4fb"/><polyline points="46,40 46,182 92,182 92,40" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="46" y1="136.67" x2="92" y2="136.67" stroke="#2563eb" stroke-width="1.8"/><line x1="92" y1="182" x2="82" y2="182" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="96" y="186" text-anchor="start" fill="#0f172a" font-size="9">0</text></g><line x1="92" y1="159.33" x2="86" y2="159.33" stroke="#64748b" stroke-width="1.4"/><line x1="92" y1="136.67" x2="82" y2="136.67" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="96" y="140.67" text-anchor="start" fill="#0f172a" font-size="9">20</text></g><line x1="92" y1="114" x2="86" y2="114" stroke="#64748b" stroke-width="1.4"/><line x1="92" y1="91.33" x2="82" y2="91.33" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="96" y="95.33" text-anchor="start" fill="#0f172a" font-size="9">40</text></g><line x1="92" y1="68.67" x2="86" y2="68.67" stroke="#64748b" stroke-width="1.4"/><line x1="92" y1="46" x2="82" y2="46" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="96" y="50" text-anchor="start" fill="#0f172a" font-size="9">60</text></g><rect x="200" y="68.67" width="42" height="111.83" fill="#cfe4fb"/><polygon points="206,118 222,108 236,120 232,140 214,144 202,132" fill="#64748b" stroke="#0f172a" stroke-width="1.8"/><polyline points="198,40 198,182 244,182 244,40" fill="none" stroke="#0f172a" stroke-width="2.5"/><line x1="198" y1="68.67" x2="244" y2="68.67" stroke="#2563eb" stroke-width="1.8"/><line x1="244" y1="182" x2="234" y2="182" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="248" y="186" text-anchor="start" fill="#0f172a" font-size="9">0</text></g><line x1="244" y1="159.33" x2="238" y2="159.33" stroke="#64748b" stroke-width="1.4"/><line x1="244" y1="136.67" x2="234" y2="136.67" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="248" y="140.67" text-anchor="start" fill="#0f172a" font-size="9">20</text></g><line x1="244" y1="114" x2="238" y2="114" stroke="#64748b" stroke-width="1.4"/><line x1="244" y1="91.33" x2="234" y2="91.33" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="248" y="95.33" text-anchor="start" fill="#0f172a" font-size="9">40</text></g><line x1="244" y1="68.67" x2="238" y2="68.67" stroke="#64748b" stroke-width="1.4"/><line x1="244" y1="46" x2="234" y2="46" stroke="#64748b" stroke-width="1.4"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="248" y="50" text-anchor="start" fill="#0f172a" font-size="9">60</text></g><line x1="120" y1="120" x2="168" y2="120" stroke="#0f172a" stroke-width="2.5"/><polygon points="168,120 158,125 158,115" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="69" y="34" text-anchor="middle" fill="#0f172a" font-size="12">قبل الغمر</text><text x="221" y="34" text-anchor="middle" fill="#0f172a" font-size="12">بعد الغمر</text><text x="144" y="112" text-anchor="middle" fill="#0f172a" font-size="10">غمر الجسم</text><text x="92" y="133.67" text-anchor="start" fill="#2563eb" font-size="11">V1 = 20</text><text x="246" y="65.67" text-anchor="start" fill="#2563eb" font-size="11">V2 = 50</text><text x="150" y="200" text-anchor="middle" fill="#0f172a" font-size="12">حجم الجسم = V2 − V1 = 30 cm³</text></g>
</svg>

## ⚖️ قيس الكتلة

**الكتلة** هي مقدار المادّة التي يحتوي عليها الجسم. نقيسها بجهاز يسمّى **الميزان**، ووحدتها الدولية هي **الكيلوغرام** (kg)، ونستعمل كثيرًا **الغرام** (g).

روابط التحويل:

| التحويل | القيمة   |
| ------- | -------- |
| 1 kg    | = 1000 g |

> ⚠️ لا تخلط بين الكتلة والحجم: الكتلة تُقاس بالميزان بالغرام (g)، والحجم يُقاس بالمخبار المدرّج بالسنتيمتر المكعّب (cm³). جسمان لهما نفس الحجم قد تختلف كتلتاهما اختلافًا كبيرًا (كرة من الفلّين وكرة من الحديد لهما نفس الحجم لكن كتلة الحديد أكبر بكثير).

## 🧮 الكتلة الحجمية: التعريف والعلاقة ρ = m/V

**الكتلة الحجمية** لجسم هي كتلة وحدة الحجم منه ; أي الكتلة المقابلة لكلّ سنتيمتر مكعّب واحد (أو متر مكعّب واحد) من مادّته. نرمز لها بالحرف الإغريقي **ρ** (رُو)، وتُحسب بالعلاقة:

**ρ = m/V**

حيث:

- **m** كتلة الجسم ;
- **V** حجم الجسم ;
- **ρ** كتلته الحجمية.

**الوحدات**: إذا عبّرنا عن الكتلة بالغرام (g) والحجم بالسنتيمتر المكعّب (cm³)، تكون الكتلة الحجمية بالوحدة **g/cm³**. وإذا استعملنا الكيلوغرام (kg) والمتر المكعّب (m³)، تكون الوحدة **kg/m³**.

للتحويل بين الوحدتين: **1 g/cm³ = 1000 kg/m³**.

> 🗡️ الكتلة الحجمية **خاصّية مميّزة للمادّة**: كلّ مادّة نقيّة لها كتلة حجمية ثابتة لا تتعلّق بحجم العيّنة. سواء أخذت غرامًا واحدًا من الحديد أو كيلوغرامًا كاملًا، تبقى كتلته الحجمية ρ = 7.9 g/cm³ نفسها ; لأنّ الكتلة والحجم يكبران معًا بنفس النسبة.

> ⚠️ انتبه إلى ترتيب العلاقة: ρ = m/V (الكتلة **مقسومة على** الحجم)، وليس V/m. قلب النسبة خطأ شائع يعطي نتيجة مقلوبة وخاطئة تمامًا.

بعض القيم المرجعية (عند شروط عادية):

| المادّة      | الكتلة الحجمية ρ (g/cm³) |
| ------------ | ------------------------ |
| الفلّين      | 0.2                      |
| الخشب        | 0.6                      |
| الزيت        | 0.9                      |
| الماء النقيّ | 1                        |
| الألمنيوم    | 2.7                      |
| الحديد       | 7.9                      |

## 🔬 التحديد العملي للكتلة الحجمية

لتعيين الكتلة الحجمية لجسم صلب في المخبر نتّبع ثلاث خطوات:

1. **قيس الكتلة m** بالميزان (بالغرام).
2. **قيس الحجم V** بالمخبار المدرّج: مباشرةً إن كان سائلًا، أو بطريقة الإزاحة (V2 − V1) إن كان صلبًا غير منتظم.
3. **الحساب**: نطبّق العلاقة ρ = m/V.

**مثال محلول**: حجر كتلته m = 75 g، غُمر في مخبار فارتفع مستوى الماء من 20 cm³ إلى 50 cm³.

- حجم الحجر: V = 50 − 20 = 30 cm³ ;
- كتلته الحجمية: ρ = m/V = 75 / 30 = 2.5 g/cm³.

> 💡 من هذه العلاقة نستنتج أيضًا الكتلة إذا عرفنا الحجم والكتلة الحجمية: **m = ρ × V**. مثال: حجم 20 cm³ من الألمنيوم كتلته m = 2.7 × 20 = 54 g.

## 🚢 الأجسام الطافية والمغمورة

عندما نضع جسمًا في الماء، إمّا أن **يطفو** فوق سطحه أو **يرسب** (يغوص) إلى القاع. ما يقرّر ذلك ليس الكتلة وحدها ولا الحجم وحده، بل **مقارنة الكتلة الحجمية للجسم بالكتلة الحجمية للماء** (ρ الماء = 1 g/cm³ = 1000 kg/m³):

| الحالة                      | الشرط       | النتيجة                |
| --------------------------- | ----------- | ---------------------- |
| ρ الجسم **أصغر** من ρ الماء | ρ < 1 g/cm³ | **يطفو** فوق الماء     |
| ρ الجسم **أكبر** من ρ الماء | ρ > 1 g/cm³ | **يرسب** (يغوص)        |
| ρ الجسم **يساوي** ρ الماء   | ρ = 1 g/cm³ | يبقى **معلّقًا** داخله |

مثال: الزيت (ρ = 0.9 g/cm³) يطفو فوق الماء لأنّ كتلته الحجمية أصغر ; والحديد (ρ = 7.9 g/cm³) يرسب لأنّ كتلته الحجمية أكبر.

> ⚠️ لا تحكم بالكتلة ولا بالحجم وحدهما: قطعة رصاص صغيرة كتلتها 20 g ترسب، بينما لوح خشبيّ كتلته 5000 g يطفو ; فالجسم الأثقل ليس دائمًا هو الذي يغوص. المعيار الوحيد هو الكتلة الحجمية.

> 🗡️ وهكذا تفسّر لماذا تطفو السفن الضخمة المصنوعة من الفولاذ: شكلها المجوّف يحبس هواءً كثيرًا، فتصبح الكتلة الحجمية **الوسطى** لمجموع (الفولاذ + الهواء) أصغر من كتلة الماء الحجمية، فتطفو رغم ثقلها الكبير.

> 🏆 أصبحت الآن قادرًا على قيس الحجم والكتلة، وحساب الكتلة الحجمية بالعلاقة ρ = m/V، والتنبّؤ هل يطفو الجسم أم يرسب بمقارنة كتلته الحجمية بكتلة الماء. في الفصل القادم ستدخل عالم الكهرباء وتكتشف أسرار الدارة الكهربائية!', '# 📜 ملخّص: الكتلة الحجمية

- **قيس الحجم**: الحجم يقيس الحيّز الذي يشغله الجسم ; وحدته m³، ونستعمل cm³ و mL و L. روابط: 1 mL = 1 cm³ ; 1 L = 1000 cm³ ; 1 m³ = 1000000 cm³. حجم السائل يُقرأ بالمخبار المدرّج، وحجم جسم صلب غير منتظم يُحسب بطريقة الإزاحة: V = V2 − V1.
- **قيس الكتلة**: الكتلة مقدار المادّة في الجسم، تُقاس بالميزان ; وحدتها kg، ونستعمل g. رابط: 1 kg = 1000 g. لا تخلط بين الكتلة (بالغرام) والحجم (بالسنتيمتر المكعّب).
- **الكتلة الحجمية**: كتلة وحدة الحجم من المادّة، رمزها ρ، وتُحسب بالعلاقة **ρ = m/V** (وليس V/m). وحدتها g/cm³ إذا كانت m بالغرام و V بالسنتيمتر المكعّب، أو kg/m³. التحويل: 1 g/cm³ = 1000 kg/m³.
- **خاصّية مميّزة**: الكتلة الحجمية ثابتة لكلّ مادّة نقيّة ولا تتعلّق بحجم العيّنة (الحديد ρ = 7.9 g/cm³ دائمًا). ومن العلاقة نستنتج m = ρ × V.
- **التحديد العملي**: نقيس m بالميزان، ثمّ V بالمخبار (مباشرة للسائل أو بالإزاحة للصلب)، ثمّ نحسب ρ = m/V. مثال: m = 75 g و V = 30 cm³ ← ρ = 2.5 g/cm³.
- **الطفو والرسوب**: نقارن الكتلة الحجمية للجسم بكتلة الماء الحجمية (ρ الماء = 1 g/cm³). إذا ρ < 1 g/cm³ يطفو ; إذا ρ > 1 g/cm³ يرسب ; إذا ρ = 1 g/cm³ يبقى معلّقًا. المعيار هو الكتلة الحجمية لا الكتلة ولا الحجم وحدهما (الزيت ρ = 0.9 يطفو، الحديد ρ = 7.9 يرسب).', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', 'الدارة الكهربائية: التركيب بالتسلسل والتفرّع', 'مكوّنات الدارة الكهربائية ورموزها الاصطلاحية، والفرق بين الدارة المفتوحة والدارة المغلقة، والموادّ الناقلة والعازلة للتيّار، والتمييز بين التركيب بالتسلسل (حلقة واحدة) والتركيب بالتفرّع (فروع متوازية) وأثر كلّ تركيب على المصابيح عند إطفاء أحدها', '# ⚔️ الدارة الكهربائية: سرّ التسلسل والتفرّع

> 💡 «في بيتك، تُطفئ مصباح غرفتك فيبقى مصباح المطبخ مضيئًا. لكن في سلسلة أضواء العيد، يكفي أن يحترق مصباح واحد لينطفئ الصفّ كلّه! لماذا يختلف السلوكان؟ السرّ كلّه في طريقة تركيب الدارة: بالتسلسل أم بالتفرّع.»

## 🏰 مكوّنات الدارة الكهربائية ورموزها الاصطلاحية

**الدارة الكهربائية** حلقة من عناصر متّصلة تسمح بمرور **التيّار الكهربائي**. عناصرها الأساسية:

| العنصر                        | دوره في الدارة                                                            |
| ----------------------------- | ------------------------------------------------------------------------- |
| **المولّد** (عمود أو بطّارية) | يزوّد الدارة بالطاقة اللازمة لجريان التيّار؛ له قطبان: موجب (+) وسالب (−) |
| **المستقبل** (مصباح أو محرّك) | يستقبل الطاقة ويحوّلها: المصباح إلى ضوء، والمحرّك إلى حركة                |
| **القاطع** (المفتاح)          | يتحكّم في فتح الدارة أو غلقها عن قصد                                      |
| **أسلاك التوصيل**             | تربط العناصر ببعضها لتكوّن مسارًا للتيّار                                 |

نرسم الدارة بـ**رموز اصطلاحية** موحّدة بدل رسم كلّ عنصر بشكله الحقيقي: المولّد خطّان متوازيان مختلفا الطول (الطويل قطبه الموجب والقصير قطبه السالب)، المصباح دائرة بداخلها علامة تقاطع (×)، المحرّك دائرة بداخلها الحرف M، القاطع المفتوح خطّ منقطع بفجوة، والقاطع المغلق خطّ متّصل.

> ⚠️ لا تخلط بين رمز المصباح (دائرة بداخلها ×) ورمز المحرّك (دائرة بداخلها M): كلاهما مستقبل، لكن أحدهما يضيء والآخر يدور.

## 🔌 الدارة المفتوحة والدارة المغلقة

- **الدارة المغلقة**: مسار متّصل بالكامل دون أيّ انقطاع، فيجري فيها التيّار ويعمل المستقبل.
- **الدارة المفتوحة**: فيها فجوة أو انقطاع في نقطة واحدة على الأقلّ (سلك مقطوع أو قاطع مفتوح)، فلا يجري التيّار ويتوقّف المستقبل تمامًا.

> 🗡️ القاعدة الذهبية: **دارة مغلقة = تيّار يجري = مستقبل يعمل**؛ **دارة مفتوحة ولو في نقطة واحدة = لا تيّار = مستقبل متوقّف بالكامل**، مهما بدت بقية الحلقة متّصلة.

## 🛡️ الموادّ الناقلة والموادّ العازلة

- **موادّ ناقلة (موصّلة)**: تسمح بمرور التيّار بسهولة — النحاس (لبّ الأسلاك)، الألمنيوم، الحديد ومعظم المعادن، والماء الذي يحوي أملاحًا مذابة، وجسم الإنسان.
- **موادّ عازلة**: تمنع مرور التيّار تمامًا — البلاستيك (غلاف الأسلاك)، المطّاط، الخشب الجافّ، الزجاج، الهواء الجافّ، القماش والورق الجافّان.

> ⚠️ لبّ السلك المعدني **ناقل** ينقل التيّار، بينما غلافه البلاستيكي **عازل** يمنع التيّار من الوصول إلى يد من يمسكه — ولذلك تُغلَّف الأسلاك بالبلاستيك.

## ⚡ التركيب بالتسلسل (على التوالي)

في **التركيب بالتسلسل** تُوصَل المستقبلات الواحد تلو الآخر في **حلقة واحدة فقط**، فيمرّ التيّار في **مسار وحيد** يعبر كلّ مصباح بالترتيب.

<svg viewBox="0 0 300 200">
<title>تركيب بالتسلسل: حلقة واحدة ومصباحان على مسار وحيد</title>
<line x1="48" y1="55" x2="48" y2="101.5" stroke="#0f172a" stroke-width="2.5"/><line x1="48" y1="110.5" x2="48" y2="158" stroke="#0f172a" stroke-width="2.5"/><line x1="31" y1="101.5" x2="65" y2="101.5" stroke="#0f172a" stroke-width="2.5"/><line x1="40" y1="110.5" x2="56" y2="110.5" stroke="#0f172a" stroke-width="5.5"/><line x1="48" y1="158" x2="258" y2="158" stroke="#0f172a" stroke-width="2.5"/><line x1="258" y1="158" x2="258" y2="55" stroke="#0f172a" stroke-width="2.5"/><line x1="258" y1="55" x2="203" y2="55" stroke="#0f172a" stroke-width="2.5"/><line x1="173" y1="55" x2="127" y2="55" stroke="#0f172a" stroke-width="2.5"/><line x1="97" y1="55" x2="48" y2="55" stroke="#0f172a" stroke-width="2.5"/><circle cx="112" cy="55" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="101.39" y1="44.39" x2="122.61" y2="65.61" stroke="#0f172a" stroke-width="2.5"/><line x1="101.39" y1="65.61" x2="122.61" y2="44.39" stroke="#0f172a" stroke-width="2.5"/><circle cx="188" cy="55" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="177.39" y1="44.39" x2="198.61" y2="65.61" stroke="#0f172a" stroke-width="2.5"/><line x1="177.39" y1="65.61" x2="198.61" y2="44.39" stroke="#0f172a" stroke-width="2.5"/><line x1="150" y1="158" x2="120" y2="158" stroke="#64748b" stroke-width="2"/><polygon points="120,158 128,154 128,162" fill="#64748b"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="48" y="106" text-anchor="end" fill="#0f172a" font-size="12">المولّد</text><text x="72" y="99.5" text-anchor="start" fill="#0f172a" font-size="15">+</text><text x="68" y="122.5" text-anchor="start" fill="#0f172a" font-size="15">−</text><text x="112" y="33" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="188" y="33" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="153" y="178" text-anchor="middle" fill="#0f172a" font-size="12">حلقة واحدة — مسار وحيد للتيّار</text></g>
</svg>

خصائصه:

- **إطفاء مصباح واحد يُطفئ الجميع**: إذا احترق مصباح أو نُزع أو انفكّ في تركيب بالتسلسل، انقطعت الحلقة الوحيدة فأصبحت الدارة **مفتوحة**، فتنطفئ **كلّ** المصابيح معًا، لا هذا المصباح وحده.
- **كلّما زاد عدد المصابيح المتسلسلة، قلّت إضاءة كلّ واحد منها**: المصابيح تتقاسم طاقة المولّد نفسها، فتضيء أضعف.
- **قاطع واحد على الحلقة يتحكّم في الجميع**: غلقه يُشعل كلّ المصابيح وفتحه يُطفئها كلّها معًا.

> 🗡️ سلسلة أضواء العيد القديمة مركّبة بالتسلسل: احتراق مصباح واحد يقطع الصفّ كلّه، ويصعب معرفة المصباح المعطوب لأنّ الجميع ينطفئ.

## 🔀 التركيب بالتفرّع (على التوازي)

في **التركيب بالتفرّع** تُوصَل المستقبلات على **فروع منفصلة** بين **نقطتَي تفرّع** (عقدتَين) مشتركتَين، فيجد التيّار **عدّة مسارات**؛ لكلّ مصباح فرعه الخاصّ.

<svg viewBox="0 0 300 200">
<title>تركيب بالتفرّع: فرعان بين عقدتَين لكلّ مصباح مساره</title>
<line x1="46" y1="55" x2="46" y2="103.5" stroke="#0f172a" stroke-width="2.5"/><line x1="46" y1="112.5" x2="46" y2="162" stroke="#0f172a" stroke-width="2.5"/><line x1="29" y1="103.5" x2="63" y2="103.5" stroke="#0f172a" stroke-width="2.5"/><line x1="38" y1="112.5" x2="54" y2="112.5" stroke="#0f172a" stroke-width="5.5"/><line x1="46" y1="55" x2="232" y2="55" stroke="#0f172a" stroke-width="2.5"/><line x1="46" y1="162" x2="232" y2="162" stroke="#0f172a" stroke-width="2.5"/><line x1="128" y1="55" x2="128" y2="93" stroke="#0f172a" stroke-width="2.5"/><line x1="128" y1="123" x2="128" y2="162" stroke="#0f172a" stroke-width="2.5"/><circle cx="128" cy="108" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="117.39" y1="97.39" x2="138.61" y2="118.61" stroke="#0f172a" stroke-width="2.5"/><line x1="117.39" y1="118.61" x2="138.61" y2="97.39" stroke="#0f172a" stroke-width="2.5"/><line x1="210" y1="55" x2="210" y2="93" stroke="#0f172a" stroke-width="2.5"/><line x1="210" y1="123" x2="210" y2="162" stroke="#0f172a" stroke-width="2.5"/><circle cx="210" cy="108" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="199.39" y1="97.39" x2="220.61" y2="118.61" stroke="#0f172a" stroke-width="2.5"/><line x1="199.39" y1="118.61" x2="220.61" y2="97.39" stroke="#0f172a" stroke-width="2.5"/><circle cx="128" cy="55" r="3.4" fill="#0f172a"/><circle cx="128" cy="162" r="3.4" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="46" y="108" text-anchor="end" fill="#0f172a" font-size="12">المولّد</text><text x="68" y="101.5" text-anchor="start" fill="#0f172a" font-size="15">+</text><text x="64" y="124.5" text-anchor="start" fill="#0f172a" font-size="15">−</text><text x="134" y="47" text-anchor="start" fill="#0f172a" font-size="11">عقدة</text><text x="128" y="86" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="210" y="86" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="150" y="182" text-anchor="middle" fill="#0f172a" font-size="12">فرعان مستقلّان بين عقدتَين</text></g>
</svg>

خصائصه:

- **إطفاء مصباح لا يؤثّر في البقية**: إذا احترق مصباح أو نُزع في فرع، بقيت الفروع الأخرى دارات مغلقة مستقلّة، فتظلّ مصابيحها **مضيئة عادةً**.
- **كلّ مصباح يضيء بكامل شدّته**: كأنّه وحده في الدارة، فإضاءته **أقوى** من إضاءة مصباح متسلسل في المجموعة نفسها.
- **يمكن التحكّم في كلّ فرع على حدة**: قاطع موضوع على فرع واحد يتحكّم في مصباح ذلك الفرع فقط دون سواه.

> 🗡️ **إنارة المنازل مركّبة بالتفرّع**: لذلك يعمل كلّ مصباح ويُطفأ باستقلال عن غيره، ويبقى بقية البيت مضيئًا حين ينطفئ مصباح غرفة واحدة.

## ⚖️ جدول المقارنة: تسلسل أم تفرّع؟

| المعيار                             | التركيب بالتسلسل       | التركيب بالتفرّع              |
| ----------------------------------- | ---------------------- | ----------------------------- |
| عدد مسارات التيّار                  | مسار واحد (حلقة وحيدة) | عدّة مسارات (فروع متوازية)    |
| إطفاء/احتراق مصباح واحد             | ينطفئ الجميع           | تبقى البقية مضيئة             |
| إضاءة كلّ مصباح مقارنةً بمصباح وحيد | أضعف                   | بنفس الشدّة (أقوى من التسلسل) |
| مثال من الحياة                      | سلسلة أضواء عيد قديمة  | إنارة المنازل                 |

> ⚠️ الخطأ الشائع: عكس القاعدتَين. تذكّر: **تسلسل ⇐ مصير مشترك** (ينطفئ الجميع بعطب واحد)؛ **تفرّع ⇐ استقلال** (كلّ فرع بمفرده).

## 🏆 خلاصة

أصبحت الآن تميّز مكوّنات الدارة ورموزها، وتفرّق بين الدارة المفتوحة والمغلقة، وتصنّف الموادّ إلى ناقلة وعازلة، والأهمّ: تعرف الفرق الجوهري بين **التركيب بالتسلسل** (مسار وحيد، مصير مشترك، إضاءة أضعف) و**التركيب بالتفرّع** (مسارات متعدّدة، فروع مستقلّة، إضاءة كاملة). صرت تفهم لماذا تُنار بيوتنا بالتفرّع — استعدّ لتحدّيات هذا الفصل! 🚀', '# 📜 ملخّص: الدارة الكهربائية — التركيب بالتسلسل والتفرّع

- **مكوّنات الدارة**: المولّد (يزوّد بالطاقة، قطبان + و−)، المستقبل (مصباح أو محرّك)، القاطع (يفتح/يغلق الدارة)، وأسلاك التوصيل. رموز اصطلاحية: خطّان متفاوتا الطول للمولّد، دائرة بها × للمصباح، دائرة بها M للمحرّك، خطّ منقطع للقاطع المفتوح ومتّصل للمغلق.
- **مفتوحة/مغلقة**: دارة مغلقة (لا انقطاع) = تيّار يجري = المستقبل يعمل؛ دارة مفتوحة (انقطاع في نقطة واحدة على الأقلّ) = لا تيّار = المستقبل متوقّف.
- **ناقلة/عازلة**: الناقلة تمرّر التيّار — معظم المعادن (نحاس، ألمنيوم، حديد) والماء المالح وجسم الإنسان؛ العازلة تمنعه — البلاستيك، المطّاط، الخشب الجافّ، الزجاج، الهواء الجافّ.
- **التركيب بالتسلسل**: حلقة واحدة، مسار وحيد للتيّار. إطفاء أو احتراق مصباح واحد يُطفئ **الجميع**؛ كلّما زاد عدد المصابيح قلّت إضاءة كلّ منها؛ قاطع واحد يتحكّم في الكلّ. مثال: سلسلة أضواء العيد القديمة.
- **التركيب بالتفرّع**: فروع منفصلة بين نقطتَي تفرّع، عدّة مسارات. إطفاء مصباح فرع لا يؤثّر في البقية (تبقى مضيئة)؛ كلّ مصباح يضيء بكامل شدّته (أقوى من التسلسل)؛ يمكن التحكّم في كلّ فرع على حدة. مثال: إنارة المنازل.
- **القاعدة**: تسلسل ⇐ مصير مشترك؛ تفرّع ⇐ استقلال الفروع.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', 'شدّة التيار الكهربائي', 'التيار الكهربائي ومنحاه الاصطلاحي (من القطب الموجب إلى القطب السالب خارج المولّد)، شدّة التيار وقيسها بالأمبيرمتر (وحدتها الأمبير A والمليأمبير mA، والتركيب بالتسلسل واحترام القطبين)، توزيع التيار في دارة بالتسلسل حيث الشدّة نفسها في كلّ نقطة، وتوزيع التيار في دارة متفرّعة وفق قانون العقد I = I1 + I2', '# ⚔️ شدّة التيار الكهربائي — كم يجري في السلك؟

> 💡 «مصباحان في المنزل: أحدهما يضيء بقوّة والآخر خافت. القاطع مغلق في الحالتين والتيّار يجري، فما الذي يختلف بينهما؟ الجواب هو شدّة التيّار الكهربائي: كمّية تُقاس بجهاز خاصّ، ولها قواعد دقيقة في توزيعها داخل الدارة. تعلّم كيف نقيسها بالأمبيرمتر، وكيف تتوزّع في دارة بالتسلسل وفي دارة متفرّعة.»

## 🏰 التيار الكهربائي ومنحاه الاصطلاحي

عندما تُغلَق الدارة، يجري فيها **تيّار كهربائي**: انتقال منظّم للشحنات الكهربائية داخل الأسلاك والعناصر، وهو الذي يشغّل المصباح والمحرّك. لكنّ التيّار ليس عشوائي الاتّجاه، بل له **منحى** محدّد.

اتّفق العلماء على **المنحى الاصطلاحي للتيّار**: خارج المولّد، يجري التيّار في الدارة **من القطب الموجب (+) إلى القطب السالب (−)** عبر أسلاك التوصيل والمستقبلات. أي إنّه يخرج من القطب الموجب للمولّد، يمرّ عبر المصباح والقاطع والأسلاك، ثمّ يعود إلى القطب السالب.

| العنصر          | ما يخصّ المنحى                                                           |
| --------------- | ------------------------------------------------------------------------ |
| **المنحى**      | من القطب (+) نحو القطب (−) خارج المولّد ; اتّجاه واحد ثابت في كلّ الحلقة |
| **قلب المولّد** | إذا عكسنا قطبَي المولّد، انعكس منحى التيّار في الدارة كلّها              |
| **تمثيله**      | سهم صغير على أحد الأسلاك يشير إلى منحى جريان التيّار                     |

> 🗡️ المنحى الاصطلاحي **اتّفاق** ثابت: من (+) إلى (−) خارج المولّد. لا تخلط بينه وبين شدّة التيّار: المنحى يخبرنا بالاتّجاه، أمّا الشدّة فتخبرنا بالمقدار (كم يجري).

## ⚡ شدّة التيار الكهربائي وقيسها بالأمبيرمتر

**شدّة التيّار الكهربائي** مقدار فيزيائي يعبّر عن «كمّية» التيّار الذي يجري في الدارة. نرمز إليها بالحرف **I**، ونقيسها بجهاز اسمه **الأمبيرمتر** (رمزه دائرة بداخلها الحرف A).

**وحدة القيس** هي **الأمبير**، رمزها **A**. وللتيّارات الضعيفة نستعمل مضاعِفًا جزئيًّا هو **المليأمبير**، رمزه **mA**، حيث:

$$1 A = 1000 mA$$

للتحويل: نضرب في 1000 عند الانتقال من A إلى mA، ونقسم على 1000 عند الانتقال من mA إلى A. مثال: 0.25 A = 250 mA ; و 80 mA = 0.08 A.

**كيف نركّب الأمبيرمتر؟** قاعدتان أساسيتان:

1. **يُركّب دائمًا بالتسلسل** مع العنصر الذي نريد قيس شدّة التيّار المارّ فيه. أي نقطع الدارة في تلك النقطة ونُدخِل الأمبيرمتر ليمرّ التيّار **من خلاله**.
2. **نحترم قطبَيه**: نربط المربط المؤشَّر بعلامة (+) في جهة تصل نحو القطب الموجب للمولّد، والمربط المؤشَّر بعلامة (−) أو COM في الجهة الأخرى. إذا عكسنا الربط، أظهر الأمبيرمتر الرقمي إشارة سالبة (−) أمام العدد.

> ⚠️ الخطأ الأخطر: تركيب الأمبيرمتر **بالتفرّع** (على التوازي) مع مصباح مثلًا. الأمبيرمتر مقاومته ضعيفة جدًّا، فتركيبه بالتفرّع يُحدث ما يشبه دارة قصيرة قد تتلفه. **الأمبيرمتر يُركّب بالتسلسل دائمًا، أبدًا بالتفرّع.**

<svg viewBox="0 0 300 200">
<title>الأمبيرمتر يُركّب بالتسلسل ليمرّ التيّار من خلاله</title>
<line x1="50" y1="55" x2="50" y2="101.5" stroke="#0f172a" stroke-width="2.5"/><line x1="50" y1="110.5" x2="50" y2="158" stroke="#0f172a" stroke-width="2.5"/><line x1="33" y1="101.5" x2="67" y2="101.5" stroke="#0f172a" stroke-width="2.5"/><line x1="42" y1="110.5" x2="58" y2="110.5" stroke="#0f172a" stroke-width="5.5"/><line x1="50" y1="55" x2="135" y2="55" stroke="#0f172a" stroke-width="2.5"/><line x1="165" y1="55" x2="258" y2="55" stroke="#0f172a" stroke-width="2.5"/><circle cx="150" cy="55" r="15" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="139.39" y1="44.39" x2="160.61" y2="65.61" stroke="#0f172a" stroke-width="2.5"/><line x1="139.39" y1="65.61" x2="160.61" y2="44.39" stroke="#0f172a" stroke-width="2.5"/><line x1="258" y1="55" x2="258" y2="158" stroke="#0f172a" stroke-width="2.5"/><line x1="258" y1="158" x2="166" y2="158" stroke="#0f172a" stroke-width="2.5"/><line x1="134" y1="158" x2="50" y2="158" stroke="#0f172a" stroke-width="2.5"/><circle cx="150" cy="158" r="16" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><text x="150" y="164" text-anchor="middle" fill="#0f172a" font-size="17" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">A</text><line x1="95" y1="55" x2="125" y2="55" stroke="#64748b" stroke-width="2"/><polygon points="125,55 117,59 117,51" fill="#64748b"/><line x1="210" y1="158" x2="185" y2="158" stroke="#64748b" stroke-width="2"/><polygon points="185,158 193,154 193,162" fill="#64748b"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="50" y="106" text-anchor="end" fill="#0f172a" font-size="12">المولّد</text><text x="72" y="99.5" text-anchor="start" fill="#0f172a" font-size="15">+</text><text x="68" y="122.5" text-anchor="start" fill="#0f172a" font-size="15">−</text><text x="150" y="33" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="172" y="152" text-anchor="start" fill="#ef4444" font-size="13">+</text><text x="128" y="152" text-anchor="end" fill="#ef4444" font-size="13">−</text><text x="150" y="180" text-anchor="middle" fill="#0f172a" font-size="12">الأمبيرمتر بالتسلسل مع المصباح</text></g>
</svg>

> 🗡️ لاختيار وحدة القيس المناسبة: إذا كان التيّار قويًّا نقرأ بالأمبير (A)، وإذا كان ضعيفًا نقرأ بالمليأمبير (mA). تذكّر دائمًا: 1 A = 1000 mA، فالعدد بالمليأمبير أكبر بألف مرّة من نظيره بالأمبير.

## 🔗 توزيع التيار في دارة بالتسلسل

في **الدارة بالتسلسل**، تُوصَل العناصر واحدًا تلو الآخر في حلقة واحدة، دون أيّ تفرّع. السؤال: هل شدّة التيّار هي نفسها في كلّ مكان، أم تنقص كلّما مرّت عبر مصباح؟

**القاعدة (وحدانية شدّة التيّار في التسلسل)**: في دارة بالتسلسل، **شدّة التيّار هي نفسها في كلّ نقاط الدارة**. لو ركّبنا أمبيرمترًا قبل المصباح الأوّل، وآخر بعده، وثالثًا قبل المولّد، لقرأت الأجهزة الثلاثة **العدد نفسه بالضبط**.

- التيّار **لا يُستهلَك** ولا يَنقُص وهو يمرّ عبر المصابيح: المصباح يحوّل الطاقة إلى ضوء، لكنّ شدّة التيّار المارّة فيه تبقى ثابتة على طول الحلقة.
- إذا أضفنا مصباحًا ثانيًا بالتسلسل، تنقص شدّة التيّار في **كامل** الدارة (كلّ المصابيح تخفت معًا)، لكنّها تظلّ **متساوية** في كلّ النقاط.

> ⚠️ خطأ شائع جدًّا: الاعتقاد بأنّ شدّة التيّار «تضعف» أو «تُستهلَك» بعد كلّ مصباح، فتكون أكبر قبل المصباح وأصغر بعده. هذا **خاطئ تمامًا**: في التسلسل الشدّة **نفسها** قبل المصباح وبعده وفي كلّ الحلقة.

> 🗡️ صورة مفيدة: تخيّل قطارًا يدور في حلقة واحدة. عدد العربات التي تمرّ في الثانية هو نفسه عند كلّ محطّة على الحلقة — لا تختفي عربة ولا تُضاف. كذلك شدّة التيّار في التسلسل: واحدة في كلّ نقطة.

## 🌿 توزيع التيار في دارة متفرّعة (قانون العقد)

في **الدارة المتفرّعة**، ينقسم مسار التيّار عند نقطة تسمّى **العقدة** إلى فرعين أو أكثر، ثمّ يلتقيان من جديد. مثال: مصباحان مركّبان بالتفرّع، لكلٍّ فرعه الخاصّ.

عند العقدة، ينقسم التيّار **الرئيسي** بين الفروع، ثمّ يتجمّع مرّة أخرى. القاعدة التي تحكم ذلك هي **قانون العقد** (قانون جمع الشدّات):

$$I = I1 + I2$$

<svg viewBox="0 0 300 200">
<title>قانون العقد: التيّار الرئيسي يساوي مجموع تيّارات الفروع</title>
<line x1="52" y1="100" x2="116" y2="100" stroke="#0f172a" stroke-width="2.5"/><line x1="72" y1="100" x2="100" y2="100" stroke="#ef4444" stroke-width="2.5"/><polygon points="100,100 91,104.5 91,95.5" fill="#ef4444"/><line x1="116" y1="100" x2="150" y2="58" stroke="#0f172a" stroke-width="2.5"/><line x1="150" y1="58" x2="214" y2="58" stroke="#0f172a" stroke-width="2.5"/><circle cx="186" cy="58" r="14" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="176.1" y1="48.1" x2="195.9" y2="67.9" stroke="#0f172a" stroke-width="2.5"/><line x1="176.1" y1="67.9" x2="195.9" y2="48.1" stroke="#0f172a" stroke-width="2.5"/><line x1="128" y1="90" x2="146" y2="66" stroke="#ef4444" stroke-width="2.5"/><polygon points="146,66 144.2,75.9 137,70.5" fill="#ef4444"/><line x1="116" y1="100" x2="150" y2="142" stroke="#0f172a" stroke-width="2.5"/><line x1="150" y1="142" x2="214" y2="142" stroke="#0f172a" stroke-width="2.5"/><circle cx="186" cy="142" r="14" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="176.1" y1="132.1" x2="195.9" y2="151.9" stroke="#0f172a" stroke-width="2.5"/><line x1="176.1" y1="151.9" x2="195.9" y2="132.1" stroke="#0f172a" stroke-width="2.5"/><line x1="128" y1="110" x2="146" y2="134" stroke="#ef4444" stroke-width="2.5"/><polygon points="146,134 137,129.5 144.2,124.1" fill="#ef4444"/><circle cx="116" cy="100" r="4" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="78" y="92" text-anchor="middle" fill="#ef4444" font-size="15">I</text><text x="132" y="74" text-anchor="start" fill="#ef4444" font-size="14">I1</text><text x="132" y="128" text-anchor="start" fill="#ef4444" font-size="14">I2</text><text x="108" y="104" text-anchor="end" fill="#0f172a" font-size="11">العقدة</text><text x="150" y="182" text-anchor="middle" fill="#0f172a" font-size="15">I = I1 + I2</text></g>
</svg>

**شدّة التيّار الرئيسي تساوي مجموع شدّات التيّارات في الفروع.** فما «يدخل» العقدة يساوي ما «يخرج» منها بالضبط: لا تضيع شحنة ولا تُخلَق.

أمثلة عددية:

- إذا كان I1 = 0.3 A ; و I2 = 0.5 A، فإنّ التيّار الرئيسي I = 0.3 + 0.5 = 0.8 A.
- إذا كان التيّار الرئيسي I = 0.6 A ; والفرع الأوّل I1 = 0.25 A، فإنّ الفرع الثاني I2 = I − I1 = 0.6 − 0.25 = 0.35 A.
- إن تفرّع التيّار إلى ثلاثة فروع، عُمّمت القاعدة: I = I1 + I2 + I3.

> ⚠️ خطأ شائع: تطبيق القانون بالطرح، كأن يُكتَب I = I1 − I2. القانون **جمع** لا طرح: التيّار الرئيسي دائمًا **أكبر** من كلّ فرع على حدة، لأنّه مجموعها. الطرح يُستعمل فقط لإيجاد فرع مجهول عندما نعرف الرئيسي وفرعًا آخر.

> 🗡️ في التفرّع، إن كان الفرعان متماثلَين تمامًا (مصباحان متطابقان)، انقسم التيّار الرئيسي بينهما بالتساوي: كلّ فرع يحمل نصف الشدّة الرئيسية. مثال: I = 1.2 A على فرعين متماثلَين ← كلّ فرع 0.6 A.

## 🏆 خلاصة الفصل

في هذا الفصل أتقنت شدّة التيّار الكهربائي:

- **المنحى الاصطلاحي**: من القطب (+) إلى القطب (−) خارج المولّد، وينعكس بقلب المولّد.
- **الشدّة وقيسها**: I تُقاس بالأمبيرمتر بوحدة الأمبير A (و mA للتيّارات الضعيفة، 1 A = 1000 mA)، ويُركّب الأمبيرمتر **بالتسلسل** مع احترام قطبَيه.
- **التوزيع في التسلسل**: شدّة التيّار **واحدة في كلّ نقطة**، لا تُستهلَك ولا تَنقُص عبر المصابيح.
- **التوزيع في التفرّع**: قانون العقد I = I1 + I2 ; فالتيّار الرئيسي يساوي مجموع تيّارات الفروع.

> 🏆 أصبحت الآن تعرف كيف يجري التيّار وبأيّ منحى، وكيف تقيس شدّته بأمان بالأمبيرمتر، وكيف تتوزّع الشدّة في دارة بالتسلسل وفي دارة متفرّعة. في السنة القادمة ستكتشف علاقة هذه الشدّة بالتوتّر عبر قانون أوم والمقاومة — لكنّك الآن تملك الأساس المتين!', '# 📜 ملخّص: شدّة التيار الكهربائي

- **المنحى الاصطلاحي للتيّار**: خارج المولّد، يجري التيّار من القطب الموجب (+) إلى القطب السالب (−) عبر المستقبلات والأسلاك ; منحى واحد ثابت في كلّ الحلقة، وينعكس إذا قلبنا قطبَي المولّد.
- **شدّة التيّار**: مقدار نرمز إليه بـ I يعبّر عن كمّية التيّار الجاري، نقيسه بـ **الأمبيرمتر** (دائرة بها A).
- **وحدة القيس**: الأمبير A، ومضاعِفه الجزئي المليأمبير mA، حيث 1 A = 1000 mA (مثال: 0.25 A = 250 mA).
- **تركيب الأمبيرمتر**: يُركّب **بالتسلسل** مع العنصر المراد قيسه (أبدًا بالتفرّع)، مع احترام قطبَيه (مربط + نحو القطب الموجب) وإلّا ظهرت إشارة سالبة.
- **التوزيع في التسلسل**: شدّة التيّار **هي نفسها في كلّ نقاط الدارة** ; لا تُستهلَك ولا تَنقُص عبر المصابيح. إضافة مصباح بالتسلسل تُنقص الشدّة في كامل الدارة لكنّها تبقى متساوية في كلّ مكان.
- **التوزيع في التفرّع (قانون العقد)**: I = I1 + I2 ; التيّار الرئيسي يساوي مجموع تيّارات الفروع، فهو دائمًا أكبر من كلّ فرع. لإيجاد فرع مجهول: I2 = I − I1.
- **فرعان متماثلان**: ينقسم التيّار الرئيسي بينهما بالتساوي (كلّ فرع نصف الشدّة الرئيسية).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', 'التوتّر الكهربائي وقيسه بالفولطمتر', 'مفهوم التوتّر الكهربائي بين طرفَي ثنائي قطب، قيس التوتّر بالفولطمتر (وحدته الفولط V) مع تركيبه بالتفرّع بين طرفَي الثنائي، وقانونا التوتّر: جمع التوترات في دارة بالتسلسل (U = U1 + U2) وتساوي التوتّر بين طرفَي فرعَين مركّبَين بالتفرّع (U1 = U2 = U)', '# ⚡ التوتّر الكهربائي — القوّة الخفيّة التي تدفع التيّار

> 💡 «في الفصل السابق قِستَ شدّة التيّار الذي يجري داخل الأسلاك. لكن ما الذي يدفع هذا التيّار للجريان أصلًا؟ إنّه التوتّر الكهربائي: الجهد الخفيّ الذي يولّده المولّد بين قطبَيه. اكتشف كيف تقيسه، وكيف يتوزّع في الدارات.»

## 🏰 ما هو التوتّر الكهربائي؟

**التوتّر الكهربائي** مقدار فيزيائي يوجد **بين نقطتَين** من الدارة، أي **بين طرفَي عنصر** (مولّد، مصباح، محرّك…). نسمّي كلّ عنصر له طرفان **ثنائي قطب**، ونتحدّث دائمًا عن **التوتّر بين طرفَي** ذلك الثنائي.

هنا يكمن الفرق الجوهري مع شدّة التيّار:

- **شدّة التيّار** تصف التيّار الذي **يعبُر** الثنائي (يمرّ من خلاله).
- **التوتّر** يصف ما يوجد **بين طرفَي** الثنائي (بين نقطتَين)، لا ما يعبُره.

يُرمز إلى التوتّر بالحرف **U**، ووحدته الدولية هي **الفولط**، ورمزها **V**.

> 🗡️ تشبيه مفيد: تخيّل شلّالًا. **التوتّر** يشبه ارتفاع الشلّال (الفارق بين الأعلى والأسفل) الذي يدفع الماء للسقوط، بينما **شدّة التيّار** تشبه كمّية الماء التي تسقط فعلًا في الثانية. لا ماء يجري بلا ارتفاع، ولا تيّار يجري بلا توتّر.

## 🔋 التوتّر بين قطبَي المولّد وبين طرفَي مستقبل

**المولّد** (عمود أو بطّارية) هو مصدر التوتّر في الدارة: يحافظ على توتّر ثابت بين قطبَيه الموجب (+) والسالب (−)، **حتّى وهو معزول والدارة مفتوحة**. هذا التوتّر هو ما يدفع التيّار للجريان بمجرّد غلق الدارة.

- التوتّر بين **قطبَي المولّد** يُكتب مثلًا 4,5 V أو 6 V أو 9 V حسب المولّد.
- التوتّر بين **طرفَي مستقبل** (مصباح، محرّك) هو نصيب ذلك المستقبل من توتّر المولّد.
- التوتّر بين طرفَي **سلك توصيل** بسيط ضئيل جدًّا، نعتبره **≈ 0 V**.

> ⚠️ خطأ شائع: الظنّ أنّ المولّد «ينتج توتّرًا فقط عندما يجري التيّار». في الحقيقة يوجد توتّر بين قطبَي المولّد حتّى قبل غلق الدارة؛ هذا التوتّر هو **سبب** جريان التيّار، لا نتيجته.

## 🧰 قيس التوتّر بالفولطمتر

نقيس التوتّر بجهاز اسمه **الفولطمتر** (قد يكون رقميًّا أو ذا إبرة)، ووحدة القيس هي **الفولط (V)**.

القاعدة الأهمّ في هذا الفصل:

> 🗡️ يُركَّب الفولطمتر **بالتفرّع** (بالتوازي) **بين طرفَي** الثنائي الذي نريد قيس توتّره؛ **لا يُركَّب أبدًا بالتسلسل**. لقيس توتّر مصباح مثلًا، نصل طرفَي الفولطمتر مباشرةً بطرفَي المصباح دون قطع الدارة.

<svg viewBox="0 0 300 200">
<title>الفولطمتر يُركّب بالتفرّع بين طرفَي المصباح</title>
<line x1="52" y1="78" x2="52" y2="118.5" stroke="#0f172a" stroke-width="2.5"/><line x1="52" y1="127.5" x2="52" y2="168" stroke="#0f172a" stroke-width="2.5"/><line x1="35" y1="118.5" x2="69" y2="118.5" stroke="#0f172a" stroke-width="2.5"/><line x1="44" y1="127.5" x2="60" y2="127.5" stroke="#0f172a" stroke-width="5.5"/><line x1="52" y1="78" x2="136" y2="78" stroke="#0f172a" stroke-width="2.5"/><line x1="168" y1="78" x2="252" y2="78" stroke="#0f172a" stroke-width="2.5"/><circle cx="152" cy="78" r="16" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><line x1="140.69" y1="66.69" x2="163.31" y2="89.31" stroke="#0f172a" stroke-width="2.5"/><line x1="140.69" y1="89.31" x2="163.31" y2="66.69" stroke="#0f172a" stroke-width="2.5"/><line x1="252" y1="78" x2="252" y2="168" stroke="#0f172a" stroke-width="2.5"/><line x1="252" y1="168" x2="52" y2="168" stroke="#0f172a" stroke-width="2.5"/><line x1="118" y1="78" x2="118" y2="30" stroke="#0f172a" stroke-width="2.5"/><line x1="118" y1="30" x2="136" y2="30" stroke="#0f172a" stroke-width="2.5"/><line x1="186" y1="78" x2="186" y2="30" stroke="#0f172a" stroke-width="2.5"/><line x1="186" y1="30" x2="168" y2="30" stroke="#0f172a" stroke-width="2.5"/><circle cx="152" cy="30" r="16" fill="#fff" stroke="#0f172a" stroke-width="2.5"/><text x="152" y="36" text-anchor="middle" fill="#0f172a" font-size="17" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">V</text><circle cx="118" cy="78" r="3.6" fill="#0f172a"/><circle cx="186" cy="78" r="3.6" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="52" y="123" text-anchor="end" fill="#0f172a" font-size="12">المولّد</text><text x="74" y="116.5" text-anchor="start" fill="#0f172a" font-size="15">+</text><text x="70" y="139.5" text-anchor="start" fill="#0f172a" font-size="15">−</text><text x="152" y="108" text-anchor="middle" fill="#0f172a" font-size="12">مصباح</text><text x="131" y="24" text-anchor="end" fill="#ef4444" font-size="13">+</text><text x="173" y="24" text-anchor="start" fill="#ef4444" font-size="13">−</text><text x="152" y="188" text-anchor="middle" fill="#0f172a" font-size="12">الفولطمتر بالتفرّع بين طرفَي المصباح</text></g>
</svg>

كيفية التوصيل الصحيح:

- نصل المربط المعلَّم **COM** بالجهة القريبة من القطب السالب (−).
- نصل المربط المعلَّم **V** بالجهة القريبة من القطب الموجب (+).
- إذا عكسنا التوصيل، يعرض الفولطمتر الرقمي **قيمة سالبة** (وتنحرف إبرة الفولطمتر ذي الإبرة في الاتّجاه المعاكس).

من مضاعفات وأجزاء الفولط: 1 kV = 1000 V ؛ 1 V = 1000 mV.

> ⚠️ لا تخلط بين الجهازَين: **الأمبيرمتر** يقيس شدّة التيّار ويُركَّب **بالتسلسل**، أمّا **الفولطمتر** فيقيس التوتّر ويُركَّب **بالتفرّع**. تركيب الفولطمتر بالتسلسل خطأ يمنع القيس الصحيح.

## 🔗 التوتّر في دارة بالتسلسل: الجمع

عندما تُركَّب عدّة مستقبلات **بالتسلسل** (في حلقة واحدة، الواحد تلو الآخر)، يتوزّع توتّر المولّد بينها. القانون:

$$ U = U1 + U2 + U3 $$

أي أنّ **التوتّر بين قطبَي المولّد يساوي مجموع التوترات بين طرفَي كلّ مستقبل**.

_مثال:_ مولّد توتّره 9 V يغذّي مصباحَين بالتسلسل. إذا كان التوتّر بين طرفَي المصباح الأوّل 5 V، فإنّ التوتّر بين طرفَي المصباح الثاني هو 9 − 5 = 4 V.

> 🗡️ في التركيب بالتسلسل: **شدّة التيّار واحدة** في كلّ نقطة، لكنّ **التوتّر يتوزّع ويُجمع**. لا تنقل خاصية شدّة التيّار إلى التوتّر.

## 🌿 التوتّر في دارة متفرّعة: التساوي

عندما يُركَّب مستقبلان (أو أكثر) **بالتفرّع** (كلّ واحد في فرع مستقلّ بين نفس النقطتَين)، يكون **التوتّر بين طرفَي كلّ فرع واحدًا ومتساويًا**:

$$ U1 = U2 = U $$

_مثال:_ مولّد توتّره 6 V يغذّي مصباحَين مركّبَين بالتفرّع. التوتّر بين طرفَي كلّ مصباح هو 6 V نفسه، وليس نصفه.

> ⚠️ خطأ شائع: الظنّ أنّ التوتّر «ينقسم» بين الفرعَين في التركيب بالتفرّع (3 V لكلّ مصباح مثلًا). هذا خطأ: التوتّر بين طرفَي الفرعَين **متساوٍ** ويساوي توتّر المصدر بينهما.

## ⚖️ لا تخلط بين التوتّر وشدّة التيّار

هذا الجدول هو مفتاح الفصل كلّه — لاحظ كيف «يتبادل» المقداران سلوكهما بين التسلسل والتفرّع:

| المقارنة       | شدّة التيّار (I، بالأمبير A)  | التوتّر (U، بالفولط V)        |
| -------------- | ----------------------------- | ----------------------------- |
| ماذا يصف؟      | ما **يعبُر** الثنائي          | ما يوجد **بين طرفَي** الثنائي |
| جهاز القيس     | الأمبيرمتر (**بالتسلسل**)     | الفولطمتر (**بالتفرّع**)      |
| في **التسلسل** | **واحدة** في كلّ نقطة         | **تُجمع**: U = U1 + U2        |
| في **التفرّع** | **تُجمع** (تتوزّع على الفروع) | **متساوٍ**: U1 = U2 = U       |

> ⚠️ الفخّ الأكبر في الامتحان: أن تظنّ «التوتّر واحد في كلّ مكان في التسلسل» لأنّ شدّة التيّار كذلك. العكس هو الصحيح: في التسلسل شدّة التيّار واحدة والتوتّر يُجمع، وفي التفرّع التوتّر متساوٍ وشدّة التيّار تُجمع.

## 🏆 خلاصة رحلتك

أحسنت أيّها البطل! لقد أمسكتَ الآن بالقوّة الخفيّة وراء كلّ دارة:

- **التوتّر U** مقدار بين طرفَي ثنائي قطب، وحدته **الفولط (V)**، يقيسه **الفولطمتر** المركَّب **بالتفرّع**.
- في **التسلسل** يُجمع التوتّر: U = U1 + U2، وفي **التفرّع** يتساوى: U1 = U2 = U.
- شدّة التيّار والتوتّر مقداران مختلفان يتبادلان سلوكهما بين التسلسل والتفرّع — لا تخلط بينهما.

> 🏆 بهذا تكون قد أتقنت مقداري الكهرباء الأساسيَّين: الشدّة والتوتّر. أنت الآن جاهز لتحدّيات هذا الفصل، ومستعدّ لِما هو أعمق في السنة القادمة حين نربط بينهما بعلاقة واحدة قويّة!', '# 📜 ملخّص: التوتّر الكهربائي وقيسه بالفولطمتر

- **مفهوم التوتّر**: مقدار فيزيائي يوجد **بين طرفَي ثنائي قطب** (بين نقطتَين)، لا ما يعبُره؛ يُرمز إليه بالحرف **U** ووحدته **الفولط (V)**. (شدّة التيّار تصف ما يعبُر الثنائي، أمّا التوتّر فما يوجد بين طرفَيه.)
- **المولّد مصدر التوتّر**: يحافظ على توتّر بين قطبَيه (+) و(−) حتّى والدارة مفتوحة، وهو ما يدفع التيّار للجريان. توتّر سلك التوصيل ≈ 0 V.
- **قيس التوتّر**: بجهاز **الفولطمتر** (رقمي أو ذي إبرة)، وحدته الفولط V. يُركَّب **بالتفرّع بين طرفَي** الثنائي، **لا بالتسلسل**؛ المربط COM جهة السالب والمربط V جهة الموجب. عكس التوصيل يعرض قيمة سالبة. (1 V = 1000 mV ؛ 1 kV = 1000 V.)
- **التوتّر في التسلسل — الجمع**: التوتّر بين قطبَي المولّد يساوي مجموع التوترات بين طرفَي المستقبلات: U = U1 + U2 + U3. مثال: مولّد 9 V ومصباح أوّل 5 V ⟵ المصباح الثاني 9 − 5 = 4 V.
- **التوتّر في التفرّع — التساوي**: التوتّر بين طرفَي الفروع المركّبة بالتفرّع واحد ومتساوٍ: U1 = U2 = U. مثال: مولّد 6 V ومصباحان بالتفرّع ⟵ كلّ مصباح 6 V (لا ينقسم).
- **لا تخلط بين المقدارَين**: في التسلسل شدّة التيّار **واحدة** والتوتّر **يُجمع**؛ في التفرّع التوتّر **متساوٍ** وشدّة التيّار **تُجمع**. الأمبيرمتر بالتسلسل، والفولطمتر بالتفرّع.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('92d2d0c9-9e2f-59f1-b4c5-25d4c87a350d', '149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'لماذا يُعدّ ماء البحر خليطًا لا ماءً نقيًّا؟', '[{"id":"a","text":"لأنّه يحتوي على ملح مذاب وأملاح أخرى مذابة فيه"},{"id":"b","text":"لأنّه ماء صافٍ لا يحمل أيّ مادّة أخرى"},{"id":"c","text":"لأنّه يتجمّد بسرعة أكبر من غيره"},{"id":"d","text":"لأنّ لونه أزرق فقط"}]'::jsonb, 'a', 'ماء البحر مالح لأنّه خليط يحتوي على ملح وأملاح معدنية مذابة فيه؛ فماء الطبيعة في الغالب خليط لا ماء نقيّ.', 1, 'mcq', NULL, NULL)
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
  ('ef121adf-facc-5c57-bf1d-0d790967bed6', '149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'ما تعريف الخليط المتجانس؟', '[{"id":"a","text":"خليط نميّز فيه مكوّنَين على الأقلّ بالعين المجرّدة"},{"id":"b","text":"خليط موحّد المظهر لا نميّز مكوّناته بالعين المجرّدة"},{"id":"c","text":"خليط يحتوي دائمًا على جسم صلب عالق"},{"id":"d","text":"خليط لا يحتوي إلّا على الماء وحده"}]'::jsonb, 'b', 'الخليط المتجانس موحّد المظهر في كلّ نقطة منه، فلا نستطيع تمييز مكوّناته بالعين المجرّدة، كماء وسكّر مذاب تمامًا.', 2, 'mcq', NULL, NULL)
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
  ('6b3ae64c-17ba-55ad-bb9c-debccf317819', '149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'في كأس شاي مُحلّى بالسكّر، ما هو المذاب وما هو المذيب؟', '[{"id":"a","text":"السكّر هو المذيب والماء هو المذاب"},{"id":"b","text":"الماء هو المذاب والسكّر هو المذيب"},{"id":"c","text":"السكّر هو المذاب والماء هو المذيب"},{"id":"d","text":"لا يوجد مذاب ولا مذيب في الشاي"}]'::jsonb, 'c', 'المذاب هو الجسم الذي يذوب ويختفي (السكّر)، والمذيب هو السائل الذي يُذيبه (الماء)؛ فالماء يُذيب السكّر.', 3, 'mcq', NULL, NULL)
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
  ('6143b8f2-695a-5943-a326-804ad37bfa5a', '149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'أذبنا سكّرًا في كأس ماء فاختفى عن العين. ماذا حدث للسكّر؟', '[{"id":"a","text":"زال السكّر نهائيًّا ولم يعد له وجود"},{"id":"b","text":"تحوّل السكّر إلى ماء"},{"id":"c","text":"توزّع السكّر في الماء ويمكن استرجاعه بتبخير الماء"},{"id":"d","text":"تصاعد السكّر في الهواء على شكل بخار"}]'::jsonb, 'c', 'المذاب لا يزول عند الذوبان، بل يتوزّع في الماء على شكل جسيمات دقيقة؛ ويمكن استرجاعه جافًّا بتبخير الماء، والكتلة محفوظة.', 4, 'mcq', NULL, NULL)
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
  ('5c3adcb5-8444-5204-9cc0-709403bee79e', '149ff0b0-1897-54bd-ba40-c6a6b26c8655', 'واصل تلميذ إضافة الملح إلى كأس ماء إلى أن بقي فائض من الملح مستقرًّا في القاع لا يذوب مهما حرّك. ماذا نسمّي هذا المحلول؟', '[{"id":"a","text":"محلول مشبع"},{"id":"b","text":"خليط غير متجانس دائمًا"},{"id":"c","text":"ماء نقيّ"},{"id":"d","text":"محلول منصهر"}]'::jsonb, 'a', 'عند بلوغ الحدّ الأقصى للذوبان، لا يذوب الفائض ويتراكم في القاع، فيصبح المحلول مشبعًا؛ والتحريك يُسرّع الذوبان فقط ولا يزيد الكمّية القصوى.', 5, 'mcq', NULL, NULL)
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
  ('3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '🛡️ تدريب المبتدئ ⭐: الخلائط والذوبان', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b7b15f39-5ad5-560b-a97d-d48ca1ed9bb8', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'ماء الوادي العكر تظهر فيه حبيبات طين بالعين المجرّدة. ما نوع هذا الخليط؟', '[{"id":"a","text":"خليط متجانس"},{"id":"b","text":"خليط غير متجانس"},{"id":"c","text":"ماء نقيّ"},{"id":"d","text":"محلول مشبع"}]'::jsonb, 'b', 'بما أنّنا نميّز حبيبات الطين بالعين المجرّدة، فالخليط غير متجانس؛ الخليط المتجانس موحّد المظهر لا نميّز مكوّناته.', 1, 'mcq', NULL, NULL)
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
  ('2a847e44-2edd-5c07-abb0-e027eaa9245a', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'في محلول مكوّن من ماء وسكّر مذاب، ما هو المذيب؟', '[{"id":"a","text":"السكّر"},{"id":"b","text":"الملح"},{"id":"c","text":"الماء"},{"id":"d","text":"الهواء"}]'::jsonb, 'c', 'المذيب هو السائل الذي يُذيب المذاب؛ وهنا الماء هو الذي يُذيب السكّر، فالماء هو المذيب.', 2, 'mcq', NULL, NULL)
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
  ('f7a8007a-0a1b-5dd4-b7c1-8c779deca5c8', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'أيّ ممّا يلي خليط متجانس؟', '[{"id":"a","text":"ماء + ملح مذاب تمامًا"},{"id":"b","text":"ماء + رمل"},{"id":"c","text":"ماء + زيت"},{"id":"d","text":"ماء + حبيبات طين عالقة"}]'::jsonb, 'a', 'ماء + ملح مذاب تمامًا خليط متجانس موحّد المظهر لا نميّز فيه الملح؛ أمّا الرمل والزيت والطين فتبقى مكوّناتها ظاهرة، فالخليط غير متجانس.', 3, 'mcq', NULL, NULL)
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
  ('11c5289a-2979-59b0-9c63-55ceb3b483fb', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'ما اسم الجسم الذي يذوب فيختفي عن العين داخل المذيب؟', '[{"id":"a","text":"المذيب"},{"id":"b","text":"المحلول"},{"id":"c","text":"الراسب"},{"id":"d","text":"المذاب"}]'::jsonb, 'd', 'المذاب هو الجسم الذي يذوب ويختفي عن العين المجرّدة داخل المذيب، مثل السكّر أو الملح في الماء.', 4, 'mcq', NULL, NULL)
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
  ('2402e398-2947-5e15-a5f3-548070c9f966', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'كأس شاي مُحلّى شفّاف لكنّ لونه بنّي. هل هو خليط متجانس؟', '[{"id":"a","text":"نعم، فهو موحّد المظهر واللون لا يمنع التجانس"},{"id":"b","text":"لا، لأنّه ملوّن فهو غير متجانس"},{"id":"c","text":"لا، لأنّه يحتوي على سكّر"},{"id":"d","text":"لا يمكن الحكم على نوعه إطلاقًا"}]'::jsonb, 'a', 'الخليط المتجانس قد يكون شفّافًا ملوّنًا (كالشاي)؛ ما دام موحّد المظهر في كلّ نقطة فهو متجانس، واللون لا ينفي ذلك.', 5, 'mcq', NULL, NULL)
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
  ('6bf4c3c9-2c25-5cb2-aa04-bc9efeb7af3c', '3d93c7c8-42e0-565b-9e1a-69df1ed5c2bb', 'أذبنا ملحًا في ماء فاختفى عن العين. كيف نتأكّد أنّه ما زال موجودًا؟', '[{"id":"a","text":"لأنّه استحال ماءً فلم يعد ملحًا"},{"id":"b","text":"لا يمكن التأكّد فقد زال نهائيًّا"},{"id":"c","text":"نتذوّق ملوحة الماء، أو نبخّر الماء فيبقى الملح الجافّ"},{"id":"d","text":"نبرّد الكأس حتّى يتجمّد"}]'::jsonb, 'c', 'المذاب لا يزول: نتذوّق ملوحته في كلّ الكأس، ونسترجعه جافًّا بتبخير الماء؛ فالكتلة محفوظة والملح موجود وإن غاب عن العين.', 6, 'mcq', NULL, NULL)
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
  ('e13d7a29-84cc-5363-a046-b776d28bad6d', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: أسرار الذوبان', 3, 120, 30, 'boss', 'admin', 2)
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
  ('344bea5f-a3a7-5cc7-b235-02e6910f9916', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'يُلقّب الماء بـ«المذيب الشامل». ماذا يعني ذلك؟', '[{"id":"a","text":"أنّه يذيب كلّ مادّة بكمّية لا حدود لها"},{"id":"b","text":"أنّه لا يذيب أيّ مادّة إطلاقًا"},{"id":"c","text":"أنّه أثقل السوائل جميعًا"},{"id":"d","text":"أنّه قادر على إذابة عدد كبير من المواد المختلفة"}]'::jsonb, 'd', 'الماء مذيب شامل لأنّه يذيب كثيرًا من المواد المختلفة (سكّر، ملح، غازات…)؛ لكنّ إذابته ليست بلا حدود، إذ يبلغ التشبّع عند حدّ أقصى.', 1, 'mcq', NULL, NULL)
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
  ('57e893d3-dc0c-562d-b8dc-945ad697a14c', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'أذبنا 20 g من الملح في 200 g من الماء ذوبانًا تامًّا. ما كتلة المحلول الناتج؟', '[{"id":"a","text":"200 g"},{"id":"b","text":"220 g"},{"id":"c","text":"180 g"},{"id":"d","text":"20 g"}]'::jsonb, 'b', 'الكتلة محفوظة أثناء الذوبان: كتلة المحلول = كتلة الماء + كتلة الملح = 200 g + 20 g = 220 g؛ فالمذاب لا يختفي بل يبقى ضمن المحلول.', 2, 'mcq', NULL, NULL)
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
  ('12cd22d8-2793-5cda-8053-d2dfd0a25557', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'ما الفرق بين ذوبان السكّر في الماء وانصهار مكعّب جليد؟', '[{"id":"a","text":"لا فرق بينهما، فكلاهما الاسم نفسه"},{"id":"b","text":"كلاهما يحتاج إلى مذيب سائل"},{"id":"c","text":"الذوبان اختفاء مذاب داخل مذيب سائل، أمّا الانصهار فتحوّل جسم صلب إلى سائل بالتسخين"},{"id":"d","text":"الانصهار يحتاج مذيبًا والذوبان يحتاج تسخينًا دائمًا"}]'::jsonb, 'c', 'الذوبان هو اختفاء مذاب (سكّر) داخل مذيب سائل (ماء)، ولا يحتاج بالضرورة إلى تسخين؛ أمّا الانصهار فهو تحوّل جسم صلب إلى سائل بفعل الحرارة (جليد يصير ماءً)، دون أيّ مذيب.', 3, 'mcq', NULL, NULL)
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
  ('7d979e72-dd3e-5f2a-aedb-aea243e04f3f', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'يظنّ تلميذ أنّ السكّر يزول نهائيًّا عند ذوبانه لأنّه لم يعد يراه. كيف تصحّح له فكرته؟', '[{"id":"a","text":"السكّر لم يزل بل توزّع في الماء، والدليل بقاء طعمه واسترجاعه بالتبخير وحفظ الكتلة"},{"id":"b","text":"فكرته صحيحة، السكّر يزول فعلًا ولا يبقى منه شيء"},{"id":"c","text":"السكّر تحوّل كلّه إلى ماء إضافيّ"},{"id":"d","text":"السكّر صعد إلى الهواء على شكل بخار"}]'::jsonb, 'a', 'المذاب لا يُعدم عند الذوبان بل يتوزّع في الماء على شكل جسيمات دقيقة لا تُرى؛ ويثبت وجوده الطعم واسترجاعه بالتبخير وحفظ كتلة المحلول.', 4, 'mcq', NULL, NULL)
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
  ('1c2b1c7a-dd06-5921-bbee-9b4c6b684ad3', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'كأس ماء بارد لم يعد يذيب مزيدًا من السكّر وتراكم الفائض في القاع. ما أفضل إجراء لإذابة قدر أكبر من السكّر؟', '[{"id":"a","text":"إضافة مزيد من السكّر إلى الكأس"},{"id":"b","text":"تسخين الماء، لأنّ ارتفاع الحرارة يرفع الحدّ الأقصى للذوبان"},{"id":"c","text":"تبريد الماء أكثر"},{"id":"d","text":"الاكتفاء بالتحريك لأنّه يرفع الكمّية القصوى القابلة للذوبان"}]'::jsonb, 'b', 'بلغ المحلول التشبّع، فإضافة سكّر أو تحريكه لن يذيب الفائض؛ رفع درجة الحرارة يرفع الحدّ الأقصى للذوبان، فيذوب قدر أكبر من السكّر في الماء الساخن.', 5, 'mcq', NULL, NULL)
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
  ('a4655089-78b1-5da1-b0df-d4ea21b17f3b', 'e13d7a29-84cc-5363-a046-b776d28bad6d', 'محلول ماء وشراب (سيروب) أحمر شفّاف موحّد المظهر في كلّ نقطة منه. كيف نصنّفه؟', '[{"id":"a","text":"خليط غير متجانس لأنّه ملوّن بالأحمر"},{"id":"b","text":"ماء نقيّ لا يحتوي على أيّ مادّة"},{"id":"c","text":"خليط غير متجانس لأنّه يحتوي على راسب في القاع"},{"id":"d","text":"خليط متجانس، فاللون الأحمر لا يمنع التجانس ما دام شفّافًا موحّد المظهر"}]'::jsonb, 'd', 'الخليط الشفّاف الموحّد المظهر متجانس ولو كان ملوّنًا؛ لا راسب ولا حبيبات ظاهرة فيه، فاللون وحده لا يجعله غير متجانس.', 6, 'mcq', NULL, NULL)
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
  ('9dea259c-cb54-52b9-9170-0dfc904e28bf', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '📖 مراجعة المحارب ⭐⭐: تثبيت المكتسبات', 2, 70, 15, 'practice', 'admin', 3)
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
  ('391f5a09-0936-59cc-a2c3-7cf8dafdca54', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'أيّ عبارة صحيحة عن ماء الطبيعة؟', '[{"id":"a","text":"يحتوي غالبًا على موادّ مذابة كالأملاح، فهو خليط لا ماء نقيّ"},{"id":"b","text":"هو دائمًا ماء نقيّ تمامًا خالٍ من أيّ مادّة"},{"id":"c","text":"لا يذيب أيّ مادّة على الإطلاق"},{"id":"d","text":"يتكوّن من الزيت فقط"}]'::jsonb, 'a', 'ماء الطبيعة في الغالب خليط: يحمل أملاحًا مذابة وغازات مذابة وأحيانًا موادّ عالقة؛ فهو ليس ماءً نقيًّا.', 1, 'mcq', NULL, NULL)
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
  ('7f0032aa-3294-5091-9fe8-715a6cd41f85', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'ما هو المحلول المائي؟', '[{"id":"a","text":"خليط غير متجانس فيه حبيبات ظاهرة دائمًا"},{"id":"b","text":"جسم صلب صافٍ"},{"id":"c","text":"خليط متجانس ناتج عن ذوبان مذاب في الماء"},{"id":"d","text":"غاز عديم اللون"}]'::jsonb, 'c', 'المحلول المائي هو الخليط المتجانس الناتج عن ذوبان مذاب في المذيب (الماء)، مثل ماء + سكّر مذاب.', 2, 'mcq', NULL, NULL)
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
  ('4ee85a30-742b-561c-b968-3e3495c56ea4', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'أضفنا سكّرًا إلى ماء وحرّكنا حتّى اختفى تمامًا. أيّ وصف صحيح للناتج؟', '[{"id":"a","text":"خليط غير متجانس تظهر فيه حبيبات السكّر"},{"id":"b","text":"محلول مائي متجانس مذيبه الماء ومذابه السكّر"},{"id":"c","text":"ماء نقيّ خالٍ من السكّر"},{"id":"d","text":"محلول مشبع بالضرورة"}]'::jsonb, 'b', 'بعد ذوبان السكّر تمامًا نحصل على محلول مائي متجانس؛ مذيبه الماء ومذابه السكّر، ولا يكون مشبعًا إلّا إذا بلغ الحدّ الأقصى للذوبان.', 3, 'mcq', NULL, NULL)
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
  ('a073a6c8-1544-5915-bb01-162cd6598de8', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'لماذا لا يُعدّ خليط الماء والزيت متجانسًا؟', '[{"id":"a","text":"لأنّ الزيت يذوب في الماء ذوبانًا تامًّا"},{"id":"b","text":"لأنّ الماء يذوب داخل الزيت"},{"id":"c","text":"لأنّه شفّاف موحّد المظهر تمامًا"},{"id":"d","text":"لأنّ قطيرات الزيت تبقى ظاهرة للعين المجرّدة فوق الماء"}]'::jsonb, 'd', 'الزيت لا يذوب في الماء، فتبقى قطيراته مرئية بالعين المجرّدة منفصلة فوقه؛ ولهذا يكون الخليط غير متجانس.', 4, 'mcq', NULL, NULL)
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
  ('e78bf373-908f-5a12-9b96-38867e1eef9e', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'ما دور التحريك بالملعقة عند إذابة السكّر في الماء؟', '[{"id":"a","text":"يُسرّع الذوبان دون أن يزيد الكمّية القصوى القابلة للذوبان"},{"id":"b","text":"يزيد الكمّية القصوى من السكّر بلا حدّ"},{"id":"c","text":"يمنع السكّر من الذوبان"},{"id":"d","text":"يحوّل السكّر إلى ملح"}]'::jsonb, 'a', 'التحريك يُسرّع الذوبان فقط؛ أمّا الكمّية القصوى التي يمكن أن تذوب فيحدّدها التشبّع (كمّية الماء ودرجة حرارته)، ولا يرفعها التحريك.', 5, 'mcq', NULL, NULL)
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
  ('25b27d8e-ff9b-52e2-b21e-e58124a1a4dd', '9dea259c-cb54-52b9-9170-0dfc904e28bf', 'عند تبخير محلول ماء وملح تبخيرًا كاملًا، ماذا يبقى في الإناء؟', '[{"id":"a","text":"لا شيء، فقد زال كلّ شيء"},{"id":"b","text":"الملح الجافّ"},{"id":"c","text":"ماء نقيّ"},{"id":"d","text":"زيت"}]'::jsonb, 'b', 'عند التبخير يتصاعد الماء بخارًا ويبقى الملح المذاب جافًّا في الإناء؛ وهذا دليل على أنّ المذاب لم يزل بل حُفظت كتلته.', 6, 'mcq', NULL, NULL)
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
  ('2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد الخلائط والتشبّع', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('cad56b6d-59cf-5ad0-aea1-e6f96d2d67f0', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'عيّنتان: (1) ماء وسكّر مذاب تمامًا، (2) ماء وطين عالق. أيّ ملاحظة بالعين المجرّدة وحدها تكفي للتمييز بينهما؟', '[{"id":"a","text":"قياس كتلة كلّ عيّنة"},{"id":"b","text":"تذوّق كلّ عيّنة"},{"id":"c","text":"ظهور حبيبات عالقة في العيّنة الثانية وغيابها في الأولى الموحّدة المظهر"},{"id":"d","text":"قياس درجة حرارة كلّ عيّنة"}]'::jsonb, 'c', 'العيّنة الثانية غير متجانسة فتظهر فيها حبيبات الطين بالعين المجرّدة، أمّا الأولى فمتجانسة موحّدة المظهر دون حبيبات؛ فهذه الملاحظة البصرية وحدها تكفي دون تذوّق أو وزن أو قياس حرارة.', 1, 'mcq', NULL, NULL)
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
  ('8f22107e-5463-51c4-9cb8-012dad188be3', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'أذاب تلميذ 15 g من السكّر في 135 g من الماء ذوبانًا تامًّا، ثمّ بدأ يبخّر جزءًا من الماء. ما مجموع كتلة (المحلول المتبقّي + بخار الماء المتصاعد)؟', '[{"id":"a","text":"135 g"},{"id":"b","text":"15 g"},{"id":"c","text":"75 g"},{"id":"d","text":"150 g"}]'::jsonb, 'd', 'الكتلة محفوظة: كتلة المحلول الأصلي = 135 g + 15 g = 150 g؛ وعند التبخير لا تُفقد كتلة بل تنتقل جزئيًّا إلى البخار، فمجموع (المحلول المتبقّي + البخار المتصاعد) يبقى 150 g.', 2, 'mcq', NULL, NULL)
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
  ('dac99671-31c7-54fe-8ea8-79149e37089a', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'عند 20°C يذوب في 100 g من الماء حدّ أقصى قدره 36 g من الملح. أضاف تلميذ 50 g من الملح إلى 100 g من الماء عند 20°C وحرّك طويلًا. ماذا يحدث؟', '[{"id":"a","text":"يذوب 36 g فقط ويتراكم 14 g في القاع لأنّ المحلول بلغ التشبّع"},{"id":"b","text":"يذوب الملح كلّه (50 g) بفضل التحريك الطويل"},{"id":"c","text":"لا يذوب أيّ ملح إطلاقًا"},{"id":"d","text":"يتحوّل الملح كلّه إلى ماء"}]'::jsonb, 'a', 'الحدّ الأقصى عند 20°C هو 36 g لكلّ 100 g ماء؛ فيذوب 36 g ويبقى 50 g − 36 g = 14 g فائضًا متراكمًا في القاع، ويكون المحلول مشبعًا؛ التحريك يُسرّع الذوبان ولا يرفع الحدّ.', 3, 'mcq', NULL, NULL)
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
  ('e7430c4d-8abf-520b-84d9-0cf136b92d96', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'محلول سكّر مشبع ساخن تركناه يبرد ببطء. ماذا نتوقّع أن يحدث؟', '[{"id":"a","text":"يذوب فيه مزيد من السكّر تلقائيًّا كلّما برد"},{"id":"b","text":"قد يترسّب بعض السكّر في القاع لأنّ الحدّ الأقصى للذوبان ينقص بانخفاض الحرارة"},{"id":"c","text":"يتحوّل المحلول إلى ماء نقيّ"},{"id":"d","text":"يصبح غير متجانس دائمًا بسبب لونه"}]'::jsonb, 'b', 'انخفاض الحرارة يخفّض الحدّ الأقصى للذوبان؛ فما كان مذابًا عند الحرارة العالية يصبح فائضًا عند التبريد فيترسّب بعض السكّر في القاع.', 4, 'mcq', NULL, NULL)
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
  ('fc04d886-30c9-5b44-a069-614b1c5ac8c0', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'قال تلميذ: «الشاي المُحلّى شفّاف لكنّه بنّي، إذن هو خليط غير متجانس لأنّه ملوّن.» ما التصويب الصحيح؟', '[{"id":"a","text":"كلامه صحيح، فاللون دليل على عدم التجانس"},{"id":"b","text":"الشاي خليط غير متجانس فعلًا لكن لسبب آخر"},{"id":"c","text":"كلامه خطأ: ما دام موحّد المظهر شفّافًا فهو متجانس، واللون لا ينفي التجانس"},{"id":"d","text":"الشاي ماء نقيّ لا خليط"}]'::jsonb, 'c', 'اللون لا علاقة له بالتجانس؛ الخليط المتجانس قد يكون شفّافًا ملوّنًا. الشاي موحّد المظهر في كلّ نقطة فهو متجانس، خلافًا لما ظنّ التلميذ.', 5, 'mcq', NULL, NULL)
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
  ('39baa053-4eeb-5ac8-acae-56444baf014e', '2e174a23-9d42-58db-82c4-65bc22e0eb5b', 'وضعنا مكعّب سكّر صلب في ماء بارد فاختفى تدريجيًّا دون تسخين، ووضعنا قطعة زبدة في مقلاة ساخنة فصارت سائلة. ما التصنيف الصحيح للظاهرتين؟', '[{"id":"a","text":"الأولى ذوبان (اختفاء مذاب في مذيب) والثانية انصهار (تحوّل صلب إلى سائل بالحرارة)"},{"id":"b","text":"كلتاهما ذوبان في مذيب"},{"id":"c","text":"كلتاهما انصهار بالحرارة"},{"id":"d","text":"الأولى انصهار والثانية ذوبان"}]'::jsonb, 'a', 'اختفاء السكّر في الماء البارد دون تسخين ذوبان (مذاب داخل مذيب)؛ أمّا تحوّل الزبدة الصلبة إلى سائل بفعل حرارة المقلاة فهو انصهار (تغيّر حالة بالحرارة) لا ذوبان.', 6, 'mcq', NULL, NULL)
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
  ('40b32f15-0662-5e43-bcac-5230ce75474a', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '⚔️ ساحة التدريب ⭐⭐⭐: خلائط الحياة اليومية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('f824fa16-d54d-5e4e-8f8f-0d06c60a9642', '40b32f15-0662-5e43-bcac-5230ce75474a', 'أيّ الأمثلة التالية محلول مائي؟', '[{"id":"a","text":"ماء + رمل"},{"id":"b","text":"ماء + ملح صفاقس مذاب تمامًا"},{"id":"c","text":"ماء + زيت"},{"id":"d","text":"ماء + حصى"}]'::jsonb, 'b', 'المحلول المائي خليط متجانس ناتج عن ذوبان مذاب في الماء؛ ماء + ملح مذاب تمامًا يحقّق ذلك، أمّا الرمل والزيت والحصى فتبقى ظاهرة ولا تذوب.', 1, 'mcq', NULL, NULL)
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
  ('f6d7c321-d555-5635-9c2d-e9c24ff068c2', '40b32f15-0662-5e43-bcac-5230ce75474a', 'لماذا نستطيع استرجاع الملح من ماء البحر بتبخير الماء؟', '[{"id":"a","text":"لأنّ الملح مذاب لم يزل، فيبقى في الإناء حين يتبخّر الماء وحده"},{"id":"b","text":"لأنّ الملح تحوّل إلى ماء عند ذوبانه"},{"id":"c","text":"لأنّ الملح هو الذي يتبخّر ويبقى الماء"},{"id":"d","text":"لأنّ ماء البحر خليط غير متجانس فيه ملح ظاهر"}]'::jsonb, 'a', 'الملح المذاب في ماء البحر لم يُعدم بل حُفظت كتلته؛ وعند التبخير يتصاعد الماء بخارًا ويبقى الملح الجافّ في الإناء، وهو مبدأ الملّاحات (استخراج الملح).', 2, 'mcq', NULL, NULL)
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
  ('87e23db1-1297-5357-bf4b-491a24544df1', '40b32f15-0662-5e43-bcac-5230ce75474a', 'أيّ عامل من العوامل التالية لا يرفع الكمّية القصوى من السكّر التي تذوب في كأس ماء؟', '[{"id":"a","text":"رفع درجة حرارة الماء"},{"id":"b","text":"زيادة كمّية الماء"},{"id":"c","text":"استعمال ماء ساخن بدل ماء بارد"},{"id":"d","text":"التحريك بالملعقة"}]'::jsonb, 'd', 'رفع الحرارة وزيادة كمّية الماء يرفعان الحدّ الأقصى للذوبان؛ أمّا التحريك فيُسرّع بلوغ هذا الحدّ فقط ولا يرفعه.', 3, 'mcq', NULL, NULL)
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
  ('f90ac73d-eff0-5aab-a1ca-722b2022b3e0', '40b32f15-0662-5e43-bcac-5230ce75474a', 'المياه المعدنية التونسية تحتوي على أملاح مذابة تمنحها طعمها. كيف نصنّف هذه المياه؟', '[{"id":"a","text":"ماء نقيّ خالٍ من أيّ مادّة"},{"id":"b","text":"خليط غير متجانس فيه راسب ظاهر"},{"id":"c","text":"خليط متجانس (محلول مائي) شفّاف موحّد المظهر"},{"id":"d","text":"خليط ناتج عن انصهار الأملاح"}]'::jsonb, 'c', 'الأملاح مذابة تمامًا فلا تُرى، والماء يبقى شفّافًا موحّد المظهر؛ فالمياه المعدنية خليط متجانس، أي محلول مائي، لا ماء نقيًّا ولا خليطًا غير متجانس.', 4, 'mcq', NULL, NULL)
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
  ('2448311e-082b-5bfa-bee1-43282032d170', '40b32f15-0662-5e43-bcac-5230ce75474a', 'حرّك تلميذ محلولًا مشبعًا بالملح مدّة طويلة جدًّا، فلم يذب الفائض المتراكم في القاع. لماذا؟', '[{"id":"a","text":"لأنّ الماء بارد فقط، ولو حرّك أكثر لذاب كلّه"},{"id":"b","text":"لأنّ المحلول بلغ حدّه الأقصى (التشبّع)، والتحريك يُسرّع الذوبان ولا يرفع الحدّ"},{"id":"c","text":"لأنّ الملح تحوّل إلى سكّر"},{"id":"d","text":"لأنّ التحريك يمنع الذوبان دائمًا"}]'::jsonb, 'b', 'المحلول المشبع بلغ الكمّية القصوى القابلة للذوبان عند تلك الحرارة والكمّية؛ فالتحريك، مهما طال، يُسرّع الذوبان فقط ولا يذيب الفائض، ويلزم رفع الحرارة أو زيادة الماء.', 5, 'mcq', NULL, NULL)
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
  ('fd9cb7dd-fadd-5d96-9afc-0c4d2836f7a6', '40b32f15-0662-5e43-bcac-5230ce75474a', 'ماء البحر وماء الوادي العكر: ما الفرق في نوع الخليط بينهما؟', '[{"id":"a","text":"ماء البحر خليط متجانس (ملح مذاب)، وماء الوادي العكر خليط غير متجانس (طين عالق ظاهر)"},{"id":"b","text":"كلاهما خليط غير متجانس"},{"id":"c","text":"كلاهما ماء نقيّ"},{"id":"d","text":"ماء البحر غير متجانس وماء الوادي متجانس"}]'::jsonb, 'a', 'ملح ماء البحر مذاب فلا يُرى، فالماء متجانس (محلول)؛ أمّا طين ماء الوادي العكر فعالق ظاهر بالعين المجرّدة، فالخليط غير متجانس.', 6, 'mcq', NULL, NULL)
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
  ('e1693509-033d-5e75-abe6-fddbd39a7103', 'cfec4d46-74f7-5575-a2eb-df99f2e33f4a', 'sciences-physiques-8eme', '👑 تحدّي الأساطير ⭐⭐⭐⭐: عبقري الذوبان', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('625cd172-603d-5904-9ba4-b62754435bf9', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'محلول مائي كتلته 250 g، ومذابه 30 g من السكّر. ما كتلة الماء (المذيب) في هذا المحلول؟', '[{"id":"a","text":"280 g"},{"id":"b","text":"250 g"},{"id":"c","text":"30 g"},{"id":"d","text":"220 g"}]'::jsonb, 'd', 'كتلة المحلول = كتلة الماء + كتلة المذاب؛ فكتلة الماء = 250 g − 30 g = 220 g، لأنّ الكتلة محفوظة أثناء الذوبان.', 1, 'mcq', NULL, NULL)
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
  ('459f5c71-c69a-540c-a204-c3c3ac71612b', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'عند 20°C تذيب 100 g من الماء 36 g من الملح كحدّ أقصى. كم من الملح يذوب كحدّ أقصى في 250 g من الماء عند 20°C؟', '[{"id":"a","text":"36 g"},{"id":"b","text":"90 g"},{"id":"c","text":"250 g"},{"id":"d","text":"14 g"}]'::jsonb, 'b', 'الحدّ الأقصى يتناسب مع كمّية الماء: 250 g من الماء تساوي 2.5 مرّة قدر 100 g؛ فالحدّ الأقصى = 36 g × 2.5 = 90 g من الملح.', 2, 'mcq', NULL, NULL)
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
  ('23a0b4f5-8f0f-5419-af9e-5b6a2f18f60d', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'سخّن تلميذ محلولًا مشبعًا من السكّر فذاب فيه مزيد من السكّر، ثمّ تركه يبرد ببطء. ما التفسير الأدقّ لما يحدث عند التبريد؟', '[{"id":"a","text":"يبقى كلّ السكّر مذابًا مهما انخفضت الحرارة"},{"id":"b","text":"يتحوّل السكّر المذاب إلى ماء إضافيّ"},{"id":"c","text":"ينقص الحدّ الأقصى للذوبان بالتبريد، فيترسّب فائض السكّر في القاع"},{"id":"d","text":"يصبح المحلول غير متجانس بسبب لونه لا غير"}]'::jsonb, 'c', 'التسخين رفع الحدّ الأقصى فذاب سكّر أكثر؛ وعند التبريد ينخفض هذا الحدّ، فيصبح جزء من السكّر فائضًا عن قدرة الماء على إذابته فيترسّب في القاع.', 3, 'mcq', NULL, NULL)
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
  ('11ee4fbb-db6f-5ce7-925b-305f2e166316', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'ثلاث كؤوس: (1) ماء وشراب أحمر شفّاف، (2) ماء وحليب أبيض عكر معتم، (3) ماء وملح مذاب صافٍ. أيّها خليط غير متجانس؟', '[{"id":"a","text":"الكأس 2 فقط، فهي عكرة معتمة غير موحّدة المظهر شفّافًا"},{"id":"b","text":"الكأس 1 فقط، لأنّها ملوّنة بالأحمر"},{"id":"c","text":"الكأس 3 فقط"},{"id":"d","text":"الكؤوس الثلاث جميعًا"}]'::jsonb, 'a', 'الكأسان 1 و3 شفّافتان موحّدتا المظهر فهما متجانستان (واللون في الأولى لا يهمّ)؛ أمّا الكأس 2 فعكرة معتمة لا يُرى ما وراءها، وهذا مظهر الخليط غير المتجانس.', 4, 'mcq', NULL, NULL)
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
  ('a0d28a2b-8cc4-5abf-a509-b7af2935f479', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'أيّ العبارات التالية صحيحة؟', '[{"id":"a","text":"عند ذوبان السكّر في الماء يتحوّل السكّر إلى ماء"},{"id":"b","text":"المذاب هو السائل الذي يُذيب غيره"},{"id":"c","text":"التحريك بالملعقة يرفع الحدّ الأقصى للذوبان"},{"id":"d","text":"ذوبان السكّر في الماء لا يحتاج بالضرورة إلى تسخين، بخلاف انصهار الجليد الذي يحتاج إلى حرارة"}]'::jsonb, 'd', 'العبارة الصحيحة هي الأخيرة: الذوبان لا يستلزم تسخينًا، والانصهار تغيّر حالة بالحرارة. الباقي خطأ: السكّر لا يتحوّل ماءً، والمذاب هو ما يذوب لا ما يُذيب، والتحريك يُسرّع الذوبان ولا يرفع حدّه.', 5, 'mcq', NULL, NULL)
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
  ('1529c04e-4624-57ab-9fd8-5ca9c88b402e', 'e1693509-033d-5e75-abe6-fddbd39a7103', 'أرادت أمّ تحضير شراب سكّري مركّز جدًّا في ماء بارد، فأضافت سكّرًا كثيرًا لكنّه تراكم في القاع دون أن يذوب كلّه. ما النصيحة العلمية الصحيحة لإذابة أكبر قدر ممكن؟', '[{"id":"a","text":"إضافة مزيد من السكّر إلى الكأس"},{"id":"b","text":"تسخين الماء و/أو زيادة كمّيته، لأنّ ذلك يرفع الحدّ الأقصى للذوبان"},{"id":"c","text":"تبريد الماء أكثر ليذوب السكّر أسرع"},{"id":"d","text":"الاكتفاء بتحريك أطول لأنّه يرفع الحدّ الأقصى للذوبان"}]'::jsonb, 'b', 'المحلول بلغ التشبّع في الماء البارد؛ ولإذابة قدر أكبر يجب رفع الحدّ الأقصى للذوبان بتسخين الماء أو زيادة كمّيته. التبريد يخفّض الحدّ، والتحريك يُسرّع الذوبان فقط دون رفع الحدّ.', 6, 'mcq', NULL, NULL)
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
  ('01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6935914b-5a5a-526f-84d4-cf17068c4db5', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'أيّ خليط يُفصل مكوّناته بالترسيب أو الترشيح أو الفرز المغناطيسي؟', '[{"id":"a","text":"أيّ خليط مهما كان نوعه بالطريقة نفسها"},{"id":"b","text":"الخليط المتجانس فقط"},{"id":"c","text":"الخليط غير المتجانس"},{"id":"d","text":"الماء النقيّ وحده دون أيّ مذاب"}]'::jsonb, 'c', 'الترسيب والترشيح والفرز المغناطيسي طرق لفصل خليط غير متجانس، إذ تبقى مكوّناته منفصلة فيزيائيًّا؛ أمّا الخليط المتجانس فيُفصل بالتبخير أو التقطير.', 1, 'mcq', NULL, NULL)
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
  ('28a766b9-e129-5660-a535-f32de7cd0585', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'ما الجسم الذي يجذبه المغنطيس في الفرز المغناطيسي؟', '[{"id":"a","text":"الرمل"},{"id":"b","text":"حبيبات السكّر"},{"id":"c","text":"الملح المذاب"},{"id":"d","text":"برادة الحديد"}]'::jsonb, 'd', 'الفرز المغناطيسي يجذب الأجسام الحديدية فقط كبرادة الحديد؛ أمّا الرمل والملح والسكّر فلا ينجذب أيّ منها إلى المغنطيس.', 2, 'mcq', NULL, NULL)
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
  ('776e7506-6fcd-57af-9e71-a311726140f9', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'خليط من ماء وملح مذاب تمامًا. أردنا استرجاع الماء النقيّ منه. ما التقنية المناسبة؟', '[{"id":"a","text":"الترشيح"},{"id":"b","text":"الترسيب"},{"id":"c","text":"التقطير"},{"id":"d","text":"الفرز المغناطيسي"}]'::jsonb, 'c', 'لاسترجاع الماء النقيّ من خليط متجانس نستعمل التقطير: يتبخّر الماء ثمّ يتكاثف في المبرّد ماءً نقيًّا، بينما يبقى الملح في إناء التسخين.', 3, 'mcq', NULL, NULL)
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
  ('0e89a901-8f89-569f-ad75-d92529853565', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'ما الفرق بين التبخير والتقطير عند فصل ماء وملح مذاب؟', '[{"id":"a","text":"التبخير يسترجع الملح ويهدر الماء، والتقطير يسترجع الماء النقيّ"},{"id":"b","text":"التبخير يسترجع الماء، والتقطير يسترجع الملح"},{"id":"c","text":"كلاهما يسترجع الماء والملح معًا دون فرق"},{"id":"d","text":"التبخير يحتاج مبرّدًا، والتقطير لا يحتاج تسخينًا"}]'::jsonb, 'a', 'في التبخير يتصاعد الماء بخارًا ولا نجمعه فنسترجع الملح فقط؛ أمّا في التقطير فنبرّد البخار في مبرّد ليتكاثف، فنسترجع الماء النقيّ ويبقى الملح في الإناء.', 4, 'mcq', NULL, NULL)
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
  ('020773d0-7bee-5580-b77f-82f5acc31887', '01f62ab9-6bd4-508e-b294-5e9f67e3c3b9', 'ما دور محطّة التطهير مقارنة بمحطّة معالجة المياه الصالحة للشرب؟', '[{"id":"a","text":"تحوّل ماء الوادي إلى ماء صالح للشرب يدخل البيوت"},{"id":"b","text":"تفصل برادة الحديد عن الرمل بالمغنطيس"},{"id":"c","text":"تضيف الكلور إلى ماء البحر لجعله عذبًا"},{"id":"d","text":"تنقّي مياه الصرف الخارجة من البيوت قبل إعادتها إلى الطبيعة"}]'::jsonb, 'd', 'محطّة التطهير تنقّي مياه الصرف الخارجة من البيوت والمصانع قبل إعادتها إلى الطبيعة؛ أمّا محطّة المعالجة فتصنع ماءً صالحًا للشرب من ماء الطبيعة. الاتّجاه معاكس والهدف مختلف.', 5, 'mcq', NULL, NULL)
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
  ('43e62201-c1fd-557c-95be-8360c855b0f8', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '🛡️ تدريب المبتدئ ⭐: التقنيات الأساسية لفصل الخلائط', 1, 50, 10, 'practice', 'admin', 1)
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
  ('07bdac97-a25b-5055-9516-e439873fd90b', '43e62201-c1fd-557c-95be-8360c855b0f8', 'أيّ ممّا يلي مثال على خليط غير متجانس؟', '[{"id":"a","text":"ماء وسكّر مذاب تمامًا"},{"id":"b","text":"ماء وملح مذاب تمامًا"},{"id":"c","text":"ماء وبرادة حديد عالقة"},{"id":"d","text":"ماء وكحول ممتزجان تمامًا"}]'::jsonb, 'c', 'ماء وبرادة الحديد خليط غير متجانس لأنّ حبيبات الحديد تبقى ظاهرة للعين المجرّدة؛ أمّا السكّر والملح والكحول فتذوب أو تمتزج تمامًا فتعطي خليطًا متجانسًا.', 1, 'mcq', NULL, NULL)
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
  ('70e355d3-bf51-5488-a04d-f979e3ade1c3', '43e62201-c1fd-557c-95be-8360c855b0f8', 'ما اسم السائل الصافي الذي يمرّ عبر ورقة الترشيح؟', '[{"id":"a","text":"الراسب"},{"id":"b","text":"المذاب"},{"id":"c","text":"المقطّر"},{"id":"d","text":"الراشح"}]'::jsonb, 'd', 'السائل الصافي النافذ عبر مسامّ ورقة الترشيح يُسمّى الراشح؛ أمّا الراسب فهو الجسم الصلب المستقرّ في القاع بعد الترسيب.', 2, 'mcq', NULL, NULL)
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
  ('b13a1a8a-314f-5bf7-bf0c-f88d71b94195', '43e62201-c1fd-557c-95be-8360c855b0f8', 'أيّ أداة نستعملها في الفرز المغناطيسي؟', '[{"id":"a","text":"ورقة ترشيح وقمع"},{"id":"b","text":"مبرّد"},{"id":"c","text":"مغنطيس"},{"id":"d","text":"ميزان"}]'::jsonb, 'c', 'الفرز المغناطيسي يعتمد على المغنطيس الذي يجذب المكوّنات الحديدية من الخليط؛ ورقة الترشيح للترشيح، والمبرّد للتقطير.', 3, 'mcq', NULL, NULL)
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
  ('941bdbf8-0d16-524c-b062-0c95d5e16744', '43e62201-c1fd-557c-95be-8360c855b0f8', 'خليط ماء ورمل تُرك ساكنًا فاستقرّ الرمل في قاع الإناء. ما اسم هذه الطريقة؟', '[{"id":"a","text":"الترسيب"},{"id":"b","text":"التقطير"},{"id":"c","text":"التبخير"},{"id":"d","text":"الفرز المغناطيسي"}]'::jsonb, 'a', 'ترك الخليط ساكنًا حتّى تسقط الحبيبات الثقيلة نحو القاع بفعل ثقلها هو الترسيب؛ الرمل الثقيل يستقرّ ويعلوه ماء أصفى.', 4, 'mcq', NULL, NULL)
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
  ('24e261a9-d494-59b1-876d-818ef4938aee', '43e62201-c1fd-557c-95be-8360c855b0f8', 'لماذا لا يُفصل ملح مذاب تمامًا عن الماء بالترشيح؟', '[{"id":"a","text":"لأنّ ورقة الترشيح تذوب في الماء المالح"},{"id":"b","text":"لأنّ الملح ذاب فلم يعد حبيبات صلبة تحجزها الورقة"},{"id":"c","text":"لأنّ الترشيح يحتاج تسخينًا شديدًا"},{"id":"d","text":"لأنّ الملح أخفّ من الماء دائمًا"}]'::jsonb, 'b', 'بعد ذوبان الملح تمامًا يصبح الخليط متجانسًا ولا توجد حبيبات صلبة منفصلة، فتدع مسامّ الورقة الماء المالح كلّه يمرّ معًا؛ الترشيح يفصل جسمًا صلبًا لا مذابًا.', 5, 'mcq', NULL, NULL)
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
  ('a000b83d-6c3e-5267-a244-bc5d3ec667e0', '43e62201-c1fd-557c-95be-8360c855b0f8', 'ما أوّل خطوة عادةً في معالجة ماء وادٍ عكر ليصبح صالحًا للشرب؟', '[{"id":"a","text":"التعقيم بالكلور مباشرة"},{"id":"b","text":"التوزيع للمنازل مباشرة"},{"id":"c","text":"الترسيب لإزالة الطين الثقيل"},{"id":"d","text":"الفرز المغناطيسي"}]'::jsonb, 'c', 'تبدأ المعالجة بالترسيب لإزالة معظم حبيبات الطين الثقيلة، ثمّ الترشيح بالرمل، ثمّ التعقيم بالكلور أخيرًا قبل التوزيع.', 6, 'mcq', NULL, NULL)
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
  ('336c59e7-ade7-5ce9-a32c-66ef35321194', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: اختيار التقنية المناسبة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('9dc0eca9-3a8c-53cb-8662-866e8064a558', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'ما القاعدة الأولى التي نعتمدها لاختيار تقنية فصل مكوّنات خليط؟', '[{"id":"a","text":"وزن الخليط قبل أيّ شيء"},{"id":"b","text":"قياس درجة حرارة الخليط أوّلًا"},{"id":"c","text":"تحديد نوع الخليط: متجانس أم غير متجانس"},{"id":"d","text":"إضافة الكلور دائمًا في البداية"}]'::jsonb, 'c', 'نوع الخليط يحدّد التقنية: غير المتجانس يُفصل بالترسيب أو الترشيح أو الفرز المغناطيسي، والمتجانس بالتبخير أو التقطير. لذلك نبدأ دائمًا بتحديد النوع.', 1, 'mcq', NULL, NULL)
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
  ('dddf2d7c-63e9-5ef3-a11e-0fac32a166f3', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'أراد تلميذ فصل خليط من برادة الحديد والرمل. ما التقنية الأنسب والأسرع؟', '[{"id":"a","text":"التقطير بالتسخين"},{"id":"b","text":"الترشيح عبر ورقة ترشيح"},{"id":"c","text":"التعقيم بالكلور"},{"id":"d","text":"الفرز المغناطيسي بتقريب مغنطيس"}]'::jsonb, 'd', 'برادة الحديد تنجذب إلى المغنطيس بينما لا ينجذب الرمل؛ فالفرز المغناطيسي يفصلهما مباشرة. التقطير والترشيح لا يفيدان لأنّ المكوّنَين صلبان جافّان لا سائل فيهما.', 2, 'mcq', NULL, NULL)
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
  ('498cde4f-508a-598a-b0af-e441dba207a7', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'لماذا لا يفيد الفرز المغناطيسي في فصل خليط من الرمل والملح؟', '[{"id":"a","text":"لأنّ المغنطيس يجذب الرمل والملح معًا فلا يميّزهما"},{"id":"b","text":"لأنّ لا الرمل ولا الملح ينجذب إلى المغنطيس فلا يفصلهما"},{"id":"c","text":"لأنّ الملح يذوّب المغنطيس"},{"id":"d","text":"لأنّ الفرز المغناطيسي يحتاج تسخينًا غير متوفّر"}]'::jsonb, 'b', 'الفرز المغناطيسي يجذب الأجسام الحديدية فقط؛ لا الرمل ولا الملح حديديّ، فلا ينجذب أيّ منهما إلى المغنطيس ولا يحدث أيّ فصل.', 3, 'mcq', NULL, NULL)
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
  ('8d7f02d0-ef2c-5686-b05e-a84b787878ab', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'خليط ماء وملح مذاب. أردنا استرجاع الملح جافًّا فقط دون الاهتمام بالماء. ما التقنية المناسبة؟', '[{"id":"a","text":"التبخير: يتصاعد الماء بخارًا ويبقى الملح في الإناء"},{"id":"b","text":"الترشيح عبر ورقة ترشيح"},{"id":"c","text":"الترسيب بترك الخليط ساكنًا"},{"id":"d","text":"الفرز المغناطيسي للملح"}]'::jsonb, 'a', 'بما أنّنا نريد الملح فقط، فالتبخير أنسب وأبسط: نسخّن حتّى يتبخّر الماء كلّه ويبقى الملح جافًّا. التقطير ممكن أيضًا لكنّه يجمع الماء بلا داعٍ هنا؛ الترشيح والترسيب والفرز لا تفصل مذابًا.', 4, 'mcq', NULL, NULL)
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
  ('6c23180b-e37b-51ee-8aca-f32a6d13ea88', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'لماذا نبدأ معالجة الماء الطبيعي بالترسيب قبل الترشيح بالرمل؟', '[{"id":"a","text":"لأنّ الترشيح يحتاج ماءً ساخنًا يوفّره الترسيب"},{"id":"b","text":"لا يوجد سبب، والترتيب اختياري"},{"id":"c","text":"لأنّ الترسيب يعقّم الماء من الجراثيم"},{"id":"d","text":"لأنّ الترسيب يزيل معظم الطين الثقيل فلا تنسدّ طبقات الرمل بسرعة"}]'::jsonb, 'd', 'الترسيب يزيل معظم حبيبات الطين الثقيلة أوّلًا، فيصل إلى الترشيح ماء أخفّ حمولة لا يسدّ طبقات الرمل بسرعة؛ عكس الترتيب يُتلف مرشّح الرمل بسرعة.', 5, 'mcq', NULL, NULL)
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
  ('c0c7bd99-28f4-53af-a9ab-58b5a37a49e0', '336c59e7-ade7-5ce9-a32c-66ef35321194', 'أيّ العبارات التالية **خاطئة** بخصوص تقنيات الفصل؟', '[{"id":"a","text":"التقطير يسترجع الماء النقيّ من خليط متجانس"},{"id":"b","text":"الترشيح يفصل حبيبات صلبة عن سائل بلا تسخين"},{"id":"c","text":"الفرز المغناطيسي يجذب النحاس والألمنيوم كما يجذب الحديد"},{"id":"d","text":"الترسيب يعتمد على ثقل الحبيبات الصلبة"}]'::jsonb, 'c', 'العبارة الخاطئة أنّ الفرز المغناطيسي يجذب النحاس والألمنيوم؛ فهو يجذب الأجسام الحديدية فقط، أمّا النحاس والألمنيوم فلا ينجذبان إلى المغنطيس.', 6, 'mcq', NULL, NULL)
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
  ('0f13b6c8-9891-5c2b-8604-008b188405c2', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '📗 مراجعة الرحلة ⭐⭐: من الخليط إلى الصنبور', 2, 70, 15, 'practice', 'admin', 3)
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
  ('f40c41a7-79c9-55a7-ac9c-209723731667', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'أيّ خليط من التالي يمكن فصل مكوّناته بالفرز المغناطيسي؟', '[{"id":"a","text":"رمل وملح"},{"id":"b","text":"ماء وكحول"},{"id":"c","text":"ماء وسكّر مذاب"},{"id":"d","text":"برادة حديد ورمل"}]'::jsonb, 'd', 'الفرز المغناطيسي يجذب الحديد فقط، فيصلح لفصل برادة الحديد عن الرمل؛ أمّا خليط الرمل والملح فلا حديد فيه، والخليطان المتجانسان (ماء وسكّر، ماء وكحول) لا يُفصلان بمغنطيس.', 1, 'mcq', NULL, NULL)
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
  ('7538d4ed-478d-573f-bb59-df41793a4d91', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'بماذا يختلف التبخير عن التقطير؟', '[{"id":"a","text":"التبخير يسترجع الجسم الصلب المذاب ويهدر الماء، والتقطير يسترجع الماء النقيّ"},{"id":"b","text":"التبخير لغير المتجانس والتقطير للمتجانس"},{"id":"c","text":"التبخير يستعمل مغنطيسًا والتقطير يستعمل ورقة ترشيح"},{"id":"d","text":"لا فرق بينهما فكلاهما يعطي النتيجة نفسها"}]'::jsonb, 'a', 'كلاهما لخليط متجانس ويعتمد التسخين، لكنّ التبخير يترك الماء يتصاعد فنسترجع المذاب فقط، بينما التقطير يبرّد البخار في مبرّد فيتكاثف ونسترجع الماء النقيّ.', 2, 'mcq', NULL, NULL)
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
  ('9767a970-8040-5d5f-a7dc-cabacc99d548', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'لاسترجاع ملح الطعام من ماء البحر في المِلّاحات، أيّ ظاهرة تُستغلّ؟', '[{"id":"a","text":"الترشيح عبر ورقة"},{"id":"b","text":"تبخّر الماء بفعل الشمس والحرارة ليبقى الملح"},{"id":"c","text":"الفرز المغناطيسي للملح"},{"id":"d","text":"التعقيم بالكلور"}]'::jsonb, 'b', 'في المِلّاحات يتبخّر ماء البحر بفعل الشمس والحرارة فيبقى ملح الطعام؛ هذا تطبيق مباشر للتبخير الذي يسترجع الجسم الصلب المذاب.', 3, 'mcq', NULL, NULL)
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
  ('c7704e6e-60c4-562a-af47-b655d6777798', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'ما الترتيب الصحيح لخطوات معالجة الماء الطبيعي ليصبح صالحًا للشرب؟', '[{"id":"a","text":"التعقيم ← الترشيح ← الترسيب"},{"id":"b","text":"الترشيح ← الترسيب ← التعقيم"},{"id":"c","text":"الترسيب ← الترشيح ← التعقيم"},{"id":"d","text":"الترسيب ← التعقيم ← الترشيح"}]'::jsonb, 'c', 'الترتيب الصحيح: الترسيب أوّلًا لإزالة الطين الثقيل، ثمّ الترشيح بالرمل لإزالة الحبيبات الدقيقة، ثمّ التعقيم بالكلور أخيرًا للقضاء على الجراثيم.', 4, 'mcq', NULL, NULL)
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
  ('12c9283a-0e88-560e-ab5d-fd3409c283d5', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'ماء عكر تُرك يترسّب فصار أصفى، لكن بقيت حبيبات دقيقة جدًّا عالقة فوق الراسب. ما الخطوة المناسبة لإزالتها؟', '[{"id":"a","text":"الاكتفاء بالترسيب فهو كافٍ دائمًا"},{"id":"b","text":"ترشيح الماء الأصفى عبر ورقة ترشيح"},{"id":"c","text":"الفرز المغناطيسي للحبيبات الدقيقة"},{"id":"d","text":"إضافة مزيد من الطين"}]'::jsonb, 'b', 'الترسيب لا يزيل الحبيبات الدقيقة جدًّا؛ فترشيح الماء الأصفى عبر ورقة ترشيح يحجز هذه الحبيبات ويكمل التنقية. المغنطيس لا يفيد لأنّ الحبيبات ليست حديدية.', 5, 'mcq', NULL, NULL)
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
  ('252ec7bb-a89e-5ba3-ab53-505955993cb8', '0f13b6c8-9891-5c2b-8604-008b188405c2', 'لماذا لا يجوز إعادة ماء الصرف مباشرة إلى الوادي دون معالجة؟', '[{"id":"a","text":"لأنّه ملوّث بموادّ تضرّ بالطبيعة والكائنات الحيّة"},{"id":"b","text":"لأنّه بارد جدًّا فيجمّد الوادي"},{"id":"c","text":"لأنّه نقيّ جدًّا فيضرّ الأسماك"},{"id":"d","text":"لأنّه يحتوي على مغنطيس ذائب"}]'::jsonb, 'a', 'ماء الصرف الخارج من البيوت والمصانع ملوّث بموادّ عضوية وكيميائية تضرّ بالطبيعة، لذلك يمرّ عبر محطّة تطهير تنقّيه قبل إعادته إلى الوادي أو البحر.', 6, 'mcq', NULL, NULL)
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
  ('712a6d00-2946-5c71-8a22-8c41eb980c61', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: خلائط متعدّدة المكوّنات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e1cc3e46-8cdb-59de-af12-28aefddaff75', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'امتزج الكحول تمامًا بالماء فكوّنا سائلًا واحد المظهر. أراد تلميذ فصل الكحول عن الماء لاحقًا. أيّ تقنية تصلح؟', '[{"id":"a","text":"الترسيب فقط"},{"id":"b","text":"الترشيح عبر ورقة ترشيح"},{"id":"c","text":"التقطير، لأنّ الخليط متجانس ولا حبيبات صلبة فيه"},{"id":"d","text":"الفرز المغناطيسي"}]'::jsonb, 'c', 'الماء والكحول خليط متجانس لا حبيبات صلبة فيه، فلا يفيد الترسيب ولا الترشيح ولا الفرز المغناطيسي؛ يُفصل مكوّناته بالتقطير الذي يستغلّ اختلاف قابلية المكوّنين للتبخّر عند التسخين.', 1, 'mcq', NULL, NULL)
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
  ('6c6e7d2f-6ff3-5f4f-89d3-89b846617eb3', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'خليط يحتوي على برادة حديد ورمل وملح مذاب في ماء. لفصل المكوّنات الثلاثة، ما الترتيب المنطقي للتقنيات؟', '[{"id":"a","text":"الفرز المغناطيسي (الحديد) ← الترشيح (الرمل) ← التبخير أو التقطير (الملح/الماء)"},{"id":"b","text":"التبخير أوّلًا ثمّ الترشيح ثمّ الفرز المغناطيسي"},{"id":"c","text":"الترشيح أوّلًا ثمّ التبخير ثمّ الفرز المغناطيسي"},{"id":"d","text":"لا يمكن فصل هذه المكوّنات الثلاثة إطلاقًا"}]'::jsonb, 'a', 'نبدأ بالفرز المغناطيسي لجذب برادة الحديد، ثمّ نرشّح لحجز الرمل غير الحديدي، فيبقى ماء مالح متجانس نفصله بالتبخير (لاسترجاع الملح) أو التقطير (لاسترجاع الماء). هذا الترتيب يعالج كلّ مكوّن بالتقنية المناسبة له.', 2, 'mcq', NULL, NULL)
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
  ('76ace142-02e5-55aa-9468-8e6850185c19', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'أراد باحث استرجاع كلٍّ من الماء النقيّ والملح الجافّ من ماء مالح، دون أن يفقد أيًّا منهما. أيّ تقنية تحقّق هذا الهدف المزدوج؟', '[{"id":"a","text":"التبخير، لأنّه يعطي الماء والملح معًا"},{"id":"b","text":"التقطير، إذ نجمع الماء المتكاثف في إناء ويبقى الملح في إناء التسخين"},{"id":"c","text":"الترشيح، إذ يفصل الماء عن الملح بالورقة"},{"id":"d","text":"الترسيب، إذ يستقرّ الملح في القاع ويعلوه الماء"}]'::jsonb, 'b', 'التقطير وحده يحقّق الهدف المزدوج: يتبخّر الماء ثمّ يتكاثف في المبرّد فنجمعه نقيًّا، ويبقى الملح جافًّا في إناء التسخين. أمّا التبخير فيسترجع الملح لكنّه يهدر الماء بخارًا في الهواء.', 3, 'mcq', NULL, NULL)
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
  ('db8d9f46-6b54-5238-9665-1d69daff3c77', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'اتّبع تلميذ خطوات معالجة ماء عكر بهذا الترتيب: (1) عقّمه بالكلور، (2) رشّحه بالرمل، (3) تركه يترسّب أخيرًا. أين الخطأ الأساسي؟', '[{"id":"a","text":"لا يوجد أيّ خطأ في هذا الترتيب"},{"id":"b","text":"الخطأ أنّه استعمل الرمل بدل ورقة الترشيح"},{"id":"c","text":"الخطأ أنّه لم يستعمل التقطير في المعالجة"},{"id":"d","text":"الخطأ أنّه قلب الترتيب: الصحيح ترسيب ← ترشيح ← تعقيم، فالتعقيم أوّلًا يهدر الكلور على الأوساخ والترسيب أخيرًا لا معنى له"}]'::jsonb, 'd', 'الترتيب مقلوب تمامًا: يجب الترسيب أوّلًا لإزالة الطين الثقيل، ثمّ الترشيح بالرمل، ثمّ التعقيم أخيرًا. التعقيم أوّلًا يجعل الكلور يُستهلك في مقاومة الأوساخ الكثيرة بدل الجراثيم، والترسيب في النهاية بعد التعقيم لا فائدة منه.', 4, 'mcq', NULL, NULL)
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
  ('8149c9f5-5643-51b6-89cd-71477e309f37', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'أيّ العبارات التالية **صحيحة**؟', '[{"id":"a","text":"التبخير يسترجع الجسم الصلب المذاب بينما يتصاعد الماء بخارًا دون جمعه"},{"id":"b","text":"الفرز المغناطيسي يصلح لفصل الملح المذاب عن الماء"},{"id":"c","text":"الترشيح يفصل مكوّنات أيّ خليط متجانس بسهولة"},{"id":"d","text":"التقطير لا يحتاج إلى أيّ تسخين"}]'::jsonb, 'a', 'العبارة الصحيحة أنّ التبخير يسترجع المذاب الصلب ويترك الماء يتصاعد بخارًا دون جمعه؛ الباقي خاطئ: المغنطيس لا يجذب الملح المذاب، والترشيح لا يفصل خليطًا متجانسًا، والتقطير يحتاج تسخينًا ثمّ تبريدًا.', 5, 'mcq', NULL, NULL)
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
  ('49095db0-9260-58a2-b3ae-8cd1faa75b57', '712a6d00-2946-5c71-8a22-8c41eb980c61', 'لاحظ سكّان قرية أنّ مياه الوادي أصبحت ذات رائحة كريهة بعد أن بدأ مصنع قريب يصرف مياهه دون معالجة. ما الإجراء الجذري الأنسب لحماية الوادي مستقبلًا؟', '[{"id":"a","text":"الاكتفاء بترشيح ماء الوادي عند كلّ استعمال"},{"id":"b","text":"إلزام المصنع بتمرير مياه صرفه عبر محطّة تطهير قبل تصريفها في الوادي"},{"id":"c","text":"زيادة كمّية المياه المصروفة لتخفيف تركيز التلوّث"},{"id":"d","text":"إضافة الكلور مباشرة إلى الوادي كلّه"}]'::jsonb, 'b', 'الحلّ الجذري معالجة التلوّث عند مصدره: إلزام المصنع بتطهير مياه صرفه قبل تصريفها. ترشيح ماء الوادي لا يمنع استمرار التلوّث، وزيادة الصرف تزيد المشكلة، وكلورة الوادي كلّه غير عملية ولا تعالج السبب.', 6, 'mcq', NULL, NULL)
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
  ('6e0fd560-ecfd-551e-8341-f2bc601488bb', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '⚔️ زعيم المعالجة ⭐⭐⭐: من الوادي إلى الطبيعة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('64924cd7-82e7-5e3a-ab77-6a372e74d6cf', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'في محطّة معالجة الماء الصالح للشرب، ما دور طبقات الرمل والحصى؟', '[{"id":"a","text":"تسخين الماء حتّى الغليان"},{"id":"b","text":"تعقيم الماء من الجراثيم"},{"id":"c","text":"ترشيح الماء بحجز الحبيبات الدقيقة المتبقّية"},{"id":"d","text":"جذب برادة الحديد من الماء"}]'::jsonb, 'c', 'تعمل طبقات الرمل والحصى كمرشّح: يمرّ الماء عبرها فتُحجز الحبيبات الدقيقة المتبقّية بعد الترسيب؛ القضاء على الجراثيم يكون لاحقًا بالتعقيم بالكلور.', 1, 'mcq', NULL, NULL)
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
  ('d36c8cd5-2df1-59d8-b7c2-34ff01eb1684', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'ما الهدف من إضافة كمّية صغيرة من الكلور في آخر مراحل معالجة ماء الشرب؟', '[{"id":"a","text":"إزالة حبيبات الطين الكبيرة"},{"id":"b","text":"تلوين الماء ليصبح شفّافًا"},{"id":"c","text":"فصل الملح المذاب عن الماء"},{"id":"d","text":"القضاء على الجراثيم والميكروبات"}]'::jsonb, 'd', 'التعقيم بالكلور يقضي على الجراثيم والميكروبات التي لا يزيلها الترسيب ولا الترشيح، فيصبح الماء آمنًا للشرب. إزالة الطين تمّت في الترسيب والترشيح قبله.', 2, 'mcq', NULL, NULL)
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
  ('1c6695c7-08e8-59d7-b43e-2613f05e0f3e', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'ما الفرق الجوهري بين محطّة معالجة المياه الصالحة للشرب ومحطّة التطهير؟', '[{"id":"a","text":"الأولى تصنع ماءً صالحًا للشرب من ماء الطبيعة، والثانية تنقّي مياه الصرف قبل إعادتها للطبيعة"},{"id":"b","text":"كلتاهما تصنعان ماء شرب بالطريقة نفسها"},{"id":"c","text":"الأولى تنقّي مياه الصرف، والثانية تصنع ماء الشرب"},{"id":"d","text":"لا فرق بينهما، والاسمان لشيء واحد"}]'::jsonb, 'a', 'محطّة المعالجة تأخذ ماء الطبيعة العكر وتحوّله إلى ماء صالح للشرب يدخل البيوت؛ محطّة التطهير تأخذ ماء الصرف الخارج من البيوت وتنقّيه قبل إعادته إلى الطبيعة. الاتّجاه معاكس.', 3, 'mcq', NULL, NULL)
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
  ('db839e05-c7ca-5d03-8f22-c43563c748d2', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'في محطّة التطهير، ما دور البكتيريا النافعة في مرحلة المعالجة البيولوجية؟', '[{"id":"a","text":"تلوّن الماء لتسهيل رؤيته"},{"id":"b","text":"تحلّل الموادّ العضوية الملوّثة في ماء الصرف"},{"id":"c","text":"تجذب برادة الحديد المذابة"},{"id":"d","text":"ترفع درجة حرارة الماء إلى الغليان"}]'::jsonb, 'b', 'في المعالجة البيولوجية تحلّل البكتيريا النافعة الموادّ العضوية الملوّثة الموجودة في ماء الصرف، فيصبح الماء أنظف قبل إعادته إلى الطبيعة.', 4, 'mcq', NULL, NULL)
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
  ('bb9d3b5d-6cf4-52aa-be4b-ac76464242da', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'سكب فلاّح ماءً عكرًا مباشرة على مرشّح رملي دقيق دون تركه يترسّب أوّلًا، فانسدّ المرشّح بسرعة. ما تفسير ذلك؟', '[{"id":"a","text":"لأنّ الرمل يذوب في الماء العكر"},{"id":"b","text":"لأنّ المرشّح الرملي يعمل فقط مع الماء الساخن"},{"id":"c","text":"لأنّ الماء العكر يحتاج تعقيمًا قبل الترشيح"},{"id":"d","text":"لأنّ كمّية الطين الثقيل الكبيرة سدّت مسامّ المرشّح دفعةً واحدة"}]'::jsonb, 'd', 'بلا ترسيب مسبق تصل كلّ حبيبات الطين الثقيلة إلى المرشّح فتسدّ مسامّه بسرعة؛ لذلك يُترك الماء يترسّب أوّلًا لإزالة معظم الطين قبل الترشيح.', 5, 'mcq', NULL, NULL)
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
  ('7640b699-5b98-5309-9d39-6c20848a7c3f', '6e0fd560-ecfd-551e-8341-f2bc601488bb', 'علّل: قلب أحد التلاميذ الترتيب فعقّم الماء بالكلور أوّلًا قبل الترسيب والترشيح، فكانت النتيجة سيّئة. لماذا؟', '[{"id":"a","text":"لأنّ الكلور يستهلك في مقاومة الطين والأوساخ بدل الجراثيم فيضعف مفعوله"},{"id":"b","text":"لأنّ الكلور يجمّد الماء فورًا"},{"id":"c","text":"لأنّ التعقيم يجب أن يكون بعد التوزيع للمنازل"},{"id":"d","text":"لأنّ الكلور يحوّل الماء إلى خليط متجانس"}]'::jsonb, 'a', 'عند التعقيم قبل إزالة الطين، يستهلك الكلور في التفاعل مع الأوساخ الكثيرة بدل التركيز على الجراثيم، فيضعف مفعوله؛ لذلك يأتي التعقيم أخيرًا بعد الترسيب والترشيح.', 6, 'mcq', NULL, NULL)
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
  ('660e79bd-5b7c-556f-aec4-db848c35e854', 'a2c9ce89-5f4a-570d-8a1f-920ad059a8a6', 'sciences-physiques-8eme', '👑 تحدّي الأسطورة ⭐⭐⭐⭐: خبير فصل الخلائط', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('12c06678-7230-5c95-94e1-f1a6ea26bd98', '660e79bd-5b7c-556f-aec4-db848c35e854', 'عيّنتان أمامك: الأولى ماء وسكّر ممزوجان تمامًا، والثانية ماء وبرادة حديد عالقة. أيّ ملاحظة أو اختبار بسيط يميّز بينهما دون تسخين؟', '[{"id":"a","text":"تقريب مغنطيس: تنجذب برادة الحديد في الثانية ولا شيء ينجذب في الأولى"},{"id":"b","text":"قياس درجة حرارة كلّ عيّنة"},{"id":"c","text":"وزن كلّ عيّنة فقط"},{"id":"d","text":"لا يمكن التمييز بينهما بأيّ اختبار"}]'::jsonb, 'a', 'العيّنة الثانية غير متجانسة وتحتوي حديدًا، فتنجذب برادته إلى المغنطيس؛ أمّا الأولى فمتجانسة ولا حديد فيها فلا شيء ينجذب. كما أنّ حبيبات الحديد ظاهرة في الثانية وغائبة في الأولى.', 1, 'mcq', NULL, NULL)
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
  ('07006037-4438-5c0b-8029-ed3436ba8b7f', '660e79bd-5b7c-556f-aec4-db848c35e854', 'أراد تلميذ إثبات أنّ ماء البحر ليس ماءً نقيًّا بل خليط متجانس يحوي أملاحًا مذابة. أيّ تجربة تثبت ذلك مباشرة؟', '[{"id":"a","text":"ترشيح ماء البحر عبر ورقة ترشيح وملاحظة الراشح"},{"id":"b","text":"ترك ماء البحر يترسّب مدّة طويلة"},{"id":"c","text":"تقريب مغنطيس من ماء البحر"},{"id":"d","text":"تبخير عيّنة من ماء البحر وملاحظة بقاء أملاح صلبة في الإناء"}]'::jsonb, 'd', 'بتبخير عيّنة من ماء البحر يتصاعد الماء ويبقى راسب من الأملاح الصلبة، ممّا يثبت وجود مذاب. الترشيح لا يحجز المذاب، والمغنطيس لا يجذب الأملاح، والترسيب لا يفصل مذابًا لأنّ الخليط متجانس.', 2, 'mcq', NULL, NULL)
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
  ('af910b24-9ecb-58c5-bcc4-3ca17b8b8858', '660e79bd-5b7c-556f-aec4-db848c35e854', 'خليط من رمل وسكّر جافّين (بلا ماء). كيف نفصلهما مستغلّين أنّ السكّر يذوب في الماء والرمل لا يذوب؟', '[{"id":"a","text":"الفرز المغناطيسي مباشرة للسكّر"},{"id":"b","text":"إضافة ماء لإذابة السكّر، ثمّ ترشيح لفصل الرمل، ثمّ تبخير الراشح لاسترجاع السكّر"},{"id":"c","text":"تسخين الخليط الجافّ مباشرة حتّى يتبخّر الرمل"},{"id":"d","text":"ترك الخليط الجافّ يترسّب في الهواء"}]'::jsonb, 'b', 'نضيف ماءً فيذوب السكّر ويبقى الرمل صلبًا، ثمّ نرشّح فيُحجز الرمل ويمرّ ماء السكّر (الراشح)، ثمّ نبخّر الراشح فيتصاعد الماء ويبقى السكّر. تسلسل ذكيّ يجمع الإذابة والترشيح والتبخير.', 3, 'mcq', NULL, NULL)
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
  ('8bdbc008-2952-51d1-aecd-86f037575f6c', '660e79bd-5b7c-556f-aec4-db848c35e854', 'استعمل تلميذ التقطير لفصل ماء وملح، فحصل على ماء مقطّر نقيّ لكنّه لاحظ أنّ كمّية الماء المجموعة أقلّ ممّا وضعه في البداية. ما التفسير الأصحّ؟', '[{"id":"a","text":"جزء من الماء تحوّل إلى ملح داخل الإناء"},{"id":"b","text":"جزء من بخار الماء لم يتكاثف تمامًا أو تسرّب قبل جمعه في إناء التقطير"},{"id":"c","text":"الملح امتصّ نصف الماء فأخفاه نهائيًّا"},{"id":"d","text":"التقطير يزيد كتلة الملح على حساب الماء دائمًا"}]'::jsonb, 'b', 'في الواقع لا يتكاثف كلّ البخار ويُجمع؛ فقد يتسرّب جزء منه أو يبقى بخارًا لم يبرد كفاية، فتقلّ كمّية الماء المجموعة. الماء لا يتحوّل إلى ملح، والملح لا يمتصّ الماء ويخفيه.', 4, 'mcq', NULL, NULL)
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
  ('acc1529d-7a32-52b9-bf68-64a28c9f0057', '660e79bd-5b7c-556f-aec4-db848c35e854', 'في محطّة تطهير مياه الصرف، رُتّبت المراحل: التصفية بالحواجز الشبكية ← الترسيب ← المعالجة البيولوجية بالبكتيريا. لماذا تأتي التصفية بالحواجز أوّلًا؟', '[{"id":"a","text":"لأنّها توقف الأجسام الكبيرة أوّلًا فلا تُعطّل الأحواض والمراحل التالية"},{"id":"b","text":"لأنّها تعقّم الماء من الجراثيم قبل كلّ شيء"},{"id":"c","text":"لأنّها تسخّن الماء لتنشيط البكتيريا"},{"id":"d","text":"لأنّها تضيف الكلور مباشرة إلى ماء الصرف"}]'::jsonb, 'a', 'الحواجز الشبكية توقف الأجسام الكبيرة (خرق، أوراق، بقايا صلبة) في البداية حتّى لا تسدّ الأحواض ولا تعطّل الترسيب والمعالجة البيولوجية اللاحقة؛ منطق شبيه بأسبقية الترسيب على الترشيح في ماء الشرب.', 5, 'mcq', NULL, NULL)
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
  ('e85ca1fe-224d-548f-95db-84583779f7ff', '660e79bd-5b7c-556f-aec4-db848c35e854', 'طلب معلّم من تلميذ تصميم سلسلة معالجة كاملة لماء وادٍ عكر يحوي أوراقًا كبيرة وطينًا ثقيلًا وحبيبات دقيقة عالقة وجراثيم. ما التسلسل الأمثل؟', '[{"id":"a","text":"تعقيم بالكلور ← ترسيب ← ترشيح ← إزالة الأوراق"},{"id":"b","text":"إزالة الأوراق بحاجز شبكي ← ترسيب الطين الثقيل ← ترشيح الحبيبات الدقيقة ← تعقيم بالكلور"},{"id":"c","text":"ترشيح ← تعقيم ← ترسيب ← إزالة الأوراق"},{"id":"d","text":"تقطير الماء كلّه ثمّ توزيعه مباشرة"}]'::jsonb, 'b', 'نتدرّج من الأكبر إلى الأدقّ إلى الجراثيم: حاجز شبكي يوقف الأوراق الكبيرة، ثمّ ترسيب يزيل الطين الثقيل، ثمّ ترشيح يحجز الحبيبات الدقيقة، ثمّ تعقيم بالكلور يقضي على الجراثيم أخيرًا. أيّ قلب لهذا التدرّج يعطّل الخطوة التالية أو يهدر الكلور.', 6, 'mcq', NULL, NULL)
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
  ('13059654-9eb4-5020-932c-4b5b4026fc0d', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0bde65de-0988-5b61-9d9c-5836202eaed8', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'ما العلاقة الصحيحة التي تُحسب بها الكتلة الحجمية ρ لجسم كتلته m وحجمه V؟', '[{"id":"a","text":"ρ = V/m"},{"id":"b","text":"ρ = m × V"},{"id":"c","text":"ρ = m − V"},{"id":"d","text":"ρ = m/V"}]'::jsonb, 'd', 'الكتلة الحجمية هي كتلة وحدة الحجم، فتُحسب بقسمة الكتلة على الحجم: ρ = m/V. أمّا V/m فهي النسبة المقلوبة الخاطئة.', 1, 'mcq', NULL, NULL)
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
  ('873226e1-fb3d-5c7c-a880-0c7ab04607c1', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'بأيّ جهاز نقيس حجم سائل في المخبر؟', '[{"id":"a","text":"الميزان"},{"id":"b","text":"المخبار المدرّج"},{"id":"c","text":"مقياس الحرارة"},{"id":"d","text":"المسطرة"}]'::jsonb, 'b', 'نقيس حجم سائل بالمخبار المدرّج ونقرأ القيمة عند مستوى سطح السائل. الميزان يقيس الكتلة، ومقياس الحرارة يقيس درجة الحرارة.', 2, 'mcq', NULL, NULL)
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
  ('b6f3e895-7b43-5493-9105-2f71093dfc85', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'أيّ وحدة من الوحدات التالية تصلح للتعبير عن الكتلة الحجمية؟', '[{"id":"a","text":"g/cm³"},{"id":"b","text":"cm³"},{"id":"c","text":"g"},{"id":"d","text":"°C"}]'::jsonb, 'a', 'الكتلة الحجمية = كتلة/حجم، فوحدتها تجمع بين وحدة كتلة وحدة حجم: g/cm³ (أو kg/m³). أمّا cm³ فوحدة حجم و g وحدة كتلة و °C وحدة درجة حرارة.', 3, 'mcq', NULL, NULL)
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
  ('77af8d7e-371d-580e-b8e2-e37e07040598', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'كم يساوي 1 mL بوحدة السنتيمتر المكعّب؟', '[{"id":"a","text":"1 cm³"},{"id":"b","text":"10 cm³"},{"id":"c","text":"1000 cm³"},{"id":"d","text":"0.1 cm³"}]'::jsonb, 'a', 'المِلّيلتر والسنتيمتر المكعّب متساويان تمامًا: 1 mL = 1 cm³. لهذا نقرأ حجم الجسم المغمور بالمِلّيلتر أو بالسنتيمتر المكعّب دون فرق.', 4, 'mcq', NULL, NULL)
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
  ('620e72f4-d3d3-5d30-963b-d1c02bfe3807', '13059654-9eb4-5020-932c-4b5b4026fc0d', 'يطفو الجسم فوق الماء (ρ الماء = 1 g/cm³) إذا كانت كتلته الحجمية:', '[{"id":"a","text":"أصغر من 1 g/cm³"},{"id":"b","text":"أكبر من 1 g/cm³"},{"id":"c","text":"مساوية تمامًا لكتلته العادية"},{"id":"d","text":"أكبر من حجمه"}]'::jsonb, 'a', 'يطفو الجسم إذا كانت كتلته الحجمية أصغر من كتلة الماء الحجمية (ρ < 1 g/cm³)، ويرسب إذا كانت أكبر (ρ > 1 g/cm³). المقارنة تكون بين كتلتين حجميتين لا بين كتلة وحجم.', 5, 'mcq', NULL, NULL)
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
  ('b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '⭐ تمرين: الكتلة الحجمية وقيس الحجم والكتلة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('842cbf11-8eb2-5e0e-8aea-fc41e523f516', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'ما هي الكتلة الحجمية لجسم؟', '[{"id":"a","text":"حجم وحدة الكتلة من المادّة"},{"id":"b","text":"كتلة وحدة الحجم من المادّة"},{"id":"c","text":"مجموع الكتلة والحجم"},{"id":"d","text":"الفرق بين الكتلة والحجم"}]'::jsonb, 'b', 'الكتلة الحجمية هي كتلة وحدة الحجم من المادّة ; أي الكتلة المقابلة لكلّ سنتيمتر مكعّب واحد. لذلك تُحسب بقسمة الكتلة على الحجم: ρ = m/V.', 1, 'mcq', NULL, NULL)
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
  ('a92ae904-9560-5aa8-afbe-7f6355681b81', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'بأيّ جهاز نقيس كتلة جسم في المخبر؟', '[{"id":"a","text":"الميزان"},{"id":"b","text":"المخبار المدرّج"},{"id":"c","text":"المسطرة"},{"id":"d","text":"مقياس الحرارة"}]'::jsonb, 'a', 'نقيس الكتلة بالميزان بوحدة الغرام (g). المخبار المدرّج يقيس الحجم، والمسطرة تقيس الطول، ومقياس الحرارة يقيس درجة الحرارة.', 2, 'mcq', NULL, NULL)
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
  ('2c292172-c3e9-5e2e-b0a0-842d9e4dc728', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'كم يساوي 1 kg بوحدة الغرام؟', '[{"id":"a","text":"100 g"},{"id":"b","text":"10 g"},{"id":"c","text":"1000 g"},{"id":"d","text":"1 g"}]'::jsonb, 'c', 'الكيلوغرام يساوي ألف غرام: 1 kg = 1000 g. لذلك للتحويل من الكيلوغرام إلى الغرام نضرب في 1000.', 3, 'mcq', NULL, NULL)
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
  ('412951c8-1e1b-5bdf-8098-31ef94f82dcb', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'في مخبر المدرسة، قاس أنور كتلة مكعّب معدني فوجدها m = 60 g وحجمه V = 20 cm³. ما كتلته الحجمية ρ؟', '[{"id":"a","text":"1200 g/cm³"},{"id":"b","text":"0.33 g/cm³"},{"id":"c","text":"80 g/cm³"},{"id":"d","text":"3 g/cm³"}]'::jsonb, 'd', 'نطبّق العلاقة ρ = m/V = 60/20 = 3 g/cm³. الخطأ 1200 ناتج عن الضرب m × V، والخطأ 0.33 ناتج عن قلب النسبة إلى V/m.', 4, 'mcq', NULL, NULL)
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
  ('8df39f3f-1bfe-5e02-b76b-d47bbc4f45c4', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'غمرت مريم حجرًا في مخبار مدرّج فيه ماء، فارتفع مستوى الماء من 40 cm³ إلى 55 cm³. ما حجم الحجر؟', '[{"id":"a","text":"15 cm³"},{"id":"b","text":"95 cm³"},{"id":"c","text":"55 cm³"},{"id":"d","text":"40 cm³"}]'::jsonb, 'a', 'بطريقة الإزاحة، حجم الحجر = V2 − V1 = 55 − 40 = 15 cm³. الرقم 95 ناتج عن الجمع بدل الطرح، و55 و40 هما القراءتان قبل وبعد الغمر لا حجم الحجر.', 5, 'mcq', NULL, NULL)
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
  ('133790bb-772b-5e35-bade-cd16ef09121c', 'b2fb5e28-2fa3-5d7a-b22e-c6b1d3c981d7', 'قطعة فلّين كتلتها الحجمية ρ = 0.7 g/cm³ وُضعت في حوض ماء (ρ الماء = 1 g/cm³). ماذا يحدث لها؟', '[{"id":"a","text":"ترسب لأنّ كتلتها الحجمية أكبر من كتلة الماء الحجمية"},{"id":"b","text":"تبقى معلّقة في منتصف الماء"},{"id":"c","text":"تطفو لأنّ كتلتها الحجمية أصغر من كتلة الماء الحجمية"},{"id":"d","text":"ترسب لأنّ كتلتها الحجمية أصغر من كتلة الماء الحجمية"}]'::jsonb, 'c', 'بما أنّ ρ = 0.7 g/cm³ أصغر من كتلة الماء الحجمية 1 g/cm³، فإنّ الفلّين يطفو. الطفو يحدث عندما تكون الكتلة الحجمية للجسم أصغر من كتلة الماء الحجمية.', 6, 'mcq', NULL, NULL)
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
  ('9e5504c1-2f9f-57f3-86a2-893643000aba', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: حساب الكتلة الحجمية والطفو', 3, 120, 30, 'boss', 'admin', 2)
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
  ('fb41b9f6-144b-51f5-9ebf-5b9e8252548f', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'قطعة ألمنيوم كتلتها m = 54 g وحجمها V = 20 cm³. ما كتلتها الحجمية ρ؟', '[{"id":"a","text":"1080 g/cm³"},{"id":"b","text":"0.37 g/cm³"},{"id":"c","text":"74 g/cm³"},{"id":"d","text":"2.7 g/cm³"}]'::jsonb, 'd', 'ρ = m/V = 54/20 = 2.7 g/cm³. الرقم 1080 ناتج عن الضرب m × V، و0.37 عن قلب النسبة V/m، و74 عن جمع m + V.', 1, 'mcq', NULL, NULL)
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
  ('4bd9d48b-dc39-5060-9379-7114100efd8c', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'قطعة زجاج كتلتها الحجمية ρ = 2.5 g/cm³ وحجمها V = 8 cm³. ما كتلتها m؟', '[{"id":"a","text":"3.2 g"},{"id":"b","text":"20 g"},{"id":"c","text":"10.5 g"},{"id":"d","text":"2.5 g"}]'::jsonb, 'b', 'من العلاقة ρ = m/V نستنتج m = ρ × V = 2.5 × 8 = 20 g. الرقم 3.2 ناتج عن قسمة V على ρ، و10.5 عن جمع ρ + V.', 2, 'mcq', NULL, NULL)
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
  ('5a13c6c8-120c-5f60-8873-75ad70591caf', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'غمر حاتم قطعة حديد كتلتها 79 g في مخبار مدرّج، فارتفع مستوى الماء من 10 cm³ إلى 20 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"7.9 g/cm³"},{"id":"b","text":"3.95 g/cm³"},{"id":"c","text":"2.63 g/cm³"},{"id":"d","text":"0.13 g/cm³"}]'::jsonb, 'a', 'أوّلًا حجم القطعة بالإزاحة: V = 20 − 10 = 10 cm³. ثمّ ρ = m/V = 79/10 = 7.9 g/cm³. الخطأ 3.95 يأتي من استعمال V2 = 20 دون طرح، و2.63 من استعمال V1 + V2 = 30.', 3, 'mcq', NULL, NULL)
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
  ('102dc1f3-d7b7-5be3-a84e-6210666a2524', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'صبّ عامل في معمل بصفاقس 100 cm³ من زيت الزيتون كتلته 90 g. احسب كتلته الحجمية ثمّ حدّد هل يطفو فوق الماء أم يرسب.', '[{"id":"a","text":"ρ = 0.9 g/cm³ ; يرسب لأنّها أكبر من كتلة الماء الحجمية"},{"id":"b","text":"يرسب لأنّ كتلته 90 g كبيرة نسبيًّا"},{"id":"c","text":"ρ = 0.9 g/cm³ ; يطفو لأنّها أصغر من كتلة الماء الحجمية 1 g/cm³"},{"id":"d","text":"يبقى معلّقًا لأنّ كتلته الحجمية تساوي كتلة الماء الحجمية"}]'::jsonb, 'c', 'ρ = m/V = 90/100 = 0.9 g/cm³، وهي أصغر من كتلة الماء الحجمية 1 g/cm³، فالزيت يطفو. القرار يكون بمقارنة الكتلة الحجمية لا الكتلة وحدها.', 4, 'mcq', NULL, NULL)
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
  ('fd2c873d-3efa-5152-9428-bc43f56776c9', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'كتلة حجمية لمادّة تساوي ρ = 2.7 g/cm³. كم تساوي بوحدة kg/m³؟', '[{"id":"a","text":"27 kg/m³"},{"id":"b","text":"2.7 kg/m³"},{"id":"c","text":"0.0027 kg/m³"},{"id":"d","text":"2700 kg/m³"}]'::jsonb, 'd', 'للتحويل من g/cm³ إلى kg/m³ نضرب في 1000: 2.7 × 1000 = 2700 kg/m³. لذلك 1 g/cm³ = 1000 kg/m³.', 5, 'mcq', NULL, NULL)
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
  ('0241bd0e-8185-5d7b-86b8-533a2b9e8270', '9e5504c1-2f9f-57f3-86a2-893643000aba', 'جسمان في الماء: الجسم A كتلته 2000 g وكتلته الحجمية 0.6 g/cm³ ; الجسم B كتلته 30 g وكتلته الحجمية 8 g/cm³. أيّهما يطفو؟', '[{"id":"a","text":"الجسم B يطفو لأنّه أخفّ كتلة"},{"id":"b","text":"الجسم A يطفو رغم أنّه أثقل، لأنّ كتلته الحجمية 0.6 g/cm³ أصغر من 1 g/cm³"},{"id":"c","text":"كلاهما يرسب لأنّهما جسمان صلبان"},{"id":"d","text":"الجسم A يرسب لأنّه أثقل كتلة"}]'::jsonb, 'b', 'المعيار هو الكتلة الحجمية لا الكتلة. الجسم A كتلته الحجمية 0.6 g/cm³ أصغر من 1 فيطفو رغم أنّه أثقل، والجسم B كتلته الحجمية 8 g/cm³ أكبر من 1 فيرسب رغم أنّه أخفّ.', 6, 'mcq', NULL, NULL)
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
  ('d25076ee-aee5-5de8-95c9-e16ba669eca2', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الكتلة الحجمية', 2, 70, 15, 'practice', 'admin', 3)
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
  ('fc862229-f738-5939-8684-b1c1b2069b29', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'لتعيين حجم مفتاح معدني غير منتظم الشكل، أيّ طريقة نستعمل؟', '[{"id":"a","text":"نزنه بالميزان"},{"id":"b","text":"نقيس طوله بالمسطرة فقط"},{"id":"c","text":"نقيس درجة حرارته بمقياس الحرارة"},{"id":"d","text":"طريقة الإزاحة: نغمره في مخبار مدرّج ونقرأ ارتفاع الماء"}]'::jsonb, 'd', 'الجسم الصلب غير المنتظم يُقاس حجمه بطريقة الإزاحة: حجمه = V2 − V1 (فرق مستوى الماء بعد الغمر وقبله). الميزان يقيس الكتلة لا الحجم.', 1, 'mcq', NULL, NULL)
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
  ('650a7239-f331-51fa-9e34-32ffed907b29', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'كم يساوي 1 L بوحدة السنتيمتر المكعّب؟', '[{"id":"a","text":"100 cm³"},{"id":"b","text":"1000 cm³"},{"id":"c","text":"10 cm³"},{"id":"d","text":"1000000 cm³"}]'::jsonb, 'b', '1 L = 1000 mL، وبما أنّ 1 mL = 1 cm³ فإنّ 1 L = 1000 cm³. أمّا 1000000 cm³ فهو حجم متر مكعّب واحد (1 m³).', 2, 'mcq', NULL, NULL)
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
  ('7e0394c6-f8d8-5be8-8acd-aca9088f34b7', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'قطعة معدنية كتلتها m = 48 g وحجمها V = 6 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"0.125 g/cm³"},{"id":"b","text":"288 g/cm³"},{"id":"c","text":"8 g/cm³"},{"id":"d","text":"42 g/cm³"}]'::jsonb, 'c', 'ρ = m/V = 48/6 = 8 g/cm³. الرقم 0.125 من قلب النسبة V/m، و288 من الضرب m × V، و42 من الطرح m − V.', 3, 'mcq', NULL, NULL)
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
  ('31cb9e0a-2b13-517d-b7f0-9272f2132429', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'صبّت نجاة عسلًا كتلته الحجمية ρ = 1.3 g/cm³ في كأس ماء (ρ الماء = 1 g/cm³). ماذا يحدث للعسل؟', '[{"id":"a","text":"يرسب لأنّ كتلته الحجمية أكبر من كتلة الماء الحجمية"},{"id":"b","text":"يطفو لأنّ كتلته الحجمية 1.3 g/cm³ أكبر من 1 g/cm³"},{"id":"c","text":"يطفو دائمًا لأنّه سائل مثل الماء"},{"id":"d","text":"يبقى معلّقًا في منتصف الكأس"}]'::jsonb, 'a', 'كتلة العسل الحجمية 1.3 g/cm³ أكبر من كتلة الماء الحجمية 1 g/cm³، فيرسب إلى قاع الكأس. الرسوب يحدث عندما تكون الكتلة الحجمية للجسم أكبر من كتلة الماء الحجمية.', 4, 'mcq', NULL, NULL)
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
  ('62905467-484e-5df0-a386-0826be46127f', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'غمر تلميذ قطعة معدنية كتلتها 120 g في مخبار، فارتفع الماء من 50 cm³ إلى 90 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"1.33 g/cm³"},{"id":"b","text":"2.4 g/cm³"},{"id":"c","text":"40 g/cm³"},{"id":"d","text":"3 g/cm³"}]'::jsonb, 'd', 'الحجم بالإزاحة: V = 90 − 50 = 40 cm³. ثمّ ρ = m/V = 120/40 = 3 g/cm³. الخطأ 1.33 يأتي من القسمة على V2 دون طرح، والخطأ 2.4 من القسمة على V1 دون طرح.', 5, 'mcq', NULL, NULL)
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
  ('bf26d0a7-d129-5676-b618-ae43a243961f', 'd25076ee-aee5-5de8-95c9-e16ba669eca2', 'أخذنا قطعتين من نفس الحديد النقيّ: الأولى حجمها 5 cm³ والثانية 20 cm³. ماذا نقول عن كتلتهما الحجمية؟', '[{"id":"a","text":"كتلة القطعة الكبيرة الحجمية أكبر لأنّها أضخم"},{"id":"b","text":"متساوية ; الكتلة الحجمية خاصّية مميّزة للمادّة لا تتعلّق بحجم العيّنة"},{"id":"c","text":"كتلة القطعة الصغيرة الحجمية أكبر"},{"id":"d","text":"لا يمكن معرفة ذلك دون قيس"}]'::jsonb, 'b', 'الكتلة الحجمية خاصّية مميّزة للمادّة ولا تتعلّق بحجم العيّنة: أيّ قطعة من الحديد النقيّ لها نفس الكتلة الحجمية (7.9 g/cm³)، لأنّ الكتلة والحجم يكبران معًا بنفس النسبة.', 6, 'mcq', NULL, NULL)
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
  ('639329d4-932e-54ad-881b-9700d5bd3790', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: إتقان الكتلة الحجمية والطفو', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1b32af39-9823-5a51-99c4-8fc096d0c78f', '639329d4-932e-54ad-881b-9700d5bd3790', 'خزّان صغير يحتوي 2 L من الماء النقيّ (ρ = 1 g/cm³). ما كتلة هذا الماء؟', '[{"id":"a","text":"2 g"},{"id":"b","text":"0.002 g"},{"id":"c","text":"2000 g"},{"id":"d","text":"500 g"}]'::jsonb, 'c', 'نحوّل الحجم أوّلًا: 2 L = 2000 cm³. ثمّ m = ρ × V = 1 × 2000 = 2000 g (أي 2 kg). الخطأ الشائع هو نسيان تحويل اللتر إلى سنتيمتر مكعّب.', 1, 'mcq', NULL, NULL)
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
  ('5942ea1b-5aca-5853-8208-47ddde86183a', '639329d4-932e-54ad-881b-9700d5bd3790', 'لوح خشبيّ كتلته m = 48 g وحجمه V = 60 cm³. احسب كتلته الحجمية ثمّ حدّد سلوكه في الماء.', '[{"id":"a","text":"ρ = 0.8 g/cm³ ; يطفو لأنّها أصغر من كتلة الماء الحجمية 1 g/cm³"},{"id":"b","text":"ρ = 1.25 g/cm³ ; يرسب"},{"id":"c","text":"ρ = 0.8 g/cm³ ; يرسب"},{"id":"d","text":"ρ = 2880 g/cm³ ; يطفو"}]'::jsonb, 'a', 'ρ = m/V = 48/60 = 0.8 g/cm³، وهي أصغر من 1 g/cm³ فالخشب يطفو. الخطأ 1.25 ناتج عن قلب النسبة V/m، و2880 عن الضرب m × V.', 2, 'mcq', NULL, NULL)
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
  ('96554ca5-c4fe-5e3c-9420-75bc70b96878', '639329d4-932e-54ad-881b-9700d5bd3790', 'صبّ فوزي زيتًا (ρ = 0.9 g/cm³) وماءً (ρ = 1 g/cm³) في نفس الكأس وتركهما يستقرّان. كيف يترتّبان؟', '[{"id":"a","text":"الماء فوق الزيت لأنّ كتلته الحجمية أصغر"},{"id":"b","text":"الزيت فوق الماء لأنّ كتلته الحجمية أصغر من كتلة الماء الحجمية"},{"id":"c","text":"يمتزجان في طبقة واحدة متجانسة"},{"id":"d","text":"الزيت تحت الماء لأنّه أثقل"}]'::jsonb, 'b', 'السائل الأصغر كتلة حجمية يعلو فوق الأكبر. بما أنّ كتلة الزيت الحجمية 0.9 g/cm³ أصغر من كتلة الماء الحجمية 1 g/cm³، يطفو الزيت في طبقة فوق الماء.', 3, 'mcq', NULL, NULL)
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
  ('7ca0d54a-fc96-57c1-9354-399b8a013964', '639329d4-932e-54ad-881b-9700d5bd3790', 'قطعة من مادّة كتلتها الحجمية ρ = 3 g/cm³ وكتلتها m = 150 g. ما حجمها V؟', '[{"id":"a","text":"450 cm³"},{"id":"b","text":"0.02 cm³"},{"id":"c","text":"50 cm³"},{"id":"d","text":"147 cm³"}]'::jsonb, 'c', 'من العلاقة ρ = m/V نستنتج V = m/ρ = 150/3 = 50 cm³. الخطأ 450 ناتج عن الضرب m × ρ، و147 عن الطرح m − ρ.', 4, 'mcq', NULL, NULL)
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
  ('dbdfe332-14c6-5647-93dd-731049981f4f', '639329d4-932e-54ad-881b-9700d5bd3790', 'كتلتان متساويتان (m = 100 g) من مادّتين مختلفتين: الأولى حجمها 20 cm³ والثانية 50 cm³. أيّهما أكبر كتلة حجمية؟', '[{"id":"a","text":"الثانية (ذات الحجم الأكبر) لأنّها أضخم"},{"id":"b","text":"متساويتان ما دامت الكتلتان متساويتين"},{"id":"c","text":"لا يمكن الحساب دون معرفة اسم المادّة"},{"id":"d","text":"الأولى (ذات الحجم الأصغر) ; ρ = 5 g/cm³ أكبر من ρ = 2 g/cm³ للثانية"}]'::jsonb, 'd', 'نحسب الكتلة الحجمية لكلّ قطعة: ρ1 = 100/20 = 5 g/cm³ و ρ2 = 100/50 = 2 g/cm³. فعند تساوي الكتلة، القطعة ذات الحجم الأصغر لها كتلة حجمية أكبر.', 5, 'mcq', NULL, NULL)
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
  ('b8c2789d-fc0d-5c4e-870c-f64615ac583c', '639329d4-932e-54ad-881b-9700d5bd3790', 'سفينة فولاذية كتلتها آلاف الأطنان تطفو فوق البحر، بينما مسمار فولاذيّ صغير يرسب فورًا. ما التفسير الصحيح؟', '[{"id":"a","text":"ماء البحر أكثر ملوحة تحت السفينة فقط"},{"id":"b","text":"شكل السفينة المجوّف يحبس هواءً كثيرًا، فتصبح الكتلة الحجمية الوسطى لمجموع (الفولاذ + الهواء) أصغر من كتلة الماء الحجمية"},{"id":"c","text":"الفولاذ في السفينة نوع مختلف تمامًا عن فولاذ المسمار"},{"id":"d","text":"السفينة في الحقيقة أخفّ كتلة من المسمار"}]'::jsonb, 'b', 'المسمار الفولاذيّ المصمت كتلته الحجمية كبيرة (نحو 7.9 g/cm³) فيرسب. أمّا السفينة فشكلها المجوّف يحبس هواءً كثيرًا، فتصير الكتلة الحجمية الوسطى للمجموع أصغر من كتلة الماء الحجمية، فتطفو رغم ثقلها الكبير.', 6, 'mcq', NULL, NULL)
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
  ('6f2168ac-8732-5d94-ac82-a03f5a49fe84', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: تدريب شامل على الكتلة الحجمية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('57fba02d-8ab7-51e3-bf84-3cecbfa128b4', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'سبيكة كتلتها m = 64 g وحجمها V = 8 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"8 g/cm³"},{"id":"b","text":"0.125 g/cm³"},{"id":"c","text":"512 g/cm³"},{"id":"d","text":"72 g/cm³"}]'::jsonb, 'a', 'ρ = m/V = 64/8 = 8 g/cm³. الرقم 0.125 من قلب النسبة V/m، و512 من الضرب m × V، و72 من الجمع m + V.', 1, 'mcq', NULL, NULL)
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
  ('253e4efa-383f-5e13-a984-8adeb1f3a4c5', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'صبّ عامل في معمل زيت 200 cm³ من الزيت (ρ = 0.9 g/cm³) في قارورة. ما كتلة هذا الزيت؟', '[{"id":"a","text":"222 g"},{"id":"b","text":"180 g"},{"id":"c","text":"200.9 g"},{"id":"d","text":"0.0045 g"}]'::jsonb, 'b', 'm = ρ × V = 0.9 × 200 = 180 g. الخطأ 222 ناتج عن قسمة V على ρ بدل الضرب.', 2, 'mcq', NULL, NULL)
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
  ('10b10e38-6e87-5410-9746-351d17e5ad34', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'غمرت ليلى قطعة معدنية كتلتها 105 g في مخبار مدرّج، فارتفع الماء من 25 cm³ إلى 60 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"1.75 g/cm³"},{"id":"b","text":"4.2 g/cm³"},{"id":"c","text":"3 g/cm³"},{"id":"d","text":"35 g/cm³"}]'::jsonb, 'c', 'الحجم بالإزاحة: V = 60 − 25 = 35 cm³. ثمّ ρ = m/V = 105/35 = 3 g/cm³. الخطأ 1.75 يأتي من القسمة على V2 دون طرح، والخطأ 4.2 من القسمة على V1 دون طرح.', 3, 'mcq', NULL, NULL)
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
  ('f927dc22-31e4-5d0c-a788-14ef07429cdc', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'جسم كتلته m = 140 g وحجمه V = 100 cm³. هل يطفو فوق الماء أم يرسب؟', '[{"id":"a","text":"يطفو ; كتلته الحجمية 1.4 g/cm³ أصغر من 1 g/cm³"},{"id":"b","text":"يبقى معلّقًا في منتصف الماء"},{"id":"c","text":"يطفو لأنّ حجمه 100 cm³ كبير"},{"id":"d","text":"يرسب ; كتلته الحجمية 1.4 g/cm³ أكبر من كتلة الماء الحجمية"}]'::jsonb, 'd', 'ρ = m/V = 140/100 = 1.4 g/cm³، وهي أكبر من كتلة الماء الحجمية 1 g/cm³، فالجسم يرسب. القرار يعتمد على الكتلة الحجمية لا الحجم وحده.', 4, 'mcq', NULL, NULL)
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
  ('8f197ba9-afb7-563d-a438-6a2882dd72ca', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'كتلة حجمية لمعدن تساوي ρ = 8 g/cm³. كم تساوي بوحدة kg/m³؟', '[{"id":"a","text":"0.008 kg/m³"},{"id":"b","text":"8000 kg/m³"},{"id":"c","text":"80 kg/m³"},{"id":"d","text":"800 kg/m³"}]'::jsonb, 'b', 'للتحويل من g/cm³ إلى kg/m³ نضرب في 1000: 8 × 1000 = 8000 kg/m³، لأنّ 1 g/cm³ = 1000 kg/m³.', 5, 'mcq', NULL, NULL)
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
  ('4bce9599-314c-5f32-9c0e-5b8f7be11244', '6f2168ac-8732-5d94-ac82-a03f5a49fe84', 'قطعنا سبيكة نحاس متجانسة إلى نصفين متساويين. ماذا يحدث للكتلة الحجمية لكلّ نصف مقارنة بالسبيكة الأصلية؟', '[{"id":"a","text":"تصير النصف لأنّ الكتلة صارت النصف"},{"id":"b","text":"تتضاعف لأنّ القطعة صغرت"},{"id":"c","text":"تبقى نفسها ; الكتلة والحجم ينقسمان بنفس النسبة فتبقى النسبة ρ = m/V ثابتة"},{"id":"d","text":"تصبح صفرًا"}]'::jsonb, 'c', 'عند تقطيع السبيكة إلى نصفين، تصير كتلة كلّ نصف النصف وحجمه النصف أيضًا، فتبقى النسبة ρ = m/V نفسها. الكتلة الحجمية خاصّية مميّزة للمادّة لا تتغيّر بالتقطيع.', 6, 'mcq', NULL, NULL)
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
  ('40d77d53-30ce-54a0-ac62-242df9edfa69', '0c144304-84ae-5eef-acd0-cef6c070a75b', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: قمّة الكتلة الحجمية والطفو', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('af653de9-33ac-5907-906b-f5dee8afcee3', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'صخرة كتلتها m = 1500 g وحجمها V = 500 cm³. ما كتلتها الحجمية؟', '[{"id":"a","text":"0.33 g/cm³"},{"id":"b","text":"2000 g/cm³"},{"id":"c","text":"750000 g/cm³"},{"id":"d","text":"3 g/cm³"}]'::jsonb, 'd', 'ρ = m/V = 1500/500 = 3 g/cm³. الرقم 0.33 من قلب النسبة V/m، و2000 من الجمع m + V، و750000 من الضرب m × V.', 1, 'mcq', NULL, NULL)
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
  ('61c036b0-210f-506c-82dd-1adacf13e97c', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'جسم متجانس كتلته m = 250 g وحجمه V = 250 cm³. احسب كتلته الحجمية وحدّد سلوكه في الماء.', '[{"id":"a","text":"ρ = 1 g/cm³ ; يبقى معلّقًا لأنّها تساوي كتلة الماء الحجمية"},{"id":"b","text":"ρ = 1 g/cm³ ; يرسب حتمًا إلى القاع"},{"id":"c","text":"ρ = 0.5 g/cm³ ; يطفو"},{"id":"d","text":"ρ = 250 g/cm³ ; يرسب"}]'::jsonb, 'a', 'ρ = m/V = 250/250 = 1 g/cm³، وهي تساوي تمامًا كتلة الماء الحجمية، فيبقى الجسم معلّقًا داخل الماء (لا يطفو ولا يرسب). هذه هي الحالة الوسطى بين الطفو والرسوب.', 2, 'mcq', NULL, NULL)
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
  ('c291c0c4-e037-5732-a3f8-09d73d5d2db8', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'مادّة كتلتها الحجمية ρ = 700 kg/m³. هل تطفو فوق الماء (ρ الماء = 1000 kg/m³)؟', '[{"id":"a","text":"ترسب ; 700 kg/m³ أكبر من 1000 kg/m³"},{"id":"b","text":"ترسب لأنّ الرقم 700 كبير"},{"id":"c","text":"تطفو ; 700 kg/m³ أصغر من كتلة الماء الحجمية 1000 kg/m³"},{"id":"d","text":"تبقى معلّقة تمامًا في الماء"}]'::jsonb, 'c', 'المقارنة تكون بنفس الوحدة: 700 kg/m³ أصغر من كتلة الماء الحجمية 1000 kg/m³ (أي 0.7 g/cm³ أصغر من 1 g/cm³)، فالمادّة تطفو.', 3, 'mcq', NULL, NULL)
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
  ('168b00f3-0145-5bbf-a5f5-1f50bf2a5534', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'وعاء حجمه 0.4 L مملوء بمادّة كتلتها الحجمية ρ = 2.5 g/cm³. ما كتلة المادّة؟', '[{"id":"a","text":"1 g"},{"id":"b","text":"160 g"},{"id":"c","text":"2.9 g"},{"id":"d","text":"1000 g"}]'::jsonb, 'd', 'نحوّل الحجم أوّلًا: 0.4 L = 400 cm³. ثمّ m = ρ × V = 2.5 × 400 = 1000 g (أي 1 kg). الخطأ الشائع هو استعمال 0.4 دون تحويل اللتر إلى سنتيمتر مكعّب.', 4, 'mcq', NULL, NULL)
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
  ('8fba674b-e01f-54c5-a124-2fb62ca9a920', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'جسمان لهما نفس الكتلة 90 g. الأوّل أزاح 30 cm³ من الماء والثاني أزاح 15 cm³. أيّهما أكبر كتلة حجمية؟', '[{"id":"a","text":"الأوّل لأنّه أزاح حجمًا أكبر من الماء"},{"id":"b","text":"الثاني ; كتلته الحجمية 6 g/cm³ أكبر من 3 g/cm³ للأوّل"},{"id":"c","text":"متساويان لأنّ كتلتيهما متساويتان"},{"id":"d","text":"لا يمكن المقارنة دون معرفة المادّة"}]'::jsonb, 'b', 'الحجم المُزاح هو حجم الجسم. ρ الأوّل = 90/30 = 3 g/cm³ و ρ الثاني = 90/15 = 6 g/cm³. فعند تساوي الكتلة، الجسم الأصغر حجمًا (الأقلّ إزاحة) له كتلة حجمية أكبر.', 5, 'mcq', NULL, NULL)
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
  ('1ddecf43-395e-52bb-b923-89182b78e477', '40d77d53-30ce-54a0-ac62-242df9edfa69', 'يطفو الجليد فوق الماء السائل في كأس مشروب بارد. ما التفسير المتوافق مع مفهوم الكتلة الحجمية؟', '[{"id":"a","text":"الجليد أثقل من الماء السائل فيبقى في الأعلى"},{"id":"b","text":"الكتلة الحجمية للجليد أكبر من كتلة الماء السائل الحجمية"},{"id":"c","text":"الكتلة الحجمية للجليد (نحو 0.92 g/cm³) أصغر من كتلة الماء السائل الحجمية (1 g/cm³) فيطفو"},{"id":"d","text":"الأمر مجرّد صدفة لا تفسير علمي له"}]'::jsonb, 'c', 'يطفو الجليد لأنّ كتلته الحجمية (نحو 0.92 g/cm³) أصغر من كتلة الماء السائل الحجمية (1 g/cm³). فالطفو يفسَّر دائمًا بمقارنة الكتل الحجمية، لا بالكتلة وحدها.', 6, 'mcq', NULL, NULL)
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
  ('72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a50a1c2b-4681-551a-94ee-7c130243fba3', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'بأيّ رمز اصطلاحي يُمثَّل المولّد في رسم الدارة الكهربائية؟', '[{"id":"a","text":"دائرة بداخلها علامة تقاطع (×)"},{"id":"b","text":"خطّان متوازيان مختلفا الطول"},{"id":"c","text":"دائرة بداخلها الحرف M"},{"id":"d","text":"خطّ مستقيم منقطع في نقطة"}]'::jsonb, 'b', 'يُمثَّل المولّد بخطّين متوازيَين مختلفَي الطول: الطويل قطبه الموجب (+) والقصير قطبه السالب (−). الدائرة بها × رمز المصباح، والدائرة بها M رمز المحرّك، والخطّ المنقطع رمز القاطع المفتوح.', 1, 'mcq', NULL, NULL)
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
  ('f8022285-128f-5e7f-8595-98d95af75ebb', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'متى يجري التيّار الكهربائي في دارة بسيطة فيعمل المستقبل؟', '[{"id":"a","text":"عندما تكون الدارة مغلقة دون أيّ انقطاع"},{"id":"b","text":"عندما يكون فيها انقطاع في نقطة واحدة"},{"id":"c","text":"عندما يكون القاطع مفتوحًا"},{"id":"d","text":"عندما يُقطَع أحد أسلاك التوصيل"}]'::jsonb, 'a', 'التيّار لا يجري إلّا في دارة مغلقة (مسار متّصل بالكامل دون انقطاع). أيّ انقطاع في نقطة واحدة — سلك مقطوع أو قاطع مفتوح — يجعل الدارة مفتوحة فيتوقّف التيّار.', 2, 'mcq', NULL, NULL)
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
  ('cd1e8e59-dd67-538d-98c3-2638008ff68c', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'أيّ مادّة من التالية عازلة لا تسمح بمرور التيّار الكهربائي؟', '[{"id":"a","text":"النحاس"},{"id":"b","text":"الحديد"},{"id":"c","text":"الخشب الجافّ"},{"id":"d","text":"الماء الذي يحوي أملاحًا مذابة"}]'::jsonb, 'c', 'الخشب الجافّ مادّة عازلة تمنع مرور التيّار. النحاس والحديد معدنان ناقلان، والماء الذي يحوي أملاحًا مذابة ناقل أيضًا.', 3, 'mcq', NULL, NULL)
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
  ('266710e1-5c1f-5ffc-bb1d-f4db1787b43b', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'في تركيب بالتسلسل يحتوي على ثلاثة مصابيح في حلقة واحدة، احترق المصباح الأوسط. ماذا يحدث للمصباحَين الآخرَين؟', '[{"id":"a","text":"يبقيان مضيئَين بشكل طبيعي"},{"id":"b","text":"يتحوّلان إلى محرّكَين"},{"id":"c","text":"يضيئان بقوّة أكبر من قبل"},{"id":"d","text":"ينطفئان أيضًا، لأنّ الحلقة الوحيدة انقطعت فأصبحت الدارة مفتوحة"}]'::jsonb, 'd', 'في التركيب بالتسلسل يمرّ التيّار في مسار وحيد؛ احتراق مصباح واحد يقطع هذه الحلقة الوحيدة فتصبح الدارة مفتوحة وينطفئ الجميع معًا، لا المصباح المحترق وحده.', 4, 'mcq', NULL, NULL)
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
  ('bcf1be1b-2e12-59c3-b8da-9b1937ea64dd', '72d7c61e-fe6b-56cb-8a12-f258d0e040f6', 'لماذا تُركَّب إنارة المنازل بالتفرّع لا بالتسلسل؟', '[{"id":"a","text":"لكي ينطفئ كلّ مصابيح البيت معًا عند إطفاء أيّ مصباح"},{"id":"b","text":"لأنّ التفرّع لا يحتاج إلى مولّد"},{"id":"c","text":"لكي تضيء المصابيح باستقلال، فيبقى بقية البيت مضيئًا عند إطفاء مصباح غرفة واحدة"},{"id":"d","text":"لأنّ التفرّع يجعل كلّ المصابيح تضيء أضعف"}]'::jsonb, 'c', 'في التركيب بالتفرّع لكلّ مصباح فرعه المستقلّ، فيمكن إشعاله أو إطفاؤه دون أن يتأثّر بقية البيت، وتضيء المصابيح بكامل شدّتها؛ لذلك تُنار المنازل بالتفرّع لا بالتسلسل.', 5, 'mcq', NULL, NULL)
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
  ('644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '⭐ تمرين: مكوّنات الدارة والتسلسل والتفرّع', 1, 50, 10, 'practice', 'admin', 1)
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
  ('fc191a28-350f-5797-91b0-dc17fc2bef70', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'ما اسم العنصر الذي يتحكّم في فتح الدارة الكهربائية أو غلقها عن قصد؟', '[{"id":"a","text":"المولّد"},{"id":"b","text":"القاطع"},{"id":"c","text":"المصباح"},{"id":"d","text":"سلك التوصيل"}]'::jsonb, 'b', 'القاطع (المفتاح) هو العنصر الذي يتحكّم عن قصد في فتح الدارة أو غلقها: يغلقها فيجري التيّار، أو يفتحها فيتوقّف.', 1, 'mcq', NULL, NULL)
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
  ('895f2579-d977-562d-9a45-e242b6d37fb9', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'في التركيب بالتسلسل، كم عدد المسارات التي يجري فيها التيّار الكهربائي؟', '[{"id":"a","text":"مسار واحد فقط (حلقة وحيدة)"},{"id":"b","text":"مساران دائمًا"},{"id":"c","text":"عدّة مسارات متوازية"},{"id":"d","text":"لا مسار إطلاقًا"}]'::jsonb, 'a', 'في التركيب بالتسلسل تُوصَل المستقبلات الواحد تلو الآخر في حلقة واحدة فقط، فيمرّ التيّار في مسار وحيد يعبر كلّ مصباح بالترتيب.', 2, 'mcq', NULL, NULL)
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
  ('86d09f02-4936-584b-b703-6ef2b2636c10', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'ما اسم الدارة التي يوجد فيها انقطاع في نقطة واحدة على الأقلّ فلا يجري فيها التيّار؟', '[{"id":"a","text":"دارة مغلقة"},{"id":"b","text":"دارة بالتفرّع"},{"id":"c","text":"دارة مفتوحة"},{"id":"d","text":"دارة بالتسلسل"}]'::jsonb, 'c', 'الدارة المفتوحة فيها فجوة أو انقطاع في نقطة واحدة على الأقلّ (سلك مقطوع أو قاطع مفتوح)، فلا يجري فيها التيّار الكهربائي.', 3, 'mcq', NULL, NULL)
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
  ('98a6eb19-114e-5464-990d-079a750dcfc6', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'في التركيب بالتفرّع، كيف تُوصَل المصابيح؟', '[{"id":"a","text":"الواحد تلو الآخر في حلقة واحدة"},{"id":"b","text":"داخل المولّد نفسه"},{"id":"c","text":"خارج الدارة تمامًا"},{"id":"d","text":"على فروع منفصلة بين نقطتَي تفرّع مشتركتَين"}]'::jsonb, 'd', 'في التركيب بالتفرّع تُوصَل المستقبلات على فروع منفصلة بين نقطتَي تفرّع (عقدتَين) مشتركتَين، فيجد التيّار عدّة مسارات؛ لكلّ مصباح فرعه الخاصّ.', 4, 'mcq', NULL, NULL)
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
  ('3dadbec2-5efa-5ddb-a306-2b05e0cf6083', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'أيّ مادّة من التالية ناقلة تسمح بمرور التيّار الكهربائي؟', '[{"id":"a","text":"الزجاج"},{"id":"b","text":"المطّاط"},{"id":"c","text":"الألمنيوم"},{"id":"d","text":"الخشب الجافّ"}]'::jsonb, 'c', 'الألمنيوم معدن، ومعظم المعادن موادّ ناقلة تسمح بمرور التيّار؛ أمّا الزجاج والمطّاط والخشب الجافّ فموادّ عازلة.', 5, 'mcq', NULL, NULL)
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
  ('a9f19831-ac0b-59a1-aad0-3be3405e7bf1', '644691d8-3ac3-5057-bacf-7ed7e4a5bc23', 'في تركيب بالتسلسل يحتوي على مصباحَين، نُزع أحدهما من مكانه. ماذا يحدث للمصباح الثاني؟', '[{"id":"a","text":"ينطفئ، لأنّ نزع المصباح قطع الحلقة الوحيدة فأصبحت الدارة مفتوحة"},{"id":"b","text":"يبقى مضيئًا بشكل طبيعي"},{"id":"c","text":"يضيء بقوّة مضاعفة"},{"id":"d","text":"لا يتأثّر لأنّ لكلّ مصباح فرعه المستقلّ"}]'::jsonb, 'a', 'في التركيب بالتسلسل يمرّ التيّار في حلقة وحيدة؛ نزع مصباح واحد يترك فجوة تقطع الحلقة فتصبح الدارة مفتوحة، فينطفئ المصباح الثاني أيضًا. الاستقلال بين الفروع خاصّية التفرّع لا التسلسل.', 6, 'mcq', NULL, NULL)
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
  ('592d8f4e-40c2-577c-b1d3-4622b6586c88', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: تسلسل أم تفرّع؟', 3, 120, 30, 'boss', 'admin', 2)
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
  ('10a19083-6cba-5056-b5f7-3c06ac8405fe', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'ركّبت هالة مصباحَين على فرعَين منفصلَين بين نقطتَي تفرّع مشتركتَين مع المولّد. ما اسم هذا التركيب؟', '[{"id":"a","text":"التركيب بالتفرّع"},{"id":"b","text":"التركيب بالتسلسل"},{"id":"c","text":"الدارة القصيرة"},{"id":"d","text":"الدارة المفتوحة"}]'::jsonb, 'a', 'توصيل المصابيح على فروع منفصلة بين نقطتَي تفرّع مشتركتَين هو تعريف التركيب بالتفرّع، حيث يجد التيّار عدّة مسارات ولكلّ مصباح فرعه الخاصّ.', 1, 'mcq', NULL, NULL)
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
  ('553f23d2-3f1a-5a6f-a385-fdd8efd903e0', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'في سلسلة أضواء عيد قديمة مركّبة بالتسلسل، لاحظ سامي أنّ الصفّ كلّه مُطفأ رغم أنّ المولّد سليم. ما التفسير الأرجح؟', '[{"id":"a","text":"المصابيح كلّها احترقت في اللحظة نفسها بالصدفة"},{"id":"b","text":"احترق أو انفكّ مصباح واحد فقط، فقطع الحلقة الوحيدة وأطفأ الجميع"},{"id":"c","text":"التركيب بالتسلسل لا يضيء أبدًا"},{"id":"d","text":"المولّد يستهلك الطاقة بدل أن يزوّدها"}]'::jsonb, 'b', 'في التسلسل يكفي عطب مصباح واحد (احتراق أو انفكاك) ليقطع المسار الوحيد فتصبح الدارة مفتوحة وينطفئ الصفّ كلّه. لهذا يصعب تحديد المصباح المعطوب في هذا التركيب.', 2, 'mcq', NULL, NULL)
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
  ('63a7816d-5637-5a8d-b202-1f0291b945f3', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'في تركيب بالتفرّع يحتوي على ثلاثة مصابيح على ثلاثة فروع، احترق مصباح فرع واحد. ماذا يحدث للمصباحَين الآخرَين؟', '[{"id":"a","text":"ينطفئان أيضًا كما في التسلسل"},{"id":"b","text":"يضيئان بقوّة أضعف بكثير"},{"id":"c","text":"يبقيان مضيئَين عادةً، لأنّ فرعَيهما دارتان مغلقتان مستقلّتان"},{"id":"d","text":"يتحوّلان إلى محرّكَين"}]'::jsonb, 'c', 'في التفرّع كلّ فرع دارة مغلقة مستقلّة؛ احتراق مصباح فرع يفتح ذلك الفرع وحده، بينما تبقى الفروع الأخرى مغلقة فتظلّ مصابيحها مضيئة عادةً.', 3, 'mcq', NULL, NULL)
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
  ('4b6ec99c-3f48-513f-a532-8b9cfc91ef71', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'قارن أيمن بين مصباح وحيد في دارة بسيطة، ثمّ أضاف إليه مصباحًا ثانيًا مماثلًا مرّة بالتسلسل ومرّة بالتفرّع (المولّد نفسه). في أيّ حالة يضيء كلّ مصباح بشدّة أقرب إلى شدّة المصباح الوحيد؟', '[{"id":"a","text":"في التسلسل، لأنّ المصابيح تتقاسم مسارًا واحدًا"},{"id":"b","text":"في التفرّع، لأنّ كلّ مصباح يعمل على فرعه المستقلّ كأنّه وحده"},{"id":"c","text":"الشدّة نفسها تمامًا في التركيبَين"},{"id":"d","text":"لا يضيء أيّ مصباح في التركيبَين"}]'::jsonb, 'b', 'في التفرّع يعمل كلّ مصباح على فرعه المستقلّ فيضيء بكامل شدّته كأنّه وحده؛ أمّا في التسلسل فيتقاسم المصباحان طاقة المولّد نفسها فيضيء كلّ منهما أضعف.', 4, 'mcq', NULL, NULL)
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
  ('9b355ce8-ccb7-5d4d-849f-5c2df0e599f2', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'أراد وليد أن يطفئ مصباح مكتبه فقط دون أن ينطفئ مصباح السقف في الغرفة نفسها. أيّ تركيب وأيّ موضع للقاطع يحقّق ذلك؟', '[{"id":"a","text":"تركيب بالتسلسل مع قاطع واحد على الحلقة"},{"id":"b","text":"توصيل المصباحَين مباشرة بقطبَي المولّد بسلك واحد"},{"id":"c","text":"تركيب بالتسلسل دون أيّ قاطع"},{"id":"d","text":"تركيب بالتفرّع مع قاطع على فرع مصباح المكتب وحده"}]'::jsonb, 'd', 'في التفرّع يمكن وضع قاطع على فرع واحد فيتحكّم في مصباحه وحده؛ فتح قاطع فرع المكتب يطفئ مصباح المكتب بينما يبقى مصباح السقف مضيئًا على فرعه. في التسلسل قاطع الحلقة يطفئ الجميع معًا.', 5, 'mcq', NULL, NULL)
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
  ('e98cb802-4d13-5c59-9a57-a1d4622d5c83', '592d8f4e-40c2-577c-b1d3-4622b6586c88', 'أيّ العبارات التالية عن التركيبَين **خاطئة**؟', '[{"id":"a","text":"في التسلسل، عطب مصباح واحد يطفئ كلّ المصابيح"},{"id":"b","text":"في التفرّع، لكلّ مصباح مسار مستقلّ عن الآخرين"},{"id":"c","text":"في التفرّع، احتراق مصباح فرع يطفئ كلّ مصابيح الدارة"},{"id":"d","text":"في التسلسل، كلّما زاد عدد المصابيح قلّت إضاءة كلّ واحد منها"}]'::jsonb, 'c', 'العبارة الخاطئة هي (ج): في التفرّع احتراق مصباح فرع يطفئ ذلك الفرع وحده وتبقى البقية مضيئة، فهو عكس التسلسل تمامًا. أمّا العبارات الأخرى فتصف بدقّة خصائص التسلسل والتفرّع.', 6, 'mcq', NULL, NULL)
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
  ('bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): من المكوّنات إلى التراكيب', 2, 70, 15, 'practice', 'admin', 3)
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
  ('6e5409f2-f31e-54ce-9665-3a1c0e513b9d', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'ما دور المولّد في الدارة الكهربائية؟', '[{"id":"a","text":"يزوّد الدارة بالطاقة اللازمة لجريان التيّار"},{"id":"b","text":"يحوّل الطاقة الكهربائية إلى ضوء"},{"id":"c","text":"يتحكّم في فتح الدارة وغلقها"},{"id":"d","text":"يعزل الأسلاك عن اليد"}]'::jsonb, 'a', 'المولّد (عمود أو بطّارية) يزوّد الدارة بالطاقة اللازمة لجريان التيّار، وله قطبان موجب وسالب. تحويل الطاقة إلى ضوء دور المصباح، والتحكّم دور القاطع.', 1, 'mcq', NULL, NULL)
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
  ('76d21ed2-8667-50da-8709-fbb6773f23a1', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'بأيّ رمز اصطلاحي يُمثَّل القاطع المفتوح؟', '[{"id":"a","text":"خطّ مستقيم متّصل بلا انقطاع"},{"id":"b","text":"خطّ مستقيم منقطع بفجوة بين طرفَيه"},{"id":"c","text":"دائرة بداخلها الحرف M"},{"id":"d","text":"خطّان متوازيان مختلفا الطول"}]'::jsonb, 'b', 'يُمثَّل القاطع المفتوح بخطّ منقطع تاركًا فجوة بين طرفَيه (يقطع الدارة)، بينما القاطع المغلق خطّ متّصل بلا انقطاع.', 2, 'mcq', NULL, NULL)
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
  ('8234c0f0-1eb7-5bca-85dd-ac93f5915741', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'دارة مغلقة بها مصباح واحد يضيء عادةً. أُدخلت في مسار سلكها قطعة من الزجاج. ماذا يحدث للمصباح؟', '[{"id":"a","text":"يضيء بشكل طبيعي لأنّ الزجاج شفّاف"},{"id":"b","text":"يضيء بقوّة أكبر"},{"id":"c","text":"ينطفئ، لأنّ الزجاج مادّة عازلة تقطع مسار التيّار فتصبح الدارة مفتوحة"},{"id":"d","text":"يتحوّل إلى محرّك"}]'::jsonb, 'c', 'الزجاج مادّة عازلة رغم شفافيته؛ إدخاله في مسار السلك يقطع مرور التيّار فتصبح الدارة مفتوحة فعليًّا وينطفئ المصباح. الشفافية لا علاقة لها بالناقلية.', 3, 'mcq', NULL, NULL)
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
  ('614f929c-cbbb-5cbc-8750-ee202eb86956', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'ثلاثة مصابيح مركّبة بالتسلسل في حلقة واحدة مع قاطع واحد. فتح التلميذ القاطع. ماذا يحدث للمصابيح الثلاثة؟', '[{"id":"a","text":"ينطفئ مصباح واحد فقط"},{"id":"b","text":"تنطفئ الثلاثة معًا، لأنّ فتح القاطع يفتح الحلقة الوحيدة"},{"id":"c","text":"تبقى مضيئة لأنّ القاطع لا يؤثّر في التسلسل"},{"id":"d","text":"يضيء مصباح ويبقى اثنان مطفأَين"}]'::jsonb, 'b', 'في التسلسل يتحكّم القاطع الواحد الموضوع على الحلقة في كلّ المصابيح؛ فتحه يفتح المسار الوحيد فتنطفئ المصابيح الثلاثة معًا.', 4, 'mcq', NULL, NULL)
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
  ('fc0e0d5c-95c6-57a4-ad40-95c3cd0cef49', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'في تركيب بالتفرّع بمصباحَين على فرعَين، نزع خالد مصباح الفرع الأوّل. كيف يكون سلوك مصباح الفرع الثاني؟', '[{"id":"a","text":"ينطفئ لأنّ الدارة كلّها أصبحت مفتوحة"},{"id":"b","text":"يتوقّف المولّد عن العمل"},{"id":"c","text":"يضيء لثوانٍ ثمّ ينطفئ نهائيًّا"},{"id":"d","text":"يبقى مضيئًا عادةً لأنّ فرعه دارة مغلقة مستقلّة"}]'::jsonb, 'd', 'نزع مصباح فرع في التفرّع يفتح ذلك الفرع وحده، بينما يبقى الفرع الثاني دارة مغلقة مستقلّة، فيظلّ مصباحه مضيئًا عادةً. هذا هو الفرق الجوهري عن التسلسل.', 5, 'mcq', NULL, NULL)
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
  ('08f73ec8-f95b-5f30-a510-1eda3a29c5cc', 'bce0b1fc-b545-599b-9e55-e7a4f52697eb', 'لماذا تُغلَّف أسلاك التوصيل النحاسية بطبقة من البلاستيك؟', '[{"id":"a","text":"لأنّ البلاستيك ناقل أفضل من النحاس"},{"id":"b","text":"لزيادة عدد المصابيح التي تعمل"},{"id":"c","text":"لأنّ البلاستيك عازل يمنع وصول التيّار إلى يد من يمسك السلك"},{"id":"d","text":"لتحويل التركيب من تسلسل إلى تفرّع"}]'::jsonb, 'c', 'اللبّ النحاسي ناقل ينقل التيّار، ويُغلَّف بالبلاستيك العازل لمنع التيّار من الوصول إلى يد من يمسك السلك، فتُضمَن السلامة.', 6, 'mcq', NULL, NULL)
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
  ('3aa750a3-e085-512c-af1e-00573ae9b8f2', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: إتقان التسلسل والتفرّع', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5d60f279-3f7d-54f8-b30c-22bb1e9c5348', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'دارة بها مصباحان مركّبان بالتسلسل مع قاطع مغلق ومولّد سليم، لكنّ المصباحَين لا يضيئان. فحص الفنّي فوجد أنّ فتيل المصباح الأوّل مقطوع من الداخل. لماذا انطفأ المصباح الثاني السليم أيضًا؟', '[{"id":"a","text":"لأنّ فتيل المصباح الأوّل المقطوع فتح الحلقة الوحيدة، فتوقّف التيّار في المسار كلّه"},{"id":"b","text":"لأنّ المصباح الثاني احترق هو أيضًا بالصدفة"},{"id":"c","text":"لأنّ المولّد توقّف عن التزويد بالطاقة"},{"id":"d","text":"لأنّ القاطع المغلق يمنع مرور التيّار"}]'::jsonb, 'a', 'في التسلسل يعبر التيّار مسارًا وحيدًا؛ فتيل مقطوع في المصباح الأوّل يترك فجوة تجعل الدارة مفتوحة، فلا يجري التيّار في المسار كلّه وينطفئ المصباح الثاني السليم أيضًا رغم سلامته.', 1, 'mcq', NULL, NULL)
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
  ('ffee084f-1a4c-57e5-889c-d5a95984cdcd', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'ركّبت مهندسة مصباحَين متماثلَين مرّة بالتسلسل ومرّة بالتفرّع بالمولّد نفسه، وسجّلت: (تركيب 1) عند نزع مصباح ينطفئ الآخر وإضاءة كلّ مصباح ضعيفة؛ (تركيب 2) عند نزع مصباح يبقى الآخر مضيئًا بكامل شدّته. ما التركيبان بالترتيب؟', '[{"id":"a","text":"تركيب 1 بالتفرّع، وتركيب 2 بالتسلسل"},{"id":"b","text":"تركيب 1 بالتسلسل، وتركيب 2 بالتفرّع"},{"id":"c","text":"كلاهما بالتسلسل"},{"id":"d","text":"كلاهما بالتفرّع"}]'::jsonb, 'b', 'الترابط في المصير (نزع مصباح يطفئ الآخر) والإضاءة الأضعف علامتا التسلسل، فتركيب 1 بالتسلسل؛ واستقلال الفروع (بقاء الآخر مضيئًا بكامل شدّته) علامة التفرّع، فتركيب 2 بالتفرّع.', 2, 'mcq', NULL, NULL)
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
  ('e5f3078b-ed63-55e8-9ee9-1a6cf389f9e0', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'في تركيب بالتفرّع بثلاثة مصابيح على ثلاثة فروع، وُضع قاطع على نقطة التفرّع الرئيسية قبل انقسام الفروع (على الجذع المشترك). ماذا يحدث عند فتح هذا القاطع؟', '[{"id":"a","text":"ينطفئ مصباح واحد فقط ويبقى اثنان مضيئَين"},{"id":"b","text":"تنطفئ المصابيح الثلاثة معًا، لأنّ القاطع على الجذع المشترك يقطع التيّار قبل وصوله إلى كلّ الفروع"},{"id":"c","text":"تبقى المصابيح الثلاثة مضيئة لأنّ التفرّع لا يتأثّر بأيّ قاطع"},{"id":"d","text":"يزداد إضاءة المصابيح الثلاثة"}]'::jsonb, 'b', 'القاطع على الجذع المشترك (قبل نقطة التفرّع) يتحكّم في التيّار الداخل إلى كلّ الفروع؛ فتحه يقطع التغذية عن الجميع فتنطفئ الثلاثة معًا. أمّا قاطع موضوع على فرع واحد فيطفئ مصباح ذلك الفرع وحده.', 3, 'mcq', NULL, NULL)
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
  ('002a64bc-7c4f-5fa4-bdb2-3dc63c168176', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'زعم تلميذ: «التركيب بالتفرّع أفضل دائمًا لأنّ استقلال الفروع يعني أنّ عطب أيّ عنصر لا يؤثّر أبدًا في بقية الدارة، حتّى لو كان العطب في المولّد». أين الخطأ في تعميمه؟', '[{"id":"a","text":"لا خطأ، فالتفرّع فعلًا يحمي من كلّ الأعطاب مهما كان موضعها"},{"id":"b","text":"الخطأ أنّ التفرّع لا يعمل إلّا بمصباح واحد"},{"id":"c","text":"الخطأ أنّ التفرّع يطفئ الجميع عند عطب أيّ فرع"},{"id":"d","text":"الخطأ أنّ استقلال الفروع يقتصر على عطب داخل فرع؛ أمّا عطب المولّد أو الجذع المشترك فيوقف كلّ الفروع لأنّها تتغذّى منه جميعًا"}]'::jsonb, 'd', 'استقلال الفروع في التفرّع يحمي من عطب داخل فرع معيّن فقط؛ لكنّ كلّ الفروع تتغذّى من المولّد عبر الجذع المشترك، فعطب المولّد نفسه أو انقطاع الجذع يوقف التيّار عن الفروع جميعًا. التعميم على «كلّ عطب» خاطئ.', 4, 'mcq', NULL, NULL)
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
  ('92a509e3-d02f-57ad-897c-9a16e44189a3', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'أيّ العبارات الأربع التالية هي **الصحيحة الوحيدة** بخصوص التركيبَين؟', '[{"id":"a","text":"في التسلسل يبقى المصباح السليم مضيئًا عند احتراق مصباح آخر في الحلقة نفسها"},{"id":"b","text":"في التفرّع تضيء المصابيح أضعف من مصباح وحيد مماثل بالمولّد نفسه"},{"id":"c","text":"زيادة عدد المصابيح المتسلسلة تُضعف إضاءة كلّ واحد منها، بينما في التفرّع يعمل كلّ فرع باستقلال بكامل شدّته"},{"id":"d","text":"قاطع واحد على فرع في التفرّع يطفئ كلّ مصابيح الدارة"}]'::jsonb, 'c', 'الصحيحة الوحيدة هي (ج). العبارات الأخرى خاطئة: في التسلسل ينطفئ الجميع بعطب واحد لا يبقى السليم مضيئًا؛ وفي التفرّع تضيء المصابيح بكامل شدّتها (أقوى لا أضعف)؛ وقاطع فرع واحد يطفئ مصباح فرعه وحده لا الكلّ.', 5, 'mcq', NULL, NULL)
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
  ('f6694c76-3b63-5897-91e1-955238e323a2', '3aa750a3-e085-512c-af1e-00573ae9b8f2', 'أراد كهربائي تركيب مصباحَي طوارئ في ممرّ بحيث يبقى الممرّ مضيئًا إذا احترق أحد المصباحَين، مع إمكانية إطفاء كلّ مصباح على حدة. أيّ تصميم يحقّق الهدفَين معًا؟', '[{"id":"a","text":"تركيب المصباحَين بالتسلسل في حلقة واحدة مع قاطع واحد مشترك"},{"id":"b","text":"تركيب المصباحَين بالتسلسل دون أيّ قاطع"},{"id":"c","text":"توصيل قطبَي المولّد مباشرة بسلك واحد دون مصابيح"},{"id":"d","text":"تركيب المصباحَين بالتفرّع، لكلّ مصباح فرعه وقاطعه الخاصّ"}]'::jsonb, 'd', 'التفرّع بفرع وقاطع لكلّ مصباح يحقّق الهدفَين: احتراق أحد المصباحَين يفتح فرعه وحده فيبقى الآخر مضيئًا (استمرار الإنارة)، وكلّ قاطع فرع يتيح إطفاء مصباحه على حدة. التسلسل يطفئ الجميع بعطب واحد وبقاطع واحد مشترك، والتوصيل المباشر دون مستقبل دارة قصيرة خطيرة.', 6, 'mcq', NULL, NULL)
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
  ('70946f62-dfe4-50c4-bc18-420950be7f1a', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '⚔️ زعيم التدريب ⭐⭐⭐: قراءة الدارات وتصنيف الموادّ', 3, 120, 30, 'boss', 'admin', 5)
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
  ('a48e74cc-d57a-5e1e-8730-6668d8baf236', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'رسم تلميذ دارة: مولّد، ثمّ سلك يصل إلى دائرة بداخلها الحرف M، ثمّ عودة إلى المولّد. ما المستقبل المستعمل في هذه الدارة؟', '[{"id":"a","text":"محرّك"},{"id":"b","text":"مصباح"},{"id":"c","text":"قاطع"},{"id":"d","text":"مولّد ثانٍ"}]'::jsonb, 'a', 'الدائرة بداخلها الحرف M رمز المحرّك؛ أمّا رمز المصباح فدائرة بداخلها علامة تقاطع (×). كلاهما مستقبل لكن المحرّك يحوّل الطاقة إلى حركة.', 1, 'mcq', NULL, NULL)
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
  ('781ba196-7c93-52e4-a207-f479e8cf1c53', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'أراد مروان اختبار ما إذا كان مفتاح معدني (من الحديد) ناقلًا، فوضعه بدل القاطع في دارة بها مصباح. أضاء المصباح. ما الاستنتاج الصحيح؟', '[{"id":"a","text":"المفتاح المعدني حوّل الدارة إلى دارة مفتوحة"},{"id":"b","text":"الحديد مادّة عازلة، والمصباح أضاء رغم ذلك"},{"id":"c","text":"المصباح يضيء بلا حاجة إلى إكمال الدارة"},{"id":"d","text":"الحديد مادّة ناقلة، فقد سمح بمرور التيّار وأكمل الدارة"}]'::jsonb, 'd', 'إضاءة المصباح تدلّ على أنّ التيّار مرّ عبر المفتاح الحديدي فأكمل الدارة المغلقة؛ إذن الحديد معدن ناقل. لو كان عازلًا لبقيت الدارة مفتوحة ولم يضئ المصباح.', 2, 'mcq', NULL, NULL)
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
  ('00b18781-2f37-553d-b07c-b0270412011e', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'في تركيب بالتسلسل بمصباحَين يضيئان، قصّر التلميذ أحد المصباحَين بسلك نحاسي يصل طرفَيه مباشرة (تجاوزه بسلك). ماذا يُتوقَّع لإضاءة المصباح الثاني؟', '[{"id":"a","text":"ينطفئ لأنّ تجاوز مصباح يفتح الدارة"},{"id":"b","text":"يضيء أقوى من قبل، لأنّه أصبح كأنّه وحده في الحلقة"},{"id":"c","text":"لا يتغيّر إطلاقًا"},{"id":"d","text":"يتحوّل إلى محرّك"}]'::jsonb, 'b', 'تجاوز المصباح الأوّل بسلك ناقل يبقي الحلقة مغلقة لكن بمصباح واحد فعّال بدل اثنَين؛ فيتوقّف تقاسم الطاقة ويضيء المصباح الثاني أقوى، كأنّه وحده في الدارة. (الحلقة تبقى مغلقة فلا ينطفئ.)', 3, 'mcq', NULL, NULL)
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
  ('7a87cda9-e3b8-57d9-9b3c-4cf477794e51', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'دارتان بالمولّد نفسه: الأولى مصباحان بالتسلسل، والثانية مصباحان بالتفرّع. أيّ مقارنة لإضاءة كلّ مصباح صحيحة؟', '[{"id":"a","text":"مصابيح التسلسل تضيء أقوى من مصابيح التفرّع"},{"id":"b","text":"مصابيح التفرّع تضيء أقوى، لأنّ كلّ مصباح يعمل على فرعه المستقلّ بكامل شدّته"},{"id":"c","text":"الإضاءة متساوية تمامًا في التركيبَين"},{"id":"d","text":"لا تضيء أيّ مصابيح في التركيبَين"}]'::jsonb, 'b', 'في التفرّع يعمل كلّ مصباح بكامل شدّته على فرعه المستقلّ، بينما في التسلسل يتقاسم المصباحان الطاقة نفسها فيضيء كلّ منهما أضعف؛ لذلك مصابيح التفرّع أقوى إضاءة.', 4, 'mcq', NULL, NULL)
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
  ('a6836676-f716-540b-880e-4fec2a8a4aae', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'لاحظ تلميذ أنّ مصباحًا في تركيب بالتفرّع بقي مضيئًا حتّى بعد نزع كلّ المصابيح الأخرى من فروعها. ماذا يستنتج عن فرع هذا المصباح؟', '[{"id":"a","text":"أنّ التركيب تحوّل إلى تسلسل"},{"id":"b","text":"أنّ الدارة كلّها أصبحت مفتوحة"},{"id":"c","text":"أنّ المولّد توقّف عن العمل"},{"id":"d","text":"أنّ فرعه بقي دارة مغلقة مستقلّة يمرّ فيها التيّار وحده"}]'::jsonb, 'd', 'استقلال الفروع في التفرّع يعني أنّ فرع المصباح المضيء بقي دارة مغلقة يتغذّى من المولّد وحده، فظلّ مضيئًا رغم نزع بقية المصابيح من فروعها. هذا جوهر التركيب بالتفرّع.', 5, 'mcq', NULL, NULL)
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
  ('c8be1a71-1acc-5897-bfc2-545904cd8615', '70946f62-dfe4-50c4-bc18-420950be7f1a', 'أيّ العبارات التالية عن الرموز والتراكيب **صحيحة**؟', '[{"id":"a","text":"الخطّان المتوازيان المختلفا الطول يرمزان إلى القاطع المفتوح"},{"id":"b","text":"التركيب بالتسلسل يوفّر مسارًا مستقلًّا لكلّ مصباح"},{"id":"c","text":"في التركيب بالتسلسل يمرّ التيّار في مسار وحيد يعبر كلّ المصابيح بالترتيب"},{"id":"d","text":"الماء الذي يحوي أملاحًا مذابة مادّة عازلة تمامًا"}]'::jsonb, 'c', 'الصحيحة هي (ج): التسلسل مسار وحيد يعبر كلّ المصابيح. الباقي خاطئ: الخطّان المتفاوتا الطول رمز المولّد لا القاطع؛ والمسار المستقلّ لكلّ مصباح خاصّية التفرّع لا التسلسل؛ والماء المالح ناقل لا عازل.', 6, 'mcq', NULL, NULL)
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
  ('629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'c2d191a9-8c75-5a10-9492-a31a97c8bdc6', 'sciences-physiques-8eme', '👑 قمّة التحدّي ⭐⭐⭐⭐: خبير الدارات المركّبة', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('f12c62f6-4e21-5699-aed6-c734c7aa357d', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'في دارة إنارة منزلية (تركيب بالتفرّع)، أضاف تلميذ سلكًا نحاسيًّا عاريًا يصل قطبَي المولّد مباشرة دون أن يمرّ عبر أيّ مصباح، إلى جانب فروع المصابيح. ما الحالة الخطيرة التي نشأت على هذا الفرع المباشر؟', '[{"id":"a","text":"دارة مفتوحة عادية لا خطر فيها"},{"id":"b","text":"دارة قصيرة، لأنّ السلك يصل القطبَين مباشرة دون مستقبل فيندفع تيّار قويّ خطير"},{"id":"c","text":"عزل كهربائي ممتاز"},{"id":"d","text":"تحوّل التركيب إلى تسلسل آمن"}]'::jsonb, 'b', 'سلك ناقل يصل قطبَي المولّد مباشرة دون المرور عبر أيّ مستقبل هو تعريف الدارة القصيرة؛ يندفع فيه تيّار قويّ فجائي قد يسخّن السلك ويسبّب حريقًا أو يتلف المولّد، حتّى لو كانت بقية الفروع سليمة.', 1, 'mcq', NULL, NULL)
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
  ('646ef569-e6d1-5168-b9c7-ea34b045aa6a', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'دارة مركّبة: مصباح L1 موصول بالتسلسل على الجذع المشترك، يليه تفرّع إلى مصباحَين L2 وL3 على فرعَين. احترق المصباح L1 وحده. ماذا يحدث لبقية المصابيح؟', '[{"id":"a","text":"يبقى L2 وL3 مضيئَين لأنّهما على فرعَين مستقلّين"},{"id":"b","text":"يضيء L2 وL3 أقوى من قبل"},{"id":"c","text":"ينطفئ L2 فقط ويبقى L3 مضيئًا"},{"id":"d","text":"ينطفئ L2 وL3 معًا، لأنّ L1 على الجذع المشترك واحتراقه يقطع التيّار قبل وصوله إلى التفرّع"}]'::jsonb, 'd', 'المصباح L1 على الجذع المشترك (بالتسلسل قبل التفرّع)؛ احتراقه يفتح المسار الوحيد الذي يغذّي نقطة التفرّع، فلا يصل التيّار إلى L2 وL3 وينطفئان معًا. لو كان L1 على فرع خاصّ لانطفأ وحده.', 2, 'mcq', NULL, NULL)
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
  ('2781e798-8fdb-5224-98df-7b581fb86c58', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'أراد فنّي التحقّق من أنّ تركيبًا بالتفرّع سليم، فنزع مصباحًا واحدًا من فرعه فانطفأت كلّ المصابيح دفعةً واحدة. ما الاستنتاج الأصحّ؟', '[{"id":"a","text":"هذا سلوك طبيعي للتفرّع تمامًا"},{"id":"b","text":"التركيب ليس تفرّعًا حقيقيًّا؛ فانطفاء الجميع بنزع مصباح واحد سلوك التسلسل، أي أنّ المصابيح موصولة فعليًّا على حلقة واحدة"},{"id":"c","text":"المولّد أقوى من اللازم"},{"id":"d","text":"المصابيح كلّها احترقت لحظة النزع"}]'::jsonb, 'b', 'في التفرّع الحقيقي نزع مصباح فرع لا يطفئ البقية؛ انطفاء الجميع بنزع مصباح واحد هو بالضبط سلوك التسلسل، فيدلّ على أنّ المصابيح موصولة في حلقة واحدة (تسلسل) لا على فروع مستقلّة كما ظُنّ.', 3, 'mcq', NULL, NULL)
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
  ('6da31707-ed07-5129-b890-cf159165f4c7', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'قارن باحث أربع دارات بالمولّد نفسه: (1) مصباح وحيد؛ (2) مصباحان بالتفرّع؛ (3) مصباحان بالتسلسل؛ (4) ثلاثة مصابيح بالتسلسل. رتّب إضاءة المصباح الواحد من الأقوى إلى الأضعف.', '[{"id":"a","text":"الدارة 3 ثمّ 4 ثمّ 1 ثمّ 2"},{"id":"b","text":"الإضاءة متساوية في الدارات الأربع"},{"id":"c","text":"الدارة 4 هي الأقوى لأنّها تحوي أكثر مصابيح"},{"id":"d","text":"المصباح في (1) و(2) بكامل الشدّة، ثمّ أضعف في (3)، ثمّ الأضعف في (4)"}]'::jsonb, 'd', 'المصباح الوحيد (1) ومصابيح التفرّع (2) تعمل كلّها بكامل الشدّة (كلّ فرع مستقلّ كأنّه وحده)؛ أمّا في التسلسل فتتقاسم المصابيح الطاقة فتضعف الإضاءة، وتزداد ضعفًا كلّما زاد العدد: فمصباحان بالتسلسل (3) أضعف من الوحيد، وثلاثة بالتسلسل (4) الأضعف.', 4, 'mcq', NULL, NULL)
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
  ('8ec10b45-5e16-5f52-a45d-74b2afdba4ab', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'أيّ العبارات الأربع التالية هي **الوحيدة الصحيحة**؟', '[{"id":"a","text":"وضع مصباح على الجذع المشترك لتركيب بالتفرّع يجعل احتراقه يطفئ كلّ الفروع التي بعده"},{"id":"b","text":"الدارة القصيرة أكثر أمانًا من مرور التيّار عبر مستقبل"},{"id":"c","text":"في التسلسل يعمل كلّ مصباح باستقلال تامّ عن الآخرين"},{"id":"d","text":"الزجاج والخشب الجافّ ناقلان جيّدان في الدارات المتفرّعة فقط"}]'::jsonb, 'a', 'الصحيحة الوحيدة (أ): مصباح على الجذع المشترك يغذّي كلّ الفروع، فاحتراقه يقطع التيّار عنها جميعًا. الباقي خاطئ: الدارة القصيرة خطيرة لا آمنة؛ والاستقلال خاصّية التفرّع لا التسلسل؛ والزجاج والخشب الجافّ عازلان في كلّ الدارات.', 5, 'mcq', NULL, NULL)
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
  ('943d7d36-dbfa-5efd-9274-afd555c5baf8', '629df4c5-0d0d-5356-9fbf-5f379bcf3809', 'طُلب من كهربائي تصميم لوحة عرض بثلاثة مصابيح بحيث: تبقى المصابيح السليمة مضيئة إذا احترق أحدها، ويضيء كلّ مصباح بكامل شدّته، ويمكن إطفاء كلّ مصباح على حدة دون خطر دارة قصيرة. أيّ تصميم يحقّق كلّ الشروط؟', '[{"id":"a","text":"المصابيح الثلاثة بالتسلسل في حلقة واحدة بقاطع مشترك"},{"id":"b","text":"توصيل قطبَي المولّد بسلك مباشر ثمّ تعليق المصابيح عليه"},{"id":"c","text":"المصابيح الثلاثة بالتفرّع، لكلّ مصباح فرعه وقاطعه الخاصّ، ويمرّ التيّار دائمًا عبر مصباح لا عبر سلك مباشر"},{"id":"d","text":"المصابيح الثلاثة بالتسلسل دون أيّ قاطع"}]'::jsonb, 'c', 'التفرّع بفرع وقاطع لكلّ مصباح يحقّق كلّ الشروط: استقلال الفروع يبقي السليمة مضيئة عند احتراق أحدها، وكلّ مصباح يضيء بكامل شدّته، وقاطع كلّ فرع يتيح إطفاءه على حدة؛ ومرور التيّار عبر المصابيح لا عبر سلك مباشر يمنع الدارة القصيرة. التسلسل يطفئ الجميع بعطب واحد، والسلك المباشر دارة قصيرة خطيرة.', 6, 'mcq', NULL, NULL)
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
  ('36fbb474-ce93-59fc-8dc8-45a2d73439cd', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('981fc3ce-7139-57a2-b646-4c21c827b2a3', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', 'ما المنحى الاصطلاحي للتيّار الكهربائي خارج المولّد؟', '[{"id":"a","text":"من القطب الموجب (+) إلى القطب السالب (−)"},{"id":"b","text":"من القطب السالب (−) إلى القطب الموجب (+)"},{"id":"c","text":"لا منحى له، يجري في كلّ الاتّجاهات معًا"},{"id":"d","text":"من المصباح إلى القاطع فقط"}]'::jsonb, 'a', 'المنحى الاصطلاحي للتيّار خارج المولّد هو من القطب الموجب (+) إلى القطب السالب (−) عبر أسلاك التوصيل والمستقبلات، وهو منحى واحد ثابت في كلّ الحلقة.', 1, 'mcq', NULL, NULL)
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
  ('11d3a0ba-175f-544c-b2f1-3c2c69cace19', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', 'ما اسم الجهاز الذي نقيس به شدّة التيّار الكهربائي، وما وحدة قيسها؟', '[{"id":"a","text":"الفولتمتر، ووحدتها الفولط (V)"},{"id":"b","text":"الأمبيرمتر، ووحدتها الأمبير (A)"},{"id":"c","text":"الميزان، ووحدتها الغرام (g)"},{"id":"d","text":"الأمبيرمتر، ووحدتها الفولط (V)"}]'::jsonb, 'b', 'نقيس شدّة التيّار بالأمبيرمتر، ووحدة قيسها هي الأمبير ورمزه A. الفولتمتر والفولط (V) يخصّان التوتّر لا الشدّة.', 2, 'mcq', NULL, NULL)
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
  ('231ac4f6-d58f-55fc-b2ed-28654b25a452', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', 'كيف يُركّب الأمبيرمتر في الدارة لقيس شدّة التيّار المارّ في مصباح؟', '[{"id":"a","text":"خارج الدارة تمامًا دون أيّ ربط"},{"id":"b","text":"بالتفرّع (على التوازي) مع المصباح"},{"id":"c","text":"بالتسلسل مع المصباح"},{"id":"d","text":"مكان المولّد بعد نزعه"}]'::jsonb, 'c', 'يُركّب الأمبيرمتر دائمًا بالتسلسل مع العنصر المراد قيس شدّة التيّار المارّ فيه، ليمرّ التيّار من خلاله. تركيبه بالتفرّع خطأ قد يتلفه.', 3, 'mcq', NULL, NULL)
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
  ('a69bea1b-6e9b-557f-9380-07194fa14b03', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', 'في دارة بالتسلسل، قرأ أمبيرمتر مركّب قبل المصباح الشدّة 0.4 A. ماذا يقرأ أمبيرمتر آخر مركّب بعد المصباح مباشرة؟', '[{"id":"a","text":"ضعف 0.4 A، أي 0.8 A"},{"id":"b","text":"أقلّ من 0.4 A، لأنّ المصباح يستهلك جزءًا من التيّار"},{"id":"c","text":"0 A، لأنّ التيّار يتوقّف بعد المصباح"},{"id":"d","text":"0.4 A، لأنّ الشدّة نفسها في كلّ نقاط التسلسل"}]'::jsonb, 'd', 'في دارة بالتسلسل، شدّة التيّار هي نفسها في كلّ النقاط: فالأمبيرمتر بعد المصباح يقرأ 0.4 A أيضًا. التيّار لا يُستهلَك ولا يَنقُص وهو يمرّ عبر المصباح.', 4, 'mcq', NULL, NULL)
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
  ('28486cbc-7317-505d-9110-2c54ce7b95da', '36fbb474-ce93-59fc-8dc8-45a2d73439cd', 'في دارة متفرّعة، بلغت شدّة التيّار في الفرع الأوّل I1 = 0.3 A وفي الفرع الثاني I2 = 0.5 A. ما شدّة التيّار الرئيسي I؟', '[{"id":"a","text":"0.8 A"},{"id":"b","text":"0.2 A"},{"id":"c","text":"0.5 A"},{"id":"d","text":"0.15 A"}]'::jsonb, 'a', 'وفق قانون العقد، التيّار الرئيسي يساوي مجموع تيّارات الفروع: I = I1 + I2 = 0.3 + 0.5 = 0.8 A. القيمة 0.2 A ناتجة عن الطرح الخاطئ، والتيّار الرئيسي دائمًا أكبر من كلّ فرع.', 5, 'mcq', NULL, NULL)
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
  ('16442953-9c4b-5c71-b160-33c82e680c6a', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '⭐ تمرين: أساسيات شدّة التيار وقيسها', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9e8def54-2d94-537d-ba9c-9e174c3148ca', '16442953-9c4b-5c71-b160-33c82e680c6a', 'بأيّ حرف نرمز إلى شدّة التيّار الكهربائي؟', '[{"id":"a","text":"V"},{"id":"b","text":"I"},{"id":"c","text":"m"},{"id":"d","text":"T"}]'::jsonb, 'b', 'نرمز إلى شدّة التيّار الكهربائي بالحرف I. الحرف V يخصّ التوتّر، و m يخصّ الكتلة.', 1, 'mcq', NULL, NULL)
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
  ('f0c4a753-1567-5ade-847d-8331025a2a0e', '16442953-9c4b-5c71-b160-33c82e680c6a', 'ما وحدة قيس شدّة التيّار الكهربائي؟', '[{"id":"a","text":"الغرام (g)"},{"id":"b","text":"الفولط (V)"},{"id":"c","text":"الأمبير (A)"},{"id":"d","text":"المتر (m)"}]'::jsonb, 'c', 'وحدة قيس شدّة التيّار هي الأمبير ورمزها A. الفولط (V) وحدة التوتّر، والغرام (g) وحدة الكتلة، والمتر (m) وحدة الطول.', 2, 'mcq', NULL, NULL)
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
  ('401b0318-9356-5252-a4ad-093fc54e9f4b', '16442953-9c4b-5c71-b160-33c82e680c6a', 'ما اسم الجهاز الذي نقيس به شدّة التيّار الكهربائي؟', '[{"id":"a","text":"الميزان"},{"id":"b","text":"الفولتمتر"},{"id":"c","text":"الترمومتر"},{"id":"d","text":"الأمبيرمتر"}]'::jsonb, 'd', 'نقيس شدّة التيّار بالأمبيرمتر (رمزه دائرة بداخلها الحرف A). الفولتمتر يقيس التوتّر، والترمومتر يقيس الحرارة.', 3, 'mcq', NULL, NULL)
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
  ('dd294748-e29f-5453-8649-c6d586e6127d', '16442953-9c4b-5c71-b160-33c82e680c6a', 'كم يساوي 1 A بالمليأمبير؟', '[{"id":"a","text":"1000 mA"},{"id":"b","text":"100 mA"},{"id":"c","text":"10 mA"},{"id":"d","text":"1 mA"}]'::jsonb, 'a', 'المليأمبير مضاعِف جزئي للأمبير: 1 A = 1000 mA. للتحويل من A إلى mA نضرب في 1000.', 4, 'mcq', NULL, NULL)
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
  ('67a24a8b-f305-57f8-a3ee-ad188f275cd1', '16442953-9c4b-5c71-b160-33c82e680c6a', 'كيف يُركّب الأمبيرمتر مع العنصر الذي نريد قيس شدّة التيّار المارّ فيه؟', '[{"id":"a","text":"بالتفرّع"},{"id":"b","text":"بالتسلسل"},{"id":"c","text":"دون توصيل بأيّ سلك"},{"id":"d","text":"مكان المولّد"}]'::jsonb, 'b', 'يُركّب الأمبيرمتر بالتسلسل مع العنصر المراد قيسه، ليمرّ التيّار من خلاله. تركيبه بالتفرّع خطأ.', 5, 'mcq', NULL, NULL)
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
  ('b4393e85-f78a-5de0-814d-ea47ac08f07c', '16442953-9c4b-5c71-b160-33c82e680c6a', 'في دارة بالتسلسل، قرأ أمبيرمتر الشدّة 0.5 A عند نقطة معيّنة. ماذا نتوقّع أن يقرأ أمبيرمتر آخر عند نقطة أخرى من نفس الحلقة؟', '[{"id":"a","text":"أكبر من 0.5 A"},{"id":"b","text":"أقلّ من 0.5 A"},{"id":"c","text":"0.5 A، لأنّ الشدّة نفسها في كلّ نقاط التسلسل"},{"id":"d","text":"0 A"}]'::jsonb, 'c', 'في دارة بالتسلسل شدّة التيّار هي نفسها في كلّ النقاط، فالأمبيرمتر الثاني يقرأ 0.5 A أيضًا.', 6, 'mcq', NULL, NULL)
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
  ('80eb7153-04ea-50ca-9e89-7fd6343a4048', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: شدّة التيار وتوزيعها', 3, 120, 30, 'boss', 'admin', 2)
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
  ('21626603-3fa2-5c97-bc2b-0519be4d35f1', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'أراد تلميذ قيس شدّة التيّار المارّ في محرّك دارته. ما التركيب الصحيح للأمبيرمتر؟', '[{"id":"a","text":"بالتفرّع على المولّد مباشرة"},{"id":"b","text":"بالتفرّع على المحرّك، مع احترام قطبَيه"},{"id":"c","text":"بالتسلسل مع المحرّك، مع احترام قطبَيه"},{"id":"d","text":"مكان المحرّك بعد نزعه من الدارة"}]'::jsonb, 'c', 'يُركّب الأمبيرمتر بالتسلسل مع العنصر المراد قيسه (المحرّك) ليمرّ التيّار من خلاله، مع احترام قطبَيه. التركيب بالتفرّع خطأ، ووضعه مكان المحرّك يغيّر الدارة.', 1, 'mcq', NULL, NULL)
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
  ('e47f397b-b58d-52e5-935d-f9315dbf2c70', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'في دارة بالتسلسل، قرأ أمبيرمتر بين المولّد والمصباح الأوّل الشدّة 0.18 A. ماذا يقرأ أمبيرمتر مركّب بين المصباح الأوّل والمصباح الثاني؟', '[{"id":"a","text":"0 A، لأنّ التيّار توقّف عند المصباح الأوّل"},{"id":"b","text":"0.09 A، لأنّ المصباح الأوّل استهلك نصف التيّار"},{"id":"c","text":"0.36 A، لأنّ التيّار يتضاعف بعد كلّ مصباح"},{"id":"d","text":"0.18 A، لأنّ الشدّة نفسها في كلّ نقاط التسلسل"}]'::jsonb, 'd', 'في التسلسل شدّة التيّار واحدة في كلّ النقاط، فالأمبيرمتر الثاني يقرأ 0.18 A أيضًا. المصباح لا يستهلك جزءًا من الشدّة ولا يضاعفها.', 2, 'mcq', NULL, NULL)
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
  ('51ae34f7-f5e3-54b9-88f8-0f5f4dcbd400', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'دارة متفرّعة إلى ثلاثة فروع، شدّاتها: I1 = 0.15 A ; I2 = 0.2 A ; I3 = 0.1 A. ما شدّة التيّار الرئيسي I؟', '[{"id":"a","text":"0.45 A"},{"id":"b","text":"0.2 A"},{"id":"c","text":"0.05 A"},{"id":"d","text":"0.15 A"}]'::jsonb, 'a', 'قانون العقد يُعمَّم على أيّ عدد من الفروع: I = I1 + I2 + I3 = 0.15 + 0.2 + 0.1 = 0.45 A. التيّار الرئيسي مجموع الفروع، فهو أكبر منها جميعًا.', 3, 'mcq', NULL, NULL)
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
  ('e37d8068-2243-5989-a73e-e1be4f55c9a0', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'دارة متفرّعة إلى فرعين. قال تلميذ: «التيّار الرئيسي I يساوي فرق الفرعين، أي I = I1 − I2.» أين الخطأ في قوله؟', '[{"id":"a","text":"لا خطأ، فالقانون فعلًا طرح"},{"id":"b","text":"الخطأ أنّ قانون العقد جمع لا طرح: I = I1 + I2، فالرئيسي أكبر من كلّ فرع"},{"id":"c","text":"الخطأ أنّ التيّار الرئيسي يساوي جذاء الفرعين I = I1 × I2"},{"id":"d","text":"الخطأ أنّ الفروع لا علاقة لها بالتيّار الرئيسي إطلاقًا"}]'::jsonb, 'b', 'قانون العقد جمع: I = I1 + I2. الطرح خاطئ لأنّ ما يدخل العقدة يساوي ما يخرج منها، فالتيّار الرئيسي مجموع الفروع وهو أكبر من كلّ واحد منها. الطرح يُستعمل فقط لإيجاد فرع مجهول: I2 = I − I1.', 4, 'mcq', NULL, NULL)
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
  ('ff9e8f56-a310-5879-bed2-c0bbbb069b81', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'في دارة متفرّعة إلى فرعين متطابقَين تمامًا (مصباحان متماثلان)، قيست شدّة التيّار الرئيسي فوُجدت 0.8 A. ما شدّة التيّار في كلّ فرع؟', '[{"id":"a","text":"1.6 A في كلّ فرع"},{"id":"b","text":"0.8 A في كلّ فرع"},{"id":"c","text":"0.4 A في كلّ فرع"},{"id":"d","text":"0.2 A في كلّ فرع"}]'::jsonb, 'c', 'الفرعان متطابقان فينقسم التيّار الرئيسي بينهما بالتساوي: كلّ فرع يحمل نصف الشدّة الرئيسية = 0.8 ÷ 2 = 0.4 A. ونتحقّق: 0.4 + 0.4 = 0.8 A ✓.', 5, 'mcq', NULL, NULL)
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
  ('dc306be7-0210-5a46-90a0-f32c11c2a22c', '80eb7153-04ea-50ca-9e89-7fd6343a4048', 'أراد تلميذ قيس شدّة تيّار ضعيف جدًّا يقدَّر بنحو 45 mA. أيّ وحدة قراءة هي الأنسب، وكم تساوي هذه الشدّة بالأمبير؟', '[{"id":"a","text":"الأنسب القراءة بالأمبير، وتساوي 450 A"},{"id":"b","text":"الأنسب القراءة بالأمبير، وتساوي 45 A"},{"id":"c","text":"الأنسب القراءة بالمليأمبير، وتساوي 4.5 A"},{"id":"d","text":"الأنسب القراءة بالمليأمبير (mA)، وتساوي 0.045 A"}]'::jsonb, 'd', 'للتيّارات الضعيفة نقرأ بالمليأمبير (mA). للتحويل إلى الأمبير نقسم على 1000: 45 ÷ 1000 = 0.045 A. القيم بالأمبير الكبيرة (45 A ; 450 A) غير معقولة لتيّار ضعيف.', 6, 'mcq', NULL, NULL)
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
  ('714ec5f5-442b-59dd-8551-87f902aca9c3', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التيار وقيسه وتوزيعه', 2, 70, 15, 'practice', 'admin', 3)
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
  ('83544320-e797-5ded-8991-6862e088ac2c', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'حوّل الشدّة 0.25 A إلى المليأمبير.', '[{"id":"a","text":"0.00025 mA"},{"id":"b","text":"25 mA"},{"id":"c","text":"2500 mA"},{"id":"d","text":"250 mA"}]'::jsonb, 'd', 'للتحويل من A إلى mA نضرب في 1000: 0.25 × 1000 = 250 mA. القيمة 25 mA ناتجة عن الضرب في 100، و 2500 mA عن الضرب في 10000.', 1, 'mcq', NULL, NULL)
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
  ('67706db9-c346-5641-b87c-b9ff1d33a68c', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'حوّل الشدّة 120 mA إلى الأمبير.', '[{"id":"a","text":"0.12 A"},{"id":"b","text":"1.2 A"},{"id":"c","text":"12 A"},{"id":"d","text":"120000 A"}]'::jsonb, 'a', 'للتحويل من mA إلى A نقسم على 1000: 120 ÷ 1000 = 0.12 A. القيمة 1.2 A ناتجة عن القسمة على 100 بالخطأ.', 2, 'mcq', NULL, NULL)
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
  ('6a7962eb-b1c0-5c1c-b8b0-f02a45b5a5eb', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'ركّب تلميذ أمبيرمترًا بالتفرّع (على التوازي) مباشرة على مصباح بدل تركيبه بالتسلسل. لماذا يُعدّ هذا خطأً؟', '[{"id":"a","text":"لأنّ الأمبيرمتر لا يعمل إلّا في الظلام"},{"id":"b","text":"لأنّ مقاومة الأمبيرمتر ضعيفة جدًّا، فتركيبه بالتفرّع يشبه دارة قصيرة قد تتلفه"},{"id":"c","text":"لأنّ الأمبيرمتر يجب أن يوضع دائمًا مكان المولّد"},{"id":"d","text":"لا يوجد أيّ خطأ، فالتفرّع هو الطريقة الصحيحة"}]'::jsonb, 'b', 'الأمبيرمتر يُركّب بالتسلسل دائمًا. مقاومته ضعيفة جدًّا، فتركيبه بالتفرّع على مصباح يفتح مسارًا شبيهًا بدارة قصيرة يمرّ فيه تيّار قويّ قد يتلف الجهاز.', 3, 'mcq', NULL, NULL)
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
  ('380a3f96-aac2-584c-9c0b-a623b523ed60', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'في دارة متفرّعة، التيّار الرئيسي I = 0.6 A، والفرع الأوّل I1 = 0.25 A. ما شدّة التيّار في الفرع الثاني I2؟', '[{"id":"a","text":"0.6 A"},{"id":"b","text":"0.85 A"},{"id":"c","text":"0.35 A"},{"id":"d","text":"0.25 A"}]'::jsonb, 'c', 'من قانون العقد I = I1 + I2، نستخرج I2 = I − I1 = 0.6 − 0.25 = 0.35 A. القيمة 0.85 A ناتجة عن جمع خاطئ بدل الطرح.', 4, 'mcq', NULL, NULL)
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
  ('2335cada-9e64-53d5-9d06-cbff2051e9c2', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'ركّب تلميذ الأمبيرمتر الرقمي في دارته بالتسلسل، فظهرت على شاشته القراءة −0.3 A بإشارة سالبة. ما التفسير؟', '[{"id":"a","text":"الدارة مفتوحة ولا يجري فيها أيّ تيّار"},{"id":"b","text":"شدّة التيّار سالبة حقيقةً وتساوي −0.3 A"},{"id":"c","text":"الأمبيرمتر تالف ولا يمكن استعماله أبدًا"},{"id":"d","text":"عكَس ربط مربطَي الأمبيرمتر (القطبين)، وشدّة التيّار فعليًّا 0.3 A"}]'::jsonb, 'd', 'ظهور إشارة سالبة على الأمبيرمتر الرقمي يعني أنّ قطبَيه مركّبان بالمقلوب بالنسبة لمنحى التيّار. القيمة المطلقة صحيحة: شدّة التيّار 0.3 A. يكفي عكس الربط لتصير موجبة.', 5, 'mcq', NULL, NULL)
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
  ('e344fa6d-31a1-5e3c-b0f0-a9c72751fc9a', '714ec5f5-442b-59dd-8551-87f902aca9c3', 'دارة بالتسلسل تحتوي على مولّد ومصباحين متطابقين. أضفنا مصباحًا ثالثًا مطابقًا بالتسلسل أيضًا. ماذا يحدث لشدّة التيّار في الدارة؟', '[{"id":"a","text":"تنقص شدّة التيّار في كامل الدارة، وتبقى مع ذلك متساوية في كلّ نقاطها"},{"id":"b","text":"تزداد شدّة التيّار في كامل الدارة"},{"id":"c","text":"تصبح الشدّة أكبر قبل المصابيح وأصغر بعدها"},{"id":"d","text":"لا يتغيّر شيء إطلاقًا"}]'::jsonb, 'a', 'إضافة مصباح بالتسلسل تُنقص شدّة التيّار في كامل الدارة (تخفت كلّ المصابيح معًا)، لكنّها تبقى نفسها في كلّ نقاط الحلقة لأنّ الشدّة واحدة في التسلسل.', 6, 'mcq', NULL, NULL)
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
  ('a1d35d6f-806b-51e1-a1b9-0180d305f24a', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: إتقان توزيع التيار وقيسه', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('cd0d1195-fbe4-5248-8173-912f6788e3af', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'في دارة متفرّعة إلى فرعين، أراد تلميذ قيس التيّار الرئيسي وتيّار كلّ فرع. كم أمبيرمترًا يحتاج على الأقلّ، وأين يركّبها؟', '[{"id":"a","text":"ثلاثة أمبيرمترات: واحد في الجذع الرئيسي، وواحد بالتسلسل في كلّ فرع"},{"id":"b","text":"أمبيرمتر واحد بالتفرّع على المولّد يكفي لقراءة الكلّ"},{"id":"c","text":"أمبيرمتران بالتفرّع على الفرعين فقط"},{"id":"d","text":"لا حاجة إلى أيّ أمبيرمتر، تُحسب الشدّات ذهنيًّا فقط"}]'::jsonb, 'a', 'لقيس ثلاث شدّات مختلفة (الرئيسية وفرعان) نحتاج ثلاثة أمبيرمترات، كلٌّ بالتسلسل في المسار المعنيّ: واحد في الجذع وواحد في كلّ فرع. الأمبيرمتر لا يُركّب بالتفرّع.', 1, 'mcq', NULL, NULL)
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
  ('6b892166-ee0a-5f15-8fac-62db7b96f65b', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'دارة متفرّعة: الأمبيرمتر في الجذع الرئيسي يقرأ 0.9 A، وأمبيرمتر الفرع الأوّل يقرأ 0.35 A. لكنّ أمبيرمتر الفرع الثاني تعطّل. ما القيمة التي كان سيقرؤها لو عمل؟', '[{"id":"a","text":"1.25 A"},{"id":"b","text":"0.55 A"},{"id":"c","text":"0.35 A"},{"id":"d","text":"0.9 A"}]'::jsonb, 'b', 'من قانون العقد I = I1 + I2، فإنّ I2 = I − I1 = 0.9 − 0.35 = 0.55 A. نتحقّق: 0.35 + 0.55 = 0.9 A ✓. القيمة 1.25 A ناتجة عن جمع خاطئ.', 2, 'mcq', NULL, NULL)
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
  ('f0159069-2b29-5857-b9ad-ba0205ceb0d4', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'دارة متفرّعة إلى ثلاثة فروع: I1 = 0.2 A ; I2 = 250 mA ; I3 = 0.15 A. ما شدّة التيّار الرئيسي I بالأمبير؟ (انتبه للوحدات)', '[{"id":"a","text":"0.35 A"},{"id":"b","text":"250.35 A"},{"id":"c","text":"0.6 A"},{"id":"d","text":"2.85 A"}]'::jsonb, 'c', 'نوحّد الوحدات أوّلًا: 250 mA = 0.25 A. ثمّ نطبّق قانون العقد: I = 0.2 + 0.25 + 0.15 = 0.6 A. الفخّ هو جمع 250 كما هي دون تحويلها من mA إلى A.', 3, 'mcq', NULL, NULL)
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
  ('f5fef651-89a4-5704-bba9-e5bf3cc42b87', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'أيّ العبارات الأربع التالية عن شدّة التيّار هي **الصحيحة الوحيدة**؟', '[{"id":"a","text":"في دارة بالتسلسل تكون الشدّة أكبر قرب المولّد وأصغر بعد آخر مصباح"},{"id":"b","text":"في دارة متفرّعة يكون التيّار الرئيسي أصغر من كلّ فرع على حدة"},{"id":"c","text":"يُركّب الأمبيرمتر بالتفرّع لأنّ مقاومته كبيرة جدًّا"},{"id":"d","text":"في دارة متفرّعة، التيّار الرئيسي يساوي مجموع تيّارات الفروع وهو أكبر من كلّ فرع"}]'::jsonb, 'd', 'الصحيحة هي (د): I = I1 + I2 فالرئيسي أكبر من كلّ فرع. الباقي خاطئ: الشدّة موحّدة في كلّ نقاط التسلسل، والتيّار الرئيسي أكبر لا أصغر من الفرع، والأمبيرمتر يُركّب بالتسلسل لأنّ مقاومته ضعيفة جدًّا.', 4, 'mcq', NULL, NULL)
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
  ('c85fd007-93cc-5a95-a0f4-35ee95e1e5ff', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'دارة متفرّعة إلى فرعين. زاد تلميذ عدد المصابيح في الفرع الأوّل بالتسلسل، فنقصت شدّة تيّاره من 0.4 A إلى 0.25 A، بينما بقي الفرع الثاني على 0.3 A. كيف يتغيّر التيّار الرئيسي؟', '[{"id":"a","text":"ينقص من 0.7 A إلى 0.55 A"},{"id":"b","text":"يبقى ثابتًا عند 0.7 A"},{"id":"c","text":"يزداد من 0.7 A إلى 0.85 A"},{"id":"d","text":"يصبح 0 A لأنّ الفرع الأوّل تعطّل"}]'::jsonb, 'a', 'التيّار الرئيسي مجموع الفرعين. قبل التغيير: 0.4 + 0.3 = 0.7 A. بعده: 0.25 + 0.3 = 0.55 A. فينقص من 0.7 A إلى 0.55 A تبعًا لنقص تيّار الفرع الأوّل.', 5, 'mcq', NULL, NULL)
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
  ('7ff7822c-3558-583b-91cd-14b7d2de349b', 'a1d35d6f-806b-51e1-a1b9-0180d305f24a', 'لتصميم كاشف تيّار في مختبر، أراد تلميذ قيس تيّار فرع يُتوقّع أن يكون نحو 0.05 A. توفّر لديه أمبيرمتران: أحدهما يقرأ حتّى 1 A بدقّة 0.1 A، والآخر يقرأ حتّى 200 mA بدقّة 1 mA. أيّهما أنسب ولماذا؟', '[{"id":"a","text":"الجهاز الذي يقرأ حتّى 1 A، لأنّ مجاله الأوسع دائمًا أدقّ"},{"id":"b","text":"الجهاز الذي يقرأ حتّى 200 mA، لأنّ التيّار المنتظر (50 mA) داخل مجاله وبدقّة أعلى بكثير"},{"id":"c","text":"أيّ منهما سيّان، فالدقّة لا تؤثّر في القراءة إطلاقًا"},{"id":"d","text":"لا يصلح أيّ منهما، لأنّ 50 mA أكبر من مجالَيهما معًا"}]'::jsonb, 'b', 'التيّار المنتظر 0.05 A = 50 mA، وهو داخل مجال الجهاز 200 mA بدقّة 1 mA (قراءة نحو 50 mA بوضوح). أمّا جهاز 1 A بدقّة 0.1 A = 100 mA فلا يميّز قيمة بهذا الصغر. المجال الأوسع ليس دائمًا أدقّ، و 50 mA أصغر من كلا المجالين لا أكبر.', 6, 'mcq', NULL, NULL)
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
  ('b8aea220-9c60-5d13-b11c-1165b8f1be90', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملة (منحى، قيس، توزيع)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('57d1d739-6285-5798-8ca2-1f3d36be811b', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'عكَس تلميذ قطبَي المولّد في دارته البسيطة. ماذا يحدث لمنحى التيّار في الدارة؟', '[{"id":"a","text":"يبقى المنحى نفسه دون أيّ تغيير"},{"id":"b","text":"ينعكس منحى التيّار في الدارة كلّها"},{"id":"c","text":"يتوقّف التيّار نهائيًّا ولا يعود"},{"id":"d","text":"تتضاعف شدّة التيّار تلقائيًّا"}]'::jsonb, 'b', 'المنحى الاصطلاحي يخرج من القطب الموجب للمولّد، فإذا عكسنا القطبين انعكس منحى التيّار في كامل الدارة. لا يتوقّف التيّار ولا تتضاعف شدّته لمجرّد قلب القطبين.', 1, 'mcq', NULL, NULL)
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
  ('01ebf836-3636-57ab-b737-e8143b0b0026', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'قرأ أمبيرمتر رقمي في دارة القيمة 0.6 A. ثمّ قلب التلميذ ربط مربطَي الأمبيرمتر فقط (دون تغيير المولّد). ماذا تُظهر الشاشة؟', '[{"id":"a","text":"1.2 A، أي ضعف القيمة"},{"id":"b","text":"0 A، لأنّ الدارة أصبحت مفتوحة"},{"id":"c","text":"−0.6 A، أي القيمة نفسها بإشارة سالبة"},{"id":"d","text":"0.3 A، أي نصف القيمة"}]'::jsonb, 'c', 'قلب مربطَي الأمبيرمتر يعكس إشارة القراءة فقط: تصبح −0.6 A. القيمة المطلقة (شدّة التيّار الفعلية) تبقى 0.6 A لأنّ الدارة لم تتغيّر.', 2, 'mcq', NULL, NULL)
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
  ('b66485be-fedc-5f46-acd6-2c081af1c95b', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'في دارة متفرّعة، التيّار الرئيسي I = 1.2 A، والفرع الأوّل I1 = 0.75 A. ما شدّة التيّار في الفرع الثاني I2؟', '[{"id":"a","text":"0.75 A"},{"id":"b","text":"1.95 A"},{"id":"c","text":"1.2 A"},{"id":"d","text":"0.45 A"}]'::jsonb, 'd', 'من قانون العقد I = I1 + I2 نستخرج I2 = I − I1 = 1.2 − 0.75 = 0.45 A. القيمة 1.95 A ناتجة عن الجمع الخاطئ 1.2 + 0.75.', 3, 'mcq', NULL, NULL)
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
  ('1ee3cafa-014e-5894-8e47-c47c3a41e5ef', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'تلميذ يعتقد أنّ الأمبيرمتر يُركّب بالتفرّع كي «يرى» التيّار دون أن يعترضه، وأنّ شدّة التيّار تنقص بعد كلّ مصباح في التسلسل. أيّ تصحيح صحيح لمعتقدَيه معًا؟', '[{"id":"a","text":"الأمبيرمتر يُركّب بالتسلسل ليمرّ التيّار من خلاله، وشدّة التيّار نفسها في كلّ نقاط التسلسل لا تنقص بعد المصباح"},{"id":"b","text":"الأمبيرمتر يُركّب بالتفرّع فعلًا، لكنّ الشدّة ثابتة في التسلسل"},{"id":"c","text":"الأمبيرمتر يُركّب بالتسلسل، لكنّ الشدّة تنقص فعلًا بعد كلّ مصباح"},{"id":"d","text":"المعتقدان صحيحان معًا ولا يحتاجان تصحيحًا"}]'::jsonb, 'a', 'المعتقدان خاطئان: الأمبيرمتر يُركّب بالتسلسل ليمرّ التيّار من خلاله (لا بالتفرّع)، وشدّة التيّار في التسلسل واحدة في كلّ النقاط ولا تنقص بعد المصباح (المصباح يحوّل الطاقة لا الشدّة).', 4, 'mcq', NULL, NULL)
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
  ('e6cd7c28-c6cc-5dd6-ac90-1ffad838d8a1', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'في دارة متفرّعة، قيست شدّة التيّار في فرعَيها: I1 = 0.4 A ; I2 = 0.4 A. ثمّ رُكّب أمبيرمتر في الجذع الرئيسي قبل نقطة التفرّع. ما القيمة المنتظرة، ولماذا؟', '[{"id":"a","text":"0.4 A، لأنّ الشدّة نفسها في الجذع كما في كلّ فرع"},{"id":"b","text":"0.8 A، لأنّ التيّار الرئيسي مجموع تيّارات الفروع (0.4 + 0.4)"},{"id":"c","text":"0 A، لأنّ الفرعين المتساويين يلغي أحدهما الآخر"},{"id":"d","text":"0.16 A، لأنّ الشدّة الرئيسية جذاء الفرعين"}]'::jsonb, 'b', 'الجذع الرئيسي يحمل مجموع تيّارات الفروع وفق قانون العقد: I = I1 + I2 = 0.4 + 0.4 = 0.8 A. الفرعان لا يلغي أحدهما الآخر، والشدّة الرئيسية ليست جذاءهما.', 5, 'mcq', NULL, NULL)
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
  ('404fadbb-a4db-50b3-ad47-f0e0ed20ffea', 'b8aea220-9c60-5d13-b11c-1165b8f1be90', 'دارة بالتسلسل قرأ فيها الأمبيرمتر 0.3 A. أُضيف مصباح ثانٍ مطابق بالتسلسل، فأصبحت القراءة 0.18 A. أيّ استنتاج صحيح حول التوزيع؟', '[{"id":"a","text":"أصبحت الشدّة 0.18 A في فرع و 0.12 A في فرع آخر"},{"id":"b","text":"أصبحت الشدّة 0.3 A قبل المصباح الأوّل و 0.18 A بعده"},{"id":"c","text":"أُنقِصت الشدّة في كامل الدارة إلى 0.18 A، وتبقى هذه القيمة نفسها في كلّ نقاط الحلقة الجديدة"},{"id":"d","text":"لم تتغيّر الشدّة، فما زالت 0.3 A في كلّ مكان"}]'::jsonb, 'c', 'إضافة مصباح بالتسلسل تُنقص الشدّة في كامل الدارة (من 0.3 A إلى 0.18 A)، لكنّها تبقى موحّدة في كلّ نقاط التسلسل. لا وجود لفروع هنا (الدارة تسلسلية)، ولا تختلف الشدّة قبل المصباح وبعده.', 6, 'mcq', NULL, NULL)
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
  ('f2c69168-2631-575a-8c53-a077ade8ac39', '9be74608-8e42-5e5f-bd83-8154e81cf237', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: قانون العقد والتحليل المتقدّم', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('68534bc2-8ed4-5bfa-8396-46ef25d49379', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'دارة متفرّعة إلى فرعين. التيّار الرئيسي I = 1.5 A، وشدّة الفرع الثاني تساوي ضِعف شدّة الفرع الأوّل. ما شدّة كلّ فرع؟', '[{"id":"a","text":"الفرع الأوّل 1 A والفرع الثاني 0.5 A"},{"id":"b","text":"الفرع الأوّل 0.75 A والفرع الثاني 1.5 A"},{"id":"c","text":"الفرع الأوّل 0.5 A والفرع الثاني 1 A"},{"id":"d","text":"الفرع الأوّل 0.3 A والفرع الثاني 0.6 A"}]'::jsonb, 'c', 'لنسمّ الفرع الأوّل x، فالثاني 2x. قانون العقد: x + 2x = 1.5، أي 3x = 1.5 ومنه x = 0.5 A. فالفرع الأوّل 0.5 A والثاني 2 × 0.5 = 1 A. نتحقّق: 0.5 + 1 = 1.5 A ✓.', 1, 'mcq', NULL, NULL)
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
  ('9ef39aa6-1d67-5301-b0e3-7fefc8080fcd', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'دارة متفرّعة إلى فرعين، الأمبيرمتر في الفرع الأوّل يقرأ 300 mA، وفي الجذع الرئيسي يقرأ 0.8 A. ما شدّة الفرع الثاني، بالمليأمبير؟', '[{"id":"a","text":"0.005 mA"},{"id":"b","text":"1100 mA"},{"id":"c","text":"0.5 mA"},{"id":"d","text":"500 mA"}]'::jsonb, 'd', 'نوحّد الوحدات: 300 mA = 0.3 A. قانون العقد: I2 = I − I1 = 0.8 − 0.3 = 0.5 A = 500 mA. القيمة 1100 mA ناتجة عن الجمع بدل الطرح.', 2, 'mcq', NULL, NULL)
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
  ('ca5247b2-d960-5455-aa30-889cc53cde2d', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'طالب يرسم دارة تسلسلية بها مولّد ومصباح، ويريد قيس الشدّة. ركّب الأمبيرمتر بالتفرّع على المصباح فأتلفه. ثمّ أراد تفسير ما جرى. أيّ تفسير صحيح؟', '[{"id":"a","text":"لضعف مقاومة الأمبيرمتر، تركيبه بالتفرّع فتح مسارًا شبه قصير مرّ فيه تيّار قويّ أتلفه ; كان يجب تركيبه بالتسلسل"},{"id":"b","text":"لأنّ المصباح ضعيف، والأمبيرمتر لا يتلف أبدًا مهما كان تركيبه"},{"id":"c","text":"لأنّ الأمبيرمتر يجب تركيبه بالتفرّع دائمًا، والعطب سببه المولّد"},{"id":"d","text":"لأنّ الدارة كانت مفتوحة فلم يمرّ أيّ تيّار إطلاقًا"}]'::jsonb, 'a', 'الأمبيرمتر مقاومته ضعيفة جدًّا، فتركيبه بالتفرّع على المصباح يفتح مسارًا شبيهًا بدارة قصيرة يمرّ فيه تيّار قويّ فجائي يتلفه. القاعدة: يُركّب بالتسلسل دائمًا. لو كانت الدارة مفتوحة لَما تلف الجهاز أصلًا.', 3, 'mcq', NULL, NULL)
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
  ('28835fa8-35e9-5144-92ca-0ef9b61cff56', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'دارة متفرّعة إلى ثلاثة فروع متطابقة تمامًا. قيس التيّار الرئيسي فوُجد 0.66 A. ما شدّة التيّار في كلّ فرع؟', '[{"id":"a","text":"0.33 A"},{"id":"b","text":"0.22 A"},{"id":"c","text":"0.66 A"},{"id":"d","text":"1.98 A"}]'::jsonb, 'b', 'الفروع الثلاثة متطابقة فينقسم التيّار الرئيسي بينها بالتساوي: كلّ فرع = 0.66 ÷ 3 = 0.22 A. نتحقّق: 0.22 × 3 = 0.66 A ✓. القيمة 1.98 A ناتجة عن الضرب في 3 بدل القسمة.', 4, 'mcq', NULL, NULL)
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
  ('d72540ca-2359-5366-85c8-e1254adca984', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'دارة مركّبة: التيّار الرئيسي I = 0.9 A يتفرّع إلى فرعين. الفرع الأوّل نفسه يتفرّع لاحقًا إلى فرعين فرعيّين شدّتاهما 0.15 A و 0.25 A، والفرع الثاني الرئيسي شدّته مجهولة. ما شدّة الفرع الثاني الرئيسي؟', '[{"id":"a","text":"1.3 A"},{"id":"b","text":"0.4 A"},{"id":"c","text":"0.5 A"},{"id":"d","text":"0.65 A"}]'::jsonb, 'c', 'شدّة الفرع الأوّل الرئيسي = مجموع فرعَيه الفرعيّين: 0.15 + 0.25 = 0.4 A. ثمّ من العقدة الرئيسية: I = I(فرع1) + I(فرع2)، أي 0.9 = 0.4 + I(فرع2)، ومنه I(فرع2) = 0.9 − 0.4 = 0.5 A.', 5, 'mcq', NULL, NULL)
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
  ('62319a38-64b6-540b-a566-19c9e94473c0', 'f2c69168-2631-575a-8c53-a077ade8ac39', 'أيّ العبارات الأربع التالية عن قيس التيّار وتوزيعه هي **الخاطئة الوحيدة**؟', '[{"id":"a","text":"إشارة سالبة على أمبيرمتر رقمي تعني أنّ قطبَيه مركّبان بالمقلوب، والشدّة الفعلية هي القيمة المطلقة"},{"id":"b","text":"في التسلسل، إضافة مصباح تُنقص الشدّة في كامل الدارة مع بقائها موحّدة في كلّ نقطة"},{"id":"c","text":"قانون العقد يُعمَّم إلى أيّ عدد من الفروع: I = I1 + I2 + I3 + ..."},{"id":"d","text":"في التفرّع، شدّة كلّ فرع تساوي شدّة التيّار الرئيسي كاملةً"}]'::jsonb, 'd', 'الخاطئة هي (ج): في التفرّع ينقسم التيّار الرئيسي بين الفروع، فشدّة كلّ فرع أصغر من الرئيسي لا مساوية له. الباقي صحيح: الإشارة السالبة تعني قلب القطبين، وإضافة مصباح بالتسلسل تُنقص الشدّة الموحّدة، وقانون العقد يُعمَّم إلى أيّ عدد من الفروع.', 6, 'mcq', NULL, NULL)
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
  ('069f92c3-acce-5a32-9906-4bba512e1479', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('93011218-bb20-56b3-aedd-5488272b8df5', '069f92c3-acce-5a32-9906-4bba512e1479', 'ما وحدة قيس التوتّر الكهربائي ورمزها؟', '[{"id":"a","text":"الأمبير، رمزه A"},{"id":"b","text":"الفولط، رمزه V"},{"id":"c","text":"الفولط، رمزه A"},{"id":"d","text":"الأمبير، رمزه V"}]'::jsonb, 'b', 'وحدة التوتّر الكهربائي هي الفولط ورمزها V؛ أمّا الأمبير (A) فهو وحدة شدّة التيّار الكهربائي، لا التوتّر.', 1, 'mcq', NULL, NULL)
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
  ('13e45d71-984a-5f78-a42f-11bcc10665c0', '069f92c3-acce-5a32-9906-4bba512e1479', 'ما الجهاز الذي نستعمله لقيس التوتّر الكهربائي بين طرفَي مصباح؟', '[{"id":"a","text":"الأمبيرمتر"},{"id":"b","text":"الميزان"},{"id":"c","text":"الفولطمتر"},{"id":"d","text":"الترمومتر"}]'::jsonb, 'c', 'نقيس التوتّر بالفولطمتر؛ الأمبيرمتر يقيس شدّة التيّار، والترمومتر يقيس درجة الحرارة، والميزان يقيس الكتلة.', 2, 'mcq', NULL, NULL)
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
  ('0b1858bb-480a-570a-b31b-48dd9ead6525', '069f92c3-acce-5a32-9906-4bba512e1479', 'كيف يُركَّب الفولطمتر في الدارة لقيس التوتّر بين طرفَي ثنائي قطب؟', '[{"id":"a","text":"بالتفرّع بين طرفَي الثنائي"},{"id":"b","text":"بالتسلسل داخل الحلقة"},{"id":"c","text":"بين قطبَي المولّد فقط دائمًا"},{"id":"d","text":"خارج الدارة دون توصيل"}]'::jsonb, 'a', 'يُركَّب الفولطمتر بالتفرّع (بالتوازي) بين طرفَي الثنائي المراد قيس توتّره، ولا يُركَّب بالتسلسل؛ التركيب بالتسلسل خاصّ بالأمبيرمتر.', 3, 'mcq', NULL, NULL)
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
  ('bb032b17-6311-5472-b8ea-6c5a0272fa60', '069f92c3-acce-5a32-9906-4bba512e1479', 'في دارة بالتسلسل، مولّد توتّره 6 V يغذّي مصباحَين. التوتّر بين طرفَي المصباح الأوّل 4 V. ما التوتّر بين طرفَي المصباح الثاني؟', '[{"id":"a","text":"10 V"},{"id":"b","text":"6 V"},{"id":"c","text":"4 V"},{"id":"d","text":"2 V"}]'::jsonb, 'd', 'في التسلسل يُجمع التوتّر: U = U1 + U2، أي 6 = 4 + U2، فيكون U2 = 6 − 4 = 2 V. الخيار 10 V ناتج عن جمع خاطئ (6 + 4).', 4, 'mcq', NULL, NULL)
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
  ('ff42a681-8223-59e6-9327-87b4d0ea972d', '069f92c3-acce-5a32-9906-4bba512e1479', 'في دارة متفرّعة، مولّد توتّره 6 V يغذّي مصباحَين مركّبَين بالتفرّع. ما التوتّر بين طرفَي كلّ مصباح؟', '[{"id":"a","text":"3 V لكلّ مصباح، لأنّ التوتّر ينقسم بينهما"},{"id":"b","text":"6 V لكلّ مصباح، لأنّ التوتّر متساوٍ بين طرفَي الفرعَين"},{"id":"c","text":"12 V لكلّ مصباح"},{"id":"d","text":"0 V لأنّ الفرعَين يلغيان بعضهما"}]'::jsonb, 'b', 'في التركيب بالتفرّع يكون التوتّر بين طرفَي كلّ فرع متساويًا: U1 = U2 = U = 6 V. التوتّر لا ينقسم بين الفرعَين (هذا سلوك شدّة التيّار في التفرّع، لا التوتّر).', 5, 'mcq', NULL, NULL)
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
  ('b10099c5-70b1-51c4-bced-13e914936a28', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '⭐ تمرين: التوتّر الكهربائي وقيسه', 1, 50, 10, 'practice', 'admin', 1)
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
  ('eaf884b8-2fd0-57cc-9225-758559f79e7a', 'b10099c5-70b1-51c4-bced-13e914936a28', 'بأيّ حرف يُرمز إلى التوتّر الكهربائي؟', '[{"id":"a","text":"الحرف I"},{"id":"b","text":"الحرف U"},{"id":"c","text":"الحرف V"},{"id":"d","text":"الحرف A"}]'::jsonb, 'b', 'يُرمز إلى التوتّر الكهربائي بالحرف U؛ أمّا V فهو رمز وحدته (الفولط)، والحرف I يرمز إلى شدّة التيّار.', 1, 'mcq', NULL, NULL)
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
  ('655c8280-3f65-5cd2-96a8-50625061be62', 'b10099c5-70b1-51c4-bced-13e914936a28', 'أكمل: نقيس التوتّر الكهربائي بجهاز اسمه … ووحدته …', '[{"id":"a","text":"الفولطمتر، والفولط (V)"},{"id":"b","text":"الأمبيرمتر، والأمبير (A)"},{"id":"c","text":"الفولطمتر، والأمبير (A)"},{"id":"d","text":"الأمبيرمتر، والفولط (V)"}]'::jsonb, 'a', 'التوتّر يُقاس بالفولطمتر ووحدته الفولط (V). الأمبيرمتر والأمبير (A) يخصّان شدّة التيّار، لا التوتّر.', 2, 'mcq', NULL, NULL)
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
  ('b6c68624-bd0c-56a7-a83d-99fa99691468', 'b10099c5-70b1-51c4-bced-13e914936a28', 'أين يوجد التوتّر الكهربائي بالنسبة إلى مصباح في دارة؟', '[{"id":"a","text":"داخل السلك بعيدًا عن المصباح"},{"id":"b","text":"في القاطع فقط"},{"id":"c","text":"بين طرفَي المصباح (بين نقطتَين)"},{"id":"d","text":"لا وجود له إلّا في المولّد"}]'::jsonb, 'c', 'التوتّر مقدار يوجد بين طرفَي الثنائي، أي بين نقطتَي المصباح. (شدّة التيّار هي التي تصف ما يعبُر المصباح، أمّا التوتّر فبين طرفَيه.)', 3, 'mcq', NULL, NULL)
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
  ('dc6e636f-c8f6-568d-9b1b-0733076cc23d', 'b10099c5-70b1-51c4-bced-13e914936a28', 'كيف يُركَّب الفولطمتر لقيس توتّر مصباح دون قطع الدارة؟', '[{"id":"a","text":"بالتسلسل داخل الحلقة"},{"id":"b","text":"بالتفرّع بين طرفَي المصباح"},{"id":"c","text":"نقطعه من المصباح ونضعه وحده"},{"id":"d","text":"بين قطبَي المولّد وجوبًا"}]'::jsonb, 'b', 'يُركَّب الفولطمتر بالتفرّع بين طرفَي المصباح مباشرةً دون قطع الدارة؛ التركيب بالتسلسل خاصّ بالأمبيرمتر ويستلزم قطع الحلقة.', 4, 'mcq', NULL, NULL)
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
  ('5e8612c7-49aa-5779-89f5-1f70cc138e26', 'b10099c5-70b1-51c4-bced-13e914936a28', 'مولّد توتّره 4,5 V يغذّي مصباحًا واحدًا في دارة بالتسلسل. ما التوتّر التقريبي بين طرفَي هذا المصباح الوحيد؟', '[{"id":"a","text":"0 V"},{"id":"b","text":"9 V"},{"id":"c","text":"4,5 V"},{"id":"d","text":"2,25 V"}]'::jsonb, 'c', 'بوجود مستقبل واحد فقط، يظهر كامل توتّر المولّد بين طرفَيه: U = 4,5 V. القيمتان 9 V و2,25 V ناتجتان عن مضاعفة أو تنصيف لا مبرّر له.', 5, 'mcq', NULL, NULL)
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
  ('c92113ce-ba70-5329-a5e3-bff12dedf092', 'b10099c5-70b1-51c4-bced-13e914936a28', 'ركّب تلميذ فولطمترًا رقميًّا بين طرفَي مصباح فعرض القيمة −3 V (سالبة). ما التفسير؟', '[{"id":"a","text":"المصباح مكسور لا محالة"},{"id":"b","text":"التوتّر الحقيقي سالب فيزيائيًّا"},{"id":"c","text":"الفولطمتر معطوب دائمًا عند القيم السالبة"},{"id":"d","text":"مرابط الفولطمتر موصولة معكوسة، والقيمة الفعلية 3 V"}]'::jsonb, 'd', 'القيمة السالبة على الفولطمتر الرقمي تعني أنّ المرابط (COM وV) موصولة بالمقلوب؛ يكفي عكس التوصيل لتظهر القيمة الموجبة 3 V.', 6, 'mcq', NULL, NULL)
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
  ('e2cd76c2-d2b6-5d50-9804-779d0255e3be', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: أسرار التوتّر الكهربائي', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ea343d3b-73b3-52f4-b41c-3dffe5a52ed0', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'بطّارية جديدة موضوعة على الطاولة، غير موصولة بأيّ دارة. ركّب تلميذ فولطمترًا بين قطبَيها فعرض 9 V. ما الاستنتاج الصحيح؟', '[{"id":"a","text":"يوجد توتّر بين قطبَي المولّد حتّى دون جريان تيّار"},{"id":"b","text":"الفولطمتر معطوب، لأنّه لا يوجد توتّر دون دارة مغلقة"},{"id":"c","text":"التوتّر ظهر لأنّ التيّار يجري داخل البطّارية وحدها"},{"id":"d","text":"التوتّر يوجد فقط بعد غلق الدارة على مصباح"}]'::jsonb, 'a', 'المولّد يحافظ على توتّر بين قطبَيه حتّى وهو معزول والدارة مفتوحة؛ هذا التوتّر هو سبب جريان التيّار لاحقًا، لا نتيجته، فوجوده دون تيّار أمر طبيعي.', 1, 'mcq', NULL, NULL)
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
  ('de45771e-48be-5845-b61c-381011e94faf', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'لقيس التوتّر بين طرفَي محرّك يعمل، أيّ تركيب للفولطمتر هو الصحيح؟', '[{"id":"a","text":"نقطع الدارة عند المحرّك ونضع الفولطمتر مكانه بالتسلسل"},{"id":"b","text":"نصل مربطَي الفولطمتر بطرفَي المحرّك بالتفرّع دون قطع الدارة"},{"id":"c","text":"نصل مربطًا واحدًا فقط بأحد طرفَي المحرّك"},{"id":"d","text":"نصل الفولطمتر بقطبَي المولّد لأنّ التوتّر واحد في كلّ مكان"}]'::jsonb, 'b', 'الفولطمتر يُركَّب بالتفرّع بين طرفَي المحرّك مباشرةً دون قطع الحلقة. قطع الدارة ووضعه بالتسلسل خطأ (ذاك تركيب الأمبيرمتر)، وقيس توتّر المولّد لا يساوي توتّر المحرّك في التسلسل.', 2, 'mcq', NULL, NULL)
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
  ('b5425926-b287-5877-873d-47062066e50d', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'في دارة بالتسلسل، مولّد توتّره 12 V يغذّي ثلاثة مصابيح متماثلة. ما التوتّر بين طرفَي كلّ مصباح؟', '[{"id":"a","text":"12 V"},{"id":"b","text":"6 V"},{"id":"c","text":"4 V"},{"id":"d","text":"36 V"}]'::jsonb, 'c', 'التوتّر يُجمع في التسلسل: U = U1 + U2 + U3 = 12، وبتماثل المصابيح يتوزّع بالتساوي: 12 ÷ 3 = 4 V لكلّ مصباح. القيمة 6 V تصلح لمصباحَين لا ثلاثة.', 3, 'mcq', NULL, NULL)
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
  ('1b8f5b05-ffc3-55e3-9228-aa4c871ae18e', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'في ورشة بمدنين، دارة بالتسلسل توتّر مولّدها 6 V، وبها مصباح ومحرّك. قِيس التوتّر بين طرفَي المصباح فكان 2,5 V. ما التوتّر بين طرفَي المحرّك؟', '[{"id":"a","text":"8,5 V"},{"id":"b","text":"2,5 V"},{"id":"c","text":"6 V"},{"id":"d","text":"3,5 V"}]'::jsonb, 'd', 'في التسلسل: U = U(مصباح) + U(محرّك)، أي 6 = 2,5 + U، فيكون U = 6 − 2,5 = 3,5 V. القيمة 8,5 V ناتجة عن جمع خاطئ (6 + 2,5).', 4, 'mcq', NULL, NULL)
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
  ('d5d44f27-b37d-5476-8bd6-409f3e7623f0', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'دارة متفرّعة توتّر مولّدها 4,5 V، وبها مصباحان في فرعَين بين نفس النقطتَين. قال تلميذ: «بما أنّهما مصباحان، فالتوتّر ينقسم فيصبح 2,25 V لكلّ واحد». ما الصحيح؟', '[{"id":"a","text":"كلامه صحيح: 2,25 V لكلّ مصباح"},{"id":"b","text":"التوتّر بين طرفَي كلّ مصباح 4,5 V لأنّه متساوٍ في التفرّع"},{"id":"c","text":"التوتّر بين طرفَي كلّ مصباح 9 V"},{"id":"d","text":"لا يمكن معرفة التوتّر دون قيس شدّة التيّار"}]'::jsonb, 'b', 'في التفرّع التوتّر بين طرفَي كلّ فرع متساوٍ: U1 = U2 = 4,5 V. الانقسام (2,25 V) خطأ ينقل سلوك شدّة التيّار (التي تتوزّع في التفرّع) إلى التوتّر.', 5, 'mcq', NULL, NULL)
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
  ('7b2b30b6-8d54-548c-a175-fb898d361371', 'e2cd76c2-d2b6-5d50-9804-779d0255e3be', 'أيّ العبارات التالية **خاطئة**؟', '[{"id":"a","text":"في التسلسل تُجمع التوترات: U = U1 + U2"},{"id":"b","text":"في التفرّع يتساوى التوتّر بين طرفَي الفروع"},{"id":"c","text":"في التسلسل يتساوى التوتّر بين طرفَي كلّ مستقبل دائمًا كما تتساوى شدّة التيّار"},{"id":"d","text":"الفولطمتر يُركَّب بالتفرّع والأمبيرمتر بالتسلسل"}]'::jsonb, 'c', 'العبارة الخاطئة هي: «في التسلسل يتساوى التوتّر بين طرفَي كلّ مستقبل دائمًا». في التسلسل شدّة التيّار هي المتساوية، أمّا التوتّر فيُجمع ولا يتساوى إلّا صدفةً عند تماثل المستقبلات. بقيّة العبارات صحيحة.', 6, 'mcq', NULL, NULL)
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
  ('dfd55ec5-8aa0-555c-9925-da9a4eda8e67', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '⭐⭐ تمرين مراجعة: التوتّر في التسلسل والتفرّع (نمط امتحان)', 2, 70, 15, 'practice', 'admin', 3)
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
  ('226e84e8-26ce-5ea4-816b-4e6d2e114e8a', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'أيّ عبارة تصف التوتّر الكهربائي وصفًا صحيحًا؟', '[{"id":"a","text":"مقدار يعبُر الثنائي ويُقاس بالأمبيرمتر"},{"id":"b","text":"مقدار بين طرفَي الثنائي ويُقاس بالفولطمتر"},{"id":"c","text":"كتلة الثنائي ويُقاس بالميزان"},{"id":"d","text":"درجة حرارة الثنائي ويُقاس بالترمومتر"}]'::jsonb, 'b', 'التوتّر مقدار يوجد بين طرفَي الثنائي (بين نقطتَين) ويُقاس بالفولطمتر. الوصف الأوّل يخصّ شدّة التيّار (تعبُر الثنائي، أمبيرمتر).', 1, 'mcq', NULL, NULL)
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
  ('3de319e6-1625-53cd-8c41-9e12738d7711', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'في دارة بالتسلسل، مولّد توتّره 9 V يغذّي مصباحَين. التوتّر بين طرفَي المصباح الأوّل 5 V. ما التوتّر بين طرفَي المصباح الثاني؟', '[{"id":"a","text":"14 V"},{"id":"b","text":"5 V"},{"id":"c","text":"9 V"},{"id":"d","text":"4 V"}]'::jsonb, 'd', 'في التسلسل: U = U1 + U2، أي 9 = 5 + U2، فيكون U2 = 9 − 5 = 4 V. القيمة 14 V ناتجة عن جمع المولّد والمصباح خطأً (9 + 5).', 2, 'mcq', NULL, NULL)
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
  ('de45ea72-709a-50d3-afca-89ec774455ad', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'في دارة متفرّعة، التوتّر بين طرفَي المصباح الأوّل 4,5 V. ما التوتّر بين طرفَي المصباح الثاني المركّب بالتفرّع معه بين نفس النقطتَين؟', '[{"id":"a","text":"4,5 V"},{"id":"b","text":"9 V"},{"id":"c","text":"2,25 V"},{"id":"d","text":"0 V"}]'::jsonb, 'a', 'الفرعان المركّبان بالتفرّع بين نفس النقطتَين لهما توتّر متساوٍ: U1 = U2 = 4,5 V. القيمتان 9 V و2,25 V تفترضان جمعًا أو قسمة لا وجود لهما في التفرّع.', 3, 'mcq', NULL, NULL)
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
  ('75481405-1d91-50ac-b5bd-ba608e701122', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'في دارة بالتسلسل بها ثلاثة مصابيح متماثلة، مولّد توتّره 6 V. ما التوتّر بين طرفَي كلّ مصباح؟', '[{"id":"a","text":"6 V"},{"id":"b","text":"3 V"},{"id":"c","text":"2 V"},{"id":"d","text":"18 V"}]'::jsonb, 'c', 'التوتّر يُجمع في التسلسل ويتوزّع بالتساوي على المصابيح المتماثلة: U = U1 + U2 + U3 = 6، فكلّ واحد 6 ÷ 3 = 2 V. القيمة 3 V تصلح لمصباحَين لا ثلاثة.', 4, 'mcq', NULL, NULL)
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
  ('dfa5555e-66c0-57f1-9f1e-348e47f18977', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'أراد تلميذ قيس شدّة التيّار في دارة، فأخذ فولطمترًا وركّبه بالتفرّع. ما الخطأ في عمله؟', '[{"id":"a","text":"لا خطأ، الفولطمتر يقيس الشدّة أيضًا"},{"id":"b","text":"الخطأ في اختيار الجهاز: شدّة التيّار تُقاس بالأمبيرمتر لا بالفولطمتر"},{"id":"c","text":"الخطأ أنّه ركّبه بالتفرّع بدل التسلسل فقط"},{"id":"d","text":"الخطأ أنّه لم يعكس المرابط"}]'::jsonb, 'b', 'الفولطمتر يقيس التوتّر لا شدّة التيّار؛ لقيس الشدّة يجب استعمال الأمبيرمتر وتركيبه بالتسلسل. الخطأ الأساسي هو اختيار الجهاز غير المناسب للمقدار.', 5, 'mcq', NULL, NULL)
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
  ('ceb76991-d3c9-55e8-879a-a2574ae83353', 'dfd55ec5-8aa0-555c-9925-da9a4eda8e67', 'في دارة بالتسلسل، مولّد توتّره 12 V يغذّي محرّكًا ومصباحًا. إذا كان التوتّر بين طرفَي المحرّك 7,5 V، فما التوتّر بين طرفَي المصباح؟', '[{"id":"a","text":"19,5 V"},{"id":"b","text":"7,5 V"},{"id":"c","text":"4,5 V"},{"id":"d","text":"12 V"}]'::jsonb, 'c', 'في التسلسل: U = U(محرّك) + U(مصباح)، أي 12 = 7,5 + U، فيكون U = 12 − 7,5 = 4,5 V. القيمة 19,5 V ناتجة عن جمع خاطئ (12 + 7,5).', 6, 'mcq', NULL, NULL)
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
  ('dec94a5b-949d-527e-8a07-6272b058c4f9', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّد التوتّر الكهربائي', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('380ebfab-f0c5-5f6f-9165-3193b0f3b8d7', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'ركّب تلميذ فولطمترًا بالتسلسل داخل الحلقة ظنًّا منه أنّه سيقيس التوتّر كما يفعل الأمبيرمتر مع الشدّة. ما تقييم عمله؟', '[{"id":"a","text":"صحيح، فطريقة تركيب الجهازَين واحدة"},{"id":"b","text":"خطأ في التركيب: الفولطمتر يُركَّب بالتفرّع بين طرفَي الثنائي لا بالتسلسل"},{"id":"c","text":"خطأ في اختيار الوحدة فقط"},{"id":"d","text":"صحيح لأنّ التفرّع والتسلسل سيّان للفولطمتر"}]'::jsonb, 'b', 'الجهازان لا يُركَّبان بنفس الطريقة: الأمبيرمتر بالتسلسل (ليعبُره التيّار) والفولطمتر بالتفرّع بين طرفَي الثنائي (ليقيس ما بين نقطتَين). تركيب الفولطمتر بالتسلسل خطأ في المبدأ لا في الوحدة.', 1, 'mcq', NULL, NULL)
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
  ('5d6b96d6-87bd-58a7-936c-922965e929cd', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'في دارة بالتسلسل، مولّد توتّره 12 V يغذّي أربعة مصابيح متماثلة. ما التوتّر بين طرفَي مصباحَين متتاليَين معًا (بين طرفَي المجموعة)؟', '[{"id":"a","text":"3 V"},{"id":"b","text":"24 V"},{"id":"c","text":"12 V"},{"id":"d","text":"6 V"}]'::jsonb, 'd', 'كلّ مصباح: 12 ÷ 4 = 3 V. التوتّر بين طرفَي مصباحَين متتاليَين هو مجموع توتّرَيهما: 3 + 3 = 6 V. القيمة 3 V توتّر مصباح واحد فقط، و12 V توتّر الأربعة معًا.', 2, 'mcq', NULL, NULL)
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
  ('e1efa255-c9b6-5f28-b879-9894f148605a', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'دارة فيها فرعان بالتفرّع بين النقطتَين A وB: الفرع الأوّل مصباح، والفرع الثاني محرّك. قِيس التوتّر بين طرفَي المصباح فكان 6 V. ماذا نستنتج عن التوتّر بين A وB وعن توتّر المحرّك؟', '[{"id":"a","text":"التوتّر بين A وB هو 6 V، وتوتّر المحرّك 6 V أيضًا"},{"id":"b","text":"التوتّر بين A وB هو 12 V، وتوتّر المحرّك 6 V"},{"id":"c","text":"التوتّر بين A وB هو 3 V، وتوتّر المحرّك 3 V"},{"id":"d","text":"لا يمكن معرفة توتّر المحرّك دون قيسه بجهاز آخر"}]'::jsonb, 'a', 'الفرعان بين نفس النقطتَين A وB، فالتوتّر بينهما واحد لكليهما وللنقطتَين: U(AB) = U(مصباح) = U(محرّك) = 6 V. هذا هو قانون تساوي التوتّر في التفرّع.', 3, 'mcq', NULL, NULL)
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
  ('3b096c27-d89c-5b3c-8fc6-f198ad8195cc', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'كتب تلميذ: «في دارة بالتسلسل، U(المولّد) = U1 − U2»، فحسب توتّر المصباح الثاني في دارة 9 V ومصباح أوّل 5 V فوجده 9 − (9 − 5) = 5 V. أين الخطأ المفهومي؟', '[{"id":"a","text":"لا خطأ، النتيجة 5 V صحيحة"},{"id":"b","text":"الخطأ في المولّد نفسه إذ يجب أن يكون 14 V"},{"id":"c","text":"القانون الصحيح جمعٌ لا طرح: U = U1 + U2، ومنه U2 = 9 − 5 = 4 V"},{"id":"d","text":"الخطأ أنّ التوتّرات تُضرب لا تُجمع"}]'::jsonb, 'c', 'قانون التوتّر في التسلسل جمعٌ: U = U1 + U2؛ توتّر المولّد يوزَّع على المستقبلات ولا يُطرح أحدها من الآخر. الحلّ الصحيح: U2 = U − U1 = 9 − 5 = 4 V، لا 5 V.', 4, 'mcq', NULL, NULL)
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
  ('598fe436-ee3e-59e6-978b-987291208c3d', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'دارة بالتسلسل توتّر مولّدها 6 V، بها مصباحان: قِيس توتّر المصباح الأوّل 2 V. ثمّ فُصل المصباح الثاني وأُبدل بسلك توصيل بسيط (توتّره ≈ 0 V) مع بقاء المصباح الأوّل. ما التوتّر الجديد بين طرفَي المصباح الأوّل تقريبًا؟', '[{"id":"a","text":"2 V كما كان"},{"id":"b","text":"0 V"},{"id":"c","text":"6 V تقريبًا (يظهر كامل توتّر المولّد عليه)"},{"id":"d","text":"4 V"}]'::jsonb, 'c', 'بعد استبدال المستقبل الثاني بسلك توتّره ≈ 0 V، يبقى المصباح الأوّل وحده مستقبلًا فعليًّا في التسلسل: U = U(مصباح) + U(سلك) = U + 0، فيظهر عليه كامل توتّر المولّد ≈ 6 V. توزيع 2 V/4 V كان بسبب وجود مستقبلَين.', 5, 'mcq', NULL, NULL)
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
  ('7a6075c9-f142-50d4-9edd-8a0b2bc29f87', 'dec94a5b-949d-527e-8a07-6272b058c4f9', 'في دارة، A وB نقطتان بينهما مصباح، وB وC نقطتان بينهما محرّك، والكلّ بالتسلسل مع مولّد توتّره 9 V. إذا كان U(AB) = 3,5 V وU(BC) = 4 V، فما التوتّر بين طرفَي سلك التوصيل الباقي، وهل الأرقام متّسقة؟', '[{"id":"a","text":"توتّر السلك ≈ 1,5 V، والأرقام متّسقة"},{"id":"b","text":"توتّر السلك ≈ 0 V، لكنّ 3,5 + 4 = 7,5 V فقط، أي أنّ 1,5 V مفقودة تعني وجود مستقبل ثالث"},{"id":"c","text":"توتّر السلك ≈ 0 V، و3,5 + 4 = 9 V فالأرقام متّسقة تمامًا"},{"id":"d","text":"توتّر السلك = 9 V"}]'::jsonb, 'b', 'توتّر سلك التوصيل ≈ 0 V دائمًا. مجموع توتّرات المستقبلين 3,5 + 4 = 7,5 V، وهو أقلّ من 9 V بمقدار 1,5 V؛ بما أنّ السلك لا يستهلك توتّرًا، فالفارق 1,5 V يدلّ على مستقبل ثالث في الحلقة. (لا يمكن للسلك أن يحمل 1,5 V.)', 6, 'mcq', NULL, NULL)
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
  ('657a8e53-4608-5b50-904b-c3ae6abdf998', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '📝 تدريب ⭐⭐⭐: توتّر الدارات (مراجعة شاملة)', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5dd0313a-af21-5942-86b5-c72af132785d', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'ما الفرق الأساسي بين شدّة التيّار والتوتّر؟', '[{"id":"a","text":"شدّة التيّار تصف ما يعبُر الثنائي، والتوتّر ما يوجد بين طرفَيه"},{"id":"b","text":"لا فرق بينهما، هما اسمان لنفس المقدار"},{"id":"c","text":"شدّة التيّار تُقاس بالفولطمتر والتوتّر بالأمبيرمتر"},{"id":"d","text":"التوتّر يوجد في التسلسل فقط والشدّة في التفرّع فقط"}]'::jsonb, 'a', 'شدّة التيّار (I، أمبير A) تصف ما يعبُر الثنائي، بينما التوتّر (U، فولط V) يصف ما يوجد بين طرفَيه. القيس معكوس في الخيار الثالث، ووجود كلّ منهما لا يقتصر على تركيب واحد.', 1, 'mcq', NULL, NULL)
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
  ('7ab11d45-39d9-548f-ac77-f009eb8409eb', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'تلميذة في نابل تريد قيس التوتّر بين طرفَي مصباح. أيّ خطوة صحيحة؟', '[{"id":"a","text":"تقطع الدارة وتُدخل الفولطمتر بالتسلسل"},{"id":"b","text":"تصل مربط COM جهة القطب السالب ومربط V جهة الموجب، بالتفرّع"},{"id":"c","text":"تستعمل أمبيرمترًا بالتفرّع"},{"id":"d","text":"تصل الفولطمتر بمربط واحد فقط"}]'::jsonb, 'b', 'يُركَّب الفولطمتر بالتفرّع بين طرفَي المصباح، مع وصل COM جهة السالب وV جهة الموجب حتّى تظهر قيمة موجبة. الأمبيرمتر لا يقيس التوتّر، والتركيب بالتسلسل خطأ.', 2, 'mcq', NULL, NULL)
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
  ('34c28d42-a214-5aba-abb3-c4014731b4b0', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'في دارة بالتسلسل، مولّد توتّره 10 V يغذّي ثلاثة مستقبلات. قِيس توتّرا مستقبلَين: 3 V و4 V. ما التوتّر بين طرفَي المستقبل الثالث؟', '[{"id":"a","text":"7 V"},{"id":"b","text":"17 V"},{"id":"c","text":"3 V"},{"id":"d","text":"10 V"}]'::jsonb, 'c', 'في التسلسل: U = U1 + U2 + U3، أي 10 = 3 + 4 + U3، فيكون U3 = 10 − 7 = 3 V. القيمة 7 V هي مجموع المستقبلَين الأوّلَين فقط لا نصيب الثالث.', 3, 'mcq', NULL, NULL)
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
  ('0d487d56-1d9f-5e95-b2d7-16d2be004253', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'دارة متفرّعة توتّر مولّدها 6 V، وبها ثلاثة فروع بين نفس النقطتَين، في كلّ فرع مصباح. ما التوتّر بين طرفَي المصباح في الفرع الثالث؟', '[{"id":"a","text":"2 V، لأنّ 6 يُقسم على 3"},{"id":"b","text":"18 V"},{"id":"c","text":"0 V"},{"id":"d","text":"6 V، لأنّ التوتّر متساوٍ بين طرفَي كلّ فرع"}]'::jsonb, 'd', 'التوتّر بين طرفَي كلّ فرع في التفرّع متساوٍ ويساوي توتّر المصدر: U1 = U2 = U3 = 6 V. القسمة على عدد الفروع (2 V) خطأ ينقل سلوك شدّة التيّار إلى التوتّر.', 4, 'mcq', NULL, NULL)
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
  ('234f57d4-4784-53a3-af91-5c75bf7857ea', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'في دارة بالتسلسل، مولّد توتّره 9 V يغذّي مصباحًا (توتّره 3,5 V) ومحرّكًا. ثمّ في تجربة أخرى رُكِّب نفس المصباح والمحرّك بالتفرّع على نفس المولّد. ما التوتّر بين طرفَي المصباح في كلّ حالة؟', '[{"id":"a","text":"3,5 V في التسلسل، و9 V في التفرّع"},{"id":"b","text":"9 V في الحالتَين"},{"id":"c","text":"3,5 V في الحالتَين"},{"id":"d","text":"5,5 V في التسلسل، و3,5 V في التفرّع"}]'::jsonb, 'a', 'في التسلسل يتوزّع التوتّر: المصباح 3,5 V (والمحرّك 9 − 3,5 = 5,5 V). في التفرّع يتساوى التوتّر بين طرفَي الفرعَين مع المصدر: 9 V للمصباح. فالنتيجة 3,5 V ثمّ 9 V.', 5, 'mcq', NULL, NULL)
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
  ('7edcefca-2b92-5062-9583-058ca7ea0657', '657a8e53-4608-5b50-904b-c3ae6abdf998', 'قال تلميذ: «في التركيب بالتسلسل، التوتّر بين طرفَي كلّ مستقبل واحد ومتساوٍ، تمامًا كشدّة التيّار». ما الحكم الصحيح؟', '[{"id":"a","text":"صحيح تمامًا"},{"id":"b","text":"خطأ: في التسلسل شدّة التيّار هي المتساوية، أمّا التوتّر فيُجمع"},{"id":"c","text":"خطأ: في التسلسل التوتّر وشدّة التيّار كلاهما يُجمع"},{"id":"d","text":"صحيح لكن في التفرّع فقط"}]'::jsonb, 'b', 'هذا هو الفخّ الأكبر: في التسلسل شدّة التيّار واحدة في كلّ نقطة، بينما التوتّر يُجمع (U = U1 + U2) ولا يتساوى إلّا عند تماثل المستقبلات. نقل خاصية الشدّة إلى التوتّر خطأ.', 6, 'mcq', NULL, NULL)
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
  ('eb085b0e-3166-59c3-9e33-c4ef45e97440', '3c3d7918-8dbf-54e8-8bce-e33ce02fe476', 'sciences-physiques-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أستاذ توزيع التوتّر', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('90727243-3522-5a56-b84a-7440ceef20fc', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'عرض فولطمتر رقمي القيمة −4,5 V بين طرفَي مصباح. ما الإجراء الصحيح لقراءة القيمة الموجبة؟', '[{"id":"a","text":"نعكس مربطَي الفولطمتر (COM وV) فتظهر 4,5 V"},{"id":"b","text":"نغيّر المصباح بمصباح آخر"},{"id":"c","text":"نضاعف العدد فتصبح 9 V"},{"id":"d","text":"نركّب الفولطمتر بالتسلسل بدل التفرّع"}]'::jsonb, 'a', 'الإشارة السالبة تدلّ على توصيل معكوس للمرابط؛ عكس COM وV يعيد القراءة موجبة 4,5 V. القيمة المطلقة للتوتّر لم تتغيّر، فلا داعي لتغيير المصباح ولا مضاعفة العدد.', 1, 'mcq', NULL, NULL)
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
  ('51bbaf04-c17f-54a0-96b9-f481f0da1d98', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'في دارة بالتسلسل، مولّد توتّره 9 V يغذّي ثلاثة مصابيح متماثلة M1 وM2 وM3. ما التوتّر بين طرفَي المصباحَين M1 وM2 معًا (بين طرفَي المجموعة)؟', '[{"id":"a","text":"3 V"},{"id":"b","text":"9 V"},{"id":"c","text":"6 V"},{"id":"d","text":"4,5 V"}]'::jsonb, 'c', 'كلّ مصباح متماثل: 9 ÷ 3 = 3 V. التوتّر بين طرفَي M1 وM2 معًا هو مجموع توتّرَيهما: 3 + 3 = 6 V، ويبقى 3 V للمصباح M3. القيمة 4,5 V تنصيف خاطئ للمولّد.', 2, 'mcq', NULL, NULL)
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
  ('d0bb6f39-1caa-58c0-9b93-fa07a2427c3c', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'دارة بها ثلاثة فروع بالتفرّع بين النقطتَين A وB. قِيس توتّر الفرع الأوّل فكان 4 V، وتوتّر الفرع الثاني فكان 4 V. من دون أيّ قيس، ماذا نجزم به عن توتّر الفرع الثالث بين A وB؟', '[{"id":"a","text":"4 V، لأنّ التوتّر بين طرفَي الفروع المتفرّعة متساوٍ"},{"id":"b","text":"8 V، لأنّ توتّر الفرعَين الأوّلَين يُجمع عليه"},{"id":"c","text":"0 V"},{"id":"d","text":"لا يمكن الجزم دون قيس"}]'::jsonb, 'a', 'الفروع الثلاثة بين نفس النقطتَين A وB، فالتوتّر بينها واحد لكلّها: U1 = U2 = U3 = 4 V. لا يُجمع التوتّر في التفرّع (الجمع خاصية التسلسل)، فالجزم ممكن دون قيس.', 3, 'mcq', NULL, NULL)
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
  ('3d94fc18-a0d4-5248-bdc0-32b9f0527b96', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'دارة مختلطة: مصباح L1 بالتسلسل مع مجموعة من مصباحَين L2 وL3 مركّبَين بالتفرّع بينهما. توتّر المولّد 9 V، وقِيس توتّر L1 فكان 4 V. ما التوتّر بين طرفَي L2؟', '[{"id":"a","text":"4 V"},{"id":"b","text":"9 V"},{"id":"c","text":"5 V"},{"id":"d","text":"2,5 V"}]'::jsonb, 'c', 'L1 بالتسلسل مع مجموعة التفرّع، فتوتّر المولّد يوزَّع بينهما: U(المجموعة) = 9 − 4 = 5 V. وبما أنّ L2 وL3 بالتفرّع، فالتوتّر بين طرفَي كلّ منهما يساوي توتّر المجموعة: U(L2) = 5 V.', 4, 'mcq', NULL, NULL)
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
  ('c5f80086-dd58-5f6a-9c54-0d907e854459', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'قال تلميذ: «كي أقيس توتّر مصباح، أفصله عن الدارة وأصل طرفَيه وحدهما بالفولطمتر». ما الحكم؟', '[{"id":"a","text":"صحيح، فهكذا يُقاس التوتّر بدقّة"},{"id":"b","text":"خطأ فقط لأنّه نسي عكس المرابط"},{"id":"c","text":"صحيح لأنّ الفولطمتر يُركَّب دائمًا خارج الدارة"},{"id":"d","text":"خطأ: فصل المصباح يُغيّر حالة الدارة؛ يُقاس التوتّر والمصباح موصول ويعمل، بوصل الفولطمتر بالتفرّع بين طرفَيه"}]'::jsonb, 'd', 'قيس التوتّر يتمّ والمصباح في مكانه يعمل، بوصل الفولطمتر بالتفرّع بين طرفَيه دون فصله. فصل المصباح يفتح الدارة ويُلغي الحالة التي نريد قيسها، فتكون القراءة بلا معنى.', 5, 'mcq', NULL, NULL)
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
  ('7cbe491f-d5f9-5865-8b70-ffe0920de9f7', 'eb085b0e-3166-59c3-9e33-c4ef45e97440', 'دارة بالتسلسل توتّر مولّدها 12 V، بها ثلاثة مستقبلات توتّراتها U1 وU2 وU3، علمًا أنّ U1 = U2 وأنّ U3 = 4 V. ما قيمة U1؟', '[{"id":"a","text":"8 V"},{"id":"b","text":"4 V"},{"id":"c","text":"2 V"},{"id":"d","text":"6 V"}]'::jsonb, 'b', 'في التسلسل: U1 + U2 + U3 = 12، ومع U1 = U2 وU3 = 4 نحصل على 2·U1 + 4 = 12، فـ 2·U1 = 8 ومنه U1 = 4 V. القيمة 8 V هي مجموع U1 وU2 معًا لا قيمة U1 وحده.', 6, 'mcq', NULL, NULL)
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
      AND e.subject_id = 'sciences-physiques-8eme'
      AND e.source = 'admin';
  END IF;
END $$;

