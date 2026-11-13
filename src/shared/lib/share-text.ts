// LE GESTE DE PARTAGE — étude 40, lot 4 (R-15, R-16, R-18).
//
// UNE implémentation, trois canaux essayés dans l'ordre : la feuille de partage du système, à
// défaut WhatsApp (`wa.me`), à défaut la copie. C'est la personne qui choisit le destinataire,
// dans SON application : rien ne passe par nos serveurs, aucun numéro ni adresse n'est demandé.
//
// Trois écrans partageaient déjà un texte, chacun avec sa copie du geste (bilan parent connecté,
// bilan parent public, bilan du test de niveau). Ils passent tous par ici, SANS changer de
// comportement : leurs différences sont devenues des options nommées, plus des lignes recopiées.
//
// Pur et testable : `navigator` et `window` entrent par `env`, rien n'est lu ailleurs.

import { SITE_URL } from "@/shared/constants/site";
import type { EntrySource } from "@/shared/lib/entry-source";

/** Ce qui a été fait — c'est aussi la propriété `method` de `content_shared`. */
export type ShareMethod = "share" | "whatsapp" | "copy" | "none";
export type ShareChannel = Exclude<ShareMethod, "none">;

/** Ce que le geste demande à l'appareil. Un canal absent est simplement sauté. */
export type ShareEnv = {
  /** La feuille de partage du système (`navigator.share`). */
  readonly share?: (data: { text: string }) => Promise<void>;
  /** Ouvre une adresse dans un nouvel onglet (`window.open`). */
  readonly open?: (url: string) => void;
  /** Le presse-papiers (`navigator.clipboard.writeText`). */
  readonly writeText?: (text: string) => Promise<void>;
};

export type ShareOptions = {
  /** Les canaux à essayer, dans l'ordre. Par défaut les trois (R-15). */
  readonly channels?: readonly ShareChannel[];
  /**
   * Que faire quand la feuille de partage existe mais n'aboutit pas :
   *   - `next-unless-cancelled` (défaut) : la personne a FERMÉ la feuille ⇒ rien ne part, on
   *     n'ouvre pas WhatsApp dans son dos ; tout autre échec ⇒ canal suivant ;
   *   - `next` : canal suivant dans tous les cas (bilan du test de niveau, depuis l'étude 39) ;
   *   - `stop` : on s'arrête là (bilans parents, depuis leur premier jour).
   */
  readonly afterUnsharedSheet?: "next-unless-cancelled" | "next" | "stop";
};

const ALL_CHANNELS: readonly ShareChannel[] = ["share", "whatsapp", "copy"];

/** R-15 — le lien WhatsApp SANS destinataire : c'est WhatsApp qui demande à qui l'envoyer. */
export function whatsappUrl(text: string): string {
  return `https://wa.me/?text=${encodeURIComponent(text)}`;
}

function isCancellation(error: unknown): boolean {
  return (
    typeof error === "object" && error !== null && "name" in error && error.name === "AbortError"
  );
}

/**
 * R-18 — partage un texte par le premier canal qui aboutit, et rend lequel. Ne lève jamais :
 * un appareil qui ne sait rien faire rend `none`, et l'écran reste tel qu'il était.
 */
export async function shareText(
  text: string,
  options: ShareOptions = {},
  env: ShareEnv = browserShareEnv(),
): Promise<ShareMethod> {
  const afterUnsharedSheet = options.afterUnsharedSheet ?? "next-unless-cancelled";
  for (const channel of options.channels ?? ALL_CHANNELS) {
    if (channel === "share" && env.share) {
      try {
        await env.share({ text });
        return "share";
      } catch (error) {
        if (afterUnsharedSheet === "stop") return "none";
        if (afterUnsharedSheet === "next-unless-cancelled" && isCancellation(error)) return "none";
      }
    }
    if (channel === "whatsapp" && env.open) {
      try {
        env.open(whatsappUrl(text));
        return "whatsapp";
      } catch {
        // Fenêtre refusée : canal suivant.
      }
    }
    if (channel === "copy" && env.writeText) {
      try {
        await env.writeText(text);
        return "copy";
      } catch {
        // Presse-papiers refusé (permission, page sans focus) : canal suivant.
      }
    }
  }
  return "none";
}

/**
 * Les canaux d'un navigateur donné. `nav` et `win` sont injectables — c'est ce qui laisse les
 * appelants historiques garder leurs tests tels quels.
 */
export function shareEnvFrom(
  nav: Partial<Pick<Navigator, "share" | "clipboard">> | undefined,
  win?: Pick<Window, "open">,
): ShareEnv {
  const clipboard = nav?.clipboard;
  return {
    share: nav && typeof nav.share === "function" ? (data) => nav.share!(data) : undefined,
    open:
      win && typeof win.open === "function"
        ? (url) => {
            // `noopener,noreferrer` : WhatsApp ne reçoit ni la main sur notre onglet ni l'adresse
            // de la page d'où part le partage.
            win.open(url, "_blank", "noopener,noreferrer");
          }
        : undefined,
    writeText:
      clipboard && typeof clipboard.writeText === "function"
        ? (text) => clipboard.writeText(text)
        : undefined,
  };
}

function browserShareEnv(): ShareEnv {
  return shareEnvFrom(
    typeof navigator === "undefined" ? undefined : navigator,
    typeof window === "undefined" ? undefined : window,
  );
}

/** Les deux étiquettes `?src=` que ce lot pose sur ses liens (lues et retirées par `entry-source`). */
export type ChapterLinkSource = Extract<EntrySource, "resume_link" | "share">;

/**
 * R-16 — le lien partagé : l'adresse canonique (`www`) du CHAPITRE, jamais celle de l'exercice —
 * un lien doit ramener à un endroit qui a du sens à froid. Absolu : un lien relatif collé dans
 * WhatsApp n'ouvre rien.
 */
export function chapterShareUrl(chapterId: string, source: ChapterLinkSource): string {
  return `${SITE_URL}/chapitre/${encodeURIComponent(chapterId)}?src=${source}`;
}

/** Ce qu'un texte partagé a le droit de porter (R-17) : ni prénom, ni pseudo, ni comparaison. */
export type ShareTextFacts = {
  readonly chapter: string;
  readonly url: string;
  readonly subject?: string | null;
  readonly correct?: number;
  readonly total?: number;
};

/**
 * R-16 — met un gabarit en mots : `{chapter}`, `{subject}`, `{correct}`, `{total}`, `{url}`.
 * Du texte brut, jamais du HTML. Sans matière connue, « — {subject} » disparaît avec son tiret.
 */
export function fillShareTemplate(template: string, facts: ShareTextFacts): string {
  const subject = facts.subject?.trim() ?? "";
  const values: Record<string, string> = {
    chapter: facts.chapter.trim(),
    subject,
    correct: String(facts.correct ?? ""),
    total: String(facts.total ?? ""),
    url: facts.url,
  };
  const shaped = subject === "" ? template.replace(/\s*[—-]\s*\{subject\}/, "") : template;
  // Une seule passe : un titre de chapitre qui contiendrait « {url} » n'est pas ré-interprété.
  return shaped.replace(
    /\{(chapter|subject|correct|total|url)\}/g,
    (_, key: string) => values[key],
  );
}
