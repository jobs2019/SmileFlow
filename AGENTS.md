# SmileFlow — Codex Agent Instructions

## 1. Purpose
This is the project-wide operating contract for Codex working on SmileFlow.

- Module specifications define **WHAT** to build.
- `SOURCE_OF_TRUTH.md` defines **which repository artifact has authority** when sources differ.
- `PROJECT_STATE.md` defines the **current project state and next authorized project action**.
- `DESIGN.md` defines the approved design-system and Figma conventions.
- This file defines **HOW Codex must operate**.
- A deeper `AGENTS.md` inside a module directory, when present, adds module-specific rules and applies to that directory and its descendants.

Never treat this file as permission to change a module. Authorization comes from the applicable project/module state and explicit user instruction.

## 2. Non-negotiable safety
Never trade architectural correctness for partial implementation.

If the complete requested operation cannot be safely executed and validated in the current turn, stop before making Figma changes and report:

`NOT READY — do not modify Figma.`

Do not make a Figma write merely because a requested feature sounds simple.

## 3. Required reading before work
Before acting on a SmileFlow request, determine the affected module(s) and read, as applicable:

1. `SOURCE_OF_TRUTH.md`
2. `PROJECT_STATE.md`
3. this `AGENTS.md`
4. the nearest applicable module `AGENTS.md`
5. module `ARCHITECTURE.md`
6. module `FIELD_SPECIFICATION.md`
7. relevant governance files
8. `DESIGN.md`
9. implementation/audit artifacts only as evidence, never as authorization

Do not assume that a historical report, audit, README, or existing Figma frame is current authority.

## 4. Source-of-truth discipline
When repository artifacts conflict, do not guess and do not silently reconcile them.

Use `SOURCE_OF_TRUTH.md` to determine authority. If the conflict cannot be resolved from the documented hierarchy, stop and report the contradiction before modifying Figma.

Current approved specifications override stale or superseded implementation artifacts.

The Figma implementation is evidence of the current implementation state; it is not automatically the architectural source of truth.

## 5. Change-scope discipline
For every requested change, first classify it as one of:

- feature addition
- feature removal
- feature modification
- visual correction
- content correction
- architecture change
- ownership change
- design-system change
- governance change

Determine the smallest affected scope before editing anything.

A local feature change must remain local unless the approved architecture explicitly requires cross-module changes.

Do not propagate a change into unrelated modules merely because similar content exists there.

## 6. Ownership
Every data and workflow domain has an owner.

A module may display another module's data as a read-only reference but must not silently become its owner.

Before adding or removing a field/action, determine:

1. who owns the underlying data or workflow;
2. whether the target module is allowed to edit it;
3. whether the change affects another module's contract;
4. whether an architecture change is required.

If ownership is ambiguous, stop before implementation.

## 7. Frozen modules
A module marked `FROZEN` is read-only.

Never modify a frozen module unless:

1. an explicit Architecture Exception has been authorized;
2. the exception is recorded in `governance/ARCHITECTURE_EXCEPTIONS.md`;
3. the applicable specification has been updated/approved;
4. the requested implementation is separately authorized.

Legacy frozen frames are also protected.

An Architecture Exception is not, by itself, permission to write to Figma.

## 8. Historical and superseded artifacts
Historical implementation reports, visual audits, old status files, and superseded specifications may remain in the repository for traceability.

They must never be treated as current authorization when a newer approved source of truth exists.

If a historical artifact conflicts with a current approved artifact, follow the documented source hierarchy and preserve the historical artifact unless explicitly instructed to rewrite history.

## 9. Figma preflight — mandatory before every write
Before any Figma write:

1. Confirm Figma MCP is callable.
2. Confirm the correct document is readable.
3. Confirm the target page is accessible.
4. Confirm write capability.
5. Confirm required components are available.
6. Confirm the target module is authorized for implementation.
7. Confirm the target composition name and exact-name conflicts.
8. Confirm no frozen-module boundary will be crossed.
9. Confirm required execution capacity exists to complete and validate the whole operation.
10. Confirm the operation can be validated after the write.

If any required capability, authorization, or information is unavailable, do not modify Figma.

Report:

`NOT READY — do not modify Figma.`

## 10. Exact-name conflicts
If the requested exact composition name already exists:

- do not modify it;
- do not delete it;
- do not rename it;
- do not duplicate it as a workaround.

Report its node ID, location, dimensions, classification, and relationship to the requested composition.

A naming exception requires explicit authorization and must be recorded where required by repository governance.

## 11. Design-system protection
Never modify the following as a side effect of module implementation:

- component definitions
- component sets
- variants
- variables
- styles
- tokens
- typography foundations
- icon foundations
- approved global design-system components

When an existing component is required, the resulting layer must be a genuine Figma `INSTANCE` linked to that component.

Never simulate an available component with local text, frames, or custom substitutes.

If a required component is unavailable or incompatible, stop and report the exact blocker.

## 12. Specification fidelity
Implement the approved specification exactly.

Do not:

- simplify requirements;
- omit fields;
- invent fields;
- split a field into multiple fields without authorization;
- reinterpret ownership;
- invent workflows;
- invent navigation;
- add convenience actions;
- add Phase 2 behavior to Phase 1;
- use stale implementation behavior to override the current specification.

If a requirement is unclear, stop rather than inventing an answer.

## 13. Feature addition/removal protocol
When a user asks to add, remove, or modify a feature:

1. Identify the owning module.
2. Identify the authoritative specification.
3. Determine whether the change is local or cross-module.
4. Check architecture impact.
5. Check ownership impact.
6. Check design-system impact.
7. Check frozen-module impact.
8. Check whether an Architecture Exception is required.
9. Update the repository specification before or as part of implementation, according to the authorized workflow.
10. Run the applicable Figma preflight.
11. Implement only the authorized scope.
12. Perform structural QA.
13. Perform Visual & UX Audit when required.
14. Reconcile status/report artifacts.
15. Freeze only when explicitly authorized.

Do not treat a feature request as permission to redesign adjacent areas.

## 14. Phase control
The normal lifecycle is:

Architecture → Field Specification → Phase 1 Implementation → Structural QA → Visual & UX Audit → Minimal Polish if authorized → Final Re-audit → FREEZE.

Do not skip phases.

Do not advance phases without explicit instruction or an existing project authorization that clearly permits the next phase.

A module that is not frozen is not automatically authorized for Figma modification.

## 15. Implementation QA
After implementation, inspect the actual Figma nodes and verify at minimum:

- exact composition identity
- architecture and region structure
- field presence and content
- component identity
- genuine instance identity
- Auto Layout
- dimensions and containment
- typography and styles
- read-only/editable distinction
- navigation/prototype behavior
- ownership boundaries
- frozen-module preservation
- design-system preservation
- unauthorized additions
- exact-name integrity

Do not report PASS based only on intended code/tool operations. Verify the actual resulting Figma state.

## 16. Audit-only mode
When instructed to `AUDIT ONLY`:

- read only;
- make no Figma changes;
- fix no findings;
- do not perform cleanup;
- report findings and stop.

## 17. Failure handling
If an API, script, connector, or Figma operation fails:

1. determine whether Figma actually changed;
2. do not silently continue;
3. retry only when safe and idempotent;
4. preserve the no-partial-implementation rule;
5. report the exact error;
6. report the confirmed change status;
7. identify the safest next action.

Never claim success from a failed or unverified operation.

## 18. Repository consistency
Repository governance is part of SmileFlow's implementation safety.

When changing project/module state, keep the relevant authority records consistent:

- `PROJECT_STATE.md`
- `SOURCE_OF_TRUTH.md`
- `governance/FROZEN_MODULES.md`
- `governance/ARCHITECTURE_EXCEPTIONS.md`
- module `STATUS.md`
- implementation/audit reports when their state is changed

Do not rewrite historical records merely to make them agree with current state; mark them superseded when appropriate.

If a contradiction is discovered, resolve the repository contradiction before Figma implementation.

## 19. Current SmileFlow boundary
At the time of this instruction set, Clinical Workspace has an approved replacement architecture and field specification, but its replacement Figma implementation has not been authorized.

The previous Clinical Workspace Figma composition is protected historical work.

Do not modify, delete, rename, duplicate, or repurpose that previous composition as part of the replacement until the strict preflight passes and implementation is separately authorized.

## 20. Source hierarchy
Use the hierarchy defined by `SOURCE_OF_TRUTH.md`.

In practical terms, do not let lower-authority evidence override a current approved specification or explicit authorization.

External repositories, screenshots, examples, and references are references only and are never SmileFlow authority.
