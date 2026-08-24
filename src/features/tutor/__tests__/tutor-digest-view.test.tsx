import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { TutorDigestView } from "../digest.server";

/**
 * Étude 11 lot 6 — CE QUE LES DEUX ÉCRANS DU BILAN DOIVENT GARANTIR.
 *
 * Le module pur et la couche serveur ont leurs 59 tests dans
 * `tutor-digest.test.ts`. Ceux-ci gardent les trois choses qu'ils ne peuvent pas
 * voir, parce qu'elles n'existent qu'au rendu :
 *
 *   1. R-15 — les QUATRE états rendent quatre phrases, et aucun ne lève. Un
 *      bilan absent, un lien coupé et une panne ne se disent pas de la même
 *      façon : « attends dimanche », « ressaisis le code » et « ce n'est pas
 *      toi » appellent trois gestes différents du lecteur.
 *   2. R-3 — le CORPS porte sa propre langue. Il est rédigé dans celle de la
 *      matière dominante de la semaine, pas dans celle de l'interface : un
 *      parent francophone peut recevoir un bilan en arabe. Sans `lang` et
 *      `dir="auto"` sur ce seul nœud, le texte se rend à l'envers.
 *   3. LA DATE EST LOCALE. `weekStart` est une date nue ; la lire avec
 *      `new Date("2026-08-17")` donnerait minuit UTC, et tout fuseau à l'ouest
 *      de Greenwich daterait le bilan de la veille. Le test le fige.
 *
 * Le composant est rendu avec les traductions PAR DÉFAUT du contexte (français,
 * `DEFAULT_LOCALE`) : c'est ce que fait déjà `tutor-panel.test.tsx`, et cela
 * garde le test lisible sans monter un provider i18n.
 */

const { fetchDigest } = vi.hoisted(() => ({ fetchDigest: vi.fn() }));

// ⚠️ `vi.hoisted` et non un `const` déclaré plus haut : une fabrique de mock qui
// lit une liaison non hissée FIGE le worker soixante secondes au lieu de lever,
// et le rouge qu'on lit alors ne ressemble en rien à la cause.
vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("../digest.server", () => ({
  getWeeklyDigest: (args: unknown) => fetchDigest(args),
}));

const { TutorDigestCard, TutorParentDigest } = await import("../components/tutor-digest");

function mount(node: React.ReactElement) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(React.createElement(QueryClientProvider, { client }, node));
}

const STUDENT = "44444444-4444-4444-8444-444444444444";

beforeEach(() => {
  fetchDigest.mockReset();
});

describe("TutorDigestCard — le bilan de l'élève", () => {
  it("rend le corps, la semaine EN DATE LOCALE et la signature", async () => {
    const view: TutorDigestView = {
      kind: "digest",
      audience: "student",
      weekStart: "2026-08-17",
      lang: "fr",
      body: "Tu as joué trois missions cette semaine.\nUne de plus que la précédente.",
    };
    fetchDigest.mockResolvedValue(view);

    mount(React.createElement(TutorDigestCard));

    const body = await screen.findByTestId("tutor-digest-body");
    expect(body.textContent).toContain("trois missions");
    // ⚠️ CE QUE CETTE ASSERTION PROUVE, ET CE QU'ELLE NE PROUVE PAS.
    // Elle prouve que la semaine est datée du 17 dans le fuseau du runner. Elle
    // ne peut PAS attraper le décalage UTC que le parsing manuel de `weekLabel`
    // évite : la CI tourne en UTC, où `new Date("2026-08-17")` et
    // `new Date(2026, 7, 17)` tombent le même jour. Le fuseau négatif d'un
    // utilisateur n'est reproductible ici qu'en pilotant `TZ` au niveau du
    // process, ce que le runner ne permet pas par fichier. La garde vit donc
    // dans le CODE (trois nombres, jamais une chaîne ISO) et dans son
    // commentaire ; ce test tient la ligne visible, pas l'invariant de fuseau.
    expect(screen.getByText(/17/)).toBeTruthy();
    expect(screen.getByText(/El Ostedh/)).toBeTruthy();
  });

  it("porte la langue du CORPS, qui n'est pas celle de l'interface (R-3)", async () => {
    fetchDigest.mockResolvedValue({
      kind: "digest",
      audience: "student",
      weekStart: "2026-08-17",
      lang: "ar",
      body: "لعبت ثلاث مهمّات هذا الأسبوع.",
    } satisfies TutorDigestView);

    mount(React.createElement(TutorDigestCard));

    const body = await screen.findByTestId("tutor-digest-body");
    expect(body.getAttribute("lang")).toBe("ar");
    // `dir="auto"` et non `rtl` en dur : c'est le premier caractère fort qui
    // tranche, et il tranche juste pour les trois langues.
    expect(body.getAttribute("dir")).toBe("auto");
  });

  it("dit « ça arrive dimanche » sans carte quand il n'y a rien", async () => {
    fetchDigest.mockResolvedValue({ kind: "none", reason: "not-yet" } satisfies TutorDigestView);

    mount(React.createElement(TutorDigestCard));

    await screen.findByTestId("tutor-digest-empty");
    expect(screen.getByText(/arrive dimanche/)).toBeTruthy();
    // Une ligne, pas une carte : six jours sur sept c'est l'état NOMINAL, et un
    // encadré vide sur le tableau de bord se lit comme une panne.
    expect(screen.queryByTestId("tutor-digest")).toBeNull();
  });

  it("distingue la PANNE de l'absence — et rassure sur ce qui compte (R-15)", async () => {
    fetchDigest.mockResolvedValue({
      kind: "none",
      reason: "unavailable",
    } satisfies TutorDigestView);

    mount(React.createElement(TutorDigestCard));

    const line = await screen.findByTestId("tutor-digest-empty");
    // Un enfant ne doit pas croire que sa semaine a été perdue avec le texte.
    expect(line.textContent).toMatch(/progrès/);
    expect(line.textContent).not.toMatch(/dimanche/);
  });
});

describe("TutorParentDigest — le bilan du parent", () => {
  it("demande l'audience PARENT pour l'élève désigné (Q-5)", async () => {
    fetchDigest.mockResolvedValue({ kind: "none", reason: "not-yet" } satisfies TutorDigestView);

    mount(React.createElement(TutorParentDigest, { studentId: STUDENT }));

    // Le parent ne lit jamais le texte écrit pour l'enfant : deux `audience`
    // distinctes en base, et l'écran doit demander la sienne. Un appel sans
    // `audience` rendrait le bilan de l'élève CONNECTÉ — c'est-à-dire le parent.
    await waitFor(() =>
      expect(fetchDigest).toHaveBeenCalledWith({
        data: { audience: "parent", studentId: STUDENT },
      }),
    );
  });

  it("dit « lien à rétablir » et non « attendez dimanche » sur un lien coupé", async () => {
    fetchDigest.mockResolvedValue({
      kind: "none",
      reason: "not-linked",
    } satisfies TutorDigestView);

    mount(React.createElement(TutorParentDigest, { studentId: STUDENT }));

    const line = await screen.findByTestId("report-tutor-digest-empty");
    // Les deux états demandent des gestes OPPOSÉS. Les confondre ferait attendre
    // indéfiniment un parent qui n'avait qu'un code à ressaisir.
    expect(line.textContent).toMatch(/lien/i);
    expect(line.textContent).not.toMatch(/dimanche/);
  });

  it("garde son encadré même sans bilan — un parent est venu chercher", async () => {
    fetchDigest.mockResolvedValue({ kind: "none", reason: "not-yet" } satisfies TutorDigestView);

    mount(React.createElement(TutorParentDigest, { studentId: STUDENT }));

    // À l'inverse de l'écran élève : un blanc dans un rapport ouvert
    // délibérément se lit comme « il n'y avait rien à dire de votre enfant ».
    await screen.findByTestId("report-tutor-digest");
    expect(screen.getByText(/dimanche soir/)).toBeTruthy();
  });
});
