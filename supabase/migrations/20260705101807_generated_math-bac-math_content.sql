-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-bac-math (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-bac-math/
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
  ('math-bac-math', 'Mathématiques', 'Analyse, algèbre, géométrie et probabilités selon le programme officiel de la 4ème année secondaire — section Mathématiques (préparation au baccalauréat)', 'Force', 'subject-math', 'Calculator', 1, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = 'bac-math'))
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
      AND e.subject_id = 'math-bac-math'
      AND e.source = 'admin'
      AND q.id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-bac-math' AND source = 'admin' AND id NOT IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254');
DELETE FROM public.questions WHERE exercise_id IN ('b76771c5-32e7-5632-9794-9ec8095fa035', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', '75fc9ae9-900f-5c98-8207-baa94bff86af', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', '6f055244-7690-5d90-b279-8c0785ee7e44', '35d2cb52-661a-50a0-94d8-24590f6525d8', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'edb002de-0e7f-5b7c-8d12-039559657254') AND id NOT IN ('3af27c08-8da6-5667-ac15-1b0d4b924c04', '2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b74234c6-97b1-57c7-b21a-9698d89bddf7', '0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'd868bf9d-4d39-5d05-8c23-91e3dd50cbd4', '2bc732c3-ef84-593e-8141-28d56a59f5f7', 'aec4ec41-216a-51a3-b0a8-6a5820082cef', '1744bf0b-0591-5555-90c5-5a33930403c2', '4beea811-5dad-5080-a722-62a3185fc237', 'b9253cb3-c7fd-597d-9e5b-efdd4610721a', '0c9af287-fc69-5495-b1d8-05872e8f8300', 'a1682039-0438-5589-810c-7ce83d3f1190', '2adf3630-8ece-5043-a698-baa40822db13', 'cd689749-cc37-5719-9e5c-779dce1c6d54', '88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '45a47019-5722-586c-8211-35c6609f5eac', '95d862fa-6176-53ff-bd36-3a089be93947', '4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '0c567130-c4c9-5bbf-98af-48ac3fe35478', '55ae6f27-b3d2-53a0-95ac-3c1522b812bc', 'bc67fce0-14b0-512d-96fb-b200ad35fa3f', 'a85f9f3a-57c8-5528-b925-41cadd3ea008', 'e5f35d28-19b0-5807-adc2-cc42ca5e625e', 'bef7b52e-7113-5e25-b4c9-7943c27a365d', '0784b9f3-963c-5021-9ab6-bb87604c9d71', '5082a155-94a8-5525-b00f-b86ccd1cab10', '3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '28b2f193-675b-52ec-8354-09cf1e8a4a6b', '5f1d4834-8d38-5bfd-83f4-1428cc4074e4', 'a9ec4bb2-971b-548b-b872-47feb78de533', '746b0135-365a-5001-8259-05b772e9e1ea', 'ffdad216-1ab6-55cf-9736-9792be0fdf75', '1480bf16-37ba-5bcb-967d-c9869d882e43', '31a27502-0123-5cab-91c3-12dcc369cdf7', 'c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '2a65b201-ef6d-5532-b334-bef78c2e24f4', '34fd0348-7102-5b8a-8302-1b9577ab01e2', '7a149b92-97dd-545c-a583-5bf272b2eb7f', 'f010664a-2322-5b74-ab99-04ea17013ccc', '0d9998e1-142f-58b9-9112-2bf36321029f', '2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '269d83d5-c846-5358-a11b-055acb721037', '418ecd91-02f2-5e60-949a-4b77903ff934', '9808b350-e59e-5b03-8df4-156a48f6313b', '1782f429-e18c-5e6f-8bf9-0fc7f054cb33', '128b72a3-9efc-5a82-9e82-7eba9bc9714a', '99763050-35a1-58e9-bdcf-b2e5cd3f3758');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-bac-math' AND c.id NOT IN ('ce10c015-98c9-52df-8043-6cb82a6a402b') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', 'Continuité et limites — la porte de l''Analyse', 'Continuité en un point et sur un intervalle, opérations et composées, calcul de limites et formes indéterminées, théorèmes de comparaison et d''encadrement, asymptotes verticales et horizontales, image d''un intervalle, théorème des valeurs intermédiaires et son corollaire, prolongement par continuité et dichotomie', '# ⚔️ Continuité et limites — la porte de l''Analyse

> 💡 «Celui qui maîtrise les limites aperçoit l''infini ; celui qui maîtrise la continuité le traverse sans jamais tomber.»

Bienvenue dans l''année du concours, héros de la section Mathématiques. Ce chapitre ouvre le domaine de l''Analyse : dérivation, fonctions réciproques et calcul intégral s''appuieront sur les armes forgées ici. Tu consolides d''abord tes acquis de 3ème (limites usuelles, opérations), puis tu les dépasses : encadrements, composées, théorème des valeurs intermédiaires.

## 🏰 Continuité en un point et sur un intervalle

Soit f une fonction définie sur un intervalle ouvert contenant a. On dit que **f est continue en a** lorsque sa limite en a existe et vaut f(a) :

$$ lim x→a f(x) = f(a) $$

- **Continuité à droite** en a : lim x→a⁺ f(x) = f(a) ; **continuité à gauche** : lim x→a⁻ f(x) = f(a). f est continue en a si et seulement si elle est continue à droite **et** à gauche en a.
- f est **continue sur un intervalle I** lorsqu''elle est continue en tout point de I.
- **Fonctions usuelles** : les polynômes, les fonctions rationnelles (sur tout intervalle de leur ensemble de définition), x ↦ √x, x ↦ |x|, sin et cos sont continues là où elles sont définies.

## ⚡ Opérations et composées

Si f et g sont continues en a, alors **f + g**, **f × g** et, si g(a) ≠ 0, **f/g** sont continues en a.

> 🗡️ **Composée** : si v est continue en a et si u est continue en v(a), alors **u ∘ v est continue en a**. _Exemple_ : x ↦ √(x² + 1) est continue sur ℝ, car v : x ↦ x² + 1 est continue à valeurs dans [1 ; +∞[ et u = √ est continue sur [0 ; +∞[.

## 🔮 Limites et formes indéterminées

Les théorèmes d''opérations (somme, produit, quotient) concluent directement… sauf face aux **quatre formes indéterminées** : **∞ − ∞**, **0 × ∞**, **∞/∞** et **0/0**. Il faut alors transformer l''expression avant de conclure. Trois techniques majeures :

- **Terme de plus haut degré** (polynômes et fonctions rationnelles en ±∞) :

$$ lim x→+∞ (3x² − x + 1) = lim x→+∞ 3x² = +∞ $$

$$ lim x→+∞ (5x + 2)/(x − 4) = lim x→+∞ 5x/x = 5 $$

- **Factorisation** (forme 0/0 en un point) :

$$ lim x→2 (x² − 4)/(x − 2) = lim x→2 (x + 2) = 4 $$

- **Expression conjuguée** (radicaux) :

$$ lim x→+∞ (√(x² + 4x) − x) = lim x→+∞ 4x/(√(x² + 4x) + x) = 4/2 = 2 $$

- **Limite infinie en un point** : on étudie le **signe du dénominateur** de part et d''autre. _Exemple_ : lim x→2⁺ 1/(x − 2) = +∞ et lim x→2⁻ 1/(x − 2) = −∞.

> ⚠️ Le piège mortel : remplacer un morceau d''une forme indéterminée par sa limite («√(x² + 4x) se comporte comme x, donc la différence tend vers 0») est une opération **illégale**. On transforme l''expression entière, puis seulement on conclut.

## 🛡️ Comparaison, encadrement et limite d''une composée

- **Comparaison** : si f(x) ≥ u(x) au voisinage de +∞ et si lim x→+∞ u(x) = +∞, alors lim x→+∞ f(x) = +∞ (énoncé analogue vers −∞ avec une majoration).
- **Théorème des gendarmes** : si u(x) ≤ f(x) ≤ v(x) au voisinage de +∞ et si lim u = lim v = ℓ, alors lim x→+∞ f(x) = ℓ. _Exemple_ : pour x > 0, −1/x ≤ (sin x)/x ≤ 1/x, donc lim x→+∞ (sin x)/x = 0. (Rappel de 3ème, toujours admis : lim x→0 (sin x)/x = 1.)
- **Limite d''une composée** : si lim x→a v(x) = b et si lim y→b u(y) = ℓ, alors lim x→a u(v(x)) = ℓ. _Exemple_ : lim x→+∞ √(4 + 1/x) = √4 = 2, car 4 + 1/x → 4 et √ est continue en 4.

## 📐 Asymptotes verticales et horizontales

- Si lim x→a f(x) = +∞ ou −∞ (même seulement à droite ou à gauche de a), la droite d''équation **x = a** est une **asymptote verticale** de la courbe.
- Si lim x→+∞ f(x) = ℓ (ou en −∞), la droite d''équation **y = ℓ** est une **asymptote horizontale**.
- _Exemple_ : pour f(x) = (2x + 1)/(x − 3), la courbe admet l''asymptote verticale x = 3 (le dénominateur s''annule en 3) et l''asymptote horizontale y = 2 (termes dominants 2x/x).

> ⚠️ Ne confonds jamais les deux : une asymptote **verticale** a une équation en **x = …** (limite infinie en un point), une **horizontale** a une équation en **y = …** (limite finie à l''infini). L''asymptote oblique et l''étude complète des branches infinies appartiennent au chapitre «étude de fonctions» — plus tard dans ta quête.

## 🧮 Image d''un intervalle et théorème des valeurs intermédiaires

- L''**image d''un intervalle par une fonction continue est un intervalle** ; l''image du segment [a ; b] est le segment **[m ; M]**, où m est le minimum et M le maximum de f sur [a ; b] — et **pas forcément [f(a) ; f(b)]**.
- **Théorème des valeurs intermédiaires (TVI)** : si f est continue sur [a ; b], alors pour tout réel k compris entre f(a) et f(b), l''équation f(x) = k admet **au moins une** solution dans [a ; b].
- Cas clé : si f est continue sur [a ; b] et f(a) · f(b) < 0, alors f **s''annule au moins une fois** sur [a ; b].
- **Corollaire (bijection)** : si f est continue **et strictement monotone** sur [a ; b], alors pour tout k compris entre f(a) et f(b), l''équation f(x) = k admet une **unique** solution dans [a ; b].

> 🗡️ Sans la dérivée à ton arc (elle arrive dans deux chapitres), la stricte monotonie se justifie par les fonctions usuelles et les opérations : une somme de fonctions strictement croissantes est strictement croissante.

_Exemple_ : f(x) = x³ + x − 3 est continue et strictement croissante sur [1 ; 2] (somme de x ↦ x³ et de x ↦ x − 3, toutes deux strictement croissantes) ; f(1) = −1 < 0 < f(2) = 7, donc l''équation f(x) = 0 admet une **unique** solution α dans [1 ; 2].

## 🧪 Prolongement par continuité et dichotomie

- **Prolongement par continuité** : si f n''est pas définie en a mais si lim x→a f(x) = ℓ avec ℓ **fini**, la fonction g définie par g(x) = f(x) pour x ≠ a et g(a) = ℓ est continue en a : c''est le prolongement par continuité de f en a. _Exemple_ : f(x) = (√(x + 1) − 1)/x n''est pas définie en 0 ; l''expression conjuguée donne f(x) = 1/(√(x + 1) + 1), donc lim x→0 f(x) = 1/2 : f se prolonge par continuité en 0 en posant g(0) = 1/2.
- **Dichotomie (balayage)** : pour encadrer la solution α de f(x) = 0 sur [a ; b], on calcule f au milieu c = (a + b)/2 et on garde la moitié où f change de signe. Chaque étape divise la longueur de l''intervalle par 2 ; on poursuit jusqu''à obtenir une **valeur approchée à 10⁻ⁿ près**. _Exemple_ : pour f(x) = x³ + x − 3, on a f(1) = −1 < 0 et f(1,5) = 1,875 > 0, donc α ∈ ]1 ; 1,5[.

> 🏆 Première porte franchie, héros : tu sais dompter l''infini, lever les indéterminations et capturer les solutions à la précision voulue. Les suites réelles t''attendent au prochain chapitre — l''Analyse ne fait que commencer.', '# 📜 Résumé : Continuité et limites

- **Continuité en a** : lim x→a f(x) = f(a) ; continuité à droite et à gauche ; f continue sur I = continue en tout point de I ; polynômes, fonctions rationnelles, √, |x|, sin et cos sont continues sur leur domaine.
- **Opérations** : somme, produit, quotient (dénominateur non nul) et composée u ∘ v de fonctions continues sont continues.
- **Formes indéterminées** : ∞ − ∞, 0 × ∞, ∞/∞, 0/0 → transformer avant de conclure : terme de plus haut degré, factorisation, expression conjuguée ; limite infinie en un point : étudier le signe du dénominateur de part et d''autre.
- **Gendarmes** : u ≤ f ≤ v et lim u = lim v = ℓ ⇒ lim f = ℓ ; théorèmes de comparaison pour les limites infinies ; **composée** : lim x→a v(x) = b et lim y→b u(y) = ℓ ⇒ lim x→a u(v(x)) = ℓ.
- **Asymptotes** : limite infinie en un point a ⇒ verticale x = a ; limite finie ℓ en ±∞ ⇒ horizontale y = ℓ (l''asymptote oblique relève du chapitre étude de fonctions).
- **Image d''un intervalle** : l''image de [a ; b] par f continue est [m ; M] (minimum ; maximum), pas forcément [f(a) ; f(b)].
- **TVI** : f continue sur [a ; b] et k compris entre f(a) et f(b) ⇒ f(x) = k admet au moins une solution ; f(a) · f(b) < 0 ⇒ f s''annule au moins une fois.
- **Corollaire de la bijection** : f continue **et strictement monotone** ⇒ solution unique (l''unicité exige la stricte monotonie, jamais le TVI seul).
- **Prolongement par continuité** : lim x→a f(x) = ℓ fini ⇒ g égale à f hors de a avec g(a) = ℓ est continue en a.
- **Dichotomie** : couper [a ; b] au milieu, garder la moitié où f change de signe → valeur approchée de α à 10⁻ⁿ près.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b76771c5-32e7-5632-9794-9ec8095fa035', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', 'Test de compréhension ⭐ : Continuité et limites', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3af27c08-8da6-5667-ac15-1b0d4b924c04', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Soit f une fonction définie sur un intervalle ouvert contenant a. Par définition, f est continue en a lorsque :', '[{"id":"a","text":"lim x→a f(x) = f(a)"},{"id":"b","text":"f(a) existe"},{"id":"c","text":"lim x→a f(x) existe"},{"id":"d","text":"f est définie au voisinage de a"}]'::jsonb, 'a', 'Par définition, f est continue en a lorsque la limite de f en a existe et est égale à f(a) : lim x→a f(x) = f(a). L''existence de f(a) seule, ou d''une limite seule, ne suffit pas — il faut l''égalité entre les deux.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2de2d061-27ca-57d5-9fb5-aed7959a337b', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Au cours d''un calcul de limites, laquelle de ces situations est une forme indéterminée ?', '[{"id":"a","text":"La somme de deux limites égales à +∞"},{"id":"b","text":"La différence de deux limites égales à +∞"},{"id":"c","text":"Le produit d''une limite nulle par une limite finie"},{"id":"d","text":"Le quotient d''une limite finie par une limite infinie"}]'::jsonb, 'b', 'La différence de deux limites infinies de même signe est la forme indéterminée ∞ − ∞ : on ne peut pas conclure sans transformer l''expression. En revanche, ∞ + ∞ donne +∞, un produit 0 × ℓ (ℓ fini) donne 0 et un quotient fini/infini donne 0.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b74234c6-97b1-57c7-b21a-9698d89bddf7', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'Une fonction f vérifie lim x→3 f(x) = +∞. Que peut-on en déduire pour la courbe de f ?', '[{"id":"a","text":"La droite d''équation y = 3 est une asymptote horizontale"},{"id":"b","text":"La droite d''équation y = 0 est une asymptote horizontale"},{"id":"c","text":"La droite d''équation x = 3 est une asymptote horizontale"},{"id":"d","text":"La droite d''équation x = 3 est une asymptote verticale"}]'::jsonb, 'd', 'Une limite infinie en un point a se traduit par une asymptote verticale d''équation x = a : ici, lim x→3 f(x) = +∞ donne l''asymptote verticale x = 3. Une asymptote horizontale correspondrait à une limite finie en +∞ ou en −∞, ce qui n''est pas la situation décrite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0776bd6e-4d92-5b2c-91dd-4748d71e1ec0', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'f est une fonction continue sur le segment [a ; b]. Quelle est l''image de [a ; b] par f ?', '[{"id":"a","text":"Le segment [f(a) ; f(b)], où f(a) et f(b) sont les valeurs aux bornes"},{"id":"b","text":"Un intervalle ouvert contenant f(a) et f(b)"},{"id":"c","text":"Le segment [m ; M], où m et M sont le minimum et le maximum de f"},{"id":"d","text":"L''ensemble ℝ tout entier, dès que f n''est pas constante"}]'::jsonb, 'c', 'L''image du segment [a ; b] par une fonction continue est le segment [m ; M], où m et M sont le minimum et le maximum de f sur [a ; b]. Ce n''est pas forcément [f(a) ; f(b)] : le maximum ou le minimum peut être atteint à l''intérieur de l''intervalle, pas aux bornes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d868bf9d-4d39-5d05-8c23-91e3dd50cbd4', 'b76771c5-32e7-5632-9794-9ec8095fa035', 'La fonction f définie par f(x) = (√(x + 1) − 1)/x n''est pas définie en 0. Quelle valeur donner à g(0) pour prolonger f par continuité en 0 ?', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"1"},{"id":"d","text":"2"}]'::jsonb, 'b', 'Avec l''expression conjuguée, (√(x + 1) − 1)/x = 1/(√(x + 1) + 1), qui tend vers 1/2 quand x tend vers 0. On pose donc g(0) = 1/2 : c''est le prolongement par continuité de f en 0, exactement comme dans le cours.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐ Exercice : Premières armes — limites et continuité', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bc732c3-ef84-593e-8141-28d56a59f5f7', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→2 (3x² − 5).', '[{"id":"a","text":"1"},{"id":"b","text":"7"},{"id":"c","text":"12"},{"id":"d","text":"17"}]'::jsonb, 'b', 'Un polynôme est continu sur ℝ : la limite s''obtient en remplaçant x par 2. lim x→2 (3x² − 5) = 3 × 2² − 5 = 12 − 5 = 7 ✓. Répondre 12 revient à oublier le − 5, 1 provient du calcul 3 × 2 − 5 où le carré a été oublié, et 17 d''une erreur de signe (12 + 5).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aec4ec41-216a-51a3-b0a8-6a5820082cef', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→+∞ (−2x³ + 5x² − 7).', '[{"id":"a","text":"−∞"},{"id":"b","text":"−2"},{"id":"c","text":"0"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'Le comportement d''un polynôme en ±∞ est dicté par son terme de plus haut degré : lim x→+∞ (−2x³ + 5x² − 7) = lim x→+∞ (−2x³) = −∞, car le coefficient dominant −2 est négatif. Répondre +∞ revient à ignorer ce signe (ou à regarder 5x²), et −2 confond la limite avec le coefficient dominant.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1744bf0b-0591-5555-90c5-5a33930403c2', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→+∞ (3x + 1)/(x + 2).', '[{"id":"a","text":"0"},{"id":"b","text":"1/2"},{"id":"c","text":"3"},{"id":"d","text":"+∞"}]'::jsonb, 'c', 'Pour une fonction rationnelle en +∞, on garde les termes de plus haut degré : (3x + 1)/(x + 2) se comporte comme 3x/x = 3, donc la limite vaut 3 ✓. Répondre 1/2 revient à prendre le rapport des constantes, et +∞ à laisser la forme ∞/∞ sans la lever.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4beea811-5dad-5080-a722-62a3185fc237', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Soit f la fonction définie par f(x) = (x² − 9)/(x − 3) si x ≠ 3, et f(3) = m. Pour quelle valeur de m la fonction f est-elle continue en 3 ?', '[{"id":"a","text":"m = 0"},{"id":"b","text":"m = 6"},{"id":"c","text":"m = 9"},{"id":"d","text":"Aucune valeur de m ne convient"}]'::jsonb, 'b', 'Pour x ≠ 3, (x² − 9)/(x − 3) = ((x − 3)(x + 3))/(x − 3) = x + 3, donc lim x→3 f(x) = 6 : f est continue en 3 si et seulement si m = 6 ✓. Répondre 9 revient à ne calculer que x² en 3, 0 provient de la simplification fautive en x − 3, et la forme 0/0 n''est pas une impasse : elle se lève par factorisation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9253cb3-c7fd-597d-9e5b-efdd4610721a', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Soit f(x) = (3x − 1)/(x + 2). La courbe de f admet une asymptote verticale : laquelle ?', '[{"id":"a","text":"La droite d''équation x = −2"},{"id":"b","text":"La droite d''équation x = 2"},{"id":"c","text":"La droite d''équation x = 3"},{"id":"d","text":"La droite d''équation y = 3"}]'::jsonb, 'a', 'Le dénominateur x + 2 s''annule en x = −2 (et le numérateur y vaut −7 ≠ 0), donc les limites de f en −2 sont infinies : la droite d''équation x = −2 est l''asymptote verticale ✓. Répondre x = 2 est une erreur de signe en résolvant x + 2 = 0, x = 3 lit le coefficient du numérateur, et y = 3 est l''asymptote horizontale — une limite finie à l''infini, pas une limite infinie en un point.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c9af287-fc69-5495-b1d8-05872e8f8300', '8ba9a0ec-cf1a-5db5-88d1-f8622d3cae0f', 'Calculer lim x→3⁺ 1/(x − 3).', '[{"id":"a","text":"−∞"},{"id":"b","text":"0"},{"id":"c","text":"3"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'Quand x → 3⁺, le dénominateur x − 3 tend vers 0 en restant strictement positif, donc 1/(x − 3) → +∞ ✓. Une erreur d''étude de signe donnerait −∞ (qui est en réalité la limite à gauche), 0 confond avec la limite en +∞, et 3 confond la valeur vers laquelle tend x avec la limite de f.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('75fc9ae9-900f-5c98-8207-baa94bff86af', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⚔️ Boss du chapitre ⭐⭐⭐ : Le gardien du seuil', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1682039-0438-5589-810c-7ce83d3f1190', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (√(x + 3) − 2)/(x − 1). Peut-on prolonger f par continuité en 1 ?', '[{"id":"a","text":"Oui, en posant f(1) = 0"},{"id":"b","text":"Oui, en posant f(1) = 1/4"},{"id":"c","text":"Oui, en posant f(1) = 1/2"},{"id":"d","text":"Non, f n''est pas prolongeable en 1"}]'::jsonb, 'b', 'En 1, numérateur et dénominateur s''annulent (√4 − 2 = 0) : forme 0/0. Expression conjuguée : (√(x + 3) − 2)(√(x + 3) + 2) = x + 3 − 4 = x − 1, donc f(x) = (x − 1)/((x − 1)(√(x + 3) + 2)) = 1/(√(x + 3) + 2), qui tend vers 1/(2 + 2) = 1/4 quand x → 1 ✓. La limite étant finie, f se prolonge avec f(1) = 1/4. Le piège courant : oublier le terme + 2 du conjugué au dénominateur donne 1/2 ; traiter 0/0 comme nul donne 0 ; et une forme 0/0 n''interdit pas le prolongement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2adf3630-8ece-5043-a698-baa40822db13', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Une fonction f vérifie, pour tout x > 0 : (2x − 1)/x ≤ f(x) ≤ (2x + 3)/x. Déterminer lim x→+∞ f(x).', '[{"id":"a","text":"−1"},{"id":"b","text":"0"},{"id":"c","text":"2"},{"id":"d","text":"3"}]'::jsonb, 'c', '(2x − 1)/x = 2 − 1/x tend vers 2, et (2x + 3)/x = 2 + 3/x tend vers 2. Les deux gendarmes ayant la même limite, le théorème des gendarmes donne lim x→+∞ f(x) = 2 ✓. Le piège courant : répondre −1 ou 3 en lisant les constantes des numérateurs, ou 0 en croyant que les termes en 1/x dictent la limite — ils tendent vers 0, mais s''ajoutent à 2.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd689749-cc37-5719-9e5c-779dce1c6d54', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Déterminer lim x→+∞ (3x + sin x)/x.', '[{"id":"a","text":"3"},{"id":"b","text":"4"},{"id":"c","text":"+∞"},{"id":"d","text":"Cette limite n''existe pas, car sin x n''a pas de limite en +∞"}]'::jsonb, 'a', 'Pour x > 0, −1 ≤ sin x ≤ 1 donne l''encadrement (3x − 1)/x ≤ (3x + sin x)/x ≤ (3x + 1)/x. Les deux bornes tendent vers 3, donc la limite vaut 3 ✓ (théorème des gendarmes, avec sin x/x → 0). Le piège courant : conclure que la limite n''existe pas parce que sin x oscille — l''encadrement neutralise l''oscillation. Répondre 4 fige sin x à sa valeur maximale 1, et +∞ oublie la division par x.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88970c96-0cf0-5c3a-b1b5-3e0a3bf71ff8', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Pour calculer lim x→+∞ (√(4x² + x) − 2x), un élève rédige :
① √(4x² + x) → +∞ et 2x → +∞ : forme indéterminée du type ∞ − ∞.
② Pour x > 0, √(4x² + x) = x√(4 + 1/x).
③ Comme √(4 + 1/x) → 2, l''expression devient x × 2 − 2x = 0.
④ Conclusion : la limite vaut 0.
Dans quelle étape se cache l''erreur ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : dans une forme indéterminée, on n''a pas le droit de remplacer un morceau de l''expression (√(4 + 1/x)) par sa limite avant de conclure — c''est une levée illégale de l''indétermination. Les étapes ① et ② sont exactes, et ④ ne fait que suivre ③. Calcul correct par le conjugué : √(4x² + x) − 2x = (4x² + x − 4x²)/(√(4x² + x) + 2x) = x/(√(4x² + x) + 2x) = 1/(√(4 + 1/x) + 2), qui tend vers 1/4 ✓. La conclusion 0 de l''élève est donc fausse : c''est bien sa démarche qu''il fallait invalider.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45a47019-5722-586c-8211-35c6609f5eac', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'On considère l''affirmation : « Si f est continue sur [a ; b] et f(a) · f(b) < 0, alors l''équation f(x) = 0 admet une unique solution dans [a ; b]. » Cette affirmation est-elle vraie ou fausse ?', '[{"id":"a","text":"Vraie : le théorème des valeurs intermédiaires garantit à la fois l''existence et l''unicité de la solution"},{"id":"b","text":"Vraie : f(a) et f(b) étant de signes contraires, la courbe ne peut couper l''axe des abscisses qu''une seule fois"},{"id":"c","text":"Fausse : le théorème des valeurs intermédiaires exige f(a) · f(b) > 0"},{"id":"d","text":"Fausse : sans stricte monotonie, f peut s''annuler plusieurs fois sur [a ; b]"}]'::jsonb, 'd', 'L''affirmation est fausse ✓ : la continuité et le changement de signe garantissent au moins une annulation (TVI), mais jamais l''unicité — une fonction qui oscille peut couper l''axe des abscisses trois fois entre a et b. L''unicité exige en plus la stricte monotonie (corollaire de la bijection). Le piège courant : croire que le TVI livre existence et unicité d''un coup ; et le TVI demande bien des signes contraires, pas f(a) · f(b) > 0.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95d862fa-6176-53ff-bd36-3a089be93947', '75fc9ae9-900f-5c98-8207-baa94bff86af', 'Soit f(x) = x³ + x − 5. f est continue et strictement croissante sur [1 ; 2] (somme de fonctions strictement croissantes), avec f(1) = −3 et f(2) = 5 : l''équation f(x) = 0 admet donc une unique solution α dans [1 ; 2]. On calcule f(1,5) = −0,125. Dans quel intervalle se trouve α ?', '[{"id":"a","text":"]1 ; 1,5["},{"id":"b","text":"]1,5 ; 2["},{"id":"c","text":"α est exactement égal à 1,5"},{"id":"d","text":"On ne peut pas conclure avec ces informations"}]'::jsonb, 'b', 'f(1,5) = 1,5³ + 1,5 − 5 = 3,375 + 1,5 − 5 = −0,125 < 0, et f(2) = 5 > 0 : le changement de signe se produit entre 1,5 et 2, donc α ∈ ]1,5 ; 2[ ✓ (la stricte croissance garantit l''unicité). Le piège courant : une erreur de signe sur f(1,5) envoie vers ]1 ; 1,5[ ; le milieu 1,5 n''est pas la solution puisque f(1,5) ≠ 0 ; et un seul pas de dichotomie suffit bel et bien à conclure.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '⭐⭐ Révision (type examen) : Lever les indéterminations', 2, 75, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4337735e-f0b8-5728-9de4-ed3c19b9f7fd', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ (x² − x).', '[{"id":"a","text":"−∞"},{"id":"b","text":"0"},{"id":"c","text":"1"},{"id":"d","text":"+∞"}]'::jsonb, 'd', 'Face à la forme indéterminée ∞ − ∞, on factorise le terme dominant : x² − x = x²(1 − 1/x). Comme x² → +∞ et 1 − 1/x → 1, la limite vaut +∞ ✓. Répondre 0 revient à lever illégalement la forme ∞ − ∞ en « annulant » les deux infinis, 1 s''arrête à la limite de la parenthèse, et −∞ prend le signe du terme −x.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c567130-c4c9-5bbf-98af-48ac3fe35478', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→2 (x² − 4)/(x² − 3x + 2).', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"4/3"},{"id":"d","text":"4"}]'::jsonb, 'd', 'Forme 0/0 en 2 : on factorise. x² − 4 = (x − 2)(x + 2) et x² − 3x + 2 = (x − 2)(x − 1), donc le quotient vaut (x + 2)/(x − 1) pour x ≠ 2, qui tend vers 4/1 = 4 ✓. Répondre 1 revient à croire que 0/0 vaut toujours 1, 4/3 provient d''une factorisation fautive du dénominateur en (x − 2)(x + 1), et 0 traite 0/0 comme nul.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55ae6f27-b3d2-53a0-95ac-3c1522b812bc', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ (√(x² + 6x) − x).', '[{"id":"a","text":"0"},{"id":"b","text":"3"},{"id":"c","text":"6"},{"id":"d","text":"+∞"}]'::jsonb, 'b', 'Forme ∞ − ∞ : on multiplie par l''expression conjuguée. √(x² + 6x) − x = (x² + 6x − x²)/(√(x² + 6x) + x) = 6x/(√(x² + 6x) + x) = 6/(√(1 + 6/x) + 1), qui tend vers 6/2 = 3 ✓. Répondre 6 oublie que le dénominateur tend vers 2, 0 lève illégalement la forme ∞ − ∞, et +∞ compare mal les deux termes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc67fce0-14b0-512d-96fb-b200ad35fa3f', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'Calculer lim x→+∞ √((4x² + 1)/(x² + 1)).', '[{"id":"a","text":"2"},{"id":"b","text":"4"},{"id":"c","text":"16"},{"id":"d","text":"+∞"}]'::jsonb, 'a', 'Limite d''une composée : la fonction intérieure (4x² + 1)/(x² + 1) tend vers 4 (termes de plus haut degré), et √ est continue en 4, donc la limite vaut √4 = 2 ✓. Répondre 4 oublie d''appliquer la racine (composée incomplète), 16 élève au carré au lieu de prendre la racine, et +∞ laisse la forme ∞/∞ non levée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a85f9f3a-57c8-5528-b925-41cadd3ea008', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'La fonction f définie par f(x) = (x² − 25)/(x − 5) n''est pas définie en 5. Est-elle prolongeable par continuité en 5 ?', '[{"id":"a","text":"Oui, en posant f(5) = 0"},{"id":"b","text":"Oui, en posant f(5) = 5"},{"id":"c","text":"Oui, en posant f(5) = 10"},{"id":"d","text":"Non, f n''est pas prolongeable en 5"}]'::jsonb, 'c', 'Pour x ≠ 5, (x² − 25)/(x − 5) = ((x − 5)(x + 5))/(x − 5) = x + 5, qui tend vers 10 quand x → 5. La limite est finie : f se prolonge par continuité en 5 en posant f(5) = 10 ✓. Répondre 5 confond la valeur du prolongement avec le point, 0 traite 0/0 comme nul, et la forme 0/0 n''empêche pas le prolongement — elle se lève par factorisation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f35d28-19b0-5807-adc2-cc42ca5e625e', '828d0edf-6c8c-52f5-9f74-eb0a9d37f5a7', 'f est une fonction continue sur [1 ; 2] avec f(1) = −2 et f(2) = 1. Que peut-on affirmer, d''après le théorème des valeurs intermédiaires, pour l''équation f(x) = 0 ?', '[{"id":"a","text":"Elle admet au moins une solution dans [1 ; 2]"},{"id":"b","text":"Elle admet exactement une solution dans [1 ; 2]"},{"id":"c","text":"Elle n''admet aucune solution dans [1 ; 2]"},{"id":"d","text":"Sa solution est exactement x = 1,5"}]'::jsonb, 'a', 'f est continue sur [1 ; 2] et 0 est compris entre f(1) = −2 et f(2) = 1 : le TVI garantit au moins une solution dans [1 ; 2] ✓. Il ne garantit jamais l''unicité : il faudrait en plus la stricte monotonie (corollaire de la bijection), qui n''est pas donnée ici. Quant à 1,5, ce n''est que le milieu de l''intervalle, pas une solution certifiée.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6f055244-7690-5d90-b279-8c0785ee7e44', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '👑 Défi élite ⭐⭐⭐⭐ : L''épreuve du bachelier', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bef7b52e-7113-5e25-b4c9-7943c27a365d', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Soit a un réel et f la fonction définie pour x ≠ 2 par f(x) = (x² + ax − 6)/(x − 2). Déterminer la valeur de a pour laquelle f est prolongeable par continuité en 2, puis la valeur f(2) de ce prolongement.', '[{"id":"a","text":"a = −1 et f(2) = 5"},{"id":"b","text":"a = 1 et f(2) = 2"},{"id":"c","text":"a = 1 et f(2) = 5"},{"id":"d","text":"a = 2 et f(2) = 6"}]'::jsonb, 'c', 'Pour que la limite en 2 soit finie, le numérateur doit s''annuler en 2 : 2² + 2a − 6 = 0, soit 2a = 2, donc a = 1 ✓. Alors x² + x − 6 = (x − 2)(x + 3), donc f(x) = x + 3 pour x ≠ 2, et f(2) = lim x→2 f(x) = 5 ✓. Vérification : 2² + 2 − 6 = 0 ✓. L''erreur classique : une faute de signe dans le terme 2a donne a = −1 (le numérateur ne s''annule alors plus en 2, la limite est infinie) ; lire ax comme a donne a = 2 ; et f(2) = 2 confond la valeur du prolongement avec le point x = 2.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0784b9f3-963c-5021-9ab6-bb87604c9d71', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Une fonction g est continue sur [0 ; 4], avec g(0) = 3 et g(4) = −1. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée ?', '[{"id":"a","text":"L''équation g(x) = 0 admet au moins une solution dans [0 ; 4]"},{"id":"b","text":"L''équation g(x) = 0 admet exactement une solution dans [0 ; 4]"},{"id":"c","text":"L''équation g(x) = 4 admet au moins une solution dans [0 ; 4]"},{"id":"d","text":"g est strictement décroissante sur [0 ; 4]"}]'::jsonb, 'a', '0 est compris entre g(4) = −1 et g(0) = 3 : le théorème des valeurs intermédiaires garantit au moins une solution de g(x) = 0 dans [0 ; 4] ✓. L''erreur classique : conclure à une solution unique — l''unicité exigerait la stricte monotonie (corollaire de la bijection), non fournie ici ; de même, g(0) > g(4) n''implique pas que g décroît sur tout l''intervalle. Enfin, 4 n''est pas compris entre −1 et 3 : le TVI ne dit rien de l''équation g(x) = 4 (piège de l''encadrement de k oublié).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5082a155-94a8-5525-b00f-b86ccd1cab10', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Une fonction h vérifie, pour tout x ≥ 1 : 2 − 1/x ≤ h(x) ≤ 2 + 1/x². Déterminer lim x→+∞ √(h(x) + 7).', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"9"},{"id":"d","text":"On ne peut pas déterminer cette limite avec ces informations"}]'::jsonb, 'b', 'Étape 1 : 2 − 1/x → 2 et 2 + 1/x² → 2, donc lim x→+∞ h(x) = 2 par le théorème des gendarmes ✓. Étape 2 : h(x) + 7 → 9. Étape 3 : √ est continue en 9, donc lim x→+∞ √(h(x) + 7) = √9 = 3 ✓. L''erreur classique : oublier la fonction extérieure et s''arrêter à 9 (voire à la limite 2 de h) ; et croire que les gendarmes ne s''appliquent pas quand les deux bornes sont des expressions différentes — seule compte l''égalité de leurs limites.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ad8eb1e-b249-5906-9fa2-664cb5adb4dc', '6f055244-7690-5d90-b279-8c0785ee7e44', 'L''affirmation suivante est fausse : « Toute fonction f définie sur [−1 ; 1] telle que f(−1) · f(1) < 0 s''annule au moins une fois sur [−1 ; 1]. » Quelle fonction en fournit un contre-exemple ?', '[{"id":"a","text":"f(x) = x pour tout x de [−1 ; 1]"},{"id":"b","text":"f(x) = x² + 1 pour tout x de [−1 ; 1]"},{"id":"c","text":"f(x) = |x| pour x ≠ 0, et f(0) = −1"},{"id":"d","text":"f(x) = 1/x pour x ≠ 0, et f(0) = 1"}]'::jsonb, 'd', 'Pour f(x) = 1/x avec f(0) = 1 : f(−1) · f(1) = (−1) × 1 = −1 < 0, et pourtant f ne s''annule jamais (1/x ≠ 0 pour x ≠ 0, et f(0) = 1) — l''hypothèse est vérifiée mais la conclusion échoue : contre-exemple valide ✓. C''est la discontinuité en 0 qui rend le TVI inapplicable. L''erreur classique : proposer une fonction qui ne vérifie pas l''hypothèse — pour x² + 1 on a f(−1) · f(1) = 2 × 2 = 4 > 0, et pour la fonction en |x| on a 1 × 1 = 1 > 0 — ou une fonction comme f(x) = x, qui s''annule et confirme l''affirmation au lieu de la contredire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28b2f193-675b-52ec-8354-09cf1e8a4a6b', '6f055244-7690-5d90-b279-8c0785ee7e44', 'f est continue et strictement croissante sur [−2 ; 3], avec f(−2) = −4 et f(3) = 6. Pour quelles valeurs du réel k l''équation f(x) = k admet-elle exactement une solution dans [−2 ; 3] ?', '[{"id":"a","text":"k ∈ [−2 ; 3]"},{"id":"b","text":"k ∈ ]−4 ; 6["},{"id":"c","text":"k ∈ [−4 ; 6]"},{"id":"d","text":"k ∈ ℝ"}]'::jsonb, 'c', 'f étant continue et strictement croissante sur [−2 ; 3], elle réalise une bijection de [−2 ; 3] sur [f(−2) ; f(3)] = [−4 ; 6] : chaque k de [−4 ; 6] est atteint exactement une fois ✓ (corollaire du TVI). Les bornes sont incluses : k = −4 donne la solution x = −2 et k = 6 donne x = 3. L''erreur classique : exclure les bornes en répondant ]−4 ; 6[, confondre l''intervalle de départ [−2 ; 3] avec l''image, ou croire qu''une fonction strictement croissante atteint tout réel k.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f1d4834-8d38-5bfd-83f4-1428cc4074e4', '6f055244-7690-5d90-b279-8c0785ee7e44', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (√(x² + 3) − 2)/(x − 1). Déterminer la valeur du prolongement par continuité de f en 1, puis l''asymptote horizontale de la courbe de f en +∞.', '[{"id":"a","text":"f(1) = 0 et asymptote y = 1"},{"id":"b","text":"f(1) = 1/4 et asymptote y = 1"},{"id":"c","text":"f(1) = 1/2 et asymptote y = 0"},{"id":"d","text":"f(1) = 1/2 et asymptote y = 1"}]'::jsonb, 'd', 'En 1 : √(1 + 3) − 2 = 0, forme 0/0. Expression conjuguée : (x² + 3 − 4)/((x − 1)(√(x² + 3) + 2)) = (x² − 1)/((x − 1)(√(x² + 3) + 2)) = (x + 1)/(√(x² + 3) + 2), qui tend vers 2/4 = 1/2 quand x → 1 ✓, donc f(1) = 1/2. En +∞ : en divisant numérateur et dénominateur par x, f(x) = (√(1 + 3/x²) − 2/x)/(1 − 1/x), qui tend vers 1/1 = 1, d''où l''asymptote horizontale y = 1 ✓. L''erreur classique : après simplification par (x − 1), oublier le facteur (x + 1) au numérateur donne 1/4 ; traiter 0/0 comme nul donne 0 ; et croire que tout quotient tend vers 0 en +∞ fabrique l''asymptote fantôme y = 0.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35d2cb52-661a-50a0-94d8-24590f6525d8', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🧩 Mission interactive ⭐ : L''atelier de l''apprenti analyste', 1, 50, 10, 'practice', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9ec4bb2-971b-548b-b872-47feb78de533', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Texte à trous — complète l''énoncé du théorème des gendarmes vu en cours :
« Si u(x) ≤ f(x) ≤ v(x) au voisinage de +∞ et si ____, alors lim x→+∞ f(x) = ℓ. »', '[{"id":"a","text":"lim x→+∞ u(x) = ℓ"},{"id":"b","text":"lim x→+∞ u(x) = lim x→+∞ v(x) = ℓ"},{"id":"c","text":"lim x→+∞ u(x) = +∞"},{"id":"d","text":"u et v sont continues sur ℝ"}]'::jsonb, 'b', 'Le théorème des gendarmes exige que les deux encadrants tendent vers la même limite finie : lim x→+∞ u(x) = lim x→+∞ v(x) = ℓ ✓. Avec la seule condition lim u = ℓ, f pourrait s''échapper vers le haut, rien ne la retient. La condition lim u = +∞ relève du théorème de comparaison, qui conclut à une limite infinie, pas à ℓ. Quant à la continuité de u et v, elle ne figure nulle part dans les hypothèses du théorème.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('746b0135-365a-5001-8259-05b772e9e1ea', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Appariement — associe chaque forme indéterminée (①②③) à la technique de levée adaptée (a, b, c, d) :
① lim x→+∞ (√(x² + x) − x), forme ∞ − ∞ avec un radical
② lim x→5 (x² − 4x − 5)/(x − 5), forme 0/0 en un point
③ lim x→−∞ (7x³ + x)/(2x³ − 1), forme ∞/∞ d''une fonction rationnelle
a. multiplier par l''expression conjuguée
b. factoriser puis simplifier par (x − 5)
c. comparer les termes de plus haut degré
d. remplacer chaque morceau par sa limite
Quel appariement est entièrement correct ?', '[{"id":"a","text":"①-a · ②-b · ③-c"},{"id":"b","text":"①-a · ②-c · ③-b"},{"id":"c","text":"①-b · ②-a · ③-c"},{"id":"d","text":"①-d · ②-b · ③-c"}]'::jsonb, 'a', 'Le bon triptyque est ①-a · ②-b · ③-c ✓ : un radical dans une forme ∞ − ∞ appelle l''expression conjuguée, une forme 0/0 en un point se lève en factorisant le facteur commun (x − 5), et une fonction rationnelle en ±∞ se traite par les termes de plus haut degré. Échanger conjuguée et factorisation (①-b · ②-a) confond les deux transformations ; appliquer les termes dominants en un point fini (②-c) n''a pas de sens, cette technique ne vaut qu''en ±∞ ; et la technique d, remplacer chaque morceau par sa limite, est précisément l''opération illégale interdite face à une forme indéterminée.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffdad216-1ab6-55cf-9736-9792be0fdf75', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Remise en ordre — pour calculer lim x→3 (x² − 2x − 3)/(x − 3), un élève dispose de quatre étapes, données dans le désordre :
① Simplifier la fraction par le facteur (x − 3) obtenu : pour x ≠ 3, le quotient vaut x + 1.
② Constater que le numérateur et le dénominateur s''annulent tous deux en 3 : le théorème du quotient ne s''applique pas (forme 0/0), il faut transformer l''expression.
③ Conclure : lim x→3 (x² − 2x − 3)/(x − 3) = 3 + 1 = 4.
④ Factoriser le numérateur pour lever cette indétermination : x² − 2x − 3 = (x − 3)(x + 1).
Quel est l''ordre correct des étapes ?', '[{"id":"a","text":"② → ① → ④ → ③"},{"id":"b","text":"② → ④ → ③ → ①"},{"id":"c","text":"④ → ② → ① → ③"},{"id":"d","text":"② → ④ → ① → ③"}]'::jsonb, 'd', 'L''ordre correct est ② → ④ → ① → ③ ✓ : on diagnostique d''abord la forme 0/0 (②), ce qui motive la factorisation (④), qui fournit le facteur (x − 3) que l''on simplifie (①), et l''on conclut alors lim = 4 (③). L''ordre ② → ① → ④ → ③ simplifie par un facteur qu''on n''a pas encore obtenu ; ② → ④ → ③ → ① conclut avant d''avoir simplifié la fraction ; et ④ → ② → ① → ③ transforme l''expression avant d''avoir constaté l''indétermination qui justifie cette transformation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1480bf16-37ba-5bcb-967d-c9869d882e43', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Lecture de document — une fonction f est continue sur [0 ; 4]. Un tableau de valeurs donne :
x : 0 · 1 · 2 · 3 · 4
f(x) : 2 · −1 · −3 · 1 · 5
D''après ce tableau, combien de solutions au moins l''équation f(x) = 0 admet-elle sur [0 ; 4] ?', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"4"}]'::jsonb, 'c', 'Le tableau montre deux changements de signe : de f(0) = 2 à f(1) = −1, puis de f(2) = −3 à f(3) = 1. Sur chacun des intervalles [0 ; 1] et [2 ; 3], f est continue et change de signe : le théorème des valeurs intermédiaires garantit au moins une solution dans chacun, donc au moins 2 solutions en tout ✓. Répondre 1 revient à s''arrêter au premier changement de signe ; 4 suppose une solution dans chaque colonne du tableau, alors qu''entre 3 et 4, f reste positive (aucun changement de signe) ; et 0 exige de lire la valeur 0 dans le tableau, ce que le TVI ne demande pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31a27502-0123-5cab-91c3-12dcc369cdf7', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Chasse à l''erreur — pour calculer lim x→−∞ (2x² + 3x)/(x² − 5), un élève rédige :
① En −∞, la limite d''une fonction rationnelle est celle du quotient de ses termes de plus haut degré.
② Les termes de plus haut degré sont 2x² au numérateur et x² au dénominateur.
③ Le quotient de ces termes vaut 2x²/x² = 2x.
④ Conclusion : lim x→−∞ (2x² + 3x)/(x² − 5) = −∞, car 2x → −∞ quand x → −∞.
Une seule étape contient une erreur : laquelle ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : la simplification est fautive, car 2x²/x² = 2 et non 2x — les deux facteurs x² se simplifient entièrement. Étape corrigée : le quotient des termes dominants vaut 2, donc lim x→−∞ (2x² + 3x)/(x² − 5) = 2 ✓, et la conclusion −∞ de l''élève est fausse. Les étapes ① et ② sont exactes, et ④ ne fait que dérouler l''erreur commise en ③. Le piège courant : mal soustraire les exposants en simplifiant des puissances (x²/x² = 1, et non x).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6da5262-b6fa-5a2e-ba02-65f1d7324fc0', '35d2cb52-661a-50a0-94d8-24590f6525d8', 'Vrai ou faux ? On considère l''affirmation : « Si une fonction f n''est pas définie en a mais admet en a une limite finie ℓ, alors f est prolongeable par continuité en a. » Choisis le verdict accompagné de la justification correcte.', '[{"id":"a","text":"Vrai, car en posant g(a) = ℓ et g(x) = f(x) pour x ≠ a, on obtient une fonction continue en a"},{"id":"b","text":"Vrai, car une forme indéterminée 0/0 donne toujours une limite finie"},{"id":"c","text":"Faux, car une fonction non définie en a ne peut jamais être rendue continue en a"},{"id":"d","text":"Faux, car le prolongement n''existe que lorsque la limite ℓ est nulle"}]'::jsonb, 'a', 'L''affirmation est vraie, et la bonne raison est la définition même du prolongement : g(x) = f(x) pour x ≠ a et g(a) = ℓ vérifie lim x→a g(x) = ℓ = g(a), donc g est continue en a ✓. Attention au verdict juste mal justifié : une forme 0/0 ne donne pas toujours une limite finie (x/x³ = 1/x² tend vers +∞ en 0), ce n''est donc pas un argument. Dire que c''est impossible contredit l''exemple du cours (√(x + 1) − 1)/x, prolongée en 0 par 1/2 ; et aucune règle n''exige ℓ = 0 : il faut seulement que ℓ soit fini.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🌉 Histoire ⭐⭐⭐ : Le pont de la continuité', 3, 120, 30, 'boss', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a65b201-ef6d-5532-b334-bef78c2e24f4', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 1 — Le pont d''Analysia enjambe le Ravin des Indéterminées, et toi, héros de la section Mathématiques, tu dois le réparer arche par arche. La première arche a pour profil la fonction f définie par f(x) = 2x² + m si x ≤ 1 et f(x) = 5x − 1 si x > 1, où m est un réel. Pour quelle valeur de m les deux tronçons se raccordent-ils, c''est-à-dire f continue en 1 ?', '[{"id":"a","text":"m = −2"},{"id":"b","text":"m = 2"},{"id":"c","text":"m = 4"},{"id":"d","text":"m = 6"}]'::jsonb, 'b', 'La continuité en 1 exige l''égalité des deux limites latérales avec f(1). À gauche : 2 × 1² + m = 2 + m ; à droite : 5 × 1 − 1 = 4. D''où 2 + m = 4, soit m = 2 ✓. Vérification : f(1) = 2 + 2 = 4, valeur commune aux deux tronçons ✓. Répondre m = 4 revient à oublier que le terme 2x² vaut 2 en x = 1 ; m = 6 ajoute 2 au lieu de le retrancher (4 + 2) ; et m = −2 résout 2 + m = 0, comme si un raccord continu exigeait f(1) = 0.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34fd0348-7102-5b8a-8302-1b9577ab01e2', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 2 — L''arche centrale du pont d''Analysia est fissurée au point x = 4 : son profil g(x) = (√(x + 5) − 3)/(x − 4) n''y est pas défini. Pour colmater la fissure, tu dois prolonger g par continuité en 4. Quelle valeur donner à g(4) ?', '[{"id":"a","text":"1/6"},{"id":"b","text":"1/3"},{"id":"c","text":"1/2"},{"id":"d","text":"6"}]'::jsonb, 'a', 'En 4, √9 − 3 = 0 et x − 4 = 0 : forme 0/0. Expression conjuguée : (√(x + 5) − 3)(√(x + 5) + 3) = x + 5 − 9 = x − 4, donc g(x) = (x − 4)/((x − 4)(√(x + 5) + 3)) = 1/(√(x + 5) + 3), qui tend vers 1/(3 + 3) = 1/6 quand x → 4 ✓. La limite étant finie, on pose g(4) = 1/6 et la fissure est colmatée. Le piège courant : oublier le terme + 3 du conjugué au dénominateur donne 1/√9 = 1/3 ; recopier le résultat 1/2 de l''exemple du cours sans refaire le calcul ; et 6 est le dénominateur √9 + 3 sans prendre l''inverse.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a149b92-97dd-545c-a583-5bf272b2eb7f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 3 — Pour hisser la poutre maîtresse au sommet du pont, le treuil du chantier enroule un câble dont la tension vérifie T(x) ≥ x² − 5 pour tout x ≥ 0, où x est la longueur de câble enroulée. Aucune autre information n''est donnée sur T. Que peut-on affirmer pour lim x→+∞ T(x) ?', '[{"id":"a","text":"Elle vaut −5, la constante qui apparaît dans la minoration"},{"id":"b","text":"Elle est finie, car une fonction minorée admet une limite finie"},{"id":"c","text":"Elle vaut +∞, d''après le théorème de comparaison"},{"id":"d","text":"On ne peut rien conclure : une minoration seule ne donne jamais de limite"}]'::jsonb, 'c', 'C''est exactement le théorème de comparaison : T(x) ≥ x² − 5 au voisinage de +∞ et lim x→+∞ (x² − 5) = +∞, donc lim x→+∞ T(x) = +∞ ✓ — la tension explose, il faudra un câble de légende. Le piège courant : croire qu''il faut toujours deux gendarmes — pour une limite infinie, une seule minoration qui tend vers +∞ suffit ; l''encadrement complet ne sert que pour une limite finie. Répondre −5 lit la constante de la minoration, et « minorée donc limite finie » confond minoration et convergence : x² − 5 est minorée et tend pourtant vers +∞.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f010664a-2322-5b74-ab99-04ea17013ccc', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 4 — Le pilier sud du pont doit toucher le fond du ravin. La profondeur de sa pointe suit h(x) = x³ + 3x − 3, fonction continue et strictement croissante sur [0 ; 1] (somme de fonctions strictement croissantes), avec h(0) = −3 et h(1) = 1. Que peut-on affirmer pour l''équation h(x) = 0 sur [0 ; 1], le point exact où le pilier touche le fond ?', '[{"id":"a","text":"Elle n''admet aucune solution, car ni h(0) ni h(1) n''est égal à 0"},{"id":"b","text":"Elle admet au moins une solution, mais rien ne permet d''en garantir l''unicité"},{"id":"c","text":"Elle admet exactement une solution, car h(0) · h(1) < 0 garantit à lui seul l''existence et l''unicité"},{"id":"d","text":"Elle admet exactement une solution, car h est continue, strictement croissante, et 0 est compris entre h(0) et h(1)"}]'::jsonb, 'd', 'Toutes les hypothèses du corollaire du TVI sont réunies : h continue sur [0 ; 1], strictement croissante, et 0 compris entre h(0) = −3 et h(1) = 1 — l''équation h(x) = 0 admet donc une unique solution α dans [0 ; 1] ✓ : le pilier touche le fond en un point exactement. Le changement de signe seul (h(0) · h(1) < 0) ne garantit que l''existence, jamais l''unicité : ce verdict-là est juste mais sa justification est fausse. Ignorer la stricte croissance pourtant donnée prive à tort de l''unicité ; et exiger h(0) = 0 ou h(1) = 0 confond « s''annuler aux bornes » et « s''annuler dans l''intervalle ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d9998e1-142f-58b9-9112-2bf36321029f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 5 — Pour ancrer le pilier sud, il te faut localiser le point d''ancrage α, l''unique solution de h(x) = 0 sur [0 ; 1], où h(x) = x³ + 3x − 3 est continue et strictement croissante avec h(0) = −3 et h(1) = 1. Par dichotomie, tu calcules h(0,5) = −1,375 puis h(0,75) ≈ −0,33. Dans quel intervalle d''amplitude 0,25 se trouve α ?', '[{"id":"a","text":"]0 ; 0,5["},{"id":"b","text":"]0,5 ; 0,75["},{"id":"c","text":"]0,75 ; 1["},{"id":"d","text":"Nulle part : h(0,5) et h(0,75) étant tous deux négatifs, α n''existe pas"}]'::jsonb, 'c', 'Premier pas : h(0,5) = −1,375 < 0 et h(1) = 1 > 0, le changement de signe est dans ]0,5 ; 1[. Deuxième pas : h(0,75) ≈ −0,33 < 0 et h(1) = 1 > 0, donc α ∈ ]0,75 ; 1[ ✓, un intervalle d''amplitude 0,25 — l''ancrage est localisé. Répondre ]0 ; 0,5[ est une erreur de signe sur h(0,5) ; ]0,5 ; 0,75[ oublie que h(0,75) est encore négatif : le fond n''est pas atteint avant 0,75 ; et deux valeurs négatives ne condamnent pas α — c''est h(1) = 1 > 0 qui maintient le changement de signe, donc l''existence.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fee117e-b359-56cb-9a1e-6f04c1d57a7f', '6b3dab15-5f8a-5de7-8848-2ddab2d2fc24', 'Épisode 6 — Dernière épreuve avant l''autre rive : la corde de traversée vibre, et son amplitude au point x est v(x) = x sin(1/x) pour x > 0. Le pont ne sera déclaré stable que si cette amplitude se stabilise au loin. Détermine lim x→+∞ x sin(1/x). (Rappel admis depuis la 3ème : lim t→0 (sin t)/t = 1.)', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"+∞"},{"id":"d","text":"Cette limite n''existe pas, car le sinus oscille sans se stabiliser"}]'::jsonb, 'b', 'Forme indéterminée du type +∞ × 0 : on pose t = 1/x. Quand x → +∞, t → 0⁺ et x sin(1/x) = sin(t)/t. Par la limite usuelle admise, sin(t)/t → 1, donc lim x→+∞ x sin(1/x) = 1 ✓ (limite d''une composée après changement d''écriture) : l''amplitude se stabilise, le pont de la continuité est réparé. Le piège courant : conclure 0 parce que sin(1/x) → 0, c''est remplacer un morceau d''un produit indéterminé par sa limite — l''opération illégale du chapitre ; +∞ ignore le facteur sin(1/x) qui tend vers 0 ; et sin(1/x) n''oscille pas en +∞ : son argument 1/x tend vers 0, donc il tend vers sin(0) = 0.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('edb002de-0e7f-5b7c-8d12-039559657254', 'ce10c015-98c9-52df-8043-6cb82a6a402b', 'math-bac-math', '🏛️ Annales Bac ⭐⭐⭐⭐ : Session principale — Continuité et limites', 4, 300, 60, 'challenge', 'admin', 7)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('269d83d5-c846-5358-a11b-055acb721037', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Soit a et b deux réels et f la fonction définie pour x ≠ 2 par f(x) = (x² + ax + b)/(x − 2). Déterminer les valeurs de a et b pour lesquelles f est prolongeable par continuité en 2, avec un prolongement vérifiant f(2) = 7.', '[{"id":"a","text":"a = −9 et b = 14"},{"id":"b","text":"a = −3 et b = −10"},{"id":"c","text":"a = 3 et b = −10"},{"id":"d","text":"a = 3 et b = 10"}]'::jsonb, 'c', 'Pour une limite finie en 2, le numérateur doit s''annuler en 2 : 4 + 2a + b = 0. On factorise alors x² + ax + b = (x − 2)(x − r), d''où f(x) = x − r pour x ≠ 2, et f(2) = 2 − r = 7 donne r = −5. Le numérateur vaut (x − 2)(x + 5) = x² + 3x − 10 : a = 3 et b = −10 ✓. Vérification par une seconde route : 4 + 2(3) + (−10) = 0 ✓ et, en posant x = 2 + h, (x² + 3x − 10)/(x − 2) = (7h + h²)/h = 7 + h → 7 quand h → 0 ✓. L''erreur classique : prendre la racine r = 7 au lieu de la valeur du prolongement 2 − r = 7 donne x² − 9x + 14, dont la limite en 2 vaut −5 ; une faute de signe en développant (x − 2)(x + 5) fabrique a = −3, et isoler b avec le mauvais signe donne b = 10 — dans ces deux cas le numérateur ne s''annule même plus en 2 (4 − 6 − 10 = −12 et 4 + 6 + 10 = 20), la limite est infinie et f n''est pas prolongeable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('418ecd91-02f2-5e60-949a-4b77903ff934', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Calculer lim x→−∞ (√(x² + 2x) + x).', '[{"id":"a","text":"−∞"},{"id":"b","text":"−1"},{"id":"c","text":"0"},{"id":"d","text":"1"}]'::jsonb, 'b', 'Forme indéterminée ∞ − ∞ (√(x² + 2x) → +∞ et x → −∞). Expression conjuguée : √(x² + 2x) + x = (x² + 2x − x²)/(√(x² + 2x) − x) = 2x/(√(x² + 2x) − x). Pour x < 0, √x² = |x| = −x, donc √(x² + 2x) = −x√(1 + 2/x) et le dénominateur vaut −x(√(1 + 2/x) + 1) : l''expression se simplifie en −2/(√(1 + 2/x) + 1), qui tend vers −2/2 = −1 ✓. Contrôle numérique : pour x = −100, √9800 − 100 ≈ 98,995 − 100 = −1,005 ✓. L''erreur classique : écrire √(x² + 2x) ≈ x en −∞ (le signe |x| = −x est perdu) transforme la somme en 2x et conduit à −∞ ; lever ∞ − ∞ en « 0 » est une opération illégale ; et répondre 1 recopie le résultat du cas x → +∞, où le signe de x change tout.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9808b350-e59e-5b03-8df4-156a48f6313b', 'edb002de-0e7f-5b7c-8d12-039559657254', 'f est une fonction continue sur [0 ; 5] telle que f(0) = 2, f(2) = −1 et f(5) = 2. Aucune autre information n''est donnée. Laquelle de ces affirmations est justifiée par ces seules hypothèses ?', '[{"id":"a","text":"L''équation f(x) = 0 admet au moins deux solutions dans [0 ; 5]"},{"id":"b","text":"L''équation f(x) = 0 admet exactement deux solutions dans [0 ; 5]"},{"id":"c","text":"L''équation f(x) = 3 admet au moins une solution dans [0 ; 5]"},{"id":"d","text":"Le maximum de f sur [0 ; 5] est égal à 2"}]'::jsonb, 'a', 'Sur [0 ; 2] : f est continue et 0 est compris entre f(0) = 2 et f(2) = −1, donc le TVI fournit une solution α ∈ ]0 ; 2[ de f(x) = 0. Sur [2 ; 5] : 0 est compris entre f(2) = −1 et f(5) = 2, d''où une solution β ∈ ]2 ; 5[. Comme f(2) = −1 ≠ 0, on a bien α < 2 < β : au moins deux solutions ✓. L''erreur classique : annoncer « exactement deux » — sans stricte monotonie sur chaque morceau, f peut très bien s''annuler quatre fois ; invoquer le TVI pour f(x) = 3 alors que 3 n''est compris entre aucune des valeurs données (une fonction affine par morceaux passant par ces trois points ne dépasse jamais 2 ✓) ; et affirmer que le maximum vaut 2, alors que l''image d''un segment est [m ; M] où le maximum M peut être atteint à l''intérieur de l''intervalle et dépasser les valeurs connues aux trois points.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1782f429-e18c-5e6f-8bf9-0fc7f054cb33', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Pour montrer que l''équation x³ + 2x = 5 admet une unique solution α dans [1 ; 2] et l''encadrer, un candidat rédige :
① On pose f(x) = x³ + 2x − 5 ; f est continue sur [1 ; 2] comme fonction polynôme.
② f(1) = −2 < 0 et f(2) = 7 > 0.
③ D''après le théorème des valeurs intermédiaires, l''équation f(x) = 0 admet donc une unique solution α dans [1 ; 2].
④ f(1,5) = 1,375 > 0, donc α ∈ ]1 ; 1,5[.
Quelle étape rend cette rédaction irrecevable ?', '[{"id":"a","text":"L''étape ①"},{"id":"b","text":"L''étape ②"},{"id":"c","text":"L''étape ③"},{"id":"d","text":"L''étape ④"}]'::jsonb, 'c', 'L''erreur se cache à l''étape ③ : le théorème des valeurs intermédiaires garantit au moins une solution, jamais l''unicité. La rédaction correcte ajoute la stricte croissance de f — somme des fonctions strictement croissantes x ↦ x³ et x ↦ 2x − 5 — puis cite le corollaire (fonction continue et strictement monotone). Les étapes ① et ② sont exactes (f(1) = 1 + 2 − 5 = −2 ✓ et f(2) = 8 + 4 − 5 = 7 ✓), et l''étape ④ aussi : f(1,5) = 3,375 + 3 − 5 = 1,375 > 0 ✓, et avec f(1) < 0 le changement de signe place bien α dans ]1 ; 1,5[. L''erreur classique du candidat : conclure « unique » en ne citant que le TVI — la conclusion est vraie ici, mais la justification est invalide et coûte les points d''unicité ; c''est la démarche qu''il fallait invalider, pas le calcul de l''étape ④.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('128b72a3-9efc-5a82-9e82-7eba9bc9714a', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Soit f la fonction définie pour x ≠ 1 par f(x) = (x² − 1)/|x − 1|. Peut-on prolonger f par continuité en 1 ?', '[{"id":"a","text":"Oui, en posant f(1) = 0"},{"id":"b","text":"Oui, en posant f(1) = 2"},{"id":"c","text":"Oui, en posant f(1) = −2"},{"id":"d","text":"Non : f n''admet pas de limite en 1"}]'::jsonb, 'd', 'Pour x > 1, |x − 1| = x − 1 et f(x) = ((x − 1)(x + 1))/(x − 1) = x + 1, qui tend vers 2 ; pour x < 1, |x − 1| = −(x − 1) et f(x) = −(x + 1), qui tend vers −2. Les limites à droite (2) et à gauche (−2) sont différentes : f n''admet pas de limite en 1, donc aucun prolongement par continuité n''est possible ✓. Contrôle numérique : f(1,01) = 0,0201/0,01 = 2,01 et f(0,99) = −0,0199/0,01 = −1,99 ✓. L''erreur classique : simplifier |x − 1| comme s''il valait toujours x − 1 (le facteur « valeur absolue » est perdu dans la simplification) donne 2, qui n''est que la limite à droite ; ne garder que le côté gauche donne −2 ; et traiter la forme 0/0 comme nulle donne 0 — un prolongement exige une limite unique et finie, identique des deux côtés.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99763050-35a1-58e9-bdcf-b2e5cd3f3758', 'edb002de-0e7f-5b7c-8d12-039559657254', 'Une seule des affirmations suivantes est vraie. Laquelle ?', '[{"id":"a","text":"Si lim x→+∞ f(x) = +∞ et lim x→+∞ g(x) = −∞, alors f + g n''admet pas de limite en +∞"},{"id":"b","text":"Si le dénominateur d''une fonction rationnelle s''annule en a, alors la droite d''équation x = a est une asymptote verticale de sa courbe"},{"id":"c","text":"Si lim x→a v(x) = b et lim y→b u(y) = ℓ, alors lim x→a v(u(x)) = ℓ"},{"id":"d","text":"Si lim x→a v(x) = b et lim y→b u(y) = ℓ, alors lim x→a u(v(x)) = ℓ"}]'::jsonb, 'd', 'Seule la dernière affirmation est vraie : c''est le théorème de la limite d''une composée, appliqué dans le bon sens — v agit d''abord, u ensuite, donc lim x→a u(v(x)) = ℓ ✓. Sa jumelle en v(u(x)) est fausse : avec a = 0, v(x) = x + 2 (donc b = 2) et u(y) = 3y (donc ℓ = 6), on obtient v(u(x)) = 3x + 2 → 2 ≠ 6 ✓ — c''est la composée dans le mauvais sens. « f + g n''a pas de limite » est fausse : ∞ − ∞ est une forme indéterminée, pas une absence de limite — f(x) = x + 5 et g(x) = −x donnent f(x) + g(x) = 5 → 5 ✓. Enfin, un dénominateur nul ne fabrique pas toujours une asymptote verticale : (x² − 4)/(x − 2) tend vers 4 en 2 (forme 0/0 levée par factorisation), la courbe n''y a aucune asymptote ✓. L''erreur classique : mémoriser ces énoncés sans leurs hypothèses ni leur sens d''application — au bac, chaque affirmation proche cache une condition précise qui la valide ou la ruine.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

