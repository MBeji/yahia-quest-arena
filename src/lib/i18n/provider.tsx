import { useCallback, useEffect, useLayoutEffect, useRef, useState } from "react";
import type { Locale } from "./types";
import { fr } from "./fr";
import { writeLocal } from "@/shared/lib/safe-storage";
import { loadCatalogue, loadedCatalogue, persistedLocale } from "./catalogues";
import {
  DEFAULT_LOCALE,
  I18nContext,
  LOCALE_COOKIE,
  STORAGE_KEY,
  dirForLocale,
  localeFromCookieHeader,
} from "./context";

const COOKIE_MAX_AGE = 60 * 60 * 24 * 365; // 1 year

function writeLocaleCookie(locale: Locale): void {
  document.cookie = `${LOCALE_COOKIE}=${locale}; path=/; max-age=${COOKIE_MAX_AGE}; SameSite=Lax`;
}

export function I18nProvider({
  children,
  initialLocale = DEFAULT_LOCALE,
}: {
  children: React.ReactNode;
  /**
   * La langue du rendu serveur — celle du cookie de la requête, que `router.tsx`
   * résout des deux côtés et dont il a chargé le catalogue AVANT le rendu. Le premier
   * rendu client reproduit donc le balisage du serveur dans la bonne langue, sans
   * écart d'hydratation ni bascule de texte (issue #1228). Sans elle (tests, arbre
   * monté hors routeur), on démarre en français comme avant.
   */
  initialLocale?: Locale;
}) {
  // On ne démarre dans `initialLocale` que si son catalogue est là : `t` et `locale`
  // doivent toujours concorder. S'il manque (chunk en échec côté client), on retombe
  // sur le français et l'effet ci-dessous redemande la langue persistée. `localStorage`
  // n'est PAS lu ici : le serveur ne le voit pas, le lire au premier rendu ferait
  // diverger l'hydratation — il est réconcilié après le montage.
  const [locale, setLocaleState] = useState<Locale>(() =>
    loadedCatalogue(initialLocale) ? initialLocale : DEFAULT_LOCALE,
  );
  const request = useRef(0);
  // La locale VISÉE : celle que l'élève a persistée, puis chaque demande de
  // `setLocale`. `locale` (l'état) ne la rejoint qu'une fois son catalogue chargé ;
  // l'effet de layout la lit pour ne pas toucher au sens du document entre-temps.
  const wanted = useRef<Locale | null>(null);

  // H2-fe (2026-10-31) : en/ar ne sont plus importés statiquement, leur chunk est
  // tiré par `loadCatalogue`. `locale` ne bascule qu'une fois son catalogue chargé,
  // donc `t` et `locale` concordent toujours ; un catalogue déjà là (fr, toujours)
  // bascule de façon synchrone. Le compteur fait gagner la dernière demande quand
  // deux bascules se croisent pendant un chargement.
  const applyLocale = useCallback((next: Locale) => {
    wanted.current = next;
    const id = ++request.current;
    if (loadedCatalogue(next)) {
      setLocaleState(next);
      return;
    }
    void loadCatalogue(next).then(
      () => {
        if (request.current === id) setLocaleState(next);
      },
      // Chunk introuvable : on reste dans la langue affichée, la prochaine demande
      // (bascule, rechargement) le retentera.
      () => {},
    );
  }, []);

  // Apply the persisted locale (localStorage, then cookie) after mount.
  useEffect(() => {
    const initial = persistedLocale();
    // One-time migration (review #8): legacy users who only have the localStorage
    // value (set before the cookie existed) would otherwise flash the default locale
    // on every SSR load until their next setLocale call writes the cookie. Mirror the
    // resolved locale into the cookie whenever it's missing/stale so the SSR shell
    // reads the right <html lang/dir> from the next request onward.
    if (localeFromCookieHeader(document.cookie) !== initial) {
      writeLocaleCookie(initial);
    }
    applyLocale(initial);
  }, [applyLocale]);

  const setLocale = useCallback(
    (newLocale: Locale) => {
      writeLocal(STORAGE_KEY, newLocale);
      writeLocaleCookie(newLocale);
      applyLocale(newLocale);
    },
    [applyLocale],
  );

  // <html dir/lang> suit la locale appliquée (après hydratation et à chaque bascule).
  // Effet de layout : il tourne dans le même commit que le texte traduit, avant la
  // peinture, pour que sens et texte basculent ensemble — jamais du français en RTL
  // (un effet passif l'a laissé passer une fois sous charge, 2026-10-31).
  //
  // Au commit d'hydratation, `locale` est celle du cookie, comme le shell SSR
  // (__root.tsx) — sauf si `localStorage` en vise une autre (cookie périmé) ou si le
  // chunk a manqué. Si la locale visée est une autre dont le chunk est encore en vol,
  // on ne touche à rien : écrire « ltr / fr » ici
  // faisait voir à l'élève arabophone du français en LTR, puis une seconde bascule
  // de sens quand le chunk arrivait (revue du 2026-11-03). Quand la locale visée est
  // bien celle appliquée (persistée = fr, ou catalogue déjà là), on écrit : c'est ce
  // qui corrige un cookie périmé que localStorage contredit.
  useLayoutEffect(() => {
    wanted.current ??= persistedLocale();
    if (locale !== wanted.current) return;
    document.documentElement.dir = dirForLocale(locale);
    document.documentElement.lang = locale;
  }, [locale]);

  const t = loadedCatalogue(locale) ?? fr;
  const dir = dirForLocale(locale);

  return (
    <I18nContext.Provider value={{ locale, t, setLocale, dir }}>{children}</I18nContext.Provider>
  );
}
