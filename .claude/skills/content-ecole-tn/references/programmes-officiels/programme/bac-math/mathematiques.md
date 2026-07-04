<!-- 🚧 TRANSCRIPTION PILOTE (test du workflow lycée) — établie HORS corpus CNP : les programmes
     officiels du secondaire ne sont pas encore intégrés au corpus (docs/lycee-architecture.md,
     station L1). Base : programme officiel tunisien de mathématiques, section Mathématiques,
     4ème année secondaire (Bac), tel que publié par le ministère + manuels scolaires officiels.
     À RE-VÉRIFIER contre les textes officiels avant toute montée en charge au-delà du pilote.
     Seul le chapitre 1 est transcrit à profondeur de génération ; le plan annuel est au niveau bloc. -->

# Mathématiques — Bac section Mathématiques (`bac-math`) · programme officiel (PILOTE)

> **Sources** :
>
> - **Programme officiel** : programme de mathématiques, 4ème année de l'enseignement secondaire,
>   section Mathématiques (ministère de l'Éducation, Tunisie). **Statut : pilote — référence
>   ministérielle à raccrocher au corpus (station L1), pages non citées.**
> - **Manuel élève** : manuel scolaire officiel de mathématiques 4ème année secondaire — section
>   Mathématiques (CNP), tomes 1–2. _(non encore intégré au corpus — pages non citées)_
>   **Transcrit le** : 2026-07-05. **Statut** : 🚧 transcription pilote (à valider).
>   **Langue d'enseignement** : fr (bascule ar→fr effectuée depuis la 1ère année secondaire —
>   aucun pont linguistique au Bac, conditions d'examen). **gradeSlug** : `bac-math`.
>   **subject id** attendu : `math-bac-math`.

## 1. Cadre & compétences

Année du **concours national du baccalauréat** (coefficient majeur de la section). Compétences
terminales : mobiliser l'analyse (limites, continuité, dérivabilité, fonctions ln/exp, calcul
intégral, suites), l'algèbre (nombres complexes, arithmétique), la géométrie (espace, isométries/
similitudes) et les probabilités pour résoudre des problèmes, conduire un raisonnement rigoureux
(implication, équivalence, contre-exemple, récurrence) et interpréter des résultats. Calibration
d'épreuve : exercices multi-étapes enchaînant sous-résultats, style annales session principale.

## 2. Plan annuel (niveau bloc — pilote)

### Domaine : Analyse

- **Chapitre 1 — Continuité et limites** _(transcrit à profondeur de génération, §2.1)_
- Suites réelles (monotonie, convergence, récurrence, suites adjacentes)
- Dérivabilité et applications ; étude de fonctions (branches infinies, asymptote oblique)
- Fonctions réciproques ; fonction logarithme népérien ; fonction exponentielle ; puissances
- Primitives et calcul intégral (aires, valeur moyenne)

### Domaine : Algèbre & arithmétique

- Nombres complexes (formes algébrique/trigonométrique/exponentielle, équations, interprétations
  géométriques) ; arithmétique (divisibilité, congruences, Bézout, Gauss, nombres premiers)

### Domaine : Géométrie

- Géométrie dans l'espace (produit scalaire, produit vectoriel, plans/droites/sphères) ;
  isométries et similitudes planes

### Domaine : Probabilités & statistiques

- Dénombrement, probabilités (conditionnement, indépendance), variables aléatoires, lois usuelles

## 2.1 Chapitre 1 — Continuité et limites (محور transcrit)

- **Objectifs** :
  - Étudier la continuité d'une fonction en un point (définition par la limite) et sur un
    intervalle ; exploiter la continuité des fonctions usuelles (polynômes, rationnelles, racine,
    valeur absolue, trigonométriques) et des composées.
  - Calculer des limites : opérations, quotients, **formes indéterminées** (∞−∞, 0×∞, ∞/∞, 0/0),
    limites par **comparaison et encadrement** (théorème des gendarmes), **limite d'une fonction
    composée**, limites et monotonie.
  - Interpréter graphiquement : **asymptotes verticales et horizontales** (l'asymptote oblique et
    les branches infinies complètes relèvent du chapitre étude de fonctions).
  - Déterminer l'**image d'un intervalle** par une fonction continue ; appliquer le **théorème des
    valeurs intermédiaires** et son **corollaire** (fonction continue strictement monotone :
    bijection, existence et unicité de la solution de f(x)=k) ; encadrer une solution par
    **balayage/dichotomie**.
  - Utiliser le **prolongement par continuité** en un point.
- **Concepts / notions** : continuité en a, continuité à droite/gauche, continuité sur un
  intervalle, opérations et composition, limite finie/infinie en a / en ±∞, formes indéterminées,
  théorèmes de comparaison et d'encadrement, limite de u∘v, asymptotes verticale/horizontale, TVI
  et corollaire de la bijection, prolongement par continuité, dichotomie.
- **Vocabulaire officiel** : « continue en a », « continue sur I », « limite à droite/gauche »,
  « forme indéterminée », « théorème des valeurs intermédiaires », « strictement monotone »,
  « prolongement par continuité », « valeur approchée à 10⁻ⁿ près ».
- **Progression** : chapitre d'ouverture de l'année (trimestre 1), s'appuie sur les acquis de
  3ème (limites usuelles, opérations) qu'il consolide puis dépasse (encadrement, composée, TVI).
- **Exemples & exercices types (manuel)** : calculs de limites avec radicaux (expression
  conjuguée), limites trigonométriques via encadrement (sin x/x au voisinage de 0 admise en 3ème,
  réutilisée), f(x)=k sur [a,b] avec tableau de valeurs et dichotomie, discussion du nombre de
  solutions selon k, prolongement de x↦(√(x+1)−1)/x en 0.
- **Bornes de scope** :
  - ✅ INCLUS : tout ce qui précède ; raisonnement par contre-exemple ; encadrements avec valeurs
    absolues ; unicité via stricte monotonie (croissance admise graphiquement ou par parité de
    fonctions usuelles — la dérivée n'est PAS encore disponible).
  - ⛔ EXCLU (chapitres ultérieurs ou hors programme) : dérivabilité et tableaux de variations
    obtenus par dérivation ; asymptote oblique/branches paraboliques ; limites avec ln/exp ;
    suites ; continuité uniforme ; ε/δ formel (la définition officielle passe par les limites).

## 3. Notes pédagogiques / méthode

Rigueur d'énoncé type bac : hypothèses explicites (continuité, monotonie), justification exigée
(citer le théorème utilisé), notation standard LTR, valeurs « qui tombent juste » (le calcul ne
doit jamais masquer le raisonnement — pas de calculatrice supposée). Pièges récurrents du niveau :
appliquer le TVI sans continuité ou sans encadrement de k, confondre « f(a)·f(b) < 0 » avec
l'unicité (oubli de la stricte monotonie), lever une forme indéterminée par une opération
illégale, composée dans le mauvais sens, asymptote verticale confondue avec horizontale.
(Taxonomie complète : skill `prof-math-lycee`.)

## 4. Chapitrage retenu (→ pilote : chapitre 1 seul)

| #   | slug                    | notion (محور)         | manuel élève (code · pages)      |
| --- | ----------------------- | --------------------- | -------------------------------- |
| 1   | `01-continuite-limites` | Continuité et limites | _(corpus secondaire à intégrer)_ |

## 5. Sources croisées

Programme officiel du secondaire (ministère) + manuel officiel 4ème Math (CNP) — **à raccrocher
physiquement au corpus** (`cnp-officiel/manuels/secondaire/`) lors de la vraie station L1 ;
annales du bac math (sessions principales) comme référence de calibration d'épreuve.
