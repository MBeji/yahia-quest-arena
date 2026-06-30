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
