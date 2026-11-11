// @vitest-environment node
import { RuleTester } from "eslint";
import { afterAll, describe, it } from "vitest";
import tseslint from "typescript-eslint";

import { noCrossFeatureImport } from "../eslint-rules/no-cross-feature-import.mjs";

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

const DUEL = "D:/repo/src/features/duel/components/duel-arena.tsx";
const DUEL_TEST = "/home/ci/repo/src/features/duel/__tests__/duel-components.test.tsx";
const ROUTE = "/home/ci/repo/src/routes/_authenticated/duel.$duelId.tsx";
const SHARED = "/home/ci/repo/src/shared/lib/quest-labels.ts";

/** Une erreur attendue depuis `duel` — le message cite la feature visée et le spécificateur. */
const err = (to, specifier) => ({
  messageId: "crossFeature",
  data: { from: "duel", to, specifier },
});

ruleTester.run("no-cross-feature-import", noCrossFeatureImport, {
  valid: [
    {
      name: "une feature importe ses propres modules, absolus ou relatifs",
      filename: DUEL,
      code: `
        import { x } from "@/features/duel/duel.server";
        import { y } from "../duel-labels";
        import { z } from "./league-podium";
      `,
    },
    {
      name: "une feature importe le partagé et l'interface transverse",
      filename: DUEL,
      code: `
        import { buildQuestLabels } from "@/shared/lib/quest-labels";
        import { QuestionInput } from "@/components/game/question-input";
        import { motion } from "motion/react";
      `,
    },
    {
      name: "une route compose plusieurs features — c'est son rôle",
      filename: ROUTE,
      code: `
        import { DuelArena } from "@/features/duel";
        import { buildQuestLabels } from "@/features/quest";
      `,
    },
    {
      name: "le partagé n'est pas une feature",
      filename: SHARED,
      code: `import { t } from "@/features/quest";`,
    },
    {
      name: "un nom de feature qui en préfixe un autre n'est pas une autre feature",
      filename: "/repo/src/features/ai/forge.server.ts",
      code: `import { x } from "@/features/ai/components/forge-panel";`,
    },
  ],
  invalid: [
    {
      name: "import statique d'une autre feature",
      filename: DUEL,
      code: `import { Confetti } from "@/features/quest/components/confetti";`,
      errors: [err("quest", "@/features/quest/components/confetti")],
    },
    {
      name: "barrel d'une autre feature",
      filename: DUEL,
      code: `import { callAi } from "@/features/ai";`,
      errors: [err("ai", "@/features/ai")],
    },
    {
      name: "chemin relatif qui sort de la feature",
      filename: DUEL,
      code: `import { QuestionInput } from "../../quest/components/question-input";`,
      errors: [err("quest", "../../quest/components/question-input")],
    },
    {
      name: "ré-export et import dynamique",
      filename: DUEL,
      code: `
        export { buildQuestLabels } from "@/features/quest/quest-labels";
        export * from "@/features/quest";
        const m = () => import("@/features/tutor/tutor.server");
      `,
      errors: [
        err("quest", "@/features/quest/quest-labels"),
        err("quest", "@/features/quest"),
        err("tutor", "@/features/tutor/tutor.server"),
      ],
    },
    {
      name: "un test qui mocke une autre feature la couple comme le code le ferait",
      filename: DUEL_TEST,
      code: `
        vi.mock("@/features/quest/quest-labels", () => ({}));
        vi.doMock("@/features/ai/ai-call.server");
      `,
      errors: [
        err("quest", "@/features/quest/quest-labels"),
        err("ai", "@/features/ai/ai-call.server"),
      ],
    },
  ],
});
