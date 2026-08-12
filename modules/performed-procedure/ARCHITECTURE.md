# Performed Procedure — Architecture (Reconstructed)

**Status:** Reconstructed from verified Figma evidence; not recovered historical source.
**Figma authority inspected:** `06 — Layouts` → `260:2`
**Canonical Figma node:** `Performed Procedure — Phase 1 — Canonical`
**Size:** 920 × 1568 px
**Layout:** Vertical Auto Layout

## Reconstruction rule

This document records only architecture that can be directly supported by the inspected Figma implementation and module boundary rules. Where runtime/backend behavior is not observable, it is intentionally unspecified.

## Purpose

Performed Procedure is the clinical workflow surface for recording the **actual procedure performed during the visit**, distinct from the planned treatment reference.

## Seven-region architecture

1. **Procedure Header** — identifies the module and patient.
2. **Visit Context** — read-only context from Shared Visit.
3. **Planned Treatment Reference** — read-only reference from Treatment Planning.
4. **Actual Procedure** — editable actual procedure values.
5. **Procedure Details** — editable details and technique.
6. **Clinical Documentation** — editable procedure notes and clinical findings.
7. **Procedure Actions** — records the actual procedure.

## Ownership boundaries

### Shared Visit
Provides read-only visit context:
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State

Performed Procedure does not own those values in this composition.

### Treatment Planning
Provides read-only planned references:
- Planned Procedure
- Planned Tooth
- Planned Surface

Performed Procedure must distinguish these from actual procedure values.

### Performed Procedure
Owns the editable actual-procedure entry surface:
- Actual Procedure
- Actual Tooth
- Actual Surface
- Procedure Details
- Materials / Technique
- Procedure Notes
- Clinical Findings

### Downstream history
Clinical Record History presents historical procedure records. The inspected Figma implementation does not establish the backend/event mechanism by which a recorded procedure becomes history, so that mechanism is intentionally unspecified here.

## Component architecture

Observed existing SmileFlow components:

- Functional Select Field: main component `236:1819`
- Input Field: main component `40:103`
- Primary Button: main component `35:99`
- Chevron Down icon: main component `229:133`

No global component modification is implied or authorized by this reconstruction.

## Action boundary

The canonical action is:

`Record Procedure`

The Figma description states that it records the actual procedure and that no additional Phase 1 action is authorized.

This document does not infer database persistence, downstream mutation, billing, insurance, scheduling, or history-event mechanics.

## Interaction boundary

The observed interactions on Actual Procedure, Actual Tooth, and Actual Surface open the existing select-menu destination `236:1830`.

No cross-module production transition was observed during recovery.

## Phase 1 exclusions from this architecture

- editing planned treatment
- editing Shared Visit state
- visit closure
- treatment completion
- Dental Chart mutation
- billing/insurance actions
- scheduling/queue actions
- automatic Clinical Record History generation unless separately specified

## Protected implementation

The Figma node `260:2` was inspected read-only and remains untouched.
