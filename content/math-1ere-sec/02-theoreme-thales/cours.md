# ⚔️ Théorème de Thalès et sa réciproque

> 💡 «Deux parallèles qui traversent un angle y découpent des longueurs proportionnelles. Cette seule idée mesure la hauteur d'un arbre, la taille de la Lune, et bien plus.»

Tu sais déjà, depuis le collège, que la droite des milieux d'un triangle est parallèle au troisième côté. Le théorème de Thalès en est la version générale : il relie par des **rapports égaux** les longueurs découpées par deux parallèles. Sa réciproque, elle, sert à **démontrer** qu'on a bien deux droites parallèles. C'est l'outil roi de la géométrie proportionnelle.

## 📏 La droite des milieux

Point de départ, à connaître par cœur :

> Dans un triangle, la droite qui joint les **milieux de deux côtés** est **parallèle au troisième côté** (et la longueur qu'elle porte en vaut la moitié).

Et sa réciproque :

> Dans un triangle, la droite qui passe par le **milieu d'un côté** et qui est **parallèle à un deuxième côté** coupe le **troisième côté en son milieu**.

_Exemple détaillé_ : dans le triangle ABC, I est le milieu de [AB] et J le milieu de [AC]. Alors (IJ) // (BC) et IJ = BC / 2. Si BC = 8 cm, alors IJ = 4 cm.

::: figure La droite des milieux: (IJ) est parallèle à (BC) et deux fois plus courte — ici BC = 8 cm donc IJ = 4 cm
<svg viewBox="0 0 340 250">
<path d="M170 30 L105 122.5 L235 122.5 Z" fill="#0f6e56" opacity="0.12"/>
<path d="M170 30 L40 215 L300 215 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M105 122.5 L235 122.5" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M165 116.5 L172 122.5 L165 128.5"/>
<path d="M165 209 L172 215 L165 221"/>
</g>
<g fill="#0f172a"><circle cx="170" cy="30" r="4"/><circle cx="40" cy="215" r="4"/><circle cx="300" cy="215" r="4"/></g>
<g fill="#0f6e56"><circle cx="105" cy="122.5" r="4"/><circle cx="235" cy="122.5" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="20" text-anchor="middle" fill="#0f172a">A</text>
<text x="27" y="233" text-anchor="middle" fill="#0f172a">B</text>
<text x="313" y="233" text-anchor="middle" fill="#0f172a">C</text>
<text x="90" y="119" text-anchor="middle" fill="#0f6e56">I</text>
<text x="250" y="119" text-anchor="middle" fill="#0f6e56">J</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="116" text-anchor="middle" fill="#0f6e56">4</text>
<text x="170" y="234" text-anchor="middle" fill="#0f172a">8</text>
</g>
</svg>
:::

## 🔺 Le théorème de Thalès dans un triangle

On généralise : les points ne sont plus forcément des milieux.

> Soient deux droites (AB) et (AC) sécantes en A, un point M de (AB) et un point N de (AC). **Si (MN) et (BC) sont parallèles**, alors :

$$ AM/AB = AN/AC = MN/BC $$

Les trois rapports sont égaux : ils portent le **même coefficient**, qui compare la petite figure à la grande.

_Exemple détaillé_ : dans le triangle ABC, M est sur [AB] et N sur [AC] avec (MN) // (BC). On donne AB = 6 cm, AM = 4 cm et BC = 9 cm. Le coefficient est AM/AB = 4/6 = 2/3. Donc MN = BC × 2/3 = 9 × 2/3 = **6 cm**, et de même AN = AC × 2/3.

::: figure Le coefficient 2/3 se lit sur les trois rapports à la fois: AM/AB = AN/AC = MN/BC
<svg viewBox="0 0 340 250">
<path d="M170 30 L83.3 153.3 L256.7 153.3 Z" fill="#0f6e56" opacity="0.12"/>
<path d="M170 30 L40 215 L300 215 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M83.3 153.3 L256.7 153.3" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
<path d="M165 147.3 L172 153.3 L165 159.3"/>
<path d="M165 209 L172 215 L165 221"/>
</g>
<g fill="#0f172a"><circle cx="170" cy="30" r="4"/><circle cx="40" cy="215" r="4"/><circle cx="300" cy="215" r="4"/></g>
<g fill="#0f6e56"><circle cx="83.3" cy="153.3" r="4"/><circle cx="256.7" cy="153.3" r="4"/></g>
<g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="20" text-anchor="middle" fill="#0f172a">A</text>
<text x="27" y="233" text-anchor="middle" fill="#0f172a">B</text>
<text x="313" y="233" text-anchor="middle" fill="#0f172a">C</text>
<text x="70" y="150" text-anchor="middle" fill="#0f6e56">M</text>
<text x="270" y="150" text-anchor="middle" fill="#0f6e56">N</text>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="112" y="85" text-anchor="middle" fill="#0f6e56">4</text>
<text x="47" y="181" text-anchor="middle" fill="#0f172a">2</text>
<text x="170" y="147" text-anchor="middle" fill="#0f6e56">6</text>
<text x="170" y="234" text-anchor="middle" fill="#0f172a">9</text>
</g>
</svg>
:::

> 🗡️ Méthode sûre : écris d'abord la chaîne des trois rapports **dans le même ordre** (sommet A en haut de chaque fraction : AM/AB, AN/AC, MN/BC), puis remplace ce que tu connais. Tu évites ainsi d'inverser un rapport.

## 🔁 La réciproque du théorème de Thalès

C'est le sens inverse : de l'égalité des rapports, on **déduit** le parallélisme.

> Soient deux droites (AB) et (AC) sécantes en A, M un point de (AB) et N un point de (AC). **Si AM/AB = AN/AC** (les points M et N étant placés dans le même ordre à partir de A), **alors (MN) et (BC) sont parallèles**.

_Exemple détaillé_ : dans le triangle ABC, AB = 6, AM = 4, AC = 7,5 et AN = 5. On compare : AM/AB = 4/6 = 2/3 et AN/AC = 5/7,5 = 2/3. Les deux rapports sont égaux, donc **(MN) // (BC)**.

> ⚠️ La réciproque n'est valable que si M et N sont placés **dans le même ordre** par rapport à A (les deux du même côté, ou les deux de l'autre côté). Si l'un est « au-delà » de A et l'autre non, l'égalité des rapports ne suffit plus : vérifie toujours la disposition des points sur la figure.

## 🔍 Agrandissement, réduction et échelle

Multiplier toutes les longueurs d'une figure par un même nombre **k > 0** donne une figure de même forme : un **agrandissement** si k > 1, une **réduction** si k < 1. Le nombre k est l'**échelle**. Effet de l'échelle :

| grandeur  | est multipliée par |
| --------- | ------------------ |
| longueurs | k                  |
| périmètre | k                  |
| **aire**  | **k²**             |

_Exemple détaillé_ : on agrandit un triangle d'aire 5 cm² à l'échelle k = 3. Les longueurs triplent, le périmètre triple, mais l'aire est multipliée par k² = 9 : la nouvelle aire vaut 5 × 9 = **45 cm²**.

> ⚠️ L'erreur la plus fréquente : multiplier l'aire par k au lieu de k². Une échelle 2 double les longueurs mais **quadruple** l'aire.

## 🛠️ Construire et partager grâce à Thalès

Le théorème sert aussi à **construire** :

- **Partager un segment dans une proportion donnée** : pour placer M sur [AB] tel que AM = (2/5)AB, on trace une demi-droite issue de A, on y reporte 5 segments isométriques, on joint le 5ᵉ point à B, et les parallèles à cette droite découpent [AB] en 5 parts égales — M est au 2ᵉ point.
- **Quatrième proportionnelle** : construire une longueur d inconnue vérifiant une égalité de rapports comme a/b = c/d se fait par la même configuration de deux droites et deux parallèles.

_Exemple détaillé_ : pour placer M tel que AM/MB = 3/2, on partage [AB] en 3 + 2 = 5 parts égales par la méthode ci-dessus, et M tombe après la 3ᵉ part.

> 🏆 Deuxième quête franchie, héros : tu manies les rapports de Thalès dans les deux sens et tu sais qu'une aire se dilate en k². Ces proportions te suivront jusqu'à la trigonométrie du prochain chapitre.
