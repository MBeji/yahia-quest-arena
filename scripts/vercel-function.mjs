/**
 * Le plafond de durée de la fonction SSR sur Vercel — UNE seule valeur.
 *
 * Elle était écrite trois fois : dans la config de la fonction
 * (`build-vercel.mjs`), recopiée en dur dans un test, et ajustée à la main dans
 * le délai client de `scripts/ai/tutor-digests.mjs`. C'est exactement
 * l'invariant maintenu à la main qui a dérivé : le client a attendu 35 s pendant
 * que le serveur passait à 300, et abandonnait des tranches que le serveur avait
 * le droit de finir.
 *
 * Module JS pur, sans import ni effet de bord : `build-vercel.mjs` le lit sur le
 * builder de Vercel, dont la version de Node ne se pilote pas d'ici — pas de
 * `.ts` à dépouiller de ses types. Ses types vivent à côté
 * (`vercel-function.d.mts`) pour que les tests TypeScript l'importent proprement.
 *
 * 300 s = le maximum du plan Hobby sous `fluid compute` (doc Vercel, relevée le
 * 2026-08-25). ⚠️ Toute valeur de `AI_TIMEOUT_MS` doit rester strictement en
 * dessous : `src/features/ai/__tests__/forge-timeout.test.ts` le vérifie.
 */
export const SSR_MAX_DURATION_S = 300;
