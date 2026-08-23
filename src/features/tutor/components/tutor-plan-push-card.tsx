// L'OPT-IN DU RAPPEL — étude 11 lot 2, US-7.
//
// « Notification push optionnelle : 1/jour max. » Les deux mots comptent :
// OPTIONNELLE — le défaut est éteint en base, et un rappel non demandé est une
// notification de trop ; 1/JOUR MAX — le cron ne tourne qu'une fois, et il
// exclut ceux qui reçoivent déjà le rappel de série. La promesse est tenue par
// la sélection d'audience, pas par une phrase.
//
// Le contrôle se cache tout seul quand le push n'est pas armé sur cet appareil :
// proposer un rappel qui ne peut pas arriver ferait cocher un interrupteur qui
// n'allume rien — la faute exacte que é29 a corrigée sur les surfaces IA (#813).

import { useEffect, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { GraduationCap } from "lucide-react";

import { Switch } from "@/components/ui/switch";
import { useT } from "@/lib/i18n";
import { getTutorPrefs, setTutorPlanPush } from "../tutor.server";

export function TutorPlanPushCard({
  /**
   * L'état du push sur CET appareil. `false` ⇒ le contrôle ne s'affiche pas :
   * la permission navigateur est un prérequis, pas une option de plus. La route
   * le passe parce qu'il appartient à la feature `notifications`, et qu'une
   * feature n'en importe pas une autre.
   */
  pushReady,
}: {
  pushReady: boolean;
}) {
  const t = useT();
  const load = useServerFn(getTutorPrefs);
  const save = useServerFn(setTutorPlanPush);
  const { data: prefs } = useQuery({
    queryKey: ["tutor-prefs"],
    queryFn: () => load({}),
    enabled: pushReady,
  });
  const [enabled, setEnabled] = useState(false);
  const [busy, setBusy] = useState(false);

  // Le réglage enregistré prend la main dès qu'il arrive. `useState` seul
  // resterait bloqué sur son initialisation : la requête est postérieure au
  // premier rendu.
  useEffect(() => {
    if (prefs) setEnabled(prefs.planPush);
  }, [prefs]);

  if (!pushReady) return null;

  async function toggle(next: boolean) {
    // Optimiste, puis corrigé : l'écran suit le doigt, et un échec revient en
    // arrière plutôt que de laisser croire à un réglage enregistré.
    setEnabled(next);
    setBusy(true);
    const result = await save({ data: { enabled: next } });
    if (!result.ok) setEnabled(!next);
    setBusy(false);
  }

  return (
    <div className="border-border mt-4 flex items-start gap-3 rounded-2xl border p-4">
      <div className="bg-[color:var(--gold)]/10 flex size-10 shrink-0 items-center justify-center rounded-xl text-[color:var(--gold)]">
        <GraduationCap className="size-5" aria-hidden="true" />
      </div>
      <div className="flex-1">
        <h3 className="text-sm font-bold">{t.tutor.planPushTitle}</h3>
        <p className="text-muted-foreground mt-0.5 text-xs">{t.tutor.planPushDesc}</p>
      </div>
      <Switch
        checked={enabled}
        disabled={busy}
        onCheckedChange={(next) => void toggle(next)}
        aria-label={t.tutor.planPushTitle}
      />
    </div>
  );
}
