# SmileFlow — Frozen Module Registry

This registry records modules whose approved Phase 1 state is protected from modification.

A frozen module may only be changed after an explicit Architecture Exception is authorized.

## Canonical modules
- Patient Management — FROZEN
- Patient Registration — FROZEN
- Dental Chart — Phase 1 — Canonical — FROZEN
- Treatment Planning — Phase 1 — Canonical (`198:1290`) — FROZEN
- Shared Visit — Phase 1 — Canonical (`256:1303`) — FROZEN
- Performed Procedure — Phase 1 — Canonical (`260:2`) — FROZEN
- Clinical Record History — Phase 1 (`153:1204`) — FROZEN
- Clinical Workspace — Phase 1 — Canonical (`328:1919`) — FROZEN

## Protected legacy modules
- Dental Chart — Phase 1 (`127:1110`) — FROZEN
- Treatment Planning — Phase 1 (`136:1124`) — FROZEN
- Clinical Workspace — Phase 1 (`207:1291`) — FROZEN / HISTORICAL PROTECTED

## Explicitly not frozen
- Clinical Closure — Phase 1 — Canonical — implementation complete, QA PASS, not frozen

## Freeze rule
The absence of a module from the frozen registry does not grant permission to modify it. Architecture, field specification, project state, and explicit user authorization still govern changes.

## Clinical Workspace freeze basis
The replacement canonical composition `328:1919` was frozen only after:

- approved architecture and field specification were satisfied;
- strict Figma preflight passed;
- replacement implementation completed;
- structural QA passed;
- Visual & UX Audit passed;
- final read-only Figma verification confirmed the canonical seven-region structure;
- protected historical node `207:1291` remained untouched.

Any future modification requires an explicit Architecture Exception and a new implementation authorization.

## Clinical Closure state
Clinical Closure Phase 1 is intentionally **not frozen** at this time. Its approved canonical implementation has completed implementation, preflight, structural QA, Visual/UX Audit, interaction validation, canonical verification, and final QA. Not-frozen status does not grant automatic permission for further Figma modification; normal repository interpretation, preflight, and explicit implementation authorization remain required.
