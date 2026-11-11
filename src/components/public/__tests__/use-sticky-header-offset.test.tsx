import { render } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";
import {
  STICKY_HEADER_VAR,
  useStickyHeaderOffset,
} from "@/components/public/use-sticky-header-offset";

function Header() {
  const ref = useStickyHeaderOffset<HTMLElement>();
  return <header ref={ref}>en-tête</header>;
}

const published = () => document.documentElement.style.getPropertyValue(STICKY_HEADER_VAR);

/**
 * Audit d'affichage du 2026-10-31 : les sauts d'ancre atterrissaient SOUS l'en-tête
 * collant sur téléphone. La hauteur de l'en-tête est mesurée et publiée pour que
 * `scroll-padding-top` (styles.css) arrête le défilement au bon endroit.
 */
describe("useStickyHeaderOffset", () => {
  afterEach(() => {
    vi.restoreAllMocks();
    vi.unstubAllGlobals();
  });

  it("publie la hauteur mesurée de l'en-tête sur <html>, arrondie", () => {
    vi.spyOn(HTMLElement.prototype, "getBoundingClientRect").mockReturnValue({
      height: 167.6,
    } as DOMRect);
    render(<Header />);
    expect(published()).toBe("168px");
  });

  it("suit les changements de taille (rotation, langue, session lue)", () => {
    let height = 61;
    vi.spyOn(HTMLElement.prototype, "getBoundingClientRect").mockImplementation(
      () => ({ height }) as DOMRect,
    );
    let notify: () => void = () => {};
    const observe = vi.fn();
    const disconnect = vi.fn();
    vi.stubGlobal(
      "ResizeObserver",
      class {
        constructor(callback: () => void) {
          notify = callback;
        }
        observe = observe;
        disconnect = disconnect;
      },
    );

    const { unmount } = render(<Header />);
    expect(published()).toBe("61px");
    expect(observe).toHaveBeenCalledTimes(1);

    height = 168;
    notify();
    expect(published()).toBe("168px");

    unmount();
    expect(disconnect).toHaveBeenCalledTimes(1);
  });

  // Hors coquille publique il n'y a plus d'en-tête collant : la variable doit
  // disparaître avec lui, sinon la coquille connectée garderait un décalage fantôme.
  it("retire la variable quand l'en-tête disparaît", () => {
    vi.spyOn(HTMLElement.prototype, "getBoundingClientRect").mockReturnValue({
      height: 100,
    } as DOMRect);
    const { unmount } = render(<Header />);
    expect(published()).toBe("100px");
    unmount();
    expect(published()).toBe("");
  });

  it("sans ResizeObserver, publie quand même la hauteur initiale", () => {
    vi.stubGlobal("ResizeObserver", undefined);
    vi.spyOn(HTMLElement.prototype, "getBoundingClientRect").mockReturnValue({
      height: 80,
    } as DOMRect);
    render(<Header />);
    expect(published()).toBe("80px");
  });
});
