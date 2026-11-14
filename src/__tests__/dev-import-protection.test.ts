// @vitest-environment node
import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const CONFIG = readFileSync(resolve(import.meta.dirname, "../../vite.config.ts"), "utf-8");

/**
 * `npm run dev` est resté cassé du 2026-11-13 (#1322) au 2026-11-14 sans que rien ne
 * rougisse : aucun gate ne lance le serveur de dev. Le client ne s'hydratait plus — la page
 * s'affichait (rendu serveur) mais plus un bouton ne répondait. Cause : la protection des
 * imports était en "error" des deux côtés, et le serveur de dev, qui n'élimine aucun code
 * mort, voyait l'import à la demande de `@tanstack/react-start/server` (branche SSR de
 * `seedOnServer`) depuis le graphe client.
 */
describe("Protection des imports — le build refuse, le dev simule", () => {
  it("garde le BUILD en refus : c'est le gate de la CI et du déploiement", () => {
    expect(CONFIG).toMatch(/behavior:\s*\{[^}]*build:\s*"error"/);
  });

  it("laisse le serveur de dev simuler un import refusé au lieu de ne plus servir l'entrée", () => {
    expect(CONFIG).toMatch(/behavior:\s*\{[^}]*dev:\s*"mock"/);
    expect(CONFIG).not.toMatch(/behavior:\s*"error"/);
  });
});
