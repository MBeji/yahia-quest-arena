import { render } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

// Même stub de routeur que les specs voisines : le header et le pied de page
// n'ont besoin que d'un <Link> qui rend une ancre.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));
vi.mock("@/features/auth", () => ({
  useAuth: () => ({ user: null, session: null, loading: false }),
}));

import { I18nProvider } from "@/lib/i18n";
import { PublicHeader } from "../public-header";
import { PublicFooter } from "../public-footer";

/** La signature de marque. La sous-police ne porte QUE ces 7 lettres (et
 *  l'espace) : changer le mot impose de la regénérer (voir `styles.css`). */
const BRAND_AR = "نقرا نلعب";
const BRAND_LETTERS = /^[ابرعقلن]$/;

const CSS = readFileSync(resolve(process.cwd(), "src/styles.css"), "utf8");

/**
 * Perf bundle-03 (2026-10-31) : « نقرا نلعب » rendue en `font-arabic` faisait
 * télécharger la face Noto Kufi complète (123 688 o, incompressible) sur chaque
 * page publique — le span du pied de page n'a pas de `hidden`, donc sur mobile
 * aussi. La signature porte désormais une famille dédiée de 6 792 o.
 */
describe("signature de marque « نقرا نلعب » (perf bundle-03)", () => {
  it.each([
    ["header", PublicHeader],
    ["pied de page", PublicFooter],
  ])("%s : la signature arabe porte la sous-police de marque, jamais la face complète", (_, C) => {
    const { container } = render(
      <I18nProvider>
        <C />
      </I18nProvider>,
    );
    const spans = [...container.querySelectorAll('span[lang="ar"]')].filter((s) =>
      s.textContent?.includes(BRAND_AR),
    );
    expect(spans).toHaveLength(1);
    expect(spans[0]).toHaveClass("font-brand-ar");
    expect(spans[0]).not.toHaveClass("font-arabic");
    expect(spans[0].textContent?.trim()).toBe(BRAND_AR);
  });

  it("styles.css mappe le token de marque sur une face dédiée, servie par son propre fichier", () => {
    expect(CSS).toMatch(/--font-brand-ar:\s*"Noto Kufi Arabic Brand"/);
    const face = CSS.match(
      /font-family:\s*"Noto Kufi Arabic Brand";[\s\S]*?src:\s*url\("([^"]+)"\)/,
    );
    expect(face?.[1]).toBe("/fonts/noto-kufi-arabic-brand-var.woff2");
  });

  it("la plage déclarée de la face de marque couvre exactement les lettres de la signature", () => {
    const face = CSS.match(
      /font-family:\s*"Noto Kufi Arabic Brand";[\s\S]*?unicode-range:\s*([^;]+);/,
    );
    const covered = new Set<number>();
    for (const token of (face?.[1] ?? "").split(",")) {
      const [lo, hi] = token
        .trim()
        .replace(/^U\+/, "")
        .split("-")
        .map((h) => parseInt(h, 16));
      for (let cp = lo; cp <= (hi ?? lo); cp += 1) covered.add(cp);
    }
    for (const ch of BRAND_AR) {
      expect(ch === " " || BRAND_LETTERS.test(ch)).toBe(true);
      expect(covered.has(ch.codePointAt(0) ?? -1), `U+${ch.codePointAt(0)?.toString(16)}`).toBe(
        true,
      );
    }
  });
});
