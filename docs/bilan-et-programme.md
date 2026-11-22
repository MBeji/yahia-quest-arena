# Bilan et programme du jour

> Commande du propriétaire du 2026-11-22 : « un rapport détaillé [de] son avancement, ce qu'il ne
> maîtrise pas encore, son niveau pour chaque matière, une recommandation de programme journalier
> (minimum 30 minutes par jour) sachant que nous sommes encore au premier trimestre ; de son côté,
> dès la connexion, il doit avoir le même rapport ; il peut cocher les chapitres déjà faits en
> classe ». Pour tous les élèves et tous les parents liés.

## Ce que l'élève et son parent voient

| Surface                           | Qui                    | Quoi                                                                            |
| --------------------------------- | ---------------------- | ------------------------------------------------------------------------------- |
| Tableau de bord, zone du jour     | l'élève                | la carte « Programme du jour » ; la bande focus en promeut la première étape    |
| `/bilan`                          | l'élève                | le bilan complet, et les cases « chapitres vus en classe »                      |
| `/parent-report`, sous le verdict | le parent lié, l'admin | **le même composant**, nourri par la même lecture ; le parent peut cocher aussi |

Le bilan dit, par matière : le **niveau** (réussite des 90 derniers jours), où en est l'élève sur
les chapitres **vus en classe**, ce qui reste **à travailler**, la dernière épreuve blanche sur 20.
Le programme dit : l'objectif (30 minutes **mesurées**), ce qui a été fait aujourd'hui, ce qui
reste à faire.

## Les règles, et où elles vivent

Tout est tranché en base (`supabase/migrations/20261122160000_study_report.sql`) ; le TypeScript
présente. Une règle n'existe qu'à un endroit.

| Règle                       | Où                                | Valeur                                                                                                                                                                                            |
| --------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Vu en classe                | `student_study_chapters`          | ce que l'élève ou son parent a coché (`student_class_chapters`) ; **sans déclaration pour la matière**, les premiers chapitres du programme à hauteur de la part de l'année écoulée (au moins un) |
| Année scolaire              | `school_year_share`               | du 15 septembre au 31 mai ; ensuite 1. Mêmes bornes que `placement-scope.ts` (un test les confronte)                                                                                              |
| Niveau d'une matière        | `study_level`                     | moins de 3 missions classiques sur 90 jours : non évalué ; puis < 60 à renforcer, < 80 en progrès, sinon solide                                                                                   |
| État d'un chapitre          | `student_study_chapters`          | étoile 4 : maîtrisé ; jamais ouvert : non commencé ; étoile ≥ 1 : acquis ; une mission ratée : fragile ; sinon en cours                                                                           |
| Mission comptée, étoile     | `mission_is_counted`, grand livre | inchangé — `docs/etoiles-et-sceaux.md`. Rien n'est recopié                                                                                                                                        |
| Durée estimée d'une mission | `study_exercise_minutes`          | 35 s par question (60 s en difficulté 4), 3 minutes au moins — le troisième quartile mesuré en production                                                                                         |
| Objectif quotidien          | `study_daily_target_minutes`      | 30 minutes                                                                                                                                                                                        |
| Temps fait                  | `get_study_report`                | `learning_pulses` du jour (Africa/Tunis), hors navigation — la mesure du suivi quotidien                                                                                                          |

## Comment le programme se compose

`student_study_plan` — **déduit à chaque lecture, jamais stocké** :

1. **Les candidates** : dans les chapitres vus qui n'ont pas leur prochaine étoile, le quiz s'il
   reste dû, puis les missions de difficulté ≤ prochaine étoile qui ne comptent pas encore. Une
   mission jouée aujourd'hui n'y revient pas le jour même.
2. **Dans une matière** : les reprises d'abord, puis les chapitres commencés (le plus proche de
   son étoile en tête), puis les chapitres vus jamais ouverts, dans l'ordre du programme. Deux
   missions au plus par chapitre, trois par matière.
3. **Entre matières** : celle qui n'a pas été travaillée aujourd'hui, puis la plus délaissée, puis
   la moins couverte. Les trois premières alternent.
4. **Jusqu'au budget** : l'objectif moins le temps déjà mesuré. Trente minutes sont donc trente
   minutes réellement passées : qui expédie ses missions en voit arriver d'autres ; l'objectif
   atteint, le programme se tait.

Le programme ne décide d'aucun accès : la porte reste `resolve_exercise_access`, au moment de jouer.

## Avec « la prochaine action »

`resolveNextAction` gagne un rang, `plan`, **derrière** la révision due et la remédiation,
**devant** la reprise et le chemin : ces deux derniers ignorent la classe de l'élève. Le tableau de
bord lit le bilan une fois (`getDashboard`), pour la carte et pour la bande — elles ne désignent
jamais deux cibles (étude 22, D-8). Le hub matière ne fournit pas ce rang et se comporte comme avant.

## Coût

La lecture part dans la première vague du tableau de bord, à chaque connexion. Mesurée en
production le 2026-11-22 sur un élève de 9ᵉ (98 chapitres, 896 missions) : ~205 ms à chaud avec
la première écriture. La migration `20261122170000_study_report_single_pass.sql` calcule les
chapitres **une fois** par lecture (le bilan et le programme les partagent) et matérialise les
étages de `student_study_chapters`, dont les fonctions de quiz étaient réévaluées à chaque
lecture de leur colonne. Le poste dominant reste `chapter_quiz_cleared` (un appel par chapitre).

## Accès

- `get_study_report(p_student, p_with_chapters)` : soi, son enfant (lien actif), ou l'admin.
- `set_class_chapters(p_subject_id, p_chapter_ids, p_student)` : soi, ou son enfant. La liste
  **remplace** la déclaration de la matière ; vide, elle la rend à l'estimation du calendrier.
- `student_class_chapters` : lecture par RLS (propriétaire, admin, parent lié), aucune écriture
  directe. Les fonctions internes sont révoquées d'`authenticated`.
- Le chemin public au code alliance (`/suivi`) ne sert pas ce bilan.

Tests : `supabase/tests/116_study_report.test.sql` ; `src/shared/lib/__tests__/study-report.test.ts` ;
`src/components/__tests__/study-report*.test.tsx`.

## Ce qui n'est pas fait

- L'objectif est fixe (30 minutes) : ni l'élève ni le parent ne le règlent.
- Aucune matière « prioritaire » ne se choisit : l'alternance sert d'elle-même les matières délaissées.
- Les épreuves blanches ne sont pas proposées par le programme (elles couvrent toute l'année) ;
  leur dernière note figure au bilan.
