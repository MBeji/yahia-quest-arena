import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { renderToString } from "react-dom/server";
import { hydrateRoot } from "react-dom/client";
import { act } from "react";
import { I18nProvider, useI18n, useT } from "@/lib/i18n";
import { loadCatalogue, persistedLocale } from "@/lib/i18n/catalogues";

// =============================================================================
// LE PREMIER RENDU SORT DANS LA LANGUE DU COOKIE (issue #1228,
// `ssr-body-wrong-language-flash`, 2026-11-12)
//
// Avant, le serveur rendait toujours le corps en français et le client hydratait
// du français avant de basculer : l'élève arabophone lisait une page française
// pendant ≈ 300 ms à chaque ouverture. Depuis, `router.tsx` charge le catalogue de
// la langue du cookie AVANT le rendu (serveur et client) et la passe au provider
// (`initialLocale`). Ce fichier tient le contrat du provider : avec un catalogue
// chargé, le TOUT PREMIER rendu est déjà dans la langue, côté serveur
// (`renderToString`) comme à l'hydratation — sans écart.
// =============================================================================

function Consumer() {
  const { locale, dir } = useI18n();
  const t = useT();
  return (
    <span data-testid="state">
      {locale}:{dir}:{t.common.loading}
    </span>
  );
}

function clearCookies() {
  for (const part of document.cookie.split(";")) {
    const name = part.split("=")[0]?.trim();
    if (name) document.cookie = `${name}=; path=/; max-age=0`;
  }
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
  document.body.innerHTML = "";
});

describe("I18nProvider — initialLocale", () => {
  it("rend le serveur dans la langue demandée une fois son catalogue chargé", async () => {
    const ar = await loadCatalogue("ar");
    const html = renderToString(
      <I18nProvider initialLocale="ar">
        <Consumer />
      </I18nProvider>,
    );
    expect(html).toContain(ar.common.loading);
    expect(html).toContain("rtl");
  });

  it("hydrate le balisage arabe du serveur sans écart ni passage par le français", async () => {
    await loadCatalogue("ar");
    document.cookie = "xp-scholars-locale=ar; path=/";
    const tree = (
      <I18nProvider initialLocale="ar">
        <Consumer />
      </I18nProvider>
    );
    const container = document.createElement("div");
    container.innerHTML = renderToString(tree);
    document.body.appendChild(container);
    const server = container.textContent;

    const seen: string[] = [];
    const observer = new MutationObserver(() => seen.push(container.textContent ?? ""));
    observer.observe(container, { childList: true, characterData: true, subtree: true });
    const recoverable: unknown[] = [];
    await act(async () => {
      hydrateRoot(container, tree, { onRecoverableError: (error) => recoverable.push(error) });
    });
    observer.disconnect();

    expect(recoverable).toEqual([]);
    expect(seen).toEqual([]);
    expect(container.textContent).toBe(server);
    expect(document.documentElement.dir).toBe("rtl");
    expect(document.documentElement.lang).toBe("ar");
  });

  it("part du cookie puis rejoint localStorage quand ils divergent (cookie périmé)", async () => {
    await loadCatalogue("ar");
    document.cookie = "xp-scholars-locale=ar; path=/";
    localStorage.setItem("xp-scholars-locale", "fr");
    render(
      <I18nProvider initialLocale="ar">
        <Consumer />
      </I18nProvider>,
    );
    await waitFor(() => expect(screen.getByTestId("state").textContent).toBe("fr:ltr:Chargement…"));
    expect(document.documentElement.dir).toBe("ltr");
    expect(document.cookie).toContain("xp-scholars-locale=fr");
  });

  it("sans initialLocale, démarre en français (visiteur sans cookie, arbres de test)", () => {
    const html = renderToString(
      <I18nProvider>
        <Consumer />
      </I18nProvider>,
    );
    expect(html).toContain("Chargement…");
  });
});

// #1307 — stockage refusé : la langue persistée se lisait sans garde dans l'effet de montage,
// et la page entière tombait. Le cookie décide, et changer de langue marche quand même.
describe("I18nProvider — stockage refusé (#1307)", () => {
  function Switcher() {
    const { locale, setLocale } = useI18n();
    return (
      <button type="button" data-testid="switch" onClick={() => setLocale("en")}>
        {locale}
      </button>
    );
  }

  beforeEach(() => {
    vi.spyOn(window, "localStorage", "get").mockImplementation(() => {
      throw new DOMException("The operation is insecure.", "SecurityError");
    });
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("la locale persistée est celle du cookie, sans lever", () => {
    document.cookie = "xp-scholars-locale=ar; path=/";
    expect(persistedLocale()).toBe("ar");
  });

  it("monte sans lever, puis change de langue et l'écrit dans le cookie", async () => {
    await loadCatalogue("en");
    render(
      <I18nProvider>
        <Switcher />
      </I18nProvider>,
    );
    expect(screen.getByTestId("switch")).toHaveTextContent("fr");
    fireEvent.click(screen.getByTestId("switch"));
    await waitFor(() => expect(screen.getByTestId("switch")).toHaveTextContent("en"));
    expect(document.cookie).toContain("xp-scholars-locale=en");
  });
});
