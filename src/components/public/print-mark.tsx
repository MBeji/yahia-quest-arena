import { useT } from "@/lib/i18n";

/**
 * Marques de propriété intellectuelle à l'impression des pages publiques (Couche
 * 3 du plan). Masquées à l'écran (`hidden`), révélées par les règles
 * `@media print` de styles.css : un filigrane de marque diagonal + un pied
 * copyright/IP. Couvre le « téléchargement » réel = Ctrl+P → Enregistrer en PDF.
 * Copie i18n (fr/en/ar).
 */
export function PrintMark() {
  const t = useT();
  const year = new Date().getFullYear();
  return (
    <>
      <div aria-hidden="true" className="print-watermark hidden">
        Na9ra Nal3ab
      </div>
      <div className="print-copyright hidden">
        © {year} Na9ra Nal3ab — {t.public.print.copyrightNotice}
      </div>
    </>
  );
}
