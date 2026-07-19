# Sources vidéo — allowlist des chaînes

> **Statut : PROPOSÉE, en attente de l'arbitrage Q-1 de Mohamed.**
> Tant que Q-1 n'est pas tranchée, ce fichier est de la **matière première**, pas
> une autorisation. Aucune campagne (lot 5) ne démarre avant.
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

## Questions ouvertes qui conditionnent l'usage

- **Q-1** — validation/amendement de cette allowlist (idéalement en vérifiant la
  disponibilité réelle depuis la Tunisie).
- **Q-2** — acceptation des publicités YouTube (impossibles à couper sur un
  embed ; seule une chaîne YPP monétisation-désactivée les garantit absentes).
- **Q-5** — admissibilité de la **derja** au primaire (recommandation de l'étude :
  oui, c'est la langue réelle d'enseignement oral ; la terminologie officielle en
  فصحى reste portée par le cours écrit). Noter alors
  `notes: "explication en derja"`.
