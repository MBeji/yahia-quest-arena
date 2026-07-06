import { Volume2, VolumeX } from "lucide-react";
import { useSound, playSound } from "@/lib/sound";
import { useT } from "@/lib/i18n";

/**
 * Sound-effects toggle — a single on/off button shown in the authenticated header
 * next to the theme and language pickers (mirrors their chrome). Turning sound ON
 * plays a short coin cue as immediate confirmation.
 */
export function SoundSwitcher({ className = "" }: { className?: string }) {
  const { enabled, setEnabled } = useSound();
  const t = useT();
  const Icon = enabled ? Volume2 : VolumeX;
  const label = enabled ? t.sound.disable : t.sound.enable;

  return (
    <button
      type="button"
      onClick={() => {
        const next = !enabled;
        setEnabled(next);
        // Play the confirmation directly: setEnabled primes the context, but the
        // context `play` is still gated on the pre-toggle (disabled) state this render.
        if (next) playSound("coin");
      }}
      className={`flex min-h-11 min-w-11 items-center justify-center gap-1.5 rounded-md border border-border/50 bg-background/50 px-2 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground ${className}`}
      aria-label={label}
      aria-pressed={enabled}
      title={label}
    >
      <Icon className="h-3.5 w-3.5" />
    </button>
  );
}
