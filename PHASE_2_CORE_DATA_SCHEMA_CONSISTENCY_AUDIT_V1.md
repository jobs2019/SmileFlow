# SmileFlow Phase 2 — Core Data Schema Consistency Audit v1

## Status

**PASS WITH CONDITIONS — SCHEMA STRUCTURE IS INTERNALLY COHERENT; IMPLEMENTATION REMAINS BLOCKED BY CONTRACT-RECOVERY AND RUNTIME GATES**

Date: 2026-08-12

## Audit scope

Read-only review of `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1.md` against:

- `APPLICATION_ARCHITECTURE.md`
- `APPLICATION_RUNTIME_CONTRACT_AUDIT_V1.md`
- the approved nine-module baseline and known ownership boundaries
- the strict SmileFlow execution roadmap

No database, migration, Supabase schema, Figma change, or application code was created.

## Executive verdict

The proposed schema is structurally consistent with the current SmileFlow architecture. The core separations are preserved:

- Patient identity vs Visit
- Appointment vs Visit
- Visit State vs Treatment Status vs Closure Outcome
- Treatment Plan vs Performed Procedure
- Procedure Definition vs Performed Procedure
- Clinical Note vs structured clinical data
- Dental Chart findings vs narrative notes
- Clinical Record History vs authoritative mutation store
- Audit Event vs authoritative domain record

However, the schema is **not yet implementation-authorized** because four module-specific contract gaps remain:

1. Patient Registration
2. Patient Management
3. Dental Chart
4. Treatment Planning

Those authoritative field contracts must be recovered/reconciled before final database columns and constraints are frozen.

## Consistency matrix

| Area | Result | Finding |
|---|---|---|
| Patient identity | PASS | Stable `patient_id` and clinic ownership preserved |
| Clinic tenancy | PASS | `clinic_id` is consistently carried through domain entities |
| User/auth boundary | PASS | Credentials remain outside domain table; membership owns clinic role |
| Appointment vs Visit | PASS | Separate entities and optional appointment→visit relationship |
| Visit lifecycle | PASS | Seven-state lifecycle preserved |
| Clinical notes | PASS | Visit-scoped narrative record, not structured-data substitute |
| Diagnoses | PASS | Structured, visit-scoped, optional tooth reference |
| Tooth model | PASS WITH CONDITION | Structured tooth identity is correct; exact Dental Chart vocabulary remains unresolved |
| Dental findings | PASS WITH CONDITION | Ownership is correct; exact finding fields remain unresolved |
| Treatment plans | PASS WITH CONDITION | Planned care is separated from performed work; exact module contract remains unresolved |
| Planned treatment items | PASS | Correct child relationship to Treatment Plan |
| Procedure definition | PASS | Catalog/definition separated from clinical event |
| Performed procedure | PASS | Visit-scoped actual work; distinct from planning |
| Clinical closure | PASS | Exactly four closure outcomes and visit-scoped 0..1 relationship |
| Clinical history | PASS | Projection/read boundary preserved |
| Documents | PASS | Metadata/reference in DB, binary content in controlled storage |
| Audit events | PASS | Append-only traceability model separated from domain records |
| Referential integrity | PASS WITH CONDITION | Same-clinic/same-patient rules are explicit; implementation constraints remain to be specified |
| Status separation | PASS | No global status enum proposed |
| Timestamps/authorship | PASS WITH CONDITION | Baseline is consistent; exact timezone and mutation policy still belong to runtime contract |
| Deletion/archive | PASS WITH CONDITION | Principle is correct; entity-by-entity policy still required |
| Runtime transactions | PASS WITH CONDITION | Boundaries are identified but not yet authoritative |

## Findings

### 1. Patient identity boundary — PASS

The schema correctly makes `patient_id` the longitudinal anchor and requires `clinic_id` ownership. This matches the application architecture and prevents visits or clinical modules from becoming patient identity owners.

### 2. Clinic membership — PASS

The proposed `Clinic Membership / Role` model correctly separates authentication identity from clinic authorization context. It also supports a future multi-clinic user without silently granting cross-clinic access.

The product scope remains single-clinic-per-practice in the current experience, but a clinic tenant boundary is an architectural security requirement and is not equivalent to building a multi-branch product.

### 3. Appointment vs Visit — PASS WITH SEQUENCING CONDITION

The schema correctly separates an expected appointment from an actual clinical visit.

However, **Scheduling is Phase 5 in the strict product roadmap**. Therefore:

- the appointment entity may remain in the schema as a dependency/reference;
- appointment implementation, scheduling UI, calendar behavior, and notification behavior must not begin during Phase 2;
- the Runtime Workflow Contract must define how an optional appointment can create/link to a visit.

This is not a schema contradiction; it is a sequencing constraint.

### 4. Visit lifecycle — PASS

The schema preserves the approved seven-state lifecycle:

`Scheduled → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed`

The schema correctly states that the transition matrix belongs to the Runtime Workflow Contract rather than being inferred from enum values alone.

### 5. Clinical Note — PASS

A note is correctly represented as narrative clinical documentation attached to a visit and authored by a user.

The schema correctly prevents notes from becoming the only representation of diagnosis, procedure, or tooth-level information.

### 6. Diagnosis — PASS WITH VOCABULARY CONDITION

The relationship is correct. Exact diagnosis vocabulary/coding is intentionally unresolved.

No coding system should be hard-coded until the clinical vocabulary contract is explicitly approved.

### 7. Tooth and Dental Chart — PASS WITH DOCUMENTATION CONDITION

The schema correctly requires structured tooth identity and supports tooth-level and whole-mouth findings.

However, the repository audit previously identified the absence of authoritative current Dental Chart Architecture/Field Specification artifacts. Therefore the schema must not be treated as the final Dental Chart field contract yet.

Specifically, these remain unresolved:

- exact finding types;
- exact finding value representation;
- tooth state semantics;
- chart-history mutation semantics;
- primary/secondary dentition coverage;
- whether tooth records are persistent entities or derived references in the final implementation.

The current schema is therefore a safe architectural placeholder, not a final Dental Chart contract.

### 8. Treatment Planning — PASS WITH DOCUMENTATION CONDITION

The schema correctly separates:

`Treatment Plan → Planned Treatment Item → Performed Procedure`

A completed planned item must not overwrite the actual performed event.

The remaining blocker is the known absence of a current authoritative Treatment Planning Architecture/Field Specification pair. Exact planned-item fields, statuses, ordering, and treatment-plan semantics must be reconciled before implementation.

### 9. Procedure Definition vs Performed Procedure — PASS

This is a strong architectural separation.

The reusable procedure definition is not the historical clinical event. A performed procedure can preserve a description/snapshot even if the underlying procedure definition later changes.

### 10. Clinical Closure — PASS

The schema correctly preserves exactly four Closure Outcome values:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

Closure is correctly represented as `Visit 0..1 → Clinical Closure` for the current baseline.

**Condition:** reopening/reclosure behavior remains undefined and must be resolved in the Runtime Workflow Contract before database constraints are finalized.

### 11. Clinical Record History — PASS

The schema correctly refuses to create a second mutable source-of-truth table merely for the Records screen.

History should be derived from authoritative domain records and/or immutable event/audit information.

This preserves the read-only ownership boundary established for Clinical Record History.

### 12. Documents — PASS

The schema keeps binary files out of the relational domain model and stores a controlled storage reference instead.

The exact storage implementation is intentionally deferred to the technology decision and storage architecture.

### 13. Audit Event — PASS

The append-only audit model is consistent with the production hardening requirements.

`metadata` is correctly described as non-authoritative. Audit events must not become the source of truth for clinical data.

### 14. Referential integrity — PASS WITH IMPLEMENTATION CONDITION

The same-clinic/same-patient constraints are clearly stated.

The eventual database implementation must enforce these constraints rather than relying only on application code.

Exact SQL/RLS mechanisms remain implementation-specific and are not authorized by this audit.

### 15. Status separation — PASS

The schema correctly avoids a universal status enum.

This protects important distinctions such as:

- Patient Status
- Appointment Status
- Visit State
- Treatment Plan Status
- Planned Item Status
- Performed Procedure Status
- Closure Outcome
- Document Status

This is consistent with the existing SmileFlow clinical ownership model.

### 16. Timestamps and authorship — PASS WITH RUNTIME CONDITION

The baseline fields are consistent and appropriate.

Before implementation, the Runtime Workflow Contract must establish:

- UTC/local-time policy;
- server vs client timestamp authority;
- mutation attribution;
- edit behavior;
- concurrency/versioning rules.

### 17. Deletion and archive — PASS WITH POLICY CONDITION

The schema correctly rejects casual destructive deletion of clinical records.

The next gate must assign an explicit policy to each entity:

- immutable;
- editable with audit;
- archivable;
- entered-in-error correction;
- deletable only when non-clinical and legally permitted.

### 18. Runtime transactions — PASS WITH WORKFLOW CONDITION

The schema identifies sensible transaction boundaries for:

- patient creation;
- visit creation;
- clinical work recording;
- visit closure.

But transaction ordering, rollback, idempotency, and concurrency are not yet authoritative.

Those belong to the Runtime Workflow Contract.

## Cross-module consistency

The proposed schema preserves the application dependency chain:

```text
Patient
  ↓
Visit
  ↓
Clinical Workspace / Notes
  ├── Dental Chart Findings
  ├── Diagnoses
  ├── Treatment Planning
  └── Performed Procedure
          ↓
   Clinical Closure
          ↓
 Clinical Record History
```

Treatment planning does not own performed work.

Clinical closure does not own visit lifecycle.

Clinical history does not own mutations.

The dashboard and Product Shell remain derived/navigation surfaces rather than data owners.

## Strict roadmap consistency

The schema is consistent with the six-phase roadmap provided that implementation is sequenced correctly:

### Phase 1 — Product Shell

Already complete.

### Phase 2 — Core Data

Current phase. Schema definition is appropriate.

### Phase 3 — Existing modules become real

The schema provides candidate persistence boundaries for the nine approved modules, but module-specific field contracts must be reconciled first.

### Phase 4 — Production behavior

State transitions, persistence transactions, audit trail, permissions, and file storage remain later gates.

### Phase 5 — Clinic operations

Scheduling/appointments are represented as a data dependency but **must not be implemented as a scheduling feature during Phase 2**.

HMO/insurance remains excluded.

### Phase 6 — Production hardening

Security, backup, recovery, performance, accessibility, testing, deployment, and monitoring remain later work.

## Conditions before schema approval

The schema should **not yet be marked implementation-ready**. The following must be resolved:

1. Recover/reconcile authoritative Patient Registration contract.
2. Recover/reconcile authoritative Patient Management contract.
3. Recover/reconcile authoritative Dental Chart contract.
4. Recover/reconcile authoritative Treatment Planning contract.
5. Define Runtime Workflow Contract.
6. Define Authentication / Authorization Specification.
7. Define entity-level deletion/archive/correction policy.
8. Define timezone and concurrency/versioning rules.
9. Resolve reopening/reclosure behavior for Clinical Closure.
10. Make the final database-specific referential-integrity and tenant-isolation design after the technology decision.

## Audit verdict

### 🟢 STRUCTURAL CONSISTENCY: PASS

### 🟡 IMPLEMENTATION READINESS: BLOCKED BY CONDITIONS

There is **no identified architectural contradiction requiring the schema to be discarded or redesigned**.

The remaining work is contract completion and runtime governance, not another schema redesign.

## Next proper task

> **SmileFlow Phase 2 — Runtime Contract Recovery & Reconciliation for Patient Registration, Patient Management, Dental Chart, and Treatment Planning**

After those four contracts are reconciled, re-run the schema consistency audit. Only then should the schema advance toward implementation authorization.

## Protected scope

- No Figma changes.
- No `06 — Layouts` cleanup.
- No clinical redesign.
- No database implementation.
- No Supabase schema.
- No HMO/insurance.
- No speculative product features.

The experience-first principle remains active: **we build the agreed product before redesigning it based on speculation.**
