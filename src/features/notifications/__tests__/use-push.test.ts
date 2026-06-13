import { renderHook, act, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";

// Mutable mock state for the (otherwise build-time) push-client module.
const h = vi.hoisted(() => ({ vapid: "BPUB" as string | undefined, supported: true }));

vi.mock("../push-client", () => ({
  get VAPID_PUBLIC_KEY() {
    return h.vapid;
  },
  isPushSupported: () => h.supported,
  urlBase64ToUint8Array: () => new Uint8Array([1, 2, 3]),
}));

const mockSave = vi.fn().mockResolvedValue({ ok: true });
const mockRemove = vi.fn().mockResolvedValue({ ok: true });
vi.mock("../notifications.server", () => ({
  savePushSubscription: { __id: "save" },
  deletePushSubscription: { __id: "remove" },
}));
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: { __id?: string }) => (fn?.__id === "save" ? mockSave : mockRemove),
}));

import { usePush } from "../use-push";

let getSubscription: ReturnType<typeof vi.fn>;
let subscribe: ReturnType<typeof vi.fn>;
let unsubscribe: ReturnType<typeof vi.fn>;
let fakeSub: { endpoint: string; toJSON: () => unknown; unsubscribe: ReturnType<typeof vi.fn> };

beforeEach(() => {
  h.vapid = "BPUB";
  h.supported = true;
  mockSave.mockClear();
  mockRemove.mockClear();
  unsubscribe = vi.fn().mockResolvedValue(true);
  fakeSub = {
    endpoint: "https://push/x",
    toJSON: () => ({ keys: { p256dh: "pk", auth: "ak" } }),
    unsubscribe,
  };
  getSubscription = vi.fn().mockResolvedValue(null);
  subscribe = vi.fn().mockResolvedValue(fakeSub);

  (globalThis as unknown as { Notification: unknown }).Notification = {
    permission: "default",
    requestPermission: vi.fn().mockResolvedValue("granted"),
  };
  Object.defineProperty(navigator, "serviceWorker", {
    configurable: true,
    value: { ready: Promise.resolve({ pushManager: { getSubscription, subscribe } }) },
  });
  Object.defineProperty(navigator, "userAgent", { configurable: true, value: "test-UA" });
});

describe("usePush", () => {
  it("reports unsupported when the browser can't do push", async () => {
    h.supported = false;
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("unsupported"));
  });

  it("reports unconfigured when the VAPID key is absent", async () => {
    h.vapid = undefined;
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("unconfigured"));
  });

  it("reports denied when permission is already blocked", async () => {
    (globalThis as unknown as { Notification: { permission: string } }).Notification.permission =
      "denied";
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("denied"));
  });

  it("reports default when supported but not yet subscribed", async () => {
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("default"));
  });

  it("reports granted when a subscription already exists", async () => {
    getSubscription.mockResolvedValue(fakeSub);
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("granted"));
  });

  it("enable() subscribes and persists the subscription", async () => {
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("default"));
    await act(async () => {
      await result.current.enable();
    });
    expect(subscribe).toHaveBeenCalled();
    expect(mockSave).toHaveBeenCalledWith({
      data: { endpoint: "https://push/x", p256dh: "pk", auth: "ak", userAgent: "test-UA" },
    });
    expect(result.current.state).toBe("granted");
  });

  it("disable() unsubscribes and removes the subscription", async () => {
    getSubscription.mockResolvedValue(fakeSub);
    const { result } = renderHook(() => usePush());
    await waitFor(() => expect(result.current.state).toBe("granted"));
    await act(async () => {
      await result.current.disable();
    });
    expect(mockRemove).toHaveBeenCalledWith({ data: { endpoint: "https://push/x" } });
    expect(unsubscribe).toHaveBeenCalled();
    expect(result.current.state).toBe("default");
  });
});
