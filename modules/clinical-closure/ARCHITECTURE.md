# Clinical Closure — Architecture & Information Model v1.1

## Status

**APPROVED — architecture reconciliation**

This architecture incorporates the approved Shared Visit ↔ Clinical Closure lifecycle contract.

It does not authorize a Figma write by itself.

## 1. Purpose

Clinical Closure is the workflow boundary used to classify the outcome of the current clinical treatment/visit after Shared Visit reaches `Ready for Closure` and before the visit lifecycle proceeds to `Closed`.

It receives current clinical and visit context as read-only reference data and owns the closure outcome classification.

## 2. Ownership

### Clinical Closure owns
- closure outcome classification
- closure decision for the current clinical context
- selected closure outcome
- user-facing closure decision/command within the Clinical Closure workflow when separately authorized

### Clinical Closure may reference
- Patient identity
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Current Visit State
- Active treatment
- Tooth / treatment scope
- Treatment Status
- Current clinical documentation
- Planned treatment/procedure context

Referenced values remain read-only.

### Clinical Closure does not own
- patient registration
- Dental Chart state
- treatment-plan creation/editing
- treatment lifecycle management
- Visit State / Shared Visit lifecycle
- appointment or queue lifecycle
- active clinical documentation
- performed-procedure details
- procedure surfaces/outcomes
- historical clinical chronology
- billing
- insurance

## 3. Entry Condition

Clinical Closure is entered only when the authoritative Shared Visit state is:

`Ready for Closure`

The previous demonstration state `In Treatment` is superseded for future Clinical Closure specification and implementation work.

The current canonical Figma implementation is not silently modified by this architecture document. Any Figma update requires a new preflight and explicit implementation authorization.

## 4. Canonical Closure Outcomes

The approved Clinical Closure outcomes are:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

These are closure classifications. They must not be represented as Treatment Planning lifecycle states or Shared Visit states.

## 5. Relationship to Shared Visit

Shared Visit owns the authoritative visit lifecycle:

Scheduled → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed

Clinical Closure does not own Visit State.

The Phase 1 dependency is:

```text
Shared Visit
In Treatment
    ↓
Shared Visit
Ready for Closure
    ↓
Clinical Closure
Closure Outcome
    ↓
closure decision recorded
    ↓
Shared Visit may proceed to Closed
```

Saving a Closure Outcome does not, by this architecture alone, authorize automatic Shared Visit mutation.

### Close Visit distinction

The architecture permits Clinical Closure to own a future user-facing `Close Visit` command while Shared Visit remains the authoritative owner of the resulting state transition `Ready for Closure → Closed`.

No `Close Visit` control is authorized in the current canonical implementation by this document alone.

## 6. Relationship to Treatment Planning

Treatment Planning owns the treatment lifecycle. Clinical Closure does not directly edit treatment lifecycle/status.

Selecting or saving a Closure Outcome must not silently mutate Treatment Planning unless a later approved workflow explicitly defines that transition.

## 7. Relationship to Clinical Workspace

Clinical Workspace owns active clinical work and current documentation. Clinical Closure receives that context as reference information and must not duplicate the Clinical Workspace documentation workflow.

## 8. Relationship to Performed Procedure

Performed Procedure owns finalized actual procedure information. Clinical Closure must not become the Performed Procedure editor.

## 9. Relationship to Clinical Record History

Clinical Record History owns historical chronology. Clinical Closure is a current workflow boundary, not a historical timeline.

## 10. Seven-Region Information Architecture

The canonical Phase 1 composition uses exactly seven top-level regions:

1. Clinical Closure Header
2. Visit Context
3. Active Treatment Context
4. Closure Outcome
5. Closure Context / Summary
6. Downstream Handoff
7. Closure Actions

Region 2 must present `Ready for Closure` when Clinical Closure is entered under this architecture.

## 11. Information Flow

```text
Clinical Workspace
      ↓
Performed Procedure
      ↓
Shared Visit → Ready for Closure
      ↓
Clinical Closure
      ↓
Shared Visit lifecycle → Closed
      ↓
Clinical Record History
```

This is a conceptual ownership/dependency model. It does not define backend persistence or automatic navigation.

## 12. State Semantics

### Visit state
`Ready for Closure` — owned by Shared Visit.

### Treatment state
`In Progress` in the treatment-context example unless separately approved — owned by Treatment Planning.

### Closure outcome
One of the four authorized outcomes — owned by Clinical Closure.

These concepts must remain visually and semantically distinct.

## 13. Multi-Visit Rule

`Treatment Continues` preserves the possibility that treatment extends beyond the current visit. Closing the current visit does not imply treatment completion.

## 14. Safety Boundaries

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

## 15. Prototype Boundary

Phase 1 contains only explicitly approved local prototype behavior.

No prototype or production behavior may invent:

- automatic treatment completion
- automatic procedure creation
- automatic history creation
- automatic Visit State mutation
- automatic cross-module navigation

Any future `Close Visit` interaction requires a separate approved interaction specification defining how the user-facing command invokes the Shared Visit-owned lifecycle transition.

## 16. Design-System Boundary

Clinical Closure must reuse existing SmileFlow components. Do not modify component definitions, component sets, variants, variables, styles, tokens, typography foundations, or icons.

If a required component is unavailable or incompatible, stop before making Figma changes and report the exact blocker.

## 17. Phase 1 Invariants

1. Exactly one canonical Clinical Closure composition.
2. Exactly seven top-level regions.
3. Existing components are reused as genuine instances.
4. Closure outcomes remain distinct from treatment lifecycle states and Visit State.
5. Clinical Closure entry state is `Ready for Closure`.
6. Shared Visit remains the sole owner of Visit State and visit lifecycle.
7. `Treatment Continues` preserves multi-visit treatment.
8. No Clinical Workspace documentation editor is duplicated.
9. No Performed Procedure editor is introduced.
10. No Clinical Record History timeline is introduced.
11. No Dental Chart or Treatment Planning mutation is introduced.
12. Frozen modules remain untouched unless a separate Architecture Exception is approved.
13. No design-system definitions are modified.
14. No Phase 2 behavior is introduced.
15. No `Close Visit` implementation is authorized solely by this architecture update.

## 18. Implementation Gate

Before any Figma implementation change:

1. Reconcile the field specification with this architecture.
2. Re-run the Cross-Module Dependency Audit.
3. Run a new Clinical Closure Figma Preflight.
4. Confirm protected/frozen nodes.
5. Obtain explicit implementation authorization.
6. Perform structural QA.
7. Perform Visual & UX Audit.
8. Perform Final QA.
9. Freeze only after separate explicit authorization.

No Figma changes are authorized by this architecture reconciliation alone.
