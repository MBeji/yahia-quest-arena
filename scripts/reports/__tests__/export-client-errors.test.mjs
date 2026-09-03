// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  DEFAULT_WINDOW_HOURS,
  MESSAGES_FRESH_TOKEN,
  SEUILS,
  assertProdClientErrorSource,
  buildClientErrorReport,
  readWindowHours,
} from "../export-client-errors.mjs";
import { AUTH_REFUSALS } from "../../../src/shared/integrations/supabase/auth-refusals.ts";

const meta = {
  windowHours: 8,
  since: "2026-09-03T00:00:00.000Z",
  generatedAt: "2026-09-03T08:00:00.000Z",
};
const ligne = (over = {}) => ({
  id: 1,
  created_at: "2026-09-03T04:00:00.000Z",
  stage: "token-attach",
  err_message: AUTH_REFUSALS.NO_HEADER.message,
  http_status: null,
  ttl_s: 120,
  last_hidden_ms: 0,
  ...over,
});

describe("export-client-errors — la boîte noire agrégée (#938)", () => {
  it("ne dit RIEN sur une fenêtre calme — le silence est l'état normal", () => {
    // Une session qui expire est routinier. C'est la rafale qui est un incident :
    // une garde qui crie sur trois refus est une garde qu'on cesse de lire.
    const doc = buildClientErrorReport([ligne(), ligne(), ligne()], meta);
    expect(doc.total).toBe(3);
    expect(doc.alertes).toEqual([]);
  });

  it("alerte sur la RAFALE, au seuil exact", () => {
    // Message SANS reprise, pour isoler l'alerte de rafale : un refus
    // `fresh-token` répété en déclencherait une seconde, et le test ne dirait
    // plus lequel des deux seuils il mesure.
    const rafale = Array.from({ length: SEUILS.totalParFenetre }, () =>
      ligne({ err_message: AUTH_REFUSALS.MISCONFIGURED.message }),
    );
    expect(buildClientErrorReport(rafale, meta).alertes).toHaveLength(1);
    expect(buildClientErrorReport(rafale.slice(1), meta).alertes).toEqual([]);
  });

  it("les DEUX alertes se lèvent quand une rafale est faite de refus `fresh-token`", () => {
    // Cas réel de #931 : une rafale de `NO_HEADER`, que la table déclare
    // guérissable. Les deux lectures sont vraies et méritent d'être dites.
    const rafale = Array.from({ length: SEUILS.totalParFenetre }, () => ligne());
    expect(buildClientErrorReport(rafale, meta).alertes).toHaveLength(2);
  });

  it("compte à part un refus `fresh-token` qui se répète MALGRÉ la reprise", () => {
    // Le signal le plus intéressant de tous : `auth-refusals.ts` déclare que ce
    // refus se guérit d'un jeton neuf. S'il revient, c'est le CONTRAT qui est
    // faux, pas la session de l'élève — la forme exacte de #931 et #914.
    const rows = Array.from({ length: SEUILS.freshTokenParFenetre }, () =>
      ligne({ err_message: AUTH_REFUSALS.INVALID_TOKEN.message }),
    );
    const doc = buildClientErrorReport(rows, meta);
    expect(doc.freshTokenQuiSeRepete).toBe(SEUILS.freshTokenParFenetre);
    expect(doc.alertes.join(" ")).toMatch(/fresh-token/);
    // Il alerte AVANT le seuil de rafale : le seuil est plus bas, à dessein.
    expect(SEUILS.freshTokenParFenetre).toBeLessThan(SEUILS.totalParFenetre);
  });

  it("ne compte PAS comme `fresh-token` un refus que la table déclare sans reprise", () => {
    const rows = Array.from({ length: SEUILS.freshTokenParFenetre }, () =>
      ligne({ err_message: AUTH_REFUSALS.MISCONFIGURED.message }),
    );
    const doc = buildClientErrorReport(rows, meta);
    expect(doc.freshTokenQuiSeRepete).toBe(0);
    expect(doc.alertes.join(" ")).not.toMatch(/fresh-token/);
  });

  it("lit ses messages DANS `auth-refusals.ts`, jamais en dur", () => {
    // Le message n'existe qu'une fois (c'est tout l'objet de #933). Si un refus
    // change de conduite là-bas, cette garde suit sans qu'on y touche.
    const attendus = Object.values(AUTH_REFUSALS)
      .filter((r) => r.recovery === "fresh-token")
      .map((r) => r.message);
    expect(MESSAGES_FRESH_TOKEN).toEqual(attendus);
    expect(MESSAGES_FRESH_TOKEN.length).toBeGreaterThan(0);
  });

  it("ventile par `stage` et par message, du plus fréquent au moins", () => {
    const doc = buildClientErrorReport(
      [
        ligne({ stage: "outbox-flush" }),
        ligne({ stage: "outbox-flush" }),
        ligne({ stage: "token-attach" }),
      ],
      meta,
    );
    expect(Object.keys(doc.parStage)).toEqual(["outbox-flush", "token-attach"]);
    expect(doc.parStage["outbox-flush"]).toBe(2);
  });

  it("départage les hypothèses d'horloge — un jeton VALIDE refusé n'est pas une expiration", () => {
    const doc = buildClientErrorReport(
      [
        ligne({ ttl_s: 300 }), // valide et pourtant refusé → #914
        ligne({ ttl_s: -5 }), // l'appareil se savait expiré
        ligne({ ttl_s: 10, last_hidden_ms: 120_000 }), // retour de veille
      ],
      meta,
    );
    expect(doc.horloge).toEqual({ jetonValideRefuse: 1, jetonExpire: 1, retourDeVeille: 1 });
  });

  it("refuse de lire autre chose que la production", () => {
    // Un rapport bien formé de la MAUVAISE base rend la garde aveugle sans que
    // rien ne le dise — le mode de panne qui a coûté 10 jours au triage.
    expect(() => assertProdClientErrorSource("https://un-projet-test.supabase.co")).toThrow(
      /production/,
    );
  });

  it("`--window-hours` : un défaut, ou une erreur — jamais un silence", () => {
    expect(readWindowHours(["node", "x"])).toBe(DEFAULT_WINDOW_HOURS);
    expect(readWindowHours(["node", "x", "--window-hours", "8"])).toBe(8);
    expect(() => readWindowHours(["node", "x", "--window-hours", "huit"])).toThrow();
    expect(() => readWindowHours(["node", "x", "--window-hours", "0"])).toThrow();
  });
});
