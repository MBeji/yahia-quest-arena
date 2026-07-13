import { renderHook, act, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";

// A controllable fake Realtime channel: records on() handlers + the subscribe
// callback so the test can drive SUBSCRIBED / CHANNEL_ERROR / broadcast events.
type Handler = (arg: unknown) => void;
const handlers: Record<string, Handler> = {};
let subscribeCb: ((status: string) => void) | null = null;
let presence: Record<string, { answered?: number }[]> = {};

const track = vi.fn();
const send = vi.fn();

const fakeChannel = {
  on: vi.fn((type: string, filter: { event: string }, cb: Handler) => {
    handlers[`${type}:${filter.event}`] = cb;
    return fakeChannel;
  }),
  subscribe: vi.fn((cb: (status: string) => void) => {
    subscribeCb = cb;
    return fakeChannel;
  }),
  track,
  send,
  presenceState: () => presence,
};

const channelFactory = vi.fn((..._args: unknown[]) => fakeChannel);
const removeChannel = vi.fn((..._args: unknown[]) => undefined);
const warn = vi.fn((..._args: unknown[]) => undefined);

vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: (...a: unknown[]) => warn(...a), info: vi.fn(), error: vi.fn() },
}));
vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    channel: (...a: unknown[]) => channelFactory(...a),
    removeChannel: (...a: unknown[]) => removeChannel(...a),
  },
}));

import { useDuelChannel } from "../use-duel-channel";

beforeEach(() => {
  for (const k of Object.keys(handlers)) delete handlers[k];
  subscribeCb = null;
  presence = {};
  track.mockClear();
  send.mockClear();
  channelFactory.mockClear();
  warn.mockClear();
});

describe("useDuelChannel", () => {
  it("does not open a channel when disabled", () => {
    renderHook(() => useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 0, enabled: false }));
    expect(channelFactory).not.toHaveBeenCalled();
  });

  it("goes active on SUBSCRIBED and tracks my presence", async () => {
    const { result } = renderHook(() =>
      useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 1, enabled: true }),
    );
    expect(channelFactory).toHaveBeenCalledWith("duel:d1", expect.anything());
    act(() => subscribeCb?.("SUBSCRIBED"));
    await waitFor(() => expect(result.current.realtimeActive).toBe(true));
    expect(track).toHaveBeenCalledWith({ answered: 1 });
  });

  it("updates the live opponent count from a progress broadcast", async () => {
    const { result } = renderHook(() =>
      useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 0, enabled: true }),
    );
    act(() => subscribeCb?.("SUBSCRIBED"));
    act(() => handlers["broadcast:progress"]?.({ payload: { answered: 3 } }));
    await waitFor(() => expect(result.current.liveOpponentAnswered).toBe(3));
  });

  it("reports the opponent online from presence sync", async () => {
    const { result } = renderHook(() =>
      useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 0, enabled: true }),
    );
    act(() => subscribeCb?.("SUBSCRIBED"));
    presence = { other: [{ answered: 2 }] };
    act(() => handlers["presence:sync"]?.(undefined));
    await waitFor(() => expect(result.current.opponentOnline).toBe(true));
    expect(result.current.liveOpponentAnswered).toBe(2);
  });

  it("falls back (R-12) and logs on CHANNEL_ERROR", async () => {
    const { result } = renderHook(() =>
      useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 0, enabled: true }),
    );
    act(() => subscribeCb?.("CHANNEL_ERROR"));
    await waitFor(() => expect(result.current.realtimeActive).toBe(false));
    expect(warn).toHaveBeenCalledWith(
      "duel.realtime_fallback",
      expect.objectContaining({ duelId: "d1", status: "CHANNEL_ERROR" }),
    );
  });

  it("removes the channel on unmount", () => {
    const { unmount } = renderHook(() =>
      useDuelChannel({ duelId: "d1", userId: "me", myAnswered: 0, enabled: true }),
    );
    unmount();
    expect(removeChannel).toHaveBeenCalled();
  });
});
