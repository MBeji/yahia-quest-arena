import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock("../beta-access.server", () => ({
  getMyBetaRequest: vi.fn(),
  requestBetaAccess: vi.fn(),
}));

import { getMyBetaRequest } from "../beta-access.server";
import { BetaAccessRequest } from "../components/beta-access-request";

const mockGetMine = getMyBetaRequest as unknown as ReturnType<typeof vi.fn>;

function renderWithClient(ui: React.ReactElement) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(<QueryClientProvider client={qc}>{ui}</QueryClientProvider>);
}

describe("BetaAccessRequest", () => {
  beforeEach(() => mockGetMine.mockReset());

  it("shows the request CTA when the user has no request", async () => {
    mockGetMine.mockResolvedValue(null);
    renderWithClient(<BetaAccessRequest />);
    await waitFor(() => expect(screen.getByText(/Request free access/i)).toBeInTheDocument());
  });

  it("opens the form (name/email fields) when the CTA is clicked", async () => {
    mockGetMine.mockResolvedValue(null);
    renderWithClient(<BetaAccessRequest />);
    const cta = await screen.findByText(/Request free access/i);
    fireEvent.click(cta);
    expect(screen.getByText(/^Name$/)).toBeInTheDocument();
    expect(screen.getByText(/^Email$/)).toBeInTheDocument();
  });

  it("shows the pending status (not the form) when a request already exists", async () => {
    mockGetMine.mockResolvedValue({
      id: "r1",
      name: "Yahia",
      email: "y@example.com",
      motivation: null,
      status: "pending",
      createdAt: "2026-06-03T00:00:00Z",
      reviewedAt: null,
    });
    renderWithClient(<BetaAccessRequest />);
    await waitFor(() => expect(screen.getByText("Pending")).toBeInTheDocument());
    expect(screen.queryByText(/Request free access/i)).not.toBeInTheDocument();
  });
});
