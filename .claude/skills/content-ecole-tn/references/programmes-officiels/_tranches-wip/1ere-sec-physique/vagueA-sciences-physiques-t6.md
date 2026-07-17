# Vérification R-7 — Physique 1ère sec (CNP 223103P00) — tranche 6 : p.243–276

**Nature du livrable** : relecture de fidélité (R-7) des sections existantes de la fiche
`.claude/skills/content-ecole-tn/references/programmes-officiels/programme/1ere-sec/sciences-physiques.md`,
**lignes 2413–2761** (ch.16 + ch.17) et **§ Incertitudes ch.14–17** (lignes 2762–2779).
Ce n'est **pas** une re-transcription : je constate, je ne réécris pas la fiche.

**Sources confrontées**

- Texte déterministe : `D:\11-coding\YahiaAcademy\cnp-officiel\_txt\223103P00-physique.txt`
  (529 556 o, 276 `\f` = 276 pages, UTF-8 valide).
- Passe vision ciblée (4 pages, `pdftoppm -r 150` → `Read`) : **p.222, 247, 266, 273** — uniquement
  pour trancher des doutes que le texte seul ne pouvait pas lever. Détail en §3 et §7.

**Pages réellement lues** : 243→276 intégralement dans le `.txt` (34 pages), + 4 pages en vision.

---

## 1. Verdict global

La transcription des ch.16–17 est **solide sur le fond** : les deux encadrés **« L'ESSENTIEL DU
COURS » (p.254 et p.270) sont verbatim exacts, mot à mot, sans omission** — je les ai collationnés
ligne à ligne. Les définitions officielles, les données chiffrées des exercices (1992 / 750 al ;
r = 4 cm, d₁ = 20 cm, d₂ = 80 cm ; R = (1 + d₂/d₁)·r) et les deux `[sic]` déjà posés
(« surafce » p.254, « contituent » p.270) sont **corrects et confirmés imprimés**.

Mais la relecture fait apparaître **4 familles de défauts**, dont deux sérieuses :

| #   | Famille                                                               | Gravité         | Nb  |
| --- | --------------------------------------------------------------------- | --------------- | --- |
| A   | **Ajouts hors source** (réponses inventées, termes absents du manuel) | 🔴 **Bloquant** | 6   |
| B   | **Erreurs de pagination** de rubriques                                | 🟠 Majeur       | 9   |
| C   | **Figures indispensables non signalées** comme absentes du texte      | 🟠 Majeur       | 8   |
| D   | Lacunes de profondeur R-5 / coquilles non marquées `[sic]`            | 🟡 Mineur       | ~12 |

La famille A est la plus grave : **une transcription qui invente une réponse absente du manuel
contamine directement la génération en aval** — et l'une des réponses inventées est en outre
géométriquement douteuse (§4.1).

---

## 2. ⚠️ LEVÉE DE LA FAUSSE INCERTITUDE p.275 — constat définitif

L'entrée actuelle (lignes 2774–2779) affirme trois choses **fausses** :

> « le fichier texte source s'arrête à la page imprimée 274, **au milieu du paragraphe** "Savoir
> plus — Mélanges de couleurs". **La page 275 […] n'est pas présente dans le fichier** […] mais la
> page 275 elle-même **n'a pas pu être transcrite faute de texte source disponible**. »

**Mesures (reproductibles) :**

| Contrôle                              | Résultat                                                       |
| ------------------------------------- | -------------------------------------------------------------- |
| Nombre de `\f` dans le `.txt`         | **276** = 276 pages du PDF (`pdfinfo`) ⇒ **aucune troncature** |
| Segment page 275 (`split('\f')[274]`) | **présent**, 0 caractère, **0 ligne non vide**                 |
| Segment page 276 (`split('\f')[275]`) | **présent**, 0 caractère, **0 ligne non vide**                 |
| Fin de la p.274                       | phrase **complète** + folio « 274 »                            |
| Taille                                | 529 556 o (= la taille validée au cadrage)                     |

**Constats :**

1. Les p.275 et 276 **sont présentes** dans le `.txt` — leurs sauts de page existent. Elles sont
   simplement **vides** (0 ligne non vide). Rien n'a été perdu.
2. Le « Savoir plus — Mélanges de couleurs » **n'est pas coupé** : il se termine sur une phrase
   complète (« Le vêtement semble plus blanc qu'il n'est en réalité. ») suivie du folio 274. La
   mention « au milieu du paragraphe » est erronée.
3. Le manuel **se termine au contenu de la p.274**. Ni corrigés, ni annexes, ni index.
4. La p.275 n'est pas « non transcriptible faute de source » : **il n'y a rien à transcrire**.

**Réécriture proposée de l'entrée** (à substituer aux lignes 2774–2779) :

> - **Fin de manuel (p.274–276) — constat définitif, aucune incertitude.** Le manuel se termine au
>   contenu de la **p.274** (« Savoir plus — Mélanges de couleurs »), qui est **complet** (dernière
>   phrase entière + folio imprimé). Les **p.275 et 276 sont VIDES** : elles sont bien présentes
>   dans le PDF comme dans le texte extrait (276 sauts de page pour 276 pages du PDF), mais ne
>   portent **aucun contenu** (0 ligne non vide). Le manuel ne comporte **ni corrigés, ni annexes,
>   ni index**. Aucune troncature d'extraction : le `.txt` (529 556 o) couvre les 276 pages.

---

## 3. Confirmation demandée : coquille « Joule (1642/1727) » (ch.14, p.222)

Le cadrage demandait de confirmer que la coquille est **imprimée** et non un artefact d'extraction.
**Confirmé, deux fois plutôt qu'une :**

1. **Vision** (`pdftoppm -f 222 -r 150` → `Read`) : la p.222 imprime, dans l'encadré
   « APERCU HISTORIQUE », « **trouver les découvertes du savant Joule (1642/1727)** ». Coquille
   **imprimée dans le manuel**. Folio imprimé 222 = index PDF 222 (offset 0 reconfirmé).
2. **Preuve interne décisive** — les trois « Aperçu historique » du manuel portent :
   - p.158 : « Galilée (**1564/1642**) » ✅ exact
   - p.174 : « Newton (**1642/1727**) » ✅ exact
   - p.222 : « Joule (**1642/1727**) » ⚠️ — **les dates de Newton, à l'identique**

   La coquille est donc très vraisemblablement un report de l'encadré de la p.174 avec le seul nom
   changé. (Dates réelles de J. P. Joule : 1818–1889.)

**L'entrée d'incertitude peut être promue en constat définitif** : retirer l'hypothèse « ou d'un
artefact d'extraction » (écartée), garder la transcription telle quelle + `[sic]`, et **ajouter le
rapprochement p.174 ↔ p.222**, qui documente le mécanisme de la coquille sans arbitrer le programme.

---

## 4. 🔴 Famille A — Ajouts hors source (bloquants)

> Règle violée : « Transcrire ce qui est imprimé, rien d'autre. On n'invente JAMAIS. »
> Vérification faite par recherche sur **les 276 pages** du `.txt`.

### 4.1 Réponses inventées sur des exercices **à résoudre** (non résolus par le manuel)

**(a) Ch.16, ligne 2546–2548 — ombre portée d'un cylindre. 🔴 Le plus grave.**

La fiche écrit : « forme de l'ombre portée d'un cylindre opaque **(axe vertical → disque ; axe
horizontal perpendiculaire à l'écran → rectangle)** ».

Le manuel (p.256) **ne donne aucune réponse** — c'est un QCM à résoudre :

> « La forme de l'ombre portée d'un cylindre opaque donnée par une source ponctuelle sur un écran
> vertical : - dans le cas où l'axe du cylindre est vertical, est : (a) un disque ; (b) un
> triangle ; (c) un rectangle. - dans le cas où l'axe du cylindre est horizontal et perpendiculaire
> à l'écran, est : (a) un disque ; (b) un triangle ; (c) un rectangle. »

Double défaut : **(1)** la fiche fabrique une réponse absente de la source ; **(2)** l'appariement
inventé **paraît inversé** (un cylindre d'axe vertical est parallèle à un écran vertical → silhouette
allongée ; un cylindre d'axe perpendiculaire à l'écran est vu par le bout → silhouette circulaire).
Je **ne tranche pas** — ce n'est pas le rôle d'une transcription. **Correction : ne restituer que
l'énoncé et les trois options imprimées, sans réponse.**

**(b) Ch.17, ligne 2716–2717 — vrai/faux du filtre rouge.** La fiche ajoute « **[faux — inverse]** ».
Le manuel (p.272) pose « Répondre par vrai ou faux et justifier la réponse » sans corrigé. Ajout à
retirer (et incohérent : les deux autres items du même exercice n'en reçoivent pas).

**(c) Ch.17, ligne 2721 — plongeur.** « (rôle filtrant de l'eau) » désigne l'option (b) d'un QCM non
corrigé. À neutraliser (restituer les trois options).

### 4.2 Termes **absents du manuel entier** introduits par la fiche

Recherche exhaustive sur les 276 pages du `.txt` :

| Terme employé par la fiche                 | Ligne     | Présence dans le manuel        |
| ------------------------------------------ | --------- | ------------------------------ |
| « **Müller-Lyer** » (illusion des flèches) | 2721–2722 | ❌ **ABSENT du manuel entier** |
| « **diffraction** » (exercice du CD)       | 2723      | ❌ **ABSENT du manuel entier** |
| « **corps noir** » (concepts ch.17)        | 2739      | ❌ **ABSENT du manuel entier** |

- **« Müller-Lyer »** (p.272) : le manuel écrit seulement « De vue, les traits entre les pointes des
  flèches ont-ils la même longueur ? Vérifier la réponse en mesurant chacun des segments à l'aide
  d'une règle. […] Peut-on toujours se fier à nos sens ? » Aucun nom propre. Nommer l'illusion est
  un apport de connaissance externe — de surcroît **invérifiable sans la figure** (non rendue).
- **« diffraction »** (p.273) : le manuel demande « Pour certaines dispositions du disque on observe
  un phénomène qu'on reconnaîtra. Le décrire. b)-Quelle fonction optique a joué le disque
  compact ? » Le chapitre n'enseigne que le **prisme** et le **réseau** ; le mot « diffraction »
  n'existe nulle part. 🔴 **Risque direct** : la fiche fait entrer dans le périmètre un concept
  **hors programme** qu'un générateur reprendrait de bonne foi.
- **« corps noir »** (concepts) : le manuel dit « Un corps qui absorbe la (ou les) radiation(s)
  qu'il reçoit **paraît noir** ». « Corps noir » est un terme technique **sans rapport** (rayonnement
  du corps noir) — que la fiche **exclut d'ailleurs elle-même** ligne 2757 (« loi de Wien ou du
  corps noir »). Elle le liste donc comme concept **inclus** et **exclu** à la fois.

### 4.3 Symbole inventé dans une citation verbatim — θ₀ (ch.17, lignes 2652–2655)

La fiche cite : « Le fait que la température **θ₂ > θ₀**, cela prouve qu'**en deçà** du rouge… »

**Vision p.266 — le manuel imprime :**

- « Comparons à la température **θ** indiquée par le thermomètre à l'ombre » → **θ sans indice** ;
- « **θ₁ > θ₂ > θ.** » ;
- « Le fait que la température **θ₂ > θ**, cela prouve qu'**en deça** du rouge… » → **« deça » sans
  cédille** (coquille imprimée).

Deux altérations **à l'intérieur d'une citation présentée comme verbatim** : l'indice **₀ est
inventé** (les indices 1 et 2 sont, eux, bien rendus par `pdftotext` — leur absence sur le troisième
θ est donc significative) et la coquille « deça » est **corrigée en silence**. Correction : rétablir
`θ` et `« en deça [sic] »`.

### 4.4 Corrections silencieuses de coquilles dans des citations verbatim

| Fiche                                                     | Manuel (imprimé)                                          | Ligne |
| --------------------------------------------------------- | --------------------------------------------------------- | ----- |
| « L'ombre de la sphère portée **sur** l'écran… »          | « L'ombre de la sphère portée **su** l'écran… » (p.250)   | 2473  |
| « Ibn **Elhaitham** (965/1040) »                          | « **IBN ELHAITHEM** (965/1040) » (p.254)                  | 2534  |
| « faisceau étroit, quasi parallèle, **monochromatique** » | « …quasi parallèle, **de couleur bien définie** » (p.258) | 2561  |

- **« su » → « sur »** : la phrase est entre guillemets comme verbatim ; la coquille imprimée a été
  corrigée. Rétablir « portée su [sic] l'écran ».
- **« ELHAITHEM » → « Elhaitham »** : graphie d'un nom propre **imprimé** modifiée. Rétablir la
  graphie du manuel.
- **« monochromatique »** : le manuel réserve ce terme au ch.17 ; il n'apparaît qu'aux **p.42, 262,
  263, 270** — **jamais p.258**. Substitution de jargon à retirer.

---

## 5. 🟠 Famille B — Erreurs de pagination (9)

Pagination réelle relevée page par page (folio imprimé = index PDF, offset 0) :

| Rubrique                                             | Fiche     | **Réel**      | Ligne |
| ---------------------------------------------------- | --------- | ------------- | ----- |
| Ch.16 — Recherche documentaire « Le cadran solaire » | p.252–253 | **p.253**     | 2499  |
| Ch.16 — Savoir plus « Le laser »                     | p.257–258 | **p.258**     | 2559  |
| Ch.17 — Activité V (énergie)                         | p.264     | **p.265**     | 2644  |
| Ch.17 — Activité VI (UV/IR)                          | p.264–266 | **p.265–267** | 2649  |
| Ch.17 — Applications et dangers des ultraviolets     | p.266     | **p.266–267** | 2658  |
| Ch.17 — Applications des infrarouges                 | p.266     | **p.267**     | 2661  |
| Ch.17 — Recherche documentaire « L'effet de serre »  | p.268–269 | **p.269**     | 2675  |
| Ch.17 — Exercice résolu                              | p.270–271 | **p.271**     | 2709  |
| Ch.17 — Exercices                                    | p.271–273 | **p.272–273** | 2714  |
| Ch.17 — Savoir plus « Mélanges de couleurs »         | p.273–274 | **p.274**     | 2730  |

**Motif** : la fiche fait presque toujours démarrer la rubrique **une page trop tôt** (elle absorbe la
page précédente, qui appartient à la rubrique d'avant). Signature d'un découpage par plage de lignes
approximatif plutôt que par folio. Toutes les bornes de **chapitre** (p.243–258, p.259–274) et les
bornes globales « Activités expérimentales » (p.246–251, p.262–267) sont, elles, **exactes**.

Découpage réel, pour la correction :

- **Ch.16** — 243 ouverture · 244-245 mise en situation · 246 Act.I · 247 Act.II · 248 Act.III ·
  249-250 Act.IV · 250 Act.V · 251 Act.VI + éclipses · 252 Fiche T.P. · 253 Rech. doc. ·
  254 Essentiel + Aperçu hist. · 255 Ex. résolu · 256-257 Exercices · 258 Savoir plus.
- **Ch.17** — 259 ouverture · 260-261 mise en situation · 262 Act.I + Act.II(début) ·
  263 Act.II(fin) + Act.III · 264 Act.IV · 265 Act.V + Act.VI(début, UV) ·
  266 Act.VI(IR + encadré) + Applications UV(début) · 267 Applications UV(fin) + Applications IR +
  Act.VII · 268 Fiche T.P. · 269 Rech. doc. · 270 Essentiel + Aperçu hist. · 271 Ex. résolu ·
  272-273 Exercices · 274 Savoir plus.

---

## 6. 🟠 Famille C — Documents dont le contenu n'existe QUE dans l'image

**Aucun** de ces documents n'est signalé comme non rendu dans la fiche actuelle. Chapitre très
visuel : le relevé ci-dessous est **nominatif**, avec sa page. **Rien n'a été deviné.**

### 🔴 C1 — p.273, ex. « synthèse » 2 : spectres humain / oiseau / poisson — **exercice insoluble sans l'image**

Énoncé : « Sur la figure ci-contre sont représentés les spectres de la lumière solaire tels que les
verraient un être humain normal, un oiseau et un poisson. » puis « Quelle(s) couleur(s) les oiseaux
ne perçoivent-ils pas ? … les poissons ? ». **Les données sont exclusivement graphiques** : le `.txt`
ne contient **aucune** couleur. C'est l'exact analogue du « tableau des planètes p.240 » déjà relevé
pour le ch.15 — **et il manque à la § Incertitudes**.

_Vérifié en vision (p.273)_ : la figure existe bien — trois bandes spectrales superposées, légendées
« Etre humain normal », « Oiseau », « Poisson », **les plages non perçues étant rendues en gris**
(l'humain a la bande complète ; l'oiseau a une plage grise vers le bleu foncé/indigo ; le poisson a
toute la moitié bleu→violet en gris). **Je m'arrête là** : l'attribution exacte des teintes
(indigo vs bleu foncé) demande une lecture couleur dédiée — **à ne pas figer sans passe vision
ciblée**. Note : la question 2 (« Reproduire le spectre tel qu'il est perçu par un daltonien
rouge-vert ») appelle une **production graphique** de l'élève.

### 🔴 C2 — p.273, ex. « synthèse » 1 : « SCIENCES PHYSIQUES » — **donnée décisive absente du texte**

Le `.txt` donne les fonds (« sciences » sur fond blanc, « physiques » sur fond noir) mais **jamais la
couleur des lettres** — or c'est **la** donnée qui décide de la réponse. _Vision (p.273)_ : les deux
mots sont imprimés **en rouge** (« SCIENCES » rouge sur blanc, « PHYSIQUES » rouge sur noir).
À faire figurer explicitement, sinon l'exercice est ingénérable.

### 🟠 C3 — p.247, Activité II : **3 photos et 3 légendes perdues par `pdftotext`**

La fiche écrit « observation du Soleil, de la Terre, de la lave (photos) » — **incomplet**. Le `.txt`
ne rend que la 1ʳᵉ rangée de légendes, mais la généralisation cite **six** objets. _Vision (p.247)_ :
le manuel fait observer **6 photos sur 2 rangées** — « Le Soleil », « La Terre », « La lave » /
**« Les lampes », « La lune », « L'atmosphère »** — ces trois dernières légendes étant **absentes du
`.txt`**. ⚠️ **Portée générale** : c'est la preuve que le `.txt`, bien que déterministe et complet en
sauts de page, **perd du texte incrusté dans les images**. Le `.txt` seul ne garantit donc pas
l'exhaustivité des **légendes**.

### 🟠 C4→C8 — autres documents purement graphiques (non rendus, non signalés)

| #   | Page      | Document                                                                                         | Impact                                                                                                                                       |
| --- | --------- | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| C4  | 255       | **Exercice résolu ch.16** : figure des positions **(1)(2)(3)** de la source + craie et son ombre | 🔴 Énoncé **inexploitable** : « indiquer la position de la source » et la solution « C'est la position (2) » n'ont aucun sens sans la figure |
| C5  | 257       | **Synthèse 1** : schémas **(a)(b)(c)(d)** du trajet de la lumière (Ahmed lisant)                 | 🔴 Le QCM porte **exclusivement** sur les schémas                                                                                            |
| C6  | 257       | **Synthèse 3** : « Indiquer sur **le schéma suivant** la région où l'éclipse est totale »        | 🔴 Schéma requis                                                                                                                             |
| C7  | 263       | **Activité III** : figures test du daltonisme — « figure (1) » (5 vs 2), « figure (2) » (lapin)  | 🟡 Le texte donne le motif attendu ; la planche reste à reproduire                                                                           |
| C8  | 264 + 268 | **Activité IV** (5 illusions d'optique) + **Fiche T.P.** « documents fournis »                   | 🟠 Les illusions **sont** les figures                                                                                                        |

Autres figures non rendues, sans blocage (protocoles décrits par le texte) : montage des 3 écrans
percés (p.249), cuve + laser (p.249), sphère/source ponctuelle/source étendue (p.250), phases de la
Lune et géométrie des deux éclipses (p.251), chambre noire (p.252), cadran solaire (p.253), schéma
du laser (p.258), prisme/spectre (p.262), tomate/piment/oignon avec et sans filtre (p.262–263),
loupe/papier (p.265), cuve à fluorescéine (p.265), thermomètre/filament (p.266), bouteilles
blanche/noire (p.267), serre (p.269), flèches de l'illusion (p.272), synthèse additive (p.274).

---

## 7. 🟡 Famille D — Lacunes de profondeur R-5 et coquilles non marquées

### 7.1 Contenu officiel manquant (à ajouter)

1. **🔴 Ch.17, p.262 — l'ordre des couleurs du spectre est absent de la fiche.** Le manuel imprime :
   « Elle est constituée de lumières colorées allant du rouge au violet en passant par **l'orange, le
   jaune, le vert, le bleu et l'indigo**. » La fiche ne retient que la formule générique « en passant
   par toutes les lumières monochromatiques intermédiaires ». **Dans un chapitre sur le spectre,
   l'énumération officielle des 7 couleurs est la donnée la plus générable de la page** — à restituer.
2. **Ch.16, p.255 — les réponses de l'exercice RÉSOLU ne sont pas rapportées** (alors qu'elles le
   sont pour le ch.17). Le manuel imprime : « **1/- C'est la position (2).** » / « b)- La craie est
   opaque puisqu'on observe son ombre portée. » / « **2/- a)- L'ombre portée de la craie garde la
   même direction, mais sa longueur diminue.** » + commentaire « Dans un milieu homogène transparent,
   la lumière se propage en ligne droite. » Un exercice résolu est une **réponse officielle** : c'est
   du contenu de première valeur.
3. **Ch.16, p.248 — protocole et observations de l'Activité III non rapportés** : faisceau
   « cylindrique » ; « Plaçons l'œil derrière la plaque (C3) […] Retirons (C3) puis (C2) » ; et les
   trois observations (« (C1) […] permet de voir nettement le filament » / « (C2) […] sans permettre
   de reconnaître la forme du filament » / « (C3) ne laisse pas passer la lumière reçue »).
4. Phrases d'encadré omises : « **Les objets cités sont visibles par ce qu'ils émettent de la
   lumière.** » (p.247, en tête de l'encadré) ; « Les phases de la Lune correspondent aux formes vues
   depuis la Terre. La même phase est visible après une lunaison. » (p.251).
5. Précisions perdues : gradient de l'eau salée « la concentration du sel **diminue progressivement
   du bas en haut** » (p.250) ; « Le style est une baguette traversant **perpendiculairement** le
   cadran en son centre » + « à midi […] l'ombre se trouve dans le **plan du méridien** contenant
   l'axe Nord-Sud » (p.253) — c'est ce qui donne son sens à la question sur « culmine » ; « la
   synthèse chlorophyllienne […] est le **maillon fort dans le cycle de l'oxygène** » (p.266) ;
   « les gouttelettes d'eau […] **réparties en densité variable** » (p.262) ; « Lorsqu'un faisceau
   Laser puissant arrive sur un obstacle, l'énergie […] peut endommager ou détruire un matériau »
   (p.258) ; « (D) […] **placé parallèlement à (E)** » (p.257).
6. **Aperçus historiques** : les deux URLs imprimées (`edunet.tn/physique/savants.htm`,
   `infoscience.fr/histoire/biograph/biograph_som.html`, p.254 et p.270) ne sont pas relevées.

### 7.2 Coquilles imprimées transcrites mais **non marquées `[sic]`**

Règle : « Coquille de la source ⇒ transcrite telle quelle **suivie de `[sic]`** ». Toutes vérifiées
imprimées ; la fiche les reproduit fidèlement mais sans marque, ce qui les rend indiscernables d'une
faute de transcription :

| Page    | Imprimé                                                                           | Attendu              | Où dans la fiche               |
| ------- | --------------------------------------------------------------------------------- | -------------------- | ------------------------------ |
| 245     | « l'éclipse **total** de Soleil »                                                 | totale               | l.2425                         |
| 245     | « entre l'ombre et **le** pénombre »                                              | la pénombre          | l.2428                         |
| 254     | « Un objet **nous n'est visible** que s'il envoie… »                              | ne nous est visible  | l.2505                         |
| 254     | « les phases de la Lune, **observé** depuis la Terre »                            | observées            | l.2530                         |
| 266     | « en **deça** du rouge »                                                          | deçà                 | l.2654 (et corrigé — cf. §4.3) |
| 247     | « visibles **par ce qu'**ils émettent »                                           | parce qu'            | non citée                      |
| 258     | « un **faisceaux** lumineux étroit » / « un faisceaux de lumière **cohérentes** » | faisceau / cohérente | non citées                     |
| 255     | « dans un **plan verticale** »                                                    | plan vertical        | paraphrasé l.2537              |
| 257     | « 750 années-**lumières** »                                                       | années-lumière       | normalisé l.2548               |
| 272-273 | « est **il-lisible** » (césure de « est-il lisible »)                             | —                    | interprété l.2724              |
| 273     | « radiations **constituants** la lumière solaire »                                | constituant          | non citée                      |
| 252     | « **G**arder **C**onstantes » (×3)                                                | garder constantes    | paraphrasé                     |

### 7.3 Reformulations qui arbitrent la source

- **Ch.16, l.2548** : le manuel demande « **En quelle année l'étoile Star est-elle née ?** » ; la
  fiche écrit « calcul de l'année de naissance **de la lumière observée** ». La reformulation
  **corrige implicitement** l'approximation du manuel — c'est un arbitrage. Restituer la question
  imprimée ; signaler l'approximation en Incertitudes si on veut la documenter.
- **Ch.17, l.2637** : la fiche attribue la figure « points blancs → points noirs » (p.264) à la
  « persistance rétinienne ». Le manuel **n'attribue pas de cause figure par figure** : il donne une
  liste globale de quatre causes. Arbitrage à neutraliser.

### 7.4 Restitutions typographiques **correctes** (aucune action — documentées pour l'auditeur)

`pdftotext` aplatit exposants et fractions ; les reconstitutions de la fiche sont **justes** et
vérifiables :

- « c = 3.108 m.s-1 » → **c = 3.10⁸ m.s⁻¹** ✅ (exposants aplatis ; valeur non ambiguë) ;
- « R =(1+ d2 )r » avec « d » / « 1 » sur les lignes voisines → **R = (1 + d₂/d₁)·r** ✅ (fraction
  éclatée ; cohérente avec Thalès et l'A.N. : (1 + 80/20)×4 = **20 cm**) ;
- « 0- 1 », « 0- 2 » → **θ₁, θ₂** ✅ (mais **θ₀ est faux** — cf. §4.3) ;
- tableau « Objet | Etoile | Satellite | Comète | Œil | **Photopile Laser** » (p.257) : colonnes
  aplaties ; la lecture de la fiche en **6 objets** (…, photopile, laser) est la bonne.

---

## 8. Incohérences de la source — signalées, **non arbitrées**

Nouvelles (non relevées par la fiche) :

1. **P.253, Recherche documentaire « Le cadran solaire »** — le texte attribue le mouvement apparent
   du Soleil à la **révolution** : « **La Terre tourne autour du Soleil**, nous voyons celui-ci se
   lever à l'Est… », alors que le paragraphe suivant invoque, lui, la **rotation propre** : « En 24
   heures, la Terre effectue une rotation complète **autour d'elle-même**, soit 360°. » Les deux sont
   imprimés. ⚠️ **À signaler explicitement** : un générateur reprendrait la première formule telle
   quelle.
2. **P.266, Activité VI** — le protocole introduit « un **filament** (une résistance chauffante par
   exemple) » puis parle de « **la lampe** » (« jusqu'à ce que **la lampe** n'émette plus de
   lumière ») sans l'avoir introduite. Confirmé imprimé (vision p.266).
3. **P.252, Fiche T.P. « Chambre noire »** — « Matériels » annonce une chambre dont **« l'ouverture du
   Diaphragme et la distance Diaphragme-Ecran sont réglables »**, mais le protocole fait varier la
   distance **Diaphragme-Objet** et la distance **Écran-Objet**, jamais Diaphragme-Écran nommément.
4. **P.266** — le manuel affirme que les ultraviolets « sont **responsables de la synthèse
   chlorophyllienne (photosynthèse)** ». Affirmation de la source, scientifiquement discutable (la
   photosynthèse relève essentiellement du visible). À **signaler**, pas à corriger : un QCM
   « les UV permettent la photosynthèse » serait généré de bonne foi.
5. **Divergence interne ch.16** : « Une source de Lumière est un **objet** qui émet de la lumière »
   (p.247, Act.II) vs « … est un **corps** qui émet de la lumière » (p.254, Essentiel). La fiche
   restitue **correctement** les deux — ✅ bonne fidélité ; simplement, la divergence n'est pas
   signalée.
6. **Divergence interne ch.17** : l'illusion d'optique est « due au fonctionnement de **la rétine et
   du cerveau** » (p.264, Act.IV) vs « au fonctionnement **du cerveau** dans le traitement de
   l'information visuelle » (p.270, Essentiel). Là encore la fiche restitue **les deux** ✅, sans
   relever la divergence.
7. **P.245, ordre d'impression** — dans le bloc « cadran solaire », les questions imprimées sont
   numérotées 1, 2, 3 mais apparaissent **dans l'ordre 1, 3, 2** dans le flux d'extraction (artefact
   de mise en page). La fiche suit l'ordre du flux et **perd la numérotation**. Restituer la
   numérotation imprimée.

Enfin, une **contradiction interne à la fiche** (§ Bornes de scope) :

8. **Ch.16, l.2583–2585** : « lois de la réflexion/réfraction […] et formation d'images par
   miroirs/lentilles — **non traitées dans ce chapitre** » ; **Ch.17, l.2758–2759** : « optique
   géométrique des lentilles/miroirs (**relève du chapitre 16**, non repris ici) ». Les deux bornes se
   **contredisent**. Le constat réel : **ni le ch.16 ni le ch.17** ne traitent lentilles/miroirs —
   c'est **hors manuel** (vérifié : aucune loi de réflexion/réfraction dans les 276 pages ; la loupe
   p.265 et le CD p.273 sont mobilisés sans aucune loi). Corriger le ch.17 en « hors manuel ».

---

## 9. Ce qui est confirmé **conforme** (collationné, aucune action)

- **Titres et bornes de chapitre** : « LA LUMIERE ET SA PROPAGATION » (p.243–258) et « SPECTRE DE
  LUMIERE ET VISION » (p.259–274) ✅ — conformes aux pages d'ouverture. _(Rappel : le manuel imprime
  « CHAPITRE I » / « CHAPITRE II » sous le thème L'OPTIQUE ; « ch.16/17 » est une convention de la
  fiche — cohérente avec le reste du document, mais à ne jamais citer comme numérotation officielle.)_
- **Plans des activités + pré-requis** des deux pages d'ouverture (6 et 7 activités) ✅ exacts.
- **« L'ESSENTIEL DU COURS » p.254 (14 puces) et p.270 (9 puces)** ✅ **verbatim intégral et exact**,
  collationné ligne à ligne, y compris les deux `[sic]` (« surafce », « contituent ») — **confirmés
  imprimés**.
- **Encadrés de règle** des activités ✅ exacts (visibilité d'un objet p.246 ; sources primaires/
  secondaires p.247 ; transparent/translucide/opaque p.248 ; rayon lumineux et 3 faisceaux p.249 ;
  ombre/pénombre p.250 ; lunaison et éclipses p.251 ; lumière polychromatique p.262 ; couleur d'un
  corps éclairé p.263 ; radiations visibles/invisibles p.266).
- **Données chiffrées** ✅ toutes exactes : c = 3.10⁸ m.s⁻¹ ; lunaison ≈ 29 j ½ ; 1992 / 750 al ;
  r = 4 cm, d₁ = 20 cm, d₂ = 80 cm ; R = (1 + d₂/d₁)·r ; 15°/heure et 360°/24 h ; 30 m (plongeur).
- **Descriptions d'activités** ✅ fidèles dans l'ensemble (Act. I–VI du ch.16 ; Act. I–VII du ch.17).
- **Aperçu historique p.270** : « Descartes (1596/1650) » ✅ exact.
- **Exercice résolu ch.17 (p.271)** ✅ énoncé **et solutions** correctement rapportés.
- **Savoir plus « Mélanges de couleurs » (p.274)** ✅ fidèle (primaires rouge/bleu/vert ; jaune,
  magenta, cyan ; complémentaires ; téléviseur ; blanchiment du linge).
- **Vocabulaire officiel** ✅ conforme, à l'exception de « corps noir » (§4.2). Manquants mineurs :
  « nerfs optiques », « rétine », « diffuser » (p.246), « réseau », « prisme » (p.262).
- **⛔ EXCLU « aucune longueur d'onde chiffrée (nm) »** ✅ **vérifié sur les 276 pages** — exact :
  l'approche est purement qualitative.
- **⛔ EXCLU « synthèse soustractive »** ✅ exact (seule la synthèse additive est traitée, p.274).

---

## 10. Réécriture proposée de la § Incertitudes ch.14–17

À substituer aux lignes 2762–2779. (Les entrées ch.14 et ch.15 sont conservées et **renforcées** ;
la 3ᵉ est **remplacée** par un constat définitif ; deux entrées sont **ajoutées**.)

```markdown
## Incertitudes rencontrées (ch.14–17)

- **Ch.14, aperçu historique (p.222) — coquille IMPRIMÉE, confirmée.** Le manuel imprime
  « Joule (1642/1727) » ; ce sont les dates d'Isaac Newton (1642–1727), non celles de James
  Prescott Joule (1818–1889). Vérifié **en vision** sur la p.222 : la coquille est bien dans le
  manuel imprimé — l'hypothèse d'un artefact d'extraction est **écartée**. Preuve interne du
  mécanisme : le manuel imprime « Newton (1642/1727) » p.174 et « Galilée (1564/1642) » p.158 —
  l'encadré de la p.222 reprend les dates de la p.174 avec le seul nom changé. Transcrit tel quel,
  sans correction : une transcription n'a pas autorité pour corriger le programme officiel.

- **Ch.15, exercice « situations simples » (p.240) — figure non rendue.** L'énoncé renvoie à un
  « tableau des caractéristiques des planètes » dont les données chiffrées n'existent que dans
  l'image (non capturée par pdftotext). Contenu non transcrit ; **exige une passe vision ciblée**
  (`Read` avec `pages=240`) avant toute génération. Rien n'a été deviné.

- **Ch.17, ex. « utiliser ses acquis pour une synthèse » 2 (p.273) — figure non rendue, exercice
  insoluble sans elle.** Les trois spectres comparés (être humain normal / oiseau / poisson)
  n'existent **que** dans l'image : aucune couleur n'apparaît dans le texte extrait, alors que les
  questions portent exclusivement sur les couleurs non perçues par chaque espèce. **Exige une passe
  vision ciblée** (`pages=273`). Aucune valeur devinée.

- **Ch.17, ex. « synthèse » 1 (p.273) — donnée décisive absente du texte.** Le texte donne les
  fonds (« sciences » sur fond blanc, « physiques » sur fond noir) mais **jamais la couleur des
  lettres**, qui commande la réponse. Vision (p.273) : les deux mots sont imprimés **en rouge**.

- **Ch.16, Activité II (p.247) — légendes perdues par l'extraction.** Le texte extrait ne rend que
  trois légendes (« Le Soleil », « La Terre », « La lave ») alors que le manuel fait observer
  **six** photos ; vision (p.247) : « Les lampes », « La lune », « L'atmosphère » complètent la
  seconde rangée — leurs légendes **n'apparaissent pas dans le .txt**. ⚠️ Portée générale : le .txt
  est complet en pages (276/276) mais **perd le texte incrusté dans les images** ; il ne garantit
  donc pas l'exhaustivité des légendes.

- **Fin de manuel (p.274–276) — constat définitif, aucune incertitude.** Le manuel se termine au
  contenu de la **p.274** (« Savoir plus — Mélanges de couleurs »), qui est **complet** (dernière
  phrase entière + folio imprimé). Les **p.275 et 276 sont VIDES** : présentes dans le PDF comme
  dans le texte extrait (276 sauts de page = 276 pages), mais sans **aucun** contenu (0 ligne non
  vide). Ni corrigés, ni annexes, ni index. **Aucune troncature** : le .txt (529 556 o) couvre les
  276 pages. _(Cette entrée remplace l'ancienne, qui affirmait à tort que la p.275 « n'est pas
  présente dans le fichier » et que le Savoir plus était coupé « au milieu du paragraphe ».)_
```

---

## 11. Actions, par priorité

1. 🔴 **Retirer les 6 ajouts hors source** (§4) : réponses inventées (cylindre p.256 — inversée de
   surcroît ; filtre rouge p.272 ; plongeur p.272), « Müller-Lyer », « diffraction », « corps noir ».
2. 🔴 **Rétablir les 4 verbatims altérés** (§4.3–4.4) : « portée **su** [sic] l'écran », « **IBN
   ELHAITHEM** », « **de couleur bien définie** », « θ₂ > **θ** » + « en **deça** [sic] ».
3. 🔴 **Ajouter au § Incertitudes les 3 trous d'image manquants** (spectres p.273 ; « SCIENCES
   PHYSIQUES » p.273 ; légendes p.247) et **réécrire l'entrée p.275** en constat définitif (§10).
4. 🟠 **Corriger les 9 paginations** (§5, tableau prêt à appliquer).
5. 🟠 **Signaler les 8 incohérences de la source** (§8), dont la contradiction interne des bornes de
   scope ch.16/ch.17 (lentilles/miroirs = **hors manuel**, pas « relève du ch.16 »).
6. 🟡 **Compléter la profondeur R-5** (§7.1), en priorité **l'ordre officiel des 7 couleurs du
   spectre (p.262)** et **les réponses de l'exercice résolu ch.16 (p.255)**.
7. 🟡 **Marquer les coquilles `[sic]`** (§7.2).

**Sur la promotion `[x]` de la fiche** (mentionnée au cadrage) : les ch.16–17 sont **promouvables
après application des points 1–3**. En l'état, la fiche affirme des réponses que le manuel ne donne
pas et introduit un concept hors programme (« diffraction ») — ce sont des défauts qui se
propageraient à la génération, pas des imperfections cosmétiques.
