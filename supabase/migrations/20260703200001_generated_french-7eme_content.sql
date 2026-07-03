-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: french-7eme (Français)
-- Regenerate with: npm run content:build
-- Source of truth: content/french-7eme/
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
  ('french-7eme', 'Français', 'Le français en 7ème année de base : lecture, conjugaison, syntaxe, orthographe et vocabulaire au fil de cinq modules thématiques', 'Sagesse', 'subject-french', 'BookOpen', 2, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '7eme-base'))
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
      AND e.subject_id = 'french-7eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('976e6fe4-5b49-586f-883a-d9e9f0c081a4', 'db41d9df-95da-557d-82ab-e08a22c0020f', 'c8a454d8-818a-553e-b22a-c483992cdae0', '40ff7c0c-2205-5dd6-94b2-8ad148ebc49f', '9afb3059-f7f8-56b3-a869-54d33a4aaefc', '9c11a918-04aa-5cec-92fa-7c29c7f260cf', '01a9a294-1675-5159-8c32-af6c76e6827e', '6ba20833-b151-5b18-8a2e-a1475ae8cdba', '3bc9abd0-5b42-5128-8f7b-abdbcd90cdb3', 'a85ae49b-77b2-58f3-89bc-5828ca448807', 'c7dc6e55-e505-5c77-b4e1-c3bc3941fea6', '26cb8fdb-4cc1-5585-9067-80cf0fbf852e', '591d194f-33fe-5eb3-9357-88c217b4b8f7', '4ea63a15-04e4-5e29-80ae-70b2af0c70df', '8721e697-8ba1-5389-b093-11302f1b3dbb', 'cb36d499-02d8-58d6-bc00-f423cea2e528', '8f4253b2-200a-5f3c-b112-b5dd8682beac', 'c77e2843-82c3-52f4-807b-6660a6bce8c1', '2d8a35c6-8da7-51be-9c58-c5e789279669', 'ac6fdf66-ba0e-5404-8c39-f75938575262', '43df3c5a-60c8-59c8-94c6-3e79c3ab2748', 'deb56b93-e341-51ef-8324-3625d3a5cf9e', '278e431b-ceee-5951-a06b-6f176d198140', '78a64ac8-e5d7-57d0-b58d-5c21785063ca', '00ea00e7-81df-5713-9516-0e0f26478104', 'd3e7c98a-4807-5c39-9419-d9add58477dc', '0933e54e-78f2-5741-865a-4d8b439369be', '6f24b257-3d4f-5b34-93d1-de677b137591', '5f1df333-158d-5a52-8f36-86f5b6708f20', 'a5cf1bda-f8e2-5c54-b434-f3db37bdde2b', '2451a178-c2c0-5bf6-8049-cefbe0b67ea3', 'c65e0c71-483d-550f-8e90-2ef05310be38', 'f9eab841-bbe6-53b8-8b5b-4a270156a2b9', '1fcb1efe-d737-5014-b350-3119d4d324c3', '2e2c0d83-aa60-5436-aeff-da8ba96b03ec', 'c70a43b8-7ba5-5f67-b0ca-98ba3cc20816', '1cb9c356-6c42-5d63-9ad7-ee57dbae7e4f', 'bce98825-cd7f-520e-a32f-8185b2aace7a', 'f16e9c89-734b-5de6-8d08-551b1d62a1c7', '37efb182-9d3c-51f0-8d56-4262b892cf0f', '441b13a8-85f6-5b39-b0b9-25e55057694b', '9b00ef85-9dfc-5f4b-aa71-fc229e8a904b', '3d7b2f38-cfe9-5abc-8e13-f216a45da40e', '396ddaf3-d18b-571a-b1fb-adf6bc7c25a4', 'c09583b8-2eeb-5a6a-b8d2-73ee4188282a', 'd0f6544a-de1e-586a-810f-315705762fb6', 'a5ad3943-6fa3-5fcc-9ec4-e698b094b448', '0a01d389-90c8-55df-a109-bf8efb11d5e6', '0594d7f3-fd69-5af1-bd84-28576507a164', '80284306-374c-5950-9bf0-ee63dbf4d566', '9140cf80-f559-5709-a5ca-39a0c0b95788', 'f3b0417a-13b1-59d9-b829-75276e09d0ba', 'b09f4830-f83a-5682-b968-0507b7c48225', '965fabc0-08fa-5c68-8305-a1799dabb089', '3dd60966-0d9c-556c-a86e-19d374668362', 'e3a6c2c1-8754-5473-9b27-0fb61669e28f', '8f54f6a8-14a1-5ac0-b668-b12d9c0b8c99', 'ab362268-2a4f-5e6c-b881-461682b745d4', '0a16e931-dcb5-5ea2-94e9-049f45b61f3a', '84159263-c4b7-5241-9216-f33d0434fe46', 'c4ce4e63-ffe1-5144-a3de-6945dba7aa36', '3e66480d-06d6-53f0-8798-bfa1d13e7878', '849f7186-bf21-523f-b0dc-bd6eaf2e45f5', '87377104-3846-5e21-9419-b47d12027968', '4cc56ce3-cbec-566e-9d7d-0eaa649fed4d', 'd9f163f9-dfd9-5fd5-868b-6519ad239e1e', '5b988d77-9284-569b-8e67-2b5fb6ae9dec', 'd70d42e2-4d38-5684-8bfc-867da3cdc32f', '3fee4803-d3ab-523c-9ee5-ed0f50fd34a9', 'fdd0be9f-29be-5edd-b41f-f105659e31b4', 'c8247de8-33db-5da3-9309-488f76ba34b3', '183db602-5a7e-5833-ab05-3ce5b0680b5b', '54e2dc59-8308-5bd5-a25d-1bddca6f8f0e', '1ccf6e9f-7ef6-584d-9443-d7b21ee9ac1e', '8dc05e29-adbd-5738-9e3b-fbfb86adef44', '2e09e5bf-1e31-5931-aa6d-66fabcaaf89a', 'b2fce535-dc06-5802-812e-12c88a809f59', '8db64676-74a2-5a33-8283-1bd9f12980c1', '4e45c6ed-d298-57e9-816d-1fa1e1722c4d', 'de483ea6-ba44-5c0c-b048-96ca3cd39290', 'f75b2b2f-bb1b-5198-a15d-dcba9adc87aa', 'c764e0f5-f73d-587e-b464-6a06759cc247', '62e9a750-5dc8-5099-9a4e-65b3e45cae55', '16c6fbf5-ae44-59b8-94f2-ab64ee3c1454', 'd9e94a90-4977-594a-a3df-e0386a5cc4aa', '045f9cf3-c80c-5c00-a77b-18389fcc3ceb', '621e26ca-425e-5542-8ea2-d6e369884f35', '349fbcf2-f64c-5d6b-9c8e-d2ef96e23876', '1e7d33aa-8fdb-5f1a-9065-9f0f586f6a66', '5239f6a0-9208-5a7e-9fd9-e64663542f1b', 'bf45cedb-df42-5fa0-b21e-0ae99ee49482', '2fa05f10-0cba-5d87-8676-5beba260dce8', 'aad6bb64-2ab3-5bba-a077-e3d969df32cd', '55710205-0a61-5af4-a214-fbb6e51569b5', '7ac60b94-ece9-5c8c-aa61-47de3d9496f5', '1cf07c35-ec20-534c-8e97-922d010b3e30', 'db18977d-2ff0-5312-be71-8a7638a3b0f3', '850af2b6-c8e3-526d-b2ed-ff0f2fba3e74', '893992a7-c755-5cfb-800e-cc73a7cf873f', '014c22b3-8d3a-58ee-9ae4-08b81336d81c', '1f6b2a93-0bc3-545c-9ea0-39a5022d77fe', 'fa811334-307a-545d-bad6-96b69671f232', '73c75612-0518-5f8a-a199-fec0d77cb396', 'b26a04c3-ba76-5a16-9b45-08cc5cb8c010', 'f567ef7c-b142-5d1a-8475-8edf4daa416c', '9180cacc-e0fa-57bd-8589-017e0d331e66', '10f84c01-3918-535f-a678-775087f22ac6', '052eaa98-193d-5a29-8211-e2f7cb97403e', 'f9f62452-f2c7-54bf-9822-9216218aa379', '48626e52-cf7b-502e-9cf5-378cd131f71c', '1bd99855-2250-5c62-a99e-ce5cf56f2e4e', 'ae87f18d-220c-5537-956a-698e0dfe1339', 'ac44816f-5fdf-54e2-a440-3fc03b693b38', '2de7d039-07e6-538f-a33e-6f84e585739b', '5c36a524-2eee-5c11-b4b9-8bbc33f00eda', '84b022ca-68f1-58e8-a7f8-0a24c6fa151e', '4cae155d-fb4e-55c2-97ae-b1816dd01893', 'aa2ac075-51a9-5308-94de-3a3b3fdd71c4', '22752aa8-e4c4-51a0-9a83-5b0383ad92e9', 'e01b412b-e688-5157-acc8-246187087418', '188e13fb-3aff-52e0-8e9b-4c2ae0a534b8', '840bd2ac-a0c6-55ae-bac9-f160a731e43f', 'b83906a1-4b2a-5f71-a270-a981f280bafb', 'fd54cacd-dda0-5d36-9484-a40e93a10d4b', 'e027dce5-8bb6-51c1-a6cd-680f00e79f94', 'a6ba8295-b00d-5ae1-abea-2fa61ec84649', '2d348c0e-a2c3-5dc1-b13b-10b5cb6fdc82', 'b3806971-21b2-561f-804e-d5165308c3c3', 'bc3495fe-e2f9-5713-b0e4-620744b77007', 'd31a042e-0908-5ac1-9e55-c2bf28995262', '471310eb-8412-5ece-ad69-540af5c77865', 'f2a9d46e-a70e-5942-9f25-19d0824a07d6', 'f13ccdf6-acb8-57d7-ba7b-778591223e0b', 'c76b1b72-823b-583a-bc76-bc65c0f1ed59', '6e71f5ca-7b79-5b7c-962e-a909e5653664', '14a6b34a-10d8-525e-91ee-e5b3013565d2', 'c4feb1b1-1100-55ff-abd5-d131603596df', '5f99c5d2-54ac-5a16-9d27-65f0decd8f8f', 'a136abb9-775a-5377-aaee-8a81bbb4fbdd', 'bd98a7b7-963c-5b43-ae77-2e6c8c237356', '9945cbd0-f927-5d91-b210-751653726523', '0fbf95ec-ae24-56e0-81e9-44e3be054758', '322993ae-b799-5b64-832d-79304684c521', 'f73c9d5a-b373-54d2-b0d2-bc389b6ab51d', 'da41089a-e5db-5ccf-9945-5258baa62619', '1924254e-f7c2-51fb-ae21-9f0f96511f73', '483e47a1-293a-56b2-ac17-7c45950b016d', '72d84cac-e653-583d-9e4f-d2f8a48c8b38', 'ad0e242f-cc7d-5992-b5b8-49de736f6cb6', 'a6a1a488-ad22-52d9-b56c-1bdf10ad09a8', 'a64c0208-fd7c-521a-ab19-9d126b534163', '0ff3b915-35fe-5223-8bbe-313a565b0ea7', 'cb09cda5-607a-5b06-8503-a65584eb1396', '3c7a85ac-c542-5d37-8c07-ac1f33f2ea9c', 'dbc3a5e2-51e0-55de-8b15-71e3b829128a', '78e56829-d7ff-5880-8ffb-553f924001f7', '5645a238-81c4-5c5f-977f-a945abd759c3', 'f8b6d6a9-8db7-509c-820c-e197f4143257', '79b39e3d-c0a8-501b-8eda-93e107fc690d', '6c3ef56b-7eed-561a-9e7d-d2072d6fbc83', '7b8c50d4-3a98-5a0b-8103-24b67d135cdf', '57389953-a54b-5043-8327-8ecc0a525bce', 'f028ed4d-d274-5657-a4f8-488953b2bc69', '68fe6bb1-7aaa-58c0-9383-68c3c8c5b8d5', 'd30414ef-01c6-547f-8902-b8c401b81871', 'd09382b7-e66b-5af3-86bb-410f49a35f62', '22846170-63a4-5d6d-bcd6-a3c19f2d6722', 'b5feaebc-e0c8-500a-9642-e9cb2c683d3d', 'f3f0c5ef-a340-5f1a-93de-1b992dbaae81', '5b18b27a-abc5-5d47-9394-1eb895d8dbe1', 'acc63222-2a38-55ea-ae27-71de59888967', 'acfdb743-d312-502f-b385-86a121074a42', 'a542e9fa-0dce-5bab-a824-8df62a577550', '1c2d5eef-0f59-5b52-ad85-fb48714e4b84', '1db1308f-359f-5acf-a87a-377caa2929a6', 'ec756b09-75dc-5697-97e9-025a04f46d4b', 'f5efec81-b1e7-5bf7-b8d5-4e09ec3c4b11', '540d1a9f-e2bb-5f12-8cf2-663c9d35a284', '916f31cc-d845-58ce-ba40-dc510a837953', '611e301f-a528-5da9-b4e1-83ba55cfd04a', '5cd1dde7-b24c-5b39-a419-78cc4c5ff592', 'e1222319-3b4c-5d48-8142-82bfed4def53', '306138aa-f99d-59c0-b4c2-de0539df797a', '0a15989e-fb4e-5a41-b414-a5eef29d395e', '08a43046-1b87-5bc0-999e-d71d4e89941b', 'a93529d3-34ba-54a8-a483-72f15e77b4c6', '6138f955-e2f5-5fe0-a04f-82d4c51be333', 'bc5cbbfd-5de3-54d9-82e4-9715ebb55f71', '4e3d6265-d782-5275-9ea0-02a7c5496202', 'd00230b8-4baa-5bdc-bcad-80e180e10e80', '870eb1e7-0b25-5091-8174-11a669161bc8', '3c51e04d-df99-5883-bfdf-d17e8e621aca', 'a9c9eade-20e9-59f7-88b6-2c738a7ad03b', '52df5b16-6e3b-528e-b4ef-435805ff69b2', 'b73fade8-ee79-5223-82d1-8989cf066ca2', '937afd0f-c2a0-5397-83f1-3c514f320ae8', 'bd25ca23-092d-570b-a9f8-c1501461d4de', '696d0e27-8d14-54d7-9054-465265d599da', '76a15040-84a0-5d27-8960-669fea2d9553', '65f405bd-260d-5e76-a88e-d3aa964f8a75', '603c7edf-e033-56c2-9c66-661ae74dae0c', 'cb1aa04f-7780-501f-8416-8dc0c615b542', '9ce3e9db-91ac-54bc-85a5-f2d7fc7df091', 'b328da5f-a697-5a65-a2d9-cbbb22192127', 'ba5edd2b-8681-51b5-a69b-7ef1c439bbba', '1c9df838-5704-5473-8721-4075efeaee7b', '2e378087-4743-5e78-b7a3-1d687a578c92', '0b44214a-d193-5112-8f47-dbb108919280', '0f2e8aaf-62c4-5d5a-85e0-1b715b1c048f', '50a68ca4-9490-5ca9-a0db-8dab42464677', '81bbe89c-0086-5334-afcb-a0559de09181', '20675ea6-06f4-5144-89e3-32c87df1ea1a', 'cbd51191-9b0c-5f3f-8f3d-8296a0b0479c', '21232e26-73fb-518c-8a9e-492bb0db1fd7', 'd809cac4-6c9b-5ce0-9048-de2a5a968b85', 'e4c7cb29-b1d0-5593-91c0-39e2f8f9c8f8', '48b34271-bef9-51d6-8d7c-ad66a8191f11', '92faf612-743d-566a-972c-c9ae3703d5ab', '4290a90f-892d-5788-be17-953b88832471', '35dccd9c-d27d-5030-9c28-d9ccdcd580e4', 'f4baee52-d104-5ae2-8cba-3a491e33aaee', 'd07628b8-bfc7-5dad-bb93-a87011aaf2b2', '15fa535b-40ca-5cbb-a50d-3fc1e108d3e2', '16e83eef-5574-5d08-b193-3471eb0b408f', 'e42aa4b5-15ea-5f71-bb81-d64a936de3b5', 'b0e2e557-4e51-57cf-83ce-da3a4e21cc07', 'd104ec5c-81a6-5c63-866a-9522252c27e0', '7ce4818c-5da2-5ecc-83e3-4e402cec0459', 'b28b046c-9e7c-55de-aa73-46012f77537f', '47114e41-7584-5d3a-abfa-9098c996f74d', '739966c5-4a74-52d9-8607-c5393ac34e28', '3f6ec357-9895-5f8d-b9ee-089eea07a246', 'ea7a2fde-b348-52c5-bb4d-a71d8068eda2', '98b20a12-6500-5d37-9031-3aa4c2f9e5be', 'd1c259f5-5f26-5266-9b3f-5edca6b50520', '897236a1-b381-510a-bd50-5c0547a5490e', '886c2ba2-fb8e-5227-ab58-5d5ba1d26192', 'b49c70c0-c84b-57e0-b32e-78aa892ce1bd', 'bb7d8fb4-c3ab-5036-bab0-d19e074f1b75', 'c07d6adc-6118-5723-8c49-b0c8ce864198', '706a4da2-641f-5e28-b40f-fa60716aaf9f', '86e364ed-30cf-5959-bf44-e7449dfd2277', 'a9cc1d7b-b38b-506a-88ca-c50532dd1cb5', 'aaffaad9-4805-5dab-bf2c-126b3cbfaea4', '13f29532-8155-55c2-8c93-0ef87817ae72', '5c19f4da-75ab-514b-b636-3d0099baae2b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'french-7eme' AND source = 'admin' AND id NOT IN ('a334697f-f495-5448-8402-8cebc3cefc15', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'efdb716c-986f-55df-a0aa-838f69aac0c4', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', '870ae3fb-8bd2-519a-b791-0355256928d2', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', '99b16069-34d1-5009-9d7d-8638a9b01ab0', '38d5735d-a8f1-59ca-8c57-40cd29139619', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', '0b92d047-a2a9-5282-aadc-f911acee4298', '018f97a5-b9fe-5893-87bf-732576d4de20', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', '13d1a33a-de49-5219-904e-2ae08637ffe7', '6092477c-5515-51e5-a5f5-a248e6c95610', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', '94a57c15-f021-5b59-801d-448e3fa987ac', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'd5976146-a3d2-5167-a77a-b28380569983', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'eac74520-052d-56bb-b51d-4097b3890bad', '4510eebd-f090-515f-8e35-e02956565360', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'b5a78763-ef19-513a-b319-a730d21f9fc9', '939e571d-f249-5f7e-8f75-2131b01e73eb', '4265e26c-52f7-5421-9c00-5cccde6d08c7', '8a171861-89da-5139-98cd-4efd5afd79e4', '4a439fe4-db3c-5564-917d-b3454827726e', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d');
DELETE FROM public.questions WHERE exercise_id IN ('a334697f-f495-5448-8402-8cebc3cefc15', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'efdb716c-986f-55df-a0aa-838f69aac0c4', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', '870ae3fb-8bd2-519a-b791-0355256928d2', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', '99b16069-34d1-5009-9d7d-8638a9b01ab0', '38d5735d-a8f1-59ca-8c57-40cd29139619', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', '0b92d047-a2a9-5282-aadc-f911acee4298', '018f97a5-b9fe-5893-87bf-732576d4de20', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', '13d1a33a-de49-5219-904e-2ae08637ffe7', '6092477c-5515-51e5-a5f5-a248e6c95610', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', '94a57c15-f021-5b59-801d-448e3fa987ac', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'd5976146-a3d2-5167-a77a-b28380569983', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'eac74520-052d-56bb-b51d-4097b3890bad', '4510eebd-f090-515f-8e35-e02956565360', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'b5a78763-ef19-513a-b319-a730d21f9fc9', '939e571d-f249-5f7e-8f75-2131b01e73eb', '4265e26c-52f7-5421-9c00-5cccde6d08c7', '8a171861-89da-5139-98cd-4efd5afd79e4', '4a439fe4-db3c-5564-917d-b3454827726e', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d') AND id NOT IN ('976e6fe4-5b49-586f-883a-d9e9f0c081a4', 'db41d9df-95da-557d-82ab-e08a22c0020f', 'c8a454d8-818a-553e-b22a-c483992cdae0', '40ff7c0c-2205-5dd6-94b2-8ad148ebc49f', '9afb3059-f7f8-56b3-a869-54d33a4aaefc', '9c11a918-04aa-5cec-92fa-7c29c7f260cf', '01a9a294-1675-5159-8c32-af6c76e6827e', '6ba20833-b151-5b18-8a2e-a1475ae8cdba', '3bc9abd0-5b42-5128-8f7b-abdbcd90cdb3', 'a85ae49b-77b2-58f3-89bc-5828ca448807', 'c7dc6e55-e505-5c77-b4e1-c3bc3941fea6', '26cb8fdb-4cc1-5585-9067-80cf0fbf852e', '591d194f-33fe-5eb3-9357-88c217b4b8f7', '4ea63a15-04e4-5e29-80ae-70b2af0c70df', '8721e697-8ba1-5389-b093-11302f1b3dbb', 'cb36d499-02d8-58d6-bc00-f423cea2e528', '8f4253b2-200a-5f3c-b112-b5dd8682beac', 'c77e2843-82c3-52f4-807b-6660a6bce8c1', '2d8a35c6-8da7-51be-9c58-c5e789279669', 'ac6fdf66-ba0e-5404-8c39-f75938575262', '43df3c5a-60c8-59c8-94c6-3e79c3ab2748', 'deb56b93-e341-51ef-8324-3625d3a5cf9e', '278e431b-ceee-5951-a06b-6f176d198140', '78a64ac8-e5d7-57d0-b58d-5c21785063ca', '00ea00e7-81df-5713-9516-0e0f26478104', 'd3e7c98a-4807-5c39-9419-d9add58477dc', '0933e54e-78f2-5741-865a-4d8b439369be', '6f24b257-3d4f-5b34-93d1-de677b137591', '5f1df333-158d-5a52-8f36-86f5b6708f20', 'a5cf1bda-f8e2-5c54-b434-f3db37bdde2b', '2451a178-c2c0-5bf6-8049-cefbe0b67ea3', 'c65e0c71-483d-550f-8e90-2ef05310be38', 'f9eab841-bbe6-53b8-8b5b-4a270156a2b9', '1fcb1efe-d737-5014-b350-3119d4d324c3', '2e2c0d83-aa60-5436-aeff-da8ba96b03ec', 'c70a43b8-7ba5-5f67-b0ca-98ba3cc20816', '1cb9c356-6c42-5d63-9ad7-ee57dbae7e4f', 'bce98825-cd7f-520e-a32f-8185b2aace7a', 'f16e9c89-734b-5de6-8d08-551b1d62a1c7', '37efb182-9d3c-51f0-8d56-4262b892cf0f', '441b13a8-85f6-5b39-b0b9-25e55057694b', '9b00ef85-9dfc-5f4b-aa71-fc229e8a904b', '3d7b2f38-cfe9-5abc-8e13-f216a45da40e', '396ddaf3-d18b-571a-b1fb-adf6bc7c25a4', 'c09583b8-2eeb-5a6a-b8d2-73ee4188282a', 'd0f6544a-de1e-586a-810f-315705762fb6', 'a5ad3943-6fa3-5fcc-9ec4-e698b094b448', '0a01d389-90c8-55df-a109-bf8efb11d5e6', '0594d7f3-fd69-5af1-bd84-28576507a164', '80284306-374c-5950-9bf0-ee63dbf4d566', '9140cf80-f559-5709-a5ca-39a0c0b95788', 'f3b0417a-13b1-59d9-b829-75276e09d0ba', 'b09f4830-f83a-5682-b968-0507b7c48225', '965fabc0-08fa-5c68-8305-a1799dabb089', '3dd60966-0d9c-556c-a86e-19d374668362', 'e3a6c2c1-8754-5473-9b27-0fb61669e28f', '8f54f6a8-14a1-5ac0-b668-b12d9c0b8c99', 'ab362268-2a4f-5e6c-b881-461682b745d4', '0a16e931-dcb5-5ea2-94e9-049f45b61f3a', '84159263-c4b7-5241-9216-f33d0434fe46', 'c4ce4e63-ffe1-5144-a3de-6945dba7aa36', '3e66480d-06d6-53f0-8798-bfa1d13e7878', '849f7186-bf21-523f-b0dc-bd6eaf2e45f5', '87377104-3846-5e21-9419-b47d12027968', '4cc56ce3-cbec-566e-9d7d-0eaa649fed4d', 'd9f163f9-dfd9-5fd5-868b-6519ad239e1e', '5b988d77-9284-569b-8e67-2b5fb6ae9dec', 'd70d42e2-4d38-5684-8bfc-867da3cdc32f', '3fee4803-d3ab-523c-9ee5-ed0f50fd34a9', 'fdd0be9f-29be-5edd-b41f-f105659e31b4', 'c8247de8-33db-5da3-9309-488f76ba34b3', '183db602-5a7e-5833-ab05-3ce5b0680b5b', '54e2dc59-8308-5bd5-a25d-1bddca6f8f0e', '1ccf6e9f-7ef6-584d-9443-d7b21ee9ac1e', '8dc05e29-adbd-5738-9e3b-fbfb86adef44', '2e09e5bf-1e31-5931-aa6d-66fabcaaf89a', 'b2fce535-dc06-5802-812e-12c88a809f59', '8db64676-74a2-5a33-8283-1bd9f12980c1', '4e45c6ed-d298-57e9-816d-1fa1e1722c4d', 'de483ea6-ba44-5c0c-b048-96ca3cd39290', 'f75b2b2f-bb1b-5198-a15d-dcba9adc87aa', 'c764e0f5-f73d-587e-b464-6a06759cc247', '62e9a750-5dc8-5099-9a4e-65b3e45cae55', '16c6fbf5-ae44-59b8-94f2-ab64ee3c1454', 'd9e94a90-4977-594a-a3df-e0386a5cc4aa', '045f9cf3-c80c-5c00-a77b-18389fcc3ceb', '621e26ca-425e-5542-8ea2-d6e369884f35', '349fbcf2-f64c-5d6b-9c8e-d2ef96e23876', '1e7d33aa-8fdb-5f1a-9065-9f0f586f6a66', '5239f6a0-9208-5a7e-9fd9-e64663542f1b', 'bf45cedb-df42-5fa0-b21e-0ae99ee49482', '2fa05f10-0cba-5d87-8676-5beba260dce8', 'aad6bb64-2ab3-5bba-a077-e3d969df32cd', '55710205-0a61-5af4-a214-fbb6e51569b5', '7ac60b94-ece9-5c8c-aa61-47de3d9496f5', '1cf07c35-ec20-534c-8e97-922d010b3e30', 'db18977d-2ff0-5312-be71-8a7638a3b0f3', '850af2b6-c8e3-526d-b2ed-ff0f2fba3e74', '893992a7-c755-5cfb-800e-cc73a7cf873f', '014c22b3-8d3a-58ee-9ae4-08b81336d81c', '1f6b2a93-0bc3-545c-9ea0-39a5022d77fe', 'fa811334-307a-545d-bad6-96b69671f232', '73c75612-0518-5f8a-a199-fec0d77cb396', 'b26a04c3-ba76-5a16-9b45-08cc5cb8c010', 'f567ef7c-b142-5d1a-8475-8edf4daa416c', '9180cacc-e0fa-57bd-8589-017e0d331e66', '10f84c01-3918-535f-a678-775087f22ac6', '052eaa98-193d-5a29-8211-e2f7cb97403e', 'f9f62452-f2c7-54bf-9822-9216218aa379', '48626e52-cf7b-502e-9cf5-378cd131f71c', '1bd99855-2250-5c62-a99e-ce5cf56f2e4e', 'ae87f18d-220c-5537-956a-698e0dfe1339', 'ac44816f-5fdf-54e2-a440-3fc03b693b38', '2de7d039-07e6-538f-a33e-6f84e585739b', '5c36a524-2eee-5c11-b4b9-8bbc33f00eda', '84b022ca-68f1-58e8-a7f8-0a24c6fa151e', '4cae155d-fb4e-55c2-97ae-b1816dd01893', 'aa2ac075-51a9-5308-94de-3a3b3fdd71c4', '22752aa8-e4c4-51a0-9a83-5b0383ad92e9', 'e01b412b-e688-5157-acc8-246187087418', '188e13fb-3aff-52e0-8e9b-4c2ae0a534b8', '840bd2ac-a0c6-55ae-bac9-f160a731e43f', 'b83906a1-4b2a-5f71-a270-a981f280bafb', 'fd54cacd-dda0-5d36-9484-a40e93a10d4b', 'e027dce5-8bb6-51c1-a6cd-680f00e79f94', 'a6ba8295-b00d-5ae1-abea-2fa61ec84649', '2d348c0e-a2c3-5dc1-b13b-10b5cb6fdc82', 'b3806971-21b2-561f-804e-d5165308c3c3', 'bc3495fe-e2f9-5713-b0e4-620744b77007', 'd31a042e-0908-5ac1-9e55-c2bf28995262', '471310eb-8412-5ece-ad69-540af5c77865', 'f2a9d46e-a70e-5942-9f25-19d0824a07d6', 'f13ccdf6-acb8-57d7-ba7b-778591223e0b', 'c76b1b72-823b-583a-bc76-bc65c0f1ed59', '6e71f5ca-7b79-5b7c-962e-a909e5653664', '14a6b34a-10d8-525e-91ee-e5b3013565d2', 'c4feb1b1-1100-55ff-abd5-d131603596df', '5f99c5d2-54ac-5a16-9d27-65f0decd8f8f', 'a136abb9-775a-5377-aaee-8a81bbb4fbdd', 'bd98a7b7-963c-5b43-ae77-2e6c8c237356', '9945cbd0-f927-5d91-b210-751653726523', '0fbf95ec-ae24-56e0-81e9-44e3be054758', '322993ae-b799-5b64-832d-79304684c521', 'f73c9d5a-b373-54d2-b0d2-bc389b6ab51d', 'da41089a-e5db-5ccf-9945-5258baa62619', '1924254e-f7c2-51fb-ae21-9f0f96511f73', '483e47a1-293a-56b2-ac17-7c45950b016d', '72d84cac-e653-583d-9e4f-d2f8a48c8b38', 'ad0e242f-cc7d-5992-b5b8-49de736f6cb6', 'a6a1a488-ad22-52d9-b56c-1bdf10ad09a8', 'a64c0208-fd7c-521a-ab19-9d126b534163', '0ff3b915-35fe-5223-8bbe-313a565b0ea7', 'cb09cda5-607a-5b06-8503-a65584eb1396', '3c7a85ac-c542-5d37-8c07-ac1f33f2ea9c', 'dbc3a5e2-51e0-55de-8b15-71e3b829128a', '78e56829-d7ff-5880-8ffb-553f924001f7', '5645a238-81c4-5c5f-977f-a945abd759c3', 'f8b6d6a9-8db7-509c-820c-e197f4143257', '79b39e3d-c0a8-501b-8eda-93e107fc690d', '6c3ef56b-7eed-561a-9e7d-d2072d6fbc83', '7b8c50d4-3a98-5a0b-8103-24b67d135cdf', '57389953-a54b-5043-8327-8ecc0a525bce', 'f028ed4d-d274-5657-a4f8-488953b2bc69', '68fe6bb1-7aaa-58c0-9383-68c3c8c5b8d5', 'd30414ef-01c6-547f-8902-b8c401b81871', 'd09382b7-e66b-5af3-86bb-410f49a35f62', '22846170-63a4-5d6d-bcd6-a3c19f2d6722', 'b5feaebc-e0c8-500a-9642-e9cb2c683d3d', 'f3f0c5ef-a340-5f1a-93de-1b992dbaae81', '5b18b27a-abc5-5d47-9394-1eb895d8dbe1', 'acc63222-2a38-55ea-ae27-71de59888967', 'acfdb743-d312-502f-b385-86a121074a42', 'a542e9fa-0dce-5bab-a824-8df62a577550', '1c2d5eef-0f59-5b52-ad85-fb48714e4b84', '1db1308f-359f-5acf-a87a-377caa2929a6', 'ec756b09-75dc-5697-97e9-025a04f46d4b', 'f5efec81-b1e7-5bf7-b8d5-4e09ec3c4b11', '540d1a9f-e2bb-5f12-8cf2-663c9d35a284', '916f31cc-d845-58ce-ba40-dc510a837953', '611e301f-a528-5da9-b4e1-83ba55cfd04a', '5cd1dde7-b24c-5b39-a419-78cc4c5ff592', 'e1222319-3b4c-5d48-8142-82bfed4def53', '306138aa-f99d-59c0-b4c2-de0539df797a', '0a15989e-fb4e-5a41-b414-a5eef29d395e', '08a43046-1b87-5bc0-999e-d71d4e89941b', 'a93529d3-34ba-54a8-a483-72f15e77b4c6', '6138f955-e2f5-5fe0-a04f-82d4c51be333', 'bc5cbbfd-5de3-54d9-82e4-9715ebb55f71', '4e3d6265-d782-5275-9ea0-02a7c5496202', 'd00230b8-4baa-5bdc-bcad-80e180e10e80', '870eb1e7-0b25-5091-8174-11a669161bc8', '3c51e04d-df99-5883-bfdf-d17e8e621aca', 'a9c9eade-20e9-59f7-88b6-2c738a7ad03b', '52df5b16-6e3b-528e-b4ef-435805ff69b2', 'b73fade8-ee79-5223-82d1-8989cf066ca2', '937afd0f-c2a0-5397-83f1-3c514f320ae8', 'bd25ca23-092d-570b-a9f8-c1501461d4de', '696d0e27-8d14-54d7-9054-465265d599da', '76a15040-84a0-5d27-8960-669fea2d9553', '65f405bd-260d-5e76-a88e-d3aa964f8a75', '603c7edf-e033-56c2-9c66-661ae74dae0c', 'cb1aa04f-7780-501f-8416-8dc0c615b542', '9ce3e9db-91ac-54bc-85a5-f2d7fc7df091', 'b328da5f-a697-5a65-a2d9-cbbb22192127', 'ba5edd2b-8681-51b5-a69b-7ef1c439bbba', '1c9df838-5704-5473-8721-4075efeaee7b', '2e378087-4743-5e78-b7a3-1d687a578c92', '0b44214a-d193-5112-8f47-dbb108919280', '0f2e8aaf-62c4-5d5a-85e0-1b715b1c048f', '50a68ca4-9490-5ca9-a0db-8dab42464677', '81bbe89c-0086-5334-afcb-a0559de09181', '20675ea6-06f4-5144-89e3-32c87df1ea1a', 'cbd51191-9b0c-5f3f-8f3d-8296a0b0479c', '21232e26-73fb-518c-8a9e-492bb0db1fd7', 'd809cac4-6c9b-5ce0-9048-de2a5a968b85', 'e4c7cb29-b1d0-5593-91c0-39e2f8f9c8f8', '48b34271-bef9-51d6-8d7c-ad66a8191f11', '92faf612-743d-566a-972c-c9ae3703d5ab', '4290a90f-892d-5788-be17-953b88832471', '35dccd9c-d27d-5030-9c28-d9ccdcd580e4', 'f4baee52-d104-5ae2-8cba-3a491e33aaee', 'd07628b8-bfc7-5dad-bb93-a87011aaf2b2', '15fa535b-40ca-5cbb-a50d-3fc1e108d3e2', '16e83eef-5574-5d08-b193-3471eb0b408f', 'e42aa4b5-15ea-5f71-bb81-d64a936de3b5', 'b0e2e557-4e51-57cf-83ce-da3a4e21cc07', 'd104ec5c-81a6-5c63-866a-9522252c27e0', '7ce4818c-5da2-5ecc-83e3-4e402cec0459', 'b28b046c-9e7c-55de-aa73-46012f77537f', '47114e41-7584-5d3a-abfa-9098c996f74d', '739966c5-4a74-52d9-8607-c5393ac34e28', '3f6ec357-9895-5f8d-b9ee-089eea07a246', 'ea7a2fde-b348-52c5-bb4d-a71d8068eda2', '98b20a12-6500-5d37-9031-3aa4c2f9e5be', 'd1c259f5-5f26-5266-9b3f-5edca6b50520', '897236a1-b381-510a-bd50-5c0547a5490e', '886c2ba2-fb8e-5227-ab58-5d5ba1d26192', 'b49c70c0-c84b-57e0-b32e-78aa892ce1bd', 'bb7d8fb4-c3ab-5036-bab0-d19e074f1b75', 'c07d6adc-6118-5723-8c49-b0c8ce864198', '706a4da2-641f-5e28-b40f-fa60716aaf9f', '86e364ed-30cf-5959-bf44-e7449dfd2277', 'a9cc1d7b-b38b-506a-88ca-c50532dd1cb5', 'aaffaad9-4805-5dab-bf2c-126b3cbfaea4', '13f29532-8155-55c2-8c93-0ef87817ae72', '5c19f4da-75ab-514b-b636-3d0099baae2b');
DELETE FROM public.chapters c WHERE c.subject_id = 'french-7eme' AND c.id NOT IN ('d80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', '331dfde0-73a4-592f-87d4-2d91ef9885f9', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', '92637f9c-679a-5afc-bc18-78093aab3928', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', 'Prérequis — présent, passé composé, types de phrases', 'Module de contrôle et de consolidation des prérequis : le présent de l''indicatif (valeurs et terminaisons des trois groupes), le passé composé (auxiliaire être ou avoir, terminaisons du participe passé, accord du participe passé avec être, verbes de mouvement et pronominaux), les types de phrases (déclarative, interrogative, exclamative) et les formes affirmative et négative, les homophones ce/se, ces/ses, c''est/s''est, et la lecture d''un court récit (personnages, narrateur, substituts, synonymes).', '# ⚔️ Réveille tes pouvoirs — présent, passé composé et types de phrases

> 💡 « Avant d''ouvrir les portes du collège, un héros vérifie ses armes : tes acquis du primaire sont ton équipement de départ. »

## 🏰 Le présent de l''indicatif : ses trois valeurs

Tu sais déjà conjuguer au présent. Mais sais-tu **pourquoi** on l''emploie ? Le présent a **trois valeurs** :

| Valeur                   | Ce qu''elle exprime                                         | Exemple                                                        |
| ------------------------ | ---------------------------------------------------------- | -------------------------------------------------------------- |
| **Action en cours**      | une action en train de se réaliser au moment où l''on parle | _Regarde, il pleut sur la ville._                              |
| **Présent de narration** | une action passée racontée au présent (récit plus vivant)  | _Hier, je marche dans la rue quand un chat surgit devant moi._ |
| **Vérité générale**      | un fait toujours vrai                                      | _La Terre tourne autour du Soleil._                            |

> 🗡️ Astuce : dans un récit au passé, un verbe au présent n''est pas une erreur — c''est souvent le **présent de narration**, qui rend l''histoire plus vivante.

## ⚡ Les terminaisons du présent (les trois groupes)

| Personne  | 1er groupe (_ranger_) | 2e groupe (_finir_) | 3e groupe (_prendre_, _venir_) |
| --------- | --------------------- | ------------------- | ------------------------------ |
| je        | range                 | fin**is**           | prends / viens                 |
| tu        | ranges                | fin**is**           | prends / viens                 |
| il/elle   | range                 | fin**it**           | prend / vient                  |
| nous      | rangeons              | fin**issons**       | prenons / venons               |
| vous      | rangez                | fin**issez**        | prenez / venez                 |
| ils/elles | rangent               | fin**issent**       | prennent / viennent            |

- **1er groupe** (verbes en _-er_) : _-e, -es, -e, -ons, -ez, -ent_. On écrit _je range_ (jamais « je ranges » : le _-s_ n''apparaît qu''avec **tu**).
- **2e groupe** (verbes en _-ir_ comme _finir, mûrir, choisir_) : n''oublie pas l''élément **-iss-** au pluriel : _les fruits mûr**issent**_.
- **3e groupe** (verbes irréguliers) : terminaisons le plus souvent _-s, -s, -t, -ons, -ez, -ent_, avec un radical qui peut changer (_je viens → nous venons → ils viennent_).

> ⚠️ Rappel : _mon père et moi_ = **nous** ; _ton frère et toi_ = **vous**. Le verbe se conjugue avec le pronom équivalent : _Mon père et moi **prenons** le louage._

## 🔮 Le passé composé : auxiliaire + participe passé

Le **passé composé** exprime une action passée et terminée. Il est formé de **l''auxiliaire _être_ ou _avoir_ au présent + le participe passé** du verbe : _j''**ai fini**, elle **est partie**_.

Les terminaisons du participe passé :

| Terminaison | Verbes                          | Exemple                              |
| ----------- | ------------------------------- | ------------------------------------ |
| **-é**      | verbes en _-er_                 | manger → mang**é**                   |
| **-i**      | la plupart des verbes en _-ir_  | finir → fin**i**                     |
| **-u**      | beaucoup de verbes du 3e groupe | perdre → perd**u**, venir → ven**u** |
| **-is**     | quelques verbes du 3e groupe    | prendre → pr**is**                   |
| **-it**     | quelques verbes du 3e groupe    | écrire → écr**it**                   |

> ⚠️ Le piège classique : « ils ont prit » est faux — le participe passé de _prendre_ est **pris** (_ils ont **pris**_). Le _-t_ final appartient à _il prit_ (autre temps), pas au participe.

## 🛡️ L''accord du participe passé avec « être »

**Avec l''auxiliaire _être_, le participe passé s''accorde avec le sujet** (en genre et en nombre) : _elle est all**ée**, Salma et sa cousine sont part**ies**_.

Se conjuguent avec **être** :

- les **verbes de mouvement ou de changement** : _aller, venir, arriver, partir, entrer, sortir, monter, descendre, tomber, rester, retourner, rentrer…_
- les **verbes pronominaux** (avec _se_) : _se lever, se réveiller, se promener, s''entraîner…_ → _elles **se sont entraînées**_.

> ⚠️ Deux pièges à désamorcer : (1) tous les verbes de mouvement ne prennent pas _être_ — _courir, marcher, nager, voyager_ se conjuguent avec **avoir** (_il **a couru**_) ; (2) avec l''auxiliaire **avoir**, le participe passé **ne s''accorde pas avec le sujet** : _elles **ont préparé** le dîner_ (jamais « préparées » — la règle complète de l''accord avec _avoir_ viendra plus tard dans l''année).

## 📐 Les types et les formes de phrases

Ce module révise **trois types** de phrases, selon l''intention de celui qui parle :

| Type              | Intention                                                                          | Ponctuation | Exemple                             |
| ----------------- | ---------------------------------------------------------------------------------- | ----------- | ----------------------------------- |
| **Déclarative**   | donner une information, raconter                                                   | .           | _Le match commence à trois heures._ |
| **Interrogative** | poser une question (_Est-ce que…_ ou inversion du sujet : _Viens-tu ?_)            | ?           | _Où habites-tu ?_                   |
| **Exclamative**   | exprimer un sentiment (joie, colère, tristesse…), souvent avec _Quel…_ ou _Comme…_ | !           | _Quelle belle victoire !_           |

Chaque type peut être à la **forme affirmative** ou à la **forme négative**. La négation encadre le verbe avec **deux mots** : _ne… pas, ne… jamais, ne… plus, ne… rien_. Une même phrase combine donc un type **et** une forme : _« Pourquoi ne viens-tu pas ? »_ = interrogative **et** négative.

## 🧪 Les homophones ce / se, ces / ses, c''est / s''est

| J''écris   | Quand ?                                          | Test infaillible                                              |
| --------- | ------------------------------------------------ | ------------------------------------------------------------- |
| **ce**    | déterminant démonstratif devant un nom masculin  | _**ce** cartable_ → on montre                                 |
| **se**    | pronom d''un verbe pronominal                     | _il **se** lave_ → verbe                                      |
| **ces**   | déterminant démonstratif devant un nom pluriel   | _**ces** nuages_ → ceux que je montre                         |
| **ses**   | déterminant possessif devant un nom pluriel      | _**ses** filets_ → les siens                                  |
| **c''est** | présentatif (3e personne du singulier seulement) | remplaçable par « **cela est** »                              |
| **s''est** | verbe pronominal au passé composé                | **toujours suivi d''un participe passé** : _il **s''est** levé_ |

> 🗡️ Réflexe d''élite : devant un participe passé → **s''est** ; remplaçable par « cela est » → **c''est**.

## 📖 Lire un court récit : narrateur, personnages, substituts

Dans un récit, distingue :

- les **personnages** : ceux qui agissent dans l''histoire ;
- le **narrateur** : celui qui raconte. S''il dit « je », c''est un personnage ; sinon, c''est un **narrateur extérieur** à l''histoire ;
- les **substituts** : les mots qui reprennent un nom pour éviter la répétition (_le grand-père… **le vieil homme**… **il**_) ;
- les **synonymes** : des mots de sens proche (_content ≈ **heureux**_).

Exemple : _« Yassine court vers le port. Son grand-père l''attend. Le vieil homme sourit. »_ → « le vieil homme » est un **substitut** de « son grand-père ».

> 🏆 Prérequis consolidés : tes armes du primaire sont affûtées. Prochaine étape : le module « En famille », où tu conquerras le futur simple et l''impératif !', '# 📜 Résumé : Prérequis — présent, passé composé et types de phrases

- **Présent de l''indicatif — 3 valeurs** : action en cours (_il pleut_), présent de narration (récit vivant), vérité générale (_la Terre tourne_).
- **Terminaisons du présent** : 1er groupe _-e, -es, -e, -ons, -ez, -ent_ (je range, jamais « je ranges ») ; 2e groupe avec **-iss-** au pluriel (_ils finissent_) ; 3e groupe _-s, -s, -t, -ons, -ez, -ent_ avec radical variable (_ils viennent_).
- **Passé composé** = auxiliaire _être_ ou _avoir_ **au présent** + participe passé ; terminaisons du PP : **-é** (mangé), **-i** (fini), **-u** (perdu), **-is** (pris), **-it** (écrit).
- **Accord du PP avec _être_** : accord avec le **sujet** (_elles sont parties_) ; verbes de mouvement (_aller, arriver, partir, rester…_) et pronominaux (_elles se sont entraînées_) ; mais _courir, marcher, nager_ → **avoir**, et avec **avoir** le PP ne s''accorde pas avec le sujet.
- **3 types de phrases** : déclarative (.), interrogative (? — _Est-ce que…_ ou inversion), exclamative (! — _Quel… / Comme…_) ; chaque type est de **forme affirmative ou négative** (_ne… pas / jamais / plus / rien_).
- **Homophones** : _ce_ + nom masculin / _se_ + verbe ; _ces_ = qu''on montre / _ses_ = les siens ; _c''est_ = « cela est » / _s''est_ = toujours suivi d''un **participe passé**.
- **Lire un récit** : personnages (agissent), narrateur (« je » = personnage, sinon extérieur), substituts (mots qui reprennent un nom), synonymes (sens proche).', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', 'En famille : passé composé, futur simple et impératif', 'Module 1 — la vie de famille : raconter au passé composé (accord du participe passé avec être, verbes pronominaux et verbes de mouvement), annoncer au futur simple (terminaisons uniques, radicaux irréguliers), ordonner et conseiller à l''impératif ; phrase verbale, non verbale et minimale ; enrichir une phrase avec des compléments circonstanciels ; homophones à / as / a.', '# ⚔️ En famille — trois temps pour raconter, annoncer et commander

> 💡 « Une famille vit dans trois temps à la fois : elle raconte hier, elle prépare demain et elle donne des consignes aujourd''hui. Maîtrise ces trois armes et aucune phrase ne te résistera. »

## 🏰 Le passé composé — raconter ce qui s''est passé

Tu connais déjà le passé composé : c''est le temps du récit de la journée. Il se forme avec l''**auxiliaire _être_ ou _avoir_ au présent** + le **participe passé** du verbe.

- _Hier soir, papa **a préparé** le couscous._ (avoir + préparé)
- _Ma sœur **est rentrée** tard du lycée._ (être + rentrée)

Le **participe passé** se termine le plus souvent par **-é** (manger → mangé), **-i** (finir → fini) ou **-u** (voir → vu).

> ⚠️ Un verbe au passé composé s''écrit toujours en **deux mots** : auxiliaire + participe passé. « Papa préparé le dîner » est incorrect : il manque l''auxiliaire.

## 🛡️ L''accord du participe passé avec _être_

Avec l''auxiliaire **être**, le participe passé **s''accorde avec le sujet** en genre et en nombre :

| Sujet                   | Phrase                          | Accord             |
| ----------------------- | ------------------------------- | ------------------ |
| Mon oncle (masc. sing.) | Mon oncle est **arrivé**.       | — (rien à ajouter) |
| Ma tante (fém. sing.)   | Ma tante est **arrivée**.       | + e                |
| Mes cousins (masc. pl.) | Mes cousins sont **arrivés**.   | + s                |
| Mes cousines (fém. pl.) | Mes cousines sont **arrivées**. | + es               |

Deux familles de verbes prennent l''auxiliaire **être** :

- Les **verbes de mouvement** : _aller, venir, arriver, partir, entrer, sortir, monter, descendre, tomber, rester, retourner_. → _Mes sœurs **sont sorties** dans le jardin._
- Les **verbes pronominaux** (avec _me, te, se, nous, vous_) : _se lever, se laver, se coucher, s''habiller_. → _Salma et Rim **se sont levées** tôt._

> ⚠️ Le piège classique : _« ils **ont** arrivé »_. Les verbes de mouvement et les verbes pronominaux se conjuguent avec **être**, jamais avec _avoir_ : _ils **sont** arrivés_, _elle **s''est** couchée_ (et non « elle s''a couchée »).

## ⚡ Le futur simple — annoncer ce qui vient (ou donner une consigne)

Le futur simple exprime une **action à venir** : _Demain, je **rangerai** ma chambre._
Il peut aussi exprimer un **ordre** ou une **consigne** : _Tu **feras** tes devoirs avant de sortir._

Bonne nouvelle : au futur, **tous les verbes ont les mêmes terminaisons**.

$$ -rai · -ras · -ra · -rons · -rez · -ront $$

- _je range**rai**, tu range**ras**, il range**ra**, nous range**rons**, vous range**rez**, ils range**ront**_

Certains verbes très fréquents changent de **radical** au futur — apprends-les par cœur :

| Verbe | Radical du futur | Exemple                     |
| ----- | ---------------- | --------------------------- |
| être  | **ser-**         | je serai, tu seras          |
| avoir | **aur-**         | j''aurai, vous aurez         |
| aller | **ir-**          | nous irons, ils iront       |
| faire | **fer-**         | tu feras, nous ferons       |
| venir | **viendr-**      | il viendra, elles viendront |

> ⚠️ Deux pièges d''orthographe : à la 1re personne, la terminaison du futur est **-rai** (jamais « -rais » : _je mangerai demain_) ; et _faire_ garde **un seul r** au radical : _nous **ferons**_ (jamais « ferrons »).

## 🔮 L''impératif — ordonner et conseiller

L''impératif sert à donner des **ordres** ou des **conseils**. Deux signes le trahissent :

1. Le **sujet n''est pas exprimé** : _**Range** ta chambre !_ (et non « Tu range… »)
2. Le verbe ne compte que **trois personnes** : _tu_, _nous_, _vous_ (sous-entendues).

| Personne sous-entendue | ranger (1er groupe) | finir (2e groupe) | prendre (3e groupe) |
| ---------------------- | ------------------- | ----------------- | ------------------- |
| tu                     | Range !             | Finis !           | Prends !            |
| nous                   | Rangeons !          | Finissons !       | Prenons !           |
| vous                   | Rangez !            | Finissez !        | Prenez !            |

> ⚠️ À la 2e personne du singulier, les verbes du **1er groupe** (et _aller_) **perdent le -s** : _Mange ta soupe !_, _**Va** au marché !_ (jamais « Vas au marché ! »). Les autres groupes gardent le **-s** : _Finis tes devoirs !_, _Prends ton cartable !_ Retiens aussi les irréguliers : _sois_ (être), _aie_ (avoir).

> 🗡️ Avec un verbe pronominal, le pronom passe **après** le verbe, relié par un trait d''union : _Lève-**toi** tôt !_, _Couchez-**vous** avant dix heures !_

## 📐 Phrase verbale, phrase non verbale, phrase minimale

- Une phrase qui contient un **verbe conjugué** est **verbale** : _Le dîner est prêt._
- Une phrase **sans verbe conjugué** est **non verbale** : _Quel désordre dans le salon !_ / _Départ à sept heures._
- La **phrase minimale** est la phrase verbale réduite à ses deux groupes obligatoires : le **groupe sujet** (qui fait l''action) + le **groupe verbal** (ce que fait ou ce qu''est le sujet). → _Mon frère **débarrasse la table**._

## 🧭 Les compléments circonstanciels — enrichir la phrase minimale

Pour enrichir une phrase minimale, on ajoute des **compléments circonstanciels** (CC) : ils précisent le **temps** (_chaque soir_), le **lieu** (_dans la cuisine_) ou la **manière** (_avec soin_).

- Phrase minimale : _Ma grand-mère prépare le tajine._
- Phrase enrichie : _**Le vendredi**, ma grand-mère prépare le tajine **dans la cuisine**, **avec soin**._

> 🗡️ Le test du CC : on peut le **supprimer** ou le **déplacer** sans détruire la phrase. Si le groupe résiste au test, ce n''est pas un CC.

## ✍️ Orthographe : les homophones à / as / a

| Forme  | Nature                        | Test                             | Exemple                          |
| ------ | ----------------------------- | -------------------------------- | -------------------------------- |
| **a**  | verbe _avoir_, 3e pers. sing. | remplaçable par **avait**        | Papa **a** préparé le dîner.     |
| **as** | verbe _avoir_, 2e pers. sing. | remplaçable par **avais**        | Tu **as** fini ton assiette.     |
| **à**  | préposition (avec accent)     | **impossible** de dire « avait » | Rim aide sa mère **à** cuisiner. |

> 🏆 Première porte du collège franchie : tu sais raconter la journée de ta famille au passé composé, annoncer le programme de demain au futur et distribuer les consignes à l''impératif. Prochain module : direction la ville et la campagne, où le groupe nominal va s''agrandir !', '# 📜 Résumé : En famille — passé composé, futur simple et impératif

- **Passé composé** = auxiliaire (_être_ ou _avoir_) **au présent** + **participe passé** (-é, -i, -u) : _papa a préparé, ma sœur est rentrée_. Toujours **deux mots**.
- **Avec _être_, le participe passé s''accorde avec le sujet** (genre + nombre) : _mes cousines sont arrivées_. Prennent _être_ : les **verbes de mouvement** (aller, venir, arriver, partir, sortir, monter…) et les **verbes pronominaux** (_elles se sont levées_) — jamais « ils ont arrivé ».
- **Futur simple** = action à venir ou consigne ; terminaisons **identiques pour tous les verbes** : -rai, -ras, -ra, -rons, -rez, -ront. Radicaux irréguliers : être → **ser-**, avoir → **aur-**, aller → **ir-**, faire → **fer-** (un seul r : _nous ferons_), venir → **viendr-**. 1re personne = **-rai** (jamais « -rais »).
- **Impératif** = ordres et conseils ; **sujet non exprimé**, **trois personnes** (tu, nous, vous). 1er groupe et _aller_ : **pas de -s** à la 2e pers. sing. (_Mange !_, _Va !_) ; autres groupes : -s (_Finis !_, _Prends !_). Irréguliers : _sois, aie_. Pronominal : _Lève-toi !_
- **Phrase verbale** (verbe conjugué) / **non verbale** (sans verbe conjugué) ; **phrase minimale** = **groupe sujet + groupe verbal**.
- **Compléments circonstanciels** (temps, lieu, manière) : ils enrichissent la phrase minimale et se laissent **supprimer ou déplacer**.
- **Homophones** : **a** = avoir (→ _avait_) ; **as** = avoir, 2e pers. (→ _avais_) ; **à** = préposition (test « avait » impossible).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', 'Ville et campagne — le futur simple et l''expansion du GN', 'Module 2 : décrire la ville et la campagne — le futur simple (verbes réguliers, verbes pronominaux, radicaux irréguliers fréquents ser-/aur-/ir-/fer-/viendr-), le groupe nominal minimal et étendu, l''adjectif épithète et l''adjectif attribut, l''accord de l''adjectif en genre et en nombre, et les homophones et/est/es, on/ont.', '# ⚔️ Ville et campagne — décrire les lieux au futur

> 💡 « Pour peindre le monde de demain — la médina animée comme la plaine silencieuse — il te faut deux pouvoirs : projeter l''action dans l''avenir et enrichir chaque nom. »

Tu sais déjà raconter au présent et au passé composé, et tu sais qu''une phrase minimale a un groupe sujet et un groupe verbal. Ici, tu vas apprendre à **annoncer ce qui se passera** dans un lieu (le futur simple) et à **enrichir un nom** pour que ta description devienne vivante.

## 🏰 Le futur simple : l''action à venir

Le **futur simple** exprime une **action qui n''a pas encore eu lieu** : _Demain, nous visiterons la médina._

Sa grande force : au futur, **tous les verbes ont les mêmes terminaisons**, ajoutées le plus souvent à l''infinitif.

| Personne   | Terminaison | Exemple (_visiter_) |
| ---------- | ----------- | ------------------- |
| je         | -rai        | je visite**rai**    |
| tu         | -ras        | tu visite**ras**    |
| il/elle/on | -ra         | elle visite**ra**   |
| nous       | -rons       | nous visite**rons** |
| vous       | -rez        | vous visite**rez**  |
| ils/elles  | -ront       | ils visite**ront**  |

Pour un **verbe régulier**, le radical est l''infinitif : _finir → je finirai_. Les verbes en **-re** perdent le **e** final : _prendre → je prendrai_.

> ⚠️ N''écris jamais « je visite**rais** » pour le futur : à la 1re personne du singulier, la terminaison est **-rai**, sans « s » (« -rais » appartient à un autre temps).

## ⚡ Les cinq radicaux irréguliers à connaître par cœur

Quelques verbes très fréquents changent de **radical** au futur — mais les terminaisons ne changent pas. Retiens ces cinq-là :

| Infinitif                   | Radical du futur | Exemple           |
| --------------------------- | ---------------- | ----------------- |
| être                        | **ser-**         | la place **sera** |
| avoir                       | **aur-**         | tu **auras**      |
| aller                       | **ir-**          | j''**irai**        |
| faire                       | **fer-**         | nous **ferons**   |
| venir (et devenir, revenir) | **viendr-**      | ils **viendront** |

> 🗡️ Piège classique : ne « régularise » pas ces verbes. On écrit _j''**irai**_ (jamais « j''allerai »), _nous **ferons**_ (jamais « nous fairons »), _ils **viendront**_ (jamais « ils veniront »).

## 🔮 Les verbes pronominaux au futur

Un **verbe pronominal** garde son pronom réfléchi (_me, te, se, nous, vous_) devant le verbe conjugué :

- _Je **me promènerai** le long de la plage._
- _Les boutiques du souk **s''ouvriront** tôt le matin._

> ⚠️ N''oublie jamais le pronom : « les boutiques ouvriront » n''est pas construit comme « les boutiques **s''**ouvriront ». Au futur, le pronom reste collé au verbe.

## 🛡️ Le groupe nominal : minimal ou étendu

Un **groupe nominal (GN)** s''organise autour d''un **nom** (le nom noyau).

- **GN minimal** : le nom avec son seul déterminant (ou un nom propre, ou un pronom).
  _le souk · une ferme · Tunis · elle_
- **GN étendu** : on ajoute une **expansion** qui enrichit le nom. En 7ème, cette expansion est un **adjectif épithète**.
  _le **grand** souk · les ruelles **étroites** · les oliveraies **argentées**_

C''est l''arme du descripteur : _une place_ ne dit presque rien ; _une **grande** place **ombragée**_ fait voir le lieu.

## 📐 L''adjectif : épithète ou attribut ?

Le même adjectif peut jouer **deux rôles** différents selon sa place :

| Rôle         | Où se trouve-t-il ?                             | Exemple                     |
| ------------ | ----------------------------------------------- | --------------------------- |
| **Épithète** | **dans le GN**, directement à côté du nom       | _la campagne **calme**_     |
| **Attribut** | **après un verbe d''état** qui le relie au sujet | _la campagne **est** calme_ |

Les **verbes d''état** à connaître : **être, sembler, paraître, devenir, rester**.

> 🗡️ Méthode : regarde le verbe. Si un **verbe d''état** relie le nom et l''adjectif → **attribut**. Si l''adjectif touche directement le nom dans le GN → **épithète**. _Les champs **verts**_ (épithète) / _Les champs **deviennent** verts_ (attribut).

## 🧮 L''accord de l''adjectif en genre et en nombre

Épithète ou attribut, l''adjectif **s''accorde** en **genre** (masculin/féminin) et en **nombre** (singulier/pluriel) avec le nom qu''il complète (épithète) ou avec le **sujet** (attribut) :

$$ un champ vert · une plaine verte · des champs verts · des plaines vertes $$

Certaines finales changent : _-eux → -euse_ (_un site merveilleux → une vue **merveilleuse**_), _-al → -aux_ au masculin pluriel (_un jardin provincial → des jardins **provinciaux**_). D''autres adjectifs sont irréguliers : _blanc → blanche_, _frais → fraîche_, _beau → belle_, _vieux → vieille_.

> ⚠️ Piège de proximité : accorde avec le **bon** mot, pas avec le plus proche. _Les collines du nord-ouest restent **vertes**_ (accord avec « collines », pas avec « nord-ouest »).

## 🧪 Orthographe : et / est / es · on / ont

Ces petits mots se prononcent presque pareil, mais un **test de remplacement** les démasque :

| Mot     | Nature                                  | Test de remplacement        | Exemple                       |
| ------- | --------------------------------------- | --------------------------- | ----------------------------- |
| **et**  | mot de liaison (addition)               | remplaçable par « et puis » | _la ville **et** la campagne_ |
| **est** | verbe être, 3e pers. du singulier       | remplaçable par « était »   | _le souk **est** animé_       |
| **es**  | verbe être, 2e pers. (toujours avec tu) | remplaçable par « étais »   | _tu **es** en ville_          |
| **on**  | pronom personnel sujet                  | remplaçable par « il »      | _**on** traversera la médina_ |
| **ont** | verbe avoir, 3e pers. du pluriel        | remplaçable par « avaient » | _ils **ont** une oliveraie_   |

> 🗡️ « **On** » est toujours **sujet d''un verbe** à la 3e personne du singulier ; « **ont** » est le verbe avoir, suivi d''un participe passé ou d''un complément : _ils **ont** planté des arbres_.

> 🏆 Porte du module 2 franchie ! Tu sais décrire la ville et la campagne au futur, étendre tes GN et déjouer les homophones. Prochaine étape : le monde des animaux et l''armée des déterminants.', '# 📜 Résumé : Ville et campagne — le futur simple et l''expansion du GN

- **Futur simple** = action à venir ; mêmes terminaisons pour tous les verbes : **-rai, -ras, -ra, -rons, -rez, -ront** (radical = infinitif ; les verbes en -re perdent le e : _prendre → je prendrai_ ; jamais « -rais » à la 1re personne du singulier).
- **Cinq radicaux irréguliers** : être → _ser-_ (je serai), avoir → _aur-_ (j''aurai), aller → _ir-_ (j''irai), faire → _fer-_ (je ferai), venir/devenir → _viendr-_ (je viendrai).
- **Verbes pronominaux au futur** : le pronom réfléchi reste devant le verbe (_je me promènerai, les boutiques s''ouvriront_).
- **GN minimal** = déterminant + nom (_le souk_) ; **GN étendu** = GN enrichi d''une expansion, l''**adjectif épithète** (_le souk animé_).
- **Épithète** = dans le GN, à côté du nom ; **attribut** = relié au nom par un **verbe d''état** (être, sembler, paraître, devenir, rester).
- **Accord de l''adjectif** : en genre et en nombre avec le nom (épithète) ou le sujet (attribut) — attention au piège de proximité (_les collines du nord-ouest restent vertes_).
- **et / est / es** : « et puis » / « était » / « étais » (avec tu) — le test de remplacement décide.
- **on / ont** : « on » = pronom sujet (remplaçable par « il ») ; « ont » = verbe avoir (remplaçable par « avaient »).', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', 'Nos amis les animaux — les déterminants et l''expansion du GN', 'Module 3 : le système des déterminants (articles définis, indéfinis et définis contractés, déterminants démonstratifs, possessifs, indéfinis, exclamatifs, numéraux ; « des » qui devient « de » à la forme négative), l''expansion du groupe nominal (adjectif épithète, complément du nom, proposition relative — repérage et substitution), le complément circonstanciel de cause et les homophones sa/son/ses, leur/leurs — au fil du monde animal.', '# ⚔️ Nos amis les animaux — les déterminants et l''expansion du GN

> 💡 « Un nom ne voyage jamais seul : son déterminant marche devant lui, et ses expansions forment son escorte. »

## 🏰 Le déterminant, le garde du nom

Tu sais déjà construire un **groupe nominal (GN)** : _le chat_, _une vache_. Le petit mot placé **devant le nom** s''appelle le **déterminant**. Il apporte des précisions sur le **genre** (masculin / féminin) et le **nombre** (singulier / pluriel) du nom : _un chameau_, _une gazelle_, _des moutons_.

Un **GN minimal** = déterminant + nom : _le chien_. On pourra ensuite l''**étendre** grâce aux expansions (plus bas dans ce chapitre).

## ⚡ Les articles : définis, indéfinis… et contractés

| Article              | Formes                                                           | Exemple                                        |
| -------------------- | ---------------------------------------------------------------- | ---------------------------------------------- |
| **Défini**           | le, la, l'', les                                                  | _le mouton, l''âne, les brebis_                 |
| **Indéfini**         | un, une, des                                                     | _un fennec, une cigogne, des chatons_          |
| **Défini contracté** | au (= à + le), aux (= à + les), du (= de + le), des (= de + les) | _Sami va **au** zoo ; le cri **des** mouettes_ |

> 🗡️ **L''astuce du singulier** pour reconnaître « des » : mets le nom au singulier. _Les chèvres descendent **des** montagnes → elle descend **de la** montagne_ : article défini contracté (de + les). _Il aperçoit **des** traces → il aperçoit **une** trace_ : article indéfini.

> ⚠️ « à le » et « de les » n''existent pas : on écrit toujours **au**, **aux**, **du**, **des**. _Je donne du foin **aux** ânes_ (jamais « à les ânes »). Devant une voyelle, pas de contraction : _à l''âne_, _de l''enclos_ (jamais « du enclos »).

**Règle clé de la forme négative** : l''article **des** devient **de** (ou **d''** devant une voyelle). _Ali a **des** tortues. → Ali n''a pas **de** tortues._ Et en sens inverse : si tu remets la phrase à la forme affirmative, « pas de tortues » redevient « **des** tortues ».

## 🔮 Les autres déterminants

| Type             | Formes                                                                        | Exemple                           |
| ---------------- | ----------------------------------------------------------------------------- | --------------------------------- |
| **Démonstratif** | ce, cet, cette, ces                                                           | _ce chameau, ces chevaux_         |
| **Possessif**    | mon, ton, son, ma, ta, sa, mes, tes, ses, notre, votre, leur, nos, vos, leurs | _ses chatons, leurs moutons_      |
| **Indéfini**     | chaque, quelques, plusieurs, tout…                                            | _chaque matin, quelques flamants_ |
| **Exclamatif**   | quel, quelle, quels, quelles (+ !)                                            | _Quels beaux chevaux !_           |
| **Numéral**      | deux, trois, dix…                                                             | _deux chèvres_                    |

Le déterminant **exclamatif** s''accorde avec le nom : _**Quel** paon ! **Quelle** crinière ! **Quelles** étranges créatures !_

> ⚠️ **cet** s''emploie devant un nom **masculin** commençant par une voyelle ou un h muet : _cet oiseau, cet âne_. Au féminin, on garde **cette**, même devant une voyelle : _cette autruche_ (jamais « cet autruche »).

## 🛡️ Orthographe : sa / son / ses et leur / leurs

- **sa, son** + nom **singulier** ; **ses** + nom **pluriel** : _la chatte lèche **ses** chatons_ (plusieurs chatons).
- **leur** + nom **singulier** ; **leurs** + nom **pluriel** : _les bergers rassemblent **leurs** moutons_. Mais si les possesseurs partagent une seule chose, on garde le singulier : _les abeilles défendent **leur** reine_ (une seule reine).
- Devant un **verbe**, **leur** est un **pronom personnel invariable** (= « à eux ») : _le dresseur **leur** donne des récompenses_ — jamais de -s au pronom.
- Après **chaque** (un seul possesseur à la fois), on emploie **sa / son / ses** : _chaque gazelle protège **ses** petits_ (et non « leurs »).
- Devant un nom **féminin** commençant par une voyelle, **sa** devient **son** : _la jument protège **son** épaule blessée_, _la cigogne répare **son** aile_ (et non « sa aile »).

## 🌿 L''expansion du GN : trois façons d''enrichir le nom

Un **GN étendu** = GN minimal + une ou plusieurs **expansions** :

| Expansion                | Construction                    | Exemple                           |
| ------------------------ | ------------------------------- | --------------------------------- |
| **Adjectif épithète**    | adjectif placé à côté du nom    | _un chaton **joueur**_            |
| **Complément du nom**    | préposition (de, à, en…) + nom  | _la gazelle **du désert**_        |
| **Proposition relative** | qui / que / où + verbe conjugué | _le chien **qui garde la ferme**_ |

Le mot qui introduit la relative se choisit selon ce qu''il remplace :

- **qui** remplace le **sujet** : _le chien **qui** aboie_ (= le chien aboie) — jamais « le chien que aboie ».
- **que** remplace le **complément d''objet direct** : _le fennec **que** nous avons observé_ (= nous avons observé le fennec).
- **où** remplace un **lieu** : _l''oasis **où** vivent les dromadaires_.

On peut **remplacer une expansion par une autre** sans changer le sens : _un chien **qui obéit** → un chien **obéissant**_ ; _la tortue **du désert** → la tortue **qui vit dans le désert**_.

> 🗡️ Un GN peut cumuler plusieurs expansions : _un **petit** fennec **du Sahara** **qui creuse son terrier**_ = **trois** expansions (épithète + complément du nom + relative). Attention : ce qui se trouve **à l''intérieur** de la relative (ici « son terrier ») ne compte pas comme une expansion à part.

## 🧭 Le complément circonstanciel de cause

Le **complément circonstanciel (CC) de cause** donne la **raison** de l''action : il répond à la question « **pourquoi ?** ».

- **parce que** + phrase conjuguée : _le chien de garde aboie **parce qu''un inconnu approche**_.
- **à cause de** + GN (cause plutôt négative) : _la cigogne quitte le nord **à cause du froid**_.
- **grâce à** + GN (cause positive) : _le troupeau survit **grâce au puits**_.

Pour **relier une phrase à son complément de cause**, mets la conséquence d''abord, la cause ensuite : _La cigogne part. Le froid arrive. → La cigogne part **parce que** le froid arrive._ (Ne renverse pas l''ordre : ce n''est pas le départ de la cigogne qui cause le froid !)

> ⚠️ Ne confonds pas la cause avec les autres circonstances : _à la tombée de la nuit_ (temps), _vers la bergerie_ (lieu), _à pas lents_ (manière).

## 🧪 Réinvestissement : futur, passé composé, impératif

- **Futur simple** : tous les verbes prennent les mêmes terminaisons — -rai, -ras, -ra, -rons, -rez, -ront : _demain, nous **nourrirons** les agneaux_.
- **Passé composé avec être** : le participe passé **s''accorde avec le sujet** : _les hirondelles sont **revenues** au printemps_. Les **verbes pronominaux** (se laver, s''installer…) se conjuguent aussi avec **être** : _les lionceaux **se sont réveillés**_, _les lionnes **se sont approchées**_.
- **Impératif** : le sujet n''est **pas exprimé** et le verbe n''a que **trois personnes**. À la 2ᵉ personne du singulier, les verbes en **-er** ne prennent **pas de -s** : _**Donne** à boire au chaton !_ À la forme négative, la négation encadre le verbe et « des » devient « de » : _**Ne donne pas de** graines aux poussins._

> 🏆 Porte du module 3 franchie, dresseur de GN ! Tu commandes tout le cortège du nom, des articles aux relatives, et tu sais expliquer la cause. Prochaine étape : les secrets de la nature et les grandes transformations de temps.', '# 📜 Résumé : Nos amis les animaux — les déterminants et l''expansion du GN

- **Le déterminant** se place devant le nom et précise son **genre** et son **nombre** ; déterminant + nom = **GN minimal** (_le chien_).
- **Articles** : définis (le, la, l'', les), indéfinis (un, une, des), **définis contractés** (au = à + le, aux = à + les, du = de + le, des = de + les — jamais « à le », « de les ») ; **test du singulier** pour distinguer les deux « des » ; à la forme **négative**, « des » devient « **de** » (_pas de tortues_).
- **Autres déterminants** : démonstratifs (ce, **cet** + masc. à voyelle, cette, ces), possessifs, indéfinis (chaque, quelques, plusieurs…), exclamatifs (quel, quelle, quels, quelles + !), numéraux (deux, trois…).
- **sa/son/ses, leur/leurs** : singulier ou pluriel selon le nom ; une seule chose partagée → _leur reine_ ; **leur** devant un verbe = **pronom invariable** (jamais de -s) ; après **chaque** → sa/son/ses ; devant un nom féminin à voyelle, **sa → son** (_son aile_).
- **Expansions du GN** : **adjectif épithète** (_chaton joueur_), **complément du nom** (préposition + nom : _gazelle du désert_), **proposition relative** (**qui** = sujet, **que** = COD, **où** = lieu) ; une expansion peut en **remplacer** une autre (_qui obéit ↔ obéissant_).
- **CC de cause** = répond à « **pourquoi ?** » : **parce que** + phrase, **à cause de** (négatif) / **grâce à** (positif) + GN ; ne pas confondre avec temps, lieu, manière.
- **Réinvestissement** : futur (-rai, -ras, -ra, -rons, -rez, -ront) ; passé composé avec **être** → accord avec le sujet (verbes pronominaux inclus : _elles se sont installées_) ; impératif : 3 personnes, pas de sujet, pas de -s aux verbes en -er (_Donne !_).', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', 'Les secrets de la nature — transformations de temps et accord du participe passé', 'Module 4 : lire un article de journal et une fiche de lecture ; transformer les temps d''un même texte (présent, passé composé, futur, impératif) ; employer les compléments circonstanciels et les substituts ; distinguer la / l''a / l''as ; accorder le participe passé avec avoir (COD placé avant) ; graphies du g dur et du g doux ; champs lexicaux de la mer, de la campagne et de la ville', '# ⚔️ Les secrets de la nature — transformations de temps et accord du participe passé

> 💡 « La nature ne livre ses secrets qu''à ceux qui savent lire les faits… et manier les temps. »

Tu sais déjà conjuguer le présent, le passé composé, le futur simple et l''impératif. Dans cette quête, tu apprends à **transformer un texte entier** d''un temps à l''autre, et tu débloques une arme nouvelle : l''**accord du participe passé avec avoir**.

## 📰 L''article de journal et la fiche de lecture

Un **article de journal** rapporte des **faits réels et récents**. Il répond aux questions : _qui ? quoi ? où ? quand ? pourquoi ?_ Il se compose de :

- un **titre** court qui accroche le lecteur ;
- un **chapeau** : le petit texte placé **sous le titre**, qui **résume l''essentiel** de l''information ;
- le **corps de l''article** : les faits racontés en détail, avec la **date** et le **lieu**.

Une **fiche de lecture**, elle, présente un **livre** : le **titre**, l''**auteur**, le **genre**, les **personnages**, un **court résumé** et l''**avis du lecteur**.

> 🗡️ Pour reconnaître un article de journal, cherche le trio **titre + chapeau + faits réels datés**. Si tu vois un **auteur de livre** et un **avis du lecteur**, c''est une fiche de lecture.

## ⚡ Transformer les temps d''un même texte

La grande compétence du module : réécrire **le même texte** au temps demandé, sans changer le sens.

| Temps         | Exemple : _observer_           | Rappel                                                                 |
| ------------- | ------------------------------ | ---------------------------------------------------------------------- |
| Présent       | _Le pêcheur observe la mer._   | action en train de se réaliser                                         |
| Passé composé | _Le pêcheur a observé la mer._ | auxiliaire **être** ou **avoir** au présent + participe passé          |
| Futur simple  | _Le pêcheur observera la mer._ | mêmes terminaisons pour tous : **-rai, -ras, -ra, -rons, -rez, -ront** |
| Impératif     | _Observe la mer._              | ordre ou conseil ; **pas de sujet exprimé** ; trois personnes          |

Points de vigilance pour transformer sans faute :

- **Passé composé avec être** : le participe passé **s''accorde avec le sujet**. Les **verbes de mouvement** (_aller, venir, arriver, partir, entrer, sortir, monter, descendre, tomber, rester_) et les **verbes pronominaux** se conjuguent avec **être** : _La brume **s''est dissipée**. Les barques **sont sorties** du port._
- **Futurs irréguliers à connaître** : être → _serai_, avoir → _aurai_, aller → _irai_, faire → _ferai_, voir → _verrai_.
- **Impératif** : trois personnes seulement (_range, rangeons, rangez_). Les verbes en **-er** ne prennent **pas de -s** à la 2ᵉ personne du singulier : _Range tes filets !_
- Quand un texte a **plusieurs verbes**, transforme-les **tous**, et garde pour chacun l''accord avec **son** sujet : _les vagues grossi**ront**, le vent forci**ra**_.

> ⚠️ Trois pièges classiques : écrire « Range**s** tes filets » avec un -s ; inventer un futur régulier (« je _voirai_ » au lieu de « je **verrai** ») ; confondre le futur simple (_il observera_) avec « il **va observer** » (futur proche), qui n''est **pas** le temps demandé.

## 🏰 Les compléments circonstanciels

Le **complément circonstanciel (CC)** précise les **circonstances** de l''action : le **temps** (_avant l''aube_), le **lieu** (_sur la plage_), la **manière** (_avec soin_), la **cause** (_par prudence, à cause du vent_).

- On peut souvent le **déplacer** ou le **supprimer** : _Les pêcheurs réparent leurs filets **sur la plage**. → **Sur la plage**, les pêcheurs réparent leurs filets._
- Pour compléter une phrase, choisis le CC qui répond à la bonne question : _quand ?_ → temps ; _où ?_ → lieu ; _comment ?_ → manière ; _pourquoi ?_ → cause.

> ⚠️ Ne confonds pas le CC avec le **COD** : dans _« Les campeurs ont quitté **la clairière** avant l''aube »_, « la clairière » répond à « quitté **quoi ?** » — c''est le COD. Dans _« Les campeurs ont dormi **dans la clairière** »_, « dans la clairière » répond à « **où ?** », il est déplaçable — c''est un CC de lieu.

## 🔮 Pronoms personnels sujets et substituts

Pour éviter les répétitions, un texte remplace un nom par des **substituts** :

- un **pronom personnel sujet** (_il, elle, ils, elles_), qui garde le **genre** et le **nombre** du nom : _**Les goélands** survolent la baie. → **Ils** survolent la baie._
- un **groupe nominal de reprise** : _**La baleine bleue** longe la côte. **Le géant des mers** plonge ensuite._

Tu dois savoir faire le chemin **dans les deux sens** : remplacer un GN sujet par un pronom, et retrouver le GN que remplace un pronom ou une reprise (même genre, même nombre !).

## 🛡️ Les homophones la / l''a / l''as et l''accord du participe passé avec avoir

| Graphie  | Nature                                                          | Test                               | Exemple                       |
| -------- | --------------------------------------------------------------- | ---------------------------------- | ----------------------------- |
| **la**   | déterminant devant un nom, ou pronom devant un verbe au présent | ne se remplace pas par « l''avait » | _**la** mer ; je **la** vois_ |
| **l''a**  | pronom **l''** + verbe **avoir** (il / elle) + participe passé   | remplaçable par « l''avait »        | _le vent **l''a** poussée_     |
| **l''as** | pronom **l''** + verbe **avoir** (tu) + participe passé          | remplaçable par « l''avais »        | _tu **l''as** vue_             |

(Et **là**, avec accent, indique un **lieu** : _reste **là**_.)

La règle nouvelle du module : avec l''auxiliaire **avoir**, le participe passé **ne s''accorde jamais avec le sujet**. Il s''accorde avec le **COD** seulement si celui-ci est placé **avant** le verbe :

- COD après le verbe → participe **invariable** : _Elle a récité **sa leçon**. Les villageois ont quitté **leurs maisons**._
- COD avant le verbe → **accord** avec le COD : _**Sa leçon**, elle **l''**a récité**e**. — **Ces photos**, il **les** a pris**es**._

> ⚠️ Le piège courant : accorder avec le sujet (« elle a récité**e** ») ou oublier l''accord quand le COD est devant (« ses affaires, elle les a rangé »). Méthode : cherche le COD, regarde s''il est **avant** le verbe, accorde avec **lui**.

## 🧪 Graphies d''un même son : g dur, g doux

| Devant… | La lettre **g** se prononce | Exemples                      |
| ------- | --------------------------- | ----------------------------- |
| a, o, u | **[g]** (g dur)             | _navi**ga**tion, **go**éland_ |
| e, i, y | **[ʒ]** (g doux)            | _ran**ge**, **gi**rafe_       |

Pour garder le bon son, on ajoute une lettre :

- **gu** devant **e, i** pour garder [g] : _il navi**gu**e, une lon**gu**e promenade_.
- **ge** devant **a, o** pour garder [ʒ] : _un plon**ge**on, nous na**ge**ons, proté**ge**ons la forêt_.
- Devant **a, o, u**, le g se prononce déjà [g] **tout seul** : on écrit _naviguer_ mais _un navi**g**ateur, la navi**g**ation_ (pas de « u » inutile).

> ⚠️ N''écris jamais « nous na**g**ons » : sans le **e**, le g se prononcerait [g].

## 🗺️ Champs lexicaux : la mer, la campagne, la ville

Un **champ lexical** rassemble les mots qui se rapportent à un **même thème**.

| La mer                             | La campagne                                     | La ville                                          |
| ---------------------------------- | ----------------------------------------------- | ------------------------------------------------- |
| vague, marée, falaise, port, filet | champ, moisson, ferme, récolte, sillon, sentier | avenue, trottoir, immeuble, quartier, circulation |

> 🏆 Porte du module 4 franchie ! Tu transformes les temps d''un texte entier, tu accordes le participe passé avec avoir et tu lis un article comme un vrai journaliste. Prochaine étape : les histoires réelles et imaginaires du module 5.', '# 📜 Résumé : Les secrets de la nature — transformations de temps et accord du participe passé

- **Article de journal** : des faits réels et récents, présentés par un **titre**, un **chapeau** (résumé sous le titre) et le **corps** (faits, date, lieu) ; la **fiche de lecture** présente un livre (titre, auteur, genre, résumé, avis du lecteur).
- **Transformer les temps** d''un même texte : présent (action en cours), passé composé (être/avoir au présent + participe passé), futur simple (**-rai, -ras, -ra, -rons, -rez, -ront** pour tous les verbes), impératif (trois personnes, pas de sujet).
- **Vigilance en transformation** : être + accord du participe avec le sujet (verbes de mouvement et pronominaux : _elles sont sorties, elle s''est dissipée_) ; futurs irréguliers (_serai, aurai, irai, ferai, verrai_) ; pas de -s à l''impératif des verbes en -er (_range !_) ; ne pas confondre futur simple et futur proche (_va observer_).
- **Complément circonstanciel** : précise le temps (quand ?), le lieu (où ?), la manière (comment ?) ou la cause (pourquoi ?) ; déplaçable et supprimable — à ne pas confondre avec le COD (« quitté quoi ? »).
- **Pronoms sujets et substituts** : un pronom (_il, elle, ils, elles_) ou un GN de reprise remplace un nom en gardant son **genre** et son **nombre**, dans les deux sens (GN → pronom, pronom → GN).
- **la / l''a / l''as / là** : _la_ = déterminant ou pronom (pas remplaçable par « l''avait ») ; _l''a_ = l'' + avoir (il/elle, test « l''avait ») ; _l''as_ = l'' + avoir (tu, test « l''avais ») ; _là_ = lieu.
- **Participe passé avec avoir** : jamais d''accord avec le sujet ; accord avec le **COD** seulement s''il est placé **avant** le verbe (_sa leçon, elle l''a récité**e**_ ; mais _elle a récité sa leçon_).
- **g dur / g doux** : g = [g] devant a, o, u et [ʒ] devant e, i, y ; on ajoute **gu** devant e, i pour garder [g] (_naviguer_) et **ge** devant a, o pour garder [ʒ] (_plongeon, nageons_) ; pas de « u » inutile devant a, o (_navigation, navigateur_).
- **Champs lexicaux** : mots d''un même thème — mer (vague, marée, falaise), campagne (moisson, ferme, sillon), ville (avenue, trottoir, immeuble).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', 'Histoires réelles, histoires imaginaires — le conte et le vocabulaire', 'Module 5 : distinguer le récit réel du récit imaginaire et découvrir le conte merveilleux (personnages types, formule d''ouverture, ordonner les parties d''un récit, imaginer une fin) ; les substituts et la pronominalisation (pronoms personnels sujets et compléments : le, la, les, lui, leur) ; les homophones la / l''a / l''as et l''accord du participe passé avec avoir (COD placé avant) ; le vocabulaire : synonymes, mots contraires, familles de mots et polysémie ; réinvestissement du futur simple et du passé composé.', '# ⚔️ Histoires réelles, histoires imaginaires — au royaume du conte

> 💡 « Le monde réel se raconte ; le monde imaginaire s''invente. Sache reconnaître l''un et fabriquer l''autre : c''est le pouvoir du conteur. »

Tu sais déjà raconter au **passé composé** et annoncer l''avenir au **futur simple**. Ici, tu vas apprendre à distinguer deux sortes d''histoires, à bâtir un vrai conte merveilleux, à **reprendre** un nom sans le répéter grâce aux pronoms, et à enrichir ton vocabulaire. En avant, apprenti conteur.

## 🏰 Récit réel ou récit imaginaire ?

Un **récit réel** raconte des faits qui se sont vraiment passés : une sortie scolaire, un voyage, un match. On y trouve des **dates**, des **lieux véritables**, des faits **vérifiables**.

Un **récit imaginaire** raconte des faits inventés : personnages surnaturels, objets magiques, animaux qui parlent. Rien n''y est vérifiable ; tout sort de l''imagination.

| Récit réel                       | Récit imaginaire                      |
| -------------------------------- | ------------------------------------- |
| faits vécus, vérifiables         | faits inventés                        |
| dates et lieux véritables        | pays et temps indéfinis               |
| _Le 3 mars, ma classe a visité…_ | _Il était une fois, dans un royaume…_ |

## 🔮 Le conte merveilleux

Le **conte merveilleux** est un récit imaginaire où le **surnaturel** est normal : la magie agit sans étonner personne.

- Il commence presque toujours par la formule **« Il était une fois »**.
- On y rencontre des **personnages types** : un **roi**, une **reine**, un **prince**, une **princesse**, une **fée** bienfaisante, une **sorcière** ou un **ogre** malfaisants.
- Des **objets magiques** interviennent : baguette, flûte enchantée, bague qui exauce les vœux.
- L''histoire se déroule dans un **ordre logique** : on présente d''abord le héros et son problème, puis les épreuves, enfin le dénouement — souvent une fin **heureuse** où le héros triomphe.

> 🗡️ **Ordonner les parties d''un conte** : le passage qui présente le héros (« Il était une fois… ») vient toujours **en premier** ; la victoire finale vient **en dernier**.

> 🗡️ **Imaginer une fin** : une bonne fin **résout** le problème posé au début et **utilise** l''élément magique introduit dans l''histoire.

## 🛡️ Les substituts : reprendre un nom sans le répéter

Pour éviter de répéter un nom, on le **reprend** par un **substitut**. Il en existe deux sortes :

- un **substitut lexical** : un autre mot de sens proche. _Le **roi** régnait… Ce **monarque** était aimé._ (monarque reprend roi)
- un **substitut pronominal** : un **pronom**. _Le **renard** choisit un poulet. **Il** l''emporte._ (il reprend le renard)

## 🗡️ La pronominalisation : les pronoms personnels

Un **pronom personnel** remplace un groupe nominal pour alléger la phrase.

| Fonction remplacée         | Pronoms                         | Exemple                                 |
| -------------------------- | ------------------------------- | --------------------------------------- |
| **Sujet**                  | il, elle, ils, elles            | _La princesse_ dort → **Elle** dort.    |
| **COD** (sans préposition) | le, la, les (l'' + voyelle)      | Il mange _la pomme_ → Il **la** mange.  |
| **COI** (nom après « à »)  | lui (un seul), leur (plusieurs) | Il parle _à la fée_ → Il **lui** parle. |

- Le **COD** répond à _qui ? / quoi ?_ après le verbe : il se remplace par **le, la, les**. Devant une voyelle, _le_ et _la_ deviennent **l''** : Il **l''**aperçoit.
- Le **COI** est introduit par **« à »** : il se remplace par **lui** (un seul) ou **leur** (plusieurs). _Le roi pardonne **aux soldats** → Le roi **leur** pardonne._

> ⚠️ Ne confonds pas le pronom **leur** (COI, invariable : _il **leur** parle_) avec le déterminant **leur/leurs** (devant un nom : _**leurs** épées_).

**Deux pronoms ensemble.** Quand on remplace un COD **et** un COI, on place le COD **avant** le COI : **le/la/les** puis **lui/leur**.
_Il montre le grimoire au prince → Il **le lui** montre._ · _Il rend leurs pouvoirs aux fées → Il **les leur** rend._

## ⚡ Homophones **la / l''a / l''as** et l''accord du participe passé

Ces mots se prononcent pareil mais s''écrivent différemment :

| Graphie  | Nature                                           | Test                      | Exemple                                   |
| -------- | ------------------------------------------------ | ------------------------- | ----------------------------------------- |
| **la**   | article (+ nom) ou pronom COD (+ verbe)          | on peut dire _le_         | Il récite **la** leçon / il **la** récite |
| **l''a**  | pronom l'' + auxiliaire **avoir** (3ᵉ pers.)      | remplaçable par _l''avait_ | Elle **l''a** récitée.                     |
| **l''as** | pronom l'' + auxiliaire **avoir** (2ᵉ pers. _tu_) | remplaçable par _l''avais_ | Tu **l''as** récitée.                      |

Après **l''a / l''as**, il y a toujours un **participe passé**.

**Accord du participe passé avec _avoir_.** Avec l''auxiliaire **avoir**, le participe passé **ne s''accorde pas avec le sujet**. Il s''accorde avec le **COD seulement si le COD est placé AVANT** le verbe.

- COD placé **après** → pas d''accord : _Elle a récité **sa leçon**._
- COD placé **avant** (pronom ou « que ») → accord : _Elle **l''**a récit**ée**._ (l'' = la leçon, féminin) · _La leçon **qu''**elle a récit**ée**._

> ⚠️ **Le piège :** avec _avoir_, on n''accorde **jamais** avec le sujet. _Les fleurs qu''il a cueilli**es**_ (accord avec « que » = les fleurs), mais _Il a cueilli des fleurs_ (COD après → aucun accord).

## 🧮 Enrichir son vocabulaire

- **Synonymes** : des mots de **sens proche**. _content → heureux, joyeux ; demeure → habitation._
- **Contraires (antonymes)** : des mots de **sens opposé**. _grand ≠ petit ; apparaître ≠ disparaître ; rapide ≠ lent._
- **Familles de mots** : des mots formés sur le **même radical** et un **sens commun**. _dent → dentiste, dentaire, dentier ; terre → terrain, terrestre, atterrir, souterrain._
- **Polysémie** : un même mot a **plusieurs sens** selon le contexte.

| Mot       | Sens 1                 | Sens 2               | Sens 3                     |
| --------- | ---------------------- | -------------------- | -------------------------- |
| **terre** | le sol qu''on cultive   | la planète           | le monde entier            |
| **pièce** | une salle de la maison | une pièce de monnaie | une pièce de théâtre       |
| **vague** | une vague de la mer    | imprécis, flou       | une série (vague de froid) |

> ⚠️ **Piège des familles :** _terrible_ ne vient **pas** de « terre » (il vient de « terreur ») ; la même **forme** ne suffit pas, il faut un **sens commun**.

> 🏆 Tu sais maintenant distinguer le réel de l''imaginaire, bâtir un conte, reprendre un nom par un pronom, écrire _l''a / la_ sans faute et jouer avec les mots. Le royaume des histoires t''appartient — franchis le boss du chapitre !', '# 📜 Résumé : Histoires réelles, histoires imaginaires — le conte et le vocabulaire

- **Réel vs imaginaire** : le récit **réel** raconte des faits vécus et vérifiables (dates, lieux vrais) ; le récit **imaginaire** invente tout (magie, surnaturel).
- **Le conte merveilleux** : commence par **« Il était une fois »** ; personnages types (roi, reine, prince, princesse, fée, sorcière, ogre) et objets magiques ; parties dans l''ordre (présentation → épreuves → fin heureuse). Une bonne fin résout le problème et utilise l''élément magique.
- **Les substituts** : reprendre un nom sans le répéter, soit par un **substitut lexical** (synonyme : roi → monarque), soit par un **pronom** (le renard → il).
- **Pronoms personnels** : **sujet** (il, elle, ils, elles) ; **COD** = le, la, les, l'' (sans préposition) ; **COI** = lui (un), leur (plusieurs) (nom après « à »). Deux pronoms : COD **avant** COI (_il le lui montre_, _il les leur rend_).
- **la / l''a / l''as** : **la** = article ou pronom COD (test : « le ») ; **l''a / l''as** = pronom + auxiliaire _avoir_, suivis d''un participe passé (test : « l''avait / l''avais »).
- **Accord du PP avec _avoir_** : jamais avec le sujet ; avec le **COD seulement s''il est placé avant** (_elle l''a récitée_, _la leçon qu''elle a récitée_) ; COD après → pas d''accord (_elle a récité sa leçon_).
- **Vocabulaire** : **synonymes** (sens proche), **contraires** (sens opposé), **familles de mots** (même radical + sens commun ; attention : _terrible_ n''est pas de la famille de _terre_), **polysémie** (un mot, plusieurs sens : terre, pièce, vague).', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a334697f-f495-5448-8402-8cebc3cefc15', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('976e6fe4-5b49-586f-883a-d9e9f0c081a4', 'a334697f-f495-5448-8402-8cebc3cefc15', 'Comment forme-t-on le passé composé ?', '[{"id":"a","text":"Avec l''auxiliaire être ou avoir au futur + le participe passé"},{"id":"b","text":"Avec l''auxiliaire être ou avoir au présent + le participe passé"},{"id":"c","text":"Avec le verbe seul et la terminaison -ait"},{"id":"d","text":"Avec l''auxiliaire aller au présent + l''infinitif"}]'::jsonb, 'b', 'Le passé composé est un temps composé : auxiliaire être ou avoir conjugué au présent, suivi du participe passé du verbe (j''ai fini, elle est partie).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db41d9df-95da-557d-82ab-e08a22c0020f', 'a334697f-f495-5448-8402-8cebc3cefc15', 'Quelle est la valeur du présent dans « Le soleil se lève à l''est. » ?', '[{"id":"a","text":"Une action en train de se réaliser au moment où l''on parle"},{"id":"b","text":"Le présent de narration"},{"id":"c","text":"Une action future"},{"id":"d","text":"Une vérité générale"}]'::jsonb, 'd', 'Ce fait est toujours vrai, à n''importe quel moment : c''est la valeur de vérité générale du présent de l''indicatif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8a454d8-818a-553e-b22a-c483992cdae0', 'a334697f-f495-5448-8402-8cebc3cefc15', 'Quel est le type de la phrase : « Où habites-tu ? »', '[{"id":"a","text":"Interrogative"},{"id":"b","text":"Déclarative"},{"id":"c","text":"Exclamative"},{"id":"d","text":"Négative"}]'::jsonb, 'a', 'La phrase pose une question et se termine par un point d''interrogation : elle est de type interrogatif. « Négative » n''est pas un type mais une forme de phrase.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40ff7c0c-2205-5dd6-94b2-8ad148ebc49f', 'a334697f-f495-5448-8402-8cebc3cefc15', 'Que faut-il écrire dans : « Leïla ___ réveillée à sept heures. » ?', '[{"id":"a","text":"c''est"},{"id":"b","text":"ces"},{"id":"c","text":"s''est"},{"id":"d","text":"ses"}]'::jsonb, 'c', '« S''est » est toujours suivi d''un participe passé : Leïla s''est réveillée (verbe pronominal « se réveiller » au passé composé). « C''est » se remplacerait par « cela est », ce qui est impossible ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9afb3059-f7f8-56b3-a869-54d33a4aaefc', 'a334697f-f495-5448-8402-8cebc3cefc15', 'Avec l''auxiliaire être, le participe passé s''accorde avec :', '[{"id":"a","text":"le complément du verbe"},{"id":"b","text":"le sujet"},{"id":"c","text":"l''auxiliaire"},{"id":"d","text":"rien : il reste invariable"}]'::jsonb, 'b', 'Avec être, le participe passé s''accorde en genre et en nombre avec le sujet : elle est partie, ils sont partis, elles sont parties.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '⭐ Exercice : réveille tes acquis', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c11a918-04aa-5cec-92fa-7c29c7f260cf', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'Complète au présent de l''indicatif : « Tu ___ (finir) ton exercice avant la récréation. »', '[{"id":"a","text":"finies"},{"id":"b","text":"finissez"},{"id":"c","text":"finis"},{"id":"d","text":"finit"}]'::jsonb, 'c', 'Finir est un verbe du 2e groupe : avec « tu », la terminaison est -is → tu finis. « Finit » correspond à il/elle, et « finissez » à vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01a9a294-1675-5159-8c32-af6c76e6827e', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'Quel est le type de la phrase : « Le match commence à trois heures. » ?', '[{"id":"a","text":"Déclarative"},{"id":"b","text":"Exclamative"},{"id":"c","text":"Interrogative"},{"id":"d","text":"Affirmative"}]'::jsonb, 'a', 'La phrase donne une information et se termine par un point : elle est déclarative. « Affirmative » désigne une forme de phrase, pas un type.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ba20833-b151-5b18-8a2e-a1475ae8cdba', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'Quelle est la forme négative correcte de : « Sami joue au football. » ?', '[{"id":"a","text":"Sami joue pas au football."},{"id":"b","text":"Sami ne joue pas au football."},{"id":"c","text":"Sami ne joue au football."},{"id":"d","text":"Sami non joue au football."}]'::jsonb, 'b', 'La négation encadre le verbe avec deux mots : ne… pas → « Sami ne joue pas au football. » Il ne faut oublier ni « ne » ni « pas ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3bc9abd0-5b42-5128-8f7b-abdbcd90cdb3', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'Complète : « ___ cartable est trop lourd pour moi. »', '[{"id":"a","text":"Ce"},{"id":"b","text":"Se"},{"id":"c","text":"C''est"},{"id":"d","text":"Ses"}]'::jsonb, 'a', 'Devant un nom masculin singulier que l''on montre, on écrit le déterminant démonstratif « ce » : ce cartable. « Se » accompagne toujours un verbe pronominal, jamais un nom.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a85ae49b-77b2-58f3-89bc-5828ca448807', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', 'Mets au passé composé : « Elle ___ (aller) au marché central. »', '[{"id":"a","text":"elle a allé"},{"id":"b","text":"elle a allée"},{"id":"c","text":"elle est allé"},{"id":"d","text":"elle est allée"}]'::jsonb, 'd', 'Aller est un verbe de mouvement : il se conjugue avec être. Avec être, le participe passé s''accorde avec le sujet féminin singulier → elle est allée.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7dc6e55-e505-5c77-b4e1-c3bc3941fea6', 'd6f9c064-5ec3-51db-950d-b1e89ee09cd5', '« Hier, au souk : soudain, un chat bondit sur l''étal et renverse les paniers. » Quelle est la valeur du verbe au présent « bondit » ?', '[{"id":"a","text":"Une vérité générale"},{"id":"b","text":"Une action en train de se réaliser au moment où l''on parle"},{"id":"c","text":"Une action future"},{"id":"d","text":"Le présent de narration"}]'::jsonb, 'd', 'La scène s''est passée hier, mais elle est racontée au présent pour rendre le récit plus vivant : c''est le présent de narration.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c975ca9-f727-5e49-8684-c8abc03ae488', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : le gardien des prérequis', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26cb8fdb-4cc1-5585-9067-80cf0fbf852e', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Dans quelle phrase le présent exprime-t-il une vérité générale ?', '[{"id":"a","text":"L''eau de mer est salée."},{"id":"b","text":"Regarde, il pleut sur Tunis."},{"id":"c","text":"Soudain, le gardien s''élance et arrête le ballon."},{"id":"d","text":"Nous jouons aux cartes en ce moment."}]'::jsonb, 'a', '« L''eau de mer est salée » est un fait toujours vrai : vérité générale ✓. Les phrases b et d décrivent une action en cours au moment où l''on parle, et la phrase c est un présent de narration dans un récit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('591d194f-33fe-5eb3-9357-88c217b4b8f7', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Complète au présent : « Les fruits ___ (mûrir) au soleil de juillet. »', '[{"id":"a","text":"mûrent"},{"id":"b","text":"mûrit"},{"id":"c","text":"mûrissent"},{"id":"d","text":"mûrient"}]'::jsonb, 'c', 'Mûrir est un verbe du 2e groupe : au pluriel, il prend l''élément -iss- → les fruits mûrissent ✓. Le piège courant : oublier le -iss- et écrire « mûrent », comme si le verbe était du 3e groupe.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ea63a15-04e4-5e29-80ae-70b2af0c70df', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Lis ce récit : « Ce matin-là, Yassine quitte la maison avant le lever du soleil. Il salue le boulanger qui allume son four, traverse les ruelles endormies de la médina et court vers le port. Son grand-père l''attend près de la barque bleue. “Te voilà enfin, petit pêcheur !” dit le vieil homme en souriant. » Qui raconte cette histoire ?', '[{"id":"a","text":"Yassine"},{"id":"b","text":"Le grand-père"},{"id":"c","text":"Un narrateur extérieur qui ne participe pas à l''histoire"},{"id":"d","text":"Le boulanger"}]'::jsonb, 'c', 'Le récit ne dit jamais « je » : les personnages (Yassine, le grand-père, le boulanger) sont désignés à la 3e personne. C''est donc un narrateur extérieur à l''histoire qui raconte ✓.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8721e697-8ba1-5389-b093-11302f1b3dbb', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Complète au passé composé : « Salma et sa cousine ___ (partir) au hammam samedi dernier. »', '[{"id":"a","text":"est partie"},{"id":"b","text":"ont parti"},{"id":"c","text":"sont partis"},{"id":"d","text":"sont parties"}]'::jsonb, 'd', 'Deux étapes : (1) « Salma et sa cousine » = elles, sujet féminin pluriel → auxiliaire au pluriel « sont » ; (2) partir se conjugue avec être, donc le participe passé s''accorde avec le sujet → parties ✓. Le piège courant : accorder au masculin (« partis ») ou oublier que le sujet est pluriel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb36d499-02d8-58d6-bc00-f423cea2e528', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Complète : « Mon oncle ___ occupé du jardin, puis il a taillé ___ propres oliviers. »', '[{"id":"a","text":"c''est / ces"},{"id":"b","text":"s''est / ses"},{"id":"c","text":"s''est / ces"},{"id":"d","text":"c''est / ses"}]'::jsonb, 'b', '« ___ occupé » est suivi d''un participe passé : c''est le verbe pronominal « s''occuper » au passé composé → s''est ✓. « ___ propres oliviers » exprime la possession (les siens) → déterminant possessif ses ✓. Le piège courant : écrire « c''est » alors que « cela est occupé du jardin » n''a aucun sens.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f4253b2-200a-5f3c-b112-b5dd8682beac', '1c975ca9-f727-5e49-8684-c8abc03ae488', 'Dans le récit de Yassine (« Son grand-père l''attend près de la barque bleue. “Te voilà enfin, petit pêcheur !” dit le vieil homme en souriant. »), quelle expression est un substitut de « son grand-père » ?', '[{"id":"a","text":"« le vieil homme »"},{"id":"b","text":"« petit pêcheur »"},{"id":"c","text":"« la barque bleue »"},{"id":"d","text":"« le boulanger »"}]'::jsonb, 'a', '« Le vieil homme » reprend « son grand-père » pour éviter la répétition : c''est un substitut ✓. Le piège courant : choisir « petit pêcheur », qui désigne Yassine (c''est le grand-père qui lui parle), pas le grand-père.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b9b3c7d0-6458-525a-bc67-5c5734f40255', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '⭐⭐ Révision (type examen) : consolider les acquis', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c77e2843-82c3-52f4-807b-6660a6bce8c1', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Dans quelle phrase le verbe est-il conjugué au présent de l''indicatif ?', '[{"id":"a","text":"Nous avons visité le musée du Bardo."},{"id":"b","text":"Nous visiterons le musée du Bardo."},{"id":"c","text":"Nous visitons le musée du Bardo."},{"id":"d","text":"Nous allons visiter le musée du Bardo."}]'::jsonb, 'c', '« Visitons » porte la terminaison du présent avec nous (-ons) : c''est le présent de l''indicatif. « Avons visité » est un passé composé et les phrases b et d expriment le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d8a35c6-8da7-51be-9c58-c5e789279669', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Choisis l''auxiliaire correct : « Les voyageurs ___ partis à l''aube. »', '[{"id":"a","text":"sont"},{"id":"b","text":"ont"},{"id":"c","text":"est"},{"id":"d","text":"a"}]'::jsonb, 'a', 'Partir est un verbe de mouvement : il se conjugue avec être. Le sujet « les voyageurs » est pluriel → sont partis. « Ont parti » est une faute classique d''auxiliaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac6fdf66-ba0e-5404-8c39-f75938575262', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Complète : « Regarde ___ nuages noirs à l''horizon ! »', '[{"id":"a","text":"s''est"},{"id":"b","text":"ses"},{"id":"c","text":"c''est"},{"id":"d","text":"ces"}]'::jsonb, 'd', 'On montre les nuages : il faut le déterminant démonstratif « ces » devant un nom pluriel. « Ses » exprimerait une possession, impossible pour des nuages.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43df3c5a-60c8-59c8-94c6-3e79c3ab2748', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Quelle est la transformation correcte de « Vous prenez le bus. » en phrase interrogative ?', '[{"id":"a","text":"Vous prenez le bus !"},{"id":"b","text":"Prenez-vous le bus ?"},{"id":"c","text":"Prenez le bus !"},{"id":"d","text":"Vous ne prenez pas le bus."}]'::jsonb, 'b', 'La phrase interrogative pose une question et se termine par « ? » : on inverse le sujet et le verbe → « Prenez-vous le bus ? » (on peut aussi dire « Est-ce que vous prenez le bus ? »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb56b93-e341-51ef-8324-3625d3a5cf9e', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Complète au passé composé : « Les joueuses ___ (s''entraîner) au stade toute la matinée. »', '[{"id":"a","text":"s''ont entraînées"},{"id":"b","text":"se sont entraîné"},{"id":"c","text":"se sont entraînées"},{"id":"d","text":"se sont entraînés"}]'::jsonb, 'c', 'Un verbe pronominal se conjugue avec être au passé composé, et le participe passé s''accorde avec le sujet « les joueuses » (féminin pluriel) → se sont entraînées. « S''ont » n''existe pas : jamais l''auxiliaire avoir avec un verbe pronominal.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('278e431b-ceee-5951-a06b-6f176d198140', 'b9b3c7d0-6458-525a-bc67-5c5734f40255', 'Quelle phrase est déclarative et de forme négative ?', '[{"id":"a","text":"Le vent ne souffle plus."},{"id":"b","text":"Le vent souffle très fort."},{"id":"c","text":"Est-ce que le vent souffle ?"},{"id":"d","text":"Comme le vent souffle fort !"}]'::jsonb, 'a', '« Le vent ne souffle plus. » donne une information (type déclaratif) et contient la négation « ne… plus » (forme négative). La phrase b est déclarative mais affirmative ; c est interrogative ; d est exclamative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : transformations sous contraintes', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78a64ac8-e5d7-57d0-b58d-5c21785063ca', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'Quelle phrase est à la fois de type interrogatif et de forme négative ?', '[{"id":"a","text":"Pourquoi ne viens-tu pas à l''entraînement ?"},{"id":"b","text":"Ne dis rien à ton adversaire !"},{"id":"c","text":"Tu ne viens pas à l''entraînement."},{"id":"d","text":"Viens-tu à l''entraînement ?"}]'::jsonb, 'a', 'La phrase a pose une question (« ? ») et contient la négation « ne… pas » : elle cumule le type interrogatif et la forme négative ✓. La phrase c est négative mais déclarative, la d est interrogative mais affirmative.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00ea00e7-81df-5713-9516-0e0f26478104', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'Un élève a écrit : « Je ranges ma chambre, je finis mes devoirs, j''appelle mon frère et nous jouons ensemble. » Quel verbe est mal conjugué ?', '[{"id":"a","text":"« finis »"},{"id":"b","text":"« ranges »"},{"id":"c","text":"« appelle »"},{"id":"d","text":"« jouons »"}]'::jsonb, 'b', 'Question « chasse à l''erreur » : la bonne réponse est le verbe fautif. Ranger est du 1er groupe : avec « je », la terminaison est -e → « je range », sans -s ✓. Le piège courant : croire que « je finis » est faux — finir est du 2e groupe et prend bien -is avec je.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3e7c98a-4807-5c39-9419-d9add58477dc', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'Transforme au passé composé ET à la forme négative : « Rim se promène sur la plage. »', '[{"id":"a","text":"Rim ne c''est pas promenée sur la plage."},{"id":"b","text":"Rim ne s''est pas promené sur la plage."},{"id":"c","text":"Rim n''a pas promené sur la plage."},{"id":"d","text":"Rim ne s''est pas promenée sur la plage."}]'::jsonb, 'd', 'Trois étapes : (1) verbe pronominal → auxiliaire être : « s''est » ; (2) accord du participe passé avec le sujet féminin « Rim » → « promenée » ; (3) négation « ne… pas » autour de l''auxiliaire ✓. Le piège courant : écrire « c''est » devant le participe passé — devant un participe passé, c''est toujours « s''est ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0933e54e-78f2-5741-865a-4d8b439369be', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', '« Hier, je marche tranquillement sur l''avenue quand un cycliste surgit devant moi. » Les verbes sont au présent alors que la scène s''est passée hier. Pourquoi ?', '[{"id":"a","text":"C''est un présent de vérité générale."},{"id":"b","text":"C''est une erreur : il fallait conjuguer au passé composé."},{"id":"c","text":"C''est le présent de narration, qui rend le récit plus vivant."},{"id":"d","text":"C''est une action en train de se réaliser au moment où l''on parle."}]'::jsonb, 'c', 'Le présent peut remplacer les temps du passé dans un récit : c''est le présent de narration, qui rend la scène plus vivante ✓. Ce n''est donc pas une faute. Le piège courant : confondre avec l''action en cours — « hier » prouve que la scène est passée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f24b257-3d4f-5b34-93d1-de677b137591', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'Complète : « ___ matin-là, Selim ___ levé en retard : ___ la faute de son réveil cassé ! »', '[{"id":"a","text":"Ce / c''est / s''est"},{"id":"b","text":"Se / s''est / c''est"},{"id":"c","text":"Ce / s''est / c''est"},{"id":"d","text":"Ce / s''est / s''est"}]'::jsonb, 'c', '« Ce matin-là » : déterminant démonstratif devant un nom masculin ✓. « Selim s''est levé » : suivi d''un participe passé → s''est ✓. « C''est la faute… » : remplaçable par « cela est la faute » → c''est ✓. Le piège courant : inverser s''est et c''est — le test « cela est » tranche à chaque fois.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f1df333-158d-5a52-8f36-86f5b6708f20', '0a2fd4b8-b7ee-584f-a451-2caaee2d9e46', 'Transforme en phrase exclamative : « Cette victoire est belle. »', '[{"id":"a","text":"Cette victoire est-elle belle ?"},{"id":"b","text":"Quelle belle victoire !"},{"id":"c","text":"Cette victoire n''est pas belle."},{"id":"d","text":"Est-ce que cette victoire est belle !"}]'::jsonb, 'b', 'La phrase exclamative exprime un sentiment (ici la joie) et se termine par « ! » ; elle commence souvent par « Quel/Quelle » → « Quelle belle victoire ! » ✓. Le piège courant : l''option d mélange la structure interrogative « Est-ce que » avec un point d''exclamation — cette construction est incorrecte.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc9b6452-a884-507f-8e8e-358fa9407b0f', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : révision globale (type examen)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5cf1bda-f8e2-5c54-b434-f3db37bdde2b', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Complète au présent de l''indicatif : « Vous ___ (prendre) le louage pour aller à Kairouan. »', '[{"id":"a","text":"prendez"},{"id":"b","text":"prennez"},{"id":"c","text":"prenez"},{"id":"d","text":"prener"}]'::jsonb, 'c', 'Prendre est un verbe du 3e groupe : avec « vous », la terminaison est -ez et le radical perd le -d → vous prenez. « Prendez » garde le -d de l''infinitif à tort ; « prennez » double le -n (réservé à ils/elles : prennent).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2451a178-c2c0-5bf6-8049-cefbe0b67ea3', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Quelle phrase est de type exclamatif ?', '[{"id":"a","text":"Comme ce match est passionnant !"},{"id":"b","text":"Est-ce que tu regardes le match ?"},{"id":"c","text":"Le match commence à seize heures."},{"id":"d","text":"Ce match ne finit pas avant vingt heures."}]'::jsonb, 'a', '« Comme ce match est passionnant ! » exprime un sentiment (l''enthousiasme) et se termine par « ! » : c''est une phrase exclamative. La b est interrogative, la c déclarative affirmative, la d déclarative négative.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c65e0c71-483d-550f-8e90-2ef05310be38', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Complète au passé composé : « Nadia a ___ (écrire) une longue lettre à sa tante. »', '[{"id":"a","text":"écris"},{"id":"b","text":"écrivé"},{"id":"c","text":"écrivu"},{"id":"d","text":"écrit"}]'::jsonb, 'd', 'Le participe passé d''écrire se termine par -it → Nadia a écrit. « Écrivé » applique à tort la terminaison -é du 1er groupe, et « écrivu » la terminaison -u : le participe correct est écrit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9eab841-bbe6-53b8-8b5b-4a270156a2b9', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Complète au passé composé : « Les randonneurs ___ (monter) au sommet de Zaghouan avant midi. »', '[{"id":"a","text":"ont monté"},{"id":"b","text":"sont monté"},{"id":"c","text":"sont montés"},{"id":"d","text":"sont montées"}]'::jsonb, 'c', 'Deux étapes : (1) monter est un verbe de mouvement → auxiliaire être ; (2) le participe s''accorde avec le sujet masculin pluriel « les randonneurs » → sont montés ✓. Le piège courant : choisir « ont monté » (mauvais auxiliaire) ou « sont monté » (accord oublié).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fcb1efe-d737-5014-b350-3119d4d324c3', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Complète : « Karim ___ dépêché ce matin, car ___ le jour de l''examen. »', '[{"id":"a","text":"c''est / s''est"},{"id":"b","text":"s''est / c''est"},{"id":"c","text":"s''est / s''est"},{"id":"d","text":"c''est / c''est"}]'::jsonb, 'b', '« ___ dépêché » est suivi d''un participe passé → verbe pronominal « se dépêcher » au passé composé : s''est ✓. « ___ le jour de l''examen » se remplace par « cela est le jour… » → c''est ✓. Le piège courant : inverser les deux — le test « cela est » ne marche que pour le second.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e2c0d83-aa60-5436-aeff-da8ba96b03ec', 'fc9b6452-a884-507f-8e8e-358fa9407b0f', 'Lis ce récit : « Dans le vieux port, un pêcheur répare son filet. L''homme travaille depuis l''aube. Bientôt, une barque colorée s''approche du quai. » Quel mot reprend « un pêcheur » pour éviter la répétition ?', '[{"id":"a","text":"« le filet »"},{"id":"b","text":"« la barque »"},{"id":"c","text":"« le quai »"},{"id":"d","text":"« l''homme »"}]'::jsonb, 'd', '« L''homme » désigne la même personne que « un pêcheur » : c''est un synonyme employé comme substitut, pour ne pas répéter le mot ✓. Le piège courant : choisir « la barque », qui est un nouvel élément du décor, pas une reprise du pêcheur.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('df3e191c-1bb2-51c1-8038-71aaf13f8268', 'd80ed1fd-7eda-51d4-b4a7-ad9b11f9dce5', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le maître des prérequis', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c70a43b8-7ba5-5f67-b0ca-98ba3cc20816', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'Une seule de ces phrases est correctement écrite. Laquelle ?', '[{"id":"a","text":"Elles sont arrivé en retard."},{"id":"b","text":"Ma sœur est resté à la maison."},{"id":"c","text":"Les enfants sont sortis dans la cour."},{"id":"d","text":"Mon frère est tombée de vélo."}]'::jsonb, 'c', 'Avec l''auxiliaire être, le participe s''accorde avec le sujet. « Les enfants sont sortis » : masculin pluriel, accord correct ✓. Les autres oublient ou ratent l''accord : arrivé → arrivées (fém. plur.), resté → restée (fém. sing.), tombée → tombé (masc. sing., « mon frère »).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cb9c356-6c42-5d63-9ad7-ee57dbae7e4f', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'Un élève écrit : « Le matin, je finit mon déjeuner, tu choisis tes habits, il prend le bus et nous partons ensemble. » Un verbe est mal conjugué. Lequel ?', '[{"id":"a","text":"« je finit »"},{"id":"b","text":"« tu choisis »"},{"id":"c","text":"« il prend »"},{"id":"d","text":"« nous partons »"}]'::jsonb, 'a', 'Question « chasse à l''erreur » : la bonne réponse est le verbe fautif. Finir est du 2e groupe : avec « je », la terminaison est -is → « je finis » (le -it est réservé à il/elle : il finit). Le piège courant : croire que « tu choisis » est faux — choisir est aussi du 2e groupe et prend bien -is avec tu.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bce98825-cd7f-520e-a32f-8185b2aace7a', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'Réécris au passé composé ET à la forme négative : « Sonia se réveille avant l''aube. »', '[{"id":"a","text":"Sonia n''a pas réveillé avant l''aube."},{"id":"b","text":"Sonia ne c''est pas réveillée avant l''aube."},{"id":"c","text":"Sonia ne s''est pas réveillée avant l''aube."},{"id":"d","text":"Sonia ne s''est pas réveillé avant l''aube."}]'::jsonb, 'c', 'Trois contraintes : (1) « se réveiller » est pronominal → auxiliaire être : « s''est » ; (2) accord du participe avec le sujet féminin « Sonia » → « réveillée » ; (3) négation « ne… pas » autour de l''auxiliaire ✓. Le piège courant : écrire « c''est » devant le participe passé — devant un participe passé, c''est toujours « s''est » ; l''option d, elle, oublie l''accord au féminin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f16e9c89-734b-5de6-8d08-551b1d62a1c7', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'On lit : « Les deux amies sont descendues du bus. » Pourquoi le participe passé s''écrit-il « descendues » ?', '[{"id":"a","text":"Parce que « descendre » se conjugue avec l''auxiliaire « avoir »."},{"id":"b","text":"Parce que l''auxiliaire est « être » et le participe s''accorde avec le sujet féminin pluriel « les deux amies »."},{"id":"c","text":"Parce que tous les participes passés prennent -es au pluriel."},{"id":"d","text":"Parce que le participe passé s''accorde toujours avec le complément du verbe."}]'::jsonb, 'b', '« Descendre » (verbe de mouvement) se conjugue avec être ; le participe s''accorde alors avec le sujet, ici féminin pluriel « les deux amies » → descendues ✓. Le piège courant : l''option a se trompe d''auxiliaire, et les options c et d inventent des règles fausses (le participe avec être suit le sujet, pas le complément).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37efb182-9d3c-51f0-8d56-4262b892cf0f', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'Complète : « ___ enfants adorent leur maîtresse : ___ elle qui leur a appris à lire, et chacun range ___ cahiers avec soin. »', '[{"id":"a","text":"Ces / s''est / ses"},{"id":"b","text":"Ses / c''est / ces"},{"id":"c","text":"Ces / c''est / ces"},{"id":"d","text":"Ces / c''est / ses"}]'::jsonb, 'd', 'Trois choix : « Ces enfants » = déterminant démonstratif pluriel (on les désigne) ✓ ; « c''est elle » = « cela est elle » ✓ ; « ses cahiers » = les siens, possession → déterminant possessif ✓. Le piège courant : écrire « ces cahiers » pour le dernier blanc, alors que la possession (« chacun range les siens ») impose « ses ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('441b13a8-85f6-5b39-b0b9-25e55057694b', 'df3e191c-1bb2-51c1-8038-71aaf13f8268', 'Lis ce récit : « Je m''appelle Farah. Chaque été, je rejoins mes cousins à Tabarka. Nous plongeons du haut des rochers et nous rentrons épuisés mais heureux. » Qui raconte cette histoire ?', '[{"id":"a","text":"Un narrateur extérieur qui ne participe pas à l''histoire."},{"id":"b","text":"Farah, un personnage de l''histoire qui dit « je »."},{"id":"c","text":"Les cousins de Farah."},{"id":"d","text":"On ne peut pas le savoir."}]'::jsonb, 'b', 'Le récit est raconté à la 1re personne (« je m''appelle Farah… je rejoins ») : le narrateur est Farah elle-même, un personnage de l''histoire ✓. Le piège courant : répondre « narrateur extérieur » — c''est le cas quand le récit dit « il/elle », mais ici le « je » désigne clairement une héroïne qui vit l''histoire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c2147f0b-349e-579e-b135-5dd48a106cf7', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b00ef85-9dfc-5f4b-aa71-fc229e8a904b', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'Comment se forme le passé composé ?', '[{"id":"a","text":"Avec le verbe seul, terminé par -ait"},{"id":"b","text":"Avec l''auxiliaire être ou avoir au présent + le participe passé"},{"id":"c","text":"Avec l''auxiliaire être ou avoir au futur + l''infinitif"},{"id":"d","text":"Avec le pronom sujet + l''infinitif du verbe"}]'::jsonb, 'b', 'Le passé composé s''écrit toujours en deux mots : l''auxiliaire être ou avoir conjugué au présent, suivi du participe passé (ex. : « papa a préparé », « ma sœur est rentrée »).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d7b2f38-cfe9-5abc-8e13-f216a45da40e', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'Au futur simple, quelles sont les terminaisons, valables pour tous les verbes ?', '[{"id":"a","text":"-e, -es, -e, -ons, -ez, -ent"},{"id":"b","text":"-ais, -ais, -ait, -ions, -iez, -aient"},{"id":"c","text":"-rai, -ras, -ra, -rons, -rez, -ront"},{"id":"d","text":"-é, -i, -u, -is, -it, -us"}]'::jsonb, 'c', 'Au futur simple, tous les verbes, sans exception, prennent les mêmes terminaisons : -rai, -ras, -ra, -rons, -rez, -ront (ex. : je rangerai, nous rangerons).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('396ddaf3-d18b-571a-b1fb-adf6bc7c25a4', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'Quelles sont les deux caractéristiques du verbe à l''impératif ?', '[{"id":"a","text":"Le sujet n''est pas exprimé et le verbe ne compte que trois personnes."},{"id":"b","text":"Le sujet est toujours exprimé et le verbe compte six personnes."},{"id":"c","text":"Le verbe est toujours au pluriel et se termine par -ez."},{"id":"d","text":"Le verbe est précédé de « ne » et suivi de « pas »."}]'::jsonb, 'a', 'L''impératif sert à donner des ordres ou des conseils : le sujet n''est pas exprimé et le verbe ne se conjugue qu''à trois personnes (tu, nous, vous) : « Range ! Rangeons ! Rangez ! ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c09583b8-2eeb-5a6a-b8d2-73ee4188282a', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'De quoi est constituée une phrase minimale ?', '[{"id":"a","text":"D''un verbe conjugué et d''un complément circonstanciel"},{"id":"b","text":"D''un groupe sujet et d''un complément de temps"},{"id":"c","text":"D''un seul mot suivi d''un point d''exclamation"},{"id":"d","text":"D''un groupe sujet et d''un groupe verbal"}]'::jsonb, 'd', 'La phrase minimale est réduite à ses deux groupes obligatoires : le groupe sujet (qui fait l''action) et le groupe verbal (ce que fait ou ce qu''est le sujet), ex. : « Mon frère débarrasse la table. »', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0f6544a-de1e-586a-810f-315705762fb6', 'c2147f0b-349e-579e-b135-5dd48a106cf7', 'Complète : « Yasmine ___ rangé sa chambre avant le déjeuner. »', '[{"id":"a","text":"à"},{"id":"b","text":"a"},{"id":"c","text":"as"},{"id":"d","text":"ont"}]'::jsonb, 'b', 'On peut dire « Yasmine avait rangé sa chambre » : c''est donc le verbe avoir à la 3e personne du singulier, qui s''écrit « a » sans accent. « à » est une préposition et « as » correspond au sujet « tu ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('efdb716c-986f-55df-a0aa-838f69aac0c4', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '⭐ Exercice : la journée de la famille', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5ad3943-6fa3-5fcc-9ec4-e698b094b448', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Complète au passé composé : « Ce midi, nous ___ mangé le couscous chez grand-mère. »', '[{"id":"a","text":"a"},{"id":"b","text":"avons"},{"id":"c","text":"ont"},{"id":"d","text":"sommes"}]'::jsonb, 'b', 'Le sujet est « nous » : l''auxiliaire avoir se conjugue à la 1re personne du pluriel, « nous avons mangé ». « a » et « ont » correspondent à d''autres personnes, et « manger » ne se conjugue pas avec être.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a01d389-90c8-55df-a109-bf8efb11d5e6', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Complète au futur simple : « Demain matin, je ___ ma chambre avant de sortir. »', '[{"id":"a","text":"rangerai"},{"id":"b","text":"rangerais"},{"id":"c","text":"rangera"},{"id":"d","text":"rangerons"}]'::jsonb, 'a', 'Avec « je », la terminaison du futur simple est -rai : « je rangerai ». Attention au piège « rangerais » : ce -s final est une erreur fréquente à la 1re personne du futur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0594d7f3-fd69-5af1-bd84-28576507a164', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Quel est l''ordre correctement écrit à l''impératif ?', '[{"id":"a","text":"Tu ranges ta chambre !"},{"id":"b","text":"Ranges ta chambre !"},{"id":"c","text":"Range ta chambre !"},{"id":"d","text":"Rangez ta chambre !"}]'::jsonb, 'c', 'À l''impératif, le sujet n''est pas exprimé, et les verbes du 1er groupe perdent le -s à la 2e personne du singulier : « Range ta chambre ! ». « Rangez » ne convient pas : « ta » indique qu''on parle à une seule personne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80284306-374c-5950-9bf0-ee63dbf4d566', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Complète : « Tu ___ fini ton assiette, bravo ! »', '[{"id":"a","text":"à"},{"id":"b","text":"a"},{"id":"c","text":"ont"},{"id":"d","text":"as"}]'::jsonb, 'd', 'On peut dire « Tu avais fini ton assiette » : c''est le verbe avoir à la 2e personne du singulier, « as ». « a » correspond à « il/elle » et « à » est une préposition.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9140cf80-f559-5709-a5ca-39a0c0b95788', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Laquelle de ces phrases est une phrase non verbale ?', '[{"id":"a","text":"Quel désordre dans le salon !"},{"id":"b","text":"Le salon est en désordre."},{"id":"c","text":"Rim range le salon."},{"id":"d","text":"Nous rangerons le salon demain."}]'::jsonb, 'a', '« Quel désordre dans le salon ! » ne contient aucun verbe conjugué : c''est une phrase non verbale. Les trois autres phrases contiennent un verbe conjugué (est, range, rangerons) : elles sont verbales.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3b0417a-13b1-59d9-b829-75276e09d0ba', 'efdb716c-986f-55df-a0aa-838f69aac0c4', 'Complète au futur simple : « L''année prochaine, tu ___ (être) en 8ème année. »', '[{"id":"a","text":"sera"},{"id":"b","text":"serais"},{"id":"c","text":"seras"},{"id":"d","text":"êtras"}]'::jsonb, 'c', 'Le verbe être a un radical irrégulier au futur : ser-. Avec « tu », on ajoute la terminaison -ras : « tu seras ». « êtras » invente un radical qui n''existe pas, « sera » correspond à « il/elle » et « serais » n''est pas une forme du futur simple.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('87e342b6-0c9d-5c22-9868-f2450a3dac33', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : la maison des trois temps', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b09f4830-f83a-5682-b968-0507b7c48225', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Quelle phrase est correctement écrite au passé composé ?', '[{"id":"a","text":"Mes cousins ont arrivé hier soir."},{"id":"b","text":"Mes cousins sont arrivé hier soir."},{"id":"c","text":"Mes cousins sont arrivés hier soir."},{"id":"d","text":"Mes cousins ont arrivés hier soir."}]'::jsonb, 'c', '« Arriver » est un verbe de mouvement : il se conjugue avec être, et le participe passé s''accorde avec le sujet « mes cousins » (masculin pluriel) : « sont arrivés » ✓. Le piège courant est « ils ont arrivé » : les verbes de mouvement ne prennent jamais l''auxiliaire avoir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('965fabc0-08fa-5c68-8305-a1799dabb089', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Complète au futur simple : « Dimanche, mes grands-parents ___ déjeuner à la maison. »', '[{"id":"a","text":"viendront"},{"id":"b","text":"viendrons"},{"id":"c","text":"veniront"},{"id":"d","text":"viendra"}]'::jsonb, 'a', 'Le verbe venir a le radical irrégulier viendr- au futur ; avec « mes grands-parents » (= ils), la terminaison est -ront : « viendront » ✓. « viendrons » confond avec « nous », « viendra » avec « il », et « veniront » garde à tort le radical de l''infinitif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dd60966-0d9c-556c-a86e-19d374668362', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Transforme à l''impératif : « Tu vas au marché avec ta mère. »', '[{"id":"a","text":"Tu va au marché avec ta mère !"},{"id":"b","text":"Va au marché avec ta mère !"},{"id":"c","text":"Vas au marché avec ta mère !"},{"id":"d","text":"Allez au marché avec ta mère !"}]'::jsonb, 'b', 'À l''impératif, on supprime le sujet, et « aller » perd son -s à la 2e personne du singulier : « Va au marché ! » ✓. Le piège courant est « Vas au marché ! » : ce -s est fautif. « Allez » s''adresse à « vous », ce qui contredit « ta mère ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3a6c2c1-8754-5473-9b27-0fb61669e28f', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Dans ce récit, une phrase contient une erreur de conjugaison. Laquelle ? « 1. Ce matin, je me suis levé tôt. 2. Ma mère a préparé le petit-déjeuner. 3. Mes sœurs sont sorties dans le jardin. 4. Ensuite, nous avons partis à l''école. »', '[{"id":"a","text":"La phrase 1"},{"id":"b","text":"La phrase 2"},{"id":"c","text":"La phrase 3"},{"id":"d","text":"La phrase 4"}]'::jsonb, 'd', 'La phrase 4 est fautive : « Partir » est un verbe de mouvement : il exige l''auxiliaire être, donc « nous sommes partis » ✓ et non « nous avons partis ». Les phrases 1 (pronominal avec être), 2 (avoir) et 3 (mouvement avec être + accord « sorties ») sont correctes. (Question « chasse à l''erreur » : la bonne réponse désigne la phrase fautive.)', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f54f6a8-14a1-5ac0-b668-b12d9c0b8c99', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Complète au futur simple : « Demain, tu ___ (faire) les courses et nous ___ (aller) chez le coiffeur. »', '[{"id":"a","text":"feras … irons"},{"id":"b","text":"fairas … irons"},{"id":"c","text":"feras … allerons"},{"id":"d","text":"fairas … allerons"}]'::jsonb, 'a', 'Deux radicaux irréguliers à mobiliser : faire → fer- (« tu feras ») et aller → ir- (« nous irons ») ✓. Le piège courant est de fabriquer le futur sur l''infinitif : « fairas » et « allerons » n''existent pas.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab362268-2a4f-5e6c-b881-461682b745d4', '87e342b6-0c9d-5c22-9868-f2450a3dac33', 'Complète au passé composé : « Ma tante et ma cousine ___ à la gare de Tunis. »', '[{"id":"a","text":"s''ont retrouvées"},{"id":"b","text":"se sont retrouvées"},{"id":"c","text":"se sont retrouvés"},{"id":"d","text":"se sont retrouvé"}]'::jsonb, 'b', '« Se retrouver » est un verbe pronominal : auxiliaire être, jamais avoir (« s''ont » n''existe pas). Avec être, le participe passé s''accorde avec le sujet « ma tante et ma cousine » (féminin pluriel) : « se sont retrouvées » ✓. « retrouvés » oublie que les deux sujets sont féminins.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ce217c22-d655-5ad1-af2a-87b2cef15ee1', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '⭐⭐ Révision (type examen) : le quotidien à la maison', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a16e931-dcb5-5ea2-94e9-049f45b61f3a', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Complète au passé composé : « Mes sœurs sont ___ au marché de Bab El Fella. »', '[{"id":"a","text":"allées"},{"id":"b","text":"allés"},{"id":"c","text":"allée"},{"id":"d","text":"allé"}]'::jsonb, 'a', 'Avec l''auxiliaire être, le participe passé s''accorde avec le sujet. « Mes sœurs » est féminin pluriel : « allées » (+es). « allés » oublie le féminin, « allée » le pluriel, « allé » les deux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84159263-c4b7-5241-9216-f33d0434fe46', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Complète : « Tu ___ promis d''aider maman ce soir. »', '[{"id":"a","text":"à"},{"id":"b","text":"a"},{"id":"c","text":"as"},{"id":"d","text":"es"}]'::jsonb, 'c', 'On peut dire « Tu avais promis » : c''est donc le verbe avoir à la 2e personne du singulier, « as ». « a » correspond à « il/elle », « à » est une préposition et « es » est le verbe être.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4ce4e63-ffe1-5144-a3de-6945dba7aa36', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Complète au passé composé : « Salma et sa sœur ___ levées tôt pour préparer la fête. »', '[{"id":"a","text":"s''ont"},{"id":"b","text":"se sont"},{"id":"c","text":"sont se"},{"id":"d","text":"ont"}]'::jsonb, 'b', '« Se lever » est un verbe pronominal : au passé composé, il se conjugue toujours avec l''auxiliaire être, placé après le pronom : « elles se sont levées ». « s''ont » et « ont » utilisent à tort l''auxiliaire avoir.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e66480d-06d6-53f0-8798-bfa1d13e7878', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Quelle valeur exprime le futur dans la phrase : « Tu rangeras ta chambre avant de sortir. » ?', '[{"id":"a","text":"Une action déjà terminée"},{"id":"b","text":"Une émotion forte"},{"id":"c","text":"Une vérité générale"},{"id":"d","text":"Un ordre, une consigne"}]'::jsonb, 'd', 'Le futur simple exprime une action à venir, mais il peut aussi servir à donner un ordre ou une consigne, comme ici : le parent impose une tâche à faire avant de sortir.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('849f7186-bf21-523f-b0dc-bd6eaf2e45f5', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Quelle est la phrase minimale contenue dans : « Chaque soir, après le dîner, mon frère débarrasse la table. » ?', '[{"id":"a","text":"Chaque soir, mon frère débarrasse la table."},{"id":"b","text":"Mon frère, après le dîner."},{"id":"c","text":"Mon frère débarrasse la table."},{"id":"d","text":"Après le dîner, mon frère débarrasse."}]'::jsonb, 'c', 'La phrase minimale garde seulement le groupe sujet (« mon frère ») et le groupe verbal (« débarrasse la table »). « Chaque soir » et « après le dîner » sont des compléments circonstanciels de temps : on les supprime.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87377104-3846-5e21-9419-b47d12027968', 'ce217c22-d655-5ad1-af2a-87b2cef15ee1', 'Complète à l''impératif : « ___ tes devoirs avant le dîner ! »', '[{"id":"a","text":"Finis"},{"id":"b","text":"Finit"},{"id":"c","text":"Finie"},{"id":"d","text":"Finissez"}]'::jsonb, 'a', '« Tes » montre qu''on s''adresse à une seule personne (tu). « Finir » est un verbe du 2e groupe : à l''impératif, il garde son -s à la 2e personne du singulier : « Finis ! ». Seuls les verbes du 1er groupe (et aller) perdent le -s.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('870ae3fb-8bd2-519a-b791-0355256928d2', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le grand tournoi du foyer', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cc56ce3-cbec-566e-9d7d-0eaa649fed4d', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Dans l''ordre « Sortez la poubelle ! », à quelle personne le verbe est-il conjugué, et quel est le sujet sous-entendu ?', '[{"id":"a","text":"2e personne du singulier — sujet sous-entendu « tu »"},{"id":"b","text":"2e personne du pluriel — sujet sous-entendu « vous »"},{"id":"c","text":"1re personne du pluriel — sujet sous-entendu « nous »"},{"id":"d","text":"3e personne du pluriel — sujet sous-entendu « ils »"}]'::jsonb, 'b', 'La terminaison -ez indique la 2e personne du pluriel : le sujet sous-entendu est « vous ». Rappel : l''impératif n''existe qu''à trois personnes (tu, nous, vous), donc « ils » est impossible, et le sujet n''est jamais écrit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9f163f9-dfd9-5fd5-868b-6519ad239e1e', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Réécris au passé composé : « Nous nous habillons rapidement et nous aidons maman. »', '[{"id":"a","text":"Nous nous avons habillés rapidement et nous avons aidé maman."},{"id":"b","text":"Nous nous sommes habillés rapidement et nous sommes aidé maman."},{"id":"c","text":"Nous nous sommes habillés rapidement et nous avons aidé maman."},{"id":"d","text":"Nous nous sommes habillé rapidement et nous avons aidés maman."}]'::jsonb, 'c', 'Deux auxiliaires à choisir : « s''habiller » est pronominal → être, avec accord au sujet (« nous nous sommes habillés ») ; « aider » → avoir, sans accord ici (« nous avons aidé ») ✓. Le piège courant : mettre avoir au pronominal (« nous nous avons habillés ») ou inverser les accords.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b988d77-9284-569b-8e67-2b5fb6ae9dec', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Une seule de ces formes du futur simple est mal orthographiée. Laquelle ?', '[{"id":"a","text":"je viendrai"},{"id":"b","text":"tu seras"},{"id":"c","text":"il ira"},{"id":"d","text":"nous ferrons"}]'::jsonb, 'd', 'Le radical du futur de « faire » est fer- avec un seul r : « nous ferons ». « ferrons » double le r à tort (piège courant, par imitation de « nous verrons »). Les trois autres formes sont correctes : viendr- (venir), ser- (être), ir- (aller). (Question « chasse à l''erreur » : la bonne réponse désigne la forme fautive.)', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d70d42e2-4d38-5684-8bfc-867da3cdc32f', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Quel groupe sujet peut compléter la phrase : « ___ sont montées se coucher. » ?', '[{"id":"a","text":"Mes petites sœurs"},{"id":"b","text":"Mon petit frère"},{"id":"c","text":"Mes cousins"},{"id":"d","text":"Le bébé"}]'::jsonb, 'a', 'Deux indices à croiser : « sont » exige un sujet pluriel (on élimine « mon petit frère » et « le bébé »), et « montées » avec -es exige un sujet féminin (on élimine « mes cousins »). Seul « mes petites sœurs » ✓ est féminin pluriel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fee4803-d3ab-523c-9ee5-ed0f50fd34a9', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Quelle phrase enrichit la phrase minimale « Rim chante. » avec un complément circonstanciel de temps ?', '[{"id":"a","text":"Rim chante une jolie chanson."},{"id":"b","text":"Rim chante le soir."},{"id":"c","text":"Rim chante dans la salle de bain."},{"id":"d","text":"La petite Rim chante."}]'::jsonb, 'b', '« Le soir » précise le moment : c''est un complément circonstanciel de temps, supprimable et déplaçable ✓. Le piège courant : « dans la salle de bain » est bien un CC, mais de lieu ; « une jolie chanson » complète directement le verbe, et « la petite » enrichit le groupe sujet, pas la phrase par un CC.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fdd0be9f-29be-5edd-b41f-f105659e31b4', '870ae3fb-8bd2-519a-b791-0355256928d2', 'Quelle phrase est entièrement correcte (conjugaison et orthographe) ?', '[{"id":"a","text":"Ce soir, tu débarrasseras la table et tu ira au lit à neuf heures."},{"id":"b","text":"Ce soir, tu débarrasserais la table et tu iras au lit à neuf heures."},{"id":"c","text":"Ce soir, tu débarrasseras la table et tu iras au lit à neuf heures."},{"id":"d","text":"Ce soir, tu débarrasseras la table et tu iras au lit a neuf heures."}]'::jsonb, 'c', 'Il faut vérifier trois points : « tu débarrasseras » et « tu iras » (futur, terminaison -ras) et la préposition « à » devant « neuf heures » ✓. Les pièges : « tu ira » oublie le -s de « tu », « débarrasserais » ajoute un -s fautif à la terminaison -rai(s), et « a neuf heures » confond la préposition à avec le verbe avoir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : une journée en famille (révision globale)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8247de8-33db-5da3-9309-488f76ba34b3', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Quelle phrase est correctement orthographiée ?', '[{"id":"a","text":"Sami à aidé sa sœur a ranger le salon."},{"id":"b","text":"Sami a aidé sa sœur à ranger le salon."},{"id":"c","text":"Sami a aidé sa sœur a ranger le salon."},{"id":"d","text":"Sami à aidé sa sœur à ranger le salon."}]'::jsonb, 'b', 'Premier mot : « Sami a aidé » = verbe avoir (on peut dire « Sami avait aidé »), donc « a » sans accent. Second mot : devant l''infinitif « ranger », le test « avait » est impossible, c''est la préposition « à » avec accent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('183db602-5a7e-5833-ab05-3ce5b0680b5b', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Dans la phrase « Ma grand-mère prépare le tajine dans la cuisine. », quel groupe peut-on supprimer ou déplacer sans détruire la phrase ?', '[{"id":"a","text":"Ma grand-mère"},{"id":"b","text":"prépare"},{"id":"c","text":"le tajine"},{"id":"d","text":"dans la cuisine"}]'::jsonb, 'd', '« Dans la cuisine » est un complément circonstanciel de lieu : on peut le supprimer (« Ma grand-mère prépare le tajine. ») ou le déplacer en tête de phrase. Le groupe sujet et le groupe verbal, eux, sont obligatoires.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54e2dc59-8308-5bd5-a25d-1bddca6f8f0e', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Complète au futur simple : « Bientôt, vous ___ (avoir) une nouvelle petite cousine. »', '[{"id":"a","text":"aurez"},{"id":"b","text":"avoirez"},{"id":"c","text":"auriez"},{"id":"d","text":"avez"}]'::jsonb, 'a', 'Le verbe avoir a le radical irrégulier aur- au futur ; avec « vous », la terminaison est -rez : « vous aurez ». « avoirez » construit le futur sur l''infinitif, « avez » est le présent et « auriez » n''est pas une forme du futur simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ccf6e9f-7ef6-584d-9443-d7b21ee9ac1e', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Complète au passé composé : « Hier, ma mère ___ (rentrer) tard et elle ___ (préparer) le dîner rapidement. »', '[{"id":"a","text":"a rentré … a préparé"},{"id":"b","text":"est rentré … a préparé"},{"id":"c","text":"est rentrée … a préparé"},{"id":"d","text":"est rentrée … est préparé"}]'::jsonb, 'c', '« Rentrer » est un verbe de mouvement → auxiliaire être, avec accord au sujet féminin : « est rentrée » ✓. « Préparer » → auxiliaire avoir : « a préparé » ✓. Le piège courant : donner le même auxiliaire aux deux verbes, ou oublier le -e de l''accord avec être.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dc05e29-adbd-5738-9e3b-fbfb86adef44', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Complète à l''impératif, à la 1re personne du pluriel : « ___ (prendre) le temps de dîner ensemble ! »', '[{"id":"a","text":"Prendons"},{"id":"b","text":"Prenons"},{"id":"c","text":"Prennons"},{"id":"d","text":"Prenez"}]'::jsonb, 'b', 'À l''impératif, la 1re personne du pluriel exprime une proposition faite au groupe : « Prenons ! » (comme au présent : nous prenons) ✓. « Prendons » et « Prennons » déforment le radical, et « Prenez » s''adresse à « vous », pas à « nous ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e09e5bf-1e31-5931-aa6d-66fabcaaf89a', '60ae7d38-59bf-5e4d-8320-ac3b8d716a5e', 'Une seule de ces affirmations est vraie. Laquelle ?', '[{"id":"a","text":"Avec l''auxiliaire être, le participe passé s''accorde avec le sujet."},{"id":"b","text":"Au futur simple, les terminaisons changent selon le groupe du verbe."},{"id":"c","text":"L''impératif se conjugue à six personnes, avec un sujet exprimé."},{"id":"d","text":"Une phrase non verbale contient toujours un verbe conjugué."}]'::jsonb, 'a', 'Avec être, le participe passé s''accorde en genre et en nombre avec le sujet (« mes cousines sont arrivées ») ✓. Les autres affirmations sont fausses : au futur, tous les verbes ont les mêmes terminaisons ; l''impératif ne compte que trois personnes sans sujet exprimé ; une phrase non verbale ne contient justement aucun verbe conjugué.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('99b16069-34d1-5009-9d7d-8638a9b01ab0', '331dfde0-73a4-592f-87d4-2d91ef9885f9', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : l''épreuve suprême de la maisonnée', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2fce535-dc06-5802-812e-12c88a809f59', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Transforme la phrase non verbale « Départ du bus scolaire à sept heures. » en phrase verbale.', '[{"id":"a","text":"Le départ du bus scolaire à sept heures."},{"id":"b","text":"Départ du bus scolaire, sept heures pile."},{"id":"c","text":"Le bus scolaire part à sept heures."},{"id":"d","text":"Le bus scolaire, à sept heures."}]'::jsonb, 'c', 'Une phrase verbale doit contenir un verbe conjugué : « part » transforme l''annonce en phrase verbale. Les trois autres propositions restent sans verbe conjugué : ajouter un article ou une virgule ne suffit pas.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8db64676-74a2-5a33-8283-1bd9f12980c1', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Complète au passé composé : « Mes cousins, ___ bien trop tard hier soir ! » (se coucher)', '[{"id":"a","text":"vous vous êtes couchés"},{"id":"b","text":"vous vous avez couchés"},{"id":"c","text":"vous vous êtes couché"},{"id":"d","text":"vous êtes vous couchés"}]'::jsonb, 'a', '« Se coucher » est pronominal : pronom + auxiliaire être (« vous vous êtes »), et le participe passé s''accorde avec le sujet « mes cousins » (masculin pluriel) : « couchés » ✓. Les pièges : l''auxiliaire avoir (« vous vous avez »), l''oubli du -s de l''accord, et l''ordre des mots inversé.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e45c6ed-d298-57e9-816d-1fa1e1722c4d', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Une seule de ces phrases contient une erreur d''homophone. Laquelle ? « 1. Tu as promis de venir vendredi. 2. Rim a téléphoné à sa tante. 3. Ma tante habite à Bizerte. 4. Papa à garé la voiture devant la maison. »', '[{"id":"a","text":"La phrase 1"},{"id":"b","text":"La phrase 2"},{"id":"c","text":"La phrase 3"},{"id":"d","text":"La phrase 4"}]'::jsonb, 'd', 'Dans la phrase 4, on peut dire « Papa avait garé la voiture » : il faut le verbe avoir « a », sans accent — « à garé » est fautif. Les phrases 1 (as = avais), 2 (a = avait, puis préposition à) et 3 (préposition à devant un lieu) sont correctes. (Question « chasse à l''erreur » : la bonne réponse désigne la phrase fautive.)', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de483ea6-ba44-5c0c-b048-96ca3cd39290', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Transforme en ordres à l''impératif : « Tu te réveilles tôt et tu fais ton lit. »', '[{"id":"a","text":"Réveilles-toi tôt et fais ton lit !"},{"id":"b","text":"Réveille-toi tôt et fais ton lit !"},{"id":"c","text":"Réveille-toi tôt et fait ton lit !"},{"id":"d","text":"Te réveille tôt et fais ton lit !"}]'::jsonb, 'b', 'Deux règles à combiner : le verbe pronominal rejette son pronom après le verbe avec un trait d''union (« Réveille-toi », sans -s : 1er groupe), et « faire » garde son -s à la 2e personne (« fais ») ✓. Les pièges : le -s fautif (« Réveilles »), la forme « fait » (3e personne) et le pronom laissé devant le verbe.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f75b2b2f-bb1b-5198-a15d-dcba9adc87aa', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Combien de compléments circonstanciels contient la phrase : « Pendant les vacances, mes parents repeindront la vieille armoire avec soin. » ?', '[{"id":"a","text":"Un seul : « pendant les vacances »"},{"id":"b","text":"Un seul : « avec soin »"},{"id":"c","text":"Deux : « pendant les vacances » et « avec soin »"},{"id":"d","text":"Trois : « pendant les vacances », « la vieille armoire » et « avec soin »"}]'::jsonb, 'c', 'Deux groupes réussissent le test du CC (supprimables et déplaçables) : « pendant les vacances » (temps) et « avec soin » (manière) ✓. Le piège : « la vieille armoire » ne peut être ni supprimée ni déplacée sans casser la phrase — elle fait partie du groupe verbal.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c764e0f5-f73d-587e-b464-6a06759cc247', '99b16069-34d1-5009-9d7d-8638a9b01ab0', 'Complète : « Hier, Selma ___ (descendre) au marché de Nabeul ; demain, elle ___ (avoir) le temps de se reposer, car elle ___ terminé ses courses. »', '[{"id":"a","text":"est descendue … aura … a"},{"id":"b","text":"a descendu … aura … a"},{"id":"c","text":"est descendue … avoira … a"},{"id":"d","text":"est descendue … aura … à"}]'::jsonb, 'a', 'Trois verrous à ouvrir : « descendre » est un verbe de mouvement → être + accord féminin (« est descendue ») ; le futur d''avoir se construit sur le radical aur- (« elle aura ») ; enfin « elle a terminé » = avoir (test : « elle avait terminé »), sans accent ✓. Chaque distracteur casse exactement un de ces trois verrous.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('38d5735d-a8f1-59ca-8c57-40cd29139619', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62e9a750-5dc8-5099-9a4e-65b3e45cae55', '38d5735d-a8f1-59ca-8c57-40cd29139619', 'Qu''exprime le futur simple ?', '[{"id":"a","text":"Une action passée et terminée"},{"id":"b","text":"Une action qui se déroule en ce moment"},{"id":"c","text":"Une action à venir"},{"id":"d","text":"Une vérité générale"}]'::jsonb, 'c', 'Le futur simple exprime une action à venir : « Demain, nous visiterons la médina. » L''action passée relève du passé composé, l''action en cours et la vérité générale relèvent du présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16c6fbf5-ae44-59b8-94f2-ab64ee3c1454', '38d5735d-a8f1-59ca-8c57-40cd29139619', 'Quelles sont les terminaisons du futur simple, identiques pour tous les verbes ?', '[{"id":"a","text":"-e, -es, -e, -ons, -ez, -ent"},{"id":"b","text":"-rai, -ras, -ra, -rons, -rez, -ront"},{"id":"c","text":"-rais, -rais, -rait, -rions, -riez, -raient"},{"id":"d","text":"-s, -s, -t, -ons, -ez, -ont"}]'::jsonb, 'b', 'Au futur simple, tous les verbes prennent les terminaisons -rai, -ras, -ra, -rons, -rez, -ront. Attention au piège du « s » : « je visiterai » s''écrit sans « s » final.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9e94a90-4977-594a-a3df-e0386a5cc4aa', '38d5735d-a8f1-59ca-8c57-40cd29139619', 'De quoi est composé un groupe nominal minimal ?', '[{"id":"a","text":"D''un déterminant et d''un nom"},{"id":"b","text":"D''un nom et d''un adjectif épithète"},{"id":"c","text":"D''un déterminant, d''un nom et d''un adjectif"},{"id":"d","text":"D''un sujet et d''un verbe"}]'::jsonb, 'a', 'Le GN minimal se réduit à un déterminant + un nom : « le souk », « une ferme ». Dès qu''on ajoute un adjectif épithète, le GN devient étendu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('045f9cf3-c80c-5c00-a77b-18389fcc3ceb', '38d5735d-a8f1-59ca-8c57-40cd29139619', 'Où se trouve l''adjectif attribut ?', '[{"id":"a","text":"Toujours placé devant le nom"},{"id":"b","text":"Dans le GN, directement à côté du nom"},{"id":"c","text":"Toujours en début de phrase"},{"id":"d","text":"Après un verbe d''état comme « être » ou « sembler »"}]'::jsonb, 'd', 'L''attribut est relié au nom par un verbe d''état (être, sembler, paraître, devenir, rester) : « La campagne est calme. » L''adjectif placé à côté du nom dans le GN est, lui, une épithète.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('621e26ca-425e-5542-8ea2-d6e369884f35', '38d5735d-a8f1-59ca-8c57-40cd29139619', 'Pour vérifier qu''il faut écrire « est » (et non « et »), on peut le remplacer par :', '[{"id":"a","text":"« et puis »"},{"id":"b","text":"« était »"},{"id":"c","text":"« il »"},{"id":"d","text":"« avaient »"}]'::jsonb, 'b', '« est » est le verbe être à la 3e personne du singulier : on peut le remplacer par « était ». Si c''est « et puis » qui convient, il faut écrire « et » ; « avaient » sert à vérifier « ont » et « il » à vérifier « on ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '⭐ Exercice : premiers pas entre ville et campagne', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('349fbcf2-f64c-5d6b-9c8e-d2ef96e23876', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Complète : « Demain, nous ____ la médina de Tunis. » (visiter)', '[{"id":"a","text":"visitons"},{"id":"b","text":"visiterons"},{"id":"c","text":"visiterions"},{"id":"d","text":"visitrons"}]'::jsonb, 'b', '« Demain » annonce une action à venir : futur simple. Radical (l''infinitif) + terminaison de « nous » : visiter + -ons → « visiterons ». « Visitons » est le présent et « visiterions » n''a pas la terminaison -rons du futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e7d33aa-8fdb-5f1a-9065-9f0f586f6a66', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Complète : « L''année prochaine, j''____ chez mes grands-parents au village. » (aller)', '[{"id":"a","text":"allerai"},{"id":"b","text":"vais"},{"id":"c","text":"irai"},{"id":"d","text":"irais"}]'::jsonb, 'c', '« Aller » a un radical irrégulier au futur : ir-. On écrit « j''irai ». « Allerai » régularise le verbe à tort, « vais » est le présent, et « irais » ajoute un « s » que la 1re personne du futur ne prend pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5239f6a0-9208-5a7e-9fd9-e64663542f1b', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Lequel de ces groupes est un GN minimal (déterminant + nom) ?', '[{"id":"a","text":"le souk"},{"id":"b","text":"le grand souk"},{"id":"c","text":"il"},{"id":"d","text":"le souk animé"}]'::jsonb, 'a', '« Le souk » = déterminant + nom, sans expansion : c''est un GN minimal. « Le grand souk » et « le souk animé » contiennent un adjectif épithète (GN étendus), et « il » est un pronom, pas un GN.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf45cedb-df42-5fa0-b21e-0ae99ee49482', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Dans la phrase « Les ruelles étroites de la médina attirent les visiteurs. », quel mot est un adjectif épithète ?', '[{"id":"a","text":"Les"},{"id":"b","text":"ruelles"},{"id":"c","text":"étroites"},{"id":"d","text":"visiteurs"}]'::jsonb, 'c', '« Étroites » est placé dans le GN, directement à côté du nom « ruelles » : c''est un adjectif épithète. « Les » est un déterminant, « ruelles » et « visiteurs » sont des noms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fa05f10-0cba-5d87-8676-5beba260dce8', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Dans la phrase « La campagne est calme. », le mot « calme » est :', '[{"id":"a","text":"un déterminant"},{"id":"b","text":"un adjectif épithète"},{"id":"c","text":"un nom"},{"id":"d","text":"un adjectif attribut"}]'::jsonb, 'd', '« Calme » est relié au nom par le verbe d''état « est » : c''est un adjectif attribut du sujet « la campagne ». Il serait épithète s''il touchait le nom dans le GN : « la campagne calme ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aad6bb64-2ab3-5bba-a077-e3d969df32cd', '4fa94bf9-b486-50ed-b9cb-1b0efeeaa9c9', 'Complète : « Mes cousins ____ une oliveraie au Cap Bon. »', '[{"id":"a","text":"on"},{"id":"b","text":"ont"},{"id":"c","text":"et"},{"id":"d","text":"est"}]'::jsonb, 'b', 'On peut dire « Mes cousins avaient une oliveraie » : il s''agit donc du verbe avoir, « ont ». « On » est un pronom sujet (remplaçable par « il ») et ne convient pas ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0b92d047-a2a9-5282-aadc-f911acee4298', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : le gardien des deux paysages', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55710205-0a61-5af4-a214-fbb6e51569b5', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Complète : « Nos amis de Tunis ____ passer l''été à la campagne. » (venir)', '[{"id":"a","text":"veniront"},{"id":"b","text":"viendront"},{"id":"c","text":"viendrons"},{"id":"d","text":"viennent"}]'::jsonb, 'b', '« Venir » a le radical irrégulier viendr- au futur : « ils viendront » ✓. Le piège courant est de régulariser le radical (« veniront »). « Viendrons » est la terminaison de « nous », et « viennent » est le présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ac60b94-ece9-5c8c-aa61-47de3d9496f5', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Lequel de ces groupes est un GN étendu ?', '[{"id":"a","text":"la ruelle"},{"id":"b","text":"cette ruelle"},{"id":"c","text":"une ruelle sombre"},{"id":"d","text":"elles"}]'::jsonb, 'c', '« Une ruelle sombre » = déterminant + nom + adjectif épithète : le GN est étendu par une expansion. « La ruelle » et « cette ruelle » restent des GN minimaux (déterminant + nom), et « elles » est un pronom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cf07c35-ec20-534c-8e97-922d010b3e30', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Lequel de ces verbes n''est **pas** un verbe d''état ?', '[{"id":"a","text":"devenir"},{"id":"b","text":"rester"},{"id":"c","text":"sembler"},{"id":"d","text":"traverser"}]'::jsonb, 'd', '« Traverser » exprime une action, pas un état : ce n''est pas un verbe d''état. Les verbes d''état à connaître sont être, sembler, paraître, devenir et rester ; ce sont eux qui introduisent un adjectif attribut.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db18977d-2ff0-5312-be71-8a7638a3b0f3', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Dans la phrase « La nouvelle route reliera bientôt notre village à la ville. », quelle analyse est correcte ?', '[{"id":"a","text":"« nouvelle » est épithète et « reliera » est au futur simple"},{"id":"b","text":"« nouvelle » est attribut et « reliera » est au futur simple"},{"id":"c","text":"« nouvelle » est épithète et « reliera » est au présent"},{"id":"d","text":"« nouvelle » est attribut et « reliera » est au présent"}]'::jsonb, 'a', '« Nouvelle » touche le nom « route » dans le GN : épithète ✓. « Reliera » = relier + -ra : futur simple ✓. Le piège courant est d''appeler « attribut » tout adjectif qui décrit un nom : l''attribut exige un verbe d''état entre le nom et l''adjectif, ce qui n''est pas le cas ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('850af2b6-c8e3-526d-b2ed-ff0f2fba3e74', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Complète : « Les collines du nord-ouest restent ____ toute l''année. » (vert)', '[{"id":"a","text":"vert"},{"id":"b","text":"verte"},{"id":"c","text":"verts"},{"id":"d","text":"vertes"}]'::jsonb, 'd', '« Rester » est un verbe d''état : l''adjectif est attribut du sujet « les collines » (féminin pluriel) → « vertes » ✓. Le piège courant est le piège de proximité : accorder avec « nord-ouest » (masculin) donne « verts », qui est faux.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('893992a7-c755-5cfb-800e-cc73a7cf873f', '0b92d047-a2a9-5282-aadc-f911acee4298', 'Complète : « Tu ____ chanceux d''habiter près de la mer, ____ tes amis le savent. »', '[{"id":"a","text":"es … et"},{"id":"b","text":"est … et"},{"id":"c","text":"es … est"},{"id":"d","text":"et … es"}]'::jsonb, 'a', '« Tu es » : verbe être à la 2e personne (remplaçable par « étais ») ✓, puis « et » relie les deux idées (remplaçable par « et puis ») ✓. Le piège courant est d''écrire « est » après « tu » : « est » ne s''emploie qu''à la 3e personne du singulier.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('018f97a5-b9fe-5893-87bf-732576d4de20', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '⭐⭐ Révision (type examen) : de la médina aux oliveraies', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('014c22b3-8d3a-58ee-9ae4-08b81336d81c', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Complète : « Dans quelques années, cette place ____ un vaste jardin public. » (être)', '[{"id":"a","text":"est"},{"id":"b","text":"sera"},{"id":"c","text":"serait"},{"id":"d","text":"seras"}]'::jsonb, 'b', '« Être » a le radical irrégulier ser- au futur : « elle sera » ✓. « Est » est le présent, « serait » ajoute un « s » de conditionnel, et « seras » est la 2e personne (avec « tu »).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f6b2a93-0bc3-545c-9ea0-39a5022d77fe', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Complète : « La place du village ____ déserte en été. »', '[{"id":"a","text":"et"},{"id":"b","text":"es"},{"id":"c","text":"est"},{"id":"d","text":"ait"}]'::jsonb, 'c', 'On peut dire « La place du village était déserte » : c''est donc le verbe être à la 3e personne, « est ». « Et » relie deux mots, « es » ne s''emploie qu''avec « tu », et « ait » est une forme du verbe avoir.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa811334-307a-545d-bad6-96b69671f232', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Complète : « Les boutiques du souk ____ tôt le matin. » (s''ouvrir)', '[{"id":"a","text":"s''ouvrent"},{"id":"b","text":"ouvriront"},{"id":"c","text":"s''ouvriras"},{"id":"d","text":"s''ouvriront"}]'::jsonb, 'd', 'Verbe pronominal au futur : le pronom « s'' » reste devant le verbe, et « les boutiques » demande la terminaison -ront → « s''ouvriront » ✓. « S''ouvrent » est le présent, « ouvriront » oublie le pronom, et « s''ouvriras » est la 2e personne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73c75612-0518-5f8a-a199-fec0d77cb396', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Compare « les champs immenses » et « les champs semblent immenses ». Dans quelle construction « immenses » est-il épithète ?', '[{"id":"a","text":"Dans la première seulement"},{"id":"b","text":"Dans la seconde seulement"},{"id":"c","text":"Dans les deux constructions"},{"id":"d","text":"Dans la seconde, car « sembler » est un verbe d''action"}]'::jsonb, 'a', 'Dans « les champs immenses », l''adjectif touche le nom dans le GN : épithète. Dans « les champs semblent immenses », le verbe d''état « sembler » relie le nom à l''adjectif : « immenses » devient attribut du sujet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b26a04c3-ba76-5a16-9b45-08cc5cb8c010', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Complète : « Nous longerons une avenue ____ . » (bruyant, animé)', '[{"id":"a","text":"bruyant et animé"},{"id":"b","text":"bruyante et animé"},{"id":"c","text":"bruyante et animée"},{"id":"d","text":"bruyantes et animées"}]'::jsonb, 'c', 'Les deux adjectifs sont épithètes du nom « avenue », féminin singulier : chacun s''accorde → « bruyante et animée » ✓. Oublier l''accord du second adjectif (« bruyante et animé ») est l''erreur la plus fréquente ; le pluriel est faux car il n''y a qu''une seule avenue.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f567ef7c-b142-5d1a-8475-8edf4daa416c', '018f97a5-b9fe-5893-87bf-732576d4de20', 'Complète : « ____ dit que les habitants de la campagne ____ un grand sens de l''accueil. »', '[{"id":"a","text":"On … ont"},{"id":"b","text":"On … on"},{"id":"c","text":"Ont … on"},{"id":"d","text":"Ont … ont"}]'::jsonb, 'a', '« On dit » : pronom sujet, remplaçable par « il » (« il dit »). « Les habitants ont » : verbe avoir, remplaçable par « avaient ». Le piège est d''échanger les deux : « ont » ne peut jamais être sujet d''un verbe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('763f3540-6f8c-5bdd-bb55-6e3141ece91b', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : maître du futur et du GN', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9180cacc-e0fa-57bd-8589-017e0d331e66', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Complète : « Depuis la terrasse du village, tu ____ une vue sur toute la baie. » (avoir)', '[{"id":"a","text":"auras"},{"id":"b","text":"aura"},{"id":"c","text":"aurais"},{"id":"d","text":"avais"}]'::jsonb, 'a', '« Avoir » a le radical irrégulier aur- au futur : « tu auras » ✓. Le piège courant est d''écrire « aura » (3e personne), de glisser vers le conditionnel « aurais », ou de rester à l''imparfait « avais ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10f84c01-3918-535f-a678-775087f22ac6', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Quelle affirmation est vraie ?', '[{"id":"a","text":"Un GN minimal contient toujours un adjectif épithète."},{"id":"b","text":"L''adjectif épithète est séparé du nom par un verbe d''état."},{"id":"c","text":"Un GN étendu contient une expansion, comme un adjectif épithète."},{"id":"d","text":"L''adjectif attribut est toujours placé à l''intérieur du groupe nominal."}]'::jsonb, 'c', 'Le GN étendu = GN minimal + expansion (ici l''adjectif épithète) ✓. Les trois autres affirmations inversent les définitions : le GN minimal n''a aucune expansion, c''est l''attribut (et non l''épithète) qui suit un verbe d''état, et l''attribut est justement hors du GN.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('052eaa98-193d-5a29-8211-e2f7cb97403e', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Quelle phrase est correctement écrite ?', '[{"id":"a","text":"Les matinées à la campagne sont fraîche."},{"id":"b","text":"Les matinées à la campagne sont fraîches."},{"id":"c","text":"Les matinée à la campagne sont fraîches."},{"id":"d","text":"Les matinées à la campagne est fraîches."}]'::jsonb, 'b', '« Fraîches » est attribut du sujet « les matinées » (féminin pluriel) : accord en genre et en nombre ✓, et « sont » s''accorde avec son sujet pluriel ✓. Les autres phrases oublient l''accord de l''adjectif (a), le pluriel du nom (c) ou l''accord sujet-verbe (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9f62452-f2c7-54bf-9822-9216218aa379', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Réécris au futur simple : « Nous nous promenons dans les ruelles blanches de Sidi Bou Saïd. »', '[{"id":"a","text":"Nous nous promenons dans les ruelles blanches de Sidi Bou Saïd."},{"id":"b","text":"Nous nous sommes promenés dans les ruelles blanches de Sidi Bou Saïd."},{"id":"c","text":"Nous promènerons dans les ruelles blanches de Sidi Bou Saïd."},{"id":"d","text":"Nous nous promènerons dans les ruelles blanches de Sidi Bou Saïd."}]'::jsonb, 'd', 'Verbe pronominal au futur : le pronom « nous » reste devant le verbe → « nous nous promènerons » ✓ (avec l''accent grave de « promener »). Le piège courant est de perdre le pronom (« nous promènerons ») ; la phrase (a) est restée au présent et la (b) est au passé composé.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48626e52-cf7b-502e-9cf5-378cd131f71c', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Complète : « ____ visitera d''abord la kasbah, ____ ensuite ____ ira au port. »', '[{"id":"a","text":"On … est … on"},{"id":"b","text":"On … et … on"},{"id":"c","text":"Ont … et … on"},{"id":"d","text":"On … et … ont"}]'::jsonb, 'b', '« On visitera » et « on ira » : pronom sujet, remplaçable par « il » ✓ ; « et ensuite » relie les deux actions, remplaçable par « et puis » ✓. Le piège courant : « ont » est le verbe avoir, il ne peut jamais être sujet de « visitera » ni de « ira ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bd99855-2250-5c62-a99e-ce5cf56f2e4e', '763f3540-6f8c-5bdd-bb55-6e3141ece91b', 'Dans la phrase « Quand tu reviendras au village, tu resteras étonné devant les nouvelles constructions. », quelle analyse est correcte ?', '[{"id":"a","text":"« étonné » est épithète et « nouvelles » est attribut"},{"id":"b","text":"« étonné » et « nouvelles » sont tous les deux épithètes"},{"id":"c","text":"« étonné » est attribut et « nouvelles » est épithète"},{"id":"d","text":"« étonné » et « nouvelles » sont tous les deux attributs"}]'::jsonb, 'c', '« Étonné » suit le verbe d''état « rester » : attribut du sujet « tu » ✓. « Nouvelles » touche le nom « constructions » dans le GN : épithète ✓. Le piège courant est de croire qu''un adjectif en fin de phrase est forcément attribut : seul le verbe d''état décide.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('13d1a33a-de49-5219-904e-2ae08637ffe7', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : révision globale (type examen)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae87f18d-220c-5537-956a-698e0dfe1339', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Complète : « Samedi, nous ____ le marché hebdomadaire de Testour. » (faire)', '[{"id":"a","text":"fairons"},{"id":"b","text":"ferons"},{"id":"c","text":"feront"},{"id":"d","text":"faisons"}]'::jsonb, 'b', '« Faire » a le radical irrégulier fer- au futur : « nous ferons » ✓. « Fairons » construit le futur sur l''infinitif à tort, « feront » est la forme de « ils », et « faisons » est le présent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac44816f-5fdf-54e2-a440-3fc03b693b38', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Quel groupe nominal est correctement accordé ?', '[{"id":"a","text":"des maisons blanc"},{"id":"b","text":"des maisons blanche"},{"id":"c","text":"des maisons blanches"},{"id":"d","text":"des maisons blancs"}]'::jsonb, 'c', '« Maisons » est féminin pluriel : l''épithète prend le féminin (blanc → blanche) et le pluriel → « blanches » ✓. Les autres formes oublient le genre, le nombre, ou les deux.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2de7d039-07e6-538f-a33e-6f84e585739b', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Dans quelle phrase le verbe est-il au futur simple ?', '[{"id":"a","text":"On traversera le vieux pont."},{"id":"b","text":"On traverse le vieux pont."},{"id":"c","text":"On a traversé le vieux pont."},{"id":"d","text":"Traverse le vieux pont !"}]'::jsonb, 'a', '« Traversera » porte la terminaison -ra du futur simple ✓. « Traverse » est au présent, « a traversé » au passé composé, et « Traverse le vieux pont ! » est à l''impératif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c36a524-2eee-5c11-b4b9-8bbc33f00eda', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Dans la phrase « Ce vieux quartier paraît tranquille. », quelle analyse est correcte ?', '[{"id":"a","text":"« vieux » et « tranquille » sont tous les deux épithètes"},{"id":"b","text":"« vieux » est attribut et « tranquille » est épithète"},{"id":"c","text":"« vieux » et « tranquille » sont tous les deux attributs"},{"id":"d","text":"« vieux » est épithète et « tranquille » est attribut"}]'::jsonb, 'd', '« Vieux » touche le nom « quartier » dans le GN : épithète ✓. « Tranquille » suit le verbe d''état « paraître » : attribut du sujet ✓. Le piège courant est de donner le même rôle aux deux adjectifs alors que leur place dans la phrase diffère.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84b022ca-68f1-58e8-a7f8-0a24c6fa151e', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Un élève a écrit : « Dans dix ans, on construira des immeubles moderne et la ville s''étendra vers le nord. » Quelle erreur a-t-il commise ?', '[{"id":"a","text":"« on » devrait s''écrire « ont »"},{"id":"b","text":"« construira » devrait s''écrire « construiera »"},{"id":"c","text":"« moderne » devrait s''écrire « modernes »"},{"id":"d","text":"« s''étendra » devrait s''écrire « s''étendera »"}]'::jsonb, 'c', 'L''épithète s''accorde avec « des immeubles » (masculin pluriel) : « modernes » ✓ — c''est la seule erreur de la phrase. « On » est bien le pronom sujet, et « construira » comme « s''étendra » sont des futurs corrects ; les corrections (b) et (d) inventent des formes fautives.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cae155d-fb4e-55c2-97ae-b1816dd01893', '13d1a33a-de49-5219-904e-2ae08637ffe7', 'Complète : « Les habitants ____ planté des arbres, ____ la place du village ____ devenue magnifique. »', '[{"id":"a","text":"ont … et … est"},{"id":"b","text":"on … et … est"},{"id":"c","text":"ont … est … et"},{"id":"d","text":"on … est … es"}]'::jsonb, 'a', '« Les habitants ont planté » : verbe avoir, remplaçable par « avaient » ✓ ; « et » relie les deux phrases (« et puis ») ✓ ; « la place est devenue » : verbe être, remplaçable par « était » ✓. Le piège courant est d''écrire « on » après un sujet pluriel déjà exprimé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6092477c-5515-51e5-a5f5-a248e6c95610', '62bf9268-6f5a-5c32-bfb4-2b978eab18a7', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le maître descripteur (plafond du module)', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa2ac075-51a9-5308-94de-3a3b3fdd71c4', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Complète : « Quand la nuit ____ , le village entier ____ . » (tomber / se reposer)', '[{"id":"a","text":"tombera … reposera"},{"id":"b","text":"tombera … se reposera"},{"id":"c","text":"tombra … se reposera"},{"id":"d","text":"tombera … se reposeras"}]'::jsonb, 'b', '« Tomber » (régulier) → « tombera » ✓ ; « se reposer » (pronominal) garde son pronom « se » → « se reposera » ✓. Le piège courant est d''oublier le pronom (« reposera ») ; « tombra » supprime à tort une syllabe et « se reposeras » est la 2e personne.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22752aa8-e4c4-51a0-9a83-5b0383ad92e9', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Quelle phrase est correctement conjuguée au futur simple ?', '[{"id":"a","text":"L''été prochain, nous alleront au bord de la mer."},{"id":"b","text":"L''été prochain, nous allerons au bord de la mer."},{"id":"c","text":"L''été prochain, nous irons au bord de la mer."},{"id":"d","text":"L''été prochain, nous iront au bord de la mer."}]'::jsonb, 'c', '« Aller » a le radical irrégulier ir-, et « nous » prend la terminaison -rons → « nous irons » ✓. Les formes (a) et (b) régularisent le radical (« aller- »), et (d) emploie la terminaison de « ils » (-ront) avec le sujet « nous ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e01b412b-e688-5157-acc8-246187087418', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Dans la phrase « Les vieilles fermes semblent abandonnées mais restent solides. », comment analyser « vieilles », « abandonnées » et « solides » ?', '[{"id":"a","text":"« vieilles » est épithète ; « abandonnées » et « solides » sont attributs"},{"id":"b","text":"les trois adjectifs sont épithètes"},{"id":"c","text":"« vieilles » et « abandonnées » sont épithètes ; « solides » est attribut"},{"id":"d","text":"les trois adjectifs sont attributs"}]'::jsonb, 'a', '« Vieilles » touche le nom « fermes » dans le GN : épithète ✓. « Abandonnées » suit le verbe d''état « sembler » et « solides » suit le verbe d''état « rester » : ce sont deux attributs du sujet ✓. Le piège courant est de classer selon la place dans la phrase ; seul le verbe d''état crée l''attribut.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('188e13fb-3aff-52e0-8e9b-4c2ae0a534b8', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Complète : « À midi, les ruelles de la médina restent ____ et ____ . » (silencieux / désert)', '[{"id":"a","text":"silencieux et désert"},{"id":"b","text":"silencieuse et déserte"},{"id":"c","text":"silencieuses et désertes"},{"id":"d","text":"silencieuses et déserts"}]'::jsonb, 'c', '« Rester » est un verbe d''état : les deux adjectifs sont attributs du sujet « les ruelles » (féminin pluriel). « Silencieux » → « silencieuses » (finale -eux → -euse) et « désert » → « désertes » ✓. Le piège courant est d''oublier le genre (a), le nombre (b) ou d''accorder « désert » au masculin (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('840bd2ac-a0c6-55ae-bac9-f160a731e43f', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Complète : « ____ raconte que les artisans du souk ____ tant de talent que leur travail ____ admiré partout. »', '[{"id":"a","text":"Ont … on … est"},{"id":"b","text":"On … on … est"},{"id":"c","text":"On … ont … et"},{"id":"d","text":"On … ont … est"}]'::jsonb, 'd', '« On raconte » : pronom sujet, remplaçable par « il » ✓ ; « les artisans ont » : verbe avoir, remplaçable par « avaient » ✓ ; « leur travail est admiré » : verbe être, remplaçable par « était » ✓. Le piège courant est d''employer « ont » comme sujet (a) ou « on » pour un sujet pluriel (b), et d''écrire « et » là où il faut le verbe « est » (c).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b83906a1-4b2a-5f71-a270-a981f280bafb', '6092477c-5515-51e5-a5f5-a248e6c95610', 'Réécris au futur simple : « Le vieux quartier devient calme et les nouvelles avenues sont larges. »', '[{"id":"a","text":"Le vieux quartier devient calme et les nouvelles avenues seront larges."},{"id":"b","text":"Le vieux quartier deviendra calme et les nouvelles avenues seront larges."},{"id":"c","text":"Le vieux quartier deviendra calme et les nouvelles avenues sont larges."},{"id":"d","text":"Le vieux quartier devriendra calme et les nouvelles avenues seront larges."}]'::jsonb, 'b', '« Devenir » suit la famille de « venir » : radical viendr- → « deviendra » ✓ ; « être » → radical ser-, sujet pluriel → « seront » ✓ ; les épithètes « vieux » et « nouvelles » et l''attribut « larges » restent accordés. Le piège courant est de ne transformer qu''un seul verbe (a, c) ou de déformer le radical (« devriendra », d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eebf04d6-e0dc-5a33-ac63-3cb7959022d9', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', 'Test de compréhension ⭐ : les déterminants et l''expansion du GN', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd54cacd-dda0-5d36-9484-a40e93a10d4b', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', 'À quoi sert le déterminant placé devant un nom ?', '[{"id":"a","text":"Il remplace le nom pour éviter une répétition."},{"id":"b","text":"Il exprime l''action faite par le nom."},{"id":"c","text":"Il apporte des précisions sur le genre et le nombre du nom."},{"id":"d","text":"Il relie deux phrases entre elles."}]'::jsonb, 'c', 'Le déterminant marche devant le nom et indique son genre (masculin/féminin) et son nombre (singulier/pluriel) : un chameau, une gazelle, des moutons.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e027dce5-8bb6-51c1-a6cd-680f00e79f94', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', 'Dans la phrase « Sami emmène son chien au parc », le mot « au » est…', '[{"id":"a","text":"une préposition toute seule"},{"id":"b","text":"un article défini contracté (à + le)"},{"id":"c","text":"un article indéfini"},{"id":"d","text":"un déterminant démonstratif"}]'::jsonb, 'b', '« au » est la contraction obligatoire de « à + le » : on ne dit jamais « à le parc ». C''est un article défini contracté, comme aux, du et des.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6ba8295-b00d-5ae1-abea-2fa61ec84649', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', 'Complète : « La chatte surveille ___ chatons. »', '[{"id":"a","text":"ses"},{"id":"b","text":"sa"},{"id":"c","text":"son"},{"id":"d","text":"leur"}]'::jsonb, 'a', '« chatons » est un nom pluriel : le possessif doit être au pluriel → ses. « sa » et « son » s''emploient devant un nom singulier, et il n''y a qu''une seule chatte (pas de « leur »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d348c0e-a2c3-5dc1-b13b-10b5cb6fdc82', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', 'Dans le GN « le cheval de la ferme », l''expansion « de la ferme » est…', '[{"id":"a","text":"un adjectif épithète"},{"id":"b","text":"une proposition relative"},{"id":"c","text":"un complément circonstanciel de lieu"},{"id":"d","text":"un complément du nom"}]'::jsonb, 'd', 'Préposition (de) + nom (la ferme) placés après un nom : c''est un complément du nom. Il enrichit le nom « cheval », il ne complète pas la phrase entière comme un CC de lieu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3806971-21b2-561f-804e-d5165308c3c3', 'eebf04d6-e0dc-5a33-ac63-3cb7959022d9', 'Le complément circonstanciel de cause répond à quelle question ?', '[{"id":"a","text":"Quand ?"},{"id":"b","text":"Pourquoi ?"},{"id":"c","text":"Où ?"},{"id":"d","text":"Comment ?"}]'::jsonb, 'b', 'Le CC de cause donne la raison de l''action : il répond à « pourquoi ? ». Exemple : le chien aboie parce qu''un inconnu approche. « Quand ? » = temps, « Où ? » = lieu, « Comment ? » = manière.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('94a57c15-f021-5b59-801d-448e3fa987ac', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '⭐ Exercice : Le cortège du nom — premiers déterminants', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc3495fe-e2f9-5713-b0e4-620744b77007', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Dans la phrase « Ces gazelles bondissent dans la steppe », le mot « ces » est un déterminant…', '[{"id":"a","text":"démonstratif"},{"id":"b","text":"possessif"},{"id":"c","text":"exclamatif"},{"id":"d","text":"numéral"}]'::jsonb, 'a', '« ces » (ce, cet, cette, ces) montre, désigne les gazelles : c''est un déterminant démonstratif. Ne le confonds pas avec « ses », le possessif qui indique une appartenance.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d31a042e-0908-5ac1-9e55-c2bf28995262', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Parmi ces déterminants, lequel est un article indéfini ?', '[{"id":"a","text":"le"},{"id":"b","text":"cette"},{"id":"c","text":"une"},{"id":"d","text":"deux"}]'::jsonb, 'c', 'Les articles indéfinis sont un, une, des : ils désignent un être qu''on ne connaît pas encore (une cigogne parmi d''autres). « le » est un article défini, « cette » un démonstratif, « deux » un numéral.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('471310eb-8412-5ece-ad69-540af5c77865', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Complète : « Le fermier de Béja donne du foin ___ ânes. »', '[{"id":"a","text":"à les"},{"id":"b","text":"aux"},{"id":"c","text":"au"},{"id":"d","text":"à"}]'::jsonb, 'b', '« à + les » se contracte obligatoirement en « aux » : on donne du foin aux ânes. « à les ânes » n''existe pas en français, et « au » (à + le) ne convient pas devant un nom pluriel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2a9d46e-a70e-5942-9f25-19d0824a07d6', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Complète : « Les fourmis transportent ___ provisions vers la fourmilière. »', '[{"id":"a","text":"leur"},{"id":"b","text":"sa"},{"id":"c","text":"ses"},{"id":"d","text":"leurs"}]'::jsonb, 'd', 'Plusieurs fourmis (plusieurs possesseurs) et plusieurs provisions (nom pluriel) → leurs, avec un -s. « leur » s''écrit sans -s devant un nom singulier ; « sa » et « ses » renvoient à un seul possesseur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f13ccdf6-acb8-57d7-ba7b-778591223e0b', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Dans le GN « un rossignol qui chante », l''expansion « qui chante » est…', '[{"id":"a","text":"un adjectif épithète"},{"id":"b","text":"un complément du nom"},{"id":"c","text":"une proposition relative"},{"id":"d","text":"un déterminant indéfini"}]'::jsonb, 'c', '« qui » suivi d''un verbe conjugué (chante) introduit une proposition relative qui enrichit le nom « rossignol ». L''épithète serait un adjectif (un rossignol mélodieux), le complément du nom une préposition + nom (le rossignol du jardin).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c76b1b72-823b-583a-bc76-bc65c0f1ed59', '94a57c15-f021-5b59-801d-448e3fa987ac', 'Mets la phrase à la forme négative : « Ali a des tortues. »', '[{"id":"a","text":"Ali n''a pas de tortues."},{"id":"b","text":"Ali n''a pas des tortues."},{"id":"c","text":"Ali n''a pas les tortues."},{"id":"d","text":"Ali a pas de tortues."}]'::jsonb, 'a', 'À la forme négative, l''article « des » devient « de » : Ali n''a pas de tortues. « pas des tortues » garde « des » à tort, « les » change le sens, et la négation exige les deux mots ne… pas.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : Le dresseur des déterminants', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e71f5ca-7b79-5b7c-962e-a909e5653664', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Dans la phrase « Le chant des cigales berce l''oasis », quelle est la nature du mot « des » ?', '[{"id":"a","text":"article indéfini"},{"id":"b","text":"article défini contracté (de + les)"},{"id":"c","text":"préposition"},{"id":"d","text":"déterminant indéfini"}]'::jsonb, 'b', 'Astuce du singulier : « le chant des cigales » → « le chant de la cigale » ✓. « des » se remplace par « de la », c''est donc l''article défini contracté de + les. Le piège courant : croire que tout « des » est indéfini — l''indéfini se remplacerait par « une » (il entend des cigales → il entend une cigale).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14a6b34a-10d8-525e-91ee-e5b3013565d2', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Complète : « ___ autruche court plus vite qu''un cheval. »', '[{"id":"a","text":"Cet"},{"id":"b","text":"Ce"},{"id":"c","text":"Cette"},{"id":"d","text":"Ces"}]'::jsonb, 'c', '« autruche » est un nom féminin singulier → cette autruche. Le piège courant : employer « cet » parce que le nom commence par une voyelle ; mais « cet » est réservé aux noms masculins (cet oiseau, cet âne). Au féminin, on garde toujours « cette ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4feb1b1-1100-55ff-abd5-d131603596df', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Complète : « Voici le poisson ___ le pêcheur de Mahdia a attrapé. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"dont"}]'::jsonb, 'a', 'Le poisson est le complément d''objet direct du verbe attraper (le pêcheur a attrapé le poisson) → on emploie « que ». « qui » remplacerait le sujet (le pêcheur qui a attrapé…), « où » un lieu. « dont » ne convient pas ici : attraper se construit sans « de ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f99c5d2-54ac-5a16-9d27-65f0decd8f8f', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Remplace la proposition relative par un adjectif épithète de même sens : « un chien qui obéit ».', '[{"id":"a","text":"un chien obéi"},{"id":"b","text":"un chien qui est obéissant"},{"id":"c","text":"un chien d''obéissance"},{"id":"d","text":"un chien obéissant"}]'::jsonb, 'd', '« qui obéit » = « obéissant » : un chien obéissant ✓ — l''adjectif épithète remplace la relative sans changer le sens. Le piège courant : « un chien qui est obéissant » contient encore « qui » + verbe conjugué, c''est toujours une relative ; « obéi » est un participe passé au sens inverse (qu''on a obéi), et « d''obéissance » est un complément du nom, pas un adjectif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a136abb9-775a-5377-aaee-8a81bbb4fbdd', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Dans le GN « la jument blanche du haras qui galope près de l''oued », quel groupe est le complément du nom ?', '[{"id":"a","text":"blanche"},{"id":"b","text":"du haras"},{"id":"c","text":"qui galope près de l''oued"},{"id":"d","text":"près de l''oued"}]'::jsonb, 'b', '« du haras » = préposition contractée (de + le) + nom → complément du nom ✓. « blanche » est l''adjectif épithète, « qui galope près de l''oued » la proposition relative. Le piège courant : choisir « près de l''oued », qui se trouve à l''intérieur de la relative et ne complète pas le nom « jument ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd98a7b7-963c-5b43-ae77-2e6c8c237356', '0352b050-d3cf-55ac-a71e-9cfbf36cbcd2', 'Complète : « La cigogne blessée répare ___ aile avant la migration. »', '[{"id":"a","text":"sa"},{"id":"b","text":"ses"},{"id":"c","text":"son"},{"id":"d","text":"leur"}]'::jsonb, 'c', '« aile » est féminin singulier, mais il commence par une voyelle : « sa aile » est imprononçable, donc sa devient son → son aile ✓. Le piège courant : écrire « sa » parce que le nom est féminin — la règle de la voyelle l''emporte. « ses » exigerait un pluriel, « leur » plusieurs possesseurs.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d5976146-a3d2-5167-a77a-b28380569983', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '⭐⭐ Révision (type examen) : Conjugaison et cause au fil des bêtes', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9945cbd0-f927-5d91-b210-751653726523', 'd5976146-a3d2-5167-a77a-b28380569983', 'Écris le verbe « donner » à l''impératif, 2ᵉ personne du singulier : « ___ à boire au chaton ! »', '[{"id":"a","text":"Donnes"},{"id":"b","text":"Donne"},{"id":"c","text":"Donner"},{"id":"d","text":"Donnez"}]'::jsonb, 'b', 'À l''impératif, 2ᵉ personne du singulier, les verbes en -er ne prennent pas de -s : Donne ! Le sujet n''est pas exprimé. « Donnez » est la 2ᵉ personne du pluriel, « Donner » l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fbf95ec-ae24-56e0-81e9-44e3be054758', 'd5976146-a3d2-5167-a77a-b28380569983', 'Écris le verbe au futur simple : « Demain, nous ___ les agneaux de la ferme. » (nourrir)', '[{"id":"a","text":"nourrirons"},{"id":"b","text":"nourrissons"},{"id":"c","text":"nourrisserons"},{"id":"d","text":"nourrons"}]'::jsonb, 'a', 'Au futur, tous les verbes ont les mêmes terminaisons : -rai, -ras, -ra, -rons, -rez, -ront. On garde l''infinitif entier : nourrir + ons → nous nourrirons ✓. « nourrissons » est le présent, « nourrisserons » invente un radical, « nourrons » perd le -ir de l''infinitif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('322993ae-b799-5b64-832d-79304684c521', 'd5976146-a3d2-5167-a77a-b28380569983', 'Écris le participe passé qui convient : « Les hirondelles sont ___ au printemps. » (revenir)', '[{"id":"a","text":"revenu"},{"id":"b","text":"revenue"},{"id":"c","text":"revenus"},{"id":"d","text":"revenues"}]'::jsonb, 'd', 'Avec l''auxiliaire être, le participe passé s''accorde avec le sujet. « Les hirondelles » est féminin pluriel → revenues ✓ (e + s). « revenu » ne porte aucun accord, « revenue » oublie le pluriel, « revenus » oublie le féminin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f73c9d5a-b373-54d2-b0d2-bc389b6ab51d', 'd5976146-a3d2-5167-a77a-b28380569983', 'Quelle phrase contient un complément circonstanciel de cause ?', '[{"id":"a","text":"Le troupeau rentre à la tombée de la nuit."},{"id":"b","text":"Le troupeau rentre vers la bergerie."},{"id":"c","text":"Le troupeau rentre parce que l''orage menace."},{"id":"d","text":"Le troupeau rentre à pas lents."}]'::jsonb, 'c', '« parce que l''orage menace » répond à la question « pourquoi le troupeau rentre-t-il ? » : c''est la cause ✓. « à la tombée de la nuit » indique le temps, « vers la bergerie » le lieu, « à pas lents » la manière.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da41089a-e5db-5ccf-9945-5258baa62619', 'd5976146-a3d2-5167-a77a-b28380569983', 'Complète : « Chaque oiseau construit ___ nid au printemps. »', '[{"id":"a","text":"leur"},{"id":"b","text":"son"},{"id":"c","text":"leurs"},{"id":"d","text":"ces"}]'::jsonb, 'b', 'Après « chaque », on considère un seul possesseur à la fois : chaque oiseau construit son nid ✓ (nom masculin singulier). « leur » et « leurs » renverraient à des possesseurs pris ensemble, ce que « chaque » interdit.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1924254e-f7c2-51fb-ae21-9f0f96511f73', 'd5976146-a3d2-5167-a77a-b28380569983', 'Complète avec le déterminant exclamatif qui convient : « ___ magnifique paon se pavane dans le jardin ! »', '[{"id":"a","text":"Quel"},{"id":"b","text":"Quelle"},{"id":"c","text":"Quels"},{"id":"d","text":"Quelles"}]'::jsonb, 'a', 'Le déterminant exclamatif s''accorde avec le nom : « paon » est masculin singulier → Quel magnifique paon ! « Quelle » est féminin, « Quels » et « Quelles » sont des pluriels.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d5daaf72-f3c3-5d60-8ece-a798b0609650', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : L''escorte royale du GN', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('483e47a1-293a-56b2-ac17-7c45950b016d', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', 'Relie la phrase à son complément de cause : « La cigogne quitte le nord. Le froid arrive. »', '[{"id":"a","text":"La cigogne quitte le nord quand le froid arrive."},{"id":"b","text":"La cigogne quitte le nord où le froid arrive."},{"id":"c","text":"Le froid arrive parce que la cigogne quitte le nord."},{"id":"d","text":"La cigogne quitte le nord parce que le froid arrive."}]'::jsonb, 'd', 'La cause du départ est le froid : la cigogne quitte le nord parce que le froid arrive ✓ (réponse à « pourquoi ? »). Le piège courant : l''option qui renverse cause et conséquence — le départ de la cigogne ne fait pas arriver le froid. « quand » exprimerait le temps, « où » le lieu.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72d84cac-e653-583d-9e4f-d2f8a48c8b38', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', 'Réécris à l''impératif (2ᵉ personne du singulier) ET à la forme négative : « Tu donnes des graines aux poussins. »', '[{"id":"a","text":"Ne donne pas des graines aux poussins."},{"id":"b","text":"Ne donnes pas de graines aux poussins."},{"id":"c","text":"Ne donne pas de graines aux poussins."},{"id":"d","text":"Tu ne donnes pas de graines aux poussins."}]'::jsonb, 'c', 'Deux règles à la fois : impératif en -er sans -s (donne) et « des » qui devient « de » à la forme négative → Ne donne pas de graines ✓. Le piège courant : garder « des » après la négation. « donnes » garde un -s fautif, et la phrase avec « Tu » reste à l''indicatif, pas à l''impératif.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad0e242f-cc7d-5992-b5b8-49de736f6cb6', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', 'Chasse à l''erreur : quelle phrase contient une faute ?', '[{"id":"a","text":"Yasmine emmène son petit frère au parc des oiseaux."},{"id":"b","text":"Le gardien parle à les visiteurs du zoo de Tunis."},{"id":"c","text":"Les mouettes tournent autour du port de La Goulette."},{"id":"d","text":"Le dresseur donne des ordres aux fauves."}]'::jsonb, 'b', 'Ici la bonne réponse est la phrase fautive : « à les visiteurs » est incorrect, car « à + les » se contracte obligatoirement en « aux » → le gardien parle aux visiteurs ✓. Les trois autres phrases emploient correctement les contractés au, du, des et aux.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6a1a488-ad22-52d9-b56c-1bdf10ad09a8', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', '« Chaque soir, deux chacals rôdent autour de la bergerie. » Quelle analyse des déterminants est exacte ?', '[{"id":"a","text":"« chaque » est un déterminant indéfini et « deux » un déterminant numéral."},{"id":"b","text":"« chaque » est un article défini et « deux » un déterminant indéfini."},{"id":"c","text":"« chaque » est un déterminant démonstratif et « deux » un déterminant numéral."},{"id":"d","text":"« chaque » est un déterminant exclamatif et « deux » un article défini."}]'::jsonb, 'a', '« chaque » appartient à la série des déterminants indéfinis (chaque, quelques, plusieurs…) et « deux » indique un nombre précis : c''est un numéral ✓. Le piège courant : confondre l''indéfini « chaque » avec un démonstratif — il ne montre rien, il envisage les soirs un à un.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a64c0208-fd7c-521a-ab19-9d126b534163', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', 'Remplace le complément du nom par une proposition relative de même sens : « la tortue du désert ».', '[{"id":"a","text":"la tortue qui traverse le désert"},{"id":"b","text":"la tortue que vit dans le désert"},{"id":"c","text":"la tortue qui vit dans le désert"},{"id":"d","text":"la tortue qu''elle vit dans le désert"}]'::jsonb, 'c', '« du désert » signifie que la tortue y vit → la tortue qui vit dans le désert ✓ : « qui » remplace le sujet (la tortue vit). Le piège courant : employer « que » devant un verbe qui a déjà son sujet caché — « que vit » est fautif, tout comme « qu''elle vit » qui ajoute un pronom en trop. « qui traverse le désert » change le sens (passer ≠ habiter).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ff3b915-35fe-5223-8bbe-313a565b0ea7', 'd5daaf72-f3c3-5d60-8ece-a798b0609650', '« Le vétérinaire leur donne leurs vaccins. » Quelle est la nature de « leur » puis de « leurs » ?', '[{"id":"a","text":"Les deux sont des déterminants possessifs."},{"id":"b","text":"« leur » est un pronom personnel invariable, « leurs » un déterminant possessif."},{"id":"c","text":"« leur » est un déterminant possessif, « leurs » un pronom personnel."},{"id":"d","text":"Les deux sont des pronoms personnels."}]'::jsonb, 'b', '« leur » est placé devant le verbe donne : c''est le pronom personnel invariable (= à eux), qui ne prend jamais de -s. « leurs » est placé devant le nom vaccins : c''est le déterminant possessif, accordé au pluriel ✓. Le piège courant : accorder le pronom en écrivant « le vétérinaire leurs donne ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('79023057-04ee-5b2e-913f-6dcdd2bb8ede', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : La grande traversée du module (révision globale)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb09cda5-607a-5b06-8503-a65584eb1396', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'Dans la phrase « Plusieurs flamants roses hivernent sur le lac de Tunis », le mot « plusieurs » est…', '[{"id":"a","text":"un article indéfini"},{"id":"b","text":"un déterminant numéral"},{"id":"c","text":"un déterminant indéfini"},{"id":"d","text":"un déterminant démonstratif"}]'::jsonb, 'c', '« plusieurs » indique une quantité imprécise : c''est un déterminant indéfini, comme chaque et quelques ✓. Les articles indéfinis sont seulement un, une, des ; un numéral donnerait un nombre exact (deux, trois) ; un démonstratif montrerait (ces flamants).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c7a85ac-c542-5d37-8c07-ac1f33f2ea9c', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'Complète avec le déterminant exclamatif qui convient : « ___ étranges créatures peuplent les fonds marins ! »', '[{"id":"a","text":"Quelles"},{"id":"b","text":"Quels"},{"id":"c","text":"Quelle"},{"id":"d","text":"Quel"}]'::jsonb, 'a', '« créatures » est un nom féminin pluriel : le déterminant exclamatif s''accorde → Quelles étranges créatures ! ✓. « Quels » est masculin pluriel, « Quelle » féminin singulier, « Quel » masculin singulier.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbc3a5e2-51e0-55de-8b15-71e3b829128a', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'Complète : « La réserve d''Ichkeul est l''endroit ___ des milliers d''oiseaux passent l''hiver. »', '[{"id":"a","text":"que"},{"id":"b","text":"qui"},{"id":"c","text":"quand"},{"id":"d","text":"où"}]'::jsonb, 'd', '« l''endroit » désigne un lieu : la relative s''introduit par où → l''endroit où des milliers d''oiseaux passent l''hiver ✓. « qui » remplacerait le sujet, « que » le COD ; « quand » n''introduit pas une relative après un nom de lieu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78e56829-d7ff-5880-8ffb-553f924001f7', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', '« Le gardien observe les oiseaux migrateurs, les tortues du parc et les poissons qui remontent l''oued. » Quel GN étendu a pour expansion un complément du nom ?', '[{"id":"a","text":"les oiseaux migrateurs"},{"id":"b","text":"les tortues du parc"},{"id":"c","text":"les poissons qui remontent l''oued"},{"id":"d","text":"le gardien"}]'::jsonb, 'b', '« du parc » = préposition contractée (de + le) + nom → complément du nom ✓. « migrateurs » est un adjectif épithète, « qui remontent l''oued » une proposition relative, et « le gardien » est un GN minimal sans expansion. Le piège courant : confondre les trois types d''expansion — repère la construction, pas le sens.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5645a238-81c4-5c5f-977f-a945abd759c3', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'Écris le verbe au passé composé : « Les cigognes ___ sur le minaret de la mosquée. » (s''installer)', '[{"id":"a","text":"s''ont installées"},{"id":"b","text":"se sont installé"},{"id":"c","text":"se sont installées"},{"id":"d","text":"se sont installés"}]'::jsonb, 'c', 'Les verbes pronominaux se conjuguent avec être, et le participe passé s''accorde avec le sujet « les cigognes » (féminin pluriel) → se sont installées ✓. Le piège courant : employer avoir (« s''ont ») ou oublier l''accord (« installé », « installés » au masculin).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8b6d6a9-8db7-509c-820c-e197f4143257', '79023057-04ee-5b2e-913f-6dcdd2bb8ede', 'Complète : « Le troupeau a survécu à la sécheresse ___ barrage du village. »', '[{"id":"a","text":"à cause du"},{"id":"b","text":"grâce à le"},{"id":"c","text":"grâce le"},{"id":"d","text":"grâce au"}]'::jsonb, 'd', 'La cause est positive (le barrage a sauvé le troupeau) → grâce à, et « à + le » se contracte en au : grâce au barrage ✓. Le piège courant : « à cause du », réservé aux causes négatives ou fâcheuses. « grâce à le » oublie la contraction obligatoire et « grâce le » perd la préposition.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('df3d7fd8-5399-58f9-82ca-eeabb28f0505', '92637f9c-679a-5afc-bc18-78093aab3928', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : L''arène des maîtres du GN', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79b39e3d-c0a8-501b-8eda-93e107fc690d', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'Une seule de ces affirmations sur les déterminants est exacte. Laquelle ?', '[{"id":"a","text":"« des » est toujours un article indéfini."},{"id":"b","text":"« au » et « du » sont des articles définis contractés."},{"id":"c","text":"Devant un verbe, « leur » prend un -s quand il désigne plusieurs personnes."},{"id":"d","text":"« cette » s''emploie devant un nom masculin qui commence par une voyelle."}]'::jsonb, 'b', '« au » = à + le et « du » = de + le : ce sont bien les articles définis contractés ✓. « des » peut aussi être le contracté de + les (le cri des mouettes) ; devant un verbe, « leur » est un pronom invariable qui ne prend jamais de -s ; devant un masculin à voyelle, c''est « cet » qu''on emploie (cet oiseau), pas « cette ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c3ef56b-7eed-561a-9e7d-d2072d6fbc83', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'Remets la phrase à la forme affirmative : « Nous n''avons pas vu de gazelles dans la réserve. »', '[{"id":"a","text":"Nous avons vu des gazelles dans la réserve."},{"id":"b","text":"Nous avons vu de gazelles dans la réserve."},{"id":"c","text":"Nous avons vu les gazelles dans la réserve."},{"id":"d","text":"Nous avons vu aux gazelles dans la réserve."}]'::jsonb, 'a', 'À la forme négative, « des » devient « de » ; en repassant à l''affirmative, « de » redevient donc « des » → nous avons vu des gazelles ✓. Le piège courant : garder « de » hors de la négation, ce qui est incorrect. « les » désignerait des gazelles précises déjà connues, et « aux » n''a rien à faire après « voir ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b8c50d4-3a98-5a0b-8103-24b67d135cdf', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'Quel GN contient exactement DEUX expansions ?', '[{"id":"a","text":"un fennec agile"},{"id":"b","text":"le fennec qui creuse son terrier au crépuscule"},{"id":"c","text":"le fennec du désert"},{"id":"d","text":"le petit fennec du Sahara"}]'::jsonb, 'd', '« le petit fennec du Sahara » cumule un adjectif épithète (petit) et un complément du nom (du Sahara) : deux expansions ✓. Le piège courant : compter « son terrier » et « au crépuscule » comme des expansions du nom « fennec » — ils sont à l''intérieur de la relative « qui creuse… », qui ne forme qu''une seule expansion. Les options a et c n''en ont qu''une.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57389953-a54b-5043-8327-8ecc0a525bce', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'Chasse à l''erreur : quelle phrase contient une faute d''orthographe grammaticale ?', '[{"id":"a","text":"Les abeilles défendent leur reine."},{"id":"b","text":"Chaque lionne surveille ses petits."},{"id":"c","text":"Les chameliers leurs donnent de l''eau fraîche."},{"id":"d","text":"La jument protège son épaule blessée."}]'::jsonb, 'c', 'Ici la bonne réponse est la phrase fautive : devant le verbe « donnent », « leur » est un pronom personnel invariable → les chameliers leur donnent ✓, jamais « leurs ». Les autres phrases sont correctes : une seule reine partagée (leur reine), chaque → ses, et « son épaule » car le nom féminin commence par une voyelle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f028ed4d-d274-5657-a4f8-488953b2bc69', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', 'Dans quelle phrase la proposition relative est-elle construite correctement ?', '[{"id":"a","text":"Le documentaire que nous avons regardé montre des loups gris."},{"id":"b","text":"Le documentaire qui nous avons regardé montre des loups gris."},{"id":"c","text":"Les loups que hurlent la nuit effraient les bergers."},{"id":"d","text":"La forêt que vivent les loups est très dense."}]'::jsonb, 'a', '« que » remplace le COD : nous avons regardé le documentaire → le documentaire que nous avons regardé ✓. Le piège courant : intervertir qui et que — « qui » exige que la relative n''ait pas d''autre sujet (les loups qui hurlent), et un lieu s''introduit par « où » (la forêt où vivent les loups).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68fe6bb1-7aaa-58c0-9383-68c3c8c5b8d5', 'df3d7fd8-5399-58f9-82ca-eeabb28f0505', '« Ces jeunes flamants restent près de leur mère parce que les eaux du lac sont froides. » Quelle affirmation est exacte ?', '[{"id":"a","text":"« Ces » est un article défini."},{"id":"b","text":"« leur » devrait s''écrire « leurs »."},{"id":"c","text":"« du lac » est un complément du nom."},{"id":"d","text":"« parce que les eaux du lac sont froides » est un complément circonstanciel de temps."}]'::jsonb, 'c', '« du lac » = de + le + nom placé après « les eaux » : complément du nom ✓. « Ces » est un déterminant démonstratif, pas un article ; « leur » reste au singulier car les flamants partagent une seule mère ; et « parce que… » répond à « pourquoi ? » : c''est un CC de cause, pas de temps.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eac74520-052d-56bb-b51d-4097b3890bad', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d30414ef-01c6-547f-8902-b8c401b81871', 'eac74520-052d-56bb-b51d-4097b3890bad', 'Un article de journal rapporte avant tout :', '[{"id":"a","text":"une histoire imaginaire inventée par l''auteur"},{"id":"b","text":"le résumé d''un livre et l''avis du lecteur"},{"id":"c","text":"des faits réels et récents"},{"id":"d","text":"une conversation entre deux personnages"}]'::jsonb, 'c', 'L''article de journal rapporte des faits réels et récents : il répond aux questions qui ? quoi ? où ? quand ? pourquoi ?. Le résumé d''un livre avec l''avis du lecteur, c''est la fiche de lecture.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d09382b7-e66b-5af3-86bb-410f49a35f62', 'eac74520-052d-56bb-b51d-4097b3890bad', 'Au futur simple, quelles terminaisons sont communes à tous les verbes ?', '[{"id":"a","text":"-ai, -as, -a, -ons, -ez, -ont"},{"id":"b","text":"-rai, -ras, -ra, -rons, -rez, -ront"},{"id":"c","text":"-e, -es, -e, -ons, -ez, -ent"},{"id":"d","text":"-é, -i, -u, -is, -it"}]'::jsonb, 'b', 'Au futur simple, tous les verbes prennent les mêmes terminaisons : -rai, -ras, -ra, -rons, -rez, -ront. Les terminaisons en -é, -i, -u sont celles du participe passé, pas du futur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22846170-63a4-5d6d-bcd6-a3c19f2d6722', 'eac74520-052d-56bb-b51d-4097b3890bad', 'Dans la phrase « Avant l''aube, les pêcheurs quittent le port », quel groupe est le complément circonstanciel ?', '[{"id":"a","text":"les pêcheurs"},{"id":"b","text":"le port"},{"id":"c","text":"quittent"},{"id":"d","text":"Avant l''aube"}]'::jsonb, 'd', '« Avant l''aube » répond à la question « quand ? » : c''est un complément circonstanciel de temps, déplaçable et supprimable. « Le port » répond à « quittent quoi ? » : c''est le COD, pas un CC.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5feaebc-e0c8-500a-9642-e9cb2c683d3d', 'eac74520-052d-56bb-b51d-4097b3890bad', 'Pourquoi écrit-on « Sa leçon, elle l''a récitée » avec la terminaison -ée ?', '[{"id":"a","text":"Le COD « l'' » (= sa leçon) est placé avant le verbe, donc le participe s''accorde avec lui."},{"id":"b","text":"Avec l''auxiliaire avoir, le participe passé s''accorde toujours avec le sujet « elle »."},{"id":"c","text":"Avec l''auxiliaire avoir, le participe passé s''accorde toujours avec le COD, où qu''il soit."},{"id":"d","text":"Le participe passé avec avoir est toujours invariable : la phrase contient une erreur."}]'::jsonb, 'a', 'Avec avoir, le participe passé ne s''accorde jamais avec le sujet ; il s''accorde avec le COD seulement quand celui-ci est placé avant le verbe. Ici « l'' » reprend « sa leçon » (féminin singulier) et précède le verbe : récitée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3f0c5ef-a340-5f1a-93de-1b992dbaae81', 'eac74520-052d-56bb-b51d-4097b3890bad', 'Pour garder le son [ʒ] devant la lettre « o », comme dans « un plon…on », on écrit :', '[{"id":"a","text":"g seul : un plongon"},{"id":"b","text":"gu : un plonguon"},{"id":"c","text":"ge : un plongeon"},{"id":"d","text":"j : un plonjon"}]'::jsonb, 'c', 'Devant a, o, u, la lettre g se prononce [g]. Pour garder le son doux [ʒ], on intercale un e : un plongeon, nous nageons.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4510eebd-f090-515f-8e35-e02956565360', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '⭐ Exercice : premiers pas dans les secrets de la nature', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b18b27a-abc5-5d47-9394-1eb895d8dbe1', '4510eebd-f090-515f-8e35-e02956565360', 'Transforme au futur simple : « Le pêcheur observe la mer. »', '[{"id":"a","text":"Le pêcheur a observé la mer."},{"id":"b","text":"Le pêcheur observera la mer."},{"id":"c","text":"Le pêcheur observeras la mer."},{"id":"d","text":"Le pêcheur va observer la mer."}]'::jsonb, 'b', 'Au futur simple, « observer » à la 3e personne du singulier donne « observera » (terminaison -ra). « Va observer » est le futur proche, pas le futur simple, et « observeras » est la terminaison de « tu ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acc63222-2a38-55ea-ae27-71de59888967', '4510eebd-f090-515f-8e35-e02956565360', 'Transforme au passé composé : « Les barques sortent du port. »', '[{"id":"a","text":"Les barques ont sorti du port."},{"id":"b","text":"Les barques sont sortis du port."},{"id":"c","text":"Les barques sont sorties du port."},{"id":"d","text":"Les barques sortiront du port."}]'::jsonb, 'c', '« Sortir » est un verbe de mouvement : il se conjugue avec l''auxiliaire être, et le participe passé s''accorde avec le sujet « les barques » (féminin pluriel) : sorties.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acfdb743-d312-502f-b385-86a121074a42', '4510eebd-f090-515f-8e35-e02956565360', 'Complète par un complément circonstanciel de temps : « ___, les paysans commencent la moisson. »', '[{"id":"a","text":"Dès le lever du soleil"},{"id":"b","text":"Dans les champs"},{"id":"c","text":"Avec leurs machines"},{"id":"d","text":"À cause de la chaleur"}]'::jsonb, 'a', 'Le CC de temps répond à la question « quand ? » : « Dès le lever du soleil ». « Dans les champs » indique le lieu, « avec leurs machines » la manière et « à cause de la chaleur » la cause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a542e9fa-0dce-5bab-a824-8df62a577550', '4510eebd-f090-515f-8e35-e02956565360', 'Quel pronom personnel remplace le GN sujet dans « Les goélands survolent la falaise » ?', '[{"id":"a","text":"Il"},{"id":"b","text":"Elle"},{"id":"c","text":"Elles"},{"id":"d","text":"Ils"}]'::jsonb, 'd', '« Les goélands » est un GN masculin pluriel : le pronom sujet qui garde son genre et son nombre est « ils ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c2d5eef-0f59-5b52-ad85-fb48714e4b84', '4510eebd-f090-515f-8e35-e02956565360', 'Complète : « Cette plage, tu ___ découverte l''été dernier. »', '[{"id":"a","text":"la"},{"id":"b","text":"l''as"},{"id":"c","text":"l''a"},{"id":"d","text":"là"}]'::jsonb, 'b', 'On peut remplacer par « l''avais » : « tu l''avais découverte ». C''est donc le pronom l'' + le verbe avoir à la 2e personne : l''as. « L''a » correspond à il/elle, et « la » ne se remplace pas par « l''avais ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1db1308f-359f-5acf-a87a-377caa2929a6', '4510eebd-f090-515f-8e35-e02956565360', 'Quelle forme du verbe « nager » est correcte à la 1re personne du pluriel du présent ?', '[{"id":"a","text":"nous nagons"},{"id":"b","text":"nous najons"},{"id":"c","text":"nous nageons"},{"id":"d","text":"nous nagueons"}]'::jsonb, 'c', 'Devant « o », le g se prononcerait [g]. Pour garder le son doux [ʒ], on intercale un e : nous nageons.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0a7462f-75a6-5019-84c0-a8d242e4fa40', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : le gardien des quatre temps', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec756b09-75dc-5697-97e9-025a04f46d4b', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', 'Transforme à l''impératif, à la 2e personne du singulier : « Tu ranges tes filets avant la tempête. »', '[{"id":"a","text":"Ranges tes filets avant la tempête !"},{"id":"b","text":"Tu range tes filets avant la tempête !"},{"id":"c","text":"Rangez vos filets avant la tempête !"},{"id":"d","text":"Range tes filets avant la tempête !"}]'::jsonb, 'd', 'À l''impératif, le sujet n''est pas exprimé, et les verbes en -er ne prennent pas de -s à la 2e personne du singulier : « Range tes filets ! » ✓. Le piège courant : garder le -s du présent (« ranges ») ou passer à la 2e personne du pluriel (« rangez »).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5efec81-b1e7-5bf7-b8d5-4e09ec3c4b11', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', '« VIOLENTE TEMPÊTE SUR LE GOLFE — Des vents de 120 km/h ont frappé la côte hier soir. — Dès la tombée de la nuit, les habitants ont vu les vagues grossir… » Comment s''appelle le passage placé sous le titre, qui résume l''essentiel de l''information ?', '[{"id":"a","text":"le chapeau"},{"id":"b","text":"le sous-titre du livre"},{"id":"c","text":"le corps de l''article"},{"id":"d","text":"l''avis du lecteur"}]'::jsonb, 'a', 'Dans un article de journal, le petit texte placé sous le titre et qui résume l''information s''appelle le chapeau. Le corps de l''article développe ensuite les faits en détail ; l''avis du lecteur appartient à la fiche de lecture.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('540d1a9f-e2bb-5f12-8cf2-663c9d35a284', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', 'Quel GN sujet peut remplacer le pronom « Elles » dans « Elles se cachent sous les rochers » ?', '[{"id":"a","text":"Les poissons"},{"id":"b","text":"Les crevettes"},{"id":"c","text":"La crevette"},{"id":"d","text":"Le banc de poissons"}]'::jsonb, 'b', 'Le pronom « elles » est féminin pluriel : seul « les crevettes » garde le même genre et le même nombre. « Les poissons » est masculin pluriel (→ ils), « la crevette » est au singulier (→ elle) et « le banc de poissons » est masculin singulier (→ il).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('916f31cc-d845-58ce-ba40-dc510a837953', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', 'Complète : « Ces photos du volcan, le reporter ___ dans son article. »', '[{"id":"a","text":"les a publié"},{"id":"b","text":"les a publiés"},{"id":"c","text":"les a publiées"},{"id":"d","text":"l''a publiées"}]'::jsonb, 'c', 'Le COD « les » reprend « ces photos » (féminin pluriel) et il est placé avant le verbe : le participe s''accorde avec lui → publiées ✓. Le piège courant : oublier l''accord (« publié ») ou accorder au masculin (« publiés ») ; « l''a » est impossible, car le COD est pluriel.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('611e301f-a528-5da9-b4e1-83ba55cfd04a', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', 'Dans « Les habitants ont quitté le village avant l''aube par prudence », les groupes « avant l''aube » et « par prudence » sont des compléments circonstanciels de :', '[{"id":"a","text":"temps, puis cause"},{"id":"b","text":"lieu, puis cause"},{"id":"c","text":"temps, puis manière"},{"id":"d","text":"manière, puis lieu"}]'::jsonb, 'a', '« Avant l''aube » répond à « quand ? » : CC de temps ✓. « Par prudence » répond à « pourquoi ? » : CC de cause ✓. Attention : « le village » n''est pas un CC, c''est le COD (« quitté quoi ? »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5cd1dde7-b24c-5b39-a419-78cc4c5ff592', 'b0a7462f-75a6-5019-84c0-a8d242e4fa40', 'Transforme au passé composé : « La marée monte et recouvre les rochers. »', '[{"id":"a","text":"La marée a monté et a recouvert les rochers."},{"id":"b","text":"La marée est montée et est recouverte les rochers."},{"id":"c","text":"La marée est monté et a recouvert les rochers."},{"id":"d","text":"La marée est montée et a recouvert les rochers."}]'::jsonb, 'd', '« Monter » est un verbe de mouvement : auxiliaire être + accord avec le sujet « la marée » → est montée ✓. « Recouvrir » se conjugue avec avoir, et son COD « les rochers » est placé après le verbe → participe invariable : a recouvert ✓. Le piège courant : employer être partout ou oublier l''accord de « montée ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23ab3790-87e9-5b55-9d44-a23f995fd5ed', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '⭐⭐ Révision (type examen) : reviser les secrets de la nature', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1222319-3b4c-5d48-8142-82bfed4def53', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Complète : « Cette nouvelle, le journaliste ___ annoncée à la radio. »', '[{"id":"a","text":"là"},{"id":"b","text":"la"},{"id":"c","text":"l''as"},{"id":"d","text":"l''a"}]'::jsonb, 'd', 'On peut remplacer par « l''avait » : « le journaliste l''avait annoncée ». C''est donc le pronom l'' + le verbe avoir à la 3e personne (il/elle) : l''a. « L''as » correspond à « tu », et « la » ne se remplace pas par « l''avait ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('306138aa-f99d-59c0-b4c2-de0539df797a', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Transforme au futur simple : « Nous faisons un feu de camp. »', '[{"id":"a","text":"Nous avons fait un feu de camp."},{"id":"b","text":"Nous ferons un feu de camp."},{"id":"c","text":"Nous fairons un feu de camp."},{"id":"d","text":"Nous faisons un feu de camp."}]'::jsonb, 'b', 'Le verbe « faire » a un futur irrégulier : le radical est fer-, donc « nous ferons ». « Fairons » est une invention, « avons fait » est le passé composé et « faisons » reste au présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a15989e-fb4e-5a41-b414-a5eef29d395e', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Quel mot n''appartient **pas** au champ lexical de la mer ?', '[{"id":"a","text":"la marée"},{"id":"b","text":"l''écume"},{"id":"c","text":"la moisson"},{"id":"d","text":"le coquillage"}]'::jsonb, 'c', 'La marée, l''écume et le coquillage se rapportent à la mer. « La moisson » (la récolte des céréales) appartient au champ lexical de la campagne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08a43046-1b87-5bc0-999e-d71d4e89941b', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Quelle phrase est correctement écrite ?', '[{"id":"a","text":"Ses poèmes, elle les a récités."},{"id":"b","text":"Ses poèmes, elle les a récité."},{"id":"c","text":"Elle a récités ses poèmes."},{"id":"d","text":"Elle les a récité ses poèmes."}]'::jsonb, 'a', 'Avec avoir, le participe s''accorde avec le COD seulement s''il est placé avant le verbe. Ici « les » reprend « ses poèmes » (masculin pluriel) et précède le verbe : récités. Dans « elle a récité ses poèmes », le COD est après le verbe, donc pas d''accord.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a93529d3-34ba-54a8-a483-72f15e77b4c6', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Dans « Le sentier est boueux à cause de la pluie », le groupe « à cause de la pluie » est un complément circonstanciel de :', '[{"id":"a","text":"temps"},{"id":"b","text":"manière"},{"id":"c","text":"lieu"},{"id":"d","text":"cause"}]'::jsonb, 'd', '« À cause de la pluie » répond à la question « pourquoi ? » : c''est un complément circonstanciel de cause. « Quand ? » donnerait le temps, « où ? » le lieu et « comment ? » la manière.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6138f955-e2f5-5fe0-a04f-82d4c51be333', '23ab3790-87e9-5b55-9d44-a23f995fd5ed', 'Par quel pronom personnel sujet peut-on remplacer le groupe souligné : « La rivière serpente entre les collines. » ?', '[{"id":"a","text":"Il"},{"id":"b","text":"Elle"},{"id":"c","text":"Ils"},{"id":"d","text":"Elles"}]'::jsonb, 'b', '« La rivière » est un groupe nominal féminin singulier : le pronom sujet qui garde le même genre et le même nombre est « elle ». « Elle serpente entre les collines. »', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b5a78763-ef19-513a-b319-a730d21f9fc9', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le maître des transformations', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc5cbbfd-5de3-54d9-82e4-9715ebb55f71', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Ce document indique : « Titre : L''Île au trésor — Auteur : R. L. Stevenson — Personnages : Jim, Long John Silver — Mon avis : un roman d''aventures passionnant. » De quel type de document s''agit-il ?', '[{"id":"a","text":"un article de journal"},{"id":"b","text":"une fiche de lecture"},{"id":"c","text":"un conte merveilleux"},{"id":"d","text":"un dialogue de théâtre"}]'::jsonb, 'b', 'Le titre du livre, l''auteur, les personnages et surtout « mon avis » sont les rubriques d''une fiche de lecture. Un article de journal rapporterait des faits réels datés, avec un titre et un chapeau, sans avis personnel sur un livre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e3d6265-d782-5275-9ea0-02a7c5496202', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Dans « Le courant l''a entraînée vers le large », pourquoi écrit-on « l''a » ?', '[{"id":"a","text":"C''est l''article « la » collé au verbe."},{"id":"b","text":"C''est le pronom l'' + avoir à la 2e personne (tu) : on dirait « l''avais »."},{"id":"c","text":"C''est le pronom l'' + le verbe avoir (il/elle) : on peut dire « l''avait entraînée »."},{"id":"d","text":"Il faut plutôt écrire « la », car il n''y a pas de verbe avoir."}]'::jsonb, 'c', 'Le sujet est « le courant » (il), et on peut remplacer par « l''avait entraînée » : c''est donc le pronom l'' + le verbe avoir à la 3e personne → « l''a ». « L''as » irait avec « tu », et « la » ne contient pas le verbe avoir.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d00230b8-4baa-5bdc-bcad-80e180e10e80', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Transforme au passé composé : « Les randonneurs arrivent au sommet et admirent le paysage. »', '[{"id":"a","text":"Les randonneurs ont arrivé au sommet et ont admiré le paysage."},{"id":"b","text":"Les randonneurs sont arrivés au sommet et sont admirés le paysage."},{"id":"c","text":"Les randonneurs sont arrivé au sommet et ont admirés le paysage."},{"id":"d","text":"Les randonneurs sont arrivés au sommet et ont admiré le paysage."}]'::jsonb, 'd', '« Arriver » est un verbe de mouvement : auxiliaire être + accord avec le sujet (masculin pluriel) → « sont arrivés » ✓. « Admirer » se conjugue avec avoir, et son COD « le paysage » est après le verbe → participe invariable : « ont admiré » ✓. Le piège courant : employer être partout ou accorder « admiré » avec le sujet.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('870eb1e7-0b25-5091-8174-11a669161bc8', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Complète : « Ces coquillages, les enfants les ___ sur la plage. »', '[{"id":"a","text":"ont ramassé"},{"id":"b","text":"ont ramassés"},{"id":"c","text":"ont ramassées"},{"id":"d","text":"a ramassés"}]'::jsonb, 'b', 'Le sujet « les enfants » est pluriel → auxiliaire « ont ». Le COD « les » reprend « ces coquillages » (masculin pluriel) et il est placé avant le verbe → accord : ramassés ✓. Le piège courant : oublier l''accord (« ramassé ») ou accorder au féminin (« ramassées »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c51e04d-df99-5883-bfdf-d17e8e621aca', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Une seule de ces phrases respecte l''accord du participe passé. Laquelle ?', '[{"id":"a","text":"La lettre, il l''a écrite ce matin."},{"id":"b","text":"La lettre, il l''a écrit ce matin."},{"id":"c","text":"Il a écrite une longue lettre."},{"id":"d","text":"Elle a récités ses devoirs."}]'::jsonb, 'a', 'Dans (a), le COD « l'' » reprend « la lettre » (féminin singulier) et précède le verbe → accord : écrite ✓. (b) oublie cet accord. Dans (c) et (d), le COD est APRÈS le verbe (« une longue lettre », « ses devoirs ») : le participe reste invariable (a écrit, a récité).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9c9eade-20e9-59f7-88b6-2c738a7ad03b', 'b5a78763-ef19-513a-b319-a730d21f9fc9', 'Transforme au futur simple : « La nuit vient, les lucioles brillent et nous voyons mille lumières. »', '[{"id":"a","text":"La nuit viendra, les lucioles brilleront et nous verrons mille lumières."},{"id":"b","text":"La nuit viendra, les lucioles brillerons et nous verrons mille lumières."},{"id":"c","text":"La nuit vientra, les lucioles brilleront et nous voirons mille lumières."},{"id":"d","text":"La nuit viendra, les lucioles brilleront et nous voyerons mille lumières."}]'::jsonb, 'a', 'Trois radicaux à maîtriser : venir → viendr- (viendra), briller → briller- (brilleront, 3e pers. du pluriel), voir → verr- (verrons). Les pièges : « vientra » et « voirons/voyerons » (radicaux inventés) et « brillerons » (terminaison de « nous », pas de « ils »).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('939e571d-f249-5f7e-8f75-2131b01e73eb', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : l''épreuve des quatre temps (révision globale)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52df5b16-6e3b-528e-b4ef-435805ff69b2', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Transforme à l''impératif (1re personne du pluriel) : « Nous protégeons la nature. »', '[{"id":"a","text":"Protégeons la nature !"},{"id":"b","text":"Protégons la nature !"},{"id":"c","text":"Nous protégeons la nature !"},{"id":"d","text":"Protégez la nature !"}]'::jsonb, 'a', 'À l''impératif, le sujet n''est pas exprimé. On garde le e après le g pour conserver le son doux [ʒ] devant o → « Protégeons ». Le piège : « protégons » perdrait le son doux, « nous protégeons » garde le sujet et « protégez » passe à la 2e personne du pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b73fade8-ee79-5223-82d1-8989cf066ca2', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Dans « Le vieux pont enjambe la rivière avec élégance », le groupe « avec élégance » est un complément circonstanciel de :', '[{"id":"a","text":"temps"},{"id":"b","text":"lieu"},{"id":"c","text":"manière"},{"id":"d","text":"cause"}]'::jsonb, 'c', '« Avec élégance » répond à la question « comment ? » : c''est un complément circonstanciel de manière. « Quand ? » donnerait le temps, « où ? » le lieu et « pourquoi ? » la cause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('937afd0f-c2a0-5397-83f1-3c514f320ae8', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Quel mot appartient au champ lexical de la ville ?', '[{"id":"a","text":"le sillon"},{"id":"b","text":"la marée"},{"id":"c","text":"le trottoir"},{"id":"d","text":"le verger"}]'::jsonb, 'c', '« Le trottoir » se rapporte à la ville. « Le sillon » et « le verger » appartiennent au champ lexical de la campagne, et « la marée » à celui de la mer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd25ca23-092d-570b-a9f8-c1501461d4de', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Transforme au futur simple : « Le fleuve déborde et les champs sont sous l''eau. »', '[{"id":"a","text":"Le fleuve débordera et les champs seront sous l''eau."},{"id":"b","text":"Le fleuve débordera et les champs sont sous l''eau."},{"id":"c","text":"Le fleuve débordra et les champs seront sous l''eau."},{"id":"d","text":"Le fleuve va déborder et les champs vont être sous l''eau."}]'::jsonb, 'a', '« Déborder » suit le modèle régulier → « débordera » (à ne pas réduire en « débordra »). « Être » a un radical irrégulier → « seront ». Il faut transformer les deux verbes : garder « sont » (b) est incomplet, et « va déborder » (d) est du futur proche, pas du futur simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('696d0e27-8d14-54d7-9054-465265d599da', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Quelle phrase est correctement orthographiée ?', '[{"id":"a","text":"Le courant la emporté vers le large."},{"id":"b","text":"Le courant l''as emportée vers le large."},{"id":"c","text":"Tu la emporté trop loin."},{"id":"d","text":"Le courant l''a emportée vers le large."}]'::jsonb, 'd', '« Le courant l''a emportée » : l'' + avoir (il/elle, test « l''avait »), et le COD « l'' » (féminin singulier) est placé avant le verbe → accord : emportée ✓. « La emporté » oublie le verbe avoir et l''accord ; « l''as » irait avec « tu », mais le sujet est « le courant » (il).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76a15040-84a0-5d27-8960-669fea2d9553', '939e571d-f249-5f7e-8f75-2131b01e73eb', 'Dans laquelle de ces phrases le participe passé doit-il s''accorder ?', '[{"id":"a","text":"Le berger a gardé ses moutons."},{"id":"b","text":"Le berger les a gardés tout l''été."},{"id":"c","text":"Le berger a surveillé la colline."},{"id":"d","text":"Le berger a compté ses bêtes."}]'::jsonb, 'b', 'Avec avoir, le participe s''accorde uniquement quand le COD est placé avant le verbe. Seule la phrase (b) place le COD avant : « les » reprend « ses moutons » (masculin pluriel) → gardés. Dans (a), (c) et (d), le COD suit le verbe, donc le participe reste invariable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4265e26c-52f7-5421-9c00-5cccde6d08c7', '03ccc69a-68bb-564d-88d5-ac912d5d44b8', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le gardien suprême des secrets de la nature', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65f405bd-260d-5e76-a88e-d3aa964f8a75', '4265e26c-52f7-5421-9c00-5cccde6d08c7', '« INONDATIONS DANS LE SUD — Notre envoyé spécial, hier à Gabès. De fortes pluies ont coupé plusieurs routes. » Ce document est un article de journal parce qu''il :', '[{"id":"a","text":"présente l''auteur d''un roman et donne un avis de lecture."},{"id":"b","text":"rapporte des faits réels et récents, avec un titre et un lieu daté."},{"id":"c","text":"raconte une histoire imaginaire avec un roi et une fée."},{"id":"d","text":"donne la liste des personnages et le résumé d''un livre."}]'::jsonb, 'b', 'L''article rapporte des faits réels et récents (« hier à Gabès », des routes coupées) avec un titre accrocheur : ce sont les marques de l''article de journal. Les options (a) et (d) décrivent une fiche de lecture, et (c) un conte merveilleux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('603c7edf-e033-56c2-9c66-661ae74dae0c', '4265e26c-52f7-5421-9c00-5cccde6d08c7', 'Transforme au passé composé : « Le brouillard se lève et les oiseaux regagnent leur nid. »', '[{"id":"a","text":"Le brouillard s''est levé et les oiseaux ont regagné leur nid."},{"id":"b","text":"Le brouillard a levé et les oiseaux sont regagnés leur nid."},{"id":"c","text":"Le brouillard s''est levé et les oiseaux ont regagnés leur nid."},{"id":"d","text":"Le brouillard s''est levée et les oiseaux ont regagné leur nid."}]'::jsonb, 'a', '« Se lever » est pronominal → auxiliaire être + accord avec le sujet (masculin singulier) : « s''est levé » ✓. « Regagner » se conjugue avec avoir, et son COD « leur nid » est après le verbe → participe invariable : « ont regagné » ✓. Les pièges : « a levé » (mauvais auxiliaire), « ont regagnés » (accord interdit avec le sujet avec avoir), « s''est levée » (accord au féminin injustifié).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb1aa04f-7780-501f-8416-8dc0c615b542', '4265e26c-52f7-5421-9c00-5cccde6d08c7', 'Dans « Ces graines, le vent ___ dispersées partout », quelle forme convient ?', '[{"id":"a","text":"l''a dispersées"},{"id":"b","text":"les a dispersées"},{"id":"c","text":"les a dispersé"},{"id":"d","text":"l''as dispersées"}]'::jsonb, 'b', 'Le COD « ces graines » est féminin PLURIEL : il se reprend par « les » (et non « l'' », qui ne remplace qu''un singulier). Placé avant le verbe, il commande l''accord → « les a dispersées » ✓. « Dispersé » oublie l''accord et « l''as » irait avec « tu », pas avec « le vent ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ce3e9db-91ac-54bc-85a5-f2d7fc7df091', '4265e26c-52f7-5421-9c00-5cccde6d08c7', 'Ce texte est mis au passé composé. Une seule forme est **fausse**. Laquelle ? « Les nuages (1) sont arrivés, les rivières (2) ont grossi, les paysans (3) ont rentré la récolte et la pluie (4) a tombée. »', '[{"id":"a","text":"forme (1) : sont arrivés"},{"id":"b","text":"forme (2) : ont grossi"},{"id":"c","text":"forme (3) : ont rentré"},{"id":"d","text":"forme (4) : a tombée"}]'::jsonb, 'd', 'La forme (4) « a tombée » est fautive : « Tomber » est un verbe de mouvement : il se conjugue avec être → « la pluie est tombée », pas « a tombée ». Les autres sont correctes : « sont arrivés » (être + accord au masculin pluriel), « ont grossi » (avoir), « ont rentré » (rentrer avec le COD « la récolte » → avoir).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b328da5f-a697-5a65-a2d9-cbbb22192127', '4265e26c-52f7-5421-9c00-5cccde6d08c7', 'On lit : « Le pêcheur les a vendues au marché. » D''après l''accord du participe « vendues », que peut être le COD « les » ?', '[{"id":"a","text":"les poissons"},{"id":"b","text":"les crabes"},{"id":"c","text":"les sardines"},{"id":"d","text":"le thon"}]'::jsonb, 'c', 'Le participe « vendues » est au féminin pluriel : le COD antéposé « les » doit donc être féminin pluriel → « les sardines ». « Les poissons » et « les crabes » sont masculins (on écrirait « vendus ») et « le thon » est au singulier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba5edd2b-8681-51b5-a69b-7ef1c439bbba', '4265e26c-52f7-5421-9c00-5cccde6d08c7', 'Transforme au futur simple : « Nous allons à la mer, nous voyons les dauphins et nous faisons de belles photos. »', '[{"id":"a","text":"Nous irons à la mer, nous verrons les dauphins et nous ferons de belles photos."},{"id":"b","text":"Nous allerons à la mer, nous voirons les dauphins et nous faiserons de belles photos."},{"id":"c","text":"Nous irons à la mer, nous voyerons les dauphins et nous ferons de belles photos."},{"id":"d","text":"Nous irons à la mer, nous verrons les dauphins et nous faisons de belles photos."}]'::jsonb, 'a', 'Trois radicaux irréguliers au futur : aller → ir- (irons), voir → verr- (verrons), faire → fer- (ferons). Les pièges : les radicaux réguliers inventés (« allerons, voirons, voyerons, faiserons ») et l''oubli de transformer le dernier verbe (« faisons » reste au présent en d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8a171861-89da-5139-98cd-4efd5afd79e4', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c9df838-5704-5473-8721-4075efeaee7b', '8a171861-89da-5139-98cd-4efd5afd79e4', 'Une histoire où un ogre parle et où une fée transforme une citrouille en carrosse est :', '[{"id":"a","text":"un article de journal"},{"id":"b","text":"un récit réel"},{"id":"c","text":"un récit historique"},{"id":"d","text":"un récit imaginaire"}]'::jsonb, 'd', 'La magie et les personnages surnaturels (ogre, fée) sont inventés : rien n''est vérifiable. C''est un récit imaginaire, comme le conte merveilleux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e378087-4743-5e78-b7a3-1d687a578c92', '8a171861-89da-5139-98cd-4efd5afd79e4', 'Par quelle formule commence traditionnellement un conte merveilleux ?', '[{"id":"a","text":"« Il était une fois »"},{"id":"b","text":"« Ce matin-là »"},{"id":"c","text":"« D''après l''article »"},{"id":"d","text":"« Cher journal »"}]'::jsonb, 'a', 'Le conte merveilleux s''ouvre presque toujours par « Il était une fois », qui installe un temps et un lieu imaginaires.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b44214a-d193-5112-8f47-dbb108919280', '8a171861-89da-5139-98cd-4efd5afd79e4', 'Choisis la bonne graphie : « Le maître ___ interrogé sur sa leçon. »', '[{"id":"a","text":"là"},{"id":"b","text":"la"},{"id":"c","text":"l''a"},{"id":"d","text":"l''as"}]'::jsonb, 'c', 'On peut dire « le maître l''avait interrogé » : c''est donc le pronom « l'' » + l''auxiliaire avoir « a », suivi du participe passé « interrogé ». On écrit « l''a ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f2e8aaf-62c4-5d5a-85e0-1b715b1c048f', '8a171861-89da-5139-98cd-4efd5afd79e4', 'Remplace le groupe souligné par un pronom : « Le bûcheron aperçoit LE CHÂTEAU. »', '[{"id":"a","text":"Le bûcheron le aperçoit."},{"id":"b","text":"Le bûcheron l''aperçoit."},{"id":"c","text":"Le bûcheron lui aperçoit."},{"id":"d","text":"Le bûcheron y aperçoit."}]'::jsonb, 'b', '« Le château » est COD (aperçoit quoi ?), donc on le remplace par « le ». Devant la voyelle « a » d''aperçoit, « le » devient « l'' » : « Le bûcheron l''aperçoit. »', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50a68ca4-9490-5ca9-a0db-8dab42464677', '8a171861-89da-5139-98cd-4efd5afd79e4', 'Quel mot est un SYNONYME de « content » ?', '[{"id":"a","text":"heureux"},{"id":"b","text":"triste"},{"id":"c","text":"fatigué"},{"id":"d","text":"méchant"}]'::jsonb, 'a', 'Un synonyme est un mot de sens proche : « heureux » a le même sens que « content ». « triste » en est le contraire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4a439fe4-db3c-5564-917d-b3454827726e', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '⭐ Exercice : le conte, les pronoms et les mots', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81bbe89c-0086-5334-afcb-a0559de09181', '4a439fe4-db3c-5564-917d-b3454827726e', 'Lequel de ces personnages appartient typiquement au conte merveilleux ?', '[{"id":"a","text":"une fée"},{"id":"b","text":"un journaliste"},{"id":"c","text":"un médecin"},{"id":"d","text":"un boulanger"}]'::jsonb, 'a', 'La fée est un personnage type du conte merveilleux, comme le roi, la princesse ou l''ogre. Les autres appartiennent à la vie réelle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20675ea6-06f4-5144-89e3-32c87df1ea1a', '4a439fe4-db3c-5564-917d-b3454827726e', 'Le compte rendu d''un voyage scolaire réellement effectué est un récit :', '[{"id":"a","text":"imaginaire"},{"id":"b","text":"réel"},{"id":"c","text":"merveilleux"},{"id":"d","text":"fantastique"}]'::jsonb, 'b', 'Le voyage a vraiment eu lieu : les faits sont vécus et vérifiables. C''est donc un récit réel.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbd51191-9b0c-5f3f-8f3d-8296a0b0479c', '4a439fe4-db3c-5564-917d-b3454827726e', 'Par quel pronom peut-on remplacer le sujet « la princesse » : « La princesse ouvre la porte. » ?', '[{"id":"a","text":"il"},{"id":"b","text":"le"},{"id":"c","text":"elle"},{"id":"d","text":"lui"}]'::jsonb, 'c', '« La princesse » est le sujet, féminin singulier : on le remplace par le pronom sujet « elle ». On obtient « Elle ouvre la porte. »', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21232e26-73fb-518c-8a9e-492bb0db1fd7', '4a439fe4-db3c-5564-917d-b3454827726e', 'Remplace le groupe souligné : « L''ogre mange LA POMME. » → « L''ogre ___ mange. »', '[{"id":"a","text":"lui"},{"id":"b","text":"le"},{"id":"c","text":"leur"},{"id":"d","text":"la"}]'::jsonb, 'd', '« La pomme » est COD (mange quoi ?), féminin singulier : on le remplace par « la ». « L''ogre la mange. » (« lui » et « leur » seraient des COI.)', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d809cac4-6c9b-5ce0-9048-de2a5a968b85', '4a439fe4-db3c-5564-917d-b3454827726e', 'Quelle graphie convient : « Le prince ___ délivrée. » (il s''agit de la princesse) ?', '[{"id":"a","text":"l''a"},{"id":"b","text":"la"},{"id":"c","text":"l''as"},{"id":"d","text":"là"}]'::jsonb, 'a', 'On peut dire « le prince l''avait délivrée » : c''est le pronom « l'' » + l''auxiliaire avoir « a » + le participe passé « délivrée ». On écrit « l''a ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4c7cb29-b1d0-5593-91c0-39e2f8f9c8f8', '4a439fe4-db3c-5564-917d-b3454827726e', 'Quel mot est le CONTRAIRE de « rapide » ?', '[{"id":"a","text":"vif"},{"id":"b","text":"pressé"},{"id":"c","text":"lent"},{"id":"d","text":"prompt"}]'::jsonb, 'c', 'Un contraire a le sens opposé : « lent » s''oppose à « rapide ». « vif », « pressé » et « prompt » en sont au contraire des synonymes.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f7358b8f-72e5-5c0b-85d4-e9a98e97e390', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '⚔️ Boss du chapitre ⭐⭐⭐ : le gardien du conte', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48b34271-bef9-51d6-8d7c-ad66a8191f11', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Remplace le groupe souligné : « Le roi promet une récompense À SES CHEVALIERS. »', '[{"id":"a","text":"Le roi lui promet une récompense."},{"id":"b","text":"Le roi leur promet une récompense."},{"id":"c","text":"Le roi les promet une récompense."},{"id":"d","text":"Le roi y promet une récompense."}]'::jsonb, 'b', '« À ses chevaliers » est un COI (introduit par « à ») au pluriel : on le remplace par « leur ». « lui » serait un singulier ; « les » est un COD ; « y » ne remplace pas des personnes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92faf612-743d-566a-972c-c9ae3703d5ab', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Complète avec la forme correcte : « La lettre que le prince a ___ était magique. » (écrire)', '[{"id":"a","text":"écrit"},{"id":"b","text":"écrits"},{"id":"c","text":"écrite"},{"id":"d","text":"écrites"}]'::jsonb, 'c', 'Avec « avoir », le participe passé s''accorde avec le COD placé avant. Ici le COD est « que » = la lettre (féminin singulier), placé avant le verbe → « écrite ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4290a90f-892d-5788-be17-953b88832471', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Quelle phrase est correctement orthographiée ?', '[{"id":"a","text":"Elle la mangée hier soir."},{"id":"b","text":"Il l''a pose sur la table."},{"id":"c","text":"Tu la vu partir."},{"id":"d","text":"Le chasseur l''a poursuivie longtemps."}]'::jsonb, 'd', '« l''a poursuivie » = pronom « l'' » + auxiliaire « a » + participe passé accordé avec « l'' » (féminin). Erreurs des autres : « la mangée » → « l''a mangée » ; « l''a pose » → « la pose » (présent, pas de PP) ; « la vu » → « l''as vu » (avec « tu »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35dccd9c-d27d-5030-9c28-d9ccdcd580e4', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Dans un conte merveilleux, quel événement vient LOGIQUEMENT en premier ?', '[{"id":"a","text":"Il était une fois un pauvre bûcheron, seul au bord de la forêt."},{"id":"b","text":"Le héros combat l''ogre et le vainc."},{"id":"c","text":"Le bûcheron épouse la princesse et devient prince."},{"id":"d","text":"Un ogre affamé se met à rôder autour du village."}]'::jsonb, 'a', 'La partie qui présente le héros (« Il était une fois… ») ouvre le conte. Vient ensuite le problème (l''ogre), puis les épreuves, et enfin le dénouement heureux (le mariage).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4baee52-d104-5ae2-8cba-3a491e33aaee', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Dans « Le paysan retourne la terre avant de semer », le mot « terre » désigne :', '[{"id":"a","text":"la planète où nous vivons"},{"id":"b","text":"le sol que l''on cultive"},{"id":"c","text":"le monde entier"},{"id":"d","text":"un vaste domaine"}]'::jsonb, 'b', '« Terre » est un mot polysémique. Ici, le contexte (semer, paysan) montre qu''il s''agit du sol cultivé, et non de la planète ni du monde.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d07628b8-bfc7-5dad-bb93-a87011aaf2b2', 'f7358b8f-72e5-5c0b-85d4-e9a98e97e390', 'Quel mot remplace « demeure » sans changer le sens dans « Le roi habite une vaste demeure » ?', '[{"id":"a","text":"cabane"},{"id":"b","text":"chaumière"},{"id":"c","text":"habitation"},{"id":"d","text":"ruine"}]'::jsonb, 'c', '« Habitation » est le synonyme le plus fidèle de « demeure ». « cabane » et « chaumière » désignent de petites maisons modestes, et « ruine » un bâtiment détruit : le sens changerait.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9699d6df-83b7-558e-9e26-844a570dd7b1', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '⭐⭐ Révision (type examen) : réel, conte, pronoms et vocabulaire', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15fa535b-40ca-5cbb-a50d-3fc1e108d3e2', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Lequel de ces éléments montre qu''un récit est IMAGINAIRE ?', '[{"id":"a","text":"une date précise"},{"id":"b","text":"un fait vérifiable"},{"id":"c","text":"un objet magique qui exauce les vœux"},{"id":"d","text":"le nom d''une vraie ville"}]'::jsonb, 'c', 'Un objet magique relève du surnaturel : il est inventé. Dates, faits vérifiables et lieux véritables signalent au contraire un récit réel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16e83eef-5574-5d08-b193-3471eb0b408f', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Complète : « Marie récite sa poésie ; elle ___ apprise hier. »', '[{"id":"a","text":"l''a"},{"id":"b","text":"la"},{"id":"c","text":"l''as"},{"id":"d","text":"là"}]'::jsonb, 'a', 'On peut dire « elle l''avait apprise » : c''est « l'' » + auxiliaire « a » + participe passé « apprise ». On écrit « l''a » (« l''as » s''emploierait avec « tu »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e42aa4b5-15ea-5f71-bb81-d64a936de3b5', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Remplace le groupe souligné : « La fée observe LES ENFANTS. » → « La fée ___ observe. »', '[{"id":"a","text":"leur"},{"id":"b","text":"lui"},{"id":"c","text":"la"},{"id":"d","text":"les"}]'::jsonb, 'd', '« Les enfants » est COD (observe qui ?) au pluriel : on le remplace par « les ». « leur » et « lui » seraient des COI (avec « à »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0e2e557-4e51-57cf-83ce-da3a4e21cc07', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Remplace le groupe souligné : « Le prince parle À LA SORCIÈRE. » → « Le prince ___ parle. »', '[{"id":"a","text":"la"},{"id":"b","text":"lui"},{"id":"c","text":"le"},{"id":"d","text":"leur"}]'::jsonb, 'b', '« À la sorcière » est un COI (introduit par « à ») au singulier : on le remplace par « lui ». « leur » serait un pluriel ; « la » et « le » seraient des COD.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d104ec5c-81a6-5c63-866a-9522252c27e0', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Quel mot n''appartient **pas** à la famille de « dent » ?', '[{"id":"a","text":"dentiste"},{"id":"b","text":"dentaire"},{"id":"c","text":"dentier"},{"id":"d","text":"dindon"}]'::jsonb, 'd', 'Une famille de mots partage le même radical et un sens commun. « dentiste », « dentaire » et « dentier » tournent autour de « dent » ; « dindon » (un oiseau) n''a rien à voir malgré sa ressemblance sonore.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ce4818c-5da2-5ecc-83e3-4e402cec0459', '9699d6df-83b7-558e-9e26-844a570dd7b1', 'Quel est le contraire de « apparaître » ?', '[{"id":"a","text":"surgir"},{"id":"b","text":"disparaître"},{"id":"c","text":"paraître"},{"id":"d","text":"montrer"}]'::jsonb, 'b', '« disparaître » a le sens opposé d''« apparaître ». « surgir » et « paraître » en sont proches, et « montrer » n''exprime pas l''idée inverse.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le maître conteur', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b28b046c-9e7c-55de-aa73-46012f77537f', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Pronominalise les DEUX compléments : « Le magicien montre le grimoire au prince. »', '[{"id":"a","text":"Le magicien le lui montre."},{"id":"b","text":"Le magicien lui le montre."},{"id":"c","text":"Le magicien le leur montre."},{"id":"d","text":"Le magicien la lui montre."}]'::jsonb, 'a', '« le grimoire » est COD → « le » ; « au prince » est COI singulier → « lui ». Le COD se place AVANT le COI : « le lui montre ». Le piège courant : inverser en « lui le » (b) ; « leur » (c) serait un pluriel ; « la » (d) un féminin.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47114e41-7584-5d3a-abfa-9098c996f74d', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Dans laquelle de ces phrases le participe passé s''accorde-t-il ?', '[{"id":"a","text":"Elle a mangé les cerises."},{"id":"b","text":"Elle a mangé des cerises rouges."},{"id":"c","text":"Elle leur a donné des cerises."},{"id":"d","text":"Les cerises qu''elle a mangées étaient mûres."}]'::jsonb, 'd', 'Avec « avoir », on accorde seulement avec le COD placé AVANT. Seule la phrase d place le COD (« que » = les cerises) avant le verbe → « mangées ». Ailleurs le COD suit le verbe (a, b) ou il s''agit d''un COI (c, « leur »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('739966c5-4a74-52d9-8607-c5393ac34e28', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Dans quelle phrase le mot « pièce » a-t-il le même sens que dans « Il a rangé les meubles dans la pièce du fond » ?', '[{"id":"a","text":"Il a payé avec une pièce de deux dinars."},{"id":"b","text":"Cette pièce de théâtre m''a beaucoup fait rire."},{"id":"c","text":"Chaque pièce de la maison était bien décorée."},{"id":"d","text":"Il manque une pièce au moteur de la voiture."}]'::jsonb, 'c', 'Ici « pièce » = une salle de la maison. C''est le même sens en c. En a c''est une monnaie, en b une œuvre de théâtre, en d un élément mécanique : la polysémie change selon le contexte.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f6ec357-9895-5f8d-b9ee-089eea07a246', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Quelle phrase est ENTIÈREMENT correcte ?', '[{"id":"a","text":"La chanson que tu l''as écrite est belle."},{"id":"b","text":"La chanson que tu as écrite est là, sur le piano."},{"id":"c","text":"La chanson que tu as écrit est la, sur le piano."},{"id":"d","text":"La chanson que tu l''a écrite est là."}]'::jsonb, 'b', 'Le pronom relatif « que » suffit à reprendre le COD : ajouter « l'' » (a, d) est une faute de double reprise. Le PP « écrite » s''accorde avec « que » = la chanson (féminin). « là » (adverbe de lieu) s''écrit avec accent, ≠ « la » article (c).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea7a2fde-b348-52c5-bb4d-a71d8068eda2', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Quelle SUITE conclut le plus logiquement ce début : « Il était une fois un jeune berger que personne n''écoutait. Un jour, une vieille femme lui offrit une flûte magique… » ?', '[{"id":"a","text":"Grâce à la flûte, le berger charma le village entier et fut enfin écouté de tous."},{"id":"b","text":"Le berger vendit ses moutons au marché puis rentra tranquillement chez lui."},{"id":"c","text":"La vieille femme reprit aussitôt sa flûte et disparut sans un mot."},{"id":"d","text":"Le berger oublia la flûte au fond de son sac et rien ne changea jamais."}]'::jsonb, 'a', 'Une bonne fin de conte résout le problème posé (« personne ne l''écoutait ») en utilisant l''élément magique (la flûte). Seule la fin a fait cela. Les autres ignorent la flûte ou laissent le manque intact.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98b20a12-6500-5d37-9031-3aa4c2f9e5be', 'af8e959f-7e9b-59ad-a6e6-7b874ef59ddf', 'Complète au FUTUR en pronominalisant les compléments : « Demain, le prince (retrouver) sa bague et (rendre) sa bague à la fée. »', '[{"id":"a","text":"le prince retrouvera sa bague et la rendra à la fée."},{"id":"b","text":"le prince la retrouvera et lui la rendra."},{"id":"c","text":"le prince la retrouvera et la lui rendra."},{"id":"d","text":"le prince le retrouvera et la lui rendra."}]'::jsonb, 'c', 'Au futur : « retrouvera », « rendra ». « sa bague » (COD féminin) → « la » ; « à la fée » (COI) → « lui ». Le COD passe avant le COI : « la lui rendra ». Pièges : « lui la » (b, mauvais ordre), « le » (d, mauvais genre), a ne pronominalise pas tout.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ab3b6416-40dd-5100-9be3-7460d7b7a014', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '📝 Entraînement ⭐⭐⭐ : la grande révision du module', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1c259f5-5f26-5266-9b3f-5edca6b50520', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Parmi ces débuts, lequel annonce un récit RÉEL ?', '[{"id":"a","text":"Il était une fois un royaume caché sous la mer."},{"id":"b","text":"Un dragon crachant des flammes gardait la montagne."},{"id":"c","text":"Le 3 mars, notre classe a visité le musée national."},{"id":"d","text":"La fée agita sa baguette étoilée sur le berceau."}]'::jsonb, 'c', 'Une date précise et un fait vécu et vérifiable (une visite scolaire) signalent un récit réel. Les autres débuts contiennent du surnaturel : ils ouvrent un récit imaginaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('897236a1-b381-510a-bd50-5c0547a5490e', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Dans « Le roi leur pardonne », le mot « leur » est :', '[{"id":"a","text":"un pronom personnel COD"},{"id":"b","text":"un pronom personnel COI"},{"id":"c","text":"un déterminant possessif"},{"id":"d","text":"un pronom personnel sujet"}]'::jsonb, 'b', '« leur » remplace « à eux » (pardonne à qui ?) : c''est un pronom personnel COI. Ne le confonds pas avec le déterminant possessif « leur(s) », qui se place devant un nom (« leurs épées »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('886c2ba2-fb8e-5227-ab58-5d5ba1d26192', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Complète : « Les histoires que grand-mère nous a ___ étaient passionnantes. » (raconter)', '[{"id":"a","text":"raconté"},{"id":"b","text":"racontés"},{"id":"c","text":"racontée"},{"id":"d","text":"racontées"}]'::jsonb, 'd', 'Avec « avoir », le PP s''accorde avec le COD placé avant. Le COD est « que » = les histoires (féminin pluriel), placé avant le verbe → « racontées ». (« nous » est ici COI, il ne commande pas l''accord.)', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b49c70c0-c84b-57e0-b32e-78aa892ce1bd', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Complète : « Cette énigme, c''est toi qui ___ résolue ! »', '[{"id":"a","text":"l''as"},{"id":"b","text":"l''a"},{"id":"c","text":"la"},{"id":"d","text":"là"}]'::jsonb, 'a', 'Le sujet est « toi » (2ᵉ personne) : l''auxiliaire avoir se conjugue « as ». On écrit donc « l''as » (« l'' » + « as » + participe passé « résolue »). Avec « il/elle », on écrirait « l''a ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb7d8fb4-c3ab-5036-bab0-d19e074f1b75', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Quel mot n''est **pas** de la même famille que « terre » ?', '[{"id":"a","text":"terrestre"},{"id":"b","text":"atterrir"},{"id":"c","text":"terrible"},{"id":"d","text":"souterrain"}]'::jsonb, 'c', '« terrestre », « atterrir » et « souterrain » partagent le radical et le sens de « terre ». « terrible » vient de « terreur » : la ressemblance de forme ne suffit pas, il faut un sens commun.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c07d6adc-6118-5723-8c49-b0c8ce864198', 'ab3b6416-40dd-5100-9be3-7460d7b7a014', 'Quel verbe est le SYNONYME le plus proche de « contempler » dans « Le prince contemple le paysage » ?', '[{"id":"a","text":"admirer"},{"id":"b","text":"surveiller"},{"id":"c","text":"apercevoir"},{"id":"d","text":"chercher"}]'::jsonb, 'a', '« contempler », c''est regarder longuement avec admiration : « admirer » en est le synonyme le plus proche. « surveiller », « apercevoir » et « chercher » expriment d''autres façons de regarder.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('59ea5eca-ead3-56ef-9ded-bf8ad37e145d', '1f1455c2-953d-5b5e-a7ef-cad5e4f64395', 'french-7eme', '👑 Défi élite ⭐⭐⭐⭐ : le sacre du conteur', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('706a4da2-641f-5e28-b40f-fa60716aaf9f', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', 'Comment le groupe souligné reprend-il un nom déjà cité ? « Le vieux roi régnait sur un pays paisible. CE MONARQUE était aimé de tous. »', '[{"id":"a","text":"par un pronom personnel"},{"id":"b","text":"par un substitut lexical (un mot de sens proche)"},{"id":"c","text":"par un déterminant possessif"},{"id":"d","text":"par un complément de nom"}]'::jsonb, 'b', '« Ce monarque » reprend « le roi » par un autre mot de même sens : c''est un substitut lexical. Un substitut pronominal aurait donné « Il était aimé de tous ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86e364ed-30cf-5959-bf44-e7449dfd2277', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', 'Pronominalise les deux compléments : « L''enchanteur a rendu leurs pouvoirs aux fées. »', '[{"id":"a","text":"L''enchanteur les leur a rendu."},{"id":"b","text":"L''enchanteur leur les a rendus."},{"id":"c","text":"L''enchanteur les leur a rendus."},{"id":"d","text":"L''enchanteur la leur a rendus."}]'::jsonb, 'c', '« leurs pouvoirs » est COD (masculin pluriel) → « les » ; « aux fées » est COI pluriel → « leur ». Ordre : COD avant COI (« les leur »). Le COD « les » étant placé avant, le PP s''accorde → « rendus ». Piège : oublier l''accord (a) ou inverser l''ordre (b).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9cc1d7b-b38b-506a-88ca-c50532dd1cb5', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', 'Dans quelle phrase « vague » a-t-il le sens d''« imprécis, flou » ?', '[{"id":"a","text":"Une vague immense renversa la petite barque."},{"id":"b","text":"Une vague de froid s''abattit soudain sur le pays."},{"id":"c","text":"Il regardait les vagues se briser contre les rochers."},{"id":"d","text":"Il n''a donné qu''une réponse vague et peu claire."}]'::jsonb, 'd', '« vague » est polysémique. En d, il qualifie une réponse floue, imprécise (adjectif). En a et c, c''est la vague de la mer ; en b, une série soudaine (vague de froid).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aaffaad9-4805-5dab-bf2c-126b3cbfaea4', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', 'Un élève met ce récit au passé composé. Quelle est la SEULE version correcte ? Départ : « La princesse cueille les fleurs et les offre à sa mère. »', '[{"id":"a","text":"La princesse a cueilli les fleurs et les a offertes à sa mère."},{"id":"b","text":"La princesse a cueilli les fleurs et les a offert à sa mère."},{"id":"c","text":"La princesse a cueillies les fleurs et les a offertes à sa mère."},{"id":"d","text":"La princesse a cueilli les fleurs et leur a offertes à sa mère."}]'::jsonb, 'a', 'Dans « a cueilli les fleurs », le COD suit le verbe → pas d''accord (« cueilli »). Dans « les a offertes », le COD « les » est placé avant → accord (« offertes »). Erreurs : b oublie l''accord de « offert » ; c accorde « cueillies » à tort (COD après) ; d met « leur » (COI) au lieu du COD « les ». C''est le piège classique : on n''accorde qu''avec le COD placé AVANT.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13f29532-8155-55c2-8c93-0ef87817ae72', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', '« Il était une fois un roi si avare qu''il enfermait tout son or dans une tour. » Quelle SUITE respecte le mieux la logique du conte merveilleux ?', '[{"id":"a","text":"Le roi calcula ses impôts et augmenta encore les taxes du royaume."},{"id":"b","text":"Le roi ouvrit un compte à la grande banque de la capitale."},{"id":"c","text":"Le roi resta avare toute sa vie et il ne se passa jamais rien."},{"id":"d","text":"Un jour, une fée le transforma en statue d''or pour lui apprendre à partager."}]'::jsonb, 'd', 'Le conte merveilleux mêle intervention surnaturelle et leçon : la fée punit le défaut du roi (l''avarice) et l''oblige à changer. Les options a et b sont réalistes et sans magie ; l''option c ne raconte aucune histoire (rien ne se passe).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c19f4da-75ab-514b-b636-3d0099baae2b', '59ea5eca-ead3-56ef-9ded-bf8ad37e145d', 'Une seule de ces affirmations est EXACTE. Laquelle ?', '[{"id":"a","text":"Avec l''auxiliaire « avoir », le participe passé s''accorde toujours avec le sujet."},{"id":"b","text":"Dans « il l''a vue », « l''a » s''écrit « la » car il précède un verbe."},{"id":"c","text":"« lui » et « leur » remplacent un complément introduit par « à » (COI)."},{"id":"d","text":"Un conte merveilleux raconte uniquement des faits réels et vérifiables."}]'::jsonb, 'c', 'Seule l''affirmation c est vraie : « lui » (singulier) et « leur » (pluriel) reprennent un COI en « à ». a est faux (avec « avoir » on accorde avec le COD placé avant, jamais avec le sujet) ; b est faux (« l''a » = pronom + auxiliaire avoir + participe passé « vue ») ; d est faux (le conte merveilleux est un récit imaginaire).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

