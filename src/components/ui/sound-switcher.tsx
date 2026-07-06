import { useEffect, useRef, useState } from "react";
import { Music, Volume2, VolumeX } from "lucide-react";
import { useSound, playSound } from "@/lib/sound";
import { Switch } from "@/components/ui/switch";
import { useT } from "@/lib/i18n";

/**
 * Sound & music control — a small dropdown (mirrors ThemeSwitcher chrome) with two
 * independent switches: gameplay **sound effects** and ambient **background
 * music**. Shown in the authenticated header. Enabling effects plays a short coin
 * cue as immediate confirmation.
 */
export function SoundSwitcher({ className = "" }: { className?: string }) {
  const { enabled, setEnabled, musicEnabled, setMusicEnabled } = useSound();
  const t = useT();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const TriggerIcon = enabled ? Volume2 : VolumeX;

  return (
    <div ref={ref} className={`relative ${className}`}>
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex min-h-11 min-w-11 items-center justify-center gap-1.5 rounded-md border border-border/50 bg-background/50 px-2 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-md transition hover:border-[color:var(--gold)]/50 hover:text-foreground"
        aria-label={t.sound.label}
        aria-haspopup="menu"
        aria-expanded={open}
      >
        <TriggerIcon className="h-3.5 w-3.5" />
      </button>
      {open && (
        <div
          role="menu"
          className="absolute end-0 top-full z-50 mt-1.5 min-w-[220px] overflow-hidden rounded-xl border border-border/60 bg-popover/95 p-2 shadow-lg backdrop-blur-xl"
        >
          <label className="flex cursor-pointer items-center justify-between gap-3 rounded-lg px-3 py-2.5 text-sm hover:bg-accent">
            <span className="flex items-center gap-2.5 text-foreground">
              <Volume2 className="h-4 w-4 shrink-0" />
              {t.sound.effects}
            </span>
            <Switch
              checked={enabled}
              onCheckedChange={(next) => {
                setEnabled(next);
                if (next) playSound("coin");
              }}
              aria-label={t.sound.effects}
            />
          </label>
          <label className="flex cursor-pointer items-center justify-between gap-3 rounded-lg px-3 py-2.5 text-sm hover:bg-accent">
            <span className="flex items-center gap-2.5 text-foreground">
              <Music className="h-4 w-4 shrink-0" />
              {t.sound.music}
            </span>
            <Switch
              checked={musicEnabled}
              onCheckedChange={setMusicEnabled}
              aria-label={t.sound.music}
            />
          </label>
        </div>
      )}
    </div>
  );
}
