// @vitest-environment node
import { describe, expect, it } from "vitest";
import { userFacingError } from "@/shared/lib/error-message";

const labels = {
  sessionExpired: "Ta session a expiré.",
  errorFallback: "Une erreur est survenue.",
};

describe("userFacingError", () => {
  it("traduit le seul échec dont l'élève puisse quelque chose", () => {
    // Signalé en prod : « Unauthorized: Invalid token » s'affichait tel quel au
    // milieu d'une interface arabe, à la fin d'un quiz.
    expect(userFacingError(new Error("Unauthorized: Invalid token"), labels)).toBe(
      labels.sessionExpired,
    );
  });

  it("laisse passer nos propres messages — les aplatir perdrait l'écran", () => {
    expect(userFacingError(new Error("Exercise not found"), labels)).toBe("Exercise not found");
  });

  it("retombe sur le libellé générique quand ce n'est même pas une Error", () => {
    expect(userFacingError("boom", labels)).toBe(labels.errorFallback);
    expect(userFacingError(null, labels)).toBe(labels.errorFallback);
    expect(userFacingError(undefined, labels)).toBe(labels.errorFallback);
  });

  it("ne confond pas les autres refus d'authentification avec une session morte", () => {
    // Ceux-là ne se réparent pas en se reconnectant : les nommer « session
    // expirée » enverrait l'élève tourner en rond.
    expect(userFacingError(new Error("Unauthorized: No token provided"), labels)).toBe(
      "Unauthorized: No token provided",
    );
    expect(
      userFacingError(new Error("Auth verification unavailable. Please try again."), labels),
    ).toBe("Auth verification unavailable. Please try again.");
  });
});
