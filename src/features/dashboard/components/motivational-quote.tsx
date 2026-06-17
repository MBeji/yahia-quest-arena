import { useT } from "@/lib/i18n";

/** Daily rotating motivational quote on the dashboard (indexed by day of month). */
export function MotivationalQuote() {
  const t = useT();
  const dayIndex = new Date().getDate() % t.quotes.length;
  const quote = t.quotes[dayIndex];

  return (
    <div className="flex flex-col justify-center rounded-2xl border border-[color:var(--gold)]/20 bg-black/40 p-5 backdrop-blur-md">
      <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--gold)] mb-3">
        {t.dashboard.quoteLabel}
      </div>
      <blockquote className="font-display text-base font-medium italic leading-relaxed">
        «&nbsp;{quote.text}&nbsp;»
      </blockquote>
      <cite className="mt-2 text-xs not-italic text-muted-foreground">— {quote.author}</cite>
    </div>
  );
}
