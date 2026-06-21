# Rapport d'audit — contenu primaire **math** (1ère + 2ème)

> **Généré** : 2026-06-21 · **Périmètre** : `math-1ere` + `math-2eme` (contenu réaligné, en prod).
> **Méthode** : `content:audit` (couverture/conformité structurelle) + audit pédagogique `content-audit`
> (re-résolution **à l'aveugle** de chaque question, vérif. notation/langue/cours/SVG, conformité CNP).
> **Lecture seule — aucune correction appliquée ici.** Ce document est la **worklist** pour la session de
> génération/alignement. Ne pas sceller (`sealed:true`) 1ere-base/2eme-base tant que les MAJOR ne sont pas traités.

## Synthèse

- **540 questions re-résolues** (261 en 1ère, 279 en 2ème) → **0 clé fausse, 0 BLOCKER, 0 ambiguïté double-réponse.**
- **Notation / langue / SVG impeccables** partout : zéro chiffre arabo-indien, zéro LaTeX/`$…$`, `−` = U+2212,
  `×` correct, unités SI, aucun groupement de chiffres bidi-dangereux en prose, tous les `<svg>` ont `viewBox` + encre sombre, arabe pur.
- **Le défaut dominant = conformité de niveau** : plusieurs chapitres enseignent/testent des notions du **niveau supérieur**.
- **Verdict : fix-first** (corriger avant diffusion/scellage) — non bloquant (rien de faux), mais hors-programme.

| Matière | Questions | BLOCKER | MAJOR | MINOR |
| --- | --- | --- | --- | --- |
| math-1ere | 261 | 0 | 3 | 4 |
| math-2eme | 279 | 0 | 4 | 9 |

---

## 1. Couverture & conformité structurelle — `npm run content:audit`

```
━━ Niveau 1ere-base (scellé : non) ━━
  ✓ math-1ere                  couverture 9/9 (100%)
  ✗ arabic-1ere                MATIÈRE MANQUANTE
  ✗ education-islamique-1ere   MATIÈRE MANQUANTE
  ✓ eveil-scientifique-1ere    chapitres non codifiés
  ✗ french-1ere                MATIÈRE MANQUANTE
  ✗ english-1ere               MATIÈRE MANQUANTE
━━ Niveau 2eme-base (scellé : non) ━━
  ✓ math-2eme                  couverture 9/9 (100%)
  ✗ arabic-2eme · education-islamique-2eme · french-2eme · english-2eme   MATIÈRE MANQUANTE
  ✓ eveil-scientifique-2eme    chapitres non codifiés
```

À faire (session génération) : **construire** arabic / education-islamique / français / anglais (1ère & 2ème) ;
**codifier puis réaligner** `eveil-scientifique-1ere/2eme` (présents mais ancien contenu générique, chapitres non
encore inscrits au manifeste).

---

## 2. Worklist — `math-1ere` (3 MAJOR · 4 MINOR)

> Problème central : `04-addition` traite massivement la **retenue (الجمع مع احتفاظ)**, **hors-programme en 1ère**
> (CNP/Taybah = « آلية الجمع **دون احتفاظ** ») **et** non enseignée dans son propre cours (golden-rule rompue en série).

### 04-addition — `[MAJOR ×2] [MINOR ×1]`
- **[MAJOR]** Hors-programme + tested-but-untaught : items **à retenue** dont l'explication déroule un algorithme jamais
  vu en cours — `exercices/02-boss.json` q3 (28+6), q4 (45+17), q6 (19+19) ; `03-revision.json` q5 (16+7) ;
  `04-defi.json` q2 (25+25), q3 (14+9+6), q5 (38+14) ; `05-entrainement.json` q1 (9+6), q3 (47+8), q5 (26+17).
  → remplacer par des additions **sans retenue** ≤ 99 (type 32+25, 40+30, déjà présents et conformes).
- **[MAJOR]** `resume.md` (≈ l.9) introduit « **مع احتفاظ** … 27 + 5 = 32 » alors que `cours.md` n'enseigne **que** le
  sans-retenue (titre + `> ⚠️` disent « دون احتفاظ ») → miroir résumé↔cours rompu. Supprimer la puce « مع احتفاظ ».
- **[MINOR]** Sommes 1-chiffre > 9 (8+5, 7+4, 8+8, 9+6) admissibles (compléments/doubles < 20) mais le cours ne pose
  aucun exemple de franchissement de la dizaine → ajouter 1 exemple travaillé (مكمّل 10) si on les garde.

### 07-reperage-espace — `[MAJOR ×1] [MINOR ×1]`
- **[MAJOR]** `cours.md` (clôture `> 🏆`, ≈ l.44) liste « …الجمع، **الطرح**، الأشكال… » — référence à la **soustraction**,
  inexistante en 1ère. → retirer « الطرح ».
- **[MINOR]** Récit « البوّابة الأخيرة » contredit `displayOrder: 1` (chapitre en tête de l'année) → harmoniser.

### 01-nombres-jusqu-9 — `[MINOR ×1]`
- **[MINOR]** `02-boss.json` q4 (5 doigts, on cache 2) et `04-defi.json` q4 (6 oiseaux, 3 s'envolent) : situations de
  **retrait** (lisibles « soustraction »). Acceptables en *comptage à rebours* sans signe `−`, mais reformuler en
  « كم بقي / كم أرى » (égrenage) pour écarter toute lecture soustraction.

### Chapitres propres
`02-nombres-jusqu-99`, `03-comparaison-rangement`, `06-formes-geometriques`, `08-ensembles`, `09-monnaie`, `10-lignes` — **✓ aucun constat**.

---

## 3. Worklist — `math-2eme` (4 MAJOR · 9 MINOR)

> Trois notions enseignées relèvent de la **3ème** : la soustraction **avec emprunt**, les **tables** de multiplication
> complètes, et l'**arrondi à la dizaine**.

### 04-soustraction — `[MAJOR ×1] [MINOR ×1]`
- **[MAJOR]** **Soustraction avec emprunt (الطرح مع الاستلاف) = hors-programme 2ème** (CNP/Taybah : « طرح **دون زيادة
  ولا تفكيك** » sur les 3 trimestres ; l'emprunt est en **3ème**). Concerné : `cours.md` §⚡ (section استلاف) + `resume.md` ;
  `quiz.json` q4 (52−27) ; `01-pratique` q6 (43−18) ; `02-boss` q1/q2/q4 (60−24, 345−128, 503−287) ; `03-revision` q4/q5
  (81−6, 94−47) ; `04-defi` q4/q5/q6 (600−145, 95−38, 402−158) ; `05-entrainement` q1–q6. → recentrer sur la soustraction
  **sans emprunt** (chiffre du haut ≥ chiffre du bas par rang) ; déplacer l'emprunt en 3ème. **Le plus structurant.**
- **[MINOR]** `02-boss.json` q4 (503−287) : double emprunt à travers un zéro + explication escamotée (disparaît avec le fix ci-dessus).

### 05-introduction-multiplication — `[MAJOR ×1] [MINOR ×2]`
- **[MAJOR]** **Tables complètes 2/3/4/5 jusqu'à ×9 mémorisées/drillées = 3ème**, au-delà du « مدخل » (introduction)
  prévu en 2ème (sens × = addition réitérée, signe ×, éventuellement le double). Concerné : `cours.md` §🔮 et §⚡ (tables) ;
  `02-boss` (4×7, 5×6, 3×9, 4×8, 5×9) ; `03-revision` q4/q5 (3×7, 4×6) ; `04-defi` q3/q5 (facteur manquant) ;
  `05-entrainement` (2×9, 5×7, 3×8, 4×4, 5×8). → réduire au sens + groupes égaux + double ; tables → 3ème.
- **[MINOR]** Convention « a × b = b additionné a fois » (4×3 = 3+3+3+3) **cohérente partout** mais inverse de certains
  manuels TN → vérifier l'alignement avec le manuel CNP retenu.
- **[MINOR]** `04-defi.json` q6 : « لكلّ دجاجةٍ **رِجلين** » → duel nominatif « **رِجلان** » (fait correct, coquille grammaticale).

### 02-comparaison-rangement — `[MAJOR ×1] [MINOR ×1]`
- **[MAJOR]** **Arrondi à la dizaine (التدوير) = hors-programme 2ème** (ni التدوير ni arrondi dans la liste CNP/Taybah ;
  notion 3ème). Concerné : `cours.md` §🛡️ + `quiz` q5 + items d'arrondi de `01`…`05` (47→50, 85→90, 32→30, 156→160) +
  bornes d'arrondi `04-defi` q5 / `05` q5. → retirer la section + les ~6 questions, ou déplacer en 3ème.
- **[MINOR]** `04-defi` q5 & `05-entrainement` q5 : même type « plus grand nombre qui s'arrondit à X » (quasi-doublon, dépend de la notion hors-programme).

### 01-nombres-jusqu-999 — `[MINOR ×2]`
- **[MINOR]** `04-defi.json` q1 (clé 507) et q6 (clé 507) : même nombre-réponse dans le même exercice → diversifier (705/750).
- **[MINOR]** `04-defi.json` q6 : distracteur « 057 » (zéro initial, écriture non standard) → ou « 75 ».

### 06-mesure-longueurs-temps — `[MINOR ×2]`
- **[MINOR]** `cours.md` §🛡️ « الشهر ≈ 4 أسابيع / ≈ 30 يومًا » absent de `resume.md` (et non testé) → ajouter au résumé ou retirer.
- **[MINOR]** Ordre d'affichage à confirmer (`displayOrder` mesure=7, monnaie=8, formes=9 vs ordre manifeste). Sans impact contenu.

### 07-formes-lignes — `[MINOR ×1]`
- **[MINOR]** Chapitre géométrie **sans aucune figure SVG** (questions purement verbales). Pas de BLOCKER (aucune question
  ne référence une figure absente) mais faible pour 7-8 ans → ajouter des SVG (formes + types de lignes, `viewBox` + encre sombre).

### Chapitres propres
`03-addition` (avec/sans retenue = conforme 2ème), `08-ensembles`, `09-monnaie` — **✓ aucun constat**.

---

## 4. Priorités (à traiter d'abord — toutes = conformité de niveau)

1. **math-2eme / 04-soustraction** — retirer la soustraction **avec emprunt** (→ 3ème) : cours + résumé + ~14 questions.
2. **math-1ere / 04-addition** — purger la **retenue** (→ hors 1ère) : ~10 questions + puce résumé ; aligner le cours.
3. **math-2eme / 05-introduction-multiplication** — supprimer les **tables complètes** (→ 3ème) ; garder l'introduction.
4. **math-2eme / 02-comparaison-rangement** — retirer l'**arrondi à la dizaine** (→ 3ème) : cours + ~6 questions.
5. **math-1ere / 07-reperage-espace** — retirer « **الطرح** » de la liste de clôture du cours.

> Après correction : relancer `content:audit` (couverture doit rester 9/9) + `content:qa:strict`, régénérer la migration
> (`content:build`), l'appliquer en prod, puis envisager de **sceller** le niveau. Les corrections retireront des questions :
> vérifier que chaque chapitre garde **≥1 mission** et l'échelle pratique/boss (le `content:audit` le signale).
