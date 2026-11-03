import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useEffect, useMemo, useState } from "react";
import { ChevronRight, Loader2, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/button";
import { PageShell } from "@/components/ui/page-shell";
import { useAuth } from "@/features/auth";
import { getParcours } from "@/features/dashboard";
import {
  formatScoreOn20,
  getPlacementSubject,
  lastFinishedPlacement,
  listPlacementSubjects,
  placementErrorCode,
  rememberPlacement,
  startPlacementSession,
  useClaimPlacementSessions,
  type RememberedPlacement,
} from "@/features/placement";
import {
  PlacementPicker,
  type PickerGrade,
  type PlacementAudience,
} from "@/features/placement/components/placement-picker";
import { useI18n } from "@/lib/i18n";
import { usePlacementT } from "@/lib/i18n/placement";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { trackProductEvent } from "@/shared/lib/product-events";
import { isRtlText } from "@/shared/lib/utils";

/**
 * L'ENTRÉE DU TEST DE NIVEAU (étude 39, US-1) — publique, partageable, auth-aware.
 *
 * Thin : la route lit le catalogue des classes (`getParcours`, feature `dashboard`), les
 * matières testables de la classe choisie (`listPlacementSubjects`) et, pour un lien partagé
 * (`?matiere=`), la carte de la matière (`getPlacementSubject`) ; elle compose, et c'est elle qui
 * mesure (`placement_started`). Un connecté y passe le test comme un visiteur — son bilan ira
 * dans son Hall.
 *
 * `validateSearch` à la main, sans zod : le validateur d'une route reste hors du chunk d'index
 * (motif de `quest.$exerciseId`). Les deux paramètres sont des identifiants de catalogue : un
 * slug, rien d'autre ne passe.
 */
type EntrySearch = { matiere?: string; niveau?: string };
const SLUG = /^[a-z0-9][a-z0-9_-]{0,63}$/i;

export const Route = createFileRoute("/_public/test-de-niveau")({
  head: () => ({
    meta: [
      { title: "Test de niveau · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Dix questions sur une matière de ta classe : ta note sur 20, ce que tu tiens, ce qu'il reste à revoir et par où commencer. Gratuit, sans inscription.",
      },
      {
        property: "og:title",
        content: "Où en es-tu ? Dix questions pour le savoir — Na9ra Nal3ab",
      },
      {
        property: "og:description",
        content:
          "Le test de niveau du programme tunisien : note sur 20 et bilan par chapitre, gratuit, sans compte.",
      },
    ],
  }),
  validateSearch: (s: Record<string, unknown>): EntrySearch => {
    const out: EntrySearch = {};
    if (typeof s.matiere === "string" && SLUG.test(s.matiere)) out.matiere = s.matiere;
    if (typeof s.niveau === "string" && SLUG.test(s.niveau)) out.niveau = s.niveau;
    return out;
  },
  component: PlacementEntryPage,
});

type CatalogueRow = {
  id: string;
  name_fr: string;
  name_en?: string | null;
  name_ar?: string | null;
  kind: string;
  status: string;
  grade_id: string | null;
  grade_cycle: string | null;
  grade_order: number | null;
  grade_selectable: boolean;
};

/** Une classe par `grade_id` : la piste « scolaire » quand elle existe, le concours sinon. */
function gradesOf(rows: CatalogueRow[], locale: string): PickerGrade[] {
  const byGrade = new Map<string, CatalogueRow>();
  for (const p of rows) {
    if (p.kind !== "concours" && p.kind !== "scolaire") continue;
    if (p.status !== "available" || p.grade_selectable === false || !p.grade_id) continue;
    const prev = byGrade.get(p.grade_id);
    if (!prev || (prev.kind === "concours" && p.kind === "scolaire")) byGrade.set(p.grade_id, p);
  }
  const cycleOf = (c: string | null): PickerGrade["cycle"] =>
    c === "primaire" || c === "college" || c === "secondaire" ? c : null;
  return [...byGrade.values()]
    .sort((a, b) => (a.grade_order ?? 0) - (b.grade_order ?? 0))
    .map((p) => ({
      parcoursId: p.id,
      label: parcoursName(p, locale),
      cycle: cycleOf(p.grade_cycle),
    }));
}

function PlacementEntryPage() {
  const t = usePlacementT();
  const { locale } = useI18n();
  const navigate = useNavigate();
  const search = Route.useSearch();
  const { user, loading: authLoading } = useAuth();
  const isAuthenticated = user != null;

  // R-16 : un compte qui arrive ici avec des tests sur l'appareil les rattache.
  useClaimPlacementSessions(isAuthenticated && !authLoading);

  const fetchParcours = useServerFn(getParcours);
  const fetchSubjects = useServerFn(listPlacementSubjects);
  const fetchSubjectCard = useServerFn(getPlacementSubject);
  const start = useServerFn(startPlacementSession);

  const [parcoursId, setParcoursId] = useState<string | null>(search.niveau ?? null);
  const [subjectId, setSubjectId] = useState<string | null>(search.matiere ?? null);
  const [audience, setAudience] = useState<PlacementAudience>("student");
  const [showPicker, setShowPicker] = useState(!search.matiere);
  const [last, setLast] = useState<RememberedPlacement | null>(null);
  useEffect(() => setLast(lastFinishedPlacement()), []);

  const parcoursQuery = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });
  const grades = useMemo(
    () => gradesOf((parcoursQuery.data?.parcours ?? []) as CatalogueRow[], locale),
    [parcoursQuery.data, locale],
  );

  // Le lien partagé : la matière est connue avant la classe — la carte la rend, avec sa classe.
  const cardQuery = useQuery({
    queryKey: ["placement-subject", search.matiere],
    queryFn: () => fetchSubjectCard({ data: { subjectId: search.matiere as string } }),
    enabled: Boolean(search.matiere),
  });
  const card = cardQuery.data ?? null;
  useEffect(() => {
    if (card?.parcoursId && !parcoursId) setParcoursId(card.parcoursId);
  }, [card, parcoursId]);

  const subjectsQuery = useQuery({
    queryKey: ["placement-subjects", parcoursId],
    queryFn: () => fetchSubjects({ data: { parcoursId: parcoursId as string } }),
    enabled: Boolean(parcoursId),
  });

  const [error, setError] = useState<string | null>(null);
  const startMutation = useMutation({
    mutationFn: (vars: { subjectId: string; fromShare: boolean }) =>
      start({ data: { subjectId: vars.subjectId, audience } }),
    onSuccess: (started, vars) => {
      rememberPlacement({
        id: started.id,
        token: started.token,
        subjectId: started.subject.id,
        subjectName: started.subject.nameFr,
        at: Date.now(),
      });
      // é39 R-21 — le premier fait du canal : un test commencé. Un id de catalogue et trois faits.
      trackProductEvent("placement_started", {
        subject_id: started.subject.id,
        audience: started.audience,
        signed_in: isAuthenticated,
        from_share: vars.fromShare,
      });
      navigate({ to: "/test-de-niveau/$sessionId", params: { sessionId: started.id } });
    },
    onError: (e) => {
      const code = placementErrorCode(e);
      setError(
        code === "busy"
          ? t.placement.entry.busy
          : code === "notEnough" || code === "subjectNotFound"
            ? t.placement.entry.notEnough
            : t.placement.entry.startFailed,
      );
    },
  });

  const startWith = (id: string, fromShare: boolean) => {
    setError(null);
    startMutation.mutate({ subjectId: id, fromShare });
  };

  const quickStart = Boolean(search.matiere) && !showPicker;

  return (
    <PageShell width="narrow" className="py-10">
      <header className="mb-8 text-center">
        <div className="inline-flex items-center gap-2 rounded-full bg-secondary px-4 py-1.5 text-xs font-semibold uppercase tracking-wider text-primary">
          <Sparkles className="h-3.5 w-3.5" aria-hidden /> {t.placement.entry.kicker}
        </div>
        <h1 className="mx-auto mt-4 max-w-2xl font-display text-3xl font-bold leading-tight sm:text-4xl">
          {t.placement.entry.title}
        </h1>
        <p className="mx-auto mt-3 max-w-xl text-muted-foreground">{t.placement.entry.subtitle}</p>
        {!authLoading && isAuthenticated && (
          <p className="mt-3 text-sm text-muted-foreground">
            {t.placement.entry.signedInHint}{" "}
            <Link to="/dashboard" className="font-semibold text-primary hover:underline">
              {t.placement.summary.seeInHall}
            </Link>
          </p>
        )}
      </header>

      {/* Le dernier test de l'appareil — pour un visiteur ; un connecté a son Hall. */}
      {last && !isAuthenticated && !authLoading && typeof last.scoreOn20 === "number" && (
        <Link
          to="/test-de-niveau/$sessionId"
          params={{ sessionId: last.id }}
          className="mb-8 flex items-center justify-between gap-3 rounded-2xl border border-border bg-card p-4 transition hover:border-primary/60"
          data-testid="placement-last-result"
        >
          <div>
            <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
              {t.placement.entry.lastResultTitle}
            </p>
            <p className="mt-1 text-sm font-semibold tabular-nums">
              {t.placement.entry.lastResultBody
                .replace("{score}", formatScoreOn20(last.scoreOn20, locale))
                .replace("{subject}", last.subjectName)}
            </p>
          </div>
          <span className="inline-flex items-center gap-1 text-sm font-semibold text-primary">
            {t.placement.entry.lastResultOpen}{" "}
            <ChevronRight className="h-4 w-4 rtl:-scale-x-100" aria-hidden />
          </span>
        </Link>
      )}

      {quickStart ? (
        /* Le lien partagé : la matière est déjà choisie — un bouton, et c'est parti. */
        <section
          className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-6 text-center"
          data-testid="placement-quick-start"
        >
          {cardQuery.isLoading ? (
            <Loader2 className="mx-auto h-6 w-6 animate-spin text-primary" aria-hidden />
          ) : card ? (
            <>
              <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                {t.placement.entry.pickSubject}
              </p>
              <h2
                className="mt-1 font-display text-2xl font-bold"
                dir={card.contentLanguage === "ar" || isRtlText(card.nameFr) ? "rtl" : undefined}
              >
                {card.nameFr}
              </h2>
              {card.gradeNameFr && (
                <p className="mt-1 text-sm text-muted-foreground">{card.gradeNameFr}</p>
              )}
              {!card.testable ? (
                <p className="mt-4 text-sm text-muted-foreground">{t.placement.entry.notEnough}</p>
              ) : (
                <>
                  <div
                    className="mt-4 flex flex-wrap justify-center gap-2"
                    role="radiogroup"
                    aria-label={t.placement.entry.audienceLabel}
                  >
                    {(["student", "parent"] as const).map((a) => (
                      <button
                        key={a}
                        type="button"
                        role="radio"
                        aria-checked={audience === a}
                        onClick={() => setAudience(a)}
                        className={`min-h-11 rounded-xl border px-4 py-2 text-sm font-medium transition ${
                          audience === a
                            ? "border-primary bg-primary/10 text-primary"
                            : "border-border bg-card hover:border-primary/60"
                        }`}
                      >
                        {a === "student"
                          ? t.placement.entry.audienceStudent
                          : t.placement.entry.audienceParent}
                      </button>
                    ))}
                  </div>
                  {error && (
                    <p role="alert" className="mt-3 text-sm text-destructive">
                      {error}
                    </p>
                  )}
                  <Button
                    type="button"
                    size="lg"
                    className="mt-4 min-h-12 gap-2 text-base"
                    disabled={startMutation.isPending}
                    onClick={() => startWith(card.id, true)}
                    data-testid="placement-quick-start-button"
                  >
                    {startMutation.isPending ? (
                      <>
                        <Loader2 className="h-4 w-4 animate-spin" aria-hidden />{" "}
                        {t.placement.entry.starting}
                      </>
                    ) : (
                      <>
                        {t.placement.entry.start}{" "}
                        <ChevronRight className="h-5 w-5 rtl:-scale-x-100" aria-hidden />
                      </>
                    )}
                  </Button>
                </>
              )}
            </>
          ) : (
            <p className="text-sm text-muted-foreground">{t.placement.entry.notEnough}</p>
          )}
          <button
            type="button"
            onClick={() => setShowPicker(true)}
            className="mt-4 block w-full text-sm font-medium text-primary underline-offset-2 hover:underline"
          >
            {t.placement.summary.otherSubject}
          </button>
        </section>
      ) : (
        <PlacementPicker
          grades={grades}
          gradesLoading={parcoursQuery.isLoading}
          subjects={parcoursId ? (subjectsQuery.data ?? null) : null}
          subjectsLoading={subjectsQuery.isLoading}
          selectedParcoursId={parcoursId}
          selectedSubjectId={subjectId}
          audience={audience}
          starting={startMutation.isPending}
          error={error}
          onSelectParcours={(id) => {
            setParcoursId(id);
            setSubjectId(null);
            setError(null);
          }}
          onSelectSubject={(id) => {
            setSubjectId(id);
            setError(null);
          }}
          onAudience={setAudience}
          onStart={() => subjectId && startWith(subjectId, false)}
        />
      )}
    </PageShell>
  );
}
