/**
 * Client-only Web Push helpers (browser APIs only — never imported server-side).
 */

/** Public VAPID key, inlined at build time. Undefined ⇒ push UI stays hidden. */
export const VAPID_PUBLIC_KEY = import.meta.env.VITE_VAPID_PUBLIC_KEY as string | undefined;

/** Whether this browser can do Web Push at all (Notification + SW + PushManager). */
export function isPushSupported(): boolean {
  return (
    typeof window !== "undefined" &&
    "Notification" in window &&
    "serviceWorker" in navigator &&
    "PushManager" in window
  );
}

/**
 * VAPID keys are URL-safe base64; PushManager.subscribe() wants the raw bytes as
 * a Uint8Array. Standard conversion (pad, swap URL-safe chars, decode).
 */
export function urlBase64ToUint8Array(base64String: string): Uint8Array<ArrayBuffer> {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const raw = atob(base64);
  // Build on an explicit ArrayBuffer so the result is Uint8Array<ArrayBuffer>
  // (a valid BufferSource for PushManager.subscribe), not <ArrayBufferLike>.
  const output = new Uint8Array(new ArrayBuffer(raw.length));
  for (let i = 0; i < raw.length; i++) output[i] = raw.charCodeAt(i);
  return output;
}
