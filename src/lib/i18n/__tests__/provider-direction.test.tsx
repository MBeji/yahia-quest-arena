import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { render, screen, act, waitFor } from "@testing-library/react";
import { I18nProvider, useI18n, useT } from "@/lib/i18n";

// =============================================================================
// LE SENS DU DOCUMENT PENDANT L'HYDRATATION (revue du 2026-11-03, suite de H2-fe)
//
// Le shell SSR pose <html lang dir> depuis le cookie ; le provider démarre en
// français (même balisage que le serveur) et n'applique la locale persistée
// qu'après le montage, une fois son catalogue — un chunk à part depuis H2-fe —
// arrivé. Entre les deux, l'effet de layout ne doit PAS réécrire « ltr / fr » :
// l'élève arabophone verrait du français en LTR, puis une seconde bascule de sens
// quand le chunk arrive (un décalage de mise en page par ouverture, surtout sur
// réseau lent). Ce fichier tient le chunk arabe en vol tant qu'il n'ouvre pas la
// porte — aucun `waitFor` ne peut donc « gagner » la course à sa place.
// =============================================================================

const gate = vi.hoisted(() => {
  let open: () => void = () => {};
  const opened = new Promise<void>((resolve) => {
    open = resolve;
  });
  return { opened, open };
});
vi.mock("@/lib/i18n/ar", async () => {
  await gate.opened;
  return await vi.importActual<typeof import("@/lib/i18n/ar")>("@/lib/i18n/ar");
});

function Consumer() {
  const { locale } = useI18n();
  const t = useT();
  return (
    <span data-testid="state">
      {locale}:{t.common.loading}
    </span>
  );
}

/** jsdom garde document.cookie d'un test à l'autre : on repart propre. */
function clearCookies() {
  for (const part of document.cookie.split(";")) {
    const name = part.split("=")[0]?.trim();
    if (name) document.cookie = `${name}=; path=/; max-age=0`;
  }
}

/** Le document tel que le shell SSR l'a rendu pour ce cookie (__root.tsx). */
function shellRenderedFor(locale: "ar" | "fr") {
  document.cookie = `xp-scholars-locale=${locale}; path=/`;
  document.documentElement.dir = locale === "ar" ? "rtl" : "ltr";
  document.documentElement.lang = locale;
}

function mount() {
  return render(
    <I18nProvider>
      <Consumer />
    </I18nProvider>,
  );
}

beforeEach(() => {
  localStorage.clear();
  clearCookies();
});

afterEach(() => {
  localStorage.clear();
  clearCookies();
  document.documentElement.dir = "ltr";
  document.documentElement.lang = "en";
});

describe("I18nProvider — le sens posé par le shell SSR survit à l'hydratation", () => {
  it("garde « rtl / ar » tant que le chunk arabe est en vol, texte français compris", async () => {
    shellRenderedFor("ar");
    mount();

    // Le texte est encore celui du serveur (français)…
    expect(screen.getByTestId("state").textContent).toBe("fr:Chargement…");
    // …et le sens du document n'a pas été réécrit en attendant le chunk.
    await act(async () => {
      await Promise.resolve();
    });
    expect(document.documentElement.dir).toBe("rtl");
    expect(document.documentElement.lang).toBe("ar");
  });

  it("corrige le document quand le cookie est périmé : localStorage dit « fr », le shell a rendu « ar »", () => {
    localStorage.setItem("xp-scholars-locale", "fr");
    shellRenderedFor("ar");
    mount();

    expect(screen.getByTestId("state").textContent).toBe("fr:Chargement…");
    expect(document.documentElement.dir).toBe("ltr");
    expect(document.documentElement.lang).toBe("fr");
    // …et le cookie est remis d'accord avec localStorage pour la prochaine requête.
    expect(document.cookie).toContain("xp-scholars-locale=fr");
  });

  it("bascule texte et sens ensemble quand le chunk arrive", async () => {
    shellRenderedFor("ar");
    mount();
    expect(screen.getByTestId("state").textContent).toBe("fr:Chargement…");

    gate.open();

    await waitFor(() => expect(screen.getByTestId("state").textContent).toBe("ar:جاري التحميل…"));
    expect(document.documentElement.dir).toBe("rtl");
    expect(document.documentElement.lang).toBe("ar");
  });
});
