// Feature: Auth (login, signup, guest access, session)
// Public API — import from "@/features/auth"

export { useAuth } from "./use-auth";
export { getGuestSignInErrorMessage, signInGuestUser, GUEST_ACCESS_COPY } from "./guest-access";
export { bootstrapProfile } from "./auth.server";
