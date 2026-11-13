import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 40, lot 5 — « INVITER MON PARENT » : la carte de l'écran de résultat (R-20), sa place dans
 * l'ordre des invitations (R-12), ce qui part par chaque canal (R-19) et ce qui est mesuré.
 */
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));
const toastSuccess = vi.fn();
vi.mock("sonner", () => ({ toast: { success: (...a: unknown[]) => toastSuccess(...a) } }));

import { I18nProvider } from "@/lib/i18n";
import { STORAGE_KEY as LOCALE_KEY } from "@/lib/i18n/context";
import { arInvite as ar } from "@/lib/i18n/invite/ar";
import { frInvite as fr } from "@/lib/i18n/invite/fr";
import { NUDGE_KEY } from "@/shared/lib/nudge-memory";
import { NudgeSlot, type NudgeCandidate } from "../nudge-slot";
import { useParentInvite } from "../use-parent-invite";
import { useParentInviteCandidate } from "../use-parent-invite-candidate";

const CODE = "1111-1111-1111-4111-8111-1111-1111-1111";
const LINK = `https://www.na9ranal3ab.tn/suivi?code=${CODE}&src=share`;
const TODAY = new Date("2026-11-13T10:00:00Z");

type Facts = { eligible: boolean; allianceCode: string; hasActiveParent: boolean | undefined };
const FACTS: Facts = { eligible: true, allianceCode: CODE, hasActiveParent: false };

/** Un écran de résultat : l'invitation du parent, et au besoin une invitation qui la précède. */
function Screen({ facts, install = false }: { facts: Facts; install?: boolean }) {
  const parent = useParentInviteCandidate(facts);
  const other: NudgeCandidate = {
    kind: "install",
    available: install,
    render: () => <p data-testid="nudge-install" />,
  };
  return <NudgeSlot candidates={[parent, other]} />;
}

function SettingsButton() {
  const invite = useParentInvite(CODE, "settings");
  return (
    <button type="button" onClick={() => void invite()}>
      inviter
    </button>
  );
}

const mount = (facts: Partial<Facts> = {}, install = false) =>
  render(
    <I18nProvider>
      <Screen facts={{ ...FACTS, ...facts }} install={install} />
    </I18nProvider>,
  );

const card = () => screen.queryByTestId("parent-invite");
const memory = (): Record<string, { shown: string; dismissed: number }> =>
  JSON.parse(window.localStorage.getItem(NUDGE_KEY) ?? "{}");

/** Pose (ou retire) les trois canaux de l'appareil. */
function device(parts: { share?: unknown; open?: unknown; writeText?: unknown }) {
  Object.defineProperty(navigator, "share", { value: parts.share, configurable: true });
  Object.defineProperty(navigator, "clipboard", {
    value: parts.writeText ? { writeText: parts.writeText } : undefined,
    configurable: true,
  });
  Object.defineProperty(window, "open", { value: parts.open, configurable: true, writable: true });
}
const originalOpen = window.open;

beforeEach(() => {
  vi.useFakeTimers({ toFake: ["Date"] });
  vi.setSystemTime(TODAY);
  vi.clearAllMocks();
  window.localStorage.clear();
  window.localStorage.setItem(LOCALE_KEY, "fr");
});
afterEach(() => {
  vi.useRealTimers();
  device({ open: originalOpen });
});

describe("R-20 — à qui la carte paraît", () => {
  it("⭐ réussite, élève sans parent lié ⇒ la carte, sans aucun champ de saisie", () => {
    const { container } = mount();
    expect(card()).not.toBeNull();
    expect(screen.getByText(fr.cardTitle)).toBeInTheDocument();
    expect(screen.getByText(fr.hint)).toBeInTheDocument();
    expect(screen.getByTestId("parent-invite-cta")).toHaveTextContent("Inviter mon parent");
    expect(container.querySelector("input, textarea, select, form")).toBeNull();
    expect(memory().parent).toEqual({ shown: "2026-11-13", dismissed: 0 });
  });

  it("⭐ un parent lié ACTIF ⇒ pas de carte, et rien n'est retenu", () => {
    mount({ hasActiveParent: true });
    expect(card()).toBeNull();
    expect(memory()).toEqual({});
  });

  it("⭐ lecture du lien en cours ou en échec ⇒ pas de carte (sens sûr)", () => {
    mount({ hasActiveParent: undefined });
    expect(card()).toBeNull();
  });

  it("R-11 — un échec ⇒ pas de carte", () => {
    mount({ eligible: false });
    expect(card()).toBeNull();
  });

  it("pas de code (parent, admin, profil non lu) ⇒ pas de carte", () => {
    mount({ allianceCode: "" });
    expect(card()).toBeNull();
  });

  it("la carte parle la langue de l'interface, dans son sens d'écriture", async () => {
    window.localStorage.setItem(LOCALE_KEY, "ar");
    mount();
    // Le catalogue arabe se charge à part : la carte suit dès qu'il est là.
    await waitFor(() => expect(card()).toHaveAttribute("dir", "rtl"));
    expect(screen.getByTestId("parent-invite-cta")).toHaveTextContent(ar.cta);
  });
});

describe("R-12 — une seule invitation par écran, le parent en dernier", () => {
  it("⭐ l'installation proposable ⇒ elle seule ; le parent attend", () => {
    mount({}, true);
    expect(screen.getByTestId("nudge-install")).toBeInTheDocument();
    expect(card()).toBeNull();
    expect(Object.keys(memory())).toEqual(["install"]);
  });

  it("déjà montrée il y a moins de 14 jours ⇒ pas de carte", () => {
    window.localStorage.setItem(
      NUDGE_KEY,
      JSON.stringify({ parent: { shown: "2026-11-05", dismissed: 0 } }),
    );
    mount();
    expect(card()).toBeNull();
  });

  it("« Plus tard » ferme la carte et compte un refus ; rien n'est mesuré comme un partage", () => {
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-later"));
    expect(card()).toBeNull();
    expect(memory().parent.dismissed).toBe(1);
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("deux refus ⇒ plus jamais", () => {
    window.localStorage.setItem(
      NUDGE_KEY,
      JSON.stringify({ parent: { shown: "2026-01-01", dismissed: 2 } }),
    );
    mount();
    expect(card()).toBeNull();
  });
});

describe("R-19 — ce qui part, et ce qui est mesuré", () => {
  it("⭐ feuille de partage : le message, le lien du bilan ; l'invitation est réglée", async () => {
    const share = vi.fn().mockResolvedValue(undefined);
    device({ share });
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-cta"));
    await waitFor(() => expect(card()).toBeNull());
    expect(share).toHaveBeenCalledWith({
      text: `👋 Je révise sur Na9ra Nal3ab. Tu peux suivre mon travail ici, sans compte : ${LINK}`,
    });
    expect(trackProductEvent).toHaveBeenCalledWith("content_shared", {
      intent: "parent",
      surface: "result",
      method: "share",
    });
    // Réglée : un refus de plus ne la ramènerait pas, et elle ne revient pas demain.
    expect(memory().parent.dismissed).toBeGreaterThanOrEqual(2);
  });

  it("⭐ zéro donnée personnelle dans l'événement : ni code, ni identifiant", async () => {
    device({ share: vi.fn().mockResolvedValue(undefined) });
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-cta"));
    await waitFor(() => expect(trackProductEvent).toHaveBeenCalled());
    const sent = JSON.stringify(trackProductEvent.mock.calls);
    expect(sent).not.toContain("1111");
    expect(sent).not.toContain("suivi");
    expect(Object.keys(trackProductEvent.mock.calls[0][1] as object).sort()).toEqual([
      "intent",
      "method",
      "surface",
    ]);
  });

  it("feuille fermée par l'élève ⇒ rien ne part, rien n'est compté, la carte reste", async () => {
    const share = vi.fn().mockRejectedValue(Object.assign(new Error("x"), { name: "AbortError" }));
    const open = vi.fn();
    device({ share, open });
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-cta"));
    await waitFor(() => expect(share).toHaveBeenCalled());
    expect(open).not.toHaveBeenCalled();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(card()).not.toBeNull();
  });

  it("sans feuille de partage : WhatsApp, SANS destinataire", async () => {
    const open = vi.fn();
    device({ open });
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-cta"));
    await waitFor(() => expect(open).toHaveBeenCalled());
    const url = new URL(open.mock.calls[0][0] as string);
    expect(`${url.origin}${url.pathname}`).toBe("https://wa.me/");
    expect(url.searchParams.get("text")).toContain(LINK);
    expect(trackProductEvent).toHaveBeenCalledWith(
      "content_shared",
      expect.objectContaining({ intent: "parent", method: "whatsapp" }),
    );
  });

  it("⭐ paramétrage : copie en dernier recours, confirmée — surface `settings`", async () => {
    const writeText = vi.fn().mockResolvedValue(undefined);
    device({ writeText });
    render(
      <I18nProvider>
        <SettingsButton />
      </I18nProvider>,
    );
    fireEvent.click(screen.getByRole("button", { name: "inviter" }));
    await waitFor(() => expect(toastSuccess).toHaveBeenCalledWith(fr.copied));
    expect(writeText.mock.calls[0][0]).toContain(LINK);
    expect(trackProductEvent).toHaveBeenCalledWith("content_shared", {
      intent: "parent",
      surface: "settings",
      method: "copy",
    });
  });

  it("appareil qui ne sait rien faire ⇒ rien n'est compté", async () => {
    device({});
    mount();
    fireEvent.click(screen.getByTestId("parent-invite-cta"));
    await Promise.resolve();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(card()).not.toBeNull();
  });
});
