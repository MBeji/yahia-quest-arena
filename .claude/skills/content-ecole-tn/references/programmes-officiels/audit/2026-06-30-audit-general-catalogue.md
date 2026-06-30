# Worklist d'audit — catalogue (état au 29/06/2026)

Branche `claude/multiple-correct-answers-bug-xm7wx5`. Skills d'audit mis à jour (clarté, âge,
fuite-contenu). **Note** : l'extension par sous-agents a été interrompue par du **rate-limiting API**
(trop d'agents en parallèle) ; la couverture catalogue-wide ci-dessous est **déterministe** (fiable),
la couche jugement est un échantillon (à reprendre à cadence douce).

## A. Couverture déterministe — TOUT le catalogue (fiable)

- **Affichage / notation : PROPRE partout.** 0 SVG sans viewBox, 0 encre blanche, 0 chiffre
  arabo-indien, 0 LaTeX/`$…$`, 0 espace bidi-dangereux, 0 virgule arabe dans notation.
- **Doubles-réponses numériques : 9 corrigées** (commit déjà poussé) ; re-scan = 0 restant.
- **Équilibre des clés (position) : NON pertinent** — le moteur mélange les options à l'affichage.
- **Fuite « bonne réponse = option la plus longue » (survit au mélange) — carte complète :**

  | Matière                  | flag/total | %       | Matière                  | flag/total | %   |
  | ------------------------ | ---------- | ------- | ------------------------ | ---------- | --- |
  | arabic-5eme              | 113/280    | **40%** | education-islamique-4eme | 74/525     | 14% |
  | eveil-scientifique-5eme  | 97/350     | **28%** | eveil-scientifique-2eme  | 43/350     | 12% |
  | sciences-vie-terre       | 64/254     | **25%** | eveil-scientifique-4eme  | 29/280     | 10% |
  | arabic (9è)              | 66/323     | **20%** | french / anglais-c2      | ~30        | 10% |
  | arabic-4eme              | 53/280     | **19%** | francais-c2              | 23/280     | 8%  |
  | education-islamique-2eme | 42/280     | 15%     | svt                      | 17/258     | 7%  |

  Maths : 0–2 % partout (propre). Total : 859/13 546 questions (6,3 %), concentré sur l'arabe +
  sciences. Heuristique → à confirmer item par item, mais les matières >15 % ont un schéma d'auteur
  systématique (l'option correcte porte une justification « ؛ لأنّ… / هكذا قال النصّ » que les
  distracteurs n'ont pas).

## B. Couche jugement — audits terminés

| Matière                      | Q    | Verdict       | Notes                                      |
| ---------------------------- | ---- | ------------- | ------------------------------------------ |
| math-1ere                    | 261  | SHIP          | 0B/0M/4m                                   |
| math-6eme ch.02–05           | 145  | SHIP          | 0B/0M ; notation propre                    |
| eveil-scientifique-3eme      | 280  | SHIP          | 0B/0M                                      |
| culture-generale-histoire-fr | 29   | SHIP          | faits vérifiés                             |
| arabic-2eme (ch.4,5)         | ~70  | leak ch.5     | clés correctes ; fuite sur Q de clôture    |
| arabic-3eme (ch.3,4)         | ~70  | SHIP          | clés correctes                             |
| **arabic-5eme**              | ~280 | **FIX-FIRST** | leak ch.5 (31/36) + notions hors-niveau 5è |

## C. À reprendre (jugement) — interrompu par rate-limit

École-tn : arabic-1ere, arabic-4eme, math-2/3/5eme, eveil-1/2/4/5/6, education-islamique-1..4, svt.
Hors-école : anglais a1..c2, francais a1..c2, english, french, fr-mastery, culture-generale ×14,
iq-training ×3, donjons.

## D. Recommandation de correction (par priorité)

1. **Pass « de-leak » ciblé** sur les matières >15 % (arabic-5eme, eveil-5eme, svt, arabic, arabic-4eme,
   education-islamique-2/4) : déplacer la justification de l'option correcte vers `explanation`,
   homogénéiser la longueur des options. Mécanique, gros impact, faible risque.
2. **arabic-5eme** : en plus du de-leak, recadrer les notions hors-niveau (بدل، أفعال القلوب، رباعي،
   الحال السببية…).
3. Reprendre la couche jugement des matières en C à cadence douce (≤4 agents) ou en session dédiée.

## E. Vague A (jugement, cadence douce) — école-tn

| Matière                 | Q    | Verdict       | Fuite-longueur (réel)               | Autre                                                               |
| ----------------------- | ---- | ------------- | ----------------------------------- | ------------------------------------------------------------------- |
| math (9è)               | 478  | SHIP          | non (0-2%)                          | 15 mineurs cosmétiques ($$ bidi ch12:63)                            |
| arabic (9è)             | ~300 | SHIP          | NON (justif aussi sur distracteurs) | 3 mineurs                                                           |
| arabic-4eme             | 280  | SHIP/1M       | non                                 | MAJOR: 05/05-entrainement q1 « بحرف الجر » sans préposition (إضافة) |
| sciences-vie-terre      | 254  | 1M systémique | **OUI 68% (174/254)**               | 0 erreur factuelle                                                  |
| eveil-scientifique-5eme | 350  | 1M systémique | **OUI 37% (130/350)**               | 0 erreur factuelle                                                  |

→ Confirmé : fuite concentrée sur SCIENCES (éveil\*, svt). Grammaire arabe = surtout OK.

## F. Vague B — éveil scientifique (toute la matière)

| Niveau     | Q    | Verdict | Fuite-longueur             | Factuel  |
| ---------- | ---- | ------- | -------------------------- | -------- |
| eveil-1ere | ~327 | SHIP    | ~17% (non systémique)      | 0 erreur |
| eveil-2eme | ~350 | 1M      | ~30-40% d3-d4 (2 motifs)   | 0 erreur |
| eveil-4eme | 280  | 1M      | 51% longest / 28% marge≥10 | 0 erreur |
| eveil-5eme | 350  | 1M      | 37% (130/350)              | 0 erreur |
| eveil-6eme | ~315 | 1M      | ~27%                       | 0 erreur |

→ Science = correctness parfaite ; fuite systémique (sauf 1ere). Même fix mécanique partout.

## G. Vague C — éducation islamique — NON ABOUTIE

Les 4 agents (islamique 1è-4è) sont morts sur **limite d'usage de session (reset minuit UTC)**.
À relancer après reset. Idem reste hors-école.

## H. Synthèse & état d'avancement

**Audité (jugement) : 17 matières** — math 1è/9è/6è(ch2-5), arabe 9è/2è/3è/4è/5è, éveil 1è-6è,
SVT(sciences-vie-terre), culture-G histoire-fr.
**Conclusions fermes :**

1. **0 erreur de clé / 0 erreur factuelle** trouvée hors des 9 doubles-réponses numériques **déjà
   corrigées**. Le contenu est correct.
2. **Affichage/notation : propre sur tout le catalogue** (déterministe).
3. **Défaut dominant = fuite « option correcte la plus longue »**, qui survit au mélange. **Systémique
   sur les SCIENCES** (SVT 68 %, éveil 2/4/5/6 ≈ 27-51 %), **ponctuel** ailleurs (arabe-5è ch5 ;
   compréhension arabe-2è). **Quasi absent en maths et en grammaire arabe** (où les justifications sont
   aussi sur les distracteurs). éveil-1è sous le seuil.
4. Quelques MAJOR isolés : arabe-4è (« بحرف الجر » sans préposition) ; arabe-5è (notions hors-niveau 5è).

**Reste à auditer (après reset) :** éducation islamique 1-4, svt, math 2/3/5, arabe-1è,
math-6è(ch6-23), + hors-école (anglais a1-c2, francais a1-c2, english, french, fr-mastery,
culture-générale ×13, iq-training ×3, donjons).

**Reco de correction n°1 (mécanique, fort impact, identity-safe) :** pass « de-leak » sciences —
déplacer la clause de justification de l'option correcte vers `explanation`, homogénéiser la longueur
des 4 options. Cible : éveil 2/4/5/6 + SVT. Puis arabe-5è (de-leak + recadrage niveau).

## I. Vague C — éducation islamique (toute la matière)

| Niveau         | Q   | Verdict   | Fuite (strictement la + longue) | Doctrinal                                           |
| -------------- | --- | --------- | ------------------------------- | --------------------------------------------------- |
| islamique-1ere | 280 | FIX-FIRST | 50,7%                           | 0 erreur (versets, hadiths, tawḥīd)                 |
| islamique-2eme | 280 | FIX-FIRST | 70,7% / 47% marquée             | 0 erreur (sourates, piliers, hadiths)               |
| islamique-3eme | 280 | SHIP/fix  | 54,6%                           | 0 erreur (fiqh malikite, takbirat Aïd web-vérifiés) |
| islamique-4eme | 525 | SHIP/fix  | 62,9% / 35% (≥10c)              | 0 erreur (madhab malikite fidèle)                   |

→ Doctrinalement irréprochable ; fuite systémique (50-71%). IMPORTANT : mon heuristique 1,6×
sous-estimait fortement — la vraie « option correcte strictement la + longue » est à 50-71%.

## J. Vague D — fin école-tn (échantillon)

| Matière                      | Q    | Verdict | Fuite          | Notes                                                                                                                                               |
| ---------------------------- | ---- | ------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| arabic-1ere                  | ~270 | SHIP    | ~1%            | options homogènes (lettres/chiffres/images)                                                                                                         |
| math-2eme                    | 279  | SHIP/2M | 8.2% (2 réels) | fuite géométrie ch07 ; meta-option ch02 ; ch8/9 légers                                                                                              |
| math-3eme                    | 279  | SHIP    | 8.2% fortuit   | meta-option « لا شيء ممّا سبق » ch02 (4 items)                                                                                                      |
| **svt (physique-chimie 9è)** | ~204 | **4M**  | ~9%            | **3 MAJOR hors-programme : paliers d4 = niveau LYCÉE** (Snell ch3, moles ch5, concentration molaire ch7). ⚠️ à valider vs CNP (pas de manifeste 9è) |

→ Maths = propre (fuite fortuite, qq items géométrie). svt physique = correct mais d4 trop avancés.

## K. Défaut d'affichage ponctuel — artefact « LTR: » (déterministe, tout le catalogue)

3 explications avec le token parasite « LTR: » côté élève (à supprimer) :

- math-5eme/08-mesure-grandeurs/exercices/04-defi.json q#2 (« تصاعدي: LTR: 900 < 1050 »)
- math-5eme/08-mesure-grandeurs/exercices/02-boss.json q#5 (« ونقارن: LTR: 120 > 95 »)
- math-5eme/08-mesure-grandeurs/exercices/05-entrainement.json q#3 (« ونقارن: LTR: 850 > 800 »)

* typo math-5eme/08 04-defi q#? : « اللترتيب » → « الترتيب ». Correctifs triviaux.

## L. Vague E — fin maths école-tn + 1er hors-école

| Matière                        | Q    | Verdict       | Fuite | Notes                                                                                |
| ------------------------------ | ---- | ------------- | ----- | ------------------------------------------------------------------------------------ |
| math-4eme                      | ~630 | SHIP/1M       | <5%   | **MAJOR affichage** : tuple virgule arabe `(2، 3)` ch13-quadrillage q5/6 → `(2 ; 3)` |
| math-5eme                      | ~420 | SHIP          | ~0%   | artefacts `LTR:` ch08 (§K) ; meta-option ch03                                        |
| math-6eme (reste 01,06-23)     | 665  | SHIP          | 9.3%  | hotspots définitions géo : 19-quadrilatères 46%, 16-perpendic. 29%                   |
| culture-generale-geographie-fr | 29   | **1 BLOCKER** | ~7%   | « 7 continents » keyé alors que conv. FR = 6 → reformuler (+ vérifier EN/AR)         |

## M. SYNTHÈSE ÉCOLE-TN — AUDIT COMPLET (toutes matières)

**~7 800 questions re-résolues à l'aveugle.** Conclusions :

1. **Correctness : 0 clé fausse, 0 erreur factuelle/doctrinale** au-delà des **9 doubles-réponses
   numériques déjà corrigées**. (math 1-9è, arabe 1-5è+9è, éveil 1-6è, SVT, svt-physique, islamique 1-4è.)
2. **Affichage/notation : propre**, sauf **2 défauts isolés triviaux** : tuple `(2، 3)` (math-4è) +
   3 artefacts `LTR:` (math-5è ch08). Scan virgule-arabe corrigé → 1 seule violation catalogue-wide.
3. **Défaut dominant = fuite « option correcte la + longue »** (survit au mélange) :
   - **Systémique** : islamique 50-71%, éveil 2/4/5/6è 27-51%, SVT 68%, + items de définition
     géométrique (math 19-quad 46%, 16, math-2è ch07).
   - **Absent** : arithmétique, grammaire arabe (justif aussi sur distracteurs), petites classes.
4. **MAJOR de contenu à arbitrer** : svt — paliers d4 niveau **lycée hors-programme** (Snell, moles,
   concentration molaire) à valider vs CNP ; arabe-5è notions hors-niveau ; arabe-4è « بحرف الجر ».
5. **1 BLOCKER hors-école** (géo-fr « 7 continents »).

**Reste : hors-école** (anglais/français CEFR ×12 + donjons, english, french, fr-mastery,
culture-générale ×12, iq-training ×3).

## N. Hors-école — culture générale (vague F)

| Matière       | Verdict       | Notes                                                                      |
| ------------- | ------------- | -------------------------------------------------------------------------- |
| geographie-fr | **1 BLOCKER** | « 7 continents » sans reconnaître le modèle FR à 6 → reformuler comme l'AR |
| geographie-en | SHIP          | « Seven » correct (public anglo)                                           |
| geographie-ar | SHIP          | « 7 » défendable (stem « تقليديًّا » + explication nomme le 6)             |
| histoire-fr   | SHIP          | (déjà) 5 mineurs                                                           |
| histoire-ar   | SHIP          | faits vérifiés, notation propre                                            |
| histoire-en   | SHIP          | faits vérifiés                                                             |

→ Culture-G factuelle = excellente. Seul fix : reformuler le « continents » FR (template = version AR).

## O. Hors-école — culture G économie/politique (vague G)

| Matière      | Verdict | Fuite                | Faits                                           |
| ------------ | ------- | -------------------- | ----------------------------------------------- |
| economie-fr  | SHIP/1M | 38% (défi 67%)       | vérifiés (Smith, FMI 1944, euro 2002, OMC, BCE) |
| economie-en  | SHIP/1M | 14%                  | vérifiés                                        |
| economie-ar  | SHIP    | 21%                  | vérifiés                                        |
| politique-fr | SHIP/1M | 14% (révision q2/q3) | vérifiés, aucun dirigeant périmé                |

→ Culture-G factuelle excellente partout ; fuite modérée concentrée sur paliers défi conceptuels.

## P. Hors-école — politique/donjon/iq (vague H)

| Matière                     | Verdict | Notes                                                                             |
| --------------------------- | ------- | --------------------------------------------------------------------------------- |
| politique-en                | SHIP/1M | fuite 10% (3 items) ; options num. non triées (mineur)                            |
| politique-ar                | SHIP    | fuite 14% isolée ; faits vérifiés                                                 |
| culture-generale-dungeon-fr | SHIP    | 17 faits vérifiés ; cours dit à tort « quiz gate ≥80% » (hors-école non gaté)     |
| iq-training-fr              | SHIP    | puzzles visuels OK (réponse unique), SVG visibles ; séquences dupliquées (mineur) |

→ politique (3 langues) propre. iq visuel FR solide. donjon FR propre.

## Q. Hors-école — iq-training + donjons (vague I)

| Matière                     | Verdict      | Notes                                                                                                            |
| --------------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------- |
| iq-training-fr              | SHIP         | puzzles OK ; séquences dupliquées (mineur)                                                                       |
| iq-training-en              | SHIP/1M      | **texte FR non traduit dans SVG** (~10 fichiers, non porteur) ; clés OK                                          |
| iq-training-ar              | FIX-FIRST/3M | **texte FR dans SVG (32 occ/14 fichiers, certains PORTEURS** → arabophone bloqué) + séquence dupliquée ; clés OK |
| culture-generale-dungeon-en | SHIP/1M      | 1 fuite (q5 PIB) ; faits vérifiés                                                                                |
| culture-generale-dungeon-ar | SHIP         | faits actuels, notation propre                                                                                   |

→ **Bug d'héritage trilingue iq-training** : légendes SVG en FR jamais traduites en AR/EN. Fix ciblé.
Scan déterministe confirme iq-training-ar = 32 légendes latines dans SVG.

## R. Hors-école — langues niveaux A (vague J)

| Matière         | Q   | Verdict       | Notes                                                                                      |
| --------------- | --- | ------------- | ------------------------------------------------------------------------------------------ |
| anglais-a1      | 155 | SHIP          | 0B/0M ; pas de double-réponse ; fuite 0%                                                   |
| anglais-a2      | 280 | SHIP          | explication garbled 08-reading/03-boss q6 (clé OK)                                         |
| **francais-a1** | 210 | **1 BLOCKER** | 04-defi q5 « Ses/Ces sœurs sont médecins » = 2 réponses valides → fix distracteur/contexte |
| francais-a2     | 280 | 1 expl.       | 04-defi q6 explication « (c) » au lieu de (d) (clé OK)                                     |

→ Langues = clés correctes ; risque = double-réponse sémantique (1 trouvé) + explications qui
référencent les options PAR LETTRE alors que le moteur mélange (smell systématique à corriger).

## S. Hors-école — langues niveaux B (vague K)

| Matière     | Q    | Verdict   | BLOCKER/MAJOR                                                                                                             |
| ----------- | ---- | --------- | ------------------------------------------------------------------------------------------------------------------------- |
| anglais-b1  | ~280 | FIX-FIRST | **2B** : used-to/would double-réponse (06/02-rev q2) ; expl. contradiction (01/05-drill q4) ; 1M (chapitre used-to/would) |
| anglais-b2  | ~252 | FIX-FIRST | **1B** : reported-speech clé/expl. incohérentes (03/05-drill q6)                                                          |
| francais-b1 | ~280 | FIX-FIRST | **2B** : expl. auto-contradictoire (01/01-prat q6) ; opinion double-réponse (08/02-rev q5)                                |
| francais-b2 | ~282 | SHIP/1M   | expl. contredit la clé (06-gerondif/04-defi q2)                                                                           |

→ THÈME LANGUES : clés ~correctes mais (1) explications qui réfèrent les options PAR LETTRE
(fausses car moteur mélange) et nomment parfois la mauvaise lettre ; (2) vraies double-réponses
grammaticales (used-to/would, Ses/Ces, opinion). 2 défauts à corriger par sujet en moyenne.
