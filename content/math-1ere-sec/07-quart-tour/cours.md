# ⚔️ Quart de tour

> 💡 «Fais pivoter le plan d'un quart de tour autour d'un point : les longueurs survivent, les angles aussi, mais toute droite se dresse perpendiculaire à elle-même. Une transformation qui fabrique des angles droits.»

Tu connais déjà la symétrie, la translation et le demi-tour (la symétrie centrale). Voici une nouvelle transformation : le **quart de tour**, une rotation de **90°** autour d'un centre. Sa signature : elle transforme une droite en une droite **perpendiculaire**. C'est un outil redoutable pour démontrer des perpendicularités et des égalités de longueurs.

## 🔄 Le quart de tour direct et indirect

Soit O un point fixe, le **centre**. L'image d'un point M (avec M ≠ O) par le **quart de tour de centre O** est le point M' tel que :

$$ OM' = OM $$

et l'angle **MOM' = 90°**. L'image de O est O lui-même (c'est le seul point fixe).

::: figure Le quart de tour direct: M' est à la même distance de O que M, et l'angle MOM' est droit
<svg viewBox="0 0 300 220">
<path d="M150 130 L240 160 M150 130 L180 40" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M240 160 A 94.87 94.87 0 0 0 180 40" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="6 5"/>
<path d="M167.1 135.7 L172.8 118.6 L155.7 112.9" fill="none" stroke="#0f6e56" stroke-width="2"/>
<g fill="#0f172a"><circle cx="150" cy="130" r="4"/><circle cx="240" cy="160" r="4.5"/></g>
<g fill="#0f6e56"><circle cx="180" cy="40" r="4.5"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="139" y="146" text-anchor="middle" fill="#0f172a">O</text>
<text x="254" y="172" text-anchor="middle" fill="#0f172a">M</text>
<text x="192" y="32" text-anchor="middle" fill="#0f6e56">M'</text>
</g>
</svg>
:::

Il y a deux sens de rotation :

- le **quart de tour direct** tourne dans le **sens direct** (contraire des aiguilles d'une montre) ;
- le **quart de tour indirect** tourne dans le **sens indirect** (celui des aiguilles d'une montre).

_Exemple détaillé_ : si OM = 4 cm, alors son image M' vérifie OM' = 4 cm et l'angle MOM' est droit. Le triangle OMM' est donc rectangle isocèle en O.

## 📐 Quart de tour et triangle rectangle isocèle

Ce lien est la clé du chapitre :

> Le triangle ABC est **rectangle isocèle en A** si et seulement si **C est l'image de B par un quart de tour de centre A** (direct ou indirect).

En effet, « rectangle isocèle en A » signifie exactement AB = AC (isocèle) et angle BAC = 90° (rectangle) : ce sont les deux conditions de définition du quart de tour de centre A.

_Exemple détaillé_ : si ABC est rectangle isocèle en A, alors AB = AC et l'angle BAC = 90° ; C est donc l'image de B par le quart de tour de centre A. Réciproquement, prendre l'image d'un point par un quart de tour, c'est fabriquer un tel triangle.

## 🔒 Ce que le quart de tour conserve

Comme la translation, le quart de tour est une **isométrie** : il déplace sans déformer. Il **conserve** :

- les **distances** (donc les longueurs et les périmètres) ;
- l'**alignement** des points ;
- les **angles** (les angles homologues sont égaux) ;
- les **aires**.

Un polygone et son image sont donc **superposables**.

_Exemple détaillé_ : un segment [AB] a pour image un segment [A'B'] de **même longueur** : A'B' = AB. Un triangle et son image ont le même périmètre et la même aire.

## ⊥ Image d'une droite : une perpendiculaire

::: figure L'image d'une droite par un quart de tour lui est toujours PERPENDICULAIRE
<svg viewBox="0 0 300 230">
<path d="M60 82 L225 148" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M96 208 L172 18" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M156.8 120.7 L162 107.7 L149 102.5" fill="none" stroke="#0f172a" stroke-width="2"/>
<g stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4" fill="none">
<path d="M80 90 L110 200 M200 138 L158 80"/>
</g>
<g fill="#0f172a"><circle cx="150" cy="130" r="4"/><circle cx="80" cy="90" r="4.5"/><circle cx="200" cy="138" r="4.5"/></g>
<g fill="#0f6e56"><circle cx="110" cy="200" r="4.5"/><circle cx="158" cy="80" r="4.5"/></g>
<g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="139" y="145" text-anchor="middle" fill="#0f172a">O</text>
<text x="70" y="80" text-anchor="middle" fill="#0f172a">A</text>
<text x="212" y="150" text-anchor="middle" fill="#0f172a">B</text>
<text x="98" y="215" text-anchor="middle" fill="#0f6e56">A'</text>
<text x="170" y="72" text-anchor="middle" fill="#0f6e56">B'</text>
</g>
</svg>
:::

Voici la propriété qui distingue le quart de tour de la translation :

> L'image d'une **droite** par un quart de tour est une **droite perpendiculaire** à la droite de départ.

À comparer : la translation transforme une droite en une droite **parallèle**. Ici, l'angle de 90° du quart de tour se retrouve entre la droite et son image. Par ailleurs :

- l'image d'un **segment** est un segment **isométrique** ;
- l'image d'un **cercle** est un cercle de **même rayon**, dont le centre est l'image du centre.

> ⚠️ Ne confonds pas les deux transformations. **Translation → droite parallèle** ; **quart de tour → droite perpendiculaire**. C'est souvent ce que teste un exercice.

## 🛠️ Utiliser le quart de tour pour démontrer et construire

Grâce à ses conservations, le quart de tour **prouve** des égalités de longueurs et des perpendicularités d'un seul coup.

_Exemple détaillé_ : soient deux carrés ABCD et AEFG partageant le sommet A. Un quart de tour de centre A qui envoie B sur D envoie aussi E sur G ; il transforme donc le segment [BE] en [DG]. On en déduit d'un seul argument que **BE = DG** (conservation des longueurs) **et que (BE) ⊥ (DG)** (image d'une droite = perpendiculaire).

Il sert aussi à **construire** des figures régulières (par exemple un octogone régulier, par quarts de tour successifs autour du centre) et des triangles rectangles isocèles.

> 🏆 Septième quête franchie, héros : tu maîtrises une transformation qui conserve tout sauf la direction des droites, qu'elle rend perpendiculaires. Au dernier chapitre de géométrie, tu quittes le plan pour l'espace et les sections planes des solides.
