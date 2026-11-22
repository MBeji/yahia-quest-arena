// @vitest-environment node
import { readdirSync, statSync } from "node:fs";
import { join, resolve } from "node:path";
import { describe, expect, it } from "vitest";
import {
  ECRANS,
  guideScreenForPath,
  isAiSilentPath,
  isContentPath,
  isFunnelPath,
  isImmersivePath,
  isStudentOnlyPath,
} from "../screens";

const ROUTES = resolve(__dirname, "../../../routes");

/** Les premiers segments d'adresse que le routeur sert, tirés des noms de fichiers. */
function segmentsDuRouteur(): Set<string> {
  const segments = new Set<string>();
  const parcourir = (dossier: string) => {
    for (const nom of readdirSync(dossier)) {
      const chemin = join(dossier, nom);
      if (statSync(chemin).isDirectory()) {
        if (nom !== "__tests__") parcourir(chemin);
        continue;
      }
      if (!nom.endsWith(".tsx") || nom.startsWith("-") || nom === "__root.tsx") continue;
      // Les coquilles (`_public.tsx`, `_authenticated.tsx`) ne sont pas des adresses.
      if (dossier === ROUTES && nom.startsWith("_")) continue;
      const base = nom.replace(/\.tsx$/, "");
      segments.add(base === "index" ? "" : base.split(".")[0].replace(/_$/, ""));
    }
  };
  parcourir(ROUTES);
  return segments;
}

describe("registre des écrans — une entrée par page servie, ni plus ni moins", () => {
  // Le même piège que la Console (deux consoles livrées sans leur entrée) : une page sans
  // entrée ici n'aurait ni sa fiche d'aide, ni ses règles de barre d'onglets ou de bulle.
  it("chaque page du routeur a son entrée", () => {
    const manquantes = [...segmentsDuRouteur()].filter((s) => !(s in ECRANS));
    expect(manquantes).toEqual([]);
  });

  it("aucune entrée ne décrit une page qui n'existe plus", () => {
    const routeur = segmentsDuRouteur();
    expect(Object.keys(ECRANS).filter((s) => !routeur.has(s))).toEqual([]);
  });
});

describe("écrans immersifs — là où la barre d'onglets se retire", () => {
  it.each([
    "/quest/abc",
    "/onboarding",
    "/examen/blanc-1",
    "/lesson/ch-1",
    "/exercice/abc",
    "/test-de-niveau/session-1",
  ])("%s est immersif", (path) => {
    expect(isImmersivePath(path)).toBe(true);
  });

  // `/examens` est la LISTE des examens ; l'ENTRÉE du test de niveau n'est pas la passation ;
  // le hall du donjon et un duel gardent leurs onglets (étude 15, D-4).
  it.each([
    "/",
    "/dashboard",
    "/examens",
    "/dungeon",
    "/duel",
    "/duel/d1",
    "/arene",
    "/parcours",
    "/programme",
    "/programme/lycee/bac",
    "/niveau/ecole-7eme-base",
    "/matiere/math-7eme",
    "/chapitre/c1",
    "/extras",
    "/test-de-niveau",
    "/test-de-niveau?matiere=math",
    "/questionnaire",
  ])("%s garde sa navigation", (path) => {
    expect(isImmersivePath(path)).toBe(false);
  });
});

describe("la bulle IA se tait sur les épreuves notées et les tunnels", () => {
  it.each(["/quest/e1", "/dungeon", "/duel/d1", "/examen/x", "/onboarding"])("%s", (path) => {
    expect(isAiSilentPath(path)).toBe(true);
  });

  // `/examens` est une liste, pas une épreuve : l'ancienne expression la faisait taire.
  it.each(["/examens", "/dashboard", "/chapitre/c1", "/arene"])("parle sur %s", (path) => {
    expect(isAiSilentPath(path)).toBe(false);
  });
});

describe("pages de contenu et tunnel de connexion", () => {
  it.each([
    "/chapitre/c1",
    "/matiere/m1",
    "/exercice/e1",
    "/niveau/p1",
    "/programme",
    "/extras?x=1",
  ])("%s est du contenu", (path) => {
    expect(isContentPath(path)).toBe(true);
  });

  it.each(["/", "/niveau", "/dashboard", "/programmes", "/suivi"])("%s n'en est pas", (path) => {
    expect(isContentPath(path)).toBe(false);
  });

  // Le routeur apparie `/AUTH` comme `/auth` : les deux anciennes définitions divergeaient là.
  it.each(["/auth", "/auth?mode=signup", "/AUTH", "/Login", "/signup/", "/auth/reset"])(
    "%s est le tunnel",
    (path) => {
      expect(isFunnelPath(path)).toBe(true);
    },
  );

  it.each(["/authors", "/", "/chapitre/c1"])("%s n'est pas le tunnel", (path) => {
    expect(isFunnelPath(path)).toBe(false);
  });
});

describe("la fiche d'aide d'un écran", () => {
  it.each([
    ["/matiere", "general"],
    ["/chapitre", "general"],
    ["/quest", "general"],
    ["/Dashboard", "dashboard"],
  ])("%s → %s", (path, screen) => {
    expect(guideScreenForPath(path)).toBe(screen);
  });
});

describe("les écrans d'élève — un parent en est renvoyé à son Suivi", () => {
  it.each(["/dashboard", "/arene", "/quest/e1", "/examen/x", "/boutique", "/onboarding"])(
    "%s est un écran d'élève",
    (path) => {
      expect(isStudentOnlyPath(path)).toBe(true);
    },
  );

  it.each(["/parent-report", "/parametrage", "/programme", "/chapitre/c1", "/suivi", "/console"])(
    "%s ne l'est pas",
    (path) => {
      expect(isStudentOnlyPath(path)).toBe(false);
    },
  );
});
