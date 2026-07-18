# 🔌 Le circuit électrique — mettre le courant en route

> 💡 «Une pile toute seule ne sert à rien ; une lampe toute seule non plus. C'est en les reliant que la lampe s'allume. Ce chapitre t'apprend la règle du jeu : comment faire circuler un courant, et dans quel sens.»

Au chapitre 1, les charges restaient immobiles. Maintenant, on les fait **circuler**. Un courant électrique parcourt un ensemble de composants reliés : un **circuit**. Voyons comment le construire, le lire et le protéger.

## 🔌 Dipôles et circuit fermé

Une pile, une lampe, un moteur ont un point commun : chacun possède **deux bornes** de connexion. On les appelle des **dipôles**. Relie-les bout à bout par des fils : tu formes une **chaîne**.

- Si la chaîne est **continue** (aucune coupure) et contient **au moins un générateur**, un courant circule : c'est un **circuit électrique fermé**.
- Le **générateur** (la pile) est le dipôle qui **fait apparaître** le courant. La lampe et le moteur sont des **récepteurs** : ils **utilisent** le courant pour fonctionner, mais ne peuvent pas le créer.

## 🔥 Les quatre effets du courant

Comment savoir qu'un courant passe ? Par ses **effets**. Le manuel en retient **quatre** :

| Effet          | On l'observe quand…                               | Exemple              |
| -------------- | ------------------------------------------------- | -------------------- |
| **thermique**  | un conducteur **chauffe**                         | filament d'une lampe |
| **chimique**   | le courant **transforme la matière**              | électrolyseur        |
| **magnétique** | une aiguille aimantée **dévie**                   | près d'un fil        |
| **lumineux**   | un composant **émet de la lumière** sans chauffer | DEL                  |

> 🗡️ La manifestation de **l'un** de ces effets **prouve** le passage d'un courant. Selon les composants, plusieurs effets peuvent apparaître à la fois (une DEL : lumineux, et un peu magnétique).

## 🚧 Conducteurs, isolants et circuit ouvert

Coupe la chaîne et intercale un objet. S'il **laisse passer** le courant (la lampe se rallume), c'est un **conducteur** (métaux, carbone). S'il **bloque** le courant, c'est un **isolant** (plastique, bois, verre). Un circuit qui contient un isolant dans sa chaîne est un **circuit ouvert** : aucun courant n'y circule.

Un circuit n'est parcouru par un courant que s'il remplit **deux conditions** :

1. il comporte un **dipôle générateur** ;
2. il forme une **chaîne continue de conducteurs**.

> 🗡️ L'air sec est isolant ; mais l'air humide, l'eau et le corps humain sont de **mauvais conducteurs** — d'où le danger de l'électricité près de l'eau.

## ✏️ Schématiser un circuit

Pour dessiner un circuit sans faire de portrait, on utilise des **symboles normalisés** : les mêmes pour tout le monde.

::: figure Un circuit fermé : le générateur (pile) impose le courant, qui parcourt la chaîne continue et allume la lampe ; la flèche rouge donne le sens conventionnel
<svg viewBox="0 0 320 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M60 55 V88"/><path d="M60 112 V150"/>
<path d="M60 55 H260"/><path d="M60 150 H260"/>
<path d="M260 55 V88"/><path d="M260 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M44 92 H76"/><path d="M52 112 H68"/></g>
<circle cx="260" cy="100" r="13" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M251 91 L269 109 M269 91 L251 109" stroke="#0f172a" stroke-width="1.5"/>
<path d="M150 55 H178" stroke="#dc2626" stroke-width="2.6" fill="none" marker-end="url(#c2)"/>
<defs><marker id="c2" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#dc2626"/></marker></defs>
<g font-size="14" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="34" y="97">+</text><text x="34" y="117">−</text>
<text x="60" y="178">pile</text><text x="260" y="140">lampe</text>
</g>
<text x="164" y="46" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">sens du courant</text>
</svg>
:::

Retiens les symboles cités par le programme : **fil, générateur, lampe, moteur, interrupteur** (ouvert ou fermé), **diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre**.

## ➡️ Le sens du courant et sa nature

Le courant a un **sens**. **Par convention**, à l'**extérieur** du générateur, il circule de la **borne positive (+)** vers la **borne négative (−)**. C'est le **sens conventionnel**.

Mais que sont ces « porteurs » qui circulent vraiment ?

- **Dans les métaux** : ce sont les **électrons** (dits électrons de conduction). Comme ils sont négatifs, ils se déplacent **en sens inverse** du sens conventionnel — vers la borne **+** du générateur.
- **Dans les solutions ioniques** (électrolytes) : ce sont des **ions**. Les **cations** (positifs) se déplacent dans le **sens conventionnel** (vers la borne −), les **anions** (négatifs) dans le sens inverse (vers la borne +).

> ⚠️ Piège classique : « le courant, ce sont toujours des électrons ». Non — dans une solution ionique, ce sont des **ions** qui se déplacent, pas des électrons.

## 🔀 La diode et le court-circuit

La **diode** est un dipôle **dissymétrique** : ses deux bornes ne jouent pas le même rôle. Elle ne laisse passer le courant que dans **un seul sens** :

- dans le **sens passant**, elle se comporte comme un **interrupteur fermé** ;
- dans le **sens bloquant**, comme un **interrupteur ouvert**.

Elle sert donc à imposer, ou à repérer, le sens du courant. La **DEL** (diode électroluminescente) est une diode qui, en plus, **émet de la lumière**.

Enfin, un **court-circuit** : on relie les deux bornes d'un dipôle par un simple **fil conducteur**. Le courant passe alors par le fil au lieu du dipôle : le dipôle **court-circuité est mis hors usage**. Aux bornes d'un **générateur**, un court-circuit est dangereux : il peut l'endommager et provoquer un **incendie**.

> 🏆 Deuxième quête bouclée, héros ! Tu sais bâtir un circuit fermé, reconnaître les quatre effets du courant, tracer un schéma normalisé et donner le sens du courant. Il te reste à le **mesurer** : cap sur l'intensité.
