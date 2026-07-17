# R-7 — Vérification de fidélité · Physique 1ère sec · p.25–86 (thème L'ÉLECTRICITÉ, ch.2–5)

> **Nature** : relecture de fidélité (R-7). **Aucune re-transcription, aucune réécriture de la fiche.**
> **Cible** : `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/1ere-sec/sciences-physiques.md`
> §2.2 (l.14–199), §2.3 (l.201–350), §2.4 (l.352–501), §2.5 (l.503–668), §Incertitudes ch.2-5 (l.670–685).
> **Source** : `cnp-officiel/manuels/secondaire/c1/eleve/223103P00.pdf` via `cnp-officiel/_txt/223103P00-physique.txt`
> (couche-texte propre, extraction déterministe).
> **Pages réellement lues** : 25–86 en intégralité (62 p.) + sommaire p.4–5 = **64 pages**.
> **Contrôles automatiques** : recensement regex des en-têtes `ACTIVITES (n)` sur p.25–86 ; comparaison
> plan d'ouverture ↔ corps sur les 4 chapitres ; revérification arithmétique de tous les relevés I/U.

---

## Verdict

**La fiche est globalement fidèle et son socle normatif est sain.** Les **41 items des 4 encadrés
« L'ESSENTIEL DU COURS »** (13 p.38 + 10 p.52 + 12 p.66 + 6 p.82) sont **tous présents, tous fidèles,
dans l'ordre**. Les 4 lois (nœuds, mailles, Ohm, convention de sens) sont verbatim conformes. **Toutes
les valeurs chiffrées relevées sont conformes à la source** — aucune valeur inventée, aucune valeur
devinée sur un graphique.

Mais la relecture remonte **3 findings majeurs** qui, non traités, produiront du contenu faux ou
ingénérable, et **une conclusion à inverser** sur l'anomalie du ch.5 (le point que la mission demandait
explicitement de recouper).

| Sévérité   | Nb  | Résumé                                                                                                                                                                                                      |
| ---------- | --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **MAJEUR** | 3   | Incohérence arithmétique de la source non signalée (p.76) ; 2 figures bloquantes non signalées (p.31, p.77+83+85)                                                                                           |
| **MODÉRÉ** | 5   | Anomalie ch.5 mal diagnostiquée ; 4 pages d'ouverture non transcrites ; 2 divergences de titre non signalées ; bornes de pages fausses ×4 ; 5 corrections silencieuses de coquilles ; 3 ajouts non imprimés |
| **MINEUR** | 7   | Paginations internes, troncatures, omissions R-5, renvoi faux, notation, [sic] manquant, artefacts de titre                                                                                                 |

---

## MAJEUR

### M1 — p.76 (ch.5) · Incohérence arithmétique **de la source** non signalée : le « 220 V·A⁻¹ »

Le manuel imprime pour le dipôle (D) :

| U(V)  | 2   | 12  | 21  |
| ----- | --- | --- | --- |
| I(mA) | 91  | 545 | 955 |

puis conclut : « **I et U sont proportionnelles puisque U1/I1 = U2/I2 = U3/I3 = 220 V.A-1.** »

**Les rapports réels sont 21,98 / 22,02 / 21,99 V·A⁻¹ ≈ 22 — pas 220. Facteur 10.**

- Les trois rapports sont **mutuellement cohérents** ⇒ la proportionnalité (le point pédagogique) tient.
- Deux lectures possibles, **à ne pas arbitrer** : soit le « 220 » devrait être « 22 » ; soit les trois
  intensités sont 10× trop grandes (il faudrait 9,1 / 54,5 / 95,5 mA — ce que donne exactement R = 220 Ω).
- Le témoin est sain : le potentiomètre p.75 (0/2,9/7,2/11,4/17,2/21,5 mA) donne 690→702 V·A⁻¹, cohérent.
- La p.77 imprime « R = 220 Ω » au code des couleurs, ce qui **pourrait** appuyer la 2ᵉ lecture — mais rien
  n'établit que ce résistor est le dipôle (D). **Ne pas trancher.**

**La fiche transcrit les chiffres fidèlement (l.535-536) ✅ mais ne relève pas l'incohérence.** Impact
direct : une génération produirait « U = 12 V, I = 545 mA → calculer R » avec une clé à 22 Ω contredisant
le manuel qui affirme 220 Ω. **À porter en §Incertitudes.** Passe vision p.76 recommandée pour confirmer
que « 91 / 545 / 955 » et « 220 » sont bien ce qui est imprimé.

### M2 — p.31 (ch.2) · Figure bloquante non signalée : la table des symboles normalisés

L'activité IV **est** une table de 12 dipôles ; dans le .txt les lignes « Symbole » sont **vides** — les
symboles normalisés, c'est-à-dire **tout le contenu pédagogique de l'activité**, n'existent que dans l'image :

```
Dipôle    Fil conducteur   Générateur     Lampe    Moteur
Symbole                                                        ← vide
Dipôle    Interrupteur fermé  Interrupteur ouvert  Diode  DEL
Symbole                                                        ← vide
Dipôle    Electrolyseur    Ampèremètre    Voltmètre  Ohmmètre
Symbole                                                        ← vide
```

La fiche (l.57-60) liste les 12 **noms** et n'indique nulle part que les symboles manquent. Or
« Pour schématiser un circuit, on utilise des symboles normalisés » est un item de L'essentiel p.38, et
la p.31 est **le seul endroit du manuel** où ces symboles sont donnés. **Passe vision p.31 obligatoire.**

### M3 — p.77 + p.83 + p.85 (ch.5) · Figure bloquante non signalée : le code des couleurs

Seules les **valeurs** « R = 220 Ω » et « R = 6000 Ω = 6 kΩ » sont extraites (p.77). **Les anneaux colorés
eux-mêmes — et la table de correspondance couleur→chiffre si elle existe — sont des images.** Le code des
couleurs est pourtant exigible en trois endroits :

- L'essentiel p.82 : « …ou se lit directement sur le résistor **ou à l'aide d'un code de couleurs** »
- Exercice résolu p.83 q.4 : « En utilisant le code des couleurs **dessiner ce résistor avec les anneaux colorés** »
- Exercices p.85 q.2 : « **En utilisant les codes de couleurs donner les valeurs des résistances** de (R1) et (R2) »

**Ingénérable sans vision p.77 + p.83 + p.85.** Non signalé par la fiche.

---

## MODÉRÉ

### D1 — ★ Le point demandé : l'anomalie « Activité III » du ch.5 — **diagnostic à inverser**

**Ce que dit la fiche** (§Incertitudes, l.672-677) : « **Chapitre 5, p.79 (Activité V)** : la **table des
matières** annonce une "Activités(III) : Détermination de la résistance d'un résistor" distincte […]
**possible artefact de mise en page (colonnes/encadrés) perdu par l'extraction pdftotext plutôt qu'une
réelle absence dans le manuel.** Non vérifié par rendu image. »

**Quatre corrections :**

**(a) Faux sourcing.** Le sommaire p.4-5 **ne liste aucune activité** — uniquement des numéros de page par
rubrique (colonnes : mise en situation | expérimentales | T.P | doc | essentiel | Internet | résolu |
exercices | Savoir Plus). Recherche exhaustive : le libellé « Détermination de la résistance d'un
résistor » **n'apparaît qu'à la p.71**, dans le « **Plan des activités expérimentales** » de la page
d'ouverture du chapitre — page que la fiche n'a pas transcrite (cf. D2).

**(b) Mauvaise page.** La note est classée « p.79 (Activité V) ». L'anomalie est en **p.76-77**, entre les
activités II et IV.

**(c) Conclusion inversée — preuve déterministe.** Comparaison plan d'ouverture ↔ en-têtes réellement
imprimés, sur les 4 chapitres :

| Ouverture       | Plan annonce | Corps imprime        |                                  |
| --------------- | ------------ | -------------------- | -------------------------------- |
| p.25 (ch.2)     | I…VIII (8)   | I…VIII (8)           | MATCH                            |
| p.43 (ch.3)     | I…V (5)      | I…V (5)              | MATCH                            |
| p.57 (ch.4)     | I…VI (6)     | I…VI (6)             | MATCH                            |
| **p.71 (ch.5)** | **I…V (5)**  | **I, II, IV, V (4)** | **DIVERGENCE — le (III) manque** |

`pdftotext` rend **23 en-têtes « ACTIVITES (n) » sur 23 attendus** dans les ch.2/3/4 — **100 % de
fiabilité sur ce motif exact**. L'hypothèse « artefact d'extraction » est donc **très faiblement
soutenue** : l'extracteur ne perd jamais ce motif ailleurs, et l'encadré qui occupe la place du III
(« **Mesure de la résistance d'un résistor** », p.76) **est** correctement rendu. Il s'agit selon toute
vraisemblance d'une **anomalie réelle du manuel** : la numérotation saute de (II) à (IV), le contenu
annoncé comme III étant traité dans un encadré **non numéroté** p.76 + le code des couleurs p.77.
**Vision p.76-77 pour clore définitivement**, mais la formulation actuelle penche du mauvais côté.

**(d) Corollaire — incohérence interne de la fiche.** §2.5 annonce « **Activités expérimentales (p.74–79)
— 5 blocs** » puis n'en décrit que **4** (I, II, IV, V). Le décompte réel est bien 4 ; c'est l'annonce
« 5 blocs » qui est fausse. (À son crédit : la fiche conserve correctement les numéros officiels IV et V
plutôt que de renuméroter 3 et 4. ✅)

### D2 — Les 4 pages d'ouverture ne sont pas transcrites (p.25, 43, 57, 71)

Aucune des 4 pages d'ouverture n'est transcrite. Sont perdus le **titre réel du chapitre** (cf. D3), le
**« Plan des activités expérimentales »** (titres officiels des activités, distincts des en-têtes-questions
du corps) et surtout les **« Pré-requis »** — information de premier plan pour la génération
(dépendances pédagogiques explicites du manuel) :

| p.     | Pré-requis imprimés                                                                                                         |
| ------ | --------------------------------------------------------------------------------------------------------------------------- |
| **25** | Conducteurs et isolants · Effet magnétique (aimant, boussole et aiguille aimantée) · Cations et anions · Incandescence      |
| **43** | Circuit électrique et sa schématisation · Sens du courant électrique · Conducteurs et isolants · Court-circuit              |
| **57** | Dipôle générateur et dipôle récepteur · Dipôle isolé et dipôle en circuit fermé · Circuit en série et circuit en dérivation |
| **71** | Mesurer une intensité · Mesurer une tension · Choisir un calibre · Tracer un graphique dans un repère cartésien             |

**Cause racine identifiée** : la fiche s'est fiée au **sommaire p.4-5** pour sa pagination — ses
paginations internes correspondent **exactement, colonne par colonne**, aux lignes du sommaire (ch.2 :
26/28/36/37/38/38/39/40/42 ; ch.5 : 72/74/80/81/82/82/83/84/86). Or le sommaire ne référence pas les
pages d'ouverture. Ceci explique D3 **et** D4 d'un seul mécanisme.

### D3 — Les 2 divergences de titre sommaire ↔ ouverture ne sont pas signalées

Les deux sont **imprimées** ⇒ rapporter les deux, ne pas arbitrer. Confirmé :

| ch.   | Sommaire p.4                          | Ouverture                                         | Fiche retient          |
| ----- | ------------------------------------- | ------------------------------------------------- | ---------------------- |
| 2     | Le circuit électrique                 | p.25 « LE CIRCUIT ELECTRIQUE »                    | — (concordent)         |
| **3** | **L'intensité du courant électrique** | **p.43 « L'INTENSITE DU COURANT »**               | sommaire, sans mention |
| 4     | La tension électrique                 | p.57 « LA TENSION ELECTRIQUE »                    | — (concordent)         |
| **5** | **Le dipôle résistor**                | **p.71 « CARACTERISTIQUE D'UN DIPÔLE RESISTOR »** | sommaire, sans mention |

La fiche adopte silencieusement le titre du sommaire pour ses 4 sections. Les divergences annoncées par
le cadrage sont **confirmées** (et limitées aux ch.3 et ch.5 : ch.2 et ch.4 concordent).

### D4 — Bornes de pages fausses dans les 4 titres de section

Pattern systématique « [1ʳᵉ rubrique du sommaire] → [1ʳᵉ rubrique du chapitre suivant − 1] », qui
**exclut la page d'ouverture du chapitre et inclut celle du suivant** :

| Fiche annonce    | Réel        |
| ---------------- | ----------- |
| ch.2 « p.26–43 » | **p.25–42** |
| ch.3 « p.44–57 » | **p.43–56** |
| ch.4 « p.58–71 » | **p.57–70** |
| ch.5 « p.72–87 » | **p.71–86** |

Le cadrage a raison sur les 4. (Les paginations **internes** de la fiche, elles, sont majoritairement
justes — cf. m1 pour les exceptions.)

### D5 — 5 corrections silencieuses de coquilles dans des citations annoncées « verbatim »

Règle : coquille de la source ⇒ transcrite telle quelle + `[sic]`. La fiche corrige sans le dire :

| p.  | Source imprime                                                        | Fiche écrit                       |
| --- | --------------------------------------------------------------------- | --------------------------------- |
| 32  | « par l'une **des ses** bornes »                                      | « par l'une **de ses** bornes »   |
| 49  | « …bornes de connexion**.** » — parenthèse ouvrante **jamais fermée** | « …bornes de connexion**).** »    |
| 75  | « Le coefficient de proportionnalité est **notée** R »                | « …est **noté** R »               |
| 82  | « **Il** ne réalisent pas donc »                                      | « **Ils** ne réalisent pas donc » |
| 35  | « sous l'effet thermique qui devient **trés** important »             | « …**très** important »           |

(+ p.38 « Le courant électrique a un sens **·** . » — espace avant point, normalisé : acceptable.)

Aucune n'altère le sens ; toutes contredisent la règle de fidélité. **À porter au crédit de la fiche** :
elle **préserve** correctement d'autres fautes de la source — « montage**s** en dérivation » (p.52),
« est associé une grandeur » (p.52), la virgule fautive « ne réalisent pas donc, des relations » (p.82).
Le traitement est donc incohérent, pas systématiquement laxiste.

### D6 — 3 ajouts non imprimés (inférences présentées comme du texte source)

**(a) p.33** — fiche l.88-89 : « Questions ouvertes : eau distillée sucrée **(pas de courant détecté)** ».
La source **pose** la question et n'y **répond pas** : « …va-t-on détecter le passage d'un courant ? ».
La réponse — correcte, et confirmée ailleurs par l'exercice p.40 — est **ajoutée par la fiche**.

**(b) p.79** — fiche l.575-576 : « figures graphiques **non alignées/non linéaires selon le texte
extrait** ». **Le texte extrait ne dit rien de tel.** La p.79 ne contient **que** trois légendes
(« Caractéristique d'une lampe à incandescence » / « …d'un électrolyseur » / « …d'une diode ») et
**aucune** description d'allure. Affirmation inventée **avec faux sourcing explicite**. (L'inférence est
raisonnable — L'essentiel p.82 dit « Les dipôles n'ont pas tous des caractéristiques de même allure » —
mais elle n'est pas p.79.)

**(c) p.78** — fiche l.562-563 : « (valeur proche, non exactement 350 mA indiqué en **mise en situation**
— cohérent avec un relevé expérimental réel) ». Glose absente de la source ; de plus le « 350 mA » vient
de l'**Activité IV p.77 elle-même** (« une lampe (3,5 V- 350 mA) »), **pas** d'une mise en situation.
L'écart 350 mA nominal vs 300 mA « la lampe brille normalement » **mérite d'être signalé en
§Incertitudes**, pas justifié par une explication inventée.

---

## MINEUR

**m1 — Paginations internes fausses** (les autres sont justes) :

| Fiche                                                               | Réel                             |
| ------------------------------------------------------------------- | -------------------------------- |
| ch.2 Activité II « p.28–29 »                                        | **p.29**                         |
| ch.2 Activité IV « p.30–31 »                                        | **p.31**                         |
| ch.3 Activité II « p.46–47 »                                        | **p.47**                         |
| ch.3 « Exercices (p.54–56) »                                        | **p.54–55** (p.56 = Savoir plus) |
| ch.4 Activité II « p.60–61 »                                        | **p.61**                         |
| ch.4 « Exercices (p.68–70) »                                        | **p.68–69** (p.70 = Savoir plus) |
| ch.5 code des couleurs / « R = 220 Ω et R = 6000 Ω » **« (p.76) »** | **p.77**                         |
| ch.5 remarque corps humain « p.76–77 »                              | **p.77**                         |
| ch.5 « Exercices (p.84–86) »                                        | **p.84–85** (p.86 = Savoir plus) |
| ch.5 « synthèse (p.85–86) »                                         | **p.85**                         |

Pattern du chapeau « Exercices » : borne systématiquement étendue à la page du Savoir plus, sur les
**3** chapitres 3/4/5.

**m2 — p.66 · 2 troncatures masquant des figures dans « L'essentiel du cours » (verbatim)** :

- source « …appelé voltmètre **de symbole:** » [figure] → fiche « …appelé voltmètre. »
- source « …flèche allant de B vers A **:** » [figure] → fiche « …flèche allant de B vers A. »

Dans les deux cas : coupe + point substitué, sans ellipse ni mention que le symbole/schéma est une
figure non rendue.

**m3 — Omissions de contenu (profondeur R-5)** :

- **p.46** — généralisation officielle omise : « **Le fonctionnement d'un composant électrique dépend du
  type de branchement des constituants du circuit.** »
- **p.29** — question ouverte omise (la fiche n'en décrit qu'une des deux) : « Si, dans un circuit, on sent
  le verre d'une lampe chauffer sans pour autant la voir briller, peut-on dire si un courant passe ou non
  dans le circuit ? »
- **p.48** — question omise : « L'intensité du courant qui circule dans (L1), est elle la même que celle
  qui traverse (L2) ? »
- **p.49** — deux questions omises : « Est-il nécessaire d'utiliser entre (L1) et (L2) et entre la lampe
  (L1) et le nœud (N1) des ampèremètres ? » / « Quelle est l'intensité du courant qui circule dans les
  fils reliant (N2) à l'interrupteur et l'interrupteur au générateur ? »
- **p.63** — question omise : « Quelle propriété commune ont les tensions aux bornes des composants de
  chacune des trois mailles du montage ? »
- **p.76** — **donnée chiffrée perdue** : le calibre de l'exemple ohmmètre — « si le calibre utilisée est
  **20 kΩ** et si la valeur R à mesurer dépasse **20 kΩ**, l'appareil affiche (I .) ».
- **p.48** — citation tronquée sans ellipse : « …on a intérêt à le brancher sur le plus grand calibre. »
  omet « Il ne faut pas oublier de baisser le calibre, si possible, pour obtenir un affichage
  suffisamment précis. »
- **p.36** — étape de protocole omise : « Relier aux bornes du moteur le fil de fer. »
- **p.60 / p.62** — titres d'activités tronqués : « …suivies de la lettre V **qu'on lit sur des appareils
  électriques** ? » ; « …d'une maille **parcourue par un courant** ? ».

**m4 — p.84 · Renvoi inter-chapitre faux.** Fiche l.622-623 : « conservation du nombre d'électrons dans une
portion de conducteur — item récurrent depuis le **chapitre 3** ». L'item figure au **chapitre 2** (p.40,
ex. 3 q.4) et au ch.5 (p.84) — **pas** au ch.3, dont les items « choisir le ou les mots exacts » sont
tungstène/fer, récepteurs en dérivation, court-circuit/fusible.

**m5 — p.62-63 · Incohérence de notation de la source non signalée.** L'énoncé de l'activité V p.62 annonce
« Mesurons […] les tensions : UAB, UBC, UNP, UEF et **UPA** » ; le tableau p.63 imprime « **UAP** »
(valeur 0). Bénin (UAP = −UPA = 0), mais imprimé. La fiche retient « UAP = 0 V » (conforme au tableau)
sans signaler la divergence.

**m6 — p.70 · Coquille de la source non marquée : « William Eintroven ».** La fiche transcrit fidèlement ✅
mais ne met ni `[sic]` ni note, alors qu'elle le fait scrupuleusement pour Ohm. L'attribution du manuel
(1903, physiologue hollandais, électrocardiogramme) désigne sans ambiguïté **Willem Einthoven**
(1860-1927, Nobel 1924) : le manuel se trompe sur le prénom **et** le nom. Traitement incohérent avec
celui d'Ohm — trancher dans un sens ou dans l'autre.

**m7 — p.36 / p.80 · Titres de fiches T.P. : caractères manquants à l'extraction.**

- p.36 : « Circuit **lectrique** » (é manquant) → fiche : « Circuit électrique »
- p.80 : « LOI D**␣**OHM » (apostrophe manquante) → fiche : « Loi d'Ohm »

Les titres p.50 (« Loi des nœuds ») et p.64 (« Loi des mailles ») sortent **intacts** ⇒ **artefact
d'extraction ponctuel** (glyphes manquants d'une police décorative) bien plus probable qu'une coquille du
manuel. La fiche restitue la forme correcte — **probablement juste, mais c'est une inférence silencieuse**.
Vision p.36 + p.80 pour lever le doute (2 pages, faible coût).

---

## Figures non rendues — relevé nominatif

`pdftotext` ne rend aucune image. **10 blocs** dont le contenu pédagogique n'existe **que** dans l'image ;
**1 seul est signalé par la fiche**.

| #   | p.     | Figure                                                                                 | Bloquant ?   | Signalé par la fiche |
| --- | ------ | -------------------------------------------------------------------------------------- | ------------ | -------------------- |
| 1   | **31** | Table des symboles normalisés (12 dipôles)                                             | **OUI — M2** | ❌                   |
| 2   | **77** | 2 résistors à anneaux colorés + code des couleurs                                      | **OUI — M3** | ❌                   |
| 3   | **83** | 3 graphes de l'exercice résolu + dessin du résistor 470 Ω (rép. 4)                     | **OUI — M3** | ❌                   |
| 4   | **85** | Résistors R1/R2 à anneaux + cadran du multimètre (ex. 2)                               | **OUI — M3** | ❌                   |
| 5   | 79     | 3 courbes (lampe à incandescence, électrolyseur, diode)                                | oui          | ✅                   |
| 6   | 66     | Symbole du voltmètre + flèche UAB (L'essentiel — cf. m2)                               | non          | ❌                   |
| 7   | 77     | Symbole du rhéostat                                                                    | non          | ❌                   |
| 8   | 34     | Symbole de la diode (« Une diode est symbolisée par : »)                               | non          | ❌                   |
| 9   | 70     | 2 tracés ECG (sujet malade / sujet sain) — documentaire                                | non          | ❌                   |
| 10  | 75     | Graphe U=f(I) du potentiomètre — **données chiffrées présentes p.75 ⇒ reconstituable** | non          | ❌                   |

**Catégorie transversale non signalée** : tous les **schémas de montage** des activités et exercices
(montages (a)–(d) p.29, (a)–(g) p.46, circuits p.41, p.55, p.69, p.85, montages du rhéostat p.78…). Non
bloquants pour le texte, mais **aucun exercice de la fiche « sur schéma » n'est générable sans vision**.

**Vision ciblée recommandée, par priorité** : p.31 · p.76-77 · p.83 · p.85 (puis p.36 + p.80 pour m7).

---

## Vérifié conforme (le socle est sain)

- ✅ **Les 41 items des 4 « L'ESSENTIEL DU COURS »** : 13 (p.38) + 10 (p.52) + 12 (p.66) + 6 (p.82) —
  **tous présents, tous fidèles, dans l'ordre**. Seules réserves : D5 (2 coquilles corrigées) et m2
  (2 troncatures).
- ✅ **Les lois, verbatim conformes** : nœuds (p.49, p.52), mailles (p.63, p.66), Ohm (p.76, p.82),
  convention de sens du courant (p.32, p.38).
- ✅ **Toutes les valeurs chiffrées conformes à la source, et arithmétiquement revérifiées** :
  - p.49 : I1 = 0,90 A / I2 = 0,65 A / I3 = 0,25 A — et 0,65 + 0,25 = 0,90 ✓
  - p.51 : 30 mA / 50 mA / 100 mA ✓
  - p.61 : tableau dipôles isolés 4,4 / 0 / 0 / 0 / 0 / 9,0 / 0 / 0 ✓
  - p.62 : pile 4,50 → 4,44 · lampe 0 → 3,50 · intensité 0 → 0,3 ✓
  - p.63 : UAB 5,5 / UBC 3,5 / UNP −9,0 / UEF 9,0 / UAP 0 ✓ · oscilloscope 2 V/div, 2,2 div ✓
  - p.75 : potentiomètre U 0/2/5/8/12/15 · I 0/2,9/7,2/11,4/17,2/21,5 ✓ (et sain : ≈ 700 V·A⁻¹)
  - p.76 : dipôle (D) U 2/12/21 · I 91/545/955 · « 220 V·A⁻¹ » — **fidèlement transcrit** (mais cf. **M1**)
  - p.77 : 5000 Ω / 1000 Ω · 25 V → 25 mA · 50 V → 10 mA — **les 2 calculs de la source sont exacts** ✓
  - p.78 : rhéostat RAC 100 Ω → 40 Ω · 0,02 V / 9 mA · 3,5 V / 300 mA ✓
  - Exercices résolus : p.39 ✓ · p.53 (30 + 50 = 80) ✓ · p.67 (240 − 90 = 150 ; 6/3 = 2) ✓ ·
    p.83 (9,4 / 0,02 = 470) ✓
- ✅ **La coquille « Ohm (1745/1827) » p.82 est CONFIRMÉE IMPRIMÉE** — identique à « Volta (1745/1827) »
  p.66 (copier-coller manifeste ; dates réelles de G. S. Ohm : 1789-1854). **Ce n'est pas un artefact
  d'extraction.** Le traitement de la fiche (transcrire tel quel + signaler sans corriger) est **correct**
  et doit être conservé.
- ✅ **Libellés de rubrique** : « ACTIVITES DOCUMENTAIRE » (p.37, p.65) vs « RECHERCHE DOCUMENTAIRE »
  (p.51, p.81) — la variation est **réelle** dans le manuel ; la fiche les distingue **correctement**.
- ✅ **Couverture des exercices** : les 3 catégories × 4 chapitres sont toutes décrites, avec leurs
  énoncés et données chiffrées (lampes 3V-300mA / 1,2V-100mA / 12V-10A p.69 ; calibres 1/3/30/100 V
  p.69 ; I=1 A, I1=600 mA, I5=50 mA, I6=0,8 A p.55 ; résistor 100 Ω + lampe 6V-50mA p.85…). ✓
- ✅ **Notation** : chiffres occidentaux, équations LTR, unités SI — conforme partout, y compris la
  normalisation « 220 V·A⁻¹ » (source : « 220 V.A-1 »), légitime.
- ✅ **Droits d'auteur** : les 4 « Savoir plus » / documentaires sont **résumés**, non copiés. Conforme.

---

## Actions recommandées (par priorité)

1. **§Incertitudes — ajouter M1** (le « 220 V·A⁻¹ » p.76 incompatible d'un facteur 10 avec les I imprimées ;
   deux lectures possibles ; **ne pas arbitrer**). C'est le finding le plus coûteux s'il passe en génération.
2. **§Incertitudes — ajouter M2 + M3** (symboles normalisés p.31 ; code des couleurs p.77/83/85) et marquer
   ces chapitres **« génération partiellement bloquée sans passe vision »**.
3. **Réécrire la note D1** : re-sourcer (plan d'ouverture **p.71**, pas la table des matières), re-placer
   (**p.76-77**, pas p.79), **inverser la conclusion** (anomalie réelle du manuel très probable, artefact
   d'extraction très peu probable — 23/23 en-têtes rendus ailleurs), et corriger « 5 blocs » → **4 blocs**.
4. **Corriger les 4 bornes de titres** (D4) et **transcrire les 4 pages d'ouverture** (D2 — pré-requis +
   plan des activités ; la matière est fournie ci-dessus, prête à intégrer).
5. **Signaler les 2 divergences de titre** ch.3 et ch.5 (D3), en rapportant les deux libellés imprimés.
6. **Rétablir les 5 coquilles + `[sic]`** (D5) et **retirer les 3 ajouts non imprimés** (D6) — en
   convertissant D6(c) en une entrée §Incertitudes (350 mA nominal vs 300 mA « brille normalement », p.77-78).
7. Mineurs m1→m7 au fil de l'eau.

**Hors tranche, mais confirmé au passage** (déjà connu du cadrage, et il conditionne la revérifiabilité de
**toutes** les pages citées ci-dessus) : le bloc **« Sources »** de la fiche (l.3-8) est **faux** — codes
`222105P01`/`222105P02` et modèle « deux tomes » inexistants ; le manuel est
**`223103P00.pdf`, volume unique, 276 p.** La note « Chimie (chapitres du tome 2) hors périmètre » est
caduque : **ce manuel ne contient aucune chimie**.
