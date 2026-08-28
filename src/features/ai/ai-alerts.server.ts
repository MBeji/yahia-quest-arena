// Les ALERTES de budget — R-11, et surtout la partie que les seuils manquent.
//
// « Parce que ces plafonds sont larges, les alertes en pourcentage arrivent trop
// tard — 80 % de 20 $ se déclenche après 16 $ dépensés. » (R-11, conséquence de
// Q-6.) D'où DEUX mécaniques, et pas une :
//
//   (a) SEUILS de plafond mensuel — 50 / 80 / 100 %, une notification par seuil
//       et par mois. Pas par appel : un plafond atteint n'a pas à sonner cent
//       fois dans l'après-midi.
//   (b) ANOMALIE — une journée dont la dépense dépasse 3× la médiane des sept
//       précédentes (plancher 0,50 $) prévient LE JOUR MÊME. C'est elle qui
//       attrape une boucle, un abus ou un bug ; le plafond mensuel, lui,
//       n'attrape que la conséquence.
//
// LE DÉDOUBLONNAGE EST EN BASE, PAS EN MÉMOIRE
// ---------------------------------------------------------------------------
// `ai_budget_alerts` porte (porteur, type, période) en clé primaire : un
// deuxième processus, un redémarrage ou deux onglets ne peuvent pas produire une
// seconde notification. Un compteur en mémoire aurait tenu jusqu'au premier
// déploiement.
//
// ÉCART ASSUMÉ vs R-11 : l'étude dit « canal notifications existant + e-mail au
// porteur ». Le moteur n'a AUCUN transport e-mail (le mailer de Supabase Auth
// sert l'authentification, pas la messagerie produit). L'alerte part donc par le
// canal push existant, qui atteint bien l'appareil du porteur, et la console
// affiche l'état. Ajouter un e-mail supposerait d'introduire un prestataire —
// une décision qui dépasse cette étude.

import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { errorMessage } from "@/shared/lib/safe-error";
import { configureVapid, sendPushToUsers } from "@/shared/lib/push-sender.server";

type DueAlert = { kind: string; period: string; month_usd: number; day_usd: number };

/**
 * Le texte de l'alerte. Il s'adresse au PORTEUR, pas à l'élève : R-14 tient même
 * ici — un enfant dont un autre paie ne verra jamais ces montants, parce que la
 * notification part à l'identifiant du porteur, pas à celui de l'élève.
 *
 * Le montant est arrondi au centime et suivi de la mention d'estimation : R-12
 * ne s'assouplit pas parce qu'on est dans une notification courte.
 */
function alertPayload(alert: DueAlert) {
  const amount = (usd: number) => `${usd.toFixed(2)} $`;

  if (alert.kind === "anomaly") {
    return {
      title: "Dépense IA inhabituelle aujourd'hui",
      body: `Environ ${amount(alert.day_usd)} dépensés aujourd'hui, bien au-dessus de vos journées habituelles. Estimation — vérifiez chez votre fournisseur.`,
      url: "/parametrage",
      tag: "ai-budget-anomaly",
    };
  }

  const pct = alert.kind.replace("pct", "");
  return {
    title: alert.kind === "pct100" ? "Plafond IA mensuel atteint" : `Plafond IA mensuel à ${pct} %`,
    body:
      alert.kind === "pct100"
        ? `Environ ${amount(alert.month_usd)} ce mois-ci. Le mode IA est coupé jusqu'au mois prochain ou jusqu'à ce que vous releviez le plafond.`
        : `Environ ${amount(alert.month_usd)} ce mois-ci. Estimation — la facture qui fait foi est celle de votre fournisseur.`,
    url: "/parametrage",
    tag: `ai-budget-${alert.kind}`,
  };
}

/**
 * Vérifie et envoie les alertes dues pour un porteur.
 *
 * Appelée dans le chemin de requête, après un solde ou une coupure. Elle ne LÈVE
 * jamais : une alerte perdue est un désagrément, un appel IA cassé par un échec
 * de notification serait une régression.
 */
export async function notifyBudgetAlerts(ownerUserId: string): Promise<number> {
  const client = supabaseAdmin;

  const { data, error } = await client.rpc("ai_budget_alerts_due", { p_owner: ownerUserId });
  if (error) {
    logger.warn("ai.budget.alerts", { error: errorMessage(error) });
    return 0;
  }

  const due = (Array.isArray(data) ? data : []) as DueAlert[];
  if (due.length === 0) return 0;

  // VAPID absent (développement, CI) : on marque quand même l'alerte comme
  // traitée. Sans cela, chaque appel suivant la re-découvrirait et le log
  // deviendrait un bruit permanent — pour une notification que rien ne peut
  // envoyer de toute façon.
  const canPush = configureVapid();

  for (const alert of due) {
    logger.warn("ai.budget", {
      owner: ownerUserId,
      threshold: alert.kind,
      action: "warn",
      monthUsd: alert.month_usd,
      dayUsd: alert.day_usd,
    });

    if (canPush) {
      try {
        await sendPushToUsers([ownerUserId], alertPayload(alert));
      } catch (pushError) {
        logger.warn("ai.budget.push", { error: errorMessage(pushError) });
      }
    }

    const { error: markError } = await client.rpc("mark_ai_budget_alert", {
      p_owner: ownerUserId,
      p_kind: alert.kind,
      p_period: alert.period,
    });
    if (markError) logger.warn("ai.budget.mark", { error: errorMessage(markError) });
  }

  return due.length;
}
