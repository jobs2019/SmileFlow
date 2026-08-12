# SmileFlow Phase 2 — Core Data Schema Consistency Audit v2

## Status

**PASS WITH IMPLEMENTATION CONDITIONS — RECONCILED SCHEMA IS INTERNALLY CONSISTENT**

Date: 2026-08-13

## Purpose

Perform a second read-only consistency audit against `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md` after the decisions recorded in `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`.

This audit verifies that the two material conflicts found in v1.0 have been removed and that the reconciliation did not introduce new ownership, lifecycle, identity, or cross-module contradictions.

This audit does not authorize database implementation.

## Authority reviewed

- `SOURCE_OF_TRUTH.md`
- `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
- `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`
- Existing approved/frozen module contracts and recovered runtime boundaries

## Executive result

The v1.1 schema is structurally consistent with the reconciliation decisions.

The two material v1.0 conflicts are resolved:

1. Treatment-plan item lifecycle now uses the authoritative four-state lifecycle.
2. Patient Registration and Patient Management now share one canonical Patient entity.

No new ownership contradiction was found.

However, the schema remains a **reconciled proposal**, not a production database contract. Several field-level and runtime decisions remain intentionally deferred because authoritative module specifications are incomplete or because they belong to later gates.

## Audit matrix

| Area | Result | Finding |
|---|---|---|
| Canonical Patient identity | PASS | One `patient_id`; no duplicate registration/management entity |
| Patient Registration ownership | PASS | Creation/capture boundary is separated from persistence identity |
| Patient Management ownership | PASS | Management/presentation does not create a second patient entity |
| Appointment vs Visit | PASS | Distinct entities and semantics preserved |
| Visit lifecycle | PASS | Seven-state lifecycle retained |
| Treatment-plan item lifecycle | PASS | Exactly Planned → Scheduled → In Progress → Completed |
| Treatment-plan container lifecycle | PASS | No invented status enum |
| Treatment Plan vs Performed Procedure | PASS | Planning and actual work remain separate |
| Procedure Definition vs Performed Procedure | PASS | Catalog/definition remains distinct from event |
| Dental Chart ownership | PASS | Tooth/chart state remains within Dental Chart boundary |
| Clinical Workspace ownership | PASS | No separate clinical source-of-truth created |
| Clinical Closure ownership | PASS | Closure Outcome remains distinct from Visit State and treatment lifecycle |
| Clinical Record History | PASS | Read projection, not mutable duplicate store |
| Tooth-level structure | PASS | Structured tooth identity retained |
| Clinic boundary | PASS | `clinic_id` remains the tenant boundary |
| Authorship/timestamps | PASS | Clinical mutations retain attribution requirements |
| HMO/insurance | PASS | Explicitly excluded |

## 1. Treatment Planning lifecycle audit

### v1.0 defect

The earlier schema used generic lifecycle values that conflicted with the authoritative Treatment Planning contract.

### v1.1 result

`planned_item.status` is now exactly:

```text
Planned
Scheduled
In Progress
Completed
```

The prohibited generic values are explicitly excluded:

```text
Active
Cancelled
Archived
```

### Decision

**PASS.**

The treatment-plan item lifecycle no longer conflicts with the recovered module contract.

### Container status

`Treatment Plan` has no clinical lifecycle enum in v1.1.

This is correct because the recovered contract establishes the item lifecycle and does not authorize a separate container lifecycle.

**PASS.**

## 2. Patient ownership audit

### v1.0 risk

Patient Registration and Patient Management both referenced patient identity and could have been misinterpreted as separate persistence owners.

### v1.1 result

The specification explicitly establishes:

```text
Patient Registration
        ↓
Canonical Patient
        ↓
Patient Management
```

Both use the same immutable `patient_id`.

No duplicate persistence entity is authorized.

**PASS.**

## 3. Appointment / Visit audit

The schema continues to distinguish:

- Appointment = expected/scheduled interaction.
- Visit = actual clinical encounter.

An appointment may exist without a visit, and a visit may optionally reference an appointment.

No lifecycle or ownership collision was introduced.

**PASS.**

## 4. Visit lifecycle audit

The Visit entity retains the approved lifecycle:

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

The schema explicitly prevents this state from being reused as treatment status or closure outcome.

The transition matrix is correctly deferred to the Runtime Workflow Contract.

**PASS.**

## 5. Treatment vs performed work audit

The model remains:

```text
Treatment Plan
   ↓
Planned Treatment Item

Visit
   ↓
Performed Procedure
```

A completed planned item does not replace the performed procedure record.

**PASS.**

## 6. Procedure Definition vs Performed Procedure

The schema retains a reusable procedure definition/catalog concept separately from actual clinical events.

This allows historical performed records to retain clinical meaning without making them dependent on mutable catalog records.

**PASS.**

## 7. Dental Chart audit

Dental Chart remains responsible for persistent chart/tooth state and tooth-condition presentation.

The schema provides a structured Tooth reference and a Dental Chart Finding boundary without transferring ownership of:

- treatment planning;
- performed procedures;
- closure;
- clinical history;
- general clinical documentation.

The exact finding vocabulary remains deferred to the Dental Chart contract.

**PASS WITH CONDITION.**

Condition: do not finalize finding columns/enums until the authoritative Dental Chart field contract is reconciled.

## 8. Clinical Workspace audit

Clinical Workspace is explicitly described as a visit-scoped working surface rather than a new source-of-truth entity.

It operates on records owned by the relevant domains.

This prevents the common failure mode of creating a generic `clinical_workspace` table that duplicates patient, visit, procedure, and note data.

**PASS.**

## 9. Clinical Closure audit

Closure Outcome remains:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

The schema keeps closure separate from:

- Visit State
- Treatment Plan Item Status
- Performed Procedure Status

**PASS.**

## 10. Clinical Record History audit

Clinical Record History remains a read-only projection.

No independent mutable history entity is introduced as a competing source of truth.

**PASS.**

## 11. Tooth-level audit

The schema uses a structured `Tooth` entity with:

- patient reference;
- notation system;
- tooth code;
- dentition.

This supports FDI references such as `11` and `46` without requiring every clinical record to reference a tooth.

The design correctly allows whole-mouth events and tooth-specific events.

**PASS.**

## 12. Clinic / tenant boundary audit

Core entities retain a clinic boundary where required.

Patient identity is clinic-scoped and cannot be silently reassigned across clinics.

User access is mediated through clinic membership rather than implicit global access.

**PASS.**

## 13. Authorship and timestamps

Clinical mutations retain authorship and timestamp requirements.

This is structurally compatible with the later audit trail and authorization specifications.

The exact audit-event taxonomy remains deferred and does not create an inconsistency in the schema.

**PASS WITH CONDITION.**

Condition: final mutation/audit semantics must be defined before production implementation.

## 14. Explicit state separation

The reconciled schema explicitly separates:

```text
Visit State
    ≠
Treatment Plan Item Status
    ≠
Performed Procedure Status
    ≠
Closure Outcome
```

No shared generic status field is used to collapse these concepts.

**PASS.**

## 15. Scope audit

The schema explicitly excludes:

- HMO / insurance;
- billing / financial workflows;
- inventory;
- laboratory management;
- patient messaging campaigns;
- AI clinical decision-making;
- autonomous clinical recommendations;
- speculative clinical modules.

This matches the current product scope.

**PASS.**

## 16. Remaining conditions before database implementation

The audit passes structurally, but the following are not yet production-authorized:

### A. Missing authoritative field contracts

The exact field inventories remain unresolved for:

- Patient Registration;
- Patient Management;
- Dental Chart;
- Treatment Planning.

These must be reconciled before final database columns and constraints are frozen where they depend on those contracts.

### B. Runtime workflow contract

The database schema does not itself define legal visit transitions or clinical transaction sequences.

That belongs to the Runtime Workflow Contract.

### C. Authentication / authorization

The schema identifies users, memberships, and roles, but does not yet define the final permission matrix or enforcement policy.

### D. Technology-specific persistence

No database engine, Supabase schema, RLS policy, migration, or API contract is authorized yet.

### E. File storage

Document metadata is in scope, but the storage-provider and access contract remain deferred.

### F. Audit taxonomy

The schema reserves audit events but does not yet define the complete event vocabulary and retention behavior.

## Final verdict

# 🟢 STRUCTURAL CONSISTENCY PASS

The reconciled v1.1 schema no longer contains the material conflicts identified in v1.0.

The core ownership and lifecycle boundaries are internally consistent.

## Important qualification

This is **not** a database implementation authorization.

The result is:

> **Schema architecture is consistent enough to proceed to the next Phase 2 contracts.**

It is not:

> "Create the database now."

## Next authorized gate

Proceed to:

> **SmileFlow Phase 2 — Authentication & Authorization Specification**

That specification must establish:

- authentication boundary;
- user/session model;
- clinic membership;
- roles;
- permissions;
- resource access rules;
- cross-clinic isolation;
- clinical mutation authorization;
- account lifecycle;
- audit implications.

After that, proceed to the Runtime Workflow Contract, technology decision, and only then database implementation authorization.

## Protected scope

No Figma changes are required.

No frozen clinical module should be modified.

`06 — Layouts` remains untouched.

HMO/insurance remains excluded.

**Final decision: the reconciled Core Data Schema passes v2 consistency audit and may proceed to the Authentication & Authorization specification gate.**
