# ⚡ Le phénomène d'électrisation — quand la matière se charge

> 💡 «Tu tires un pull en laine par temps sec : ça crépite, ça t'attire les cheveux, et parfois une petite étincelle te pique le doigt. Ce chapitre t'explique ce petit choc — et, au passage, l'éclair qui tombe du ciel.»

Bienvenue dans **L'ÉLECTRICITÉ**, héros. Avant les circuits et les piles, il faut comprendre d'où vient l'électricité. Tout part d'un geste banal : **frotter**. Ce chapitre est entièrement **qualitatif** — aucun calcul — mais il pose le modèle sur lequel repose tout le reste du programme.

## 🧲 Électriser un corps

Approche une règle en plexiglas d'une petite boule légère suspendue à un fil de soie — un **pendule électrostatique**. Rien ne bouge. Frotte maintenant cette règle avec un tissu en **laine**, puis approche-la **sans toucher** la boule : **la boule est attirée**.

Le frottement a modifié la surface de la règle : elle est devenue capable d'attirer les corps légers. On dit qu'elle est **électrisée**, ou **chargée d'électricité**. Le verre, le plexiglas, le plastique, le caoutchouc, les métaux, la laine… sont **susceptibles d'être électrisés par frottement**. Le **pendule électrostatique** est notre premier **détecteur** de charge.

## ➕➖ Deux charges, une règle de signe

Frotte deux bâtons en verre : approchés l'un de l'autre, ils **se repoussent**. Frotte un bâton en verre et un bâton en P.V.C : ils **s'attirent**. Il existe donc **deux types de charges électriques**. La convention se lit **par rapport au verre** frotté avec de la laine :

- un corps qui **repousse** le verre électrisé porte une charge **positive (+)** (autrefois « électricité vitrée ») ;
- un corps qui est **attiré** par le verre électrisé porte une charge **négative (−)** (autrefois « électricité résineuse »).

::: figure Deux charges de même signe s'écartent, deux charges de signes contraires se rapprochent : c'est le signe, jamais la seule présence de charge, qui décide
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

Retiens la double loi : **deux corps chargés de même signe se repoussent ; deux corps chargés de signes contraires s'attirent.**

## 🔄 Trois façons d'électriser

Il existe **trois modes d'électrisation** :

| Mode           | Comment                                         | Résultat                                           |
| -------------- | ----------------------------------------------- | -------------------------------------------------- |
| **frottement** | on frotte deux corps l'un contre l'autre        | chaque corps se charge                             |
| **contact**    | un corps électrisé en touche un autre           | le corps touché prend une charge **de même signe** |
| **influence**  | on approche un corps électrisé **sans toucher** | les charges de l'autre corps se réorganisent       |

L'**électroscope** est l'appareil qui, par **influence**, permet de **détecter si un corps qui lui est approché est électrisé ou non** : son aiguille (ou ses feuilles) dévie.

C'est aussi l'**influence** qui explique pourquoi un corps chargé attire même un corps **neutre** (comme la boule du début du chapitre) : il attire vers lui les charges de signe opposé et repousse les charges de même signe. Les charges attirées se retrouvant **plus proches** que les charges repoussées, **l'attraction l'emporte sur la répulsion**.

> 🗡️ Un corps **non frotté et non électrisé par contact** n'agit sur rien : il est **électriquement neutre**. Neutre ne veut pas dire « vide de charges » — tu vas voir pourquoi.

## ⚛️ Le modèle : des électrons qui migrent

Pour tout expliquer, on admet que la matière contient des **porteurs de charges** de deux sortes : les uns portent de l'électricité **positive**, les autres de l'électricité **négative**. Un corps **neutre** en contient des **quantités égales** — d'où sa neutralité.

Lors du frottement, de minuscules porteurs négatifs, les **électrons**, **migrent d'un corps à l'autre** :

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

La charge portée par un corps est une **grandeur mesurable**, notée **q**. Son unité, dans le système international, est le **coulomb** (symbole **C**). La charge d'un seul électron est notée **−e**, où **e** est la **charge élémentaire** :

$$ e = 1,6 × 10⁻¹⁹ C $$

## 🚧 Conducteurs et isolants

Électrise une tige, puis relie-la à la boule du pendule par différents matériaux. Résultat :

- avec le **cuivre**, l'**aluminium** ou le **carbone**, la charge **se propage** : ce sont des **conducteurs**. Ils **laissent circuler les électrons**, et la charge se **répartit sur toute la tige**.
- avec le **bois**, le **verre**, le **P.V.C** ou le **plexiglas**, rien ne passe : ce sont des **isolants**. La charge **reste localisée** là où elle est apparue.

> ⚠️ Piège classique : « le verre est un isolant, donc on ne peut pas l'électriser ». Faux ! On électrise très bien le verre **par frottement** — sa charge reste simplement **localisée** au point frotté, faute de pouvoir circuler.

## ⚡ Décharges, étincelles et foudre

Accumule des charges de signes contraires sur les deux sphères d'une **machine de Wimshurst** : au bout d'un moment, une **étincelle** jaillit avec un **crépitement**. Deux corps très chargés de signes contraires provoquent un **déplacement d'électrons à travers l'air** : c'est une **décharge électrique**. Ces électrons se déplacent **du corps négatif vers le corps positif**. La lueur qui matérialise le canal de la décharge est l'**éclair** ; l'échauffement intense de l'air produit le **crépitement**.

Au bout d'une **pointe**, les charges s'accumulent très fortement et la décharge y est facilitée : c'est l'**effet de pointe**. C'est exactement ce qui se joue dans le ciel : le bas d'un nuage orageux, chargé négativement, provoque une décharge vers le sol — la **foudre** ; le bruit qui suit est le **tonnerre**. Une grosse pointe métallique reliée à la Terre, le **paratonnerre**, capte la foudre et la conduit au sol. Et la carrosserie métallique d'une voiture forme une **cage de Faraday** : elle protège ses occupants en maintenant le champ électrique **nul à l'intérieur**.

> 🏆 Première quête franchie, héros ! Tu sais électriser un corps, lire le signe d'une charge, expliquer les trois modes d'électrisation par le transfert d'électrons, et distinguer conducteur et isolant. Cap sur le **circuit électrique** : il est temps de faire circuler ce courant.
