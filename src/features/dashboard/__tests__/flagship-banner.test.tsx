import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    flagship: {
      badge: "National exam",
      sectionTitle: "Our flagship exams",
      bannerTitle: "Prepare for your national exam",
      bannerSubtitle: "Aim for the exam.",
      bannerCta: "Explore the exams",
    },
  }),
}));

import { FlagshipBanner } from "../components/flagship-banner";
import type { ProgramParcours } from "../program-families";

const P = (id: string, name_fr: string): ProgramParcours => ({
  id,
  name_fr,
  status: "available",
  is_premium: true,
  hasEntitlement: false,
  theme_id: "ecole-tn",
  grade_cycle: null,
  grade_order: null,
});

describe("FlagshipBanner", () => {
  it("renders nothing when there are no flagship parcours", () => {
    const { container } = render(<FlagshipBanner flagships={[]} onOpen={vi.fn()} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("spotlights the flagship concours and opens the category on click", () => {
    const onOpen = vi.fn();
    render(
      <FlagshipBanner
        flagships={[P("concours-6eme", "6ème"), P("concours-9eme", "9ème")]}
        onOpen={onOpen}
      />,
    );
    expect(screen.getByText("Prepare for your national exam")).toBeInTheDocument();
    expect(screen.getByText("6ème")).toBeInTheDocument();
    expect(screen.getByText("9ème")).toBeInTheDocument();
    // The whole banner is a single tap target → the category page.
    fireEvent.click(screen.getByRole("button"));
    expect(onOpen).toHaveBeenCalledTimes(1);
  });
});
