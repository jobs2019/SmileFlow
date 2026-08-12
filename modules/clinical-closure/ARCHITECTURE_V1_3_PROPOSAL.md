# Clinical Closure — Architecture & Information Model v1.3

## Status

**APPROVED — IMPLEMENTED — FINAL QA DOCUMENTATION RECONCILED**

Clinical Closure v1.3 architecture is approved for the bounded Figma implementation and Functional QA construction authorized by `V1_3_APPROVAL.md`.

The v1.2 canonical implementation was protected during implementation. The v1.3 Figma work was performed as the explicitly authorized bounded construction, with no authorization for production/backend behavior or automatic cross-module mutation.

This document is now the authoritative architecture record for Clinical Closure v1.3. The historical proposal status is retained only as repository history; it is no longer the current gate state.

## Approval and implementation boundary

Approved:

- Clinical Closure v1.3 architecture
- Four canonical Closure Outcome values
- Structured closure-record model
- Seven-region architecture
- Existing SmileFlow component reuse
- Bounded Figma Functional QA construction
- Functional QA coverage for outcome and validation behavior

Not authorized by this document:

- production/backend implementation
- database/API behavior
- automatic Shared Visit mutation
- automatic `Close Visit`
- automatic Treatment Planning mutation
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- automatic scheduling/navigation
- AI diagnosis or autonomous clinical decisions
- full revision-history implementation

## 1. Goal

Upgrade Clinical Closure from a closure-outcome selection prototype into a useful structured clinical closure record.

The module captures what happened during the visit without taking ownership of Shared Visit lifecycle, Treatment Planning, Performed Procedure, Clinical Workspace, Dental Chart, or Clinical Record History.

## 2. Preserved lifecycle architecture

The approved Option A lifecycle remains unchanged:

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
Closed when the Shared Visit workflow explicitly performs closure
```

Clinical Closure does not become the owner of Visit State.

Saving a closure record does not automatically change Shared Visit Visit State.

## 3. Ownership

### Clinical Closure owns

- Closure Outcome
- Actual Procedure / clinical work summary captured specifically for closure
- Actual Tooth / Site when required for closure documentation
- Actual Surface / Scope when required
- Clinical Closure Summary / note
- Complications / exceptions recorded at closure
- Patient Tolerance
- Conditional modification reason
- Conditional not-completed reason
- Conditional continuation context
- Provider attribution for the closure record
- Closure record timestamp

### Clinical Closure references read-only

- Patient identity
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State
- Treatment Item
- Planned Procedure
- Planned Tooth / Site
- Planned Surface / Scope
- Treatment Status
- Current clinical context
- Authoritative Performed Procedure data when available

### Clinical Closure does not own

- Shared Visit lifecycle
- Treatment Planning lifecycle/status
- general Clinical Workspace documentation
- Performed Procedure as a separate finalized procedure record
- Dental Chart state
- Clinical Record History presentation
- billing
- insurance
- scheduling
- queue management

## 4. Relationship to Performed Procedure

Clinical Closure maintains a strict distinction between closure documentation and Performed Procedure record ownership.

Clinical Closure may capture a concise actual-work summary needed to explain the closure decision, but it must not become a second Performed Procedure editor.

If authoritative Performed Procedure data exists, Clinical Closure should reference it rather than require duplicate entry.

## 5. Core closure record

Every saved closure contains, at minimum:

1. Closure Outcome
2. Clinical Closure Summary
3. Provider
4. Closure Date / Time

Where clinically relevant, the closure record may additionally contain:

5. Actual Procedure / Work Performed
6. Actual Tooth / Site
7. Actual Surface / Scope
8. Complications / Exceptions
9. Patient Tolerance

## 6. Conditional outcome behavior

### Completed as Planned

Required:
- Closure Outcome
- Actual Work / Procedure when work occurred
- Clinical Closure Summary
- Provider
- Date / Time

### Completed with Modification

Required:
- Closure Outcome
- Actual Work / Procedure
- Modification Classification
- Modification Reason
- Closure Summary
- Provider
- Date / Time

### Not Completed

Required:
- Closure Outcome
- Not Completed Reason
- Closure Summary
- Provider
- Date / Time

If partial clinical work occurred, bounded Actual Work / Procedure documentation is required/reference-populated.

### Treatment Continues

Required:
- Closure Outcome
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Closure Summary
- Provider
- Date / Time

Next Planned Procedure / Next Step is captured when known.

## 7. Clinical Closure Summary

The closure record contains a concise human-readable summary.

The summary may be generated from captured structured values and then reviewed and edited by the provider before save.

It is a Clinical Closure record, not a replacement for general Clinical Workspace notes.

## 8. Provider and timestamp

A saved closure is attributable at save time.

Minimum metadata:

- Provider/user
- Saved timestamp

Full revision history is out of scope and requires a separate approved specification.

## 9. Conditional fields

Only fields relevant to the selected Closure Outcome appear in the user workflow.

The implementation must not display every possible outcome-specific field simultaneously.

## 10. Save semantics

The canonical v1.3 action is:

`Save Closure Record`

Save validates the complete closure record and records the Clinical Closure data.

Save does not automatically mutate Shared Visit Visit State or any other module unless a future separately approved interaction contract authorizes that behavior.

## 11. Cancel semantics

Cancel abandons unsaved closure edits.

It does not:

- mutate Shared Visit
- mutate Treatment Planning
- create a Performed Procedure
- create Clinical Record History data
- alter Dental Chart state

## 12. Seven-region architecture

Exactly seven top-level regions remain:

1. **Clinical Closure Header** — patient/module identity
2. **Visit Context** — Shared Visit read-only context
3. **Active Treatment Context** — treatment/procedure reference and relevant actual-work context
4. **Closure Outcome** — outcome selection and conditional outcome fields
5. **Closure Context / Summary** — structured closure summary and confirmation
6. **Downstream Handoff** — Shared Visit lifecycle boundary and next-step context
7. **Closure Actions** — Save Closure Record and Cancel

No new top-level region is required for v1.3 conditional fields.

## 13. Design-system boundary

Use genuine existing SmileFlow components.

No shared component definitions, variants, variables, styles, tokens, typography, or icons are modified for Clinical Closure-specific vocabulary.

The approved implementation uses:

- Functional Select Field for Closure Outcome
- approved Button component for Save Closure Record and Cancel
- approved Multiline Text Field for Clinical Closure Summary
- existing field/text patterns for read-only and conditional context

## 14. Explicit exclusions

This architecture does not authorize:

- automatic Visit State mutation
- automatic `Close Visit`
- Treatment Planning editing
- treatment completion
- Performed Procedure replacement or duplication
- Dental Chart mutation
- Clinical Record History editing/creation
- billing
- insurance
- scheduling
- queue management
- AI diagnosis
- AI-generated clinical decisions
- full audit/revision history

## 15. v1.3 invariants

1. Option A lifecycle remains intact.
2. Shared Visit remains sole owner of Visit State.
3. Closure Outcome remains owned by Clinical Closure.
4. The closure record captures useful clinical context rather than only an outcome label.
5. Conditional fields appear according to outcome.
6. Clinical Closure Summary is attributable and timestamped.
7. Existing Performed Procedure ownership is preserved.
8. No duplicate general clinical notes editor is created.
9. Exactly seven top-level regions remain.
10. Existing design-system components remain unchanged.
11. No automatic downstream lifecycle mutation is introduced.
12. The v1.3 Figma implementation remains bounded by the approved QA authorization.

## 16. Gate state

The v1.3 gate sequence is now:

1. v1.3 architecture approval — **APPROVED**
2. Field specification approval — **APPROVED / RECONCILED**
3. Cross-module dependency audit — **PASS**
4. Strict Figma preflight — **PASS**
5. Figma implementation authorization — **AUTHORIZED**
6. Functional QA construction — **COMPLETE**
7. Functional Prototype QA — **PASS**
8. Structural / Visual QA — **PASS**
9. Final QA — **PENDING DOCUMENTATION RECONCILIATION COMPLETION**
10. Canonicalization / freeze — **NOT YET AUTHORIZED**

The remaining gate is documentation consistency, not an architectural or Figma blocker.

## 17. Historical baseline protection

The v1.2 canonical implementation was protected during the v1.3 work.

No v1.2 behavior was removed merely because v1.3 was introduced.

The approved v1.3 construction does not authorize production runtime behavior.
