import { type Page, type Locator } from "@playwright/test";

/**
 * La rangée « Garder ce chapitre » (étude 40 lot 4) — écran de résultat sans compte, bas d'un
 * cours. Ses libellés sont traduits : tout passe par des `data-testid`.
 *
 * Elle ne parle qu'à l'APPAREIL (feuille de partage, WhatsApp, presse-papiers). Un test ne laisse
 * jamais rien partir : `shapeDevice` remplace ces trois canaux par une sonde, AVANT le chargement.
 */
type KeepProbe = { opened: string[]; copied: string[] };

export class KeepRowPage {
  constructor(private readonly page: Page) {}

  get row(): Locator {
    return this.page.getByTestId("keep-row");
  }
  /** « M'envoyer la suite » (résultat) ou « M'envoyer ce cours » (cours). */
  get send(): Locator {
    return this.page.getByTestId("keep-send");
  }
  /** « Partager ma réussite » — sur une réussite seulement. */
  get shareSuccess(): Locator {
    return this.page.getByTestId("keep-share-success");
  }
  /** La confirmation de copie (zone vivante, vide tant que rien n'a été copié). */
  get copied(): Locator {
    return this.page.getByTestId("keep-copied");
  }

  /**
   * L'appareil du test : jamais de feuille de partage ; WhatsApp joignable ou non ; un
   * presse-papiers qui retient ce qu'on lui confie. `window.open` est remplacé — la navigation
   * vers `wa.me` ne part JAMAIS, son adresse est seulement retenue. À appeler avant `goto`.
   */
  async shapeDevice(device: { whatsapp: boolean }): Promise<void> {
    await this.page.context().route(/^https:\/\/(?:[^/]+\.)?wa\.me\//, (route) => route.abort());
    await this.page.addInitScript((whatsapp) => {
      const probe: { opened: string[]; copied: string[] } = { opened: [], copied: [] };
      Object.assign(window, { __keepProbe: probe });
      Object.defineProperty(Navigator.prototype, "share", { value: undefined, configurable: true });
      Object.defineProperty(Navigator.prototype, "clipboard", {
        configurable: true,
        get: () => ({
          writeText: (text: string) => {
            probe.copied.push(text);
            return Promise.resolve();
          },
        }),
      });
      Object.defineProperty(window, "open", {
        configurable: true,
        writable: true,
        value: whatsapp
          ? (url?: string | URL) => {
              probe.opened.push(String(url));
              return null;
            }
          : undefined,
      });
    }, device.whatsapp);
  }

  private probe(): Promise<KeepProbe> {
    return this.page.evaluate(
      () =>
        (window as unknown as { __keepProbe?: KeepProbe }).__keepProbe ?? {
          opened: [],
          copied: [],
        },
    );
  }

  /** Les textes confiés à WhatsApp, dans l'ordre — décodés du `?text=` de chaque lien `wa.me`. */
  async whatsappTexts(): Promise<string[]> {
    const { opened } = await this.probe();
    return opened.map((href) => {
      const url = new URL(href);
      if (url.origin !== "https://wa.me") throw new Error(`fenêtre inattendue : ${href}`);
      return url.searchParams.get("text") ?? "";
    });
  }

  /** Les textes copiés, dans l'ordre. */
  async copiedTexts(): Promise<string[]> {
    return (await this.probe()).copied;
  }
}

/** Le lien de chapitre porté par un texte partagé : son chemin, et la source qu'il annonce. */
export function chapterLinkIn(text: string): { path: string; chapterId: string; src: string } {
  const match =
    /https:\/\/www\.na9ranal3ab\.tn(\/chapitre\/([^/?#\s]+))\?src=([a-z_]+)(?=\s|$)/.exec(text);
  if (!match) throw new Error(`aucun lien canonique de chapitre dans : ${text}`);
  return { path: `${match[1]}?src=${match[3]}`, chapterId: match[2], src: match[3] };
}
