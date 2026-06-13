import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { fr } from "@/lib/i18n/fr";

const mockUsePush = vi.fn();
vi.mock("../use-push", () => ({ usePush: () => mockUsePush() }));
vi.mock("sonner", () => ({ toast: { error: vi.fn(), success: vi.fn() } }));

import { EnablePushCard } from "../components/enable-push-card";

beforeEach(() => mockUsePush.mockReset());

function withState(state: string) {
  mockUsePush.mockReturnValue({ state, busy: false, enable: vi.fn(), disable: vi.fn() });
}

describe("EnablePushCard", () => {
  it.each(["loading", "unsupported", "unconfigured"])("renders nothing when %s", (state) => {
    withState(state);
    const { container } = render(<EnablePushCard />);
    expect(container).toBeEmptyDOMElement();
  });

  it("offers the enable CTA in the default state", () => {
    withState("default");
    render(<EnablePushCard />);
    expect(screen.getByText(fr.pushNotifications.enable)).toBeInTheDocument();
  });

  it("shows the enabled state with a disable action", () => {
    withState("granted");
    render(<EnablePushCard />);
    expect(screen.getByText(fr.pushNotifications.enabled)).toBeInTheDocument();
    expect(screen.getByText(fr.pushNotifications.disable)).toBeInTheDocument();
  });

  it("surfaces the blocked hint when denied", () => {
    withState("denied");
    render(<EnablePushCard />);
    expect(screen.getByText(fr.pushNotifications.blocked)).toBeInTheDocument();
  });
});
