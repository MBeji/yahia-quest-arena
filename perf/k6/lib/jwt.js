// Decode the `sub` (user id) out of a Supabase access token without verifying
// it — k6 only needs the claim to build the per-user rate-limit key so the
// gameplay scenario reproduces the real advisory-lock distribution (audit C-2).
import encoding from "k6/encoding";

export function jwtSub(jwt) {
  try {
    const payload = jwt.split(".")[1];
    const json = encoding.b64decode(payload.replace(/-/g, "+").replace(/_/g, "/"), "rawstd", "s");
    return JSON.parse(json).sub;
  } catch (_e) {
    return "unknown";
  }
}
