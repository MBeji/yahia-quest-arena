# Physique (sciences physiques) — 1ère année secondaire (tronc commun) · programme officiel CNP

> **Sources** :
>
> - **Guide enseignant** (programme) : **aucun au corpus** pour ce couple (niveau, matière). Le dossier
>   `cnp-officiel/manuels/secondaire/c1/` ne contient **que** `eleve/` — **vérifié le 2026-07-17** (il n'y a
>   aucun guide du secondaire dans le corpus téléchargé). **⇒ Le manuel élève fait référence** (règle
>   « une seule source disponible ⇒ elle fait référence », [`README`](../README.md)) — situation de **toutes**
>   les fiches `1ere-sec` (mathematiques, svt, chimie, francais, anglais).
> - **Manuel élève** (source unique, donc source de scope **et** de contenu) : **`223103P00.pdf`**
>   (`cnp-officiel/manuels/secondaire/c1/eleve/`) — « **PHYSIQUE — 1ère Année de l'enseignement secondaire** »
>   (République Tunisienne, Ministère de l'Éducation, Centre National Pédagogique). **276 pages, VOLUME
>   UNIQUE.** **Pages lues : 1–276 (intégralité).**
>   Auteurs : **Limam Moncef** (Inspecteur) · **Mimouni Slaheddine** (Inspecteur) · **Boudriga Imed**
>   (Conseiller pédagogique) · **Sridi Thouraya** (Professeur Principal). Évaluateurs : **Daoud Ftouh**
>   (Inspecteur Général de l'Éducation) · **Gharbi Abdelhafidh** (Professeur Universitaire) ·
>   **Mandhouj Salem** (Inspecteur Principal). « © Tous **droit** [sic] réservés au Centre National
>   Pédagogique » (p.2).
>   **Titre imprimé** : la couverture imprime « **PHYSIQUE** » — « Sciences Physiques » est le nom de la
>   matière (et de ce fichier), pas celui de l'ouvrage.
> - **Non transcrit — hors périmètre** : `224101P00.pdf` (« Chimie », 160 p.) est un **manuel distinct**,
>   déjà couvert par [`chimie.md`](./chimie.md). **Ce manuel-ci ne contient aucune chimie** (voir §5).
>
> **Transcrit le** : 2026-07-08 (ch.2–17) · **complété le 2026-07-17** (ch.1 + liminaires + gabarit §1–§6).
> **Statut** : transcription fidèle, **profondeur de génération** — les **17 chapitres** des **6 thèmes** y
> sont, chaque activité / manipulation / exercice décrit individuellement avec ses données chiffrées, et les
> encadrés « L'ESSENTIEL DU COURS » **verbatim**.
>
> **Langue d'enseignement** : **`fr`** — **constatée sur la source** : le manuel est **intégralement rédigé en
> français**, de la couverture à la p.274 (le titre arabe « فيزياء » du `CATALOGUE.md` est un libellé de
> catalogue, pas la langue de l'ouvrage). ✅ **Conforme** à `docs/lycee-architecture.md` §4, qui prévoit les
> matières scientifiques en `fr` à partir de la 1ère sec (bascule ar→fr après la 9ème) : **aucune divergence
> à arbitrer**.
> **gradeSlug** : `1ere-sec`. **subject id attendu** : **`physique-1ere-sec`** (convention
> `<matière>-<gradeSlug>`, `docs/lycee-architecture.md` §2 — **pas** `sciences-physiques-1ere-sec`).
>
> **Méthode d'obtention du texte (traçabilité)** : ce PDF porte une **couche-texte propre** → extraction
> **déterministe** `pdftotext -layout` vers `cnp-officiel/_txt/223103P00-physique.txt` (**276 sauts de page =
> 276 pages `pdfinfo`, aucune troncature** ; 529 556 octets ; SHA256
> `2b80954ad1030c74d852f41ca8c6eca35f6471e4c534a5566d44b7a558a9f55c` ; UTF-8 strict, CRLF). **0 OCR, 0 clé
> API** — le corpus n'en a pas eu besoin ici. Les passes **vision** (rastérisation `pdftocairo`/`pdftoppm` →
> lecture par l'agent) n'ont servi qu'à lever des points que le texte seul ne pouvait pas trancher : elles
> sont **nommées à l'endroit où elles ont servi** et récapitulées en §6.
>
> **R-7 — relecture de fidélité indépendante : ✅ EFFECTUÉE le 2026-07-17.** Périmètre **exact** de
> l'attestation, à ne pas élargir en le citant :
>
> - **Ce qui a été relu contre la source** : **les ch.2–17 (p.25–276), en totalité**, par **5 agents à contexte
>   vierge**, un par tranche (p.25–86 · 87–146 · 147–208 · 209–242 · 243–276), chacun lisant sa tranche
>   **intégralement** dans la couche-texte déterministe + des passes vision ciblées (~25 pages au total).
> - **Ce qui n'a PAS été relu** : le **ch.1 + les liminaires (p.1–24)**, qui ne sont **pas** une relecture mais une
>   **transcription neuve** du 2026-07-17 (le ch.1 était purement et simplement **absent** de la fiche pilote).
>   Son auteur a relu les **24/24 pages en vision** et n'a laissé aucun `[?]`, mais **aucun second agent ne l'a
>   collationnée** : le §2.1 est du **contenu neuf non contre-vérifié**, pas du contenu R-7.
>
> **Verdict des 5 tranches — le socle normatif est sain** : les **16 encadrés « L'ESSENTIEL DU COURS » des
> ch.2–17 sont verbatim exacts, collationnés puce à puce** (155 items : 41 + 36 + 32 + 23 + 23) — le 17ᵉ (ch.1,
> p.20, 12 puces) vient de la transcription neuve et n'entre pas dans ce décompte. **Toutes les valeurs chiffrées
> relevées sont conformes à la source et ont été arithmétiquement revérifiées ; aucune valeur inventée, aucune
> valeur devinée sur un graphique.** Les écarts trouvés étaient de trois ordres : (a) des **inventions** (réponses
> fabriquées sur des exercices que le manuel ne corrige pas, termes hors-manuel) — **retirées ici** ; (b) des
> **coquilles de la source corrigées en silence** dans des citations données pour verbatim — **rétablies +
> `[sic]` ici** ; (c) des **incohérences de la source jamais signalées** — **portées en §6, non arbitrées**.
>
> **Ce que R-7 n'a PAS couvert (à charge, honnêtement)** : le **§3 « Notes pédagogiques » n'a pas été audité** ·
> le **§2.1 (ch.1) n'a pas de relecture indépendante** (ci-dessus) · les **figures listées en §6.2 restent non
> levées** (~45 documents bloquants ; seule une vingtaine de pages ont été ouvertes en vision) · la **notation
> vectorielle des ch.11–13 est reconstruite, non vérifiée** (§6.2) · la lecture de **`35.10²⁰` (p.169) reste
> ouverte**. **Aucune de ces réserves n'invalide le socle** ; toutes bornent son usage.
> **Limite structurelle, à connaître** : `pdftotext` **ne rend aucune figure** — et, preuve faite (p.247), il
> **perd aussi le texte incrusté dans les images** (légendes). « Complet » ne vaut donc que pour le texte de
> flux, jamais pour les documents. Les documents dont le contenu n'existe **que** dans l'image sont
> **signalés, jamais reconstitués** : leur relevé est en **§6.2 — c'est la borne d'usage de cette fiche.**

---

## 1. Cadre & compétences

> ⚠️ **Borne de la source.** Le **référentiel officiel de compétences** (objectifs généraux, bornes de scope
> du programme) est porté par le **guide enseignant**, **absent du corpus** pour ce couple. Cette section
> transcrit donc **ce que le manuel élève déclare de lui-même** (son Avant-Propos, p.3) et **rien d'autre** :
> aucune compétence n'est déduite, extrapolée ni empruntée à un autre niveau.

**Conformité déclarée** (p.3, verbatim) : « Ce manuel est destiné aux élèves de première année de
l'enseignement secondaire. **Il est conforme au programme officiel.** » Le manuel se dit conforme au
programme **sans le reproduire** — le texte officiel du programme n'est donc **pas** transcrit ici (cf. §6.0).

**Les quatre compétences visées** (p.3, verbatim — « Le contenu et l'approche adoptée visent à développer
chez l'élève un certain nombre de compétences ») :

- « expérimenter ; »
- « conceptualiser ; »
- « communiquer ; »
- « **resoudre** [sic] des problèmes. » _(sans accent dans la source)_

**La démarche officielle** (p.3, verbatim) : « Dans le souci d'impliquer l'élève dans l'appropriation du
savoir et de développer ses capacités à apporter des réponses à des situations problèmes, le cheminement
adopté vise à favoriser une **investigation spontanée** suivie d'une **investigation réfléchie** qui conduit à
une **structuration des apprentissages**. »

**Le gabarit officiel d'un chapitre** (p.3, verbatim condensé — « Chaque chapitre comporte : »). C'est **la
clé de lecture de tout le manuel** : les 17 chapitres le suivent sans exception, et le §2 en reprend l'ordre.

| Rubrique imprimée                  | Fonction déclarée par l'Avant-Propos (verbatim)                                                                                                                                                                   |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| « activités de mise en situation » | « permet, suite à des observations, de faire émerger un questionnement qui cadre la (les) situation(s) problème(s) » ; vise « une **curiosité formative** face à son environnement »                              |
| « activités expérimentales »       | « expérimentation, observation, collecte de données ou d'informations, traitement des données » + « des **questions (en italiques)** posées à la fin de certaines activités visant une **évaluation formative** » |
| « fiche T.P »                      | « mettre l'élève en contact avec une activité expérimentale **de recherche ou de réalisation d'un projet** »                                                                                                      |
| « recherche documentaire »         | « collecte des informations […] à partir d'un document écrit ou photographié suivie d'une synthèse » ; « exploiter une publication scientifique et **porter un jugement à son égard** »                           |
| « l'essentiel du cours »           | « un résumé »                                                                                                                                                                                                     |
| renvois à des « sites Internet »   | « habituer l'élève à utiliser l'Internet en vue de cherche [sic] une information » _(imprimé « APERCU HISTORIQUE » sur la page — cf. §6.3)_                                                                       |
| « exercice résolu »                | « acquérir une **méthode de résolution** des problèmes »                                                                                                                                                          |
| « série d'exercices »              | **trois catégories** : « de vérifier s'il a compris » · « d'utiliser ses acquis dans des situations simples » · « d'utiliser ses acquis pour une synthèse en assurant un certain degré d'intégration »            |
| « savoir plus »                    | « une ouverture montrant le rôle que jouent les sciences et leurs utilisations dans les activités humaines **en relation avec l'environnement** »                                                                 |

**Trois logos récurrents** structurent chaque activité expérimentale (nommés p.6, « Pour une utilisation aisée
de Votre manuel ») : **« expérimentons »**, **« observons »**, **« tirons les résultats »** — soit le triptyque
_protocole → observation → conclusion_ qu'on retrouve dans les 17 chapitres.

---

## 2. Plan annuel (structure officielle du manuel)

> **Source unique = le manuel** : il n'y a **pas** de plan annuel officiel (guide enseignant absent). La
> progression ci-dessous est **celle du manuel**, dans son ordre imprimé. Aucun séquençage trimestriel n'est
> disponible pour ce niveau (Taybah ne couvre que le primaire) — **le manuel n'en donne aucun** : il
> n'imprime ni trimestres, ni volume horaire, ni répartition.

**6 thèmes · 17 chapitres · p.9–274.** ⚠️ **Point de lecture décisif** : le manuel **numérote les chapitres
par thème, en chiffres romains** — il y a **six « CHAPITRE I »** dans l'ouvrage (un par thème), et **jamais**
de numérotation de 1 à 17. La numérotation continue **1–17 employée ci-dessous est une convention interne à
cette fiche** : elle n'est imprimée nulle part. **Citer les pages, jamais « le chapitre 15 ».**

| Thème imprimé     | Chapitres (convention fiche) | Désignation imprimée | Pages     |
| ----------------- | ---------------------------- | -------------------- | --------- |
| **L'ELECTRICITE** | 1 → 5                        | CHAPITRE I → V       | p.9–86    |
| **LA MATIERE**    | 6 → 9                        | CHAPITRE I → IV      | p.87–146  |
| **LA MECANIQUE**  | 10 → 13                      | CHAPITRE I → IV      | p.147–208 |
| **L'ENERGIE**     | 14                           | CHAPITRE I           | p.209–226 |
| **ASTRONOMIE**    | 15                           | CHAPITRE I           | p.227–242 |
| **L'OPTIQUE**     | 16 → 17                      | CHAPITRE I → II      | p.243–274 |

**Bornes d'un chapitre — convention retenue et vérifiée** : **[page d'ouverture → page « SAVOIR PLUS »]**.
Contrôle déterministe (2026-07-17) : le manuel imprime **17 pages d'ouverture** (motif `CHAPITRE <romain>`) et
**17 pages « SAVOIR PLUS »**, qui s'apparient **sans trou ni recouvrement** — la structure est parfaitement
régulière, il n'y a **aucune « transition d'imprimerie »**. Les bornes du §4 en découlent.

> ⚠️ **Correction appliquée le 2026-07-17.** Les titres de section des **ch.2–14** annonçaient des bornes
> **décalées de +1** (ex. « ch.2 : p.26–43 »), parce que la transcription pilote avait suivi le **sommaire
> p.4–5**, dont la première colonne est « Activités de mise en situation » et qui **ne référence jamais la
> page d'ouverture**. Conséquence **matérielle** (et non cosmétique) : les pages d'ouverture des ch.2–10 et 14
> — qui portent le **« Plan des activités expérimentales »** et les **« Pré-requis »**, exigés par R-5 —
> n'étaient transcrites nulle part. **Les bornes sont rectifiées et les 10 pages d'ouverture manquantes sont
> ajoutées** ci-dessous. Les ch.15, 16 et 17 étaient déjà bornés correctement.

### Liminaires (p.1–8) — hors chapitres

- **p.1** — Couverture / page de titre (auteurs et évaluateurs : cf. en-tête). Aucun libellé arabe.
- **p.2** — Copyright : « © Tous **droit** [sic] réservés au Centre National Pédagogique ».
- **p.3** — **Avant-Propos** (signé « Les Auteurs ») → transcrit au **§1**.
- **p.4–5** — **Sommaire** : un tableau unique imprimé **tourné à 90°** ; colonnes = les 9 rubriques du
  gabarit, lignes = les 17 chapitres groupés en 6 thèmes. ⚠️ Le sommaire porte **au moins deux renvois faux**
  et **deux titres divergents** de ceux des pages d'ouverture — cf. §6.3.
- **p.6–7** — **« Pour une utilisation aisée de Votre manuel »** : double page de vignettes annotées, sans
  texte de cours. Nomme les trois logos (« expérimentons », « observons », « tirons les résultats ») et les
  rubriques. Fait notable : les vignettes sont majoritairement des **pages du chapitre 1 lui-même** (p.9, 19,
  20, 21, 22, 24) — le ch.1 sert de chapitre-étalon au mode d'emploi. Coquille : « **Excercices** [sic]
  d'évaluation » (p.7) ; « Activités de mise en **situations** » (p.6, au pluriel, contre le singulier partout
  ailleurs).
- **p.8** — **« NAVIGUER SUR L'INTERNET »** : ⚠️ page **globale au manuel** (et non propre à l'électricité) —
  elle liste des URL pour **les six thèmes** : ELECTRICITE (5), MATIERE (4), MECANIQUE (4 — dont **deux
  strictement identiques**, cf. §6.3), ENERGIE (3), ASTRONOMIE (4), OPTIQUE (4). Elle **ne remplace pas** les
  renvois « Naviguer sur l'Internet » de chaque chapitre, qui s'impriment sous le titre « APERCU HISTORIQUE ».

---

## 2.1 Physique — Chapitre 1 : Le phénomène d'électrisation (p.9–24, transcrit à profondeur de génération)

**Désignation imprimée (p.9)** : bandeau « **CHAPITRE I** » · thème « **L'ELECTRICITE** » · titre
« **LE PHENOMENE D'ELECTRISATION** ». **Titre au sommaire (p.4)** : « Le phénomène d'électrisation » —
**concordant** (à la casse près) ; ce chapitre ne présente **pas** la divergence sommaire/ouverture qui
affecte les ch.3 et ch.5 (§6.3).

- **Page d'ouverture** (p.9) — imprime deux blocs et rien d'autre (aucune photo) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Mise en évidence du phénomène
    d'électrisation » · « • Activités(II) : Les deux types de charges électriques » · « • Activités(III) :
    Autres modes d'électrisation » · « • Activités(IV) : Interprétation du phénomène d'électrisation » ·
    « • Activités(V) : Corps conducteurs et corps isolants » · « • Activités(VI) : Décharge électrique » ·
    « • Activités(VII) : Effet de pointe ».
  - **Pré-requis** (verbatim) : « Sens des mots suivants: • Eclair • Tonnerre • Foudre ». ⇒ Prérequis
    **lexical uniquement** : le chapitre ne suppose **aucun acquis d'électricité**. C'est le chapitre
    d'entrée du manuel.
  - _Note de lecture (dispositif éditorial, pas une incohérence)_ : le plan p.9 donne des intitulés
    **thématiques**, tandis que chaque activité s'imprime en tête de page sous forme de **question
    directrice**. Les deux libellés sont donnés ci-dessous. Ce parti-pris est constant dans les 17 chapitres.

- **Structure de la leçon** :

  - **Activités de mise en situation** (p.10–11) : quatre mises en situation, chacune une **photographie** +
    un encadré de questions ouvertes (**aucune réponse n'est donnée dans le manuel**).

    1. **Le peigne et les cheveux** (p.10, photo : fillette brossant ses cheveux, mèches dressées vers la
       brosse) — 4 questions : « 1/- Pourquoi des cheveux secs brossés avec un peigne en matière plastique se
       dressent-ils ? » ; « 2/- Comment expliquer le fait que les cheveux sont attirés par le peigne ? » ;
       « 3/- Pourquoi nos ancêtres se brossent-ils avec des peignes en bois ? » _(présent de l'indicatif pour
       une pratique passée — reproduit tel quel)_ ; « 4/- Quel genre de peigne choisissez-vous pour vous
       brosser ? »
    2. **La poignée de voiture** (p.10, photo : fillette à la portière d'une voiture rouge, la mère à
       l'intérieur) — énoncé : « En ouvrant la porte de la voiture, pour embrasser sa maman qui rentre après
       une course par temps sec et ensoleillé, la petite fille a senti une décharge électrique. » Puis :
       « 1/- Comment expliquer l'électrisation de la poignée de la voiture ? » ; « 2/- Quelle solution
       proposez-vous pour : - décharger la carrosserie de la voiture ? - ne pas subir l'effet de la décharge
       en ouvrant la porte de la voiture ? » ; « 3/- La décharge qu'on peut ressentir, lors du contact avec un
       corps électrisé, peut-elle présenter un danger ? »
    3. **L'orage** (p.11, photo : éclair ramifié frappant une crête) — 4 questions : « 1/- Qu'est-ce qu'un
       éclair ? » ; « 2/- Qu'est-ce qu'une foudre ? » ; « 3/- L'éclair, la foudre et le tonnerre sont-ils
       dangereux ? » ; « 4/- Qu'est-ce qu'un paratonnerre ( ou parafoudre) et comment fonctionne-t-il ? »
       (⇒ reprise directe des trois pré-requis lexicaux de la p.9 ; les réponses sont au « Savoir plus » p.24).
    4. **La peinture électrostatique** (p.11, photo : chaîne industrielle de peinture d'une carrosserie) —
       2 questions : « 1/- Qu'est-ce qu'une peinture électrostatique ? » ; « 2/- Les gouttelettes de peinture
       éjectées par le pistolet sont attirées par la carrosserie de la voiture. Quels sont les avantages d'une
       telle technique ? »

  - **Activités expérimentales** (p.12–17) — **7 blocs**, précédés d'une **consigne générale imprimée en tête
    de rubrique (p.12)** : « **Toutes les expériences sont à réaliser dans une atmosphère sèche.** »

    1. **Activité I — plan : « Mise en évidence du phénomène d'électrisation » / titre imprimé : « Comment
       mettre en évidence le phénomène d'électrisation ? »** (p.12) :
       _Dispositif_ — définition officielle du **pendule électrostatique** : « une boule très légère en
       polystyrène recouverte d'une feuille très fine en aluminium et suspendue à un fil en soie (dispositif
       appelé pendule électrostatique) ».
       _Protocole et observations_ — (a) une règle en plexiglas approchée de la boule : « La règle n'a aucune
       action sur la boule. » ; (b) « La même règle frottée avec un tissu en laine est approchée du pendule
       électrostatique **sans toucher la boule** » : « La règle attire la boule. »
       _Extension_ : « Des expériences analogues aux précédentes, réalisées avec des bâtons en verre puis en
       cuivre muni d'un manche en bois…, donnent les mêmes observations faites avec la règle en plexiglas. »
       _Conclusion_ : « Le frottement a modifié les propriétés de la surface de la règle : elle est devenue
       capable d'attirer les corps légers. On dit qu'elle est **électrisée** ou **chargée d'électricité**. »
       **Généralisation officielle** (encadré) : « Des matériaux tels que le verre, le plexiglas, le
       plastique, le caoutchouc synthétique, les métaux, la laine, les tissus synthétiques… sont susceptibles
       d'être électrisés par frottement. »

    2. **Activité II — plan : « Les deux types de charges électriques » / titre imprimé : « Quels sont les
       deux types de charges électriques ? »** (p.12–13) :
       _Protocole_ — « Frottons deux bâtons en verre (V), deux bâtons en plexiglas (P) et deux bâtons en P.V.C
       avec des tissus en laine et vérifions à l'aide d'un pendule électrique qu'ils sont électrisés. Plaçons
       les, deux à deux, sur des supports mobiles autour d'un axe vertical et notons dans un tableau les
       observations. » Trois séries photographiées, légendes verbatim : « Libérons simultanément les deux
       bâtons en verre » · « Libérons simultanément le bâton en verre et le bâton en P.V.C » · « Libérons
       simultanément le bâton en verre et le bâton en plexiglas ».
       _Tableau officiel_ (p.13, **reproduit tel qu'imprimé — les « ? » sont bien dans le manuel : c'est un
       tableau à compléter par l'élève**, confirmé en vision) :

       |               | Verre (V)  | P.V.C      | Plexiglas(P) |
       | ------------- | ---------- | ---------- | ------------ |
       | Verre (V)     | Répulsion  | Attraction | Répulsion    |
       | P.V.C         | Attraction | ?          | ?            |
       | Plexiglas (P) | répulsion  | ?          | ?            |

       _(la casse est celle du manuel : « Répulsion » capitalisé partout sauf « répulsion » en
       Plexiglas × Verre — simple irrégularité, aucune ambiguïté de sens.)_
       _Consigne_ : « Prévoir et vérifier par l'expérience ce qui se passe lorsqu'on approche un bâton en
       P.V.C d'un bâton en plexiglas, un bâton en plexiglas d'un autre bâton en plexiglas et un bâton en P.V.C
       d'un autre bâton en P.V.C. »
       _Résultats_ : « Entre deux corps électrisés se manifestent des actions mutuelles, appelées
       **interaction**. » ; « Dans certains cas, cette interaction est une **répulsion** : les corps électrisés
       se repoussent mutuellement. » ; « Dans d'autres cas cette interaction est une **attraction** : les corps
       électrisés s'attirent mutuellement. »
       _Convention de signe (officielle, référencée au verre)_ : « Vis-à-vis du verre électrisé par frottement
       contre une étoffe en laine, les corps électrisés n'ont pas tous le même comportement : - une famille de
       corps électrisés **repoussent** le verre. On convient d'attribuer le signe **(+)** à la charge
       électrique que portent ces corps (ce type d'électricité s'appelait au **XVIII siècle** [sic] :
       **électricité vitrée**). - une famille de corps électrisés **attirent** le verre. On convient
       d'attribuer le signe **(-)** à la charge électrique que portent ces corps (ce type d'électricité
       s'appelait au XVIII siècle: **électricité résineuse**). »
       **Généralisation officielle** (encadré) : « Deux corps chargés d'électricité de même signe se
       repoussent. / Deux corps chargés d'électricité de signes **contaires** [sic] s'attirent. »
       ⚠️ La coquille « contaires » est **dans un encadré normatif** ; l'orthographe correcte figure au même
       endroit dans « L'essentiel du cours » p.20 (« signes contraires »). Le manuel imprime donc les deux
       formes — **signalé, non arbitré** (§6.3).

    3. **Activité III — plan : « Autres modes d'électrisation » / titre imprimé : « Y a-t-il d'autres modes
       d'électrisation ? »** (p.13–14) — **deux volets** :
       - _Volet contact_ : « Approchons une règle en plexiglas, électrisée par frottement avec un tissu en
         laine, de la boule d'un pendule électrostatique initialement non électrisée. » → « La boule est
         attirée par la règle jusqu'à venir la toucher. Juste après le contact, la boule est repoussée. »
         Répétition avec **une règle en P.V.C** électrisée par frottement → observation **identique** (même
         phrase imprimée). _Interprétation_ : après contact avec la règle en plexiglas électrisée
         **positivement**, répulsion ⇒ la boule porte une charge **(+)** ; après contact avec la règle en P.V.C
         électrisée **négativement**, répulsion ⇒ la boule porte une charge **(-)**.
         **Généralisation officielle** (encadré) : « Lors d'un contact avec un corps électrisé un deuxième
         corps est susceptible de devenir électrisé. Il s'agit d'un autre mode d'électrisation :
         **électrisation par contact**. / Le corps électrisé par contact devient porteur de charges de même
         signe que le corps électrisant. »
       - _Volet influence + introduction de l'électroscope_ (p.14) : « Approchons du dispositif ci-contre, un
         bâton en verre électrisé par frottement avec un tissu en laine. » → « **L'aiguille de l'appareil
         dévie.** » _Interprétation_ : « La répulsion entre la tige et l'aiguille montre que les propriétés
         électriques de l'appareil ont changé. On dit que l'appareil est devenu **électrisé par influence**. » ;
         « L'appareil permet de nous renseigner si un corps qui lui est approché est électrisé ou non. Pour
         cette raison il est appelé **électroscope**. »
         ⚠️ Le « dispositif ci-contre » n'est **identifié que par la photographie** (boîtier vitré à cadre
         métallique, tige et aiguille mobile) : le texte ne le nomme qu'**après** l'expérience. L'appareil est
         ici **à aiguille** ; l'exercice de synthèse p.23 en utilise une variante **à feuilles** — le manuel
         emploie « électroscope » pour les deux sans le signaler (§6.3).

    4. **Activité IV — plan : « Interprétation du phénomène d'électrisation » / titre imprimé : « Comment
       interpréter le phénomène d'électrisation ? »** (p.14–15) :
       _Trois expériences en cascade, toutes sur le même bâton en plexiglas électrisé par frottement à la
       laine puis placé sur un pivot vertical_ :
       - (a) approcher **le tissu en laine** (celui qui a servi au frottement) → « Le tissu attire la règle en
         plexiglas. »
       - (b) approcher **un deuxième tissu en laine frotté avec un bâton en P.V.C** → « Le tissu en laine
         repousse le bâton en plexiglas. »
       - (c) approcher **un troisième tissu en laine sans qu'il ne soit frotté** → « il n'y a ni attraction, ni
         répulsion : il n'y a aucune interaction. »
         _Conclusions_ : « Par frottement, le tissu en laine est susceptible de porter une électricité positive
         ou une électricité négative **selon le corps frottant**. » ; « Un corps non frotté et non électrisé par
         contact n'a pas d'action sur les corps frottés. Il est **électriquement neutre**. »

       _Encadré « **Un modèle pour expliquer le phénomène d'électrisation** »_ (p.15) — **le cœur théorique du
       chapitre** :
       - « On doit admettre que la matière contient des **porteurs de charges** qui sont de deux types : - des
         porteurs de charges renfermant de l'électricité négative ; - des porteurs de charges renfermant de
         l'électricité positive. »
       - « Un corps électriquement **neutre** est formé de matière qui renferme des **quantités égales**
         d'électricité positive et d'électricité négative. »
       - « Lors du frottement, des particules chargées négativement, appelées **électrons**, migrent d'un corps
         à un autre : - celui qui **reçoit** ces électrons devient porteur d'une quantité d'électricité négative
         supérieure à la quantité d'électricité positive (qui n'est pas modifiée). La charge globale devient
         **négative**. - celui qui **cède** ces électrons devient porteur d'une quantité d'électricité positive
         supérieure à la quantité d'électricité négative. La charge globale devient **positive**. »
       - « La charge portée par un corps est une grandeur mesurable, notée **q**. Son unité s'exprime dans le
         système international en **coulomb**, de symbole **(C)**. »
       - « La charge portée par un électron est notée **–e** ; **e** est la charge élémentaire dont la valeur
         est **1,6.10⁻¹⁹ C**. » _(exposant confirmé en vision p.15 ; l'extraction texte l'aplatit en
         « 1,6.10-19 C ». **Seule valeur numérique de tout le chapitre.**)_
       - « Lors du contact d'un corps (A) électrisé négativement avec un corps (B) neutre, quelques électrons
         migrent de (A) vers (B) ce qui engendre un excès de charges négatives dans (B). (B) devient, comme
         (A), électrisé négativement. »
         _Question ouverte (en italiques, **non corrigée par le manuel**)_ : « **Expliquer l'électrisation d'un
         corps neutre lors d'un contact avec un corps électrisé positivement.** » (⇒ le cas symétrique, laissé
         à l'élève.)

    5. **Activité V — plan : « Corps conducteurs et corps isolants » / titre imprimé : « Tous les corps
       sont-ils conducteurs ? »** (p.16) :
       _Protocole_ — « Electrisons par frottement (ou par contact) une règle en plexiglas. Plaçons-la à une
       **distance L** de la boule d'un pendule électrostatique telle qu'on ne perçoit pas un effet appréciable
       sur la boule. » puis « Intercalons entre la règle et la boule une **tige en carbone (crayon taillé des
       deux bouts)**, tenue par une **pince en bois** et telle qu'elle vienne toucher par un bout la règle et
       par l'autre la boule. » puis « Reprenons la même expérience en remplaçant la tige en carbone par une
       autre en **verre**, puis en **cuivre**, puis en **bois**, puis en **P.V.C**, puis en **plexiglas**, enfin
       en **aluminium**, » (**7 matériaux testés** au total).
       _Observations_ : « La boule est **repoussée** dans le cas du cuivre, de l'aluminium et du carbone. » ;
       « La boule **garde sa position** dans le cas du bois, du verre, du P.V.C et du plexiglas. »
       _Résultats_ : « La boule s'électrise positivement par contact avec les tiges en cuivre, en aluminium et
       en carbone. » ; « La boule ne s'électrise pas, malgré le contact avec les autres tiges. »
       _Encadré « **Interprétation** »_ : « Par contact avec la règle en plexiglas, la tige en cuivre (ou en
       aluminium ou en carbone) s'électrise positivement en cédant des électrons à la règle. Ces électrons
       ayant quitté la tige font **apparaitre** [sic] une charge positive sur toute la tige. » ; « La charge
       positive qui apparaît sur le cuivre (ou l'aluminium ou le carbone) **n'est pas localisée à la zone
       touchée** par la règle. L'extrémité de la tige, en contact avec la boule, **arrache des électrons** à
       cette dernière, l'amenant ainsi à devenir chargée positivement ce qui explique la répulsion. » ; « Le
       cuivre, l'aluminium et le carbone sont des matériaux qui **laissent circuler les électrons** ; ils sont
       appelés des **conducteurs**. » ; « Le bois, le plexiglas, le verre et le P.V.C sont des matériaux qui
       **ne permettent pas une circulation des électrons** (la charge électrique **reste localisée** au bout des
       tiges du côté de la règle en plexiglas) ils sont appelés des **isolants**. »
       _Trois questions ouvertes (en italiques, **non corrigées**)_ : « Comment expliquer la disparition de la
       charge électrique d'un corps électrisé par frottement ou par contact quand on touche sa partie
       électrisée à la main ? » ; « Pourquoi doit-on tenir une tige en cuivre électrisée à l'aide d'un manche
       en bois ? » ; « Interpréter l'électrisation par influence de l'électroscope observée **aux cours** [sic]
       des activités III. »

    6. **Activité VI — plan : « Décharge électrique » / titre imprimé : « Qu'est-ce qu'une décharge
       électrique ? »** (p.17) :
       _Protocole_ — « Tournons la manivelle de la **machine de Wimshurst**, appelée aussi **machine
       électrostatique**, après avoir rapproché ses deux sphères (sans qu'elles ne se touchent). »
       _Observations_ : « Des charges de signes contraires, qu'on vérifiera à l'aide d'un pendule
       électrostatique, s'accumulent **progressivement** sur les sphères. » ; « Après une accumulation
       **suffisante** de charges, il apparaît une **étincelle** qui jaillit entre les deux sphères. Cette
       étincelle est accompagnée d'un **crépitement**. »
       _Résultat (interprétation officielle)_ : « Deux corps chargés d'électricité de signes différents et
       rapprochés l'un de l'autre peuvent donner lieu (si les quantités d'électricité sont importantes) à un
       **déplacement d'électrons à travers l'air**. Ce déplacement se fait **du corps chargé négativement vers
       le corps chargé positivement**. Il conduit à une **décharge** des corps en regard. Cette décharge brève
       est accompagnée d'un phénomène lumineux appelé **éclair** qui matérialise le **canal** par lequel
       s'écoulent les charges. L'**échauffement intense** de l'air contenu dans ce canal est à l'origine des
       **crépitements**. »

    7. **Activité VII — plan : « Effet de pointe » / titre imprimé : « Sur un corps électrisé, la répartition
       des charges est-elle partout la même ? »** (p.17) :
       _Protocole_ — « Fixons à l'une des sphères de la machine de Wimshurst un **corps pointu** et répétons
       l'expérience précédente. »
       _Observation_ : « L'étincelle jaillit **facilement** et arrive à la **région la plus pointue** des deux
       corps électrisés **ou en part**. » _(tour elliptique de la source — « ou part de cette région » —
       reproduit tel quel.)_
       _Résultats_ : « Au bout d'une pointe, les charges d'un corps électrisé s'accumulent très fortement et la
       décharge y est facilitée: c'est **l'effet de pointe**. » ; « Le **canal** d'une décharge dépend de la
       **forme géométrique** des corps concernés. »
       _Question ouverte (en italiques, **non corrigée**)_ : « Ce phénomène est à rapprocher d'un phénomène
       naturel : **la foudre**. Proposer une explication. » (⇒ pont explicite vers le « Savoir plus » p.24.)

  - **Fiche T.P.** (p.18) « **ELECTRISATION PAR FROTTEMENT** » :
    - _Buts_ (3, verbatim) : « Electriser un corps par frottement. » ; « Déterminer la nature de la charge d'un
      corps électrisé par frottement. » ; « Montrer que l'électricité qui apparaît sur un corps frotté dépend
      de **la nature du corps frotté** et de **l'objet qui a servi à l'électriser**. »
    - _Matériels_ (8) : « Support d'un pendule électrostatique. » · « Bâton en verre. » · « Bâton en
      plexiglas. » · « Bâton en ébonite. » · « Règle en PVC. » · « Coton. » · « Peau de chat. » · « Sachet en
      polyéthylène. »
    - _Expérimentation_ — tableau à **4 colonnes** (« Nature de l'objet frottant » | « Nature du corps
      frotté » | « **Interaction** » | « **Electricité** ») et **6 lignes** : objet frottant **Sachet en
      polyéthylène** × {Règle en PVC, Bâton en ébonite, Bâton en plexiglas}, puis objet frottant **Peau de
      chat** × {Règle en PVC, Bâton en ébonite, Bâton en plexiglas}. **Les colonnes « Interaction » et
      « Electricité » sont imprimées VIDES** (à remplir par l'élève) — vérifié en vision p.18.
    - _Protocole_ (verbatim) : « Frotter le bâton en verre avec du coton ou avec un tissu en laine, puis le
      suspendre au support du pendule électrostatique. » ; « Frotter chaque corps avec l'objet indiqué dans le
      tableau ci-dessus, puis approcher le du bâton en verre électrisé. » ; « Noter le type d'interaction
      (attractive ou répulsive). » ; « Déduire la nature de la charge portée par chaque corps et la porter dans
      le tableau. » ; « Interpréter les résultats. »
      ⇒ Le **bâton en verre sert de référence** (il matérialise la convention de signe posée en Activité II) ;
      il n'est pas lui-même une ligne du tableau. Un **tissu en laine** est admis en substitut du coton pour
      cette référence, bien qu'il ne figure pas dans la liste « Matériels ».

  - **Recherche documentaire** (p.19) « **LA CAGE DE FARADAY** » — texte documentaire court (résumé ; photo :
    une automobile dans une chambre anéchoïque à parois hérissées d'absorbants) : définition de la cage de
    Faraday (enceinte ou cage métallique isolant une région de l'espace de l'influence des champs électriques
    extérieurs) ; champ électrique **nul à l'intérieur**, même si des charges sont placées à l'extérieur ou si
    la cage est reliée à un générateur électrostatique ; **la carrosserie métallique d'une voiture en est une**
    et protège ses occupants de l'électrocution (contact extérieur ou décharge atmosphérique) ; les ondes radio
    (électromagnétiques) ne traversent pas les cages de Faraday — d'où les dysfonctionnements des
    récepteurs/émetteurs dans l'habitacle et le recours à une **antenne de toit**.
    _4 questions (verbatim)_ : « 1/- Préciser, en utilisant un dictionnaire, le sens du mot
    «**élecro-magnétique**» [sic]. » ; « 2/- Citer quelques dangers d'électrocution. » ; « 3/- Donner un
    exemple de décharge atmosphérique. » ; « 4/- Pourquoi doit-on utiliser une antenne de toit pour faire
    fonctionner correctement un auto-radio ? »
    ⚠️ La coquille « élecro » (« t » manquant) est **vérifiée au zoom 300 dpi** et porte **précisément sur le
    mot que l'élève doit chercher au dictionnaire** — gênante à l'usage (§6.3).

  - **L'essentiel du cours** (p.20, **verbatim — 12 puces**) :
    - « Certains corps frottés peuvent devenir chargés d'électricité. On dit qu'ils subissent un phénomène
      d'électrisation par frottement. »
    - « On distingue deux types de charges électriques : - des charges positives : ce sont des charges que
      porte le verre frotté avec un tissu en laine ou tout corps repoussé par le verre électrisé. - des charges
      négatives : ce sont des charges que porte tout corps attiré par le verre électrisé. »
    - « Deux corps chargés d'électricité de même signe se repoussent. »
    - « Deux corps chargés d'électricité de signes contraires s'attirent. »
    - « Un corps électrisé par contact se charge d'électricité de même signe que le corps électrisant. »
    - « Le phénomène d'électrisation par contact ou par frottement est dû à un transfert d'électrons d'un corps
      à un autre : celui qui cède des électrons devient chargé positivement et celui qui en reçoit devient
      chargé négativement. »
    - « La quantité d'électricité est une grandeur mesurable. Elle s'exprime en coulomb de symbole C. »
    - « L'électroscope est un appareil qui permet de rendre compte si un corps est chargé ou non et de comparer
      les quantités d'électricité des corps électrisés. »
    - « Un corps conducteur permet le passage des électrons (tels que les métaux), un corps isolant ne le permet
      pas (tels que les matières plastiques). »
    - « Au bout d'une pointe les charges d'un corps électrisé s'accumulent très fortement. »
    - « La lumière émise par une étincelle accompagne le passage d'électrons dans l'air. »
    - « Le canal d'une décharge dépend de la forme géométrique des corps concernés. »
      ⚠️ **Notable pour la génération** : l'essentiel **n'énonce ni la charge élémentaire e = 1,6.10⁻¹⁹ C, ni la
      notation q, ni l'électrisation par influence** — pourtant tous trois enseignés dans les activités
      (p.14–15). Symétriquement, il attribue à l'électroscope une capacité à « **comparer** les quantités
      d'électricité » qui n'est **démontrée par aucune activité**. Un contenu calibré sur le seul « essentiel »
      serait **en deçà** du chapitre réellement enseigné et laisserait deux exercices du manuel insolubles
      (§6.3).

  - **Aperçu historique / Naviguer sur l'Internet** (p.20) : « Naviguer sur l'Internet
    (`http://www.edunet.tn/physique/savants.htm`) ou
    (`http://www.infoscience.fr/histoire/biograph/biograph_som.html`) et trouver les découvertes du savant
    **Dufay (1698/1739)**. » _(Charles François de Cisternay du Fay, auteur de la distinction électricité
    vitrée/résineuse invoquée en Activité II — le manuel ne fait pas ce lien explicitement. Dates
    **historiquement exactes**, contrairement à celles des p.82 et p.222 — cf. §6.3.)_ Titre de rubrique imprimé
    « **APERCU HISTORIQUE** » (sans cédille — usage typographique constant du manuel sur les capitales).

  - **Exercice résolu** (p.21) — _avec_ solution et colonne « Commentaires » :
    - _Énoncé_ : « On électrise un bâton en plexiglas par frottement avec du **coton**, puis on l'approche d'un
      bâton en verre électrisé par un tissu en laine. On constate qu'il y a une **répulsion**. Lorsqu'on
      approche le bâton en plexiglas électrisé de la boule d'un pendule électrostatique initialement non
      électrisée, on constate qu'il y a une **attraction**, puis une **répulsion** tout juste après que la boule
      se mette en contact avec le bâton de plexiglas électrisé. »
      _Questions_ : « 1/- Préciser le signe de la charge portée par le bâton en plexiglas électrisé par
      frottement avec du coton. » ; « 2/- Préciser le signe de la charge de la boule du pendule électrostatique
      juste après le contact avec le bâton en plexiglas électrisé. » ; « 3/- Comment expliquer, avant contact,
      l'interaction attractive entre la boule initialement non électrisée et le bâton en plexiglas électrisé ? »
    - _Solution imprimée_ : **1/-** « Le bâton en verre et le bâton en plexiglas se repoussent, donc le bâton en
      plexiglas est électrisé **positivement**. » — _commentaire_ : « Deux charges de même signe se
      repoussent. » **2/-** « Puisque le bâton en plexiglas est chargé positivement et comme, après contact, on
      assiste à une répulsion, on conclut que la boule du pendule électrostatique est devenue chargée
      **positivement**. » — _commentaire_ : « Lors du contact, des électrons quittent la boule du pendule
      électrostatique pour migrer vers le bâton de plexiglas, ce qui conduit les deux corps à porter des charges
      de même signe. » **3/-** « La charge positive du bâton en plexiglas **attire les électrons de la surface
      de la boule** vers la région qui lui est proche, ce qui fait apparaître un **excès de charges positives sur
      la région la plus éloignée**. La charge globale du pendule étant neutre, la quantité d'électricité positive
      est égale à la quantité d'électricité négative mais **toutes les deux situées à des distances inégales** du
      bâton de plexiglas. L'interaction d'attraction **l'emporte alors** sur l'interaction de répulsion d'où
      l'observation de l'attraction. » — _commentaire_ : « La boule du pendule électrostatique est revêtue d'un
      conducteur. A l'approche du bâton de plexiglas, **il** [sic] s'électrise par influence. »
      ⇒ La question 3 est le **seul endroit du chapitre** où le mécanisme de l'**attraction d'un corps neutre par
      un corps chargé** (influence + inégalité des distances) est réellement démontré. C'est aussi ce qui
      justifie _a posteriori_ l'Activité I (attraction d'une boule non électrisée).

  - **Exercices à résoudre** (p.22–23) — les **trois catégories** du gabarit, **sans corrigé imprimé** (aucune
    réponse n'est donnée ci-dessous : le manuel n'en donne aucune) :
    - **« Vérifier ses acquis »** (p.22) — 3 exercices :
      1. « Recopier les phrases suivantes en les complétant. » (texte à trous, 3 phrases) : « 1/-Par convention,
         l'électricité……apparaît sur le verre frotté avec un tissu en laine et sur tout corps qu'il……. » ;
         « 2/-Un corps électriquement neutre possède……d'électrons que de charges positives. » ; « 3/-Un corps
         chargé négativement présente un excès……Entre ce corps et un autre corps de charge opposée il y a……. »
      2. « Répondre par vrai ou faux et justifier la réponse. » (3 affirmations) : « 1/-Par temps sec et après
         frottement, une baguette **en verre** tenue à la main **garde** sa charge; alors qu'une baguette **en
         cuivre** tenue à la main **perd** sa charge. » ; « 2/-Par contact avec un corps A déjà chargé, un corps
         B se charge d'électricité de même signe que celle du corps A. » ; « 3/-Si on relie à la Terre un corps
         chargé positivement par un fil conducteur, **les charges positives s'écoulent vers la Terre**. »
      3. « Choisir le ou les mots exacts. » (4 items) : « 1/-Deux corps frottés l'un contre l'autre puis séparés
         deviennent électrisés. Leurs charges sont _(de même signe/de signes contraires)_. » ; « 2/-Un corps
         isolant _(permet/ne permet pas)_ un déplacement de charges électriques. » ; « 3/-Dans un corps
         conducteur électrisé, les charges _(restent localisées/se répartissent sur tout le corps)_. » ;
         « 4/-L'électrisation par frottement est expliquée par un transfert _(d'électrons/de charges
         positives)_ d'un corps à un autre. »
    - **« Utiliser ses acquis dans des situations simples »** (p.22–23) — 3 exercices :
      1. (p.22) « Choisir la bonne réponse. » — « Après frottement avec un tissu en laine, le verre repousse le
         plexiglas et le plexiglas attire l'ébonite, donc le verre : (a) attire l'ébonite ; (b) repousse
         l'ébonite ; (c) n'a aucune action sur l'ébonite. » _(transitivité des signes.)_
      2. (p.23) « Indiquer comment procéder pour décharger un corps : a)- fortement électrisé. b)- faiblement
         électrisé. »
      3. (p.23) « Le frottement de l'air sur les carrosseries des voitures produit des décharges électriques.
         Comment élimine-t-on ces charges? »
    - **« Utiliser ses acquis pour une synthèse »** (p.23) — 3 exercices :
      1. « La boule d'un premier pendule électrostatique est chargée par contact avec un bâton de verre électrisé
         **positivement**. Celle d'un deuxième pendule est chargée par contact avec une **règle en plastique
         frottée avec du polyéthylène**. On approche les deux boules l'une de l'autre : **elles se repoussent**.
         Préciser la nature de la charge de la règle. »
      2. « On approche de la **boule métallique (B)** d'un **électroscope** (sans la toucher), un **bâton en
         ébonite (E)** préalablement frotté avec un tissu en laine, nous constatons que **les feuilles** (très
         minces et très légères d'aluminium) de l'électroscope **se repoussent**. a)- Expliquer la répulsion des
         feuilles d'aluminium. b)- Les feuilles d'aluminium ont-elles subi une électrisation par contact ou par
         frottement ? Sinon donner un nom à ce mode d'électrisation. »
         **Figure associée (p.23, lue en vision)** : deux schémas au trait superposés d'un **électroscope à
         feuilles** — en haut, l'appareil seul, repéré **(B)** (boule au sommet), feuilles **jointes/parallèles**
         (état initial, non électrisé) ; en bas, le même appareil repéré **(B)** avec les feuilles **écartées en
         V** et, approché de la boule sans contact, le bâton **(E)** figuré par un barreau noir horizontal (état
         après influence). Aucune valeur chiffrée n'y figure. ⚠️ **Seule figure du chapitre porteuse d'une
         information non redondante avec le texte** (l'état initial feuilles jointes n'est écrit nulle part).
      3. « 1/- Deux corps électrisés portent de grandes quantités de charges électriques opposées. a)- Expliquer
         pourquoi il pourrait se produire une décharge électrique entre ces deux corps. b)- Citer les
         manifestations de cette décharge. 2/- La foudre est un phénomène naturel au cours duquel se manifeste
         cette décharge. a)- Préciser les deux corps électrisés responsables de ce phénomène naturel. b)-
         Expliquer l'électrisation de ces deux corps. »

  - **Savoir plus** (p.24) « **LA FOUDRE** » — texte documentaire (résumé ; photo pleine hauteur : éclair
    ramifié frappant le sol). Contenu : les nuages orageux (**cumulo-nimbus**) sont des masses de **plusieurs
    milliers de tonnes d'eau**, formées par conditions particulières d'humidité et de température (journée
    chaude et humide) ; **base entre 1 et 3 km**, **sommet pouvant dépasser 10 km** d'altitude ; les fortes
    différences de température entre base et sommet provoquent des **courants d'air de convection** ; les
    courants ascendants entraînent les particules **les plus légères**, qui s'élèvent, se **transforment en
    glace** et se chargent **positivement**, tandis que les particules **plus lourdes** descendent, restent
    **liquides** en bas et sont chargées **négativement** ; le bas du nuage, négatif, **repousse les charges
    négatives du sol**, qui se trouve **chargé positivement par influence**. La décharge peut se produire **entre
    deux nuages** ou **entre un nuage et le sol** : c'est la **foudre**, avec sa trainée lumineuse, l'**éclair**.
    Les objets **les plus proches du nuage et les plus pointus** sont atteints de préférence (clochers, poteaux,
    cimes des arbres). Consignes de sécurité : éviter la proximité de tels points ; ne pas traverser une vaste
    place ou un champ où **la personne serait la partie la plus pointue** ; ne pas utiliser un parapluie ou un
    objet pointu (piolet, fourche) ; **l'automobile est un très bon abri** car sa carrosserie métallique
    constitue une **cage de Faraday** (⇒ rappel explicite de la p.19). Le **paratonnerre** : « une grosse tige
    métallique, dressée sur le toit et reliée à la Terre, qui conduit les charges électriques vers cette
    dernière ». Le **tonnerre** : « un phénomène sonore : les couches d'air s'échauffent et vibrent tout au long
    de l'éclair on entend alors un bruit caractéristique ».
    ⇒ Cette rubrique **répond** aux questions de mise en situation p.11 (éclair/foudre/tonnerre/paratonnerre) et
    à la question ouverte de l'Activité VII (p.17), et **fournit la matière** de l'exercice de synthèse 3 (p.23).

- **Concepts / notions** : électrisation **par frottement** ; corps **électrisé** / **chargé d'électricité** ;
  **pendule électrostatique** (instrument de détection) ; **interaction** entre corps électrisés (attraction /
  répulsion) ; les **deux types de charges** et la **convention de signe référencée au verre** (+ = vitrée,
  − = résineuse) ; **électrisation par contact** (même signe que le corps électrisant) ; **électrisation par
  influence** ; **électroscope** (détecter ; comparer les quantités d'électricité) ; corps **électriquement
  neutre** ; **modèle des porteurs de charges** et **transfert d'électrons** (le corps qui cède devient +, celui
  qui reçoit devient −) ; **charge q**, unité **coulomb (C)** ; **charge élémentaire e = 1,6.10⁻¹⁹ C**, charge de
  l'électron **−e** ; **conducteurs** (cuivre, aluminium, carbone — laissent circuler les électrons, charge
  **délocalisée** sur toute la tige) vs **isolants** (bois, verre, P.V.C, plexiglas — charge **localisée**) ;
  **décharge électrique** à travers l'air (des électrons du corps − vers le corps +), **étincelle**, **éclair**,
  **canal**, **crépitement** (échauffement intense de l'air) ; **effet de pointe** ; dépendance du canal à la
  **forme géométrique** ; **cage de Faraday** ; **foudre**, **tonnerre**, **paratonnerre**.

- **Vocabulaire officiel** : « électrisation par frottement », « électrisé », « chargé d'électricité »,
  « pendule électrostatique », « interaction », « attraction », « répulsion », « charge électrique »,
  « électricité vitrée », « électricité résineuse », « électrisation par contact », « corps électrisant »,
  « électrisation par influence », « électroscope », « électriquement neutre », « porteurs de charges »,
  « électrons », « charge globale », « quantité d'électricité », « coulomb (C) », « charge élémentaire »,
  « conducteurs », « isolants », « décharge », « étincelle », « éclair », « canal », « crépitement », « effet de
  pointe », « machine de Wimshurst », « machine électrostatique », « cage de Faraday », « cumulo-nimbus »,
  « foudre », « tonnerre », « paratonnerre », « parafoudre », « peinture électrostatique ».

- **Bornes de scope** :
  - ✅ **INCLUS** : mise en évidence expérimentale de l'électrisation par frottement (matériaux électrisables) ;
    existence de **deux** types de charges et convention de signe **par référence au verre frotté à la laine** ;
    lois qualitatives d'interaction (même signe → répulsion ; signes contraires → attraction) ; les **trois modes
    d'électrisation** (frottement, contact, influence) ; le **pendule électrostatique** et l'**électroscope**
    comme détecteurs ; neutralité électrique ; **modèle du transfert d'électrons** comme interprétation unique de
    tout le chapitre ; la grandeur **charge q** en **coulomb (C)** et la valeur de la **charge élémentaire** ;
    distinction **conducteur/isolant** posée **par la mobilité des électrons et la localisation de la charge**
    (jamais par le passage d'un courant) ; **décharge** à travers l'air et ses manifestations (étincelle, éclair,
    crépitement) ; **effet de pointe** ; applications (cage de Faraday, paratonnerre, peinture électrostatique).
  - ⛔ **EXCLU (relève des chapitres suivants)** : **tout ce qui touche au circuit et au courant** — notion de
    dipôle, circuit fermé/ouvert, générateur/récepteur, effets du courant, symboles normalisés, sens conventionnel
    (**ch.2**, p.25–42) ; intensité et ampèremètre (**ch.3**) ; tension et voltmètre (**ch.4**) ; résistance et loi
    d'Ohm (**ch.5**). Le chapitre 1 ne comporte **aucun montage électrique, aucun générateur, aucune mesure
    chiffrée** : la seule valeur numérique de tout le chapitre est **e = 1,6.10⁻¹⁹ C**, et elle est donnée, jamais
    calculée. **Aucun calcul n'est demandé nulle part** (ni dans les activités, ni dans les 9 exercices) — le
    chapitre est **intégralement qualitatif**.
  - ⛔ **EXCLU (hors programme de ce niveau, bien que le mot soit imprimé)** : le **champ électrique** — le terme
    n'apparaît qu'à la p.19 (« le champ électrique est nul »), dans un texte **documentaire**, sans aucune
    définition ; la **force de Coulomb** et toute loi quantitative d'interaction ; la structure atomique
    (noyau/protons) — le manuel s'en tient à des « porteurs de charges » **sans jamais nommer le proton ni
    l'atome** ; la nature de la charge du corps frottant _dans le cas général_ (seule la laine est étudiée).
  - 🔗 **Prérequis aval** : ce chapitre est le **prérequis explicite du chapitre II de chimie** (cf.
    [`chimie.md`](./chimie.md), p.19) — l'électrisation y fonde le modèle de la charge. En amont, il n'exige **que
    le sens des mots éclair / tonnerre / foudre** (p.9).

---

## 2.2 Physique — Chapitre 2 : Le circuit électrique (p.25–42, transcrit à profondeur de génération)

**Désignation imprimée (p.25)** : « **CHAPITRE II** » · thème « **L'ELECTRICITE** » · titre « **LE CIRCUIT
ELECTRIQUE** » — concordant avec le sommaire p.4.

- **Page d'ouverture** (p.25) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Le circuit électrique » ·
    « • Activités(II) : Les effets du courant électrique » · « • Activités(III) : Les conducteurs et les
    isolants » · « • Activités(IV) : Schématisation d'un circuit électrique » · « • Activités(V) : Le sens du
    courant électrique » · « • Activités(VI) : La nature du courant électrique » · « • Activités(VII) : La diode
    et le sens du courant » · « • Activités(VIII) : Le court-circuit ». _(Les 8 sont bien imprimées dans le
    corps — plan et corps concordent.)_
  - **Pré-requis** (verbatim) : « Conducteurs et isolants » · « Effet magnétique (aimant, boussole et aiguille
    aimantée) » · « Cations et anions » · « Incandescence ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.26–27) : quatre mises en situation illustrées (bouton
    d'une torche électrique ; jouet à mouvements en sens inverses ; techniciens réparant une
    ligne haute tension avec une perche en matière plastique ; batterie contenant un liquide
    (eau acidulée)), chacune suivie de 3–4 questions ouvertes (« Qu'appelle-t-on circuit
    électrique ? », « Qu'est-ce qu'un dipôle ? », « Qu'est-ce qu'un dipôle générateur/récepteur ? »,
    « Le courant électrique a-t-il un sens ? », « D'où provient l'énergie électrique ? »,
    « Qu'est-ce qu'un court-circuit ? Quels dangers ? Comment s'en protéger ? »).
  - **Activités expérimentales** (p.28–35) — 8 blocs :
    1. **Activité I — Qu'est-ce qu'un circuit ?** (p.28) : lampe, pile, moteur — propriété
       commune : deux bornes → appelés **dipôles**. Branchements en chaîne à l'aide de fils de
       connexion : pour certains, le moteur tourne et/ou la lampe s'allume. **Généralisation
       officielle** : « La chaîne continue de dipôles électriques ainsi constituée forme un
       circuit électrique fermé. » Retrait d'un dipôle (lampe/moteur) en maintenant la chaîne :
       l'autre continue de fonctionner ; retrait de la pile : plus de courant → « La pile joue le
       rôle de générateur. » « Le moteur et la lampe sont des récepteurs : ils ne peuvent pas
       provoquer l'apparition d'un courant. »
    2. **Activité II — Quels sont les effets du courant électrique ?** (p.28–29) : 4 montages
       (a)(b)(c)(d) — (a) lampe qui chauffe (effet thermique, filament, vérifiable au toucher du
       verre) ; (b) électrolyseur, transformation de la matière (effet chimique) ; (c) aiguille
       aimantée qui dévie (effet magnétique) ; (d) DEL qui éclaire sans chauffer (effet lumineux).
       **Généralisation officielle** : « Dans un circuit électrique, un courant électrique peut
       avoir : un effet thermique (expérience : a) ; un effet chimique (expérience : b) ; un
       effet magnétique (expérience : c) ; un effet lumineux (expérience : d). » « Selon les
       composants d'un circuit, il peut se manifester plus d'un effet (expériences : c et d). »
       « La manifestation de l'un des effets ci-dessus cités est une preuve du passage d'un
       courant électrique dans un circuit. » Question ouverte (p.29) : lampes en série, l'une
       éclaire l'autre non — la lampe éteinte est-elle traversée par un courant ? Quel nom donner
       au dipôle (D) ?
    3. **Activité III — comportement des conducteurs et isolants** (p.30) : débranchement d'un
       fil (bornes A/B) → lampe et diode s'éteignent. Insertion successive entre A et B d'un
       corps en matière plastique, bois, métallique, verre, crayon taillé des deux bouts :
       avec le carbone du crayon et l'objet métallique → la diode et la lampe éclairent (tous les
       **conducteurs**) ; avec plastique/verre/bois → n'éclairent plus (tous les **isolants**).
       **Généralisation officielle** : « Un conducteur laisse passer le courant électrique alors
       qu'un isolant ne le laisse pas passer. » « Un circuit électrique comportant dans sa chaîne
       un corps isolant est dit circuit ouvert. » « Un circuit électrique est le siège d'un
       courant électrique s'il remplit les deux conditions suivantes : il comporte un dipôle
       générateur ; il renferme une chaîne continue de conducteurs. » Remarques : l'air sec entre
       A et B déconnectés est un isolant ; l'air humide, l'eau, le corps humain sont des
       « mauvais conducteurs électriques ».
    4. **Activité IV — Comment schématiser un circuit électrique ?** (p.30–31) : table de
       symboles normalisés (fil conducteur, générateur, lampe, moteur, interrupteur
       fermé/ouvert, diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre) ; schémas d'un
       circuit fermé et d'un circuit ouvert.
    5. **Activité V — Le courant électrique a-t-il un sens ?** (p.31–32) : pôles P et N d'une
       pile reliés aux bornes A et B d'un moteur, interrupteur K fermé — le moteur tourne dans
       un sens déterminé ; connexions de la pile inversées → le moteur tourne en sens contraire.
       « Le passage du courant électrique est une cause capable de faire tourner le moteur : la
       rotation du moteur est un effet du courant électrique. » « Le changement de sens de
       rotation du moteur est attribué à un changement du sens de la cause qui lui a donné
       naissance, c'est-à-dire du courant électrique. » **Généralisation officielle (convention
       de sens)** : « Par convention, le courant électrique débité par un générateur circule
       dans le circuit électrique extérieur fermé en sortant de la borne positive (+) du
       générateur et en rentrant par sa borne négative (-). »
    6. **Activité VI — Quelle est la nature du courant électrique ?** (p.32–33) — deux volets :
       - **A/- Dans les métaux** : le courant s'établit dès la fermeture du circuit, continue tant
         que la chaîne n'est pas rompue et que le générateur fonctionne. « Le courant électrique
         dans les conducteurs solides est dû à un mouvement d'ensemble d'électrons mobiles
         (appelés électrons de conduction) présents dans ces conducteurs. C'est le générateur qui
         fournit aux dipôles récepteurs des électrons par l'une de ses bornes repérée par
         convention par le signe (-) et qui en reçoit au niveau de sa deuxième borne repérée par
         le signe (+). » Analogie officielle : « Son fonctionnement est à rapprocher d'une pompe
         qui refoule des électrons par sa borne (-) et les attire par sa borne (+). »
       - **B/- Dans les solutions d'électrolytes** (p.33) : bandelette de papier filtre imbibée
         d'une solution de sel, grains de sulfate de cuivre II + permanganate de potassium ;
         séparation des couleurs à la fermeture : ions permanganate (violets) migrent vers la
         lame liée à la borne positive, ions cuivre II (bleus) migrent vers la lame liée à la
         borne négative. Une lampe insérée indique le passage du courant. « Un liquide ionique
         est un conducteur électrique. » « Dans les solutions ioniques (solutions d'électrolytes)
         le courant est un déplacement ordonné d'ions et non pas d'électrons. » « Les ions
         positifs (appelés cations) se déplacent dans le sens conventionnel du courant. Les ions
         négatifs (appelés anions) se déplacent dans le sens contraire. » Questions ouvertes :
         eau distillée sucrée (« …va-t-on détecter le passage d'un courant ? » — **la source pose la
         question et n'y répond pas** : aucune réponse n'est imprimée) ; batterie d'accumulateurs au
         plomb.
    7. **Activité VII — Comportement d'une diode dans un circuit électrique** (p.34) : diode
       symbolisée, montages pile + lampe + diode + interrupteur. Diode orientée de sorte que le
       courant la traverse de l'anode (borne éloignée de l'anneau) vers la cathode (borne proche
       de l'anneau) → la lampe brille ; bornes inversées → lampe éteinte. « La diode est un
       dipôle dont les pôles ne sont pas identiques : c'est un dipôle dissymétrique. » « Lorsqu'un
       courant traverse une diode, il sort par la borne située près de l'anneau. La diode est dite
       branchée dans le sens passant ; elle joue alors le rôle d'un interrupteur fermé. »
       « Lorsque la diode se comporte comme un isolant, elle est dite montée dans le sens
       bloquant ; elle joue alors le rôle d'un interrupteur ouvert. » « Une diode peut servir pour
       connaître le sens du courant en tout point d'un circuit électrique. » Remarques : sens
       passant d'une DEL repéré par la longueur des tiges (anode = tige longue → cathode = tige
       courte) ; couleur émise dépend du semi-conducteur.
    8. **Activité VIII — Qu'est-ce qu'un court-circuit ?** (p.35) : deux lampes L1/L2 en série ;
       relier les deux bornes de L1 par un fil de connexion → L1 s'éteint, L2 brille davantage.
       « La lampe (L1) s'éteint lorsque ses deux bornes sont reliées par un fil conducteur, c'est
       la preuve qu'elle n'est plus traversée par un courant capable de porter son filament à
       l'incandescence. » « Le courant qui traverse (L2) traverse le fil conducteur au lieu de
       traverser (L1). On dit qu'on a réalisé un court-circuit aux bornes de (L1) ou que (L1) est
       court-circuitée. » Risque : « La lampe (L2) brille fortement et risque d'être détériorée
       (son filament fond) sous l'effet thermique qui devient très important. » Remarque : risque
       d'incendie si court-circuit aux bornes d'un générateur.
  - **Fiche T.P.** (p.36) « Circuit électrique » : buts (réaliser un circuit à partir d'un schéma,
    reconnaître conducteurs/isolants, dépanner un circuit en panne simple, citer les effets du
    courant) ; matériel (générateur continu, électrolyseur avec solution de sel de cuisine,
    moteur électrique, fils de connexion, lampe à filament tungstène, fil en laine et fil en fer,
    interrupteur) ; protocole séquencé (interrupteur ouvert puis fermé, reconnaître isolant/
    conducteur, remplacer un fil conducteur par le fil en laine, déduire la propriété électrique
    de la laine).
  - **Activité documentaire** (p.37) « Les circuits intégrés » : historique de la microélectronique
    (premier circuit intégré miniature en 1958 avec un seul transistor, quatre diodes et
    quelques résistances ; puces actuelles à dizaines de millions de transistors), procédé de
    fabrication sur silicium en « salles blanches », 4 questions de compréhension (sens de
    « mégabit », étapes de conception d'une puce, rôle des broches, pourquoi les salles blanches).
  - **L'essentiel du cours** (p.38, verbatim) :
    - « Une chaîne continue (ininterrompue) de dipôles électriques comportant au moins un dipôle
      générateur constitue un circuit électrique fermé. »
    - « Le dipôle responsable de l'établissement du courant électrique dans un circuit est
      appelé générateur. »
    - « Le dipôle qui utilise le courant électrique pour fonctionner est appelé dipôle
      récepteur. »
    - « Les conducteurs laissent passer le courant électrique. »
    - « Les isolants ne laissent pas passer le courant électrique. »
    - « Quand un courant circule dans un circuit électrique, l'un des effets suivants, au moins,
      se manifeste : effet magnétique, effet thermique, effet chimique, effet lumineux. »
    - « Pour schématiser un circuit, on utilise des symboles normalisés des dipôles qui le
      constituent. »
    - « Le courant électrique a un sens. Par convention ce sens va, à l'extérieur du dipôle
      générateur, de la borne positive vers la borne négative. »
    - « Le courant électrique est un mouvement d'ensemble de porteurs de charges : des électrons
      dans les conducteurs solides (les métaux) et des ions dans les solutions ioniques. Les
      anions et les électrons se déplacent vers la borne positive du générateur et les cations
      vers la borne négative. »
    - « Une diode est un composant électronique qui ne se laisse traverser par le courant que
      dans un seul sens, appelé passant. L'autre sens est dit bloquant. »
    - « Un dipôle est court-circuité lorsque ses bornes sont reliées par un fil conducteur. »
    - « Un dipôle récepteur court-circuité est mis hors usage. Un tel court-circuit peut
      endommager certains composants du circuit. »
    - « Lorsque le dipôle est un générateur, un court-circuit peut l'endommager et peut être à
      l'origine d'un incendie. »
  - **Aperçu historique** (p.38) : recherche internet sur le savant **Faraday (1791–1867)**.
  - **Exercice résolu** (p.39) : moteur devant tourner dans un sens déterminé, pile plate sans
    signes indiqués, diode de protection associée. 1/- déduire le signe des bornes de la pile à
    partir du sens de fonctionnement du moteur. 2/- intérêt de la diode. 3/- effet d'un
    court-circuit de la diode / d'une inversion des bornes du moteur. Solution : lame la plus
    longue = borne négative ; diode passante = interrupteur fermé, protège le moteur si montée
    bloquante ; diode court-circuitée = moteur continue de fonctionner (« un dipôle
    court-circuité est mis hors usage ») ; moteur inversé = endommagé.
  - **Exercices** (p.40–41) : « Vérifier ses acquis » — phrases à compléter (chaîne
    continue/dipôle générateur ; électrons en mouvement dès fermeture, pas d'accumulation ;
    diode passante/bloquante selon la cathode reliée à la borne + ou -) ; vrai/faux motivé
    (tous les électrons de chaque atome participent-ils à la conduction ? sens des ions négatifs
    vs électrons dans un circuit mixte ; effets du courant dépendant du sens) ; choisir le(s) mot(s)
    exact(s) (électrons/ions et sens réel vs conventionnel ; nature du courant en solution ;
    signe des ions se déplaçant dans le sens conventionnel ; conservation du nombre d'électrons
    dans une portion de conducteur). « Utiliser ses acquis dans des situations simples » (p.40–41) :
    QCM eau sucrée isolante vs eau salée conductrice (p.40) ; exemples d'appareils à effet
    thermique/magnétique (p.41) ; montage à interrupteurs K1/K2 (identifier ce montage d'usage
    courant, p.41). « Utiliser ses acquis pour une synthèse » (p.41) : allumage indépendant de
    deux lampes (modifier le montage sans ajouter/retirer de dipôle) ; schéma d'un circuit avec
    un dipôle en panne (identifier + corriger) ; circuit avec interrupteur à deux positions et
    diodes (sens des électrons dans la lampe, allumage selon la position).
  - **Savoir plus** (p.42) « La diode LED » : LED = « diode à émission lumineuse » (Light Emitting
    Diode), diode à jonction à base de semi-conducteurs ; anode (tige longue, sortie
    d'électrons) / cathode (tige courte, entrée d'électrons) ; libère de l'énergie sous forme de
    lumière monochromatique (verte, rouge, jaune…) selon le semi-conducteur ; faible consommation,
    usages (voyants, affichage de chiffres/lettres/images, montres, calculatrices, panneaux
    lumineux).
- **Concepts / notions** : dipôle (deux bornes) ; circuit électrique fermé / ouvert ; générateur
  / récepteur ; effets du courant (thermique, chimique, magnétique, lumineux) ; conducteur /
  isolant ; mauvais conducteur (air humide, eau, corps humain) ; symboles normalisés ; sens
  conventionnel du courant (borne + → borne -, à l'extérieur du générateur) ; nature du courant
  (électrons de conduction dans les métaux ; ions — cations/anions — dans les électrolytes) ;
  diode (dipôle dissymétrique, sens passant/bloquant, anode/cathode) ; court-circuit et ses
  risques (dipôle hors usage, incendie côté générateur).
- **Vocabulaire officiel** : « dipôle », « circuit électrique fermé/ouvert », « générateur »,
  « récepteur », « effet thermique/chimique/magnétique/lumineux », « conducteur », « isolant »,
  « électron de conduction », « électrolyte », « cation », « anion », « diode », « anode »,
  « cathode », « sens passant », « sens bloquant », « court-circuit », « DEL (diode
  électroluminescente) ».
- **Bornes de scope** :
  - ✅ **INCLUS** : notion de dipôle et de circuit fermé/ouvert ; générateur vs récepteur ;
    conducteurs/isolants (comportement qualitatif) ; les 4 effets du courant ; symboles
    normalisés et schématisation ; convention de sens du courant ; double nature du courant
    (électrons dans les métaux, ions dans les électrolytes) ; comportement dissymétrique d'une
    diode ; notion et dangers du court-circuit.
  - ⛔ **EXCLU (relève des chapitres suivants)** : association série/dérivation, notion de
    branche/nœud/maille, intensité du courant et ampèremètre, loi des nœuds (chapitre 3) ;
    tension électrique, voltmètre, loi des mailles (chapitre 4) ; loi d'Ohm, résistance,
    rhéostat (chapitre 5) — ce chapitre 2 pose le vocabulaire et les conventions de base, sans
    aucune mesure chiffrée d'intensité ou de tension.

## 2.3 Physique — Chapitre 3 : L'intensité du courant électrique (p.43–56, transcrit à profondeur de génération)

**Désignation imprimée (p.43)** : « **CHAPITRE III** » · thème « **L'ELECTRICITE** » · titre imprimé
« **L'INTENSITE DU COURANT** ». ⚠️ **Divergence imprimée, non arbitrée** : le sommaire p.4 titre « L'intensité
**du courant électrique** ». **Les deux sont imprimés** ; le titre de section ci-dessus reprend celui du
sommaire (§6.3).

- **Page d'ouverture** (p.43) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Associations de dipôles » ·
    « • Activités(II) : Intensité du courant électrique » · « • Activités(III) : Mesure de l'intensité d'un
    courant électrique dans une branche d'un circuit » · « • Activités(IV) : Intensité du courant dans un
    circuit en série » · « • Activités(V) : Intensité du courant dans un circuit en dérivation ». _(Les 5 sont
    bien imprimées dans le corps.)_
  - **Pré-requis** (verbatim) : « Circuit électrique et sa schématisation » · « Sens du courant électrique » ·
    « Conducteurs et isolants » · « Court-circuit ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.44–45) : différence d'éclairement de deux lampes ;
    filaments en tungstène plutôt qu'en fer/cuivre ; qu'est-ce qu'un ampèremètre, un calibre,
    précautions de mesure d'intensité dans une branche ; démarreur de voiture (batterie 12 V vs
    pile 12 V) ; sections des fils reliés à la batterie ; calibre des fusibles d'une voiture ;
    branchement en dérivation de récepteurs sans risque.
  - **Activités expérimentales** (p.46–49) — 5 blocs :
    1. **Activité I — Comment peut-on associer les dipôles ?** (p.46) : deux lampes, un
       générateur, un moteur → montages (a)–(g). Dans (a)(b) les quatre dipôles sont associés à
       la suite les uns des autres ; dans (c)–(g) non. Éclats des lampes et vitesse du moteur
       changent d'un montage à l'autre. **Généralisation officielle** : « Avec un générateur et
       deux dipôles ou plus, on peut avoir deux sortes de montages : montage où tous les dipôles
       sont branchés les uns à la suite des autres : un tel montage est appelé montage en série ;
       montage où les dipôles ne sont pas branchés les uns à la suite des autres : un tel montage
       est appelé montage en dérivation ou en parallèle. » « Dans un montage en parallèle
       comportant un seul dipôle générateur, on distingue plusieurs branches (une branche peut
       être constituée d'un dipôle ou de plusieurs dipôles montés en série) : une branche
       principale : c'est celle qui contient le générateur ; des branches dérivées : ce sont les
       branches formées de dipôles récepteurs. » « Chaque couple de branches constituant une
       boucle fermée est appelé maille. » « Le point de rencontre de plus de deux branches
       s'appelle un nœud. »
    2. **Activité II — Quelle grandeur caractérise un courant électrique ?** (p.46–47) : piles
       identiques, lampes identiques ; circuit (1) : L1 éclaire normalement ; circuit (2) : L2 et
       L3 éclairent faiblement. « La différence des effets est due à une grandeur qui caractérise
       le courant électrique : c'est son intensité. » « L'intensité d'un courant, notée I, est
       une grandeur mesurable qui s'exprime dans le système international en ampère de symbole
       (A). » « L'appareil de mesure d'une intensité de courant électrique est appelé
       ampèremètre. Il existe deux genres d'ampèremètres : ampèremètre à aiguille et ampèremètre
       numérique. » Encadré « Ce qu'il faut connaître sur l'ampèremètre » : borne A (rouge, +) et
       borne commune COM (noire, -) ; commutateur D.C/C.C ou A.C/C.A ; sélecteur de calibre ;
       cadran gradué + aiguille ou écran numérique. « On appelle calibre la plus grande intensité
       que peut mesurer l'ampèremètre. »
    3. **Activité III — Comment mesurer l'intensité d'un courant dans une branche d'un
       circuit ?** (p.47–48) : protocole détaillé — ouvrir l'interrupteur, ouvrir la branche à
       mesurer, insérer l'ampèremètre en série (courant entrant par A/+, sortant par COM/-),
       commutateur sur DC, sélecteur sur le plus grand calibre (10 A), fermer l'interrupteur,
       lire l'ordre de grandeur, ajuster au calibre immédiatement supérieur au résultat lu.
       Précision de lecture : sur une échelle de 100 graduations, une graduation = erreur de
       1 mA au calibre 100 mA, de 10 mA au calibre 1 A ; pour une mesure de 40 mA, une erreur de
       1 mA est acceptable, une erreur de 10 mA ne l'est pas. « Pour éviter de détériorer
       l'ampèremètre, on a intérêt à le brancher sur le plus grand calibre. » « Le plus petit
       calibre qui nous permet de faire la mesure fournit la valeur la plus précise. » Formule
       officielle pour appareil analogique : « Valeur = Lecture × Calibre / Echelle ». Question
       ouverte : ordres de grandeur d'intensités (extraction de l'aluminium de la bauxite, métro
       à 100 km/h, machine à laver, DEL, circuit intégré).
    4. **Activité IV — Quelle propriété vérifie l'intensité du courant dans un circuit en
       série ?** (p.48–49) : circuit série avec L1 et L2 (éclats différents) ; ampèremètre
       inséré à trois positions (générateur→L1, L1→L2, L2→générateur), ordre des lampes changé.
       « L'indication de l'ampèremètre est la même là où on l'insère. Elle est indépendante de
       l'ordre des composants dans le circuit. » Ajout d'une L3 en série : « L'intensité du
       courant diminue. » **Généralisation officielle** : « Dans un circuit en série, l'intensité
       du courant est la même dans tous les composants électriques qui le constituent (y compris
       le générateur). » « L'ajout d'un récepteur dans un circuit série entraîne une diminution
       de l'intensité du courant qui le parcourt. » « Si dans un circuit série aucun effet
       (magnétique, chimique, thermique ou lumineux) n'apparaît, on doit déduire que l'intensité
       du courant est nulle. » « Un courant nul, dans un circuit série, est dû à une discontinuité
       électrique dans le circuit (un appareil grillé ou un fil coupé ou un mauvais contact au
       niveau des bornes de connexion). »
    5. **Activité V — Quelle propriété vérifie l'intensité du courant dans un circuit en
       dérivation ?** (p.49) : ampèremètre dans chaque branche — A1 indique I1 = 0,90 A, A2
       indique I2 = 0,65 A, A3 indique I3 = 0,25 A. « L'intensité I1 du courant dans la branche
       principale est supérieure aux intensités I2 et I3 des courants dans les branches
       dérivées. » « Les intensités I1, I2 et I3 sont liées par la relation : I1 = I2 + I3. »
       « L'intensité du courant dans la branche principale est égale à la somme des intensités
       des courants dans les branches dérivées. » Ajout d'une branche L4/A4 en parallèle avec
       L1 : I'2 > I'4. **Loi des nœuds (officielle)** : « À chaque fois qu'un courant rencontre
       un nœud, il se divise entre les branches. Loi des nœuds : La somme des intensités des
       courants qui arrivent à un nœud est égale à la somme des intensités des courants qui en
       partent. » Questions ouvertes : effet d'une lampe grillée sur les intensités.
  - **Fiche T.P.** (p.50) « Loi des nœuds » : buts (réaliser un circuit, mesurer des intensités,
    vérifier la loi des nœuds) ; matériel (générateur continu, interrupteur, moteur, ampèremètre
    ou multimètre, lampe, fils de connexion) ; deux expérimentations (circuit en série : mesurer
    l'intensité traversant chaque dipôle, conclure ; circuit en dérivation : mesurer l'intensité
    de chaque branche, conclure).
  - **Recherche documentaire** (p.51) « Danger et sécurité » : le corps humain n'est ni bon
    conducteur ni isolant ; tableau officiel Intensité → Conséquences : 30 mA → paralysie
    musculaire, 50 mA → asphyxie, 100 mA → fibrillation du cœur ; pictogrammes de sécurité
    (pieds dans l'eau, isolation défectueuse, objets conducteurs dans une prise, cordon tiré
    brutalement, appareil non débranché avant réparation) ; 4 questions (sens de « fibrillation »,
    « asphyxie », « paralysie » ; conditions d'usage sans crainte ; sèche-cheveux en salle de
    bain ; premiers gestes en cas d'électrocution).
  - **L'essentiel du cours** (p.52, verbatim) :
    - « Avec un ensemble de dipôles électriques, on peut réaliser deux types de montages :
      montage en série : les différents dipôles sont liés les uns à la suite des autres ;
      montages en dérivation : les différents dipôles ne sont pas liés les uns à la suite des
      autres. »
    - « Dans un montage en parallèle comportant un seul dipôle générateur, on distingue
      plusieurs branches (une branche peut être constituée d'un dipôle ou de plusieurs dipôles
      montés en série) : une branche principale : c'est celle qui contient le générateur ; des
      branches dérivées : ce sont les branches formées de dipôles récepteurs. »
    - « Le point de rencontre de plus de deux branches s'appelle un nœud. »
    - « Entre deux nœuds consécutifs l'association en série de dipôles constitue une branche. »
    - « Chaque couple de branches constituant une boucle fermée est appelé maille. »
    - « À un courant électrique est associé une grandeur mesurable appelée intensité du courant,
      symbolisée par I et exprimée en ampère de symbole (A). »
    - « L'intensité d'un courant est mesurée à l'aide d'un appareil appelé ampèremètre. »
    - « Dans un circuit série l'intensité du courant est la même en tous ses points. »
    - « En un nœud d'un circuit en dérivation, la somme des intensités des courants qui y
      arrivent est égale à la somme des intensités des courants qui en partent. »
    - « Un fusible est un dipôle qui protège les composants d'un circuit électrique en fondant
      rapidement dès que l'intensité du courant qui le traverse dépasse une valeur donnée. »
  - **Aperçu historique** (p.52) : recherche internet sur le savant **Ampère (1775–1836)**.
  - **Exercice résolu** (p.53) : circuit avec L1 (I1 = 30 mA) et générateur (I = 80 mA). 1/-
    calculer I2 traversant L2 (loi des nœuds : I1 + I2 = I → I2 = 50 mA). 2/- inversion des
    branchements du générateur — éclat des lampes inchangé (dipôles symétriques, intensité
    débitée inchangée). 3/- L1 détériorée — I change (devient environ égale à celle qui
    traversait L2 avant que L1 ne soit grillée).
  - **Exercices** (p.54–56) : « Vérifier ses acquis » — compléter (unité SI de l'intensité ;
    précision de lecture liée au plus petit calibre ; loi des nœuds — arrivent/partent) ;
    vrai/faux motivé (intensité dans une branche vs générateur ; ampèremètres en circuit série
    ouvert ; influence de l'intensité sur l'éclairement) ; choisir le(s) mot(s) exact(s)
    (température qui augmente avec l'intensité — tungstène vs fer ; intensité du courant
    principal qui diminue quand on ajoute des récepteurs en dérivation ; effets d'un
    court-circuit — augmentation d'intensité, protection par fusible). « Utiliser ses acquis dans
    des situations simples » (p.54–55) : QCM courant traversant un générateur quand on dévisse
    une lampe (série/dérivation/circuit ouvert) ; schéma d'un circuit série (pile, deux lampes,
    ampèremètre, diode, interrupteur) avec repérage de la borne COM ; choix de calibre pour un
    ampèremètre à calibres 1 mA/10 mA/100 mA/1 A/10 A, et pour une intensité connue de 0,02 A.
    « Utiliser ses acquis pour une synthèse » (p.55–56) : montage domestique série/parallèle des
    lampes et appareils électroménagers, influence sur l'éclairement d'une pièce, calibre 20 A
    d'une prise avec machine à laver (12 A) + plaque chauffante (10 A) ; identification
    série/dérivation sur 4 montages (a)(b)(c)(d) et comparaison des éclats ; circuit à
    plusieurs nœuds avec relations entre I, I1…I6 (I = 1 A, I1 = 600 mA, I5 = 50 mA, I6 = 0,8 A)
    à résoudre, puis lecture d'un ampèremètre calibre 1 A / échelle 100 divisions.
  - **Savoir plus** (p.56) « Les fusibles » : fusibilité = tendance d'un métal chauffé à passer
    de l'état solide à l'état liquide (fusion nette pour étain/plomb, graduelle pour le fer) ;
    fusible = petit morceau de conducteur chauffant puis fondant avant les autres éléments du
    circuit ; fil en aluminium le plus souvent, calibre fonction de la section du fil ; exemples
    de calibres réels — circuit d'éclairage : fusible 10 A, circuit avec machine à laver : 16 A ;
    fusibles généraux d'une voiture 80 A → 200 A, fusibles de fonction 10 A → 50 A.
- **Concepts / notions** : montage série vs dérivation (parallèle) ; branche principale / branche
  dérivée ; nœud ; maille ; intensité du courant (I, ampère A) ; ampèremètre (borne A/COM,
  commutateur DC/AC, calibre, échelle) ; méthode de choix du calibre (du plus grand vers le plus
  petit adapté) ; formule Valeur = Lecture × Calibre / Échelle ; conservation de l'intensité en
  série ; loi des nœuds en dérivation ; fusible (protection par fusion).
- **Vocabulaire officiel** : « montage en série », « montage en dérivation/parallèle », « branche
  principale », « branche dérivée », « nœud », « maille », « intensité », « ampère (A) »,
  « ampèremètre », « calibre », « loi des nœuds », « fusible ».
- **Bornes de scope** :
  - ✅ **INCLUS** : distinction série/dérivation et vocabulaire associé (branche, nœud, maille) ;
    définition et mesure de l'intensité (ampère, ampèremètre, choix de calibre, précision) ;
    conservation de l'intensité en série ; loi des nœuds (addition simple des intensités) ;
    notion et rôle du fusible ; dangers électriques liés à l'intensité (tableau
    intensité/conséquences).
  - ⛔ **EXCLU (relève des chapitres suivants)** : tension électrique, voltmètre, loi des mailles,
    caractère algébrique de la tension (chapitre 4) ; loi d'Ohm, résistance, caractéristique
    intensité-tension, rhéostat (chapitre 5) — ce chapitre 3 ne traite que l'intensité, jamais la
    tension ni la relation U=f(I).

## 2.4 Physique — Chapitre 4 : La tension électrique (p.57–70, transcrit à profondeur de génération)

**Désignation imprimée (p.57)** : « **CHAPITRE IV** » · thème « **L'ELECTRICITE** » · titre « **LA TENSION
ELECTRIQUE** » — concordant avec le sommaire p.4.

- **Page d'ouverture** (p.57) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : La tension électrique » ·
    « • Activités(II) : Mesure d'une tension aux bornes d'un dipôle isolé » · « • Activités(III) : Mesure d'une
    tension aux bornes d'un dipôle placé dans un circuit fermé » · « • Activités(IV) : La tension est une
    grandeur algébrique » · « • Activités(V) : Loi des mailles » · « • Activités(VI) : Visualisation d'une
    tension à l'oscilloscope ». _(Les 6 sont bien imprimées dans le corps.)_
  - **Pré-requis** (verbatim) : « Dipôle générateur et dipôle récepteur » · « Dipôle isolé et dipôle en circuit
    fermé » · « Circuit en série et circuit en dérivation ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.58–59) : indications « 4,5 V ; 40 mA » sur une lampe ;
    différence entre une lampe et une pile portant toutes deux l'indication 4,5 V ; symbole sur
    un poteau de ligne de tension et dangers d'une ligne haute tension ; ligne de tension à un
    seul fil (possible ou non) ; indication « 0,035 V » relevée sur un citron et appareil utilisé
    pour la mesurer ; lampes d'une guirlande qui éclairent de la même façon et effet du grillage
    d'une lampe sur les autres.
  - **Activités expérimentales** (p.60–63) — 6 blocs :
    1. **Activité I — Que signifient les valeurs numériques suivies de la lettre V ?** (p.60) :
       relevés d'indications sur piles (1,5 V, 4,5 V, 9 V), générateurs de T.P. (6 V, 12 V,
       30 V), compteur STEG (220 V), lampes (3 V, 6 V, 12 V, 220 V). « Une des grandeurs
       électriques qui caractérise un dipôle, c'est la tension à ses bornes. […] Elle s'exprime
       dans le système international en volt de symbole (V) et se mesure par un appareil appelé
       voltmètre. » Encadré « Ce qu'il faut connaître sur le voltmètre » : borne A (rouge, +) et
       borne commune COM (noire, -) ; commutateur DC/CC/V et AC/CA/V ; sélecteur de calibre ;
       cadran gradué + aiguille ou écran numérique — même structure que l'ampèremètre.
    2. **Activité II — Comment mesurer la tension aux bornes d'un dipôle isolé ?** (p.60–61) :
       tableau de mesures — Pile(1) 4,4 V, Lampe 0, Moteur 0, Interrupteur ouvert 0, Interrupteur
       fermé 0, Pile(2) 9,0 V, Ampèremètre 0, Diode 0. « La tension aux bornes d'une pile isolée
       n'est pas nulle. Elle vaut approximativement ce qui est indiqué sur la pile. » « La tension
       aux bornes d'une lampe, d'un moteur, d'une diode… non insérés dans un circuit est nulle. »
       **Généralisation officielle** : « Un dipôle isolé aux bornes duquel il existe une tension
       est un dipôle générateur. Un dipôle isolé aux bornes duquel il n'existe pas une tension
       est un dipôle récepteur. » Distinction f.é.m. / tension nominale : « pour un générateur,
       la tension indiquée désigne la tension à vide (lorsqu'il n'est branché à aucun dipôle
       récepteur) appelée aussi la force électromotrice (f.e.m) du générateur » ; « pour les
       dipôles récepteurs, l'indication de la tension renseigne sur la tension, appelée tension
       nominale, qu'on doit appliquer à ses bornes pour qu'ils fonctionnent normalement (une
       tension plus faible ne le met pas en fonctionnement de manière satisfaisante et une
       tension plus grande le détériore). » Question ouverte : ordres de grandeur de tensions
       nominales (LED, lampe de torche, lampe de voiture, poste radio de poche, télévision,
       métro).
    3. **Activité III — Comment mesurer la tension aux bornes d'un dipôle placé dans un
       circuit ?** (p.61–62) : voltmètre en dérivation, borne V reliée à la borne d'entrée du
       courant. Tableau de mesures (interrupteur ouvert : pile 4,50 V / lampe 0 V, intensité
       0 A ; interrupteur fermé : pile 4,44 V / lampe 3,50 V, intensité 0,3 A). « En circuit
       ouvert : la tension aux bornes d'un dipôle générateur n'est pas nulle, alors qu'elle est
       nulle aux bornes de tout autre dipôle récepteur ; aucun dipôle n'est traversé par un
       courant. » « En circuit fermé : on mesure une tension non nulle aux bornes du dipôle
       générateur ainsi qu'aux bornes de tout autre dipôle récepteur ; la lampe, le moteur ainsi
       que le générateur sont parcourus par un courant d'intensité non nulle. »
    4. **Activité IV — La tension est-elle toujours positive ?** (p.62) : inversion des
       connexions du générateur, voltmètre numérique, borne V reliée à la borne A de la lampe →
       lecture négative, même valeur absolue. « La tension aux bornes d'un dipôle peut avoir une
       valeur positive ou négative. La tension est une grandeur algébrique. » Notation officielle
       : « On notera UAB la tension, aux bornes d'un dipôle, indiquée par un voltmètre dont la
       borne « V » est reliée à A et sa borne « COM » est reliée à B. On symbolisera cette
       tension par une flèche dirigée de B vers A. » « La tension UAB aux bornes d'un dipôle est
       positive si le courant arrive au dipôle placé entre A et B par A, et négative dans le cas
       contraire. » « La tension UAB aux bornes d'un dipôle est aussi appelée différence de
       potentiel (d.d.p en abrégé). On la note VA-VB. » Remarque sur le lien signe/borne du
       générateur (borne + reliée à V → lecture positive ; borne + reliée à COM → lecture
       négative).
    5. **Activité V — Par quelle loi sont régies les tensions aux bornes des dipôles d'une
       maille ?** (p.62–63) : montage avec mesures UAB = 5,5 V, UBC = 3,5 V, UNP = -9,0 V,
       UEF = 9,0 V, UAP = 0 V. « Aux bornes d'un fil conducteur parcouru par un courant la
       tension est nulle. » « UPA+UAB+UBC+UCN+UNP=0 et UAE+UEF+UFC+UCB+UBA=0. » **Loi des mailles
       (officielle)** : « Dans une maille la somme algébrique des tensions aux bornes des
       différents composants qui la constituent est nulle. » Questions ouvertes : intensité dans
       AE ; déduction de UCN, UEA, UCF, UPN sans refaire les mesures ; tableau interrupteur
       ouvert ; tension entre E et F si L2 court-circuitée ; relation entre tensions en série ;
       précaution d'achat d'un poste radio sur secteur.
    6. **Activité VI — Peut-on visualiser une tension et mesurer sa valeur ?** (p.63) :
       oscilloscope (écran gradué, boutons de réglage, voies X et Y) ; segment horizontal réglé
       sur la voie X ; pile plate branchée aux bornes de la voie X ; sensibilité verticale 2 V/div
       → déviation de 2,2 divisions (vers le haut ou le bas selon le branchement). « L'oscillogramme
       (le graphe) de la tension aux bornes de la pile est un trait horizontal lorsque le balayage
       est déclenché, cela signifie que cette tension ne varie pas au cours du temps : elle est
       dite tension continue. »
  - **Fiche T.P.** (p.64) « Loi des mailles » : buts (réaliser un circuit, mesurer des tensions,
    vérifier la loi des mailles) ; matériel (générateur continu, interrupteur, moteur, voltmètre
    ou multimètre ou oscilloscope, lampe, fils de connexion) ; deux expérimentations (circuit en
    série : tensions aux bornes de chaque dipôle, conclure ; circuit en dérivation : idem,
    conclure).
  - **Activité documentaire** (p.65) « L'anguille électrique » : gymnote, poisson allongé
    (jusqu'à 2,5 m), bassin de l'Amazone, deux organes électriques dans les flancs (tête = pôle
    positif, queue = pôle négatif, analogie avec une pile de Volta) ; décharges de tension
    600 volts pour détecter/étourdir ses proies ; 4 questions (sens de « vaseux »/« anguille »,
    pourquoi ce nom, organes électriques, mode de défense).
  - **L'essentiel du cours** (p.66, verbatim) :
    - « La tension est une grandeur qui caractérise un dipôle. Elle s'exprime en volt de symbole
      (V), et se mesure à l'aide d'un appareil appelé voltmètre. »
    - « Le voltmètre se branche en dérivation avec le dipôle aux bornes duquel on désire mesurer
      la tension. »
    - « La tension aux bornes d'un dipôle générateur isolé est non nulle. »
    - « La tension aux bornes d'un dipôle récepteur isolé est nulle. »
    - « La tension indiquée sur un dipôle récepteur est appelée sa tension nominale. Sous cette
      tension le dipôle fonctionne normalement. »
    - « La tension aux bornes d'un dipôle générateur inséré dans un circuit fermé est non
      nulle. »
    - « La tension aux bornes d'un dipôle récepteur inséré dans un circuit est non nulle. Sa
      valeur dépend des composants du circuit. »
    - « La tension aux bornes A et B d'un dipôle est notée UAB. Elle est représentée par une
      flèche allant de B vers A. »
    - « La tension est une grandeur algébrique : UAB = -UBA. »
    - « UAB est positive si un voltmètre, branché entre A et B, indique une valeur positive
      lorsque sa borne COM (ou noire ou -) est reliée à B. »
    - « Loi des mailles : la somme algébrique des tensions aux bornes des différents dipôles
      d'une maille d'un circuit est égale à zéro. »
    - « Pour une bonne utilisation des composants électriques, il ne faut jamais les soumettre à
      des tensions éloignées de leur tension nominale. »
  - **Aperçu historique** (p.66) : recherche internet sur le savant **Volta (1745–1827)**.
  - **Exercice résolu** (p.67) : circuit avec quatre lampes identiques, U aux bornes du générateur
    = 6 V. 1/- a) sens du courant dans les trois branches (toujours du + vers le - du
    générateur) ; b) I″ (à travers L2) = 90 mA, I (débitée) = 240 mA → I′ (à travers L4), par la
    loi des nœuds I = I′ + I″ → I′ = 150 mA. 2/- a) loi des mailles : U - U1 - U2 - U3 = 0 et
    U - U4 = 0 ; lampes identiques → U1 = U2 = U3 = U/3 = 2 V et U4 = U = 6 V ; b) L1, L2, L3 en
    série éclairent de la même manière mais moins fortement que L4 (courant plus intense).
  - **Exercices** (p.68–70) : « Vérifier ses acquis » — compléter (passage de courant nécessite
    une tension entre deux points ; instruments de mesure de tension branchés en dérivation ;
    somme algébrique des tensions sur une maille = zéro) ; vrai/faux motivé (« l'unité de la
    tension est le voltmètre » — piège terminologique volt/voltmètre ; tension pouvant être
    négative ; absence de tension si absence de courant) ; choisir le(s) mot(s) exact(s)
    (tension nécessaire = égale à la tension nominale ; tension aux bornes d'un interrupteur
    fermé/ouvert ; UAB vs UBA selon COM/V). « Utiliser ses acquis dans des situations simples »
    (p.68–69) : installation domestique 220 V — montage série/mixte/parallèle et comparaison
    d'éclairement selon montage série vs dérivation avec le secteur ; protocole prouvant
    l'indépendance de la relation des tensions à l'ordre de montage en série ; circuit avec
    tension du générateur = tension nominale des deux lampes en série (correction du montage).
    « Utiliser ses acquis pour une synthèse » (p.69) : indication d'un voltmètre entre A et B
    selon K ouvert/fermé et nom du dipôle AB quand K fermé ; trois lampes (3V-300mA, 1,2V-100mA,
    12V-10A) et moteur de tension nominale 6V — état de fonctionnement de chaque lampe insérée
    entre A et B ; tableau de mesures voltmètre 100 divisions à calibres 1/3/30/100 V à
    compléter ; circuit générateur 12 V, trois lampes identiques 6 V chacune — tensions et état
    de fonctionnement selon K ouvert/fermé.
  - **Savoir plus** (p.70) « L'électrocardiogramme » : William Eintroven (1903, physiologue
    hollandais), différences de potentiel entre points du corps liées à l'activité cardiaque ;
    oreillettes/ventricules assimilés aux bornes d'un générateur ; neuf électrodes (poignets,
    pied gauche, six sur le thorax) reliées à un voltmètre ; électrocardiogrammes comparés
    (sujet avec troubles cardiaques vs sujet en bonne santé).
- **Concepts / notions** : tension (volt, V) ; voltmètre (branchement en dérivation, borne
  A/COM) ; dipôle isolé générateur (tension non nulle) vs récepteur (tension nulle) ; f.é.m.
  (tension à vide) vs tension nominale ; tension en circuit fermé (générateur et récepteur) ;
  caractère algébrique de la tension, notation UAB, flèche de B vers A ; différence de potentiel
  (d.d.p.) ; loi des mailles ; oscilloscope et tension continue.
- **Vocabulaire officiel** : « tension », « volt (V) », « voltmètre », « tension à vide »,
  « force électromotrice (f.e.m) », « tension nominale », « UAB », « différence de potentiel
  (d.d.p) », « loi des mailles », « oscilloscope », « tension continue ».
- **Bornes de scope** :
  - ✅ **INCLUS** : mesure de la tension (voltmètre, branchement en dérivation) ; distinction
    dipôle isolé générateur/récepteur par la tension ; f.é.m. vs tension nominale ; tension en
    circuit fermé ; caractère algébrique de la tension et notation UAB ; loi des mailles ;
    notion qualitative d'oscilloscope et de tension continue (pas de tension variable/alternative
    étudiée en détail à ce stade).
  - ⛔ **EXCLU (relève du chapitre suivant)** : loi d'Ohm, résistance, caractéristique
    intensité-tension, rhéostat, code des couleurs des résistors (chapitre 5) — ce chapitre 4
    définit la tension et la loi des mailles, sans jamais relier U et I par une loi de
    proportionnalité.

## 2.5 Physique — Chapitre 5 : Le dipôle résistor (p.71–86, transcrit à profondeur de génération)

**Désignation imprimée (p.71)** : « **CHAPITRE V** » · thème « **L'ELECTRICITE** » · titre imprimé
« **CARACTERISTIQUE D'UN DIPÔLE RESISTOR** ». ⚠️ **Divergence imprimée, non arbitrée** : le sommaire p.4 titre
« Le **dipôle résistor** ». **Les deux sont imprimés** ; le titre de section ci-dessus reprend celui du sommaire
(§6.3).

- **Page d'ouverture** (p.71) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Caractéristique d'un dipôle » ·
    « • Activités(II) : Caractéristique d'un résistor : loi d'Ohm » · « • Activités(III) : Détermination de la
    résistance d'un résistor. » · « • Activités(IV) : Rôle d'un rhéostat dans un circuit » · « • Activités(V) :
    Exemples de caractéristiques de dipôles ».
    ⚠️ **Incohérence de la source (signalée, non arbitrée — §6.3)** : le plan annonce **5** activités, le corps
    n'en imprime que **4** — **il n'existe aucune « ACTIVITES (III) »** dans le chapitre. Le contenu annoncé
    comme III est traité **p.76 dans un encadré NON numéroté** (« Mesure de la résistance d'un résistor ») + le
    code des couleurs p.77. La numérotation officielle IV et V est conservée telle qu'imprimée (elle n'est pas
    renumérotée en 3 et 4).
  - **Pré-requis** (verbatim) : « Mesurer une intensité » · « Mesurer une tension » · « Choisir un calibre » ·
    « Tracer un graphique dans un repère cartésien ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.72–73) : deux abat-jour en série qui éclairent mal bien
    que non grillés et sous 220 V (quelle relation doit exister entre tension et intensité pour un
    fonctionnement normal ?) ; dipôles à anneaux colorés sur un circuit imprimé (nom, rôle,
    signification des anneaux) ; commandes d'un sèche-cheveux (quelle grandeur électrique
    varie-t-on ?) ; ohmmètre et conductibilité du corps humain, protection contre une
    électrocution à 10 mA.
  - **Activités expérimentales** (p.74–79) — 5 blocs :
    1. **Activité I — Y a-t-il une relation entre la tension d'un générateur et l'intensité qu'il
       débite dans un dipôle récepteur ?** (p.74) : générateur de tension réglable, trois dipôles
       récepteurs D1, D2, D3 branchés successivement ; intensités I1, I2, I3 différentes.
       « L'intensité du courant débitée par un générateur dépend du dipôle récepteur qui lui est
       relié. » Puis un seul dipôle D, tension variable U1, U2, U3 → intensités I1, I2, I3
       différentes. **Généralisation officielle** : « Entre la tension U appliquée aux bornes
       d'un dipôle récepteur et l'intensité I du courant qui le parcourt, il existe une relation
       qu'on notera U=f(I) ou I=g(U). » « La courbe représentant la relation U=f(I) relative à un
       dipôle (D) est appelée caractéristique intensité-tension de (D). La courbe représentant la
       relation I=g(U) relative à un dipôle (D) est appelée caractéristique tension-intensité de
       (D). »
    2. **Activité II — Quelle relation a-t-on entre la tension et l'intensité pour un dipôle
       résistor ?** (p.75–76) : montage avec générateur réglable (0–30 V), potentiomètre (P) d'un
       poste radio, ampèremètre, voltmètre. Relevé de couples (I,U) — U(V) : 0, 2, 5, 8, 12, 15 ;
       I(mA) : 0, 2,9, 7,2, 11,4, 17,2, 21,5. Points quasi alignés, droite passant par l'origine.
       « Le tracé de la variation de U=f(I) donne une portion de droite qui passe par l'origine.
       Cela montre qu'entre la tension aux bornes du potentiomètre et l'intensité du courant qui
       le traverse, il existe une relation de proportionnalité. » **Généralisation officielle
       (dipôle résistor)** : « La caractéristique intensité-tension du dipôle étudié est une
       portion de droite passant par l'origine : la tension et l'intensité du courant sont
       proportionnelles. Un tel dipôle est appelé dipôle résistor ou conducteur ohmique. » « Le
       coefficient de proportionnalité est noté R ; soit : R = U/I. » Deuxième composant (D) —
       couples U(V) : 2, 12, 21 ; I(mA) : 91, 545, 955 ; rapport constant U1/I1 = U2/I2 = U3/I3 =
       220 V·A⁻¹. « Le dipôle (D) est donc un résistor. » Comparaison à tension égale (12 V) :
       potentiomètre 17,2 mA vs résistor (D) 545 mA → « Le potentiomètre a résisté plus que le
       résistor (D) au passage du courant. » « R caractérise la résistance plus ou moins grande
       d'un dipôle au passage du courant. Cette nouvelle grandeur R caractérisant un résistor est
       appelée résistance du résistor. » « R est une grandeur mesurable, elle s'exprime dans le
       système international en ohm de symbole (Ω). » **Loi d'Ohm (officielle)** : « La tension U
       aux bornes d'un résistor (ou conducteur ohmique), de résistance R est égale au produit de
       la résistance R par l'intensité du courant I qui le traverse : U = R.I. » Encadré « Mesure
       de la résistance d'un résistor » : usage de l'ohmmètre/multimètre — sélecteur sur calibre
       Ω, branchement entre COM et V-Ω, lecture directe, dépassement de calibre signalé « I. » sur
       l'écran (changer de calibre). Exemples réels de lecture par code de couleurs (p.76) : R =
       220 Ω et R = 6000 Ω = 6 kΩ. Remarque sur la résistance du corps humain (p.76–77) : varie
       selon l'individu, dépend de l'état de la peau (enfants — peau fine — résistance plus
       faible ; adultes — peau épaisse/sèche — résistance plus grande) ; diminue si la peau est
       mouillée ; passage de 10 mA pendant plus de 30 s peut entraîner la mort ; valeurs
       officielles : 5000 Ω (corps sec), 1000 Ω (corps mouillé) ; seuils de tension dangereuse :
       25 V en milieu humide (I=U/R=25/1000=25mA), 50 V en conditions habituelles
       (I=U/R=50/5000=10mA).
    3. **Activité IV — Comment ajuster la tension et l'intensité dans un circuit pour faire
       fonctionner normalement un dipôle ?** (p.77–78) : cas d'une lampe (3,5 V - 350 mA) reliée
       à un générateur fournissant 9 V constants — impossible en direct. Introduction du rhéostat
       (enroulement de fil métallique, bornes A/B en totalité ou A/C-B/C en partie) : mesure
       RAC = 100 Ω puis, curseur déplacé, RAC = 40 Ω → « En déplaçant le curseur (C), la
       résistance RAC de la partie située entre A et C varie. » Montage complet avec la lampe :
       curseur à l'extrémité côté B non connectée → lampe éteinte, voltmètre 0,02 V, ampèremètre
       9 mA ; curseur déplacé d'environ 2/3 de la longueur → voltmètre 3,5 V, ampèremètre 300 mA,
       lampe brille normalement. ⚠️ **Écart de la source, signalé non arbitré (§6.3)** : la lampe
       est donnée « (3,5 V - 350 mA) » par l'Activité IV **elle-même** (p.77), mais le relevé
       imprimé pour « la lampe brille normalement » indique **300 mA**. « Lorsqu'on utilise la borne reliée
       au curseur et l'une de ses deux autres bornes, un rhéostat permet, lorsqu'il est introduit
       dans une branche d'un circuit, de commander l'intensité du courant qui le traverse. »
       Questions ouvertes : effet de poursuivre le déplacement de C vers A ; exemples
       d'appareils domestiques à résistance réglable.
       (Note : l'« Activité III » de la table des matières — « Détermination de la résistance
       d'un résistor » — est traitée en pratique à l'intérieur de l'Activité II via l'encadré
       ohmmètre/code des couleurs plutôt que comme bloc séparé numéroté dans le texte extrait ;
       aucune section autonome intitulée « ACTIVITES (III) » n'apparaît dans le flux de la page
       76-77.)
    4. **Activité V — Les dipôles ont-ils tous des caractéristiques de même forme ?** (p.79) :
       trois caractéristiques présentées. ⚠️ La p.79 n'imprime **que les trois légendes** — «
       Caractéristique d'une lampe à incandescence » / « …d'un électrolyseur » / « …d'une diode » —
       et **aucune description d'allure** : les trois courbes sont des **images non rendues**
       (§6.2). Le seul énoncé du manuel sur leur forme est **ailleurs**, dans L'essentiel p.82 : «
       Les dipôles n'ont pas tous des caractéristiques de même allure. »
  - **Fiche T.P.** (p.80) « Loi d'Ohm » : buts (réaliser un circuit, mesurer tensions et
    intensités, tracer la caractéristique intensité-tension d'un résistor, vérifier la loi d'Ohm,
    utiliser un ohmmètre, comparer résistance graphique et résistance affichée par l'ohmmètre) ;
    matériel (générateur continu, dipôle résistor, rhéostat, interrupteur, voltmètre, ampèremètre,
    fils de connexion, ohmmètre) ; protocole (varier U via le curseur du rhéostat, mesurer I pour
    différentes valeurs de U, tracer la caractéristique, interpréter, déduire la loi liant U à I,
    déterminer R graphiquement, vérifier à l'ohmmètre).
  - **Recherche documentaire** (p.81) « Photorésistance et thermistance » : photorésistance (LDR,
    Light Dependant Resistor) — résistance sensible à la lumière, très élevée dans l'obscurité
    (« plusieurs milliers d'Ohms »), ne laisse passer un courant que si éclairée ; usages
    (escalator, alarme, allumage automatique nocturne, posemètre photographique) ; thermistance
    (CTN, Coefficient de Température Négatif) — résistance sensible à la chaleur, grande à 20°C,
    ne laisse passer un courant appréciable que chauffée ; usages (commande de lampe/ventilateur,
    détecteur d'incendie, thermomètre digital, bolomètre) ; 3 questions (sens de « bolomètre »,
    différence LDR/CTN, exemples d'applications).
  - **L'essentiel du cours** (p.82, verbatim) :
    - « La tension U aux bornes d'un dipôle et l'intensité I qui le parcourt sont liées par une
      relation. »
    - « Pour un dipôle résistor cette relation est de la forme : U = R.I. »
    - « La courbe représentant les variations de la tension U aux bornes d'un dipôle en fonction
      de l'intensité I qui le traverse est appelée caractéristique intensité-tension du dipôle.
      Pour un dipôle résistor elle est une portion de droite qui passe par l'origine. »
    - « Un résistor est caractérisé par sa résistance notée R qui est une grandeur mesurable.
      Elle s'exprime en ohm de symbole (Ω) et se mesure à l'aide d'un ohmmètre (ou se lit
      directement sur le résistor ou à l'aide d'un code de couleurs). »
    - « Pour commander l'intensité du courant dans un circuit électrique (ou électronique), on
      insère un résistor réglable appelé rhéostat. »
    - « Les dipôles n'ont pas tous des caractéristiques de même allure. Ils ne réalisent pas
      donc, des relations tension-intensité de la même forme. »
  - **Aperçu historique** (p.82) : recherche internet sur le savant **Ohm** — le texte imprime
    « (1745/1827) », dates identiques à celles données pour Volta au chapitre 4 ; il s'agit très
    vraisemblablement d'une coquille d'impression du manuel (Georg Simon Ohm a vécu 1789–1854) —
    signalé ici tel quel, sans correction, car reproduction fidèle du texte source.
  - **Exercice résolu** (p.83) : trois graphes de caractéristiques intensité-tension. 1/-
    identifier lequel correspond à un résistor (le graphe (2), portion de droite passant par
    l'origine). 2/- tension pour I=20 mA → U=9,4 V (lecture graphique). 3/- R = U/I =
    9,4/0,02 = 470 Ω. 4/- dessiner le résistor avec anneaux colorés correspondant à 470 Ω
    (code des couleurs).
  - **Exercices** (p.84–86) : « Vérifier ses acquis » — compléter (caractéristique d'un résistor/
    conducteur ohmique = droite passant par l'origine ; unité et symbole de la résistance : ohm,
    Ω ; loi d'Ohm : produit de la résistance par l'intensité) ; vrai/faux motivé (comportement du
    résistor selon le sens du courant — dipôle symétrique ; droite affine ≠ nécessairement un
    résistor pur passant par l'origine ; relation résistance du circuit / intensité inversement
    proportionnelle, pas directement) ; choisir le(s) mot(s) exact(s) (diode = dipôle asymétrique,
    caractéristique différente du résistor ; résistance d'une lampe à incandescence qui dépend du
    courant, caractéristique différente d'un résistor ; conservation du nombre d'électrons dans
    une portion de conducteur — item récurrent depuis le chapitre 3). « Utiliser ses acquis dans
    des situations simples » (p.84–85) : QCM méthode de mesure de la résistance d'un résistor
    monté dans un circuit avec interrupteur K (ouvrir K et brancher l'ohmmètre) ; deux méthodes
    de détermination de la résistance avec schémas ; applications des résistors ; montage à
    corriger pour tracer correctement la caractéristique intensité-tension d'un résistor R.
    « Utiliser ses acquis pour une synthèse » (p.85–86) : diagnostic à l'ohmmètre d'un dipôle
    défectueux (lampe, résistor, interrupteur ou diode) dans un montage où la lampe ne s'allume
    pas ; lecture des valeurs de R1 et R2 par code des couleurs et comparaison de leur effet sur
    l'intensité en série ; choix de calibre du multimètre et comparaison avec le code des
    couleurs ; circuit avec résistor de 100 Ω et lampe (6 V - 50 mA) — représenter le sens
    conventionnel du courant, bornes COM/A du voltmètre et de l'ampèremètre, valeurs sous
    fonctionnement nominal, puis reconfiguration de branchement du voltmètre/ampèremètre et
    déduction de la tension aux bornes de la pile.
  - **Savoir plus** (p.86) « La supraconductivité » : disparition brutale et complète de la
    résistance électrique d'un matériau refroidi sous une température critique dépendant de sa
    nature ; courant établi dans un circuit supraconducteur se maintient à intensité constante
    en l'absence de générateur, sans perte d'énergie sous forme de chaleur ; découverte par le
    physicien hollandais Heike Kamerlingh Onnes (1853–1926) en 1911 avec le mercure refroidi à
    -269°C, puis le plomb (-266°C) ; à partir de 1986, céramiques supraconductrices à des
    températures plus élevées (-180°C à -147°C, atteignables à l'azote liquide -196°C) ;
    applications : câbles supraconducteurs (puissance de réfrigération 100 à 1000 fois plus
    faible que la puissance dissipée dans un câble de cuivre, densités de courant 100 fois
    supérieures), bobines pour accélérateurs de particules et IRMN, fusion nucléaire contrôlée
    (tokamaks), trains à lévitation magnétique.
- **Concepts / notions** : caractéristique intensité-tension U=f(I) / tension-intensité I=g(U) ;
  dipôle résistor (conducteur ohmique) ; proportionnalité U/I constante ; résistance R (ohm, Ω) ;
  loi d'Ohm U=R.I ; mesure de R (ohmmètre/multimètre, code des couleurs) ; rhéostat (résistance
  réglable, réglage de l'intensité) ; caractéristiques non linéaires (lampe à incandescence,
  électrolyseur, diode) ; résistance du corps humain et seuils de tension dangereuse ;
  photorésistance (LDR) et thermistance (CTN) comme applications de résistances variables.
- **Vocabulaire officiel** : « caractéristique intensité-tension », « caractéristique
  tension-intensité », « dipôle résistor », « conducteur ohmique », « résistance », « ohm (Ω) »,
  « loi d'Ohm », « ohmmètre », « code des couleurs », « rhéostat », « curseur ».
- **Bornes de scope** :
  - ✅ **INCLUS** : notion de caractéristique intensité-tension d'un dipôle ; identification du
    dipôle résistor par la proportionnalité U/I ; loi d'Ohm U=R.I ; résistance (unité, mesure à
    l'ohmmètre, lecture par code des couleurs) ; rôle du rhéostat pour ajuster l'intensité dans
    un circuit ; comparaison qualitative de caractéristiques non linéaires (lampe, électrolyseur,
    diode) sans étude quantitative de ces dernières ; sécurité électrique liée à R et U (seuils
    25 V/50 V).
  - ⛔ **EXCLU (hors programme de ce chapitre)** : association de résistances en série/parallèle
    et calcul de résistance équivalente (non traité dans le texte extrait de ce chapitre) ;
    puissance électrique et effet Joule quantifié (relève d'un chapitre distinct, non présent
    dans la plage p.72–87) ; étude quantitative détaillée des caractéristiques non linéaires
    (lampe, électrolyseur, diode) — seule leur existence et leur allure différente sont
    mentionnées.

## 2.6 Physique — Chapitre 6 : Les états physiques de la matière (p.87–100, transcrit à profondeur de génération)

**Désignation imprimée (p.87)** : « **CHAPITRE I** » · thème « **LA MATIERE** » · titre « **LES ETATS
PHYSIQUES DE LA MATIERE** » — concordant avec le sommaire p.4.

- **Page d'ouverture** (p.87) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Les états physiques de la matière » ·
    « • Activités(II) : Calcul et mesure de volumes » · « • Activités(III) : Relation entre certaines unités de
    mesure de volumes » · « • Activités(IV) : Propriétés caractéristiques des solides et des liquides » ·
    « • Activités(V) : Propriétés caractéristiques des gaz » · « • Activités(VI) : Description microscopique des
    états de la matière ».
    ⚠️ **Incohérence de la source (signalée, non arbitrée — §6.3)** : le corps du chapitre imprime **deux fois
    « ACTIVITES (II) »** (p.91) puis passe **directement à « ACTIVITES (IV) »** (p.92) — **aucune « ACTIVITES
    (III) »** n'est imprimée, alors que le plan en annonce une. La 2ᵉ « (II) » (« Utilise-t-on d'autres unités de
    volume ? ») correspond au contenu annoncé comme (III).
  - **Pré-requis** (verbatim) : « Mesure des longueurs » · « Unités de mesure des longueurs et des volumes » ·
    « Calcul des volumes de corps de formes géométriques simples ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.88–89) : quatre mises en situation illustrées — corps posés
    sur une table (« Peut-on classifier les corps posés sur la table en familles ayant des
    caractéristiques physiques communes ? », « Occupent-ils le même espace ? », « Quels sont les
    corps qu'on peut saisir entre les doigts ? ») ; l'eau et les roches (« A quel état faut-il
    transformer l'eau pour qu'elle ne coule plus ? », « Les roches coulent-elles ? Ont-elles une
    forme propre ? », « L'eau présente-t-elle une surface libre ? ») ; le sable (« Est-ce que le
    sable est un solide ? », « Est-ce qu'il peut couler comme les liquides ? », « Peut-on le saisir
    entre les doigts ? ») ; les gaz et la plongée (« Les gaz ont-ils une surface libre ? », « Comment
    le plongeur peut-il respirer sous l'eau pendant des heures avec une petite bouteille de gaz sur
    le dos ? »).
  - **Activités expérimentales** (p.90–94) — 6 blocs :
    1. **Activité I** — « Nos sens, peuvent-ils servir à reconnaître l'état physique d'un corps ? » :
       une bille en acier posée sur la table + de l'eau dans un cristallisoir, essai de préhension
       entre les doigts. La bille est saisissable (ne coule pas), l'eau ne l'est pas (elle coule et
       occupe une partie du volume qu'on lui offre). **Généralisations officielles** : « La bille en
       acier est saisissable entre les doigts : on dit que l'acier est à l'état solide. » / « L'eau
       n'est pas saisissable entre les doigts, elle coule de façon continue et occupe une partie du
       volume qu'on lui offre : on dit qu'elle est à l'état liquide. » Extension à d'autres solides
       (craie, clou, stylo, feuille, lunettes) et liquides (alcool, huile, mercure à température
       ordinaire). **Remarque officielle** : « Certains corps formés de petits grains tels que la
       farine, le sable, le sucre broyé, la semoule… coulent mais sont saisissables entre les
       doigts : ce sont des solides. » Puis un verre « vide » renversé sur un cristallisoir d'eau,
       incliné progressivement : des bulles en sortent en traversant la surface libre de l'eau.
       **Généralisations** : « Le verre "vide" est en réalité plein de matière appelée air. » / « Deux
       corps ne peuvent occuper simultanément le même espace. » / « L'air contenu initialement dans
       le verre coule n'est pas saisissable entre les doigts et occupe tout l'espace qu'on lui
       offre : on dit il est à l'état gazeux. » Extension à diiode, dioxygène, diazote, dichlore =
       des gaz. Question ouverte : « Est-il juste de dire que le verre est "vide", avant de l'avoir
       rempli d'eau ? » **Remarque (fluides)** : « Les liquides et les gaz sont insaisissables entre
       les doigts et s'écoulent facilement : ce sont des fluides. »
    2. **Activité II** — « Qu'appelle-t-on volume d'un corps ? » : trois corps en pâte à modeler (A),
       (B), (C) immergés successivement dans une éprouvette graduée contenant de l'eau colorée ;
       comparaison des niveaux nA, nB, nC. (A) fait monter le niveau plus haut que (B) ; (B) et (C)
       donnent le même niveau malgré des formes différentes. **Généralisations** : « Le volume d'un
       corps est une grandeur qui caractérise l'espace occupé par ce corps. » / « (B) et (C) ont des
       volumes égaux bien que leurs formes sont différentes. » / « Le volume d'un corps est une
       grandeur mesurable. Elle s'exprime dans le système international en mètre cube, de symbole
       m3. » Sous-activité unités : récipient cubique d'arête a = 5 cm rempli de sable, transvasé
       dans une éprouvette graduée en mL — surface libre horizontale au niveau 125 mL ; calcul
       V = a3 = 125 cm3. **Généralisation** : « 1 cm3 est égal à 1 mL. »
    3. **Suite Activité II (unités)** (p.91) — encadré officiel : « Pour mesurer des volumes, on
       utilise souvent comme unité : le millilitre, de symbole mL : 1 mL = 1 cm3 = 10⁻⁶ m3 ; le
       litre, de symbole L : 1 L = 1000 mL = 1000 cm3 = 1 dm3. » Table des volumes de solides de
       formes simples (cube a3 ; parallélépipède L·l·h ; cylindre de rayon R et hauteur h : πR²h ;
       sphère de rayon R : 4/3 πR3). **Remarque** : « La surface libre du liquide est incurvée au
       contact de la paroi de l'éprouvette formant un ménisque. » Question sur les positions de
       lecture de l'œil (a)(b)(c)(d) pour lire correctement le volume.
    4. **Activité IV** — « Quelles sont les caractéristiques de l'état solide et de l'état liquide ? »
       (p.92) : un barreau de fer introduit successivement dans un bécher, un verre à pied, un
       erlenmeyer gradués, puis même expérience avec de l'eau. Forme et dimensions du barreau
       inchangées quel que soit le récipient ; forme de l'eau change d'un récipient à l'autre mais son
       volume reste inchangé. **Généralisations officielles** : « Un solide est caractérisé par une
       forme propre et un volume propre. » / « Un liquide est caractérisé par un volume propre, mais
       il n'a pas de forme propre (il épouse la forme de son contenant). Sa surface libre est plane et
       horizontale si elle est étendue. »
    5. **Activité V** — « Qu'en est-il pour les gaz ? » (p.93) : flacon rempli de butane (ou propane)
       transvasé dans une éprouvette par déplacement d'eau — le gaz change de forme.
       **Généralisation** : « Les gaz n'ont pas de forme propre et n'ont pas de surface libre. »
       Puis une quantité de gaz coloré emprisonnée dans une seringue, piston poussé puis tiré : la
       teinte et le volume varient (couleur plus intense + volume réduit en compression ; couleur
       moins intense + volume plus grand en détente). **Généralisations** : « Une même quantité de
       gaz peut occuper des espaces de plus en plus réduits : on dit que les gaz sont
       compressibles. » / « Une même quantité de gaz peut occuper des espaces de plus en plus
       grands : on dit que les gaz sont expansibles. » / « Un gaz occupe l'espace qu'on lui offre ;
       il n'a pas de volume propre. »
    6. **Activité VI** — « Quelle description microscopique peut-on envisager pour chacun des trois
       états de la matière ? » (p.93) — texte officiel intégral : « L'état solide est caractérisé
       par : un contact entre les particules (molécules, atomes ou ions) qui le constituent ; une
       disposition inchangée de ces particules ; en particulier, elle est ordonnée dans les solides
       cristallins ; une agitation très limitée des particules (un mouvement de va et vient autour
       d'une position moyenne) sans que leurs positions relatives ne changent. » « L'état liquide est
       caractérisé par : un contact entre les particules qui le constituent ; une agitation
       désordonnée de ces particules : les particules glissent les unes sur les autres (leurs
       positions relatives changent). » « L'état gazeux est caractérisé par : un espacement des
       particules qui le constituent ; une agitation très désordonnée de ces particules. » (un
       schéma du modèle microscopique des trois états suit, non transcriptible en texte).
  - **Fiche T.P.** (p.94) — « Mesure et calcul des volumes » : buts (calculer le volume d'un solide
    de forme simple à partir de ses dimensions ; mesurer le volume d'un solide de forme quelconque) ;
    matériel (éprouvette graduée, pissette d'eau, règle graduée, pied à coulisse, corps (A) de forme
    simple/parallélépipède, corps (B) de forme sphérique, corps (C) de forme quelconque/pâte à
    modeler) ; protocole (mesurer les dimensions de (A) et calculer son volume ; méthode par
    déplacement d'eau : lire V1 puis V2 après immersion de (A), déduire V = V2 − V1 ; pour (B),
    mesurer le diamètre au pied à coulisse, en déduire R, mesurer V' par déplacement d'eau et
    comparer V' au cube du rayon ; pour (C), mesurer le volume par déplacement d'eau, changer sa
    forme et remesurer pour vérifier l'invariance).
    **Relation à vérifier, imprimée pour le corps (B)** — c'est le **cœur pédagogique du protocole**
    (vérification expérimentale du volume de la sphère) : « **Vérifier que : V'/R³ = 4/3 π** ».
    ⚠️ **Provenance** : cette formule est une **image de formule** — `pdftotext` la rend **vide**
    (« Vérifier que : . ») ; elle a été **levée en passe vision sur la p.94** par la relecture R-7 du
    2026-07-17 (tranche ch.6–9), **non par une lecture du `.txt`**. Sans elle, le protocole s'arrêtait
    sur « comparer V' au cube du rayon » et la vérification demandée n'existait nulle part.
  - **Recherche documentaire** (p.95) — « La plongée sous-marine » : texte sur la plongée libre en
    apnée (poumons contenant 4 à 5 litres d'air qui se réduisent avec la pression, doublée à 10 m,
    triplée à 20 m) et la plongée avec bouteilles d'oxygène/hélium comprimé (dissolution de l'azote
    dans le sang pouvant provoquer une ivresse ; risques de décompression à la remontée : bulles de
    gaz qui bloquent la circulation, lésions pulmonaires si le plongeur retient son souffle en
    remontant). Questions : sens des mots « apnée » et « lésions » ; comparer plongée libre et
    plongée avec bouteille ; comment éviter les accidents de décompression.
  - **L'essentiel du cours** (p.96, formulation officielle — à reprendre verbatim) :
    - « La matière se présente sous trois principaux états physiques : l'état solide ; l'état
      liquide ; l'état gazeux. »
    - « Les solides sont saisissables entre les doigts tandis que les liquides et les gaz sont
      insaisissables et ils s'écoulent facilement : ce sont des fluides. »
    - « Le volume d'un corps est une grandeur qui caractérise l'espace occupé par ce corps. »
    - « Le volume s'exprime dans le système international en mètre cube : 1 m3 = 1000 L. »
    - « Un corps à l'état solide a une forme propre et un volume propre. »
    - « Un corps à l'état liquide n'a pas de forme propre. Il est incompressible et inextensible ; il
      a donc un volume propre. »
    - « Un corps à l'état gazeux est un fluide compressible et expansible et occupe tout l'espace
      qu'on lui offre. Il n'a ni forme propre ni volume propre. »
    - « Dans les solides, les particules sont faiblement agitées et disposées de manière compacte.
      Elles sont ordonnées si le solide a une structure cristalline. »
    - « Dans les liquides, les particules sont en agitation et sont disposées de manière compacte,
      mais elles sont désordonnées : elles glissent les unes sur les autres. »
    - « Dans les gaz, les particules sont fortement agitées, dispersées et désordonnées. »
  - **Aperçu historique** (p.96) : renvoi à deux sites internet pour rechercher les découvertes du
    savant **Avogadro (1776–1856)**.
  - **Exercice résolu** (p.97) : bécher de capacité 100 mL, corps solide (C) cubique de 4 cm de côté.
    1. Calcul du volume V = a3 = (4 cm)3 = 64 cm3 = 64 mL. 2) a) Espace total {eau, (C)} avec 50 mL
       d'eau initiale : VT = 50 + 64 = 114 mL > 100 mL, donc impossible de mesurer par immersion directe
       dans ce bécher. b) Volume d'eau déversée : VD = 114 − 100 = 14 mL. 3) Pour obtenir 100 mL d'air
       dans le bécher, il suffit de le vider d'eau et du corps (C) — commentaire officiel : « Deux corps
       ne peuvent pas occuper le même espace simultanément. »
  - **Exercices — Vérifier ses acquis** (p.98–99) : compléter des phrases (les trois états physiques ;
    « à l'état …… lorsqu'on peut le saisir entre les doigts » ; liquides et gaz « …… entre les
    doigts », appelés « ……» = fluides) ; vrai/faux motivé (un corps à l'état gazeux occupe la partie
    supérieure de l'espace offert ; le thermomètre à mercure contient du mercure à l'état solide dans
    son réservoir — piège ; tous les solides ne coulent pas ; la surface libre étendue d'un liquide
    est plane et horizontale) ; choisir le(s) mot(s) exact(s) (changement de forme/volume d'un
    liquide transvasé ; volume d'un liquide sous pression du piston bouché ; les gaz sont des
    fluides expansibles, compressibles, sans surface libre). **Utiliser ses acquis dans des
    situations simples** (p.98–99, item 1 lu) : QCM — récipient cylindrique de rayon r = 2 cm avec
    62,8 mL d'eau, hauteur de l'eau (réponses proposées 5 mL / 5 cm / 10 cm) ; item 2 — recherche
    documentaire sur les proportions de dioxygène/diazote/autres gaz dans l'air, les gaz des lampes
    à incandescence, les gaz des bouteilles de plongée ; item 3 — ballon de baudruche gonflé au
    dihydrogène, décrire une expérience pour recueillir un litre de ce gaz dans un flacon.
    **Utiliser ses acquis pour une synthèse** (p.99, items lus) : propriété de la surface libre d'un
    liquide + dessin du niveau dans des récipients remplis jusqu'à une flèche ; lecture d'une
    éprouvette graduée photographiée (unité, volume maximal, valeur d'une division, méthode de
    lecture correcte, lecture du volume affiché) ; problème des billes dans une éprouvette (60 mL de
    billes + un autre corps, ajout de 50 mL d'eau → niveau à 90 mL, déterminer le volume des billes
    puis celui de l'autre corps).
  - **Savoir plus** (p.100) — « Les cristaux liquides » : texte de culture scientifique sur l'état
    intermédiaire entre solide et liquide (cristaux nématiques, smectiques, cholestériques ;
    découverte sur le benzoate de cholestéryle ; usages dans l'affichage des calculatrices/montres —
    faible consommation d'énergie vs diodes électroluminescentes — et en médecine pour détecter des
    tumeurs via variation de couleur selon la température de la peau).
- **Concepts / notions** : les trois états physiques (solide, liquide, gazeux) ; critère de
  préhension entre les doigts ; fluides (liquides + gaz) ; volume propre / forme propre ; volume
  d'un corps (grandeur mesurable, unité SI le mètre cube m3) ; unités usuelles (mL, L, 1 cm3 = 1 mL,
  1 L = 1000 mL = 1 dm3) ; formules de volume des solides simples (cube, parallélépipède, cylindre,
  sphère) ; ménisque ; compressibilité / expansibilité des gaz ; description microscopique des trois
  états (contact/espacement des particules, ordre/désordre, degré d'agitation).
- **Vocabulaire officiel** : « saisissable entre les doigts », « fluide », « volume propre », « forme
  propre », « surface libre », « ménisque », « éprouvette graduée », « compressible », « expansible »,
  « particule (molécule, atome, ion) ».
- **Bornes de scope** :
  - ✅ **INCLUS** : distinction empirique des trois états par le critère de préhension/écoulement ;
    notion de volume (définition, mesure par déplacement d'eau, unités mL/L/m3, formules de solides
    simples) ; propriétés macroscopiques (forme propre, volume propre, surface libre) ; description
    microscopique qualitative (contact/espacement, ordre/désordre, degré d'agitation) — sans aucune
    notion de température ni de changement d'état (réservés au chapitre 9).
  - ⛔ **EXCLU (relève des chapitres suivants)** : effet de la température sur le volume — dilatation/
    contraction (chapitre 7) ; masse et masse volumique (chapitre 8) ; changements d'état physique,
    fusion/solidification/vaporisation/liquéfaction/sublimation (chapitre 9).

## 2.7 Physique — Chapitre 7 : Quelques propriétés de la matière (p.101–114, transcrit à profondeur de génération)

**Désignation imprimée (p.101)** : « **CHAPITRE II** » · thème « **LA MATIERE** » · titre « **QUELQUES
PROPRIETES DE LA MATIERE** » — concordant avec le sommaire p.4.

- **Page d'ouverture** (p.101) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Effet d'une variation de la
    température sur un corps solide » · « • Activités(II) : Effet d'une variation de la température sur un corps
    liquide » · « • Activités(III) : Effet d'une variation de la température sur un corps gazeux » ·
    « • Activités(IV) : **Conductibilité** thermique des corps ». _(Les 4 sont bien imprimées dans le corps.)_
    ⚠️ Le manuel emploie « **conductibilité** thermique » ici et p.103, mais « **conductivité** thermique » p.107
    et p.110 — **deux termes pour la même notion dans le même chapitre** (§6.3).
  - **Pré-requis** (verbatim) : « Notion de température » · « Notion de volume » · « Les états physiques de la
    matière » · « Précautions à prendre lors de l'utilisation d'une source de chaleur ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.102–103) : rails de voies ferrées anciennes séparés par de
    petits espaces libres (« Pourquoi… ? », « Quel risque encourt-on lorsque les rails s'échauffent
    fortement ? ») ; thermomètre à alcool (déplacement de l'alcool dans le tube capillaire, limite
    d'usage pour les températures élevées, pourquoi un réservoir relativement petit) ; réglage de la
    température d'un fer à repasser, influence de la nature du matériau sur la dilatation,
    fonctionnement des lampes clignotantes d'une guirlande ; manches non métalliques des ustensiles
    de cuisine, conductibilité thermique différente selon les matériaux.
  - **Activités expérimentales** (p.104–107) — 4 blocs :
    1. **Activité I** — « Quel effet peut avoir une élévation ou une diminution de la température sur
       le volume d'un corps solide ? » (p.104) : boule légèrement plus petite que l'anneau à
       température ambiante ; chauffée, elle ne traverse plus l'anneau ; refroidie, elle repasse.
       **Généralisations** : « Le volume de la boule augmente sous l'effet d'une élévation de la
       température. On dit que le corps solide se dilate. » / « Le volume de la boule diminue sous
       l'effet d'une diminution de la température. On dit que le corps solide se contracte. » Puis
       trois tiges (fer, cuivre, aluminium) de même longueur soudées à un socle commun, chauffées au
       bec Bunsen : l'aluminium s'allonge plus que le cuivre, qui s'allonge plus que le fer.
       **Généralisation** : « La dilatation d'un corps à l'état solide dépend de sa nature, de son
       volume et de la variation de sa température. » Relation officielle donnée (dilatation
       linéaire) : « On montre que la dilatation Δl d'un corps solide filiforme de longueur l₀ est
       régie par la relation : Δl = l₀·λ·Δθ ; où Δθ est la variation de la température du corps et λ
       est une constante qui dépend du matériau qui le constitue. »
    2. **Activité II** — « Quel effet peut avoir une élévation ou une diminution de la température sur
       le volume d'un corps liquide ? » (p.104–105) : ballon rempli d'un liquide coloré muni d'un tube
       effilé, plongé dans un bain d'eau chaude puis laissé refroidir. Le niveau descend légèrement au
       début (dilatation du verre) puis monte en chauffant, puis redescend au refroidissement.
       **Généralisations** : « Une élévation de la température d'un liquide conduit à sa dilatation. »
       / « Les liquides se dilatent plus facilement que les solides : à égalité de volume et pour une
       même durée d'échauffement avec des sources de chaleur identiques, la dilatation des liquides
       est plus grande que celle des solides. » / « Un abaissement de la température d'un liquide
       conduit généralement à sa contraction. » **Application — Le thermomètre** (p.105, encadré) :
       principe basé sur la dilatation du mercure (réservoir en verre mince + tube capillaire
       calibré, volume du réservoir souvent < 1 mL) ; raisons du choix du mercure (obtenu pur
       facilement, se dilate facilement, ne mouille pas le verre — n'adhère pas —, utilisable sur une
       large plage de températures) ; définition de l'échelle Celsius par les deux points fixes
       (glace fondante = 0, eau bouillante = 100 sous pression atmosphérique normale, intervalle
       divisé en 100 parties = degré Celsius, symbole °C).
       **Définition officielle du degré, imprimée en toutes lettres** (restituée le 2026-07-17 — la
       version pilote la résumait en « intervalle divisé en 100 parties ») : « **Le degré Celsius est
       la variation de température qui produit, dans le tube capillaire du thermomètre, une variation
       du niveau du mercure égale au 1/100 de sa variation observée entre les températures 0°C et
       100°C suite à l'immersion du réservoir du thermomètre respectivement dans la glace fondante et
       dans l'eau bouillante.** » Précautions de mesure (agiter le liquide
       pour uniformiser la température, réservoir ne touchant pas les parois, œil au niveau supérieur
       du mercure). **Remarque officielle (anomalie de l'eau)** (p.106) : « La dilatation ou la
       contraction de l'eau présente des particularités : lorsqu'on refroidit l'eau à l'état liquide
       jusqu'à 4°C, son volume diminue mais entre 4°C et 0°C son volume augmente. C'est pour cette
       raison qu'une bouteille en verre totalement remplie d'eau et placée au congélateur, quelques
       instants plus tard, se casse. »
    3. **Activité III** — « Quel effet peut avoir une élévation ou une diminution de la température sur
       le volume d'un corps gazeux ? » (p.106) : deux tubes à essai identiques surmontés d'un tube
       fin, l'un contenant de l'eau colorée, l'autre de l'air emprisonné par une goutte d'eau-index,
       plongés dans un bain d'eau tiède. À 25°C les deux index sont au même niveau ; à 40°C, l'index
       du tube d'air monte beaucoup plus haut que le niveau de l'eau colorée. **Généralisations** :
       « Le volume de l'air augmente sous l'effet d'une élévation de la température. On dit que l'air
       se dilate. » / « Les gaz se dilatent plus facilement que les liquides : à égalité de volume et
       pour une même durée d'échauffement avec des sources de chaleur identiques, la dilatation des
       gaz est beaucoup plus grande que celle des liquides. »
    4. **Activité IV** — « Est-ce que tous les corps conduisent la chaleur de la même manière ? »
       (p.107) : tige métallique horizontale, boules de cire déposées à différentes positions,
       chauffage d'une extrémité — les boules fondent successivement en commençant par la plus proche
       de la flamme. **Généralisations** : « Le long de la tige, la chaleur se transmet de proche en
       proche à partir de la source de chaleur. » / « Un métal est un conducteur de chaleur. » Puis
       tiges en cuivre, aluminium, verre et bois (même section, même longueur) dans un bécher d'eau
       chauffée, boule de cire à l'extrémité supérieure de chacune : le cuivre fond le premier, puis
       l'aluminium, puis (après un long délai) le verre ; le bois ne fond jamais. **Généralisations** :
       « Les métaux sont de bons conducteurs de chaleur. » / « Le bois est un mauvais conducteur de
       chaleur. » / « La conductivité thermique d'un corps dépend de la nature de la matière qui le
       constitue : le cuivre conduit mieux la chaleur que l'aluminium qui, à son tour, conduit
       beaucoup mieux la chaleur que le verre. » Tableau officiel des conducteurs thermiques : bons
       (argent, cuivre, aluminium, fer), mauvais (verre, bois, brique, papier), très mauvais (amiante,
       plastique, laine, liège). **Remarques officielles** : « A l'exception du mercure, les liquides
       et les gaz au repos sont de mauvais conducteurs de chaleur. » / « Les solides bons conducteurs
       d'électricité (voir chapitre I, activités V) sont généralement de bons conducteurs de la
       chaleur. C'est le cas du cuivre, du fer…. » / « Les solides isolants électriques (voir chapitre
       I, activités V) sont généralement de mauvais conducteurs de la chaleur. C'est le cas du bois,
       du verre…. » (renvoi explicite au chapitre 1 d'électrostatique du même manuel).
  - **Fiche T.P.** (p.108) — « Réalisation d'un thermoscope » : buts (construire un instrument
    comparant des températures, discuter ses inconvénients, proposer des améliorations) ; matériel
    (petit ballon/pilulier, tube fin de 50 cm, bouchon percé, bandelette de papier millimétré, quatre
    béchers, source de chaleur, liquide coloré) ; protocole (marquer sur la bandelette le niveau du
    liquide dans une eau froide puis dans une eau chaude, diviser l'intervalle en graduations, tester
    l'instrument dans un troisième puis un quatrième bécher) ; questions ouvertes (inconvénients,
    améliorations, capacité à mesurer une vraie température).
  - **Recherche documentaire** (p.109) — « Les rails de chemin de fer » : texte sur les déformations
    dues à la dilatation, les anciens rails non jointifs (bruit, usure) vs les rails soudés modernes
    fixés aux traverses ancrées dans le ballast, l'étirage/compression aux vérins hydrauliques avant
    soudure selon la température moyenne de la voie. Questions : sens de « ballast » et « ancrée »,
    inconvénients des anciens rails, procédé d'installation.
  - **L'essentiel du cours** (p.109–110, formulation officielle — à reprendre verbatim) :
    - « En s'échauffant, les solides, les liquides et les gaz se dilatent. »
    - « En se refroidissant, les solides, les liquides et les gaz se contractent, sauf l'eau qui
      présente des particularités. »
    - « L'eau se dilate lorsque sa température baisse de 4°C à 0°C. »
    - « A égalité de volume et pour une même élévation de température, les gaz se dilatent plus que
      les liquides qui, à leur tour, se dilatent plus que les solides. »
    - « La dilatation et la contraction d'un corps dépendent de sa nature, de son volume et de la
      variation de sa température. »
    - « La température est la grandeur qui nous permet de reconnaître si un corps est plus ou moins
      chaud (ou plus ou moins froid) qu'un autre corps. »
    - « Un thermomètre est un instrument qui permet de repérer la température d'un corps. Le principe
      de son fonctionnement est basé sur la dilatation des corps. »
    - « Les thermomètres usuels sont gradués en degré Celsius, de symbole °C. »
    - « La conductivité thermique d'un corps dépend de la nature de la matière qui le constitue : le
      cuivre conduit plus la chaleur que l'aluminium qui, à son tour, conduit plus la chaleur que le
      verre. »
    - « Les solides bons conducteurs d'électricité sont généralement de bons conducteurs de
      chaleur. »
    - « Les solides isolants électriques sont généralement de mauvais conducteurs de chaleur. »
  - **Aperçu historique** (p.110) : renvoi aux mêmes sites pour rechercher les découvertes du savant
    **S'gravesande (1688–1742)**.
  - **Exercice résolu** (p.111) : « le dispositif de **la figure ci-contre** », imaginé par un élève,
    pour étudier la dilatation d'un liquide plongé dans l'eau chaude. ⚠️ **Le montage n'est décrit
    nulle part dans le texte** — il n'existe **que dans la figure**, non rendue (§6.2) ; la solution
    ne nomme que « le verre, le liquide et l'air » et « le tube fin ». _(La version pilote écrivait
    « ballon + tube fin » : le « ballon » était **déduit par analogie** avec l'activité II p.104,
    **jamais lu** — reconstitution de figure, contraire à la règle « signalé, jamais reconstitué ».
    Retirée le 2026-07-17.)_ 1) L'élévation du niveau ne provient pas
    uniquement de la dilatation du liquide : le verre, le liquide et l'air du dispositif se dilatent
    tous, l'élévation renseigne sur la dilatation globale. 2) Inconvénient : la dilatation du verre
    est négligeable devant celle du liquide, mais si de l'air reste emprisonné, sa dilatation
    (beaucoup plus grande) provoque une montée brusque risquant de faire déborder le liquide —
    commentaire officiel : « Pour étudier la dilatation d'un liquide contenu dans un récipient, il
    faut chasser l'air de ce récipient en le remplissant totalement de liquide. »
  - **Exercices — Vérifier ses acquis** (p.112) : compléter des phrases (dilatation dépend de la
    nature, du volume, de la variation de température ; le bois utilisé comme isolant thermique ;
    bons conducteurs d'électricité généralement bons conducteurs de chaleur) ; vrai/faux motivé (un
    liquide se dilate moins qu'un solide de même volume pour une même élévation — faux ; bouteille
    Thermos garde les boissons chaudes uniquement — faux, piège classique ; les solides se dilatent
    dans une seule direction sous l'effet de la chaleur — faux) ; choisir le(s) mot(s) exact(s)
    (isolation thermique des maisons ; le mercure n'adhère pas au tube et se dilate/contracte
    facilement ; bilame de deux métaux différents dans le thermostat d'un fer à repasser).
    **Utiliser ses acquis dans des situations simples** (p.112–113) : item 1 lu — QCM sur les lampes
    clignotantes à bilame (contact à froid, le bilame se chauffe et s'incurve → réponses proposées
    (a) reste allumée / (b) s'incurve et s'éteint / (c) s'éteint par baisse d'intensité) ; item 2 —
    fentes des chaussées sur les ponts, ce qui les recouvre ; item 3 — la laine comme isolant : peut-
    elle retarder la fusion d'un glaçon, chauffer un biberon, protéger la gorge du froid, empêcher un
    pain de se refroidir (à expliquer). **Utiliser ses acquis pour une synthèse** (p.113) : item 1 —
    thermomètre à minima et maxima (mercure encadré d'alcool des deux côtés), identifier la branche
    au plus grand volume d'alcool, quel volume se dilate/se contracte le plus, quel index (I ou J)
    monte selon une température maximale ou minimale ; item 2 — tableau du volume de 1 kg d'eau de
    0°C à 8°C, tracer la courbe, identifier la température de volume minimal (4°C), expliquer
    l'« anomalie » de l'eau. **Les 9 couples imprimés** (restitués le 2026-07-17 — la version pilote
    ne donnait que les bornes, ce qui rendait l'exercice **non régénérable**) :

    | θ (°C) | 0       | 1       | 2       | 3       | 4       | 5       | 6       | 7       | 8       |
    | ------ | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
    | V (mL) | 1000,12 | 1000,07 | 1000,03 | 1000,01 | 1000,00 | 1000,01 | 1000,03 | 1000,07 | 1000,11 |

    **Consigne imprimée également omise par la pilote** : « On prendra la graduation 1000 mL sur l'axe
    des ordonnées confondue avec la graduation 0°C sur l'axe des abscisses. » ; item 3 —
    rail en acier de 100 m à 25°C, allongement de 0,01 mm par mètre par °C, calculer la longueur à
    50°C et à 0°C, en déduire la distance minimale à respecter entre deux rails identiques.

  - **Savoir plus** (p.114) — « Le refroidissement des moteurs » : texte sur les chambres d'explosion
    atteignant 2000°C, le rôle du liquide de refroidissement (circule autour des cylindres, cède sa
    chaleur au radiateur aidé du ventilateur), la plage normale de 80–90°C, le vase d'expansion
    permettant à l'eau de se dilater librement.
- **Concepts / notions** : dilatation / contraction (solide, liquide, gaz) ; dépendance de la
  dilatation à la nature, au volume et à la variation de température ; relation Δl = l₀·λ·Δθ pour un
  solide filiforme ; anomalie de l'eau entre 0°C et 4°C ; échelle Celsius (points fixes 0°C/100°C,
  degré Celsius) ; thermomètre à mercure (principe et précautions d'usage) ; conductivité thermique ;
  bons/mauvais/très mauvais conducteurs de chaleur ; lien conducteur électrique ↔ conducteur
  thermique.
- **Vocabulaire officiel** : « se dilater », « se contracter », « tube capillaire », « réservoir »,
  « degré Celsius (°C) », « conductivité thermique », « conducteur de chaleur », « isolant
  thermique », « bilame ».
- **Bornes de scope** :
  - ✅ **INCLUS** : effet qualitatif de la température sur le volume des trois états (dilatation/
    contraction), hiérarchie gaz > liquides > solides ; relation linéaire de dilatation d'un solide
    filiforme (Δl = l₀·λ·Δθ, sans calcul de λ tabulé) ; anomalie de l'eau entre 0 et 4°C ; principe du
    thermomètre et échelle Celsius ; conductivité thermique qualitative et tableau de classement des
    matériaux.
  - ⛔ **EXCLU (relève des chapitres voisins)** : notion et mesure de la masse, masse volumique et
    densité (chapitre 8) ; changements d'état physique — fusion, ébullition, sublimation (chapitre 9) ; les trois états eux-mêmes en tant que propriétés mécaniques/structurelles (déjà couvert au
    chapitre 6, non repris ici) ; aucun calcul chiffré de coefficient de dilatation λ n'est fourni
    dans les tableaux du chapitre — seuls des exercices numériques simples avec un coefficient donné
    en énoncé (ex. rail en acier) figurent en fin de chapitre.

## 2.8 Physique — Chapitre 8 : La masse (p.115–130, transcrit à profondeur de génération)

**Désignation imprimée (p.115)** : « **CHAPITRE III** » · thème « **LA MATIERE** » · titre « **LA MASSE** » —
concordant avec le sommaire p.4.

- **Page d'ouverture** (p.115) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : La masse d'un corps » ·
    « • Activités(II) : Mesure d'une masse » · « • Activités(III) : La masse volumique d'un corps » ·
    « • Activités(IV) : Densité d'un liquide et d'un solide ».
    ⚠️ **Incohérence de la source (signalée, non arbitrée — §6.3)** : le plan annonce **4** activités, le corps
    en imprime **5** (I p.118 → V p.122), et les intitulés décrochent à partir du rang III/IV — le plan (IV)
    « Densité d'un liquide et d'un solide » correspond en fait à l'**ACTIVITES (V)** imprimée p.122, tandis que
    l'ACTIVITES (IV) imprimée p.121 porte sur la masse volumique d'un solide.
  - **Pré-requis** (verbatim) : « Mesurer un volume » · « Conversion des unités de volume » · « Les états
    physiques de la matière ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.116–117) : emballages alimentaires avec indications
    chiffrées entourées (« Que représente les indications entourées sur chaque emballage ? »,
    « Quelle est la signification de l'écriture kg et l'écriture g ? », « Ces produits ont-ils le
    même volume ? ») ; appareils de mesure pour préparer un couscous (signification de l'écriture
    mL, pourquoi l'ail n'est mesuré ni en kg ni en mL) ; l'iceberg qui flotte sur l'eau (comparaison
    de la masse volumique de la glace à celle de l'eau, densité de la glace) ; un verre mesureur
    (mesure-t-il des volumes ou des masses, pourquoi les graduations diffèrent pour la semoule et la
    farine).
  - **Activités expérimentales** (p.118–123) — 5 blocs :
    1. **Activité I** — « Qu'appelle-t-on masse d'un corps ? » (p.118) : relevé des indications
       chiffrées sur des emballages (couscous 1 kg, farine 1 kg, macaroni 500 g, bouteille d'huile
       920 g) ; la quantité de macaroni du paquet 1 kg est double de celle du paquet 500 g.
       **Généralisations** : « Chacune des indications chiffrées représente la masse du corps. La
       masse d'un corps est une grandeur physique qui caractérise la quantité de matière qu'il
       contient. » / « La masse d'un corps est une grandeur mesurable ; elle s'exprime en kilogramme
       de symbole : kg, et se mesure avec un instrument : la balance. » (illustration : balance de
       Roberval et masses marquées).
    2. **Activité II** — « Comment déterminer la masse d'un corps ? » (p.119) : plateaux vides de la
       balance de Roberval, position de l'aiguille repérée ; un corps posé sur un plateau, masses
       marquées ajoutées sur l'autre jusqu'au retour de l'aiguille à sa position initiale ; corps
       retiré et remplacé par des masses marquées jusqu'à obtenir de nouveau la même position.
       Exemple : m = m1+m2+m3 = 50+10+2 = 62 g. **Généralisations** : « Le corps et les masses
       marquées qui l'ont remplacé possèdent la même masse : la masse m du corps est alors égale à
       62 g. » / « Pour mesurer la masse d'un corps, il suffit de le placer sur l'un des plateaux de
       la balance de Roberval. On amènera l'aiguille de la balance à sa position repérée à vide en
       plaçant sur son deuxième plateau des masses marquées. La somme des masses marquées est égale
       à la masse du corps. » / « Avec une balance de Roberval, une seule pesée suffit pour déterminer
       la masse d'un corps. » **Remarque officielle** : « La masse d'un corps ne dépend ni de sa forme
       ni de sa position dans l'espace. »
    3. **Activité III** — « La masse et le volume caractérisent-ils une substance ? » (p.120–121) :
       trois pesées comparatives — (a)/(b) fiole de 250 mL vide / avec 250 mL d'eau / avec 250 mL
       d'huile : valeurs affichées différentes pour un même volume. **Généralisations** : « Deux
       substances différentes de même volume n'ont pas la même masse. » / « Deux corps ayant le même
       volume ne sont pas nécessairement formés de la même substance. Donc le volume ne peut pas
       caractériser une substance. » Puis (c)/(d) 100 mL d'huile vs 92 mL d'eau : mêmes valeurs
       affichées pour des volumes différents. **Généralisations** : « Deux substances différentes de
       même masse n'ont pas le même volume. » / « Deux corps ayant la même masse ne sont pas
       nécessairement formés de la même substance. Donc la masse ne peut pas caractériser une
       substance. » Puis pesée (e) de 17 mL d'huile. Tableau des trois quantités d'huile (250 mL/230
       g ; 100 mL/92 g ; 17 mL/15,6 g). **Généralisation** : « Plus le volume d'un corps est grand,
       plus sa masse est grande. » Relation officielle : m1/V1 = m2/V2 = m3/V3 = 920 g·L⁻¹ pour
       l'huile. **Définition officielle (encadrée)** : « La nature d'une substance est caractérisée
       par une grandeur appelée masse volumique notée ρ et définie comme étant le rapport de la masse
       m au volume V de la substance. Soit : ρ = m/V. Si la masse est exprimée en kilogramme et le
       volume en mètre cube, ρ s'exprime en kg.m⁻³. » Tableau des masses volumiques de liquides (eau
       1000, chloroforme 1480, alcool 790 kg.m⁻³). Mention d'autres unités : kg.L⁻¹, g.cm⁻³. Question
       ouverte : relation entre 1 kg.m⁻³ et 1 g.cm⁻³.
    4. **Activité IV** — « Comment déterminer expérimentalement la masse volumique d'une substance à
       l'état solide ? » (p.121–122) : mesure par déplacement d'eau (V1 = 50 mL avant, V2 = 55 mL
       après immersion du solide → V = 5 mL) puis pesée sur balance électronique (m = 39,5 g).
       Calcul : ρ = 7,9 g.mL⁻¹ = 7,9 g.cm⁻3 = 7900 kg.m⁻3. Tableau des masses volumiques de solides à
       25°C (aluminium 2700, cuivre 8900, fer 7900, liège 240, or 19300, plomb 11300, zinc 7150
       kg.m⁻3). **Remarques officielles** : le liquide de mesure ne doit pas dissoudre le solide ; le
       solide ne doit pas renfermer de cavités ; pour une forme géométrique simple, le volume peut
       être évalué par calcul ; « la masse volumique d'une substance varie avec la température »
       puisque le volume change avec la température sans que la masse ne change. Question ouverte :
       variation de la masse volumique lors d'un refroidissement.
    5. **Activité V** — « Pourquoi certains corps mis dans l'eau flottent-ils et d'autres coulent-
       ils ? » (p.122–123) : tube à essai avec 10 mL de chloroforme, 20 mL d'eau, 30 mL d'huile, 20 mL
       d'alcool superposés sans se mélanger (chloroforme dessous, puis eau, huile, alcool dessus).
       **Généralisation** : « Si on prend l'eau comme référence, on dit que le chloroforme est plus
       dense que l'eau, que l'huile est moins dense que l'eau et que l'alcool est moins dense que
       l'eau. » Note de sécurité officielle : « La manipulation du chloroforme nécessite des
       précautions particulières : l'utiliser en petite quantité sans le toucher ni le sentir. » Puis
       liège/fer/cuivre introduits dans un cristallisoir d'eau : le liège flotte, fer et cuivre
       coulent. **Généralisations** : « Si on prend l'eau comme référence, on dit que le fer et le
       cuivre sont plus denses que l'eau et que le liège est moins dense que l'eau. » / « La densité
       est un autre moyen pour caractériser une substance donnée. » / « Les substances qui ont des
       masses volumiques plus grandes que celle de l'eau sont plus denses que cette dernière. » /
       « Les substances qui ont des masses volumiques plus petites que celle de l'eau sont moins
       denses que cette dernière. » **Définition officielle (encadrée)** : « La densité d'une
       substance solide ou liquide, notée d, est définie comme étant le rapport de sa masse volumique
       à celle de l'eau. Soit : d = ρ(substance)/ρ(eau). » « La densité est une grandeur sans unité. »
       Tableau des densités (eau 1,00, glace 0,92, huile 0,92, chloroforme 1,48, cuivre 8,90, or
       19,30, liège 0,24, fer 7,80). **Remarque officielle** : les masses volumiques comparées
       doivent être exprimées dans les mêmes unités ; formulation alternative de la densité comme
       d = ms/me pour un échantillon de volume Vs = Ve — « la densité d'une substance solide ou
       liquide est égale au quotient de la masse d'un échantillon de volume V de cette substance à la
       masse d'un égal volume d'eau. »
  - **Fiche T.P.** (p.124) — « Mesure de densités » : buts (utiliser une balance et des masses
    marquées, lire un volume à l'éprouvette, déterminer la densité de l'alcool et du cuivre) ;
    matériel (balance de Roberval + masses marquées, éprouvette graduée, pissette d'eau, pycnomètre,
    alcool, morceau de cuivre) ; protocole densité du cuivre (masse, volume par déplacement, masse
    volumique du cuivre, masse de 250 mL d'eau, masse volumique de l'eau, déduire la densité) ;
    protocole densité de l'alcool par pycnométrie (pesée du pycnomètre vide, rempli d'alcool, rempli
    d'eau pure, déduire les masses puis la densité).
  - **Recherche documentaire** (p.125) — « Le kilogramme international » : texte historique sur la
    disparité des unités anciennes (la livre : 453,5 g en Angleterre, 489,5 g en France, l'once =
    1/16 de livre), la convention de 1793 (masse d'un cm3 d'eau à 0°C), le cylindre en platine de
    1799 (« le kilogramme étalon »), le remplacement en 1889 par l'étalon en platine iridié
    (« kilogramme étalon international », conservé à Sèvres, copies dans chaque pays), dimensions du
    cylindre (39 mm de hauteur, 39 mm de diamètre). Questions : sens du mot « étalon », la livre a-t-
    elle la même valeur partout, différence entre kilogramme étalon et kilogramme étalon
    international.
  - **L'essentiel du cours** (p.126, formulation officielle — à reprendre verbatim) :
    - « La masse d'un corps est une grandeur physique qui caractérise la quantité de matière qu'il
      renferme. Elle ne dépend ni de la forme du corps ni de sa position dans l'espace ni de son état
      physique. »
    - « La masse d'un corps est une grandeur mesurable. Elle est mesurée avec une balance. »
    - « L'unité de masse dans le système international est le kilogramme, de symbole (kg). »
    - « La masse volumique d'un corps solide ou d'un corps liquide, notée ρ, représente la masse de
      l'unité de volume de ce corps. »
    - « L'unité de la masse volumique dans le système international est le kg.m⁻³. »
    - « La densité d'une substance à l'état solide ou à l'état liquide est égale au quotient de sa
      masse volumique à celle de l'eau exprimées dans les mêmes unités. »
    - « La densité d'une substance n'a pas d'unité. »
  - **Aperçu historique** (p.126) : renvoi aux mêmes sites pour rechercher les découvertes du savant
    **Roberval (1602–1675)**.
  - **Exercice résolu** (p.127) : bijou en or de masse m = 25,1 g et volume V = 2 cm3, ρ(or) =
    19,3 g.cm⁻3. 1) Décrire les expériences (balance de précision pour la masse, éprouvette graduée
    de 25 mL pour le volume, calcul du quotient m/V). 2) a) m/V(bijou) = 25,1/2 = 12,55 g.cm⁻3 =
    12550 kg.m⁻3 < ρ(or) = 19300 kg.m⁻3, donc le bijou est creux — commentaire officiel : « Le rapport
    de la masse d'un objet à son volume n'est égal à la masse volumique de la substance qui le
    constitue que lorsqu'il ne comporte pas de cavité. » b) Volume de la cavité : V(cavité) =
    V(bijou) − m(or)/ρ(or) = 2 − 25,1/19,3 = 0,7 cm3.
  - **Exercices — Vérifier ses acquis** (p.127–128) : compléter des phrases (mesure d'une masse via
    des corps de masses connues appelés « masses marquées » ; une balance Roberval permet de
    « comparer » deux masses ; densité = quotient de la masse volumique de la substance à celle de
    l'eau) ; vrai/faux motivé (la masse dépend de la position dans l'espace — faux ; masse d'un gaz
    comprimé inchangée — vrai ; le verre mesureur permet de mesurer des volumes — vrai) ; choisir
    le(s) mot(s) exact(s) (masse indépendante du volume/de la forme ; g.L⁻¹ égal à kg.m⁻³ ; 1 kg de
    glace donne 920 g d'eau en fondant car la masse dépend de l'état physique — piège officiel, la
    bonne réponse étant que la masse NE dépend PAS de l'état, seul le volume change). **Utiliser ses
    acquis dans des situations simples** (p.128–129) : item 1 — QCM sur trois objets (fer/cuivre/
    aluminium) de même masse ou de même volume, lequel a le plus grand volume / la plus grande
    masse, en s'appuyant sur le tableau des masses volumiques ; item 2 — recherche du « carat
    métrique », masse en grammes d'un diamant de 10 carats ; item 3 — bouteille de verre de 0,75 L
    remplie de 745 mL d'eau placée **« dans la chambre froide d'un réfrigérateur »** (terme exact du
    manuel — la version pilote écrivait « au congélateur », terme que le manuel emploie ailleurs
    (p.106, ch.7) mais **pas ici** ; substitution corrigée le 2026-07-17) (ρ glace = 920 kg.m⁻3), que
    va-t-il se produire, nombre minimal de masses marquées pour peser la glace formée. **Utiliser ses acquis pour une
    synthèse** (p.129) : item 1 — cylindre plein en plomb, hauteur 10 cm, rayon 2 cm, pesée
    schématisée : calculer le volume, la masse, la masse volumique, la densité du plomb, prédire sa
    position dans l'eau ; item 2 — corps en zinc de forme quelconque à 25°C, volume déduit d'un
    schéma, pesée par déplacement d'eau (426 mL d'eau nécessaire pour équilibrer), déduire la densité
    du zinc ; item 3 — balance de Roberval avec deux éprouvettes de 100 mL d'huile et 100 mL d'alcool
    équilibrées par 320 g de masses marquées : déterminer les masses d'huile et d'alcool via le
    tableau des masses volumiques, en déduire la masse d'une éprouvette, puis effet du mélange
    huile+alcool sur l'équilibre de la balance.
  - **Savoir plus** (p.130) — « L'iceberg » : texte sur la banquise polaire, la formation des icebergs
    par rupture des glaciers, la densité de la glace inférieure de 10% à celle de l'eau expliquant
    que 90% du volume d'un iceberg est immergé, les dangers pour la navigation maritime, mention du
    naufrage du Titanic le 15 avril 1912.
- **Concepts / notions** : masse (grandeur mesurable, indépendante de la forme/position/état
  physique) ; balance de Roberval et masses marquées ; masse volumique ρ = m/V (unité SI kg.m⁻3,
  autres unités kg.L⁻1, g.cm⁻3) ; variation de la masse volumique avec la température ; densité
  d = ρ(substance)/ρ(eau) (sans unité) ; flottaison/superposition de liquides non miscibles selon la
  densité ; corps creux détecté par écart entre densité apparente et densité tabulée.
- **Vocabulaire officiel** : « masse », « kilogramme (kg) », « masses marquées », « balance de
  Roberval », « masse volumique (ρ) », « densité (d) », « pycnomètre ».
- **Bornes de scope** :
  - ✅ **INCLUS** : définition et mesure de la masse (balance de Roberval) ; masse volumique (mesure
    par pesée + déplacement d'eau, formule ρ = m/V, unités kg.m⁻3/kg.L⁻1/g.cm⁻3) ; densité (définition
    par rapport à l'eau, sans unité, mesure au pycnomètre) ; exploitation de tableaux de ρ/d fournis ;
    détection d'une cavité par comparaison masse/volume apparent vs ρ tabulée.
  - ⛔ **EXCLU (relève des chapitres voisins)** : dilatation/contraction en fonction de la température
    (chapitre 7, prérequis mentionné) ; changements d'état physique et conservation de la masse au
    cours d'un changement d'état — cette dernière notion (« lorsqu'un corps change d'état physique,
    sa masse ne change pas ») est en fait traitée au **chapitre 9**, pas ici ; poids et relation
    poids/masse (hors programme de ce chapitre, relève de la mécanique, chapitres 10+).

## 2.9 Physique — Chapitre 9 : Les changements d'état physique d'un corps pur (p.131–146, transcrit à profondeur de génération)

**Désignation imprimée (p.131)** : « **CHAPITRE IV** » · thème « **LA MATIERE** » · titre « **LES CHANGEMENTS
D'ETAT PHYSIQUE D'UN CORPS PUR** » — concordant avec le sommaire p.4. _(Le mot « **physique** » est imprimé aux
deux endroits ; la version pilote de cette fiche l'amputait — rétabli le 2026-07-17.)_

- **Page d'ouverture** (p.131) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : La solidification d'un corps pur et la
    transformation inverse » · « • Activités(II) : La vaporisation par ébullition » · « • Activités(III) : La
    vaporisation par évaporation » · « • Activités(IV) : La condensation de la vapeur d'eau : cycle de l'eau » ·
    « • Activités(V) : La sublimation » · « • Activités(VI) : Conservation de la masse lors d'un changement
    d'état » · « • Activités(VII) : Interprétation microscopique des changements d'état / Notion d'équilibre
    dynamique ». _(Les 7 sont bien imprimées dans le corps.)_
  - **Pré-requis** (verbatim) : « Propriétés caractéristiques des corps dans les différents états physiques de la
    matière » · « Structure corpusculaire de la matière et agitation thermique » · « Mesure de la température » ·
    « Mesure de la masse et mesure du volume d'un corps ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.132–133) : les états de l'eau dans la nature (« Dans quels
    états physiques rencontre-t-on l'eau dans la nature ? », fonte de la neige des sommets, formation
    des nuages et de la pluie) ; la lave des volcans qui se solidifie en refroidissant et son effet sur
    l'eau d'une rivière ; le séchage des vêtements (modes de vaporisation, séchage plus rapide en été
    qu'en hiver) ; conservation de la masse et du volume de l'eau selon son état physique.
  - **Activités expérimentales** (p.134–139) — 7 blocs :
    1. **Activité I** — « Quel est l'effet d'une variation de température sur l'état physique d'un
       corps ? » (p.134) : tube à essai d'eau liquide plongé dans un milieu réfrigérant (glace + sel),
       thermomètre surveillant la température. La température baisse ; dès 0°C la glace apparaît ; la
       température reste inchangée jusqu'à transformation totale en glace, puis la température de la
       glace continue de diminuer. **Généralisations** : « Le refroidissement de l'eau liquide conduit
       à sa transformation à l'état solide : il s'agit d'une solidification. » / « Le changement de
       l'état liquide à l'état solide de l'eau pure se produit à une température constante. Celle-ci
       est égale à 0°C sous la pression atmosphérique normale. » Puis le tube sorti et laissé à l'air
       libre : la glace se réchauffe, à 0°C l'eau liquide apparaît, la température reste à 0°C jusqu'à
       fusion totale, puis la température de l'eau augmente. **Généralisations** : « L'échauffement de
       la glace conduit à sa transformation en eau liquide : il s'agit d'une fusion. » / « La
       température reste conservée et égale à 0°C durant la transformation de la glace en eau
       liquide. » / « La fusion est une transformation inverse de la solidification. »
    2. **Activité II** — « A quelle température s'effectue l'ébullition de l'eau pure ? » (p.135) :
       ballon en verre avec eau liquide, thermomètre, chauffage au chauffe-ballon. La température
       augmente ; à 100°C de grosses bulles apparaissent et crèvent en surface, la température reste à
       100°C pendant la transformation, la quantité d'eau diminue. **Généralisations** : « Par
       échauffement, l'eau liquide passe à l'état gazeux : il s'agit d'une vaporisation par
       ébullition. » / « Le changement de l'état liquide à l'état gazeux de l'eau pure se produit à une
       température constante. Celle-ci est égale à 100°C sous la pression atmosphérique normale. » /
       « L'entretien de la vaporisation nécessite un apport continu de "chaleur". » **Remarque
       officielle** : « La valeur de la température d'ébullition d'un corps pur dépend de la pression
       de la vapeur qui le surmonte. »
    3. **Activité III** — « Y a-t-il un autre mode de vaporisation ? » (p.136) : quelques gouttes
       d'alcool (ou d'acétone) dans une soucoupe à l'air libre — disparition totale après un certain
       temps avec odeur d'alcool perceptible. **Généralisations** : « Le passage de l'alcool de l'état
       liquide à l'état gazeux se produit à la température ambiante. » / « Ce mode de changement
       d'état est une vaporisation par évaporation : les molécules d'éther quittent la surface de
       contact avec l'air et passent dans l'atmosphère. » (Note : le texte source emploie « molécules
       d'éther » alors que l'expérience porte sur l'alcool/acétone — incohérence de rédaction du
       manuel, signalée en incertitude ci-dessous.) / « Ce phénomène est général : les liquides
       abandonnés à l'air libre s'évaporent à des températures supérieures à leurs températures de
       fusion. » Questions ouvertes : pourquoi les vêtements mouillés sèchent plus vite en atmosphère
       sèche ; l'histoire du flacon de parfum oublié ouvert vidé après une semaine, conseil à donner.
    4. **Activité IV** — « Que se passe-t-il à un corps gazeux lorsqu'on le refroidit ? » (p.136) :
       vapeur d'eau d'une ébullition présentée à un verre de montre tenu à la pince en bois — des
       gouttelettes d'eau se forment sur la surface. **Généralisations** : « Par refroidissement, l'eau
       à l'état gazeux passe à l'état liquide : il s'agit d'une liquéfaction ou condensation. » / « La
       liquéfaction est une transformation inverse de la vaporisation. » Question ouverte : décrire le
       cycle de l'eau dans la nature.
    5. **Activité V** — « Comment peut-on expliquer l'odeur d'une boule antimite abandonnée sur
       l'étagère d'une armoire ? » (p.137) : ballon muni d'un long tube de verre (réfrigérant à air)
       contenant des cristaux d'iode, chauffé légèrement — une vapeur brune violacée apparaît et envahit
       le ballon, puis se condense en cristaux brillants au contact des parois froides du haut du
       ballon et du tube. **Généralisations** : « Par échauffement, l'iode se transforme directement de
       l'état solide à l'état gazeux : il s'agit d'une sublimation. » / « Par refroidissement, le
       diiode se transforme directement de l'état gazeux à l'état solide : il s'agit d'une
       condensation. » / « La sublimation est une transformation inverse de la condensation. »
       **Remarque officielle** : « L'antimite, comme l'iode, subit une sublimation lente à la
       température ambiante : il passe de l'état solide à l'état gazeux sans passer par l'état
       liquide. » Tableau officiel des températures de changement d'état sous pression atmosphérique
       normale : Eau (fusion 0°C, ébullition 100°C), Éthanol (−117°C, 78°C), Mercure (−39°C, 357°C),
       Fer (1535°C, 2750°C).
    6. **Activité VI** — « Lorsque l'état physique d'un corps change, que se produirait-il à sa
       masse ? » (p.138) : flacon de glace sur une balance électronique, masse relevée ; la glace fond,
       masse relevée à nouveau — indication identique. **Généralisation** : « Lorsqu'un corps change
       d'état physique, sa masse ne change pas. »
    7. **Activité VII** — « Comment interpréter les changements d'état ? » (p.138–139) — interprétation
       microscopique en deux volets. Fusion/solidification : « Lors de la fusion d'un corps, les
       molécules (ou les atomes ou les ions) qui étaient en contact et en mouvement de vibration autour
       de leur position moyenne restent en contact, mais deviennent désordonnées et peuvent glisser les
       unes sur les autres. » / « Lors de la solidification c'est le phénomène inverse qui se
       produit. » Liquéfaction/vaporisation : « Lors de la liquéfaction d'un corps, les molécules (ou
       les atomes) qui étaient espacées et en mouvement désordonné restent désordonnées mais elles se
       rapprochent les unes des autres et deviennent en contact. » / « Lors de la vaporisation, c'est le
       phénomène inverse qui se produit. » **Notion d'équilibre dynamique** (p.139, encadré) : question
       posée — que se produit-il si on cesse de chauffer/refroidir un milieu {glace + eau liquide}
       isolé thermiquement ? À l'échelle macroscopique, « la quantité de glace reste inchangée ainsi
       que celle de l'eau liquide. Nous dirons que l'ensemble (eau+glace) est en équilibre. » À
       l'échelle microscopique : « des molécules d'eau se détachent de la surface du solide et passent
       dans la phase liquide, d'autres quittent la phase liquide et se déposent sur la surface de la
       glace tel que le nombre de molécules qui passent d'une phase à l'autre, au bout d'une durée
       donnée, soit le même. Nous dirons que le système (eau+glace) est dans un état d'équilibre
       dynamique. » Question ouverte : que signifie isoler thermiquement un milieu matériel.
  - **Fiche T.P.** (p.140) — « Vaporisation par ébullition » : buts (suivre les variations de la
    température de l'eau pure au cours de son échauffement, tracer la courbe θ(t), expliquer par la
    structure microscopique) ; matériel (ballon en verre pyrex à col long, thermomètre à mercure
    −10/110°C, chronomètre, supports, eau distillée, source de chaleur type lampe à alcool) ;
    protocole (relever la température initiale et le niveau, déclencher le chronomètre au chauffage,
    relever la température au cours du temps, tracer la courbe, expliquer les résultats).
  - **Recherche documentaire** (p.141) — « Le cycle de l'eau » : texte sur la « planète bleue »,
    l'évaporation de l'eau de mer/lacs/rivières sous l'effet du soleil, la condensation en altitude sur
    des poussières formant les nuages, la formation de la pluie (gouttelettes trop lourdes) ou de la
    neige (par temps très froid — solidification), la fusion de la neige au contact de l'air chaud, le
    ruissellement vers rivières/fleuves/mer/lacs et l'infiltration formant les nappes souterraines.
    Questions : sens du mot « percolation », schéma du cycle de l'eau, formation du brouillard (nuage
    proche du sol).
  - **L'essentiel du cours** (p.142, formulation officielle — à reprendre verbatim) :
    - « Un corps peut être transformé d'un état physique à un autre par variation de sa température. »
    - « A chaque changement d'état est associé un changement d'état inverse. »
    - « Les corps purs ont, sous une pression donnée, une température de changement d'état
      constante. »
    - « La fusion de l'eau pure se produit à une température constante égale à 0°C sous la pression
      atmosphérique normale. »
    - « La vaporisation de l'eau pure peut se produire par évaporation à des températures supérieures
      à sa température du fusion, ou par ébullition à une température constante égale à 100°C sous la
      pression atmosphérique normale. »
    - « Pour un corps pur, la température d'un changement d'état et du changement d'état inverse est
      la même sous la même pression. »
    - « Au cours des changements d'état, la nature et la masse d'un corps pur sont conservées. »
    - « Tout système fermé, thermiquement isolé, siège de deux changements d'état inverses, est dans
      un état d'équilibre dynamique. »
  - **Aperçu historique** (p.142) : renvoi aux mêmes sites pour rechercher les découvertes du savant
    **Celsius (1701–1744)**.
  - **Exercice résolu** (p.143) : liquide (A) refroidi sous pression atmosphérique normale, tableau
    θ(t) : 24→20→16→12→8→6→5 (de 0 à 6 min) puis 5°C constant de 6 à 12 min, puis 5→4→2→0→−2°C (de 12
    à 16 min). 1) a) montage avec réfrigérant glace+sel (commentaire officiel : « Ce mélange ne fond
    pas à 0°C, ce qui permet de refroidir jusqu'à des températures négatives. ») ; b) tracé de la
    courbe ; c) états : liquide et refroidissement sur [0,5 min], mélange liquide+solide sur [6,12
    min], solide et refroidissement sur [12,16 min] ; d) (A) est un corps pur car sa solidification se
    produit à température constante θ = 5°C. 2) a) chauffer (A) à l'état solide pour observer la
    transformation inverse ; b) allure de la courbe inverse (fusion au même palier de 5°C, cohérent
    avec la conservation de la température de changement d'état pour un corps pur).
  - **Exercices — Vérifier ses acquis** (p.144) : compléter des phrases (variation de la température à
    pression constante ; vaporisation par « évaporation » à toute température vs ébullition à
    température constante = 100°C ; sublimation et « liquéfaction/condensation » transformations
    inverses) ; vrai/faux motivé (thermomètre dans la neige fondante indique 0°C même si l'air ambiant
    est à 25°C — vrai ; thermomètre médical 35–42°C utilisable pour eau bouillante/glacée — faux, hors
    plage ; vêtements mouillés sèchent plus vite près de la mer que dans le désert — faux, l'humidité
    ambiante ralentit l'évaporation) ; choisir le(s) mot(s) exact(s) (volume de la glace qui fond
    diminue, masse reste la même, masse volumique de l'eau liquide plus grande que celle de la glace ;
    états physiques de la buée/grêle/nuage ; origine principale de l'eau de pluie = évaporation de la
    mer). **Utiliser ses acquis dans des situations simples** (p.144–145) : item 1 lu — histoire
    d'Amel et ses vêtements mouillés : solidification par temps froid puis fusion par temps moins
    froid puis évaporation par le vent (QCM à trois choix pour chaque étape) ; item 2 — sécher sans
    serviette (évaporation) et formation de la buée visible par temps froid en expirant ; item 3 —
    l'échelle kelvin (recherche de sa signification et de la relation avec Celsius), températures de
    solidification/ébullition de l'eau en kelvin. **Utiliser ses acquis pour une synthèse** (p.145) :
    item 1 — alcool (θs = −117°C, θe = 78°C) chauffé de −120°C à 100°C, tracer l'allure de θ(t),
    associer chaque partie à l'état physique, discuter la capacité d'un thermomètre à alcool à repérer
    les températures de changement d'état de l'eau pure ; item 2 — deux béchers (eau pure / eau salée)
    refroidis, courbes (A) et (B) à identifier, lien avec l'usage du mélange glace+sel comme
    réfrigérant et avec l'ajout de sel dans l'eau de cuisson des légumes pour accélérer la cuisson ;
    item 3 — molécules représentées par des boules identiques dans les états (a)/(b)/(c), faire
    correspondre chaque figure à un état physique, nommer la transformation (a)→(b), et la propriété
    de conservation de la quantité de matière au cours des transformations physiques.
  - **Savoir plus** (p.146) — « La réfrigération » : texte sur le cycle frigorifique (compresseur,
    condenseur à 40°C sous 8–10 bars, tube fin d'expansion, évaporateur sous le congélateur qui
    absorbe la chaleur en se vaporisant complètement), critères d'un bon réfrigérant (température
    d'ébullition adaptée, densité élevée, ininflammable, faible/nulle toxicité), historique des CFC
    nuisibles à la couche d'ozone remplacés par des HCFC comme le HCFC 134A (~110 g dans un frigo
    ordinaire), dégradation par les radicaux hydroxyles en basse atmosphère.
- **Concepts / notions** : les six changements d'état et leurs couples inverses (fusion/
  solidification, vaporisation-ébullition et vaporisation-évaporation/liquéfaction-condensation,
  sublimation/condensation solide) ; température de changement d'état constante pour un corps pur
  sous pression donnée (0°C et 100°C pour l'eau à pression atmosphérique normale) ; dépendance de la
  température d'ébullition à la pression de vapeur ; conservation de la masse et de la nature au
  cours d'un changement d'état ; interprétation microscopique (contact/espacement, ordre/désordre des
  molécules/atomes/ions) ; équilibre dynamique dans un système fermé thermiquement isolé.
- **Vocabulaire officiel** : « fusion », « solidification », « vaporisation (par ébullition / par
  évaporation) », « liquéfaction », « condensation », « sublimation », « corps pur », « palier de
  température », « équilibre dynamique », « réfrigérant ».
- **Bornes de scope** :
  - ✅ **INCLUS** : les six changements d'état d'un corps pur et leur nomenclature précise ;
    constance de la température de changement d'état sous pression donnée (paliers à 0°C/100°C pour
    l'eau) ; distinction ébullition/évaporation ; conservation de la masse lors d'un changement
    d'état ; interprétation microscopique qualitative ; notion d'équilibre dynamique dans un système
    fermé isolé ; lecture/tracé de courbes θ(t) avec identification des paliers et des états.
  - ⛔ **EXCLU (relève d'autres chapitres ou hors programme de 1ère secondaire)** : notion de chaleur
    latente et calcul énergétique des changements d'état (aucune formule de type Q = mL fournie, la
    « chaleur » n'est mentionnée que qualitativement — « apport continu de chaleur ») ; diagrammes de
    phase pression-température ; masse volumique et densité déjà couvertes au chapitre 8 (utilisées
    ici seulement pour l'exercice « glace/eau », sans redéfinition) ; dilatation/contraction en
    fonction de la température, déjà couverte au chapitre 7 (prérequis mentionné explicitement en
    en-tête de chapitre).

## 2.10 Physique — Chapitre 10 : Le mouvement (p.147–162, transcrit à profondeur de génération)

**Désignation imprimée (p.147)** : « **CHAPITRE I** » · thème « **LA MECANIQUE** » · titre « **LE MOUVEMENT** »
— concordant avec le sommaire p.5.

- **Page d'ouverture** (p.147) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Repérage du temps » ·
    « • Activités(II) : Relativité d'un mouvement » · « • Activités(III) : Techniques d'étude d'un mouvement » ·
    « • Activités(IV) : Trajectoire d'un mobile » · « • Activités(V) : Les trois types de mouvement » ·
    « • Activités(VI) : Vitesse moyenne d'un mobile » · « • Activités(VII) : Vitesse instantanée ». _(Les 7 sont
    bien imprimées dans le corps.)_
  - **Pré-requis** (verbatim) : « Repérage dans le plan (origine, axe des abscisses et axe des ordonnées). » ·
    « Coordonnées d'un point dans un repère orthonormé. » · « Abscisse linéaire. »

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.148–149) : quatre mises en situation illustrées —
    voitures (trajectoires rectilignes/curvilignes ? calcul de la vitesse moyenne ? rôle du
    tachymètre ?) ; planètes autour du Soleil (origine du repère des trajectoires ; le Soleil
    est-il en mouvement ou au repos dans ce repère ?) ; athlètes en course (comment calcule-t-on
    la vitesse instantanée ? même trajectoire/même vitesse moyenne pour tous ?) ; balle de
    ping-pong en chronophotographie (qu'est-ce que la chronophotographie ? permet-elle de décrire
    trajectoire et évolution de vitesse ?).
  - **Activités expérimentales** (p.150–159) — 7 blocs :
    1. **Activité I** (p.150) — différence entre temps, instant et date : notion de durée
       (intervalle de temps séparant deux instants coïncidant chacun avec un événement) ; un
       repère temps est défini par une origine (instant d'un événement particulier — naissance
       de Jésus-Christ, Elhejra, déclenchement d'un chronomètre…) et une unité de durée (la
       seconde, symbole s, dans le SI) ; à chaque instant on associe une date notée t ; le repère
       temps est modélisé par un axe orienté vers le futur, gradué en unité de durée : événement
       avant l'origine → date t négative, après → date t positive. Question ouverte : situer sur
       l'axe les dates t1 (arrivée au lycée), t2 (début du 1er cours), t3 (réveil) et préciser
       leurs signes.
    2. **Activité II** (p.151–152) — situer la position d'un mobile : exemple du bateau (voile
       en mouvement par rapport à l'observateur (A) lié au sol, au repos par rapport à
       l'observateur (B) lié au bateau ; oiseau : idem ; palmiers : au repos par rapport à (A),
       en mouvement par rapport à (B)) → **généralisation officielle** : « Selon le choix de
       l'observateur, le même corps peut être en mouvement ou au repos. » / « Pour déclarer si
       un corps est en mouvement ou s'il est au repos, il faut choisir un corps de référence. » /
       « Le même corps peut avoir des mouvements différents par rapport à deux références
       différentes. » Encadré : « L'état de mouvement ou d'immobilité d'un corps n'a un sens que
       lorsque nous précisons une référence. » Question ouverte (valise sur le porte-bagage d'un
       train : qui la voit bouger, le propriétaire dans le train ou le voyageur sur le quai ?).
       Introduction du repère espace (système d'axes repérant la position des mobiles) : pour un
       mouvement sur une droite — origine O, droite orientée, unité de longueur = le mètre
       (symbole m) dans le SI. **Généralisation officielle** : « L'ensemble, repère espace et
       repère temps, constitue un référentiel. »
    3. **Activité III** (p.152) — techniques d'étude des mouvements (étude faite par rapport à
       une référence liée à la Terre) : le **marquage par étincelage** (mobile autoporteur sur
       table à coussin d'air, étincelle produisant une marque à chaque durée Δt ≈ 40 ms) ; la
       **chronophotographie** (disque troué tournant à vitesse constante devant l'objectif d'un
       appareil photo → images successives) ; **ordinateur + carte d'acquisition** (enregistrement
       automatique des dates au passage devant le capteur, abscisses des capteurs entrées au
       clavier) ; la **stroboscopie** (source lumineuse à éclairs brefs et réguliers d'intervalle
       Te, pour mouvements périodiques rapides — immobilité apparente ou ralenti).
    4. **Activité IV** (p.153) — notion de trajectoire : mobile autoporteur sur table à coussin
       d'air, position du point M repérée par A à la date tA puis par B à la date tB (tB>tA) ; la
       ligne matérialisant les positions successives de M est la **trajectoire**. Expérience
       annexe à l'oscilloscope (balayage enclenché/déclenché, signal triangulaire puis sinusoïdal
       — le spot décrit une ligne brisée ou une sinusoïde). Typologie : trajectoire portée par une
       droite → mouvement **rectiligne** ; portée par une ligne courbée → **curviligne** ; portée
       par une circonférence → **circulaire**.
    5. **Activité V** (p.154) — mouvement accéléré/décéléré/uniforme : chute d'une balle,
       clichés à intervalles de 0,02 s ; entre 0 s et 0,16 s la balle passe de A vers B ; sur le
       cliché n°1, les distances parcourues à intervalles consécutifs et égaux de 0,02 s sont de
       plus en plus grandes ; sur le cliché n°2, les durées mises pour parcourir des distances
       successives égales à 24 mm sont de plus en plus petites. **Généralisation officielle** :
       « Le mouvement de la balle est tel que, les distances parcourues à des intervalles de
       temps consécutifs et égaux augmentent ou les durées mises pour parcourir des distances
       successives et égales diminuent : on dit que le mouvement est accéléré. » Comparaison de
       la rapidité de deux mobiles : par les durées de trajets successifs de même longueur, ou
       par les longueurs de trajets parcourus en durées successives égales. Question ouverte
       (clichés A décéléré/retardé/ralenti/freiné, B uniforme).
    6. **Activité VI** (p.154–155) — comparer la rapidité de deux mouvements : athlètes (A) **l500**
       [sic — « l » minuscule pour le chiffre « 1 » ; la lecture « 1500 » est certaine, le manuel
       calculant lui-même 7,28 m.s⁻¹] m en 3 min 26 s et (B) 800 m en 1 min 54 s → (A) parcourt en moyenne 7,28 m/s, (B) 7,02 m/s,
       (A) plus rapide. **Généralisation officielle** : « La vitesse moyenne, notée Vmoy, d'un
       mobile est égale au quotient de la distance d parcourue par le mobile par la durée t du
       parcours : Vmoy = d/t. » Unité SI : mètre par seconde (m.s⁻¹) ; conversion usuelle
       1 m.s⁻¹ = 3,6 km.h⁻¹.
    7. **Activité VII** (p.155) — le tachymètre : à t1, le tachymètre indique 80 km.h⁻¹ ; à t2,
       110 km.h⁻¹. **Généralisation officielle** : « La vitesse instantanée, à un instant de date
       t, est la vitesse moyenne pendant une durée brève autour de la date t. » Elle est plus
       riche en information : constante (mouvement uniforme), croît (accéléré), diminue (retardé).
       Tableaux de vitesses instantanées d'animaux (tortue 0,4 km.h⁻¹, mouton 25, lièvre 60,
       cheval 70, guépard 100, faucon 350) et d'autres mobiles (voiture de course 300, avion 900,
       satellite 25200, Terre 107244, Pluton 17064, Mercure 172404 km.h⁻¹) (p.155).
  - **Fiche T.P.** (p.156) — « Différents types de mouvements » : buts (étudier le mouvement
    d'un mobile, calculer des vitesses instantanées, déduire la nature du mouvement) ; matériel
    (banc à coussin d'air, cavalier + carton de largeur Δx = 2 cm, trois chronomètres numériques
    au 1/1000 s, trois capteurs) ; protocole en 3 mouvements (banc horizontal avec vitesse
    initiale ; banc incliné d'un angle β sans vitesse initiale depuis le haut ; banc incliné, lancé
    du bas vers le haut avec vitesse initiale), mesure de Δt du passage devant chaque capteur
    (positions M1=40 cm, M2=80 cm, M3=120 cm de O), v = Δx/Δt, conclusion sur la nature du
    mouvement dans chaque cas.
  - **Recherche documentaire — Sécurité routière** (p.157) : vitesse excessive = première cause
    d'accidents ; choc à plus de 60 km.h⁻¹ généralement mortel ; limitation à 50 km.h⁻¹ en
    agglomération ; à cette vitesse, force de plus de 20 000 N pour retenir un corps de 75 kg
    contre un mur ; taux de mortalité des non-ceinturés 2 à 3 fois plus élevé ; distance d'arrêt
    DA = DR + DF (DR = distance de réaction, DF = distance de freinage, dépend de la vitesse, de
    l'état du véhicule et de la route) ; tableau vitesse (45/90/130 km.h⁻¹) → distance d'arrêt sur
    chaussée sèche (25/77/160 m). Questions : sens de « agglomération »/« habitacle » ; comment
    éviter les accidents ; rôle de la ceinture.
  - **L'essentiel du cours** (p.158, formulation officielle — verbatim) :
    - « Le mouvement d'un corps est relatif. »
    - « Pour s'informer sur le mouvement d'un point mobile, nous devons définir un repère temps
      et un repère espace. Le repère temps permet de situer un évènement dans le temps et le
      repère espace est un système d'axes permettant de repérer la position des mobiles dans
      l'espace. »
    - « Un corps est immobile s'il garde, au cours du temps, la même position par rapport au
      repère espace choisi. Il est en mouvement dans le cas contraire. »
    - « Dans un repère donné, la trajectoire d'un point mobile est l'ensemble des positions
      occupées par ce point au cours du mouvement. »
    - « Dans un repère donné, un mouvement peut être : rectiligne, si la trajectoire du mobile
      est portée par une droite ; curviligne, si la trajectoire est portée par une ligne courbée
      (si la ligne courbée est un cercle, la trajectoire est circulaire). »
    - « La vitesse moyenne d'un mobile est la distance qu'il parcourt, en moyenne pendant une
      unité de temps. Elle est égale au quotient de la distance d parcourue par le mobile à la
      durée t du parcours. »
    - « Dans le système international la vitesse s'exprime en mètre par seconde, de symbole
      m.s⁻¹. »
    - « La vitesse instantanée d'un mobile à un instant de date t est la vitesse moyenne pendant
      un intervalle de temps très bref autour de la date t. »
    - « Un mouvement est dit : accéléré, si la vitesse du mobile croît au cours du déplacement ;
      décéléré, si la vitesse du mobile diminue au cours du déplacement ; uniforme, si la vitesse
      du mobile reste inchangée au cours du déplacement. »
  - **Aperçu historique** (p.158) : recherche sur le savant **Galilée (1564–1642)**.
  - **Exercice résolu** (p.159) : chronophotographie d'une chute de balle prise toutes les
    0,02 s. 1) rôle de la chronophotographie ; 2) mouvement rectiligne (trajectoire = droite) ; 3) a) Vmoy entre 1ère et 2ème position = d1/t1 = 0,006/0,02 = 0,3 m.s⁻¹, entre 2ème et 3ème =
    d2/t2 = 0,010/0,02 = 0,5 m.s⁻¹ ; b) vitesse croît → mouvement accéléré ; 4) la **question 4**
    demande la vitesse moyenne « entre la première et la **dernière** position », mais le **corrigé
    imprimé** répond « Entre la première et la **deuxième** [sic] position » — **coquille de la
    source, transcrite telle quelle, non arbitrée** (§6.3) ; valeur : 0,16/0,16 = **1 m.s⁻¹**.
    ⚠️ **Les valeurs sont justes — ne pas les « réparer ».** Leur cohérence est **triple** : le manuel
    imprime lui-même « = 1 m.s⁻¹ » ; l'Activité V (p.154) établit une chute de **0,16 s** entre A et
    B ; une chute de 0,16 m en 0,16 s donne bien 1 m.s⁻¹. _(La version pilote écrivait « 1ère et
    **dernière** position » — arbitrage silencieux du mot imprimé — et diagnostiquait « cohérence
    fragile après extraction texte », **piège actif** qui invitait un agent aval à corriger des
    nombres exacts. Les deux sont **supprimés le 2026-07-17** ; le seul défaut réellement imprimé est
    le **libellé**.)_
  - **Exercices — Vérifier ses acquis** (p.160, items 1–3) : phrases à compléter (ensemble des
    « … » occupées par le point mobile au cours de son « mouvement » ; « Le Soleil se lève à …… et
    se couche à …… La Terre tourne donc de …… à ……. » (**texte à trous : les « …… » sont imprimés ;
    le manuel n'imprime aucun corrigé**) ; Ismail dans une voiture
    arrêtée au passage à niveau, un train passe — objets/personnes en mouvement par rapport au
    train) ; vrai/faux motivé (un mouvement rectiligne dans un repère le reste-t-il dans tout
    autre repère ? comparaison de rapidité par durées de parcours de même longueur ; suffit-il
    d'un repère espace pour décrire un mouvement ?) ; choisir le(s) mot(s) exact(s) (vitesse
    moyenne apporte plus/moins de renseignements que la vitesse instantanée ; mouvement
    curviligne uniforme = vitesse constante/variable ; démarrage/arrêt d'un autobus = accéléré/
    ralenti/uniforme). « Utiliser ses acquis dans des situations simples » (p.160–161) : QCM
    train (Hamza somnole, Amina/Ismail — relativité du mouvement) ; personnages sur tapis
    roulant (mouvement par rapport au sol / au tapis) ; nature du mouvement sur diagrammes.
    « Utiliser ses acquis pour une synthèse » (p.161–162) : valve de chambre à air d'une roue de
    bicyclette (trajectoire du centre du moyeu par rapport au sol ; trajectoire de l'extrémité de
    la valve par rapport au moyeu ; tracé de la trajectoire de la valve par rapport au sol) ;
    nœud marin / mille marin / mile — vitesse d'un vent de 25 nœuds en km.h⁻¹ et distance
    parcourue en 10 min ; tableau code de la route (vitesse 45/90 km.h⁻¹ → distance de réaction
    12,5/25 m, distance de freinage sur route sèche 13/52 m, sur route mouillée 26/104 m) —
    calcul des distances d'arrêt, influence de l'excès de vitesse et de l'état de la route,
    calcul du temps de réaction, influence de l'alcool sur la distance de réaction.
  - **Savoir plus — Satellisation d'un engin** (p.162) : énergie considérable + vitesse
    horizontale nécessaires ; le satellite reste soumis à l'attraction terrestre qui incurve son
    orbite ; vitesse faible → trajectoire parabolique, retombe ; augmentation de la vitesse →
    orbite fermée quasi circulaire ; « première vitesse de libération » ≈ 7 km.s⁻¹ ; au-delà,
    trajectoire elliptique puis, à la « seconde vitesse de libération » = 11,2 km.s⁻¹, l'engin
    peut s'éloigner à l'infini. Illustration : station spatiale internationale ISS (altitude
    375 km, 52 m de long, 73 m d'envergure).
- **Concepts / notions** : instant, date, durée, repère temps (origine + unité de durée = la
  seconde) ; repère espace (origine, orientation, unité de longueur = le mètre) ; référentiel
  (repère espace + repère temps) ; relativité du mouvement (corps de référence) ; techniques
  d'étude des mouvements (marquage par étincelage, chronophotographie, carte d'acquisition,
  stroboscopie) ; trajectoire ; mouvement rectiligne / curviligne / circulaire ; mouvement
  accéléré / décéléré (retardé) / uniforme ; vitesse moyenne (Vmoy = d/t, en m.s⁻¹) ; vitesse
  instantanée (vitesse moyenne sur une durée très brève autour d'un instant) ; tachymètre ;
  distance de réaction / distance de freinage / distance d'arrêt.
- **Vocabulaire officiel** : « instant », « date », « durée », « repère temps », « repère
  espace », « référentiel », « mobile », « trajectoire », « rectiligne », « curviligne »,
  « circulaire », « accéléré », « décéléré » (ou « retardé »/« ralenti »/« freiné »), « uniforme »,
  « vitesse moyenne (Vmoy) », « vitesse instantanée », « tachymètre », « chronophotographie »,
  « marquage par étincelage », « stroboscope »/« stroboscopie », « distance de réaction (DR) »,
  « distance de freinage (DF) », « distance d'arrêt (DA) ».
- **Bornes de scope** :
  - ✅ **INCLUS** : construction qualitative des notions de repère temps/espace/référentiel ;
    relativité du mouvement ; classification descriptive des trajectoires (rectiligne, curviligne,
    circulaire) et des régimes de mouvement (accéléré, décéléré, uniforme) par comparaison de
    distances/durées (pas de dérivée ni de calcul différentiel) ; calcul de vitesse moyenne
    Vmoy = d/t et conversions m.s⁻¹ ↔ km.h⁻¹ ; définition qualitative de la vitesse instantanée
    (vitesse moyenne sur un intervalle très bref) ; sécurité routière (distances de réaction/
    freinage/arrêt) comme application chiffrée.
  - ⛔ **EXCLU (relève des chapitres suivants de mécanique)** : notion de force et modélisation
    vectorielle d'une action mécanique (chapitre 11) ; poids, masse, centre de gravité, principe
    d'inertie (chapitre 11) ; conditions d'équilibre, principe d'interaction, loi de Hooke
    (chapitre 12) ; force pressante et pression (chapitre 13). Le chapitre 10 est un préalable
    purement cinématique (description du mouvement), sans aucune notion dynamique (cause du
    mouvement).

## 2.11 Physique — Chapitre 11 : Les actions mécaniques (p.163–178, transcrit à profondeur de génération)

- **Structure de la leçon** :
  - **Plan des activités expérimentales** (p.163, en tête de chapitre) : Activités(I) Les effets
    d'une action mécanique ; Activités(II) Modélisation d'une action mécanique par une force ;
    Activités(III) Le poids d'un corps ; Activités(IV) Caractéristiques du poids d'un corps ;
    Activités(V) Relation entre masse et valeur du poids d'un corps ; Activités(VI) Première loi
    de Newton (Principe d'inertie). **Pré-requis** listés : notion de vecteur, représentation
    d'un vecteur, mouvement et vitesse d'un mobile, masse d'un corps.
  - **Activités de mise en situation** (p.164–165) : athlète au lancer de marteau (quels
    éléments du corps exercent une action sur le marteau ? quel effet sur le marteau ?) ; sauteur
    à la perche (effet de l'action des mains sur la perche ; la perche exerce-t-elle une action
    sur l'athlète ?) ; voile de bateau sous le vent (action de contact ou à distance ? localisée
    ou répartie ? effet produit) ; sauteur en hauteur retombant après avoir franchi la barre
    (sous quelle action retombe-t-il ? contact ou distance ? localisée ou répartie ? relation
    avec sa masse ?).
  - **Activités expérimentales** (p.166–172) — 6 blocs :
    1. **Activité I** (p.166) — effets d'une action mécanique : chariot/bille poussé(e) sur table
       lisse horizontale puis lâché(e) → se met en mouvement et continue à se déplacer en
       l'absence de l'action (contact = doigt). Bille en acier + aimant approché → se met en
       mouvement sans contact (**action à distance**). Bille lâchée sur plan incliné, avec et
       sans aimant présenté → trajectoires différentes. **Généralisations officielles** : « Une
       action peut mettre un corps en mouvement. » / « Il s'agit d'une action de contact. » /
       « L'action de l'aimant sur la bille est une action qui se manifeste sans qu'il ne soit
       nécessaire d'avoir un contact entre le corps qui agit et le corps qui subit l'action. Il
       s'agit d'une action à distance. » / « Une action (…) peut modifier la nature du mouvement
       d'un corps. » Puis ressort + pâte à modeler sur table lisse : une seule action suffit pour
       déplacer, il en faut au moins deux pour déformer ; ressort = élastique (reprend sa forme),
       pâte à modeler = inélastique (reste déformée). **Définition officielle** (encadré) : « Une
       action est toute cause capable de produire ou de modifier le mouvement (vitesse et/ou
       trajectoire) d'un corps, ou de participer à la déformation d'un corps. » Remarque : effet
       dynamique (production/modification du mouvement) vs effet statique (déformation).
    2. **Activité II** (p.167–168) — caractéristiques d'une action : ressort à spires non
       jointives allongé progressivement → déformations plus importantes nécessitent des actions
       plus grandes (« Les actions sont comparables. À chaque action est associée une valeur ou
       intensité. »). Ressort tiré puis poussé horizontalement à son extrémité libre : reste
       horizontal dans les deux cas (direction commune), s'allonge dans un cas, se raccourcit
       dans l'autre → caractéristique distincte = le **sens**. **Généralisation officielle** :
       « Une action mécanique est caractérisée par une valeur, une direction et un sens. »
       **Modélisation d'une action mécanique par une force** (encadré, p.168) : force notée F,
       intensité notée F exprimée en newton (symbole N) dans le SI ; représentation par une
       droite (direction), une flèche (sens), une longueur à l'échelle (intensité) ; mesure par
       le **dynamomètre** (dynamomètre droit illustré). Tableau « Ordre de grandeur des
       intensités de quelques forces » (p.169) : doigt sur poussoir de stylo 1 N ; vent sur voile
       de 20 m² 200 N ; main au lancer de poids 500 N ; cheval sur chariot 700 N ; poussée d'un
       avion 100 000 N ; poussée d'une fusée 5 000 000 N ; attraction Soleil-Terre 35.10²⁰ N.
    3. **Activité III** (p.169) — pourquoi un corps abandonné à lui-même tombe : corps (C) lancé
       verticalement vers le haut (a), horizontalement (b), obliquement vers le haut (c), avec
       chronophotographie de chaque mouvement. Trajectoire rectiligne si lancé verticalement,
       curviligne si horizontal/oblique ; mouvement ascendant décéléré, descendant accéléré.
       **Généralisation officielle** : « Le changement de mouvement du corps lancé (…) prouve que
       le corps abandonné à lui-même est soumis à une action à distance. Cette action est
       exercée par la Terre. » « Cette action est une attraction puisqu'elle freine les
       mouvements des corps qui s'éloignent de la Terre et accélère ceux des corps qui s'en
       approchent. » « L'action d'attraction exercée par la Terre sur un corps est appelée poids
       du corps. »
    4. **Activité IV** (p.169–170) — caractéristiques du poids : corps suspendu à un fil à plomb
       matérialisant la verticale du lieu ; craie placée dans le prolongement ; fil brûlé → le
       corps tombe et écrase la craie, suivant la direction matérialisée par le fil.
       **Généralisation officielle** : « Le poids qui cause cette chute a une direction
       verticale. Il est orienté vers le bas. » Modélisation par un vecteur P, direction
       verticale, sens vers le bas, intensité P mesurable au dynamomètre. Remarques : action
       répartie sur tout le volume du corps (chaque particule attirée) ; convention de
       représentation en un point particulier, le **centre de gravité G** ; pour un corps
       homogène de forme géométrique simple à centre de symétrie, G coïncide avec ce centre ;
       G n'appartient pas toujours au corps (ex. anneau, cerceau). Encadré : « La verticale d'un
       point est la droite qui **joigne** [sic] ce point au centre de gravité de la Terre. »
    5. **Activité V** (p.170) — relation masse/poids : renvoi à la fiche T.P. **Généralisation
       officielle** : « En un lieu donné, l'intensité du poids d'un corps est proportionnelle à
       sa masse : P = m.g. » g = intensité de la pesanteur, exprimée en newton par kilogramme
       (N.kg⁻¹) ; g = valeur du vecteur champ de pesanteur g⃗. « L'action de la Terre n'est pas la
       même partout (…) g varie d'un lieu à un autre : elle diminue avec l'altitude et augmente
       avec la latitude. » Tableaux (p.170) : latitude Équateur 0° / Tunis 37° / Pôle Nord 90° →
       g = 9,78 / 9,80 / 9,83 N.kg⁻¹ ; altitude Tunis 0 m / Echâmbi 1544 m → g = 9,80 / 9,79
       N.kg⁻¹.
    6. **Activité VI** (p.171) — mouvement du centre de gravité si on supprime la cause : mobile
       autoporteur muni d'un éclateur sur l'axe vertical passant par G, sur table horizontale ;
       trajectoire de G = droite, traces équidistantes. Le poids est compensé par l'air soufflé
       (mobile autoporteur non en contact avec la table). « Le mouvement de G, appelé mouvement
       d'ensemble du solide, est rectiligne. » « Puisque les distances parcourues (…) pendant des
       intervalles de temps consécutifs et égaux sont égales, le mouvement de G est uniforme. »
       « Parmi tous les points du mobile, G a le mouvement le plus simple. Le centre de gravité G
       est appelé aussi **centre d'inertie**. » Question ouverte : si la feuille d'enregistrement
       est elle-même tirée brusquement, le mouvement de G par rapport à la feuille garde-t-il la
       même nature ? **Première loi de Newton (Principe d'inertie)** (encadré, p.171) : « Dans un
       référentiel dit galiléen, lorsqu'un solide est non soumis à des actions mécaniques (il est
       dit isolé) ou soumis à des actions qui se compensent (il est dit pseudo-isolé), et quel que
       soit le mouvement de ce solide, son centre d'inertie G peut : rester au repos, s'il est
       initialement immobile ; être animé d'un mouvement rectiligne uniforme, s'il est déjà en
       mouvement. » Remarques : ce principe ne régit que le mouvement de G ; le référentiel
       terrestre peut être assimilé, avec une bonne approximation, à un référentiel galiléen ; le
       référentiel lié à une feuille en mouvement non uniforme n'est pas galiléen.
  - **Fiche T.P.** (p.172) — « Poids et masse d'un corps » : buts (établir une relation entre
    masse et valeur du poids, déterminer g au lieu de l'expérience) ; matériel (dynamomètre droit
    ou à cadran max 5N, masses marquées, support, corps (C) de masse inconnue) ; protocole (mesure
    de P pour m = 0,1 à 0,5 kg par pas de 0,1, tracé P = f(m), déduction de la relation et de g,
    puis détermination de la masse de (C) par la courbe, vérification par balance).
  - **Recherche documentaire — Les forces musculaires** (p.173) : force d'un muscle proportionnelle
    à sa section, intensité maximale ≈ 40 N/cm² ; évaluations biométriques genou (football)/épaule
    (tennis). Données chiffrées : main au lancer de poids ≈ 500 N (masse du poids 7,257 kg,
    vitesse de départ 36 km.h⁻¹) ; raquette sur balle de tennis ≈ 1100 N (masse balle 58 g,
    vitesse 201,6 km.h⁻¹) ; club sur balle de golf ≈ 2600 N (masse balle 47 g, vitesse
    237,6 km.h⁻¹) ; pied de footballeur sur ballon ≈ 1500 N (masse ballon 430 g, vitesse départ
    93,6 km.h⁻¹). Questions : sens du mot « biométrie » ; comment augmenter la taille du muscle ;
    représenter à la même échelle les forces des quatre sportifs.
  - **L'essentiel du cours** (p.174, formulation officielle — verbatim) :
    - « Une action mécanique est toute cause capable de produire ou de modifier le mouvement
      (vitesse et/ou trajectoire) d'un corps, ou de participer à la déformation d'un corps. »
    - « Une action mécanique est caractérisée par : une intensité (appelée aussi valeur), une
      direction et un sens. »
    - « On modélise une action mécanique par un vecteur force, noté F. »
    - « L'intensité de la force se mesure à l'aide d'un dynamomètre et s'exprime dans le système
      international en newton, de symbole N. »
    - « La force d'attraction exercée par la Terre sur un corps est appelée le poids de ce corps.
      Elle est notée P. »
    - « On convient de représenter le poids d'un corps en un point particulier appelé son centre
      de gravité et noté G. »
    - « Le poids d'un corps est une action dirigée vers le centre de gravité de la Terre suivant
      la verticale (…) et d'intensité proportionnelle à sa masse m ; soit : P = m.g ; g est appelé
      intensité de la pesanteur. »
    - « L'intensité de la pesanteur g varie avec le lieu ; elle diminue avec l'altitude et
      augmente avec la latitude. »
    - « Le centre d'inertie G d'un corps est le point de ce corps qui a le mouvement le plus
      simple. »
    - « Dans un repère galiléen le mouvement du centre d'inertie G d'un corps isolé ou pseudo-
      isolé est rectiligne uniforme. »
  - **Aperçu historique** (p.174) : recherche sur le savant **Newton (1642–1727)**.
  - **Exercice résolu** (p.175) : corps cubique homogène m = 5102 g (≈ 5,102 kg), g = 9,8 N.kg⁻¹.
    1. P = m.g = 5,102 × 9,8 = 50,00 N ; 2) représentation à l'échelle 1 cm → 20,00 N (50,0 N →
       2,5 cm) ; 3) a) hauteur de l'Everest ≈ 8846 m (≈ 9000 m) ; b) le poids diminue d'environ 3/10000
       de sa valeur au sol par 1000 m d'élévation : 0,0003 × 9 × P = 0,0003 × 9 × 50,00 = 0,13 N,
       nouveau poids P' = 50,00 − 0,13 = 49,87 N.
  - **Exercices — Vérifier ses acquis** (p.176) : phrases à compléter (force = cause capable de
    mettre en mouvement/modifier vitesse ou trajectoire/participer à la déformation ; direction
    par une droite, sens par une flèche, intensité par une longueur ; le dynamomètre) ; vrai/faux
    motivé (poids mesuré en kg ? poids de la pâte à modeler dépend-il de sa forme ? force
    localisée caractérisée uniquement par son point d'application ?) ; choix des mots exacts
    (action du vent : à distance/de contact, localisée/répartie ; pomme qui tombe sous l'action de
    son poids/sa masse, action à distance exercée par l'arbre/la Terre ; même poids en deux lieux
    différents → même masse ou non). « Utiliser ses acquis dans des situations simples » (p.176– 177) : associer forces et valeurs (pied de footballeur, poussée de fusée au départ, Terre sur
    une pomme → 10⁷ N / 10³ N / 2 N) ; main soulevant un couffin avec F = 100 N (caractéristiques,
    schéma) ; tableau contact/distance et localisée/répartie pour câble-lustre, table-livre,
    Terre-Lune, aimant-clou. « Utiliser ses acquis pour une synthèse » (p.177–178) : fil sur avion
    jouet (nature de la force, caractéristiques, représentation à l'échelle 2 cm → 1 N) ; boules de
    pétanque (A) et (B) — tableau des effets d'action (boule(A)/sable, (A)/(B), (B)/(A), sable/
    boules après choc) ; corps C1 et C2 de poids 97,8 N chacun au pôle sud et à l'équateur —
    représentation à l'échelle 1 cm → 48,9 N, calcul de m1 avec g_équateur = 9,78 N.kg⁻¹, puis de
    g au pôle sud si P(C1) = 98,3 N et déduction de la masse de C2.
  - **Savoir plus — L'apesanteur** (p.178) : disparition apparente des effets de la pesanteur
    terrestre à l'intérieur d'un engin spatial ; perturbations physiologiques (otolithes,
    illusions d'orientation) ; illustration : cosmonautes en apesanteur dans la station orbitale
    Mir (satellisée en 1986, détruite le 23 mars 2001).
    _(Le chapitre s'arrête à la p.178. La **p.179 n'en fait pas partie** : c'est la **page d'ouverture
    normale** du ch.12, strictement identique en structure aux p.147 / 163 / 195, transcrite en §2.12.
    La version pilote la rattachait ici en invoquant une « transition d'imprimerie » — **rationalisation
    inventée d'une structure parfaitement régulière** (17 ouvertures ↔ 17 « SAVOIR PLUS », appariées sans
    trou — §2) : **supprimée le 2026-07-17**.)_
- **Concepts / notions** : action mécanique (de contact / à distance) ; effet dynamique
  (mise en mouvement, changement de trajectoire/vitesse) vs effet statique (déformation) ;
  corps élastique / inélastique ; caractéristiques d'une action (valeur/intensité, direction,
  sens) ; force, vecteur force F, intensité en newton (N) ; dynamomètre ; poids P (force
  d'attraction terrestre) ; centre de gravité G ; verticale du lieu ; relation P = m.g ; intensité
  de la pesanteur g (N.kg⁻¹, variable avec l'altitude et la latitude) ; vecteur champ de
  pesanteur g⃗ ; centre d'inertie ; principe d'inertie (1ère loi de Newton) ; corps isolé / pseudo-
  isolé ; référentiel galiléen.
- **Vocabulaire officiel** : « action mécanique », « action de contact », « action à distance »,
  « localisée », « répartie », « élastique », « inélastique », « force », « vecteur force »,
  « intensité (newton, N) », « dynamomètre », « poids », « centre de gravité (G) »,
  « verticale du lieu », « intensité de la pesanteur (g, N.kg⁻¹) », « vecteur champ de pesanteur »,
  « centre d'inertie », « principe d'inertie », « corps isolé », « corps pseudo-isolé »,
  « référentiel galiléen ».
- **Bornes de scope** :
  - ✅ **INCLUS** : distinction action de contact / à distance, localisée / répartie ; effets
    dynamique et statique d'une action ; les trois caractéristiques d'une force (valeur, direction,
    sens) et sa modélisation vectorielle ; usage du dynamomètre ; le poids comme force d'attraction
    terrestre, sa direction/sens/point d'application (G) ; relation quantitative P = m.g et
    variation de g avec le lieu ; centre d'inertie ; énoncé qualitatif du principe d'inertie
    (1ère loi de Newton) pour un solide isolé ou pseudo-isolé.
  - ⛔ **EXCLU (relève des chapitres suivants)** : condition d'équilibre de deux forces, forces
    directement opposées, tension du fil/ressort, réaction du plan, loi de Hooke, principe
    d'interaction — 3ème loi de Newton (chapitre 12) ; force pressante, surface pressée, notion de
    pression (chapitre 13). Aucun calcul de résultante de plusieurs forces ni de dynamique du
    mouvement (2ème loi de Newton) n'apparaît dans ce chapitre — seule la 1ère loi (principe
    d'inertie) y est énoncée.

## 2.12 Physique — Chapitre 12 : Forces et équilibre (p.179–194, transcrit à profondeur de génération)

- **Structure de la leçon** :
  - **Plan des activités expérimentales** (p.179, en tête de chapitre) : Activités(I) Équilibre
    d'un solide soumis à l'action de deux forces ; Activités(II) Équilibre d'un corps suspendu à
    un fil ; Activités(III) Équilibre d'un corps posé sur un plan ; Activités(IV) Loi de Hooke ;
    Activités(V) Principe d'interaction ; Activités(VI) Transmission d'une force par un fil et
    par un ressort. **Pré-requis** : vecteurs opposés, somme de vecteurs opposés, corps au repos
    et corps en mouvement, modélisation d'une action mécanique par une force.
  - **Activités de mise en situation** (p.180–181) : acrobates en équilibre sur une piste (quelles
    actions mécaniques agissent sur l'ensemble ? quelle condition pour l'équilibre ? l'action de
    la piste reste-t-elle inchangée si une 4ème acrobate rejoint le groupe ?) ; lustre suspendu à
    un crochet (condition entre action du crochet et action de la Terre pour l'équilibre ; notion
    de tension de rupture d'un fil/chaîne) ; ressort de suspension d'une voiture (déformation
    élastique ou inélastique ? limite de l'élasticité ? relation entre déformation du ressort et
    action mécanique du châssis/moteur/équipement) ; deux patineurs (si l'un pousse l'autre,
    l'autre agit-il en retour ? le principe reste-t-il valable si les deux sont en mouvement ?).
  - **Activités expérimentales** (p.182–188) — 6 blocs :
    1. **Activité I** (p.182–183) — condition d'équilibre de deux forces : morceau de polystyrène
       (S) soumis à deux forces F1 et F2 (via deux fils et deux dynamomètres à cadran (D1), (D2)
       en A1, A2), intensités nettement supérieures au poids de (S), équilibre obtenu. Constats :
       les deux fils sont tendus et dans le prolongement l'un de l'autre ; F1 et F2 de sens
       contraires ; (D1) et (D2) indiquent des intensités égales. **Généralisation officielle** :
       « Lorsqu'un solide soumis à deux forces F1 et F2 est en équilibre, alors ces deux forces :
       ont la même droite d'action ; sont de sens contraires ; sont de même intensité. » F1 et F2
       sont dites « deux forces directement opposées ». Question ouverte : état dynamique de (S)
       si sa vitesse est non nulle, tout en restant soumis à deux forces qui se compensent.
       Nouvelle expérience : (D1) déplacé dans une autre direction, intensité 3 N → nouvelle
       position d'équilibre, F'1 et F'2 toujours directement opposées. **Encadré « Condition
       d'équilibre »** (p.183) : « Dans un repère donné, un solide sur lequel s'exercent deux
       forces est en équilibre si ces deux forces sont directement opposées. » Traduction :
       F1 = −F2 ou F1 + F2 = 0, et F1, F2 ont la même droite d'action.
    2. **Activité II** (p.183–184) — équilibre d'un corps suspendu à un fil : corps (C) suspendu
       par un fil, extrémité A à (C), extrémité B au support fixe ; le fil tendu empêche la chute,
       (C) reste en équilibre. Le fil exerce sur (C) une force de contact localisée en A, dirigée
       vers le haut suivant la verticale, appelée **tension du fil**, notée T. « Le poids P est
       directement opposée à la tension du fil T, puisque (C) est en équilibre : P = −T. »
       « Le fil tendu matérialise la droite d'action du poids P. » **Application** (p.183–184) :
       détermination expérimentale du centre de gravité — plaque de carton percée de trois trous
       A, B, C, suspendue successivement par chacun avec marquage des points A', B', C' sur la
       droite d'action du poids ; les droites (AA'), (BB'), (CC') se coupent en un même point,
       noté G, le **centre de gravité** du solide.
    3. **Activité III** (p.184) — équilibre d'un corps posé sur un plan : livre, stylo, verre
       posés sur une table horizontale, en équilibre. Chaque corps soumis à une force à distance
       (son poids P) ; pour expliquer l'équilibre, il faut admettre que le plan exerce une force
       de contact directement opposée à P, appelée **réaction du plan**, notée R. « La réaction
       du plan est la force équivalente à toutes les actions mécaniques exercées par le plan sur
       le corps agissant » — réparties sur toute la surface de contact = **base d'appui** ;
       R augmente avec l'action. Remarque : la réaction d'un plan parfaitement lisse est normale
       (perpendiculaire) à la surface de contact. Question ouverte : disposition d'un plan
       parfaitement lisse permettant l'équilibre d'un corps abandonné sans vitesse initiale ; que
       se passe-t-il avec une vitesse initiale ?
    4. **Activité IV** (p.185–186) — déformation d'un ressort et sa cause : traction/compression
       sur l'extrémité A d'un ressort fixé en B ; le ressort tire la main quand allongé, pousse
       quand comprimé ; extrémité A en équilibre quand la main est immobilisée. « Lorsque le
       ressort est déformé (…) il exerce une force sur le corps agissant. Cette force est appelée
       **tension du ressort** et notée T. » En A agissent deux forces de contact (force musculaire
       et tension du ressort), directement opposées : F = −T. Remarque : au-delà d'un allongement
       limite Xm, le ressort ne retrouve plus sa longueur initiale (limite du domaine d'élasticité).
       **Application — loi de Hooke** (p.186) : la valeur T de la tension d'un ressort est une
       fonction linéaire de sa déformation Δl : T = k.|Δl|, k = constante de raideur du ressort
       (N.m⁻¹, ressort dit « linéaire »). Principe du dynamomètre droit fondé sur cette loi
       (exemple : force 0,2 N allonge le ressort de 2 cm → graduation tous les 2 cm par pas de
       0,2 N).
    5. **Activité V** (p.187–188) — principe d'interaction : morceau de fer (A) et aimant (B) de
       masses voisines, chacun sur un morceau de liège flottant, reliés par un fil retenu tendu
       puis brûlé → (A) et (B) se mettent simultanément en mouvement l'un vers l'autre. Les deux
       brins de fil tendus (f1, f2) dans le prolongement l'un de l'autre : (B) agit sur (A) avec
       une force notée F(B/A), (A) agit sur (B) avec une force notée F(A/B) — même droite d'action,
       sens contraires, même valeur → « directement opposés » : F(A/B) = −F(B/A). Deuxième
       expérience : dynamomètre (D1) agissant sur dynamomètre (D2) → indications égales, fils
       tendus dans le prolongement l'un de l'autre → interaction de contact, F(D1/D2) = −F(D2/D1).
       Remarque : pour les interactions de contact localisées, les points d'application des
       éléments d'une interaction sont confondus. **Encadré « Troisième loi de Newton (Principe
       d'interaction) »** (p.187) : « Lorsque deux corps (A) et (B) interagissent, (A) exerce sur
       (B) une force notée F(A/B) et en même temps (B) exerce sur (A) une force notée F(B/A)
       directement opposée à F(A/B). » Remarque : le principe s'applique aux corps au repos comme
       en mouvement. Question ouverte : tous les objets à la surface de la Terre exercent-ils une
       force sur la Terre ? Comparaison des valeurs.
    6. **Activité VI** (p.187–188) — transmission d'une force par un fil/ressort : ressort (R) de
       masse négligeable relié à deux dynamomètres droits (D1), (D2) tendu ; le ressort reste en
       équilibre, axe dans le prolongement des deux dynamomètres, indications égales. Par le
       principe d'interaction, les tensions T1 et T2 aux deux extrémités du ressort sont
       directement opposées. « Le ressort allongé (ou comprimé) exerce sur ses extrémités deux
       tensions directement opposées. » « Un ressort tendu permet de transmettre à une extrémité,
       la force subie à l'autre extrémité. » Remarque : un fil tendu a la même propriété.
  - **Fiche T.P.** (p.188) — « Loi de Hooke » : buts (appliquer la condition d'équilibre à un
    solide soumis à deux forces dont la tension d'un ressort, établir l'expression de la loi de
    Hooke, réaliser un dynamomètre) ; matériel (support, ressort à spires non jointives, masses
    marquées, papier millimétré, miroir plan) ; protocole (repérage de la position à vide G0,
    puis des positions G1, G2, G3… pour m1, m2, m3, tableau m (0,1 à 0,5 kg) / Δl / T, tracé
    T = f(Δl), puis consigne imprimée : « **proposer une écriture vectorielle** entre [T], Δl et
    **un vecteur unitaire à définir** » ; construction d'un dynamomètre droit).
    ⚠️ **Le manuel ne donne PAS la relation ici — il demande à l'élève de la proposer.** _(La version
    pilote écrivait « écriture vectorielle **T = −k.Δl⃗** » comme si elle était imprimée sur cette
    page : c'était la **réponse attendue**, pas le texte du T.P. La forme vectorielle n'est imprimée
    qu'à la **p.190** (L'essentiel). Corrigé le 2026-07-17.)_
  - **Recherche documentaire — Propulsion d'un coureur** (p.189) : starting-block, force de
    propulsion (le coureur pousse vers l'arrière sur le starting-block, celui-ci exerce une force
    opposée vers l'avant — application du principe d'interaction) ; action d'une piste rugueuse =
    force de propulsion horizontale + force verticale opposée au poids ; sur surfaces lisses,
    frottements très faibles → pas de force de propulsion. Questions : sens de « rugueux » et
    « propulsion » ; pourquoi appuyer fortement au démarrage ; le sol rugueux exerce-t-il
    uniquement une force de propulsion ?
  - **L'essentiel du cours** (p.190, formulation officielle — verbatim) :
    - « Lorsqu'un solide soumis à deux forces F1 et F2 est en équilibre, alors ces deux forces :
      ont la même droite d'action D ; sont de sens contraires ; ont la même intensité. »
    - « F1 et F2 sont dites deux forces directement opposées. Elles vérifient la relation :
      F1 + F2 = 0. »
    - « La droite d'action du poids d'un corps (C) passe toujours par un point particulier quelle
      que soit l'orientation de (C) dans l'espace. Ce point, noté G, est appelé le centre de
      gravité du corps (C). »
    - « Lorsqu'un ressort est déformé (allongé ou comprimé) il exerce une force sur le corps
      agissant. Cette force est appelée tension du ressort. Elle est notée T. »
    - « La valeur T de la tension d'un ressort est une fonction linéaire de sa déformation Δl :
      T = k.Δl, où k est une constante positive appelée constante de raideur du ressort. Puisque
      T est de sens opposé à celui de la déformation du ressort, elle s'écrit : T = −k.Δl. Cette
      relation traduit la loi de Hooke. »
    - « Le principe de l'interaction stipule que lorsque deux corps (A) et (B) interagissent, (A)
      exerce sur (B) une force notée F(A/B) et en même temps (B) exerce sur (A) une force notée
      F(B/A) directement opposée à F(A/B). »
    - « F(A/B) et F(B/A) constituent les deux éléments de cette interaction. Un ressort ou un fil
      tendu permet de transmettre à une extrémité, la force subie par l'autre extrémité. »
  - **Aperçu historique** (p.190) : recherche sur le savant **Hooke (1635–1703)**.
  - **Exercice résolu** (p.191) : g = 9,8 N.kg⁻¹, corps (C) suspendu à un dynamomètre à cadran
    affichant 10 N. 1) a) forces appliquées : poids P (Terre) et tension du fil T ; b) à
    l'équilibre P + T = 0 soit T = P = m.g, m = 10/9,8 = 1,02 kg = 1020 g. 2) (C) posé sur un sol
    horizontal : a) forces poids P et réaction du sol R ; b) à l'équilibre R = P = m.g = 10 N.
    ⚠️ **Numérotation renumérotée ici, incohérence de la source signalée** : le corrigé imprimé porte
    **deux fois « 1/- a)- »** — la réponse à la **question 2** y est numérotée « 1/- ». Le « 2) »
    ci-dessus est une **remise en ordre de lecture**, pas ce qui est imprimé (§6.3).
  - **Exercices — Vérifier ses acquis** (p.192) : phrases à compléter (F(A/B) et « F(B/A) » ; les
    deux forces constituent « les éléments/l'interaction », chacune « élément » de l'interaction ;
    tension du ressort linéaire « proportionnelle » à sa déformation) ; vrai/faux motivé (un
    système soumis à deux forces directement opposées est-il obligatoirement immobile ? le poids
    est-il élément d'une interaction ? la loi de Hooke ne s'applique-t-elle que dans le domaine
    d'élasticité ?) ; choix des mots exacts (force pointe de clou/doigt : plus grande/égale/plus
    petite ; sens contraires/même sens, même valeur, droites confondues/concourantes pour un
    objet en équilibre sous deux forces ; Terre-Lune : force plus/moins intense/égale à celle
    Lune-Terre). « Utiliser ses acquis dans des situations simples » (p.192–193) : ressort linéaire
    comprimé de 5 cm par une force de 2 N → constante de raideur, **QCM à trois options imprimées**
    : « (a) 40 N.m-1 ; (b) 10 N.m-1 ; (c) 40 m.N-1 » (**aucun corrigé imprimé**) ; Tour de Pise (14
    500 tonnes ; « La verticale (Δ) passant par le centre de sa base d'appui a 4 mètres de décalage
    par rapport au **centre de sa partie supérieure** » ; « **En suppose** [sic] que le centre de
    gravité G de la tour est à égale distance de ses deux bases » — donnée qui commande la question
    c) ; g = 10 N.kg⁻¹) — calcul du poids, de la réaction du sol, représentation de la position de la
    droite d'action par rapport à (Δ) ; dynamomètre à réaliser avec k = 20 N.m⁻¹ (une seule force
    connue de 3 N, distance entre deux divisions consécutives). « Utiliser ses acquis pour une
    synthèse » (p.193–194) : solide de masse m accroché à un ressort k = 20 N.m⁻¹, allongement à
    l'équilibre a = 5 cm, g = 10 N.kg⁻¹ (interactions ressort/solide et ressort/crochet, valeur des
    tensions, déduction de m) ; deux pendules électrostatiques P1/P2 en répulsion, force F(1/2)
    représentée (identifier Q1/Q2, nature de l'interaction, représenter F(2/1), signe de Q2 sachant
    Q1 positive) ; corps (A) suspendu à un dynamomètre affichant 10 N, g = 10 N.kg⁻¹ (éléments
    D/A et A/D de l'interaction, nature contact/distance, relation avec le poids, calcul de m).
  - **Savoir plus — L'interaction gravitationnelle** (p.194) : deux interactions fondamentales à
    l'échelle macroscopique — électromagnétique (connue depuis Thalès, VIe siècle av. J.-C.) et
    gravitationnelle (mise en évidence par Newton fin XVIIe s.) ; anecdote de la pomme ; théorie
    de l'attraction universelle publiée par Newton en 1687 : « Deux corps de masse m1 et m2
    s'attirent ; l'intensité des forces d'interaction augmente avec les masses m1 et m2 et
    diminue lorsque la distance qui sépare les deux objets augmente. Ces forces gravitationnelles
    obéissent au principe d'interaction. » Première mesure en laboratoire par **Cavendish
    (1731–1810)**.
- **Concepts / notions** : condition d'équilibre de deux forces (même droite d'action, sens
  contraires, même intensité — « forces directement opposées », F1 + F2 = 0) ; tension du fil T ;
  centre de gravité G (détermination expérimentale par suspension successive) ; réaction du plan
  R (base d'appui, normale à un plan lisse) ; tension du ressort T, loi de Hooke (T = k.|Δl|,
  constante de raideur k en N.m⁻¹), limite d'élasticité ; principe d'interaction (3ème loi de
  Newton, F(A/B) = −F(B/A)) ; interaction de contact vs à distance ; transmission d'une force par
  un fil/ressort tendu.
- **Vocabulaire officiel** : « forces directement opposées », « droite d'action », « tension du
  fil (T) », « centre de gravité (G) », « réaction du plan (R) », « base d'appui », « tension du
  ressort (T) », « constante de raideur (k, N.m⁻¹) », « loi de Hooke », « ressort linéaire »,
  « principe d'interaction », « éléments de l'interaction », « interaction de contact »,
  « interaction à distance ».
- **Bornes de scope** :
  - ✅ **INCLUS** : condition d'équilibre d'un solide soumis à deux forces (forces directement
    opposées) ; tension d'un fil, réaction d'un plan, tension d'un ressort comme forces de contact
    identifiées par l'équilibre ; détermination expérimentale du centre de gravité ; loi de Hooke
    (relation linéaire scalaire T = k.Δl et forme vectorielle T = −k.Δl⃗) ; 3ème loi de Newton
    (principe d'interaction) et distinction interaction de contact/à distance ; transmission d'une
    force par un fil ou un ressort tendu.
  - ⛔ **EXCLU (relève du chapitre suivant ou hors-programme à ce stade)** : force pressante,
    surface pressée, notion et calcul de pression en pascal (chapitre 13) ; aucune décomposition
    de forces non colinéaires ni équilibre à trois forces ou plus n'est traitée dans ce chapitre
    (seul le cas de deux forces directement opposées est étudié) ; pas de calcul quantitatif de la
    loi de l'attraction universelle (F = G.m1.m2/d²) — seule la formulation qualitative de Newton
    (« Savoir plus ») est mentionnée, sans formule ni constante G.

## 2.13 Physique — Chapitre 13 : Forces et pression (p.195–208, transcrit à profondeur de génération)

- **Structure de la leçon** :
  - **Plan des activités expérimentales** (p.195, en tête de chapitre) : Activités(I)
    Transmission des forces par les solides ; Activités(II) Force pressante ; Activités(III)
    Notion de pression ; Activités(IV) Applications. **Pré-requis** : actions mécaniques,
    équilibre d'un corps soumis à l'action de deux forces, principe d'interaction.
  - **Activités de mise en situation** (p.196–197) : personne assise sur une chaise (la chaise
    transmet-elle au sol les actions de la Terre sur la personne ? que se passe-t-il si le sol
    est sablonneux ?) ; dromadaires sur le sable (pourquoi la surface de sable a-t-elle subi un
    enfoncement ? de quels facteurs dépend la pression subie par le sol ?) ; couteau (pourquoi
    utiliser le côté aiguisé plutôt que le dos de la lame, à force musculaire égale, pour couper
    du pain ?) ; punaise enfoncée par le doigt (pourquoi une extrémité pointue et une extrémité
    large ? la force du doigt est-elle égale à la force subie par la planche ? la pression subie
    par la punaise est-elle égale à la pression transmise à la planche ?).
  - **Activités expérimentales** (p.198–201) — 4 blocs :
    1. **Activité I** (p.198) — les solides transmettent-ils les forces : solide (S) suspendu à
       un dynamomètre à cadran (sensible à la tension du fil, il indique cette tension) ;
       à l'équilibre, P + T = 0 (T force du fil localisée sur (S)) ; au point d'attache A du fil
       sur (S), en équilibre, agit une force directement opposée à T (notée T') : T + T' = 0,
       donc T' = P. **Généralisation officielle** : « Le solide (S) transmet, au fil du
       dynamomètre, l'action P de la terre qu'il subit. » Question ouverte : montrer que si le
       fil a une masse négligeable devant celle de (S), le dynamomètre indique la valeur de P.
       Deuxième expérience : ressort tiré à 2 N, extrémité libre repérée ; solide (S) sans
       frottement sur plan horizontal, attaché au ressort, tiré jusqu'à ramener le ressort à la
       même position repérée → dynamomètre indique 2 N. « Le solide (S) a transmis la force
       localisée que le dynamomètre a exercé sur lui au ressort avec lequel il est en contact. »
       **Généralisation encadrée** (p.198) : « Les expériences réalisées mettent en évidence le
       fait qu'un solide transmet toute action localisée ou répartie qu'il subit à tout corps en
       contact avec lui. »
    2. **Activité II** (p.199) — force pressante : corps (C) parallélépipédique posé sans appuyer,
       par sa petite surface s, sur plâtre en poudre (ou sable, farine) → trace de la forme de la
       face en contact, profondeur d'empreinte partout la même. « Le corps (C) transmet les
       actions à distance exercées par la Terre sur les particules qui le constituent au solide
       (S). Les actions transmises sont réparties sur toute la surface de contact s. » « Les
       actions exercées sur la surface de contact s sont équivalentes à une force F, appelée
       **force pressante**, égale (…) au poids du corps (C). » La surface s est la **surface
       pressée**. « La force pressante est normale (perpendiculaire) à la surface pressée et agit
       uniformément sur cette surface. »
    3. **Activité III** (p.199–200) — notion de pression : sur (C), pose d'un corps (C') de
       poids P' (ou force musculaire vers le bas) → surface pressée identique, empreinte plus
       profonde. « Pour une même surface pressée, l'emprunte est d'autant plus profonde que la
       force pressante est plus intense. » Puis (C) posé, sans appuyer, par sa grande surface S
       (S > s) sur le plâtre → empreinte moins profonde. « Pour une même force pressante,
       l'emprunte est d'autant moins profonde que la surface pressée est plus grande. »
       « L'effet statique d'une force pressante sur un corps dépend de l'intensité de la force et
       de la surface sur laquelle elle agit. Pour caractériser cet effet, on définit une nouvelle
       grandeur physique liée à la force pressante et à la surface pressée appelée **pression** et
       notée p. » **Encadré — définition de la pression** (p.200) : « La pression exercée par des
       actions réparties uniformément sur une surface s d'un corps pressé et agissant normalement
       à cette surface est égale au quotient de l'intensité de la force pressante F, équivalente
       à ces actions, à la surface pressée s. Soit : p = F/s. » Unité SI : le **pascal** (symbole
       Pa) ; si F en newton et s en mètre carré, p en pascal. Remarque : multiples usuels — le bar
       (1 bar = 10⁵ Pa), le millibar (1 mbar = 10² Pa). Questions ouvertes : deux forces
       d'intensités différentes peuvent-elles engendrer des pressions égales ? comment augmenter
       ou réduire des pressions selon les besoins ?
    4. **Activité IV** (p.201) — comment réaliser de fortes ou faibles pressions : **fortes
       pressions** — réduire la surface pressée (instruments tranchants : rasoir, couteau,
       burin ; pointus : poinçon, punaise, clou, aiguille) ou augmenter la force pressante
       (machines-outils : presses à forger, laminoirs, machines à emboutir/matricer, production
       de boîtes et tubes métalliques sans soudure). **Faibles pressions** — augmenter la surface
       d'appui pour réduire la pénétration : skis/raquettes sur la neige (répartition du poids sur
       une plus grande surface) ; tracteurs à roues larges, chars/bulldozers à chenilles ;
       traverses de voies ferrées répartissant le poids des convois ; socles en maçonnerie des
       monuments et édifices lourds.
  - **Fiche T.P.** (p.202) — « Pression subie par un corps solide » : but (déterminer les
    facteurs dont dépend la pression subie par un corps solide sous une force pressante) ;
    matériel (cristallisoir, règle, plâtre en poudre, dynamomètre, deux boîtes métalliques (A) et
    (B) parallélépipédiques) ; protocole (boîte (A) posée sur sa grande face → profondeur h1 ;
    sur sa petite face → h2 ; (A) sur petite face + (B) posée dessus → h3 ; comparaison h1/h2/h3 ;
    mesure des poids de (A) et (B) au dynamomètre ; calcul des surfaces grande/petite face de (A) ;
    tableau force pressante / aire de la surface pressée / pression / profondeur de l'empreinte).
  - **Recherche documentaire — Franchir les dunes** (p.203) : dégonfler les pneus pour augmenter
    la surface de contact au sol et réduire l'enfoncement ; pneus mous/larges épousent mieux le
    sable ; conduite souple nécessaire ; le poids ennemi du franchissement, alléger le véhicule
    réduit l'enfoncement. Questions : sens de « s'avachir » et « verglas » ; pourquoi dégonfler les
    pneus ; pourquoi décharger le véhicule.
  - **L'essentiel du cours** (p.204, formulation officielle — verbatim) :
    - « Un solide transmet toute action localisée ou répartie qu'il subit à tout corps en contact
      avec lui. »
    - « Les actions réparties sur une surface d'un corps solide sont équivalentes à une force F,
      appelée force pressante. »
    - « La surface de contact entre le corps pressant et le corps pressé est appelée surface
      pressée. »
    - « La pression exercée par des actions réparties uniformément sur une surface s d'un corps
      pressé et agissant normalement à cette surface est égale au quotient de l'intensité de la
      force pressante F, équivalente à ces actions, à la surface pressée s. Soit : p = F/s. »
    - « La pression est une grandeur mesurable. Elle s'exprime dans le système international en
      pascal, de symbole Pa. »
    - « Le pascal est une unité très petite, on utilise ses multiples tels que le bar et le
      millibar : 1 bar = 10⁵ Pa ; 1 millibar = 10² Pa. »
  - **Aperçu historique** (p.204) : recherche sur le savant **Pascal (1623–1662)**.
  - **Exercice résolu** (p.205) : patineuse m = 54 kg, aire de contact des deux patins avec la
    glace s = 30 cm², g = 9,8 N.kg⁻¹, masse des patins négligée. 1) pression exercée par le poids
    sur la glace : p = P/s = 176,4.10³ Pa (surface convertie en m²). 2) pression si elle marche
    avec ses chaussures, aire de chaque chaussure S = 160 cm² (deux chaussures) : p' = 16,5.10³ Pa. 3) p est plus de dix fois supérieure à p' — la glace, dure, ne s'enfonce pas même fortement
    pressée, mais permet à la patineuse de glisser avec peu de frottement grâce à la petite aire
    de contact.
  - **Exercices — Vérifier ses acquis** (p.206) : phrases à compléter (force répartissant son
    action sur une portion de « surface » = force pressante ; pression p = « quotient » de la
    force pressante à l'aire s de la « surface pressée » ; à forces égales, pression d'autant plus
    grande que la surface pressée est « petite ») ; vrai/faux motivé (pression ↑ → déformation ↑
    et vice-versa ; augmenter la pression ne peut se faire qu'en diminuant la surface ; les skis
    diminuent-ils la force pressante exercée sur la neige ?) ; choix des mots exacts (unité SI de
    pression : pascal/bar/millibar ; grandeur scalaire/vectorielle, notée Pa/p ; traverses de
    voies ferrées augmentent/diminuent la surface pressée pour réduire la pression/la force).
    « Utiliser ses acquis dans des situations simples » (p.206–207) : pince coupante, s = 0,8 mm²,
    F = 100 N → pression (choix parmi 0,8.10⁻⁴ / 125 / 125.10⁶ Pa) ; skieur m = 80 kg, chaque ski
    S = 0,225 m² → pression sur la neige, comparée à chaussures s = 225 cm² chacune ; deux corps de
    même masse posés sur un support (pression la plus grande selon la forme ; cas d'un contact
    ponctuel — valeur de la pression et conséquence pour le support). « Utiliser ses acquis pour
    une synthèse » (p.207–208) : punaise enfoncée avec F = 20 N, tête de diamètre D = 6 mm, pointe
    de surface s = 0,03 mm² (calcul de la surface de la tête S, pression sur la punaise, pression
    transmise à la planche) ; brique homogène m = 3 kg, dimensions a=5 cm, b=10 cm, c=20 cm, posée
    sur du plâtre (poids, pression dans les trois positions possibles, comparaison) ; bâtiment de
    masse totale M = 1000 tonnes (force pressante sur les fondations, aire de la surface pressée
    pour une pression de 1 bar ; couche de terre d'épaisseur e = 60 cm, masse volumique
    ρ = 1,4 g.cm⁻³, pression exercée sur la terrasse).
  - **Savoir plus — Les fondations** (p.208) : rôle des fondations, taux de travail admissible des
    sols (en MPa ou bar, 1 bar = 0,1 MPa) ; sols rocheux/granuleux stables, sols argileux/limoneux
    plus instables surtout humides ; types de fondations — superficielles (semelles filantes en
    béton armé, ~90% des constructions), superficielles par radier général, profondes sur pieux/
    micropieux avec longrine ; protection contre le gel (profondeur de garde de 25 cm à plus d'un
    mètre selon la région et l'altitude).
    _(Le chapitre s'arrête à la p.208. La **p.209 n'en fait pas partie** : c'est la **page d'ouverture
    normale** du ch.14 (« CHAPITRE I / L'ENERGIE / ENERGIE ET CONTRÔLE »), désormais transcrite en §2.14
    avec son plan et ses pré-requis. La version pilote la rattachait ici comme une « transition » dont le
    contenu serait « hors périmètre, non transcrit » — **doublement faux** : la structure est régulière
    (§2) et ce contenu est **exigé par R-5**. **Corrigé le 2026-07-17**.)_
- **Concepts / notions** : transmission d'une force par un solide (action localisée ou répartie) ;
  force pressante F ; surface pressée s ; pression p = F/s (pascal, Pa) ; multiples (bar,
  millibar) ; relation entre pression, force pressante et surface (à force égale, pression
  inversement liée à la surface ; à surface égale, pression proportionnelle à la force) ;
  applications : instruments tranchants/pointus (forte pression, petite surface), machines-outils
  (forte pression, grande force), skis/raquettes/chenilles/traverses/socles (faible pression,
  grande surface).
- **Vocabulaire officiel** : « force pressante », « surface pressée », « corps pressant »,
  « corps pressé », « pression (p) », « pascal (Pa) », « bar », « millibar », « empreinte »,
  « base d'appui » (repris du chapitre 12), « tranchant », « pointu ».
- **Bornes de scope** :
  - ✅ **INCLUS** : transmission d'une action mécanique par un solide en contact (localisée ou
    répartie) ; construction expérimentale de la notion de force pressante (normale à la surface,
    uniforme) ; définition et calcul de la pression p = F/s en pascal, conversions bar/millibar ;
    analyse qualitative des applications (fortes vs faibles pressions) via la surface et/ou la
    force.
  - ⛔ **EXCLU (hors périmètre de ce chapitre, relève d'autres parties du programme)** : pression
    dans les fluides (hydrostatique, principe de Pascal appliqué aux liquides, poussée
    d'Archimède) — non abordée ici, cette activité traite uniquement de la pression exercée par un
    **corps solide** sur un support solide ; aucune formule de pression hydrostatique
    (p = ρ.g.h) n'apparaît dans ce chapitre ; l'**énergie** (thème suivant du manuel) relève du
    **ch.14**, transcrit en §2.14. _(La version pilote écrivait ici que le ch.14 était « hors du
    périmètre demandé (chapitres 10 à 13 uniquement) » — reliquat du **découpage en tranches** de la
    transcription, sans objet dans cette fiche qui couvre les **17 chapitres**. Retiré le
    2026-07-17.)_

## 2.14 Physique — Chapitre 14 : Énergie et contrôle (p.209–226, transcrit à profondeur de génération)

**Désignation imprimée (p.209)** : « **CHAPITRE I** » · thème « **L'ENERGIE** » · titre « **ENERGIE ET
CONTRÔLE** » — concordant avec le sommaire p.5.

- **Page d'ouverture** (p.209) :
  - **Plan des activités expérimentales** (verbatim) : « • Activités(I) : Sources d'énergie renouvelables et
    sources d'énergie non renouvelables » · « • Activités(II) : Les principales formes d'énergie » ·
    « • Activités(III) : Transformations mutuelles des formes d'énergie » · « • Activités(IV) : Les différents
    modes de transfert d'énergie » · « • Activités(V) : Les deux modes de transfert d'énergie par chaleur : la
    conduction et la convection » · « • Activités(VI) : Isolation thermique » · « • Activités(VII) : Energie et
    contrôle ». _(Les 7 sont bien imprimées dans le corps.)_
  - **Pré-requis** (verbatim) : « Changement d'état physique de la matière » · « Le thermomètre et son
    utilisation » · « Mouvement ».

- **Structure de la leçon** :
  - **Activités de mise en situation** (p.210–211) : quatre mises en situation illustrées avec
    questions ouvertes — « Quelle est l'origine de l'énergie du Soleil ? », « Comment cette
    énergie atteint-elle la surface de la Terre ? », « Le bois est-il une source d'énergie ? »,
    « Si oui est-elle renouvelable ou non ? » (p.210) ; « Sous quelle forme une éolienne
    transforme-t-elle l'énergie du vent ? », « Sous quelle forme les animaux stockent-ils
    l'énergie des aliments ? », « Le gaz naturel est-il une source d'énergie renouvelable ou
    non ? », « Comment la chaleur se transmet-elle dans les solides, les liquides et les gaz ? »,
    « Que signifie, isoler thermiquement un corps ? » (p.211).
  - **Activités expérimentales** (p.212–219) — **7 activités numérotées (I→VII)**, plus le bloc
    « Interprétation microscopique » qui n'est **pas** une activité numérotée du manuel — soit
    **8 blocs** décrits ci-dessous. _(Bornes et décompte rectifiés le 2026-07-17 : la version pilote
    annonçait « p.212–218 — 7 blocs » puis en énumérait 8 ; l'Activité VII court jusqu'à la p.219
    incluse.)_
    1. **Activité I** — sources d'énergie renouvelables / non renouvelables : classement de
       photos (charbon, vent, pétrole, Soleil, bois, uranium, marées, geyser). **Généralisations
       officielles** : « Le Soleil, le vent, les marées, la biomasse (végétaux et animaux) et la
       géothermie (eau en contact avec des roches volcaniques) sont des sources d'énergie
       renouvelables vu qu'elles produisent de l'énergie de manière relativement illimitée dans le
       temps. Elles sont non polluantes et dont l'exploitation cause le moins de dégâts
       écologiques. » ; « Le charbon, le gaz naturel, le pétrole et l'uranium sont des sources
       épuisables d'énergie : elles disparaissent petit à petit au fur et à mesure qu'elles
       produisent de l'énergie. Elles sont dites sources d'énergie non renouvelables. »
    2. **Activité II** — formes d'énergie : « Un ensemble de particules matérielles constitue un
       système matériel. » « L'énergie totale d'un système est la somme de son énergie
       macroscopique (ou mécanique) et de son énergie microscopique. » Remarque : l'énergie
       mécanique est la somme de l'énergie cinétique macroscopique (mouvement d'ensemble :
       voiture, vent, vagues) et de l'énergie potentielle macroscopique (interactions entre
       parties : ressort, perche, système {Terre-fusée}) (p.212). L'énergie microscopique est la
       somme de l'énergie cinétique microscopique (agitation des particules, dite énergie
       thermique) et de l'énergie potentielle d'interaction microscopique (énergie chimique,
       énergie nucléaire…) (p.213).
    3. **Activité III** — conversion d'énergie (p.213) : génératrice de bicyclette → lampe
       (énergie cinétique → électrique → thermique) ; pile + moteur → ventilateur (énergie
       chimique → électrique → mécanique) ; cellules photovoltaïques (solaire → électrique) ;
       dromadaire (chimique microscopique des aliments → mécanique/cinétique).
       **Généralisation officielle** : « L'énergie contenue dans l'Univers est conservée. Elle
       peut passer d'une forme à une autre sans augmentation ni diminution. » « Les objets qui
       transforment l'énergie d'une forme à une autre sont appelés des convertisseurs d'énergie. »
       « Lorsqu'un système perd ou gagne de l'énergie, c'est toujours le résultat d'un transfert
       avec l'extérieur, c'est-à-dire avec le système environnant. » « L'énergie d'un système ne
       peut pas, en général, être mesurée ; seules les variations d'énergie sont mesurables. »
       « La variation d'énergie, notée ΔE, s'exprime dans le système international en joule, de
       symbole J. » Unités annexes : calorie (1 cal = 4,187 J), kilowattheure (1 kWh = 3,6.10⁶ J),
       électron-volt (1 eV = 1,6.10⁻¹⁹ J) (p.214). Remarques chiffrées : besoins énergétiques
       vitaux d'un adulte ≈ 2.10⁵ calories/jour ; 1 m² de surface terrestre éclairée
       orthogonalement reçoit en moyenne 1000 J/s. Tableau « Équivalence énergétique d'une
       tonne de différentes sources d'énergie en joule » : pétrole 4,2.10¹⁰, houille 2,6.10¹⁰,
       lignite 1,7.10¹⁰, essence 4,4.10¹⁰, fioul 4,6.10¹⁰, uranium 4,2.10¹⁴ (p.214).
    4. **Activité IV** — modes de transfert d'énergie (p.214–215) : tracteur/remorque → travail
       mécanique WM ; pile/ventilateur → travail électrique WE ; four à micro-ondes/eau →
       rayonnement WR ; récipient métallique chaud immergé dans eau froide → chaleur Q, notée Q.
       **Généralisation officielle** : « L'énergie mécanique du tracteur est transférée par
       travail mécanique à la remorque chargée. Le travail mécanique est un mode de transfert
       d'énergie entre deux systèmes. Il est notée WM. » « L'énergie chimique de la pile est
       transférée par travail électrique au ventilateur. » « L'énergie thermique du four à
       micro-ondes est transférée à l'eau par rayonnement. » « La chaleur est un mode de
       transfert d'énergie (microscopique) entre deux sources. Elle est notée Q. » Remarque :
       « Le transfert d'énergie thermique par chaleur entre un corps pur et le milieu extérieur
       environnant peut provoquer, soit une variation de la température de ce corps, soit un
       changement de son état physique à température constante. »
    5. **Activité V** — modes de transfert par chaleur (p.215–216) : tige métallique chauffée à
       une extrémité → conduction thermique (« La propagation de la chaleur s'est produite de
       proche en proche dans la tige sans aucun transfert de matière. ») ; sciure de bois dans
       bécher chauffé à la base → convection (« Une partie de l'énergie thermique initialement
       fournie au liquide par la flamme du bec bunsen est transférée par chaleur des parties
       chaudes vers les parties froides du liquide par déplacement de matière. »). Remarque :
       distinction chaleur (mode de transfert, en joule) vs température (grandeur caractéristique
       de l'énergie thermique, en °C ou K).
    6. **Interprétation microscopique** (p.217) : agitation thermique = énergie cinétique
       microscopique des particules ; la température renseigne sur l'agitation moyenne ;
       contact corps chaud/froid → répartition de l'agitation ; lors d'un changement d'état, la
       chaleur fournie/perdue ne modifie pas la température mais brise/reforme les liens entre
       molécules.
    7. **Activité VI** — isolation thermique (p.217) : eau chaude dans calorimètre fermé, la
       température reste pratiquement la même. **Généralisation officielle** : « Le calorimètre
       ne permet pas l'échange d'énergie thermique avec le milieu extérieur. On dit qu'il est
       thermiquement isolé. Toute enceinte permettant de réaliser cette isolation est qualifiée
       d'enceinte adiabatique ou d'enceinte calorifugée. » Exemples : chambres froides,
       glacières, réfrigérateurs, wagons frigorifiques (double paroi bois + liège + carton +
       feutre), bouteille thermos.
    8. **Activité VII** — économiser l'énergie (p.218–219) : Tunisie dépend surtout de sources
       non renouvelables (pétrole, gaz naturel, bois, charbon) ; conseils chiffrés — lampes
       fluorescentes (durée de vie 8000 h, 7–8× plus longue, consomment 5× moins que les
       incandescentes) ; réfrigérateur à ≥ 10 cm d'un mur ; chauffage/climatisation : « chauffer
       (ou refroidir) une pièce d'un degré de plus (ou de moins) entraîne une surconsommation de
       7 % » ; briques creuses (air emprisonné, mauvais conducteur) vs briques pleines ; laine de
       verre / polystyrène / mélange argile-paille en double cloison ; conduite automobile calme
       (écart de consommation jusqu'à 40 % vs conduite brutale) ; +100 kg dans une voiture ≈
       +0,5 L/100 km ; domotique (thermostats programmables, détecteurs de présence, chauffe-eau
       solaire en amont du classique).
  - **Fiche T.P.** (p.220) — « Élévation de la température d'un corps » : buts (étudier les 4
    façons d'élever la température : par chaleur, par rayonnement, par travail électrique, par
    travail mécanique) ; matériel (4 béchers d'eau numérotés, résistance chauffante, brûleur à
    gaz, four micro-ondes, source électrique, thermomètre, agitateur mécanique/batteur à
    œufs) ; protocole en 4 volets (bécher 1 sur brûleur à gaz ; bécher 2 avec résistance
    chauffante ; bécher 3 au four micro-ondes ; bécher 4 agité mécaniquement), suivi de la
    température et schéma des transferts énergétiques pour chacun.
  - **Recherche documentaire** (p.221) — « L'énergie solaire » : le Soleil « véritable réacteur
    nucléaire » ; origine solaire de l'éolien, de l'hydraulique et de la biomasse (photosynthèse) ;
    rayonnement moyen ≈ 2500 kWh.m⁻² près de l'équateur, ≈ 2000 kWh.m⁻² en Tunisie ;
    applications (chauffage eau/locaux, photovoltaïque, thermo-hélioélectrique à concentration).
    Questions associées (p.221) : sens du mot « biomasse », pourcentage d'énergie solaire reçu
    par le sol, avantages de l'énergie solaire.
  - **L'essentiel du cours** (p.222, formulation officielle — verbatim) :
    - « On appelle source d'énergie renouvelable toute source qui produit de l'énergie de manière
      relativement illimitée dans le temps. »
    - « Les sources épuisables d'énergie disparaissent petit à petit au fur et à mesure qu'elles
      produisent de l'énergie. Elles sont dites sources non renouvelables. »
    - « L'énergie totale d'un système et la somme de son énergie mécanique et de son énergie
      microscopique. »
    - « L'énergie contenue dans l'Univers se conserve mais, elle peut se transformer d'une forme
      à une autre. »
    - « Les objets qui transforment l'énergie d'une forme à une autre sont appelés des
      convertisseurs d'énergie. »
    - « Lorsqu'un système perd ou gagne de l'énergie, c'est toujours le résultat d'un transfert
      avec l'extérieur, c'est-à-dire avec le système environnant. »
    - « L'énergie d'un système ne peut pas, en général, être mesurée ; seules les variations
      d'énergie sont mesurables. »
    - « La variation d'énergie, notée ΔE, s'exprime dans le système international en joule, de
      symbole J. »
    - « Les transferts d'énergie s'effectuent par travail mécanique (noté WM) ou travail
      électrique noté (WE) ou travail rayonnant noté (WR) ou chaleur (notée Q). »
    - « Le travail est un mode de transfert ordonné d'énergie, alors que chaleur est un mode de
      transfert désordonné d'énergie. »
    - « La chaleur est un transfert d'énergie microscopique entre deux systèmes. Ce transfert
      s'effectue spontanément, par conduction ou par convection, du corps chaud vers le corps
      froid. »
    - « L'énergie thermique est liée à l'agitation des particules (molécules, ions, atomes),
      appelée agitation thermique. Elle représente l'énergie cinétique microscopique des
      particules composant la substance considérée. La température renseigne sur cette agitation
      incessante et désordonnée des particules. »
    - « Toute enceinte empêchant tout échange de chaleur avec le milieu extérieur est qualifiée
      d'enceinte adiabatique ou d'enceinte calorifugée. Elle réalise une isolation thermique. »
  - **Aperçu historique** (p.222) : renvoi à deux sites internet pour rechercher les découvertes
    du savant **Joule (1642/1727)** [dates telles qu'imprimées dans le texte source ; la vraie
    date de naissance de James Prescott Joule est 1818, probable coquille du manuel ou artefact
    OCR — signalé en incertitude, non corrigé pour rester fidèle à la source].
  - **Exercice résolu** (p.223) : circuit électrique (pile, fils, interrupteur, lampe à
    incandescence). 1) schéma du circuit. 2) source d'énergie = la pile (chimique), transférée par
    travail électrique. 3) la lampe reçoit du travail électrique, le retransfère par chaleur et
    rayonnement (énergie thermique) ; pile et lampe = convertisseurs d'énergie.
  - **Exercices** (p.224–225) : **Vérifier ses acquis** — phrases à compléter (sources d'énergie
    renouvelables/non renouvelables ; les modes de transfert thermique — 3 modes) ; vrai/faux
    motivé (deux formes d'énergie mécanique/microscopique ; chaleur en °C ; corps pur en
    changement d'état) ; choisir le(s) mot(s) exact(s) (travail/chaleur/rayonnement = modes de
    transfert ; enceinte adiabatique ; moteur = convertisseur, essence = source). **Utiliser ses
    acquis dans des situations simples** — rasoir électrique à pile (source = pile, convertisseur
    = moteur) ; rôle isolant de la laine de verre/liège en double cloison ; radiateur électrique à
    ventilateur alimenté par le secteur (analyse des transferts + schéma). **Utiliser ses acquis
    pour une synthèse** — tube à essais avec glace au fond, rondelle métallique, eau chauffée par
    résistance en surface qui bout sans faire fondre la glace (isolation, transferts) ; tableau à
    compléter avec des convertisseurs (lampe, pile, électrolyseur, moulin traditionnel, moteur
    électrique, réacteur de fusée, brûleur à gaz, centrale thermique, moteur à vapeur, génératrice
    de bicyclette, agitateur magnétique, tête à combustion) croisant formes d'énergie converties
    (mécanique/électrique/chimique/thermique) ; pompe solaire (moteur électrique + batterie +
    cellules photovoltaïques) — source/convertisseur, chaîne énergétique, formes stockées.
  - **Savoir plus** (p.226) — « La centrale nucléaire » : principe (chaleur de l'uranium →
    vapeur → turbine → alternateur → électricité) ; contrôle de la réaction en chaîne par des
    barres de contrôle absorbant les neutrons ; barres de sécurité automatiques en cas d'anomalie.
    Schéma légendé (barres de contrôle, cuve, échangeur, pompe, eau, vapeur).
- **Concepts / notions** : source d'énergie renouvelable / non renouvelable (épuisable) ; système
  matériel ; énergie totale = énergie macroscopique (mécanique) + énergie microscopique ; énergie
  cinétique / potentielle macroscopique ; énergie cinétique microscopique (thermique) / potentielle
  d'interaction microscopique (chimique, nucléaire) ; conservation de l'énergie ; convertisseur
  d'énergie ; transfert d'énergie avec l'extérieur ; variation d'énergie ΔE (joule) ; unités
  annexes (calorie, kWh, eV) ; modes de transfert : travail mécanique (WM), travail électrique
  (WE), rayonnement (WR), chaleur (Q) ; conduction thermique ; convection ; agitation thermique ;
  température vs chaleur ; enceinte adiabatique / calorifugée ; économie d'énergie ; domotique.
- **Vocabulaire officiel** : « source d'énergie renouvelable/non renouvelable », « système
  matériel », « énergie mécanique », « énergie microscopique », « convertisseur d'énergie »,
  « joule (J) », « travail mécanique (WM) », « travail électrique (WE) », « rayonnement (WR) »,
  « chaleur (Q) », « conduction thermique », « convection », « agitation thermique », « enceinte
  adiabatique », « enceinte calorifugée », « calorimètre ».
- **Bornes de scope** :
  - ✅ **INCLUS** : classification renouvelable/non renouvelable ; énergie totale = mécanique +
    microscopique (approche qualitative, sans calcul d'énergie cinétique ½mv² à ce stade — aucune
    formule chiffrée d'énergie cinétique/potentielle n'apparaît dans ce chapitre) ; conservation
    et conversion de l'énergie ; les 4 modes de transfert (WM, WE, WR, Q) et leur identification
    dans des situations concrètes ; distinction chaleur/température ; conduction vs convection ;
    isolation thermique (enceinte adiabatique) ; sensibilisation aux économies d'énergie.
  - ⛔ **EXCLU (hors chapitre)** : calcul quantitatif de l'énergie cinétique (½mv²) ou de l'énergie
    potentielle (mgh) — relève des chapitres de mécanique (10–13) déjà vus mais non repris ici
    avec formules ; calcul de la quantité de chaleur Q = mcΔθ (aucune formule de calorimétrie
    chiffrée n'apparaît dans le texte transcrit) ; notions de puissance et de rendement
    énergétique (non mentionnées) ; étude quantitative de la propagation thermique (loi de
    Fourier, coefficients de conductivité) — hors-programme, resté qualitatif.

## 2.15 Physique — Chapitre 15 : La Terre et l'univers (p.227–242, transcrit à profondeur de génération)

- **Plan des activités expérimentales officiel** (p.227) : Activités(I) Les corps célestes ;
  Activités(II) Les constellations ; Activités(III) La Voie Lactée : notre Galaxie ;
  Activités(IV) Le système solaire ; Activités(V) La succession des jours et des nuits et celle
  des saisons. **Pré-requis** (p.227) : la matière et ses états ; masse et densité ; notion de
  mouvement.
- **Structure de la leçon** :
  - **Activités de mise en situation** (p.228–229) : « Le ciel a-t-il le même aspect à
    différentes époques de l'année ? », « De quoi est constitué l'Univers ? », « Qu'appelle-t-on
    étoiles, constellations et galaxies ? », « Qu'appelle-t-on étoiles filantes ? », « Quelles
    différences y a-t-il entre un météore et un météorite ? » (p.228) ; « De quoi est constitué
    le système solaire ? », « Comment reconnaître à l'œil nu une planète parmi les étoiles ? »,
    « Sommes-nous immobiles dans l'Univers ? », « Comment explique-t-on la succession des jours
    et des nuits ainsi que celle des saisons ? », « La Lune tourne-t-elle autour d'elle même ? »
    (p.229).
  - **Activités expérimentales** (p.230–235) — 5 blocs :
    1. **Activité I** — observation du ciel nocturne (p.230). **Généralisations officielles** :
       « Les corps lumineux qui scintillent sont appelés étoiles. Ils sont situées à des
       distances très grandes de la Terre. Le Soleil est une étoile. » « Les corps qui émettent de
       la lumière sans scintiller sont appelés des planètes. La Terre est une planète. » « Le corps
       lumineux qui change d'aspect est la Lune. C'est un satellite naturel de notre planète
       Terre. » Satellites artificiels ; « Quelques traînées sont observées la nuit. Il s'agit de
       petits corps célestes appelés astéroïdes, qui se trouvant proche de la Terre, s'en
       rapprochent et brûlent au contact de l'atmosphère. […] On parle alors de météores ou
       d'étoiles filantes. […] tombent sur le sol avec une grande vitesse créant ainsi des
       cratères. Ce sont des météorites. »
    2. **Activité II** — constellations (p.231). « Chaque groupement d'étoiles vu dans une même
       région du ciel est appelé Constellation. » « Les étoiles d'une même constellation n'ont pas
       le même éclat, ce qui veut dire qu'elles ne sont pas situées à la même distance de la
       Terre. C'est un effet de perspective… » Constellations citées : Orion, Gémeaux, Cassiopée,
       Balance, Vierge, Grande Ourse, Aigle, Cygne, Petite Ourse, Lion, chien de chasse. Repérage
       du Nord par l'étoile Polaire à partir de la Grande Ourse (« environ 5 fois » la distance du
       bord de la « casserole »). Unité **année-lumière** : « Une année lumière est la distance
       que parcourt, dans le vide, un signal lumineux pendant une durée d'une année avec la
       célérité (vitesse de propagation) c = 3.10⁸ m.s⁻¹ : 1 a.l = 1 × 365 × 24 × 3600 × 3.10⁸ ≈
       9,46.10¹² km. » Exemple chiffré : Proxima du Centaure à 4,22 a.l ; distance Terre-Soleil ≈
       8 mn-lumière. Remarque : durée de vie d'une étoile liée à sa taille (Soleil ≈ 10 milliards
       d'années) ; couleur bleue (jeune, très chaude) → jaune (adulte) → géante rouge (fin de vie) ;
       lumière reçue aujourd'hui peut provenir d'étoiles déjà disparues.
    3. **Activité III** — la Voie Lactée (p.232). « Cette traînée fait partie d'un ensemble de
       200 milliards d'étoiles qui constitue notre Galaxie : c'est la Voie Lactée. » « La voie
       Lactée, née il y a environ 15 milliards d'années, est une galaxie spirale qui ressemble à
       un grand disque qui aurait une bosse en son milieu et de grands bras couverts d'étoiles. Le
       Soleil se situe sur l'un de ses bras à 30 000 a.l. de son centre. » Diamètre ≈ 100 000 a.l,
       épaisseur 15 000 a.l. Autres galaxies : Andromède (hémisphère nord), Magellan (hémisphère
       sud) ; galaxies groupées en amas (« Amas Local » : Voie Lactée + Magellan + Andromède + une
       vingtaine d'autres).
    4. **Activité IV** — le système solaire (p.233–234). « On compte neuf corps célestes en
       mouvement autour du Soleil. » Soleil : « boule de gaz incandescente », température de
       surface ≈ 6 000 °C, température au centre ≈ 15 000 000 °C, âge estimé 5 milliards d'années,
       durée de vie restante ≈ 5 milliards d'années. Mars, Jupiter, Saturne visibles au Sud ;
       Mercure et Vénus au crépuscule à l'Ouest ou à l'aube à l'Est. Huit planètes : orbites
       elliptiques planes dans le plan de l'écliptique ; Pluton (9ᵉ planète, la plus lointaine),
       orbite elliptique légèrement inclinée. Satellites : toutes les planètes sauf Mercure et
       Vénus en possèdent. Anneaux (Saturne, Uranus, Neptune) constitués de roches et de glace
       (hélium, méthane, hydrogène, ammoniac). Ceinture d'astéroïdes entre Mars et Jupiter.
       Comètes (comète de Halley, visible tous les 76 ans). Deux familles séparées par la
       ceinture d'astéroïdes (p.234) : « famille des planètes internes ou telluriques : Mercure,
       Venus, la Terre et Mars […] densité relativement élevée, une rotation lente, une surface
       solide, pas d'anneaux et peu de satellites » ; « famille des Planètes externes ou
       gazeuses : Jupiter, Saturne, Uranus, Neptune et Pluton […] principalement composées
       d'hydrogène et d'hélium et généralement ont une faible densité, une rotation rapide, des
       atmosphères épaisses, des anneaux et beaucoup de satellites. » Période de rotation de la
       Terre = 23 h 56 mn (un jour) ; période de révolution = 365,25 j (une année).

       **Tableau « Caractéristiques \ Planète » (p.234) — transcrit tel qu'imprimé.**
       ⚠️ **Provenance** : ce tableau est une **image raster** — il est **absent de la couche-texte**
       (preuve auxiliaire : le tableau « à cocher » de la p.241 est, lui, **vectoriel**, et `pdftotext`
       le capte ; « Mercure » n'apparaît jamais dans le `.txt` des p.240/241). Il a été **levé en passe
       vision 400 dpi sur la p.234** par la relecture R-7 du 2026-07-17 (tranche ch.14–15), **non par
       une lecture du `.txt`**. L'en-tête est une **cellule barrée en diagonale** : « Planète »
       (haut-droite) / « Caractéristiques » (bas-gauche).

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

       ⚠️ Le manuel écrit « **Venus** » **sans accent** dans ce tableau (et p.238), mais « **Vénus** »
       **avec** accent p.233 — incohérence de la source, **signalée, non arbitrée** (§6.3).
       **C'est le tableau référent de deux exercices** : la p.240 (« utiliser ses acquis ») et la p.241
       (synthèse 1) y renvoient explicitement (« En vous aidant des informations fournies dans le
       tableau des caractéristiques des planètes »). Contrôle de cohérence effectué par la R-7 : les
       4 questions de la p.240 sont bien toutes résolubles par ce tableau (plus proche du Soleil →
       Mercure 57,93 ; la plus grosse → Jupiter 142264 ; la moins dense → Saturne 0,69 ; poids le plus
       grand → Jupiter 24,9 N/kg), et la p.241 en a besoin (diamètre Terre 12756, distance 149,6).

    5. **Activité V** — jours/nuits et saisons (p.235). Expérience du globe terrestre éclairé par
       une lanterne, tournant autour de l'axe polaire : « La rotation de la Terre autour de l'axe
       polaire engendre la succession des jours et des nuits. » Positions solaires caractéristiques
       (le manuel donne systématiquement une **double date**) : **21 (ou 22) juin** — rayons quasi
       orthogonaux sur Tunis, décalage maximal vers le nord (lever nord-est, coucher nord-ouest),
       début de l'été ; **22 (ou 23) septembre** et **20 (ou 21) mars** — lever à l'est, coucher à
       l'ouest (équinoxes, **non nommés explicitement** dans le texte).
       ⚠️ **Pour décembre, le manuel imprime DEUX dates différentes sur la même page — rapportées
       toutes les deux, non arbitrées** (§6.3) : « Le **21 (ou 22)** Décembre, les rayons solaires
       arrivent avec une inclinaison maximale » **puis**, plus bas, « Le **22 (ou 23)** Décembre, les
       rayons solaires tombent avec une inclinaison telle que le temps fera froid. **Il s'agit du début
       de l'hiver.** » ⇒ c'est la **seconde** phrase (22 ou 23) qui porte « début de l'hiver », pas la
       première. _(La version pilote de cette fiche fusionnait les deux et rattachait « début de
       l'hiver » au « 21 (ou 22) » — arbitrage non autorisé, **annulé le 2026-07-17**. Les deux dates
       sont confirmées imprimées par passe vision de la R-7, tranche ch.14–15.)_ Le décalage vers le
       sud (lever sud-est, coucher sud-ouest) est bien celui de décembre.
       **Phrase de la source contredisant sa propre suite** (imprimée, non arbitrée — §6.3) : « **A
       partir du début de l'hiver, le Soleil commence à se décaler vers le sud.** » (or le décalage sud
       est déjà maximal au solstice d'hiver).
       **Deux questions de clôture imprimées** : « **Les débuts des couper du jeun** [sic] **sont-ils à
       la même heure le long des années ?** » (phrase altérée dans la source — transcrite verbatim,
       **l'intention n'est pas devinée**, §6.4) ; « Dans la carte des saisons ci-dessus, repérez la
       position de la Terre à la date de votre naissance. » (⇒ renvoi à la « carte des saisons », figure
       non rendue — §6.2).
  - **Fiche T.P.** (p.236) — « Les constellations » : buts (construire une partie de la carte du
    ciel, retrouver des constellations connues, reconnaître le nord géographique) ; matériel
    (carte vierge du ciel, tableau de coordonnées d'étoiles) ; tableau de données angle/distance
    pour Étoile polaire (0°, 0), Véga (345°, 5,5 div), Castor (170°, 6,0 div), Arcturus (280°,
    7,0 div), Pollux (175°, 6,5 div), et **deux constellations dont les 12 points sont tabulés**
    (toutes les distances en **divisions**) :
    - **Grande Ourse**, points 1→7 : 275°/5,0 · 270°/3,5 · 260°/3,5 · 245°/3,5 · 240°/4,0 ·
      225°/3,5 · 225°/3,0
    - **Cassiopée**, points 1→5 : 95°/3,0 · 90°/3,5 · 85°/3,0 · 80°/3,5 · 75°/3,0

    _(Les 12 couples étaient présents dans la couche-texte mais résumés en « avec leurs
    angles/distances tabulés » par la version pilote ; restitués le 2026-07-17 — R-5 exige les données
    chiffrées, faute de quoi le T.P. n'est pas régénérable.)_ ⚠️ La **carte vierge du ciel** sur
    laquelle ces coordonnées se reportent est une **figure non rendue** (§6.2).

  - **Recherche documentaire** (p.237) — « Aurores polaires » : taches/bandes de lumière verte ou
    rouge, visibles depuis les hautes latitudes (≈ 70°, Scandinavie, nord de la Sibérie, Canada,
    Alaska, abords de l'Antarctique) ; émises dans l'ionosphère entre 80 et 150 km d'altitude ;
    causées par des collisions entre particules chargées venant du Soleil (via la magnétosphère)
    et les atomes/ions de l'ionosphère. Questions associées : sens des mots « magnétosphère »,
    « collision », « ionosphère » ; explication de la formation ; visibilité mondiale ou non.
  - **L'essentiel du cours** (p.238, formulation officielle — verbatim) :
    - « Chaque groupement d'étoiles vu dans une même région du ciel est appelé Constellation. »
    - « Ces constellations sont utilisées par nos ancêtres pour se repérer. Le nord est indiqué
      par l'étoile Polaire. La Polaire est facile à retrouver une fois la Grande Ourse (qui a
      l'aspect d'une casserole) est repérée. »
    - « Une année lumière est la distance que parcourt, dans le vide, un signal lumineux pendant
      une durée d'une année avec la célérité c = 3.10⁸ m.s⁻¹ : 1 a.l ≈ 9,46.10¹² km. »
    - « La voie Lactée, née il y a environ 15 milliards d'années, est une galaxie spirale qui
      ressemble à un grand disque qui aurait une bosse en son milieu et de grands bras couverts
      d'étoiles. Le Soleil se situe sur l'un de ses bras à 30 000 a.l. de son centre. »
    - « Les galaxies sont groupées en amas (notre Galaxie, la galaxie de Magellan et la galaxie
      d'Andromède et une vingtaine d'autres appartiennent à un même amas appelé l'Amas Local). »
    - « Le Soleil, les neuf planètes, leurs satellites, les astéroïdes et les comètes constituent
      ensemble le système solaire. »
    - « La ceinture d'astéroïdes sépare les planètes en deux familles : - Planètes internes ou
      telluriques : Mercure, Venus, la Terre et Mars. - Planètes externes ou gazeuses : Jupiter,
      Saturne, Uranus, Neptune et Pluton. »
    - « La rotation de la Terre autour de l'axe polaire engendre la succession des jours et des
      nuits. »
    - « Du fait de l'inclinaison de son axe par rapport à l'écliptique, plan de sa trajectoire, et
      de sa rotation autour du Soleil, la Terre présente le phénomène périodique des saisons. En
      hiver le Soleil s'élève moins sur l'horizon qu'en été, la durée d'exposition devient plus
      courte et les températures plus basses. »
  - **Aperçu historique** (p.238) : recherche sur le savant **Al Khawarizmi (780/850)**.
  - **Exercice résolu** (p.239) : l'étoile double Algol (constellation de Persée), éclat qui
    diminue toutes les ~2 jours pendant 4 h ; les deux étoiles tournent l'une autour de l'autre en
    2 j 20 h ; l'une 40× plus brillante que l'autre. 1) identifier les deux constellations
    (Cassiopée et Persée) et les deux étoiles (Polaire et Algol) sur une figure. 2) schéma
    Terre/deux étoiles montrant l'alignement produisant l'éclipse.
  - **Exercices** (p.240–241) : **Vérifier ses acquis** — phrases à compléter (système solaire :
    Soleil/planètes/satellites ; direction pour observer Mars/Jupiter/Saturne ; galaxies
    regroupées en amas) ; vrai/faux motivé (anneaux de Saturne/Uranus/Neptune ; année-lumière =
    unité de durée [faux, c'est une distance] ; toutes les étoiles brillent en continu [faux]) ;
    choisir le(s) mot(s) exact(s) (durée de vie du Soleil : 5/10/15 milliards d'années ;
    comètes/constellations ; couleur bleue→jaune→rouge selon l'âge de l'étoile). **Utiliser ses
    acquis dans des situations simples** — calcul de distance Proxima du Centaure (4,22 a.l → km,
    QCM (a) 40.10⁹ (b) 12,66.10⁸ (c) 39,92.10¹²) ; lecture du **tableau des caractéristiques des
    planètes** (planète la plus proche du Soleil, la plus grosse, la moins dense, poids le plus
    grand) — ⚠️ **le tableau n'est PAS imprimé sur cette page** : il est p.234 (Activité IV, où il est
    désormais transcrit intégralement) ; les p.240/241 ne font qu'y **renvoyer** ; tableau à
    cocher (Halley, Terre, Soleil, Véga, Lune, Io, Voie Lactée, Mars, Cassiopée) × catégories
    (Galaxie, Constellation, Étoile, Planète, Satellite, Comète). **Utiliser ses acquis pour une
    synthèse** — modèle réduit du système solaire (Soleil = boule de 14 cm de diamètre pour un
    diamètre réel de 1,4.10⁶ km, calcul du diamètre représentatif de la Terre et de la distance
    Terre-Soleil à l'échelle) ; schéma d'ellipses représentant les trajectoires planétaires
    (identification, nom des trajectoires = orbites, nom du plan = écliptique, classement en deux
    familles) ; observation d'un paysage et de la course du Soleil (lever/coucher, saison,
    durée jour/nuit).
  - **Savoir plus** (p.242) — « La naissance de l'Univers » : théorie du Big-Bang (explosion
    il y a environ 15 milliards d'années, Univers initial infiniment petit, ultra-dense, très
    chaud) ; loi de Hubble (vitesse d'éloignement d'une galaxie proportionnelle à sa distance) ;
    expansion actuelle sur environ 15 milliards d'années-lumière ; hypothèse du Big-Crunch.
- **Concepts / notions** : corps célestes (étoiles, planètes, satellites, astéroïdes, comètes,
  météores/étoiles filantes, météorites) ; constellation ; étoile Polaire ; année-lumière (a.l) ;
  Voie Lactée / Galaxie ; amas de galaxies ; système solaire (Soleil, neuf planètes, satellites,
  ceinture d'astéroïdes, comètes) ; écliptique ; planètes telluriques vs gazeuses ; rotation de la
  Terre (période 23 h 56 mn) ; révolution de la Terre (période 365,25 j) ; succession jours/nuits ;
  saisons (inclinaison de l'axe terrestre).
- **Vocabulaire officiel** : « étoile », « planète », « satellite naturel/artificiel », « météore »,
  « étoile filante », « météorite », « constellation », « étoile Polaire », « année-lumière (a.l) »,
  « Voie Lactée », « Galaxie », « amas », « système solaire », « orbite », « écliptique », « planète
  tellurique », « planète gazeuse », « comète », « rotation », « révolution », « saison ».
- **Bornes de scope** :
  - ✅ **INCLUS** : observation qualitative du ciel (étoiles/planètes/Lune/satellites/météores) ;
    notion de constellation et repérage par l'étoile Polaire ; unité année-lumière avec calcul de
    conversion simple (a.l → km) ; description de la Voie Lactée et des amas de galaxies ;
    composition du système solaire, deux familles de planètes (telluriques/gazeuses) ; rotation
    (jour/nuit) et révolution (saisons) de la Terre, dates caractéristiques (solstices/équinoxes,
    non nommés comme tels dans le texte officiel transcrit) ; **lecture et comparaison d'un tableau
    de données chiffrées** (distances, diamètres, densités, pesanteurs du tableau p.234) — c'est
    l'objet même de l'exercice p.240 et de la synthèse 1 p.241. _(Cette borne a été ajoutée le
    2026-07-17 : la version pilote ne pouvait pas la voir, faute d'avoir le tableau p.234.)_
  - ⛔ **EXCLU** : lois de Kepler et mécanique céleste quantitative (aucune formule
    gravitationnelle n'apparaît) ; calculs de masse/distance par la troisième loi de Kepler ;
    spectroscopie stellaire détaillée ; théorie du Big-Bang développée au-delà du paragraphe
    « Savoir plus » (hors essentiel du cours, non évaluable comme notion centrale) ; phases de la
    Lune et éclipses — traitées dans le **chapitre 16** (« La lumière et sa propagation »), pas
    dans ce chapitre 15.

## 2.16 Physique — Chapitre 16 : La lumière et sa propagation (p.243–258, transcrit à profondeur de génération)

- **Plan des activités expérimentales officiel** (p.243) : Activités(I) L'œil, un détecteur de
  lumière ; Activités(II) Sources primaires et sources secondaires de lumière ; Activités(III)
  Propriété de la matière vis-à-vis de la lumière ; Activités(IV) Propagation rectiligne de la
  lumière ; Activités(V) Ombre et pénombre ; Activités(VI) Les phases de la Lune - Les éclipses.
  **Pré-requis** (p.243) : étoiles, planètes et satellites ; théorème de Thalès ; milieu homogène.
- **Structure de la leçon** :
  - **Activités de mise en situation** (p.244–245) : « Voit-on cet objet lorsque les bougies sont
    éteintes ? », « Les bougies sont-elles des sources de lumière primaires ou secondaires ? »,
    « Comment l'œil détecte-t-il les corps ? », « La Lune émet-elle de la lumière ? »,
    « Pourquoi, d'une nuit à une autre, la Lune nous apparaît-elle sous des formes différentes ? »
    (p.244) ; « Qu'appelle-t-on éclipse de Soleil ? », « Comment explique-t-on l'éclipse total de
    Soleil ? », « Quel phénomène optique régit le fonctionnement d'un cadran solaire ? »,
    « Pourquoi la longueur de l'ombre, à la même heure, change-t-elle suivant les saisons ? »,
    « Quelle différence y a-t-il entre l'ombre et le pénombre ? » (p.245).
  - **Activités expérimentales** (p.246–251) — 6 blocs :
    1. **Activité I** — l'œil détecteur de lumière (p.246) : livre posé sur une table, invisible
       dans le noir, visible une fois éclairé. **Généralisations officielles** : « Dans
       l'obscurité, les objets sont invisibles. Eclairés, ils deviennent visibles. Ils diffusent
       (renvoient dans toutes les directions) une partie de la lumière qu'ils reçoivent. » « Pour
       voir il faut que nos yeux reçoivent de la lumière. » « La lumière renvoyée par l'objet
       éclairé traverse les différents milieux transparents de l'œil pour former, sur la rétine,
       l'image de cet objet. » « L'œil joue le rôle de détecteur de lumière. » Encadré : « Un
       objet n'est visible que s'il renvoie dans nos yeux, une partie de la lumière qu'il reçoit. »
       Remarque : pellicules photographiques et végétaux chlorophylliens = détecteurs chimiques ;
       capteurs CCD (caméras) et cellules photovoltaïques = détecteurs électroniques.
    2. **Activité II** — sources de lumière (p.247) : observation du Soleil, de la Terre, de la
       lave (photos). « Le Soleil, la lave et les lampes émettent la lumière qu'ils produisent. »
       « La Terre, la Lune et l'atmosphère diffusent la lumière qu'ils reçoivent. » **Définitions
       officielles** : « Une source de Lumière est un objet qui émet de la lumière. On distingue
       deux types d'émetteurs de lumière : - Les sources primaires de lumière. Ce sont des corps
       qui produisent leur propre lumière. - Les sources secondaires de lumière. Ce sont des corps
       qui diffusent une partie de la lumière qu'ils reçoivent d'une autre source. » Remarque : le
       ciel nocturne paraît noir car la lumière solaire ne rencontre pas de particules matérielles
       à diffuser dans le vide spatial.
    3. **Activité III** — transparence de la matière (p.248) : trois plaques (verre C1, verre
       martelé C2, bois C3) sur le trajet d'un faisceau lumineux. **Définitions officielles** :
       « La plaque en verre laisse passer la lumière reçue sans la diffuser : c'est un corps
       transparent. » « La plaque en verre martelé laisse passer une partie de la lumière reçue et
       diffuse par sa surface le reste. C'est un corps translucide. » « La plaque en bois ne laisse
       pas passer la lumière reçue. Elle en absorbe une partie au niveau de sa surface qui diffuse
       le reste : c'est un corps opaque. » Question associée : classer eau, nuage, cuivre, papier
       huilé, carton, verre, fer, air, papier calque en transparent/translucide/opaque.
    4. **Activité IV** — propagation rectiligne (p.249–250) : filament de lampe visé à travers
       trois écrans percés d'un trou, seule la disposition alignée permet l'observation.
       **Généralisation officielle** : « Entre émetteur et récepteur, la lumière suit, au cours de
       sa propagation dans l'air, une ligne droite. On dit que la propagation de la lumière est
       rectiligne. » Modélisation par le « rayon lumineux » (droite fléchée) ; « faisceau de
       lumière » = ensemble de rayons issus d'une même source ; « pinceau de lumière » = faisceau
       étroit cylindrique. Trois types de faisceaux : parallèle/cylindrique (rayons parallèles
       entre eux), convergent (rayons se dirigeant vers un même point), divergent (rayons issus ou
       semblant provenir d'un même point). Expérience laser dans cuve d'eau pure (rectiligne) vs
       eau salée non mélangée (non rectiligne, milieu non homogène). « L'air, l'eau pure et le
       verre sont des corps homogènes transparents. » « Dans un milieu homogène transparent, la
       lumière se propage en ligne droite. Dans un milieu non homogène transparent, la propagation
       de la lumière n'est pas rectiligne. » Vitesse de propagation : « La vitesse de propagation
       (ou célérité) de la lumière dans le vide est égale à c : c = 3.10⁸ m.s⁻¹. Dans l'air, elle
       est voisine de c. »
    5. **Activité V** — ombre et pénombre (p.250) : sphère opaque éclairée par une source
       ponctuelle → « L'ombre de la sphère portée sur l'écran est un cercle qui a un contour bien
       défini. » Distinction « ombre propre » (partie non éclairée de la sphère elle-même) vs
       « ombre portée » (sur l'écran, plus grande que la sphère) ; « Aucun rayon lumineux n'arrive
       en un point de la zone d'ombre. » Avec une source étendue : contours flous, apparition
       d'une « zone d'ombre centrale : aucun rayon lumineux n'y parvient » et d'une « zone de
       pénombre : en s'éloignant de la zone d'ombre, une partie de plus en plus étendue de la
       source éclaire cette région. »
    6. **Activité VI** — phases de la Lune et éclipses (p.251). « Pour un observateur terrestre,
       la Lune effectue un tour en un mois lunaire de 29 jours et demi environ. Cette durée est
       appelée lunaison. […] On dit que la Lune présente différentes phases. » Quatre positions
       particulières : nouvelle Lune, premier quartier, pleine Lune, dernier quartier. « L'éclipse
       de Soleil » : « Dans la phase de nouvelle Lune, il arrive que la Lune passe entre la Terre
       et le Soleil. La Lune crée alors une ombre portée sur la Terre. Pour des observateurs
       terrestres situés dans cette ombre, la Lune peut masquer complètement le Soleil : c'est
       l'éclipse totale de Soleil. » « L'éclipse de Lune » : « Dans la phase de pleine Lune, il
       arrive que la Lune pénètre dans la zone d'ombre de la Terre. N'étant plus éclairée, elle
       devient invisible dans le ciel nocturne c'est une éclipse de Lune. Le Soleil, la Terre et
       la Lune sont alors alignés dans cet ordre. Deux éclipses de Lune consécutives sont séparées
       d'environ six mois. »
  - **Fiche T.P.** (p.252) — « Chambre noire » : buts (observer l'image d'une bougie sur l'écran
    d'une chambre noire ; appliquer la propagation rectiligne pour expliquer nature/position/
    grandeur de l'image ; étudier les effets de variation des caractéristiques — grandeur, netteté,
    luminosité) ; matériel (chambre noire à diaphragme et distance diaphragme-écran réglables,
    bougie, règle) ; protocole en 3 volets (variation de la distance diaphragme-objet à distances
    écran-objet et ouverture constantes ; variation de la distance écran-objet ; variation de
    l'ouverture du diaphragme), avec observation et interprétation à chaque fois.
  - **Recherche documentaire** (p.252–253) — « Le cadran solaire » : tige (« style ») + cadran
    gradué ; en 24 h la Terre tourne de 360°, soit 15°/heure, d'où la représentation d'1 heure par
    un angle de 15° sur le cadran ; nécessité d'ajouter 1 ou 2 heures selon l'époque pour l'heure
    légale. Questions associées : sens du mot « culmine », construction d'un cadran solaire,
    pourquoi ajouter des heures selon la saison.
  - **L'essentiel du cours** (p.254, formulation officielle — verbatim) :
    - « Un objet nous n'est visible que s'il envoie de la lumière, qu'il reçoit ou qu'il produit,
      dans nos yeux. »
    - « L'œil joue le rôle de détecteur de lumière. »
    - « Une source de Lumière est un corps qui émet de la lumière. On distingue deux types
      d'émetteurs de lumière : - Les sources primaires de lumière. Ce sont des corps qui
      produisent leur propre lumière. - Les sources secondaires de lumière. Ce sont des corps qui
      diffusent une partie de la lumière qu'ils reçoivent d'une autre source. »
    - « Un corps transparent laisse passer la lumière qu'il reçoit sans la diffuser. »
    - « Un corps translucide laisse passer une partie de la lumière qu'il reçoit tout en
      diffusant le reste par sa surafce [sic — coquille du manuel, « surface »]. »
    - « Un corps opaque ne laisse pas passer la lumière qu'il reçoit. Il en absorbe une partie et
      diffuse le reste par sa surface. »
    - « Dans un milieu homogène transparent, la lumière se propage en ligne droite : c'est le
      principe de la propagation rectiligne de la lumière. »
    - « La vitesse de propagation de la lumière dans le vide est égale à c : c = 3.10⁸ m.s⁻¹. Dans
      l'air, elle est voisine de c. »
    - « Le rayon lumineux est une représentation géométrique qui modélise le trajet suivi par la
      lumière pour aller d'un point à un autre. »
    - « L'ensemble des rayons lumineux issus d'une même source est appelé faisceau de lumière. »
    - « On distingue trois types de faisceaux lumineux : faisceau parallèle, faisceau convergent
      et faisceau divergent. »
    - « Lorsqu'une source étendue de lumière éclaire un objet opaque : - on ne voit pas la source
      de lumière si l'on se trouve dans la zone d'ombre ; - on voit une partie de la source
      lumineuse si l'on se trouve dans la zone de pénombre ; - on voit toute la source si l'on se
      trouve dans la zone éclairée. »
    - « La Lune est éclairée par le Soleil. Les formes visibles de la Lune, observé depuis la
      Terre, sont appelées les phases de la Lune : - si la Lune passe dans le cône d'ombre de la
      Terre, il y a éclipse de Lune ; - si une région de la Terre se trouve dans le cône d'ombre de
      la Lune, il y a éclipse de Soleil dans cette région. »
  - **Aperçu historique** (p.254) : recherche sur le savant **IBN ELHAITHEM (965/1040)** [sic —
    graphie et casse du manuel].
  - **Exercice résolu** (p.255) : construction géométrique de la position d'une source
    ponctuelle produisant l'ombre portée d'une craie (opaque) ; déplacement de la source dans un
    plan vertical (position 1 → 3), variation de longueur/orientation de l'ombre, construction de
    l'ombre en position 3.
  - **Exercices** (p.256–257) : **Vérifier ses acquis** — phrases à compléter (source primaire,
    objet éclairé, récepteur de lumière, milieux transparents traversés — scène de Fares lisant à
    travers une vitre ; corps translucide ; propagation en milieu homogène et transparent, rayon
    lumineux) ; vrai/faux motivé (écran de cinéma = source primaire vs écran de télévision =
    source secondaire ; eau pure transparente ; éclipse totale de Lune observée en tout point du
    cône d'ombre) ; choisir le(s) mot(s) exact(s) (envoie/reçoit de la lumière vers/en provenance
    de nos yeux ; nécessite/ne nécessite pas un milieu matériel ; image droite/renversée dans une
    chambre noire). **Utiliser ses acquis dans des situations simples** — forme de l'ombre portée
    d'un cylindre opaque donnée par une source ponctuelle sur un écran vertical — **QCM à deux
    volets, trois options chacun, sans corrigé imprimé** : « - dans le cas où l'axe du cylindre est
    vertical, est : (a) un disque ; (b) un triangle ; (c) un rectangle. - dans le cas où l'axe du
    cylindre est horizontal et perpendiculaire à l'écran, est : (a) un disque ; (b) un triangle ;
    (c) un rectangle. » ; étoile « Star » apparue en 1992, à 750 années-lumière (calcul de l'année de
    naissance de la lumière observée ; « la lumière est le messager des astres ») ; tableau nature
    d'objets (étoile, satellite, comète, œil, photopile, laser) → source primaire/secondaire/
    détecteur. **Utiliser ses acquis pour une synthèse** — Ahmed lisant son roman (identifier
    source primaire, objet diffusant, détecteurs ; choisir le bon schéma de trajet lumineux parmi
    (a)(b)(c)(d)) ; problème géométrique chiffré : source ponctuelle S, écran E, disque opaque D
    de rayon r = 4 cm à d₁ = 20 cm de S et d₂ = 80 cm de E, centre de S et D alignés — tracé de la
    zone d'ombre/pénombre, forme de l'ombre portée, démonstration par le théorème de Thalès de
    R = (1 + d₂/d₁)·r et calcul numérique, variation de R en rapprochant le disque de l'écran ;
    troisième planète du système solaire et son satellite naturel, cause d'une éclipse totale de
    Soleil et zone de totalité sur un schéma.
  - **Savoir plus** (p.257–258) — « Le laser » : acronyme « Light Amplification by Stimulated
    Emission of Radiation » (amplification de lumière par émission stimulée de rayonnement) ;
    « un **faisceaux** [sic] lumineux étroit », quasi parallèle, « **de couleur bien définie** » (le
    manuel n'écrit **pas** « monochromatique » ici — il réserve ce terme au ch.17), de grande
    intensité ; principe (cylindre
    rempli d'un composé chimique, miroirs réfléchissant la lumière, orifice de sortie) ;
    applications : télécommunications (fibre optique), médecine (fond de l'œil), microélectronique
    (circuits imprimés), télémétrie spatiale (distance Terre-Lune), spectacles.
- **Concepts / notions** : détecteur de lumière (œil, rétine) ; source primaire / source
  secondaire ; corps transparent / translucide / opaque ; propagation rectiligne de la lumière ;
  rayon lumineux ; faisceau parallèle / convergent / divergent ; célérité c = 3.10⁸ m.s⁻¹ ; ombre
  propre / ombre portée ; pénombre ; phases de la Lune (lunaison ≈ 29,5 j) ; éclipse de Soleil /
  éclipse de Lune ; cône d'ombre ; chambre noire.
- **Vocabulaire officiel** : « détecteur de lumière », « source primaire », « source secondaire »,
  « transparent », « translucide », « opaque », « rayon lumineux », « faisceau », « pinceau de
  lumière », « célérité », « ombre propre », « ombre portée », « pénombre », « lunaison »,
  « nouvelle Lune », « premier quartier », « pleine Lune », « dernier quartier », « éclipse
  totale de Soleil », « éclipse de Lune », « chambre noire ».
- **Bornes de scope** :
  - ✅ **INCLUS** : conditions de visibilité d'un objet (émission/diffusion de lumière vers l'œil) ;
    sources primaires/secondaires ; transparence/translucidité/opacité ; propagation rectiligne en
    milieu homogène (théorème de Thalès appliqué aux ombres, cas chiffrés) ; types de faisceaux ;
    valeur numérique de c ; construction géométrique d'ombre/pénombre ; phases de la Lune et
    mécanisme des deux types d'éclipses (Soleil/Lune).
  - ⛔ **EXCLU (relève du chapitre suivant)** : décomposition de la lumière blanche, spectre,
    couleurs des objets, daltonisme, illusions d'optique, ultraviolet/infrarouge (**chapitre 17**) ;
    lois de la réflexion/réfraction (Snell-Descartes) et formation d'images par miroirs/lentilles —
    non traitées dans ce chapitre (la chambre noire y est abordée uniquement via la propagation
    rectiligne, sans formule de grandissement).

## 2.17 Physique — Chapitre 17 : Spectre de lumière et vision (p.259–274, transcrit à profondeur de génération)

- **Plan des activités expérimentales officiel** (p.259) : Activités(I) Spectre de la lumière
  blanche ; Activités(II) Lumière blanche et vision des couleurs ; Activités(III) Le daltonisme ;
  Activités(IV) Les illusions d'optique ; Activités(V) L'énergie transportée par la lumière ;
  Activités(VI) L'ultraviolet et l'infrarouge ; Activités(VII) Adaptation aux températures
  extrêmes. **Pré-requis** (p.259) : diffusion de la lumière par les corps éclairés ; faisceaux
  lumineux ; propagation rectiligne de la lumière ; transfert d'énergie par rayonnement.
- **Structure de la leçon** :
  - **Activités de mise en situation** (p.260–261) : « Quel renseignement nous apporte
    l'observation d'un arc-en-ciel ? », « Peut-on observer tous les jours un arc-en-ciel ? »,
    « Par quels moyens peut-on former un spectre de lumière ? », « Pourquoi les objets ont-ils des
    couleurs ? », « Voit-on toujours l'objet avec sa couleur "réelle" ? » (p.260) ; « Voit-on
    toujours vrai ? », « Quelles sont les origines d'une illusion d'optique ? », « Pourquoi le port
    de lunettes spéciales est-il indispensable lors de la soudure à l'arc électrique ? », « Quand
    est-ce que les lunettes solaires sont-elles conseillées ? » (p.261).
  - **Activités expérimentales** (p.262–267) — 7 blocs :
    1. **Activité I** — spectre de la lumière blanche (p.262) : lumière blanche d'un
       rétroprojecteur traversant un prisme (« milieu transparent à faces planes et non
       parallèles ») ou un réseau. **Généralisations officielles** : « Le prisme (ou le réseau)
       décompose la lumière blanche en plusieurs lumières colorées. » « Chaque lumière colorée est
       appelée lumière monochromatique ou radiation simple. » « L'ensemble des couleurs constitue
       le spectre de la lumière blanche. » « Le spectre de la lumière blanche décomposée est
       constitué de lumières monochromatiques allant du rouge au violet en passant par toutes les
       lumières monochromatiques intermédiaires. Un tel spectre est dit continu. »
       **⚠️ Énumération officielle des 7 couleurs, imprimée sur la même page** (la version pilote ne
       retenait que la formule générique « toutes les lumières monochromatiques intermédiaires » et
       **perdait l'ordre des couleurs — dans un chapitre sur le spectre, c'est la donnée la plus
       générable de la page** ; restituée le 2026-07-17) : « Elle est constituée de lumières colorées
       allant du **rouge** au **violet** en passant par **l'orange, le jaune, le vert, le bleu et
       l'indigo**. » ⇒ ordre officiel : **rouge · orange · jaune · vert · bleu · indigo · violet**.
       Encadré : « Une
       lumière blanche est une lumière polychromatique : elle est formée par la superposition de
       lumières monochromatiques que nos yeux ne distinguent pas séparément. » Remarque : l'arc-en-
       ciel résulte de la décomposition de la lumière blanche du Soleil par les gouttelettes d'eau
       en suspension dans l'atmosphère.
    2. **Activité II** — couleur des objets (p.262–263) : tomate, piment et oignon éclairés en
       lumière blanche (rouge, vert, blanc perçus), puis à travers un filtre rouge (tomate reste
       rouge, piment devient noir, oignon devient rouge). **Généralisations officielles** : « La
       tomate est perçue rouge parce qu'elle diffuse la lumière rouge. » « L'oignon paraît blanc
       parce qu'il diffuse la lumière blanche. » « Le piment reçoit la lumière rouge et ne diffuse
       aucune lumière. » « Certains corps éclairés absorbent certaines lumières monochromatiques
       (ou radiations) et laissent passer ou diffusent les autres. » Encadré : « Un corps éclairé
       absorbe les radiations du spectre de la lumière qui l'éclaire sauf celle qu'il diffuse et
       que nous voyons. C'est sa couleur. » « Un corps qui absorbe la (ou les) radiation(s) qu'il
       reçoit paraît noir. Aucune lumière n'est diffusée. On le reconnaît à travers son contour. »
       « La couleur d'un objet est contenue dans la lumière qui l'éclaire. » « La couleur d'un objet
       dépend non seulement de l'objet lui-même, mais aussi de la lumière qui l'éclaire. »
    3. **Activité III** — daltonisme (p.263) : figures test (chiffre 5 vs 2 ; lapin vs aucun
       motif). « Pour ceux qui voient autres choses, ils sont dits daltoniens. Leurs yeux
       fonctionnent normalement, mais le traitement de l'image, formée sur la rétine, par le
       cerveau est défaillant. » « Les cônes (cellules de la rétine responsables de la vision des
       couleurs) sont de trois types : celles qui sont sensibles au rouge, celles sensibles au vert
       et celles sensibles au bleu. Une absence ou une faiblesse de la sensibilité de l'un des trois
       types de cônes entraîne la non vision de la couleur correspondante. »
    4. **Activité IV** — illusions d'optique (p.264) : figures illustratives (droites parallèles
       translatées passant par des points A/B ; vase ou deux visages ; cylindre à ouverture
       ambiguë ; effet de persistance rétinienne points blancs/noirs ; lignes droites parallèles
       perçues courbes). « Une double image, une fausse perspective, la persistance de l'impression
       lumineuse sur la rétine ou l'influence de l'environnement, peut conduire à une vision
       d'images qui peuvent ne pas correspondre à la réalité. » Définition : « Le cerveau donne
       parfois une mauvaise interprétation des informations qu'il reçoit de l'œil. Un tel
       phénomène, qui n'est pas dû au trajet de la lumière entre la source et l'œil mais au
       fonctionnement de la rétine et du cerveau, est appelé illusion d'optique. »
    5. **Activité V** — énergie transportée par la lumière (p.264) : loupe concentrant la lumière
       du Soleil sur du papier noir → le papier brûle. « Le papier a reçu de l'énergie thermique.
       Cette énergie est le résultat d'un transfert d'énergie par rayonnement de la source
       lumineuse vers le papier. » Applications du laser : découpe de plaques métalliques, cassage
       de calculs (rénaux), destruction de cellules malades par brûlure.
    6. **Activité VI** — ultraviolet et infrarouge (p.264–266) : cuve d'eau à fluorescéine (ou
       écran fluorescent) éclairée par le spectre solaire → « La fluorescéine est impressionnée par
       des radiations invisibles situées dans le spectre après le violet. Elles sont appelées
       radiations ultraviolettes. » Thermomètre approché d'un filament rouge puis éteint ;
       comparaison « à la température **θ** indiquée par le thermomètre à l'ombre » (**θ sans indice
       dans la source**) : « **θ₁ > θ₂ > θ.** » — « Le fait que la température θ₂ > **θ**, cela
       prouve qu'en **deça** [sic] du rouge il existe des
       radiations responsables de la sensation de chaleur. Ces radiations sont dites infrarouges. »
       Encadré : « Les radiations solaires ou émises par une lampe à incandescence sont formées :
       - de radiations visibles : la lumière blanche ; - et de radiations invisibles : l'infrarouge
         et l'ultraviolet. » **Applications et dangers des ultraviolets** (p.266) : synthèse de la
         vitamine D (carence → rachitisme) ; bronzage (exposition prolongée → brûlures, cancers de la
         peau) ; photosynthèse chlorophyllienne ; stérilisation de produits agricoles ; détection des
         fausses monnaies (motifs fluorescents). **Applications des infrarouges** (p.266) : systèmes
         de commande (portes automatiques, robots industriels) ; télécommandes (DEL émettrices,
         photorésistances/photodiodes réceptrices) ; thermographie satellitaire ; lunettes
         infrarouges (vision nocturne) ; effet de serre.
    7. **Activité VII** — énergie absorbée et couleur (p.267) : deux bouteilles d'eau identiques,
       l'une peinte en blanc, l'autre en noir, exposées au Soleil — « La température de l'eau dans
       la bouteille peinte en noir est nettement plus élevée que celle de l'eau contenue dans la
       bouteille peinte en blanc. » Questions ouvertes associées : vêtements sombres en hiver vs
       clairs en été ; choix nylon/laine/coton en été.
  - **Fiche T.P.** (p.268) — « Illusions d'optique » : but (créer des situations d'illusion
    d'optique à partir de documents fournis) ; matériel (crayon, règle, compas, feuilles de
    dessin) ; protocole (identifier la cause de chaque illusion parmi double image, fausse
    perspective, persistance rétinienne, influence de l'environnement ; créer une illusion inédite
    ; essayer d'autres créations basées sur des causes variées).
  - **Recherche documentaire** (p.268–269) — « L'effet de serre » : infrarouges solaires
    parvenant au sol, élévation de température, réémission d'infrarouges moins énergétiques,
    piégés par une couche vitrée/plastique/CO₂ ; principe des serres horticoles (rayonnement
    thermique + transparence sélective du verre — transparent au visible, opaque à l'infrarouge
    peu énergétique) ; rôle du CO₂ et de la vapeur d'eau atmosphériques ; risque d'un excès de CO₂
    (réchauffement du sol). Questions associées : sens des mots « horticole », « piéger »,
    « sélectif » ; phénomènes physiques expliquant l'effet de serre ; risques des rejets
    industriels de CO₂.
  - **L'essentiel du cours** (p.270, formulation officielle — verbatim) :
    - « Le prisme (ou le réseau) décompose la lumière blanche en plusieurs lumières colorées que
      nos yeux ne distinguent pas séparément. »
    - « La lumière blanche est constituée de lumières monochromatiques (ou radiations) allant du
      rouge au violet en passant par toutes les couleurs intermédiaires. Ces couleurs contituent
      [sic] le spectre de la lumière blanche. »
    - « Le spectre de la lumière blanche est continu. »
    - « Un corps éclairé absorbe les couleurs du spectre de la lumière qui l'éclaire sauf celle
      qu'il diffuse et que nous voyons. C'est sa couleur. Elle doit être contenue dans la lumière
      qui l'éclaire. »
    - « Un corps qui absorbe la (ou les) lumière(s) qu'il reçoit paraît noir. Aucune lumière n'est
      diffusée. On le reconnaît à travers son contour. »
    - « Les cônes (cellules responsables de la vision des couleurs) sont de trois types : celles
      qui sont sensibles au rouge, celles sensibles au vert et celles sensibles au bleu. Une
      absence ou une faiblesse de la sensibilité de l'un des trois types de cônes entraîne la non
      vision de la couleur correspondante. Une telle déficience est appelée daltonisme. »
    - « Le cerveau donne parfois une mauvaise interprétation des informations qu'il reçoit de
      l'œil. Un tel phénomène, qui n'est pas dû au trajet de la lumière entre la source et l'œil
      mais au fonctionnement du cerveau dans le traitement de l'information visuelle, est appelé
      illusion d'optique. »
    - « C'est par rayonnement que l'énergie est transférée d'une source lumineuse au milieu
      extérieur. »
    - « Les radiations solaires ou émises par une lampe à incandescence sont formées : - de
      radiations visibles : la lumière blanche ; - et de radiations invisibles : l'infrarouge et
      l'ultraviolet. »
  - **Aperçu historique** (p.270) : recherche sur le savant **Descartes (1596/1650)**.
  - **Exercice résolu** (p.270–271) : 1) température plus douce au lever/coucher du Soleil
    (trajet atmosphérique plus long, énergie transférée au sol minimale) ; 2) rayonnement
    ultraviolet responsable du bronzage et des coups de soleil ; crèmes protectrices (filtrent
    lumière visible + UV) vs crèmes de bronzage (absorbent sélectivement les UV agressifs) ; 3) bronzage plus rapide sur la plage car le sable diffuse les UV (contrairement aux
    végétaux).
  - **Exercices** (p.271–273) : **Vérifier ses acquis** — phrases à compléter (spectre continu
    d'un corps incandescent ; illusions dues à la rétine/au cerveau, non à l'œil ; infrarouge et
    ultraviolet invisibles) ; vrai/faux motivé, **sans corrigé imprimé** (filtre rouge laisse passer
    toutes les lumières sauf le rouge ; couleur dépend de l'objet et de l'éclairage ; infrarouge/UV
    prolongent le spectre visible) ; choisir le(s) mot(s) exact(s) (composition des radiations
    solaires ; vêtements clairs/sombres en hiver et absorption/diffusion ; fluorescence sensible
    aux UV). **Utiliser ses acquis dans des situations simples** — plongeur en combinaison blanche
    perçue bleu-vert à 30 m de profondeur (**QCM sans corrigé imprimé**) ; illusion des flèches —
    **le manuel ne la nomme pas** : « De vue, les traits entre les pointes des flèches ont-ils la
    même longueur ? Vérifier la réponse en mesurant chacun des segments à l'aide d'une règle. […]
    Peut-on toujours se fier à nos sens ? » (**figure non rendue**, §6.2) ; disque compact exposé à
    la lumière du jour : « Pour certaines dispositions du disque on observe un phénomène qu'on
    reconnaîtra. Le décrire. b)-Quelle fonction optique a joué le disque compact ? » (**sans
    corrigé** ; le chapitre n'enseigne que le prisme et le réseau — le mot « diffraction »
    **n'existe nulle part** dans le manuel). **Utiliser ses acquis pour une
    synthèse** — lisibilité des mots « sciences » (fond blanc) et « physiques » (fond noir) à
    travers filtres rouge/vert, choix d'un filtre pour lire toute l'expression ; spectres comparés
    humain/oiseau/poisson (couleurs non perçues par chaque espèce, reproduction du spectre perçu
    par un daltonien rouge-vert) ; perception des UV/IR par l'œil humain (limite de sensibilité,
    non un défaut optique), sources et applications des UV (2 sources, 1 expérience, 2
    applications) et des IR (2 sources, 1 expérience, 2 applications).
  - **Savoir plus** (p.273–274) — « Mélanges de couleurs » : trois couleurs fondamentales
    (primaires) — rouge, bleu, vert ; addition des trois → blanc ; couleurs secondaires : jaune
    (rouge + vert), magenta (rouge + bleu), bleu cyan (bleu + vert) ; couleurs complémentaires
    (mélange d'une couleur secondaire et de la primaire manquante → blanc) ; principe utilisé dans
    les téléviseurs couleur (pastilles fluorescentes rouge/bleu/vert non résolues séparément par
    l'œil à distance) ; utilisation des couleurs complémentaires pour blanchir le linge (teinture
    bleue neutralisant le jaunissement).
- **Concepts / notions** : décomposition de la lumière blanche par un prisme/réseau ; lumière
  monochromatique / polychromatique ; spectre continu ; couleur d'un objet (absorption/diffusion
  sélective) ; « un corps qui absorbe la (ou les) radiation(s) qu'il reçoit **paraît noir** »
  (formulation du manuel ; le terme « corps noir » **n'apparaît nulle part** dans l'ouvrage) ; cônes rétiniens (rouge/vert/bleu) ; daltonisme ;
  illusion d'optique (double image, fausse perspective, persistance rétinienne, influence de
  l'environnement) ; transfert d'énergie par rayonnement lumineux ; ultraviolet ; infrarouge ;
  effet de serre ; couleurs primaires/secondaires/complémentaires (synthèse additive).
- **Vocabulaire officiel** : « spectre de la lumière blanche », « lumière monochromatique »,
  « radiation », « lumière polychromatique », « spectre continu », « cônes », « daltonisme »,
  « illusion d'optique », « rayonnement », « ultraviolet », « infrarouge », « effet de serre »,
  « couleurs fondamentales/primaires », « couleurs secondaires », « couleurs complémentaires ».
- **Bornes de scope** :
  - ✅ **INCLUS** : décomposition de la lumière blanche (prisme/réseau), spectre continu ;
    mécanisme qualitatif de la couleur des objets par absorption/diffusion sélective (y compris
    à travers un filtre coloré) ; daltonisme (mécanisme rétine/cerveau, trois types de cônes) ;
    illusions d'optique (typologie qualitative des causes) ; transfert d'énergie par rayonnement
    lumineux (loupe/papier noir) ; existence et mise en évidence expérimentale de l'UV et de l'IR,
    leurs applications et dangers ; couleurs primaires/secondaires/complémentaires (synthèse
    additive qualitative).
  - ⛔ **EXCLU** : longueurs d'onde chiffrées des radiations visibles/UV/IR (aucune valeur
    numérique en nm n'apparaît dans le texte transcrit — approche purement qualitative) ; loi de
    Wien ou du corps noir ; synthèse soustractive (peinture/pigments) — seule la synthèse additive
    (lumières colorées) est traitée ; optique géométrique des lentilles/miroirs (relève du
    chapitre 16, non repris ici) ; anatomie détaillée de l'œil au-delà de la rétine/cônes (pas de
    cristallin, cornée, etc. développés dans ce chapitre).

---

## 3. Notes pédagogiques / méthode

> **Source** : le manuel seul (pas de guide enseignant — §1). Ce qui suit est **observé sur les 17 chapitres**,
> pas prescrit par un texte officiel. ⚠️ **Cette section n'a pas été auditée par la passe R-7** (à charge).

**La démarche, telle qu'elle est réellement mise en œuvre.** Le triptyque annoncé par l'Avant-Propos
(_investigation spontanée → investigation réfléchie → structuration_) se lit page à page :

1. **Mise en situation** (2 p.) — 4 photographies du quotidien tunisien + questions ouvertes **jamais
   corrigées**. Elles ne servent pas à évaluer : elles installent le questionnement. Les réponses arrivent
   parfois **14 pages plus loin**, dans le « Savoir plus » (cas exemplaire du ch.1 : les questions
   éclair/foudre/tonnerre p.11 sont résolues p.24).
2. **Activités expérimentales** (4–6 p.) — l'ossature. Chaque activité suit invariablement
   _protocole → observation → résultat → **encadré de généralisation**_. **L'encadré est la norme** : c'est là,
   et seulement là, que le savoir est posé. Les **questions en italiques** de fin d'activité sont, elles aussi,
   **non corrigées** (évaluation formative).
3. **Fiche T.P.** (1 p.) — buts / matériels / expérimentation / protocole. Les **tableaux y sont imprimés
   vides** : ce sont des feuilles de relevé à remplir par l'élève (ch.1 p.18, ch.11 p.172…). Ne jamais lire une
   colonne vide comme une perte d'extraction.
4. **Recherche documentaire** (1 p.) — texte + 4 questions. Rubrique imprimée tantôt « RECHERCHE
   DOCUMENTAIRE », tantôt « ACTIVITES DOCUMENTAIRE » (§6.3).
5. **L'essentiel du cours** (1 p.) — le résumé normatif, **6 à 14 puces**. C'est la source la plus sûre du
   manuel : les 17 encadrés ont été collationnés verbatim (R-7). ⚠️ Mais **il n'est pas exhaustif** : le ch.1
   montre qu'il peut **omettre des notions enseignées** (charge élémentaire, influence) et **ajouter une
   capacité jamais démontrée**. **Ne pas calibrer une génération sur le seul « essentiel ».**
6. **Aperçu historique** (même page) — renvoi Internet vers un savant. ⚠️ **2 des 14 portent des dates
   fausses** (§6.3).
7. **Exercice résolu** (1 p.) — énoncé + solution + **colonne « Commentaires »** (la méthode explicitée). C'est
   la **seule réponse officielle** du chapitre : tout le reste des exercices est **sans corrigé**.
8. **Exercices à résoudre** (2 p.) — les 3 catégories de l'Avant-Propos, dans l'ordre :
   _vérifier ses acquis_ → _situations simples_ → _synthèse_. **Difficulté croissante** ; la 3ᵉ catégorie
   s'appuie très souvent sur une figure.
9. **Savoir plus** (1 p.) — ouverture sciences/société/environnement.

**Notations et unités — le manuel est conforme au standard.** Chiffres occidentaux 0-9 partout, équations LTR,
unités SI. Conventions constantes : virgule décimale (« 12,55 g.cm⁻³ ») ; unités en notation pointée
(« kg.m⁻³ », « V.A-1 ») ; puissances de 10 en exposant ; grandeurs vectorielles fléchées ; indices
(W_M / W_E / W_R p.222 ; θ₁, θ₂ p.266). ⚠️ **`pdftotext` aplatit exposants et indices et ne rend aucun symbole
vectoriel** : toute notation vectorielle de cette fiche est une **reconstruction** (§6.2).

**Savoir-faire transversaux attendus** (récurrents d'un thème à l'autre) : choisir un **calibre** et lire une
mesure (ampèremètre, voltmètre, ohmmètre, multimètre) ; **tracer et exploiter un graphique** dans un repère
cartésien ; **lire un tableau de données chiffrées** (ch.15, tableau des planètes p.234) ; convertir des unités
(volumes, masses, pressions) ; **schématiser un circuit** avec les symboles normalisés (p.31) ; exploiter une
**chronophotographie** (ch.10) ; construire un vecteur à l'échelle (ch.11–12).

**Pièges et erreurs fréquentes que le manuel travaille explicitement** : confondre **répulsion et attraction**
comme critère de signe (ch.1, la convention est référencée **au verre**, jamais absolue) ; croire qu'un corps
**neutre** ne subit rien (ch.1, act. I vs exercice résolu p.21) ; confondre **masse et volume**, puis **masse
volumique et densité** (ch.8) ; confondre **rotation** et **révolution** (ch.15 — le manuel s'y contredit
lui-même, §6.3) ; croire que « fondre » et « se dissoudre » sont un même phénomène (ch.9) ; croire que la
pression dépend de la seule force (ch.13, l'« emprunte » [sic] montre la surface).

**Ce que le manuel ne fait jamais** (borne de méthode, utile en génération) : il **ne corrige pas** les
exercices à résoudre ; il **ne donne aucun volume horaire ni découpage trimestriel** ; il **ne numérote pas ses
chapitres de 1 à 17** ; il **n'emploie aucun formalisme mathématique au-delà du produit et du quotient** (ni
dérivée, ni trigonométrie, ni équation différentielle) ; il **ne chiffre jamais une longueur d'onde** (§6.2).

---

## 4. Chapitrage retenu (→ alimente `manifest/1ere-sec.json`)

**17 chapitres**, dans l'ordre du manuel (seule source). La numérotation continue `01…17` est celle du
**contenu applicatif** ; la colonne « notion » conserve la **désignation imprimée** (thème + chiffre romain,
qui redémarre à I à chaque thème) pour rester revérifiable — cf. l'avertissement du §2.

| #   | slug                         | notion (désignation imprimée)                                             | manuel élève (code · pages) |
| --- | ---------------------------- | ------------------------------------------------------------------------- | --------------------------- |
| 1   | `01-phenomene-electrisation` | L'ELECTRICITE · CHAPITRE I — Le phénomène d'électrisation                 | `223103P00` · p.9–24        |
| 2   | `02-circuit-electrique`      | L'ELECTRICITE · CHAPITRE II — Le circuit électrique                       | `223103P00` · p.25–42       |
| 3   | `03-intensite-courant`       | L'ELECTRICITE · CHAPITRE III — L'intensité du courant                     | `223103P00` · p.43–56       |
| 4   | `04-tension-electrique`      | L'ELECTRICITE · CHAPITRE IV — La tension électrique                       | `223103P00` · p.57–70       |
| 5   | `05-dipole-resistor`         | L'ELECTRICITE · CHAPITRE V — Caractéristique d'un dipôle résistor         | `223103P00` · p.71–86       |
| 6   | `06-etats-physiques-matiere` | LA MATIERE · CHAPITRE I — Les états physiques de la matière               | `223103P00` · p.87–100      |
| 7   | `07-proprietes-matiere`      | LA MATIERE · CHAPITRE II — Quelques propriétés de la matière              | `223103P00` · p.101–114     |
| 8   | `08-masse`                   | LA MATIERE · CHAPITRE III — La masse                                      | `223103P00` · p.115–130     |
| 9   | `09-changements-etat`        | LA MATIERE · CHAPITRE IV — Les changements d'état physique d'un corps pur | `223103P00` · p.131–146     |
| 10  | `10-mouvement`               | LA MECANIQUE · CHAPITRE I — Le mouvement                                  | `223103P00` · p.147–162     |
| 11  | `11-actions-mecaniques`      | LA MECANIQUE · CHAPITRE II — Les actions mécaniques                       | `223103P00` · p.163–178     |
| 12  | `12-forces-equilibre`        | LA MECANIQUE · CHAPITRE III — Forces et équilibre                         | `223103P00` · p.179–194     |
| 13  | `13-forces-pression`         | LA MECANIQUE · CHAPITRE IV — Forces et pression                           | `223103P00` · p.195–208     |
| 14  | `14-energie-controle`        | L'ENERGIE · CHAPITRE I — Energie et contrôle                              | `223103P00` · p.209–226     |
| 15  | `15-terre-univers`           | ASTRONOMIE · CHAPITRE I — La Terre et l'univers                           | `223103P00` · p.227–242     |
| 16  | `16-lumiere-propagation`     | L'OPTIQUE · CHAPITRE I — La lumière et sa propagation                     | `223103P00` · p.243–258     |
| 17  | `17-spectre-vision`          | L'OPTIQUE · CHAPITRE II — Spectre de lumière et vision                    | `223103P00` · p.259–274     |

**Bornes vérifiées** (contrôle déterministe du 2026-07-17) : **17 pages d'ouverture** (`CHAPITRE <romain>`) et
**17 pages « SAVOIR PLUS »**, appariées sans trou ni recouvrement ⇒ les 17 plages ci-dessus **pavent exactement
p.9–274**, sans chevauchement. **Offset folio imprimé ↔ index PDF = 0** (recoupé indépendamment par les 5
tranches R-7 sur les folios 3, 6, 8–10, 16, 20, 24, 209, 222, 226–227, 240, 242, 247, 266, 273).

**Pages hors chapitres** (à ne rattacher à aucun chapitre — elles alimentent §1 et §2) : **p.1–8** liminaires
(couverture, copyright, Avant-Propos, sommaire p.4–5, mode d'emploi p.6–7, « Naviguer sur l'Internet » global
p.8) · **p.275–276 vides** (§6.5).

> **⚠️ Écart gabarit ↔ schéma réel (signalé, non corrigé en silence).** La dernière colonne alimente le champ
> **`chapter.manuel = { code, pages }` du _contenu_** (`content/<subject>/NN-<slug>/chapter.json` — schéma Zod
> `src/shared/content/schema.ts`, compilé dans la colonne `chapters.manuel_ref`), **pas le manifeste** : le
> schéma du manifeste (`src/shared/content/program-manifest.ts`) n'accepte que `{ slug, notion, optional }` —
> **il ne porte aucun champ `manuel`**. Le mapping code↔pages vit donc **ici, dans cette table**, et sera
> consommé au **lot de génération**.

---

## 5. Sources croisées

- **Guide enseignant** : **inexistant au corpus** pour (1ère sec × physique). Le dossier
  `cnp-officiel/manuels/secondaire/c1/` ne comporte **que** `eleve/` — il n'y a **aucun** guide du secondaire
  dans le corpus téléchargé (vérifié le 2026-07-17). La règle « une seule source ⇒ elle fait référence »
  s'applique : **le manuel élève est la référence de scope ET de contenu**. C'est la situation de **toutes** les
  fiches `1ere-sec` du dépôt.
- **Manuel élève** : `223103P00` — « PHYSIQUE — 1ère Année de l'enseignement secondaire » (CNP, **276 p., volume
  unique**). **Source unique, lue intégralement (p.1–276).** Pages par chapitre : cf. §4.
- **⚠️ Correction de sourcing appliquée le 2026-07-17 — l'en-tête précédent était faux sur trois points.** Il
  annonçait « Deux tomes (pagination continue) : **222105P01.pdf** (tome 1, chapitres 1–9) et **222105P02.pdf**
  (tome 2, chapitres 10–17) ». Vérification (`find` sur tout le corpus + `pdfinfo`) :
  1. **Les codes `222105P01` et `222105P02` n'existent pas** dans le corpus. Le seul `222105*` est
     **`222105P00.pdf`** — le **cahier d'activités de MATHS** (catalogue « رياضيات », **118 p.**, extrait vers
     `_txt/222105P00-math-cahier.txt`). Aucun rapport avec la physique.
  2. **Le modèle « deux tomes » est une fabrication** : le manuel est un **volume unique de 276 p.** (`pdfinfo`)
     contenant les **17 chapitres**. Il n'a jamais été vérifié avant ce jour.
  3. La note « **Chimie (chapitres du tome 2) hors périmètre MVP — à traiter dans un PR séparé** » découlait de
     ce faux modèle et est **caduque** : **ce manuel ne contient aucune chimie** — ses 17 chapitres sont **6
     thèmes de physique** (Électricité, Matière, Mécanique, Énergie, Astronomie, Optique). ⇒ Note **supprimée**.
- **`224101P00` — « Chimie », 1ère année de l'enseignement secondaire (160 p.) — NON transcrit ici, hors
  périmètre (et déjà couvert).** C'est un **manuel distinct**, transcrit dans [`chimie.md`](./chimie.md)
  (statut `[x]`). **Confirmation croisée indépendante** : l'en-tête de `chimie.md` énonce de son côté que
  `sciences-physiques.md` « ne transcrit aucun chapitre de chimie » — les deux fiches concordent. Lien
  pédagogique réel entre les deux ouvrages : le **ch.1 de physique est le prérequis explicite du chapitre II de
  chimie** (cf. `chimie.md`, p.19).
- **`225105P00` — « Sciences biologiques » (section SPORT)** : sans objet ici (traité par
  [`svt.md`](./svt.md) §5).
- **Taybah** : **sans objet** — les plans trimestriels Taybah ne couvrent que le **primaire** ; aucun séquençage
  trimestriel externe n'existe pour la 1ère année secondaire. La progression retenue est **celle du manuel**.
- **Divergences signalées** : voir §6.3 (titres sommaire ↔ ouverture des ch.3 et ch.5 ; renvois faux du
  sommaire ; incohérences internes du manuel). Rappel de la règle : en cas de divergence de scope le guide
  enseignant ferait foi — **il n'y en a pas ici**, la source est unique, donc **rien n'arbitre contre le
  manuel**.

---

## 6. Incertitudes / à revérifier

> **Rien de ce qui suit n'a été corrigé en silence.** Les coquilles de la source sont transcrites telles quelles
> suivies de `[sic]` ; les lectures impossibles seraient marquées `[?]` et **jamais devinées** (il n'y en a
> aucune : la couche-texte est propre) ; les incohérences internes du manuel sont **signalées, pas arbitrées** —
> une transcription n'a pas autorité pour corriger le programme officiel.

### 6.0 Points d'arbitrage pour Mohamed (les seuls qui appellent une décision)

1. **⚠️ La borne d'usage de cette fiche : AUCUNE figure n'est rendue.** `pdftotext` restitue le texte de flux et
   **rien d'autre** — et la R-7 a prouvé (p.247) qu'il **perd aussi le texte incrusté dans les images**
   (3 légendes sur 6 manquaient). Le manuel est **massivement expérimental et visuel**. « Transcrit sans perte »
   ne vaut donc que pour **le texte**, jamais pour les documents. Le relevé **nominatif** des documents dont la
   perte rend l'item **inexploitable** est en **§6.2** : **~45 documents bloquants**, dont une dizaine rendent un
   exercice du manuel **strictement insoluble**. **Décision à prendre** : toute mission adossée à un schéma, un
   graphe, une chronophotographie, un spectre ou un symbole normalisé **exige une passe vision ciblée** sur la
   page nommée (`render.sh 223103P00.pdf <p> <p> 200` → PNG → `Read`) — c'est peu de pages, elles sont listées,
   mais **ce n'est pas fait ici**.
2. **Le programme officiel lui-même n'est pas transcrit** (pas de guide enseignant au corpus, §1) : la fiche
   transcrit le **manuel**, qui se dit conforme au programme sans le reproduire. Les bornes ✅/⛔ de chaque
   chapitre sont donc **déduites du contenu réellement traité par le manuel**, pas d'un texte officiel de
   programme. C'est la situation de **toutes** les fiches `1ere-sec`.
3. **⚠️ Le manuel se contredit sur une valeur numérique enseignée — le « 220 V·A⁻¹ » (p.76, ch.5). Le point le
   plus coûteux de la fiche s'il passe en génération.** Le manuel imprime le relevé du dipôle (D) :

   | U(V)  | 2   | 12  | 21  |
   | ----- | --- | --- | --- |
   | I(mA) | 91  | 545 | 955 |

   puis conclut : « **I et U sont proportionnelles puisque U1/I1 = U2/I2 = U3/I3 = 220 V.A-1.** » Or les rapports
   réels sont **21,98 / 22,02 / 21,99 V·A⁻¹ ≈ 22 — pas 220. Facteur 10.** _(Revérifié le 2026-07-17.)_
   - Le **point pédagogique tient** : les trois rapports sont mutuellement cohérents ⇒ la proportionnalité est
     bien établie. Le témoin est sain : le potentiomètre p.75 donne 690→702 V·A⁻¹, cohérent.
   - **Deux lectures possibles, non arbitrées** : soit le « 220 » devrait être « 22 » ; soit les trois intensités
     sont 10× trop grandes (il faudrait 9,1 / 54,5 / 95,5 mA — ce que donne exactement R = 220 Ω). La p.77
     imprime « R = 220 Ω » au code des couleurs, ce qui **pourrait** appuyer la 2ᵉ lecture — mais **rien
     n'établit** que ce résistor est le dipôle (D).
   - **Décision à prendre** : un item « U = 12 V, I = 545 mA → calculer R » aurait une clé à **22 Ω**
     contredisant le manuel qui affirme **220**. ⇒ **Ne pas générer d'exercice sur ce relevé** tant que le point
     n'est pas arbitré. Les chiffres sont transcrits **tels quels** dans le §2.5.

4. **Le manuel se contredit sur la densité du fer** (ch.8) : **d = 7,80** (tableau p.123) alors que
   **ρ = 7900 kg·m⁻³** (tableau p.122) et que le manuel **définit lui-même** d = ρ(substance)/ρ(eau) avec
   ρ(eau) = 1000 ⇒ **d attendu = 7,90**. Les deux valeurs sont **confirmées imprimées** (vision p.122 et p.123).
   Le fer est le **seul** de la table à décrocher (cuivre 8,90 ↔ 8900 ✓ ; or 19,30 ↔ 19300 ✓ ; liège 0,24 ↔ 240 ✓
   ; chloroforme 1,48 ✓ ; huile 0,92 ✓ ; eau 1,00 ✓). La contradiction est **interne et vérifiable par l'élève**.
   **Piège direct pour la génération** : l'exercice p.128 renvoie au tableau des **masses volumiques** (7900),
   tandis qu'un item sur les **densités** renverrait à 7,80. **Les deux valeurs sont transcrites telles quelles ;
   l'arbitrage n'appartient pas à la transcription.**
5. **Le manuel affirme une contre-vérité scientifique, en toutes lettres** (p.266, ch.17) : les ultraviolets
   « sont **responsables de la synthèse chlorophyllienne (photosynthèse)** » — or la photosynthèse relève
   essentiellement du visible. **Signalé, non corrigé** : un QCM « les UV permettent la photosynthèse » serait
   généré **de bonne foi** depuis le manuel. Même famille : le « HCFC 134A » (p.146) est en réalité un **HFC**
   (sans chlore), et le manuel nomme « **première vitesse de libération** » (p.162) la vitesse de satellisation
   circulaire (l'usage réserve « libération » à la vitesse d'évasion). **Le manuel officiel fait foi pour
   l'examen** — d'où l'arbitrage nécessaire avant toute génération sur ces trois points.

### 6.1 Ce que la passe R-7 du 2026-07-17 a corrigé (traçabilité)

La fiche pilote (2026-07-08) **n'avait jamais été relue contre sa source**. La R-7 a trouvé — et **cette
version corrige** — trois familles de défauts. Le **fond était sain** : les **16 « L'ESSENTIEL DU COURS » des
ch.2–17** sont verbatim exacts et **aucune valeur chiffrée n'était fausse** (le 17ᵉ, ch.1, est du contenu neuf —
cf. le périmètre exact en tête de fiche).

**(a) Inventions retirées** — la fiche fabriquait des réponses que le manuel **ne donne pas** (les exercices « à
résoudre » n'ont **aucun corrigé imprimé**). Toutes **supprimées** ; seuls les énoncés et les options imprimées
subsistent :

| Page | Ce que la fiche affirmait                                                      | Réalité de la source                                                  |
| ---- | ------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| 256  | ombre du cylindre : « axe vertical → disque ; axe horizontal → rectangle »     | QCM **non corrigé** — et l'appariement inventé **paraissait inversé** |
| 160  | « le Soleil se lève à **l'Est** … la Terre tourne de **l'Ouest** à **l'Est** » | texte à trous « …… » **non corrigé**                                  |
| 176  | « direction / sens / intensité », « le dynamomètre »                           | texte à trous « …… » **non corrigé**                                  |
| 192  | « constante de raideur (**40 N.m⁻¹**, calcul k = F/x) »                        | QCM **non corrigé** — 3 options imprimées, aucune restituée           |
| 206  | « surface », « quotient », « surface pressée », « petite »                     | texte à trous « …… » **non corrigé**                                  |
| 272  | filtre rouge « **[faux — inverse]** » ; plongeur « (rôle filtrant de l'eau) »  | vrai/faux et QCM **non corrigés**                                     |
| 33   | eau distillée sucrée « **(pas de courant détecté)** »                          | la source **pose** la question, n'y répond pas                        |
| 79   | « figures graphiques non alignées/non linéaires **selon le texte extrait** »   | **faux sourcing** — la p.79 ne porte que 3 légendes                   |

**Termes hors-manuel retirés** (recherche exhaustive sur les 276 pages, 2026-07-17) : « **Müller-Lyer** »,
« **diffraction** », « **corps noir** » — **absents du manuel entier**. Le cas de « diffraction » était le plus
grave : il faisait entrer **un concept hors programme** qu'un générateur aurait repris de bonne foi (le ch.17
n'enseigne que le prisme et le réseau). « corps noir » était de surcroît listé comme concept **inclus** et
**exclu** à la fois.

**Deux inventions supplémentaires retirées** (2ᵉ passe du 2026-07-17) : la **reconstitution d'une figure** —
l'exercice résolu p.111 était décrit « dispositif (**ballon** + tube fin) », or le manuel ne dit que « le
dispositif de la figure ci-contre » et sa solution ne nomme que « le verre, le liquide et l'air » : le
« ballon » était **déduit par analogie** avec l'activité II p.104, **jamais lu** (§2.7) ; et la **réponse
attendue d'un T.P. présentée comme imprimée** — la fiche T.P. p.188 était créditée de « l'écriture vectorielle
**T = −k.Δl⃗** », alors que le manuel **demande à l'élève de la proposer** et ne l'imprime qu'à la p.190
(§2.12).

**(b) Verbatims altérés rétablis + `[sic]`** — la fiche corrigeait des coquilles **à l'intérieur de citations
données pour verbatim** : `des ses` (p.32), parenthèse jamais fermée (p.49), `notée R` (p.75), `Il ne réalisent`
(p.82), `trés` (p.35), `joigne` (p.170), `COPRS` (p.172), `Lorsque un` / `Elle et notée` (p.190), `l500` (p.154),
`su l'écran` (p.250), `ELHAITHEM` (p.254), `de couleur bien définie` (p.258 — remplacé à tort par
« monochromatique », terme que le manuel réserve au ch.17), `en deça` (p.266), `méhane` (p.233), `tâches`
(p.237). **Cas particulier — un symbole inventé** : la fiche citait « θ₂ > **θ₀** » (p.266) ; le manuel imprime
**θ sans indice** (les indices 1 et 2 sont, eux, bien rendus par `pdftotext` — l'absence sur le troisième θ est
donc significative). Rétabli.

**(c) Diagnostics faux redressés** — trois affirmations de la §Incertitudes pilote étaient **actives et
nuisibles** :

- « **Aucune vérification par rendu image n'a été nécessaire : le texte extrait était complet** » (ch.10–13) —
  **faux**. Le `.txt` ne contient **aucun symbole vectoriel, aucun exposant, aucune figure** ; la fiche les avait
  **reconstruits sans le déclarer**. La phrase disait à l'aval « pas besoin de vision » alors que plusieurs
  exercices sont inexploitables sans l'image. **Remplacée par le §6.2.**
- « **La page 275 n'est pas présente dans le fichier** […] le texte s'arrête **au milieu du paragraphe** » —
  **faux** (§6.5).
- « **artefact de l'extraction PDF→texte (chiffres tronqués)** » sur l'exercice résolu p.159 — **faux, et c'était
  un piège actif** : il invitait un agent aval à « réparer » des nombres **justes**. Les valeurs 0,16/0,16 = 1 se
  vérifient **triplement** (l'activité V p.154 établit une chute de 0,16 s ; le manuel imprime « = 1 m.s⁻¹ »).
  Le seul défaut réellement imprimé est **le libellé** : le corrigé écrit « entre la première et la **deuxième**
  position » là où la question demande « la **dernière** ». → `deuxième [sic]`, valeurs conservées (§6.3).
- La justification du `35.10²⁰ N` (p.169) invoquait un contrôle physique **faux** (« conforme à l'ordre de
  grandeur réel ≈ 3,5×10²¹ N »). L'attraction Soleil-Terre vaut **≈ 3,5×10²² N** ; `35.10²⁰ = 3,5×10²¹` est donc
  **10× trop petit**. Le réflexe (signaler l'exposant perdu) était bon, **l'argument qui l'a validé ne tient
  pas** → **passe vision p.169 requise** (§6.2), justification retirée.

**(d) Contenu manquant ajouté** : les **10 pages d'ouverture** absentes (ch.2–10 et 14 — plan des activités +
pré-requis) ; le **tableau des caractéristiques des planètes p.234**, image raster absente du `.txt`, **levé en
vision** et transcrit intégralement en **§2.15** (il porte **deux exercices**, p.240 et p.241, qui n'y renvoyaient
que dans le vide) ; la formule **`V'/R³ = 4/3 π`** de la fiche T.P. p.94 (image de formule, **cœur du protocole**
— §2.6) ; les **12 couples angle/distance** des constellations du T.P. p.236 (Grande Ourse 7 points, Cassiopée
5 points), présents dans le `.txt` mais résumés par la pilote ; les **deux questions de clôture** de la p.235 ;
l'**énumération officielle des 7 couleurs du spectre** (p.262 — rouge · orange · jaune · vert · bleu · indigo ·
violet ; **dans un chapitre sur le spectre, la donnée la plus générable de la page**, réduite par la pilote à
« toutes les lumières monochromatiques intermédiaires », §2.17) ; la **définition officielle du degré Celsius**
(p.105, imprimée en toutes lettres, résumée par la pilote — §2.7) ; les **9 couples du tableau du volume de 1 kg
d'eau** (p.113) + sa consigne de tracé, sans lesquels l'exercice n'était **pas régénérable** (§2.7) ; les
**bornes de chapitre** rectifiées (§2).

**(e) Arbitrages silencieux annulés** — la pilote **tranchait** des incohérences de la source au lieu de les
rapporter. Cas principal : **les deux dates du solstice de décembre** (p.235) étaient **fusionnées** en une seule
(« 21 (ou 22) décembre … début de l'hiver ») alors que le manuel imprime **deux phrases à dates différentes**, et
que c'est la **seconde** (« 22 (ou 23) ») qui porte « début de l'hiver ». **Les deux sont désormais rapportées**
(§2.15, §6.3). Idem, corrigé plus haut : « chambre froide » rendue par « congélateur » (p.129), le libellé
« deuxième/dernière » du corrigé p.159, le double « 1/- » du corrigé p.191.

**(f) Paginations rectifiées** (la citation de page est ce qui rend la fiche **revérifiable**) : ch.14 « Savoir
plus » **p.226** (et non 225–226) · ch.15 « Savoir plus » **p.242** (et non 241–242) · ch.14 « Interprétation
microscopique » **p.217** (et non 216) · ch.14 « Activités expérimentales » **p.212–219** (et non 212–218), dont
le décompte annonçait « 7 blocs » pour **8 blocs** énumérés (7 activités numérotées + « Interprétation
microscopique », qui n'est pas une activité du manuel) · les ~20 paginations internes des ch.2–5, 6–9, 12 et
16–17 relevées par les tranches R-7.

> **Traçabilité de la consolidation elle-même (à charge).** L'intégration du 2026-07-17 s'est faite en **deux
> passes**. La première a appliqué l'essentiel des tranches ch.2–13 et ch.16–17, mais a **annoncé en §6.1(d) et
> §6.2 du contenu qu'elle n'avait pas réellement inséré** (le tableau p.234 et la formule p.94 étaient déclarés
> « levés / intégrés au §2 » alors que le §2 portait encore « données du tableau non retranscrites ici » et
> « comparer V' au cube du rayon »), et avait laissé la tranche ch.14–15 largement non appliquée. La seconde
> passe a **inséré le contenu manquant, annulé l'arbitrage du solstice, rectifié les paginations ci-dessus et
> resserré l'attestation R-7 en tête de fiche** sur son périmètre réel. **Leçon** : une entrée de traçabilité
> n'est une preuve de rien — **elle se vérifie contre le §2**, pas contre elle-même.

### 6.1 bis — Findings R-7 **connus et NON appliqués** (dette assumée, à traiter avant `[x]`)

Tous sont de gravité **mineure à moyenne** : aucun ne fait « apprendre faux », aucun ne se propage en invention.
Ils relèvent de la **profondeur R-5** (du contenu imprimé résumé au lieu d'être transcrit) et sont **entièrement
documentés dans les rapports de tranche** — le travail de lecture est fait, il ne reste qu'à reporter.

- **Ch.2–5 (tranche R-7 « m3 »)** — une dizaine d'omissions R-5 : la généralisation officielle p.46 (« Le
  fonctionnement d'un composant électrique dépend du type de branchement des constituants du circuit. ») ; des
  questions ouvertes p.29, p.48 (×1), p.49 (×2), p.63 ; le **calibre 20 kΩ** de l'exemple ohmmètre p.76 ; une
  citation tronquée p.48 ; une étape de protocole p.36 ; deux titres d'activités tronqués p.60/p.62.
  ⚠️ **Non revérifiées par la présente passe** : ces items n'ont pas été recoupés contre le §2.2–§2.5.
- **Ch.16 (p.255)** — les **réponses de l'exercice résolu** ne sont pas rapportées (alors qu'elles le sont pour
  le ch.17) : « 1/- C'est la position (2). » · « b)- La craie est opaque puisqu'on observe son ombre portée. » ·
  « 2/- a)- L'ombre portée de la craie garde la même direction, mais sa longueur diminue. » + commentaire. **Un
  exercice résolu est une réponse officielle** — contenu de première valeur.
- **Ch.16 (p.248)** — protocole et 3 observations de l'Activité III non rapportés ; phrases d'encadré omises
  p.247 et p.251 ; précisions perdues p.250, p.253, p.257, p.258, p.262, p.266 (relevé nominatif en tranche 6).
- **Ch.14 (p.215, 216, 218–219)** — définitions parallèles de **W_E** et **W_R** (seule celle de W_M figure) ;
  définition de la **convection** ; le bloc « **Economiser sur l'eau chaude** » (entièrement absent) et
  « Contrôler la pression des roues » ; p.224 ex.1 2/- ; la cellule pré-remplie du tableau p.225.
- **Ch.15 (p.239)** — commentaire « Algol […] baptisée Algol par les astronomes arabes ce qui signifie "œil du
  démon" » non transcrit.
- **Coquilles `[sic]` de la source** — le §6.4 en recense un grand nombre, mais **le marquage n'est pas
  systématique dans le corps du §2** : plusieurs sont transcrites fidèlement **sans** leur `[sic]` (p.247
  « par ce qu' », p.258 « faisceaux »/« cohérentes », p.273 « constituants », p.252 « Garder Constantes »…).
- **Vocabulaire officiel** — manquants relevés : « capacité », « pied à coulisse », « cristallisoir »,
  « erlenmeyer », « verre à pied », « pissette » (ch.6) ; « échelle/degré centésimal », « liquide
  thermométrique », « thermoscope » (ch.7) ; « masse moyenne par unité de volume », « étalon », « platine
  iridié », « fiole », « carat métrique » (ch.8) ; « nerfs optiques », « rétine », « diffuser », « réseau »,
  « prisme » (ch.16–17).
- **Ch.16 (p.245)** — les questions du cadran solaire, numérotées 1, 2, 3, sont restituées dans l'ordre du flux
  d'extraction (1, 3, 2) et **perdent leur numérotation imprimée** (§6.5).

### 6.2 Figures et symboles non rendus — la borne d'usage

> `pdftotext` **ne rend aucune image**, et **perd le texte incrusté dans les images**. **Rien n'a été deviné.**
> Un item ci-dessous marqué 🔴 est **strictement insoluble** sans une passe vision sur la page nommée.

**🔴 Bloquants — l'exercice ou l'activité n'existe pas sans la figure :**

| Page(s)        | Document                                                                                                                                          | Pourquoi                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **31**         | **Table des 12 symboles normalisés** (fil, générateur, lampe, moteur, interrupteurs, diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre) | **Seul endroit du manuel** où ils sont donnés ; exigé par L'essentiel p.38 |
| **77, 83, 85** | **Code des couleurs des résistors** (anneaux + table de correspondance)                                                                           | Exigé 3× : L'essentiel p.82, ex. résolu p.83 q.4, exercice p.85 q.2        |
| **161**        | Ex. n°3 : « **pour chaque diagramme** déterminer la nature du mouvement »                                                                         | **Zéro donnée dans le texte** — renvoi pur                                 |
| **161**        | Ex. n°2 : personnages A, B, C sur un tapis roulant                                                                                                | Positions et sens uniquement dans le dessin                                |
| **159**        | Chronophotographie de l'exercice résolu ch.10                                                                                                     | Les distances **se mesurent sur l'image**                                  |
| **154**        | Clichés n°1/n°2 de la chute de balle ; clichés (A)/(B) boule M→N                                                                                  | Graduations et intervalles lus sur les clichés                             |
| **169**        | Tableau « ordre de grandeur » : **l'exposant de `35.10²⁰`**                                                                                       | Lecture actuelle **invalidée** par le contrôle physique (§6.1c)            |
| **193**        | Tour de Pise + verticale (Δ) ; solide au ressort ; 2 pendules électrostatiques                                                                    | La géométrie **porte** la question                                         |
| **205**        | Ex. résolu ch.13 : **les deux lignes de calcul**                                                                                                  | La substitution numérique imprimée est **absente du `.txt`**               |
| **99**         | Synthèse 2 : éprouvette graduée photographiée                                                                                                     | **4 sous-questions** insolubles (unité, max, division, volume)             |
| **113**        | Synthèse 1 : thermomètre à minima et maxima (indexes I et J)                                                                                      | Insoluble sans l'image                                                     |
| **129**        | Synthèse 1 : **pesée** du cylindre ; synthèse 2 : lectures d'éprouvette (zinc)                                                                    | « Déterminer sa masse » insoluble                                          |
| **143, 145**   | Courbes θ(t) : « courbe rouge », « courbe bleue en pointillé » ; courbes (A)/(B)                                                                  | Les tracés n'existent que dans l'image                                     |
| **239, 241**   | Ch.15 : figure des 2 constellations + 2 étoiles ; ellipses + positions ; course du Soleil                                                         | 3 exercices insolubles                                                     |
| **255, 257**   | Ch.16 : positions (1)(2)(3) de la source + craie ; schémas (a)–(d) ; région de l'éclipse totale                                                   | Le QCM porte **exclusivement** sur les schémas                             |
| **273**        | Ch.17 : **spectres humain / oiseau / poisson**                                                                                                    | **Aucune couleur dans le texte** ; questions 100 % graphiques              |
| **273**        | Ch.17 : « SCIENCES PHYSIQUES » — **la couleur des lettres**                                                                                       | Donnée décisive ; _vision : les deux mots sont en **rouge**_               |

**🟠 Symboles et notations reconstruits, non vérifiés** — **tous** les vecteurs de la mécanique. Le `.txt` laisse
un **blanc** là où le manuel imprime un vecteur : la fiche a écrit `F`, `P`, `T`, `0⃗`, `p = F/s`… en
**reconstruisant**. Les lectures sont **physiquement quasi certaines** ; **la notation exacte du manuel (flèche ?
gras ? `‖F‖` ?) reste inconnue** — et c'est précisément ce dont un générateur aura besoin. Emplacements :
**p.168, 170, 174, 182–183, 185–187, 190–191, 198, 200, 204**. Exposants aplatis : p.169, 176, 200, 204, 205, 206.
⇒ **Passe vision requise** avant toute génération notée sur les ch.11–13.

**Levés par les passes vision de la R-7** (contenu désormais établi, intégré au §2) : tableau des planètes
**p.234** · formule `V'/R³ = 4/3 π` **p.94** · `Δl = lo.λ.Δθ` **p.104** (le « Δ0- » du `.txt` était un artefact) ·
définitions de la densité **p.123** · tableau ρ des solides **p.122** · tableau des volumes **p.92** · légendes
**p.247** (« Les lampes », « La lune », « L'atmosphère » — **absentes du `.txt`**) · couleurs **p.273**.

**Catégorie transversale, non listée ci-dessus** : **tous les schémas de montage** des activités et exercices
(p.29, 41, 46, 55, 69, 78, 85, 148–153, 166–172, 182–188, 198–202, 213, 223, 226, 231, 235–236, 249–253,
262–269…). Non bloquants pour le texte (le protocole est écrit), mais **aucun exercice « sur schéma » n'est
générable sans vision**.

### 6.3 Incohérences de la SOURCE — signalées, jamais arbitrées

**Numérotation des activités** (le manuel se contredit avec ses propres plans d'ouverture) :

- **Ch.5** — le plan p.71 annonce **5 activités (I→V)** ; le corps n'imprime que **I, II, IV, V** : **aucune
  « ACTIVITES (III) »**. Le contenu annoncé comme III (« Détermination de la résistance d'un résistor ») est
  traité p.76 dans un **encadré non numéroté** (« Mesure de la résistance d'un résistor ») + le code des couleurs
  p.77. **Anomalie réelle du manuel, pas un artefact** : contrôle déterministe (2026-07-17) — l'extracteur rend
  **19/19** des en-têtes `ACTIVITES (n)` des ch.2/3/4, il ne perd jamais ce motif. _(La note pilote concluait
  l'inverse, sur la mauvaise page et en invoquant la « table des matières » — le libellé vient du **plan p.71**.
  Redressé.)_
- **Ch.6** — le manuel imprime **deux fois « ACTIVITES (II) »** en p.91 (« Qu'appelle-t-on volume d'un corps ? »
  puis « Utilise-t-on d'autres unités de volume ? ») et passe **directement à « ACTIVITES (IV) »** p.92 : **aucune
  (III)**, alors que le plan p.87 en annonce une (« Relation entre certaines unités de mesure de volumes »).
  _(Confirmé en vision + contrôle regex.)_
- **Ch.8** — le plan p.115 annonce **4 activités**, le manuel en imprime **5** (I p.118 → V p.122), et les
  intitulés décrochent à partir du rang III/IV.

**Titres divergents sommaire ↔ page d'ouverture** (les deux sont imprimés ⇒ les deux sont rapportés) :

| ch. | Sommaire p.4                                           | Page d'ouverture                                                   |
| --- | ------------------------------------------------------ | ------------------------------------------------------------------ |
| 3   | « L'intensité **du courant électrique** »              | p.43 « **L'INTENSITE DU COURANT** »                                |
| 5   | « Le **dipôle résistor** »                             | p.71 « **CARACTERISTIQUE D'UN DIPÔLE RESISTOR** »                  |
| 9   | « Les changements d'état **physique** d'un corps pur » | p.131 idem — _la fiche pilote amputait « physique » ; **rétabli**_ |

_(Les ch.1, 2, 4, 6, 7, 8, 10–17 concordent.)_

**Renvois faux du sommaire** (au moins deux) : ch.7 « Exercices à résoudre » annoncés **p.113**, imprimés
**p.112** · ch.13 « Savoir Plus » annoncé **p.206**, imprimé **p.208** (le sommaire répète 206 dans deux
colonnes). Les autres renvois recoupés sont exacts.

**Dates fausses des « Aperçu historique »** — **2 des 14**, par copier-coller manifeste _(mécanisme prouvé le
2026-07-17 par relevé exhaustif des 14 encadrés)_ :

- **p.82** : « **Ohm (1745/1827)** » = **exactement** les dates de « **Volta (1745/1827)** » p.66. Dates réelles
  de G. S. Ohm : **1789–1854**.
- **p.222** : « **Joule (1642/1727)** » = **exactement** les dates de « **Newton (1642/1727)** » p.174. Dates
  réelles de J. P. Joule : **1818–1889**. _(Confirmé **imprimé** par deux passes vision indépendantes sur la
  p.222 : l'hypothèse « artefact d'extraction » ou « OCR » est **écartée** — il n'y a jamais eu d'OCR sur ce
  manuel.)_
- Les 12 autres sont **exacts** : Dufay (1698/1739), Faraday (1791/1867), Ampère (1775/1836), Volta (1745/1827),
  Avogadro (1776/1856), S'gravesande (1688/1742), Roberval (1602/1675), Celsius (1701/1744), Galilée (1564/1642),
  Newton (1642/1727), Hooke (1635/1703), Pascal (1623/1662), Descartes (1596/1650).

**Contradictions internes du manuel** (toutes imprimées, aucune arbitrée) :

- **Ch.15, p.235** — **deux dates différentes pour le solstice de décembre, sur la même page** : « Le **21 (ou 22)** Décembre… » puis « Le **22 (ou 23)** Décembre… ». _(La fiche pilote avait **fusionné** les deux et retenu
  silencieusement la première — **arbitrage non autorisé, annulé** : les deux sont rapportées.)_
- **Ch.15, p.235** — « **A partir du début de l'hiver, le Soleil commence à se décaler vers le sud.** » —
  contredit la suite immédiate et le solstice d'hiver (décalage sud déjà maximal).
- **Ch.15** — « **Venus** » sans accent dans le tableau p.234 et p.238, « **Vénus** » avec accent p.233.
- **Ch.15, p.238** (essentiel, puce 9) — « …et de **sa rotation autour du Soleil** » alors que le manuel a défini
  **révolution** (autour du Soleil) vs **rotation** (axe polaire) p.234.
- **Ch.16, p.253** — le mouvement apparent du Soleil attribué à la **révolution** (« La Terre tourne autour du
  Soleil, nous voyons celui-ci se lever à l'Est… ») puis, au paragraphe suivant, à la **rotation propre**
  (« En 24 heures, la Terre effectue une rotation complète autour d'elle-même, soit 360° »).
- **Ch.1, p.13 vs p.20** — « signes **contaires** [sic] » dans un **encadré normatif**, « signes contraires »
  (correct) dans L'essentiel : le manuel imprime les deux formes.
- **Ch.1, p.20 vs p.14–15** — L'essentiel **omet** la notation **q**, la **charge élémentaire** et
  l'**électrisation par influence** (pourtant exigée par l'ex. résolu p.21 et la synthèse 2 p.23), et **attribue
  à l'électroscope** une capacité à « comparer les quantités d'électricité » **qu'aucune activité ne démontre**.
- **Ch.7** — « **conductibilité** thermique » (plan p.101, p.103) **et** « **conductivité** thermique » (p.107,
  p.110) : deux termes pour la même notion, dans le même chapitre.
- **Ch.9, p.137** — « **l'iode** se transforme… » / « **le diiode** se transforme… » : deux nomenclatures en deux
  phrases consécutives.
- **Ch.9, p.136** — « les molécules d'**éther** » alors que l'expérience porte sur « quelques gouttes d'alcool
  (ou d'acétone…) ». _(Coquille **confirmée imprimée** ; la fiche pilote l'avait correctement relevée.)_
- **Ch.13** — « **emprunte** » [sic] pour « empreinte », **y compris dans les généralisations citées verbatim** ;
  la p.202 imprime **les deux graphies sur la même page** (« profondeur h1 de l'**empreinte** » ×3, et dans le
  tableau « Profondeur de l'**emprunte** »).
- **Ch.16 vs ch.17** — « Une source de Lumière est un **objet** » (p.247) vs « …est un **corps** » (p.254) ;
  l'illusion d'optique due « à **la rétine et au cerveau** » (p.264) vs « au **cerveau** » (p.270).
- **Ch.14, p.224** — « le bois » classé **dans les deux listes** du même item : non renouvelable **et**
  renouvelable. **Ch.14, p.225** — « un radiateur électrique, utilisant la rotation d'un ventilateur **pour
  refroidir** l'atmosphère ».
- **Ch.6, p.98** — les exercices numérotent **1/-, 2/-, 4/-** : le **3/- est sauté**.
- **Ch.12, p.191** — le corrigé imprime **deux fois « 1/- a)- »** (la réponse à la question 2 est numérotée 1).
- **Ch.10, p.159** — le corrigé écrit « entre la première et la **deuxième** [sic] position » là où la question 4
  demande « la **dernière** ». **Les valeurs (0,16/0,16 = 1 m.s⁻¹) sont justes** — c'est le libellé qui est
  fautif (§6.1c).
- **Ch.8, p.130 vs p.123** — « densité de la glace inférieure de **10 %** ⇒ **90 %** du volume immergé » alors que
  le tableau p.123 donne d(glace) = **0,92** (⇒ 8 % / 92 %). Arrondi de la source.
- **Ch.6, p.97** — l'énoncé dit « avoir dans **le bécher** 100 mL d'air », la solution répond « Pour remplir **le
  verre** d'air… ».
- **Ch.4, p.62–63** — l'énoncé annonce la tension « **UPA** », le tableau imprime « **UAP** » (valeur 0). Bénin
  (UAP = −UPA = 0) mais imprimé.
- **Ch.3, p.70** — « **William Eintroven** » : le manuel se trompe sur le prénom **et** le nom du physiologiste
  hollandais de l'électrocardiogramme (**Willem Einthoven**, 1860–1927, Nobel 1924).
- **Ch.13, p.202** — la fiche T.P. annonce une chambre dont « l'ouverture du Diaphragme et la distance
  **Diaphragme-Ecran** sont réglables », mais le protocole fait varier **Diaphragme-Objet** et **Écran-Objet**.
- **Ch.17, p.266** — le protocole introduit « un **filament** (une résistance chauffante par exemple) » puis parle
  de « **la lampe** » sans l'avoir introduite.
- **Liminaires, p.8** — la section MECANIQUE liste **deux fois la même URL**
  (`ac-reims.fr/datice/sc_physiques2/docs/lyc/2/galilee.htm`), sur deux lignes consécutives.
- **Rubriques** — le manuel intitule tantôt « **RECHERCHE DOCUMENTAIRE** » (p.51, 81…), tantôt « **ACTIVITES
  DOCUMENTAIRE** » (p.37, 65…) ; et le sommaire nomme « Naviguer sur L'Internet » une colonne dont la rubrique
  s'imprime « **APERCU HISTORIQUE** ».

### 6.4 Coquilles de la source — transcrites telles quelles + `[sic]`

Toutes **vérifiées imprimées** (couche-texte et/ou vision) — ce ne sont **pas** des artefacts d'extraction, et
**aucune n'est corrigée** :

**Liminaires & ch.1** : « Tous **droit** réservés » (p.2) · « **resoudre** des problèmes » (p.3, dans la liste
des 4 compétences officielles) · « cherche une information » (p.3) · « **Excercices** d'évaluation » (p.7) ·
« Activités de mise en **situations** » (p.6) · « signes **contaires** » (p.13) · « au **XVIII siècle** » ×2
(p.13) · « **apparaitre** » (p.16, alors qu'« appa**raît** » est correct deux lignes plus bas) · « **aux cours**
des activités III » (p.16) · « «**élecro-magnétique**» » (p.19 — ⚠️ la question **porte sur ce mot** que l'élève
doit chercher au dictionnaire) · « **il** s'électrise » pour « elle » (p.21) · « **APERCU HISTORIQUE** » sans
cédille (partout).

**Ch.2–5** : « par l'une **des ses** bornes » (p.32) · « …bornes de connexion**.** » — parenthèse ouvrante jamais
fermée (p.49) · « le coefficient de proportionnalité est **notée** R » (p.75) · « **Il** ne réalisent pas donc »
(p.82) · « **trés** important » (p.35) · « montage**s** en dérivation » (p.52) · « est associé une grandeur »
(p.52).

**Ch.6–9** : « Cube **d'arrête** » (p.92, alors que p.91 écrit « arête ») · « l'**ensemle** » (p.121) · « son
volume **poura** être évalué » (p.122) · « **Choloforme** » (légende, p.122) · « ρ = m/**v** » minuscule (p.121,
alors que le texte pose « volume **V** ») · « une balance et **de** corps » (p.128) · « « kilogramme étalon
international» » — guillemet doublé (p.125) · « température **du** fusion » (p.142, **dans L'essentiel**) · « de
la glace **mélangé** » (p.143) · « Il est **entrain** de se refroidir » (p.143, ×2).

**Ch.10–13** : « **l500 m** » — `l` minuscule pour `1` (p.154) · « Cavalier **menu** d'un carton » (p.156) ·
« la droite qui **joigne** » (p.170) · « ressort à **sipres** non jointives » (p.168) · « table **hortisantale** »
(p.171) · « POIDS ET MASSE D'UN **COPRS** » (p.172) · « les **acvités** les plus élémentaires » (p.178) ·
« **quelque soit** l'orientation » (p.184) · « **Dés** que (A) et (B) sont libérés » (p.186) · « **Lorsque un**
ressort » / « **Elle et notée** » (p.190, **dans L'essentiel**) · « **En suppose** que le centre de gravité G »
(p.193) · « un plan **horizontale** » (p.198) · « **emprunte** » (p.199, 200, 202).

**Ch.14–17** : « L'énergie totale d'un système **et** la somme » (p.222, **dans L'essentiel**) · « alors que
**chaleur** est un mode de transfert » (p.222) · « non polluantes **et dont** l'exploitation » (p.212) · « Le
**soeil** » (p.212) · « Il est **notée** WM / WE / WR » (p.214–215) · « Il **,existe** deux principales formes »
(p.224) · « **méhane** » (p.233) · « Ils sont **situées** à des distances » (p.230) · « **tâches** » pour
« taches » (p.237) · « **Pérsée** » vs « Persée » (p.239) · « de grandes **figurent** appelées » (p.240) · « Les
débuts des **couper du jeun** » — phrase altérée, **ne pas deviner l'intention** (p.235) · « l'éclipse **total**
de Soleil » / « le **pénombre** » (p.245) · « Un objet **nous n'est visible** » / « les phases de la Lune,
**observé** » / « **surafce** » (p.254) · « dans un **plan verticale** » (p.255) · « visibles **par ce qu'**ils
émettent » (p.247) · « un **faisceaux** lumineux » / « lumière **cohérentes** » (p.258) · « 750
années-**lumières** » (p.257) · « en **deça** du rouge » (p.266) · « **contituent** » (p.270) · « est
**il-lisible** » (p.272–273) · « radiations **constituants** » (p.273).

### 6.5 Artefacts d'EXTRACTION (défauts du `.txt`, **pas** du manuel) — à ne pas propager

- **Fin de manuel (p.274–276) — constat définitif, aucune incertitude.** _(Remplace l'entrée pilote, qui
  affirmait à tort que la p.275 « n'est pas présente dans le fichier » et que le Savoir plus était coupé « au
  milieu du paragraphe ».)_ Le manuel se termine au contenu de la **p.274** (« Savoir plus — Mélanges de
  couleurs »), **complet** (dernière phrase entière « Le vêtement semble plus blanc qu'il n'est en réalité. » +
  folio imprimé). Les **p.275 et 276 sont VIDES** : présentes dans le PDF comme dans le `.txt` (**276 sauts de
  page = 276 pages**), mais **0 ligne non vide** _(revérifié le 2026-07-17)_. Le manuel ne comporte **ni
  corrigés, ni annexes, ni index**. **Aucune troncature.**
- **Exposants et indices aplatis** : `1,6.10-19` (p.15) → **1,6.10⁻¹⁹** · `35.1020` (p.169) · `107 N`/`103 N`
  (p.176) · `105 Pa`/`102 Pa` (p.200, 204) · `176,4.103` (p.205) · `125.106`/`0,8.10-4` (p.206) · `3,6.106 J`,
  `4,2.1014`, `40.109` (ch.14) · `c = 3.108 m.s-1` (ch.17) · W_M/W_E/W_R (p.222) · θ₁/θ₂ (p.266). Les
  restitutions de la fiche sont **justes** (vérifiées en vision là où c'était nécessaire) — **sauf `35.10²⁰`**,
  dont la lecture reste **ouverte** (§6.2).
- **Symboles vectoriels : blancs systématiques** — cf. §6.2.
- **Fractions éclatées** : `R =(1+ d2 )r` → **R = (1 + d₂/d₁)·r** (p.271, vérifié : (1 + 80/20)×4 = 20 cm ✓) ·
  `p = F/s` (p.200, 204) · `m = P/g` (p.191).
- **p.12** — la consigne générale « Toutes les expériences sont à réaliser dans une atmosphère sèche. » s'imprime
  **en une seule ligne bleue** ; `pdftotext` **entrelace deux colonnes** et la restitue coupée en deux, le titre
  de rubrique inséré au milieu. **La source est saine** (vérifié au zoom 300 dpi).
- **Bandeau latéral « C O U R S »** — la mention verticale répétée en marge de chaque page de cours ressort dans
  le `.txt` en lettres isolées (`C`/`O`/`U`/`R`/`S`) qui s'intercalent dans les phrases. Décoratif.
- **p.8** — le « N I » en tête de l'extraction n'appartient pas au titre : ce sont deux capitales décoratives en
  filigrane (vérifié en vision).
- **p.36 / p.80** — titres de fiches T.P. : « Circuit **lectrique** » (é manquant) et « LOI D**␣**OHM »
  (apostrophe manquante), alors que les titres p.50 et p.64 sortent **intacts** ⇒ **artefact ponctuel** (glyphes
  d'une police décorative) bien plus probable qu'une coquille. La fiche restitue la forme correcte — **inférence
  signalée** ; vision p.36 + p.80 pour lever le doute (2 pages, faible coût).
- **p.104** — le « Δ0- » du `.txt` est un **artefact** : le manuel imprime bien `Δl = lo.λ.Δθ` (vision).
- **p.162** — le `.txt` répète le paragraphe « Si on augmente la vitesse initiale de l'objet… », la seconde
  occurrence s'interrompant net. **Deux hypothèses non tranchées** (répétition réellement imprimée, ou artefact
  d'ordre de colonnes) → vision p.162.
- **p.245** — les questions du bloc « cadran solaire », numérotées 1, 2, 3, **apparaissent dans l'ordre 1, 3, 2**
  dans le flux d'extraction (artefact de mise en page).

### 6.6 Incertitudes de la passe R-7 elle-même (à charge)

- **Aucun `[?]`** dans toute la fiche : la couche-texte est propre, les 276 pages ont été lues, **aucune valeur
  n'a été devinée**.
- **Tous les findings R-7 ne sont PAS appliqués.** Le reliquat connu est listé en **§6.1 bis** — dette de
  **profondeur R-5** (contenu imprimé résumé), sans invention ni erreur de fond. **La fiche n'est donc pas encore
  promouvable `[x]` sans une passe de report** ; elle est en revanche **utilisable pour la génération** partout
  où le §6.2 ne l'interdit pas.
- **Le §2.1 (ch.1 + liminaires) n'a AUCUNE relecture indépendante** : c'est une transcription neuve (vision
  24/24 pages, 0 `[?]`), pas du contenu R-7. Cf. le périmètre en tête de fiche.
- **Le §3 « Notes pédagogiques » n'a pas été audité** par la R-7.
- **Périmètre vision** : ~25 pages sur 276. Les documents du §6.2 marqués « à faire » **n'ont pas été ouverts** et
  **n'ont pas été reconstitués**.
- **Non arbitré, par construction** : tous les points du §6.0 et du §6.3. La décision appartient à Mohamed ;
  aucune correction du programme officiel n'est proposée.
- **Un point de forme reste ouvert** : « élecro-magnétique » (p.19) — le trait d'union tombe **exactement en fin
  de ligne**, il est donc indécidable à l'œil s'il s'agit du trait d'union du mot composé ou d'une césure de
  justification (auquel cas le mot imprimé serait « élecromagnétique »). La forme avec trait d'union a été
  retenue par cohérence avec « électro-magnétiques » du corps du texte — **sans certitude sur ce point précis**.
  La coquille « élecro », elle, est **certaine**.
