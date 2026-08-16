import type { TranslationKeys } from "@/lib/i18n/types";
import { formatMinutes, type ParentAlert } from "../insights";

/**
 * Monte la phrase d'une alerte depuis sa clé et ses paramètres.
 *
 * C'est la couture entre les RÈGLES (`insights/alerts.ts`, qui ne produisent
 * jamais de texte) et le DICTIONNAIRE (fr / en / ar). Elle vit dans son propre
 * module, sans JSX : un fichier qui exporte des composants ne peut pas aussi
 * exporter une fonction sans casser le rafraîchissement à chaud.
 */
export function alertMessage(alert: ParentAlert, t: TranslationKeys): string {
  const templates: Record<ParentAlert["key"], string> = {
    noActivity: t.parentDaily.alertNoActivity,
    performanceDrop: t.parentDaily.alertPerformanceDrop,
    timeWithoutProgress: t.parentDaily.alertTimeWithoutProgress,
    timeLowYield: t.parentDaily.alertTimeLowYield,
    chapterStruggle: t.parentDaily.alertChapterStruggle,
    subjectNeglected: t.parentDaily.alertSubjectNeglected,
    abandonedExercises: t.parentDaily.alertAbandonedExercises,
    lowRegularity: t.parentDaily.alertLowRegularity,
    revisionNeeded: t.parentDaily.alertRevisionNeeded,
    improvement: t.parentDaily.alertImprovement,
    goalReached: t.parentDaily.alertGoalReached,
    strongSubject: t.parentDaily.alertStrongSubject,
  };

  let message = templates[alert.key];
  for (const [key, value] of Object.entries(alert.params)) {
    // Les durées sont mises en forme ICI, pas dans les règles : « 2 h 15 » est un
    // choix d'affichage, « 135 minutes » est le fait.
    const rendered = key === "minutes" ? formatMinutes(Number(value)) : String(value);
    message = message.replaceAll(`{${key}}`, rendered);
  }
  return message;
}
