// @vitest-environment node
import { afterEach, describe, expect, it, vi } from "vitest";
import {
  META_DESCRIPTION_MAX,
  SITE_TITLE_SUFFIX,
  plainExcerpt,
  publicPageHead,
  seedOnServer,
  serializeJsonLd,
} from "@/shared/lib/public-page-seo";
import { logger } from "@/shared/lib/logger";

vi.mock("@/shared/lib/logger", () => ({
  logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));

afterEach(() => {
  vi.unstubAllEnvs();
  vi.clearAllMocks();
});

describe("seedOnServer", () => {
  it("loads the page data during the server render", async () => {
    vi.stubEnv("SSR", true);
    await expect(seedOnServer("chapitre", async () => ({ ok: 1 }))).resolves.toEqual({ ok: 1 });
  });

  // En navigation client la route garde son chargement d'avant : aucun appel
  // de plus, la requête du composant suffit.
  it("never calls the loader in the browser", async () => {
    vi.stubEnv("SSR", false);
    const load = vi.fn(async () => ({ ok: 1 }));
    await expect(seedOnServer("chapitre", load)).resolves.toBeNull();
    expect(load).not.toHaveBeenCalled();
  });

  // Un préchargement raté ne casse jamais le rendu : la page retombe sur le
  // chargement client, et la panne laisse une trace.
  it("swallows a failing load, logs it and returns null", async () => {
    vi.stubEnv("SSR", true);
    const result = await seedOnServer("matiere", async () => {
      throw new Error("db down");
    });
    expect(result).toBeNull();
    expect(logger.warn).toHaveBeenCalledWith(
      expect.stringContaining("SSR seed failed"),
      expect.objectContaining({ label: "matiere" }),
    );
  });
});

describe("plainExcerpt", () => {
  it("strips markdown, HTML and directives down to one line of text", () => {
    const md = [
      "# ⚔️ Le titre",
      "",
      ":::definition",
      "Un **nombre** _réel_ est un [nombre](/x) de la <abbr>droite</abbr>.",
      ":::",
      "- premier point",
      "> une citation",
    ].join("\n");
    expect(plainExcerpt(md)).toBe(
      "⚔️ Le titre Un nombre réel est un nombre de la droite . premier point une citation",
    );
  });

  it("returns an empty string for missing content", () => {
    expect(plainExcerpt(null)).toBe("");
    expect(plainExcerpt(undefined)).toBe("");
    expect(plainExcerpt("   ")).toBe("");
  });

  it("cuts long text at a word boundary with an ellipsis, within the limit", () => {
    const long = "mot ".repeat(100);
    const out = plainExcerpt(long);
    expect(out.length).toBeLessThanOrEqual(META_DESCRIPTION_MAX);
    expect(out.endsWith("mot…")).toBe(true);
  });

  it("keeps Arabic text intact", () => {
    expect(plainExcerpt("التوكيد **تابعٌ** يُذكر")).toBe("التوكيد تابعٌ يُذكر");
  });
});

describe("publicPageHead", () => {
  it("names the page in the title and the social card, with the site suffix", () => {
    const { meta } = publicPageHead({ title: "Les fractions — Maths 6ᵉ", path: "/chapitre/x" });
    const title = `Les fractions — Maths 6ᵉ${SITE_TITLE_SUFFIX}`;
    expect(meta).toContainEqual({ title });
    expect(meta).toContainEqual({ property: "og:title", content: title });
    expect(meta).toContainEqual({ property: "og:type", content: "website" });
    expect(meta).toContainEqual({
      property: "og:url",
      content: "https://www.na9ranal3ab.tn/chapitre/x",
    });
  });

  it("emits a description only when there is one — the root default stays otherwise", () => {
    const without = publicPageHead({ title: "T", path: "/", description: "" });
    expect(without.meta.some((m) => "name" in m && m.name === "description")).toBe(false);

    const withDesc = publicPageHead({ title: "T", path: "/", description: "**Une** phrase." });
    expect(withDesc.meta).toContainEqual({ name: "description", content: "Une phrase." });
    expect(withDesc.meta).toContainEqual({ property: "og:description", content: "Une phrase." });
  });

  it("serves structured data as a JSON-LD script", () => {
    const head = publicPageHead({
      title: "T",
      path: "/chapitre/x",
      type: "article",
      jsonLd: { "@type": "LearningResource", name: "T" },
    });
    expect(head.meta).toContainEqual({ property: "og:type", content: "article" });
    expect(head.scripts).toEqual([
      { type: "application/ld+json", children: '{"@type":"LearningResource","name":"T"}' },
    ]);
  });
});

describe("serializeJsonLd", () => {
  // Un titre de contenu ne doit jamais pouvoir fermer la balise <script>.
  it("escapes `<` so content cannot break out of the script tag", () => {
    const out = serializeJsonLd({ name: "</script><script>alert(1)</script>" });
    expect(out).not.toContain("<");
    expect(JSON.parse(out)).toEqual({ name: "</script><script>alert(1)</script>" });
  });
});
