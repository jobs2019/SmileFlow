# SmileFlow Phase 2 — Runtime Workflow Contract Consistency Audit v1.0

## Status

**STRUCTURAL CONSISTENCY PASS — IMPLEMENTATION STILL CONDITIONALLY BLOCKED**

Date: 2026-08-13

## Audited sources

1. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
2. `PHASE_2_AUTHENTICATION_AUTHORIZATION_SPECIFICATION_V1.md`
3. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md`
4. `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`
5. Existing approved/frozen module contracts referenced by the repository source-of-truth rules

## Executive result

The Runtime Workflow Contract is structurally consistent with the reconciled Core Data Schema and the Authentication & Authorization model.

No contradiction was found that requires rewriting the core state architecture.

However, the runtime contract intentionally leaves several module-level details unresolved. Those remain blockers for production database/workflow implementation where they affect concrete constraints or transactions.

## 1. State-domain separation — PASS

The runtime contract preserves the schema's required independent domains:

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

No shared generic state enum is introduced.

## 2. Visit lifecycle — PASS

The runtime contract matches the reconciled schema:

```text
Scheduled
→ Checked In
→ Waiting
→ Called
→ In Treatment
→ Ready for Closure
→ Closed
```

The contract correctly treats the visit as the owner of this lifecycle.

No ordinary `Closed → In Treatment` reopening path is introduced.

## 3. Treatment Plan Item lifecycle — PASS

The runtime contract exactly matches the reconciled schema:

```text
Planned
→ Scheduled
→ In Progress
→ Completed
```

The prohibited generic states `Active`, `Cancelled`, and `Archived` are not reintroduced.

## 4. Treatment Plan container — PASS

The schema deliberately has no treatment-plan container lifecycle enum.

The runtime contract does not invent one.

This preserves the reconciliation decision.

## 5. Appointment vs Visit — PASS

Appointment remains a scheduling-domain object.

A completed appointment does not automatically close a visit.

A visit may reference an appointment, and creating a visit from an appointment is an explicit workflow action.

This is consistent with the schema and avoids collapsing scheduled and actual encounters.

## 6. Patient ownership — PASS

Patient Registration creates the canonical Patient entity.

Patient Management operates on the same `patient_id`.

No duplicate patient entity is introduced by runtime behavior.

## 7. Dental Chart ownership — PASS

Dental Chart mutations are restricted to chart-owned findings/tooth state.

The runtime contract explicitly prevents automatic creation of procedures, diagnoses, treatment-plan items, or closure outcomes from a chart mutation unless a future explicit transaction authorizes it.

This matches the schema's module ownership boundary.

## 8. Performed Procedure boundary — PASS WITH DEFERRED DETAIL

The runtime contract correctly maintains:

```text
Planned Treatment Item ≠ Performed Procedure
```

It also avoids inventing a performed-procedure status enum.

The remaining status/finalization semantics are intentionally contract-dependent.

This is not a contradiction, but it prevents final persistence constraints from being authorized yet.

## 9. Clinical Closure — PASS

Closure is correctly treated as a visit-level finalization boundary.

The atomic closure transaction is:

```text
validate current visit state
→ validate closure data
→ record closure outcome
→ attribute actor
→ visit → Closed
→ audit/history
→ commit atomically
```

The runtime contract does not make Closure the owner of unrelated domain lifecycles.

## 10. Cross-module side effects — PASS

The following prohibited implicit transitions are explicitly preserved:

- Procedure Completed ≠ automatically close Visit
- Treatment Item Completed ≠ automatically close Visit
- Visit Closed ≠ automatically complete Treatment Items
- Appointment Completed ≠ automatically close Visit
- Dental Chart Updated ≠ automatically create Procedure
- Diagnosis Created ≠ automatically create Procedure

This is consistent with the schema ownership model.

## 11. Authorization consistency — PASS

The runtime mutation sequence matches the Authentication & Authorization specification:

```text
Authenticate
→ Active Clinic Membership
→ Resource Ownership
→ Permission
→ Current State
→ Valid Transition
→ Validation
→ Atomic Mutation
→ Authorship / Audit
→ Persist
```

The runtime contract does not permit client-supplied author IDs or client-only permission enforcement.

## 12. Clinic isolation — PASS

The runtime context requires server-side resolution of `user_id`, `clinic_id`, `patient_id`, resource, and current state.

This is consistent with the clinic-membership boundary and deny-by-default authorization model.

## 13. Authorship — PASS

Clinical authorship is derived from authenticated server-side identity.

This matches the schema's `created_by`, `updated_by`, `recorded_by`, and `performed_by` concepts and the authorization specification.

## 14. Concurrency — PASS

The optimistic concurrency rule is compatible with independent state machines and prevents stale clients from overwriting newer persisted state.

The exact implementation mechanism remains technology-dependent.

## 15. Idempotency — PASS

The contract requires idempotency for non-repeatable clinical mutations, especially Clinical Closure and Performed Procedure creation/finalization.

No schema contradiction is introduced.

## 16. Atomicity — PASS

The closure transaction explicitly requires atomic persistence of closure outcome, visit closure, and audit/history event.

This is consistent with the schema's Clinical Closure boundary and Audit Event concept.

## 17. Historical integrity — PASS

Clinical Record History remains a read-only projection.

Correction/reopening of closed records is intentionally deferred to a future amendment/correction contract rather than implemented as a generic reverse transition.

## 18. Permission matrix alignment — CONDITIONAL PASS

The Authentication & Authorization specification intentionally contains several permissions marked:

- `where authorized`
- `restricted`
- `limited`
- `explicitly authorized`

The runtime contract correctly requires permission checks but cannot finalize those ambiguous role-to-action mappings without the corresponding module/runtime contracts.

This is a deferred authorization-detail issue, not a state-model contradiction.

## 19. Module contract gaps — CONDITIONAL BLOCKERS

The following remain unresolved and must not be invented during implementation:

1. Patient Registration exact field validation
2. Patient Management exact field permissions
3. Dental Chart exact finding vocabulary
4. Treatment Planning exact field inventory beyond lifecycle
5. Performed Procedure status/finalization semantics
6. Clinical Closure field-level validation
7. Audit-event taxonomy

These are implementation blockers where they affect database constraints, enums, or transaction payloads.

## 20. Important non-contradiction: Treatment Closure Outcome

`Treatment Continues` is a valid Clinical Closure outcome while the visit transitions to `Closed`.

This is not equivalent to keeping the visit open. The outcome records the clinical disposition of the encounter; the Visit State records the lifecycle of that encounter.

Therefore:

```text
Closure Outcome = Treatment Continues
Visit State = Closed
```

is architecturally valid under the current separation rules.

## 21. Scheduling scope — PASS

Appointment workflow is defined as a runtime dependency, but Scheduling UI remains Phase 5.

The runtime contract does not accidentally authorize Phase 5 scheduling implementation.

## 22. Excluded scope — PASS

The contract does not introduce:

- HMO / insurance
- billing
- financial workflows
- inventory
- laboratory management
- autonomous clinical recommendations

HMO/insurance remains explicitly excluded.

## 23. Overall decision

### Structural consistency

**PASS**

The runtime workflow contract is consistent with:

- reconciled Core Data schema;
- Authentication & Authorization architecture;
- canonical Patient ownership;
- independent clinical state domains;
- Clinical Closure boundaries;
- existing experience-first governance.

### Implementation readiness

**NOT YET AUTHORIZED**

The architecture is consistent, but unresolved module-level contracts still prevent final production persistence/workflow authorization.

## Current Phase 2 gate

```text
Core Data Dependency Audit                    PASS
Core Data Schema Specification                PASS
Schema Consistency Audit v2                   PASS
Authentication / Authorization Specification  PASS
Authentication / Authorization Audit          PASS
Runtime Workflow Contract                     PASS
Runtime Workflow Consistency Audit            PASS

Technology / Backend Decision                 NEXT
Database / RLS Implementation Specification   REQUIRED
Explicit Database Implementation Authorization REQUIRED
```

## Governing decision

> **The runtime state architecture is approved as structurally consistent. Do not modify the core state machines merely to resolve deferred field-level contracts. Resolve those contracts explicitly before implementation.**

No database, Supabase, authentication, Figma, or application changes are authorized by this audit.
