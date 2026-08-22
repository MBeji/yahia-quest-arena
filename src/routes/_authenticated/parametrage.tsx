import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState, type ReactNode } from "react";
import {
  Bell,
  BrainCircuit,
  Check,
  ChevronRight,
  Copy,
  KeyRound,
  LogOut,
  Map,
  Monitor,
  Pencil,
  ScrollText,
  Shield,
  Sparkles,
  Trash2,
  TriangleAlert,
  UserCircle,
} from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { toast } from "sonner";

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
import { PageShell } from "@/components/ui/page-shell";
import { ThemeChoice, LocaleChoice, SoundToggles } from "@/components/ui/settings-controls";
import {
  accountDeleteErrorLabel,
  confirmsAccountEmail,
  deleteAccount,
  DISPLAY_NAME_MAX_LENGTH,
  isValidDisplayName,
  updateDisplayName,
  useAuth,
  useMyRole,
} from "@/features/auth";
import { getParcours } from "@/features/dashboard";
import { EnablePushCard } from "@/features/notifications";
import { AiModeSection } from "@/features/ai/components/ai-mode-section";
import { formatStudentAllianceCode } from "@/features/parent-report";
import { useI18n, useT } from "@/lib/i18n";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { supabase } from "@/shared/integrations/supabase/client";

/**
 * Paramétrage — le pôle unique des réglages.
 *
 * Avant lui, ce que l'application appelait « ses paramètres » était éparpillé :
 * trois pop-over dans le header (langue, thème, son), le consentement aux
 * notifications en carte au milieu du tableau de bord, le code d'alliance dans le
 * bloc héros, l'avatar dans la Boutique, la déconnexion en bouton de barre — et
 * le parcours actif, lui, ne se changeait que par un CTA du catalogue public, sans
 * qu'aucun écran ne le présente comme un réglage.
 *
 * Cinq sections, une par intention. La page suit le patron de `/arene` (étude 15,
 * lot 5) : une page-pôle légère qui maille des surfaces qui s'ignoraient.
 */
export const Route = createFileRoute("/_authenticated/parametrage")({
  head: () => ({ meta: [{ title: "Paramétrage · Na9ra Nal3ab" }] }),
  component: ParametragePage,
});

function Section({
  Icon,
  title,
  desc,
  children,
}: {
  Icon: LucideIcon;
  title: string;
  desc: string;
  children: ReactNode;
}) {
  return (
    <section className="rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-4 backdrop-blur-md sm:p-5">
      <header className="mb-2 flex items-start gap-3">
        <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15">
          <Icon className="h-5 w-5 text-[color:var(--gold)]" />
        </div>
        <div className="min-w-0">
          <h2 className="font-display text-lg font-bold">{title}</h2>
          <p className="text-sm text-muted-foreground">{desc}</p>
        </div>
      </header>
      {children}
    </section>
  );
}

/**
 * Une ligne « intitulé → valeur/action », la maille de base des sections.
 *
 * `hint` est la note qui passe sous la ligne, sur toute sa largeur : une valeur
 * que l'élève doit COMPRENDRE avant d'en faire quelque chose (le code d'alliance)
 * ne peut pas tenir dans l'intitulé sans écraser la maille des voisines.
 */
function Row({ label, hint, children }: { label: string; hint?: string; children: ReactNode }) {
  return (
    <div className="flex min-h-11 flex-wrap items-center justify-between gap-2 border-t border-border/50 py-2.5 first:border-t-0">
      <span className="text-sm text-muted-foreground">{label}</span>
      <span className="flex min-w-0 items-center gap-2 text-sm font-semibold text-foreground">
        {children}
      </span>
      {hint && <span className="basis-full text-xs font-normal text-muted-foreground">{hint}</span>}
    </div>
  );
}

const ACTION_CLASS =
  "inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10";

/**
 * Le pseudo — le seul réglage de cette page qui s'écrit au lieu de se choisir.
 *
 * Il était jusqu'ici fixé une fois pour toutes à l'inscription : aucun écran ne
 * le reprenait, alors que le tableau de bord, la Boutique et le suivi parent
 * l'affichent tous les trois. Édition en place plutôt qu'en boîte de dialogue :
 * une modale pour un champ de texte coûterait plus d'attention qu'elle n'en
 * économise, et la ligne garde ainsi la même maille que ses voisines.
 *
 * La validation est celle de l'inscription — littéralement la même, importée de
 * `@/features/auth` — donc l'écran ne peut pas refuser un pseudo que la création
 * de compte, elle, aurait accepté.
 */
function PseudoRow() {
  const t = useT();
  const { user } = useAuth();
  const { displayName } = useMyRole();
  const queryClient = useQueryClient();
  const rename = useServerFn(updateDisplayName);
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState("");
  const [saving, setSaving] = useState(false);

  const valid = isValidDisplayName(draft);

  async function save() {
    if (!valid || saving) return;
    setSaving(true);
    try {
      await rename({ data: { displayName: draft } });
      // Le pseudo se lit à deux endroits : la ligne ci-dessus (`me-role`) et le
      // profil complet que le tableau de bord ET la Boutique partagent sous la
      // clé `dashboard`. Sans cette seconde invalidation, la page de réglages
      // affiche le nouveau nom pendant que le hall montre encore l'ancien.
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["me-role", user?.id] }),
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
      ]);
      toast.success(t.settings.pseudoSaved);
      setEditing(false);
    } catch {
      toast.error(t.settings.pseudoError);
    } finally {
      setSaving(false);
    }
  }

  if (!editing) {
    return (
      <Row label={t.auth.heroNameLabel}>
        <span className="truncate" data-testid="settings-pseudo">
          {displayName ?? "—"}
        </span>
        <button
          type="button"
          onClick={() => {
            setDraft(displayName ?? "");
            setEditing(true);
          }}
          data-testid="settings-pseudo-edit"
          className={ACTION_CLASS}
        >
          <Pencil className="h-3.5 w-3.5" />
          {t.settings.pseudoAction}
        </button>
      </Row>
    );
  }

  return (
    <Row label={t.auth.heroNameLabel}>
      <span className="flex flex-wrap items-center justify-end gap-2">
        <input
          type="text"
          autoFocus
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          // Entrée valide, Échap annule : le champ vit dans une ligne, pas dans un
          // <form> — celui-ci ne serait pas du contenu valide à l'intérieur du
          // <span> de la ligne, et une modale coûterait plus qu'elle ne rapporte.
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              e.preventDefault();
              void save();
            } else if (e.key === "Escape") {
              setEditing(false);
            }
          }}
          maxLength={DISPLAY_NAME_MAX_LENGTH}
          disabled={saving}
          aria-label={t.auth.heroNameLabel}
          aria-invalid={!valid}
          aria-describedby="settings-pseudo-rule"
          data-testid="settings-pseudo-input"
          className="min-h-11 w-40 rounded-lg border border-input bg-background/60 px-3 py-1.5 text-sm focus:border-gold focus:outline-none sm:w-56"
        />
        <button
          type="button"
          onClick={() => void save()}
          disabled={!valid || saving}
          data-testid="settings-pseudo-save"
          className={`${ACTION_CLASS} disabled:opacity-50`}
        >
          <Check className="h-3.5 w-3.5" />
          {t.settings.pseudoSave}
        </button>
        <button
          type="button"
          onClick={() => setEditing(false)}
          disabled={saving}
          data-testid="settings-pseudo-cancel"
          className={`${ACTION_CLASS} disabled:opacity-50`}
        >
          {t.settings.pseudoCancel}
        </button>
        <span
          id="settings-pseudo-rule"
          className="basis-full text-end text-xs font-normal text-muted-foreground"
        >
          {t.settings.pseudoRule.replace("{max}", String(DISPLAY_NAME_MAX_LENGTH))}
        </span>
      </span>
    </Row>
  );
}

function ParametragePage() {
  const t = useT();
  const { locale } = useI18n();
  const { user } = useAuth();
  const { role, currentParcoursId } = useMyRole();
  const navigate = useNavigate();
  const [copied, setCopied] = useState(false);
  const [sendingReset, setSendingReset] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [typedEmail, setTypedEmail] = useState("");
  const [deleting, setDeleting] = useState(false);
  const runDeleteAccount = useServerFn(deleteAccount);

  // Le nom du parcours actif se lit dans le catalogue (requête anonyme déjà en
  // cache pour tout visiteur du programme) — pas de requête dédiée.
  const fetchParcours = useServerFn(getParcours);
  const { data: catalogue } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
    staleTime: 5 * 60_000,
  });
  const current = catalogue?.parcours.find((p) => p.id === currentParcoursId) ?? null;

  // Le code d'alliance est une pure fonction de l'identifiant : rien à charger — et c'est
  // précisément pourquoi il n'a pas besoin du tableau de bord. Il s'y affichait en double,
  // en position 2 du bloc héros, à CHAQUE session d'un élève, pour un geste qui se fait une
  // fois et qui appartient au parent (audit étude 15, constat [MOYEN] de C-1). Le hall n'en
  // porte plus de copie : cette ligne est le seul endroit où un élève lit son code.
  const allianceCode = role === "student" && user ? formatStudentAllianceCode(user.id) : "";

  async function signOut() {
    await supabase.auth.signOut();
    toast.success(t.layout.logoutToast);
    navigate({ to: "/" });
  }

  // Changer de mot de passe depuis un compte connecté : `/auth` renvoie tout
  // utilisateur authentifié sur le tableau de bord, donc un lien vers l'écran
  // « mot de passe oublié » serait mort. On déclenche l'envoi ici, sur l'adresse
  // du compte lui-même, avec la même redirection que cet écran.
  async function sendPasswordReset() {
    if (!user?.email) return;
    setSendingReset(true);
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(user.email, {
        redirectTo: `${window.location.origin}/auth/reset`,
      });
      if (error) throw error;
      toast.success(t.settings.passwordSent);
    } catch {
      toast.error(t.settings.passwordError);
    } finally {
      setSendingReset(false);
    }
  }

  // La MÊME fonction pure que la garde serveur (`confirmsAccountEmail`) : le bouton
  // ne peut pas s'armer sur une saisie que le serveur refuserait, ni l'inverse.
  const confirmed = confirmsAccountEmail(typedEmail, user?.email ?? null);

  async function confirmDeleteAccount() {
    if (!confirmed || deleting) return;
    setDeleting(true);
    try {
      await runDeleteAccount({ data: { confirmEmail: typedEmail } });
      // Le compte n'existe plus : la session locale ne pointe vers rien. On la
      // vide AVANT de naviguer, sinon le garde d'authentification renverrait vers
      // un tableau de bord que plus aucune requête ne peut servir.
      await supabase.auth.signOut();
      setDeleteOpen(false);
      toast.success(t.settings.deleteDone);
      navigate({ to: "/" });
    } catch (error) {
      toast.error(
        accountDeleteErrorLabel(error instanceof Error ? error.message : String(error), t),
      );
      setDeleting(false);
    }
  }

  return (
    <PageShell width="reading" className="py-8">
      <header className="mb-6">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">{t.settings.title}</h1>
        <p className="mt-2 text-muted-foreground">{t.settings.subtitle}</p>
      </header>

      <div className="grid gap-3">
        <Section Icon={UserCircle} title={t.settings.accountTitle} desc={t.settings.accountDesc}>
          <PseudoRow />
          <Row label={t.settings.email}>
            <span className="truncate">{user?.email ?? "—"}</span>
          </Row>
          <Row label={t.settings.avatar}>
            <Link to="/boutique" className={ACTION_CLASS}>
              <Sparkles className="h-3.5 w-3.5" />
              {t.settings.avatarAction}
            </Link>
          </Row>
          {allianceCode && (
            <Row label={t.settings.allianceCode} hint={t.settings.allianceHint}>
              <span className="font-mono text-xs">{allianceCode}</span>
              <button
                type="button"
                onClick={async () => {
                  await navigator.clipboard.writeText(allianceCode);
                  setCopied(true);
                  setTimeout(() => setCopied(false), 1200);
                }}
                className={ACTION_CLASS}
              >
                {copied ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />}
                {copied ? t.settings.allianceCopied : t.settings.allianceCopy}
              </button>
            </Row>
          )}
          <Row label={t.settings.password}>
            <button
              type="button"
              onClick={sendPasswordReset}
              disabled={sendingReset || !user?.email}
              className={`${ACTION_CLASS} disabled:opacity-50`}
            >
              <KeyRound className="h-3.5 w-3.5" />
              {t.settings.passwordAction}
            </button>
          </Row>
          <Row label={t.layout.signOut}>
            <button
              type="button"
              onClick={signOut}
              data-testid="settings-sign-out"
              className={ACTION_CLASS}
            >
              <LogOut className="h-3.5 w-3.5" />
              {t.layout.signOut}
            </button>
          </Row>
        </Section>

        {/* Élève seulement : un parent ne s'inscrit JAMAIS à un parcours — le garde
            d'onboarding l'en exempte explicitement. Lui montrer « aucun parcours
            actif » et un bouton pour en changer inventerait un réglage qui n'existe
            pas pour lui, et le renverrait vers un catalogue qui ne le concerne pas. */}
        {role === "student" && (
          <Section Icon={Map} title={t.settings.parcoursTitle} desc={t.settings.parcoursDesc}>
            <Row label={t.settings.parcoursCurrent}>
              <span className="truncate">
                {current ? parcoursName(current, locale) : t.settings.parcoursNone}
              </span>
            </Row>
            <Row label={t.settings.parcoursChange}>
              <Link to="/programme" className={ACTION_CLASS}>
                {t.settings.parcoursChange}
                <ChevronRight className="h-3.5 w-3.5 rtl:-scale-x-100" />
              </Link>
            </Row>
          </Section>
        )}

        <Section Icon={Monitor} title={t.settings.displayTitle} desc={t.settings.displayDesc}>
          <ThemeChoice />
          <LocaleChoice />
        </Section>

        <Section Icon={Bell} title={t.settings.soundTitle} desc={t.settings.soundDesc}>
          <SoundToggles />
          <EnablePushCard />
        </Section>

        {/* Mode IA (étude 29 lot 2, D-16) : la clé d'API est un réglage de compte,
            et c'est ici qu'elle se saisit — pas sur une page à elle, introuvable
            pour qui ne sait pas déjà qu'elle existe.

            La section se rend elle-même INVISIBLE quand le mode famille n'est pas
            disponible (R-1) : pas de bouton grisé, pas de « bientôt ». Le
            <Section> qui l'enveloppe disparaît donc avec elle — sinon un
            en-tête vide annoncerait une fonctionnalité absente, ce qui est
            exactement ce que R-1 interdit. */}
        <AiModeSection
          render={(children) => (
            <Section Icon={BrainCircuit} title={t.ai.sectionTitle} desc={t.ai.sectionDesc}>
              {children}
            </Section>
          )}
        />

        <Section Icon={ScrollText} title={t.settings.helpTitle} desc={t.settings.helpDesc}>
          <Row label={t.settings.helpTerms}>
            <Link to="/conditions" className={ACTION_CLASS}>
              <ScrollText className="h-3.5 w-3.5" />
              {t.settings.helpTerms}
            </Link>
          </Row>
          <Row label={t.settings.helpPrivacy}>
            <Link to="/confidentialite" className={ACTION_CLASS}>
              <Shield className="h-3.5 w-3.5" />
              {t.settings.helpPrivacy}
            </Link>
          </Row>
        </Section>

        {/* La suppression de compte ferme la moitié « droits des personnes » de
            GAP-024. Elle est en DERNIÈRE section, et la seule à porter la couleur
            destructive : une action irréversible ne se présente pas comme un
            réglage parmi d'autres. La page confidentialité promettait déjà cet
            effacement — c'est ici qu'il devient un geste. */}
        <Section Icon={TriangleAlert} title={t.settings.dangerTitle} desc={t.settings.dangerDesc}>
          {/* L'intitulé nomme l'EFFET, le bouton nomme le geste — comme partout
              ailleurs sur cette page (« Mot de passe » → « Recevoir un lien »).
              Répéter « Supprimer mon compte » des deux côtés aurait fait de la
              ligne un écho, et perdu la seule chose qu'elle a à ajouter : que
              l'effacement est définitif. */}
          <Row label={t.settings.deleteRowLabel}>
            <button
              type="button"
              onClick={() => {
                setTypedEmail("");
                setDeleteOpen(true);
              }}
              data-testid="settings-delete-account"
              className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-destructive/50 px-3 py-1.5 text-xs font-semibold text-destructive transition hover:bg-destructive/10"
            >
              <Trash2 className="h-3.5 w-3.5" />
              {t.settings.deleteAccount}
            </button>
          </Row>
        </Section>
      </div>

      <AlertDialog
        open={deleteOpen}
        onOpenChange={(next) => {
          // Pendant l'appel, la boîte reste : la fermer laisserait croire à une
          // annulation alors que la suppression est déjà partie.
          if (deleting) return;
          setDeleteOpen(next);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>{t.settings.deleteDialogTitle}</AlertDialogTitle>
            <AlertDialogDescription>
              {/* Un parent n'a ni XP, ni séries, ni duels : lui lire l'inventaire
                  d'un élève inventerait une perte qu'il ne subit pas, et tairait
                  la seule qui le concerne — le lien avec ses enfants. Même règle
                  que la section « Mon parcours », masquée pour lui plus haut. */}
              {role === "parent" ? t.settings.deleteDialogWhatParent : t.settings.deleteDialogWhat}{" "}
              <strong className="text-destructive">{t.settings.deleteDialogFinal}</strong>
            </AlertDialogDescription>
          </AlertDialogHeader>

          <label className="block text-sm">
            <span className="text-muted-foreground">{t.settings.deleteConfirmLabel}</span>
            <Input
              type="email"
              autoComplete="off"
              value={typedEmail}
              disabled={deleting}
              onChange={(e) => setTypedEmail(e.target.value)}
              placeholder={user?.email ?? ""}
              data-testid="settings-delete-confirm-email"
              className="mt-1.5"
              dir="ltr"
            />
          </label>

          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>{t.settings.deleteCancel}</AlertDialogCancel>
            <AlertDialogAction
              // Radix ferme la boîte au clic : on l'en empêche, sinon elle
              // disparaîtrait pendant l'appel et une erreur n'aurait plus où s'afficher.
              onClick={(e) => {
                e.preventDefault();
                void confirmDeleteAccount();
              }}
              disabled={!confirmed || deleting}
              data-testid="settings-delete-confirm"
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {deleting ? t.settings.deleteBusy : t.settings.deleteConfirm}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </PageShell>
  );
}
