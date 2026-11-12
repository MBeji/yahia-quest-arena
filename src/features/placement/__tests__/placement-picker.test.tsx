import { fireEvent, render, screen } from "@testing-library/react";
import React from "react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { PlacementPicker, type PickerSubject } from "../components/placement-picker";

/**
 * Relevé « première visite » du 2026-11-12, C-5 — toucher sa classe ne changeait rien à l'écran :
 * la liste des classes fait près de deux écrans de téléphone et la matière apparaissait 1 200 px
 * plus bas. Un CHOIX amène désormais l'étape suivante à l'écran ; un pré-remplissage, non.
 */
const grades = [
  { parcoursId: "p7", label: "7ème année de base", cycle: "college" as const },
  { parcoursId: "p8", label: "8ème année de base", cycle: "college" as const },
];
const subjects: PickerSubject[] = [
  { id: "s1", nameFr: "Français", contentLanguage: "fr", chapters: 4, questions: 40 },
];

function Harness({ initialParcours = null }: { initialParcours?: string | null }) {
  const [parcoursId, setParcoursId] = React.useState<string | null>(initialParcours);
  const [subjectId, setSubjectId] = React.useState<string | null>(null);
  return (
    <PlacementPicker
      grades={grades}
      gradesLoading={false}
      subjects={parcoursId ? subjects : null}
      subjectsLoading={false}
      selectedParcoursId={parcoursId}
      selectedSubjectId={subjectId}
      audience="student"
      starting={false}
      error={null}
      onSelectParcours={setParcoursId}
      onSelectSubject={setSubjectId}
      onAudience={() => {}}
      onStart={() => {}}
    />
  );
}

describe("PlacementPicker — l'étape ouverte vient à l'écran", () => {
  const scrollIntoView = vi.fn();
  beforeEach(() => {
    scrollIntoView.mockClear();
    Element.prototype.scrollIntoView = scrollIntoView;
  });
  afterEach(() => {
    delete (Element.prototype as { scrollIntoView?: unknown }).scrollIntoView;
  });

  it("choisir sa classe amène la liste des matières en haut de l'écran", () => {
    render(<Harness />);
    fireEvent.click(screen.getByRole("radio", { name: "7ème année de base" }));

    expect(scrollIntoView).toHaveBeenCalledTimes(1);
    expect(scrollIntoView.mock.contexts[0]).toBe(
      document.querySelector('[aria-labelledby="placement-pick-subject"]'),
    );
    expect(scrollIntoView.mock.calls[0][0]).toMatchObject({ block: "start" });
  });

  it("choisir sa matière amène le bouton Commencer à l'écran", () => {
    render(<Harness />);
    fireEvent.click(screen.getByRole("radio", { name: "7ème année de base" }));
    scrollIntoView.mockClear();
    fireEvent.click(screen.getByRole("radio", { name: "Français" }));

    expect(scrollIntoView).toHaveBeenCalledTimes(1);
    expect(
      (scrollIntoView.mock.contexts[0] as Element).querySelector('[data-testid="placement-start"]'),
    ).not.toBeNull();
    expect(scrollIntoView.mock.calls[0][0]).toMatchObject({ block: "nearest" });
  });

  it("une classe pré-remplie (adresse, carte du Hall) ne fait pas défiler la page", () => {
    render(<Harness initialParcours="p7" />);
    expect(scrollIntoView).not.toHaveBeenCalled();
  });
});
