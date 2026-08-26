import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Users } from "lucide-react";

import { Switch } from "@/components/ui/switch";
import { useT, type TranslationKeys } from "@/lib/i18n";
import { AI_LIVE_FEATURES, TUTOR_HARD_DAILY_CAP, type AiFeature } from "@/shared/constants/ai";
import {
  AI_ACTIVATABLE_FEATURES,
  getAiStudents,
  setAiStudentAccess,
  type AiStudentAccess,
} from "../ai-access.server";
import { aiErrorLabel, aiModeErrorCode } from "../ai-mode-status";

/**
 * US-3 — « Activer par enfant ». L'écran qui applique R-3.
 *
 * « La console liste les enfants liés ; pour chacun : interrupteur, sélection
 * des surfaces autorisées, plafond d'énergie quotidien. »
 *
 * R-3 tient toujours sur ce qui compte — une clé enregistrée n'allume RIEN
 * d'elle-même, et un élève non activé n'a aucune surface. Ce qui a changé le
 * 2026-08-26, c'est le contenu du geste d'activation : armer l'interrupteur
 * d'un élève ouvre désormais toutes les surfaces que la clé paie, au lieu de
 * n'en ouvrir aucune. Le porteur restreint ensuite s'il le souhaite ; il ne
 * part plus d'un mode allumé qui n'allume rien.
 *
 * Deux choses que cet écran ne fait PAS, et c'est délibéré :
 *
 *   * il n'affiche AUCUN montant (R-14). L'élève qu'on active peut ouvrir la
 *     même page si la clé est la sienne — la dépense se lit dans la section du
 *     porteur, jamais dans une liste d'élèves ;
 *   * il ne laisse pas monter l'énergie au-delà du plafond DUR. Ce n'est pas un
 *     garde-fou de coût — le plafond monétaire s'en charge — c'est un garde-fou
 *     pédagogique (é09 anti-farm, é11 R-12), et il ne se règle pas.
 *
 * L'auto-détention (Q-2) apparaît comme une ligne « Moi » en tête : le porteur
 * qui a branché sa propre clé pour lui-même n'a pas à chercher où s'activer.
 */

/** Le libellé d'une surface. Fermé : une surface sans libellé ne s'affiche pas. */
function featureLabel(feature: AiFeature, t: TranslationKeys): string | null {
  switch (feature) {
    case "explain":
      return t.ai.featExplain;
    case "reformulate":
      return t.ai.featReformulate;
    case "chat":
      return t.ai.featChat;
    case "check":
      return t.ai.featCheck;
    case "forge":
      return t.ai.featForge;
    case "exercise_gen":
      return t.ai.featExerciseGen;
    case "digest_student":
      return t.ai.featDigestStudent;
    case "digest_parent":
      return t.ai.featDigestParent;
    default:
      return null;
  }
}

export function AiStudentsPanel() {
  const t = useT();
  const queryClient = useQueryClient();
  const fetchStudents = useServerFn(getAiStudents);

  const { data: students } = useQuery<AiStudentAccess[]>({
    queryKey: ["ai-students"],
    queryFn: () => fetchStudents(),
    staleTime: 30_000,
  });

  return (
    <div className="mt-4 border-t border-border/50 pt-3">
      <p className="flex items-center gap-2 text-sm font-semibold">
        <Users className="h-4 w-4 text-[color:var(--gold)]" />
        {t.ai.studentsTitle}
      </p>
      <p className="text-xs text-muted-foreground">{t.ai.studentsDesc}</p>

      {students && students.length === 0 && (
        <p className="mt-2 text-xs text-muted-foreground">{t.ai.studentNone}</p>
      )}

      {(students ?? []).map((student) => (
        <StudentRow
          key={student.studentUserId}
          student={student}
          onChanged={() => queryClient.invalidateQueries({ queryKey: ["ai-students"] })}
        />
      ))}
    </div>
  );
}

function StudentRow({ student, onChanged }: { student: AiStudentAccess; onChanged: () => void }) {
  const t = useT();
  const save = useServerFn(setAiStudentAccess);
  const [busy, setBusy] = useState(false);

  async function persist(next: Partial<AiStudentAccess>) {
    setBusy(true);
    try {
      await save({
        data: {
          studentUserId: student.studentUserId,
          enabled: next.enabled ?? student.enabled,
          features: (next.features ??
            student.features) as (typeof AI_ACTIVATABLE_FEATURES)[number][],
          dailyEnergyMax: next.dailyEnergyMax ?? student.dailyEnergyMax,
        },
      });
      onChanged();
    } catch (error) {
      const code = aiModeErrorCode(error instanceof Error ? error.message : String(error));
      // Les trois signaux propres à l'activation ont leur propre phrase ; le
      // reste retombe sur la table de l'annexe C.
      const raw = error instanceof Error ? error.message : "";
      const label = raw.includes("AI_NOT_LINKED")
        ? t.ai.errNotLinked
        : raw.includes("AI_NO_CREDENTIAL")
          ? t.ai.errNoCredential
          : raw.includes("AI_ENERGY_CAP_EXCEEDED")
            ? t.ai.errEnergyCap
            : aiErrorLabel(code, t);
      toast.error(label);
    } finally {
      setBusy(false);
    }
  }

  function toggleFeature(feature: AiFeature, on: boolean) {
    const next = on
      ? [...new Set([...student.features, feature])]
      : student.features.filter((f) => f !== feature);
    void persist({ features: next });
  }

  return (
    <div
      className="mt-2 rounded-lg border border-border/50 p-2.5"
      data-testid={`ai-student-${student.studentUserId}`}
    >
      <div className="flex flex-wrap items-center justify-between gap-2">
        <span className="text-sm font-semibold">
          {student.isSelf ? t.ai.studentSelf : (student.displayName ?? "—")}
        </span>
        <span className="flex items-center gap-2 text-xs text-muted-foreground">
          {t.ai.studentEnabled}
          <Switch
            checked={student.enabled}
            disabled={busy}
            data-testid={`ai-student-toggle-${student.studentUserId}`}
            // ARBITRAGE DU 2026-08-26 : allumer un élève ouvre TOUTES les
            // surfaces que la clé paie — c'est l'usage nominal, pas une option.
            // Le défaut d'avant (liste vide) obligeait le porteur à cocher
            // chaque puce APRÈS avoir armé l'interrupteur ; celui qui s'arrêtait
            // là avait un mode « allumé » qui n'allumait rien, et concluait que
            // la clé ne servait à rien. On ne pré-remplit QUE sur une liste
            // vide : un porteur qui a déjà restreint son enfant garde son choix
            // quand il rallume.
            onCheckedChange={(on) =>
              void persist(
                on && student.features.length === 0
                  ? { enabled: true, features: [...AI_LIVE_FEATURES] }
                  : { enabled: on },
              )
            }
            aria-label={t.ai.studentEnabled}
          />
        </span>
      </div>

      {/* Les surfaces et l'énergie ne s'affichent qu'une fois le mode allumé :
          régler le détail d'un mode éteint est un réglage sans effet, et les
          montrer ferait croire que quelque chose est actif. */}
      {student.enabled && (
        <>
          <div className="mt-2 flex flex-wrap gap-1.5">
            {/* Seules les surfaces qui ont un ÉCRAN sont proposées. Un
                interrupteur qui n'allume rien fait conclure que le mode est
                cassé — voir AI_LIVE_FEATURES. */}
            {AI_LIVE_FEATURES.map((feature) => {
              const label = featureLabel(feature, t);
              if (!label) return null;
              const on = student.features.includes(feature);
              return (
                <button
                  key={feature}
                  type="button"
                  disabled={busy}
                  onClick={() => toggleFeature(feature, !on)}
                  aria-pressed={on}
                  data-testid={`ai-feature-${feature}`}
                  className={`min-h-11 rounded-full border px-2.5 py-1 text-xs font-semibold transition disabled:opacity-50 ${
                    on
                      ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                      : "border-border/60 text-muted-foreground hover:bg-accent"
                  }`}
                >
                  {label}
                </button>
              );
            })}
          </div>

          <label className="mt-2 flex flex-wrap items-center gap-2 text-xs">
            <span className="text-muted-foreground">{t.ai.energyMax}</span>
            <input
              type="range"
              min={0}
              max={TUTOR_HARD_DAILY_CAP}
              step={1}
              defaultValue={student.dailyEnergyMax}
              disabled={busy}
              data-testid={`ai-energy-${student.studentUserId}`}
              onPointerUp={(e) => void persist({ dailyEnergyMax: Number(e.currentTarget.value) })}
              onKeyUp={(e) => void persist({ dailyEnergyMax: Number(e.currentTarget.value) })}
              aria-label={t.ai.energyMax}
              className="max-w-40 flex-1"
            />
            <span className="font-semibold" dir="ltr">
              {t.ai.energyToday
                .replace("{spent}", String(student.energySpentToday))
                .replace("{max}", String(student.dailyEnergyMax))}
            </span>
          </label>
        </>
      )}
    </div>
  );
}
