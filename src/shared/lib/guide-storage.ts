/**
 * Ce que l'appareil retient du GUIDE INTÉGRÉ : bulles « ? » allumées ou non,
 * cartes de première visite déjà lues. En `localStorage`, jamais en base : c'est
 * un confort d'affichage, pas un fait pédagogique, et un échec de lecture
 * retombe sur le comportement le plus aidant (bulles allumées, carte montrée).
 *
 * Séparé de `guide.ts` parce que `GuideProvider` (racine, chunk index) n'a
 * besoin que de ceci — le chunk index n'a que quelques KB de marge.
 */
import type { GuideScreenKey } from "@/lib/i18n/guide.types";

/** Le stockage minimal dont le guide a besoin — `localStorage` ou un double de test. */
export type GuideStorage = Pick<Storage, "getItem" | "setItem">;

export const GUIDE_TIPS_KEY = "na9ra.guide.tips";

export function guideIntroKey(screen: GuideScreenKey): string {
  return `na9ra.guide.intro.${screen}`;
}

/** `localStorage` quand il existe et répond ; `null` en SSR ou navigation privée stricte. */
export function browserGuideStorage(): GuideStorage | null {
  try {
    return typeof window === "undefined" ? null : window.localStorage;
  } catch {
    return null;
  }
}

function read(storage: GuideStorage | null, key: string): string | null {
  try {
    return storage?.getItem(key) ?? null;
  } catch {
    return null;
  }
}

function write(storage: GuideStorage | null, key: string, value: string): void {
  try {
    storage?.setItem(key, value);
  } catch {
    // Quota plein ou stockage refusé : l'aide reste simplement visible.
  }
}

/** Les bulles « ? » sont allumées par défaut — seul un « off » explicite les éteint. */
export function readTipsEnabled(storage: GuideStorage | null): boolean {
  return read(storage, GUIDE_TIPS_KEY) !== "off";
}

export function writeTipsEnabled(storage: GuideStorage | null, enabled: boolean): void {
  write(storage, GUIDE_TIPS_KEY, enabled ? "on" : "off");
}

export function readIntroDismissed(storage: GuideStorage | null, screen: GuideScreenKey): boolean {
  return read(storage, guideIntroKey(screen)) === "seen";
}

export function writeIntroDismissed(storage: GuideStorage | null, screen: GuideScreenKey): void {
  write(storage, guideIntroKey(screen), "seen");
}
