import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/** Detect if text starts with Arabic/RTL characters */
export function isRtlText(text: string): boolean {
  const normalized = text.trimStart().replace(/^[^\p{Script=Arabic}\p{Number}\p{Letter}]*/u, "");
  return /^\p{Script=Arabic}/u.test(normalized);
}

/** Detect if text is a math equation (numbers, operators, variables — should stay LTR) */
export function isMathExpression(text: string): boolean {
  return /^[\s0-9a-zA-Z+\-*/=²³√×÷(){}[\]<>≤≥≠±∞π.,;:|^_%°]+$/.test(text.trim());
}

/** Returns dir="rtl" props if text is Arabic */
export function rtlProps(text: string) {
  return isRtlText(text) ? { dir: "rtl" as const, className: "text-right" } : {};
}
