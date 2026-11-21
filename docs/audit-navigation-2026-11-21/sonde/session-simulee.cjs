// A SIMULATED signed-in session: nothing is created anywhere. The browser holds a fake
// session in localStorage; every call that would carry it is intercepted here.
const REF = "fasrenmmrkqjoobrztbp";
const USER_ID = "00000000-0000-4000-8000-000000000001";
const b64 = (o) => Buffer.from(JSON.stringify(o)).toString("base64url");
function fakeSession() {
  const now = Math.floor(Date.now() / 1000);
  const user = {
    id: USER_ID,
    aud: "authenticated",
    role: "authenticated",
    email: "probe@example.invalid",
    app_metadata: { provider: "email", providers: ["email"] },
    user_metadata: {},
    identities: [],
    created_at: new Date(now * 1000 - 864e5).toISOString(),
    last_sign_in_at: new Date(now * 1000 - 36e5).toISOString(),
  };
  const access_token = `${b64({ alg: "HS256", typ: "JWT" })}.${b64({ sub: USER_ID, aud: "authenticated", role: "authenticated", exp: now + 3600, iat: now })}.probe`;
  return {
    access_token,
    refresh_token: "probe-refresh",
    token_type: "bearer",
    expires_in: 3600,
    expires_at: now + 3600,
    user,
  };
}
/**
 * profile: { role: "student"|"parent"|"admin", current_parcours_id, display_name, xp, current_streak }
 * log: array receiving one line per intercepted call (to see what a screen asks for).
 */
async function signInAs(ctx, profile, log = [], opts = {}) {
  const session = fakeSession();
  // seed:false = the backend is simulated but the visitor starts WITHOUT a session (he will log in).
  // The seed is written once per tab (a real sign-out must stay signed out across reloads).
  if (opts.seed !== false)
    await ctx.addInitScript(
      ([key, value]) => {
        if (!sessionStorage.getItem("probe.seeded")) {
          sessionStorage.setItem("probe.seeded", "1");
          localStorage.setItem(key, value);
        }
      },
      [`sb-${REF}-auth-token`, JSON.stringify(session)],
    );
  await ctx.route(new RegExp(`https://${REF}\\.supabase\\.co/auth/v1/`), async (route) => {
    const url = route.request().url();
    log.push(`auth ${route.request().method()} ${url.split("/auth/v1/")[1].slice(0, 40)}`);
    if (url.includes("/logout")) return route.fulfill({ status: 204, body: "" });
    if (url.includes("/token")) return route.fulfill({ json: fakeSession() });
    if (url.includes("/user")) return route.fulfill({ json: session.user });
    return route.fulfill({ status: 400, json: { message: "probe: not mocked" } });
  });
  await ctx.route(new RegExp(`https://${REF}\\.supabase\\.co/rest/v1/`), async (route) => {
    const req = route.request();
    const url = new URL(req.url());
    const table = url.pathname.split("/rest/v1/")[1];
    if (table === "profiles" && req.method() === "GET") {
      const wantsObject = (req.headers()["accept"] || "").includes("vnd.pgrst.object");
      const row = {
        id: USER_ID,
        role: "student",
        current_parcours_id: "ecole-7eme-base",
        display_name: "Sonde",
        xp: 1234,
        current_streak: 3,
        ...profile,
      };
      log.push(`rest GET profiles ${url.searchParams.get("select")}`);
      return route.fulfill({ json: wantsObject ? row : [row] });
    }
    if (req.method() === "GET" || req.method() === "HEAD") {
      // Anonymous read: never send the fake token to the real project.
      const headers = { ...req.headers(), authorization: `Bearer ${req.headers()["apikey"]}` };
      log.push(`rest ${req.method()} ${table} (as anon)`);
      return route.continue({ headers });
    }
    log.push(`rest ${req.method()} ${table} BLOCKED`);
    return route.fulfill({ status: 503, json: { message: "probe: write blocked" } });
  });
  // Server fns: forwarded WITHOUT the fake token. A public one answers as for a visitor; one that
  // requires a session is turned into a plain network failure (never an auth refusal, which would
  // end the simulated session).
  await ctx.route(/\/_serverFn\//, async (route) => {
    const req = route.request();
    const headers = { ...req.headers() };
    const hadAuth = "authorization" in headers;
    delete headers.authorization;
    if (req.method() !== "GET") {
      log.push(`serverFn ${req.method()} BLOCKED`);
      return route.abort("failed");
    }
    try {
      const res = await route.fetch({ headers });
      const body = await res.text();
      if (/Unauthorized/.test(body)) {
        log.push(`serverFn GET needs-session → failed`);
        return route.abort("failed");
      }
      log.push(`serverFn GET public ${res.status()}${hadAuth ? "" : " (no token sent)"}`);
      return route.fulfill({ response: res, body });
    } catch (e) {
      return route.abort("failed");
    }
  });
  return session;
}
/** Records every change of the shell's visible state, frame by frame. */
async function installRecorder(ctx) {
  await ctx.addInitScript(() => {
    const vis = (el) => {
      if (!el) return false;
      const r = el.getBoundingClientRect();
      const s = getComputedStyle(el);
      return r.width > 0 && r.height > 0 && s.visibility !== "hidden" && s.display !== "none";
    };
    const sig = () => {
      const pub = document.querySelector("[data-public-header]");
      const app = document.querySelector(".app-shell > header");
      const shellLoading = document.querySelector(".app-shell.grid.place-items-center");
      const tab = document.querySelector('[data-testid="student-tab-bar"]');
      const hud = document.querySelector('[data-testid="account-hud"]');
      const ph = document.querySelector('[data-testid="header-account-placeholder"]');
      const signup = document.querySelector('[data-testid="header-signup"]');
      const main = document.querySelector("main");
      return [
        location.pathname,
        pub
          ? "hdr:public"
          : app
            ? "hdr:app"
            : shellLoading
              ? "FULLSCREEN-LOADING"
              : document.querySelector("main")
                ? "hdr:none"
                : "BLANK",
        vis(tab) ? "tab:yes" : "tab:no",
        vis(hud) ? "hud" : ph ? "acct:placeholder" : vis(signup) ? "acct:signup" : "acct:none",
        main
          ? `main:${(main.innerText || "").trim().length > 0 ? "content" : "empty"}`
          : "main:none",
        `h1:${(document.querySelector("h1")?.textContent || "").trim().slice(0, 24)}`,
      ].join(" | ");
    };
    window.__timeline = [];
    let last = "";
    const tick = () => {
      let s;
      try {
        s = sig();
      } catch {
        s = "?";
      }
      if (s !== last) {
        last = s;
        window.__timeline.push([Math.round(performance.now()), s]);
      }
      requestAnimationFrame(tick);
    };
    const start = () => requestAnimationFrame(tick);
    if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start);
    else start();
    // layout shift
    window.__cls = 0;
    try {
      new PerformanceObserver((l) => {
        for (const e of l.getEntries()) if (!e.hadRecentInput) window.__cls += e.value;
      }).observe({ type: "layout-shift", buffered: true });
    } catch {}
  });
}
async function mark(page) {
  return page.evaluate(() => {
    const n = window.__timeline.length;
    const t = Math.round(performance.now());
    return [n, t, window.__cls];
  });
}
async function since(page, [n, t0, cls0]) {
  return page.evaluate(
    ([n, t0, cls0]) => ({
      steps: window.__timeline.slice(n).map(([t, s]) => `+${t - t0}ms  ${s}`),
      cls: +(window.__cls - cls0).toFixed(3),
    }),
    [n, t0, cls0],
  );
}
module.exports = { signInAs, installRecorder, mark, since, REF, USER_ID };
