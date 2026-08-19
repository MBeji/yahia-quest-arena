import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState, type ReactNode } from "react";
import {
  Bell,
  Check,
  ChevronRight,
  Copy,
  KeyRound,
  LogOut,
  Map,
  Monitor,
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
  useAuth,
  useMyRole,
} from "@/features/auth";
import { getParcours } from "@/features/dashboard";
import { EnablePushCard } from "@/features/notifications";
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

/** Une ligne « intitulé → valeur/action », la maille de base des sections. */
function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex min-h-11 flex-wrap items-center justify-between gap-2 border-t border-border/50 py-2.5 first:border-t-0">
      <span className="text-sm text-muted-foreground">{label}</span>
      <span className="flex min-w-0 items-center gap-2 text-sm font-semibold text-foreground">
        {children}
      </span>
    </div>
  );
}

const ACTION_CLASS =
  "inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 px-3 py-1.5 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10";

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

  // Le code d'alliance est une pure fonction de l'identifiant : rien à charger.
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
            <Row label={t.dashboard.allianceCode}>
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
                {copied ? t.dashboard.allianceCopied : t.dashboard.allianceCopy}
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
