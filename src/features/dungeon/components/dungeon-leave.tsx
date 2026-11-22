import { useState } from "react";
import { ArrowLeft } from "lucide-react";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useT } from "@/lib/i18n";

/**
 * QUITTER UNE DESCENTE EN COURS (audit de navigation du 2026-11-21, N-12 · arbitrage Q-6).
 *
 * « Quitter le donjon » était un simple lien vers le Hall. Or les gains ne sont crédités qu'à la
 * finalisation de la partie, et le quota du jour compte les parties CRÉÉES : quitter à l'étage 9
 * perdait les XP et une partie. Le propriétaire a tranché : on confirme, et la partie est
 * finalisée à la sortie — l'élève encaisse ce qu'il a franchi, puis voit son bilan.
 */
export function DungeonLeaveButton({ onConfirm }: { onConfirm: () => void }) {
  const t = useT();
  const [open, setOpen] = useState(false);
  return (
    <>
      <button
        type="button"
        data-testid="dungeon-leave"
        onClick={() => setOpen(true)}
        className="inline-flex min-h-11 items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" aria-hidden />
        {t.dungeon.leaveDungeon}
      </button>
      <AlertDialog open={open} onOpenChange={setOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>{t.dungeon.leaveTitle}</AlertDialogTitle>
            <AlertDialogDescription>{t.dungeon.leaveBody}</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel data-testid="dungeon-leave-cancel">
              {t.dungeon.leaveCancel}
            </AlertDialogCancel>
            <AlertDialogAction data-testid="dungeon-leave-confirm" onClick={onConfirm}>
              {t.dungeon.leaveConfirm}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
