// LE COMPTEUR D'ÉNERGIE — étude 11 lot 7 (R-12, D-14, R-15).
//
// CE QU'IL DIT, ET LE MOT QU'IL NE DIRA JAMAIS
// ---------------------------------------------------------------------------
// D-14 : l'énergie est une MÉCANIQUE DE JEU, jamais un paywall. Les mots
// « premium », « abonnement » et « payant » sont interdits sur toute surface
// élève — et la règle va plus loin que le vocabulaire : AUCUNE formulation ne
// doit laisser croire qu'on pourrait en obtenir plus autrement qu'en jouant. Il
// n'existe donc ici qu'un seul chemin pour regagner de l'énergie, l'échange
// d'une charge d'indice gagnée dans le jeu, et pas un état de plus qui
// suggérerait une porte de sortie qui n'existe pas.
//
// R-11 : ce composant ne distribue RIEN. Ni XP, ni pièce, ni badge. Il dépense
// dans l'autre sens (une charge d'inventaire) et il l'annonce avant de le faire.
//
// POURQUOI IL SE TAIT QUAND IL NE SAIT PAS
// ---------------------------------------------------------------------------
// Une lecture ratée rend `null`, donc l'état `unknown`, donc rien à l'écran.
// C'est le choix le plus honnête pour une JAUGE : afficher « 0 » sur une panne
// dirait à l'enfant qu'il est épuisé — il refermerait l'application alors qu'il
// lui restait ses dix questions. Un message d'erreur technique à côté d'un
// compteur ne lui apprendrait rien non plus. Le silence, lui, ne ment pas
// (motif `AiSpendPanel`, é29 lot 5).
//
// LA ROUTE COMPOSE, LE COMPOSANT NE S'IMPORTE PAS AILLEURS
// ---------------------------------------------------------------------------
// Une feature n'en importe jamais une autre (AGENTS.md) : ce compteur vit dans
// `features/tutor` et c'est la ROUTE qui le place, comme `TutorGreeting` et
// `TutorPracticeEntry` avant lui.

import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Zap } from "lucide-react";

import { useT } from "@/lib/i18n";
import { TUTOR_ENERGY_PER_HINT } from "@/shared/constants/ai";
import { tutorEnergyState, TUTOR_ENERGY_QUERY_KEY, type TutorEnergyReading } from "../energy";
import {
  getTutorEnergy,
  rechargeTutorEnergy,
  type TutorRechargeResult,
} from "../tutor.energy.server";

/**
 * La phrase qui suit un échange. Les trois issues du serveur donnent trois
 * phrases DIFFÉRENTES, et c'est la partie qui compte : les deux refus ne
 * consomment rien, et l'élève doit le lire — sans quoi il croira avoir perdu
 * son indice et n'essaiera plus.
 */
function rechargeMessage(res: TutorRechargeResult, t: ReturnType<typeof useT>): string {
  const gain = String(TUTOR_ENERGY_PER_HINT);
  if (res.outcome === "recharged") {
    return res.itemName
      ? t.tutor.energy.rechargedWithItem.replace("{item}", res.itemName).replace("{n}", gain)
      : t.tutor.energy.recharged.replace("{n}", gain);
  }
  if (res.outcome === "at-cap") return t.tutor.energy.atCap;
  if (res.outcome === "no-item") return t.tutor.energy.noItem;
  return t.tutor.energy.failed;
}

export function TutorEnergyMeter() {
  const t = useT();
  const queryClient = useQueryClient();
  const fetchEnergy = useServerFn(getTutorEnergy);
  const recharge = useServerFn(rechargeTutorEnergy);
  const [message, setMessage] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const { data } = useQuery<TutorEnergyReading | null>({
    queryKey: TUTOR_ENERGY_QUERY_KEY,
    queryFn: () => fetchEnergy(),
    staleTime: 60_000,
  });

  const state = tutorEnergyState(data);
  if (state.kind === "unknown") return null;

  async function exchange() {
    setBusy(true);
    setMessage(null);
    try {
      const res = await recharge();
      setMessage(rechargeMessage(res, t));
      // On ne ré-interroge que si quelque chose a bougé : les deux refus
      // n'écrivent rien, et un aller-retour de plus ne changerait aucun chiffre.
      if (res.outcome === "recharged") {
        await queryClient.invalidateQueries({ queryKey: TUTOR_ENERGY_QUERY_KEY });
      }
    } catch {
      // R-15 : même une panne réseau est un état. Le compteur reste lisible.
      setMessage(t.tutor.energy.failed);
    } finally {
      setBusy(false);
    }
  }

  return (
    <div
      data-testid="tutor-energy"
      className="border-border bg-surface-2 mt-3 rounded-xl border p-3"
    >
      <div className="flex items-center justify-between gap-2">
        <span className="flex items-center gap-1.5 text-sm font-semibold">
          <Zap className="size-4 shrink-0 text-[color:var(--gold)]" aria-hidden="true" />
          {t.tutor.energy.title}
        </span>
        {/*
          `dir="ltr"` sur les chiffres : en arabe, « 3 / 10 » sans direction
          forcée se lit à l'envers — c'est le même réflexe que `Stat` dans la
          console admin. Le libellé, lui, suit la direction de la page.
        */}
        <span
          data-testid="tutor-energy-count"
          dir="ltr"
          className="font-display text-sm font-bold tabular-nums"
        >
          {state.left} / {state.max}
        </span>
      </div>

      {/* La jauge est décorative : les chiffres au-dessus portent l'information,
          et un lecteur d'écran n'a pas à entendre deux fois la même chose. */}
      <div className="bg-muted mt-2 h-1.5 overflow-hidden rounded-full" aria-hidden="true">
        <div
          className="h-full rounded-full bg-[color:var(--gold)] transition-[width]"
          style={{ width: `${Math.round(state.leftRatio * 100)}%` }}
        />
      </div>

      {state.level === "empty" ? (
        // Les deux clés existent depuis le lot 1 (« El Ostedh revient demain »)
        // et `degradedCopy` les sert déjà pour AI_NO_ENERGY. En écrire des
        // jumelles ici ferait diverger deux phrases qui disent la même chose.
        <div className="mt-2">
          <p className="text-sm font-medium">{t.tutor.noEnergyTitle}</p>
          <p className="text-muted-foreground text-xs">{t.tutor.noEnergyBody}</p>
        </div>
      ) : (
        <p className="text-muted-foreground mt-2 text-xs">{t.tutor.energy.hint}</p>
      )}

      {state.boosted && (
        <p className="text-muted-foreground mt-1 text-xs" data-testid="tutor-energy-bonus">
          {t.tutor.energy.bonus.replace("{n}", String(state.bonus))}
        </p>
      )}

      {/*
        Le bouton n'apparaît que si l'échange a un sens (`offerRecharge`, cf.
        `energy.ts`). Il ne PROMET pas l'échange pour autant : l'élève peut
        n'avoir aucune charge d'indice, et c'est un cas normal que le serveur
        tranche — d'où une phrase dédiée plutôt qu'un bouton grisé sans raison.
      */}
      {state.offerRecharge && (
        <button
          type="button"
          data-testid="tutor-energy-recharge"
          disabled={busy}
          onClick={() => void exchange()}
          className="border-border hover:bg-surface-3 mt-2 inline-flex items-center gap-1 self-start rounded-lg border px-2 py-1 text-xs font-bold transition disabled:opacity-50"
        >
          <Zap className="size-3" aria-hidden="true" />
          {busy
            ? t.tutor.energy.rechargeBusy
            : t.tutor.energy.rechargeCta.replace("{n}", String(TUTOR_ENERGY_PER_HINT))}
        </button>
      )}

      {message && (
        <p
          data-testid="tutor-energy-message"
          dir="auto"
          role="status"
          className="text-muted-foreground mt-1 text-xs"
        >
          {message}
        </p>
      )}
    </div>
  );
}
