# ⚡ La tension électrique — la « pression » qui pousse le courant

> 💡 «Sur une pile, il est écrit 4,5 V ; sur une lampe, 3 V. Ce « V », c'est le volt, l'unité de la tension. Ce chapitre t'explique ce que mesure cette valeur — et pourquoi elle peut être négative.»

Tu sais mesurer le débit du courant (l'intensité). Voici la seconde grandeur clé : la **tension**. C'est elle qui caractérise un dipôle par ses bornes, et qui explique pourquoi un courant circule.

## ⚡ La tension et le volt

Les indications « 1,5 V », « 4,5 V », « 220 V » sur les piles, les lampes ou le compteur désignent une **tension**. La tension caractérise un dipôle **par ses deux bornes**. Elle est **notée U**, s'exprime en **volt** (symbole **V**) et se mesure avec un **voltmètre**.

## 🔀 Le voltmètre en dérivation

Contrairement à l'ampèremètre, le voltmètre se branche **en dérivation**, c'est-à-dire **aux bornes** du dipôle. Le courant entre par la borne **V** (rouge, +) et la borne **COM** (noire, −) se relie à l'autre borne.

::: figure Le voltmètre est branché en dérivation : ses deux fils rejoignent directement les deux bornes de la lampe, sans couper le circuit
<svg viewBox="0 0 300 165">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M35 55 H100"/><path d="M140 55 H265"/>
<path d="M85 55 V115"/><path d="M85 115 H105"/>
<path d="M155 55 V115"/><path d="M155 115 H135"/>
</g>
<circle cx="120" cy="55" r="18" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M107 42 L133 68 M133 42 L107 68" stroke="#0f172a" stroke-width="1.3"/>
<g fill="#0f172a"><circle cx="85" cy="55" r="3.5"/><circle cx="155" cy="55" r="3.5"/></g>
<circle cx="120" cy="115" r="16" fill="#e0e7ff" stroke="#0f172a" stroke-width="2"/>
<text x="120" y="121" font-size="15" font-weight="700" fill="#0f172a" text-anchor="middle">V</text>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="120" y="27">lampe</text><text x="120" y="150">voltmètre</text>
</g>
</svg>
:::

## 🔌 Dipôle isolé : générateur ou récepteur

Mesure la tension aux bornes d'un dipôle **isolé** (non branché dans un circuit). Deux cas :

- aux bornes d'un **générateur** (une pile), la tension est **non nulle** ;
- aux bornes d'un **récepteur** (lampe, moteur, diode) isolé, la tension est **nulle**.

C'est un test : **un dipôle isolé dont la tension n'est pas nulle est un générateur.**

Deux mots à ne pas confondre :

- la **force électromotrice (f.é.m.)** : la tension d'un générateur **à vide** (non branché à un récepteur) ;
- la **tension nominale** : la tension qu'il faut appliquer à un **récepteur** pour qu'il fonctionne normalement. En dessous, il fonctionne mal ; **au-dessus, il se détériore**.

## ➕➖ La tension est algébrique

Inverse les branchements d'un voltmètre numérique : il affiche la **même valeur, mais négative**. La **tension est une grandeur algébrique** : elle peut être positive ou négative.

On note **UAB** la tension aux bornes d'un dipôle placé entre A et B, mesurée quand la borne **V** est reliée à A et **COM** à B. On la représente par une **flèche allant de B vers A**. Inverser les points inverse le signe :

$$ UAB = −UBA $$

La tension UAB est aussi appelée **différence de potentiel** (d.d.p.), notée VA − VB.

> ⚠️ Piège classique : « l'unité de la tension est le voltmètre ». Non ! L'unité est le **volt (V)** ; le **voltmètre** est l'appareil de mesure. Ne confonds pas la grandeur et l'instrument.

## 🔄 La loi des mailles

Aux bornes d'un **fil** parcouru par un courant, la tension est **nulle**. Sur une **maille** (une boucle fermée), les tensions se compensent :

> 🗡️ **Loi des mailles** : dans une maille, la **somme algébrique** des tensions aux bornes des différents dipôles est **nulle**.

_Exemple détaillé_ : un générateur de tension U = 6 V alimente deux lampes en série, de tensions U₁ et U₂. La loi des mailles donne U = U₁ + U₂. Si U₁ = 2 V, alors U₂ = 6 − 2 = **4 V** ✓.

::: figure Autour de la maille, la tension du générateur se répartit sur les deux lampes : U = U₁ + U₂, soit 6 = 2 + 4
<svg viewBox="0 0 320 175">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 50 V78"/><path d="M55 112 V150"/>
<path d="M55 50 H115"/><path d="M155 50 H205"/><path d="M245 50 H265"/>
<path d="M265 50 V150"/><path d="M55 150 H265"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 85 H70"/><path d="M48 106 H62"/></g>
<circle cx="135" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M124 39 L146 61 M146 39 L124 61" stroke="#0f172a" stroke-width="1.3"/>
<circle cx="225" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M214 39 L236 61 M236 39 L214 61" stroke="#0f172a" stroke-width="1.3"/>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="30" y="90">+</text>
<text x="90" y="172" text-anchor="start">U = 6 V (générateur)</text>
<text x="135" y="90">U₁ = 2 V</text>
<text x="225" y="90">U₂ = 4 V</text>
</g>
</svg>
:::

## 📉 L'oscilloscope et la tension continue

Un **oscilloscope** permet de **visualiser** une tension et d'en mesurer la valeur. Branche une pile plate à son entrée : l'écran affiche un **trait horizontal**. Cela signifie que la tension **ne varie pas au cours du temps** : c'est une **tension continue**.

> 🏆 Dernière quête du thème L'ÉLECTRICITÉ franchie, héros ! Tu sais mesurer une tension au voltmètre, distinguer générateur et récepteur, manier son signe et appliquer la loi des mailles. Intensité et tension en main, tu es prêt pour la suite : la caractéristique d'un dipôle.
