import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useLocation, useNavigate, useParams } from "@tanstack/react-router";
import { GraduationCap, Hammer, Lock, Sparkles } from "lucide-react";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useT } from "@/lib/i18n";
import { getAiStudentSurfaces } from "../ai-access.server";
import { listForgeableChapters, type ForgeableChapter } from "../forge.server";

/**
 * LA BULLE IA — permanente, y compris pour qui n'a pas de clé.
 *
 * ⚠️ CE COMPOSANT RENVERSE R-1 DE L'ÉTUDE 29, ET C'EST UN ARBITRAGE ASSUMÉ.
 * ---------------------------------------------------------------------------
 * R-1 disait : « aucune surface IA n'est visible sans mode actif — pas de bouton
 * grisé, pas d'appel à l'action, pas de "bientôt" ». La règle protégeait d'une
 * chose précise : promettre à un enfant ce que sa famille n'a pas branché.
 *
 * Arbitrage du propriétaire (2026-08-27) : le mode IA est le cœur du produit et
 * personne ne peut le découvrir s'il est invisible. La bulle est donc TOUJOURS
 * là ; ce qui n'est pas ouvert apparaît GRISÉ, et un clic explique comment
 * l'ouvrir. La contrepartie de ce renversement est écrite dans le code :
 *
 *   * aucune surface grisée ne se DÉCLENCHE — elle explique, elle n'appelle
 *     jamais un modèle, donc elle ne coûte rien à personne ;
 *   * le texte ne dit ni « premium », ni « abonnement », ni « payant » : la
 *     phase gratuite l'interdit sur toute surface (AGENTS.md), et c'est vrai —
 *     l'application ne facture rien, la clé est celle de la famille ;
 *   * la bulle DISPARAÎT pendant une épreuve notée. Ce n'est pas une exception
 *     à la permanence, c'est l'autre moitié de R-1 — « jamais pendant un donjon,
 *     un duel » — qui est une règle d'ANTI-TRICHE, pas de découverte. Une bulle
 *     qui invite au tuteur au milieu d'un donjon inviterait à tricher.
 *
 * CE QUE LA BULLE NE FAIT PAS : elle n'embarque aucune surface. Elle MÈNE au
 * chat (sur son chapitre) et à la Forge, là où ils vivent déjà. Une feature
 * n'importe pas une autre feature (AGENTS.md), et dupliquer le chat dans un
 * dialogue en ferait deux qui divergeraient.
 */

/** Routes où la bulle se tait : épreuves notées et tunnels sans place pour elle. */
const SILENT_PATHS = /^\/(quest|dungeon|duel|examen|onboarding)/;

/**
 * Le chemin courant, LU DANS LE ROUTEUR — jamais dans `window.location`.
 *
 * `window.location.pathname` lu pendant un rendu n'est pas une donnée réactive :
 * il ne se relit qu'au prochain rendu, et rien ne garantit qu'il y en ait un.
 * Deux écrans sans paramètre d'URL — `/onboarding` puis `/dashboard`, `/dungeon`
 * puis `/dashboard` — ne changent aucune des valeurs auxquelles ce composant
 * était abonné : il gardait donc le `null` du rendu précédent, et la bulle
 * restait INVISIBLE sur le tableau de bord, juste après la sortie du tunnel
 * d'inscription. Le cœur du produit disparaissait au moment exact où l'élève
 * arrivait dessus, jusqu'au prochain rechargement complet.
 *
 * Le routeur, lui, notifie à chaque navigation ; et il rend le même chemin au
 * SSR et au client, ce que `window` ne peut pas faire (côté serveur, il n'existe
 * pas : la bulle était rendue dans le HTML des écrans d'épreuve, puis retirée à
 * l'hydratation).
 */
function useSilent(): boolean {
  return useLocation({ select: (location) => SILENT_PATHS.test(location.pathname) });
}

export function AiLauncher({ authenticated }: { authenticated: boolean }) {
  const t = useT();
  const navigate = useNavigate();
  const fetchSurfaces = useServerFn(getAiStudentSurfaces);
  const fetchChapters = useServerFn(listForgeableChapters);
  const [open, setOpen] = useState(false);
  const [picked, setPicked] = useState<string | null>(null);

  // Le chapitre de la route COURANTE, quand il y en a un. `strict: false` parce
  // que ce composant est monté dans la coquille : il ne connaît pas la route,
  // il lit ce qu'elle expose.
  const params = useParams({ strict: false }) as { chapterId?: string };
  const currentChapterId = params.chapterId ?? null;
  const silent = useSilent();

  const { data: surfaces } = useQuery({
    queryKey: ["ai-surfaces"],
    queryFn: () => fetchSurfaces(),
    enabled: authenticated,
    staleTime: 60_000,
  });

  // Les chapitres ne sont chargés qu'à l'OUVERTURE du dialogue, et seulement
  // quand il faut en choisir un : une bulle présente sur tous les écrans qui
  // interrogerait le catalogue à chaque page vue serait une requête par
  // navigation, pour un menu que personne n'a demandé.
  const needsPicker = open && currentChapterId === null;
  const { data: chapters } = useQuery<ForgeableChapter[]>({
    queryKey: ["forgeable-chapters"],
    queryFn: () => fetchChapters(),
    enabled: authenticated && needsPicker,
    staleTime: 5 * 60_000,
  });

  if (!authenticated) return null;
  if (silent) return null;

  const features = surfaces?.enabled === true ? surfaces.features : [];
  const chatOpen = features.includes("chat");
  const forgeOpen = features.includes("forge");
  const anyOpen = features.length > 0;

  const chatTarget = currentChapterId ?? picked;

  function goToChat() {
    if (!chatTarget) return;
    setOpen(false);
    void navigate({
      to: "/chapitre/$chapterId",
      params: { chapterId: chatTarget },
      search: { chat: true },
    });
  }

  function goToForge() {
    setOpen(false);
    void navigate({
      to: "/forge",
      search: currentChapterId ? { chapitre: currentChapterId } : undefined,
    });
  }

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label={t.ai.launcherLabel}
        title={t.ai.launcherLabel}
        data-testid="ai-launcher"
        data-state={anyOpen ? "on" : "locked"}
        // Grisé quand rien n'est ouvert — l'arbitrage du 2026-08-27 en toutes
        // lettres. Le bouton reste CLIQUABLE : c'est le clic qui explique.
        className={`fixed bottom-[calc(8.5rem+env(safe-area-inset-bottom))] end-4 z-40 inline-flex items-center gap-2 rounded-full border px-4 py-2.5 text-sm font-semibold shadow-gold backdrop-blur-md transition hover:scale-105 lg:bottom-[calc(4.75rem+env(safe-area-inset-bottom))] ${
          anyOpen
            ? "border-[color:var(--gold)]/40 bg-surface-3 text-champagne hover:text-[color:var(--gold)]"
            : "border-border/50 bg-surface-2 text-muted-foreground hover:text-foreground"
        }`}
      >
        {anyOpen ? (
          <Sparkles className="h-4 w-4 shrink-0" aria-hidden="true" />
        ) : (
          <Lock className="h-4 w-4 shrink-0" aria-hidden="true" />
        )}
        <span className="hidden sm:inline">{t.ai.launcherLabel}</span>
      </button>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Sparkles className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />
              {t.ai.launcherTitle}
            </DialogTitle>
            <DialogDescription>
              {anyOpen ? t.ai.launcherDesc : t.ai.launcherLockedDesc}
            </DialogDescription>
          </DialogHeader>

          {/* LE CHAT — le cœur, donc en tête. Sans chapitre courant, on en fait
              choisir un : la conversation est cadrée sur un cours (é11 R-6), et
              c'est ce cadrage qui la rend sûre pour un enfant. */}
          <Entry
            icon={<GraduationCap className="h-5 w-5" aria-hidden="true" />}
            title={t.ai.launcherChat}
            desc={t.ai.launcherChatDesc}
            locked={!chatOpen}
            testId="ai-launcher-chat"
            disabled={chatOpen && !chatTarget}
            onClick={goToChat}
          >
            {chatOpen && currentChapterId === null && (
              <ChapterSelect chapters={chapters ?? []} current={picked} onPick={setPicked} />
            )}
          </Entry>

          <Entry
            icon={<Hammer className="h-5 w-5" aria-hidden="true" />}
            title={t.ai.launcherForge}
            desc={t.ai.launcherForgeDesc}
            locked={!forgeOpen}
            testId="ai-launcher-forge"
            onClick={goToForge}
          />

          {/* L'INVITATION — la raison d'être de l'arbitrage. Elle ne s'affiche
              QUE si rien n'est ouvert : la répéter à une famille qui a déjà
              branché sa clé serait du bruit. */}
          {!anyOpen && (
            <p className="mt-1 text-xs text-muted-foreground" data-testid="ai-launcher-invite">
              {t.ai.launcherInvite}{" "}
              <button
                type="button"
                onClick={() => {
                  setOpen(false);
                  void navigate({ to: "/parametrage" });
                }}
                className="font-semibold text-[color:var(--gold)] underline"
                data-testid="ai-launcher-settings"
              >
                {t.ai.launcherInviteCta}
              </button>
            </p>
          )}
        </DialogContent>
      </Dialog>
    </>
  );
}

function Entry({
  icon,
  title,
  desc,
  locked,
  disabled,
  testId,
  onClick,
  children,
}: {
  icon: React.ReactNode;
  title: string;
  desc: string;
  locked: boolean;
  disabled?: boolean;
  testId: string;
  onClick: () => void;
  children?: React.ReactNode;
}) {
  const t = useT();
  return (
    <div
      className={`mt-2 rounded-xl border p-3 ${
        locked ? "border-border/40 opacity-60" : "border-[color:var(--gold)]/25 bg-surface-2"
      }`}
      data-testid={testId}
      data-locked={locked ? "true" : "false"}
    >
      <div className="flex items-start gap-3">
        <span
          className={`grid h-10 w-10 shrink-0 place-items-center rounded-xl ${
            locked
              ? "bg-muted text-muted-foreground"
              : "bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
          }`}
        >
          {locked ? <Lock className="h-5 w-5" aria-hidden="true" /> : icon}
        </span>
        <span className="min-w-0 flex-1">
          <span className="block font-display font-bold">{title}</span>
          <span className="block text-xs text-muted-foreground">
            {locked ? t.ai.launcherEntryLocked : desc}
          </span>
        </span>
      </div>

      {children}

      {/* Une entrée verrouillée n'a PAS de bouton : rien à déclencher, donc rien
          qui puisse coûter un appel. L'explication est au-dessus, l'invitation
          en bas du dialogue. */}
      {!locked && (
        <button
          type="button"
          onClick={onClick}
          disabled={disabled}
          data-testid={`${testId}-go`}
          className="mt-3 inline-flex min-h-11 w-full items-center justify-center rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-sm font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50"
        >
          {t.ai.launcherGo}
        </button>
      )}
    </div>
  );
}

/** Le même sélecteur que la Forge, pour la même raison : le chat est cadré sur un cours. */
function ChapterSelect({
  chapters,
  current,
  onPick,
}: {
  chapters: readonly ForgeableChapter[];
  current: string | null;
  onPick: (chapterId: string) => void;
}) {
  const t = useT();
  if (chapters.length === 0) {
    return <p className="mt-2 text-xs text-muted-foreground">{t.ai.forgeNoChapter}</p>;
  }

  const bySubject = new Map<string, ForgeableChapter[]>();
  for (const chapter of chapters) {
    const bucket = bySubject.get(chapter.subjectName);
    if (bucket) bucket.push(chapter);
    else bySubject.set(chapter.subjectName, [chapter]);
  }

  return (
    <label className="mt-3 block">
      <span className="text-xs font-semibold text-muted-foreground">{t.ai.forgeChapter}</span>
      <select
        value={current ?? ""}
        onChange={(e) => onPick(e.target.value)}
        data-testid="ai-launcher-chapter"
        className="mt-1 min-h-11 w-full rounded-lg border border-border/60 bg-surface-2 px-3 py-1.5 text-sm"
      >
        <option value="" disabled>
          {t.ai.forgeChapterPlaceholder}
        </option>
        {[...bySubject].map(([subjectName, items]) => (
          <optgroup key={subjectName} label={subjectName}>
            {items.map((chapter) => (
              <option key={chapter.id} value={chapter.id}>
                {chapter.title}
              </option>
            ))}
          </optgroup>
        ))}
      </select>
    </label>
  );
}
