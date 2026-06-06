-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-economie-fr (Culture générale — Économie (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-economie-fr/
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
  ('culture-generale-economie-fr', 'Culture générale — Économie (FR)', 'Les grandes notions de l''économie : richesse, marché, monnaie et acteurs qui font tourner le monde.', 'Richesse', 'subject-french', 'TrendingUp', 19, 'fr', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-economie-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('7d9b4a07-f501-50f7-a2c3-09def00eb6b6', 'cfa201d6-57ed-5c5a-9c25-1367b715eb62', '72a9edca-c119-5686-81ad-4c875ae15308', 'c514b836-510b-5163-ab14-b343d7ec20fd', '8bf48c36-ef96-57c5-be07-b28c92b59fac', '394b53bd-ff68-5124-9bdf-1c2e66a4923c', '224d9293-10f9-576d-b6a0-346ec93ebecf', '9032a4ba-7801-58b6-9e6e-8af007fe78ef', '694db220-7fd4-50c5-b779-22d271c542d6', 'b2ccb241-7c13-5010-ae71-bad4dfa7391d', '4762698c-d1f7-51d3-ad10-30f901a2aba9', '496e17a2-5223-5e00-a89c-06bce58c0b97', '2c246836-5104-551a-b6cb-ce0961ec5374', 'a76667bf-5a87-53fd-9f52-64694436847e', 'd4848d3e-8817-543c-bb53-6072d59eb391', '848af702-5718-5985-8758-0b9ae2e1a8e6', '7572fb5a-d0d0-5571-98be-5ebe8568ea77', '0e4380f7-08c9-5e9b-8ecf-760a819f63db', 'c3e99b5a-4e41-59f6-9e2a-8d07957e74c0', 'd0497d33-2b1c-5d3f-9a31-adf77247b50d', '2b2ae244-3be6-586d-8c35-055e789f99c1', '0d132934-8892-5c82-bd5e-29ca56ca24ea', '33ca8177-2331-5b65-b0be-1660dc3be13c', 'a594c43c-c049-543e-897c-3a9c7d5a1dbd', '9ac56d44-c9ef-5a38-9a53-ad3a8b9b8ea0', '8b77af20-e00a-54cb-82c9-b08812b9c018', 'dbf5cbd9-c027-569f-b9bf-daa62f6185a4', 'f50b2553-b518-523a-8b4a-095a7561183e', '26fc4125-34cd-5c2f-b3b3-549ebbd727c0');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-economie-fr' AND source = 'admin' AND id NOT IN ('375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729');
DELETE FROM public.questions WHERE exercise_id IN ('375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729') AND id NOT IN ('7d9b4a07-f501-50f7-a2c3-09def00eb6b6', 'cfa201d6-57ed-5c5a-9c25-1367b715eb62', '72a9edca-c119-5686-81ad-4c875ae15308', 'c514b836-510b-5163-ab14-b343d7ec20fd', '8bf48c36-ef96-57c5-be07-b28c92b59fac', '394b53bd-ff68-5124-9bdf-1c2e66a4923c', '224d9293-10f9-576d-b6a0-346ec93ebecf', '9032a4ba-7801-58b6-9e6e-8af007fe78ef', '694db220-7fd4-50c5-b779-22d271c542d6', 'b2ccb241-7c13-5010-ae71-bad4dfa7391d', '4762698c-d1f7-51d3-ad10-30f901a2aba9', '496e17a2-5223-5e00-a89c-06bce58c0b97', '2c246836-5104-551a-b6cb-ce0961ec5374', 'a76667bf-5a87-53fd-9f52-64694436847e', 'd4848d3e-8817-543c-bb53-6072d59eb391', '848af702-5718-5985-8758-0b9ae2e1a8e6', '7572fb5a-d0d0-5571-98be-5ebe8568ea77', '0e4380f7-08c9-5e9b-8ecf-760a819f63db', 'c3e99b5a-4e41-59f6-9e2a-8d07957e74c0', 'd0497d33-2b1c-5d3f-9a31-adf77247b50d', '2b2ae244-3be6-586d-8c35-055e789f99c1', '0d132934-8892-5c82-bd5e-29ca56ca24ea', '33ca8177-2331-5b65-b0be-1660dc3be13c', 'a594c43c-c049-543e-897c-3a9c7d5a1dbd', '9ac56d44-c9ef-5a38-9a53-ad3a8b9b8ea0', '8b77af20-e00a-54cb-82c9-b08812b9c018', 'dbf5cbd9-c027-569f-b9bf-daa62f6185a4', 'f50b2553-b518-523a-8b4a-095a7561183e', '26fc4125-34cd-5c2f-b3b3-549ebbd727c0');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-economie-fr' AND c.id NOT IN ('24778470-5846-5a22-a6b8-99e934c601c3') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', 'Économie : les notions de base', 'Richesse, PIB, marché, loi de l''offre et de la demande, monnaie, inflation et grands acteurs économiques : la boîte à outils pour comprendre l''économie.', '# ⚔️ Économie — la grande arène de la richesse

> 💡 « L''économie, c''est l''art de tirer le meilleur de ressources qui ne suffisent jamais à tout le monde. »

Bienvenue, apprenti stratège. Avant de conquérir les marchés, il te faut maîtriser les sorts de base : que veut dire **produire**, **échanger**, **dépenser** ? Ce chapitre te donne la boîte à outils pour décoder l''actualité économique et briller en culture générale.

## 🏰 Qu''est-ce que l''économie ?

L''**économie** est la science qui étudie comment les humains produisent, échangent, répartissent et consomment des **biens** (objets) et des **services** (prestations) face à des ressources **rares**. La rareté est le point de départ : nos besoins sont illimités, mais le temps, l''argent et les matières premières, eux, sont limités. Toute décision économique est donc un **choix** — et tout choix a un coût.

On distingue deux grands regards :

| Niveau | Ce qu''il observe | Exemple de question |
|---|---|---|
| **Microéconomie** | Les agents individuels (un ménage, une entreprise) | « À quel prix vendre mon pain ? » |
| **Macroéconomie** | L''économie d''un pays dans son ensemble | « Le chômage va-t-il baisser cette année ? » |

## ⚡ Les acteurs et les facteurs

Trois grands **agents économiques** font tourner la machine : les **ménages** (qui consomment et travaillent), les **entreprises** (qui produisent) et l''**État** (qui prélève des impôts et redistribue). Pour produire, on combine des **facteurs de production** : le **travail** (l''effort humain) et le **capital** (machines, outils, bâtiments).

> 🗡️ Astuce de mémoire : *ménages, entreprises, État* — les trois piliers. Un seul qui faiblit et l''arène vacille.

## 🔮 Le marché : l''offre rencontre la demande

Un **marché** est le lieu (réel ou virtuel) où s''échangent un bien ou un service. La **loi de l''offre et de la demande** est la magie qui y fixe les prix :

- Quand la **demande** dépasse l''**offre**, le bien devient rare → le **prix monte**.
- Quand l''offre dépasse la demande, le bien abonde → le **prix baisse**.

Le **prix d''équilibre** est le point magique où la quantité offerte égale la quantité demandée : ni pénurie, ni surplus. Le prix exprime ainsi la **rareté** d''un bien.

> ⚠️ Piège classique : croire qu''« un prix élevé = mauvaise économie ». Un prix élevé signale souvent une forte demande ou une offre rare — c''est un signal, pas une punition.

## 🛡️ La monnaie et l''inflation

La **monnaie** sert à trois choses : payer (intermédiaire des échanges), mesurer la valeur (unité de compte) et épargner (réserve de valeur). Sans elle, il faudrait revenir au **troc**.

L''**inflation** est la **hausse générale et durable des prix**. Une inflation de 5 % signifie qu''en moyenne, ce qui coûtait 100 coûte désormais 105 : ton argent perd du **pouvoir d''achat**. Une baisse générale et durable des prix s''appelle la **déflation** — plus rare, mais redoutable.

## 🧮 Mesurer la richesse : le PIB

Le **Produit Intérieur Brut (PIB)** mesure la valeur de tous les biens et services produits dans un pays sur une année. C''est le « score » de l''économie nationale.

- **PIB nominal** : calculé aux prix courants (inclut l''inflation).
- **PIB réel** : corrigé de l''inflation → reflète la vraie production.

La **croissance économique**, c''est l''augmentation du PIB réel d''une année sur l''autre.

## 🧪 Les grands gardiens du système

Quelques figures et institutions à connaître :

- **Adam Smith** publie en **1776** *La Richesse des Nations*, acte de naissance de l''économie moderne et de la fameuse **« main invisible »** : la poursuite de l''intérêt individuel profiterait à tous.
- La **banque centrale** (BCE pour la zone euro) fixe les **taux directeurs** et veille à la stabilité des prix.
- Le **Fonds Monétaire International (FMI)**, créé en **1944** aux accords de **Bretton Woods**, surveille la stabilité monétaire mondiale et aide les pays en difficulté.
- L''**euro**, en circulation sous forme de billets et pièces depuis le **1ᵉʳ janvier 2002**, est la monnaie de la zone euro.

> 🏆 Première porte franchie ! Tu sais désormais lire un marché, mesurer une richesse et nommer ses gardiens. Prochaine étape : affronter le Boss et prouver que tu maîtrises l''arène de la richesse.', '# 📜 Résumé : Économie — les notions de base

- **Économie** : science des choix face à la **rareté** — produire, échanger, répartir et consommer biens et services.
- **Micro vs macro** : la microéconomie observe les agents individuels (ménage, entreprise) ; la macroéconomie observe le pays entier.
- **Agents économiques** : ménages (consomment, travaillent), entreprises (produisent), État (prélève et redistribue). Facteurs de production : **travail** + **capital**.
- **Marché & loi de l''offre et de la demande** : quand la demande dépasse l''offre, le prix monte ; le **prix d''équilibre** égalise quantité offerte et demandée.
- **Monnaie** : intermédiaire des échanges, unité de compte et réserve de valeur ; remplace le troc.
- **Inflation** : hausse générale et durable des prix → baisse du **pouvoir d''achat** ; son contraire est la **déflation**.
- **PIB** : valeur de la production d''un pays sur un an ; le PIB **réel** est corrigé de l''inflation ; sa hausse = **croissance**.
- **Repères** : Adam Smith, *La Richesse des Nations* (**1776**), la « main invisible » ; **FMI** créé en **1944** (Bretton Woods) ; **euro** en circulation depuis le **1ᵉʳ janvier 2002**.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('375397eb-94e6-5b48-9c24-f1d43bd6f56a', '24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7d9b4a07-f501-50f7-a2c3-09def00eb6b6', '375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'Que mesure le Produit Intérieur Brut (PIB) d''un pays ?', '[{"id":"a","text":"La valeur de tous les biens et services produits dans le pays sur une année"},{"id":"b","text":"Le montant total de l''épargne des ménages"},{"id":"c","text":"La quantité de monnaie en circulation"},{"id":"d","text":"La dette de l''État envers l''étranger"}]'::jsonb, 'a', 'Le PIB additionne la valeur de toute la production de biens et services d''un pays sur une année : c''est le principal indicateur de son activité économique. Sa hausse d''une année sur l''autre s''appelle la croissance. À ne pas confondre avec l''épargne ou la dette, qui mesurent autre chose.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfa201d6-57ed-5c5a-9c25-1367b715eb62', '375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'D''après la loi de l''offre et de la demande, que se passe-t-il généralement quand la demande d''un bien augmente fortement alors que l''offre reste stable ?', '[{"id":"a","text":"Le prix du bien a tendance à baisser"},{"id":"b","text":"Le prix du bien a tendance à monter"},{"id":"c","text":"Le prix reste exactement identique"},{"id":"d","text":"Le bien disparaît définitivement du marché"}]'::jsonb, 'b', 'Quand la demande dépasse l''offre, le bien devient relativement rare et son prix monte jusqu''au prix d''équilibre. Le prix agit comme un signal de rareté. Il ne reste pas figé : c''est justement son ajustement qui équilibre quantités offertes et demandées.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72a9edca-c119-5686-81ad-4c875ae15308', '375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'Comment définit-on l''inflation ?', '[{"id":"a","text":"Une baisse du nombre d''habitants d''un pays"},{"id":"b","text":"La création d''une nouvelle monnaie"},{"id":"c","text":"Une hausse générale et durable des prix"},{"id":"d","text":"L''augmentation des exportations"}]'::jsonb, 'c', 'L''inflation est la hausse générale et durable du niveau des prix : ton argent perd du pouvoir d''achat. Son contraire, la déflation, est une baisse générale des prix. Une inflation de 5 % signifie qu''un panier à 100 coûte désormais 105.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c514b836-510b-5163-ab14-b343d7ec20fd', '375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'Quelle branche de l''économie étudie le comportement d''un agent individuel comme un ménage ou une entreprise ?', '[{"id":"a","text":"La macroéconomie"},{"id":"b","text":"La microéconomie"},{"id":"c","text":"La géopolitique"},{"id":"d","text":"La comptabilité nationale"}]'::jsonb, 'b', 'La microéconomie étudie les choix des agents individuels (un ménage, une entreprise), tandis que la macroéconomie observe l''économie d''un pays dans son ensemble (chômage, croissance, inflation). Le préfixe « micro » (petit) aide à les distinguer.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bf48c36-ef96-57c5-be07-b28c92b59fac', '375397eb-94e6-5b48-9c24-f1d43bd6f56a', 'Parmi ces fonctions, laquelle n''est PAS une fonction de la monnaie ?', '[{"id":"a","text":"Servir d''intermédiaire des échanges pour payer"},{"id":"b","text":"Servir d''unité de compte pour mesurer la valeur"},{"id":"c","text":"Servir de réserve de valeur pour épargner"},{"id":"d","text":"Fixer à elle seule le taux de chômage du pays"}]'::jsonb, 'd', 'La monnaie remplit trois fonctions : intermédiaire des échanges, unité de compte et réserve de valeur. Le taux de chômage dépend du marché du travail et de la conjoncture, pas de la monnaie seule. Sans monnaie, il faudrait revenir au troc, beaucoup moins pratique.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c01836da-0400-5d1e-9a26-0e8bc794f8c6', '24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', '⭐ Quiz : Économie', 1, 50, 10, 'practice', 'admin', 1)
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
  ('394b53bd-ff68-5124-9bdf-1c2e66a4923c', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'Quel concept de base désigne le fait que les ressources sont limitées alors que les besoins sont illimités ?', '[{"id":"a","text":"La rareté"},{"id":"b","text":"L''abondance"},{"id":"c","text":"La gratuité"},{"id":"d","text":"Le gaspillage"}]'::jsonb, 'a', 'La rareté est le point de départ de l''économie : comme les ressources (temps, argent, matières) sont limitées, il faut faire des choix. C''est l''opposé de l''abondance. Tout choix économique a donc un coût, appelé coût d''opportunité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('224d9293-10f9-576d-b6a0-346ec93ebecf', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'Lequel de ces éléments est un service plutôt qu''un bien ?', '[{"id":"a","text":"Une consultation chez le médecin"},{"id":"b","text":"Une bouteille d''eau"},{"id":"c","text":"Un téléphone portable"},{"id":"d","text":"Une paire de chaussures"}]'::jsonb, 'a', 'Un service est une prestation immatérielle (consultation, transport, coupe de cheveux), alors qu''un bien est un objet matériel qu''on peut stocker. La consultation médicale est donc un service ; les trois autres sont des biens.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9032a4ba-7801-58b6-9e6e-8af007fe78ef', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'Quels sont les trois grands agents économiques d''un pays ?', '[{"id":"a","text":"Les banques, les usines et les magasins"},{"id":"b","text":"Les acheteurs, les vendeurs et les touristes"},{"id":"c","text":"Les ménages, les entreprises et l''État"},{"id":"d","text":"Les riches, les pauvres et la classe moyenne"}]'::jsonb, 'c', 'Les trois agents économiques de base sont les ménages (qui consomment et travaillent), les entreprises (qui produisent) et l''État (qui prélève des impôts et redistribue). Banques et magasins sont des types d''entreprises, pas une catégorie d''agents à part.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('694db220-7fd4-50c5-b779-22d271c542d6', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'À quoi sert principalement la monnaie dans une économie ?', '[{"id":"a","text":"À décorer les portefeuilles"},{"id":"b","text":"À remplacer totalement le travail"},{"id":"c","text":"À faciliter les échanges et mesurer la valeur"},{"id":"d","text":"À fixer la météo des marchés"}]'::jsonb, 'c', 'La monnaie facilite les échanges (intermédiaire), mesure la valeur (unité de compte) et permet d''épargner (réserve de valeur). Sans elle, il faudrait recourir au troc, beaucoup plus contraignant car il exige une double coïncidence des besoins.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2ccb241-7c13-5010-ae71-bad4dfa7391d', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'Comment appelle-t-on l''augmentation de la production (PIB réel) d''un pays d''une année sur l''autre ?', '[{"id":"a","text":"L''inflation"},{"id":"b","text":"La croissance économique"},{"id":"c","text":"La récession"},{"id":"d","text":"Le chômage"}]'::jsonb, 'b', 'La croissance économique est la hausse du PIB réel d''une année sur l''autre. À ne pas confondre avec l''inflation (hausse des prix) ni la récession, qui est au contraire un recul de l''activité. Quand le PIB baisse durablement, on parle de récession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4762698c-d1f7-51d3-ad10-30f901a2aba9', 'c01836da-0400-5d1e-9a26-0e8bc794f8c6', 'Sur un marché, comment appelle-t-on le prix pour lequel la quantité offerte est égale à la quantité demandée ?', '[{"id":"a","text":"Le prix de revient"},{"id":"b","text":"Le prix de gros"},{"id":"c","text":"Le prix d''équilibre"},{"id":"d","text":"Le prix de luxe"}]'::jsonb, 'c', 'Le prix d''équilibre est celui où l''offre rencontre exactement la demande : ni pénurie, ni surplus. C''est le point de rencontre des deux courbes. Le prix de revient, lui, est ce que coûte la fabrication d''un produit, ce qui est une notion différente.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', '24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', '⚔️ Boss ⭐⭐⭐ : Économie', 3, 120, 30, 'boss', 'admin', 2)
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
  ('496e17a2-5223-5e00-a89c-06bce58c0b97', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'Lequel de ces couples constitue les deux principaux facteurs de production ?', '[{"id":"a","text":"Le travail et le capital"},{"id":"b","text":"L''offre et la demande"},{"id":"c","text":"L''impôt et la subvention"},{"id":"d","text":"L''épargne et la dette"}]'::jsonb, 'a', 'Produire combine deux facteurs : le travail (l''effort humain) et le capital (machines, outils, bâtiments). L''offre et la demande, elles, décrivent le fonctionnement du marché, pas les moyens de produire. Certains économistes ajoutent la terre comme troisième facteur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c246836-5104-551a-b6cb-ce0961ec5374', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'Quel philosophe écossais est considéré comme le père de l''économie moderne avec son ouvrage de 1776, La Richesse des Nations ?', '[{"id":"a","text":"Karl Marx"},{"id":"b","text":"John Maynard Keynes"},{"id":"c","text":"David Ricardo"},{"id":"d","text":"Adam Smith"}]'::jsonb, 'd', 'Adam Smith publie La Richesse des Nations en 1776, acte de naissance de l''économie moderne et de la « main invisible ». Marx (XIXe) et Keynes (XXe) sont plus tardifs ; Ricardo, contemporain de Smith, a surtout théorisé l''avantage comparatif, pas fondé la discipline.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a76667bf-5a87-53fd-9f52-64694436847e', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'Quelle est la différence essentielle entre le PIB nominal et le PIB réel ?', '[{"id":"a","text":"Le PIB réel inclut l''inflation, le PIB nominal l''exclut"},{"id":"b","text":"Le PIB réel est corrigé de l''inflation, le PIB nominal est calculé aux prix courants"},{"id":"c","text":"Le PIB nominal ne concerne que les services"},{"id":"d","text":"Le PIB réel ne mesure que les exportations"}]'::jsonb, 'b', 'Le PIB nominal est mesuré aux prix courants et grossit avec l''inflation ; le PIB réel est corrigé de l''inflation, donc reflète la vraie production. C''est le PIB réel qu''on suit pour juger de la croissance. L''option a inverse exactement les deux notions : c''est le piège.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4848d3e-8817-543c-bb53-6072d59eb391', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'En 1944, les accords de Bretton Woods ont donné naissance à une institution chargée de veiller à la stabilité du système monétaire international. Laquelle ?', '[{"id":"a","text":"L''Organisation Mondiale du Commerce (OMC)"},{"id":"b","text":"L''Organisation des Nations Unies (ONU)"},{"id":"c","text":"La Banque Centrale Européenne (BCE)"},{"id":"d","text":"Le Fonds Monétaire International (FMI)"}]'::jsonb, 'd', 'Le FMI naît en juillet 1944 à la conférence de Bretton Woods pour stabiliser le système monétaire d''après-guerre et aider les pays en difficulté. L''OMC date de 1995, la BCE de 1998 (zone euro), et l''ONU, fondée en 1945, n''a pas de rôle monétaire spécifique.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('848af702-5718-5985-8758-0b9ae2e1a8e6', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'Une économie connaît une inflation de 10 % sur l''année. Que devient le pouvoir d''achat d''une somme de 100 conservée sous le matelas, en termes réels ?', '[{"id":"a","text":"Il augmente, car les prix montent"},{"id":"b","text":"Il diminue : 100 achètent moins de biens qu''avant"},{"id":"c","text":"Il reste exactement le même"},{"id":"d","text":"Il double automatiquement"}]'::jsonb, 'b', 'Avec 10 % d''inflation, ce qui coûtait 100 coûte désormais 110 : les mêmes 100 achètent donc moins de biens, leur pouvoir d''achat diminue. Le piège courant est de croire que des prix qui montent enrichissent ceux qui détiennent de l''argent liquide : c''est l''inverse, l''inflation érode l''épargne non placée.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7572fb5a-d0d0-5571-98be-5ebe8568ea77', 'c8d2891e-f72a-5cf2-a240-7a1fb0d010ff', 'Sur un marché concurrentiel, l''offre d''un produit double soudainement alors que la demande reste inchangée. Quel effet le plus probable sur le prix d''équilibre ?', '[{"id":"a","text":"Le prix d''équilibre baisse"},{"id":"b","text":"Le prix d''équilibre monte"},{"id":"c","text":"Le prix d''équilibre est multiplié par deux"},{"id":"d","text":"Le marché disparaît immédiatement"}]'::jsonb, 'a', 'Quand l''offre augmente sans que la demande suive, le produit devient relativement abondant et le prix d''équilibre baisse pour écouler les quantités. Le piège est de croire que doubler l''offre double le prix : la quantité offerte et le prix évoluent en sens inverse, pas dans le même sens.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('22cb5db9-8621-54d6-b696-f416c9d9fc28', '24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', '⭐⭐ Révision : Économie', 2, 70, 15, 'practice', 'admin', 3)
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
  ('0e4380f7-08c9-5e9b-8ecf-760a819f63db', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Comment appelle-t-on une baisse générale et durable des prix, phénomène inverse de l''inflation ?', '[{"id":"a","text":"La déflation"},{"id":"b","text":"La stagflation"},{"id":"c","text":"La dévaluation"},{"id":"d","text":"La récession"}]'::jsonb, 'a', 'La déflation est la baisse générale et durable des prix : à ne pas confondre avec la récession (recul de l''activité) ni la dévaluation (baisse volontaire de la valeur d''une monnaie). La déflation est redoutée car elle pousse à reporter les achats, ce qui ralentit l''économie.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3e99b5a-4e41-59f6-9e2a-8d07957e74c0', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Quel niveau d''analyse économique étudie les grands agrégats d''un pays comme le PIB, le chômage ou l''inflation ?', '[{"id":"a","text":"La microéconomie"},{"id":"b","text":"La gestion d''entreprise"},{"id":"c","text":"Le marketing"},{"id":"d","text":"La macroéconomie"}]'::jsonb, 'd', 'La macroéconomie étudie l''économie d''un pays dans sa globalité à travers ses grands agrégats (PIB, chômage, inflation). La microéconomie, elle, se concentre sur les choix d''un agent individuel. Le préfixe « macro » (grand) signale qu''on raisonne à l''échelle de la nation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0497d33-2b1c-5d3f-9a31-adf77247b50d', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Quelle expression d''Adam Smith désigne l''idée que la poursuite de l''intérêt individuel peut profiter à l''ensemble de la société ?', '[{"id":"a","text":"La destruction créatrice"},{"id":"b","text":"La lutte des classes"},{"id":"c","text":"La main invisible"},{"id":"d","text":"Le multiplicateur keynésien"}]'::jsonb, 'c', 'La « main invisible » d''Adam Smith décrit comment les actions individuelles guidées par l''intérêt personnel contribuent au bien commun via le marché. La destruction créatrice est de Schumpeter, la lutte des classes de Marx et le multiplicateur de Keynes : autant d''auteurs et d''idées différents.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b2ae244-3be6-586d-8c35-055e789f99c1', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Quelle institution est chargée de fixer les taux directeurs et de veiller à la stabilité des prix dans la zone euro ?', '[{"id":"a","text":"La Banque Centrale Européenne (BCE)"},{"id":"b","text":"La Commission européenne"},{"id":"c","text":"Le Parlement européen"},{"id":"d","text":"Le Fonds Monétaire International (FMI)"}]'::jsonb, 'a', 'La BCE conduit la politique monétaire de la zone euro : elle fixe les taux directeurs pour maîtriser l''inflation et garder les prix stables. La Commission et le Parlement ont des rôles politiques et législatifs, et le FMI agit à l''échelle mondiale, pas seulement dans la zone euro.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d132934-8892-5c82-bd5e-29ca56ca24ea', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Depuis quand les billets et les pièces en euros circulent-ils physiquement dans la poche des citoyens de la zone euro ?', '[{"id":"a","text":"Depuis le 1ᵉʳ janvier 1999"},{"id":"b","text":"Depuis le 1ᵉʳ janvier 2002"},{"id":"c","text":"Depuis le 1ᵉʳ janvier 1995"},{"id":"d","text":"Depuis le 1ᵉʳ janvier 2010"}]'::jsonb, 'b', 'Les billets et pièces en euros sont mis en circulation le 1ᵉʳ janvier 2002. L''euro existait déjà depuis le 1ᵉʳ janvier 1999, mais seulement comme monnaie « invisible » (paiements électroniques et comptables) : c''est le piège entre la création de la monnaie et l''arrivée du cash.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33ca8177-2331-5b65-b0be-1660dc3be13c', '22cb5db9-8621-54d6-b696-f416c9d9fc28', 'Une entreprise voit le prix de ses matières premières fortement augmenter et répercute ce coût sur ses prix de vente. À quel mécanisme d''inflation cela correspond-il ?', '[{"id":"a","text":"L''inflation par la demande"},{"id":"b","text":"L''inflation par les coûts"},{"id":"c","text":"La déflation importée"},{"id":"d","text":"La désinflation"}]'::jsonb, 'b', 'Quand la hausse des coûts de production (matières premières, salaires) pousse les entreprises à augmenter leurs prix, on parle d''inflation par les coûts. L''inflation par la demande, elle, vient d''une demande supérieure à l''offre. La désinflation est un simple ralentissement de l''inflation, pas une cause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d4b620f5-3b8d-5b00-8f6b-42aca7e86729', '24778470-5846-5a22-a6b8-99e934c601c3', 'culture-generale-economie-fr', '👑 Défi élite ⭐⭐⭐⭐ : Économie', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a594c43c-c049-543e-897c-3a9c7d5a1dbd', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'On dit que le PIB ne mesure pas tout. Laquelle de ces activités n''est PAS comptabilisée dans le PIB officiel d''un pays ?', '[{"id":"a","text":"Le salaire versé à un cuisinier de restaurant"},{"id":"b","text":"Le travail domestique non rémunéré effectué à la maison"},{"id":"c","text":"La construction d''une route par une entreprise"},{"id":"d","text":"La vente de billets de train"}]'::jsonb, 'b', 'Le PIB ne compte que la production donnant lieu à un échange marchand ou mesurable ; le travail domestique non rémunéré (ménage, garde d''enfants à la maison) en est exclu. C''est l''une des grandes limites du PIB, souvent citée. Les trois autres activités, elles, sont rémunérées et donc comptabilisées.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ac56d44-c9ef-5a38-9a53-ad3a8b9b8ea0', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'Une banque centrale veut combattre une inflation jugée trop élevée. Quelle action est la plus cohérente avec cet objectif ?', '[{"id":"a","text":"Augmenter ses taux directeurs pour freiner le crédit et la demande"},{"id":"b","text":"Baisser ses taux directeurs pour encourager les emprunts"},{"id":"c","text":"Distribuer gratuitement de la monnaie aux ménages"},{"id":"d","text":"Interdire l''épargne"}]'::jsonb, 'a', 'Pour calmer l''inflation, une banque centrale relève ses taux directeurs : le crédit devient plus cher, la demande ralentit et la pression sur les prix retombe. Le piège est de croire qu''il faut baisser les taux : cela relance au contraire la demande et donc l''inflation. Distribuer de la monnaie l''aggraverait encore.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b77af20-e00a-54cb-82c9-b08812b9c018', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'Comment nomme-t-on la valeur à laquelle on renonce lorsqu''on choisit une option plutôt qu''une autre, faute de ressources pour tout faire ?', '[{"id":"a","text":"Le coût marginal"},{"id":"b","text":"Le coût d''opportunité"},{"id":"c","text":"Le coût fixe"},{"id":"d","text":"Le coût de revient"}]'::jsonb, 'b', 'Le coût d''opportunité est la valeur de la meilleure option à laquelle on renonce : étudier un soir, c''est renoncer à la sortie correspondante. Le coût marginal est le coût d''une unité supplémentaire produite, le coût fixe ne dépend pas de la quantité, et le coût de revient est le coût total de fabrication.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbf5cbd9-c027-569f-b9bf-daa62f6185a4', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'Un pays enregistre deux trimestres consécutifs de baisse de son PIB réel. Quel terme économique décrit le mieux cette situation ?', '[{"id":"a","text":"Une expansion"},{"id":"b","text":"Une récession"},{"id":"c","text":"Une inflation galopante"},{"id":"d","text":"Une relance budgétaire"}]'::jsonb, 'b', 'Une définition courante de la récession est un recul du PIB réel sur deux trimestres consécutifs. L''expansion est l''inverse (croissance soutenue). L''inflation concerne les prix, pas la production, et la relance budgétaire est une politique de l''État, pas un état de l''économie : ce sont les pièges à éviter.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f50b2553-b518-523a-8b4a-095a7561183e', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'Sur un marché de concurrence pure et parfaite, laquelle de ces conditions est requise ?', '[{"id":"a","text":"Un seul vendeur contrôle tout le marché"},{"id":"b","text":"Les acheteurs ne connaissent pas les prix pratiqués"},{"id":"c","text":"Les produits échangés sont homogènes et les vendeurs très nombreux"},{"id":"d","text":"L''État fixe lui-même tous les prix"}]'::jsonb, 'c', 'La concurrence pure et parfaite suppose des produits homogènes, des vendeurs et acheteurs nombreux, une information parfaite sur les prix et la libre entrée sur le marché. Un seul vendeur correspond à un monopole (option a), l''opacité des prix (b) ou des prix fixés par l''État (d) contredisent justement ce modèle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26fc4125-34cd-5c2f-b3b3-549ebbd727c0', 'd4b620f5-3b8d-5b00-8f6b-42aca7e86729', 'Dans la phrase « les agents économiques sont reliés par des flux », à quoi correspond le flux qui va des ménages vers les entreprises en échange d''un salaire ?', '[{"id":"a","text":"Le facteur travail"},{"id":"b","text":"Le facteur capital"},{"id":"c","text":"Les impôts"},{"id":"d","text":"Les dividendes"}]'::jsonb, 'a', 'Les ménages fournissent leur travail aux entreprises et reçoivent en échange un salaire : c''est le facteur travail. Le capital désigne les machines et outils, les impôts vont vers l''État, et les dividendes rémunèrent les actionnaires, pas le travail fourni. Distinguer ces flux est la clé du circuit économique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

