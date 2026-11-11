/**
 * « Où tu en es » — la carte à 4 états (étude 30, lot 3 · US-2, US-3, D-1, R-17).
 *
 * Ce que ces tests protègent est presque entièrement de l'ordre du NE PAS :
 *
 *  1. **D-1, l'interdit central** — aucune probabilité de croyance n'atteint le DOM. Le test
 *     ne cherche pas « le composant lit-il `p_known` ? » (il ne le lit pas, c'est facile à
 *     vérifier en le regardant) : il balaie le texte rendu à la recherche de TOUT nombre qui
 *     ressemble à une croyance, y compris via une future régression. Une assertion sur le
 *     résultat, pas sur l'implémentation.
 *  2. **R-17, la maîtrise ne verrouille rien** — une compétence hors-portée porte un
 *     avertissement, jamais un bouton désactivé ni un cadenas.
 *  3. **R-4, la preuve se montre** — « prouvé N fois, sous M formes » n'apparaît que sur une
 *     compétence déclarée maîtrisée, parce que c'est là que la phrase engage.
 *  4. **US-3, la contestation** — elle est offerte sur une croyance DÉDUITE, et sur elle seule.
 *  5. **R-6** — zéro ligne rend un état vide qui invite, jamais une page cassée.
 *  6. **Le repli (2026-09-04)** — sur le tableau de bord, la carte ne déroule PAS ses lignes :
 *     un résumé par état, et un geste pour le détail. Les tests de détail ci-dessous passent
 *     donc par `expand()` — c'est le chemin de l'élève, pas un contournement.
 */
import { render, screen, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

import type { LearningStateRow } from "@/shared/types/competency";

const disputeInference = vi.fn((_args: unknown) => Promise.resolve({ disputed: true }));
vi.mock("../progression.server", () => ({
  disputeInference: (args: unknown) => disputeInference(args),
}));

let mockLocale: "fr" | "en" | "ar" = "fr";
vi.mock("@/lib/i18n", async () => {
  const { fr } = await import("@/lib/i18n/fr");
  const { ar } = await import("@/lib/i18n/ar");
  return {
    useI18n: () => ({
      t: mockLocale === "ar" ? ar : fr,
      locale: mockLocale,
      dir: mockLocale === "ar" ? "rtl" : "ltr",
      setLocale: () => {},
    }),
  };
});

import { LearningStateMap } from "../components/learning-state-map";

function row(overrides: Partial<LearningStateRow> = {}): LearningStateRow {
  return {
    competency_id: "c-1",
    slug: "math.frac.add-sous",
    family: "math",
    domain: "frac",
    label_fr: "Additionner des fractions",
    label_en: "Add fractions",
    label_ar: "جمع الكسور",
    state: "en-cours",
    zone: "frontiere",
    p_known: 0.7314,
    evidence_count: 3,
    sessions_seen: 2,
    forms_count: 1,
    belief_source: "evidence",
    suspect: false,
    ...overrides,
  };
}

beforeEach(() => {
  mockLocale = "fr";
  disputeInference.mockClear();
});

/** Le geste de l'élève : déplier la liste. Sélectionné par son état ARIA, pas par son libellé,
 *  pour que les tests en arabe passent par le même chemin. */
async function expand() {
  await userEvent.setup().click(screen.getByRole("button", { expanded: false }));
  return screen.getByTestId("learning-state-detail");
}

describe("LearningStateMap — la carte à 4 états", () => {
  describe("D-1 : la croyance décide, elle ne s'affiche pas", () => {
    it("ne rend AUCUNE probabilité de croyance, sous aucune forme", async () => {
      const { container } = render(
        <LearningStateMap
          rows={[
            row({ p_known: 0.7314, state: "en-cours" }),
            row({
              competency_id: "c-2",
              slug: "s2",
              p_known: 0.9712,
              state: "maitrisee",
              evidence_count: 4,
              forms_count: 2,
              label_fr: "Comparer",
            }),
            row({
              competency_id: "c-3",
              slug: "s3",
              p_known: 0.0821,
              state: "lacune",
              label_fr: "Diviser",
            }),
          ]}
        />,
      );
      // Replié (le résumé) puis déplié (les lignes) : les deux surfaces sont balayées, parce
      // qu'une régression pourrait rebrancher la valeur dans l'une sans toucher l'autre.
      const collapsed = container.textContent ?? "";
      expect(collapsed).not.toMatch(/\d+\s*%/);
      await expand();
      const text = container.textContent ?? "";

      // Ni la valeur brute, ni son écriture décimale française, ni sa version en pourcentage.
      for (const forbidden of [
        "0.7314",
        "0,7314",
        "0.73",
        "0,73",
        "73 %",
        "73%",
        "0.9712",
        "97 %",
        "97%",
        "0.0821",
        "8 %",
        "8%",
      ]) {
        expect(text).not.toContain(forbidden);
      }
      // Et, plus largement : aucun pourcentage du tout sur cette carte. C'est la différence
      // avec la carte de é07 — celle-ci n'est pas un bulletin.
      expect(text).not.toMatch(/\d+\s*%/);
    });

    it("rend un ÉTAT en toutes lettres à la place", async () => {
      render(<LearningStateMap rows={[row({ state: "lacune" })]} />);
      // Une fois dans le résumé, une fois sur la ligne : les deux en toutes lettres.
      expect(screen.getByText("Lacune")).toBeInTheDocument();
      await expand();
      expect(screen.getAllByText("Lacune")).toHaveLength(2);
    });
  });

  describe("R-4 : la preuve se montre, elle ne s'affirme pas", () => {
    it("affiche « prouvé N fois, sous M formes » sur une compétence maîtrisée", async () => {
      render(
        <LearningStateMap
          rows={[row({ state: "maitrisee", evidence_count: 5, forms_count: 3 })]}
        />,
      );
      await expand();
      expect(screen.getByText("prouvé 5 fois, sous 3 formes")).toBeInTheDocument();
    });

    it("ne l'affiche PAS sur une compétence qui n'est pas déclarée maîtrisée", async () => {
      // La phrase engage : « prouvé 3 fois » sous une compétence fragile laisserait croire
      // que la preuve suffit, alors que R-4 dit exactement l'inverse.
      render(<LearningStateMap rows={[row({ state: "fragile", evidence_count: 3 })]} />);
      await expand();
      expect(screen.queryByText(/prouvé/)).not.toBeInTheDocument();
    });
  });

  describe("US-3 / R-10 : une déduction se conteste en un geste", () => {
    it("offre « je ne suis pas d'accord » sur une croyance déduite", async () => {
      const user = userEvent.setup();
      render(<LearningStateMap rows={[row({ belief_source: "inference" })]} />);
      await expand();

      expect(screen.getByText("Déduit")).toBeInTheDocument();
      await user.click(screen.getByRole("button", { name: "Je ne suis pas d'accord" }));

      expect(disputeInference).toHaveBeenCalledWith({
        data: { competency: "math.frac.add-sous" },
      });
      // Le geste répond tout de suite : attendre le serveur pour un refus donnerait
      // l'impression de n'être pas écouté.
      expect(screen.getByRole("status")).toHaveTextContent(/c'est noté/i);
      expect(screen.queryByText("Déduit")).not.toBeInTheDocument();
    });

    it("ne l'offre PAS sur une croyance gagnée par la preuve", async () => {
      // La refuser reviendrait à effacer ce que l'élève a réellement fait.
      render(<LearningStateMap rows={[row({ belief_source: "evidence" })]} />);
      await expand();
      expect(screen.queryByText("Déduit")).not.toBeInTheDocument();
      expect(screen.queryByRole("button", { name: /pas d'accord/ })).not.toBeInTheDocument();
    });
  });

  describe("R-17 : la maîtrise conseille, elle n'interdit jamais", () => {
    it("une compétence hors-portée est signalée, jamais verrouillée", async () => {
      const { container } = render(
        <LearningStateMap rows={[row({ zone: "hors-portee", state: "fragile" })]} />,
      );
      await expand();
      expect(screen.getByText("Il manque une base")).toBeInTheDocument();
      // Aucun bouton désactivé, aucun cadenas : é22 a retiré les faux verrous séquentiels,
      // et cette carte ne les remet pas par la bande.
      expect(container.querySelectorAll("button:disabled")).toHaveLength(0);
      expect(container.querySelector('[aria-disabled="true"]')).toBeNull();
    });
  });

  describe("R-8 : « à revoir » est une priorité, pas une sanction", () => {
    it("affiche le marqueur suspect sans changer l'état", async () => {
      render(<LearningStateMap rows={[row({ suspect: true, state: "en-cours" })]} />);
      const detail = await expand();
      expect(within(detail).getByText("À revoir")).toBeInTheDocument();
      expect(within(detail).getByText("En cours")).toBeInTheDocument();
    });
  });

  describe("Lecture et langue", () => {
    it("trie par urgence : ce qui bloque en haut, l'acquis en bas", async () => {
      render(
        <LearningStateMap
          rows={[
            row({
              competency_id: "a",
              slug: "a",
              state: "maitrisee",
              label_fr: "Acquise",
              evidence_count: 4,
              forms_count: 2,
            }),
            row({ competency_id: "b", slug: "b", state: "lacune", label_fr: "Bloquante" }),
            row({ competency_id: "c", slug: "c", state: "fragile", label_fr: "Fragile" }),
          ]}
        />,
      );
      const detail = await expand();
      const labels = within(detail)
        .getAllByRole("listitem")
        .map((li) => li.textContent?.slice(0, 20));
      expect(labels[0]).toContain("Bloquante");
      expect(labels[1]).toContain("Fragile");
      expect(labels[2]).toContain("Acquise");
    });

    it("met les libellés dans la langue de l'interface (le serveur en envoie trois)", async () => {
      mockLocale = "ar";
      render(<LearningStateMap rows={[row()]} />);
      await expand();
      expect(screen.getByText("جمع الكسور")).toBeInTheDocument();
      expect(screen.queryByText("Additionner des fractions")).not.toBeInTheDocument();
    });

    it("RTL : une phrase mixte texte/chiffres est UN SEUL nœud de texte", async () => {
      // Le piège documenté de `docs/design-surfaces.md` : « أُثبتت 4 مرات، بـ 2 أشكال » mêle
      // arabe et chiffres. Découpée en plusieurs nœuds (« أُثبتت », {n}, « مرات »…), elle
      // s'inverse à l'affichage — les nombres partent au mauvais bout de la phrase. La parade
      // n'est pas une classe CSS, c'est de composer la chaîne AVANT de la rendre. Ce test
      // vérifie le résultat, donc il survivrait à une réécriture du composant.
      mockLocale = "ar";
      const { container } = render(
        <LearningStateMap
          rows={[row({ state: "maitrisee", evidence_count: 4, forms_count: 2 })]}
        />,
      );
      await expand();
      const proven = [...container.querySelectorAll("span")].find((el) =>
        el.textContent?.includes("أُثبتت"),
      );
      expect(proven).toBeDefined();
      expect(proven?.childNodes).toHaveLength(1);
      expect(proven?.childNodes[0]?.nodeType).toBe(Node.TEXT_NODE);
      expect(proven?.textContent).toBe("أُثبتت 4 مرات، بـ 2 أشكال");
    });

    it("groupe par domaine", async () => {
      render(
        <LearningStateMap
          rows={[
            row({ competency_id: "a", slug: "a", domain: "frac" }),
            row({ competency_id: "b", slug: "b", domain: "geo", label_fr: "Thalès" }),
          ]}
        />,
      );
      await expand();
      expect(screen.getByText("frac")).toBeInTheDocument();
      expect(screen.getByText("geo")).toBeInTheDocument();
    });
  });

  describe("Le repli : le hall n'est pas un audit", () => {
    const three = [
      row({ competency_id: "a", slug: "a", state: "lacune", label_fr: "Bloquante" }),
      row({ competency_id: "b", slug: "b", state: "lacune", label_fr: "Bloquante aussi" }),
      row({
        competency_id: "c",
        slug: "c",
        state: "maitrisee",
        label_fr: "Acquise",
        evidence_count: 4,
        forms_count: 2,
      }),
    ];

    it("se replie par défaut : le titre, le résumé par état, et AUCUNE ligne de compétence", () => {
      render(<LearningStateMap rows={three} />);
      expect(screen.getByText("Où tu en es")).toBeInTheDocument();
      expect(screen.queryByTestId("learning-state-detail")).not.toBeInTheDocument();
      expect(screen.queryByText("Bloquante")).not.toBeInTheDocument();
      expect(screen.queryByText(/prouvé/)).not.toBeInTheDocument();
      expect(screen.getByRole("button", { expanded: false })).toHaveTextContent("Voir le détail");
    });

    it("le résumé compte par état, dans l'ordre d'urgence, et tait les états absents", () => {
      render(<LearningStateMap rows={three} />);
      const chips = within(screen.getByRole("list", { name: "Résumé par état" })).getAllByRole(
        "listitem",
      );
      expect(chips.map((c) => c.textContent)).toEqual(["Lacune2", "Maîtrisée1"]);
      // Ni « Fragile », ni « En cours », ni « Pas encore vue » : un zéro n'informe pas, et
      // « 0 lacune » ressemblerait à un satisfecit.
      expect(screen.queryByText("Fragile")).not.toBeInTheDocument();
      expect(screen.queryByText("En cours")).not.toBeInTheDocument();
    });

    it("un geste déplie la liste complète, le même geste la replie", async () => {
      const user = userEvent.setup();
      render(<LearningStateMap rows={three} />);

      await user.click(screen.getByRole("button", { expanded: false }));
      const detail = screen.getByTestId("learning-state-detail");
      expect(within(detail).getAllByRole("listitem")).toHaveLength(3);
      expect(screen.getByText("prouvé 4 fois, sous 2 formes")).toBeInTheDocument();
      const toggle = screen.getByRole("button", { expanded: true });
      expect(toggle).toHaveTextContent("Masquer le détail");
      expect(toggle).toHaveAttribute("aria-controls", detail.id);

      await user.click(toggle);
      expect(screen.queryByTestId("learning-state-detail")).not.toBeInTheDocument();
      expect(screen.getByRole("button", { expanded: false })).toBeInTheDocument();
    });

    it("le résumé suit la langue de l'interface", () => {
      mockLocale = "ar";
      render(<LearningStateMap rows={three} />);
      expect(screen.getByRole("list", { name: "ملخّص حسب الحالة" })).toBeInTheDocument();
      expect(screen.getByRole("button", { expanded: false })).toHaveTextContent("عرض التفاصيل");
    });
  });

  describe("R-6 : l'état vide invite, il ne reproche pas", () => {
    it("rend une invitation quand rien n'est taggé", () => {
      render(<LearningStateMap rows={[]} />);
      expect(screen.getByText(/ta carte s'allumera/i)).toBeInTheDocument();
    });
  });
});
