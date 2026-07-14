# ⚔️ Somme de deux vecteurs et vecteurs colinéaires

> 💡 «Deux déplacements enchaînés n'en font qu'un : c'est toute la puissance de l'addition vectorielle. De là naît le calcul des forces, des trajectoires et des alignements.»

Tu sais déjà reconnaître deux vecteurs égaux et translater une figure. Maintenant, tu apprends à **calculer** avec les vecteurs : les additionner, les multiplier par un nombre, reconnaître ceux qui sont **colinéaires**. Ces opérations transforment un problème de géométrie (alignement, milieu, parallélisme) en un petit calcul — la clé du raisonnement vectoriel.

## ➕ La somme de deux vecteurs : la relation de Chasles

Enchaîner le déplacement de A vers B, puis de B vers C, revient à se déplacer directement de A vers C :

$$ vecteur AB + vecteur BC = vecteur AC $$

C'est la **relation de Chasles**. Le secret : le point d'arrivée du premier vecteur est le point de départ du second (ici, B).

::: figure Relation de Chasles: aller de A à B puis de B à C revient à aller directement de A à C
<svg viewBox="0 0 320 215">
<path d="M50 180 L154.3 84.1" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M160 70 L154.3 84.1 L145.9 75.7 Z" fill="#0f6e56"/>
<path d="M160 70 L258.7 141.8" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M270 150 L255.2 146.7 L262.2 136.9 Z" fill="#0f6e56"/>
<path d="M50 180 L256.1 151.9" fill="none" stroke="#0f172a" stroke-width="2.5" stroke-dasharray="7 4"/>
<path d="M270 150 L256.9 157.8 L255.3 146 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="50" cy="180" r="4"/><circle cx="160" cy="70" r="4"/><circle cx="270" cy="150" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="38" y="194" text-anchor="middle" fill="#0f172a">A</text>
<text x="160" y="58" text-anchor="middle" fill="#0f172a">B</text>
<text x="284" y="148" text-anchor="middle" fill="#0f172a">C</text>
</g>
</svg>
:::

_Exemple détaillé_ : vecteur AB + vecteur BC + vecteur CD = vecteur AD (on enchaîne A→B→C→D, il reste A→D). De même, vecteur AC + vecteur CB = vecteur AB.

> 🗡️ Astuce de calcul : pour simplifier une somme de vecteurs, réorganise-la pour que les lettres « se recollent » (…AB + BC…). Quand un vecteur et son opposé se suivent, ils s'annulent.

## ▱ Règle du parallélogramme et vecteurs opposés

Quand les deux vecteurs partent du **même point** A, on utilise la **règle du parallélogramme** :

> Si A, B, C ne sont pas alignés, alors vecteur AB + vecteur AC = vecteur AD **équivaut à « ABDC est un parallélogramme »** (D est le quatrième sommet).

::: figure Règle du parallélogramme: quand les deux vecteurs partent du même point A, leur somme est la diagonale AD
<svg viewBox="0 0 320 215">
<path d="M70 180 L200 180 L250 70 L120 70 Z" fill="#0f6e56" opacity="0.08"/>
<path d="M70 180 L200 180 L250 70 L120 70 Z" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
<path d="M70 180 L186 180" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M200 180 L186 186 L186 174 Z" fill="#0f6e56"/>
<path d="M70 180 L114 83" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M120 70 L110 84.5 L104 76 Z" fill="#0f6e56"/>
<path d="M70 180 L237 82" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<path d="M250 70 L235 78 L242 88 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="70" cy="180" r="4"/><circle cx="200" cy="180" r="4"/><circle cx="250" cy="70" r="4"/><circle cx="120" cy="70" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="58" y="196" text-anchor="middle" fill="#0f172a">A</text>
<text x="210" y="196" text-anchor="middle" fill="#0f172a">B</text>
<text x="264" y="64" text-anchor="middle" fill="#0f172a">D</text>
<text x="108" y="64" text-anchor="middle" fill="#0f172a">C</text>
</g>
</svg>
:::

Deux vecteurs sont **opposés** lorsque leur somme est le vecteur nul. C'est le cas de vecteur AB et vecteur BA :

$$ vecteur AB + vecteur BA = vecteur 0 $$

_Exemple détaillé_ : dans un parallélogramme ABDC, la somme des deux côtés issus de A, vecteur AB + vecteur AC, donne la diagonale vecteur AD. C'est la version géométrique de l'addition.

## ✖️ Le produit d'un vecteur par un réel

Multiplier un vecteur u par un réel α donne un nouveau vecteur αu, **colinéaire** à u :

- sa **longueur** est **|α| × (longueur de u)** ;
- son **sens** est **celui de u si α > 0**, l'**opposé si α < 0**.

_Exemple détaillé_ : 2·vecteur AB est deux fois plus long que vecteur AB et de même sens ; −3·vecteur AB est trois fois plus long et de sens contraire. On note aussi (−1)·vecteur AB = −vecteur AB = vecteur BA.

::: figure Multiplier par un réel: 2·AB est deux fois plus long et de même sens; −AB garde la longueur mais renverse le sens
<svg viewBox="0 0 330 180">
<path d="M55 120 L118 88.5" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<path d="M125 85 L112 98 L109 84 Z" fill="#0f172a"/>
<path d="M55 60 L258 -41.5" fill="none" stroke="#0f6e56" stroke-width="0"/>
<path d="M55 55 L118 23.5" fill="none" stroke="#0f6e56" stroke-width="0"/>
<path d="M175 130 L308 63.5" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M315 60 L302 73 L299 59 Z" fill="#0f6e56"/>
<path d="M175 130 L108 163.5" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M101 167 L114 154 L117 168 Z" fill="#0f6e56"/>
<g fill="#0f172a"><circle cx="55" cy="120" r="4"/><circle cx="175" cy="130" r="4"/></g>
<g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="86" y="118" text-anchor="middle" fill="#0f172a">u</text>
<text x="250" y="86" text-anchor="middle" fill="#0f6e56">2u</text>
<text x="132" y="162" text-anchor="middle" fill="#0f6e56">−u</text>
</g>
</svg>
:::

> ⚠️ Ne confonds pas longueur et coefficient. Le vecteur −3·vecteur AB a pour longueur 3 × AB (on prend la **valeur absolue** du coefficient) ; le signe « − » ne change que le sens, pas la longueur.

## ↔️ Vecteurs colinéaires

Deux vecteurs non nuls sont **colinéaires** lorsque l'un est le produit de l'autre par un réel :

> vecteur CD et vecteur AB sont colinéaires **si et seulement s'il existe un réel k tel que vecteur CD = k · vecteur AB.**

Le lien avec le parallélisme est fondamental :

- si vecteur CD = k · vecteur AB, alors les droites (AB) et (CD) sont **parallèles** (ou confondues) ;
- réciproquement, si (AB) // (CD), alors vecteur AB et vecteur CD sont colinéaires.

_Exemple détaillé_ : si vecteur CD = 2 · vecteur AB, les points sont tels que (CD) // (AB), CD = 2 × AB, et les deux vecteurs sont de même sens (k = 2 > 0). C'est **l'outil pour prouver que trois points sont alignés** : A, B, C sont alignés si et seulement si vecteur AB et vecteur AC sont colinéaires.

## 🎯 Milieu d'un segment

Les vecteurs caractérisent aussi le **milieu**. Le point I est le milieu de [AB] lorsque :

$$ vecteur IA + vecteur IB = vecteur 0 $$

ce qui équivaut aussi à :

$$ vecteur AB = 2 · vecteur AI $$

_Exemple détaillé_ : si I est le milieu de [AB], alors vecteur AI et vecteur IB sont égaux, et vecteur AB = 2·vecteur AI. Réciproquement, dès que vecteur AB = 2·vecteur AI avec I sur [AB], I est le milieu.

> 🏆 Cinquième quête franchie, héros : tu additionnes les vecteurs par Chasles, tu les multiplies par un réel et tu détectes la colinéarité — donc l'alignement et le parallélisme. Au prochain chapitre, tu poseras un **repère** pour tout calculer avec des coordonnées.
