import { afterEach, describe, expect, it, vi } from "vitest";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";

import { frGuide } from "@/lib/i18n/guide/fr";
import { fr } from "@/lib/i18n/fr";
import { LOCKED_CHAPTER_STEPS } from "@/shared/lib/guide";
import { guideIntroKey, GUIDE_TIPS_KEY } from "@/shared/lib/guide-storage";

let pathname = "/matiere/s1";
vi.mock("@tanstack/react-router", () => ({
  useRouterState: ({ select }: { select: (s: { location: { pathname: string } }) => string }) =>
    select({ location: { pathname } }),
}));

import { ChapterSteps } from "../chapter-steps";
import { GuideButton } from "../guide-button";
import { GuideIntroCard } from "../guide-intro-card";
import { GuideProvider } from "../guide-provider";
import { GuideRule } from "../guide-rule";
import { HelpTip } from "../help-tip";

const g = frGuide.guide;

afterEach(() => {
  localStorage.clear();
  pathname = "/matiere/s1";
});

describe("GuideButton + fiche d'aide", () => {
  it("le bouton « Aide » est écrit, et ouvre la fiche de l'écran affiché", async () => {
    render(
      <GuideProvider>
        <GuideButton />
      </GuideProvider>,
    );
    const button = screen.getByTestId("guide-open");
    expect(button).toHaveTextContent(fr.layout.help);
    expect(screen.queryByTestId("guide-sheet")).toBeNull();

    fireEvent.click(button);
    expect(await screen.findByTestId("guide-sheet")).toBeInTheDocument();
    expect(screen.getByTestId("guide-screen-subject")).toHaveTextContent(g.screens.subject.title);
    // Écran élève : la règle d'or est dite.
    expect(screen.getByText(g.rule.title)).toBeInTheDocument();
  });

  it("les fiches parent n'affichent pas la règle d'or (pas de cadenas à expliquer)", async () => {
    pathname = "/parent-report";
    render(
      <GuideProvider>
        <GuideButton />
      </GuideProvider>,
    );
    fireEvent.click(screen.getByTestId("guide-open"));
    expect(await screen.findByTestId("guide-screen-parent")).toHaveTextContent(
      g.screens.parent.title,
    );
    expect(screen.queryByText(g.rule.title)).toBeNull();
  });

  it("l'interrupteur éteint les bulles « ? » et s'en souvient", async () => {
    render(
      <GuideProvider>
        <GuideButton />
        <HelpTip label="Lire le cours" text="Commence ici." />
      </GuideProvider>,
    );
    expect(screen.getByTestId("help-tip")).toBeInTheDocument();
    fireEvent.click(screen.getByTestId("guide-open"));
    fireEvent.click(await screen.findByTestId("guide-tips-switch"));
    await waitFor(() => expect(screen.queryByTestId("help-tip")).toBeNull());
    expect(localStorage.getItem(GUIDE_TIPS_KEY)).toBe("off");
  });

  it("un choix « off » mémorisé est relu au montage", async () => {
    localStorage.setItem(GUIDE_TIPS_KEY, "off");
    render(
      <GuideProvider>
        <HelpTip label="Lire le cours" text="Commence ici." />
      </GuideProvider>,
    );
    await waitFor(() => expect(screen.queryByTestId("help-tip")).toBeNull());
  });
});

describe("HelpTip", () => {
  it("s'annonce au lecteur d'écran et s'ouvre au toucher", async () => {
    render(<HelpTip label="Lire le cours" text="Commence toujours par ici." />);
    const tip = screen.getByRole("button", { name: "Aide : Lire le cours" });
    fireEvent.click(tip);
    expect(await screen.findByText("Commence toujours par ici.")).toBeInTheDocument();
  });
});

describe("GuideIntroCard — première visite", () => {
  it("se montre une fois, puis « J'ai compris » la ferme pour de bon", async () => {
    const { unmount } = render(<GuideIntroCard screen="dashboard" />);
    const card = await screen.findByTestId("guide-intro-dashboard");
    expect(card).toHaveTextContent(g.screens.dashboard.title);
    // Les trois premières lignes de la fiche, pas plus.
    expect(card).toHaveTextContent(g.screens.dashboard.items[2].label);
    expect(card).not.toHaveTextContent(g.screens.dashboard.items[3].label);

    fireEvent.click(screen.getByTestId("guide-intro-dismiss"));
    expect(screen.queryByTestId("guide-intro-dashboard")).toBeNull();
    expect(localStorage.getItem(guideIntroKey("dashboard"))).toBe("seen");

    unmount();
    render(<GuideIntroCard screen="dashboard" />);
    await waitFor(() => expect(screen.queryByTestId("guide-intro-dashboard")).toBeNull());
  });

  it("la variante « règle » dit les 3 étapes, seuil et durée compris", async () => {
    render(<GuideIntroCard screen="subject" variant="rule" />);
    const card = await screen.findByTestId("guide-intro-subject");
    expect(card).toHaveTextContent(g.rule.lesson.title);
    expect(card).toHaveTextContent(g.rule.missions.title);
    expect(card).toHaveTextContent("80 %");
    expect(card).toHaveTextContent("4 secondes");
  });

  it("« Voir toute l'aide » ouvre la fiche", async () => {
    render(
      <GuideProvider>
        <GuideIntroCard screen="subject" />
      </GuideProvider>,
    );
    fireEvent.click(await screen.findByText(g.intro.more));
    expect(await screen.findByTestId("guide-sheet")).toBeInTheDocument();
  });
});

describe("ChapterSteps et GuideRule", () => {
  it("marque l'étape à faire maintenant et les étapes fermées", () => {
    render(<ChapterSteps states={LOCKED_CHAPTER_STEPS} />);
    const list = screen.getByRole("list", { name: g.stepper.label });
    const items = list.querySelectorAll("li");
    expect(items).toHaveLength(3);
    expect(items[0]).toHaveAttribute("aria-current", "step");
    expect(items[0]).toHaveTextContent(`1. ${g.stepper.lesson}`);
    expect(items[2]).toHaveAttribute("data-state", "locked");
    expect(items[2]).toHaveTextContent(g.stepper.locked);
    // #1191 : l'étiquette d'état n'est jamais éclaircie (4,41:1 en thème clair).
    expect(screen.getByText(g.stepper.current).className).not.toMatch(/\bopacity-/);
  });

  it("GuideRule peut taire son titre", () => {
    render(<GuideRule showTitle={false} />);
    expect(screen.queryByText(g.rule.title)).toBeNull();
    expect(screen.getByText(g.rule.quiz.title)).toBeInTheDocument();
  });
});
