# ⚔️ Continuité et limites — la porte de l'Analyse

> 💡 «Celui qui maîtrise les limites aperçoit l'infini ; celui qui maîtrise la continuité le traverse sans jamais tomber.»

Bienvenue dans l'année du concours, héros de la section Mathématiques. Ce chapitre ouvre le domaine de l'Analyse : dérivation, fonctions réciproques et calcul intégral s'appuieront sur les armes forgées ici. Tu consolides d'abord tes acquis de 3ème (limites usuelles, opérations), puis tu les dépasses : encadrements, composées, théorème des valeurs intermédiaires.

## 🏰 Continuité en un point et sur un intervalle

Soit f une fonction définie sur un intervalle ouvert contenant a. On dit que **f est continue en a** lorsque sa limite en a existe et vaut f(a) :

$$ lim x→a f(x) = f(a) $$

- **Continuité à droite** en a : lim x→a⁺ f(x) = f(a) ; **continuité à gauche** : lim x→a⁻ f(x) = f(a). f est continue en a si et seulement si elle est continue à droite **et** à gauche en a.
- f est **continue sur un intervalle I** lorsqu'elle est continue en tout point de I.
- **Fonctions usuelles** : les polynômes, les fonctions rationnelles (sur tout intervalle de leur ensemble de définition), x ↦ √x, x ↦ |x|, sin et cos sont continues là où elles sont définies.

## ⚡ Opérations et composées

Si f et g sont continues en a, alors **f + g**, **f × g** et, si g(a) ≠ 0, **f/g** sont continues en a.

> 🗡️ **Composée** : si v est continue en a et si u est continue en v(a), alors **u ∘ v est continue en a**. _Exemple_ : x ↦ √(x² + 1) est continue sur ℝ, car v : x ↦ x² + 1 est continue à valeurs dans [1 ; +∞[ et u = √ est continue sur [0 ; +∞[.

## 🔮 Limites et formes indéterminées

Les théorèmes d'opérations (somme, produit, quotient) concluent directement… sauf face aux **quatre formes indéterminées** : **∞ − ∞**, **0 × ∞**, **∞/∞** et **0/0**. Il faut alors transformer l'expression avant de conclure. Trois techniques majeures :

- **Terme de plus haut degré** (polynômes et fonctions rationnelles en ±∞) :

$$ lim x→+∞ (3x² − x + 1) = lim x→+∞ 3x² = +∞ $$

$$ lim x→+∞ (5x + 2)/(x − 4) = lim x→+∞ 5x/x = 5 $$

- **Factorisation** (forme 0/0 en un point) :

$$ lim x→2 (x² − 4)/(x − 2) = lim x→2 (x + 2) = 4 $$

- **Expression conjuguée** (radicaux) :

$$ lim x→+∞ (√(x² + 4x) − x) = lim x→+∞ 4x/(√(x² + 4x) + x) = 4/2 = 2 $$

- **Limite infinie en un point** : on étudie le **signe du dénominateur** de part et d'autre. _Exemple_ : lim x→2⁺ 1/(x − 2) = +∞ et lim x→2⁻ 1/(x − 2) = −∞.

> ⚠️ Le piège mortel : remplacer un morceau d'une forme indéterminée par sa limite («√(x² + 4x) se comporte comme x, donc la différence tend vers 0») est une opération **illégale**. On transforme l'expression entière, puis seulement on conclut.

## 🛡️ Comparaison, encadrement et limite d'une composée

- **Comparaison** : si f(x) ≥ u(x) au voisinage de +∞ et si lim x→+∞ u(x) = +∞, alors lim x→+∞ f(x) = +∞ (énoncé analogue vers −∞ avec une majoration).
- **Théorème des gendarmes** : si u(x) ≤ f(x) ≤ v(x) au voisinage de +∞ et si lim u = lim v = ℓ, alors lim x→+∞ f(x) = ℓ. _Exemple_ : pour x > 0, −1/x ≤ (sin x)/x ≤ 1/x, donc lim x→+∞ (sin x)/x = 0. (Rappel de 3ème, toujours admis : lim x→0 (sin x)/x = 1.)
- **Limite d'une composée** : si lim x→a v(x) = b et si lim y→b u(y) = ℓ, alors lim x→a u(v(x)) = ℓ. _Exemple_ : lim x→+∞ √(4 + 1/x) = √4 = 2, car 4 + 1/x → 4 et √ est continue en 4.

## 📐 Asymptotes verticales et horizontales

- Si lim x→a f(x) = +∞ ou −∞ (même seulement à droite ou à gauche de a), la droite d'équation **x = a** est une **asymptote verticale** de la courbe.
- Si lim x→+∞ f(x) = ℓ (ou en −∞), la droite d'équation **y = ℓ** est une **asymptote horizontale**.
- _Exemple_ : pour f(x) = (2x + 1)/(x − 3), la courbe admet l'asymptote verticale x = 3 (le dénominateur s'annule en 3) et l'asymptote horizontale y = 2 (termes dominants 2x/x).

> ⚠️ Ne confonds jamais les deux : une asymptote **verticale** a une équation en **x = …** (limite infinie en un point), une **horizontale** a une équation en **y = …** (limite finie à l'infini). L'asymptote oblique et l'étude complète des branches infinies appartiennent au chapitre «étude de fonctions» — plus tard dans ta quête.

## 🧮 Image d'un intervalle et théorème des valeurs intermédiaires

- L'**image d'un intervalle par une fonction continue est un intervalle** ; l'image du segment [a ; b] est le segment **[m ; M]**, où m est le minimum et M le maximum de f sur [a ; b] — et **pas forcément [f(a) ; f(b)]**.
- **Théorème des valeurs intermédiaires (TVI)** : si f est continue sur [a ; b], alors pour tout réel k compris entre f(a) et f(b), l'équation f(x) = k admet **au moins une** solution dans [a ; b].
- Cas clé : si f est continue sur [a ; b] et f(a) · f(b) < 0, alors f **s'annule au moins une fois** sur [a ; b].
- **Corollaire (bijection)** : si f est continue **et strictement monotone** sur [a ; b], alors pour tout k compris entre f(a) et f(b), l'équation f(x) = k admet une **unique** solution dans [a ; b].

> 🗡️ Sans la dérivée à ton arc (elle arrive dans deux chapitres), la stricte monotonie se justifie par les fonctions usuelles et les opérations : une somme de fonctions strictement croissantes est strictement croissante.

_Exemple_ : f(x) = x³ + x − 3 est continue et strictement croissante sur [1 ; 2] (somme de x ↦ x³ et de x ↦ x − 3, toutes deux strictement croissantes) ; f(1) = −1 < 0 < f(2) = 7, donc l'équation f(x) = 0 admet une **unique** solution α dans [1 ; 2].

## 🧪 Prolongement par continuité et dichotomie

- **Prolongement par continuité** : si f n'est pas définie en a mais si lim x→a f(x) = ℓ avec ℓ **fini**, la fonction g définie par g(x) = f(x) pour x ≠ a et g(a) = ℓ est continue en a : c'est le prolongement par continuité de f en a. _Exemple_ : f(x) = (√(x + 1) − 1)/x n'est pas définie en 0 ; l'expression conjuguée donne f(x) = 1/(√(x + 1) + 1), donc lim x→0 f(x) = 1/2 : f se prolonge par continuité en 0 en posant g(0) = 1/2.
- **Dichotomie (balayage)** : pour encadrer la solution α de f(x) = 0 sur [a ; b], on calcule f au milieu c = (a + b)/2 et on garde la moitié où f change de signe. Chaque étape divise la longueur de l'intervalle par 2 ; on poursuit jusqu'à obtenir une **valeur approchée à 10⁻ⁿ près**. _Exemple_ : pour f(x) = x³ + x − 3, on a f(1) = −1 < 0 et f(1,5) = 1,875 > 0, donc α ∈ ]1 ; 1,5[.

> 🏆 Première porte franchie, héros : tu sais dompter l'infini, lever les indéterminations et capturer les solutions à la précision voulue. Les suites réelles t'attendent au prochain chapitre — l'Analyse ne fait que commencer.
