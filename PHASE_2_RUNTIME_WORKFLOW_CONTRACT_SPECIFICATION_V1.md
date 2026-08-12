# SmileFlow Phase 2 — Runtime Workflow Contract Specification v1.0

## Status

**PROPOSED — NOT IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-13

## Purpose

Define the allowed runtime transitions and cross-module transaction boundaries for the core SmileFlow clinical workflow before database implementation.

This contract connects:

```text
Authenticated User
      ↓
Clinic Membership / Permission
      ↓
Allowed Action
      ↓
Domain State Transition
      ↓
Persisted Result
      ↓
Audit / History
```

It does not implement any workflow, database transaction, API, or Figma behavior.

## Governing principles

1. **A state belongs to one domain.** Visit state, treatment-plan-item status, performed-procedure status, and closure outcome must never be treated as one shared state machine.
2. **Every mutation is permission-gated.** Authentication alone never authorizes a clinical mutation.
3. **Invalid transitions are rejected.** The client may prevent an invalid action for UX, but the authoritative runtime must reject it as well.
4. **Clinical authorship comes from the authenticated server-side identity.** Client-supplied author IDs are not trusted.
5. **Cross-module writes are explicit.** One module must not silently mutate another module's owned state.
6. **Clinical history is append/trace oriented.** Historical facts must not be silently rewritten to make the current state look correct.
7. **Closure is a transaction boundary.** Clinical Closure may validate and finalize the relevant visit context but does not become owner of unrelated domain lifecycles.
8. **No inferred state transitions.** A completed procedure does not automatically mean the visit is closed; a treatment-plan item becoming completed does not automatically create or close a visit.
9. **Idempotency matters.** Retried mutation requests must not duplicate clinical events.
10. **Failure is atomic at the transaction boundary.** A rejected clinical mutation must not leave a partially applied cross-module state.

## Runtime context

Every clinical mutation must resolve the following context server-side:

```text
user_id
clinic_id
patient_id
optional visit_id
required domain resource
required action
current persisted state
```

The runtime must verify that the authenticated user has an active clinic membership and the permission required for the requested action.

## Workflow domains

The contract defines five independent state domains:

1. Appointment
2. Visit
3. Treatment Plan Item
4. Performed Procedure
5. Clinical Closure

Their states are intentionally independent.

```text
Appointment State
      ≠
Visit State
      ≠
Treatment Plan Item Status
      ≠
Performed Procedure Status
      ≠
Closure Outcome
```

## 1. Appointment workflow

Appointment is a scheduling-domain object, not a clinical encounter.

### States

```text
Scheduled
Confirmed
Completed
Cancelled
No Show
```

### Allowed transitions

```text
Scheduled → Confirmed
Scheduled → Cancelled
Scheduled → No Show
Scheduled → Completed

Confirmed → Completed
Confirmed → Cancelled
Confirmed → No Show

Completed → [terminal for normal scheduling workflow]
Cancelled → [terminal]
No Show → [terminal]
```

The exact scheduling UI and reminder behavior are Phase 5 concerns.

### Visit relationship

An appointment may exist without a visit.

A visit may reference an appointment, but the existence or completion of an appointment must not by itself close a visit.

Creating a visit from an appointment is an explicit workflow action.

## 2. Visit workflow

Visit is the actual patient encounter and owns the visit lifecycle.

### Canonical states

```text
Scheduled
   ↓
Checked In
   ↓
Waiting
   ↓
Called
   ↓
In Treatment
   ↓
Ready for Closure
   ↓
Closed
```

### Allowed transitions

```text
Scheduled → Checked In
Checked In → Waiting
Waiting → Called
Called → In Treatment
In Treatment → Ready for Closure
Ready for Closure → Closed
```

### Controlled recovery transitions

The runtime may support operational recovery transitions such as returning from `Called` to `Waiting` or from `Ready for Closure` back to `In Treatment` only if the approved Shared Visit / Clinical Workspace runtime contract explicitly authorizes them.

They must not be invented by the database implementation.

### Invalid transition examples

The following are invalid unless a future approved contract explicitly changes them:

```text
Scheduled → In Treatment
Scheduled → Closed
Waiting → Closed
Called → Closed
Closed → In Treatment
Closed → Ready for Closure
```

A closed visit is not reopened through an ordinary client action. Any correction/reopening mechanism requires an explicit future correction workflow.

## 3. Treatment Plan Item workflow

Treatment Planning owns the lifecycle of an individual planned treatment item.

### Canonical lifecycle

```text
Planned
   ↓
Scheduled
   ↓
In Progress
   ↓
Completed
```

### Allowed transitions

```text
Planned → Scheduled
Scheduled → In Progress
In Progress → Completed
```

No `Active`, `Cancelled`, or `Archived` status is permitted in this lifecycle under the current contract.

### Important independence rule

A treatment-plan item may become `Completed` only through its own authorized workflow.

It does not automatically:

- close the visit;
- complete the treatment plan container;
- create a diagnosis;
- create a performed procedure unless the explicit workflow transaction says so;
- change the Dental Chart.

Likewise, a visit state change does not automatically advance a treatment-plan item.

## 4. Performed Procedure workflow

A Performed Procedure represents actual clinical work, not planned intent.

### Required distinction

```text
Planned Treatment Item
        ≠
Performed Procedure
```

A performed procedure must be associated with the relevant patient and visit and, where applicable, procedure definition and tooth.

### Runtime rule

Creation/finalization of a performed procedure requires the appropriate clinical permission and a valid active visit context unless the authoritative procedure contract explicitly permits another context.

### Status

The reconciled schema intentionally does not invent a final performed-procedure status machine beyond the approved module contract.

Therefore:

- do not create a new enum in implementation;
- do not reuse Visit State;
- do not reuse Treatment Plan Item Status;
- finalize/draft/error semantics remain contract-dependent until the Performed Procedure runtime contract is authoritative.

### Independence

A completed performed procedure does not automatically close the visit.

A performed procedure does not automatically complete a treatment-plan item unless the explicit transaction contract maps the two records.

## 5. Clinical Closure workflow

Clinical Closure is the finalization boundary for a visit, not a replacement for the Visit lifecycle.

### Closure outcomes

```text
Completed as Planned
Completed with Modification
Not Completed
Treatment Continues
```

### Preconditions

Clinical Closure may only be committed when:

1. the acting user is authenticated;
2. the acting user has active membership in the visit's clinic;
3. the acting user has Clinical Closure permission;
4. the visit exists and is accessible;
5. the visit is in `Ready for Closure` unless a future approved contract explicitly allows another source state;
6. required closure fields are valid;
7. the closure operation has not already been committed.

### Closure transaction

The closure transaction must:

1. verify current visit state;
2. validate required clinical/closure data;
3. record the closure outcome;
4. attribute the mutation to the authenticated user;
5. transition the visit to `Closed`;
6. record the appropriate audit/history event;
7. commit atomically.

If any required step fails, the transaction must not leave the visit partially closed.

### Closure does not own

Clinical Closure must not independently mutate:

- appointment lifecycle;
- treatment-plan item lifecycle;
- Dental Chart ownership state;
- unrelated historical records;
- billing or insurance state.

If closure needs to cause another domain mutation, that must be an explicitly approved cross-module transaction.

## 6. Cross-module clinical workflow

The intended high-level workflow is:

```text
Appointment (optional)
        ↓
Visit Created
        ↓
Scheduled
        ↓
Checked In
        ↓
Waiting
        ↓
Called
        ↓
In Treatment
        ↓
Clinical Workspace
   ┌────┼─────────┐
   ↓    ↓         ↓
Chart  Diagnosis Procedure
              ↓
        Treatment Planning
        (when applicable)
              ↓
      Ready for Closure
              ↓
      Clinical Closure
              ↓
            Closed
```

This diagram describes dependency/context, not automatic state transitions.

## 7. Patient Registration workflow

Patient Registration creates the canonical Patient entity.

### Preconditions

- authenticated user;
- active clinic membership;
- registration permission;
- required authoritative registration fields valid;
- no conflicting patient identity under the approved duplicate-detection rules.

### Result

A new canonical `patient_id` is created.

Patient Management, Dental Chart, Visits, Treatment Planning, and Clinical Records subsequently reference that same `patient_id`.

Registration must not create a duplicate patient entity for another module.

## 8. Patient Management workflow

Patient Management operates on the canonical Patient entity.

It may perform approved patient-level updates without creating a second patient identity.

Field-level update permissions remain subject to the final Patient Management contract.

## 9. Dental Chart workflow

Dental Chart mutations operate on persistent patient/tooth findings.

### Rule

```text
Patient
  ↓
Tooth
  ↓
Dental Chart Finding
```

A chart mutation must:

- resolve the patient and clinic server-side;
- verify chart permission;
- validate tooth reference where applicable;
- preserve authorship and timestamps;
- create/update only chart-owned state.

Dental Chart mutations do not automatically create procedures, diagnoses, treatment-plan items, or closure outcomes unless an explicit approved transaction says so.

## 10. Treatment Planning workflow

Treatment Planning creates and updates treatment plans and planned treatment items.

### Creation

```text
Patient
  ↓
Treatment Plan
  ↓
Planned Treatment Item
```

### Lifecycle mutation

Each item transition requires:

- authenticated user;
- active clinic membership;
- treatment-planning permission;
- current status matches the expected source state;
- requested next state is an allowed transition.

### Concurrency rule

A transition must be based on the current persisted item status. If another transaction changes the status first, the stale transition must fail rather than overwrite the newer state.

## 11. Performed Procedure workflow

The actual procedure workflow is:

```text
Visit
  ↓
Clinical Work
  ↓
Performed Procedure
  ↓
Persisted clinical event
```

Where a planned treatment item exists, the relationship may be referenced, but the planned item and performed event remain separate records.

A procedure performed without a matching planned item must not be rejected merely because no plan exists unless the authoritative clinical contract explicitly requires a plan.

## 12. Clinical Record History workflow

Clinical Record History is read-only.

It consumes persisted domain events/records and must not mutate the source records merely by being viewed.

Historical ordering should be derived from authoritative timestamps and event relationships rather than manually maintained duplicate chronology.

## 13. Permission gate for mutations

Every mutation follows:

```text
Request
  ↓
Authenticate
  ↓
Resolve active clinic membership
  ↓
Resolve resource ownership
  ↓
Check permission
  ↓
Read current state
  ↓
Validate transition
  ↓
Validate required fields
  ↓
Apply authorized mutation atomically
  ↓
Record authorship / audit event
  ↓
Return persisted result
```

Failure at any gate stops the mutation.

## 14. Optimistic concurrency

For state transitions, the runtime must prevent stale clients from overwriting newer state.

Conceptually:

```text
UPDATE resource
SET state = requested_next_state
WHERE id = resource_id
  AND state = expected_current_state
```

If zero rows are affected, the transition must be treated as stale/conflicting and the client must reload current state.

The exact database mechanism is implementation-dependent.

## 15. Idempotency

Actions that create clinical events or closure records must be safe against duplicate submission/retry.

At minimum, the implementation must provide a server-side idempotency strategy for:

- Clinical Closure commit;
- Performed Procedure creation/finalization;
- other mutation endpoints later identified as non-repeatable.

A double-click or network retry must not create two identical clinical events.

## 16. Error categories

The runtime should distinguish at least:

### Authentication failure

No valid authenticated identity.

### Authorization failure

Authenticated but not permitted.

### Clinic boundary failure

Authenticated and possibly authorized generally, but not a member of the resource's clinic.

### Resource not found / inaccessible

The resource cannot be accessed under the caller's authorized scope.

### Invalid transition

The requested state change is not permitted from the current state.

### Validation failure

Required data is missing or invalid.

### Concurrency conflict

The persisted state changed before the requested mutation could commit.

### Duplicate/idempotency conflict

The requested event has already been committed.

### Persistence failure

The transaction could not be safely committed.

The client must not translate all of these into a generic success/failure response if doing so would cause unsafe retries or incorrect state assumptions.

## 17. Transaction boundaries

### Single-domain mutation

A simple update to a single owned resource should commit atomically.

### Cross-module mutation

If one user action intentionally changes multiple domains, the operation must use an explicit transaction or reliable orchestration mechanism.

Example:

```text
Clinical Closure
  ├── closure outcome
  ├── visit → Closed
  └── audit event
```

These must either all commit or none commit.

No best-effort sequence of independent client writes is acceptable for a production clinical transaction.

## 18. What is explicitly NOT automatic

The following are prohibited unless an explicit future contract authorizes them:

```text
Procedure Completed
    ≠ automatically close Visit

Treatment Item Completed
    ≠ automatically close Visit

Visit Closed
    ≠ automatically complete all Treatment Items

Appointment Completed
    ≠ automatically close Visit

Dental Chart Updated
    ≠ automatically create Procedure

Diagnosis Created
    ≠ automatically create Procedure
```

This prevents hidden cross-module side effects.

## 19. Reopening / correction

The current contract does not authorize ordinary reopening of a closed visit.

Corrections to closed clinical records require a dedicated future correction/amendment contract with:

- explicit permission;
- reason;
- authorship;
- audit trail;
- preservation of the original historical fact.

No implementation may add a generic `reopen` button or `Closed → In Treatment` transition without that authorization.

## 20. Notifications and external effects

Notifications, billing, document processing, and other external side effects are not part of the core clinical transaction unless explicitly authorized by their later module contracts.

Core clinical state must not depend on an unreliable external notification completing successfully.

## 21. Runtime contracts intentionally deferred

The following remain separate specifications:

- exact Patient Registration field validation;
- exact Patient Management field permissions;
- exact Dental Chart finding vocabulary;
- exact Treatment Planning field inventory beyond the reconciled lifecycle;
- exact Performed Procedure status/finalization contract;
- exact Clinical Closure field-level validation;
- Scheduling UI/workflow;
- file/document storage;
- notification delivery;
- audit-event taxonomy;
- production security hardening;
- provider-specific authentication behavior.

These omissions are intentional and must not be filled by implementation guesswork.

## Implementation constraints

This specification does **not** authorize:

- SQL migrations;
- Supabase schema creation;
- RLS policies;
- authentication-provider configuration;
- API implementation;
- Figma modifications;
- clinical workflow implementation;
- scheduling implementation;
- billing or HMO/insurance.

## Readiness gate

Before database implementation authorization, the following must pass:

1. Core Data Schema Consistency Audit v2 — **passed**
2. Authentication & Authorization Consistency Audit — **passed**
3. Runtime Workflow Contract Consistency Audit — **required**
4. Technology / Backend Decision — **required**
5. Database / RLS Implementation Specification — **required**
6. Explicit Database Implementation Authorization — **required**

## Governing principle

> **No state transition without permission, no cross-module mutation without an explicit contract, no clinical transaction without atomic persistence, and no implementation guesswork where the authoritative contract is still unresolved.**
