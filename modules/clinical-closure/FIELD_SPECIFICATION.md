# Clinical Closure — Precise Field-Level Specification v1.0

## Status

**DRAFT FOR APPROVAL**

This document translates the approved Clinical Closure Architecture & Information Model v1.0 into a precise Phase 1 field-level contract.

It is a repository specification only. It does **not** authorize Figma implementation.

No Figma changes are authorized until this specification is explicitly approved and the SmileFlow Figma Preflight protocol passes.

---

## 1. Canonical composition

Canonical name:

`Clinical Closure — Phase 1 — Canonical`

Recommended width:

`920 px`

Layout:

- Vertical Auto Layout
- Exactly seven top-level regions
- Existing SmileFlow components only
- No global component, variant, variable, style, token, typography, or icon modifications

---

## 2. Canonical demonstration context

Unless a later approved demonstration context replaces these values, Phase 1 uses the following values for structural/design verification:

| Field | Demonstration value | Mode | Owner |
|---|---|---|---|
| Patient Name | `Maria Santos` | Read-only | Patient domain |
| Patient ID | `P-000128` | Read-only | Patient domain |
| Visit ID | `V-000128` | Read-only | Shared Visit |
| Visit Date | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair 02` | Read-only | Shared Visit |
| Visit State | `In Treatment` | Read-only | Shared Visit |
| Treatment Item | `Composite Restoration` | Read-only | Treatment Planning |
| Procedure | `Composite Restoration` | Read-only | Treatment Planning |
| Tooth / Site | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Occlusal` | Read-only | Treatment Planning |
| Treatment Status | `In Progress` | Read-only | Treatment Planning |
| Planned Treatment | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Procedure | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Tooth / Site | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Occlusal` | Read-only | Treatment Planning |
| Plan Status | `Planned` | Read-only | Treatment Planning |

These are demonstration values only and do not grant Clinical Closure permission to mutate any upstream module.

---

# 3. Region 1 — Clinical Closure Header

### Purpose
Identify the patient and the Clinical Closure module.

| Field | Exact label | Value | Mode | Component requirement |
|---|---|---|---|---|
| Module title | `Clinical Closure` | `Clinical Closure` | Static/read-only | Existing text/presentation pattern |
| Patient | `Patient` | `Maria Santos` | Read-only | Existing read-only presentation |
| Patient ID | `Patient ID` | `P-000128` | Read-only | Existing read-only presentation |

### Rules

- Patient identity is never editable here.
- No patient search, registration, or identity mutation control.
- Header must clearly identify this as Clinical Closure rather than Clinical Workspace.

---

# 4. Region 2 — Visit Context

### Purpose
Provide current visit context needed to understand the closure decision.

| Field | Exact label | Value | Mode | Owner |
|---|---|---|---|---|
| Visit ID | `Visit ID` | `V-000128` | Read-only | Shared Visit |
| Visit Date | `Visit Date` | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `Visit Type` | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair` | `Chair 02` | Read-only | Shared Visit |
| Visit State | `Visit State` | `In Treatment` | Read-only | Shared Visit |

### Rules

- `In Treatment` is a visit state, not a closure outcome.
- No visit-state editing control.
- No appointment, queue, check-in, waiting, called, or visit-closing control.
- `Visit State` must be visually distinct from `Closure Outcome`.

---

# 5. Region 3 — Active Treatment Context

### Purpose
Identify the treatment being evaluated at the closure boundary.

| Field | Exact label | Value | Mode | Owner |
|---|---|---|---|---|
| Treatment Item | `Treatment Item` | `Composite Restoration` | Read-only | Treatment Planning |
| Procedure | `Procedure` | `Composite Restoration` | Read-only | Treatment Planning |
| Tooth / Site | `Tooth / Site` | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Planned Surface / Scope` | `Occlusal` | Read-only | Treatment Planning |
| Treatment Status | `Treatment Status` | `In Progress` | Read-only | Treatment Planning |

### Rules

- `In Progress` is the Treatment Planning lifecycle state.
- No treatment lifecycle mutation.
- No treatment completion control.
- No tooth/site editing.
- No Dental Chart mutation.
- No treatment-plan creation or editing.

---

# 6. Region 4 — Closure Outcome

### Purpose
Provide the single primary Clinical Closure decision.

### Field

| Field | Exact label | Demonstration value | Mode | Component |
|---|---|---|---|---|
| Closure Outcome | `Closure Outcome` | `Completed as Planned` | Editable | Existing appropriate Select Field instance |

### Canonical option vocabulary

Exactly these four options are authorized:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

### Rules

- These values belong exclusively to Clinical Closure.
- They must not be presented as Treatment Planning lifecycle states.
- They must not be merged with Visit State or Treatment Status.
- Use the existing approved Functional Select Field / appropriate Select Field component.
- Do not create or modify a global select component for this module.
- No additional outcome such as `Cancelled`, `Closed`, `Completed`, `Deferred`, or `Abandoned` may be introduced without an approved specification change.
- `Treatment Continues` must preserve the possibility that the treatment extends beyond the current visit.

### Conditional behavior

Phase 1 does not authorize conditional mutation of upstream data based on the selected outcome.

Selecting an outcome changes the local Clinical Closure decision only.

---

# 7. Region 5 — Closure Context / Summary

### Purpose
Provide a concise read-only confirmation context for the selected closure decision without duplicating Clinical Workspace documentation.

| Field | Exact label | Demonstration value | Mode |
|---|---|---|---|
| Selected Outcome | `Selected Outcome` | `Completed as Planned` | Read-only derived display |
| Treatment Context | `Treatment Context` | `Composite Restoration — Tooth 46` | Read-only derived/reference display |
| Visit Context | `Visit Context` | `V-000128 — August 11, 2026` | Read-only derived/reference display |

### Rules

- These are confirmation/reference displays, not additional editable fields.
- No clinical notes editor belongs here.
- No procedure finalization editor belongs here.
- No historical timeline belongs here.
- No billing, insurance, scheduling, or queue information belongs here.

### State synchronization rule

The displayed `Selected Outcome` must represent the current local Closure Outcome selection. It must not silently mutate Treatment Planning, Shared Visit, Performed Procedure, Dental Chart, or Clinical Record History.

---

# 8. Region 6 — Downstream Handoff

### Purpose
Communicate the next workflow boundary without performing an unauthorized transition.

| Field | Exact label | Demonstration value | Mode |
|---|---|---|---|
| Next Workflow Boundary | `Next Workflow Boundary` | `Performed Procedure` | Read-only |
| Handoff Status | `Handoff Status` | `No automatic transition` | Read-only |

### Rules

- This region communicates workflow ownership only.
- It is not a navigation control in Phase 1.
- It must not create a Performed Procedure record automatically.
- It must not modify Treatment Planning.
- It must not modify Shared Visit.
- It must not create Clinical Record History entries.
- No cross-module prototype transition is authorized in this specification.

### Rationale

Performed Procedure is the downstream owner of finalized actual procedure information. Clinical Closure may identify that boundary, but Phase 1 does not authorize an automatic transition or record creation.

If later workflow requirements require navigation or automatic handoff, that behavior requires a separate approved interaction specification and a new Figma preflight.

---

# 9. Region 7 — Closure Actions

### Purpose
Commit or abandon the local Clinical Closure decision.

## Action A — Primary

| Property | Value |
|---|---|
| Exact label | `Save Closure Outcome` |
| Type | Primary Button |
| Editable state | Enabled only when a Closure Outcome is selected |
| Ownership | Clinical Closure |
| Effect | Saves the Clinical Closure outcome only |
| Cross-module mutation | None authorized |
| Prototype | No reaction in Phase 1 |

## Action B — Secondary

| Property | Value |
|---|---|
| Exact label | `Cancel` |
| Type | Secondary Button |
| Ownership | Clinical Closure |
| Effect | Abandons the unsaved local closure decision |
| Cross-module mutation | None |
| Prototype | No reaction in Phase 1 |

### Rules

- Existing Button instances must be reused.
- No `Record Procedure` action.
- No `Close Visit` action.
- No `Complete Treatment` action.
- No `Cancel Visit` action.
- No Dental Chart action.
- No Treatment Planning action.
- No billing, insurance, appointment, or queue action.
- `Save Closure Outcome` must not silently finalize a procedure or complete treatment.
- `Cancel` must not mutate upstream or downstream records.

### Approval note

The exact action labels above are proposed Phase 1 labels derived from the architecture requirement for commit/cancel closure actions. They require explicit specification approval before implementation.

---

# 10. Editable / Read-Only Matrix

## Editable

Exactly one domain field:

- `Closure Outcome`

The following actions are interactive controls but are not data fields:

- `Save Closure Outcome`
- `Cancel`

## Read-only

- Patient
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State
- Treatment Item
- Procedure
- Tooth / Site
- Planned Surface / Scope
- Treatment Status
- Planned Treatment
- Planned Procedure
- Planned Tooth / Site
- Planned Surface / Scope
- Plan Status
- Selected Outcome
- Treatment Context
- Visit Context
- Next Workflow Boundary
- Handoff Status

No other editable data field is authorized in Phase 1.

---

# 11. Component Requirements

## Required existing components

### Closure Outcome
Use the existing approved Functional Select Field / appropriate Select Field instance.

The implementation must not modify:

- Select Option
- Select Menu
- Functional Select Field
- component sets
- variants
- variables
- tokens
- styles

### Buttons
Use existing approved Button instances for:

- `Save Closure Outcome`
- `Cancel`

### Read-only presentation
Reuse existing SmileFlow read-only label/value presentation patterns.

Do not create a new global component solely for Clinical Closure.

### Component blocker rule

If the exact required component variant cannot be identified, stop before Figma implementation and report the blocker. Do not substitute a custom component without an approved architecture/specification change.

---

# 12. Demonstration-State Semantics

The canonical demonstration state is:

```text
Visit State:       In Treatment
Treatment Status:  In Progress
Closure Outcome:   Completed as Planned
```

These values intentionally represent three different ownership domains.

They must remain visually and semantically distinct.

The selected closure outcome does not imply that Treatment Status has changed.

---

# 13. Prototype / Interaction Boundary

Phase 1 has **no automatic cross-module transition**.

Specifically, the following are NOT authorized:

- automatic Treatment Planning completion
- automatic Shared Visit closure
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- automatic Dental Chart mutation
- automatic navigation to another module
- automatic billing/insurance action

`Save Closure Outcome` saves the Clinical Closure decision only.

`Cancel` discards the unsaved local decision only.

If prototype reactions are later required, they must be defined in a separate approved interaction specification and pass the Figma Preflight protocol again.

---

# 14. Ownership Contract

| Data / behavior | Owner | Clinical Closure behavior |
|---|---|---|
| Patient identity | Patient domain | Read-only reference |
| Visit identity/state | Shared Visit | Read-only reference |
| Treatment lifecycle | Treatment Planning | Read-only reference |
| Current clinical documentation | Clinical Workspace | Read-only reference only |
| Closure outcome | Clinical Closure | Owns/edit/saves |
| Finalized procedure | Performed Procedure | Downstream boundary only |
| Historical chronology | Clinical Record History | Downstream boundary only |
| Dental chart | Dental Chart | No mutation |

Clinical Closure must never become a duplicate editor for another module.

---

# 15. Exclusions

The following are explicitly excluded from Phase 1:

- Insurance
- Billing
- Payments
- Claims
- Appointment scheduling
- Queue management
- Messaging
- AI diagnosis
- AI treatment recommendations
- Dental Chart editing
- Treatment Planning editing
- Treatment completion controls
- Visit closure controls
- Performed Procedure editing
- Procedure surface/outcome editing
- Historical timeline editing
- Clinical Workspace documentation editing
- Automatic downstream record creation
- Automatic cross-module navigation

---

# 16. Canonical Composition Invariants

Before Figma implementation, the following must be mechanically verifiable:

1. Exactly one `Clinical Closure — Phase 1 — Canonical` composition exists.
2. Exactly seven top-level regions exist.
3. Region order matches the architecture exactly.
4. `Closure Outcome` is the only editable domain field.
5. Closure Outcome contains exactly four authorized options.
6. Existing approved Select Field components are reused as genuine instances.
7. Existing Button components are reused as genuine instances.
8. Exactly two closure actions exist: `Save Closure Outcome` and `Cancel`.
9. No unauthorized cross-module action exists.
10. Visit State remains `In Treatment`.
11. Treatment Status remains `In Progress`.
12. Closure Outcome remains semantically separate from both.
13. `Treatment Continues` remains an available closure outcome.
14. No Clinical Workspace documentation editor is duplicated.
15. No Performed Procedure editor is introduced.
16. No Clinical Record History timeline is introduced.
17. No Dental Chart or Treatment Planning mutation is introduced.
18. Frozen modules remain untouched.
19. Global design-system definitions remain untouched.
20. No Phase 2 behavior is introduced.

---

# 17. Implementation Gate

This specification becomes an implementation authority only when its status is explicitly changed to:

**APPROVED — Phase 1 source of truth**

After approval, the following must occur before any Figma write:

1. Confirm exact-name availability.
2. Verify required Select Field and Button components.
3. Verify read-only presentation pattern.
4. Run the SmileFlow Figma Preflight protocol.
5. Confirm no protected/frozen composition will be modified.
6. Obtain explicit implementation authorization.
7. Create a brand-new canonical composition.
8. Perform structural QA.
9. Perform Visual & UX Audit.
10. Freeze only after separate explicit authorization.

Until approval, **do not modify Figma**.
