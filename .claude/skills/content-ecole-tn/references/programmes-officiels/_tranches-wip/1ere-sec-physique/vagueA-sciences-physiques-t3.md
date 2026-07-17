# VÉRIFICATION R-7 — Physique 1ère sec (CNP 223103P00), thème LA MATIÈRE, ch.6–9 (p.87–146)

**Nature du travail** : relecture de fidélité de la fiche existante
`.claude/skills/content-ecole-tn/references/programmes-officiels/programme/1ere-sec/sciences-physiques.md`
(sections ch.6–9, lignes 687–1347, + sa §Incertitudes lignes 1348–1361) contre le manuel officiel.
**Pas de re-transcription** : ce qui est conforme est attesté, pas recopié. Le contenu exact n'est
restitué que là où la fiche a un trou ou une erreur (action corrective).

**Sources de contrôle**

- `D:\11-coding\YahiaAcademy\cnp-officiel\_txt\223103P00-physique.txt` (couche-texte déterministe) — p.87–146 lues **intégralement**, plus p.4–5 (sommaire) et p.9 + p.16 (ch.1) pour deux points de cohérence.
- **Passe vision ciblée** (`pdftoppm -r 200` → `Read`) sur **5 pages** : **92, 94, 104, 122, 123** — motivées par des formules/tableaux non rendus par `pdftotext`.

**Verdict global** : fiche **globalement fidèle sur le fond** — les 36 énoncés des 4 encadrés
« L'essentiel du cours » sont **verbatim exacts** (10+11+7+8), et **tous les tableaux chiffrés sont
recoupés exacts** (§9). Mais **4 écarts MAJEURS** et **une incohérence de la source jamais relevée**
(masse volumique / densité du fer) doivent être traités avant promotion `[x]`. La §Incertitudes de
la fiche contient en outre **une affirmation infirmée** par ma passe vision (§8).

---

## 1. Écart systémique — bornes de pages des 4 chapitres (MAJEUR)

La fiche décale **les 4 bornes de +1** : elle exclut la page d'ouverture (qui appartient au chapitre)
et inclut l'ouverture du chapitre suivant. Structure réelle vérifiée sur le .txt (ouverture
« CHAPITRE <romain> » → page « SAVOIR PLUS »), folios imprimés recoupés (offset 0 confirmé) :

| Ch. | Titre imprimé sur la page d'ouverture          | Réel          | Annoncé par la fiche |
| --- | ---------------------------------------------- | ------------- | -------------------- |
| 6   | LES ETATS PHYSIQUES DE LA MATIERE              | **p.87–100**  | p.88–101 ✗           |
| 7   | QUELQUES PROPRIETES DE LA MATIERE              | **p.101–114** | p.102–115 ✗          |
| 8   | LA MASSE                                       | **p.115–130** | p.116–131 ✗          |
| 9   | LES CHANGEMENTS D'ETAT PHYSIQUE D'UN CORPS PUR | **p.131–146** | p.132–147 ✗          |

Origine probable : le **sommaire p.4 ne liste pas la page d'ouverture** (sa première colonne est
« Activités de mise en situation » = 88/102/116/132). La fiche a suivi le sommaire.
Les **pages internes** citées par la fiche sont, elles, en offset 0 correct (deux exceptions en §2/§3).

**Conséquence directe** : les 4 pages d'ouverture ne sont **pas transcrites** — or elles portent le
**« Plan des activités expérimentales »** et les **« Pré-requis »**, exigés par R-5, et **deux d'entre
elles portent des incohérences de la source** (§6.2, §6.3). Contenu manquant à ajouter :

- **p.87 (ch.6)** — Plan : (I) Les états physiques de la matière · (II) Calcul et mesure de volumes ·
  (III) Relation entre certaines unités de mesure de volumes · (IV) Propriétés caractéristiques des
  solides et des liquides · (V) Propriétés caractéristiques des gaz · (VI) Description microscopique
  des états de la matière. Pré-requis : Mesure des longueurs · Unités de mesure des longueurs et des
  volumes · Calcul des volumes de corps de formes géométriques simples.
- **p.101 (ch.7)** — Plan : (I) Effet d'une variation de la température sur un corps solide ·
  (II) … sur un corps liquide · (III) … sur un corps gazeux · (IV) **Conductibilité** thermique des
  corps. Pré-requis : Notion de température · Notion de volume · Les états physiques de la matière ·
  Précautions à prendre lors de l'utilisation d'une source de chaleur.
- **p.115 (ch.8)** — Plan : (I) La masse d'un corps · (II) Mesure d'une masse · (III) La masse
  volumique d'un corps · (IV) Densité d'un liquide et d'un solide. Pré-requis : Mesurer un volume ·
  Conversion des unités de volume · Les états physiques de la matière.
- **p.131 (ch.9)** — Plan : (I) La solidification d'un corps pur et la transformation inverse ·
  (II) La vaporisation par ébullition · (III) La vaporisation par évaporation · (IV) La condensation
  de la vapeur d'eau : cycle de l'eau · (V) La sublimation · (VI) Conservation de la masse lors d'un
  changement d'état · (VII) Interprétation microscopique des changements d'état / Notion d'équilibre
  dynamique. Pré-requis : Propriétés caractéristiques des corps dans les différents états physiques
  de la matière · Structure corpusculaire de la matière et agitation thermique · Mesure de la
  température · Mesure de la masse et mesure du volume d'un corps.

**Point de fidélité validé** : contrairement aux ch.3 et ch.5 (divergences déjà connues), les titres
**sommaire p.4 ↔ page d'ouverture concordent** pour les ch.6–9. En revanche le titre du ch.9 imprimé
**aux deux endroits** est « Les changements d'état **physique** d'un corps pur » ; la fiche (ligne 1173)
titre « Les changements d'état d'un corps pur » — **« physique » est amputé** (MAJEUR, titre de chapitre).

---

## 2. Chapitre 6 — Les états physiques de la matière (p.87–100)

**Conforme** : les 4 mises en situation (p.88–89) ; act. I/II/IV/V/VI ; Fiche T.P p.94 ; Recherche
documentaire p.95 ; **L'essentiel du cours p.96 — 10 items verbatim exacts** ; Aperçu historique
(Avogadro 1776/1856) ; Exercice résolu p.97 (V=64 cm³ ; V_T=114 mL ; V_D=14 mL) ; exercices p.98–99 ;
Savoir plus p.100.

**Écarts**

1. **(MAJEUR — trou de contenu, confirmé en vision p.94)** Fiche T.P p.94, protocole du corps (B) :
   la fiche s'arrête à « comparer V' au cube du rayon » et **omet la relation à vérifier**, rendue
   vide par `pdftotext` (« Vérifier que : . ») parce qu'elle est une **image de formule**.
   Vision p.94 → la formule imprimée est :
   **`Vérifier que : V'/R³ = 4/3 π`**
   C'est le cœur pédagogique du protocole (vérification expérimentale du volume de la sphère). À ajouter.
2. **(MAJEUR — incohérence source non signalée)** **Numérotation des activités du ch.6** : le manuel
   imprime **deux fois « ACTIVITES (II) »** en p.91 (« Qu'appelle-t-on volume d'un corps ? » puis
   « Utilise-t-on d'autres unités de volume ? ») et **passe directement à « ACTIVITES (IV) »** p.92
   (confirmé en vision) : **aucune « ACTIVITES (III) » n'est imprimée**, alors que le plan p.87 en
   annonce une (« Relation entre certaines unités de mesure de volumes » — soit exactement la 2ᵉ (II)).
   La fiche contourne en inventant un intitulé (« Suite Activité II (unités) », ligne 730) puis saute
   à « Activité IV » sans explication. **À signaler comme incohérence de la source, pas à arbitrer.**
3. **(MOYEN — pagination)** Ligne 730 : l'encadré des unités (« Pour mesurer des volumes… »), le
   tableau des volumes, la remarque du ménisque et la question des 4 positions de l'œil sont attribués
   à **p.91** ; ils sont **tous p.92** (vérifié en vision). Seule l'activité « Utilise-t-on d'autres
   unités de volume ? » est p.91.
4. **(MOYEN — incohérence source non signalée)** Exercices « Vérifier ses acquis » p.98, item 3 : le
   manuel numérote **1/- , 2/- , 4/-** — le **3/- est sauté**. Non relevé.
5. **(MINEUR)** Exercice résolu p.97 : l'énoncé demande « avoir dans **le bécher** 100 mL d'air », la
   solution imprimée répond « Pour remplir **le verre** d'air… ». La fiche (ligne 804) normalise en
   « bécher » et **lisse l'incohérence** au lieu de la signaler.
6. **(MINEUR)** Coquille imprimée non marquée : tableau p.92, « Cube **d'arrête** : a » [sic]
   (confirmé en vision ; p.91 écrit correctement « d'arête »).
7. **(MINEUR)** Vocabulaire officiel non relevé : « **capacité** » (récipient/bécher), « pied à
   coulisse », « cristallisoir », « erlenmeyer », « verre à pied », « pissette ».

---

## 3. Chapitre 7 — Quelques propriétés de la matière (p.101–114)

**Conforme** : mises en situation p.102–103 ; act. I à IV ; tableau des conducteurs thermiques
(p.107 : argent/cuivre/aluminium/fer — verre/bois/brique/papier — amiante/plastique/laine/liège) ;
Fiche T.P p.108 ; Recherche documentaire p.109 ; **L'essentiel du cours p.110 — 11 items verbatim
exacts** ; Aperçu historique (S'gravesande 1688/1742) ; exercices p.112–113 ; Savoir plus p.114.

**Deux vérifications demandées, toutes deux VALIDÉES**

- **Δθ (p.104)** : le .txt rend « Δl =lo.λ.Δ0- ; où Δ0- est la variation… ». **Vision p.104** → le
  manuel imprime bien **`Δl = lo.λ.Δθ ; où Δθ est la variation de la température du corps et λ est une
constante qui dépend du matériau qui le constitue.`** Le « 0- » est un **artefact d'extraction**, pas
  une coquille source. **La restitution de la fiche (ligne 872) est exacte.** (Nuance triviale : le
  manuel imprime « lo », lettre o, là où la fiche écrit « l₀ ».)
- **Renvoi « voir chapitre I, activités V » (p.107)** : la fiche (ligne 922) l'interprète comme
  « renvoi explicite au chapitre 1 d'électrostatique du même manuel ». **Vérifié et correct** : le
  ch.1 (thème L'ÉLECTRICITÉ, ouverture p.9) annonce « Activités(V) : Corps conducteurs et corps
  isolants », imprimée p.16 (« ACTIVITES (V): Tous les corps sont-ils conducteurs ? »). Le chapitre I
  du thème LA MATIÈRE (= ch.6) a bien une activité (V), mais sur les gaz — aucune ambiguïté réelle.
  _Réserve de forme_ : la numérotation par thème rend un « chapitre I » nu ambigu ; la fiche gagnerait
  à citer la page (p.16) plutôt qu'un numéro de convention.

**Écarts**

1. **(MOYEN — définition officielle non transcrite)** p.105, encadré « Application : Le thermomètre » :
   la fiche résume l'échelle Celsius en « intervalle divisé en 100 parties = degré Celsius » et
   **omet la définition officielle du degré**, imprimée en toutes lettres :
   > « Le degré Celsius est la variation de température qui produit, dans le tube capillaire du
   > thermomètre, une variation du niveau du mercure égale au 1/100 de sa variation observée entre les
   > températures 0°C et 100°C suite à l'immersion du réservoir du thermomètre respectivement dans la
   > glace fondante et dans l'eau bouillante. »
2. **(MOYEN — reconstitution non sourcée d'une figure)** Exercice résolu p.111 : la fiche (ligne 957)
   décrit « dispositif imaginé par un élève (**ballon + tube fin**) ». L'énoncé imprimé dit seulement
   « le dispositif de **la figure ci-contre** » ; le texte ne mentionne nulle part un « ballon » (la
   solution ne cite que « le verre, le liquide et l'air » et « le tube fin »). **« ballon » est déduit
   par analogie avec l'act. II p.104, pas lu** → viole la règle « ne jamais reconstituer une figure ».
   À remplacer par un renvoi figure + passe vision.
3. **(MOYEN — pagination)** Ligne 935 : « L'essentiel du cours (p.109–110) » → il est **entièrement
   p.110** ; p.109 est la Recherche documentaire.
4. **(MOYEN — profondeur R-5)** Synthèse item 2 p.113 : la fiche (ligne 981) résume le tableau du
   volume de 1 kg d'eau par ses seules bornes. Les **9 couples sont exacts** mais non transcrits, donc
   l'exercice n'est pas régénérable. Tableau imprimé :
   | θ (°C)                                                                                          | 0       | 1       | 2       | 3       | 4       | 5       | 6       | 7       | 8       |
   | ----------------------------------------------------------------------------------------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
   | V (mL)                                                                                          | 1000,12 | 1000,07 | 1000,03 | 1000,01 | 1000,00 | 1000,01 | 1000,03 | 1000,07 | 1000,11 |
   | Consigne également omise : « On prendra la graduation 1000 mL sur l'axe des ordonnées confondue |
   | avec la graduation 0°C sur l'axe des abscisses. »                                               |
5. **(MINEUR)** Act. III p.106 : le manuel insiste sur « **un égal volume** d'air » (condition « à
   égalité de volume ») ; la fiche écrit « l'autre de l'air ».
6. **(MINEUR)** Exercice résolu p.111 : la fiche omet la condition imprimée « **si son volume est
   comparable à celui du liquide** » sur la dilatation de l'air.
7. **(MINEUR)** Synthèse item 3 p.113 : sous-questions qualitatives omises (« Que se passerait-il pour
   le rail en été ? / … en hiver ? »).
8. **(MINEUR — vocabulaire officiel)** Non relevés : « **échelle centésimale** », « **degré
   centésimal** », « **liquide thermométrique** », « **thermoscope** », « ballast », « vérins
   hydrauliques », « vase d'expansion ». Surtout : le manuel emploie **« conductibilité thermique »**
   (plan p.101, mise en situation p.103) **et « conductivité thermique »** (p.107, p.110) — **deux
   termes pour la même notion dans le même chapitre** ; à relever comme variation de la source.

---

## 4. Chapitre 8 — La masse (p.115–130)

**Conforme** : mises en situation p.116–117 ; act. I à V ; **tous les tableaux chiffrés** (§9) ;
Fiche T.P p.124 ; Recherche documentaire p.125 ; **L'essentiel du cours p.126 — 7 items verbatim
exacts** ; Aperçu historique (Roberval 1602/1675) ; Exercice résolu p.127 (12,55 g.cm⁻³ = 12550
kg.m⁻³ < 19300 → creux ; V_cavité = 0,7 cm³) ; exercices p.128–129 ; Savoir plus p.130.

**Vérification demandée, VALIDÉE** — les deux formules de la p.123 sont des **images** (rendues vides
par `pdftotext`). **Vision p.123** → la fiche les a **restituées exactement** :
`d = ρ(substance)/ρ(eau)` et `d = ρs/ρe = (ms/Vs)/(me/Ve) = ms/me`.
_Réserve méthodologique_ : la fiche les présente **entre guillemets, comme du verbatim**, sans
signaler qu'elles proviennent d'une image — le résultat est juste, la méthode ne l'était pas (elle
n'était pas vérifiable avant ma passe vision).

**Écarts**

1. **(MAJEUR — incohérence de la source jamais relevée)** → détaillé en **§6.1** : **densité du fer
   7,80 (p.123) vs masse volumique 7900 kg.m⁻³ (p.122) ⇒ 7,90**. Les deux valeurs sont **confirmées
   imprimées en vision**. C'est le point que le cadrage demandait de chercher.
2. **(MAJEUR — incohérence source non signalée)** **Plan p.115 vs corps du chapitre** : le plan
   annonce **4 activités**, le manuel en imprime **5** ((I) p.118 → (V) p.122), et les intitulés
   décrochent : le plan (IV) « Densité d'un liquide et d'un solide » correspond en fait à
   **ACTIVITES (V)** p.122, tandis que l'ACTIVITES (IV) imprimée p.121 porte sur la masse volumique
   d'un solide. **À signaler, pas à arbitrer.**
3. **(MOYEN — substitution de terme)** « Utiliser ses acquis » item 3 p.129 : le manuel écrit
   « placée dans **la chambre froide d'un réfrigérateur** » ; la fiche (ligne 1141) écrit « placée au
   **congélateur** ». (« congélateur » est le terme de la remarque p.106, ch.7 — probable
   contamination.)
4. **(MINEUR)** Synthèse item 3 p.129 : sous-question 2b omise (« Schématiser l'éprouvette contenant
   l'huile et l'alcool en utilisant une couleur pour chacun des deux liquides »).
5. **(MINEUR)** Savoir plus p.130 : la fiche reprend « densité de la glace inférieure de **10 %** à
   celle de l'eau ⇒ **90 %** du volume immergé » sans signaler la **tension avec le tableau p.123**
   (d(glace) = 0,92 ⇒ 8 % / 92 %). Arrondi de la source — à signaler, pas à corriger.
6. **(MINEUR)** Coquilles imprimées non marquées : « l'**ensemle** formé par l'eau et le solide »
   (p.121) [sic] · « son volume **poura** être évalué » (p.122) [sic, confirmé en vision] ·
   « **Choloforme** » dans la légende de la photo (p.122) [sic, confirmé en vision] · « on utilise une
   balance et **de** corps dont on connaît les masses » (p.128) [sic] · guillemet doublé
   « « kilogramme étalon international» » (p.125) [sic] · définition p.121 imprimée « ρ = m/**v** »
   (v minuscule) alors que le texte pose « volume **V** ».
7. **(MINEUR — vocabulaire officiel)** Non relevé : « **masse moyenne par unité de volume** »
   (formulation de l'exercice résolu p.127), « étalon », « platine iridié », « fiole », « carat
   métrique », « verre mesureur ».

---

## 5. Chapitre 9 — Les changements d'état **physique** d'un corps pur (p.131–146)

**Conforme** : mises en situation p.132–133 ; act. I à VII (dont l'équilibre dynamique p.139) ;
**tableau des températures de changement d'état p.137 — 8 valeurs exactes** (§9) ; Fiche T.P p.140 ;
Recherche documentaire p.141 ; **L'essentiel du cours p.142 — 8 items verbatim exacts** ; Aperçu
historique (Celsius 1701/1744) ; Exercice résolu p.143 (**17 couples θ(t) recoupés exacts**) ;
exercices p.144–145 ; Savoir plus p.146.

**Vérification demandée, VALIDÉE** — « molécules d'**éther** » (p.136) : **la coquille est bien
IMPRIMÉE**, ce n'est **pas** un artefact d'extraction. Verbatim confirmé :

> « Ce mode de changement d'état est une vaporisation par évaporation : les molécules d'éther quittent
> la surface de contact avec l'air et passent dans l'atmosphère. »
> alors que l'expérience porte sur « quelques gouttes d'alcool (ou d'acétone…) ». **La fiche l'a
> correctement relevé** (ligne 1350) et laissé tel quel. ✅ Rien à changer sur ce point.

**Écarts**

1. **(MAJEUR)** **Titre amputé** : « Les changements d'état d'un corps pur » (ligne 1173) → le titre
   imprimé, **à la fois au sommaire p.4 et sur l'ouverture p.131**, est « Les changements d'état
   **physique** d'un corps pur ».
2. **(MOYEN — coquille reproduite sans marque)** L'essentiel p.142, 5ᵉ item : le manuel imprime
   « …à des températures supérieures à sa **température du fusion**… ». La fiche **reproduit
   fidèlement** la coquille (ligne 1277) **mais ne la marque pas `[sic]`** — R-5 l'exige, faute de
   quoi un générateur la lira comme une faute de frappe de la fiche et la « corrigera » silencieusement
   (ou la propagera). Même remarque, plus bénigne, sur l'absence de point final de l'item précédent.
3. **(MOYEN — figures non signalées)** Exercice résolu p.143 : la solution imprimée renvoie à
   « **Voir la courbe rouge** » (1b) et « **Voir la courbe bleue en pointillé** » (2b) — deux courbes
   qui n'existent **que dans l'image**. La fiche décrit l'allure de la courbe inverse (« fusion au même
   palier de 5°C ») : c'est **déductible du commentaire imprimé** (« (A) étant pur… ses transformations
   inverses (solidification et fusion) se produisent à la même température θ = 5°C »), donc l'inférence
   est licite — mais **le trou n'est pas signalé**.
4. **(MINEUR — incohérence source non signalée)** p.137 : « Par échauffement, **l'iode** se
   transforme… » / « Par refroidissement, **le diiode** se transforme… » — **deux nomenclatures dans
   deux phrases consécutives**. La fiche cite les deux verbatim mais ne relève pas la variation.
5. **(MINEUR — incohérence source non signalée)** Exercice résolu p.143 : les intervalles de la
   question 1c **se chevauchent en t = 12 mn** ([6,12] _et_ [12,16]) et reçoivent deux réponses
   contradictoires (« mélange liquide+solide » / « solide, en train de se refroidir ») alors que
   θ(12) = 5°C est encore sur le palier.
6. **(MINEUR)** Recherche documentaire p.141 : la question 1 porte sur « le sens du mot
   « percolation » **indiqué sur la figure** » — le mot **n'apparaît pas dans le texte**, seulement
   dans le schéma du cycle de l'eau (non rendu). À signaler comme dépendance figure.
7. **(MINEUR — erreur factuelle de la source)** Savoir plus p.146 : le manuel classe le
   « **HCFC 134A** » parmi les hydrochlorofluorocarbones, puis explique que « les HCFC sont dégradés
   par des radicaux hydroxyles… et **peu de chlore** atteint la couche d'ozone ». Le R‑134a est en
   réalité un **HFC** (sans chlore). La fiche reprend « des HCFC comme le HCFC 134A » sans signalement.
   **À signaler, pas à arbitrer** (le manuel officiel fait foi pour l'examen).
8. **(MINEUR)** Coquilles imprimées non marquées : « de la glace **mélangé** avec du sel » (p.143)
   [sic] · « Il est **entrain** de se refroidir » (p.143, ×2) [sic].

---

## 6. Incohérences de la SOURCE — signalées, non arbitrées

### 6.1 ⚠️ Densité du fer : 7,80 (p.123) contradictoire avec ρ = 7900 kg.m⁻³ (p.122) — **MAJEUR, inédit**

Les deux valeurs sont **confirmées imprimées** (vision p.122 et p.123) :

| Substance   | ρ (kg.m⁻³) p.122   | d attendu = ρ/ρ(eau), ρ(eau)=1000 p.121 | d imprimé p.123 | Verdict           |
| ----------- | ------------------ | --------------------------------------- | --------------- | ----------------- |
| Cuivre      | 8900               | 8,90                                    | 8,90            | ✅                |
| Or          | 19300              | 19,30                                   | 19,30           | ✅                |
| Liège       | 240                | 0,24                                    | 0,24            | ✅                |
| Chloroforme | 1480 (p.121)       | 1,48                                    | 1,48            | ✅                |
| Huile       | 920 (p.121, g.L⁻¹) | 0,92                                    | 0,92            | ✅                |
| Eau         | 1000               | 1,00                                    | 1,00            | ✅                |
| **Fer**     | **7900**           | **7,90**                                | **7,80**        | ❌ **discordant** |

Le fer est le **seul** de la table à décrocher, et le manuel **définit lui-même** d = ρ(substance)/ρ(eau)
(p.123) — la contradiction est donc **interne et vérifiable par l'élève**. Elle est **piégeuse pour la
génération** : l'exercice p.128 (« Trois objets en fer, en cuivre, en aluminium… ») renvoie au tableau
des **masses volumiques**, tandis qu'un item sur les densités renverrait à 7,80.
**Action** : consigner en §Incertitudes avec `[sic]`, transcrire **les deux valeurs telles quelles**,
et **interdire l'arbitrage** — une transcription n'a pas autorité pour corriger le programme officiel.

### 6.2 Ch.6 — numérotation des activités : deux « (II) », aucune « (III) » (p.91–92) — **MAJEUR, inédit**

Voir §2.2. Le plan p.87 annonce pourtant « Activités(III) : Relation entre certaines unités de mesure
de volumes ».

### 6.3 Ch.8 — le plan p.115 annonce 4 activités, le chapitre en imprime 5 — **MAJEUR, inédit**

Voir §4.2 (intitulés décalés à partir du rang III/IV).

### 6.4 Sommaire p.4 inexact sur le ch.7 — **MOYEN, inédit**

Le sommaire annonce « Exercices à résoudre » du ch.7 en **p.113** ; ils commencent en réalité
**p.112** (« EXERCICES / Vérifier ses acquis »). Les 8 autres renvois du ch.7 et **les 27 renvois des
ch.6/8/9 sont exacts** (recoupés un à un).
→ **Même famille que l'incohérence déjà connue du ch.13** (« Savoir Plus » annoncé p.206, réel p.208) :
le sommaire de ce manuel a **au moins deux renvois faux**. À consigner comme tel.

### 6.5 Libellé de rubrique : sommaire vs page — **MINEUR**

Le sommaire p.4 nomme la colonne « **Naviguer sur L'Internet** » (p.96/110/126/142) ; la rubrique
imprimée sur ces pages s'intitule « **APERCU HISTORIQUE** » et contient l'invitation à naviguer. La
fiche emploie le libellé imprimé (correct) mais ne signale pas la divergence.

### 6.6 Autres — voir §2.4, §2.5, §3.8, §4.5, §5.4, §5.5, §5.7 et les coquilles typographiques.

**Point de contrôle demandé — dates des « Aperçu historique »** : aucune anomalie du type
« Joule (1642/1727) » (p.222, hors tranche) dans les ch.6–9. Les 4 renvois sont **exacts et
historiquement corrects** : Avogadro (1776/1856), S'gravesande (1688/1742), Roberval (1602/1675),
Celsius (1701/1744).

---

## 7. Figures non rendues — inventaire nommé (exigent une passe vision ciblée)

`pdftotext` ne rend **aucune** image. Ci-dessous les documents dont le **contenu pédagogique n'existe
que dans l'image** — jamais à reconstituer. **Les 5 premières ont été levées par ma passe vision** ;
les autres restent ouvertes.

### 7.1 Levées par ma passe vision (contenu désormais établi)

| Page    | Document                        | Résultat                                                                                |
| ------- | ------------------------------- | --------------------------------------------------------------------------------------- |
| **94**  | Fiche T.P, « Vérifier que : … » | **`V'/R³ = 4/3 π`** — **manquait à la fiche** (§2.1)                                    |
| **104** | Relation de dilatation          | `Δl = lo.λ.Δθ` — fiche **correcte**, « Δ0- » = artefact                                 |
| **123** | Définition de la densité (×2)   | `d = ρ(substance)/ρ(eau)` et `d = ρs/ρe = (ms/Vs)/(me/Ve) = ms/me` — fiche **correcte** |
| **122** | Tableau ρ des solides           | Fer **7900** confirmé imprimé (§6.1)                                                    |
| **92**  | Tableau des volumes             | `a³                                                                                     | L.l.h | π R².h | 4/3 π R³` confirmé ; « d'arrête » [sic] confirmé |

### 7.2 Ouvertes — contenu exclusivement graphique, **à ne pas deviner**

| Page                                  | Document                                                               | Ce qui manque                                                                                                                                                                                                                                 |
| ------------------------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **92**                                | Photo éprouvette 250 mL + positions **(a)(b)(c)(d)** de l'œil          | Les positions relatives à la surface libre — la question est insoluble sans l'image. _(Vu en vision : photo d'une éprouvette « 250:2 ml / ±2,0 ml / In 20°C », 4 repères pointés sur le ménisque — je ne tranche pas laquelle est correcte.)_ |
| **93**                                | **Modèle microscopique des trois états**                               | Le schéma annoncé par « on peut utiliser le modèle suivant : »                                                                                                                                                                                |
| **99**                                | Synthèse 1 : « les récipients suivants »                               | Les formes des récipients (à dessiner le niveau)                                                                                                                                                                                              |
| **99**                                | Synthèse 2 : « éprouvette graduée **photographiée** ci-contre »        | Unité, volume max, valeur d'une division, volume affiché — **4 sous-questions insolubles** sans la photo                                                                                                                                      |
| **111**                               | Exercice résolu : « le dispositif de la figure ci-contre »             | Le montage (→ §3.2 : la fiche l'a **deviné**)                                                                                                                                                                                                 |
| **113**                               | Synthèse 1 : thermomètre à **minima et maxima**                        | Branches droite/gauche et **indexes I et J** — insoluble sans l'image                                                                                                                                                                         |
| **129**                               | Synthèse 1 : « La **pesée** de ce cylindre est représentée ci-contre » | Les masses marquées → « Déterminer sa masse » insoluble sans l'image                                                                                                                                                                          |
| **129**                               | Synthèse 2 : « mesures schématisées ci-contre » (zinc)                 | Les lectures d'éprouvette                                                                                                                                                                                                                     |
| **141**                               | Schéma du cycle de l'eau                                               | Le mot « **percolation** » n'existe **que** sur la figure (§5.6)                                                                                                                                                                              |
| **143**                               | Exercice résolu : **courbe rouge** + **courbe bleue en pointillé**     | Les deux tracés θ = f(t) (§5.3)                                                                                                                                                                                                               |
| **145**                               | Synthèse 2 : **courbes (A) et (B)**                                    | Insoluble sans les tracés (« Identifier pour chaque courbe le contenu du bécher »)                                                                                                                                                            |
| **145**                               | Synthèse 3 : états **(a) (b) (c)** en boules                           | Insoluble sans les figures                                                                                                                                                                                                                    |
| 88–89, 102–103, 116–117, 132–133      | Photos des mises en situation (16 vignettes)                           | Support des questions (ex. « les corps posés sur la table ») — contenu partiellement dans l'image                                                                                                                                             |
| 90, 91, 93, 104–107, 118–123, 134–140 | Schémas/photos de montages                                             | Illustratifs : le texte décrit le protocole ; **non bloquants**                                                                                                                                                                               |

**Total : 13 documents bloquants ouverts** (+5 levées par ma passe vision).

---

## 8. Contrôle de la §Incertitudes existante (lignes 1348–1361)

| #   | Affirmation de la fiche                                                                                                     | Verdict                                                                                                                                                                                                                                                                                                                 |
| --- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | « molécules d'éther » (p.136) = probable erreur de rédaction, transcrite verbatim                                           | ✅ **CONFIRMÉ** — bien imprimé, pas un artefact. Rien à changer.                                                                                                                                                                                                                                                        |
| 2   | « Les schémas/figures… **Non vérifié par rendu image (jugé non nécessaire — le contenu textuel est cohérent et complet)** » | ❌ **INFIRMÉ — le point le plus grave**. Ma passe vision démontre le contraire : (a) la formule `V'/R³ = 4/3 π` (p.94) **manquait purement et simplement** ; (b) **13 documents** (§7.2) sont insolubles sans leur figure. La justification « jugé non nécessaire » doit être retirée et remplacée par l'inventaire §7. |
| 3   | Ch.8 item 3.3 (p.128) : bonne réponse « **déduite du cours et non du corrigé** »                                            | ⚠️ **Surdimensionné**. Exact qu'aucun corrigé n'est imprimé, mais la réponse est **explicitement donnée** par L'essentiel p.126 : « Elle ne dépend ni de la forme du corps ni de sa position dans l'espace **ni de son état physique** ». À reformuler en citant la source plutôt qu'en déclarant une incertitude.      |

**Absents de la §Incertitudes et à y ajouter** : §6.1 (fer 7,80/7900 — **prioritaire**), §6.2, §6.3,
§6.4, §2.4 (saut du 3/- p.98), §5.2 (« température du fusion » à marquer `[sic]`), §5.4 (iode/diiode),
§5.7 (HCFC 134A), §4.5 (iceberg 10 %/90 %), et les coquilles typographiques (§2.6, §4.6, §5.8).

---

## 9. Tableaux chiffrés — recoupement valeur par valeur (contrôle demandé)

**Tous conformes**, sauf l'incohérence **interne au manuel** du §6.1 (que la fiche ne signale pas).

| Tableau                           | Page      | Valeurs                                                                                                    | Verdict fiche                                                                                           |
| --------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Volumes des solides simples       | 92        | a³ · L.l.h · πR².h · 4/3 πR³                                                                               | ✅ 4/4                                                                                                  |
| ρ des liquides                    | 121       | eau 1000 · chloroforme 1480 · alcool 790 (kg.m⁻³)                                                          | ✅ 3/3                                                                                                  |
| Couples (V, m) de l'huile         | 120       | 250 mL/230 g · 100 mL/92 g · 17 mL/15,6 g → 920 g.L⁻¹                                                      | ✅ 6/6 (arithmétique cohérente : 0,92 g.mL⁻¹, arrondi 15,6 ≈ 17×0,92)                                   |
| ρ des solides à 25°C              | 122       | Al 2700 · Cu 8900 · Fe 7900 · liège 240 · Au 19300 · Pb 11300 · Zn 7150                                    | ✅ 7/7 (**vision**)                                                                                     |
| Densités                          | 123       | eau 1,00 · glace 0,92 · huile 0,92 · chloroforme 1,48 · cuivre 8,90 · or 19,30 · liège 0,24 · **fer 7,80** | ✅ 8/8 **fidèlement transcrites** — mais **fer 7,80 contredit ρ=7900** (§6.1), non signalé (**vision**) |
| Mesure de ρ d'un solide           | 121–122   | V1=50 mL · V2=55 mL · V=5 mL · m=39,5 g · ρ=7,9 g.mL⁻¹=7900 kg.m⁻³                                         | ✅ 5/5 (39,5/5 = 7,9 ✓)                                                                                 |
| Températures de changement d'état | 137       | Eau 0/100 · Éthanol −117/78 · Mercure −39/357 · Fer 1535/2750 (°C)                                         | ✅ 8/8                                                                                                  |
| θ(t) de l'exercice résolu         | 143       | 24,20,16,12,8,6,5 (t=0→6) · 5 constant (t=6→12) · 5,4,2,0,−2 (t=12→16)                                     | ✅ 17/17                                                                                                |
| Volume de 1 kg d'eau              | 113       | 1000,12 → 1000,00 (4°C) → 1000,11                                                                          | ✅ bornes exactes, **9 valeurs non transcrites** (§3.4)                                                 |
| Exercice résolu du bijou          | 127       | m=25,1 g · V=2 cm³ · ρ(or)=19,3 g.cm⁻³ · 12,55 g.cm⁻³ · 0,7 cm³                                            | ✅ 5/5 (25,1/19,3=1,30 ; 2−1,30=0,70 ✓)                                                                 |
| Conducteurs thermiques            | 107       | 3 classes × 4 matériaux                                                                                    | ✅ 12/12                                                                                                |
| Cohérence inter-chapitres         | 137 ↔ 145 | alcool θs=−117°C, θe=78°C ↔ Éthanol −117/78                                                                | ✅ cohérent                                                                                             |

---

## 10. Incertitudes de MA vérification

- **Aucun `[?]`** : la couche-texte est propre et la tranche a été lue intégralement ; les 5 points
  douteux ont été levés en vision (§7.1). Aucune valeur n'a été devinée.
- **Périmètre vision** : 5 pages sur 60. Les **13 documents du §7.2** restent non levés — je ne les ai
  **pas** ouverts et ne les ai **pas** reconstitués. Leur levée demande une passe dédiée
  (`render.sh 223103P00.pdf <p> <p> 200` → `Read`), à cadrer hors R-7.
- **Affichage `�`** : aucun signalé — j'ai lu le .txt avec `encoding="utf-8"` explicite, conformément
  au cadrage.
- **Non arbitré, par construction** : §6.1 (fer), §6.2/6.3 (plans vs activités), §6.4 (sommaire),
  §5.7 (HCFC), §4.5 (iceberg), §5.5 (chevauchement t=12). Ces points sont **signalés** ; la décision
  appartient à l'agent de consolidation, et aucune correction du programme officiel n'est proposée.
- **Hors périmètre R-7 mais confirmé au passage** : le plan du manuel fourni au cadrage (bornes
  ouverture→savoir plus des ch.6–9, offset folio 0, numérotation romaine par thème) est **exact** ;
  les actions de cohérence annoncées (ligne 137 de `_INDEX.md`, bloc « Sources » de la fiche) n'ont
  pas été touchées.

---

## Synthèse des actions (par priorité)

| #   | Action                                                                                                                                                                                                 | Sévérité   | §                          |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------- | -------------------------- |
| 1   | Consigner l'incohérence **fer d=7,80 vs ρ=7900** avec `[sic]`, sans arbitrer                                                                                                                           | **MAJEUR** | 6.1                        |
| 2   | Ajouter la formule **`V'/R³ = 4/3 π`** (Fiche T.P p.94)                                                                                                                                                | **MAJEUR** | 2.1                        |
| 3   | Corriger les **4 bornes de chapitre** et transcrire les **4 pages d'ouverture** (plan + prérequis)                                                                                                     | **MAJEUR** | 1                          |
| 4   | Rétablir le titre du ch.9 : « changements d'état **physique** d'un corps pur »                                                                                                                         | **MAJEUR** | 5.1                        |
| 5   | Signaler la numérotation des activités **ch.6** (deux (II), pas de (III)) et le **plan ch.8** (4 vs 5)                                                                                                 | **MAJEUR** | 6.2, 6.3                   |
| 6   | Remplacer la §Incertitudes item 2 (« jugé non nécessaire ») par l'inventaire figures §7                                                                                                                | **MAJEUR** | 8                          |
| 7   | Ajouter la définition officielle du **degré Celsius** (p.105)                                                                                                                                          | MOYEN      | 3.1                        |
| 8   | Retirer la reconstitution « ballon + tube fin » (p.111) → renvoi figure                                                                                                                                | MOYEN      | 3.2                        |
| 9   | Marquer `[sic]` sur « **température du fusion** » (p.142)                                                                                                                                              | MOYEN      | 5.2                        |
| 10  | Corriger 2 paginations (encadré unités p.92 ; L'essentiel ch.7 p.110) ; « chambre froide » ≠ congélateur ; sommaire ch.7 (113/112) ; saut du 3/- p.98                                                  | MOYEN      | 2.3, 3.3, 4.3, 6.4, 2.4    |
| 11  | Transcrire les 9 valeurs du tableau 1 kg d'eau (p.113)                                                                                                                                                 | MOYEN      | 3.4                        |
| 12  | Compléter le vocabulaire officiel (échelle/degré centésimal, conductibilité vs conductivité, thermoscope, liquide thermométrique, masse moyenne par unité de volume…) et marquer les coquilles `[sic]` | MINEUR     | 2.6-2.7, 3.8, 4.6-4.7, 5.8 |
