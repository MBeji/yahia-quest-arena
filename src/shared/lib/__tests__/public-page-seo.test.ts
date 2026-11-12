// @vitest-environment node
import { afterEach, describe, expect, it, vi } from "vitest";
import { notFound } from "@tanstack/react-router";
import {
  META_DESCRIPTION_MAX,
  breadcrumbJsonLd,
  itemListJsonLd,
  isUuid,
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

describe("seedOnServer — « introuvable » n'est pas une panne", () => {
  // Le faux 404 du 2026-11-12 : avalé comme une panne, un `notFound()` laissait
  // `/chapitre/<id inconnu>` répondre HTTP 200. Il doit atteindre le routeur.
  it("lets a notFound() through, without logging a failure", async () => {
    vi.stubEnv("SSR", true);
    const missing = notFound();
    await expect(
      seedOnServer("chapitre", async () => {
        throw missing;
      }),
    ).rejects.toBe(missing);
    expect(logger.warn).not.toHaveBeenCalled();
  });
});

describe("isUuid", () => {
  it("accepts a uuid, whatever its case", () => {
    expect(isUuid("6e7219be-5c5a-586e-bedd-318a6262ec8f")).toBe(true);
    expect(isUuid("6E7219BE-5C5A-586E-BEDD-318A6262EC8F")).toBe(true);
    expect(isUuid("00000000-0000-0000-0000-000000000000")).toBe(true);
  });

  it("refuses anything that cannot name a chapter or an exercise", () => {
    expect(isUuid("pas-un-uuid")).toBe(false);
    expect(isUuid("")).toBe(false);
    expect(isUuid("6e7219be-5c5a-586e-bedd-318a6262ec8f/x")).toBe(false);
    expect(isUuid("------------------------------------")).toBe(false);
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

describe("breadcrumbJsonLd", () => {
  // Niveau › matière › cours : positions à partir de 1, adresses absolues sur
  // l'origine canonique — ce que Google affiche à la place de l'URL brute.
  it("numbers the trail from the widest page to the page itself", () => {
    expect(
      breadcrumbJsonLd([
        { name: "6ème année", path: "/niveau/ecole-6eme-base" },
        { name: "Mathématiques", path: "/matiere/math-6eme" },
        { name: "Les fractions", path: "/chapitre/abc" },
      ]),
    ).toEqual({
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      itemListElement: [
        {
          "@type": "ListItem",
          position: 1,
          name: "6ème année",
          item: "https://www.na9ranal3ab.tn/niveau/ecole-6eme-base",
        },
        {
          "@type": "ListItem",
          position: 2,
          name: "Mathématiques",
          item: "https://www.na9ranal3ab.tn/matiere/math-6eme",
        },
        {
          "@type": "ListItem",
          position: 3,
          name: "Les fractions",
          item: "https://www.na9ranal3ab.tn/chapitre/abc",
        },
      ],
    });
  });
});

describe("itemListJsonLd", () => {
  it("lists the pages in order, with their count", () => {
    expect(
      itemListJsonLd("Mathématiques — 6ème année", [
        { name: "Les fractions", path: "/chapitre/a" },
        { name: "Les décimaux", path: "/chapitre/b" },
      ]),
    ).toEqual({
      "@context": "https://schema.org",
      "@type": "ItemList",
      name: "Mathématiques — 6ème année",
      numberOfItems: 2,
      itemListElement: [
        {
          "@type": "ListItem",
          position: 1,
          name: "Les fractions",
          url: "https://www.na9ranal3ab.tn/chapitre/a",
        },
        {
          "@type": "ListItem",
          position: 2,
          name: "Les décimaux",
          url: "https://www.na9ranal3ab.tn/chapitre/b",
        },
      ],
    });
  });
});

describe("publicPageHead — langue du contenu et données structurées multiples", () => {
  // Un cours d'arabe partagé est un contenu ARABE, quelle que soit la langue
  // d'interface du visiteur.
  it("declares og:locale from the content language", () => {
    const locale = (lang: string | null | undefined) =>
      publicPageHead({ title: "T", path: "/x", contentLanguage: lang }).meta.find(
        (tag) => "property" in tag && tag.property === "og:locale",
      );
    expect(locale("ar")).toEqual({ property: "og:locale", content: "ar_AR" });
    expect(locale("fr")).toEqual({ property: "og:locale", content: "fr_FR" });
    expect(locale("en")).toEqual({ property: "og:locale", content: "en_US" });
  });

  it("declares no og:locale rather than a wrong one", () => {
    for (const lang of [undefined, null, "", "tzm"]) {
      const head = publicPageHead({ title: "T", path: "/x", contentLanguage: lang });
      expect(head.meta.some((tag) => "property" in tag && tag.property === "og:locale")).toBe(
        false,
      );
    }
  });

  it("emits one ld+json script per structured-data object, each one escaped", () => {
    const head = publicPageHead({
      title: "T",
      path: "/x",
      jsonLd: [{ "@type": "LearningResource", name: "</script>" }, { "@type": "BreadcrumbList" }],
    });
    expect(head.scripts).toHaveLength(2);
    expect(head.scripts?.every((script) => script.type === "application/ld+json")).toBe(true);
    expect(head.scripts?.[0]?.children).not.toContain("</script>");
    expect(JSON.parse(head.scripts?.[1]?.children ?? "{}")).toEqual({ "@type": "BreadcrumbList" });
  });
});
