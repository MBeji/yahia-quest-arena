# ⚔️ Activités numériques II — puissances, racines, valeur absolue

> 💡 «Puissances, racines et valeur absolue sont les trois clés du calcul sur les réels. Les manier avec sûreté, c'est comparer, encadrer et simplifier n'importe quelle expression.»

Ce chapitre muscle ton calcul sur les nombres réels. Tu y consolides les **puissances** (même à exposant négatif), les **racines carrées** et leurs règles, l'art de **comparer** et d'**encadrer** des réels, et deux notions décisives : la **valeur absolue** et les **intervalles**. Ce sont les outils quotidiens de toute l'algèbre.

## 🔟 Puissances et exposants négatifs

Pour un réel a non nul et des entiers m, n, on retient :

$$ aᵐ × aⁿ = aᵐ⁺ⁿ $$
$$ (aᵐ)ⁿ = aᵐⁿ $$
$$ aᵐ / aⁿ = aᵐ⁻ⁿ $$

Un **exposant négatif** désigne l'inverse : a⁻ⁿ = 1/aⁿ. Enfin, (a × b)ⁿ = aⁿ × bⁿ.

_Exemple détaillé_ : 2³ × 2⁵ = 2⁸ = 256 ; (2³)² = 2⁶ = 64 ; 10⁻² = 1/10² = 1/100 = 0,01.

## √ Racines carrées et leurs règles

La racine carrée d'un réel positif a est le réel positif dont le carré vaut a. Règles essentielles :

$$ √a × √b = √(a × b) $$
$$ √(a²) = |a| $$

De la première on tire la **simplification** d'un radical : on sort du radical le plus grand carré parfait.

_Exemple détaillé_ : √50 = √(25 × 2) = √25 × √2 = 5√2. De même, 2√3 + 3√3 = 5√3 (on additionne les coefficients d'un même radical, comme des termes semblables).

> 🗡️ **Rendre rationnel un dénominateur** grâce à l'expression conjuguée : (√a − √b)(√a + √b) = a − b. Ainsi 1/(√2 − 1) = (√2 + 1) / ((√2 − 1)(√2 + 1)) = (√2 + 1) / (2 − 1) = √2 + 1.

> ⚠️ Attention : √(a²) = |a|, **pas** a. Par exemple √((−5)²) = √25 = 5 = |−5|, et non −5.

## ⚖️ Comparer des nombres réels

Pour comparer deux réels, la méthode sûre est d'étudier le **signe de leur différence** :

$$ a ≥ b ⟺ a − b ≥ 0 $$

Autres repères utiles : ranger deux réels revient à comparer, selon les cas, leurs carrés (pour des positifs), leurs racines ou leurs inverses. En particulier, pour un réel **a ≥ 1** :

$$ √a ≤ a ≤ a² $$

et l'ordre s'inverse pour 0 ≤ a ≤ 1 : a² ≤ a ≤ √a.

_Exemple détaillé_ : pour a = 4 (≥ 1), on a √4 = 2, puis 4, puis 4² = 16, donc 2 ≤ 4 ≤ 16. Pour a = 1/4 (entre 0 et 1), (1/4)² = 1/16, puis 1/4, puis √(1/4) = 1/2, donc 1/16 ≤ 1/4 ≤ 1/2.

## 📏 La valeur absolue

La **valeur absolue** d'un réel a, notée |a|, est sa **distance à 0** sur la droite réelle. Elle est toujours positive :

$$ |a| = a si a ≥ 0, et |a| = −a si a < 0 $$

_Exemple détaillé_ : |3| = 3 et |−5| = 5 (les deux nombres 3 et −5 sont respectivement à 3 et à 5 unités de 0). La valeur absolue « efface » le signe.

## 📐 Intervalles et encadrements

Un **intervalle** regroupe tous les réels compris entre deux bornes. Le crochet est **fermé** [ si la borne est incluse, **ouvert** ] ou [ si elle est exclue :

- [2 ; 5] : tous les x tels que 2 ≤ x ≤ 5 (bornes incluses) ;
- ]−1 ; 3] : tous les x tels que −1 < x ≤ 3 ;
- [0 ; +∞[ : tous les x tels que x ≥ 0.

**Encadrer** un réel, c'est le situer entre deux valeurs : l'**amplitude** de l'encadrement est la différence des deux bornes.

_Exemple détaillé_ : 3,1 ≤ x ≤ 3,2 est un encadrement de x d'amplitude 3,2 − 3,1 = 0,1. Plus l'amplitude est petite, plus l'encadrement est précis.

> 🏆 Dixième quête franchie, héros : puissances domptées, radicaux simplifiés, réels comparés et encadrés — ton calcul est prêt pour l'algèbre littérale du prochain chapitre.
