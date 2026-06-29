import type React from "react";
import { GraduationCap, Languages, Globe, Brain, Award } from "lucide-react";

/**
 * Shared visual tokens for the 5 root programs, used by both the hub
 * (`program-hub`) and the category page (`program-category`). Kept in its own
 * light module so the category page never imports the motion-heavy hub.
 */
export const PROGRAM_ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  GraduationCap,
  Languages,
  Globe,
  Brain,
  Award,
};

/** Map a `subject-*` color token to its CSS custom property. */
export const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;
