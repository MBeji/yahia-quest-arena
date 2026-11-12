import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "../dialog";
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle } from "../sheet";

/**
 * Dialogue et panneau latéral suivent le sens d'écriture (issue #1228,
 * `dialog-sheet-rtl-header-and-close`). Mesuré dans Chromium en arabe avant le
 * correctif : croix à DROITE (côté début, sur le titre) et titre aligné à gauche ;
 * après : croix à gauche, titre à droite — et rien ne bouge en français. jsdom ne
 * met pas en page : on tient ici les classes LOGIQUES qui produisent ce rendu.
 */
const physical = /(?:^|\s)(?:sm:)?(?:left|right)-\d|text-(?:left|right)\b/;

describe("Dialog", () => {
  it("croix côté fin, en-tête aligné au début — aucune classe physique", () => {
    render(
      <Dialog open>
        <DialogContent>
          <DialogHeader data-testid="header">
            <DialogTitle>Titre</DialogTitle>
            <DialogDescription>Texte</DialogDescription>
          </DialogHeader>
        </DialogContent>
      </Dialog>,
    );
    const close = screen.getByRole("button", { name: "Fermer" });
    expect(close.className).toContain("end-2");
    expect(close.className).not.toMatch(physical);
    expect(screen.getByTestId("header").className).toContain("sm:text-start");
    expect(screen.getByTestId("header").className).not.toMatch(physical);
  });
});

describe("Sheet", () => {
  function open(side?: "start" | "end" | "left" | "right") {
    render(
      <Sheet open>
        <SheetContent side={side} data-testid="sheet">
          <SheetHeader data-testid="header">
            <SheetTitle>Titre</SheetTitle>
            <SheetDescription>Texte</SheetDescription>
          </SheetHeader>
        </SheetContent>
      </Sheet>,
    );
    return screen.getByTestId("sheet").className;
  }

  it("par défaut : côté FIN, filet et glissement logiques", () => {
    const classes = open();
    expect(classes).toContain("end-0");
    expect(classes).toContain("border-s");
    expect(classes).toContain("slide-in-from-end");
    expect(classes).not.toMatch(/(?:^|\s)(?:left|right)-0|slide-in-from-(?:left|right)/);
    expect(screen.getByRole("button", { name: "Fermer" }).className).toContain("end-2");
    expect(screen.getByTestId("header").className).toContain("sm:text-start");
  });

  it("`start` : côté début", () => {
    const classes = open("start");
    expect(classes).toContain("start-0");
    expect(classes).toContain("border-e");
    expect(classes).toContain("slide-in-from-start");
  });

  it("`left` reste un côté physique, pour qui le demande", () => {
    expect(open("left")).toContain("left-0");
  });
});
