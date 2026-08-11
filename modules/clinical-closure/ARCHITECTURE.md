# Clinical Closure — Architecture & Information Model v1.0

## Status

DRAFT FOR APPROVAL

This architecture is the next module-level source artifact for SmileFlow.
It is intentionally limited to the Clinical Closure ownership boundary
already established in the project.

It does not authorize Figma implementation by itself.

---

## 1. Purpose

Clinical Closure is the workflow boundary used to classify the outcome of
the current clinical treatment/visit before downstream finalized procedure
and historical-record workflows.

It receives the current clinical context as read-only reference data and
owns the closure outcome classification.

Clinical Closure must make the distinction between:

- the current visit state,
- the treatment state,
- the closure outcome,

clear and visually explicit.

---

## 2. Ownership

### Clinical Closure owns

- closure outcome classification
- closure decision for the current clinical context
- the selected closure outcome
- closure-specific user action required to submit/confirm the outcome

### Clinical Closure may reference

- Patient identity
- Patient ID
- Visit type
- Chair / current visit context
- Current visit status
- Active treatment
- Tooth / treatment scope
- Treatment status
- Current clinical documentation

Referenced values remain read-only.

### Clinical Closure does not own

- patient registration
- Dental Chart state
- treatment-plan creation/editing
- treatment lifecycle management
- appointment or queue lifecycle
- active clinical documentation
- performed-procedure details
- procedure surfaces/outcomes
- historical clinical chronology
- billing
- insurance

---

## 3. Canonical Closure Outcomes

The project has already established the following closure outcomes as
Clinical Closure-owned outcomes:

1. Completed as Planned
2. Completed with Modification
3. Not Completed
4. Treatment Continues

These are closure classifications.

They must not be represented as Treatment Planning lifecycle states.

They must not be confused with the Shared Visit state `In Treatment`.

---

## 4. Relationship to Treatment Planning

Treatment Planning owns the treatment lifecycle:

Planned → Scheduled → In Progress → Completed

Clinical Closure does not directly edit that lifecycle.

Clinical Closure records/classifies what happened at the closure boundary.

A closure outcome must not silently mutate Treatment Planning data unless
a later approved workflow explicitly defines that transition.

---

## 5. Relationship to Clinical Workspace

Clinical Workspace owns active clinical work and current documentation.

Clinical Closure receives that context as reference information.

Clinical Closure must not duplicate the Clinical Workspace documentation
workflow or provide another general-purpose clinical notes workspace.

---

## 6. Relationship to Performed Procedure

Performed Procedure owns finalized actual procedure information.

Clinical Closure must not become the Performed Procedure editor.

The closure outcome may provide an authorized downstream handoff, but the
actual procedure record remains owned by Performed Procedure.

---

## 7. Relationship to Clinical Record History

Clinical Record History owns historical chronology.

Clinical Closure is a current workflow boundary, not a historical timeline.

Do not place a visit/procedure/history timeline inside Clinical Closure.

---

## 8. Seven-Region Information Architecture

The canonical Phase 1 composition should use exactly seven top-level regions.

### Region 1 — Clinical Closure Header

Purpose:
Identify the patient and module.

Expected information:

- Patient Name
- Patient ID
- `Clinical Closure`

Patient identity is read-only.

---

### Region 2 — Visit Context

Purpose:
Provide read-only context for the closure decision.

Expected references:

- Visit Type
- Chair
- Current Visit Status

The current visit state must remain visually distinct from the closure
outcome.

---

### Region 3 — Active Treatment Context

Purpose:
Identify what treatment is being closed.

Expected references:

- Treatment Name
- Tooth / Site
- Planned Surface where applicable
- Treatment Status

All treatment context is read-only.

No Treatment Planning editing controls belong here.

---

### Region 4 — Closure Outcome

Purpose:
Allow the user to select the Clinical Closure outcome.

Canonical outcome vocabulary:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

This is the primary Clinical Closure decision area.

The implementation should use an existing appropriate Select Field instance
when a selectable control is required by the approved field specification.

---

### Region 5 — Closure Context / Summary

Purpose:
Show the selected closure context before submission.

This region may present read-only derived/reference information needed to
verify the decision.

It must not become a duplicate Clinical Workspace documentation area.

---

### Region 6 — Downstream Handoff

Purpose:
Clearly communicate the next workflow boundary after closure.

The handoff must remain conceptually separate from:

- Treatment Planning
- Performed Procedure
- Clinical Record History

No downstream module should be modified merely by displaying the handoff.

Actual navigation/transition must be explicitly approved in the Phase 1
field specification before implementation.

---

### Region 7 — Closure Actions

Purpose:
Provide the approved action(s) required to commit or cancel the closure
decision.

Actions must use existing Button instances.

No appointment, queue, treatment-editing, Dental Chart, billing, insurance,
or history actions may be introduced.

---

## 9. Information Flow

Current clinical context:

Clinical Workspace
        ↓
Clinical Closure
        ↓
Approved downstream workflow

Clinical Closure is therefore a boundary, not a replacement for the
modules before or after it.

---

## 10. State Semantics

### Visit state

`In Treatment`

Owned by the Shared Visit / current visit domain.

### Treatment state

`In Progress`

Owned by Treatment Planning.

### Closure outcome

One of:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

Owned by Clinical Closure.

These three concepts must remain visually and semantically distinct.

---

## 11. Multi-Visit Rule

`Treatment Continues` explicitly preserves the possibility that treatment
extends beyond the current visit.

Clinical Closure must not visually or semantically imply that closing the
current visit automatically completes the treatment plan.

---

## 12. Safety Boundaries

Clinical Closure must not introduce:

- Dental Chart editing
- tooth-condition editing
- treatment creation/editing
- treatment completion controls
- appointment scheduling
- queue controls
- check-in/waiting/called controls
- clinical documentation authoring
- performed-procedure editing
- procedure surface/outcome editing
- historical timeline editing
- billing
- insurance

---

## 13. Prototype Boundary

Phase 1 should contain only explicitly approved closure transitions.

Do not invent:

- automatic treatment completion
- automatic procedure creation
- automatic history creation
- automatic visit-state mutation

If the precise field-level specification does not explicitly authorize a
transition, it must not be implemented.

---

## 14. Design-System Boundary

Clinical Closure must reuse existing SmileFlow components.

Do not modify:

- component definitions
- component sets
- variants
- variables
- styles
- tokens
- typography foundations
- icons

If a required component is unavailable or incompatible, stop before making
Figma changes and report the exact blocker.

---

## 15. Phase 1 Invariants

1. Exactly one canonical Clinical Closure composition.
2. Exactly seven top-level regions.
3. Existing components are reused as genuine instances.
4. Closure outcomes remain distinct from treatment lifecycle states.
5. `Treatment Continues` preserves multi-visit treatment.
6. No Clinical Workspace documentation editor is duplicated.
7. No Performed Procedure editor is introduced.
8. No Clinical Record History timeline is introduced.
9. No Dental Chart or Treatment Planning mutation is introduced.
10. Frozen modules remain untouched.
11. No design-system definitions are modified.
12. No Phase 2 behavior is introduced.

---

## 16. Implementation Gate

This Architecture & Information Model is the prerequisite for:

`Clinical Closure — Precise Field-Level Specification v1.0`

It is not itself an implementation authorization.

Before Phase 1 implementation, the precise specification must define:

- exact field labels
- exact demonstration values
- exact component types
- editable/read-only status
- exact action labels
- exact prototype transitions
- exact downstream handoff behavior, if any
- exact canonical composition name
- exact seven-region content

No Figma changes should be made until that specification is approved.
