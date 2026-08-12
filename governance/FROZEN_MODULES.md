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

## Protected legacy modules
- Dental Chart — Phase 1 (`127:1110`) — FROZEN
- Treatment Planning — Phase 1 (`136:1124`) — FROZEN

## Explicitly not frozen
- Clinical Workspace — replacement architecture approved; replacement implementation not yet authorized for Figma
- Clinical Closure — next module; architecture is draft for approval and implementation is not authorized

## Freeze rule
The absence of a module from the frozen registry does not grant permission to modify it. Architecture, field specification, project state, and explicit user authorization still govern changes.
