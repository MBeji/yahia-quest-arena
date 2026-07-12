import { describe, it, expect } from "vitest";
import { buildErrorDebugText } from "@/shared/lib/error-debug";

describe("buildErrorDebugText", () => {
  const error = {
    name: "TypeError",
    message: "boom",
    stack: "TypeError: boom\n    at /srv/internal/module.js:42:7",
  };

  it("withholds the stack trace in production (only the error identity)", () => {
    const out = buildErrorDebugText(error, true);
    expect(out).toBe("TypeError: boom");
    expect(out).not.toContain("stack");
    expect(out).not.toContain("/srv/internal");
  });

  it("includes the stack outside production for local diagnosis", () => {
    const out = buildErrorDebugText(error, false);
    expect(out).toContain("TypeError: boom");
    expect(out).toContain("/srv/internal/module.js:42:7");
  });

  it("degrades gracefully when fields are missing", () => {
    expect(buildErrorDebugText({}, true)).toBe("Error: ");
    expect(buildErrorDebugText({ name: "E", message: "m" }, false)).toBe("E: m\n(no stack)");
  });
});
