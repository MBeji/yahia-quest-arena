# ⚔️ Angles — droites parallèles et cercle

> 💡 «Un angle bien lu, c'est une droite qui se trahit ou un cercle qui se dévoile. Apprends à faire parler les angles, et la figure n'aura plus de secret.»

Bienvenue en 1ère année secondaire, héros. Tu connais déjà les angles aigus, obtus, la bissectrice et les angles supplémentaires. Dans cette quête, tu apprends à t'en servir comme d'outils de preuve : montrer que deux droites sont parallèles, calculer un angle inconnu dans un cercle, prouver qu'un triangle est rectangle. C'est le socle de toute la géométrie de l'année.

## 🔺 Somme des angles et angle extérieur d'un triangle

Dans **tout triangle**, la somme des trois angles vaut **180°** :

$$ BAC + ABC + ACB = 180° $$

Un **angle extérieur** d'un triangle est l'angle formé par un côté et le prolongement d'un autre côté. Propriété clé :

> Un angle extérieur d'un triangle est égal à la **somme des deux angles intérieurs qui ne lui sont pas adjacents**.

_Exemple détaillé_ : dans le triangle ABC, on prolonge [BC] au-delà de C jusqu'à un point D. Si BAC = 60° et ABC = 50°, alors l'angle extérieur ACD = 60° + 50° = **110°**. Vérification : l'angle intérieur ACB = 180° − 110° = 70°, et 60° + 50° + 70° = 180° ✓.

> 🗡️ L'angle extérieur et l'angle intérieur au même sommet sont **supplémentaires** (leur somme fait 180°) : c'est une deuxième façon rapide de trouver l'un à partir de l'autre.

## ↔️ Angles, sécante et droites parallèles

Une **sécante** coupe deux droites en deux points. Elle y forme des paires d'angles : **correspondants**, **alternes-internes**, et **intérieurs d'un même côté**. Quand les deux droites sont **parallèles** :

- deux angles **alternes-internes** sont **égaux** ;
- deux angles **correspondants** sont **égaux** ;
- deux angles **intérieurs d'un même côté** sont **supplémentaires** (somme = 180°).

_Exemple détaillé_ : deux droites parallèles (d) et (d') coupées par une sécante. Un angle mesure 65°. Son alterne-interne mesure aussi 65° ; son correspondant mesure 65° ; l'angle intérieur du même côté mesure 180° − 65° = 115°.

## 🔁 Reconnaître deux droites parallèles

Les propriétés ci-dessus ont une **réciproque** — c'est elle qui sert à **démontrer** un parallélisme :

> Si deux droites coupées par une sécante forment deux angles **alternes-internes égaux** (ou deux angles **correspondants égaux**, ou deux angles **intérieurs d'un même côté supplémentaires**), alors ces deux droites sont **parallèles**.

_Exemple détaillé_ : une sécante coupe (AB) et (CD). Les angles alternes-internes mesurent 48° et 48°. Comme ils sont égaux, on conclut : **(AB) // (CD)**.

> ⚠️ Piège classique : la propriété directe part du parallélisme pour donner l'égalité des angles ; la réciproque part de l'égalité des angles pour donner le parallélisme. Ne mélange pas le sens de la flèche.

## ⭕ Angle inscrit et angle au centre

Sur un cercle de centre O :

- un **angle inscrit** a son **sommet sur le cercle** et ses deux côtés recoupent le cercle ; il **intercepte** l'arc situé entre ses côtés ;
- un **angle au centre** a son **sommet en O**.

Propriété fondamentale, quand les deux angles interceptent le **même arc** :

$$ angle au centre = 2 × angle inscrit $$

Autrement dit, un angle inscrit est égal à la **moitié** de l'angle au centre qui intercepte le même arc.

_Exemple détaillé_ : A, B, M sont sur un cercle de centre O. L'angle au centre AOB = 100°. L'angle inscrit AMB, qui intercepte le même arc [AB], vaut donc 100° / 2 = **50°**.

> 🗡️ Conséquence directe : **deux angles inscrits qui interceptent le même arc sont égaux** (ils valent tous la moitié du même angle au centre). Très utile pour transporter une mesure d'un point à un autre du cercle.

> ⚠️ L'angle inscrit vaut la **moitié**, pas le double, de l'angle au centre — et les deux doivent intercepter **le même arc**. Deux angles inscrits sur des arcs différents n'ont aucune raison d'être égaux.

## 📐 Triangle rectangle inscrit dans un demi-cercle

Cas particulier capital : lorsque l'arc intercepté est un **demi-cercle**, l'angle au centre est un angle plat (180°), donc l'angle inscrit vaut 180° / 2 = 90°. D'où :

> Si l'un des côtés d'un triangle est un **diamètre** de son cercle circonscrit, alors ce triangle est **rectangle**, et l'angle droit est au sommet opposé à ce diamètre.

Réciproquement, on décrit ainsi un **lieu géométrique** : pour deux points fixes A et B, l'ensemble des points P tels que **APB = 90°** est le **cercle de diamètre [AB]** (privé de A et de B).

_Exemple détaillé_ : [BC] est un diamètre du cercle circonscrit au triangle ABC. Alors BAC = 90°. Si de plus ABC = 35°, on obtient ACB = 180° − 90° − 35° = **55°**.

> 🗡️ Application : les **tangentes** à un cercle de centre O menées depuis un point extérieur A touchent le cercle en des points T tels que OTA = 90° (le rayon est perpendiculaire à la tangente). Ces points de contact sont donc sur le cercle de diamètre [OA] — ce qui donne une construction au compas des tangentes.

> 🏆 Première quête franchie, héros : tu sais calculer un angle inconnu, prouver un parallélisme et débusquer un angle droit caché dans un cercle. Ces armes serviront dès le prochain chapitre, avec le théorème de Thalès.
