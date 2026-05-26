-- =========================================================
-- COMPLETE FRENCH PROGRAM - 9ème année Tunisie
-- Adds lesson_content for all 5 French chapters
-- Adds boss exercises where missing
-- Adds quiz questions for all exercises
-- =========================================================

-- ===================================================================
-- CHAPTER 1: GRAMMAIRE
-- ===================================================================
UPDATE public.chapters SET lesson_content = '# 📖 Chapitre du Sage : La Grammaire française

## 🏰 Porte 1 : Les types de phrases

> 💡 *"Maîtriser les types de phrases, c''est maîtriser l''art de communiquer !"*

Il existe **4 types** de phrases :

| Type | Fonction | Ponctuation | Exemple |
|------|----------|-------------|---------|
| **Déclarative** | Informer, constater | . | Le soleil brille. |
| **Interrogative** | Poser une question | ? | Viendras-tu demain ? |
| **Impérative** | Ordonner, conseiller | . ou ! | Ferme la porte ! |
| **Exclamative** | Exprimer un sentiment | ! | Quel beau paysage ! |

---

## ⚡ Porte 2 : Les formes de phrases

Chaque phrase peut être :
- **Affirmative** ou **Négative** : Je mange → Je **ne** mange **pas**
- **Active** ou **Passive** : Le chat attrape la souris → La souris est attrapée par le chat
- **Personnelle** ou **Impersonnelle** : Il pleut. / Il faut partir.
- **Neutre** ou **Emphatique** : C''est Pierre **qui** a gagné.

### 🗡️ La négation — formes variées :
- ne...pas (négation totale)
- ne...plus (cessation)
- ne...jamais (fréquence nulle)
- ne...rien (quantité nulle)
- ne...personne / ne...aucun
- ne...ni...ni (double négation)

---

## 🛡️ Porte 3 : Les propositions subordonnées

### 📐 La phrase complexe :
Une phrase complexe contient **plusieurs propositions** reliées entre elles.

### Types de propositions :

**1. Proposition subordonnée relative :**
- Introduite par un pronom relatif : qui, que, dont, où, lequel...
- Complète un nom (antécédent)
- Exemple : L''élève **qui travaille** réussira.

**2. Proposition subordonnée complétive :**
- Introduite par **que** (conjonction)
- Fonction : COD, sujet, attribut
- Exemple : Je pense **qu''il viendra**.

**3. Propositions subordonnées circonstancielles :**

| Type | Conjonctions | Exemple |
|------|-------------|---------|
| **Temps** | quand, lorsque, avant que, après que | Il sort **quand** il pleut. |
| **Cause** | parce que, puisque, comme | Il reste **parce qu''il** pleut. |
| **Conséquence** | si bien que, de sorte que | Il pleut **si bien que** je reste. |
| **But** | pour que, afin que | Je travaille **pour que** tu réussisses. |
| **Concession** | bien que, quoique (+subj.) | **Bien qu''il** pleuve, il sort. |
| **Condition** | si, à condition que | **Si** tu viens, je serai content. |
| **Comparaison** | comme, ainsi que | Il court **comme** le vent. |

---

## 🔮 Porte 4 : Voix active et voix passive

### Transformation :
- **Active** : Sujet + Verbe + COD
- **Passive** : Le COD devient sujet + être (au même temps) + participe passé + par + complément d''agent

### Exemples selon les temps :

| Temps | Active | Passive |
|-------|--------|---------|
| Présent | Le chat mange la souris | La souris **est mangée** par le chat |
| Passé composé | Le chat a mangé la souris | La souris **a été mangée** par le chat |
| Imparfait | Le chat mangeait la souris | La souris **était mangée** par le chat |
| Futur | Le chat mangera la souris | La souris **sera mangée** par le chat |

⚠️ **Attention** : Seuls les verbes transitifs directs (avec COD) acceptent la voix passive !

---

## 🔑 Porte 5 : Le discours rapporté

### Discours direct → Discours indirect :

| Direct | Indirect |
|--------|----------|
| Il dit : « Je viens. » | Il dit **qu''il vient**. |
| Il demande : « Viens-tu ? » | Il demande **si tu viens**. |
| Il ordonne : « Viens ! » | Il ordonne **de venir**. |

### Transformations au passé :
- Présent → Imparfait
- Passé composé → Plus-que-parfait
- Futur → Conditionnel présent
- Aujourd''hui → Ce jour-là
- Demain → Le lendemain
- Ici → Là

---

## 🏆 Résumé du chapitre :
*"La grammaire est le squelette de la langue — sans elle, les mots n''ont pas de structure !"*
' WHERE id = 'c2000000-0000-0000-0000-000000000001';

-- ===================================================================
-- CHAPTER 2: CONJUGAISON
-- ===================================================================
UPDATE public.chapters SET lesson_content = '# 📖 Chapitre du Maître du Temps : La Conjugaison

## 🏰 Porte 1 : Les temps de l''indicatif

> 💡 *"Conjuguer, c''est voyager dans le temps !"*

### ⚔️ Le présent de l''indicatif :

| Groupe | Terminaisons | Exemple |
|--------|-------------|---------|
| 1er (-er) | -e, -es, -e, -ons, -ez, -ent | je parle, tu parles... |
| 2ème (-ir → -issons) | -is, -is, -it, -issons, -issez, -issent | je finis, tu finis... |
| 3ème | -s, -s, -t/-d, -ons, -ez, -ent | je prends, tu prends... |

**Verbes irréguliers fréquents :** être, avoir, aller, faire, pouvoir, vouloir, savoir, devoir, venir, voir

---

## ⚡ Porte 2 : Les temps du passé

### 🗡️ L''imparfait :
- Formation : radical du présent (nous) + -ais, -ais, -ait, -ions, -iez, -aient
- Usage : description, habitude, action en cours dans le passé
- Exemple : Quand j''étais petit, je **jouais** au parc.

### 🛡️ Le passé composé :
- Formation : auxiliaire (être/avoir) au présent + participe passé
- Usage : action achevée dans le passé
- Exemple : J''**ai mangé** à midi. / Elle **est partie** hier.

⚠️ **Accord du participe passé :**
- Avec **être** : accord avec le sujet (Elle est part**ie**)
- Avec **avoir** : accord avec le COD placé avant (La pomme que j''ai mangé**e**)

### ⚔️ Le plus-que-parfait :
- Formation : auxiliaire à l''imparfait + participe passé
- Usage : action antérieure à une autre action passée
- Exemple : Il **avait fini** quand je suis arrivé.

### 🔮 Le passé simple :
- Terminaisons 1er groupe : -ai, -as, -a, -âmes, -âtes, -èrent
- Terminaisons 2ème groupe : -is, -is, -it, -îmes, -îtes, -irent
- Usage : récit littéraire, action ponctuelle passée
- Exemple : Il **entra** et **s''assit**.

---

## 🛡️ Porte 3 : Le futur

### Le futur simple :
- Formation : infinitif + -ai, -as, -a, -ons, -ez, -ont
- Exemple : Je **parlerai**, tu **finiras**, il **prendra**

### Le futur antérieur :
- Formation : auxiliaire au futur simple + participe passé
- Usage : action future achevée avant une autre
- Exemple : Quand j''**aurai fini**, je sortirai.

---

## ⚔️ Porte 4 : Le subjonctif

### Le subjonctif présent :
- Formation : radical de « ils » au présent + -e, -es, -e, -ions, -iez, -ent
- Usage : après les verbes de volonté, sentiment, doute, nécessité

**Expressions suivies du subjonctif :**
- Il faut que...
- Je veux que...
- Je doute que...
- Bien que... / Pour que... / Avant que...

Exemple : Il faut que tu **fasses** tes devoirs.

---

## 🔮 Porte 5 : Le conditionnel

### Conditionnel présent :
- Formation : radical du futur + terminaisons de l''imparfait (-ais, -ais, -ait, -ions, -iez, -aient)
- Usages : politesse, souhait, hypothèse, information incertaine
- Exemple : Je **voudrais** un café. / Si j''étais riche, je **voyagerais**.

### Conditionnel passé :
- Formation : auxiliaire au conditionnel présent + participe passé
- Usage : regret, reproche, irréel du passé
- Exemple : J''**aurais aimé** venir. / Si j''avais su, je **serais venu**.

---

## ⚡ Porte 6 : L''impératif

- Conjugaison à 3 personnes seulement : tu, nous, vous
- Pas de pronom sujet
- 1er groupe : **Mange !** (sans -s à la 2ème personne)
- 2ème groupe : **Finis !**
- 3ème groupe : **Prends ! Fais ! Sois !**

---

## 🏆 Résumé du chapitre :
*"Chaque temps est une arme — le passé raconte, le présent agit, le futur promet !"*
' WHERE id = 'c2000000-0000-0000-0000-000000000002';

-- ===================================================================
-- CHAPTER 3: VOCABULAIRE
-- ===================================================================
UPDATE public.chapters SET lesson_content = '# 📖 Chapitre de l''Explorateur : Le Vocabulaire

## 🏰 Porte 1 : Les champs lexicaux

> 💡 *"Les mots forment des familles — apprends à les reconnaître !"*

Un **champ lexical** est l''ensemble des mots qui se rapportent à un même thème.

### Exemples :
- **La mer** : vague, plage, sable, océan, marée, navire, écume, tempête
- **La peur** : terreur, effroi, angoisse, trembler, pâlir, frissonner
- **La joie** : bonheur, allégresse, sourire, rire, éclat, fête

📐 **Astuce** : Le champ lexical permet de comprendre le thème d''un texte et d''enrichir une production écrite.

---

## ⚡ Porte 2 : Synonymes et antonymes

### 🗡️ Les synonymes :
Mots de sens proche (mais pas identique !) :
- beau → magnifique, splendide, superbe
- grand → immense, vaste, gigantesque
- manger → dévorer, grignoter, savourer

⚠️ Les synonymes varient selon le **registre de langue** :
- Familier : bouffer / Courant : manger / Soutenu : se restaurer

### 🛡️ Les antonymes :
Mots de sens contraire :
- beau ≠ laid
- grand ≠ petit
- monter ≠ descendre
- commencer ≠ terminer

**Formation des antonymes par préfixes :**
- in-/im-/il-/ir- : possible → **im**possible
- dé-/dés- : faire → **dé**faire
- mal- : heureux → **mal**heureux

---

## 🛡️ Porte 3 : Les familles de mots

Les mots d''une même famille partagent un **radical commun** :

- **terre** : terrain, terrasse, atterrir, souterrain, territorial
- **port** : porter, transport, portable, importation, déporter
- **écrire** : écriture, écrivain, inscription, descriptif

### Formation des mots :
- **Préfixe** + radical : re-faire, pré-voir, in-connu
- Radical + **suffixe** : beau-té, grand-eur, mange-able
- **Préfixe** + radical + **suffixe** : in-support-able

---

## 🔮 Porte 4 : Les registres de langue

| Registre | Caractéristiques | Exemple |
|----------|-----------------|---------|
| **Familier** | Abrègements, argot, phrases incomplètes | T''as vu ? C''est ouf ! |
| **Courant** | Langue quotidienne correcte | Tu as vu ? C''est incroyable ! |
| **Soutenu** | Vocabulaire recherché, structures complexes | Avez-vous remarqué ? C''est extraordinaire ! |

---

## ⚔️ Porte 5 : Les figures de style

| Figure | Définition | Exemple |
|--------|-----------|---------|
| **Comparaison** | Rapprochement avec un outil (comme, tel) | Il est rusé **comme** un renard |
| **Métaphore** | Comparaison sans outil | Cet homme est **un lion** |
| **Personnification** | Attribuer des qualités humaines | Le vent **murmure** |
| **Hyperbole** | Exagération | Je meurs de faim |
| **Euphémisme** | Atténuation | Il nous a quittés (= il est mort) |
| **Antithèse** | Opposition de deux idées | Petit homme, **grande** ambition |
| **Énumération** | Liste de termes | Il aime le sport, la musique, le cinéma et les voyages |
| **Anaphore** | Répétition en début de phrase | **Paris !** Paris outragé ! **Paris** brisé ! |

---

## 🏆 Résumé du chapitre :
*"Un vocabulaire riche est une épée affûtée — plus tu en connais, plus tu es puissant !"*
' WHERE id = 'c2000000-0000-0000-0000-000000000003';

-- ===================================================================
-- CHAPTER 4: COMPRÉHENSION DE TEXTE
-- ===================================================================
UPDATE public.chapters SET lesson_content = '# 📖 Chapitre du Détective : La Compréhension de texte

## 🏰 Porte 1 : Le texte narratif

> 💡 *"Lire un texte narratif, c''est enquêter sur une histoire !"*

### Caractéristiques :
- Raconte une **histoire** (réelle ou fictive)
- Contient des **personnages**, un **cadre spatio-temporel**, une **intrigue**
- Temps dominants : passé simple / imparfait (récit) ou présent (narration)
- Narrateur : 1ère personne (je) ou 3ème personne (il/elle)

### Schéma narratif :
1. **Situation initiale** : présentation du cadre et des personnages
2. **Élément perturbateur** : événement qui bouleverse l''équilibre
3. **Péripéties** : actions et réactions des personnages
4. **Élément de résolution** : résolution du problème
5. **Situation finale** : nouvel équilibre

### Questions-clés :
- Qui ? (personnages) — Où ? Quand ? (cadre)
- Quoi ? (événements) — Comment ? Pourquoi ?
- Quel est le point de vue du narrateur ?

---

## ⚡ Porte 2 : Le texte argumentatif

### Caractéristiques :
- But : **convaincre** ou **persuader** le lecteur
- Structure : thèse + arguments + exemples + conclusion
- Connecteurs logiques : donc, car, en effet, cependant, toutefois, en revanche

### Structure d''un texte argumentatif :

| Partie | Rôle | Indices |
|--------|------|---------|
| **Introduction** | Présenter le sujet et la thèse | D''abord, il faut savoir que... |
| **Développement** | Arguments + exemples | En effet... Par exemple... De plus... |
| **Conclusion** | Résumer et élargir | En conclusion... Ainsi... |

### Les types d''arguments :
- **D''autorité** : citation d''un expert
- **D''expérience** : vécu personnel
- **Logique** : raisonnement cause-conséquence
- **Par l''exemple** : fait concret, statistique
- **Par analogie** : comparaison avec un domaine connu

---

## 🛡️ Porte 3 : Le texte descriptif

### Caractéristiques :
- But : faire **voir, sentir, imaginer**
- Temps dominant : imparfait
- Vocabulaire sensoriel : couleurs, sons, odeurs, textures
- Figures de style : comparaisons, métaphores, personnifications

### Organisation de la description :
- Du général au particulier (ou inversement)
- De haut en bas / de gauche à droite
- Du plus proche au plus lointain

### Indices :
- Adjectifs qualificatifs nombreux
- Compléments du nom
- Propositions relatives descriptives
- Verbes d''état : être, paraître, sembler

---

## 🔮 Porte 4 : Méthodologie d''analyse

### Étapes d''analyse d''un texte :

1. **Lecture globale** : comprendre le sens général
2. **Identification** : type de texte, genre, thème
3. **Analyse du paratexte** : titre, auteur, source, date
4. **Repérage** : champs lexicaux, figures de style, temps verbaux
5. **Interprétation** : intention de l''auteur, message, tonalité

### Les tonalités (registres littéraires) :

| Tonalité | Effet recherché | Indices |
|----------|----------------|---------|
| **Comique** | Faire rire | Jeux de mots, quiproquos |
| **Tragique** | Inspirer la pitié | Fatalité, mort, souffrance |
| **Lyrique** | Exprimer les sentiments | « je », exclamations, nature |
| **Pathétique** | Émouvoir | Souffrance, larmes, pitié |
| **Satirique** | Critiquer en se moquant | Ironie, exagération |

---

## 🏆 Résumé du chapitre :
*"Comprendre un texte, c''est percer ses secrets — chaque mot est un indice !"*
' WHERE id = 'c2000000-0000-0000-0000-000000000004';

-- ===================================================================
-- CHAPTER 5: PRODUCTION ÉCRITE
-- ===================================================================
UPDATE public.chapters SET lesson_content = '# 📖 Chapitre du Créateur : La Production écrite

## 🏰 Porte 1 : Le paragraphe argumentatif

> 💡 *"Écrire un bon paragraphe argumentatif, c''est construire un mur solide, brique par brique !"*

### Structure d''un paragraphe argumentatif :
1. **Phrase d''introduction** : annonce l''idée principale
2. **Argument** : raison qui soutient l''idée
3. **Exemple / illustration** : preuve concrète
4. **Phrase de conclusion** : synthèse ou transition

### Modèle :
> D''abord, [idée principale]. En effet, [argument]. Par exemple, [illustration concrète]. Ainsi, [conclusion partielle].

### Connecteurs utiles :

| Fonction | Connecteurs |
|----------|------------|
| Addition | De plus, en outre, par ailleurs, également |
| Cause | Car, en effet, parce que, puisque |
| Conséquence | Donc, ainsi, par conséquent, c''est pourquoi |
| Opposition | Mais, cependant, toutefois, en revanche, néanmoins |
| Conclusion | En conclusion, en somme, finalement, bref |

---

## ⚡ Porte 2 : La rédaction d''un essai

### Structure d''un essai argumentatif :

**Introduction (1 paragraphe) :**
- Accroche (question, citation, fait marquant)
- Présentation du sujet
- Annonce du plan (thèse)

**Développement (2-3 paragraphes) :**
- Paragraphe 1 : premier argument + exemple
- Paragraphe 2 : deuxième argument + exemple
- Paragraphe 3 (optionnel) : concession + réfutation OU troisième argument

**Conclusion (1 paragraphe) :**
- Résumé des arguments
- Réaffirmation de la thèse
- Ouverture (question, élargissement)

---

## 🛡️ Porte 3 : La lettre formelle

### Mise en page :
```
[Expéditeur]                    [Lieu, date]
[Adresse]

                                [Destinataire]
                                [Adresse]

Objet : [sujet de la lettre]

Madame / Monsieur,

[Corps de la lettre]

Veuillez agréer, Madame/Monsieur,
l''expression de mes salutations distinguées.

[Signature]
```

### Formules de politesse :
- **Début** : J''ai l''honneur de... / Je me permets de... / Suite à...
- **Fin** : Veuillez agréer... / Je vous prie d''accepter...

---

## 🔮 Porte 4 : Le texte descriptif / narratif

### Décrire un lieu :
- Utiliser l''imparfait
- Organiser spatialement (haut/bas, gauche/droite, proche/loin)
- Enrichir avec des adjectifs et des comparaisons
- Vocabulaire des 5 sens

### Raconter un événement :
- Respecter le schéma narratif
- Alterner passé simple (actions) et imparfait (descriptions)
- Utiliser des indicateurs temporels : d''abord, ensuite, puis, enfin, soudain

---

## ⚔️ Porte 5 : Conseils pratiques

### Grille d''auto-évaluation :
- ✅ Mon texte respecte-t-il la consigne ?
- ✅ Ai-je organisé mes idées logiquement ?
- ✅ Ai-je utilisé des connecteurs variés ?
- ✅ Mon vocabulaire est-il précis et riche ?
- ✅ Ai-je vérifié l''orthographe et la grammaire ?
- ✅ Ai-je varié les structures de phrases ?
- ✅ Mon introduction accroche-t-elle le lecteur ?
- ✅ Ma conclusion apporte-t-elle une synthèse claire ?

### Erreurs fréquentes à éviter :
- Phrases trop longues → varier les longueurs
- Répétitions → utiliser des synonymes
- Hors-sujet → relire la consigne
- Manque d''exemples → illustrer chaque argument
- Pas de transitions → utiliser des connecteurs

---

## 🏆 Résumé du chapitre :
*"Écrire, c''est penser clairement — chaque phrase doit avoir un but !"*
' WHERE id = 'c2000000-0000-0000-0000-000000000005';

-- ===================================================================
-- ADD BOSS EXERCISES WHERE MISSING (Chapters 3, 4, 5)
-- ===================================================================
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000012', 'c2000000-0000-0000-0000-000000000003', 'french', 'Boss: Maître du vocabulaire', 3, 120, 25, 'boss', 3),
  ('e2000000-0000-0000-0000-000000000013', 'c2000000-0000-0000-0000-000000000004', 'french', 'Boss: Détective littéraire', 3, 120, 25, 'boss', 3),
  ('e2000000-0000-0000-0000-000000000014', 'c2000000-0000-0000-0000-000000000005', 'french', 'Boss: Plume d''or', 3, 120, 25, 'boss', 3)
ON CONFLICT (id) DO NOTHING;

-- ===================================================================
-- QUIZ QUESTIONS FOR ALL FRENCH EXERCISES
-- ===================================================================

-- Chapter 1: Grammaire - Exercise e1 (Types et formes de phrases)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000001',
 '📖 Quel est le type de cette phrase : « Fermez la porte ! »',
 '[{"id":"a","text":"Impérative"},{"id":"b","text":"Exclamative"},{"id":"c","text":"Déclarative"},{"id":"d","text":"Interrogative"}]',
 'a', '🔑 Cette phrase donne un ordre → c''est une phrase impérative (même si elle finit par !).', 1),
('e2000000-0000-0000-0000-000000000001',
 '📖 Quelle est la forme négative correcte de « Il mange toujours » ?',
 '[{"id":"a","text":"Il ne mange jamais"},{"id":"b","text":"Il ne mange pas"},{"id":"c","text":"Il ne mange plus"},{"id":"d","text":"Il ne mange rien"}]',
 'a', '🔑 L''antonyme de « toujours » est « jamais » → ne...jamais.', 2),
('e2000000-0000-0000-0000-000000000001',
 '📖 « Quel magnifique coucher de soleil ! » est une phrase :',
 '[{"id":"a","text":"Exclamative"},{"id":"b","text":"Impérative"},{"id":"c","text":"Interrogative"},{"id":"d","text":"Déclarative"}]',
 'a', '🔑 Elle exprime un sentiment d''admiration avec « ! » → exclamative.', 3),
('e2000000-0000-0000-0000-000000000001',
 '📖 Transformez à la forme passive : « Le jardinier arrose les fleurs. »',
 '[{"id":"a","text":"Les fleurs sont arrosées par le jardinier."},{"id":"b","text":"Les fleurs arrosent le jardinier."},{"id":"c","text":"Le jardinier est arrosé par les fleurs."},{"id":"d","text":"Les fleurs ont été arrosées."}]',
 'a', '🔑 COD (les fleurs) → sujet + être + pp + par + complément d''agent.', 4),
('e2000000-0000-0000-0000-000000000001',
 '📖 « Ne... que » exprime :',
 '[{"id":"a","text":"La restriction (seulement)"},{"id":"b","text":"La négation totale"},{"id":"c","text":"La cessation"},{"id":"d","text":"L''absence de quantité"}]',
 'a', '🔑 « Il ne mange que des fruits » = Il mange seulement des fruits. C''est une restriction, pas une négation.', 5);

-- Chapter 1: Grammaire - Exercise e2 (Propositions subordonnées)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000002',
 '📖 Dans « L''homme qui court est mon voisin », la subordonnée est :',
 '[{"id":"a","text":"Relative"},{"id":"b","text":"Complétive"},{"id":"c","text":"Circonstancielle de temps"},{"id":"d","text":"Circonstancielle de cause"}]',
 'a', '🔑 « qui court » est introduit par le pronom relatif « qui » et complète le nom « homme ».', 1),
('e2000000-0000-0000-0000-000000000002',
 '📖 « Je pense qu''il viendra demain. » La proposition soulignée est :',
 '[{"id":"a","text":"Complétive (COD)"},{"id":"b","text":"Relative"},{"id":"c","text":"Circonstancielle de temps"},{"id":"d","text":"Circonstancielle de cause"}]',
 'a', '🔑 « qu''il viendra demain » est COD du verbe « penser » → complétive.', 2),
('e2000000-0000-0000-0000-000000000002',
 '📖 « Bien qu''il soit fatigué, il continue. » La subordonnée exprime :',
 '[{"id":"a","text":"La concession"},{"id":"b","text":"La cause"},{"id":"c","text":"Le but"},{"id":"d","text":"La conséquence"}]',
 'a', '🔑 « Bien que » introduit une concession (opposition à la logique attendue).', 3),
('e2000000-0000-0000-0000-000000000002',
 '📖 Quel pronom relatif complète : « La ville ... je viens est belle » ?',
 '[{"id":"a","text":"d''où"},{"id":"b","text":"qui"},{"id":"c","text":"que"},{"id":"d","text":"dont"}]',
 'a', '🔑 « venir de » + lieu → « d''où » (complément de lieu d''origine).', 4),
('e2000000-0000-0000-0000-000000000002',
 '📖 « Pour que tu réussisses, il faut travailler. » La subordonnée exprime :',
 '[{"id":"a","text":"Le but"},{"id":"b","text":"La cause"},{"id":"c","text":"La conséquence"},{"id":"d","text":"La condition"}]',
 'a', '🔑 « Pour que » introduit le but (l''objectif visé).', 5);

-- Chapter 1: Grammaire - Exercise e3 (Voix active et passive)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000003',
 '📖 Quelle phrase est à la voix passive ?',
 '[{"id":"a","text":"La lettre a été envoyée par Paul."},{"id":"b","text":"Paul a envoyé la lettre."},{"id":"c","text":"Paul envoie souvent des lettres."},{"id":"d","text":"Envoie cette lettre !"}]',
 'a', '🔑 « a été envoyée par » = auxiliaire être + pp + par → voix passive.', 1),
('e2000000-0000-0000-0000-000000000003',
 '📖 Transposez au discours indirect : Il dit : « Je viendrai demain. »',
 '[{"id":"a","text":"Il dit qu''il viendra le lendemain."},{"id":"b","text":"Il dit qu''il vient demain."},{"id":"c","text":"Il dit je viendrai demain."},{"id":"d","text":"Il dit qu''il viendrait demain."}]',
 'a', '🔑 Verbe introducteur au présent → pas de changement de temps. Demain → le lendemain.', 2),
('e2000000-0000-0000-0000-000000000003',
 '📖 « Le gâteau sera mangé par les enfants. » À la voix active :',
 '[{"id":"a","text":"Les enfants mangeront le gâteau."},{"id":"b","text":"Les enfants mangent le gâteau."},{"id":"c","text":"Les enfants ont mangé le gâteau."},{"id":"d","text":"Les enfants mangeaient le gâteau."}]',
 'a', '🔑 « sera mangé » = futur passif → actif au futur : « mangeront ».', 3),
('e2000000-0000-0000-0000-000000000003',
 '📖 Quel verbe ne peut PAS se mettre au passif ?',
 '[{"id":"a","text":"Aller"},{"id":"b","text":"Manger"},{"id":"c","text":"Construire"},{"id":"d","text":"Lire"}]',
 'a', '🔑 « Aller » est intransitif (pas de COD) → impossible au passif.', 4),
('e2000000-0000-0000-0000-000000000003',
 '📖 Il a dit : « J''ai fini hier. » → Au discours indirect passé :',
 '[{"id":"a","text":"Il a dit qu''il avait fini la veille."},{"id":"b","text":"Il a dit qu''il a fini hier."},{"id":"c","text":"Il a dit qu''il finissait hier."},{"id":"d","text":"Il a dit qu''il finirait la veille."}]',
 'a', '🔑 Passé composé → plus-que-parfait. Hier → la veille.', 5);

-- Chapter 2: Conjugaison - Exercise e4 (Indicatif: temps simples)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000004',
 '📖 Conjuguez « finir » à l''imparfait, 1ère personne du pluriel :',
 '[{"id":"a","text":"nous finissions"},{"id":"b","text":"nous finissons"},{"id":"c","text":"nous finîmes"},{"id":"d","text":"nous finirons"}]',
 'a', '🔑 Imparfait de « finir » : radical « finiss- » + terminaison « -ions ».', 1),
('e2000000-0000-0000-0000-000000000004',
 '📖 Quel est le passé simple de « voir » à la 3ème personne du singulier ?',
 '[{"id":"a","text":"il vit"},{"id":"b","text":"il voyait"},{"id":"c","text":"il voit"},{"id":"d","text":"il verra"}]',
 'a', '🔑 Voir → passé simple irrégulier : je vis, tu vis, il vit, nous vîmes...', 2),
('e2000000-0000-0000-0000-000000000004',
 '📖 « Quand je serai grand, je _____ médecin. » (devenir)',
 '[{"id":"a","text":"deviendrai"},{"id":"b","text":"deviendrais"},{"id":"c","text":"deviens"},{"id":"d","text":"devenais"}]',
 'a', '🔑 « Quand + futur » → futur simple. Devenir → je deviendrai.', 3),
('e2000000-0000-0000-0000-000000000004',
 '📖 Le plus-que-parfait est formé avec :',
 '[{"id":"a","text":"Auxiliaire à l''imparfait + participe passé"},{"id":"b","text":"Auxiliaire au présent + participe passé"},{"id":"c","text":"Auxiliaire au futur + participe passé"},{"id":"d","text":"Auxiliaire au passé simple + participe passé"}]',
 'a', '🔑 Plus-que-parfait = avoir/être à l''imparfait + pp. Ex: j''avais mangé.', 4),
('e2000000-0000-0000-0000-000000000004',
 '📖 Conjuguez « aller » au futur simple, 2ème personne du pluriel :',
 '[{"id":"a","text":"vous irez"},{"id":"b","text":"vous allez"},{"id":"c","text":"vous iriez"},{"id":"d","text":"vous allâtes"}]',
 'a', '🔑 Aller au futur : j''irai, tu iras, il ira, nous irons, vous irez, ils iront.', 5);

-- Chapter 2: Conjugaison - Exercise e5 (Subjonctif et conditionnel)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000005',
 '📖 « Il faut que tu _____ tes devoirs. » (faire)',
 '[{"id":"a","text":"fasses"},{"id":"b","text":"fais"},{"id":"c","text":"ferais"},{"id":"d","text":"feras"}]',
 'a', '🔑 « Il faut que » → subjonctif. Faire → que je fasse, que tu fasses...', 1),
('e2000000-0000-0000-0000-000000000005',
 '📖 « Si j''étais riche, je _____ le monde. » (parcourir)',
 '[{"id":"a","text":"parcourrais"},{"id":"b","text":"parcours"},{"id":"c","text":"parcoure"},{"id":"d","text":"parcourrai"}]',
 'a', '🔑 Si + imparfait → conditionnel présent. Parcourir → je parcourrais.', 2),
('e2000000-0000-0000-0000-000000000005',
 '📖 Quel mode est utilisé après « bien que » ?',
 '[{"id":"a","text":"Le subjonctif"},{"id":"b","text":"L''indicatif"},{"id":"c","text":"Le conditionnel"},{"id":"d","text":"L''impératif"}]',
 'a', '🔑 « Bien que » exprime la concession et exige toujours le subjonctif.', 3),
('e2000000-0000-0000-0000-000000000005',
 '📖 « J''aurais aimé venir. » exprime :',
 '[{"id":"a","text":"Un regret"},{"id":"b","text":"Un ordre"},{"id":"c","text":"Une certitude"},{"id":"d","text":"Un souhait réalisé"}]',
 'a', '🔑 Conditionnel passé → regret ou irréel du passé.', 4),
('e2000000-0000-0000-0000-000000000005',
 '📖 Conjuguez « être » au subjonctif présent, 3ème pers. du singulier :',
 '[{"id":"a","text":"qu''il soit"},{"id":"b","text":"qu''il est"},{"id":"c","text":"qu''il serait"},{"id":"d","text":"qu''il fut"}]',
 'a', '🔑 Être au subjonctif : que je sois, que tu sois, qu''il soit...', 5);

-- Chapter 2: Conjugaison - Exercise e6 (Boss: Conjugaison mixte)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000006',
 '💀 Boss : « Quand il _____ (arriver), nous _____ (partir) déjà. »',
 '[{"id":"a","text":"arriva / étions partis"},{"id":"b","text":"arrive / partons"},{"id":"c","text":"arrivait / partions"},{"id":"d","text":"arrivera / partirons"}]',
 'a', '☠️ Passé simple (action ponctuelle) + plus-que-parfait (antériorité).', 1),
('e2000000-0000-0000-0000-000000000006',
 '💀 Boss : « Si j''avais su, je ne _____ pas venu. » (être)',
 '[{"id":"a","text":"serais"},{"id":"b","text":"suis"},{"id":"c","text":"serai"},{"id":"d","text":"étais"}]',
 'a', '☠️ Si + plus-que-parfait → conditionnel passé. Ne serais pas venu.', 2),
('e2000000-0000-0000-0000-000000000006',
 '💀 Boss : Identifiez le temps : « Nous eûmes terminé avant midi. »',
 '[{"id":"a","text":"Passé antérieur"},{"id":"b","text":"Plus-que-parfait"},{"id":"c","text":"Passé composé"},{"id":"d","text":"Futur antérieur"}]',
 'a', '☠️ Auxiliaire au passé simple (eûmes) + pp = passé antérieur.', 3),
('e2000000-0000-0000-0000-000000000006',
 '💀 Boss : « Je doute qu''il _____ la vérité. » (dire)',
 '[{"id":"a","text":"dise"},{"id":"b","text":"dit"},{"id":"c","text":"dira"},{"id":"d","text":"dirait"}]',
 'a', '☠️ « Douter que » → subjonctif. Dire → que je dise, qu''il dise.', 4),
('e2000000-0000-0000-0000-000000000006',
 '💀 Boss : « Dès qu''il _____ fini, il sortira. » (avoir)',
 '[{"id":"a","text":"aura"},{"id":"b","text":"a"},{"id":"c","text":"avait"},{"id":"d","text":"aurait"}]',
 'a', '☠️ Dès que + futur antérieur (antériorité future) → « aura fini ».', 5);

-- Chapter 3: Vocabulaire - Exercise e7 (Champs lexicaux)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000007',
 '📖 Quel mot n''appartient PAS au champ lexical de la mer ?',
 '[{"id":"a","text":"Prairie"},{"id":"b","text":"Vague"},{"id":"c","text":"Écume"},{"id":"d","text":"Marée"}]',
 'a', '🔑 « Prairie » appartient au champ lexical de la campagne, pas de la mer.', 1),
('e2000000-0000-0000-0000-000000000007',
 '📖 « Terreur, angoisse, effroi, trembler » — quel champ lexical ?',
 '[{"id":"a","text":"La peur"},{"id":"b","text":"La colère"},{"id":"c","text":"La tristesse"},{"id":"d","text":"La surprise"}]',
 'a', '🔑 Tous ces mots évoquent la peur sous différentes formes.', 2),
('e2000000-0000-0000-0000-000000000007',
 '📖 Quel est le registre de langue de : « C''est vachement bien ! »',
 '[{"id":"a","text":"Familier"},{"id":"b","text":"Courant"},{"id":"c","text":"Soutenu"},{"id":"d","text":"Littéraire"}]',
 'a', '🔑 « Vachement » est un intensificateur familier (argot).', 3),
('e2000000-0000-0000-0000-000000000007',
 '📖 « Il est rusé comme un renard. » C''est une :',
 '[{"id":"a","text":"Comparaison"},{"id":"b","text":"Métaphore"},{"id":"c","text":"Personnification"},{"id":"d","text":"Hyperbole"}]',
 'a', '🔑 Présence de l''outil de comparaison « comme » → comparaison.', 4),
('e2000000-0000-0000-0000-000000000007',
 '📖 Trouvez l''antonyme de « courageux » :',
 '[{"id":"a","text":"Lâche"},{"id":"b","text":"Fort"},{"id":"c","text":"Brave"},{"id":"d","text":"Intrépide"}]',
 'a', '🔑 Le contraire de courageux est lâche (qui manque de courage).', 5);

-- Chapter 3: Vocabulaire - Exercise e8 (Synonymes et antonymes)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000008',
 '📖 Quel est le synonyme soutenu de « manger » ?',
 '[{"id":"a","text":"Se restaurer"},{"id":"b","text":"Bouffer"},{"id":"c","text":"Grignoter"},{"id":"d","text":"Croquer"}]',
 'a', '🔑 Familier: bouffer / Courant: manger / Soutenu: se restaurer.', 1),
('e2000000-0000-0000-0000-000000000008',
 '📖 Quel préfixe forme l''antonyme de « possible » ?',
 '[{"id":"a","text":"im-"},{"id":"b","text":"dé-"},{"id":"c","text":"pré-"},{"id":"d","text":"re-"}]',
 'a', '🔑 Possible → impossible. Le préfixe « im- » (devant p, b, m) indique le contraire.', 2),
('e2000000-0000-0000-0000-000000000008',
 '📖 Quel mot appartient à la famille de « terre » ?',
 '[{"id":"a","text":"Atterrir"},{"id":"b","text":"Terrible"},{"id":"c","text":"Terreur"},{"id":"d","text":"Terrier"}]',
 'a', '🔑 Atterrir (se poser sur la terre) partage le radical « terr- » = sol.', 3),
('e2000000-0000-0000-0000-000000000008',
 '📖 « Cet homme est un lion. » Cette figure de style est :',
 '[{"id":"a","text":"Une métaphore"},{"id":"b","text":"Une comparaison"},{"id":"c","text":"Une personnification"},{"id":"d","text":"Une hyperbole"}]',
 'a', '🔑 Pas d''outil de comparaison (comme, tel) → métaphore directe.', 4),
('e2000000-0000-0000-0000-000000000008',
 '📖 « Il nous a quittés » est un exemple de :',
 '[{"id":"a","text":"Euphémisme"},{"id":"b","text":"Hyperbole"},{"id":"c","text":"Antithèse"},{"id":"d","text":"Anaphore"}]',
 'a', '🔑 Dire « il nous a quittés » au lieu de « il est mort » → atténuation = euphémisme.', 5);

-- Chapter 3: Vocabulaire - Boss Exercise e12
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000012',
 '💀 Boss : « Paris ! Paris outragé ! Paris brisé ! » — figure de style ?',
 '[{"id":"a","text":"Anaphore"},{"id":"b","text":"Métaphore"},{"id":"c","text":"Euphémisme"},{"id":"d","text":"Comparaison"}]',
 'a', '☠️ Répétition de « Paris » en début de phrase → anaphore.', 1),
('e2000000-0000-0000-0000-000000000012',
 '💀 Boss : Quel suffixe transforme l''adjectif « beau » en nom ?',
 '[{"id":"a","text":"-té (beauté)"},{"id":"b","text":"-ment (beaument)"},{"id":"c","text":"-eur (beaueur)"},{"id":"d","text":"-tion (beaution)"}]',
 'a', '☠️ Beau → beauté. Le suffixe « -té » forme des noms à partir d''adjectifs.', 2),
('e2000000-0000-0000-0000-000000000012',
 '💀 Boss : « Je meurs de faim » est une :',
 '[{"id":"a","text":"Hyperbole"},{"id":"b","text":"Litote"},{"id":"c","text":"Métaphore"},{"id":"d","text":"Personnification"}]',
 'a', '☠️ Exagération volontaire pour amplifier l''idée → hyperbole.', 3),
('e2000000-0000-0000-0000-000000000012',
 '💀 Boss : Le mot « insupportable » est formé par :',
 '[{"id":"a","text":"préfixe in- + radical support + suffixe -able"},{"id":"b","text":"radical insupport + suffixe -able"},{"id":"c","text":"préfixe in- + radical supportable"},{"id":"d","text":"radical in + suffixe -supportable"}]',
 'a', '☠️ in- (préfixe négatif) + support (radical) + -able (suffixe) = insupportable.', 4),
('e2000000-0000-0000-0000-000000000012',
 '💀 Boss : Identifiez le registre soutenu :',
 '[{"id":"a","text":"Auriez-vous l''obligeance de m''indiquer le chemin ?"},{"id":"b","text":"Tu peux me dire où c''est ?"},{"id":"c","text":"Pouvez-vous m''indiquer le chemin ?"},{"id":"d","text":"Hé, c''est où ?"}]',
 'a', '☠️ « Auriez-vous l''obligeance » = conditionnel de politesse + vocabulaire recherché → soutenu.', 5);

-- Chapter 4: Compréhension - Exercise e9 (Texte narratif)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000009',
 '📖 Dans un schéma narratif, l''« élément perturbateur » c''est :',
 '[{"id":"a","text":"L''événement qui bouleverse la situation initiale"},{"id":"b","text":"La fin de l''histoire"},{"id":"c","text":"La description du décor"},{"id":"d","text":"La présentation des personnages"}]',
 'a', '🔑 L''élément perturbateur déclenche l''action en rompant l''équilibre initial.', 1),
('e2000000-0000-0000-0000-000000000009',
 '📖 Un texte narratif au passé utilise principalement :',
 '[{"id":"a","text":"Le passé simple et l''imparfait"},{"id":"b","text":"Le présent et le futur"},{"id":"c","text":"Le conditionnel et le subjonctif"},{"id":"d","text":"Le passé composé et le futur antérieur"}]',
 'a', '🔑 Passé simple = actions ponctuelles / Imparfait = descriptions et habitudes.', 2),
('e2000000-0000-0000-0000-000000000009',
 '📖 Un narrateur qui dit « je » dans le récit utilise le point de vue :',
 '[{"id":"a","text":"Interne"},{"id":"b","text":"Externe"},{"id":"c","text":"Omniscient"},{"id":"d","text":"Objectif"}]',
 'a', '🔑 Le narrateur-personnage (je) = point de vue interne (vision limitée).', 3),
('e2000000-0000-0000-0000-000000000009',
 '📖 « Soudain, un bruit retentit. » Ce mot indique :',
 '[{"id":"a","text":"Une rupture temporelle (événement brusque)"},{"id":"b","text":"Une description"},{"id":"c","text":"Un retour en arrière"},{"id":"d","text":"La fin du récit"}]',
 'a', '🔑 « Soudain » est un indicateur de rupture qui marque un événement inattendu.', 4),
('e2000000-0000-0000-0000-000000000009',
 '📖 La « situation finale » d''un récit c''est :',
 '[{"id":"a","text":"Le nouvel équilibre après la résolution"},{"id":"b","text":"Le début de l''histoire"},{"id":"c","text":"Le moment le plus intense"},{"id":"d","text":"La présentation du héros"}]',
 'a', '🔑 La situation finale montre l''état des choses après que le problème est résolu.', 5);

-- Chapter 4: Compréhension - Exercise e10 (Texte argumentatif)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000010',
 '📖 L''objectif d''un texte argumentatif est de :',
 '[{"id":"a","text":"Convaincre le lecteur d''une opinion"},{"id":"b","text":"Raconter une histoire"},{"id":"c","text":"Décrire un paysage"},{"id":"d","text":"Donner des instructions"}]',
 'a', '🔑 Le texte argumentatif cherche à persuader/convaincre en présentant des arguments.', 1),
('e2000000-0000-0000-0000-000000000010',
 '📖 « En effet » est un connecteur qui exprime :',
 '[{"id":"a","text":"La cause / l''explication"},{"id":"b","text":"L''opposition"},{"id":"c","text":"La conséquence"},{"id":"d","text":"La conclusion"}]',
 'a', '🔑 « En effet » sert à expliquer ou justifier ce qui vient d''être dit.', 2),
('e2000000-0000-0000-0000-000000000010',
 '📖 « La lecture développe l''esprit. Par exemple, les études montrent que... » — « Par exemple » introduit :',
 '[{"id":"a","text":"Un exemple qui illustre l''argument"},{"id":"b","text":"Une opposition"},{"id":"c","text":"Une nouvelle thèse"},{"id":"d","text":"Une conclusion"}]',
 'a', '🔑 « Par exemple » introduit une illustration concrète qui soutient l''argument.', 3),
('e2000000-0000-0000-0000-000000000010',
 '📖 « Cependant » et « toutefois » expriment :',
 '[{"id":"a","text":"L''opposition / la concession"},{"id":"b","text":"La cause"},{"id":"c","text":"L''addition"},{"id":"d","text":"Le temps"}]',
 'a', '🔑 Ce sont des connecteurs d''opposition qui introduisent une nuance ou un contre-argument.', 4),
('e2000000-0000-0000-0000-000000000010',
 '📖 Dans un essai argumentatif, la conclusion doit :',
 '[{"id":"a","text":"Résumer les arguments et réaffirmer la thèse"},{"id":"b","text":"Introduire de nouveaux arguments"},{"id":"c","text":"Raconter une anecdote"},{"id":"d","text":"Poser uniquement des questions"}]',
 'a', '🔑 La conclusion synthétise le raisonnement et peut ouvrir sur une réflexion plus large.', 5);

-- Chapter 4: Compréhension - Boss Exercise e13
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000013',
 '💀 Boss : La tonalité « lyrique » d''un texte se reconnaît par :',
 '[{"id":"a","text":"L''expression des sentiments personnels (je, exclamations)"},{"id":"b","text":"Le comique et les jeux de mots"},{"id":"c","text":"La violence et la mort"},{"id":"d","text":"Les instructions et les ordres"}]',
 'a', '☠️ Registre lyrique = expression des émotions, « je », nature, musicalité.', 1),
('e2000000-0000-0000-0000-000000000013',
 '💀 Boss : Un texte qui utilise l''ironie pour critiquer a une tonalité :',
 '[{"id":"a","text":"Satirique"},{"id":"b","text":"Pathétique"},{"id":"c","text":"Tragique"},{"id":"d","text":"Épique"}]',
 'a', '☠️ La satire utilise l''ironie et la moquerie pour dénoncer des défauts.', 2),
('e2000000-0000-0000-0000-000000000013',
 '💀 Boss : L''argument « d''autorité » consiste à :',
 '[{"id":"a","text":"Citer un expert ou une source reconnue"},{"id":"b","text":"Raconter son expérience personnelle"},{"id":"c","text":"Donner un exemple concret"},{"id":"d","text":"Faire un raisonnement logique"}]',
 'a', '☠️ L''argument d''autorité s''appuie sur la crédibilité d''un spécialiste ou d''une institution.', 3),
('e2000000-0000-0000-0000-000000000013',
 '💀 Boss : Un narrateur « omniscient » :',
 '[{"id":"a","text":"Connaît les pensées de tous les personnages"},{"id":"b","text":"Ne sait rien des personnages"},{"id":"c","text":"Est un personnage du récit"},{"id":"d","text":"Décrit uniquement les actions visibles"}]',
 'a', '☠️ Omniscient = « qui sait tout ». Il accède aux pensées, sentiments, passé de chacun.', 4),
('e2000000-0000-0000-0000-000000000013',
 '💀 Boss : « Il faisait nuit ; le vent hurlait ; la pluie battait les vitres. » — le temps verbal dominant indique :',
 '[{"id":"a","text":"Une description (imparfait)"},{"id":"b","text":"Une action ponctuelle (passé simple)"},{"id":"c","text":"Un futur prévu"},{"id":"d","text":"Une habitude présente"}]',
 'a', '☠️ L''imparfait est le temps de la description et du cadre dans un récit.', 5);

-- Chapter 5: Production écrite - Exercise e11 (Rédiger un paragraphe argumentatif)
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000011',
 '📖 Un bon paragraphe argumentatif commence par :',
 '[{"id":"a","text":"Une phrase qui annonce l''idée principale"},{"id":"b","text":"Un exemple"},{"id":"c","text":"La conclusion"},{"id":"d","text":"Une question rhétorique obligatoire"}]',
 'a', '🔑 Structure : idée principale → argument → exemple → conclusion partielle.', 1),
('e2000000-0000-0000-0000-000000000011',
 '📖 Quel connecteur introduit une conséquence ?',
 '[{"id":"a","text":"C''est pourquoi"},{"id":"b","text":"En effet"},{"id":"c","text":"De plus"},{"id":"d","text":"Bien que"}]',
 'a', '🔑 « C''est pourquoi » introduit la conséquence logique de ce qui précède.', 2),
('e2000000-0000-0000-0000-000000000011',
 '📖 Dans une lettre formelle, quelle formule de politesse est correcte ?',
 '[{"id":"a","text":"Veuillez agréer, Monsieur, l''expression de mes salutations distinguées."},{"id":"b","text":"À bientôt !"},{"id":"c","text":"Cordialement,"},{"id":"d","text":"Bisous."}]',
 'a', '🔑 Formule complète et soutenue requise dans une lettre formelle officielle.', 3),
('e2000000-0000-0000-0000-000000000011',
 '📖 Pour enrichir un texte descriptif, on utilise :',
 '[{"id":"a","text":"Des adjectifs, comparaisons et vocabulaire sensoriel"},{"id":"b","text":"Uniquement des verbes d''action"},{"id":"c","text":"Des chiffres et statistiques"},{"id":"d","text":"Des connecteurs logiques uniquement"}]',
 'a', '🔑 La description fait appel aux sens : vue, ouïe, odorat, toucher, goût.', 4),
('e2000000-0000-0000-0000-000000000011',
 '📖 L''introduction d''un essai doit contenir :',
 '[{"id":"a","text":"Accroche + présentation du sujet + annonce du plan"},{"id":"b","text":"Uniquement la thèse"},{"id":"c","text":"Les exemples et arguments"},{"id":"d","text":"La conclusion anticipée"}]',
 'a', '🔑 Introduction = accroche (attirer l''attention) + sujet + plan (ce qu''on va développer).', 5);

-- Chapter 5: Production écrite - Boss Exercise e14
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000014',
 '💀 Boss : Quelle erreur est la plus grave dans une production écrite ?',
 '[{"id":"a","text":"Le hors-sujet"},{"id":"b","text":"Une faute d''accent"},{"id":"c","text":"Un paragraphe court"},{"id":"d","text":"L''absence de titre"}]',
 'a', '☠️ Le hors-sujet est l''erreur la plus pénalisée : on n''a pas répondu à la consigne.', 1),
('e2000000-0000-0000-0000-000000000014',
 '💀 Boss : Dans un récit au passé, les descriptions utilisent :',
 '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le passé simple"},{"id":"c","text":"Le présent"},{"id":"d","text":"Le futur"}]',
 'a', '☠️ Imparfait = descriptions, arrière-plan. Passé simple = actions de premier plan.', 2),
('e2000000-0000-0000-0000-000000000014',
 '💀 Boss : « D''une part... D''autre part... » sert à :',
 '[{"id":"a","text":"Structurer deux arguments complémentaires"},{"id":"b","text":"Opposer deux idées"},{"id":"c","text":"Conclure un texte"},{"id":"d","text":"Donner un exemple"}]',
 'a', '☠️ Ces connecteurs organisent une énumération d''arguments dans un plan.', 3),
('e2000000-0000-0000-0000-000000000014',
 '💀 Boss : Pour éviter les répétitions dans un texte, on utilise :',
 '[{"id":"a","text":"Des synonymes, pronoms et périphrases"},{"id":"b","text":"Uniquement des pronoms"},{"id":"c","text":"On supprime les phrases"},{"id":"d","text":"On répète volontairement"}]',
 'a', '☠️ Variété = synonymes + pronoms + GN substituts + périphrases.', 4),
('e2000000-0000-0000-0000-000000000014',
 '💀 Boss : La « concession » dans un essai, c''est :',
 '[{"id":"a","text":"Reconnaître un argument adverse avant de le réfuter"},{"id":"b","text":"Abandonner sa thèse"},{"id":"c","text":"Répéter sa thèse"},{"id":"d","text":"Ignorer l''opposition"}]',
 'a', '☠️ Concéder puis réfuter montre la maturité du raisonnement : « Certes... mais... »', 5);
