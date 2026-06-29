import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { ThemeProvider, useTheme } from "@/lib/theme";
import { isTheme, themeFromCookieHeader, DEFAULT_THEME } from "@/lib/theme/context";

function TestConsumer() {
  const { theme, setTheme } = useTheme();
  return (
    <div>
      <span data-testid="theme">{theme}</span>
      <button data-testid="set-reference" onClick={() => setTheme("reference")} />
      <button data-testid="set-light" onClick={() => setTheme("light")} />
      <button data-testid="set-dark" onClick={() => setTheme("dark")} />
    </div>
  );
}

/** jsdom persists document.cookie across tests; clear it so cookie-based theme
 *  fallback in one test doesn't leak into the next. */
function clearCookies() {
  for (const part of document.cookie.split(";")) {
    const name = part.split("=")[0]?.trim();
    if (name) document.cookie = `${name}=; path=/; max-age=0`;
  }
}

function resetThemeState() {
  localStorage.clear();
  clearCookies();
  document.documentElement.classList.remove("dark", "light", "reference");
}

describe("theme context helpers", () => {
  it("isTheme accepts only the three known themes", () => {
    expect(isTheme("dark")).toBe(true);
    expect(isTheme("light")).toBe(true);
    expect(isTheme("reference")).toBe(true);
    expect(isTheme("solarized")).toBe(false);
    expect(isTheme(null)).toBe(false);
    expect(isTheme(undefined)).toBe(false);
  });

  it("themeFromCookieHeader parses the theme cookie", () => {
    expect(themeFromCookieHeader("xp-scholars-theme=light")).toBe("light");
    expect(themeFromCookieHeader("foo=bar; xp-scholars-theme=dark; baz=1")).toBe("dark");
    expect(themeFromCookieHeader("xp-scholars-theme=reference")).toBe("reference");
  });

  it("themeFromCookieHeader falls back to the default", () => {
    expect(themeFromCookieHeader(null)).toBe(DEFAULT_THEME);
    expect(themeFromCookieHeader("")).toBe(DEFAULT_THEME);
    expect(themeFromCookieHeader("xp-scholars-theme=neon")).toBe(DEFAULT_THEME);
    expect(themeFromCookieHeader("other=value")).toBe(DEFAULT_THEME);
  });
});

describe("ThemeProvider", () => {
  beforeEach(resetThemeState);
  afterEach(resetThemeState);

  it("defaults to the reference theme", () => {
    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );
    expect(screen.getByTestId("theme").textContent).toBe("reference");
    expect(document.documentElement.classList.contains("reference")).toBe(true);
  });

  it("switches between the three themes and reflects a single <html> class", () => {
    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("set-light"));
    });
    expect(screen.getByTestId("theme").textContent).toBe("light");
    expect(document.documentElement.classList.contains("light")).toBe(true);
    expect(document.documentElement.classList.contains("reference")).toBe(false);
    expect(document.documentElement.classList.contains("dark")).toBe(false);

    act(() => {
      fireEvent.click(screen.getByTestId("set-dark"));
    });
    expect(screen.getByTestId("theme").textContent).toBe("dark");
    expect(document.documentElement.classList.contains("dark")).toBe(true);
    expect(document.documentElement.classList.contains("light")).toBe(false);

    act(() => {
      fireEvent.click(screen.getByTestId("set-reference"));
    });
    expect(screen.getByTestId("theme").textContent).toBe("reference");
    expect(document.documentElement.classList.contains("reference")).toBe(true);
    expect(document.documentElement.classList.contains("dark")).toBe(false);
  });

  it("persists the chosen theme to localStorage and cookie", () => {
    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("set-light"));
    });

    expect(localStorage.getItem("xp-scholars-theme")).toBe("light");
    expect(themeFromCookieHeader(document.cookie)).toBe("light");
  });

  it("restores the theme from localStorage on mount", () => {
    localStorage.setItem("xp-scholars-theme", "light");

    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    // Applied in the post-mount effect.
    expect(screen.getByTestId("theme").textContent).toBe("light");
    expect(document.documentElement.classList.contains("light")).toBe(true);
  });

  it("restores the theme from the cookie when localStorage is empty", () => {
    document.cookie = "xp-scholars-theme=dark; path=/";

    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    expect(screen.getByTestId("theme").textContent).toBe("dark");
  });

  it("falls back to the default for an invalid stored theme", () => {
    localStorage.setItem("xp-scholars-theme", "rainbow");

    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    expect(screen.getByTestId("theme").textContent).toBe("reference");
  });

  it("setTheme applies the requested theme directly", () => {
    render(
      <ThemeProvider>
        <TestConsumer />
      </ThemeProvider>,
    );

    act(() => {
      fireEvent.click(screen.getByTestId("set-dark"));
    });
    expect(screen.getByTestId("theme").textContent).toBe("dark");

    act(() => {
      fireEvent.click(screen.getByTestId("set-reference"));
    });
    expect(screen.getByTestId("theme").textContent).toBe("reference");
  });
});
