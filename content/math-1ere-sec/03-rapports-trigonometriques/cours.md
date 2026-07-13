# ⚔️ Rapports trigonométriques et relations métriques

> 💡 «Avec un seul angle et une seule longueur, la trigonométrie reconstruit tout le triangle rectangle. C'est l'art de mesurer l'inaccessible : la hauteur d'un immeuble, la pente d'une route, la distance d'un astre.»

Dans un triangle rectangle, les côtés et les angles ne sont pas indépendants : ils sont liés par trois rapports, le **cosinus**, le **sinus** et la **tangente**. Ce chapitre te donne ces outils, leurs valeurs remarquables, et les **relations métriques** qui complètent le théorème de Pythagore. Tu pourras alors résoudre un triangle rectangle presque les yeux fermés.

## 📐 Cosinus, sinus et tangente d'un angle aigu

On se place dans un triangle **ABC rectangle en A**. Pour l'angle aigu en B, on distingue : le côté **adjacent** [AB], le côté **opposé** [AC], et l'**hypoténuse** [BC] (face à l'angle droit). On définit :

$$ cos B = adjacent / hypoténuse = AB/BC $$
$$ sin B = opposé / hypoténuse = AC/BC $$
$$ tan B = opposé / adjacent = AC/AB $$

_Exemple détaillé_ : dans un triangle rectangle où l'adjacent à B vaut 3 cm et l'hypoténuse 5 cm, cos B = 3/5 = 0,6. Si l'opposé vaut 4 cm, alors sin B = 4/5 = 0,8 et tan B = 4/3.

> 🗡️ Moyen mnémotechnique : **CAH – SOH – TOA** (Cosinus = Adjacent/Hypoténuse, Sinus = Opposé/Hypoténuse, Tangente = Opposé/Adjacent). Adjacent et opposé changent selon l'angle aigu choisi ; l'hypoténuse, elle, ne bouge jamais.

## 🧮 Trouver une longueur ou un angle

Ces rapports permettent, connaissant un angle et un côté, de **calculer** un autre côté ; et connaissant deux côtés, de **retrouver** l'angle (avec la calculatrice en mode **DEG**, touches sin/cos/tan, et leurs fonctions inverses).

_Exemple détaillé (longueur)_ : dans un triangle rectangle en A, l'hypoténuse BC = 10 cm et l'angle B = 60°. Alors AB = BC × cos 60° = 10 × 0,5 = **5 cm**.

_Exemple détaillé (angle)_ : si cos B = 0,6, la calculatrice donne B ≈ 53,13°, soit environ **53,1°** au dixième près.

## 🔗 Relations entre cosinus, sinus et tangente

Pour tout angle aigu a, les trois rapports sont reliés :

$$ tan a = sin a / cos a $$
$$ (sin a)² + (cos a)² = 1 $$

De plus, dans un triangle rectangle en A, les angles B et C sont **complémentaires** (B + C = 90°). D'où :

> Si deux angles sont complémentaires, le **sinus de l'un est égal au cosinus de l'autre** : sin B = cos C et cos B = sin C.

_Exemple détaillé_ : si cos a = 3/5, alors (sin a)² = 1 − (3/5)² = 1 − 9/25 = 16/25, donc sin a = 4/5 (positif car a est aigu). On vérifie : (3/5)² + (4/5)² = 9/25 + 16/25 = 1 ✓.

> ⚠️ Le cosinus et le sinus d'un angle aigu sont toujours **compris entre 0 et 1** (ce sont des rapports d'un côté à l'hypoténuse, plus grande). Une valeur de sinus égale à 1,3 est donc forcément une erreur.

## ⭐ Les angles remarquables 30°, 45°, 60°

Ces trois angles ont des valeurs exactes à connaître par cœur :

| angle | sin  | cos  | tan  |
| ----- | ---- | ---- | ---- |
| 30°   | 1/2  | √3/2 | √3/3 |
| 45°   | √2/2 | √2/2 | 1    |
| 60°   | √3/2 | 1/2  | √3   |

_Exemple détaillé_ : dans un triangle rectangle en A, si l'angle B = 30° et BC = 8 cm, alors AC = BC × sin 30° = 8 × 1/2 = **4 cm**.

> 🗡️ Remarque cohérente avec la complémentarité : 30° et 60° sont complémentaires, et l'on retrouve bien sin 30° = cos 60° = 1/2, ainsi que sin 60° = cos 30° = √3/2.

## 📏 Relations métriques dans le triangle rectangle

Soit ABC **rectangle en A** et H le **pied de la hauteur** issue de A sur l'hypoténuse [BC]. Alors :

$$ AB² + AC² = BC² $$
$$ AB × AC = AH × BC $$
$$ AH² = HB × HC $$
$$ AB² = BH × BC $$

La première est le **théorème de Pythagore**. La deuxième traduit l'aire calculée de deux façons. Les deux dernières relient la hauteur et les projections des côtés sur l'hypoténuse (de même, AC² = CH × CB).

_Exemple détaillé_ : ABC rectangle en A avec AB = 6 et AC = 8. Par Pythagore, BC = √(6² + 8²) = √100 = 10. La hauteur vaut AH = AB × AC / BC = 6 × 8 / 10 = **4,8**. La projection BH = AB² / BC = 36 / 10 = **3,6**.

> 🏆 Troisième quête franchie, héros : tu résous n'importe quel triangle rectangle, angle ou côté, et tu maîtrises les relations métriques qui prolongent Pythagore. Change de terrain : le prochain chapitre t'initie aux vecteurs et aux translations.
