const HEX32_REGEX = /^[0-9a-f]{32}$/i;

export function formatStudentAllianceCode(userId: string): string {
  const hex = userId.replace(/-/g, "").toUpperCase();
  if (!HEX32_REGEX.test(hex)) return "";
  return hex.match(/.{1,4}/g)?.join("-") ?? "";
}

export function parseStudentAllianceCode(code: string): string | null {
  const hex = code.replace(/[^a-fA-F0-9]/g, "").toLowerCase();
  if (!HEX32_REGEX.test(hex)) return null;

  const uuid = `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
  return uuid;
}
