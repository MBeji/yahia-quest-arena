import { renderHook } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 31 lot 4 (R-17) — la langue d'interface poussée dans le profil, pour que
 * les notifications parlent celle de l'élève. Monté par la coquille authentifiée
 * (`routes/_authenticated.tsx`) ; jusqu'ici aucun test ne l'exerçait.
 *
 * Le contrat : fire-and-forget, UNE fois par valeur, rien quand c'est désactivé,
 * et un échec ne bloque pas la tentative suivante.
 */
const { pushLocale, i18n } = vi.hoisted(() => ({
  pushLocale: vi.fn(),
  i18n: { locale: "fr" as "fr" | "en" | "ar" },
}));

vi.mock("@tanstack/react-start", () => ({ useServerFn: () => pushLocale }));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: i18n.locale }) }));
// La server fn elle-même n'est pas le sujet : `useServerFn` la remplace.
vi.mock("../auth.server", () => ({ setProfileLocale: "set-profile-locale" }));

import { useProfileLocaleSync } from "../use-locale-sync";

function mount(enabled: boolean) {
  return renderHook(({ on }: { on: boolean }) => useProfileLocaleSync(on), {
    initialProps: { on: enabled },
  });
}

/** Laisse filer les promesses (le `.catch` du fire-and-forget). */
const settle = () => new Promise((resolve) => setTimeout(resolve, 0));

beforeEach(() => {
  pushLocale.mockReset();
  pushLocale.mockResolvedValue({ locale: "fr" });
  i18n.locale = "fr";
});

describe("useProfileLocaleSync", () => {
  it("n'écrit rien tant que la coquille ne connaît ni l'élève ni son profil", () => {
    mount(false);
    expect(pushLocale).not.toHaveBeenCalled();
  });

  it("écrit la langue affichée dès qu'il est activé", () => {
    const { rerender } = mount(false);
    rerender({ on: true });
    expect(pushLocale).toHaveBeenCalledTimes(1);
    expect(pushLocale).toHaveBeenCalledWith({ data: { locale: "fr" } });
  });

  it("n'écrit qu'UNE fois par valeur, quels que soient les rendus", () => {
    const { rerender } = mount(true);
    rerender({ on: true });
    rerender({ on: true });
    expect(pushLocale).toHaveBeenCalledTimes(1);
  });

  it("écrit de nouveau quand la langue change", () => {
    const { rerender } = mount(true);
    i18n.locale = "ar";
    rerender({ on: true });
    expect(pushLocale).toHaveBeenNthCalledWith(2, { data: { locale: "ar" } });
  });

  it("ne lève rien sur un échec, et retente la MÊME langue quand l'effet repart", async () => {
    pushLocale.mockRejectedValueOnce(new Error("fetch failed"));
    const { rerender } = mount(true);
    await settle();

    // Même langue, effet relancé (la coquille se désactive puis se réactive, par
    // exemple au rechargement du profil). Sans la remise à zéro sur échec, « fr »
    // serait tenu pour déjà envoyé et ne repartirait jamais.
    rerender({ on: false });
    rerender({ on: true });

    expect(pushLocale.mock.calls.map(([arg]) => arg.data.locale)).toEqual(["fr", "fr"]);
  });

  it("ne retente PAS une langue déjà écrite avec succès", async () => {
    const { rerender } = mount(true);
    await settle();
    rerender({ on: false });
    rerender({ on: true });

    expect(pushLocale).toHaveBeenCalledTimes(1);
  });
});
