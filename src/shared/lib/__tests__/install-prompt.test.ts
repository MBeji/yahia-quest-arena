// @vitest-environment node
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it, vi } from "vitest";
import {
  getInstallMode,
  installModeOf,
  isIosSafari,
  promptInstall,
  promptWith,
  type InstallWindow,
} from "@/shared/lib/install-prompt";
import {
  createInstallCapture,
  isStandaloneDisplay,
  type CaptureWindow,
} from "@/shared/lib/install-signals";

/**
 * Étude 40 lot 3 — CE QUE L'APPAREIL SAIT FAIRE POUR INSTALLER (R-13), l'application déjà
 * installée (R-11) et le manifeste (R-14). Chaque règle a son test nommé.
 */

const UA = {
  iphoneSafari:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1",
  ipadSafari:
    "Mozilla/5.0 (iPad; CPU OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
  // iPadOS 13+ se présente comme un Mac : seul l'écran tactile le distingue.
  ipadDesktopClass:
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15",
  iphoneChrome:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/126.0.6478.54 Mobile/15E148 Safari/604.1",
  iphoneFirefox:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/127.0 Mobile/15E148 Safari/605.1.15",
  iphoneFacebook:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/21F90 [FBAN/FBIOS;FBAV/470.0.0.34.108;FBBV/612345678;FBDV/iPhone14,5]",
  iphoneInstagram:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/21F90 Instagram 337.0.0.23.103 (iPhone14,5; iOS 17_5; fr_FR)",
  iphoneWebView:
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
  androidChrome:
    "Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36",
  macSafari:
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15",
  desktopChrome:
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
};

type Listener = (event: Event) => void;

/** Une fenêtre factice : agent, mode d'affichage, et de quoi émettre les événements du navigateur. */
function fakeWindow(options: {
  userAgent?: string;
  maxTouchPoints?: number;
  standaloneMedia?: boolean;
  navigatorStandalone?: boolean;
}) {
  const listeners = new Map<string, Listener[]>();
  const win: InstallWindow & CaptureWindow = {
    addEventListener: (type, listener) => {
      listeners.set(type, [...(listeners.get(type) ?? []), listener]);
    },
    matchMedia: (query) => ({
      matches: query === "(display-mode: standalone)" && options.standaloneMedia === true,
    }),
    navigator: {
      userAgent: options.userAgent ?? UA.androidChrome,
      maxTouchPoints: options.maxTouchPoints ?? 0,
      ...(options.navigatorStandalone === undefined
        ? {}
        : { standalone: options.navigatorStandalone }),
    },
  };
  const capture = createInstallCapture(win);
  return {
    win,
    capture,
    mode: () => installModeOf(win, capture),
    count: (type: string) => listeners.get(type)?.length ?? 0,
    emit: (type: string, event: object = {}) =>
      listeners.get(type)?.forEach((listener) => listener(event as Event)),
  };
}

function installEvent(outcome: "accepted" | "dismissed") {
  return {
    preventDefault: vi.fn(),
    prompt: vi.fn(() => Promise.resolve()),
    userChoice: Promise.resolve({ outcome }),
  };
}

describe("R-13 — Chromium : `beforeinstallprompt` est retenu à son passage", () => {
  it("⭐ sans événement, pas de carte : le mode est `none`", () => {
    expect(fakeWindow({ userAgent: UA.androidChrome }).mode()).toBe("none");
  });

  it("⭐ l'événement reçu ⇒ `native` ; la bannière du navigateur est retenue (`preventDefault`)", () => {
    const page = fakeWindow({ userAgent: UA.androidChrome });
    const changed = vi.fn();
    page.capture.subscribe(changed);
    const event = installEvent("accepted");
    page.emit("beforeinstallprompt", event);
    expect(event.preventDefault).toHaveBeenCalledTimes(1);
    expect(page.mode()).toBe("native");
    expect(changed).toHaveBeenCalledTimes(1);
  });

  it("⭐ le bouton appelle `prompt()` ; acceptation ⇒ `accepted`, et l'événement ne ressert pas", async () => {
    const page = fakeWindow({});
    const changed = vi.fn();
    const event = installEvent("accepted");
    page.emit("beforeinstallprompt", event);
    page.capture.subscribe(changed);
    await expect(promptWith(page.capture)).resolves.toBe("accepted");
    expect(event.prompt).toHaveBeenCalledTimes(1);
    expect(page.mode()).toBe("none");
    expect(changed).toHaveBeenCalled();
    await expect(promptWith(page.capture)).resolves.toBe("unavailable");
    expect(event.prompt).toHaveBeenCalledTimes(1);
  });

  it("⭐ la fenêtre refermée ⇒ `dismissed`", async () => {
    const page = fakeWindow({});
    page.emit("beforeinstallprompt", installEvent("dismissed"));
    await expect(promptWith(page.capture)).resolves.toBe("dismissed");
  });

  it("une fenêtre qui ne s'ouvre pas ⇒ `unavailable`, sans lever", async () => {
    const page = fakeWindow({});
    page.emit("beforeinstallprompt", {
      ...installEvent("accepted"),
      prompt: () => Promise.reject(new Error("NotAllowedError")),
    });
    await expect(promptWith(page.capture)).resolves.toBe("unavailable");
  });

  it("un événement qui n'a pas la forme attendue n'ouvre rien : `unavailable`, sans lever", async () => {
    const page = fakeWindow({});
    page.emit("beforeinstallprompt", { preventDefault: vi.fn() });
    await expect(promptWith(page.capture)).resolves.toBe("unavailable");
    expect(page.mode()).toBe("none");
  });

  it("`appinstalled` ⇒ plus rien à proposer", () => {
    const page = fakeWindow({});
    page.emit("beforeinstallprompt", installEvent("accepted"));
    page.emit("appinstalled");
    expect(page.mode()).toBe("none");
  });

  it("un écouteur par événement et par fenêtre", () => {
    const page = fakeWindow({});
    expect(page.count("beforeinstallprompt")).toBe(1);
    expect(page.count("appinstalled")).toBe(1);
  });

  it("se désabonner arrête les notifications", () => {
    const page = fakeWindow({});
    const changed = vi.fn();
    page.capture.subscribe(changed)();
    page.emit("beforeinstallprompt", installEvent("accepted"));
    expect(changed).not.toHaveBeenCalled();
  });
});

describe("R-13 — iPhone / iPad Safari : les deux gestes, sans événement", () => {
  it.each([
    ["iPhone Safari", UA.iphoneSafari, 5],
    ["iPad Safari", UA.ipadSafari, 5],
    ["iPad « classe bureau » (se présente comme un Mac tactile)", UA.ipadDesktopClass, 5],
  ])("⭐ %s ⇒ `ios`", (_label, userAgent, maxTouchPoints) => {
    expect(fakeWindow({ userAgent, maxTouchPoints }).mode()).toBe("ios");
  });

  it.each([
    ["Chrome sur iPhone", UA.iphoneChrome],
    ["Firefox sur iPhone", UA.iphoneFirefox],
    ["navigateur intégré de Facebook", UA.iphoneFacebook],
    ["navigateur intégré d'Instagram", UA.iphoneInstagram],
    ["vue web intégrée d'une application", UA.iphoneWebView],
    ["Chrome Android sans événement", UA.androidChrome],
    ["Chrome de bureau sans événement", UA.desktopChrome],
  ])("⭐ tout autre cas — %s ⇒ `none`", (_label, userAgent) => {
    expect(fakeWindow({ userAgent, maxTouchPoints: 5 }).mode()).toBe("none");
  });

  it("un Mac sans écran tactile n'est pas un iPad", () => {
    expect(isIosSafari({ userAgent: UA.macSafari, maxTouchPoints: 0 })).toBe(false);
  });

  it("sans agent lisible ⇒ pas Safari iOS", () => {
    expect(isIosSafari(undefined)).toBe(false);
    expect(isIosSafari({})).toBe(false);
  });
});

describe("R-11 — jamais si l'application tourne déjà installée", () => {
  it("⭐ `display-mode: standalone` ⇒ `none`, même avec l'événement reçu", () => {
    const page = fakeWindow({ standaloneMedia: true });
    page.emit("beforeinstallprompt", installEvent("accepted"));
    expect(page.mode()).toBe("none");
  });

  it("⭐ `navigator.standalone` (Safari iOS, ouverte depuis l'écran d'accueil) ⇒ `none`", () => {
    expect(fakeWindow({ userAgent: UA.iphoneSafari, navigatorStandalone: true }).mode()).toBe(
      "none",
    );
  });

  it("le mode d'affichage se lit par la media query, et par `navigator.standalone` pour Safari iOS", () => {
    expect(isStandaloneDisplay({ matchMedia: () => ({ matches: true }) })).toBe(true);
    expect(isStandaloneDisplay({ matchMedia: () => ({ matches: false }) })).toBe(false);
    expect(isStandaloneDisplay({ navigator: { standalone: true } })).toBe(true);
    expect(isStandaloneDisplay(undefined)).toBe(false);
  });

  it("une media query qui lève ne casse rien", () => {
    expect(
      isStandaloneDisplay({
        matchMedia: () => {
          throw new Error("boom");
        },
      }),
    ).toBe(false);
  });
});

describe("le sens sûr", () => {
  it("rendu serveur (pas de fenêtre) ⇒ `none`, rien ne lève", async () => {
    const capture = createInstallCapture(undefined);
    expect(installModeOf(undefined, capture)).toBe("none");
    await expect(promptWith(capture)).resolves.toBe("unavailable");
    // L'instance de la page, chargée ici sans `window` : même réponse.
    expect(getInstallMode()).toBe("none");
    await expect(promptInstall()).resolves.toBe("unavailable");
  });

  it("une fenêtre qui refuse une lecture ⇒ `none`", () => {
    expect(
      installModeOf(
        {
          matchMedia: () => {
            throw new Error("refusé");
          },
          get navigator(): never {
            throw new Error("refusé");
          },
        },
        createInstallCapture(undefined),
      ),
    ).toBe("none");
  });
});

describe("R-13 — l'écouteur est posé dès le chargement des deux coquilles", () => {
  it.each(["src/routes/_public.tsx", "src/routes/_authenticated.tsx"])(
    "⭐ %s importe le module pour son effet",
    (file) => {
      expect(readFileSync(join(process.cwd(), file), "utf8")).toContain(
        'import "@/shared/lib/install-signals";',
      );
    },
  );

  it("⭐ le module pose son écouteur à son chargement, pas au montage d'une carte", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/install-signals.ts"), "utf8");
    expect(source).toMatch(/^export const installCapture = createInstallCapture\($/m);
    expect(source).toContain('win?.addEventListener("beforeinstallprompt"');
  });

  it("⭐ il est sur le chemin de tous : il n'importe RIEN", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/install-signals.ts"), "utf8");
    expect(source).not.toMatch(/^import /m);
  });
});

describe("R-14 — le manifeste", () => {
  const manifest = JSON.parse(
    readFileSync(join(process.cwd(), "public/manifest.webmanifest"), "utf8"),
  ) as Record<string, unknown>;

  it("⭐ `start_url` porte la source d'entrée que le lot 0 sait lire", () => {
    expect(manifest.start_url).toBe("/?src=pwa");
  });

  it("⭐ `id` stable, `scope` inchangé", () => {
    expect(manifest.id).toBe("/");
    expect(manifest.scope).toBe("/");
  });

  it("⭐ la description ne parle plus des seuls concours 6ᵉ et 9ᵉ", () => {
    expect(String(manifest.description)).not.toMatch(/6ème|9ème|concours/i);
    expect(String(manifest.description)).toMatch(/Baccalauréat/);
  });
});

describe("stop-point du lot — ni cache, ni plugin PWA", () => {
  it("⭐ `vite-plugin-pwa` n'entre pas dans les dépendances", () => {
    expect(readFileSync(join(process.cwd(), "package.json"), "utf8")).not.toContain(
      "vite-plugin-pwa",
    );
  });
});
