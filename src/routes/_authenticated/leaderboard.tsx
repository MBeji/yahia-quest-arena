import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, useReducedMotion } from "motion/react";
import { useState } from "react";
import { Crown, Flame, Medal, Zap } from "lucide-react";
import { BackLink } from "@/components/ui/back-link";
import { PageShell } from "@/components/ui/page-shell";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import {
  getLeaderboard,
  getGradeLeaderboard,
  getLeaderboardSubjects,
  getSubjectLeaderboard,
} from "@/features/dashboard";
import { GRADE_TAB_DEFAULT_MIN_RANKED } from "@/shared/constants/gamification";
import { isRtlText } from "@/shared/lib/utils";
import { entrance } from "@/shared/lib/motion";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/leaderboard")({
  head: () => ({ meta: [{ title: "Classement · Na9ra Nal3ab" }] }),
  component: LeaderboardPage,
});

const GLOBAL = "global";
/** Onglet cohorte de classe (étude 22, R-23). */
const MY_CLASS = "my-class";

// SECURITY: rows carry no peer `user_id` (UUID-leak fix). They are keyed by
// `rank` (unique per board) and the self row is flagged by `isMe` server-side.
type Player = {
  rank: number;
  displayName: string;
  heroClass: string;
  level: number;
  xp: number;
  streak: number;
  avatarTier: number;
  isMe: boolean;
};

function LeaderboardPage() {
  const t = useT();
  const reduced = useReducedMotion();
  const fetchLeaderboard = useServerFn(getLeaderboard);
  const fetchGradeLeaderboard = useServerFn(getGradeLeaderboard);
  const fetchSubjects = useServerFn(getLeaderboardSubjects);
  const fetchSubjectLeaderboard = useServerFn(getSubjectLeaderboard);

  const [tab, setTab] = useState<string | null>(null);

  // Tabs are scoped to the ACTIVE parcours' subjects (GAP-018) — not the whole
  // academy catalogue — so the row stays short and homonym subjects across grades
  // ("Mathématiques" 9ème vs 6ème) can't collide.
  const subjectsQuery = useQuery({
    queryKey: ["leaderboard-subjects"],
    queryFn: () => fetchSubjects(),
  });
  const globalQuery = useQuery({
    queryKey: ["leaderboard", GLOBAL],
    queryFn: () => fetchLeaderboard(),
  });
  const gradeQuery = useQuery({
    queryKey: ["leaderboard", MY_CLASS],
    queryFn: () => fetchGradeLeaderboard(),
  });

  // R-23 : la cohorte de classe n'existe que pour un élève rattaché à un grade. Un parcours
  // libre n'en a pas — on masque l'onglet plutôt que de proposer un classement vide.
  const hasCohort = gradeQuery.data?.hasCohort === true;
  const rankedCount = gradeQuery.data?.rankedCount ?? 0;

  // Onglet par défaut (R-23, Q-1 arbitrée) : « Ma classe » dès que la cohorte compte assez de
  // classés pour qu'un rang veuille dire quelque chose, « Global » sinon. Bascule silencieuse
  // — jamais un réglage à faire, ni un message à lire. Tant que la requête n'a pas répondu,
  // `tab` reste null et l'écran n'affiche pas un onglet qu'il devrait changer juste après.
  const defaultTab = hasCohort && rankedCount >= GRADE_TAB_DEFAULT_MIN_RANKED ? MY_CLASS : GLOBAL;
  const activeTab = tab ?? (gradeQuery.isLoading ? null : defaultTab);

  const isGlobal = activeTab === GLOBAL;
  const isMyClass = activeTab === MY_CLASS;
  const isSubjectTab = activeTab !== null && !isGlobal && !isMyClass;

  const subjectQuery = useQuery({
    queryKey: ["leaderboard", "subject", activeTab],
    queryFn: () => fetchSubjectLeaderboard({ data: { subjectId: activeTab as string } }),
    enabled: isSubjectTab,
  });

  const subjects = subjectsQuery.data?.subjects ?? [];
  const activeSubject = subjects.find((s) => s.id === activeTab) ?? null;

  const data = isGlobal ? globalQuery.data : isMyClass ? gradeQuery.data : subjectQuery.data;
  const isLoading =
    activeTab === null ||
    (isGlobal ? globalQuery.isLoading : isMyClass ? gradeQuery.isLoading : subjectQuery.isLoading);

  const leaderboard = (data?.leaderboard ?? []) as Player[];
  const myRank = (data?.myRank ?? null) as Player | null;

  return (
    <PageShell>
      <BackLink to="/dashboard">{t.common.backToHall}</BackLink>

      <div className="mb-6 text-center">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">
          <span className="text-gradient-gold">{t.leaderboard.titleGradient}</span>{" "}
          {t.leaderboard.titleRest}
        </h1>
        <p className="mt-2 text-muted-foreground">
          {isGlobal
            ? t.leaderboard.subtitleGlobal
            : isMyClass
              ? t.leaderboard.subtitleMyClass
              : t.leaderboard.subtitleSubject.replace("{subject}", activeSubject?.name_fr ?? "")}
        </p>
      </div>

      {/* Tabs: Global + one per subject */}
      <div className="mb-6 flex flex-wrap justify-center gap-2">
        <button
          onClick={() => setTab(GLOBAL)}
          data-testid="leaderboard-global-tab"
          className={`inline-flex min-h-11 items-center rounded-full border px-4 py-1.5 text-sm font-semibold transition ${
            isGlobal
              ? "border-gold/60 bg-gold/15 text-gold"
              : "border-border/50 bg-black/40 text-muted-foreground hover:text-foreground"
          }`}
        >
          {t.leaderboard.globalTab}
        </button>
        {hasCohort && (
          <button
            onClick={() => setTab(MY_CLASS)}
            data-testid="leaderboard-my-class-tab"
            className={`inline-flex min-h-11 items-center rounded-full border px-4 py-1.5 text-sm font-semibold transition ${
              isMyClass
                ? "border-gold/60 bg-gold/15 text-gold"
                : "border-border/50 bg-black/40 text-muted-foreground hover:text-foreground"
            }`}
          >
            {t.leaderboard.myClassTab}
          </button>
        )}
        {subjects.map((s) => {
          const active = s.id === activeTab;
          return (
            <button
              key={s.id}
              data-testid="leaderboard-subject-tab"
              onClick={() => setTab(s.id)}
              dir={isRtlText(s.name_fr) ? "rtl" : undefined}
              className={`inline-flex min-h-11 items-center rounded-full border px-4 py-1.5 text-sm font-semibold transition ${
                active
                  ? "border-gold/60 bg-gold/15 text-gold"
                  : "border-border/50 bg-black/40 text-muted-foreground hover:text-foreground"
              }`}
            >
              {s.name_fr}
            </button>
          );
        })}
      </div>

      {isLoading ? (
        <LoadingState label={t.leaderboard.loading} className="min-h-[30dvh]" />
      ) : (
        <>
          {/* My rank card */}
          {myRank && (
            <motion.div
              {...entrance(reduced)}
              className="mb-6 rounded-2xl border border-gold/40 bg-black/60 p-5 backdrop-blur-xl shadow-gold"
            >
              <div className="flex items-center justify-between gap-3">
                <div className="flex min-w-0 items-center gap-4">
                  <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[image:var(--gradient-gold)] font-display text-xl font-bold text-black shadow-gold">
                    #{myRank.rank}
                  </div>
                  <div className="min-w-0">
                    <div className="truncate font-display text-lg font-bold">
                      {myRank.displayName}
                    </div>
                    <div className="truncate text-xs uppercase tracking-widest text-champagne">
                      {myRank.heroClass}
                    </div>
                  </div>
                </div>
                <div className="shrink-0 text-end">
                  <div className="flex items-center gap-1 font-display text-lg font-bold text-neon-gold">
                    <Zap className="h-4 w-4" /> {myRank.xp} XP
                  </div>
                  <div className="text-xs text-muted-foreground">
                    {t.leaderboard.lvl} {myRank.level}
                  </div>
                </div>
              </div>
            </motion.div>
          )}

          {/* Top 3 podium */}
          {leaderboard.length >= 3 && (
            <div className="mb-8 grid grid-cols-3 gap-2 sm:gap-3">
              {[leaderboard[1], leaderboard[0], leaderboard[2]].map((player, i) => {
                const podiumOrder = [2, 1, 3];
                const rank = podiumOrder[i];
                const heights = ["h-28", "h-36", "h-24"];
                // Couleurs de MÉDAILLES fixes (argent/or/bronze) — vocabulaire
                // universel du podium, volontairement hors tokens de thème (l'or du
                // thème clair est teal). Encre sombre fixe, lisible sur les trois.
                const colors = [
                  "from-[oklch(0.86_0.01_260)] to-[oklch(0.7_0.015_260)]",
                  "from-[oklch(0.85_0.14_88)] to-[oklch(0.68_0.13_75)]",
                  "from-[oklch(0.66_0.1_60)] to-[oklch(0.5_0.09_55)]",
                ];
                return (
                  // Keyed by position, not rank: RANK() can tie (equal-XP rows
                  // share a rank), so rank is not a unique key.
                  <motion.div
                    key={`podium-${i}`}
                    {...entrance(reduced, "rise", i * 0.1)}
                    className="flex flex-col items-center"
                  >
                    <div
                      className={`mb-2 grid h-10 w-10 place-items-center rounded-full bg-gradient-to-br ${colors[i]} text-sm font-bold text-[oklch(0.2_0.02_60)] shadow-lg`}
                    >
                      {rank === 1 ? <Crown className="h-5 w-5" /> : <Medal className="h-4 w-4" />}
                    </div>
                    <div className="text-center">
                      <div className="text-sm font-bold truncate max-w-[100px]">
                        {player.displayName}
                      </div>
                      <div className="text-xs text-muted-foreground">
                        {t.leaderboard.lvl} {player.level}
                      </div>
                    </div>
                    <div
                      className={`mt-2 w-full ${heights[i]} rounded-t-xl bg-gradient-to-t ${colors[i]} opacity-30`}
                    />
                    <div className="mt-1 text-xs font-bold text-neon-gold">{player.xp} XP</div>
                  </motion.div>
                );
              })}
            </div>
          )}

          {/* Full ranking */}
          <div className="space-y-2">
            {leaderboard.map((player, i) => (
              // Keyed by position, not rank: RANK() can tie, so rank is not unique.
              <motion.div
                key={`row-${i}`}
                data-testid="leaderboard-row"
                // "rise" preset (not the old physical x-slide, which read backwards
                // in RTL). Stagger capped so a long board doesn't cascade for
                // seconds; rows past the first screenful share the same delay.
                {...entrance(reduced, "rise", Math.min(i, 12) * 0.02)}
                className={`list-row-cv flex items-center gap-4 rounded-xl border p-4 transition ${
                  player.isMe
                    ? "border-gold/50 bg-gold/10"
                    : "border-border/50 bg-black/40 hover:bg-black/60"
                }`}
              >
                <div
                  className={`grid h-9 w-9 place-items-center rounded-lg text-sm font-bold ${
                    player.rank <= 3
                      ? "bg-gradient-to-br from-neon-gold to-gold-deep text-primary-foreground"
                      : "bg-secondary text-muted-foreground"
                  }`}
                >
                  {player.rank}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold truncate">{player.displayName}</span>
                    {/* Opaque card-surface chip (not a translucent gold tint) so the
                        label always meets contrast — the "Toi" pill sits on the gold/10
                        highlighted row, where a gold-on-gold tint dropped to 3.7:1 and
                        failed WCAG AA. Mirrors the GAP-047 premium-lock badge pattern:
                        readable in all 3 themes (gold is dark teal under Référence). */}
                    {player.isMe && (
                      <span className="rounded-full border border-gold/50 bg-card px-2 py-0.5 text-2xs font-bold uppercase tracking-wider text-foreground shadow-sm">
                        {t.leaderboard.youChip}
                      </span>
                    )}
                  </div>
                  <div className="text-xs text-muted-foreground">
                    {player.heroClass} · {t.leaderboard.lvl} {player.level}
                  </div>
                </div>

                <div className="flex items-center gap-3">
                  {player.streak > 0 && (
                    <div className="flex items-center gap-1 text-sm text-flame">
                      <Flame className="h-3.5 w-3.5 animate-flame" /> {player.streak}
                    </div>
                  )}
                  <div className="font-display text-sm font-bold text-neon-gold">
                    {player.xp} XP
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          {leaderboard.length === 0 && (
            <EmptyState
              icon={Medal}
              className="mt-12"
              title={
                isGlobal
                  ? t.leaderboard.coldStartTitle
                  : isMyClass
                    ? t.leaderboard.myClassEmptyTitle
                    : t.leaderboard.emptySubject
              }
              description={
                isGlobal
                  ? t.leaderboard.coldStartDesc
                  : isMyClass
                    ? t.leaderboard.myClassEmptyDesc
                    : undefined
              }
              action={
                isGlobal || isMyClass ? (
                  <Link
                    to="/dashboard"
                    className="inline-flex min-h-11 items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition hover:opacity-90"
                  >
                    {t.leaderboard.coldStartCta}
                  </Link>
                ) : undefined
              }
            />
          )}
        </>
      )}
    </PageShell>
  );
}
