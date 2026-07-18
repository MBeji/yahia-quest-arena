# ⚡ Le dipôle résistor — quand tension et intensité marchent au pas

> 💡 «Tu sais mesurer une intensité et une tension. Question de héros : quand tu doubles la tension aux bornes d'un composant, que devient le courant qui le traverse ? Pour un dipôle bien particulier, la réponse est d'une simplicité redoutable.»

Tu maîtrises l'intensité I (le débit du courant) et la tension U (aux bornes d'un dipôle). Ce chapitre relie enfin les deux : pour un **dipôle résistor**, U et I obéissent à une loi limpide, la **loi d'Ohm**.

## 📈 La caractéristique intensité-tension

Branche un dipôle récepteur à un générateur **réglable**. Pour chaque valeur de la tension U appliquée, tu relèves l'intensité I qui traverse le dipôle. En plaçant tous les couples (I, U) dans un repère, tu obtiens une courbe.

Cette courbe, qui représente **U en fonction de I**, s'appelle la **caractéristique intensité-tension** du dipôle. Elle est la carte d'identité électrique du composant : deux dipôles différents n'ont pas la même caractéristique.

## 📐 Le dipôle résistor : une droite qui passe par l'origine

Pour certains dipôles, la caractéristique est une **portion de droite qui passe par l'origine**. Un tel dipôle est appelé **dipôle résistor** (ou **conducteur ohmique**).

::: figure Pour un dipôle résistor, la caractéristique U = f(I) est une droite qui part de l'origine : U et I augmentent ensemble, dans le même rapport
<svg viewBox="0 0 220 160">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M35 20 V132 H205"/>
<path d="M35 132 L190 38"/>
</g>
<g fill="#0f172a" font-size="12" font-weight="700">
<text x="18" y="26">U</text>
<text x="196" y="150">I</text>
<text x="24" y="146">O</text>
</g>
</svg>
:::

Une droite passant par l'origine, en mathématiques, signale une **proportionnalité**. Ici : **la tension U et l'intensité I sont proportionnelles**. Le quotient U/I garde donc la **même valeur** en tout point de la droite.

## 🛡️ La résistance et la loi d'Ohm

Ce quotient constant est une nouvelle grandeur : la **résistance** du résistor, notée **R**.

$$ R = U / I $$

Elle mesure à quel point le dipôle **s'oppose au passage du courant** : à tension égale, plus R est grande, moins il passe de courant. La résistance s'exprime dans le système international en **ohm**, de symbole **Ω**.

En réarrangeant ce quotient, on obtient la relation reine du chapitre, la **loi d'Ohm** :

$$ U = R × I $$

> 🗡️ **Loi d'Ohm** : la tension U aux bornes d'un résistor est égale au produit de sa résistance R par l'intensité I qui le traverse.

_Exemple détaillé_ : un résistor de résistance **R = 12 Ω** est traversé par un courant **I = 0,5 A**. La tension à ses bornes vaut U = R × I = 12 × 0,5 = **6 V** ✓. Inversement, si tu mesures U = 6 V et I = 0,5 A, tu retrouves R = U/I = 6 ÷ 0,5 = **12 Ω**.

## 🔧 Mesurer une résistance

Deux moyens de connaître R sans tracer de graphique :

- l'**ohmmètre** (une fonction du multimètre) : hors tension, on branche le résistor entre les bornes **COM** et **Ω**, et la valeur s'affiche directement ;
- le **code des couleurs** : des anneaux colorés imprimés sur le résistor codent sa valeur, qui se lit directement.

## 🎛️ Le rhéostat : régler l'intensité

Un **rhéostat** est un **résistor réglable** : en déplaçant un curseur, on modifie la longueur de fil parcourue, donc sa résistance. Inséré dans un circuit, il permet de **commander l'intensité** du courant — c'est ainsi qu'on ajuste la vitesse d'un moteur ou l'éclat d'une lampe.

## 🔮 Tous les dipôles ne se ressemblent pas

Attention : **tous les dipôles ne sont pas des résistors**. La lampe à incandescence, l'électrolyseur ou la diode ont des caractéristiques qui ne sont **pas des droites passant par l'origine**. Ils ne réalisent donc pas de relation de proportionnalité entre U et I.

> ⚠️ Piège classique : « une droite, donc un résistor ». Non ! Il faut une droite **qui passe par l'origine**. Une caractéristique courbe, ou une droite décalée, n'est pas celle d'un résistor.

Enfin, le corps humain est lui aussi un conducteur, de résistance **5000 Ω** environ (peau sèche) mais seulement **1000 Ω** si la peau est mouillée. Comme I = U/R, une tension d'autant plus faible devient dangereuse que la résistance chute : le seuil de danger tombe à **25 V** en milieu humide, contre **50 V** en conditions habituelles.

> 🏆 Dernière quête du thème L'ÉLECTRICITÉ franchie, héros ! Tu sais lire une caractéristique, reconnaître un résistor, appliquer la loi d'Ohm et manier le rhéostat. Range tes fils : le prochain thème t'attend, LA MATIÈRE et ses trois états.
