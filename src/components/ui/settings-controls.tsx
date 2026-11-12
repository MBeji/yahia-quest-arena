import { useId, type KeyboardEvent, type ReactNode } from "react";
import { Moon, Music, Sun, Volume2 } from "lucide-react";
import type { LucideIcon } from "lucide-react";

import { useI18n, useT, type Locale } from "@/lib/i18n";
import { useTheme, THEMES, type Theme } from "@/lib/theme";
import { useSound, playSound } from "@/lib/sound";
import { Switch } from "@/components/ui/switch";

/**
 * Les contrôles de réglage eux-mêmes, sans chrome — partagés par le menu de
 * l'engrenage (`<SettingsMenu/>`) et par la page-pôle `/parametrage`.
 *
 * L'arbitrage « menu rapide + page » impose que les deux surfaces montrent les
 * mêmes bascules ; les faire vivre ici garantit qu'elles restent le MÊME
 * contrôle, pas deux implémentations qui divergeront. C'est ce qui manquait
 * avant : `language-switcher`, `theme-switcher` et `sound-switcher` étaient trois
 * composants au chrome recopié, chacun avec son état d'ouverture et son écouteur
 * de clic-dehors.
 */

const THEME_ICONS: Record<Theme, LucideIcon> = { reference: Sun, dark: Moon };

/** La liste des locales, source unique — le `LanguageSwitcher` des écrans sans
 * header (connexion, réinitialisation, onboarding) la partage. */
export const LOCALES: { code: Locale; label: string; short: string }[] = [
  { code: "en", label: "English", short: "EN" },
  { code: "fr", label: "Français", short: "FR" },
  { code: "ar", label: "العربية", short: "AR" },
];

/**
 * Un bouton d'un choix segmenté — actif = plein, sinon discret.
 *
 * C'est un `radio` dans un `radiogroup`, pas un `menuitemradio` : ces contrôles
 * vivent aussi sur la page `/parametrage`, hors de tout menu, où un
 * `menuitemradio` est un rôle orphelin (axe `aria-required-parent`). Le groupe
 * porte donc tout le contrat du motif : un seul arrêt de tabulation (le choix
 * actif), et les flèches déplacent le choix.
 */
function Choice({
  active,
  onClick,
  label,
  children,
}: {
  active: boolean;
  onClick: () => void;
  label: string;
  children: ReactNode;
}) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={active}
      aria-label={label}
      tabIndex={active ? 0 : -1}
      onClick={onClick}
      className={`flex min-h-11 flex-1 items-center justify-center gap-1.5 rounded-lg px-2 py-1.5 text-xs font-bold transition ${
        active
          ? "bg-[color:var(--gold)]/15 text-[color:var(--gold)]"
          : "text-muted-foreground hover:bg-accent hover:text-foreground"
      }`}
    >
      {children}
    </button>
  );
}

const NEXT_KEYS = ["ArrowRight", "ArrowDown"];
const PREVIOUS_KEYS = ["ArrowLeft", "ArrowUp"];

/** Les flèches d'un `radiogroup` : elles déplacent le focus ET le choix, en boucle.
 * En arabe la rangée est en miroir, donc gauche/droite s'inversent ; haut/bas non. */
function onRadioGroupKeyDown(event: KeyboardEvent<HTMLDivElement>) {
  const radios = Array.from(
    event.currentTarget.querySelectorAll<HTMLButtonElement>('[role="radio"]'),
  );
  const current = radios.indexOf(document.activeElement as HTMLButtonElement);
  if (current === -1) return;
  const rtl = getComputedStyle(event.currentTarget).direction === "rtl";
  const key =
    rtl && event.key === "ArrowLeft"
      ? "ArrowRight"
      : rtl && event.key === "ArrowRight"
        ? "ArrowLeft"
        : event.key;
  const step = NEXT_KEYS.includes(key) ? 1 : PREVIOUS_KEYS.includes(key) ? -1 : 0;
  if (step === 0) return;
  event.preventDefault();
  const next = radios[(current + step + radios.length) % radios.length];
  next.focus();
  next.click();
}

/** Intitulé + rangée de choix. L'intitulé visible nomme le groupe. */
function Field({ label, children }: { label: string; children: ReactNode }) {
  const labelId = useId();
  return (
    <div className="py-1.5">
      <div id={labelId} className="mb-1 text-xs text-muted-foreground">
        {label}
      </div>
      <div
        role="radiogroup"
        aria-labelledby={labelId}
        onKeyDown={onRadioGroupKeyDown}
        className="flex gap-1"
      >
        {children}
      </div>
    </div>
  );
}

/** Choix du thème (Clair « Référence » / Sombre « Noir & Or », étude 14 Q-1). */
export function ThemeChoice() {
  const t = useT();
  const { theme, setTheme } = useTheme();
  return (
    <Field label={t.theme.label}>
      {THEMES.map((value) => {
        const Icon = THEME_ICONS[value];
        return (
          <Choice
            key={value}
            active={value === theme}
            onClick={() => setTheme(value)}
            label={t.theme[value]}
          >
            <Icon className="h-3.5 w-3.5 shrink-0" />
            <span>{t.theme[value]}</span>
          </Choice>
        );
      })}
    </Field>
  );
}

/** Choix de la langue d'interface — change aussi la direction du document (AR ⇒ RTL). */
export function LocaleChoice() {
  const t = useT();
  const { locale, setLocale } = useI18n();
  return (
    <Field label={t.settings.languageLabel}>
      {LOCALES.map((l) => (
        <Choice
          key={l.code}
          active={l.code === locale}
          onClick={() => setLocale(l.code)}
          label={l.label}
        >
          {l.short}
        </Choice>
      ))}
    </Field>
  );
}

/** Une bascule à interrupteur. */
function Toggle({
  Icon,
  label,
  checked,
  onCheckedChange,
}: {
  Icon: LucideIcon;
  label: string;
  checked: boolean;
  onCheckedChange: (next: boolean) => void;
}) {
  return (
    <label className="flex min-h-11 cursor-pointer items-center justify-between gap-3 rounded-lg px-2 py-2 text-sm hover:bg-accent">
      <span className="flex items-center gap-2.5 text-foreground">
        <Icon className="h-4 w-4 shrink-0" />
        {label}
      </span>
      <Switch checked={checked} onCheckedChange={onCheckedChange} aria-label={label} />
    </label>
  );
}

/** Effets sonores + musique d'ambiance, indépendants l'un de l'autre. */
export function SoundToggles() {
  const t = useT();
  const { enabled, setEnabled, musicEnabled, setMusicEnabled } = useSound();
  return (
    <>
      <Toggle
        Icon={Volume2}
        label={t.sound.effects}
        checked={enabled}
        onCheckedChange={(next) => {
          setEnabled(next);
          // Activer les effets les fait entendre tout de suite : une bascule
          // muette laisse croire qu'elle n'a rien fait.
          if (next) playSound("coin");
        }}
      />
      <Toggle
        Icon={Music}
        label={t.sound.music}
        checked={musicEnabled}
        onCheckedChange={setMusicEnabled}
      />
    </>
  );
}
