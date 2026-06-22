import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { I18nProvider, useI18n, useT } from "@/lib/i18n";

// Helper component to test hooks
function TestConsumer() {
  const { locale, dir, setLocale } = useI18n();
  const t = useT();
  return (
    <div>
      <span data-testid="locale">{locale}</span>
      <span data-testid="dir">{dir}</span>
      <span data-testid="loading">{t.common.loading}</span>
      <span data-testid="public-nav">{t.public.header.programme}</span>
      <button data-testid="switch-fr" onClick={() => setLocale("fr")} />
      <button data-testid="switch-ar" onClick={() => setLocale("ar")} />
      <button data-testid="switch-en" onClick={() => setLocale("en")} />
    </div>
  );
}

/** jsdom persists document.cookie across tests; clear it so cookie-based locale
 *  fallback in one test doesn't leak into the next. */
function clearCookies() {
  for (const part of document.cookie.split(";")) {
    const name = part.split("=")[0]?.trim();
    if (name) document.cookie = `${name}=; path=/; max-age=0`;
  }
}

describe("i18n system", () => {
  beforeEach(() => {
    localStorage.clear();
    clearCookies();
    document.documentElement.dir = "ltr";
    document.documentElement.lang = "en";
  });

  afterEach(() => {
    localStorage.clear();
    clearCookies();
    document.documentElement.dir = "ltr";
    document.documentElement.lang = "en";
  });

  it("defaults to French locale (French-first product, GAP-010)", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    expect(screen.getByTestId("locale").textContent).toBe("fr");
    expect(screen.getByTestId("dir").textContent).toBe("ltr");
  });

  it("provides French translations by default", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    expect(screen.getByTestId("loading").textContent).toBe("Chargement…");
  });

  it("switches to French locale", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("switch-fr"));
    });

    expect(screen.getByTestId("locale").textContent).toBe("fr");
    expect(screen.getByTestId("dir").textContent).toBe("ltr");
    expect(screen.getByTestId("loading").textContent).toBe("Chargement…");
  });

  it("switches to Arabic with RTL direction", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("switch-ar"));
    });

    expect(screen.getByTestId("locale").textContent).toBe("ar");
    expect(screen.getByTestId("dir").textContent).toBe("rtl");
    expect(document.documentElement.dir).toBe("rtl");
    expect(document.documentElement.lang).toBe("ar");
  });

  it("persists locale to localStorage", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("switch-fr"));
    });

    expect(localStorage.getItem("xp-scholars-locale")).toBe("fr");
  });

  it("restores locale from localStorage on mount", () => {
    localStorage.setItem("xp-scholars-locale", "ar");

    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    // After useEffect runs
    expect(screen.getByTestId("locale").textContent).toBe("ar");
  });

  it("falls back to French for invalid stored locale", () => {
    localStorage.setItem("xp-scholars-locale", "invalid");

    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    expect(screen.getByTestId("locale").textContent).toBe("fr");
  });

  it("each locale has public-screen keys defined", async () => {
    const { en } = await import("@/lib/i18n/en");
    const { fr } = await import("@/lib/i18n/fr");
    const { ar } = await import("@/lib/i18n/ar");

    expect(en.public.landing.heroTitle).toBeTruthy();
    expect(fr.public.landing.heroTitle).toBeTruthy();
    expect(ar.public.landing.heroTitle).toBeTruthy();
  });

  it("the three locale dictionaries share the exact same key structure", async () => {
    const { en } = await import("@/lib/i18n/en");
    const { fr } = await import("@/lib/i18n/fr");
    const { ar } = await import("@/lib/i18n/ar");

    // Collect every leaf key path (e.g. "dungeon.locked") so a key added to one
    // locale but forgotten in another fails fast — TypeScript enforces the shape,
    // but this guards the runtime values and any future structural drift.
    const leafPaths = (obj: unknown, prefix = ""): string[] => {
      if (obj === null || typeof obj !== "object") return [prefix];
      return Object.entries(obj as Record<string, unknown>).flatMap(([k, v]) =>
        leafPaths(v, prefix ? `${prefix}.${k}` : k),
      );
    };

    const frKeys = leafPaths(fr).sort();
    expect(leafPaths(en).sort()).toEqual(frKeys);
    expect(leafPaths(ar).sort()).toEqual(frKeys);
  });

  it("exposes the keys added by the screens audit in every locale", async () => {
    const { en } = await import("@/lib/i18n/en");
    const { fr } = await import("@/lib/i18n/fr");
    const { ar } = await import("@/lib/i18n/ar");

    for (const d of [fr, en, ar]) {
      // Dungeon lock block, quest result strings, shop enum maps, dashboard toast,
      // landing reduce-motion and the auth OAuth prefix — all externalized in F2.
      expect(d.dungeon.locked).toBeTruthy();
      expect(d.dungeon.runsToday).toContain("{n}");
      expect(d.quest.resultScore).toContain("{pct}");
      expect(d.quest.potionXpApplied).toContain("{x}");
      expect(d.dashboard.noQuestTarget).toBeTruthy();
      expect(d.dashboard.itemTypes.skin).toBeTruthy();
      expect(d.dashboard.rarities.common).toBeTruthy();
      expect(d.public.landing.heroTitle).toBeTruthy();
      expect(d.public.practice.checkCta).toBeTruthy();
      expect(d.public.subject.chapter).toContain("{n}");
      expect(d.auth.oauthErrorPrefix).toContain("{msg}");
    }
  });

  it("switching back to English sets LTR", () => {
    render(
      <I18nProvider>
        <TestConsumer />
      </I18nProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("switch-ar"));
    });
    expect(document.documentElement.dir).toBe("rtl");

    act(() => {
      fireEvent.click(screen.getByTestId("switch-en"));
    });
    expect(document.documentElement.dir).toBe("ltr");
    expect(document.documentElement.lang).toBe("en");
  });
});
