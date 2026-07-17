# Tranche 5 — VÉRIFICATION R-7 — sciences-physiques 1ère sec (223103P00), p.209–242

**Nature de la passe** : relecture de fidélité (PAS de re-transcription). Objet : sections de la fiche
`programme/1ere-sec/sciences-physiques.md` lignes ~2066–2412 (ch.14 Énergie et contrôle, ch.15 La Terre
et l'univers).
**Date** : 2026-07-17. **Pages réellement lues** : 209–242 en couche texte (34/34), + passes vision
ciblées sur p.222, 224, 233, 234, 235, 240, 241.

## 0. Fiabilité de la source (revérifiée indépendamment)

- `223103P00-physique.txt` : SHA256 `2b80954ad1030c74d852f41ca8c6eca35f6471e4c534a5566d44b7a558a9f55c`,
  529 556 o, 276 `\f` = 276 pages (pdfinfo), 277 chunks (le dernier vide). Décodage UTF-8 **strict**
  sans erreur.
- **Offset folio↔PDF = 0 confirmé sur ma tranche** par ancrage automatique : le folio imprimé égale
  l'index PDF sur les pages 209, 222, 226, 227, 240, 242.
- Le .txt est en **CRLF** (10 777 paires, 0 LF nu) — sans incidence, mais à savoir pour tout script.

> ⚠️ **Incident d'outillage à signaler** : le scratchpad de session est **partagé avec des sessions
> concurrentes** (tranches p.1-24 / 87-146 / 147-208 / 243-276 travaillent dans le même dossier). Mon
> `extract.py` a été **écrasé par une autre session entre deux appels**. J'ai re-extrait avec un script
> à nom unique et vérifié que les deux découpages sont **strictement identiques en contenu** sur mes
> deux plages. Recommandation pour les prochaines vagues : préfixer les scripts par la tranche.

## 1. LES DEUX POINTS OUVERTS — TRANCHÉS

### 1.1 « Joule (1642/1727) » p.222 → coquille **IMPRIMÉE**, confirmée ✅

Rendu vision de la p.222 (400 DPI) — l'encadré APERCU HISTORIQUE imprime littéralement :

> « Naviguer sur l'Internet (http://www.edunet.tn/physique/savants.htm) ou
> (http://www.infoscience.fr/histoire/biograph/biograph_som.html) et trouver les découvertes du savant
> Joule (1642/1727). »

**Verdict** : couche texte et rendu image **concordent** ⇒ la coquille est bien imprimée dans la source,
ce n'est pas un artefact d'extraction. Les dates 1642/1727 sont celles de **Newton** ; J. P. Joule
(1818/1889). **À laisser telle quelle + `[sic]`**, sans arbitrage.

**Correction à apporter à la fiche (l.2198-2201)** : la note actuelle dit « probable coquille du manuel
**ou artefact OCR** ». L'hypothèse OCR est à **retirer** : l'extraction est déterministe (couche texte
propre), il n'y a jamais eu d'OCR sur ce manuel ; et la vision confirme l'impression. Rédaction proposée :
« coquille imprimée dans la source (dates réelles de Newton), confirmée par lecture vision de la p.222 —
transcrite telle quelle, non corrigée ».

### 1.2 Tableau des caractéristiques des planètes → **LA FICHE ET LE CADRAGE SE TROMPENT DE PAGE** ⚠️

**Le tableau n'est pas p.240.** Vision p.240 et p.241 : **aucun tableau de planètes n'y est imprimé**.
Les deux exercices ne font qu'y **renvoyer** (« En vous aidant des informations fournies dans le tableau
des caractéristiques des planètes »).

**Le tableau est imprimé p.234** (cours, Activité IV, sous le texte telluriques/gazeuses), en **image
raster** — d'où son absence de la couche texte.

Preuve auxiliaire décisive : le tableau « cocher les cases » de la p.241 est, lui, **vectoriel** et **est
bien capté** par pdftotext. Donc les tableaux vectoriels de ce manuel sont extraits ; celui de la p.234
ne l'est pas parce que c'est une image. Et « Mercure » n'apparaît jamais dans la couche texte des p.240/241,
alors qu'un tableau des planètes le contiendrait forcément.

**Transcrit intégralement ci-dessous (passe vision 400 DPI, deux moitiés).** Le trou est **levé**.

#### p.234 — « Caractéristiques \ Planète » (verbatim, chiffres occidentaux, tel qu'imprimé)

| Caractéristiques                            | Mercure       | Venus  | Terre       | Mars         | Jupiter | Saturne | Uranus | Neptune | Pluton |
| ------------------------------------------- | ------------- | ------ | ----------- | ------------ | ------- | ------- | ------ | ------- | ------ |
| Distance moyenne au Soleil (millions de km) | 57,93         | 108,20 | 149,6       | 227,94       | 778,33  | 1430    | 2870   | 4490    | 5910   |
| Diamètre équatorial (km)                    | 4878          | 12104  | 12756       | 6786         | 142264  | 120536  | 51118  | 49528   | 2300   |
| Période de rotation (heure)                 | 1403,5        | 5815,2 | 23,93       | 24,62        | 9,84    | 10,23   | 17,90  | 19,20   | 6,39   |
| Période de révolution (année)               | 0,241         | 0,615  | 1           | 1,88         | 11,86   | 29,46   | 84,01  | 164,79  | 248,54 |
| Vitesse moyenne orbitale (km/s)             | 47,89         | 35,03  | 29,79       | 24,14        | 13,06   | 9,64    | 6,81   | 5,47    | 4,74   |
| Température de surface (°C)                 | de -180 à 430 | 480    | de -55 à 70 | de -120 à 25 | -150    | -180    | -210   | -220    | -230   |
| Masse relative à la Terre                   | 0,06          | 0,81   | 1           | 0,11         | 317,93  | 95,18   | 14,53  | 17,14   | 0,01   |
| Densité moyenne                             | 5,43          | 5,25   | 5,52        | 3,95         | 1,33    | 0,69    | 1,29   | 1,64    | 2,03   |
| Pesanteur à la surface (N/kg)               | 3,73          | 9,12   | 9,80        | 3,72         | 24,9    | 9,02    | 7,74   | 11,8    | 0,392  |
| Nombre de satellites connus                 | 0             | 0      | 1           | 2            | 16      | 23      | 15     | 8       | 1      |

- L'en-tête est une **cellule barrée en diagonale** : « Planète » (haut-droite) / « Caractéristiques »
  (bas-gauche). Le manuel écrit **« Venus »** sans accent dans le tableau (et p.234/p.238), mais
  **« Vénus »** avec accent p.233 — incohérence de la source, signalée, non arbitrée.
- **Contrôle de cohérence** : les 4 questions de la p.240 ex.2 sont bien toutes résolubles par ce tableau
  (plus proche du Soleil → Mercure 57,93 ; la plus grosse → Jupiter 142264 ; la moins dense → Saturne
  0,69 ; poids le plus grand → Jupiter 24,9 N/kg), et la p.241 ex.1 en a besoin (diamètre Terre 12756 et
  distance 149,6). Le tableau p.234 est bien le référent visé.

**Corrections à apporter à la fiche** : (a) ajouter ce tableau à l'Activité IV du ch.15 (p.233–234), où
la fiche ne le mentionne **pas du tout** ; (b) remplacer, l.2374-2376, « tableau des caractéristiques des
planètes (…) données du tableau non retranscrites ici, extraction texte incomplète pour ce tableau » par
un renvoi au tableau p.234 ; (c) noter que la p.241 ex.1 y renvoie aussi.

## 2. Erreurs de pagination de la fiche (R-5 : la fiche doit rester revérifiable)

| Fiche                                                 | Réalité         | Preuve                                                                                              |
| ----------------------------------------------------- | --------------- | --------------------------------------------------------------------------------------------------- |
| ch.14 « Savoir plus (p.225–226) » l.2221              | **p.226 seule** | p.225 = exercices ; la fiche cite elle-même « Exercices (p.224–225) » → chevauchement impossible    |
| ch.15 « Savoir plus (p.241–242) » l.2385              | **p.242 seule** | p.241 = exercices (fiche : « Exercices (p.240–241) »)                                               |
| ch.14 « Interprétation microscopique (p.216) » l.2133 | **p.217**       | le bloc s'ouvre en tête de la p.217                                                                 |
| ch.14 « Activités expérimentales (p.212–218) » l.2077 | **p.212–219**   | l'Activité VII court jusqu'à la p.219 incluse — la fiche le dit elle-même en item 8 « (p.218–219) » |

Incohérence interne mineure : l.2077 annonce « **7 blocs** » puis en énumère **8** (les 7 activités
officielles + « Interprétation microscopique », qui n'est pas une activité numérotée).

## 3. Omission structurelle — page d'ouverture du ch.14 (p.209) non transcrite

La fiche ne transcrit **pas** la p.209, alors que le ch.15 le fait pour la p.227 et le ch.16 pour la
p.243. Asymétrie à combler. Contenu imprimé p.209 (verbatim) :

- Bandeau : **« CHAPITRE I »** / **« L'ENERGIE »** / **« ENERGIE ET CONTRÔLE »**
  (rappel : le manuel numérote par thème en chiffres romains — « Chapitre 14 » est une convention de la fiche).
- **Plan des activités expérimentales** :
  - Activités(I) : Sources d'énergie renouvelables et sources d'énergie non renouvelables
  - Activités(II) : Les principales formes d'énergie
  - Activités(III) : Transformations mutuelles des formes d'énergie
  - Activités(IV) : Les différents modes de transfert d'énergie
  - Activités(V) : Les deux modes de transfert d'énergie par chaleur : la conduction et la convection
  - Activités(VI) : Isolation thermique
  - Activités(VII) : Energie et contrôle
- **Pré-requis** : Changement d'état physique de la matière · Le thermomètre et son utilisation · Mouvement

(Pour mémoire, la p.227 imprime « CHAPITRE I / ASTRONOMIE / LA TERRE ET L'UNIVERS » — la fiche transcrit
correctement son plan et ses pré-requis, mais ne relève pas non plus la mention « CHAPITRE I ».)

## 4. Blocs verbatim — CONFORMES ✅

- **ch.14 « L'ESSENTIEL DU COURS » p.222 : 14/14 puces conformes au verbatim** (contrôlées une à une
  contre le rendu vision, y compris les coquilles de la source, fidèlement recopiées).
- **ch.15 « L'ESSENTIEL DU COURS » p.238 : 9/9 puces conformes au verbatim.**

C'est le point fort de la fiche : les encadrés normatifs sont exacts.

## 5. Incohérences de la source **non signalées** par la fiche (à signaler, jamais à arbitrer)

1. **p.224 ex.1 1/- — « le bois » dans les deux listes** (CONFIRMÉ VISION) : « Le charbon, **le bois**, le
   pétrole et le gaz naturel sont des …… d'énergie …… et le Soleil, le vent, **le bois** et la géothermie
   sont des …… d'énergie ……. » Le même item doit être classé non renouvelable **et** renouvelable, alors
   que le cours p.212 range la biomasse en renouvelable. À signaler tel quel.
2. **p.235 — deux dates différentes pour le solstice de décembre, sur la même page** (CONFIRMÉ VISION) :
   « Le **21 (ou 22)** Décembre, les rayons solaires arrivent avec une inclinaison maximale » puis « Le
   **22 (ou 23)** Décembre, les rayons solaires tombent avec une inclinaison telle que le temps fera
   froid. Il s'agit du début de l'hiver. » La fiche (l.2322-2323) a **fusionné** les deux énoncés et
   retenu silencieusement « 21 (ou 22) décembre » → **arbitrage non autorisé**. Les deux doivent être
   rapportés.
3. **p.235 — « A partir du début de l'hiver, le Soleil commence à se décaler vers le sud. »** (CONFIRMÉ
   VISION) : contredit la suite immédiate et le solstice d'hiver (décalage sud déjà maximal). Non
   transcrite par la fiche.
4. **p.235 — phrase altérée** (CONFIRMÉ VISION) : « **Les débuts des couper du jeun** [sic] **sont-ils à
   la même heure le long des années ?** » Transcrire verbatim + `[sic]` ; **ne pas deviner** l'intention.
   Question de clôture non transcrite par la fiche (avec « Dans la carte des saisons ci-dessus, repérez la
   position de la Terre à la date de votre naissance. »).
5. **p.225 ex.3** : « Un radiateur électrique, utilisant la rotation d'un ventilateur **pour refroidir**
   l'atmosphère environnante, est alimenté par le secteur. » — un radiateur qui refroidit. La fiche
   paraphrase en « radiateur électrique à ventilateur » et perd l'anomalie.
6. **p.238 essentiel, puce 9** : « …et de **sa rotation autour du Soleil**, la Terre présente le phénomène
   périodique des saisons » — le manuel a pourtant défini « révolution » (autour du Soleil) vs « rotation »
   (axe polaire) p.234. Verbatim exact dans la fiche, mais l'incohérence terminologique n'est pas relevée.

## 6. Coquilles de la source **corrigées silencieusement** par la fiche (violation R-5)

1. **p.233 : « méhane »** [sic] — CONFIRMÉ VISION. La fiche (l.2307-2308) écrit « méthane ». À restituer
   « méhane [sic] ».
2. **p.237 : « tâches »** [sic pour « taches »] — la fiche écrit « taches » (l.2333).

## 7. Coquilles de la source **fidèlement recopiées mais non marquées `[sic]`**

Elles sont exactes, mais sans `[sic]` un relecteur les prendra pour des fautes de la fiche — R-5 demande
le marquage :

- p.222 essentiel : « L'énergie totale d'un système **et** la somme… » (pour « est ») — CONFIRMÉ VISION.
- p.222 essentiel : « alors que **chaleur** est un mode de transfert désordonné » (manque « la ») — CONFIRMÉ VISION.
- p.222 essentiel : « Elles sont non polluantes **et dont** l'exploitation cause le moins de dégâts écologiques » (p.212, syntaxe rompue).
- p.212 : « Le **soeil** » (pour « Soleil »).
- p.214/215 : « Il est **notée** WM / WE / WR » (accord).
- p.230 : « Ils sont **situées** à des distances très grandes ».
- p.240 : « de grandes **figurent** appelées » (pour « figures ») — CONFIRMÉ VISION.
- p.224 : « Il **,existe** deux principales formes d'énergie ».
- p.239 : « **Pérsée** » dans la solution vs « Persée » dans l'énoncé.

## 8. Notation

- **p.222 : WM / WE / WR sont imprimés avec des INDICES** (W<sub>M</sub>, W<sub>E</sub>, W<sub>R</sub>) —
  CONFIRMÉ VISION. `pdftotext` aplatit les indices ; la fiche écrit « WM/WE/WR ». À noter (cosmétique,
  mais c'est du jargon officiel).
- Les **exposants** sont aplatis par `pdftotext` (« 3,6.106 J », « 1,6.10-19 J », « 4,2.1014 », « 40.109 »).
  La fiche les a **restitués correctement** — vérifié en vision : p.222 (ΔE, joule) et p.240 (QCM
  (a) 40.10⁹ / (b) 12,66.10⁸ / (c) 39,92.10¹²), ainsi que le tableau d'équivalences p.214. ✅
- Chiffres occidentaux, équations LTR, unités SI : conformes partout dans la tranche.

## 9. Omissions de contenu (R-5 « profondeur de génération »)

**ch.14**

- p.212 : 1re puce de généralisation non transcrite — « Le soeil [sic], le vent, la biomasse… assurent et
  entretiennent les activités des êtres vivants. Ce sont des sources d'énergie. »
- p.215 : les **définitions parallèles** de WE et WR non transcrites (« Le travail électrique est un mode
  de transfert d'énergie entre deux systèmes. Il est notée WE. » ; idem « Le rayonnement… WR. ») — seule
  celle de WM figure dans la fiche.
- p.216 : « La convection de la chaleur est un transfert d'énergie par chaleur qui s'effectue avec un
  transport de matière. » + « Ce déplacement provoque l'augmentation progressive de la température. »
- p.218 : **le bloc « Economiser sur l'eau chaude » entièrement absent** (ballon dimensionné aux besoins
  réels, 30 à 50 litres par personne ; individualiser la production d'ECS de celle du chauffage ;
  distribuer l'eau chaude à une température aussi faible que possible). p.219 : « Contrôler la pression
  des roues » absent.
- p.224 ex.1 2/- non transcrit : « Dans une chaîne d'énergie, les …… n'emmagasinent pas l'énergie : ils
  transfèrent à des réservoirs toute l'énergie qu'ils reçoivent. »
- p.225 ex.2 (synthèse) : la **cellule pré-remplie** du tableau (ligne « Chimique » × colonne
  « Mécanique » = « Réacteur d'une fusée ») non notée.

**ch.15**

- **p.234 : LE TABLEAU** (majeur — levé au §1.2).
- p.235 : les deux questions de clôture (cf. §5.4).
- p.236 : les **12 lignes de coordonnées** des constellations (Grande Ourse 1→7 : 275°/5,0 ; 270°/3,5 ;
  260°/3,5 ; 245°/3,5 ; 240°/4,0 ; 225°/3,5 ; 225°/3,0 — Cassiopée 1→5 : 95°/3,0 ; 90°/3,5 ; 85°/3,0 ;
  80°/3,5 ; 75°/3,0 — toutes en « divisions ») résumées en « avec leurs angles/distances tabulés ». R-5
  demande les données chiffrées ; elles sont dans la couche texte, donc gratuites à récupérer.
- p.241 ex.1 : le renvoi « En vous aidant des informations fournies dans le tableau des caractéristiques
  des planètes » non noté (2ᵉ référence au tableau p.234).
- p.239 : commentaire non transcrit — Algol « baptisée Algol par les astronomes arabes ce qui signifie
  "œil du démon" ».

## 10. Figures non rendues — contenu pédagogique **exclusivement** dans l'image

**13 items porteurs** recensés nommément sur la tranche ; **1 est levé par cette passe** (le tableau
p.234) ⇒ **12 restent à traiter**. Les photos purement illustratives (mises en situation p.210-211,
p.228-229 ; photos d'expériences p.212, 214-217 ; illustrations d'économie d'énergie p.218-219 ; Soleil
p.221 ; ciel/Voie Lactée p.230-232 ; comète p.233 ; pose longue p.234 ; aurore p.237) ne sont **pas**
comptées : leur contenu testable est dans le texte.

| #   | Page | Document                                                                                                                                                                                              | Statut                       |
| --- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| 1   | 234  | **Tableau des caractéristiques des planètes**                                                                                                                                                         | ✅ **LEVÉ** — transcrit §1.2 |
| 2   | 213  | Schéma du circuit pile / interrupteur / moteur-ventilateur (« Fermons le circuit ci-contre »)                                                                                                         | à faire                      |
| 3   | 223  | Exercice résolu — **solution 1/-** : le schéma du circuit (c'est la réponse)                                                                                                                          | à faire                      |
| 4   | 223  | Exercice résolu — **solution 3/-b)** : le schéma des transferts (c'est la réponse)                                                                                                                    | à faire                      |
| 5   | 226  | Schéma légendé de la centrale nucléaire (légendes Barres de contrôle / Cuve / Echangeur / Pompe / Eau / Vapeur présentes en texte ; le schéma non)                                                    | à faire                      |
| 6   | 231  | Figures des constellations : Grande Ourse → prolongement « environ 5 fois » → étoile Polaire                                                                                                          | à faire                      |
| 7   | 235  | **« Carte des saisons »** (bande zodiacale Capricorne / Verseau / Poissons / Bélier / Taureau / Gémeaux) — explicitement renvoyée par la question de clôture « Dans la carte des saisons ci-dessus… » | à faire                      |
| 8   | 235  | Photos « En été » / « En hiver » avec axes Est / Sud / Nord / Ouest et course du Soleil                                                                                                               | à faire                      |
| 9   | 236  | Fiche T.P. — la « carte vierge du ciel »                                                                                                                                                              | à faire                      |
| 10  | 239  | Exercice résolu — **la figure des deux constellations + deux étoiles** (« Dans la figure sont représentées deux constellations et deux étoiles : lesquelles ? ») — **exercice insoluble sans elle**   | à faire                      |
| 11  | 239  | Exercice résolu — schéma-solution 2/- (Terre + les deux étoiles alignées)                                                                                                                             | à faire                      |
| 12  | 241  | Ex.2 synthèse — schéma des ellipses + points noirs (positions des planètes) — **insoluble sans**                                                                                                      | à faire                      |
| 13  | 241  | Ex.3 synthèse — paysage + course du Soleil (Est/Sud/Nord/Ouest) — **insoluble sans**                                                                                                                  | à faire                      |

La fiche ne signale **aucun** de ces documents comme exigeant une passe vision : sa seule mention de trou
figure (l.2374-2376) et elle se trompe de page. Les items 10, 12 et 13 sont les plus critiques : ce sont
des exercices dont l'énoncé est **inexploitable** sans la figure — un générateur de contenu qui lirait la
fiche seule produirait des questions insolubles.

## 11. Bornes de scope — contrôle

Les bornes ✅ INCLUS / ⛔ EXCLU des deux chapitres (l.2238-2250 et l.2399-2411) sont **exactes** et bien
déduites du texte réellement imprimé. Vérifications ponctuelles :

- ch.14 : aucune formule ½mv², mgh, ni Q = mcΔθ, ni puissance/rendement dans la tranche → ⛔ correct.
- ch.15 : aucune loi de Kepler ni formule gravitationnelle → ⛔ correct. « phases de la Lune et éclipses
  → ch.16 » : confirmé (le plan p.243 annonce « Activités(VI) : Les phases de la Lune - Les éclipses »).
- ch.15 : « équinoxes / solstices non nommés comme tels dans le texte » → **confirmé**, le manuel écrit
  « début du printemps / de l'automne / de l'été / de l'hiver » sans jamais employer les deux mots.
- **Nuance à ajouter au scope ch.15** : avec le tableau p.234 désormais transcrit, la lecture de tableau
  de données chiffrées (comparer distances, diamètres, densités, pesanteurs) est **✅ INCLUSE** — c'est
  l'objet de p.240 ex.2 et p.241 ex.1. La fiche ne pouvait pas le voir puisqu'elle n'avait pas le tableau.

## 12. Verdict

**Fidélité du fond : bonne.** Les deux encadrés normatifs sont verbatim-exacts (14/14 et 9/9), les
généralisations officielles sont fidèles, les données chiffrées du texte sont exactes et les exposants
correctement restitués. Rien d'**inventé** n'a été trouvé sur la tranche.

**Mais la fiche n'est pas promouvable `[x]` en l'état** — 4 défauts qui affectent la revérifiabilité et
la réutilisation :

1. le **tableau p.234 manquant** et mal localisé (majeur — il porte 2 exercices sur 2 pages) ;
2. **4 erreurs de pagination**, dont deux « Savoir plus » qui se chevauchent avec les exercices ;
3. **6 incohérences de la source non signalées**, dont **une arbitrée** silencieusement (les deux dates
   du solstice de décembre, §5.2) et **deux coquilles corrigées** silencieusement (§6) — ce sont les
   seules vraies violations de la règle « signaler, jamais arbitrer » ;
4. **12 figures porteuses** non signalées, dont 3 rendent des exercices insolubles.

Aucun de ces points ne demande de rouvrir le scan : tout est corrigeable depuis ce rapport.
