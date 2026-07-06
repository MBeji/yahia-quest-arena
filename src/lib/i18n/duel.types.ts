/**
 * Duel (étude 05) translation keys — split into its own file so the large
 * `TranslationKeys` dictionary in types.ts stays under the max-lines cap.
 * Referenced there as `duel: DuelTranslations`.
 */
export interface DuelTranslations {
  title: string;
  subtitle: string;
  findOpponent: string;
  searching: string;
  cancel: string;
  activeDuels: string;
  history: string;
  noHistory: string;
  play: string;
  resume: string;
  opponent: string;
  statusActive: string;
  statusFinished: string;
  statusExpired: string;
  statusPending: string;
  questionOf: string;
  validate: string;
  tooFast: string;
  waitingOpponent: string;
  opponentAnswered: string;
  opponentDone: string;
  resultWin: string;
  resultLoss: string;
  resultDraw: string;
  resultPending: string;
  finalScore: string;
  reviewTitle: string;
  correctAnswer: string;
  backToHub: string;
  loading: string;
  notFound: string;
  emptyHubHint: string;
}
