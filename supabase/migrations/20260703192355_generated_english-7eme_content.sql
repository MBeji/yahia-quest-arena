-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: english-7eme (English)
-- Regenerate with: npm run content:build
-- Source of truth: content/english-7eme/
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
  ('english-7eme', 'English', 'Second year of English (7th year basic education, A2): five modules from Self to the wider world — functions, grammar in context, lexis and pronunciation', 'Agilite', 'subject-english', 'Globe', 5, 'en', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '7eme-base'))
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
      AND e.subject_id = 'english-7eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('255a513b-a502-578f-941a-5c33f67d2bc8', '980773bb-3f37-5bca-8ee9-308e68d88dfe', '494678cc-6ac1-5019-b498-9f288b87985e', 'a9259d15-ddd6-5e66-8649-bd7fbaffa2de', '7036d5ea-eeee-5f57-8522-51502bb8b126', 'e9088603-34a6-5f9c-8705-47fdc3bce329', 'b42c4a0c-27a0-5b7b-b9a2-e2b1333d69e9', '1a78e2af-0d07-50d7-a58a-aaf512bbe70f', 'de6e05dc-bd25-56b5-8e11-5371eb627ec7', '55a4cedd-45c8-5e56-aae8-18a70d341ca9', '51a97c24-897f-5293-b4be-6fbbce4c2c82', '1a323cb9-cef1-51a2-84c7-c7ee75b618b3', '4e007ec2-b53b-51a9-adf7-facd08755c61', 'c42e6adc-9741-54d3-8cab-725ede898c7d', '1b12d814-700a-58d3-b6d7-43ac8b2e839a', 'eb651788-f6e8-5ed1-a728-b808e38aa509', 'b1f1a07a-af97-5f36-8035-fde492a2ecfc', '374df004-cef5-5533-b973-5f3249fbe151', '8e83eaba-531c-5739-bcc0-585a0cfeb9a3', 'ceed5612-1b83-5cbc-b7db-e7ad62f9e9d5', '364e28ba-dc30-5057-93b8-ef890eabbf49', '9928a60e-c862-583c-9d77-c252588e709a', '590b0d3f-c72f-501a-a604-8e8ef03f2eac', 'ba4d912b-0eb9-5d25-9270-929a59b15cd4', '3395507b-3ea1-55ba-8be6-c127862f09d9', 'ae788721-920f-5806-b067-a96bfbf6e182', 'dc0f8914-184b-5539-8273-304e2c08450b', '68beac7e-420a-51b8-966a-96d9dea2c63b', 'e122c52b-323a-5e1c-b126-057822bfff39', 'ee5ff1bc-cc3a-5600-8c55-b0a2dc1f9a68', '84c0753d-0834-5041-9469-24cfa6516948', 'd9f6c86a-73ca-562c-8498-a655226df24c', 'c445ac50-a506-56d1-a691-52321d7ce614', 'dcf27452-5f2d-547a-8348-b503bc40a09d', 'a3fbf482-2688-5f21-a9f8-8ed72a96b960', 'fbaaee7a-3902-5856-b8b2-d296e2190903', 'c9818539-a38a-5537-a9ad-0c57ee7fd9bc', 'e88e470b-1a69-5ac6-a466-eebcff991a29', '3814e30c-4218-5844-98a0-8f6bfd367b50', 'b9f689d3-f3e5-5f00-b8bb-9d61ad622008', '60676487-3032-56ce-8114-f830aa944222', '81b14d79-efdb-5441-8e9a-e979a9357008', '576a29b2-564b-5994-a4e1-98b4cf6ed04e', '89d25b45-2bb2-5221-a83a-a615fdc04f9e', '90848a98-7501-536f-8965-959edba31f80', '9be93a32-dff7-5f6b-b7c8-5d33d5ff3deb', 'aa8658c4-9a22-51f9-8324-a6b6eda2669a', '4c7c5ee1-6624-5ba7-86d2-941ff0bd9bad', '117f6be2-b756-5d6d-b63a-aa05b9ece168', '13c396b6-beea-51b5-b2a2-d6eaa80201ae', 'f14ec5d8-18b7-52e6-ad4f-fca6b0301189', '3dee34da-5682-5669-8d81-9fb371f96302', '8fd052ae-b8db-51c0-a4d2-8bbc94f294f0', '79571eb5-2c8c-5b47-8367-c13d07b0daeb', 'cbcfc71e-ad5a-5296-90a1-40802450ecd7', 'f231ebe7-ca6d-55f5-bb51-ca7d10d11d5c', 'a80e9f50-bab7-5b5a-bad6-3542db05addd', '689458d1-f0a1-57b3-ba2b-523853791e4a', '87b06e1c-db7c-5d24-8a9c-9cc3ac88e0a1', '2bcc18e0-1791-58e2-bfc1-73b66a6d5b1f', 'de31de3c-c1a3-5ed0-87b6-4d5ba253bb58', 'e5ff7a28-2d64-5eeb-868e-dc4e1779ecb9', 'e6082c68-8c32-501d-b6c2-fad38505b8ab', 'a3522099-eb1b-5435-8bde-622eecc37437', '883d03fc-492f-593a-aff6-39c8c634100b', '5375129d-b664-5c6a-82c7-8feed93bf918', '0a703a5f-4d84-597f-b975-d142e853a87c', '04db1856-a05c-534c-a659-fd0c2be6ec66', '63a6c5f6-391f-5f6b-9161-725a59477e22', 'd5683040-9ec1-5e4f-90a2-8d86d4f46997', '75b86551-3bcd-5911-8730-e3f0db296156', '63fc993e-3057-5af9-914c-913b48c1372f', '144a4f24-250f-51c0-b2fe-e35902c28c39', 'ba0ed95a-8b52-5e94-b056-9663092f3bb5', 'a71f53c6-c1b7-50ab-bab0-2298e60fb0c3', '8c8c3669-798c-5f04-a772-d0f401e2259b', '9b548ac1-84d1-5538-b461-3e46ce91d9f3', '8646e145-fbf2-5588-8a07-822e2716e414', '7fdd3578-2089-5c01-a6ad-51937efa9b46', '3d45ad1a-7e39-5120-841d-488088750890', 'b9b261d1-a48f-5b86-a3e4-f1be08f04bd3', '2d0a4db3-aee9-58b4-8a4b-e22e8c76483f', 'f0364601-bdb2-56de-a9c7-3fc4c76e7335', 'c9f8d872-51c0-5275-95ee-1be82c3a9802', '49259319-3289-541e-a620-ac024422bde0', 'c429c8b8-45ae-580d-8a1c-d52dfd6b5b3d', '95e4c703-8011-5801-983f-c0b664a54707', '0c4b068b-0bcb-5048-9c7b-933945cef823', 'e56b5783-f4d9-5cef-9d8f-8366439e205c', '354cd450-ef55-54a5-804d-ea64eb272696', '7a8d3324-e0ed-5308-a9f1-55ffe64d81aa', '5a09cad6-c347-5663-82b1-1737f8480cb7', '2d846f6e-7060-54e6-a6ee-e8e8e6c411d3', '3939b95a-4b82-5b16-a25d-97386204cf65', 'f451e1b0-5d92-5c61-a614-1773d5805d88', '42ce5548-d525-5f69-aa01-cb35efb90d7f', '0a115bde-b18c-505a-9d71-aa928a18abe4', '06d7bbd9-4426-55b4-bcde-b4c52e4a445c', 'e90369a2-4a60-54b9-bc85-536198cb5d8b', '71f8c98a-873e-5435-8f43-99be02ee2f28', 'e90d66c9-c99d-5122-a49e-6d4de05e8a67', '97339513-bce3-5f70-a6a0-2a03da1cda76', 'f91a34fa-d076-5053-a31f-f3cb00554be6', '55d5bb1d-baa6-5276-9c31-90e850659ac5', '5e259439-48ac-58e1-b717-d875b4d6375b', 'd12d471d-9d7f-555d-98e4-e36e48155f6e', '3ea85799-73ad-55e1-b293-428f0105a1ad', 'f9efc740-5b72-5f7f-9e8c-9d5c3af62345', 'a87c4a70-2df9-5348-b75e-f3da80ef37d8', '0ef1c40e-3604-5ab0-ab69-2bb3cef21c73', 'a27e1e55-9b87-5d10-aedd-fef9266df704', 'cae52785-790e-5c2b-935a-11f9bb0b8931', 'bac32162-7022-5e58-85bd-56beb0841640', '428fc80c-2af7-579e-a615-5b6fb81eb4e9', '6d7b5021-350d-5cb2-97f2-e5fc2ff48b1f', 'a18f423b-5eb8-5501-866a-d749e012c6c3', 'c72fbdbe-ab31-59c5-854f-85d6d6ee3182', '3b1147bb-88c0-555d-bc96-538191baf969', 'f2a447cc-a83f-5101-896e-d652cf0471ea', 'e67e3f2d-c199-59d3-957b-665464d5e5b8', 'e9872abb-4daa-5cad-9fb2-12259282da60', '3b03f8fc-4161-5e82-8e5e-12af50d59e28', '4f31777a-83d2-531a-8da3-7868e104a981', '5b427aa2-15f7-5799-a231-4510424e0922', '5b666cff-c256-52be-974b-09c0bfdb06d2', 'ee33d38d-6bd6-59c3-9b50-7c52921c8e3f', '0bf7ba30-72d9-54fb-930b-2e1631ac82e6', 'b9411d40-73e5-575d-8ea6-5bf93e294824', '50a54102-b98b-53fc-8c5f-c4558debf6b3', 'f0c6ab19-630c-5dee-9e4d-aa32b19adfdc', '02a14766-8f1e-5cb6-9fd9-dce016077a09', 'b131bda6-b75c-5409-b76e-deb62286eca9', '277f89ae-d362-5c3b-914d-0fcfab2f231f', '7197ed3e-96f1-5b97-8a9e-6594f0a58455', 'bf8c05c4-b5fc-5d6e-a60b-fa1c4640df22', '087b77c0-b970-5fa6-b28c-c68ee6526a24', '23df7cb3-b7c1-568b-8d73-ad7a8675f0dd', '49d95a0a-30c4-5b9c-9080-4ed547b218f7', 'f8d665e0-e53b-5c7a-9e6c-9fe797ebd80b', 'a87c2e32-f4ae-5022-8a25-e5b71fca02b6', 'd1d40dc9-727c-53e8-8f68-b2f022033711', 'c6405f8b-587a-5ca7-8752-2e0ab24ff589', '2a9753b7-5cf8-5ae6-afd4-2793830dd426', '40abaa5b-b842-5ede-885f-a533efee0e61', '9ce3bc31-6775-50f1-be19-fddeb8b9a9f3', 'db211a94-7c24-5e2b-949a-9432ae6bad78', '42b6fef4-854e-53e6-bb5d-03f253f8efe9', 'c823025b-c29d-5424-b04b-317501927224', 'e261f3e4-7830-5332-b791-c83ffc088b12', '8bcece81-98c1-5069-8406-93b76eaa6473', '2730fe1f-a2e8-5349-8df4-398794fd0042', '2b8d4dd7-dbfc-56ad-aba9-0bb0070af96c', '5b68af97-c330-5a2e-9831-494c8a5fda7c', '9e6fc1c3-5176-5ecf-8741-62cbb2710dce', '61e8f0d4-75ff-59db-9a2c-b1e6b458dc93', '65348784-3957-5723-8823-7f55aadf1112', '9582c3cf-5090-5543-9eec-1ece90c489d6', '90cc0c3f-3fd7-52a0-8d0e-75f9613acf01', 'cb0807a7-c129-5644-9b4a-c18225eec25a', 'ddc22115-dd1f-58cd-b116-67d5001cb241', '9e45d0ec-056e-5891-82e2-f0fb2f780805', '39b5a840-7675-5cbd-a0fe-28513fabebbf', 'a8c4fd2a-6eb1-5ec8-8ac2-39243e726716', 'c87f73d3-8ece-5b44-a08f-8a21509f2bfe', '3b081fcb-75fa-56c4-ab70-28e66ee71e33', 'c712152c-00d5-5b55-aff6-f181d5d89db0', '43177917-3205-5218-b0a8-9ae16a896389', '8b1a2c8f-7f70-59af-90fc-a76982eb8abe', 'c94312dd-d592-5a3c-9767-173e5b2d75f1', '5ae1e042-1a7c-592c-9cc8-be276ff22b30', '3c11c863-75c1-5818-85b5-0a09c4ae712b', '59235613-8f8b-5e0c-ab56-3bde24dc5546', '08b9d361-8d34-5ee6-accf-8613a894bcf4', '320fabce-e8b8-5735-9cf6-324d57a7b43a', 'f9915754-ecff-5a21-9619-f2a84641bcf9', '9a85c266-689a-541e-8cfa-0675dbd8659f', '3159fbb9-f6cb-5863-9add-d0422a5b73d7', 'd516354e-e45f-5401-a131-5e818870a030', '7d62105d-3b4e-50f7-9153-bde3a662db51', '580b2f1d-249c-519e-976a-529e07a5805b', '2635b7fd-bcdb-5312-b7e4-21e55815c23c', '92eaca82-dcf5-55c9-9b2f-64086027d073', '8d001152-b414-5a71-8d9a-3dc8e99475c6', '888913fd-d0a1-5fed-b459-14e0ccd30205', '6181bd24-b8f9-59d3-bcc0-ae51c4e2d561', 'c9123d92-50a3-55d8-8493-55350f1235ee', '6fb61990-e093-51e1-98d0-c47e5d7958ac', 'c58eaddc-a84e-5ea6-8515-acbdae81c8d3', '663abd99-5d9e-53e8-b937-25d775ec6a13', '4f328c28-4726-5e67-afde-74d87c83f679', '73b908c5-63db-5c13-a522-461190f3abbf', '2dcd9834-7898-5498-bc1a-b95a19bd3e8f', '35fdcfa4-e3fb-58fa-8855-fc860b10f2cf', '247151d4-b620-5d60-bdf0-b448141f2d5a', '4a67404d-8529-55d8-a140-635073303b60', '8eb55e8e-6050-5c7f-b14b-4f1637ae0b01', '0f98381f-267a-5d91-a93c-8a8276b849bd', '062955de-b74e-5fb9-911e-ec5c7c3a380e', '7966420b-de42-52be-8a35-adfe6b2017a3', '86f165a6-3e68-5fa4-98a2-9aa1f53b685e', '913848d6-07e7-536e-8e45-9beaefdc0d37', '6f400d36-06ca-5c34-ae83-e475ccbf27ad', '53fc7d39-930f-56a2-8fb0-f3ff0ee58a8a', 'da2772ea-6174-52a1-9f4c-a3ad015901a0', '0d07e580-f1a1-5e1b-84d9-b16f13821d9a');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'english-7eme' AND source = 'admin' AND id NOT IN ('1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'c6af4185-1377-539c-a739-3d2a46319ebc', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'b1897c4b-d452-58ec-b21e-572213df0515', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'a2169252-3a38-5465-939b-956957c79a10', '50aaf125-34a2-5a10-974c-864ce623413f', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'c7b8334d-9545-5271-889a-1819cad03a16', '6fc2acf0-a631-5361-846f-1cd988167f04', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'c3def0e4-6783-5b62-981e-d0d502161dbe', '41638fc1-7038-5c31-913f-26c55119e3a6', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'dfce81bc-6849-54c7-9788-287e89910be7', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', '7107128a-b7a8-5a20-8fe3-fcee65e70224', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', '534974a1-eda7-5462-b54d-8ed48574bc03');
DELETE FROM public.questions WHERE exercise_id IN ('1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'c6af4185-1377-539c-a739-3d2a46319ebc', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'b1897c4b-d452-58ec-b21e-572213df0515', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'a2169252-3a38-5465-939b-956957c79a10', '50aaf125-34a2-5a10-974c-864ce623413f', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'c7b8334d-9545-5271-889a-1819cad03a16', '6fc2acf0-a631-5361-846f-1cd988167f04', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'c3def0e4-6783-5b62-981e-d0d502161dbe', '41638fc1-7038-5c31-913f-26c55119e3a6', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'dfce81bc-6849-54c7-9788-287e89910be7', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', '7107128a-b7a8-5a20-8fe3-fcee65e70224', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', '534974a1-eda7-5462-b54d-8ed48574bc03') AND id NOT IN ('255a513b-a502-578f-941a-5c33f67d2bc8', '980773bb-3f37-5bca-8ee9-308e68d88dfe', '494678cc-6ac1-5019-b498-9f288b87985e', 'a9259d15-ddd6-5e66-8649-bd7fbaffa2de', '7036d5ea-eeee-5f57-8522-51502bb8b126', 'e9088603-34a6-5f9c-8705-47fdc3bce329', 'b42c4a0c-27a0-5b7b-b9a2-e2b1333d69e9', '1a78e2af-0d07-50d7-a58a-aaf512bbe70f', 'de6e05dc-bd25-56b5-8e11-5371eb627ec7', '55a4cedd-45c8-5e56-aae8-18a70d341ca9', '51a97c24-897f-5293-b4be-6fbbce4c2c82', '1a323cb9-cef1-51a2-84c7-c7ee75b618b3', '4e007ec2-b53b-51a9-adf7-facd08755c61', 'c42e6adc-9741-54d3-8cab-725ede898c7d', '1b12d814-700a-58d3-b6d7-43ac8b2e839a', 'eb651788-f6e8-5ed1-a728-b808e38aa509', 'b1f1a07a-af97-5f36-8035-fde492a2ecfc', '374df004-cef5-5533-b973-5f3249fbe151', '8e83eaba-531c-5739-bcc0-585a0cfeb9a3', 'ceed5612-1b83-5cbc-b7db-e7ad62f9e9d5', '364e28ba-dc30-5057-93b8-ef890eabbf49', '9928a60e-c862-583c-9d77-c252588e709a', '590b0d3f-c72f-501a-a604-8e8ef03f2eac', 'ba4d912b-0eb9-5d25-9270-929a59b15cd4', '3395507b-3ea1-55ba-8be6-c127862f09d9', 'ae788721-920f-5806-b067-a96bfbf6e182', 'dc0f8914-184b-5539-8273-304e2c08450b', '68beac7e-420a-51b8-966a-96d9dea2c63b', 'e122c52b-323a-5e1c-b126-057822bfff39', 'ee5ff1bc-cc3a-5600-8c55-b0a2dc1f9a68', '84c0753d-0834-5041-9469-24cfa6516948', 'd9f6c86a-73ca-562c-8498-a655226df24c', 'c445ac50-a506-56d1-a691-52321d7ce614', 'dcf27452-5f2d-547a-8348-b503bc40a09d', 'a3fbf482-2688-5f21-a9f8-8ed72a96b960', 'fbaaee7a-3902-5856-b8b2-d296e2190903', 'c9818539-a38a-5537-a9ad-0c57ee7fd9bc', 'e88e470b-1a69-5ac6-a466-eebcff991a29', '3814e30c-4218-5844-98a0-8f6bfd367b50', 'b9f689d3-f3e5-5f00-b8bb-9d61ad622008', '60676487-3032-56ce-8114-f830aa944222', '81b14d79-efdb-5441-8e9a-e979a9357008', '576a29b2-564b-5994-a4e1-98b4cf6ed04e', '89d25b45-2bb2-5221-a83a-a615fdc04f9e', '90848a98-7501-536f-8965-959edba31f80', '9be93a32-dff7-5f6b-b7c8-5d33d5ff3deb', 'aa8658c4-9a22-51f9-8324-a6b6eda2669a', '4c7c5ee1-6624-5ba7-86d2-941ff0bd9bad', '117f6be2-b756-5d6d-b63a-aa05b9ece168', '13c396b6-beea-51b5-b2a2-d6eaa80201ae', 'f14ec5d8-18b7-52e6-ad4f-fca6b0301189', '3dee34da-5682-5669-8d81-9fb371f96302', '8fd052ae-b8db-51c0-a4d2-8bbc94f294f0', '79571eb5-2c8c-5b47-8367-c13d07b0daeb', 'cbcfc71e-ad5a-5296-90a1-40802450ecd7', 'f231ebe7-ca6d-55f5-bb51-ca7d10d11d5c', 'a80e9f50-bab7-5b5a-bad6-3542db05addd', '689458d1-f0a1-57b3-ba2b-523853791e4a', '87b06e1c-db7c-5d24-8a9c-9cc3ac88e0a1', '2bcc18e0-1791-58e2-bfc1-73b66a6d5b1f', 'de31de3c-c1a3-5ed0-87b6-4d5ba253bb58', 'e5ff7a28-2d64-5eeb-868e-dc4e1779ecb9', 'e6082c68-8c32-501d-b6c2-fad38505b8ab', 'a3522099-eb1b-5435-8bde-622eecc37437', '883d03fc-492f-593a-aff6-39c8c634100b', '5375129d-b664-5c6a-82c7-8feed93bf918', '0a703a5f-4d84-597f-b975-d142e853a87c', '04db1856-a05c-534c-a659-fd0c2be6ec66', '63a6c5f6-391f-5f6b-9161-725a59477e22', 'd5683040-9ec1-5e4f-90a2-8d86d4f46997', '75b86551-3bcd-5911-8730-e3f0db296156', '63fc993e-3057-5af9-914c-913b48c1372f', '144a4f24-250f-51c0-b2fe-e35902c28c39', 'ba0ed95a-8b52-5e94-b056-9663092f3bb5', 'a71f53c6-c1b7-50ab-bab0-2298e60fb0c3', '8c8c3669-798c-5f04-a772-d0f401e2259b', '9b548ac1-84d1-5538-b461-3e46ce91d9f3', '8646e145-fbf2-5588-8a07-822e2716e414', '7fdd3578-2089-5c01-a6ad-51937efa9b46', '3d45ad1a-7e39-5120-841d-488088750890', 'b9b261d1-a48f-5b86-a3e4-f1be08f04bd3', '2d0a4db3-aee9-58b4-8a4b-e22e8c76483f', 'f0364601-bdb2-56de-a9c7-3fc4c76e7335', 'c9f8d872-51c0-5275-95ee-1be82c3a9802', '49259319-3289-541e-a620-ac024422bde0', 'c429c8b8-45ae-580d-8a1c-d52dfd6b5b3d', '95e4c703-8011-5801-983f-c0b664a54707', '0c4b068b-0bcb-5048-9c7b-933945cef823', 'e56b5783-f4d9-5cef-9d8f-8366439e205c', '354cd450-ef55-54a5-804d-ea64eb272696', '7a8d3324-e0ed-5308-a9f1-55ffe64d81aa', '5a09cad6-c347-5663-82b1-1737f8480cb7', '2d846f6e-7060-54e6-a6ee-e8e8e6c411d3', '3939b95a-4b82-5b16-a25d-97386204cf65', 'f451e1b0-5d92-5c61-a614-1773d5805d88', '42ce5548-d525-5f69-aa01-cb35efb90d7f', '0a115bde-b18c-505a-9d71-aa928a18abe4', '06d7bbd9-4426-55b4-bcde-b4c52e4a445c', 'e90369a2-4a60-54b9-bc85-536198cb5d8b', '71f8c98a-873e-5435-8f43-99be02ee2f28', 'e90d66c9-c99d-5122-a49e-6d4de05e8a67', '97339513-bce3-5f70-a6a0-2a03da1cda76', 'f91a34fa-d076-5053-a31f-f3cb00554be6', '55d5bb1d-baa6-5276-9c31-90e850659ac5', '5e259439-48ac-58e1-b717-d875b4d6375b', 'd12d471d-9d7f-555d-98e4-e36e48155f6e', '3ea85799-73ad-55e1-b293-428f0105a1ad', 'f9efc740-5b72-5f7f-9e8c-9d5c3af62345', 'a87c4a70-2df9-5348-b75e-f3da80ef37d8', '0ef1c40e-3604-5ab0-ab69-2bb3cef21c73', 'a27e1e55-9b87-5d10-aedd-fef9266df704', 'cae52785-790e-5c2b-935a-11f9bb0b8931', 'bac32162-7022-5e58-85bd-56beb0841640', '428fc80c-2af7-579e-a615-5b6fb81eb4e9', '6d7b5021-350d-5cb2-97f2-e5fc2ff48b1f', 'a18f423b-5eb8-5501-866a-d749e012c6c3', 'c72fbdbe-ab31-59c5-854f-85d6d6ee3182', '3b1147bb-88c0-555d-bc96-538191baf969', 'f2a447cc-a83f-5101-896e-d652cf0471ea', 'e67e3f2d-c199-59d3-957b-665464d5e5b8', 'e9872abb-4daa-5cad-9fb2-12259282da60', '3b03f8fc-4161-5e82-8e5e-12af50d59e28', '4f31777a-83d2-531a-8da3-7868e104a981', '5b427aa2-15f7-5799-a231-4510424e0922', '5b666cff-c256-52be-974b-09c0bfdb06d2', 'ee33d38d-6bd6-59c3-9b50-7c52921c8e3f', '0bf7ba30-72d9-54fb-930b-2e1631ac82e6', 'b9411d40-73e5-575d-8ea6-5bf93e294824', '50a54102-b98b-53fc-8c5f-c4558debf6b3', 'f0c6ab19-630c-5dee-9e4d-aa32b19adfdc', '02a14766-8f1e-5cb6-9fd9-dce016077a09', 'b131bda6-b75c-5409-b76e-deb62286eca9', '277f89ae-d362-5c3b-914d-0fcfab2f231f', '7197ed3e-96f1-5b97-8a9e-6594f0a58455', 'bf8c05c4-b5fc-5d6e-a60b-fa1c4640df22', '087b77c0-b970-5fa6-b28c-c68ee6526a24', '23df7cb3-b7c1-568b-8d73-ad7a8675f0dd', '49d95a0a-30c4-5b9c-9080-4ed547b218f7', 'f8d665e0-e53b-5c7a-9e6c-9fe797ebd80b', 'a87c2e32-f4ae-5022-8a25-e5b71fca02b6', 'd1d40dc9-727c-53e8-8f68-b2f022033711', 'c6405f8b-587a-5ca7-8752-2e0ab24ff589', '2a9753b7-5cf8-5ae6-afd4-2793830dd426', '40abaa5b-b842-5ede-885f-a533efee0e61', '9ce3bc31-6775-50f1-be19-fddeb8b9a9f3', 'db211a94-7c24-5e2b-949a-9432ae6bad78', '42b6fef4-854e-53e6-bb5d-03f253f8efe9', 'c823025b-c29d-5424-b04b-317501927224', 'e261f3e4-7830-5332-b791-c83ffc088b12', '8bcece81-98c1-5069-8406-93b76eaa6473', '2730fe1f-a2e8-5349-8df4-398794fd0042', '2b8d4dd7-dbfc-56ad-aba9-0bb0070af96c', '5b68af97-c330-5a2e-9831-494c8a5fda7c', '9e6fc1c3-5176-5ecf-8741-62cbb2710dce', '61e8f0d4-75ff-59db-9a2c-b1e6b458dc93', '65348784-3957-5723-8823-7f55aadf1112', '9582c3cf-5090-5543-9eec-1ece90c489d6', '90cc0c3f-3fd7-52a0-8d0e-75f9613acf01', 'cb0807a7-c129-5644-9b4a-c18225eec25a', 'ddc22115-dd1f-58cd-b116-67d5001cb241', '9e45d0ec-056e-5891-82e2-f0fb2f780805', '39b5a840-7675-5cbd-a0fe-28513fabebbf', 'a8c4fd2a-6eb1-5ec8-8ac2-39243e726716', 'c87f73d3-8ece-5b44-a08f-8a21509f2bfe', '3b081fcb-75fa-56c4-ab70-28e66ee71e33', 'c712152c-00d5-5b55-aff6-f181d5d89db0', '43177917-3205-5218-b0a8-9ae16a896389', '8b1a2c8f-7f70-59af-90fc-a76982eb8abe', 'c94312dd-d592-5a3c-9767-173e5b2d75f1', '5ae1e042-1a7c-592c-9cc8-be276ff22b30', '3c11c863-75c1-5818-85b5-0a09c4ae712b', '59235613-8f8b-5e0c-ab56-3bde24dc5546', '08b9d361-8d34-5ee6-accf-8613a894bcf4', '320fabce-e8b8-5735-9cf6-324d57a7b43a', 'f9915754-ecff-5a21-9619-f2a84641bcf9', '9a85c266-689a-541e-8cfa-0675dbd8659f', '3159fbb9-f6cb-5863-9add-d0422a5b73d7', 'd516354e-e45f-5401-a131-5e818870a030', '7d62105d-3b4e-50f7-9153-bde3a662db51', '580b2f1d-249c-519e-976a-529e07a5805b', '2635b7fd-bcdb-5312-b7e4-21e55815c23c', '92eaca82-dcf5-55c9-9b2f-64086027d073', '8d001152-b414-5a71-8d9a-3dc8e99475c6', '888913fd-d0a1-5fed-b459-14e0ccd30205', '6181bd24-b8f9-59d3-bcc0-ae51c4e2d561', 'c9123d92-50a3-55d8-8493-55350f1235ee', '6fb61990-e093-51e1-98d0-c47e5d7958ac', 'c58eaddc-a84e-5ea6-8515-acbdae81c8d3', '663abd99-5d9e-53e8-b937-25d775ec6a13', '4f328c28-4726-5e67-afde-74d87c83f679', '73b908c5-63db-5c13-a522-461190f3abbf', '2dcd9834-7898-5498-bc1a-b95a19bd3e8f', '35fdcfa4-e3fb-58fa-8855-fc860b10f2cf', '247151d4-b620-5d60-bdf0-b448141f2d5a', '4a67404d-8529-55d8-a140-635073303b60', '8eb55e8e-6050-5c7f-b14b-4f1637ae0b01', '0f98381f-267a-5d91-a93c-8a8276b849bd', '062955de-b74e-5fb9-911e-ec5c7c3a380e', '7966420b-de42-52be-8a35-adfe6b2017a3', '86f165a6-3e68-5fa4-98a2-9aa1f53b685e', '913848d6-07e7-536e-8e45-9beaefdc0d37', '6f400d36-06ca-5c34-ae83-e475ccbf27ad', '53fc7d39-930f-56a2-8fb0-f3ff0ee58a8a', 'da2772ea-6174-52a1-9f4c-a3ad015901a0', '0d07e580-f1a1-5e1b-84d9-b16f13821d9a');
DELETE FROM public.chapters c WHERE c.subject_id = 'english-7eme' AND c.id NOT IN ('b7c95f45-e1ad-5792-9e93-13aa45797c40', '3a82c877-d63f-5a91-a131-5552717b5819', 'f5f4d771-26e7-5005-b86d-ca479aae4279', '4fd104d3-5147-508c-bca6-b95dedb00c27', '6da97736-31b8-59ec-a585-156756f4122c') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', 'All About Me', 'Module One — Self: greetings and introductions, family and possession with have got, ages and numbers, hobbies with like/love/enjoy, daily routines in the simple present with adverbs of frequency, telling the time and the prepositions at/in/on', '# ⚔️ All About Me — Your Hero Introduction

> 💡 "Every great adventure begins with three little words: **Hello, I am…**"

## 🏰 Greetings and introductions

You already know **Hello!** and **Hi!** from your first year of English. Now level up your first meeting:

- _"Hello, Salma! **How are you?**" — "**Fine, thanks. And you?**"_
- Introduce yourself: _**I am** Salma._ / _**My name is** Salma._
- Introduce others with a **demonstrative**: **this** for ONE person, **these** for TWO or more: _**This is** my friend Rania._ — _**These are** my parents._
- After a name, use a **subject pronoun**: **I, you, he** (a boy), **she** (a girl), **it** (a thing), **we, they**: _My father is a farmer. **He** works every day._ — _My parents are teachers. **They** work at my school._
- When a friend tells you good news, show **approval**: _"I have got a new bike!" — "**That''s great!**"_

## ⚡ The verb "to be" — who you are, how old you are

**To be** is your first weapon. Learn its three forms:

| Subject         | Affirmative  | Negative        | Question       |
| --------------- | ------------ | --------------- | -------------- |
| I               | I **am**     | I **am not**    | **Am** I…?     |
| he / she / it   | she **is**   | she **isn''t**   | **Is** she…?   |
| you / we / they | they **are** | they **aren''t** | **Are** they…? |

Two people together also take **are**: _Salma **and I are** good friends._ (Salma and I = **we**.)

Ask about **age** with **How old**: _**How old** are you? — I **am** twelve (12) years old._

> ⚠️ In English, age uses **to be**, never "have": say _I **am** twelve years old_ — NOT "I have twelve years".

Know your **numbers**: one, two… nine (9), twelve (12), thirteen (13), fourteen (14), twenty (20). _Salma is twelve; her brother Youssef is two years older — he is **fourteen**._

## 🛡️ "Have got" — your family and your things

Use **have got / has got** for **possession** — your family (**parents, grandparents, brother, sister, son, daughter, children**), pets and things:

| Subject             | Affirmative                  | Negative                     | Question               |
| ------------------- | ---------------------------- | ---------------------------- | ---------------------- |
| I / you / we / they | I **have got** a bike        | we **haven''t got** a car     | **Have** you **got**…? |
| he / she / it       | she **has got** two brothers | he **hasn''t got** a computer | **Has** she **got**…?  |

**Short answers** repeat the auxiliary: _Have you got any cousins? — **Yes, I have.** / **No, I haven''t.**_ — _Has he got a kite? — **Yes, he has.** / **No, he hasn''t.**_

Ask about **number** with **How many**: _**How many** brothers **has** Salma **got**? — Two._

> ⚠️ With he / she / it, always use **has**: _He **has got** a kite_ — NOT "He have got".

## 🔮 Hobbies — like, love, enjoy

Talk about your **hobbies** and **pastimes** with **like, love, enjoy**. After these verbs, an activity takes **-ing**:

- _I **love swimming**._ — _Meriem **enjoys cycling**._ — _We **like playing** football._
- Ask: _**What** are your hobbies? — My **favourite** hobby is swimming._

> 🗡️ Third person singular adds **-s**: _She **likes** football_ ✓ — "She like football" ✗.

## 🗺️ Daily routines — the simple present

Use the **simple present** for **daily routines**: _get up, wash, get dressed, have breakfast, have lunch, have dinner, watch TV, go to bed._

| Form        | Rule                                  | Example                                |
| ----------- | ------------------------------------- | -------------------------------------- |
| Affirmative | base verb; **-s / -es** for he/she/it | _Omar **gets** up at seven._           |
| Negative    | **don''t / doesn''t** + base verb       | _Youssef **doesn''t like** tea._        |
| Question    | **Do / Does** + subject + base verb   | _**What time does** Rania **get up**?_ |

Spelling of the third person: _watch → **watches**_, _wash → **washes**_, _go → **goes**_, _study → **studies**_.

> ⚠️ The **-s** is ONLY for **he / she / it**. Plural subjects keep the base form: _Her brothers **like** football_ — NOT "her brothers likes". And after **doesn''t**, the verb loses its -s: _she **doesn''t like**_ ✓, "doesn''t likes" ✗.

## ⏰ Adverbs of frequency

Adverbs of frequency say **how often** you do something:

| Adverb        | How often?             |
| ------------- | ---------------------- |
| **always**    | every time (100%)      |
| **usually**   | most times (about 80%) |
| **sometimes** | not often (about 40%)  |
| **never**     | not one time (0%)      |

**Position rule**: the adverb goes **before a main verb**, but **after the verb "to be"**:

- _Rania **always gets** up at six._ (before "gets") — _Youssef **is never** late for school._ (after "is")

> ⚠️ Never say "Rania gets always up" or "Youssef never is late" — learn the two positions by heart.

## 🕗 Telling the time — at, in, on — and linkers

Ask the time with **What time is it?** and read the clock like a pro:

- _8:00 → It''s eight **o''clock**._ — _8:30 → It''s **half past** eight._
- _7:15 → It''s **a quarter past** seven._ — _7:45 → It''s **a quarter to** eight._ (15 minutes before 8)
- _8:50 → It''s **ten to** nine._ (10 minutes before 9)

**Prepositions of time**: **at** + clock time (_at half past seven_, _at night_) · **in** + parts of the day (_in the morning, in the evening_) · **on** + days (_on Monday_). ⚠️ Say _**in** the morning_, never "at the morning".

**Linkers** join your ideas: **and** adds (_I like tea **and** milk_), **but** contrasts (_Salma loves swimming, **but** Youssef doesn''t like it_).

🎵 **Sound check** — train your ear:

| Sound | Words                                                                           |
| ----- | ------------------------------------------------------------------------------- |
| /ɑː/  | f**a**ther, p**ar**k, cl**a**ss                                                 |
| /ʌ/   | m**o**ther, br**o**ther, c**u**p, s**u**n                                       |
| /iː/  | m**ee**t, s**ee**, t**ea**                                                      |
| /tʃ/  | wa**tch**, **ch**ildren, **ch**eese — but s**ch**ool is /k/ and wa**sh** is /ʃ/ |
| /eɪ/  | n**a**me, pl**ay**, **eigh**t                                                   |

> 🏆 Gate one cleared, hero! You can now introduce yourself, your family and your day in English. Next stop: your **immediate world** — friends, home and a very special visitor.', '# 📜 Summary: All About Me

- **Greetings & introductions**: _How are you? — Fine, thanks._ · **This is** (one) / **These are** (2+) · subject pronouns I, you, he, she, it, we, they · approval: _That''s great!_
- **To be**: am / is / are (affirmative, negative, question) · age with **How old are you? — I am twelve years old** (never "I have twelve years") · numbers 1–20.
- **Have got** = possession: _she **has got** / we **haven''t got** / **Have** you **got**…?_ · short answers _Yes, I have. / No, he hasn''t._ · **How many** + has/have … got?
- **Hobbies**: like / love / enjoy + verb**-ing** (_I love swimming_) · _What are your hobbies?_ · she **likes** (-s for he/she/it).
- **Simple present** for routines: he/she/it adds **-s/-es** (watches, goes, studies) · negative **don''t/doesn''t** + base verb · question **Do/Does** + subject + base verb · plural subjects take NO -s.
- **Adverbs of frequency**: always (100%) → usually → sometimes → never (0%) · **before a main verb**, **after "to be"**.
- **Time & linkers**: half past / a quarter past / a quarter to / ten to · **at** + clock time, **in** + the morning/evening, **on** + days · **and** = addition, **but** = contrast · sounds /ɑː/ (father) vs /ʌ/ (mother), /iː/, /tʃ/ (watch — school is /k/), /eɪ/.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', 'My Immediate World', 'Module Two — Immediate environment: describing friends with adjectives of quality, describing places with where-questions and prepositions, possessive adjectives, yes/no questions, the present progressive for actions happening now, polite requests with can at the airport, greetings and taking leave, and invitations with would you like / what about at lunch time', '# ⚔️ My Immediate World — Friends, Home and a Special Visitor

> 💡 "A hero is never alone: good friends, a warm home and a kind welcome are the strongest power-ups."

## 🏰 My friends — describing people

In Module One you introduced people. Now describe them with **adjectives of quality**:

| Adjective       | It means…                  | Example                                                  |
| --------------- | -------------------------- | -------------------------------------------------------- |
| **friendly**    | nice and kind to people    | _Nour is very **friendly**; she smiles at everybody._    |
| **helpful**     | always ready to help       | _Sami is **helpful**; he carries his grandmother''s bag._ |
| **intelligent** | very good at understanding | _Rania is **intelligent**; she wins every school quiz._  |
| **funny**       | makes you laugh            | _Karim is **funny**; his stories make everybody laugh._  |
| **quiet**       | calm, not noisy            | _My cousin is **quiet**; he doesn''t talk a lot._         |

Ask a **yes/no question** with the verb **to be** first, and answer with a **short answer**:

- _**Is** your friend helpful? — **Yes, he is.** / **No, he isn''t.**_
- _**Are** your friends funny? — **Yes, they are.** / **No, they aren''t.**_

> 🗡️ A yes/no question starts with the verb (**Is / Are**), and the short answer repeats that same verb.

## 🗺️ Describing places — where?

Ask about a place with the WH-word **where**: _**Where** is your house? — It''s **in** Sousse, **near** the river._

**Prepositions of place** give the position: **in** + a town or a space (_in Sousse, in the garden_) · **near** = close to (_near the river_) · **at** + an exact point (_at the door, at the airport_) · **on** + a surface (_on the table_).

Useful place words: **house, street, garden, river, island**. An **island** is a piece of land with water all around it: _Djerba is a **lovely** island._ Places can be **beautiful, wonderful** or **quiet** too: _Our street is **quiet** and the **weather** is **wonderful**._

## 🛡️ Possessive adjectives — whose is it?

A **possessive adjective** goes before a noun and says who the thing belongs to:

| Subject | Possessive | Example                               |
| ------- | ---------- | ------------------------------------- |
| I       | **my**     | _**My** street is quiet._             |
| you     | **your**   | _Is this **your** bike?_              |
| he      | **his**    | _Karim loves **his** kite._           |
| she     | **her**    | _Salma is in **her** room._           |
| it      | **its**    | _The cat is drinking **its** milk._   |
| we      | **our**    | _We love **our** new house._          |
| they    | **their**  | _Tom and Lucy are in **their** room._ |

> ⚠️ **His** is for a boy, **her** is for a girl — don''t swap them. And **its** (no apostrophe) shows possession; **it''s** (with an apostrophe) means "it is".

## ⚡ What''s happening? — the present progressive

For an action happening **now**, use the **present progressive**: **am / is / are + verb-ing**.

| Subject         | Affirmative          | Negative                | Question                   |
| --------------- | -------------------- | ----------------------- | -------------------------- |
| I               | I **am cooking**     | I **am not cooking**    | **Am** I **cooking**…?     |
| he / she / it   | she **is cleaning**  | she **isn''t cleaning**  | **Is** she **cleaning**…?  |
| you / we / they | they **are playing** | they **aren''t playing** | **Are** they **playing**…? |

Spelling of **-ing**: _make → **making**_ (drop the -e) · _sit → **sitting**_, _swim → **swimming**_ (double the last letter) · _play → **playing**_, _clean → **cleaning**_ (just add -ing).

Signal words: **now, today, at the moment, Look!, Listen!** — _**Listen!** The birds **are singing**._ — _Everybody is **busy** today: Dad **is cleaning** the **garage**, Salma **is tidying up** her room and Mum **is preparing** lunch._

Ask questions and give short answers: _**What is** Mum **doing**? — She **is preparing** dinner._ — _**Is** Lina **helping**? — **Yes, she is.** / **No, she isn''t.**_

> ⚠️ Two classic mistakes: don''t forget **be** ("She cooking" ✗ → She **is** cooking ✓), and don''t forget **-ing** ("She is cook" ✗ → She is cook**ing** ✓).

> ⚠️ Habit or now? The simple present is for habits (**every day, usually**); the progressive is for **now / today**: _Nour usually **drinks** milk, but today she **is drinking** orange juice._

## 🔮 Welcome to Tunisia! — at the airport

Big news: Tom and his sister Lucy, Salma''s pen-friends from London, **arrive** today! Their **plane** lands at the **airport**: they show their **passports** to the **policeman**, pass through **customs**, put their **luggage** (a heavy **suitcase**!) on a **trolley**, cross the **lounge** and take a **taxi**.

Make **polite requests** with **can … please**: _**Can** I see your passport, **please**?_ — _**Can** you help me with my luggage, **please**?_ A request without "please", like "Give me your passport.", sounds rude.

**Greet** your guests: _**Welcome to Tunisia!** — Thank you!_ When someone leaves, **take leave**: _**Good-bye! See you soon!**_

## 🧪 Time for lunch — inviting your guest

At the Trabelsi house, lunch is ready: **fish, chips, soup, rice, omelette, vegetables, fruit, dates, roast chicken** and couscous, a **traditional** Tunisian **dish**.

- **Invite / offer**: _**Would you like** some soup?_ · _**What about** some grilled fish?_
- **Accept**: _**Yes, please.**_ / _**Yes, with pleasure!**_ — **Decline politely**: _**No, thank you.** I''m full._ / _**I''m sorry, I can''t.**_
- **Express appreciation**: _Mmm! It **smells delicious**!_ — verbs like **smell, like, love** stay in the simple present, even now (never "it is smelling").
- **Thank** your host: _Thank you for this delicious lunch! — **You''re welcome.**_

> 🗡️ Remember from Module One: after **like / love / enjoy**, the activity takes **-ing**: _Lucy **loves swimming**._

🎵 **Sound check** — train your ear:

| Sound      | Words                                                      |
| ---------- | ---------------------------------------------------------- |
| /aɪ/       | n**i**ce, qu**i**et, **i**sland, inv**i**te                |
| /əʊ/       | h**o**me, g**o**, n**o**, b**oa**t                         |
| /eə/       | wh**ere**, th**eir**, **air**port                          |
| /θ/        | **th**ank you, **th**ree, **th**ing                        |
| silent ''b'' | lam**b**, clim**b**, com**b** — the b is written, not said |

> 🏆 Gate two cleared, hero! You can describe your friends and your street, say what is happening right now, welcome a visitor politely and invite them to lunch. Next stop: Module Three — the house, the farm and market day!', '# 📜 Summary: My Immediate World

- **Describing friends**: adjectives of quality — friendly, helpful, intelligent, funny, quiet · yes/no questions with "to be": _Is he helpful? — Yes, he is. / No, he isn''t._
- **Describing places**: **Where** is…? · **in** (a town/space), **near** (close to), **at** (an exact point), **on** (a surface) · an **island** = land with water all around it · street, river, garden, lovely, wonderful.
- **Possessive adjectives**: my, your, **his** (boy), **her** (girl), **its** (no apostrophe — "it''s" = it is), our, their.
- **Present progressive** = happening now: **am/is/are + verb-ing** · spelling: making (drop -e), sitting/swimming (double letter) · negative: isn''t/aren''t + -ing · question: Is/Are + subject + -ing, short answers _Yes, she is._ · signals: now, today, Look!, Listen! · habit = simple present, now = progressive.
- **At the airport**: polite requests — **Can I / Can you … please?** · greeting a guest: _Welcome to Tunisia!_ · taking leave: _Good-bye! See you soon!_ · plane, passport, customs, luggage, suitcase, trolley, lounge, taxi.
- **Time for lunch**: invite with **Would you like…? / What about…?** · accept: _Yes, please. / With pleasure!_ · decline politely: _No, thank you. / I''m sorry, I can''t._ · appreciation: _It **smells** delicious!_ (simple present) · _Thank you → You''re welcome._
- **Sounds**: /aɪ/ (nice, island), /əʊ/ (home, go), /eə/ (where, airport), /θ/ (thank), silent ''b'' (lamb, climb).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', 'Home, Farm and Market', 'Module Three — home, farm and market: describing the home with there is / there are and prepositions of location, asking What''s it like?, subject and object pronouns, articles a/an/the, the genitive (''s), regular and irregular plurals, linkers (and, but, because, then), likes and dislikes about fruits and vegetables, clothes and shops, birthday parties, colours, time and age', '# ⚔️ Home, Farm and Market — Your World in English

> 💡 "A hero must know their home before they conquer the world: **There is** a door — open it!"

## 🏰 There is / There are — describing your home

When you say what a place **contains**, use **there is** or **there are**.

| Form          | Use it for…                                 | Example                                   |
| ------------- | ------------------------------------------- | ----------------------------------------- |
| **There is**  | ONE thing (singular) or an uncountable noun | _**There is** a sofa in the living room._ |
| **There are** | TWO or more things (plural)                 | _**There are** three bedrooms upstairs._  |

Make them negative with **isn''t / aren''t**: _There **isn''t** a garage._ — _There **aren''t** any chairs._

Learn the rooms — **kitchen, living room, dining room, bedroom, hall, garden** — and the furniture — **sofa, bed, carpet, wardrobe, table, window**. _In my **bedroom** there is a bed and a **wardrobe**._

> ⚠️ With a **plural** you MUST use **there are**: say _There **are** three rooms_ — NOT "there **is** three rooms". But when a **list starts with a singular** thing, the verb follows that first thing: _There **is** a sofa and two armchairs._ (singular "a sofa" first → **is**).

## 🧭 Where is it? — prepositions of location, "What''s it like?"

To say **where** something is, use a preposition of location:

| Preposition                    | Meaning                                                          |
| ------------------------------ | ---------------------------------------------------------------- |
| **in**                         | inside (_the keys are **in** the bag_)                           |
| **on**                         | on top of (_the vase is **on** the table_)                       |
| **near**                       | close to (_the shop is **near** the school_)                     |
| **next to**                    | right beside (_the bank is **next to** the café_)                |
| **between**                    | in the middle of TWO things (_**between** the bed and the door_) |
| **on the right / on the left** | to the right / left side                                         |
| **in the middle**              | in the centre                                                    |

To **ask someone to describe** a person, place or thing, use **What… like?**:

- _**What''s** your new house **like**? — It''s big and modern._
- _**What''s** your teacher **like**? — She''s kind and patient._

> ⚠️ Do not confuse **like** the preposition (for a description) with **like** the verb (for tastes): _What is it **like**?_ (describe it) ≠ _What does she **like**?_ (her tastes). And **between** needs exactly **two** things.

## 🐄 On Uncle Ridha''s farm — subject and object pronouns

A pronoun replaces a noun. The **subject** does the action; the **object** receives it.

| Role                                      | Forms                                 |
| ----------------------------------------- | ------------------------------------- |
| **Subject** (before the verb)             | I · you · he · she · it · we · they   |
| **Object** (after a verb / a preposition) | me · you · him · her · it · us · them |

- _**She** likes the goats. → I feed **them** with **her**._
- _Karim is my friend. **He** helps me and I help **him**._

On the farm you meet **hens, cows, goats, ducks, rabbits, turkeys**, and you talk about **fruit and vegetables** — **carrots, cucumber, figs, strawberries, watermelon, lettuce, onion**. Say what you **like / love** and **dislike / don''t like**: _I **love** figs, but I **don''t like** onions._

> ⚠️ Never use an object pronoun as the subject: say _**I** like strawberries_ — NOT "**Me** like strawberries". And after a verb or a preposition, use the object form: _play with **him**_, NOT "play with **he**".

## 🛍️ Market day — articles a / an / the

**a** and **an** mean "one, any" (you meet the thing for the first time). **the** means "this exact one" (we both know which).

| Article | Rule                              | Example                      |
| ------- | --------------------------------- | ---------------------------- |
| **a**   | before a **consonant sound**      | _**a** dress, **a** butcher_ |
| **an**  | before a **vowel sound**          | _**an** apple, **an** onion_ |
| **the** | a **specific** thing we both know | _**The** market is open._    |

It is the **sound**, not the letter, that counts: _**a** uniform_ (sounds like "you-niform") but _**an** hour_ (the "h" is silent). First time **a/an**, then **the**: _I bought **a** shirt. **The** shirt is blue._

At the market you name **clothes** — **dress, socks, sandals, trousers, jacket, tie, tee-shirt** — and **shops** — **greengrocer, butcher, market, stall**. Ask with **when** (time) and **what** (thing): _**When** is market day? — On Saturday._ — _**What** do you sell?_

> 🗡️ Look at the first **sound**: _**an** hour_, _**a** university_. The letter can trick you — trust your ear.

## 👶 One or many? — regular and irregular plurals

Most nouns add **-s**. Some follow small spelling rules; a few are **irregular** and you must learn them by heart.

| Rule                               | Singular → Plural                                                                                               |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| add **-s**                         | carpet → carpet**s**                                                                                            |
| after -s, -sh, -ch, -x add **-es** | dress → dress**es**, box → box**es**                                                                            |
| consonant + y → **-ies**           | party → part**ies**                                                                                             |
| **irregular**                      | child → **children**, man → **men**, woman → **women**, foot → **feet**, tooth → **teeth**, person → **people** |

_One **child**, two **children**._ — _One **man**, three **men**._

> ⚠️ Irregular plurals never take a plain -s: it is **children** (not "childs"), **men** (not "mans"), **people** (not "persons" in everyday English).

## 🎂 Happy birthday — the genitive, linkers and colours

To show **who owns** something, add **''s** to the owner (the **genitive**) — this is much more natural than "the … of …" for people:

| Owner               | Form          | Example                    |
| ------------------- | ------------- | -------------------------- |
| one person          | **name + ''s** | _**Nour''s** cake_          |
| plural ending in -s | **+ '' only**  | _my two **sisters''** room_ |
| irregular plural    | **+ ''s**      | _the **children''s** toys_  |

So say **Sami''s schoolbag**, NOT "the schoolbag of Sami". **Linkers** join your ideas:

- **and** = adds (_a cake **and** candles_) · **but** = contrasts (_I like it, **but** it''s small_)
- **because** = gives a reason (_I love parties **because** they are fun_) · **then** = next step (_We light the candles, **then** we blow them out_)

At a **birthday party** you see **balloons, a cake, candles, presents**, and you name **colours**: **red, green, yellow, pink, brown, white**. _My dress is **pink and white**._

> ⚠️ Watch the apostrophe: _my **parents'' car**_ (plural owners), _the **cat''s** food_ (one owner) — a missing apostrophe ("my parents car") is wrong.

> 🏆 Gate three cleared, hero! You can now describe a home, a farm and a market, own things with **''s** and count with real plurals. Next, you''ll learn to stay **safe and fit** — warnings, health and the weather await.', '# 📜 Summary: Home, Farm and Market

- **There is / there are**: **there is** + one thing / uncountable (_there is a sofa_) · **there are** + plural (_there are three rooms_ — never "there is three rooms") · negatives isn''t / aren''t · a list follows its first noun.
- **Prepositions of location**: in, on, near, next to, **between** (two things), on the right, on the left, in the middle. Ask to describe with **What''s … like? — It''s big and modern.**
- **Pronouns**: subject **I, you, he, she, it, we, they** (before the verb) vs object **me, you, him, her, it, us, them** (after a verb or preposition). _I help **him**_ · never "Me like…".
- **Articles**: **a** + consonant sound (a dress), **an** + vowel sound (an apple, **an hour**, **a uniform** — the sound, not the letter), **the** = a specific known thing (first _a_, then _the_).
- **Plurals**: add **-s**; **-es** after s/sh/ch/x (dresses); **-ies** for consonant+y (parties); irregular **child→children, man→men, woman→women, foot→feet, tooth→teeth, person→people** (never "childs/mans").
- **Genitive (''s)**: one owner **name''s** (Sami''s schoolbag, not "the bag of Sami") · plural owners **+ ''** (sisters'') · irregular plural **+ ''s** (children''s).
- **Linkers & colours**: **and** (add), **but** (contrast), **because** (reason), **then** (next step) · colours red, green, yellow, pink, brown, white · WH **when** (time) / **what** (thing).', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', 'Staying Safe and Fit', 'Module Four: warnings with Be careful! and Do not + verb, obligation and prohibition with must / mustn''t, body parts and ailments (cut, burn, hurt), asking for permission, giving advice with the imperative, quantity with much / many, a first look at the simple past (frequent regular and irregular verbs), weather words with Noun + y adjectives, and suggestions with Let''s / What about', '# ⚔️ Staying Safe and Fit — The Guardian''s Code

> 💡 "A true hero protects two treasures: a safe body and a healthy body."

## 🛡️ Warnings — Be careful! / Do not…

When you see danger, warn people fast:

- _**Be careful**, Yasmine! The floor is wet!_ — _The knife is sharp. **Be careful!**_
- **Do not + verb** (short form **Don''t**) tells someone to STOP: _**Do not touch** the oven!_ — _**Don''t run** near the swimming pool!_

Safety words: **dangerous** ≠ **safe**, **fall down**, **touch**, **sharp**.

> ⚠️ Say _Be **careful**!_ (careful = adjective), never "Be carefully!" or "Careful be!". And after **Don''t**, use the BASE verb: _Don''t **touch**!_ — never "Don''t touching", "No touch" or "Doesn''t touch".

## ⚡ Must and mustn''t — obligation and prohibition

| Structure               | Meaning                                | Example                                 |
| ----------------------- | -------------------------------------- | --------------------------------------- |
| **must + base verb**    | obligation — you have to do it         | _You **must wear** a helmet on a bike._ |
| **mustn''t + base verb** | prohibition — it is not allowed, stop! | _You **mustn''t play** with fire._       |

**Mustn''t** is strong: _You mustn''t swim here_ = swimming here is forbidden and dangerous — do not do it.

> ⚠️ Must never takes "to" or "-s": _You **must stop**_ ✓ — "must to stop", "musts stop" ✗. The negative is **mustn''t** — never "don''t must" or "not must".

## 🩹 At the doctor''s — your body, small injuries, permission

Learn your **body parts**, from head to foot: **head, hair, eye, ear, mouth, arm, hand, leg, ankle, foot**.

Accidents happen (**ailments**): you can **cut** your finger, **burn** your hand on something hot, **slip** on a wet floor, **fall down** and **hurt** your leg. The doctor asks: _**What''s the matter?**_ — he wants to know your **problem**: _My arm hurts._ Then he helps: a **plaster** on a small cut, **medicine** to drink, or an **injection**.

To ask for **permission**, use **Can I + verb…, please?**: _**Can I go** out, please?_ — _Yes, **of course you can**._

> 🗡️ "Can I…?" needs the base verb and the question order: _Can I open the window, please?_ — never "Can I to open…" or "I can go out?" as a question.

## 🧃 Keep fit — advice with the imperative, quantity with much / many

Give **advice** with the **imperative** (the base verb, no subject): _**Eat** a balanced diet._ — _**Practise** sit-ups and press-ups._ — _**Brush** your teeth after every meal._ — _**Don''t smoke.**_

Talk about **quantity** with much / many:

| Word     | Use with…                                      | Example                           |
| -------- | ---------------------------------------------- | --------------------------------- |
| **many** | things you can count (_sweets, oranges, eggs_) | _Don''t eat too **many** sweets._  |
| **much** | things you cannot count (_milk, bread, water_) | _There isn''t **much** milk left._ |

We often use **much** in negative sentences: _Don''t drink too **much** coke._ You can also say **too many / too much** (more than is good) and **so many / so much**.

> ⚠️ The classic trap is swapping them: "many water" ✗, "much sweets" ✗ — count it first, then choose.

## 🕰️ A first look at the simple past

To talk about **yesterday** or **last week**, English uses the **simple past**. This is just a first look — you will study it more next year.

- **Regular verbs** add **-ed**: _play → **played**_, _walk → **walked**_, _slip → **slipped**_ (the p doubles). _Yesterday, Karim **played** football._
- **Frequent irregular verbs** change completely — learn these by heart: _go → **went**_, _eat → **ate**_, _drink → **drank**_, _have → **had**_, _fall → **fell**_, _hurt → **hurt**_ (no change!), _be → **was / were**_.
- _Last Sunday, we **went** to the countryside and **had** a picnic. Anis **fell** down, but he **was** OK._

> ⚠️ Irregular verbs never take -ed: "goed", "eated", "falled", "hurted" ✗ — say **went, ate, fell, hurt** ✓. And regular verbs keep their spelling rule: _slip → **slipped**_, not "sliped".

## 🌦️ What''s the weather like? — Noun + y = adjective

Ask about the weather with the fixed question: _**What is the weather like?**_ (short: _What''s the weather like?_) — answer with **It''s…**: _It''s cloudy and cold today._

Many weather adjectives come from a **noun + y**:

| Noun      | Adjective  | Example                                 |
| --------- | ---------- | --------------------------------------- |
| **sun**   | **sunny**  | _It''s a **sunny** day._                 |
| **rain**  | **rainy**  | _Take your umbrella — it''s **rainy**._  |
| **wind**  | **windy**  | _A **windy** day is good for kites._    |
| **cloud** | **cloudy** | _The sky is grey and **cloudy**._       |
| **snow**  | **snowy**  | _A **snowy** morning in the mountains._ |

> ⚠️ Use the adjective, not the noun: _a **rainy** day_ ✓, "a rain day" ✗. And build it with **-y** only: "windly", "cloudly" ✗. The question is _**What** is the weather **like**?_ — never "How is the weather like?".

## 🤝 Suggestions — Let''s… / What about…?

Make a **suggestion** to do something together:

- **Let''s + base verb**: _It''s sunny! **Let''s go** to the beach._ — _**Let''s fly** our kites!_
- **What about + verb-ing?**: _**What about playing** football after school?_
- **What about + noun?**: _**What about a picnic** near the river?_

> ⚠️ Never "Let''s to go" or "Let''s going" — Let''s takes the base verb. And What about takes **-ing** (or a noun), never "What about play" or "What about to help".

🎵 **Sound check** — train your ear:

| Focus              | Examples                                                                                   |
| ------------------ | ------------------------------------------------------------------------------------------ |
| Silent **t**       | lis**t**en — you do not hear the t                                                         |
| Silent **l**       | wa**l**k, ta**l**k, ha**l**f — you do not hear the l                                       |
| /aʊ/ as in "out"   | m**ou**th, d**ow**n, sh**ou**t — but t**ou**ch and y**ou**ng are /ʌ/, and s**ou**p is /uː/ |
| Stressed syllables | ad**VISE** (second syllable) — but **CARE**ful, **HEAL**thy, **SUN**ny (first)             |

> 🏆 Gate four cleared, guardian! You can warn, protect, heal, keep fit and read the sky. One last gate remains: the school, helping others — and a big good-bye.', '# 📜 Summary: Staying Safe and Fit

- **Warnings**: _Be careful!_ (never "Be carefully") · **Do not / Don''t + BASE verb**: _Don''t touch!_ · dangerous ≠ safe.
- **Must / mustn''t**: **must + base verb** = obligation (_you must wear a helmet_) · **mustn''t** = prohibition, it is not allowed (_you mustn''t play with fire_) · never "must to", "musts", "don''t must".
- **Body & doctor**: head, hair, eye, ear, mouth, arm, hand, leg, ankle, foot · ailments: cut, burn, slip, fall down, hurt · _What''s the matter?_ = what is your problem? · plaster, medicine, injection · permission: _**Can I** go out, please? — Yes, of course you can._
- **Keep fit**: advice with the **imperative** (_Eat a balanced diet. Brush your teeth. Don''t smoke._) · **many** + countable (_too many sweets_), **much** + uncountable (_too much coke, not much milk_).
- **Simple past (first look)**: regular + **-ed** (_played, walked, slip → slipped_) · frequent irregulars: went, ate, drank, had, fell, hurt (no change), was/were · never "goed", "eated", "falled", "hurted".
- **Weather**: _**What''s the weather like?** — It''s cloudy._ · **Noun + y = adjective**: sun→sunny, rain→rainy, wind→windy, cloud→cloudy, snow→snowy (never "windly"/"a rain day").
- **Suggestions**: **Let''s + base verb** (_Let''s go!_) · **What about + verb-ing / + noun** (_What about playing? What about a picnic?_) · never "Let''s to go" / "What about play".
- **Sounds**: silent t (lis**t**en) · silent l (wa**l**k, ha**l**f) · /aʊ/ (mouth, down — but touch/young = /ʌ/) · stress: ad**VISE** vs **CARE**ful, **HEAL**thy.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', 'School and Good-byes', 'Module 5 — visiting a school, helping others and taking leave: permission and desire (you can / want to), prepositions of place, adverbs in -ly, comparing with like, can/cannot, how much/how many, apologies and farewells, and the -ed ending sounds', '# ⚔️ School and Good-byes — The Last Gate of the Journey

> 💡 "A polite hero opens every door: _Can I…?_ to enter, _I''m sorry_ to repair, and a warm _Good-bye_ to leave like a legend."

## 🏰 Giving permission — you can + verb

Emma, a pupil from London, is spending her last week in Tunisia. Today she visits her friend Yasmine''s school. To enter a place or use something, she asks for **permission** with **Can I / Can we…?**, and the answer gives permission with **you can + verb**:

- _**Can I** see your classroom, please? — **Of course you can!**_
- The headmaster says: _Welcome! **You can** visit all the classrooms._
- For another person, change the pronoun: _Can my sister come too? — Of course **she can**._

> ⚠️ After **can**, the verb NEVER takes "to": _You can **visit**_ ✓ — "You can to visit" ✗.

## 🔮 Expressing desire — want + noun / want + to + verb

To say what you **want**, use one of two patterns:

| Pattern              | Example                                     |
| -------------------- | ------------------------------------------- |
| **want + noun**      | _I **want** a glass of water._              |
| **want + to + verb** | _Emma **wants to see** the school library._ |

- With he / she / it, the verb takes **-s**: _She **wants** a souvenir._

> ⚠️ Never drop the **to**: _I want **to visit**_ ✓ — "I want visit" ✗ — and never "I want to visiting" ✗.

## 🗺️ Locating people and things — prepositions of place

A school is full of things: the **bell**, the **flag**, a **map**, a **globe**, the **board**, the **chalk**, an **eraser**, a **ruler**, a **pencil-case**, a **desk**, a **bookcase**, the **register**, the **headmaster''s office**, the **courtyard**. Say WHERE everything is with the **prepositions of place**:

| Preposition     | Meaning              | Example                                                    |
| --------------- | -------------------- | ---------------------------------------------------------- |
| **in front of** | before, facing       | _The board is **in front of** the pupils._                 |
| **behind**      | at the back of       | _The courtyard is **behind** the school._                  |
| **under**       | below                | _The cat sleeps **under** the desk._                       |
| **between**     | in the middle of two | _The eraser is **between** the ruler and the pencil-case._ |

## ⚡ My favourite subject — choice, apologies and -ly adverbs

School **subjects**: Maths, Arabic, English, physics, biology, history, technology. Express your **choice** with **favourite**: _My **favourite subject** is physics — I love working in the **lab**!_

> ⚠️ The English word is **subject**, not "matter" — "matter" is a French trap (matière).

Describe your teachers with adjectives: **strict**, **attentive**, **nervous**, **boring**… and describe HOW people do things with **adverbs of manner**: adjective + **-ly**.

| Adjective | Adverb        | Example                             |
| --------- | ------------- | ----------------------------------- |
| slow      | **slowly**    | _Please close the door **slowly**._ |
| fluent    | **fluently**  | _Emma speaks English **fluently**._ |
| careful   | **carefully** | _Carry the globe **carefully**!_    |
| quiet     | **quietly**   | _The pupils work **quietly**._      |
| clear     | **clearly**   | _The teacher explains **clearly**._ |

When you make a mistake — you **drop** a pencil-case, you step on a foot — **apologize**, and learn to **forgive**:

- Apologize: _**I''m sorry!** / I''m so sorry!_
- Grant forgiveness: _**That''s all right.** / **Never mind.**_

> ⚠️ Don''t confuse: **You''re welcome** answers "Thank you" — it does NOT answer "I''m sorry".

## 🛡️ Let''s help others — and compare with "like"

Good pupils **help** each other and keep the school **clean**: don''t **throw litter** on the **floor**, put waste paper in the **waste basket**, **collect** the **garbage**, keep the classroom **tidy**. To **compare** two things, use the pattern **noun + be + like + noun**:

- _My school **is like** a big family._ — _The library **is like** a treasure room._

> 🗡️ In this pattern, **like** means "similar to". Say _is **like** a garden_ — never "is as a garden", and never "is liking".

## 🧳 Good-bye, Emma! — ability, help and souvenir shopping

Emma''s stay ends, and the good-byes begin. Talk about **ability** and **inability** with **can / cannot (can''t)**:

- _Karim **can** carry the **light** bag, but he **cannot** carry the **heavy** **suitcase**._

**Ask for help** and **offer help** with the same little word **can**:

- Ask for help: _**Can you help me**, please?_ — Offer help: _**Can I help you?**_

At the **souk**, Emma the **customer** buys **souvenirs** — a small **carpet**, a wooden **toy**, some **roses** — and asks the **shopkeeper** about quantity and **price**:

| Question                   | Use with                | Example                                         |
| -------------------------- | ----------------------- | ----------------------------------------------- |
| **How much + uncountable** | water, milk, money, tea | _**How much** milk do you want?_                |
| **How many + countable**   | books, maps, toys       | _**How many** maps are there on the wall?_      |
| **How much is / are…?**    | price                   | _**How much** is this carpet? — Twenty dinars._ |

> ⚠️ Money and prices always take **how much**, even for plural things: _**How much are** these toys? — Five dinars each._ Never "How much books", and never "How many milk".

Time to go! **Take leave** like a hero: _**Good-bye!** — **See you soon!** — **Hurry up**, the taxi is waiting! — **Have a safe trip!**_

## 🎵 Sound check — the -ed ending and /æ/ vs /ɪ/

Regular verbs take **-ed** in the past (you met them in Module Four), and this -ed has **three possible sounds**:

| Sound | When                                     | Examples                            |
| ----- | ---------------------------------------- | ----------------------------------- |
| /t/   | after voiceless sounds (p, k, s, sh, ch) | help**ed**, wash**ed**, watch**ed** |
| /d/   | after voiced sounds (vowels, l, n, v…)   | play**ed**, open**ed**, clean**ed** |
| /ɪd/  | after the sounds t or d                  | want**ed**, need**ed**, visit**ed** |

And train your ear on two short vowels: **/æ/** as in _b**a**g, bl**a**ck, h**a**t_ — **/ɪ/** as in _b**i**g, s**i**x, sh**i**p_.

> 🏆 Module Five cleared — the whole journey is complete, hero! You can ask permission, say what you want, find your way around a school, apologize, compare, shop at the souk and say good-bye in English. New adventures are waiting — see you soon!', '# 📜 Summary: School and Good-byes

- **Permission**: _Can I / Can we…?_ → _Of course you can._ · **you can + verb** (never "can to") · change the pronoun for others: _Of course she can._
- **Desire**: **want + noun** (_I want a glass of water_) · **want + to + verb** (_She wants to see the library_) — never "want visit" · he/she/it → **wants**.
- **Prepositions of place**: **in front of** (facing) · **behind** (at the back) · **under** (below) · **between** … and … · school things: bell, flag, map, globe, board, ruler, pencil-case, bookcase, register, courtyard.
- **Choice, apologies & -ly adverbs**: _My favourite **subject** is physics_ (never "matter") · adjective + **-ly** = adverb of manner: slowly, fluently, carefully, quietly, clearly · _I''m sorry!_ → _That''s all right. / Never mind._ (**You''re welcome** answers "Thank you", not "I''m sorry").
- **Helping & comparing**: keep the school clean — no litter on the floor, waste paper in the waste basket · compare with **noun + be + like + noun**: _My school is like a big family_ (never "is as").
- **Ability, help & shopping**: **can / cannot** (_he cannot carry the heavy suitcase_) · ask: _Can you help me?_ / offer: _Can I help you?_ · **how much + uncountable** (milk, money, prices: _How much are these toys?_) / **how many + countable** (maps, books) · take leave: _Good-bye! See you soon! Have a safe trip!_
- **Sounds**: final **-ed** = /t/ (helped, washed), /d/ (played, cleaned), /ɪd/ (wanted, visited) · **/æ/** (bag, black) vs **/ɪ/** (big, six).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('255a513b-a502-578f-941a-5c33f67d2bc8', '1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'Complete the introduction: "Hello! I ___ Salma, and this is my friend Rania."', '[{"id":"a","text":"am"},{"id":"b","text":"are"},{"id":"c","text":"be"},{"id":"d","text":"is"}]'::jsonb, 'a', 'After the subject "I", the verb "to be" is always "am": I am Salma. "Are" goes with you/we/they, "is" goes with he/she/it, and "be" is the base form, which cannot follow a subject directly here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('980773bb-3f37-5bca-8ee9-308e68d88dfe', '1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'Choose the correct word: "___ are my grandparents."', '[{"id":"a","text":"This"},{"id":"b","text":"These"},{"id":"c","text":"It"},{"id":"d","text":"He"}]'::jsonb, 'b', '"Grandparents" means two people, so we use the plural demonstrative "these": These are my grandparents. "This", "it" and "he" are all singular, so they cannot introduce two people.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('494678cc-6ac1-5019-b498-9f288b87985e', '1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'Complete: "My little sister ___ got a red schoolbag."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"have"},{"id":"d","text":"has"}]'::jsonb, 'd', '"My little sister" = she, and with he/she/it we use "has got": she has got a red schoolbag. "Have got" is for I/you/we/they, and "am/is got" mixes the verb "to be" with "got".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9259d15-ddd6-5e66-8649-bd7fbaffa2de', '1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'Complete: "Every morning, Omar ___ up at seven o''clock."', '[{"id":"a","text":"get"},{"id":"b","text":"gets"},{"id":"c","text":"getting"},{"id":"d","text":"is get"}]'::jsonb, 'b', '"Every morning" describes a daily routine, so we use the simple present. Omar = he, so the verb takes -s: he gets up. "Get" forgets the -s, and "getting" or "is get" are not correct simple present forms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7036d5ea-eeee-5f57-8522-51502bb8b126', '1a2ba30a-e411-52f3-85ca-15cdbe8fab8d', 'Complete: "We have our English lesson ___ Monday."', '[{"id":"a","text":"at"},{"id":"b","text":"in"},{"id":"c","text":"on"},{"id":"d","text":"to"}]'::jsonb, 'c', 'With days of the week we use "on": on Monday. "At" is for clock times (at eight o''clock) and "in" is for parts of the day (in the morning).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '⭐ Practice: meet Salma''s family', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9088603-34a6-5f9c-8705-47fdc3bce329', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Rania says: "Hello, Salma! How are you?" What is the best reply?', '[{"id":"a","text":"\"Fine, thanks. And you?\""},{"id":"b","text":"\"Goodbye!\""},{"id":"c","text":"\"I am twelve.\""},{"id":"d","text":"\"Yes, I am.\""}]'::jsonb, 'a', '"How are you?" asks how you feel, so the friendly reply is "Fine, thanks. And you?". "I am twelve" answers "How old are you?", "Goodbye" is for leaving, and "Yes, I am" answers a yes/no question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b42c4a0c-27a0-5b7b-b9a2-e2b1333d69e9', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Complete with a subject pronoun: "My father is a farmer. ___ works in the fields every day."', '[{"id":"a","text":"I"},{"id":"b","text":"He"},{"id":"c","text":"She"},{"id":"d","text":"It"}]'::jsonb, 'b', '"My father" is one man, so the subject pronoun is "he": He works in the fields. "She" is for a woman, "it" is for a thing, and "I" is the speaker.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a78e2af-0d07-50d7-a58a-aaf512bbe70f', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Complete: "My grandparents ___ from Kairouan."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'c', '"Grandparents" means two people (they), so the verb "to be" is "are": they are from Kairouan. "Is" is only for one person (he/she/it) and "am" is only for "I".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de6e05dc-bd25-56b5-8e11-5371eb627ec7', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Choose the correct sentence to introduce your brother:', '[{"id":"a","text":"This is my brother, Anis."},{"id":"b","text":"This are my brother, Anis."},{"id":"c","text":"These are my brother, Anis."},{"id":"d","text":"These is my brother, Anis."}]'::jsonb, 'a', 'You are introducing ONE person, so you need the singular demonstrative "this" with the singular verb "is": This is my brother. "These" is for two or more people, and "this are" / "these is" mix singular and plural.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55a4cedd-45c8-5e56-aae8-18a70d341ca9', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Complete the question: "___ are you, Anis?" — "I am nine years old."', '[{"id":"a","text":"How"},{"id":"b","text":"How many"},{"id":"c","text":"How old"},{"id":"d","text":"What"}]'::jsonb, 'c', 'The answer gives an age (nine years old), so the question asks about age with "How old": How old are you? "How are you?" asks about feelings, and "How many" asks about a number of things.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51a97c24-897f-5293-b4be-6fbbce4c2c82', '29cc2bcd-de0e-5ef9-8a4e-7796027e9d4e', 'Salma is twelve years old. Her brother Youssef is two years older. How old is Youssef?', '[{"id":"a","text":"ten"},{"id":"b","text":"twelve"},{"id":"c","text":"thirteen"},{"id":"d","text":"fourteen"}]'::jsonb, 'd', 'Two years older than twelve means 12 + 2 = 14, so Youssef is fourteen (14). "Ten" subtracts instead of adding, "thirteen" adds only one year, and "twelve" forgets to add at all.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '⚔️ Chapter boss ⭐⭐⭐: my day, my family', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a323cb9-cef1-51a2-84c7-c7ee75b618b3', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'Complete: "I ___ got a bike. I always walk to school."', '[{"id":"a","text":"don''t"},{"id":"b","text":"hasn''t"},{"id":"c","text":"haven''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'c', 'The negative of "I have got" is "I haven''t got": have + not. "Hasn''t" is only for he/she/it, and "don''t got" or "isn''t got" mix other auxiliaries into the "have got" structure.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e007ec2-b53b-51a9-adf7-facd08755c61', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'Complete: "After dinner, my mother ___ TV with us."', '[{"id":"a","text":"watch"},{"id":"b","text":"watches"},{"id":"c","text":"watchs"},{"id":"d","text":"watching"}]'::jsonb, 'b', '"My mother" = she, so the verb takes the third-person ending. Verbs ending in -ch add -es, not just -s: she watches TV ✓. The common trap is writing "watchs" — after -ch, -sh or -o, the ending is always -es (watches, washes, goes).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c42e6adc-9741-54d3-8cab-725ede898c7d', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'Complete the question: "___ do you go to bed?" — "At nine o''clock."', '[{"id":"a","text":"What time"},{"id":"b","text":"How many time"},{"id":"c","text":"How old"},{"id":"d","text":"Where"}]'::jsonb, 'a', 'The answer "At nine o''clock" gives a clock time, so the question word is "What time": What time do you go to bed? "How many time" is not correct English, "How old" asks about age, and "Where" asks about a place.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b12d814-700a-58d3-b6d7-43ac8b2e839a', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', '"School starts at half past eight." What time is that on the clock?', '[{"id":"a","text":"8:15"},{"id":"b","text":"8:30"},{"id":"c","text":"8:45"},{"id":"d","text":"9:30"}]'::jsonb, 'b', '"Half past eight" means 30 minutes after eight o''clock, so it is 8:30 ✓. The common trap is confusing "half" (30 minutes) with "a quarter" (15 minutes): 8:15 is a quarter past eight and 8:45 is a quarter to nine. 9:30 would be half past nine.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb651788-f6e8-5ed1-a728-b808e38aa509', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'Which sentence puts the adverb in the correct place?', '[{"id":"a","text":"Always Rania gets up at six."},{"id":"b","text":"Rania gets always up at six."},{"id":"c","text":"Rania gets up always at six."},{"id":"d","text":"Rania always gets up at six."}]'::jsonb, 'd', 'An adverb of frequency goes BEFORE the main verb: Rania always gets up at six ✓. The common trap is putting it after the verb ("gets always up") or at the start of the sentence — with an ordinary verb like "get up", "always" must sit just before it.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1f1a07a-af97-5f36-8035-fde492a2ecfc', 'db3af8e2-d3cc-5c40-a422-e19ba71c46dc', 'Complete the short answer: "Has Youssef got a computer?" — "No, he ___."', '[{"id":"a","text":"haven''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"hasn''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'c', 'The short answer repeats the auxiliary of the question in the negative: Has he…? → No, he hasn''t ✓. The common trap is answering "No, he doesn''t" — that matches a "Does he have…?" question, not a "Has he got…?" question. "Haven''t" is for I/you/we/they.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '⭐⭐ Review (exam style): all about me', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('374df004-cef5-5533-b973-5f3249fbe151', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Complete: "My mother ___ a farmer; she is a teacher."', '[{"id":"a","text":"isn''t"},{"id":"b","text":"aren''t"},{"id":"c","text":"don''t"},{"id":"d","text":"not"}]'::jsonb, 'a', '"My mother" = she, so the negative of "to be" is "isn''t" (is not): she isn''t a farmer. "Aren''t" goes with you/we/they, "don''t" is for ordinary verbs, and "not" alone cannot stand without a verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e83eaba-531c-5739-bcc0-585a0cfeb9a3', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Complete the short answer: "Have you got any cousins, Rania?" — "Yes, I ___."', '[{"id":"a","text":"am"},{"id":"b","text":"do"},{"id":"c","text":"got"},{"id":"d","text":"have"}]'::jsonb, 'd', 'A short answer repeats the auxiliary of the question. The question starts with "Have", so the answer is "Yes, I have." "Am" answers an "Are you…?" question and "do" answers a "Do you…?" question.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ceed5612-1b83-5cbc-b7db-e7ad62f9e9d5', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Complete the question: "How many brothers ___ Salma got?" — "Two."', '[{"id":"a","text":"does"},{"id":"b","text":"has"},{"id":"c","text":"have"},{"id":"d","text":"is"}]'::jsonb, 'b', 'With "got" and the singular subject Salma (= she), we use "has": How many brothers has Salma got? "Have" is for I/you/we/they, and "does" would need the verb "have" without "got".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('364e28ba-dc30-5057-93b8-ef890eabbf49', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Complete: "Meriem enjoys ___ in the sea in summer."', '[{"id":"a","text":"swim"},{"id":"b","text":"swims"},{"id":"c","text":"swimming"},{"id":"d","text":"to swimming"}]'::jsonb, 'c', 'After "like", "love" and "enjoy", an activity takes the -ing form: she enjoys swimming. "Swim" and "swims" are simple present forms, and "to swimming" wrongly mixes "to" with -ing.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9928a60e-c862-583c-9d77-c252588e709a', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Omar drinks tea every single morning, without exception. Complete: "Omar ___ drinks tea in the morning."', '[{"id":"a","text":"always"},{"id":"b","text":"usually"},{"id":"c","text":"sometimes"},{"id":"d","text":"never"}]'::jsonb, 'a', '"Every single morning, without exception" means 100% of the time, and the adverb for 100% is "always". "Usually" means most mornings but not all, "sometimes" means only now and then, and "never" means 0%.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('590b0d3f-c72f-501a-a604-8e8ef03f2eac', '2ef594a5-73ab-5f7d-b40d-c863c449c3c5', 'Your friend says: "I have got a new bike!" You are happy for her. What do you say?', '[{"id":"a","text":"\"Good night.\""},{"id":"b","text":"\"Sorry, I''m late.\""},{"id":"c","text":"\"That''s great!\""},{"id":"d","text":"\"You''re welcome.\""}]'::jsonb, 'c', 'To show approval of good news, English speakers say "That''s great!". "You''re welcome" replies to "thank you", "Good night" is for going to bed, and "Sorry, I''m late" is an apology.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6af4185-1377-539c-a739-3d2a46319ebc', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the hero''s introduction', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba4d912b-0eb9-5d25-9270-929a59b15cd4', 'c6af4185-1377-539c-a739-3d2a46319ebc', 'Which sentence is NOT correct?', '[{"id":"a","text":"Salma doesn''t like tea."},{"id":"b","text":"They don''t play tennis."},{"id":"c","text":"Omar don''t like coffee."},{"id":"d","text":"We don''t get up late."}]'::jsonb, 'c', 'This question asks for the INCORRECT sentence. "Omar don''t like coffee" is wrong because Omar = he, and he/she/it needs "doesn''t": Omar doesn''t like coffee ✓. The other three sentences correctly use "don''t" with they, we and "doesn''t" with she.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3395507b-3ea1-55ba-8be6-c127862f09d9', 'c6af4185-1377-539c-a739-3d2a46319ebc', 'Rania gets up at six o''clock. Choose the question that asks about this time.', '[{"id":"a","text":"What time does Rania get up?"},{"id":"b","text":"What time do Rania get up?"},{"id":"c","text":"What time is Rania get up?"},{"id":"d","text":"What time Rania gets up?"}]'::jsonb, 'a', 'A simple present question needs: WH-word + does (for he/she/it) + subject + BASE verb → What time does Rania get up? ✓ The common traps are all here: "do" with a singular subject, "is" mixed with an ordinary verb, and forgetting the auxiliary completely ("What time Rania gets up?").', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae788721-920f-5806-b067-a96bfbf6e182', 'c6af4185-1377-539c-a739-3d2a46319ebc', 'Anis goes to football training three Saturdays out of every four. Which sentence describes his routine?', '[{"id":"a","text":"He always goes to football training on Saturdays."},{"id":"b","text":"He usually goes to football training on Saturdays."},{"id":"c","text":"He sometimes goes to football training on Saturdays."},{"id":"d","text":"He never goes to football training on Saturdays."}]'::jsonb, 'b', 'Three Saturdays out of four is most of the time, but not every time — that is exactly "usually" ✓. The common trap is "always", which means 100% with no exception; "sometimes" would fit a much lower frequency, and "never" means 0%.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc0f8914-184b-5539-8273-304e2c08450b', 'c6af4185-1377-539c-a739-3d2a46319ebc', '"It''s ten to nine." Which clock time is it?', '[{"id":"a","text":"8:50"},{"id":"b","text":"9:10"},{"id":"c","text":"9:50"},{"id":"d","text":"10:09"}]'::jsonb, 'a', '"Ten to nine" means 10 minutes BEFORE nine o''clock: 9:00 minus 10 minutes = 8:50 ✓. The common trap is 9:10, which is "ten past nine" — "past" counts after the hour, "to" counts before the next hour. Reading the words in order as "10:09" is also wrong.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68beac7e-420a-51b8-966a-96d9dea2c63b', 'c6af4185-1377-539c-a739-3d2a46319ebc', 'In which word is the vowel sound /ɑː/, as in "father"?', '[{"id":"a","text":"brother"},{"id":"b","text":"cup"},{"id":"c","text":"mother"},{"id":"d","text":"park"}]'::jsonb, 'd', '"Park" has the long sound /ɑː/, exactly like "father" ✓. The trap is that "mother" and "brother" LOOK like "father" on paper, but they are pronounced with the short sound /ʌ/, like "cup" and "sun" — spelling and sound do not always match in English.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e122c52b-323a-5e1c-b126-057822bfff39', 'c6af4185-1377-539c-a739-3d2a46319ebc', 'Complete: "My cousins ___ got a small dog, and they enjoy ___ with it in the garden."', '[{"id":"a","text":"has … play"},{"id":"b","text":"has … playing"},{"id":"c","text":"have … play"},{"id":"d","text":"have … playing"}]'::jsonb, 'd', 'Two rules work together here: "cousins" is plural (= they), so it takes "have got", and after "enjoy" the activity takes -ing → have … playing ✓. The common trap is getting one rule right and the other wrong: "has" with a plural subject, or "enjoy play" without -ing.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1511ca9a-b5ec-5921-95ed-91748f96c205', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '📝 Training ⭐⭐⭐: Module One round-up (exam style)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee5ff1bc-cc3a-5600-8c55-b0a2dc1f9a68', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'Complete: "Salma and I ___ good friends. We play together every day."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'c', '"Salma and I" means two people together (= we), and "we" takes "are": Salma and I are good friends. The common trap is choosing "am" because of the word "I" — but the full subject is plural, not "I" alone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84c0753d-0834-5041-9469-24cfa6516948', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'Complete the question: "___ your parents got a car?"', '[{"id":"a","text":"Are"},{"id":"b","text":"Do"},{"id":"c","text":"Has"},{"id":"d","text":"Have"}]'::jsonb, 'd', 'In a "have got" question, "have" itself moves to the front: Have your parents got a car? "Parents" is plural, so "has" is wrong, and "Do" or "Are" cannot combine with "got" in this structure.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9f6c86a-73ca-562c-8498-a655226df24c', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'Complete: "Youssef ___ like tea; he drinks milk."', '[{"id":"a","text":"doesn''t"},{"id":"b","text":"don''t"},{"id":"c","text":"isn''t"},{"id":"d","text":"not"}]'::jsonb, 'a', 'Youssef = he, and the simple present negative for he/she/it is "doesn''t" + base verb: he doesn''t like tea. The classic mistake is "he don''t like" — "don''t" is only for I/you/we/they. "Isn''t" belongs to the verb "to be", not to "like".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c445ac50-a506-56d1-a691-52321d7ce614', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'Complete: "Salma does her homework ___ the evening."', '[{"id":"a","text":"at"},{"id":"b","text":"in"},{"id":"c","text":"on"},{"id":"d","text":"to"}]'::jsonb, 'b', 'Parts of the day take "in": in the morning, in the evening. The common trap is "at the evening" — "at" is for clock times (at seven o''clock) and for "at night", and "on" is for days (on Monday).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcf27452-5f2d-547a-8348-b503bc40a09d', '1511ca9a-b5ec-5921-95ed-91748f96c205', 'Complete with a linker: "Salma loves swimming, ___ her brother Youssef doesn''t like it."', '[{"id":"a","text":"and"},{"id":"b","text":"but"},{"id":"c","text":"or"},{"id":"d","text":"so"}]'::jsonb, 'b', 'The two ideas are opposites (she loves it / he doesn''t like it), so we need the contrast linker "but". "And" only adds a similar idea, and "or" offers a choice — neither shows contrast.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3fbf482-2688-5f21-a9f8-8ed72a96b960', '1511ca9a-b5ec-5921-95ed-91748f96c205', '"What time is it?" — "It''s 7:45." Which sentence gives the same time?', '[{"id":"a","text":"It''s a quarter past seven."},{"id":"b","text":"It''s a quarter past eight."},{"id":"c","text":"It''s a quarter to eight."},{"id":"d","text":"It''s half past seven."}]'::jsonb, 'c', '7:45 is 15 minutes (a quarter of an hour) BEFORE eight, so we say "a quarter to eight" ✓. The common trap is "a quarter past seven", which is 7:15 — "past" counts minutes after the hour, "to" counts minutes before the next hour. "Half past seven" is 7:30.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d05e13b1-3f2f-5679-9564-9caba9b0b636', 'b7c95f45-e1ad-5792-9e93-13aa45797c40', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of Module One', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbaaee7a-3902-5856-b8b2-d296e2190903', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Complete: "My little sister ___ seven years old."', '[{"id":"a","text":"has"},{"id":"b","text":"has got"},{"id":"c","text":"have"},{"id":"d","text":"is"}]'::jsonb, 'd', 'English expresses age with the verb "to be": she is seven years old ✓. The common trap comes from translating other languages, where age uses "have" — but "she has seven years" or "she has got seven years old" are impossible in English.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9818539-a38a-5537-a9ad-0c57ee7fd9bc', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Read the text: "(1) Salma is twelve years old. (2) She has got two brothers. (3) Her brothers likes football. (4) They play in the garden every evening." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 has the mistake: this question asks you to find the faulty sentence. "Her brothers likes football" is wrong: "brothers" is plural (= they), and the -s ending is ONLY for he/she/it — it must be "her brothers like football" ✓. Sentences 1, 2 and 4 correctly use "is", "has got" and "play".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e88e470b-1a69-5ac6-a466-eebcff991a29', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Choose the question that matches this answer: "Yes, they have. They have got two cats."', '[{"id":"a","text":"Are your neighbours got any cats?"},{"id":"b","text":"Do your neighbours have got any cats?"},{"id":"c","text":"Has your neighbours got any cats?"},{"id":"d","text":"Have your neighbours got any cats?"}]'::jsonb, 'd', 'The short answer "Yes, they have" repeats the auxiliary of the question, so the question must start with "Have" + plural subject: Have your neighbours got any cats? ✓ "Has" cannot go with the plural "neighbours", and "Do … have got" or "Are … got" mix two structures together.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3814e30c-4218-5844-98a0-8f6bfd367b50', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Complete: "Anis has breakfast ___ half past seven ___ the morning."', '[{"id":"a","text":"at … in"},{"id":"b","text":"at … on"},{"id":"c","text":"in … at"},{"id":"d","text":"on … in"}]'::jsonb, 'a', 'Two prepositions of time work together: "at" + a clock time (at half past seven) and "in" + a part of the day (in the morning) ✓. The common trap is swapping them ("in half past seven… at the morning") — remember: at + hour, in + morning/evening, on + day.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9f689d3-f3e5-5f00-b8bb-9d61ad622008', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Which sentence puts "never" in the correct place?', '[{"id":"a","text":"Never Youssef is late for school."},{"id":"b","text":"Youssef is late never for school."},{"id":"c","text":"Youssef is never late for school."},{"id":"d","text":"Youssef never is late for school."}]'::jsonb, 'c', 'With the verb "to be", the adverb of frequency goes AFTER the verb: Youssef is never late ✓. The common trap is applying the other rule everywhere — "never" goes BEFORE an ordinary verb (he never gets up late) but AFTER am/is/are. "Youssef never is late" uses the wrong rule.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60676487-3032-56ce-8114-f830aa944222', 'd05e13b1-3f2f-5679-9564-9caba9b0b636', 'Which word has the sound /tʃ/, as in "cheese"?', '[{"id":"a","text":"wash"},{"id":"b","text":"watch"},{"id":"c","text":"school"},{"id":"d","text":"sister"}]'::jsonb, 'b', '"Watch" ends with the sound /tʃ/, exactly like "cheese" and "children" ✓. The traps are words whose spelling deceives you: "school" is written with ch but pronounced /k/, "wash" ends in the softer sound /ʃ/, and "sister" starts with a plain /s/.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81b14d79-efdb-5441-8e9a-e979a9357008', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'Complete: "My friend Nour always helps me with my homework. She is very ___."', '[{"id":"a","text":"friendly"},{"id":"b","text":"funny"},{"id":"c","text":"helpful"},{"id":"d","text":"quiet"}]'::jsonb, 'c', 'A person who always helps is "helpful". "Friendly" means nice to people, "funny" means she makes you laugh, and "quiet" means calm and not noisy — only "helpful" matches "always helps me".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('576a29b2-564b-5994-a4e1-98b4cf6ed04e', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'Complete: "Look! Dad ___ lunch in the kitchen."', '[{"id":"a","text":"cooking"},{"id":"b","text":"cooks"},{"id":"c","text":"is cook"},{"id":"d","text":"is cooking"}]'::jsonb, 'd', '"Look!" shows the action is happening now, so we need the present progressive: is/are + verb-ing → Dad is cooking. "Cooking" alone forgets the verb "be", "is cook" forgets the -ing, and "cooks" is the simple present, used for habits.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89d25b45-2bb2-5221-a83a-a615fdc04f9e', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'Tom''s suitcase is very heavy. What is the polite way to ask for help?', '[{"id":"a","text":"\"Can you help me, please?\""},{"id":"b","text":"\"Help me now!\""},{"id":"c","text":"\"I want help, quick!\""},{"id":"d","text":"\"You help me.\""}]'::jsonb, 'a', 'A polite request uses "Can you … please?": Can you help me, please? The other three sentences give orders without "please", so they sound rude in English.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90848a98-7501-536f-8965-959edba31f80', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', '"Would you like some fresh orange juice?" — You want some. What do you say?', '[{"id":"a","text":"\"No, thank you.\""},{"id":"b","text":"\"Yes, please.\""},{"id":"c","text":"\"You''re welcome.\""},{"id":"d","text":"\"Fine, thanks.\""}]'::jsonb, 'b', 'To accept an offer, English speakers say "Yes, please." "No, thank you" politely declines, "You''re welcome" answers "thank you", and "Fine, thanks" answers "How are you?".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9be93a32-dff7-5f6b-b7c8-5d33d5ff3deb', '3e68127f-ac51-5f8e-b6f3-8e54ffaabba1', 'Complete: "Salma and Youssef love ___ new house."', '[{"id":"a","text":"her"},{"id":"b","text":"his"},{"id":"c","text":"our"},{"id":"d","text":"their"}]'::jsonb, 'd', '"Salma and Youssef" means two people (= they), so the possessive adjective is "their": their new house. "His" is for one boy, "her" is for one girl, and "our" would mean the house belongs to "we", the speakers.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed8703be-df78-550b-ae0f-2714fea691cf', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '⭐ Practice: my friends, my street', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa8658c4-9a22-51f9-8324-a6b6eda2669a', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Sami tells wonderful stories and everybody laughs. He is very ___.', '[{"id":"a","text":"funny"},{"id":"b","text":"helpful"},{"id":"c","text":"intelligent"},{"id":"d","text":"quiet"}]'::jsonb, 'a', 'A person who makes everybody laugh is "funny". "Helpful" describes someone who helps, "intelligent" someone who understands quickly, and "quiet" someone calm who does not make noise.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c7c5ee1-6624-5ba7-86d2-941ff0bd9bad', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Complete the question: "___ is your house?" — "It''s near the river."', '[{"id":"a","text":"How"},{"id":"b","text":"What"},{"id":"c","text":"Where"},{"id":"d","text":"Who"}]'::jsonb, 'c', 'The answer gives a place (near the river), so the question asks about place with "Where": Where is your house? "Who" asks about a person, "What" asks about a thing, and "How" asks about manner or state.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('117f6be2-b756-5d6d-b63a-aa05b9ece168', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Complete: "Listen! Meriem ___ a song in her room."', '[{"id":"a","text":"sings"},{"id":"b","text":"singing"},{"id":"c","text":"is sing"},{"id":"d","text":"is singing"}]'::jsonb, 'd', '"Listen!" tells us the action is happening right now, so we use the present progressive: is + verb-ing → she is singing. "Sings" is the simple present for habits, "singing" alone has no verb "be", and "is sing" forgets the -ing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13c396b6-beea-51b5-b2a2-d6eaa80201ae', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Complete: "This is my friend Karim. ___ bike is red."', '[{"id":"a","text":"Her"},{"id":"b","text":"His"},{"id":"c","text":"My"},{"id":"d","text":"Their"}]'::jsonb, 'b', 'Karim is a boy, so the possessive adjective is "his": his bike. "Her" is for a girl, "their" is for two or more people, and "my" would mean the bike belongs to the speaker, not to Karim.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f14ec5d8-18b7-52e6-ad4f-fca6b0301189', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Complete: "My friend Nour lives ___ Sousse."', '[{"id":"a","text":"at"},{"id":"b","text":"in"},{"id":"c","text":"on"},{"id":"d","text":"under"}]'::jsonb, 'b', 'With a town or city we use "in": she lives in Sousse. "At" is for an exact point (at the door), "on" is for a surface (on the table), and "under" means below something.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3dee34da-5682-5669-8d81-9fb371f96302', 'ed8703be-df78-550b-ae0f-2714fea691cf', 'Complete the question: "___ your street quiet?" — "Yes, it is."', '[{"id":"a","text":"Are"},{"id":"b","text":"Do"},{"id":"c","text":"Does"},{"id":"d","text":"Is"}]'::jsonb, 'd', 'The short answer "Yes, it is" repeats the verb of the question, so the question starts with "Is": Is your street quiet? "Are" goes with plural subjects, and "Do/Does" are for ordinary verbs, not for "to be".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '⚔️ Chapter boss ⭐⭐⭐: what''s happening right now?', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fd052ae-b8db-51c0-a4d2-8bbc94f294f0', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'Complete: "Salma ___ TV now; she is doing her homework."', '[{"id":"a","text":"doesn''t watch"},{"id":"b","text":"doesn''t watching"},{"id":"c","text":"isn''t watch"},{"id":"d","text":"isn''t watching"}]'::jsonb, 'd', '"Now" asks for the present progressive, and its negative is be + not + verb-ing: she isn''t watching TV ✓. "Doesn''t watch" is the simple present, used for habits, not for this moment; "isn''t watch" forgets the -ing, and "doesn''t watching" mixes the two tenses together.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79571eb5-2c8c-5b47-8367-c13d07b0daeb', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'Complete: "Look! The cat ___ on my bed."', '[{"id":"a","text":"is siting"},{"id":"b","text":"is sitting"},{"id":"c","text":"sit"},{"id":"d","text":"sits"}]'::jsonb, 'b', '"Look!" signals an action happening now, and short verbs like "sit" double their last letter before -ing: the cat is sitting ✓. The common trap is "is siting" with one t — sit, swim and other short verbs double the final consonant (sitting, swimming). "Sits" and "sit" are simple present forms.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbcfc71e-ad5a-5296-90a1-40802450ecd7', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'At customs, Tom wants his passport back. What is the polite way to ask?', '[{"id":"a","text":"\"Can I have my passport back, please?\""},{"id":"b","text":"\"Give me my passport.\""},{"id":"c","text":"\"I want my passport now.\""},{"id":"d","text":"\"My passport, quick!\""}]'::jsonb, 'a', 'A polite request uses "Can I … please?": Can I have my passport back, please? ✓ The other three are direct orders without "please" — in English they sound rude, especially when you speak to an officer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f231ebe7-ca6d-55f5-bb51-ca7d10d11d5c', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'Complete the invitation: "It''s lunch time. ___ some grilled fish?"', '[{"id":"a","text":"Are you"},{"id":"b","text":"Do you"},{"id":"c","text":"What about"},{"id":"d","text":"Would you"}]'::jsonb, 'c', '"What about + noun" makes an offer: What about some grilled fish? ✓ "Would you" needs "like" (Would you LIKE some fish?), and "Do you" or "Are you" cannot stand directly before "some grilled fish" — the sentence would have no main verb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a80e9f50-bab7-5b5a-bad6-3542db05addd', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'Complete the question: "What ___ Mum ___?" — "She is preparing dinner."', '[{"id":"a","text":"does … doing"},{"id":"b","text":"does … do"},{"id":"c","text":"is … doing"},{"id":"d","text":"is … do"}]'::jsonb, 'c', 'The answer "She is preparing dinner" is in the present progressive, so the question must be too: What is Mum doing? ✓ The common trap is "What does Mum do?" — that simple present question asks about her job or habits, not about this moment. "Does … doing" and "is … do" mix the two structures.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('689458d1-f0a1-57b3-ba2b-523853791e4a', 'c5f7094f-7a1d-5bcb-84b0-8c70caa4fb0d', 'Complete: "Nour usually ___ milk, but today she ___ orange juice."', '[{"id":"a","text":"drinks … drinks"},{"id":"b","text":"drinks … is drinking"},{"id":"c","text":"is drinking … drinks"},{"id":"d","text":"is drinking … is drinking"}]'::jsonb, 'b', '"Usually" describes a habit → simple present (drinks), and "today" describes what is happening now → present progressive (is drinking) ✓. The common trap is using the same tense in both parts — the sentence contrasts a habit with this moment, so the two tenses must be different, in that order.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('30b34613-6c08-55ad-ba3d-1e2015ea9588', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '⭐⭐ Review (exam style): my immediate world', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87b06e1c-db7c-5d24-8a9c-9cc3ac88e0a1', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Choose the correct word: a piece of land with water all around it.', '[{"id":"a","text":"garden"},{"id":"b","text":"island"},{"id":"c","text":"river"},{"id":"d","text":"street"}]'::jsonb, 'b', 'An island is land with water all around it — Djerba is a famous Tunisian island. A river is water that flows, a garden is a green space near a house, and a street is a road in a town.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bcc18e0-1791-58e2-bfc1-73b66a6d5b1f', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Complete: "Rania and I love ___ new school."', '[{"id":"a","text":"her"},{"id":"b","text":"my"},{"id":"c","text":"our"},{"id":"d","text":"their"}]'::jsonb, 'c', '"Rania and I" means "we", and the possessive adjective for "we" is "our": our new school. The common trap is choosing "my" because of the word "I" — but the school belongs to both people, so "my" and "her" are each only half right, and "their" is for other people.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de31de3c-c1a3-5ed0-87b6-4d5ba253bb58', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Complete: "We ___ for the plane in the lounge."', '[{"id":"a","text":"are wait"},{"id":"b","text":"are waiting"},{"id":"c","text":"is waiting"},{"id":"d","text":"waiting"}]'::jsonb, 'b', 'With "we", the present progressive is are + verb-ing: we are waiting ✓. "Are wait" forgets the -ing, "waiting" alone forgets the verb "be", and "is" goes with he/she/it, not with "we".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5ff7a28-2d64-5eeb-868e-dc4e1779ecb9', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Tom arrives at Salma''s house for the first time. What does Salma''s father say?', '[{"id":"a","text":"\"Good night, Tom!\""},{"id":"b","text":"\"Good-bye, Tom!\""},{"id":"c","text":"\"Welcome to Tunisia, Tom!\""},{"id":"d","text":"\"You''re welcome, Tom!\""}]'::jsonb, 'c', 'To greet a guest who arrives, we say "Welcome to Tunisia!". The trap is "You''re welcome", which only answers "thank you". "Good-bye" is for leaving and "Good night" is for going to bed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6082c68-8c32-501d-b6c2-fad38505b8ab', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Complete the offer: "___ you like some couscous, Lucy?"', '[{"id":"a","text":"Would"},{"id":"b","text":"What"},{"id":"c","text":"Do"},{"id":"d","text":"Are"}]'::jsonb, 'a', 'An offer at the table uses "Would you like + some + food": Would you like some couscous? The common trap is "Do you like some couscous?" — "Do you like…?" asks about general taste, not an offer, and it does not go with "some". "What" would need "about" (What about some couscous?).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3522099-eb1b-5435-8bde-622eecc37437', '30b34613-6c08-55ad-ba3d-1e2015ea9588', 'Lucy says: "Thank you for this delicious lunch!" What does Salma''s mother reply?', '[{"id":"a","text":"\"Fine, thanks.\""},{"id":"b","text":"\"Welcome to Tunisia!\""},{"id":"c","text":"\"Yes, please.\""},{"id":"d","text":"\"You''re welcome.\""}]'::jsonb, 'd', 'The reply to "thank you" is "You''re welcome." "Welcome to Tunisia" greets a guest who arrives, "Yes, please" accepts an offer, and "Fine, thanks" answers "How are you?".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b1897c4b-d452-58ec-b21e-572213df0515', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: a visitor at the airport', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('883d03fc-492f-593a-aff6-39c8c634100b', 'b1897c4b-d452-58ec-b21e-572213df0515', 'Which sentence is NOT correct?', '[{"id":"a","text":"Lina is preparing the salad."},{"id":"b","text":"Dad is cook the couscous."},{"id":"c","text":"The kids are tidying up their room."},{"id":"d","text":"Mum is making a cake."}]'::jsonb, 'b', 'This question asks for the INCORRECT sentence. "Dad is cook the couscous" is wrong: the present progressive needs be + verb-ING, so it must be "Dad is cookING" ✓. The other three sentences correctly combine is/are with preparing, tidying and making.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5375129d-b664-5c6a-82c7-8feed93bf918', 'b1897c4b-d452-58ec-b21e-572213df0515', 'Your question: "What are the neighbours doing?" Choose the correct answer.', '[{"id":"a","text":"\"They are planting a tree in their garden.\""},{"id":"b","text":"\"They are farmers.\""},{"id":"c","text":"\"They plant a tree now.\""},{"id":"d","text":"\"Yes, they are.\""}]'::jsonb, 'a', '"What are they doing?" asks about an action happening now, so the answer is in the present progressive: They are planting a tree ✓. The common trap is "They are farmers" — that answers "What do they do?", the job question. "They plant a tree now" uses the wrong tense with "now", and "Yes, they are" answers a yes/no question.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a703a5f-4d84-597f-b975-d142e853a87c', 'b1897c4b-d452-58ec-b21e-572213df0515', 'Complete: "Tom and Lucy are in ___ room; they ___ their suitcases."', '[{"id":"a","text":"her … is opening"},{"id":"b","text":"his … are opening"},{"id":"c","text":"their … are opening"},{"id":"d","text":"their … is opening"}]'::jsonb, 'c', 'Two rules work together: "Tom and Lucy" = they, so the possessive adjective is "their", and the plural verb is "are opening" ✓. The common trap is getting one rule right and the other wrong: "their … is opening" puts a singular verb with a plural subject, and "his" or "her" would mean the room belongs to only one of them.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04db1856-a05c-534c-a659-fd0c2be6ec66', 'b1897c4b-d452-58ec-b21e-572213df0515', '"Would you like some more soup, Tom?" Tom is full. What is the polite reply?', '[{"id":"a","text":"\"Yes, please. I''m full.\""},{"id":"b","text":"\"No! Take it away.\""},{"id":"c","text":"\"You''re welcome.\""},{"id":"d","text":"\"No, thank you. It''s delicious, but I''m full.\""}]'::jsonb, 'd', 'To decline an offer politely, say "No, thank you" and soften it with a kind word: No, thank you. It''s delicious, but I''m full ✓. The trap in "Yes, please. I''m full" is the contradiction — you cannot accept AND say you are full. "No! Take it away" is rude, and "You''re welcome" answers "thank you", not an offer.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63a6c5f6-391f-5f6b-9161-725a59477e22', 'b1897c4b-d452-58ec-b21e-572213df0515', 'In which word is the letter ''b'' silent?', '[{"id":"a","text":"banana"},{"id":"b","text":"bread"},{"id":"c","text":"lamb"},{"id":"d","text":"table"}]'::jsonb, 'c', 'In "lamb" the final b is written but not pronounced — we say /læm/, exactly like in "climb" and "comb" ✓. The trap is trusting the spelling: in "banana", "bread" and "table" the b is clearly pronounced, because the silent b appears mainly at the END of a word after m.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5683040-9ec1-5e4f-90a2-8d86d4f46997', 'b1897c4b-d452-58ec-b21e-572213df0515', 'Complete: "Where is Lucy?" — "She ___ in the sea now. She loves ___."', '[{"id":"a","text":"is swimming … swimming"},{"id":"b","text":"is swimming … swim"},{"id":"c","text":"swims … swimming"},{"id":"d","text":"swims … swim"}]'::jsonb, 'a', 'Two rules combine: "now" needs the present progressive with a double m (she is swimming), and after "love" the activity takes -ing (she loves swimming) ✓. The common trap is getting only one rule right: "swims" is a habit form that cannot go with "now", and "she loves swim" forgets the -ing after love.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7b397c80-e6a4-51cd-adae-ca0ffb5402f6', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '📝 Training ⭐⭐⭐: Module Two round-up (exam style)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75b86551-3bcd-5911-8730-e3f0db296156', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', 'Complete: "At the airport, you show your ___ to the policeman."', '[{"id":"a","text":"luggage"},{"id":"b","text":"passport"},{"id":"c","text":"taxi"},{"id":"d","text":"trolley"}]'::jsonb, 'b', 'The document you show to the policeman at the airport is your passport. Your luggage is your bags, a trolley is the small cart that carries them, and a taxi is the car you take after the airport.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63fc993e-3057-5af9-914c-913b48c1372f', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', 'Complete the short answer: "Is Lina helping her mother in the kitchen?" — "Yes, she ___."', '[{"id":"a","text":"does"},{"id":"b","text":"has"},{"id":"c","text":"helps"},{"id":"d","text":"is"}]'::jsonb, 'd', 'A short answer repeats the auxiliary of the question. The question starts with "Is", so the answer is "Yes, she is." The common trap is "Yes, she does" — that matches a simple present question (Does she help…?), not a progressive one, and we never repeat the full verb ("helps") in a short answer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('144a4f24-250f-51c0-b2fe-e35902c28c39', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', 'Complete: "Where is the taxi?" — "It is waiting ___ the airport door."', '[{"id":"a","text":"at"},{"id":"b","text":"in"},{"id":"c","text":"on"},{"id":"d","text":"under"}]'::jsonb, 'a', 'For an exact point we use "at": the taxi is waiting at the airport door. "In" is for a town or a space (in Sousse, in the garden), "on" is for a surface (on the table), and "under" means below something.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba0ed95a-8b52-5e94-b056-9663092f3bb5', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', '"Would you like to come to my house on Sunday?" — You accept. What do you say?', '[{"id":"a","text":"\"Good-bye!\""},{"id":"b","text":"\"I''m sorry, I can''t.\""},{"id":"c","text":"\"Yes, with pleasure! Thank you.\""},{"id":"d","text":"\"You''re welcome.\""}]'::jsonb, 'c', 'To accept an invitation warmly, say "Yes, with pleasure!" and thank your friend. "I''m sorry, I can''t" politely DECLINES the invitation, "You''re welcome" answers "thank you", and "Good-bye" is for taking leave.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a71f53c6-c1b7-50ab-bab0-2298e60fb0c3', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', 'Complete: "Granny ___ a big couscous in the kitchen. It smells delicious!"', '[{"id":"a","text":"is makeing"},{"id":"b","text":"is making"},{"id":"c","text":"makes"},{"id":"d","text":"making"}]'::jsonb, 'b', 'The scene is happening now, so we use the present progressive, and verbs ending in -e drop it before -ing: make → making → she is making ✓. The common trap is "is makeing", which keeps the -e. "Makes" is the habit form, and "making" alone has no verb "be".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c8c3669-798c-5f04-a772-d0f401e2259b', '7b397c80-e6a4-51cd-adae-ca0ffb5402f6', 'Choose the correct sentence.', '[{"id":"a","text":"Listen! The baby cries."},{"id":"b","text":"Listen! The baby cry now."},{"id":"c","text":"Listen! The baby is crying."},{"id":"d","text":"The baby is crying every night."}]'::jsonb, 'c', '"Listen!" points to this moment, so the present progressive is needed: The baby is crying ✓. The common trap is mixing tense and signal: "The baby cries" is a habit form after "Listen!", "is crying every night" puts the now-tense with a habit signal, and "the baby cry now" has no correct verb form at all.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('283f3731-6d05-5c87-a5d7-5fc57879b375', '3a82c877-d63f-5a91-a131-5552717b5819', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of Module Two', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b548ac1-84d1-5538-b461-3e46ce91d9f3', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Read the text: "(1) It is Sunday morning at the Trabelsi house. (2) Salma is watering the flowers in the garden. (3) Youssef and Anis is washing the car. (4) Their parents are preparing lunch." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 has the mistake: this question asks you to find the faulty sentence. "Youssef and Anis is washing" is wrong: two people together = they, and the progressive needs the plural auxiliary — Youssef and Anis ARE washing the car ✓. Sentences 1, 2 and 4 correctly use "is" with one subject and "are" with a plural one.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8646e145-fbf2-5588-8a07-822e2716e414', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Turn into a yes/no question: "Karim is flying his kite in the garden."', '[{"id":"a","text":"Is Karim flying his kite in the garden?"},{"id":"b","text":"Is Karim flies his kite in the garden?"},{"id":"c","text":"Does Karim flying his kite in the garden?"},{"id":"d","text":"Karim is flying his kite in the garden?"}]'::jsonb, 'a', 'In the present progressive, the question is made by moving "be" before the subject and keeping the -ing: Is Karim flying…? ✓ The common traps are all here: adding "does" (that belongs to the simple present), changing the verb to "flies" after "is", and leaving the sentence without inversion, with only a question mark.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fdd3578-2089-5c01-a6ad-51937efa9b46', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Complete the airport dialogue: "___ I take your suitcase, madam?" — "___ you very much, young man."', '[{"id":"a","text":"Am … Please"},{"id":"b","text":"Can … Thank"},{"id":"c","text":"Can … Welcome"},{"id":"d","text":"Do … Thank"}]'::jsonb, 'b', 'Two functions work together: a polite offer of help uses "Can I…?" (Can I take your suitcase?), and the lady thanks him with "Thank you very much" ✓. "Do I take…?" and "Am I take…?" are not correct request forms, and "Welcome you very much" is not English — "You''re welcome" is only the REPLY to a thank-you.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d45ad1a-7e39-5120-841d-488088750890', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Complete: "The cat is drinking ___ milk near the kitchen door."', '[{"id":"a","text":"it"},{"id":"b","text":"it''s"},{"id":"c","text":"its"},{"id":"d","text":"their"}]'::jsonb, 'c', 'The possessive adjective for "it" (an animal or a thing) is "its", written WITHOUT an apostrophe: the cat is drinking its milk ✓. The common trap is "it''s", which means "it is" — "the cat is drinking it is milk" makes no sense. "It" alone is a pronoun, not a possessive, and "their" is for a plural owner.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9b261d1-a48f-5b86-a3e4-f1be08f04bd3', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Complete: "Mmm! The couscous ___ delicious, Mrs Trabelsi!" — "Thank you, Tom."', '[{"id":"a","text":"is smelling"},{"id":"b","text":"smell"},{"id":"c","text":"smelling"},{"id":"d","text":"smells"}]'::jsonb, 'd', 'Verbs like "smell", "like" and "love" stay in the simple present even at this moment: The couscous smells delicious ✓ — this is the set phrase for expressing appreciation. The common trap is "is smelling": after a whole chapter of -ing forms, students put every verb in the progressive, but these verbs describe a state, not an action. "Smell" forgets the -s of he/she/it.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d0a4db3-aee9-58b4-8a4b-e22e8c76483f', '283f3731-6d05-5c87-a5d7-5fc57879b375', 'Complete Tom''s postcard: "Dear Grandma, Tunisia is wonderful. Right now, I ___ on the beach and Lucy ___ photos."', '[{"id":"a","text":"am sitting … is taking"},{"id":"b","text":"am sitting … taking"},{"id":"c","text":"is sitting … is taking"},{"id":"d","text":"sit … takes"}]'::jsonb, 'a', '"Right now" needs the present progressive for BOTH subjects, each with its own auxiliary: I AM sitting (with the double t) and Lucy IS taking ✓. The common trap is dropping the second auxiliary ("Lucy taking") or using "is" with "I". "Sit … takes" is the simple present, impossible with "right now".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a2169252-3a38-5465-939b-956957c79a10', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0364601-bdb2-56de-a9c7-3fc4c76e7335', 'a2169252-3a38-5465-939b-956957c79a10', 'Complete: "___ a big garden behind Uncle Ridha''s house."', '[{"id":"a","text":"There are"},{"id":"b","text":"There is"},{"id":"c","text":"There am"},{"id":"d","text":"There be"}]'::jsonb, 'b', '"A big garden" is one thing (singular), so we use "there is": There is a big garden. "There are" is only for plural things, and "there am / there be" are not correct English forms.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9f8d872-51c0-5275-95ee-1be82c3a9802', 'a2169252-3a38-5465-939b-956957c79a10', 'Complete: "One child is playing, and two ___ are watching."', '[{"id":"a","text":"child"},{"id":"b","text":"childs"},{"id":"c","text":"children"},{"id":"d","text":"childrens"}]'::jsonb, 'c', 'The plural of "child" is irregular: one child, two children. "Childs" and "childrens" do not exist, and "child" is the singular, which cannot follow "two".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49259319-3289-541e-a620-ac024422bde0', 'a2169252-3a38-5465-939b-956957c79a10', 'Complete: "The little table is ___ the two beds."', '[{"id":"a","text":"in"},{"id":"b","text":"on"},{"id":"c","text":"next to"},{"id":"d","text":"between"}]'::jsonb, 'd', 'When something is in the middle of exactly two things, we use "between": between the two beds. "In" means inside, "on" means on top of, and "next to" means beside just one thing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c429c8b8-45ae-580d-8a1c-d52dfd6b5b3d', 'a2169252-3a38-5465-939b-956957c79a10', 'Complete: "Nour eats ___ apple every morning."', '[{"id":"a","text":"an"},{"id":"b","text":"a"},{"id":"c","text":"the"},{"id":"d","text":"any"}]'::jsonb, 'a', '"Apple" begins with a vowel sound, so we use "an": an apple. "A" is for consonant sounds (a banana), "the" points to one specific apple, and "any" is used in questions and negatives.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95e4c703-8011-5801-983f-c0b664a54707', 'a2169252-3a38-5465-939b-956957c79a10', 'This schoolbag belongs to Karim. Choose the correct sentence.', '[{"id":"a","text":"It is Karims schoolbag."},{"id":"b","text":"It is Karim''s schoolbag."},{"id":"c","text":"It is Karims'' schoolbag."},{"id":"d","text":"It is Karim schoolbag."}]'::jsonb, 'b', 'To show possession by one person, we add apostrophe + s to the owner''s name: Karim''s schoolbag. "Karims" forgets the apostrophe, "Karims''" puts it in the wrong place (that is for plural owners), and "Karim schoolbag" has no genitive at all.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50aaf125-34a2-5a10-974c-864ce623413f', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '⭐ Practice: welcome to my home', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c4b068b-0bcb-5048-9c7b-933945cef823', '50aaf125-34a2-5a10-974c-864ce623413f', 'Complete: "There ___ a big kitchen in our house."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"has"},{"id":"d","text":"be"}]'::jsonb, 'a', '"A big kitchen" is one thing, so we use "there is": there is a big kitchen. "There are" is for plural, and "there has / there be" are not correct.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e56b5783-f4d9-5cef-9d8f-8366439e205c', '50aaf125-34a2-5a10-974c-864ce623413f', 'Complete: "There ___ three bedrooms upstairs."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"have"},{"id":"d","text":"be"}]'::jsonb, 'b', '"Three bedrooms" is plural, so we use "there are": there are three bedrooms. Saying "there is three bedrooms" is a common mistake — a plural needs "are".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('354cd450-ef55-54a5-804d-ea64eb272696', '50aaf125-34a2-5a10-974c-864ce623413f', 'Which piece of furniture do you sleep in?', '[{"id":"a","text":"a bed"},{"id":"b","text":"a carpet"},{"id":"c","text":"a sofa"},{"id":"d","text":"a wardrobe"}]'::jsonb, 'a', 'You sleep in a bed. A carpet covers the floor, a sofa is for sitting in the living room, and a wardrobe is where you keep your clothes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a8d3324-e0ed-5308-a9f1-55ffe64d81aa', '50aaf125-34a2-5a10-974c-864ce623413f', 'Complete with a subject pronoun: "My mother is in the kitchen. ___ is cooking lunch."', '[{"id":"a","text":"He"},{"id":"b","text":"She"},{"id":"c","text":"It"},{"id":"d","text":"They"}]'::jsonb, 'b', '"My mother" is one woman, so the subject pronoun is "she": she is cooking. "He" is for a man, "it" is for a thing, and "they" is for two or more.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a09cad6-c347-5663-82b1-1737f8480cb7', '50aaf125-34a2-5a10-974c-864ce623413f', 'Complete: "The plates are ___ the table."', '[{"id":"a","text":"in"},{"id":"b","text":"near"},{"id":"c","text":"on"},{"id":"d","text":"between"}]'::jsonb, 'c', 'The plates are on top of the table, so we use "on": on the table. "In" means inside, "near" means close to, and "between" needs two things on each side.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d846f6e-7060-54e6-a6ee-e8e8e6c411d3', '50aaf125-34a2-5a10-974c-864ce623413f', 'Complete: "I want to buy one dress, but my sister wants two ___."', '[{"id":"a","text":"dress"},{"id":"b","text":"dresss"},{"id":"c","text":"dreses"},{"id":"d","text":"dresses"}]'::jsonb, 'd', 'A noun ending in -ss adds -es in the plural: one dress, two dresses. "Dress" is the singular, and "dresss / dreses" are wrong spellings — the rule is add -es after -s, -sh, -ch and -x.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d4f165eb-93ab-5d87-8473-a36c3e993fd0', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '⚔️ Chapter boss ⭐⭐⭐: my home and my family''s things', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3939b95a-4b82-5b16-a25d-97386204cf65', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', 'Complete: "In the living room there ___ a sofa, two armchairs and a carpet."', '[{"id":"a","text":"is"},{"id":"b","text":"are"},{"id":"c","text":"have"},{"id":"d","text":"be"}]'::jsonb, 'a', 'In a list, the verb follows the FIRST noun. Here the list starts with "a sofa" (singular), so we use "there is": there is a sofa, two armchairs and a carpet. The common trap is looking at "two armchairs" and choosing "are" — but the first item decides.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f451e1b0-5d92-5c61-a614-1773d5805d88', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', 'Complete: "Sami and Nour are my friends. I visit ___ every Friday, and ___ visit me too."', '[{"id":"a","text":"they … them"},{"id":"b","text":"them … they"},{"id":"c","text":"they … they"},{"id":"d","text":"them … them"}]'::jsonb, 'b', 'After the verb "visit", the object pronoun is "them" (I visit them). Before the verb "visit", the subject pronoun is "they" (they visit me). The common trap is mixing them up: the doer is a subject (they), the receiver is an object (them).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42ce5548-d525-5f69-aa01-cb35efb90d7f', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', '"The bedroom of my two sisters" — choose the correct genitive form: "my ___ bedroom."', '[{"id":"a","text":"sister''s"},{"id":"b","text":"sisters"},{"id":"c","text":"sisters''"},{"id":"d","text":"sisters''s"}]'::jsonb, 'c', 'There are two sisters (a plural owner ending in -s), so the apostrophe goes AFTER the -s: my sisters'' bedroom ✓. "Sister''s" means only one sister, and "sisters / sisters''s" are wrong forms for a plural owner.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a115bde-b18c-505a-9d71-aa928a18abe4', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', 'Complete: "Yesterday I bought ___ shirt. ___ shirt is dark blue."', '[{"id":"a","text":"The … a"},{"id":"b","text":"a … a"},{"id":"c","text":"The … The"},{"id":"d","text":"a … The"}]'::jsonb, 'd', 'The first time you mention something new, use "a": I bought a shirt. The second time, you both know which shirt, so use "the": The shirt is dark blue ✓. The common trap is starting with "the" for something the listener does not know yet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06d7bbd9-4426-55b4-bcde-b4c52e4a445c', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', 'On a shelf, the clock is on the left and the vase is on the right. Where is the photo, if it sits exactly between them?', '[{"id":"a","text":"in the middle"},{"id":"b","text":"near"},{"id":"c","text":"between"},{"id":"d","text":"next to"}]'::jsonb, 'a', 'The photo is in the centre of the shelf, so we say it is "in the middle" ✓. "Between" would need to name two things (between the clock and the vase); on its own it is incomplete, and "near / next to" only say it is close to something.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e90369a2-4a60-54b9-bc85-536198cb5d8b', 'd4f165eb-93ab-5d87-8473-a36c3e993fd0', 'Complete: "There ___ five ___ playing in the yard."', '[{"id":"a","text":"is … children"},{"id":"b","text":"are … children"},{"id":"c","text":"are … childs"},{"id":"d","text":"are … childrens"}]'::jsonb, 'b', '"Five children" is plural, so we need "there are" ✓, and the plural of child is the irregular "children". The traps: "there is" does not agree with a plural, while "childs" and "childrens" are impossible forms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '⭐⭐ Review (exam style): home, farm and market', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71f8c98a-873e-5435-8f43-99be02ee2f28', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete the question: "___ ? — It''s big and modern."', '[{"id":"a","text":"What''s your new house like"},{"id":"b","text":"How''s your new house like"},{"id":"c","text":"What''s your new house as"},{"id":"d","text":"Where''s your new house like"}]'::jsonb, 'a', 'To ask for a description, use "What''s … like?": What''s your new house like? The answer "It''s big and modern" describes it. "How''s … like" and "What''s … as" are not correct, and "Where" would ask about a place, not a description.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e90d66c9-c99d-5122-a49e-6d4de05e8a67', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete with a pronoun: "Karim is a good friend. I always play with ___."', '[{"id":"a","text":"he"},{"id":"b","text":"him"},{"id":"c","text":"his"},{"id":"d","text":"her"}]'::jsonb, 'b', 'After the preposition "with", we use the object pronoun "him": play with him ✓. "He" is a subject pronoun (he plays), "his" shows possession (his ball), and "her" is for a girl.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97339513-bce3-5f70-a6a0-2a03da1cda76', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete: "On the plate there is ___ orange and ___ banana."', '[{"id":"a","text":"a … an"},{"id":"b","text":"an … a"},{"id":"c","text":"a … a"},{"id":"d","text":"an … an"}]'::jsonb, 'b', '"Orange" starts with a vowel sound → an orange; "banana" starts with a consonant sound → a banana. So it is "an orange and a banana" ✓. The trap is choosing the article by the noun''s meaning instead of its first sound.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f91a34fa-d076-5053-a31f-f3cb00554be6', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete the question: "___ is your birthday party?" — "On Saturday."', '[{"id":"a","text":"When"},{"id":"b","text":"What"},{"id":"c","text":"Where"},{"id":"d","text":"How"}]'::jsonb, 'a', 'The answer "On Saturday" gives a time/day, so the question word is "When": When is your party? "What" asks about a thing, "Where" about a place, and "How" about a way or condition.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55d5bb1d-baa6-5276-9c31-90e850659ac5', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete: "I love Uncle Ridha''s farm ___ there are many animals."', '[{"id":"a","text":"and"},{"id":"b","text":"but"},{"id":"c","text":"because"},{"id":"d","text":"then"}]'::jsonb, 'c', 'The second part gives the REASON for loving the farm, so we use "because": I love the farm because there are many animals ✓. "And" just adds, "but" shows a contrast, and "then" shows the next step in time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e259439-48ac-58e1-b717-d875b4d6375b', '76b09a3a-d5f2-5406-91ca-b99c8deb02e4', 'Complete: "There is one man at the stall now, but at noon there are three ___."', '[{"id":"a","text":"man"},{"id":"b","text":"mans"},{"id":"c","text":"mens"},{"id":"d","text":"men"}]'::jsonb, 'd', 'The plural of "man" is irregular: one man, three men ✓. "Man" is the singular, and "mans / mens" do not exist — you simply learn man → men by heart.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c7b8334d-9545-5271-889a-1819cad03a16', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: master of home and market', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d12d471d-9d7f-555d-98e4-e36e48155f6e', 'c7b8334d-9545-5271-889a-1819cad03a16', 'Complete with pronouns: "Nour has got a new bike. She rides ___ to the market and locks ___ near the shop."', '[{"id":"a","text":"it … it"},{"id":"b","text":"them … it"},{"id":"c","text":"it … them"},{"id":"d","text":"her … it"}]'::jsonb, 'a', '"A bike" is one thing, so both times we replace it with the object pronoun "it": she rides it … locks it ✓. "Them" is for plural objects, and "her" is for a girl, not for a bike.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ea85799-73ad-55e1-b293-428f0105a1ad', 'c7b8334d-9545-5271-889a-1819cad03a16', 'What does "my brothers'' room" mean?', '[{"id":"a","text":"the room of one brother"},{"id":"b","text":"the room of two or more brothers"},{"id":"c","text":"the brother of the room"},{"id":"d","text":"two rooms"}]'::jsonb, 'b', 'The apostrophe AFTER the -s (brothers'') shows a plural owner, so it is the room of two or more brothers ✓. If it were one brother, we would write "my brother''s room" with the apostrophe before the -s. The position of the apostrophe tells you how many owners there are.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9efc740-5b72-5f7f-9e8c-9d5c3af62345', 'c7b8334d-9545-5271-889a-1819cad03a16', 'One sentence has a mistake. Which one? (1) There are five rooms in our house. (2) The kitchen is next to the living room. (3) My parents room is upstairs. (4) I share my bedroom with my sister.', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 is the faulty one. "My parents room" needs a genitive apostrophe: the room belongs to the parents, so it must be "my parents'' room" ✓. Sentences 1, 2 and 4 correctly use "there are", "next to" and "my bedroom".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a87c4a70-2df9-5348-b75e-f3da80ef37d8', 'c7b8334d-9545-5271-889a-1819cad03a16', 'Complete: "She wears ___ uniform, and ___ hour later she leaves for school."', '[{"id":"a","text":"an … a"},{"id":"b","text":"a … a"},{"id":"c","text":"an … an"},{"id":"d","text":"a … an"}]'::jsonb, 'd', 'It is the SOUND that decides. "Uniform" starts with a /j/ sound ("you-niform"), a consonant sound → a uniform; "hour" has a silent h and starts with a vowel sound → an hour. So: a uniform … an hour ✓. The common trap is choosing by the letter (u, h) instead of the sound.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ef1c40e-3604-5ab0-ab69-2bb3cef21c73', 'c7b8334d-9545-5271-889a-1819cad03a16', 'Complete: "In Nour''s bedroom there ___ a bed near the window, and between the bed and the door there ___ a small carpet."', '[{"id":"a","text":"are … are"},{"id":"b","text":"is … is"},{"id":"c","text":"is … are"},{"id":"d","text":"are … is"}]'::jsonb, 'b', '"A bed" and "a small carpet" are each one thing (singular), so both blanks take "there is": there is a bed … there is a small carpet ✓. The common trap is using "there are" because two objects are described — but each one is singular, so each needs "is".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a27e1e55-9b87-5d10-aedd-fef9266df704', 'c7b8334d-9545-5271-889a-1819cad03a16', 'Complete: "One ___ carries a bag. Many ___ carry bags. These are the ___ bags."', '[{"id":"a","text":"person … people … people''s"},{"id":"b","text":"person … persons … persons''"},{"id":"c","text":"person … people … peoples''"},{"id":"d","text":"person … persons … people''s"}]'::jsonb, 'a', 'The everyday plural of "person" is the irregular "people": one person, many people ✓. Its genitive adds apostrophe + s like any irregular plural: the people''s bags. "Persons" is very formal/rare, and "peoples''" puts the apostrophe wrongly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6fc2acf0-a631-5361-846f-1cd988167f04', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '📝 Training ⭐⭐⭐: full review of Module Three', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cae52785-790e-5c2b-935a-11f9bb0b8931', '6fc2acf0-a631-5361-846f-1cd988167f04', 'Complete the question: "___ is your new dress?" — "It''s pink and white."', '[{"id":"a","text":"What colour"},{"id":"b","text":"How old"},{"id":"c","text":"What time"},{"id":"d","text":"How many"}]'::jsonb, 'a', 'The answer names colours (pink and white), so the question asks "What colour": What colour is your dress? "How old" asks about age, "What time" about the clock, and "How many" about a number of things.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bac32162-7022-5e58-85bd-56beb0841640', '6fc2acf0-a631-5361-846f-1cd988167f04', 'Complete: "First we light the candles, ___ we blow them out."', '[{"id":"a","text":"but"},{"id":"b","text":"because"},{"id":"c","text":"near"},{"id":"d","text":"then"}]'::jsonb, 'd', 'The two actions happen one after the other, so we use "then" to show the next step: first we light the candles, then we blow them out ✓. "But" shows a contrast, "because" a reason, and "near" is a preposition of place, not a linker.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('428fc80c-2af7-579e-a615-5b6fb81eb4e9', '6fc2acf0-a631-5361-846f-1cd988167f04', 'One sentence has a mistake. Which one? (1) There are many fruits at the market. (2) Me like strawberries very much. (3) My mother buys apples and figs. (4) We eat them at home.', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'b', 'Sentence 2 is the faulty one. "Me" is an object pronoun and cannot be the subject of a verb: it must be "I like strawberries very much" ✓. Sentences 1, 3 and 4 correctly use "there are", the simple present, and the object pronoun "them".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d7b5021-350d-5cb2-97f2-e5fc2ff48b1f', '6fc2acf0-a631-5361-846f-1cd988167f04', 'Complete: "___ market is near ___ big mosque in our town."', '[{"id":"a","text":"A … a"},{"id":"b","text":"A … the"},{"id":"c","text":"The … the"},{"id":"d","text":"The … a"}]'::jsonb, 'c', 'Both places are specific, well-known places in the town that the speaker and listener both know, so we use "the" for each: The market is near the big mosque ✓. "A / an" would introduce them as new, unknown things, which does not fit "our town".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a18f423b-5eb8-5501-866a-d749e012c6c3', '6fc2acf0-a631-5361-846f-1cd988167f04', 'Rewrite "the toys of the children" with a genitive: "the ___ toys."', '[{"id":"a","text":"childrens''"},{"id":"b","text":"children''s"},{"id":"c","text":"childs''"},{"id":"d","text":"children"}]'::jsonb, 'b', '"Children" is an irregular plural, so its genitive adds apostrophe + s, like a singular owner: the children''s toys ✓. "Childrens''" is wrong because "childrens" does not exist, "childs''" uses a non-existent plural, and "children" alone shows no possession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c72fbdbe-ab31-59c5-854f-85d6d6ee3182', '6fc2acf0-a631-5361-846f-1cd988167f04', 'Complete: "There ___ two markets ___ my town: one near the beach and one in the centre."', '[{"id":"a","text":"are … in"},{"id":"b","text":"is … in"},{"id":"c","text":"are … on"},{"id":"d","text":"are … at"}]'::jsonb, 'a', '"Two markets" is plural → there are; and for a town (an area) we use "in": there are two markets in my town ✓. "There is" does not agree with a plural, and "on / at my town" are the wrong prepositions for a place this size.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'f5f4d771-26e7-5005-b86d-ca479aae4279', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of Module Three', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b1147bb-88c0-555d-bc96-538191baf969', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'Which question asks someone to DESCRIBE the market?', '[{"id":"a","text":"What is the market like?"},{"id":"b","text":"What does the market like?"},{"id":"c","text":"How the market is?"},{"id":"d","text":"What the market likes?"}]'::jsonb, 'a', 'To ask for a description we use "What … like?": What is the market like? — It''s big and busy ✓. In (b) and (d) "like" is treated as the verb (tastes), which is wrong here, and (c) has the wrong word order for a question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2a447cc-a83f-5101-896e-d652cf0471ea', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'Picture: a table in the middle of the room, a chair on its left, a plant on its right, and a clock on the wall between two windows. Which sentence is TRUE?', '[{"id":"a","text":"The chair is on the right of the table."},{"id":"b","text":"The plant is on the left of the table."},{"id":"c","text":"The clock is between two windows."},{"id":"d","text":"The table is near the door."}]'::jsonb, 'c', 'Read the layout carefully. The clock sits between two windows, so sentence (c) is true ✓. The chair is on the LEFT (not the right), the plant is on the RIGHT (not the left), and the table is in the MIDDLE of the room (not near the door).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e67e3f2d-c199-59d3-957b-665464d5e5b8', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'Complete with pronouns: "Karim and I love football. ___ play every day, and our friends watch ___."', '[{"id":"a","text":"Us … we"},{"id":"b","text":"We … us"},{"id":"c","text":"We … we"},{"id":"d","text":"Us … us"}]'::jsonb, 'b', '"Karim and I" is the subject that plays, so we use "we": We play every day. After the verb "watch", we are the object, so we use "us": our friends watch us ✓. The common trap is using the object "us" as a subject — the doer is always a subject pronoun.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9872abb-4daa-5cad-9fb2-12259282da60', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'How do you say "the schoolbag that belongs to Sami" in natural English?', '[{"id":"a","text":"the schoolbag of Sami"},{"id":"b","text":"Sami schoolbag''s"},{"id":"c","text":"the Sami schoolbag"},{"id":"d","text":"Sami''s schoolbag"}]'::jsonb, 'd', 'For a person who owns something, English uses the genitive: Sami''s schoolbag ✓. "The schoolbag of Sami" is understandable but unnatural for a person, "Sami schoolbag''s" puts the ''s on the wrong word, and "the Sami schoolbag" has no genitive.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b03f8fc-4161-5e82-8e5e-12af50d59e28', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'Complete: "I want the blue jacket ___ it is warm, ___ it is too expensive for me."', '[{"id":"a","text":"because … but"},{"id":"b","text":"but … because"},{"id":"c","text":"and … then"},{"id":"d","text":"then … and"}]'::jsonb, 'a', 'The first blank gives the REASON I want it (because it is warm), and the second shows a CONTRAST (but it is too expensive). So: because … but ✓. Swapping them ("but … because") reverses the logic, and "and/then" do not express reason or contrast.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f31777a-83d2-531a-8da3-7868e104a981', '5dcb6ff9-d6e5-5897-a40c-ce9cbd986eda', 'Which sentence is completely correct?', '[{"id":"a","text":"There are a farmer and three goats on the farm."},{"id":"b","text":"There is a farmer and three goats on the farm."},{"id":"c","text":"There is a farmer and three goat on the farm."},{"id":"d","text":"There is an farmer and three goats on the farm."}]'::jsonb, 'b', 'Three things must be right at once: the list starts with "a farmer" (singular) → there is; "farmer" starts with a consonant sound → a farmer; "goats" is a plain plural. Only (b) has all three ✓. (a) uses "are" with a singular first item, (c) forgets the plural "goats", and (d) uses "an" before a consonant sound.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c3def0e4-6783-5b62-981e-d0d502161dbe', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b427aa2-15f7-5799-a231-4510424e0922', 'c3def0e4-6783-5b62-981e-d0d502161dbe', 'The floor is wet. Choose the correct warning: "___, Yasmine!"', '[{"id":"a","text":"Be care"},{"id":"b","text":"Be careful"},{"id":"c","text":"Be carefully"},{"id":"d","text":"Careful be"}]'::jsonb, 'b', 'The warning uses the adjective "careful" after "be": Be careful! "Be carefully" wrongly adds -ly, "be care" uses the noun, and "careful be" puts the words in the wrong order.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b666cff-c256-52be-974b-09c0bfdb06d2', 'c3def0e4-6783-5b62-981e-d0d502161dbe', 'Complete the warning: "___ play with matches. They are dangerous."', '[{"id":"a","text":"Do not"},{"id":"b","text":"Doesn''t"},{"id":"c","text":"No"},{"id":"d","text":"Not"}]'::jsonb, 'a', 'A negative order uses "Do not" (or "Don''t") + base verb: Do not play with matches. "No play", "Not play" and "Doesn''t play" are not correct ways to give an order in English.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee33d38d-6bd6-59c3-9b50-7c52921c8e3f', 'c3def0e4-6783-5b62-981e-d0d502161dbe', 'Complete: "You ___ wear a helmet when you ride your bike."', '[{"id":"a","text":"must"},{"id":"b","text":"musts"},{"id":"c","text":"must to"},{"id":"d","text":"are must"}]'::jsonb, 'a', 'Obligation uses "must" + base verb, with no -s and no "to": You must wear a helmet. "Must to", "musts" and "are must" are all impossible forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bf7ba30-72d9-54fb-930b-2e1631ac82e6', 'c3def0e4-6783-5b62-981e-d0d502161dbe', 'Complete: "There isn''t ___ milk in the fridge."', '[{"id":"a","text":"many"},{"id":"b","text":"much"},{"id":"c","text":"some"},{"id":"d","text":"a lot"}]'::jsonb, 'b', '"Milk" is a thing you cannot count, so it takes "much", often in negative sentences: there isn''t much milk. "Many" goes with countable things like eggs or sweets.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9411d40-73e5-575d-8ea6-5bf93e294824', 'c3def0e4-6783-5b62-981e-d0d502161dbe', 'Which adjective comes from the noun "snow"?', '[{"id":"a","text":"snowed"},{"id":"b","text":"snowly"},{"id":"c","text":"snows"},{"id":"d","text":"snowy"}]'::jsonb, 'd', 'Weather adjectives are built with Noun + y: snow becomes snowy, like sun → sunny and rain → rainy. "Snowly" invents an -ly ending, and "snowed" / "snows" are verb forms, not adjectives.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('41638fc1-7038-5c31-913f-26c55119e3a6', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '⭐ Practice: the safety patrol', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50a54102-b98b-53fc-8c5f-c4558debf6b3', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Your little brother is walking towards a very hot oven. What do you say?', '[{"id":"a","text":"\"Be careful! It''s hot!\""},{"id":"b","text":"\"Be carefully! It''s hot!\""},{"id":"c","text":"\"That''s great! It''s hot!\""},{"id":"d","text":"\"What about hot?\""}]'::jsonb, 'a', 'To warn someone about danger, say "Be careful!" — "careful" is an adjective after "be". "Be carefully" wrongly adds -ly, "That''s great!" shows approval, and "What about…?" makes a suggestion, not a warning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0c6ab19-630c-5dee-9e4d-aa32b19adfdc', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Complete the warning: "Don''t ___ the sharp knife!"', '[{"id":"a","text":"touch"},{"id":"b","text":"touches"},{"id":"c","text":"touching"},{"id":"d","text":"to touch"}]'::jsonb, 'a', 'After "Don''t" we always use the base verb: Don''t touch! "Touches" adds an -s, "touching" adds -ing, and "to touch" adds "to" — none of these follow "don''t" in an order.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02a14766-8f1e-5cb6-9fd9-dce016077a09', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Complete the traffic rule: "You ___ cross the street when the light is red for you."', '[{"id":"a","text":"must"},{"id":"b","text":"mustn''t"},{"id":"c","text":"must to"},{"id":"d","text":"don''t must"}]'::jsonb, 'b', 'Crossing on a red light is forbidden, so we use "mustn''t" (prohibition): you mustn''t cross. "Must" would make it an obligation to cross, and "must to" / "don''t must" are impossible forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b131bda6-b75c-5409-b76e-deb62286eca9', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Choose the correct prohibition:', '[{"id":"a","text":"You don''t must play near the road."},{"id":"b","text":"You mustn''t to play near the road."},{"id":"c","text":"You mustn''t play near the road."},{"id":"d","text":"You not must play near the road."}]'::jsonb, 'c', 'The negative of "must" is "mustn''t" + base verb: You mustn''t play near the road. "Don''t must" and "not must" build the negative the wrong way, and "mustn''t to" adds an extra "to".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('277f89ae-d362-5c3b-914d-0fcfab2f231f', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Sami fell off his bike and hurt a part of his body — now he cannot walk. Which part is it?', '[{"id":"a","text":"his ear"},{"id":"b","text":"his arm"},{"id":"c","text":"his hand"},{"id":"d","text":"his ankle"}]'::jsonb, 'd', 'The ankle joins the leg to the foot, so a hurt ankle stops you from walking. The ear, the arm and the hand are painful when hurt, but they do not stop you from walking.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7197ed3e-96f1-5b97-8a9e-6594f0a58455', '41638fc1-7038-5c31-913f-26c55119e3a6', 'Complete: "Take your umbrella! It is a ___ day."', '[{"id":"a","text":"rain"},{"id":"b","text":"rainy"},{"id":"c","text":"snowy"},{"id":"d","text":"sunny"}]'::jsonb, 'b', 'An umbrella means rain, and before the noun "day" we need the adjective rain + y = rainy: a rainy day. "Rain" is the noun, and a sunny or snowy day does not call for an umbrella.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '⚔️ Chapter boss ⭐⭐⭐: emergency at the clinic', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf8c05c4-b5fc-5d6e-a60b-fa1c4640df22', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'At the clinic, the doctor asks Anis: "What''s the matter?" What does the doctor want to know?', '[{"id":"a","text":"Anis''s address"},{"id":"b","text":"Anis''s age"},{"id":"c","text":"Anis''s name"},{"id":"d","text":"Anis''s problem"}]'::jsonb, 'd', '"What''s the matter?" asks about the problem: the doctor wants to know what hurts or what is wrong. Questions about the name, the age or the address use "What''s your name?", "How old are you?" and "Where do you live?".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('087b77c0-b970-5fa6-b28c-c68ee6526a24', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'Nour touched the hot iron and now her hand is red and painful. She has a ___ on her hand.', '[{"id":"a","text":"burn"},{"id":"b","text":"cut"},{"id":"c","text":"injection"},{"id":"d","text":"plaster"}]'::jsonb, 'a', 'Something very hot gives you a burn. A cut comes from something sharp like a knife, while a plaster and an injection are treatments the nurse gives you, not injuries.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23df7cb3-b7c1-568b-8d73-ad7a8675f0dd', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'Karim cut his finger on a pencil sharpener. The nurse cleans the small cut and puts a ___ on it.', '[{"id":"a","text":"injection"},{"id":"b","text":"leaflet"},{"id":"c","text":"medicine"},{"id":"d","text":"plaster"}]'::jsonb, 'd', 'A small cut gets a plaster to protect it. Medicine is something you drink or swallow, an injection is for serious cases, and a leaflet is only a paper with information.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49d95a0a-30c4-5b9c-9080-4ed547b218f7', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'Complete the doctor''s orders: "You ___ take this medicine every morning, and you ___ forget it."', '[{"id":"a","text":"must … must"},{"id":"b","text":"must … mustn''t"},{"id":"c","text":"mustn''t … must"},{"id":"d","text":"mustn''t … mustn''t"}]'::jsonb, 'b', 'Taking the medicine is an obligation → "you must take it"; forgetting it is what you are NOT allowed to do → "you mustn''t forget it" ✓. The common trap is reading only the first blank: the two verbs need opposite ideas — obligation first, prohibition second.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8d665e0-e53b-5c7a-9e6c-9fe797ebd80b', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'In which word is the letter "t" silent?', '[{"id":"a","text":"doctor"},{"id":"b","text":"hospital"},{"id":"c","text":"listen"},{"id":"d","text":"matter"}]'::jsonb, 'c', 'In "listen" the t is silent — you say /ˈlɪsn/, with no t sound at all ✓. The common trap is trusting the spelling: in "doctor", "hospital" and "matter" the t is written AND clearly pronounced.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a87c2e32-f4ae-5022-8a25-e5b71fca02b6', '0d2a74f0-abcc-5bd0-a4f5-8dcfa8189c16', 'Which word has the sound /aʊ/, as in "out"?', '[{"id":"a","text":"mouth"},{"id":"b","text":"soup"},{"id":"c","text":"touch"},{"id":"d","text":"young"}]'::jsonb, 'a', '"Mouth" has the sound /aʊ/, exactly like "out", "down" and "shout" ✓. The common trap is the spelling "ou": in "touch" and "young" the same letters are pronounced /ʌ/, and in "soup" they are /uː/ — English letters and sounds do not always match.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dfce81bc-6849-54c7-9788-287e89910be7', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '⭐⭐ Review (exam style): safe, healthy and ready', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1d40dc9-727c-53e8-8f68-b2f022033711', 'dfce81bc-6849-54c7-9788-287e89910be7', 'You want to leave the classroom. How do you ask the teacher for permission?', '[{"id":"a","text":"\"Can go I out, please?\""},{"id":"b","text":"\"Can I go out, please?\""},{"id":"c","text":"\"Can I to go out, please?\""},{"id":"d","text":"\"I can go out, please?\""}]'::jsonb, 'b', 'Permission uses the question order Can + I + base verb: Can I go out, please? "Can go I" breaks the word order, "Can I to go" adds an extra "to", and "I can go out" is a statement, not a question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6405f8b-587a-5ca7-8752-2e0ab24ff589', 'dfce81bc-6849-54c7-9788-287e89910be7', 'Give your little sister advice: "___ your teeth after every meal."', '[{"id":"a","text":"Brush"},{"id":"b","text":"Brushes"},{"id":"c","text":"Brushing"},{"id":"d","text":"To brush"}]'::jsonb, 'a', 'Advice uses the imperative: the base verb with no subject — Brush your teeth. "Brushes" adds a third-person -s, and "Brushing" / "To brush" are not imperative forms.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a9753b7-5cf8-5ae6-afd4-2793830dd426', 'dfce81bc-6849-54c7-9788-287e89910be7', 'Complete the advice: "Don''t eat too ___ sweets before dinner."', '[{"id":"a","text":"many"},{"id":"b","text":"much"},{"id":"c","text":"some"},{"id":"d","text":"a lot"}]'::jsonb, 'a', '"Sweets" are things you can count (one sweet, two sweets), so they take "many": too many sweets. "Much" is for uncountable things like milk or bread, and "a lot" would need "of" after it.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40abaa5b-b842-5ede-885f-a533efee0e61', 'dfce81bc-6849-54c7-9788-287e89910be7', 'Complete the suggestion: "It''s sunny! ___ go to the beach."', '[{"id":"a","text":"Let"},{"id":"b","text":"Let is"},{"id":"c","text":"Let''s"},{"id":"d","text":"Let''s to"}]'::jsonb, 'c', 'A suggestion to do something together uses "Let''s" + base verb: Let''s go to the beach. "Let''s to go" adds an extra "to", and "Let" alone or "Let is" are not suggestion forms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ce3bc31-6775-50f1-be19-fddeb8b9a9f3', 'dfce81bc-6849-54c7-9788-287e89910be7', 'Complete the suggestion: "___ playing football after school?"', '[{"id":"a","text":"How about to"},{"id":"b","text":"Let''s"},{"id":"c","text":"Must we"},{"id":"d","text":"What about"}]'::jsonb, 'd', 'Before a verb in -ing, the suggestion is "What about…?": What about playing football? "Let''s" takes the base verb (Let''s play), "How about to" wrongly adds "to", and "must" expresses obligation, not a suggestion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db211a94-7c24-5e2b-949a-9432ae6bad78', 'dfce81bc-6849-54c7-9788-287e89910be7', 'Complete: "Yesterday, Karim ___ football with his friends in the park."', '[{"id":"a","text":"play"},{"id":"b","text":"played"},{"id":"c","text":"playing"},{"id":"d","text":"plays"}]'::jsonb, 'b', '"Yesterday" tells us the action is finished, so the regular verb takes -ed in the simple past: Karim played football. "Play" and "plays" are present forms, and "playing" needs an auxiliary before it.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: train like a champion', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42b6fef4-854e-53e6-bb5d-03f253f8efe9', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Choose the correct question about the weather:', '[{"id":"a","text":"How is the weather like?"},{"id":"b","text":"What does the weather like?"},{"id":"c","text":"What is the weather like?"},{"id":"d","text":"What the weather is like?"}]'::jsonb, 'c', 'The fixed question is "What is the weather like?" ✓. The common trap is mixing two questions into "How is the weather like?" — with "like" you must use "What". "What does the weather like?" treats "like" as a verb, and "What the weather is like?" forgets the question word order.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c823025b-c29d-5424-b04b-317501927224', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Complete: "Look at the sky! There are big grey clouds — it is very ___ today."', '[{"id":"a","text":"cloud"},{"id":"b","text":"clouded"},{"id":"c","text":"cloudly"},{"id":"d","text":"cloudy"}]'::jsonb, 'd', 'After "is very" we need the adjective, built with Noun + y: cloud → cloudy ✓. The common trap is inventing "cloudly" with -ly, which makes adverbs, not weather adjectives; "cloud" is the noun and "clouded" is a verb form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e261f3e4-7830-5332-b791-c83ffc088b12', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Read the coach''s poster: "(1) Let''s go jogging in the park. (2) You mustn''t to smoke. (3) Eat vegetables every day. (4) Don''t drink too much coke." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'b', 'Sentence 2 has the mistake: this question asks you to find the faulty sentence. "You mustn''t to smoke" is wrong: must and mustn''t are always followed by the base verb with NO "to" — you mustn''t smoke ✓. Sentences 1, 3 and 4 correctly use Let''s + verb, the imperative, and "too much" + coke (uncountable).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bcece81-98c1-5069-8406-93b76eaa6473', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Complete: "Yesterday, Meriem ___ an apple and ___ a glass of milk after sport."', '[{"id":"a","text":"ate … drank"},{"id":"b","text":"ate … drinked"},{"id":"c","text":"eated … drank"},{"id":"d","text":"eated … drinked"}]'::jsonb, 'a', '"Eat" and "drink" are both irregular: their simple past forms are ate and drank ✓. The common trap is adding -ed as if they were regular — "eated" and "drinked" do not exist; only regular verbs like "play → played" take -ed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2730fe1f-a2e8-5349-8df4-398794fd0042', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Choose the correct suggestion:', '[{"id":"a","text":"Let''s playing tennis."},{"id":"b","text":"Let''s to play tennis."},{"id":"c","text":"What about play tennis?"},{"id":"d","text":"What about playing tennis?"}]'::jsonb, 'd', '"What about" is followed by a verb in -ing: What about playing tennis? ✓ The common trap is swapping the two rules: Let''s takes the BASE verb (Let''s play), so "Let''s playing" and "Let''s to play" are wrong, and "What about play" forgets the -ing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b8d4dd7-dbfc-56ad-aba9-0bb0070af96c', '7dc24bd0-0d04-5ecd-a51f-35370ac0a86f', 'Which word is stressed on the SECOND syllable?', '[{"id":"a","text":"advise"},{"id":"b","text":"careful"},{"id":"c","text":"healthy"},{"id":"d","text":"sunny"}]'::jsonb, 'a', '"Advise" is stressed on the second syllable: ad-VISE ✓. The common trap is stressing every word on the first syllable — that works for CARE-ful, HEAL-thy and SUN-ny, but not for advise, so say each word aloud before you choose.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b6061f0a-dd0a-518d-bc3d-f8966af347d1', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '📝 Training ⭐⭐⭐: safe and fit — full review', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b68af97-c330-5a2e-9831-494c8a5fda7c', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'Complete: "How ___ water do you drink every day?"', '[{"id":"a","text":"many"},{"id":"b","text":"much"},{"id":"c","text":"some"},{"id":"d","text":"any"}]'::jsonb, 'b', '"Water" is a thing you cannot count one by one, so it takes "much": How much water do you drink? "Many" goes with countable things like eggs or apples, and "some"/"any" do not fit the "How ___" question about quantity.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e6fc1c3-5176-5ecf-8741-62cbb2710dce', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'Complete: "The trees are moving and my hat flew away. It is very ___ today."', '[{"id":"a","text":"wind"},{"id":"b","text":"windly"},{"id":"c","text":"winded"},{"id":"d","text":"windy"}]'::jsonb, 'd', 'After "is very" we need the adjective, built with Noun + y: wind → windy. "Wind" is the noun, "windly" wrongly adds -ly (that makes adverbs), and "winded" is not a weather adjective.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61e8f0d4-75ff-59db-9a2c-b1e6b458dc93', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'It is snowing outside. Choose the correct suggestion.', '[{"id":"a","text":"Let''s make a snowman."},{"id":"b","text":"Let''s makes a snowman."},{"id":"c","text":"Let''s making a snowman."},{"id":"d","text":"Let''s to make a snowman."}]'::jsonb, 'a', '"Let''s" is followed by the base verb: Let''s make a snowman. "Let''s makes" adds a third-person -s, "Let''s making" adds -ing, and "Let''s to make" adds an extra "to" — none of these follow "Let''s".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65348784-3957-5723-8823-7f55aadf1112', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'A pupil is running in the corridor. What does the teacher say?', '[{"id":"a","text":"\"Don''t runs!\""},{"id":"b","text":"\"Don''t running!\""},{"id":"c","text":"\"Don''t run!\""},{"id":"d","text":"\"Don''t to run!\""}]'::jsonb, 'c', 'After "Don''t" we use the base verb with nothing added: Don''t run! "Don''t runs" keeps an -s, "Don''t running" adds -ing, and "Don''t to run" adds "to" — all wrong after "Don''t".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9582c3cf-5090-5543-9eec-1ece90c489d6', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'Complete: "Last weekend, we ___ to the countryside for a picnic."', '[{"id":"a","text":"go"},{"id":"b","text":"goed"},{"id":"c","text":"went"},{"id":"d","text":"goes"}]'::jsonb, 'c', '"Last weekend" is a finished time, so we need the simple past. "Go" is irregular: its past is "went", not "goed" ✓. The common trap is adding -ed to make "goed" — irregular verbs change their whole form, so it is went.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90cc0c3f-3fd7-52a0-8d0e-75f9613acf01', 'b6061f0a-dd0a-518d-bc3d-f8966af347d1', 'The coach gives advice. Choose the correct sentence.', '[{"id":"a","text":"Eating a balanced diet and not eat too much sugar."},{"id":"b","text":"To eat a balanced diet and don''t eat too much sugar."},{"id":"c","text":"Eat a balanced diet and not eat too much sugar."},{"id":"d","text":"Eat a balanced diet and don''t eat too much sugar."}]'::jsonb, 'd', 'Advice uses the imperative: the base verb for a positive order (Eat a balanced diet) and "don''t" + base verb for a negative order (don''t eat too much sugar) ✓. The common trap is "not eat" — the negative imperative needs "don''t", not just "not"; "Eating" and "To eat" are not imperative forms either.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7107128a-b7a8-5a20-8fe3-fcee65e70224', '4fd104d3-5147-508c-bca6-b95dedb00c27', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the health champion''s test', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb0807a7-c129-5644-9b4a-c18225eec25a', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'Complete: "For a healthy body, eat ___ vegetables, but don''t drink too ___ soda."', '[{"id":"a","text":"many … much"},{"id":"b","text":"much … many"},{"id":"c","text":"many … many"},{"id":"d","text":"much … much"}]'::jsonb, 'a', 'Two choices in one sentence: "vegetables" can be counted, so it takes "many"; "soda" cannot be counted, so it takes "much" → many vegetables … much soda ✓. The common trap is using the same word twice — you must judge each noun on its own: countable → many, uncountable → much.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddc22115-dd1f-58cd-b116-67d5001cb241', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'Complete: "There is not a single cloud. The sky is blue and it is very ___."', '[{"id":"a","text":"sun"},{"id":"b","text":"suny"},{"id":"c","text":"sunly"},{"id":"d","text":"sunny"}]'::jsonb, 'd', 'Noun + y gives the weather adjective, and a short word like "sun" doubles its last letter: sun → sunny ✓. The common trap is "suny" with a single n; "sunly" wrongly uses -ly, and "sun" is the noun, not the adjective.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e45d0ec-056e-5891-82e2-f0fb2f780805', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'One sentence has a mistake. Which one? (1) You mustn''t run near the pool. (2) Let''s play tennis after school. (3) What about play basketball? (4) Don''t eat too many sweets.', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'c', 'Sentence 3 has the mistake: this question asks for the faulty sentence. "What about play basketball?" is wrong: after "What about" you need a verb in -ing → What about playing basketball? ✓. Sentences 1, 2 and 4 are correct: mustn''t + base verb, Let''s + base verb, and "many" with countable sweets.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39b5a840-7675-5cbd-a0fe-28513fabebbf', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'A sign at the pool says: "Danger! Deep water." Which rule is correct?', '[{"id":"a","text":"You must swim here alone."},{"id":"b","text":"You mustn''t swim here without an adult."},{"id":"c","text":"You don''t must swim here."},{"id":"d","text":"You mustn''t to swim here."}]'::jsonb, 'b', 'Deep, dangerous water means swimming alone is forbidden, so the safe rule is "You mustn''t swim here without an adult" ✓. "You must swim here alone" gives the dangerous, wrong meaning; "don''t must" and "mustn''t to" are both impossible forms — mustn''t is followed by the base verb, with no "to".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8c4fd2a-6eb1-5ec8-8ac2-39243e726716', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'Complete: "Yesterday, Lina ___ a bad cold, so she ___ at home all day."', '[{"id":"a","text":"had … rested"},{"id":"b","text":"have … rested"},{"id":"c","text":"had … rest"},{"id":"d","text":"haved … rested"}]'::jsonb, 'a', '"Yesterday" needs the simple past. "Have" is irregular → had, and "rest" is regular → rested (add -ed): she had a cold, so she rested ✓. The common trap is "haved" — irregular verbs never take -ed — or forgetting the -ed on the regular verb "rest".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c87f73d3-8ece-5b44-a08f-8a21509f2bfe', '7107128a-b7a8-5a20-8fe3-fcee65e70224', 'In which word is the letter "l" silent?', '[{"id":"a","text":"clean"},{"id":"b","text":"leg"},{"id":"c","text":"healthy"},{"id":"d","text":"half"}]'::jsonb, 'd', 'In "half" the l is written but not said — we pronounce /hɑːf/, like the silent l in "walk" and "talk" ✓. The common trap is trusting the spelling: in "clean", "leg" and "healthy" the l is clearly pronounced.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7e7bf4e8-6e68-5a51-a81b-6500eb560edf', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b081fcb-75fa-56c4-ab70-28e66ee71e33', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'Emma visits Yasmine''s school. She asks the headmaster: "___ I see the computer room, please?"', '[{"id":"a","text":"Can"},{"id":"b","text":"Want"},{"id":"c","text":"Behind"},{"id":"d","text":"Slowly"}]'::jsonb, 'a', 'To ask for permission we use "Can I…?": Can I see the computer room? "Want" is not a question word, "behind" is a preposition of place, and "slowly" is an adverb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c712152c-00d5-5b55-aff6-f181d5d89db0', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'Complete: "Emma wants ___ the school library."', '[{"id":"a","text":"see"},{"id":"b","text":"to see"},{"id":"c","text":"seeing"},{"id":"d","text":"to seeing"}]'::jsonb, 'b', 'After "want" plus a verb we use "to" + the base form: she wants to see the library. "Want see" drops the "to", and "want seeing" or "want to seeing" wrongly add -ing.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43177917-3205-5218-b0a8-9ae16a896389', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'Look at the picture: the playground is at the back of the school. Complete: "The playground is ___ the school building."', '[{"id":"a","text":"between"},{"id":"b","text":"in front of"},{"id":"c","text":"behind"},{"id":"d","text":"under"}]'::jsonb, 'c', '"At the back of" means "behind": the playground is behind the building. "In front of" is the opposite (facing it), "under" means below, and "between" needs two things on each side.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b1a2c8f-7f70-59af-90fc-a76982eb8abe', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'Complete: "___ maps are there on the classroom wall?"', '[{"id":"a","text":"How much"},{"id":"b","text":"How long"},{"id":"c","text":"How old"},{"id":"d","text":"How many"}]'::jsonb, 'd', '"Maps" is a countable noun (one map, two maps), so we ask with "How many": How many maps are there? "How much" is only for uncountable nouns like water or money.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c94312dd-d592-5a3c-9767-173e5b2d75f1', '7e7bf4e8-6e68-5a51-a81b-6500eb560edf', 'The suitcase is very heavy. Complete: "Karim ___ carry it; it is too heavy for him."', '[{"id":"a","text":"can"},{"id":"b","text":"cannot"},{"id":"c","text":"wants"},{"id":"d","text":"likes"}]'::jsonb, 'b', 'The suitcase is too heavy, so Karim is NOT able to carry it: he cannot carry it. "Can" means he is able to (the opposite here), and "wants"/"likes" talk about desire, not ability.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('beb16456-c396-57b1-aa3e-1ec205f2f082', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '⭐ Practice: a visit to Yasmine''s school', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ae1e042-1a7c-592c-9cc8-be276ff22b30', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'Emma asks: "Can I see your classroom, please?" What is the best reply to give permission?', '[{"id":"a","text":"\"Of course you can!\""},{"id":"b","text":"\"No, thank you.\""},{"id":"c","text":"\"I am twelve.\""},{"id":"d","text":"\"It is behind.\""}]'::jsonb, 'a', 'To give permission after "Can I…?", we say "Of course you can!". "No, thank you" refuses an offer, "I am twelve" answers about age, and "It is behind" answers a "where" question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c11c863-75c1-5818-85b5-0a09c4ae712b', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'Complete: "At the souk, Emma ___ a small carpet for her bedroom."', '[{"id":"a","text":"want"},{"id":"b","text":"wants"},{"id":"c","text":"wanting"},{"id":"d","text":"to want"}]'::jsonb, 'b', 'Emma = she, so in the simple present the verb "want" takes -s: Emma wants a small carpet. Here "want" is followed by a noun (a carpet), not another verb. "Wanting" and "to want" are not correct here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59235613-8f8b-5e0c-ab56-3bde24dc5546', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'Look: the cat is sleeping below the desk. Complete: "The cat is sleeping ___ the desk."', '[{"id":"a","text":"between"},{"id":"b","text":"behind"},{"id":"c","text":"on"},{"id":"d","text":"under"}]'::jsonb, 'd', '"Below" something means "under" it: the cat is under the desk. "On" would be on top of the desk, "behind" is at the back of it, and "between" needs two objects on each side.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08b9d361-8d34-5ee6-accf-8613a894bcf4', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'The teacher stands facing the pupils. Complete: "The teacher stands ___ the pupils."', '[{"id":"a","text":"behind"},{"id":"b","text":"in front of"},{"id":"c","text":"under"},{"id":"d","text":"between"}]'::jsonb, 'b', 'Facing the pupils means the teacher is "in front of" them. "Behind" is the opposite (at their back), "under" means below, and "between" needs two things on each side.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('320fabce-e8b8-5735-9cf6-324d57a7b43a', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'Complete: "After the lesson, you can ___ the school museum."', '[{"id":"a","text":"visit"},{"id":"b","text":"to visit"},{"id":"c","text":"visiting"},{"id":"d","text":"visits"}]'::jsonb, 'a', 'After "can", the verb is always in the base form with no "to": you can visit the museum. "To visit", "visiting" and "visits" are all wrong after "can".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9915754-ecff-5a21-9619-f2a84641bcf9', 'beb16456-c396-57b1-aa3e-1ec205f2f082', 'Emma asks the shopkeeper about the price of a carpet. Complete: "___ is this carpet?" — "Twenty dinars."', '[{"id":"a","text":"How many"},{"id":"b","text":"How old"},{"id":"c","text":"How much"},{"id":"d","text":"How long"}]'::jsonb, 'c', 'To ask about a price we use "How much": How much is this carpet? — Twenty dinars. "How many" counts objects, "How old" asks about age, and "How long" asks about time or length.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2858c8b-9f45-5bf9-9b5f-660ccad7937a', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '⚔️ Chapter boss ⭐⭐⭐: permission, desire and place', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a85c266-689a-541e-8cfa-0675dbd8659f', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Choose the correct sentence.', '[{"id":"a","text":"I want visit the science lab."},{"id":"b","text":"I want to visit the science lab."},{"id":"c","text":"I want visiting the science lab."},{"id":"d","text":"I want to visiting the science lab."}]'::jsonb, 'b', 'The pattern is "want + to + base verb": I want to visit the lab ✓. The common trap is "I want visit", which drops the "to". "Want visiting" and "want to visiting" wrongly use the -ing form after "want to".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3159fbb9-f6cb-5863-9add-d0422a5b73d7', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Complete: "___ water do you want in your bottle?"', '[{"id":"a","text":"How many"},{"id":"b","text":"How much"},{"id":"c","text":"How old"},{"id":"d","text":"How long"}]'::jsonb, 'b', '"Water" is uncountable (we cannot say "two waters"), so we ask with "How much": How much water do you want? "How many" is only for countable nouns like bottles or cups.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d516354e-e45f-5401-a131-5e818870a030', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Karim is strong, but the suitcase is enormous. Complete: "He ___ lift it alone."', '[{"id":"a","text":"can"},{"id":"b","text":"must"},{"id":"c","text":"cannot"},{"id":"d","text":"wants"}]'::jsonb, 'c', 'The suitcase is too big to lift alone, so Karim is NOT able to: he cannot lift it alone. "Can" says the opposite (he is able to), "must" is about obligation, and "wants" is about desire, not ability.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d62105d-3b4e-50f7-9153-bde3a662db51', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Complete: "The eraser is ___ the ruler ___ the pencil-case."', '[{"id":"a","text":"between … and"},{"id":"b","text":"under … and"},{"id":"c","text":"behind … and"},{"id":"d","text":"between … or"}]'::jsonb, 'a', '"Between" always goes with "and": between the ruler and the pencil-case ✓. The common trap is "between … or" — "between" is only followed by "and". "Under" and "behind" would change the meaning completely.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('580b2f1d-249c-519e-976a-529e07a5805b', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Emma speaks English very well and without stopping. Complete: "She speaks English ___."', '[{"id":"a","text":"fluent"},{"id":"b","text":"fluent way"},{"id":"c","text":"fluently"},{"id":"d","text":"more fluent"}]'::jsonb, 'c', 'To say HOW she speaks, we need an adverb of manner: adjective "fluent" + -ly = "fluently". She speaks fluently ✓. "Fluent" alone is the adjective, and "fluent way" / "more fluent" are not adverb forms.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2635b7fd-bcdb-5312-b7e4-21e55815c23c', 'f2858c8b-9f45-5bf9-9b5f-660ccad7937a', 'Read: "(1) Can I see your classroom? (2) Of course you can. (3) I want to visit the lab. (4) The headmaster can to help you." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'Sentence 4 has the mistake: this question asks you to find the faulty sentence. "The headmaster can to help you" is wrong: after "can" the verb never takes "to" — it must be "can help you" ✓. Sentences 1, 2 and 3 correctly use "Can I…?", "Of course you can" and "want to visit".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('548ec081-86dc-56cf-b41f-4b12abb6b120', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '⭐⭐ Review (exam style): school and good-byes', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92eaca82-dcf5-55c9-9b2f-64086027d073', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Complete: "Can my little sister come too?" — "Of course ___."', '[{"id":"a","text":"she can"},{"id":"b","text":"she cans"},{"id":"c","text":"she can to"},{"id":"d","text":"can she"}]'::jsonb, 'a', 'We give permission with "Of course she can": we just change the pronoun and keep "can". "Can" never adds -s ("cans" is wrong) and never takes "to" ("can to" is wrong).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d001152-b414-5a71-8d9a-3dc8e99475c6', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Complete: "Emma ___ to buy a souvenir for her mother."', '[{"id":"a","text":"want"},{"id":"b","text":"wants"},{"id":"c","text":"wanting"},{"id":"d","text":"want to"}]'::jsonb, 'b', 'Emma = she, so the verb takes -s: Emma wants to buy a souvenir. The "to buy" is already in the sentence, so we only need the correct form "wants". "Want" forgets the -s and "want to" would repeat "to".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('888913fd-d0a1-5fed-b459-14e0ccd30205', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Look: the courtyard is at the back of the school. Complete: "The courtyard is ___ the school."', '[{"id":"a","text":"in front of"},{"id":"b","text":"under"},{"id":"c","text":"behind"},{"id":"d","text":"between"}]'::jsonb, 'c', '"At the back of" means "behind": the courtyard is behind the school. "In front of" is the opposite side (facing it), "under" means below, and "between" needs two objects.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6181bd24-b8f9-59d3-bcc0-ae51c4e2d561', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Complete: "___ books are there in the bookcase?"', '[{"id":"a","text":"How old"},{"id":"b","text":"How far"},{"id":"c","text":"How much"},{"id":"d","text":"How many"}]'::jsonb, 'd', '"Books" is countable (one book, two books), so we ask with "How many": How many books are there? "How much" is for uncountable nouns, "How old" asks about age, and "How far" asks about distance.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9123d92-50a3-55d8-8493-55350f1235ee', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Complete: "Please close the door ___." (in a slow way)', '[{"id":"a","text":"slow"},{"id":"b","text":"slowly"},{"id":"c","text":"more slow"},{"id":"d","text":"slowness"}]'::jsonb, 'b', 'To say HOW to close the door, we need an adverb of manner: "slow" + -ly = "slowly". Close the door slowly ✓. "Slow" is the adjective, "more slow" is not correct English, and "slowness" is a noun.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fb61990-e093-51e1-98d0-c47e5d7958ac', '548ec081-86dc-56cf-b41f-4b12abb6b120', 'Emma accidentally drops a pencil-case on the floor. What does she say?', '[{"id":"a","text":"\"You''re welcome.\""},{"id":"b","text":"\"Never mind.\""},{"id":"c","text":"\"I''m sorry!\""},{"id":"d","text":"\"That''s all right.\""}]'::jsonb, 'c', 'When you make a mistake you apologize: "I''m sorry!". "Never mind" and "That''s all right" are answers that GRANT forgiveness, and "You''re welcome" replies to "thank you", not to a mistake.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b8aade2e-7a54-5d47-8cad-251c8cfeabc1', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: shopping, helping and comparing', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c58eaddc-a84e-5ea6-8515-acbdae81c8d3', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'Which sentence is correct?', '[{"id":"a","text":"Emma want to see the lab."},{"id":"b","text":"Emma wants see the lab."},{"id":"c","text":"Emma wants to see the lab."},{"id":"d","text":"Emma wants to seeing the lab."}]'::jsonb, 'c', 'The rule is "subject + wants + to + base verb" for he/she/it: Emma wants to see the lab ✓. "Want" (a) forgets the -s, "wants see" (b) drops the "to", and "to seeing" (d) adds -ing after "to".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('663abd99-5d9e-53e8-b937-25d775ec6a13', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'In the shop the toys all cost the same. Complete: "___ these toys?" — "Five dinars each."', '[{"id":"a","text":"How many are"},{"id":"b","text":"How much are"},{"id":"c","text":"How much is"},{"id":"d","text":"How many is"}]'::jsonb, 'b', 'Prices always take "how much", even when the noun is plural: How much are these toys? ✓ The common trap is "How many" because "toys" is countable — but for the PRICE we use "how much". "Toys" is plural, so we need "are", not "is".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f328c28-4726-5e67-afde-74d87c83f679', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'Emma''s bag is heavy. A kind boy wants to OFFER help. What does he say?', '[{"id":"a","text":"\"Can you help me?\""},{"id":"b","text":"\"Can I help you?\""},{"id":"c","text":"\"I cannot help.\""},{"id":"d","text":"\"How much is it?\""}]'::jsonb, 'b', 'To OFFER help you ask "Can I help you?" ✓. The common trap is "Can you help me?", which is how you ASK FOR help (when YOU need it). "I cannot help" refuses, and "How much is it?" asks a price.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73b908c5-63db-5c13-a522-461190f3abbf', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'Choose the correct comparison: "My new school ___ a big, happy family."', '[{"id":"a","text":"is like"},{"id":"b","text":"is as"},{"id":"c","text":"is liking"},{"id":"d","text":"likes"}]'::jsonb, 'a', 'To compare two things we use "noun + be + like + noun": my school is like a big family ✓ (like = similar to). The common trap is "is as" (wrong here). "Is liking" and "likes" use the verb "to like", which means to enjoy — a different meaning.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2dcd9834-7898-5498-bc1a-b95a19bd3e8f', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'Read: "(1) Yesterday Emma visited the souk. (2) She wanted a small carpet. (3) The shopkeeper helped her. (4) She can to carry it home alone." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'd', 'Sentence 4 has the mistake: this question asks you to spot the faulty sentence. "She can to carry it" is wrong: after "can" the verb takes no "to" — it must be "She can carry it" ✓. Sentences 1, 2 and 3 correctly use the regular past forms "visited", "wanted" and "helped".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35fdcfa4-e3fb-58fa-8855-fc860b10f2cf', 'b8aade2e-7a54-5d47-8cad-251c8cfeabc1', 'Which verb has its final -ed pronounced /ɪd/ (an extra syllable), like "wanted"?', '[{"id":"a","text":"played"},{"id":"b","text":"helped"},{"id":"c","text":"visited"},{"id":"d","text":"cleaned"}]'::jsonb, 'c', 'The -ed is pronounced /ɪd/ (an extra syllable) only after a t or d sound: visit → visited /ɪd/ ✓, exactly like "wanted". The common trap is "played": it ends in a vowel sound, so its -ed is /d/. "Helped" is /t/ and "cleaned" is /d/ — no extra syllable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c58481c3-b350-507a-9e8d-1e732cd3fd87', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '📝 Training ⭐⭐⭐: Module Five round-up (exam style)', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('247151d4-b620-5d60-bdf0-b448141f2d5a', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Complete: "Can I use the computer, please?" — "Of course ___."', '[{"id":"a","text":"you can"},{"id":"b","text":"you want"},{"id":"c","text":"you cans"},{"id":"d","text":"can you"}]'::jsonb, 'a', 'We give permission with "Of course you can". "You want" talks about desire, not permission, "you cans" wrongly adds -s to "can", and "can you" is question word order, not an answer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a67404d-8529-55d8-a140-635073303b60', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Complete: "What does Emma want to do after school?" — "She ___ buy some souvenirs."', '[{"id":"a","text":"want to"},{"id":"b","text":"wants to"},{"id":"c","text":"wants"},{"id":"d","text":"to wants"}]'::jsonb, 'b', 'She = he/she/it, so the verb takes -s, and "buy" is a second verb, so we need "to": she wants to buy souvenirs ✓. "Want to" forgets the -s, "wants" alone drops the "to" before "buy", and "to wants" is not correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8eb55e8e-6050-5c7f-b14b-4f1637ae0b01', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Look: the flag hangs with a window on each side. Complete: "The flag is ___ the two windows."', '[{"id":"a","text":"under"},{"id":"b","text":"behind"},{"id":"c","text":"between"},{"id":"d","text":"in front of"}]'::jsonb, 'c', 'When something is in the middle, with one thing on each side, we use "between": the flag is between the two windows ✓. "Under" means below, "behind" means at the back, and "in front of" means facing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f98381f-267a-5d91-a93c-8a8276b849bd', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Complete: "___ money have you got for the souvenirs?"', '[{"id":"a","text":"How far"},{"id":"b","text":"How old"},{"id":"c","text":"How many"},{"id":"d","text":"How much"}]'::jsonb, 'd', '"Money" is uncountable (we cannot say "two moneys"), so we ask with "How much": How much money have you got? "How many" is only for countable nouns like coins or dinars.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('062955de-b74e-5fb9-911e-ec5c7c3a380e', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Complete: "The globe is fragile. Carry it ___!" (in a careful way)', '[{"id":"a","text":"careful"},{"id":"b","text":"carefully"},{"id":"c","text":"more careful"},{"id":"d","text":"care"}]'::jsonb, 'b', 'To say HOW to carry it, we need an adverb of manner: "careful" + -ly = "carefully". Carry it carefully ✓. "Careful" is the adjective, "more careful" is not the right form here, and "care" is a noun or verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7966420b-de42-52be-8a35-adfe6b2017a3', 'c58481c3-b350-507a-9e8d-1e732cd3fd87', 'Emma''s taxi is waiting to take her to the airport. Which sentence is the best way to take leave?', '[{"id":"a","text":"\"Have a safe trip!\""},{"id":"b","text":"\"Good morning!\""},{"id":"c","text":"\"You''re welcome.\""},{"id":"d","text":"\"How old are you?\""}]'::jsonb, 'a', 'When someone is leaving on a journey, we take leave with "Have a safe trip!" ✓. "Good morning" is a greeting, "You''re welcome" replies to "thank you", and "How old are you?" asks about age.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('534974a1-eda7-5462-b54d-8ed48574bc03', '6da97736-31b8-59ec-a585-156756f4122c', 'english-7eme', '👑 Elite challenge ⭐⭐⭐⭐: the final gate of the journey', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86f165a6-3e68-5fa4-98a2-9aa1f53b685e', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Emma is lost in the souk and needs help. Which question does SHE ask?', '[{"id":"a","text":"\"Can you help me, please?\""},{"id":"b","text":"\"Can I help you?\""},{"id":"c","text":"\"You can help.\""},{"id":"d","text":"\"How much is it?\""}]'::jsonb, 'a', 'When YOU need help, you ASK FOR it: "Can you help me, please?" ✓. The common trap is "Can I help you?", which you say to OFFER help to someone else. "You can help" is not a question, and "How much is it?" asks a price.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('913848d6-07e7-536e-8e45-9beaefdc0d37', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Complete: "___ bread do you want for the picnic?"', '[{"id":"a","text":"How old"},{"id":"b","text":"How far"},{"id":"c","text":"How much"},{"id":"d","text":"How many"}]'::jsonb, 'c', '"Bread" is uncountable — we say "a loaf of bread", never "two breads" — so we ask with "How much": How much bread do you want? ✓ The common trap is "How many" because bread feels like a thing you can count, but it is uncountable.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f400d36-06ca-5c34-ae83-e475ccbf27ad', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Which sentence compares two things correctly?', '[{"id":"a","text":"The library is like a treasure room."},{"id":"b","text":"The library is as a treasure room."},{"id":"c","text":"The library likes a treasure room."},{"id":"d","text":"The library is liking a treasure room."}]'::jsonb, 'a', 'The comparison pattern is "noun + be + like + noun": the library is like a treasure room ✓ (like = similar to). "Is as" is the common trap and is wrong here. "Likes" and "is liking" use the verb "to like" (to enjoy), which changes the meaning.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53fc7d39-930f-56a2-8fb0-f3ff0ee58a8a', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Three of these -ed verbs end in the sound /t/. Which one is DIFFERENT?', '[{"id":"a","text":"washed"},{"id":"b","text":"watched"},{"id":"c","text":"helped"},{"id":"d","text":"played"}]'::jsonb, 'd', '"Played" ends in a vowel sound, so its -ed is pronounced /d/ — it is the odd one out ✓. The other three follow a voiceless sound (sh, ch, p), so their -ed is /t/: washed, watched, helped all end in /t/.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da2772ea-6174-52a1-9f4c-a3ad015901a0', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Read: "(1) Emma wants to buy a small carpet. (2) ''How many is this carpet?'' she asks. (3) The shopkeeper says it is twenty dinars. (4) Emma cannot carry it alone." Which sentence contains a mistake?', '[{"id":"a","text":"Sentence 1"},{"id":"b","text":"Sentence 2"},{"id":"c","text":"Sentence 3"},{"id":"d","text":"Sentence 4"}]'::jsonb, 'b', 'Sentence 2 has the mistake: this question asks you to spot the faulty sentence. "How many is this carpet?" is wrong: a price always takes "how much", so it must be "How much is this carpet?" ✓. Sentences 1, 3 and 4 correctly use "wants to buy", the answer, and "cannot carry".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d07e580-f1a1-5e1b-84d9-b16f13821d9a', '534974a1-eda7-5462-b54d-8ed48574bc03', 'Only ONE of these sentences is completely correct. Which one?', '[{"id":"a","text":"The globe is behind of the door."},{"id":"b","text":"I want that you visit the lab."},{"id":"c","text":"You can put the map between the two windows."},{"id":"d","text":"She can to speak English fluently."}]'::jsonb, 'c', 'Sentence c is correct: "can" + base verb "put", and "between" with two things ✓. "Behind of" (a) is wrong — "behind" takes no "of". "I want that you visit" (b) is a translation trap; English uses "I want you to visit". "Can to speak" (d) wrongly adds "to" after "can".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

