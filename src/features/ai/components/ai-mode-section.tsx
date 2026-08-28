import { useCallback, useState, type ReactNode } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Check, KeyRound, ShieldAlert, Trash2, TriangleAlert } from "lucide-react";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { useT } from "@/lib/i18n";
import {
  AI_DEFAULT_BUDGETS,
  AI_MODEL_PRICES_AS_OF,
  AI_PROVIDER_PRESETS,
  presetById,
  type AiProviderId,
  type AiProviderPreset,
} from "@/shared/constants/ai";
import {
  getAiModeStatus,
  revokeAiCredential,
  setAiCredential,
  setAiModels,
  setAiPreferences,
} from "../ai-credentials.server";
import { aiErrorLabel, aiModeErrorCode, type AiModeStatus } from "../ai-mode-status";
import { AiStudentsPanel } from "./ai-students-panel";
import { AiSpendPanel } from "./ai-spend-panel";

/**
 * La section « Mode IA » des Réglages (étude 29 lot 2, D-16).
 *
 * POURQUOI ELLE VIT DANS `/parametrage` ET PAS SUR UNE PAGE À ELLE
 * -------------------------------------------------------------------------
 * Une clé d'API est un réglage de compte, au même titre que la langue ou le
 * thème : elle appartient à la rubrique où l'on va quand on cherche « où est-ce
 * que je change ça ? ». Une route `/ia` dédiée serait introuvable pour qui ne
 * sait pas déjà qu'elle existe (D-16).
 *
 * R-1 — LE PRODUIT SANS CLÉ EST LE PRODUIT D'AUJOURD'HUI
 * -------------------------------------------------------------------------
 * Quand le mode famille n'est pas disponible (kill-switch, coffre sans clé
 * maîtresse), cette section **ne rend rien du tout**. Pas de bouton grisé, pas
 * d'appel à l'action, pas de « bientôt ». C'est la règle, et c'est aussi ce qui
 * rend le test de non-régression possible : mode éteint, l'écran est identique.
 *
 * R-4 — la clé ne réapparaît jamais. On affiche `sk-…4f2a`, en `dir="ltr"` :
 * un masque de clé lu de droite à gauche dans une interface arabe se lit à
 * l'envers (piège déjà payé sur les tableaux de cours, arena#712).
 */

const ACTION_CLASS =
  "inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50";

const FIELD_CLASS = "mt-1 w-full";

function Field({
  label,
  hint,
  children,
}: {
  label: string;
  hint?: string;
  children: React.ReactNode;
}) {
  return (
    <label className="mt-3 block text-sm">
      <span className="font-semibold text-foreground">{label}</span>
      {children}
      {hint && <span className="mt-1 block text-xs text-muted-foreground">{hint}</span>}
    </label>
  );
}

/**
 * `render` reçoit le corps de la section et l'enveloppe dans le chrome de la
 * page appelante (l'en-tête à icône de `/parametrage`).
 *
 * Ce détour existe pour R-1, et pour rien d'autre : quand le mode famille n'est
 * pas disponible, le composant rend `null` — donc l'EN-TÊTE disparaît avec le
 * corps. Si la page enveloppait elle-même, un cartouche « Mode IA » vide
 * resterait à l'écran, ce qui est exactement le « teasing » que R-1 interdit.
 */
export function AiModeSection({ render }: { render: (children: ReactNode) => ReactNode }) {
  const queryClient = useQueryClient();
  const fetchStatus = useServerFn(getAiModeStatus);

  const { data: status } = useQuery<AiModeStatus>({
    queryKey: ["ai-mode-status"],
    queryFn: () => fetchStatus(),
    staleTime: 30_000,
  });

  // R-1 : tant qu'on ne SAIT PAS que le mode est disponible, on ne rend rien.
  // Un état de chargement visible serait déjà un « bientôt ».
  if (!status?.available) return null;

  return render(
    <AiModeBody
      status={status}
      onChanged={() => queryClient.invalidateQueries({ queryKey: ["ai-mode-status"] })}
    />,
  );
}

function AiModeBody({ status, onChanged }: { status: AiModeStatus; onChanged: () => void }) {
  const t = useT();
  const [editing, setEditing] = useState(false);
  const credential = status.credential;

  /**
   * Le formulaire, au moment où il EXISTE. Une ref de rappel plutôt qu'un effet :
   * c'est l'attachement du nœud qui est l'événement attendu, et il survient un
   * rendu après le clic. Le formulaire n'étant monté que par ce clic, il n'y a
   * pas ici le second cas du chat de chapitre (une intention reçue à panneau
   * déjà monté) — le montage EST l'ouverture.
   */
  const revealForm = useCallback((node: HTMLDivElement | null) => {
    if (!node) return;
    requestAnimationFrame(() => node.scrollIntoView({ behavior: "smooth", block: "start" }));
  }, []);

  return (
    <div>
      {credential ? (
        <SavedKey status={status} onChanged={onChanged} onReplace={() => setEditing(true)} />
      ) : (
        !editing && (
          <div className="flex flex-wrap items-center justify-between gap-2 py-2">
            <span className="text-sm text-muted-foreground">{t.ai.stateNone}</span>
            <button
              type="button"
              onClick={() => setEditing(true)}
              className={ACTION_CLASS}
              data-testid="ai-attach"
            >
              <KeyRound className="h-3.5 w-3.5" />
              {t.ai.attach}
            </button>
          </div>
        )
      )}

      {editing && (
        // AMENER LE FORMULAIRE SOUS LES YEUX — signalé le 2026-08-28 :
        // « remplacer la clé ne fait rien ». Il ne faisait rien de VISIBLE.
        //
        // Le formulaire est monté en frère de la carte de la clé, donc APRÈS
        // tout ce qu'elle contient : les plafonds, le panneau de dépense avec
        // son journal d'appels, et l'activation par élève. Mesuré sur un compte
        // réel : le bouton est à 2093 px, le champ « Clé d'API » à 4903 —
        // quatre écrans plus bas, sans que rien ne bouge au clic.
        //
        // Même remède qu'en é11 lot 3 pour le chat de chapitre, et pour la même
        // raison : une frame de retard, parce que le rendu du formulaire doit
        // avoir eu lieu avant qu'on cherche à le rejoindre. `scroll-mt-20`
        // compense l'en-tête collant, sans quoi le titre arriverait dessous.
        <div ref={revealForm} className="scroll-mt-20">
          <AttachForm
            status={status}
            onDone={() => {
              setEditing(false);
              onChanged();
            }}
            onCancel={() => setEditing(false)}
          />
        </div>
      )}
    </div>
  );
}

/** L'état d'une clé enregistrée : `last4`, statut, plafonds réglables, révocation. */
function SavedKey({
  status,
  onChanged,
  onReplace,
}: {
  status: AiModeStatus;
  onChanged: () => void;
  onReplace: () => void;
}) {
  const t = useT();
  const credential = status.credential!;
  const savePrefs = useServerFn(setAiPreferences);
  const changeModels = useServerFn(setAiModels);
  const revoke = useServerFn(revokeAiCredential);

  const [modelFast, setModelFast] = useState(credential.modelFast);
  const [modelRich, setModelRich] = useState(credential.modelRich);
  const [daily, setDaily] = useState(String(credential.dailyBudgetUsd));
  const [monthly, setMonthly] = useState(String(credential.monthlyBudgetUsd));
  const [doubleSolve, setDoubleSolve] = useState(credential.doubleSolve);
  const [limitsEnforced, setLimitsEnforced] = useState(credential.limitsEnforced);
  const [busy, setBusy] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);

  const stateLabel =
    credential.status === "active"
      ? t.ai.stateActive
      : credential.status === "invalid"
        ? t.ai.stateInvalid
        : t.ai.stateUnverified;

  /** Rien à vérifier tant que rien n'a bougé : le bouton reste désarmé. */
  const modelsChanged =
    modelFast.trim() !== credential.modelFast || modelRich.trim() !== credential.modelRich;

  async function saveModels() {
    if (busy || !modelsChanged) return;
    setBusy(true);
    try {
      await changeModels({ data: { modelFast: modelFast.trim(), modelRich: modelRich.trim() } });
      toast.success(t.ai.modelsSaved);
      onChanged();
    } catch (error) {
      // Le code stable voyage dans le message (motif `parent-code-errors`) : un
      // modèle inexistant chez le fournisseur se dit « ce modèle n'existe pas »,
      // pas « une erreur est survenue ».
      const code = aiModeErrorCode(error instanceof Error ? error.message : String(error));
      toast.error(aiErrorLabel(code, t));
    } finally {
      setBusy(false);
    }
  }

  async function persist(next: { doubleSolve?: boolean; limitsEnforced?: boolean } = {}) {
    setBusy(true);
    try {
      await savePrefs({
        data: {
          dailyBudgetUsd: Number(daily),
          monthlyBudgetUsd: Number(monthly),
          doubleSolve: next.doubleSolve ?? doubleSolve,
          limitsEnforced: next.limitsEnforced ?? limitsEnforced,
        },
      });
      toast.success(t.ai.prefsSaved);
      onChanged();
    } catch {
      toast.error(t.ai.errGeneric);
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="text-sm">
      <div className="flex flex-wrap items-center justify-between gap-2 py-2">
        <span className="flex items-center gap-2">
          {credential.status === "active" ? (
            <Check className="h-4 w-4 text-[color:var(--gold)]" />
          ) : (
            <ShieldAlert className="h-4 w-4 text-destructive" />
          )}
          <span className="font-semibold">{stateLabel}</span>
          {/* Le masque de clé est du contenu LTR dans un contexte RTL (é29 §2.5). */}
          <span dir="ltr" className="font-mono text-xs text-muted-foreground">
            {t.ai.keyMasked.replace("{last4}", `sk-…${credential.last4}`)}
          </span>
        </span>
        <span className="flex gap-2">
          <button type="button" onClick={onReplace} className={ACTION_CLASS}>
            {t.ai.replace}
          </button>
          <button
            type="button"
            onClick={() => setConfirmOpen(true)}
            data-testid="ai-revoke"
            className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-destructive/50 px-3 py-1.5 text-xs font-semibold text-destructive transition hover:bg-destructive/10"
          >
            <Trash2 className="h-3.5 w-3.5" />
            {t.ai.revoke}
          </button>
        </span>
      </div>

      {/* Annexe C : un code stable, traduit ici. Jamais le message du fournisseur. */}
      {credential.hasError && (
        <p className="rounded-lg border border-destructive/40 bg-destructive/5 px-3 py-2 text-xs text-destructive">
          {aiErrorLabel(credential.lastErrorCode, t)}
        </p>
      )}

      {/* LES MODÈLES, RÉGLABLES SANS RECOLLER LA CLÉ (2026-08-28).
          R-4 rend la clé irrécupérable — corriger un identifiant de modèle
          imposait donc de la ressaisir en entier, sur le geste le plus courant
          qui soit : quitter un modèle à raisonnement, trop lent pour répondre
          devant un élève. Le serveur re-vérifie avec la clé du COFFRE, si bien
          que l'invariant du §5 tient — rien n'est écrit qui n'ait répondu.

          Un bouton, et pas un `onBlur` comme les plafonds juste dessous : celui-ci
          émet un appel facturé au fournisseur, et on ne facture pas quelqu'un
          parce qu'il a cliqué à côté d'un champ. */}
      <div className="mt-4 border-t border-border/50 pt-3">
        <span className="block font-semibold">{t.ai.modelsTitle}</span>
        <span className="block text-xs text-muted-foreground">{t.ai.modelsHint}</span>
        <div className="mt-2 grid gap-x-4 sm:grid-cols-2">
          <Field label={t.ai.modelFast}>
            <Input
              dir="ltr"
              value={modelFast}
              onChange={(e) => setModelFast(e.target.value)}
              disabled={busy}
              data-testid="ai-saved-model-fast"
              className={FIELD_CLASS}
            />
          </Field>
          <Field label={t.ai.modelRich}>
            <Input
              dir="ltr"
              value={modelRich}
              onChange={(e) => setModelRich(e.target.value)}
              disabled={busy}
              data-testid="ai-saved-model-rich"
              className={FIELD_CLASS}
            />
          </Field>
        </div>
        <button
          type="button"
          onClick={() => void saveModels()}
          disabled={busy || !modelsChanged}
          data-testid="ai-save-models"
          className={`${ACTION_CLASS} mt-2`}
        >
          {busy ? t.ai.saving : t.ai.modelsSave}
        </button>
      </div>

      {/* Les plafonds de consommation. Décision du 2026-08-22 : ils ne coupent
          plus par défaut. L'interrupteur est posé AVANT les montants parce qu'il
          change ce que ces montants VEULENT DIRE — un plafond ou un repère. */}
      <div className="mt-4 flex items-start justify-between gap-3 border-t border-border/50 pt-3">
        <span>
          <span className="block font-semibold">{t.ai.limitsTitle}</span>
          <span className="block text-xs text-muted-foreground">
            {limitsEnforced ? t.ai.limitsOnHint : t.ai.limitsOffHint}
          </span>
        </span>
        <Switch
          checked={limitsEnforced}
          disabled={busy}
          data-testid="ai-limits-enforced"
          onCheckedChange={(next) => {
            setLimitsEnforced(next);
            void persist({ limitsEnforced: next });
          }}
          aria-label={t.ai.limitsTitle}
        />
      </div>

      <div className="grid gap-x-4 sm:grid-cols-2">
        <Field label={limitsEnforced ? t.ai.dailyBudget : t.ai.dailyReference}>
          <Input
            type="number"
            inputMode="decimal"
            dir="ltr"
            min={0.01}
            step={0.5}
            value={daily}
            onChange={(e) => setDaily(e.target.value)}
            onBlur={() => void persist()}
            disabled={busy}
            data-testid="ai-daily-budget"
            className={FIELD_CLASS}
          />
        </Field>
        <Field
          label={limitsEnforced ? t.ai.monthlyBudget : t.ai.monthlyReference}
          hint={limitsEnforced ? t.ai.budgetHint : t.ai.budgetReferenceHint}
        >
          <Input
            type="number"
            inputMode="decimal"
            dir="ltr"
            min={0.01}
            step={1}
            value={monthly}
            onChange={(e) => setMonthly(e.target.value)}
            onBlur={() => void persist()}
            disabled={busy}
            data-testid="ai-monthly-budget"
            className={FIELD_CLASS}
          />
        </Field>
      </div>

      {/* R-12 : la mention de renvoi au fournisseur est PERMANENTE, pas une note
          de bas de page. Elle est ici, sous les montants, pas en fin d'écran. */}
      <p className="mt-2 text-xs text-muted-foreground">
        {t.ai.estimateNotice} {t.ai.pricesAsOf.replace("{date}", AI_MODEL_PRICES_AS_OF)}
      </p>

      {/* R-18bis : couper la double résolution est un geste délibéré, et le
          risque est énoncé en UNE phrase, à côté de l'interrupteur. */}
      <div className="mt-4 flex items-start justify-between gap-3 border-t border-border/50 pt-3">
        <span>
          <span className="block font-semibold">{t.ai.doubleSolve}</span>
          <span className="block text-xs text-muted-foreground">
            {doubleSolve ? t.ai.doubleSolveHint : t.ai.doubleSolveWarning}
          </span>
        </span>
        <Switch
          checked={doubleSolve}
          disabled={busy}
          data-testid="ai-double-solve"
          onCheckedChange={(next) => {
            setDoubleSolve(next);
            void persist({ doubleSolve: next });
          }}
          aria-label={t.ai.doubleSolve}
        />
      </div>

      {/* US-7 : la dépense, réservée au PORTEUR (R-14b). Elle vient AVANT les
          activations : « combien ça me coûte » est la question qu'on se pose en
          ouvrant cet écran, « qui y a droit » celle qu'on règle une fois. */}
      {credential.status === "active" && <AiSpendPanel />}

      {/* US-3 : l'activation par élève. Elle n'apparaît qu'une fois la clé
          ACTIVE — activer un élève sur une clé refusée produirait une surface
          qui échoue au premier clic, ce que é11 R-15 interdit. */}
      {credential.status === "active" && <AiStudentsPanel />}

      <AlertDialog open={confirmOpen} onOpenChange={(next) => !busy && setConfirmOpen(next)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>{t.ai.revokeTitle}</AlertDialogTitle>
            <AlertDialogDescription>
              {t.ai.revokeBody} {/* US-8 : l'écran rappelle le geste qui compte vraiment. */}
              <strong className="text-destructive">{t.ai.revokeAtProvider}</strong>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={busy}>{t.ai.revokeCancel}</AlertDialogCancel>
            <AlertDialogAction
              disabled={busy}
              data-testid="ai-revoke-confirm"
              onClick={(e) => {
                e.preventDefault();
                setBusy(true);
                void revoke()
                  .then(() => {
                    toast.success(t.ai.revoked);
                    setConfirmOpen(false);
                    onChanged();
                  })
                  .catch(() => toast.error(t.ai.errGeneric))
                  .finally(() => setBusy(false));
              }}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {t.ai.revokeConfirm}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

/**
 * Le préréglage qui DÉCRIT la clé en place, pour rouvrir le formulaire dessus.
 *
 * Un fournisseur nommé se retrouve par son identifiant ; un compatible OpenAI se
 * reconnaît à son adresse, et retombe sur « Autre » quand elle n'est celle
 * d'aucun préréglage — ce qui est le cas nominal de la porte de Q-4, pas un
 * échec.
 */
function presetForCredential(credential: AiModeStatus["credential"]): AiProviderPreset {
  if (!credential) return AI_PROVIDER_PRESETS[0];
  if (credential.provider !== "openai_compatible") {
    return (
      AI_PROVIDER_PRESETS.find((p) => p.provider === credential.provider) ?? AI_PROVIDER_PRESETS[0]
    );
  }
  return (
    AI_PROVIDER_PRESETS.find((p) => p.baseUrl && p.baseUrl === credential.baseUrl) ??
    presetById("custom") ??
    AI_PROVIDER_PRESETS[0]
  );
}

/** US-1 : consentement → fournisseur → clé → modèles → plafonds → « Vérifier et enregistrer ». */
function AttachForm({
  status,
  onDone,
  onCancel,
}: {
  status: AiModeStatus;
  onDone: () => void;
  onCancel: () => void;
}) {
  const t = useT();
  const save = useServerFn(setAiCredential);

  /**
   * REMPLACER, C'EST PARTIR DE L'EXISTANT — pas d'une page blanche.
   *
   * Le formulaire s'ouvrait sur `anthropic` et les modèles d'Anthropic, quel que
   * soit le fournisseur en place : un porteur qui remplaçait une clé xAI
   * atterrissait sur un formulaire Claude, et devait tout retrouver de tête —
   * fournisseur, adresse, deux identifiants de modèle, deux plafonds. Signalé
   * le 2026-08-28 avec le reste (« ne me donne pas la main »).
   *
   * Le SECRET, lui, reste vide, et c'est la seule chose qui ne se pré-remplit
   * pas : R-4 le rend irrécupérable, et c'est justement ce qu'on veut ici.
   */
  const current = status.credential;
  const initialPreset = presetForCredential(current);
  const [presetId, setPresetId] = useState(initialPreset.id);
  const preset = presetById(presetId) ?? AI_PROVIDER_PRESETS[0];
  const provider: AiProviderId = preset.provider;
  const [baseUrl, setBaseUrl] = useState(current?.baseUrl ?? initialPreset.baseUrl ?? "");
  const [secret, setSecret] = useState("");
  const [modelFast, setModelFast] = useState(
    current?.modelFast ?? AI_PROVIDER_PRESETS[0].models!.fast,
  );
  const [modelRich, setModelRich] = useState(
    current?.modelRich ?? AI_PROVIDER_PRESETS[0].models!.rich,
  );
  const [daily, setDaily] = useState(
    String(current?.dailyBudgetUsd ?? AI_DEFAULT_BUDGETS.dailyUsd),
  );
  const [monthly, setMonthly] = useState(
    String(current?.monthlyBudgetUsd ?? AI_DEFAULT_BUDGETS.monthlyUsd),
  );
  const [consent, setConsent] = useState(false);
  const [adult, setAdult] = useState(false);
  const [busy, setBusy] = useState(false);

  /**
   * Choisir un préréglage remplit l'adresse et les modèles — il ne les VERROUILLE
   * pas : les deux champs restent éditables juste en dessous. « Autre » ne
   * remplit rien, et c'est la porte de Q-4 (adresse libre) restée grande ouverte.
   */
  function pickPreset(next: AiProviderPreset) {
    setPresetId(next.id);
    setBaseUrl(next.baseUrl ?? "");
    if (next.models) {
      setModelFast(next.models.fast);
      setModelRich(next.models.rich);
    } else {
      setModelFast("");
      setModelRich("");
    }
  }

  // R-20 : le consentement est PRÉALABLE. R-2a : la confirmation d'adulte l'est
  // aussi quand le niveau du compte l'exige. Le bouton ne s'arme pas avant.
  const ready =
    consent &&
    (!status.requiresAdultConfirmation || adult) &&
    secret.length >= 8 &&
    (provider === "anthropic" || baseUrl.startsWith("https://"));

  async function submit() {
    if (!ready || busy) return;
    setBusy(true);
    try {
      await save({
        data: {
          provider,
          baseUrl: provider === "openai_compatible" ? baseUrl : null,
          modelFast,
          modelRich,
          secret,
          dailyBudgetUsd: Number(daily),
          monthlyBudgetUsd: Number(monthly),
          doubleSolve: true,
          consentVersion: status.consentVersion,
          adultPresent: adult,
        },
      });
      toast.success(t.ai.saved);
      setSecret("");
      onDone();
    } catch (error) {
      const code = aiModeErrorCode(error instanceof Error ? error.message : String(error));
      toast.error(aiErrorLabel(code, t));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div
      className="mt-2 rounded-xl border border-border/60 bg-background/40 p-3"
      data-testid="ai-form"
    >
      {/* R-20 : le texte est versionné, et il vise un lecteur de 15 ans — depuis
          Q-2, celui qui signe peut être mineur (registre é15). */}
      <p className="text-sm font-semibold">{t.ai.consentTitle}</p>
      <ul className="mt-1 list-disc space-y-1 ps-5 text-xs text-muted-foreground">
        <li>{t.ai.consentSent}</li>
        <li>{t.ai.consentNotSent}</li>
        <li>{t.ai.consentShared}</li>
        <li>{t.ai.consentProvider}</li>
        <li className="font-semibold text-foreground">{t.ai.consentMoney}</li>
      </ul>
      <label className="mt-2 flex items-center gap-2 text-sm">
        <input
          type="checkbox"
          checked={consent}
          onChange={(e) => setConsent(e.target.checked)}
          data-testid="ai-consent"
          className="h-4 w-4"
        />
        {t.ai.consentAccept}
      </label>

      {/* R-2a — l'avertissement est calibré sur le niveau scolaire RÉEL du compte,
          pas sur une case « je certifie être majeur » que personne ne lit. */}
      {status.requiresAdultConfirmation && (
        <div className="mt-3 rounded-lg border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/5 p-2">
          <p className="flex items-center gap-1.5 text-xs font-semibold">
            <TriangleAlert className="h-3.5 w-3.5 text-[color:var(--gold)]" />
            {t.ai.adultTitle}
          </p>
          <label className="mt-1 flex items-center gap-2 text-xs">
            <input
              type="checkbox"
              checked={adult}
              onChange={(e) => setAdult(e.target.checked)}
              data-testid="ai-adult"
              className="h-4 w-4"
            />
            {t.ai.adultConfirm}
          </label>
        </div>
      )}

      {/* Les fournisseurs sont NOMMÉS. Le moteur acceptait déjà n'importe quelle
          adresse compatible (Q-4), mais l'écran n'affichait que « Compatible
          OpenAI » : un porteur y lisait, à raison, que le produit ne connaissait
          que deux fournisseurs. Un préréglage ne restreint rien — il montre. */}
      <Field label={t.ai.provider} hint={t.ai.providerHint}>
        <span className="mt-1 flex flex-wrap gap-2">
          {AI_PROVIDER_PRESETS.map((p) => (
            <button
              key={p.id}
              type="button"
              onClick={() => pickPreset(p)}
              data-testid={`ai-preset-${p.id}`}
              className={`min-h-11 rounded-lg border px-3 py-1.5 text-xs font-semibold transition ${
                presetId === p.id
                  ? "border-[color:var(--gold)] bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
                  : "border-border/60 text-muted-foreground hover:bg-accent"
              }`}
            >
              {/* Un nom de marque ne se traduit pas, et se lit LTR même en arabe. */}
              <span dir="ltr">{p.label}</span>
            </button>
          ))}
        </span>
      </Field>

      {provider === "openai_compatible" && (
        <Field label={t.ai.baseUrl} hint={`${t.ai.baseUrlHint} ${t.ai.localModelWarning}`}>
          <Input
            type="url"
            dir="ltr"
            value={baseUrl}
            onChange={(e) => setBaseUrl(e.target.value)}
            placeholder="https://api.example.com/v1"
            data-testid="ai-base-url"
            className={FIELD_CLASS}
          />
        </Field>
      )}

      <Field label={t.ai.keyLabel} hint={t.ai.keyHint}>
        <Input
          type="password"
          dir="ltr"
          autoComplete="off"
          value={secret}
          onChange={(e) => setSecret(e.target.value)}
          data-testid="ai-secret"
          className={FIELD_CLASS}
        />
      </Field>

      <div className="grid gap-x-4 sm:grid-cols-2">
        <Field label={t.ai.modelFast} hint={`${t.ai.modelCurated} · ${t.ai.modelFree}`}>
          <Input
            list="ai-models"
            dir="ltr"
            value={modelFast}
            onChange={(e) => setModelFast(e.target.value)}
            data-testid="ai-model-fast"
            className={FIELD_CLASS}
          />
        </Field>
        <Field label={t.ai.modelRich}>
          <Input
            list="ai-models"
            dir="ltr"
            value={modelRich}
            onChange={(e) => setModelRich(e.target.value)}
            data-testid="ai-model-rich"
            className={FIELD_CLASS}
          />
        </Field>
      </div>
      {/* D-11 : la liste curée est une PROPOSITION. La saisie libre reste ouverte
          — c'est sa clé, son choix (et Q-4 a ouvert l'adresse en conséquence). */}
      <datalist id="ai-models">
        {preset.suggested.map((model) => (
          <option key={model} value={model} />
        ))}
      </datalist>

      <div className="grid gap-x-4 sm:grid-cols-2">
        <Field label={t.ai.dailyReference}>
          <Input
            type="number"
            dir="ltr"
            inputMode="decimal"
            min={0.01}
            step={0.5}
            value={daily}
            onChange={(e) => setDaily(e.target.value)}
            className={FIELD_CLASS}
          />
        </Field>
        <Field label={t.ai.monthlyReference} hint={t.ai.budgetReferenceHint}>
          <Input
            type="number"
            dir="ltr"
            inputMode="decimal"
            min={0.01}
            step={1}
            value={monthly}
            onChange={(e) => setMonthly(e.target.value)}
            className={FIELD_CLASS}
          />
        </Field>
      </div>

      <p className="mt-2 text-xs text-muted-foreground">{t.ai.estimateNotice}</p>

      <div className="mt-3 flex flex-wrap gap-2">
        <button
          type="button"
          onClick={() => void submit()}
          disabled={!ready || busy}
          data-testid="ai-save"
          className={ACTION_CLASS}
        >
          <KeyRound className="h-3.5 w-3.5" />
          {busy ? t.ai.saving : t.ai.save}
        </button>
        <button type="button" onClick={onCancel} disabled={busy} className={ACTION_CLASS}>
          {t.ai.cancel}
        </button>
      </div>
    </div>
  );
}
