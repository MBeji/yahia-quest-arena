import { useId } from "react";

/**
 * The site's gold crown logo (mirrors `public/favicon.svg`) as an animated emblem
 * that flags the two flagship national-concours parcours (6ème, 9ème). A slow
 * rotating gold shine (`animate-flagship-spin`) turns behind the upright crown,
 * and the emblem blinks via a pulsing glow (`animate-gold-pulse`). Both animations
 * are disabled under `prefers-reduced-motion` (global rule in styles.css). Purely
 * decorative — the host provides the accessible label. Sized by the caller
 * (e.g. `className="h-16 w-16"`).
 */
export function FlagshipCrown({ className = "" }: { className?: string }) {
  const gid = useId();
  return (
    <span className={`relative inline-grid shrink-0 place-items-center ${className}`} aria-hidden>
      {/* Rotating gold shine behind the crown — the "animation qui tourne". */}
      <span
        className="animate-flagship-spin absolute inset-[-22%] rounded-full blur-[3px]"
        style={{
          background:
            "conic-gradient(from 0deg, transparent 0deg, var(--gold) 70deg, transparent 150deg, transparent 360deg)",
        }}
      />
      {/* Pulsing glow ("clignote") + the site crown logo. */}
      <span className="animate-gold-pulse relative grid h-full w-full place-items-center rounded-[26%]">
        <svg viewBox="0 0 512 512" className="h-full w-full">
          <defs>
            <linearGradient id={gid} x1="0" y1="0" x2="1" y2="1">
              <stop offset="0" stopColor="#c9962f" />
              <stop offset="0.5" stopColor="#f7e8b0" />
              <stop offset="1" stopColor="#d4af37" />
            </linearGradient>
          </defs>
          <rect width="512" height="512" rx="104" fill="#0a0a0a" />
          <g fill={`url(#${gid})`}>
            <path d="M120 348 L120 250 L180 300 L256 198 L332 300 L392 250 L392 348 Z" />
            <rect x="120" y="356" width="272" height="42" rx="10" />
            <circle cx="120" cy="250" r="20" />
            <circle cx="256" cy="193" r="22" />
            <circle cx="392" cy="250" r="20" />
          </g>
        </svg>
      </span>
    </span>
  );
}
