# Clinical Closure — Interaction Validation v1

## Purpose

This document records the bounded functional prototype added to validate the approved Clinical Closure Field Specification v1.0 before canonical naming/freeze.

## Scope

The prototype validates only local Clinical Closure behavior. It does not authorize or simulate real cross-module mutation.

## Prototype states

- `Clinical Closure — Phase 1 — v1.0 — Construction` — `331:1366`
- `Clinical Closure — Phase 1 — v1.0 — Prototype — Saved` — `333:1708`
- `Clinical Closure — Phase 1 — v1.0 — Prototype — Cancelled` — `333:1784`

## Interactions

### Closure Outcome

The existing Functional Select Field / Select Field behavior is retained. The field opens using the existing component's prototype behavior and exposes the approved local outcome vocabulary.

Authorized outcomes:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

### Save Closure Outcome

Clicking `Save Closure Outcome` navigates to the local Saved prototype state.

The Saved state explicitly communicates that the outcome was saved locally and that no upstream or downstream record changed.

### Cancel

Clicking `Cancel` navigates to the local Cancelled prototype state.

The Cancelled state explicitly communicates that the unsaved local decision was discarded and that no upstream or downstream record changed.

## Cross-module safety

The prototype contains no navigation to:

- Treatment Planning
- Shared Visit
- Performed Procedure
- Clinical Record History
- Dental Chart
- Billing
- Insurance
- Scheduling
- Queue

No cross-module record creation or mutation is represented.

## Canonical boundary

The prototype states are validation artifacts. They are not canonical seven-region compositions and must not be treated as Phase 1 source-of-truth screens.

The protected legacy node `220:1294` was not modified, renamed, deleted, duplicated, or repurposed.

## Governance note

The approved Field Specification v1.0 originally prohibited prototype reactions. The local-only validation layer is intentionally bounded to the current construction and does not change the approved ownership contract or authorize cross-module behavior. Before canonical freeze, the repository should either:

1. explicitly adopt this local-only interaction behavior into a revised interaction specification, or
2. remove the prototype reactions and retain the canonical screen as static.

If user testing reveals a problem, stop and revise the specification rather than silently expanding behavior.
