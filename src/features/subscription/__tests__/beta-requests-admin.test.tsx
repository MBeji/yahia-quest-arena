import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";

vi.mock("@tanstack/react-start", () => ({ useServerFn: (fn: unknown) => fn }));
vi.mock("sonner", () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock("../beta-access.server", () => ({
  listBetaRequests: vi.fn(),
  reviewBetaRequest: vi.fn(),
}));

import { listBetaRequests, reviewBetaRequest } from "../beta-access.server";
import { BetaRequestsAdmin } from "../components/beta-requests-admin";

const mockList = listBetaRequests as unknown as ReturnType<typeof vi.fn>;
const mockReview = reviewBetaRequest as unknown as ReturnType<typeof vi.fn>;

function renderWithClient(ui: React.ReactElement) {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(<QueryClientProvider client={qc}>{ui}</QueryClientProvider>);
}

const PENDING = {
  id: "r1",
  name: "Yahia",
  email: "y@example.com",
  motivation: "I want to help test",
  status: "pending" as const,
  createdAt: "2026-06-03T00:00:00Z",
  reviewedAt: null,
};

describe("BetaRequestsAdmin", () => {
  beforeEach(() => {
    mockList.mockReset();
    mockReview.mockReset();
  });

  it("renders a pending request with approve/reject actions", async () => {
    mockList.mockResolvedValue({ requests: [PENDING] });
    renderWithClient(<BetaRequestsAdmin />);
    await waitFor(() => expect(screen.getByText("Yahia")).toBeInTheDocument());
    expect(screen.getByText("y@example.com")).toBeInTheDocument();
    expect(screen.getByText("Approve")).toBeInTheDocument();
    expect(screen.getByText("Reject")).toBeInTheDocument();
  });

  it("shows the empty state when there are no requests", async () => {
    mockList.mockResolvedValue({ requests: [] });
    renderWithClient(<BetaRequestsAdmin />);
    await waitFor(() => expect(screen.getByText("No requests yet.")).toBeInTheDocument());
  });

  it("calls reviewBetaRequest(approve) when Approve is clicked", async () => {
    mockList.mockResolvedValue({ requests: [PENDING] });
    mockReview.mockResolvedValue({ ok: true });
    renderWithClient(<BetaRequestsAdmin />);
    const approve = await screen.findByText("Approve");
    fireEvent.click(approve);
    await waitFor(() =>
      expect(mockReview).toHaveBeenCalledWith({ data: { requestId: "r1", approve: true } }),
    );
  });
});
