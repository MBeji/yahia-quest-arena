// @vitest-environment node
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { SITE_URL, SOCIAL_IMAGE } from "@/shared/constants/site";

describe("SOCIAL_IMAGE", () => {
  // Une plateforme de partage ne lit qu'une URL ABSOLUE, sur l'hôte canonique.
  it("is an absolute URL on the canonical host", () => {
    expect(SOCIAL_IMAGE.url).toBe(`${SITE_URL}/og-image.png`);
    expect(SOCIAL_IMAGE.publicPath).toBe(`public${new URL(SOCIAL_IMAGE.url).pathname}`);
  });

  // Le fichier servi doit exister et avoir les dimensions déclarées dans le <head> :
  // une image absente ou mal mesurée, c'est un lien partagé sans visuel.
  it("points at a real PNG of the declared size", () => {
    const png = readFileSync(resolve(process.cwd(), SOCIAL_IMAGE.publicPath));
    expect(png.subarray(1, 4).toString("ascii")).toBe("PNG");
    // IHDR : largeur puis hauteur, entiers 32 bits gros-boutistes aux octets 16 et 20.
    expect(png.readUInt32BE(16)).toBe(SOCIAL_IMAGE.width);
    expect(png.readUInt32BE(20)).toBe(SOCIAL_IMAGE.height);
    // Sous la limite des aperçus WhatsApp (~300 Ko), avec de la marge.
    expect(png.byteLength).toBeLessThan(200_000);
  });
});
