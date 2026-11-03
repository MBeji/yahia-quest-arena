import type { Locale, TranslationKeys } from "./types";
import { fr } from "./fr";
import { DEFAULT_LOCALE, STORAGE_KEY, isLocale, localeFromCookieHeader } from "./context";

/**
 * Chargement des catalogues par locale (H2-fe, 2026-10-31).
 *
 * Seul `fr` (DEFAULT_LOCALE) reste dans le graphe synchrone — `context.ts` en a
 * besoin pour la valeur par défaut du contexte, et c'est la langue du premier rendu
 * (SSR comme hydratation). `en` et `ar` sont chacun leur propre chunk (`i18n-en` /
 * `i18n-ar`, cf. manualChunks dans vite.config.ts), tiré pour la seule locale du
 * visiteur : avant, le chunk trilingue (192 KB bruts / 66 KB gz) était importé
 * statiquement par index et préchargé sur chaque page, pour deux langues inutiles.
 *
 * Pas de flash ajouté : le chunk de la locale persistée est demandé dès l'évaluation
 * du module client (bas de ce fichier), en parallèle de la création du routeur et de
 * l'hydratation — mesuré en 3G, il arrive ≈ 500 ms avant l'effet post-montage qui
 * applique la locale.
 *
 * ⚠️ Règle de chunk : les fichiers de locale ne doivent partager aucun module entre
 * eux — rolldown fond un module commun à fr/en/ar dans le premier chunk de locale
 * rencontré (ar) et ramène ce chunk dans le graphe statique (mesuré le 2026-10-31,
 * le gain était annulé). Les chunks de locale ne contiennent que des données.
 */
type LazyLocale = Exclude<Locale, "fr">;

const loaded: Partial<Record<Locale, TranslationKeys>> = { fr };
const loaders: Record<LazyLocale, () => Promise<TranslationKeys>> = {
  en: () => import("./en").then((m) => m.en),
  ar: () => import("./ar").then((m) => m.ar),
};
const inflight = new Map<LazyLocale, Promise<TranslationKeys>>();

function isLazy(locale: Locale): locale is LazyLocale {
  return locale in loaders;
}

/** Le catalogue si son chunk est déjà chargé (toujours vrai pour fr). */
export function loadedCatalogue(locale: Locale): TranslationKeys | undefined {
  return loaded[locale];
}

/** Résout le catalogue d'une locale en ne tirant son chunk qu'une seule fois. */
export function loadCatalogue(locale: Locale): Promise<TranslationKeys> {
  const cached = loaded[locale];
  if (cached || !isLazy(locale)) return Promise.resolve(cached ?? fr);
  let pending = inflight.get(locale);
  if (!pending) {
    pending = loaders[locale]().then((catalogue) => {
      loaded[locale] = catalogue;
      return catalogue;
    });
    inflight.set(locale, pending);
  }
  return pending;
}

/**
 * La locale persistée côté client : localStorage d'abord (setLocale écrit les deux,
 * ils concordent donc normalement), puis le cookie que lit le shell SSR.
 */
export function persistedLocale(): Locale {
  if (typeof window === "undefined") return DEFAULT_LOCALE;
  const stored = localStorage.getItem(STORAGE_KEY);
  if (isLocale(stored)) return stored;
  return localeFromCookieHeader(document.cookie);
}

// Préchauffage : le chunk de la locale persistée part dès que le graphe client
// s'évalue, en parallèle du routeur et de l'hydratation. Sous try/catch : une
// SecurityError de stockage (navigation privée, iframe) tuerait sinon tout le
// chunk index — l'effet du provider refera la demande.
if (typeof window !== "undefined") {
  try {
    const warm = persistedLocale();
    if (warm !== DEFAULT_LOCALE) void loadCatalogue(warm).catch(() => {});
  } catch {
    // Pas d'accès au stockage : l'effet post-montage réessaie.
  }
}
