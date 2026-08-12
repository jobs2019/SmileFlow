# Clinical Workspace — Status

## Current status
REPLACEMENT ARCHITECTURE APPROVED — Figma replacement implementation NOT IMPLEMENTED

## Canonical composition under replacement architecture
`Clinical Workspace — Phase 1 — Canonical`

## Previous implementation
The previous Clinical Workspace implementation at `207:1291` (`Clinical Workspace — Phase 1`) is a historical, protected composition associated with the superseded architecture.

It is not the source of truth for the replacement implementation.

## Replacement readiness
- Architecture: APPROVED
- Field Specification: APPROVED
- Figma pre-flight: COMPLETE — NOT READY
- Replacement implementation: NOT IMPLEMENTED
- Structural QA: NOT STARTED
- Visual & UX Audit: NOT STARTED
- Freeze: NOT READY

## Preflight result
The strict read-first Figma preflight is recorded at `modules/clinical-workspace/FIGMA_PREFLIGHT.md`.

Result: `NOT READY — do not modify Figma.`

Primary findings:
- The existing protected composition `207:1291` does not conform to the replacement seven-region architecture.
- The existing composition contains the prohibited `Clinical Closure` action instead of the authorized `Save Clinical Notes` action.
- The required Clinical Assessment and Treatment Plan Context regions are absent from the existing composition.
- The required editable assessment fields are absent.
- The required Materials / Technique working-documentation field is absent.
- The replacement implementation must be created as a new canonical composition; `207:1291` must remain untouched.
- The current task authorized preflight only; implementation requires separate authorization.

## Required next step
Do not modify Figma. Confirm/authorize the replacement implementation plan, then run the implementation only against the approved architecture and field specification, followed by structural QA and Visual & UX Audit.

No Figma changes are authorized by this status file.
