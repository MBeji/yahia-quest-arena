import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import {
  RETURN_TO_TTL_MS,
  consumeReturnTo,
  isSafeReturnPath,
  peekReturnReason,
  peekReturnTo,
  rememberCurrentPage,
  rememberReturnTo,
} from "../return-to";

/**
 * Étude 38 lot 1 — le retour au point de départ.
 *
 * Ce module est la SEULE porte entre une source qu'on ne contrôle pas (une URL, un stockage qu'une
 * autre page a pu écrire) et `router.history.push(...)`. Ces tests sont donc surtout des cas
 * hostiles : un chemin qui sort de l'origine est un redirect ouvert.
 */
describe("isSafeReturnPath (R-1)", () => {
  it.each([
    ["/chapitre/c1", "/chapitre/c1"],
    ["/quest/abc?variant=recall", "/quest/abc?variant=recall"],
    ["/programme?cycle=college", "/programme?cycle=college"],
    ["/", "/"],
    ["/authors", "/authors"],
    ["/a/../b", "/b"],
  ])("garde %s", (raw, expected) => {
    expect(isSafeReturnPath(raw)).toBe(expected);
  });

  it("retire le fragment : c'est là que Supabase dépose ses jetons", () => {
    expect(isSafeReturnPath("/matiere/x#access_token=secret&refresh_token=secret")).toBe(
      "/matiere/x",
    );
  });

  it("laisse un « %2f » encodé là où il est : un segment, pas un « // »", () => {
    expect(isSafeReturnPath("/%2f%2fevil.tn")).toBe("/%2f%2fevil.tn");
  });

  it.each([
    ["rien", undefined],
    ["null", null],
    ["un nombre", 123],
    ["un objet", { path: "/x" }],
    ["la chaîne vide", ""],
    ["un chemin relatif", "chapitre/c1"],
    ["une adresse absolue", "https://evil.tn/phish"],
    ["un schéma javascript", "javascript:alert(1)"],
    ["un schéma data", "data:text/html,<script>alert(1)</script>"],
    ["un protocole-relatif", "//evil.tn"],
    ["un protocole-relatif en antislash", "/\\evil.tn"],
    ["un double antislash", "/\\\\evil.tn"],
    ["un antislash au milieu", "/chapitre\\c1"],
    ["une tabulation qui reforme « // »", "/\t/evil.tn"],
    ["un saut de ligne", "/chapitre/c1\nSet-Cookie: x=1"],
    ["un caractère nul", "/chapitre/c1\u0000"],
    ["un caractère de contrôle DEL", "/chapitre/\u007fc1"],
  ])("refuse %s", (_label, raw) => {
    expect(isSafeReturnPath(raw)).toBeNull();
  });

  it("refuse le tunnel lui-même : y « revenir » boucle", () => {
    for (const funnel of [
      "/auth",
      "/auth?mode=login",
      "/auth/reset",
      "/login",
      "/signup",
      "/signup?x=1",
    ]) {
      expect(isSafeReturnPath(funnel), funnel).toBeNull();
    }
  });

  it("borne la longueur à 512 caractères", () => {
    expect(isSafeReturnPath("/" + "a".repeat(511))).not.toBeNull();
    expect(isSafeReturnPath("/" + "a".repeat(512))).toBeNull();
  });

  // Revue de sécurité du lot 1 : la NORMALISATION de l'URL (segments « . » et « .. ») peut faire
  // apparaître un « // » que la chaîne d'origine n'avait pas. Le contrôle sur l'origine ne le voit pas ;
  // sans le contrôle sur le résultat, la fonction rend un chemin protocole-relatif.
  it.each([
    "/.//evil.tn",
    "/a/..//x",
    "/%2e//x",
    "/..//evil.tn/phish",
    "/././/evil.tn",
    "/a/b/../..//evil.tn",
  ])("refuse %s : la normalisation en ferait un « // »", (raw) => {
    expect(isSafeReturnPath(raw)).toBeNull();
  });

  it("refuse le tunnel quelle que soit la casse : le routeur apparie /AUTH à /auth", () => {
    for (const funnel of ["/AUTH", "/Auth?mode=signup", "/LOGIN", "/SignUp", "/aUtH/reset"]) {
      expect(isSafeReturnPath(funnel), funnel).toBeNull();
    }
  });

  it("ne refuse pas un chemin qui COMMENCE comme le tunnel sans en être un", () => {
    expect(isSafeReturnPath("/authors")).toBe("/authors");
    expect(isSafeReturnPath("/Authors?x=1")).toBe("/Authors?x=1");
    expect(isSafeReturnPath("/login-help")).toBe("/login-help");
  });

  /**
   * Les invariants que la fonction PROMET, sur un corpus engendré plutôt que sur des exemples choisis :
   * c'est ainsi que le « // » d'après normalisation a été trouvé, et pas par les exemples. Tout ce qui
   * sort est un chemin interne sans « // » ni antislash ni contrôle, hors tunnel — et rejouer la
   * fonction sur sa propre sortie ne change rien (sinon la mémoire écrit ce qu'elle refusera de relire).
   */
  it("tient ses promesses sur un corpus engendré, et est idempotente", () => {
    const pieces = [
      "/",
      ".",
      "..",
      "%2e",
      "%2E",
      "%2f",
      "%5c",
      "\\",
      "a",
      "auth",
      "?",
      "#",
      "x=1",
      "\t",
    ];
    let kept = 0;
    const walk = (prefix: string, depth: number) => {
      const out = isSafeReturnPath(prefix);
      if (out !== null) {
        kept += 1;
        expect(out.startsWith("/"), prefix).toBe(true);
        expect(out.startsWith("//"), prefix).toBe(false);
        expect(out.includes("\\"), prefix).toBe(false);
        expect(out.includes("#"), prefix).toBe(false);
        expect(/^\/(?:auth|login|signup)(?:[/?]|$)/i.test(out), prefix).toBe(false);
        expect(isSafeReturnPath(out), prefix).toBe(out);
      }
      if (depth === 0) return;
      for (const piece of pieces) walk(prefix + piece, depth - 1);
    };
    for (const piece of pieces) walk("/" + piece, 3);
    // Le corpus n'est pas vide de cas acceptés : sinon l'invariant ne mesurerait rien.
    expect(kept).toBeGreaterThan(1000);
  });
});

describe("la mémoire du retour (R-2, R-3)", () => {
  const T0 = Date.parse("2026-10-30T12:00:00.000Z");

  beforeEach(() => window.localStorage.clear());
  afterEach(() => vi.restoreAllMocks());

  it("retient un chemin sûr, et le rend sans le consommer", () => {
    expect(rememberReturnTo("/chapitre/c1", T0)).toBe(true);
    expect(peekReturnTo(T0)).toBe("/chapitre/c1");
    expect(peekReturnTo(T0)).toBe("/chapitre/c1");
  });

  it("ne sert QU'UNE FOIS : consumeReturnTo le rend puis l'oublie", () => {
    rememberReturnTo("/chapitre/c1", T0);
    expect(consumeReturnTo(T0)).toBe("/chapitre/c1");
    expect(consumeReturnTo(T0)).toBeNull();
    expect(peekReturnTo(T0)).toBeNull();
  });

  it("refuse un chemin dangereux, et ne touche pas à un bon retour déjà gardé", () => {
    rememberReturnTo("/chapitre/c1", T0);
    expect(rememberReturnTo("//evil.tn", T0)).toBe(false);
    expect(rememberReturnTo("/auth", T0)).toBe(false);
    expect(peekReturnTo(T0)).toBe("/chapitre/c1");
  });

  it("le dernier retour remplace le précédent", () => {
    rememberReturnTo("/chapitre/c1", T0);
    rememberReturnTo("/matiere/m1", T0 + 1000);
    expect(peekReturnTo(T0 + 2000)).toBe("/matiere/m1");
  });

  it("expire après 24 heures, et l'expiré est effacé au passage", () => {
    rememberReturnTo("/chapitre/c1", T0);
    expect(peekReturnTo(T0 + RETURN_TO_TTL_MS - 1)).toBe("/chapitre/c1");
    expect(consumeReturnTo(T0 + RETURN_TO_TTL_MS + 1)).toBeNull();
    expect(window.localStorage.getItem("na9ra.returnTo.v1")).toBeNull();
  });

  it("ignore une entrée datée du futur (horloge déréglée)", () => {
    rememberReturnTo("/chapitre/c1", T0 + 60_000);
    expect(peekReturnTo(T0)).toBeNull();
  });

  it("le stockage est une source NON FIABLE : une entrée dangereuse écrite ailleurs est ignorée", () => {
    window.localStorage.setItem("na9ra.returnTo.v1", JSON.stringify({ path: "//evil.tn", at: T0 }));
    expect(peekReturnTo(T0)).toBeNull();
    window.localStorage.setItem(
      "na9ra.returnTo.v1",
      JSON.stringify({ path: "javascript:alert(1)", at: T0 }),
    );
    expect(consumeReturnTo(T0)).toBeNull();
  });

  it.each([
    ["du JSON cassé", "{pas du json"],
    ["un tableau", "[1,2]"],
    ["null", "null"],
    ["une date qui n'est pas un nombre", JSON.stringify({ path: "/x", at: "hier" })],
    ["un chemin qui n'est pas une chaîne", JSON.stringify({ path: 42, at: 1 })],
  ])("ignore %s", (_label, raw) => {
    window.localStorage.setItem("na9ra.returnTo.v1", raw);
    expect(peekReturnTo(T0)).toBeNull();
  });

  it("un stockage qui lève (navigation privée, quota) ne casse jamais la page", () => {
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(() => {
      throw new Error("QuotaExceededError");
    });
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new Error("SecurityError");
    });
    vi.spyOn(Storage.prototype, "removeItem").mockImplementation(() => {
      throw new Error("SecurityError");
    });
    expect(rememberReturnTo("/chapitre/c1", T0)).toBe(false);
    expect(peekReturnTo(T0)).toBeNull();
    expect(consumeReturnTo(T0)).toBeNull();
  });
});

describe("rememberCurrentPage — les invitations retiennent LA PAGE OÙ L'ON EST (R-4)", () => {
  beforeEach(() => window.localStorage.clear());
  afterEach(() => window.history.replaceState({}, "", "/"));

  it("retient le chemin et la requête de la page courante", () => {
    window.history.replaceState({}, "", "/chapitre/c1?x=1");
    expect(rememberCurrentPage()).toBe(true);
    expect(peekReturnTo()).toBe("/chapitre/c1?x=1");
  });

  it("ne retient pas l'accueil public : le Hall vaut mieux que la vitrine", () => {
    window.history.replaceState({}, "", "/");
    expect(rememberCurrentPage()).toBe(false);
    expect(peekReturnTo()).toBeNull();
  });

  it("ne retient pas le tunnel", () => {
    window.history.replaceState({}, "", "/auth?mode=signup");
    expect(rememberCurrentPage()).toBe(false);
  });

  // Revue de sécurité du lot 1 : `?code=` y porte le code d'alliance d'un enfant — une clé au porteur
  // que la page ne garde sur l'appareil que si le parent laisse « se souvenir » coché. La mémoire du
  // retour dure vingt-quatre heures et « oublier » ne la vide pas.
  it.each(["/suivi?code=ABCD1234", "/suivi/?code=ABCD1234", "/SUIVI?code=ABCD1234"])(
    "retient %s SANS le code d'alliance",
    (url) => {
      window.history.replaceState({}, "", url);
      expect(rememberCurrentPage()).toBe(true);
      const kept = peekReturnTo();
      expect(kept).not.toBeNull();
      expect(kept).not.toContain("code");
      expect(window.localStorage.getItem("na9ra.returnTo.v1")).not.toContain("ABCD1234");
    },
  );

  it("garde la requête des autres pages : seule celle du suivi est sensible", () => {
    window.history.replaceState({}, "", "/chapitre/c1?variant=recall");
    expect(rememberCurrentPage()).toBe(true);
    expect(peekReturnTo()).toBe("/chapitre/c1?variant=recall");
  });
});

describe("la raison du retour (é38 lot 3, R-7)", () => {
  const T0 = Date.parse("2026-10-30T12:00:00.000Z");
  const KEY = "na9ra.returnTo.v1";

  beforeEach(() => window.localStorage.clear());
  afterEach(() => window.history.replaceState({}, "", "/"));

  it("un retour ordinaire n'a pas de raison", () => {
    rememberReturnTo("/chapitre/c1", T0);
    expect(peekReturnReason(T0)).toBeNull();
  });

  it("un retour d'expiration garde la sienne, et le chemin reste lisible", () => {
    expect(rememberReturnTo("/quest/ex-1", T0, "expired")).toBe(true);
    expect(peekReturnReason(T0)).toBe("expired");
    expect(peekReturnTo(T0)).toBe("/quest/ex-1");
  });

  it("un retour écrit SANS raison remplace un retour d'expiration : la dernière intention compte", () => {
    rememberReturnTo("/quest/ex-1", T0, "expired");
    rememberReturnTo("/chapitre/c1", T0 + 1000);
    expect(peekReturnTo(T0 + 1000)).toBe("/chapitre/c1");
    expect(peekReturnReason(T0 + 1000)).toBeNull();
  });

  it("la raison est consommée avec le retour : il ne sert qu'une fois", () => {
    rememberReturnTo("/quest/ex-1", T0, "expired");
    expect(consumeReturnTo(T0)).toBe("/quest/ex-1");
    expect(peekReturnReason(T0)).toBeNull();
  });

  it("la raison périme avec le retour (24 h)", () => {
    rememberReturnTo("/quest/ex-1", T0, "expired");
    expect(peekReturnReason(T0 + RETURN_TO_TTL_MS + 1)).toBeNull();
  });

  it.each([
    ["une raison inconnue", "hacked"],
    ["une raison qui n'est pas une chaîne", 42],
    ["une raison objet", { x: 1 }],
  ])(
    "%s, écrite par une autre page, est ignorée — le chemin, lui, reste valable",
    (_label, reason) => {
      window.localStorage.setItem(KEY, JSON.stringify({ path: "/quest/ex-1", at: T0, reason }));
      expect(peekReturnReason(T0)).toBeNull();
      expect(peekReturnTo(T0)).toBe("/quest/ex-1");
    },
  );

  it("une raison ne sauve pas un chemin dangereux", () => {
    window.localStorage.setItem(
      KEY,
      JSON.stringify({ path: "//evil.tn", at: T0, reason: "expired" }),
    );
    expect(peekReturnReason(T0)).toBeNull();
    expect(peekReturnTo(T0)).toBeNull();
  });

  it('rememberCurrentPage("expired") retient la page courante AVEC la raison', () => {
    window.history.replaceState({}, "", "/quest/ex-1?variant=recall");
    expect(rememberCurrentPage("expired")).toBe(true);
    expect(peekReturnTo()).toBe("/quest/ex-1?variant=recall");
    expect(peekReturnReason()).toBe("expired");
  });

  it('rememberCurrentPage("expired") retient /suivi sans le code d\'alliance, raison comprise', () => {
    window.history.replaceState({}, "", "/suivi?code=ABCD1234");
    expect(rememberCurrentPage("expired")).toBe(true);
    expect(window.localStorage.getItem(KEY)).not.toContain("ABCD1234");
    expect(peekReturnReason()).toBe("expired");
  });
});
