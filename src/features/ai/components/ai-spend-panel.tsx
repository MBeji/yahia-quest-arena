import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { TriangleAlert } from "lucide-react";

import { useT } from "@/lib/i18n";
import { asAiErrorCode, microsToUsd } from "@/shared/integrations/ai";
import { aiErrorLabel, aiFeatureLabel } from "../ai-mode-status";
import { getAiConsole, type AiConsole } from "../ai-console.server";

/**
 * US-7 — « Suivre la dépense » (étude 29 lot 5).
 *
 * R-12 EST LA CONTRAINTE DE CET ÉCRAN, pas une note en bas
 * -------------------------------------------------------------------------
 * « Aucune surface ne présente le montant comme une facture ; la mention de
 * renvoi au fournisseur est PERMANENTE. » Elle est donc rendue avec les
 * montants, dans le même bloc, avec la date de la grille — un chiffre sans sa
 * date est un chiffre qu'on ne peut pas contredire.
 *
 * R-14b : cet écran ne s'affiche que pour le PORTEUR de la clé. Il vit dans la
 * section « Mode IA » des Réglages, qui n'existe que là où une clé existe — et
 * `get_ai_console` est self-scoped, donc même une erreur d'écran ne montrerait
 * la dépense de personne d'autre.
 *
 * R-19 : le bandeau qui NOMME un modèle qui échoue trop. Il ne bascule pas et ne
 * propose pas de basculer d'un clic : il nomme, il chiffre, il suggère. C'est sa
 * clé, donc son choix (D-11).
 */

const usd = (micros: number) => `${microsToUsd(micros).toFixed(2)} $`;

/** Assez pour voir la panne du jour, pas assez pour noyer la console. */
const RECENT_SHOWN = 8;

export function AiSpendPanel() {
  const t = useT();
  const fetchConsole = useServerFn(getAiConsole);

  const { data } = useQuery<AiConsole | null>({
    queryKey: ["ai-console"],
    queryFn: () => fetchConsole(),
    staleTime: 60_000,
  });

  if (!data) return null;

  return (
    <div className="mt-4 border-t border-border/50 pt-3 text-sm" data-testid="ai-spend">
      <p className="font-semibold">{t.ai.spendTitle}</p>

      {/* R-19 — le bandeau. En TÊTE, avant les chiffres : si le modèle jette la
          moitié de ce qu'il produit, c'est la première chose à savoir. */}
      {data.modelAdvice && (
        <div
          className="mt-2 rounded-lg border border-destructive/40 bg-destructive/5 p-2.5 text-xs"
          data-testid="ai-model-advice"
        >
          <p className="flex items-center gap-1.5 font-semibold text-destructive">
            <TriangleAlert className="h-3.5 w-3.5" />
            {t.ai.adviceTitle}
          </p>
          <p className="mt-1">{t.ai.adviceBody.replace("{model}", data.modelAdvice.model)}</p>
          {data.modelAdvice.suggestions.length > 0 && (
            <p className="mt-1 text-muted-foreground">
              {t.ai.adviceSuggest.replace("{models}", data.modelAdvice.suggestions.join(", "))}
            </p>
          )}
        </div>
      )}

      <div className="mt-2 grid grid-cols-2 gap-3">
        <Figure
          label={t.ai.spendToday}
          value={usd(data.dayMicros)}
          hintLabel={data.limitsEnforced ? null : t.ai.spendRefShort}
          hint={`${data.dailyBudgetUsd.toFixed(2)} $`}
          testId="ai-spend-today"
        />
        <Figure
          label={t.ai.spendMonth}
          value={usd(data.monthMicros)}
          hintLabel={data.limitsEnforced ? null : t.ai.spendRefShort}
          hint={`${data.monthlyBudgetUsd.toFixed(2)} $`}
          testId="ai-spend-month"
        />
      </div>

      {/* R-12 : permanente, et collée aux montants. */}
      <p className="mt-2 text-xs text-muted-foreground">
        {t.ai.estimateNotice} {t.ai.pricesAsOf.replace("{date}", data.pricesAsOf)}
      </p>

      <p className="mt-2 text-xs text-muted-foreground">
        {t.ai.spendCalls.replace("{n}", String(data.callsMonth))}
      </p>

      <Breakdown title={t.ai.spendByStudent} rows={data.byStudent} />
      <Breakdown title={t.ai.spendByFeature} rows={data.byFeature} />

      {/* R-13 : par modèle. C'est la ligne qui rend un rebut imputable — sans
          elle, la console mélange les fournisseurs et ne veut plus rien dire. */}
      {Object.keys(data.byModel).length > 0 && (
        <div className="mt-3">
          <p className="text-xs font-semibold text-muted-foreground">{t.ai.spendByModel}</p>
          <ul className="mt-1 grid gap-1">
            {Object.entries(data.byModel).map(([model, stats]) => (
              <li key={model} className="flex justify-between gap-2 text-xs">
                <span className="truncate font-mono" dir="ltr">
                  {model}
                </span>
                <span className="shrink-0" dir="ltr">
                  {usd(stats.micros)} · {stats.calls}
                  {stats.errors > 0 && ` · ⚠ ${stats.errors}`}
                </span>
              </li>
            ))}
          </ul>
        </div>
      )}

      {/* LES DERNIERS APPELS, ÉCHECS COMPRIS.
          `get_ai_console` rend cette liste avec son `errorCode` depuis le lot 5,
          et l'écran la jetait. C'était la seule surface où un porteur pouvait
          apprendre POURQUOI un appel a échoué — sans elle, une clé refusée, un
          modèle inexistant et un fournisseur en panne se ressemblent tous : un
          geste qui ne marche pas. La clé n'est marquée `invalid` que sur un 401
          (`concludeFailure`), donc le bandeau d'erreur des Réglages reste muet
          pour tous les autres codes ; c'est ici qu'ils se lisent. */}
      {data.recent.length > 0 && (
        <div className="mt-3">
          <p className="text-xs font-semibold text-muted-foreground">{t.ai.spendRecent}</p>
          <ul className="mt-1 grid gap-1" data-testid="ai-spend-recent">
            {data.recent.slice(0, RECENT_SHOWN).map((call) => (
              <li
                key={`${call.at}-${call.feature}-${call.model}`}
                className="flex flex-wrap items-baseline justify-between gap-x-2 text-xs"
              >
                <span className="min-w-0 truncate">
                  {aiFeatureLabel(call.feature, t) ?? call.feature}
                  <span className="text-muted-foreground">
                    {" · "}
                    <span className="font-mono" dir="ltr">
                      {call.model}
                    </span>
                  </span>
                </span>
                {call.status === "error" ? (
                  <span className="shrink-0 text-destructive">
                    {aiErrorLabel(asAiErrorCode(call.errorCode), t)}
                  </span>
                ) : (
                  <span className="shrink-0" dir="ltr">
                    {usd(call.micros)}
                  </span>
                )}
              </li>
            ))}
          </ul>
        </div>
      )}

      {data.callsMonth === 0 && (
        <p className="mt-2 text-xs text-muted-foreground">{t.ai.spendNone}</p>
      )}
    </div>
  );
}

function Figure({
  label,
  value,
  hint,
  hintLabel,
  testId,
}: {
  label: string;
  value: string;
  hint: string;
  /**
   * Mot qui qualifie le second montant. `null` ⇒ le montant est un PLAFOND, et
   * le « / » suffit. Sinon c'est un simple repère, et il faut le DIRE : depuis
   * le 2026-08-22 les plafonds ne coupent plus par défaut, et « 1,20 $ / 2,00 $ »
   * laisserait croire à une coupure à 2 $ qui n'arrivera jamais.
   */
  hintLabel: string | null;
  testId: string;
}) {
  return (
    <div className="rounded-lg border border-border/60 p-2.5">
      <span className="block text-xs text-muted-foreground">{label}</span>
      {/* Un montant est du contenu LTR, même dans une interface arabe (é29 §2.5). */}
      <span className="block font-display text-lg font-bold" dir="ltr" data-testid={testId}>
        {value}
      </span>
      {/* Le MOT suit la direction de la page ; seul le MONTANT est forcé en LTR. */}
      <span className="block text-xs text-muted-foreground">
        {hintLabel ? (
          <>
            {hintLabel} <span dir="ltr">{hint}</span>
          </>
        ) : (
          <span dir="ltr">/ {hint}</span>
        )}
      </span>
    </div>
  );
}

function Breakdown({ title, rows }: { title: string; rows: Record<string, number> }) {
  const entries = Object.entries(rows).filter(([, micros]) => micros > 0);
  if (entries.length === 0) return null;
  return (
    <div className="mt-3">
      <p className="text-xs font-semibold text-muted-foreground">{title}</p>
      <ul className="mt-1 grid gap-1">
        {entries
          .sort((a, b) => b[1] - a[1])
          .map(([key, micros]) => (
            <li key={key} className="flex justify-between gap-2 text-xs">
              <span className="truncate">{key}</span>
              <span className="shrink-0" dir="ltr">
                {usd(micros)}
              </span>
            </li>
          ))}
      </ul>
    </div>
  );
}
