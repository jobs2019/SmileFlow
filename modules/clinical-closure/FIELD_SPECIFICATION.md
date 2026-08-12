# Clinical Closure — Precise Field-Level Specification v1.2

## Status

**DRAFT FOR RE-APPROVAL — architecture-reconciled**

This specification preserves the existing Clinical Closure v1.0 field contract and v1.1 prototype-only amendment except where this document explicitly changes the visit-entry context to conform to the approved Shared Visit ↔ Clinical Closure lifecycle contract.

It does not authorize a Figma write by itself.

## 1. Canonical composition

Canonical name:

`Clinical Closure — Phase 1 — Canonical`

Recommended width: `920 px`

Layout:
- Vertical Auto Layout
- Exactly seven top-level regions
- Existing SmileFlow components only
- No global component, variant, variable, style, token, typography, or icon modifications

## 2. Canonical demonstration context

| Field | Demonstration value | Mode | Owner |
|---|---|---|---|
| Patient Name | `Maria Santos` | Read-only | Patient domain |
| Patient ID | `P-000128` | Read-only | Patient domain |
| Visit ID | `V-000128` | Read-only | Shared Visit |
| Visit Date | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair 02` | Read-only | Shared Visit |
| Visit State | `Ready for Closure` | Read-only | Shared Visit |
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

These are demonstration values only and do not grant Clinical Closure permission to mutate upstream modules.

## 3. Region 1 — Clinical Closure Header

Purpose: identify the patient and Clinical Closure module.

| Field | Exact label | Value | Mode |
|---|---|---|---|
| Module title | `Clinical Closure` | `Clinical Closure` | Static/read-only |
| Patient | `Patient` | `Maria Santos` | Read-only |
| Patient ID | `Patient ID` | `P-000128` | Read-only |

## 4. Region 2 — Visit Context

| Field | Exact label | Value | Mode | Owner |
|---|---|---|---|---|
| Visit ID | `Visit ID` | `V-000128` | Read-only | Shared Visit |
| Visit Date | `Visit Date` | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `Visit Type` | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair` | `Chair 02` | Read-only | Shared Visit |
| Visit State | `Visit State` | `Ready for Closure` | Read-only | Shared Visit |

### Entry rule

Clinical Closure is entered only when Shared Visit's authoritative Visit State is `Ready for Closure`.

`Visit State` is not editable in Clinical Closure.

## 5. Region 3 — Active Treatment Context

| Field | Exact label | Value | Mode | Owner |
|---|---|---|---|---|
| Treatment Item | `Treatment Item` | `Composite Restoration` | Read-only | Treatment Planning |
| Procedure | `Procedure` | `Composite Restoration` | Read-only | Treatment Planning |
| Tooth / Site | `Tooth / Site` | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Planned Surface / Scope` | `Occlusal` | Read-only | Treatment Planning |
| Treatment Status | `Treatment Status` | `In Progress` | Read-only | Treatment Planning |

No treatment lifecycle mutation, completion control, tooth/site editing, Dental Chart mutation, or treatment-plan editing is authorized.

## 6. Region 4 — Closure Outcome

### Field

| Field | Exact label | Demonstration value | Mode | Component |
|---|---|---|---|---|
| Closure Outcome | `Closure Outcome` | `Completed as Planned` | Editable | Existing approved Functional Select Field |

### Canonical option vocabulary

Exactly:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

These are Clinical Closure classifications, not Visit State or Treatment Planning lifecycle values.

## 7. Region 5 — Closure Context / Summary

| Field | Exact label | Demonstration value | Mode |
|---|---|---|---|
| Selected Outcome | `Selected Outcome` | `Completed as Planned` | Read-only derived display |
| Treatment Context | `Treatment Context` | `Composite Restoration — Tooth 46` | Read-only derived/reference display |
| Visit Context | `Visit Context` | `V-000128 — August 11, 2026` | Read-only derived/reference display |

These are confirmation/reference displays, not editable fields.

## 8. Region 6 — Downstream Handoff

| Field | Exact label | Demonstration value | Mode |
|---|---|---|---|
| Next Workflow Boundary | `Next Workflow Boundary` | `Shared Visit — Close Lifecycle` | Read-only |
| Handoff Status | `Handoff Status` | `No automatic transition` | Read-only |

The handoff communicates workflow ownership only. It does not authorize automatic Visit State mutation, procedure creation, history creation, or navigation.

## 9. Region 7 — Closure Actions

### Save Closure Outcome

| Property | Value |
|---|---|
| Exact label | `Save Closure Outcome` |
| Type | Primary Button |
| Ownership | Clinical Closure |
| Effect | Saves the Clinical Closure outcome only |
| Cross-module mutation | None authorized by this specification |
| Prototype | Local-only QA behavior permitted under v1.1 amendment |

### Cancel

| Property | Value |
|---|---|
| Exact label | `Cancel` |
| Type | Secondary Button |
| Ownership | Clinical Closure |
| Effect | Abandons the unsaved local closure decision |
| Cross-module mutation | None |
| Prototype | Local-only QA behavior permitted under v1.1 amendment |

### Close Visit

`Close Visit` is **not an implemented Phase 1 action in the current canonical composition**.

The architecture permits a future Clinical Closure user-facing `Close Visit` command while Shared Visit remains the authoritative owner of `Ready for Closure → Closed`. Adding this control requires a separate approved interaction specification and Figma Preflight.

## 10. Editable / Read-Only Matrix

### Editable domain field

Exactly one:

- `Closure Outcome`

### Interactive actions

- `Save Closure Outcome`
- `Cancel`

### Read-only

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

## 11. State Semantics

Canonical demonstration state:

```text
Visit State:       Ready for Closure
Treatment Status:  In Progress
Closure Outcome:   Completed as Planned
```

These are independent ownership domains.

A saved Closure Outcome does not by itself imply Treatment Planning completion or Shared Visit closure.

`Treatment Continues` preserves the possibility of future visits while the current visit can later close.

## 12. Prototype / Interaction Boundary

The v1.1 amendment remains effective for local-only Save/Cancel QA behavior.

No prototype or production behavior is authorized for:

- automatic Shared Visit mutation
- automatic visit closure
- automatic treatment completion
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- automatic Dental Chart mutation
- automatic cross-module navigation
- billing/insurance/scheduling/queue actions

Any future `Close Visit` interaction must be separately specified and must invoke the Shared Visit-owned lifecycle transition rather than create a second lifecycle owner.

## 13. Ownership Contract

| Data / behavior | Owner | Clinical Closure behavior |
|---|---|---|
| Patient identity | Patient domain | Read-only reference |
| Visit identity/state | Shared Visit | Read-only reference |
| Treatment lifecycle | Treatment Planning | Read-only reference |
| Current clinical documentation | Clinical Workspace | Read-only reference |
| Closure outcome | Clinical Closure | Owns/edit/saves |
| Visit lifecycle transition | Shared Visit | Downstream owner; no direct edit in current composition |
| Finalized procedure | Performed Procedure | Boundary only |
| Historical chronology | Clinical Record History | Boundary only |
| Dental chart | Dental Chart | No mutation |

## 14. Exclusions

Explicitly excluded from this Phase 1 specification:

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
- Visit State editing
- `Close Visit` implementation
- Performed Procedure editing
- Procedure surface/outcome editing
- Historical timeline editing
- Clinical Workspace documentation editing
- Automatic downstream record creation
- Automatic cross-module navigation

## 15. Canonical Composition Invariants

1. Exactly one current canonical Clinical Closure composition.
2. Exactly seven top-level regions.
3. `Ready for Closure` is the canonical Clinical Closure entry state.
4. Shared Visit remains the sole owner of Visit State and visit lifecycle.
5. Closure Outcome is the only editable domain field.
6. Exactly four Closure Outcome values are authorized.
7. Existing approved Select Field and Button components are reused.
8. No unauthorized cross-module action exists.
9. `Save Closure Outcome` does not automatically close the visit.
10. `Cancel` does not mutate upstream or downstream records.
11. No Clinical Workspace documentation editor is duplicated.
12. No Performed Procedure editor is introduced.
13. No Clinical Record History timeline is introduced.
14. No Dental Chart or Treatment Planning mutation is introduced.
15. Frozen modules remain untouched until explicitly authorized.
16. Global design-system definitions remain untouched.
17. No Phase 2 behavior is introduced.

## 16. Implementation Gate

This is a reconciled draft for approval. Before any Figma change:

1. Approve this v1.2 specification.
2. Re-run the Cross-Module Dependency Audit.
3. Run the Clinical Closure Figma Preflight against v1.2.
4. Confirm protected/frozen nodes.
5. Obtain explicit implementation authorization.
6. Only then modify the canonical Clinical Closure composition if required.
7. Perform structural QA, Visual/UX Audit, and Final QA.
8. Freeze only after separate explicit authorization.

No Figma changes are authorized by this specification alone.
