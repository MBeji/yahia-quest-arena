import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";

import type { CompetencyBlocker, CompetencyMasteryRow } from "@/shared/types/competency";
import { getLearningFrontier, getLearningState } from "../progression.server";
import { CompetencyMapPanel } from "./competency-map-panel";
import { FrontierCard } from "./frontier-card";
import { LearningStateMap } from "./learning-state-map";

/**
 * Les deux panneaux du tuteur déterministe, et le repli qui les rend sûrs à livrer
 * (étude 30, lot 3).
 *
 * POURQUOI UN COMPOSANT PLUTÔT QUE TROIS DANS LA ROUTE. Trois raisons, dans l'ordre où elles
 * comptent :
 *
 *  1. **Le budget de bundle.** Trois `lazy()` + deux `useQuery` dans la route poussaient le
 *     chunk eager du tableau de bord de 32,00 à 32,13 kB — au-dessus de son budget. Relever
 *     le budget aurait été affaiblir le gate pour 130 octets ; regrouper coûte moins et se
 *     lit mieux. La route ne charge plus qu'UNE porte, et tout le reste vit derrière.
 *  2. **Les deux lectures sont des requêtes CLIENT** (§3.11, clés `learning-state` et
 *     `frontier`). Elles ne partent donc qu'une fois ce module chargé — ce qui veut dire que
 *     sur une matière non taggée, le chemin SSR du tableau de bord n'est pas seulement
 *     inchangé en RÉSULTAT (R-6) mais aussi en LATENCE : rien n'est demandé, rien n'attend.
 *  3. **Le repli appartient à la progression, pas à la route.** Décider quelle carte montrer
 *     est une règle de cette feature ; la route ne devrait avoir à connaître ni les états, ni
 *     la notion de « non taggé ».
 *
 * LE REPLI, justement, n'est pas de la prudence — c'est R-6 littéral. Sur les ~88 matières non
 * taggées, `get_learning_state` rend zéro ligne, et l'élève doit alors retrouver EXACTEMENT
 * l'écran d'aujourd'hui : la carte de é07 lot 4, servie par une RPC qu'on ne touche pas (sa
 * retraite est une décision de é07 — stop-point du lot). Ce n'est donc pas « la nouvelle carte
 * ou rien », c'est « la nouvelle carte là où il y a de quoi la nourrir ».
 */
export function LearningPanels({
  map,
  blockers,
  blockedSlug,
}: {
  map: CompetencyMasteryRow[];
  blockers: CompetencyBlocker[];
  blockedSlug: string | null;
}) {
  const fetchLearningState = useServerFn(getLearningState);
  const fetchFrontier = useServerFn(getLearningFrontier);

  // Toutes familles confondues (`family: null`) : le tableau de bord n'est pas dans une
  // matière. Une erreur de lecture rend une liste vide côté server fn, donc ici le repli
  // joue — un tableau de bord ne casse pas parce qu'une carte n'a pas pu se charger.
  const { data: learningState } = useQuery({
    queryKey: ["learning-state", null],
    queryFn: () => fetchLearningState({ data: { family: null } }),
  });
  // Trois cartes, jamais une liste (é15 R-1) : c'est une proposition, pas un catalogue.
  const { data: frontier } = useQuery({
    queryKey: ["frontier", null],
    queryFn: () => fetchFrontier({ data: { family: null, limit: 3 } }),
  });

  return (
    <>
      {/* « Prêt à apprendre » AVANT la carte, et c'est délibéré : l'élève vient jouer, pas
          s'auditer. La carte d'état, en dessous, est là pour qui veut comprendre pourquoi. */}
      <FrontierCard rows={frontier ?? []} />
      {(learningState?.length ?? 0) > 0 ? (
        <LearningStateMap rows={learningState ?? []} />
      ) : (
        <CompetencyMapPanel map={map} blockers={blockers} blockedSlug={blockedSlug} />
      )}
    </>
  );
}
