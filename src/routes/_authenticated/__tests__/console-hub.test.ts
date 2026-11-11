// @vitest-environment node
import { describe, expect, it } from "vitest";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

/**
 * ⭐ TOUTE CONSOLE D'ADMIN EST ATTEIGNABLE DEPUIS LE PÔLE.
 *
 * Cette garde existe parce que la même panne s'est produite DEUX fois :
 *
 *   · `/admin/economie` ne s'atteignait qu'en tapant son URL — le pôle
 *     (`console.tsx`) l'a récupérée en le disant dans son propre en-tête ;
 *   · `/admin/engagement` (é31 lot 1) a été livrée le 2026-09-02 avec le même
 *     trou, six jours plus tard, et signalée depuis la PRODUCTION le 2026-09-03 :
 *     « je ne peux pas atteindre la page depuis la navigation et le menu,
 *     uniquement en copiant le lien ».
 *
 * Une console qu'on n'atteint pas ne mesure rien. C'est le constat même de
 * l'étude 31 — neuf badges décernables que rien ne décernait — rejoué sur l'outil
 * censé la mesurer. Un commentaire disant « ne recommence pas » n'a pas suffi ;
 * une assertion, si.
 *
 * Elle compare le ROUTEUR au pôle, dans les deux sens : ni console orpheline, ni
 * entrée qui pointe vers une route disparue.
 */
const ROUTES_DIR = join(process.cwd(), "src/routes/_authenticated");
const hub = readFileSync(join(ROUTES_DIR, "console.tsx"), "utf8");

/** `admin.engagement.tsx` → `/admin/engagement` (le routeur à plat de TanStack). */
function routePathOf(file: string): string {
  return (
    "/" +
    file
      .replace(/\.tsx$/, "")
      .split(".")
      .join("/")
  );
}

const adminRoutes = readdirSync(ROUTES_DIR)
  .filter((f) => f.startsWith("admin.") && f.endsWith(".tsx"))
  .map(routePathOf);

describe("le pôle d'administration (console.tsx)", () => {
  it("ne peut pas passer à vide — le routeur porte bien des consoles d'admin", () => {
    // Sans ça, un jour où le nommage des fichiers changerait, ce fichier
    // deviendrait vert en ne vérifiant plus rien.
    expect(adminRoutes.length).toBeGreaterThanOrEqual(8);
  });

  it("⭐ lie CHAQUE route `/admin/*` — aucune console n'est atteignable par sa seule URL", () => {
    for (const path of adminRoutes) {
      expect(
        hub.includes(`"${path}" as const`),
        `${path} existe dans le routeur mais n'a pas d'entrée dans le pôle : ` +
          `elle ne s'atteint qu'en collant son URL`,
      ).toBe(true);
    }
  });

  it("⭐ et ne lie AUCUNE route qui n'existe plus — l'inverse casse en 404", () => {
    const liees = [...hub.matchAll(/"(\/admin\/[a-z-]+)" as const/g)].map((m) => m[1]);
    expect(liees.length).toBeGreaterThanOrEqual(8);
    for (const path of liees) {
      expect(
        adminRoutes.includes(path),
        `le pôle pointe vers ${path}, qui n'existe pas dans le routeur`,
      ).toBe(true);
    }
  });
});
