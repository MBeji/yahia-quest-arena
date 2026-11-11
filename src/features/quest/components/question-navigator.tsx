/**
 * Navigateur de questions — accès de TEST (compte admin, 2026-09-05).
 *
 * Le lecteur avance question par question : choisir → valider → suivante, et
 * rien ne permet de revenir ni de sauter. C'est le bon contrat pour un élève ;
 * c'est un obstacle pour qui vérifie le contenu — relire la question 7 d'une
 * mission ne devrait pas coûter six réponses. Ce composant n'apparaît que pour
 * le compte de test (`getExercise().unrestricted`) : une pastille par question,
 * la courante marquée, celles déjà répondues cochées, et un clic saute où l'on
 * veut. Purement présentationnel : le lecteur possède l'état et fournit `onJump`.
 */
export function QuestionNavigator({
  questionIds,
  currentIndex,
  answers,
  label,
  questionLabel,
  onJump,
}: {
  questionIds: readonly string[];
  currentIndex: number;
  /** Les réponses déjà données — une pastille cochée par question répondue. */
  answers: ReadonlyArray<{ questionId: string }>;
  /** Intitulé du bloc (i18n) — dit POURQUOI ces pastilles existent. */
  label: string;
  /** `Question {n}` (i18n) — libellé accessible de chaque pastille. */
  questionLabel: string;
  onJump: (index: number) => void;
}) {
  const answeredIds = new Set(answers.map((a) => a.questionId));
  return (
    <nav
      aria-label={label}
      data-testid="question-navigator"
      className="mb-4 rounded-xl border border-dashed border-(--gold)/40 bg-(--gold)/5 px-3 py-2"
    >
      <p className="mb-1.5 text-2xs font-bold uppercase tracking-wider text-(--gold)">🧪 {label}</p>
      <ol className="flex flex-wrap gap-1.5">
        {questionIds.map((id, i) => {
          const current = i === currentIndex;
          const answered = answeredIds.has(id);
          return (
            <li key={id}>
              <button
                type="button"
                aria-label={questionLabel.replace("{n}", String(i + 1))}
                aria-current={current ? "step" : undefined}
                data-testid={`question-nav-${i + 1}`}
                disabled={current}
                onClick={() => onJump(i)}
                className={`min-h-8 min-w-8 rounded-lg border px-2 text-xs font-bold transition [@media(pointer:coarse)]:min-h-11 [@media(pointer:coarse)]:min-w-11 ${
                  current
                    ? "border-(--gold) bg-(--gold) text-primary-foreground"
                    : answered
                      ? "border-success/40 bg-success/12 text-success hover:bg-success/20"
                      : "border-border bg-surface-2 text-foreground hover:bg-surface-3"
                }`}
              >
                {i + 1}
                {answered ? " ✓" : ""}
              </button>
            </li>
          );
        })}
      </ol>
    </nav>
  );
}
