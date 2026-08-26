import { Link } from "@tanstack/react-router";
import {
  AlertTriangle,
  ChevronRight,
  Gauge,
  Lightbulb,
  Sparkles,
  Target,
  TrendingUp,
} from "lucide-react";
import { useParentT, type ParentTranslationKeys } from "@/lib/i18n/parent";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import {
  analyzeSubjects,
  formatMinutes,
  subjectLevel,
  topContributors,
  topGaps,
  type DailyReport,
  type EfficiencyResult,
  type EngagementResult,
  type IndexResult,
  type ParentAlert,
  type ScoredFactor,
  type SubjectSlice,
} from "../insights";
import { alertMessage } from "./alert-message";
import { BAND_STYLES, useBandLabel } from "./daily-band";
import { DeltaChip, EmptyRow, Meter, SectionCard } from "./daily-primitives";

type T = ParentTranslationKeys;
type AnyFactor = ScoredFactor<string>;

/**
 * §5 et §6 : l'engagement et l'efficacité, tous deux EXPLIQUÉS.
 *
 * Un score nu (« 72/100 ») n'aide aucun parent : il invite à négocier avec un
 * chiffre qu'il ne comprend pas. Chaque carte montre donc ce qui a porté le
 * niveau et ce qui l'a retenu, avec les valeurs brutes derrière — « 4 jours
 * actifs sur les 5 attendus », pas « régularité : 0,8 ».
 */
export function IndexCard({
  title,
  subtitle,
  icon,
  result,
}: {
  title: string;
  subtitle: string;
  icon: React.ReactNode;
  result: EngagementResult | EfficiencyResult;
}) {
  const t = useParentT();
  const bandLabel = useBandLabel();
  const style = BAND_STYLES[result.band];

  if (result.insufficientData) {
    return (
      <SectionCard title={title} subtitle={subtitle} icon={icon}>
        <EmptyRow label={t.parentDaily.indexNotEnoughData} />
      </SectionCard>
    );
  }

  const contributors = topContributors(result as IndexResult<string>);
  const gaps = topGaps(result as IndexResult<string>);

  return (
    <SectionCard title={title} subtitle={subtitle} icon={icon}>
      <div className={`flex items-center gap-4 rounded-lg border p-3 ${style.bg} ${style.ring}`}>
        <div className="relative h-16 w-16 shrink-0">
          <svg className="h-16 w-16 -rotate-90" viewBox="0 0 36 36" aria-hidden="true">
            <circle cx="18" cy="18" r="15" fill="none" stroke="var(--muted)" strokeWidth="3" />
            <circle
              cx="18"
              cy="18"
              r="15"
              fill="none"
              stroke="currentColor"
              strokeWidth="3"
              strokeDasharray={`${result.score * 0.94} 100`}
              className={style.text}
            />
          </svg>
          <span
            className={`absolute inset-0 flex items-center justify-center text-base font-bold ${style.text}`}
          >
            {result.score}
          </span>
        </div>
        <div className="min-w-0">
          <div className={`text-lg font-bold ${style.text}`}>{bandLabel(result.band)}</div>
          <p className="text-xs text-muted-foreground">
            {t.parentDaily.indexScoreOutOf.replace("{score}", String(result.score))}
          </p>
        </div>
      </div>

      {contributors.length > 0 && (
        <FactorList
          title={t.parentDaily.indexDrivers}
          icon={<Sparkles className="h-4 w-4 text-success" />}
          factors={contributors}
          tone="good"
        />
      )}
      {gaps.length > 0 && (
        <FactorList
          title={t.parentDaily.indexHolders}
          icon={<Target className="h-4 w-4 text-flame" />}
          factors={gaps}
          tone="bad"
        />
      )}
    </SectionCard>
  );
}

function FactorList({
  title,
  icon,
  factors,
  tone,
}: {
  title: string;
  icon: React.ReactNode;
  factors: AnyFactor[];
  tone: "good" | "bad";
}) {
  const t = useParentT();
  return (
    <div className="mt-3">
      <div className="flex items-center gap-1.5 text-xs font-semibold text-muted-foreground">
        {icon}
        {title}
      </div>
      <ul className="mt-1.5 space-y-2">
        {factors.map((factor) => (
          <li key={factor.key}>
            <div className="flex items-baseline justify-between gap-2 text-sm">
              <span className="text-foreground">{factorLabel(factor.key, t)}</span>
              <span className="shrink-0 text-xs tabular-nums text-muted-foreground">
                {factorReadout(factor, t)}
              </span>
            </div>
            <div className="mt-1">
              <Meter
                value={(factor.ratio ?? 0) * 100}
                className={tone === "good" ? "bg-success" : "bg-flame"}
              />
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}

/** Le nom lisible d'un facteur — la seule chaîne traduite par facteur. */
function factorLabel(key: string, t: T): string {
  const labels: Record<string, string> = {
    regularity: t.parentDaily.factorRegularity,
    learningTime: t.parentDaily.factorLearningTime,
    activityVolume: t.parentDaily.factorActivityVolume,
    lessonCompletion: t.parentDaily.factorLessonCompletion,
    perseverance: t.parentDaily.factorPerseverance,
    progress: t.parentDaily.factorProgress,
    revision: t.parentDaily.factorRevision,
    accuracy: t.parentDaily.factorAccuracy,
    timeToResult: t.parentDaily.factorTimeToResult,
    progression: t.parentDaily.factorProgress,
    retrySuccess: t.parentDaily.factorRetrySuccess,
    pace: t.parentDaily.factorPace,
    revisionGain: t.parentDaily.factorRevisionGain,
  };
  return labels[key] ?? key;
}

/**
 * La valeur BRUTE derrière le facteur. Composée de nombres et d'unités courtes
 * plutôt que de phrases traduites : treize phrases en trois langues coûteraient
 * plus au dictionnaire (budget de bundle) qu'elles n'apporteraient de clarté.
 */
function factorReadout(factor: AnyFactor, t: T): string {
  const d = factor.detail;
  const signed = (n: number) => `${n > 0 ? "+" : ""}${n}`;

  switch (factor.key) {
    case "regularity":
      return `${d.activeDays} / ${d.expectedActiveDays} ${t.parentDaily.unitDays}`;
    case "learningTime":
      return `${formatMinutes(d.learningMinutes, "0")} / ${formatMinutes(d.targetMinutes, "0")}`;
    case "activityVolume":
      return `${d.activities} / ${d.target}`;
    case "lessonCompletion":
      return `${d.lessonsStudied} / ${d.lessonsOpened}`;
    case "perseverance":
      return `${d.completed} / ${d.started}`;
    case "progress":
    case "progression":
      return `${signed(d.trend)} ${t.parentDaily.unitPoints}`;
    case "revision":
      return formatMinutes(d.revisionMinutes, "0");
    case "accuracy":
      return `${d.accuracyPct} %`;
    case "timeToResult":
      return `${d.minutesPerPass} ${t.parentDaily.unitMinutesPerSuccess}`;
    case "retrySuccess":
      return `${d.avgTriesToPass} ${t.parentDaily.unitTries}`;
    case "pace":
      return `${d.secondsPerQuestion} ${t.parentDaily.unitSecondsPerQuestion}`;
    case "revisionGain":
      return `${signed(d.gain)} ${t.parentDaily.unitPoints}`;
    default:
      return `${Math.round((factor.ratio ?? 0) * 100)} %`;
  }
}

/**
 * §7 : la comparaison des matières, plus la lecture automatique — fortes,
 * fragiles, délaissées, celles où l'enfant progresse le plus.
 */
export function SubjectsSection({ report }: { report: DailyReport }) {
  const t = useParentT();
  const bandLabel = useBandLabel();
  const analysis = analyzeSubjects(report);

  return (
    <SectionCard
      title={t.parentDaily.subjectsTitle}
      subtitle={t.parentDaily.subjectsSubtitle}
      icon={<Gauge className="h-5 w-5 text-gold" />}
    >
      {report.subjects.length === 0 ? (
        <EmptyRow label={t.parentDaily.subjectsEmpty} />
      ) : (
        <>
          {/* Le tableau garde ses colonnes et défile horizontalement plutôt que
              d'écraser la page — la règle du projet pour les contenus larges. */}
          <div className="-mx-1 overflow-x-auto px-1">
            <table className="w-full min-w-[34rem] border-collapse text-sm">
              <thead>
                <tr className="border-b border-border/50 text-start text-2xs uppercase tracking-wider text-muted-foreground">
                  <th className="py-2 text-start font-semibold">{t.parentDaily.colSubject}</th>
                  <th className="py-2 text-start font-semibold">{t.parentDaily.colCoverage}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colTime}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colLessons}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colExercises}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colSuccess}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colProgress}</th>
                  <th className="py-2 text-end font-semibold">{t.parentDaily.colLevel}</th>
                </tr>
              </thead>
              <tbody>
                {report.subjects.map((subject) => {
                  const level = subjectLevel(subject);
                  return (
                    <tr key={subject.subjectId} className="border-b border-border/30 last:border-0">
                      {/* Le NIVEAU sous le nom : sans lui, « Mathématiques »
                          apparaît autant de fois que l'élève suit de niveaux,
                          et le parent ne peut relier aucune ligne à rien. */}
                      <td className="max-w-[11rem] py-2 pe-2">
                        <div className="truncate text-foreground">
                          {isolateLtrRuns(subject.name)}
                        </div>
                        {subject.gradeName && (
                          <div className="truncate text-2xs text-muted-foreground">
                            {isolateLtrRuns(subject.gradeName)}
                          </div>
                        )}
                      </td>
                      <td className="py-2 pe-2">
                        <CoverageCell subject={subject} />
                      </td>
                      <td className="py-2 text-end tabular-nums text-muted-foreground">
                        {formatMinutes(subject.minutes)}
                      </td>
                      <td className="py-2 text-end tabular-nums text-muted-foreground">
                        {subject.lessons}
                      </td>
                      <td className="py-2 text-end tabular-nums text-muted-foreground">
                        {subject.exercises}
                      </td>
                      <td className="py-2 text-end tabular-nums text-foreground">
                        {subject.exercises > 0 ? `${subject.avgScore}%` : "—"}
                      </td>
                      <td className="py-2 text-end">
                        <DeltaChip value={subject.scoreDelta} suffix="%" />
                      </td>
                      <td className="py-2 text-end">
                        {level ? (
                          <span className={`text-xs font-bold ${BAND_STYLES[level].text}`}>
                            {bandLabel(level)}
                          </span>
                        ) : (
                          <span className="text-xs text-muted-foreground">—</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="mt-4 grid gap-2 sm:grid-cols-2">
            <SubjectTagList
              label={t.parentDaily.subjectsStrong}
              names={analysis.strong.map((s) => s.name)}
              tone="good"
            />
            <SubjectTagList
              label={t.parentDaily.subjectsFragile}
              names={analysis.fragile.map((s) => s.name)}
              tone="bad"
            />
            <SubjectTagList
              label={t.parentDaily.subjectsNeglected}
              names={analysis.neglected.map((s) => s.name)}
              tone="bad"
            />
            <SubjectTagList
              label={t.parentDaily.subjectsImproving}
              names={analysis.mostImproved.map((s) => `${s.name} (+${s.scoreDelta}%)`)}
              tone="good"
            />
          </div>
        </>
      )}
    </SectionCard>
  );
}

/**
 * La couverture du programme d'une matière : chapitres terminés sur chapitres
 * publiés. La règle est celle de la carte `/parcours` que l'élève voit — un
 * chapitre compte quand toutes ses missions de catalogue sont réussies (et, en
 * scolaire, son quiz de compréhension passé). Le parent et l'enfant lisent donc
 * le même chiffre.
 *
 * Une matière sans chapitre publié affiche « — » : la fraction n'existe pas,
 * elle ne vaut pas 0 %.
 */
function CoverageCell({ subject }: { subject: SubjectSlice }) {
  const t = useParentT();

  if (subject.chaptersTotal <= 0) {
    return <span className="text-xs text-muted-foreground">—</span>;
  }

  const pctDone = Math.round((subject.chaptersCompleted / subject.chaptersTotal) * 100);

  return (
    <div className="min-w-[5.5rem]">
      <div className="flex items-baseline justify-between gap-2 text-2xs text-muted-foreground">
        <span className="tabular-nums">
          {subject.chaptersCompleted}/{subject.chaptersTotal}
        </span>
        <span className="tabular-nums">{pctDone}%</span>
      </div>
      <div className="mt-1">
        <Meter
          value={subject.chaptersCompleted}
          max={subject.chaptersTotal}
          className="bg-primary"
          label={t.parentDaily.coverageAria
            .replace("{done}", String(subject.chaptersCompleted))
            .replace("{total}", String(subject.chaptersTotal))}
        />
      </div>
    </div>
  );
}

function SubjectTagList({
  label,
  names,
  tone,
}: {
  label: string;
  names: string[];
  tone: "good" | "bad";
}) {
  const t = useParentT();
  return (
    <div className="rounded-lg border border-border/50 bg-surface-3 p-2.5">
      <div className="text-2xs font-semibold uppercase tracking-wider text-muted-foreground">
        {label}
      </div>
      {names.length === 0 ? (
        <p className="mt-1 text-xs text-muted-foreground">{t.parentDaily.none}</p>
      ) : (
        <div className="mt-1.5 flex flex-wrap gap-1.5">
          {names.map((name) => (
            <span
              key={name}
              className={`rounded px-1.5 py-0.5 text-xs font-medium ${
                tone === "good" ? "bg-success/20 text-success" : "bg-flame/20 text-flame"
              }`}
            >
              {isolateLtrRuns(name)}
            </span>
          ))}
        </div>
      )}
    </div>
  );
}

/** §9 : les alertes et recommandations, avec un lien pour agir. */
export function AlertsSection({ alerts }: { alerts: ParentAlert[] }) {
  const t = useParentT();

  return (
    <SectionCard
      title={t.parentDaily.alertsTitle}
      subtitle={t.parentDaily.alertsSubtitle}
      icon={<Lightbulb className="h-5 w-5 text-gold" />}
    >
      {alerts.length === 0 ? (
        <EmptyRow label={t.parentDaily.alertsEmpty} />
      ) : (
        <ul className="space-y-2">
          {alerts.map((alert) => (
            <li
              key={`${alert.key}-${alert.chapterId ?? alert.subjectId ?? ""}`}
              className={`flex items-start gap-2.5 rounded-lg border p-3 ${
                alert.tone === "warning"
                  ? "border-flame/30 bg-flame/5"
                  : "border-success/30 bg-success/5"
              }`}
            >
              {alert.tone === "warning" ? (
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-flame" />
              ) : (
                <TrendingUp className="mt-0.5 h-4 w-4 shrink-0 text-success" />
              )}
              <div className="min-w-0">
                <p className="text-sm text-foreground">{alertMessage(alert, t)}</p>
                {alert.chapterId && (
                  <Link
                    to="/chapitre/$chapterId"
                    params={{ chapterId: alert.chapterId }}
                    className="mt-1 inline-flex items-center gap-1 text-xs font-semibold text-gold hover:underline print:hidden"
                  >
                    {t.parentReport.adviceReviewCta}
                    <ChevronRight className="h-3.5 w-3.5 rtl:-scale-x-100" />
                  </Link>
                )}
              </div>
            </li>
          ))}
        </ul>
      )}
    </SectionCard>
  );
}
