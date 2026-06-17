import { useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getParcours } from "../dashboard.server";
import { flagshipConcours, type ProgramParcours } from "../program-families";
import { FlagshipBanner } from "./flagship-banner";

/**
 * Dashboard wiring for the flagship banner: pulls the (cached, shared with the
 * Découvrir hub) parcours catalogue, picks the flagship concours (6ème, 9ème),
 * and routes to the "Programme tunisien" category page on tap. Renders nothing
 * when there are no flagships — the presentational `<FlagshipBanner />` decides.
 */
export function FlagshipConcoursBanner() {
  const navigate = useNavigate();
  const fetchParcours = useServerFn(getParcours);
  const { data } = useQuery({ queryKey: ["explorer-parcours"], queryFn: () => fetchParcours() });
  const flagships = flagshipConcours((data?.parcours as ProgramParcours[]) ?? []);
  return (
    <FlagshipBanner
      flagships={flagships}
      onOpen={() => navigate({ to: "/themes/$familyId", params: { familyId: "tunisien" } })}
    />
  );
}
