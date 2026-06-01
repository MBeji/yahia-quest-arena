# Dependency Maintenance Cadence

## Goal
Keep runtime and dev dependencies secure and up to date with predictable operational risk.

## Cadence
- Monthly: review outdated packages and security advisories.
- Weekly: check Dependabot/renovation PRs if enabled.
- Immediate: patch high/critical vulnerabilities.

## Process
1. Run `npm outdated`.
2. Run `npm run audit:deps`.
3. Group upgrades by risk: patch, minor, major.
4. Prefer patch/minor first, then major with dedicated validation.
5. Validate with `npm run lint`, `npm run test:coverage`, `npm run build:check`.
6. Document notable upgrades in release notes.

## Rules
- Never merge dependency updates without CI green.
- For major upgrades, require explicit changelog review.
- Keep lockfile committed and reviewed.
