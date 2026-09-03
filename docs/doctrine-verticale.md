# Doctrine verticale — profondeur avant largeur

> **Ce document est normatif.** Il gouverne **quand on ouvre une capacité nouvelle** et **à
> quelle condition une capacité est finie**. Il ne dit rien du code : c'est le pendant
> **produit** de la Definition of Done d'[AGENTS.md](../AGENTS.md) — le DoD garantit que le
> code est sain, la **DoE** (§3) que l'expérience est complète.
>
> **Origine et autorité.** Doctrine de l'**étude 26**, arbitrée le **2026-07-20** (Q-1…Q-5,
> toutes sur recommandation). L'étude vit dans le dépôt privé
> (`FableEtudes/26-doctrine-verticale/`) et reste la version longue : le mandat, l'audit qui
> l'a produite, l'analyse de portefeuille, l'état de l'art. **Ce fichier-ci est la version
> opposable** — celle qu'une session lit sans charger l'étude.
>
> ⚠️ **Écrit le 2026-09-03, six semaines après son arbitrage.** Pendant ces six semaines, tous
> les autres documents du projet ont cité « la doctrine verticale » comme une chose établie —
> ROADMAP, STATUS.md, index des études, en-têtes d'études gelées — alors qu'elle n'existait
> nulle part sous forme normative. Elle ne vivait que dans son étude et dans les citations
> qu'on en faisait. C'est exactement le défaut que P-2 nomme : une règle qu'on applique sans
> l'avoir écrite est une règle que personne ne peut contester, corriger, ni tenir.

---

## 1. Les trois mots

| Terme                 | Ce qu'il désigne                                                                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Capacité**          | Une fonctionnalité **du point de vue de l'élève ou du parent** — le player d'exercice, la correction, la révision, le donjon, le rapport parent. C'est l'unité de la scorecard. |
| **Verticale**         | Une **chaîne de valeur complète** : plusieurs capacités qui, ensemble, tiennent une promesse de bout en bout (« j'apprends une notion et je la maîtrise »).                     |
| **Profondeur**        | Le degré d'achèvement d'une capacité ou d'une verticale — job complet, boucles refermées, UX de tous les états, valeur mesurée. Elle se mesure sur la grille **M0-M4** (§2).    |
| **Largeur capacités** | Ajouter une capacité ou une verticale **nouvelle**. C'est ce que cette doctrine gouverne, et rien d'autre.                                                                      |
| **Largeur catalogue** | Ajouter du **contenu** (classes, matières, chapitres) dans les capacités existantes. **Hors doctrine** — voir §6.                                                               |

**L'excellence se juge sur la VERTICALE, pas sur la capacité isolée.** Un excellent player
d'exercice avec une révision absente est une verticale cassée, pas une réussite partielle.
C'est la raison d'être de la distinction : on peut livrer cinq capacités M3 et n'avoir tenu
aucune promesse.

---

## 2. Les sept principes

### P-1 — Profondeur avant largeur

Entre **approfondir** une capacité existante et en **ouvrir** une nouvelle, l'approfondissement
gagne **par défaut**. L'ouverture exige une décision humaine explicite et motivée (§4).

### P-2 — Toute boucle se referme

Une donnée collectée doit nourrir une surface utilisateur ou une décision produit **datée**.
Sinon on ne la collecte pas — ou on écrit qui la consommera, et quand.

**Une télémétrie orpheline est de la largeur déguisée** : du coût payé, de la valeur jamais
encaissée. C'est le constat fondateur de l'étude : trois boucles d'intelligence étaient
collectées depuis des mois et n'avaient jamais atteint un seul écran d'élève.

### P-3 — Le job complet, pas la feature

Une capacité n'est **livrée** que si l'utilisateur accomplit la promesse de bout en bout, **cas
dégradés compris**. Le critère d'arrivée est la DoE (§3).

### P-4 — Brique d'excellence

Chaque capacité visée doit pouvoir devenir **une référence de son marché** : conçue contre les
meilleures pratiques documentées, pas contre le minimum viable.

**M3 est le plancher de tout ce qui est LIVE. M4 est réservé aux capacités _signature_**
(§7) — l'excellence ciblée, jamais le gold-plating uniforme.

### P-5 — IA-native systématique, IA disciplinée

Pour chaque capacité, la question « **que peut l'IA ici ?** » reçoit une réponse **écrite** —
y compris « rien pour l'instant ». Le principe d'architecture de l'étude 11 devient un
principe produit transverse : **le déterministe décide, le LLM rédige** (§5).

### P-6 — Mesurer ou ne pas prétendre

« Excellent » est un état **mesuré**, pas déclaré. Toute capacité M3+ nomme ses **1 à 3
métriques de valeur** et **l'endroit où on les lit**. Tant que la mesure n'existe pas, la
scorecard l'affiche comme **dette de fondation** — pas comme excuse.

### P-7 — Dire non par défaut

Le réflexe face à une bonne idée nouvelle est le **gel motivé**, pas le brouillon d'étude. Le
portefeuille matérialise ses « non » (statut `gelée (doctrine verticale)`) pour qu'ils restent
**visibles et réversibles**.

Dire non par écrit, quotidiennement, sans culpabilité : un « non » qui n'est écrit nulle part
revient tous les trimestres.

---

## 3. La maturité (M0-M4) et la Definition of Excellence

### La grille

| Niveau | Nom           | Critère discriminant                                                                                                                    |
| ------ | ------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **M0** | Absente       | Étude ou idée seulement — rien en production.                                                                                           |
| **M1** | Squelette     | La mécanique ou la donnée existe (table, RPC, collecte) mais **l'expérience n'existe pas** : boucle ouverte, aucune surface.            |
| **M2** | Fonctionnelle | Le job passe de bout en bout, **sans excellence** : états incomplets, incohérences tolérées, scories, valeur non mesurée.               |
| **M3** | **Aboutie**   | La **DoE est tenue intégralement**. ⬅ **Plancher de toute capacité LIVE.**                                                              |
| **M4** | **Référence** | M3 **+** différenciation défendable sur le marché local (souvent IA-native) : la version qu'un concurrent citerait. **Signature only.** |

### La DoE — huit critères, tous vérifiables

Un exécuteur les coche comme il coche le DoD.

1. **Job complet** — la promesse est tenue de bout en bout, cas dégradés compris (déconnecté,
   contenu vide, erreur serveur).
2. **Boucles refermées** — toute donnée que la capacité collecte est affichée ou consommée
   (P-2) ; toute donnée qu'elle devrait montrer existe et arrive.
3. **États UX complets** — vide / chargement / erreur / verrouillé-**avec-raison**,
   mobile-first, conformes aux registres et gabarits de l'étude 15.
4. **Trilingue réel** — FR/EN/AR quand la surface l'est, **RTL vérifié au rendu** (pas
   seulement traduit).
5. **Cohérente** — zéro contradiction avec les autres écrans ; constantes centralisées.
   _Contre-exemple canonique_ : une carte de parcours qui verrouille ce qu'un autre écran
   laisse jouer.
6. **Mesurée** — 1 à 3 métriques de valeur nommées, et où on les lit (P-6).
7. **Robuste** — tests co-localisés (DoD §5), anti-abus pensé, pas de scories
   (déclaré-jamais-créé, constantes mortes).
8. **IA évaluée** — la fiche de verticalité documente l'apport IA **retenu ou rejeté motivé**.

---

## 4. La règle de décision

**À appliquer avant d'ouvrir toute capacité nouvelle** — nouvelle étude, nouveau lot hors
étude, nouveau front.

```
1. La verticale stratégique en cours a-t-elle atteint sa cible ?
   ├── NON → la nouvelle capacité ATTEND.
   │         Exception possible, mais elle s'assume PAR ÉCRIT dans l'index des études.
   └── OUI → passer à 2.

2. La proposition approfondit-elle une verticale existante, ou en ouvre-t-elle une ?
   ├── APPROFONDISSEMENT (elle referme une boucle, complète un job, élève un niveau M)
   │   → elle entre dans la file de sa verticale, priorisée par la valeur.
   └── OUVERTURE
       → GEL PAR DÉFAUT (P-7) : statut `gelée (doctrine verticale)`.
         Dégelable par arbitrage humain uniquement.

3. Deux approfondissements en concurrence ? Gagne celui qui :
   (a) referme une boucle DÉJÀ PAYÉE (P-2) — la dette la plus chère est celle qu'on a déjà réglée ;
   (b) sert une capacité SIGNATURE (§7) ;
   (c) a le meilleur ratio valeur / effort.
```

### Les deux cas qui ne passent pas par l'arbre

- **Les fondations** — mesure, monitoring, légal, harness, sécurité. Elles ne sont ni
  profondeur ni largeur : elles **conditionnent tout**, et s'exécutent en parallèle.
- **La largeur catalogue** — voir §6.

---

## 5. Doctrine IA-native : le déterministe décide, le LLM rédige

L'état de l'art est sans ambiguïté. Chez tous les leaders examinés (Duolingo, Khan Academy,
Carnegie Learning), **un moteur déterministe choisit** — l'exercice, la progression, la
difficulté — et **le LLM parle** : explications, conversation, synthèses. Les modèles de
_knowledge tracing_ classiques battent les LLM en prédiction de maîtrise, pour un coût par
décision incomparablement inférieur. Et le chatbot sans garde-fous **nuit** à l'apprentissage
(Bastani _et al._, PNAS : −17 % à l'examen après usage libre).

- **P-5a — Le learner model est et reste déterministe.** SM-2, EWMA de maîtrise, adaptation de
  difficulté, misconceptions. **Aucun LLM ne décide d'une progression, d'un déblocage ou d'une
  récompense.**
- **P-5b — Le LLM intervient là où le langage EST la valeur** : expliquer, reformuler,
  converser, synthétiser — **ancré** sur des données vérifiées fournies dans le prompt
  (l'explication canonique, la clé, le tag de misconception). Jamais en calcul libre.
- **P-5c — La génération de contenu reste offline + gates + revue.** L'usine `content-*` /
  `prof-*` est exactement l'état de l'art. L'anti-pattern inverse est documenté : les 148 cours
  générés de Duolingo, avril 2025.
- **P-5d — Une seule porte LLM runtime.** Adaptateur unique, comptabilité `ai_usage_events`,
  quotas et énergie, kill-switch. **Aucune capacité IA runtime hors de cette porte** — pas de
  deuxième intégration parallèle.
- **P-5e — Garde-fous mineurs, non négociables.** Jamais le nom de l'élève dans un prompt ;
  conversations journalisées et visibles des parents ; quotas ; **pas d'entraînement sur les
  données élèves**.

### Où l'IA apporte, par ordre de valeur

| Rang | Capacité                  | Apport retenu                                                      |
| ---- | ------------------------- | ------------------------------------------------------------------ |
| 1    | **Correction à l'échec**  | Explication ancrée sur l'item **+ le distracteur choisi** + le tag |
| 2    | **Usine de contenu**      | Génération offline gated + revue (déjà en place)                   |
| 3    | **Tuteur / chat cadré**   | Indices progressifs qui **ne donnent jamais la réponse**           |
| 4    | **Sélection/progression** | **Aucun LLM** — apport « négatif », et structurant (P-5a)          |
| 5    | **Rapport parent**        | Digest en langage naturel FR/AR sur des agrégats **déterministes** |
| 6    | **Banque d'exercices**    | Variantes paramétriques **vérifiées par solveur**, en batch        |
| 7    | **Pistes langues**        | Conversation puis oral — après V1 (coût et modération supérieurs)  |

**Pourquoi finir le socle d'abord.** Aucun tuteur IA aligné sur le programme tunisien FR/AR
n'existe, et le leader local n'a pas d'IA documentée. La combinaison « corpus corrigé
propriétaire + télémétrie de misconceptions + graphe de compétences + LLM discipliné » est
l'actif que personne d'autre n'a localement. **C'est le socle qui rend l'IA non-gadget** — sans
lui, on livre le même chatbot que tout le monde.

---

## 6. Ce que la doctrine ne gouverne PAS

**La largeur catalogue suit sa propre gouvernance** : barre de qualité contenu, gates
`content:*`, registre de suivi, audits. La règle du §4 ne s'applique qu'aux **capacités**.

Le déséquilibre est **assumé** et vaut d'être compris : le contenu est l'actif dont la largeur
**est** de la profondeur de catalogue. Un élève de 8ᵉ sans sa classe n'a rien à approfondir. La
cadence des campagnes reste un arbitrage humain.

Hors périmètre également : **aucun gate CI de doctrine**. La doctrine s'applique aux frontières
humaines qui existent déjà — création d'étude (la fiche), validation (l'humain vérifie), revue
de lot (la DoE complète le DoD). Un `doctrine:check` serait indécidable mécaniquement : de la
friction sans valeur.

---

## 7. Comment la doctrine s'applique, concrètement

| Où                              | Quoi                                                                                                                            |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **À la création d'une étude**   | La **fiche de verticalité** de `FableEtudes/_TEMPLATE.md` : verticale · maturité visée · boucles ouvertes/refermées · apport IA |
| **À la validation d'une étude** | L'humain vérifie la fiche. Une étude sans fiche n'est pas validable.                                                            |
| **À la revue d'un lot**         | La **DoE** (§3) complète le DoD d'AGENTS.md.                                                                                    |
| **Dans le topo**                | La colonne **« M »** du tableau des features de [STATUS.md](../STATUS.md).                                                      |
| **Dans le séquencement**        | L'ordre d'exécution de l'index des études, par verticale.                                                                       |
| **Capacités signature (M4)**    | **correction-révision**, **tuteur**, **examen blanc**. Tout le reste vise M3 **et s'y arrête**.                                 |

⚠️ **Les études existantes ne sont pas rétro-modifiées.** La fiche vaut pour les **nouvelles**
études ; les anciennes sont positionnées par l'analyse de portefeuille de l'étude 26. Rouvrir
vingt-cinq études pour leur ajouter quatre lignes serait précisément la bureaucratie que la
doctrine refuse.

---

## 8. Les deux façons de mal l'appliquer

Elles sont nommées ici parce qu'elles sont plus probables que l'oubli de la règle.

1. **Le gold-plating uniforme.** Lire « brique d'excellence » comme « tout doit être M4 ». Non :
   **M3 est le plancher, M4 est une exception désignée.** Pousser une capacité ordinaire à M4
   coûte le temps d'une capacité manquante — c'est de la largeur payée au prix de la
   profondeur.
2. **Le gel comme classement vertical.** Lire « gelée » comme « rejetée ». Non : un gel est
   **motivé, écrit et réversible**. Il existe pour que la décision reste visible et
   re-arbitrable — pas pour enterrer une idée sans le dire.

---

## 9. En un paragraphe

Avant d'ouvrir quoi que ce soit, on finit ce qui est commencé. Une capacité n'est finie que
quand un élève accomplit son job de bout en bout, que toute donnée collectée est retournée à
un écran, que les états dégradés existent, que la valeur est mesurée — et que la question
« l'IA sert-elle ici ? » a reçu une réponse écrite, fût-elle non. Le déterministe décide, le
LLM rédige. Le reste est gelé, par écrit, et dégelable.
