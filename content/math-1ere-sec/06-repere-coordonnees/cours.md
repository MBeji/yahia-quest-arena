# ⚔️ Activités dans un repère

> 💡 «Poser un repère, c'est donner une adresse à chaque point. Dès lors, un problème de géométrie devient un simple calcul sur des nombres : c'est l'idée géniale de Descartes.»

Jusqu'ici, tu raisonnais sur des figures. Avec un **repère**, chaque point reçoit des **coordonnées**, chaque vecteur des **composantes**, et les grandes questions — milieu, alignement, distance, parallélisme — se résolvent par le calcul. Ce chapitre relie la géométrie des chapitres précédents à l'algèbre.

## 📍 Repère et abscisse sur une droite

Un **repère cartésien** d'une droite est un couple (O, I) : O est l'**origine**, et le vecteur OI donne l'unité. Tout point M de la droite a une unique **abscisse** x telle que :

$$ vecteur OM = x · vecteur OI $$

La **mesure algébrique** du vecteur AB est le réel :

$$ AB = xB − xA $$

_Exemple détaillé_ : sur une droite, A a pour abscisse 2 et B pour abscisse 5. La mesure algébrique de vecteur AB vaut xB − xA = 5 − 2 = 3. Si l'abscisse de C est −1, alors la mesure algébrique de vecteur AC vaut −1 − 2 = −3 (le signe indique le sens).

## 🗺️ Repère du plan : coordonnées d'un point

Un **repère cartésien du plan** est un triplet (O, I, J). L'**axe des abscisses** porte OI, l'**axe des ordonnées** porte OJ. Tout point M a un unique couple de **coordonnées** (x ; y) tel que :

$$ vecteur OM = x · vecteur OI + y · vecteur OJ $$

x est l'**abscisse**, y l'**ordonnée**. On note M(x ; y).

_Exemple détaillé_ : le point A(2 ; 3) se lit « 2 vers la droite, 3 vers le haut » à partir de l'origine. L'origine O est le point (0 ; 0).

## ➡️ Composantes d'un vecteur

Un vecteur possède un couple de **composantes**, obtenu en soustrayant les coordonnées « arrivée moins départ » :

$$ vecteur AB (xB − xA ; yB − yA) $$

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6), les composantes de vecteur AB sont (4 − 1 ; 6 − 2) = (3 ; 4). **Deux vecteurs sont égaux si et seulement s'ils ont les mêmes composantes.**

> 🗡️ Ordre à respecter : toujours **coordonnées de l'arrivée moins coordonnées du départ**. Inverser donne le vecteur opposé.

## 🎯 Milieu et colinéarité par le calcul

Deux formules essentielles :

- **Milieu** de [AB] : le point K de coordonnées

$$ K((xA + xB)/2 ; (yA + yB)/2) $$

- **Colinéarité** : vecteur CD et vecteur AB sont colinéaires lorsque leurs composantes sont **proportionnelles**, c'est-à-dire s'il existe un réel k tel que chaque composante de vecteur CD soit k fois celle de vecteur AB. C'est le test d'**alignement** : A, B, C sont alignés si vecteur AB et vecteur AC sont colinéaires.

_Exemple détaillé (milieu)_ : le milieu de [AB] avec A(2 ; 3) et B(6 ; 9) est K((2 + 6)/2 ; (3 + 9)/2) = (4 ; 6).

_Exemple détaillé (colinéarité)_ : vecteur AB(3 ; 4) et vecteur CD(6 ; 8) : on cherche k tel que 6 = k × 3 et 8 = k × 4. Les deux donnent k = 2, donc les vecteurs sont colinéaires (et vecteur CD = 2·vecteur AB).

> ⚠️ Pour la colinéarité, le **même** coefficient k doit convenir aux **deux** composantes. Si 6 = 2 × 3 mais 8 ≠ 3 × 3, les vecteurs ne sont pas colinéaires.

## 📏 Distance dans un repère orthonormé

Un repère est **orthonormé** lorsque ses deux axes sont perpendiculaires et de même unité. On peut alors calculer une **distance** :

$$ AB = √((xB − xA)² + (yB − yA)²) $$

C'est le théorème de Pythagore appliqué aux composantes du vecteur.

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6) dans un repère orthonormé, AB = √((4 − 1)² + (6 − 2)²) = √(9 + 16) = √25 = 5.

> 🗡️ Deux droites qui sont les représentations graphiques de fonctions affines de **même coefficient directeur** sont **parallèles** : par exemple y = 2x + 1 et y = 2x − 3 ont des droites parallèles.

> 🏆 Sixième quête franchie, héros : tu sais placer un point, calculer des composantes, un milieu, une distance, et prouver un alignement par le calcul. Au prochain chapitre, tu découvriras une nouvelle transformation : le quart de tour.
