# Shared Visit ↔ Clinical Closure — Lifecycle Contract v1.0

## Status

**APPROVED — repository architecture reconciliation**

This contract resolves the Phase 1 dependency between Shared Visit and Clinical Closure. It is an architecture-level contract only. It does not authorize a Figma write or production runtime implementation.

## 1. Core ownership

### Shared Visit owns

- Visit lifecycle
- Current Visit State
- transition from `In Treatment` to `Ready for Closure`
- transition from `Ready for Closure` to `Closed`

### Clinical Closure owns

- Closure Outcome
- closure record
- closure classification
- the user-facing closure workflow and closure-record save action

Clinical Closure does not become the owner of Visit State.

## 2. Entry condition

Clinical Closure is entered only when the authoritative Shared Visit state is:

`Ready for Closure`

The previous Clinical Closure demonstration state `In Treatment` is superseded by this contract for future specification/implementation work.

## 3. Phase 1 lifecycle

```text
Shared Visit
In Treatment
    ↓
Shared Visit
Ready for Closure
    ↓
Clinical Closure
select Closure Outcome
    ↓
Save Closure Record
    ↓
Closure record recorded
    ↓
Shared Visit lifecycle may proceed to Closed
```

The `Save Closure Record` action does not, by this contract alone, authorize automatic mutation of Shared Visit.

## 4. Close Visit ownership distinction

The repository architecture identifies `Close Visit` as a possible future Clinical Closure user-facing command while Shared Visit remains the authoritative owner of the resulting lifecycle state.

Therefore:

- Clinical Closure may own a future user-facing closure command only through a separately approved interaction specification.
- Shared Visit owns the state transition `Ready for Closure → Closed`.
- The command must not introduce a second Visit State owner.
- The command must not directly edit or duplicate Shared Visit's lifecycle model.

No `Close Visit` control is added to the current Clinical Closure implementation by this contract.

## 5. Closure outcome independence

Closure Outcome is not a Shared Visit state and is not a Treatment Planning status.

Authorized Closure Outcomes remain:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

`Treatment Continues` may coexist with a later closed visit. Closing a visit does not imply that the treatment plan is completed.

## 6. Treatment ownership

Treatment Planning continues to own treatment lifecycle/status.

Performed Procedure continues to own actual procedure information.

Clinical Closure does not complete treatment merely because a Closure Outcome is selected or saved.

## 7. Historical ownership

Clinical Record History remains the read-only historical presentation boundary.

This contract does not define the backend/event mechanism by which a finalized procedure becomes historical record data.

## 8. Current Clinical Closure implementation implication

The current canonical Clinical Closure implementation was built using the earlier demonstration context `Visit State = In Treatment`. This contract does not silently modify that Figma implementation.

Before any Figma change, the repository specifications must be reconciled and a new Clinical Closure Figma Preflight must pass.

## 9. Required follow-up

Before implementing this contract in Figma:

1. Update Clinical Closure architecture to use `Ready for Closure` as the entry state.
2. Update Clinical Closure field specification demonstration state accordingly.
3. Reconcile any conflicting Shared Visit language.
4. Re-run the Cross-Module Dependency Audit.
5. If the audit passes, run a new Clinical Closure Figma Preflight.
6. Obtain explicit implementation authorization before modifying the canonical Clinical Closure composition.

## 10. Non-goals

This contract does not define:

- backend persistence
- API behavior
- database schema
- automatic downstream navigation
- automatic visit-state mutation after Save
- treatment completion behavior
- Performed Procedure creation
- Clinical Record History creation
- billing or insurance behavior

Those require separate approved specifications.
