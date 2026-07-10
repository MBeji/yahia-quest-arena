import { Link } from "@tanstack/react-router";
import { ArrowLeft } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The single back-navigation idiom (étude 14, D-2) — replaces the seven inline
 * copies the audit found (divergent margins, missing RTL flips). Spacing under
 * the link belongs to the page (pass `className="mb-6"` etc. if needed);
 * the default carries the common `mb-6`.
 */
export function BackLink({
  className,
  children,
  ...props
}: Omit<React.ComponentProps<typeof Link>, "children"> & { children?: React.ReactNode }) {
  return (
    <Link
      {...props}
      className={cn(
        "mb-6 inline-flex min-h-11 items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground",
        className,
      )}
    >
      <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" aria-hidden />
      {children}
    </Link>
  );
}
