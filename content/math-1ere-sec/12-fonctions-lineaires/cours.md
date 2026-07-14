# ⚔️ Fonctions linéaires

> 💡 «Une fonction linéaire, c'est la proportionnalité mise en formule : double l'entrée, tu doubles la sortie. Prix, distances, pourcentages : le monde des grandeurs proportionnelles obéit à f(x) = ax.»

Voici ta première **fonction** : un procédé qui, à chaque nombre x, associe un nombre f(x). La plus simple et la plus utile est la **fonction linéaire**, celle de la proportionnalité. Tu apprends à la reconnaître, à la représenter par une droite, à lire un graphique et à l'utiliser pour les pourcentages. C'est la porte d'entrée d'un thème majeur des mathématiques.

## 📈 Qu'est-ce qu'une fonction linéaire ?

Soit a un réel fixé. La fonction qui, à chaque réel x, associe le réel **ax** est une **fonction linéaire**. On la note :

$$ f : x ↦ ax $$

- **a** est le **coefficient** de f ;
- **f(x) = ax** est l'**image** de x par f ;
- x est un **antécédent** de f(x).

_Exemple détaillé_ : pour f : x ↦ 3x, l'image de 2 est f(2) = 3 × 2 = 6. Pour trouver l'antécédent de 12, on résout 3x = 12, soit x = 4 : l'antécédent de 12 est 4.

## 🔑 Les propriétés caractéristiques

Toute fonction linéaire f : x ↦ ax vérifie :

$$ f(0) = 0 et f(1) = a $$

De plus, elle « respecte l'addition » : pour tous réels x et x', f(x + x') = f(x) + f(x').

_Exemple détaillé_ : le coefficient est l'image de 1. Donc si l'on connaît f(1), on connaît a. Réciproquement, si une fonction vérifie f(0) ≠ 0, elle **n'est pas** linéaire.

> 🗡️ Pour trouver le coefficient à partir d'une image connue : a = f(x) / x. Par exemple, si f(5) = 15, alors a = 15/5 = 3, et f : x ↦ 3x.

## 📉 La représentation graphique

::: figure La représentation d'une fonction linéaire est une droite qui passe par l'origine — et le coefficient a se lit directement: c'est f(1)
<svg viewBox="0 0 280 245">
<g stroke="#94a3b8" stroke-width="1" opacity="0.45">
<path d="M36 25 V230 M84 25 V230 M108 25 V230 M132 25 V230 M156 25 V230 M180 25 V230 M204 25 V230 M228 25 V230"/>
<path d="M20 37 H250 M20 61 H250 M20 85 H250 M20 109 H250 M20 133 H250 M20 157 H250 M20 181 H250 M20 229 H250"/>
</g>
<path d="M20 205 H248 M60 232 V28" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M254 205 L242 210 L242 200 Z M60 22 L55 34 L65 34 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="60" cy="205" r="3.5"/></g>
<text x="48" y="222" text-anchor="middle" font-size="14" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">O</text>
<path d="M36 229 L150 1" fill="none" stroke="#0f6e56" stroke-width="0"/>
<path d="M48 229 L146 33" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M60 205 L84 205" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="5 3"/>
<path d="M84 205 L84 157" fill="none" stroke="#0f172a" stroke-width="2" stroke-dasharray="5 3"/>
<g fill="#0f6e56"><circle cx="84" cy="157" r="5"/></g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="72" y="222" text-anchor="middle" fill="#0f172a">+1</text>
<text x="99" y="186" text-anchor="middle" fill="#0f172a">+2</text>
<text x="106" y="150" text-anchor="middle" fill="#0f6e56">f(1) = 2</text>
</g>
</svg>
:::

Dans un repère (O, I, J), la représentation graphique de f : x ↦ ax est une **droite qui passe par l'origine O**, d'équation :

$$ y = ax $$

Cette droite passe aussi par le point A(1 ; a). Il suffit donc de deux points — O et A(1 ; a) — pour la tracer.

_Exemple détaillé_ : la fonction f : x ↦ 2x est représentée par la droite d'équation y = 2x, passant par O(0 ; 0) et par A(1 ; 2).

> ⚠️ La droite d'une fonction linéaire passe **toujours** par l'origine (car f(0) = 0). Si une droite ne passe pas par O, elle ne représente pas une fonction linéaire (ce sera une fonction affine, au chapitre 14).

## 🔍 Lire un graphique

::: figure Le signe du coefficient décide du sens: a > 0 donne une droite qui monte, a < 0 une droite qui descend
<svg viewBox="0 0 280 245">
<g stroke="#94a3b8" stroke-width="1" opacity="0.45">
<path d="M36 25 V230 M84 25 V230 M108 25 V230 M132 25 V230 M156 25 V230 M180 25 V230 M204 25 V230 M228 25 V230"/>
<path d="M20 37 H250 M20 61 H250 M20 85 H250 M20 109 H250 M20 133 H250 M20 157 H250 M20 181 H250 M20 229 H250"/>
</g>
<path d="M20 205 H248 M60 232 V28" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M254 205 L242 210 L242 200 Z M60 22 L55 34 L65 34 Z" fill="#0f172a"/>
<g fill="#0f172a"><circle cx="60" cy="205" r="3.5"/></g>
<text x="48" y="222" text-anchor="middle" font-size="14" font-weight="700" fill="#0f172a" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">O</text>
<path d="M48 229 L146 33" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M20 157 L84 229" fill="none" stroke="#0f172a" stroke-width="2.5" stroke-dasharray="7 4"/>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="168" y="50" text-anchor="middle" fill="#0f6e56">y = 2x</text>
<text x="44" y="150" text-anchor="middle" fill="#0f172a">y = −x</text>
</g>
</svg>
:::

Sur la droite d'une fonction linéaire, on lit directement :

- l'**image** d'un nombre : on part de x sur l'axe des abscisses, on monte jusqu'à la droite, on lit y = f(x) ;
- l'**antécédent** d'un nombre : on part de y sur l'axe des ordonnées, on rejoint la droite, on lit x ;
- le **coefficient** a : à partir d'un point M(x ; y) de la droite, a = y/x.

_Exemple détaillé_ : si la droite passe par le point M(4 ; 6), alors a = 6/4 = 1,5, donc f : x ↦ 1,5x.

## 💯 Fonctions linéaires et pourcentages

Augmenter ou diminuer d'un pourcentage, c'est appliquer une fonction linéaire :

- une **hausse de t %** correspond à f : x ↦ (1 + t/100) x ;
- une **baisse de t %** correspond à f : x ↦ (1 − t/100) x.

_Exemple détaillé_ : une hausse de 20 % multiplie par 1,2 (f : x ↦ 1,2x) ; une baisse de 15 % multiplie par 0,85 (f : x ↦ 0,85x). Deux variations **successives** se composent : une baisse de 10 % suivie d'une hausse de 10 % donne × 0,9 × 1,1 = × 0,99, soit une baisse nette de 1 % (et non un retour au prix initial !).

> 🏆 Douzième quête franchie, héros : tu manies la proportionnalité en fonction, tu la lis sur une droite et tu domptes les pourcentages. Bientôt, tu généraliseras avec les fonctions affines. Place d'abord aux équations et inéquations.
