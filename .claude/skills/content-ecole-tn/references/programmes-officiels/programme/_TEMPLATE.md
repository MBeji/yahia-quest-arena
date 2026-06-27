<!-- GABARIT — copier vers programme/<niveau>/<matière>.md puis remplir depuis le guide enseignant CNP.
     Transcription FIDÈLE (pas de réinterprétation). Citer les pages. Garder les chiffres latins. -->

# <Matière en arabe/français> — <Niveau> · programme officiel CNP

> **Source** : guide enseignant `<code>P00.pdf` (`cnp-officiel/manuels/<asasi|secondaire>/<cN>/enseignant/`) — « <titre du guide> ».
> **Pages lues** : <p.X–Y (المخطّط السّنوي), p.Z (إطار الكفايات)…>. **Transcrit le** : <AAAA-MM-JJ>. **Statut** : transcription fidèle.
> **Langue d'enseignement** : <ar | fr | en>. **gradeSlug** : `<niveau>`. **subject id** attendu : `<id>`.

## 1. Cadre & compétences (الكفايات / les objectifs généraux)
<Compétence(s) terminale(s) du niveau pour la matière + grandes finalités, transcrites du guide (الكفاية المستهدفة / المعايير).>

## 2. Plan annuel (المخطّط السّنوي)

### مجال / Domaine : <nom>
#### محور / Thème <N> : <nom>
- **Objectifs (الأهداف المميّزة)** : <liste fidèle>
- **Concepts / notions (المفاهيم / المحتوى)** : <liste>
- **Vocabulaire & terminologie officielle** : <termes exacts à employer>
- **Progression / séquençage** : <trimestre/période/ordre indiqué>
- **Exemples types du guide** : <exemples, mots, nombres, textes que le guide utilise — précieux pour générer fidèlement>
- **Bornes de scope** :
  - ✅ INCLUS au niveau : <…>
  - ⛔ EXCLU (relève d'un autre niveau) : <… ex. « la division = 4ème, pas 3ème »>

<!-- répéter par محور, puis par مجال -->

## 3. Notes pédagogiques / méthode
<Démarche recommandée par le guide, savoir-faire attendus, pièges/erreurs fréquentes signalés, types d'activités. Pour les langues : ordre d'introduction des lettres/sons, etc. Pour l'éducation islamique : سور/آيات au programme (texte exact), أذكار, école malikite. Pour les maths/sciences : notations, unités.>

## 4. Chapitrage retenu (→ alimente `manifest/<niveau>.json`)
| # | slug | notion (محور) | manuel élève (code · pages) |
|---|------|---------------|------------------------------|
| 1 | `NN-slug` | <notion> | `<code>` · p.12–15 |

> La dernière colonne alimente le champ `chapter.manuel = { code, pages }` (cf.
> `content-engine/references/content-schema.md`). Repérer, dans le **manuel élève** (pas le guide
> enseignant), les pages qui couvrent chaque chapitre ; `pages` accepte page seule / plage / liste
> (`"12"`, `"12-15"`, `"12-15, 18"`). Laisser vide si le manuel élève n'est pas disponible.

## 5. Sources croisées
- **Manuel élève** : `<code>` — « <titre> » (contenu/exemples officiels + **pages par chapitre**, cf. §4, si dispo).
- **Taybah** (`taybah/<niveau>.md`) : séquençage trimestriel (vérification).
- **Divergences signalées** : <le cas échéant, avec page>.

## 6. Incertitudes / à revérifier
<Zones de lecture difficile (texte pivoté/basse-DPI), choix éditoriaux, points à valider par Mohamed.>
