-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: svt-1ere-sec (Sciences de la Vie et de la Terre)
-- Regenerate with: npm run content:build
-- Source of truth: content/svt-1ere-sec/
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
  ('svt-1ere-sec', 'Sciences de la Vie et de la Terre', 'Amélioration de la production végétale (nutrition minérale, nutrition carbonée, multiplication végétative), microbes et santé (diversité du monde microbien, agents pathogènes et maladies infectieuses, défense de l''organisme) et découverte et gestion de notre environnement géologique selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun)', 'Vitalite', 'subject-svt', 'Leaf', 3, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'))
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
      AND e.subject_id = 'svt-1ere-sec'
      AND e.source = 'admin'
      AND q.id NOT IN ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', '89c9d68e-0825-5c8a-b227-53823dcebcce', 'b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'dc95078f-4b07-5369-9d4e-20e7da51cfa6', '8370514e-445c-591a-92da-e4099e253999', '8e59a821-f39b-5ba3-ab73-5b234b3b6253', 'de8815b1-b69c-553b-b863-e04b9254f688', '027d4c81-285a-5dc1-9a33-4fa045cf121b', '3616a836-0f14-5737-b34c-8954e0492386', '24b390fb-9b31-5195-920e-32e25236b520', '7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'f55785f1-1488-598f-836d-6d962733d85c', '91a21c54-f5eb-5636-905d-ca036d1fbe7f', '9e6ec3b7-1a4a-5324-b693-4befe7421343', '96569c1c-2c6f-58ac-be1c-1e9c63f8544b', '2af41e79-44d7-54cc-87a8-f7e8fb554818', '52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', 'e395ec07-d9a5-58de-8a71-7edaeef8becd', '650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '99012c23-8348-5018-bbd4-4c21a5b1a8a8', 'e42de770-7ccd-57ae-9d50-7b8e1b9ad950', 'a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'b090ddd8-59be-59ba-bb90-a5878b110d4f', '78b78f9b-886e-59b5-926c-f9edf845f4d7', '7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'f850f95b-136b-5c31-bb57-875cc4a1461a', 'fe53f4af-f844-5250-b629-d6bb89028ce2', '09dce64e-c683-5928-a806-eb08a471da9b', '1627a75b-f528-5ca9-9be0-57f70af79631', '90414dcf-d539-5199-99be-a07837dbe49a', '928b07f4-9368-5470-86e9-e0e86a536a0f', '4fa20252-4e33-5378-adb2-98783f658dbb', 'ca3e8723-6581-5fa1-9b6a-988b944557e7', 'be73d5e3-1039-5dfb-82da-19796687e6ef', 'd0cb9d1b-054c-5c92-b59e-849adaab9a71', '95a19fac-1d90-527f-a28c-c57942c6bc24', 'be512e27-4044-5f2f-940a-b523152a8bda', '60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', 'e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '3364383e-d368-5784-86f2-de778373c561', '45559784-8b76-5964-8436-c523028c5c23', '8ae48a12-409a-5862-8d8b-fd5717b60f6b', '1112df0f-2cc9-57eb-8626-75a1f48d6489', 'd89a6f15-c64b-5dfa-b278-ec3148730ddd', '2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'ada3ea63-8e05-59da-b2e8-d839fa08f014', '01e92174-0fd1-5e71-a5f9-ba16e036f152', 'b51d95dc-789a-52c6-bcf8-039d9a13dca2', '3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', '93db0bf6-4904-59ee-8216-d62070775e36', 'bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', '9cbf896b-6c63-553c-88c3-fba80035bffd', 'd67fe435-439d-5cdd-b681-1444debbd583', '86b52802-4f18-5911-b9c3-8708c3435d2f', '7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '90d6ba8c-fca4-5f7d-9674-138b16f9463f', '24fecb22-d64c-5d54-a8bf-9306088600b2', 'ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', 'dbb47327-f7c2-56bf-a720-d139236eb74c', '89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '49aa94ef-d027-5918-940e-187e21d1fb75', 'c6be8323-1727-5529-b909-6c6305de34d1', '8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '83349456-85cd-5aac-998d-1ec9a6898925', 'f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '38db394b-2177-5753-a9ab-d53a32e524ce');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'svt-1ere-sec' AND source = 'admin' AND id NOT IN ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', '194de524-a981-5046-97c2-b5fd75a83615', 'c36f186f-3063-51cd-993c-dc9cec99830e', '9b5b7c6a-148c-5478-93da-b16535b99a16', '7f91558c-7618-5982-baef-81925e952f79', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'fbb8b06e-5283-56bb-972b-345b39829387', 'bc4dc18c-ab71-558f-b433-660d14f30960', '6642bf10-24ef-5328-a3c5-04d817695cfe', '4d10426c-9477-5321-8749-0ae925f7c072');
DELETE FROM public.questions WHERE exercise_id IN ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', '194de524-a981-5046-97c2-b5fd75a83615', 'c36f186f-3063-51cd-993c-dc9cec99830e', '9b5b7c6a-148c-5478-93da-b16535b99a16', '7f91558c-7618-5982-baef-81925e952f79', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'fbb8b06e-5283-56bb-972b-345b39829387', 'bc4dc18c-ab71-558f-b433-660d14f30960', '6642bf10-24ef-5328-a3c5-04d817695cfe', '4d10426c-9477-5321-8749-0ae925f7c072') AND id NOT IN ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', '89c9d68e-0825-5c8a-b227-53823dcebcce', 'b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'dc95078f-4b07-5369-9d4e-20e7da51cfa6', '8370514e-445c-591a-92da-e4099e253999', '8e59a821-f39b-5ba3-ab73-5b234b3b6253', 'de8815b1-b69c-553b-b863-e04b9254f688', '027d4c81-285a-5dc1-9a33-4fa045cf121b', '3616a836-0f14-5737-b34c-8954e0492386', '24b390fb-9b31-5195-920e-32e25236b520', '7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'f55785f1-1488-598f-836d-6d962733d85c', '91a21c54-f5eb-5636-905d-ca036d1fbe7f', '9e6ec3b7-1a4a-5324-b693-4befe7421343', '96569c1c-2c6f-58ac-be1c-1e9c63f8544b', '2af41e79-44d7-54cc-87a8-f7e8fb554818', '52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', 'e395ec07-d9a5-58de-8a71-7edaeef8becd', '650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '99012c23-8348-5018-bbd4-4c21a5b1a8a8', 'e42de770-7ccd-57ae-9d50-7b8e1b9ad950', 'a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'b090ddd8-59be-59ba-bb90-a5878b110d4f', '78b78f9b-886e-59b5-926c-f9edf845f4d7', '7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'f850f95b-136b-5c31-bb57-875cc4a1461a', 'fe53f4af-f844-5250-b629-d6bb89028ce2', '09dce64e-c683-5928-a806-eb08a471da9b', '1627a75b-f528-5ca9-9be0-57f70af79631', '90414dcf-d539-5199-99be-a07837dbe49a', '928b07f4-9368-5470-86e9-e0e86a536a0f', '4fa20252-4e33-5378-adb2-98783f658dbb', 'ca3e8723-6581-5fa1-9b6a-988b944557e7', 'be73d5e3-1039-5dfb-82da-19796687e6ef', 'd0cb9d1b-054c-5c92-b59e-849adaab9a71', '95a19fac-1d90-527f-a28c-c57942c6bc24', 'be512e27-4044-5f2f-940a-b523152a8bda', '60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', 'e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '3364383e-d368-5784-86f2-de778373c561', '45559784-8b76-5964-8436-c523028c5c23', '8ae48a12-409a-5862-8d8b-fd5717b60f6b', '1112df0f-2cc9-57eb-8626-75a1f48d6489', 'd89a6f15-c64b-5dfa-b278-ec3148730ddd', '2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'ada3ea63-8e05-59da-b2e8-d839fa08f014', '01e92174-0fd1-5e71-a5f9-ba16e036f152', 'b51d95dc-789a-52c6-bcf8-039d9a13dca2', '3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', '93db0bf6-4904-59ee-8216-d62070775e36', 'bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', '9cbf896b-6c63-553c-88c3-fba80035bffd', 'd67fe435-439d-5cdd-b681-1444debbd583', '86b52802-4f18-5911-b9c3-8708c3435d2f', '7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '90d6ba8c-fca4-5f7d-9674-138b16f9463f', '24fecb22-d64c-5d54-a8bf-9306088600b2', 'ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', 'dbb47327-f7c2-56bf-a720-d139236eb74c', '89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '49aa94ef-d027-5918-940e-187e21d1fb75', 'c6be8323-1727-5529-b909-6c6305de34d1', '8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '83349456-85cd-5aac-998d-1ec9a6898925', 'f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '38db394b-2177-5753-a9ab-d53a32e524ce');
DELETE FROM public.chapters c WHERE c.subject_id = 'svt-1ere-sec' AND c.id NOT IN ('eb484ddb-29b8-522a-a8bd-be1247b74660', 'da09b891-f755-5773-8d01-3100b3d94215', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'd0a86148-bdad-5274-8564-f6d944ce6b13') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', 'La nutrition minérale — de l''eau du sol à la feuille', 'Mise en évidence, localisation et mesure de l''absorption d''eau (zone pilifère, poil absorbant, potomètre) ; mécanisme osmotique de l''absorption (turgescence, plasmolyse, osmose, pression osmotique, milieux hypotonique et hypertonique, isotonie, conduction latérale) ; transpiration foliaire et stomates, facteurs internes et externes ; couplage absorption-transpiration (aspiration foliaire, poussée radiculaire, bilan hydrique) ; besoins en sels minéraux (méthode analytique, méthode synthétique, liquide de Knop, milieux carencés et symptômes, macroéléments et oligoéléments, déficience-optimum-toxicité) ; conduction verticale de la sève brute par le xylème ; amélioration de la production végétale par une irrigation et une fertilisation rationnelles, le choix des semences et la culture sous serre', '# ⚔️ La nutrition minérale — de l''eau du sol à la feuille

> 💡 «Une plante ne boit pas : elle aspire. Comprends la force qui fait entrer l''eau dans une racine, et tu sauras pourquoi un champ trop arrosé rend moins qu''un champ bien arrosé.»

Bienvenue en 1ère année secondaire, héros. Au collège tu as appris que la plante verte prélève dans le sol de l''eau et des sels minéraux par ses racines, et que la **sève brute** monte vers tous les organes. Cette quête ouvre la boîte noire : **par où** l''eau entre, **quelle force** l''y pousse, **comment** elle monte et **de quoi** la plante a réellement besoin. C''est le savoir sur lequel repose toute l''amélioration de la production végétale.

## 🌱 L''absorption d''eau : par où, et combien ?

Place une plante dans un tube d''eau et repère le niveau : 24 heures plus tard, le niveau a baissé. **L''absorption d''eau** est l''entrée d''eau dans la plante **par le système racinaire**.

Une jeune racine observée à la loupe binoculaire montre trois zones : la **coiffe** (à l''extrémité), la **zone pilifère** (couverte de fins prolongements) et la **zone subéreuse** (plus haut). C''est la **zone pilifère** qui absorbe : ses **poils absorbants** sont les cellules par lesquelles l''eau et les sels minéraux entrent.

::: figure Les poils absorbants sont tous rassemblés sur une seule zone de la racine — la zone pilifère : c''est là, et nulle part ailleurs, que l''eau entre
<svg viewBox="0 0 340 260">
<path d="M120 25 L120 122 L156 122 L156 25 Z" fill="#94a3b8" opacity="0.22"/>
<path d="M120 122 L120 198 L156 198 L156 122 Z" fill="#0f6e56" opacity="0.16"/>
<path d="M120 198 Q120 230 138 234 Q156 230 156 198 Z" fill="#0f172a" opacity="0.15"/>
<g fill="none" stroke="#0f172a" stroke-width="2" stroke-linecap="round">
<path d="M120 25 L120 198 Q120 230 138 234 Q156 230 156 198 L156 25"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M120 122 H156"/>
<path d="M120 198 H156"/>
</g>
<g fill="none" stroke="#0f6e56" stroke-width="1.8" stroke-linecap="round">
<path d="M120 132 L96 125"/><path d="M120 145 L94 141"/><path d="M120 158 L96 158"/><path d="M120 171 L94 175"/><path d="M120 184 L96 191"/>
<path d="M156 132 L180 125"/><path d="M156 145 L182 141"/><path d="M156 158 L180 158"/><path d="M156 171 L182 175"/><path d="M156 184 L180 191"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M156 70 H205"/><path d="M182 158 H208"/><path d="M150 226 H205"/><path d="M94 190 L66 206"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="208" y="74" fill="#0f172a">zone subéreuse</text>
<text x="211" y="162" fill="#0f6e56">zone pilifère</text>
<text x="208" y="230" fill="#0f172a">coiffe</text>
<text x="55" y="219" text-anchor="middle" fill="#0f6e56">poil absorbant</text>
</g>
</svg>
:::

Un **poil absorbant** est minuscule mais innombrable : 12 à 15 μm de diamètre, 1 à plusieurs mm de long, jusqu''à 2000 par cm² chez les graminées — soit 14 milliards chez un seul plant de seigle, offrant environ **400 m² de surface de contact** avec la solution du sol.

_Exemple détaillé_ : on mesure l''absorption avec un **potomètre** (potos = boisson, mètre = mesure). L''index se déplace dans un tube capillaire de 2 mm de diamètre, donc de rayon R = 1 mm = 0,1 cm. Le volume absorbé pour 1 mm de déplacement vaut V = R × R × π × h = 0,1 × 0,1 × 3,14 × 0,1 = **0,00314 cm³**. Si l''index avance de 8 mm en 5 minutes, V = 0,00314 × 8 = **0,025 cm³**, soit une vitesse de 0,025 / 5 = 0,005 cm³/mn = **0,3 cm³/heure** ✓.

> 🗡️ Dans l''expérience de Rosène, cinq plants ont leurs racines plongées dans cinq tubes ; un seul, le tube A, a **toute** la racine dans l''eau, sans huile. Ce tube est le **témoin** : c''est lui qui prouve que ce n''est pas le dispositif qui empêche l''absorption dans les autres tubes.

## 💧 Le mécanisme : l''osmose

Une graine de pois chiche dans l''eau du robinet **gonfle** ; une olive dans l''eau fortement salée devient **crénelée**. Ces deux constatations sont l''affaire de cellules.

Plonge des fragments d''épiderme d''oignon violet dans du chlorure de sodium (NaCl) à trois concentrations : à **2 g/l** les cellules sont **turgescentes** (l''eau est entrée, la vacuole est gonflée) ; à **9 g/l** elles restent **normales** ; à **20 g/l** elles sont **plasmolysées** (l''eau est sortie, le cytoplasme se décolle de la paroi).

::: figure À gauche l''eau est entrée et plaque la membrane contre la paroi ; à droite elle est sortie et la membrane se décolle — c''est le même passage d''eau, dans les deux sens
<svg viewBox="0 0 340 200">
<rect x="30" y="45" width="112" height="112" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="34" y="49" width="104" height="104" fill="none" stroke="#0f6e56" stroke-width="2"/>
<rect x="42" y="57" width="88" height="88" rx="8" fill="#7c3aed" opacity="0.35"/>
<circle cx="112" cy="128" r="8" fill="#0f172a" opacity="0.75"/>
<rect x="198" y="45" width="112" height="112" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="218" y="65" width="72" height="72" rx="14" fill="none" stroke="#0f6e56" stroke-width="2"/>
<rect x="226" y="73" width="56" height="56" rx="10" fill="#7c3aed" opacity="0.35"/>
<circle cx="272" cy="122" r="7" fill="#0f172a" opacity="0.75"/>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="86" y="36" text-anchor="middle" fill="#0f172a">NaCl 2 g/l</text>
<text x="254" y="36" text-anchor="middle" fill="#0f172a">NaCl 20 g/l</text>
<text x="86" y="180" text-anchor="middle" fill="#0f6e56">turgescente</text>
<text x="254" y="180" text-anchor="middle" fill="#0f6e56">plasmolysée</text>
</g>
</svg>
:::

L''**osmomètre** (un tube fermé par une membrane semi-perméable, rempli de sulfate de cuivre et plongé dans l''eau pure) montre la loi générale : le niveau de la solution **monte**. L''**osmose** est le passage d''eau à travers une membrane semi-perméable, du milieu **le moins concentré** vers le milieu **le plus concentré**, jusqu''à l''égalité des concentrations, ou **isotonie**.

La force en jeu est la **pression osmotique** : la force exercée par les particules dissoutes sur le solvant.

$$ π = n.R.T $$

avec n = nombre de moles de soluté par litre, R = 0,082 et T = température en degré Kelvin = T°C + 273. Un milieu de **faible** pression osmotique est dit **hypotonique** par rapport à un second ; un milieu de **forte** pression osmotique est dit **hypertonique**.

_Exemple détaillé_ : la solution du sol est à 0,5 atm ; le poil absorbant est à 0,7 atm. Le poil est donc **hypertonique** par rapport au sol : l''eau y entre par osmose. Et de cellule en cellule la pression **augmente** — 0,7 puis 1,4 ; 1,8 ; 2,1 ; 2,8 ; 3 atm en allant vers le cylindre central : l''eau traverse horizontalement la racine, toujours du moins concentré vers le plus concentré. C''est la **conduction latérale**.

> ⚠️ Piège classique : l''osmose ne fait pas passer l''eau « du plus vers le moins ». C''est l''inverse — l''eau va **vers** le milieu le plus concentré. C''est pour cela que l''olive dans la saumure se ratatine au lieu de gonfler.

## 🌬️ La transpiration et les stomates

La plante perd une bonne partie de l''eau absorbée sous forme de **vapeur**, surtout par les feuilles : c''est la **transpiration**. Une lamelle de verre posée sur chaque face d''une feuille se couvre de buée : **les deux faces transpirent**, mais la face inférieure transpire davantage.

La structure responsable est le **stomate** : deux **cellules stomatiques** bordant un orifice, l''**ostiole**, par où sort la vapeur d''eau. L''ostiole change de diamètre selon les conditions du milieu.

::: figure Ce n''est pas la feuille qui s''ouvre, ce sont deux cellules : en s''écartant, elles ménagent entre elles l''ostiole par où la vapeur s''échappe
<svg viewBox="0 0 340 220">
<g fill="none" stroke="#94a3b8" stroke-width="1.5">
<path d="M30 40 L110 45 L120 100 L100 165 L34 172 Z"/>
<path d="M230 45 L308 40 L312 172 L240 165 L220 100 Z"/>
</g>
<path d="M170 45 C 118 58, 118 142, 170 155 C 146 132, 146 68, 170 45 Z" fill="#0f6e56" opacity="0.32" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M170 45 C 222 58, 222 142, 170 155 C 194 132, 194 68, 170 45 Z" fill="#0f6e56" opacity="0.32" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M170 45 C 146 68, 146 132, 170 155 C 194 132, 194 68, 170 45 Z" fill="#ffffff" stroke="#0f172a" stroke-width="1.5"/>
<circle cx="142" cy="100" r="5" fill="#0f172a" opacity="0.75"/>
<circle cx="198" cy="100" r="5" fill="#0f172a" opacity="0.75"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M175 78 L246 44"/><path d="M136 140 L104 190"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="249" y="40" fill="#0f6e56">ostiole</text>
<text x="86" y="206" text-anchor="middle" fill="#0f172a">cellule stomatique</text>
<text x="286" y="206" text-anchor="middle" fill="#94a3b8">épiderme</text>
</g>
</svg>
:::

L''intensité de la transpiration dépend de deux familles de facteurs :

| Facteurs                          | Ils augmentent la transpiration quand…                                                                   |
| --------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Internes** (propres au végétal) | la surface foliaire est grande ; la densité des stomates (nombre par unité de surface) est élevée        |
| **Externes** (environnement)      | il y a de la lumière ; la température s''élève (jusqu''à 25 à 30 °C) ; l''air se dessèche ; l''air est agité |

Les facteurs externes agissent tous de la même façon : ils **favorisent l''ouverture des ostioles**.

> 🗡️ La feuille de tilleul n''a **aucun** stomate sur sa face supérieure et transpire pourtant 200 mg par 24 h : sa **cuticule** est mince et laisse passer la vapeur. La cuticule est une voie accessoire de transpiration.

## ⚖️ Absorption et transpiration sont couplées

Deux potomètres, deux plantes de même taille et de même âge : la plante entière (A) et la même **privée de quelques feuilles** (B). En 20 minutes l''index avance de 48 mm en A contre 21 mm en B. Moins de feuilles ⇒ moins de transpiration ⇒ **moins d''absorption**.

La perte d''eau par les feuilles crée un appel d''eau : c''est l''**aspiration foliaire**. Mais un rameau de vigne coupé au printemps « pleure » alors qu''il n''a pas de feuilles : la sève est aussi **poussée** par la racine — c''est la **poussée radiculaire**, que l''expérience de Hales met en évidence avec un manomètre à mercure. Dans la plante, **l''eau est à la fois poussée et aspirée**.

Le **bilan hydrique** est la différence entre l''eau absorbée et l''eau perdue. S''il devient **négatif** durablement — l''eau manque dans le sol — la plante se fane et peut mourir : il faut irriguer.

> ⚠️ Ne confonds pas les deux moteurs : l''aspiration foliaire vient **du haut** (les feuilles) et s''arrête si la plante est effeuillée ; la poussée radiculaire vient **du bas** (les racines) et continue sans feuilles.

## 🧪 Les besoins en sels minéraux

Deux méthodes complémentaires répondent à la question « de quoi la plante a-t-elle besoin ? ».

- La **méthode analytique** : on brûle le végétal et on analyse les gaz et les cendres ; on obtient sa **composition élémentaire**. La luzerne est ainsi faite, en % de matière fraîche, de C 11,34 · H 8,72 · O 77,90 · N 0,82 · P 0,71 · S 0,10 — à eux six, **99,59 %** — le reste (Ca, Na, K, Mg, Al, Si, Fe) ne pesant que des fractions de pour cent.
- La **méthode synthétique** : on fabrique une solution nutritive à partir de cette composition. En 1860, **Knop** compose un **milieu synthétique complet** (nitrate de calcium 1 g, nitrate de potassium 0,25 g, sulfate de magnésium 0,25 g, phosphate monopotassique 0,25 g, chlorure ferrique 0,001 g, eau qsp 1000 ml) : les plantes s''y développent, fleurissent et donnent des graines fertiles. Un **milieu synthétique incomplet**, ou **carencé**, est privé d''un élément.

_Exemple détaillé_ : six lots de maïs, un sur milieu de Knop (le **témoin**) et cinq sur milieux carencés. Au bout de 3 semaines, chaque carence laisse **sa** signature :

| Milieu de culture | État des feuilles                        | Masse sèche (g / 100 pieds) |
| ----------------- | ---------------------------------------- | --------------------------: |
| Knop (complet)    | normales                                 |                         162 |
| sans azote        | chlorose                                 |                          68 |
| sans phosphore    | jaunissement à l''extrémité des feuilles  |                         116 |
| sans potassium    | nécrose                                  |                          44 |
| sans magnésium    | jaunissement du limbe entre les nervures |                         120 |
| sans fer          | chlorose                                 |                         130 |

Tous ces éléments sont donc nécessaires — mais pas aux mêmes doses. Les **macroéléments** (azote, phosphore, soufre, potassium) sont nécessaires à des doses de l''ordre du **gramme au milligramme** ; ils entrent dans la composition des organes et dans le fonctionnement des cellules. Les **oligoéléments** (calcium, magnésium, zinc, fer, chlore) sont nécessaires à des doses de l''ordre du **microgramme** ; ils interviennent dans le fonctionnement de la plante.

Et pour un même élément, la dose fait tout. On cultive 13 lots sur des milieux ne différant que par leur teneur en potassium, et on mesure leur vitesse de croissance :

::: figure Trois domaines sur une seule courbe : la croissance grimpe, plafonne, puis s''effondre — trop de potassium est aussi nuisible que pas assez
<svg viewBox="0 0 340 260">
<path d="M50 226 V220 H328" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M322 214 L331 220 L322 226 Z M44 59 L50 48 L56 59 Z" fill="#0f172a"/>
<path d="M182.5 220 V56 M235.5 220 V56" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
<path d="M50 220 V50" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M76.5 196.9 L89.8 187 L103 173.8 L129.5 154 L156 121 L182.5 67.1 L195.8 63.8 L209 62.7 L222.3 64.9 L235.5 66 L262 110 L288.5 165 L315 209" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>
<g fill="#0f6e56">
<circle cx="76.5" cy="196.9" r="2.4"/><circle cx="89.8" cy="187" r="2.4"/><circle cx="103" cy="173.8" r="2.4"/><circle cx="129.5" cy="154" r="2.4"/><circle cx="156" cy="121" r="2.4"/><circle cx="182.5" cy="67.1" r="2.4"/><circle cx="195.8" cy="63.8" r="2.4"/><circle cx="209" cy="62.7" r="3.6"/><circle cx="222.3" cy="64.9" r="2.4"/><circle cx="235.5" cy="66" r="2.4"/><circle cx="262" cy="110" r="2.4"/><circle cx="288.5" cy="165" r="2.4"/><circle cx="315" cy="209" r="2.4"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M46 165 H50"/><path d="M46 110 H50"/><path d="M46 55 H50"/>
<path d="M182.5 220 V224"/><path d="M235.5 220 V224"/><path d="M315 220 V224"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="42" y="169" text-anchor="end" fill="#0f172a">50</text>
<text x="42" y="114" text-anchor="end" fill="#0f172a">100</text>
<text x="42" y="59" text-anchor="end" fill="#0f172a">150</text>
<text x="182.5" y="236" text-anchor="middle" fill="#0f172a">500</text>
<text x="235.5" y="236" text-anchor="middle" fill="#0f172a">700</text>
<text x="315" y="236" text-anchor="middle" fill="#0f172a">1000</text>
<text x="316" y="252" text-anchor="middle" fill="#0f172a">mg/l</text>
<text x="116" y="40" text-anchor="middle" fill="#0f172a">déficience</text>
<text x="209" y="40" text-anchor="middle" fill="#0f6e56">optimum</text>
<text x="276" y="40" text-anchor="middle" fill="#0f172a">toxicité</text>
</g>
</svg>
:::

En dessous de 500 mg/l, la croissance est limitée par le manque : c''est la **déficience**. Entre 500 et 700 mg/l, elle est maximale (143 à 600 mg/l) : c''est la **concentration optimale**. Au-delà de 700 mg/l, elle s''effondre (10 seulement à 1000 mg/l) : la **concentration toxique** empoisonne la plante.

## 🚰 La conduction verticale : le xylème

Plonge une tige de marguerite dans de l''éosine à 2 % : le colorant se retrouve en haut, dans les pétales. Une racine de carotte dans du bleu de méthylène à 1 % pendant 24 heures montre, en coupe, les canaux empruntés. Ce sont les **vaisseaux du bois**.

Le **carmino-vert** les révèle : il colore en **vert** les parois riches en **lignine** (le bois) et en **rose foncé** celles riches en **cellulose**. Un **vaisseau du bois** est une file de **cellules mortes**, réduites à leur paroi lignifiée ; l''ensemble des vaisseaux du bois forme le **xylème**. Selon l''épaississement de leur paroi on distingue les vaisseaux **annelés**, **spiralés** et **réticulés**.

La **sève brute** — le mélange d''eau et de sels minéraux — y monte des racines vers les feuilles, poussée par la racine et aspirée par les feuilles.

## 🚜 Améliorer la production végétale

Tout ce qui précède sert ici : on améliore le rendement en agissant sur les facteurs de la nutrition minérale.

- **Une irrigation rationnelle**, ni excès ni déficit. Trop d''eau coûte cher, assèche les nappes et provoque une **asphyxie des racines**, qui réduit l''absorption. Un déficit fait chuter le rendement, surtout pendant la **reproduction**, période la plus sensible ; le tournesol supporte bien un déficit modéré, le maïs beaucoup moins. Il faut choisir la technique, le moment et le volume.
- **Une fertilisation du sol**, pour restituer les éléments consommés. La **fertilisation minérale** épand des engrais chimiques (azote, phosphore, potassium) : **simples** s''ils apportent un seul élément, **composés** s''ils en apportent plusieurs. La **fertilisation organique** apporte fumier, déchets ou **engrais vert** (on sème du trèfle ou de la luzerne puis on l''enfouit) : les micro-organismes le minéralisent progressivement et libèrent des nitrates.
- **La lutte contre les mauvaises herbes**, qui concurrencent la culture pour l''eau et les sels minéraux.
- **Des semences sélectionnées** sur leur productivité et leur résistance aux maladies. En 1943, les agronomes mexicains ont trouvé une variété de blé résistante à la **rouille de la tige** ; le Mexique est devenu autosuffisant en blé.
- **La culture sous serre**, où les conditions climatiques, hydriques et thermiques sont contrôlées, et la **culture hors-sol**, où la plante pousse sur une solution nutritive dosée — le milieu synthétique de Knop devenu technique agricole.

> 🏆 Première quête franchie, héros : tu sais par où l''eau entre, quelle force l''y pousse, ce qui la fait monter et pourquoi une dose d''engrais peut tuer une plante. Il te reste une énigme : la plante ne mange pas que des minéraux — d''où vient son carbone ? C''est le prochain chapitre.', '# 📜 Résumé : La nutrition minérale

- **Absorption d''eau** : entrée d''eau par le système racinaire, au niveau des **poils absorbants** de la **zone pilifère** (12 à 15 μm de diamètre, jusqu''à 2000/cm², environ 400 m² de surface chez un plant de seigle) ; on la mesure au **potomètre** et on en tire une vitesse en cm³/heure.
- **Osmose** : passage d''eau à travers une membrane semi-perméable, du milieu **le moins concentré (hypotonique)** vers **le plus concentré (hypertonique)**, jusqu''à l''**isotonie** ; d''où la **turgescence** (NaCl 2 g/l) et la **plasmolyse** (NaCl 20 g/l). La force est la **pression osmotique** π = n.R.T (R = 0,082 ; T en degré Kelvin = T°C + 273).
- **Conduction latérale** : la pression osmotique croît du poil absorbant vers le cylindre central, donc l''eau traverse la racine de cellule en cellule, toujours par osmose.

::: figure La pression osmotique monte à chaque cellule : c''est ce seul escalier de valeurs qui tire l''eau du sol jusqu''au cylindre central
<svg viewBox="0 0 340 130">
<path d="M20 26 H304" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M300 20 L310 26 L300 32 Z" fill="#0f6e56"/>
<rect x="14" y="40" width="42" height="60" fill="#38bdf8" opacity="0.25" stroke="#0f172a" stroke-width="1.5"/>
<g stroke="#0f172a" stroke-width="1.5">
<rect x="60" y="40" width="40" height="60" fill="#0f6e56" opacity="0.10"/>
<rect x="102" y="40" width="40" height="60" fill="#0f6e56" opacity="0.16"/>
<rect x="144" y="40" width="40" height="60" fill="#0f6e56" opacity="0.22"/>
<rect x="186" y="40" width="40" height="60" fill="#0f6e56" opacity="0.28"/>
<rect x="228" y="40" width="40" height="60" fill="#0f6e56" opacity="0.34"/>
<rect x="270" y="40" width="40" height="60" fill="#0f6e56" opacity="0.40"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="162" y="19" text-anchor="middle" fill="#0f6e56">H₂O</text>
<text x="35" y="75" text-anchor="middle" fill="#0f172a">0,5</text>
<text x="80" y="75" text-anchor="middle" fill="#0f172a">0,7</text>
<text x="122" y="75" text-anchor="middle" fill="#0f172a">1,4</text>
<text x="164" y="75" text-anchor="middle" fill="#0f172a">1,8</text>
<text x="206" y="75" text-anchor="middle" fill="#0f172a">2,1</text>
<text x="248" y="75" text-anchor="middle" fill="#0f172a">2,8</text>
<text x="290" y="75" text-anchor="middle" fill="#0f172a">3</text>
<text x="35" y="118" text-anchor="middle" fill="#0f172a">sol</text>
<text x="102" y="118" text-anchor="middle" fill="#0f6e56">poil absorbant</text>
<text x="272" y="118" text-anchor="middle" fill="#0f172a">cylindre central</text>
</g>
</svg>
:::

- **Transpiration** : perte d''eau sous forme de vapeur, par les **deux faces** de la feuille (davantage par l''inférieure), à travers les **stomates** (deux cellules stomatiques bordant un **ostiole**) ; la **cuticule** est une voie accessoire. Elle augmente avec la surface foliaire et la densité stomatique (facteurs internes), et avec la lumière, la température (jusqu''à 25 à 30 °C), le dessèchement et l''agitation de l''air (facteurs externes).
- **Couplage absorption ↔ transpiration** : la transpiration crée l''**aspiration foliaire** ; la racine exerce la **poussée radiculaire** (pleurs de la vigne, expérience de Hales). L''eau est à la fois poussée et aspirée. Le **bilan hydrique** = eau absorbée − eau perdue ; négatif, la plante se fane.
- **Besoins en sels minéraux** : établis par la **méthode analytique** (composition élémentaire) et la **méthode synthétique** (milieu de Knop, milieux carencés → chlorose, nécrose, jaunissements). **Macroéléments** N, P, S, K (du g au mg) ; **oligoéléments** Ca, Mg, Zn, Fe, Cl (de l''ordre du μg). Trois domaines de dose : **déficience / optimum / toxicité**.
- **Conduction verticale** : la **sève brute** (eau + sels minéraux) monte des racines aux feuilles dans les **vaisseaux du bois** — files de cellules mortes à paroi lignifiée (annelés, spiralés, réticulés) — dont l''ensemble forme le **xylème** ; le **carmino-vert** colore la lignine en vert et la cellulose en rose foncé.
- **Amélioration de la production** : irrigation rationnelle (excès → asphyxie racinaire ; déficit → chute du rendement, la reproduction étant le stade le plus sensible), fertilisation minérale (engrais simples ou composés) et organique (fumier, engrais vert), lutte contre les mauvaises herbes, semences sélectionnées, culture sous serre et hors-sol.', 1, '{"code":"225104P00","pages":"8-43","pageNumbers":[8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', 'La nutrition carbonée — l''usine à matière organique', 'Mise en évidence des substances organiques (glucides, protides, lipides) dans les organes de réserve et dans la feuille ; les trois conditions de la photosynthèse démontrées expérimentalement (lumière, chlorophylle, dioxyde de carbone) ; la cellule chlorophyllienne et le chloroplaste comme siège, spectre d''absorption et spectre d''action ; l''origine du carbone et de l''oxygène établie par marquage radioactif et la photolyse de l''eau ; les deux phases de la photosynthèse (expérience de Gaffron) et l''équation globale ; le transport de la sève élaborée par le phloème (tubes criblés, annélation, sens de circulation) et la mise en réserve ; l''intensité photosynthétique, la relation IPN = IPB − IR, le point de compensation et les facteurs limitants ; les risques sanitaires des nitrates et des pesticides, les engrais naturels et la lutte biologique', '# ⚔️ La nutrition carbonée — l''usine à matière organique

> 💡 «Une plante ne mange que du minéral, et pourtant elle fabrique du sucre, de l''huile et des protéines. Découvre l''usine qui réalise ce tour de force — et la source d''énergie qui la fait tourner.»

Au chapitre précédent, héros, tu as suivi l''eau et les sels minéraux du sol jusqu''à la feuille. Mais la production végétale n''est pas faite que d''eau et de minéraux : elle est faite de **substances carbonées** — glucides, lipides, protides. La plante se nourrit **uniquement** de matière minérale et fabrique pourtant toute cette matière organique. Comment ? À quelles conditions ? Et à quel prix pour notre santé quand on veut en produire toujours plus ?

## 🍞 La matière organique dans la plante verte

La matière vivante comporte trois groupes de substances organiques : les **glucides**, les **protides** et les **lipides**. Chacun se révèle par un test simple.

| Substance recherchée                     | Manipulation                                       | Résultat                                                |
| ---------------------------------------- | -------------------------------------------------- | ------------------------------------------------------- |
| **Amidon** (tubercule de pomme de terre) | ajouter quelques gouttes d''**eau iodée**           | coloration **bleue foncée**                             |
| **Glucose** (jus de raisin)              | ajouter de la **liqueur de Fehling** et chauffer   | **précipité rouge brique**                              |
| **Gluten** (graines de fève, de haricot) | recouvrir de **CuSO₄**, vider, ajouter de la soude | coloration **violette**                                 |
| **Huile** (olive)                        | frotter l''échantillon sur un papier                | **tache translucide** qui ne disparaît pas à la chaleur |

L''**amidon** est une grosse molécule glucidique, association de nombreuses molécules de **glucose** ; un **protide** est formé de plusieurs acides aminés ; un **lipide** est une matière grasse.

_Exemple détaillé_ : les feuilles d''un plant de pomme de terre contiennent de l''amidon **à la fin de la journée**, et n''en contiennent plus **au début de la journée suivante**. Deux indices en un : la feuille en fabrique le jour, et ce qu''elle fabrique **ne reste pas sur place**.

## ☀️ Les trois conditions de la photosynthèse

La formation de matière organique à partir de matière minérale, avec de l''énergie lumineuse, s''appelle la **photosynthèse**. Trois expériences, trois conditions — chacune obtenue en supprimant **un seul** facteur.

| Ce qu''on supprime         | Le montage                                                                                        | Ce qu''on démontre               |
| ------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------- |
| La **lumière**            | un **cache opaque** sur une partie d''une feuille de pélargonium                                   | sans lumière, pas d''amidon      |
| La **chlorophylle**       | une feuille **panachée** (des zones vertes, des zones blanches) exposée à la lumière              | sans chlorophylle, pas d''amidon |
| Le **dioxyde de carbone** | l''air du sac n° 2 barbote dans la **potasse**, qui absorbe le CO₂ ; le sac n° 1 est le **témoin** | sans CO₂, pas d''amidon          |

Dans chaque cas, on révèle l''amidon de la même façon : eau bouillante (pour tuer les cellules), alcool bouillant (pour décolorer), puis eau iodée.

> 🗡️ Dans le montage du CO₂, l''air traverse **deux** flacons : le premier (potasse) absorbe le dioxyde de carbone ; le second (eau de chaux) **contrôle** qu''il a bien été totalement absorbé. Un montage sérieux ne se contente pas d''agir : il vérifie qu''il a agi.

La **chlorophylle** est le pigment responsable de la coloration verte des végétaux ; elle est nécessaire à la photosynthèse.

## 🔬 Le siège : le chloroplaste — et le rôle de la chlorophylle

Une petite feuille d''élodée montée entre lame et lamelle révèle l''organisation de la **cellule chlorophyllienne** : une **paroi pectocellulosique**, un **cytoplasme**, et — c''est ce qui la distingue de toute autre cellule végétale — des **chloroplastes**.

::: figure Ce qui distingue une cellule chlorophyllienne d''une autre cellule végétale, ce sont ces petits corps verts : les chloroplastes
<svg viewBox="0 0 340 220">
<rect x="90" y="60" width="170" height="110" rx="5" fill="none" stroke="#0f172a" stroke-width="3"/>
<rect x="95" y="65" width="160" height="100" rx="3" fill="#0f6e56" opacity="0.07"/>
<g fill="#0f6e56" opacity="0.7" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="125" cy="86" rx="17" ry="9" transform="rotate(-20 125 86)"/>
<ellipse cx="175" cy="74" rx="17" ry="9" transform="rotate(10 175 74)"/>
<ellipse cx="222" cy="90" rx="17" ry="9" transform="rotate(-15 222 90)"/>
<ellipse cx="152" cy="118" rx="17" ry="9" transform="rotate(15 152 118)"/>
<ellipse cx="205" cy="140" rx="17" ry="9" transform="rotate(-10 205 140)"/>
<ellipse cx="238" cy="118" rx="17" ry="9" transform="rotate(25 238 118)"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M170 38 V58"/><path d="M232 84 L280 66"/><path d="M108 148 L62 178"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="30" text-anchor="middle" fill="#0f172a">paroi pectocellulosique</text>
<text x="300" y="62" text-anchor="middle" fill="#0f6e56">chloroplaste</text>
<text x="42" y="192" text-anchor="middle" fill="#0f172a">cytoplasme</text>
</g>
</svg>
:::

Le **chloroplaste** est l''organite de la cellule végétale **où se déroule la photosynthèse** — c''est là que l''eau iodée révèle l''amidon, chez les plantes éclairées et seulement chez elles.

Que fait exactement la chlorophylle ? On l''extrait en broyant des feuilles vertes avec du sable et de l''alcool à 90°, puis en filtrant : on obtient une **solution de chlorophylle brute**. Un prisme placé devant une source lumineuse décompose la lumière blanche sur un écran : c''est le **spectre de la lumière blanche**, l''ensemble des radiations élémentaires qui la composent. Intercale la solution de chlorophylle : des **bandes d''absorption** apparaissent — certaines radiations ont été retenues.

- Le **spectre d''absorption** est la variation de l''absorption de la lumière en fonction de la longueur d''onde. Chaque molécule a le sien.
- Le **spectre d''action** est la variation de l''**intensité photosynthétique** en fonction de la longueur d''onde des radiations éclairantes.

Les deux se superposent : **les radiations les plus absorbées sont celles qui font le plus travailler la photosynthèse**. La chlorophylle ne subit pas la lumière : elle en **capte** l''énergie.

## 💨 D''où viennent le carbone et l''oxygène ? La photolyse de l''eau

Pour savoir d''où vient un atome, on le **marque** : on le rend radioactif et on le suit. Trois expériences sur des chlorelles (des algues unicellulaires) suffisent à tout trancher.

| Expérience                                               | Résultat                                                         |
| -------------------------------------------------------- | ---------------------------------------------------------------- |
| CO₂ dont le **carbone** est radioactif                   | les **glucides** fabriqués sont radioactifs                      |
| CO₂ dont l''**oxygène** est radioactif                    | l''O₂ dégagé n''est **pas** radioactif ; les **glucides** le sont  |
| **Eau** dont l''**oxygène** est radioactif, forte lumière | l''O₂ dégagé **est** radioactif ; les glucides ne le sont **pas** |
| La même, mais **à l''obscurité**                          | **aucun** dégagement d''oxygène                                   |

Conclusion sans échappatoire : le **carbone** de la matière organique vient du **dioxyde de carbone**, tandis que l''**oxygène dégagé** vient de l''**eau** — et son dégagement exige la lumière.

Le mécanisme porte un nom. Sous l''action de la lumière et en présence de chlorophylle, la molécule d''eau se décompose :

$$ 2 H₂O → O₂ + 4 H⁺ + 4 e⁻ $$

C''est la **photolyse de l''eau**, une réaction photochimique. L''oxygène est dégagé ; les protons, eux, serviront avec le CO₂ à fabriquer la matière organique.

> ⚠️ Piège classique : l''oxygène rejeté par la plante ne vient **pas** du CO₂, malgré son nom. Il vient de l''eau — la troisième expérience le prouve, et c''est exactement ce que les deux premières interdisaient de croire.

## ⚗️ Le déroulement : deux phases, une équation

En 1951, **Gaffron** apporte à des algues fortement éclairées du CO₂ radioactif, puis les passe à l''obscurité. Le carbone continue d''être incorporé pendant **15 à 20 secondes** — mais seulement si les algues ont reçu au préalable une forte illumination d''**au moins 10 minutes**. Sans cette illumination préalable, l''incorporation cesse dès le passage à l''obscurité.

Autrement dit : l''incorporation du CO₂ ne dépend **pas directement** de la lumière — elle dépend de quelque chose que la lumière a **mis en réserve**. La photosynthèse comprend donc deux ensembles de réactions :

1. La **phase photochimique**, à la lumière : la photolyse de l''eau et le **stockage d''énergie chimique**.
2. La **phase sombre**, dont le déroulement n''exige pas directement la lumière : l''**incorporation du CO₂** et la synthèse des substances organiques, avec l''énergie chimique stockée pendant la phase précédente.

D''où l''équation globale de la photosynthèse :

$$ 6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂ $$

(la lumière et la chlorophylle sont les conditions de la réaction ; C₆H₁₂O₆ est le glucose). Les premières substances fabriquées sont des **glucides simples** ; c''est à partir d''eux que la plante élabore les autres glucides (glucose, amidon), puis les lipides et les protides.

> 🗡️ Retiens le sens de la phrase « phase sombre » : elle ne se déroule pas **dans le noir**, elle se déroule **sans avoir besoin de la lumière**. En plein jour, les deux phases tournent en même temps.

## 🚚 La sève élaborée et le phloème

Les racines grandissent sans pouvoir fabriquer leur propre matière ; le tubercule de pomme de terre est bourré d''amidon sans pouvoir en synthétiser. Ce que la feuille fabrique **voyage**.

Une coupe transversale de pétiole colorée au carmin aluné vert d''iode montre **deux** sortes de vaisseaux : ceux de la sève brute (parois lignifiées, vertes) et ceux de la **sève élaborée** (parois cellulosiques, roses). La **cellulose** se colore en rose, la **lignine** en vert.

Les vaisseaux de la sève élaborée forment le **phloème** : ce sont des **tubes criblés**, chacun formé d''une file de **cellules vivantes** dont les **parois transversales sont percées de pores**.

::: figure La cellule d''un tube criblé a perdu son noyau et sa vacuole, et sa paroi transversale est criblée de pores — c''est par là que passe la sève élaborée
<svg viewBox="0 0 340 210">
<rect x="25" y="30" width="110" height="150" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="29" y="34" width="102" height="142" fill="#0f6e56" opacity="0.10"/>
<rect x="42" y="52" width="76" height="90" rx="10" fill="#7c3aed" opacity="0.30"/>
<circle cx="105" cy="158" r="10" fill="#0f172a" opacity="0.75"/>
<rect x="205" y="30" width="110" height="150" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="209" y="34" width="102" height="142" fill="#0f6e56" opacity="0.10"/>
<g stroke="#0f172a" stroke-width="3" fill="none">
<path d="M205 105 H222 M232 105 H247 M257 105 H272 M282 105 H297 M307 105 H315"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M114 160 L150 172"/><path d="M186 103 L228 105"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="80" y="101" text-anchor="middle" fill="#0f172a">vacuole</text>
<text x="170" y="180" text-anchor="middle" fill="#0f172a">noyau</text>
<text x="170" y="100" text-anchor="middle" fill="#0f6e56">pores</text>
<text x="80" y="200" text-anchor="middle" fill="#0f172a">cellule normale</text>
<text x="260" y="200" text-anchor="middle" fill="#0f6e56">tube criblé</text>
</g>
</svg>
:::

Dans quel sens circule cette sève ? Découpe **en anneau** l''écorce d''une tige : la plante reste alimentée en sève brute et la photosynthèse continue. Quelques heures plus tard, les substances organiques sont **anormalement abondantes au-dessus** de la zone décortiquée ; plusieurs semaines plus tard, un **bourrelet de cicatrisation** s''y est formé, **au-dessus** lui aussi. La sève élaborée était donc en train de **descendre** et l''anneau l''a bloquée.

La **sève élaborée** est la solution contenant les produits de la photosynthèse. Elle est distribuée à **tous les organes** — notamment vers le bas, vers les racines et les organes de réserve — à l''inverse de la sève brute, qui ne fait que monter. Une partie des molécules est dégradée pour produire l''énergie des fonctions vitales ; une autre est stockée : dans le tubercule de pomme de terre, l''eau iodée révèle des **amyloplastes**, ces cellules où l''amidon est mis en réserve.

## 📈 Les conditions optimales de la photosynthèse

L''**intensité photosynthétique (IP)** est la quantité de CO₂ absorbé ou d''O₂ rejeté **par unité de masse du végétal et par unité de temps**. Elle dépend de trois facteurs.

**1. L''intensité lumineuse.** Attention : la plante **respire aussi**, 24 heures sur 24, et la respiration consomme de l''oxygène. Ce que l''on mesure est donc un bilan, l''intensité photosynthétique **nette** :

$$ IPN = IPB − IR $$

où IPB est l''intensité photosynthétique brute et IR l''intensité respiratoire. À l''obscurité, seule la respiration est mesurée : l''IPN est négative. Pour un éclairement précis, IPB = IR — tout l''oxygène produit est consommé, le bilan est nul : c''est le **point de compensation**. Au-delà, l''IPN devient positive et croît, puis atteint un **palier**. Cet optimum n''est pas le même pour toutes les plantes : les **plantes de soleil** (épinard, pomme de terre) l''atteignent sous fort éclairement, les **plantes d''ombre** (fougère) sous un éclairement beaucoup plus faible.

**2. Le taux de CO₂.** L''IP augmente avec la teneur de l''air en dioxyde de carbone, puis cesse d''augmenter à partir de 0,3 % ; au-delà, elle peut même baisser — le CO₂ devient **toxique** pour le végétal.

::: figure Au-delà de 0,15 % de CO₂ la courbe se couche : ajouter du dioxyde de carbone ne change plus rien, car c''est un autre facteur qui limite désormais la photosynthèse
<svg viewBox="0 0 340 250">
<path d="M55 216 V210 H325" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M319 204 L328 210 L319 216 Z M49 56 L55 45 L61 56 Z" fill="#0f172a"/>
<path d="M55 210 V47" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M237.1 63.3 H312 M237.1 210 V70" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
<path d="M55 196.7 L91.4 163.3 L127.9 130 L164.3 103.3 L200.7 76.7 L237.1 63.3 L273.6 63.3 L310 63.3" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>
<g fill="#0f6e56">
<circle cx="55" cy="196.7" r="2.6"/><circle cx="91.4" cy="163.3" r="2.6"/><circle cx="127.9" cy="130" r="2.6"/><circle cx="164.3" cy="103.3" r="2.6"/><circle cx="200.7" cy="76.7" r="2.6"/><circle cx="237.1" cy="63.3" r="2.6"/><circle cx="273.6" cy="63.3" r="2.6"/><circle cx="310" cy="63.3" r="2.6"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M51 143.3 H55"/><path d="M51 76.7 H55"/>
<path d="M91.4 210 V214"/><path d="M164.3 210 V214"/><path d="M237.1 210 V214"/><path d="M310 210 V214"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="47" y="147" text-anchor="end" fill="#0f172a">5</text>
<text x="47" y="81" text-anchor="end" fill="#0f172a">10</text>
<text x="55" y="38" text-anchor="middle" fill="#0f172a">IP</text>
<text x="91.4" y="226" text-anchor="middle" fill="#0f172a">0,03</text>
<text x="164.3" y="226" text-anchor="middle" fill="#0f172a">0,09</text>
<text x="237.1" y="226" text-anchor="middle" fill="#0f172a">0,15</text>
<text x="310" y="226" text-anchor="middle" fill="#0f172a">0,21</text>
<text x="312" y="242" text-anchor="middle" fill="#0f172a">% CO₂</text>
<text x="276" y="55" text-anchor="middle" fill="#0f6e56">palier</text>
</g>
</svg>
:::

**3. La température.** L''IP augmente jusqu''à un optimum voisin de **30 à 40 °C**, puis diminue.

> ⚠️ Ne confonds pas les deux seuils du CO₂ — et lis bien ce qu''est un palier. **0,3 %** est le plafond du gaz lui-même : au-delà, il devient toxique. Mais la courbe de la figure se couche dès **0,15 %**, bien avant ce plafond. C''est que le **palier** ne dit jamais « la plante est au maximum de ses possibilités » : il dit qu''**un autre facteur** que celui qu''on étudie limite désormais le phénomène. C''est le **facteur limitant** — ici la température ou l''éclairement de cette plante-là, qui l''ont arrêtée avant que le CO₂ n''ait donné tout ce qu''il pouvait.

## ⚠️ Engrais, pesticides et santé

Produire plus a un coût. L''emploi d''engrais chimiques et de pesticides augmente le rendement, mais présente des effets néfastes sur la santé humaine.

- **Les nitrates.** Absorbés à forte dose, ils transforment l''hémoglobine en **méthémoglobine**, incapable de fixer l''oxygène de l''air et de le céder aux tissus : difficultés respiratoires, vertiges. Comly l''établit en 1945. La maladie atteint surtout les **nourrissons** et peut être mortelle. Les seuils : une eau destinée à la consommation humaine doit être **≤ 50 mg/l** ; entre **50 et 100 mg/l** elle reste utilisable **sauf** pour les femmes enceintes et les nourrissons de moins de 6 mois ; **au-delà de 100 mg/l** elle ne doit pas être consommée.
- **Les pesticides** — insecticides, herbicides, fongicides — sont nocifs à des degrés divers. Les enfants y sont plus vulnérables que les adultes : ils en absorbent davantage par kilogramme de poids corporel et portent tout à la bouche (45 % des intoxications aiguës rapportées au centre anti-poison de Québec concernent les 0 à 15 ans). La **rémanence** est la durée pendant laquelle le produit reste actif : si on ne la respecte pas, les fraises traitées contre le champignon Botrytis gardent des résidus de fongicide et provoquent des diarrhées.

Que faire ? Quatre leviers, tous dans le programme :

- **Les engrais naturels.** Le **compostage** est une fermentation de débris animaux et végétaux qui aboutit au **compost** ; avec la **fumure organique**, il remplace les engrais chimiques. Dans le sol, l''azote organique se **minéralise** d''abord en **ammoniaque**, puis en nitrates ; or l''ammoniaque est directement utilisable par la plante — d''où **moins de nitrates** et moins de risque.
- **L''usage rationnel des engrais chimiques**, en respectant les doses et en évitant l''épandage excessif d''engrais azotés.
- **Des pesticides à courte durée d''activité**, et le respect de la rémanence.
- **La lutte biologique**, qui remplace le produit chimique par un être vivant :
  - les **prédateurs naturels** — une coccinelle adulte mange **300 pucerons par jour**, sa larve plusieurs fois par jour sa propre masse ;
  - les **phéromones**, ces substances chimiques émises par les femelles pour attirer le partenaire sexuel. La **stérilisation des mâles** les piège avec des phéromones de synthèse, les stérilise par irradiation et les relâche : comme les ravageurs ne s''accouplent généralement qu''une fois, les femelles n''ont pas de descendance. La **confusion des mâles** dissémine des diffuseurs de phéromone synthétique dans la culture : le mâle, incapable de localiser une source plutôt qu''une autre, ne retrouve plus la femelle.
  - le **désherbage manuel**, contre les mauvaises herbes.

> 🏆 Deuxième quête franchie, héros : tu sais fabriquer du sucre avec de l''air, de l''eau et du soleil, lire un palier et reconnaître un facteur limitant. La plante sait se nourrir — reste à savoir se multiplier. C''est le prochain chapitre.', '# 📜 Résumé : La nutrition carbonée

- **Les substances organiques** : glucides, protides, lipides. Tests — amidon + eau iodée → bleu foncé ; glucose + liqueur de Fehling + chauffage → précipité rouge brique ; gluten + CuSO₄ + soude → violet ; huile → tache translucide résistant à la chaleur. La feuille contient de l''amidon le soir, plus le lendemain matin : elle en fabrique, et il s''en va.
- **Les trois conditions de la photosynthèse**, démontrées en supprimant un seul facteur à la fois : la **lumière** (cache opaque), la **chlorophylle** (feuille panachée), le **dioxyde de carbone** (air barbotant dans la potasse, sac témoin à côté). La **photosynthèse** est la formation de matière organique qui nécessite de l''énergie lumineuse.
- **Le siège** : la **cellule chlorophyllienne** (paroi pectocellulosique, cytoplasme, **chloroplastes**) ; le **chloroplaste** est l''organite où se déroule la photosynthèse. La chlorophylle **capte** la lumière : les radiations les plus absorbées (**spectre d''absorption**) sont celles qui font le plus travailler la photosynthèse (**spectre d''action**).
- **L''origine des atomes**, par marquage radioactif sur des chlorelles : le **carbone** de la matière organique vient du **CO₂** ; l''**oxygène dégagé** vient de l''**eau**, jamais du CO₂. Mécanisme : la **photolyse de l''eau**, 2 H₂O → O₂ + 4 H⁺ + 4 e⁻, sous l''action de la lumière et en présence de chlorophylle.
- **Deux phases** (expérience de Gaffron, 1951 : le CO₂ continue d''être incorporé 15 à 20 s à l''obscurité, après 10 min de forte lumière) : la **phase photochimique** (à la lumière : photolyse et stockage d''énergie chimique) et la **phase sombre** (incorporation du CO₂, sans besoin direct de lumière). Équation globale : **6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂**.
- **La sève élaborée** (les produits de la photosynthèse) circule dans le **phloème** : des **tubes criblés**, files de cellules **vivantes** sans noyau ni vacuole, à **parois transversales percées de pores**. Le carmin aluné vert d''iode colore la **cellulose** en rose et la **lignine** en vert. Elle est distribuée à tous les organes, dont les organes de réserve (**amyloplastes** du tubercule).

::: figure L''anneau d''écorce enlevé bloque la sève élaborée : les substances organiques s''accumulent au-dessus, et c''est au-dessus que se forme le bourrelet de cicatrisation — elle descendait donc
<svg viewBox="0 0 340 220">
<rect x="145" y="25" width="40" height="93" fill="#0f6e56" opacity="0.10"/>
<rect x="145" y="134" width="40" height="71" fill="#0f6e56" opacity="0.10"/>
<rect x="155" y="118" width="20" height="16" fill="#94a3b8" opacity="0.30"/>
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M145 25 V118 M185 25 V118"/>
<path d="M145 134 V205 M185 134 V205"/>
<path d="M155 118 V134 M175 118 V134"/>
<path d="M145 118 H155 M175 118 H185 M145 134 H155 M175 134 H185"/>
</g>
<path d="M145 118 C 130 110, 132 94, 150 92 L180 92 C 198 94, 200 110, 185 118 Z" fill="#0f6e56" opacity="0.40" stroke="#0f172a" stroke-width="2"/>
<g fill="none" stroke="#0f6e56" stroke-width="2.5">
<path d="M152 36 V80"/><path d="M178 36 V80"/>
</g>
<g fill="#0f6e56">
<path d="M147 78 L152 88 L157 78 Z"/><path d="M173 78 L178 88 L183 78 Z"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M114 58 L146 60"/><path d="M198 100 L222 88"/><path d="M188 128 L214 146"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="72" y="58" text-anchor="middle" fill="#0f6e56">sève élaborée</text>
<text x="250" y="84" text-anchor="middle" fill="#0f172a">bourrelet</text>
<text x="252" y="152" text-anchor="middle" fill="#0f172a">écorce enlevée</text>
</g>
</svg>
:::

- **L''intensité photosynthétique (IP)** = quantité de CO₂ absorbé ou d''O₂ rejeté par unité de masse et de temps. La plante respirant 24 h sur 24, on mesure **IPN = IPB − IR** ; quand IPB = IR le bilan est nul : c''est le **point de compensation**. Un **palier** signale un **facteur limitant** (température, taux de CO₂). Facteurs : lumière (**plantes de soleil** épinard, pomme de terre / **plantes d''ombre** fougère), taux de CO₂ (l''augmentation cesse à 0,3 %, au-delà le CO₂ devient toxique), température (optimum voisin de 30 à 40 °C).
- **Engrais, pesticides et santé** : les **nitrates** transforment l''hémoglobine en **méthémoglobine** (eau de consommation ≤ 50 mg/l ; 50 à 100 mg/l interdite aux femmes enceintes et aux nourrissons de moins de 6 mois ; > 100 mg/l non consommable) ; les **pesticides** (insecticides, herbicides, fongicides) exigent le respect de la **rémanence**. Parades : **engrais naturels** (compost, fumure organique — minéralisation en ammoniaque puis en nitrates), usage rationnel des engrais chimiques, pesticides à courte durée d''activité, **lutte biologique** (prédateurs — 300 pucerons par jour pour une coccinelle adulte ; **phéromones** — stérilisation ou confusion des mâles ; désherbage manuel).', 2, '{"code":"225104P00","pages":"44-73","pageNumbers":[44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', 'La multiplication végétative — cloner une plante performante', 'Les techniques traditionnelles de multiplication végétative : le bouturage (pomme de terre et son cycle végétatif, pélargonium et racines adventives, olivier en bouturage semi-ligneux avec formation d''un cal, et par éclat de souche), le marcottage, et le greffage (greffon, porte greffe, végétal franc, greffe en fente, greffe en écusson, raccordement des vaisseaux conducteurs, possibilités de greffage) ; l''importance et les avantages de la multiplication végétative ; la multiplication végétative par culture in vitro (microbouturage de l''olivier, conditions d''asepsie, vitro pousses, acclimatation) et la culture in vitro des cellules méristématiques ; totipotence et clone ; l''intérêt de la culture in vitro (clones sains, sauvegarde des espèces en voie de disparition, économie de temps et d''espace)', '# ⚔️ La multiplication végétative — cloner une plante performante

> 💡 «Tu as trouvé l''olivier parfait. Une graine te donnera un descendant qui ne lui ressemblera pas forcément. Un fragment de rameau, lui, te donnera exactement le même — et par milliers.»

Tu sais désormais, héros, comment la plante se nourrit d''eau, de sels minéraux et de carbone. Mais un agriculteur qui a repéré une plante **performante** — bon rendement, beau fruit, résistante aux maladies — veut la **multiplier telle quelle**. Chez le bananier, le grenadier, le figuier, la vigne, la pomme de terre ou le jasmin, la multiplication végétative est même le seul moyen d''obtenir facilement et rapidement une production importante. Voici ses techniques, de la plus vieille à la plus moderne.

## 🌿 Deux façons de faire une plante

Au collège tu as appris que les végétaux ont **deux modes de reproduction** :

- la **reproduction sexuée**, assurée par la **graine** ;
- la **reproduction asexuée**, ou **multiplication végétative**, à partir d''organes végétatifs variés : tige, rhizome, tubercule, bulbe.

Ses trois modes traditionnels sont le **bouturage**, le **marcottage** et le **greffage**. Tous partagent une propriété capitale : ils **conservent les caractères de la plante mère**.

_Exemple détaillé_ : un fragment de tubercule de pomme de terre planté en **automne** donne un pied qui produit **15 à 30 tubercules**, récoltés au **printemps**. Une **graine** de pomme de terre, elle, ne donne un plant à tubercules normaux qu''au bout de **quatre ans**. Même plante, deux chemins — et un rapport de 1 à 8 sur les délais.

## ✂️ Le bouturage

**Principe** : mis à terre, un fragment d''organe de l''appareil végétatif de certaines plantes s''enracine et développe une nouvelle plante. Ce fragment est la **bouture**.

- **Chez la pomme de terre.** Le tubercule est une portion de **tige souterraine** qui porte des **bourgeons**. Planté, il fournit un plant complet ; et **un seul bourgeon isolé** suffit à donner un plant normal producteur de tubercules normaux. Son cycle végétatif enchaîne quatre phases : **croissance** de la plante feuillée, **tubérisation**, **repos** du tubercule (plusieurs mois), puis **germination**.
- **Chez le pélargonium.** Un rameau feuillé isolé, enfoncé dans de la terre humide, développe des **racines adventives** près de la section ; la partie aérienne s''accroît, se ramifie et engendre des feuilles.
- **Chez l''olivier**, deux techniques. Le **bouturage semi-ligneux** : on prépare une bouture de **15 à 17 cm** sur un rameau âgé d''**au moins un an**, on garde **deux paires de feuilles** au sommet, on enracine à **23 à 25 °C** sous une humidité **supérieure à 80 %** ; un **cal** se développe au bout de quelques semaines, les racines apparaissent vers **8 semaines**. Le **bouturage par éclat de souche** : la protubérance de la base du tronc est fragmentée en tronçons de **15 à 20 cm** pesant de **500 g à 5 kg**, les **éclats de souche** ou **souchets** ; enterré et irrigué, le souchet s''enracine et donne une plante identique à la plante mère.

## 🪢 Le marcottage

**Principe** : on enterre à quelques centimètres, ou dans un pot, une tige aérienne — **sans la détacher de la plante**. Quelques semaines plus tard, des **racines adventives** se sont formées. On isole alors la tige enracinée : on obtient une nouvelle plante identique à la plante mère.

::: figure La bouture est un fragment détaché qui s''enracine tout seul ; la marcotte, elle, reste attachée à la plante mère pendant qu''elle s''enracine — on ne la sépare qu''après
<svg viewBox="0 0 340 200">
<rect x="10" y="140" width="320" height="45" fill="#a16207" opacity="0.20"/>
<path d="M10 140 H330" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M70 138 V60" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="55" cy="78" rx="14" ry="7" transform="rotate(-25 55 78)"/>
<ellipse cx="86" cy="66" rx="14" ry="7" transform="rotate(20 86 66)"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M70 142 L58 166"/><path d="M70 142 V172"/><path d="M70 142 L83 166"/>
</g>
<path d="M215 140 V52" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="199" cy="72" rx="14" ry="7" transform="rotate(-25 199 72)"/>
<ellipse cx="231" cy="60" rx="14" ry="7" transform="rotate(20 231 60)"/>
<ellipse cx="309" cy="106" rx="13" ry="7" transform="rotate(25 309 106)"/>
</g>
<path d="M215 105 C 250 95, 276 116, 286 142" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M286 145 L302 116" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M286 145 L275 168"/><path d="M286 145 V174"/><path d="M286 145 L298 168"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="70" y="194" text-anchor="middle" fill="#0f6e56">bouture</text>
<text x="200" y="194" text-anchor="middle" fill="#0f172a">plante mère</text>
<text x="292" y="194" text-anchor="middle" fill="#0f6e56">marcotte</text>
</g>
</svg>
:::

> ⚠️ Piège classique : bouture et marcotte se ressemblent une fois enracinées. La différence tient à **un seul détail de chronologie** — la bouture est **détachée d''abord**, la marcotte **détachée après**. Le marcottage laisse donc la plante mère nourrir la tige tant qu''elle n''a pas ses racines.

## 🔗 Le greffage

Le **greffage** met en jeu deux plantes. Le **greffon** est un fragment de tige — un bourgeon ou un jeune rameau — prélevé sur un végétal **sélectionné pour la qualité de ses fruits ou de ses fleurs**. Le **porte greffe** est la plante sur laquelle on le fixe. Tous deux appartiennent à la **même espèce ou à des espèces voisines**.

**Principe** : le greffon est fixé sur le porte greffe de telle sorte que **les vaisseaux conducteurs des deux se raccordent**. Sans ce raccordement, la sève ne passe pas et la greffe échoue.

::: figure Le greffon, taillé en biseau, est glissé dans la fente du porte greffe puis ligaturé et masticé — tout l''enjeu est que les vaisseaux conducteurs des deux se raccordent
<svg viewBox="0 0 340 230">
<rect x="10" y="195" width="320" height="32" fill="#a16207" opacity="0.20"/>
<path d="M10 195 H330" fill="none" stroke="#0f172a" stroke-width="2"/>
<rect x="145" y="110" width="44" height="85" fill="#a16207" opacity="0.35" stroke="#0f172a" stroke-width="2.5"/>
<path d="M167 110 V142" fill="none" stroke="#0f172a" stroke-width="2"/>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M167 197 L148 220"/><path d="M167 197 V224"/><path d="M167 197 L186 220"/>
</g>
<path d="M167 120 V45" fill="none" stroke="#0f6e56" stroke-width="3"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="151" cy="62" rx="14" ry="7" transform="rotate(-25 151 62)"/>
<ellipse cx="184" cy="50" rx="14" ry="7" transform="rotate(20 184 50)"/>
</g>
<rect x="141" y="108" width="52" height="20" fill="none" stroke="#0f172a" stroke-width="1.5"/>
<g stroke="#0f172a" stroke-width="1.2">
<path d="M147 128 L157 108 M159 128 L169 108 M171 128 L181 108 M183 128 L193 108"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M172 70 L214 66"/><path d="M191 165 L216 168"/><path d="M139 118 L112 118"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="243" y="70" text-anchor="middle" fill="#0f6e56">greffon</text>
<text x="256" y="172" text-anchor="middle" fill="#0f172a">porte greffe</text>
<text x="80" y="122" text-anchor="middle" fill="#0f172a">ligature</text>
</g>
</svg>
:::

Deux modalités sont au programme.

| Modalité              | Le greffon                                                                                                    | Le porte greffe                                                                                     | La finition                                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| **Greffe en fente**   | un **rameau taillé en biseau**                                                                                | **au moins 3 cm** de diamètre, **rabattu 10 à 20 cm** au-dessus du sol, **fendu** longitudinalement | ligature + **mastic** ; écorces au même niveau |
| **Greffe en écusson** | un **bourgeon** accompagné d''une bande d''écorce, prélevé sur un rameau d''un arbre âgé d''**au moins deux ans** | écorce **incisée en T**, greffon inséré entre les deux lèvres, en contact avec le bois              | ligature                                       |

**Le résultat**, et c''est tout l''intérêt : le porte greffe conserve son **appareil absorbant** complet (les racines) et une partie du tronc ; le greffon développe un **appareil assimilateur et de fructification** (rameaux, tige, feuilles, fruits) **à l''exclusion de toute racine**. La nouvelle plante porte les **caractères de la plante qui a fourni le greffon**.

Un **végétal franc** est un végétal provenant des semis. C''est souvent lui qu''on utilise comme porte greffe :

| Modalité          | Greffon    | Porte greffe                     | Période |
| ----------------- | ---------- | -------------------------------- | ------- |
| Greffe en fente   | pommier    | pommier franc                    | hiver   |
| Greffe en fente   | poirier    | poirier franc, cognassier        | —       |
| Greffe en écusson | abricotier | abricotier franc, amandier franc | mai     |
| Greffe en écusson | pêcher     | pêcher franc, amandier franc     | juin    |

> 🗡️ Retiens la répartition des rôles : **les racines viennent du porte greffe, les fruits viennent du greffon**. C''est pour cela qu''on peut greffer un abricotier sur un **amandier** franc — l''amandier fournit les racines, l''abricotier les abricots.

## 🧫 La culture in vitro

Les techniques traditionnelles multiplient vite, mais le **nombre** de plantes obtenues reste faible. La **culture in vitro** change d''échelle.

**Le microbouturage.** On prélève sur une plante performante une **microbouture** renfermant un **bourgeon**. Ce bourgeon renferme des cellules embryonnaires, les **cellules totipotentes**, capables de se développer pour donner **n''importe quelle partie** de la plante : tige, racine, feuille. La technique exige des conditions d''**asepsie**. Chez l''olivier, elle suit neuf étapes :

1. **fragmentation** d''un rameau prélevé sur une plante, en microboutures ;
2. **mise en culture** sur un milieu nutritif, en conditions stériles ;
3. développement des **vitro pousses** — trois mois en moyenne ;
4. **fragmentation** d''une vitro pousse, en conditions stériles ;
5. **remise** sur milieu nutritif ;
6. **développement** ;
7. **enracinement** ;
8. **mise en pot** pour la phase d''**acclimatation** ;
9. **plantation** dans un champ.

Les étapes 4, 5 et 6 se **répètent plusieurs fois** — et c''est là que tout se joue. En un an, on obtient **400 000 oliviers** identiques à la plante d''origine, là où le bouturage traditionnel n''en donnerait dans le même temps qu''**une vingtaine**.

**La culture des cellules méristématiques.** À l''extrémité d''un **bourgeon terminal** se trouvent des **cellules méristématiques**, celles qui permettent la croissance et l''édification des organes du végétal. Isolées et cultivées in vitro sur un milieu convenable, elles forment un massif cellulaire qu''on fragmente ; quelques mois plus tard, on dispose d''un très grand nombre de plantes performantes toutes identiques.

::: figure Tout en haut du bourgeon, sous les jeunes feuilles, une poignée de cellules seulement : ce sont elles qui édifient tous les organes — et elles seules qu''on prélève pour la culture in vitro
<svg viewBox="0 0 340 220">
<rect x="155" y="94" width="30" height="112" fill="#0f6e56" opacity="0.12" stroke="#0f172a" stroke-width="2"/>
<g fill="#0f6e56" opacity="0.30" stroke="#0f172a" stroke-width="1.8" stroke-linejoin="round">
<path d="M156 116 C 130 112, 112 142, 122 176 C 138 152, 152 138, 158 122 Z"/>
<path d="M184 116 C 210 112, 228 142, 218 176 C 202 152, 188 138, 182 122 Z"/>
<path d="M158 104 C 138 98, 128 122, 134 148 C 146 130, 155 118, 160 108 Z"/>
<path d="M182 104 C 202 98, 212 122, 206 148 C 194 130, 185 118, 180 108 Z"/>
</g>
<path d="M155 96 A 15 15 0 0 1 185 96 Z" fill="#0f6e56" opacity="0.85" stroke="#0f172a" stroke-width="1.8"/>
<g fill="#ffffff" opacity="0.9">
<circle cx="163" cy="90" r="2.6"/><circle cx="170" cy="86" r="2.6"/><circle cx="177" cy="90" r="2.6"/><circle cx="166" cy="94" r="2.6"/><circle cx="174" cy="94" r="2.6"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M183 88 L216 58"/><path d="M120 172 L98 178"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="250" y="52" text-anchor="middle" fill="#0f6e56">cellules méristématiques</text>
<text x="62" y="182" text-anchor="middle" fill="#0f172a">jeune feuille</text>
</g>
</svg>
:::

## 🏆 Pourquoi multiplier ainsi ?

Toutes les plantes issues de la multiplication végétative d''une même plante mère forment un **clone** : un ensemble d''individus possédant les mêmes caractères et provenant de la multiplication végétative d''un individu unique. Ce qui rend le clonage possible, c''est la **totipotence** des cellules des végétaux chlorophylliens : leur capacité à se développer et à donner **n''importe quel organe** de la plante à partir d''une seule cellule.

Les avantages, traditionnels d''abord :

- **conserver les caractères** appréciés du consommateur : rendement élevé, qualité alimentaire, industrielle ou ornementale, résistance aux maladies ;
- **gagner du temps** : quelques mois au lieu de quatre ans chez la pomme de terre.

Puis ceux, décisifs, de la culture in vitro :

- **des clones sains** : les maladies à virus ravagent les cultures de pomme de terre ; la culture des méristèmes a permis de reconstituer des clones indemnes ;
- **la sauvegarde d''espèces en voie de disparition**, parce qu''elles se reproduisent difficilement — pommier ancien, rosier ancien ;
- **une économie d''espace et de temps** : un local de culture in vitro climatisé de **9 m²** remplace **25 500 m²** de serres chauffées ou refroidies selon la saison. Un grand producteur d''œillets obtient en **deux ans** ce qu''il produisait en **quatre ans** par la culture traditionnelle — deux ans de chauffage de plusieurs hectares de serres économisés.

> ⚠️ Un clone n''est pas « une plante meilleure » : c''est **la même** plante, en très grand nombre. Il n''améliore rien par lui-même — il **conserve** et **multiplie** ce que la plante mère avait déjà. C''est le choix de la plante mère qui décide de tout.

> 🏆 Troisième quête franchie, héros : tu sais faire une plante à partir d''un fragment, marier deux végétaux et en cloner 400 000 en un an. La partie « production végétale » est bouclée. Une autre t''attend, invisible à l''œil nu : le monde microbien.', '# 📜 Résumé : La multiplication végétative

- **Deux modes de reproduction** : la **reproduction sexuée**, assurée par la graine, et la **reproduction asexuée** ou **multiplication végétative**, à partir d''organes végétatifs (tige, rhizome, tubercule, bulbe). Ses trois modes traditionnels — bouturage, marcottage, greffage — **conservent les caractères de la plante mère**. Repère : un fragment de tubercule planté en automne donne 15 à 30 tubercules au printemps ; une graine met **quatre ans** à donner un plant à tubercules normaux.
- **Bouturage** : un fragment d''organe végétatif mis à terre s''enracine et développe une nouvelle plante ; ce fragment est la **bouture**, qui émet des **racines adventives**. Chez l''olivier : **bouturage semi-ligneux** (bouture de 15 à 17 cm sur un rameau d''au moins un an, deux paires de feuilles, 23 à 25 °C, humidité > 80 % ; **cal** après quelques semaines, racines vers 8 semaines) et **éclat de souche** ou **souchet** (tronçon de 15 à 20 cm, de 500 g à 5 kg). Cycle végétatif de la pomme de terre : croissance, tubérisation, repos, germination.
- **Marcottage** : on enterre une tige aérienne **sans la détacher** de la plante ; elle forme des racines adventives, et on l''isole **ensuite**. C''est la seule différence avec le bouturage — mais elle est décisive : la plante mère nourrit la marcotte jusqu''à son enracinement.
- **Greffage** : le **greffon** (bourgeon ou jeune rameau prélevé sur un végétal sélectionné pour ses fruits ou ses fleurs) est fixé sur un **porte greffe** (même espèce ou espèce voisine) de façon que les **vaisseaux conducteurs se raccordent**. **Greffe en fente** (porte greffe ≥ 3 cm de diamètre, rabattu 10 à 20 cm au-dessus du sol, greffon taillé en biseau, ligature + mastic) ; **greffe en écusson** (bourgeon + bande d''écorce d''un arbre d''au moins deux ans, incision en T, ligature). **Résultat** : racines et partie du tronc au porte greffe, rameaux-feuilles-fruits au greffon, **sans aucune racine** — la nouvelle plante porte les caractères du **greffon**. Un **végétal franc** provient des semis.
- **Culture in vitro** : multiplication des cellules d''un tissu végétal sur un milieu nutritif adapté, en **asepsie**, pour obtenir des plantes identiques au végétal de départ. Par **microbouturage** (microbouture portant un bourgeon → **vitro pousses** en trois mois → fragmentations répétées → enracinement → **acclimatation** en pot → plantation) : **400 000 oliviers en un an**, contre une vingtaine par bouturage traditionnel. Par **cellules méristématiques**, prélevées à l''extrémité d''un bourgeon terminal.

::: figure Un seul bourgeon, quelques cycles de fragmentation, et l''on obtient 200 000 à 400 000 rosiers rigoureusement identiques : c''est le clone
<svg viewBox="0 0 340 155">
<path d="M45 58 C 30 68, 32 88, 45 92 C 58 88, 60 68, 45 58 Z" fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.8"/>
<path d="M72 75 H104" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M102 69 L112 75 L102 81 Z" fill="#0f172a"/>
<path d="M132 78 V86 A 14 14 0 0 0 160 86 V78 Z" fill="#0f6e56" opacity="0.20"/>
<path d="M132 42 V86 A 14 14 0 0 0 160 86 V42" fill="none" stroke="#0f172a" stroke-width="2.2"/>
<path d="M146 82 V56" fill="none" stroke="#0f6e56" stroke-width="2.2"/>
<ellipse cx="154" cy="60" rx="8" ry="4" transform="rotate(20 154 60)" fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1"/>
<path d="M130 32 A 16 16 0 1 1 160 26" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M153 21 L164 24 L157 33 Z" fill="#0f6e56"/>
<path d="M176 75 H208" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M206 69 L216 75 L206 81 Z" fill="#0f172a"/>
<g fill="none" stroke="#0f6e56" stroke-width="2.2">
<path d="M250 98 V62"/><path d="M275 98 V58"/><path d="M300 98 V62"/>
</g>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1">
<ellipse cx="242" cy="70" rx="8" ry="4" transform="rotate(-25 242 70)"/>
<ellipse cx="258" cy="66" rx="8" ry="4" transform="rotate(25 258 66)"/>
<ellipse cx="267" cy="66" rx="8" ry="4" transform="rotate(-25 267 66)"/>
<ellipse cx="283" cy="62" rx="8" ry="4" transform="rotate(25 283 62)"/>
<ellipse cx="292" cy="70" rx="8" ry="4" transform="rotate(-25 292 70)"/>
<ellipse cx="308" cy="66" rx="8" ry="4" transform="rotate(25 308 66)"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="145" y="14" text-anchor="middle" fill="#0f6e56">×N</text>
<text x="45" y="125" text-anchor="middle" fill="#0f172a">1 bourgeon</text>
<text x="146" y="125" text-anchor="middle" fill="#0f172a">milieu nutritif</text>
<text x="275" y="125" text-anchor="middle" fill="#0f6e56">200 000 à 400 000</text>
</g>
</svg>
:::

- **Clone et totipotence** : toutes les plantes issues de la multiplication végétative d''une même plante mère forment un **clone**. Ce qui le rend possible est la **totipotence** — la capacité d''une seule cellule à donner n''importe quel organe de la plante. Avantages : conserver les caractères recherchés (rendement, qualité, résistance aux maladies), gagner du temps, obtenir des **clones sains** (assainissement viral par culture de méristèmes), **sauver des espèces en voie de disparition** (pommier ancien, rosier ancien) et **économiser espace et temps** (un local de 9 m² remplace 25 500 m² de serres ; deux ans in vitro valent quatre ans de culture traditionnelle chez l''œillet).', 3, '{"code":"225104P00","pages":"74-88","pageNumbers":[74,75,76,77,78,79,80,81,82,83,84,85,86,87,88]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', 'La diversité du monde microbien — quatre groupes sous l''objectif', 'Les quatre groupes de micro-organismes et leurs caractéristiques : les protozoaires (paramécie, amibe dysentérique, pseudopode, enkystement) ; les bactéries (bacille subtil, bactéries lactiques, diplocoques, streptocoques et staphylocoques, Eschérishia Coli, structure procaryote, bipartition toutes les 20 mn, minéralisation par les bactéries du sol) ; les champignons microscopiques (levure de bière et bourgeonnement, moisissure de pain, Pénicillium notatum et pénicilline, trichophyton et teigne, Phytophtora et mildiou) ; les virus (capsule et matériel génétique, absence d''organisation cellulaire, cellule hôte, parasite intracellulaire obligatoire, ordres de grandeur en nm et en angström) ; procaryote et eucaryote ; microbes utiles et microbes pathogènes avec le tableau microbe-maladie ; les techniques d''observation microscopique (montage entre lame et lamelle, frottis coloré, grossissement, taille réelle, microscope optique et microscope électronique)', '# ⚔️ La diversité du monde microbien — quatre groupes sous l''objectif

> 💡 «Ils sont dans l''eau, dans l''air, dans le sol, sur ta peau et dans ton intestin. Certains font ton yaourt, d''autres te tuent. Apprends d''abord à les distinguer — le reste en découle.»

Nouvelle partie, héros : **microbes et santé**. Le monde microbien est constitué d''organismes qu''on ne peut observer qu''au microscope — des **micro-organismes**. Il se caractérise par une **grande diversité** : ils diffèrent par leur taille, leur forme et leur mode d''action sur l''organisme. Tu sais déjà qu''ils sont microscopiques, que certains sont pathogènes et d''autres utiles. Ce chapitre pose la carte du territoire : **quatre groupes**, et ce qui distingue chacun.

## 🐛 Les protozoaires

Un **protozoaire** est un **animal unicellulaire**. Comme toute cellule animale, il possède un **noyau entouré d''une membrane**.

- **La paramécie.** Mets de l''eau et du foin dans un cristallisoir, place-le à l''abri du soleil à 25 à 30 °C : une semaine plus tard, une goutte du liquide observée au faible grossissement (G = × 200) grouille de paramécies. La paramécie est un animal unicellulaire des **eaux stagnantes** ; c''est un micro-organisme **inoffensif**. Elle porte des **cils vibratiles**, une **bouche**, une **vacuole digestive**, une **vacuole pulsatile**, un **noyau** et un **cytoplasme**.
- **L''amibe dysentérique.** Son cytoplasme forme des prolongements, les **pseudopodes**, qui assurent le **déplacement** et la **nutrition**. Lorsque les conditions sont défavorables, elle **s''enkyste**. Ses **kystes** peuvent être ingérés par l''homme avec l''eau ou les aliments **souillés** ; ils se transforment dans le tube digestif en amibes, qui se multiplient dans le gros intestin et causent la **dysentérie amibienne** (diarrhées, vomissements).

> 🗡️ Deux protozoaires, deux destins : la paramécie est inoffensive, l''amibe dysentérique est **pathogène** — c''est-à-dire qu''elle cause une maladie. Appartenir à un groupe ne dit donc rien de la dangerosité.

## 🧫 Les bactéries

Une **bactérie** est un être vivant **unicellulaire** microscopique, qui se multiplie par **bipartition**, et dont le **matériel génétique n''est pas délimité par une membrane** : c''est un organisme **procaryote**.

::: figure Le matériel génétique baigne directement dans le cytoplasme : aucune membrane ne l''entoure — c''est exactement ce qui fait de la bactérie une cellule procaryote
<svg viewBox="0 0 340 200">
<path d="M80 70 H260 A 35 35 0 0 1 260 140 H80 A 35 35 0 0 1 80 70 Z" fill="#0f6e56" opacity="0.10"/>
<path d="M80 70 H260 A 35 35 0 0 1 260 140 H80 A 35 35 0 0 1 80 70 Z" fill="none" stroke="#0f172a" stroke-width="3"/>
<path d="M86 76 H254 A 29 29 0 0 1 254 134 H86 A 29 29 0 0 1 86 76 Z" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M140 118 C 120 108, 135 88, 160 92 C 185 96, 200 84, 215 96 C 228 106, 210 122, 185 116 C 165 111, 155 126, 140 118 Z" fill="#7c3aed" opacity="0.45" stroke="#0f172a" stroke-width="1.8"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M82 92 L58 70"/><path d="M160 76 L172 40"/><path d="M250 104 L272 102"/><path d="M170 116 L170 166"/>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="48" y="62" text-anchor="middle" fill="#0f172a">paroi</text>
<text x="176" y="32" text-anchor="middle" fill="#0f6e56">membrane cytoplasmique</text>
<text x="300" y="106" text-anchor="middle" fill="#0f172a">cytoplasme</text>
<text x="170" y="180" text-anchor="middle" fill="#0f172a">matériel génétique</text>
</g>
</svg>
:::

**Les formes.** Le **bacille** est une bactérie en forme de **bâtonnet** ; les **coques** sont des bactéries en forme de **granules**, isolées ou associées ; d''autres bactéries sont **spiralées**.

_Exemple détaillé_ : fais bouillir de l''eau et du foin, filtre, attends 48 heures — un **voile** se forme à la surface du filtrat. Observé au microscope (× 900), il révèle le **bacille subtil**, une bactérie en bâtonnet. Autre exemple : dépose une goutte du liquide qui surnage un yaourt sur une lame, étale, sèche à l''air libre, fixe à l''**alcool**, colore au **bleu de méthylène** pendant 10 minutes, rince et sèche : ce **frottis** observé à × 1000 montre les **bactéries lactiques**, de deux types — les **lactobacilles** en bâtonnets et les **streptocoques** en grains arrondis groupés en chaînettes. Ce sont elles qui transforment le lait en yaourt.

Les coques, elles, se classent sur un critère qui n''est pas leur forme individuelle :

::: figure Le critère de classement des coques n''est pas leur forme — elles sont toutes rondes — mais leur groupement : par deux, en chaîne ou en grappe
<svg viewBox="0 0 340 180">
<g fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.8">
<circle cx="48" cy="80" r="12"/><circle cx="72" cy="80" r="12"/>
<circle cx="130" cy="80" r="11"/><circle cx="150" cy="78" r="11"/><circle cx="170" cy="80" r="11"/><circle cx="190" cy="78" r="11"/><circle cx="210" cy="80" r="11"/>
<circle cx="265" cy="68" r="10"/><circle cx="285" cy="63" r="10"/><circle cx="303" cy="72" r="10"/><circle cx="272" cy="86" r="10"/><circle cx="292" cy="86" r="10"/><circle cx="308" cy="90" r="10"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="60" y="130" text-anchor="middle" fill="#0f172a">diplocoque</text>
<text x="170" y="130" text-anchor="middle" fill="#0f172a">streptocoque</text>
<text x="285" y="130" text-anchor="middle" fill="#0f172a">staphylocoque</text>
<text x="60" y="152" text-anchor="middle" fill="#0f6e56">2 coques</text>
<text x="170" y="152" text-anchor="middle" fill="#0f6e56">1 chaîne</text>
<text x="285" y="152" text-anchor="middle" fill="#0f6e56">une grappe</text>
</g>
</svg>
:::

| Groupement                     | Ce qu''ils provoquent                                                                                                                           |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Diplocoque** (2 coques)      | **méningocoques** → méningite ; **pneumocoques** → pneumonie                                                                                   |
| **Streptocoque** (une chaîne)  | abcès ; broncho-pneumonie ; angine, dont la complication en l''absence de traitement est le rhumatisme articulaire aigu et l''atteinte cardiaque |
| **Staphylocoque** (une grappe) | abondants partout — peau, nez, gorge, intestin ; infectent l''organisme à la faveur d''une plaie → furoncle ou abcès                             |

**La multiplication.** Placée dans des conditions favorables, **Eschérishia Coli** — un bacille qui vit normalement dans l''intestin de l''homme et fait partie de la **flore intestinale** — s''allonge et se divise en deux : c''est la **bipartition**. **Deux bactéries se forment à partir d''une bactérie initiale toutes les 20 minutes.** Les bactéries ont donc une grande capacité de multiplication dès que le milieu est favorable.

**Et les utiles ?** Les **bactéries du sol** décomposent la matière organique des cadavres et des déchets animaux et végétaux, et les transforment en **sels minéraux** et en dioxyde de carbone : c''est la **minéralisation**, qui restitue au sol les sels minéraux puisés par les plantes. Tu reconnais la fertilisation organique du chapitre 1 — voici les ouvriers.

## 🍄 Les champignons microscopiques

Les **champignons** sont des organismes **eucaryotes** apparentés aux végétaux, mais s''en distinguant par leur **mode de nutrition** : ce sont des êtres **hétérotrophes**, qui se nourrissent d''eau, de sels minéraux et de **substances carbonées** — le bilan les décrit comme des végétaux microscopiques **non chlorophylliens**. Une **moisissure** est un champignon microscopique. On les classe en deux catégories.

| Catégorie                     | Exemples et signes                                                                                                                                  |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Unicellulaires**            | la **levure de bière** : cellules sphériques ou ovoïdes de **6 à 10 μm**, qui se multiplient par **bourgeonnement** ; elle sert à fabriquer le pain |
| **Filamenteux** (moisissures) | la **moisissure de pain** (**mycélium** + **sporanges**, ces boîtes à spores) ; le **Pénicille** ; le **trichophyton** ; le **Phytophtora**         |

_Exemple détaillé_ : dilue 1 gramme de levure du commerce dans 10 ml d''une solution de saccharose à 10 % à 37 °C, laisse reposer quelques heures, observe à × 1500 : tu vois des cellules **en bourgeonnement**. Autre exemple : place un morceau de pain humide dans un cristallisoir couvert, à 25 à 30 °C ; au bout de **deux jours**, le pain se recouvre d''un **duvet blanc** — la moisissure, observable à × 400.

Trois champignons à connaître par leur effet :

- **Pénicillium notatum** — une moisissure **verte** à partir de laquelle est fabriquée la **pénicilline**, un **antibiotique**. Utile.
- **Le trichophyton** — un champignon filamenteux qui infecte la **peau** et les **cheveux** ; il est l''agent de la **teigne**, caractérisée par une chute des cheveux. **Parasite.**
- **Le Phytophtora** — un champignon filamenteux, agent du **mildiou**, maladie qui attaque la tomate, la pomme de terre et la vigne. **Parasite.**

## ☣️ Les virus

Un **virus** est une **particule organisée incapable de se développer en dehors d''une cellule vivante**. C''est une particule **très petite**, observable seulement au **microscope électronique**, dont la taille va de quelques **angströms** (1 A° = 10⁻¹⁰ m) à quelques **micromètres** (1 μm = 10⁻⁶ m).

::: figure Une capsule, du matériel génétique, et rien d''autre : ni cytoplasme, ni membrane cytoplasmique, ni noyau — le virus n''a pas l''organisation d''une cellule
<svg viewBox="0 0 340 200">
<circle cx="150" cy="100" r="55" fill="#0f6e56" opacity="0.10"/>
<circle cx="150" cy="100" r="55" fill="none" stroke="#0f172a" stroke-width="3"/>
<path d="M124 118 C 110 100, 128 80, 150 88 C 170 95, 182 112, 162 120 C 146 126, 136 130, 124 118 Z" fill="#7c3aed" opacity="0.45" stroke="#0f172a" stroke-width="1.8"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M189 68 L240 54"/><path d="M148 116 L162 172"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="273" y="50" text-anchor="middle" fill="#0f172a">capsule</text>
<text x="176" y="186" text-anchor="middle" fill="#0f172a">matériel génétique</text>
</g>
</svg>
:::

Le virus est **inerte** dans le milieu extérieur : **il ne respire pas et ne se reproduit pas**. Il ne peut se multiplier qu''à l''intérieur d''une cellule vivante, appelée **cellule hôte** — animale, végétale ou bactérienne. D''où son nom : **parasite intracellulaire obligatoire**.

| Virus                   | Taille | Ce qu''il fait                                                                                                                      |
| ----------------------- | -----: | ---------------------------------------------------------------------------------------------------------------------------------- |
| **V.I.H.**              | 100 nm | virus du S.I.D.A. ; se transmet par le sperme, les sécrétions vaginales et le sang ; s''attaque aux cellules du système immunitaire |
| **Virus de la grippe**  | 150 nm | responsable des inflammations respiratoires                                                                                        |
| **Bactériophages**      | 200 nm | des virus qui infectent les **bactéries**                                                                                          |
| **Virus de la variole** | 240 nm | provoque une infection de la peau avec formation de pustules                                                                       |

> ⚠️ Piège classique : « le virus est le plus petit des microbes, donc c''est une toute petite cellule ». Non — ce n''est **pas** une cellule du tout. Compare les deux figures : la bactérie a une paroi, une membrane, un cytoplasme et son matériel génétique ; le virus n''a **qu''**une capsule et du matériel génétique. Un virus est un **assemblage de molécules**, pas un être unicellulaire.

## ⚖️ Utiles ou pathogènes ?

Est **pathogène** un microbe qui **cause une maladie**. Mais une autre catégorie de microbes nous sert.

**Les utiles.** La capacité de **fermentation** de différentes espèces bactériennes est utilisée pour produire fromages, yaourts et vinaigres ; d''autres bactéries servent à produire fibres textiles, enzymes, polysaccharides, détergents, médicaments, antibiotiques, vaccins et hormones. Côté champignons : le **Pénicille** est cultivé pour produire la **pénicilline** ; la **levure de bière** sert à fabriquer le pain, le vin, la bière et le cidre ; des **moisissures** entrent dans la fabrication de quelques types de fromage.

**Les pathogènes.** Chaque groupe a les siens :

| Groupe           | Microbe                  | Maladie                                       |
| ---------------- | ------------------------ | --------------------------------------------- |
| **Protozoaires** | hématozoaire             | paludisme                                     |
|                  | amibe dysentérique       | amibiase                                      |
|                  | trypanosome              | maladie du sommeil                            |
| **Bactéries**    | bacille de Koch          | tuberculose                                   |
|                  | vibrion du choléra       | choléra                                       |
|                  | bacille diphtérique      | diphtérie                                     |
|                  | bacille tétanique        | tétanos                                       |
|                  | streptocoque             | infection d''une plaie, rhumatisme articulaire |
|                  | staphylocoque            | infection d''une plaie                         |
|                  | tréponème                | syphilis                                      |
| **Moisissures**  | trichophyton             | teigne                                        |
|                  | candida albicans         | candidose                                     |
| **Virus**        | virus de la rougeole     | rougeole                                      |
|                  | virus de la rage         | rage                                          |
|                  | virus de la variole      | variole                                       |
|                  | virus de la poliomyélite | poliomyélite                                  |
|                  | virus de la grippe       | grippe                                        |
|                  | V.I.H.                   | S.I.D.A.                                      |

## 🔍 Voir l''invisible : les techniques

Rien de ce qui précède n''existerait sans l''instrument. Retiens les gestes et les deux calculs.

- **Le montage entre lame et lamelle** : une goutte du liquide, une lamelle, puis l''observation au faible, au moyen, puis au fort grossissement.
- **Le frottis coloré** : étaler, sécher à l''air libre, **fixer** à l''alcool, **colorer** (bleu de méthylène), rincer, sécher.
- **Le grossissement du microscope** est le produit de celui de l''oculaire par celui de l''objectif :

$$ grossissement = oculaire × objectif $$

_Exemple détaillé_ : un oculaire × 15 et un objectif × 40 donnent un grossissement de 15 × 40 = **600** ✓.

- **La taille réelle** se déduit de la taille mesurée sur l''image et du grossissement :

$$ taille réelle = taille mesurée ÷ grossissement $$

- **Le microscope électronique** prend le relais quand l''objet est trop petit pour le microscope optique : c''est lui qui révèle la structure de E. Coli (au MEB, × 27 000) et celle des virus. Repère utile : **1 μm = 1 millième de mm**.

> 🏆 Quatrième quête franchie, héros : tu sais nommer les quatre groupes, reconnaître un procaryote, distinguer un virus d''une cellule et calculer un grossissement. Tu tiens la carte. Reste à savoir ce que ces microbes font vraiment à un organisme — c''est le prochain chapitre.', '# 📜 Résumé : La diversité du monde microbien

- **Quatre groupes.** Les **micro-organismes** ne s''observent qu''au microscope et diffèrent par leur taille, leur forme et leur mode d''action : on les classe en **protozoaires**, **bactéries**, **champignons microscopiques** et **virus**.
- **Protozoaires** = **animaux unicellulaires**, à noyau entouré d''une membrane. La **paramécie** (eaux stagnantes, cils vibratiles, vacuole pulsatile, vacuole digestive, bouche) est **inoffensive** ; l''**amibe dysentérique** se déplace et se nourrit par ses **pseudopodes**, **s''enkyste** en conditions défavorables, et ses kystes ingérés avec de l''eau ou des aliments souillés causent la **dysentérie amibienne**.
- **Bactéries** = êtres unicellulaires **procaryotes** : le **matériel génétique baigne dans le cytoplasme, sans membrane pour l''entourer** (paroi + membrane cytoplasmique + cytoplasme + matériel génétique). Formes : **bacille** (bâtonnet), **coques** (granules), **spiralées**. Les coques se classent sur leur **groupement** : **diplocoque** (2 coques : méningocoque, pneumocoque), **streptocoque** (une chaîne), **staphylocoque** (une grappe). Multiplication par **bipartition** — 2 bactéries à partir d''une seule **toutes les 20 mn**. Les **bactéries du sol** assurent la **minéralisation**.

::: figure Chaque bactérie se divise en deux toutes les 20 minutes : au bout d''une heure il y a eu 3 divisions, et une seule bactérie en est devenue 2³ = 8
<svg viewBox="0 0 340 190">
<g fill="none" stroke="#0f172a" stroke-width="2">
<path d="M62 80 H106"/><path d="M144 80 H190"/><path d="M226 80 H275"/>
</g>
<g fill="#0f172a">
<path d="M104 74 L114 80 L104 86 Z"/><path d="M188 74 L198 80 L188 86 Z"/><path d="M273 74 L283 80 L273 86 Z"/>
</g>
<g fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.6">
<circle cx="50" cy="80" r="7"/>
<circle cx="130" cy="66" r="7"/><circle cx="130" cy="94" r="7"/>
<circle cx="210" cy="44" r="7"/><circle cx="210" cy="68" r="7"/><circle cx="210" cy="92" r="7"/><circle cx="210" cy="116" r="7"/>
<circle cx="300" cy="24" r="6"/><circle cx="300" cy="40" r="6"/><circle cx="300" cy="56" r="6"/><circle cx="300" cy="72" r="6"/><circle cx="300" cy="88" r="6"/><circle cx="300" cy="104" r="6"/><circle cx="300" cy="120" r="6"/><circle cx="300" cy="136" r="6"/>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="50" y="162" text-anchor="middle" fill="#0f6e56">1</text>
<text x="130" y="162" text-anchor="middle" fill="#0f6e56">2</text>
<text x="210" y="162" text-anchor="middle" fill="#0f6e56">4</text>
<text x="300" y="162" text-anchor="middle" fill="#0f6e56">8</text>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="50" y="180" text-anchor="middle" fill="#0f172a">0</text>
<text x="130" y="180" text-anchor="middle" fill="#0f172a">20</text>
<text x="210" y="180" text-anchor="middle" fill="#0f172a">40</text>
<text x="300" y="180" text-anchor="middle" fill="#0f172a">60 mn</text>
</g>
</svg>
:::

- **Champignons microscopiques** = organismes **eucaryotes** apparentés aux végétaux mais **hétérotrophes** (végétaux microscopiques **non chlorophylliens**). **Unicellulaires** : la **levure de bière** (6 à 10 μm, multiplication par **bourgeonnement**). **Filamenteux** (**moisissures**) : moisissure de pain (**mycélium**, **sporange** = boîte à spores), **Pénicillium notatum** → **pénicilline**, **trichophyton** → **teigne**, **Phytophtora** → **mildiou**.
- **Virus** = particule organisée **incapable de se développer en dehors d''une cellule vivante** : une **capsule** + du **matériel génétique**, sans organisation cellulaire. Inerte dehors (il ne respire pas, ne se reproduit pas), il ne se multiplie que dans une **cellule hôte** — animale, végétale ou bactérienne : c''est un **parasite intracellulaire obligatoire**. Tailles : V.I.H. 100 nm, grippe 150 nm, bactériophages 200 nm, variole 240 nm. Repères : 1 A° = 10⁻¹⁰ m ; 1 μm = 10⁻⁶ m.
- **Utiles ou pathogènes** — la ligne de partage traverse les quatre groupes. **Utiles** : fermentation bactérienne (fromages, yaourts, vinaigres), production d''enzymes, de médicaments, d''antibiotiques, de vaccins, d''hormones ; Pénicille → pénicilline ; levure → pain, vin, bière, cidre. **Pathogènes** : hématozoaire → paludisme, amibe dysentérique → amibiase, trypanosome → maladie du sommeil ; bacille de Koch → tuberculose, vibrion du choléra → choléra, bacille tétanique → tétanos, tréponème → syphilis ; trichophyton → teigne, candida albicans → candidose ; virus de la rougeole, de la rage, de la variole, de la poliomyélite, de la grippe, V.I.H. → S.I.D.A.
- **Voir l''invisible** : montage entre lame et lamelle ; **frottis** (étaler, sécher, **fixer** à l''alcool, **colorer** au bleu de méthylène) ; **grossissement = oculaire × objectif** (× 15 et × 40 → × 600) ; **taille réelle = taille mesurée ÷ grossissement** (1 μm = 1 millième de mm) ; le **microscope électronique** prend le relais pour E. Coli (MEB, × 27 000) et pour les virus.', 4, '{"code":"225104P00","pages":"92-106","pageNumbers":[92,93,94,95,96,97,98,99,100,101,102,103,104,105,106]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', 'Test de compréhension ⭐ : La nutrition minérale', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Dans une jeune racine, quelle zone assure l''absorption de l''eau et des sels minéraux ?', '[{"id":"a","text":"La coiffe"},{"id":"b","text":"La zone subéreuse"},{"id":"c","text":"La zone pilifère"},{"id":"d","text":"Le cylindre central"}]'::jsonb, 'c', 'L''absorption se fait au niveau des poils absorbants, et ceux-ci sont tous rassemblés sur la zone pilifère ✓. Ni la coiffe, à l''extrémité de la racine, ni la zone subéreuse, plus haut, ne portent de poils absorbants. Quant au cylindre central, l''eau ne l''atteint qu''après avoir traversé horizontalement la racine : c''est un point d''arrivée, pas la porte d''entrée.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'L''osmose est le passage d''eau à travers une membrane semi-perméable. Dans quel sens se fait-il ?', '[{"id":"a","text":"Du milieu le plus concentré vers le milieu le moins concentré"},{"id":"b","text":"Du milieu le moins concentré vers le milieu le plus concentré"},{"id":"c","text":"De la cellule vers le milieu extérieur, quelles que soient les concentrations"},{"id":"d","text":"Du milieu le plus chaud vers le milieu le plus froid"}]'::jsonb, 'b', 'L''osmose fait passer l''eau du milieu le moins concentré, dit hypotonique, vers le milieu le plus concentré, dit hypertonique, jusqu''à l''égalité des concentrations ou isotonie ✓. Inverser ce sens est le piège le plus courant : il rendrait incompréhensible l''olive qui se ratatine dans une saumure. Et le sens ne dépend ni de la position par rapport à la cellule, ni de la température, mais seulement de la différence de concentration.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89c9d68e-0825-5c8a-b227-53823dcebcce', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Un fragment d''épiderme d''oignon violet est plongé dans une solution de chlorure de sodium à 20 g/l. Dans quel état seront ses cellules ?', '[{"id":"a","text":"Turgescentes"},{"id":"b","text":"Inchangées, comme dans une solution à 9 g/l"},{"id":"c","text":"Éclatées, leur paroi ayant cédé"},{"id":"d","text":"Plasmolysées"}]'::jsonb, 'd', 'À 20 g/l, la solution est hypertonique par rapport au contenu de la cellule : l''eau sort par osmose, la vacuole se rétracte et le cytoplasme se décolle de la paroi — les cellules sont plasmolysées ✓. La turgescence est l''état inverse, observé à 2 g/l lorsque l''eau entre ; c''est à 9 g/l que les cellules restent normales, pas à 20 g/l. Et la paroi ne cède pas : c''est justement elle qui reste en place pendant que la membrane s''en détache.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Qu''est-ce que la sève brute, et où circule-t-elle ?', '[{"id":"a","text":"Un mélange d''eau et de sels minéraux, qui circule dans les vaisseaux du bois"},{"id":"b","text":"Un mélange d''eau et de sels minéraux, qui circule dans les poils absorbants"},{"id":"c","text":"Un mélange d''eau et de sucres, qui circule dans les vaisseaux du bois"},{"id":"d","text":"Un mélange d''eau et de sucres, qui circule dans les poils absorbants"}]'::jsonb, 'a', 'La sève brute est le mélange d''eau et de sels minéraux absorbé par les racines ; elle monte vers les feuilles dans les vaisseaux du bois, ces files de cellules mortes à paroi lignifiée dont l''ensemble forme le xylème ✓. Elle ne contient pas de sucres : la plante ne prélève dans le sol que de l''eau et des sels minéraux. Et le poil absorbant est la porte d''entrée de l''eau, pas la voie de sa montée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dc95078f-4b07-5369-9d4e-20e7da51cfa6', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Un agriculteur apporte systématiquement beaucoup plus d''eau que nécessaire à sa culture. Quelle conséquence subit la plante elle-même ?', '[{"id":"a","text":"Ses racines s''allongent plus vite pour aller chercher l''eau"},{"id":"b","text":"Ses racines s''asphyxient, ce qui réduit la quantité d''eau absorbée"},{"id":"c","text":"Sa transpiration s''arrête complètement"},{"id":"d","text":"Ses stomates se ferment définitivement"}]'::jsonb, 'b', 'Trop d''eau conduit à une asphyxie des racines, qui réduit la quantité d''eau absorbée par la plante ✓ — c''est pourquoi une irrigation rationnelle ne dépasse pas les quantités optimales, l''excès étant en outre coûteux et contribuant à l''assèchement des nappes. L''excès d''eau n''allonge pas les racines : il les asphyxie. Quant à la transpiration et à l''ouverture des ostioles, elles dépendent de la surface foliaire, de la densité stomatique, de la lumière, de la température et de l''état de l''air — pas d''un excès d''eau dans le sol.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', '⭐ Exercice : Sur les traces de l''eau dans la plante', 1, 50, 10, 'practice', 'admin', 1)
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
  ('8370514e-445c-591a-92da-e4099e253999', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'À quoi sert un potomètre ?', '[{"id":"a","text":"À mesurer la quantité d''eau absorbée par une plante"},{"id":"b","text":"À mesurer la masse sèche d''un végétal"},{"id":"c","text":"À mettre en évidence les échanges d''eau à travers une membrane semi-perméable"},{"id":"d","text":"À colorer les vaisseaux conducteurs d''une tige"}]'::jsonb, 'a', 'Le potomètre (potos = boisson, mètre = mesure) mesure la quantité d''eau absorbée par une plante : on suit le déplacement de l''index dans son tube capillaire ✓. La masse sèche, elle, s''obtient par pesée après déshydratation. L''appareil qui met en évidence les échanges d''eau à travers une membrane semi-perméable est l''osmomètre, pas le potomètre : ne les confonds pas. Et la coloration des vaisseaux se fait à l''éosine ou au bleu de méthylène, sans appareil de mesure.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8e59a821-f39b-5ba3-ab73-5b234b3b6253', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Les poils absorbants d''un plant de seigle offrent environ 400 m² de surface de contact avec la solution du sol. Quel est l''intérêt d''une telle surface ?', '[{"id":"a","text":"Elle rend la racine plus résistante à l''arrachement"},{"id":"b","text":"Elle permet à la racine de réaliser la photosynthèse"},{"id":"c","text":"Elle permet d''absorber une grande quantité d''eau et de sels minéraux"},{"id":"d","text":"Elle protège la coiffe contre le dessèchement"}]'::jsonb, 'c', 'Chaque poil absorbant est minuscule (12 à 15 μm de diamètre), mais on en compte jusqu''à 2000 par cm² chez les graminées, soit 14 milliards chez un plant de seigle : ensemble, ils représentent une surface d''échange considérable entre la plante et le sol, et plus cette surface est grande, plus la plante peut absorber d''eau et de sels minéraux ✓. La résistance mécanique et la protection de la coiffe ne sont pas la fonction du poil absorbant. Quant à la photosynthèse, elle exige de la lumière : elle n''a pas lieu dans le sol.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de8815b1-b69c-553b-b863-e04b9254f688', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'De quoi un stomate est-il formé ?', '[{"id":"a","text":"D''une cellule unique percée d''un pore central"},{"id":"b","text":"D''une file de cellules mortes à paroi lignifiée"},{"id":"c","text":"De deux poils absorbants accolés"},{"id":"d","text":"De deux cellules stomatiques bordant un ostiole"}]'::jsonb, 'd', 'Un stomate est une structure épidermique formée de deux cellules stomatiques qui bordent un orifice, l''ostiole, par où sort la vapeur d''eau ✓. Ce n''est ni une cellule unique, ni deux poils absorbants accolés — le poil absorbant est une cellule de la racine, pas de la feuille. Et la file de cellules mortes à paroi lignifiée décrit le vaisseau du bois : il conduit la sève brute, il ne transpire pas.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('027d4c81-285a-5dc1-9a33-4fa045cf121b', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Par quelle(s) face(s) d''une feuille se fait la transpiration ?', '[{"id":"a","text":"Par la face supérieure uniquement"},{"id":"b","text":"Par la face inférieure uniquement"},{"id":"c","text":"Par les deux faces, davantage par l''inférieure"},{"id":"d","text":"Par les deux faces, davantage par la supérieure"}]'::jsonb, 'c', 'Une lamelle de verre fixée sur chaque face se couvre de buée au bout de 30 minutes : les deux faces transpirent. Mais la transpiration foliaire est plus importante au niveau de la face inférieure ✓, où les stomates sont plus nombreux. Ne retenir qu''une seule des deux faces serait donc déjà faux ; et prétendre que la face supérieure transpire davantage inverse le rapport entre elles.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3616a836-0f14-5737-b34c-8954e0492386', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Que reste-t-il d''un vaisseau du bois une fois qu''il est formé ?', '[{"id":"a","text":"Une file de cellules mortes réduites à leur paroi lignifiée"},{"id":"b","text":"Une file de cellules mortes réduites à leur paroi cellulosique"},{"id":"c","text":"Une file de cellules vivantes à paroi lignifiée"},{"id":"d","text":"Une file de cellules vivantes à paroi cellulosique"}]'::jsonb, 'a', 'Un vaisseau du bois est une file de cellules mortes réduites à leur paroi, riche en lignine ✓ ; l''ensemble des vaisseaux du bois forme le xylème. Deux erreurs sont possibles, et chacune se glisse dans les autres propositions. D''abord croire les cellules vivantes : le vaisseau est un tube inerte. Ensuite croire la paroi cellulosique : c''est la lignine qui la rend dure — le carmino-vert la colore d''ailleurs en vert, alors qu''il colore la cellulose en rose foncé.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24b390fb-9b31-5195-920e-32e25236b520', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Qu''est-ce qu''un milieu synthétique carencé ?', '[{"id":"a","text":"Un milieu qui contient tous les éléments minéraux nécessaires"},{"id":"b","text":"Un milieu auquel il manque un élément minéral indispensable"},{"id":"c","text":"Un milieu dont un élément minéral atteint la concentration toxique"},{"id":"d","text":"Un milieu qui ne contient que de l''eau distillée, sans aucun sel"}]'::jsonb, 'b', 'Un milieu synthétique incomplet, ou carencé, est un milieu nutritif artificiel auquel il manque un ou plusieurs éléments indispensables à la nutrition de la plante ✓ : on l''obtient en retirant au milieu complet le seul élément dont on veut tester le rôle. Un milieu qui contient tous les éléments nécessaires est au contraire le milieu synthétique complet, comme le liquide de Knop. Une concentration toxique est un excès, pas un manque. Et l''eau distillée seule n''est pas un milieu de culture : c''est sur elle que Knop fait germer ses grains de maïs avant de les placer sur la solution nutritive.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Absorption, transpiration et sels minéraux', 2, 75, 15, 'practice', 'admin', 3)
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
  ('7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Dans l''expérience de Rosène, cinq jeunes plants ont leurs racines plongées dans cinq tubes A, B, C, D et E. Le tube A est le seul où toute la racine baigne dans l''eau, sans huile. Quel est son rôle ?', '[{"id":"a","text":"Il sert de témoin, aucune zone n''y étant isolée par l''huile"},{"id":"b","text":"Il sert à mesurer la vitesse d''absorption en cm³/heure"},{"id":"c","text":"Il sert à empêcher l''évaporation de l''eau des autres tubes"},{"id":"d","text":"Il sert à comparer deux espèces végétales différentes"}]'::jsonb, 'a', 'Le tube A est le témoin : il montre ce que donne le montage quand aucune zone de la racine n''est isolée de l''eau par l''huile. C''est lui qui permet d''attribuer les différences observées dans les tubes B, C, D et E à la seule zone laissée au contact de l''eau ✓. La vitesse d''absorption, elle, se mesure au potomètre, pas ici. C''est l''huile — justement absente du tube A — qui isole une zone de l''eau, et non le tube témoin qui protégerait les autres de l''évaporation. Enfin, le protocole ne compare pas des espèces : d''un tube à l''autre, seule la zone en contact avec l''eau change.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f55785f1-1488-598f-836d-6d962733d85c', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Un rameau de vigne coupé au printemps laisse s''écouler de la sève au niveau de la section de la tige : on dit que la vigne pleure. Que prouve ce phénomène ?', '[{"id":"a","text":"Que la transpiration foliaire aspire la sève vers le haut"},{"id":"b","text":"Que la sève est poussée par une pression venue des racines"},{"id":"c","text":"Que la sève brute descend des feuilles vers les racines"},{"id":"d","text":"Que le bilan hydrique de la plante est devenu négatif"}]'::jsonb, 'b', 'Un rameau coupé n''a plus de partie aérienne feuillée, donc plus d''aspiration foliaire — et pourtant la sève monte et s''écoule. C''est la preuve qu''elle circule sous pression dans les vaisseaux du bois, poussée depuis les racines : c''est la poussée radiculaire ✓, que l''expérience de Hales mesure au manomètre à mercure. L''aspiration foliaire est bien l''autre moteur de la montée de sève, mais elle ne peut pas agir ici, faute de feuilles : c''est tout l''intérêt de l''observation. La sève brute monte des racines vers les feuilles, elle ne descend pas. Et un bilan hydrique négatif signifie que la plante perd plus d''eau qu''elle n''en absorbe : elle se fane, elle ne rejette pas de sève.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91a21c54-f5eb-5636-905d-ca036d1fbe7f', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'On cultive six lots de maïs sur six milieux synthétiques pendant trois semaines. Sur l''un d''eux, les feuilles présentent une nécrose et la masse sèche tombe à 44 g pour 100 pieds, contre 162 g sur le milieu de Knop. De quel milieu s''agit-il ?', '[{"id":"a","text":"Le milieu sans azote"},{"id":"b","text":"Le milieu sans phosphore"},{"id":"c","text":"Le milieu sans potassium"},{"id":"d","text":"Le milieu sans fer"}]'::jsonb, 'c', 'Chaque carence laisse sa signature sur les feuilles et sur la masse sèche. La nécrose, accompagnée de la plus forte chute de masse sèche (44 g contre 162 g pour le témoin), est celle du milieu sans potassium ✓. La carence en azote donne une chlorose et 68 g ; celle en phosphore un jaunissement à l''extrémité des feuilles et 116 g ; celle en fer une chlorose et 130 g. Seule la lecture conjointe du symptôme et du chiffre permet de trancher, puisque l''azote et le fer donnent le même symptôme.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e6ec3b7-1a4a-5324-b693-4befe7421343', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Garreau mesure, chez le tilleul, le nombre de stomates et l''eau transpirée par chaque face d''une feuille. La face inférieure porte 300 stomates par mm² et transpire 490 mg d''eau en 24 heures ; la face supérieure n''en porte aucun et transpire pourtant 200 mg en 24 heures. Comment expliquer cette transpiration sans stomate ?', '[{"id":"a","text":"Les stomates de la face inférieure transpirent aussi pour la face supérieure"},{"id":"b","text":"Le tilleul possède des stomates invisibles au microscope"},{"id":"c","text":"La mesure est fausse : sans stomate, aucune transpiration n''est possible"},{"id":"d","text":"La cuticule, mince chez le tilleul, laisse passer la vapeur d''eau"}]'::jsonb, 'd', 'Puisque la face supérieure du tilleul transpire 200 mg par 24 heures sans porter un seul stomate, la vapeur emprunte forcément une autre voie. La comparaison des coupes des deux feuilles la désigne : chez le Dahlia, la face supérieure a des stomates et une cuticule épaisse ; chez le tilleul, elle n''a pas de stomate et sa cuticule est mince — c''est donc la cuticule qui est responsable de cette transpiration accessoire ✓. Les stomates d''une face ne transpirent pas pour l''autre : chacun débouche sur sa propre face. Postuler des stomates invisibles contredit l''observation microscopique, qui n''en montre aucun. Et le piège courant est de rejeter la mesure : c''est elle, au contraire, qui oblige à chercher une seconde voie de transpiration.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('96569c1c-2c6f-58ac-be1c-1e9c63f8544b', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Dans un potomètre dont le tube capillaire a un diamètre de 2 mm, l''index se déplace de 8 mm en 5 minutes. Le volume du cylindre d''eau vaut V = R × R × π × h, avec π = 3,14. Quelle est la vitesse d''absorption ?', '[{"id":"a","text":"0,005 cm³/heure"},{"id":"b","text":"0,025 cm³/heure"},{"id":"c","text":"0,3 cm³/heure"},{"id":"d","text":"1,2 cm³/heure"}]'::jsonb, 'c', 'Le tube capillaire est assimilé à un cylindre. Son diamètre vaut 2 mm, donc son rayon R = 1 mm = 0,1 cm ; le déplacement de l''index donne la hauteur h = 8 mm = 0,8 cm. Le volume absorbé vaut V = 0,1 × 0,1 × 3,14 × 0,8 = 0,025 cm³ en 5 minutes. La vitesse est donc 0,025 / 5 = 0,005 cm³/mn, soit 0,005 × 60 = 0,3 cm³/heure ✓. Le piège courant est de prendre le diamètre pour le rayon : le volume est alors multiplié par 4 et l''on trouve 1,2. Trouver 0,025 revient à confondre le volume absorbé en 5 minutes avec une vitesse ; trouver 0,005 revient à s''arrêter à la vitesse par minute, qu''il restait à multiplier par 60.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2af41e79-44d7-54cc-87a8-f7e8fb554818', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'On mesure la vitesse de croissance de plantes cultivées sur des solutions ne différant que par leur teneur en potassium : 21 à 100 mg/l, 139 à 500 mg/l, 143 à 600 mg/l, 140 à 700 mg/l, 50 à 900 mg/l et 10 à 1000 mg/l. Un agriculteur dont la solution est à 500 mg/l décide de doubler la dose. Que prévoient ces résultats ?', '[{"id":"a","text":"Une chute de la croissance : à 1000 mg/l, le potassium est toxique"},{"id":"b","text":"Un doublement de la croissance, puisque la dose est doublée"},{"id":"c","text":"Une croissance inchangée : la courbe forme un palier après 500 mg/l"},{"id":"d","text":"Une croissance maximale : 1000 mg/l est la concentration optimale"}]'::jsonb, 'a', 'La croissance ne suit pas la dose : elle traverse trois domaines. En dessous de 500 mg/l, le manque la limite — c''est la déficience. Entre 500 et 700 mg/l elle est maximale (143 à 600 mg/l) — c''est la concentration optimale. Au-delà de 700 mg/l elle s''effondre. En doublant 500 mg/l, l''agriculteur atteint 1000 mg/l, où la vitesse retombe à 10, soit moins que les 21 obtenus à 100 mg/l ✓ : la concentration est devenue toxique et empoisonne la plante. Le piège courant est de raisonner en proportion : à 500 mg/l on est déjà à 139, tout près du maximum de 143 — il n''y a plus rien à gagner. Le palier existe bien, mais il s''arrête à 700 mg/l. Et l''optimum se situe entre 500 et 700 mg/l, pas à 1000.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('194de524-a981-5046-97c2-b5fd75a83615', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', 'Test de compréhension ⭐ : La nutrition carbonée', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', '194de524-a981-5046-97c2-b5fd75a83615', 'Quel réactif révèle l''amidon d''un tubercule de pomme de terre, et quelle coloration obtient-on ?', '[{"id":"a","text":"L''eau iodée ; coloration bleue foncée"},{"id":"b","text":"La liqueur de Fehling ; précipité rouge brique"},{"id":"c","text":"Le sulfate de cuivre puis la soude ; coloration violette"},{"id":"d","text":"L''alcool à 90° ; coloration verte"}]'::jsonb, 'a', 'L''amidon se révèle par quelques gouttes d''eau iodée, qui donnent une coloration bleue foncée ✓. La liqueur de Fehling chauffée donne bien un précipité rouge brique, mais elle révèle le glucose. Le sulfate de cuivre suivi de la soude donne une coloration violette et révèle le gluten. Quant à l''alcool à 90°, ce n''est pas un révélateur : il sert à extraire la chlorophylle et à décolorer la feuille avant le test à l''eau iodée.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e395ec07-d9a5-58de-8a71-7edaeef8becd', '194de524-a981-5046-97c2-b5fd75a83615', 'Où se déroule la photosynthèse dans la cellule chlorophyllienne ?', '[{"id":"a","text":"Dans le cytoplasme"},{"id":"b","text":"Dans la paroi pectocellulosique"},{"id":"c","text":"Dans le chloroplaste"},{"id":"d","text":"Dans la vacuole"}]'::jsonb, 'c', 'Le chloroplaste est l''organite de la cellule végétale où se déroule la photosynthèse ✓ : c''est lui qui porte la chlorophylle. Le cytoplasme et la paroi pectocellulosique sont bien des constituants de la cellule chlorophyllienne, mais on les trouve dans toute cellule végétale — ce qui distingue la cellule chlorophyllienne des autres, ce sont précisément ses chloroplastes. La vacuole, elle, n''intervient pas dans la photosynthèse.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '194de524-a981-5046-97c2-b5fd75a83615', 'On place des chlorelles, sous fort éclairement, dans de l''eau additionnée de dioxyde de carbone. L''oxygène de cette eau est radioactif. Résultat : l''oxygène dégagé est radioactif, mais pas les glucides fabriqués. Que peut-on en conclure ?', '[{"id":"a","text":"L''oxygène dégagé provient du dioxyde de carbone"},{"id":"b","text":"L''oxygène des glucides fabriqués provient de l''eau"},{"id":"c","text":"L''oxygène dégagé provient de l''air ambiant"},{"id":"d","text":"L''oxygène dégagé provient de l''eau"}]'::jsonb, 'd', 'Le marquage suit l''atome : l''oxygène radioactif était dans l''eau et se retrouve dans l''oxygène dégagé — l''O₂ rejeté par la plante vient donc de l''eau ✓. Il ne vient pas du dioxyde de carbone : dans l''expérience symétrique, où c''est l''oxygène du CO₂ qui est radioactif, l''O₂ dégagé n''est pas radioactif. Il ne vient pas non plus de l''air ambiant : la plante en rejette ici, elle n''en prélève pas. Quant à l''oxygène des glucides, il ne vient pas de l''eau — les glucides ne sont justement pas radioactifs dans cette expérience, alors qu''ils le sont dans celle où le CO₂ porte l''oxygène marqué.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99012c23-8348-5018-bbd4-4c21a5b1a8a8', '194de524-a981-5046-97c2-b5fd75a83615', 'Une feuille panachée porte des zones vertes et des zones blanches. Exposée à la lumière puis traitée à l''eau iodée, quelle condition de la photosynthèse permet-elle de démontrer ?', '[{"id":"a","text":"Le rôle du dioxyde de carbone"},{"id":"b","text":"Le rôle de la chlorophylle"},{"id":"c","text":"Le rôle de la lumière"},{"id":"d","text":"Le rôle de la température"}]'::jsonb, 'b', 'La feuille panachée est éclairée en entier et baigne tout entière dans le même air : la lumière et le dioxyde de carbone sont donc identiques partout. La seule chose qui change d''une zone à l''autre est la présence de chlorophylle — c''est elle, et elle seule, que l''expérience teste ✓. Le rôle du CO₂ se démontre en faisant barboter l''air dans la potasse ; celui de la lumière, avec un cache opaque posé sur une partie de la feuille. La température, elle, n''est pas l''une des trois conditions établies par ces expériences.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e42de770-7ccd-57ae-9d50-7b8e1b9ad950', '194de524-a981-5046-97c2-b5fd75a83615', 'Un dispositif mesure le taux d''oxygène du milieu autour d''une plante éclairée. Pour un certain éclairement, ce taux reste constant. Que cela signifie-t-il ?', '[{"id":"a","text":"Photosynthèse et respiration se compensent exactement"},{"id":"b","text":"La plante a cessé toute activité biologique"},{"id":"c","text":"La plante ne respire plus : seule la photosynthèse fonctionne"},{"id":"d","text":"La photosynthèse a atteint son intensité maximale"}]'::jsonb, 'a', 'Un taux d''oxygène constant signifie que la quantité d''O₂ rejetée par la photosynthèse est exactement égale à celle absorbée par la respiration : IPB = IR, donc IPN = 0. C''est le point de compensation ✓. La plante n''a pas cessé toute activité : les deux phénomènes tournent, mais ils s''annulent — c''est très différent. Elle ne cesse jamais non plus de respirer : la respiration se déroule 24 heures sur 24, et c''est justement pour cela qu''on ne mesure jamais qu''une intensité photosynthétique nette. Enfin le maximum de la photosynthèse correspond au palier de la courbe, atteint pour un éclairement bien supérieur.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c36f186f-3063-51cd-993c-dc9cec99830e', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', '⭐ Exercice : L''usine à sucre de la feuille', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Qu''est-ce que la photosynthèse ?', '[{"id":"a","text":"La formation de matière organique qui nécessite de l''énergie lumineuse"},{"id":"b","text":"L''absorption d''eau et de sels minéraux par les racines"},{"id":"c","text":"La dégradation de matière organique pour produire de l''énergie utilisable"},{"id":"d","text":"La perte d''eau par les feuilles sous forme de vapeur"}]'::jsonb, 'a', 'La photosynthèse est la formation de matière organique, qui nécessite de l''énergie lumineuse ✓ ; seuls les organismes chlorophylliens la réalisent. L''absorption d''eau et de sels minéraux par les racines est la nutrition minérale, étudiée au chapitre précédent. La dégradation de matière organique pour produire de l''énergie est la respiration : la plante la pratique aussi, 24 heures sur 24, mais c''est le phénomène inverse. Et la perte d''eau sous forme de vapeur est la transpiration.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b090ddd8-59be-59ba-bb90-a5878b110d4f', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Dans le montage qui prive des feuilles de dioxyde de carbone, l''air du sac n° 2 barbote d''abord dans la potasse, puis dans l''eau de chaux. À quoi sert le second flacon ?', '[{"id":"a","text":"À absorber le dioxyde de carbone restant"},{"id":"b","text":"À contrôler que le dioxyde de carbone a bien été totalement absorbé"},{"id":"c","text":"À enrichir l''air en oxygène avant qu''il n''atteigne les feuilles du sac"},{"id":"d","text":"À humidifier l''air avant qu''il n''entre dans le sac"}]'::jsonb, 'b', 'C''est le premier flacon, celui de potasse, qui absorbe le dioxyde de carbone ; le second, à l''eau de chaux, sert à contrôler que le CO₂ a bien été totalement absorbé ✓. Sans lui, on ignorerait si le montage a réellement fait ce qu''on attend de lui — et toute la conclusion s''écroulerait. Il n''a donc pas pour rôle d''absorber à son tour, et il ne modifie ni l''oxygène ni l''humidité de l''air. Rappelle-toi aussi le rôle du sac n° 1, qui reçoit un air normal : c''est le témoin.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78b78f9b-886e-59b5-926c-f9edf845f4d7', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Comment est faite une cellule d''un tube criblé, dans le phloème ?', '[{"id":"a","text":"C''est une cellule morte, réduite à sa paroi lignifiée"},{"id":"b","text":"C''est une cellule déjà morte, dont la paroi transversale est percée de pores"},{"id":"c","text":"C''est une cellule vivante, dont la paroi transversale est percée de pores"},{"id":"d","text":"C''est une cellule vivante, entièrement close, sans communication"}]'::jsonb, 'c', 'Les vaisseaux conducteurs de la sève élaborée forment le phloème : ce sont des tubes criblés, chacun formé d''une file de cellules vivantes dont les parois transversales sont percées de pores ✓. Comparées à une cellule normale, elles ont perdu leur noyau et leur vacuole, mais gardé leur cytoplasme et leur paroi cellulosique. La cellule morte réduite à sa paroi lignifiée décrit le vaisseau du bois, qui conduit la sève brute — et lui prêter des pores mélange les deux organes. Enfin, une cellule entièrement close ne laisserait rien circuler : ce sont justement les pores qui font le crible du tube criblé.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'L''intensité photosynthétique peut se mesurer par :', '[{"id":"a","text":"la quantité de lumière reçue par unité de surface de feuille"},{"id":"b","text":"la quantité d''O₂ rejeté par unité de masse et par unité de temps"},{"id":"c","text":"la masse sèche produite par la plante au bout d''un mois de culture"},{"id":"d","text":"le nombre de chloroplastes contenus dans une cellule"}]'::jsonb, 'b', 'L''intensité photosynthétique est la quantité de dioxyde de carbone absorbé, ou d''oxygène rejeté, par unité de masse du végétal et par unité de temps ✓ : ce sont les deux manifestations gazeuses de la photosynthèse, et l''une ou l''autre suffit à la mesurer. L''éclairement est un facteur qui la fait varier, pas sa mesure. La masse sèche produite en un mois mesure la production végétale : il y manque la masse du végétal, donc ce n''est pas une intensité. Et le nombre de chloroplastes ne dit rien de leur activité.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f850f95b-136b-5c31-bb57-875cc4a1461a', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Quelle est l''équation globale de la photosynthèse ?', '[{"id":"a","text":"C₆H₁₂O₆ + 6 O₂ → 6 CO₂ + 6 H₂O"},{"id":"b","text":"6 CO₂ + 6 O₂ → C₆H₁₂O₆ + 6 H₂O"},{"id":"c","text":"2 H₂O → O₂ + 4 H⁺ + 4 e⁻"},{"id":"d","text":"6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂"}]'::jsonb, 'd', 'La photosynthèse part de matières premières minérales — le dioxyde de carbone et l''eau — pour fabriquer du glucose en rejetant de l''oxygène : 6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂ ✓, sous les conditions de lumière et de chlorophylle. L''équation qui consomme le glucose et l''oxygène pour rendre du CO₂ et de l''eau est la même, écrite à l''envers. Celle qui fait entrer l''oxygène comme matière première se trompe de camp : l''oxygène est un produit. Quant à 2 H₂O → O₂ + 4 H⁺ + 4 e⁻, elle est exacte, mais c''est la photolyse de l''eau : une seule réaction de la phase photochimique, pas le bilan global.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe53f4af-f844-5250-b629-d6bb89028ce2', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'À partir de quelle teneur en nitrates une eau ne doit-elle plus être consommée du tout ?', '[{"id":"a","text":"6 mg/l"},{"id":"b","text":"50 mg/l"},{"id":"c","text":"100 mg/l"},{"id":"d","text":"300 mg/l"}]'::jsonb, 'c', 'Une eau contenant plus de 100 mg/l de nitrates ne doit pas être consommée ✓. En dessous, le texte fixe deux autres paliers : une eau destinée à la consommation humaine doit avoir une teneur inférieure ou égale à 50 mg/l — c''est le seuil au-delà duquel la maladie peut apparaître — et, entre 50 et 100 mg/l, l''eau reste utilisable sauf pour les femmes enceintes et les nourrissons de moins de 6 mois. Le nombre 6 est précisément cet âge en mois, pas une teneur ; et 300 mg/l ne correspond à aucun seuil.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9b5b7c6a-148c-5478-93da-b16535b99a16', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Photosynthèse, sève élaborée et facteurs limitants', 2, 75, 15, 'practice', 'admin', 3)
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
  ('09dce64e-c683-5928-a806-eb08a471da9b', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'En 1951, Gaffron apporte du dioxyde de carbone radioactif à des algues fortement éclairées, puis les place à l''obscurité. Le carbone continue d''être incorporé pendant 15 à 20 secondes, à condition que les algues aient reçu au préalable au moins 10 minutes de forte lumière ; sans cette illumination, l''incorporation cesse aussitôt. Que conclut-on ?', '[{"id":"a","text":"Que l''incorporation du CO₂ utilise l''énergie stockée à la lumière"},{"id":"b","text":"Que l''incorporation du CO₂ ne se produit qu''en pleine lumière"},{"id":"c","text":"Que la lumière ne joue aucun rôle dans la photosynthèse"},{"id":"d","text":"Que le CO₂ radioactif éclaire les algues pendant 15 à 20 secondes"}]'::jsonb, 'a', 'Si l''incorporation du carbone se poursuit 15 à 20 secondes après l''extinction, c''est qu''elle ne réclame pas la lumière à l''instant même. Et si elle exige quand même 10 minutes de forte lumière préalable, c''est que cette lumière a laissé quelque chose derrière elle : de l''énergie chimique stockée ✓. C''est exactement ce qui sépare la phase photochimique, qui se déroule à la lumière et stocke l''énergie, de la phase sombre, qui incorpore le CO₂ sans besoin direct de lumière. Soutenir que tout exige la pleine lumière est contredit par les 15 à 20 secondes d''incorporation à l''obscurité ; soutenir que la lumière ne joue aucun rôle est contredit par l''autre moitié de l''expérience, puisque sans les 10 minutes préalables tout s''arrête. Quant à faire du traceur radioactif une source lumineuse, cela n''a aucun sens.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1627a75b-f528-5ca9-9be0-57f70af79631', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'On découpe en anneau l''écorce d''une tige. La plante reste alimentée en sève brute et la photosynthèse se poursuit normalement. Quelques heures plus tard, les substances organiques sont anormalement abondantes au-dessus de la zone décortiquée. Qu''en déduit-on ?', '[{"id":"a","text":"La sève brute circulait vers le bas et l''anneau l''a bloquée"},{"id":"b","text":"La sève élaborée circulait vers le haut et l''anneau l''a bloquée"},{"id":"c","text":"La sève élaborée circulait vers le bas et l''anneau l''a bloquée"},{"id":"d","text":"L''écorce fabrique elle-même les substances organiques"}]'::jsonb, 'c', 'Les substances organiques s''accumulent juste au-dessus de la coupure : elles arrivaient donc d''en haut, des feuilles, et n''ont pas pu passer. La sève élaborée descendait, et l''anneau d''écorce l''a bloquée ✓ — le bourrelet de cicatrisation se forme d''ailleurs au-dessus lui aussi, plusieurs semaines plus tard. La sève brute n''est pas concernée : l''énoncé précise que la plante reste alimentée, car elle circule dans le bois, à l''intérieur, et non dans l''écorce ; de toute façon, elle monte. Si la sève élaborée montait, l''accumulation se ferait en dessous de l''anneau — c''est le piège courant, qui consiste à ne pas regarder de quel côté du blocage la matière s''entasse. Enfin, l''écorce ne fabrique pas de matière organique : c''est la feuille qui la fabrique, à la lumière et grâce à la chlorophylle.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('90414dcf-d539-5199-99be-a07837dbe49a', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'Six lots de jeunes plantes sont cultivés dans des conditions identiques, sauf l''éclairement. Après un mois, la masse sèche récoltée est de 2,5 g à 1000 lux, 5 g à 2000 lux, 12,5 g à 4000 lux, 17,5 g à 6000 lux, 20 g à 8000 lux et 20,5 g à 10 000 lux. Que montrent ces résultats ?', '[{"id":"a","text":"La production est proportionnelle à l''éclairement sur tout l''intervalle"},{"id":"b","text":"La production augmente avec l''éclairement, puis plafonne au-delà de 8000 lux"},{"id":"c","text":"La production diminue dès que l''éclairement dépasse 8000 lux"},{"id":"d","text":"L''éclairement n''a pas d''influence sur la production de matière sèche"}]'::jsonb, 'b', 'La masse sèche grimpe de 2,5 g à 20 g quand l''éclairement passe de 1000 à 8000 lux, puis ne gagne plus que 0,5 g entre 8000 et 10 000 lux : la production augmente d''abord fortement, puis plafonne ✓ — un autre facteur est devenu limitant. Elle n''est pas proportionnelle : en passant de 2000 à 4000 lux l''éclairement double, mais la production passe de 5 g à 12,5 g, soit un facteur 2,5 et non 2. Elle ne diminue pas non plus au-delà de 8000 lux : 20,5 g est supérieur à 20 g, l''augmentation est simplement devenue négligeable. Et prétendre que l''éclairement n''a pas d''influence est intenable : c''est le seul paramètre qui change entre les six lots, et la production est multipliée par 8.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('928b07f4-9368-5470-86e9-e0e86a536a0f', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'L''épinard, la pomme de terre et la fougère n''atteignent pas leur intensité photosynthétique maximale au même éclairement : l''optimum de la fougère est obtenu pour un éclairement beaucoup plus faible. Comment nomme-t-on ces deux catégories de plantes ?', '[{"id":"a","text":"Plantes de soleil (fougère) et plantes d''ombre (épinard, pomme de terre)"},{"id":"b","text":"Plantes de jour et plantes de nuit"},{"id":"c","text":"Plantes chlorophylliennes et plantes non chlorophylliennes"},{"id":"d","text":"Plantes de soleil (épinard, pomme de terre) et plantes d''ombre (fougère)"}]'::jsonb, 'd', 'Certaines plantes n''atteignent leur optimum que sous un fort éclairement : ce sont les plantes de soleil, comme l''épinard et la pomme de terre. D''autres l''atteignent sous un éclairement beaucoup plus faible : ce sont les plantes d''ombre, comme la fougère ✓. Ranger la fougère parmi les plantes de soleil inverse les deux listes — c''est bien elle qui se contente de peu de lumière. Le partage chlorophyllien / non chlorophyllien n''a pas de sens ici : les trois espèces citées sont chlorophylliennes, sans quoi il n''y aurait aucune photosynthèse à mesurer. Et « plantes de nuit » n''existe pas : aucune plante ne photosynthétise sans lumière.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4fa20252-4e33-5378-adb2-98783f658dbb', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'On mesure l''intensité photosynthétique d''une plante en fonction de la teneur de l''air en dioxyde de carbone : 1 à 0 %, 6 à 0,06 %, 10 à 0,12 %, 11 à 0,15 %, 11 à 0,18 % et 11 à 0,21 %. Un serriste décide d''enrichir l''atmosphère de sa serre de 0,15 % à 0,21 % de CO₂. Qu''obtiendra-t-il ?', '[{"id":"a","text":"Une intensité inchangée : un autre facteur est devenu limitant"},{"id":"b","text":"Une intensité multipliée par 1,4, comme la teneur en CO₂"},{"id":"c","text":"Une chute de l''intensité : à 0,21 %, le CO₂ est devenu toxique"},{"id":"d","text":"Une intensité nulle : à cette teneur, la plante ne respire plus"}]'::jsonb, 'a', 'À partir de 0,15 % la courbe forme un palier : l''intensité reste à 11, que l''air contienne 0,15 %, 0,18 % ou 0,21 % de CO₂. L''enrichissement ne changera donc rien ✓, et pour une raison précise : le CO₂ n''est plus le facteur qui limite le phénomène — un autre l''a remplacé, généralement la température ou l''éclairement. Le raisonnement proportionnel est le piège courant : la relation n''est à peu près linéaire qu''au début, entre 0 et 0,12 %. Le CO₂ devient bien toxique un jour, mais seulement au-delà de 0,3 % : on en est loin. Et la respiration ne s''arrête jamais, elle se déroule 24 heures sur 24.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca3e8723-6581-5fa1-9b6a-988b944557e7', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'Un arboriculteur place dans son verger de multiples diffuseurs de phéromone de synthèse. Par quel mécanisme cette technique fait-elle baisser la population de ravageurs ?', '[{"id":"a","text":"Les diffuseurs empoisonnent les mâles qui s''en approchent"},{"id":"b","text":"Les phéromones tuent les larves avant leur éclosion"},{"id":"c","text":"Le mâle ne distingue plus la piste de la femelle et ne la retrouve pas"},{"id":"d","text":"Les mâles, attirés dans des pièges, y sont capturés puis stérilisés par irradiation"}]'::jsonb, 'c', 'Dans les conditions normales, le mâle rejoint la femelle en suivant le flux d''air chargé de phéromones. En multipliant les diffuseurs de phéromone synthétique, on brouille cette piste : incapable de localiser une source plutôt qu''une autre, le mâle se trouve « confondu » et ne retrouve pas la femelle — les chances d''accouplement chutent et les effectifs baissent ✓. C''est la confusion des mâles. Les phéromones ne sont ni un poison ni un larvicide : ce sont des substances chimiques émises par les femelles pour attirer le partenaire sexuel, et la lutte biologique se sert de ce signal, jamais d''une toxicité. Le piège courant est de décrire l''autre technique fondée sur les phéromones — la stérilisation des mâles, où les diffuseurs sont placés dans des pièges et les mâles capturés puis irradiés avant d''être relâchés. Ici, il n''y a aucun piège : les diffuseurs sont en plein verger.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7f91558c-7618-5982-baef-81925e952f79', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', 'Test de compréhension ⭐ : La multiplication végétative', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('be73d5e3-1039-5dfb-82da-19796687e6ef', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qu''une bouture ?', '[{"id":"a","text":"Une graine sélectionnée pour son fort pouvoir germinatif"},{"id":"b","text":"Une portion de plante capable de régénérer les parties manquantes"},{"id":"c","text":"Un bourgeon prélevé pour être fixé sur une autre plante"},{"id":"d","text":"Une jeune plante issue de la reproduction sexuée"}]'::jsonb, 'b', 'Une bouture est une portion plus ou moins importante d''une plante — feuille, tige, rhizome — capable de régénérer les parties manquantes et de se développer totalement ✓ : mise à terre, elle s''enracine et donne une nouvelle plante. Une graine, comme une jeune plante issue d''un semis, relève de la reproduction sexuée, pas de la multiplication végétative. Et le bourgeon prélevé pour être fixé sur une autre plante est un greffon : il ne s''enracine pas, il se raccorde aux vaisseaux du porte greffe.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0cb9d1b-054c-5c92-b59e-849adaab9a71', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qui distingue le marcottage du bouturage ?', '[{"id":"a","text":"Le marcottage n''emploie que des racines, le bouturage que des tiges"},{"id":"b","text":"La plante obtenue par marcottage diffère de la plante mère"},{"id":"c","text":"Le marcottage se pratique in vitro, le bouturage en pleine terre"},{"id":"d","text":"La tige n''est détachée de la plante mère qu''après son enracinement"}]'::jsonb, 'd', 'Dans le marcottage, on enterre une tige aérienne sans la détacher de la plante ; ce n''est qu''une fois les racines adventives formées qu''on isole la tige enracinée ✓. Dans le bouturage, au contraire, le fragment est détaché d''abord et s''enracine seul : c''est toute la différence, et elle tient à la chronologie. Les deux techniques emploient bien des tiges aériennes, et non des racines. Toutes deux conservent les caractères de la plante mère — c''est justement leur intérêt. Et aucune des deux ne se pratique in vitro : ce sont les techniques traditionnelles.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95a19fac-1d90-527f-a28c-c57942c6bc24', '7f91558c-7618-5982-baef-81925e952f79', 'Après une greffe réussie, d''où viennent les racines de la nouvelle plante, et d''où viennent ses fruits ?', '[{"id":"a","text":"Les racines viennent du porte greffe, les fruits viennent du greffon"},{"id":"b","text":"Les racines viennent du greffon, les fruits viennent du porte greffe"},{"id":"c","text":"Les racines et les fruits viennent tous deux du greffon"},{"id":"d","text":"Les racines et les fruits viennent tous deux du porte greffe"}]'::jsonb, 'a', 'Le porte greffe conserve son appareil absorbant complet — ses racines — et une partie du tronc ; le greffon développe l''appareil assimilateur et de fructification (rameaux, tige, feuilles, fruits), à l''exclusion de toute racine ✓. La nouvelle plante porte donc les caractères de la plante qui a fourni le greffon, et c''est bien pour cela qu''on prélève ce dernier sur un végétal sélectionné pour la qualité de ses fruits ou de ses fleurs. Toute autre répartition se trompe sur au moins un des deux rôles.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('be512e27-4044-5f2f-940a-b523152a8bda', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qu''un clone ?', '[{"id":"a","text":"Une plante obtenue en croisant deux variétés différentes"},{"id":"b","text":"Un ensemble de graines produites par une même plante mère"},{"id":"c","text":"Un ensemble d''individus identiques issus d''un individu unique"},{"id":"d","text":"Une plante dont les caractères ont été améliorés au laboratoire"}]'::jsonb, 'c', 'Un clone est un ensemble d''individus possédant les mêmes caractères et provenant de la multiplication végétative d''un individu unique ✓ : toutes les plantes issues d''une même plante mère par bouturage, marcottage, greffage ou culture in vitro en forment un. Un croisement relève de la reproduction sexuée, et ses descendants ne sont justement pas identiques ; des graines non plus. Et la multiplication végétative n''améliore rien : elle conserve et multiplie ce que la plante mère avait déjà — c''est le choix de cette plante mère qui décide de tout.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '7f91558c-7618-5982-baef-81925e952f79', 'Quel est l''avantage décisif de la culture in vitro par rapport au bouturage traditionnel ?', '[{"id":"a","text":"Elle produit des plantes différentes de la plante mère, donc plus variées"},{"id":"b","text":"Elle produit un nombre bien plus grand de plantes dans le même temps"},{"id":"c","text":"Elle se pratique en pleine terre, sans matériel de laboratoire"},{"id":"d","text":"Elle permet de se passer de tout milieu nutritif"}]'::jsonb, 'b', 'En un an, le microbouturage in vitro donne 400 000 oliviers identiques à la plante d''origine, là où le bouturage traditionnel n''en donnerait dans le même temps qu''une vingtaine ✓ : c''est un changement d''échelle. Les plantes obtenues ne sont pas plus variées — elles forment justement un clone, toutes identiques à la plante de départ. Et la technique ne se pratique ni en pleine terre ni sans milieu nutritif : elle exige des conditions d''asepsie, et c''est bien sur un milieu nutritif que chaque microbouture est mise en culture.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('227a9291-489c-5ecf-acd2-9c5c64e2961f', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', '⭐ Exercice : Boutures, greffes et éprouvettes', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Le tubercule de pomme de terre permet la multiplication végétative. De quel organe s''agit-il exactement ?', '[{"id":"a","text":"D''une racine gonflée de réserves"},{"id":"b","text":"D''une portion de tige souterraine portant des bourgeons"},{"id":"c","text":"D''un bulbe formé de feuilles serrées les unes contre les autres"},{"id":"d","text":"D''un fruit souterrain contenant des graines"}]'::jsonb, 'b', 'Le tubercule de pomme de terre est une partie d''une tige souterraine qui porte des bourgeons ✓ — et c''est précisément pour cela qu''il multiplie la plante : un seul bourgeon isolé suffit à fournir un plant normal producteur de tubercules normaux. Ce n''est ni une racine ni un bulbe : le tubercule est une tige, reconnaissable à ses bourgeons. Et ce n''est pas un fruit : un fruit contiendrait des graines et relèverait donc de la reproduction sexuée, alors que planter un tubercule est bien une multiplication végétative.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Un rameau feuillé de pélargonium est enfoncé dans de la terre humide. Qu''apparaît-il dans la partie enterrée, au voisinage de la section ?', '[{"id":"a","text":"Des bourgeons floraux"},{"id":"b","text":"Un cal, et rien d''autre ensuite"},{"id":"c","text":"Des racines adventives"},{"id":"d","text":"Des tubercules"}]'::jsonb, 'c', 'Des racines adventives apparaissent dans la partie enterrée, au voisinage de la section ✓ ; la partie aérienne s''accroît alors, se ramifie et engendre des feuilles — le rameau isolé est ainsi à l''origine d''une nouvelle plante. Des bourgeons floraux ne sont pas ce que produit la section. Le cal existe bien, mais il est décrit chez l''olivier en bouturage semi-ligneux, et il précède justement l''émission des racines : la bouture ne s''arrête pas là. Quant aux tubercules, ce sont des tiges souterraines de réserve produites par le plant de pomme de terre.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3364383e-d368-5784-86f2-de778373c561', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Dans une greffe, comment appelle-t-on la plante sur laquelle on fixe le fragment prélevé ?', '[{"id":"a","text":"Le porte greffe"},{"id":"b","text":"Le greffon"},{"id":"c","text":"La marcotte"},{"id":"d","text":"Le végétal franc"}]'::jsonb, 'a', 'Le porte greffe est la plante sur laquelle on fixe le greffon ✓. Le greffon, lui, est le fragment prélevé — un bourgeon ou un jeune rameau — sur un végétal sélectionné pour la qualité de ses fruits ou de ses fleurs : c''est l''inverse du rôle demandé. La marcotte appartient à une autre technique, le marcottage. Quant au végétal franc, c''est un végétal provenant des semis : il sert souvent de porte greffe (pommier franc, amandier franc), mais le terme désigne son origine, pas son rôle dans la greffe.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('45559784-8b76-5964-8436-c523028c5c23', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'En un an, le microbouturage in vitro permet d''obtenir combien d''oliviers identiques à la plante d''origine, là où le bouturage traditionnel n''en donne qu''une vingtaine ?', '[{"id":"a","text":"400"},{"id":"b","text":"4000"},{"id":"c","text":"40 000"},{"id":"d","text":"400 000"}]'::jsonb, 'd', 'En un an, la culture in vitro par microbouturage donne 400 000 oliviers identiques à la plante d''origine ✓, contre une vingtaine seulement par bouturage traditionnel dans le même temps. Aucun des ordres de grandeur plus modestes ne rend justice à ce que permet la technique : ce n''est pas un gain marginal mais un changement d''échelle, rendu possible par la répétition des étapes de fragmentation, de remise sur milieu nutritif et de développement — chaque cycle multipliant à nouveau le nombre de microboutures.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8ae48a12-409a-5862-8d8b-fd5717b60f6b', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Le bouturage semi-ligneux de l''olivier réclame une température et une humidité ambiante précises. Lesquelles ?', '[{"id":"a","text":"5 à 10 °C, et une humidité inférieure à 20 %"},{"id":"b","text":"23 à 25 °C, et une humidité supérieure à 80 %"},{"id":"c","text":"23 à 25 °C, et une humidité inférieure à 20 %"},{"id":"d","text":"5 à 10 °C, et une humidité supérieure à 80 %"}]'::jsonb, 'b', 'On enracine la bouture d''olivier à une température de 23 à 25 °C et sous une humidité ambiante supérieure à 80 % ✓ ; un cal se développe alors au bout de quelques semaines, et les racines apparaissent vers 8 semaines. Ni une température de 5 à 10 °C ni une atmosphère sèche ne figurent au protocole. Et la forte humidité n''est pas un détail : tant que la bouture n''a pas de racines, elle ne peut pas remplacer l''eau qu''elle perd.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1112df0f-2cc9-57eb-8626-75a1f48d6489', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Pourquoi qualifie-t-on de « totipotentes » les cellules du bourgeon prélevé pour le microbouturage ?', '[{"id":"a","text":"Parce qu''elles se divisent indéfiniment sans jamais mourir"},{"id":"b","text":"Parce qu''elles résistent à toutes les maladies de la plante"},{"id":"c","text":"Parce qu''elles peuvent donner n''importe quelle partie de la plante"},{"id":"d","text":"Parce qu''elles contiennent toutes les substances nutritives utiles"}]'::jsonb, 'c', 'Le bourgeon d''une microbouture renferme des cellules embryonnaires dites totipotentes : elles sont capables de se développer pour donner n''importe quelle partie de la plante — tige, racine, feuille ✓. C''est cette propriété, la totipotence, qui rend la reproduction végétative possible : une seule cellule peut donner n''importe quel organe. Ni une division illimitée, ni une résistance aux maladies, ni une réserve de nutriments ne sont ce que le mot désigne — ce sont d''ailleurs bien des maladies à virus que la culture des méristèmes cherche à éliminer, et le milieu nutritif est apporté de l''extérieur, pas contenu dans la cellule.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fbb8b06e-5283-56bb-972b-345b39829387', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Du greffon au clone', 2, 75, 15, 'practice', 'admin', 3)
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
  ('d89a6f15-c64b-5dfa-b278-ec3148730ddd', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un fragment de tubercule de pomme de terre planté en automne donne un pied qui produit 15 à 30 tubercules, récoltés au printemps. Une graine de pomme de terre, elle, ne donne un plant à tubercules normaux qu''au bout de quatre ans. Que montre cette comparaison ?', '[{"id":"a","text":"La multiplication végétative donne un meilleur rendement, plus vite"},{"id":"b","text":"La reproduction sexuée est plus rapide que la multiplication végétative"},{"id":"c","text":"Les deux modes donnent le même résultat dans le même temps"},{"id":"d","text":"La graine de pomme de terre est incapable de germer"}]'::jsonb, 'a', 'Quatre ans par la graine, contre une seule saison — de l''automne au printemps — par le fragment de tubercule, et 15 à 30 tubercules à la clé : la multiplication végétative permet un rendement meilleur et dans un délai court ✓. Soutenir que la reproduction sexuée est plus rapide inverse exactement la comparaison, et prétendre que les deux modes se valent revient à ignorer l''écart de quatre ans. Enfin, la graine germe bel et bien et donne un plant : il lui faut simplement quatre ans pour produire des tubercules normaux.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'fbb8b06e-5283-56bb-972b-345b39829387', 'On greffe en écusson un greffon d''abricotier sur un porte greffe d''amandier franc. Quels fruits portera la nouvelle plante ?', '[{"id":"a","text":"Des amandes, puisque les racines sont celles de l''amandier"},{"id":"b","text":"Des abricots, puisque le greffon vient de l''abricotier"},{"id":"c","text":"Un mélange d''abricots et d''amandes"},{"id":"d","text":"Aucun fruit : greffer deux espèces différentes rend la plante stérile"}]'::jsonb, 'b', 'Le greffon développe l''appareil assimilateur et de fructification — rameaux, tige, feuilles, fruits — et la nouvelle plante porte les caractères de la plante qui a fourni le greffon : elle donnera donc des abricots ✓. Le porte greffe, lui, ne fournit que l''appareil absorbant (les racines) et une partie du tronc. Le piège courant est de croire que la racine décide du fruit, et d''attendre des amandes. Il n''y a pas non plus de mélange : chaque partie garde son identité. Et la greffe n''est pas stérile : greffon et porte greffe appartiennent à la même espèce ou à des espèces voisines, et le tableau des possibilités de greffage donne justement ce couple abricotier / amandier franc, en écusson, au mois de mai.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ada3ea63-8e05-59da-b2e8-d839fa08f014', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Le clonage in vitro d''un rosier part d''un explant — un bourgeon — mis en culture en conditions aseptiques sur un milieu nutritif, et aboutit à 200 000 à 400 000 rosiers. Quelle étape, entre les deux, explique ce nombre ?', '[{"id":"a","text":"L''enracinement des plantules avant leur mise en pot"},{"id":"b","text":"La mise en pot sous serre des plantules enracinées"},{"id":"c","text":"La fragmentation répétée de la bouture en de nombreuses microboutures"},{"id":"d","text":"L''acclimatation progressive des plants aux conditions extérieures"}]'::jsonb, 'c', 'Entre l''explant unique et les centaines de milliers de plants, une seule étape multiplie : la fragmentation de la bouture obtenue en de nombreuses microboutures, chacune remise en culture — et l''opération se répète plusieurs fois ✓. C''est ce cycle qui fait passer de 1 bourgeon à « nombreuses boutures », puis à 200 000 à 400 000 plantules. L''enracinement, la mise en pot et l''acclimatation sont des étapes indispensables, mais elles ne font que mener à terme des plants déjà obtenus : aucune ne crée un individu de plus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01e92174-0fd1-5e71-a5f9-ba16e036f152', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un local de culture in vitro climatisé de 9 m² remplace 25 500 m² de serres chauffées ou refroidies selon la saison. Par combien la surface nécessaire est-elle approximativement divisée ?', '[{"id":"a","text":"Par 30 environ"},{"id":"b","text":"Par 300 environ"},{"id":"c","text":"Par 2800 environ"},{"id":"d","text":"Par 28 000 environ"}]'::jsonb, 'c', '25 500 / 9 ≈ 2833 : la surface nécessaire est divisée par 2800 environ ✓. Les rapports de 30 et de 300 sous-estiment d''un facteur 100 et 10 ; celui de 28 000 surestime d''un facteur 10. Retiens surtout ce que ce chiffre signifie : au-delà de l''espace, c''est le chauffage et la climatisation de plusieurs hectares de serres qui sont économisés — un grand producteur d''œillets obtient d''ailleurs en deux ans, par la culture in vitro, ce qu''il produisait en quatre ans par la culture traditionnelle.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b51d95dc-789a-52c6-bcf8-039d9a13dca2', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Une culture de pomme de terre est ravagée par des maladies à virus. Un agronome veut en obtenir des plants sains, sans perdre la variété qu''il cultive. Que doit-il faire ?', '[{"id":"a","text":"Replanter les tubercules de la culture atteinte, après les avoir triés"},{"id":"b","text":"Croiser cette variété avec une autre et semer les graines obtenues"},{"id":"c","text":"Bouturer des fragments de tiges prélevés sur la culture atteinte"},{"id":"d","text":"Prélever des cellules méristématiques et les cultiver in vitro"}]'::jsonb, 'd', 'Des clones sains ont pu être reconstitués grâce à la culture des cellules méristématiques : c''est l''un des trois grands intérêts de la culture in vitro ✓, et le seul moyen qui réponde ici aux deux exigences à la fois — éliminer la maladie et garder la variété. Replanter les tubercules ou bouturer des fragments de la culture atteinte, c''est repartir de la plante malade elle-même : rien, dans ces techniques, n''est présenté comme éliminant la maladie — la multiplication végétative conserve les caractères de la plante mère, c''est son principe même. Quant au croisement, il relève de la reproduction sexuée : les descendants issus de graines ne sont justement pas identiques entre eux, et l''agronome perdrait la variété qu''il cherche à sauver.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un agriculteur clone in vitro un plant de vigne médiocre, en espérant que la technique améliore sa production. Qu''obtiendra-t-il ?', '[{"id":"a","text":"Des milliers de plants aussi médiocres que le plant de départ"},{"id":"b","text":"Des plants améliorés : la culture in vitro sélectionne les meilleures cellules"},{"id":"c","text":"Des plants tous différents les uns des autres"},{"id":"d","text":"Des plants améliorés : le milieu nutritif enrichit les caractères de la plante"}]'::jsonb, 'a', 'La culture in vitro produit un clone : un ensemble d''individus possédant les mêmes caractères que l''individu unique dont ils proviennent. Elle conserve donc à l''identique la médiocrité du plant de départ — et la multiplie par des milliers ✓. C''est le piège le plus courant du chapitre : croire que la technique améliore, que ce soit par une prétendue sélection des meilleures cellules ou par la vertu du milieu nutritif. Elle ne fait que conserver et multiplier, et c''est bien pour cela qu''on prélève toujours la microbouture sur une plante performante, sélectionnée pour son rendement, sa qualité ou sa résistance aux maladies. Enfin les plants ne seront pas différents entre eux : ils sont tous identiques, c''est la définition même du clone.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bc4dc18c-ab71-558f-b433-660d14f30960', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', 'Test de compréhension ⭐ : La diversité du monde microbien', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('93db0bf6-4904-59ee-8216-d62070775e36', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'En combien de groupes classe-t-on les micro-organismes, et lesquels ?', '[{"id":"a","text":"2 groupes : les microbes utiles et les microbes pathogènes"},{"id":"b","text":"3 groupes : les bactéries, les champignons et les virus"},{"id":"c","text":"4 groupes : les protozoaires, les bactéries, les champignons et les virus"},{"id":"d","text":"4 groupes : les bacilles, les coques, les moisissures et les bactériophages"}]'::jsonb, 'c', 'On classe les micro-organismes en quatre groupes : les protozoaires, les bactéries, les champignons microscopiques et les virus ✓, qui diffèrent par leur taille, leur forme et leur mode d''action sur l''organisme. La distinction utiles / pathogènes est réelle, mais elle traverse les quatre groupes au lieu de les remplacer. S''en tenir aux bactéries, aux champignons et aux virus oublie les protozoaires. Et la liste bacilles / coques / moisissures / bactériophages mélange les niveaux : bacilles et coques sont des formes de bactéries, les moisissures une catégorie de champignons, les bactériophages une sorte de virus — ce sont des subdivisions, pas les groupes eux-mêmes.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Que signifie « procaryote » ?', '[{"id":"a","text":"Un être vivant dont la cellule ne contient pas un véritable noyau"},{"id":"b","text":"Un être vivant constitué d''une seule cellule"},{"id":"c","text":"Un être vivant qui cause une maladie"},{"id":"d","text":"Un être vivant dont la cellule est entièrement dépourvue de cytoplasme"}]'::jsonb, 'a', 'Procaryote signifie : un être vivant constitué d''une cellule ne contenant pas un véritable noyau ✓ — son matériel génétique baigne directement dans le cytoplasme, sans membrane pour l''entourer. Exemples : les bactéries, les algues bleues. Être formé d''une seule cellule, c''est être unicellulaire : la paramécie l''est aussi, et pourtant elle possède un vrai noyau — c''est une eucaryote. Causer une maladie, c''est être pathogène. Et un procaryote a bien un cytoplasme : c''est justement là que baigne son matériel génétique.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9cbf896b-6c63-553c-88c3-fba80035bffd', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Pourquoi dit-on du virus que c''est un « parasite intracellulaire obligatoire » ?', '[{"id":"a","text":"Parce qu''il vit collé à la surface des cellules"},{"id":"b","text":"Parce qu''il ne peut se multiplier qu''à l''intérieur d''une cellule vivante"},{"id":"c","text":"Parce qu''il détruit obligatoirement la cellule vivante dans laquelle il pénètre"},{"id":"d","text":"Parce qu''il ne parasite que les cellules humaines"}]'::jsonb, 'b', 'Un virus est inerte dans le milieu extérieur : il ne respire pas et ne se reproduit pas. Il ne peut se multiplier qu''à l''intérieur d''une cellule vivante, la cellule hôte ✓ — d''où « intracellulaire » et « obligatoire ». Il ne vit pas collé à la surface : il doit pénétrer dans la cellule pour manifester la moindre activité. La destruction de la cellule n''est pas ce que le terme désigne. Et il ne parasite pas que les cellules humaines : la cellule hôte peut être animale, végétale ou bactérienne — les bactériophages sont précisément des virus qui infectent les bactéries.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d67fe435-439d-5cdd-b681-1444debbd583', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Pourquoi la levure de bière est-elle qualifiée de champignon « unicellulaire » ?', '[{"id":"a","text":"Parce qu''elle vit isolée, jamais en groupe"},{"id":"b","text":"Parce qu''elle ne possède qu''un seul type de cellule, toujours le même"},{"id":"c","text":"Parce qu''elle mesure moins de 10 μm"},{"id":"d","text":"Parce que chaque individu est formé d''une seule cellule"}]'::jsonb, 'd', 'La levure de bière est constituée de cellules sphériques ou ovoïdes de 6 à 10 μm, et chaque individu est une cellule unique ✓ : voilà pourquoi on la dit unicellulaire. C''est ce qui l''oppose aux champignons filamenteux — moisissures, trichophyton, Phytophtora — dont le corps est un mycélium fait de filaments. Vivre isolée n''est pas la question : le bourgeonnement produit justement des cellules groupées. Le nombre de types de cellules ne définit pas non plus le mot, pas plus que la taille : une bactérie mesure elle aussi moins de 10 μm sans être un champignon.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86b52802-4f18-5911-b9c3-8708c3435d2f', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Diplocoques, streptocoques et staphylocoques sont trois sortes de coques. Sur quel critère les classe-t-on ?', '[{"id":"a","text":"Sur leur mode de groupement : par deux, en chaîne ou en grappe"},{"id":"b","text":"Sur la forme de chaque coque prise isolément : ronde, allongée ou spiralée"},{"id":"c","text":"Sur leur taille : petite, moyenne ou grande"},{"id":"d","text":"Sur la maladie qu''elles provoquent"}]'::jsonb, 'a', 'Les coques sont toutes des bactéries en forme de granules : c''est leur groupement qui les distingue — un diplocoque est fait de 2 coques, un streptocoque d''une chaîne de coques, un staphylocoque d''un ensemble de coques en grappe ✓. Leur forme individuelle ne varie pas : elles sont rondes dans les trois cas, et une bactérie en bâtonnet serait un bacille, pas une coque. La taille n''est pas le critère retenu. Quant à la maladie, c''est une conséquence du classement et non son critère : ce sont deux diplocoques différents, le méningocoque et le pneumocoque, qui donnent la méningite et la pneumonie.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6642bf10-24ef-5328-a3c5-04d817695cfe', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', '⭐ Exercice : Reconnaître un microbe', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Où vit la paramécie, et est-elle dangereuse pour l''homme ?', '[{"id":"a","text":"Dans les eaux stagnantes ; c''est un micro-organisme inoffensif"},{"id":"b","text":"Dans le gros intestin ; elle cause la dysentérie amibienne"},{"id":"c","text":"Dans le sol ; elle décompose la matière organique des déchets"},{"id":"d","text":"Sur la peau ; elle provoque des furoncles et des abcès"}]'::jsonb, 'a', 'La paramécie est un animal unicellulaire des eaux stagnantes, et c''est un micro-organisme inoffensif ✓ — on l''obtient en laissant une semaine de l''eau et du foin dans un cristallisoir, à l''abri du soleil et à 25 à 30 °C. Le gros intestin et la dysentérie amibienne sont l''affaire de l''amibe dysentérique, l''autre protozoaire du chapitre : elle, elle est pathogène. La décomposition de la matière organique est le travail des bactéries du sol. Et les furoncles sont l''œuvre des staphylocoques.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('90d6ba8c-fca4-5f7d-9674-138b16f9463f', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'À quoi servent les pseudopodes de l''amibe ?', '[{"id":"a","text":"À la respiration et à l''excrétion"},{"id":"b","text":"À la reproduction et à l''enkystement"},{"id":"c","text":"Au déplacement et à la nutrition"},{"id":"d","text":"À la fixation sur la paroi de l''intestin"}]'::jsonb, 'c', 'Le cytoplasme de l''amibe forme des prolongements, les pseudopodes, qui assurent le déplacement et la nutrition ✓. La respiration et l''excrétion ne leur sont pas attribuées. L''enkystement est un phénomène distinct : lorsque les conditions sont défavorables, l''amibe s''enkyste — et ce sont ces kystes, ingérés avec de l''eau ou des aliments souillés, qui se transforment en amibes dans le tube digestif. Enfin les pseudopodes ne servent pas à se fixer : ils sont au contraire l''organe du mouvement.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24fecb22-d64c-5d54-a8bf-9306088600b2', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Placée dans des conditions favorables, Eschérishia Coli s''allonge et se divise en deux. À quel rythme ?', '[{"id":"a","text":"Toutes les 20 secondes"},{"id":"b","text":"Toutes les 20 minutes"},{"id":"c","text":"Toutes les 20 heures"},{"id":"d","text":"Tous les 20 jours"}]'::jsonb, 'b', 'Deux nouvelles bactéries se forment à partir d''une bactérie initiale toutes les 20 minutes ✓ : ce mode de division est la bipartition, et c''est lui qui donne aux bactéries leur grande capacité de multiplication dès que le milieu leur est favorable. En une heure, cela fait 3 divisions — une bactérie en devient 8. Ni les 20 secondes, ni les 20 heures, ni les 20 jours ne correspondent à ce que l''on observe en culture.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'De quel micro-organisme la pénicilline est-elle tirée ?', '[{"id":"a","text":"De la levure de bière"},{"id":"b","text":"D''une bactérie lactique"},{"id":"c","text":"De l''amibe dysentérique"},{"id":"d","text":"Du Pénicillium notatum"}]'::jsonb, 'd', 'Le Pénicillium notatum, ou Pénicille, est une moisissure verte à partir de laquelle est fabriquée la pénicilline, un antibiotique ✓ : c''est l''exemple type du microbe utile, cultivé par l''homme pour un usage médical. La levure de bière sert, elle, à fabriquer le pain, le vin, la bière et le cidre. Les bactéries lactiques transforment le lait en yaourt. Quant à l''amibe dysentérique, c''est un protozoaire pathogène, agent de l''amibiase.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dbb47327-f7c2-56bf-a720-d139236eb74c', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Sur un microscope, l''oculaire porte l''indication × 15 et l''objectif × 40. Quel est le grossissement de l''observation ?', '[{"id":"a","text":"× 2,7"},{"id":"b","text":"× 40"},{"id":"c","text":"× 55"},{"id":"d","text":"× 600"}]'::jsonb, 'd', 'Le grossissement du microscope est le produit de celui de l''oculaire par celui de l''objectif : 15 × 40 = 600 ✓. Trouver 55 revient à additionner au lieu de multiplier (15 + 40) — c''est le piège courant. Trouver 40 revient à ne retenir que l''objectif et à oublier l''oculaire. Et trouver 2,7 revient à diviser (40 / 15), ce qui n''aurait aucun sens : un microscope grossit, il ne réduit pas.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Les bactéries du sol décomposent la matière organique des cadavres et des déchets animaux et végétaux. En quoi la transforment-elles, et comment nomme-t-on ce processus ?', '[{"id":"a","text":"En humus et en eau ; c''est la fermentation"},{"id":"b","text":"En sels minéraux et en dioxyde de carbone ; c''est la minéralisation"},{"id":"c","text":"En matière organique nouvelle ; c''est la photosynthèse"},{"id":"d","text":"En nitrates et en oxygène ; c''est la respiration"}]'::jsonb, 'b', 'Les bactéries du sol transforment la matière organique des cadavres et des déchets en sels minéraux et en dioxyde de carbone, qui se dégage dans l''air : ce processus est la minéralisation ✓, et il restitue au sol les sels minéraux puisés par les plantes — c''est exactement ce qui fait fonctionner la fertilisation organique vue au chapitre 1. La fermentation est une autre capacité bactérienne, employée pour produire fromages, yaourts et vinaigres. La photosynthèse fabrique de la matière organique au lieu de la décomposer, et elle est l''œuvre des végétaux chlorophylliens. Quant aux nitrates, ils apparaissent bien dans le sol, mais au terme de la minéralisation de l''azote organique — et ce processus ne s''appelle pas la respiration.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4d10426c-9477-5321-8749-0ae925f7c072', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Procaryotes, virus et calculs au microscope', 2, 75, 15, 'practice', 'admin', 3)
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
  ('49aa94ef-d027-5918-940e-187e21d1fb75', '4d10426c-9477-5321-8749-0ae925f7c072', '« La levure de bière est une bactérie. » Pourquoi cette phrase est-elle fausse ?', '[{"id":"a","text":"La levure de bière est un champignon unicellulaire, pas une bactérie"},{"id":"b","text":"La levure de bière est un protozoaire, pas une bactérie"},{"id":"c","text":"La levure de bière est un virus, pas une bactérie"},{"id":"d","text":"La phrase est en réalité exacte"}]'::jsonb, 'a', 'La levure de bière est un champignon unicellulaire, formé de cellules sphériques ou ovoïdes de 6 à 10 μm qui se multiplient par bourgeonnement ✓. Une bactérie, elle, est un procaryote qui se multiplie par bipartition : ni le groupe, ni la structure, ni le mode de multiplication ne coïncident. Ce n''est pas non plus un protozoaire, qui serait un animal unicellulaire, ni un virus, qui n''aurait aucune organisation cellulaire. Et la phrase n''est pas exacte : les quatre groupes de micro-organismes sont bien distincts.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6be8323-1727-5529-b909-6c6305de34d1', '4d10426c-9477-5321-8749-0ae925f7c072', 'Deux micro-organismes sont schématisés au microscope électronique. Le premier montre une capsule et du matériel génétique, sans cytoplasme. Le second montre un cytoplasme entouré d''une membrane cytoplasmique, dans lequel baigne un matériel génétique non délimité par une membrane, le tout entouré d''une paroi. Que sont-ils ?', '[{"id":"a","text":"Le premier est une bactérie, le second un virus"},{"id":"b","text":"Le premier est un virus, le second une bactérie"},{"id":"c","text":"Les deux sont des bactéries"},{"id":"d","text":"Les deux sont des protozoaires"}]'::jsonb, 'b', 'Le premier est formé d''un matériel génétique et d''une capsule, et ne renferme pas de cytoplasme : il n''a donc pas l''organisation d''une cellule — c''est un virus. Le second est constitué d''un cytoplasme entouré d''une membrane cytoplasmique, dans lequel baigne un matériel génétique non limité par une membrane, et d''une paroi : c''est une bactérie, et cette description est celle même d''une cellule procaryote ✓. Le piège courant est d''intervertir les deux, en croyant que le plus simple des schémas doit être la bactérie. Aucun des deux n''est un protozoaire : un protozoaire est un animal unicellulaire, à noyau entouré d''une membrane. Et les deux schémas ne peuvent pas représenter deux bactéries : le premier n''a même pas de cytoplasme.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '4d10426c-9477-5321-8749-0ae925f7c072', 'La paramécie et la bactérie sont toutes deux des micro-organismes unicellulaires. Qu''est-ce qui les sépare fondamentalement ?', '[{"id":"a","text":"La bactérie a un véritable noyau, la paramécie non"},{"id":"b","text":"La bactérie a un cytoplasme, la paramécie non"},{"id":"c","text":"La paramécie a un véritable noyau, la bactérie non"},{"id":"d","text":"La paramécie est visible à l''œil nu, la bactérie non"}]'::jsonb, 'c', 'La paramécie est un protozoaire, un animal unicellulaire dont le noyau est entouré d''une membrane : c''est une eucaryote. La bactérie, elle, n''a pas de véritable noyau — son matériel génétique baigne directement dans le cytoplasme : c''est une procaryote ✓. Être unicellulaire ne suffit donc pas à classer un microbe : c''est la présence ou l''absence d''un vrai noyau qui tranche. Attribuer le noyau à la bactérie inverse exactement les deux. Toutes deux ont un cytoplasme : c''est un constituant fondamental de toute cellule. Et aucune n''est visible à l''œil nu : ce sont des micro-organismes, observables seulement au microscope.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('83349456-85cd-5aac-998d-1ec9a6898925', '4d10426c-9477-5321-8749-0ae925f7c072', 'Le paludisme, la tuberculose, la teigne et la rage sont quatre maladies. À quels groupes de microbes appartiennent respectivement leurs agents ?', '[{"id":"a","text":"Protozoaire, bactérie, moisissure, virus"},{"id":"b","text":"Bactérie, protozoaire, virus, moisissure"},{"id":"c","text":"Virus, bactérie, protozoaire, moisissure"},{"id":"d","text":"Moisissure, virus, bactérie, protozoaire"}]'::jsonb, 'a', 'Le paludisme est dû à l''hématozoaire, un protozoaire ; la tuberculose au bacille de Koch, une bactérie ; la teigne au trichophyton, une moisissure ; et la rage au virus de la rage ✓. Chacun des quatre groupes a donc ses pathogènes — c''est ce qui rend le tableau microbe-maladie indispensable à mémoriser. Le nom du microbe est souvent le meilleur indice : « bacille » annonce une bactérie, la terminaison « -zoaire » un animal unicellulaire. Toutes les autres combinaisons proposées permutent au moins deux de ces quatre affectations.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '4d10426c-9477-5321-8749-0ae925f7c072', 'Une culture contient une seule bactérie au temps 0. Le milieu étant favorable, une division se produit toutes les 20 minutes. Combien y aura-t-il de bactéries deux heures après le temps 0 ?', '[{"id":"a","text":"6"},{"id":"b","text":"12"},{"id":"c","text":"32"},{"id":"d","text":"64"}]'::jsonb, 'd', 'Deux heures font 120 minutes, soit 6 × 20 minutes : il se produit donc 6 divisions. Or n divisions produisent 2ⁿ bactéries à partir d''une seule — d''où 2⁶ = 64 ✓. Répondre 6, c''est confondre le nombre de divisions avec le nombre de bactéries. Répondre 12, c''est doubler ce nombre de divisions, comme si chaque division n''ajoutait que deux bactéries au total : c''est croire la croissance proportionnelle au temps, alors qu''elle double à chaque étape. Et répondre 32, soit 2⁵, correspond à 5 divisions — le piège courant, qui consiste à en oublier une.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('38db394b-2177-5753-a9ab-d53a32e524ce', '4d10426c-9477-5321-8749-0ae925f7c072', 'Sur une observation microscopique réalisée au grossissement × 1000, une cellule de levure de bière mesure 8 mm. Quelle est sa taille réelle, et le résultat est-il cohérent avec les données du chapitre ?', '[{"id":"a","text":"0,8 μm — dix fois plus petit que l''intervalle annoncé"},{"id":"b","text":"8 μm — bien dans l''intervalle de 6 à 10 μm annoncé"},{"id":"c","text":"80 μm — dix fois plus grand que l''intervalle annoncé"},{"id":"d","text":"8 mm — soit la taille mesurée sur l''image elle-même"}]'::jsonb, 'b', 'La taille réelle est la taille mesurée divisée par le grossissement : 8 / 1000 = 0,008 mm. Or 1 μm vaut 1 millième de mm, donc 0,008 mm = 8 μm ✓ — et 8 μm tombe bien dans l''intervalle de 6 à 10 μm annoncé pour une cellule de levure : le calcul se vérifie lui-même. Répondre 8 mm, c''est oublier purement et simplement de diviser et rendre la taille mesurée sur l''image, ce qui ferait une levure visible à l''œil nu. Quant à 0,8 μm et 80 μm, ce sont les deux erreurs de conversion symétriques, d''un facteur 10 dans un sens ou dans l''autre — et c''est précisément l''intervalle 6 à 10 μm qui permet de les écarter sans hésiter.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'svt-1ere-sec'
      AND e.source = 'admin';
  END IF;
END $$;

