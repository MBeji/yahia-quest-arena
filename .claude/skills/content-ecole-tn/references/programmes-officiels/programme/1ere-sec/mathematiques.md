<!-- Transcription FIDÈLE du manuel élève CNP (pas de réinterprétation). Pages citées. Chiffres latins. -->

# Mathématiques — 1ère année secondaire (tronc commun) · programme officiel CNP (PILOTE)

> **Sources** :
>
> - **Manuel élève** (seule source disponible — pas de guide enseignant au corpus pour cette
>   matière/ce niveau, cf. règle « une seule source ⇒ elle fait référence », `README.md`
>   « Sources officielles combinées ») : « **Mathématiques — 1ère année de l'enseignement
>   secondaire** » (République Tunisienne, Ministère de l'Éducation, Centre National
>   Pédagogique). Auteurs : Rachid Mcharek (Inspecteur principal), Najiba Mhamdi (Inspectrice),
>   Sadok Klila (Professeur), Leïla Ben Youssef (professeur). Évaluateurs : Hikma Smida
>   (Professeur universitaire), Jaafar Ben Yazid (Inspecteur général), Slimane Hassayoun
>   (Inspecteur principal). **Conforme aux nouveaux programmes mis en place par la loi
>   d'orientation de l'éducation et de l'enseignement scolaire du 23 juillet 2002** (préface, p.3).
>   Deux tomes (pagination continue) : `222104P01.pdf` (130 p., tome 1, chapitres 1–8 :
>   Travaux géométriques) et `222104P02.pdf` (142 p., tome 2, chapitres 9–16 : Travaux
>   numériques). **Pages lues** : couverture + préface (p.1–3), sommaire complet (p.5), page
>   « Organisation des chapitres » (p.6) ; **chapitre 1 « Angles » in extenso** (p.9–22, incluant
>   « Math-Culture » p.22).
> - **Guide enseignant** : **non disponible au corpus** pour ce couple (matière/niveau) — à
>   l'inverse du primaire/collège, le corpus CNP secondaire ne contient **aucun guide
>   enseignant** pour les matières scientifiques (maths, sciences physiques). Programme
>   ministériel formel (référentiel de compétences) **non présent au corpus** — voir §6.
> - ⚠️ **Distinction importante** : `222105P00.pdf` (118 p., même dossier `eleve/`) **n'est
>   PAS** un cahier d'exercices complémentaire mais un **manuel différent** : « Mathématiques —
>   1ère année secondaire — **Section sport** » (auteurs Salah Marzougui, Habib Jouini ;
>   évaluateurs Noureddine Affi, Abdellatif Bouzidi). La section sport est **hors du périmètre
>   initial** (`docs/lycee-architecture.md` §8, trade-offs) — ce fichier n'a donc **pas été
>   exploité** ici et ne doit pas être confondu avec le manuel tronc-commun `222104P01/P02`.
>   **Transcrit le** : 2026-07-07. **Statut** : 🚧 transcription pilote (manuel élève seul —
>   périmètre = 1 chapitre transcrit en profondeur + plan annuel niveau bloc pour le reste,
>   cf. modèle `bac-math/mathematiques.md`). **Langue d'enseignement** : `fr` — **bascule ar→fr
>   à partir de la 1ère année secondaire** (le programme de mathématiques était intégralement en
>   arabe jusqu'en 9ème-base ; ce manuel est entièrement rédigé en français, notation déjà
>   standard des deux côtés — cf. §6 « pont linguistique »). **gradeSlug** : `1ere-sec`.
>   **subject id** attendu : `math-1ere-sec` (convention `<matière>-<gradeSlug>`,
>   `docs/lycee-architecture.md` §2).

## 1. Cadre & compétences

Le manuel ne tabule pas de « compétences terminales » formelles à part (pas de guide
enseignant au corpus) ; la **préface** (p.3, transcrite fidèlement) énonce les finalités
visées, conformément à la loi d'orientation du 23 juillet 2002 — l'élève doit apprendre à :

- **pratiquer une démarche mathématique** en développant sa capacité à chercher, exprimer,
  conjecturer, modéliser et raisonner ;
- **mobiliser des algorithmes et des procédures** dans des situations mathématiques ;
- **utiliser et appliquer les mathématiques** pour résoudre des problèmes dans des situations
  familières ou non familières, en rapport avec l'environnement de l'élève ;
- **communiquer oralement ou par écrit** dans un langage mathématique ;
- **utiliser les technologies de l'information et de la communication** dans son travail de
  recherche, de prospection et de contrôle, ainsi que comme moyen d'échange et de
  communication ;
- **collecter, organiser et exploiter l'information** ;
- **apprécier la contribution des mathématiques** au développement des autres disciplines, à
  la compréhension des phénomènes et à la prise de décision.

**Architecture pédagogique de chaque chapitre** (page « Organisation des chapitres », p.6,
transcrite fidèlement — structure constante du manuel, à respecter pour calibrer le
`cours.md`/les missions lors de la génération) :

- **Reprendre** — rubrique à traiter avec l'aide du professeur ; vise à consolider les acquis
  antérieurs, identifier les lacunes éventuelles, communiquer avec un vocabulaire
  mathématique en relation avec les notions du chapitre. (QCM à réponses multiples typique.)
- **Découvrir** — activités (numérotées « Activité 1, 2, 3… ») à traiter avec l'aide du
  professeur ; développent la capacité à chercher, expérimenter, modéliser, conjecturer,
  raisonner ; construisent les savoirs/savoir-faire à connaître.
- **Retenir** — les résultats/théorèmes qu'il est indispensable de connaître (encadrés,
  formulation officielle figée — à reprendre verbatim lors de la génération).
- **Mobiliser ses compétences** — « Situations » avec une « Stratégie de résolution »
  explicite (indices méthodologiques guidant la démarche, jamais la solution).
- **S'auto-évaluer** — Vrai/Faux, Observer (vrai/faux sur figure), Recopier et compléter :
  auto-évaluation rapide avant les exercices.
- **Exercices et problèmes** — deux paliers : **Maîtriser** (application directe) puis
  (chapitres suivants, non lus ici) un palier plus avancé.
- **Math-Culture** — encart culturel/historique en fin de chapitre (portrait d'un
  mathématicien/astronome, anecdote historique, lien avec le patrimoine tunisien).

## 2. Plan annuel (niveau bloc — 16 chapitres, sommaire p.5)

Le manuel est structuré en **deux grands domaines**, chacun réparti sur les deux tomes
(pagination continue 1–272 environ ; lexique final p.268) :

### Domaine : Travaux géométriques (tome 1, `222104P01.pdf`, chapitres 1–8, p.9–130)

- **Chapitre 1 — Angles** (p.9–22) — _transcrit à profondeur de génération, §2.1_
- Chapitre 2 — Théorème de Thalès et sa réciproque (p.23–36)
- Chapitre 3 — Rapports trigonométriques d'un angle aigu. Relations métriques dans un
  triangle rectangle (p.37–50)
- Chapitre 4 — Vecteurs et translations (p.51–68)
- Chapitre 5 — Somme de deux vecteurs - Vecteurs colinéaires (p.69–80)
- Chapitre 6 — Activités dans un repère (p.81–100)
- Chapitre 7 — Quart de tour (p.101–116)
- Chapitre 8 — Sections planes d'un solide (p.117–130)

### Domaine : Travaux numériques (tome 2, `222104P02.pdf`, chapitres 9–16, p.133–267)

- Chapitre 9 — Activités numériques I (p.133–152)
- Chapitre 10 — Activités numériques II (p.153–168)
- Chapitre 11 — Activités algébriques (p.169–184)
- Chapitre 12 — Fonctions linéaires (p.185–196)
- Chapitre 13 — Equations et inéquations du premier degré à une inconnue (p.197–212)
- Chapitre 14 — Fonctions affines (p.213–226)
- Chapitre 15 — Systèmes de deux équations à deux inconnues (p.227–240)
- Chapitre 16 — Exploitation de l'information (p.241–267)

**Lexique** (glossaire de fin de manuel, bilingue probable fr/ar — non ouvert dans cette
passe) : p.268.

> Nomenclature officielle confirmée par le sommaire (p.5, transcription verbatim des
> intitulés). L'ordre est celui imprimé (géométrie d'abord, puis numérique/algèbre) — à
> ne **pas** réordonner lors de la génération sans justification pédagogique explicite.

## 2.1 Chapitre 1 — Angles (p.9–22, transcrit à profondeur de génération)

- **Structure de la leçon (fidèle au découpage du manuel)** :
  - **Reprendre** (p.9) : QCM à 3 réponses (A/B/C, une ou plusieurs correctes) sur 4 figures
    de rappel — angles aigu/obtus repérés sur une figure, angles alternes-internes/
    correspondants sur deux droites sécantes à une transversale, angle adjacent/bissectrice,
    angles d'un parallélogramme (supplémentaires/correspondants/égaux). Vise à réactiver les
    notions de 9ème (angles, droites parallèles, quadrilatères).
  - **Découvrir** (p.10–13) — 12 activités guidées, réparties en 3 sous-thèmes :
    1. **« Angles et figures de base »** (Activités 1–4, p.10–11) : somme des angles d'un
       triangle et angle extérieur (Act.1 : montrer `CÂB + ÂBC = ÂCD` pour un triangle ABC
       avec D sur (BC) au-delà de C ; cas particulier équilatéral, rectangle isocèle,
       isocèle en C) ; construction de triangle connaissant deux angles et un périmètre
       (Act.2) ; angles d'un carré + triangle équilatéral accolé (Act.3, 4) — degré
       d'exigence : justification complète attendue (pas de mesure directe).
    2. **« Angles égaux et droites parallèles »** (Activités 5–9, p.11–12) : angles d'un
       triangle avec parallèle à un côté (Act.5) ; démonstration des propriétés
       angles-intérieurs supplémentaires / alternes-internes égaux / correspondants égaux
       pour deux droites parallèles coupées par une sécante, **via projeté orthogonal**
       (Act.6, 7) ; puis les **réciproques** (Act.8, 9 : si les angles alternes-internes
       (resp. correspondants) sont égaux alors les droites sont parallèles).
    3. **« Angles inscrits et angles au centre »** (Activités 10–12, p.12–13) : triangle
       inscrit dans un cercle de diamètre [AB] est rectangle (Act.10.1) ; position d'un
       point M par rapport au cercle selon que `AMB` >/</= 90° (Act.10.2–4) ; définition de
       l'angle inscrit et de l'angle au centre associé (Act.11, avec un exemple numérique
       100°/50°/50°) ; comparaison `BÂC` et `BÔC` selon la position de O par rapport au
       triangle ABC — 2 cas (Act.12).
  - **Retenir** (p.14, formulation officielle — à reprendre verbatim) :
    - « Deux droites parallèles forment avec une sécante : deux angles intérieurs d'un même
      côté supplémentaires ; deux angles alternes internes égaux ; deux angles correspondants
      égaux. »
    - Réciproques (3 énoncés séparés, un par critère : angles intérieurs supplémentaires ⇒
      parallèles ; alternes-internes égaux ⇒ parallèles ; correspondants égaux ⇒ parallèles).
    - « Si le côté [BC] d'un triangle ABC est diamètre de son cercle circonscrit alors ce
      triangle est rectangle en A. »
    - « A et B sont deux points distincts. Les points P tels que `ÂPB` = 90° sont les points
      du cercle de diamètre [AB], privé des points A et B. »
    - « Un angle inscrit dans un cercle est égal à la moitié de l'angle au centre qui
      intercepte le même arc. »
    - « Deux angles inscrits qui interceptent le même arc sont égaux. »
  - **Mobiliser ses compétences** (p.15–17) : 4 « Situations » avec stratégie de résolution
    explicite — construction au compas seul du symétrique d'un point par rapport à un point
    (Situation 1, thème « Angles et figures de base ») ; construction d'un hexagone régulier
    (Situation 2) ; comparaison d'aires de triangles via angles correspondants et parallélisme
    (thème « Angles et droites parallèles », Situation 1) ; calcul d'aire d'une terrasse
    composée d'un trapèze + 2 secteurs circulaires, avec parallélisme d'angles intérieurs
    (Situation 2, données chiffrées : 13 m, 21,6 m, 22 m, 28 m, 35 m, angles 80°/130°/50°) ;
    thème « Utiliser les angles inscrits pour comparer des grandeurs » : cordes
    perpendiculaires et angles inscrits égaux (Situation 1) ; tangentes à un cercle depuis un
    point extérieur, triangle rectangle inscriptible, bissectrice, périmètre et angle
    constants (Situation 2, cercle rayon 4 cm, OA = 5 cm).
  - **S'auto-évaluer** (p.18–19) : Vrai/Faux (loupe grossissante et mesure d'angle — piège
    classique : un angle ne se « multiplie » pas visuellement) ; Observer (juger le
    parallélisme de deux droites à partir d'angles donnés sur 3 figures : 131,2°/48,8°,
    72°/66°, 41,5°/41,5°) ; Recopier et compléter (calcul direct d'angle inscrit/au centre à
    partir d'un angle donné : 4 figures chiffrées 50°, 130°, 15°, 60°/210°).
  - **Exercices et problèmes — Maîtriser** (p.20, exercices 7–14 lus) : parallélisme de
    droites via cercles tangents (ex.7), bissectrice de l'angle extérieur et parallélisme
    (ex.8), périmètre/aire d'un cercle circonscrit à un triangle rectangle (ex.9), tangentes à
    un cercle depuis un point extérieur via cercle auxiliaire de diamètre [AB] (ex.10),
    quadrilatère médian EFGH d'un parallélogramme (ex.11), arcs isométriques et angles
    inscrits égaux (ex.12), triangle équilatéral et point sur l'arc (ex.13 — construction de
    triangle équilatéral MNC), angles inscrits sur un même cercle (ex.14, énoncé tronqué en
    fin de page — à revérifier si besoin de détail).
  - **Math-Culture** (p.22) : mesure de la circonférence terrestre par Ératosthène (méthode
    des angles alternes-internes égaux, ombre à Syène/Alexandrie, distance 800 km, angle
    7,12°) + note historique (Ératosthène, bibliothèque d'Alexandrie, « Crible
    d'Ératosthène ») + activité sur le pentagone régulier et l'étoile du drapeau tunisien
    (angle `BÂE` d'un pentagone régulier ABCDE).
- **Concepts / notions** : angle aigu/obtus, angle extérieur d'un triangle et somme des
  angles, angles alternes-internes, angles correspondants, angles intérieurs de même côté
  (supplémentaires), critères de parallélisme de deux droites (3 réciproques), triangle
  rectangle et cercle circonscrit (diamètre = hypoténuse), lieu géométrique des points voyant
  un segment sous un angle droit, angle inscrit, angle au centre, relation angle
  inscrit = angle au centre / 2, angles inscrits interceptant le même arc.
- **Vocabulaire officiel** (relevé dans le manuel) : « angle alterne-interne », « angle
  correspondant », « angles intérieurs d'un même côté », « supplémentaires », « bissectrice »,
  « angle inscrit », « angle au centre », « intercepte l'arc », « cercle circonscrit »,
  « tangente issue d'un point », « projeté orthogonal ».
- **Exemples & exercices types (manuel élève)** : voir listes détaillées ci-dessus (Activités
  1–12, Situations 1–2 ×2 thèmes, exercices Maîtriser 7–14). Valeurs numériques récurrentes :
  angles à 90°/100°/50°/72°/66°/40°/50°/80° ; périmètres/longueurs en cm et en m (contexte
  terrasse : 13 m, 21,6 m, 22 m, 28 m, 35 m).
- **Bornes de scope** :
  - ✅ **INCLUS** : consolidation des critères de parallélisme (aller ET réciproques, les 6
    énoncés) ; angle inscrit / angle au centre et leur relation (moitié) ; triangle
    rectangle ⟺ inscrit dans un cercle de diamètre l'hypoténuse ; constructions au compas
    seul (symétrie centrale, hexagone régulier) ; raisonnement démonstratif complet
    (justifications rédigées, pas de mesure au rapporteur comme preuve) ; tangentes à un
    cercle depuis un point extérieur (égalité des deux longueurs tangentes — réutilisé, revu
    en détail probablement au chapitre 3 trigonométrie).
  - ⛔ **EXCLU (relève d'un autre chapitre/niveau)** : rapports trigonométriques dans le
    triangle rectangle (chapitre 3, à venir) ; vecteurs et translations (chapitres 4–5) ;
    repérage/coordonnées (chapitre 6) ; rotations autres que le quart de tour (chapitre 7,
    lui-même limité au quart de tour — pas de rotation d'angle quelconque en 1ère sec) ;
    trigonométrie du cercle (hors-programme secondaire 1ère année).

## 3. Notes pédagogiques / méthode

Démarche constante du manuel (cf. §1 « Organisation des chapitres ») : **Reprendre**
(réactivation) → **Découvrir** (activités guidées, construction du savoir) → **Retenir**
(formalisation, encadrés à mémoriser tels quels) → **Mobiliser ses compétences** (situations
avec stratégie de résolution explicitée, jamais la solution) → **S'auto-évaluer** (contrôle
rapide) → **Exercices et problèmes** (paliers Maîtriser puis plus avancé) → **Math-Culture**
(ouverture historique/culturelle). Notation standard LTR, chiffres latins, angles notés avec
chapeau (`Â`, `AÔB`). Rigueur de rédaction attendue dès la 1ère sec (« montrer que »,
« justifier ») — registre plus exigeant qu'en 9ème mais construit sur les mêmes objets
(angles, triangles, cercles) déjà connus. Piège pédagogique explicite illustré par le
manuel lui-même (S'auto-évaluer, Vrai/Faux p.18) : un angle **ne se multiplie pas** quand on
le regarde à la loupe — rappel que la mesure d'un angle est indépendante de l'échelle du
dessin, seulement de l'écartement des côtés.

## 4. Chapitrage retenu (→ alimente `manifest/1ere-sec.json`)

| #   | slug                          | notion                                                                           | manuel élève (code · pages) |
| --- | ----------------------------- | -------------------------------------------------------------------------------- | --------------------------- |
| 1   | `01-angles`                   | Angles                                                                           | `222104P01` · p.9–22        |
| 2   | `02-thales`                   | Théorème de Thalès et sa réciproque                                              | `222104P01` · p.23–36       |
| 3   | `03-trigonometrie-triangle`   | Rapports trigonométriques d'un angle aigu — relations métriques (triangle rect.) | `222104P01` · p.37–50       |
| 4   | `04-vecteurs-translations`    | Vecteurs et translations                                                         | `222104P01` · p.51–68       |
| 5   | `05-somme-vecteurs`           | Somme de deux vecteurs — vecteurs colinéaires                                    | `222104P01` · p.69–80       |
| 6   | `06-repere`                   | Activités dans un repère                                                         | `222104P01` · p.81–100      |
| 7   | `07-quart-de-tour`            | Quart de tour                                                                    | `222104P01` · p.101–116     |
| 8   | `08-sections-planes`          | Sections planes d'un solide                                                      | `222104P01` · p.117–130     |
| 9   | `09-activites-numeriques-1`   | Activités numériques I                                                           | `222104P02` · p.133–152     |
| 10  | `10-activites-numeriques-2`   | Activités numériques II                                                          | `222104P02` · p.153–168     |
| 11  | `11-activites-algebriques`    | Activités algébriques                                                            | `222104P02` · p.169–184     |
| 12  | `12-fonctions-lineaires`      | Fonctions linéaires                                                              | `222104P02` · p.185–196     |
| 13  | `13-equations-inequations`    | Équations et inéquations du premier degré à une inconnue                         | `222104P02` · p.197–212     |
| 14  | `14-fonctions-affines`        | Fonctions affines                                                                | `222104P02` · p.213–226     |
| 15  | `15-systemes-equations`       | Systèmes de deux équations à deux inconnues                                      | `222104P02` · p.227–240     |
| 16  | `16-exploitation-information` | Exploitation de l'information                                                    | `222104P02` · p.241–267     |

> Seul le **chapitre 1** a été transcrit à profondeur de génération (§2.1) ; les chapitres 2–16
> ne portent, pour l'instant, que le titre officiel + la pagination (niveau bloc, §2). Le
> `manifest/1ere-sec.json` du pilote ne codifie donc, par prudence, **aucun chapitre** pour
> `math-1ere-sec` (`chapters: []`) — le codifier chapitre par chapitre au fur et à mesure des
> transcriptions futures, comme l'exige `README.md` §« Manifeste ».

## 5. Sources croisées

- **Manuel élève** : `222104P01` (tome 1, 130 p.) + `222104P02` (tome 2, 142 p.) — «
  Mathématiques — 1ère année de l'enseignement secondaire » (CNP). **Seule source
  disponible et donc source de référence** pour ce couple (matière/niveau) — pas de guide
  enseignant au corpus secondaire pour les matières scientifiques (règle README « une seule
  source ⇒ elle fait référence »).
- **Guide enseignant** : absent du corpus (`cnp-officiel/manuels/secondaire/c1/enseignant/`
  ne contient aucun fichier de code `222…`, vérifié par le listing du dossier `eleve/`
  fourni — aucun homologue `enseignant/` de code `2221xx`/`2224xx` n'a été localisé lors de
  cette passe). À rechercher/compléter si le corpus est enrichi.
- **Programme ministériel formel** (référentiel de compétences par cycle, loi du 23 juillet 2002) : cité en préface mais **texte intégral non présent au corpus** — cf. incertitudes §6.
- **Manuel « Section sport »** (`222105P00`) : exploré en couverture seulement — confirmé
  hors-périmètre (matière identique mais section différente, non ciblée par ce pilote).
- **Taybah** : aucune transcription école pour le secondaire (couverture Taybah = primaire
  seulement, `README.md` §« Fichiers école ») — pas de vérification croisée possible ici.
- **Divergences signalées** : aucune (source unique).

## 6. Incertitudes / à revérifier

- **Absence de guide enseignant** : contrairement au primaire/collège, aucun guide
  méthodologique n'a été localisé pour les mathématiques secondaires au corpus. Les
  « compétences terminales » officielles formelles (référentiel de la loi de 2002) ne sont
  donc **pas** transcrites ici — seule la préface du manuel élève (résumé des finalités) en
  tient lieu. À compléter si un guide ou le texte du programme ministériel est ajouté au
  corpus.
- **`222105P00.pdf` (section sport)** : n'a été ouvert qu'en page de couverture pour confirmer
  sa nature (identification du titre exact) — son contenu mathématique n'a **pas** été
  comparé à celui du tronc commun ; à explorer séparément si la section sport est un jour
  mise au périmètre.
- **Chapitres 2–16** : transcrits au **niveau bloc** uniquement (titre + pagination officielle
  du sommaire p.5) — profondeur de contenu (objectifs, notions, exemples/exercices détaillés)
  **non lue** dans cette passe (hors périmètre du pilote, cf. brief). Prochaine session de
  persistance : approfondir chapitre par chapitre au fur et à mesure de la génération réelle
  (station L2), en respectant la règle « ne pas double-scanner » (`README.md` §Recette,
  étape 2) — sauf si la persistance doit précéder de nouveau, auquel cas relire ce fichier
  d'abord.
- **Lexique final (p.268)** : non ouvert — pourrait contenir un glossaire fr/ar utile au
  **pont linguistique** (`docs/lycee-architecture.md` §4) ; à vérifier lors d'une passe
  ultérieure, pourrait éviter de reconstruire le lexique de transition depuis zéro.
- **Pont linguistique (ar→fr)** : ce fichier ne produit **pas** le lexique de transition
  fr↔ar (hors scope de la couche persistance, cf. brief) — mais signale les termes
  techniques nouveaux/rebasculés observés au chapitre 1 qui mériteront un glossage en
  `cours.md` lors de la génération : « angle alterne-interne » (زاوية متبادلة داخلية),
  « angle correspondant » (زاوية مماثلة), « angle inscrit » (زاوية محاطة/منقوشة),
  « angle au centre » (زاوية مركزية), « cercle circonscrit » (الدائرة المحيطة),
  « tangente » (المماس), « bissectrice » (منصف الزاوية) — la notation elle-même (chiffres,
  écriture des angles `Â`, `AÔB`) ne change pas entre les deux langues, seule la terminologie
  change (payoff attendu de `math-and-notation.md`).
- **Numérotation `222105P00`** : le code (`2`=secondaire, `22`=maths-fr, `1`=classe 1ère,
  `05`=variante) suggère une **variante de programme** (section sport) plutôt qu'un cahier
  d'exercices — cohérent avec le contenu observé en page de titre, mais la nomenclature
  précise du 5ᵉ chiffre n'est pas documentée dans `README.md` (qui ne détaille que les 4
  premiers chiffres) : à confirmer si besoin exact.
