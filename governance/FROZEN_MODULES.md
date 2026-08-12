# SmileFlow — Frozen Module Registry

This registry records modules whose approved Phase 1 state is protected from modification.

A frozen module may only be changed after an explicit Architecture Exception or the applicable versioned change-control authorization is recorded.

## Canonical modules
- Patient Management — FROZEN
- Patient Registration — FROZEN
- Dental Chart — Phase 1 — Canonical — FROZEN
- Treatment Planning — Phase 1 — Canonical (`198:1290`) — FROZEN
- Shared Visit — Phase 1 — Canonical (`256:1303`) — FROZEN
- Performed Procedure — Phase 1 — Canonical (`260:2`) — FROZEN
- Clinical Record History — Phase 1 (`153:1204`) — FROZEN
- Clinical Workspace — Phase 1 — Canonical (`328:1919`) — FROZEN
- Clinical Closure — Phase 1 — Canonical (`220:1294`) — FROZEN

## Protected legacy modules
- Dental Chart — Phase 1 (`127:1110`) — FROZEN
- Treatment Planning — Phase 1 (`136:1124`) — FROZEN
- Clinical Workspace — Phase 1 (`207:1291`) — FROZEN / HISTORICAL PROTECTED

## Clinical Closure freeze basis
Clinical Closure v1.3 was explicitly authorized for canonicalization and freeze after:

- approved architecture and field specification;
- cross-module dependency audit;
- strict Figma preflight;
- implementation authorization;
- Functional QA;
- Structural / Visual QA;
- Final QA.

Freeze authorization is recorded in:

`modules/clinical-closure/CANONICALIZATION_FREEZE_AUTHORIZATION_V1_3.md`

Canonical node: `220:1294`.

The dedicated QA harness `356:1197` remains non-canonical and is not promoted in place of the canonical frame.

## Freeze rule
The absence of a module from the frozen registry does not grant permission to modify it. Architecture, field specification, project state, and explicit user authorization still govern changes.

Any future modification to a frozen module must follow the applicable change-control path. For Clinical Closure, the next modification must begin as a new versioned change proposal such as v1.4; the existing v1.3 baseline must not be edited ad hoc.
