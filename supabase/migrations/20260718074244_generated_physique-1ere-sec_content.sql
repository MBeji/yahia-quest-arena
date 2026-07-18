-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: physique-1ere-sec (Sciences Physiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/physique-1ere-sec/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id, manuel_refs) VALUES
  ('physique-1ere-sec', 'Sciences Physiques', 'L''électricité selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun) : le phénomène d''électrisation, le circuit électrique, l''intensité du courant électrique et la tension électrique', 'Observation', 'subject-svt', 'Atom', 2, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'), NULL)
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
  grade_id = EXCLUDED.grade_id,
  manuel_refs = EXCLUDED.manuel_refs;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'physique-1ere-sec'
      AND e.source = 'admin'
      AND q.id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'physique-1ere-sec' AND source = 'admin' AND id NOT IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841');
DELETE FROM public.questions WHERE exercise_id IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841') AND id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5');
DELETE FROM public.chapters c WHERE c.subject_id = 'physique-1ere-sec' AND c.id NOT IN ('f3c0e519-3356-5b57-bf8a-c39cf6650721', '60fba4c2-4acb-5966-bf21-451643db2757', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'cefe9013-8f6e-57cc-beb2-addd28192c81') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', 'Le phénomène d''électrisation', 'Électrisation par frottement et détection au pendule électrostatique ; les deux types de charges et la convention de signe référencée au verre (positive/vitrée, négative/résineuse) ; lois d''interaction (même signe → répulsion, signes contraires → attraction) ; les trois modes d''électrisation (frottement, contact, influence) et l''électroscope ; le modèle des porteurs de charges et le transfert d''électrons ; la charge q en coulomb (C) et la charge élémentaire e = 1,6 × 10⁻¹⁹ C ; conducteurs et isolants ; décharge électrique, étincelle, éclair, effet de pointe ; cage de Faraday, foudre et paratonnerre', '# ⚡ Le phénomène d''électrisation — quand la matière se charge

> 💡 «Tu tires un pull en laine par temps sec : ça crépite, ça t''attire les cheveux, et parfois une petite étincelle te pique le doigt. Ce chapitre t''explique ce petit choc — et, au passage, l''éclair qui tombe du ciel.»

Bienvenue dans **L''ÉLECTRICITÉ**, héros. Avant les circuits et les piles, il faut comprendre d''où vient l''électricité. Tout part d''un geste banal : **frotter**. Ce chapitre est entièrement **qualitatif** — aucun calcul — mais il pose le modèle sur lequel repose tout le reste du programme.

## 🧲 Électriser un corps

Approche une règle en plexiglas d''une petite boule légère suspendue à un fil de soie — un **pendule électrostatique**. Rien ne bouge. Frotte maintenant cette règle avec un tissu en **laine**, puis approche-la **sans toucher** la boule : **la boule est attirée**.

Le frottement a modifié la surface de la règle : elle est devenue capable d''attirer les corps légers. On dit qu''elle est **électrisée**, ou **chargée d''électricité**. Le verre, le plexiglas, le plastique, le caoutchouc, les métaux, la laine… sont **susceptibles d''être électrisés par frottement**. Le **pendule électrostatique** est notre premier **détecteur** de charge.

## ➕➖ Deux charges, une règle de signe

Frotte deux bâtons en verre : approchés l''un de l''autre, ils **se repoussent**. Frotte un bâton en verre et un bâton en P.V.C : ils **s''attirent**. Il existe donc **deux types de charges électriques**. La convention se lit **par rapport au verre** frotté avec de la laine :

- un corps qui **repousse** le verre électrisé porte une charge **positive (+)** (autrefois « électricité vitrée ») ;
- un corps qui est **attiré** par le verre électrisé porte une charge **négative (−)** (autrefois « électricité résineuse »).

::: figure Deux charges de même signe s''écartent, deux charges de signes contraires se rapprochent : c''est le signe, jamais la seule présence de charge, qui décide
<svg viewBox="0 0 340 170">
<g stroke="#0f172a" stroke-width="1.8">
<circle cx="55" cy="55" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="120" cy="55" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="55" cy="125" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="120" cy="125" r="20" fill="#3b82f6" opacity="0.75"/>
</g>
<g font-size="20" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="55" y="62">+</text><text x="120" y="62">+</text>
<text x="55" y="132">+</text><text x="120" y="132">−</text>
</g>
<g stroke="#0f172a" stroke-width="2.5" fill="none" marker-end="url(#ar)">
<path d="M78 40 L100 40"/><path d="M97 70 L75 70"/>
<path d="M88 110 L102 110"/><path d="M87 140 L73 140"/>
</g>
<defs><marker id="ar" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>
<g font-size="12" font-weight="700" fill="#0f172a">
<text x="175" y="59">même signe → répulsion</text>
<text x="175" y="129">signes contraires → attraction</text>
</g>
</svg>
:::

Retiens la double loi : **deux corps chargés de même signe se repoussent ; deux corps chargés de signes contraires s''attirent.**

## 🔄 Trois façons d''électriser

Il existe **trois modes d''électrisation** :

| Mode           | Comment                                         | Résultat                                           |
| -------------- | ----------------------------------------------- | -------------------------------------------------- |
| **frottement** | on frotte deux corps l''un contre l''autre        | chaque corps se charge                             |
| **contact**    | un corps électrisé en touche un autre           | le corps touché prend une charge **de même signe** |
| **influence**  | on approche un corps électrisé **sans toucher** | les charges de l''autre corps se réorganisent       |

L''**électroscope** est l''appareil qui, par **influence**, permet de **détecter si un corps qui lui est approché est électrisé ou non** : son aiguille (ou ses feuilles) dévie.

C''est aussi l''**influence** qui explique pourquoi un corps chargé attire même un corps **neutre** (comme la boule du début du chapitre) : il attire vers lui les charges de signe opposé et repousse les charges de même signe. Les charges attirées se retrouvant **plus proches** que les charges repoussées, **l''attraction l''emporte sur la répulsion**.

> 🗡️ Un corps **non frotté et non électrisé par contact** n''agit sur rien : il est **électriquement neutre**. Neutre ne veut pas dire « vide de charges » — tu vas voir pourquoi.

## ⚛️ Le modèle : des électrons qui migrent

Pour tout expliquer, on admet que la matière contient des **porteurs de charges** de deux sortes : les uns portent de l''électricité **positive**, les autres de l''électricité **négative**. Un corps **neutre** en contient des **quantités égales** — d''où sa neutralité.

Lors du frottement, de minuscules porteurs négatifs, les **électrons**, **migrent d''un corps à l''autre** :

- le corps qui **reçoit** les électrons devient chargé **négativement** ;
- le corps qui **cède** ses électrons devient chargé **positivement**.

::: figure En frottant le verre avec la laine, des électrons quittent le verre pour la laine : le verre, qui en cède, devient positif ; la laine, qui en reçoit, devient négative
<svg viewBox="0 0 340 160">
<rect x="30" y="60" width="90" height="26" rx="6" fill="#fca5a5" opacity="0.7" stroke="#0f172a" stroke-width="1.8"/>
<rect x="220" y="60" width="90" height="26" rx="6" fill="#93c5fd" opacity="0.7" stroke="#0f172a" stroke-width="1.8"/>
<g stroke="#1d4ed8" stroke-width="2.5" fill="none" marker-end="url(#e)">
<path d="M130 50 C 170 30, 200 30, 214 48"/>
</g>
<defs><marker id="e" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#1d4ed8"/></marker></defs>
<g fill="#1d4ed8" stroke="#0f172a" stroke-width="1"><circle cx="150" cy="41" r="6"/><circle cx="172" cy="35" r="6"/><circle cx="194" cy="38" r="6"/></g>
<g font-size="10" font-weight="700" fill="#ffffff" text-anchor="middle"><text x="150" y="45">−</text><text x="172" y="39">−</text><text x="194" y="42">−</text></g>
<g font-size="13" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="75" y="77">verre</text><text x="265" y="77">laine</text>
<text x="75" y="112">devient +</text><text x="265" y="112">devient −</text>
<text x="172" y="20">électrons</text>
</g>
</svg>
:::

La charge portée par un corps est une **grandeur mesurable**, notée **q**. Son unité, dans le système international, est le **coulomb** (symbole **C**). La charge d''un seul électron est notée **−e**, où **e** est la **charge élémentaire** :

$$ e = 1,6 × 10⁻¹⁹ C $$

## 🚧 Conducteurs et isolants

Électrise une tige, puis relie-la à la boule du pendule par différents matériaux. Résultat :

- avec le **cuivre**, l''**aluminium** ou le **carbone**, la charge **se propage** : ce sont des **conducteurs**. Ils **laissent circuler les électrons**, et la charge se **répartit sur toute la tige**.
- avec le **bois**, le **verre**, le **P.V.C** ou le **plexiglas**, rien ne passe : ce sont des **isolants**. La charge **reste localisée** là où elle est apparue.

> ⚠️ Piège classique : « le verre est un isolant, donc on ne peut pas l''électriser ». Faux ! On électrise très bien le verre **par frottement** — sa charge reste simplement **localisée** au point frotté, faute de pouvoir circuler.

## ⚡ Décharges, étincelles et foudre

Accumule des charges de signes contraires sur les deux sphères d''une **machine de Wimshurst** : au bout d''un moment, une **étincelle** jaillit avec un **crépitement**. Deux corps très chargés de signes contraires provoquent un **déplacement d''électrons à travers l''air** : c''est une **décharge électrique**. Ces électrons se déplacent **du corps négatif vers le corps positif**. La lueur qui matérialise le canal de la décharge est l''**éclair** ; l''échauffement intense de l''air produit le **crépitement**.

Au bout d''une **pointe**, les charges s''accumulent très fortement et la décharge y est facilitée : c''est l''**effet de pointe**. C''est exactement ce qui se joue dans le ciel : le bas d''un nuage orageux, chargé négativement, provoque une décharge vers le sol — la **foudre** ; le bruit qui suit est le **tonnerre**. Une grosse pointe métallique reliée à la Terre, le **paratonnerre**, capte la foudre et la conduit au sol. Et la carrosserie métallique d''une voiture forme une **cage de Faraday** : elle protège ses occupants en maintenant le champ électrique **nul à l''intérieur**.

> 🏆 Première quête franchie, héros ! Tu sais électriser un corps, lire le signe d''une charge, expliquer les trois modes d''électrisation par le transfert d''électrons, et distinguer conducteur et isolant. Cap sur le **circuit électrique** : il est temps de faire circuler ce courant.', '# 📜 Résumé : Le phénomène d''électrisation

- **Électriser un corps.** Un corps frotté peut devenir **électrisé** (chargé d''électricité) : il attire alors les corps légers. Le **pendule électrostatique** sert à **détecter** cette charge.
- **Deux charges, règle de signe.** Il existe deux types de charges. Par convention, référencée au **verre** frotté à la laine : un corps **repoussé** par le verre est **positif (+)**, un corps **attiré** par le verre est **négatif (−)**. Loi : **même signe → répulsion ; signes contraires → attraction.**
- **Trois modes d''électrisation.** Par **frottement**, par **contact** (le corps touché prend le **même signe** que le corps électrisant) et par **influence** (sans contact). L''**électroscope** détecte, par influence, si un corps est chargé. Un corps ni frotté ni touché est **électriquement neutre**.
- **Le modèle des électrons.** La matière contient des **porteurs de charges** ; un corps neutre en a autant de positifs que de négatifs. Au frottement, des **électrons** migrent : celui qui en **reçoit** devient **négatif**, celui qui en **cède** devient **positif**. La charge se note **q**, en **coulomb (C)** ; la charge élémentaire vaut **e = 1,6 × 10⁻¹⁹ C**, et l''électron porte **−e**.
- **Conducteurs et isolants.** Les **conducteurs** (cuivre, aluminium, carbone) **laissent circuler les électrons** : la charge se répartit sur tout le corps. Les **isolants** (bois, verre, P.V.C, plexiglas) ne le permettent pas : la charge **reste localisée**.
- **Décharges et foudre.** Entre deux corps très chargés de signes contraires, des électrons traversent l''air **du corps négatif vers le positif** : c''est une **décharge**, avec **étincelle**, **éclair** et **crépitement**. Au bout d''une **pointe**, la décharge est facilitée (**effet de pointe**). Dans le ciel : **foudre** et **tonnerre** ; on s''en protège par le **paratonnerre** et la **cage de Faraday** (carrosserie de voiture).', 1, '{"code":"223103P00","pages":"9-24","pageNumbers":[9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', 'Le circuit électrique', 'Notion de dipôle et de circuit électrique fermé (chaîne continue de dipôles avec au moins un générateur) ; dipôle générateur et dipôle récepteur ; les quatre effets du courant (thermique, chimique, magnétique, lumineux) ; conducteurs et isolants, circuit ouvert, conditions de passage du courant ; symboles normalisés et schématisation ; sens conventionnel du courant (de la borne + vers la borne − à l''extérieur du générateur) ; nature du courant (électrons dans les métaux, cations et anions dans les électrolytes) ; la diode, dipôle dissymétrique (sens passant et sens bloquant) ; le court-circuit et ses dangers', '# 🔌 Le circuit électrique — mettre le courant en route

> 💡 «Une pile toute seule ne sert à rien ; une lampe toute seule non plus. C''est en les reliant que la lampe s''allume. Ce chapitre t''apprend la règle du jeu : comment faire circuler un courant, et dans quel sens.»

Au chapitre 1, les charges restaient immobiles. Maintenant, on les fait **circuler**. Un courant électrique parcourt un ensemble de composants reliés : un **circuit**. Voyons comment le construire, le lire et le protéger.

## 🔌 Dipôles et circuit fermé

Une pile, une lampe, un moteur ont un point commun : chacun possède **deux bornes** de connexion. On les appelle des **dipôles**. Relie-les bout à bout par des fils : tu formes une **chaîne**.

- Si la chaîne est **continue** (aucune coupure) et contient **au moins un générateur**, un courant circule : c''est un **circuit électrique fermé**.
- Le **générateur** (la pile) est le dipôle qui **fait apparaître** le courant. La lampe et le moteur sont des **récepteurs** : ils **utilisent** le courant pour fonctionner, mais ne peuvent pas le créer.

## 🔥 Les quatre effets du courant

Comment savoir qu''un courant passe ? Par ses **effets**. Le manuel en retient **quatre** :

| Effet          | On l''observe quand…                               | Exemple              |
| -------------- | ------------------------------------------------- | -------------------- |
| **thermique**  | un conducteur **chauffe**                         | filament d''une lampe |
| **chimique**   | le courant **transforme la matière**              | électrolyseur        |
| **magnétique** | une aiguille aimantée **dévie**                   | près d''un fil        |
| **lumineux**   | un composant **émet de la lumière** sans chauffer | DEL                  |

> 🗡️ La manifestation de **l''un** de ces effets **prouve** le passage d''un courant. Selon les composants, plusieurs effets peuvent apparaître à la fois (une DEL : lumineux, et un peu magnétique).

## 🚧 Conducteurs, isolants et circuit ouvert

Coupe la chaîne et intercale un objet. S''il **laisse passer** le courant (la lampe se rallume), c''est un **conducteur** (métaux, carbone). S''il **bloque** le courant, c''est un **isolant** (plastique, bois, verre). Un circuit qui contient un isolant dans sa chaîne est un **circuit ouvert** : aucun courant n''y circule.

Un circuit n''est parcouru par un courant que s''il remplit **deux conditions** :

1. il comporte un **dipôle générateur** ;
2. il forme une **chaîne continue de conducteurs**.

> 🗡️ L''air sec est isolant ; mais l''air humide, l''eau et le corps humain sont de **mauvais conducteurs** — d''où le danger de l''électricité près de l''eau.

## ✏️ Schématiser un circuit

Pour dessiner un circuit sans faire de portrait, on utilise des **symboles normalisés** : les mêmes pour tout le monde.

::: figure Un circuit fermé : le générateur (pile) impose le courant, qui parcourt la chaîne continue et allume la lampe ; la flèche rouge donne le sens conventionnel
<svg viewBox="0 0 320 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M60 55 V88"/><path d="M60 112 V150"/>
<path d="M60 55 H260"/><path d="M60 150 H260"/>
<path d="M260 55 V88"/><path d="M260 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M44 92 H76"/><path d="M52 112 H68"/></g>
<circle cx="260" cy="100" r="13" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M251 91 L269 109 M269 91 L251 109" stroke="#0f172a" stroke-width="1.5"/>
<path d="M150 55 H178" stroke="#dc2626" stroke-width="2.6" fill="none" marker-end="url(#c2)"/>
<defs><marker id="c2" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#dc2626"/></marker></defs>
<g font-size="14" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="34" y="97">+</text><text x="34" y="117">−</text>
<text x="60" y="178">pile</text><text x="260" y="140">lampe</text>
</g>
<text x="164" y="46" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">sens du courant</text>
</svg>
:::

Retiens les symboles cités par le programme : **fil, générateur, lampe, moteur, interrupteur** (ouvert ou fermé), **diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre**.

## ➡️ Le sens du courant et sa nature

Le courant a un **sens**. **Par convention**, à l''**extérieur** du générateur, il circule de la **borne positive (+)** vers la **borne négative (−)**. C''est le **sens conventionnel**.

Mais que sont ces « porteurs » qui circulent vraiment ?

- **Dans les métaux** : ce sont les **électrons** (dits électrons de conduction). Comme ils sont négatifs, ils se déplacent **en sens inverse** du sens conventionnel — vers la borne **+** du générateur.
- **Dans les solutions ioniques** (électrolytes) : ce sont des **ions**. Les **cations** (positifs) se déplacent dans le **sens conventionnel** (vers la borne −), les **anions** (négatifs) dans le sens inverse (vers la borne +).

> ⚠️ Piège classique : « le courant, ce sont toujours des électrons ». Non — dans une solution ionique, ce sont des **ions** qui se déplacent, pas des électrons.

## 🔀 La diode et le court-circuit

La **diode** est un dipôle **dissymétrique** : ses deux bornes ne jouent pas le même rôle. Elle ne laisse passer le courant que dans **un seul sens** :

- dans le **sens passant**, elle se comporte comme un **interrupteur fermé** ;
- dans le **sens bloquant**, comme un **interrupteur ouvert**.

Elle sert donc à imposer, ou à repérer, le sens du courant. La **DEL** (diode électroluminescente) est une diode qui, en plus, **émet de la lumière**.

Enfin, un **court-circuit** : on relie les deux bornes d''un dipôle par un simple **fil conducteur**. Le courant passe alors par le fil au lieu du dipôle : le dipôle **court-circuité est mis hors usage**. Aux bornes d''un **générateur**, un court-circuit est dangereux : il peut l''endommager et provoquer un **incendie**.

> 🏆 Deuxième quête bouclée, héros ! Tu sais bâtir un circuit fermé, reconnaître les quatre effets du courant, tracer un schéma normalisé et donner le sens du courant. Il te reste à le **mesurer** : cap sur l''intensité.', '# 📜 Résumé : Le circuit électrique

- **Dipôles et circuit fermé.** Un **dipôle** a **deux bornes**. Une **chaîne continue** de dipôles comportant **au moins un générateur** forme un **circuit électrique fermé**. Le **générateur** fait apparaître le courant ; les **récepteurs** (lampe, moteur) l''utilisent pour fonctionner.
- **Les quatre effets du courant.** Le passage d''un courant se manifeste par un effet **thermique** (échauffement), **chimique** (électrolyseur), **magnétique** (déviation d''une aiguille aimantée) ou **lumineux** (DEL). L''un de ces effets **prouve** qu''un courant passe.
- **Conducteurs, isolants, circuit ouvert.** Un **conducteur** laisse passer le courant, un **isolant** le bloque. Un circuit contenant un isolant est un **circuit ouvert**. Deux conditions pour un courant : un **générateur** + une **chaîne continue de conducteurs**. L''eau et le corps humain sont de **mauvais conducteurs**.
- **Schématiser.** On dessine un circuit avec des **symboles normalisés** (fil, générateur, lampe, moteur, interrupteur, diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre).
- **Sens et nature du courant.** Sens **conventionnel** : de la borne **+** vers la borne **−**, à l''**extérieur** du générateur. Nature : des **électrons** dans les métaux (ils vont en sens inverse, vers la borne +), des **ions** dans les électrolytes (**cations** dans le sens conventionnel, **anions** en sens inverse).
- **Diode et court-circuit.** La **diode** est un dipôle **dissymétrique** : passante (interrupteur fermé) dans un sens, bloquante (interrupteur ouvert) dans l''autre ; la **DEL** émet en plus de la lumière. Un dipôle **court-circuité** (bornes reliées par un fil) est **hors usage** ; court-circuiter un générateur peut l''endommager et causer un **incendie**.', 2, '{"code":"223103P00","pages":"25-42","pageNumbers":[25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', 'L''intensité du courant électrique', 'Associations de dipôles : montage en série et montage en dérivation (parallèle), branche principale et branches dérivées, nœud et maille ; l''intensité du courant I et son unité l''ampère (A) ; l''ampèremètre (bornes A et COM, commutateur, calibre, échelle), son branchement en série et le choix du calibre ; la conservation de l''intensité dans un circuit série ; la loi des nœuds dans un montage en dérivation ; le fusible et les dangers électriques liés à l''intensité', '# 🔋 L''intensité du courant électrique — mesurer le débit

> 💡 «Deux lampes, deux éclats différents : l''une brille fort, l''autre à peine. La différence, c''est l''intensité du courant qui les traverse. Ce chapitre t''apprend à la mesurer et à prévoir sa valeur.»

Tu sais faire circuler un courant. Reste à le **mesurer**. Le courant électrique a un « débit » : son **intensité**. Mais d''abord, il faut savoir de quelle façon les dipôles sont associés.

## 🔗 Série ou dérivation

Avec un générateur et plusieurs dipôles, on distingue **deux sortes de montages** :

| Montage                    | Comment les dipôles sont branchés            |
| -------------------------- | -------------------------------------------- |
| **série**                  | les uns à la suite des autres, en une boucle |
| **dérivation** (parallèle) | sur des branches séparées                    |

Dans un montage en dérivation à un seul générateur :

- la **branche principale** est celle qui contient le **générateur** ;
- les **branches dérivées** sont celles des récepteurs ;
- un **nœud** est un point où se rencontrent **plus de deux branches** ;
- une **maille** est une boucle fermée du circuit.

::: figure Le générateur est sur la branche principale ; les deux lampes sont sur des branches dérivées qui se rejoignent aux nœuds — les points où trois fils se rencontrent
<svg viewBox="0 0 300 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 55 H245"/><path d="M55 150 H245"/>
<path d="M55 55 V85"/><path d="M55 115 V150"/>
<path d="M245 55 V88"/><path d="M245 112 V150"/>
<path d="M150 55 V88"/><path d="M150 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 88 H70"/><path d="M48 110 H62"/></g>
<circle cx="245" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M236.5 91.5 L253.5 108.5 M253.5 91.5 L236.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<circle cx="150" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M141.5 91.5 L158.5 108.5 M158.5 91.5 L141.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<g fill="#dc2626"><circle cx="150" cy="55" r="4.5"/><circle cx="150" cy="150" r="4.5"/></g>
<g font-size="11" font-weight="700" fill="#0f172a">
<text x="30" y="82">+</text>
<text x="55" y="175" text-anchor="middle">branche principale</text>
<text x="198" y="45" text-anchor="middle" fill="#dc2626">nœud</text>
</g>
</svg>
:::

## 📊 L''intensité et l''ampère

Deux piles branchées sur une même lampe la font briller différemment : une grandeur caractérise cette différence, l''**intensité** du courant. Elle est **notée I** et s''exprime, dans le système international, en **ampère** (symbole **A**). On la mesure avec un **ampèremètre** (à aiguille ou numérique).

## 🎛️ Mesurer avec l''ampèremètre

L''ampèremètre se branche **en série**, en respectant ses bornes : le courant entre par la borne **A** (rouge, +) et sort par la borne **COM** (noire, −). Le **calibre** est la **plus grande intensité** que l''appareil peut mesurer.

**Règle du calibre** : on commence par le **plus grand** calibre (aucun risque), puis on descend vers le **plus petit calibre adapté** — c''est lui qui donne la mesure la plus **précise**. Sur un appareil à aiguille, on lit :

$$ Valeur = Lecture × Calibre ÷ Échelle $$

_Exemple détaillé_ : calibre **1 A**, échelle de **100** divisions, aiguille sur la division **40**. Alors Valeur = 40 × 1 ÷ 100 = **0,40 A** ✓.

## ➖ En série : une seule intensité

Insère l''ampèremètre à différents endroits d''un **circuit série** : il indique **toujours la même valeur**.

> 🗡️ **Dans un circuit série, l''intensité du courant est la même en tout point** — quel que soit l''ordre des dipôles. Ajouter un récepteur en série **diminue** cette intensité commune.

Si aucun effet du courant n''apparaît, c''est que l''intensité est **nulle** : il y a une **coupure** quelque part (appareil grillé, fil coupé, mauvais contact).

## ➕ La loi des nœuds

En dérivation, le courant se **partage** aux nœuds. Mesure les intensités de chaque branche : celle de la branche principale est la **somme** de celles des branches dérivées.

::: figure Au nœud, le courant entrant se partage entre les deux branches : 0,90 A d''un côté, 0,65 A et 0,25 A de l''autre, et 0,65 + 0,25 = 0,90
<svg viewBox="0 0 300 160">
<path d="M35 80 H126" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 73 L250 38" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 87 L250 122" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<circle cx="145" cy="80" r="5.5" fill="#dc2626"/>
<defs><marker id="nd" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>
<g font-size="13" font-weight="700" fill="#0f172a">
<text x="55" y="72">I₁ = 0,90 A</text>
<text x="205" y="32">I₂ = 0,65 A</text>
<text x="205" y="140">I₃ = 0,25 A</text>
</g>
<text x="145" y="108" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">nœud</text>
</svg>
:::

**Loi des nœuds** : la somme des intensités des courants qui **arrivent** à un nœud est égale à la somme des intensités des courants qui en **partent**. Ici : I₁ = I₂ + I₃, soit 0,90 = 0,65 + 0,25 ✓.

## 🛡️ Fusible et sécurité

Un **fusible** protège le circuit : c''est un fil qui **fond** dès que l''intensité dépasse une valeur donnée, coupant le courant. L''intensité est aussi une affaire de **sécurité** — le corps humain n''est ni bon conducteur ni isolant :

| Intensité traversant le corps | Conséquence          |
| ----------------------------- | -------------------- |
| 30 mA                         | paralysie musculaire |
| 50 mA                         | asphyxie             |
| 100 mA                        | fibrillation du cœur |

> 🏆 Troisième quête franchie, héros ! Tu sais distinguer série et dérivation, mesurer une intensité au bon calibre, et appliquer la loi des nœuds. Il te manque une dernière grandeur pour tout relier : la **tension**.', '# 📜 Résumé : L''intensité du courant électrique

- **Série ou dérivation.** En **série**, les dipôles sont branchés les uns à la suite des autres ; en **dérivation** (parallèle), sur des branches séparées. La **branche principale** contient le générateur, les **branches dérivées** les récepteurs. Un **nœud** est un point de rencontre de plus de deux branches ; une **maille** est une boucle fermée.
- **L''intensité et l''ampère.** L''**intensité** du courant, notée **I**, se mesure en **ampère (A)** à l''aide d''un **ampèremètre**.
- **Mesurer avec l''ampèremètre.** Il se branche **en série** ; le courant entre par la borne **A (+)** et sort par **COM (−)**. Le **calibre** est la plus grande intensité mesurable ; on part du **plus grand** calibre puis on descend au **plus petit adapté** (le plus précis). Sur un appareil à aiguille : **Valeur = Lecture × Calibre ÷ Échelle** (ex. 40 × 1 ÷ 100 = 0,40 A).
- **En série : une seule intensité.** Dans un circuit **série**, l''intensité est **la même en tout point**, quel que soit l''ordre des dipôles ; ajouter un récepteur en série la **diminue**. Une intensité **nulle** signale une **coupure**.
- **La loi des nœuds.** En dérivation, le courant se partage aux nœuds : la somme des intensités **arrivant** à un nœud égale la somme de celles qui en **partent**. Ainsi I₁ = I₂ + I₃ (0,90 A = 0,65 A + 0,25 A).
- **Fusible et sécurité.** Un **fusible** fond dès que l''intensité dépasse un seuil et coupe le courant. Pour le corps humain : 30 mA → paralysie, 50 mA → asphyxie, 100 mA → fibrillation cardiaque.', 3, '{"code":"223103P00","pages":"43-56","pageNumbers":[43,44,45,46,47,48,49,50,51,52,53,54,55,56]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', 'La tension électrique', 'La tension électrique et son unité le volt (V) ; le voltmètre et son branchement en dérivation (bornes V et COM) ; la tension aux bornes d''un dipôle isolé (non nulle pour un générateur, nulle pour un récepteur) ; force électromotrice (tension à vide) et tension nominale ; la tension en circuit fermé ; le caractère algébrique de la tension, la notation UAB et la relation UAB = −UBA ; la loi des mailles ; l''oscilloscope et la tension continue', '# ⚡ La tension électrique — la « pression » qui pousse le courant

> 💡 «Sur une pile, il est écrit 4,5 V ; sur une lampe, 3 V. Ce « V », c''est le volt, l''unité de la tension. Ce chapitre t''explique ce que mesure cette valeur — et pourquoi elle peut être négative.»

Tu sais mesurer le débit du courant (l''intensité). Voici la seconde grandeur clé : la **tension**. C''est elle qui caractérise un dipôle par ses bornes, et qui explique pourquoi un courant circule.

## ⚡ La tension et le volt

Les indications « 1,5 V », « 4,5 V », « 220 V » sur les piles, les lampes ou le compteur désignent une **tension**. La tension caractérise un dipôle **par ses deux bornes**. Elle est **notée U**, s''exprime en **volt** (symbole **V**) et se mesure avec un **voltmètre**.

## 🔀 Le voltmètre en dérivation

Contrairement à l''ampèremètre, le voltmètre se branche **en dérivation**, c''est-à-dire **aux bornes** du dipôle. Le courant entre par la borne **V** (rouge, +) et la borne **COM** (noire, −) se relie à l''autre borne.

::: figure Le voltmètre est branché en dérivation : ses deux fils rejoignent directement les deux bornes de la lampe, sans couper le circuit
<svg viewBox="0 0 300 165">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M35 55 H100"/><path d="M140 55 H265"/>
<path d="M85 55 V115"/><path d="M85 115 H105"/>
<path d="M155 55 V115"/><path d="M155 115 H135"/>
</g>
<circle cx="120" cy="55" r="18" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M107 42 L133 68 M133 42 L107 68" stroke="#0f172a" stroke-width="1.3"/>
<g fill="#0f172a"><circle cx="85" cy="55" r="3.5"/><circle cx="155" cy="55" r="3.5"/></g>
<circle cx="120" cy="115" r="16" fill="#e0e7ff" stroke="#0f172a" stroke-width="2"/>
<text x="120" y="121" font-size="15" font-weight="700" fill="#0f172a" text-anchor="middle">V</text>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="120" y="27">lampe</text><text x="120" y="150">voltmètre</text>
</g>
</svg>
:::

## 🔌 Dipôle isolé : générateur ou récepteur

Mesure la tension aux bornes d''un dipôle **isolé** (non branché dans un circuit). Deux cas :

- aux bornes d''un **générateur** (une pile), la tension est **non nulle** ;
- aux bornes d''un **récepteur** (lampe, moteur, diode) isolé, la tension est **nulle**.

C''est un test : **un dipôle isolé dont la tension n''est pas nulle est un générateur.**

Deux mots à ne pas confondre :

- la **force électromotrice (f.é.m.)** : la tension d''un générateur **à vide** (non branché à un récepteur) ;
- la **tension nominale** : la tension qu''il faut appliquer à un **récepteur** pour qu''il fonctionne normalement. En dessous, il fonctionne mal ; **au-dessus, il se détériore**.

## ➕➖ La tension est algébrique

Inverse les branchements d''un voltmètre numérique : il affiche la **même valeur, mais négative**. La **tension est une grandeur algébrique** : elle peut être positive ou négative.

On note **UAB** la tension aux bornes d''un dipôle placé entre A et B, mesurée quand la borne **V** est reliée à A et **COM** à B. On la représente par une **flèche allant de B vers A**. Inverser les points inverse le signe :

$$ UAB = −UBA $$

La tension UAB est aussi appelée **différence de potentiel** (d.d.p.), notée VA − VB.

> ⚠️ Piège classique : « l''unité de la tension est le voltmètre ». Non ! L''unité est le **volt (V)** ; le **voltmètre** est l''appareil de mesure. Ne confonds pas la grandeur et l''instrument.

## 🔄 La loi des mailles

Aux bornes d''un **fil** parcouru par un courant, la tension est **nulle**. Sur une **maille** (une boucle fermée), les tensions se compensent :

> 🗡️ **Loi des mailles** : dans une maille, la **somme algébrique** des tensions aux bornes des différents dipôles est **nulle**.

_Exemple détaillé_ : un générateur de tension U = 6 V alimente deux lampes en série, de tensions U₁ et U₂. La loi des mailles donne U = U₁ + U₂. Si U₁ = 2 V, alors U₂ = 6 − 2 = **4 V** ✓.

::: figure Autour de la maille, la tension du générateur se répartit sur les deux lampes : U = U₁ + U₂, soit 6 = 2 + 4
<svg viewBox="0 0 320 175">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 50 V78"/><path d="M55 112 V150"/>
<path d="M55 50 H115"/><path d="M155 50 H205"/><path d="M245 50 H265"/>
<path d="M265 50 V150"/><path d="M55 150 H265"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 85 H70"/><path d="M48 106 H62"/></g>
<circle cx="135" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M124 39 L146 61 M146 39 L124 61" stroke="#0f172a" stroke-width="1.3"/>
<circle cx="225" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M214 39 L236 61 M236 39 L214 61" stroke="#0f172a" stroke-width="1.3"/>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="30" y="90">+</text>
<text x="90" y="172" text-anchor="start">U = 6 V (générateur)</text>
<text x="135" y="90">U₁ = 2 V</text>
<text x="225" y="90">U₂ = 4 V</text>
</g>
</svg>
:::

## 📉 L''oscilloscope et la tension continue

Un **oscilloscope** permet de **visualiser** une tension et d''en mesurer la valeur. Branche une pile plate à son entrée : l''écran affiche un **trait horizontal**. Cela signifie que la tension **ne varie pas au cours du temps** : c''est une **tension continue**.

> 🏆 Dernière quête du thème L''ÉLECTRICITÉ franchie, héros ! Tu sais mesurer une tension au voltmètre, distinguer générateur et récepteur, manier son signe et appliquer la loi des mailles. Intensité et tension en main, tu es prêt pour la suite : la caractéristique d''un dipôle.', '# 📜 Résumé : La tension électrique

- **La tension et le volt.** La **tension**, notée **U**, caractérise un dipôle par ses deux bornes. Elle s''exprime en **volt (V)** et se mesure avec un **voltmètre**.
- **Le voltmètre en dérivation.** Le voltmètre se branche **en dérivation**, aux bornes du dipôle : borne **V (+)** d''un côté, borne **COM (−)** de l''autre. (À l''inverse de l''ampèremètre, qui se branche en série.)
- **Dipôle isolé.** Aux bornes d''un **générateur** isolé, la tension est **non nulle** ; aux bornes d''un **récepteur** isolé, elle est **nulle** — c''est un test pour les distinguer. La **f.é.m.** est la tension d''un générateur **à vide** ; la **tension nominale** est celle qu''il faut appliquer à un récepteur pour qu''il fonctionne normalement (une tension trop grande le **détériore**).
- **La tension est algébrique.** Elle peut être positive ou négative : **UAB = −UBA**. On la note **UAB** (borne V reliée à A, COM reliée à B) et on la représente par une **flèche de B vers A**. C''est aussi la **différence de potentiel** VA − VB.
- **La loi des mailles.** Sur une **maille** (boucle fermée), la **somme algébrique** des tensions aux bornes des dipôles est **nulle**. Ainsi, pour un générateur (U) alimentant deux lampes en série : U = U₁ + U₂ (par exemple 6 V = 2 V + 4 V). La tension aux bornes d''un simple fil est nulle.
- **L''oscilloscope et la tension continue.** L''**oscilloscope** visualise une tension. Un **trait horizontal** à l''écran signale une tension qui ne varie pas dans le temps : une **tension continue**.', 4, '{"code":"223103P00","pages":"57-70","pageNumbers":[57,58,59,60,61,62,63,64,65,66,67,68,69,70]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23efe879-f28b-5f02-9781-87c73bbf943c', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le phénomène d''électrisation', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cd81dc68-012d-5b7b-933f-d7435246ca21', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Un bâton frotté avec de la laine est repoussé par un bâton en verre lui aussi électrisé. Quel est le signe de la charge portée par ce bâton ?', '[{"id":"a","text":"Positive (+)"},{"id":"b","text":"Négative (−)"},{"id":"c","text":"Nulle"},{"id":"d","text":"Positive ou négative selon la distance"}]'::jsonb, 'a', 'La convention se lit par rapport au verre : un corps qui repousse le verre électrisé porte une charge positive ✓. Deux corps qui se repoussent portent des charges de même signe, et le verre définit justement le signe +. Le bâton attiré par le verre, lui, serait négatif — c''est la confusion la plus fréquente. La répulsion ne signifie pas non plus que le corps est neutre, et le signe d''une charge ne dépend pas de la distance.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a86d19a9-30d9-5c8d-90d6-d731fd8c3612', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Deux boules chargées de même signe sont approchées l''une de l''autre. Que se passe-t-il ?', '[{"id":"a","text":"Elles s''attirent"},{"id":"b","text":"Elles se repoussent"},{"id":"c","text":"Elles restent sans action l''une sur l''autre"},{"id":"d","text":"Elles se neutralisent aussitôt"}]'::jsonb, 'b', 'Deux corps chargés d''électricité de même signe se repoussent ✓ ; ce sont les signes contraires qui s''attirent — inverser les deux est le piège classique. Deux corps chargés exercent toujours une interaction : ils ne restent donc pas sans action l''un sur l''autre. Et un simple rapprochement, sans contact, ne neutralise pas les charges.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba093546-03bb-5f48-b5ab-332a4678ebf6', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Au cours d''un frottement, un corps reçoit des électrons venus d''un autre corps. Comment se charge-t-il ?', '[{"id":"a","text":"Positivement"},{"id":"b","text":"Négativement"},{"id":"c","text":"Il reste neutre"},{"id":"d","text":"Il se décharge entièrement"}]'::jsonb, 'b', 'L''électron porte une charge négative : le corps qui en reçoit se retrouve avec un excès de charges négatives, donc chargé négativement ✓. C''est le corps qui cède ses électrons qui devient positif — ne pas inverser les deux. Recevoir des charges ne laisse pas le corps neutre, et l''électrisation charge le corps, elle ne le décharge pas.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4020c7c3-42ec-5666-ac02-4a7c928298c3', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Parmi ces quatre matériaux, lequel est un conducteur ?', '[{"id":"a","text":"Le verre"},{"id":"b","text":"Le plexiglas"},{"id":"c","text":"Le cuivre"},{"id":"d","text":"Le bois"}]'::jsonb, 'c', 'Le cuivre laisse circuler les électrons : c''est un conducteur ✓, au même titre que l''aluminium et le carbone. Le verre, le plexiglas et le bois sont au contraire des isolants : la charge y reste localisée là où elle apparaît, sans se propager. On peut les électriser par frottement, mais leur charge ne circule pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01ce9519-615d-5193-a9ed-164d0b5a072d', '23efe879-f28b-5f02-9781-87c73bbf943c', 'On met en contact une boule neutre avec un bâton chargé négativement. Que devient la boule ?', '[{"id":"a","text":"Elle se charge positivement"},{"id":"b","text":"Elle reste neutre"},{"id":"c","text":"Elle se décharge dans l''air"},{"id":"d","text":"Elle se charge négativement"}]'::jsonb, 'd', 'Lors d''une électrisation par contact, le corps touché prend une charge de même signe que le corps électrisant : touchée par un bâton négatif, la boule devient négative ✓. Elle ne prend pas le signe opposé — c''est l''erreur courante, confondre contact et attraction. Le contact avec un corps chargé ne la laisse pas neutre, et il n''y a ici aucune décharge dans l''air.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('825c0e36-76ff-5ed0-807a-767423c8d266', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', '⭐ Exercice : Premiers pas dans l''électrisation', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d08bd409-bb8d-5a8c-95ab-629c0f9a422f', '825c0e36-76ff-5ed0-807a-767423c8d266', 'À quoi sert un pendule électrostatique ?', '[{"id":"a","text":"À détecter si un corps est électrisé"},{"id":"b","text":"À mesurer la masse d''un corps"},{"id":"c","text":"À produire de l''électricité"},{"id":"d","text":"À mesurer une longueur"}]'::jsonb, 'a', 'Le pendule électrostatique est une petite boule légère suspendue à un fil : approchée d''un corps électrisé, elle est attirée. Il sert donc à détecter la présence d''une charge ✓. Il ne pèse rien, ne mesure aucune longueur, et ne produit pas d''électricité : c''est un détecteur, pas une source.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Comment rend-on une règle en plastique capable d''attirer de petits morceaux de papier ?', '[{"id":"a","text":"En la chauffant"},{"id":"b","text":"En la frottant avec un tissu"},{"id":"c","text":"En la mouillant"},{"id":"d","text":"En la refroidissant"}]'::jsonb, 'b', 'En la frottant avec un tissu (laine, coton…), on l''électrise : sa surface devient capable d''attirer les corps légers ✓. C''est le frottement, et lui seul, qui charge la règle ici. La chauffer ou la refroidir ne l''électrise pas ; la mouiller la rendrait au contraire mauvais isolant et ferait fuir la charge.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Un corps est attiré par un bâton en verre électrisé. Quel est le signe de sa charge ?', '[{"id":"a","text":"Positive"},{"id":"b","text":"Négative"},{"id":"c","text":"Nulle"},{"id":"d","text":"Elle n''a pas de signe"}]'::jsonb, 'b', 'Par convention, un corps attiré par le verre électrisé porte une charge négative ✓ : l''attraction traduit des signes contraires, et le verre est positif. Un corps repoussé par le verre serait au contraire positif. L''attraction prouve que le corps est bien chargé, donc sa charge n''est ni nulle ni sans signe.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2058a83d-ec8d-53f0-861d-a626c400a934', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Dans le système international, la charge électrique q d''un corps s''exprime en :', '[{"id":"a","text":"Ampère (A)"},{"id":"b","text":"Volt (V)"},{"id":"c","text":"Coulomb (C)"},{"id":"d","text":"Newton (N)"}]'::jsonb, 'c', 'La charge, notée q, est une grandeur mesurable dont l''unité SI est le coulomb, de symbole C ✓. L''ampère mesure une intensité, le volt une tension et le newton une force : aucun ne convient pour une charge.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bef91dee-3629-5e84-bade-c7522a85fb50', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Quand on approche un corps électrisé d''un autre corps sans le toucher, et que ce dernier voit ses charges se réorganiser, on parle d''électrisation par :', '[{"id":"a","text":"Frottement"},{"id":"b","text":"Contact"},{"id":"c","text":"Conduction"},{"id":"d","text":"Influence"}]'::jsonb, 'd', 'Agir à distance, sans contact, en approchant simplement un corps chargé, c''est l''électrisation par influence ✓ — c''est ainsi que fonctionne l''électroscope. Le frottement suppose un contact frotté et le contact un simple attouchement : tous deux exigent de toucher. « Conduction » n''est pas un mode d''électrisation du chapitre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbba134a-f585-5325-9050-883b9fced6ef', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Quelle est la valeur de la charge élémentaire e ?', '[{"id":"a","text":"1,6 × 10⁻¹⁹ C"},{"id":"b","text":"1,6 × 10¹⁹ C"},{"id":"c","text":"3,2 × 10⁻¹⁹ C"},{"id":"d","text":"1,6 × 10⁻¹² C"}]'::jsonb, 'a', 'La charge élémentaire vaut e = 1,6 × 10⁻¹⁹ C ✓ ; la charge d''un électron est −e. Attention à l''exposant : il est négatif (10⁻¹⁹, une très petite charge), pas positif. La valeur 3,2 × 10⁻¹⁹ C correspondrait à deux charges élémentaires, et 10⁻¹² est un tout autre ordre de grandeur.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Charges, conducteurs et décharges', 2, 75, 15, 'practice', 'admin', 3)
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
  ('680466e0-720b-5f2b-b901-9d1549225955', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Par temps sec, une baguette en verre frottée et tenue à la main garde sa charge, alors qu''une baguette en cuivre frottée et tenue à la main la perd. Comment l''expliquer ?', '[{"id":"a","text":"Le cuivre est conducteur, le verre est isolant"},{"id":"b","text":"Le verre est conducteur, le cuivre est isolant"},{"id":"c","text":"Le cuivre ne peut pas être électrisé"},{"id":"d","text":"Le verre est plus léger que le cuivre"}]'::jsonb, 'a', 'Le cuivre est un conducteur : sa charge circule et s''écoule à travers la main de l''expérimentateur, si bien que la baguette se décharge ✓. Le verre est un isolant : sa charge reste localisée et ne peut pas s''échapper par la main, donc elle demeure. Inverser les deux natures donne l''option b, fausse. Le cuivre s''électrise très bien, et la masse n''a rien à voir avec la conservation de la charge.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65d44468-4c57-58f6-988e-b41cffdbf06d', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Lors d''une décharge électrique entre deux corps chargés de signes contraires, dans quel sens les électrons traversent-ils l''air ?', '[{"id":"a","text":"Du corps positif vers le corps négatif"},{"id":"b","text":"Dans les deux sens à la fois"},{"id":"c","text":"Du corps négatif vers le corps positif"},{"id":"d","text":"Ils restent immobiles"}]'::jsonb, 'c', 'Les électrons portent une charge négative et se déplacent du corps chargé négativement vers le corps chargé positivement ✓ : c''est ce déplacement à travers l''air qui constitue la décharge, matérialisée par l''étincelle. Ils ne vont pas dans l''autre sens (ce serait le sens conventionnel du courant, étudié plus loin), ni dans les deux à la fois, et une décharge est justement un déplacement de charges, non une immobilité.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0be8d0a3-98bf-5aa1-89f0-997374ec0922', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'En cas d''orage, pourquoi une voiture constitue-t-elle un bon abri ?', '[{"id":"a","text":"Parce que ses pneus en caoutchouc l''isolent du sol"},{"id":"b","text":"Parce qu''elle roule plus vite que la foudre"},{"id":"c","text":"Parce que sa carrosserie métallique forme une cage de Faraday"},{"id":"d","text":"Parce que le verre des vitres arrête la foudre"}]'::jsonb, 'c', 'La carrosserie métallique de la voiture forme une cage de Faraday : le champ électrique reste nul à l''intérieur et les occupants sont protégés, même si la foudre frappe le véhicule ✓. Ce ne sont pas les pneus qui protègent — c''est la croyance courante, mais une décharge capable de traverser des kilomètres d''air n''est pas arrêtée par quelques centimètres de caoutchouc. La vitesse du véhicule et le verre des vitres n''y jouent aucun rôle.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Pourquoi installe-t-on au sommet d''un bâtiment un paratonnerre en forme de pointe métallique reliée à la Terre ?', '[{"id":"a","text":"La pointe repousse la foudre au loin"},{"id":"b","text":"À la pointe, les charges se concentrent et la décharge est facilitée vers le sol"},{"id":"c","text":"Le métal empêche toute décharge de se produire"},{"id":"d","text":"La pointe isole le bâtiment du sol"}]'::jsonb, 'b', 'C''est l''effet de pointe : au bout d''une pointe, les charges d''un corps électrisé s''accumulent très fortement et la décharge y est facilitée ✓. Le paratonnerre capte donc la foudre de préférence et, étant relié à la Terre, il conduit les charges vers le sol sans danger. La pointe ne repousse pas la foudre, elle l''attire ; le métal ne bloque pas la décharge, il la canalise ; et le paratonnerre est justement relié au sol, non isolé de lui.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('719be2dd-43e5-5a01-9a87-5d3229436d1e', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Après frottement à la laine, un bâton en verre repousse un bâton en plexiglas, et ce bâton en plexiglas attire un bâton en ébonite. Quelle interaction s''exerce entre le verre et l''ébonite ?', '[{"id":"a","text":"Ils se repoussent"},{"id":"b","text":"Ils s''attirent"},{"id":"c","text":"Ils n''ont aucune action l''un sur l''autre"},{"id":"d","text":"L''ébonite est forcément neutre"}]'::jsonb, 'b', 'On enchaîne les deux règles. Le verre repousse le plexiglas : même signe, donc le plexiglas est positif comme le verre. Le plexiglas attire l''ébonite : signes contraires, donc l''ébonite est négative. Le verre (+) et l''ébonite (−) sont de signes contraires : ils s''attirent ✓. Ils ne se repoussent donc pas, et l''ébonite, attirée par un corps chargé, n''est pas neutre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Un bâton chargé attire une boule métallique légère initialement neutre, avant même tout contact. Comment expliquer cette attraction ?', '[{"id":"a","text":"La boule était en réalité déjà chargée avant l''approche"},{"id":"b","text":"Un corps chargé attire indifféremment tout objet, sans raison"},{"id":"c","text":"La boule s''est chargée par frottement avec l''air"},{"id":"d","text":"Par influence : les charges de la boule se réorganisent et l''attraction l''emporte"}]'::jsonb, 'd', 'C''est l''électrisation par influence. Le bâton attire vers sa face proche les charges de signe opposé de la boule et repousse vers la face éloignée les charges de même signe. La boule reste globalement neutre, mais les charges attirées sont plus proches que les charges repoussées : l''attraction l''emporte sur la répulsion, d''où le mouvement ✓. La boule n''était pas chargée au départ, et un corps chargé n''attire pas « sans raison » : c''est cette réorganisation qui l''explique. Le frottement avec l''air n''intervient pas.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le circuit électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('593f42be-93b1-539f-9322-a8d575e1a230', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Qu''est-ce qu''un dipôle électrique ?', '[{"id":"a","text":"Un composant électrique qui possède deux bornes"},{"id":"b","text":"Un composant électrique qui possède une seule borne"},{"id":"c","text":"Un composant électrique qui possède trois bornes"},{"id":"d","text":"Un composant qui produit toujours de la lumière"}]'::jsonb, 'a', 'Un dipôle est un composant électrique muni de deux bornes de connexion ✓ : une pile, une lampe et un moteur sont des dipôles. Ce n''est ni un composant à une seule borne ni à trois bornes, et produire de la lumière n''est pas ce qui définit un dipôle (une lampe éclaire, un interrupteur non, et tous deux sont des dipôles).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e471922a-f642-51a7-bb9e-033148f07ab8', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Dans un circuit, quel dipôle est responsable de l''apparition du courant électrique ?', '[{"id":"a","text":"La lampe"},{"id":"b","text":"Le moteur"},{"id":"c","text":"Le générateur"},{"id":"d","text":"L''interrupteur"}]'::jsonb, 'c', 'Le générateur (la pile) est le dipôle qui fait apparaître le courant dans le circuit ✓. La lampe et le moteur sont des récepteurs : ils utilisent le courant mais ne peuvent pas le créer. L''interrupteur ne fait qu''ouvrir ou fermer le circuit ; il ne produit aucun courant.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e6ae6bc1-5f41-5427-8663-966a9f69011b', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Une aiguille aimantée dévie lorsqu''on l''approche d''un fil parcouru par un courant. Quel effet du courant est ainsi mis en évidence ?', '[{"id":"a","text":"L''effet thermique"},{"id":"b","text":"L''effet chimique"},{"id":"c","text":"L''effet lumineux"},{"id":"d","text":"L''effet magnétique"}]'::jsonb, 'd', 'La déviation d''une aiguille aimantée révèle l''effet magnétique du courant ✓. L''effet thermique se traduit par un échauffement, l''effet chimique par une transformation de la matière (électrolyseur), l''effet lumineux par une émission de lumière : aucun ne fait dévier une aiguille aimantée.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3219b52c-4050-536e-a787-d88a78e20a56', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'À l''extérieur du générateur, dans quel sens le courant conventionnel circule-t-il ?', '[{"id":"a","text":"De la borne − vers la borne +"},{"id":"b","text":"De la borne + vers la borne −"},{"id":"c","text":"Dans les deux sens à la fois"},{"id":"d","text":"Le courant n''a pas de sens"}]'::jsonb, 'b', 'Par convention, à l''extérieur du générateur, le courant circule de la borne positive (+) vers la borne négative (−) ✓. Le sens inverse est celui du déplacement réel des électrons dans les métaux, pas celui du courant conventionnel. Le courant a bien un sens déterminé, unique à un instant donné.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16e4af28-858b-50dd-ab76-15ff08bd3a3d', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Dans une solution ionique (électrolyte), à quoi correspond le passage du courant électrique ?', '[{"id":"a","text":"Au déplacement d''électrons"},{"id":"b","text":"Au déplacement d''atomes neutres"},{"id":"c","text":"Au déplacement d''ions"},{"id":"d","text":"Au déplacement de photons"}]'::jsonb, 'c', 'Dans une solution ionique, le courant est un déplacement ordonné d''ions : les cations (positifs) dans le sens conventionnel, les anions (négatifs) en sens inverse ✓. Ce sont les électrons qui portent le courant dans les métaux, pas dans les électrolytes. Des atomes neutres ne transportent aucune charge, et les photons sont des grains de lumière, sans rôle ici.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4c945492-15a7-5744-b8d4-aca03ae96823', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', '⭐ Exercice : Construire et lire un circuit', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', '4c945492-15a7-5744-b8d4-aca03ae96823', 'On intercale un objet isolant dans la chaîne d''un circuit. Comment devient ce circuit ?', '[{"id":"a","text":"Un circuit fermé"},{"id":"b","text":"Un court-circuit"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Un circuit ouvert"}]'::jsonb, 'd', 'Un isolant bloque le courant : la chaîne n''est plus continue, le circuit est ouvert et aucun courant ne circule ✓. Ce n''est donc pas un circuit fermé (qui exige une chaîne continue de conducteurs). Un court-circuit est tout autre chose (des bornes reliées par un fil), et un circuit n''est jamais un « générateur ».', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', '4c945492-15a7-5744-b8d4-aca03ae96823', 'La lampe et le moteur utilisent le courant pour fonctionner mais ne peuvent pas le créer. Comment appelle-t-on ces dipôles ?', '[{"id":"a","text":"Des générateurs"},{"id":"b","text":"Des conducteurs"},{"id":"c","text":"Des récepteurs"},{"id":"d","text":"Des isolants"}]'::jsonb, 'c', 'Un dipôle qui utilise le courant pour fonctionner est un récepteur ✓ : la lampe et le moteur en sont. Le générateur, lui, fait apparaître le courant : c''est le rôle inverse. « Conducteur » et « isolant » qualifient l''aptitude à laisser passer le courant, pas le rôle du dipôle dans le circuit.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eaded567-35c8-5e33-8c78-4390a0158224', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Le filament d''une lampe s''échauffe fortement lorsqu''elle brille. Quel effet du courant cela met-il en évidence ?', '[{"id":"a","text":"L''effet thermique"},{"id":"b","text":"L''effet magnétique"},{"id":"c","text":"L''effet chimique"},{"id":"d","text":"L''effet lumineux"}]'::jsonb, 'a', 'L''échauffement d''un conducteur traduit l''effet thermique du courant ✓. L''effet magnétique fait dévier une aiguille aimantée, l''effet chimique transforme la matière dans un électrolyseur : ni l''un ni l''autre n''est un échauffement. La lampe produit aussi de la lumière (effet lumineux), mais la question porte ici sur l''échauffement du filament.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Une diode branchée dans le sens passant se comporte comme :', '[{"id":"a","text":"Un interrupteur fermé"},{"id":"b","text":"Un interrupteur ouvert"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Un isolant en toute circonstance"}]'::jsonb, 'a', 'Dans le sens passant, la diode laisse circuler le courant : elle agit comme un interrupteur fermé ✓. Dans le sens bloquant, au contraire, elle se comporte comme un interrupteur ouvert. Elle ne produit jamais de courant (ce n''est pas un générateur) et n''est pas isolante en permanence : tout dépend du sens de branchement.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ea325711-a531-5ac4-820b-d0830db1e4e8', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Lequel de ces objets, intercalé dans un circuit, permet à la lampe de rester allumée ?', '[{"id":"a","text":"Une règle en plastique"},{"id":"b","text":"Un objet métallique"},{"id":"c","text":"Un morceau de verre"},{"id":"d","text":"Un bâton en bois"}]'::jsonb, 'b', 'Un objet métallique est un conducteur : il laisse passer le courant, la lampe reste allumée ✓. Le plastique, le verre et le bois sont des isolants : ils ouvrent le circuit et la lampe s''éteint.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Dans un fil métallique parcouru par un courant, dans quel sens se déplacent les électrons ?', '[{"id":"a","text":"Dans le sens conventionnel du courant"},{"id":"b","text":"Dans les deux sens à la fois"},{"id":"c","text":"En sens inverse du courant conventionnel"},{"id":"d","text":"Ils restent immobiles"}]'::jsonb, 'c', 'Les électrons sont négatifs : ils se déplacent en sens inverse du sens conventionnel du courant, c''est-à-dire vers la borne + du générateur ✓. Le sens conventionnel a été fixé avant qu''on ne connaisse les électrons, d''où cette opposition. Les électrons se déplacent bien (ils ne sont pas immobiles) et tous dans le même sens.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1f35f50b-4457-5031-8b0c-fdde34926782', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Effets, sens et dangers du courant', 2, 75, 15, 'practice', 'admin', 3)
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
  ('296021ad-7e08-546c-9dbe-aaae56fd29e9', '1f35f50b-4457-5031-8b0c-fdde34926782', 'À quelles deux conditions un circuit électrique est-il parcouru par un courant ?', '[{"id":"a","text":"Un générateur et une chaîne continue de conducteurs"},{"id":"b","text":"Un récepteur et une chaîne interrompue"},{"id":"c","text":"Au moins deux lampes montées en série"},{"id":"d","text":"Un interrupteur ouvert dans la chaîne"}]'::jsonb, 'a', 'Un courant circule si, et seulement si, le circuit comporte un dipôle générateur et forme une chaîne continue de conducteurs ✓. Sans générateur, rien n''impose le courant ; sans chaîne continue (chaîne interrompue ou interrupteur ouvert), le circuit est ouvert. Le nombre de lampes n''a rien à voir avec ces deux conditions.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e4d55829-3d13-5138-81d0-18c228a57299', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Dans une solution ionique parcourue par un courant, dans quel sens se déplacent les cations (ions positifs) ?', '[{"id":"a","text":"En sens inverse du courant conventionnel"},{"id":"b","text":"Dans le sens conventionnel du courant"},{"id":"c","text":"Ils ne se déplacent pas"},{"id":"d","text":"Tantôt dans un sens, tantôt dans l''autre"}]'::jsonb, 'b', 'Les cations, positifs, se déplacent dans le sens conventionnel du courant, c''est-à-dire vers la borne − du générateur ✓. Ce sont les anions (négatifs) et les électrons qui se déplacent en sens inverse, vers la borne +. Dans un électrolyte parcouru par un courant, les ions se déplacent bien, chacun dans un sens déterminé.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7facd2a5-4bfd-50c2-a843-4959d28528c5', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Près d''un composant d''un circuit, une aiguille aimantée dévie. Que peut-on en conclure ?', '[{"id":"a","text":"Le composant est un aimant permanent"},{"id":"b","text":"Aucun courant ne circule dans ce composant"},{"id":"c","text":"Un courant circule dans ce composant"},{"id":"d","text":"Le composant est un isolant"}]'::jsonb, 'c', 'La déviation d''une aiguille aimantée est l''effet magnétique du courant : sa manifestation prouve qu''un courant circule dans le composant ✓. Ce n''est pas la signature d''un aimant permanent (qui dévierait l''aiguille même sans circuit alimenté), et un isolant ne serait traversé par aucun courant, donc ne dévierait pas l''aiguille.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58838187-63ac-5d6a-94ec-0ebfe67c6383', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Deux lampes L1 et L2 sont montées en série. On relie les deux bornes de L1 par un fil de connexion. Que devient L1 ?', '[{"id":"a","text":"Elle brille plus fort"},{"id":"b","text":"Elle s''éteint"},{"id":"c","text":"Elle explose"},{"id":"d","text":"Rien ne change pour elle"}]'::jsonb, 'b', 'En reliant ses deux bornes par un fil, on court-circuite L1 : le courant passe par le fil plutôt que par le filament, qui n''est plus traversé — L1 s''éteint ✓. Un dipôle court-circuité est mis hors usage. Elle ne brille donc pas davantage (c''est L2 qui brillerait plus), et elle n''explose pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('485bc1fd-849e-5f84-88cc-38034411f189', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Une lampe brille dans un circuit contenant une diode montée dans le sens passant. On inverse le sens de la diode. Que devient la lampe ?', '[{"id":"a","text":"Elle brille davantage"},{"id":"b","text":"Elle brille de la même façon"},{"id":"c","text":"Elle s''éteint"},{"id":"d","text":"Elle se met à clignoter"}]'::jsonb, 'c', 'Inversée, la diode est branchée dans le sens bloquant : elle se comporte alors comme un interrupteur ouvert et ne laisse plus passer le courant, la lampe s''éteint ✓. Une diode ne laisse passer le courant que dans un seul sens ; dans l''autre, le circuit est ouvert. La lampe ne peut donc ni briller pareil, ni davantage, ni clignoter.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Pourquoi ne faut-il jamais relier directement les deux bornes d''une pile par un simple fil conducteur ?', '[{"id":"a","text":"Parce que la pile se recharge alors toute seule"},{"id":"b","text":"Parce que le fil se transforme en aimant permanent"},{"id":"c","text":"Parce qu''il ne se passe absolument rien"},{"id":"d","text":"Parce que la pile peut être endommagée et provoquer un incendie"}]'::jsonb, 'd', 'Relier directement les deux bornes d''un générateur, c''est le court-circuiter : un courant très intense s''établit, l''effet thermique devient énorme, la pile peut être endommagée et le fil peut provoquer un incendie ✓. Une pile ne se recharge pas ainsi, le fil ne devient pas un aimant permanent, et il se passe au contraire quelque chose de dangereux.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6d851b3d-7e0a-5089-88e3-e1650983ebe0', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', 'Test de compréhension ⭐ : L''intensité du courant électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('03340da1-e134-5d23-a6da-4fa8758f7d93', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Quelle est l''unité de l''intensité du courant électrique dans le système international ?', '[{"id":"a","text":"Le volt (V)"},{"id":"b","text":"L''ampère (A)"},{"id":"c","text":"Le coulomb (C)"},{"id":"d","text":"Le watt (W)"}]'::jsonb, 'b', 'L''intensité du courant, notée I, s''exprime en ampère, de symbole A ✓. Le volt est l''unité de la tension, le coulomb celle de la charge électrique, et le watt celle d''une puissance : aucun ne mesure une intensité.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b5f857f-c66f-5e1b-9b81-2512f2bf448c', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Comment branche-t-on un ampèremètre pour mesurer l''intensité du courant dans une branche ?', '[{"id":"a","text":"En série"},{"id":"b","text":"En dérivation"},{"id":"c","text":"En court-circuit"},{"id":"d","text":"Aux bornes du générateur uniquement"}]'::jsonb, 'a', 'Un ampèremètre se branche en série dans la branche dont on veut mesurer l''intensité, afin d''être traversé par le même courant qu''elle ✓. Branché en dérivation, il ne mesurerait pas ce courant ; le brancher en court-circuit est dangereux ; et il se place là où l''on veut mesurer, pas seulement aux bornes du générateur.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f965d026-c959-5dbb-959a-627734428969', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Dans un circuit en série, comment se comporte l''intensité du courant d''un point à un autre ?', '[{"id":"a","text":"Elle est plus grande près du générateur"},{"id":"b","text":"Elle est plus grande dans la première lampe"},{"id":"c","text":"Elle est la même en tout point"},{"id":"d","text":"Elle est nulle partout"}]'::jsonb, 'c', 'Dans un circuit série, l''intensité du courant est la même en tout point, quel que soit l''ordre des dipôles ✓ : l''ampèremètre indique la même valeur où qu''on l''insère. Elle n''est donc ni plus forte près du générateur, ni plus forte dans une lampe particulière, et elle n''est nulle que si le circuit est coupé.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Dans un montage en dérivation, la branche principale porte une intensité de 0,90 A. L''une des deux branches dérivées porte 0,65 A. Quelle est l''intensité dans l''autre branche dérivée ?', '[{"id":"a","text":"0,25 A"},{"id":"b","text":"0,65 A"},{"id":"c","text":"0,90 A"},{"id":"d","text":"1,55 A"}]'::jsonb, 'a', 'D''après la loi des nœuds, l''intensité de la branche principale est la somme des intensités des branches dérivées : I₁ = I₂ + I₃, donc 0,90 = 0,65 + I₃, soit I₃ = 0,90 − 0,65 = 0,25 A ✓. La valeur 1,55 A vient d''une addition au lieu d''une soustraction ; 0,90 A et 0,65 A sont des intensités déjà connues, pas celle cherchée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('64fb427c-c19f-5c39-8663-1d3598b6b47c', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Que désigne le calibre d''un ampèremètre ?', '[{"id":"a","text":"La plus petite intensité qu''il peut mesurer"},{"id":"b","text":"Le nombre de divisions de son échelle"},{"id":"c","text":"La valeur exacte affichée par l''aiguille"},{"id":"d","text":"La plus grande intensité qu''il peut mesurer"}]'::jsonb, 'd', 'Le calibre est la plus grande intensité que l''ampèremètre peut mesurer ✓ : on choisit un calibre supérieur à l''intensité attendue pour ne pas détériorer l''appareil. Ce n''est pas la plus petite intensité, ni le nombre de divisions de l''échelle, ni la valeur lue, qui se calcule à partir du calibre et de l''échelle.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1d81c458-1701-5b14-a5fe-009936e9168d', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', '⭐ Exercice : Intensité, calibres et loi des nœuds', 1, 50, 10, 'practice', 'admin', 1)
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
  ('aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Dans un montage en série, comment les dipôles sont-ils branchés ?', '[{"id":"a","text":"Les uns à la suite des autres"},{"id":"b","text":"Sur des branches séparées"},{"id":"c","text":"Chacun directement sur le générateur"},{"id":"d","text":"En étoile autour d''un point central"}]'::jsonb, 'a', 'Dans un montage en série, tous les dipôles sont branchés les uns à la suite des autres, formant une seule boucle ✓. Les brancher sur des branches séparées serait un montage en dérivation (parallèle) : c''est le montage opposé.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8720ecf5-db88-5cdc-a041-489b34b363fa', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Qu''est-ce qu''un nœud dans un circuit électrique ?', '[{"id":"a","text":"Une boucle fermée du circuit"},{"id":"b","text":"Un point de rencontre de plus de deux branches"},{"id":"c","text":"La branche qui contient le générateur"},{"id":"d","text":"Un dipôle muni de deux bornes"}]'::jsonb, 'b', 'Un nœud est un point où se rencontrent plus de deux branches ✓ : c''est là que le courant se partage. Une boucle fermée est une maille, la branche qui contient le générateur est la branche principale, et un dipôle à deux bornes est un composant, pas un nœud.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b561a76-af87-55be-900d-790038fa5101', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Par quelle lettre note-t-on l''intensité du courant électrique ?', '[{"id":"a","text":"U"},{"id":"b","text":"Q"},{"id":"c","text":"I"},{"id":"d","text":"R"}]'::jsonb, 'c', 'L''intensité du courant est notée I ✓ et s''exprime en ampère (A). La lettre U désigne la tension, Q la charge électrique et R la résistance : ce sont d''autres grandeurs.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d07fd26-fb3d-5bf3-9d73-672be638bbfe', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Sur un ampèremètre, par quelle borne le courant doit-il entrer ?', '[{"id":"a","text":"La borne COM (noire, −)"},{"id":"b","text":"N''importe quelle borne"},{"id":"c","text":"Les deux bornes à la fois"},{"id":"d","text":"La borne A (rouge, +)"}]'::jsonb, 'd', 'Le courant doit entrer par la borne A (rouge, notée +) et ressortir par la borne COM (noire, notée −) ✓. Inverser le branchement fausserait l''indication (ou ferait dévier l''aiguille à l''envers). Le sens de branchement de l''ampèremètre n''est donc pas indifférent.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fdfff668-8cea-5ba3-a664-5e4c24672e98', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Un générateur débite une intensité de 80 mA. Dans un montage en dérivation, une branche est traversée par 30 mA. Quelle intensité traverse la seconde branche ?', '[{"id":"a","text":"30 mA"},{"id":"b","text":"50 mA"},{"id":"c","text":"80 mA"},{"id":"d","text":"110 mA"}]'::jsonb, 'b', 'La loi des nœuds donne I = I₁ + I₂, donc 80 = 30 + I₂, soit I₂ = 80 − 30 = 50 mA ✓. La valeur 110 mA proviendrait d''une addition (80 + 30) au lieu d''une soustraction ; 80 mA est l''intensité totale et 30 mA celle déjà connue.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b79494b4-f612-5930-96f7-f80616f6d462', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Dans un circuit en série, que devient l''intensité du courant lorsqu''on ajoute un récepteur supplémentaire ?', '[{"id":"a","text":"Elle augmente"},{"id":"b","text":"Elle reste identique"},{"id":"c","text":"Elle diminue"},{"id":"d","text":"Elle s''annule aussitôt"}]'::jsonb, 'c', 'Ajouter un récepteur en série diminue l''intensité du courant qui parcourt le circuit ✓ : c''est pourquoi trois lampes en série brillent moins que deux. Elle n''augmente pas et ne reste pas identique, et elle ne s''annule que si le circuit est coupé, pas par le simple ajout d''un récepteur.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b224ac1f-0892-5896-afb0-e8e6f7c5501e', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Mesures, loi des nœuds et sécurité', 2, 75, 15, 'practice', 'admin', 3)
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
  ('47981fe7-4f66-5600-afc6-e076e535b7f8', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'À quoi sert un fusible dans une installation électrique ?', '[{"id":"a","text":"À produire de la lumière"},{"id":"b","text":"À augmenter l''intensité du courant"},{"id":"c","text":"À couper le courant en fondant lorsque l''intensité dépasse un seuil"},{"id":"d","text":"À mesurer l''intensité du courant"}]'::jsonb, 'c', 'Un fusible est un fil qui fond dès que l''intensité dépasse une valeur donnée, ce qui coupe le courant et protège le reste du circuit ✓. Il ne produit pas de lumière, n''augmente jamais l''intensité (il la coupe), et ne mesure rien — c''est le rôle de l''ampèremètre.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eaf88d4d-6b20-5533-a3ce-591bdc9a7900', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'À un nœud d''un circuit arrivent deux courants d''intensités 0,30 A et 0,45 A. Un seul courant en repart. Quelle est son intensité ?', '[{"id":"a","text":"0,15 A"},{"id":"b","text":"0,30 A"},{"id":"c","text":"0,45 A"},{"id":"d","text":"0,75 A"}]'::jsonb, 'd', 'La loi des nœuds impose que la somme des intensités qui arrivent égale la somme de celles qui partent : le courant sortant vaut 0,30 + 0,45 = 0,75 A ✓. La valeur 0,15 A viendrait d''une soustraction, tandis que 0,30 A et 0,45 A sont les intensités entrantes, pas la sortante.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a38a704-d473-5ac3-b4c7-993995d4c29f', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Un courant de 100 mA traverse le corps humain. D''après le tableau de sécurité, quelle en est la conséquence ?', '[{"id":"a","text":"Une fibrillation du cœur"},{"id":"b","text":"Une paralysie musculaire"},{"id":"c","text":"Une asphyxie"},{"id":"d","text":"Aucun effet notable"}]'::jsonb, 'a', 'À 100 mA, le courant provoque une fibrillation du cœur ✓, la conséquence la plus grave du tableau. La paralysie musculaire survient dès 30 mA et l''asphyxie vers 50 mA : ces effets apparaissent avant, à des intensités plus faibles. Un courant de 100 mA à travers le corps est loin d''être sans effet.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('53189c58-507c-56b7-903b-5aecf00ddb48', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'On veut mesurer une intensité d''environ 0,02 A avec un ampèremètre offrant les calibres 1 mA, 10 mA, 100 mA, 1 A et 10 A. Quel calibre choisir ?', '[{"id":"a","text":"10 mA"},{"id":"b","text":"100 mA"},{"id":"c","text":"1 A"},{"id":"d","text":"10 A"}]'::jsonb, 'b', 'L''intensité vaut 0,02 A, soit 20 mA. Le calibre doit être supérieur à la valeur mesurée : le calibre 10 mA est trop petit (20 > 10). Parmi les calibres possibles (100 mA, 1 A, 10 A), on choisit le plus petit, qui donne la mesure la plus précise : 100 mA ✓. Les calibres 1 A et 10 A conviendraient mais mesureraient moins finement.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('afff4689-031e-56c8-a4bc-a1bea114a14f', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Un ampèremètre à aiguille est réglé sur le calibre 1 A ; son échelle compte 100 divisions et l''aiguille s''arrête sur la division 40. Quelle intensité indique-t-il ?', '[{"id":"a","text":"0,04 A"},{"id":"b","text":"0,40 A"},{"id":"c","text":"4 A"},{"id":"d","text":"40 A"}]'::jsonb, 'b', 'On applique Valeur = Lecture × Calibre ÷ Échelle = 40 × 1 ÷ 100 = 0,40 A ✓. Oublier de diviser par l''échelle donnerait 40 A ; se tromper d''un facteur 10 donnerait 0,04 A ou 4 A. La valeur mesurée reste toujours inférieure au calibre choisi (ici 1 A).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eeb1aad5-2c6c-50ae-b230-7ca3785764ee', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Une prise est protégée par un fusible de calibre 20 A. On y branche en même temps une machine à laver qui appelle 12 A et une plaque chauffante qui appelle 10 A. Que se passe-t-il ?', '[{"id":"a","text":"Rien de particulier ne se produit"},{"id":"b","text":"La prise fournit automatiquement plus de courant"},{"id":"c","text":"La machine à laver ralentit pour compenser"},{"id":"d","text":"Le fusible fond et coupe le courant"}]'::jsonb, 'd', 'Les deux appareils en dérivation appellent une intensité totale de 12 + 10 = 22 A, supérieure au calibre du fusible (20 A) : le fusible fond et coupe le courant ✓. Le fusible ne « laisse » pas passer davantage que son calibre, et aucun appareil ne ralentit tout seul pour s''adapter — c''est justement le rôle protecteur du fusible d''interrompre le circuit surchargé.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d11513d0-a414-5c0c-91d2-e662b444d896', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', 'Test de compréhension ⭐ : La tension électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('209983c0-a5b5-5ec3-984e-d29485e28584', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Quelle est l''unité de la tension électrique dans le système international ?', '[{"id":"a","text":"Le voltmètre"},{"id":"b","text":"Le volt (V)"},{"id":"c","text":"L''ampère (A)"},{"id":"d","text":"Le coulomb (C)"}]'::jsonb, 'b', 'L''unité de la tension est le volt, de symbole V ✓. Attention au piège : le voltmètre n''est pas une unité, c''est l''appareil qui mesure la tension. L''ampère mesure une intensité et le coulomb une charge : ni l''un ni l''autre n''est l''unité d''une tension.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Comment se branche un voltmètre pour mesurer la tension aux bornes d''un dipôle ?', '[{"id":"a","text":"En dérivation, aux bornes du dipôle"},{"id":"b","text":"En série avec le dipôle"},{"id":"c","text":"En court-circuit sur le dipôle"},{"id":"d","text":"À la place du générateur"}]'::jsonb, 'a', 'Le voltmètre se branche en dérivation, c''est-à-dire directement aux bornes du dipôle, sans couper le circuit ✓. C''est l''ampèremètre, lui, qui se branche en série. Le brancher en court-circuit ou à la place du générateur n''aurait aucun sens pour mesurer une tension.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a45667e8-3ab4-54a0-84b4-11b6aa63abdc', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Aux bornes d''un générateur isolé (non branché dans un circuit), la tension est :', '[{"id":"a","text":"Nulle"},{"id":"b","text":"Toujours négative"},{"id":"c","text":"Non nulle"},{"id":"d","text":"Impossible à mesurer"}]'::jsonb, 'c', 'Aux bornes d''un générateur isolé, la tension est non nulle : elle vaut approximativement la valeur indiquée sur le générateur ✓. C''est justement ce qui distingue un générateur d''un récepteur isolé, dont la tension est nulle. Cette tension se mesure sans difficulté au voltmètre, et rien n''impose qu''elle soit négative.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49bf1bda-7235-598d-9788-41f843be864f', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Que traduit la relation UAB = −UBA ?', '[{"id":"a","text":"La tension est toujours positive"},{"id":"b","text":"UAB et UBA sont toujours égales"},{"id":"c","text":"La tension est nécessairement nulle"},{"id":"d","text":"La tension est une grandeur algébrique (positive ou négative)"}]'::jsonb, 'd', 'La relation UAB = −UBA exprime que la tension est une grandeur algébrique : elle change de signe quand on échange les deux points, donc elle peut être positive ou négative ✓. Elle n''est donc pas toujours positive, et UAB et UBA sont opposées, pas égales (sauf si toutes deux sont nulles).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d431ec8e-8e26-519f-9b15-c24355ed386c', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Dans une maille d''un circuit, que vaut la somme algébrique des tensions aux bornes des différents dipôles ?', '[{"id":"a","text":"Zéro"},{"id":"b","text":"La tension du générateur"},{"id":"c","text":"La somme des intensités"},{"id":"d","text":"La tension nominale d''un récepteur"}]'::jsonb, 'a', 'D''après la loi des mailles, la somme algébrique des tensions aux bornes des dipôles d''une maille est nulle ✓. Ce n''est pas la tension du générateur seule (celle-ci se répartit justement sur les récepteurs), et une somme de tensions ne peut pas donner une somme d''intensités : ce sont des grandeurs différentes.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', '⭐ Exercice : Tension, voltmètre et loi des mailles', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Par quelle lettre note-t-on la tension électrique ?', '[{"id":"a","text":"I"},{"id":"b","text":"U"},{"id":"c","text":"R"},{"id":"d","text":"Q"}]'::jsonb, 'b', 'La tension est notée U ✓ et s''exprime en volt (V). La lettre I désigne l''intensité, R la résistance et Q la charge électrique : ce sont d''autres grandeurs.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5b30ac05-ab65-506e-87b6-14e9d6915203', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Aux bornes de quel dipôle isolé (non branché) mesure-t-on une tension non nulle ?', '[{"id":"a","text":"Une lampe"},{"id":"b","text":"Un moteur"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Une diode"}]'::jsonb, 'c', 'Seul un générateur isolé présente une tension non nulle à ses bornes ✓ ; c''est ce qui permet de le reconnaître. La lampe, le moteur et la diode sont des récepteurs : isolés, la tension à leurs bornes est nulle.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89ad05de-c572-5581-9325-79a511f17280', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Que désigne la tension nominale d''un récepteur ?', '[{"id":"a","text":"La tension maximale avant qu''il ne soit détruit"},{"id":"b","text":"La tension du générateur à vide"},{"id":"c","text":"La tension aux bornes d''un fil conducteur"},{"id":"d","text":"La tension à appliquer pour qu''il fonctionne normalement"}]'::jsonb, 'd', 'La tension nominale est la tension qu''il faut appliquer aux bornes d''un récepteur pour qu''il fonctionne normalement ✓ : en dessous il fonctionne mal, au-dessus il se détériore. Ce n''est donc pas une tension de destruction. La tension à vide est la f.é.m. d''un générateur, et la tension aux bornes d''un fil parcouru par un courant est nulle.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('42cbe483-f5da-5c86-88f4-ff14087d8c9c', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'La tension UAB aux bornes d''un dipôle est représentée par une flèche allant :', '[{"id":"a","text":"De B vers A"},{"id":"b","text":"De A vers B"},{"id":"c","text":"Du pôle + vers le pôle −"},{"id":"d","text":"Du haut vers le bas"}]'::jsonb, 'a', 'Par convention, la tension UAB se représente par une flèche allant de B vers A ✓. Inverser le sens de la flèche reviendrait à considérer UBA = −UAB. Le sens de la flèche est fixé par l''ordre des indices A et B, pas par les pôles du générateur ni par une orientation « haut-bas ».', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21a2da4a-2ccb-57b7-9d1e-64ba4003707b', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Un générateur de tension 6 V alimente deux lampes montées en série. La tension aux bornes de la première lampe est 2 V. Quelle est la tension aux bornes de la seconde ?', '[{"id":"a","text":"2 V"},{"id":"b","text":"4 V"},{"id":"c","text":"6 V"},{"id":"d","text":"8 V"}]'::jsonb, 'b', 'La loi des mailles donne U = U₁ + U₂, donc 6 = 2 + U₂, soit U₂ = 6 − 2 = 4 V ✓. La valeur 8 V viendrait d''une addition (6 + 2) au lieu d''une soustraction ; 6 V est la tension du générateur et 2 V celle de la première lampe.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('faf9e844-3874-512b-9c3f-7d79e45bd9fe', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Sur l''écran d''un oscilloscope, la tension aux bornes d''une pile plate apparaît comme un trait horizontal. Que peut-on en conclure ?', '[{"id":"a","text":"La tension est nulle"},{"id":"b","text":"La tension varie rapidement"},{"id":"c","text":"La tension est continue"},{"id":"d","text":"La tension est très élevée"}]'::jsonb, 'c', 'Un trait horizontal signifie que la tension ne varie pas au cours du temps : c''est une tension continue ✓, celle que délivre une pile. Une tension nulle donnerait un trait sur l''axe (valeur zéro), une tension variable donnerait une courbe qui monte et descend, et la hauteur du trait n''indique pas forcément une valeur élevée.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Tension, signe et loi des mailles', 2, 75, 15, 'practice', 'admin', 3)
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
  ('8104cc1a-7645-50e1-b7e2-04987db22904', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Une lampe est insérée dans un circuit fermé et traversée par un courant. Que peut-on dire de la tension à ses bornes ?', '[{"id":"a","text":"Elle est nulle"},{"id":"b","text":"Elle est non nulle"},{"id":"c","text":"Elle est forcément négative"},{"id":"d","text":"Elle est toujours égale à la tension du générateur"}]'::jsonb, 'b', 'En circuit fermé, un récepteur traversé par un courant présente une tension non nulle à ses bornes ✓, dont la valeur dépend des composants du circuit. C''est différent du récepteur isolé, dont la tension est nulle. Elle n''est pas nécessairement négative, et elle n''égale la tension du générateur que dans des cas particuliers (récepteur seul), pas toujours.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('783d5c76-c42e-5890-9687-67972acd4c70', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'On mesure la tension aux bornes de deux dipôles isolés : le premier donne 4,5 V, le second 0 V. Que peut-on en déduire ?', '[{"id":"a","text":"Le premier est un récepteur, le second un générateur"},{"id":"b","text":"Les deux sont des générateurs"},{"id":"c","text":"Le premier est un générateur, le second un récepteur"},{"id":"d","text":"Les deux sont des récepteurs"}]'::jsonb, 'c', 'Un dipôle isolé dont la tension n''est pas nulle est un générateur, un dipôle isolé de tension nulle est un récepteur : le premier (4,5 V) est donc un générateur, le second (0 V) un récepteur ✓. L''association inverse est fausse, et si les deux étaient de même nature ils donneraient la même sorte d''indication (tous deux non nuls, ou tous deux nuls).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Que désigne la force électromotrice (f.é.m.) d''un générateur ?', '[{"id":"a","text":"Sa tension nominale en fonctionnement"},{"id":"b","text":"La tension aux bornes d''un récepteur"},{"id":"c","text":"La tension aux bornes d''un fil conducteur"},{"id":"d","text":"Sa tension à vide, lorsqu''il n''est branché à aucun récepteur"}]'::jsonb, 'd', 'La force électromotrice est la tension d''un générateur à vide, c''est-à-dire lorsqu''il n''alimente aucun récepteur ✓. La « tension nominale » qualifie un récepteur, pas un générateur ; la tension aux bornes d''un fil parcouru par un courant est nulle. La f.é.m. est bien une caractéristique propre au générateur.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Aux bornes d''un dipôle, un voltmètre indique UAB = 4,5 V. Que vaut alors UBA ?', '[{"id":"a","text":"−4,5 V"},{"id":"b","text":"0 V"},{"id":"c","text":"4,5 V"},{"id":"d","text":"9 V"}]'::jsonb, 'a', 'La tension est algébrique : échanger les indices change le signe, donc UBA = −UAB = −4,5 V ✓. La valeur reste la même en grandeur, mais devient négative. Répondre 4,5 V oublie ce changement de signe ; 0 V et 9 V ne correspondent à aucune règle du chapitre.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Un générateur de tension 6 V alimente trois lampes identiques montées en série. Quelle est la tension aux bornes de chaque lampe ?', '[{"id":"a","text":"2 V"},{"id":"b","text":"3 V"},{"id":"c","text":"6 V"},{"id":"d","text":"18 V"}]'::jsonb, 'a', 'La loi des mailles donne U = U₁ + U₂ + U₃. Les trois lampes étant identiques, elles se partagent également la tension : chacune reçoit U ÷ 3 = 6 ÷ 3 = 2 V ✓. La valeur 18 V viendrait d''une multiplication par 3 au lieu d''une division ; 6 V est la tension totale du générateur, pas celle d''une seule lampe.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Une lampe porte l''indication « 3 V ». On la branche seule aux bornes d''un générateur de 12 V. Que se passe-t-il ?', '[{"id":"a","text":"Elle brille faiblement"},{"id":"b","text":"Elle se détériore"},{"id":"c","text":"Elle fonctionne normalement"},{"id":"d","text":"Rien, la tension n''a aucun effet"}]'::jsonb, 'b', '3 V est la tension nominale de la lampe : c''est la tension à appliquer pour un fonctionnement normal. Sous 12 V, très supérieure à la valeur nominale, la lampe se détériore ✓. Une tension plus faible que la nominale la ferait briller faiblement, mais ici la tension est bien trop grande, ce qui est destructeur : il ne faut jamais éloigner un récepteur de sa tension nominale.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'physique-1ere-sec'
      AND e.source = 'admin';
  END IF;
END $$;

