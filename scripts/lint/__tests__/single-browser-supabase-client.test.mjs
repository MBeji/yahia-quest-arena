// @vitest-environment node
import { RuleTester } from "eslint";
import { afterAll, describe, it } from "vitest";
import tseslint from "typescript-eslint";

import { singleBrowserSupabaseClient } from "../eslint-rules/single-browser-supabase-client.mjs";

// Wire ESLint's RuleTester into vitest's runner (it drives describe/it itself).
RuleTester.afterAll = afterAll;
RuleTester.describe = describe;
RuleTester.it = it;
RuleTester.itOnly = it.only;

const ruleTester = new RuleTester({
  languageOptions: {
    parser: tseslint.parser,
    ecmaVersion: 2022,
    sourceType: "module",
  },
});

const FEATURE = "D:/repo/src/features/quest/components/exercise-player.tsx";
const FACTORY = "D:/repo/src/shared/integrations/supabase/client.ts";
const PER_REQUEST = "D:/repo/src/shared/integrations/supabase/auth-request.ts";
const TEST_FILE = "D:/repo/src/shared/integrations/supabase/__tests__/client.test.ts";

ruleTester.run("single-browser-supabase-client", singleBrowserSupabaseClient, {
  valid: [
    {
      name: "la factory du navigateur a le droit de créer LE client",
      filename: FACTORY,
      code: `
        import { createClient } from "@supabase/supabase-js";
        export const supabase = createClient(url, key);
      `,
    },
    {
      name: "le client par requête reste autorisé — il porte le Bearer de l'appelant",
      filename: PER_REQUEST,
      code: `
        import { createClient } from "@supabase/supabase-js";
        export function resolve(token) { return createClient(url, key, { global: { headers: {} } }); }
      `,
    },
    {
      name: "un test qui appelle la factory n'est pas du code de production",
      filename: TEST_FILE,
      code: `
        import { createClient } from "@supabase/supabase-js";
        createClient("https://x.test", "key");
      `,
    },
    {
      name: "importer le singleton est le geste ATTENDU",
      filename: FEATURE,
      code: `
        import { supabase } from "@/shared/integrations/supabase/client";
        export const run = () => supabase.auth.getSession();
      `,
    },
    {
      name: "un createClient venu d'ailleurs que de Supabase ne concerne pas la règle",
      filename: FEATURE,
      code: `
        import { createClient } from "some-other-sdk";
        export const c = createClient();
      `,
    },
  ],

  invalid: [
    {
      // LE CONTRÔLE NÉGATIF : sans ce cas, un lint vert ne prouverait rien —
      // il pourrait aussi bien signifier que la règle ne voit plus rien.
      name: "un composant qui se fabrique son propre client est refusé",
      filename: FEATURE,
      code: `
        import { createClient } from "@supabase/supabase-js";
        const supabase = createClient(url, key);
      `,
      errors: [{ messageId: "extraClient" }],
    },
    {
      name: "un alias d'import ne suffit pas à passer",
      filename: FEATURE,
      code: `
        import { createClient as makeClient } from "@supabase/supabase-js";
        const supabase = makeClient(url, key);
      `,
      errors: [{ messageId: "extraClient" }],
    },
    {
      name: "chaque création est signalée, pas seulement la première",
      filename: FEATURE,
      code: `
        import { createClient } from "@supabase/supabase-js";
        const a = createClient(url, key);
        const b = createClient(url, key);
      `,
      errors: [{ messageId: "extraClient" }, { messageId: "extraClient" }],
    },
    {
      name: "createBrowserClient est refusé même dans une factory autorisée",
      filename: FACTORY,
      code: `
        import { createBrowserClient } from "@supabase/ssr";
        export const supabase = createBrowserClient(url, key);
      `,
      errors: [{ messageId: "browserClient" }],
    },
    {
      name: "createBrowserClient est refusé dans un composant",
      filename: FEATURE,
      code: `
        import { createBrowserClient } from "@supabase/ssr";
        export const supabase = createBrowserClient(url, key);
      `,
      errors: [{ messageId: "browserClient" }],
    },
  ],
});
