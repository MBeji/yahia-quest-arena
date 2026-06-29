-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-c1 (Français — Autonome (C1 · DALF C1))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-c1/
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
  ('francais-c1', 'Français — Autonome (C1 · DALF C1)', 'Vise l''autonomie : maîtrise l''accord du participe passé dans les cas difficiles, la concordance des temps, la mise en relief, la nominalisation, les connecteurs avancés et l''articulation du discours, les registres de langue, les expressions idiomatiques et le lexique soutenu, et la lecture de textes complexes. Niveau autonome (CECRL C1), aligné sur le DALF C1.', 'Agilité', 'subject-french', 'Languages', 5, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-c1'
      AND e.source = 'admin'
      AND q.id NOT IN ('c3ed080f-c7d5-58e9-b611-73f0eeacf2d1', '0f043a39-a062-552e-a7f5-6d781231510a', '8e1cebda-3d9d-55be-8547-ac94bbc54c15', '944c9b98-ee1c-50c3-b24e-f291509a3a3b', '2e07776c-2820-5f29-9f33-4e4da093d59c', '11237457-58d9-5d3b-b12c-a9f4fba1bb5c', '6342529d-ab03-52e3-bb50-e7423ce18380', 'bb2f62b4-2671-502b-8654-7c671340aa0a', 'bee7ed77-cb9b-5158-be60-9c8e508818fa', '1a45f61b-9084-5ab6-9d36-b96f0a7e0c72', 'cf44a16a-f85e-5126-89ca-6b6c756227bf', 'af8e2222-4b77-560c-8765-8e6bbf6b66d7', 'e0830eb7-0e91-5da3-aaad-9da8cc493474', '44c506f0-31a1-57db-9e95-ed8ae4978cb3', 'b3a00945-2861-55b9-8874-8320c0b1e967', 'b51c9e03-780d-5704-9c18-e651c93fab70', 'a47bfc43-e374-5904-9d44-e309f9d1766b', '978042ff-ebe3-5e9e-95f8-e5bbc38c02e4', 'f25c20a8-f807-5f7d-b356-1b550bf9b9d2', '34cbbe22-520f-5289-9523-02c6a99d97a7', '8d140818-dc74-5f79-9524-d5cc1d734d4c', '5be3f9a9-191d-5ca3-a8da-714656742dc3', 'f86855cc-1a2b-59ea-b9a7-be701b5c1dac', '5873ec30-220c-5e15-8792-500430e9fd65', 'cb8d709f-7929-578c-a800-c2558fcf5817', '0487d769-b1a9-56b4-89ba-8976572d5e1e', '01ad1c48-6e32-563a-ab2c-837b701f4177', 'ea5b90d1-33ad-5da8-a51b-73d567ebe20c', '79dd978d-8f11-5932-9312-063f18a6b0dd', 'b5df4d9a-7862-5f25-9ff3-f72700b95560', 'a9daec88-f6b4-54e4-8507-86b21064e25f', '17f81caa-c1f6-52bd-adce-4e12341f90cb', '594d7d45-58ba-599c-b446-f889e4326709', '639a7ba3-fd80-56f4-b129-4ab9187e1a36', '810c4952-f53f-5622-a213-4f3571b7d23b', '5d43edbc-5b05-5c13-9235-ee8b24fc848d', '839117d8-6365-5c93-816a-fb2268ea35eb', 'd128e874-e35c-5082-a553-1ab9c957e300', 'ba7c6047-b853-5a79-9a8b-be8152dc8752', '9286245b-ab8b-5a41-a25a-5038f02ea50e', '7d5f2a84-1485-5999-a04c-55cca0be6f82', '53d28307-a609-5fa8-94d0-f7fc99e4c7e2', '48e54a10-1db0-5a46-bbc1-9bfe0cad616f', '7a8ac4e1-c4a1-5904-948c-44089195d1d4', '879a36c7-6eb5-56df-bdc8-61da97b08120', 'a4caef19-4bb5-5258-abb6-f5c5dec91dd2', 'f412d47b-31f2-5097-a336-583102dd19f9', '1fc856bc-92bb-5695-bcf7-64d95d33199b', 'c6f79d64-1c06-5ed6-bf49-6adce4da4f8a', '98d90e1b-0e63-50c2-9889-a11b9c23af46', '5353871c-d393-5f03-9123-becde94f6dba', '116aa368-5294-587b-8c9a-fe07e0f02611', 'bc9aed38-02db-5074-bac1-3bbdde09ac00', 'c900576f-9a1f-5e51-bf62-792410236833', 'b61301dc-969d-568c-a61c-4f68a0aa6571', 'c34c8b4a-ccc0-567b-b7c1-e3a124adbabb', 'a3897316-fcee-57a7-943b-29c32ef8cd42', '8dc3e64d-59a5-52df-904e-6d70d45953ea', 'd4763290-850e-52ef-a473-cbb36502b007', '7b508c52-4129-58df-aad8-39afac3bb5db', 'bfd4795b-f2ac-5743-b47f-e65b0f1700f6', '56f89e54-104a-5825-b0f5-d21f8135e7a9', 'e23985af-fef5-5e33-a666-ed0b54098bbb', '45f17cda-50d8-56e0-a7b9-a70e732a495c', '67490c81-7522-5678-9494-8eafe22dd6f6', '100ab80c-c333-5523-9b3c-27b5d9130875', 'ba58ccdd-602f-5861-adca-1b619c969c66', 'f4fd74d9-2728-5e59-b387-68118bbf2662', 'd47fc8cf-9712-5715-b55b-fec749d77771', '682674c6-cb1e-547e-af43-9b870a74149b', 'd620c25b-5c84-55eb-9a05-8cb695c819b7', 'd1d1afbb-5d9c-5012-9bdc-3c05bb2a26a8', 'cc7f129e-8ba9-50c2-8b99-7925569a0b5d', 'b364268f-1c67-5c31-acc4-f8550f10296a', '6e7f4297-74e1-5f0d-a0c8-52fcd77bf2c5', 'ec9cc806-5fb1-5cc6-bb34-e144d29f39a7', 'd12526e5-a8b9-56dc-b9fc-ab06bf83a03d', '476b8774-769c-5958-8ad3-b9cd19e293c3', 'e71c8ec1-aeb4-562c-bb8f-5a8af7347b2e', '309fd65f-0567-59ee-9d60-66d6ec4678f6', '9499efe4-22a3-5c65-a7fd-6b02cff47798', 'ca5e542a-6c71-54d4-a6b0-1390ca347d6b', '79533cbf-0735-52af-94d1-b70177385323', '7e7236cd-271b-5e58-99a1-b5a9b2955ab2', '6a547c4a-472d-5148-a982-54e188a3b176', '70920fd7-84bf-511d-bb5b-24047626c7e4', '90384d86-a4ab-5f77-9eb6-afd750ab9727', 'bb8e18e9-bd45-5eb3-979e-1e5d8a2a78e2', '2f52d071-7de1-5a82-a051-69447282af8f', '26f40e90-d553-5c82-a07c-9603948a645b', 'b05c8b07-5066-5bb0-badd-c9ac409a7f40', '1ce79a31-a780-551d-97ed-af1717e80a5c', 'db390fc3-7997-5b3e-a2c0-2b4f8224cb9a', '8d8adb85-e119-5941-a685-bbf49f3c74f2', 'b6e16e97-7c6e-58ea-abba-d52133051e9a', 'da21e47b-5a01-5c61-b38a-af0fa382ee61', 'e305f447-aa9a-5825-bd3d-6b4d5848e008', 'a60c503a-a358-508c-8771-f9a55a7f5c40', '3c34b47d-b68d-51ce-a962-fd050792c67e', 'db05c774-979f-5c5f-ae8d-960bbfc8bb97', '44a64b52-eeae-566e-bb68-6ba0248a517b', 'cee14fd1-3a82-573d-ac3f-03327423e97e', '3287a867-fead-528d-9a38-83e77e1cce0f', 'e2eb12b9-d39d-52b2-baef-3284140f5200', 'ee603ff4-ef15-5b2c-8415-27ed1ea22de5', '099d558e-369d-5fd4-a1c4-7a86bd613358', '123fccc2-c7b2-5396-8cd8-1313e23afd85', 'e65f4167-259f-54fd-be56-4bd7da8896db', 'ab5cedf3-c6c7-59dd-b355-2aa3b6d37539', 'ec62f594-05c5-54f6-ae27-222e761b6d78', '9fcf9baf-cd80-5979-9cc0-6209b40f36f9', 'ec788a73-1656-5def-b99a-61d8cd9499c4', 'da201679-cc2e-5ce8-8830-9364b5aa3b9c', 'c8697c61-90a7-5a5c-a43c-4acb0e5f7c70', 'c818e096-3a6d-5c89-856d-02d4f4bd029a', '12484694-3422-502d-b2c9-f561f556ee20', 'c117ac7c-4d43-58ac-a8b3-bee14f213f34', 'a10c48e5-422b-59f5-ba0b-f7bc637e60e2', '66caad7b-3d79-5c5d-a5d4-6bd4570e023c', '3e0c0e67-5a49-5f8e-810b-ea57549d843f', 'ca3fb4b7-5e4c-50ef-816c-16cd8b855152', '818cd98a-dbf8-55c3-9b6f-ef881973f67d', 'f8a9a48a-83cc-5a8c-9378-25a8fe2a9b0d', 'd89fb7db-96cf-52a8-a915-ac3d3d886be8', 'effb5d15-c08f-5d16-98ca-0f6c1df86928', 'dfba706a-0a80-516d-a3da-c6216e02e408', '8f467402-95fb-51cb-b3d2-1e1155ef5f09', '6bfff066-0ab0-506d-a98b-fe2248308835', 'c5b4ece6-f0ae-5c5e-947b-9a77aab80728', '3f1c2bcb-7405-571a-9e8e-40f0ec5be18e', '388807e1-36fe-556b-a3bc-61c51643f1bd', '863ed009-e33f-5ef2-97c8-d29fc1417699', '7a26e55c-6b0c-5934-987a-b070bf64fee8', '508b9dee-a95b-5bc0-806a-d17be329475e', '77c68ce2-f76f-5759-9f48-1b98b075ce98', '08869e69-06a0-5cf5-b049-bea35472a89f', '7f0bb918-602a-52c3-995b-e4b132f7f31d', '19a112cf-cdd8-530d-ba75-a2edc1e72bb2', 'cc619469-5f9b-5a07-b931-e722e57f73e1', '701e0655-a0de-54ea-b5c8-65efb9576a9f', 'd5159c64-12d7-5077-9a58-35fb94800ddb', 'b4409000-5d58-5bd1-b6ba-96243901e492', '11ebe136-80de-5469-a62f-200d6a83fd97', 'e5c1e927-b346-5836-9cc4-5c98557f28fe', '5c066da4-46ce-5686-9819-ae29d2f8df4a', 'd8338ce8-ea96-5341-9de8-3f97c2fd1688', '939e5c5e-6ebb-5620-92fd-964b6769de34', '82c7847f-c112-5fba-bde9-c26c8b184c2c', '4f20636f-9d74-597e-88aa-ba64d1eff092', '1287afb6-4317-5e93-85e6-8cdeaceb5588', '26883b27-a30d-5b1f-a5b1-69d011025476', '4fd07784-1aec-5c67-af26-db0a97e32d70', 'd8b930d7-940d-5798-8e1c-22e8a129454d', 'c73e3151-44fd-5a5f-8eb6-abea93bb7b19', 'a5f96872-0b6d-5f4e-90f8-c1ce24cf80a4', '1e1658ed-d4fd-5bd6-a4be-34c4c9cd6c9b', '0188e508-afd1-5f5c-8d60-6fb1d5526a15', 'd30ff86f-f4e8-564a-9569-e874b3dd9d3f', '716f15c7-0e39-59c3-b09c-64fee449609e', '6e05554b-c169-5e4c-9bef-66ae4f659e23', 'f7345016-acaf-523a-a243-636d9afa7efc', '3e594c84-660e-532f-a2e9-4434596b3dae', '03606fbd-8905-5895-8e37-54dceae2a1a0', '5cb0060c-281f-5ac0-ac11-25d9667949f3', '52762ec6-cff4-5f84-bb96-2954e5f68f50', '92d1027c-4dc0-52db-994b-8b16a85a4dc2', '1422534b-a390-584c-9bd8-4ac476e717bc', '328a1aa6-3963-530b-ad6c-58c908f03267', '0d163354-6f34-59fc-9eee-a888c6bf4ab8', '397922e7-7465-531b-9dbd-3f98c4f64d2d', '86f494d7-09d0-517a-9e7b-b978a2bc27e2', '7568c154-6fe9-50d2-b3ca-08ba3ddc038b', 'e2136ea1-136a-5331-a416-a2c9446b6852', '74939bea-4e57-5c80-beae-39c7a10fb185', '24b91a4b-d79f-510a-ab69-34782d223621', 'eca7f174-72c2-5005-b2ef-ca1dbb76f0b7', 'e1b74aa2-bf6a-534a-8c3d-0c6ecb723ee5', '46e183c3-59aa-50d1-9476-427c5221e37d', 'adab297b-7f69-5194-adde-898c547a0cae', 'a422db06-1499-5672-a004-905c4a14a167', '07a05e25-3ef4-5576-aa3c-c60eee1c5472', 'a251507c-5c2b-5b07-b96f-40d6b7632500', '006fe8e5-ccbd-5d14-a9ce-937d3214778b', 'bc6e2e87-b52d-5369-8cf9-15715cd8be9a', '0120ab12-517f-5792-a2e3-f50bf59571cd', '317751a4-9214-5e9c-85c1-1f9203c3cee1', 'c1bb9ee6-b5a2-5e33-94cb-0a5a0328d111', '74d3bbc8-066b-560d-a3cf-203bf364b07b', '778dc34c-25bb-5ad8-a73f-e05647edd7c5', '375dd66c-e0a4-53ee-981c-be8b21d26b3a', '405fcb52-6f49-5b8a-9df8-36a167168887', 'ed5c92c6-f766-546f-aeb3-7be6de7aee57', '8529851c-5503-541d-baae-656cab549097', '56fe0e27-4f4d-5b8e-9085-0f808908572d', '17240c5e-c4e5-5b23-a575-e40215ddc70c', 'de202391-5ded-5a45-867c-a3881fc9c8d5', '5f2b0fa6-2ace-5926-9adf-420597029bc9', 'a928149a-e459-5966-b280-4095a9153cc3', '0515d80d-53fa-50e9-bbe4-063eb282216e', '7167097e-0b53-5a2c-81a2-96e9d9970ab8', 'b293d4c1-d6a3-5f56-8938-157be5647429', '51e62ab9-b1c9-5dd6-a89c-4141ad5ba4de', '3a20edc5-ec3c-5846-ae65-e7ba1b417d64', 'aa8391d1-7048-5ece-b7e4-6a77b912dbf1', 'df93e06b-9076-516a-b8f0-c6078c53d085', 'bab77483-ac97-5160-ae01-150ca2bdc7a1', '03cb9e82-e491-5b9a-b122-e623c61e4f36', '673b95bc-ab98-59df-90f0-65da78bab15c', 'a18ebc64-0459-56a7-9aa4-972515c6c80a', '7961debb-958c-5935-9998-ae78ffa809d3', '5e87c512-893f-511b-af1e-d68d0cd4f98d', '8eb330ab-e1fa-586f-b7f4-c767a5a16a21', '1ad16aee-fdb7-519e-b21b-f2d2d22a2e53', 'f526034c-df66-5faf-8f46-701ffc323c58', '6f961eb9-62bc-5749-a1f4-d26c33a337dd', '18dee952-a530-5053-9d24-2e93353b3227', 'ee2d1f86-4268-5a85-a14f-2fd41b336c5a', '46572621-ce44-5987-bdcf-a91f0e6b0763', '6b7a9be9-aaad-58ad-b367-9e3058e6d4f9', '0b875923-c964-5a12-bb4f-7e0b969fa67c', '8b573395-82ef-5a2e-8e89-c4f4c56c1e31', 'e3bf62ff-c251-5c5c-b301-c5200daa953f', '8cfe2584-950b-55ab-a75b-07c8b150216c', '452aa00c-8190-5c98-beaa-6cb707d7c5ab', 'db40cda6-7553-5f6a-9559-21201fa98cb0', 'db5bfd2f-5a61-5493-841b-174223ccc344', '30aa8cca-a812-55b1-9add-1dde3a1c96f2', '9779b1d6-b8e0-576d-b8a2-c0434fc68eba', '49dca535-d141-5fd0-adde-db4277347c23', '01e8d5e7-c19b-5799-a98e-8759c3dd59db', 'e7fb6bc2-8648-5a08-ae2d-448f3a341e93', '7f1c57c2-327b-525e-ac96-70ae65935512', '4a649635-85ea-53dc-838b-38f080288ee8', 'd2ee4325-2c32-51dd-9026-56f84409ce32', '8a5648b3-0661-50e9-889b-bf6d0233d8df', 'ed702adc-ba89-5636-b9cd-4e0bb1f3e57b', '7c6a31e5-ab8c-5b22-84ab-3bbfe4909bc4', '66671381-6f2a-539d-af08-6d5e79de0fe4', '292981d1-7b67-54df-91a9-a85a2b979f1e', '958671d9-a0df-5565-bdb4-990d7943da5c', '9ebde8a6-d156-5db6-87f7-c401572b103a', 'e06f8f1a-f4d5-5806-baa9-9176421bf9d6', 'c3578d3b-fdb7-56c5-b975-41a1275801d9', 'dbeb7c7e-788e-5ec8-9123-a0a8670d9ffc', 'ad8006d9-e465-5835-abd0-4d1b9bac8ff3', 'ceca6400-2b73-5e17-aebc-d1ded8870c41', 'af03ec1b-4415-583d-86db-8c371cfb5339', '4064bb7f-90e9-5341-9258-e5a61f33ad8d', '2d1d5f55-b380-5d0e-b422-ebe44a0f99c1', '9fd33fea-3f39-5f4e-9029-bb6517532bee', 'f3049023-31bd-5c63-b70c-de059f306f6f', '53dada63-1c55-5b94-8e04-6677802629ae', 'f8edebe4-b87a-5698-9523-3d41e5ff56c2', 'b6d1af50-a589-5b11-8869-b71912f4fcce', '1192ed95-6b52-5cce-9740-c9f0aaea8fde', '012eb559-584c-5108-a791-e0d1dd308a69', '1be3398c-546f-5c85-a84f-1bbe1bc707f5', '0a31f462-b7d3-5b00-ac8c-df27546a544b', '2ae7a482-ab59-5a32-8745-188e13271de6', '4cb85955-8562-5cc4-b812-6904ec90e3be', '2affecda-99a2-5e7f-a13a-7b9a36c131de', '455e6ad7-cb22-51f3-8820-0680b738b64a', 'e803711a-4b82-50e3-94d8-c412f15e9775', 'dcfbc33a-7a39-5c4a-9dd5-4ed38f8c86cf', 'c2b0f0a5-a3f5-584f-826a-32c54c9d8bb0', '47bd48ed-89e5-5ec7-910d-db776414f4db', 'bb9097ac-a379-5e33-a000-f949d3134437', '634ff1f3-5c9d-5900-917c-16aed88980f3', '395a5ad4-8a93-5fea-b74a-f141cbe99212', '13d986ab-6784-51d6-9aab-e9ad4f82b75a', 'f523d362-13a1-55f6-9c76-8d601896a171', '50703343-595b-5617-a03b-4b9cbccbe8f9', '2926e03d-fb60-5eee-8aae-2ed6d6db48d2', 'ad01a4dc-cdfa-51b3-8d5b-9f79dab05031', 'd60540bc-2972-538d-95ee-eea4ca54ded5', 'feabb142-13bc-54c5-8fa2-c0a45ad1ccc6', 'fc98c914-6202-5671-9d51-de8a6a5455a2', '47b96e4c-4c47-590c-b321-0390fdaf9e1d', '452f2368-9a05-5b7b-96cb-1975617a8594', '1a44aa46-9ebb-5682-84b4-736594207d36');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-c1' AND source = 'admin' AND id NOT IN ('c59c4434-dee3-59ac-8b21-d37b637b9f83', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'def9bed6-4853-5722-8393-bb311ead412e', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', '840343dc-430a-5e84-a0bc-d11801903d90', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'ab418311-2294-5802-878c-c8084d4f34ca', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', '952990fe-89a3-54fa-85fe-f7af9bd272b7', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'd50cc612-26b0-5570-9186-b29d7e363021', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', '0a548630-582d-58dc-9674-7ae90a923fdc', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', '2b938254-083a-5601-b46c-67870fdd3c78', '606f19ce-4de9-53c7-8948-c3c94a152790', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', '4f35e08b-f07c-5473-b82d-83b168db09cb', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'bf5925da-167d-5945-982d-6873f2048151', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'e5743058-e69b-561e-ba4d-fcf65902ca80', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', '5ba79a1e-0e62-5660-a8b0-19da0c897234', '7fe0131c-e489-5ede-a1e0-21e27e536de2', '89186261-2abe-51fb-bfd3-7f059cdec3a2', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', '67639796-8e84-5376-a327-238826f1ad55', '9f1ac286-d018-5994-b399-f2054b019201', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'ede1b633-9352-5655-bad0-e48fd8490122');
DELETE FROM public.questions WHERE exercise_id IN ('c59c4434-dee3-59ac-8b21-d37b637b9f83', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'def9bed6-4853-5722-8393-bb311ead412e', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', '840343dc-430a-5e84-a0bc-d11801903d90', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'ab418311-2294-5802-878c-c8084d4f34ca', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', '952990fe-89a3-54fa-85fe-f7af9bd272b7', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'd50cc612-26b0-5570-9186-b29d7e363021', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', '0a548630-582d-58dc-9674-7ae90a923fdc', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', '2b938254-083a-5601-b46c-67870fdd3c78', '606f19ce-4de9-53c7-8948-c3c94a152790', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', '4f35e08b-f07c-5473-b82d-83b168db09cb', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'bf5925da-167d-5945-982d-6873f2048151', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'e5743058-e69b-561e-ba4d-fcf65902ca80', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', '5ba79a1e-0e62-5660-a8b0-19da0c897234', '7fe0131c-e489-5ede-a1e0-21e27e536de2', '89186261-2abe-51fb-bfd3-7f059cdec3a2', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', '67639796-8e84-5376-a327-238826f1ad55', '9f1ac286-d018-5994-b399-f2054b019201', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'ede1b633-9352-5655-bad0-e48fd8490122') AND id NOT IN ('c3ed080f-c7d5-58e9-b611-73f0eeacf2d1', '0f043a39-a062-552e-a7f5-6d781231510a', '8e1cebda-3d9d-55be-8547-ac94bbc54c15', '944c9b98-ee1c-50c3-b24e-f291509a3a3b', '2e07776c-2820-5f29-9f33-4e4da093d59c', '11237457-58d9-5d3b-b12c-a9f4fba1bb5c', '6342529d-ab03-52e3-bb50-e7423ce18380', 'bb2f62b4-2671-502b-8654-7c671340aa0a', 'bee7ed77-cb9b-5158-be60-9c8e508818fa', '1a45f61b-9084-5ab6-9d36-b96f0a7e0c72', 'cf44a16a-f85e-5126-89ca-6b6c756227bf', 'af8e2222-4b77-560c-8765-8e6bbf6b66d7', 'e0830eb7-0e91-5da3-aaad-9da8cc493474', '44c506f0-31a1-57db-9e95-ed8ae4978cb3', 'b3a00945-2861-55b9-8874-8320c0b1e967', 'b51c9e03-780d-5704-9c18-e651c93fab70', 'a47bfc43-e374-5904-9d44-e309f9d1766b', '978042ff-ebe3-5e9e-95f8-e5bbc38c02e4', 'f25c20a8-f807-5f7d-b356-1b550bf9b9d2', '34cbbe22-520f-5289-9523-02c6a99d97a7', '8d140818-dc74-5f79-9524-d5cc1d734d4c', '5be3f9a9-191d-5ca3-a8da-714656742dc3', 'f86855cc-1a2b-59ea-b9a7-be701b5c1dac', '5873ec30-220c-5e15-8792-500430e9fd65', 'cb8d709f-7929-578c-a800-c2558fcf5817', '0487d769-b1a9-56b4-89ba-8976572d5e1e', '01ad1c48-6e32-563a-ab2c-837b701f4177', 'ea5b90d1-33ad-5da8-a51b-73d567ebe20c', '79dd978d-8f11-5932-9312-063f18a6b0dd', 'b5df4d9a-7862-5f25-9ff3-f72700b95560', 'a9daec88-f6b4-54e4-8507-86b21064e25f', '17f81caa-c1f6-52bd-adce-4e12341f90cb', '594d7d45-58ba-599c-b446-f889e4326709', '639a7ba3-fd80-56f4-b129-4ab9187e1a36', '810c4952-f53f-5622-a213-4f3571b7d23b', '5d43edbc-5b05-5c13-9235-ee8b24fc848d', '839117d8-6365-5c93-816a-fb2268ea35eb', 'd128e874-e35c-5082-a553-1ab9c957e300', 'ba7c6047-b853-5a79-9a8b-be8152dc8752', '9286245b-ab8b-5a41-a25a-5038f02ea50e', '7d5f2a84-1485-5999-a04c-55cca0be6f82', '53d28307-a609-5fa8-94d0-f7fc99e4c7e2', '48e54a10-1db0-5a46-bbc1-9bfe0cad616f', '7a8ac4e1-c4a1-5904-948c-44089195d1d4', '879a36c7-6eb5-56df-bdc8-61da97b08120', 'a4caef19-4bb5-5258-abb6-f5c5dec91dd2', 'f412d47b-31f2-5097-a336-583102dd19f9', '1fc856bc-92bb-5695-bcf7-64d95d33199b', 'c6f79d64-1c06-5ed6-bf49-6adce4da4f8a', '98d90e1b-0e63-50c2-9889-a11b9c23af46', '5353871c-d393-5f03-9123-becde94f6dba', '116aa368-5294-587b-8c9a-fe07e0f02611', 'bc9aed38-02db-5074-bac1-3bbdde09ac00', 'c900576f-9a1f-5e51-bf62-792410236833', 'b61301dc-969d-568c-a61c-4f68a0aa6571', 'c34c8b4a-ccc0-567b-b7c1-e3a124adbabb', 'a3897316-fcee-57a7-943b-29c32ef8cd42', '8dc3e64d-59a5-52df-904e-6d70d45953ea', 'd4763290-850e-52ef-a473-cbb36502b007', '7b508c52-4129-58df-aad8-39afac3bb5db', 'bfd4795b-f2ac-5743-b47f-e65b0f1700f6', '56f89e54-104a-5825-b0f5-d21f8135e7a9', 'e23985af-fef5-5e33-a666-ed0b54098bbb', '45f17cda-50d8-56e0-a7b9-a70e732a495c', '67490c81-7522-5678-9494-8eafe22dd6f6', '100ab80c-c333-5523-9b3c-27b5d9130875', 'ba58ccdd-602f-5861-adca-1b619c969c66', 'f4fd74d9-2728-5e59-b387-68118bbf2662', 'd47fc8cf-9712-5715-b55b-fec749d77771', '682674c6-cb1e-547e-af43-9b870a74149b', 'd620c25b-5c84-55eb-9a05-8cb695c819b7', 'd1d1afbb-5d9c-5012-9bdc-3c05bb2a26a8', 'cc7f129e-8ba9-50c2-8b99-7925569a0b5d', 'b364268f-1c67-5c31-acc4-f8550f10296a', '6e7f4297-74e1-5f0d-a0c8-52fcd77bf2c5', 'ec9cc806-5fb1-5cc6-bb34-e144d29f39a7', 'd12526e5-a8b9-56dc-b9fc-ab06bf83a03d', '476b8774-769c-5958-8ad3-b9cd19e293c3', 'e71c8ec1-aeb4-562c-bb8f-5a8af7347b2e', '309fd65f-0567-59ee-9d60-66d6ec4678f6', '9499efe4-22a3-5c65-a7fd-6b02cff47798', 'ca5e542a-6c71-54d4-a6b0-1390ca347d6b', '79533cbf-0735-52af-94d1-b70177385323', '7e7236cd-271b-5e58-99a1-b5a9b2955ab2', '6a547c4a-472d-5148-a982-54e188a3b176', '70920fd7-84bf-511d-bb5b-24047626c7e4', '90384d86-a4ab-5f77-9eb6-afd750ab9727', 'bb8e18e9-bd45-5eb3-979e-1e5d8a2a78e2', '2f52d071-7de1-5a82-a051-69447282af8f', '26f40e90-d553-5c82-a07c-9603948a645b', 'b05c8b07-5066-5bb0-badd-c9ac409a7f40', '1ce79a31-a780-551d-97ed-af1717e80a5c', 'db390fc3-7997-5b3e-a2c0-2b4f8224cb9a', '8d8adb85-e119-5941-a685-bbf49f3c74f2', 'b6e16e97-7c6e-58ea-abba-d52133051e9a', 'da21e47b-5a01-5c61-b38a-af0fa382ee61', 'e305f447-aa9a-5825-bd3d-6b4d5848e008', 'a60c503a-a358-508c-8771-f9a55a7f5c40', '3c34b47d-b68d-51ce-a962-fd050792c67e', 'db05c774-979f-5c5f-ae8d-960bbfc8bb97', '44a64b52-eeae-566e-bb68-6ba0248a517b', 'cee14fd1-3a82-573d-ac3f-03327423e97e', '3287a867-fead-528d-9a38-83e77e1cce0f', 'e2eb12b9-d39d-52b2-baef-3284140f5200', 'ee603ff4-ef15-5b2c-8415-27ed1ea22de5', '099d558e-369d-5fd4-a1c4-7a86bd613358', '123fccc2-c7b2-5396-8cd8-1313e23afd85', 'e65f4167-259f-54fd-be56-4bd7da8896db', 'ab5cedf3-c6c7-59dd-b355-2aa3b6d37539', 'ec62f594-05c5-54f6-ae27-222e761b6d78', '9fcf9baf-cd80-5979-9cc0-6209b40f36f9', 'ec788a73-1656-5def-b99a-61d8cd9499c4', 'da201679-cc2e-5ce8-8830-9364b5aa3b9c', 'c8697c61-90a7-5a5c-a43c-4acb0e5f7c70', 'c818e096-3a6d-5c89-856d-02d4f4bd029a', '12484694-3422-502d-b2c9-f561f556ee20', 'c117ac7c-4d43-58ac-a8b3-bee14f213f34', 'a10c48e5-422b-59f5-ba0b-f7bc637e60e2', '66caad7b-3d79-5c5d-a5d4-6bd4570e023c', '3e0c0e67-5a49-5f8e-810b-ea57549d843f', 'ca3fb4b7-5e4c-50ef-816c-16cd8b855152', '818cd98a-dbf8-55c3-9b6f-ef881973f67d', 'f8a9a48a-83cc-5a8c-9378-25a8fe2a9b0d', 'd89fb7db-96cf-52a8-a915-ac3d3d886be8', 'effb5d15-c08f-5d16-98ca-0f6c1df86928', 'dfba706a-0a80-516d-a3da-c6216e02e408', '8f467402-95fb-51cb-b3d2-1e1155ef5f09', '6bfff066-0ab0-506d-a98b-fe2248308835', 'c5b4ece6-f0ae-5c5e-947b-9a77aab80728', '3f1c2bcb-7405-571a-9e8e-40f0ec5be18e', '388807e1-36fe-556b-a3bc-61c51643f1bd', '863ed009-e33f-5ef2-97c8-d29fc1417699', '7a26e55c-6b0c-5934-987a-b070bf64fee8', '508b9dee-a95b-5bc0-806a-d17be329475e', '77c68ce2-f76f-5759-9f48-1b98b075ce98', '08869e69-06a0-5cf5-b049-bea35472a89f', '7f0bb918-602a-52c3-995b-e4b132f7f31d', '19a112cf-cdd8-530d-ba75-a2edc1e72bb2', 'cc619469-5f9b-5a07-b931-e722e57f73e1', '701e0655-a0de-54ea-b5c8-65efb9576a9f', 'd5159c64-12d7-5077-9a58-35fb94800ddb', 'b4409000-5d58-5bd1-b6ba-96243901e492', '11ebe136-80de-5469-a62f-200d6a83fd97', 'e5c1e927-b346-5836-9cc4-5c98557f28fe', '5c066da4-46ce-5686-9819-ae29d2f8df4a', 'd8338ce8-ea96-5341-9de8-3f97c2fd1688', '939e5c5e-6ebb-5620-92fd-964b6769de34', '82c7847f-c112-5fba-bde9-c26c8b184c2c', '4f20636f-9d74-597e-88aa-ba64d1eff092', '1287afb6-4317-5e93-85e6-8cdeaceb5588', '26883b27-a30d-5b1f-a5b1-69d011025476', '4fd07784-1aec-5c67-af26-db0a97e32d70', 'd8b930d7-940d-5798-8e1c-22e8a129454d', 'c73e3151-44fd-5a5f-8eb6-abea93bb7b19', 'a5f96872-0b6d-5f4e-90f8-c1ce24cf80a4', '1e1658ed-d4fd-5bd6-a4be-34c4c9cd6c9b', '0188e508-afd1-5f5c-8d60-6fb1d5526a15', 'd30ff86f-f4e8-564a-9569-e874b3dd9d3f', '716f15c7-0e39-59c3-b09c-64fee449609e', '6e05554b-c169-5e4c-9bef-66ae4f659e23', 'f7345016-acaf-523a-a243-636d9afa7efc', '3e594c84-660e-532f-a2e9-4434596b3dae', '03606fbd-8905-5895-8e37-54dceae2a1a0', '5cb0060c-281f-5ac0-ac11-25d9667949f3', '52762ec6-cff4-5f84-bb96-2954e5f68f50', '92d1027c-4dc0-52db-994b-8b16a85a4dc2', '1422534b-a390-584c-9bd8-4ac476e717bc', '328a1aa6-3963-530b-ad6c-58c908f03267', '0d163354-6f34-59fc-9eee-a888c6bf4ab8', '397922e7-7465-531b-9dbd-3f98c4f64d2d', '86f494d7-09d0-517a-9e7b-b978a2bc27e2', '7568c154-6fe9-50d2-b3ca-08ba3ddc038b', 'e2136ea1-136a-5331-a416-a2c9446b6852', '74939bea-4e57-5c80-beae-39c7a10fb185', '24b91a4b-d79f-510a-ab69-34782d223621', 'eca7f174-72c2-5005-b2ef-ca1dbb76f0b7', 'e1b74aa2-bf6a-534a-8c3d-0c6ecb723ee5', '46e183c3-59aa-50d1-9476-427c5221e37d', 'adab297b-7f69-5194-adde-898c547a0cae', 'a422db06-1499-5672-a004-905c4a14a167', '07a05e25-3ef4-5576-aa3c-c60eee1c5472', 'a251507c-5c2b-5b07-b96f-40d6b7632500', '006fe8e5-ccbd-5d14-a9ce-937d3214778b', 'bc6e2e87-b52d-5369-8cf9-15715cd8be9a', '0120ab12-517f-5792-a2e3-f50bf59571cd', '317751a4-9214-5e9c-85c1-1f9203c3cee1', 'c1bb9ee6-b5a2-5e33-94cb-0a5a0328d111', '74d3bbc8-066b-560d-a3cf-203bf364b07b', '778dc34c-25bb-5ad8-a73f-e05647edd7c5', '375dd66c-e0a4-53ee-981c-be8b21d26b3a', '405fcb52-6f49-5b8a-9df8-36a167168887', 'ed5c92c6-f766-546f-aeb3-7be6de7aee57', '8529851c-5503-541d-baae-656cab549097', '56fe0e27-4f4d-5b8e-9085-0f808908572d', '17240c5e-c4e5-5b23-a575-e40215ddc70c', 'de202391-5ded-5a45-867c-a3881fc9c8d5', '5f2b0fa6-2ace-5926-9adf-420597029bc9', 'a928149a-e459-5966-b280-4095a9153cc3', '0515d80d-53fa-50e9-bbe4-063eb282216e', '7167097e-0b53-5a2c-81a2-96e9d9970ab8', 'b293d4c1-d6a3-5f56-8938-157be5647429', '51e62ab9-b1c9-5dd6-a89c-4141ad5ba4de', '3a20edc5-ec3c-5846-ae65-e7ba1b417d64', 'aa8391d1-7048-5ece-b7e4-6a77b912dbf1', 'df93e06b-9076-516a-b8f0-c6078c53d085', 'bab77483-ac97-5160-ae01-150ca2bdc7a1', '03cb9e82-e491-5b9a-b122-e623c61e4f36', '673b95bc-ab98-59df-90f0-65da78bab15c', 'a18ebc64-0459-56a7-9aa4-972515c6c80a', '7961debb-958c-5935-9998-ae78ffa809d3', '5e87c512-893f-511b-af1e-d68d0cd4f98d', '8eb330ab-e1fa-586f-b7f4-c767a5a16a21', '1ad16aee-fdb7-519e-b21b-f2d2d22a2e53', 'f526034c-df66-5faf-8f46-701ffc323c58', '6f961eb9-62bc-5749-a1f4-d26c33a337dd', '18dee952-a530-5053-9d24-2e93353b3227', 'ee2d1f86-4268-5a85-a14f-2fd41b336c5a', '46572621-ce44-5987-bdcf-a91f0e6b0763', '6b7a9be9-aaad-58ad-b367-9e3058e6d4f9', '0b875923-c964-5a12-bb4f-7e0b969fa67c', '8b573395-82ef-5a2e-8e89-c4f4c56c1e31', 'e3bf62ff-c251-5c5c-b301-c5200daa953f', '8cfe2584-950b-55ab-a75b-07c8b150216c', '452aa00c-8190-5c98-beaa-6cb707d7c5ab', 'db40cda6-7553-5f6a-9559-21201fa98cb0', 'db5bfd2f-5a61-5493-841b-174223ccc344', '30aa8cca-a812-55b1-9add-1dde3a1c96f2', '9779b1d6-b8e0-576d-b8a2-c0434fc68eba', '49dca535-d141-5fd0-adde-db4277347c23', '01e8d5e7-c19b-5799-a98e-8759c3dd59db', 'e7fb6bc2-8648-5a08-ae2d-448f3a341e93', '7f1c57c2-327b-525e-ac96-70ae65935512', '4a649635-85ea-53dc-838b-38f080288ee8', 'd2ee4325-2c32-51dd-9026-56f84409ce32', '8a5648b3-0661-50e9-889b-bf6d0233d8df', 'ed702adc-ba89-5636-b9cd-4e0bb1f3e57b', '7c6a31e5-ab8c-5b22-84ab-3bbfe4909bc4', '66671381-6f2a-539d-af08-6d5e79de0fe4', '292981d1-7b67-54df-91a9-a85a2b979f1e', '958671d9-a0df-5565-bdb4-990d7943da5c', '9ebde8a6-d156-5db6-87f7-c401572b103a', 'e06f8f1a-f4d5-5806-baa9-9176421bf9d6', 'c3578d3b-fdb7-56c5-b975-41a1275801d9', 'dbeb7c7e-788e-5ec8-9123-a0a8670d9ffc', 'ad8006d9-e465-5835-abd0-4d1b9bac8ff3', 'ceca6400-2b73-5e17-aebc-d1ded8870c41', 'af03ec1b-4415-583d-86db-8c371cfb5339', '4064bb7f-90e9-5341-9258-e5a61f33ad8d', '2d1d5f55-b380-5d0e-b422-ebe44a0f99c1', '9fd33fea-3f39-5f4e-9029-bb6517532bee', 'f3049023-31bd-5c63-b70c-de059f306f6f', '53dada63-1c55-5b94-8e04-6677802629ae', 'f8edebe4-b87a-5698-9523-3d41e5ff56c2', 'b6d1af50-a589-5b11-8869-b71912f4fcce', '1192ed95-6b52-5cce-9740-c9f0aaea8fde', '012eb559-584c-5108-a791-e0d1dd308a69', '1be3398c-546f-5c85-a84f-1bbe1bc707f5', '0a31f462-b7d3-5b00-ac8c-df27546a544b', '2ae7a482-ab59-5a32-8745-188e13271de6', '4cb85955-8562-5cc4-b812-6904ec90e3be', '2affecda-99a2-5e7f-a13a-7b9a36c131de', '455e6ad7-cb22-51f3-8820-0680b738b64a', 'e803711a-4b82-50e3-94d8-c412f15e9775', 'dcfbc33a-7a39-5c4a-9dd5-4ed38f8c86cf', 'c2b0f0a5-a3f5-584f-826a-32c54c9d8bb0', '47bd48ed-89e5-5ec7-910d-db776414f4db', 'bb9097ac-a379-5e33-a000-f949d3134437', '634ff1f3-5c9d-5900-917c-16aed88980f3', '395a5ad4-8a93-5fea-b74a-f141cbe99212', '13d986ab-6784-51d6-9aab-e9ad4f82b75a', 'f523d362-13a1-55f6-9c76-8d601896a171', '50703343-595b-5617-a03b-4b9cbccbe8f9', '2926e03d-fb60-5eee-8aae-2ed6d6db48d2', 'ad01a4dc-cdfa-51b3-8d5b-9f79dab05031', 'd60540bc-2972-538d-95ee-eea4ca54ded5', 'feabb142-13bc-54c5-8fa2-c0a45ad1ccc6', 'fc98c914-6202-5671-9d51-de8a6a5455a2', '47b96e4c-4c47-590c-b321-0390fdaf9e1d', '452f2368-9a05-5b7b-96cb-1975617a8594', '1a44aa46-9ebb-5682-84b4-736594207d36');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-c1' AND c.id NOT IN ('e13db806-78e2-5db0-80e3-3829bfb948ca', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'd92e635b-7c7d-53b9-8745-78aef0049de1', '094d8b92-d09a-59ba-b636-14e32a6585b2', '65646086-8d8d-55e2-9a39-364c325754a3', '50f269b2-88c1-51eb-801b-1bf230e573a0', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', '525fd972-a102-5a5f-ae97-72d48eb79e61') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', 'L''accord du participe passé (cas difficiles)', 'Maîtrise les accords qui font trébucher même les francophones experts : verbes pronominaux (réfléchi COD vs COI, sens passif, accord avec « les mains »), participe suivi d''un infinitif, COD = « en », verbes impersonnels, et « fait/laissé + infinitif » invariables. Le raffinement orthographique qui distingue un écrit de niveau C1.', '# ⚔️ L''accord du participe passé — La forge des cas difficiles

> 💡 «Tout le monde sait accorder _les fleurs que j''ai achetées_. Le maître, lui, sait pourquoi on écrit _elle s''est lavé les mains_ et _ils se sont parlé_. C''est dans ces cas tordus que se joue le niveau C1.»

---

## 🏰 1. Le rappel express (tu connais déjà ça)

Deux règles fondatrices, vues dès le B1 — on ne les réexplique pas, on les pose comme socle :

- **Auxiliaire ÊTRE** → le participe s''accorde avec le **sujet**.
  _Elles **sont parties**. · La tour **a été construite**._
- **Auxiliaire AVOIR** → le participe s''accorde avec le **COD seulement s''il est placé AVANT** le verbe ; sinon, **invariable**.
  _J''ai acheté **des fleurs**._ (COD après → invariable) · _Les fleurs que j''ai **achetées**._ (COD _que_ avant → accord) · _Je les ai **vues**._ (_les_ = COD avant → accord)

> 🗡️ Réflexe de base : avec _avoir_, pose toujours la question « **quoi ?** » avant le verbe. Si la réponse précède le participe → accord. Tout le chapitre n''est qu''une extension fine de ce réflexe.

---

## ⚡ 2. Les verbes pronominaux — le cœur du chapitre

Ils se conjuguent avec **être**, mais on **n''accorde PAS** automatiquement avec le sujet. Il faut d''abord les classer.

| Type de pronominal                                                  | Règle d''accord                          | Exemple                               |
| ------------------------------------------------------------------- | --------------------------------------- | ------------------------------------- |
| **Essentiellement pronominal** (n''existe qu''à la forme pronominale) | accord avec le **sujet**                | _Elle s''est **évanouie**._            |
| **Sens passif**                                                     | accord avec le **sujet**                | _Ces livres se sont bien **vendus**._ |
| **Réfléchi / réciproque, pronom = COD**                             | accord avec le pronom (= avec le sujet) | _Elle s''est **lavée**._               |
| **Réfléchi / réciproque, pronom = COI**                             | **invariable**                          | _Ils se sont **parlé**._              |
| **Réfléchi avec un COD placé APRÈS**                                | **invariable**                          | _Elle s''est **lavé** les mains._      |

La clé est toujours la même : **quelle est la fonction du pronom réfléchi (se / s'')** ?

> _Elle s''est **lavée**._ → _se_ = COD (elle lave qui ? elle-même) → **accord**.
> _Elle s''est **lavé** les mains._ → le COD est _les mains_ (placé **après**), _se_ n''est qu''un COI (à elle-même) → **pas d''accord**.

> ⚠️ Piège n°1 : _Ils se sont **parlé**_, _elles se sont **succédé**_, _elles se sont **plu**_ — invariables ! On dit _parler **à** quelqu''un_, _succéder **à** quelqu''un_, _plaire **à** quelqu''un_ : le pronom est **COI**, jamais COD.

---

## 🛡️ 3. Le test infaillible pour les pronominaux

Pour trancher, transforme mentalement avec l''auxiliaire **avoir** et cherche le **COD** :

| Phrase                         | Réécriture-test               | COD ?                     | Accord              |
| ------------------------------ | ----------------------------- | ------------------------- | ------------------- |
| _Elle s''est lavée._            | elle a lavé **elle-même**     | _se_ avant → COD          | **lavée** ✓         |
| _Elle s''est lavé les mains._   | elle a lavé **les mains**     | COD après                 | **lavé** (invar.)   |
| _Ils se sont parlé._           | ils ont parlé **à eux**       | pas de COD (COI)          | **parlé** (invar.)  |
| _Elle s''est permis de partir._ | elle a permis **cela à elle** | COD = _de partir_ (après) | **permis** (invar.) |

> 🗡️ Astuce : _se permettre, se nuire, se ressembler, se sourire, se téléphoner, se succéder, se mentir_ → tous à **COI** → toujours invariables.

---

## 🔮 4. Participe passé + infinitif

On accorde **si** le COD placé avant **fait l''action** exprimée par l''infinitif ; sinon, **invariable**.

| Phrase                                            | Le COD fait-il l''action de l''infinitif ?      | Accord               |
| ------------------------------------------------- | --------------------------------------------- | -------------------- |
| _Les cantatrices que j''ai **entendues** chanter._ | oui (les cantatrices chantent)                | **entendues** ✓      |
| _Les airs que j''ai **entendu** chanter._          | non (les airs ne chantent pas, on les chante) | **entendu** (invar.) |

> _Les enfants que j''ai **vus** jouer._ (les enfants jouent → accord) · _La pièce que j''ai **vu** jouer._ (la pièce ne joue pas, elle est jouée → invariable).

> ⚠️ Piège n°2 : ne te fie pas au son. _Entendue_ et _entendu_ se prononcent pareil — seule la **logique du COD** décide.

---

## 🧪 5. Le COD est « EN » → jamais d''accord

Lorsque le COD antéposé est le pronom **en**, le participe reste **invariable**.

> _Des erreurs, j''**en** ai **fait** beaucoup._ (jamais _~~faites~~_) · _Des fleurs, j''**en** ai **cueilli**._ · _De ces livres, combien en as-tu **lu** ?_

La raison : _en_ a une valeur partitive (« une partie de »), trop indéterminée pour commander l''accord.

> 🗡️ Mémo : dès que tu vois **en** comme COD, range le participe au masculin singulier et passe à la suite.

---

## 🧮 6. Verbes impersonnels & « fait / laissé + infinitif »

Deux familles toujours **invariables** :

| Cas                                                 | Règle               | Exemple                                                                     |
| --------------------------------------------------- | ------------------- | --------------------------------------------------------------------------- |
| **Verbe impersonnel** (_il faut, il y a, il pleut_) | invariable          | _Les efforts qu''il a **fallu**._ · _La chaleur qu''il a **fait**._           |
| **fait + infinitif**                                | _fait_ invariable   | _Elle s''est **fait** construire une maison._ · _Je les ai **fait** entrer._ |
| **laissé + infinitif** (rectif. 1990)               | _laissé_ invariable | _Elle s''est **laissé** mourir._ · _Les enfants que j''ai **laissé** partir._ |

> ⚠️ Piège n°3 : _Elle s''est **fait** belle_ ? Non — là _fait_ n''est pas suivi d''un infinitif, donc on accorde : _elle s''est **faite** belle_. Mais _elle s''est **fait** construire une maison_ (fait + infinitif _construire_) → **invariable**. Repère toujours l''infinitif qui suit.

> 🗡️ Astuce : _fait + infinitif_ forme un bloc verbal indissociable ; le participe _fait_ y perd toute possibilité d''accord, quel que soit le COD.

---

## 📜 7. La carte mentale du C1

Devant n''importe quel participe douteux, déroule cet arbre de décision :

1. **Quel auxiliaire ?** _être_ → accord sujet (sauf pronominaux, voir 2) ; _avoir_ → cherche le COD avant.
2. **Pronominal ?** classe-le (essentiel/passif → sujet ; réfléchi → fonction du pronom).
3. **Suivi d''un infinitif ?** le COD fait-il l''action ? oui → accord ; non → invariable.
4. **COD = en, verbe impersonnel, fait/laissé + infinitif ?** → **invariable**, point final.

> 🏆 Porte franchie ! Tu domines désormais les accords qui piègent les meilleurs. Tu écris _elle s''est lavé les mains_ et _les cantatrices que j''ai entendues chanter_ sans hésiter. Prochaine étape du parcours C1 : **la concordance des temps**.', '# 📜 Résumé : L''accord du participe passé (cas difficiles)

- **Rappel** : avec _être_ → accord avec le sujet ; avec _avoir_ → accord avec le COD seulement s''il est placé avant (_les fleurs que j''ai achetées_, _je les ai vues_).
- **Pronominaux — sujet** : essentiellement pronominaux et sens passif s''accordent avec le sujet (_elle s''est évanouie_).
- **Pronominaux — pronom COD** : accord si le pronom réfléchi est COD (_elle s''est lavée_) ; pas d''accord s''il est COI (_ils se sont parlé_) ou si un COD suit (_elle s''est lavé les mains_).
- **Cas invariables fréquents** : _elle s''est permis de partir_, _elles se sont succédé_ (COI).
- **Participe + infinitif** : accord si le COD fait l''action de l''infinitif (_les cantatrices que j''ai entendues chanter_) ; sinon invariable (_les airs que j''ai entendu chanter_).
- **COD = en** : toujours invariable (_des erreurs, j''en ai fait_).
- **Verbes impersonnels** : invariables (_les efforts qu''il a fallu_).
- **fait / laissé + infinitif** : _fait_ et _laissé_ invariables (_elle s''est fait construire une maison_, _elle s''est laissé mourir_).
- **Méthode** : repère l''auxiliaire, classe le pronominal, teste la fonction du COD, puis vérifie les cas spéciaux (en, impersonnel, fait + infinitif).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', 'La concordance des temps', 'Maîtrise l''accord des temps entre la principale et la subordonnée : à l''indicatif (simultanéité, antériorité, postériorité) selon que la principale est au présent ou au passé, le conditionnel comme futur du passé, le subjonctif présent et passé en français courant, et la reconnaissance du subjonctif imparfait littéraire.', '# ⚔️ La concordance des temps — l''horloge cachée de la phrase

> 💡 «Une subordonnée n''est jamais libre : son temps obéit à celui de la principale. Apprends cette mécanique et tes phrases sonneront juste, du présent le plus simple au littéraire le plus rare.»

## 🏰 Le principe : la principale commande

La **concordance des temps** règle l''accord entre le temps du verbe de la **principale** et celui du verbe de la **subordonnée**. Deux questions décident de tout : à quel temps est la principale (**présent** ou **passé** ?) et quel est le **rapport temporel** entre les deux actions ?

Ce rapport peut être de trois sortes :

- **simultanéité** : les deux actions se déroulent au même moment ;
- **antériorité** : l''action de la subordonnée précède celle de la principale ;
- **postériorité** : l''action de la subordonnée suit celle de la principale.

> 🗡️ Réflexe : regarde d''abord le verbe principal, puis demande « avant, en même temps ou après ? ». Le temps de la subordonnée découle de ces deux réponses.

## ⚡ Subordonnée à l''indicatif, principale au présent

Quand la principale est au **présent** (ou au futur), la subordonnée garde sa valeur naturelle :

| Rapport      | Temps de la subordonnée | Exemple                        |
| ------------ | ----------------------- | ------------------------------ |
| simultanéité | présent                 | _Je crois qu''il **vient**._    |
| antériorité  | passé composé           | _Je crois qu''il **est venu**._ |
| postériorité | futur simple            | _Je crois qu''il **viendra**._  |

Le présent de la principale laisse la subordonnée « parler en temps réel » : on emploie le temps que l''on emploierait dans une phrase indépendante.

## 🛡️ Subordonnée à l''indicatif, principale au passé

Quand la principale passe au **passé** (imparfait, passé composé, passé simple), tout **recule d''un cran** :

| Rapport      | Temps de la subordonnée | Exemple                            |
| ------------ | ----------------------- | ---------------------------------- |
| simultanéité | imparfait               | _Je croyais qu''il **venait**._     |
| antériorité  | plus-que-parfait        | _Je croyais qu''il **était venu**._ |
| postériorité | conditionnel présent    | _Je croyais qu''il **viendrait**._  |

Compare les deux tableaux : _vient → venait_, _est venu → était venu_, _viendra → viendrait_. La principale au passé fait basculer la subordonnée vers les temps « du fond du passé ».

> ⚠️ Piège : après une principale au passé, **on ne dit pas** _Je croyais qu''il **vient**_ ni _qu''il **viendra**_ — le présent et le futur sont réservés à une principale au présent. Le passé appelle imparfait / plus-que-parfait / conditionnel.

## 🔮 Le conditionnel : le « futur du passé »

La postériorité après un verbe au passé n''utilise jamais le futur, mais le **conditionnel présent** : c''est le **futur du passé**.

_Il annonce qu''il **viendra**._ → _Il a annoncé qu''il **viendrait**._

Quand l''action future est elle-même **achevée** par rapport à un autre repère, on emploie le **conditionnel passé** (le futur antérieur du passé) :

_Il a promis qu''il **aurait fini** avant midi._ (= il finirait, et ce serait achevé, avant midi).

> 🗡️ Astuce : ce conditionnel n''exprime ici **aucune hypothèse** — il marque seulement un futur vu depuis le passé. Ne le confonds pas avec le conditionnel de l''irréel (_S''il venait, je serais content_).

## 🧪 Subordonnée au subjonctif (français courant)

Après les verbes de volonté, de sentiment ou de doute, la subordonnée passe au **subjonctif**. En français **courant**, on n''utilise que deux temps, quel que soit le temps de la principale :

| Rapport                     | Temps employé      | Exemple                             |
| --------------------------- | ------------------ | ----------------------------------- |
| simultanéité / postériorité | subjonctif présent | _Je voulais qu''il **vienne**._      |
| antériorité                 | subjonctif passé   | _J''étais ravi qu''il **soit venu**._ |

Point capital : **même après une principale au passé**, on garde le subjonctif présent (_Je voulais qu''il vienne_) — il n''y a **pas** de recul vers l''imparfait dans l''usage courant.

> ⚠️ Piège : ne calque pas la concordance de l''indicatif sur le subjonctif. _Je voulais qu''il **venait**_ est faux (l''imparfait de l''indicatif n''a rien à faire ici) ; on dit _qu''il **vienne**_.

## 📜 Registre soutenu : le subjonctif imparfait (à reconnaître)

Dans la langue **littéraire ou très soutenue**, la concordance « complète » fait reculer le subjonctif après une principale au passé :

| Courant (à produire)               | Soutenu / littéraire (à reconnaître) |
| ---------------------------------- | ------------------------------------ |
| _Je voulais qu''il **vienne**_      | _Je voulais qu''il **vînt**_          |
| _J''étais ravi qu''il **soit venu**_ | _J''étais ravi qu''il **fût venu**_    |

Le **subjonctif imparfait** (_qu''il vînt_, _qu''il fût_) et le **plus-que-parfait du subjonctif** (_qu''il fût venu_) appartiennent au style écrit recherché. **À ton niveau, sache les reconnaître en lecture, mais ne les produis pas** : le subjonctif présent reste correct et naturel à l''oral comme à l''écrit courant.

> 🗡️ Indice de lecture : un accent circonflexe sur la voyelle finale (_vînt, fût, eût, allât_) trahit souvent un subjonctif imparfait. Ne le prends pas pour une faute : c''est du français soigné d''auteur.

> 🏆 Porte franchie ! Tu maîtrises désormais l''horloge cachée de la phrase : indicatif réglé par la principale, conditionnel comme futur du passé, subjonctif courant à deux temps, et subjonctif littéraire reconnu sans être imité. Prochaine étape : tisser tout cela dans des périodes complexes sans jamais désaccorder un temps.', '# 📜 Résumé : La concordance des temps

- **Principe** — le temps de la subordonnée dépend du temps de la principale (présent ou passé) et du rapport temporel (simultanéité / antériorité / postériorité).
- **Indicatif, principale au présent** — simultanéité = présent (_qu''il vient_), antériorité = passé composé (_qu''il est venu_), postériorité = futur (_qu''il viendra_).
- **Indicatif, principale au passé** — tout recule : simultanéité = imparfait (_qu''il venait_), antériorité = plus-que-parfait (_qu''il était venu_), postériorité = conditionnel présent (_qu''il viendrait_).
- **Conditionnel = futur du passé** — _Il a annoncé qu''il **viendrait**_ ; le conditionnel passé marque le futur antérieur du passé (_il aurait fini_) ; aucune valeur d''hypothèse ici.
- **Subjonctif courant (deux temps)** — subjonctif présent pour le simultané/postérieur (_qu''il vienne_), subjonctif passé pour l''antérieur (_qu''il soit venu_), **même après un passé** (_Je voulais qu''il vienne_).
- ⚠️ Ne pas mettre l''imparfait de l''indicatif après une principale au passé au subjonctif : _qu''il **vienne**_, jamais _qu''il venait_.
- **Soutenu / littéraire** — subjonctif imparfait (_qu''il vînt_) et plus-que-parfait du subjonctif (_qu''il fût venu_) : à **reconnaître** en lecture (accent circonflexe), **non à produire**.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', 'La mise en relief (l''emphase)', 'Maîtrise les procédés d''emphase du français soutenu : l''extraction par « c''est … qui / c''est … que », les tournures « ce qui / ce que / ce dont … c''est », la dislocation (reprise ou anticipation par un pronom) et l''accord du verbe après « c''est moi/nous/vous qui ». Des outils essentiels pour focaliser l''attention, contraster et nuancer à l''oral comme à l''écrit (niveau C1 / DALF C1).', '# ⚔️ La mise en relief — L''art de braquer le projecteur

> 💡 «Une phrase neutre dit la vérité. Une phrase mise en relief dit la vérité ET te montre du doigt ce qui compte. Apprends à diriger le projecteur.»

## 🏰 Qu''est-ce que la mise en relief ?

Une phrase ordinaire répartit l''information de façon plate : _Marie a téléphoné hier._ Tout est sur le même plan. La **mise en relief** (ou **emphase**) consiste à **détacher un élément** pour le mettre en valeur, le contraster ou le corriger. C''est un réflexe de locuteur **autonome** : le sens reste le même, mais l''attention change de cible.

_Neutre :_ **Marie a téléphoné.**
_Emphase sur le sujet :_ **C''est Marie qui a téléphoné.** (et non quelqu''un d''autre)

Trois grandes familles de procédés : l''**extraction** (_c''est… qui/que_), les **tournures en ce qui/ce que/ce dont**, et la **dislocation**.

## ⚡ L''extraction : « c''est … QUI » et « c''est … QUE »

C''est le procédé roi. On encadre l''élément à mettre en valeur par **c''est … qui** ou **c''est … que**. Le choix entre _qui_ et _que_ ne dépend pas du hasard mais de la **fonction** de l''élément encadré.

| On met en relief…              | On utilise      | Exemple                              |
| ------------------------------ | --------------- | ------------------------------------ |
| le **sujet**                   | c''est … **qui** | _**C''est Marie qui** a téléphoné._   |
| un **COD**                     | c''est … **que** | _**C''est ce livre que** je préfère._ |
| un **complément** (lieu, etc.) | c''est … **que** | _**C''est à Paris qu''**il habite._    |
| un **complément de temps**     | c''est … **que** | _**C''est demain que** ça commence._  |

> 🗡️ Astuce décisive : **qui** = le sujet (il fait l''action), **que** = tout le reste (COD, lieu, temps, manière). Si l''élément encadré commande le verbe, c''est _qui_ ; sinon, c''est _que_.

## 🛡️ L''accord du verbe après « c''est … qui »

Voici la finesse qui trahit le niveau C1. Après **c''est moi/toi/nous/vous … qui**, le verbe de la relative s''accorde avec la **personne** mise en relief, **pas** avec la 3ᵉ personne.

| Élément en relief | Verbe accordé | Exemple                               |
| ----------------- | ------------- | ------------------------------------- |
| **moi** qui       | 1ʳᵉ sg        | _C''est **moi qui suis** responsable._ |
| **toi** qui       | 2ᵉ sg         | _C''est **toi qui as** raison._        |
| **nous** qui      | 1ʳᵉ pl        | _C''est **nous qui avons** gagné._     |
| **vous** qui      | 2ᵉ pl         | _C''est **vous qui avez** la clé._     |

> ⚠️ Piège majeur : on n''écrit **jamais** _~~C''est moi qui est responsable~~_ ni _~~C''est nous qui ont gagné~~_. Le pronom relatif _qui_ transmet la personne de son antécédent (_moi, nous_) au verbe : **C''est moi qui suis**, **c''est nous qui avons**.

## 🔮 Les tournures « ce qui / ce que / ce dont … c''est »

Pour mettre en relief un élément en l''annonçant d''abord, on emploie une **proposition en ce + relatif**, reprise par **c''est**. Le choix du relatif dépend de la construction du verbe.

| Le verbe se construit avec…     | Relatif     | Exemple                                         |
| ------------------------------- | ----------- | ----------------------------------------------- |
| un **sujet**                    | **ce qui**  | _**Ce qui** m''intéresse, **c''est** la musique._ |
| un **COD** (verbe direct)       | **ce que**  | _**Ce que** je veux, **c''est** partir._         |
| **de** + qqch (verbe en « de ») | **ce dont** | _**Ce dont** j''ai besoin, **c''est** du calme._  |

> 🗡️ Repère-toi sur le verbe : _intéresser_ a un sujet → **ce qui** ; _vouloir_ a un COD → **ce que** ; _avoir besoin **de**_ → **ce dont**. On dit _ce dont j''ai besoin_, jamais _~~ce que j''ai besoin~~_.

## 🧭 La dislocation : reprise et anticipation

La **dislocation** détache un élément en tête ou en fin de phrase, et le **double par un pronom**. Très fréquente à l''oral, elle est parfaitement correcte au registre courant.

- **Anticipation** (élément en tête, repris ensuite) : _**Moi, je** pense que… — **Ce film, je l''**ai adoré. — **À Paul, je lui** fais confiance._
- **Reprise** (pronom d''abord, élément détaché à la fin) : _**Il** est génial, **ce roman**. — **Je l''**adore, **cette chanson**._

Le pronom de reprise doit avoir **la bonne fonction** : un COD se reprend par _le/la/les_, un COI en « à » par _lui/leur_, un complément en « de » par _en_, un complément de lieu/de « à + chose » par _y_.

| Élément détaché           | Repris par    | Exemple                              |
| ------------------------- | ------------- | ------------------------------------ |
| COD (_ce film_)           | **le/la/les** | _Ce film, je **l''**ai adoré._        |
| COI à + personne (_Paul_) | **lui/leur**  | _À Paul, je **lui** fais confiance._ |
| de + chose (_ce projet_)  | **en**        | _De ce projet, j''**en** suis fier._  |

> ⚠️ Piège : on ne reprend pas un COD par _lui_. On dit _Ce livre, je **l''**ai lu_ (COD → _l''_), jamais _~~je lui ai lu~~_. Inversement, _téléphoner à qqn_ se reprend par _lui_ : _Marie, je **lui** téléphone._

## ✨ Registre et usage

L''**extraction** (_c''est… qui/que_) appartient à tous les registres et reste la tournure la plus sûre à l''écrit soutenu, notamment pour **corriger** ou **contraster** : _**Ce n''est pas le prix mais la qualité qui** a décidé._ La **dislocation** est typique de l''oral et de l''écrit familier ; on l''évite dans un texte académique formel, où l''on préfère l''extraction ou les tournures en _ce qui… c''est_.

> 🏆 Porte franchie ! Tu sais désormais braquer le projecteur sur n''importe quel élément, choisir _qui_ ou _que_, accorder le verbe après _c''est moi qui_ et disloquer sans fausse note. Prochaine quête : la **nominalisation**, pour condenser une idée entière en un seul groupe nominal.', '# 📜 Résumé : La mise en relief (l''emphase)

- **But** — détacher un élément pour le mettre en valeur, contraster ou corriger ; le sens reste le même, l''attention change de cible.
- **Extraction** — _c''est … **qui**_ pour le **sujet** (_C''est Marie qui a téléphoné_) ; _c''est … **que**_ pour un **COD** ou un **complément** (_C''est ce livre que je préfère ; C''est à Paris qu''il habite ; C''est demain que ça commence_).
- **Accord après « c''est moi/nous/vous qui »** — le verbe s''accorde avec la personne en relief : _C''est moi qui **suis** ; c''est nous qui **avons** ; c''est vous qui **avez**_ — jamais la 3ᵉ personne.
- **Tournures « ce … c''est »** — _**ce qui** … c''est_ (sujet : _Ce qui m''intéresse, c''est la musique_) ; _**ce que** … c''est_ (COD : _Ce que je veux, c''est partir_) ; _**ce dont** … c''est_ (verbe en « de » : _Ce dont j''ai besoin, c''est du calme_).
- **Dislocation** — détacher en tête ou en fin et reprendre par un pronom : _Moi, je pense… ; Ce film, je l''ai adoré ; Il est génial, ce roman ; À Paul, je lui fais confiance._
- **Reprise pronominale correcte** — COD → _le/la/les_, COI à + personne → _lui/leur_, de + chose → _en_, à + chose/lieu → _y_.
- ⚠️ Pièges — _qui_ (sujet) vs _que_ (complément) ; accord fautif (_~~c''est moi qui est~~_) ; _~~ce que j''ai besoin~~_ au lieu de _ce dont_ ; reprise d''un COD par _lui_ (_~~ce livre, je lui ai lu~~_).', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', 'La nominalisation', 'Transforme une phrase verbale ou adjectivale en groupe nominal pour atteindre le style soutenu, journalistique et administratif. Tu apprendras à dériver un nom à partir d''un verbe (-tion, -ment, -age, -ure, dérivé sans suffixe) ou d''un adjectif (-té/-ité, -eur, -esse, -ise), à choisir le bon suffixe, à maîtriser le genre du dérivé et à rédiger des titres de presse condensés.', '# 🔮 La nominalisation — l''art de condenser le verbe en nom

> 💡 « Là où le débutant fait une phrase, le styliste forge un nom. Transformer le verbe en groupe nominal, c''est compresser l''action en un seul mot puissant — l''arme du style soutenu, du journaliste et de l''administration. »

## 🏰 Pourquoi nominaliser au niveau C1

**Nominaliser**, c''est transformer une phrase construite autour d''un **verbe** ou d''un **adjectif** en un **groupe nominal**. _Les prix ont augmenté_ devient _**l''augmentation** des prix_ ; _Le suspect a été arrêté_ devient _**l''arrestation** du suspect_.

Cette opération condense l''information, crée un style abstrait et impersonnel, et permet les **titres de presse** ultra-compacts. C''est une marque essentielle du registre soutenu, journalistique et administratif visé au DALF C1.

## ⚡ Nominaliser à partir d''un VERBE

Le nom d''action dérive du verbe par un **suffixe**, parfois sans suffixe. Le suffixe n''est **pas libre** : il est fixé par l''usage pour chaque verbe.

| Suffixe            | Verbe → Nom dérivé                                                                                             | Exemple condensé                           |
| ------------------ | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| **-tion / -ation** | _construire → **la construction**_ · _augmenter → **l''augmentation**_                                          | _**La construction** du pont a commencé._  |
| **-ment**          | _développer → **le développement**_ · _changer → **le changement**_                                            | _**Le développement** durable s''impose._   |
| **-age**           | _recycler → **le recyclage**_ · _laver → **le lavage**_                                                        | _**Le recyclage** progresse en ville._     |
| **-ure**           | _ouvrir → **l''ouverture**_ · _fermer → **la fermeture**_                                                       | _**L''ouverture** du magasin est reportée._ |
| **sans suffixe**   | _arriver → **l''arrivée**_ · _choisir → **le choix**_ · _refuser → **le refus**_ · _accueillir → **l''accueil**_ | _**Le refus** du dialogue inquiète._       |

> 🗡️ Astuce : le dérivé sans suffixe se forme sur le radical (le choix, le refus, l''appel) ou avec une finale en **-ée** (l''arrivée, la montée, la chute). Ne lui colle pas de suffixe artificiel : on dit _le choix_, jamais ✗*le choisissement*.

## 🛡️ Nominaliser à partir d''un ADJECTIF

L''adjectif se transforme en nom de **qualité** par un suffixe abstrait.

| Suffixe        | Adjectif → Nom dérivé                                        | Exemple                                  |
| -------------- | ------------------------------------------------------------ | ---------------------------------------- |
| **-té / -ité** | _rapide → **la rapidité**_ · _beau → **la beauté**_          | _**La rapidité** d''exécution étonne._    |
| **-eur**       | _lent → **la lenteur**_ · _grand → **la grandeur**_          | _**La lenteur** des démarches lasse._    |
| **-esse**      | _gentil → **la gentillesse**_ · _faible → **la faiblesse**_  | _**La faiblesse** du plan est nette._    |
| **-ise**       | _gourmand → **la gourmandise**_ · _franc → **la franchise**_ | _**La gourmandise** est un défaut doux._ |

> ⚠️ Piège : le suffixe est imposé par l''usage. _Rapide_ donne _la rapidit**é**_, pas ✗*la rapidesse* ; _lent_ donne _la lent**eur**_, pas ✗*la lenteté*. Apprends le couple adjectif → nom comme un bloc.

## 🔮 Le GENRE du dérivé — une règle qui sauve

Le genre du nom dérivé est largement **prévisible** d''après le suffixe :

| Suffixe                      | Genre        | Exemples                                          |
| ---------------------------- | ------------ | ------------------------------------------------- |
| **-tion / -ation**           | **féminin**  | _la construction, l''augmentation, la disparition_ |
| **-té / -ité**               | **féminin**  | _la beauté, la rapidité, la fierté_               |
| **-eur** (qualité abstraite) | **féminin**  | _la lenteur, la douceur, la grandeur_             |
| **-esse**                    | **féminin**  | _la gentillesse, la faiblesse, la justesse_       |
| **-ment**                    | **masculin** | _le développement, le changement, le mouvement_   |
| **-age**                     | **masculin** | _le recyclage, le lavage, le passage_             |

> 🗡️ Astuce : on dit donc _**la** construction_ et _**le** développement_. L''erreur ✗*le construction* ou ✗*la développement* trahit aussitôt le faux pas de genre.

## 🧭 Le style nominal dans les titres de presse

Le journalisme adore la nominalisation : un titre supprime le verbe conjugué et tout tient en un groupe nominal.

| Phrase verbale                   | Titre nominalisé                    |
| -------------------------------- | ----------------------------------- |
| _Les prix ont augmenté._         | _**Hausse** des prix_               |
| _La police a arrêté le suspect._ | _**Arrestation** du suspect_        |
| _Un enfant a disparu._           | _**Disparition** inquiétante_       |
| _Le ministre a démissionné._     | _**Démission** du ministre_         |
| _L''usine va fermer._             | _**Fermeture** annoncée de l''usine_ |

> ⚠️ Piège : ne confonds pas la base. _Disparaître_ (verbe) → _**la disparition**_ ; on ne dit pas ✗*le disparaissement*. Et c''est bien _l''arrestation_ (du verbe _arrêter_), non ✗*l''arrêtation*.

## 🧱 Familles à maîtriser au C1

| Base (verbe/adjectif) | Nom dérivé       | Suffixe / procédé | Genre    |
| --------------------- | ---------------- | ----------------- | -------- |
| augmenter             | l''augmentation   | -ation            | féminin  |
| développer            | le développement | -ment             | masculin |
| recycler              | le recyclage     | -age              | masculin |
| ouvrir                | l''ouverture      | -ure              | féminin  |
| choisir               | le choix         | sans suffixe      | masculin |
| arriver               | l''arrivée        | -ée               | féminin  |
| rapide                | la rapidité      | -ité              | féminin  |
| lent                  | la lenteur       | -eur              | féminin  |
| gentil                | la gentillesse   | -esse             | féminin  |

> 🏆 Niveau franchi ! Tu sais désormais compresser n''importe quelle action en un nom précis et lui donner le bon genre. C''est exactement le réflexe qui distingue une copie C1 — passe au boss du chapitre pour le prouver. ⚔️', '# 📜 Résumé : La nominalisation

- **Nominaliser** = transformer une phrase verbale ou adjectivale en groupe nominal (style soutenu, journalistique, administratif) : _les prix ont augmenté_ → _l''augmentation des prix_.
- **À partir d''un verbe** : suffixe **-tion/-ation** (construire → la construction), **-ment** (développer → le développement), **-age** (recycler → le recyclage), **-ure** (ouvrir → l''ouverture), ou **dérivé sans suffixe** (choisir → le choix, refuser → le refus, arriver → l''arrivée).
- **À partir d''un adjectif** : **-té/-ité** (rapide → la rapidité), **-eur** (lent → la lenteur), **-esse** (gentil → la gentillesse), **-ise** (gourmand → la gourmandise).
- **Genre prévisible** : -tion/-ation, -té/-ité, -eur (qualité), -esse → **féminin** ; -ment, -age → **masculin**. On dit donc _la construction_, _le développement_.
- ⚠️ Le suffixe est **fixé par l''usage** : _la rapidité_ (non ✗rapidesse), _la lenteur_ (non ✗lenteté), _le choix_ (non ✗le choisissement).
- ⚠️ Attention à la base : _disparaître_ → _la disparition_ ; _arrêter_ → _l''arrestation_.
- **Titres de presse condensés** : « Hausse des prix », « Arrestation du suspect », « Disparition inquiétante » — le verbe disparaît, tout tient dans le groupe nominal.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', 'Connecteurs logiques avancés et articulation du discours', 'Au-delà des bases B2 : maîtrise les connecteurs du registre soutenu et l''architecture d''un argumentaire — addition et gradation (en outre, qui plus est, voire), reformulation (autrement dit, à savoir), illustration (notamment, à titre d''exemple), concession nuancée (certes… néanmoins, il n''en demeure pas moins que, force est de constater que), cause et conséquence soutenues (dans la mesure où, eu égard à, partant, dès lors, de sorte que + mode), conclusion (en somme, en définitive, somme toute) et structuration (d''une part… d''autre part, non seulement… mais encore).', '# ⚔️ Connecteurs logiques avancés et articulation du discours — Forge l''armure de ton argumentation

> 💡 « Au B2, tu reliais des idées ; au C1, tu bâtis une cathédrale. Le bon connecteur, au bon endroit, dans le bon registre : voilà ce qui sépare le candidat qui rédige du candidat qui convainc le jury du DALF. »

## 🏰 Du B2 au C1 : monter d''un cran de registre

Tu connais déjà _parce que_, _donc_, _mais_, _bien que_, _malgré_, _pourtant_, _néanmoins_. Ce chapitre ne les répète pas : il t''arme des connecteurs **du registre soutenu** et te montre comment **architecturer** un raisonnement. À ce niveau, le piège n''est plus la grammaire de base, mais le **choix de la valeur logique** (ne pas donner une cause pour une conséquence) et le **registre** (ne pas glisser un _du coup_ familier dans une dissertation).

## ⚡ Addition et gradation — empiler les arguments

| Connecteur            | Valeur                                     | Registre     |
| --------------------- | ------------------------------------------ | ------------ |
| **de plus, en outre** | ajout neutre d''un argument                 | soutenu      |
| **par ailleurs**      | ajout d''un point **connexe** mais distinct | soutenu      |
| **qui plus est**      | ajout d''un argument **encore plus fort**   | très soutenu |
| **voire**             | gradation : « et même », pousse plus loin  | soutenu      |

_Le projet est coûteux ; **en outre**, il est risqué. — La réforme est inefficace ; **qui plus est**, elle est injuste. — C''est une erreur, **voire** une faute grave._

> 🗡️ Astuce : **voire** introduit une **gradation** (on renchérit, on va plus loin), pas une simple addition. _difficile, **voire** impossible_ : le second terme est plus fort que le premier.

## 🔮 Reformulation et illustration — ne pas les confondre

Deux familles que les candidats mélangent souvent.

| Famille           | Connecteurs                                                 | Rôle                                    |
| ----------------- | ----------------------------------------------------------- | --------------------------------------- |
| **Reformulation** | _autrement dit, en d''autres termes, c''est-à-dire, à savoir_ | **redire** la même idée plus clairement |
| **Illustration**  | _ainsi, à titre d''exemple, notamment, en particulier_       | **donner un exemple** de l''idée         |

_La séance est reportée, **autrement dit** elle n''aura pas lieu aujourd''hui._ (on redit)
_Plusieurs régions sont touchées, **notamment** le Sud._ (on illustre par un cas)

> ⚠️ Piège : ne pas employer une **reformulation** là où il faut une **illustration**. _Beaucoup d''auteurs, ~~c''est-à-dire~~ Hugo et Zola_ est faux : Hugo et Zola sont des **exemples**, donc → _**notamment** Hugo et Zola_.

## 🛡️ Concession nuancée — le geste argumentatif du C1

La concession C1 ne se réduit pas à _bien que_ + subjonctif. Elle articule deux mouvements : on **admet** d''abord (_certes_), puis on **réfute** (_néanmoins_).

| Tournure                          | Construction           | Emploi                                    |
| --------------------------------- | ---------------------- | ----------------------------------------- |
| **certes… néanmoins / mais**      | deux propositions      | admettre puis réfuter (le balancier)      |
| **il n''en demeure pas moins que** | + **indicatif**        | « malgré cela, il reste vrai que… »       |
| **force est de constater que**    | + **indicatif**        | reconnaître un fait imposé par l''évidence |
| **quoi qu''il en soit**            | en tête, + proposition | « de toute façon », clôt le débat         |

_**Certes**, le coût est élevé ; **néanmoins**, le bénéfice le justifie. — Les chiffres se sont améliorés ; **il n''en demeure pas moins que** la situation reste fragile. — **Force est de constater que** l''objectif n''a pas été atteint._

> 🗡️ Astuce : **il n''en demeure pas moins que** et **force est de constater que** se construisent à l''**indicatif** (on pose un fait), jamais au subjonctif.

## 🧮 Cause et conséquence soutenues — et le mode après « de sorte que »

| Connecteur             | Valeur              | Construction / registre                        |
| ---------------------- | ------------------- | ---------------------------------------------- |
| **dans la mesure où**  | cause/condition     | + indicatif ; « dans la mesure où c''est vrai » |
| **étant donné que**    | cause posée en fait | + indicatif                                    |
| **eu égard à**         | cause               | + **nom** (très soutenu, formel)               |
| **dès lors / partant** | conséquence         | en tête ; « par suite, donc » (soutenu)        |

La pièce maîtresse, c''est **de (telle) sorte que**, dont le sens change avec le **mode** :

$$ de sorte que + INDICATIF = conséquence (le fait a eu lieu) $$
$$ de sorte que + SUBJONCTIF = but (l''intention visée) $$

_Il a parlé fort, **de sorte que** tout le monde **a entendu**._ (indicatif → conséquence : ils ont entendu)
_Parlez fort, **de sorte que** tout le monde **entende**._ (subjonctif → but : pour qu''ils entendent)

> ⚠️ Piège du « d''autant que » : **d''autant que / d''autant plus que** renforce une cause (« et ce, d''autant plus que… »). On ne l''emploie **pas** pour une simple conséquence. _Je l''aide, **d''autant qu''**il est seul_ (cause renforcée) ✓ ; ~~Il est seul, d''autant qu''il déprime~~ pour dire « donc » ✗.

## 🗝️ Conclusion et synthèse — refermer le raisonnement

| Connecteur           | Nuance                                        |
| -------------------- | --------------------------------------------- |
| **en somme**         | récapitule l''essentiel                        |
| **en définitive**    | « tout bien pesé », après réflexion           |
| **en fin de compte** | « au bout du compte », bilan final            |
| **somme toute**      | « après tout, finalement », nuance d''évidence |

_**En définitive**, la prudence s''impose. — Les avis divergent ; **somme toute**, le projet mérite d''être tenté._

> 🗡️ Astuce : ces connecteurs **ferment** un développement. N''en mets qu''un, en tête de ta conclusion — les empiler (_en somme, en définitive, somme toute_) sonne maladroit.

## 🧪 Structurer l''argumentaire — les couples corrélatifs

| Couple                                      | Rôle                             |
| ------------------------------------------- | -------------------------------- |
| **d''une part… d''autre part**                | présenter deux faces équilibrées |
| **d''abord… ensuite… enfin**                 | énumérer des étapes ordonnées    |
| **non seulement… mais encore / mais aussi** | ajouter un argument plus fort    |

_**Non seulement** la mesure est coûteuse, **mais encore** elle est inefficace._

> ⚠️ Piège de construction : après **non seulement** placé en tête, l''**inversion** du sujet est fréquente à l''écrit soutenu : _**Non seulement** a-t-il refusé, **mais** il a protesté._

> 🏆 Quête accomplie ! Tu sais désormais graduer (_voire_), reformuler vs illustrer (_autrement dit_ vs _notamment_), concéder avec finesse (_certes… néanmoins_, _il n''en demeure pas moins que_), nuancer cause et conséquence (_dans la mesure où_, _de sorte que_ + mode), conclure (_en définitive_) et bâtir un plan (_d''une part… d''autre part_). Ton arsenal d''argumentation DALF C1 est complet. ⚔️', '# 📜 Résumé : Connecteurs logiques avancés et articulation du discours

- **Addition / gradation** — _de plus, en outre, par ailleurs_ (ajout soutenu) ; _qui plus est_ (argument plus fort) ; _voire_ (gradation : « et même », _difficile, voire impossible_).
- **Reformulation** — _autrement dit, en d''autres termes, c''est-à-dire, à savoir_ : on **redit** la même idée. À ne pas confondre avec l''illustration.
- **Illustration** — _ainsi, à titre d''exemple, notamment, en particulier_ : on **donne un exemple** (_notamment Hugo et Zola_, jamais _c''est-à-dire Hugo et Zola_).
- **Concession nuancée** — _certes… néanmoins_ (admettre puis réfuter) ; _il n''en demeure pas moins que_ + indicatif ; _force est de constater que_ + indicatif ; _quoi qu''il en soit_ (clôt le débat).
- **Cause soutenue** — _dans la mesure où_, _étant donné que_ (+ indicatif) ; _eu égard à_ + nom.
- **Conséquence soutenue** — _dès lors, partant_ ; **de sorte que** + **indicatif** = conséquence, + **subjonctif** = but.
- ⚠️ **d''autant que / d''autant plus que** renforce une **cause**, jamais une conséquence (≠ « donc »).
- **Conclusion** — _en somme, en définitive, en fin de compte, somme toute_ : un seul, en tête de la conclusion.
- **Structuration** — _d''une part… d''autre part_, _d''abord… ensuite… enfin_, _non seulement… mais encore_ (avec inversion fréquente : _non seulement a-t-il refusé…_).', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', 'Les registres de langue', 'Identifier et adapter le registre soutenu, courant et familier (et reconnaître le très familier). Le lexique selon le registre (bagnole / voiture / automobile, bosser / travailler / œuvrer, fric / argent / fonds, bouffer / manger / se restaurer) ; la syntaxe (interrogation Tu viens ? / Est-ce que tu viens ? / Viens-tu ?, négation avec ou sans « ne », tournures soutenues comme l''inversion et « il convient de ») ; les marqueurs du familier (ça, on pour nous, troncations resto/ado/ordi, « quoi », « genre ») ; et le choix du mot ou de la tournure adapté·e au contexte et au destinataire.', '# 🎭 Les registres de langue — parler à la bonne table

> 💡 «Connaître un mot, c''est bien ; savoir à qui le dire, c''est l''art du locuteur autonome. Le registre, c''est le costume de ta phrase : on ne s''habille pas pareil pour un bal et pour la plage.»

## 🏰 Trois registres, une seule idée

Le **registre** (ou niveau de langue) est la variété de français adaptée à une situation, à une relation et à un destinataire. La même idée se dit à des hauteurs différentes :

| Familier           | Courant       | Soutenu                       |
| ------------------ | ------------- | ----------------------------- |
| _une bagnole_      | _une voiture_ | _une automobile_              |
| _bosser_           | _travailler_  | _œuvrer / labourer la tâche_  |
| _le fric_          | _l''argent_    | _les fonds / les deniers_     |
| _la flotte_        | _l''eau_       | _l''eau (potable)_             |
| _bouffer_          | _manger_      | _se restaurer / se sustenter_ |
| _un truc_          | _une chose_   | _un objet / un élément_       |
| _un mec / un type_ | _un homme_    | _un individu / un monsieur_   |
| _crever_           | _mourir_      | _décéder / s''éteindre_        |

> 🗡️ Astuce : le **courant** est le registre neutre, valable presque partout. Le **soutenu** marque la distance, l''écrit officiel, l''élégance ; le **familier** marque la proximité, l''oral entre proches. Au-delà encore vit le **très familier** (_la caisse_ pour la voiture, _la thune_ pour l''argent, le vulgaire), à reconnaître mais à éviter à l''écrit.

## ⚡ La syntaxe change aussi, pas seulement les mots

Le registre se lit dans la **construction de la phrase** autant que dans le lexique.

**L''interrogation** — trois niveaux du même sens :

| Familier         | Courant                   | Soutenu         |
| ---------------- | ------------------------- | --------------- |
| _Tu viens ?_     | _Est-ce que tu viens ?_   | _Viens-tu ?_    |
| _Tu veux quoi ?_ | _Qu''est-ce que tu veux ?_ | _Que veux-tu ?_ |

L''intonation seule (_Tu viens ?_) est familière ; **est-ce que** est courant ; l''**inversion du sujet** (_Viens-tu ?_) est soutenue.

**La négation** — l''oral familier **omet souvent le « ne »** :

- Familier : _J''sais pas. / Je viens pas. / Il a rien dit._
- Courant et soutenu : _Je ne sais pas. / Je ne viens pas. / Il n''a rien dit._

> ⚠️ Piège : à l''écrit, l''omission du « ne » est une **faute de registre** (et perçue comme une faute tout court). On rétablit toujours la négation complète : _Je **ne** sais **pas**._

**Les tournures soutenues** ajoutent l''inversion, des verbes impersonnels et des formules figées :

$$ il convient de + infinitif · veuillez agréer mes salutations distinguées · je vous saurais gré de · force est de constater que $$

## 🛡️ Les marqueurs du familier

Certains mots trahissent immédiatement le registre familier — à connaître pour les **repérer** et savoir les **remplacer** à l''écrit :

| Marqueur familier                              | Équivalent courant / soutenu                      |
| ---------------------------------------------- | ------------------------------------------------- |
| **ça**                                         | cela                                              |
| **on** (= nous)                                | nous                                              |
| _resto, ado, ordi, frigo_ (troncations)        | restaurant, adolescent, ordinateur, réfrigérateur |
| _« quoi », « genre », « bref »_ (mots d''appui) | (à supprimer à l''écrit)                           |
| _grave, trop_ (= très)                         | très, fort, extrêmement                           |

_« On part demain, quoi »_ est doublement familier (_on_ pour _nous_, _quoi_ en appui) ; à l''écrit : _« Nous partons demain. »_

> 🗡️ Astuce : la **troncation** (couper le mot : _ordi_, _appart_, _aprèm_) est le signal familier le plus rapide à repérer. En contexte soigné, on restitue le mot entier.

## 🔮 Adapter au contexte et au destinataire

Le bon registre n''est pas le plus élevé : c''est le **plus adapté**. On calibre selon **à qui** et **pourquoi** on écrit.

- **Lettre formelle, candidature, administration** → soutenu : _« Je vous saurais gré de bien vouloir… »_, _« Veuillez agréer… »_.
- **Conversation, courriel professionnel neutre** → courant : _« Pouvez-vous m''envoyer le document ? »_.
- **Message à un ami, SMS** → familier accepté : _« Tu m''envoies le doc ? »_.

> ⚠️ Piège majeur : le **mélange incohérent** de registres dans une même phrase. _« Je vous saurais gré de m''envoyer ce truc fissa »_ est un contresens social : début soutenu (_je vous saurais gré_), fin familière (_ce truc_, _fissa_). On reste **homogène** d''un bout à l''autre.

## 🧮 La méthode du locuteur autonome

1. **Identifier la situation** : qui parle à qui, à l''oral ou à l''écrit, en contexte intime ou officiel ?
2. **Choisir le registre cible** : familier, courant ou soutenu.
3. **Aligner lexique ET syntaxe** : _bouffer_ va avec _on_ et _pas de « ne »_ ; _se restaurer_ va avec l''inversion et le _ne… pas_ complet.
4. **Vérifier l''homogénéité** : aucune note discordante (pas de _truc_ dans une lettre, pas de _veuillez_ dans un SMS).

> 🏆 Porte franchie ! Tu ne choisis plus seulement le bon mot : tu choisis le bon **ton**, accordé à la situation. Tu lis le registre d''un texte et tu sais le déplacer vers le haut ou vers le bas sans fausse note. Cap sur le chapitre suivant : les expressions idiomatiques et le lexique soutenu.', '# 📜 Résumé : Les registres de langue

- **Trois registres** — le familier (proximité, oral entre proches), le courant (neutre, partout) et le soutenu (distance, écrit officiel, élégance) ; au-delà, le très familier, à reconnaître mais à éviter à l''écrit.
- **Le lexique varie** — _bagnole / voiture / automobile_ ; _bosser / travailler / œuvrer_ ; _fric / argent / fonds_ ; _bouffer / manger / se restaurer_ ; _un truc / une chose / un objet_.
- **La syntaxe varie aussi** — interrogation : _Tu viens ?_ (familier) / _Est-ce que tu viens ?_ (courant) / _Viens-tu ?_ (soutenu, inversion).
- **La négation** — l''oral familier omet le « ne » (_J''sais pas_) ; à l''écrit on rétablit toujours _je ne sais pas_.
- **Tournures soutenues** — inversion, verbes impersonnels (_il convient de_), formules figées (_veuillez agréer mes salutations distinguées_, _je vous saurais gré de_).
- **Marqueurs du familier** — _ça_ (= cela), _on_ (= nous), troncations (_resto, ado, ordi_), mots d''appui (_quoi, genre_).
- **Adapter au destinataire** — lettre formelle = soutenu, courriel neutre = courant, message à un ami = familier ; choisir le mot adapté.
- ⚠️ Éviter le **mélange incohérent** : pas de soutenu et de familier dans la même phrase (_je vous saurais gré… ce truc_).', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', 'Vocabulaire C1 : expressions idiomatiques et lexique soutenu', 'Décode et emploie les expressions imagées et les locutions figées du français courant (tomber dans le panneau, avoir le bras long, mettre la charrue avant les bœufs…), maîtrise un lexique soutenu et précis (la mansuétude, fortuit, fallacieux, exacerber, pallier, s''avérer, déroger à…) et déjoue les pièges classiques du niveau C1 (« pallier à », « s''avérer vrai », « au jour d''aujourd''hui »).', '# ⚔️ Expressions idiomatiques et lexique soutenu — L''arsenal du locuteur autonome

> 💡 «Au niveau C1, on ne traduit plus les mots un à un : on lit entre les lignes. Une expression imagée mal comprise, et tout le sens s''effondre.»

## 🏰 Pourquoi ce chapitre

Tu maîtrises déjà la grammaire et l''argumentation. Il te manque la **texture** de la langue : ces **expressions imagées** que les natifs glissent partout, ces **locutions figées** qu''on ne peut pas démonter mot à mot, et ce **lexique soutenu** qui distingue un écrit C1 d''un écrit B2. À ce niveau, le danger n''est plus la faute grossière mais le **faux sens** : prendre une image au pied de la lettre, confondre deux expressions voisines, ou tomber dans un piège de norme (« pallier à »). Ce chapitre est ton bestiaire : apprends les bêtes avant de les affronter en donjon.

## ⚡ Expressions imagées : ne pas les prendre au pied de la lettre

Une **expression imagée** a un sens **figuré** qu''on ne déduit pas des mots. Lis-les en situation, jamais littéralement.

| Expression                                 | Sens figuré (le vrai)                              |
| ------------------------------------------ | -------------------------------------------------- |
| **tomber dans le panneau**                 | se laisser piéger, se faire avoir par une ruse     |
| **avoir le bras long**                     | avoir de l''influence, des relations puissantes     |
| **donner sa langue au chat**               | renoncer à deviner, avouer qu''on ne trouve pas     |
| **mettre la charrue avant les bœufs**      | faire les choses dans le mauvais ordre             |
| **couper la poire en deux**                | faire un compromis, partager équitablement         |
| **prendre des vessies pour des lanternes** | se tromper grossièrement, croire une absurdité     |
| **le revers de la médaille**               | l''aspect négatif d''une chose par ailleurs positive |
| **un coup d''épée dans l''eau**              | une action vaine, sans aucun effet                 |
| **tirer son épingle du jeu**               | se sortir habilement d''une situation délicate      |
| **avoir d''autres chats à fouetter**        | avoir des préoccupations plus importantes          |

> 🗡️ Astuce : **tomber dans le panneau** n''a rien à voir avec un panneau de signalisation — le « panneau » était à l''origine un filet de chasse. L''image est figée : on ne dit jamais « tomber sur le panneau ».

## 🛡️ Locutions figées : des blocs qu''on n''altère pas

Une **locution figée** se mémorise telle quelle ; on n''en change ni l''ordre ni le nombre.

| Locution                        | Sens                                             |
| ------------------------------- | ------------------------------------------------ |
| **faire la part des choses**    | distinguer le vrai du faux, relativiser, nuancer |
| **prendre son mal en patience** | supporter une situation pénible en attendant     |
| **avoir voix au chapitre**      | avoir le droit de donner son avis, de décider    |
| **battre de l''aile**            | être en difficulté, péricliter, fonctionner mal  |
| **mettre la main à la pâte**    | participer concrètement au travail               |
| **en avoir gros sur le cœur**   | éprouver de la tristesse, du ressentiment retenu |

> ⚠️ Piège : ne confonds pas deux expressions **voisines par l''image mais opposées par le sens**. _Couper la poire en deux_ = faire un compromis ; _mettre la charrue avant les bœufs_ = inverser l''ordre. L''image agricole est proche, le sens n''a rien à voir.

## 🔮 Lexique soutenu : le mot juste, précis et rare

Le registre soutenu remplace l''à-peu-près par le terme exact.

| Mot soutenu       | Sens précis                                                              |
| ----------------- | ------------------------------------------------------------------------ |
| **un comble**     | le point culminant, le summum (souvent ironique : « c''est un comble ! ») |
| **l''acharnement** | la persévérance obstinée, parfois excessive ou cruelle                   |
| **la mansuétude** | la bienveillance indulgente, la clémence envers une faute                |
| **fortuit**       | qui arrive par hasard, imprévu (un événement fortuit)                    |
| **fallacieux**    | trompeur, conçu pour induire en erreur (un argument fallacieux)          |
| **exacerber**     | rendre plus intense, aviver, pousser à l''extrême                         |
| **susciter**      | faire naître, provoquer (susciter l''intérêt, la curiosité)               |
| **escompter**     | espérer, compter sur quelque chose à venir                               |

Trois verbes soutenus à manier avec précision :

- **s''avérer** = se révéler exact à l''usage (le « ver » vient de _verus_, « vrai »). _Le projet s''est avéré rentable._
- **pallier** = compenser, remédier à un manque. **Verbe transitif direct** : on _pallie un défaut_, jamais ~~« pallier à »~~.
- **déroger à** = manquer à une règle, faire exception. _Déroger à un principe, au règlement._

> 🗡️ Astuce : la **mansuétude** n''est pas la faiblesse — c''est une indulgence choisie, lucide. Un juge fait preuve de mansuétude quand il atténue une peine par bonté.

## 🧪 Les pièges de norme du C1

Trois fautes que même de bons locuteurs commettent — et que le DALF sanctionne.

| Forme fautive                                 | Forme correcte                            | Pourquoi                                                                   |
| --------------------------------------------- | ----------------------------------------- | -------------------------------------------------------------------------- |
| ~~pallier **à** un problème~~                 | **pallier** un problème                   | _pallier_ est transitif direct : pas de préposition _à_                    |
| ~~s''avérer **vrai**~~ / ~~s''avérer **faux**~~ | s''avérer **exact** / s''avérer **inexact** | _s''avérer_ contient déjà l''idée du vrai → _s''avérer vrai_ est un pléonasme |
| ~~au jour d''aujourd''hui~~                     | **aujourd''hui** (ou _à ce jour_)          | _aujourd''hui_ signifie déjà « au jour de ce jour » : pléonasme             |

> ⚠️ Piège : _s''avérer faux_ est si répandu qu''il est parfois toléré, mais à l''écrit C1 préfère _se révéler faux_ ou _s''avérer inexact_ — la rigueur paie à l''examen.

## 📜 Stratégie : décoder une expression inconnue

Face à une image que tu ne connais pas, ne traduis jamais littéralement. Appuie-toi sur :

1. **Le contexte** — _« ses efforts ont été un coup d''épée dans l''eau »_ : le ton d''échec t''oriente vers « action vaine ».
2. **L''opposition logique** — si la phrase oppose deux idées, l''expression marque souvent la nuance ou le revers.
3. **La forme figée** — une expression idiomatique ne se modifie pas : un mot changé, et c''est un faux sens ou une faute.

> 🏆 Porte franchie ! Tu possèdes désormais le bestiaire des expressions imagées, les locutions figées et le lexique soutenu du C1 — et tu ne diras plus jamais « pallier à ». Au prochain donjon, ces armes feront la différence face à un texte complexe.', '# 📜 Résumé : Expressions idiomatiques et lexique soutenu

- **Expressions imagées** — sens figuré, jamais littéral : _tomber dans le panneau_ (se faire piéger), _avoir le bras long_ (être influent), _mettre la charrue avant les bœufs_ (faire dans le désordre), _un coup d''épée dans l''eau_ (action vaine), _tirer son épingle du jeu_ (s''en sortir habilement).
- **Le revers de la médaille / couper la poire en deux** — l''aspect négatif d''une chose positive ; faire un compromis. _Prendre des vessies pour des lanternes_ = se tromper grossièrement.
- **Locutions figées** (à mémoriser telles quelles) — _faire la part des choses_ (nuancer), _prendre son mal en patience_ (supporter), _avoir voix au chapitre_ (avoir son mot à dire), _battre de l''aile_ (péricliter), _mettre la main à la pâte_ (participer), _en avoir gros sur le cœur_ (avoir du ressentiment).
- **Lexique soutenu** — _un comble_ (le summum), _l''acharnement_ (persévérance obstinée), _la mansuétude_ (indulgence bienveillante), _fortuit_ (dû au hasard), _fallacieux_ (trompeur), _exacerber_ (intensifier), _susciter_ (faire naître), _escompter_ (espérer).
- **Verbes précis** — _s''avérer_ (se révéler exact), _pallier_ (compenser, **transitif direct**), _déroger à_ (manquer à une règle).
- **Pièges C1** — on dit _pallier un problème_ (jamais ~~pallier à~~) ; _s''avérer exact/inexact_ (et non ~~s''avérer vrai~~, pléonasme) ; _aujourd''hui_ (et non ~~au jour d''aujourd''hui~~, pléonasme).
- ⚠️ Ne jamais traduire une expression au pied de la lettre ni en modifier la forme figée : un mot changé, c''est un faux sens.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', 'Compréhension écrite : lire l''implicite et la pensée critique', 'Maîtrise la lecture de textes complexes au niveau C1 (épreuve de compréhension écrite du DALF C1) : repérer la thèse implicite et les présupposés, suivre une structure argumentative dense, décoder le ton, l''ironie et la distance critique, identifier l''énonciation (qui parle ?), inférer le sens entre les lignes, interpréter un terme abstrait ou figuré en contexte, peser la valeur d''un connecteur et la modalisation, et distinguer les nuances entre des interprétations très proches.', '# 🧭 Compréhension écrite : lire l''implicite — Le donjon des textes denses

> 💡 «Au niveau C1, un texte ne dit jamais tout. Il sous-entend, il insinue, il prend ses distances. Le héros-lecteur ne déchiffre plus des mots : il reconstruit une pensée. Apprends à lire entre les lignes et aucun texte ne te résistera.»

## 🏰 Le pacte du lecteur expert

Au B2, on repérait la thèse et le ton. Au **C1**, on monte d''un cran : la thèse est souvent **implicite**, l''auteur fait parler **plusieurs voix**, il **module** ses affirmations et tient le lecteur à **distance critique**. Ta mission : ne jamais confondre **ce que le texte dit** (énoncé) avec **ce qu''il veut faire entendre** (visée). L''inférence n''est pas une devinette : c''est un raisonnement **contrôlé**, justifié par des indices précis du texte.

> 🗡️ Astuce : avant de répondre, demande-toi toujours trois choses — **Qui parle ? Sur quel ton ? Pour conclure quoi ?** La bonne réponse découle du texte, jamais de tes opinions personnelles.

## ⚡ Repérer l''implicite et les présupposés

Un **présupposé** est une information tenue pour acquise, glissée sans être affirmée. Le **sous-entendu** est ce que l''auteur laisse deviner.

| Indice dans le texte                              | Présupposé / sous-entendu                              |
| ------------------------------------------------- | ------------------------------------------------------ |
| _Il a **encore** échoué._                         | présuppose qu''il a déjà échoué auparavant              |
| _Même les plus prudents s''y sont laissé prendre._ | sous-entend que le piège était redoutable              |
| _On **prétend** que la réforme a réussi._         | l''auteur doute : « prétend » distancie l''affirmation   |
| _Cette « réussite » mérite examen._               | les guillemets signalent une réserve, voire une ironie |

> ⚠️ Piège : un présupposé reste vrai même si l''on nie la phrase. _Il n''a pas encore réussi_ présuppose toujours qu''il essaie. Ne prends pas un présupposé pour la thèse — c''est l''arrière-plan, pas le propos.

## 🛡️ L''énonciation : qui parle vraiment ?

Un texte C1 est souvent **polyphonique** : l''auteur **cite une voix adverse** pour la réfuter. Confondre cette voix rapportée avec la position de l''auteur est l''erreur n°1.

| Formule                                             | Qui parle ?                                                                |
| --------------------------------------------------- | -------------------------------------------------------------------------- |
| _On nous répète que…_ / _Certains soutiennent que…_ | une **voix adverse**, souvent réfutée ensuite                              |
| _Soit. Mais…_ / _Certes… pourtant…_                 | l''auteur **concède** puis objecte (sa vraie thèse vient après le « mais ») |
| _Il serait tentant de croire que…_                  | l''auteur signale une idée séduisante **qu''il va contester**                |

## 🔮 La modalisation : le degré d''engagement

La **modalisation** indique à quel point l''auteur s''engage dans ce qu''il dit. Un mot change tout.

- **Engagement fort** : _l''évidence montre_, _il est certain que_, _sans aucun doute_.
- **Prudence / réserve** : _il semblerait_, _peut-être_, _on pourrait penser_, conditionnel _aurait aggravé_.
- **Distance / doute** : _prétendu_, _soi-disant_, guillemets de distance, _à en croire ses partisans_.

> 🗡️ Astuce : une affirmation au **conditionnel** (_la réforme aurait creusé les inégalités_) n''est pas un fait, mais une donnée **non assumée** par l''auteur. Ne la traite jamais comme une certitude du texte.

## 🗝️ Le ton, l''ironie et la distance critique

L''**ironie** dit le contraire de ce qu''elle pense, souvent par **antiphrase** louangeuse : _nos dirigeants, dans leur infinie sagesse…_ — repère le décalage entre l''éloge et les faits cités. La **litote** dit peu pour suggérer beaucoup : _les pertes ne furent pas tout à fait négligeables_ → elles furent énormes.

> ⚠️ Piège : ne prends jamais une phrase ironique **au pied de la lettre**. Si le sens littéral contredit les faits du texte, c''est que l''auteur pense l''inverse de ce qu''il écrit.

## 🧱 Le sens figuré et le mot abstrait en contexte

Un terme rare, abstrait ou imagé se devine par son **environnement** : contraste, reformulation, apposition, exemple.
_Sa **pugnacité** — ce refus obstiné de céder — finit par payer._ → la reformulation donne le sens. Le **sens figuré** prime quand le sens littéral est exclu par le contexte (_la vitrine du progrès_ = une façade flatteuse, pas un magasin).

## 🧮 La cohérence argumentative et la valeur des connecteurs

Chaque connecteur a une **fonction logique** : la repérer, c''est cartographier l''argumentation.

| Connecteur                                   | Fonction                                                       |
| -------------------------------------------- | -------------------------------------------------------------- |
| _certes… mais_, _il est vrai que… toutefois_ | **concession** puis objection (la thèse suit)                  |
| _or_                                         | introduit un **fait gênant** qui fait basculer le raisonnement |
| _en somme_, _aussi_, _ainsi_                 | **conclusion** ou conséquence                                  |
| _loin de…_, _bien loin que_                  | **réfutation** d''une idée reçue                                |

### 🧪 Exemple intégralement résolu (niveau Boss)

> « On nous l''a assez répété : la croissance résoudra tout. Le chômage ? La croissance. La dette ? Encore la croissance. À force d''invoquer ce remède universel, on a fini par oublier de se demander s''il guérissait vraiment, ou s''il ne faisait que masquer les symptômes. »

1. **Qui parle ?** _On nous l''a assez répété_ = une voix collective rapportée, **pas** l''auteur. L''expression marque déjà l''agacement.
2. **Sur quel ton ?** La répétition mécanique (_La croissance… Encore la croissance_) est **ironique** : l''auteur singe le slogan pour le ridiculiser.
3. **Pour conclure quoi ?** _on a fini par oublier de se demander s''il guérissait vraiment_ → thèse **implicite** : on érige la croissance en remède miracle **sans jamais en questionner l''efficacité réelle**.
4. **Le piège** : répondre « la croissance résout tout » = confondre la voix raillée avec la thèse de l''auteur. ✓ La bonne lecture inverse cette voix.

> 🏆 Donjon franchi ! Tu sais désormais traquer l''implicite, démasquer l''ironie et reconstruire une argumentation dense. Chaque indice du texte est une arme — sers-t''en. Prochain palier : les épreuves d''entraînement. ⚔️', '# 📜 Résumé : Compréhension écrite — lire l''implicite (C1)

- **Inférence contrôlée** : ne jamais confondre ce que le texte dit avec ce qu''il veut faire entendre ; toute réponse s''appuie sur un indice précis du texte.
- **Présupposés** : information tenue pour acquise (_il a **encore** échoué_) ; reste vraie même phrase niée — c''est l''arrière-plan, pas la thèse.
- **Énonciation / polyphonie** : repérer qui parle ; _on nous répète que…_, _certains soutiennent…_ = voix adverse souvent réfutée ; la thèse de l''auteur suit le « mais ».
- **Modalisation** : le degré d''engagement (_il est certain_ vs _il semblerait_, conditionnel _aurait aggravé_) ; une affirmation non assumée n''est pas un fait du texte.
- **Ton, ironie, litote** : l''antiphrase loue pour critiquer (_dans leur infinie sagesse_) ; ne jamais lire l''ironie au pied de la lettre.
- **Sens figuré / mot en contexte** : se devine par contraste, reformulation, apposition ; le figuré prime quand le littéral est exclu.
- **Connecteurs** : _certes… mais_ = concession+objection ; _or_ = fait gênant qui fait basculer ; _en somme_ = conclusion ; _loin de_ = réfutation.
- **Méthode** : avant chaque réponse, se demander — Qui parle ? Sur quel ton ? Pour conclure quoi ?', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c59c4434-dee3-59ac-8b21-d37b637b9f83', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3ed080f-c7d5-58e9-b611-73f0eeacf2d1', 'c59c4434-dee3-59ac-8b21-d37b637b9f83', 'Complète : « Elle s''est ___ devant tout le monde. » (verbe : s''évanouir)', '[{"id":"a","text":"évanoui"},{"id":"b","text":"évanouie"},{"id":"c","text":"évanouis"},{"id":"d","text":"évanouies"}]'::jsonb, 'b', '« S''évanouir » est un verbe essentiellement pronominal : il s''accorde avec le sujet. Le sujet « elle » étant féminin singulier, on écrit « elle s''est évanouie ». La forme « évanoui » ne marquerait pas le féminin.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f043a39-a062-552e-a7f5-6d781231510a', 'c59c4434-dee3-59ac-8b21-d37b637b9f83', 'Choisis la phrase correcte.', '[{"id":"a","text":"Les fleurs que j''ai acheté sont fanées."},{"id":"b","text":"Les fleurs que j''ai achetées sont fanées."},{"id":"c","text":"Les fleurs que j''ai achetés sont fanées."},{"id":"d","text":"Les fleurs que j''ai achetée sont fanées."}]'::jsonb, 'b', 'Avec l''auxiliaire « avoir », le participe s''accorde avec le COD placé avant le verbe. Ici « que » remplace « les fleurs » (féminin pluriel) et précède le participe, donc on écrit « achetées ». Sans COD antéposé, le participe resterait invariable.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e1cebda-3d9d-55be-8547-ac94bbc54c15', 'c59c4434-dee3-59ac-8b21-d37b637b9f83', 'Complète : « Elle s''est ___ les mains avant le repas. »', '[{"id":"a","text":"lavée"},{"id":"b","text":"lavées"},{"id":"c","text":"lavé"},{"id":"d","text":"lavés"}]'::jsonb, 'c', 'Le COD « les mains » est placé APRÈS le verbe, donc le participe reste invariable : « elle s''est lavé les mains ». Le pronom « se » n''est ici qu''un COI (à elle-même). On n''accorderait (« lavée ») que si le pronom était lui-même COD, comme dans « elle s''est lavée ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('944c9b98-ee1c-50c3-b24e-f291509a3a3b', 'c59c4434-dee3-59ac-8b21-d37b637b9f83', 'Complète : « Des erreurs, j''en ai ___ beaucoup. »', '[{"id":"a","text":"faites"},{"id":"b","text":"faite"},{"id":"c","text":"faits"},{"id":"d","text":"fait"}]'::jsonb, 'd', 'Lorsque le COD antéposé est le pronom « en », le participe passé reste invariable : « j''en ai fait ». La valeur partitive de « en » empêche l''accord, même si « des erreurs » est féminin pluriel. On n''écrit donc jamais « faites » ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e07776c-2820-5f29-9f33-4e4da093d59c', 'c59c4434-dee3-59ac-8b21-d37b637b9f83', 'Complète : « Ils se sont ___ pendant des heures au téléphone. » (verbe : se parler)', '[{"id":"a","text":"parlés"},{"id":"b","text":"parlé"},{"id":"c","text":"parlée"},{"id":"d","text":"parlées"}]'::jsonb, 'b', 'On dit « parler À quelqu''un » : le pronom réfléchi « se » est donc un COI, jamais un COD. Le participe reste invariable : « ils se sont parlé ». C''est le même cas que « se téléphoner » ou « se succéder ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('130cc152-4668-5733-b59e-41b5b7ec8a1f', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', '⭐ Entraînement : l''accord du participe passé', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11237457-58d9-5d3b-b12c-a9f4fba1bb5c', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « Les lettres que j''ai ___ hier sont parties. » (verbe : écrire)', '[{"id":"a","text":"écrit"},{"id":"b","text":"écrits"},{"id":"c","text":"écrites"},{"id":"d","text":"écrite"}]'::jsonb, 'c', 'Avec « avoir », on accorde avec le COD placé avant. « Que » remplace « les lettres » (féminin pluriel) et précède le participe : on écrit « écrites ». La forme « écrit » oublierait l''accord obligatoire avec le COD antéposé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6342529d-ab03-52e3-bb50-e7423ce18380', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « Elles sont ___ très tôt ce matin. » (verbe : partir)', '[{"id":"a","text":"parti"},{"id":"b","text":"partis"},{"id":"c","text":"partie"},{"id":"d","text":"parties"}]'::jsonb, 'd', '« Partir » se conjugue avec l''auxiliaire « être » : le participe s''accorde avec le sujet. Le sujet « elles » étant féminin pluriel, on écrit « parties ». « Partis » serait le masculin pluriel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb2f62b4-2671-502b-8654-7c671340aa0a', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « Ma sœur s''est ___ ce matin. » (verbe : se réveiller, ici réfléchi)', '[{"id":"a","text":"réveillée"},{"id":"b","text":"réveillé"},{"id":"c","text":"réveillés"},{"id":"d","text":"réveillées"}]'::jsonb, 'a', 'Dans « se réveiller » sans complément qui suit, le pronom « se » est COD (elle réveille elle-même) : on accorde avec le sujet féminin singulier, donc « réveillée ». Sans accord (« réveillé »), on aurait à tort traité le pronom comme un COI.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bee7ed77-cb9b-5158-be60-9c8e508818fa', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « La maison a été ___ en 1920. » (verbe : construire)', '[{"id":"a","text":"construit"},{"id":"b","text":"construite"},{"id":"c","text":"construits"},{"id":"d","text":"construites"}]'::jsonb, 'b', 'À la voix passive, l''auxiliaire est « être » et le participe s''accorde avec le sujet. « La maison » est féminin singulier, donc « construite ». Le masculin « construit » ne s''accorderait pas avec le sujet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a45f61b-9084-5ab6-9d36-b96f0a7e0c72', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « Je les ai ___ au cinéma hier soir. » (« les » = mes cousines ; verbe : voir)', '[{"id":"a","text":"vu"},{"id":"b","text":"vus"},{"id":"c","text":"vue"},{"id":"d","text":"vues"}]'::jsonb, 'd', 'Le pronom « les » (= mes cousines, féminin pluriel) est COD et placé avant « avoir » : on accorde, donc « vues ». La forme « vu » négligerait l''accord pourtant requis par le COD antéposé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf44a16a-f85e-5126-89ca-6b6c756227bf', '130cc152-4668-5733-b59e-41b5b7ec8a1f', 'Complète : « Des gâteaux, j''en ai ___ pour la fête. » (verbe : préparer)', '[{"id":"a","text":"préparés"},{"id":"b","text":"préparé"},{"id":"c","text":"préparées"},{"id":"d","text":"préparée"}]'::jsonb, 'b', 'Quand le COD antéposé est le pronom « en », le participe reste invariable : « j''en ai préparé ». La valeur partitive de « en » bloque l''accord, même devant un nom masculin pluriel comme « des gâteaux ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('def9bed6-4853-5722-8393-bb311ead412e', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', '⭐⭐ Révision : l''accord du participe passé', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af8e2222-4b77-560c-8765-8e6bbf6b66d7', 'def9bed6-4853-5722-8393-bb311ead412e', 'Complète : « Elle s''est ___ une nouvelle robe. » (verbe : s''acheter)', '[{"id":"a","text":"acheté"},{"id":"b","text":"achetée"},{"id":"c","text":"achetés"},{"id":"d","text":"achetées"}]'::jsonb, 'a', 'Le COD « une nouvelle robe » est placé APRÈS le verbe, donc le participe reste invariable : « elle s''est acheté une robe ». Le pronom « se » n''est ici qu''un COI (à elle-même). On n''écrirait « achetée » que si le COD était antéposé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0830eb7-0e91-5da3-aaad-9da8cc493474', 'def9bed6-4853-5722-8393-bb311ead412e', 'Complète : « Ces livres se sont bien ___ cette année. » (sens passif : se vendre)', '[{"id":"a","text":"vendus"},{"id":"b","text":"vendu"},{"id":"c","text":"vendue"},{"id":"d","text":"vendues"}]'::jsonb, 'a', '« Se vendre » a ici un sens passif (les livres sont vendus) : on accorde avec le sujet. « Ces livres » est masculin pluriel, donc « vendus ». L''invariable « vendu » oublierait l''accord propre au pronominal de sens passif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44c506f0-31a1-57db-9e95-ed8ae4978cb3', 'def9bed6-4853-5722-8393-bb311ead412e', 'Complète : « Les efforts qu''il a ___ pour réussir étaient immenses. » (verbe : falloir)', '[{"id":"a","text":"fallus"},{"id":"b","text":"fallue"},{"id":"c","text":"fallu"},{"id":"d","text":"fallues"}]'::jsonb, 'c', '« Falloir » est un verbe impersonnel : son participe est toujours invariable, « fallu ». Le « il » est un sujet apparent neutre, et « les efforts » n''est pas un vrai COD qui commanderait l''accord. On n''écrit donc jamais « fallus ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3a00945-2861-55b9-8874-8320c0b1e967', 'def9bed6-4853-5722-8393-bb311ead412e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ils se sont parlés toute la soirée."},{"id":"b","text":"Elle s''est évanouie de fatigue."},{"id":"c","text":"Les fleurs qu''il a cueillies sont belles."},{"id":"d","text":"Elle s''est lavé les cheveux."}]'::jsonb, 'a', '« Ils se sont parlés » est faux : on dit « parler À quelqu''un », donc « se » est COI et le participe reste invariable (« ils se sont parlé »). Les phrases (b), (c) et (d) sont correctes : accord avec le sujet, accord avec le COD antéposé, et invariabilité devant un COD postposé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b51c9e03-780d-5704-9c18-e651c93fab70', 'def9bed6-4853-5722-8393-bb311ead412e', 'Complète : « La pièce que j''ai ___ jouer était magnifique. » (verbe : voir)', '[{"id":"a","text":"vue"},{"id":"b","text":"vu"},{"id":"c","text":"vues"},{"id":"d","text":"vus"}]'::jsonb, 'b', 'Participe + infinitif : on accorde seulement si le COD fait l''action de l''infinitif. Ici « la pièce » ne joue pas, elle est jouée : le COD ne fait pas l''action, donc le participe reste invariable, « vu ». On écrirait « vue » si le COD était l''agent (par ex. « la cantatrice que j''ai vue chanter »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a47bfc43-e374-5904-9d44-e309f9d1766b', 'def9bed6-4853-5722-8393-bb311ead412e', 'Complète : « Elles se sont ___ à la direction de l''entreprise. » (verbe : se succéder)', '[{"id":"a","text":"succédées"},{"id":"b","text":"succédé"},{"id":"c","text":"succédée"},{"id":"d","text":"succédés"}]'::jsonb, 'b', 'On dit « succéder À quelqu''un » : le pronom « se » est COI, donc le participe reste invariable, « succédé ». L''accord (« succédées ») serait une erreur classique, car aucun COD ne précède le verbe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : l''accord du participe passé', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('978042ff-ebe3-5e9e-95f8-e5bbc38c02e4', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Complète : « Les cantatrices que j''ai ___ chanter étaient exceptionnelles. » (verbe : entendre)', '[{"id":"a","text":"entendu"},{"id":"b","text":"entendue"},{"id":"c","text":"entendus"},{"id":"d","text":"entendues"}]'::jsonb, 'd', 'Participe + infinitif : on accorde si le COD antéposé FAIT l''action de l''infinitif. Ici « les cantatrices » chantent : le COD fait l''action, donc accord, « entendues ». Le piège courant est d''écrire « entendu » : on n''omet l''accord que lorsque le COD subit l''action (« les airs que j''ai entendu chanter »).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f25c20a8-f807-5f7d-b356-1b550bf9b9d2', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Complète : « Elle s''est ___ construire une villa au bord de la mer. » (verbe : se faire)', '[{"id":"a","text":"fait"},{"id":"b","text":"faite"},{"id":"c","text":"faits"},{"id":"d","text":"faites"}]'::jsonb, 'a', 'Devant un infinitif, le participe « fait » est toujours invariable : « elle s''est fait construire une villa ». « fait + infinitif » forme un bloc verbal indissociable. Le piège est d''accorder (« faite ») par réflexe avec le sujet féminin ; mais l''infinitif « construire » bloque tout accord.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34cbbe22-520f-5289-9523-02c6a99d97a7', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Elle s''est permise de partir plus tôt."},{"id":"b","text":"Les airs que j''ai entendus chanter étaient connus."},{"id":"c","text":"Elle s''est permis de partir plus tôt."},{"id":"d","text":"Des erreurs, j''en ai faites trop."}]'::jsonb, 'c', '« Elle s''est permis de partir » est correct : « permettre À quelqu''un » fait du pronom un COI, et le vrai COD (« de partir ») est postposé, donc invariable. (a) accorde à tort ; (b) accorde alors que les airs sont chantés et non chanteurs ; (d) accorde alors que le COD est « en » (toujours invariable).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d140818-dc74-5f79-9524-d5cc1d734d4c', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Complète : « Combien de fautes a-t-il ___ dans sa dictée ? » (verbe : faire)', '[{"id":"a","text":"faites"},{"id":"b","text":"faite"},{"id":"c","text":"faits"},{"id":"d","text":"fait"}]'::jsonb, 'a', '« Combien de fautes » est un COD féminin pluriel placé AVANT le verbe « avoir » : on accorde, « faites ». Attention à ne pas confondre avec le cas de « en » : ici le COD est un groupe nominal explicite antéposé, pas le pronom « en », donc l''accord est obligatoire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5be3f9a9-191d-5ca3-a8da-714656742dc3', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Complète : « Ils se sont ___ que tout irait bien. » (verbe : se dire ; « que… » = COD)', '[{"id":"a","text":"dits"},{"id":"b","text":"dit"},{"id":"c","text":"dite"},{"id":"d","text":"dites"}]'::jsonb, 'b', 'Le COD est la proposition « que tout irait bien », placée APRÈS le verbe : le participe reste invariable, « dit ». Le pronom « se » est ici un COI (ils disent cela à eux-mêmes). Accorder (« dits ») serait l''erreur typique de l''accord automatique avec le sujet.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f86855cc-1a2b-59ea-b9a7-be701b5c1dac', 'f9b0e9bd-f626-5ded-ad53-69cbdba3b8a3', 'Complète : « La chaleur qu''il a ___ cet été a battu des records. » (verbe : faire, impersonnel)', '[{"id":"a","text":"faites"},{"id":"b","text":"faite"},{"id":"c","text":"fait"},{"id":"d","text":"faits"}]'::jsonb, 'c', '« Il a fait » (chaleur, météo) est un emploi impersonnel : le participe reste invariable, « fait ». « La chaleur » n''est pas un vrai COD qui commande l''accord, c''est un sujet réel d''un verbe impersonnel. Accorder en « faite » est le piège classique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : l''accord du participe passé', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5873ec30-220c-5e15-8792-500430e9fd65', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Complète : « Les efforts qu''elle s''est ___ pour réussir l''ont épuisée. » (verbe : s''imposer)', '[{"id":"a","text":"imposés"},{"id":"b","text":"imposée"},{"id":"c","text":"imposé"},{"id":"d","text":"imposées"}]'::jsonb, 'a', 'Le COD « que » (= les efforts, masculin pluriel) est placé AVANT et c''est lui le vrai COD : on accorde, « imposés ». Le pronom « se » est COI (elle impose à elle-même). Le piège est d''accorder avec le sujet féminin (« imposée ») : ici l''accord se fait avec le COD antéposé, pas avec le sujet.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb8d709f-7929-578c-a800-c2558fcf5817', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elle s''est laissé mourir de chagrin."},{"id":"b","text":"Les ouvriers que j''ai vus travailler étaient compétents."},{"id":"c","text":"Elle s''est faite construire une maison."},{"id":"d","text":"Les robes qu''elle s''est fait faire sont superbes."}]'::jsonb, 'c', '« Elle s''est faite construire » est faux : devant un infinitif, « fait » reste invariable (« elle s''est fait construire »). Les autres sont correctes : « laissé + infinitif » est invariable (a), le COD « ouvriers » fait l''action de l''infinitif → accord (b), et « fait + infinitif » reste invariable malgré le COD antéposé (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0487d769-b1a9-56b4-89ba-8976572d5e1e', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Complète : « Des promesses, elle nous en avait ___ beaucoup. » (verbe : faire)', '[{"id":"a","text":"faites"},{"id":"b","text":"faite"},{"id":"c","text":"faits"},{"id":"d","text":"fait"}]'::jsonb, 'd', 'Le COD antéposé est le pronom « en » : le participe reste invariable, « fait ». La présence de « nous » (COI) ne change rien, et le féminin pluriel « des promesses » n''impose pas l''accord, car « en » a une valeur partitive qui le bloque. L''erreur courante est d''écrire « faites ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ad1c48-6e32-563a-ab2c-837b701f4177', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Complète : « La somme qu''il a ___ payer était exorbitante. » (verbe : faire ; « faire payer »)', '[{"id":"a","text":"faite"},{"id":"b","text":"fait"},{"id":"c","text":"faits"},{"id":"d","text":"faites"}]'::jsonb, 'b', '« faire + infinitif » (faire payer) : le participe « fait » est toujours invariable, « fait ». Même si « la somme » est un COD féminin singulier antéposé, le bloc « fait payer » interdit l''accord. Accorder en « faite » est précisément le piège tendu par la présence du COD avant le verbe.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5b90d1-33ad-5da8-a51b-73d567ebe20c', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Complète : « Ces deux théories se sont longtemps ___. » (verbe : se contredire, réciproque)', '[{"id":"a","text":"contredit"},{"id":"b","text":"contredite"},{"id":"c","text":"contredites"},{"id":"d","text":"contredits"}]'::jsonb, 'c', '« Contredire » est transitif direct (contredire quelque chose) : dans l''emploi réciproque, le pronom « se » est COD, donc on accorde avec le sujet « ces deux théories » (féminin pluriel), « contredites ». À distinguer de « se parler » ou « se succéder » (COI, invariables) : tout dépend de la construction du verbe.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79dd978d-8f11-5932-9312-063f18a6b0dd', 'c05be01f-2cf0-5f30-9a04-5d59a4e29cda', 'Complète : « Quelles décisions ont été ___ lors de la réunion ? » (verbe : prendre)', '[{"id":"a","text":"pris"},{"id":"b","text":"prise"},{"id":"c","text":"prit"},{"id":"d","text":"prises"}]'::jsonb, 'd', 'À la voix passive (« ont été prises »), le participe s''accorde avec le sujet « quelles décisions » (féminin pluriel), donc « prises ». Le masculin « pris » négligerait l''accord avec le sujet, et « prit » est une forme du passé simple, sans rapport avec le participe passé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'e13db806-78e2-5db0-80e3-3829bfb948ca', 'francais-c1', '⭐⭐ Drill : l''accord du participe passé', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5df4d9a-7862-5f25-9ff3-f72700b95560', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Complète : « Elle s''est ___ de longues heures avant l''examen. » (verbe : se préparer, réfléchi)', '[{"id":"a","text":"préparée"},{"id":"b","text":"préparé"},{"id":"c","text":"préparés"},{"id":"d","text":"préparées"}]'::jsonb, 'a', 'Sans complément qui suit, « se » est COD (elle prépare elle-même) : on accorde avec le sujet féminin singulier, « préparée ». « De longues heures » est un complément de temps, pas un COD, donc il n''empêche pas l''accord.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9daec88-f6b4-54e4-8507-86b21064e25f', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Complète : « Quelles épreuves ils ont ___ pour en arriver là ! » (verbe : traverser)', '[{"id":"a","text":"traversé"},{"id":"b","text":"traversée"},{"id":"c","text":"traversées"},{"id":"d","text":"traversés"}]'::jsonb, 'c', 'Le COD « quelles épreuves » (féminin pluriel) est placé avant l''auxiliaire « avoir » : on accorde, « traversées ». Il ne faut pas confondre avec le pronom « en » : ici le COD est un vrai groupe nominal antéposé, donc l''accord est requis.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17f81caa-c1f6-52bd-adce-4e12341f90cb', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Complète : « Les musiciens que nous avons ___ jouer nous ont enchantés. » (verbe : voir)', '[{"id":"a","text":"vu"},{"id":"b","text":"vue"},{"id":"c","text":"vus"},{"id":"d","text":"vues"}]'::jsonb, 'c', 'Participe + infinitif : « les musiciens » font l''action de jouer, donc le COD antéposé fait l''action de l''infinitif et l''on accorde, « vus » (masculin pluriel). On écrirait « vu » seulement si le COD subissait l''action, comme dans « la symphonie que nous avons vu jouer ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('594d7d45-58ba-599c-b446-f889e4326709', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Les villes que j''ai visitées étaient superbes."},{"id":"b","text":"Elle s''est offert un beau voyage."},{"id":"c","text":"Des conseils, il m''en a donnés plusieurs."},{"id":"d","text":"Elle s''est évanouie de joie."}]'::jsonb, 'c', '« Il m''en a donnés » est faux : le COD antéposé est « en », donc le participe reste invariable (« donné »). Les autres sont correctes : accord avec le COD antéposé (a), invariabilité car le COD « un voyage » suit (b), et accord au sujet d''un essentiellement pronominal (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('639a7ba3-fd80-56f4-b129-4ab9187e1a36', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Complète : « La décision qu''il a ___ prendre l''a soulagé. » (verbe : laisser ; « laisser prendre »)', '[{"id":"a","text":"laissée"},{"id":"b","text":"laissés"},{"id":"c","text":"laissées"},{"id":"d","text":"laissé"}]'::jsonb, 'd', 'Suivant les rectifications de 1990, « laissé + infinitif » reste invariable : « la décision qu''il a laissé prendre ». Le bloc « laissé prendre » empêche l''accord, même avec le COD féminin « la décision » placé avant. Le piège est d''accorder en « laissée ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('810c4952-f53f-5622-a213-4f3571b7d23b', '84de3c27-76e3-5ce1-befd-cbb5498e9eb1', 'Complète : « Ils se sont ___ en silence avant la cérémonie. » (verbe : se regarder, réciproque)', '[{"id":"a","text":"regardé"},{"id":"b","text":"regardée"},{"id":"c","text":"regardées"},{"id":"d","text":"regardés"}]'::jsonb, 'd', '« Regarder » est transitif direct (regarder quelqu''un) : dans l''emploi réciproque, « se » est COD, donc on accorde avec le sujet « ils » (masculin pluriel), « regardés ». À l''inverse de « se parler » (COI, invariable), tout dépend de la construction directe ou indirecte du verbe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d43edbc-5b05-5c13-9235-ee8b24fc848d', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'Complétez : « Je crois qu''il ___ demain. » (action postérieure, principale au présent)', '[{"id":"a","text":"viendra"},{"id":"b","text":"viendrait"},{"id":"c","text":"venait"},{"id":"d","text":"vienne"}]'::jsonb, 'a', 'La principale est au présent (« je crois ») et l''action est postérieure : on emploie le futur simple, « viendra ». Le conditionnel « viendrait » serait le futur du passé (après une principale au passé), « venait » exprime le simultané au passé, et « vienne » est un subjonctif, non appelé ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('839117d8-6365-5c93-816a-fb2268ea35eb', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'Complétez : « Je croyais qu''il ___ malade. » (action simultanée, principale au passé)', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"sera"},{"id":"d","text":"serait"}]'::jsonb, 'b', 'Avec une principale au passé (« je croyais »), la simultanéité s''exprime à l''imparfait : « était ». Le présent « est » et le futur « sera » supposeraient une principale au présent ; « serait » (conditionnel) exprimerait la postériorité, pas la simultanéité.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d128e874-e35c-5082-a553-1ab9c957e300', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'Complétez : « Il a annoncé qu''il ___ à la réunion. » (futur vu depuis le passé)', '[{"id":"a","text":"participera"},{"id":"b","text":"participe"},{"id":"c","text":"participerait"},{"id":"d","text":"participait"}]'::jsonb, 'c', 'Après un verbe introducteur au passé, la postériorité se rend par le conditionnel présent, le « futur du passé » : « participerait ». Le futur « participera » se garde après un présent, « participe » est simultané au présent, « participait » est simultané au passé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba7c6047-b853-5a79-9a8b-be8152dc8752', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'Complétez : « Je veux qu''il ___ tout de suite. » (subjonctif, action postérieure)', '[{"id":"a","text":"part"},{"id":"b","text":"parte"},{"id":"c","text":"partira"},{"id":"d","text":"partait"}]'::jsonb, 'b', 'Le verbe « vouloir » impose le subjonctif. Pour une action simultanée ou postérieure, on emploie le subjonctif présent : « qu''il parte ». « Part » est l''indicatif présent, « partira » le futur de l''indicatif, « partait » l''imparfait de l''indicatif — aucun n''est un subjonctif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9286245b-ab8b-5a41-a25a-5038f02ea50e', 'c03f470e-d4cd-59f0-8e6a-633a5b3e82cb', 'Dans « J''étais heureux qu''elle soit venue », à quoi sert le subjonctif passé « soit venue » ?', '[{"id":"a","text":"À marquer l''antériorité de l''action par rapport à la principale"},{"id":"b","text":"À marquer la simultanéité des deux actions"},{"id":"c","text":"À marquer la postériorité de l''action"},{"id":"d","text":"À exprimer une hypothèse irréelle"}]'::jsonb, 'a', 'Le subjonctif passé (« soit venue ») exprime une action antérieure à celle de la principale : sa venue précède le bonheur ressenti. La simultanéité/postériorité emploierait le subjonctif présent (« vienne »), et l''irréel relève du conditionnel, non du subjonctif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('840343dc-430a-5e84-a0bc-d11801903d90', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', '⭐ Entraînement : la concordance des temps', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d5f2a84-1485-5999-a04c-55cca0be6f82', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Elle dit qu''elle ___ fatiguée. » (simultané, principale au présent)', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"sera"},{"id":"d","text":"serait"}]'::jsonb, 'a', 'Principale au présent (« elle dit ») + simultanéité : on garde le présent dans la subordonnée, « est ». L''imparfait « était » s''emploierait après un passé, et le conditionnel « serait » exprimerait une postériorité du passé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53d28307-a609-5fa8-94d0-f7fc99e4c7e2', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Il pense qu''ils ___ hier. » (antériorité, principale au présent)', '[{"id":"a","text":"partiront"},{"id":"b","text":"partaient"},{"id":"c","text":"sont partis"},{"id":"d","text":"étaient partis"}]'::jsonb, 'c', 'Avec une principale au présent (« il pense »), l''antériorité se rend au passé composé : « sont partis ». Le plus-que-parfait « étaient partis » appartiendrait à une principale au passé, le futur « partiront » et l''imparfait « partaient » ne marquent pas l''antériorité accomplie.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48e54a10-1db0-5a46-bbc1-9bfe0cad616f', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Je savais qu''elle ___ la vérité. » (simultané, principale au passé)', '[{"id":"a","text":"connaît"},{"id":"b","text":"connaissait"},{"id":"c","text":"connaîtra"},{"id":"d","text":"connaisse"}]'::jsonb, 'b', 'Après « je savais » (passé) et pour une action simultanée, on emploie l''imparfait : « connaissait ». Le présent « connaît » et le futur « connaîtra » supposeraient un présent en principale ; « connaisse » est un subjonctif que « savoir » affirmatif n''appelle pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a8ac4e1-c4a1-5904-948c-44089195d1d4', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Tu m''avais promis que tu ___. » (postériorité, principale au passé)', '[{"id":"a","text":"reviens"},{"id":"b","text":"revenais"},{"id":"c","text":"reviendras"},{"id":"d","text":"reviendrais"}]'::jsonb, 'd', 'Après une principale au passé (« tu m''avais promis »), la postériorité se rend par le conditionnel présent, futur du passé : « reviendrais ». Le futur « reviendras » se garde après un présent ; « reviens » et « revenais » expriment le simultané, non l''à-venir.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('879a36c7-6eb5-56df-bdc8-61da97b08120', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Je souhaite qu''il ___ heureux. » (subjonctif, action simultanée/postérieure)', '[{"id":"a","text":"est"},{"id":"b","text":"sera"},{"id":"c","text":"soit"},{"id":"d","text":"était"}]'::jsonb, 'c', '« Souhaiter que » impose le subjonctif ; pour le simultané/postérieur, c''est le subjonctif présent : « soit ». « Est » et « était » sont des indicatifs, et le subjonctif ne possède pas de futur : « sera » est donc exclu.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4caef19-4bb5-5258-abb6-f5c5dec91dd2', '840343dc-430a-5e84-a0bc-d11801903d90', 'Complétez : « Il a déclaré qu''il ___ déçu de l''accueil. » (simultané, principale au passé)', '[{"id":"a","text":"est"},{"id":"b","text":"était"},{"id":"c","text":"serait"},{"id":"d","text":"soit"}]'::jsonb, 'b', '« Il a déclaré » est au passé ; pour le simultané on emploie l''imparfait : « était ». Le présent « est » exigerait une principale au présent, le conditionnel « serait » marquerait la postériorité, et « soit » (subjonctif) n''est pas appelé par « déclarer » affirmatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4220d64-dd32-5d61-95fe-d93556b3d310', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', '⭐⭐ Révision : la concordance des temps', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f412d47b-31f2-5097-a336-583102dd19f9', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Complétez : « Nous espérions qu''il ___ avant la nuit. » (postériorité, principale au passé)', '[{"id":"a","text":"arrivera"},{"id":"b","text":"arriverait"},{"id":"c","text":"arrive"},{"id":"d","text":"arrivait"}]'::jsonb, 'b', '« Nous espérions » est au passé ; la postériorité s''exprime alors par le conditionnel présent, futur du passé : « arriverait ». Le futur « arrivera » se garde après un présent ; « arrive » et « arrivait » marquent le simultané.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fc856bc-92bb-5695-bcf7-64d95d33199b', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Complétez : « Le guide a expliqué que le musée ___ la veille. » (antériorité, principale au passé)', '[{"id":"a","text":"avait fermé"},{"id":"b","text":"ferme"},{"id":"c","text":"a fermé"},{"id":"d","text":"fermerait"}]'::jsonb, 'a', 'Après « a expliqué » (passé), l''antériorité se rend par le plus-que-parfait : « avait fermé ». Le passé composé « a fermé » correspondrait à une principale au présent ; « ferme » est simultané au présent et « fermerait » exprime la postériorité.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6f79d64-1c06-5ed6-bf49-6adce4da4f8a', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Complétez : « J''étais content qu''elle ___ son examen. » (subjonctif, action antérieure)', '[{"id":"a","text":"réussisse"},{"id":"b","text":"a réussi"},{"id":"c","text":"ait réussi"},{"id":"d","text":"réussissait"}]'::jsonb, 'c', '« Être content que » impose le subjonctif ; l''action étant antérieure (la réussite précède le contentement), on emploie le subjonctif passé : « ait réussi ». « Réussisse » (subjonctif présent) marquerait le simultané ; « a réussi » et « réussissait » sont des indicatifs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98d90e1b-0e63-50c2-9889-a11b9c23af46', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Complétez : « Je voulais qu''il ___ avec nous au cinéma. » (subjonctif, principale au passé)', '[{"id":"a","text":"venait"},{"id":"b","text":"vienne"},{"id":"c","text":"viendrait"},{"id":"d","text":"viendra"}]'::jsonb, 'b', 'En français courant, le subjonctif présent se maintient même après une principale au passé : « Je voulais qu''il vienne ». « Venait » (imparfait de l''indicatif) calque à tort la concordance de l''indicatif ; « viendrait » et « viendra » sont des indicatifs et ne conviennent pas après « vouloir que ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5353871c-d393-5f03-9123-becde94f6dba', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Identifiez la phrase CORRECTE.', '[{"id":"a","text":"Il a dit qu''il viendra demain."},{"id":"b","text":"Il a dit qu''il vient le lendemain."},{"id":"c","text":"Il a dit qu''il venait demain."},{"id":"d","text":"Il a dit qu''il viendrait le lendemain."}]'::jsonb, 'd', 'Après « il a dit » (passé), la postériorité demande le conditionnel (« viendrait »), et le marqueur « demain » devient « le lendemain ». En (a) le futur ne s''accorde pas avec le passé ; en (c) le présent est fautif ; en (d) « venait » ne marque pas la postériorité et « demain » n''est pas reporté.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('116aa368-5294-587b-8c9a-fe07e0f02611', 'e4220d64-dd32-5d61-95fe-d93556b3d310', 'Complétez : « Elle remarqua que le ciel ___ depuis l''aube. » (antériorité, principale au passé simple)', '[{"id":"a","text":"s''éclaircit"},{"id":"b","text":"s''éclaircissait"},{"id":"c","text":"s''était éclairci"},{"id":"d","text":"s''éclaircirait"}]'::jsonb, 'c', '« Remarqua » est un passé simple (principale au passé) ; l''action de la subordonnée, achevée avant ce moment, se met au plus-que-parfait : « s''était éclairci ». L''imparfait « s''éclaircissait » marquerait un processus simultané, et le conditionnel « s''éclaircirait » une postériorité.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : la concordance des temps', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc9aed38-02db-5074-bac1-3bbdde09ac00', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Je crois qu''il est venu hier."},{"id":"b","text":"Je croyais qu''il était venu la veille."},{"id":"c","text":"Je croyais qu''il vient demain."},{"id":"d","text":"Je crois qu''il viendra demain."}]'::jsonb, 'c', 'L''erreur est en (c) : après « je croyais » (passé), on ne peut employer ni le présent « vient » ni « demain ». Il faudrait « qu''il viendrait le lendemain ». (a), (b) et (d) respectent la concordance (présent→passé composé, passé→plus-que-parfait, présent→futur).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c900576f-9a1f-5e51-bf62-792410236833', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Complétez : « Le ministre avait assuré que la réforme ___ avant la fin de l''année. » (futur antérieur du passé)', '[{"id":"a","text":"serait achevée"},{"id":"b","text":"aurait été achevée"},{"id":"c","text":"sera achevée"},{"id":"d","text":"était achevée"}]'::jsonb, 'b', 'L''action est future par rapport au passé ET présentée comme achevée avant un repère (« la fin de l''année ») : c''est le conditionnel passé, futur antérieur du passé, « aurait été achevée ». Le conditionnel présent « serait achevée » exprimerait un futur simple du passé sans valeur d''accomplissement ; « sera » et « était » ne s''accordent pas avec le passé de la principale.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b61301dc-969d-568c-a61c-4f68a0aa6571', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Complétez : « J''attendais qu''il ___ pour commencer. » (subjonctif, action postérieure, principale au passé)', '[{"id":"a","text":"arrive"},{"id":"b","text":"arrivait"},{"id":"c","text":"arriverait"},{"id":"d","text":"arrivera"}]'::jsonb, 'a', '« Attendre que » impose le subjonctif. En français courant, le subjonctif présent se maintient même après un passé, pour le simultané comme le postérieur : « qu''il arrive ». « Arrivait » et « arrivera » sont des indicatifs, « arriverait » un conditionnel : aucun n''est le subjonctif requis.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c34c8b4a-ccc0-567b-b7c1-e3a124adbabb', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Quelle transformation au discours indirect passé est CORRECTE ? Départ : « Il déclare : “Je terminerai dès qu''ils seront partis.” »', '[{"id":"a","text":"Il déclara qu''il terminera dès qu''ils seraient partis."},{"id":"b","text":"Il déclara qu''il terminerait dès qu''ils seraient partis."},{"id":"c","text":"Il déclara qu''il terminerait dès qu''ils sont partis."},{"id":"d","text":"Il déclara qu''il termine dès qu''ils étaient partis."}]'::jsonb, 'b', 'Après « il déclara » (passé), le futur « terminerai » devient conditionnel présent (« terminerait ») et le futur antérieur « seront partis » devient conditionnel passé (« seraient partis »). En (a) le premier futur n''est pas accordé ; en (c) et (d) la subordonnée temporelle n''est pas reculée correctement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3897316-fcee-57a7-943b-29c32ef8cd42', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Trouvez la phrase INCORRECTE.', '[{"id":"a","text":"Il était surpris que nous soyons partis si tôt."},{"id":"b","text":"Il était surpris que nous partions si tôt."},{"id":"c","text":"Il était surpris que nous étions partis si tôt."},{"id":"d","text":"Il craignait que nous ne soyons en retard."}]'::jsonb, 'c', 'L''erreur est en (c) : « être surpris que » appelle le subjonctif, donc « que nous soyons partis » (subjonctif passé), jamais l''indicatif « étions partis ». (a) emploie correctement le subjonctif passé (antériorité), (b) le subjonctif présent, (d) un subjonctif présent avec « ne » explétif — tous corrects.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dc3e64d-59a5-52df-904e-6d70d45953ea', 'eda638c1-3c6d-52e0-8b7c-9072d54812a9', 'Complétez : « On nous avait garanti que tout ___ réglé avant notre arrivée. » (antériorité par rapport à un futur du passé)', '[{"id":"a","text":"sera"},{"id":"b","text":"serait"},{"id":"c","text":"avait été"},{"id":"d","text":"aurait été"}]'::jsonb, 'd', 'L''action (« réglé ») est future par rapport au passé (« on avait garanti ») mais antérieure à un autre repère futur (« notre arrivée ») : c''est le conditionnel passé, « aurait été ». Le conditionnel présent « serait » manquerait la valeur d''accomplissement ; « sera » ne s''accorde pas au passé et « avait été » (plus-que-parfait) n''exprime pas l''à-venir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ab418311-2294-5802-878c-c8084d4f34ca', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : la concordance des temps', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4763290-850e-52ef-a473-cbb36502b007', 'ab418311-2294-5802-878c-c8084d4f34ca', 'Dans la phrase littéraire « Il fallait qu''elle partît sur-le-champ », quelle est la nature de « partît » ?', '[{"id":"a","text":"Un subjonctif imparfait (registre soutenu)"},{"id":"b","text":"Un passé simple de l''indicatif"},{"id":"c","text":"Un imparfait de l''indicatif"},{"id":"d","text":"Une faute d''orthographe pour « partit »"}]'::jsonb, 'a', '« Partît », avec accent circonflexe à la 3e personne, est un subjonctif imparfait, employé en style soutenu après une principale au passé (« il fallait que »). Le passé simple serait « partit » (sans accent), l''imparfait de l''indicatif « partait » ; ce n''est donc ni une faute ni un indicatif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b508c52-4129-58df-aad8-39afac3bb5db', 'ab418311-2294-5802-878c-c8084d4f34ca', 'En français COURANT, comment exprime-t-on « Il fallait qu''elle partît » sans recourir au registre littéraire ?', '[{"id":"a","text":"Il fallait qu''elle parte."},{"id":"b","text":"Il fallait qu''elle partait."},{"id":"c","text":"Il fallait qu''elle partirait."},{"id":"d","text":"Il fallait qu''elle est partie."}]'::jsonb, 'a', 'En français courant, le subjonctif imparfait littéraire « partît » se rend par le subjonctif présent « parte », maintenu même après un passé : « Il fallait qu''elle parte ». « Partait » est un imparfait de l''indicatif, « partirait » un conditionnel, « est partie » un indicatif : « falloir que » exige le subjonctif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfd4795b-f2ac-5743-b47f-e65b0f1700f6', 'ab418311-2294-5802-878c-c8084d4f34ca', 'Repérez la phrase où le subjonctif imparfait est MAL identifié.', '[{"id":"a","text":"« qu''il vînt » est un subjonctif imparfait."},{"id":"b","text":"« qu''il fût venu » est un plus-que-parfait du subjonctif."},{"id":"c","text":"« qu''il vint » (sans accent) est un subjonctif imparfait."},{"id":"d","text":"« qu''il eût fini » est un plus-que-parfait du subjonctif."}]'::jsonb, 'c', '« Il vint » sans accent est un passé simple de l''indicatif, non un subjonctif imparfait : ce dernier porte l''accent circonflexe (« qu''il vînt »). Les énoncés (a), (b) et (d) identifient correctement le subjonctif imparfait et le plus-que-parfait du subjonctif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56f89e54-104a-5825-b0f5-d21f8135e7a9', 'ab418311-2294-5802-878c-c8084d4f34ca', 'Complétez correctement au discours indirect passé : « Elle pensa qu''elle ___ tout ce qu''elle ___ promis. » (postériorité achevée, puis antériorité)', '[{"id":"a","text":"tiendrait / avait"},{"id":"b","text":"tiendra / a"},{"id":"c","text":"tenait / avait"},{"id":"d","text":"aurait tenu / avait"}]'::jsonb, 'd', '« Aurait tenu » est le conditionnel passé (futur achevé du passé) ; « avait promis » est le plus-que-parfait, marquant l''antériorité par rapport à « pensa ». « Tiendrait » manquerait l''accomplissement ; « tiendra / a » ne s''accorde pas au passé ; « tenait » exprime un simultané, non un futur achevé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e23985af-fef5-5e33-a666-ed0b54098bbb', 'ab418311-2294-5802-878c-c8084d4f34ca', 'Trouvez la phrase INCORRECTE en français courant.', '[{"id":"a","text":"Je regrettais qu''il fût absent."},{"id":"b","text":"Je regrette qu''il soit absent."},{"id":"c","text":"Je regrettais qu''il était absent."},{"id":"d","text":"Je regrettais qu''il soit absent."}]'::jsonb, 'c', 'L''erreur est en (c) : « regretter que » impose le subjonctif, jamais l''indicatif « était ». En français courant on dit « qu''il soit absent » (d) ; (b) est correct au présent ; (a) emploie le subjonctif imparfait « fût », correct mais réservé au registre soutenu. Seul (c) mêle à tort l''indicatif.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45f17cda-50d8-56e0-a7b9-a70e732a495c', 'ab418311-2294-5802-878c-c8084d4f34ca', 'Complétez : « Le témoin affirma qu''il ___ l''accusé la nuit où le crime ___ commis. » (simultané puis antériorité, principale au passé)', '[{"id":"a","text":"voyait / était"},{"id":"b","text":"avait vu / avait été"},{"id":"c","text":"a vu / a été"},{"id":"d","text":"verrait / serait"}]'::jsonb, 'b', 'Après « affirma » (passé), l''action vue et le crime sont antérieurs : les deux se mettent au plus-que-parfait, « avait vu » et « avait été commis ». L''imparfait « voyait / était » marquerait une simple toile de fond non achevée ; le passé composé « a vu / a été » ne s''accorde pas au passé simple ; le conditionnel « verrait / serait » exprimerait une postériorité.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'de61a179-cc8c-5204-b3b4-89666723fdcb', 'francais-c1', '⭐⭐ Drill : la concordance des temps', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67490c81-7522-5678-9494-8eafe22dd6f6', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Complétez : « Nous savons qu''elle ___ son rapport la semaine dernière. » (antériorité, principale au présent)', '[{"id":"a","text":"a rendu"},{"id":"b","text":"avait rendu"},{"id":"c","text":"rendra"},{"id":"d","text":"rendait"}]'::jsonb, 'a', 'Principale au présent (« nous savons ») + antériorité accomplie : passé composé, « a rendu ». Le plus-que-parfait « avait rendu » appartiendrait à une principale au passé ; « rendra » est un futur et « rendait » un imparfait, qui ne marquent pas l''antériorité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('100ab80c-c333-5523-9b3c-27b5d9130875', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Complétez : « Il pensait que la pluie ___ bientôt. » (postériorité, principale au passé)', '[{"id":"a","text":"cessera"},{"id":"b","text":"cesserait"},{"id":"c","text":"cesse"},{"id":"d","text":"cessait"}]'::jsonb, 'b', '« Il pensait » est au passé ; la postériorité se rend par le conditionnel présent, futur du passé : « cesserait ». Le futur « cessera » se garde après un présent ; « cesse » et « cessait » expriment le simultané, pas l''à-venir.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba58ccdd-602f-5861-adca-1b619c969c66', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Complétez : « Je doute qu''il ___ déjà terminé son travail. » (subjonctif, action antérieure)', '[{"id":"a","text":"a"},{"id":"b","text":"aura"},{"id":"c","text":"ait"},{"id":"d","text":"avait"}]'::jsonb, 'c', '« Douter que » impose le subjonctif ; l''action étant antérieure (« déjà terminé »), c''est le subjonctif passé, dont l''auxiliaire est « ait » : « qu''il ait terminé ». « A » est l''indicatif présent, « aura » le futur, « avait » l''imparfait — aucun n''est un subjonctif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4fd74d9-2728-5e59-b387-68118bbf2662', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Identifiez la phrase CORRECTE.', '[{"id":"a","text":"Elle voulait que je lui disais la vérité."},{"id":"b","text":"Elle voulait que je lui dise la vérité."},{"id":"c","text":"Elle voulait que je lui dirais la vérité."},{"id":"d","text":"Elle voulait que je lui dirai la vérité."}]'::jsonb, 'b', '« Vouloir que » exige le subjonctif, maintenu au présent même après un passé : « que je lui dise ». « Disais » est un imparfait de l''indicatif (calque fautif de la concordance indicative) ; « dirais » et « dirai » sont des indicatifs et ne conviennent pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d47fc8cf-9712-5715-b55b-fec749d77771', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Complétez : « Il jura qu''il ___ innocent et qu''il ne ___ jamais menti. » (simultané puis antériorité, principale au passé)', '[{"id":"a","text":"est / a"},{"id":"b","text":"serait / aurait"},{"id":"c","text":"était / a"},{"id":"d","text":"était / avait"}]'::jsonb, 'd', 'Après « il jura » (passé simple), le simultané se met à l''imparfait (« était ») et l''antériorité au plus-que-parfait (« avait menti »). Le présent « est / a » ne s''accorde pas au passé ; le conditionnel « serait / aurait » exprimerait une postériorité, non l''état présent et le fait antérieur.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('682674c6-cb1e-547e-af43-9b870a74149b', 'ab01ae46-3fa6-5479-bfb4-30ca3f74a5c6', 'Dans la phrase soutenue « Je craignais qu''il n''eût oublié », à quel mode et temps est « eût oublié » ?', '[{"id":"a","text":"Plus-que-parfait du subjonctif (registre littéraire)"},{"id":"b","text":"Conditionnel passé"},{"id":"c","text":"Plus-que-parfait de l''indicatif"},{"id":"d","text":"Subjonctif passé courant"}]'::jsonb, 'a', '« Eût oublié » (auxiliaire au subjonctif imparfait + participe) est un plus-que-parfait du subjonctif, employé en style soutenu après un passé ; en français courant on dirait « qu''il ait oublié ». Le conditionnel passé serait « aurait oublié », et le plus-que-parfait de l''indicatif « avait oublié ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('377eaa50-cfae-5f4f-b148-279185a8baaa', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d620c25b-5c84-55eb-9a05-8cb695c819b7', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'Pour mettre en relief le SUJET de la phrase « Marie a téléphoné », on écrit :', '[{"id":"a","text":"C''est Marie qu''a téléphoné."},{"id":"b","text":"C''est Marie qui a téléphoné."},{"id":"c","text":"C''est Marie dont a téléphoné."},{"id":"d","text":"Ce que Marie a téléphoné."}]'::jsonb, 'b', 'On met le sujet en relief avec « c''est … qui ». Comme Marie est le sujet (elle fait l''action de téléphoner), le relatif est « qui » : C''est Marie qui a téléphoné. « que » (a) servirait pour un complément, pas pour le sujet ; « dont » et « ce que » sont ici hors construction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1d1afbb-5d9c-5012-9bdc-3c05bb2a26a8', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'Complète : « C''est ce roman ___ je préfère. »', '[{"id":"a","text":"qui"},{"id":"b","text":"dont"},{"id":"c","text":"que"},{"id":"d","text":"qu''il"}]'::jsonb, 'c', '« ce roman » est le COD de « préférer » (je préfère quoi ? ce roman). On met un COD en relief avec « c''est … que » : C''est ce roman que je préfère. « qui » s''emploie pour le sujet ; « dont » pour un complément en « de » ; « qu''il » introduirait un autre sujet.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc7f129e-8ba9-50c2-8b99-7925569a0b5d', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'Quelle phrase met correctement en relief le LIEU « à Paris » ?', '[{"id":"a","text":"C''est à Paris qu''il habite."},{"id":"b","text":"C''est à Paris qui il habite."},{"id":"c","text":"C''est à Paris dont il habite."},{"id":"d","text":"Ce qui à Paris il habite."}]'::jsonb, 'a', 'Un complément de lieu se met en relief avec « c''est … que » : C''est à Paris qu''il habite (« que » s''élide en « qu'' » devant la voyelle). « qui » est réservé au sujet ; « dont » remplace un complément en « de » ; la forme (d) est agrammaticale.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b364268f-1c67-5c31-acc4-f8550f10296a', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'Complète : « ___ je veux, c''est partir en voyage. »', '[{"id":"a","text":"Ce qui"},{"id":"b","text":"Ce dont"},{"id":"c","text":"Ce que"},{"id":"d","text":"C''est que"}]'::jsonb, 'c', '« vouloir » se construit avec un COD (je veux quoi ?). On emploie donc « ce que … c''est » : Ce que je veux, c''est partir en voyage. « ce qui » servirait pour un sujet ; « ce dont » pour un verbe en « de » (avoir besoin de…) ; « c''est que » ne convient pas en tête.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e7f4297-74e1-5f0d-a0c8-52fcd77bf2c5', '377eaa50-cfae-5f4f-b148-279185a8baaa', 'Complète l''accord : « C''est moi qui ___ responsable du projet. »', '[{"id":"a","text":"est"},{"id":"b","text":"suis"},{"id":"c","text":"es"},{"id":"d","text":"sont"}]'::jsonb, 'b', 'Après « c''est moi qui », le verbe s''accorde avec « moi » (1ʳᵉ personne du singulier) : C''est moi qui suis responsable. « est » (3ᵉ pers., piège fréquent) est fautif ; « es » est la 2ᵉ personne ; « sont » la 3ᵉ du pluriel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', '⭐ Entraînement : la mise en relief', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec9cc806-5fb1-5cc6-bb34-e144d29f39a7', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Complète pour mettre en relief le sujet : « ___ Léa qui a trouvé la solution. »', '[{"id":"a","text":"C''est"},{"id":"b","text":"Ce qui"},{"id":"c","text":"Ce dont"},{"id":"d","text":"C''est que"}]'::jsonb, 'a', 'Pour mettre le sujet en relief, on utilise « c''est … qui » : C''est Léa qui a trouvé la solution. « Ce qui » et « ce dont » servent aux tournures « ce … c''est » ; « c''est que » n''introduit pas un nom isolé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d12526e5-a8b9-56dc-b9fc-ab06bf83a03d', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Complète : « C''est ce livre ___ je cherchais depuis longtemps. »', '[{"id":"a","text":"qui"},{"id":"b","text":"que"},{"id":"c","text":"dont"},{"id":"d","text":"où"}]'::jsonb, 'b', '« ce livre » est le COD de « chercher » (je cherchais quoi ?). On met un COD en relief avec « c''est … que » : C''est ce livre que je cherchais. « qui » est réservé au sujet ; « dont » à un complément en « de » ; « où » au lieu ou au temps.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('476b8774-769c-5958-8ad3-b9cd19e293c3', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Choisis la tournure correcte pour mettre en relief « la musique » (sujet de « intéresser ») :', '[{"id":"a","text":"Ce que m''intéresse, c''est la musique."},{"id":"b","text":"Ce dont m''intéresse, c''est la musique."},{"id":"c","text":"Ce qui m''intéresse, c''est la musique."},{"id":"d","text":"C''est la musique qu''intéresse."}]'::jsonb, 'c', '« intéresser » a un sujet (qu''est-ce qui m''intéresse ?). On emploie donc « ce qui … c''est » : Ce qui m''intéresse, c''est la musique. « ce que » s''utiliserait pour un COD, « ce dont » pour un verbe en « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e71c8ec1-aeb4-562c-bb8f-5a8af7347b2e', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Quelle phrase met correctement en relief le complément de temps « demain » ?', '[{"id":"a","text":"C''est demain qui ça commence."},{"id":"b","text":"C''est demain que ça commence."},{"id":"c","text":"Ce qui demain ça commence."},{"id":"d","text":"C''est demain dont ça commence."}]'::jsonb, 'b', 'Un complément de temps se met en relief avec « c''est … que » : C''est demain que ça commence. « qui » est réservé au sujet ; « dont » à un complément en « de » ; la forme (c) est agrammaticale.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('309fd65f-0567-59ee-9d60-66d6ec4678f6', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Complète l''accord : « C''est nous qui ___ gagné le tournoi. »', '[{"id":"a","text":"avons"},{"id":"b","text":"ont"},{"id":"c","text":"avez"},{"id":"d","text":"a"}]'::jsonb, 'a', 'Après « c''est nous qui », le verbe s''accorde avec « nous » (1ʳᵉ personne du pluriel) : C''est nous qui avons gagné. « ont » (3ᵉ pers.) est le piège classique ; « avez » est la 2ᵉ pers. ; « a » le singulier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9499efe4-22a3-5c65-a7fd-6b02cff47798', 'ea3e2b00-d9dd-5854-8e4b-73a31323ac7f', 'Dans la dislocation « Ce film, je ___ ai adoré », quel pronom reprend « ce film » (COD) ?', '[{"id":"a","text":"lui"},{"id":"b","text":"y"},{"id":"c","text":"en"},{"id":"d","text":"l''"}]'::jsonb, 'd', '« ce film » est le COD de « adorer » ; un COD se reprend par « le/la/les » (ici « l'' » devant voyelle) : Ce film, je l''ai adoré. « lui » reprend un COI (à qqn), « en » un complément en « de », « y » un complément en « à »/un lieu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('952990fe-89a3-54fa-85fe-f7af9bd272b7', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', '⭐⭐ Révision : la mise en relief', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca5e542a-6c71-54d4-a6b0-1390ca347d6b', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Complète : « ___ j''ai besoin, c''est d''un peu de calme. »', '[{"id":"a","text":"Ce que"},{"id":"b","text":"Ce dont"},{"id":"c","text":"Ce qui"},{"id":"d","text":"Ce à quoi"}]'::jsonb, 'b', '« avoir besoin » se construit avec « de ». La tournure de mise en relief reprend cette préposition par « ce dont … c''est » : Ce dont j''ai besoin, c''est de calme. « ce que » (COD) est la faute la plus fréquente ; « ce qui » sert au sujet ; « ce à quoi » conviendrait à un verbe en « à ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79533cbf-0735-52af-94d1-b70177385323', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Complète l''accord : « C''est vous qui ___ raison sur ce point. »', '[{"id":"a","text":"a"},{"id":"b","text":"ont"},{"id":"c","text":"avez"},{"id":"d","text":"avons"}]'::jsonb, 'c', 'Après « c''est vous qui », le verbe s''accorde avec « vous » (2ᵉ personne du pluriel) : C''est vous qui avez raison. « a » et « ont » (3ᵉ pers.) sont les pièges ; « avons » est la 1ʳᵉ personne du pluriel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e7236cd-271b-5e58-99a1-b5a9b2955ab2', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Reprends correctement le complément disloqué : « À mes voisins, je ___ fais entièrement confiance. »', '[{"id":"a","text":"les"},{"id":"b","text":"leur"},{"id":"c","text":"y"},{"id":"d","text":"en"}]'::jsonb, 'b', '« faire confiance à qqn » est un COI (à + personne) ; il se reprend par « lui/leur ». Avec un pluriel : À mes voisins, je leur fais confiance. « les » reprend un COD, « y » un complément en « à »+chose/lieu, « en » un complément en « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a547c4a-472d-5148-a982-54e188a3b176', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Quelle phrase met correctement en relief « partir » avec une tournure en « ce que » ?', '[{"id":"a","text":"Ce qui je veux, c''est partir."},{"id":"b","text":"Ce dont je veux, c''est partir."},{"id":"c","text":"C''est partir dont je veux."},{"id":"d","text":"Ce que je veux, c''est partir."}]'::jsonb, 'd', '« vouloir » a un COD ; on emploie « ce que … c''est » : Ce que je veux, c''est partir. « ce qui » sert au sujet, « ce dont » à un verbe en « de » ; la forme (c) est agrammaticale (vouloir ne se construit pas avec « dont »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70920fd7-84bf-511d-bb5b-24047626c7e4', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"C''est toi qui as oublié les clés."},{"id":"b","text":"C''est moi qui suis arrivé le premier."},{"id":"c","text":"C''est nous qui ont préparé le repas."},{"id":"d","text":"C''est vous qui avez raison."}]'::jsonb, 'c', 'La phrase fautive est (c) : après « c''est nous qui », le verbe doit s''accorder à la 1ʳᵉ personne du pluriel (« avons »), pas à la 3ᵉ. Il faut dire : C''est nous qui avons préparé le repas. Les phrases (a), (b) et (d) respectent bien l''accord avec toi/moi/vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90384d86-a4ab-5f77-9eb6-afd750ab9727', '952990fe-89a3-54fa-85fe-f7af9bd272b7', 'Complète : « C''est à ce résultat ___ nous voulons aboutir. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"à quoi"}]'::jsonb, 'a', 'Même quand l''élément en relief contient déjà la préposition (« à ce résultat »), l''extraction se fait avec « c''est … que » : C''est à ce résultat que nous voulons aboutir. « qui » est réservé au sujet ; « dont » et « à quoi » feraient double emploi avec la préposition déjà présente.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25992876-cf57-56d6-b2ef-2bd08ed384da', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : la mise en relief', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb8e18e9-bd45-5eb3-979e-1e5d8a2a78e2', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ce dont je rêve, c''est d''un long voyage."},{"id":"b","text":"Ce que j''ai besoin, c''est de repos."},{"id":"c","text":"Ce qui m''inquiète, c''est son silence."},{"id":"d","text":"Ce que je préfère, c''est lire le soir."}]'::jsonb, 'b', 'La phrase fautive est (b) : « avoir besoin » se construit avec « de », donc il faut « ce dont » et non « ce que ». Il faut dire : Ce dont j''ai besoin, c''est de repos. En (a) « rêver de » → ce dont ✓ ; (c) « inquiéter » a un sujet → ce qui ✓ ; (d) « préférer » a un COD → ce que ✓.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f52d071-7de1-5a82-a051-69447282af8f', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Mets en relief le sujet « ses parents » dans : « Ses parents ont financé ses études. »', '[{"id":"a","text":"C''est ses parents qu''ont financé ses études."},{"id":"b","text":"Ce sont ses parents qu''ont financé ses études."},{"id":"c","text":"Ce dont ses parents ont financé, ce sont ses études."},{"id":"d","text":"Ce sont ses parents qui ont financé ses études."}]'::jsonb, 'd', 'Avec un élément pluriel, « c''est » devient « ce sont », et le sujet se met en relief par « qui » : Ce sont ses parents qui ont financé ses études. Le relatif est « qui » (sujet de « ont financé »), jamais « qu'' » : (a) et (b) emploient « qu'' » à la place de « qui ». Le verbe de la relative s''accorde au pluriel (« ont »). ✓ Piège courant : confondre l''extraction du sujet (qui) avec celle d''un complément (que).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26f40e90-d553-5c82-a07c-9603948a645b', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Complète l''accord : « C''est toi et moi qui ___ chargés de l''organisation. »', '[{"id":"a","text":"es"},{"id":"b","text":"êtes"},{"id":"c","text":"sont"},{"id":"d","text":"sommes"}]'::jsonb, 'd', '« toi et moi » équivaut à « nous » (1ʳᵉ personne du pluriel l''emporte) ; après « qui », le verbe s''accorde donc à « sommes » : C''est toi et moi qui sommes chargés. ✓ Règle : moi + toi = nous → 1ʳᵉ pl. Pièges : « êtes » (si on s''arrêtait à « toi ») ou « sont » (accord fautif à la 3ᵉ pers.).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b05c8b07-5066-5bb0-badd-c9ac409a7f40', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Quelle phrase emploie correctement la reprise pronominale dans une dislocation ?', '[{"id":"a","text":"Ce dossier, je lui ai relu hier soir."},{"id":"b","text":"Ce dossier, j''en ai relu hier soir."},{"id":"c","text":"Ce dossier, je l''ai relu hier soir."},{"id":"d","text":"Ce dossier, j''y ai relu hier soir."}]'::jsonb, 'c', '« ce dossier » est le COD de « relire » ; un COD se reprend par « le/la/les » (ici « l'' ») : Ce dossier, je l''ai relu hier soir. ✓ Pièges : « lui » (a) reprend un COI (à qqn) ; « en » (b) un complément en « de » ; « y » (d) un complément en « à »/un lieu — aucun ne convient pour un COD.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ce79a31-a780-551d-97ed-af1717e80a5c', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Pour corriger fermement (« ce n''est pas le prix, c''est la qualité »), quelle structure d''extraction est correcte ?', '[{"id":"a","text":"Ce n''est pas le prix mais la qualité qui a décidé."},{"id":"b","text":"Ce n''est pas le prix mais la qualité qu''a décidé."},{"id":"c","text":"Ce n''est pas le prix dont la qualité a décidé."},{"id":"d","text":"Ce que n''est pas le prix, c''est la qualité a décidé."}]'::jsonb, 'a', 'Pour contraster deux sujets, on emploie l''extraction négative « ce n''est pas X mais Y qui… » : Ce n''est pas le prix mais la qualité qui a décidé. ✓ « qualité » est sujet de « décider » → relatif « qui », jamais « qu'' » (b). « dont » (c) et la forme (d) cassent la structure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db390fc3-7997-5b3e-a2c0-2b4f8224cb9a', '25992876-cf57-56d6-b2ef-2bd08ed384da', 'Complète : « ___ il habite, c''est dans un petit village du Sud. »', '[{"id":"a","text":"Ce que"},{"id":"b","text":"Ce dont"},{"id":"c","text":"Là où"},{"id":"d","text":"C''est où"}]'::jsonb, 'c', 'Pour mettre en relief un lieu avec une tournure annonçant l''élément, on emploie « là où … c''est » : Là où il habite, c''est dans un petit village. ✓ « habiter » indique un lieu, pas un COD (« ce que ») ni un complément en « de » (« ce dont ») ; « c''est où » serait une question, non une mise en relief.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d50cc612-26b0-5570-9186-b29d7e363021', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : la mise en relief', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d8adb85-e119-5941-a685-bbf49f3c74f2', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"C''est moi qui suis le plus concerné par cette décision."},{"id":"b","text":"C''est eux qui ont voté contre le projet."},{"id":"c","text":"C''est nous qui ont le plus travaillé."},{"id":"d","text":"C''est toi qui as proposé cette idée."}]'::jsonb, 'c', 'La phrase fautive est (c) : après « c''est nous qui », le verbe doit s''accorder à la 1ʳᵉ personne du pluriel : C''est nous qui avons le plus travaillé. ✓ (a) moi → suis ✓ ; (d) toi → as ✓ ; (b) « eux » est une 3ᵉ pers. pl., donc « ont » est correct (l''usage soutenu préférerait « ce sont eux », mais l''accord du verbe reste juste).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6e16e97-7c6e-58ea-abba-d52133051e9a', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Repère et corrige l''erreur : « Ce que je tiens le plus, c''est à ma liberté. »', '[{"id":"a","text":"« Ce que » doit devenir « Ce à quoi » : Ce à quoi je tiens le plus, c''est ma liberté."},{"id":"b","text":"« Ce que » doit devenir « Ce dont » : Ce dont je tiens le plus, c''est ma liberté."},{"id":"c","text":"« c''est à » doit devenir « c''est de » : Ce que je tiens, c''est de ma liberté."},{"id":"d","text":"La phrase est correcte."}]'::jsonb, 'a', '« tenir à qqch » se construit avec « à » : la tournure correcte est « ce à quoi … c''est » : Ce à quoi je tiens le plus, c''est ma liberté. ✓ « ce que » (COD) et « ce dont » (verbe en « de ») ne reprennent pas la préposition « à ». Piège courant : oublier que la préposition du verbe commande le relatif (à → à quoi, de → dont).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da21e47b-5a01-5c61-b38a-af0fa382ee61', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Pour annoncer puis identifier avec emphase, complète : « ___ ce roman, c''est sa fin inattendue. »', '[{"id":"a","text":"Ce que m''a marqué dans"},{"id":"b","text":"Ce dont m''a marqué"},{"id":"c","text":"C''est qui m''a marqué dans"},{"id":"d","text":"Ce qui m''a marqué dans"}]'::jsonb, 'd', '« marquer » a un sujet (qu''est-ce qui m''a marqué ?) ; on emploie « ce qui … c''est » : Ce qui m''a marqué dans ce roman, c''est sa fin inattendue. ✓ « ce que » (a) servirait pour un COD, « ce dont » (b) pour un verbe en « de » ; la forme (c) est agrammaticale.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e305f447-aa9a-5825-bd3d-6b4d5848e008', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Quelle phrase combine correctement extraction et contraste pour un écrit soutenu ?', '[{"id":"a","text":"Ce n''est pas par hasard mais par mérite qu''elle a été promue."},{"id":"b","text":"Ce n''est pas par hasard mais par mérite qui elle a été promue."},{"id":"c","text":"Ce dont elle a été promue, ce n''est pas le hasard."},{"id":"d","text":"C''est par mérite dont elle a été promue, pas par hasard."}]'::jsonb, 'a', 'On contraste deux compléments de manière avec « ce n''est pas X mais Y que… » : Ce n''est pas par hasard mais par mérite qu''elle a été promue. ✓ Ce sont des compléments (pas le sujet) → relatif « que/qu'' », jamais « qui » (b). « dont » (c, d) ne convient pas : « être promue par » n''est pas une construction en « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a60c503a-a358-508c-8771-f9a55a7f5c40', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Repère la dislocation dont la reprise pronominale est CORRECTE.', '[{"id":"a","text":"Ce projet ambitieux, je le crois vraiment."},{"id":"b","text":"Ce projet ambitieux, j''en crois vraiment."},{"id":"c","text":"Ce projet ambitieux, j''y crois vraiment."},{"id":"d","text":"Ce projet ambitieux, je lui crois vraiment."}]'::jsonb, 'c', '« croire à qqch » (avoir foi en) se construit avec « à » + chose ; il se reprend par « y » : Ce projet ambitieux, j''y crois vraiment. ✓ « le » (a) reprendrait un COD (croire qqch = être d''avis), sens différent ; « en » (b) un complément en « de » ; « lui » (d) un COI personne. Piège : distinguer « croire qqch » (COD → le) de « croire à qqch » (→ y).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c34b47d-b68d-51ce-a962-fd050792c67e', 'd50cc612-26b0-5570-9186-b29d7e363021', 'Complète l''accord dans cette phrase soignée : « C''est l''une d''entre vous qui ___ désignée. »', '[{"id":"a","text":"serez"},{"id":"b","text":"sera"},{"id":"c","text":"seront"},{"id":"d","text":"serons"}]'::jsonb, 'b', 'L''antécédent de « qui » est « l''une » (singulier), pas « vous » : le verbe se met au singulier : C''est l''une d''entre vous qui sera désignée. ✓ Le complément « d''entre vous » n''impose pas le pluriel. Pièges : « serez » (accord avec vous), « seront » (pluriel), « serons » (1ʳᵉ pers.) sont tous fautifs.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d0aae207-43fc-59fa-b916-6e5a23f97c8a', 'd92e635b-7c7d-53b9-8745-78aef0049de1', 'francais-c1', '⭐⭐ Drill : la mise en relief', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db05c774-979f-5c5f-ae8d-960bbfc8bb97', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Complète : « C''est cette chanson ___ me rappelle mon enfance. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"dont"},{"id":"d","text":"qu''elle"}]'::jsonb, 'b', '« cette chanson » est le sujet de « rappeler » (qu''est-ce qui me rappelle ?). On met le sujet en relief avec « c''est … qui » : C''est cette chanson qui me rappelle mon enfance. « que » servirait pour un COD ; « dont » pour un complément en « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44a64b52-eeae-566e-bb68-6ba0248a517b', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Complète : « ___ je suis fier, c''est de mon équipe. »', '[{"id":"a","text":"Ce que"},{"id":"b","text":"Ce qui"},{"id":"c","text":"Ce dont"},{"id":"d","text":"Ce à quoi"}]'::jsonb, 'c', '« être fier de » se construit avec « de » ; la mise en relief reprend la préposition par « ce dont » : Ce dont je suis fier, c''est de mon équipe. « ce que » (COD) est le piège ; « ce qui » sert au sujet ; « ce à quoi » à un verbe en « à ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cee14fd1-3a82-573d-ac3f-03327423e97e', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Complète l''accord : « C''est moi qui ___ rangé la salle. »', '[{"id":"a","text":"a"},{"id":"b","text":"as"},{"id":"c","text":"ai"},{"id":"d","text":"ont"}]'::jsonb, 'c', 'Après « c''est moi qui », l''auxiliaire s''accorde à la 1ʳᵉ personne du singulier : C''est moi qui ai rangé la salle. « a » (3ᵉ pers.) est le piège habituel ; « as » est la 2ᵉ pers. ; « ont » la 3ᵉ du pluriel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3287a867-fead-528d-9a38-83e77e1cce0f', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Quelle phrase met correctement en relief le complément « avec patience » ?', '[{"id":"a","text":"C''est avec patience qu''il a tout expliqué."},{"id":"b","text":"C''est avec patience qui il a tout expliqué."},{"id":"c","text":"Ce dont il a tout expliqué, c''est la patience."},{"id":"d","text":"C''est avec patience dont il a tout expliqué."}]'::jsonb, 'a', 'Un complément de manière se met en relief avec « c''est … que » : C''est avec patience qu''il a tout expliqué. « qui » est réservé au sujet ; « dont » à un complément en « de », ce qui ne correspond pas à « avec patience ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2eb12b9-d39d-52b2-baef-3284140f5200', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ce film, je l''ai trouvé bouleversant."},{"id":"b","text":"À tes amis, tu peux leur faire confiance."},{"id":"c","text":"De ce sujet, j''en ai déjà parlé."},{"id":"d","text":"Ce livre, je lui ai lu en une nuit."}]'::jsonb, 'd', 'La phrase fautive est (d) : « ce livre » est un COD de « lire », il se reprend par « l'' » et non « lui » (réservé au COI). Il faut dire : Ce livre, je l''ai lu en une nuit. En (a) COD → l'' ✓ ; (b) COI à+personne → leur ✓ ; (c) complément en « de » → en ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee603ff4-ef15-5b2c-8415-27ed1ea22de5', 'd0aae207-43fc-59fa-b916-6e5a23f97c8a', 'Complète la dislocation par anticipation : « ___, je le respecte énormément. »', '[{"id":"a","text":"À cet écrivain"},{"id":"b","text":"Cet écrivain"},{"id":"c","text":"De cet écrivain"},{"id":"d","text":"En cet écrivain"}]'::jsonb, 'b', 'Le pronom de reprise « le » est un COD ; l''élément anticipé doit donc être un COD, sans préposition : Cet écrivain, je le respecte énormément. « À/De/En cet écrivain » introduiraient un complément prépositionnel, qui se reprendrait par lui/en/y, pas par « le ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b20ac41c-5e08-5fcf-90c1-61a93943292d', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('099d558e-369d-5fd4-a1c4-7a86bd613358', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', 'Quel est le nom dérivé du verbe « construire » ?', '[{"id":"a","text":"la construction"},{"id":"b","text":"le construisement"},{"id":"c","text":"le construisage"},{"id":"d","text":"la construiture"}]'::jsonb, 'a', '« Construire » donne « la construction » (suffixe -tion). Les formes ✗construisement, ✗construisage et ✗construiture n''existent pas : le suffixe est fixé par l''usage, et c''est -tion qui s''attache ici.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('123fccc2-c7b2-5396-8cd8-1313e23afd85', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', 'Quel est le genre du nom « augmentation » ?', '[{"id":"a","text":"masculin : un augmentation"},{"id":"b","text":"féminin : une augmentation"},{"id":"c","text":"les deux sont corrects"},{"id":"d","text":"neutre"}]'::jsonb, 'b', 'Les noms en -tion/-ation sont féminins : « une augmentation », « la construction », « la disparition ». Le français n''a pas de neutre, et le genre des dérivés en -tion est régulier : toujours féminin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e65f4167-259f-54fd-be56-4bd7da8896db', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', 'Quel titre de presse nominalise correctement « Les prix ont augmenté » ?', '[{"id":"a","text":"Augmenter les prix"},{"id":"b","text":"Les prix augmentent fort"},{"id":"c","text":"Hausse des prix"},{"id":"d","text":"Prix augmentés"}]'::jsonb, 'c', 'Un titre nominalisé supprime le verbe conjugué au profit d''un groupe nominal : « Hausse des prix ». « Augmenter les prix » garde un infinitif, « Les prix augmentent » garde un verbe conjugué, et « Prix augmentés » est un participe : seul « Hausse » est un vrai nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab5cedf3-c6c7-59dd-b355-2aa3b6d37539', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', 'Nominalisez : « Le suspect a été arrêté. »', '[{"id":"a","text":"L''arrêtation du suspect"},{"id":"b","text":"L''arrestation du suspect"},{"id":"c","text":"L''arrêtement du suspect"},{"id":"d","text":"L''arrêtage du suspect"}]'::jsonb, 'b', 'Le nom dérivé du verbe « arrêter » (au sens d''appréhender) est « l''arrestation ». Les formes ✗arrêtation, ✗arrêtement et ✗arrêtage ne sont pas attestées : c''est « arrestation » qu''utilise notamment le style journalistique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec62f594-05c5-54f6-ae27-222e761b6d78', 'b20ac41c-5e08-5fcf-90c1-61a93943292d', 'Quel nom dérive de l''adjectif « rapide » ?', '[{"id":"a","text":"la rapidesse"},{"id":"b","text":"la rapideur"},{"id":"c","text":"la rapidité"},{"id":"d","text":"le rapidement"}]'::jsonb, 'c', 'L''adjectif « rapide » donne le nom de qualité « la rapidité » (suffixe -ité, féminin). ✗rapidesse et ✗rapideur n''existent pas, et « rapidement » est un adverbe, pas un nom : le suffixe correct est -ité.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a9e7091-212b-5153-9b30-91bc11962ec6', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', '⭐ Entraînement : la nominalisation', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fcf9baf-cd80-5979-9cc0-6209b40f36f9', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Quel nom dérive du verbe « développer » ?', '[{"id":"a","text":"la développation"},{"id":"b","text":"le développement"},{"id":"c","text":"le développage"},{"id":"d","text":"la développure"}]'::jsonb, 'b', '« Développer » donne « le développement » (suffixe -ment, masculin). ✗développation, ✗développage et ✗développure n''existent pas : le verbe sélectionne le suffixe -ment.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec788a73-1656-5def-b99a-61d8cd9499c4', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Quel nom dérive du verbe « recycler » ?', '[{"id":"a","text":"le recyclage"},{"id":"b","text":"la recyclation"},{"id":"c","text":"le recyclement"},{"id":"d","text":"la recyclure"}]'::jsonb, 'a', '« Recycler » donne « le recyclage » (suffixe -age, masculin). Les formes ✗recyclation, ✗recyclement et ✗recyclure ne sont pas attestées : c''est -age qui s''applique ici, comme dans lavage, passage.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da201679-cc2e-5ce8-8830-9364b5aa3b9c', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Quel est le genre du nom « développement » ?', '[{"id":"a","text":"neutre"},{"id":"b","text":"féminin : une développement"},{"id":"c","text":"les deux sont admis"},{"id":"d","text":"masculin : un développement"}]'::jsonb, 'd', 'Les noms en -ment sont masculins : « un développement », « le changement », « le mouvement ». On dit donc « le développement », jamais ✗la développement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8697c61-90a7-5a5c-a43c-4acb0e5f7c70', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Quel nom dérive de l''adjectif « lent » ?', '[{"id":"a","text":"la lenteté"},{"id":"b","text":"la lentise"},{"id":"c","text":"la lenteur"},{"id":"d","text":"la lentesse"}]'::jsonb, 'c', 'L''adjectif « lent » donne « la lenteur » (suffixe -eur, féminin). ✗lenteté, ✗lentise et ✗lentesse n''existent pas : le couple à mémoriser est lent → lenteur, comme grand → grandeur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c818e096-3a6d-5c89-856d-02d4f4bd029a', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Nominalisez : « Le magasin va ouvrir. »', '[{"id":"a","text":"L''ouverture du magasin"},{"id":"b","text":"L''ouvrement du magasin"},{"id":"c","text":"L''ouvrage du magasin"},{"id":"d","text":"L''ouvration du magasin"}]'::jsonb, 'a', '« Ouvrir » donne « l''ouverture » (suffixe -ure, féminin). ✗ouvrement et ✗ouvration n''existent pas ; « ouvrage » existe mais désigne un travail ou un livre, pas l''action d''ouvrir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12484694-3422-502d-b2c9-f561f556ee20', '9a9e7091-212b-5153-9b30-91bc11962ec6', 'Quel nom (dérivé sans suffixe) correspond au verbe « choisir » ?', '[{"id":"a","text":"le choisissement"},{"id":"b","text":"la choisition"},{"id":"c","text":"le choix"},{"id":"d","text":"le choisissage"}]'::jsonb, 'c', '« Choisir » donne « le choix », un dérivé sans suffixe formé sur le radical. ✗choisissement, ✗choisition et ✗choisissage sont inventés : certains verbes nominalisent sans suffixe (choisir → le choix, refuser → le refus).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e5382bc8-d70e-5871-96b6-405a1dafa5c2', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', '⭐⭐ Révision : la nominalisation', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c117ac7c-4d43-58ac-a8b3-bee14f213f34', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Nominalisez : « Les habitants ont refusé le projet. »', '[{"id":"a","text":"Le refusement du projet"},{"id":"b","text":"La refusation du projet"},{"id":"c","text":"Le refusage du projet"},{"id":"d","text":"Le refus du projet par les habitants"}]'::jsonb, 'd', '« Refuser » nominalise sans suffixe en « le refus » (masculin), comme choisir → le choix. ✗refusement, ✗refusation et ✗refusage n''existent pas.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a10c48e5-422b-59f5-ba0b-f7bc637e60e2', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Quel est le genre du nom « rapidité » ?', '[{"id":"a","text":"masculin : un rapidité"},{"id":"b","text":"féminin : une rapidité"},{"id":"c","text":"les deux sont admis"},{"id":"d","text":"neutre"}]'::jsonb, 'b', 'Les noms en -té/-ité sont féminins : « la rapidité », « la beauté », « la fierté ». On dit donc « une grande rapidité », jamais ✗un rapidité.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66caad7b-3d79-5c5d-a5d4-6bd4570e023c', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Quel nom dérive de l''adjectif « gentil » ?', '[{"id":"a","text":"la gentilité"},{"id":"b","text":"la gentilleur"},{"id":"c","text":"la gentillesse"},{"id":"d","text":"la gentillise"}]'::jsonb, 'c', '« Gentil » donne « la gentillesse » (suffixe -esse, féminin), comme faible → la faiblesse. ✗gentilité, ✗gentilleur et ✗gentillise ne sont pas attestés.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e0c0e67-5a49-5f8e-810b-ea57549d843f', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Trouvez l''intrus : un seul nom n''est PAS correctement dérivé.', '[{"id":"a","text":"augmenter → l''augmentation"},{"id":"b","text":"changer → le changement"},{"id":"c","text":"arriver → l''arrivement"},{"id":"d","text":"fermer → la fermeture"}]'::jsonb, 'c', 'L''intrus est « arriver → l''arrivement » : la forme correcte est « l''arrivée » (dérivé en -ée). Les autres sont justes : l''augmentation (-ation), le changement (-ment), la fermeture (-ure).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca3fb4b7-5e4c-50ef-816c-16cd8b855152', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Nominalisez : « Le ministre a démissionné. »', '[{"id":"a","text":"La démission du ministre"},{"id":"b","text":"Le démissionnement du ministre"},{"id":"c","text":"La démissionnation du ministre"},{"id":"d","text":"Le démissionnage du ministre"}]'::jsonb, 'a', '« Démissionner » nominalise en « la démission » (féminin), forme dérivée sans suffixe verbal régulier. ✗démissionnation, ✗démissionnement et ✗démissionnage sont inventés.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('818cd98a-dbf8-55c3-9b6f-ef881973f67d', 'e5382bc8-d70e-5871-96b6-405a1dafa5c2', 'Quel groupe nominal nominalise correctement « Un enfant a disparu » dans un titre ?', '[{"id":"a","text":"Disparaissement d''un enfant"},{"id":"b","text":"Disparition d''un enfant"},{"id":"c","text":"Disparissage d''un enfant"},{"id":"d","text":"Disparu d''un enfant"}]'::jsonb, 'b', '« Disparaître » donne « la disparition » (suffixe -tion, féminin). ✗disparaissement et ✗disparissage n''existent pas, et « disparu » est un participe, pas un nom d''action : un titre exige le nom « disparition ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : la nominalisation', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8a9a48a-83cc-5a8c-9378-25a8fe2a9b0d', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Nominalisez : « L''usine sera fermée le mois prochain. »', '[{"id":"a","text":"La fermeture de l''usine"},{"id":"b","text":"La fermation de l''usine"},{"id":"c","text":"Le fermement de l''usine"},{"id":"d","text":"Le fermage de l''usine"}]'::jsonb, 'a', '« Fermer » donne « la fermeture » (suffixe -ure, féminin). ✗fermement et ✗fermation n''existent pas ; « fermage » existe mais désigne la location d''une terre agricole, pas l''action de fermer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d89fb7db-96cf-52a8-a915-ac3d3d886be8', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Nominalisez : « Les autorités ont interdit la manifestation. »', '[{"id":"a","text":"L''interdisement de la manifestation"},{"id":"b","text":"L''interdiction de la manifestation"},{"id":"c","text":"L''interdisage de la manifestation"},{"id":"d","text":"L''interditure de la manifestation"}]'::jsonb, 'b', '« Interdire » donne « l''interdiction » (suffixe -tion, féminin). ✗interdisement, ✗interdisage et ✗interditure sont inventés : c''est -tion, comme produire → la production.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('effb5d15-c08f-5d16-98ca-0f6c1df86928', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Trouvez l''intrus : un seul couple présente une erreur de GENRE.', '[{"id":"a","text":"la construction"},{"id":"b","text":"le développement"},{"id":"c","text":"la recyclage"},{"id":"d","text":"la lenteur"}]'::jsonb, 'c', 'L''erreur est « la recyclage » : les noms en -age sont masculins, donc « le recyclage ». Les autres genres sont corrects : la construction (-tion, fém.), le développement (-ment, masc.), la lenteur (-eur, fém.).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfba706a-0a80-516d-a3da-c6216e02e408', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Quel nom dérive de l''adjectif « franc » (sincère) ?', '[{"id":"a","text":"la francité"},{"id":"b","text":"la franceur"},{"id":"c","text":"la francesse"},{"id":"d","text":"la franchise"}]'::jsonb, 'd', '« Franc » (sincère) donne « la franchise » (suffixe -ise, féminin), comme gourmand → la gourmandise. ✗francité, ✗franceur et ✗francesse ne sont pas attestés.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f467402-95fb-51cb-b3d2-1e1155ef5f09', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Nominalisez le titre : « La population a baissé dans la région. »', '[{"id":"a","text":"Baisse de la population régionale"},{"id":"b","text":"Baissage de la population régionale"},{"id":"c","text":"Baissement de la population régionale"},{"id":"d","text":"Baissation de la population régionale"}]'::jsonb, 'a', '« Baisser » nominalise sans suffixe en « la baisse » (féminin), comme dans un titre de presse condensé. ✗baissement, ✗baissage et ✗baissation n''existent pas : le nom d''action est « baisse ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bfff066-0ab0-506d-a98b-fe2248308835', 'aaf0fbfd-ce04-5000-82e1-9c49d16b5da1', 'Trouvez l''intrus : un seul nom n''est PAS un dérivé correct de son verbe.', '[{"id":"a","text":"accueillir → l''accueil"},{"id":"b","text":"monter → la montée"},{"id":"c","text":"appeler → l''appel"},{"id":"d","text":"produire → le produisement"}]'::jsonb, 'd', 'L''intrus est « produire → le produisement » : la forme correcte est « la production » (-tion). Les autres sont justes : l''accueil et l''appel (dérivés sans suffixe), la montée (-ée).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a548630-582d-58dc-9674-7ae90a923fdc', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : la nominalisation', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5b4ece6-f0ae-5c5e-947b-9a77aab80728', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Nominalisez en style administratif : « Le dossier a été transmis au service compétent. »', '[{"id":"a","text":"Le transmettement du dossier au service compétent"},{"id":"b","text":"La transmission du dossier au service compétent"},{"id":"c","text":"Le transmissage du dossier au service compétent"},{"id":"d","text":"La transmetture du dossier au service compétent"}]'::jsonb, 'b', '« Transmettre » donne « la transmission » (suffixe -ssion, féminin). Le piège courant est d''inventer ✗transmettement ou ✗transmetture à partir du radical du verbe : la nominalisation passe ici par la base latine -mission, comme admettre → l''admission.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f1c2bcb-7405-571a-9e8e-40f0ec5be18e', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Trouvez l''intrus : un seul couple adjectif → nom est INCORRECT.', '[{"id":"a","text":"beau → la beausse"},{"id":"b","text":"doux → la douceur"},{"id":"c","text":"faible → la faiblesse"},{"id":"d","text":"fier → la fierté"}]'::jsonb, 'a', 'L''intrus est « beau → la beausse » : la forme correcte est « la beauté » (suffixe -té). Les autres sont justes : la faiblesse (-esse), la douceur (-eur), la fierté (-té). Le piège est de plaquer -esse sur tout adjectif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('388807e1-36fe-556b-a3bc-61c51643f1bd', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Nominalisez : « On a accru les effectifs cette année. »', '[{"id":"a","text":"L''accroissage des effectifs"},{"id":"b","text":"L''accruement des effectifs"},{"id":"c","text":"L''accroissement des effectifs"},{"id":"d","text":"L''accruation des effectifs"}]'::jsonb, 'c', '« Accroître » donne « l''accroissement » (suffixe -ment, masculin), formé sur le radical du participe (accroissant). Le piège courant est de dériver sur le participe passé « accru » (✗accruement, ✗accruation) : c''est bien « accroissement ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('863ed009-e33f-5ef2-97c8-d29fc1417699', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Choisissez le titre de presse correctement nominalisé : « Le tribunal a acquitté l''accusé. »', '[{"id":"a","text":"Acquit de l''accusé"},{"id":"b","text":"Acquittation de l''accusé"},{"id":"c","text":"Acquittage de l''accusé"},{"id":"d","text":"Acquittement de l''accusé"}]'::jsonb, 'd', '« Acquitter » (au sens judiciaire) donne « l''acquittement » (suffixe -ment, masculin). Le piège est « acquit » (un acquit = une quittance de paiement), qui ne désigne pas la décision du tribunal ; ✗acquittation et ✗acquittage n''existent pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a26e55c-6b0c-5934-987a-b070bf64fee8', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Trouvez l''intrus : un seul nom n''est PAS le bon dérivé du verbe.', '[{"id":"a","text":"résoudre → la résolution"},{"id":"b","text":"conclure → la conclusion"},{"id":"c","text":"permettre → le permettement"},{"id":"d","text":"détruire → la destruction"}]'::jsonb, 'c', 'L''intrus est « permettre → le permettement » : la forme correcte est « la permission » (-ssion). Les autres sont justes : la résolution, la conclusion, la destruction — toutes en -tion/-sion, féminines, formées sur la base latine et non sur le radical français.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('508b9dee-a95b-5bc0-806a-d17be329475e', '0a548630-582d-58dc-9674-7ae90a923fdc', 'Nominalisez : « Le projet a abouti après deux ans. »', '[{"id":"a","text":"L''aboutation du projet"},{"id":"b","text":"L''aboutissement du projet"},{"id":"c","text":"L''aboutissage du projet"},{"id":"d","text":"L''about du projet"}]'::jsonb, 'b', '« Aboutir » donne « l''aboutissement » (suffixe -ment sur le radical aboutiss-, masculin), comme accomplir → l''accomplissement. Le piège est d''inventer ✗aboutation ou ✗aboutissage, ou de réduire au radical nu ✗l''about (qui désigne une extrémité technique).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ae330677-ee9c-5dcd-9f79-36e025b0cece', '094d8b92-d09a-59ba-b636-14e32a6585b2', 'francais-c1', '⭐⭐ Drill : la nominalisation', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77c68ce2-f76f-5759-9f48-1b98b075ce98', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Quel nom dérive du verbe « laver » ?', '[{"id":"a","text":"le lavage"},{"id":"b","text":"le lavement"},{"id":"c","text":"la lavation"},{"id":"d","text":"la lavure"}]'::jsonb, 'a', '« Laver » donne « le lavage » (suffixe -age, masculin). ✗lavation n''existe pas ; « lavement » existe mais a un sens médical, et « lavure » désigne une eau sale : le nom d''action courant est « lavage ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08869e69-06a0-5cf5-b049-bea35472a89f', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Quel est le genre du nom « disparition » ?', '[{"id":"a","text":"masculin : un disparition"},{"id":"b","text":"féminin : une disparition"},{"id":"c","text":"les deux sont admis"},{"id":"d","text":"neutre"}]'::jsonb, 'b', 'Les noms en -tion sont féminins : « une disparition », « la disparition ». On dit donc « une disparition inquiétante », jamais ✗un disparition.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f0bb918-602a-52c3-995b-e4b132f7f31d', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Nominalisez : « Le public a accueilli chaleureusement l''artiste. »', '[{"id":"a","text":"L''accueillement de l''artiste"},{"id":"b","text":"L''accueil de l''artiste"},{"id":"c","text":"L''accueillage de l''artiste"},{"id":"d","text":"L''accueillition de l''artiste"}]'::jsonb, 'b', '« Accueillir » nominalise sans suffixe en « l''accueil » (masculin), formé sur le radical. ✗accueillement, ✗accueillage et ✗accueillition sont inventés.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19a112cf-cdd8-530d-ba75-a2edc1e72bb2', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Quel nom dérive de l''adjectif « grand » ?', '[{"id":"a","text":"la grandité"},{"id":"b","text":"la grandesse"},{"id":"c","text":"la grandise"},{"id":"d","text":"la grandeur"}]'::jsonb, 'd', '« Grand » donne « la grandeur » (suffixe -eur, féminin), comme lent → la lenteur, doux → la douceur. ✗grandité, ✗grandesse et ✗grandise n''existent pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc619469-5f9b-5a07-b931-e722e57f73e1', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Trouvez l''intrus : un seul couple verbe → nom est INCORRECT.', '[{"id":"a","text":"passer → le passage"},{"id":"b","text":"monter → la montée"},{"id":"c","text":"vendre → la vendition"},{"id":"d","text":"appeler → l''appel"}]'::jsonb, 'c', 'L''intrus est « vendre → la vendition » : le nom correct est « la vente » (dérivé sans suffixe régulier). Les autres sont justes : le passage (-age), la montée (-ée), l''appel (dérivé sans suffixe).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('701e0655-a0de-54ea-b5c8-65efb9576a9f', 'ae330677-ee9c-5dcd-9f79-36e025b0cece', 'Nominalisez le titre : « Les routes ont été dégradées par le gel. »', '[{"id":"a","text":"Dégradement des routes par le gel"},{"id":"b","text":"Dégradage des routes par le gel"},{"id":"c","text":"Dégradure des routes par le gel"},{"id":"d","text":"Dégradation des routes par le gel"}]'::jsonb, 'd', '« Dégrader » donne « la dégradation » (suffixe -ation, féminin). ✗dégradement, ✗dégradage et ✗dégradure ne sont pas attestés : le nom d''action est « dégradation », fréquent dans les titres de presse.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5159c64-12d7-5077-9a58-35fb94800ddb', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', 'Quelle valeur logique le connecteur « voire » exprime-t-il dans : « C''est une démarche difficile, voire impossible » ?', '[{"id":"a","text":"Une gradation : il renchérit, va plus loin que le premier terme."},{"id":"b","text":"Une reformulation : il redit la même idée autrement."},{"id":"c","text":"Une opposition : il contredit le premier terme."},{"id":"d","text":"Une conséquence : il en tire un effet."}]'::jsonb, 'a', '« Voire » marque une gradation (« et même ») : « impossible » est plus fort que « difficile ». Ce n''est pas une reformulation (autrement dit), ni une opposition (mais), ni une conséquence (donc).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4409000-5d58-5bd1-b6ba-96243901e492', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', 'Complétez : « Plusieurs disciplines sont concernées, ___ les mathématiques et la physique. »', '[{"id":"a","text":"c''est-à-dire"},{"id":"b","text":"autrement dit"},{"id":"c","text":"notamment"},{"id":"d","text":"en d''autres termes"}]'::jsonb, 'c', 'On donne des exemples parmi un ensemble : il faut un connecteur d''illustration, « notamment ». « C''est-à-dire », « autrement dit » et « en d''autres termes » sont des reformulations : ils annonceraient que les maths et la physique sont l''équivalent exact de « plusieurs disciplines », ce qui est faux.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11ebe136-80de-5469-a62f-200d6a83fd97', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', 'Quel connecteur introduit l''argument le plus fort, dans un registre soutenu ?', '[{"id":"a","text":"et aussi"},{"id":"b","text":"qui plus est"},{"id":"c","text":"du coup"},{"id":"d","text":"et puis"}]'::jsonb, 'b', '« Qui plus est » ajoute un argument encore plus décisif, dans un registre soutenu. « Et aussi » et « et puis » sont neutres ou familiers ; « du coup » est familier et marque une conséquence, pas une addition renforcée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5c1e927-b346-5836-9cc4-5c98557f28fe', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', 'Complétez correctement : « Il a parlé fort, de sorte que tout le monde ___. » (on constate un fait accompli)', '[{"id":"a","text":"entende"},{"id":"b","text":"entendît"},{"id":"c","text":"ait entendu"},{"id":"d","text":"a entendu"}]'::jsonb, 'd', '« De sorte que » + indicatif exprime la conséquence (le résultat a réellement eu lieu) : « a entendu ». Le subjonctif (« entende », « entendît », « ait entendu ») donnerait au connecteur la valeur de but (l''intention), ce qui ne correspond pas à un fait accompli.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c066da4-46ce-5686-9819-ae29d2f8df4a', '0bfb3bfc-5a3f-51c9-9612-38d77a2c9bc5', 'Quelle phrase emploie correctement une tournure de concession soutenue ?', '[{"id":"a","text":"Force est de constater que les résultats soient décevants."},{"id":"b","text":"Il n''en demeure pas moins que la situation reste fragile."},{"id":"c","text":"Certes le coût est élevé, c''est-à-dire le bénéfice le justifie."},{"id":"d","text":"Quoi qu''il en soit, du coup on abandonne le projet."}]'::jsonb, 'b', '« Il n''en demeure pas moins que » se construit à l''indicatif (« reste ») et pose un fait malgré ce qui précède : correct. En (a) il faut l''indicatif (« sont »), pas le subjonctif. En (c) le balancier de concession appelle « néanmoins/mais », non une reformulation. En (d), « du coup » est familier et inadapté au registre soutenu.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2b938254-083a-5601-b46c-67870fdd3c78', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', '⭐ Entraînement : connecteurs et articulation du discours', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8338ce8-ea96-5341-9de8-3f97c2fd1688', '2b938254-083a-5601-b46c-67870fdd3c78', 'Quelle est la valeur logique de « en outre » ?', '[{"id":"a","text":"Reformulation d''une idée."},{"id":"b","text":"Opposition entre deux faits."},{"id":"c","text":"Conséquence d''un fait."},{"id":"d","text":"Addition d''un argument, registre soutenu."}]'::jsonb, 'd', '« En outre » ajoute un argument supplémentaire dans un registre soutenu (= de plus). Il ne marque ni l''opposition (mais, en revanche), ni la conséquence (donc), ni la reformulation (autrement dit).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('939e5c5e-6ebb-5620-92fd-964b6769de34', '2b938254-083a-5601-b46c-67870fdd3c78', 'Complétez : « La séance est reportée ; ___, elle n''aura pas lieu cette semaine. » (on redit l''idée plus clairement)', '[{"id":"a","text":"à titre d''exemple"},{"id":"b","text":"néanmoins"},{"id":"c","text":"autrement dit"},{"id":"d","text":"en particulier"}]'::jsonb, 'c', '« Autrement dit » reformule : la seconde proposition redit la première en plus clair. « À titre d''exemple » et « en particulier » illustrent ; « néanmoins » concède, ce qui changerait le sens en y opposant une réserve.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82c7847f-c112-5fba-bde9-c26c8b184c2c', '2b938254-083a-5601-b46c-67870fdd3c78', 'Complétez : « De nombreux pays sont concernés, ___ ceux du bassin méditerranéen. »', '[{"id":"a","text":"c''est-à-dire"},{"id":"b","text":"en d''autres termes"},{"id":"c","text":"notamment"},{"id":"d","text":"à savoir"}]'::jsonb, 'c', 'On cite un exemple parmi un ensemble : « notamment » (illustration). « C''est-à-dire », « en d''autres termes » et « à savoir » sont des reformulations, qui sous-entendraient à tort que les pays méditerranéens sont exactement « de nombreux pays ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f20636f-9d74-597e-88aa-ba64d1eff092', '2b938254-083a-5601-b46c-67870fdd3c78', 'Complétez avec un connecteur de conclusion : « Les avis divergent ; ___, la prudence s''impose. »', '[{"id":"a","text":"à savoir"},{"id":"b","text":"par ailleurs"},{"id":"c","text":"qui plus est"},{"id":"d","text":"en définitive"}]'::jsonb, 'd', '« En définitive » referme le raisonnement et annonce le bilan : connecteur de conclusion. « Par ailleurs » et « qui plus est » ajoutent un argument ; « à savoir » reformule. Aucun ne conclut.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1287afb6-4317-5e93-85e6-8cdeaceb5588', '2b938254-083a-5601-b46c-67870fdd3c78', 'Dans « C''est une maladresse, voire une faute », que signifie « voire » ?', '[{"id":"a","text":"Ou bien, au choix entre deux termes équivalents."},{"id":"b","text":"C''est-à-dire, en précisant le même terme."},{"id":"c","text":"Et même, en renchérissant vers un terme plus fort."},{"id":"d","text":"Cependant, en opposant les deux termes."}]'::jsonb, 'c', '« Voire » exprime une gradation : « une faute » est plus grave que « une maladresse ». Ce n''est pas un choix d''équivalents, ni une reformulation (c''est-à-dire), ni une opposition (cependant).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26883b27-a30d-5b1f-a5b1-69d011025476', '2b938254-083a-5601-b46c-67870fdd3c78', 'Quel couple structure correctement une énumération équilibrée ?', '[{"id":"a","text":"d''une part… en revanche"},{"id":"b","text":"non seulement… c''est-à-dire"},{"id":"c","text":"d''une part… d''autre part"},{"id":"d","text":"d''abord… néanmoins"}]'::jsonb, 'c', 'Le couple corrélatif « d''une part… d''autre part » présente deux faces équilibrées. Les autres mêlent un terme structurant à un connecteur d''une autre famille (opposition « en revanche », reformulation « c''est-à-dire », concession « néanmoins »), ce qui rompt la corrélation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('606f19ce-4de9-53c7-8948-c3c94a152790', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', '⭐⭐ Révision : connecteurs et articulation du discours', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fd07784-1aec-5c67-af26-db0a97e32d70', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Complétez : « ___ tu connais déjà ces données, je passe directement à l''analyse. » (cause présentée comme une condition admise)', '[{"id":"a","text":"Qui plus est"},{"id":"b","text":"Eu égard à"},{"id":"c","text":"De sorte que"},{"id":"d","text":"Dans la mesure où"}]'::jsonb, 'd', '« Dans la mesure où » + indicatif introduit une cause posée comme condition admise (« puisque, dès lors que c''est le cas »). « Eu égard à » se construit avec un nom, pas une proposition ; « de sorte que » marque la conséquence ou le but ; « qui plus est » est une addition.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8b930d7-940d-5798-8e1c-22e8a129454d', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Choisissez la phrase correcte avec « eu égard à ».', '[{"id":"a","text":"Eu égard à il a beaucoup travaillé, on lui accorde une prime."},{"id":"b","text":"Eu égard à ses efforts, on lui accorde une prime."},{"id":"c","text":"Eu égard à qu''il a travaillé, on lui accorde une prime."},{"id":"d","text":"Eu égard qu''il travaille, on lui accorde une prime."}]'::jsonb, 'b', '« Eu égard à » (registre très soutenu) se construit avec un nom ou un groupe nominal : « eu égard à ses efforts ». Il ne peut être suivi d''une proposition à verbe conjugué (a, c, d), qui exigerait « étant donné qu''il a travaillé ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c73e3151-44fd-5a5f-8eb6-abea93bb7b19', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Complétez : « Certes, la méthode est lente ; ___, elle reste la plus fiable. »', '[{"id":"a","text":"autrement dit"},{"id":"b","text":"à titre d''exemple"},{"id":"c","text":"néanmoins"},{"id":"d","text":"en outre"}]'::jsonb, 'c', 'Le balancier « certes… » appelle un connecteur de réfutation : « néanmoins » (on admet puis on objecte). « Autrement dit » reformule, « à titre d''exemple » illustre, « en outre » ajoute un argument dans le même sens — aucun ne réfute la concession.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5f96872-0b6d-5f4e-90f8-c1ce24cf80a4', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Complétez : « Les indicateurs ont progressé ; ___ la reprise reste fragile. » (on maintient une réserve malgré le progrès)', '[{"id":"a","text":"en d''autres termes"},{"id":"b","text":"par conséquent"},{"id":"c","text":"dès lors"},{"id":"d","text":"il n''en demeure pas moins que"}]'::jsonb, 'd', '« Il n''en demeure pas moins que » (+ indicatif) maintient un fait malgré ce qui précède : valeur concessive soutenue. « Par conséquent » et « dès lors » marqueraient une conséquence (l''inverse du sens voulu) ; « en d''autres termes » reformulerait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e1658ed-d4fd-5bd6-a4be-34c4c9cd6c9b', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Trouvez la phrase où « d''autant que » est employé CORRECTEMENT.', '[{"id":"a","text":"Il est tard, d''autant que nous partons."},{"id":"b","text":"Je l''aide volontiers, d''autant qu''il est seul."},{"id":"c","text":"Il pleut, d''autant que nous restons."},{"id":"d","text":"D''autant que le bilan est mauvais, on conclut."}]'::jsonb, 'b', '« D''autant que » renforce une cause (« et ce, d''autant plus que… ») : en (b), la solitude renforce la raison d''aider. En (a), (c) et (d), on attend une conséquence (« donc »), valeur que « d''autant que » ne peut pas exprimer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0188e508-afd1-5f5c-8d60-6fb1d5526a15', '606f19ce-4de9-53c7-8948-c3c94a152790', 'Complétez : « Le contrat n''a pas été signé ; ___, le projet est suspendu. » (conséquence, registre soutenu)', '[{"id":"a","text":"à savoir"},{"id":"b","text":"voire"},{"id":"c","text":"dans la mesure où"},{"id":"d","text":"partant"}]'::jsonb, 'd', '« Partant » signifie « par suite, donc » : connecteur de conséquence soutenu. « À savoir » reformule, « voire » gradue (« et même »), « dans la mesure où » introduit une cause — aucun n''exprime la conséquence attendue.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e5d5a5bd-4d61-55fa-85fe-b5086d185d83', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : connecteurs et articulation du discours', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d30ff86f-f4e8-564a-9569-e874b3dd9d3f', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Complétez : « Réorganisez les dossiers ___ chacun retrouve facilement les siens. » (intention visée : but)', '[{"id":"a","text":"de sorte que chacun retrouve"},{"id":"b","text":"de sorte que chacun retrouvera"},{"id":"c","text":"de sorte que chacun a retrouvé"},{"id":"d","text":"de sorte que chacun retrouvait"}]'::jsonb, 'a', 'Quand « de sorte que » exprime le but (l''intention, le résultat souhaité), il se construit au subjonctif : « retrouve ». L''indicatif (futur, passé composé, imparfait) lui donnerait la valeur de conséquence (un fait constaté), incompatible avec une intention non encore réalisée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('716f15c7-0e39-59c3-b09c-64fee449609e', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Complétez la concession soutenue : « ___ l''objectif chiffré n''a pas été atteint. »', '[{"id":"a","text":"Force est de constater que"},{"id":"b","text":"Force est de constater qu''"},{"id":"c","text":"À titre d''exemple,"},{"id":"d","text":"Qui plus est,"}]'::jsonb, 'a', '« Force est de constater que » introduit un fait imposé par l''évidence (+ indicatif), valeur concessive de reconnaissance. Devant « l''objectif » (consonne), on garde « que » : « qu'' » de (b) est une faute d''élision. « À titre d''exemple » illustre et « qui plus est » ajoute — hors sujet ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e05554b-c169-5e4c-9bef-66ae4f659e23', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Complétez : « La demande explose ; ___, il faut doubler la production sans tarder. »', '[{"id":"a","text":"à savoir"},{"id":"b","text":"notamment"},{"id":"c","text":"par ailleurs"},{"id":"d","text":"dès lors"}]'::jsonb, 'd', '« Dès lors » marque la conséquence (« par suite, donc ») dans un registre soutenu : doubler la production découle de l''explosion de la demande. « À savoir » reformule, « notamment » illustre, « par ailleurs » ajoute un point connexe — aucun n''exprime la conséquence.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7345016-acaf-523a-a243-636d9afa7efc', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Trouvez la phrase où le connecteur a une valeur logique INADAPTÉE.', '[{"id":"a","text":"Le sol est gelé ; partant, les semis sont retardés."},{"id":"b","text":"Le sol est gelé ; en d''autres termes, les semis sont retardés."},{"id":"c","text":"Le sol étant gelé, les semis sont retardés."},{"id":"d","text":"Le sol est gelé ; dès lors, les semis sont retardés."}]'::jsonb, 'b', 'Le retard des semis est une conséquence du gel, pas une reformulation du même fait : « en d''autres termes » est donc inadapté en (b). « Partant » et « dès lors » (conséquence) et le participe causal en (c) conviennent à la chaîne cause-conséquence.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e594c84-660e-532f-a2e9-4434596b3dae', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Quelle phrase emploie correctement le couple « non seulement… mais encore » avec l''inversion soutenue ?', '[{"id":"a","text":"Non seulement il a refusé, mais encore il a protesté."},{"id":"b","text":"Non seulement a-t-il refusé, mais encore il a protesté."},{"id":"c","text":"Non seulement a-t-il refusé, mais encore a-t-il protesté que non."},{"id":"d","text":"Non seulement il a refusé, mais encore a-t-il que protesté."}]'::jsonb, 'b', 'Avec « non seulement » en tête de phrase, l''écrit soutenu pratique l''inversion du sujet dans la première proposition : « Non seulement a-t-il refusé ». La seconde, introduite par « mais encore », reste à l''ordre normal. (a) est correct mais sans l''inversion demandée ; (c) et (d) déforment la construction.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03606fbd-8905-5895-8e37-54dceae2a1a0', 'e5d5a5bd-4d61-55fa-85fe-b5086d185d83', 'Dans un débat, on a longuement opposé les arguments. Pour clore et trancher, quel connecteur convient le mieux ?', '[{"id":"a","text":"Par ailleurs,"},{"id":"b","text":"C''est-à-dire,"},{"id":"c","text":"Quoi qu''il en soit,"},{"id":"d","text":"Qui plus est,"}]'::jsonb, 'c', '« Quoi qu''il en soit » (= « de toute façon ») balaie les réserves précédentes et clôt le débat : c''est le geste de clôture attendu. « Par ailleurs » et « qui plus est » relanceraient l''argumentation ; « c''est-à-dire » reformulerait. À ne pas confondre avec « quoi que » suivi du subjonctif (« quoi qu''il dise »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4f35e08b-f07c-5473-b82d-83b168db09cb', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : connecteurs et articulation du discours', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5cb0060c-281f-5ac0-ac11-25d9667949f3', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Choisissez la paire qui articule le mieux ce raisonnement : « ___ la réforme part d''une bonne intention. ___ ses modalités d''application en compromettent les effets. »', '[{"id":"a","text":"Certes … Néanmoins"},{"id":"b","text":"En outre … Qui plus est"},{"id":"c","text":"Dès lors … Partant"},{"id":"d","text":"Autrement dit … À savoir"}]'::jsonb, 'a', 'Le mouvement concessif typique : on admet (« Certes, la réforme part d''une bonne intention ») puis on réfute (« Néanmoins, ses modalités… »). « En outre/qui plus est » sont deux additions (même sens), « dès lors/partant » deux conséquences, « autrement dit/à savoir » deux reformulations — aucun n''oppose l''admission à la réserve.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52762ec6-cff4-5f84-bb96-2954e5f68f50', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Repérez l''ERREUR de connecteur dans cette phrase soutenue : « Le rapport est incomplet ; dans la mesure où, il faudra le compléter avant la séance. »', '[{"id":"a","text":"« dans la mesure où » introduit une cause et ne peut, suivi d''une virgule, jouer le rôle d''un connecteur de conséquence (« par conséquent »)."},{"id":"b","text":"Le point-virgule devrait être une virgule."},{"id":"c","text":"« incomplet » devrait être suivi du subjonctif."},{"id":"d","text":"« avant la séance » devrait précéder « il faudra »."}]'::jsonb, 'a', '« Dans la mesure où » est une locution conjonctive de cause qui doit introduire une proposition (« dans la mesure où il est incomplet »). Employée seule, suivie d''une virgule pour relier deux phrases, elle ne peut signifier « par conséquent / aussi », qui serait ici le connecteur de conséquence attendu. Les autres remarques sont des points de style ou des fausses pistes grammaticales.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92d1027c-4dc0-52db-994b-8b16a85a4dc2', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Quelle version est la plus cohérente ET la plus appropriée à une dissertation soutenue ?', '[{"id":"a","text":"Le texte est dense. Du coup c''est dur à lire. Mais bon, il est intéressant quand même."},{"id":"b","text":"Le texte est dense ; il n''en demeure pas moins accessible, dans la mesure où l''auteur multiplie les exemples."},{"id":"c","text":"Le texte est dense, c''est-à-dire accessible, voire l''auteur multiplie les exemples."},{"id":"d","text":"Le texte est dense, partant accessible, autrement dit l''auteur donne des exemples."}]'::jsonb, 'b', '(b) enchaîne logiquement : concession (« il n''en demeure pas moins accessible ») puis cause justifiante (« dans la mesure où… »), dans un registre soutenu et cohérent. (a) est familier (« du coup », « mais bon… quand même »). (c) confond reformulation et gradation et juxtapose des valeurs incompatibles. (d) emploie « partant » (conséquence) puis « autrement dit » (reformulation) de façon illogique.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1422534b-a390-584c-9bd8-4ac476e717bc', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Complétez la phrase complexe : « ___ la subvention a été refusée, ___ le directeur a dû geler les recrutements, ___ l''équipe restera incomplète cette année. »', '[{"id":"a","text":"Étant donné que … de sorte qu'' … il n''en demeure pas moins qu''"},{"id":"b","text":"Notamment … à savoir … voire"},{"id":"c","text":"Quoi qu''il en soit … c''est-à-dire … partant"},{"id":"d","text":"À titre d''exemple … en outre … dès lors"}]'::jsonb, 'a', 'La chaîne est : cause (« Étant donné que la subvention a été refusée ») → conséquence (« de sorte qu''il a dû geler les recrutements », + indicatif = fait avéré) → constat concessif final (« il n''en demeure pas moins que l''équipe restera incomplète »). Les autres mêlent illustration, reformulation et gradation, sans rendre la progression cause → conséquence → constat.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('328a1aa6-3963-530b-ad6c-58c908f03267', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Dans laquelle de ces phrases « voire » est-il employé à BON escient (gradation) ?', '[{"id":"a","text":"Le délai sera court, voire les moyens seront limités."},{"id":"b","text":"La tâche est ardue, voire insurmontable."},{"id":"c","text":"Il a réussi, voire il a échoué."},{"id":"d","text":"Il pleut, voire nous restons à l''abri."}]'::jsonb, 'b', '« Voire » relie deux termes de même nature en renchérissant : « insurmontable » est plus fort qu''« ardue ». En (a) il relie deux idées distinctes (il faudrait « de plus »), en (c) il opposerait des contraires (« mais »), en (d) il marquerait une conséquence (« donc ») — autant d''emplois fautifs.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d163354-6f34-59fc-9eee-a888c6bf4ab8', '4f35e08b-f07c-5473-b82d-83b168db09cb', 'Pour conclure une synthèse après avoir pesé le pour et le contre, quelle formulation est la plus juste et la plus économe ?', '[{"id":"a","text":"En somme, en définitive, somme toute, le projet mérite d''être tenté."},{"id":"b","text":"Par ailleurs, le projet mérite d''être tenté."},{"id":"c","text":"En définitive, le projet mérite d''être tenté."},{"id":"d","text":"À savoir, le projet mérite d''être tenté."}]'::jsonb, 'c', 'Un seul connecteur de conclusion suffit, placé en tête du bilan : « En définitive » (« tout bien pesé »). (a) empile trois synonymes de clôture, lourdeur à proscrire. « Par ailleurs » ajoute un argument (ne conclut pas) et « à savoir » reformule — ni l''un ni l''autre ne clôt la synthèse.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3bd675de-ab5e-5115-bb00-cf6f7c0c457e', '65646086-8d8d-55e2-9a39-364c325754a3', 'francais-c1', '⭐⭐ Drill : connecteurs et articulation du discours', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('397922e7-7465-531b-9dbd-3f98c4f64d2d', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Complétez : « Cette politique est inefficace ; ___, elle se révèle injuste. » (on ajoute un grief plus lourd, registre soutenu)', '[{"id":"a","text":"qui plus est"},{"id":"b","text":"c''est-à-dire"},{"id":"c","text":"dès lors"},{"id":"d","text":"à savoir"}]'::jsonb, 'a', '« Qui plus est » ajoute un argument encore plus fort (l''injustice aggrave l''inefficacité). « C''est-à-dire » et « à savoir » reformulent ; « dès lors » marquerait une conséquence, ce qui n''est pas le rapport visé.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86f494d7-09d0-517a-9e7b-b978a2bc27e2', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Complétez : « L''examen porte sur tout le programme, ___ les chapitres révisés en classe. »', '[{"id":"a","text":"autrement dit"},{"id":"b","text":"en particulier"},{"id":"c","text":"néanmoins"},{"id":"d","text":"en d''autres termes"}]'::jsonb, 'b', '« En particulier » met en relief un sous-ensemble illustratif du programme : c''est une illustration. « Autrement dit » et « en d''autres termes » reformuleraient (faux : les chapitres révisés ne sont pas tout le programme) ; « néanmoins » concéderait.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7568c154-6fe9-50d2-b3ca-08ba3ddc038b', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Quelle phrase emploie « par ailleurs » conformément à sa valeur ?', '[{"id":"a","text":"Il est compétent ; par ailleurs, il connaît bien le secteur, ce qui est un atout supplémentaire."},{"id":"b","text":"Il est compétent ; par ailleurs, donc on l''embauche."},{"id":"c","text":"Il est compétent, par ailleurs incompétent selon d''autres."},{"id":"d","text":"Il est compétent, par ailleurs c''est-à-dire qualifié."}]'::jsonb, 'a', '« Par ailleurs » ajoute un point connexe mais distinct (sa connaissance du secteur s''ajoute à sa compétence) : emploi correct en (a). En (b) il est mêlé à une conséquence (« donc »), en (c) à une opposition, en (d) à une reformulation — autant de valeurs étrangères à l''addition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2136ea1-136a-5331-a416-a2c9446b6852', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Complétez la synthèse : « Le bilan comporte des ombres et des lumières ; ___, l''expérience aura été instructive. »', '[{"id":"a","text":"à titre d''exemple"},{"id":"b","text":"voire"},{"id":"c","text":"en outre"},{"id":"d","text":"somme toute"}]'::jsonb, 'd', '« Somme toute » (« après tout, finalement ») clôt et nuance le bilan : connecteur de conclusion adapté. « À titre d''exemple » illustre, « voire » gradue, « en outre » ajoute un argument — aucun ne referme la synthèse.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74939bea-4e57-5c80-beae-39c7a10fb185', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Complétez correctement : « Il a tout planifié à l''avance, de sorte que rien ___ laissé au hasard. » (fait constaté : conséquence)', '[{"id":"a","text":"ne soit"},{"id":"b","text":"n''a été"},{"id":"c","text":"ne fût"},{"id":"d","text":"ne fut"}]'::jsonb, 'b', '« De sorte que » + indicatif = conséquence avérée : « rien n''a été laissé au hasard ». Le subjonctif (« ne soit », « ne fût ») exprimerait un but (intention), ce qui ne convient pas à un résultat constaté ; « ne fut » (passé simple) ne s''emploierait pas ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24b91a4b-d79f-510a-ab69-34782d223621', '3bd675de-ab5e-5115-bb00-cf6f7c0c457e', 'Repérez l''emploi FAUTIF de « d''autant plus que ».', '[{"id":"a","text":"Le sujet me passionne, d''autant plus qu''il touche à mon métier."},{"id":"b","text":"La décision est urgente, d''autant plus que les délais se resserrent."},{"id":"c","text":"Les délais se resserrent, d''autant plus que la décision est urgente."},{"id":"d","text":"Je préfère partir tôt, d''autant plus que la route est longue."}]'::jsonb, 'c', '« D''autant plus que » renforce la cause de l''énoncé principal. En (c), c''est l''urgence qui devrait justifier le resserrement, or la logique est inversée : on attendrait plutôt « d''où » ou « par conséquent ». En (a), (b) et (d), la subordonnée renforce bien la raison de la principale.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eca7f174-72c2-5005-b2ef-ca1dbb76f0b7', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', 'Quel est l''équivalent le plus SOUTENU du mot « bagnole » ?', '[{"id":"a","text":"une voiture"},{"id":"b","text":"une automobile"},{"id":"c","text":"une caisse"},{"id":"d","text":"une bagnole"}]'::jsonb, 'b', '« Automobile » appartient au registre soutenu. « Voiture » est le terme courant (neutre), « caisse » et « bagnole » sont familiers. L''échelle complète est : caisse/bagnole (familier) → voiture (courant) → automobile (soutenu).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1b74aa2-bf6a-534a-8c3d-0c6ecb723ee5', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', 'Parmi ces interrogations qui ont le même sens, laquelle relève du registre SOUTENU ?', '[{"id":"a","text":"Tu viens ?"},{"id":"b","text":"Est-ce que tu viens ?"},{"id":"c","text":"Viens-tu ?"},{"id":"d","text":"Tu viens, quoi ?"}]'::jsonb, 'c', '« Viens-tu ? » utilise l''inversion du sujet, marque du registre soutenu. L''intonation seule (« Tu viens ? ») est familière, « est-ce que » est courant, et l''ajout de « quoi » est familier.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46e183c3-59aa-50d1-9476-427c5221e37d', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', 'Dans la phrase familière « J''sais pas si on y va », quel trait disparaît par rapport au registre courant ?', '[{"id":"a","text":"Le « ne » de la négation est omis."},{"id":"b","text":"Le verbe est au mauvais temps."},{"id":"c","text":"Le sujet est inversé."},{"id":"d","text":"Le pronom complément est doublé."}]'::jsonb, 'a', 'À l''oral familier, le « ne » de la négation est très souvent omis (« j''sais pas » au lieu de « je ne sais pas »). En registre courant et soutenu, on rétablit toujours « ne… pas ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adab297b-7f69-5194-adde-898c547a0cae', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', 'Lequel de ces mots est un MARQUEUR du registre familier ?', '[{"id":"a","text":"cela"},{"id":"b","text":"nous"},{"id":"c","text":"ça"},{"id":"d","text":"lequel"}]'::jsonb, 'c', '« ça » est la forme familière de « cela ». De même, « on » remplace familièrement « nous ». « Cela », « nous » et « lequel » appartiennent au registre courant ou soutenu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a422db06-1499-5672-a004-905c4a14a167', 'b3dad98b-0d80-57d3-8edd-9bf485f6e3d1', 'Pour conclure une lettre de candidature, quelle formule est appropriée au registre SOUTENU ?', '[{"id":"a","text":"Allez, à plus, merci d''avance !"},{"id":"b","text":"Veuillez agréer mes salutations distinguées."},{"id":"c","text":"Bisous et bon courage."},{"id":"d","text":"Voilà, j''attends ta réponse, quoi."}]'::jsonb, 'b', '« Veuillez agréer mes salutations distinguées » est la formule de politesse figée du registre soutenu, attendue dans une lettre formelle. Les autres options sont familières et inadaptées à une candidature.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', '⭐ Entraînement : les registres de langue', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07a05e25-3ef4-5576-aa3c-c60eee1c5472', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Quel est l''équivalent COURANT (neutre) du verbe familier « bosser » ?', '[{"id":"a","text":"œuvrer"},{"id":"b","text":"bûcher"},{"id":"c","text":"trimer"},{"id":"d","text":"travailler"}]'::jsonb, 'd', '« Travailler » est le verbe courant et neutre. « Bosser », « trimer » et « bûcher » sont familiers. « Œuvrer » serait, lui, soutenu. L''échelle : bosser (familier) → travailler (courant) → œuvrer (soutenu).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a251507c-5c2b-5b07-b96f-40d6b7632500', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Quel mot appartient au registre FAMILIER pour désigner l''argent ?', '[{"id":"a","text":"les fonds"},{"id":"b","text":"les deniers"},{"id":"c","text":"l''argent"},{"id":"d","text":"le fric"}]'::jsonb, 'd', '« Le fric » est familier. « L''argent » est courant, tandis que « les fonds » et « les deniers » relèvent du soutenu. On a donc : fric (familier) → argent (courant) → fonds/deniers (soutenu).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('006fe8e5-ccbd-5d14-a9ce-937d3214778b', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Quel est l''équivalent SOUTENU du verbe « manger » ?', '[{"id":"a","text":"bouffer"},{"id":"b","text":"grailler"},{"id":"c","text":"se restaurer"},{"id":"d","text":"casser la croûte"}]'::jsonb, 'c', '« Se restaurer » (ou « se sustenter ») appartient au registre soutenu. « Bouffer », « grailler » et « casser la croûte » sont familiers. L''échelle : bouffer (familier) → manger (courant) → se restaurer (soutenu).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc6e2e87-b52d-5369-8cf9-15715cd8be9a', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Dans une phrase soignée, par quoi remplace-t-on le mot familier « un truc » ?', '[{"id":"a","text":"un machin"},{"id":"b","text":"un bidule"},{"id":"c","text":"une chose"},{"id":"d","text":"un schmilblick"}]'::jsonb, 'c', '« Une chose » est le terme courant et neutre qui remplace le familier « un truc » (et son équivalent soutenu serait « un objet, un élément »). « Machin », « bidule » et « schmilblick » sont tout aussi familiers que « truc ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0120ab12-517f-5792-a2e3-f50bf59571cd', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Quelle interrogation relève du registre COURANT (ni familier, ni soutenu) ?', '[{"id":"a","text":"Tu pars quand ?"},{"id":"b","text":"Est-ce que tu pars bientôt ?"},{"id":"c","text":"Pars-tu prochainement ?"},{"id":"d","text":"Tu pars, là ?"}]'::jsonb, 'b', '« Est-ce que tu pars bientôt ? » est le tour courant. L''intonation seule (« Tu pars quand ? », « Tu pars, là ? ») est familière, et l''inversion (« Pars-tu… ? ») est soutenue.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('317751a4-9214-5e9c-85c1-1f9203c3cee1', '3ac39a44-c31e-5e0e-912d-7bdb8f4da54d', 'Quelle phrase appartient sans ambiguïté au registre FAMILIER ?', '[{"id":"a","text":"Nous ne savons pas s''il viendra."},{"id":"b","text":"Nous ignorons s''il sera présent."},{"id":"c","text":"Il convient d''attendre sa venue."},{"id":"d","text":"On sait pas s''il vient."}]'::jsonb, 'd', '« On sait pas s''il vient » cumule deux marques familières : « on » pour « nous » et l''omission du « ne » de la négation. Les options (a) et (b) sont courantes/soutenues, et (c) (« il convient de ») est franchement soutenue.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ec9d96dd-58fc-551d-acb8-75a2222c57b7', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', '⭐⭐ Révision : les registres de langue', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1bb9ee6-b5a2-5e33-94cb-0a5a0328d111', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Classe correctement : laquelle de ces trois formes appartient au registre SOUTENU ?', '[{"id":"a","text":"la flotte"},{"id":"b","text":"l''eau"},{"id":"c","text":"le pinard"},{"id":"d","text":"l''eau potable"}]'::jsonb, 'd', '« L''eau potable » relève du registre soutenu ou technique. « La flotte » est familier, « l''eau » est courant, et « le pinard » (= le vin) est familier et n''est même pas un synonyme d''eau : c''est un intrus de sens.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74d3bbc8-066b-560d-a3cf-203bf364b07b', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Quelle phrase est écrite dans un registre COURANT homogène, adapté à un courriel professionnel neutre ?', '[{"id":"a","text":"Pouvez-vous m''envoyer le document ?"},{"id":"b","text":"Tu m''balances le doc ?"},{"id":"c","text":"Je vous saurais gré de bien vouloir me transmettre ledit document."},{"id":"d","text":"Envoie-moi le truc, quoi."}]'::jsonb, 'a', '« Pouvez-vous m''envoyer le document ? » est neutre et homogène : lexique courant, négation et politesse correctes. (b) et (d) sont familiers (« balances », « truc », « quoi »), et (c) est franchement soutenu (« je vous saurais gré », « ledit »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('778dc34c-25bb-5ad8-a73f-e05647edd7c5', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Trouve la phrase où le registre est INCOHÉRENT (mélange de soutenu et de familier).', '[{"id":"a","text":"Je vous saurais gré de bien vouloir patienter."},{"id":"b","text":"Je vous saurais gré de m''envoyer ce truc rapidement."},{"id":"c","text":"Pouvez-vous patienter quelques instants ?"},{"id":"d","text":"Tu peux attendre deux minutes ?"}]'::jsonb, 'b', 'Phrase (b) commence en soutenu (« je vous saurais gré ») et bascule dans le familier (« ce truc »). Ce mélange est une faute de registre. (a) est tout soutenu, (c) tout courant, (d) tout familier : chacune est homogène.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('375dd66c-e0a4-53ee-981c-be8b21d26b3a', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Pour rendre la phrase « On va bouffer un truc, là » plus COURANTE, quelle réécriture choisir ?', '[{"id":"a","text":"Nous allons nous sustenter d''un mets."},{"id":"b","text":"On va grailler vite fait."},{"id":"c","text":"Nous allons manger quelque chose."},{"id":"d","text":"On bouffe un machin, quoi."}]'::jsonb, 'c', '« Nous allons manger quelque chose » remplace « on » par « nous », « bouffer » par « manger », « un truc » par « quelque chose » et supprime « là ». (a) est trop soutenu (« nous sustenter », « un mets »), (b) et (d) restent familiers.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('405fcb52-6f49-5b8a-9df8-36a167168887', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Quel mot est une TRONCATION familière qu''on développe à l''écrit soigné ?', '[{"id":"a","text":"ordinateur"},{"id":"b","text":"ordi"},{"id":"c","text":"appareil"},{"id":"d","text":"machine"}]'::jsonb, 'b', '« Ordi » est la troncation familière d''« ordinateur ». La troncation (resto, ado, frigo, appart) est un marqueur familier rapide à repérer ; à l''écrit soigné, on rétablit le mot entier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed5c92c6-f766-546f-aeb3-7be6de7aee57', 'ec9d96dd-58fc-551d-acb8-75a2222c57b7', 'Quel est l''équivalent COURANT (neutre) du verbe familier « crever » (au sens de mourir) ?', '[{"id":"a","text":"décéder"},{"id":"b","text":"s''éteindre"},{"id":"c","text":"mourir"},{"id":"d","text":"trépasser"}]'::jsonb, 'c', '« Mourir » est le verbe courant et neutre. « Crever » est familier ; « décéder », « s''éteindre » et « trépasser » relèvent du soutenu ou de l''euphémisme administratif. L''échelle : crever (familier) → mourir (courant) → décéder/s''éteindre (soutenu).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bf5925da-167d-5945-982d-6873f2048151', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : les registres de langue', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8529851c-5503-541d-baae-656cab549097', 'bf5925da-167d-5945-982d-6873f2048151', 'Un candidat écrit à un recruteur : « Salut, je voulais savoir si vous embauchez encore, répondez-moi vite. » Quel défaut de registre principal présente ce message ?', '[{"id":"a","text":"Il est trop soutenu pour un courriel."},{"id":"b","text":"Il emploie une inversion interdite à l''écrit."},{"id":"c","text":"Il manque de mots d''appui comme « quoi »."},{"id":"d","text":"Il est familier alors que le destinataire et la situation exigent le soutenu."}]'::jsonb, 'd', 'Le destinataire (un recruteur) et la situation (une candidature) imposent le registre soutenu ; or « Salut », « je voulais savoir », « répondez-moi vite » sont familiers ou trop directs. Le défaut est l''inadéquation du registre familier au contexte formel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56fe0e27-4f4d-5b8e-9085-0f808908572d', 'bf5925da-167d-5945-982d-6873f2048151', 'Quelle réécriture fait passer « Tu veux quoi ? » du familier au registre SOUTENU sans erreur ?', '[{"id":"a","text":"Qu''est-ce que tu veux ?"},{"id":"b","text":"Qu''est-ce que c''est que tu veux ?"},{"id":"c","text":"Tu veux quoi, exactement ?"},{"id":"d","text":"Que veux-tu ?"}]'::jsonb, 'd', '« Que veux-tu ? » emploie le pronom interrogatif « que » et l''inversion du sujet : c''est le tour soutenu. « Qu''est-ce que tu veux ? » est seulement courant, et les autres restent familières ou fautives (« qu''est-ce que c''est que »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17240c5e-c4e5-5b23-a575-e40215ddc70c', 'bf5925da-167d-5945-982d-6873f2048151', 'Dans laquelle de ces phrases le registre est-il parfaitement HOMOGÈNE (soutenu de bout en bout) ?', '[{"id":"a","text":"Il convient de régler cette histoire au plus vite."},{"id":"b","text":"Il convient d''apporter une réponse à cette question dans les meilleurs délais."},{"id":"c","text":"Faut régler ce problème, et vite."},{"id":"d","text":"Il convient de gérer ce truc rapidos."}]'::jsonb, 'b', 'Phrase (b) est homogène : « il convient de », « apporter une réponse », « dans les meilleurs délais » sont tous soutenus. (a) mêle « il convient de » et le familier « cette histoire » ; (c) est familier (« faut ») ; (d) bascule dans « ce truc, rapidos ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de202391-5ded-5a45-867c-a3881fc9c8d5', 'bf5925da-167d-5945-982d-6873f2048151', 'Soit la phrase familière : « On a rien capté, du coup on s''est cassés. » Quelle est sa réécriture COURANTE correcte ?', '[{"id":"a","text":"Nous n''avons rien compris ; nous sommes donc partis."},{"id":"b","text":"On n''a rien compris, du coup on est partis."},{"id":"c","text":"Nous n''eûmes rien saisi ; partant, nous prîmes congé."},{"id":"d","text":"On a rien pigé, alors on a filé."}]'::jsonb, 'a', 'Le passage au courant exige « nous » pour « on », le « ne » rétabli, « compris » pour « capté », « partis » pour « cassés », et « donc » pour « du coup ». (b) garde « on » et « du coup », (c) est excessivement soutenu (passé simple, « partant »), (d) reste familier.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f2b0fa6-2ace-5926-9adf-420597029bc9', 'bf5925da-167d-5945-982d-6873f2048151', 'Quelle formule de demande convient à une LETTRE administrative (registre soutenu) ?', '[{"id":"a","text":"Je vous saurais gré de bien vouloir m''adresser ce document."},{"id":"b","text":"Vous pouvez m''envoyer le document, merci."},{"id":"c","text":"Pensez à m''envoyer le doc dès que possible."},{"id":"d","text":"Faut que vous m''envoyiez le document."}]'::jsonb, 'a', '« Je vous saurais gré de bien vouloir… » est la tournure de demande propre au registre soutenu administratif. (b) est courant, (c) un peu trop direct, et (d) est familier (« faut que ») et fautif de registre dans une lettre officielle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a928149a-e459-5966-b280-4095a9153cc3', 'bf5925da-167d-5945-982d-6873f2048151', 'Parmi ces quatre phrases au même sens, laquelle MÉLANGE deux registres et constitue donc une faute ?', '[{"id":"a","text":"Nous vous prions d''agréer nos salutations distinguées."},{"id":"b","text":"Veuillez patienter, on revient tout de suite."},{"id":"c","text":"Merci de patienter quelques instants."},{"id":"d","text":"Attends deux secondes, je reviens."}]'::jsonb, 'b', 'Phrase (b) ouvre en soutenu (« Veuillez patienter ») puis tombe dans le familier (« on revient tout de suite », avec « on » pour « nous »). Ce contraste interne est la faute. (a) est tout soutenu, (c) courant, (d) familier : chacune reste cohérente.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c916cb89-0f34-5c17-8832-28f8fa7b3df0', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : les registres de langue', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0515d80d-53fa-50e9-bbe4-063eb282216e', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Texte familier : « Salut, on s''est plantés sur le devis, du coup faut qu''on refasse les chiffres avant lundi. » Quelle réécriture pour un courriel professionnel SOUTENU est la plus complète et correcte ?', '[{"id":"a","text":"Bonjour, une erreur s''est glissée dans le devis ; il convient donc de réviser les chiffres avant lundi."},{"id":"b","text":"Bonjour, on a fait une erreur sur le devis, du coup il faut refaire les chiffres avant lundi."},{"id":"c","text":"Salut, le devis est faux, faut revoir tout ça avant lundi."},{"id":"d","text":"Bonjour, nous nous sommes plantés sur le devis ; il convient de le refaire fissa."}]'::jsonb, 'a', 'Seule (a) est homogène et soutenue : « une erreur s''est glissée », « il convient de réviser », « donc » pour « du coup », et l''abandon de « on » et de « faut qu''on ». (b) garde « on » et « du coup » ; (c) reste familier (« Salut », « faux », « faut ») ; (d) mêle le soutenu « il convient » au familier « plantés » et « fissa ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7167097e-0b53-5a2c-81a2-96e9d9970ab8', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Identifie la phrase dont TOUS les éléments (lexique, négation, interrogation) appartiennent au registre soutenu, sans aucune dissonance.', '[{"id":"a","text":"Ne conviendrait-il pas de différer cette décision ?"},{"id":"b","text":"Est-ce qu''il faudrait pas reporter ce truc ?"},{"id":"c","text":"Ne conviendrait-il pas de différer ce machin ?"},{"id":"d","text":"On devrait pas plutôt repousser cette décision ?"}]'::jsonb, 'a', 'Phrase (a) est intégralement soutenue : inversion (« conviendrait-il »), négation complète, verbe « différer », nom « décision ». (b) omet le « ne » et emploie « truc » ; (c) garde l''inversion mais glisse « machin » (familier) ; (d) emploie « on », omet « ne » et reste courant/familier.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b293d4c1-d6a3-5f56-8938-157be5647429', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Dans la phrase « Veuillez nous excuser pour ce contretemps, on vous tient au jus dès que possible », quel élément précis trahit la RUPTURE de registre ?', '[{"id":"a","text":"« Veuillez nous excuser »"},{"id":"b","text":"« pour ce contretemps »"},{"id":"c","text":"« on vous tient au jus »"},{"id":"d","text":"« dès que possible »"}]'::jsonb, 'c', '« On vous tient au jus » est familier (« on » pour « nous » et l''expression argotique « tenir au jus » = informer) au sein d''une phrase ouverte par le soutenu « Veuillez nous excuser ». Les autres segments (« contretemps », « dès que possible ») restent dans un registre soutenu ou courant cohérent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51e62ab9-b1c9-5dd6-a89c-4141ad5ba4de', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Une consigne familière dit : « Bouge pas, je reviens dans deux secondes. » Quelle version respecte un registre SOUTENU homogène ?', '[{"id":"a","text":"Bougez pas, je reviens dans un instant."},{"id":"b","text":"Veuillez ne pas vous éloigner, je reviens dans un instant."},{"id":"c","text":"Reste là, je reviens dans deux secondes."},{"id":"d","text":"Veuillez ne pas bouger, je reviens dans deux secondes, quoi."}]'::jsonb, 'b', 'Phrase (b) est homogène et soutenue : « Veuillez ne pas vous éloigner », négation complète, « dans un instant ». (a) omet le « ne » (« Bougez pas »), (c) est courant/familier (« Reste là »), et (d) gâche le soutenu « Veuillez » par « deux secondes » et le mot d''appui familier « quoi ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a20edc5-ec3c-5846-ae65-e7ba1b417d64', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Quel énoncé constitue une CORRESPONDANCE de registre ERRONÉE entre une forme familière et son équivalent soutenu ?', '[{"id":"a","text":"bosser → œuvrer"},{"id":"b","text":"le fric → les deniers"},{"id":"c","text":"bouffer → décéder"},{"id":"d","text":"la bagnole → l''automobile"}]'::jsonb, 'c', '« bouffer → décéder » est faux : « décéder » est le synonyme soutenu de « mourir », non de « manger » (dont l''équivalent soutenu est « se restaurer »). Les autres paires sont exactes : bosser/œuvrer, fric/deniers, bagnole/automobile relient bien un terme familier à son équivalent soutenu.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa8391d1-7048-5ece-b7e4-6a77b912dbf1', 'c916cb89-0f34-5c17-8832-28f8fa7b3df0', 'Un même message doit être adapté à trois destinataires. Quelle association situation → formulation est CORRECTE et cohérente ?', '[{"id":"a","text":"À un ami (SMS) : « Je vous saurais gré de me confirmer votre présence. »"},{"id":"b","text":"À un collègue (courriel neutre) : « Peux-tu me confirmer ta présence ? »"},{"id":"c","text":"À un directeur (lettre) : « Tu confirmes que tu viens ? »"},{"id":"d","text":"À un ami (SMS) : « Auriez-vous l''obligeance de confirmer votre venue ? »"}]'::jsonb, 'b', 'L''association (b) est juste : un courriel à un collègue appelle un registre courant, et « Peux-tu me confirmer ta présence ? » y correspond. (a) et (d) plaquent du soutenu sur un SMS amical (inadéquat), et (c) emploie du familier (« Tu confirmes ? ») dans une lettre au directeur, qui exige le soutenu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e5743058-e69b-561e-ba4d-fcf65902ca80', '50f269b2-88c1-51eb-801b-1bf230e573a0', 'francais-c1', '⭐⭐ Drill : les registres de langue', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df93e06b-9076-516a-b8f0-c6078c53d085', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Quel est l''équivalent FAMILIER du mot courant « un homme » ?', '[{"id":"a","text":"un individu"},{"id":"b","text":"un personnage"},{"id":"c","text":"un monsieur"},{"id":"d","text":"un mec"}]'::jsonb, 'd', '« Un mec » (ou « un type ») est familier. « Un homme » est courant, et « un individu » ou « un monsieur » relèvent du soutenu ou du neutre administratif. L''échelle : mec/type (familier) → homme (courant) → individu (soutenu).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bab77483-ac97-5160-ae01-150ca2bdc7a1', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Quelle phrase emploie une négation conforme au registre SOUTENU et courant (et non familier) ?', '[{"id":"a","text":"J''ai pas eu le temps."},{"id":"b","text":"J''sais pas trop."},{"id":"c","text":"Je n''ai pas reçu votre réponse."},{"id":"d","text":"On comprend pas."}]'::jsonb, 'c', '« Je n''ai pas reçu votre réponse » rétablit le « ne » de la négation, comme l''exigent les registres courant et soutenu. Les autres options omettent le « ne » (« j''ai pas », « j''sais pas », « comprend pas »), marque de l''oral familier.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03cb9e82-e491-5b9a-b122-e623c61e4f36', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Pour développer la troncation familière « l''aprèm » à l''écrit soigné, on écrit :', '[{"id":"a","text":"l''après-midi"},{"id":"b","text":"l''aprèm''"},{"id":"c","text":"le tantôt"},{"id":"d","text":"l''aprème"}]'::jsonb, 'a', '« L''après-midi » est la forme entière et neutre. « L''aprèm » est une troncation familière : à l''écrit soigné on restitue le mot complet. « Le tantôt » est régional/familier, et les autres ne sont que des variantes de la troncation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('673b95bc-ab98-59df-90f0-65da78bab15c', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Trouve la phrase où le registre est INCOHÉRENT.', '[{"id":"a","text":"Force est de constater que les résultats sont décevants."},{"id":"b","text":"Force est de constater que c''est nul."},{"id":"c","text":"Les résultats sont décevants, c''est clair."},{"id":"d","text":"Les résultats sont vraiment pas terribles."}]'::jsonb, 'b', 'Phrase (b) ouvre sur la tournure soutenue « Force est de constater que » et bascule dans le familier « c''est nul ». Ce contraste est la faute. (a) reste soutenue, (c) courante, (d) familière : chacune est homogène.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a18ebc64-0459-56a7-9aa4-972515c6c80a', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Quelle réécriture fait passer « Tu m''files un coup de main ? » au registre COURANT correct ?', '[{"id":"a","text":"Auriez-vous l''amabilité de me prêter assistance ?"},{"id":"b","text":"Peux-tu m''aider ?"},{"id":"c","text":"Tu peux me filer un coup de main ?"},{"id":"d","text":"Tu m''aides, quoi ?"}]'::jsonb, 'b', '« Peux-tu m''aider ? » remplace l''expression familière « filer un coup de main » par le verbe neutre « aider » : c''est le registre courant. (a) est trop soutenue, (c) garde « filer un coup de main », et (d) ajoute le mot d''appui familier « quoi ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7961debb-958c-5935-9998-ae78ffa809d3', 'e5743058-e69b-561e-ba4d-fcf65902ca80', 'Quelle association forme une échelle de registre EXACTE (familier → courant → soutenu) ?', '[{"id":"a","text":"le boulot → le travail → la besogne"},{"id":"b","text":"le boulot → la besogne → le travail"},{"id":"c","text":"le travail → le boulot → la besogne"},{"id":"d","text":"la besogne → le travail → le boulot"}]'::jsonb, 'a', 'L''ordre correct est « le boulot » (familier) → « le travail » (courant) → « la besogne » (soutenu/littéraire). Les autres options intervertissent les niveaux, plaçant par exemple « boulot » (familier) après le neutre ou en mettant « besogne » au début.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e87c512-893f-511b-af1e-d68d0cd4f98d', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', 'Que signifie l''expression « tomber dans le panneau » ?', '[{"id":"a","text":"Heurter un panneau de signalisation."},{"id":"b","text":"Se laisser piéger, se faire avoir par une ruse."},{"id":"c","text":"Échouer à un examen."},{"id":"d","text":"Tomber malade subitement."}]'::jsonb, 'b', '« Tomber dans le panneau » signifie se laisser prendre à un piège ou à une ruse. Le « panneau » était à l''origine un filet de chasse, d''où l''idée de se faire attraper. L''option (a) prend l''image au pied de la lettre ; (c) et (d) inventent des sens sans rapport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8eb330ab-e1fa-586f-b7f4-c767a5a16a21', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', '« Il a le bras long » : que veut-on dire de cette personne ?', '[{"id":"a","text":"Elle est grande et mince."},{"id":"b","text":"Elle est généreuse de son temps."},{"id":"c","text":"Elle travaille beaucoup de ses mains."},{"id":"d","text":"Elle a beaucoup d''influence et de relations."}]'::jsonb, 'd', '« Avoir le bras long » signifie disposer d''influence et de relations puissantes, capables d''agir loin. L''option (a) est une lecture littérale ; (b) et (c) confondent l''image avec d''autres qualités sans rapport avec le pouvoir d''intervention.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ad16aee-fdb7-519e-b21b-f2d2d22a2e53', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', 'Complète : « Inutile de chercher davantage : je donne ma langue ___. »', '[{"id":"a","text":"au chat"},{"id":"b","text":"aux bœufs"},{"id":"c","text":"à la pâte"},{"id":"d","text":"au panneau"}]'::jsonb, 'a', '« Donner sa langue au chat » signifie renoncer à deviner, avouer qu''on ne trouve pas la réponse. Les autres propositions mélangent des morceaux d''expressions différentes (mettre la charrue avant les bœufs, mettre la main à la pâte, tomber dans le panneau) qui n''existent pas sous cette forme.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f526034c-df66-5faf-8f46-701ffc323c58', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', 'Que signifie le mot soutenu « fortuit » ?', '[{"id":"a","text":"Qui est très solide, résistant."},{"id":"b","text":"Qui est riche, fortuné."},{"id":"c","text":"Qui arrive par hasard, de façon imprévue."},{"id":"d","text":"Qui est prévu de longue date."}]'::jsonb, 'c', '« Fortuit » qualifie ce qui survient par hasard, sans avoir été prévu (une rencontre fortuite). L''option (b) est un faux ami avec « fortuné » (riche) ; (a) confond avec « fort » ; (d) en est l''exact contraire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f961eb9-62bc-5749-a1f4-d26c33a337dd', '098a84d6-5e12-5dbf-a5cb-2b5bab5d63a0', 'Quelle phrase emploie correctement le verbe « pallier » ?', '[{"id":"a","text":"Cette aide permet de pallier à la pénurie de personnel."},{"id":"b","text":"Cette aide permet de pallier la pénurie de personnel."},{"id":"c","text":"Cette aide permet de pallier à ce que le personnel manque."},{"id":"d","text":"Cette aide permet de pallier de la pénurie de personnel."}]'::jsonb, 'b', '« Pallier » est un verbe transitif direct : on pallie quelque chose, sans préposition. On dit donc « pallier la pénurie ». Les formes « pallier à » (a, c) et « pallier de » (d) sont des fautes très répandues mais sanctionnées au niveau C1.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5ba79a1e-0e62-5660-a8b0-19da0c897234', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', '⭐ Entraînement : expressions imagées et lexique soutenu', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18dee952-a530-5053-9d24-2e93353b3227', '5ba79a1e-0e62-5660-a8b0-19da0c897234', 'Que signifie « mettre la charrue avant les bœufs » ?', '[{"id":"a","text":"Travailler très dur aux champs."},{"id":"b","text":"Préparer soigneusement un projet."},{"id":"c","text":"Faire les choses dans le mauvais ordre."},{"id":"d","text":"Avancer plus vite que prévu."}]'::jsonb, 'c', '« Mettre la charrue avant les bœufs » signifie inverser l''ordre logique des étapes, commencer par ce qui devrait venir ensuite. L''image : les bœufs tirent la charrue, les placer derrière est absurde. L''option (a) prend l''image au pied de la lettre ; (b) et (d) inventent des sens contraires.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee2d1f86-4268-5a85-a14f-2fd41b336c5a', '5ba79a1e-0e62-5660-a8b0-19da0c897234', '« Après des mois de désaccord, ils ont fini par couper la poire en deux. » Que veut dire l''expression ?', '[{"id":"a","text":"Faire un compromis, partager équitablement."},{"id":"b","text":"Se séparer définitivement."},{"id":"c","text":"Partager un repas ensemble."},{"id":"d","text":"Choisir la moins bonne solution."}]'::jsonb, 'a', '« Couper la poire en deux » signifie trouver un compromis en partageant la différence. Le contexte (« après des mois de désaccord ») confirme l''idée d''accord négocié. L''option (b) est le contraire ; (c) prend l''image au sens propre ; (d) ajoute un jugement absent de l''expression.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46572621-ce44-5987-bdcf-a91f0e6b0763', '5ba79a1e-0e62-5660-a8b0-19da0c897234', 'Quel mot soutenu signifie « la bienveillance indulgente, la clémence » ?', '[{"id":"a","text":"L''acharnement."},{"id":"b","text":"L''amertume."},{"id":"c","text":"La méfiance."},{"id":"d","text":"La mansuétude."}]'::jsonb, 'd', '« La mansuétude » désigne une douceur indulgente, une disposition à pardonner. L''« acharnement » (a) est au contraire l''obstination, parfois cruelle ; l''amertume (b) et la méfiance (c) sont des sentiments négatifs sans rapport avec l''indulgence.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b7a9be9-aaad-58ad-b367-9e3058e6d4f9', '5ba79a1e-0e62-5660-a8b0-19da0c897234', 'Complète : « Ses promesses étaient ___ : elles n''avaient pour but que de nous tromper. »', '[{"id":"a","text":"fortuites"},{"id":"b","text":"fallacieuses"},{"id":"c","text":"imminentes"},{"id":"d","text":"éminentes"}]'::jsonb, 'b', '« Fallacieux » signifie trompeur, destiné à induire en erreur — exactement le sens donné par « tromper ». « Fortuit » (a) signifie dû au hasard ; « imminent » (c) signifie très proche ; « éminent » (d) signifie remarquable. Seul (b) correspond au piège tendu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b875923-c964-5a12-bb4f-7e0b969fa67c', '5ba79a1e-0e62-5660-a8b0-19da0c897234', 'Que signifie « un coup d''épée dans l''eau » ?', '[{"id":"a","text":"Une action vaine, sans aucun effet."},{"id":"b","text":"Une attaque soudaine et violente."},{"id":"c","text":"Une décision risquée mais payante."},{"id":"d","text":"Un effort partagé entre plusieurs personnes."}]'::jsonb, 'a', '« Un coup d''épée dans l''eau » désigne une tentative inutile, qui ne produit aucun résultat — comme frapper l''eau sans rien atteindre. L''option (b) retient l''idée de violence mais oublie l''inefficacité ; (c) et (d) inventent des sens absents de l''image.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b573395-82ef-5a2e-8e89-c4f4c56c1e31', '5ba79a1e-0e62-5660-a8b0-19da0c897234', 'Quel verbe soutenu signifie « se révéler exact à l''usage » ?', '[{"id":"a","text":"Escompter."},{"id":"b","text":"Susciter."},{"id":"c","text":"S''avérer."},{"id":"d","text":"Déroger."}]'::jsonb, 'c', '« S''avérer » signifie se révéler vrai, exact à l''usage (le radical vient du latin verus, « vrai ») : le projet s''est avéré rentable. « Escompter » (a) = espérer ; « susciter » (b) = faire naître ; « déroger » (d) = manquer à une règle. Aucun de ces trois ne porte l''idée de « se révéler ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7fe0131c-e489-5ede-a1e0-21e27e536de2', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', '⭐⭐ Révision : locutions figées et mot juste', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3bf62ff-c251-5c5c-b301-c5200daa953f', '7fe0131c-e489-5ede-a1e0-21e27e536de2', '« Depuis le départ du fondateur, l''entreprise bat de l''aile. » Que signifie cette locution ?', '[{"id":"a","text":"Elle se développe très rapidement."},{"id":"b","text":"Elle est en difficulté, elle périclite."},{"id":"c","text":"Elle change souvent de direction."},{"id":"d","text":"Elle recrute beaucoup de personnel."}]'::jsonb, 'b', '« Battre de l''aile » se dit d''une chose qui fonctionne mal, qui décline — comme un oiseau blessé. Le contexte (« depuis le départ du fondateur ») confirme la dégradation. L''option (a) est le contraire ; (c) et (d) inventent des sens étrangers à l''image de l''affaiblissement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cfe2584-950b-55ab-a75b-07c8b150216c', '7fe0131c-e489-5ede-a1e0-21e27e536de2', 'Quelle expression veut dire « avoir le droit de donner son avis, de participer à une décision » ?', '[{"id":"a","text":"Faire la part des choses."},{"id":"b","text":"Prendre son mal en patience."},{"id":"c","text":"Mettre la main à la pâte."},{"id":"d","text":"Avoir voix au chapitre."}]'::jsonb, 'd', '« Avoir voix au chapitre » signifie avoir le droit d''intervenir dans une délibération (le « chapitre » désignait l''assemblée des religieux). « Faire la part des choses » (a) = nuancer ; « prendre son mal en patience » (b) = supporter ; « mettre la main à la pâte » (c) = participer au travail concret, non à la décision.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('452aa00c-8190-5c98-beaa-6cb707d7c5ab', '7fe0131c-e489-5ede-a1e0-21e27e536de2', 'Complète avec le mot soutenu : « La sécheresse n''a fait qu''___ les tensions entre les éleveurs. »', '[{"id":"a","text":"escompter"},{"id":"b","text":"déroger"},{"id":"c","text":"exacerber"},{"id":"d","text":"pallier"}]'::jsonb, 'c', '« Exacerber » signifie rendre plus intense, aviver — ce que fait la sécheresse aux tensions. « Escompter » (a) = espérer ; « déroger » (b) = manquer à une règle ; « pallier » (d) = compenser un manque, soit l''inverse d''aggraver. Seul « exacerber » exprime l''intensification.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db40cda6-7553-5f6a-9559-21201fa98cb0', '7fe0131c-e489-5ede-a1e0-21e27e536de2', '« Il a su tirer son épingle du jeu malgré la faillite générale. » Que veut dire l''expression ?', '[{"id":"a","text":"Se sortir habilement d''une situation délicate."},{"id":"b","text":"Abandonner la partie le premier."},{"id":"c","text":"Profiter du malheur des autres."},{"id":"d","text":"Prendre un gros risque inconsidéré."}]'::jsonb, 'a', '« Tirer son épingle du jeu » signifie se dégager adroitement d''une affaire compromise, en limitant les pertes. Le contexte (« malgré la faillite générale ») confirme l''idée de s''en sortir. L''option (b) est le contraire ; (c) ajoute un jugement moral absent ; (d) contredit l''habileté contenue dans l''expression.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db5bfd2f-5a61-5493-841b-174223ccc344', '7fe0131c-e489-5ede-a1e0-21e27e536de2', 'Quelle phrase est correcte au niveau C1 ?', '[{"id":"a","text":"Au jour d''aujourd''hui, rien n''est décidé."},{"id":"b","text":"Cette mesure s''est avérée vraie après coup."},{"id":"c","text":"Il faut pallier à ce manque de moyens."},{"id":"d","text":"À ce jour, aucune décision n''a été prise."}]'::jsonb, 'd', '« À ce jour » est correct et soutenu. « Au jour d''aujourd''hui » (a) est un double pléonasme. « S''avérer vraie » (b) est redondant car « s''avérer » contient déjà l''idée du vrai. « Pallier à » (c) est fautif : « pallier » est transitif direct. Seul (d) est irréprochable.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30aa8cca-a812-55b1-9add-1dde3a1c96f2', '7fe0131c-e489-5ede-a1e0-21e27e536de2', 'Quel mot signifie « la persévérance obstinée, parfois excessive » ?', '[{"id":"a","text":"La mansuétude."},{"id":"b","text":"L''acharnement."},{"id":"c","text":"Un comble."},{"id":"d","text":"Une polémique."}]'::jsonb, 'b', '« L''acharnement » désigne une ardeur obstinée, une ténacité qui peut aller jusqu''à l''excès (s''acharner sur un problème). « La mansuétude » (a) est au contraire l''indulgence ; « un comble » (c) est le point culminant ; « une polémique » (d) est une vive dispute. Seul (b) exprime l''obstination tenace.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('89186261-2abe-51fb-bfd3-7f059cdec3a2', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : expressions idiomatiques et lexique soutenu', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9779b1d6-b8e0-576d-b8a2-c0434fc68eba', '89186261-2abe-51fb-bfd3-7f059cdec3a2', '« Devant les preuves accablantes, l''accusé a fini par donner sa langue au chat. » Pourquoi cette phrase est-elle un contresens ?', '[{"id":"a","text":"« Donner sa langue au chat » signifie renoncer à deviner une devinette, non avouer une faute."},{"id":"b","text":"L''expression ne s''emploie qu''à propos d''enfants."},{"id":"c","text":"L''expression devrait être « donner sa langue aux chats » au pluriel."},{"id":"d","text":"L''expression signifie au contraire « parler abondamment »."}]'::jsonb, 'a', '« Donner sa langue au chat » signifie uniquement renoncer à trouver la réponse à une énigme, et non avouer ou capituler face à des preuves. Le contexte judiciaire appellerait « passer aux aveux ». L''option (c) invente un pluriel inexistant ; (b) et (d) attribuent à l''expression des restrictions ou des sens qu''elle n''a pas.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49dca535-d141-5fd0-adde-db4277347c23', '89186261-2abe-51fb-bfd3-7f059cdec3a2', 'Quel verbe complète correctement : « En accordant cette faveur, le directeur a ___ au règlement intérieur. » ?', '[{"id":"a","text":"exacerbé"},{"id":"b","text":"escompté"},{"id":"c","text":"dérogé"},{"id":"d","text":"suscité"}]'::jsonb, 'c', '« Déroger à » signifie s''écarter d''une règle, y faire exception — exactement le sens d''accorder une faveur contraire au règlement. Le verbe se construit avec « à », d''où « dérogé au règlement ». « Exacerber » (a) = intensifier ; « escompter » (b) = espérer ; « susciter » (d) = faire naître : aucun ne convient ici.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01e8d5e7-c19b-5799-a98e-8759c3dd59db', '89186261-2abe-51fb-bfd3-7f059cdec3a2', 'Trouve l''intrus : trois de ces expressions évoquent l''échec ou la difficulté ; laquelle ne le fait PAS ?', '[{"id":"a","text":"Un coup d''épée dans l''eau."},{"id":"b","text":"Tirer son épingle du jeu."},{"id":"c","text":"Battre de l''aile."},{"id":"d","text":"Prendre des vessies pour des lanternes."}]'::jsonb, 'b', '« Tirer son épingle du jeu » exprime au contraire la réussite : se sortir adroitement d''une situation difficile. Les trois autres relèvent de l''échec ou de l''erreur : un coup d''épée dans l''eau (action vaine), battre de l''aile (péricliter), prendre des vessies pour des lanternes (se tromper grossièrement). L''intrus est donc (b).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7fb6bc2-8648-5a08-ae2d-448f3a341e93', '89186261-2abe-51fb-bfd3-7f059cdec3a2', '« Le succès de ce produit, c''est bien ; mais le revers de la médaille, c''est la rupture de stock. » Quel sens prend ici « le revers de la médaille » ?', '[{"id":"a","text":"Une récompense méritée."},{"id":"b","text":"Un retournement complet de situation."},{"id":"c","text":"Une seconde chance offerte."},{"id":"d","text":"L''aspect négatif d''une chose par ailleurs positive."}]'::jsonb, 'd', '« Le revers de la médaille » désigne l''inconvénient qui accompagne un avantage — ici, la rupture de stock causée par le succès. La structure « c''est bien ; mais… » signale cette opposition. L''option (a) ne retient que le côté positif ; (b) confond avec un renversement total ; (c) invente un sens d''opportunité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f1c57c2-327b-525e-ac96-70ae65935512', '89186261-2abe-51fb-bfd3-7f059cdec3a2', 'Quelle phrase emploie « s''avérer » de façon irréprochable au niveau C1 ?', '[{"id":"a","text":"La rumeur s''est avérée inexacte après vérification."},{"id":"b","text":"La rumeur s''est avérée fausse après vérification."},{"id":"c","text":"La rumeur s''est avérée vraie après vérification."},{"id":"d","text":"La rumeur s''est avérée à fausse après vérification."}]'::jsonb, 'a', '« S''avérer » porte déjà l''idée du vrai, si bien que « s''avérer vraie » (c) est un pléonasme et « s''avérer fausse » (b) une contradiction interne tolérée mais déconseillée à l''écrit C1. On préfère « s''avérer inexacte » (a). La construction (d) avec « à » est agrammaticale.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a649635-85ea-53dc-838b-38f080288ee8', '89186261-2abe-51fb-bfd3-7f059cdec3a2', '« Laissons cela : nous avons d''autres chats à fouetter. » Que veut dire cette expression ?', '[{"id":"a","text":"Nous devons être plus sévères."},{"id":"b","text":"Nous manquons de temps libre."},{"id":"c","text":"Nous avons des préoccupations plus importantes."},{"id":"d","text":"Nous aimons les tâches difficiles."}]'::jsonb, 'c', '« Avoir d''autres chats à fouetter » signifie avoir des affaires plus pressantes ou plus importantes à régler. Le « laissons cela » du contexte confirme qu''on écarte un sujet secondaire. L''option (a) prend l''image du fouet au sens de sévérité ; (b) et (d) inventent des sens absents de la locution.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : expressions idiomatiques et lexique soutenu', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2ee4325-2c32-51dd-9026-56f84409ce32', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', 'Lis : « Le ministre a multiplié les annonces sans jamais agir : un véritable coup d''épée dans l''eau. » Quel mot soutenu résume le mieux le sens de l''expression dans ce contexte ?', '[{"id":"a","text":"Un acharnement."},{"id":"b","text":"Une polémique."},{"id":"c","text":"Un comble."},{"id":"d","text":"Une action vaine."}]'::jsonb, 'd', '« Un coup d''épée dans l''eau » désigne une action sans effet : ici, des annonces suivies d''aucun acte. « Une action vaine » (d) en est le synonyme exact. « Acharnement » (a) suppose une obstination ; « polémique » (b) une dispute ; « comble » (c) un point culminant : aucun ne rend l''idée d''inefficacité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a5648b3-0661-50e9-889b-bf6d0233d8df', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', 'Dans laquelle de ces phrases le verbe « pallier » est-il employé correctement ?', '[{"id":"a","text":"Ce dispositif permet de pallier à l''absence de transports."},{"id":"b","text":"Ce dispositif permet de pallier l''absence de transports."},{"id":"c","text":"Ce dispositif permet de pallier au manque de transports."},{"id":"d","text":"Ce dispositif permet de pallier face à l''absence de transports."}]'::jsonb, 'b', '« Pallier » est transitif direct : on pallie quelque chose, sans préposition (« pallier l''absence »). Les constructions « pallier à » (a, c) sont les fautes les plus fréquemment sanctionnées au DALF, et « pallier face à » (d) est tout aussi fautive. Seule (b) respecte la norme.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed702adc-ba89-5636-b9cd-4e0bb1f3e57b', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', '« Inutile de t''emballer sur ces chiffres : tu prends des vessies pour des lanternes. » Quelle reformulation soutenue conserve le sens ?', '[{"id":"a","text":"Tu te trompes lourdement et crois à une chose fausse."},{"id":"b","text":"Tu fais preuve d''un optimisme contagieux."},{"id":"c","text":"Tu exagères ton mérite personnel."},{"id":"d","text":"Tu hésites trop longtemps avant de décider."}]'::jsonb, 'a', '« Prendre des vessies pour des lanternes » signifie se tromper grossièrement, prendre une chose pour une autre, croire à une illusion. La reformulation (a) en restitue le sens. Les options (b), (c) et (d) évoquent l''optimisme, la vanité ou l''indécision, qui n''ont aucun rapport avec l''erreur de jugement décrite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c6a31e5-ab8c-5b22-84ab-3bbfe4909bc4', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', 'Trouve l''intrus : trois de ces tournures invitent à la prudence ou à la patience ; laquelle exprime autre chose ?', '[{"id":"a","text":"Faire la part des choses."},{"id":"b","text":"Prendre son mal en patience."},{"id":"c","text":"Mettre la charrue avant les bœufs."},{"id":"d","text":"Peser le pour et le contre."}]'::jsonb, 'c', '« Mettre la charrue avant les bœufs », c''est agir dans le désordre, soit l''inverse de la prudence : c''est l''intrus. Les trois autres relèvent de la mesure réfléchie : faire la part des choses (nuancer), prendre son mal en patience (attendre sans s''emporter), peser le pour et le contre (délibérer avant d''agir).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66671381-6f2a-539d-af08-6d5e79de0fe4', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', '« Après l''incident, il en avait gros sur le cœur. » Quel énoncé restitue le mieux le sens, registre soutenu compris ?', '[{"id":"a","text":"Il éprouvait une grande joie qu''il peinait à contenir."},{"id":"b","text":"Il nourrissait un ressentiment et une amertume qu''il taisait."},{"id":"c","text":"Il souffrait d''un véritable problème cardiaque."},{"id":"d","text":"Il manifestait bruyamment sa colère à tous."}]'::jsonb, 'b', '« En avoir gros sur le cœur » exprime une tristesse ou un ressentiment contenu, une peine qu''on garde pour soi. La reformulation (b) en rend la nuance d''amertume retenue. (a) inverse le sentiment ; (c) prend l''image au sens médical ; (d) contredit le caractère tu, retenu de l''émotion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('292981d1-7b67-54df-91a9-a85a2b979f1e', '3e8dad02-722f-5fe7-93e1-7fe1a08e44fe', 'Quelle phrase est intégralement correcte au niveau C1 (norme et sens) ?', '[{"id":"a","text":"Au jour d''aujourd''hui, ce remède pallie à bien des maux."},{"id":"b","text":"Son hypothèse s''est avérée vraie, ce qui a suscité à des débats."},{"id":"c","text":"Cette rencontre fortuite a exacerbé à la rivalité ancienne."},{"id":"d","text":"Cette aide ponctuelle ne pallie qu''en partie un manque structurel."}]'::jsonb, 'd', 'Seule (d) est irréprochable : « pallier » y est transitif direct (« pallie un manque ») et le sens tient. (a) cumule le pléonasme « au jour d''aujourd''hui » et la faute « pallie à » ; (b) le pléonasme « s''avérée vraie » et le fautif « suscité à » ; (c) ajoute un « à » indu après « exacerbé », verbe transitif direct.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('67639796-8e84-5376-a327-238826f1ad55', '1e9c013c-15ed-5c86-a7b5-e85d13ed7e17', 'francais-c1', '⭐⭐ Drill : révision globale du chapitre', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('958671d9-a0df-5565-bdb4-990d7943da5c', '67639796-8e84-5376-a327-238826f1ad55', 'Quel mot soutenu signifie « espérer, compter sur quelque chose à venir » ?', '[{"id":"a","text":"Déroger."},{"id":"b","text":"Exacerber."},{"id":"c","text":"Escompter."},{"id":"d","text":"S''avérer."}]'::jsonb, 'c', '« Escompter » signifie compter à l''avance sur un résultat, l''espérer (escompter une hausse des ventes). « Déroger » (a) = manquer à une règle ; « exacerber » (b) = intensifier ; « s''avérer » (d) = se révéler exact. Seul (c) exprime l''attente d''un événement futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ebde8a6-d156-5db6-87f7-c401572b103a', '67639796-8e84-5376-a327-238826f1ad55', '« Tout le monde a mis la main à la pâte pour finir à temps. » Que veut dire cette locution ?', '[{"id":"a","text":"Chacun a participé concrètement au travail."},{"id":"b","text":"Chacun a commis la même erreur."},{"id":"c","text":"Chacun a cuisiné un plat."},{"id":"d","text":"Chacun a donné de l''argent."}]'::jsonb, 'a', '« Mettre la main à la pâte » signifie s''impliquer directement, participer soi-même à la tâche. Le contexte (« pour finir à temps ») confirme l''idée d''effort collectif concret. L''option (c) prend l''image culinaire au pied de la lettre ; (b) et (d) inventent des sens sans rapport.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e06f8f1a-f4d5-5806-baa9-9176421bf9d6', '67639796-8e84-5376-a327-238826f1ad55', 'Complète : « Sans preuve, son accusation n''était qu''un argument ___ destiné à nous égarer. »', '[{"id":"a","text":"fortuit"},{"id":"b","text":"imminent"},{"id":"c","text":"conséquent"},{"id":"d","text":"fallacieux"}]'::jsonb, 'd', '« Fallacieux » qualifie un raisonnement trompeur, fait pour égarer — ce que confirme « destiné à nous égarer ». « Fortuit » (a) = dû au hasard ; « imminent » (b) = très proche ; « conséquent » (c) = cohérent. Seul « fallacieux » correspond à la tromperie volontaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3578d3b-fdb7-56c5-b975-41a1275801d9', '67639796-8e84-5376-a327-238826f1ad55', 'Quelle expression signifie « faire un compromis en partageant la différence » ?', '[{"id":"a","text":"Mettre la charrue avant les bœufs."},{"id":"b","text":"Couper la poire en deux."},{"id":"c","text":"Tomber dans le panneau."},{"id":"d","text":"Avoir le bras long."}]'::jsonb, 'b', '« Couper la poire en deux » désigne le compromis où chacun cède une part. « Mettre la charrue avant les bœufs » (a) = agir dans le désordre ; « tomber dans le panneau » (c) = se faire piéger ; « avoir le bras long » (d) = être influent. Aucune de ces trois n''évoque le partage négocié.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbeb7c7e-788e-5ec8-9123-a0a8670d9ffc', '67639796-8e84-5376-a327-238826f1ad55', 'Trouve l''intrus : trois de ces termes désignent une qualité de jugement ou de caractère, lequel n''en est pas un ?', '[{"id":"a","text":"Un comble."},{"id":"b","text":"La mansuétude."},{"id":"c","text":"L''acharnement."},{"id":"d","text":"La clémence."}]'::jsonb, 'a', '« Un comble » désigne un point culminant, souvent ironique (« c''est un comble ! ») : ce n''est pas un trait de caractère, d''où l''intrus. Les trois autres qualifient une disposition : la mansuétude et la clémence (indulgence) et l''acharnement (ténacité obstinée).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad8006d9-e465-5835-abd0-4d1b9bac8ff3', '67639796-8e84-5376-a327-238826f1ad55', 'Laquelle de ces phrases respecte la norme du niveau C1 ?', '[{"id":"a","text":"Au jour d''aujourd''hui, nous attendons toujours."},{"id":"b","text":"Cette subvention pallie à un déficit chronique."},{"id":"c","text":"Cette subvention pallie un déficit chronique."},{"id":"d","text":"Le diagnostic s''est avéré vrai après examen."}]'::jsonb, 'c', '« Pallier » étant transitif direct, on dit « pallie un déficit » (c), sans « à ». La phrase (b) reprend la faute « pallier à » ; (a) contient le pléonasme « au jour d''aujourd''hui » ; (d) le pléonasme « s''est avéré vrai ». Seule (c) est correcte.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9f1ac286-d018-5994-b399-f2054b019201', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ceca6400-2b73-5e17-aebc-d1ded8870c41', '9f1ac286-d018-5994-b399-f2054b019201', 'Selon le cours, qu''appelle-t-on l''« énonciation polyphonique » d''un texte C1 ?', '[{"id":"a","text":"Le fait que l''auteur fasse entendre plusieurs voix, notamment une voix adverse qu''il cite pour la réfuter."},{"id":"b","text":"Le fait qu''un texte soit toujours écrit à la première personne du pluriel."},{"id":"c","text":"Le fait qu''un texte soit lu à voix haute par plusieurs lecteurs."},{"id":"d","text":"Le fait que l''auteur n''ait aucune opinion personnelle."}]'::jsonb, 'a', 'Le cours définit la polyphonie comme la présence de plusieurs voix : l''auteur cite souvent une voix adverse pour mieux la contester. Confondre cette voix rapportée avec sa position est l''erreur n°1.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af03ec1b-4415-583d-86db-8c371cfb5339', '9f1ac286-d018-5994-b399-f2054b019201', 'Lisez l''extrait :
« Derrière la façade rutilante de la start-up nation, bien des jeunes diplômés enchaînent les stages sans lendemain. »

Que désigne ici « la façade rutilante » ?', '[{"id":"a","text":"Le mur extérieur d''un immeuble d''entreprise."},{"id":"b","text":"Une image flatteuse et trompeuse qui masque une réalité moins reluisante."},{"id":"c","text":"Une vitrine de magasin récemment repeinte."},{"id":"d","text":"Un panneau publicitaire lumineux."}]'::jsonb, 'b', '« Derrière la façade… bien des jeunes… » oppose l''apparence séduisante à la réalité : « façade rutilante » est un sens figuré désignant une image trompeuse. Le sens littéral (mur, vitrine, panneau) est exclu par le contexte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4064bb7f-90e9-5341-9258-e5a61f33ad8d', '9f1ac286-d018-5994-b399-f2054b019201', 'Lisez l''extrait :
« On nous assure que ce traité protégera l''environnement. Or aucun de ses articles n''est contraignant. »

Quelle est la fonction du connecteur « Or » ?', '[{"id":"a","text":"Il confirme l''idée de la première phrase."},{"id":"b","text":"Il introduit un fait gênant qui fait basculer le raisonnement contre cette idée."},{"id":"c","text":"Il exprime une simple addition d''exemples."},{"id":"d","text":"Il marque la conclusion définitive de l''auteur."}]'::jsonb, 'b', '« Or » introduit le fait gênant (« aucun article n''est contraignant ») qui contredit l''assurance affichée : il fait basculer le raisonnement, comme l''indique le cours. Il n''ajoute, ni ne confirme, ni ne conclut.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d1d5f55-b380-5d0e-b422-ebe44a0f99c1', '9f1ac286-d018-5994-b399-f2054b019201', 'Lisez l''extrait :
« Le ministre a, dans sa grande générosité, accordé aux hôpitaux un budget tout juste suffisant pour ne pas fermer. »

Quel procédé l''auteur emploie-t-il ?', '[{"id":"a","text":"Un éloge sincère de la générosité du ministre."},{"id":"b","text":"Une description strictement neutre et chiffrée."},{"id":"c","text":"L''ironie : l''éloge est démenti par la maigreur du budget décrite ensuite."},{"id":"d","text":"Une hypothèse prudente sur l''avenir des hôpitaux."}]'::jsonb, 'c', '« Dans sa grande générosité » loue, mais « tout juste suffisant pour ne pas fermer » dément l''éloge : ce décalage est une antiphrase ironique. Ce n''est ni un compliment sincère, ni une donnée neutre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fd33fea-3f39-5f4e-9029-bb6517532bee', '9f1ac286-d018-5994-b399-f2054b019201', 'Lisez l''extrait :
« La réforme aurait, selon ses détracteurs, fragilisé les plus modestes. »

Que signale le verbe au conditionnel « aurait fragilisé » ?', '[{"id":"a","text":"Un fait établi et assumé par l''auteur."},{"id":"b","text":"Une affirmation que l''auteur rapporte sans la prendre à son compte."},{"id":"c","text":"Un ordre adressé au lecteur."},{"id":"d","text":"Une action future certaine."}]'::jsonb, 'b', 'Le conditionnel et « selon ses détracteurs » marquent une donnée non assumée : l''auteur attribue le propos à d''autres sans le valider. Le cours rappelle qu''une telle affirmation n''est pas un fait du texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c033e9c2-1a09-5524-b33f-d3d333ade7bf', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', '⭐ Entraînement : implicite, énonciation et ton', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3049023-31bd-5c63-b70c-de059f306f6f', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« Les chantres de la dérégulation aiment à présenter l''État comme un poids mort, une bureaucratie tatillonne dont l''économie ne se libérerait qu''en s''en débarrassant. À les entendre, le marché, livré à lui-même, saurait toujours s''autoréguler. L''histoire récente, des krachs financiers aux scandales sanitaires, invite pourtant à plus de circonspection. »

Quelle est la thèse de l''auteur ?', '[{"id":"a","text":"L''État est un poids mort dont l''économie devrait se débarrasser."},{"id":"b","text":"Le marché livré à lui-même s''autorégule toujours efficacement."},{"id":"c","text":"Les scandales sanitaires n''ont aucun rapport avec l''économie."},{"id":"d","text":"La confiance aveugle dans l''autorégulation du marché doit être nuancée par l''expérience."}]'::jsonb, 'd', 'Les deux premières phrases rapportent la voix des « chantres de la dérégulation » ; le « pourtant » de la dernière phrase introduit la position de l''auteur, qui invite à « plus de circonspection ». Les options a et b reprennent la voix adverse réfutée ; d contredit le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53dada63-1c55-5b94-8e04-6677802629ae', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« La municipalité a tenu, une fois encore, à saluer son engagement « exemplaire » en faveur de la propreté. Les riverains, eux, contemplent depuis des mois les mêmes monceaux d''ordures au pied des immeubles. »

Quel est le ton de ce passage ?', '[{"id":"a","text":"Admiratif et reconnaissant envers la municipalité."},{"id":"b","text":"Ironique : l''éloge officiel est démenti par la réalité décrite."},{"id":"c","text":"Purement descriptif et sans aucune prise de position."},{"id":"d","text":"Nostalgique d''une époque plus propre."}]'::jsonb, 'b', 'Les guillemets autour d''« exemplaire » et le contraste avec « les mêmes monceaux d''ordures » signalent que l''auteur ne partage pas l''éloge officiel : c''est de l''ironie. Le ton n''est ni admiratif, ni neutre, ni nostalgique.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8edebe4-b87a-5698-9523-3d41e5ff56c2', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« On reproche volontiers aux réseaux sociaux d''abrutir leurs usagers. Pourtant, jamais le débat public, la circulation des savoirs et la mobilisation citoyenne n''ont été aussi accessibles au plus grand nombre. Le problème ne tient peut-être pas à l''outil, mais à l''usage que nous en faisons. »

Quelle est l''idée principale ?', '[{"id":"a","text":"Le défaut vient de notre usage des réseaux, plus que des réseaux eux-mêmes."},{"id":"b","text":"Les réseaux sociaux abrutissent effectivement tous leurs usagers."},{"id":"c","text":"Le débat public a totalement disparu avec les réseaux sociaux."},{"id":"d","text":"Il faudrait interdire purement et simplement les réseaux sociaux."}]'::jsonb, 'a', 'Après « Pourtant », l''auteur conteste le reproche et conclut que « le problème… tient à l''usage que nous en faisons ». L''option b reprend l''accusation réfutée ; c et d ne figurent pas dans le texte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6d1af50-a589-5b11-8869-b71912f4fcce', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« Il est vrai que la numérisation des services publics a simplifié bien des démarches. Toutefois, elle a aussi laissé sur le bord du chemin tous ceux que l''écran intimide ou que la connexion fait défaut. »

Quelle est la fonction de « Il est vrai que… Toutefois » ?', '[{"id":"a","text":"Il introduit la conclusion finale du raisonnement."},{"id":"b","text":"Il exprime une cause expliquant la numérisation."},{"id":"c","text":"Il met en doute l''existence même de la numérisation."},{"id":"d","text":"Il concède un avantage avant d''introduire l''objection centrale de l''auteur."}]'::jsonb, 'd', '« Il est vrai que… Toutefois » est un couple concessif : l''auteur accorde un mérite à la numérisation, puis « Toutefois » introduit sa véritable objection (l''exclusion des plus fragiles). Ce n''est ni une conclusion, ni une cause, ni un doute.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1192ed95-6b52-5cce-9740-c9f0aaea8fde', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« Le rapport indique que les émissions de la région ont baissé de 12 % en cinq ans. Pour les uns, c''est la preuve éclatante d''une transition réussie ; pour les autres, un recul trop lent au regard de l''urgence climatique. »

Qu''est-ce qui, dans cet extrait, relève du FAIT ?', '[{"id":"a","text":"Les émissions de la région ont baissé de 12 % en cinq ans."},{"id":"b","text":"C''est la preuve éclatante d''une transition réussie."},{"id":"c","text":"C''est un recul trop lent au regard de l''urgence climatique."},{"id":"d","text":"La transition régionale est globalement un échec."}]'::jsonb, 'a', '« –12 % en cinq ans » est une donnée chiffrée vérifiable : un fait. « Preuve éclatante » et « recul trop lent » sont deux jugements opposés (opinions) ; l''option d est une prise de position absente du texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('012eb559-584c-5108-a791-e0d1dd308a69', 'c033e9c2-1a09-5524-b33f-d3d333ade7bf', 'Lisez l''extrait :
« Après bien des promesses, la rénovation du quartier a enfin été votée. Reste à voir si les crédits suivront, ou si ce projet rejoindra le cimetière des plans d''urbanisme jamais sortis des cartons. »

Que suggère la dernière phrase ?', '[{"id":"a","text":"Que la rénovation sera certainement menée à bien."},{"id":"b","text":"Que les promesses passées ont toutes été tenues."},{"id":"c","text":"Que le projet a finalement été abandonné par la mairie."},{"id":"d","text":"Que l''auteur doute de la réalisation effective du projet, faute de financement."}]'::jsonb, 'd', '« Reste à voir si les crédits suivront » et l''image du « cimetière des plans… jamais sortis des cartons » expriment un doute sur l''aboutissement. Le texte dit pourtant que la rénovation a été votée (pas abandonnée), après des promesses non tenues.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', '⭐⭐ Révision : présupposés, modalisation et connecteurs', 2, 75, 15, 'practice', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1be3398c-546f-5c85-a84f-1bbe1bc707f5', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« Faut-il vraiment s''étonner que les électeurs se détournent encore un peu plus des urnes ? »

Que présuppose cette question ?', '[{"id":"a","text":"Que la participation électorale était déjà en baisse auparavant."},{"id":"b","text":"Que les électeurs n''ont jamais voté de toute leur vie."},{"id":"c","text":"Que la participation électorale est en hausse constante."},{"id":"d","text":"Que les urnes vont être supprimées."}]'::jsonb, 'a', 'L''adverbe « encore un peu plus » présuppose que le détournement avait déjà commencé : la baisse est antérieure. Les options b, c et d contredisent ce présupposé ou sortent du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a31f462-b7d3-5b00-ac8c-df27546a544b', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« Ce dispositif, prétendument destiné à protéger les consommateurs, sert d''abord les intérêts des grands groupes qui l''ont inspiré. »

Que signale l''adverbe « prétendument » ?', '[{"id":"a","text":"Que l''auteur adhère pleinement à l''objectif affiché du dispositif."},{"id":"b","text":"Que le dispositif protège réellement et efficacement les consommateurs."},{"id":"c","text":"Que l''auteur ignore à qui profite le dispositif."},{"id":"d","text":"Que l''auteur met à distance l''objectif affiché, qu''il juge trompeur."}]'::jsonb, 'd', '« Prétendument » distancie l''auteur de la finalité officielle : il suggère que la protection annoncée n''est qu''un prétexte, comme le confirme « sert d''abord les intérêts des grands groupes ». L''auteur n''adhère pas à l''objectif affiché et sait précisément à qui profite le dispositif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ae7a482-ab59-5a32-8745-188e13271de6', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« Les défenseurs du projet vantent la création de centaines d''emplois. Encore faudrait-il que ces emplois soient durables et correctement rémunérés, ce que rien, dans le dossier, ne permet d''affirmer. »

Quelle attitude l''auteur adopte-t-il ?', '[{"id":"a","text":"Une adhésion enthousiaste aux promesses d''emplois."},{"id":"b","text":"Une indifférence totale à la question de l''emploi."},{"id":"c","text":"Une certitude que les emplois seront durables et bien payés."},{"id":"d","text":"Une réserve sceptique : il doute de la qualité réelle des emplois promis."}]'::jsonb, 'd', '« Encore faudrait-il que… ce que rien… ne permet d''affirmer » exprime une réserve : l''auteur ne conteste pas le nombre d''emplois mais doute de leur qualité. Ce n''est ni de l''adhésion, ni de l''indifférence, ni une certitude inverse.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cb85955-8562-5cc4-b812-6904ec90e3be', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« Le tourisme assure, dit-on, la prospérité de l''île. Or les jeunes natifs, eux, n''ont d''autre horizon que d''émigrer pour trouver un emploi stable. »

Quelle est la fonction du connecteur « Or » ?', '[{"id":"a","text":"Il confirme et renforce l''idée de prospérité."},{"id":"b","text":"Il introduit un fait qui contredit l''idée de prospérité et fait basculer le propos."},{"id":"c","text":"Il ajoute un simple exemple supplémentaire de prospérité."},{"id":"d","text":"Il marque la conclusion générale de l''auteur."}]'::jsonb, 'b', '« Or » introduit un fait gênant (l''émigration des jeunes) qui contredit la « prospérité » annoncée et fait basculer le raisonnement. Il ne confirme pas, n''ajoute pas un exemple concordant et n''est pas un connecteur de conclusion.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2affecda-99a2-5e7f-a13a-7b9a36c131de', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« On célèbre l''« agriculture de précision » comme l''avenir de nos campagnes. Derrière ce vocable séduisant se cache pourtant une dépendance accrue aux brevets, aux capteurs et aux multinationales qui les fournissent. La précision, ici, est surtout celle du contrôle exercé sur l''agriculteur. »

Quelle est la thèse implicite de l''auteur ?', '[{"id":"a","text":"L''agriculture de précision est l''avenir incontestable des campagnes."},{"id":"b","text":"Les capteurs agricoles sont trop coûteux pour être rentables."},{"id":"c","text":"Sous un terme valorisant, l''agriculture de précision renforce surtout la dépendance et le contrôle de l''agriculteur."},{"id":"d","text":"Les agriculteurs refusent en bloc toute innovation technologique."}]'::jsonb, 'c', 'Le « pourtant » et la reformulation finale (« la précision… est surtout celle du contrôle ») dévoilent la critique : sous un mot flatteur, l''auteur dénonce une dépendance accrue. L''option a reprend la voix valorisante critiquée ; b et d ajoutent des idées absentes du texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('455e6ad7-cb22-51f3-8820-0680b738b64a', 'a49ef7fd-b2c8-5e37-b70e-ab30c08edc12', 'Lisez l''extrait :
« §1 : on vante les vertus des classes surchargées, qui « endurciraient » les élèves. §2 (introduit par « En réalité ») : toutes les études convergent vers l''effet inverse sur les apprentissages. §3 : « Reste à savoir combien de générations il faudra sacrifier avant d''en tirer les conséquences. »

Quelle est la fonction du troisième paragraphe ?', '[{"id":"a","text":"Il revient sur la thèse adverse pour finalement l''approuver."},{"id":"b","text":"Il clôt le texte sur une question amère qui dramatise l''inaction, renforçant la critique de l''auteur."},{"id":"c","text":"Il introduit un sujet nouveau, sans lien avec les classes surchargées."},{"id":"d","text":"Il rapporte de façon neutre l''avis des partisans des classes surchargées."}]'::jsonb, 'b', 'Après la réfutation du §2 (« En réalité »), le §3 conclut par une question rhétorique amère (« combien de générations… sacrifier ») qui dramatise l''inaction et appuie la critique. Ce n''est ni une approbation de la thèse adverse, ni un sujet nouveau, ni un compte rendu neutre.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', '⚔️ Boss du chapitre ⭐⭐⭐ : ironie, voix et structure dense', 3, 120, 30, 'boss', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e803711a-4b82-50e3-94d8-c412f15e9775', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« Nos experts en prospective, dont la perspicacité n''a d''égale que leur talent pour se tromper d''une décennie sur deux, nous promettent désormais une intelligence artificielle bienveillante, sobre et créatrice d''emplois. On voudrait les croire. On se souvient seulement qu''ils nous avaient déjà promis, en leur temps, la fin du travail, la paix par le commerce et la démocratie par le câble. »

Quel est le ton dominant de ce passage ?', '[{"id":"a","text":"Ironique et désabusé à l''égard des prévisions des experts."},{"id":"b","text":"Admiratif devant la perspicacité des experts."},{"id":"c","text":"Strictement informatif sur l''intelligence artificielle."},{"id":"d","text":"Optimiste quant à l''avenir promis par les experts."}]'::jsonb, 'a', 'La louange « dont la perspicacité n''a d''égale que leur talent pour se tromper » est une antiphrase, et la liste des promesses non tenues confirme le scepticisme : le ton est ironique et désabusé. Il n''y a ni admiration réelle, ni neutralité, ni optimisme.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcfbc33a-7a39-5c4a-9dd5-4ed38f8c86cf', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« Que la culture soit devenue une industrie, nul ne le contestera plus. Le malheur n''est pas qu''elle se vende — elle l''a toujours fait —, mais qu''elle ait fini par calquer ses formes sur celles de n''importe quelle marchandise : standardisées, testées sur des panels, conçues pour ne déplaire à personne et, par là même, pour ne marquer durablement personne. »

Quelle est la thèse de l''auteur ?', '[{"id":"a","text":"La culture n''a jamais dû se vendre et devrait rester gratuite."},{"id":"b","text":"La marchandisation appauvrit la culture en la standardisant pour ne déplaire à personne."},{"id":"c","text":"Les panels de test garantissent une culture de meilleure qualité."},{"id":"d","text":"La culture est désormais accessible à tous grâce à l''industrie."}]'::jsonb, 'b', 'L''auteur précise que le problème n''est pas la vente (« elle l''a toujours fait ») mais le calque sur la marchandise standardisée, « conçue pour ne marquer durablement personne » : c''est une critique de l''appauvrissement. L''option a se trompe de cible (l''auteur ne condamne pas la vente) ; c et d inversent ou ajoutent au propos.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2b0f0a5-a3f5-584f-826a-32c54c9d8bb0', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« Il pleuvait sur la ville comme il avait toujours plu, et les passants pressaient le pas vers des destinations qui, à les voir si affairés, semblaient toutes capitales. Lui seul, sous l''auvent du café, regardait s''écouler ce ruissellement d''existences, songeant que parmi tous ces gens si sûrs d''aller quelque part, aucun peut-être ne savait vraiment où. »

Quelle vision du monde se dégage de ce passage littéraire ?', '[{"id":"a","text":"Une célébration enthousiaste de l''énergie urbaine et de ses certitudes."},{"id":"b","text":"Une description météorologique sans portée sur les personnages."},{"id":"c","text":"Un éloge de la ponctualité et de la rigueur des passants."},{"id":"d","text":"Un regard mélancolique et distancié sur l''agitation humaine, jugée peut-être sans véritable but."}]'::jsonb, 'd', 'Le contraste entre l''« affairé » des passants « si sûrs d''aller quelque part » et le doute final (« aucun peut-être ne savait vraiment où ») installe un regard mélancolique et distancié de l''observateur. Ce n''est ni une célébration, ni une simple notation météo, ni un éloge de la ponctualité.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47bd48ed-89e5-5ec7-910d-db776414f4db', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« On objectera que la liberté d''expression doit protéger même les propos les plus odieux, sans quoi elle ne serait qu''un mot. L''argument a sa force. Reste qu''une société qui, au nom de cette liberté, laisse prospérer l''appel à la haine finit par sacrifier la liberté de ceux que cette haine vise à réduire au silence. »

Comment l''auteur traite-t-il l''objection qu''il rapporte ?', '[{"id":"a","text":"Il l''adopte intégralement comme sa propre conclusion."},{"id":"b","text":"Il la rejette d''emblée comme absurde et sans intérêt."},{"id":"c","text":"Il lui reconnaît une part de validité, puis la dépasse en montrant ses effets pervers."},{"id":"d","text":"Il l''ignore et change complètement de sujet."}]'::jsonb, 'c', '« L''argument a sa force » concède une part de validité ; « Reste que… » introduit le dépassement : laisser prospérer la haine sacrifie la liberté des victimes. C''est une concession suivie d''une réfutation nuancée, ni adhésion totale, ni rejet pur, ni abandon du sujet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb9097ac-a379-5e33-a000-f949d3134437', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« §1 : on s''émeut, à juste titre, de la disparition des petits commerces. §2 : mais l''on oublie que ces mêmes commerces, hier, furent accusés d''avoir tué les marchés et les artisans qui les précédaient. §3 : « Peut-être ne pleurons-nous jamais que le monde de notre enfance, en le confondant avec un âge d''or. »

Quelle est la portée du troisième paragraphe ?', '[{"id":"a","text":"Il affirme qu''il existait réellement un âge d''or du commerce, désormais perdu."},{"id":"b","text":"Il généralise la réflexion : notre nostalgie tiendrait moins aux faits qu''à notre rapport au passé."},{"id":"c","text":"Il propose un plan concret pour sauver les petits commerces."},{"id":"d","text":"Il accuse les artisans d''avoir détruit les marchés."}]'::jsonb, 'b', 'Après le constat (§1) et sa relativisation historique (§2), le §3 généralise par une hypothèse (« Peut-être ne pleurons-nous jamais que le monde de notre enfance ») : la nostalgie viendrait de notre rapport au passé. Au contraire, le texte met en doute l''idée d''un « âge d''or » ; il ne propose pas de plan et n''accuse pas les artisans.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('634ff1f3-5c9d-5900-917c-16aed88980f3', '6c6eae1d-0be9-58e9-bcc0-77632fbdc6dd', 'Lisez l''extrait :
« Sans doute la transparence est-elle une vertu démocratique. Mais à force d''exiger que tout soit exposé, surveillé, archivé, ne risque-t-on pas de confondre la lumière qui éclaire avec celle qui aveugle, et de faire de la défiance généralisée le seul lien qui nous reste ? »

Que suggère l''opposition entre « la lumière qui éclaire » et « celle qui aveugle » ?', '[{"id":"a","text":"Que la transparence est toujours bénéfique, quelle que soit son intensité."},{"id":"b","text":"Qu''il faudrait supprimer toute forme de transparence dans la vie publique."},{"id":"c","text":"Que poussée à l''excès, la transparence peut se retourner en surveillance et en défiance, perdant sa vertu."},{"id":"d","text":"Que l''éclairage public des villes consomme trop d''énergie."}]'::jsonb, 'c', 'La métaphore oppose la transparence utile (« qui éclaire ») à son excès nuisible (« qui aveugle »), prolongée par « la défiance généralisée » : l''auteur avertit qu''à l''excès la transparence se dénature. Il ne la dit ni toujours bénéfique (a), ni à supprimer (b) ; d prend la métaphore au sens littéral.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('abfa245d-02b0-59ea-9d52-f9c6ec37256c', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', '👑 Défi élite ⭐⭐⭐⭐ : lecture critique des textes complexes', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('395a5ad4-8a93-5fea-b74a-f141cbe99212', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« Je veux bien que l''on m''explique en quoi le fait de rebaptiser les pauvres « personnes en situation de précarité » a, jusqu''à présent, rempli une seule assiette. Le langage administratif a ceci de commode qu''il enveloppe les choses d''une ouate de syllabes : on n''y voit plus la blessure, seulement le pansement verbal. »

Quelle est la cible de la critique de l''auteur ?', '[{"id":"a","text":"Les personnes en situation de précarité elles-mêmes."},{"id":"b","text":"Les linguistes qui étudient l''évolution du vocabulaire."},{"id":"c","text":"La distribution de nourriture aux plus démunis."},{"id":"d","text":"L''euphémisme administratif qui masque les réalités au lieu d''y remédier."}]'::jsonb, 'd', 'L''ironie (« remplir une seule assiette ») et l''image du « pansement verbal » qui cache « la blessure » visent l''euphémisme administratif : changer les mots sans changer les choses. L''auteur ne s''en prend ni aux pauvres, ni aux linguistes, ni à l''aide alimentaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13d986ab-6784-51d6-9aab-e9ad4f82b75a', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« Les promoteurs de la « ville intelligente » nous assurent qu''en truffant l''espace de capteurs, on le rendra plus fluide, plus sûr, plus économe. Admettons. Encore conviendrait-il de préciser pour qui : car la donnée, une fois captée, ne reste jamais longtemps sans maître, et le citoyen qui croit habiter une ville se découvre parfois locataire d''une plateforme. »

Quelle est la thèse implicite de l''auteur ?', '[{"id":"a","text":"La ville intelligente profitera également et sans risque à tous les habitants."},{"id":"b","text":"Les capteurs urbains tombent trop souvent en panne pour être utiles."},{"id":"c","text":"Sous couvert d''efficacité, la ville connectée transfère le pouvoir aux détenteurs des données, au détriment du citoyen."},{"id":"d","text":"Il faut multiplier les capteurs pour rendre la ville plus sûre."}]'::jsonb, 'c', '« Encore conviendrait-il de préciser pour qui », « la donnée… ne reste jamais sans maître » et la chute (« locataire d''une plateforme ») dévoilent la critique : le bénéfice affiché masque un transfert de pouvoir vers les détenteurs de données. L''option a reprend le discours promotionnel critiqué ; b et d sortent du propos.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f523d362-13a1-55f6-9c76-8d601896a171', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« On nous vante l''évaluation permanente comme un gage d''excellence. Soit. Mais lorsqu''un professeur passe plus d''heures à remplir des grilles qu''à préparer ses cours, lorsqu''un soignant documente davantage qu''il ne soigne, il faut se demander si l''on mesure encore le travail — ou si l''on a fini par prendre la mesure pour le travail lui-même. »

Que dénonce précisément l''auteur dans la dernière phrase ?', '[{"id":"a","text":"Le manque de compétences des professeurs et des soignants."},{"id":"b","text":"La confusion par laquelle l''outil d''évaluation finit par se substituer à l''activité qu''il devait seulement mesurer."},{"id":"c","text":"L''absence totale d''évaluation dans les services publics."},{"id":"d","text":"Le coût financier excessif des grilles d''évaluation."}]'::jsonb, 'b', 'L''opposition « mesure-t-on encore le travail — ou a-t-on pris la mesure pour le travail » désigne une inversion : l''évaluation, censée être un moyen, devient une fin qui supplante l''activité. L''auteur ne met en cause ni la compétence des agents (a), ni un manque d''évaluation (c), ni d''abord son coût (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50703343-595b-5617-a03b-4b9cbccbe8f9', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« Elle relisait ses lettres d''autrefois avec une tendresse appliquée, comme on visite un musée dont on serait à la fois la conservatrice et l''unique visiteuse. Les mots y étaient restés jeunes ; c''était elle qui avait vieilli autour d''eux. »

Que suggère la comparaison du musée et la dernière phrase ?', '[{"id":"a","text":"Que le personnage a oublié le contenu de ses anciennes lettres."},{"id":"b","text":"Que le personnage projette de fonder un véritable musée privé."},{"id":"c","text":"Que le personnage contemple son passé avec une distance lucide, mesurant l''écart entre ce qu''elle fut et ce qu''elle est devenue."},{"id":"d","text":"Que les lettres ont été matériellement abîmées par le temps."}]'::jsonb, 'c', 'L''image du musée (« conservatrice et unique visiteuse ») et l''antithèse « les mots restés jeunes / elle qui avait vieilli » disent une contemplation lucide et distancée de soi à travers le temps. Le passage n''évoque ni un oubli (a), ni un projet de musée (b), ni une dégradation matérielle (d) — « restés jeunes » l''exclut.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2926e03d-fb60-5eee-8aae-2ed6d6db48d2', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« §1 : on déplore la défiance des citoyens envers la science. §2 : mais cette défiance, dit l''auteur, naît moins de l''ignorance que du spectacle d''experts se contredisant au gré des intérêts qui les financent. §3 : « En somme, ce n''est pas trop de science que réclame le public, mais une science dont il puisse, enfin, croire qu''elle ne lui ment pas. »

Quelle est la fonction du troisième paragraphe et que révèle-t-il de la thèse ?', '[{"id":"a","text":"Il conclut en déplaçant la responsabilité : le problème n''est pas l''ignorance du public mais la crédibilité de la science."},{"id":"b","text":"Il conclut que le public est définitivement hostile à toute forme de science."},{"id":"c","text":"Il introduit un exemple nouveau de découverte scientifique récente."},{"id":"d","text":"Il rétablit la thèse du §1 selon laquelle la défiance vient de l''ignorance."}]'::jsonb, 'a', '« En somme » conclut, et la formule « non pas trop de science… mais une science… qu''elle ne lui ment pas » déplace la cause : ce n''est pas l''ignorance (thèse du §1 récusée au §2) mais le défaut de crédibilité. L''option d réaffirme la thèse réfutée ; b durcit le propos ; c invente un exemple absent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad01a4dc-cdfa-51b3-8d5b-9f79dab05031', 'abfa245d-02b0-59ea-9d52-f9c6ec37256c', 'Lisez l''extrait :
« Les zélateurs du « bon sens » se présentent volontiers en adversaires des idéologies. C''est oublier que le bon sens fut, à chaque époque, le nom respectable que se donnaient les préjugés du moment — hier pour justifier l''ordre établi, aujourd''hui pour se dispenser de penser ce qui dérange. »

Quel présupposé l''auteur conteste-t-il chez les « zélateurs du bon sens » ?', '[{"id":"a","text":"L''idée que le bon sens serait neutre et étranger à toute idéologie."},{"id":"b","text":"L''idée que les préjugés du passé auraient réellement existé."},{"id":"c","text":"L''idée que penser serait toujours fatigant et inutile."},{"id":"d","text":"L''idée que l''ordre établi devrait être préservé à tout prix."}]'::jsonb, 'a', 'Les zélateurs se posent en « adversaires des idéologies », présupposant un bon sens neutre ; l''auteur conteste ce présupposé en montrant que le bon sens fut « le nom respectable des préjugés du moment ». Il ne nie pas l''existence des préjugés (b), ne dit pas que penser est inutile (c) et ne défend pas l''ordre établi (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ede1b633-9352-5655-bad0-e48fd8490122', '525fd972-a102-5a5f-ae97-72d48eb79e61', 'francais-c1', '⭐⭐ Drill : révision globale de la lecture C1', 2, 75, 15, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d60540bc-2972-538d-95ee-eea4ca54ded5', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« On présente la voiture autonome comme la fin des accidents de la route. Pourtant, déléguer la conduite à un algorithme, c''est aussi lui déléguer, en cas de drame, des choix que nul n''a jamais voulu trancher à froid. »

Quelle est la thèse de l''auteur ?', '[{"id":"a","text":"La voiture autonome supprimera tous les accidents de la route."},{"id":"b","text":"Confier la conduite à un algorithme soulève des dilemmes moraux qu''on préfère ne pas affronter."},{"id":"c","text":"Les algorithmes sont incapables de conduire un véhicule."},{"id":"d","text":"Il faudrait interdire toute forme d''automobile."}]'::jsonb, 'b', 'Le « Pourtant » introduit la position de l''auteur : déléguer la conduite revient à déléguer « des choix que nul n''a voulu trancher à froid », soit des dilemmes moraux esquivés. L''option a reprend la promesse contestée ; c et d ne figurent pas dans le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('feabb142-13bc-54c5-8fa2-c0a45ad1ccc6', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« La direction se réjouit, dans un communiqué « historique », d''avoir « préservé l''emploi » : trois cents postes seulement supprimés, là où le marché en aurait justifié le double. »

Quel est le ton de ce passage ?', '[{"id":"a","text":"Ironique : la satisfaction officielle est minée par le nombre de postes supprimés."},{"id":"b","text":"Élogieux envers la direction et sa gestion sociale."},{"id":"c","text":"Neutre et purement factuel."},{"id":"d","text":"Inquiet pour l''avenir financier du marché."}]'::jsonb, 'a', 'Les guillemets autour d''« historique » et de « préservé l''emploi », suivis de « trois cents postes seulement supprimés », signalent une distance ironique : l''auteur démonte l''autosatisfaction officielle. Le ton n''est ni élogieux, ni neutre, ni centré sur le marché.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc98c914-6202-5671-9d51-de8a6a5455a2', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« Ce label « éco-responsable », apposé sur des produits acheminés à l''autre bout du monde, en dit long sur le pouvoir des mots à rassurer le consommateur sans rien changer à ses pratiques. »

Que signalent les guillemets autour d''« éco-responsable » ?', '[{"id":"a","text":"Une citation exacte d''un texte de loi sur l''écologie."},{"id":"b","text":"L''insistance admirative de l''auteur sur la qualité du label."},{"id":"c","text":"Une mise à distance critique : l''auteur juge le label trompeur."},{"id":"d","text":"Une simple convention typographique sans valeur particulière."}]'::jsonb, 'c', 'Les guillemets de distance, renforcés par « rassurer… sans rien changer », montrent que l''auteur tient le label pour trompeur. Ce ne sont ni une citation légale, ni une marque d''admiration, ni un détail typographique neutre.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47b96e4c-4c47-590c-b321-0390fdaf9e1d', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« On loue la mobilité comme une chance offerte à chacun de se réinventer. Or, pour beaucoup, changer sans cesse de ville et d''emploi n''est pas une liberté choisie, mais une précarité subie sous un nom plus flatteur. »

Quelle est la fonction du connecteur « Or » ?', '[{"id":"a","text":"Il renforce l''éloge de la mobilité comme liberté."},{"id":"b","text":"Il introduit un fait qui retourne l''éloge en critique de la précarité."},{"id":"c","text":"Il ajoute un exemple allant dans le même sens que la première phrase."},{"id":"d","text":"Il conclut le raisonnement de manière apaisée."}]'::jsonb, 'b', '« Or » oppose à l''éloge de la mobilité une réalité contraire (« une précarité subie sous un nom plus flatteur »), faisant basculer le propos vers la critique. Il ne renforce pas l''éloge, n''ajoute pas un exemple concordant et n''apaise pas la conclusion.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('452f2368-9a05-5b7b-96cb-1975617a8594', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« §1 : on s''alarme de la baisse du niveau en orthographe. §2 (introduit par « À y regarder de plus près ») : les mêmes lamentations se lisent, mot pour mot, dans des chroniques vieilles d''un siècle. §3 : « Peut-être chaque génération a-t-elle besoin de croire qu''elle assiste, la première, au crépuscule de la langue. »

Quelle est la portée du troisième paragraphe ?', '[{"id":"a","text":"Il confirme que le niveau en orthographe s''effondre réellement aujourd''hui."},{"id":"b","text":"Il propose une méthode pour enseigner l''orthographe."},{"id":"c","text":"Il généralise par une hypothèse : ce déclin annoncé serait surtout une croyance que chaque génération renouvelle."},{"id":"d","text":"Il accuse les chroniqueurs du passé d''avoir menti."}]'::jsonb, 'c', 'Après le constat (§1) relativisé par l''argument historique (§2), le §3 généralise par une hypothèse (« Peut-être chaque génération… ») : le « crépuscule de la langue » serait une croyance récurrente. Le texte met donc en doute l''effondrement (a) ; il ne propose pas de méthode (b) et n''accuse personne de mensonge (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a44aa46-9ebb-5682-84b4-736594207d36', 'ede1b633-9352-5655-bad0-e48fd8490122', 'Lisez l''extrait :
« Sans doute le bénévolat est-il admirable. Mais lorsqu''un État se repose sur la bonne volonté de quelques-uns pour assurer ce qu''il devrait garantir à tous, l''admiration cède la place à une question plus gênante : à qui profite, au juste, cette générosité que l''on encense ? »

Quelle est l''attitude de l''auteur envers le bénévolat ?', '[{"id":"a","text":"Une condamnation du bénévolat, jugé inutile et néfaste."},{"id":"b","text":"Une admiration sans réserve pour les bénévoles."},{"id":"c","text":"Une indifférence totale à la question sociale."},{"id":"d","text":"Une admiration tempérée d''une réserve critique sur le désengagement de l''État qu''il masque."}]'::jsonb, 'd', '« Sans doute… admirable. Mais… » concède la valeur du bénévolat puis introduit la réserve : l''État s''en sert pour se désengager. L''auteur ne condamne pas le bénévolat (a), ne l''admire pas sans réserve (b) et ne se montre pas indifférent (c).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

