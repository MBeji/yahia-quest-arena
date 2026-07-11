import { createFileRoute, Link } from "@tanstack/react-router";
import { Skull, Swords, Crown, ChevronRight } from "lucide-react";
import { PageShell } from "@/components/ui/page-shell";
import { useT } from "@/lib/i18n";
import { DUNGEON_XP_PER_FLOOR } from "@/features/dungeon";
import { DUEL_REWARDS } from "@/shared/constants/gamification";

/**
 * Arène — le pôle compétitif (étude 15, lot 5 / D-4). Regroupe Donjon · Duels ·
 * Classement sous une entrée de nav unique : fin du débordement de la barre
 * desktop (« Duels » tronqué, « Classement » hors écran — audit §E-4) et de la
 * barre mobile surchargée. Cette page-pôle légère maille aussi les trois écrans
 * entre eux (constat §E-4 : ils s'ignoraient). L'enjeu (gains) est annoncé AVANT
 * le clic (R-4) — lu depuis les constantes de jeu, jamais dupliqué en dur.
 */
export const Route = createFileRoute("/_authenticated/arene")({
  head: () => ({ meta: [{ title: "Arène · Na9ra Nal3ab" }] }),
  component: ArenePage,
});

function ArenePage() {
  const t = useT();
  // Titles/pitches reuse the modes' own copy (DRY — the Arène hub IS those
  // screens); only the hub-specific reward hints and framing are new keys.
  const modes = [
    {
      to: "/dungeon" as const,
      Icon: Skull,
      title: t.dungeon.title,
      desc: t.dungeon.desc,
      reward: t.arena.dungeonReward.replace("{xp}", String(DUNGEON_XP_PER_FLOOR)),
    },
    {
      to: "/duel" as const,
      Icon: Swords,
      title: t.duel.title,
      desc: t.duel.subtitle,
      reward: t.arena.duelReward.replace("{xp}", String(DUEL_REWARDS.win.xp)),
    },
    {
      to: "/leaderboard" as const,
      Icon: Crown,
      title: t.leaderboard.titleGradient,
      desc: t.arena.rankingDesc,
      reward: t.arena.rankingReward,
    },
  ];

  return (
    <PageShell width="narrow" className="py-8">
      <header className="mb-6">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">{t.arena.title}</h1>
        <p className="mt-2 text-muted-foreground">{t.arena.subtitle}</p>
      </header>

      <div className="grid gap-3">
        {modes.map(({ to, Icon, title, desc, reward }) => (
          <Link
            key={to}
            to={to}
            className="group flex items-center gap-4 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:bg-black/50 [@media(pointer:coarse)]:min-h-11"
          >
            <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15">
              <Icon className="h-6 w-6 text-[color:var(--gold)]" />
            </div>
            <div className="min-w-0 flex-1">
              <div className="font-display text-lg font-bold">{title}</div>
              <p className="text-sm text-muted-foreground">{desc}</p>
              <p className="mt-0.5 text-xs font-semibold text-[color:var(--gold)]">{reward}</p>
            </div>
            <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
          </Link>
        ))}
      </div>
    </PageShell>
  );
}
