import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { ArrowLeft, Crown, Flame, Medal, Zap } from "lucide-react";
import { getLeaderboard } from "@/features/dashboard";

export const Route = createFileRoute("/_authenticated/leaderboard")({
  head: () => ({ meta: [{ title: "Leaderboard · XP Scholars" }] }),
  component: LeaderboardPage,
});

function LeaderboardPage() {
  const fetchLeaderboard = useServerFn(getLeaderboard);
  const { data, isLoading } = useQuery({
    queryKey: ["leaderboard"],
    queryFn: () => fetchLeaderboard(),
  });

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
        Loading leaderboard…
      </div>
    );
  }

  const { leaderboard, myRank } = data;

  return (
    <div className="mx-auto max-w-3xl px-6 py-8">
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4" /> Back to hall
      </Link>

      <div className="mb-8 text-center">
        <h1 className="font-display text-4xl font-bold">
          <span className="text-gradient-primary">Academy</span> Leaderboard
        </h1>
        <p className="mt-2 text-muted-foreground">The most powerful heroes of the exam</p>
      </div>

      {/* My rank card */}
      {myRank && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6 rounded-2xl border border-[color:var(--neon-violet)]/40 bg-card/60 p-5 backdrop-blur-xl shadow-neon"
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] font-display text-xl font-bold text-primary-foreground shadow-neon">
                #{myRank.rank}
              </div>
              <div>
                <div className="font-display text-lg font-bold">{myRank.displayName}</div>
                <div className="text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">
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
                key={player.id}
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
            key={player.id}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: i * 0.02 }}
            className={`flex items-center gap-4 rounded-xl border p-4 transition ${
              player.isMe
                ? "border-[color:var(--neon-violet)]/50 bg-[color:var(--neon-violet)]/10"
                : "border-border/50 bg-card/40 hover:bg-card/60"
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
                  <span className="rounded-full bg-[color:var(--neon-violet)]/20 px-2 py-0.5 text-[10px] font-bold uppercase text-[color:var(--neon-violet)]">
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
        <div className="mt-12 text-center text-muted-foreground">No heroes registered yet.</div>
      )}
    </div>
  );
}
