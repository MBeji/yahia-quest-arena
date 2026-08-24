// L'ÉTAT DU COMPTEUR D'ÉNERGIE — étude 11 lot 7 (R-12, D-14, R-15).
//
// POURQUOI UNE FONCTION PURE PLUTÔT QUE TROIS `if` DANS LE COMPOSANT
// ---------------------------------------------------------------------------
// Même motif que `coaching.ts`, `escalation.ts` et `practice.ts` : ce qui se
// DÉCIDE se teste sans rendu, sans base et sans session. Ici la décision tient
// en une ligne d'écran — offrir ou non l'échange d'un indice — mais elle engage
// un objet de l'inventaire de l'élève, gagné en jouant. Une inversion de
// condition ne casserait aucun test de rendu ; elle ferait perdre des indices à
// des enfants qui n'avaient rien à y gagner.
//
// ⚠️ CE MODULE NE RECALCULE RIEN. `left`, `max` et `canRecharge` sont produits
// par `get_tutor_energy()` (migration 20260823110000) :
//   * `left` vaut déjà GREATEST(max - used, 0) ;
//   * `max` vaut déjà LEAST(base + bonus, tutor_hard_daily_cap()) ;
//   * `canRecharge` vaut déjà (base + bonus) < tutor_hard_daily_cap().
// Les recalculer ici ferait vivre les seuils à deux endroits — la faute que R-2
// a dû réparer après avoir vu son triplet recopié à quatre endroits divergents.
// Ce module ne fait que LIRE ces nombres et en nommer l'état.
//
// D-14 EST LA CONTRAINTE DE RÉDACTION, ET ELLE DESCEND JUSQU'ICI
// ---------------------------------------------------------------------------
// L'énergie est une MÉCANIQUE DE JEU, jamais une vanne commerciale. Ce module ne
// connaît donc qu'une seule façon d'en regagner : échanger une charge d'indice
// déjà gagnée en jouant. Il n'existe aucun état « tu pourrais en avoir plus »
// qui ne soit pas cet échange — parce qu'il n'y en a pas d'autre, et qu'un état
// de plus finirait par appeler une phrase qui le suggère.

/**
 * La clé de fraîcheur du compteur, NOMMÉE ICI plutôt que dans le composant.
 *
 * Deux raisons : une surface du tuteur qui dépense de l'énergie (le panneau de
 * correction, le chat, la Forge) doit pouvoir invalider ce cache sans recopier
 * une chaîne magique ; et un module de composants qui exporte autre chose que
 * des composants casse le Fast Refresh (`react-refresh/only-export-components`).
 */
export const TUTOR_ENERGY_QUERY_KEY = ["tutor-energy"] as const;

/**
 * Ce que rend `get_tutor_energy()`, à la clé près. Le nom des champs est celui
 * du `jsonb_build_object` de la RPC : les renommer ici obligerait à un mapping
 * de plus, donc à un endroit de plus où se tromper.
 */
export type TutorEnergyReading = {
  /** Énergie déjà dépensée aujourd'hui. */
  readonly used: number;
  /** Énergie regagnée aujourd'hui par des indices échangés. */
  readonly bonus: number;
  /** Plafond du JOUR, bonus compris, déjà borné par le plafond dur. */
  readonly max: number;
  /** Ce qu'il reste — déjà calculé, jamais recalculé ici. */
  readonly left: number;
  /**
   * Le plafond dur n'est PAS atteint : un échange aurait un effet.
   *
   * ⚠️ Ce booléen ne dit PAS que l'élève possède une charge d'indice — la RPC ne
   * regarde son inventaire qu'au moment de l'échange, et rend alors `NO_ITEM`.
   * « Pas de charge » est donc un cas NORMAL du bouton, pas un bug de l'écran.
   */
  readonly canRecharge: boolean;
};

/** Le niveau de consommation. Trois mots, parce qu'ils appellent trois phrases. */
export type TutorEnergyLevel = "full" | "partial" | "empty";

/** Le plafond du jour : peut-il encore monter, ou est-il au plafond DUR ? */
export type TutorEnergyCap = "rechargeable" | "at-cap";

/**
 * L'état complet du compteur.
 *
 * POURQUOI DEUX AXES ET NON CINQ ÉTATS
 * ---------------------------------------------------------------------------
 * « Plein / entamé / vide » et « rechargeable / au plafond » ne sont pas cinq
 * cases exclusives : ils se croisent. Un élève peut être VIDE et AU PLAFOND —
 * et c'est justement la combinaison la plus délicate, la seule où l'écran n'a
 * rien à proposer. Les aplatir en une énumération de cinq obligerait à choisir
 * lequel des deux faits l'emporte, et le jour où l'on choisirait mal, l'écran
 * proposerait un échange impossible ou tairait le fait qu'il en reste un.
 */
export type TutorEnergyState =
  /** La lecture a échoué (R-15) : un état, pas une exception — et surtout pas un zéro inventé. */
  | { readonly kind: "unknown" }
  | {
      readonly kind: "known";
      readonly level: TutorEnergyLevel;
      readonly cap: TutorEnergyCap;
      /** L'écran doit-il montrer le bouton d'échange ? (voir {@link tutorEnergyState}) */
      readonly offerRecharge: boolean;
      /** Le plafond du jour a déjà été relevé par au moins un indice. */
      readonly boosted: boolean;
      readonly used: number;
      readonly left: number;
      readonly max: number;
      readonly bonus: number;
      /** Part restante, 0 → 1, pour la jauge. Jamais hors bornes. */
      readonly leftRatio: number;
    };

/**
 * L'état du compteur à partir d'une lecture — ou de son absence.
 *
 * L'ORDRE DES TESTS DE NIVEAU EST LE CONTRAT
 * ---------------------------------------------------------------------------
 * `empty` se teste AVANT `full`, et ce n'est pas un détail : un élève dont le
 * plafond du jour vaut 0 (un parent peut poser `daily_energy_max = 0`) a
 * `used = 0` ET `left = 0`. Dire « plein » à celui-là serait un mensonge que le
 * premier clic démentirait. Ce qui reste prime toujours sur ce qui a été pris.
 *
 * `offerRecharge` AJOUTE UNE CONDITION AU SERVEUR, IL N'EN RETIRE AUCUNE
 * ---------------------------------------------------------------------------
 * Le serveur dit « tu n'es pas au plafond dur » (`canRecharge`) ; l'écran ajoute
 * « et tu en as réellement besoin » (`level !== "full"`). Deux raisons :
 *
 *   1. l'échange consomme la charge POUR DE BON dès que le plafond n'est pas
 *      atteint — l'invariant anti-gaspillage de `recharge_tutor_energy()` ne
 *      protège que du plafond, pas d'un échange prématuré à 10/10 ;
 *   2. é09 (anti-farm) et la sobriété demandée au compteur : un bouton qui
 *      s'affiche en permanence finit par être cliqué pour lui-même.
 *
 * Cette condition ne peut RIEN casser : la RPC reste juge, et un élève qui
 * arrive à cliquer quand même obtient exactement ce que le serveur décide.
 */
export function tutorEnergyState(reading: TutorEnergyReading | null | undefined): TutorEnergyState {
  if (!reading) return { kind: "unknown" };

  const { used, bonus, max, left, canRecharge } = reading;

  // `<= 0` et non `=== 0` : le module est pur et se teste seul, il ne suppose
  // pas que son appelant a validé ses entrées.
  const level: TutorEnergyLevel = left <= 0 ? "empty" : used <= 0 ? "full" : "partial";

  return {
    kind: "known",
    level,
    cap: canRecharge ? "rechargeable" : "at-cap",
    offerRecharge: canRecharge && level !== "full",
    boosted: bonus > 0,
    used,
    left,
    max,
    bonus,
    // Plafond nul ⇒ rien à montrer : une jauge pleine annoncerait une réserve
    // qui n'existe pas. La division est gardée pour la même raison.
    leftRatio: max > 0 ? Math.min(Math.max(left / max, 0), 1) : 0,
  };
}

/** Les trois verdicts de `recharge_tutor_energy()`, et rien d'autre. */
export type TutorRechargeReason = "OK" | "AT_CAP" | "NO_ITEM";

/**
 * Ce que l'écran a le droit de dire après un échange. `unknown` couvre la panne
 * ET le verdict qu'on ne sait pas lire — R-15 : on dégrade, on n'invente pas.
 */
export type TutorRechargeOutcome = "recharged" | "at-cap" | "no-item" | "unknown";

/**
 * Le verdict d'un échange, lu sur le SEUL champ qui engage quelque chose.
 *
 * ⚠️ `consumed` FAIT AUTORITÉ, PAS `reason`. C'est lui — et lui seul — qui dit
 * qu'une charge d'inventaire a réellement bougé (`recharge_tutor_energy()` ne
 * joint `itemName` que dans ce cas). Lire `reason === "OK"` reviendrait à
 * annoncer « +3 » à un enfant dont l'indice n'a pas été pris le jour où un
 * refus futur porterait un autre libellé.
 *
 * Un verdict inconnu ne devient JAMAIS un gain : dans le doute, on ne promet
 * rien. Se tromper dans ce sens coûte un message vague ; se tromper dans
 * l'autre fait croire à une énergie qui n'est pas là.
 */
export function rechargeOutcome(result: {
  readonly consumed: boolean;
  readonly reason: string;
}): TutorRechargeOutcome {
  if (result.consumed) return "recharged";
  if (result.reason === "AT_CAP") return "at-cap";
  if (result.reason === "NO_ITEM") return "no-item";
  return "unknown";
}
