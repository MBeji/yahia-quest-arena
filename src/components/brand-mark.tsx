/**
 * La marque de Na9ra Nal3ab : une COURONNE.
 *
 * Elle existait déjà partout où l'application se montre HORS de l'interface —
 * `public/favicon.svg`, les trois icônes PWA (`public/icons/*.png`) et la page
 * hors-ligne dessinent tous la même couronne dorée. L'interface, elle, affichait
 * une `Sparkles` de lucide : l'application ne portait nulle part son propre logo,
 * et l'onglet du navigateur ne ressemblait pas à l'en-tête qu'il ouvrait.
 *
 * Le tracé est donc RECOPIÉ À L'IDENTIQUE de `public/favicon.svg` — une seule
 * couronne dans le produit, jamais deux silhouettes à faire diverger.
 *
 * ⚠️ Le `viewBox` est serré sur la boîte englobante du tracé (x 100→412,
 * y 171→398), pas sur le carré de 512 de l'original : ces marges sont celles
 * d'une icône d'application, et gardées ici la couronne n'occuperait qu'un tiers
 * d'un emplacement `h-5 w-5`. Toucher au tracé sans recalculer cette boîte
 * rogne le dessin en silence.
 *
 * Aucune couleur n'est codée ici : l'encre vient de `currentColor` (donc du
 * `text-…` de l'appelant) et la lueur du conteneur (`shadow-gold`), comme pour
 * l'icône lucide qu'elle remplace.
 */
export function CrownMark({ className }: { className?: string }) {
  return (
    <svg
      data-testid="brand-crown"
      viewBox="100 171 312 227"
      xmlns="http://www.w3.org/2000/svg"
      fill="currentColor"
      aria-hidden="true"
      focusable="false"
      className={className}
    >
      <path d="M120 348 L120 250 L180 300 L256 198 L332 300 L392 250 L392 348 Z" />
      <rect x="120" y="356" width="272" height="42" rx="10" />
      <circle cx="120" cy="250" r="20" />
      <circle cx="256" cy="193" r="22" />
      <circle cx="392" cy="250" r="20" />
    </svg>
  );
}
