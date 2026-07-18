# 🔋 L'intensité du courant électrique — mesurer le débit

> 💡 «Deux lampes, deux éclats différents : l'une brille fort, l'autre à peine. La différence, c'est l'intensité du courant qui les traverse. Ce chapitre t'apprend à la mesurer et à prévoir sa valeur.»

Tu sais faire circuler un courant. Reste à le **mesurer**. Le courant électrique a un « débit » : son **intensité**. Mais d'abord, il faut savoir de quelle façon les dipôles sont associés.

## 🔗 Série ou dérivation

Avec un générateur et plusieurs dipôles, on distingue **deux sortes de montages** :

| Montage                    | Comment les dipôles sont branchés            |
| -------------------------- | -------------------------------------------- |
| **série**                  | les uns à la suite des autres, en une boucle |
| **dérivation** (parallèle) | sur des branches séparées                    |

Dans un montage en dérivation à un seul générateur :

- la **branche principale** est celle qui contient le **générateur** ;
- les **branches dérivées** sont celles des récepteurs ;
- un **nœud** est un point où se rencontrent **plus de deux branches** ;
- une **maille** est une boucle fermée du circuit.

::: figure Le générateur est sur la branche principale ; les deux lampes sont sur des branches dérivées qui se rejoignent aux nœuds — les points où trois fils se rencontrent
<svg viewBox="0 0 300 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 55 H245"/><path d="M55 150 H245"/>
<path d="M55 55 V85"/><path d="M55 115 V150"/>
<path d="M245 55 V88"/><path d="M245 112 V150"/>
<path d="M150 55 V88"/><path d="M150 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 88 H70"/><path d="M48 110 H62"/></g>
<circle cx="245" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M236.5 91.5 L253.5 108.5 M253.5 91.5 L236.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<circle cx="150" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M141.5 91.5 L158.5 108.5 M158.5 91.5 L141.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<g fill="#dc2626"><circle cx="150" cy="55" r="4.5"/><circle cx="150" cy="150" r="4.5"/></g>
<g font-size="11" font-weight="700" fill="#0f172a">
<text x="30" y="82">+</text>
<text x="55" y="175" text-anchor="middle">branche principale</text>
<text x="198" y="45" text-anchor="middle" fill="#dc2626">nœud</text>
</g>
</svg>
:::

## 📊 L'intensité et l'ampère

Deux piles branchées sur une même lampe la font briller différemment : une grandeur caractérise cette différence, l'**intensité** du courant. Elle est **notée I** et s'exprime, dans le système international, en **ampère** (symbole **A**). On la mesure avec un **ampèremètre** (à aiguille ou numérique).

## 🎛️ Mesurer avec l'ampèremètre

L'ampèremètre se branche **en série**, en respectant ses bornes : le courant entre par la borne **A** (rouge, +) et sort par la borne **COM** (noire, −). Le **calibre** est la **plus grande intensité** que l'appareil peut mesurer.

**Règle du calibre** : on commence par le **plus grand** calibre (aucun risque), puis on descend vers le **plus petit calibre adapté** — c'est lui qui donne la mesure la plus **précise**. Sur un appareil à aiguille, on lit :

$$ Valeur = Lecture × Calibre ÷ Échelle $$

_Exemple détaillé_ : calibre **1 A**, échelle de **100** divisions, aiguille sur la division **40**. Alors Valeur = 40 × 1 ÷ 100 = **0,40 A** ✓.

## ➖ En série : une seule intensité

Insère l'ampèremètre à différents endroits d'un **circuit série** : il indique **toujours la même valeur**.

> 🗡️ **Dans un circuit série, l'intensité du courant est la même en tout point** — quel que soit l'ordre des dipôles. Ajouter un récepteur en série **diminue** cette intensité commune.

Si aucun effet du courant n'apparaît, c'est que l'intensité est **nulle** : il y a une **coupure** quelque part (appareil grillé, fil coupé, mauvais contact).

## ➕ La loi des nœuds

En dérivation, le courant se **partage** aux nœuds. Mesure les intensités de chaque branche : celle de la branche principale est la **somme** de celles des branches dérivées.

::: figure Au nœud, le courant entrant se partage entre les deux branches : 0,90 A d'un côté, 0,65 A et 0,25 A de l'autre, et 0,65 + 0,25 = 0,90
<svg viewBox="0 0 300 160">
<path d="M35 80 H126" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 73 L250 38" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 87 L250 122" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<circle cx="145" cy="80" r="5.5" fill="#dc2626"/>
<defs><marker id="nd" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>
<g font-size="13" font-weight="700" fill="#0f172a">
<text x="55" y="72">I₁ = 0,90 A</text>
<text x="205" y="32">I₂ = 0,65 A</text>
<text x="205" y="140">I₃ = 0,25 A</text>
</g>
<text x="145" y="108" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">nœud</text>
</svg>
:::

**Loi des nœuds** : la somme des intensités des courants qui **arrivent** à un nœud est égale à la somme des intensités des courants qui en **partent**. Ici : I₁ = I₂ + I₃, soit 0,90 = 0,65 + 0,25 ✓.

## 🛡️ Fusible et sécurité

Un **fusible** protège le circuit : c'est un fil qui **fond** dès que l'intensité dépasse une valeur donnée, coupant le courant. L'intensité est aussi une affaire de **sécurité** — le corps humain n'est ni bon conducteur ni isolant :

| Intensité traversant le corps | Conséquence          |
| ----------------------------- | -------------------- |
| 30 mA                         | paralysie musculaire |
| 50 mA                         | asphyxie             |
| 100 mA                        | fibrillation du cœur |

> 🏆 Troisième quête franchie, héros ! Tu sais distinguer série et dérivation, mesurer une intensité au bon calibre, et appliquer la loi des nœuds. Il te manque une dernière grandeur pour tout relier : la **tension**.
