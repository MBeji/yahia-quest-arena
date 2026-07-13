# ⚔️ Sections planes d'un solide

> 💡 «Trancher un solide par un plan, c'est révéler la figure cachée à l'intérieur. Un cylindre coupé donne un cercle, une pyramide un polygone réduit : l'espace se lit dans le plan.»

Ce chapitre quitte le plan pour l'**espace**. Tu revois d'abord les **volumes** des solides usuels, puis tu étudies leurs **sections planes** : la figure obtenue quand un plan coupe le solide. Selon le solide et l'orientation du plan, on obtient un rectangle, un cercle ou un polygone réduit — des résultats à connaître par cœur.

## 🧊 Les solides usuels et leurs volumes

Rappel des formules de volume (B désigne l'aire de la base, h la hauteur, R le rayon) :

| solide                    | volume        |
| ------------------------- | ------------- |
| parallélépipède rectangle | a × b × c     |
| prisme droit              | B × h         |
| cylindre                  | π × R² × h    |
| pyramide, cône, tétraèdre | (1/3) × B × h |

Pour la **sphère** de rayon R : son aire vaut 4 × π × R², et le volume de la **boule** vaut (4/3) × π × R³.

_Exemple détaillé_ : un cylindre de rayon 3 cm et de hauteur 10 cm a pour volume π × 3² × 10 = 90π cm³ (soit environ 282,7 cm³).

## ▭ Section d'un parallélépipède rectangle

Deux cas au programme :

> La section d'un parallélépipède droit par un plan **parallèle à une face** est un **rectangle isométrique** (identique) à cette face.

> La section par un plan **contenant une arête** est un **rectangle**.

_Exemple détaillé_ : on coupe une boîte parallélépipédique par un plan parallèle à sa face avant. La tranche obtenue est un rectangle exactement superposable à cette face avant.

## 🔺 Section d'une pyramide et d'un cône

Quand le plan est **parallèle à la base** :

> La section d'une **pyramide** par un plan parallèle à sa base est un **polygone de même nature que la base**, mais **réduit**.

> La section d'un **cône de révolution** par un plan parallèle à sa base est un **cercle** (plus petit) ; la partie basse forme un **cône tronqué**.

Cette réduction suit une **échelle k** (comme au chapitre Thalès) : les longueurs sont multipliées par k, et l'**aire de la section par k²**.

_Exemple détaillé_ : une pyramide à base carrée est coupée à mi-hauteur par un plan parallèle à la base (k = 1/2). La section est un carré dont le côté est la moitié de celui de la base, donc d'aire quatre fois plus petite (k² = 1/4).

## ⭕ Section d'un cylindre et d'une sphère

> La section d'un **cylindre** par un plan **parallèle à une base** est un **cercle de même rayon** que la base.

> La section d'une **sphère** par un plan est un **cercle**. Si le plan passe par le **centre**, ce cercle a le rayon de la sphère : on l'appelle un **grand cercle**.

Pour une sphère de rayon R coupée par un plan situé à la distance d de son centre, le rayon r de la section se calcule par le théorème de Pythagore :

$$ r = √(R² − d²) $$

_Exemple détaillé_ : une sphère de rayon 25 cm est coupée par un plan situé à 20 cm de son centre. Le rayon de la section vaut r = √(25² − 20²) = √(625 − 400) = √225 = **15 cm**.

> ⚠️ Pour la sphère, la section est un cercle **d'autant plus petit que le plan est loin du centre**. Le plus grand cercle possible (le grand cercle) s'obtient quand le plan passe par le centre (d = 0, donc r = R).

## 📐 Plans parallèles et perpendicularité

Deux propriétés d'espace utiles pour justifier la nature d'une section :

- Quand un plan **sécant** coupe **deux plans parallèles**, les **deux droites d'intersection sont parallèles** entre elles.
- Une droite est **perpendiculaire à un plan** lorsqu'elle est perpendiculaire à toutes les droites de ce plan passant par leur point commun ; l'axe d'un cylindre ou la hauteur d'un cône sont perpendiculaires à la base.

_Exemple détaillé_ : la hauteur d'un cône, perpendiculaire à la base, l'est aussi à tout plan de section parallèle à la base — ce qui garantit que la section est bien un cercle centré sur l'axe.

> 🏆 Huitième quête franchie, héros : tu calcules des volumes et tu reconnais la figure cachée dans toute section usuelle. Tu clôtures la géométrie de l'année ; place maintenant aux nombres et à l'algèbre.
