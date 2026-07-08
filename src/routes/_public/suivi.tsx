import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Activity, Link as LinkIcon, Printer, Share2 } from "lucide-react";
import {
  buildFamilyReportShareText,
  getStudentReportByCode,
  ReportContent,
} from "@/features/parent-report";
import { useI18n } from "@/lib/i18n";

/**
 * Suivi parental PUBLIC par code — aucun compte, aucune connexion requise.
 *
 * Le parent colle l'Alliance Code de son enfant (affiché sur le tableau de bord de
 * l'élève) et voit le bilan en lecture seule. Le code peut arriver pré-rempli via
 * `?code=…` (deep-link depuis la landing / lien partagé). L'accès « au porteur » est
 * assumé côté produit ; le RPC `get_student_report_by_code` est appelable en anonyme.
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
  const { t } = useI18n();
  const { code: codeParam } = Route.useSearch();
  const navigate = Route.useNavigate();
  const fetchReport = useServerFn(getStudentReportByCode);
  const [code, setCode] = useState(codeParam ?? "");

  const reportMutation = useMutation({
    mutationFn: (studentCode: string) => fetchReport({ data: { studentCode } }),
    onError: () => {
      // Message précis déjà porté par l'erreur (server fn) — rien à ajouter ici.
    },
  });

  // Auto-lance la requête quand la page arrive avec un code (deep-link / partage).
  useEffect(() => {
    const initial = codeParam?.trim();
    if (initial && initial.length >= 8) {
      reportMutation.mutate(initial);
    }
    // Volontairement au montage / changement de `codeParam` uniquement.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [codeParam]);

  const report = reportMutation.data;

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const trimmed = code.trim();
    if (trimmed.length < 8) return;
    // Reflète le code dans l'URL (partageable / bookmarkable) puis lance.
    navigate({ search: { code: trimmed } });
    reportMutation.mutate(trimmed);
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
        {reportMutation.isError && (
          <p role="alert" className="mt-2 text-sm font-medium text-destructive">
            {reportMutation.error instanceof Error
              ? reportMutation.error.message
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
          <ReportContent report={report} />
        </>
      )}

      {reportMutation.isPending && (
        <div className="flex items-center justify-center py-20">
          <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent" />
        </div>
      )}
    </div>
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
