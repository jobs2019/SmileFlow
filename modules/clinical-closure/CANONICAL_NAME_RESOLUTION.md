# Clinical Closure — Gate 3 Exact-Name Conflict Resolution

## Result

**PASS — resolved non-destructively.**

The v1.0 implementation candidate has been assigned the exact requested canonical name without modifying the protected legacy frame.

## Canonical authority

Current canonical implementation:

- Name: `Clinical Closure — Phase 1 — Canonical`
- Figma node: `331:1366`
- Page: `06 — Layouts`
- Dimensions: `920 × 1376 px`

Repository authority is node-ID based. The node ID `331:1366` is the authoritative identity of the current canonical implementation.

## Protected legacy

Legacy node:

- Name: `Clinical Closure — Phase 1 — Canonical`
- Figma node: `220:1294`
- Dimensions: `920 × 1315 px`
- Status: HISTORICAL / SUPERSEDED / PROTECTED

It was not modified, renamed, deleted, duplicated, moved, or repurposed.

## Why duplicate names are acceptable

Figma node names are not globally unique identifiers. Figma node IDs are unique identities. Two nodes may therefore retain the same display name while governance distinguishes them by node ID and repository status.

This is preferable to modifying the protected legacy artifact solely to free the name.

## Verification

Before the write:

- legacy node `220:1294` had the canonical name;
- candidate `331:1366` had the temporary construction name;
- both were on `06 — Layouts`;
- exact canonical-name count was 1.

Write performed:

- renamed only `331:1366` to `Clinical Closure — Phase 1 — Canonical`.

After the write:

- `331:1366` has the canonical name;
- `220:1294` still has the canonical display name;
- legacy dimensions remain `920 × 1315`;
- legacy child count remains 7;
- legacy child names remain unchanged;
- exact canonical-name count is now 2.

## Governance rule

Future agents MUST use the repository-authoritative node ID `331:1366` for the current Clinical Closure canonical composition.

They MUST NOT infer authority from name matching alone.

The legacy node `220:1294` remains protected historical evidence.

## Freeze boundary

Gate 3 resolution does not freeze the module. Final canonical verification and repository synchronization remain separate gates, followed by a separate explicit freeze decision.
