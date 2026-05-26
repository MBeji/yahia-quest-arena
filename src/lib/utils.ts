import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/** Detect if text starts with Arabic/RTL characters */
export function isRtlText(text: string): boolean {
  return /^[\s\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF⚔️💀🗡️🎯🔮⚡🛡️💡🏆📊🔥]/.test(text);
}

/** Returns dir="rtl" props if text is Arabic */
export function rtlProps(text: string) {
  return isRtlText(text) ? { dir: "rtl" as const, className: "text-right" } : {};
}
