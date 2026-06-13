import { describe, it, expect, afterEach } from "vitest";
import { urlBase64ToUint8Array, isPushSupported } from "../push-client";

describe("push-client", () => {
  describe("urlBase64ToUint8Array", () => {
    it("decodes (padless) base64 to the expected bytes", () => {
      // "hello" → standard base64 "aGVsbG8=", padless "aGVsbG8".
      expect(Array.from(urlBase64ToUint8Array("aGVsbG8"))).toEqual([104, 101, 108, 108, 111]);
    });
    it("translates URL-safe characters (- and _) back to + and /", () => {
      // bytes [251, 255] → standard base64 "+/8=" → URL-safe "-_8".
      expect(Array.from(urlBase64ToUint8Array("-_8"))).toEqual([251, 255]);
    });
  });

  describe("isPushSupported", () => {
    const w = window as unknown as Record<string, unknown>;
    afterEach(() => {
      delete w.Notification;
      delete w.PushManager;
      // Best-effort cleanup of the navigator.serviceWorker stub.
      try {
        Object.defineProperty(navigator, "serviceWorker", { configurable: true, value: undefined });
      } catch {
        /* ignore */
      }
    });

    function stubAll() {
      w.Notification = function () {};
      w.PushManager = function () {};
      Object.defineProperty(navigator, "serviceWorker", { configurable: true, value: {} });
    }

    it("is true when Notification, serviceWorker and PushManager all exist", () => {
      stubAll();
      expect(isPushSupported()).toBe(true);
    });

    it("is false when PushManager is missing", () => {
      stubAll();
      delete w.PushManager;
      expect(isPushSupported()).toBe(false);
    });

    it("is false when Notification is missing", () => {
      stubAll();
      delete w.Notification;
      expect(isPushSupported()).toBe(false);
    });
  });
});
