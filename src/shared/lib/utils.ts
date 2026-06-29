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

/**
 * Detect if text is a pure math/scientific expression (numbers, operators, set &
 * interval notation, units — no Arabic/Latin prose) that must render LTR. Used to
 * force `dir="ltr"` on answer options so brackets, the true minus `−` (U+2212) and
 * separators don't get reordered by the surrounding RTL context. The char class is
 * intentionally broad — any string of these symbols is unambiguously LTR math, and
 * widening it only fixes more options (Arabic prose keeps its letters and is never
 * matched). Note the Arabic comma `،` is **deliberately excluded**: it is an Arabic
 * char that breaks the LTR run, so math notation must use `;` / `,` (see
 * `content-engine` math-and-notation.md), not `،`.
 */
export function isMathExpression(text: string): boolean {
  return /^[\s0-9a-zA-Z+\-−*/=²³¹⁰⁴⁵⁶⁷⁸⁹₀₁₂₃₄₅₆₇₈₉√×÷(){}[\]<>≤≥≠≈≡±∞π°′″.,;:|^_%∈∉⊂⊃⊆⊇∪∩∅ℝℕℤℚℂ∥⊥∠→⟶⟵⟹⟺Ωµ∆∑∏∫]+$/u.test(
    text.trim(),
  );
}

/** Returns dir="rtl" props if text is Arabic */
export function rtlProps(text: string) {
  return isRtlText(text) ? { dir: "rtl" as const, className: "text-right" } : {};
}
