import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef, useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Activity, Link as LinkIcon, Printer, Share2, Trash2 } from "lucide-react";
import { LoadingState } from "@/components/ui/loading-state";
import {
  buildFamilyReportShareText,
  DailyDashboard,
  forgetRememberedCode,
  getStudentReportByCode,
  parentCodeErrorLabel,
  readRememberedCode,
  rememberCode,
  ReportContent,
} from "@/features/parent-report";
import { useParentT } from "@/lib/i18n/parent";

/**
 * Suivi parental PUBLIC par code — aucun compte, aucune connexion requise.
 *
 * Le parent colle l'Alliance Code de son enfant (affiché sur le tableau de bord de
 * l'élève) et voit le bilan en lecture seule. Le code peut arriver pré-rempli via
 * `?code=…` (deep-link depuis la landing / lien partagé) ou depuis la mémoire de
 * l'appareil (case « se souvenir » — sans elle, cette page sans session redemandait
 * le code à CHAQUE visite). L'accès « au porteur » est assumé côté produit ; le RPC
 * `get_student_report_by_code` est appelable en anonyme.
 */
export const Route = createFileRoute("/_public/suivi")({
  validateSearch: (s: Record<string, unknown>): { code?: string } =>
    typeof s.code === "string" && s.code.trim() ? { code: s.code.trim() } : {},
  head: () => ({
    meta: [
      { title: "Suivi de mon enfant · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Suivez la progression de votre enfant avec son code d'alliance — sans compte ni connexion.",
      },
    ],
  }),
  component: SuiviPublicPage,
});

function SuiviPublicPage() {
  const t = useParentT();
  const { code: codeParam } = Route.useSearch();
  const navigate = Route.useNavigate();
  const fetchReport = useServerFn(getStudentReportByCode);
  const [code, setCode] = useState(codeParam ?? "");
  // Coché par défaut : qui ouvre cette page vient voir un bilan, pas régler une
  // option. Le choix reste sous les yeux (label + bouton d'oubli dès qu'un code
  // est retenu), donc l'écriture n'a rien de silencieux.
  const [remember, setRemember] = useState(true);
  const [view, setView] = useState<"summary" | "daily">("daily");
  const [hasStoredCode, setHasStoredCode] = useState(false);
  // Dernier code demandé : le submit pousse le code dans l'URL, ce qui réveille
  // l'effet d'auto-chargement — sans ce garde-fou la requête part deux fois.
  const requestedRef = useRef<string | null>(null);

  const reportMutation = useMutation({
    mutationFn: (studentCode: string) => fetchReport({ data: { studentCode } }),
    onSuccess: (_report, studentCode) => {
      // On ne retient qu'un code qui a vraiment ouvert un bilan.
      if (!remember) return;
      rememberCode(studentCode);
      setHasStoredCode(true);
    },
    onError: () => {
      // Message précis déjà porté par l'erreur (server fn) — rien à ajouter ici.
    },
  });

  function runReport(raw: string, options?: { force?: boolean }) {
    const trimmed = raw.trim();
    if (trimmed.length < 8) return;
    if (!options?.force && requestedRef.current === trimmed) return;
    requestedRef.current = trimmed;
    reportMutation.mutate(trimmed);
  }

  // Auto-lance la requête : code du deep-link (partage) d'abord, sinon celui
  // mémorisé sur cet appareil. `localStorage` n'est lu qu'APRÈS le montage — le
  // lire au rendu ferait diverger l'hydratation du HTML rendu au SSR.
  useEffect(() => {
    const stored = readRememberedCode();
    setHasStoredCode(stored !== null);
    const initial = codeParam?.trim() || stored;
    if (!initial) return;
    setCode(initial);
    runReport(initial);
    // Volontairement au montage / changement de `codeParam` uniquement.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [codeParam]);

  const report = reportMutation.data;
  const submittedCode = reportMutation.variables ?? null;

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const trimmed = code.trim();
    if (trimmed.length < 8) return;
    // Reflète le code dans l'URL (partageable / bookmarkable) puis lance.
    navigate({ search: { code: trimmed } });
    runReport(trimmed, { force: true });
  }

  function toggleRemember(next: boolean) {
    setRemember(next);
    if (!next) {
      forgetRememberedCode();
      setHasStoredCode(false);
      return;
    }
    // Re-coché alors qu'un bilan est déjà affiché : on retient tout de suite,
    // sans attendre une deuxième saisie du même code.
    if (reportMutation.isSuccess) {
      rememberCode(code);
      setHasStoredCode(true);
    }
  }

  // « Oublier » remet la page à zéro : sinon le code reviendrait aussitôt par
  // l'URL (`?code=…`) ou par le bilan resté à l'écran.
  function forgetCode() {
    forgetRememberedCode();
    setHasStoredCode(false);
    setRemember(false);
    setCode("");
    requestedRef.current = null;
    reportMutation.reset();
    navigate({ search: {} });
  }

  return (
    <div className="mx-auto min-h-[100dvh] max-w-6xl p-4 md:p-8">
      <div className="mb-8 print:hidden">
        <h1 className="flex items-center gap-3 font-display text-2xl font-bold text-foreground md:text-3xl">
          <Activity className="h-7 w-7 text-primary" />
          {t.parentReport.title}
        </h1>
        <p className="mt-1 text-muted-foreground">{t.parentReport.subtitle}</p>
      </div>

      <form
        onSubmit={submit}
        className="mb-6 rounded-xl border border-border bg-card p-4 print:hidden"
      >
        <div className="mb-3 flex items-center gap-2 text-primary">
          <LinkIcon className="h-4 w-4" />
          <span className="font-semibold">{t.parentReport.linkTitle}</span>
        </div>
        <div className="grid gap-2 md:grid-cols-[1fr_auto]">
          <input
            value={code}
            onChange={(e) => setCode(e.target.value)}
            placeholder={t.parentReport.codePlaceholder}
            aria-label={t.parentReport.codePlaceholder}
            className="rounded-lg border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:border-primary focus:outline-none"
          />
          <button
            type="submit"
            disabled={code.trim().length < 8 || reportMutation.isPending}
            className="rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition hover:opacity-90 disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
          >
            {reportMutation.isPending ? t.parentReport.linking : t.parentReport.linkCta}
          </button>
        </div>
        <p className="mt-2 text-xs text-muted-foreground">{t.parentReport.linkHint}</p>
        <div className="mt-3 flex flex-wrap items-start justify-between gap-3">
          <label className="inline-flex cursor-pointer items-start gap-2 text-xs text-muted-foreground">
            <input
              type="checkbox"
              checked={remember}
              onChange={(e) => toggleRemember(e.target.checked)}
              className="mt-0.5 h-4 w-4 shrink-0 accent-primary"
            />
            <span>
              <span className="font-medium text-foreground">{t.parentReport.rememberCode}</span>
              <span className="block">{t.parentReport.rememberHint}</span>
            </span>
          </label>
          {hasStoredCode && (
            <button
              type="button"
              onClick={forgetCode}
              className="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-xs font-semibold text-muted-foreground transition hover:border-destructive hover:text-destructive [@media(pointer:coarse)]:min-h-11"
            >
              <Trash2 className="h-3.5 w-3.5" /> {t.parentReport.forgetCode}
            </button>
          )}
        </div>
        {reportMutation.isError && (
          <p role="alert" className="mt-2 text-sm font-medium text-destructive">
            {reportMutation.error instanceof Error
              ? parentCodeErrorLabel(reportMutation.error.message, t)
              : t.parentReport.linkFailed}
          </p>
        )}
      </form>

      {report && (
        <>
          <div className="mb-6 flex flex-wrap gap-2 print:hidden">
            <button
              type="button"
              onClick={() => shareReport(buildFamilyReportShareText(report, t))}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-4 py-2 text-sm font-semibold text-foreground transition hover:border-primary [@media(pointer:coarse)]:min-h-11"
            >
              <Share2 className="h-4 w-4" /> {t.parentReport.shareCta}
            </button>
            <button
              type="button"
              onClick={() => window.print()}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-4 py-2 text-sm font-semibold text-foreground transition hover:border-primary [@media(pointer:coarse)]:min-h-11"
            >
              <Printer className="h-4 w-4" /> {t.parentReport.printCta}
            </button>
          </div>

          {/* Deux lectures du même enfant. Le « Bilan » répond « où en est-il »,
              le « Jour par jour » répond « qu'a-t-il fait, et est-ce sérieux ».
              Empilées, elles seraient illisibles toutes les deux. */}
          <div className="mb-4 inline-flex rounded-lg border border-border bg-card p-0.5 print:hidden">
            <ViewTab
              active={view === "summary"}
              label={t.parentDaily.tabSummary}
              onClick={() => setView("summary")}
            />
            <ViewTab
              active={view === "daily"}
              label={t.parentDaily.tabDaily}
              onClick={() => setView("daily")}
            />
          </div>

          {view === "daily" && submittedCode ? (
            // Le code qui a RÉELLEMENT produit ce rapport, pas la saisie courante :
            // le champ reste éditable après coup.
            <DailyDashboard source={{ kind: "code", studentCode: submittedCode }} />
          ) : (
            <ReportContent report={report} />
          )}
        </>
      )}

      {reportMutation.isPending && <LoadingState label={t.common.loading} className="py-20" />}
    </div>
  );
}

function ViewTab({
  active,
  label,
  onClick,
}: {
  active: boolean;
  label: string;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-pressed={active}
      className={`rounded-md px-4 py-2 text-sm font-semibold transition [@media(pointer:coarse)]:min-h-11 ${
        active
          ? "bg-primary text-primary-foreground"
          : "text-muted-foreground hover:text-foreground"
      }`}
    >
      {label}
    </button>
  );
}

/**
 * Partage du bilan : Web Share natif quand disponible (mobile), sinon WhatsApp web
 * — le canal familial n°1 en Tunisie. (Miroir de la page parent authentifiée.)
 */
function shareReport(text: string): void {
  if (typeof navigator !== "undefined" && typeof navigator.share === "function") {
    navigator.share({ text }).catch(() => {});
    return;
  }
  window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, "_blank", "noopener,noreferrer");
}
