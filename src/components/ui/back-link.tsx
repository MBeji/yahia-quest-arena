import * as React from "react";
import { createLink, type LinkComponent } from "@tanstack/react-router";
import { ArrowLeft } from "lucide-react";
import { cn } from "@/shared/lib/utils";

/**
 * The single back-navigation idiom (étude 14, D-2) — replaces the seven inline
 * copies the audit found (divergent margins, missing RTL flips). Built with
 * `createLink` so router typing (`to`, `params`) flows through intact.
 * Spacing under the link belongs to the page (override via `className`);
 * the default carries the common `mb-6`.
 */
const BackLinkBase = React.forwardRef<HTMLAnchorElement, React.ComponentPropsWithoutRef<"a">>(
  ({ className, children, ...props }, ref) => (
    <a
      ref={ref}
      {...props}
      className={cn(
        "mb-6 inline-flex min-h-11 items-center gap-1.5 text-sm text-muted-foreground transition hover:text-foreground",
        className,
      )}
    >
      <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" aria-hidden />
      {children}
    </a>
  ),
);
BackLinkBase.displayName = "BackLinkBase";

const CreatedBackLink = createLink(BackLinkBase);

export const BackLink: LinkComponent<typeof BackLinkBase> = (props) => (
  <CreatedBackLink {...props} />
);
