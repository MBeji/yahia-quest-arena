// BACKWARD COMPAT — barrel re-export for all gamification features.
// New code should import from specific features:
//   @/features/dashboard
//   @/features/shop
//   @/features/quest
//   @/features/progression
export * from "@/features/dashboard/dashboard.server";
export * from "@/features/shop/shop.server";
export * from "@/features/quest/quest.server";
export * from "@/features/progression/progression.server";
