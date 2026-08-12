# Clinical Closure — Precise Field-Level Specification v1.3

## Status

**APPROVED — CANONICALIZED — FROZEN**

This is the authoritative frozen v1.3 field-level specification. It reconciles the architecture, cross-module dependency audit, Figma preflight, implementation authorization, completed Functional QA, Structural / Visual QA, and Final QA.

Canonicalization and freeze are recorded in `CANONICALIZATION_FREEZE_AUTHORIZATION_V1_3.md`.

## 1. Purpose

Clinical Closure v1.3 upgrades the v1.2 outcome selector into a structured closure record answering:

1. What was the closure outcome?
2. What clinical work was completed or not completed?
3. What changed from the plan, if anything?
4. What remains when treatment continues?
5. Why was treatment not completed?
6. What concise closure summary should be retained?
7. Who recorded the closure and when?

Clinical Closure remains a current-workflow boundary. It is not a replacement for Treatment Planning, Performed Procedure, Clinical Workspace documentation, Dental Chart, or Clinical Record History.

## 2. Lifecycle

Clinical Closure is entered when authoritative Shared Visit state is:

`Ready for Closure`

The approved lifecycle remains:

```text
Shared Visit
In Treatment
    ↓
Shared Visit
Ready for Closure
    ↓
Clinical Closure
Closure Record
    ↓
Shared Visit remains lifecycle owner
    ↓
Closed when Shared Visit explicitly performs closure
```

Saving a closure record does not automatically change Shared Visit Visit State.

## 3. Canonical composition

Canonical name:

`Clinical Closure — Phase 1 — Canonical`

Exactly seven top-level regions remain:

1. Clinical Closure Header
2. Visit Context
3. Active Treatment Context
4. Closure Outcome
5. Closure Context / Summary
6. Downstream Handoff
7. Closure Actions

Existing SmileFlow components and vertical Auto Layout are preserved. No shared component, variant, variable, style, token, typography, or icon modification is authorized.

## 4. Demonstration context

Demonstration values:

| Field | Value | Mode | Owner |
|---|---|---|---|
| Patient | `Maria Santos` | Read-only | Patient |
| Patient ID | `P-000128` | Read-only | Patient |
| Visit ID | `V-000128` | Read-only | Shared Visit |
| Visit Date | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair 02` | Read-only | Shared Visit |
| Visit State | `Ready for Closure` | Read-only | Shared Visit |
| Treatment Item | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Procedure | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Tooth / Site | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Occlusal` | Read-only | Treatment Planning |
| Treatment Status | `In Progress` | Read-only | Treatment Planning |
| Plan Status | `Planned` | Read-only | Treatment Planning |
| Closure Outcome | `Completed as Planned` | Editable | Clinical Closure |
| Provider | `Dr. Example` | System-derived/read-only | Provider context |
| Closure Date / Time | `August 11, 2026 — 3:42 PM` | System-derived/read-only | Clinical Closure |

Demonstration values do not authorize upstream mutation.

## 5. Region 1 — Clinical Closure Header

Required, read-only/static:

- `Clinical Closure`
- `Patient`
- `Patient ID`

No editable patient information is permitted.

## 6. Region 2 — Visit Context

Required, read-only:

- `Visit ID`
- `Visit Date`
- `Visit Type`
- `Chair`
- `Visit State`

`Visit State` must never be editable from Clinical Closure.

## 7. Region 3 — Active Treatment Context

### Planned/reference fields

Required, read-only:

- `Treatment Item`
- `Planned Procedure`
- `Planned Tooth / Site`
- `Planned Surface / Scope`
- `Treatment Status`
- `Plan Status`

### Actual-work rule

`Actual Work / Procedure` is required only when clinical work occurred or authoritative Performed Procedure data exists and is being referenced. It is not required when no clinical work occurred.

Conditional fields:

- `Actual Work / Procedure`
- `Actual Tooth / Site`
- `Actual Surface / Scope`

If authoritative Performed Procedure data exists, Clinical Closure should reference it rather than duplicate the complete procedure editor.

## 8. Region 4 — Closure Outcome

### Primary field

`Closure Outcome` is editable and uses the approved existing **Functional Select Field**.

Exactly four values, in this order:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

No additional domain-specific values are permitted without a specification revision.

### Outcome behavior

#### Completed as Planned

Required:

- Closure Outcome
- Actual Work / Procedure when work occurred
- Clinical Closure Summary
- Provider
- Closure Date / Time

Optional when applicable:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

#### Completed with Modification

Required:

- Closure Outcome
- Actual Work / Procedure
- Modification Classification
- Modification Reason
- Clinical Closure Summary
- Provider
- Closure Date / Time

Optional when applicable:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

#### Not Completed

Required:

- Closure Outcome
- Not Completed Reason
- Clinical Closure Summary
- Provider
- Closure Date / Time

Conditionally required when follow-up is needed:

- Next Step / Follow-up Context

If partial clinical work occurred, Actual Work / Procedure is required/reference-populated.

Optional:

- Patient Tolerance
- Complications / Exceptions

#### Treatment Continues

Required:

- Closure Outcome
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Clinical Closure Summary
- Provider
- Closure Date / Time

Conditionally required when known:

- Next Planned Procedure / Next Step

Optional:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

## 9. Outcome-specific controlled vocabulary

### Modification Classification

1. `Procedure Changed`
2. `Tooth / Site Changed`
3. `Surface / Scope Changed`
4. `Treatment Extent Changed`
5. `Material / Technique Changed`
6. `Other`

This vocabulary is consumer-owned by Clinical Closure and must not mutate Treatment Planning.

### Not Completed Reason

1. `Patient Declined`
2. `Patient Unable to Tolerate`
3. `Insufficient Time`
4. `Medical Concern`
5. `Unexpected Clinical Finding`
6. `Equipment / Resource Issue`
7. `Financial / Administrative Reason`
8. `Referred Elsewhere`
9. `Other`

These values classify the closure record only.

### Patient Tolerance

1. `Good`
2. `Fair`
3. `Poor`
4. `Not Documented`

## 10. Region 5 — Closure Context / Summary

### Clinical Closure Summary

- Exact label: `Clinical Closure Summary`
- Type: Multiline text field
- Mode: Editable
- Required: Yes for every saved closure
- Owner: Clinical Closure
- Component: approved `Multiline Text Field`

A generated summary is only a suggested/editable value. The provider must review and approve the final text before save.

### Confirmation/reference fields

Read-only:

- `Selected Outcome`
- `Treatment Context`
- `Visit Context`
- `Provider`
- `Closure Date / Time`

`Provider` and `Closure Date / Time` are system-derived in normal workflow.

Editable when applicable:

- `Patient Tolerance`
- `Complications / Exceptions`

## 11. Region 6 — Downstream Handoff

Read-only:

| Field | Value |
|---|---|
| `Next Workflow Boundary` | `Shared Visit — Close Lifecycle` |
| `Handoff Status` | `No automatic transition` |

This region communicates the lifecycle boundary; it is not a transition control.

## 12. Region 7 — Closure Actions

### Save Closure Record

Canonical v1.3 primary action:

`Save Closure Record`

Use the existing approved Button component.

Save must:

- validate required fields;
- save the complete Clinical Closure record;
- preserve provider attribution;
- preserve the saved timestamp.

Save must not automatically:

- mutate Shared Visit Visit State;
- close the visit;
- mutate Treatment Planning;
- create a Performed Procedure;
- create Clinical Record History data;
- modify Dental Chart;
- schedule or book follow-up;
- navigate through an unapproved workflow transition.

### Cancel

Canonical secondary action:

`Cancel`

Use the existing approved Button component.

Cancel abandons unsaved closure edits and does not mutate other modules.

### Close Visit

`Close Visit` is not implemented in v1.3.

Any future Close Visit command requires a separate approved interaction contract owned by Shared Visit.

## 13. Editable / read-only matrix

### Editable

- Closure Outcome
- Actual Work / Procedure when applicable and not reference-populated
- Actual Tooth / Site when applicable and not reference-populated
- Actual Surface / Scope when applicable and not reference-populated
- Clinical Closure Summary
- Patient Tolerance when applicable
- Complications / Exceptions when applicable
- Modification Classification
- Modification Reason
- Not Completed Reason
- Next Step / Follow-up Context
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Next Planned Procedure / Next Step

### System-derived/read-only

- Patient
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State
- Provider
- Closure Date / Time
- Treatment Item
- Planned Procedure
- Planned Tooth / Site
- Planned Surface / Scope
- Treatment Status
- Plan Status
- Selected Outcome
- Treatment Context
- Visit Context
- Next Workflow Boundary
- Handoff Status

## 14. Save validation

Minimum validation rules:

1. Closure Outcome is required.
2. Clinical Closure Summary is required.
3. Provider context is required.
4. Closure Date / Time is system-derived and required.
5. Outcome-specific required fields must be complete before save.
6. Missing required fields must block save and identify the missing field/section.
7. Save must not silently discard incomplete data.
8. Cancel must not save the draft.

Examples:

- Completed with Modification without Modification Reason → block save.
- Not Completed without Not Completed Reason → block save.
- Treatment Continues without Remaining Treatment / Continuation Context → block save.
- Any outcome without Clinical Closure Summary → block save.

## 15. Cross-module boundaries

### Shared Visit

Owns Visit State and the `Ready for Closure → Closed` lifecycle transition.

### Treatment Planning

Owns planned treatment context and treatment lifecycle/status.

### Performed Procedure

Owns the complete finalized procedure record. Clinical Closure may reference authoritative data and capture only bounded actual-work context necessary for closure.

### Clinical Workspace

Owns general active clinical documentation. Clinical Closure Summary is closure-specific and is not a replacement notes editor.

### Clinical Record History

Remains the historical presentation boundary. Clinical Closure does not directly edit the history timeline.

## 16. Multi-visit rule

`Treatment Continues` documents continuation of treatment for the current closure record. It does not mean treatment is completed, does not automatically book another visit, and does not automatically change Shared Visit state.

## 17. Design-system invariants

1. Functional Select Field is reused for Closure Outcome.
2. Approved Button is reused for Save Closure Record and Cancel.
3. Approved Multiline Text Field is reused for Clinical Closure Summary.
4. No shared component definition is modified for consumer vocabulary.
5. No shared variant is repurposed for unrelated domain semantics.
6. No design tokens, typography, colors, spacing foundations, or icons are modified.
7. Missing required components must be reported as a preflight blocker rather than solved by ad hoc shared-component modification.

## 18. Explicit exclusions

Out of scope:

- automatic Visit State mutation
- automatic `Close Visit`
- automatic treatment completion
- automatic Treatment Planning modification
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- automatic appointment scheduling
- Dental Chart editing
- general Clinical Workspace note editing
- billing
- insurance
- payments
- claims
- queue management
- messaging
- AI diagnosis
- AI treatment recommendations
- autonomous clinical decision-making
- full revision history

## 19. Frozen gate state

The v1.3 lifecycle is complete:

1. Architecture approval — **APPROVED**
2. Field specification approval — **APPROVED / RECONCILED**
3. Cross-module dependency audit — **PASS**
4. Strict Figma preflight — **PASS**
5. Figma implementation authorization — **AUTHORIZED**
6. Bounded Functional QA construction — **COMPLETE**
7. Functional Prototype QA — **PASS**
8. Structural QA / Visual & UX Audit — **PASS**
9. Final QA — **PASS**
10. Canonicalization / freeze — **AUTHORIZED / COMPLETE**

## 20. Change control after freeze

Any change to this frozen v1.3 field contract requires a new versioned change proposal and the appropriate dependency audit, preflight, implementation authorization, QA, and re-freeze sequence.
