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
      AND q.id NOT IN ('d285fe0d-a649-59ec-9b9b-260fdfeeaf7b', 'e2413add-c559-5006-9763-b2e6c0ca9c89', '73a94e94-6f1f-5b60-a634-b25f85ed89f9', '6b37fb80-e700-5e9e-8e2e-f1a963e25b35', '9a7a2e73-214f-5f5d-8dad-a8d7919519a0', '670f4bd7-d3ef-5fe7-882c-3caab050f965', '77164441-8214-5d03-aa87-a8790339e0aa', 'e5ab50f1-deb8-55e5-8157-eddd648249d1', 'a8ceb12f-18af-5b44-8a64-aab661bcc934', '6346b5b1-c7a4-57fc-93a7-caea03adc76f', '18bc3295-0937-5961-b296-286a45588f48', '66b5185a-77fc-56b2-bb0c-35bb9da60c8e', '9e8ae2ad-e939-5769-8828-ae1efe8a344a', 'b5607ac8-472a-53ba-9772-b3464358dad7', 'f1abc7bc-5fc9-5b3c-a89a-e0d6e4fff9a0', 'a749ceb8-fb9e-5765-a105-7b1a04b6d50f', '637af2aa-fc0c-5f8e-808a-711d6626a480', '764a693e-3867-5b8a-ad9f-a42528c44dec', '216481af-765a-54ee-af1a-db4150a6eaa9', 'c4b28f7f-bd59-5ed6-becb-9ce4553dc584', '479c92f3-14d0-53ae-9e25-9a1bd0d1f89b', '77890e76-b136-5311-a899-e23395450742', 'd53aebe8-b1fa-5a8b-b4df-93fc9a0ec009', '18b8e0cd-b2a4-575d-95c9-acda7a27760c', '4a668275-6d7c-5465-9021-d137579e6cbf', 'f9c457a2-f786-506e-9305-2479a40da662', 'c005dd7f-adc0-5960-ad84-0a8799f68255', '17592f6d-4d2b-5a43-af4a-20fdbd30811b', '2dae05ea-9009-5914-894d-e75db10699f8', 'acf01e4b-a18c-56a9-b2ab-abdf02df8488', '5783b0b1-59a0-5c39-819f-5d423d584556', 'a918ddb6-255d-534d-ab95-903d4903d01a', '7f3a3309-5193-5bf2-befd-1e43093bc1c8', '1e58bb0d-50f8-5b28-bf82-89e9b7467512', 'd349fe65-986a-5603-ae50-e032deccd78f', '15aab741-a4ca-5292-a15d-7c77c9715783', '240a91a4-545d-55f7-8429-ff6c47d81db0', 'fb2e2b96-6a01-58fd-997f-155f9d682d54', '8c741e82-276f-550f-a42e-efc47a7739ed', '6bda0794-a768-5cad-b7bd-9f861eb5cc0b', '4d977cc2-0e48-55de-b3b5-bf4a0069a1e2', 'ae7e4c95-4ac8-56a7-be58-a32b77c3a037', '78524b2f-03dc-52a8-8325-121282a9fe9e', '62a5aab3-407b-5275-a4c8-6ea8418aeb32', '2852f4a1-2aca-5f72-8797-3d67c83130a6', '18b4ef50-4d0e-5ba3-b133-07dc1c374633', '39d071a2-6674-5bc6-b57f-71c8edb1ede7', '8a82afc1-9f54-5be0-bdb8-5341127e633c', '26308c5b-3f4e-5170-8c1f-e22c01c325a8', '50538a6c-151f-5a1c-b006-1d84127ae939', 'fd5e917d-d34a-51f6-bc8c-22136676df0b', '742071d9-aa0f-50a7-951c-40726423ef50', '18d2aa01-f0cd-5c5a-9df7-c1370f10dd67', '228794f1-d74f-542f-abd5-9b49cd74dabb', 'fbf64f7c-26c4-5098-bb0a-731f57ccccec', '4f04d64c-122e-543c-ad1d-75fe18e109c5', 'd5f421d1-b075-5b4e-9b56-2193091fbd3c', '01376b6b-6a85-5b32-a8cb-fa8f3c43ac89', 'e05154ac-3dd5-5807-9510-4795a06f21f5', '1edd73a8-150f-5640-aa84-693a23908f69', '1fd63e3b-6fd2-5d07-8ae7-f152f10b8104', '9d8cab86-ff23-50a6-b36e-a359c69e0aef', 'eeec4ca2-6208-5d70-aec9-acd383a59131', 'af104644-25ea-517f-aeae-6d94a5a56d30', '3b4077a7-368e-51ee-aec2-ebc68a5f0d9c', 'b3002d5c-00dc-50d8-a8bc-0ed261dd939b', '476256f9-5c92-571a-b0ec-d01eeec4597c', '22666f07-e576-5be3-a257-1573a241cd64');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-1ere-sec' AND source = 'admin' AND id NOT IN ('d47dc4b0-b18d-51a7-aff1-fd797f002c14', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04');
DELETE FROM public.questions WHERE exercise_id IN ('d47dc4b0-b18d-51a7-aff1-fd797f002c14', '5b96fcd8-5d95-5575-85ac-ff19598c617e', 'd805ccf7-d0ae-5ae3-985f-31a4bfc87e17', '776d1dc2-d59c-5465-8223-e3c1f19c52f9', '3f648e0b-bac9-5e26-88c2-f361e5208d9e', '4b48f1c0-b761-569b-ae0d-e716dbf12bb9', '84215a2f-6db5-5f6e-ad09-a9f101cd50ab', 'b50207c5-1330-51d4-8cd5-bffd7ee39c4b', 'fa2d2181-fa92-58b6-9f6e-d3256baa78ac', '64d130ab-91b3-52f1-b923-72eb0d6b6b1d', 'de80c7db-55cd-5c65-a9e3-9f7b1c42b0ff', '7a2c09ed-2c5a-52a8-a29e-a5ae020a6d04') AND id NOT IN ('d285fe0d-a649-59ec-9b9b-260fdfeeaf7b', 'e2413add-c559-5006-9763-b2e6c0ca9c89', '73a94e94-6f1f-5b60-a634-b25f85ed89f9', '6b37fb80-e700-5e9e-8e2e-f1a963e25b35', '9a7a2e73-214f-5f5d-8dad-a8d7919519a0', '670f4bd7-d3ef-5fe7-882c-3caab050f965', '77164441-8214-5d03-aa87-a8790339e0aa', 'e5ab50f1-deb8-55e5-8157-eddd648249d1', 'a8ceb12f-18af-5b44-8a64-aab661bcc934', '6346b5b1-c7a4-57fc-93a7-caea03adc76f', '18bc3295-0937-5961-b296-286a45588f48', '66b5185a-77fc-56b2-bb0c-35bb9da60c8e', '9e8ae2ad-e939-5769-8828-ae1efe8a344a', 'b5607ac8-472a-53ba-9772-b3464358dad7', 'f1abc7bc-5fc9-5b3c-a89a-e0d6e4fff9a0', 'a749ceb8-fb9e-5765-a105-7b1a04b6d50f', '637af2aa-fc0c-5f8e-808a-711d6626a480', '764a693e-3867-5b8a-ad9f-a42528c44dec', '216481af-765a-54ee-af1a-db4150a6eaa9', 'c4b28f7f-bd59-5ed6-becb-9ce4553dc584', '479c92f3-14d0-53ae-9e25-9a1bd0d1f89b', '77890e76-b136-5311-a899-e23395450742', 'd53aebe8-b1fa-5a8b-b4df-93fc9a0ec009', '18b8e0cd-b2a4-575d-95c9-acda7a27760c', '4a668275-6d7c-5465-9021-d137579e6cbf', 'f9c457a2-f786-506e-9305-2479a40da662', 'c005dd7f-adc0-5960-ad84-0a8799f68255', '17592f6d-4d2b-5a43-af4a-20fdbd30811b', '2dae05ea-9009-5914-894d-e75db10699f8', 'acf01e4b-a18c-56a9-b2ab-abdf02df8488', '5783b0b1-59a0-5c39-819f-5d423d584556', 'a918ddb6-255d-534d-ab95-903d4903d01a', '7f3a3309-5193-5bf2-befd-1e43093bc1c8', '1e58bb0d-50f8-5b28-bf82-89e9b7467512', 'd349fe65-986a-5603-ae50-e032deccd78f', '15aab741-a4ca-5292-a15d-7c77c9715783', '240a91a4-545d-55f7-8429-ff6c47d81db0', 'fb2e2b96-6a01-58fd-997f-155f9d682d54', '8c741e82-276f-550f-a42e-efc47a7739ed', '6bda0794-a768-5cad-b7bd-9f861eb5cc0b', '4d977cc2-0e48-55de-b3b5-bf4a0069a1e2', 'ae7e4c95-4ac8-56a7-be58-a32b77c3a037', '78524b2f-03dc-52a8-8325-121282a9fe9e', '62a5aab3-407b-5275-a4c8-6ea8418aeb32', '2852f4a1-2aca-5f72-8797-3d67c83130a6', '18b4ef50-4d0e-5ba3-b133-07dc1c374633', '39d071a2-6674-5bc6-b57f-71c8edb1ede7', '8a82afc1-9f54-5be0-bdb8-5341127e633c', '26308c5b-3f4e-5170-8c1f-e22c01c325a8', '50538a6c-151f-5a1c-b006-1d84127ae939', 'fd5e917d-d34a-51f6-bc8c-22136676df0b', '742071d9-aa0f-50a7-951c-40726423ef50', '18d2aa01-f0cd-5c5a-9df7-c1370f10dd67', '228794f1-d74f-542f-abd5-9b49cd74dabb', 'fbf64f7c-26c4-5098-bb0a-731f57ccccec', '4f04d64c-122e-543c-ad1d-75fe18e109c5', 'd5f421d1-b075-5b4e-9b56-2193091fbd3c', '01376b6b-6a85-5b32-a8cb-fa8f3c43ac89', 'e05154ac-3dd5-5807-9510-4795a06f21f5', '1edd73a8-150f-5640-aa84-693a23908f69', '1fd63e3b-6fd2-5d07-8ae7-f152f10b8104', '9d8cab86-ff23-50a6-b36e-a359c69e0aef', 'eeec4ca2-6208-5d70-aec9-acd383a59131', 'af104644-25ea-517f-aeae-6d94a5a56d30', '3b4077a7-368e-51ee-aec2-ebc68a5f0d9c', 'b3002d5c-00dc-50d8-a8bc-0ed261dd939b', '476256f9-5c92-571a-b0ec-d01eeec4597c', '22666f07-e576-5be3-a257-1573a241cd64');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-1ere-sec' AND c.id NOT IN ('15f8bfa0-02d7-54aa-9362-0c7b3a5e4847', '1d85914e-62d3-50ce-943e-1b77a49bb180', '7c588ba8-cc30-53da-8702-cd8365c0c879', '911d2611-f232-5e69-b326-4d2b66501742') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

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

| grandeur   | est multipliée par |
| ---------- | ------------------ |
| longueurs  | k                  |
| périmètre  | k                  |
| **aire**   | **k²**             |

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

| angle | sin    | cos    | tan    |
| ----- | ------ | ------ | ------ |
| 30°   | 1/2    | √3/2   | √3/3   |
| 45°   | √2/2   | √2/2   | 1      |
| 60°   | √3/2   | 1/2    | √3     |

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

| figure de départ | son image par translation                                            |
| ---------------- | -------------------------------------------------------------------- |
| une droite       | une droite **parallèle** à la première                               |
| un segment       | un segment **isométrique** (même longueur)                           |
| un cercle        | un cercle de **même rayon**, dont le centre est l''image du centre     |
| un polygone      | un polygone **superposable** (mêmes longueurs, mêmes angles)          |

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

