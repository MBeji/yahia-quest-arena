// @vitest-environment node
import { describe, it, expect } from "vitest";
import { beliefGuess, beliefSlip, beliefUpdate, predictedSuccess } from "../belief-model.mjs";

/**
 * LA TABLE DE VÉRITÉ DE L'ANNEXE A — la moitié JavaScript.
 *
 * Ces nombres sont les mêmes, à la décimale près, que ceux que `supabase/tests/
 * 75_adaptive_belief.test.sql` assert sur les fonctions SQL. C'est délibéré et c'est tout
 * le dispositif anti-dérive : le port JS n'est pas « testé de son côté », il est épinglé à
 * la même table que la référence. Une dérive fait rougir l'une des deux suites.
 *
 * Les magies sont ici légitimes parce qu'elles sont DÉRIVÉES ET MONTRÉES — chaque valeur
 * est accompagnée du calcul qui la produit, à partir des seules formules du §3.2.
 *
 * ⚠️ Un écart avec l'étude, tranché en faveur du modèle : l'annexe A.1 n° 2 annonce 0,861
 * pour un `numeric` juste depuis 0,20, alors que les formules du §3.2 donnent 0,8482 (il
 * faudrait p(G) = 0,045 et non 0,05 pour obtenir 0,861). Les huit autres lignes des tables
 * A.1/A.2 se rejouent exactement. La table dérive du modèle ; là où elle le contredit, le
 * modèle fait foi.
 */
describe("Modèle de croyance — port JS (étude 30 §3.2, annexe A)", () => {
  describe("p(G) : le hasard est la géométrie de l'item (D-2)", () => {
    it("un QCM vaut 1/k, borné [0,15 ; 0,30]", () => {
      expect(beliefGuess("mcq", 2, "classic")).toBe(0.3); // 1/2 = 0,50 → plafonné
      expect(beliefGuess("mcq", 4, "classic")).toBe(0.25);
      expect(beliefGuess("mcq", 5, "classic")).toBe(0.2);
      expect(beliefGuess("mcq", 8, "classic")).toBe(0.15); // 1/8 = 0,125 → planché
      expect(beliefGuess("mcq", 20, "classic")).toBe(0.15);
    });

    it("une saisie libre n'a presque pas de hasard, et le rappel prime sur le type", () => {
      expect(beliefGuess("short_answer", null, "classic")).toBe(0.02);
      // Une `mcq` jouée de mémoire n'affiche pas ses options : son hasard n'est plus
      // celui d'un QCM. C'est ce qui fait du rappel actif un investissement diagnostique.
      expect(beliefGuess("mcq", 4, "recall")).toBe(0.02);
    });

    it("les autres types natifs ont leur propre géométrie", () => {
      expect(beliefGuess("numeric", null, "classic")).toBe(0.05);
      expect(beliefGuess("ordering", null, "classic")).toBe(0.05);
      expect(beliefGuess("matching", null, "classic")).toBe(0.05);
      expect(beliefGuess("multi", null, "classic")).toBe(0.08);
    });

    it("un type inconnu retombe sur un hasard prudent, jamais sur zéro", () => {
      // Zéro ferait d'une seule bonne réponse une preuve absolue.
      expect(beliefGuess("type-inexistant", null, "classic")).toBe(0.25);
      expect(beliefGuess(null, null, null)).toBe(0.25);
    });

    it("un QCM sans options connues est traité comme un QCM à 4 options", () => {
      expect(beliefGuess("mcq", null, "classic")).toBe(0.25);
      expect(beliefGuess("mcq", 1, "classic")).toBe(0.3); // k < 2 n'existe pas
    });
  });

  describe("p(S) : l'inattention décroît avec la difficulté (D-2)", () => {
    it("d1 0,10 → d4 0,05, défaut d2", () => {
      expect(beliefSlip(1, false)).toBe(0.1);
      expect(beliefSlip(2, false)).toBe(0.08);
      expect(beliefSlip(3, false)).toBe(0.06);
      expect(beliefSlip(4, false)).toBe(0.05);
      expect(beliefSlip(null, false)).toBe(0.08);
    });

    it("le signal de charge pousse au plafond de R-3, dans le sens indulgent", () => {
      expect(beliefSlip(4, true)).toBe(0.2);
      expect(beliefSlip(4, true)).toBeGreaterThan(beliefSlip(4, false));
      // Plafond dur : R-3 interdit d'aller au-delà de 0,20, jamais relevé par l'élève.
      expect(beliefSlip(1, true)).toBe(0.2);
    });
  });

  describe("Annexe A.1 — la même bonne réponse ne vaut pas la même chose", () => {
    const slip = beliefSlip(2, false); // 0,08
    const transit = 0.15;

    it("n° 1 · short_answer depuis 0,200 → 0,9320", () => {
      // p⁺ = 0,20×0,92 / (0,20×0,92 + 0,80×0,02) = 0,184/0,200 = 0,92
      // p' = 0,92 + 0,08×0,15 = 0,932
      expect(
        beliefUpdate(0.2, true, beliefGuess("short_answer", null, "classic"), slip, transit),
      ).toBe(0.932);
    });

    it("n° 2 · numeric depuis 0,200 → 0,8482 (l'étude annonce 0,861 : voir l'entête)", () => {
      // p⁺ = 0,184 / (0,184 + 0,80×0,05) = 0,184/0,224 = 0,821428…
      // p' = 0,821428 + 0,178571×0,15 = 0,848214 → 0,8482
      expect(beliefUpdate(0.2, true, beliefGuess("numeric", null, "classic"), slip, transit)).toBe(
        0.8482,
      );
    });

    it("n° 3 à 6 · il faut TROIS QCM à 4 options pour dépasser une seule saisie libre", () => {
      const mcq = beliefGuess("mcq", 4, "classic");
      const first = beliefUpdate(0.2, true, mcq, slip, transit);
      const second = beliefUpdate(first, true, mcq, slip, transit);
      const third = beliefUpdate(second, true, mcq, slip, transit);
      const fourth = beliefUpdate(third, true, mcq, slip, transit);

      expect(first).toBe(0.5573);
      expect(second).toBe(0.8491);
      expect(third).toBe(0.9608);
      // La 4ᵉ donne 0,9907 en modèle pur, bornée à 0,99 par R-1.
      expect(fourth).toBe(0.99);

      // Le corollaire produit, qui n'a pas été décrété mais calculé : c'est la VARIÉTÉ qui
      // porte l'information, pas la répétition.
      const oneRecall = beliefUpdate(
        0.2,
        true,
        beliefGuess("short_answer", null, "classic"),
        slip,
        transit,
      );
      expect(second).toBeLessThan(oneRecall);
      expect(third).toBeGreaterThan(oneRecall);
    });
  });

  describe("Annexe A.2 — l'erreur, et le pardon", () => {
    const mcq = beliefGuess("mcq", 4, "classic");
    const transit = 0.15;

    it("n° 7 · l'erreur d'un débutant n'apprend presque rien : 0,200 → 0,1721", () => {
      // p⁺ = 0,20×0,08 / (0,016 + 0,80×0,75) = 0,016/0,616 = 0,025974
      // p' = 0,025974 + 0,974026×0,15 = 0,172078
      expect(beliefUpdate(0.2, false, mcq, beliefSlip(2, false), transit)).toBe(0.1721);
    });

    it("n° 8 · une seule erreur fait sortir un quasi-maître de la maîtrise : 0,960 → 0,7612", () => {
      // Et c'est correct : la maîtrise se re-prouve, elle ne s'acquiert pas définitivement.
      expect(beliefUpdate(0.96, false, mcq, beliefSlip(2, false), transit)).toBe(0.7612);
    });

    it("n° 9 · sous signal de charge, le système pardonne : 0,960 → 0,8851", () => {
      // L'écart entre le n° 8 et le n° 9 est toute la différence entre « tu ne sais pas »
      // et « tu es fatigué ». Le détecteur qui lève ce drapeau est au lot 6 ; l'arithmétique
      // qui le rend utile est ici.
      const forgiven = beliefUpdate(0.96, false, mcq, beliefSlip(2, true), transit);
      expect(forgiven).toBe(0.8851);
      expect(forgiven).toBeGreaterThan(
        beliefUpdate(0.96, false, mcq, beliefSlip(2, false), transit),
      );
    });
  });

  describe("Annexe A.3 — le poids de la preuve (R-21)", () => {
    const mcq = beliefGuess("mcq", 4, "classic");
    const slip = beliefSlip(2, false);

    it("sans aide 0,5573 · paliers 1-2 ou mini-check 0,3786 · palier 3 0,2893", () => {
      expect(beliefUpdate(0.2, true, mcq, slip, 0.15, 1)).toBe(0.5573);
      expect(beliefUpdate(0.2, true, mcq, slip, 0.15, 0.5)).toBe(0.3786);
      expect(beliefUpdate(0.2, true, mcq, slip, 0.15, 0.25)).toBe(0.2893);
    });

    it("un poids nul n'apprend rien du tout — le prior est rendu intact", () => {
      expect(beliefUpdate(0.2, true, mcq, slip, 0.15, 0)).toBe(0.2);
    });
  });

  describe("Les bornes, et ce qui n'informe pas", () => {
    it("aucune séquence de réussites ne dépasse 0,99", () => {
      let high = 0.2;
      const mcq = beliefGuess("mcq", 4, "classic");
      for (let i = 0; i < 40; i += 1) {
        high = beliefUpdate(high, true, mcq, beliefSlip(2, false), 0.15);
      }
      expect(high).toBe(0.99);
    });

    it("une série d'échecs ne tombe PAS à 0,01 : p(T) impose un plancher, et il est bas", () => {
      // Ce n'est pas une borne, c'est un point fixe. BKT suppose qu'on peut apprendre EN
      // répondant (p(T)), donc chaque erreur est suivie d'une remontée de (1−p⁺)·T : la
      // croyance converge vers la valeur où la descente bayésienne et cette remontée
      // s'annulent. Avec p(T) = 0,15 (le défaut du registre), ce plancher vaut ≈ 0,168.
      const mcq = beliefGuess("mcq", 4, "classic");
      let low = 0.8;
      for (let i = 0; i < 200; i += 1)
        low = beliefUpdate(low, false, mcq, beliefSlip(2, false), 0.15);
      expect(low).toBeCloseTo(0.168, 2);

      // ⚠️ LE PLANCHER SUIT p(T), ET C'EST CE QUI REND `p_transit` DANGEREUX À ÉCRIRE
      // HAUT : ≈ 1,12 × p(T). R-5 déclare une LACUNE à p_known ≤ 0,25, donc au-delà de
      // p(T) ≈ 0,22 le plancher passe AU-DESSUS du seuil et la lacune devient
      // INDÉTECTABLE sur cette compétence — quel que soit le nombre d'erreurs.
      // Voici le danger, gardé comme justification de la borne :
      let ecrase = 0.8;
      for (let i = 0; i < 200; i += 1)
        ecrase = beliefUpdate(ecrase, false, mcq, beliefSlip(2, false), 0.4);
      expect(ecrase).toBeGreaterThan(0.25);
    });

    it("la borne du registre (0,18) SUFFIT : à son maximum, une lacune reste détectable", () => {
      // privé#247 item 2, tranché le 2026-09-01 : le CHECK de `competencies.p_transit`
      // est passé de 0,40 à 0,18 (migration `20260901200000`). Ce test est ce qui rend
      // les deux nombres solidaires — sinon rien n'empêche un futur élargissement du
      // CHECK de rallumer le défaut en silence. Il échoue si l'un bouge sans l'autre.
      const mcq = beliefGuess("mcq", 4, "classic");
      const GAP_THRESHOLD = 0.25; // R-5
      const P_TRANSIT_MAX = 0.18; // CHECK du registre
      let low = 0.8;
      for (let i = 0; i < 200; i += 1)
        low = beliefUpdate(low, false, mcq, beliefSlip(2, false), P_TRANSIT_MAX);
      expect(low).toBeCloseTo(0.202, 2);
      expect(low).toBeLessThan(GAP_THRESHOLD);
    });

    it("un item dégénéré ne fabrique pas d'information", () => {
      // p(G) = 1 : tout le monde tombe juste. Une bonne réponse n'apprend alors rien —
      // le dénominateur s'annule et la croyance est rendue telle quelle.
      expect(beliefUpdate(0.01, false, 1, 0, 0.15)).toBe(0.01);
    });
  });

  describe("Annexe A.5 — P(réussite), ce que le système annonce avant de servir", () => {
    it("à croyance égale, un QCM est TOUJOURS plus facile qu'une saisie libre, de p(G)", () => {
      const mcq = beliefGuess("mcq", 4, "classic");
      const free = beliefGuess("short_answer", null, "classic");
      const slip = beliefSlip(2, false);
      expect(predictedSuccess(0.2, mcq, slip)).toBe(0.384);
      expect(predictedSuccess(0.5, mcq, slip)).toBe(0.585);
      expect(predictedSuccess(0.7, mcq, slip)).toBe(0.719);
      expect(predictedSuccess(0.2, free, slip)).toBe(0.2);
      expect(predictedSuccess(0.5, free, slip)).toBe(0.47);
      expect(predictedSuccess(0.7, free, slip)).toBe(0.65);
      // C'est pourquoi un QCM ennuie PLUS TARD qu'une saisie libre : l'écart vaut p(G).
      expect(predictedSuccess(0.7, mcq, slip) - predictedSuccess(0.7, free, slip)).toBeCloseTo(
        (1 - 0.7) * (mcq - free),
        4,
      );
    });
  });
});
