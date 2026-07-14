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

::: figure Les coordonnées de M se lisent par projection sur les deux axes: l'abscisse en premier, l'ordonnée ensuite
<svg viewBox="0 0 300 240">
<g stroke="#94a3b8" stroke-width="1" opacity="0.5">
<path d="M80 15 V225 M110 15 V225 M140 15 V225 M170 15 V225 M200 15 V225 M230 15 V225 M260 15 V225"/>
<path d="M25 25 H285 M25 55 H285 M25 85 H285 M25 115 H285 M25 145 H285 M25 175 H285"/>
</g>
<path d="M25 205 H282 M50 228 V18" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M288 205 L276 210 L276 200 Z M50 12 L45 24 L55 24 Z" fill="#0f172a"/>
<path d="M140 145 L140 205 M140 145 L50 145" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="6 4"/>
<g fill="#0f172a"><circle cx="50" cy="205" r="4"/></g>
<g fill="#0f6e56"><circle cx="140" cy="145" r="5"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="38" y="222" text-anchor="middle" fill="#0f172a">O</text>
<text x="154" y="137" text-anchor="middle" fill="#0f6e56">M</text>
<text x="140" y="224" text-anchor="middle" fill="#0f6e56">3</text>
<text x="36" y="150" text-anchor="middle" fill="#0f6e56">2</text>
</g>
</svg>
:::

Un **repère cartésien du plan** est un triplet (O, I, J). L'**axe des abscisses** porte OI, l'**axe des ordonnées** porte OJ. Tout point M a un unique couple de **coordonnées** (x ; y) tel que :

$$ vecteur OM = x · vecteur OI + y · vecteur OJ $$

x est l'**abscisse**, y l'**ordonnée**. On note M(x ; y).

_Exemple détaillé_ : le point A(2 ; 3) se lit « 2 vers la droite, 3 vers le haut » à partir de l'origine. L'origine O est le point (0 ; 0).

## ➡️ Composantes d'un vecteur

Un vecteur possède un couple de **composantes**, obtenu en soustrayant les coordonnées « arrivée moins départ » :

$$ vecteur AB (xB − xA ; yB − yA) $$

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6), les composantes de vecteur AB sont (4 − 1 ; 6 − 2) = (3 ; 4). **Deux vecteurs sont égaux si et seulement s'ils ont les mêmes composantes.**

::: figure Les composantes de AB se lisent « arrivée moins départ »: de A(1 ; 2) à B(4 ; 6), on avance de 3 et on monte de 4
<svg viewBox="0 0 300 240">
<g stroke="#94a3b8" stroke-width="1" opacity="0.5">
<path d="M80 15 V225 M110 15 V225 M140 15 V225 M170 15 V225 M200 15 V225 M230 15 V225 M260 15 V225"/>
<path d="M25 25 H285 M25 55 H285 M25 85 H285 M25 115 H285 M25 145 H285 M25 175 H285"/>
</g>
<path d="M25 205 H282 M50 228 V18" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M288 205 L276 210 L276 200 Z M50 12 L45 24 L55 24 Z" fill="#0f172a"/>
<path d="M80 145 L170 145" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="6 4"/>
<path d="M170 145 L170 25" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="6 4"/>
<path d="M80 145 L162 33.6" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<path d="M170 25 L157.5 40.6 L153.6 27.2 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="50" cy="205" r="4"/><circle cx="80" cy="145" r="4.5"/><circle cx="170" cy="25" r="4.5"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="38" y="222" text-anchor="middle" fill="#0f172a">O</text>
<text x="68" y="162" text-anchor="middle" fill="#0f172a">A</text>
<text x="184" y="22" text-anchor="middle" fill="#0f172a">B</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="125" y="162" text-anchor="middle" fill="#0f6e56">3</text>
<text x="184" y="90" text-anchor="middle" fill="#0f6e56">4</text>
</g>
</svg>
:::

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

::: figure La distance AB est l'hypoténuse du triangle rectangle des composantes: AB = √(3² + 4²) = 5
<svg viewBox="0 0 300 240">
<g stroke="#94a3b8" stroke-width="1" opacity="0.5">
<path d="M80 15 V225 M110 15 V225 M140 15 V225 M170 15 V225 M200 15 V225 M230 15 V225 M260 15 V225"/>
<path d="M25 25 H285 M25 55 H285 M25 85 H285 M25 115 H285 M25 145 H285 M25 175 H285"/>
</g>
<path d="M25 205 H282 M50 228 V18" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M288 205 L276 210 L276 200 Z M50 12 L45 24 L55 24 Z" fill="#0f172a"/>
<path d="M80 145 L170 145 L170 25 Z" fill="#0f6e56" opacity="0.10"/>
<path d="M80 145 L170 145 L170 25 Z" fill="none" stroke="#0f6e56" stroke-width="2" stroke-linejoin="round"/>
<path d="M80 145 L170 25" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<path d="M152 145 L152 127 L170 127" fill="none" stroke="#0f6e56" stroke-width="2"/>
<g fill="#0f172a"><circle cx="50" cy="205" r="4"/><circle cx="80" cy="145" r="4.5"/><circle cx="170" cy="25" r="4.5"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="38" y="222" text-anchor="middle" fill="#0f172a">O</text>
<text x="68" y="162" text-anchor="middle" fill="#0f172a">A</text>
<text x="184" y="22" text-anchor="middle" fill="#0f172a">B</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="125" y="162" text-anchor="middle" fill="#0f6e56">3</text>
<text x="184" y="90" text-anchor="middle" fill="#0f6e56">4</text>
<text x="112" y="80" text-anchor="middle" fill="#0f172a">5</text>
</g>
</svg>
:::

Un repère est **orthonormé** lorsque ses deux axes sont perpendiculaires et de même unité. On peut alors calculer une **distance** :

$$ AB = √((xB − xA)² + (yB − yA)²) $$

C'est le théorème de Pythagore appliqué aux composantes du vecteur.

_Exemple détaillé_ : pour A(1 ; 2) et B(4 ; 6) dans un repère orthonormé, AB = √((4 − 1)² + (6 − 2)²) = √(9 + 16) = √25 = 5.

> 🗡️ Deux droites qui sont les représentations graphiques de fonctions affines de **même coefficient directeur** sont **parallèles** : par exemple y = 2x + 1 et y = 2x − 3 ont des droites parallèles.

> 🏆 Sixième quête franchie, héros : tu sais placer un point, calculer des composantes, un milieu, une distance, et prouver un alignement par le calcul. Au prochain chapitre, tu découvriras une nouvelle transformation : le quart de tour.
