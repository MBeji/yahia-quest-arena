# VÉRIFICATION R-7 — Physique 1ère année secondaire — Thème LA MÉCANIQUE (p.147–208)

> **Nature du travail** : relecture de fidélité (R-7), **pas** une re-transcription.
> **Source contrôlée** : `D:\11-coding\YahiaAcademy\cnp-officiel\_txt\223103P00-physique.txt`
> (couche-texte déterministe du PDF `manuels\secondaire\c1\eleve\223103P00.pdf`, 276 p., offset folio↔PDF = 0).
> **Fiche contrôlée** : `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/1ere-sec/sciences-physiques.md`,
> lignes 1363–2064 (ch.10 à 13 + « Incertitudes rencontrées (ch.10-13) »).
> **Pages réellement lues** : 147 à 208 intégralement (62 p.), **plus** p.4–5 (sommaire) lues pour
> instruire l'incohérence n°2 du cadrage.
> **Aucune** re-transcription n'a été produite : ce document liste ce qui est **confirmé fidèle**,
> ce qui doit être **corrigé**, et ce qui exige une **passe vision ciblée**.
> **Aucune** modification n'a été apportée au dépôt.

---

## 0. Verdict global

**La fiche est, sur le fond, d'une fidélité élevée.** Les encadrés normatifs, les définitions,
les valeurs numériques et les énoncés d'exercices ont été recoupés un à un : **la quasi-totalité
est exacte au chiffre près** (voir §6, « ce qui est confirmé »). Le travail n'est pas à refaire.

**Mais trois défauts systémiques doivent être corrigés avant de promouvoir la fiche `[x]`** :

| #     | Défaut                                                                                                                                                                                                                                                                                                                                                                                                                          | Portée                | Gravité    |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- | ---------- |
| **A** | **Les bornes de chapitre sont décalées de +1** : la fiche exclut la page d'ouverture du chapitre et inclut celle du chapitre suivant. Pour le ch.10, la conséquence est une **perte de contenu imprimé** (le plan des activités + les pré-requis de la p.147 ne sont nulle part).                                                                                                                                               | 4 ch.                 | **MAJEUR** |
| **B** | **La §Incertitudes affirme que le texte extrait est « complet »** et qu'« aucune vérification par rendu image n'a été nécessaire ». C'est **faux** : le `.txt` ne contient **aucun symbole vectoriel**, **aucun exposant**, **aucune figure**. La fiche les a **reconstruits sans le déclarer**. Cette phrase dit à l'aval « pas besoin de vision » alors que plusieurs exercices sont strictement inexploitables sans l'image. | 4 ch. (surtout 11-13) | **MAJEUR** |
| **C** | **La fiche complète les phrases à trous des exercices** (elle imprime les réponses à la place des « …… » du manuel) et **corrige silencieusement des coquilles à l'intérieur de citations données pour verbatim**. Deux violations directes de « on n'invente jamais » / « signaler, pas arbitrer ».                                                                                                                            | 4 ch.                 | **MAJEUR** |

S'y ajoutent : **1 incertitude mal diagnostiquée** (§5.1), **1 justification physique fausse**
(§5.2), **des citations de page erronées sur le ch.12** (§4.3), et **l'incohérence du sommaire
sur le ch.13, non signalée** (§5.4).

---

## 1. Structure réelle imprimée — référence de contrôle

Recoupée sur trois sources concordantes : les pages d'ouverture, les rubriques imprimées, et le
**tableau du sommaire p.5** (lu pour cette vérification — il donne le folio de chaque rubrique).

| Ch. (conv. fiche) | Désignation **imprimée** (p. d'ouverture)                 | Bornes réelles | Bornes fiche | Écart  |
| ----------------- | --------------------------------------------------------- | -------------- | ------------ | ------ |
| 10                | `CHAPITRE I` — `LA MECANIQUE` — `LE MOUVEMENT`            | **p.147–162**  | p.148–163    | **+1** |
| 11                | `CHAPITRE II` — `LA MECANIQUE` — `LES ACTIONS MECANIQUES` | **p.163–178**  | p.164–179    | **+1** |
| 12                | `CHAPITRE III` — `LA MECANIQUE` — `FORCES ET EQUILIBRE`   | **p.179–194**  | p.180–195    | **+1** |
| 13                | `CHAPITRE IV` — `LA MECANIQUE` — `FORCES ET PRESSION`     | **p.195–208**  | p.196–209    | **+1** |

**Gabarit vérifié, identique pour les 4 chapitres** (confirmé par le sommaire p.5) :

| Rubrique                                                | ch.10       | ch.11       | ch.12       | ch.13       |
| ------------------------------------------------------- | ----------- | ----------- | ----------- | ----------- |
| Page d'ouverture (plan + pré-requis)                    | 147         | 163         | 179         | 195         |
| Activités de mise en situation                          | 148–149     | 164–165     | 180–181     | 196–197     |
| Activités expérimentales                                | **150–155** | **166–171** | **182–187** | **198–201** |
| Fiche T.P                                               | 156         | 172         | 188         | 202         |
| Recherche documentaire                                  | 157         | 173         | 189         | 203         |
| L'essentiel du cours                                    | 158         | 174         | 190         | 204         |
| Naviguer sur l'Internet (imprimé « APERCU HISTORIQUE ») | 158         | 174         | 190         | 204         |
| Exercice résolu                                         | 159         | 175         | 191         | 205         |
| Exercices à résoudre                                    | 160–161     | 176–177     | 192–193     | 206–207     |
| Savoir plus                                             | 162         | 178         | 194         | **208**     |

**Pas de divergence de titre sommaire/ouverture pour ces 4 chapitres** (contrairement aux ch.3 et
ch.5 signalés au cadrage) : le sommaire imprime « Le mouvement », « Les actions mécaniques »,
« Forces et équilibre », « Forces et pression » — identiques (à la casse près) aux pages
d'ouverture. **Rien à signaler de ce côté.**

---

## 2. Défaut A — bornes de chapitre décalées de +1

### 2.1 Le mécanisme

La fiche a défini chaque chapitre comme **[1ère page de contenu → page d'ouverture du chapitre
suivant]**. Elle a donc, à chaque fois, **amputé l'ouverture de son propre chapitre** et
**annexé l'ouverture du suivant**.

Elle en a même conscience, mais l'explique à tort :

> **fiche, ligne 1690** : « **Fin de chapitre** (p.179) : plan des activités expérimentales et
> pré-requis du chapitre 12 (Forces et équilibre) apparaissent déjà sur cette page (**transition
> d'imprimerie**). »
>
> **fiche, ligne 2022** : « **Transition** (p.209) : plan des activités expérimentales et
> pré-requis du chapitre suivant […] apparaissent déjà en fin de plage ».

Il n'y a **aucune « transition d'imprimerie »**. La p.179 est la **page d'ouverture normale** du
chapitre « FORCES ET EQUILIBRE », strictement identique en structure aux p.147 / 163 / 195. Le
cadrage l'établit d'ailleurs pour tout le manuel (17 ouvertures / 17 « SAVOIR PLUS », appariées
sans trou). **« Transition d'imprimerie » est une rationalisation inventée d'une structure qui est
en réalité parfaitement régulière.** À supprimer.

### 2.2 La conséquence matérielle : la p.147 est absente de la fiche

Les ch.11, 12 et 13 transcrivent bien leur page d'ouverture (« **Plan des activités
expérimentales** (p.163, en tête de chapitre) », idem p.179 et p.195). **Le ch.10 est le seul à ne
pas le faire** — parce que sa page d'ouverture (p.147) tombe hors de la plage p.148–163 qu'il
s'est donnée. Contenu imprimé **manquant** (R-5 : plan + pré-requis sont exigés) :

> **p.147 — `CHAPITRE I` / `LA MECANIQUE` / `LE MOUVEMENT`**
>
> **Plan des activités expérimentales**
>
> - Activités(I) : Repérage du temps
> - Activités(II) : Relativité d'un mouvement
> - Activités(III) : Techniques d'étude d'un mouvement
> - Activités(IV) : Trajectoire d'un mobile
> - Activités(V) : Les trois types de mouvement
> - Activités(VI) : Vitesse moyenne d'un mobile
> - Activités(VII) : Vitesse instantanée
>
> **Pré-requis**
>
> - Repérage dans le plan (origine, axe des abscisses et axe des ordonnées).
> - Coordonnées d'un point dans un repère orthonormé.
> - Abscisse linéaire.

À noter (fait imprimé, à consigner sans l'arbitrer) : **le plan p.147 et les intitulés des
activités p.150-155 ne portent pas les mêmes titres** — le plan emploie une forme thématique
(« Repérage du temps »), l'activité une forme interrogative (« Quelle est la différence entre
temps, instant et date ? »). Les deux sont imprimés. C'est le parti-pris du manuel (vérifié
identique aux ch.11-13), pas une incohérence — mais la fiche ne retient qu'une des deux formes.

### 2.3 La désignation imprimée n'est jamais consignée

Aucun des 4 chapitres ne consigne sa désignation réelle (`CHAPITRE I` … `CHAPITRE IV`) ni son
thème (`LA MECANIQUE`). La fiche n'expose que sa numérotation continue maison (« Chapitre 10 »),
**qui n'est imprimée nulle part dans le manuel**. Un relecteur ne peut pas raccrocher
« Chapitre 12 » à quoi que ce soit de visible dans l'ouvrage. À ajouter dans chaque en-tête.

### 2.4 Bornes des « Activités expérimentales » également fausses (3 ch. sur 4)

| Ch. | Fiche                     | Réel (confirmé par le sommaire p.5) | Verdict                                                         |
| --- | ------------------------- | ----------------------------------- | --------------------------------------------------------------- |
| 10  | « (p.150–159) — 7 blocs » | **p.150–155**                       | ✗ avale fiche T.P + recherche doc + essentiel + exercice résolu |
| 11  | « (p.166–172) — 6 blocs » | **p.166–171**                       | ✗ avale la fiche T.P                                            |
| 12  | « (p.182–188) — 6 blocs » | **p.182–187**                       | ✗ avale la fiche T.P                                            |
| 13  | « (p.198–201) — 4 blocs » | **p.198–201**                       | ✓ correct                                                       |

---

## 3. Défaut B — le `.txt` n'est PAS complet ; la fiche a reconstruit sans le déclarer

C'est le constat central de cette R-7, et il contredit frontalement la §Incertitudes actuelle :

> **fiche, lignes 2061-2064** : « **Aucune vérification par rendu image (render.sh) n'a été
> nécessaire** : le texte extrait était globalement cohérent et **complet** sur les quatre
> chapitres, hormis les deux points numériques ci-dessus qui relèvent d'artefacts mineurs de mise
> en page (fractions/exposants) plutôt que d'un texte manquant. »

**Cette affirmation est fausse sur trois plans.** Ce sont des chapitres de mécanique
vectorielle : le manuel dit l'essentiel avec des glyphes que `pdftotext` ne restitue pas.

### 3.1 Tous les symboles vectoriels sont absents du `.txt`

Le `.txt` laisse un **blanc** partout où le manuel imprime un vecteur. Extraits littéraux :

| Page | Ce que contient le `.txt`                                                        | Ce que la fiche a écrit                         |
| ---- | -------------------------------------------------------------------------------- | ----------------------------------------------- |
| 168  | `modélisée par un vecteur appelé vecteur force et noté    .`                     | « noté **F** »                                  |
| 168  | `L'intensité de la force, notée    , s'exprime`                                  | « intensité notée **F** »                       |
| 170  | `on modélise le poids d'un corps par un vecteur, noté , de direction verticale`  | « vecteur **P** »                               |
| 170  | `l'intensité du poids d'un corps est proportionnelle à sa masse :       = m.g .` | « **P** = m.g »                                 |
| 174  | `On modélise une action mécanique par un vecteur force, noté         .`          | « noté **F** »                                  |
| 174  | `Elle est notée     .`                                                           | « Elle est notée **P**. »                       |
| 182  | `deux forces 1 et 2 , d'intensités`                                              | « deux forces **F1 et F2** »                    |
| 183  | `Ceci se traduit par : 1= - 2 ou 1 +   2=`                                       | « **F1 = −F2** ou **F1 + F2 = 0** »             |
| 183  | `Le poids     est directement opposée à la tension du fil […] : =- .`            | « **P = −T** »                                  |
| 190  | `Elles vérifient la relation :     1+ 2 =    .`                                  | « **F1 + F2 = 0** »                             |
| 191  | `A l'équilibre on a : + = ; ou bien : = - . Soit : = = m.g ; d'où : m = _ .`     | « **P + T = 0**, **T = P = m.g**, **m = P/g** » |
| 198  | `Donc, en (A) agit une force directement opposée à : + = . D'où : = .`           | « **T + T' = 0, donc T' = P** »                 |
| 200  | `Soit : p =    s .`                                                              | « **p = F/s** »                                 |
| 204  | `Soit : p =  s .`                                                                | « **p = F/s** »                                 |

Les lectures sont **physiquement quasi certaines** (`P = m.g`, `p = F/s`…) et je ne conteste
aucune d'elles. **Le problème n'est pas la lecture : c'est qu'elle n'est pas déclarée.** Une
fiche qui écrit « L'essentiel du cours (p.174, formulation officielle — **verbatim**) : “On
modélise une action mécanique par un vecteur force, noté **F**.” » présente comme relevé un
caractère qu'elle n'a jamais vu. Le notation exacte du manuel (flèche ? gras ? `‖F‖` ou `F` pour
la norme ?) reste **inconnue** — et c'est précisément ce dont un générateur d'exercices aura
besoin. Certains blancs sont d'ailleurs plus lourds : le **`0⃗`** de `F1 + F2 = 0⃗` (p.183, p.190)
et le **numérateur `F` de `p = F/s`** (p.200, p.204) sont, eux aussi, purement reconstruits.

**Correction demandée** : soit une passe vision sur p.168, 170, 174, 183, 190, 191, 198, 200, 204
pour relever la notation réelle ; soit, a minima, une mention explicite en §Incertitudes que
**toutes** les notations vectorielles sont des reconstructions non vérifiées.

### 3.2 Tous les exposants sont aplatis

`pdftotext` colle les exposants au corps du texte. Occurrences dans la tranche :
`35.1020` (p.169) · `107 N` / `103 N` (p.176) · `105 Pa` / `102 Pa` (p.200, p.204) ·
`176,4.103 Pa` / `16,5.103 Pa` (p.205) · `125.106 Pa` / `0,8.10-4 Pa` (p.206) ·
`5 000 000` et `100 000` (p.169, ceux-là en clair).
La fiche a restitué `10⁷`, `10³`, `10⁵`, `10²`, `176,4.10³`… — **toutes justes**, sauf que
`35.10²⁰` repose sur un raisonnement faux (§5.2).

### 3.3 Aucune figure n'est rendue — inventaire nominatif : §7

---

## 4. Défaut C + constats par chapitre

### 4.1 Chapitre 10 — `CHAPITRE I` / `LE MOUVEMENT` (réel : p.147–162)

**Confirmé fidèle** : Activités I à VII (contenu, généralisations, encadrés) ; les 9 puces de
« L'ESSENTIEL DU COURS » p.158 — **verbatim exact, contrôlées une à une** ; la fiche T.P p.156
(OM1=40 / OM2=80 / OM3=120 cm, Δx=2 cm, 1/1000 s, 3 mouvements) ; la recherche documentaire p.157
(60 km.h⁻¹, 50 km.h⁻¹, « plus de vingt mille newtons » pour 75 kg, mortalité ×2-3, tableau
45/90/130 → 25/77/160 m) ; les deux tableaux de vitesses p.155 **au chiffre près** (tortue 0,4 ·
mouton 25 · lièvre 60 · cheval 70 · guépard 100 · faucon 350 ; voiture 300 · avion 900 ·
satellite 25200 · Terre 107244 · Pluton 17064 · Mercure 172404) ; le tableau code de la route
p.161 (12,5/25 · 13/52 · 26/104) ; le « Savoir plus » p.162 (7 km.s⁻¹, 11,2 km.s⁻¹, ISS 375 km /
52 m / 73 m).

**À corriger :**

1. **`l500 m` [sic] non signalé (p.154, Activité VI).** Le `.txt` imprime littéralement
   `Deux athlètes (A) et (B) ont parcouru respectivement **l500 m** en 3 mn 26 s` — un **`l`
   minuscule** à la place du chiffre `1`. La fiche écrit « 1500 m » **sans note**. La lecture est
   certaine (le manuel calcule lui-même 7,28 m.s⁻¹ ; 1500/206 s = 7,28 ✓ ; et 800/114 s = 7,02 ✓),
   mais c'est une **normalisation silencieuse d'une graphie source**. → `l500 [sic]` + note.
2. **Réponses inventées dans les phrases à trous (p.160).** Le manuel imprime
   `Le Soleil se lève à …… et se couche à …… La Terre tourne donc de …… à …….` ; la fiche écrit
   « **le Soleil se lève à l'Est et se couche à l'Ouest, la Terre tourne donc de l'Ouest à
   l'Est** ». **Il n'y a pas de corrigé imprimé pour cette rubrique** : ces quatre mots sont une
   génération. Incohérent avec l'item voisin, où la fiche a correctement conservé « … ».
3. **Remarque pédagogique imprimée, omise (p.153).** « Le mot "trajectoire" est une partie de la
   trajectoire de l'extrémité du stylo qu'on déplace pour écrire "trajectoire" sur une feuille
   blanche (l'autre partie est située dans l'air) » — absente de la fiche.
4. **Donnée omise (p.154, Activité V).** « Si on choisit la graduation **2 mm** de la règle comme
   référence et l'instant d'arrivée de la balle à cette graduation comme origine des dates ».
5. Coquille source non relevée (p.156, fiche T.P) : « Cavalier **menu** [sic] d'un carton »
   (pour « muni »). L'angle est imprimé `ß` (eszett) et non `β` — normalisé sans note.
6. Le corrigé de l'exercice résolu p.159 **ne transcrit pas la colonne « Commentaires »**
   (3 encarts imprimés).
7. Cf. §5.1 (exercice résolu q.4 — incertitude mal diagnostiquée) et §5.3 (paragraphe dupliqué
   p.162).

### 4.2 Chapitre 11 — `CHAPITRE II` / `LES ACTIONS MECANIQUES` (réel : p.163–178)

**Confirmé fidèle** : le plan p.163 et les pré-requis — **exacts** ; les Activités I à VI ; la
définition encadrée p.167 ; l'encadré « Principe d'inertie » p.171 — **verbatim exact** ; les 10
puces de « L'ESSENTIEL » p.174 — **verbatim exact** ; le tableau des ordres de grandeur p.169
(1 / 200 / 500 / 700 / 100 000 / 5 000 000 N) ; les tableaux de `g` p.170 **au chiffre près**
(Équateur 0° 9,78 · Tunis 37° 9,80 · Pôle Nord 90° 9,83 ; Tunis 0 m 9,80 · Echâmbi 1544 m 9,79) ;
la recherche documentaire p.173 **intégralement** (40 N/cm² ; 500 N / 7,257 kg / 36 km.h⁻¹ ;
1100 N / 58 g / 201,6 km.h⁻¹ ; 2600 N / 47 g / 237,6 km.h⁻¹ ; 1500 N / 430 g / 93,6 km.h⁻¹) ;
l'exercice résolu p.175 (5102 g, 50,00 N, 2,5 cm, Everest 8846 m, 0,13 N, 49,87 N) ; le
« Savoir plus » p.178 (Mir, 1986, 23 mars 2001).

**À corriger :**

1. **Coquille corrigée à l'intérieur d'une citation verbatim (p.170) — le plus net.**
   Le manuel imprime : « La verticale d'un point est la droite qui **joigne** ce point au centre
   de gravité de la Terre. » (subjonctif fautif, **vérifié dans la couche-texte**).
   La fiche cite, entre guillemets : « …la droite qui **joint** ce point… ». → rétablir
   `joigne [sic]`.
2. **Titre de rubrique corrigé silencieusement (p.172).** Le manuel imprime
   « **POIDS ET MASSE D'UN COPRS** » [sic] ; la fiche écrit « « Poids et masse d'un corps » ».
   → `COPRS [sic]`.
3. **Coquilles source non relevées** : p.168 « ressort à **sipres** [sic] non jointives » ;
   p.171 « Sur une table **hortisantale** [sic] » ; p.178 « assurer les **acvités** [sic] les
   plus élémentaires ».
4. **Réponses inventées (p.176)** : même pattern qu'au ch.10 — la fiche imprime « direction /
   sens / intensité » et « le dynamomètre » à la place des « …… » du manuel.
5. **Élision de contenu dans une citation verbatim (p.174)** : la puce sur le poids est citée
   « …suivant la verticale **(…)** et d'intensité proportionnelle… » ; le passage élidé
   « ( qui est la droite joignant le centre de gravité du corps au centre de gravité de la
   Terre) » est une définition, pas un remplissage.
6. Cf. §5.2 (`35.10²⁰` — justification physique fausse) et §2.1 (« transition d'imprimerie »).

**Corroboration utile pour le ch.14 (hors tranche).** Le cadrage signale « Joule (1642/1727) »
p.222. Je confirme que la p.174 imprime **« Newton (1642/1727) »** dans un bloc « APERCU
HISTORIQUE » de gabarit rigoureusement identique. L'anomalie de la p.222 est donc très
probablement un report de cette ligne-ci — élément à verser au dossier de l'agent qui traitera
le ch.14, **sans arbitrer** pour autant.

### 4.3 Chapitre 12 — `CHAPITRE III` / `FORCES ET EQUILIBRE` (réel : p.179–194)

**Confirmé fidèle** : le plan p.179 et les pré-requis — **exacts** ; les Activités I à VI ; les
encadrés « Condition d'équilibre » p.183 et « Troisième loi de Newton » p.187 — **verbatim
exact** ; les 7 puces de « L'ESSENTIEL » p.190 (dont la précision « la même droite d'action **D** »,
correctement relevée) ; la fiche T.P p.188 ; la recherche documentaire p.189 ; l'exercice résolu
p.191 (10 N, 1,02 kg = 1020 g, R = P = 10 N) ; tous les énoncés p.192-193 (k=20 N.m⁻¹, 14 500 t,
4 m, a=5 cm, 3 N, 10 N) ; le « Savoir plus » p.194 (Thalès VIe s. av. J.-C., 1687, citation de
Newton **verbatim exacte**, Cavendish 1731-1810).

**À corriger :**

1. **Citations de page fausses (+1) sur les activités IV à VI.** Contrôlées sur les sauts de page :

   | Bloc                                                       | Fiche     | Réel              |
   | ---------------------------------------------------------- | --------- | ----------------- |
   | Activité IV (déformation d'un ressort)                     | p.185–186 | **p.185** (seule) |
   | Application « loi de Hooke » / construction du dynamomètre | **p.186** | **p.185**         |
   | Activité V (principe d'interaction)                        | p.187–188 | **p.186–187**     |
   | Activité VI (transmission par fil/ressort)                 | p.187–188 | **p.187** (seule) |

   Les ch.10, 11 et 13 ont, eux, des citations internes **correctes** : le défaut est localisé.
   Il n'est pas cosmétique — la citation de page est ce qui rend la fiche revérifiable.

2. **Deux coquilles corrigées dans la citation verbatim de « L'ESSENTIEL » p.190.**
   Le manuel imprime : « **Lorsque un** ressort est déformé […] Cette force est appelée tension
   du ressort. **Elle et notée** . » (**vérifié dans la couche-texte**). La fiche cite
   « **Lorsqu'un** ressort… **Elle est notée** T. ». → `Lorsque un [sic]`, `Elle et [sic] notée`.
3. **Coquille de numérotation du corrigé imprimé, arbitrée en silence (p.191).** Le corrigé
   imprime **deux fois** « **1/- a)-** » : la réponse à la question **2/** (« Le corps (C) est
   posé sur un sol horizontal ») est numérotée « 1/- ». La fiche renumérote en « 2) » sans note.
   → incohérence **de la source**, à signaler telle quelle.
4. **Donnée d'énoncé omise + géométrie déformée (p.193, Tour de Pise).**
   - Omis : « **En suppose** [sic] que le centre de gravité G de la tour est à égale distance de
     ses deux bases. » — c'est la donnée qui permet la question c).
   - Déformé : la fiche écrit « décalage de 4 m **entre les verticales des bases** » ; le manuel
     écrit « La verticale (Δ) passant par le centre de sa base d'appui a 4 mètres de décalage par
     rapport au **centre de sa partie supérieure** ».
5. **Réponse + méthode inventées (p.192).** Le QCM « constante de raideur » imprime trois
   options : `(a) 40 N.m-1 ; (b) 10 N.m-1 ; (c) 40 m.N-1`. La fiche n'en restitue aucune et
   écrit à la place « → constante de raideur (**40 N.m⁻¹, calcul k = F/x**) ». Aucun corrigé
   n'est imprimé. (À comparer avec le QCM p.206 du ch.13, où la fiche a correctement restitué
   les trois options sans trancher : l'incohérence est interne à la fiche.)
6. **Formule attribuée à tort à la fiche T.P (p.188).** La fiche écrit « écriture vectorielle
   **T = −k.Δl⃗** avec un vecteur unitaire à définir » ; le manuel **demande à l'élève de la
   proposer** (« proposer une écriture vectorielle entre , Δl et un vecteur unitaire à
   définir ») et ne l'imprime qu'ailleurs (p.190).
7. Coquilles source non relevées : p.184 « **quelque soit** [sic] l'orientation » ; p.186
   « **Dés** [sic] que (A) et (B) sont libérés ». À l'inverse, **bon point** : la fiche a
   correctement conservé l'accord fautif « Le poids P est directement **opposée** » (p.183).

### 4.4 Chapitre 13 — `CHAPITRE IV` / `FORCES ET PRESSION` (réel : p.195–208)

**Le chapitre le mieux transcrit des quatre.**

**Confirmé fidèle** : le plan p.195 et les pré-requis — **exacts** ; les Activités I à IV ;
l'encadré de définition de la pression p.200 et les 6 puces de « L'ESSENTIEL » p.204 — **verbatim
exact** ; la fiche T.P p.202 ; la recherche documentaire p.203 ; l'exercice résolu p.205
(**recalculé : 54 × 9,8 / 30.10⁻⁴ = 176 400 Pa = 176,4.10³ ✓** ; 529,2 / 0,032 = 16,5.10³ ✓ ;
rapport 10,7 ✓ « plus que dix fois ») ; **tous** les énoncés p.206-207 (0,8 mm² / 100 N ; 80 kg /
0,225 m² / 225 cm² ; 20 N / D=6 mm / 0,03 mm² ; 3 kg / 5-10-20 cm ; 1000 t / 1 bar / 60 cm /
1,4 g.cm⁻³) ; le « Savoir plus » p.208 (1 bar = 0,1 MPa, ~90 %, 25 cm à plus d'un mètre).
Les bornes des activités expérimentales (p.198–201) sont, ici, **justes**.

**À corriger :**

1. **L'incohérence du sommaire n'est pas signalée** — alors que c'est le point explicitement
   demandé. Cf. §5.4.
2. **Réponses inventées (p.206)** : la fiche imprime « surface », « quotient », « surface
   pressée », « petite » à la place des « …… » du manuel. Même pattern.
3. **Vocabulaire officiel normalisé au lieu d'être relevé tel quel.** La fiche liste
   « **empreinte** » ; le manuel imprime « **emprunte** » [sic] p.199 et p.200 (dans les
   généralisations **citées verbatim par la fiche**, qui a d'ailleurs bien conservé « emprunte »
   dans les citations — l'entrée de vocabulaire est donc en contradiction avec ses propres
   citations). **Incohérence de la source à signaler** : la p.202 imprime **les deux graphies sur
   la même page** — « profondeur h1 de l'**empreinte** » (×3, correct) et, dans le tableau,
   « Profondeur de l'**emprunte** (mm) ».
4. **Reconstruction non déclarée du corrigé p.205.** Le `.txt` donne
   `p=                            =176,4.103 Pa.` : **toute la substitution numérique imprimée
   est absente**. La fiche écrit « p = P/s = 176,4.10³ Pa (surface convertie en m²) ». Le
   résultat est bon (revérifié), mais l'étape imprimée n'est pas récupérable sans vision.
5. Termes de procédé omis (p.201) : « par **martelage, laminage ou emboutissage** ».
6. Coquilles source non relevées : p.198 « un plan **horizontale** [sic] » ; p.198 « la terre »
   en minuscule dans la généralisation (**bon point** : la fiche l'a conservée). **Bon point**
   également : la fiche a fidèlement conservé « le dynamomètre a **exercé** [sic] sur lui ».

---

## 5. Incohérences de la source & incertitudes — signalées, **non arbitrées**

### 5.1 Ch.10, exercice résolu q.4 (p.159) — **l'incertitude de la fiche est mal diagnostiquée**

La fiche écrit (lignes 2051-2056) :

> « […] ces valeurs numériques (0,16/0,16) semblent **incohérents** avec l'énoncé et avec les
> distances données au 3/a) […]. Il s'agit **probablement d'un artefact de l'extraction
> PDF→texte** (chiffres tronqués ou mal positionnés dans un tableau/fraction). »

**C'est le contraire.** Les valeurs sont cohérentes, c'est le libellé qui est fautif :

- le manuel imprime le résultat `= 1 m.s-1`, et `0,16 / 0,16 = 1` **tombe exactement juste** ;
- l'Activité V (p.154) établit que la chute dure **0,16 s** entre A et B ; une chute de **0,16 m**
  en 0,16 s donne bien 1 m.s⁻¹ ;
- la cohérence interne est donc **triple** (d, t, résultat imprimé). Un artefact d'extraction ne
  produit pas trois nombres qui se vérifient entre eux.

**Le seul défaut réellement imprimé** est le libellé : le corrigé écrit « Entre la première et la
**deuxième** position » là où l'énoncé de la question 4 demande « entre la première et la
**dernière** position ». **Coquille de la source** → `deuxième [sic]` + note, valeurs conservées.

**Deux conséquences.** (a) La fiche **arbitre en silence** dans le corps du texte : ligne 1477
elle écrit « 4) Vmoy entre **1ère et dernière** position », remplaçant le mot imprimé. (b) Le
diagnostic « artefact d'extraction » **invite un agent aval à “réparer” des nombres qui sont
justes** — c'est un piège actif. À réécrire.

### 5.2 Ch.11, `35.10²⁰ N` (p.169) — le signalement est bon, **la justification est fausse**

La fiche écrit (lignes 2057-2060) :

> « la notation « 35.1020 » de l'extraction a été interprétée comme 35×10²⁰ N (**conforme à
> l'ordre de grandeur physique réel, ≈ 3,5×10²¹ N**) ; l'exposant a pu perdre sa mise en forme ».

Le réflexe (signaler l'exposant perdu) est **le bon**. Mais le contrôle physique invoqué est faux :

> F = G·M☉·M⊕/d² = (6,674×10⁻¹¹ × 1,989×10³⁰ × 5,972×10²⁴) / (1,496×10¹¹)²
> = 7,93×10⁴⁴ / 2,24×10²² ≈ **3,5×10²² N**

L'attraction Soleil-Terre vaut **≈ 3,5×10²² N**, pas 3,5×10²¹ N. Or `35.10²⁰ = 3,5×10²¹`. La
lecture retenue est donc **10 fois trop petite**, et l'argument « conforme à l'ordre de grandeur
physique réel » qui l'a validée ne tient pas. Deux hypothèses, **qu'une transcription n'a pas
autorité pour départager** : soit le manuel imprime bien `35.10²⁰` et **la source est erronée
d'un facteur 10** (à signaler tel quel), soit l'extraction a mangé un chiffre. → **passe vision
requise sur p.169**, et retrait de la justification fausse dans tous les cas.

### 5.3 Ch.10, « Savoir plus » p.162 — paragraphe dupliqué (à vérifier en vision)

Le `.txt` contient **deux fois** le paragraphe « Si on augmente la vitesse initiale de l'objet, il
retombe de plus en plus loin et il vient un moment où il ne retombe plus sur la surface: » — la
seconde occurrence s'interrompt net après « sur la surface: ». Deux hypothèses possibles
(répétition réellement imprimée, ou artefact d'ordre de colonnes propre à cette mise en page
2 colonnes + légendes) : **je ne tranche pas**. → vérification vision p.162. Non relevé par la
fiche.

À signaler également, sans le corriger : le manuel nomme **« première vitesse de libération »**
(p.162) la vitesse de satellisation circulaire (≈ 7 km.s⁻¹) — dénomination non standard (l'usage
réserve « libération » à la vitesse d'évasion, ici « seconde vitesse de libération », 11,2 km.s⁻¹).
**Bon point** : la fiche a restitué la formulation du manuel entre guillemets, sans la corriger.

### 5.4 Ch.13 — incohérence du sommaire p.5 : **confirmée, à signaler, non arbitrée**

J'ai lu la p.5 pour instruire ce point. Le tableau du sommaire donne, pour « Forces et pression » :

> `Forces et pression | 196 | 198 | 202 | 203 | 204 | 204 | 205 | 206 | **206**`
> (dernière colonne = **Savoir Plus**)

Or le bloc « **SAVOIR PLUS / LES FONDATIONS** » est imprimé **p.208** ; la p.206 est la première
page des « Exercices à résoudre » — **le sommaire répète donc 206 dans deux colonnes**. Les 8
autres chapitres du manuel ont, eux, un « Savoir Plus » en dernière page de chapitre, distinct.

**Les deux informations sont imprimées ⇒ rapporter les deux, ne pas arbitrer.** La fiche cite
correctement « (p.208) » dans le corps du chapitre, mais **ne signale nulle part la divergence** :
sa §Incertitudes ch.10-13 n'en dit rien. → entrée à ajouter.

### 5.5 Ce que la §Incertitudes ch.10-13 doit devenir

L'entrée 1 est à réécrire (§5.1), l'entrée 2 à amender (§5.2), l'entrée 3 (« complet », « aucune
vérification par rendu image nécessaire ») est **à supprimer et remplacer**. Il faut y ajouter :
la notation vectorielle intégralement reconstruite (§3.1) ; les exposants (§3.2) ; l'inventaire
des figures (§7) ; le sommaire ch.13 (§5.4) ; le paragraphe dupliqué p.162 (§5.3) ; `l500 [sic]`
(§4.1) ; les coquilles `joigne` / `COPRS` / `sipres` / `hortisantale` / `Lorsque un` / `Elle et` /
`En suppose` / `emprunte` / `quelque soit` / `menu` / `acvités` / `Dés` / `horizontale` (§4) ; le
double « 1/- » du corrigé p.191 (§4.3) ; la corroboration « Newton (1642/1727) » p.174 (§4.2).

---

## 6. Ce qui est confirmé fidèle (à ne pas retoucher)

Pour éviter qu'une passe de correction n'abîme l'existant :

- **Les 4 encadrés normatifs majeurs sont verbatim exacts** : « Une action est toute cause… »
  (p.167) · « Principe d'inertie » (p.171) · « Condition d'équilibre » (p.183) · « Troisième loi
  de Newton » (p.187) · définition de la pression (p.200).
- **Les 4 « L'ESSENTIEL DU COURS » (p.158 / 174 / 190 / 204) ont été contrôlés puce par puce :
  32 puces, toutes fidèles**, aux seules réserves des §4.2-5 (élision p.174) et §4.3-2
  (2 coquilles corrigées p.190) et des symboles vectoriels (§3.1).
- **Toutes les valeurs numériques de la tranche ont été recoupées : aucune erreur de chiffre.**
  Y compris les 12 vitesses p.155, les 7 forces p.169, les 5 valeurs de `g` p.170, les 4 fiches
  sportives p.173, les 6 tableaux d'exercices. Les deux exercices résolus calculables (p.175,
  p.205) ont été **re-résolus** : résultats du manuel confirmés.
- Les 16 activités de mise en situation (4 par chapitre) et leurs questions : exactes.
- Les 4 fiches T.P et les 4 recherches documentaires : exactes (réserves mineures §4.1-5,
  §4.3-6, §4.4-5).
- Les sections « Concepts / notions », « Vocabulaire officiel » et « Bornes de scope » des 4
  chapitres sont **pertinentes et correctement bornées** (le découpage cinématique → actions →
  équilibre → pression est juste ; les exclusions annoncées — pas de dérivée, pas de 2ᵉ loi de
  Newton, pas d'équilibre à 3 forces, pas d'hydrostatique, pas de `F = G·m₁m₂/d²` — sont
  **vérifiées exactes** sur les 62 pages). Seule réserve : « empreinte » → « emprunte » [sic]
  (§4.4-3).

---

## 7. Inventaire des documents dont le contenu n'existe QUE dans l'image

`pdftotext` ne rend **aucune** image. **Aucun de ces éléments n'a été deviné.** Classement par
criticité pour l'aval.

### 7.1 BLOQUANT — item strictement inexploitable sans une passe vision (13)

| #   | Page    | Document                                                                                                              | Pourquoi c'est bloquant                                                                                |
| --- | ------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| 1   | **161** | Exercice « situations simples » n°3 : « **Pour chaque diagramme** déterminer la nature du mouvement »                 | **Zéro donnée dans le texte.** L'exercice est un renvoi pur à des diagrammes non rendus.               |
| 2   | **161** | Exercice « situations simples » n°2 : personnages **A, B, C** sur un tapis roulant, « du dessin ci-contre »           | Positions et sens de déplacement uniquement dans le dessin.                                            |
| 3   | **159** | Chronophotographie de l'exercice résolu ch.10                                                                         | Les distances **0,006 m / 0,010 m / 0,16 m** se **mesurent sur l'image** ; l'énoncé dit « ci-contre ». |
| 4   | **154** | Clichés **n°1** et **n°2** de la chute de balle (Activité V)                                                          | Graduation 2 mm, distances de 24 mm, intervalles 0,02 s : tout se lit sur les clichés.                 |
| 5   | **154** | Clichés **(A)** et **(B)** de la question ouverte (boule M→N)                                                         | Le raisonnement décéléré/uniforme porte sur les clichés seuls.                                         |
| 6   | **150** | L'axe des temps gradué                                                                                                | L'application dit « Situez sur **l'axe précédent** » — l'axe n'existe que dans l'image.                |
| 7   | **169** | Tableau « Ordre de grandeur » : **l'exposant de `35.10²⁰`**                                                           | Cf. §5.2 — la lecture retenue est invalidée par le contrôle physique.                                  |
| 8   | **205** | Exercice résolu ch.13 : **les deux lignes de calcul** (`p=…` et `p'=…`)                                               | La substitution numérique imprimée est **intégralement absente** du `.txt`.                            |
| 9   | **191** | Exercice résolu ch.12 : la ligne `Soit : = = m.g ; d'où : m = _ .`                                                    | Fractions et symboles éclatés/absents.                                                                 |
| 10  | **193** | Figures : **Tour de Pise + verticale (Δ)** · solide accroché au ressort · **deux pendules électrostatiques + F(1/2)** | Les 3 énoncés disent « ci-contre » et la géométrie porte la question.                                  |
| 11  | **177** | Figures : **avion jouet tenu par un fil** · **corps C1/C2** (pôle sud / équateur)                                     | « comme l'indique la figure ci-contre » ; l'orientation des poids est la réponse.                      |
| 12  | **207** | Figure des **deux corps de même masse** (dont « le corps sphérique ») · figure de la **brique**                       | « Les deux corps **ci-contre** » — la forme du second corps n'est nulle part dans le texte.            |
| 13  | **175** | Schéma du **plan incliné** de l'exercice résolu ch.11 (tracé du poids, échelle 1 cm → 20 N)                           | La représentation demandée s'appuie sur la figure.                                                     |

### 7.2 SYMBOLES / EXPOSANTS — reconstruits par la fiche, non vérifiés (14 emplacements)

Vecteurs absents : **p.168** (encadré « Modélisation » : `F⃗`, norme) · **p.170** (`P⃗`, norme,
`g⃗`) · **p.174** (`F⃗`, `P⃗`) · **p.182-183** (`F⃗1`, `F⃗2`, **`0⃗`**) · **p.183** (`P⃗`, `T⃗`) ·
**p.185-186** (`T⃗`, `F⃗`) · **p.187** (`F⃗A/B`, `F⃗B/A`, `T⃗1`, `T⃗2` ; le schéma se réduit à
`(   )  (R)  (   )`) · **p.190** (`F⃗1`, `F⃗2`, `0⃗`, `T⃗`, `Δl⃗`) · **p.191** · **p.198**
(`P⃗`, `T⃗`) · **p.200** et **p.204** (**numérateur `F` de `p = F/s`**).
Exposants aplatis : **p.169** (`35.1020`) · **p.176** (`107 N`, `103 N`) · **p.200/204**
(`105`, `102`) · **p.205** (`176,4.103`, `16,5.103`) · **p.206** (`125.106`, `0,8.10-4`).

### 7.3 Schémas expérimentaux non rendus — contenu décrit par le texte adjacent (≈ 20)

p.148 (voitures ; **trajectoires des planètes autour du Soleil** — le repère demandé est dans le
schéma) · p.149 (athlètes ; **chronophotographie de la balle de ping-pong**) · p.151 (bateau /
voile / oiseau / palmiers + observateurs (A) et (B) ; axe du repère espace) · p.152 (4 vignettes :
table à coussin d'air, chronophotographie, carte d'acquisition, stroboscope) · **p.153
(Figures 1, 2, 3, 4 — écrans d'oscilloscope)** · p.155 (tachymètre à t1 et t2) · p.162 (2 photos
ISS + légendes détaillées : laboratoire Destiny, modules Zarya/Zvezda, panneaux P6 — **la 2ᵉ
légende n'est pas dans la fiche**) · p.166 (3 schémas : chariot+doigt, bille+aimant, plan
incliné+aimant) · p.167 (ressort + pâte à modeler) · **p.168 (dynamomètre droit + « action de la
main » / « action du corps »)** · p.169 (3 chronophotographies (a)(b)(c) ; fil à plomb + craie) ·
p.170 (vecteur poids ; **anneau/cerceau — G hors du corps**) · p.171 (traces de l'éclateur) ·
p.172 (montage dynamomètre + masses ; tableau vide) · p.182 (polystyrène (S) + (D1)/(D2)) ·
p.184 (corps posés + P⃗/R⃗) · p.185 (ressort tiré/comprimé ; dynamomètre gradué) · p.186 (**vue de
dessus (A)/(B) sur liège + brins (f1)/(f2)** ; (D1) sur (D2)) · p.188 (montage loi de Hooke) ·
p.198-200 (schémas (S) suspendu ; (C) petite face / (C)+(C') / (C) grande face) · p.201
(vignettes : tranchants, machines-outils, skis, tracteur, chenilles, traverses, socles) · p.202
(cristallisoir + boîtes (A)/(B)).

### 7.4 Illustratif — l'absence ne bloque rien (≈ 10)

p.164 (lancer de marteau ; sauteur à la perche) · p.165 (voilier ; sauteur en hauteur) · p.173
(4 photos de sportifs) · p.178 (cosmonautes dans Mir) · p.180 (acrobates ; lustre) · p.181
(suspension de voiture ; patineurs) · p.189 (starting-block) · p.194 (schéma de l'interaction
gravitationnelle) · p.196 (chaise ; dromadaires) · p.197 (couteau ; punaise) · p.203 (4×4 dans
les dunes) · p.205 (patineuse).

**Passes vision minimales recommandées** (`Read` avec `pages=`, ≤ 20 p./appel) :
**p.159-161** (13 lignes de §7.1 en dépendent) · **p.169-170** · **p.168 + 174** ·
**p.183 + 190-191** · **p.193** · **p.200 + 204-205 + 207** · **p.162** (§5.3) ·
**p.175 + 177**.

---

## 8. Actions à porter sur la fiche (par ordre de priorité)

1. **Rectifier les 4 en-têtes de chapitre** : bornes réelles (147-162 / 163-178 / 179-194 /
   195-208) **et** désignation imprimée (`CHAPITRE I…IV` — `LA MECANIQUE`).
2. **Ajouter la p.147** au ch.10 (plan des 7 activités + 3 pré-requis, texte au §2.2).
3. **Supprimer** les puces « Fin de chapitre (p.179) — transition d'imprimerie » (l.1690) et
   « Transition (p.209) » (l.2022) : rationalisations inventées.
4. **Réécrire la §Incertitudes ch.10-13** selon §5.5 — en particulier **retirer** « le texte
   extrait était […] complet » et « aucune vérification par rendu image n'a été nécessaire ».
5. **Corriger les bornes des « Activités expérimentales »** (ch.10 → 150-155, ch.11 → 166-171,
   ch.12 → 182-187) et **les citations de page du ch.12** (activités IV-VI, §4.3-1).
6. **Rétablir les coquilles imprimées** avec `[sic]` dans les citations verbatim : `joigne`
   (p.170), `Lorsque un` / `Elle et notée` (p.190), `COPRS` (p.172), `l500` (p.154), `emprunte`
   (vocabulaire ch.13), et **signaler** le double « 1/- » du corrigé p.191.
7. **Retirer les réponses inventées** des phrases à trous (p.160, 176, 192, 206) et du QCM p.192,
   et **restituer les options imprimées**.
8. **Ajouter la donnée omise** de la Tour de Pise (position de G) et corriger la géométrie de son
   énoncé ; ajouter la remarque « stylo/trajectoire » (p.153) et la graduation 2 mm (p.154).
9. **Signaler l'incohérence du sommaire p.5 sur le ch.13** (Savoir Plus annoncé p.206, imprimé
   p.208) — sans l'arbitrer.
10. **Planifier les passes vision** du §7 avant toute génération de cours/exercices sur ces
    chapitres.

**Hors périmètre R-7, pour l'agent de consolidation** (rappels du cadrage, confirmés par cette
lecture) : le bloc « Sources » de la fiche (l.3-8) est **faux** — il annonce deux tomes
`222105P01/P02` et une note « chimie tome 2 » ; le manuel réellement transcrit est
**`223103P00.pdf`, volume unique, 276 p., sans chimie**. Et la ligne 137 de `_INDEX.md` est à
corriger.

---

## 9. Périmètre effectivement couvert

- **Lu en entier** : p.147 → p.208 (62 pages), via la couche-texte déterministe.
- **Lu en complément** : p.5 (sommaire) — pour instruire l'incohérence ch.13 exigée par la tranche.
- **Non lu** : p.4 (1ère page du sommaire) ; le reste du manuel (hors tranche).
- **Contrôles outillés** : décompte des sauts de page (277 segments = 276 pages + fin de fichier,
  cohérent) ; repérage automatique des rubriques p.147-208 ; recherche littérale des 8 coquilles
  suspectées — **les 8 sont confirmées présentes dans la couche-texte**, donc imprimées et non
  introduites par l'extraction.
- **Aucune** passe vision effectuée (aucune n'était nécessaire pour établir les constats
  ci-dessus ; celles qui restent requises sont listées au §7).
- **Aucune** écriture hors de ce fichier, **aucune** opération git.
