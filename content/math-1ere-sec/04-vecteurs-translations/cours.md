# ⚔️ Vecteurs et translations

> 💡 «Un vecteur, c'est un déplacement pur : une direction, un sens, une longueur — et rien d'autre. Le glisser sur une figure, c'est la translater sans jamais la déformer.»

Jusqu'ici, un point restait à sa place. Le **vecteur** capture l'idée de **déplacement** : aller de A vers B, c'est le vecteur AB. Deux déplacements identiques, partis de points différents, définissent le **même vecteur**. La **translation** applique ce déplacement à toute une figure. C'est le premier outil d'une géométrie nouvelle, qui prépare le calcul dans un repère.

## ➡️ Qu'est-ce qu'un vecteur ?

Un couple ordonné de points (A, B) est un **bipoint**. Le **vecteur AB** possède trois caractères : une **direction** (celle de la droite (AB)), un **sens** (de A vers B) et une **longueur** (la distance AB).

::: figure Le vecteur AB porte trois caractères: une direction (celle de la droite (AB)), un sens (de A vers B) et une longueur
<svg viewBox="0 0 300 200">
<path d="M60 155 L235 65" fill="none" stroke="#0f172a" stroke-width="1.5" stroke-dasharray="6 5"/>
<path d="M60 155 L225 70" fill="none" stroke="#0f6e56" stroke-width="3"/>
<path d="M232 66.4 L219.7 82 L215.6 68.6 Z" fill="#0f6e56"/>
<g fill="#0f172a"><circle cx="60" cy="155" r="4.5"/><circle cx="235" cy="65" r="4.5"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="48" y="170" text-anchor="middle" fill="#0f172a">A</text>
<text x="248" y="58" text-anchor="middle" fill="#0f172a">B</text>
</g>
</svg>
:::

Deux bipoints représentent **le même vecteur** — on dit qu'ils sont **équipollents** — lorsqu'ils ont même direction, même sens et même longueur. On le reconnaît ainsi :

> Le vecteur AB est égal au vecteur CD **si et seulement si les segments [AD] et [BC] ont le même milieu**.

Le **vecteur nul**, noté 0, est celui d'un bipoint (A, A) : direction et sens indéfinis, longueur nulle.

_Exemple détaillé_ : si le milieu de [AD] coïncide avec le milieu de [BC], alors le vecteur AB = le vecteur CD : les deux flèches sont parallèles, de même sens et de même longueur.

## 🟰 Caractériser l'égalité de deux vecteurs

La définition par les milieux se traduit par des critères commodes :

- **Parallélogramme** : si A, B, C ne sont pas alignés, alors « vecteur AB = vecteur CD » équivaut à « **ABDC est un parallélogramme** » (les segments [AD] et [BC] en sont les diagonales, qui se coupent en leur milieu).
- **Permutation** : vecteur AB = vecteur CD équivaut à vecteur AC = vecteur BD.
- **Milieu** : pour trois points distincts, vecteur AB = vecteur BC équivaut à « **B est le milieu de [AC]** ».

_Exemple détaillé_ : ABDC est un parallélogramme. Alors vecteur AB = vecteur CD, et aussi vecteur AC = vecteur BD (les deux autres côtés). C'est la façon la plus rapide de « lire » des vecteurs égaux sur une figure.

::: figure Dans le parallélogramme ABDC, les vecteurs AB et CD sont égaux: même direction, même sens, même longueur
<svg viewBox="0 0 310 215">
<path d="M60 180 L180 180 L250 80 L130 80 Z" fill="#0f6e56" opacity="0.08"/>
<path d="M60 180 L180 180 L250 80 L130 80 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M60 180 L166 180" fill="none" stroke="#0f6e56" stroke-width="3"/>
<path d="M180 180 L166 186 L166 174 Z" fill="#0f6e56"/>
<path d="M130 80 L236 80" fill="none" stroke="#0f6e56" stroke-width="3"/>
<path d="M250 80 L236 86 L236 74 Z" fill="#0f6e56"/>
<g fill="#0f172a"><circle cx="60" cy="180" r="4"/><circle cx="180" cy="180" r="4"/><circle cx="250" cy="80" r="4"/><circle cx="130" cy="80" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="48" y="196" text-anchor="middle" fill="#0f172a">A</text>
<text x="190" y="196" text-anchor="middle" fill="#0f172a">B</text>
<text x="264" y="74" text-anchor="middle" fill="#0f172a">D</text>
<text x="118" y="74" text-anchor="middle" fill="#0f172a">C</text>
</g>
</svg>
:::

> ⚠️ L'ordre des lettres compte. Le vecteur AB et le vecteur BA ont la même direction et la même longueur mais des **sens opposés** : ils ne sont pas égaux (ce sont des vecteurs opposés).

## 🎯 La translation et l'image d'un point

::: figure La translation fait glisser toute la figure du même vecteur: l'image est superposable à l'original
<svg viewBox="0 0 320 215">
<path d="M50 175 L120 175 L75 110 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M160 120 L230 120 L185 55 Z" fill="#0f6e56" opacity="0.12"/>
<path d="M160 120 L230 120 L185 55 Z" fill="none" stroke="#0f6e56" stroke-width="2" stroke-linejoin="round"/>
<g stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4" fill="none">
<path d="M50 175 L160 120 M120 175 L230 120 M75 110 L185 55"/>
</g>
<path d="M245 175 L340 128" fill="none" stroke="#0f6e56" stroke-width="0"/>
<path d="M60 60 L165 7" fill="none" stroke="#0f6e56" stroke-width="0"/>
<g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="40" y="190" text-anchor="middle" fill="#0f172a">A</text>
<text x="130" y="190" text-anchor="middle" fill="#0f172a">B</text>
<text x="66" y="102" text-anchor="middle" fill="#0f172a">C</text>
<text x="150" y="135" text-anchor="middle" fill="#0f6e56">A'</text>
<text x="242" y="135" text-anchor="middle" fill="#0f6e56">B'</text>
<text x="176" y="47" text-anchor="middle" fill="#0f6e56">C'</text>
</g>
</svg>
:::

Se donner un vecteur AB, c'est se donner une **translation**.

> L'**image** d'un point M par la translation de vecteur AB est l'unique point M' tel que **vecteur MM' = vecteur AB**.

Ainsi l'image de A est B. Tout point suit exactement le même déplacement : même direction, même sens, même longueur.

_Exemple détaillé_ : par la translation de vecteur AB, le point M se déplace « comme A se déplace vers B ». On construit M' en reportant, à partir de M, un segment parallèle à [AB], de même sens et de même longueur ; alors MABM'... plus simplement, MM' = AB et ABM'M est un parallélogramme.

## 📐 Images d'une droite, d'un segment, d'un cercle, d'un polygone

Une translation transporte les figures entières, sans les déformer :

| figure de départ | son image par translation                                         |
| ---------------- | ----------------------------------------------------------------- |
| une droite       | une droite **parallèle** à la première                            |
| un segment       | un segment **isométrique** (même longueur)                        |
| un cercle        | un cercle de **même rayon**, dont le centre est l'image du centre |
| un polygone      | un polygone **superposable** (mêmes longueurs, mêmes angles)      |

_Exemple détaillé_ : l'image d'un cercle de centre O et de rayon 3 cm par une translation de vecteur AB est le cercle de rayon 3 cm dont le centre O' est l'image de O (donc OO' = AB).

## 🔒 Ce que la translation conserve

Parce qu'elle déplace sans déformer, la translation **conserve** :

- les **distances** (deux points et leurs images sont à la même distance) ;
- les **longueurs** et les **périmètres** ;
- les **aires** ;
- les **angles** (les angles homologues sont égaux).

_Exemple détaillé_ : un triangle et son image par une translation ont exactement le même périmètre, la même aire et les mêmes angles : ils sont superposables (on peut les faire coïncider en glissant l'un sur l'autre).

> 🗡️ Une translation ne fait ni tourner ni agrandir : elle glisse. C'est pourquoi les images sont toujours parallèles aux figures de départ et de même taille — contrairement à un agrandissement (chapitre 2) qui, lui, change les longueurs.

> 🏆 Quatrième quête franchie, héros : tu sais reconnaître deux vecteurs égaux, construire l'image d'une figure par translation et nommer tout ce qu'elle conserve. Au prochain chapitre, tu apprendras à **additionner** les vecteurs et à repérer ceux qui sont colinéaires.
