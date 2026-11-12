import { act, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it } from "vitest";
import { toast } from "sonner";
import { LazyToaster } from "@/components/ui/lazy-toaster";

afterEach(() => {
  act(() => {
    toast.dismiss();
  });
});

/**
 * L'afficheur de notifications est chargé après le premier rendu (issue #1250).
 * Ces cas utilisent le VRAI `sonner` : la garantie testée est la sienne, et c'est
 * une montée de version qui pourrait la retirer.
 */
describe("LazyToaster", () => {
  // Le cas qui compte : un message d'erreur émis pendant que le chunk de
  // l'afficheur est encore en vol ne doit pas disparaître en silence.
  it("affiche une notification émise AVANT son montage", async () => {
    act(() => {
      toast.error("Connexion impossible");
    });
    expect(screen.queryByText("Connexion impossible")).toBeNull();

    render(<LazyToaster />);

    expect(await screen.findByText("Connexion impossible")).toBeInTheDocument();
  });

  it("affiche une notification émise après son montage", async () => {
    render(<LazyToaster />);
    // L'afficheur arrive par un import différé : on attend sa région.
    await screen.findByRole("region", { name: /notifications/i });

    act(() => {
      toast.success("Enregistré");
    });

    expect(await screen.findByText("Enregistré")).toBeInTheDocument();
  });

  it("transmet ses réglages à l'afficheur", async () => {
    render(<LazyToaster position="top-center" theme="dark" />);
    act(() => {
      toast("Bonjour");
    });
    const item = (await screen.findByText("Bonjour")).closest("[data-sonner-toast]");
    expect(item).toHaveAttribute("data-y-position", "top");
    expect(item).toHaveAttribute("data-x-position", "center");
    expect(item?.closest("[data-sonner-toaster]")).toHaveAttribute("data-sonner-theme", "dark");
  });
});
