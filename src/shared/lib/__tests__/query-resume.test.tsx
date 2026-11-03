import { act, render, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider, useQuery } from "@tanstack/react-query";
import React from "react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { RESUME_REFETCH_AFTER_MS, refetchOnlyIfOlderThan } from "../query-resume";

/**
 * Sonde data-02 (2026-10-31) : le VRAI query-core, 9 queries montées (le jeu du
 * tableau de bord), un `visibilitychange` ou une reconnexion dispatchés sur
 * `window` — exactement ce que focusManager et onlineManager écoutent. Seule
 * l'horloge est truquée (`Date`), pour vieillir les données sans attendre.
 */

const T0 = new Date("2026-10-31T10:00:00Z").getTime();
const DASHBOARD_KEYS = [
  "dashboard",
  "sprint2",
  "daily-ring",
  "active-event",
  "weekly-recap",
  "learning-state",
  "frontier",
  "family-goal",
  "ai-surfaces",
] as const;

function Probe({
  name,
  calls,
  refetchOnWindowFocus,
  refetchOnReconnect,
  fail = false,
}: {
  name: string;
  calls: Map<string, number>;
  refetchOnWindowFocus?: boolean;
  refetchOnReconnect?: boolean;
  fail?: boolean;
}) {
  useQuery({
    queryKey: [name],
    queryFn: async () => {
      calls.set(name, (calls.get(name) ?? 0) + 1);
      if (fail) throw new Error("down");
      return name;
    },
    ...(refetchOnWindowFocus !== undefined ? { refetchOnWindowFocus } : {}),
    ...(refetchOnReconnect !== undefined ? { refetchOnReconnect } : {}),
  });
  return null;
}

function makeClient() {
  // Les défauts de `router.tsx` : staleTime 30 s, et le seuil de reprise 5 min.
  return new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: 30_000,
        retry: false,
        refetchOnWindowFocus: refetchOnlyIfOlderThan(RESUME_REFETCH_AFTER_MS),
        refetchOnReconnect: refetchOnlyIfOlderThan(RESUME_REFETCH_AFTER_MS),
      },
    },
  });
}

const total = (calls: Map<string, number>) => [...calls.values()].reduce((a, b) => a + b, 0);

async function focusAt(offsetMs: number) {
  vi.setSystemTime(T0 + offsetMs);
  await act(async () => {
    window.dispatchEvent(new Event("visibilitychange"));
  });
}

async function reconnectAt(offsetMs: number) {
  vi.setSystemTime(T0 + offsetMs);
  // `setOnline` est un no-op sans bascule : il faut une vraie transition.
  await act(async () => {
    window.dispatchEvent(new Event("offline"));
  });
  await act(async () => {
    window.dispatchEvent(new Event("online"));
  });
}

describe("refetchOnlyIfOlderThan — reprise au retour d'onglet / de réseau", () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(T0);
    Object.defineProperty(document, "visibilityState", { value: "visible", configurable: true });
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  it("ne relance rien sous 5 min d'absence, tout au-delà (focus ET reconnexion)", async () => {
    const calls = new Map<string, number>();
    const qc = makeClient();
    render(
      <QueryClientProvider client={qc}>
        {DASHBOARD_KEYS.map((k) => (
          <Probe key={k} name={k} calls={calls} />
        ))}
      </QueryClientProvider>,
    );
    await waitFor(() => expect(total(calls)).toBe(9));

    // Détour calculatrice (31 s : périmée pour la staleTime, pas pour la reprise).
    await focusAt(31_000);
    await reconnectAt(31_000);
    expect(total(calls)).toBe(9);

    await focusAt(4 * 60_000);
    await reconnectAt(4 * 60_000);
    expect(total(calls)).toBe(9);

    // Absence longue : la page restée ouverte se rafraîchit comme avant.
    await focusAt(5 * 60_000 + 1_000);
    await waitFor(() => expect(total(calls)).toBe(18));

    await reconnectAt(11 * 60_000);
    await waitFor(() => expect(total(calls)).toBe(27));
    qc.clear();
  });

  it("respecte les opt-in (`true`, classement) et opt-out (`false`, joueur) par query", async () => {
    const calls = new Map<string, number>();
    const qc = makeClient();
    render(
      <QueryClientProvider client={qc}>
        <Probe name="leaderboard" calls={calls} refetchOnWindowFocus refetchOnReconnect={false} />
        <Probe
          name="exercise"
          calls={calls}
          refetchOnWindowFocus={false}
          refetchOnReconnect={false}
        />
        <Probe name="dashboard" calls={calls} />
      </QueryClientProvider>,
    );
    await waitFor(() => expect(total(calls)).toBe(3));

    await focusAt(31_000);
    await waitFor(() => expect(calls.get("leaderboard")).toBe(2));
    expect(calls.get("dashboard")).toBe(1);
    expect(calls.get("exercise")).toBe(1);

    await focusAt(20 * 60_000);
    await waitFor(() => expect(calls.get("dashboard")).toBe(2));
    expect(calls.get("leaderboard")).toBe(3);
    expect(calls.get("exercise")).toBe(1);

    // Reconnexion 20 min plus tard : le défaut relance, l'opt-out `false` jamais.
    await reconnectAt(40 * 60_000);
    await waitFor(() => expect(calls.get("dashboard")).toBe(3));
    expect(calls.get("leaderboard")).toBe(3);
    expect(calls.get("exercise")).toBe(1);
    qc.clear();
  });

  it("laisse `refetchOnMount` intact : une navigation relit une donnée de 31 s", async () => {
    const calls = new Map<string, number>();
    const qc = makeClient();
    const tree = (
      <QueryClientProvider client={qc}>
        <Probe name="subject" calls={calls} />
      </QueryClientProvider>
    );
    const { unmount } = render(tree);
    await waitFor(() => expect(calls.get("subject")).toBe(1));
    unmount();

    vi.setSystemTime(T0 + 31_000);
    render(tree);
    await waitFor(() => expect(calls.get("subject")).toBe(2));
    qc.clear();
  });

  it("relance au focus une query sans donnée (en erreur), comme avant", async () => {
    const calls = new Map<string, number>();
    const qc = makeClient();
    render(
      <QueryClientProvider client={qc}>
        <Probe name="broken" calls={calls} fail />
      </QueryClientProvider>,
    );
    await waitFor(() => expect(calls.get("broken")).toBe(1));
    await waitFor(() => expect(qc.getQueryState(["broken"])?.status).toBe("error"));

    await focusAt(1_000);
    await waitFor(() => expect(calls.get("broken")).toBe(2));
    qc.clear();
  });

  it("juge l'âge de la donnée, pas celui de la query", () => {
    const older = refetchOnlyIfOlderThan(1_000);
    const at = (dataUpdatedAt: number) =>
      older({ state: { dataUpdatedAt } } as unknown as Parameters<typeof older>[0]);
    vi.setSystemTime(T0);
    expect(at(T0 - 999)).toBe(false);
    expect(at(T0 - 1_000)).toBe(true);
    expect(at(0)).toBe(true);
  });
});
