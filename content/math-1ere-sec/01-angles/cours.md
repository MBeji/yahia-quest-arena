# ⚔️ Angles — droites parallèles et cercle

> 💡 «Un angle bien lu, c'est une droite qui se trahit ou un cercle qui se dévoile. Apprends à faire parler les angles, et la figure n'aura plus de secret.»

Bienvenue en 1ère année secondaire, héros. Tu connais déjà les angles aigus, obtus, la bissectrice et les angles supplémentaires. Dans cette quête, tu apprends à t'en servir comme d'outils de preuve : montrer que deux droites sont parallèles, calculer un angle inconnu dans un cercle, prouver qu'un triangle est rectangle. C'est le socle de toute la géométrie de l'année.

## 🔺 Somme des angles et angle extérieur d'un triangle

Dans **tout triangle**, la somme des trois angles vaut **180°** :

$$ BAC + ABC + ACB = 180° $$

Un **angle extérieur** d'un triangle est l'angle formé par un côté et le prolongement d'un autre côté. Propriété clé :

> Un angle extérieur d'un triangle est égal à la **somme des deux angles intérieurs qui ne lui sont pas adjacents**.

_Exemple détaillé_ : dans le triangle ABC, on prolonge [BC] au-delà de C jusqu'à un point D. Si BAC = 60° et ABC = 50°, alors l'angle extérieur ACD = 60° + 50° = **110°**. Vérification : l'angle intérieur ACB = 180° − 110° = 70°, et 60° + 50° + 70° = 180° ✓.

::: figure L'angle extérieur en C vaut 110° — soit exactement la somme des deux angles intérieurs non adjacents (60° + 50°)
<svg viewBox="0 0 340 225">
<path d="M179 49 L60 190 L230 190 Z" fill="#0f6e56" opacity="0.10"/>
<path d="M179 49 L60 190 L230 190 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M230 190 L300 190" fill="none" stroke="#0f6e56" stroke-width="2" stroke-dasharray="7 4"/>
<path d="M92 190 A 32 32 0 0 0 80.6 165.5" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M157.1 75 A 34 34 0 0 0 190.6 81" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M260 190 A 30 30 0 0 0 219.8 161.9" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f172a"><circle cx="179" cy="49" r="4"/><circle cx="60" cy="190" r="4"/><circle cx="230" cy="190" r="4"/></g>
<g fill="#0f6e56"><circle cx="300" cy="190" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="179" y="38" text-anchor="middle" fill="#0f172a">A</text>
<text x="48" y="207" text-anchor="middle" fill="#0f172a">B</text>
<text x="228" y="209" text-anchor="middle" fill="#0f172a">C</text>
<text x="310" y="207" text-anchor="middle" fill="#0f6e56">D</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="104" y="176" text-anchor="middle" fill="#0f172a">50°</text>
<text x="170" y="107" text-anchor="middle" fill="#0f172a">60°</text>
<text x="262" y="158" text-anchor="middle" fill="#0f6e56">110°</text>
</g>
</svg>
:::

> 🗡️ L'angle extérieur et l'angle intérieur au même sommet sont **supplémentaires** (leur somme fait 180°) : c'est une deuxième façon rapide de trouver l'un à partir de l'autre.

## ↔️ Angles, sécante et droites parallèles

Une **sécante** coupe deux droites en deux points. Elle y forme des paires d'angles : **correspondants**, **alternes-internes**, et **intérieurs d'un même côté**. Quand les deux droites sont **parallèles** :

- deux angles **alternes-internes** sont **égaux** ;
- deux angles **correspondants** sont **égaux** ;
- deux angles **intérieurs d'un même côté** sont **supplémentaires** (somme = 180°).

_Exemple détaillé_ : deux droites parallèles (d) et (d') coupées par une sécante. Un angle mesure 65°. Son alterne-interne mesure aussi 65° ; son correspondant mesure 65° ; l'angle intérieur du même côté mesure 180° − 65° = 115°.

::: figure Deux angles alternes-internes: de part et d'autre de la sécante, entre les deux parallèles — ils sont égaux
<svg viewBox="0 0 320 235">
<path d="M50 80 H290 M50 180 H290" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M245.4 25.6 L154.3 220.8" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="none" stroke="#0f172a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M75 74 L82 80 L75 86"/>
<path d="M75 174 L82 180 L75 186"/>
</g>
<path d="M190 80 A 30 30 0 0 0 207.3 107.2" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M203.3 180 A 30 30 0 0 0 186 152.8" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f172a"><circle cx="220" cy="80" r="4"/><circle cx="173.3" cy="180" r="4"/></g>
<g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="62" y="72" text-anchor="middle" fill="#0f172a">(d)</text>
<text x="62" y="172" text-anchor="middle" fill="#0f172a">(d')</text>
<text x="181" y="112" text-anchor="middle" fill="#0f6e56">65°</text>
<text x="214" y="163" text-anchor="middle" fill="#0f6e56">65°</text>
</g>
</svg>
:::

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

::: figure L'angle inscrit AMB vaut la moitié de l'angle au centre AOB — les deux interceptent le même arc [AB]
<svg viewBox="0 0 320 250">
<circle cx="160" cy="130" r="95" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M160 130 L232.8 191.1 M160 130 L87.2 191.1" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M160 35 L232.8 191.1 M160 35 L87.2 191.1" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M183 149.3 A 30 30 0 0 1 137 149.3" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M173.5 64 A 32 32 0 0 1 146.5 64" fill="none" stroke="#0f172a" stroke-width="2"/>
<g fill="#0f172a"><circle cx="160" cy="130" r="4"/><circle cx="160" cy="35" r="4"/><circle cx="232.8" cy="191.1" r="4"/><circle cx="87.2" cy="191.1" r="4"/></g>
<g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="147" y="126" text-anchor="middle" fill="#0f172a">O</text>
<text x="160" y="25" text-anchor="middle" fill="#0f172a">M</text>
<text x="248" y="205" text-anchor="middle" fill="#0f172a">A</text>
<text x="72" y="205" text-anchor="middle" fill="#0f172a">B</text>
<text x="160" y="183" text-anchor="middle" fill="#0f6e56">100°</text>
<text x="160" y="90" text-anchor="middle" fill="#0f172a">50°</text>
</g>
</svg>
:::

> 🗡️ Conséquence directe : **deux angles inscrits qui interceptent le même arc sont égaux** (ils valent tous la moitié du même angle au centre). Très utile pour transporter une mesure d'un point à un autre du cercle.

> ⚠️ L'angle inscrit vaut la **moitié**, pas le double, de l'angle au centre — et les deux doivent intercepter **le même arc**. Deux angles inscrits sur des arcs différents n'ont aucune raison d'être égaux.

## 📐 Triangle rectangle inscrit dans un demi-cercle

Cas particulier capital : lorsque l'arc intercepté est un **demi-cercle**, l'angle au centre est un angle plat (180°), donc l'angle inscrit vaut 180° / 2 = 90°. D'où :

> Si l'un des côtés d'un triangle est un **diamètre** de son cercle circonscrit, alors ce triangle est **rectangle**, et l'angle droit est au sommet opposé à ce diamètre.

Réciproquement, on décrit ainsi un **lieu géométrique** : pour deux points fixes A et B, l'ensemble des points P tels que **APB = 90°** est le **cercle de diamètre [AB]** (privé de A et de B).

_Exemple détaillé_ : [BC] est un diamètre du cercle circonscrit au triangle ABC. Alors BAC = 90°. Si de plus ABC = 35°, on obtient ACB = 180° − 90° − 35° = **55°**.

> 🗡️ Application : les **tangentes** à un cercle de centre O menées depuis un point extérieur A touchent le cercle en des points T tels que OTA = 90° (le rayon est perpendiculaire à la tangente). Ces points de contact sont donc sur le cercle de diamètre [OA] — ce qui donne une construction au compas des tangentes.

> 🏆 Première quête franchie, héros : tu sais calculer un angle inconnu, prouver un parallélisme et débusquer un angle droit caché dans un cercle. Ces armes serviront dès le prochain chapitre, avec le théorème de Thalès.
