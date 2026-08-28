import React from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { AiModeStatus } from "../ai-mode-status";

/**
 * R-1, l'invariant le plus facile à casser sans s'en apercevoir : « aucune
 * surface IA n'est visible sans mode actif — pas de bouton grisé, pas d'appel à
 * l'action, pas de "bientôt" ».
 *
 * Et R-2a / R-20 : le bouton d'enregistrement ne peut pas s'armer avant le
 * consentement, ni avant la confirmation d'adulte quand le niveau du compte
 * l'exige. Ces deux gardes existent AUSSI côté serveur (le formulaire n'est pas
 * le juge) — ici on vérifie que l'écran ne propose pas un geste que le serveur
 * refuserait, ce qui serait une impasse pour l'utilisateur.
 */

let status: AiModeStatus | undefined;

// Le faux `useQuery` répond PAR CLÉ : la section et le panneau d'activation en
// utilisent chacun un, et leur rendre le même objet ferait planter le second sur
// un `.map` — ce qui est arrivé, et ce que ce commentaire empêche de refaire.
vi.mock("@tanstack/react-query", () => ({
  useQuery: ({ queryKey }: { queryKey: unknown[] }) => {
    if (queryKey[0] === "ai-students") return { data: [] };
    // `ai-console` rend `null` quand il n'y a pas de clé : c'est l'état par
    // défaut (R-1), et le panneau de dépense ne s'affiche pas.
    if (queryKey[0] === "ai-console") return { data: null };
    return { data: status };
  },
  useQueryClient: () => ({ invalidateQueries: vi.fn() }),
}));

vi.mock("@tanstack/react-start", () => ({
  useServerFn: (fn: unknown) => fn,
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      inputValidator: () => chain,
      handler: () => vi.fn(),
    };
    return chain;
  },
}));

vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));

// Les rares clés qui portent un gabarit : le composant fait `.replace("{x}", …)`
// dessus, donc le faux doit le porter aussi, sinon la substitution est un no-op.
const PLACEHOLDERS: Record<string, string> = {
  keyMasked: "{last4}",
  pricesAsOf: "{date}",
  lastVerified: "{date}",
};

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    ai: new Proxy({} as Record<string, string>, {
      // Le dictionnaire réel est vérifié par le typecheck ; ici seule la STRUCTURE
      // compte, et un proxy évite de recopier soixante clés dans un mock qui
      // divergerait au premier ajout.
      get: (_target, key: string) =>
        PLACEHOLDERS[key] ? `ai.${key} ${PLACEHOLDERS[key]}` : `ai.${key}`,
    }),
  }),
}));

import { AiModeSection } from "../components/ai-mode-section";

const wrap = (children: React.ReactNode) =>
  React.createElement("section", { "data-testid": "ai-wrapper" }, children);

const BASE: AiModeStatus = {
  available: true,
  consentVersion: "2026-08-22",
  requiresAdultConfirmation: false,
  credential: null,
};

/** jsdom n'implémente pas `scrollIntoView` : on le pose, et on l'observe. */
const scrollIntoView = vi.fn();

beforeEach(() => {
  status = undefined;
  Element.prototype.scrollIntoView = scrollIntoView;
  scrollIntoView.mockClear();
});

describe("R-1 — le produit sans clé est le produit d'aujourd'hui", () => {
  it("ne rend RIEN quand le mode famille n'est pas disponible", () => {
    status = { ...BASE, available: false };
    const { container } = render(React.createElement(AiModeSection, { render: wrap }));
    // Pas de bouton grisé, pas de « bientôt » : littéralement rien, en-tête
    // comprise — c'est pour cela que la section enveloppe elle-même son chrome.
    expect(container).toBeEmptyDOMElement();
    expect(screen.queryByTestId("ai-wrapper")).toBeNull();
  });

  it("ne rend rien non plus tant que l'état n'est pas connu", () => {
    status = undefined;
    const { container } = render(React.createElement(AiModeSection, { render: wrap }));
    // Un squelette de chargement serait déjà un teasing.
    expect(container).toBeEmptyDOMElement();
  });

  it("rend la section — chrome compris — dès que le mode est disponible", () => {
    status = BASE;
    render(React.createElement(AiModeSection, { render: wrap }));
    expect(screen.getByTestId("ai-wrapper")).toBeInTheDocument();
    expect(screen.getByTestId("ai-attach")).toBeInTheDocument();
  });
});

describe("R-20 et R-2a — le bouton ne s'arme pas avant les deux gardes", () => {
  async function openForm() {
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByTestId("ai-attach"));
  }

  it("reste désactivé sans consentement, même avec une clé saisie", async () => {
    status = BASE;
    await openForm();
    await userEvent.type(screen.getByTestId("ai-secret"), "sk-ant-something-long");
    expect(screen.getByTestId("ai-save")).toBeDisabled();
  });

  it("s'arme une fois le consentement donné", async () => {
    status = BASE;
    await openForm();
    await userEvent.type(screen.getByTestId("ai-secret"), "sk-ant-something-long");
    await userEvent.click(screen.getByTestId("ai-consent"));
    expect(screen.getByTestId("ai-save")).toBeEnabled();
  });

  it("exige EN PLUS la confirmation d'adulte quand le niveau du compte l'impose", async () => {
    status = { ...BASE, requiresAdultConfirmation: true };
    await openForm();
    await userEvent.type(screen.getByTestId("ai-secret"), "sk-ant-something-long");
    await userEvent.click(screen.getByTestId("ai-consent"));
    // Le consentement seul ne suffit plus : R-2a s'ajoute, elle ne remplace pas.
    expect(screen.getByTestId("ai-save")).toBeDisabled();
    await userEvent.click(screen.getByTestId("ai-adult"));
    expect(screen.getByTestId("ai-save")).toBeEnabled();
  });

  it("n'affiche PAS la confirmation d'adulte quand le niveau ne l'exige pas", async () => {
    status = BASE;
    await openForm();
    expect(screen.queryByTestId("ai-adult")).toBeNull();
  });
});

describe("R-6 — l'écran ne propose pas une adresse que le serveur refuserait", () => {
  it("garde le bouton fermé sur une base_url non-https", async () => {
    status = BASE;
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByTestId("ai-attach"));
    await userEvent.click(screen.getByTestId("ai-preset-custom"));
    await userEvent.type(screen.getByTestId("ai-secret"), "sk-something-long-enough");
    await userEvent.click(screen.getByTestId("ai-consent"));

    await userEvent.type(screen.getByTestId("ai-base-url"), "http://api.example.com/v1");
    expect(screen.getByTestId("ai-save")).toBeDisabled();

    await userEvent.clear(screen.getByTestId("ai-base-url"));
    await userEvent.type(screen.getByTestId("ai-base-url"), "https://api.example.com/v1");
    expect(screen.getByTestId("ai-save")).toBeEnabled();
  });

  it("NOMME les fournisseurs compatibles, et un préréglage remplit ses champs", async () => {
    // Le grief d'origine : le moteur acceptait déjà DeepSeek (Q-4, adresse
    // libre), mais l'écran n'affichait que « Compatible OpenAI » — un porteur y
    // lisait que le produit ne connaissait que deux fournisseurs.
    status = BASE;
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByTestId("ai-attach"));

    expect(screen.getByTestId("ai-preset-deepseek")).toBeInTheDocument();
    expect(screen.getByTestId("ai-preset-moonshot")).toBeInTheDocument();
    expect(screen.getByTestId("ai-preset-zai")).toBeInTheDocument();
    // xAI a été nommé en retard sur l'usage : `grok-4.6` servait déjà à calibrer
    // le délai de la Forge, branché par la porte « Autre ».
    expect(screen.getByTestId("ai-preset-xai")).toBeInTheDocument();

    await userEvent.click(screen.getByTestId("ai-preset-deepseek"));
    expect(screen.getByTestId("ai-base-url")).toHaveValue("https://api.deepseek.com");
    expect(screen.getByTestId("ai-model-fast")).toHaveValue("deepseek-v4-flash");
    expect(screen.getByTestId("ai-model-rich")).toHaveValue("deepseek-v4-pro");
  });

  it("laisse « Autre » entièrement libre — la porte de Q-4 reste ouverte", async () => {
    status = BASE;
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByTestId("ai-attach"));
    await userEvent.click(screen.getByTestId("ai-preset-custom"));
    expect(screen.getByTestId("ai-base-url")).toHaveValue("");
    expect(screen.getByTestId("ai-model-fast")).toHaveValue("");
  });

  it("cache le champ d'adresse pour Anthropic — son adresse est fixe (§3.5)", async () => {
    status = BASE;
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByTestId("ai-attach"));
    expect(screen.queryByTestId("ai-base-url")).toBeNull();
  });
});

describe("R-4 — la clé ne réapparaît jamais", () => {
  const withKey: AiModeStatus = {
    ...BASE,
    credential: {
      provider: "anthropic",
      baseUrl: null,
      modelFast: "claude-haiku-4-5",
      modelRich: "claude-sonnet-5",
      last4: "4f2a",
      status: "active",
      lastErrorCode: "AI_UNKNOWN",
      hasError: false,
      verifiedAt: "2026-08-22T10:00:00Z",
      lastUsedAt: null,
      dailyBudgetUsd: 2,
      monthlyBudgetUsd: 20,
      doubleSolve: true,
      consentStale: false,
      limitsEnforced: false,
    },
  };

  it("affiche `sk-…4f2a` et rien de plus, en LTR", () => {
    status = withKey;
    render(React.createElement(AiModeSection, { render: wrap }));
    const masked = screen.getByText(/sk-…4f2a/);
    expect(masked).toBeInTheDocument();
    // Un masque de clé lu de droite à gauche se lit à l'envers (é29 §2.5).
    expect(masked).toHaveAttribute("dir", "ltr");
    // Aucun champ ne réaffiche la clé : le formulaire de saisie n'est pas ouvert.
    expect(screen.queryByTestId("ai-secret")).toBeNull();
  });

  it("montre le code d'erreur traduit, jamais le message du fournisseur", () => {
    status = {
      ...withKey,
      credential: {
        ...withKey.credential!,
        status: "invalid",
        hasError: true,
        lastErrorCode: "AI_KEY_INVALID",
      },
    };
    render(React.createElement(AiModeSection, { render: wrap }));
    expect(screen.getByText("ai.errKeyInvalid")).toBeInTheDocument();
  });

  it("propose de REMPLACER, jamais de « voir » la clé (R-4)", () => {
    status = withKey;
    render(React.createElement(AiModeSection, { render: wrap }));
    expect(screen.getByText("ai.replace")).toBeInTheDocument();
    expect(screen.queryByText(/ai\.(show|reveal|display)/)).toBeNull();
  });
});

/**
 * « LE PARAMÉTRAGE NE ME DONNE PAS LA MAIN, ET REMPLACER LA CLÉ NE FAIT RIEN »
 * — signalé le 2026-08-28, sur un compte dont la clé xAI était active.
 *
 * Trois défauts derrière cette phrase, et ce bloc les tient tous les trois :
 *
 *   1. le formulaire s'ouvrait HORS DE VUE. Il est monté en frère de la carte de
 *      la clé, donc après les plafonds, le panneau de dépense et l'activation
 *      par élève : mesuré sur le compte réel, bouton à 2093 px, champ de clé à
 *      4903. Rien ne bougeait à l'écran, d'où « ne fait rien » ;
 *   2. il s'ouvrait sur ANTHROPIC, jamais sur le fournisseur en place — tout
 *      était à retrouver de tête ;
 *   3. et il n'existait AUCUN moyen de changer un modèle sans recoller la clé,
 *      que R-4 rend pourtant irrécupérable.
 */
describe("la console du porteur donne la main (2026-08-28)", () => {
  const xai: AiModeStatus = {
    ...BASE,
    credential: {
      provider: "openai_compatible",
      baseUrl: "https://api.x.ai/v1",
      modelFast: "grok-4.6",
      modelRich: "grok-4.6",
      last4: "6hzw",
      status: "active",
      lastErrorCode: "AI_UNKNOWN",
      hasError: false,
      verifiedAt: "2026-08-28T09:00:00Z",
      lastUsedAt: null,
      dailyBudgetUsd: 2,
      monthlyBudgetUsd: 20,
      doubleSolve: true,
      consentStale: false,
      limitsEnforced: false,
    },
  };

  it("AMÈNE le formulaire sous les yeux au clic sur « Remplacer »", async () => {
    status = xai;
    render(React.createElement(AiModeSection, { render: wrap }));

    await userEvent.click(screen.getByText("ai.replace"));
    expect(screen.getByTestId("ai-form")).toBeInTheDocument();
    // Une frame de retard, à dessein : le nœud doit exister avant qu'on le
    // rejoigne. Sans ce défilement, le formulaire s'ouvre quatre écrans plus bas
    // et l'écran a l'air inerte.
    await new Promise((resolve) => requestAnimationFrame(resolve));
    expect(scrollIntoView).toHaveBeenCalled();
  });

  it("rouvre sur le fournisseur ET les modèles en place, pas sur une page blanche", async () => {
    status = xai;
    render(React.createElement(AiModeSection, { render: wrap }));
    await userEvent.click(screen.getByText("ai.replace"));

    expect(screen.getByTestId("ai-base-url")).toHaveValue("https://api.x.ai/v1");
    expect(screen.getByTestId("ai-model-fast")).toHaveValue("grok-4.6");
    expect(screen.getByTestId("ai-model-rich")).toHaveValue("grok-4.6");
    // La clé, elle, reste vide : c'est la seule chose que R-4 interdit de rendre.
    expect(screen.getByTestId("ai-secret")).toHaveValue("");
  });

  it("laisse changer un modèle SANS recoller la clé", async () => {
    status = xai;
    render(React.createElement(AiModeSection, { render: wrap }));

    // Désarmé tant que rien n'a bougé : ce bouton émet un appel FACTURÉ au
    // fournisseur, il ne part pas sur un simple passage dans le champ.
    expect(screen.getByTestId("ai-save-models")).toBeDisabled();

    await userEvent.clear(screen.getByTestId("ai-saved-model-fast"));
    await userEvent.type(screen.getByTestId("ai-saved-model-fast"), "grok-4-fast");
    expect(screen.getByTestId("ai-save-models")).toBeEnabled();

    // Et aucun champ de clé n'est apparu au passage : tout le point est là.
    expect(screen.queryByTestId("ai-secret")).toBeNull();
  });
});
