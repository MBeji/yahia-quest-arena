import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { fr } from "@/lib/i18n/fr";
import { ar } from "@/lib/i18n/ar";
import { parentTranslations } from "@/lib/i18n/parent";

const mockUsePush = vi.fn();
vi.mock("../use-push", () => ({ usePush: () => mockUsePush() }));
const toast = vi.hoisted(() => ({ error: vi.fn(), success: vi.fn() }));
vi.mock("sonner", () => ({ toast }));

const getPref = vi.fn();
const setPref = vi.fn();
vi.mock("../notifications.server", () => ({
  getParentDigestPref: "get",
  setParentDigestPref: "set",
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => (fn === "get" ? getPref : setPref),
}));

const locale = vi.hoisted(() => ({ current: "fr" as "fr" | "ar" }));
vi.mock("@/lib/i18n", async () => {
  const frMod = await import("@/lib/i18n/fr");
  const arMod = await import("@/lib/i18n/ar");
  return { useT: () => (locale.current === "ar" ? arMod.ar : frMod.fr) };
});
vi.mock("@/lib/i18n/parent", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/parent")>();
  const frMod = await import("@/lib/i18n/fr");
  const arMod = await import("@/lib/i18n/ar");
  return {
    ...actual,
    useParentT: () => ({
      ...(locale.current === "ar" ? arMod.ar : frMod.fr),
      ...actual.parentTranslations(locale.current),
    }),
  };
});

import { ParentDigestCard } from "../components/parent-digest-card";

const frP = parentTranslations("fr").parentReport;
const arP = parentTranslations("ar").parentReport;

function push(state: string, enable = vi.fn().mockResolvedValue(true)) {
  mockUsePush.mockReturnValue({ state, busy: false, enable, disable: vi.fn() });
  return enable;
}

function renderCard(hasLinkedStudent = true) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <ParentDigestCard hasLinkedStudent={hasLinkedStudent} />
    </QueryClientProvider>,
  );
}

const digestSwitch = () => screen.findByRole("switch", { name: frP.digestTitle });

beforeEach(() => {
  locale.current = "fr";
  mockUsePush.mockReset();
  getPref.mockReset().mockResolvedValue({ enriched: false });
  setPref.mockReset().mockImplementation(async ({ data }: { data: { enabled: boolean } }) => ({
    enriched: data.enabled,
  }));
  toast.error.mockReset();
  toast.success.mockReset();
});

describe("ParentDigestCard — étude 08 lot 2", () => {
  it.each(["loading", "unconfigured"])("ne rend rien quand le push est %s", (state) => {
    push(state);
    const { container } = renderCard();
    expect(container).toBeEmptyDOMElement();
    expect(getPref).not.toHaveBeenCalled();
  });

  it("navigateur sans push : la marche à suivre, et aucun contrôle mort", () => {
    push("unsupported");
    renderCard();
    expect(screen.getByText(frP.digestUnsupported)).toBeInTheDocument();
    expect(screen.queryByRole("switch")).not.toBeInTheDocument();
    expect(getPref).not.toHaveBeenCalled();
  });

  it("⭐ désactivé par défaut (Q-1) : l'interrupteur est éteint tant qu'on n'a rien demandé", async () => {
    push("granted");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());
    expect(control).toHaveAttribute("aria-checked", "false");
    expect(screen.getByText(frP.digestDesc)).toBeInTheDocument();
    expect(screen.getByText(frP.digestLockNote)).toBeInTheDocument();
  });

  it("un clic demande le résumé, et le dit", async () => {
    push("granted");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());

    await userEvent.click(control);

    await waitFor(() => expect(setPref).toHaveBeenCalledWith({ data: { enabled: true } }));
    await waitFor(() => expect(control).toHaveAttribute("aria-checked", "true"));
    expect(toast.success).toHaveBeenCalledWith(frP.digestOn);
  });

  it("⭐ sans notifications activées, le même clic ouvre d'abord le canal", async () => {
    const enable = push("default");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());

    await userEvent.click(control);

    await waitFor(() => expect(setPref).toHaveBeenCalledWith({ data: { enabled: true } }));
    expect(enable).toHaveBeenCalledTimes(1);
    expect(enable.mock.invocationCallOrder[0]).toBeLessThan(setPref.mock.invocationCallOrder[0]);
  });

  it("permission refusée : rien n'est enregistré, et on explique pourquoi", async () => {
    push("default", vi.fn().mockResolvedValue(false));
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());

    await userEvent.click(control);

    await waitFor(() => expect(toast.error).toHaveBeenCalledWith(frP.digestBlocked));
    expect(setPref).not.toHaveBeenCalled();
    expect(control).toHaveAttribute("aria-checked", "false");
  });

  it("couper le résumé ne redemande aucune permission", async () => {
    getPref.mockResolvedValue({ enriched: true });
    const enable = push("default");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toHaveAttribute("aria-checked", "true"));
    // Demandé ailleurs, mais pas de canal ICI : on le dit.
    expect(screen.getByText(frP.digestOtherDevice)).toBeInTheDocument();

    await userEvent.click(control);

    await waitFor(() => expect(setPref).toHaveBeenCalledWith({ data: { enabled: false } }));
    expect(enable).not.toHaveBeenCalled();
    expect(toast.success).toHaveBeenCalledWith(frP.digestOff);
  });

  it("notifications bloquées : texte vouvoyé, interrupteur verrouillé — sauf pour couper", async () => {
    push("denied");
    renderCard();
    const control = await digestSwitch();
    expect(screen.getByText(frP.digestBlocked)).toBeInTheDocument();
    expect(screen.queryByText(fr.pushNotifications.blocked)).not.toBeInTheDocument();
    await waitFor(() => expect(getPref).toHaveBeenCalled());
    expect(control).toBeDisabled();
  });

  it("notifications bloquées mais résumé déjà demandé : on peut toujours le couper", async () => {
    getPref.mockResolvedValue({ enriched: true });
    push("denied");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());
  });

  it("une panne d'enregistrement se dit, sans basculer l'interrupteur", async () => {
    setPref.mockRejectedValue(new Error("boom"));
    push("granted");
    renderCard();
    const control = await digestSwitch();
    await waitFor(() => expect(control).toBeEnabled());

    await userEvent.click(control);

    await waitFor(() => expect(toast.error).toHaveBeenCalledWith(frP.digestError));
    expect(control).toHaveAttribute("aria-checked", "false");
  });

  it("parent sans enfant lié : on dit pourquoi rien ne partira encore", async () => {
    push("granted");
    renderCard(false);
    await digestSwitch();
    expect(screen.getByText(frP.digestNoChild)).toBeInTheDocument();
  });

  it("parent avec enfant lié : pas de mention superflue", async () => {
    push("granted");
    renderCard(true);
    await digestSwitch();
    expect(screen.queryByText(frP.digestNoChild)).not.toBeInTheDocument();
  });

  it("RTL : la carte se lit en arabe, chaque phrase d'un seul tenant", async () => {
    locale.current = "ar";
    push("granted");
    document.documentElement.dir = "rtl";
    try {
      renderCard(false);
      const control = await screen.findByRole("switch", { name: arP.digestTitle });
      expect(control).toBeInTheDocument();
      // Un seul nœud de texte par phrase : rien que le bidi puisse réordonner.
      for (const text of [arP.digestDesc, arP.digestLockNote, arP.digestNoChild]) {
        expect(screen.getByText(text).childNodes).toHaveLength(1);
      }
      expect(screen.getByText(ar.pushNotifications.enabled)).toBeInTheDocument();
    } finally {
      document.documentElement.dir = "ltr";
    }
  });

  it("les trois langues portent toutes les clés du digest, sans mot d'argent", () => {
    for (const code of ["fr", "en", "ar"] as const) {
      const p = parentTranslations(code).parentReport;
      const digest = Object.entries(p).filter(([key]) => key.startsWith("digest"));
      expect(digest).toHaveLength(10);
      for (const [, value] of digest) {
        expect(String(value).trim().length).toBeGreaterThan(0);
        expect(String(value).toLowerCase()).not.toMatch(/premium|abonnement|payant|subscription/);
      }
    }
  });
});
