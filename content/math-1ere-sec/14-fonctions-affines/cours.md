# ⚔️ Fonctions affines

> 💡 «La fonction affine généralise la fonction linéaire : à la proportionnalité, elle ajoute un point de départ. Facture avec frais fixes, température en Fahrenheit, tarif d'abonnement : le monde réel est plein de droites qui ne passent pas par zéro.»

Tu connais la fonction linéaire f(x) = ax (chapitre 12). La **fonction affine** lui ajoute une constante b : f(x) = ax + b. Sa représentation reste une **droite**, mais elle ne passe plus forcément par l'origine. C'est l'un des objets les plus utiles des mathématiques, et la clé de la résolution graphique.

## 📈 Qu'est-ce qu'une fonction affine ?

Soient a et b deux réels. La fonction qui, à chaque réel x, associe **ax + b** est une **fonction affine** :

$$ f : x ↦ ax + b $$

f(x) = ax + b est l'**image** de x ; un **antécédent** d'un nombre y est un x tel que f(x) = y.

_Exemple détaillé_ : pour f : x ↦ 2x + 3, l'image de 4 est f(4) = 2 × 4 + 3 = 11. Pour l'antécédent de 3, on résout 2x + 3 = 3, soit x = 0.

## 🔑 Coefficient directeur et ordonnée à l'origine

Deux nombres décrivent entièrement une fonction affine :

- **b = f(0)** est l'**ordonnée à l'origine** (la valeur en x = 0) ;
- **a** est le **coefficient** (ou coefficient directeur), qui se calcule comme un **taux d'accroissement** :

$$ a = (f(x) − f(x')) / (x − x') $$

Deux cas particuliers : si **b = 0**, f est une fonction **linéaire** ; si **a = 0**, f est une fonction **constante** (f(x) = b pour tout x).

_Exemple détaillé_ : pour f : x ↦ 2x + 3, on a b = f(0) = 3. Et à partir de f(1) = 5 et f(3) = 9 : a = (9 − 5)/(3 − 1) = 4/2 = 2. On retrouve bien le coefficient 2.

## 📉 La représentation graphique

::: figure f : x ↦ 2x + 3 — l'ordonnée à l'origine b = 3 est là où la droite coupe l'axe vertical; le coefficient a = 2 est la montée pour un pas vers la droite
<svg viewBox="0 0 280 245">
<g stroke="#94a3b8" stroke-width="1" opacity="0.45">
<path d="M36 25 V230 M84 25 V230 M108 25 V230 M132 25 V230 M156 25 V230 M180 25 V230 M204 25 V230 M228 25 V230"/>
<path d="M20 37 H250 M20 61 H250 M20 85 H250 M20 109 H250 M20 133 H250 M20 157 H250 M20 181 H250 M20 229 H250"/>
</g>
<path d="M20 205 H248 M60 232 V28" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M254 205 L242 210 L242 200 Z M60 22 L55 34 L65 34 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="60" cy="205" r="3.5"/></g>
<text x="48" y="222" text-anchor="middle" font-size="14" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">O</text>
<path d="M24 205 L112 29" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M60 133 L84 133" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="5 3"/>
<path d="M84 133 L84 85" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="5 3"/>
<g fill="#0f6e56"><circle cx="60" cy="133" r="5"/><circle cx="84" cy="85" r="5"/></g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="46" y="130" text-anchor="middle" fill="#0f6e56">3</text>
<text x="72" y="150" text-anchor="middle" fill="#0f172a">+1</text>
<text x="99" y="114" text-anchor="middle" fill="#0f172a">+2</text>
<text x="150" y="60" text-anchor="middle" fill="#0f6e56">y = 2x + 3</text>
</g>
</svg>
:::

Dans un repère, la représentation graphique de f : x ↦ ax + b est une **droite d'équation** :

$$ y = ax + b $$

- **a** est le **coefficient directeur** (l'inclinaison de la droite) ;
- la droite passe par le point de coordonnées **(0 ; b)** (elle coupe l'axe des ordonnées à la hauteur b).

_Exemple détaillé_ : la droite d'équation y = 2x + 3 passe par (0 ; 3) et, en montant de 1 en x, monte de 2 en y (coefficient directeur 2). Deux points suffisent à la tracer, par exemple (0 ; 3) et (1 ; 5).

> ⚠️ Ne confonds pas les deux nombres : **a** donne l'inclinaison (la « pente »), **b** donne la hauteur où la droite coupe l'axe des ordonnées. Une droite horizontale a un coefficient directeur nul (a = 0).

## 🧩 Déterminer une fonction affine

Connaissant l'image de **deux** nombres (ou deux points de la droite), on retrouve a et b :

1. on calcule le coefficient a comme taux d'accroissement ;
2. on remplace dans f(x) = ax + b pour trouver b.

_Exemple détaillé_ : une fonction affine vérifie f(2) = 3 et f(4) = 1. Alors a = (1 − 3)/(4 − 2) = −2/2 = −1. Puis f(2) = −1 × 2 + b = 3 donne b = 5. Donc **f(x) = −x + 5**.

## 🔍 Résolution graphique

::: figure Résolution graphique de f(x) = 7: on part de 7 sur l'axe vertical, on rejoint la droite, on redescend — et on lit x = 2
<svg viewBox="0 0 280 245">
<g stroke="#94a3b8" stroke-width="1" opacity="0.45">
<path d="M36 25 V230 M84 25 V230 M108 25 V230 M132 25 V230 M156 25 V230 M180 25 V230 M204 25 V230 M228 25 V230"/>
<path d="M20 37 H250 M20 61 H250 M20 85 H250 M20 109 H250 M20 133 H250 M20 157 H250 M20 181 H250 M20 229 H250"/>
</g>
<path d="M20 205 H248 M60 232 V28" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M254 205 L242 210 L242 200 Z M60 22 L55 34 L65 34 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="60" cy="205" r="3.5"/></g>
<text x="48" y="222" text-anchor="middle" font-size="14" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">O</text>
<path d="M24 205 L112 29" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M60 37 L108 37" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="6 4"/>
<path d="M108 37 L108 205" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="6 4"/>
<g fill="#0f172a"><circle cx="108" cy="37" r="5"/></g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="46" y="34" text-anchor="middle" fill="#0f172a">7</text>
<text x="108" y="223" text-anchor="middle" fill="#0f172a">2</text>
<text x="168" y="64" text-anchor="middle" fill="#0f6e56">y = 2x + 3</text>
</g>
</svg>
:::

Représenter deux fonctions affines par leurs droites permet de **résoudre graphiquement** :

- l'**équation** f(x) = g(x) correspond au **point d'intersection** des deux droites (on lit son abscisse) ;
- l'**inéquation** f(x) ≤ g(x) correspond à la région où une droite est **au-dessous** de l'autre.

_Exemple détaillé_ : pour comparer deux tarifs, on trace la droite de chaque tarif ; leur intersection donne le nombre pour lequel les deux tarifs sont égaux, et de part et d'autre on lit lequel est le plus avantageux.

> 🏆 Quatorzième quête franchie, héros : la fonction affine et sa droite n'ont plus de secret, et tu sais résoudre en lisant un graphique. Au prochain chapitre, deux droites se rencontrent : les systèmes de deux équations.
