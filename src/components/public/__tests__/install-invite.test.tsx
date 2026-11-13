import { act, fireEvent, render, screen } from "@testing-library/react";
import { renderToString } from "react-dom/server";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 40 lot 3 — LA CARTE D'INSTALLATION et l'emplacement d'invitation d'un écran.
 *
 * Les états de la carte : rien / native / ios ; acceptée / refusée / plus tard. Et les règles
 * qu'elle porte : R-11 (après une réussite seulement), R-12 (mémoire commune, une seule
 * invitation par écran), R-13 (bouton ⇒ `prompt()` ; iOS ⇒ deux gestes, sans bouton d'action).
 */
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

type Mode = "native" | "ios" | "none";
const device = vi.hoisted(() => ({
  mode: "none" as "native" | "ios" | "none",
  outcome: "accepted" as "accepted" | "dismissed" | "unavailable",
  listeners: new Set<() => void>(),
}));
const promptInstall = vi.fn(() => {
  // Comme le vrai module : l'événement ne sert qu'une fois.
  setMode("none");
  return Promise.resolve(device.outcome);
});
vi.mock("@/shared/lib/install-prompt", () => ({
  getInstallMode: () => device.mode,
  promptInstall: () => promptInstall(),
  subscribeInstallMode: (listener: () => void) => {
    device.listeners.add(listener);
    return () => device.listeners.delete(listener);
  },
}));

function setMode(mode: Mode) {
  device.mode = mode;
  device.listeners.forEach((listener) => listener());
}

import { I18nProvider } from "@/lib/i18n";
import { STORAGE_KEY as LOCALE_KEY } from "@/lib/i18n/context";
import { NUDGE_KEY } from "@/shared/lib/nudge-memory";
import { InstallNudge } from "../install-nudge";
import { useInstallCandidate } from "../use-install-candidate";
import { NudgeSlot, type NudgeCandidate } from "../nudge-slot";

const TODAY = new Date("2026-11-13T10:00:00Z");
const DAY = 24 * 60 * 60 * 1000;

const memory = (): Record<string, { shown: string; dismissed: number }> =>
  JSON.parse(window.localStorage.getItem(NUDGE_KEY) ?? "{}");

function mount(props: Partial<Parameters<typeof InstallNudge>[0]> = {}) {
  return render(
    <I18nProvider>
      <InstallNudge audience="student" eligible {...props} />
    </I18nProvider>,
  );
}

const card = () => screen.queryByTestId("install-invite");

beforeEach(() => {
  vi.useFakeTimers({ toFake: ["Date"] });
  vi.setSystemTime(TODAY);
  vi.clearAllMocks();
  window.localStorage.clear();
  // Posée à chaque test : la langue choisie par un test précédent survit dans le module i18n.
  window.localStorage.setItem(LOCALE_KEY, "fr");
  device.mode = "none";
  device.outcome = "accepted";
  device.listeners.clear();
});
afterEach(() => {
  vi.useRealTimers();
  vi.restoreAllMocks();
});

describe("R-13 — Chromium, événement reçu : la carte et son bouton", () => {
  it("⭐ réussite + événement reçu ⇒ la carte, texte élève, avec son bouton", () => {
    device.mode = "native";
    mount();
    expect(card()).toHaveAttribute("data-platform", "native");
    expect(screen.getByText("Garde Na9ra Nal3ab sur ton écran d’accueil")).toBeInTheDocument();
    expect(screen.getByTestId("install-invite-cta")).toHaveTextContent("Installer");
    expect(screen.queryByTestId("install-invite-steps")).toBeNull();
  });

  it('⭐ montrée ⇒ `install_invite{action:"shown"}` une seule fois, et la mémoire retient le jour', () => {
    device.mode = "native";
    const { rerender } = mount();
    rerender(
      <I18nProvider>
        <InstallNudge audience="student" eligible />
      </I18nProvider>,
    );
    expect(trackProductEvent).toHaveBeenCalledTimes(1);
    expect(trackProductEvent).toHaveBeenCalledWith("install_invite", {
      action: "shown",
      platform: "native",
      audience: "student",
    });
    expect(memory()).toEqual({ install: { shown: "2026-11-13", dismissed: 0 } });
  });

  it("⭐ bouton ⇒ `prompt()` ; acceptation ⇒ `accepted`, la carte disparaît pour toujours", async () => {
    device.mode = "native";
    device.outcome = "accepted";
    const view = mount();
    await act(async () => {
      fireEvent.click(screen.getByTestId("install-invite-cta"));
    });
    expect(promptInstall).toHaveBeenCalledTimes(1);
    expect(trackProductEvent).toHaveBeenLastCalledWith("install_invite", {
      action: "accepted",
      platform: "native",
      audience: "student",
    });
    expect(card()).toBeNull();
    expect(memory().install.dismissed).toBe(2);

    // Un an plus tard, l'événement de nouveau reçu : toujours rien.
    view.unmount();
    vi.setSystemTime(new Date(TODAY.getTime() + 365 * DAY));
    device.mode = "native";
    mount();
    expect(card()).toBeNull();
  });

  it("⭐ fenêtre du navigateur refermée ⇒ `dismissed`, pas avant 14 jours", async () => {
    device.mode = "native";
    device.outcome = "dismissed";
    const view = mount();
    await act(async () => {
      fireEvent.click(screen.getByTestId("install-invite-cta"));
    });
    expect(trackProductEvent).toHaveBeenLastCalledWith("install_invite", {
      action: "dismissed",
      platform: "native",
      audience: "student",
    });
    expect(card()).toBeNull();
    expect(memory().install).toEqual({ shown: "2026-11-13", dismissed: 1 });

    view.unmount();
    vi.setSystemTime(new Date(TODAY.getTime() + 13 * DAY));
    device.mode = "native";
    const early = mount();
    expect(card()).toBeNull();

    early.unmount();
    vi.setSystemTime(new Date(TODAY.getTime() + 14 * DAY));
    mount();
    expect(card()).not.toBeNull();
  });

  it("⭐ « Plus tard » ⇒ `dismissed` sans ouvrir la fenêtre ; au deuxième refus, plus jamais", () => {
    device.mode = "native";
    const first = mount();
    fireEvent.click(screen.getByTestId("install-invite-later"));
    expect(promptInstall).not.toHaveBeenCalled();
    expect(trackProductEvent).toHaveBeenLastCalledWith("install_invite", {
      action: "dismissed",
      platform: "native",
      audience: "student",
    });
    expect(card()).toBeNull();

    first.unmount();
    vi.setSystemTime(new Date(TODAY.getTime() + 14 * DAY));
    const second = mount();
    fireEvent.click(screen.getByTestId("install-invite-later"));
    expect(memory().install.dismissed).toBe(2);

    second.unmount();
    vi.setSystemTime(new Date(TODAY.getTime() + 400 * DAY));
    mount();
    expect(card()).toBeNull();
  });

  it("une fenêtre qui n'a pas pu s'ouvrir n'est comptée ni comme acceptation ni comme refus", async () => {
    device.mode = "native";
    device.outcome = "unavailable";
    mount();
    await act(async () => {
      fireEvent.click(screen.getByTestId("install-invite-cta"));
    });
    expect(trackProductEvent).toHaveBeenCalledTimes(1); // « shown » seulement
    expect(memory().install.dismissed).toBe(0);
    expect(card()).toBeNull();
  });
});

describe("R-13 — iPhone / iPad Safari : les deux gestes, sans bouton d'action", () => {
  it("⭐ non installé ⇒ carte en deux gestes (« Partager », « Sur l’écran d’accueil »), sans bouton", () => {
    device.mode = "ios";
    mount();
    expect(card()).toHaveAttribute("data-platform", "ios");
    const steps = screen.getByTestId("install-invite-steps");
    expect(steps.querySelectorAll("li")).toHaveLength(2);
    expect(steps).toHaveTextContent("Partager");
    expect(steps).toHaveTextContent("Sur l’écran d’accueil");
    expect(screen.queryByTestId("install-invite-cta")).toBeNull();
    expect(trackProductEvent).toHaveBeenCalledWith("install_invite", {
      action: "shown",
      platform: "ios",
      audience: "student",
    });
  });

  it("⭐ RTL : les deux pictogrammes sont des icônes, pas des flèches retournées", async () => {
    window.localStorage.setItem(LOCALE_KEY, "ar");
    device.mode = "ios";
    mount();
    expect(await screen.findByText("مشاركة")).toBeInTheDocument();
    const steps = screen.getByTestId("install-invite-steps");
    expect(steps).toHaveTextContent("إضافة إلى الشاشة الرئيسية");
    expect(steps.querySelectorAll("svg")).toHaveLength(2);
    expect(steps.innerHTML).not.toContain("scale-x");
    expect(card()?.className).toContain("text-start");
    expect(card()).toHaveAttribute("dir", "rtl");
  });

  it("interface en français dans un écran posé en `rtl` (exercice en arabe) : la carte garde son sens", () => {
    device.mode = "ios";
    render(
      <div dir="rtl">
        <I18nProvider>
          <InstallNudge audience="student" eligible />
        </I18nProvider>
      </div>,
    );
    expect(card()).toHaveAttribute("dir", "ltr");
  });

  it('« Plus tard » sur iOS ⇒ `dismissed{platform:"ios"}`', () => {
    device.mode = "ios";
    mount();
    fireEvent.click(screen.getByTestId("install-invite-later"));
    expect(trackProductEvent).toHaveBeenLastCalledWith("install_invite", {
      action: "dismissed",
      platform: "ios",
      audience: "student",
    });
    expect(card()).toBeNull();
  });
});

describe("US-10 — le bilan parent", () => {
  it("⭐ audience parent ⇒ texte parent (vouvoiement), mesuré comme tel", () => {
    device.mode = "ios";
    mount({ audience: "parent" });
    expect(screen.getByText("Gardez le suivi sur votre écran d’accueil")).toBeInTheDocument();
    expect(screen.queryByText(/ton écran/)).toBeNull();
    expect(trackProductEvent).toHaveBeenCalledWith("install_invite", {
      action: "shown",
      platform: "ios",
      audience: "parent",
    });
  });

  it("en anglais et en arabe aussi", async () => {
    window.localStorage.setItem(LOCALE_KEY, "en");
    device.mode = "native";
    const en = mount({ audience: "parent" });
    expect(
      await screen.findByText("Keep the progress report on your home screen"),
    ).toBeInTheDocument();
    expect(screen.getByTestId("install-invite-cta")).toHaveTextContent("Install");
    en.unmount();

    window.localStorage.removeItem(NUDGE_KEY);
    window.localStorage.setItem(LOCALE_KEY, "ar");
    mount({ audience: "parent" });
    expect(await screen.findByText("احتفظوا بالمتابعة على شاشتكم الرئيسية")).toBeInTheDocument();
    expect(screen.getByTestId("install-invite-cta")).toHaveTextContent("تثبيت");
    expect(screen.getByTestId("install-invite-later")).toHaveTextContent("لاحقًا");
  });
});

describe("R-11 — rien hors d'une réussite, rien si rien n'est proposable", () => {
  it("⭐ quiz raté (`eligible` faux) ⇒ rien, rien n'est mesuré ni retenu", () => {
    device.mode = "native";
    mount({ eligible: false });
    expect(card()).toBeNull();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(window.localStorage.getItem(NUDGE_KEY)).toBeNull();
  });

  it("⭐ application déjà installée, navigateur intégré, bureau sans événement (`none`) ⇒ rien", () => {
    device.mode = "none";
    mount();
    expect(card()).toBeNull();
    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(window.localStorage.getItem(NUDGE_KEY)).toBeNull();
  });

  it("⭐ le serveur ne la rend jamais", () => {
    device.mode = "ios";
    const html = renderToString(
      <I18nProvider>
        <InstallNudge audience="student" eligible />
      </I18nProvider>,
    );
    expect(html).not.toContain("install-invite");
  });
});

describe("R-12 — la mémoire commune tient la carte", () => {
  it("⭐ déjà montrée il y a moins de 14 jours ⇒ rien", () => {
    window.localStorage.setItem(
      NUDGE_KEY,
      JSON.stringify({ install: { shown: "2026-11-05", dismissed: 0 } }),
    );
    device.mode = "native";
    mount();
    expect(card()).toBeNull();
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("⭐ stockage indisponible ⇒ aucune invitation", () => {
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("QuotaExceededError");
    });
    device.mode = "native";
    mount();
    expect(card()).toBeNull();
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("⭐ aucun décalage : un événement arrivé APRÈS l'écran n'y insère pas de carte…", () => {
    mount();
    act(() => setMode("native"));
    expect(card()).toBeNull();
    expect(window.localStorage.getItem(NUDGE_KEY)).toBeNull();
  });

  it("…sauf en bas de page (`late`), où rien n'est poussé", () => {
    mount({ late: true });
    expect(card()).toBeNull();
    act(() => setMode("native"));
    expect(card()).not.toBeNull();
  });
});

describe("R-12 — UNE SEULE invitation par écran : rappel → installation → parent", () => {
  /** Un écran qui compose plusieurs invitations, comme le fera la route de quête. */
  function Screen({ push, parent }: { push: boolean; parent: boolean }) {
    const install = useInstallCandidate("student", true);
    const other = (kind: "push" | "parent", available: boolean): NudgeCandidate => ({
      kind,
      available,
      render: ({ dismiss }) => (
        <button type="button" data-testid={`nudge-${kind}`} onClick={dismiss}>
          {kind}
        </button>
      ),
    });
    // Déclarés dans le désordre, à dessein : l'ordre est celui de la règle, pas celui de l'écran.
    return <NudgeSlot candidates={[other("parent", parent), install, other("push", push)]} />;
  }
  const mountScreen = (props: { push: boolean; parent: boolean }) =>
    render(
      <I18nProvider>
        <Screen {...props} />
      </I18nProvider>,
    );

  it("⭐ le rappel proposable ⇒ lui seul ; la carte d'installation ne paraît pas", () => {
    device.mode = "native";
    mountScreen({ push: true, parent: true });
    expect(screen.getByTestId("nudge-push")).toBeInTheDocument();
    expect(card()).toBeNull();
    expect(screen.queryByTestId("nudge-parent")).toBeNull();
    expect(Object.keys(memory())).toEqual(["push"]);
  });

  it("⭐ le rappel ne paraît pas ⇒ la carte d'installation, et pas celle du parent", () => {
    device.mode = "native";
    mountScreen({ push: false, parent: true });
    expect(card()).not.toBeNull();
    expect(screen.queryByTestId("nudge-parent")).toBeNull();
  });

  it("⭐ ni rappel ni installation ⇒ l'invitation du parent", () => {
    mountScreen({ push: false, parent: true });
    expect(screen.getByTestId("nudge-parent")).toBeInTheDocument();
  });

  it("une invitation écartée ne laisse pas la place à la suivante sur le même écran", () => {
    device.mode = "native";
    mountScreen({ push: true, parent: true });
    fireEvent.click(screen.getByTestId("nudge-push"));
    expect(screen.queryByTestId("nudge-push")).toBeNull();
    expect(card()).toBeNull();
    expect(memory().push.dismissed).toBe(1);
  });
});
