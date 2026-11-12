import { useEffect, useRef } from "react";
import { ChevronRight, Loader2, Users } from "lucide-react";

import { Button } from "@/components/ui/button";
import { usePlacementT } from "@/lib/i18n/placement";
import { PLACEMENT_ITEMS } from "@/shared/constants/placement";
import { isRtlText } from "@/shared/lib/utils";

/**
 * L'ENTRÉE DU TEST — classe, puis matière, puis « je suis… », puis Commencer (étude 39 US-1).
 *
 * Présentationnel : la ROUTE lit le catalogue (`getParcours`, feature `dashboard`) et la liste
 * des matières testables (`listPlacementSubjects`), et compose — une feature n'en importe jamais
 * une autre (D-11). Ce composant ne connaît ni le réseau ni la session : il reçoit des listes et
 * rend des choix.
 *
 * Le registre est « Référence » (coquille publique) : `bg-card`, `border-border`, `text-primary`,
 * jamais un littéral de couleur (docs/design-surfaces.md).
 */

export type PickerGrade = {
  parcoursId: string;
  label: string;
  cycle: "primaire" | "college" | "secondaire" | null;
};

export type PickerSubject = {
  id: string;
  nameFr: string;
  contentLanguage: string | null;
  chapters: number;
  questions: number;
};

export type PlacementAudience = "student" | "parent";

const OPTION_BASE =
  "flex min-h-11 w-full items-center justify-between gap-3 rounded-xl border px-4 py-3 text-start text-sm font-medium transition";
const OPTION_IDLE = "border-border bg-card hover:border-primary/60";
const OPTION_ON = "border-primary bg-primary/10 text-primary";

/**
 * Amène à l'écran l'étape que le choix vient d'ouvrir. La liste des classes fait près de deux
 * écrans de téléphone : la matière apparaissait 1 200 px sous le doigt, et rien de visible ne
 * changeait (relevé « première visite » du 2026-11-12, C-5). Sans animation pour qui l'a demandé.
 */
function reveal(el: HTMLElement | null, block: ScrollLogicalPosition) {
  if (!el || typeof el.scrollIntoView !== "function") return;
  const reduced =
    typeof window.matchMedia === "function" &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  el.scrollIntoView({ block, behavior: reduced ? "auto" : "smooth" });
}

export function PlacementPicker({
  grades,
  gradesLoading,
  subjects,
  subjectsLoading,
  selectedParcoursId,
  selectedSubjectId,
  audience,
  starting,
  error,
  onSelectParcours,
  onSelectSubject,
  onAudience,
  onStart,
}: {
  grades: PickerGrade[];
  gradesLoading: boolean;
  /** `null` tant qu'aucune classe n'est choisie. */
  subjects: PickerSubject[] | null;
  subjectsLoading: boolean;
  selectedParcoursId: string | null;
  selectedSubjectId: string | null;
  audience: PlacementAudience;
  starting: boolean;
  error: string | null;
  onSelectParcours: (parcoursId: string) => void;
  onSelectSubject: (subjectId: string) => void;
  onAudience: (audience: PlacementAudience) => void;
  onStart: () => void;
}) {
  const t = usePlacementT();
  // Seul un CHOIX fait défiler : une classe pré-remplie par l'adresse ou par la carte du Hall
  // laisse le visiteur en haut de page, là où il lit la promesse.
  const pickedRef = useRef<"grade" | "subject" | null>(null);
  const subjectSectionRef = useRef<HTMLElement>(null);
  const startRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const picked = pickedRef.current;
    pickedRef.current = null;
    if (picked === "grade") reveal(subjectSectionRef.current, "start");
    if (picked === "subject") reveal(startRef.current, "nearest");
  }, [selectedParcoursId, selectedSubjectId]);
  const cycleLabel = (cycle: PickerGrade["cycle"]) =>
    cycle === "primaire"
      ? t.cycles.primaire
      : cycle === "college"
        ? t.cycles.college
        : cycle === "secondaire"
          ? t.cycles.secondaire
          : "";
  const cycles: PickerGrade["cycle"][] = ["primaire", "college", "secondaire", null];

  return (
    <div className="space-y-8" data-testid="placement-picker">
      {/* Les trois faits — ce qui attend l'élève, avant qu'il choisisse. */}
      <ul className="flex flex-wrap gap-2 text-xs font-semibold text-muted-foreground">
        <li className="rounded-full bg-secondary px-3 py-1">
          {t.placement.entry.factQuestions.replace("{n}", String(PLACEMENT_ITEMS))}
        </li>
        <li className="rounded-full bg-secondary px-3 py-1">{t.placement.entry.factMinutes}</li>
        <li className="rounded-full bg-secondary px-3 py-1">{t.placement.entry.factBilan}</li>
      </ul>

      {/* 1. La classe */}
      <section aria-labelledby="placement-pick-grade">
        <h2 id="placement-pick-grade" className="font-display text-lg font-bold">
          {t.placement.entry.pickGrade}
        </h2>
        {gradesLoading ? (
          <div className="mt-3 grid gap-2 sm:grid-cols-2">
            {[0, 1, 2, 3].map((i) => (
              <div key={i} className="h-11 animate-pulse rounded-xl border border-border bg-card" />
            ))}
          </div>
        ) : (
          <div className="mt-3 space-y-4">
            {cycles.map((cycle) => {
              const items = grades.filter((g) => g.cycle === cycle);
              if (items.length === 0) return null;
              return (
                <div key={cycle ?? "libre"}>
                  {cycle && (
                    <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                      {cycleLabel(cycle)}
                    </h3>
                  )}
                  <div
                    className="grid gap-2 sm:grid-cols-2"
                    role="radiogroup"
                    aria-label={t.placement.entry.pickGrade}
                  >
                    {items.map((g) => {
                      const on = g.parcoursId === selectedParcoursId;
                      return (
                        <button
                          key={g.parcoursId}
                          type="button"
                          role="radio"
                          aria-checked={on}
                          onClick={() => {
                            pickedRef.current = "grade";
                            onSelectParcours(g.parcoursId);
                          }}
                          className={`${OPTION_BASE} ${on ? OPTION_ON : OPTION_IDLE}`}
                          dir={isRtlText(g.label) ? "rtl" : undefined}
                        >
                          <span>{g.label}</span>
                          <ChevronRight className="h-4 w-4 shrink-0 rtl:-scale-x-100" aria-hidden />
                        </button>
                      );
                    })}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </section>

      {/* 2. La matière — seulement celles qui ont de quoi composer un test (R-1). */}
      {selectedParcoursId && (
        <section
          ref={subjectSectionRef}
          aria-labelledby="placement-pick-subject"
          className="scroll-mt-44"
        >
          <h2 id="placement-pick-subject" className="font-display text-lg font-bold">
            {t.placement.entry.pickSubject}
          </h2>
          {subjectsLoading || subjects === null ? (
            <div className="mt-3 grid gap-2 sm:grid-cols-2">
              {[0, 1, 2].map((i) => (
                <div
                  key={i}
                  className="h-11 animate-pulse rounded-xl border border-border bg-card"
                />
              ))}
            </div>
          ) : subjects.length === 0 ? (
            <p className="mt-3 rounded-xl border border-dashed border-border/60 bg-card/40 p-4 text-sm text-muted-foreground">
              {t.placement.entry.noSubject}
            </p>
          ) : (
            <div
              className="mt-3 grid gap-2 sm:grid-cols-2"
              role="radiogroup"
              aria-label={t.placement.entry.pickSubject}
            >
              {subjects.map((s) => {
                const on = s.id === selectedSubjectId;
                return (
                  <button
                    key={s.id}
                    type="button"
                    role="radio"
                    aria-checked={on}
                    data-testid={`placement-subject-${s.id}`}
                    onClick={() => {
                      pickedRef.current = "subject";
                      onSelectSubject(s.id);
                    }}
                    className={`${OPTION_BASE} ${on ? OPTION_ON : OPTION_IDLE}`}
                    dir={s.contentLanguage === "ar" || isRtlText(s.nameFr) ? "rtl" : undefined}
                  >
                    <span>{s.nameFr}</span>
                    <ChevronRight className="h-4 w-4 shrink-0 rtl:-scale-x-100" aria-hidden />
                  </button>
                );
              })}
            </div>
          )}
        </section>
      )}

      {/* 3. « Je suis… » — auto-déclaré, n'ouvre aucun droit (D-10). */}
      <section aria-labelledby="placement-audience">
        <h2 id="placement-audience" className="font-display text-lg font-bold">
          {t.placement.entry.audienceLabel}
        </h2>
        <div
          className="mt-3 flex flex-wrap gap-2"
          role="radiogroup"
          aria-label={t.placement.entry.audienceLabel}
        >
          {(["student", "parent"] as const).map((a) => {
            const on = audience === a;
            return (
              <button
                key={a}
                type="button"
                role="radio"
                aria-checked={on}
                data-testid={`placement-audience-${a}`}
                onClick={() => onAudience(a)}
                className={`inline-flex min-h-11 items-center gap-2 rounded-xl border px-4 py-2 text-sm font-medium transition ${on ? OPTION_ON : OPTION_IDLE}`}
              >
                {a === "parent" && <Users className="h-4 w-4" aria-hidden />}
                {a === "student"
                  ? t.placement.entry.audienceStudent
                  : t.placement.entry.audienceParent}
              </button>
            );
          })}
        </div>
        {audience === "parent" && (
          <p className="mt-2 text-sm text-muted-foreground">
            {t.placement.entry.audienceParentHint}
          </p>
        )}
      </section>

      {error && (
        <p
          role="alert"
          className="rounded-xl border border-destructive/40 bg-destructive/10 p-3 text-sm text-destructive"
        >
          {error}
        </p>
      )}

      <div ref={startRef} className="scroll-mb-6">
        <Button
          type="button"
          size="lg"
          className="min-h-12 w-full gap-2 text-base sm:w-auto"
          disabled={!selectedSubjectId || starting}
          onClick={onStart}
          data-testid="placement-start"
        >
          {starting ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" aria-hidden /> {t.placement.entry.starting}
            </>
          ) : (
            <>
              {t.placement.entry.start}{" "}
              <ChevronRight className="h-5 w-5 rtl:-scale-x-100" aria-hidden />
            </>
          )}
        </Button>
      </div>
    </div>
  );
}
