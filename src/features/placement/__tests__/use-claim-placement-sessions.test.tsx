import { render, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { useClaimPlacementSessions } from "../use-claim-placement-sessions";
import { rememberPlacement, rememberedTokens } from "../placement-memory";

/**
 * Étude 39 R-16 — le rattachement : une fois par montage, seulement quand une session est lue,
 * les jetons de l'appareil partent, puis l'appareil les oublie ; la mesure ne compte que ce qui
 * a vraiment été rattaché.
 */
const claim = vi.fn();
vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
// Le hook importe la couche serveur : on remplace le MODULE serveur, pas le framework.
vi.mock("../placement.server", () => ({
  claimPlacementSessions: (...a: unknown[]) => claim(...a),
}));
const track = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => track(...a),
}));

const uuid = (n: number) => `${String(n).padStart(8, "0")}-0000-4000-8000-000000000000`;

function Probe({ enabled, onClaimed }: { enabled: boolean; onClaimed?: (ids: string[]) => void }) {
  useClaimPlacementSessions(enabled, onClaimed);
  return null;
}

describe("useClaimPlacementSessions", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
    claim.mockResolvedValue({ claimed: [] });
  });

  it("n'envoie rien sans session, ni sans jeton sur l'appareil", () => {
    render(<Probe enabled={false} />);
    rememberPlacement({
      id: uuid(1),
      token: uuid(101),
      subjectId: "math",
      subjectName: "M",
      at: Date.now(),
    });
    render(<Probe enabled={false} />);
    expect(claim).not.toHaveBeenCalled();
    const { rerender } = render(<Probe enabled={true} />);
    rerender(<Probe enabled={true} />);
    expect(claim).toHaveBeenCalledTimes(1);
  });

  it("rattache, oublie les jetons envoyés, mesure et prévient l'écran", async () => {
    rememberPlacement({
      id: uuid(1),
      token: uuid(101),
      subjectId: "math",
      subjectName: "M",
      at: Date.now(),
    });
    rememberPlacement({
      id: uuid(2),
      token: uuid(102),
      subjectId: "svt",
      subjectName: "S",
      at: Date.now(),
    });
    claim.mockResolvedValue({ claimed: [uuid(1)] });
    const onClaimed = vi.fn();
    render(<Probe enabled onClaimed={onClaimed} />);

    await waitFor(() => expect(onClaimed).toHaveBeenCalledWith([uuid(1)]));
    expect(claim).toHaveBeenCalledWith({
      data: { tokens: expect.arrayContaining([uuid(101), uuid(102)]) },
    });
    // Les deux ont été envoyés : les deux quittent l'appareil (l'un est au compte, l'autre
    // n'était pas à lui).
    expect(rememberedTokens()).toEqual([]);
    expect(track).toHaveBeenCalledWith("placement_claimed", { count: 1 });
  });

  it("rien de rattaché : aucune mesure, aucun appel d'écran", async () => {
    rememberPlacement({
      id: uuid(1),
      token: uuid(101),
      subjectId: "math",
      subjectName: "M",
      at: Date.now(),
    });
    claim.mockResolvedValue({ claimed: [] });
    const onClaimed = vi.fn();
    render(<Probe enabled onClaimed={onClaimed} />);
    await waitFor(() => expect(rememberedTokens()).toEqual([]));
    expect(track).not.toHaveBeenCalled();
    expect(onClaimed).not.toHaveBeenCalled();
  });

  it("un échec réseau garde les jetons : le prochain montage réessaiera", async () => {
    rememberPlacement({
      id: uuid(1),
      token: uuid(101),
      subjectId: "math",
      subjectName: "M",
      at: Date.now(),
    });
    claim.mockRejectedValue(new Error("réseau"));
    render(<Probe enabled />);
    await waitFor(() => expect(claim).toHaveBeenCalledTimes(1));
    expect(rememberedTokens()).toEqual([uuid(101)]);
  });
});
