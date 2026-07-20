# Sources vidéo — allowlist des chaînes

> **Statut : VALIDÉE par Mohamed le 2026-07-19 (arbitrage Q-1), telle que proposée.**
> Les chaînes ci-dessous sont donc autorisées ; la campagne (lot 5) peut démarrer.
>
> Décisions liées, prises le même jour :
>
> - **Q-2 — publicités YouTube : ACCEPTÉES** en phase gratuite. Elles sont
>   impossibles à couper sur un embed ; la mention hébergeur reste visible sur la
>   façade. À notion égale, **préférer quand même une source sans pub**
>   (Khan Academy — ONG, chaîne du ministère).
> - **Q-5 — derja au primaire : ADMISE.** C'est la langue réelle d'enseignement
>   oral en Tunisie et un facteur majeur de compréhension pour les 6-12 ans ; la
>   terminologie officielle en فصحى reste portée par le cours écrit de l'app.
>   Le noter dans la fiche : `notes: "explication en derja"`.
>
> Rappel structurant : **l'allowlist autorise une CHAÎNE, jamais une VIDÉO.**
> Chaque vidéo passe la grille R-2 + un visionnage intégral (R-3), sans exception.
> Source : `FableEtudes/23-videos-explicatives/ETUDE.md`, annexe A (recherche du
> 2026-07-17).

## Allowlist proposée — par cycle × matière × langue

La langue est celle **d'instruction de la matière** (R-8). « Primaires » = sources
principales ; « complément » = seulement quand la principale n'a pas la notion.

| cycle × matière (langue)          | primaires                                                     | complément                                           |
| --------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------- |
| Primaire — عربية/قراءة (ar)       | Saboura                                                       | Sala7li (corrections manuel), chaînes d'instituteurs |
| Primaire — رياضيات (ar)           | Saboura                                                       | Khan ar (notionnel), Sala7li                         |
| Primaire — إيقاظ علمي (ar)        | Saboura                                                       | Devoir.TN (6ᵉ)                                       |
| Concours سيزيام 6ᵉ (ar)           | القناة الوطنية التربوية                                       | Devoir.TN/Tadris                                     |
| Collège 7-9ᵉ — maths (ar)         | Devoir.TN/Tadris · Faouzi El Gharbi                           | TakiAcademy (9ᵉ), Khan ar (notionnel)                |
| Collège 7-9ᵉ — physique/SVT (ar)  | Devoir.TN/Tadris                                              | TakiAcademy (9ᵉ)                                     |
| Concours نوفيام 9ᵉ (ar)           | القناة الوطنية · TakiAcademy                                  | El Gharbi, Sala7li                                   |
| Arabe langue — نحو/صرف (ar)       | Tadris (7-8ᵉ)                                                 | Mekkawi, تبسيط النحو (réserve terminologie)          |
| Lycée — maths (fr)                | Yvan Monka · jaicompris (corrections)                         | MATHEZER (sections TN), Hedacademy, Khan fr          |
| Lycée — physique-chimie (fr)      | Les Bons Profs · Paul Olivier · F. Raffin (bac)               | e-profs, TuniSchool/Lyceena                          |
| Lycée — SVT (fr)                  | Prof SVT71 · Mon Cours de SVT                                 | Les Bons Profs                                       |
| Lycée — info (fr)                 | TuniSchool/Lyceena                                            | —                                                    |
| Bac — philo/hist-géo/éco (ar)     | TakiAcademy · القناة الوطنية (par شعبة)                       | —                                                    |
| Français langue (3ᵉ année → bac)  | Les fondamentaux (si CGU OK) · Les Bons Profs (collège/lycée) | Français avec Pierre, Mediaclasse (méthode bac)      |
| Anglais (école + thème `anglais`) | 3ich English                                                  | à cartographier                                      |
| Culture générale (thème, fr)      | 1 jour 1 question (8-13 ans) · C'est (toujours) pas sorcier   | Kezako (CC)                                          |
| Culture générale (thème, ar/en)   | **trou identifié** — session de cartographie dédiée           | Khan ar (sciences)                                   |

## Notes par source (points de vigilance à la curation)

- **Yvan Monka (Maths et tiques)** — ~1 900 vidéos, 5-15 min, une notion par
  vidéo. LA référence francophone ; programme lycée fr ≈ lycée tunisien.
- **jaicompris Maths** — 1 095+ vidéos classées par chapitre : le format exact
  « exercice corrigé » attendu par l'écran de résultat (`correctionVideo`).
- **Khan Academy (fr/ar)** — **sans pub** (ONG) : à privilégier à notion égale.
  Progression US traduite → **complément notionnel, jamais fil de programme.**
- **Devoir.TN / Tadris.TN** — la seule couverture systématique du collège
  arabophone alignée sur les manuels TN. **Frontière gratuit/payant à vérifier
  vidéo par vidéo.**
- **TakiAcademy** — 100 % programme TN, mais **formats longs (1-2 h)** → toujours
  en extrait (`startSec`/`endSec`), et pubs.
- **القناة الوطنية التربوية** (ministère) — supervision pédagogique officielle,
  **zéro risque de droits** ; captation 2020-21 datée, cours de 30-55 min →
  extraits.
- **Saboura** — le primaire, le cycle le plus mal servi ailleurs.
- **Sala7li / chaînes d'إصلاح الكتاب** — correction du manuel officiel page à
  page, en **derja** (cf. Q-5) ; chaînes modestes → auditer une à une.
- **MATHEZER, TuniSchool/Lyceena** — jargon et découpage des sections TN, mais
  plateformes payantes : **n'intégrer que le catalogue YouTube public.**
- **C'est pas sorcier / Les fondamentaux** — épisodes longs (26 min) → extraits ;
  CGU d'embed Canopé **à lever** avant tout usage en masse.

## Écartées (ne pas y revenir sans nouvelle décision)

| source                      | raison                                                              |
| --------------------------- | ------------------------------------------------------------------- |
| Lumni (plateforme)          | géo-bloquée hors de France + pas d'embed public                     |
| PCCL                        | animations Flash (mort en 2021), distribution .exe                  |
| Nafham, Edraak K-12         | programmes EG/JO… — pas la Tunisie ; dialecte égyptien              |
| InnerFrench                 | B1-B2 adulte, 20-40 min — hors cible 6-19 ans                       |
| Madrasa.org                 | player propriétaire, YouTube partiel — à revisiter si accord        |
| Dailymotion                 | pubs cousues côté serveur depuis 2025 — inacceptable pour un mineur |
| Vimeo Free                  | 1 GB à vie, watermark                                               |
| EduSoutien (ministère)      | pas d'embed (login, player propre) — **piste de partenariat**       |
| Plateformes payantes en soi | seules leurs chaînes YouTube publiques entrent dans le périmètre    |

## Trous assumés (à combler au fil des campagnes)

Culture générale en **ar/en** ; éveil scientifique 1ʳᵉ-5ᵉ hors Saboura ; anglais
scolaire aligné sur les manuels TN. Le thème `muscle-cerveau` **n'a besoin
d'aucune vidéo** (son format est l'exercice).

## Questions tranchées (2026-07-19)

- **Q-1 — allowlist : VALIDÉE** telle que proposée.
- **Q-2 — pubs YouTube : ACCEPTÉES** (voir l'en-tête).
- **Q-5 — derja au primaire : ADMISE** (voir l'en-tête).

## Reste ouvert

- **Q-3 — deux actions ops, à la charge de Mohamed** (prises en charge, échéance
  libre) : (a) auto-désigner l'app **child-directed** auprès de Google
  (obligation développeur, R-14) ; (b) publier le paragraphe « vidéos YouTube
  intégrées » à destination des parents. Le texte prêt à coller est en annexe C
  de l'étude. **Aucune des deux ne bloque la curation**, mais (a) est une
  obligation de conformité de la plateforme : à ne pas laisser filer.
- **Q-4 — phase B** (chaîne YouTube officielle du projet pour des vidéos
  propres) : non tranchée, volontairement — la recommandation de l'étude est
  d'attendre le bilan d'usage `video_open` du pilote.
