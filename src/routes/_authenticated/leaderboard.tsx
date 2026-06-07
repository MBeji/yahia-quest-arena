import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { useState } from "react";
import { ArrowLeft, Crown, Flame, Medal, Zap } from "lucide-react";
import { getLeaderboard, getSubjects, getSubjectLeaderboard } from "@/features/dashboard";
import { isRtlText } from "@/shared/lib/utils";

export const Route = createFileRoute("/_authenticated/leaderboard")({
  head: () => ({ meta: [{ title: "Leaderboard · XP Scholars" }] }),
  component: LeaderboardPage,
});

const GLOBAL = "global";

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
  const fetchLeaderboard = useServerFn(getLeaderboard);
  const fetchSubjects = useServerFn(getSubjects);
  const fetchSubjectLeaderboard = useServerFn(getSubjectLeaderboard);

  const [tab, setTab] = useState<string>(GLOBAL);

  const subjectsQuery = useQuery({
    queryKey: ["subjects-list"],
    queryFn: () => fetchSubjects(),
  });
  const globalQuery = useQuery({
    queryKey: ["leaderboard", GLOBAL],
    queryFn: () => fetchLeaderboard(),
  });
  const subjectQuery = useQuery({
    queryKey: ["leaderboard", "subject", tab],
    queryFn: () => fetchSubjectLeaderboard({ data: { subjectId: tab } }),
    enabled: tab !== GLOBAL,
  });

  const subjects = subjectsQuery.data?.subjects ?? [];
  const activeSubject = subjects.find((s) => s.id === tab) ?? null;
  const isGlobal = tab === GLOBAL;

  const data = isGlobal ? globalQuery.data : subjectQuery.data;
  const isLoading = isGlobal ? globalQuery.isLoading : subjectQuery.isLoading;

  const leaderboard = (data?.leaderboard ?? []) as Player[];
  const myRank = (data?.myRank ?? null) as Player | null;

  return (
    <div className="mx-auto max-w-3xl px-6 py-8">
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> Back to hall
      </Link>

      <div className="mb-6 text-center">
        <h1 className="font-display text-4xl font-bold">
          <span className="text-gradient-gold">Academy</span> Leaderboard
        </h1>
        <p className="mt-2 text-muted-foreground">
          {isGlobal
            ? "The most powerful heroes of the exam"
            : `Classement par XP · ${activeSubject?.name_fr ?? ""}`}
        </p>
      </div>

      {/* Tabs: Global + one per subject */}
      <div className="mb-6 flex flex-wrap justify-center gap-2">
        <button
          onClick={() => setTab(GLOBAL)}
          data-testid="leaderboard-global-tab"
          className={`rounded-full border px-4 py-1.5 text-sm font-semibold transition ${
            isGlobal
              ? "border-[color:var(--gold)]/60 bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
              : "border-border/50 bg-black/40 text-muted-foreground hover:text-foreground"
          }`}
        >
          🌍 Global
        </button>
        {subjects.map((s) => {
          const active = s.id === tab;
          return (
            <button
              key={s.id}
              onClick={() => setTab(s.id)}
              dir={isRtlText(s.name_fr) ? "rtl" : undefined}
              className={`rounded-full border px-4 py-1.5 text-sm font-semibold transition ${
                active
                  ? "border-[color:var(--gold)]/60 bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                  : "border-border/50 bg-black/40 text-muted-foreground hover:text-foreground"
              }`}
            >
              {s.name_fr}
            </button>
          );
        })}
      </div>

      {isLoading ? (
        <div className="grid min-h-[30vh] place-items-center text-sm text-muted-foreground">
          Loading leaderboard…
        </div>
      ) : (
        <>
          {/* My rank card */}
          {myRank && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="mb-6 rounded-2xl border border-[color:var(--gold)]/40 bg-black/60 p-5 backdrop-blur-xl shadow-gold"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="grid h-12 w-12 place-items-center rounded-xl bg-[image:var(--gradient-gold)] font-display text-xl font-bold text-black shadow-gold">
                    #{myRank.rank}
                  </div>
                  <div>
                    <div className="font-display text-lg font-bold">{myRank.displayName}</div>
                    <div className="text-xs uppercase tracking-widest text-[color:var(--champagne)]">
                      {myRank.heroClass}
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="flex items-center gap-1 font-display text-lg font-bold text-[color:var(--neon-gold)]">
                    <Zap className="h-4 w-4" /> {myRank.xp} XP
                  </div>
                  <div className="text-xs text-muted-foreground">Lvl {myRank.level}</div>
                </div>
              </div>
            </motion.div>
          )}

          {/* Top 3 podium */}
          {leaderboard.length >= 3 && (
            <div className="mb-8 grid grid-cols-3 gap-3">
              {[leaderboard[1], leaderboard[0], leaderboard[2]].map((player, i) => {
                const podiumOrder = [2, 1, 3];
                const rank = podiumOrder[i];
                const heights = ["h-28", "h-36", "h-24"];
                const colors = [
                  "from-slate-300 to-slate-400",
                  "from-[color:var(--neon-gold)] to-amber-500",
                  "from-amber-600 to-amber-800",
                ];
                return (
                  <motion.div
                    key={player.rank}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: i * 0.1 }}
                    className="flex flex-col items-center"
                  >
                    <div
                      className={`mb-2 grid h-10 w-10 place-items-center rounded-full bg-gradient-to-br ${colors[i]} text-sm font-bold text-white shadow-lg`}
                    >
                      {rank === 1 ? <Crown className="h-5 w-5" /> : <Medal className="h-4 w-4" />}
                    </div>
                    <div className="text-center">
                      <div className="text-sm font-bold truncate max-w-[100px]">
                        {player.displayName}
                      </div>
                      <div className="text-xs text-muted-foreground">Lvl {player.level}</div>
                    </div>
                    <div
                      className={`mt-2 w-full ${heights[i]} rounded-t-xl bg-gradient-to-t ${colors[i]} opacity-30`}
                    />
                    <div className="mt-1 text-xs font-bold text-[color:var(--neon-gold)]">
                      {player.xp} XP
                    </div>
                  </motion.div>
                );
              })}
            </div>
          )}

          {/* Full ranking */}
          <div className="space-y-2">
            {leaderboard.map((player, i) => (
              <motion.div
                key={player.rank}
                data-testid="leaderboard-row"
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: i * 0.02 }}
                className={`flex items-center gap-4 rounded-xl border p-4 transition ${
                  player.isMe
                    ? "border-[color:var(--gold)]/50 bg-[color:var(--gold)]/10"
                    : "border-border/50 bg-black/40 hover:bg-black/60"
                }`}
              >
                <div
                  className={`grid h-9 w-9 place-items-center rounded-lg text-sm font-bold ${
                    player.rank <= 3
                      ? "bg-gradient-to-br from-[color:var(--neon-gold)] to-amber-600 text-white"
                      : "bg-secondary text-muted-foreground"
                  }`}
                >
                  {player.rank}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold truncate">{player.displayName}</span>
                    {player.isMe && (
                      <span className="rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-[10px] font-bold uppercase text-[color:var(--gold)]">
                        You
                      </span>
                    )}
                  </div>
                  <div className="text-xs text-muted-foreground">
                    {player.heroClass} · Lvl {player.level}
                  </div>
                </div>

                <div className="flex items-center gap-3">
                  {player.streak > 0 && (
                    <div className="flex items-center gap-1 text-sm text-[color:var(--flame)]">
                      <Flame className="h-3.5 w-3.5 animate-flame" /> {player.streak}
                    </div>
                  )}
                  <div className="font-display text-sm font-bold text-[color:var(--neon-gold)]">
                    {player.xp} XP
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          {leaderboard.length === 0 && (
            <div className="mt-12 text-center text-muted-foreground">
              {isGlobal
                ? "No heroes registered yet."
                : "Aucun score dans cette matière pour l'instant."}
            </div>
          )}
        </>
      )}
    </div>
  );
}
