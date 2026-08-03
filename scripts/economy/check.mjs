/**
 * `npm run economy:check` — rejoue les trois personas et confronte les garde-fous.
 *
 * Sortie LISIBLE d'abord (le tableau par semaine), verdict ensuite : c'est le
 * tableau qu'on lit pour comprendre, pas le code de sortie. La règle R-4 demande
 * de joindre cette sortie AVANT/APRÈS à toute PR qui touche `gamification.ts` —
 * ce qui n'a d'intérêt que si elle se compare d'un coup d'œil.
 *
 * Hors `verify` / `ci:verify` (D-4) : garde-fou d'équilibrage, pas test de code.
 */

import { exit, stdout } from "node:process";

import { PERSONAS, simulate } from "./simulate.mjs";
import { checkGuardrails } from "./assertions.mjs";

const pad = (v, n) => String(v).padStart(n);

const runs = {};
for (const name of Object.keys(PERSONAS)) {
  runs[name] = simulate(name);
}

for (const [name, run] of Object.entries(runs)) {
  const p = PERSONAS[name];
  stdout.write(
    `\n${name.toUpperCase()} — ${p.daysPerWeek} j/7, ${p.exercisesPerDay} ex/j, ${p.successPct} % de réussite\n`,
  );
  stdout.write("  sem   XP total   niv   coins\n");
  for (const w of run.weeks) {
    stdout.write(
      `  ${pad(w.week, 3)}   ${pad(w.xpTotal, 8)}   ${pad(w.level, 3)}   ${pad(w.coinsEarned, 5)}\n`,
    );
  }
  stdout.write(
    `  → ${run.daysActive} jours actifs, ${run.daysMissed} manqués · pic ${run.maxXpInADay} XP/jour` +
      `${run.levelFiveDay ? ` · niveau 5 au jour ${run.levelFiveDay}` : " · niveau 5 non atteint"}\n`,
  );
}

const results = checkGuardrails(runs);
stdout.write("\nGarde-fous (é09 Q-1 / A9) — hypothèses de départ, pas des vérités mesurées :\n");
let failed = 0;
for (const r of results) {
  stdout.write(`  ${r.ok ? "✓" : "✗"} ${r.id} — ${r.message}\n`);
  if (!r.ok) failed++;
}

if (failed > 0) {
  stdout.write(
    `\n${failed} garde-fou(s) en échec.\n` +
      "⚠️ Avant de toucher `gamification.ts` : demande-toi si c'est le SEUIL qui a tort.\n" +
      "Ils ont été ratifiés comme point de départ, à corriger après lecture de la page\n" +
      "Économie. Régler l'économie pour faire passer un test, c'est régler l'outil.\n",
  );
  exit(1);
}

stdout.write("\nTous les garde-fous tiennent.\n");
