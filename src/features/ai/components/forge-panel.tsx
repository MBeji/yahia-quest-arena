import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Link } from "@tanstack/react-router";
import { toast } from "sonner";
import { Hammer, TriangleAlert } from "lucide-react";

import { useT, type TranslationKeys } from "@/lib/i18n";
import { AI_FORGE_LIMITS } from "@/shared/constants/ai";
import { AI_ERROR_CODES } from "@/shared/integrations/ai";
import { aiErrorLabel } from "../ai-mode-status";
import { MAX_DIFFICULTY_LEVEL, MIN_DIFFICULTY_LEVEL } from "@/shared/constants/gamification";
import {
  forgeQuiz,
  listForgeableChapters,
  listForgedQuizzes,
  type ForgeableChapter,
  type ForgedQuizSummary,
} from "../forge.server";
import { ForgedQuizPlayer } from "./forged-quiz-player";

/**
 * L'écran de la Forge — US-6 (étude 29 §2.3).
 *
 * Tout ce que l'élève choisit est DÉTERMINISTE : le périmètre, le volume, la
 * difficulté. « Aucun de ces champs n'est décidé par le modèle. » La langue
 * n'est même pas un choix : c'est celle de la matière (é11 R-3), et elle est
 * imposée côté serveur.
 *
 * SANS CHAPITRE, L'ÉCRAN EN DEMANDE UN
 * -------------------------------------------------------------------------
 * L'entrée du tableau de bord n'apporte aucun chapitre (§2.1 : « depuis le hub
 * d'un chapitre ET depuis le dashboard élève »). Les réglages ne s'affichaient
 * alors pas du tout, et la page se réduisait à son titre — une porte qui ne
 * s'ouvre sur rien. Le sélecteur ci-dessous EST cette porte : il ne propose que
 * des chapitres enseignés du parcours actif, ceux dont la Forge sait tirer un
 * quiz. Un chapitre reçu en `search` reste prioritaire — on ne redemande pas
 * ce que l'élève vient de désigner.
 *
 * R-14a — CE QUE CET ÉCRAN NE MONTRE JAMAIS
 * -------------------------------------------------------------------------
 * Ni dollar, ni token, ni « il te reste 0,42 $ ». L'étude est explicite :
 * « l'estimation est côté parent, et l'élève ne voit que le coût en énergie ».
 * Le seul compteur ici est le quota de quiz du jour (R-18), qui est une règle de
 * jeu — pas de l'argent.
 */

/**
 * LE CODE D'ÉCHEC, DIT À L'ÉLÈVE — annexe C, appliquée ici aussi.
 *
 * Cette fonction ne reconnaissait que quatre codes et renvoyait tout le reste
 * sur `errGeneric`, qui disait « L'enregistrement a échoué ». Deux fautes dans
 * une seule ligne : la Forge n'enregistre rien à ce moment-là (elle GÉNÈRE), et
 * une clé refusée, un modèle inexistant, un fournisseur en panne ou un plafond
 * atteint arrivaient tous à l'écran sous cette même phrase — celle qui ne
 * permet ni de comprendre, ni d'agir. Un porteur voyait « échec » sans jamais
 * apprendre que sa clé était refusée.
 *
 * L'ordre compte : les codes propres à la Forge d'abord (l'annexe C ne les
 * connaît pas), puis la table commune, puis un générique qui parle au moins de
 * la bonne action.
 */
function forgeErrorLabel(raw: string, t: TranslationKeys): string {
  if (raw.includes("AI_FORGE_QUOTA")) return t.ai.errForgeQuota;
  if (raw.includes("AI_FORGE_NO_QUORUM")) return t.ai.errForgeNoQuorum;
  if (raw.includes("AI_FORGE_NO_CONTEXT")) return t.ai.errForgeNoContext;
  if (raw.includes("AI_OUTPUT_REJECTED")) return t.ai.errForgeOutputRejected;

  // `AI_FORGE_NO_QUORUM` appartient aussi à `AI_ERROR_CODES` : il est traité
  // au-dessus, donc la recherche ci-dessous ne le rencontre jamais.
  const code = AI_ERROR_CODES.find((candidate) => raw.includes(candidate));
  if (code && code !== "AI_UNKNOWN") return aiErrorLabel(code, t);
  return t.ai.errForgeFailed;
}

export function ForgePanel({ chapterId }: { chapterId: string | null }) {
  const t = useT();
  const queryClient = useQueryClient();
  const fetchList = useServerFn(listForgedQuizzes);
  const fetchChapters = useServerFn(listForgeableChapters);
  const forge = useServerFn(forgeQuiz);

  const { data } = useQuery({
    queryKey: ["forged-quizzes"],
    queryFn: () => fetchList(),
    staleTime: 30_000,
  });

  const [size, setSize] = useState<5 | 8 | 10>(8);
  const [difficulty, setDifficulty] = useState(2);
  const [busy, setBusy] = useState(false);
  const [playing, setPlaying] = useState<string | null>(null);
  const [picked, setPicked] = useState<string | null>(null);

  // Le catalogue n'est interrogé QUE lorsqu'il sert : arrivé depuis un
  // chapitre, l'élève a déjà choisi, et lui charger la liste serait une requête
  // pour un menu qu'il ne verra pas.
  const { data: chapters, isLoading: chaptersLoading } = useQuery<ForgeableChapter[]>({
    queryKey: ["forgeable-chapters"],
    queryFn: () => fetchChapters(),
    enabled: chapterId === null,
    staleTime: 5 * 60_000,
  });

  if (playing) {
    return <ForgedQuizPlayer quizId={playing} onLeave={() => setPlaying(null)} />;
  }

  const target = chapterId ?? picked;
  const quotaLeft = data?.quotaLeft ?? AI_FORGE_LIMITS.dailyQuizzesPerStudent;

  async function run() {
    if (!target || busy) return;
    setBusy(true);
    try {
      const outcome = await forge({ data: { chapterId: target, size, difficulty } });
      if (outcome.ok) {
        await queryClient.invalidateQueries({ queryKey: ["forged-quizzes"] });
        setPlaying(outcome.quizId);
      } else {
        toast.error(forgeErrorLabel(outcome.code, t));
      }
    } catch (error) {
      toast.error(forgeErrorLabel(error instanceof Error ? error.message : "", t));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div data-testid="forge-panel">
      <p className="flex items-center gap-2 font-display text-lg font-bold">
        <Hammer className="h-5 w-5 text-[color:var(--gold)]" />
        {t.ai.forgeTitle}
      </p>
      {/* R-16, dit d'emblée : un élève doit savoir AVANT de jouer que ce quiz ne
          rapporte rien. L'apprendre à l'écran de résultat serait une déception. */}
      <p className="text-sm text-muted-foreground">{t.ai.forgeDesc}</p>

      {chapterId === null && (
        <ChapterPicker
          chapters={chapters ?? []}
          loading={chaptersLoading}
          current={picked}
          onPick={setPicked}
        />
      )}

      {target && (
        <div className="mt-3 grid gap-3">
          <Choice
            label={t.ai.forgeSize}
            values={AI_FORGE_LIMITS.allowedSizes}
            current={size}
            onPick={(v) => setSize(v as 5 | 8 | 10)}
            testId="forge-size"
          />
          <Choice
            label={t.ai.forgeDifficulty}
            values={Array.from(
              { length: MAX_DIFFICULTY_LEVEL - MIN_DIFFICULTY_LEVEL + 1 },
              (_, i) => MIN_DIFFICULTY_LEVEL + i,
            )}
            current={difficulty}
            onPick={setDifficulty}
            testId="forge-difficulty"
            render={(v) => "⭐".repeat(v)}
          />

          <div className="flex flex-wrap items-center gap-3">
            <button
              type="button"
              onClick={() => void run()}
              disabled={busy || quotaLeft <= 0}
              data-testid="forge-run"
              className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-4 py-1.5 text-sm font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50"
            >
              <Hammer className="h-4 w-4" />
              {busy ? t.ai.forgeWorking : t.ai.forgeStart}
            </button>
            {/* R-18 : un quota de quiz, pas un montant. C'est une règle de jeu. */}
            <span className="text-xs text-muted-foreground" data-testid="forge-quota">
              {t.ai.forgeQuota.replace("{left}", String(quotaLeft))}
            </span>
          </div>
        </div>
      )}

      <ul className="mt-4 grid gap-2">
        {(data?.quizzes ?? []).length === 0 && (
          <li className="text-xs text-muted-foreground">{t.ai.forgeNoQuiz}</li>
        )}
        {(data?.quizzes ?? []).map((quiz) => (
          <QuizRow key={quiz.id} quiz={quiz} onPlay={() => setPlaying(quiz.id)} />
        ))}
      </ul>
    </div>
  );
}

/**
 * Le sélecteur de chapitre — visible seulement quand la page n'en a pas reçu.
 *
 * Un `<select>` natif, et pas une liste maison : trois langues dont une RTL, un
 * usage majoritairement mobile, et un contrôle que le navigateur rend déjà
 * accessible au clavier et au lecteur d'écran. Les `<optgroup>` portent la
 * matière — sans eux, « Les fractions » et « Les fractions » de deux matières
 * différentes seraient indiscernables.
 *
 * Liste VIDE ≠ chargement : le premier cas est un fait à expliquer (aucun
 * chapitre enseigné dans le parcours actif, ou aucun parcours choisi) avec la
 * sortie qui va avec ; le second ne promet rien tant qu'il ne sait rien.
 */
function ChapterPicker({
  chapters,
  loading,
  current,
  onPick,
}: {
  chapters: readonly ForgeableChapter[];
  loading: boolean;
  current: string | null;
  onPick: (chapterId: string) => void;
}) {
  const t = useT();

  if (loading) return null;

  if (chapters.length === 0) {
    return (
      <p className="mt-3 text-sm text-muted-foreground" data-testid="forge-no-chapter">
        {t.ai.forgeNoChapter}{" "}
        <Link to="/parcours" className="font-semibold text-[color:var(--gold)] underline">
          {t.ai.forgeBrowseParcours}
        </Link>
      </p>
    );
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
        data-testid="forge-chapter"
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

function Choice({
  label,
  values,
  current,
  onPick,
  testId,
  render,
}: {
  label: string;
  values: readonly number[];
  current: number;
  onPick: (value: number) => void;
  testId: string;
  render?: (value: number) => string;
}) {
  return (
    <div>
      <span className="text-xs font-semibold text-muted-foreground">{label}</span>
      <div className="mt-1 flex gap-2">
        {values.map((value) => (
          <button
            key={value}
            type="button"
            aria-pressed={current === value}
            data-testid={`${testId}-${value}`}
            onClick={() => onPick(value)}
            className={`min-h-11 flex-1 rounded-lg border px-3 py-1.5 text-sm font-semibold transition ${
              current === value
                ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                : "border-border/60 text-muted-foreground hover:bg-accent"
            }`}
          >
            {render ? render(value) : value}
          </button>
        ))}
      </div>
    </div>
  );
}

function QuizRow({ quiz, onPlay }: { quiz: ForgedQuizSummary; onPlay: () => void }) {
  const t = useT();
  return (
    <li className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-border/60 p-2.5 text-sm">
      <span className="min-w-0">
        <span className="block truncate font-semibold">{quiz.chapterTitle ?? "—"}</span>
        <span className="block text-xs text-muted-foreground">
          {"⭐".repeat(quiz.difficulty)} · {quiz.questionCount} ·{" "}
          {t.ai.forgeExpires.replace("{date}", new Date(quiz.expiresAt).toLocaleDateString())}
        </span>
      </span>
      <span className="flex items-center gap-2">
        {/* R-18bis.2 : l'étiquette suit le quiz jusque dans la liste. */}
        {!quiz.verified && (
          <span className="inline-flex items-center gap-1 rounded-full border border-destructive/50 px-2 py-0.5 text-2xs font-semibold text-destructive">
            <TriangleAlert className="h-3 w-3" />
            {t.ai.forgeUnverified}
          </span>
        )}
        <button
          type="button"
          onClick={onPlay}
          data-testid={`forge-play-${quiz.id}`}
          className="inline-flex min-h-11 items-center rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10"
        >
          {t.ai.forgePlay}
        </button>
      </span>
    </li>
  );
}
