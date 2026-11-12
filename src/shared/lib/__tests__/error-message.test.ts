// @vitest-environment node
import { afterEach, describe, expect, it } from "vitest";
import { onlineManager } from "@tanstack/react-query";
import { RATE_LIMITED_CODE } from "@/shared/lib/client-error-codes";
import { isNetworkFailure, userFacingError } from "@/shared/lib/error-message";

const labels = {
  sessionExpired: "Ta session a expiré.",
  errorFallback: "Une erreur est survenue.",
  offline: "Pas de réseau — réessaie quand il revient.",
  rateLimited: "Trop d'essais — patiente une minute.",
};

afterEach(() => onlineManager.setOnline(true));

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

  // --- étude 38, R-15 : l'erreur dit sa cause -------------------------------

  it("traduit le refus du limiteur, levé par le serveur sous un code stable", () => {
    expect(userFacingError(new Error(RATE_LIMITED_CODE), labels)).toBe(labels.rateLimited);
  });

  it("dit « pas de réseau » quand l'appel n'a pas atteint le serveur", () => {
    for (const message of [
      "Failed to fetch",
      "Load failed",
      "NetworkError when attempting to fetch resource.",
    ]) {
      expect(userFacingError(new TypeError(message), labels)).toBe(labels.offline);
    }
  });

  it("dit « pas de réseau » pour tout échec survenu hors connexion", () => {
    onlineManager.setOnline(false);
    expect(userFacingError(new Error("Exercise not found"), labels)).toBe(labels.offline);
    expect(isNetworkFailure("boom")).toBe(true);
  });

  it("garde la session morte et le limiteur devant le réseau : ils disent quoi faire", () => {
    onlineManager.setOnline(false);
    expect(userFacingError(new Error("Unauthorized: Invalid token"), labels)).toBe(
      labels.sessionExpired,
    );
    expect(userFacingError(new Error(RATE_LIMITED_CODE), labels)).toBe(labels.rateLimited);
  });

  it("ne prend pas une TypeError quelconque pour une panne de réseau", () => {
    expect(userFacingError(new TypeError("x is not a function"), labels)).toBe(
      "x is not a function",
    );
    expect(isNetworkFailure(new Error("Failed to fetch"))).toBe(false);
  });
});
