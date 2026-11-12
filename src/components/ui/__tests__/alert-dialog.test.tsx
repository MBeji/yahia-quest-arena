import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "../alert-dialog";

// Audit d'affichage (#1228) — `alert-dialog-no-gutter-no-scroll` : la confirmation de
// suppression du compte touchait les bords d'un téléphone et, en paysage, ses boutons
// sortaient de l'écran sans défilement. Mesuré au navigateur avec ces classes (voir la
// PR) ; ce test épingle le contrat pour qu'un nettoyage ne le retire pas en silence.
describe("AlertDialog — gouttière, défilement, sens d'écriture", () => {
  const renderOpen = () =>
    render(
      <AlertDialog open>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Supprimer le compte ?</AlertDialogTitle>
            <AlertDialogDescription>Cette action est définitive.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Annuler</AlertDialogCancel>
            <AlertDialogAction>Supprimer</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>,
    );

  it("garde une gouttière latérale et défile quand l'écran est trop bas", () => {
    renderOpen();
    const classes = screen.getByRole("alertdialog").className.split(/\s+/);
    expect(classes).toContain("w-[calc(100%-2rem)]");
    expect(classes).toContain("max-h-[calc(100dvh-2rem)]");
    expect(classes).toContain("overflow-y-auto");
    expect(classes).not.toContain("w-full");
  });

  it("n'emploie aucune classe physique : en arabe le texte et les boutons suivent la page", () => {
    renderOpen();
    const html = screen.getByRole("alertdialog").innerHTML;
    expect(html).not.toMatch(/text-left|space-x-/);
  });
});
