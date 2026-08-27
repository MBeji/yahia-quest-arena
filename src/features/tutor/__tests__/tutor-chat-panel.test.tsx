import { render, screen, waitFor } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { TutorChatEntry } from "../tutor.server";

/**
 * « JE CLIQUE SUR DISCUTER AVEC LE PROF, RIEN NE SE PASSE, JE REVIENS AU COURS »
 * — signalé le 2026-08-27, capture à l'appui, la bulle IA ouverte au-dessus d'un
 * chapitre d'arabe. Trois défauts distincts se cachaient derrière cette phrase,
 * et ce fichier les tient tous les trois :
 *
 *   1. l'INTENTION n'arrivait qu'au montage. Depuis un chapitre, « Y aller » ne
 *      change que la recherche de l'URL — même route, même composant, aucun
 *      remontage : `useState(defaultOpen)` ne relisait jamais rien ;
 *   2. le panneau est monté APRÈS la leçon entière. Ouvert sans être rejoint, il
 *      est invisible — d'où « je reviens au cours », qui était littéralement
 *      vrai : l'élève regardait son cours, le chat trois écrans plus bas ;
 *   3. une porte fermée se retirait SANS UN MOT. `can_use_tutor` referme la
 *      portée chapitre dès qu'une séance d'exercice y est restée ouverte, et le
 *      clic sur « Discuter avec le Prof » ne produisait alors rigoureusement
 *      rien à l'écran — l'apparence exacte d'une panne.
 */

let entry: TutorChatEntry | undefined = {
  allowed: true,
  reason: "OK",
  freeText: true,
  lang: "fr",
};

vi.mock("@tanstack/react-query", () => ({
  useQuery: () => ({ data: entry }),
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));

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

// Le jeton du flux : l'attacheur réel monte tout le socle Supabase, dont ce
// fichier n'a que faire — aucun de ces tests n'envoie de message.
vi.mock("@/shared/integrations/supabase/auth-attacher", () => ({
  resolveAccessToken: vi.fn(async () => "jeton-de-test"),
}));

// La jauge d'énergie a sa propre requête et son propre écran : hors sujet ici.
vi.mock("../components/tutor-energy", () => ({ TutorEnergyMeter: () => null }));

import { TutorChatPanel } from "../components/tutor-chat-panel";

const CHAPTER = "44444444-4444-4444-8444-444444444444";

/** jsdom n'implémente pas `scrollIntoView` : on le pose, et on l'observe. */
const scrollIntoView = vi.fn();

beforeEach(async () => {
  Element.prototype.scrollIntoView = scrollIntoView;
  // Le panneau défile à la frame SUIVANTE (le routeur remet la page en haut, il
  // doit passer après lui) : on vide donc les frames laissées par le test
  // précédent avant de remettre le compteur à zéro, sinon leur appel — sans
  // effet sur un nœud détaché, mais compté — atterrirait dans le test suivant.
  await new Promise((resolve) => requestAnimationFrame(resolve));
  entry = { allowed: true, reason: "OK", freeText: true, lang: "fr" };
  scrollIntoView.mockClear();
});

describe("TutorChatPanel — l'intention « ouvre le chat »", () => {
  it("s'ouvre quand l'intention ARRIVE, panneau déjà monté", async () => {
    const view = render(<TutorChatPanel chapterId={CHAPTER} />);
    // Replié : c'est l'état de l'élève qui lisait son cours.
    expect(screen.getByTestId("tutor-chat-open")).toBeInTheDocument();
    expect(screen.queryByTestId("tutor-chat")).not.toBeInTheDocument();

    // La bulle change la recherche de l'URL — et rien d'autre : même route, même
    // composant. C'est LE cas que `useState(defaultOpen)` ne voyait pas.
    view.rerender(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    expect(screen.getByTestId("tutor-chat")).toBeInTheDocument();
  });

  it("AMÈNE le panneau sous les yeux — il est tout en bas du cours", async () => {
    const view = render(<TutorChatPanel chapterId={CHAPTER} />);
    view.rerender(<TutorChatPanel chapterId={CHAPTER} openIntent />);

    // Une frame de retard, à dessein : le routeur remet la page en haut à chaque
    // navigation, et cette ouverture en est une.
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalled());
  });

  it("s'ouvre AUSSI quand l'intention est là dès le montage", async () => {
    render(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    expect(screen.getByTestId("tutor-chat")).toBeInTheDocument();
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalled());
  });

  it("attend l'entrée du serveur pour rejoindre le panneau", async () => {
    entry = undefined;
    const view = render(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    // Rien à montrer ni à rejoindre tant que la porte n'a pas répondu.
    expect(screen.queryByTestId("tutor-chat")).not.toBeInTheDocument();
    expect(scrollIntoView).not.toHaveBeenCalled();

    entry = { allowed: true, reason: "OK", freeText: true, lang: "fr" };
    view.rerender(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    expect(screen.getByTestId("tutor-chat")).toBeInTheDocument();
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalled());
  });

  it("REND COMPTE de l'intention prise — une seule fois", () => {
    const handled = vi.fn();
    const view = render(
      <TutorChatPanel chapterId={CHAPTER} openIntent onIntentHandled={handled} />,
    );
    expect(handled).toHaveBeenCalledTimes(1);

    // L'URL nettoyée par la route : le panneau reste ouvert, il ne se referme
    // pas parce que l'intention a disparu.
    view.rerender(<TutorChatPanel chapterId={CHAPTER} onIntentHandled={handled} />);
    expect(handled).toHaveBeenCalledTimes(1);
    expect(screen.getByTestId("tutor-chat")).toBeInTheDocument();
  });

  it("ne rend PAS compte tant qu'il n'a rien pris", () => {
    const handled = vi.fn();
    render(<TutorChatPanel chapterId={CHAPTER} onIntentHandled={handled} />);
    expect(handled).not.toHaveBeenCalled();
  });

  it("répond à CHAQUE demande — la deuxième comme la première", async () => {
    const view = render(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalledTimes(1));

    // L'intention prise, la route la retire de l'URL…
    view.rerender(<TutorChatPanel chapterId={CHAPTER} />);
    // …et l'élève, remonté lire son cours, redemande le Prof. Sans ce
    // va-et-vient, la deuxième demande produisait une URL identique à la
    // première : aucune navigation, et de nouveau « rien ne se passe ».
    view.rerender(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalledTimes(2));
  });
});

describe("TutorChatPanel — R-1, la porte", () => {
  it("NOMME le refus au lieu de disparaître", async () => {
    entry = { allowed: false, reason: "ACTIVE_SESSION", freeText: false, lang: "fr" };
    render(<TutorChatPanel chapterId={CHAPTER} openIntent />);

    // La même phrase que l'écran de correction, et rien de cliquable.
    expect(screen.getByText(/Termine d'abord ta mission/)).toBeInTheDocument();
    expect(screen.queryByRole("button")).toBeNull();
    // Elle est la réponse au clic : on l'amène sous les yeux, comme le panneau.
    await waitFor(() => expect(scrollIntoView).toHaveBeenCalled());
  });

  it("dit aussi le donjon et le duel", () => {
    entry = { allowed: false, reason: "ACTIVE_DUNGEON", freeText: false, lang: "fr" };
    const view = render(<TutorChatPanel chapterId={CHAPTER} />);
    expect(screen.getByText(/Pas pendant un donjon/)).toBeInTheDocument();

    entry = { allowed: false, reason: "ACTIVE_DUEL", freeText: false, lang: "fr" };
    view.rerender(<TutorChatPanel chapterId={CHAPTER} />);
    expect(screen.getByText(/Pas pendant un duel/)).toBeInTheDocument();
  });

  it("s'efface entièrement sur un refus qu'on ne sait pas expliquer", () => {
    // `UNKNOWN` ne dit rien à un enfant — et il couvre la porte qu'on n'a PAS su
    // interroger. L'écran se tait plutôt que d'inventer.
    entry = { allowed: false, reason: "UNKNOWN", freeText: false, lang: "fr" };
    const { container } = render(<TutorChatPanel chapterId={CHAPTER} openIntent />);
    expect(container.textContent).toBe("");
  });
});
