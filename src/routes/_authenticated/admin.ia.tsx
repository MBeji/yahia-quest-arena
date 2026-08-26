import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ArrowLeft, BrainCircuit } from "lucide-react";
import { toast } from "sonner";

import { Switch } from "@/components/ui/switch";
import { PageShell } from "@/components/ui/page-shell";
import { useMyRole } from "@/features/auth";
import { useT } from "@/lib/i18n";
import { microsToUsd } from "@/shared/integrations/ai";
import {
  getAiAdminOverview,
  setAiModeEnabled,
  type AiAdminOverview,
} from "@/features/ai/ai-console.server";
// Chemin COMPLET et non `@/features/tutor` : le barrel de la feature tuteur
// exporte aussi ses server fns, qui atterriraient dans le chunk de cette route.
import { TutorCachePanel } from "@/features/tutor/components/tutor-cache-stats";

/**
 * Console « Mode IA » (étude 29 lot 5, §3.9) — admin seulement.
 *
 * CE QU'ELLE MONTRE, ET CE QU'ELLE NE MONTRERA JAMAIS
 * -------------------------------------------------------------------------
 * Des AGRÉGATS : adoption, répartition des fournisseurs et des modèles, ratio
 * 👍/👎 par modèle, état des kill-switches, familles en coupure. « Aucun
 * transcript, aucune clé, aucun montant nominatif au-delà de l'agrégat. »
 *
 * Le tableau qui justifie cette page est le dernier : le ratio 👍/👎 PAR MODÈLE.
 * C'est la donnée que l'étude nomme comme inexistante aujourd'hui (§1.4), et
 * celle qui dira si un modèle bon marché tient la barre — la question que Q-3 et
 * Q-7 ont rendue urgente en ouvrant le cache mutualisé et la vérification
 * désactivable.
 *
 * Le `isAdmin` client n'est PAS le contrôle d'accès : il évite d'afficher un
 * écran qui échouera. La porte autoritaire est `get_ai_admin_overview()`,
 * SECURITY DEFINER, qui refuse tout non-admin. Même câblage que /admin/economie.
 */
export const Route = createFileRoute("/_authenticated/admin/ia")({
  head: () => ({ meta: [{ title: "Mode IA · Na9ra Nal3ab" }] }),
  component: AdminAiPage,
});

function AdminAiPage() {
  const t = useT();
  const { role, isAdmin } = useMyRole();
  const queryClient = useQueryClient();
  const fetchOverview = useServerFn(getAiAdminOverview);
  const setEnabled = useServerFn(setAiModeEnabled);

  const { data } = useQuery<AiAdminOverview | null>({
    queryKey: ["admin-ai-overview"],
    enabled: isAdmin,
    queryFn: () => fetchOverview(),
  });

  if (role !== null && !isAdmin) {
    return (
      <div className="mx-auto max-w-2xl px-6 py-12 text-center">
        <h1 className="font-display text-2xl font-bold">{t.ai.adminDenied}</h1>
        <Link
          to="/dashboard"
          className="mt-4 inline-block text-sm text-[color:var(--gold)] hover:underline"
        >
          {t.common.backToHall}
        </Link>
      </div>
    );
  }

  return (
    <PageShell width="reading" className="py-8">
      <Link
        to="/console"
        className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" />
        {t.adminHub.title}
      </Link>

      <header className="mb-6">
        <h1 className="flex items-center gap-2 font-display text-3xl font-bold">
          <BrainCircuit className="h-7 w-7 text-[color:var(--gold)]" />
          {t.ai.adminTitle}
        </h1>
        <p className="mt-2 text-muted-foreground">{t.ai.adminDesc}</p>
      </header>

      {data && (
        <>
          {/* Le kill-switch DONNÉES : il coupe sans redéploiement, et son
              actionnement est journalisé (`ai.killswitch`). Les kill-switches
              d'ENVIRONNEMENT restent au-dessus de lui — celui-ci s'y ajoute. */}
          <div className="flex items-center justify-between gap-3 rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-4">
            <span>
              <span className="block font-display font-bold">{t.ai.adminGlobal}</span>
              <span className="block text-xs text-muted-foreground">{t.ai.errModeOff}</span>
            </span>
            <Switch
              checked={data.ai_enabled}
              data-testid="admin-ai-switch"
              aria-label={t.ai.adminGlobal}
              onCheckedChange={(next) => {
                void setEnabled({ data: { enabled: next } })
                  .then(() => queryClient.invalidateQueries({ queryKey: ["admin-ai-overview"] }))
                  .catch(() => toast.error(t.ai.errGeneric));
              }}
            />
          </div>

          {/* La clé PLATEFORME — quel fournisseur elle branche, et sinon
              pourquoi elle n'en branche aucun (é11 A5).

              Elle n'est plus câblée sur Anthropic : `AI_PLATFORM_PROVIDER` la
              bascule vers DeepSeek, Grok, Kimi, GLM ou n'importe quelle adresse
              compatible, exactement comme le formulaire d'une famille. Ce qui
              rend cette ligne nécessaire : une variable mal saisie éteint le
              chemin en SILENCE — l'élève retombe sur le produit déterministe,
              et le seul symptôme est une absence d'appels. Le motif est nommé
              tel quel (`missing_base_url`, …) : c'est le mot qu'on va chercher
              dans les variables d'environnement de l'hébergeur. */}
          <div className="mt-4 rounded-2xl border border-border/60 bg-surface-2 p-4">
            <p className="font-display font-bold">{t.ai.adminPlatform}</p>
            {data.platform.state === "on" ? (
              <p className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-1 text-xs">
                {/* Un nom de marque ne se traduit pas et se lit LTR même en arabe. */}
                <span dir="ltr" className="font-semibold">
                  {data.platform.label ?? data.platform.presetId}
                </span>
                <span dir="ltr" className="font-mono text-muted-foreground">
                  {data.platform.models.fast} · {data.platform.models.rich}
                </span>
                {data.platform.baseUrl && (
                  <span dir="ltr" className="font-mono text-muted-foreground">
                    {data.platform.baseUrl}
                  </span>
                )}
              </p>
            ) : (
              // Le motif est rendu TEL QUEL, sans traduction, et c'est délibéré
              // à deux titres. C'est le mot exact qu'on va chercher dans les
              // variables d'environnement de l'hébergeur — le traduire ferait
              // perdre la seule information utile. Et le catalogue i18n est
              // chargé par TOUS les élèves : y verser des phrases qu'un seul
              // compte lira se paie en kilo-octets sur chaque appareil (le
              // budget du bundle `i18n-` était déjà à 0,1 % de son plafond).
              // `no_key` n'est pas une panne — c'est l'état par défaut (R-1) —
              // d'où l'absence de rouge sur ce seul motif.
              <p
                dir="ltr"
                className={`mt-1 font-mono text-xs ${
                  data.platform.issue === "no_key" ? "text-muted-foreground" : "text-destructive"
                }`}
              >
                {data.platform.issue}
              </p>
            )}
          </div>

          <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-4">
            <Stat label={t.ai.adminFamilies} value={data.families_with_key} />
            <Stat label={t.ai.adminSuspended} value={data.families_suspended} />
            <Stat label={t.ai.adminStudents} value={data.students_enabled} />
            <Stat label={t.ai.adminCalls} value={data.calls_30d} />
          </div>

          {/* Un montant AGRÉGÉ, jamais nominatif : c'est la dépense de tout le
              parc, et elle ne dit rien d'une famille en particulier. */}
          <p className="mt-2 text-xs text-muted-foreground" dir="ltr">
            {microsToUsd(data.micros_30d).toFixed(2)} $ · 30 j
          </p>

          <Table title={t.ai.spendByModel} rows={data.by_model} />
          <Table title={t.ai.provider} rows={data.by_provider} />

          {/* Étude 11 lot 7 — LES DEUX MESURES QUE LA DÉPENSE NE DONNE PAS.
              Au-dessus, ce que l'étage IA a coûté ; ici, ce qu'il a ÉVITÉ de
              coûter (les explications resservies depuis le pot commun) et ce
              qu'il a jeté avant de le servir (le rebut de la Forge). Un montant
              qui monte ne dit pas si le cache travaille ; ces deux ratios, si.

              Le panneau porte sa propre requête plutôt que d'élargir
              `getAiAdminOverview` : sa RPC est celle du TUTEUR, elle a sa propre
              fenêtre et sa propre garde `is_admin()`. La rattacher à l'agrégat
              IA aurait obligé à rouvrir `get_ai_admin_overview` — un DROP qui
              emporte ses GRANT pour deux colonnes.

              Le composant vit dans `features/tutor` et c'est cette ROUTE qui le
              compose : `ai` et `tutor` ne s'importent pas. Et le masquer aux
              non-admins est un confort d'affichage, jamais le contrôle — la
              porte autoritaire est la RPC, qui rend `null` à qui n'a rien à y
              voir. */}
          <TutorCachePanel />

          {/* ⭐ Le tableau de §1.4. */}
          <div className="mt-4">
            <p className="text-sm font-semibold">{t.ai.adminQuality}</p>
            <ul className="mt-1 grid gap-1">
              {Object.entries(data.quality_by_model).map(([model, q]) => (
                <li key={model} className="flex justify-between gap-2 text-xs">
                  <span className="truncate font-mono" dir="ltr">
                    {model}
                  </span>
                  <span className="shrink-0" dir="ltr">
                    👍 {q.up} · 👎 {q.down}
                  </span>
                </li>
              ))}
              {Object.keys(data.quality_by_model).length === 0 && (
                <li className="text-xs text-muted-foreground">{t.ai.spendNone}</li>
              )}
            </ul>
          </div>
        </>
      )}
    </PageShell>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-xl border border-border/60 p-2.5">
      <span className="block text-xs text-muted-foreground">{label}</span>
      <span className="block font-display text-xl font-bold" dir="ltr">
        {value}
      </span>
    </div>
  );
}

function Table({ title, rows }: { title: string; rows: Record<string, number> }) {
  const entries = Object.entries(rows);
  if (entries.length === 0) return null;
  return (
    <div className="mt-4">
      <p className="text-sm font-semibold">{title}</p>
      <ul className="mt-1 grid gap-1">
        {entries
          .sort((a, b) => b[1] - a[1])
          .map(([key, count]) => (
            <li key={key} className="flex justify-between gap-2 text-xs">
              <span className="truncate font-mono" dir="ltr">
                {key}
              </span>
              <span className="shrink-0" dir="ltr">
                {count}
              </span>
            </li>
          ))}
      </ul>
    </div>
  );
}
