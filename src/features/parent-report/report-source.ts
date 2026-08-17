/**
 * D'où l'écran de suivi tire ses données. Deux chemins, un seul tableau de bord :
 *
 *   * `student` — parent connecté et lié à l'élève (`/parent-report`) ;
 *   * `code`    — porteur du code alliance, sans compte (`/suivi`).
 *
 * Ce type ne décide d'AUCUN droit : il choisit seulement quelle RPC appeler. Le
 * contrôle d'accès est entièrement côté serveur — lien famille vérifié pour la
 * première, décodage du code et « c'est bien un élève » pour la seconde.
 *
 * Module à part, et non exporté depuis un composant : le tableau de bord et le
 * dialogue de détail en dépendent tous les deux, et le premier monte le second.
 */
export type ReportSource =
  { kind: "student"; studentId: string } | { kind: "code"; studentCode: string };

/** L'identité de la source — sert de segment de clé de cache. */
export function reportSourceKey(source: ReportSource): string {
  return source.kind === "student" ? source.studentId : source.studentCode;
}
