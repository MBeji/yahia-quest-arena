-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-b2 (Français — Intermédiaire avancé (B2 · DELF B2))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-b2/
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
  ('francais-b2', 'Français — Intermédiaire avancé (B2 · DELF B2)', 'Atteins l''autonomie avancée : maîtrise la voix passive, le subjonctif passé et ses emplois avancés, l''expression de la cause, la conséquence, le but, l''opposition et la concession, les pronoms relatifs composés, le gérondif et le participe présent, le vocabulaire de l''opinion et du débat, et la compréhension de textes argumentatifs. Niveau intermédiaire avancé (CECRL B2), aligné sur le DELF B2.', 'Agilité', 'subject-french', 'Languages', 4, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-b2'
      AND e.source = 'admin'
      AND q.id NOT IN ('d3cbacd5-5d95-5a54-bfb8-e0b64d60e72d', 'c0fed68e-42e5-5e2f-8f3e-cf10ccd66227', '35e5e594-2b72-5b10-9a87-a4ec567c6757', '8cb83048-068f-5b53-bca7-2031661d743a', '4f68ddf8-e98e-56c7-815b-64aa1645f1fe', '92748b00-290e-57f9-b2e7-9059ebe50171', '612261cb-e21a-5558-97a2-8536f17810a3', '8684dac1-099a-5a11-ad96-74de23d6a393', '5166e681-88af-5397-9f58-926f8d867f10', '2a170fb4-48a3-506e-93d6-218d856173f9', '0802191f-e4bf-5716-a693-5ce61a697773', '08a88c15-76ad-5192-a1f9-38461562934a', '792c145d-00f5-5926-86fd-05781ce6407a', '46daf019-995a-5f6d-9ef8-f2391d92b768', '94b3fefa-2aaf-5faa-b4b4-8086387ec677', 'dca2f6ca-9e89-5785-ab14-296b4a254a90', '6bd1122b-8b39-557b-a3bd-23c1dd64432e', '5bea9c2b-251e-58ac-91d6-f72984bf4591', '0b8febd7-c23e-5328-81ed-ae7add545c61', '21cfb950-5286-5c1e-aed2-6157d3b0e78b', 'c368616f-f7e3-5081-aecc-e23a6de6ae27', '56393432-0511-5333-bbf0-5c36916502e7', '14c19d54-1297-585b-a2f0-998522862403', '25052778-30a1-5187-a70b-bc8f2e810fa5', '42b8a38f-3a78-5d54-b083-bb62980932d4', 'd69190b6-eb11-5c1d-80e9-611290742781', 'cad54213-01ad-5c13-ae72-9c1c68d8dd1d', '8b51d39e-f235-593e-b2cd-69660216b2ea', '83bb012c-5dd6-5b5d-b053-8e64d3cf11e7', 'f8a251c8-6ee3-5027-bd1e-15ca85c552b4', '4edac505-b0a6-5585-bb8d-85b3f3605c2e', 'b8163e4b-3d16-50b3-b42e-e554c8392c16', 'ce9ccf41-c873-585c-8c68-51c5f8d14a3e', 'a8199572-41da-56d4-b06e-6af3b29913ef', 'b60b0aa0-d69c-504e-a955-ff987165385b', '8d9e1c97-7b5d-51d8-a137-b51b1f159d66', 'be8d5286-009b-5ac1-aec2-268d175a2394', '84b28989-6163-594f-b8f0-88c7d4e2facd', '33674c1c-e508-583c-8eac-500770d3e6e8', '67ec44d8-18dd-5d27-b769-1731619f9d14', '3d0f0f46-67cd-544a-8a1e-3f016d260f4f', 'a4030df4-3003-57e2-8a38-9b8028403420', '536a3724-b9b9-550f-88dd-7c789ccca30c', '814c401a-977f-5fd4-b80c-2f7bf25d3c5b', 'aed59985-17f8-5f6f-975a-38d76be99d29', 'da24c131-0482-59b4-8ff0-d4ea01ab71c8', 'd08985cc-f855-51bf-acf3-face8f97af6a', '0f2cf850-e02f-5125-895a-57a03d0f2f43', 'cf898c93-3355-537a-88a7-2029232eb11f', '29a49cf9-1a05-546d-868a-57059cac58fb', '59d55131-ae0a-5769-a73f-fb3761c8aee0', '87f97da2-42b0-5065-a0e9-27c6a233d89c', 'fe6121ee-74ef-590a-9e40-e74e3dd10c9b', '5b4df701-7e11-5bd7-b2cb-eaf15526c15f', '04089efb-8c33-5ea0-a4d1-4914e08ee186', 'f9b260b1-bcba-5060-929b-cc56977b846f', '907f00a0-2d29-5d01-b083-8588fd435757', 'f39e08af-186d-5519-86c5-9932b8bb9bc3', '58d93a80-a035-5b28-ac68-8d56a6a272c4', 'f4951492-5d81-577c-a920-60521cdf8c71', '4f393fdc-3672-576b-a959-d8dd8c01c643', '83452cf0-0a14-55db-a581-6b6dcc9b83dd', '95da0f1b-d08a-589d-9c91-087f629dae04', '3929342d-8adc-5ae5-8e73-6a6ef11c4061', '0c6577bc-d9a8-5a3e-9fba-840e1ce3f3d0', 'bf1c31d9-d0d8-545f-9241-2277f50807bf', '730207d1-f9cd-5fb1-b4e1-52c35af018db', '4f764cc3-19c4-5587-a4fa-5cb3e76aaea1', '8d8f24a3-8339-5f9c-8a47-bced4b35e5fe', '60ce5256-c523-5817-819f-78f682e8d20e', 'b5ca8918-72cc-5ee3-b6dd-bcae02f6bf90', '4efa4823-dfcb-5c5d-984a-c6907dcab94b', '802a7323-a072-5585-8aac-a2eea28e048f', '6aad5e23-378a-53f7-9ff6-926518c6b7b3', '5f627e33-15a7-59a8-8e15-ddaebaf3bfb1', 'a6fc904d-2712-5f77-a8a7-7e68fdd9d2bb', '42ef1c82-0e4c-53c1-a893-6aaeef1db091', '34eb058f-0964-5fc3-903d-19f249265b67', '437bf2bb-e4ba-5349-8b56-c25ef3fe012a', '3986534c-d85d-5a47-a43b-e5b948cf22c3', '496ced50-dae6-5a6a-a1e6-e7bc2f5d702e', 'b245e22f-c016-5e60-bd22-78e3b8a5ec9a', '7151d6d3-8662-5567-91e0-84d291af351f', 'd6a7523c-8d00-5f51-86e3-9b4db89a30d3', '454a1679-187d-5a15-a3a0-970ca7ebf881', '90151351-2da3-593f-91f9-74aeeacb1444', 'fd32723b-988e-52b6-b798-389bdff94b6f', 'e15e5f72-58a0-58ca-996d-5ba89c87d571', '4de3d740-47b9-500f-9f63-10bcc258a412', '441d792c-be6e-511c-b150-40ac080d4120', '504e893b-af7e-5268-afc9-b622613e8654', '2bb643aa-76d2-5201-b2f9-0416da26f4b2', 'b2bb905f-b0d4-5d25-b77a-d929d21e7a9c', 'cc349f38-eee6-5ed4-ac64-671c8868b1ba', '160e19fc-e086-58c7-bb55-fd80b1c4ec81', '95466827-f160-5b79-aaf7-17aa03a08db3', '18ad233d-ea03-5255-9f01-a7b403713294', 'f6d774a8-e7b0-5151-991c-615a84da466a', '921d8f08-0971-5d3b-86ec-23599e42b643', '1beeb09e-5228-5c7d-927f-3917be849af4', '9b1fbfc7-59b3-5508-bec7-a0710157eea6', 'fa5087ed-cd43-5670-9f3c-4db6a490744d', 'd9613bc6-b5ec-5e2f-a0af-6c2a9a2e510e', 'ccfaa651-daa8-511a-bff2-74bd40942344', '881277db-9c38-53b9-97f6-1da854e878b9', 'f555ccea-bb84-5b96-b8d7-54df979583ec', '63d18b5d-1c22-57a7-857a-bbb8aa9434bb', 'cfbef0fb-500f-5eef-9f89-e61bcbae7c31', 'b95459fd-c20c-592b-954e-45ee7e590e42', '62c0d8b1-3da2-5876-866a-0a7c83c44f3b', '9bede61b-1f61-5757-9f76-6bf07e291f14', 'a2e657c0-75d9-5d90-9b05-52c6eafc4e2c', 'ca9e04d6-bdc8-57cb-93e2-e1816f2e4048', 'fd918a33-eef5-5a85-bce3-c69655dac396', '4a0c00e0-0b10-5ce9-97a5-f372e6c3c0a1', '0ec82fde-d43b-5d6c-adae-733173ce6e18', 'bcb4506b-476e-5fb9-acda-8695b48695b2', '59bf4fd0-314e-5be2-bd0c-ad151472fa5f', 'cb01bbb8-a77e-5719-a592-e80ddcf0cca0', '2dc5e1b3-7423-5e0e-ad8d-810e46fd93ba', 'c958e294-ac12-5f97-9425-b0103452af0f', '02d090cb-7703-5812-857d-ae025a2fd98a', '3788d7c7-4ff1-508c-a763-fdae4145a471', '669bde6f-6372-5e33-986e-d2f88e2cfed6', 'e63b5a2c-366f-5cc0-91b4-4b5a25612fe0', '5de26c68-9d9c-5236-851c-62c0f1669523', '0a0d0d6d-abaa-5e6e-a1a3-9c30bc8fa984', 'a6ef7c58-3bb2-5bde-8e3e-a86590fe5db4', 'b7696313-82c8-5fb4-aa4f-f1003db13032', 'b13f5009-51c4-58ef-92d5-195057b88874', 'd0f7ee4a-153b-54b7-9b68-6aebe113938e', '0ac38ad5-6285-54c0-84c0-a94459926048', '00a0506c-e35f-5dd5-84a8-669f833b1697', '6d263e49-3375-5fdf-8cd1-d8841b07084b', 'd543d1f6-525e-5244-a3b4-a62b9c0dd961', '2b1af8ea-424e-5007-9764-9a5083b33b1c', 'cbdd9c1f-933f-5564-8431-0d6d50c60b5b', '4ee379cb-408e-5aca-ae45-a2b16f1098c7', '6dd39785-8161-52c9-afa0-e3dfb1281b07', 'e9d7b466-7ea0-5559-b03e-54d62b5e8564', 'afe1b298-7994-52cf-b143-3fba3e3ce564', '5acf0b68-8b26-5064-9f12-1a2374156200', '3c76be11-47c0-5e7b-8e4f-e420247a226d', 'd50d442b-7c36-5fbc-811c-b744dae91971', '44bde482-3c08-5156-af3d-f48689e4f293', 'bd0b58ff-d025-5394-b12d-6cb2c0103ef9', '26cc604e-e3d5-5046-b25e-208554e2e4a1', '3bad32e8-38ec-5513-9a2e-5fc6b4b858b7', 'a58a6e46-c3dd-5a79-9e94-a3b0a2d67e40', 'c473681c-3940-51e2-bf2b-f4477bc41b92', 'deba50ac-2dcb-5965-8da2-93aa4367f9e5', '47c386cc-4768-54d1-8916-112d12a14994', '3182459f-3998-52d7-8428-14e9a61c0985', '6a6aee27-c53d-58dd-bb2b-06b88d455ecd', '79d6abf6-c22b-5408-842e-7a993d376052', 'd3e6b36c-a853-5e1e-a1c7-77f36041cb8d', '95964cae-0d91-5f05-883d-97e628a41d9e', '8290c0d0-3d37-53d4-84aa-b177e67b9839', 'b43aa562-fb8c-5ed3-a690-3bb3661401bf', 'b2e869d3-f02d-52c5-ba8a-9a46b14aab14', '3e442c61-53a8-5076-be74-0412f059d457', 'a8830f07-6180-505c-9102-e09a04b69b52', '19bbfca2-9aa5-5157-98e0-40b7214453e0', '701203ba-1ad9-52b4-bfb1-9cf11e7f85f7', 'ad12e383-d581-5377-a876-bf8a7265a7a8', '498bf81f-d4a8-50a4-ab47-8f4025088d8c', '4e417fdb-fd10-5c01-90a4-e3464bca1229', 'db96b6ba-e96d-5110-bf3a-6680ced262f4', '547e68ab-8874-5142-b8a0-330b2311740d', '2ad8ac2b-3d71-58c1-8415-9220cc56d99a', '1856efd6-786e-5b50-8b71-5de02f73551d', 'b7339b58-ed22-5ec6-b09b-622d345cc35e', '4a3ba236-0176-5d61-be62-8b4bf2de8e9e', '6df860c2-ac7e-5255-a3f7-f839a7f711aa', '329f9936-9cba-5a5e-b184-aeab6c186ccc', '359206d8-7628-589b-882e-bd12be974f57', '5467d07b-0e86-50b5-ae62-37a8b1688cf9', '535fb9d4-7134-51bb-b94c-5238d81d7f8a', '2eae7464-d1f0-5926-9358-345f7bf48762', 'f88494f1-c57f-5e4c-8d24-9b2f862a6406', '5f7ffe26-473d-5f83-affa-9497f9649df7', '6a128097-d29d-5abe-8a62-931ffde33af1', 'a94bdf24-2720-5d7e-b181-81c960948d24', '8b3bbc7d-d48f-5188-ae41-5601656267f5', 'c66db4d6-8ec6-5913-9c66-f95fd36e47b0', '3d4be76e-bfdc-5034-a983-2e89a2f717b7', '487c3f13-e600-5394-9364-2ddc8e602d3c', '6a426d47-d848-587f-9cc2-46954447c6ba', 'a664adf6-7163-5e31-9b7f-cb5f8470be58', '62e6100c-d7c7-5575-9246-fb48afd8d22b', 'fda1679a-b725-5dd5-ac09-2d6507a28947', 'eda5f1c7-9898-5c24-9158-3f0d0bb99b7d', '7f0627bc-3563-511a-812f-0c6fe4a5376c', 'ace8f2f9-8edd-51c6-a97c-9448c9960da1', '5e89503d-9b38-5532-a2ea-95a8805e6dc8', 'e97c52ef-cb87-545e-9472-766105102f6e', 'b029cf20-fab2-5f8a-abab-c6fbb34b1db1', '046bfe89-df29-5278-9e96-1f13e1282c48', '9dcc4ebc-6785-50d6-9252-087da8909ddf', '025bb3ed-d1d4-58e1-b433-06560ac2376c', '1e039a32-2eda-5df4-ac2f-029b39305262', '27d31263-6c20-5960-9947-4838d0aeac6d', '94c6cd6c-a9f2-5bde-b7eb-493ac4a22ce0', 'ea5e1016-730a-566f-a828-6d7cfbae291d', '5d866374-bf66-5c55-bb1c-54dadb29dfef', '97dc6686-b429-523a-8df4-d9f0142d47a5', '4c6d44c1-853f-574b-8471-9d4f33602649', 'c1573cc3-dd21-510b-8de6-0da3a00bc644', '96888519-567a-5569-8bd8-deb156b72454', '5a9bcd2a-f5cf-558d-aa2f-54520987fe6e', '615fca08-c918-5dba-b0f1-14e596902fd0', '4009fd1a-02d2-59e8-94d4-51571aa457c2', 'c5f8a131-363d-53a2-963a-f30e8e848530', 'a92cf033-4c4b-55fd-9f8e-c423174c89c0', 'fdd3d48b-944f-5d30-8608-f8cd466d1765', '447f9f8f-7379-51fb-ae22-7ceab470feb8', 'f7fe3c6f-65f1-5c74-9807-569cbebdd004', '98de6419-e1f4-5394-a99a-80a3581432e1', '01ea5b2e-216e-5db0-887b-107698c48234', 'adae746a-d599-57c7-91d9-5c85b1c07fa7', '46e5f336-1895-5a26-ab34-2c7e9ec87e66', 'dddfeb8b-86a9-5301-bc48-f5bd37e04530', 'b47ddafa-8937-5fdd-bcd3-3e858e8c33ae', 'd265cbdc-9632-5ecb-8888-032167028c49', '41ad74c8-4ed9-5a94-9c28-ef3040198569', '33527e1d-f277-512f-b297-78df2934f639', '955e1f30-216c-515a-9af3-e74ebae838f1', '02572e1b-c6ed-5afc-9829-30e4df69cc9a', 'b9f7a259-6515-5cb9-ac4e-a9dd3427b1b2', '07002426-7e84-5b6b-843d-ed72ca23d644', '17165391-181b-5240-92a7-89b751ea115d', 'b2617868-a707-56e7-9ddc-4e09f3e57174', '6adcc2bc-36c1-54be-b407-69aa3c2ed739', 'afa51f2c-ab4e-5c30-90a1-5bc6c208c0ac', '9cc1727f-8f38-5a75-8695-2161cbd1928c', 'ab628f0c-b3e0-52c9-abe4-eb9c7bbb865c', '2f8ddc0d-e8a2-543d-8f10-d05d03265d42', '6964e943-f0e4-5342-8731-8a2eaa9e030e', '64253699-602a-5ab5-af61-c977f7a6759c', 'cae7422a-6289-54ca-bbdc-8c8fc39c95b8', '302a34dd-4b61-5858-bba4-9a4315d058fa', '36f4a476-d88c-58ed-a721-64519b6f0328', '78332cfb-0cea-5a60-91a2-89aa6761a625', 'a1e8181b-ea18-50f4-b838-1e51c1118cec', '0d0a1b39-f0dc-5038-a2c2-3bdc2f693fe2', '23aba99d-d7cb-53cf-aa33-4f56776f55df', 'c20d04c2-70b7-5198-b5f9-e0fb05a50a7b', '5c4929cb-aa87-5c4a-b842-8324fd804179', '201c6d5f-3c2f-5d37-a919-2f8b3ed2f222', '9175245d-a8ad-5cc7-a0a1-4839d623b891', 'f0709fa4-b689-5014-9942-662b7e6da89c', 'ab3cda70-840e-5c11-a271-a0a4ec35ee5e', 'e9980c69-61d3-5c78-ac80-998b3ba3be92', 'f892dcd1-8711-509a-bc87-0805272c97c9', '90349fb6-6e89-5fc1-ae5d-8daf97ff6cfc', 'da8a7e82-b599-5aa5-8d0e-197f47e35767', 'c5fa98c2-7ac7-57d0-99f6-4963fbd328b7', '7c15eb40-9944-5153-bbbb-c27526806cdc', 'cfa0edf8-d53c-551f-baf1-2b86786c0415', '958ebc19-c1c0-59f1-b7f7-69a4d398af42', 'efaf276e-41b5-50a6-b06f-389997993d35', '92c9a27b-c4e9-517b-a302-a71582170d60', 'fc6f8898-1df4-519f-9af3-0503cc112044', '3f68ffb6-4d71-52b3-ad07-d16ed596af79', '074cd333-b674-5e18-ba7b-cd553553a1eb', '210aaa23-efca-587f-a174-9495189ed69c', '0d65fb17-ad5b-5a59-9e60-06eeb6e12893', '57fe1ac8-64f3-5ea0-aba5-9091ab0f40f3', '464850d0-cfea-585d-ae39-8669fd219201', 'e99ef1f9-2115-590e-928f-f100c8b5e65f', 'a92c35c5-e11e-5113-949f-a7ed92414bb0', 'db479135-0e5b-56b7-ad46-ec811fa6f3d0', 'f779587e-3967-51fa-a8f4-fcb433695c22', '545ecd21-37dd-5146-995e-f0aa2e45ede4', 'e4d77114-52a6-5d30-a251-0e6da9497fc5', '526f44bf-c046-5786-b98c-fcf7bb1d63f4', 'eaa07d89-5a79-5008-825b-cf0d20d30911', '8211a675-f38f-5f50-b3f9-6c26b23d5e11', '0d461361-f124-572f-9f1f-aea0f695eb79', 'fcad836d-8e60-500a-98cf-0321056e75ee');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-b2' AND source = 'admin' AND id NOT IN ('1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', '7ebef735-a9ae-5f78-8223-3faad8297763', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', '02146c8d-795e-54d2-97b7-8f32084b3131', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', '198b1701-98f9-532c-9760-e07ef596bd8b', 'd953eb2e-e6c2-5480-911f-e43924f0309e', '6af4356c-1871-5520-aa06-0ef5e009055f', '1e47a99a-4253-5052-849f-50536e016929', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', '9b5fe8a8-6679-5c24-b152-a4e03a580209', '3abcd171-b909-548d-be87-313b4dd9a9a8', '0616886d-5c59-5428-9177-7919f9b703a0', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', '07e0bb6f-2cae-5349-9507-63abee100a22', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', '3858ed6f-755f-5881-9e51-8b30f788b3f5', '005bb173-521b-5a9c-b35f-b0341d54cf44', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'effaa6a3-6663-5095-a504-5352b2fccefa', '8e242bae-c7d1-5651-a9e8-2c140efd1168', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'ca7a1902-69bb-580a-ba92-48aefe402482', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'df6621cf-8b28-5693-b1ac-5624aff64423', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'cfb43058-c9d7-5e86-9475-40b707d50340', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', '94619014-b090-5f36-9868-d40584d8c779');
DELETE FROM public.questions WHERE exercise_id IN ('1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', '7ebef735-a9ae-5f78-8223-3faad8297763', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', '02146c8d-795e-54d2-97b7-8f32084b3131', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', '198b1701-98f9-532c-9760-e07ef596bd8b', 'd953eb2e-e6c2-5480-911f-e43924f0309e', '6af4356c-1871-5520-aa06-0ef5e009055f', '1e47a99a-4253-5052-849f-50536e016929', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', '9b5fe8a8-6679-5c24-b152-a4e03a580209', '3abcd171-b909-548d-be87-313b4dd9a9a8', '0616886d-5c59-5428-9177-7919f9b703a0', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', '07e0bb6f-2cae-5349-9507-63abee100a22', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', '3858ed6f-755f-5881-9e51-8b30f788b3f5', '005bb173-521b-5a9c-b35f-b0341d54cf44', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'effaa6a3-6663-5095-a504-5352b2fccefa', '8e242bae-c7d1-5651-a9e8-2c140efd1168', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'ca7a1902-69bb-580a-ba92-48aefe402482', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'df6621cf-8b28-5693-b1ac-5624aff64423', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'cfb43058-c9d7-5e86-9475-40b707d50340', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', '94619014-b090-5f36-9868-d40584d8c779') AND id NOT IN ('d3cbacd5-5d95-5a54-bfb8-e0b64d60e72d', 'c0fed68e-42e5-5e2f-8f3e-cf10ccd66227', '35e5e594-2b72-5b10-9a87-a4ec567c6757', '8cb83048-068f-5b53-bca7-2031661d743a', '4f68ddf8-e98e-56c7-815b-64aa1645f1fe', '92748b00-290e-57f9-b2e7-9059ebe50171', '612261cb-e21a-5558-97a2-8536f17810a3', '8684dac1-099a-5a11-ad96-74de23d6a393', '5166e681-88af-5397-9f58-926f8d867f10', '2a170fb4-48a3-506e-93d6-218d856173f9', '0802191f-e4bf-5716-a693-5ce61a697773', '08a88c15-76ad-5192-a1f9-38461562934a', '792c145d-00f5-5926-86fd-05781ce6407a', '46daf019-995a-5f6d-9ef8-f2391d92b768', '94b3fefa-2aaf-5faa-b4b4-8086387ec677', 'dca2f6ca-9e89-5785-ab14-296b4a254a90', '6bd1122b-8b39-557b-a3bd-23c1dd64432e', '5bea9c2b-251e-58ac-91d6-f72984bf4591', '0b8febd7-c23e-5328-81ed-ae7add545c61', '21cfb950-5286-5c1e-aed2-6157d3b0e78b', 'c368616f-f7e3-5081-aecc-e23a6de6ae27', '56393432-0511-5333-bbf0-5c36916502e7', '14c19d54-1297-585b-a2f0-998522862403', '25052778-30a1-5187-a70b-bc8f2e810fa5', '42b8a38f-3a78-5d54-b083-bb62980932d4', 'd69190b6-eb11-5c1d-80e9-611290742781', 'cad54213-01ad-5c13-ae72-9c1c68d8dd1d', '8b51d39e-f235-593e-b2cd-69660216b2ea', '83bb012c-5dd6-5b5d-b053-8e64d3cf11e7', 'f8a251c8-6ee3-5027-bd1e-15ca85c552b4', '4edac505-b0a6-5585-bb8d-85b3f3605c2e', 'b8163e4b-3d16-50b3-b42e-e554c8392c16', 'ce9ccf41-c873-585c-8c68-51c5f8d14a3e', 'a8199572-41da-56d4-b06e-6af3b29913ef', 'b60b0aa0-d69c-504e-a955-ff987165385b', '8d9e1c97-7b5d-51d8-a137-b51b1f159d66', 'be8d5286-009b-5ac1-aec2-268d175a2394', '84b28989-6163-594f-b8f0-88c7d4e2facd', '33674c1c-e508-583c-8eac-500770d3e6e8', '67ec44d8-18dd-5d27-b769-1731619f9d14', '3d0f0f46-67cd-544a-8a1e-3f016d260f4f', 'a4030df4-3003-57e2-8a38-9b8028403420', '536a3724-b9b9-550f-88dd-7c789ccca30c', '814c401a-977f-5fd4-b80c-2f7bf25d3c5b', 'aed59985-17f8-5f6f-975a-38d76be99d29', 'da24c131-0482-59b4-8ff0-d4ea01ab71c8', 'd08985cc-f855-51bf-acf3-face8f97af6a', '0f2cf850-e02f-5125-895a-57a03d0f2f43', 'cf898c93-3355-537a-88a7-2029232eb11f', '29a49cf9-1a05-546d-868a-57059cac58fb', '59d55131-ae0a-5769-a73f-fb3761c8aee0', '87f97da2-42b0-5065-a0e9-27c6a233d89c', 'fe6121ee-74ef-590a-9e40-e74e3dd10c9b', '5b4df701-7e11-5bd7-b2cb-eaf15526c15f', '04089efb-8c33-5ea0-a4d1-4914e08ee186', 'f9b260b1-bcba-5060-929b-cc56977b846f', '907f00a0-2d29-5d01-b083-8588fd435757', 'f39e08af-186d-5519-86c5-9932b8bb9bc3', '58d93a80-a035-5b28-ac68-8d56a6a272c4', 'f4951492-5d81-577c-a920-60521cdf8c71', '4f393fdc-3672-576b-a959-d8dd8c01c643', '83452cf0-0a14-55db-a581-6b6dcc9b83dd', '95da0f1b-d08a-589d-9c91-087f629dae04', '3929342d-8adc-5ae5-8e73-6a6ef11c4061', '0c6577bc-d9a8-5a3e-9fba-840e1ce3f3d0', 'bf1c31d9-d0d8-545f-9241-2277f50807bf', '730207d1-f9cd-5fb1-b4e1-52c35af018db', '4f764cc3-19c4-5587-a4fa-5cb3e76aaea1', '8d8f24a3-8339-5f9c-8a47-bced4b35e5fe', '60ce5256-c523-5817-819f-78f682e8d20e', 'b5ca8918-72cc-5ee3-b6dd-bcae02f6bf90', '4efa4823-dfcb-5c5d-984a-c6907dcab94b', '802a7323-a072-5585-8aac-a2eea28e048f', '6aad5e23-378a-53f7-9ff6-926518c6b7b3', '5f627e33-15a7-59a8-8e15-ddaebaf3bfb1', 'a6fc904d-2712-5f77-a8a7-7e68fdd9d2bb', '42ef1c82-0e4c-53c1-a893-6aaeef1db091', '34eb058f-0964-5fc3-903d-19f249265b67', '437bf2bb-e4ba-5349-8b56-c25ef3fe012a', '3986534c-d85d-5a47-a43b-e5b948cf22c3', '496ced50-dae6-5a6a-a1e6-e7bc2f5d702e', 'b245e22f-c016-5e60-bd22-78e3b8a5ec9a', '7151d6d3-8662-5567-91e0-84d291af351f', 'd6a7523c-8d00-5f51-86e3-9b4db89a30d3', '454a1679-187d-5a15-a3a0-970ca7ebf881', '90151351-2da3-593f-91f9-74aeeacb1444', 'fd32723b-988e-52b6-b798-389bdff94b6f', 'e15e5f72-58a0-58ca-996d-5ba89c87d571', '4de3d740-47b9-500f-9f63-10bcc258a412', '441d792c-be6e-511c-b150-40ac080d4120', '504e893b-af7e-5268-afc9-b622613e8654', '2bb643aa-76d2-5201-b2f9-0416da26f4b2', 'b2bb905f-b0d4-5d25-b77a-d929d21e7a9c', 'cc349f38-eee6-5ed4-ac64-671c8868b1ba', '160e19fc-e086-58c7-bb55-fd80b1c4ec81', '95466827-f160-5b79-aaf7-17aa03a08db3', '18ad233d-ea03-5255-9f01-a7b403713294', 'f6d774a8-e7b0-5151-991c-615a84da466a', '921d8f08-0971-5d3b-86ec-23599e42b643', '1beeb09e-5228-5c7d-927f-3917be849af4', '9b1fbfc7-59b3-5508-bec7-a0710157eea6', 'fa5087ed-cd43-5670-9f3c-4db6a490744d', 'd9613bc6-b5ec-5e2f-a0af-6c2a9a2e510e', 'ccfaa651-daa8-511a-bff2-74bd40942344', '881277db-9c38-53b9-97f6-1da854e878b9', 'f555ccea-bb84-5b96-b8d7-54df979583ec', '63d18b5d-1c22-57a7-857a-bbb8aa9434bb', 'cfbef0fb-500f-5eef-9f89-e61bcbae7c31', 'b95459fd-c20c-592b-954e-45ee7e590e42', '62c0d8b1-3da2-5876-866a-0a7c83c44f3b', '9bede61b-1f61-5757-9f76-6bf07e291f14', 'a2e657c0-75d9-5d90-9b05-52c6eafc4e2c', 'ca9e04d6-bdc8-57cb-93e2-e1816f2e4048', 'fd918a33-eef5-5a85-bce3-c69655dac396', '4a0c00e0-0b10-5ce9-97a5-f372e6c3c0a1', '0ec82fde-d43b-5d6c-adae-733173ce6e18', 'bcb4506b-476e-5fb9-acda-8695b48695b2', '59bf4fd0-314e-5be2-bd0c-ad151472fa5f', 'cb01bbb8-a77e-5719-a592-e80ddcf0cca0', '2dc5e1b3-7423-5e0e-ad8d-810e46fd93ba', 'c958e294-ac12-5f97-9425-b0103452af0f', '02d090cb-7703-5812-857d-ae025a2fd98a', '3788d7c7-4ff1-508c-a763-fdae4145a471', '669bde6f-6372-5e33-986e-d2f88e2cfed6', 'e63b5a2c-366f-5cc0-91b4-4b5a25612fe0', '5de26c68-9d9c-5236-851c-62c0f1669523', '0a0d0d6d-abaa-5e6e-a1a3-9c30bc8fa984', 'a6ef7c58-3bb2-5bde-8e3e-a86590fe5db4', 'b7696313-82c8-5fb4-aa4f-f1003db13032', 'b13f5009-51c4-58ef-92d5-195057b88874', 'd0f7ee4a-153b-54b7-9b68-6aebe113938e', '0ac38ad5-6285-54c0-84c0-a94459926048', '00a0506c-e35f-5dd5-84a8-669f833b1697', '6d263e49-3375-5fdf-8cd1-d8841b07084b', 'd543d1f6-525e-5244-a3b4-a62b9c0dd961', '2b1af8ea-424e-5007-9764-9a5083b33b1c', 'cbdd9c1f-933f-5564-8431-0d6d50c60b5b', '4ee379cb-408e-5aca-ae45-a2b16f1098c7', '6dd39785-8161-52c9-afa0-e3dfb1281b07', 'e9d7b466-7ea0-5559-b03e-54d62b5e8564', 'afe1b298-7994-52cf-b143-3fba3e3ce564', '5acf0b68-8b26-5064-9f12-1a2374156200', '3c76be11-47c0-5e7b-8e4f-e420247a226d', 'd50d442b-7c36-5fbc-811c-b744dae91971', '44bde482-3c08-5156-af3d-f48689e4f293', 'bd0b58ff-d025-5394-b12d-6cb2c0103ef9', '26cc604e-e3d5-5046-b25e-208554e2e4a1', '3bad32e8-38ec-5513-9a2e-5fc6b4b858b7', 'a58a6e46-c3dd-5a79-9e94-a3b0a2d67e40', 'c473681c-3940-51e2-bf2b-f4477bc41b92', 'deba50ac-2dcb-5965-8da2-93aa4367f9e5', '47c386cc-4768-54d1-8916-112d12a14994', '3182459f-3998-52d7-8428-14e9a61c0985', '6a6aee27-c53d-58dd-bb2b-06b88d455ecd', '79d6abf6-c22b-5408-842e-7a993d376052', 'd3e6b36c-a853-5e1e-a1c7-77f36041cb8d', '95964cae-0d91-5f05-883d-97e628a41d9e', '8290c0d0-3d37-53d4-84aa-b177e67b9839', 'b43aa562-fb8c-5ed3-a690-3bb3661401bf', 'b2e869d3-f02d-52c5-ba8a-9a46b14aab14', '3e442c61-53a8-5076-be74-0412f059d457', 'a8830f07-6180-505c-9102-e09a04b69b52', '19bbfca2-9aa5-5157-98e0-40b7214453e0', '701203ba-1ad9-52b4-bfb1-9cf11e7f85f7', 'ad12e383-d581-5377-a876-bf8a7265a7a8', '498bf81f-d4a8-50a4-ab47-8f4025088d8c', '4e417fdb-fd10-5c01-90a4-e3464bca1229', 'db96b6ba-e96d-5110-bf3a-6680ced262f4', '547e68ab-8874-5142-b8a0-330b2311740d', '2ad8ac2b-3d71-58c1-8415-9220cc56d99a', '1856efd6-786e-5b50-8b71-5de02f73551d', 'b7339b58-ed22-5ec6-b09b-622d345cc35e', '4a3ba236-0176-5d61-be62-8b4bf2de8e9e', '6df860c2-ac7e-5255-a3f7-f839a7f711aa', '329f9936-9cba-5a5e-b184-aeab6c186ccc', '359206d8-7628-589b-882e-bd12be974f57', '5467d07b-0e86-50b5-ae62-37a8b1688cf9', '535fb9d4-7134-51bb-b94c-5238d81d7f8a', '2eae7464-d1f0-5926-9358-345f7bf48762', 'f88494f1-c57f-5e4c-8d24-9b2f862a6406', '5f7ffe26-473d-5f83-affa-9497f9649df7', '6a128097-d29d-5abe-8a62-931ffde33af1', 'a94bdf24-2720-5d7e-b181-81c960948d24', '8b3bbc7d-d48f-5188-ae41-5601656267f5', 'c66db4d6-8ec6-5913-9c66-f95fd36e47b0', '3d4be76e-bfdc-5034-a983-2e89a2f717b7', '487c3f13-e600-5394-9364-2ddc8e602d3c', '6a426d47-d848-587f-9cc2-46954447c6ba', 'a664adf6-7163-5e31-9b7f-cb5f8470be58', '62e6100c-d7c7-5575-9246-fb48afd8d22b', 'fda1679a-b725-5dd5-ac09-2d6507a28947', 'eda5f1c7-9898-5c24-9158-3f0d0bb99b7d', '7f0627bc-3563-511a-812f-0c6fe4a5376c', 'ace8f2f9-8edd-51c6-a97c-9448c9960da1', '5e89503d-9b38-5532-a2ea-95a8805e6dc8', 'e97c52ef-cb87-545e-9472-766105102f6e', 'b029cf20-fab2-5f8a-abab-c6fbb34b1db1', '046bfe89-df29-5278-9e96-1f13e1282c48', '9dcc4ebc-6785-50d6-9252-087da8909ddf', '025bb3ed-d1d4-58e1-b433-06560ac2376c', '1e039a32-2eda-5df4-ac2f-029b39305262', '27d31263-6c20-5960-9947-4838d0aeac6d', '94c6cd6c-a9f2-5bde-b7eb-493ac4a22ce0', 'ea5e1016-730a-566f-a828-6d7cfbae291d', '5d866374-bf66-5c55-bb1c-54dadb29dfef', '97dc6686-b429-523a-8df4-d9f0142d47a5', '4c6d44c1-853f-574b-8471-9d4f33602649', 'c1573cc3-dd21-510b-8de6-0da3a00bc644', '96888519-567a-5569-8bd8-deb156b72454', '5a9bcd2a-f5cf-558d-aa2f-54520987fe6e', '615fca08-c918-5dba-b0f1-14e596902fd0', '4009fd1a-02d2-59e8-94d4-51571aa457c2', 'c5f8a131-363d-53a2-963a-f30e8e848530', 'a92cf033-4c4b-55fd-9f8e-c423174c89c0', 'fdd3d48b-944f-5d30-8608-f8cd466d1765', '447f9f8f-7379-51fb-ae22-7ceab470feb8', 'f7fe3c6f-65f1-5c74-9807-569cbebdd004', '98de6419-e1f4-5394-a99a-80a3581432e1', '01ea5b2e-216e-5db0-887b-107698c48234', 'adae746a-d599-57c7-91d9-5c85b1c07fa7', '46e5f336-1895-5a26-ab34-2c7e9ec87e66', 'dddfeb8b-86a9-5301-bc48-f5bd37e04530', 'b47ddafa-8937-5fdd-bcd3-3e858e8c33ae', 'd265cbdc-9632-5ecb-8888-032167028c49', '41ad74c8-4ed9-5a94-9c28-ef3040198569', '33527e1d-f277-512f-b297-78df2934f639', '955e1f30-216c-515a-9af3-e74ebae838f1', '02572e1b-c6ed-5afc-9829-30e4df69cc9a', 'b9f7a259-6515-5cb9-ac4e-a9dd3427b1b2', '07002426-7e84-5b6b-843d-ed72ca23d644', '17165391-181b-5240-92a7-89b751ea115d', 'b2617868-a707-56e7-9ddc-4e09f3e57174', '6adcc2bc-36c1-54be-b407-69aa3c2ed739', 'afa51f2c-ab4e-5c30-90a1-5bc6c208c0ac', '9cc1727f-8f38-5a75-8695-2161cbd1928c', 'ab628f0c-b3e0-52c9-abe4-eb9c7bbb865c', '2f8ddc0d-e8a2-543d-8f10-d05d03265d42', '6964e943-f0e4-5342-8731-8a2eaa9e030e', '64253699-602a-5ab5-af61-c977f7a6759c', 'cae7422a-6289-54ca-bbdc-8c8fc39c95b8', '302a34dd-4b61-5858-bba4-9a4315d058fa', '36f4a476-d88c-58ed-a721-64519b6f0328', '78332cfb-0cea-5a60-91a2-89aa6761a625', 'a1e8181b-ea18-50f4-b838-1e51c1118cec', '0d0a1b39-f0dc-5038-a2c2-3bdc2f693fe2', '23aba99d-d7cb-53cf-aa33-4f56776f55df', 'c20d04c2-70b7-5198-b5f9-e0fb05a50a7b', '5c4929cb-aa87-5c4a-b842-8324fd804179', '201c6d5f-3c2f-5d37-a919-2f8b3ed2f222', '9175245d-a8ad-5cc7-a0a1-4839d623b891', 'f0709fa4-b689-5014-9942-662b7e6da89c', 'ab3cda70-840e-5c11-a271-a0a4ec35ee5e', 'e9980c69-61d3-5c78-ac80-998b3ba3be92', 'f892dcd1-8711-509a-bc87-0805272c97c9', '90349fb6-6e89-5fc1-ae5d-8daf97ff6cfc', 'da8a7e82-b599-5aa5-8d0e-197f47e35767', 'c5fa98c2-7ac7-57d0-99f6-4963fbd328b7', '7c15eb40-9944-5153-bbbb-c27526806cdc', 'cfa0edf8-d53c-551f-baf1-2b86786c0415', '958ebc19-c1c0-59f1-b7f7-69a4d398af42', 'efaf276e-41b5-50a6-b06f-389997993d35', '92c9a27b-c4e9-517b-a302-a71582170d60', 'fc6f8898-1df4-519f-9af3-0503cc112044', '3f68ffb6-4d71-52b3-ad07-d16ed596af79', '074cd333-b674-5e18-ba7b-cd553553a1eb', '210aaa23-efca-587f-a174-9495189ed69c', '0d65fb17-ad5b-5a59-9e60-06eeb6e12893', '57fe1ac8-64f3-5ea0-aba5-9091ab0f40f3', '464850d0-cfea-585d-ae39-8669fd219201', 'e99ef1f9-2115-590e-928f-f100c8b5e65f', 'a92c35c5-e11e-5113-949f-a7ed92414bb0', 'db479135-0e5b-56b7-ad46-ec811fa6f3d0', 'f779587e-3967-51fa-a8f4-fcb433695c22', '545ecd21-37dd-5146-995e-f0aa2e45ede4', 'e4d77114-52a6-5d30-a251-0e6da9497fc5', '526f44bf-c046-5786-b98c-fcf7bb1d63f4', 'eaa07d89-5a79-5008-825b-cf0d20d30911', '8211a675-f38f-5f50-b3f9-6c26b23d5e11', '0d461361-f124-572f-9f1f-aea0f695eb79', 'fcad836d-8e60-500a-98cf-0321056e75ee');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-b2' AND c.id NOT IN ('28369603-0cce-5a38-95a4-b2cefdade397', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', 'La voix passive', 'Déplace le projecteur de l''auteur de l''action vers celui qui la subit : transforme l''actif en passif, conjugue l''auxiliaire être à tous les temps avec un participe passé qui s''accorde, distingue le complément d''agent introduit par par ou par de, repère les verbes qui ne peuvent pas se mettre au passif, et exploite les alternatives (on, se faire + infinitif, passif pronominal).', '# ⚔️ La voix passive — Déplace le projecteur

> 💡 «À la voix active, le héros agit. À la voix passive, c''est le monde qui réagit à lui. Apprends à retourner la phrase comme un gant : ce qui subissait l''action devient le centre du récit.»

---

## 🏰 1. De l''actif au passif : le grand retournement

À la **voix active**, le sujet fait l''action. À la **voix passive**, le sujet **subit** l''action. La transformation suit toujours la même mécanique :

- le **COD** de la phrase active devient le **sujet** de la phrase passive ;
- le **sujet** de la phrase active devient le **complément d''agent** ;
- le verbe se met à l''auxiliaire **être** + **participe passé**.

> _Le chat **mange** la souris._ (actif) → _La souris **est mangée** par le chat._ (passif)

| Élément actif     | Devient au passif                  |
| ----------------- | ---------------------------------- |
| sujet (_le chat_) | complément d''agent (_par le chat_) |
| verbe (_mange_)   | être + participe (_est mangée_)    |
| COD (_la souris_) | sujet (_la souris_)                |

> 🗡️ Astuce : avant de transformer, repère le COD de la phrase active. Pas de COD → pas de passif (voir §4).

---

## ⚡ 2. La formation : être conjugué + participe passé qui s''accorde

Le passif se construit **toujours** avec l''auxiliaire **être**. Deux règles d''or :

1. **être** se met au **temps de la phrase active** (c''est lui qui porte le temps) ;
2. le **participe passé s''accorde** avec le sujet (genre et nombre), comme un adjectif.

$$ sujet + être (au temps voulu) + participe passé accordé (+ par/de + agent) $$

> _La lettre **est écrite**._ · _Les maisons **ont été construites**._ · _La porte **sera fermée**._

> ⚠️ Piège n°1 : l''accord du participe. Avec le passif, on accorde **toujours** avec le sujet → _Les maisons **sont construites**_ (jamais _~~sont construit~~_). C''est l''erreur la plus fréquente.

---

## 🔮 3. Le passif à tous les temps

Seul l''auxiliaire **être** change de temps ; le participe passé, lui, ne bouge pas (il s''accorde seulement). Compare avec l''actif _faire_ → passif _être fait_ :

| Temps                | Actif (faire) | Passif (être fait)    |
| -------------------- | ------------- | --------------------- |
| **présent**          | on fait       | c''est **fait**        |
| **imparfait**        | on faisait    | c''était **fait**      |
| **futur simple**     | on fera       | ce sera **fait**      |
| **passé composé**    | on a fait     | ça **a été fait**     |
| **plus-que-parfait** | on avait fait | ça **avait été fait** |

Remarque : au passé composé et au plus-que-parfait, on a **deux** participes — celui de _être_ (été) puis celui du verbe (fait) : _a **été** **fait**_, _avait **été** **fait**_.

> _Hier, la salle **était décorée**._ (imparfait) · _Demain, le prix **sera remis**._ (futur) · _Le pont **a été inauguré** en 1889._ (passé composé)

---

## 🛡️ 4. Seuls les verbes transitifs directs se mettent au passif

Un verbe ne peut devenir passif **que s''il possède un COD** à l''actif : ce sont les **verbes transitifs directs**.

- _construire **une maison**_ → _une maison **est construite**_ ✓ (transitif direct)
- _téléphoner **à un ami**_ → impossible ✗ (téléphoner est transitif **indirect** : _à_ un ami)
- _partir, dormir, arriver_ → impossible ✗ (verbes **intransitifs**, sans complément d''objet)

| Verbe actif       | Type               | Passif possible ?              |
| ----------------- | ------------------ | ------------------------------ |
| _peindre un mur_  | transitif direct   | ✓ _le mur est peint_           |
| _obéir à un chef_ | transitif indirect | ✗ (_~~est obéi~~_)             |
| _tomber_          | intransitif        | ✗ (_~~est tombé est passif~~_) |

> ⚠️ Piège n°2 : _La voiture est tombée_ n''est **pas** un passif — c''est le passé composé actif de _tomber_ (verbe de mouvement avec auxiliaire être). Pour reconnaître un vrai passif, demande-toi : « par qui ? ». _Tombée par qui ?_ n''a aucun sens → ce n''est pas un passif.

---

## 🧪 5. Le complément d''agent : PAR ou DE ?

L''agent (celui qui fait l''action) est le plus souvent introduit par **par**. Mais certains verbes — surtout les verbes d''**état**, de **description** ou de **sentiment** — préfèrent **de**.

| Introduit par **par** (action concrète) | Introduit par **de** (état, sentiment, description) |
| --------------------------------------- | --------------------------------------------------- |
| _détruit **par** la tempête_            | _connu **de** tous_                                 |
| _écrit **par** l''auteur_                | _aimé **de** ses élèves_                            |
| _réparé **par** le mécanicien_          | _suivi **de** son chien_ · _entouré **de** champs_  |

> _Ce savant est respecté **de** tous._ · _Le toit a été arraché **par** le vent._

L''agent peut d''ailleurs être **omis** quand il est inconnu ou évident : _Le musée **a été cambriolé**._ (par qui ? on ne sait pas).

> 🗡️ Mémo : retiens la liste des « **de** » courants — **connu de, aimé de, suivi de, entouré de, accompagné de, respecté de, précédé de, couvert de**.

---

## 🌀 6. Les alternatives au passif

Le français passif est plus lourd qu''en anglais ; à l''oral, on lui préfère souvent trois tournures plus naturelles :

| Alternative              | Quand l''employer                           | Exemple                                 |
| ------------------------ | ------------------------------------------ | --------------------------------------- |
| **on** + verbe actif     | agent inconnu ou général                   | _**On** a volé ma voiture._             |
| **se faire** + infinitif | quand le sujet subit (souvent désagréable) | _Il **s''est fait** renverser._          |
| **passif pronominal**    | vérité générale, usage, vente              | _Ça **se vend** bien. · Ça **se dit**._ |

> _On m''a offert ce livre._ (= ce livre m''a été offert) · _Elle s''est fait gronder._ (= elle a été grondée) · _Ce plat **se mange** froid._

> 🏆 Porte franchie ! Tu sais retourner une phrase, conjuguer le passif à tous les temps, accorder le participe, choisir entre **par** et **de**, écarter les verbes intransitifs et dégainer les alternatives. Prochaine étape : le **subjonctif passé** et ses emplois avancés.', '# 📜 Résumé : La voix passive

- **Transformation actif → passif :** le COD devient sujet, le sujet devient complément d''agent ; le verbe passe à _être + participe passé_. _Le chat mange la souris → La souris est mangée par le chat._
- **Formation :** auxiliaire **être** conjugué au temps de la phrase active + participe passé qui **s''accorde** avec le sujet. _Les maisons ont été construites._
- **Tous les temps :** seul _être_ change de temps — présent : _est fait_ ; imparfait : _était fait_ ; futur : _sera fait_ ; passé composé : _a été fait_ ; plus-que-parfait : _avait été fait_.
- **Verbes possibles :** seuls les **transitifs directs** (qui ont un COD) se mettent au passif ; jamais un verbe intransitif (_tomber, partir_) ni transitif indirect (_obéir à_).
- **Complément d''agent :** introduit par **par** (action) ou par **de** pour les verbes d''état/sentiment (_connu de, aimé de, suivi de, entouré de_) ; il peut être omis.
- **Alternatives :** **on** + actif (_on a volé ma voiture_), **se faire** + infinitif (_il s''est fait renverser_), passif **pronominal** (_ça se vend bien_).
- **Piège n°1 :** ne jamais oublier l''accord du participe avec le sujet. **Piège n°2 :** _est tombé_ n''est pas un passif mais un passé composé actif (test : « par qui ? »).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', 'Le subjonctif passé et les emplois avancés du subjonctif', 'Forme et emploie le subjonctif passé (que j''aie fini, qu''elle soit partie), choisis entre subjonctif présent et passé selon l''antériorité, et maîtrise les emplois avancés : après un superlatif ou « le seul / le premier / le dernier », après les conjonctions (bien que, sans que, à moins que, avant que, pour que) et dans les relatives de but ou de souhait.', '# ⚔️ Le subjonctif passé et ses emplois avancés — Le mode du déjà-accompli

> 💡 «Tu sais déjà former le subjonctif présent. Au niveau B2, tu apprends à dire qu''une action redoutée, souhaitée ou jugée est _déjà arrivée_ — et à dégainer le subjonctif là où le débutant met l''indicatif.»

## 🏰 Rappel express : le subjonctif présent

Tu maîtrises (niveau B1) la formation du subjonctif présent et le duel **indicatif / subjonctif** des opinions (_je pense qu''il **a** raison_ mais _je ne pense pas qu''il **ait** raison_). Ce chapitre ne le répète pas : il l''**étend**. On garde une seule certitude de base — le subjonctif vit dans une subordonnée introduite par **« que »**.

## ⚡ Former le subjonctif passé

Le **subjonctif passé** est un temps **composé**. La recette tient en une ligne :

$$ que + auxiliaire (avoir/être) au subjonctif présent + participe passé $$

Tu connais déjà le subjonctif présent de _avoir_ (_que j''aie…_) et de _être_ (_que je sois…_) : il suffit d''y ajouter le participe passé.

| Pronom       | avec **avoir** (_finir_) | avec **être** (_partir_)      | pronominal (_se lever_)           |
| ------------ | ------------------------ | ----------------------------- | --------------------------------- |
| que je / j''  | que j''**aie** fini       | que je **sois** parti(e)      | que je me **sois** levé(e)        |
| que tu       | que tu **aies** fini     | que tu **sois** parti(e)      | que tu te **sois** levé(e)        |
| qu''il/elle   | qu''il **ait** fini       | qu''elle **soit** partie       | qu''elle se **soit** levée         |
| que nous     | que nous **ayons** fini  | que nous **soyons** parti(e)s | que nous nous **soyons** levé(e)s |
| que vous     | que vous **ayez** fini   | que vous **soyez** parti(e)s  | que vous vous **soyez** levé(e)s  |
| qu''ils/elles | qu''ils **aient** fini    | qu''elles **soient** parties   | qu''ils se **soient** levés        |

> 🗡️ Astuce : le choix de l''auxiliaire et l''**accord du participe** obéissent aux mêmes règles qu''au passé composé. Avec _être_, le participe s''accorde avec le sujet : \*qu''elle soit **partie\***, \*qu''ils soient **venus\***.

> ⚠️ Piège : ne confonds pas le subjonctif (_que j''**aie** fini_) avec l''indicatif (_j''**ai** fini_). À l''oral c''est proche, à l''écrit c''est _aie_, pas _ai_.

## 🔮 Présent ou passé du subjonctif ? Une question de temps

Le subjonctif n''a pas de futur : présent et passé suffisent à situer l''action **par rapport au verbe principal**.

| L''action de la subordonnée est… | Subjonctif  | Exemple                                      |
| ------------------------------- | ----------- | -------------------------------------------- |
| **simultanée ou postérieure**   | **présent** | _Je suis content que tu **viennes** demain._ |
| **antérieure / déjà accomplie** | **passé**   | _Je suis content que tu **sois venu** hier._ |

\*Je doute qu''il **réussisse\*** (l''examen est à venir) → présent.
\*Je doute qu''il **ait réussi\*** (l''examen a déjà eu lieu) → passé.

> 🗡️ Astuce : repère un indice temporel. _Hier, la semaine dernière, déjà_ appellent le **passé** ; _demain, bientôt, maintenant_ appellent le **présent**.

## 🛡️ Emploi avancé : après un superlatif

Après un **superlatif** (_le meilleur, le pire, le plus…_) et après **le seul, le premier, le dernier, l''unique**, la relative se met souvent au **subjonctif** — car on exprime une appréciation, pas un fait neutre.

_C''est le meilleur livre que j''**aie** lu. — C''est la seule personne qui me **comprenne**. — C''est le premier film qui m''**ait** vraiment ému._

> ⚠️ Piège : à l''indicatif (_le meilleur livre que j''**ai** lu_) la phrase n''est pas « fausse », mais le subjonctif est la marque du registre B2/soutenu et exprime la nuance d''appréciation. Sache choisir _aie_, pas _ai_.

## 🧮 Emploi avancé : les conjonctions à subjonctif

Certaines conjonctions imposent **toujours** le subjonctif, même quand le fait paraît réel.

| Conjonction             | Sens              | Exemple                                         |
| ----------------------- | ----------------- | ----------------------------------------------- |
| **bien que / quoique**  | opposition        | _Bien qu''il **soit** riche, il vit simplement._ |
| **pour que / afin que** | but               | _Je répète **pour que** tu **comprennes**._     |
| **avant que**           | antériorité       | _Pars **avant qu''**il (ne) **soit** trop tard._ |
| **à moins que**         | restriction       | _On sort, **à moins qu''**il (ne) **pleuve**._   |
| **sans que**            | sans + résultat   | _Il est sorti **sans que** je le **sache**._    |
| **jusqu''à ce que**      | limite temporelle | _Attends **jusqu''à ce que** je **revienne**._   |

> 🗡️ Astuce : _avant que_ et _à moins que_ admettent un **« ne » explétif** (sans valeur de négation) : _avant qu''il **ne** parte_. Mais attention — _après que_ se construit, lui, avec l''**indicatif** (_après qu''il **est** parti_).

## 🪄 Emploi avancé : la relative de but ou de souhait

Quand la relative décrit un objet **recherché, désiré, hypothétique** (pas encore identifié), elle passe au **subjonctif** ; quand elle décrit un objet **réel et connu**, elle reste à l''**indicatif**.

_Je cherche une maison qui **soit** calme._ (je ne l''ai pas encore trouvée → souhait)
_J''habite une maison qui **est** calme._ (elle existe, je la connais → fait)

> ⚠️ Piège : ne mets pas l''indicatif sous prétexte que la phrase « sonne réelle » : _Je voudrais un guide qui **connaisse** la région_ — c''est un guide souhaité, donc subjonctif (_connaisse_, pas _connaît_).

> 🏆 Porte franchie ! Tu formes le subjonctif passé, tu choisis entre présent et passé selon l''antériorité, et tu dégaines le subjonctif après un superlatif, les bonnes conjonctions et dans une relative de souhait. Prochaine étape : **l''expression de la cause, de la conséquence et du but** pour structurer ton argumentation.', '# 📜 Résumé : Le subjonctif passé et ses emplois avancés

- **Subjonctif passé** = _que_ + auxiliaire (_avoir/être_) au subjonctif présent + participe passé : _que j''**aie** fini, qu''elle **soit** partie, qu''elle se **soit** levée_.
- **Auxiliaire et accord** suivent les règles du passé composé : avec _être_, le participe s''accorde avec le sujet (\*qu''ils soient **venus\***).
- ⚠️ _que j''**aie** fini_ (subjonctif) ≠ _j''**ai** fini_ (indicatif) : à l''écrit, _aie_, pas _ai_.
- **Présent vs passé** : action simultanée/postérieure → présent (_content que tu **viennes** demain_) ; action antérieure/accomplie → passé (_content que tu **sois venu** hier_).
- **Après un superlatif** et après _le seul / le premier / le dernier_ → subjonctif : \*le meilleur livre que j''**aie** lu ; la seule qui me **comprenne\***.
- **Conjonctions à subjonctif** : _bien que, quoique, pour que, afin que, avant que, à moins que, sans que, jusqu''à ce que_ (mais _après que_ → indicatif).
- **« ne » explétif** possible après _avant que_ et _à moins que_ (_avant qu''il **ne** parte_) — il ne nie rien.
- **Relative de but/souhait** → subjonctif (objet recherché : _une maison qui **soit** calme_) ; relative de fait → indicatif (objet réel : _une maison qui **est** calme_).', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', 'La cause, la conséquence et le but', 'Exprime avec précision les relations logiques au niveau B2 : la cause (parce que, car, puisque, comme, à cause de, grâce à, en raison de, étant donné que, faute de), la conséquence (donc, c''est pourquoi, par conséquent, si bien que, tellement/si… que, tant de… que) et le but (pour / afin de + infinitif, pour que / afin que + subjonctif, de peur que, de manière à). Choisis le bon connecteur, le bon mode et la bonne nuance — neutre, positive ou négative.', '# ⚔️ La cause, la conséquence et le but — La chaîne logique du raisonnement

> 💡 «Savoir relier un fait à sa raison, à son effet et à son intention, c''est passer du français qui décrit au français qui argumente. Forge ces connecteurs et ton discours deviendra une arme de persuasion.»

## 🏰 La grande triade logique

Trois questions, trois familles de connecteurs. Au B2, on ne se contente plus de _parce que_ : on choisit le mot juste selon la nuance, la place dans la phrase et la structure (verbe conjugué ou nom).

| Question            | Relation           | Connecteurs phares                                  |
| ------------------- | ------------------ | --------------------------------------------------- |
| **Pourquoi ?**      | la **cause**       | _parce que, car, puisque, comme, grâce à…_          |
| **Et alors ?**      | la **conséquence** | _donc, c''est pourquoi, si bien que, tellement… que_ |
| **Dans quel but ?** | le **but**         | _pour, afin de, pour que, de peur que…_             |

## ⚡ La cause — pourquoi ?

| Connecteur          | Construction               | Nuance / emploi                                           |
| ------------------- | -------------------------- | --------------------------------------------------------- |
| **parce que**       | + proposition (verbe)      | cause neutre, répond à « pourquoi ? »                     |
| **car**             | + proposition (verbe)      | justification, registre soutenu, jamais en tête de phrase |
| **puisque**         | + proposition (verbe)      | cause **déjà connue**, évidente pour l''interlocuteur      |
| **comme**           | + proposition, **en tête** | met la cause en avant, toujours au début                  |
| **à cause de**      | **+ nom**                  | cause **neutre ou négative**                              |
| **grâce à**         | **+ nom**                  | cause **positive** (un résultat heureux)                  |
| **en raison de**    | + nom                      | registre formel, administratif                            |
| **étant donné que** | + proposition (verbe)      | cause posée comme un fait admis                           |
| **faute de**        | + nom (sans article)       | cause = un manque (_faute de temps_)                      |

_Il est resté chez lui **parce qu''**il était malade. — **Puisque** tu connais la réponse, dis-la. — **Comme** il pleuvait, nous sommes restés. — **Grâce à** ton aide, j''ai réussi. — Le vol est annulé **en raison du** brouillard._

> 🗡️ Astuce : **à cause de** et **grâce à** se suivent d''un **nom**, jamais d''un verbe conjugué. La différence est la nuance : _**à cause de** la pluie_ (regret, neutre/négatif) vs _**grâce à** la pluie_ (bénéfice, positif).

> ⚠️ Piège : on ne dit jamais ~~parce que la pluie~~ ! **Parce que** exige un verbe conjugué. Devant un **nom**, on emploie **à cause de / grâce à / en raison de**.

## 🛡️ La conséquence — et alors ?

| Connecteur         | Construction           | Registre                         |
| ------------------ | ---------------------- | -------------------------------- |
| **donc**           | + proposition          | conséquence logique, courant     |
| **alors**          | + proposition          | courant, oral                    |
| **c''est pourquoi** | + proposition, en tête | soutenu, écrit                   |
| **par conséquent** | + proposition, en tête | formel                           |
| **du coup**        | + proposition          | **familier**, oral seulement     |
| **si bien que**    | + proposition (verbe)  | conséquence dans une subordonnée |

_Il pleuvait, **donc** nous sommes restés. — Le train avait du retard, **c''est pourquoi** je suis arrivé en retard. — Il a tout révisé, **si bien qu''**il a eu la meilleure note._

## 🔮 La conséquence d''intensité — tellement / si / tant… que

Pour relier une **intensité** à son effet, on encadre l''élément intense entre un adverbe d''intensité et **que**.

| Structure                                       | S''applique à     | Exemple                                            |
| ----------------------------------------------- | ---------------- | -------------------------------------------------- |
| **si / tellement** + adjectif/adverbe + **que** | qualité, manière | _Il est **si** fatigué **qu''**il dort debout._     |
| **tellement de / tant de** + **nom** + **que**  | quantité         | _Il a **tant de** travail **qu''**il ne dort plus._ |
| verbe + **tellement / tant** + **que**          | un verbe         | _Il a **tant** travaillé **qu''**il a réussi._      |

> 🗡️ Astuce : devant un **adjectif ou un adverbe**, choisis _**si**_ ou _**tellement**_ (jamais _tant_). Devant un **nom**, choisis _**tant de**_ ou _**tellement de**_ (jamais _si_). Devant un **verbe**, choisis _**tant**_ ou _**tellement**_.

## 💎 Le but — dans quel but ?

Le but est une intention, un objectif visé. La règle d''or : **même sujet → infinitif** ; **deux sujets différents → subjonctif**.

| Connecteur                       | Construction     | Condition                           |
| -------------------------------- | ---------------- | ----------------------------------- |
| **pour / afin de**               | **+ infinitif**  | **un seul sujet** (même personne)   |
| **pour que / afin que**          | **+ subjonctif** | **deux sujets** différents          |
| **de peur de / de crainte de**   | + infinitif      | un seul sujet, but négatif (éviter) |
| **de peur que / de crainte que** | + subjonctif     | deux sujets, but négatif            |
| **de manière à / de façon à**    | + infinitif      | but + manière                       |

_Je travaille **pour réussir**._ (même sujet : je travaille / je réussis)
_Je t''explique **pour que** tu **comprennes**._ (sujets différents : je / tu → subjonctif)
_Il chuchote **de peur de** réveiller le bébé. — Il chuchote **de peur que** le bébé **ne se réveille**._

> ⚠️ Piège : on ne dit jamais ~~pour que réussir~~ ni ~~pour que tu comprends~~ ! Après **pour que / afin que**, le verbe est toujours au **subjonctif**, jamais à l''indicatif ni à l''infinitif. Et **pour** + infinitif quand le sujet ne change pas.

> 🗡️ Astuce : le test du sujet. Si la même personne fait les deux actions → _**pour** + infinitif_. Si une personne agit pour qu''une **autre** fasse quelque chose → _**pour que** + subjonctif_.

> 🏆 Porte franchie ! Tu sais désormais nuancer la cause (positif _grâce à_ vs négatif _à cause de_), enchaîner la conséquence (_si bien que_, _tant… que_) et viser un but avec le bon mode (_pour_ + infinitif, _pour que_ + subjonctif). Prochaine étape du DELF B2 : **l''opposition et la concession** pour défendre une thèse face à ses contradicteurs. ⚔️', '# 📜 Résumé : La cause, la conséquence et le but

- **Cause + verbe** — _parce que_ (neutre), _car_ (justification soutenue, jamais en tête), _puisque_ (cause déjà connue), _comme_ (en tête de phrase), _étant donné que_ (fait admis).
- **Cause + nom** — _à cause de_ (neutre/négatif), _grâce à_ (positif, bénéfice), _en raison de_ (formel), _faute de_ (un manque). Jamais ~~parce que + nom~~.
- **Conséquence** — _donc, alors, c''est pourquoi, par conséquent, si bien que_ ; _du coup_ est familier.
- **Conséquence d''intensité** — _si / tellement_ + adjectif/adverbe + _que_ ; _tant de / tellement de_ + nom + _que_ ; verbe + _tant / tellement_ + _que_ (_Il a tant travaillé qu''il a réussi_).
- **But, même sujet** — _pour / afin de / de manière à / de peur de_ + **infinitif** (_je travaille pour réussir_).
- **But, deux sujets** — _pour que / afin que / de peur que_ + **subjonctif** (_je t''explique pour que tu comprennes_).
- ⚠️ Devant un nom : _à cause de / grâce à_, jamais _parce que_.
- ⚠️ Après _pour que / afin que_ : subjonctif, jamais l''indicatif ni l''infinitif.
- ⚠️ _grâce à_ = positif ; _à cause de_ = neutre ou négatif.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', 'L''expression de l''opposition et de la concession', 'Distingue et maîtrise les deux relations logiques voisines : l''opposition (deux faits mis en contraste — mais, par contre, en revanche, alors que / tandis que, au lieu de, contrairement à) et la concession (un obstacle qui n''empêche pas le résultat — bien que / quoique + subjonctif, même si + indicatif, malgré, en dépit de, pourtant, cependant, néanmoins, quand même, avoir beau + infinitif). Choix du mode, registre des connecteurs et fautes classiques. Niveau CECRL B2 / DELF B2.', '# ⚔️ Opposition et concession — Deux armes pour nuancer ta pensée

> 💡 « Opposer, c''est mettre deux mondes côte à côte ; concéder, c''est franchir un obstacle sans s''arrêter. Maîtrise les deux, et ton argumentation devient inébranlable. »

## 🏰 Deux relations voisines, à ne jamais confondre

Au niveau B2, tu dois distinguer deux mécanismes logiques très proches :

- **L''OPPOSITION** met **deux faits en contraste**, sur le même plan. Aucun n''empêche l''autre ; on les compare simplement.
  _Mon frère adore le sport, **alors que** moi je préfère la lecture._
- **LA CONCESSION** présente **un obstacle qui n''empêche pas le résultat attendu**. On dit en somme : « malgré X, on a quand même Y ».
  _**Bien qu''**il pleuve, nous sortons._ (la pluie devrait empêcher la sortie — mais non)

> 🗡️ Test rapide : si tu peux reformuler par « malgré cela / pourtant », c''est de la **concession**. Si tu compares deux situations parallèles, c''est de l''**opposition**.

## ⚡ Les connecteurs d''OPPOSITION

| Connecteur                   | Se construit avec…                                | Exemple                                                        |
| ---------------------------- | ------------------------------------------------- | -------------------------------------------------------------- |
| **mais**                     | proposition (coordination)                        | _Il est riche **mais** malheureux._                            |
| **par contre / en revanche** | proposition (registre soutenu pour _en revanche_) | _Le matin est libre ; **en revanche**, l''après-midi est pris._ |
| **alors que / tandis que**   | **+ INDICATIF**                                   | _Elle dort **alors que** tout le monde travaille._             |
| **au lieu de**               | **+ INFINITIF** (ou + nom)                        | _**Au lieu de** te plaindre, agis._                            |
| **contrairement à**          | **+ NOM / pronom**                                | _**Contrairement à** son frère, il est timide._                |
| **à l''inverse / à l''opposé** | proposition                                       | _Les uns approuvent ; **à l''inverse**, les autres refusent._   |

> ⚠️ Piège : **alors que** et **tandis que** se construisent à l''**indicatif**, jamais au subjonctif. On dit _alors qu''il **part**_, jamais ~~alors qu''il parte~~.

## 🛡️ Les connecteurs de CONCESSION + SUBJONCTIF

Les conjonctions concessives les plus fréquentes exigent le **subjonctif** :

| Conjonction  | Mode requis      | Exemple                                              |
| ------------ | ---------------- | ---------------------------------------------------- |
| **bien que** | **+ SUBJONCTIF** | _**Bien qu''**il **soit** fatigué, il continue._      |
| **quoique**  | **+ SUBJONCTIF** | _**Quoiqu''**elle **ait** peu d''argent, elle voyage._ |

> ⚠️ Piège majeur : ~~bien qu''il **est** fatigué~~ est **faux**. Après **bien que / quoique**, toujours le subjonctif : _bien qu''il **soit**_.

> 🗡️ Ne confonds pas **quoique** (= bien que, concession) avec **quoi que** (en deux mots = « peu importe ce que ») : _**Quoi que** tu dises, je reste._

## 🔮 Concession + INDICATIF : « même si »

**Même si** est la grande exception : elle se construit **toujours à l''indicatif** (jamais subjonctif).

_**Même si** je **suis** fatigué, je finirai ce travail._
_**Même si** tu **avais** raison, je n''agirais pas autrement._ (irréel → imparfait)

> ⚠️ Piège : ~~même si je **sois**~~ est une faute. **Même si** + indicatif, point final.

## 🧮 Concession + NOM : « malgré » et « en dépit de »

Ces deux prépositions introduisent un **nom** (ou un pronom), **jamais une proposition** :

$$ malgré + NOM = en dépit de + NOM $$

_**Malgré** la pluie, ils sont sortis._
_**En dépit de** ses efforts, il a échoué._

> ⚠️ Piège classique : ~~**malgré que**~~ (très critiqué) et ~~malgré qu''il **pleuve**~~ sont à éviter. Pour introduire une proposition, emploie **bien que / quoique + subjonctif** ; pour un nom, **malgré / en dépit de**.

## 🧪 Les adverbes de concession (lien entre deux phrases)

Ces adverbes relient deux phrases (ou deux propositions) déjà complètes ; ils ne changent pas le mode :

| Adverbe                   | Registre         | Exemple                                              |
| ------------------------- | ---------------- | ---------------------------------------------------- |
| **pourtant**              | courant          | _Il a tout révisé ; **pourtant**, il a échoué._      |
| **cependant / toutefois** | soutenu          | _C''est cher ; **cependant**, cela en vaut la peine._ |
| **néanmoins**             | très soutenu     | _Le risque est réel ; **néanmoins**, nous tentons._  |
| **quand même**            | familier/courant | _Il pleut ; je sors **quand même**._                 |

## 🗝️ La structure star de la concession : « avoir beau »

**Avoir beau + INFINITIF** exprime un effort vain : « on a beau faire X, le résultat ne change pas ».

$$ avoir beau + INFINITIF → effort sans effet $$

_Il **a beau** travailler, il échoue toujours._ (= bien qu''il travaille, il échoue)
_Tu **as beau** crier, personne ne t''entendra._

> 🗡️ Astuce : **avoir beau** se place **en tête de proposition**, suivi directement de l''infinitif. Le verbe « avoir » se conjugue au temps voulu (_j''avais beau insister…_).

> 🏆 Quête accomplie ! Tu sais désormais opposer deux idées et franchir tout obstacle logique. Opposition, concession, choix du mode, registre : ton argumentation B2 est prête pour le DELF. Au chapitre suivant, les pronoms relatifs composés t''attendent ! ⚔️', '# 📜 Résumé : L''opposition et la concession

- **Opposition vs concession** — l''opposition met **deux faits en contraste** (parallèles) ; la concession présente **un obstacle qui n''empêche pas** le résultat (« malgré X, quand même Y »).
- **Opposition** — _mais, par contre, en revanche_ (entre propositions) ; **alors que / tandis que + INDICATIF** ; **au lieu de + infinitif** ; **contrairement à + nom** ; _à l''inverse_.
- **Concession + SUBJONCTIF** — **bien que** et **quoique** : _bien qu''il **soit** là_ (jamais ~~bien qu''il est~~).
- **Concession + INDICATIF** — **même si** se construit toujours à l''indicatif : _même si je **suis** fatigué_ (jamais ~~même si je sois~~).
- **Concession + NOM** — **malgré / en dépit de** + nom : _malgré la pluie_. Éviter ~~malgré que~~ ; pour une proposition, utiliser **bien que + subjonctif**.
- **Adverbes concessifs** — _pourtant_ (courant), _cependant, toutefois, néanmoins_ (soutenus), _quand même_ (courant), reliant deux phrases complètes.
- **Avoir beau + INFINITIF** — exprime un effort vain : _Il **a beau** travailler, il échoue_ (= bien qu''il travaille).
- ⚠️ **Pièges clés** — _quoique_ (= bien que) ≠ _quoi que_ (= peu importe ce que) ; _alors que_ jamais au subjonctif ; _malgré_ jamais devant un verbe conjugué.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', 'Les pronoms relatifs composés', 'Passe au niveau supérieur des relatives : emploie lequel, laquelle, lesquels, lesquelles après une préposition (la table sur laquelle…, les outils avec lesquels…), maîtrise les contractions auquel / auxquels / auxquelles avec « à » et duquel / desquels / desquelles avec « de », distingue « qui » et « lequel » pour les personnes, et choisis entre « dont » et « duquel » après une locution prépositionnelle (au milieu duquel, au toit de laquelle).', '# ⚔️ Les pronoms relatifs composés — l''arme des phrases d''élite

> 💡 « Quand une préposition garde la porte de ta relative, c''est _lequel_ qui détient la clé. »

Au niveau B1, tu as forgé tes quatre lames de base : **qui** (sujet), **que** (COD), **où** (lieu/temps) et **dont** (complément en « de »). Elles suffisent au combat rapproché. Mais dès qu''une **préposition** (sur, avec, pour, dans, à côté de…) verrouille la relative, ces lames se brisent. Il te faut alors une arme plus lourde : **les pronoms relatifs composés**. C''est le passage obligé du DELF B2.

## 🏰 La forme de base : lequel et sa famille

Le pronom composé **s''accorde en genre et en nombre** avec son antécédent. Mémorise le tableau — c''est ton grimoire.

| Genre / nombre     | Forme          |
| ------------------ | -------------- |
| Masculin singulier | **lequel**     |
| Féminin singulier  | **laquelle**   |
| Masculin pluriel   | **lesquels**   |
| Féminin pluriel    | **lesquelles** |

On l''emploie **après une préposition**, surtout pour des **choses** :

- _La table **sur laquelle** je travaille est bancale._ (la table = féminin singulier)
- _Les outils **avec lesquels** il répare le moteur sont neufs._ (les outils = masculin pluriel)
- _Le but **pour lequel** il lutte est noble._ (le but = masculin singulier)
- _Les raisons **pour lesquelles** j''ai refusé sont claires._ (les raisons = féminin pluriel)

> 🗡️ Le réflexe gagnant : repère d''abord **la préposition**, puis **accorde** le pronom avec son antécédent. Préposition + accord = pronom composé correct.

## ⚡ Les contractions avec « à »

Quand la préposition est **à**, elle fusionne avec _lequel_ (sauf au féminin singulier). À mémoriser absolument :

| à + …          | Contraction                           | Exemple                                 |
| -------------- | ------------------------------------- | --------------------------------------- |
| à + lequel     | **auquel**                            | _le problème **auquel** je pense_       |
| à + laquelle   | **à laquelle** _(pas de contraction)_ | _la question **à laquelle** je réponds_ |
| à + lesquels   | **auxquels**                          | _les défis **auxquels** il fait face_   |
| à + lesquelles | **auxquelles**                        | _les règles **auxquelles** tu obéis_    |

> ⚠️ Piège classique : **« à lequel » et « à lesquels » n''existent pas**. Toute forme non contractée au masculin ou au pluriel est fausse. Seul le féminin singulier reste séparé : **à laquelle**.

## 🛡️ Les contractions avec « de »

Même mécanique avec la préposition **de** :

| de + …          | Contraction                            | Exemple typique                         |
| --------------- | -------------------------------------- | --------------------------------------- |
| de + lequel     | **duquel**                             | _le sujet au cours **duquel**…_         |
| de + laquelle   | **de laquelle** _(pas de contraction)_ | _la maison au toit **de laquelle**…_    |
| de + lesquels   | **desquels**                           | _les arbres au pied **desquels**…_      |
| de + lesquelles | **desquelles**                         | _les épreuves au terme **desquelles**…_ |

Ces formes apparaissent surtout dans les **locutions prépositionnelles** finissant par « de » : _au milieu de, à côté de, au cours de, au pied de, au terme de, au bout de, près de, loin de…_

- _Le jardin **au milieu duquel** trône une fontaine._
- _Les vacances **au cours desquelles** nous avons fait du ski._

## 🔮 Personnes : « qui » ou « lequel » ?

Après une préposition, pour une **personne**, deux options coexistent — **avec qui** (le plus courant, le plus naturel) ou **avec laquelle / auquel** (plus soutenu) :

- _La collègue **avec qui** je travaille._ = _La collègue **avec laquelle** je travaille._
- _Le directeur **à qui** je m''adresse._ = _Le directeur **auquel** je m''adresse._

> 🗡️ Pour une **chose**, « qui » après préposition est **impossible** : on dit _l''outil **avec lequel** je répare_, jamais _l''outil avec qui_. Réserve « préposition + qui » aux **personnes**.

## 🧮 Le duel décisif : « dont » contre « duquel »

C''est le combat de boss du chapitre. Les deux remplacent un complément en « de », mais ne s''emploient pas dans le même contexte.

| On emploie…               | Quand…                                                                 | Exemple                                                                                               |
| ------------------------- | ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| **dont**                  | « de » **simple** (verbe, adjectif, nom non précédé d''une préposition) | _Le livre **dont** je parle._ / _L''auteur **dont** j''admire le style._                                |
| **duquel** (et variantes) | « de » fait partie d''une **locution prépositionnelle**                 | _La maison au toit **de laquelle** niche une cigogne._ / _Le congrès au cours **duquel** il a parlé._ |

La règle de Grevisse : **« dont » ne peut pas s''employer après une autre préposition ni à l''intérieur d''un groupe prépositionnel**. Dès qu''il y a _au milieu de, à côté de, au cours de…_, « dont » est interdit → on passe à **duquel / de laquelle / desquels / desquelles**.

- ✗ _La table dont je travaille à côté._ → ✓ _La table **à côté de laquelle** je travaille._
- ✗ _Le pont dont nous sommes passés en dessous._ → ✓ _Le pont **en dessous duquel** nous sommes passés._

> ⚠️ Piège courant : confondre _parler **de** quelque chose_ (« de » simple → **dont**) et _au cours **de** quelque chose_ (locution → **duquel**). Demande-toi toujours : le « de » est-il seul, ou enfermé dans une locution ?

> 🏆 Première porte franchie : tu manies désormais _lequel_, ses contractions et l''arbitrage _dont_ / _duquel_. Tes phrases gagnent en précision et en élégance — exactement ce qu''attend le jury du DELF B2. Au chapitre suivant, le gérondif et le participe présent t''attendent. En garde !', '# 📜 Résumé : Les pronoms relatifs composés

- **Forme de base** : _lequel, laquelle, lesquels, lesquelles_ s''emploient après une préposition (sur, avec, pour, dans…), surtout pour des choses, et s''accordent en genre et en nombre avec l''antécédent.
- **Contractions avec « à »** : à + lequel → **auquel**, à + lesquels → **auxquels**, à + lesquelles → **auxquelles** ; mais **à laquelle** ne se contracte pas.
- **Contractions avec « de »** : de + lequel → **duquel**, de + lesquels → **desquels**, de + lesquelles → **desquelles** ; mais **de laquelle** ne se contracte pas — surtout dans les locutions (_au milieu de, au cours de_).
- **Personnes** après préposition : _avec qui_ (courant) ou _avec laquelle / auquel_ (soutenu) ; pour une **chose**, « qui » est impossible (_l''outil avec lequel_).
- **« dont » vs « duquel »** : « dont » reprend un « de » **simple** (parler de, fier de, le sens de) ; **« duquel »** s''emploie quand le « de » est dans une **locution prépositionnelle** (_au toit de laquelle, au cours duquel_).
- **Piège majeur** : « dont » est interdit après une autre préposition ou dans un groupe prépositionnel → on passe alors à _duquel / de laquelle_.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', 'Le gérondif et le participe présent', 'Maîtrise les formes en -ant : forme le participe présent, distingue-le du gérondif (en + -ant) et de l''adjectif verbal qui s''accorde. Exprime la simultanéité, la cause, la manière, le moyen et la condition, et évite les pièges classiques du niveau B2 (sujet du gérondif, « en » oublié, accord fautif).', '# ⚔️ Le gérondif et le participe présent — La magie des formes en -ant

> 💡 «Une seule terminaison, trois pouvoirs. Sache lequel invoquer, et tes phrases gagneront en fluidité et en précision.»

---

## 🏰 1. La porte d''entrée : trois formes en -ant

Au niveau B2, tu rencontres trois formes qui se terminent toutes par **-ant** mais qui ne jouent pas le même rôle :

- le **participe présent** : _parlant_, _finissant_, _ayant_ ;
- le **gérondif** : _en parlant_, _en finissant_, _en ayant_ ;
- l''**adjectif verbal** : _fatigant_, _négligent_, _convaincant_.

Les confondre, c''est le piège classique du DELF B2. Ce chapitre te donne la clé pour les distinguer.

---

## ⚡ 2. La formation : radical de « nous » + -ANT

Pour former le participe présent, pars du présent à la **1re personne du pluriel** (« nous »), retire la terminaison **-ons**, et ajoute **-ant**.

| Verbe   | Présent (nous)     | Radical | Participe présent |
| ------- | ------------------ | ------- | ----------------- |
| parler  | nous **parlons**   | parl-   | **parlant**       |
| finir   | nous finiss**ons** | finiss- | **finissant**     |
| prendre | nous pren**ons**   | pren-   | **prenant**       |
| faire   | nous fais**ons**   | fais-   | **faisant**       |

> 🗡️ Astuce : cette règle marche pour presque tous les verbes. Il n''existe que **trois irréguliers** à mémoriser.

| Verbe  | Participe présent |
| ------ | ----------------- |
| être   | **étant**         |
| avoir  | **ayant**         |
| savoir | **sachant**       |

---

## 🛡️ 3. Le participe présent : INVARIABLE

Le participe présent est une forme **verbale** : il ne s''accorde jamais, ni en genre ni en nombre. Il exprime une action **simultanée** ou une **cause**, et équivaut souvent à une proposition relative.

- Simultanéité / cause : _**Étant** malade, il est resté chez lui._ (= comme il était malade)
- Équivalent d''une relative : _Les candidats **parlant** trois langues sont prioritaires._ (= qui parlent)

Remarque : _parlant_ reste invariable même devant un nom pluriel — c''est un verbe, pas un adjectif.

> ⚠️ Piège : ne confonds pas _des étudiants **parlant** anglais_ (participe présent, invariable, action) avec _des étudiants **parlants**_ — cette dernière forme n''existe pas.

---

## 🔮 4. Le gérondif : EN + participe présent

Le gérondif, c''est **en** + participe présent : _en parlant_, _en travaillant_, _en partant_. Il exprime trois nuances.

| Valeur          | Exemple                                                 |
| --------------- | ------------------------------------------------------- |
| Simultanéité    | _Il chante **en travaillant**._ (en même temps)         |
| Manière / moyen | _Il a réussi **en travaillant** dur._ (grâce à cela)    |
| Condition       | _**En partant** tôt, tu éviteras les bouchons._ (si tu) |

> 🗡️ Règle d''or : le gérondif a **toujours le même sujet** que le verbe principal. _Il chante en travaillant_ = c''est **lui** qui chante et qui travaille.

> ⚠️ Piège : si les deux sujets diffèrent, le gérondif est **fautif**. ❌ _En entrant, le téléphone a sonné_ (ce n''est pas le téléphone qui entre). ✅ _Quand je suis entré, le téléphone a sonné._

---

## 🧮 5. L''adjectif verbal : il S''ACCORDE

L''adjectif verbal a la même origine que le participe présent, mais il est devenu un **adjectif** : il décrit une qualité et **s''accorde** en genre et en nombre.

- Participe présent (invariable, verbe) : _Une histoire **fatiguant** les enfants._ (= qui fatigue)
- Adjectif verbal (variable, qualité) : _Une histoire **fatigante**._ — _Des arguments **convaincants**._

> 🗡️ Test : si tu peux remplacer la forme par une relative « qui + verbe », c''est un **participe présent** (invariable). Si tu peux la remplacer par un autre adjectif (_pénible_, _solide_), c''est un **adjectif verbal** (accordé).

---

## 🧪 6. Orthographe : participe présent ≠ adjectif verbal

Pour certains verbes, l''adjectif verbal change même d''orthographe par rapport au participe présent. À connaître absolument au B2.

| Participe présent (invariable) | Adjectif verbal (accordé) |
| ------------------------------ | ------------------------- |
| fatigu**ant**                  | fatig**ant**(e)           |
| différ**ant**                  | différ**ent**(e)          |
| provoqu**ant**                 | provoc**ant**(e)          |
| néglige**ant**                 | néglig**ent**(e)          |
| communiqu**ant**               | communic**ant**(e)        |

_Les deux trains **différant** d''une minute…_ (participe présent) → _Ils ont des prix **différents**._ (adjectif verbal).

> 🏆 Chapitre maîtrisé ! Tu sais désormais forger, distinguer et employer les trois formes en -ant. C''est un marqueur fort du niveau B2 : tes phrases deviennent plus denses et plus élégantes. La quête continue — au prochain donjon !', '# 📜 Résumé : Le gérondif et le participe présent

- **Formation** — radical de « nous » au présent + **-ant** : nous parlons → _parlant_, nous finissons → _finissant_, nous prenons → _prenant_.
- **Irréguliers** — être → _étant_, avoir → _ayant_, savoir → _sachant_.
- **Participe présent** (_faisant_) — **invariable** ; exprime une action simultanée ou une cause ; équivaut souvent à une relative (_les candidats parlant trois langues_ = qui parlent).
- **Gérondif** (_en_ + participe présent) — simultanéité (_il chante en travaillant_), manière/moyen (_il a réussi en travaillant dur_), condition (_en partant tôt, tu éviteras les bouchons_).
- **Règle d''or du gérondif** — il a **le même sujet** que le verbe principal ; sinon il est fautif.
- **Adjectif verbal** — **variable**, il s''accorde (_une histoire fatigante, des arguments convaincants_), parfois avec une orthographe différente : _fatigant/fatiguant_, _différent/différant_, _provocant/provoquant_, _négligent/négligeant_.
- ⚠️ **Pièges B2** — gérondif sans « en », sujet différent du verbe principal, accord erroné du participe présent (qui reste invariable).', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', 'Vocabulaire B2 : opinions, débat et idées abstraites', 'Passe à l''argumentation autonome : exprime et nuance une opinion (affirmer, soutenir, concéder, réfuter), maîtrise le lexique du débat (un argument, une objection, un enjeu, un consensus), les articulateurs du discours (en revanche, par ailleurs, certes… mais), les idées abstraites (la liberté, l''éthique, une conviction) et les paronymes piégeux du niveau B2 (compréhensif/compréhensible, éminent/imminent, notable/notoire). Niveau intermédiaire avancé (CECRL B2), aligné sur le DELF B2.', '# ⚔️ Opinions, débat et idées abstraites — L''art de défendre sa thèse

> 💡 «Au niveau B2, on ne se contente plus de dire si l''on est d''accord : on argumente, on nuance, on concède, on réfute. Le mot juste devient ton arme.»

## 🏰 Pourquoi ce chapitre

En A2 et B1, tu disais simplement _je suis d''accord_ ou _je ne suis pas d''accord_. Au niveau **B2**, l''examen du DELF te demande de **développer un point de vue argumenté** : poser une thèse, l''étayer, anticiper les objections, puis conclure. Cela exige un lexique précis — et la capacité de **nuancer** au lieu d''affirmer brutalement. Ce chapitre te donne les verbes, les expressions et les articulateurs qui font la différence entre un avis et une véritable argumentation.

## ⚡ Exprimer et défendre une opinion

Sortir de _je pense que_ : voici les verbes d''opinion du niveau B2, du plus neutre au plus engagé.

| Verbe         | Sens précis                                               | Exemple                                        |
| ------------- | --------------------------------------------------------- | ---------------------------------------------- |
| **affirmer**  | déclarer avec assurance, sans preuve nécessaire           | _Il **affirme** que la réforme est utile._     |
| **soutenir**  | défendre une idée, la maintenir contre l''opposition       | _Elle **soutient** que le climat change vite._ |
| **prétendre** | affirmer une chose douteuse ou non prouvée                | _Il **prétend** avoir tout lu — j''en doute._   |
| **démontrer** | prouver par un raisonnement ou des faits                  | _L''étude **démontre** un lien clair._          |
| **souligner** | mettre en avant un point important                        | _Je **souligne** l''urgence du problème._       |
| **nuancer**   | rendre une affirmation moins absolue, plus mesurée        | _Je **nuance** : ce n''est pas toujours vrai._  |
| **admettre**  | reconnaître qu''une chose est vraie (souvent à contrecœur) | _J''**admets** que l''argument a du poids._      |

> 🗡️ Astuce : **prétendre** est presque toujours teinté de méfiance (« il prétend que… mais »). Ne l''emploie jamais comme un simple synonyme neutre d''_affirmer_.

Pour t''engager, utilise ces **expressions d''opinion** soutenues :

- _à mon sens_, _selon moi_, _de mon point de vue_ (introduire un avis)
- _il me semble que_, _j''ai le sentiment que_ (avis nuancé, prudent)
- _je suis convaincu(e) que_, _je suis persuadé(e) que_ (conviction forte)
- _force est de constater que_ (constat qu''on ne peut nier)

## 🛡️ Concéder puis réfuter : le mouvement gagnant

Une bonne argumentation **reconnaît l''autre camp** avant de le dépasser. Deux verbes clés :

| Verbe        | Sens                                          | Exemple                                       |
| ------------ | --------------------------------------------- | --------------------------------------------- |
| **concéder** | accorder un point à l''adversaire (concession) | _Je **concède** que le coût est élevé, mais…_ |
| **réfuter**  | démontrer qu''un argument est faux             | _Cette objection est facile à **réfuter**._   |

> 🗡️ Le schéma DELF : **certes** [concession] **… mais** [ta thèse]. _Certes, la mesure coûte cher ; mais elle sauve des vies._ On **concède** d''abord, on **réfute** ensuite.

## 🔮 Le lexique du débat

| Mot                 | Sens précis                                    |
| ------------------- | ---------------------------------------------- |
| **un argument**     | une raison avancée pour appuyer une thèse      |
| **une objection**   | une raison opposée à une thèse                 |
| **un point de vue** | la position, la perspective d''une personne     |
| **un enjeu**        | ce qui est en jeu, l''importance d''une question |
| **une polémique**   | une dispute publique et vive                   |
| **un consensus**    | un accord général entre les parties            |

Verbes du débat : **convaincre** (amener par la raison à croire), **persuader** (amener à agir, souvent par l''émotion), **défendre une thèse**, **remettre en cause** (contester, mettre en doute). Collocations soutenues : _prendre position_, _faire valoir un argument_, _peser le pour et le contre_, _tirer une conclusion_, _nuancer son propos_.

> ⚠️ Piège : **convaincre** vise la _raison_ (on est convaincu **que** quelque chose est vrai) ; **persuader** vise l''_action_ (on est persuadé **de** faire quelque chose). On _convainc de la vérité_, on _persuade d''agir_.

## 🧮 Les articulateurs du discours

Ils structurent ton raisonnement. Choisis-les selon la **fonction logique** voulue :

| Articulateur                 | Fonction                                    |
| ---------------------------- | ------------------------------------------- |
| **en effet**                 | confirmer, justifier ce qu''on vient de dire |
| **par ailleurs**             | ajouter un argument supplémentaire          |
| **en revanche**              | marquer une opposition forte                |
| **d''une part… d''autre part** | présenter deux aspects                      |
| **certes… mais**             | concéder puis réfuter                       |
| **en somme**                 | résumer, conclure                           |

> ⚠️ Piège : **en effet** ≠ _en fait_. _En effet_ confirme (« il pleut ; en effet, le ciel est noir ») ; _en fait_ rectifie ou nuance (« je pensais venir ; en fait, je ne peux pas »).

## 🧪 Idées abstraites et paronymes B2

Le débat porte sur des **idées abstraites** : _la liberté_, _l''égalité_, _la justice_, _le progrès_, _l''éthique_ (la morale, les principes), _une valeur_, _une conviction_ (croyance profonde), _une cause_ (un combat qu''on défend).

Surtout, le niveau B2 traque les **paronymes** — des mots proches par la forme mais distincts par le sens :

| Paronymes                         | Distinction                                                                                          |
| --------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **compréhensif / compréhensible** | _compréhensif_ = indulgent (une personne) ; _compréhensible_ = clair, qui se comprend                |
| **éminent / imminent**            | _éminent_ = remarquable, supérieur ; _imminent_ = qui va arriver très bientôt                        |
| **notable / notoire**             | _notable_ = digne d''être noté ; _notoire_ = connu de tous (souvent en mal)                           |
| **conséquent / important**        | _conséquent_ = logique, cohérent ; (familier abusif : « gros ») ; préfère _important_ pour la taille |
| **susceptible / capable**         | _susceptible de_ = qui peut éventuellement ; _capable de_ = qui a la capacité                        |
| **original / originel**           | _original_ = nouveau, inédit ; _originel_ = des origines, premier                                    |

> 🗡️ Astuce : _davantage_ (= plus) ≠ _d''avantage(s)_ (= de bénéfices). _Travaille davantage_ (plus), mais _cela présente bien des avantages_ (des bénéfices).

> 🏆 Porte franchie ! Tu possèdes désormais l''arsenal du débatteur B2 : tu sais affirmer, nuancer, concéder et réfuter, et tu ne confonds plus _éminent_ et _imminent_. Au chapitre suivant, tu mettras ce lexique au service de la compréhension de textes argumentatifs.', '# 📜 Résumé : Vocabulaire B2 — opinions, débat et idées abstraites

- **Exprimer une opinion** : _affirmer_ (déclarer), _soutenir_ (défendre une idée), _prétendre_ (affirmer sans preuve, méfiance), _démontrer_ (prouver), _souligner_ (mettre en avant), _nuancer_ (rendre moins absolu).
- **Expressions d''opinion** : _à mon sens_, _selon moi_, _il me semble que_, _je suis convaincu que_, _force est de constater que_.
- **Concéder puis réfuter** : _admettre / concéder_ un point (_certes…_), puis _réfuter_ l''argument adverse (_… mais_). C''est le mouvement gagnant du DELF B2.
- **Le débat** : _un argument_ ↔ _une objection_, _un point de vue_, _un enjeu_, _une polémique_ ↔ _un consensus_ ; _convaincre_ (la raison) ≠ _persuader_ (l''action) ; _remettre en cause_.
- **Articulateurs** : _en effet_ (confirme), _par ailleurs_ (ajoute), _en revanche_ (oppose), _d''une part… d''autre part_, _en somme_ (conclut). ⚠️ _en effet_ ≠ _en fait_ (rectifie).
- **Idées abstraites** : _la liberté_, _l''égalité_, _la justice_, _l''éthique_, _une valeur_, _une conviction_, _une cause_.
- **Paronymes B2** : _compréhensif_ (indulgent) ≠ _compréhensible_ (clair) ; _éminent_ (remarquable) ≠ _imminent_ (très proche) ; _notable_ (à noter) ≠ _notoire_ (connu de tous) ; _susceptible de_ (peut) ≠ _capable de_ (sait) ; _original_ (inédit) ≠ _originel_ (des origines).
- **Collocations soutenues** : _prendre position_, _faire valoir un argument_, _peser le pour et le contre_, _tirer une conclusion_, _nuancer son propos_. ⚠️ _davantage_ (plus) ≠ _d''avantages_ (de bénéfices).', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', 'Compréhension écrite : argumentation, ton et implicite', 'Décode les textes argumentatifs longs du niveau B2 — éditoriaux, tribunes, essais, critiques, courriers des lecteurs — en repérant la thèse et la structure du raisonnement, en distinguant les points de vue, en détectant l''ironie et le sous-entendu, en pratiquant l''inférence contrôlée et en saisissant le sens figuré d''une expression en contexte.', '# 📖 Compréhension écrite : argumentation, ton et implicite

> 💡 «Au niveau B2, le vrai sens d''un texte est rarement écrit en toutes lettres : il se déduit du ton, de l''ironie et de ce que l''auteur choisit de ne pas dire.»

Bienvenue à la Haute Porte des Textes, héros. Ici, les adversaires ne crient plus : ils **insinuent**. Un éditorialiste feint d''approuver pour mieux démolir, un essayiste glisse une concession pour désarmer son lecteur, une tribune cache sa thèse sous une question rhétorique. Pour franchir cette porte, tu dois lire **entre les lignes** : repérer la thèse derrière les détours, distinguer les voix qui s''affrontent, démasquer l''ironie et inférer le non-dit **sans jamais sur-interpréter**.

## 🏰 Les genres argumentatifs au niveau B2

Au DELF B2, les textes sont longs et **engagés** : l''auteur défend une position et cherche à te convaincre.

| Genre                     | Ce que c''est                                  | Indice de reconnaissance              |
| ------------------------- | --------------------------------------------- | ------------------------------------- |
| **Éditorial / tribune**   | prise de position d''un journal ou d''un auteur | « il est temps de… », « on nous dit » |
| **Article de fond**       | enquête approfondie, plusieurs points de vue  | données, témoignages contrastés       |
| **Essai**                 | réflexion personnelle argumentée              | « je », nuances, hypothèses           |
| **Critique argumentée**   | jugement raisonné d''une œuvre                 | éloge ou réquisitoire motivé          |
| **Courrier des lecteurs** | réaction d''un lecteur à un article            | « en réponse à votre article… »       |
| **Texte d''opinion**       | défense ouverte d''une thèse                   | impératifs, questions rhétoriques     |

## ⚡ Stratégie 1 — Repérer la thèse et les articulateurs

La **thèse** est la position que l''auteur veut te faire admettre. Au B2 elle est souvent **différée** : annoncée prudemment, puis affirmée en fin de texte.

> 🗡️ Astuce : suis les **articulateurs logiques**, ce sont les panneaux du raisonnement. _Certes… mais_ annonce une concession suivie de la vraie thèse ; _or_ introduit un retournement ; _en somme_ signale la conclusion.

| Relation        | Articulateurs B2                                         |
| --------------- | -------------------------------------------------------- |
| **Concession**  | certes… mais, bien que, quand bien même, il est vrai que |
| **Opposition**  | or, en revanche, à l''inverse, loin de                    |
| **Cause**       | car, dans la mesure où, étant donné que                  |
| **Conséquence** | aussi, partant, dès lors, de sorte que                   |
| **Conclusion**  | en somme, force est de constater, au fond                |

## 🔮 Stratégie 2 — Distinguer les points de vue (les voix)

Un texte B2 fait souvent **dialoguer plusieurs voix** : celle de l''auteur, celle d''un adversaire qu''il cite pour le réfuter, celle de l''opinion commune (« on dit que… »).

> ⚠️ Piège : ne confonds pas une opinion **rapportée pour être combattue** avec la thèse de l''auteur. Après « on prétend que… » ou « certains affirment… », guette le _mais_ qui annonce la riposte.

- L''**argument** soutient la thèse ; le **contre-argument** est l''objection adverse, souvent citée puis démontée.
- Repère qui parle : un verbe comme _admettre, concéder_ marque une concession ; _déplorer, fustiger_ marque l''attaque.

## 🛡️ Stratégie 3 — Détecter l''ironie et l''implicite

L''**ironie** consiste à dire le contraire de ce qu''on pense, pour critiquer. Le **sous-entendu** laisse deviner sans affirmer.

> 🗡️ Astuce : l''ironie se trahit par un **décalage** — un éloge appuyé démenti par les faits, des guillemets de distance (« nos brillants experts »), une exagération absurde, une juxtaposition cruelle.

_« Quelle merveilleuse réforme : trois ans plus tard, les files d''attente n''ont jamais été aussi longues. »_ → l''éloge « merveilleuse » est contredit par les faits : l''auteur **critique** la réforme.

## 🧭 Stratégie 4 — Fait, opinion, hypothèse

- Un **fait** est vérifiable : _« Le chômage a baissé de 2 % en 2023. »_
- Une **opinion** est un jugement : _« Cette politique est un échec. »_
- Une **hypothèse** est une supposition prudente, marquée par le conditionnel ou _peut-être, sans doute, il se pourrait que_ : _« La réforme aurait aggravé les inégalités. »_

> ⚠️ Piège : une **conclusion tirée d''un chiffre** n''est pas un fait. « Les ventes ont chuté » (fait) → « donc le produit est mauvais » (opinion). Le conditionnel (_aurait, serait_) signale presque toujours une hypothèse, pas une certitude.

## 🧪 Stratégie 5 — L''inférence contrôlée et le sens figuré

**Inférer**, c''est déduire ce qui n''est pas écrit — mais **uniquement à partir du texte**, jamais de ta culture générale.

> ⚔️ Exemple travaillé — démonte le piège
>
> Texte : _« On nous vante sans relâche les vertus du télétravail : autonomie, sérénité, fin des transports harassants. Soit. Mais derrière cette belle vitrine, combien de salariés isolés, joignables à toute heure, dont le salon est devenu un bureau qui ne ferme jamais ? La frontière entre vie privée et travail, jadis nette, s''est dissoute comme un sucre dans l''eau. »_
>
> **Q : Quelle est la thèse de l''auteur ?**
> L''ouverture (« On nous vante ») rapporte l''opinion commune ; le « Mais » qui suit annonce la riposte. La vraie thèse est **critique** : le télétravail efface la frontière vie privée/travail, au détriment du salarié. ✓ (Choisir « le télétravail apporte autonomie et sérénité » serait prendre la voix adverse pour celle de l''auteur — le piège classique.)
>
> **Q : Que signifie « cette belle vitrine » ?**
> _Vitrine_ = une image flatteuse mais trompeuse ; l''adjectif ironique « belle » et le « derrière » qui suit révèlent une **façade** masquant une réalité moins reluisante. (Pas « un magasin » : le sens est ici **figuré**.)
>
> **Q : « s''est dissoute comme un sucre dans l''eau » — quel est l''effet de cette image ?**
> La comparaison souligne une disparition **progressive et irréversible** de la frontière : elle rend l''idée concrète et frappante. ✓

## 🧙 Stratégie 6 — L''élimination raisonnée

Quand tu hésites entre deux réponses proches, traque le défaut :

1. Barre la **sur-interprétation** : une option qui va plus loin que le texte (un mot extrême — _tous, jamais, prouve_ — absent du texte).
2. Barre le **contresens** : une option qui prend la voix adverse pour la thèse, ou inverse le ton.
3. Barre la **lecture partielle** : une option vraie mais qui ne retient qu''un détail, pas le cœur du propos.

> 🏆 Quête accomplie ! Tu possèdes désormais la panoplie du lecteur B2 : thèse différée, voix multiples, ironie, fait/opinion/hypothèse, inférence contrôlée et sens figuré. Applique-les, et aucun éditorial retors ne te résistera jusqu''au DELF B2.', '# 📜 Résumé : compréhension écrite B2 (argumentation, ton, implicite)

- **Genres argumentatifs** : éditorial, tribune, article de fond, essai, critique, courrier des lecteurs — l''auteur défend une position.
- **Thèse et articulateurs** : la thèse est souvent différée ; suis _certes… mais_, _or_, _en somme_ pour cartographier le raisonnement.
- **Voix multiples** : ne confonds pas une opinion citée pour être réfutée (« on prétend que… ») avec la thèse de l''auteur ; repère argument et contre-argument.
- **Ironie et implicite** : un décalage (éloge démenti par les faits, guillemets de distance, exagération) trahit l''ironie ; le sous-entendu se déduit du contexte.
- **Fait / opinion / hypothèse** : le fait est vérifiable, l''opinion est un jugement, l''hypothèse est marquée par le conditionnel (_aurait, serait_).
- **Inférence contrôlée** : déduis le non-dit à partir du texte seul, jamais de ta culture générale.
- **Sens figuré** : une expression imagée (« belle vitrine », « se dissoudre comme un sucre ») se lit en contexte, pas au sens littéral.
- **Élimination** : barre la sur-interprétation, le contresens (voix adverse prise pour la thèse) et la lecture partielle.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3cbacd5-5d95-5a54-bfb8-e0b64d60e72d', '1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'Quelle est la transformation passive correcte de « Le jardinier arrose les fleurs » ?', '[{"id":"a","text":"Les fleurs sont arrosées par le jardinier."},{"id":"b","text":"Les fleurs sont arrosé par le jardinier."},{"id":"c","text":"Les fleurs ont arrosé le jardinier."},{"id":"d","text":"Les fleurs étaient arrosées par le jardinier."}]'::jsonb, 'a', 'Le COD « les fleurs » devient sujet et le participe s''accorde au féminin pluriel : « arrosées ». L''option b oublie l''accord. L''option c inverse les rôles (contresens). L''option d change le temps (imparfait), alors que l''actif est au présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0fed68e-42e5-5e2f-8f3e-cf10ccd66227', '1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'Avec quel auxiliaire se forme toujours la voix passive ?', '[{"id":"a","text":"avoir"},{"id":"b","text":"être"},{"id":"c","text":"aller"},{"id":"d","text":"faire"}]'::jsonb, 'b', 'La voix passive se construit toujours avec l''auxiliaire « être » + participe passé. C''est « être » qui porte le temps (est fait, sera fait, a été fait). « Avoir » sert à former les temps composés de l''actif, pas le passif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35e5e594-2b72-5b10-9a87-a4ec567c6757', '1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'Dans « La maison a été vendue », à quel temps est cette phrase passive ?', '[{"id":"a","text":"présent"},{"id":"b","text":"imparfait"},{"id":"c","text":"passé composé"},{"id":"d","text":"futur simple"}]'::jsonb, 'c', '« a été » correspond au passé composé de l''auxiliaire être, donc le passif est au passé composé (= on a vendu la maison). Le présent serait « est vendue », l''imparfait « était vendue » et le futur « sera vendue ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cb83048-068f-5b53-bca7-2031661d743a', '1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'Quel verbe NE peut PAS se mettre à la voix passive ?', '[{"id":"a","text":"construire (une maison)"},{"id":"b","text":"lire (un livre)"},{"id":"c","text":"dormir"},{"id":"d","text":"réparer (une voiture)"}]'::jsonb, 'c', 'Seuls les verbes transitifs directs (avec un COD) se mettent au passif. « Dormir » est intransitif : il n''a pas de COD, donc pas de passif possible. Construire, lire et réparer ont un COD et acceptent le passif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f68ddf8-e98e-56c7-815b-64aa1645f1fe', '1772d2a8-c30a-5cf6-872a-feb2c46cfa1c', 'Complète : « Ce professeur est aimé ___ tous ses élèves. »', '[{"id":"a","text":"de"},{"id":"b","text":"par"},{"id":"c","text":"à"},{"id":"d","text":"pour"}]'::jsonb, 'a', 'Les verbes de sentiment comme « aimer » introduisent le complément d''agent avec « de » : aimé de tous. « Par » s''emploie pour les actions concrètes (réparé par). « À » et « pour » n''introduisent jamais le complément d''agent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c0ad7d1c-3ff8-5089-b653-602ae867b083', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', '⭐ Entraînement : la voix passive', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92748b00-290e-57f9-b2e7-9059ebe50171', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Mets à la voix passive : « Le chef prépare le repas. » → « Le repas ___ par le chef. »', '[{"id":"a","text":"était préparé"},{"id":"b","text":"a préparé"},{"id":"c","text":"sera préparé"},{"id":"d","text":"est préparé"}]'::jsonb, 'd', 'L''actif est au présent (« prépare »), donc le passif est « est + participe » : est préparé. « A préparé » resterait de l''actif ; « sera préparé » est le futur ; « était préparé » est l''imparfait.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('612261cb-e21a-5558-97a2-8536f17810a3', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Mets à la voix passive : « Les ouvriers ont construit le pont. » → « Le pont ___ par les ouvriers. »', '[{"id":"a","text":"est construit"},{"id":"b","text":"a été construit"},{"id":"c","text":"sera construit"},{"id":"d","text":"était construit"}]'::jsonb, 'b', 'L''actif est au passé composé (« ont construit »), donc le passif est « a été + participe » : a été construit. « Est construit » serait le présent et « était construit » l''imparfait, qui ne traduisent pas le passé composé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8684dac1-099a-5a11-ad96-74de23d6a393', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Choisis la bonne forme : « Les fenêtres ___ par le vent. » (actif : le vent a cassé les fenêtres)', '[{"id":"a","text":"ont cassé"},{"id":"b","text":"ont été cassé"},{"id":"c","text":"a été cassées"},{"id":"d","text":"ont été cassées"}]'::jsonb, 'd', 'Le participe s''accorde avec le sujet « les fenêtres » (féminin pluriel) : cassées, et l''auxiliaire être est au pluriel : ont été. « Ont été cassé » oublie l''accord ; « a été » est au singulier ; « ont cassé » est de l''actif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5166e681-88af-5397-9f58-926f8d867f10', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Mets au passif futur : « Le directeur signera le contrat. » → « Le contrat ___ par le directeur. »', '[{"id":"a","text":"est signé"},{"id":"b","text":"a été signé"},{"id":"c","text":"sera signé"},{"id":"d","text":"était signé"}]'::jsonb, 'c', 'L''actif est au futur simple (« signera »), donc le passif est « sera + participe » : sera signé. « Est signé » est le présent, « a été signé » le passé composé et « était signé » l''imparfait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a170fb4-48a3-506e-93d6-218d856173f9', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Complète le complément d''agent : « Le château est entouré ___ hauts murs. »', '[{"id":"a","text":"par de"},{"id":"b","text":"de"},{"id":"c","text":"à"},{"id":"d","text":"avec"}]'::jsonb, 'b', 'Le verbe « entourer » exprime une description et introduit son agent par « de » : entouré de hauts murs. « Par » conviendrait pour une action concrète, mais pas ici ; « à » et « avec » n''introduisent pas le complément d''agent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0802191f-e4bf-5716-a693-5ce61a697773', 'c0ad7d1c-3ff8-5089-b653-602ae867b083', 'Quelle phrase est à la voix passive ?', '[{"id":"a","text":"Marie est partie tôt ce matin."},{"id":"b","text":"Le voleur est tombé dans l''escalier."},{"id":"c","text":"La lettre est lue par le facteur."},{"id":"d","text":"Nous sommes arrivés en retard."}]'::jsonb, 'c', '« La lettre est lue par le facteur » est un vrai passif : on peut demander « lue par qui ? ». Les autres phrases sont des passés composés actifs de verbes de mouvement (partir, tomber, arriver), où « est » est l''auxiliaire, pas un passif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7ebef735-a9ae-5f78-8223-3faad8297763', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', '⭐⭐ Révision : la voix passive', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08a88c15-76ad-5192-a1f9-38461562934a', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Mets au passif imparfait : « Chaque été, les villageois décoraient la place. » → « Chaque été, la place ___ par les villageois. »', '[{"id":"a","text":"est décorée"},{"id":"b","text":"était décorée"},{"id":"c","text":"a été décorée"},{"id":"d","text":"sera décorée"}]'::jsonb, 'b', 'L''actif est à l''imparfait (« décoraient », action répétée), donc le passif est « était + participe » : était décorée, accordé au féminin singulier. « Est décorée » est le présent et « a été décorée » le passé composé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('792c145d-00f5-5926-86fd-05781ce6407a', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Choisis la préposition correcte : « Cette région est connue ___ tous les touristes pour ses plages. »', '[{"id":"a","text":"par"},{"id":"b","text":"de"},{"id":"c","text":"des"},{"id":"d","text":"à"}]'::jsonb, 'b', '« Connaître » est un verbe d''état qui introduit l''agent par « de » : connue de tous les touristes. « Par » s''emploie pour une action concrète. « Des » est la contraction de + les, mais ici « tous les » impose « de » sans contraction.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46daf019-995a-5f6d-9ef8-f2391d92b768', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Reformule avec « se faire » : « Pierre a été grondé par sa mère. » → « Pierre ___ par sa mère. »', '[{"id":"a","text":"a fait gronder"},{"id":"b","text":"s''est fait grondé"},{"id":"c","text":"se fait gronder"},{"id":"d","text":"s''est fait gronder"}]'::jsonb, 'd', '« Se faire + infinitif » est une alternative au passif : s''est fait gronder. Après « faire », le verbe reste à l''infinitif (« gronder », jamais « grondé »). « Se fait » serait le présent, et « a fait gronder » signifierait que Pierre est l''auteur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94b3fefa-2aaf-5faa-b4b4-8086387ec677', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Quelle phrase exprime correctement un passif pronominal ?', '[{"id":"a","text":"Ce vin se boit frais."},{"id":"b","text":"Ce vin est se boit frais."},{"id":"c","text":"Ce vin se est bu frais."},{"id":"d","text":"Ce vin a se boit frais."}]'::jsonb, 'a', 'Le passif pronominal se forme avec « se » + verbe à la forme active : « ce vin se boit frais » (= ce vin est bu frais / on le boit frais). Les autres formes mélangent à tort « être » ou « avoir » avec le pronom « se », ce qui n''existe pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dca2f6ca-9e89-5785-ab14-296b4a254a90', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Mets au passif plus-que-parfait : « Quand je suis arrivé, on avait déjà fermé les portes. » → « Quand je suis arrivé, les portes ___. »', '[{"id":"a","text":"avaient déjà été fermées"},{"id":"b","text":"ont déjà été fermées"},{"id":"c","text":"étaient déjà fermées"},{"id":"d","text":"avaient déjà fermé"}]'::jsonb, 'a', 'Le plus-que-parfait passif est « avait été + participe » : avaient déjà été fermées (accord au féminin pluriel). L''option b est un passé composé ; l''option c (imparfait passif) ne traduit pas l''antériorité ; l''option d est de l''actif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bd1122b-8b39-557b-a3bd-23c1dd64432e', '7ebef735-a9ae-5f78-8223-3faad8297763', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Les résultats seront annoncés demain."},{"id":"b","text":"La décision a été prise hier."},{"id":"c","text":"Les invités sont accueillis à l''entrée."},{"id":"d","text":"Le problème a été obéi par les élèves."}]'::jsonb, 'd', '« Obéir » est transitif indirect (on obéit À quelqu''un), il n''a pas de COD et ne peut donc pas se mettre au passif : « a été obéi » est impossible. Les phrases a, b et c passivent correctement des verbes transitifs directs (annoncer, prendre, accueillir).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0852122d-7278-546b-9cb7-20aea7c5e9be', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : la voix passive', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bea9c2b-251e-58ac-91d6-f72984bf4591', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Reformule sans passif, avec « on » : « Ma voiture a été volée cette nuit. »', '[{"id":"a","text":"On a volé ma voiture cette nuit."},{"id":"b","text":"On a été volé ma voiture cette nuit."},{"id":"c","text":"On a volée ma voiture cette nuit."},{"id":"d","text":"Ma voiture on a volé cette nuit."}]'::jsonb, 'a', 'Avec « on », la phrase redevient active : « On a volé ma voiture » (le COD revient après le verbe, sans accord avec lui). L''option b ajoute « été » à tort ; l''option c accorde le participe alors que le COD est placé après ; l''option d est mal construite.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b8febd7-c23e-5328-81ed-ae7add545c61', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Mets au passif présent : « On répare actuellement la route. »', '[{"id":"a","text":"La route a été réparée actuellement."},{"id":"b","text":"La route était réparée actuellement."},{"id":"c","text":"La route sera réparée actuellement."},{"id":"d","text":"La route est réparée actuellement."}]'::jsonb, 'd', 'L''actif est au présent (« répare »), donc passif au présent : est réparée, accordé au féminin. Comme l''agent est « on » (indéfini), on l''omet. Les options a, b et c changent le temps (passé composé, imparfait, futur), incompatible avec « actuellement ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21cfb950-5286-5c1e-aed2-6157d3b0e78b', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Mets cette phrase au passif : « Le président inaugurera le nouveau musée en présence des journalistes. »', '[{"id":"a","text":"Le nouveau musée est inauguré par le président en présence des journalistes."},{"id":"b","text":"Le nouveau musée a été inauguré par le président en présence des journalistes."},{"id":"c","text":"Le nouveau musée sera inauguré de le président en présence des journalistes."},{"id":"d","text":"Le nouveau musée sera inauguré par le président en présence des journalistes."}]'::jsonb, 'd', 'L''actif est au futur (« inaugurera »), donc passif au futur : sera inauguré, agent introduit par « par » (action concrète). L''option a est au présent, l''option b au passé composé, et l''option c emploie « de » au lieu de « par ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c368616f-f7e3-5081-aecc-e23a6de6ae27', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Trouve la phrase où l''accord du participe est FAUX.', '[{"id":"a","text":"Les preuves ont été examinées par le juge."},{"id":"b","text":"Cette loi a été votée l''an dernier."},{"id":"c","text":"Les documents ont été signé par le notaire."},{"id":"d","text":"Les rues étaient désertées le dimanche."}]'::jsonb, 'c', 'Au passif, le participe s''accorde toujours avec le sujet : « les documents » (masculin pluriel) exige « signés », pas « signé ». Le piège courant est d''oublier l''accord après « ont été ». Les phrases a, b et d accordent correctement (examinées, votée, désertées).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56393432-0511-5333-bbf0-5c36916502e7', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Quelle phrase n''est PAS une voix passive ?', '[{"id":"a","text":"Le coureur a été dépassé dans le dernier virage."},{"id":"b","text":"La fillette est tombée de vélo."},{"id":"c","text":"Le tableau a été restauré par un expert."},{"id":"d","text":"La porte est ouverte par le concierge chaque matin."}]'::jsonb, 'b', '« Est tombée » est un passé composé actif de « tomber » (verbe de mouvement avec auxiliaire être) : le test « tombée par qui ? » n''a aucun sens, donc ce n''est pas un passif. Les phrases a, c et d sont de vrais passifs (dépassé par, restauré par, ouverte par).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14c19d54-1297-585b-a2f0-998522862403', '0852122d-7278-546b-9cb7-20aea7c5e9be', 'Choisis la préposition correcte : « Le vieux sage était respecté ___ tout le village mais critiqué ___ ses rivaux. »', '[{"id":"a","text":"par … de"},{"id":"b","text":"de … de"},{"id":"c","text":"de … par"},{"id":"d","text":"par … par"}]'::jsonb, 'c', '« Respecter » (sentiment) prend « de » : respecté de tout le village. « Critiquer » (action concrète, attaque ponctuelle) prend « par » : critiqué par ses rivaux. La bonne combinaison est donc « de … par ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4fe90a5-b1c9-5b0e-9a7c-58392351c798', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : la voix passive', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25052778-30a1-5187-a70b-bc8f2e810fa5', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Lis : « La tour Eiffel ___ (construire) pour l''Exposition de 1889 ; depuis, elle ___ (visiter) par des millions de personnes. » Choisis le bon couple de temps.', '[{"id":"a","text":"a été construite / a été visitée"},{"id":"b","text":"était construite / est visitée"},{"id":"c","text":"a été construite / est visitée"},{"id":"d","text":"est construite / a été visitée"}]'::jsonb, 'c', '« Pour l''Exposition de 1889 » est un fait ponctuel passé → passé composé passif : a été construite. « Depuis » + situation actuelle qui dure → présent passif : est visitée. Le piège : utiliser deux fois le même temps (a/d) brise la logique chronologique passé daté / état présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42b8a38f-3a78-5d54-b083-bb62980932d4', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Quelle phrase contient une ERREUR cachée de construction passive ?', '[{"id":"a","text":"Les conclusions seront présentées lundi prochain."},{"id":"b","text":"Plusieurs plaintes ont été déposées par les habitants."},{"id":"c","text":"Le dossier était étudié quand la panne est survenue."},{"id":"d","text":"Le suspect a été aperçu entrant dans l''immeuble par un témoin."}]'::jsonb, 'd', 'L''erreur est l''ambiguïté/placement : « par un témoin » se rattache mal et surtout « aperçu entrant » est lourd ; la forme correcte serait « Le suspect a été aperçu par un témoin en train d''entrer ». Plus simplement, le complément d''agent doit suivre le verbe passif, non l''objet de la perception. Les phrases a, b et c sont des passifs corrects et clairs.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d69190b6-eb11-5c1d-80e9-611290742781', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Lis : « L''association ___ par trois bénévoles en 1990. Aujourd''hui, elle ___ par une équipe de cent salariés. » Quel couple exprime le mieux le contraste origine / présent ?', '[{"id":"a","text":"est fondée / est dirigée"},{"id":"b","text":"a été fondée / est dirigée"},{"id":"c","text":"avait été fondée / a été dirigée"},{"id":"d","text":"a été fondée / a été dirigée"}]'::jsonb, 'b', '« En 1990 » → passé composé passif : a été fondée (événement daté). « Aujourd''hui » → présent passif : est dirigée (situation actuelle). L''option a met tout au présent (la fondation n''est pas présente) ; c et d emploient des temps du passé pour « aujourd''hui », ce qui contredit l''adverbe.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cad54213-01ad-5c13-ae72-9c1c68d8dd1d', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ce médicament se prend après les repas."},{"id":"b","text":"Elle s''est fait opérer du genou la semaine dernière."},{"id":"c","text":"Cette nouvelle a été parue dans tous les journaux."},{"id":"d","text":"On nous a remis les diplômes à la fin de la cérémonie."}]'::jsonb, 'c', '« Paraître » est intransitif : il n''a pas de COD, donc pas de passif → « a été parue » est impossible. La forme correcte est « Cette nouvelle a paru dans tous les journaux » (passé composé actif). Les options a (pronominal), b (se faire + infinitif) et d (on + actif) sont correctes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b51d39e-f235-593e-b2cd-69660216b2ea', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Reformule au passif en gardant le sens : « On avait prévenu les passagers du retard avant l''embarquement. »', '[{"id":"a","text":"Les passagers avaient été prévenus du retard avant l''embarquement."},{"id":"b","text":"Les passagers ont été prévenus du retard avant l''embarquement."},{"id":"c","text":"Les passagers étaient prévenus du retard avant l''embarquement."},{"id":"d","text":"Les passagers avaient été prévenu du retard avant l''embarquement."}]'::jsonb, 'a', 'L''actif est au plus-que-parfait (« avait prévenu »), donc passif au plus-que-parfait : avaient été prévenus, accordé au masculin pluriel. L''option b est un passé composé, l''option c un imparfait (pas d''antériorité marquée), et l''option d oublie l''accord du participe.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83bb012c-5dd6-5b5d-b053-8e64d3cf11e7', 'e4fe90a5-b1c9-5b0e-9a7c-58392351c798', 'Dans laquelle de ces phrases le complément d''agent est-il introduit correctement ?', '[{"id":"a","text":"Le toit a été emporté par la tempête et le sol était couvert de débris."},{"id":"b","text":"Le toit a été emporté de la tempête et le sol était couvert par débris."},{"id":"c","text":"Le toit a été emporté par la tempête et le sol était couvert par débris."},{"id":"d","text":"Le toit a été emporté de la tempête et le sol était couvert de débris."}]'::jsonb, 'a', '« Emporter » (action concrète) prend « par » : emporté par la tempête. « Couvert » (état/description) prend « de » : couvert de débris. La bonne combinaison est donc « par … de ». Les autres mélangent les prépositions ou inversent par/de.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('02146c8d-795e-54d2-97b7-8f32084b3131', '28369603-0cce-5a38-95a4-b2cefdade397', 'francais-b2', '⭐⭐ Drill : la voix passive', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8a251c8-6ee3-5027-bd1e-15ca85c552b4', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Mets au passif : « La pluie inondait les champs. » → « Les champs ___ par la pluie. »', '[{"id":"a","text":"sont inondés"},{"id":"b","text":"étaient inondés"},{"id":"c","text":"ont été inondés"},{"id":"d","text":"seront inondés"}]'::jsonb, 'b', 'L''actif est à l''imparfait (« inondait »), donc passif à l''imparfait : étaient inondés, accordé au masculin pluriel. « Sont inondés » est le présent, « ont été inondés » le passé composé et « seront inondés » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4edac505-b0a6-5585-bb8d-85b3f3605c2e', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Complète : « Le chasseur avançait, suivi ___ son chien fidèle. »', '[{"id":"a","text":"par"},{"id":"b","text":"avec"},{"id":"c","text":"de"},{"id":"d","text":"à"}]'::jsonb, 'c', '« Suivre » fait partie des verbes qui introduisent l''agent par « de » dans ce sens descriptif : suivi de son chien. « Par » insisterait sur une poursuite active ; « avec » et « à » n''introduisent pas le complément d''agent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8163e4b-3d16-50b3-b42e-e554c8392c16', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Reformule avec le passif pronominal : « En Tunisie, on parle l''arabe partout. »', '[{"id":"a","text":"En Tunisie, l''arabe se parle partout."},{"id":"b","text":"En Tunisie, l''arabe est se parle partout."},{"id":"c","text":"En Tunisie, l''arabe se est parlé partout."},{"id":"d","text":"En Tunisie, l''arabe s''a parlé partout."}]'::jsonb, 'a', 'Le passif pronominal exprime un usage général : l''arabe se parle partout (= est parlé / on le parle). On ne combine jamais « se » avec « être » ou « avoir » comme dans les options b, c et d, qui sont agrammaticales.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce9ccf41-c873-585c-8c68-51c5f8d14a3e', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Mets au passif passé composé : « Un célèbre architecte a dessiné ces plans. » → « Ces plans ___ un célèbre architecte. »', '[{"id":"a","text":"ont été dessiné par"},{"id":"b","text":"ont été dessinés de"},{"id":"c","text":"ont été dessinés par"},{"id":"d","text":"sont dessinés par"}]'::jsonb, 'c', 'Passé composé passif : ont été dessinés (accord masculin pluriel avec « ces plans »), agent introduit par « par » (action de dessiner). L''option a oublie l''accord ; l''option b emploie « de » à tort ; l''option d est au présent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8199572-41da-56d4-b06e-6af3b29913ef', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Le colis sera livré demain matin."},{"id":"b","text":"La salle avait été réservée à l''avance."},{"id":"c","text":"Le rapport est relu par la directrice."},{"id":"d","text":"Les enfants sont rentrés par la nuit."}]'::jsonb, 'd', '« Sont rentrés » est un passé composé actif (rentrer, verbe de mouvement) : on ne peut pas y ajouter un complément d''agent « par la nuit » comme à un passif. La forme correcte serait « Les enfants sont rentrés pendant la nuit ». Les phrases a, c et d sont des passifs corrects.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b60b0aa0-d69c-504e-a955-ff987165385b', '02146c8d-795e-54d2-97b7-8f32084b3131', 'Reformule avec « se faire » : « Le piéton a été renversé par une voiture. »', '[{"id":"a","text":"Le piéton s''est fait renverser par une voiture."},{"id":"b","text":"Le piéton s''est fait renversé par une voiture."},{"id":"c","text":"Le piéton a fait renverser par une voiture."},{"id":"d","text":"Le piéton se fait renverser par une voiture."}]'::jsonb, 'a', '« Se faire + infinitif » au passé composé : s''est fait renverser. Le verbe après « faire » reste à l''infinitif (« renverser », jamais « renversé »). L''option c oublie le pronom « se » et change le sens ; l''option d est au présent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b317ee3b-d7b2-56bf-b48d-0879e718a61f', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d9e1c97-7b5d-51d8-a137-b51b1f159d66', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'Complète au subjonctif passé : « Je suis content que tu ___ hier soir. » (venir)', '[{"id":"a","text":"viennes"},{"id":"b","text":"sois venu"},{"id":"c","text":"es venu"},{"id":"d","text":"viendras"}]'::jsonb, 'b', 'L''action est antérieure (« hier soir ») : on emploie le subjonctif passé, formé de l''auxiliaire être au subjonctif présent + participe passé : que tu sois venu. « viennes » est le subjonctif présent, « es venu » l''indicatif (passé composé), « viendras » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be8d5286-009b-5ac1-aec2-268d175a2394', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'Comment forme-t-on le subjonctif passé ?', '[{"id":"a","text":"que + auxiliaire avoir/être au subjonctif présent + participe passé"},{"id":"b","text":"que + auxiliaire avoir/être à l''imparfait + participe passé"},{"id":"c","text":"que + radical du présent + terminaisons -e, -es, -e"},{"id":"d","text":"que + auxiliaire avoir/être au futur + participe passé"}]'::jsonb, 'a', 'Le subjonctif passé est un temps composé : auxiliaire avoir ou être conjugué au subjonctif présent, suivi du participe passé (que j''aie fini, qu''il soit parti). La réponse (c) décrit le subjonctif présent simple, pas le passé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84b28989-6163-594f-b8f0-88c7d4e2facd', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'Complète : « C''est le meilleur film que j''___ jamais vu. » (avoir vu)', '[{"id":"a","text":"ai"},{"id":"b","text":"aie"},{"id":"c","text":"avais"},{"id":"d","text":"aurai"}]'::jsonb, 'b', 'Après un superlatif (« le meilleur »), la relative se met au subjonctif : que j''aie vu. À l''écrit soigné B2, c''est aie (subjonctif), non ai (indicatif). « avais » est l''imparfait et « aurai » le futur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33674c1c-e508-583c-8eac-500770d3e6e8', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'Complète : « Bien qu''il ___ très fatigué, il a terminé le marathon. » (être)', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"soit"},{"id":"d","text":"sera"}]'::jsonb, 'c', 'La conjonction « bien que » impose toujours le subjonctif, même quand le fait semble réel : bien qu''il soit fatigué. « est » et « était » sont à l''indicatif, « sera » au futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67ec44d8-18dd-5d27-b769-1731619f9d14', 'b317ee3b-d7b2-56bf-b48d-0879e718a61f', 'Choisis le bon mode : « Je cherche un appartement qui ___ lumineux. » (être)', '[{"id":"a","text":"soit"},{"id":"b","text":"est"},{"id":"c","text":"sera"},{"id":"d","text":"était"}]'::jsonb, 'a', 'L''appartement est recherché, pas encore trouvé : la relative de souhait se met au subjonctif (qui soit). Si l''appartement existait déjà, on dirait « l''appartement où j''habite, qui est lumineux » (indicatif).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e3651824-8e9a-5357-a50a-e1dd1d6fd927', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', '⭐ Entraînement : le subjonctif passé', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d0f0f46-67cd-544a-8a1e-3f016d260f4f', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Complète : « Je doute qu''il ___ son travail avant midi. » (finir, action déjà accomplie)', '[{"id":"a","text":"ait fini"},{"id":"b","text":"finisse"},{"id":"c","text":"a fini"},{"id":"d","text":"finira"}]'::jsonb, 'a', 'L''action est antérieure : on emploie le subjonctif passé = avoir au subjonctif présent + participe passé : qu''il ait fini. « finisse » est le subjonctif présent, « a fini » l''indicatif, « finira » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4030df4-3003-57e2-8a38-9b8028403420', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Complète : « Nous sommes heureux qu''elle ___ à la fête samedi dernier. » (venir)', '[{"id":"a","text":"vienne"},{"id":"b","text":"soit venue"},{"id":"c","text":"est venue"},{"id":"d","text":"soit venu"}]'::jsonb, 'b', 'Action passée (« samedi dernier ») + verbe venir → subjonctif passé avec être : qu''elle soit venue, le participe s''accordant au féminin. « vienne » est le présent, « est venue » l''indicatif, et « soit venu » ne s''accorde pas avec « elle ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('536a3724-b9b9-550f-88dd-7c789ccca30c', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Quel est le subjonctif passé du verbe parler avec « que j'' » ?', '[{"id":"a","text":"que je parle"},{"id":"b","text":"que j''ai parlé"},{"id":"c","text":"que j''aie parlé"},{"id":"d","text":"que j''avais parlé"}]'::jsonb, 'c', 'Le subjonctif passé = avoir au subjonctif présent (que j''aie) + participe passé (parlé) : que j''aie parlé. « que je parle » est le subjonctif présent, « que j''ai parlé » l''indicatif, « que j''avais parlé » le plus-que-parfait.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('814c401a-977f-5fd4-b80c-2f7bf25d3c5b', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Complète : « Il faut que tu ___ tes valises avant ce soir. » (faire, action à venir)', '[{"id":"a","text":"aies fait"},{"id":"b","text":"fasses"},{"id":"c","text":"fais"},{"id":"d","text":"feras"}]'::jsonb, 'b', 'L''action reste à accomplir (postérieure) : on garde le subjonctif présent du verbe faire : que tu fasses. Le subjonctif passé « aies fait » exprimerait une action déjà terminée. « fais » et « feras » sont l''indicatif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aed59985-17f8-5f6f-975a-38d76be99d29', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Complète : « Je suis désolé que vous ___ attendre si longtemps hier. » (devoir)', '[{"id":"a","text":"deviez"},{"id":"b","text":"avez dû"},{"id":"c","text":"ayez dû"},{"id":"d","text":"devrez"}]'::jsonb, 'c', 'Action passée (« hier ») après un sentiment → subjonctif passé avec avoir : que vous ayez dû. « deviez » est le subjonctif présent, « avez dû » l''indicatif, et « devrez » le futur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da24c131-0482-59b4-8ff0-d4ea01ab71c8', 'e3651824-8e9a-5357-a50a-e1dd1d6fd927', 'Complète : « Elle regrette que nous ___ si tôt l''an dernier. » (partir)', '[{"id":"a","text":"partions"},{"id":"b","text":"sommes partis"},{"id":"c","text":"soyons partis"},{"id":"d","text":"ayons partis"}]'::jsonb, 'c', 'Action antérieure + verbe partir (auxiliaire être) → subjonctif passé : que nous soyons partis. « partions » est le présent, « sommes partis » l''indicatif, et « ayons partis » utilise le mauvais auxiliaire (partir se conjugue avec être).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('198b1701-98f9-532c-9760-e07ef596bd8b', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', '⭐⭐ Révision : présent ou passé du subjonctif', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d08985cc-f855-51bf-acf3-face8f97af6a', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Complète : « Je suis ravi que tu ___ ton diplôme la semaine dernière. » (obtenir)', '[{"id":"a","text":"obtiennes"},{"id":"b","text":"aies obtenu"},{"id":"c","text":"as obtenu"},{"id":"d","text":"obtiendras"}]'::jsonb, 'b', 'Indice « la semaine dernière » = action antérieure → subjonctif passé : que tu aies obtenu. « obtiennes » est le présent (action à venir), « as obtenu » l''indicatif, « obtiendras » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f2cf850-e02f-5125-895a-57a03d0f2f43', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Choisis la bonne forme : « Nous attendons que le train ___ pour monter. » (arriver)', '[{"id":"a","text":"arrive"},{"id":"b","text":"soit arrivé"},{"id":"c","text":"arrivera"},{"id":"d","text":"est arrivé"}]'::jsonb, 'a', 'L''arrivée du train est postérieure à l''attente : on emploie le subjonctif présent : que le train arrive. Le subjonctif passé « soit arrivé » signifierait que le train est déjà là. « arrivera » et « est arrivé » sont à l''indicatif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf898c93-3355-537a-88a7-2029232eb11f', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Complète : « Bien qu''elle ___ tout révisé hier, elle reste inquiète. » (réviser)', '[{"id":"a","text":"révise"},{"id":"b","text":"a révisé"},{"id":"c","text":"révisait"},{"id":"d","text":"ait révisé"}]'::jsonb, 'd', '« Bien que » impose le subjonctif, et « hier » impose l''antériorité → subjonctif passé : bien qu''elle ait révisé. « a révisé » et « révisait » sont à l''indicatif, « révise » est le subjonctif présent (action non passée).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29a49cf9-1a05-546d-868a-57059cac58fb', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Complète : « Il est possible qu''ils ___ déjà ce matin. » (se réveiller)', '[{"id":"a","text":"se soient réveillés"},{"id":"b","text":"se sont réveillés"},{"id":"c","text":"se réveillent"},{"id":"d","text":"se réveilleront"}]'::jsonb, 'a', 'Verbe pronominal + action déjà accomplie (« déjà ce matin ») → subjonctif passé avec être : qu''ils se soient réveillés, participe accordé au masculin pluriel. « se sont réveillés » est l''indicatif, « se réveillent » le présent, « se réveilleront » le futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59d55131-ae0a-5769-a73f-fb3761c8aee0', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je crains qu''il ne soit déjà parti."},{"id":"b","text":"Je veux que tu sois là demain."},{"id":"c","text":"Je suis surpris qu''elle a réussi l''examen hier."},{"id":"d","text":"Il est dommage que nous ayons perdu ce match."}]'::jsonb, 'c', 'Erreur dans (c) : après « je suis surpris que » (sentiment) et avec une action passée, il faut le subjonctif passé qu''elle ait réussi, non l''indicatif « a réussi ». Les phrases (a), (b) et (d) emploient correctement le subjonctif (passé ou présent).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87f97da2-42b0-5065-a0e9-27c6a233d89c', '198b1701-98f9-532c-9760-e07ef596bd8b', 'Complète : « Avant que vous ne ___ , laissez-moi vous remercier. » (partir, action future)', '[{"id":"a","text":"soyez partis"},{"id":"b","text":"partez"},{"id":"c","text":"partirez"},{"id":"d","text":"partiez"}]'::jsonb, 'd', '« Avant que » impose le subjonctif et l''action est encore à venir → subjonctif présent : avant que vous ne partiez. Le « ne » est explétif (il ne nie pas). « soyez partis » est le passé, « partez » et « partirez » sont l''indicatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d953eb2e-e6c2-5480-911f-e43924f0309e', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : les emplois avancés', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe6121ee-74ef-590a-9e40-e74e3dd10c9b', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Complète : « C''est la plus belle ville que je ___ jamais visitée. » (visiter)', '[{"id":"a","text":"ai"},{"id":"b","text":"aie"},{"id":"c","text":"avais"},{"id":"d","text":"aurai"}]'::jsonb, 'b', 'Après un superlatif (« la plus belle »), la relative passe au subjonctif passé : que je aie visitée. À l''écrit B2 c''est aie (subjonctif), non ai (indicatif). « avais » est l''imparfait, « aurai » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b4df701-7e11-5bd7-b2cb-eaf15526c15f', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Complète : « Il est sorti sans que personne ne s''en ___ . » (apercevoir, action simultanée)', '[{"id":"a","text":"aperçoit"},{"id":"b","text":"soit aperçu"},{"id":"c","text":"aperçoive"},{"id":"d","text":"apercevait"}]'::jsonb, 'c', '« Sans que » impose toujours le subjonctif ; l''action est simultanée à la sortie → subjonctif présent : sans que personne ne s''en aperçoive. « aperçoit » et « apercevait » sont l''indicatif, et le passé « soit aperçu » n''est pas justifié ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04089efb-8c33-5ea0-a4d1-4914e08ee186', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Choisis le bon mode : « Je cherche un assistant qui ___ parler trois langues. » (savoir)', '[{"id":"a","text":"sait"},{"id":"b","text":"saura"},{"id":"c","text":"savait"},{"id":"d","text":"sache"}]'::jsonb, 'd', 'L''assistant est recherché, pas encore trouvé : la relative de souhait se met au subjonctif présent : qui sache parler. Le piège est de mettre l''indicatif « sait », qui décrirait une personne réelle et identifiée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9b260b1-bcba-5060-929b-cc56977b846f', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Complète : « Nous resterons ici jusqu''à ce que la pluie ___ . » (cesser, action future)', '[{"id":"a","text":"cessera"},{"id":"b","text":"cessait"},{"id":"c","text":"cesse"},{"id":"d","text":"ait cessé"}]'::jsonb, 'c', '« Jusqu''à ce que » impose le subjonctif et l''action de cesser est postérieure → subjonctif présent : jusqu''à ce que la pluie cesse. Le piège courant est « cessera » (futur de l''indicatif), interdit après cette conjonction ; « ait cessé » suggérerait à tort une fin déjà advenue.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('907f00a0-2d29-5d01-b083-8588fd435757', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Après qu''il soit parti, nous avons rangé la salle."},{"id":"b","text":"Bien qu''elle ait travaillé dur, elle a échoué."},{"id":"c","text":"C''est le seul ami qui me comprenne vraiment."},{"id":"d","text":"Je l''aiderai à moins qu''il ne refuse."}]'::jsonb, 'a', 'Erreur dans (a) : « après que » se construit avec l''indicatif, non le subjonctif → après qu''il est parti. Le piège classique est de l''aligner sur « avant que » (qui, lui, prend le subjonctif). Les phrases (b), (c) et (d) emploient correctement le subjonctif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f39e08af-186d-5519-86c5-9932b8bb9bc3', 'd953eb2e-e6c2-5480-911f-e43924f0309e', 'Complète : « C''est le dernier roman qu''il ___ avant de mourir. » (écrire)', '[{"id":"a","text":"a écrit"},{"id":"b","text":"écrivait"},{"id":"c","text":"écrira"},{"id":"d","text":"ait écrit"}]'::jsonb, 'd', 'Après « le dernier » (comme un superlatif), la relative passe au subjonctif, et l''action est antérieure → subjonctif passé : qu''il ait écrit. Le piège est l''indicatif « a écrit », acceptable en langue courante mais non conforme au registre B2 attendu ; « écrivait » et « écrira » ne situent pas correctement l''action.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6af4356c-1871-5520-aa06-0ef5e009055f', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : subjonctif d''expert', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58d93a80-a035-5b28-ac68-8d56a6a272c4', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Complète : « Quoiqu''ils ___ tout tenté la veille, le projet a échoué. » (tenter)', '[{"id":"a","text":"ont tenté"},{"id":"b","text":"tentent"},{"id":"c","text":"avaient tenté"},{"id":"d","text":"aient tenté"}]'::jsonb, 'd', '« Quoique » (= bien que) impose le subjonctif et « la veille » impose l''antériorité → subjonctif passé : quoiqu''ils aient tenté. « ont tenté » et « avaient tenté » sont l''indicatif ; « tentent » est le présent, qui ne marque pas l''action accomplie.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4951492-5d81-577c-a920-60521cdf8c71', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Choisis : « C''est bien la chose la plus étrange qui me ___ depuis des années. » (arriver)', '[{"id":"a","text":"est arrivée"},{"id":"b","text":"arrivait"},{"id":"c","text":"soit arrivée"},{"id":"d","text":"soit arrivé"}]'::jsonb, 'c', 'Superlatif (« la plus étrange ») + action passée → subjonctif passé, et le participe s''accorde avec « la chose » (féminin) puisque l''auxiliaire est être : qui me soit arrivée. « est arrivée » est l''indicatif, « arrivait » l''imparfait, et « soit arrivé » oublie l''accord au féminin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f393fdc-3672-576b-a959-d8dd8c01c643', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Complète : « Je préfère prévenir maintenant, de peur qu''il n''y ___ un malentendu plus tard. » (avoir)', '[{"id":"a","text":"ait"},{"id":"b","text":"a"},{"id":"c","text":"aura"},{"id":"d","text":"avait"}]'::jsonb, 'a', '« De peur que » (locution de crainte, comme « avant que ») impose le subjonctif présent pour une action redoutée à venir : de peur qu''il n''y ait. Le « n'' » est explétif. « a », « aura » et « avait » sont à l''indicatif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83452cf0-0a14-55db-a581-6b6dcc9b83dd', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Trouve la SEULE phrase correcte.', '[{"id":"a","text":"Je doute qu''elle a compris la consigne."},{"id":"b","text":"C''est le meilleur conseil qu''on m''ait jamais donné."},{"id":"c","text":"Après qu''elle soit revenue, on a dîné."},{"id":"d","text":"Je cherche quelqu''un qui sait réparer ça, mais je ne sais pas qui."}]'::jsonb, 'b', 'Seule (b) est correcte : superlatif « le meilleur » + action passée → subjonctif passé qu''on m''ait donné. (a) demande le subjonctif passé « ait compris » après « je doute » ; (c) demande l''indicatif après « après que » (est revenue) ; (d) demande le subjonctif « qui sache » pour une personne recherchée et non identifiée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95da0f1b-d08a-589d-9c91-087f629dae04', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Complète : « Il est le seul à qui je ___ confiance depuis cet incident. » (faire)', '[{"id":"a","text":"fais"},{"id":"b","text":"ferai"},{"id":"c","text":"faisais"},{"id":"d","text":"fasse"}]'::jsonb, 'd', 'Après « le seul », la relative se met au subjonctif ; l''action de faire confiance est durable et actuelle → subjonctif présent : à qui je fasse confiance. Le piège est l''indicatif « fais », fréquent à l''oral mais non conforme au registre soigné attendu après « le seul ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3929342d-8adc-5ae5-8e73-6a6ef11c4061', '6af4356c-1871-5520-aa06-0ef5e009055f', 'Complète : « Bien que la décision ___ déjà avant la réunion, on en a longuement débattu. » (prendre, voix passive)', '[{"id":"a","text":"ait été prise"},{"id":"b","text":"a été prise"},{"id":"c","text":"soit prise"},{"id":"d","text":"était prise"}]'::jsonb, 'a', '« Bien que » impose le subjonctif ; au passif et avec une action antérieure (« déjà avant »), on emploie le subjonctif passé du passif : ait été prise (avoir été + participe accordé au féminin). « a été prise » et « était prise » sont l''indicatif ; « soit prise » est le subjonctif présent, qui ne marque pas l''antériorité.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1e47a99a-4253-5052-849f-50536e016929', '3ba90c2b-2c2f-553e-bc7a-65b743544e78', 'francais-b2', '⭐⭐ Drill : révision globale du chapitre', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c6577bc-d9a8-5a3e-9fba-840e1ce3f3d0', '1e47a99a-4253-5052-849f-50536e016929', 'Complète : « Nous sommes fiers que vous ___ ce concours l''an passé. » (réussir)', '[{"id":"a","text":"ayez réussi"},{"id":"b","text":"réussissiez"},{"id":"c","text":"avez réussi"},{"id":"d","text":"réussirez"}]'::jsonb, 'a', 'Sentiment + action passée (« l''an passé ») → subjonctif passé avec avoir : que vous ayez réussi. « réussissiez » est le présent, « avez réussi » l''indicatif, « réussirez » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf1c31d9-d0d8-545f-9241-2277f50807bf', '1e47a99a-4253-5052-849f-50536e016929', 'Complète : « Pars vite, à moins que tu ne ___ rester encore un peu. » (vouloir)', '[{"id":"a","text":"veux"},{"id":"b","text":"veuilles"},{"id":"c","text":"voudras"},{"id":"d","text":"aies voulu"}]'::jsonb, 'b', '« À moins que » impose le subjonctif présent pour une volonté actuelle : à moins que tu ne veuilles. Le « ne » est explétif. « veux » et « voudras » sont l''indicatif, et le passé « aies voulu » n''a pas de sens ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('730207d1-f9cd-5fb1-b4e1-52c35af018db', '1e47a99a-4253-5052-849f-50536e016929', 'Choisis le bon mode : « C''est le premier élève qui ___ résolu ce problème. » (avoir résolu)', '[{"id":"a","text":"a"},{"id":"b","text":"avait"},{"id":"c","text":"aura"},{"id":"d","text":"ait"}]'::jsonb, 'd', 'Après « le premier » (valeur de superlatif), la relative se met au subjonctif : qui ait résolu. C''est le subjonctif passé (action accomplie). « a » et « avait » sont l''indicatif, « aura » le futur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f764cc3-19c4-5587-a4fa-5cb3e76aaea1', '1e47a99a-4253-5052-849f-50536e016929', 'Complète : « J''aimerais trouver une explication qui ___ tout le monde. » (satisfaire)', '[{"id":"a","text":"satisfait"},{"id":"b","text":"satisfasse"},{"id":"c","text":"satisfera"},{"id":"d","text":"satisfaisait"}]'::jsonb, 'b', 'L''explication est souhaitée, pas encore trouvée : relative de souhait au subjonctif présent : qui satisfasse. « satisfait » (indicatif) décrirait une explication réelle ; « satisfera » est le futur, « satisfaisait » l''imparfait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d8f24a3-8339-5f9c-8a47-bced4b35e5fe', '1e47a99a-4253-5052-849f-50536e016929', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je suis content qu''elle soit arrivée à temps."},{"id":"b","text":"Pour que tu réussisses, travaille régulièrement."},{"id":"c","text":"Après que nous ayons mangé, nous sommes sortis."},{"id":"d","text":"Bien qu''il pleuve, nous irons marcher."}]'::jsonb, 'c', 'Erreur dans (c) : « après que » se construit avec l''indicatif → après que nous avons mangé. Le piège est de l''aligner sur « avant que » (subjonctif). Les phrases (a), (b) et (d) emploient correctement le subjonctif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60ce5256-c523-5817-819f-78f682e8d20e', '1e47a99a-4253-5052-849f-50536e016929', 'Complète : « Il agit toujours sans que ses collègues ne ___ informés à l''avance. » (être)', '[{"id":"a","text":"sont"},{"id":"b","text":"seront"},{"id":"c","text":"étaient"},{"id":"d","text":"soient"}]'::jsonb, 'd', '« Sans que » impose le subjonctif ; l''action est simultanée → subjonctif présent : sans que ses collègues ne soient informés. « sont », « seront » et « étaient » sont à l''indicatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5ca8918-72cc-5ee3-b6dd-bcae02f6bf90', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'Complète : « ___ ton aide, j''ai réussi mon examen. » (résultat positif)', '[{"id":"a","text":"À cause de"},{"id":"b","text":"Grâce à"},{"id":"c","text":"Parce que"},{"id":"d","text":"Puisque"}]'::jsonb, 'b', '« Grâce à » + nom exprime une cause positive (un bénéfice) : grâce à ton aide. « À cause de » conviendrait pour un résultat négatif ou neutre. « Parce que » et « puisque » exigent un verbe conjugué, pas un nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4efa4823-dfcb-5c5d-984a-c6907dcab94b', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'Quelle phrase est CORRECTE ?', '[{"id":"a","text":"Je suis resté chez moi parce que la pluie."},{"id":"b","text":"Je suis resté chez moi à cause de la pluie."},{"id":"c","text":"Je suis resté chez moi car la pluie."},{"id":"d","text":"Je suis resté chez moi puisque la pluie."}]'::jsonb, 'b', 'Devant un nom (la pluie), on emploie « à cause de » : à cause de la pluie. « Parce que », « car » et « puisque » introduisent une proposition avec un verbe conjugué (parce qu''il pleuvait), jamais un simple nom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('802a7323-a072-5585-8aac-a2eea28e048f', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'Complète : « Il faisait froid, ___ nous avons allumé le chauffage. »', '[{"id":"a","text":"parce que"},{"id":"b","text":"à cause de"},{"id":"c","text":"donc"},{"id":"d","text":"pour que"}]'::jsonb, 'c', 'La seconde proposition est la conséquence du froid → « donc » (conséquence). « Parce que » introduirait une cause (l''ordre serait inversé), « à cause de » exige un nom, et « pour que » introduit un but au subjonctif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6aad5e23-378a-53f7-9ff6-926518c6b7b3', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'Complète : « Je te le répète ___ tu n''oublies pas. »', '[{"id":"a","text":"pour ne pas oublier"},{"id":"b","text":"pour que tu oublies pas"},{"id":"c","text":"pour que tu n''oublies pas"},{"id":"d","text":"pour que tu n''oublieras pas"}]'::jsonb, 'c', 'Deux sujets différents (je / tu) → « pour que » + subjonctif : pour que tu n''oublies pas. La forme (d) met le futur (oublieras), interdit après « pour que ». L''option (a) change le sens (même sujet), et (b) oublie la négation « ne ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f627e33-15a7-59a8-8e15-ddaebaf3bfb1', 'a9e5ca3c-51e3-53cc-a9f7-546b791d8505', 'Complète : « Il a ___ travail qu''il ne dort plus. »', '[{"id":"a","text":"si de"},{"id":"b","text":"tellement de"},{"id":"c","text":"si"},{"id":"d","text":"tant"}]'::jsonb, 'b', 'Devant un nom (travail), la conséquence d''intensité se construit avec « tellement de » ou « tant de » + nom + que : tellement de travail qu''il ne dort plus. « Si » et « tant » seuls s''emploient devant un adjectif/adverbe ou un verbe, pas devant un nom ; « si de » n''existe pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', '⭐ Entraînement : la cause, la conséquence et le but', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6fc904d-2712-5f77-a8a7-7e68fdd9d2bb', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Complète : « ___ ses efforts, elle a obtenu une bourse. » (résultat positif)', '[{"id":"a","text":"À cause de"},{"id":"b","text":"Grâce à"},{"id":"c","text":"Faute de"},{"id":"d","text":"Parce que"}]'::jsonb, 'b', '« Grâce à » + nom marque une cause positive : grâce à ses efforts. « À cause de » serait négatif/neutre, « faute de » signifie un manque, et « parce que » exige un verbe conjugué, pas un nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42ef1c82-0e4c-53c1-a893-6aaeef1db091', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Complète : « Je révise beaucoup ___ réussir le DELF. » (même sujet)', '[{"id":"a","text":"pour"},{"id":"b","text":"pour que"},{"id":"c","text":"afin que"},{"id":"d","text":"parce que"}]'::jsonb, 'a', 'Le sujet est le même (je révise / je réussis) → « pour » + infinitif : pour réussir. « Pour que » et « afin que » s''emploient quand les sujets diffèrent (+ subjonctif). « Parce que » exprimerait une cause, pas un but.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34eb058f-0964-5fc3-903d-19f249265b67', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Complète : « Il pleuvait, ___ nous avons annulé la sortie. »', '[{"id":"a","text":"car"},{"id":"b","text":"puisque"},{"id":"c","text":"c''est pourquoi"},{"id":"d","text":"pour que"}]'::jsonb, 'c', 'La seconde proposition est la conséquence du fait qu''il pleuvait → « c''est pourquoi » (conséquence). « Car » et « puisque » introduisent une cause, et « pour que » un but au subjonctif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('437bf2bb-e4ba-5349-8b56-c25ef3fe012a', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Quelle phrase est CORRECTE ?', '[{"id":"a","text":"Le match est annulé parce que la neige."},{"id":"b","text":"Le match est annulé en raison de la neige."},{"id":"c","text":"Le match est annulé donc la neige."},{"id":"d","text":"Le match est annulé grâce à la neige."}]'::jsonb, 'b', 'Devant le nom « la neige », on emploie « en raison de » (cause, registre formel). « Parce que » exige un verbe conjugué ; « donc » introduit une conséquence ; « grâce à » serait positif, ce qui ne convient pas à une annulation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3986534c-d85d-5a47-a43b-e5b948cf22c3', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Complète : « ___ tu es déjà au courant, je ne répète pas. » (cause connue de l''interlocuteur)', '[{"id":"a","text":"Puisque"},{"id":"b","text":"Pour que"},{"id":"c","text":"À cause de"},{"id":"d","text":"Si bien que"}]'::jsonb, 'a', '« Puisque » introduit une cause déjà connue, évidente pour l''interlocuteur : puisque tu es au courant. « Pour que » marque un but, « à cause de » exige un nom, et « si bien que » introduit une conséquence.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('496ced50-dae6-5a6a-a1e6-e7bc2f5d702e', 'b7e3e90d-d866-5e5a-8c57-4f5b4d230593', 'Complète : « Elle parle bas ___ que le bébé. » (deux sujets, but : éviter de réveiller)', '[{"id":"a","text":"de peur de réveiller"},{"id":"b","text":"de peur que le bébé se réveille"},{"id":"c","text":"de peur que le bébé se réveillera"},{"id":"d","text":"à cause de réveiller"}]'::jsonb, 'b', 'Deux sujets (elle / le bébé) → « de peur que » + subjonctif : de peur que le bébé se réveille. La forme (c) met le futur, interdit ici. L''option (a) supposerait le même sujet, et « à cause de » + verbe est incorrect.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', '⭐⭐ Révision : la cause, la conséquence et le but', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b245e22f-c016-5e60-bd22-78e3b8a5ec9a', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Complète : « ___ il faisait beau, nous avons pique-niqué. » (cause mise en tête de phrase)', '[{"id":"a","text":"Comme"},{"id":"b","text":"Car"},{"id":"c","text":"Donc"},{"id":"d","text":"Grâce à"}]'::jsonb, 'a', 'En tête de phrase, la cause s''introduit par « comme » : Comme il faisait beau… « Car » ne se place jamais en début de phrase ; « donc » marque la conséquence ; « grâce à » exige un nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7151d6d3-8662-5567-91e0-84d291af351f', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Complète : « ___ l''embouteillage, j''ai raté mon train. » (cause négative + nom)', '[{"id":"a","text":"Grâce à"},{"id":"b","text":"Parce que"},{"id":"c","text":"Si bien que"},{"id":"d","text":"À cause de"}]'::jsonb, 'd', 'Résultat fâcheux + nom → « à cause de » : à cause de l''embouteillage. « Grâce à » serait positif (contresens ici), « parce que » exige un verbe, et « si bien que » introduit une conséquence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6a7523c-8d00-5f51-86e3-9b4db89a30d3', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Complète : « Le projet a échoué ___ moyens financiers. » (cause = un manque)', '[{"id":"a","text":"grâce à des"},{"id":"b","text":"parce que des"},{"id":"c","text":"faute de"},{"id":"d","text":"pour que des"}]'::jsonb, 'c', '« Faute de » + nom (sans article) exprime une cause par manque : faute de moyens. « Grâce à » serait positif, « parce que » exige un verbe conjugué, et « pour que » introduit un but au subjonctif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('454a1679-187d-5a15-a3a0-970ca7ebf881', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Complète : « Il a ___ couru qu''il est essoufflé. » (intensité portant sur le verbe)', '[{"id":"a","text":"si"},{"id":"b","text":"tant"},{"id":"c","text":"tant de"},{"id":"d","text":"tellement de"}]'::jsonb, 'b', 'L''intensité porte sur le verbe « courir » → « tant » (ou « tellement ») + verbe + que : il a tant couru qu''il est essoufflé. « Si » s''emploie devant un adjectif/adverbe ; « tant de » et « tellement de » devant un nom.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90151351-2da3-593f-91f9-74aeeacb1444', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Quelle phrase est CORRECTE ?', '[{"id":"a","text":"Je l''aide afin qu''il finir à temps."},{"id":"b","text":"Je l''aide afin qu''il finit à temps."},{"id":"c","text":"Je l''aide afin qu''il finisse à temps."},{"id":"d","text":"Je l''aide afin qu''il finira à temps."}]'::jsonb, 'c', '« Afin que » + subjonctif : afin qu''il finisse. La forme (a) garde l''infinitif, (b) l''indicatif présent (finit), (d) le futur (finira) — tous interdits après « afin que », qui impose le subjonctif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd32723b-988e-52b6-b798-389bdff94b6f', 'cef6cc6b-7cfe-598c-a56b-58b8df5864df', 'Complète : « Range ta chambre ___ pouvoir inviter tes amis. » (même sujet)', '[{"id":"a","text":"de manière à"},{"id":"b","text":"de manière à ce que"},{"id":"c","text":"pour que"},{"id":"d","text":"afin que"}]'::jsonb, 'a', 'Même sujet (tu ranges / tu pourras inviter) → « de manière à » + infinitif : de manière à pouvoir inviter. « Pour que », « afin que » et « de manière à ce que » introduisent un subjonctif et supposent deux sujets différents.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9b5fe8a8-6679-5c24-b152-a4e03a580209', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : la cause, la conséquence et le but', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e15e5f72-58a0-58ca-996d-5ba89c87d571', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Complète : « Il a réussi ___ il a beaucoup travaillé. » (cause, justification soutenue)', '[{"id":"a","text":"à cause de"},{"id":"b","text":"donc"},{"id":"c","text":"car"},{"id":"d","text":"pour que"}]'::jsonb, 'c', '« Car » introduit une justification (+ verbe conjugué) après la principale : il a réussi, car il a travaillé. « À cause de » exige un nom, « donc » marque la conséquence (et non la cause), « pour que » un but au subjonctif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4de3d740-47b9-500f-9f63-10bcc258a412', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Complète : « Le film était ___ long que plusieurs spectateurs sont partis. »', '[{"id":"a","text":"tant"},{"id":"b","text":"si"},{"id":"c","text":"tellement de"},{"id":"d","text":"tant de"}]'::jsonb, 'b', 'L''intensité porte sur l''adjectif « long » → « si » (ou « tellement ») + adjectif + que : si long que. « Tant » s''emploie avec un verbe ; « tant de » et « tellement de » devant un nom, pas devant un adjectif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('441d792c-be6e-511c-b150-40ac080d4120', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Complète : « Il a neigé toute la nuit, ___ les routes sont bloquées. » (conséquence, registre formel)', '[{"id":"a","text":"du coup"},{"id":"b","text":"puisque"},{"id":"c","text":"faute de"},{"id":"d","text":"par conséquent"}]'::jsonb, 'd', '« Par conséquent » introduit une conséquence dans un registre formel : les routes sont bloquées. « Du coup » est familier (à éviter à l''écrit soigné), « puisque » introduit une cause, et « faute de » un manque (+ nom).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('504e893b-af7e-5268-afc9-b622613e8654', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je note tout pour ne rien oublier."},{"id":"b","text":"Je note tout afin de ne rien oublier."},{"id":"c","text":"Je note tout de peur de tout oublier."},{"id":"d","text":"Je note tout pour que je n''oublie rien."}]'::jsonb, 'd', 'Quand le sujet est le même (je note / je n''oublie), on emploie « pour » + infinitif : pour ne rien oublier. « Pour que » + subjonctif est réservé à deux sujets différents ; ici, « pour que je » est maladroit et fautif. Les options (a), (b) et (c) utilisent correctement l''infinitif (même sujet).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bb643aa-76d2-5201-b2f9-0416da26f4b2', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Complète : « Elle a tellement insisté ___ j''ai fini par accepter. »', '[{"id":"a","text":"que"},{"id":"b","text":"pour que"},{"id":"c","text":"à cause que"},{"id":"d","text":"afin que"}]'::jsonb, 'a', 'Le piège courant : « tellement » + verbe appelle « que » pour introduire la conséquence : elle a tellement insisté que j''ai accepté. « Pour que » et « afin que » introduiraient un but au subjonctif, et « à cause que » est incorrect en français standard.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2bb905f-b0d4-5d25-b77a-d929d21e7a9c', '9b5fe8a8-6679-5c24-b152-a4e03a580209', 'Complète : « ___ que le climat se réchauffe, il faut réduire les émissions. » (cause posée comme un fait admis)', '[{"id":"a","text":"Grâce à"},{"id":"b","text":"Afin"},{"id":"c","text":"Étant donné"},{"id":"d","text":"De peur"}]'::jsonb, 'c', '« Étant donné que » + verbe pose une cause comme un fait admis : étant donné que le climat se réchauffe. « Grâce à » exige un nom, « afin que » introduit un but au subjonctif, et « de peur que » un but négatif — aucun n''exprime ici la cause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3abcd171-b909-548d-be87-313b4dd9a9a8', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : la cause, la conséquence et le but', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc349f38-eee6-5ed4-ac64-671c8868b1ba', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"En raison de la grève, le trafic est perturbé."},{"id":"b","text":"À cause de la grève, j''ai manqué mon vol."},{"id":"c","text":"Grâce à la grève, des milliers de voyageurs sont restés bloqués."},{"id":"d","text":"Faute de personnel, le guichet est fermé."}]'::jsonb, 'c', 'Le piège courant : « grâce à » exprime une cause POSITIVE (un bénéfice). Devant un résultat fâcheux (des voyageurs bloqués), il faut « à cause de » ou « en raison de ». Les options (a), (b) et (d) emploient correctement « en raison de », « à cause de » et « faute de » + nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('160e19fc-e086-58c7-bb55-fd80b1c4ec81', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Complète : « Il avait ___ peur ___ il n''osait pas bouger. » (intensité sur un nom)', '[{"id":"a","text":"tellement de … que"},{"id":"b","text":"si … que"},{"id":"c","text":"tant … que"},{"id":"d","text":"si … pour que"}]'::jsonb, 'a', '« Peur » est ici un nom → « tellement de » (ou « tant de ») + nom + que : tellement de peur qu''il n''osait pas bouger. « Si » et « tant » seuls ne précèdent pas un nom, et « pour que » introduirait un but, non une conséquence.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95466827-f160-5b79-aaf7-17aa03a08db3', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Choisis la phrase CORRECTE et la plus naturelle.', '[{"id":"a","text":"Je baisse le son afin que les voisins ne se plaignent."},{"id":"b","text":"Je baisse le son afin que les voisins ne se plaindront pas."},{"id":"c","text":"Je baisse le son afin de les voisins ne se plaignent pas."},{"id":"d","text":"Je baisse le son afin que les voisins ne se plaignent pas."}]'::jsonb, 'd', 'Deux sujets (je / les voisins) → « afin que » + subjonctif, avec la négation complète « ne… pas » : afin que les voisins ne se plaignent pas. La (a) omet « pas », la (b) met le futur (interdit après afin que), la (c) confond « afin de » (+ infinitif, même sujet) avec « afin que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18ad233d-ea03-5255-9f01-a7b403713294', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Complète : « ___ tu connais déjà la réponse, pourquoi me la demander ? »', '[{"id":"a","text":"Parce que"},{"id":"b","text":"Puisque"},{"id":"c","text":"Pour que"},{"id":"d","text":"Si bien que"}]'::jsonb, 'b', 'La cause est présentée comme déjà connue et partagée → « puisque » : puisque tu connais la réponse. « Parce que » répond à « pourquoi ? » (information nouvelle), « pour que » marque un but au subjonctif, et « si bien que » une conséquence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6d774a8-e7b0-5151-991c-615a84da466a', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Il a tant de soucis qu''il n''arrive plus à dormir."},{"id":"b","text":"La pièce était si sombre qu''on ne voyait rien."},{"id":"c","text":"Il a si de travail qu''il a refusé l''invitation."},{"id":"d","text":"Elle parle si vite qu''on la comprend mal."}]'::jsonb, 'c', '« Si de » n''existe pas : devant le nom « travail », il faut « tant de » ou « tellement de » (tant de travail qu''il a refusé). Les options (a) « tant de » + nom, (b) « si » + adjectif et (d) « si » + adverbe sont toutes correctes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('921d8f08-0971-5d3b-86ec-23599e42b643', '3abcd171-b909-548d-be87-313b4dd9a9a8', 'Complète : « Le pont a été fermé ___ travaux, ___ les habitants doivent faire un détour. »', '[{"id":"a","text":"pour … parce que"},{"id":"b","text":"grâce à … car"},{"id":"c","text":"afin de … puisque"},{"id":"d","text":"à cause de … donc"}]'::jsonb, 'd', 'Premier vide : cause + nom à valeur négative → « à cause des travaux ». Second vide : conséquence → « donc » (les habitants doivent faire un détour). « Grâce à » serait positif, et les autres mélangent but/cause de façon incohérente avec l''enchaînement logique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0616886d-5c59-5428-9177-7919f9b703a0', 'eaea941b-2e48-5372-bdb2-91a920a0be6d', 'francais-b2', '⭐⭐ Drill : la cause, la conséquence et le but', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1beeb09e-5228-5c7d-927f-3917be849af4', '0616886d-5c59-5428-9177-7919f9b703a0', 'Complète : « ___ une bonne carte, nous avons retrouvé le chemin. » (cause positive + nom)', '[{"id":"a","text":"Grâce à"},{"id":"b","text":"À cause de"},{"id":"c","text":"Comme"},{"id":"d","text":"Pour que"}]'::jsonb, 'a', 'Résultat heureux + nom → « grâce à » : grâce à une bonne carte. « À cause de » serait négatif/neutre, « comme » introduit une cause avec un verbe en tête de phrase, et « pour que » un but au subjonctif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b1fbfc7-59b3-5508-bec7-a0710157eea6', '0616886d-5c59-5428-9177-7919f9b703a0', 'Complète : « ___ le magasin était fermé, nous sommes rentrés. » (cause en tête de phrase)', '[{"id":"a","text":"Car"},{"id":"b","text":"Comme"},{"id":"c","text":"Par conséquent"},{"id":"d","text":"Afin que"}]'::jsonb, 'b', 'En début de phrase, la cause s''introduit par « comme » + verbe : Comme le magasin était fermé… « Car » ne se met jamais en tête de phrase, « par conséquent » marque la conséquence, et « afin que » un but au subjonctif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa5087ed-cd43-5670-9f3c-4db6a490744d', '0616886d-5c59-5428-9177-7919f9b703a0', 'Complète : « Parle plus fort ___ tout le monde t''entende. » (deux sujets)', '[{"id":"a","text":"pour"},{"id":"b","text":"parce que"},{"id":"c","text":"pour que"},{"id":"d","text":"si bien que"}]'::jsonb, 'c', 'Sujets différents (tu parles / tout le monde entend) → « pour que » + subjonctif : pour que tout le monde t''entende. « Pour » + infinitif supposerait le même sujet, « parce que » marque la cause, et « si bien que » la conséquence.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9613bc6-b5ec-5e2f-a0af-6c2a9a2e510e', '0616886d-5c59-5428-9177-7919f9b703a0', 'Complète : « Il y avait ___ monde que nous n''avons pas pu entrer. »', '[{"id":"a","text":"si"},{"id":"b","text":"tant"},{"id":"c","text":"tant de"},{"id":"d","text":"tellement"}]'::jsonb, 'c', '« Monde » est un nom → « tant de » (ou « tellement de ») + nom + que : tant de monde que nous n''avons pas pu entrer. « Si », « tant » et « tellement » seuls s''emploient devant un adjectif, un adverbe ou un verbe, pas devant un nom.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ccfaa651-daa8-511a-bff2-74bd40942344', '0616886d-5c59-5428-9177-7919f9b703a0', 'Quelle phrase est CORRECTE ?', '[{"id":"a","text":"Il est parti tôt parce que la circulation."},{"id":"b","text":"Il est parti tôt pour que la circulation."},{"id":"c","text":"Il est parti tôt donc la circulation."},{"id":"d","text":"Il est parti tôt en raison de la circulation."}]'::jsonb, 'd', 'Devant le nom « la circulation », on emploie « en raison de » (cause formelle). « Parce que » exige un verbe conjugué, « pour que » un but au subjonctif, et « donc » introduit une conséquence — aucun ne précède directement un simple nom ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('881277db-9c38-53b9-97f6-1da854e878b9', '0616886d-5c59-5428-9177-7919f9b703a0', 'Complète : « Il chuchote ___ réveiller son frère. » (même sujet, but : éviter)', '[{"id":"a","text":"de peur de"},{"id":"b","text":"de peur que"},{"id":"c","text":"grâce à"},{"id":"d","text":"à cause de"}]'::jsonb, 'a', 'Même sujet (il chuchote / il pourrait réveiller) → « de peur de » + infinitif : de peur de réveiller son frère. « De peur que » + subjonctif s''emploierait avec deux sujets, tandis que « grâce à » et « à cause de » introduisent une cause + nom, pas un but.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('63a33250-3d2a-5e8a-b036-f2a924e1c260', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f555ccea-bb84-5b96-b8d7-54df979583ec', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'Complète : « ___ il soit malade, il est venu travailler. »', '[{"id":"a","text":"Bien qu''"},{"id":"b","text":"Même si"},{"id":"c","text":"Malgré"},{"id":"d","text":"Alors qu''"}]'::jsonb, 'a', '« Bien que » introduit une concession et se construit avec le subjonctif : « bien qu''il soit malade ». « Même si » exigerait l''indicatif (soit est subjonctif), « malgré » se construit avec un nom, et « alors que » marque l''opposition + indicatif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63d18b5d-1c22-57a7-857a-bbb8aa9434bb', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'Quelle phrase exprime une OPPOSITION (deux faits contrastés, sans obstacle) ?', '[{"id":"a","text":"Bien qu''il pleuve, nous sortons."},{"id":"b","text":"Mon frère aime le sport, alors que moi je préfère lire."},{"id":"c","text":"Malgré la fatigue, il continue."},{"id":"d","text":"Il a beau insister, je refuse."}]'::jsonb, 'b', '« Alors que » met deux situations en contraste parallèle (le sport / la lecture) : c''est de l''opposition. Les phrases (a), (c) et (d) expriment une concession (un obstacle franchi : la pluie, la fatigue, l''insistance).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfbef0fb-500f-5eef-9f89-e61bcbae7c31', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'Complète : « ___ ses efforts, il n''a pas réussi l''examen. »', '[{"id":"a","text":"Bien que"},{"id":"b","text":"Malgré"},{"id":"c","text":"Quoique"},{"id":"d","text":"Pourtant"}]'::jsonb, 'b', '« Malgré » se construit directement avec un nom : « malgré ses efforts ». « Bien que » et « quoique » introduiraient une proposition au subjonctif, et « pourtant » est un adverbe qui relie deux phrases, pas une préposition devant un nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b95459fd-c20c-592b-954e-45ee7e590e42', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'Complète : « ___ tu travailles dur, tu n''auras pas de promotion cette année. »', '[{"id":"a","text":"Même si"},{"id":"b","text":"Au lieu de"},{"id":"c","text":"Contrairement à"},{"id":"d","text":"Malgré"}]'::jsonb, 'a', '« Même si » introduit une concession suivie de l''indicatif (« tu travailles ») : c''est correct. « Au lieu de » demande un infinitif, « contrairement à » un nom, et « malgré » un nom — aucun ne peut précéder « tu travailles » conjugué ainsi.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62c0d8b1-3da2-5876-866a-0a7c83c44f3b', '63a33250-3d2a-5e8a-b036-f2a924e1c260', 'Quelle phrase est correcte ?', '[{"id":"a","text":"Bien qu''il est riche, il vit simplement."},{"id":"b","text":"Malgré qu''il pleuve, ils sortent."},{"id":"c","text":"Il a beau crier, personne ne l''entend."},{"id":"d","text":"Même si je sois fatigué, je continue."}]'::jsonb, 'c', '« Avoir beau + infinitif » exprime un effort vain et est parfaitement correct : « il a beau crier ». (a) est faux (bien que + subjonctif : « soit »), (b) emploie « malgré que » à éviter (dire « bien qu''il pleuve »), et (d) est faux (même si + indicatif : « suis »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', '⭐ Entraînement : opposition et concession', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bede61b-1f61-5757-9f76-6bf07e291f14', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Quel connecteur introduit une CONCESSION (un obstacle qui n''empêche pas le résultat) ?', '[{"id":"a","text":"alors que"},{"id":"b","text":"tandis que"},{"id":"c","text":"bien que"},{"id":"d","text":"contrairement à"}]'::jsonb, 'c', '« Bien que » exprime la concession : un obstacle franchi (« bien qu''il pleuve, on sort »). « Alors que » et « tandis que » marquent l''opposition (deux faits contrastés), et « contrairement à » oppose un nom à un autre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e657c0-75d9-5d90-9b05-52c6eafc4e2c', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Complète : « ___ la pluie, le match a eu lieu. »', '[{"id":"a","text":"Même si"},{"id":"b","text":"Bien que"},{"id":"c","text":"Pourtant"},{"id":"d","text":"Malgré"}]'::jsonb, 'd', '« Malgré » se construit avec un nom : « malgré la pluie ». « Bien que » et « même si » introduisent une proposition (un verbe conjugué), et « pourtant » est un adverbe qui relie deux phrases, non une préposition devant un nom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca9e04d6-bdc8-57cb-93e2-e1816f2e4048', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Complète au bon mode : « Bien qu''il ___ tort, il refuse de l''admettre. »', '[{"id":"a","text":"a"},{"id":"b","text":"ait"},{"id":"c","text":"aura"},{"id":"d","text":"avait"}]'::jsonb, 'b', 'Après « bien que », on emploie toujours le subjonctif : « bien qu''il ait tort ». « a » (indicatif présent), « aura » (futur) et « avait » (imparfait) sont tous incorrects après cette conjonction concessive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd918a33-eef5-5a85-bce3-c69655dac396', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Quelle phrase exprime une OPPOSITION entre deux personnes ?', '[{"id":"a","text":"Même si elle est jeune, elle est très sage."},{"id":"b","text":"Lui est bavard, alors qu''elle est silencieuse."},{"id":"c","text":"Malgré son âge, il court vite."},{"id":"d","text":"Il a beau étudier, il oublie tout."}]'::jsonb, 'b', '« Alors que » oppose deux comportements parallèles (bavard / silencieuse) : c''est de l''opposition. Les phrases (a), (c) et (d) sont concessives : elles présentent un obstacle franchi (jeunesse, âge, étude vaine).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a0c00e0-0b10-5ce9-97a5-f372e6c3c0a1', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Complète : « ___ te plaindre, propose une solution. »', '[{"id":"a","text":"Tandis que"},{"id":"b","text":"Malgré"},{"id":"c","text":"Bien que"},{"id":"d","text":"Au lieu de"}]'::jsonb, 'd', '« Au lieu de » se construit avec un infinitif et exprime une substitution oppositive : « au lieu de te plaindre ». « Malgré » demande un nom, « bien que » un subjonctif, et « tandis que » un verbe conjugué à l''indicatif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ec82fde-d43b-5d6c-adae-733173ce6e18', 'c7f9d2fc-61f4-50fd-8cb4-81a7811801b4', 'Quel adverbe peut compléter : « Il avait tout révisé ; ___, il a échoué. » ?', '[{"id":"a","text":"donc"},{"id":"b","text":"pourtant"},{"id":"c","text":"ainsi"},{"id":"d","text":"par exemple"}]'::jsonb, 'b', '« Pourtant » marque la concession entre deux phrases : un résultat contraire à l''attente (réviser → échouer). « Donc » et « ainsi » expriment la conséquence logique, et « par exemple » introduit une illustration, pas une opposition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2a5403ce-d37b-5c28-8f5a-80004c352faa', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', '⭐⭐ Révision : opposition et concession', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcb4506b-476e-5fb9-acda-8695b48695b2', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Complète au bon mode : « Quoiqu''elle ___ peu d''expérience, on l''a embauchée. »', '[{"id":"a","text":"a"},{"id":"b","text":"ait"},{"id":"c","text":"avait"},{"id":"d","text":"aurait"}]'::jsonb, 'b', '« Quoique » (= bien que) introduit la concession et exige le subjonctif : « quoiqu''elle ait peu d''expérience ». L''indicatif (« a », « avait ») et le conditionnel (« aurait ») sont incorrects après cette conjonction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59bf4fd0-314e-5be2-bd0c-ad151472fa5f', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Même si tu insistes, je refuse."},{"id":"b","text":"Malgré son retard, il a été reçu."},{"id":"c","text":"Même si tu sois là, je partirai."},{"id":"d","text":"Bien qu''il fasse froid, je sors."}]'::jsonb, 'c', 'La faute est en (c) : « même si » se construit à l''INDICATIF, jamais au subjonctif. Il faut dire « même si tu es là ». Les phrases (a), (b) et (d) sont correctes (même si + indicatif, malgré + nom, bien que + subjonctif).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb01bbb8-a77e-5719-a592-e80ddcf0cca0', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Complète : « ___ son frère qui est sportif, lui déteste l''effort. »', '[{"id":"a","text":"Pourtant"},{"id":"b","text":"Bien que"},{"id":"c","text":"Au lieu de"},{"id":"d","text":"Contrairement à"}]'::jsonb, 'd', '« Contrairement à » se construit avec un nom ou un pronom et oppose deux personnes : « contrairement à son frère ». « Bien que » demande un subjonctif, « au lieu de » un infinitif, et « pourtant » relie deux phrases complètes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dc5e1b3-7423-5e0e-ad8d-810e46fd93ba', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Reformule « Il travaille beaucoup mais il échoue toujours » avec « avoir beau ».', '[{"id":"a","text":"Il a beau travailler beaucoup, il échoue toujours."},{"id":"b","text":"Il a beau de travailler, il échoue toujours."},{"id":"c","text":"Il a beau qu''il travaille, il échoue toujours."},{"id":"d","text":"Il a beaucoup travaillé, il échoue toujours."}]'::jsonb, 'a', '« Avoir beau » se construit directement avec un infinitif : « il a beau travailler ». On ne dit pas « avoir beau de » (b) ni « avoir beau que » (c) ; la phrase (d) supprime l''idée de concession et devient une simple succession de faits.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c958e294-ac12-5f97-9425-b0103452af0f', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Choisis le connecteur d''opposition de registre SOUTENU.', '[{"id":"a","text":"mais"},{"id":"b","text":"par contre"},{"id":"c","text":"en revanche"},{"id":"d","text":"quand même"}]'::jsonb, 'c', '« En revanche » est le connecteur d''opposition de registre soutenu, préféré à l''écrit formel. « Par contre » est courant (parfois critiqué à l''écrit), « mais » est neutre/courant, et « quand même » est un adverbe concessif familier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02d090cb-7703-5812-857d-ae025a2fd98a', '2a5403ce-d37b-5c28-8f5a-80004c352faa', 'Quelle phrase signifie « peu importe ce que tu dises, je ne changerai pas d''avis » ?', '[{"id":"a","text":"Quoi que tu dises, je ne changerai pas d''avis."},{"id":"b","text":"Quoique tu sois convaincant, je ne changerai pas d''avis."},{"id":"c","text":"Bien que tu le répètes, je ne changerai pas d''avis."},{"id":"d","text":"Alors que tu insistes, je ne changerai pas d''avis."}]'::jsonb, 'a', '« Quoi que » en deux mots signifie « peu importe ce que » : « quoi que tu dises ». À ne pas confondre avec « quoique » en un mot (= bien que, concession), qui exprime un fait concédé, non l''idée de « n''importe quoi ». « Bien que » et « alors que » n''ont pas ce sens d''indéfini.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c8e4fbf7-0436-5edc-8163-4913263031f5', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : opposition et concession', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3788d7c7-4ff1-508c-a763-fdae4145a471', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Complète au bon mode : « Bien que le projet ___ ambitieux, l''équipe l''a mené à bien. »', '[{"id":"a","text":"est"},{"id":"b","text":"sera"},{"id":"c","text":"était"},{"id":"d","text":"soit"}]'::jsonb, 'd', 'Règle : « bien que » + subjonctif → « bien que le projet soit ambitieux ». L''indicatif « est » est la faute la plus courante après « bien que » ; « sera » (futur) et « était » (imparfait indicatif) sont aussi incorrects après cette conjonction concessive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('669bde6f-6372-5e33-986e-d2f88e2cfed6', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Malgré qu''il pleuve, le défilé est maintenu."},{"id":"b","text":"Bien qu''il pleuve, le défilé est maintenu."},{"id":"c","text":"Malgré la pluie, le défilé est maintenu."},{"id":"d","text":"Même s''il pleut, le défilé est maintenu."}]'::jsonb, 'a', 'La faute est en (a) : « malgré que » est une construction critiquée et fautive. « Malgré » doit précéder un nom (c). Pour une proposition, on dit « bien qu''il pleuve » (b, subjonctif) ou « même s''il pleut » (d, indicatif).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e63b5a2c-366f-5cc0-91b4-4b5a25612fe0', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Complète l''opposition au bon mode : « Mon collègue arrive toujours en avance, tandis que moi j''___ souvent en retard. »', '[{"id":"a","text":"arriverais"},{"id":"b","text":"arrive"},{"id":"c","text":"sois arrivé"},{"id":"d","text":"arrivasse"}]'::jsonb, 'b', '« Tandis que » marque l''opposition et se construit à l''INDICATIF : « tandis que j''arrive souvent en retard ». Le piège est d''employer le conditionnel (« arriverais ») ou le subjonctif (« sois arrivé », « arrivasse »), comme on le ferait à tort par analogie avec « bien que ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5de26c68-9d9c-5236-851c-62c0f1669523', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Quelle phrase exprime correctement un effort vain avec « avoir beau » ?', '[{"id":"a","text":"J''ai beau de lui expliquer, il ne comprend pas."},{"id":"b","text":"J''ai beau que je lui explique, il ne comprend pas."},{"id":"c","text":"J''ai beau lui expliquer, il ne comprend pas."},{"id":"d","text":"J''ai eu beau de lui expliquer, il ne comprenait pas."}]'::jsonb, 'c', '« Avoir beau » + infinitif direct : « j''ai beau lui expliquer ». On n''ajoute jamais « de » (a, d) ni « que » + proposition (b). Le verbe « avoir » se conjugue selon le temps, mais l''infinitif qui suit reste sans préposition.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a0d0d6d-abaa-5e6e-a1a3-9c30bc8fa984', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Choisis le connecteur le plus approprié : « Le candidat manquait d''expérience ; ___, son enthousiasme a convaincu le jury. »', '[{"id":"a","text":"par conséquent"},{"id":"b","text":"en effet"},{"id":"c","text":"néanmoins"},{"id":"d","text":"c''est-à-dire"}]'::jsonb, 'c', '« Néanmoins » (adverbe concessif soutenu) introduit un résultat contraire à l''attente : malgré le manque d''expérience, le jury est convaincu. « Par conséquent » exprime la conséquence, « en effet » la confirmation/cause, et « c''est-à-dire » la reformulation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6ef7c58-3bb2-5bde-8e3e-a86590fe5db4', 'c8e4fbf7-0436-5edc-8163-4913263031f5', 'Reformule sans changer le sens : « Il est très intelligent, pourtant il a raté l''épreuve. »', '[{"id":"a","text":"Bien qu''il soit très intelligent, il a raté l''épreuve."},{"id":"b","text":"Parce qu''il est très intelligent, il a raté l''épreuve."},{"id":"c","text":"Au lieu d''être intelligent, il a raté l''épreuve."},{"id":"d","text":"Alors qu''il a raté l''épreuve, il est intelligent."}]'::jsonb, 'a', '« Pourtant » exprime la concession ; on le reformule par « bien que + subjonctif » : « bien qu''il soit très intelligent, il a raté l''épreuve ». (b) exprime la cause (faux sens), (c) détourne le sens, et (d) inverse la logique sans rendre la concession.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d52ba9dd-8628-5384-b784-8786f4101f55', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : opposition et concession', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7696313-82c8-5fb4-aa4f-f1003db13032', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Lis : « Les ventes ont chuté au troisième trimestre. La direction, ___, reste optimiste : ___ la conjoncture difficile, un nouveau produit doit relancer la croissance. » Choisis la paire correcte.', '[{"id":"a","text":"par conséquent … grâce à"},{"id":"b","text":"cependant … malgré"},{"id":"c","text":"cependant … bien que"},{"id":"d","text":"en effet … malgré"}]'::jsonb, 'b', 'Lacune 1 : « cependant » (adverbe concessif) oppose l''optimisme à la chute des ventes. Lacune 2 : « malgré » + nom (« malgré la conjoncture difficile »). (a) « par conséquent » exprime une conséquence, faux ici, et « grâce à » est positif. (c) « bien que » exigerait un verbe au subjonctif, pas le nom « la conjoncture ». (d) « en effet » confirme au lieu d''opposer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b13f5009-51c4-58ef-92d5-195057b88874', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Trouve la SEULE phrase entièrement correcte.', '[{"id":"a","text":"Bien qu''il pleuve et que le vent souffle fort, malgré qu''il fasse froid, la course est maintenue."},{"id":"b","text":"Même s''il pleuve, la course est maintenue."},{"id":"c","text":"Alors qu''il fasse froid, la course est maintenue."},{"id":"d","text":"Bien qu''il pleuve et que le vent souffle, la course est maintenue."}]'::jsonb, 'd', '(d) est correcte : « bien que » + subjonctif, répété par « que » (« qu''il pleuve et que le vent souffle »). (a) contient « malgré que », fautif. (b) emploie le subjonctif après « même si » (il faut « même s''il pleut »). (c) met « alors que » au subjonctif (il faut l''indicatif « alors qu''il fait froid »), et le sens devrait être concessif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0f7ee4a-153b-54b7-9b68-6aebe113938e', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Quelle reformulation conserve EXACTEMENT le sens de : « Il a beau être riche, il n''est pas heureux. » ?', '[{"id":"a","text":"Bien qu''il soit riche, il n''est pas heureux."},{"id":"b","text":"Parce qu''il est riche, il n''est pas heureux."},{"id":"c","text":"S''il était riche, il ne serait pas heureux."},{"id":"d","text":"Comme il est riche, il n''est pas heureux."}]'::jsonb, 'a', '« Avoir beau + infinitif » équivaut à « bien que + subjonctif » : « bien qu''il soit riche, il n''est pas heureux ». (b) « parce que » et (d) « comme » expriment la cause (contresens), et (c) introduit une hypothèse irréelle au lieu d''un fait concédé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ac38ad5-6285-54c0-84c0-a94459926048', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Complète cette phrase argumentative soutenue : « ___ les critiques aient été nombreuses, la réforme a été adoptée ; ___ ses partisans, elle ne réglera pourtant pas tout. »', '[{"id":"a","text":"Quoique … malgré"},{"id":"b","text":"Même si … contrairement à"},{"id":"c","text":"Quoique … contrairement à"},{"id":"d","text":"Alors que … selon"}]'::jsonb, 'c', 'Lacune 1 : « quoique » + subjonctif (« aient été ») = concession soutenue, correct. Lacune 2 : « contrairement à » + nom (« contrairement à ses partisans ») oppose deux points de vue. (a) « malgré » + nom serait possible mais perd l''idée d''opposition entre avis. (b) « même si » exige l''indicatif, pas « aient été » (subjonctif). (d) « alors que » + subjonctif est fautif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00a0506c-e35f-5dd5-84a8-669f833b1697', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Repère la phrase qui présente un MÉLANGE de registres incohérent.', '[{"id":"a","text":"Le bilan est mitigé ; néanmoins, les perspectives demeurent encourageantes."},{"id":"b","text":"Le bilan est négatif ; néanmoins, c''est carrément génial."},{"id":"c","text":"Le bilan est décevant ; toutefois, des progrès notables sont à signaler."},{"id":"d","text":"Le bilan est fragile ; cependant, la tendance reste favorable."}]'::jsonb, 'b', '(b) associe le connecteur très soutenu « néanmoins » à l''expression familière « carrément génial » : c''est une rupture de registre. (a), (c) et (d) combinent un connecteur soutenu (néanmoins, toutefois, cependant) avec un vocabulaire formel cohérent — registres homogènes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d263e49-3375-5fdf-8cd1-d8841b07084b', 'd52ba9dd-8628-5384-b784-8786f4101f55', 'Choisis la version la plus correcte ET la plus soutenue pour un texte argumentatif.', '[{"id":"a","text":"Au lieu de réduire les coûts, la mesure les a augmenté ; par contre, le service il s''est amélioré."},{"id":"b","text":"Malgré réduire les coûts, la mesure les a augmentés ; mais le service s''est amélioré."},{"id":"c","text":"Bien que réduire les coûts, la mesure les a augmentés ; pourtant le service il a progressé."},{"id":"d","text":"Au lieu de réduire les coûts, la mesure les a augmentés ; en revanche, la qualité du service a progressé."}]'::jsonb, 'd', '(d) est correcte et soutenue : « au lieu de » + infinitif, accord « augmentés » (les = coûts, masc. pluriel), « en revanche » (opposition soutenue). (a) a une faute d''accord (« augmenté ») et un sujet redoublé familier (« le service il »). (b) emploie « malgré » + infinitif (fautif). (c) emploie « bien que » + infinitif (fautif) et un sujet redoublé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', '58b3368f-67ec-5feb-8ca8-6102e923b4b2', 'francais-b2', '⭐⭐ Drill : opposition et concession', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d543d1f6-525e-5244-a3b4-a62b9c0dd961', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Complète : « ___ ses promesses, le maire n''a rien changé. »', '[{"id":"a","text":"Bien que"},{"id":"b","text":"En dépit de"},{"id":"c","text":"Tandis que"},{"id":"d","text":"Au lieu de"}]'::jsonb, 'b', '« En dépit de » (= malgré) se construit avec un nom : « en dépit de ses promesses ». « Bien que » demande un subjonctif, « tandis que » un verbe à l''indicatif, et « au lieu de » un infinitif — aucun ne précède directement le nom « ses promesses ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b1af8ea-424e-5007-9764-9a5083b33b1c', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Complète au bon mode : « Quoique la tâche ___ difficile, nous la terminerons. »', '[{"id":"a","text":"soit"},{"id":"b","text":"est"},{"id":"c","text":"sera"},{"id":"d","text":"serait"}]'::jsonb, 'a', '« Quoique » (concession) exige le subjonctif : « quoique la tâche soit difficile ». L''indicatif « est », le futur « sera » et le conditionnel « serait » sont incorrects après cette conjonction, exactement comme après « bien que ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbdd9c1f-933f-5564-8431-0d6d50c60b5b', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Quelle phrase exprime une OPPOSITION et non une concession ?', '[{"id":"a","text":"Bien qu''il soit calme, il s''est emporté."},{"id":"b","text":"Malgré son calme, il s''est emporté."},{"id":"c","text":"L''aîné est calme, tandis que le cadet est turbulent."},{"id":"d","text":"Il a beau rester calme, on le provoque."}]'::jsonb, 'c', '« Tandis que » oppose deux personnes aux comportements parallèles (calme / turbulent) : opposition. Les phrases (b), (c) et (d) sont concessives : un obstacle (le calme) franchi par un résultat contraire (s''emporter, être provoqué).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ee379cb-408e-5aca-ae45-a2b16f1098c7', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Contrairement à ses habitudes, il est arrivé tôt."},{"id":"b","text":"Au lieu de dormir, elle a révisé."},{"id":"c","text":"Malgré sa fatigue, elle a révisé."},{"id":"d","text":"Contrairement à dormir, elle a révisé."}]'::jsonb, 'd', 'La faute est en (d) : « contrairement à » se construit avec un NOM ou un pronom, pas avec un verbe à l''infinitif. Pour opposer une action, on dit « au lieu de dormir » (b). Les phrases (a) et (c) sont correctes (contrairement à + nom, malgré + nom).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6dd39785-8161-52c9-afa0-e3dfb1281b07', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Complète : « ___ il fasse beau, nous restons à l''intérieur pour réviser. »', '[{"id":"a","text":"Parce qu''"},{"id":"b","text":"Bien qu''"},{"id":"c","text":"Puisqu''"},{"id":"d","text":"Dès qu''"}]'::jsonb, 'b', 'Le sens est concessif (le beau temps devrait nous faire sortir, mais non) et le verbe « fasse » est au subjonctif : seul « bien que » convient. « Parce que » et « puisque » expriment la cause (+ indicatif), et « dès que » le temps (+ indicatif).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9d7b466-7ea0-5559-b03e-54d62b5e8564', 'ebbab040-3f8e-5fa7-a7bb-1e64f14f1161', 'Reformule « Malgré sa préparation, il a eu le trac » avec une proposition concessive correcte.', '[{"id":"a","text":"Bien qu''il se soit préparé, il a eu le trac."},{"id":"b","text":"Malgré qu''il se soit préparé, il a eu le trac."},{"id":"c","text":"Bien qu''il s''est préparé, il a eu le trac."},{"id":"d","text":"Alors qu''il se soit préparé, il a eu le trac."}]'::jsonb, 'a', 'Pour transformer « malgré + nom » en proposition, on emploie « bien que + subjonctif » : « bien qu''il se soit préparé ». (b) « malgré que » est fautif, (c) met l''indicatif « s''est » après « bien que » (faute), et (d) emploie « alors que » au subjonctif (incorrect).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('07e0bb6f-2cae-5349-9507-63abee100a22', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afe1b298-7994-52cf-b143-3fba3e3ce564', '07e0bb6f-2cae-5349-9507-63abee100a22', 'Complète : « La chaise ___ je suis assis est cassée. »', '[{"id":"a","text":"sur laquelle"},{"id":"b","text":"sur lequel"},{"id":"c","text":"sur lesquelles"},{"id":"d","text":"qui"}]'::jsonb, 'a', 'Après la préposition « sur », on emploie un pronom composé accordé à l''antécédent : « la chaise » est féminin singulier, donc « sur laquelle ». « sur lequel » est masculin, « sur lesquelles » est un pluriel, et « qui » après préposition est réservé aux personnes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5acf0b68-8b26-5064-9f12-1a2374156200', '07e0bb6f-2cae-5349-9507-63abee100a22', 'Complète : « Voici le projet ___ je pense depuis longtemps. »', '[{"id":"a","text":"à lequel"},{"id":"b","text":"auquel"},{"id":"c","text":"à laquelle"},{"id":"d","text":"auxquels"}]'::jsonb, 'b', 'On dit penser À quelque chose ; « à » se contracte avec « lequel » (masculin singulier, comme « le projet ») et donne « auquel » : le projet auquel je pense. « à lequel » n''existe pas, « à laquelle » est féminin, et « auxquels » est un pluriel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c76be11-47c0-5e7b-8e4f-e420247a226d', '07e0bb6f-2cae-5349-9507-63abee100a22', 'Complète : « Les collègues ___ je travaille sont sympathiques. »', '[{"id":"a","text":"avec lequel"},{"id":"b","text":"dont"},{"id":"c","text":"avec qui"},{"id":"d","text":"auxquels"}]'::jsonb, 'c', 'Pour des personnes après une préposition, « avec qui » est la tournure naturelle : les collègues avec qui je travaille. « avec lequel » serait un masculin singulier (incorrect pour un pluriel), « dont » s''emploie avec « de », et « auxquels » conviendrait à penser à, pas à travailler avec.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d50d442b-7c36-5fbc-811c-b744dae91971', '07e0bb6f-2cae-5349-9507-63abee100a22', 'Complète : « C''est une décision ___ tu dois réfléchir sérieusement. »', '[{"id":"a","text":"auquel"},{"id":"b","text":"à lequel"},{"id":"c","text":"dont"},{"id":"d","text":"à laquelle"}]'::jsonb, 'd', 'On dit réfléchir À quelque chose ; « décision » est féminin singulier, donc « à laquelle » (le féminin singulier ne se contracte pas). « auquel » serait un masculin, « à lequel » n''existe pas, et « dont » s''emploie avec « de », pas avec « à ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44bde482-3c08-5156-af3d-f48689e4f293', '07e0bb6f-2cae-5349-9507-63abee100a22', 'Complète : « Le château ___ s''étend un grand parc appartient à la commune. »', '[{"id":"a","text":"dont"},{"id":"b","text":"au pied duquel"},{"id":"c","text":"au pied dont"},{"id":"d","text":"au pied de laquelle"}]'::jsonb, 'b', 'La locution « au pied de » se termine par « de » : on emploie alors « duquel » accordé à « le château » (masculin singulier), d''où « au pied duquel ». « dont » est interdit dans une locution prépositionnelle, « au pied dont » est impossible, et « de laquelle » serait un féminin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dfdd1549-d2d8-5b33-a133-a8380633fa49', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', '⭐ Entraînement : les pronoms relatifs composés', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd0b58ff-d025-5394-b12d-6cb2c0103ef9', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Complète : « Le stylo ___ j''écris est un cadeau. »', '[{"id":"a","text":"avec lequel"},{"id":"b","text":"avec laquelle"},{"id":"c","text":"avec lesquels"},{"id":"d","text":"avec qui"}]'::jsonb, 'a', 'Après la préposition « avec », on accorde le pronom composé à l''antécédent : « le stylo » est masculin singulier, donc « avec lequel ». « avec laquelle » est féminin, « avec lesquels » un pluriel, et « avec qui » est réservé aux personnes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26cc604e-e3d5-5046-b25e-208554e2e4a1', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Complète : « La maison ___ il habite est ancienne. »', '[{"id":"a","text":"dans lequel"},{"id":"b","text":"dans laquelle"},{"id":"c","text":"dans lesquelles"},{"id":"d","text":"dans qui"}]'::jsonb, 'b', 'Après « dans », on emploie un pronom composé accordé : « la maison » est féminin singulier, donc « dans laquelle ». « dans lequel » est masculin, « dans lesquelles » un pluriel, et « dans qui » est impossible (jamais « qui » pour une chose).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3bad32e8-38ec-5513-9a2e-5fc6b4b858b7', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Complète : « Les raisons ___ j''ai accepté sont personnelles. »', '[{"id":"a","text":"pour lequel"},{"id":"b","text":"pour laquelle"},{"id":"c","text":"pour lesquelles"},{"id":"d","text":"pour lesquels"}]'::jsonb, 'c', 'Après « pour », on accorde au pluriel féminin « les raisons » : « pour lesquelles ». « pour lesquels » serait un masculin pluriel, « pour lequel » et « pour laquelle » sont des singuliers — tous fautifs ici.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a58a6e46-c3dd-5a79-9e94-a3b0a2d67e40', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Complète : « Voici les amis ___ je pars en vacances. »', '[{"id":"a","text":"avec lequel"},{"id":"b","text":"avec laquelle"},{"id":"c","text":"dont"},{"id":"d","text":"avec qui"}]'::jsonb, 'd', 'Pour des personnes après une préposition, « avec qui » est la tournure naturelle : les amis avec qui je pars. « avec lequel » et « avec laquelle » sont des singuliers, et « dont » s''emploie avec « de », pas avec « avec ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c473681c-3940-51e2-bf2b-f4477bc41b92', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Complète : « Le défi ___ il fait face est immense. »', '[{"id":"a","text":"à lequel"},{"id":"b","text":"auquel"},{"id":"c","text":"à laquelle"},{"id":"d","text":"auxquels"}]'::jsonb, 'b', 'On dit faire face À quelque chose ; « à » se contracte avec « lequel » (masculin singulier, « le défi ») et donne « auquel ». « à lequel » n''existe pas, « à laquelle » est féminin, et « auxquels » est un pluriel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deba50ac-2dcb-5965-8da2-93aa4367f9e5', 'dfdd1549-d2d8-5b33-a133-a8380633fa49', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"La table sur laquelle je pose mes livres est solide."},{"id":"b","text":"Les outils avec lesquels il travaille sont neufs."},{"id":"c","text":"Le crayon avec qui je dessine est usé."},{"id":"d","text":"La salle dans laquelle nous étudions est calme."}]'::jsonb, 'c', 'La phrase incorrecte est la troisième : un crayon est une chose, donc « avec qui » est impossible ; il faut « avec lequel » (le crayon avec lequel je dessine). « qui » après préposition ne s''emploie que pour les personnes. Les autres accordent correctement le pronom composé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3858ed6f-755f-5881-9e51-8b30f788b3f5', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', '⭐⭐ Révision : les pronoms relatifs composés', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47c386cc-4768-54d1-8916-112d12a14994', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Complète : « Les problèmes ___ nous sommes confrontés sont nombreux. »', '[{"id":"a","text":"à lesquels"},{"id":"b","text":"auxquels"},{"id":"c","text":"auxquelles"},{"id":"d","text":"auquel"}]'::jsonb, 'b', 'On dit être confronté À quelque chose ; « à » + « lesquels » (masculin pluriel, « les problèmes ») se contracte en « auxquels ». « à lesquels » n''existe pas, « auxquelles » serait un féminin pluriel, et « auquel » un singulier.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3182459f-3998-52d7-8428-14e9a61c0985', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Complète : « C''est une cause ___ je me dévoue entièrement. »', '[{"id":"a","text":"auquel"},{"id":"b","text":"à lequel"},{"id":"c","text":"dont"},{"id":"d","text":"à laquelle"}]'::jsonb, 'd', 'On dit se dévouer À quelque chose ; « cause » est féminin singulier et « à laquelle » ne se contracte pas : la cause à laquelle je me dévoue. « auquel » serait un masculin, « à lequel » n''existe pas, et « dont » s''emploie avec « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a6aee27-c53d-58dd-bb2b-06b88d455ecd', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Complète : « La forêt au milieu ___ coule une rivière est protégée. »', '[{"id":"a","text":"de laquelle"},{"id":"b","text":"duquel"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'a', 'La locution « au milieu de » se termine par « de » : on emploie « de laquelle » accordé à « la forêt » (féminin singulier), qui ne se contracte pas. « duquel » serait un masculin, « dont » est interdit dans une locution, et « où » ne convient pas à « au milieu de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79d6abf6-c22b-5408-842e-7a993d376052', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Complète : « Le voisin ___ je m''adresse est très aimable. »', '[{"id":"a","text":"dont"},{"id":"b","text":"auxquels"},{"id":"c","text":"à qui"},{"id":"d","text":"à lequel"}]'::jsonb, 'c', 'On dit s''adresser À quelqu''un ; pour une personne, « à qui » est naturel : le voisin à qui je m''adresse (on pourrait aussi dire « auquel »). « dont » s''emploie avec « de », « auxquels » est un pluriel, et « à lequel » n''existe pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3e6b36c-a853-5e1e-a1c7-77f36041cb8d', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Complète : « Les épreuves au terme ___ il a triomphé étaient rudes. »', '[{"id":"a","text":"duquel"},{"id":"b","text":"de laquelle"},{"id":"c","text":"dont"},{"id":"d","text":"desquelles"}]'::jsonb, 'd', 'La locution « au terme de » impose « de » + le pronom accordé à « les épreuves » (féminin pluriel) : « desquelles ». « duquel » est un masculin singulier, « de laquelle » un féminin singulier, et « dont » est interdit après une locution prépositionnelle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95964cae-0d91-5f05-883d-97e628a41d9e', '3858ed6f-755f-5881-9e51-8b30f788b3f5', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Le pont au-dessus dont passe le train est ancien."},{"id":"b","text":"Les valeurs auxquelles je crois sont simples."},{"id":"c","text":"La personne avec qui je discute est mon oncle."},{"id":"d","text":"Le sujet au cours duquel il s''est endormi était long."}]'::jsonb, 'a', 'La première phrase est fausse : la locution « au-dessus de » se termine par « de », donc « dont » est interdit ; il faut « au-dessus duquel » (le pont au-dessus duquel passe le train). Les autres sont correctes : « auxquelles » (croire à), « avec qui » (personne) et « au cours duquel » (locution).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('005bb173-521b-5a9c-b35f-b0341d54cf44', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : les pronoms relatifs composés', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8290c0d0-3d37-53d4-84aa-b177e67b9839', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Complète : « C''est une revue dans les colonnes ___ il a publié son article. »', '[{"id":"a","text":"dont"},{"id":"b","text":"de laquelle"},{"id":"c","text":"duquel"},{"id":"d","text":"à laquelle"}]'::jsonb, 'b', 'La locution « dans les colonnes de » se termine par « de » : « dont » est interdit, on emploie « de laquelle » accordé à « une revue » (féminin singulier). ✓ « duquel » serait un masculin, et « à laquelle » correspond à « à », pas à « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b43aa562-fb8c-5ed3-a690-3bb3661401bf', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Complète : « La théorie au nom ___ il défend ses idées est contestée. »', '[{"id":"a","text":"dont"},{"id":"b","text":"duquel"},{"id":"c","text":"de laquelle"},{"id":"d","text":"auquel"}]'::jsonb, 'c', 'La locution « au nom de » se termine par « de », donc « dont » est interdit ; on emploie « de laquelle » accordé à « la théorie » (féminin singulier). « duquel » serait un masculin, et « auquel » correspond à « à », pas à « de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2e869d3-f02d-52c5-ba8a-9a46b14aab14', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Complète : « Les invités à côté ___ j''étais assis parlaient fort. »', '[{"id":"a","text":"dont"},{"id":"b","text":"duquel"},{"id":"c","text":"de laquelle"},{"id":"d","text":"desquels"}]'::jsonb, 'd', 'La locution « à côté de » impose « de » + le pronom accordé à « les invités » (masculin pluriel) : « desquels ». On pourrait aussi dire « à côté de qui » (personnes), mais « dont » est interdit dans une locution, et « duquel »/« de laquelle » sont des singuliers.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e442c61-53a8-5076-be74-0412f059d457', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Complète : « C''est un domaine ___ je m''intéresse beaucoup. »', '[{"id":"a","text":"auquel"},{"id":"b","text":"dont"},{"id":"c","text":"à lequel"},{"id":"d","text":"duquel"}]'::jsonb, 'a', 'On dit s''intéresser À quelque chose ; « à » + « lequel » (masculin singulier, « un domaine ») se contracte en « auquel ». Le piège courant est « dont », mais s''intéresser se construit avec « à », pas « de » ; « à lequel » n''existe pas, et « duquel » correspond à « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8830f07-6180-505c-9102-e09a04b69b52', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Complète : « La société pour le compte ___ il travaille est étrangère. »', '[{"id":"a","text":"dont"},{"id":"b","text":"duquel"},{"id":"c","text":"de laquelle"},{"id":"d","text":"auquel"}]'::jsonb, 'c', 'La locution « pour le compte de » se termine par « de » : « dont » est interdit, on emploie « de laquelle » accordé à « la société » (féminin singulier). « duquel » serait un masculin, et « auquel » correspond à « à », pas à « de ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19bbfca2-9aa5-5157-98e0-40b7214453e0', '005bb173-521b-5a9c-b35f-b0341d54cf44', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Le but pour lequel il lutte est juste."},{"id":"b","text":"Le fleuve le long dont nous marchions était calme."},{"id":"c","text":"Les amis sur lesquels je compte sont rares."},{"id":"d","text":"La réunion au cours de laquelle on a voté fut tendue."}]'::jsonb, 'b', 'La deuxième phrase est fausse : la locution « le long de » se termine par « de », donc « dont » est interdit ; il faut « le long duquel » (le fleuve le long duquel nous marchions). Les autres sont correctes : « pour lequel », « sur lesquels » et « au cours de laquelle ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3763fdb0-b7bc-54b5-9ca0-361b369335d3', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : les pronoms relatifs composés', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('701203ba-1ad9-52b4-bfb1-9cf11e7f85f7', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Complète : « Le tribunal devant ___ il a comparu l''a acquitté. »', '[{"id":"a","text":"lequel"},{"id":"b","text":"laquelle"},{"id":"c","text":"lesquels"},{"id":"d","text":"qui"}]'::jsonb, 'a', 'La préposition « devant » introduit un pronom composé accordé à « le tribunal » (masculin singulier) : « devant lequel ». « laquelle » est féminin, « lesquels » un pluriel, et « qui » est exclu pour une chose après préposition.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad12e383-d581-5377-a876-bf8a7265a7a8', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Complète : « L''affaire à propos ___ on a beaucoup écrit reste mystérieuse. »', '[{"id":"a","text":"de laquelle"},{"id":"b","text":"dont"},{"id":"c","text":"duquel"},{"id":"d","text":"à laquelle"}]'::jsonb, 'a', 'La locution « à propos de » se termine par « de » : « dont » est interdit, on emploie « de laquelle » accordé à « l''affaire » (féminin singulier). Le piège est « dont » car on pense à « écrire sur/de », mais la locution prépositionnelle impose « de laquelle » ; « duquel » serait un masculin et « à laquelle » correspond à « à ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('498bf81f-d4a8-50a4-ab47-8f4025088d8c', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Complète : « Ce sont des principes ___ je ne renoncerai jamais. »', '[{"id":"a","text":"dont"},{"id":"b","text":"à lesquels"},{"id":"c","text":"desquels"},{"id":"d","text":"auxquels"}]'::jsonb, 'd', 'On dit renoncer À quelque chose ; « à » + « lesquels » (masculin pluriel, « des principes ») se contracte en « auxquels ». Le piège courant est « dont », mais renoncer se construit avec « à », pas « de » ; « à lesquels » n''existe pas, et « desquels » correspond à « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e417fdb-fd10-5c01-90a4-e3464bca1229', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Complète : « Voilà la falaise au sommet ___ on aperçoit un phare. »', '[{"id":"a","text":"duquel"},{"id":"b","text":"de laquelle"},{"id":"c","text":"dont"},{"id":"d","text":"auquel"}]'::jsonb, 'b', 'La locution « au sommet de » se termine par « de » : « dont » est interdit, on emploie « de laquelle » accordé à « la falaise » (féminin singulier). Le piège est « duquel » (masculin) à cause du mot « sommet », mais l''accord se fait avec l''antécédent « falaise », féminin ; « auquel » correspond à « à ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db96b6ba-e96d-5110-bf3a-6680ced262f4', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Complète : « C''est un collègue ___ l''avis compte beaucoup pour moi. »', '[{"id":"a","text":"auquel"},{"id":"b","text":"duquel"},{"id":"c","text":"dont"},{"id":"d","text":"de qui"}]'::jsonb, 'c', 'C''est l''avis DU collègue : un « de » simple, complément du nom « avis » sans locution prépositionnelle, donc « dont » : un collègue dont l''avis compte. Le piège est « duquel », réservé aux locutions (au sujet duquel) ; « auquel » correspond à « à » et « de qui » est moins naturel ici pour un complément du nom.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('547e68ab-8874-5142-b8a0-330b2311740d', '3763fdb0-b7bc-54b5-9ca0-361b369335d3', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"Les recherches au cours desquelles il a échoué l''ont épuisé."},{"id":"b","text":"L''arbre au pied duquel nous pique-niquons donne de l''ombre."},{"id":"c","text":"La cause pour laquelle je me bats est juste."},{"id":"d","text":"Le dossier au sujet dont nous discutons est confidentiel."}]'::jsonb, 'd', 'La quatrième phrase est fausse : la locution « au sujet de » se termine par « de », donc « dont » est interdit ; il faut « au sujet duquel » (le dossier au sujet duquel nous discutons). Les autres sont correctes : « au cours desquelles » (féminin pluriel), « au pied duquel » (masculin singulier) et « pour laquelle ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cb9d60f0-236c-5286-a164-6a8fd4acb0b8', '089289f0-e784-5691-a3e6-22cdaadd24ee', 'francais-b2', '⭐⭐ Drill : les pronoms relatifs composés', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ad8ac2b-3d71-58c1-8415-9220cc56d99a', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Complète : « Les étagères ___ je range mes dossiers sont pleines. »', '[{"id":"a","text":"sur lequel"},{"id":"b","text":"sur laquelle"},{"id":"c","text":"sur lesquelles"},{"id":"d","text":"sur qui"}]'::jsonb, 'c', 'Après « sur », on accorde le pronom à l''antécédent : « les étagères » est féminin pluriel, donc « sur lesquelles ». « sur lequel »/« sur laquelle » sont des singuliers, et « sur qui » est réservé aux personnes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1856efd6-786e-5b50-8b71-5de02f73551d', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Complète : « C''est un examen ___ je me prépare depuis des mois. »', '[{"id":"a","text":"auquel"},{"id":"b","text":"à lequel"},{"id":"c","text":"dont"},{"id":"d","text":"à laquelle"}]'::jsonb, 'a', 'On dit se préparer À quelque chose ; « à » + « lequel » (masculin singulier, « un examen ») se contracte en « auquel ». « à lequel » n''existe pas, « dont » s''emploie avec « de », et « à laquelle » est un féminin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7339b58-ed22-5ec6-b09b-622d345cc35e', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Complète : « La rivière le long ___ nous avons marché était paisible. »', '[{"id":"a","text":"dont"},{"id":"b","text":"duquel"},{"id":"c","text":"où"},{"id":"d","text":"de laquelle"}]'::jsonb, 'd', 'La locution « le long de » se termine par « de » : « dont » est interdit, on emploie « de laquelle » accordé à « la rivière » (féminin singulier). « duquel » serait un masculin, et « où » ne convient pas après « le long de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a3ba236-0176-5d61-be62-8b4bf2de8e9e', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Complète : « La cliente ___ je m''adresse souhaite un remboursement. »', '[{"id":"a","text":"dont"},{"id":"b","text":"à qui"},{"id":"c","text":"auxquelles"},{"id":"d","text":"à lequel"}]'::jsonb, 'b', 'On dit s''adresser À quelqu''un ; pour une personne, « à qui » est naturel : la cliente à qui je m''adresse (on dirait aussi « à laquelle »). « dont » s''emploie avec « de », « auxquelles » est un pluriel, et « à lequel » n''existe pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6df860c2-ac7e-5255-a3f7-f839a7f711aa', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Complète : « C''est un musée ___ les collections sont mondialement connues. »', '[{"id":"a","text":"duquel"},{"id":"b","text":"auquel"},{"id":"c","text":"dont"},{"id":"d","text":"de laquelle"}]'::jsonb, 'c', 'Ce sont les collections DU musée : un « de » simple, complément du nom sans locution prépositionnelle, donc « dont » : un musée dont les collections sont connues. « duquel » est réservé aux locutions, « auquel » correspond à « à », et « de laquelle » serait un féminin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('329f9936-9cba-5a5e-b184-aeab6c186ccc', 'cb9d60f0-236c-5286-a164-6a8fd4acb0b8', 'Trouve la phrase incorrecte.', '[{"id":"a","text":"La place au centre dont se dresse une statue est célèbre."},{"id":"b","text":"Le projet auquel je participe avance bien."},{"id":"c","text":"Les voisins avec qui nous dînons sont charmants."},{"id":"d","text":"La décision contre laquelle ils ont protesté est annulée."}]'::jsonb, 'a', 'La première phrase est fausse : la locution « au centre de » se termine par « de », donc « dont » est interdit ; il faut « au centre de laquelle » (la place au centre de laquelle se dresse une statue). Les autres sont correctes : « auquel » (participer à), « avec qui » (personnes) et « contre laquelle ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('effaa6a3-6663-5095-a504-5352b2fccefa', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('359206d8-7628-589b-882e-bd12be974f57', 'effaa6a3-6663-5095-a504-5352b2fccefa', 'Quel est le participe présent du verbe « finir » ?', '[{"id":"a","text":"finant"},{"id":"b","text":"finissant"},{"id":"c","text":"finissent"},{"id":"d","text":"fini"}]'::jsonb, 'b', 'On forme le participe présent sur le radical de « nous » au présent : nous finiss-ons → finiss- + -ant = finissant. « finant » oublie l''infixe -iss-, « finissent » est une forme conjuguée et « fini » est le participe passé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5467d07b-0e86-50b5-ae62-37a8b1688cf9', 'effaa6a3-6663-5095-a504-5352b2fccefa', 'Complétez : « Il a appris le français ___ des films sous-titrés. » (exprimer le moyen)', '[{"id":"a","text":"regardant"},{"id":"b","text":"en regardant"},{"id":"c","text":"regarde"},{"id":"d","text":"à regarder"}]'::jsonb, 'b', 'Le gérondif (en + participe présent) exprime ici le moyen : il a appris en regardant des films. « regardant » seul est un participe présent sans la préposition « en » obligatoire pour le gérondif ; les autres formes ne conviennent pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('535fb9d4-7134-51bb-b94c-5238d81d7f8a', 'effaa6a3-6663-5095-a504-5352b2fccefa', 'Lequel de ces participes présents est IRRÉGULIER ?', '[{"id":"a","text":"prenant"},{"id":"b","text":"faisant"},{"id":"c","text":"sachant"},{"id":"d","text":"disant"}]'::jsonb, 'c', '« savoir » a un participe présent irrégulier : sachant (et non « savant »). Les trois irréguliers sont étant, ayant, sachant. « prenant », « faisant » et « disant » suivent la règle du radical de « nous » (prenons, faisons, disons).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2eae7464-d1f0-5926-9358-345f7bf48762', 'effaa6a3-6663-5095-a504-5352b2fccefa', 'Le participe présent dans « des élèves parlant trois langues » est :', '[{"id":"a","text":"invariable, il équivaut à « qui parlent »"},{"id":"b","text":"variable, il s''accorde avec « élèves »"},{"id":"c","text":"un adjectif verbal au pluriel"},{"id":"d","text":"un gérondif"}]'::jsonb, 'a', 'Le participe présent est une forme verbale invariable : on écrit « parlant », jamais « parlants ». Il équivaut à la relative « qui parlent ». Ce n''est pas un adjectif verbal (qui, lui, s''accorderait) et il n''y a pas de préposition « en » : ce n''est donc pas un gérondif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f88494f1-c57f-5e4c-8d24-9b2f862a6406', 'effaa6a3-6663-5095-a504-5352b2fccefa', 'Dans quelle phrase la forme en -ant est-elle un ADJECTIF VERBAL (accordé) ?', '[{"id":"a","text":"Fatiguant tout le monde, il a fini par partir."},{"id":"b","text":"Ce sont des journées vraiment fatigantes."},{"id":"c","text":"En fatiguant le cheval, tu le rendras nerveux."},{"id":"d","text":"Les efforts fatiguant les muscles sont à doser."}]'::jsonb, 'b', 'Dans (b), « fatigantes » s''accorde avec « journées » : c''est l''adjectif verbal (orthographe sans u). Dans (a) et (d), « fatiguant » est un participe présent invariable (= qui fatigue) et dans (c), « en fatiguant » est un gérondif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8e242bae-c7d1-5651-a9e8-2c140efd1168', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', '⭐ Entraînement : le gérondif et le participe présent', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f7ffe26-473d-5f83-affa-9497f9649df7', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Quel est le participe présent du verbe « prendre » ?', '[{"id":"a","text":"prendant"},{"id":"b","text":"prennent"},{"id":"c","text":"pris"},{"id":"d","text":"prenant"}]'::jsonb, 'd', 'On part du radical de « nous » : nous pren-ons → pren- + -ant = prenant. « prendant » garde à tort le d de l''infinitif, « prennent » est une forme conjuguée et « pris » est le participe passé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a128097-d29d-5abe-8a62-931ffde33af1', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Complétez : « ___ malade, elle a annulé son voyage. » (exprimer la cause)', '[{"id":"a","text":"Étante"},{"id":"b","text":"En étant"},{"id":"c","text":"Étant"},{"id":"d","text":"Étants"}]'::jsonb, 'c', 'Le participe présent « étant » (irrégulier) exprime ici la cause (= comme elle était malade) et reste invariable. « En étant » serait un gérondif, peu naturel ici ; « étante » et « étants » sont fautifs car le participe présent ne s''accorde jamais.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a94bdf24-2720-5d7e-b181-81c960948d24', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Complétez : « Il s''est blessé ___ du vélo. » (simultanéité)', '[{"id":"a","text":"faisant"},{"id":"b","text":"à faire"},{"id":"c","text":"en faisant"},{"id":"d","text":"fait"}]'::jsonb, 'c', 'Le gérondif « en faisant » exprime la simultanéité : il s''est blessé pendant qu''il faisait du vélo. « faisant » seul est un participe présent sans la préposition « en » ; les autres formes ne conviennent pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b3bbc7d-d48f-5188-ae41-5601656267f5', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Quel est le participe présent du verbe « avoir » ?', '[{"id":"a","text":"avant"},{"id":"b","text":"avoyant"},{"id":"c","text":"eu"},{"id":"d","text":"ayant"}]'::jsonb, 'd', '« avoir » a un participe présent irrégulier : ayant. « avant » est une préposition, « avoyant » n''existe pas et « eu » est le participe passé. Les trois irréguliers à retenir sont étant, ayant, sachant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c66db4d6-8ec6-5913-9c66-f95fd36e47b0', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Complétez : « ___ tôt, tu arriveras avant la foule. » (exprimer la condition)', '[{"id":"a","text":"Partant"},{"id":"b","text":"En partant"},{"id":"c","text":"Pour partir"},{"id":"d","text":"Partir"}]'::jsonb, 'b', 'Le gérondif « en partant » exprime ici la condition (= si tu pars tôt). « partant » seul est un participe présent sans « en » ; « pour partir » exprime le but et « partir » est un simple infinitif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d4be76e-bfdc-5034-a983-2e89a2f717b7', '8e242bae-c7d1-5651-a9e8-2c140efd1168', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Sachant la vérité, il a préféré se taire."},{"id":"b","text":"Elle travaille en écoutant de la musique."},{"id":"c","text":"Il a réussi travaillant beaucoup."},{"id":"d","text":"Les enfants jouant dehors faisaient du bruit."}]'::jsonb, 'c', 'La phrase (c) est incorrecte : pour exprimer le moyen, il faut le gérondif avec la préposition « en » → « il a réussi en travaillant beaucoup ». (a) emploie correctement le participe présent « sachant », (b) un gérondif correct et (d) un participe présent invariable correct.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('537595ab-8529-5d0c-b3fe-6b2a24138f40', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', '⭐⭐ Révision : le gérondif et le participe présent', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('487c3f13-e600-5394-9364-2ddc8e602d3c', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Complétez : « Les voyageurs ___ un billet valide peuvent embarquer. » (= qui possèdent)', '[{"id":"a","text":"en possédant"},{"id":"b","text":"possédants"},{"id":"c","text":"possédant"},{"id":"d","text":"possédantes"}]'::jsonb, 'c', 'Le participe présent « possédant » équivaut à la relative « qui possèdent » et reste invariable. « possédants » / « possédantes » seraient des accords fautifs ; « en possédant » serait un gérondif, qui n''a pas de sens ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a426d47-d848-587f-9cc2-46954447c6ba', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Réécrivez « Comme il ne savait pas la route, il s''est perdu » avec un participe présent.', '[{"id":"a","text":"Ne savant pas la route, il s''est perdu."},{"id":"b","text":"En ne sachant pas la route, il s''est perdu."},{"id":"c","text":"Ne saquant pas la route, il s''est perdu."},{"id":"d","text":"Ne sachant pas la route, il s''est perdu."}]'::jsonb, 'd', 'Le participe présent de « savoir » est l''irrégulier « sachant ». Il exprime ici la cause (= comme il ne savait pas). « savant » et « saquant » sont fautifs ; « en ne sachant » serait un gérondif maladroit pour exprimer une cause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a664adf6-7163-5e31-9b7f-cb5f8470be58', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Choisissez la bonne orthographe : « C''est une démonstration très ___. »', '[{"id":"a","text":"convainquant"},{"id":"b","text":"convaincant"},{"id":"c","text":"convaincante"},{"id":"d","text":"convainquante"}]'::jsonb, 'c', 'Ici la forme est un adjectif verbal : il s''accorde avec « démonstration » (féminin) → « convaincante » (avec c). « convainquant » est le participe présent invariable (avec qu) et les deux autres formes mélangent les orthographes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62e6100c-d7c7-5575-9246-fb48afd8d22b', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Complétez : « ___ ce contrat, vous renoncez à toute réclamation. » (condition/conséquence)', '[{"id":"a","text":"Signant"},{"id":"b","text":"En signant"},{"id":"c","text":"Signants"},{"id":"d","text":"À signer"}]'::jsonb, 'b', 'Le gérondif « en signant » exprime ici la condition (= si vous signez). « signant » seul est un participe présent sans « en » ; « signants » est un accord impossible et « à signer » n''a pas le sens voulu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fda1679a-b725-5dd5-ac09-2d6507a28947', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Pourquoi la phrase « En ouvrant la porte, un courant d''air a soufflé » est-elle fautive ?', '[{"id":"a","text":"Le gérondif et le verbe principal n''ont pas le même sujet."},{"id":"b","text":"Il manque la préposition « en »."},{"id":"c","text":"Le participe présent devrait s''accorder."},{"id":"d","text":"« ouvrant » est un participe présent irrégulier mal formé."}]'::jsonb, 'a', 'Le gérondif doit avoir le même sujet que le verbe principal. Ici le sujet de « a soufflé » est « un courant d''air », qui n''ouvre pas la porte. Il faut écrire « Quand j''ai ouvert la porte, un courant d''air a soufflé ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eda5f1c7-9898-5c24-9158-3f0d0bb99b7d', '537595ab-8529-5d0c-b3fe-6b2a24138f40', 'Dans « des produits différant légèrement par la couleur », la forme « différant » est :', '[{"id":"a","text":"un adjectif verbal accordé au pluriel"},{"id":"b","text":"un participe présent invariable (= qui diffèrent)"},{"id":"c","text":"une faute : il faut écrire « différents »"},{"id":"d","text":"un gérondif sans « en »"}]'::jsonb, 'b', '« différant » (avec a) est le participe présent invariable, équivalent à « qui diffèrent ». L''adjectif verbal s''écrirait « différents » (avec e) et s''accorderait, mais ici la forme verbale est correcte. Ce n''est pas un gérondif (pas de « en »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : le gérondif et le participe présent', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f0627bc-3563-511a-812f-0c6fe4a5376c', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Complétez : « Il est sorti ___ saluer personne. »', '[{"id":"a","text":"sans saluant"},{"id":"b","text":"en ne saluant"},{"id":"c","text":"sans saluer"},{"id":"d","text":"ne saluant"}]'::jsonb, 'c', 'Après la préposition « sans », on emploie l''infinitif, pas le participe présent : « sans saluer personne ». « sans saluant » est fautif ; un gérondif négatif (« en ne saluant ») serait lourd et « ne saluant » est incomplet.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ace8f2f9-8edd-51c6-a97c-9448c9960da1', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Choisissez la phrase CORRECTE.', '[{"id":"a","text":"Ce sont des arguments convaincant."},{"id":"b","text":"Ce sont des arguments convaincants."},{"id":"c","text":"Ce sont des arguments convainquants."},{"id":"d","text":"Ce sont des arguments en convainquant."}]'::jsonb, 'b', '« convaincants » est l''adjectif verbal : il s''accorde avec « arguments » (masculin pluriel) et s''écrit avec c. (a) oublie l''accord, (c) utilise l''orthographe du participe présent (avec qu) et (d) introduit un gérondif absurde.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e89503d-9b38-5532-a2ea-95a8805e6dc8', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Réécrivez « Il a obtenu le poste parce qu''il avait insisté » en gardant l''idée de moyen.', '[{"id":"a","text":"Il a obtenu le poste en insistant."},{"id":"b","text":"Il a obtenu le poste insistant."},{"id":"c","text":"Il a obtenu le poste, insistante."},{"id":"d","text":"Il a obtenu le poste à insister."}]'::jsonb, 'a', 'Le gérondif « en insistant » exprime le moyen (= grâce au fait qu''il a insisté). « insistant » seul serait un participe présent sans « en », « insistante » un accord impossible et « à insister » n''a pas ce sens.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e97c52ef-cb87-545e-9472-766105102f6e', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Dans « une remarque provocante », quelle est la nature et l''orthographe correcte de « provocante » ?', '[{"id":"a","text":"Gérondif : en provoquant."},{"id":"b","text":"Participe présent invariable, écrit avec qu : provoquant."},{"id":"c","text":"Adjectif verbal écrit avec qu : provoquante."},{"id":"d","text":"Adjectif verbal accordé, écrit avec c : provocante."}]'::jsonb, 'd', 'Ici la forme qualifie « remarque » : c''est l''adjectif verbal, accordé et écrit avec c → « provocante ». Le participe présent s''écrirait « provoquant » (avec qu) et resterait invariable, mais le contexte exige bien l''adjectif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b029cf20-fab2-5f8a-abab-c6fbb34b1db1', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Trouvez la phrase où le gérondif est EMPLOYÉ DE FAÇON FAUTIVE.', '[{"id":"a","text":"En lisant le contrat, j''ai remarqué une erreur."},{"id":"b","text":"En arrivant à la gare, le train était déjà parti."},{"id":"c","text":"Tu progresseras en t''entraînant tous les jours."},{"id":"d","text":"Il s''est endormi en regardant la télévision."}]'::jsonb, 'b', 'Dans (b), le sujet du gérondif (celui qui arrive) n''est pas le sujet du verbe principal « le train » : le train n''arrive pas, il est déjà parti. Il faudrait « Quand je suis arrivé… ». Dans (a), (c) et (d), le sujet est bien partagé entre les deux verbes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('046bfe89-df29-5278-9e96-1f13e1282c48', 'e12862bd-23ab-5a3d-b2b5-ae4c88df7273', 'Complétez : « ___ leurs preuves, ces méthodes sont désormais recommandées. » (= qui ont fait)', '[{"id":"a","text":"Ayant fait"},{"id":"b","text":"En ayant fait"},{"id":"c","text":"Ayants fait"},{"id":"d","text":"Avant fait"}]'::jsonb, 'a', '« ayant fait » est le participe présent composé (ayant + participe passé), invariable, exprimant ici une cause antérieure (= comme elles ont fait leurs preuves). « ayants » est un accord fautif, « avant fait » est une faute et le gérondif n''a pas de sens ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : le gérondif et le participe présent', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9dcc4ebc-6785-50d6-9252-087da8909ddf', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Choisissez la phrase entièrement CORRECTE.', '[{"id":"a","text":"Les négligeant leurs devoirs seront sanctionnés."},{"id":"b","text":"Les élèves négligeant leurs devoirs seront sanctionnés."},{"id":"c","text":"Les élèves négligents leurs devoirs seront sanctionnés."},{"id":"d","text":"Les élèves en négligeant leurs devoirs seront sanctionnés."}]'::jsonb, 'b', '« négligeant » est le participe présent invariable (= qui négligent), avec un complément « leurs devoirs ». (a) supprime le nom, (c) confond avec l''adjectif verbal « négligents » qui ne peut pas avoir de complément d''objet, et (d) ajoute un « en » qui transforme la relative en gérondif incohérent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('025bb3ed-d1d4-58e1-b433-06560ac2376c', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Quelle phrase exprime correctement la MANIÈRE par un gérondif ?', '[{"id":"a","text":"Elle est entrée souriant à tout le monde."},{"id":"b","text":"Elle est entrée souriante en tout le monde."},{"id":"c","text":"Elle est entrée à sourire à tout le monde."},{"id":"d","text":"Elle est entrée en souriant à tout le monde."}]'::jsonb, 'd', 'Le gérondif « en souriant » exprime la manière (= avec le sourire). (a) emploie un participe présent sans « en », (c) mêle un adjectif verbal accordé et une préposition fautive, et (d) n''est pas une construction française correcte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e039a32-2eda-5df4-ac2f-029b39305262', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Dans « les sociétés communicantes investissent dans l''image », « communicantes » est :', '[{"id":"a","text":"un adjectif verbal accordé (écrit avec c)"},{"id":"b","text":"un participe présent invariable (écrit avec qu)"},{"id":"c","text":"une faute pour « communiquantes »"},{"id":"d","text":"un gérondif"}]'::jsonb, 'a', '« communicantes » qualifie « sociétés » et s''accorde : c''est l''adjectif verbal, écrit avec c. Le participe présent s''écrirait « communiquant » (avec qu) et resterait invariable. La forme « communiquantes » avec accord n''existe pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27d31263-6c20-5960-9947-4838d0aeac6d', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Réécrivez « Si tu prends le métro, tu gagneras du temps » avec un gérondif.', '[{"id":"a","text":"Prenant le métro, tu gagneras du temps."},{"id":"b","text":"En prenant le métro, tu gagneras du temps."},{"id":"c","text":"En prenant le métro, on gagnera du temps."},{"id":"d","text":"À prendre le métro, tu gagneras du temps."}]'::jsonb, 'b', 'Le gérondif « en prenant » exprime la condition (= si tu prends) et garde le même sujet « tu » que « tu gagneras ». (a) oublie « en » (participe présent), (c) change le sujet en « on » et (d) n''est pas une tournure correcte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94c6cd6c-a9f2-5bde-b7eb-493ac4a22ce0', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Trouvez la SEULE phrase grammaticalement correcte.', '[{"id":"a","text":"Étants fatigués, ils ont fait une pause."},{"id":"b","text":"En lisant attentivement, l''erreur m''a sauté aux yeux."},{"id":"c","text":"Ayant terminé le travail, ils sont rentrés."},{"id":"d","text":"Les enfants jouants dans la cour riaient fort."}]'::jsonb, 'c', '« Ayant terminé » est un participe présent composé invariable, avec le même sujet « ils » que « sont rentrés » : correct. (a) accorde à tort « étant », (b) donne au gérondif un sujet (« l''erreur ») différent de celui qui lit, et (d) accorde à tort le participe présent « jouant ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5e1016-730a-566f-a828-6d7cfbae291d', '8a87a758-27ab-521e-aaf6-f97fa1ccaedb', 'Quelle réécriture de « Les passagers qui n''ont pas de réservation devront patienter » utilise correctement le participe présent ?', '[{"id":"a","text":"Les passagers n''ayant pas de réservation devront patienter."},{"id":"b","text":"Les passagers n''ayants pas de réservation devront patienter."},{"id":"c","text":"Les passagers en n''ayant pas de réservation devront patienter."},{"id":"d","text":"Les passagers n''avant pas de réservation devront patienter."}]'::jsonb, 'a', 'Le participe présent « ayant » (irrégulier, invariable) remplace la relative « qui n''ont pas » : « les passagers n''ayant pas de réservation ». (b) accorde à tort « ayants », (c) ajoute un « en » qui crée un gérondif incohérent et (d) écrit une forme inexistante.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2674421-45a6-57e2-9e54-7695f0bd6e95', 'd78c4bb2-2282-5595-9bc0-47a5962558c8', 'francais-b2', '⭐⭐ Drill : le gérondif et le participe présent', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d866374-bf66-5c55-bb1c-54dadb29dfef', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Quel est le participe présent du verbe « commencer » ?', '[{"id":"a","text":"commençant"},{"id":"b","text":"commencant"},{"id":"c","text":"commencent"},{"id":"d","text":"commencé"}]'::jsonb, 'a', 'Sur le radical de « nous commençons » : commenç- + -ant = commençant. La cédille est nécessaire devant a pour garder le son [s]. « commencant » oublie la cédille, « commencent » est conjugué et « commencé » est le participe passé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97dc6686-b429-523a-8df4-d9f0142d47a5', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Complétez : « Elle a appris à nager ___ tous les étés à la mer. » (moyen)', '[{"id":"a","text":"passant"},{"id":"b","text":"à passer"},{"id":"c","text":"passante"},{"id":"d","text":"en passant"}]'::jsonb, 'd', 'Le gérondif « en passant » exprime le moyen : elle a appris grâce aux étés passés à la mer. « passant » seul est un participe présent sans « en », « à passer » n''a pas ce sens et « passante » est un accord impossible.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c6d44c1-853f-574b-8471-9d4f33602649', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Choisissez la bonne orthographe : « Ce sont des couleurs ___ d''un écran à l''autre. » (= qui diffèrent)', '[{"id":"a","text":"différentes"},{"id":"b","text":"différents"},{"id":"c","text":"différant"},{"id":"d","text":"en différant"}]'::jsonb, 'c', 'Avec le complément « d''un écran à l''autre », il s''agit du participe présent invariable « différant » (avec a), équivalent à « qui diffèrent ». L''adjectif verbal « différentes » (avec e) décrirait une qualité sans complément verbal.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1573cc3-dd21-510b-8de6-0da3a00bc644', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Réécrivez « Comme elle est responsable du projet, elle signe les documents » avec un participe présent.', '[{"id":"a","text":"En étant responsable du projet, elle signe les documents."},{"id":"b","text":"Étant responsable du projet, elle signe les documents."},{"id":"c","text":"Étante responsable du projet, elle signe les documents."},{"id":"d","text":"Étants responsable du projet, elle signe les documents."}]'::jsonb, 'b', 'Le participe présent « étant » (invariable) exprime la cause (= comme elle est responsable). Le gérondif « en étant » donnerait une nuance de moyen, moins naturelle ici, et les formes accordées « étante » / « étants » sont fautives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96888519-567a-5569-8bd8-deb156b72454', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Pourquoi « En courant pour attraper le bus, mon sac s''est ouvert » est-il fautif ?', '[{"id":"a","text":"Le gérondif n''a pas le même sujet que le verbe principal."},{"id":"b","text":"« courant » devrait s''accorder avec « sac »."},{"id":"c","text":"Il faut un infinitif après « en »."},{"id":"d","text":"« courant » est un participe présent irrégulier mal formé."}]'::jsonb, 'a', 'Le gérondif doit partager le sujet du verbe principal. Ici « mon sac » ne court pas : le sujet de « courant » devrait être la personne. Il faut « En courant pour attraper le bus, j''ai vu mon sac s''ouvrir » ou une subordonnée avec « quand ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a9bcd2a-f5cf-558d-aa2f-54520987fe6e', 'f2674421-45a6-57e2-9e54-7695f0bd6e95', 'Dans laquelle de ces phrases la forme en -ant est-elle un ADJECTIF VERBAL ?', '[{"id":"a","text":"Une voix tremblant d''émotion s''est élevée."},{"id":"b","text":"Il a répondu d''une voix tremblante."},{"id":"c","text":"Tremblant de froid, il est rentré vite."},{"id":"d","text":"En tremblant, elle a ouvert la lettre."}]'::jsonb, 'b', 'Dans (b), « tremblante » s''accorde avec « voix » : c''est l''adjectif verbal (qualité). Dans (a) et (c), « tremblant » est un participe présent invariable (= qui tremble) et dans (d), « en tremblant » est un gérondif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2f31210b-9332-5e1b-a42b-0c52a1fad5f0', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('615fca08-c918-5dba-b0f1-14e596902fd0', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'Quel verbe exprime le fait de « défendre une idée et la maintenir contre l''opposition » ?', '[{"id":"a","text":"soutenir"},{"id":"b","text":"prétendre"},{"id":"c","text":"admettre"},{"id":"d","text":"nuancer"}]'::jsonb, 'a', '« Soutenir » une thèse, c''est la défendre et la maintenir face aux objections. « Prétendre » affirme une chose douteuse, « admettre » reconnaît la position adverse, et « nuancer » rend une affirmation moins absolue : aucun ne signifie défendre activement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4009fd1a-02d2-59e8-94d4-51571aa457c2', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'Complétez : « ___, la mesure coûte cher ; ___ elle sauve des vies. » (concession puis opposition)', '[{"id":"a","text":"En effet … par ailleurs"},{"id":"b","text":"Certes … mais"},{"id":"c","text":"D''une part … d''autre part"},{"id":"d","text":"En somme … donc"}]'::jsonb, 'b', 'Le couple « certes … mais » concède un point à l''adversaire avant de le dépasser : c''est le mouvement argumentatif type du DELF B2. « En effet » confirme, « d''une part… d''autre part » juxtapose deux aspects, et « en somme » résume : aucun ne marque la concession suivie de l''opposition.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5f8a131-363d-53a2-963a-f30e8e848530', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'Dans une argumentation, « une objection » désigne :', '[{"id":"a","text":"une raison avancée pour appuyer sa propre thèse"},{"id":"b","text":"un accord général entre les parties"},{"id":"c","text":"une raison opposée à une thèse"},{"id":"d","text":"le résumé final d''un débat"}]'::jsonb, 'c', 'Une « objection » est une raison qui s''oppose à une thèse. La raison qui appuie une thèse est « un argument » ; l''accord général est « un consensus » ; le résumé final relève de la conclusion. L''objection est ce que l''on doit ensuite réfuter.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a92cf033-4c4b-55fd-9f8e-c423174c89c0', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'Quel mot complète : « Cette personne est très ___ : elle pardonne facilement et écoute sans juger. » ?', '[{"id":"a","text":"compréhensible"},{"id":"b","text":"convaincante"},{"id":"c","text":"conséquente"},{"id":"d","text":"compréhensive"}]'::jsonb, 'd', '« Compréhensive » qualifie une personne indulgente, qui comprend autrui. « Compréhensible » qualifie une chose claire (un texte compréhensible), pas une personne. « Convaincante » signifie persuasive, et « conséquente » veut dire cohérente : ni l''une ni l''autre ne correspond à l''indulgence décrite.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fdd3d48b-944f-5d30-8608-f8cd466d1765', '2f31210b-9332-5e1b-a42b-0c52a1fad5f0', 'Quelle expression introduit une opinion personnelle de manière soutenue ?', '[{"id":"a","text":"en fait"},{"id":"b","text":"à mon sens"},{"id":"c","text":"force est de constater que"},{"id":"d","text":"par ailleurs"}]'::jsonb, 'b', '« À mon sens » introduit explicitement un avis personnel, comme « selon moi ». « En fait » rectifie, « force est de constater que » présente un constat objectif qu''on ne peut nier (et non un avis subjectif), et « par ailleurs » ajoute un argument sans marquer l''opinion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ca7a1902-69bb-580a-ba92-48aefe402482', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', '⭐ Entraînement : opinions et débat', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('447f9f8f-7379-51fb-ae22-7ceab470feb8', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Complétez : « Il ___ avoir lu tout le rapport, mais ses réponses montrent le contraire. »', '[{"id":"a","text":"démontre"},{"id":"b","text":"prétend"},{"id":"c","text":"souligne"},{"id":"d","text":"concède"}]'::jsonb, 'b', '« Prétendre » affirme une chose douteuse ou non prouvée, ce qu''indique « mais ses réponses montrent le contraire ». « Démontrer » prouverait par des faits, « souligner » mettrait en avant un point, et « concéder » accorderait un point à l''adversaire : aucun ne traduit l''affirmation suspecte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7fe3c6f-65f1-5c74-9807-569cbebdd004', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Quel mot désigne « ce qui est en jeu, l''importance réelle d''une question » ?', '[{"id":"a","text":"une polémique"},{"id":"b","text":"une objection"},{"id":"c","text":"un enjeu"},{"id":"d","text":"un consensus"}]'::jsonb, 'c', '« Un enjeu » est ce qui est en jeu, l''importance d''une question. « Une polémique » est une dispute publique vive, « une objection » est une raison contraire à une thèse, et « un consensus » est un accord général : aucun ne désigne l''importance d''un sujet.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98de6419-e1f4-5394-a99a-80a3581432e1', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Trouvez le synonyme précis de « réfuter » dans un débat.', '[{"id":"a","text":"démontrer qu''un argument est faux"},{"id":"b","text":"reconnaître un argument adverse"},{"id":"c","text":"ajouter un nouvel argument"},{"id":"d","text":"répéter sa propre thèse"}]'::jsonb, 'a', '« Réfuter » signifie démontrer qu''un argument est faux. Reconnaître un argument adverse, c''est « concéder » ou « admettre » ; ajouter un argument relève de « par ailleurs » ; répéter sa thèse n''est pas réfuter. Réfuter, c''est attaquer la validité de l''argument opposé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ea5b2e-216e-5db0-887b-107698c48234', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Complétez : « ___, les chiffres ont baissé ; le bilan est donc positif. » (confirmer ce qui précède)', '[{"id":"a","text":"En revanche"},{"id":"b","text":"En fait"},{"id":"c","text":"Certes"},{"id":"d","text":"En effet"}]'::jsonb, 'd', '« En effet » confirme et justifie ce qui vient d''être dit. « En revanche » marque une opposition, « certes » introduit une concession, et « en fait » rectifie : seul « en effet » apporte la confirmation attendue par « le bilan est donc positif ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adae746a-d599-57c7-91d9-5c85b1c07fa7', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Choisissez la collocation correcte.', '[{"id":"a","text":"donner position sur le sujet"},{"id":"b","text":"prendre position sur le sujet"},{"id":"c","text":"faire position sur le sujet"},{"id":"d","text":"mettre position sur le sujet"}]'::jsonb, 'b', 'La collocation figée est « prendre position » (= afficher clairement son opinion). « Donner », « faire » et « mettre position » ne sont pas des expressions correctes en français : c''est le verbe « prendre » qui se combine avec « position ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46e5f336-1895-5a26-ab34-2c7e9ec87e66', 'ca7a1902-69bb-580a-ba92-48aefe402482', 'Quel mot complète : « L''arrivée du train est ___ : il entre en gare dans deux minutes. » ?', '[{"id":"a","text":"éminente"},{"id":"b","text":"permanente"},{"id":"c","text":"imminente"},{"id":"d","text":"notoire"}]'::jsonb, 'c', '« Imminent » signifie « qui va arriver très bientôt », ce qui convient à « dans deux minutes ». « Éminent » veut dire remarquable, supérieur (un éminent savant) ; « notoire » signifie connu de tous ; « permanent » veut dire continu. Seul « imminent » exprime la proximité dans le temps.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('602c0fbc-02fd-525a-9271-b3558e0accb4', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', '⭐⭐ Révision : opinions et débat', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dddfeb8b-86a9-5301-bc48-f5bd37e04530', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Complétez : « Je ne nie pas la difficulté ; je ___ même qu''elle est réelle, mais elle reste surmontable. »', '[{"id":"a","text":"réfute"},{"id":"b","text":"prétends"},{"id":"c","text":"concède"},{"id":"d","text":"démontre"}]'::jsonb, 'c', '« Concéder » = accorder un point à l''adversaire avant de le dépasser (« mais elle reste surmontable »). « Réfuter » nierait l''argument ; « prétendre » affirmerait une chose douteuse ; « démontrer » prouverait. Le mouvement « je concède… mais » est la concession classique du DELF B2.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b47ddafa-8937-5fdd-bcd3-3e858e8c33ae', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Distinguez : on ___ quelqu''un de la vérité d''une idée, mais on ___ quelqu''un d''agir.', '[{"id":"a","text":"convainc / persuade"},{"id":"b","text":"persuade / convainc"},{"id":"c","text":"convainc / convainc"},{"id":"d","text":"persuade / persuade"}]'::jsonb, 'a', '« Convaincre » s''adresse à la raison (convaincre de la vérité d''une idée) ; « persuader » vise l''action et l''émotion (persuader d''agir). On est convaincu QUE quelque chose est vrai, et persuadé DE faire quelque chose : le couple correct est donc « convainc / persuade ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d265cbdc-9632-5ecb-8888-032167028c49', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Trouvez l''intrus : trois de ces mots sont des articulateurs d''ajout ou d''opposition ; lequel exprime un constat objectif ?', '[{"id":"a","text":"par ailleurs"},{"id":"b","text":"force est de constater que"},{"id":"c","text":"en revanche"},{"id":"d","text":"d''une part"}]'::jsonb, 'b', '« Force est de constater que » introduit un constat qu''on ne peut nier, ce qui le distingue des trois autres. « Par ailleurs » ajoute un argument, « en revanche » oppose, et « d''une part » amorce une énumération en deux temps : ce sont des articulateurs logiques, pas un constat.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41ad74c8-4ed9-5a94-9c28-ef3040198569', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Quel mot complète : « C''est un savant ___ : ses travaux font autorité dans le monde entier. » ?', '[{"id":"a","text":"imminent"},{"id":"b","text":"notoire"},{"id":"c","text":"originel"},{"id":"d","text":"éminent"}]'::jsonb, 'd', '« Éminent » signifie remarquable, supérieur, qui se distingue : un savant éminent fait autorité. « Imminent » veut dire très proche dans le temps ; « notoire » signifie connu de tous (souvent en mauvaise part) ; « originel » renvoie aux origines. Seul « éminent » exprime l''excellence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33527e1d-f277-512f-b297-78df2934f639', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Choisissez la phrase où « davantage » est correctement employé.', '[{"id":"a","text":"Si tu révises davantage, tu progresseras vite."},{"id":"b","text":"Cette offre présente bien des davantage."},{"id":"c","text":"Il tire profit du davantage de la situation."},{"id":"d","text":"Le contrat comporte plusieurs davantages."}]'::jsonb, 'a', '« Davantage » est un adverbe invariable signifiant « plus » : « réviser davantage » = réviser plus. Les autres phrases confondent avec « avantage(s) » (= bénéfices) : on dit « bien des avantages », « le profit de la situation » ou « plusieurs avantages », jamais « des davantages ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('955e1f30-216c-515a-9af3-e74ebae838f1', '602c0fbc-02fd-525a-9271-b3558e0accb4', 'Complétez : « Son raisonnement est ___ : chaque étape découle logiquement de la précédente. »', '[{"id":"a","text":"important"},{"id":"b","text":"compréhensif"},{"id":"c","text":"conséquent"},{"id":"d","text":"imminent"}]'::jsonb, 'c', '« Conséquent » signifie logique, cohérent : un raisonnement conséquent enchaîne ses étapes sans contradiction. « Important » renvoie à la taille ou à la portée, « compréhensif » qualifie une personne indulgente, et « imminent » signifie très proche : aucun ne décrit la cohérence logique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('df6621cf-8b28-5693-b1ac-5624aff64423', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : opinions et débat', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02572e1b-c6ed-5afc-9829-30e4df69cc9a', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Le rapport a persuadé les experts que la théorie était vraie."},{"id":"b","text":"Le commercial a persuadé le client de signer le contrat."},{"id":"c","text":"Les preuves ont convaincu le jury de la culpabilité de l''accusé."},{"id":"d","text":"Cet argument m''a convaincu que la réforme était nécessaire."}]'::jsonb, 'a', 'L''erreur est en (a) : on « convainc » quelqu''un QUE quelque chose est vrai (la raison), alors qu''on « persuade » quelqu''un DE faire quelque chose (l''action). Il fallait « a convaincu les experts que ». En (b) « persuader de signer » est correct (action) ; (c) et (d) emploient bien « convaincre que » pour une vérité. Le piège courant est de traiter les deux verbes comme interchangeables.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9f7a259-6515-5cb9-ac4e-a9dd3427b1b2', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Complétez avec le mot le plus précis : « Ce fait est ___ : il mérite d''être relevé, sans pour autant être célèbre. »', '[{"id":"a","text":"notoire"},{"id":"b","text":"éminent"},{"id":"c","text":"imminent"},{"id":"d","text":"notable"}]'::jsonb, 'd', '« Notable » signifie « digne d''être noté, remarquable » sans l''idée de célébrité. « Notoire » désigne ce qui est connu de tous (souvent en mauvaise part) — exclu par « sans être célèbre ». « Éminent » qualifie une personne supérieure, et « imminent » ce qui va arriver. Le piège courant est de confondre notable (à noter) et notoire (connu de tous).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07002426-7e84-5b6b-843d-ed72ca23d644', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Dans une dissertation, quelle formule introduit correctement la concession avant la réfutation ?', '[{"id":"a","text":"Par ailleurs, cette idée est juste ; en effet, elle est fausse."},{"id":"b","text":"Certes, cette idée séduit ; mais elle néglige un point essentiel."},{"id":"c","text":"En somme, cette idée séduit ; donc elle est fausse."},{"id":"d","text":"En effet, cette idée séduit ; en revanche, elle séduit."}]'::jsonb, 'b', '« Certes… mais » concède d''abord un mérite à la thèse adverse (« cette idée séduit »), puis la dépasse (« mais elle néglige… ») : c''est la structure attendue. (a) enchaîne deux articulateurs contradictoires, (c) tire une conséquence illogique avec « donc », et (d) se contredit en répétant « elle séduit ». Le piège : confondre concession et simple opposition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17165391-181b-5240-92a7-89b751ea115d', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Trouvez l''INTRUS parmi ces emplois de « susceptible » et « capable ».', '[{"id":"a","text":"Ce produit est susceptible de provoquer une allergie."},{"id":"b","text":"Cette mesure est susceptible d''améliorer les résultats."},{"id":"c","text":"Ce logiciel est susceptible de calculer la moyenne automatiquement."},{"id":"d","text":"Cette hausse est susceptible d''inquiéter les marchés."}]'::jsonb, 'c', 'L''intrus est (c) : un logiciel qui sait faire une opération est « capable de » la calculer (aptitude réelle), non « susceptible de » (simple éventualité). En (a), (b) et (d), « susceptible de » exprime correctement une possibilité incertaine (peut provoquer, peut améliorer, peut inquiéter). Le piège : employer « susceptible de » pour une compétence avérée, qui relève de « capable de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2617868-a707-56e7-9ddc-4e09f3e57174', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Lisez : « Le projet est compréhensif : ses objectifs sont exposés avec une grande clarté. » Qu''est-ce qui CLOCHE ?', '[{"id":"a","text":"Il faut « compréhensible » : c''est une chose claire, pas une personne indulgente."},{"id":"b","text":"Il faut remplacer « clarté » par « clairté ». "},{"id":"c","text":"Le verbe « exposer » ne convient pas à des objectifs."},{"id":"d","text":"Rien ne cloche, la phrase est correcte."}]'::jsonb, 'a', '« Compréhensif » qualifie une personne indulgente, qui comprend autrui ; pour une chose claire, qui se comprend, il faut « compréhensible » (un projet compréhensible). « Clarté » est l''orthographe correcte (« clairté » n''existe pas), et « exposer des objectifs » est tout à fait standard. Le piège courant : appliquer « compréhensif » à un objet.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6adcc2bc-36c1-54be-b407-69aa3c2ed739', 'df6621cf-8b28-5693-b1ac-5624aff64423', 'Choisissez la collocation soutenue correcte pour « examiner les deux côtés d''une question avant de décider ».', '[{"id":"a","text":"compter le pour et le contre"},{"id":"b","text":"mesurer le pour et le contre"},{"id":"c","text":"balancer le pour et le contre"},{"id":"d","text":"peser le pour et le contre"}]'::jsonb, 'd', 'La collocation figée est « peser le pour et le contre » (= évaluer les avantages et les inconvénients). « Compter », « mesurer » et « balancer le pour et le contre » ne sont pas des expressions consacrées : c''est le verbe « peser » qui s''emploie ici, par l''image de la balance qui soupèse.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('24102e4e-d280-5565-834c-6fa6e6bc1862', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : opinions et débat', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afa51f2c-ab4e-5c30-90a1-5bc6c208c0ac', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Complétez avec le mot le plus juste : « Loin de défendre cette thèse, l''auteur la ___ point par point en exposant ses contradictions. »', '[{"id":"a","text":"soutient"},{"id":"b","text":"réfute"},{"id":"c","text":"concède"},{"id":"d","text":"souligne"}]'::jsonb, 'b', '« Réfuter » = démontrer qu''un argument est faux, ce que confirme « loin de défendre » et « ses contradictions ». « Soutenir » serait défendre la thèse (contredit par « loin de ») ; « concéder » accorderait un point ; « souligner » mettrait en avant. Le piège : « soutenir » attire l''œil mais inverse le sens du passage.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cc1727f-8f38-5a75-8695-2161cbd1928c', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Trouvez la phrase où l''articulateur est employé CORRECTEMENT.', '[{"id":"a","text":"Le coût est élevé ; par ailleurs, les bénéfices à long terme le justifient."},{"id":"b","text":"Le coût est élevé ; en effet, les bénéfices le justifient pleinement."},{"id":"c","text":"Le coût est élevé ; en somme, les bénéfices le justifient."},{"id":"d","text":"Le coût est élevé ; d''une part, les bénéfices le justifient."}]'::jsonb, 'a', '« Par ailleurs » ajoute un argument distinct (le coût d''un côté, les bénéfices de l''autre), ce qui est cohérent. « En effet » confirmerait ce qui précède, mais les bénéfices ne confirment pas le coût ; « en somme » résume sans rien ajouter ; « d''une part » appelle un « d''autre part » manquant. Le piège : « en effet » et « par ailleurs » ne sont pas interchangeables.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab628f0c-b3e0-52c9-abe4-eb9c7bbb865c', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Quel mot complète : « Cette légende remonte au mythe ___, celui qui figure dès les premières versions du récit. » ?', '[{"id":"a","text":"notable"},{"id":"b","text":"éminent"},{"id":"c","text":"original"},{"id":"d","text":"originel"}]'::jsonb, 'd', '« Originel » signifie « des origines, premier » : le mythe originel est celui des premières versions. « Original » signifie nouveau, inédit — sens opposé ici. « Notable » veut dire digne d''être noté, et « éminent » remarquable : ni l''un ni l''autre n''exprime l''antériorité. Le piège classique : confondre original (inédit) et originel (premier).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f8ddc0d-e8a2-543d-8f10-d05d03265d42', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Trouvez l''INTRUS : trois de ces formules introduisent une opinion personnelle ; laquelle énonce un constat impersonnel ?', '[{"id":"a","text":"à mon sens"},{"id":"b","text":"selon moi"},{"id":"c","text":"force est de constater que"},{"id":"d","text":"j''ai le sentiment que"}]'::jsonb, 'c', '« Force est de constater que » présente un fait qu''on ne peut nier, de manière impersonnelle, sans marquer un « je ». « À mon sens », « selon moi » et « j''ai le sentiment que » introduisent au contraire un avis subjectif et personnel. Le piège : croire que toute formule d''introduction signale une opinion personnelle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6964e943-f0e4-5342-8731-8a2eaa9e030e', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Lisez : « L''experte est notoire pour la rigueur de ses analyses, saluées par toute la profession. » Quel mot pose problème ?', '[{"id":"a","text":"« notoire » : pour une qualité positive, il faut « réputée » ou « renommée »."},{"id":"b","text":"« rigueur » : il faut « rigorosité »."},{"id":"c","text":"« saluées » : le participe ne devrait pas s''accorder."},{"id":"d","text":"Rien ne pose problème, la phrase est correcte."}]'::jsonb, 'a', '« Notoire » s''emploie surtout pour ce qui est connu de tous en mauvaise part (un escroc notoire) ; pour une qualité saluée, on dit « réputée » ou « renommée ». « Rigueur » est correct (« rigorosité » n''existe pas), et « saluées » s''accorde bien avec « analyses » (féminin pluriel). Le piège : employer « notoire » comme un éloge neutre.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64253699-602a-5ab5-af61-c977f7a6759c', '24102e4e-d280-5565-834c-6fa6e6bc1862', 'Choisissez la phrase dont toutes les collocations sont soutenues et correctes.', '[{"id":"a","text":"Il a donné valoir un argument décisif et pris une conclusion."},{"id":"b","text":"Il a fait valoir un argument décisif et tiré une conclusion."},{"id":"c","text":"Il a mis valoir un argument décisif et sorti une conclusion."},{"id":"d","text":"Il a porté valoir un argument décisif et levé une conclusion."}]'::jsonb, 'b', 'Les collocations consacrées sont « faire valoir un argument » (= le mettre en avant) et « tirer une conclusion » (= la déduire). Les autres options déforment ces expressions : on ne dit pas « donner / mettre / porter valoir », ni « prendre / sortir / lever une conclusion ». Le piège : remplacer le verbe support figé par un synonyme apparent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c361398f-50a1-5ea1-a776-de04dbbe1db0', '4a002ba3-071f-5a06-8d52-d2846a4f4d0c', 'francais-b2', '⭐⭐ Drill : opinions et débat', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cae7422a-6289-54ca-bbdc-8c8fc39c95b8', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Complétez : « L''étude ___ clairement le lien entre les deux phénomènes, chiffres à l''appui. »', '[{"id":"a","text":"prétend"},{"id":"b","text":"concède"},{"id":"c","text":"démontre"},{"id":"d","text":"nuance"}]'::jsonb, 'c', '« Démontrer » = prouver par un raisonnement ou des faits, ce que confirme « chiffres à l''appui ». « Prétendre » affirmerait sans preuve, « concéder » accorderait un point adverse, et « nuancer » atténuerait l''affirmation : aucun ne correspond à une preuve établie.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('302a34dd-4b61-5858-bba4-9a4315d058fa', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Quel mot désigne « un accord général partagé par les parties en présence » ?', '[{"id":"a","text":"une polémique"},{"id":"b","text":"une objection"},{"id":"c","text":"un enjeu"},{"id":"d","text":"un consensus"}]'::jsonb, 'd', '« Un consensus » est un accord général entre les parties. « Une polémique » est au contraire une dispute vive, « une objection » une raison opposée à une thèse, et « un enjeu » ce qui est en jeu : seul le consensus exprime l''accord partagé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36f4a476-d88c-58ed-a721-64519b6f0328', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Complétez : « ___, ce projet est ambitieux ; ___ il manque encore de financement. » (concession puis opposition)', '[{"id":"a","text":"Certes … mais"},{"id":"b","text":"En effet … par ailleurs"},{"id":"c","text":"En somme … donc"},{"id":"d","text":"D''une part … en effet"}]'::jsonb, 'a', '« Certes… mais » concède une qualité (« ambitieux ») avant d''opposer une limite (« manque de financement ») : c''est le schéma argumentatif du DELF B2. « En effet » confirme, « en somme » résume, et « d''une part » appelle « d''autre part » : aucun n''enchaîne concession puis opposition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78332cfb-0cea-5a60-91a2-89aa6761a625', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Quel mot complète : « Une catastrophe semblait ___ : tout indiquait qu''elle surviendrait dans les heures suivantes. » ?', '[{"id":"a","text":"éminente"},{"id":"b","text":"imminente"},{"id":"c","text":"notoire"},{"id":"d","text":"originelle"}]'::jsonb, 'b', '« Imminent » = qui va arriver très bientôt, ce que confirme « dans les heures suivantes ». « Éminent » qualifie ce qui est remarquable, « notoire » ce qui est connu de tous, et « originel » ce qui remonte aux origines : seul « imminent » exprime la proximité dans le temps.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1e8181b-ea18-50f4-b838-1e51c1118cec', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Trouvez l''INTRUS : trois de ces verbes servent à contester une idée ; lequel sert à l''appuyer ?', '[{"id":"a","text":"réfuter"},{"id":"b","text":"remettre en cause"},{"id":"c","text":"contester"},{"id":"d","text":"soutenir"}]'::jsonb, 'd', '« Soutenir » sert à défendre et appuyer une idée, à l''inverse des trois autres. « Réfuter » démontre qu''un argument est faux, « remettre en cause » conteste, et « contester » s''oppose : tous trois attaquent une thèse, alors que « soutenir » la défend.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d0a1b39-f0dc-5038-a2c2-3bdc2f693fe2', 'c361398f-50a1-5ea1-a776-de04dbbe1db0', 'Choisissez la phrase correcte du point de vue de la collocation et du paronyme.', '[{"id":"a","text":"Avant de trancher, il faut peser le pour et le contre de chaque option."},{"id":"b","text":"Avant de trancher, il faut compter le pour et le contre de chaque option."},{"id":"c","text":"Avant de trancher, il faut peser le davantage de chaque option."},{"id":"d","text":"Avant de trancher, il faut mesurer le pour et le contre de chaque option."}]'::jsonb, 'a', 'La collocation figée est « peser le pour et le contre » (= évaluer avantages et inconvénients). « Compter » et « mesurer le pour et le contre » ne sont pas consacrés, et « le davantage » confond l''adverbe « davantage » (= plus) avec « avantage » (= bénéfice). Seule (a) respecte la collocation et le bon mot.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cfb43058-c9d7-5e86-9475-40b707d50340', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23aba99d-d7cb-53cf-aa33-4f56776f55df', 'cfb43058-c9d7-5e86-9475-40b707d50340', 'Selon le cours, où se situe le plus souvent la thèse dans un texte argumentatif de niveau B2 ?', '[{"id":"a","text":"Elle est souvent différée : annoncée prudemment, puis affirmée plus loin, notamment en fin de texte."},{"id":"b","text":"Elle figure toujours dans la première phrase du texte."},{"id":"c","text":"Elle n''apparaît jamais : le lecteur doit l''inventer."},{"id":"d","text":"Elle se trouve uniquement dans le titre."}]'::jsonb, 'a', 'Le cours indique qu''au B2 la thèse est souvent différée : l''auteur l''annonce prudemment puis l''affirme plus loin. Elle n''est ni toujours en tête, ni absente, ni cantonnée au titre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c20d04c2-70b7-5198-b5f9-e0fb05a50a7b', 'cfb43058-c9d7-5e86-9475-40b707d50340', 'Lisez l''extrait :
« Derrière la belle vitrine du progrès technologique se cache souvent une réalité moins reluisante. »

Que désigne ici « la belle vitrine » ?', '[{"id":"a","text":"Un magasin spécialisé en électronique."},{"id":"b","text":"Une vitre fragile qu''il faut protéger."},{"id":"c","text":"Une image flatteuse mais trompeuse, une façade."},{"id":"d","text":"Un objet de décoration moderne."}]'::jsonb, 'c', 'Au sens figuré, « belle vitrine » désigne une apparence séduisante qui masque autre chose ; le « derrière… se cache » confirme l''idée de façade. Le sens littéral (magasin, vitre, objet) est ici exclu par le contexte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c4929cb-aa87-5c4a-b842-8324fd804179', 'cfb43058-c9d7-5e86-9475-40b707d50340', 'Lisez l''extrait :
« On nous répète que ces caméras de surveillance garantissent notre sécurité. Mais aucune étude sérieuse n''a jamais établi qu''elles réduisaient la délinquance. »

La première phrase (« On nous répète… ») exprime :', '[{"id":"a","text":"La thèse personnelle de l''auteur."},{"id":"b","text":"Une opinion commune que l''auteur s''apprête à contester."},{"id":"c","text":"Un fait scientifique démontré."},{"id":"d","text":"Une hypothèse prudente de l''auteur."}]'::jsonb, 'b', '« On nous répète que… » rapporte une opinion commune, et le « Mais » qui suit annonce la riposte de l''auteur : c''est donc une voix adverse citée pour être contestée, pas la thèse de l''auteur ni un fait démontré.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('201c6d5f-3c2f-5d37-a919-2f8b3ed2f222', 'cfb43058-c9d7-5e86-9475-40b707d50340', 'Lisez l''extrait :
« Bravo aux organisateurs : un festival annoncé pour trente mille personnes a réuni, ce soir-là, une bonne centaine de courageux sous la pluie. »

Quel procédé l''auteur emploie-t-il ?', '[{"id":"a","text":"Un éloge sincère du festival."},{"id":"b","text":"Une description purement neutre."},{"id":"c","text":"L''ironie : le compliment est démenti par les chiffres."},{"id":"d","text":"Une hypothèse sur la météo."}]'::jsonb, 'c', 'Le « Bravo » est contredit par l''écart entre trente mille attendus et une centaine de présents : ce décalage entre l''éloge et les faits est la marque de l''ironie. Ce n''est ni un éloge sincère, ni une description neutre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9175245d-a8ad-5cc7-a0a1-4839d623b891', 'cfb43058-c9d7-5e86-9475-40b707d50340', 'Parmi ces énoncés, lequel est une HYPOTHÈSE et non un fait ?', '[{"id":"a","text":"Le chômage a baissé de 2 % au premier trimestre."},{"id":"b","text":"La loi a été votée le 12 mars."},{"id":"c","text":"Le musée a accueilli 4 000 visiteurs en mai."},{"id":"d","text":"La réforme aurait aggravé les inégalités selon plusieurs économistes."}]'::jsonb, 'd', 'Le conditionnel « aurait aggravé » marque une supposition prudente, donc une hypothèse. Les trois autres énoncés rapportent des données chiffrées ou datées, vérifiables : ce sont des faits.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('725530b0-9f2f-5b89-bbf8-d1961909a847', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', '⭐ Entraînement : thèse, ton et idée principale', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0709fa4-b689-5014-9942-662b7e6da89c', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« Les défenseurs de la voiture individuelle invoquent la liberté de se déplacer. Mais à l''heure où nos villes étouffent sous les embouteillages et la pollution, où chaque trajet solitaire encombre un peu plus l''espace commun, cette « liberté » a un prix que nous payons tous. Repenser nos mobilités n''est plus une option : c''est une nécessité. »

Quelle est la thèse de l''auteur ?', '[{"id":"a","text":"La voiture individuelle garantit la liberté de chacun."},{"id":"b","text":"Les embouteillages sont un problème mineur."},{"id":"c","text":"Il faut repenser nos modes de déplacement, devenus un coût collectif."},{"id":"d","text":"La pollution n''a aucun lien avec les transports."}]'::jsonb, 'c', 'La dernière phrase énonce la thèse : « Repenser nos mobilités… c''est une nécessité. » L''option a reprend la voix adverse (les défenseurs de la voiture), citée pour être réfutée par le « Mais » ; b et d contredisent le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab3cda70-840e-5c11-a271-a0a4ec35ee5e', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« Le maire a inauguré la nouvelle médiathèque avec emphase, promettant qu''elle deviendrait « le cœur battant du quartier ». Six mois plus tard, les rayonnages restent à moitié vides et les horaires d''ouverture ont déjà été réduits, faute de personnel. »

Quel est le ton de l''auteur ?', '[{"id":"a","text":"Enthousiaste et élogieux."},{"id":"b","text":"Sceptique et implicitement critique."},{"id":"c","text":"Strictement neutre et administratif."},{"id":"d","text":"Nostalgique et attendri."}]'::jsonb, 'b', 'L''auteur oppose les promesses du maire (« cœur battant du quartier ») à la réalité (rayonnages vides, horaires réduits) : ce contraste révèle une distance critique, donc un ton sceptique. Il ne partage pas l''enthousiasme du maire et le choix des faits n''est pas neutre.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9980c69-61d3-5c78-ac80-998b3ba3be92', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« On accuse volontiers les jeunes de ne plus lire. Pourtant, jamais une génération n''a autant écrit et déchiffré de textes : messages, articles partagés, forums, sous-titres. Ce n''est peut-être pas la lecture qui décline, mais l''idée que l''on s''en fait. »

Quelle est l''idée principale ?', '[{"id":"a","text":"Notre définition de la lecture est dépassée, plus que la pratique elle-même."},{"id":"b","text":"Les jeunes ne lisent effectivement plus du tout."},{"id":"c","text":"Les forums sont la meilleure forme de lecture."},{"id":"d","text":"Les sous-titres devraient être interdits."}]'::jsonb, 'a', 'Après « Pourtant », l''auteur conteste l''accusation et conclut que c''est « l''idée que l''on s''en fait » qui est en cause : c''est notre définition de la lecture qui est dépassée. L''option b reprend l''accusation réfutée ; c et d ne figurent pas dans le texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f892dcd1-8711-509a-bc87-0805272c97c9', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« Certes, le télétravail a permis à beaucoup de gagner du temps et de la souplesse. Mais il a aussi creusé un fossé entre ceux dont le métier s''exerce derrière un écran et ceux qui, sur le terrain, n''ont jamais eu ce choix. »

Quelle est la fonction du mot « Certes » au début du texte ?', '[{"id":"a","text":"Il introduit la conclusion définitive de l''auteur."},{"id":"b","text":"Il marque une cause expliquant le télétravail."},{"id":"c","text":"Il exprime un doute sur l''existence du télétravail."},{"id":"d","text":"Il concède un point avant d''introduire l''objection principale par « Mais »."}]'::jsonb, 'd', '« Certes… Mais » est un couple concessif : « Certes » accorde un avantage au télétravail, puis « Mais » introduit la véritable objection (le fossé entre métiers). Ce n''est ni une conclusion, ni une cause, ni un doute sur son existence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90349fb6-6e89-5fc1-ae5d-8daf97ff6cfc', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« La fréquentation du parc national a augmenté de 40 % en deux ans. Pour certains, c''est une belle victoire pour l''accès à la nature ; pour d''autres, le signe inquiétant d''un site bientôt saturé et menacé. »

Dans cet extrait, qu''est-ce qui relève du FAIT ?', '[{"id":"a","text":"La fréquentation a augmenté de 40 % en deux ans."},{"id":"b","text":"C''est une belle victoire pour l''accès à la nature."},{"id":"c","text":"Le site est bientôt saturé et menacé."},{"id":"d","text":"L''accès à la nature est plus important que sa protection."}]'::jsonb, 'a', '« +40 % en deux ans » est une donnée chiffrée vérifiable : un fait. « Belle victoire » et « inquiétant… saturé » sont des jugements opposés (opinions) ; l''option d est une prise de position absente du texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da8a7e82-b599-5aa5-8d0e-197f47e35767', '725530b0-9f2f-5b89-bbf8-d1961909a847', 'Lisez l''extrait :
« Après des mois de débats houleux, le projet de loi a fini par être adopté. Reste à savoir si les moyens suivront, ou si ce texte rejoindra la longue liste des bonnes intentions restées lettre morte. »

Que suggère la dernière phrase ?', '[{"id":"a","text":"Que la loi sera certainement appliquée avec succès."},{"id":"b","text":"Que les débats ont été calmes et consensuels."},{"id":"c","text":"Que l''auteur doute que la loi soit réellement appliquée, faute de moyens."},{"id":"d","text":"Que la loi a été rejetée par le parlement."}]'::jsonb, 'c', '« Reste à savoir si les moyens suivront » et « lettre morte » expriment un doute : l''auteur n''est pas sûr que la loi soit appliquée. Le texte dit au contraire qu''elle a été adoptée (pas rejetée) après des débats « houleux » (pas calmes).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', '⭐⭐ Révision : voix, contre-arguments et sens figuré', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5fa98c2-7ac7-57d0-99f6-4963fbd328b7', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« Les partisans du tout-numérique à l''école promettent des élèves plus motivés et mieux préparés au monde de demain. Leurs détracteurs rétorquent que rien ne remplace le contact humain et que l''écran fatigue plus qu''il n''enseigne. Le débat, lui, ne fait que commencer. »

Quelle est la position de l''auteur ?', '[{"id":"a","text":"Il défend ardemment le tout-numérique à l''école."},{"id":"b","text":"Il reste neutre et expose les deux camps sans trancher."},{"id":"c","text":"Il condamne fermement l''usage des écrans."},{"id":"d","text":"Il juge le débat inutile et dépassé."}]'::jsonb, 'b', 'L''auteur rapporte les arguments des « partisans » puis des « détracteurs » avec des verbes neutres (« promettent », « rétorquent ») et conclut que « le débat ne fait que commencer » : il expose les deux voix sans prendre parti. Il ne défend ni ne condamne, et ne juge pas le débat inutile.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c15eb40-9944-5153-bbbb-c27526806cdc', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« Bien sûr, on objectera que ces mesures coûtent cher. Mais que pèsent quelques millions face aux vies qu''un dépistage précoce permettrait de sauver chaque année ? »

Quelle est la fonction de la première phrase (« Bien sûr, on objectera… ») ?', '[{"id":"a","text":"Elle énonce la thèse principale de l''auteur."},{"id":"b","text":"Elle donne une preuve chiffrée à l''appui de la thèse."},{"id":"c","text":"Elle conclut le raisonnement."},{"id":"d","text":"Elle anticipe un contre-argument pour mieux le réfuter ensuite."}]'::jsonb, 'd', '« On objectera que… » présente d''avance l''objection (le coût) que l''auteur va aussitôt balayer par sa question rhétorique : c''est une concession anticipée pour mieux la réfuter. Ce n''est pas la thèse, ni une preuve, ni une conclusion.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfa0edf8-d53c-551f-baf1-2b86786c0415', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« Les promesses de campagne, on le sait, fondent comme neige au soleil dès le lendemain de l''élection. »

Que signifie l''expression « fondre comme neige au soleil » ?', '[{"id":"a","text":"Disparaître rapidement et sans laisser de trace."},{"id":"b","text":"Se renforcer avec le temps."},{"id":"c","text":"Devenir plus froides et distantes."},{"id":"d","text":"Se multiplier de façon inattendue."}]'::jsonb, 'a', 'L''image « fondre comme neige au soleil » signifie s''évanouir vite et totalement ; appliquée aux promesses, elle souligne qu''elles sont vite oubliées. Le sens figuré exclut l''idée de renforcement, de froideur ou de multiplication.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('958ebc19-c1c0-59f1-b7f7-69a4d398af42', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« On vante la « gratuité » des grands réseaux sociaux. Gratuité ? Le mot fait sourire. Car si nous ne payons pas avec notre argent, nous payons abondamment avec nos données, notre attention et, parfois, notre tranquillité d''esprit. »

Pourquoi l''auteur met-il « gratuité » entre guillemets ?', '[{"id":"a","text":"Pour citer fidèlement un expert reconnu."},{"id":"b","text":"Parce qu''il s''agit d''un terme technique précis."},{"id":"c","text":"Pour marquer une distance ironique : il conteste cette prétendue gratuité."},{"id":"d","text":"Pour indiquer une traduction d''un mot étranger."}]'::jsonb, 'c', 'Les guillemets, renforcés par « Le mot fait sourire » et le « Car » qui révèle le vrai coût (données, attention), signalent une distance ironique : l''auteur récuse l''idée de gratuité. Ce n''est ni une citation d''expert, ni un terme technique, ni une traduction.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efaf276e-41b5-50a6-b06f-389997993d35', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« Le rapport souligne des progrès indéniables dans l''accès aux soins. Il reconnaît néanmoins que les zones rurales restent largement à l''écart de ces avancées, et que sans transports adaptés, le meilleur hôpital du monde demeure inaccessible. »

Comment le texte présente-t-il la situation des zones rurales ?', '[{"id":"a","text":"Comme pleinement bénéficiaire des progrès décrits."},{"id":"b","text":"Comme un détail négligeable sans importance."},{"id":"c","text":"Comme la preuve que le rapport est mensonger."},{"id":"d","text":"Comme une limite importante aux progrès, soulignée par le « néanmoins »."}]'::jsonb, 'd', 'Le « néanmoins » introduit une réserve : malgré des progrès, les zones rurales « restent largement à l''écart ». Le texte en fait une limite sérieuse, pas un détail. Il ne dit pas qu''elles bénéficient des progrès ni que le rapport est mensonger.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92c9a27b-c4e9-517b-a302-a71582170d60', 'b431d1a2-34d6-53fe-8a5e-cc68bed56611', 'Lisez l''extrait :
« Adopter ce nouveau logiciel ? L''idée séduit sur le papier. Encore faudrait-il que les équipes soient formées, que les anciens fichiers soient compatibles et que le budget de maintenance suive. Autant de « détails » dont personne ne semble vouloir parler. »

Que sous-entend l''auteur en parlant de « détails » ?', '[{"id":"a","text":"Que ces points sont vraiment mineurs et faciles à régler."},{"id":"b","text":"Que ces obstacles sont en réalité majeurs, mais sont passés sous silence."},{"id":"c","text":"Que le logiciel a déjà été adopté avec succès."},{"id":"d","text":"Que la formation des équipes est déjà terminée."}]'::jsonb, 'b', 'Les guillemets autour de « détails » sont ironiques : formation, compatibilité et budget sont des obstacles lourds, et « personne ne semble vouloir parler » de ce qui dérange. L''auteur souligne donc des problèmes majeurs minimisés, et non des points réellement mineurs ou déjà résolus.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', '⚔️ Boss du chapitre ⭐⭐⭐ : ironie, implicite et structure', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc6f8898-1df4-519f-9af3-0503cc112044', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« On nous l''a assez répété : la croissance résoudra tout. Le chômage ? La croissance. La pauvreté ? La croissance. La dette ? Encore la croissance. À force d''invoquer ce remède universel, on a fini par oublier de se demander s''il guérissait vraiment, ou s''il ne faisait que masquer les symptômes. »

Quelle est la thèse implicite de l''auteur ?', '[{"id":"a","text":"La croissance est effectivement la solution à tous les problèmes."},{"id":"b","text":"Le chômage est le seul vrai problème de la société."},{"id":"c","text":"La croissance est invoquée comme un remède miracle dont l''efficacité réelle n''est jamais questionnée."},{"id":"d","text":"Il faut augmenter la dette pour relancer la croissance."}]'::jsonb, 'c', 'La répétition ironique (« La croissance », « Encore la croissance ») et l''image du « remède universel » qui « masque les symptômes » montrent que l''auteur conteste cette foi aveugle. Sa thèse : on ne questionne jamais l''efficacité réelle de la croissance. L''option a confond la voix critiquée avec celle de l''auteur (le piège courant) ; b et d ne sont pas dans le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f68ffb6-4d71-52b3-ad07-d16ed596af79', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« Nos dirigeants, dans leur infinie sagesse, ont décidé de réduire le budget de la recherche l''année même où une épidémie rappelait à tous combien la science nous est vitale. »

Quel est l''effet de l''expression « dans leur infinie sagesse » ?', '[{"id":"a","text":"Elle est ironique : elle souligne, par antiphrase, l''absurdité de la décision."},{"id":"b","text":"Elle exprime une admiration sincère pour les dirigeants."},{"id":"c","text":"Elle constitue une simple information neutre."},{"id":"d","text":"Elle annonce une hypothèse sur l''avenir de la recherche."}]'::jsonb, 'a', '« Dans leur infinie sagesse » loue la décision au moment même où le texte en montre l''absurdité (couper la recherche pendant une épidémie) : c''est une antiphrase ironique, l''auteur pense le contraire de ce qu''il dit. Il n''y a ni admiration réelle, ni neutralité, ni hypothèse.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('074cd333-b674-5e18-ba7b-cd553553a1eb', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« Il serait tentant de voir dans cette baisse de la délinquance le seul fruit des nouvelles caméras. La réalité est plus nuancée : la même période a connu une forte hausse de l''emploi des jeunes et un renforcement des médiateurs de quartier. »

Qu''est-ce que l''auteur cherche à montrer ?', '[{"id":"a","text":"Que les caméras sont la seule cause de la baisse de la délinquance."},{"id":"b","text":"Que la délinquance n''a pas réellement baissé."},{"id":"c","text":"Que les médiateurs de quartier sont inutiles."},{"id":"d","text":"Que la baisse de la délinquance a plusieurs causes, pas seulement les caméras."}]'::jsonb, 'd', '« La réalité est plus nuancée » introduit d''autres facteurs (emploi des jeunes, médiateurs) : l''auteur récuse l''explication unique par les caméras au profit de causes multiples. L''option a est précisément la lecture simpliste que le texte combat ; b et c contredisent le texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('210aaa23-efca-587f-a174-9495189ed69c', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« Le tourisme de masse, dit-on, fait vivre la région. Soit. Mais à quel prix ? Des centres-villes désertés par leurs habitants, transformés en décors pour cartes postales, où l''on ne croise plus que des valises à roulettes et des boutiques de souvenirs identiques d''une ville à l''autre. »

Que suggère l''image des « centres-villes transformés en décors pour cartes postales » ?', '[{"id":"a","text":"Que ces villes sont devenues plus belles et mieux entretenues."},{"id":"b","text":"Que ces villes ont perdu leur authenticité et leur vie réelle, réduites à une façade pour touristes."},{"id":"c","text":"Que les habitants y sont plus nombreux qu''avant."},{"id":"d","text":"Que la photographie y est interdite."}]'::jsonb, 'b', '« Décors pour cartes postales », « désertés par leurs habitants », « boutiques identiques » disent une ville vidée de sa vie réelle, réduite à une façade pour touristes. L''image est péjorative : pas d''embellissement, pas plus d''habitants, et rien sur une interdiction de photographier.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d65fb17-ad5b-5a59-9e60-06eeb6e12893', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« Le rapport se félicite d''un taux de réussite « historique » à l''examen. On aimerait partager cet enthousiasme. Encore faudrait-il savoir si les épreuves ont gardé la même exigence, ou si l''on a simplement déplacé la barre vers le bas. »

Quelle attitude l''auteur adopte-t-il face au taux de réussite ?', '[{"id":"a","text":"Une adhésion totale et sans réserve."},{"id":"b","text":"Une indifférence complète."},{"id":"c","text":"Un rejet de toute idée de réussite scolaire."},{"id":"d","text":"Une réserve sceptique : il soupçonne une baisse d''exigence derrière le bon chiffre."}]'::jsonb, 'd', '« On aimerait partager cet enthousiasme. Encore faudrait-il… » exprime une réserve, et l''hypothèse « déplacé la barre vers le bas » suggère que le bon taux pourrait venir d''une exigence moindre. Ce n''est ni une adhésion, ni de l''indifférence, ni un rejet de la réussite en soi.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57fe1ac8-64f3-5ea0-aba5-9091ab0f40f3', '2ff86a67-61e2-50b2-8b0b-e1926f006b77', 'Lisez l''extrait :
« Premier paragraphe : on célèbre les bienfaits supposés des compléments alimentaires. Deuxième paragraphe (introduit par « Pourtant ») : aucune étude indépendante n''en confirme l''utilité, et certains présentent même des risques. Troisième paragraphe : « En somme, mieux vaut une assiette équilibrée qu''une armoire à pharmacie. »

Quelle est la fonction du troisième paragraphe ?', '[{"id":"a","text":"Il conclut en formulant la thèse de l''auteur : l''alimentation prime sur les compléments."},{"id":"b","text":"Il introduit un nouveau sujet sans rapport."},{"id":"c","text":"Il rapporte l''avis des fabricants de compléments."},{"id":"d","text":"Il pose une question restée sans réponse."}]'::jsonb, 'a', '« En somme » est un articulateur de conclusion : après l''éloge (§1) puis la réfutation (§2, « Pourtant »), le §3 tranche en faveur de l''alimentation, c''est la thèse de l''auteur. Ce n''est pas un nouveau sujet, ni l''avis des fabricants, ni une question ouverte.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', '👑 Défi élite ⭐⭐⭐⭐ : lecture critique des textes argumentatifs', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('464850d0-cfea-585d-ae39-8669fd219201', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait d''éditorial :
« Voilà donc qu''on nous propose, pour « sauver la planète », de culpabiliser le consommateur à chaque geste : ton sac, ton trajet, ta douche. Pendant ce temps, une poignée d''industries continue d''émettre, en toute quiétude, l''essentiel des gaz à effet de serre. La vertu individuelle a bon dos quand elle dispense de regarder les vrais responsables. »

Quelle est la thèse de l''éditorialiste ?', '[{"id":"a","text":"Les gestes individuels suffisent à sauver la planète."},{"id":"b","text":"Centrer le débat sur la culpabilité individuelle détourne l''attention des principaux pollueurs."},{"id":"c","text":"Il ne sert à rien de protéger la planète."},{"id":"d","text":"Les industries ne polluent pas réellement."}]'::jsonb, 'b', 'L''expression « a bon dos » et l''opposition entre le consommateur culpabilisé et « une poignée d''industries… en toute quiétude » montrent que l''auteur dénonce un détournement d''attention vers l''individu. L''option a reprend la cible de sa critique ; c et d sont des contresens (il défend l''écologie et accuse les industries).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e99ef1f9-2115-590e-928f-f100c8b5e65f', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait :
« Les nostalgiques de « l''école d''autrefois » oublient opportunément qu''à l''époque tant vantée, une part importante des enfants quittait le système sans le moindre diplôme. La mémoire, décidément, est une grande nettoyeuse. »

Que signifie l''image finale « la mémoire est une grande nettoyeuse » ?', '[{"id":"a","text":"La mémoire conserve fidèlement tous les détails du passé."},{"id":"b","text":"Il faut nettoyer régulièrement ses souvenirs."},{"id":"c","text":"La mémoire efface les aspects négatifs du passé et en garde une image embellie."},{"id":"d","text":"Le passé était objectivement meilleur que le présent."}]'::jsonb, 'c', 'L''auteur rappelle un fait gênant (les enfants sans diplôme) « oublié opportunément » : la métaphore de la « nettoyeuse » dit que la mémoire gomme le négatif et embellit le passé. C''est l''inverse d''une conservation fidèle, et l''auteur conteste justement que le passé fût meilleur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a92c35c5-e11e-5113-949f-a7ed92414bb0', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait :
« Que les algorithmes nous recommandent des films, passe encore. Qu''ils décident demain de qui obtient un crédit, un emploi, une libération conditionnelle, sans que nul ne puisse expliquer pourquoi — voilà qui devrait nous tenir éveillés la nuit. »

Quel est le point de vue de l''auteur sur les algorithmes de décision ?', '[{"id":"a","text":"Il les approuve sans réserve dans tous les domaines."},{"id":"b","text":"Il les juge utiles uniquement pour les décisions de justice."},{"id":"c","text":"Il y est totalement indifférent."},{"id":"d","text":"Il s''inquiète de leur usage dans des décisions graves et opaques."}]'::jsonb, 'd', 'L''auteur tolère les recommandations de films (« passe encore ») mais s''alarme de décisions lourdes et inexplicables (« devrait nous tenir éveillés la nuit ») : il dénonce l''opacité dans les choix graves. Il n''approuve pas sans réserve, n''est pas indifférent, et ne réserve pas son inquiétude à la justice seule.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db479135-0e5b-56b7-ad46-ec811fa6f3d0', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait :
« Certes, le projet de rénovation embellira le quartier ; nul ne le conteste. Mais lorsqu''on apprend que les loyers doubleront et que les commerçants historiques devront partir, on est en droit de se demander : embellir, pour qui, exactement ? »

Quelle est la fonction de la question finale (« embellir, pour qui ? ») ?', '[{"id":"a","text":"C''est une question rhétorique qui suggère que la rénovation profitera surtout à de nouveaux arrivants, pas aux habitants actuels."},{"id":"b","text":"C''est une vraie demande d''information que l''auteur pose par ignorance."},{"id":"c","text":"Elle prouve que l''auteur approuve pleinement le projet."},{"id":"d","text":"Elle indique que le projet a été abandonné."}]'::jsonb, 'a', 'La concession (« Certes… nul ne le conteste ») prépare le « Mais » qui révèle les perdants (loyers doublés, commerçants chassés) ; la question rhétorique « pour qui ? » sous-entend que d''autres en profiteront. Ce n''est pas une vraie question, ni une approbation, ni une annonce d''abandon.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f779587e-3967-51fa-a8f4-fcb433695c22', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait :
« On célèbre l''essor du bénévolat comme une preuve de générosité retrouvée. L''analyse est flatteuse. Elle l''est peut-être trop : et si cette « générosité » comblait surtout le vide laissé par des services publics qui, faute de moyens, ont cessé d''assurer ce qu''ils devaient ? »

Quel sous-entendu porte cet extrait ?', '[{"id":"a","text":"Le bénévolat est inutile et devrait disparaître."},{"id":"b","text":"Les services publics sont parfaitement financés."},{"id":"c","text":"L''essor du bénévolat pourrait masquer un désengagement de l''État plutôt qu''un surcroît de générosité."},{"id":"d","text":"La générosité des citoyens a réellement augmenté de façon certaine."}]'::jsonb, 'c', '« L''est peut-être trop » et l''hypothèse au conditionnel (« et si… comblait… ») sous-entendent que le bénévolat compenserait le retrait des services publics, plus qu''une vraie générosité. L''auteur ne condamne pas le bénévolat (a), conteste le bon financement public (b) et doute de l''explication par la générosité (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('545ecd21-37dd-5146-995e-f0aa2e45ede4', 'cf4a839f-5b46-51fc-8851-1ca2cb6a4183', 'Lisez l''extrait :
« Les défenseurs du projet avancent qu''il créera des emplois — argument imparable, semble-t-il. Mais ces emplois seront précaires, mal payés, et disparaîtront sitôt les subventions épuisées. Présenter cela comme un progrès social relève moins de l''analyse que de la publicité. »

Comment l''auteur traite-t-il l''argument « cela créera des emplois » ?', '[{"id":"a","text":"Il l''accepte comme une preuve décisive en faveur du projet."},{"id":"b","text":"Il le cite comme contre-argument, puis le démonte en montrant la précarité de ces emplois."},{"id":"c","text":"Il l''ignore complètement."},{"id":"d","text":"Il affirme qu''aucun emploi ne sera créé."}]'::jsonb, 'b', 'L''auteur rapporte l''argument adverse (« créera des emplois — argument imparable, semble-t-il »), avec un « semble-t-il » déjà sceptique, puis le réfute par le « Mais » (emplois précaires, éphémères) et le qualifie de « publicité ». Il ne l''accepte donc pas, ne l''ignore pas, et ne nie pas toute création d''emploi : il en conteste la valeur.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('94619014-b090-5f36-9868-d40584d8c779', 'bcaf7a17-3906-5b1e-94fe-11f1792d3df1', 'francais-b2', '⭐⭐ Drill : révision globale de la compréhension écrite', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4d77114-52a6-5d30-a251-0e6da9497fc5', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« On présente souvent la suppression des notes à l''école comme un progrès évident. Pourtant, sans repère chiffré, certains élèves peinent à mesurer leurs progrès, et certains parents naviguent à vue. La question mérite mieux qu''un slogan. »

Quelle est la position de l''auteur ?', '[{"id":"a","text":"Il défend sans réserve la suppression des notes."},{"id":"b","text":"Il réclame le retour immédiat des notes partout."},{"id":"c","text":"Il estime que le sujet est sans intérêt."},{"id":"d","text":"Il invite à la prudence et refuse de trancher par un simple slogan."}]'::jsonb, 'd', 'Le « Pourtant » et « La question mérite mieux qu''un slogan » montrent que l''auteur nuance l''idée reçue sans la rejeter en bloc : il appelle à la réflexion. Il ne défend pas l''option a (la voix initiale), ne réclame pas le retour des notes, et ne juge pas le sujet sans intérêt.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('526f44bf-c046-5786-b98c-fcf7bb1d63f4', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« Le concert, paraît-il, fut « inoubliable ». Inoubliable, en effet, pour les quelques spectateurs qui, faute de chauffage, ont passé la soirée à grelotter dans une salle à moitié vide. »

Quel est le ton de cet extrait ?', '[{"id":"a","text":"Ironique : « inoubliable » est repris pour se moquer de l''événement raté."},{"id":"b","text":"Élogieux et reconnaissant envers les organisateurs."},{"id":"c","text":"Strictement factuel et sans jugement."},{"id":"d","text":"Nostalgique et ému."}]'::jsonb, 'a', 'L''auteur reprend « inoubliable » entre guillemets puis le retourne (« inoubliable… pour grelotter dans une salle à moitié vide ») : ce décalage entre l''éloge et la réalité est ironique. Il n''y a ni éloge sincère, ni neutralité, ni nostalgie.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eaa07d89-5a79-5008-825b-cf0d20d30911', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« Le rapport indique que 60 % des sondés se disent favorables à la mesure. Pour ses promoteurs, c''est un plébiscite ; pour ses opposants, c''est l''aveu que près de la moitié des gens n''en veulent pas. »

Dans cet extrait, qu''est-ce qui relève du FAIT ?', '[{"id":"a","text":"La mesure est un plébiscite."},{"id":"b","text":"60 % des sondés se disent favorables à la mesure."},{"id":"c","text":"Près de la moitié des gens rejettent la mesure par principe."},{"id":"d","text":"La mesure est mauvaise pour le pays."}]'::jsonb, 'b', '« 60 % des sondés se disent favorables » est une donnée d''enquête vérifiable : un fait. « Plébiscite » et « aveu que près de la moitié n''en veulent pas » sont deux interprétations opposées du même chiffre (opinions) ; l''option d est un jugement absent du texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8211a675-f38f-5f50-b3f9-6c26b23d5e11', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« Bien que la fréquentation des bibliothèques ait reculé, il serait hâtif d''y voir la mort du livre : jamais on n''a tant emprunté de livres numériques ni écouté de livres audio. »

Quelle est la fonction de « Bien que » au début de la phrase ?', '[{"id":"a","text":"Il exprime une cause directe du recul des bibliothèques."},{"id":"b","text":"Il annonce la conclusion finale de l''auteur."},{"id":"c","text":"Il introduit une concession : un fait défavorable que l''auteur reconnaît avant de le nuancer."},{"id":"d","text":"Il marque une simple addition de deux idées équivalentes."}]'::jsonb, 'c', '« Bien que » est un connecteur de concession : l''auteur admet le recul des bibliothèques, puis le relativise (« il serait hâtif… ») en citant le numérique et l''audio. Ce n''est ni une cause, ni une conclusion, ni une simple addition.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d461361-f124-572f-9f1f-aea0f695eb79', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« À en croire la brochure, ce quartier neuf serait un « havre de verdure ». Sur place, trois arbres rachitiques tentent de survivre entre deux parkings de béton. »

Que suggère le contraste entre les deux phrases ?', '[{"id":"a","text":"Que la réalité dément la promesse publicitaire du « havre de verdure »."},{"id":"b","text":"Que le quartier est effectivement très végétalisé."},{"id":"c","text":"Que la brochure dit la stricte vérité."},{"id":"d","text":"Que l''auteur recommande chaleureusement ce quartier."}]'::jsonb, 'a', 'Le « havre de verdure » de la brochure est démenti par « trois arbres rachitiques » entre des parkings de béton : le contraste révèle l''écart entre la promesse et la réalité. Le quartier n''est donc pas verdoyant, la brochure ne dit pas vrai, et l''auteur ne le recommande pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcad836d-8e60-500a-98cf-0321056e75ee', '94619014-b090-5f36-9868-d40584d8c779', 'Lisez l''extrait :
« Les partisans de la réforme parlent de modernisation. Ses détracteurs, de démantèlement. Entre les deux, l''usager, lui, attend surtout de savoir si son bureau de poste sera encore ouvert le mois prochain. »

Que sous-entend la dernière phrase à propos du débat ?', '[{"id":"a","text":"Que l''usager soutient pleinement la réforme."},{"id":"b","text":"Que le bureau de poste a déjà fermé définitivement."},{"id":"c","text":"Que les détracteurs ont forcément tort."},{"id":"d","text":"Que, derrière les grands mots des deux camps, c''est l''inquiétude concrète de l''usager qui compte."}]'::jsonb, 'd', 'En opposant « modernisation » et « démantèlement » à la question très concrète de l''usager (« son bureau encore ouvert le mois prochain »), l''auteur sous-entend que les étiquettes des deux camps comptent moins que la réalité vécue. L''usager ne prend pas parti, le bureau n''est pas dit fermé, et le texte ne tranche pas en faveur d''un camp.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

