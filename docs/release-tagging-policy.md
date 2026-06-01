# Release Tagging Policy

## Purpose
Ensure traceable deployments and fast rollback.

## Versioning
- Use semantic versioning tags: `vMAJOR.MINOR.PATCH`.
- Tag only after CI passes on `main`.

## Release Workflow
1. Merge approved PRs to `main`.
2. Ensure CI workflow is green.
3. Create an annotated tag:
   - `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
4. Push tag:
   - `git push origin vX.Y.Z`
5. Publish release notes with key changes and migration notes.

## Hotfixes
- Branch from latest tag.
- Apply minimal fix.
- Tag with patch bump.
