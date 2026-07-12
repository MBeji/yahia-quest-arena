import { useCallback, useEffect, useState } from "react";
import { useServerFn } from "@tanstack/react-start";
import { savePushSubscription, deletePushSubscription } from "./notifications.server";
import { VAPID_PUBLIC_KEY, isPushSupported, urlBase64ToUint8Array } from "./push-client";

/**
 * Push enablement state machine for the UI:
 *  - loading       : still resolving (don't flash a control)
 *  - unsupported   : browser can't do Web Push (e.g. iOS Safari not installed)
 *  - unconfigured  : VAPID public key missing from the build → feature off
 *  - default       : supported & not yet decided (offer "Enable")
 *  - granted       : permission granted AND a subscription is saved
 *  - denied        : permission blocked (must be re-enabled in browser settings)
 */
export type PushState =
  "loading" | "unsupported" | "unconfigured" | "default" | "granted" | "denied";

export function usePush() {
  const [state, setState] = useState<PushState>("loading");
  const [busy, setBusy] = useState(false);
  const save = useServerFn(savePushSubscription);
  const remove = useServerFn(deletePushSubscription);

  useEffect(() => {
    if (!isPushSupported()) {
      setState("unsupported");
      return;
    }
    if (!VAPID_PUBLIC_KEY) {
      setState("unconfigured");
      return;
    }
    if (Notification.permission === "denied") {
      setState("denied");
      return;
    }
    // Granted-but-not-subscribed is treated as "default" so the user can re-arm.
    (async () => {
      try {
        const reg = await navigator.serviceWorker.ready;
        const sub = await reg.pushManager.getSubscription();
        setState(sub ? "granted" : "default");
      } catch {
        setState("default");
      }
    })();
  }, []);

  const enable = useCallback(async () => {
    if (!isPushSupported() || !VAPID_PUBLIC_KEY) return;
    setBusy(true);
    try {
      const permission = await Notification.requestPermission();
      if (permission !== "granted") {
        setState(permission === "denied" ? "denied" : "default");
        return;
      }
      const reg = await navigator.serviceWorker.ready;
      const sub = await reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
      });
      const keys = sub.toJSON().keys ?? {};
      await save({
        data: {
          endpoint: sub.endpoint,
          p256dh: keys.p256dh ?? "",
          auth: keys.auth ?? "",
          userAgent: navigator.userAgent.slice(0, 512),
        },
      });
      setState("granted");
    } finally {
      setBusy(false);
    }
  }, [save]);

  const disable = useCallback(async () => {
    setBusy(true);
    try {
      const reg = await navigator.serviceWorker.ready;
      const sub = await reg.pushManager.getSubscription();
      if (sub) {
        await remove({ data: { endpoint: sub.endpoint } });
        await sub.unsubscribe();
      }
      setState("default");
    } finally {
      setBusy(false);
    }
  }, [remove]);

  return { state, busy, enable, disable };
}
