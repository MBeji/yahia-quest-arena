import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { AI_LIVE_FEATURES } from "@/shared/constants/ai";
import type { AiStudentAccess } from "../ai-access.server";

/**
 * ALLUMER UN ÉLÈVE L'ALLUME VRAIMENT — arbitrage du 2026-08-26.
 *
 * Le geste d'activation écrivait `features: []` : le mode passait à « allumé »
 * et aucune surface ne l'était. Le porteur qui s'arrêtait à l'interrupteur —
 * c'est-à-dire celui qui fait le geste évident — obtenait un mode allumé qui
 * n'allume rien, et en concluait que sa clé ne servait à rien. C'est
 * exactement le signalement d'usage qui a déclenché cet arbitrage.
 *
 * Ce que ces tests fixent : le pré-remplissage à l'allumage, et le fait qu'il
 * ne PIÉTINE PAS un choix déjà fait — un porteur qui a restreint son enfant
 * retrouve sa restriction quand il rallume.
 */

let students: AiStudentAccess[] = [];
const saved: unknown[] = [];

vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: students }),
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: () => (args: unknown) => {
    saved.push(args);
    return Promise.resolve({ ok: true });
  },
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, {
      get: (_target, key: string) => `ai.${key}`,
    }),
  }),
}));

import { AiStudentsPanel } from "../components/ai-students-panel";

const STUDENT = "22222222-2222-4222-8222-222222222222";

function student(overrides: Partial<AiStudentAccess> = {}): AiStudentAccess {
  return {
    studentUserId: STUDENT,
    displayName: "Yahia",
    isSelf: false,
    enabled: false,
    features: [],
    dailyEnergyMax: 10,
    energySpentToday: 0,
    ...overrides,
  };
}

/** Le dernier `data` envoyé à `setAiStudentAccess`. */
function lastSave() {
  const call = saved.at(-1) as { data: { enabled: boolean; features: string[] } };
  return call.data;
}

beforeEach(() => {
  saved.length = 0;
  students = [student()];
});

describe("AiStudentsPanel — l'activation", () => {
  it("allumer un élève ouvre TOUTES les surfaces que la clé paie", async () => {
    render(<AiStudentsPanel />);
    await userEvent.click(screen.getByTestId(`ai-student-toggle-${STUDENT}`));

    expect(lastSave().enabled).toBe(true);
    expect(lastSave().features).toEqual([...AI_LIVE_FEATURES]);
  });

  it("ne piétine PAS une restriction déjà posée", async () => {
    // Un porteur qui n'a laissé que la Forge à son enfant, puis coupe et
    // rallume, retrouve la Forge — pas les six surfaces.
    students = [student({ features: ["forge"] })];
    render(<AiStudentsPanel />);
    await userEvent.click(screen.getByTestId(`ai-student-toggle-${STUDENT}`));

    expect(lastSave()).toMatchObject({ enabled: true, features: ["forge"] });
  });

  it("éteindre ne touche pas à la sélection", async () => {
    students = [student({ enabled: true, features: [...AI_LIVE_FEATURES] })];
    render(<AiStudentsPanel />);
    await userEvent.click(screen.getByTestId(`ai-student-toggle-${STUDENT}`));

    expect(lastSave()).toMatchObject({ enabled: false, features: [...AI_LIVE_FEATURES] });
  });

  it("propose une puce par surface payée, et aucune de plus", () => {
    students = [student({ enabled: true, features: [...AI_LIVE_FEATURES] })];
    render(<AiStudentsPanel />);

    for (const feature of AI_LIVE_FEATURES) {
      expect(screen.getByTestId(`ai-feature-${feature}`)).toBeInTheDocument();
    }
    // `check` et `exercise_gen` n'appellent aucun modèle : les proposer serait
    // un interrupteur qui n'allume rien.
    expect(screen.queryByTestId("ai-feature-check")).not.toBeInTheDocument();
    expect(screen.queryByTestId("ai-feature-exercise_gen")).not.toBeInTheDocument();
  });
});
