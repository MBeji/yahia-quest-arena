# ⚔️ Activités numériques I — arithmétique et ensembles de nombres

> 💡 «Derrière chaque entier se cache une structure secrète : ses diviseurs, ses facteurs premiers. Savoir la lire, c'est simplifier une fraction, synchroniser deux cycles, ranger tout nombre à sa place.»

Ce chapitre plonge dans le monde des **entiers** et des **nombres**. Tu y apprends la division euclidienne, les nombres premiers, le PGCD et le PPCM (les outils pour simplifier et synchroniser), la grande famille des ensembles de nombres, et la notation scientifique pour manier le très grand et le très petit. Des bases solides pour toute l'algèbre à venir.

## ➗ La division euclidienne

Diviser un entier a (le **dividende**) par un entier b non nul (le **diviseur**), c'est trouver un **quotient** q et un **reste** r tels que :

$$ a = b × q + r, avec 0 ≤ r < b $$

Le reste est toujours **positif et strictement inférieur au diviseur**. Quand r = 0, on dit que **b divise a**.

_Exemple détaillé_ : la division euclidienne de 452 par 6 donne 452 = 6 × 75 + 2 (quotient 75, reste 2). Comme le reste n'est pas nul, 6 ne divise pas 452.

## 🔢 Nombres premiers et facteurs premiers

Un **nombre premier** est un entier supérieur à 1 qui n'a que **deux diviseurs** : 1 et lui-même (2, 3, 5, 7, 11, 13…). Résultat fondamental :

> Tout entier naturel supérieur à 1 se **décompose en produit de facteurs premiers**, et cette décomposition est unique.

_Exemple détaillé_ : 84 = 2 × 42 = 2 × 2 × 21 = 2 × 2 × 3 × 7, donc 84 = 2² × 3 × 7. Cette écriture révèle tous les diviseurs de 84.

> 🗡️ Pour tester si un nombre est premier, il suffit d'essayer de le diviser par les nombres premiers successifs (2, 3, 5, 7…) jusqu'à ce que leur carré dépasse le nombre.

## 🔗 PGCD, PPCM et algorithme d'Euclide

- Le **PGCD** de a et b est leur **plus grand commun diviseur**.
- Le **PPCM** de a et b est leur **plus petit commun multiple** (non nul).
- Ils sont reliés par : **PGCD(a, b) × PPCM(a, b) = a × b**.

L'**algorithme d'Euclide** calcule le PGCD par divisions successives : on remplace (a, b) par (b, reste) jusqu'à un reste nul ; le dernier reste non nul est le PGCD.

_Exemple détaillé_ : PGCD(2430, 756). 2430 = 3 × 756 + 162 ; 756 = 4 × 162 + 108 ; 162 = 1 × 108 + 54 ; 108 = 2 × 54 + 0. Le dernier reste non nul est **54** : PGCD(2430, 756) = 54.

Deux entiers sont **premiers entre eux** si leur seul diviseur commun est 1 (leur PGCD vaut 1). Une **fraction est irréductible** quand son numérateur et son dénominateur sont premiers entre eux.

_Exemple détaillé_ : PGCD(175, 196) = 7 (car 175 = 5² × 7 et 196 = 2² × 7²). Donc 175/196 = 25/28, forme irréductible (25 et 28 n'ont plus de diviseur commun).

## 📚 Les ensembles de nombres

Les nombres se rangent dans des ensembles **emboîtés** :

$$ IN ⊂ ℤ ⊂ D ⊂ Q ⊂ R $$

- **IN** : entiers naturels (0, 1, 2, 3…) ;
- **ℤ** : entiers relatifs (…, −2, −1, 0, 1, 2…) ;
- **D** : décimaux (écriture décimale finie, comme 3,25) ;
- **Q** : rationnels (quotient de deux entiers, comme 1/3) ;
- **R** : réels (tous, y compris √2 et π).

_Exemple détaillé_ : −5 est dans ℤ mais pas dans IN ; 0,25 = 1/4 est dans D ; 1/3 est dans Q mais **pas** dans D (son écriture décimale 0,333… est illimitée) ; √2 est dans R mais pas dans Q.

## 🔬 Notation scientifique et ordre de grandeur

La **notation scientifique** d'un nombre l'écrit sous la forme **a × 10ⁿ**, où **1 ≤ a < 10** et n est un entier relatif. Elle rend lisibles les nombres très grands ou très petits.

_Exemple détaillé_ : le rayon de la Terre, 6 371 km, s'écrit 6,371 × 10³ km. Le nombre 0,0003 s'écrit 3 × 10⁻⁴. L'**ordre de grandeur** est la puissance de 10 dominante : celui de 6 371 est 10³.

> 🏆 Neuvième quête franchie, héros : tu décomposes, tu simplifies, tu synchronises et tu ranges tout nombre à sa place. Au prochain chapitre, tu approfondis le calcul sur les puissances, les racines carrées et les intervalles.
