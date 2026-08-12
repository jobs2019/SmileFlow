# Clinical Closure — Architecture & Information Model v1.3 Proposal

## Status

**PROPOSED — NOT APPROVED — NO FIGMA WRITE AUTHORIZED**

This proposal extends the approved Clinical Closure v1.1 architecture toward a clinically useful production-oriented closure record while preserving the existing Option A lifecycle boundary.

The current v1.2 canonical implementation remains the approved baseline until this proposal is explicitly approved.

## 1. Goal

Upgrade Clinical Closure from a closure-outcome selection prototype into a useful structured clinical closure record.

The module should capture what happened during the visit, not merely classify the outcome.

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
    ↓
Closure Outcome + closure record
    ↓
Shared Visit remains lifecycle owner
    ↓
Closed when the Shared Visit workflow explicitly performs closure
```

Clinical Closure does not become the owner of Visit State.

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

### Clinical Closure does not own

- Shared Visit lifecycle
- Treatment Planning lifecycle/status
- general Clinical Workspace documentation
- Performed Procedure as a separate finalized procedure record
- Dental Chart state
- Clinical Record History presentation
- billing
- insurance

## 4. Relationship to Performed Procedure

This proposal introduces a strict distinction between:

**Closure documentation** and **Performed Procedure record ownership**.

Clinical Closure may capture a concise actual-work summary needed to explain the closure decision, but it must not become a second Performed Procedure editor.

If the closure workflow needs a complete finalized procedure record, that record remains owned by Performed Procedure.

The closure fields must therefore be limited to information necessary to explain the current closure decision and should reference existing procedure data wherever possible.

## 5. Core closure record

Every saved closure should contain, at minimum:

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

The system should avoid requiring duplicate entry when authoritative procedure data already exists.

## 6. Conditional outcome behavior

### Completed as Planned

Required:
- Closure Outcome
- Closure Summary
- Provider
- Date / Time

Optional when needed:
- actual procedure
- actual site/scope
- complications
- patient tolerance

### Completed with Modification

Required:
- Closure Outcome
- What changed / modification classification
- Modification Reason
- Closure Summary
- Provider
- Date / Time

The modification must describe the difference between planned and actual work without becoming a replacement Treatment Planning editor.

### Not Completed

Required:
- Closure Outcome
- Not Completed Reason
- Next Step / Follow-up Context when applicable
- Closure Summary
- Provider
- Date / Time

The outcome must not silently mark the treatment as completed.

### Treatment Continues

Required:
- Closure Outcome
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Next Planned Procedure or Next Step when known
- Closure Summary
- Provider
- Date / Time

This explicitly preserves the multi-visit treatment model.

## 7. Clinical Closure Summary

The closure record should contain a structured human-readable summary.

The summary may be generated from structured fields and then reviewed/edited by the dentist.

Example:

> Composite restoration completed on tooth #46, occlusal surface. Procedure completed as planned. Occlusion checked. Patient tolerated procedure well. No complications noted.

The summary is a Clinical Closure record, not a replacement for the general Clinical Workspace notes.

## 8. Provider and timestamp

A saved closure must have attributable authorship and timing.

Minimum metadata:

- Provider
- Created / Saved Date-Time

If the application later supports record revision, revision metadata should be defined separately rather than inferred in this proposal.

## 9. Conditional fields

Conditional fields must appear only when the selected Closure Outcome requires them.

Do not display every possible field simultaneously.

This keeps the closure workflow concise while preserving clinical completeness.

## 10. Save semantics

`Save Closure Outcome` should evolve into a save action for the complete closure record.

The save operation must validate required conditional fields before saving.

Saving the closure record does not automatically mutate Shared Visit Visit State unless a separate approved interaction contract authorizes that behavior.

## 11. Cancel semantics

Cancel abandons unsaved closure edits.

It must not:

- mutate Shared Visit
- mutate Treatment Planning
- create a Performed Procedure
- create Clinical Record History data
- alter Dental Chart state

## 12. Auditability

The closure record should be attributable at save time.

Required minimum audit metadata:

- provider/user
- saved timestamp

A full revision history is out of scope for this proposal unless separately specified.

## 13. Seven-region architecture

The existing seven-region architecture is preserved.

The proposed functional content maps as follows:

1. **Clinical Closure Header** — patient/module identity
2. **Visit Context** — Shared Visit read-only context
3. **Active Treatment Context** — treatment/procedure reference and relevant actual-work context
4. **Closure Outcome** — outcome selection and conditional outcome fields
5. **Closure Context / Summary** — structured closure summary and confirmation
6. **Downstream Handoff** — Shared Visit lifecycle boundary and next-step context
7. **Closure Actions** — Save Closure Record and Cancel

No new top-level region is required.

## 14. Design-system boundary

Use genuine existing SmileFlow components.

Do not modify shared component definitions merely to support Clinical Closure v1.3.

Consumer-owned vocabulary remains consumer-owned.

If a required field or component cannot be represented using existing approved components, stop at preflight and report the blocker.

## 15. Explicit exclusions

This proposal does not authorize:

- automatic Visit State mutation
- automatic `Close Visit`
- Treatment Planning editing
- treatment completion
- Performed Procedure replacement or duplication
- Dental Chart mutation
- Clinical Record History editing
- billing
- insurance
- scheduling
- queue management
- AI diagnosis
- AI-generated clinical decisions
- full audit/revision history

## 16. Proposed Phase 1.3 invariants

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
12. No Figma modification occurs until this proposal is approved, a field specification is approved, and a new preflight passes.

## 17. Required next gates

Before implementation:

1. Approve or revise this v1.3 architecture proposal.
2. Author `FIELD_SPECIFICATION_V1_3.md` from the approved architecture.
3. Run a read-only cross-module dependency audit against v1.3.
4. Run a strict read-first Clinical Closure v1.3 Figma Preflight.
5. Obtain explicit Figma implementation authorization.
6. Implement only the approved bounded changes.
7. Structural QA.
8. Visual/UX Audit.
9. Functional Prototype QA.
10. Final QA.
11. Freeze only after explicit authorization.

## 18. Baseline protection

The current v1.2 canonical implementation remains the baseline while this proposal is under review.

No v1.2 behavior is to be removed or changed merely because this proposal exists.
