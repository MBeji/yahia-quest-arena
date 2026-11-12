import { Link } from "@tanstack/react-router";
import { Compass } from "lucide-react";
import { EmptyState } from "@/components/ui/empty-state";
import { useT } from "@/lib/i18n";

/**
 * Ce que rend une adresse de contenu qui ne désigne rien (`/chapitre/<id inconnu>`,
 * `/niveau/inexistant`…) — le `notFoundComponent` des quatre pages du catalogue.
 *
 * Le loader a levé `notFound()` : la réponse part en HTTP 404, DANS la coquille
 * publique (en-tête, pied de page), avec un chemin de retour vers le catalogue
 * plutôt qu'un cul-de-sac. `noindex` double le code HTTP pour un robot qui ne
 * regarderait que le HTML (React 19 hisse la balise dans `<head>`).
 *
 * Préfixe `-` : le routeur de fichiers ignore ce module, ce n'est pas une route.
 */
export function CatalogueNotFound({ title }: { title?: string }) {
  const t = useT();
  return (
    <div className="mx-auto max-w-md px-6 py-20">
      <meta name="robots" content="noindex" />
      <EmptyState
        icon={Compass}
        title={title ?? t.errors.notFoundTitle}
        action={
          <Link
            to="/programme"
            className="inline-flex min-h-11 items-center rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
          >
            {t.public.header.programme}
          </Link>
        }
      />
    </div>
  );
}
