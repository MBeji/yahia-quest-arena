import { renderHook } from "@testing-library/react";
import { afterEach, describe, it, expect, vi } from "vitest";
import {
  buildAttributedCopy,
  isImageTarget,
  usePublicContentProtection,
} from "../content-protection";

describe("buildAttributedCopy", () => {
  it("appends source + © to a substantial selection", () => {
    const long = "Le théorème de Thalès permet de calculer des longueurs dans des triangles.";
    const out = buildAttributedCopy(long, "https://na9ranal3ab.tn/chapitre/abc");
    expect(out).toContain(long);
    expect(out).toContain("https://na9ranal3ab.tn/chapitre/abc");
    expect(out).toContain("Na9ra Nal3ab");
    expect(out).toContain("Propriété intellectuelle");
  });

  it("leaves a trivial selection untouched", () => {
    expect(buildAttributedCopy("court", "https://x")).toBe("court");
  });

  it("handles a missing url gracefully", () => {
    const long = "x".repeat(80);
    expect(buildAttributedCopy(long, "")).toContain("Na9ra Nal3ab");
  });
});

describe("isImageTarget", () => {
  it("is true for an <img> element", () => {
    expect(isImageTarget(document.createElement("img"))).toBe(true);
  });

  it("is false for other elements and null", () => {
    expect(isImageTarget(document.createElement("div"))).toBe(false);
    expect(isImageTarget(null)).toBe(false);
  });
});

/**
 * Le hook branché sur la coquille publique : la copie reste permise mais porte
 * une attribution, les images ne se glissent ni ne s'ouvrent au clic droit. Seules
 * ses deux fonctions pures étaient testées ; le branchement lui-même ne l'était pas.
 */
describe("usePublicContentProtection", () => {
  const LONG = "Le théorème de Thalès relie des longueurs proportionnelles dans un triangle.";

  afterEach(() => {
    vi.restoreAllMocks();
    document.body.innerHTML = "";
  });

  function copyEvent() {
    const event = new Event("copy", { bubbles: true, cancelable: true });
    const setData = vi.fn();
    Object.defineProperty(event, "clipboardData", { value: { setData } });
    return { event, setData };
  }

  function selecting(text: string) {
    vi.spyOn(document, "getSelection").mockReturnValue({
      toString: () => text,
    } as unknown as Selection);
  }

  it("ajoute la source et le © à une copie substantielle, à la place du texte brut", () => {
    renderHook(() => usePublicContentProtection());
    selecting(LONG);
    const { event, setData } = copyEvent();

    document.dispatchEvent(event);

    expect(event.defaultPrevented).toBe(true);
    expect(setData).toHaveBeenCalledWith(
      "text/plain",
      buildAttributedCopy(LONG, window.location.href),
    );
  });

  it("laisse une copie courte au navigateur, sans y toucher", () => {
    renderHook(() => usePublicContentProtection());
    selecting("Thalès");
    const { event, setData } = copyEvent();

    document.dispatchEvent(event);

    expect(event.defaultPrevented).toBe(false);
    expect(setData).not.toHaveBeenCalled();
  });

  it.each(["contextmenu", "dragstart"])("bloque « %s » sur une image, pas ailleurs", (type) => {
    renderHook(() => usePublicContentProtection());
    document.body.innerHTML = `<figure><img alt="schéma" /></figure><p>texte</p>`;

    const onImage = new Event(type, { bubbles: true, cancelable: true });
    document.querySelector("img")?.dispatchEvent(onImage);
    const onText = new Event(type, { bubbles: true, cancelable: true });
    document.querySelector("p")?.dispatchEvent(onText);

    expect(onImage.defaultPrevented).toBe(true);
    expect(onText.defaultPrevented).toBe(false);
  });

  it("retire ses écouteurs au démontage", () => {
    const { unmount } = renderHook(() => usePublicContentProtection());
    unmount();
    selecting(LONG);
    const { event, setData } = copyEvent();

    document.dispatchEvent(event);

    expect(setData).not.toHaveBeenCalled();
  });
});
