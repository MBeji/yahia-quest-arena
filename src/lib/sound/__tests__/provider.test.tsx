import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { render, screen, fireEvent, act } from "@testing-library/react";
import { SoundProvider } from "../provider";
import { useSound } from "../hooks";
import { SOUND_STORAGE_KEY, soundEnabledFromStored, DEFAULT_SOUND_ENABLED } from "../context";
import { playSound, unlockAudio } from "../engine";

vi.mock("../engine", () => ({
  playSound: vi.fn(),
  unlockAudio: vi.fn(),
}));

function Consumer() {
  const { enabled, setEnabled, play } = useSound();
  return (
    <div>
      <span data-testid="enabled">{enabled ? "on" : "off"}</span>
      <button onClick={() => play("victory")}>play</button>
      <button onClick={() => setEnabled(false)}>turn-off</button>
      <button onClick={() => setEnabled(true)}>turn-on</button>
    </div>
  );
}

function renderProvider() {
  return render(
    <SoundProvider>
      <Consumer />
    </SoundProvider>,
  );
}

beforeEach(() => {
  localStorage.clear();
  vi.mocked(playSound).mockClear();
  vi.mocked(unlockAudio).mockClear();
});

afterEach(() => {
  localStorage.clear();
});

describe("soundEnabledFromStored", () => {
  it("parses persisted values and defaults on unknown input", () => {
    expect(soundEnabledFromStored("on")).toBe(true);
    expect(soundEnabledFromStored("off")).toBe(false);
    expect(soundEnabledFromStored(null)).toBe(DEFAULT_SOUND_ENABLED);
    expect(soundEnabledFromStored("garbage")).toBe(DEFAULT_SOUND_ENABLED);
  });
});

describe("SoundProvider", () => {
  it("defaults to enabled when nothing is stored", () => {
    renderProvider();
    expect(screen.getByTestId("enabled")).toHaveTextContent("on");
  });

  it("applies the persisted 'off' preference on mount", () => {
    localStorage.setItem(SOUND_STORAGE_KEY, "off");
    renderProvider();
    expect(screen.getByTestId("enabled")).toHaveTextContent("off");
  });

  it("plays effects when enabled", () => {
    renderProvider();
    fireEvent.click(screen.getByText("play"));
    expect(playSound).toHaveBeenCalledWith("victory");
  });

  it("does not play effects when disabled", () => {
    renderProvider();
    act(() => {
      fireEvent.click(screen.getByText("turn-off"));
    });
    vi.mocked(playSound).mockClear();
    fireEvent.click(screen.getByText("play"));
    expect(playSound).not.toHaveBeenCalled();
  });

  it("persists the preference to localStorage", () => {
    renderProvider();
    act(() => {
      fireEvent.click(screen.getByText("turn-off"));
    });
    expect(localStorage.getItem(SOUND_STORAGE_KEY)).toBe("off");
    act(() => {
      fireEvent.click(screen.getByText("turn-on"));
    });
    expect(localStorage.getItem(SOUND_STORAGE_KEY)).toBe("on");
  });

  it("primes audio when sound is switched on", () => {
    renderProvider();
    act(() => {
      fireEvent.click(screen.getByText("turn-on"));
    });
    expect(unlockAudio).toHaveBeenCalled();
  });
});
