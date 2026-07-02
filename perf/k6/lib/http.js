// Thin PostgREST helpers for the k6 suite.
import http from "k6/http";
import { check } from "k6";
import { SUPABASE_URL, ANON_KEY } from "./config.js";

function headers(jwt) {
  return {
    apikey: ANON_KEY,
    Authorization: `Bearer ${jwt || ANON_KEY}`,
    "Content-Type": "application/json",
    Accept: "application/json",
  };
}

// Call a SECURITY DEFINER RPC over PostgREST, exactly as the SSR server fns do.
export function rpc(name, body, jwt, tags = {}) {
  const res = http.post(`${SUPABASE_URL}/rest/v1/rpc/${name}`, JSON.stringify(body || {}), {
    headers: headers(jwt),
    tags: { name, ...tags },
  });
  check(res, {
    [`${name} status 2xx`]: (r) => r.status >= 200 && r.status < 300,
  });
  return res;
}

// REST table read (GET) with RLS applied under the user JWT.
export function select(path, jwt, tags = {}) {
  const res = http.get(`${SUPABASE_URL}/rest/v1/${path}`, {
    headers: headers(jwt),
    tags: { name: path.split("?")[0], ...tags },
  });
  check(res, {
    [`GET ${path.split("?")[0]} status 2xx`]: (r) => r.status >= 200 && r.status < 300,
  });
  return res;
}
