/**
 * Duel (étude 05) translation keys — split into its own file so the large
 * `TranslationKeys` dictionary in types.ts stays under the max-lines cap.
 * Referenced there as `duel: DuelTranslations`.
 */
export interface DuelTranslations {
  title: string;
  subtitle: string;
  errorSearch: string;
  findOpponent: string;
  searching: string;
  cancel: string;
  activeDuels: string;
  history: string;
  noHistory: string;
  // Pre-match narration (étude 15 lot 11, D-7) — the rule + reward tiers before the click.
  rulesFirstDone: string;
  rewardWin: string;
  rewardDraw: string;
  rewardLoss: string;
  rewardsHint: string;
  play: string;
  resume: string;
  forfeit: string;
  forfeitDone: string;
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
  online: string;
  offline: string;
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
  leagueTitle: string;
  leagueSubtitle: string;
  leagueEmpty: string;
  leaguePts: string;
  lastAward: string;
  tierDiamond: string;
  tierPlatinum: string;
  tierGold: string;
  tierSilver: string;
  tierBronze: string;
}
