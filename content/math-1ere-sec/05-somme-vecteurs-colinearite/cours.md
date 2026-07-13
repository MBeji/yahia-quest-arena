# ⚔️ Somme de deux vecteurs et vecteurs colinéaires

> 💡 «Deux déplacements enchaînés n'en font qu'un : c'est toute la puissance de l'addition vectorielle. De là naît le calcul des forces, des trajectoires et des alignements.»

Tu sais déjà reconnaître deux vecteurs égaux et translater une figure. Maintenant, tu apprends à **calculer** avec les vecteurs : les additionner, les multiplier par un nombre, reconnaître ceux qui sont **colinéaires**. Ces opérations transforment un problème de géométrie (alignement, milieu, parallélisme) en un petit calcul — la clé du raisonnement vectoriel.

## ➕ La somme de deux vecteurs : la relation de Chasles

Enchaîner le déplacement de A vers B, puis de B vers C, revient à se déplacer directement de A vers C :

$$ vecteur AB + vecteur BC = vecteur AC $$

C'est la **relation de Chasles**. Le secret : le point d'arrivée du premier vecteur est le point de départ du second (ici, B).

_Exemple détaillé_ : vecteur AB + vecteur BC + vecteur CD = vecteur AD (on enchaîne A→B→C→D, il reste A→D). De même, vecteur AC + vecteur CB = vecteur AB.

> 🗡️ Astuce de calcul : pour simplifier une somme de vecteurs, réorganise-la pour que les lettres « se recollent » (…AB + BC…). Quand un vecteur et son opposé se suivent, ils s'annulent.

## ▱ Règle du parallélogramme et vecteurs opposés

Quand les deux vecteurs partent du **même point** A, on utilise la **règle du parallélogramme** :

> Si A, B, C ne sont pas alignés, alors vecteur AB + vecteur AC = vecteur AD **équivaut à « ABDC est un parallélogramme »** (D est le quatrième sommet).

Deux vecteurs sont **opposés** lorsque leur somme est le vecteur nul. C'est le cas de vecteur AB et vecteur BA :

$$ vecteur AB + vecteur BA = vecteur 0 $$

_Exemple détaillé_ : dans un parallélogramme ABDC, la somme des deux côtés issus de A, vecteur AB + vecteur AC, donne la diagonale vecteur AD. C'est la version géométrique de l'addition.

## ✖️ Le produit d'un vecteur par un réel

Multiplier un vecteur u par un réel α donne un nouveau vecteur αu, **colinéaire** à u :

- sa **longueur** est **|α| × (longueur de u)** ;
- son **sens** est **celui de u si α > 0**, l'**opposé si α < 0**.

_Exemple détaillé_ : 2·vecteur AB est deux fois plus long que vecteur AB et de même sens ; −3·vecteur AB est trois fois plus long et de sens contraire. On note aussi (−1)·vecteur AB = −vecteur AB = vecteur BA.

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
