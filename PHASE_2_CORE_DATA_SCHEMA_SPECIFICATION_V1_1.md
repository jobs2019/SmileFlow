# SmileFlow Phase 2 — Core Data Schema Specification v1.1

## Status

**RECONCILED PROPOSAL — NOT DATABASE-IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-13

## Purpose

This document is the reconciled v1.1 schema specification derived from `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1.md` and the decisions recorded in `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`.

It resolves the material schema conflicts discovered during runtime-contract recovery while preserving all other v1.0 schema boundaries unless explicitly amended below.

It is still a specification, not a SQL migration, database implementation, authentication implementation, or Supabase authorization policy.

## Governing authority

The following are authoritative for this reconciliation:

1. Current user-approved SmileFlow architecture decisions.
2. `SOURCE_OF_TRUTH.md`.
3. Current approved/frozen module contracts.
4. `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`.
5. This reconciled specification v1.1.

Historical Figma implementation evidence is not sufficient to invent missing runtime fields.

## Scope

### Included

- Clinic / organization boundary
- User and clinic membership / role context
- Canonical Patient entity
- Patient Registration and Patient Management ownership boundaries
- Appointments
- Visits
- Dental Chart / tooth state
- Clinical notes
- Diagnoses
- Treatment Planning
- Performed Procedures
- Clinical Closure
- Clinical Record History as a read projection
- Documents / attachments
- Audit events

### Explicitly excluded

- HMO / insurance
- Billing / financial workflows
- Inventory
- Laboratory management
- Patient messaging campaigns
- AI clinical decision-making
- Autonomous clinical recommendations
- Speculative clinical modules

## Reconciliation changes from v1.0

### Change 1 — Treatment-plan item lifecycle

The treatment-plan item lifecycle is now exactly:

```text
Planned → Scheduled → In Progress → Completed
```

The following are **not** treatment-plan-item lifecycle values:

- Active
- Cancelled
- Archived

Those values must not be reintroduced without a future approved Treatment Planning architecture decision.

### Change 2 — Treatment-plan container status

The v1.0 `treatment_plan.status` field is removed from the canonical schema because the authoritative Treatment Planning contract establishes the lifecycle for treatment-plan items, not a separate container lifecycle.

The container therefore has no clinical lifecycle enum in v1.1.

If a future implementation requires an administrative container state, that must be introduced as a separately named, explicitly approved concept. The item lifecycle must never be reused for that purpose.

### Change 3 — Patient ownership

There is exactly **one canonical Patient entity**.

Patient Registration owns the registration/creation/capture workflow and its approved registration fields.

Patient Management owns patient-level management presentation, summaries, and navigation within its approved scope.

Both modules reference the same immutable `patient_id`.

No registration-patient or management-patient duplicate persistence entity is permitted.

### Change 4 — Patient field restraint

The schema retains only patient fields already established as safe core identity fields. Exact registration-specific fields remain contract-dependent and must not be invented.

This includes, but is not limited to:

- contact structures;
- emergency-contact structures;
- patient-level alerts;
- registration review fields;
- registration action fields;
- additional demographics.

## Core entity model

```text
Clinic
  │
  ├── Users / Memberships / Roles
  │
  └── Patients
        │
        ├── Appointments
        │      │
        │      └── Visit (optional result)
        │
        ├── Visits
        │      │
        │      ├── Clinical Notes
        │      ├── Diagnoses
        │      ├── Performed Procedures
        │      ├── Dental Chart / Tooth Findings
        │      └── Clinical Closure
        │
        ├── Treatment Plans
        │      └── Planned Treatment Items
        │
        ├── Documents / Attachments
        │
        └── Clinical Record History (read projection)
```

## Canonical entities retained from v1.0

### 1. Clinic

`clinic_id` UUID primary key.

Required core fields remain:

- `clinic_id`
- `name`
- `status`
- `created_at`
- `updated_at`

### 2. User

`user_id` UUID primary key.

Required core fields remain:

- `user_id`
- `email`
- `display_name`
- `status`
- `created_at`
- `updated_at`

Authentication credentials remain owned by the authentication provider and are not stored in the application-domain user record.

### 3. Clinic Membership / Role

`membership_id` UUID primary key.

Required core relationships:

- `clinic_id` → Clinic
- `user_id` → User
- `role` → Dentist / Dental Assistant / Receptionist / Administrator
- `status`
- `created_at`
- `updated_at`

Cross-clinic access must never be implicit.

### 4. Patient

`patient_id` UUID primary key and immutable longitudinal identity.

Core fields:

- `patient_id`
- `clinic_id`
- `patient_number`
- `first_name`
- `middle_name` optional
- `last_name`
- `suffix` optional
- `birth_date` optional until registration contract requires it
- `sex` optional controlled value if collected
- `status` — Active / Archived
- `created_at`
- `created_by`
- `updated_at`
- `updated_by`

Integrity:

- `patient_id` is immutable.
- `patient_number` is unique within a clinic.
- A patient cannot be silently reassigned to another clinic.
- Registration and Management share this same entity.
- Registration-specific fields must not be invented until the authoritative field specification is reconciled.

### 5. Appointment

Appointment remains distinct from Visit.

Core fields remain:

- `appointment_id`
- `clinic_id`
- `patient_id`
- `provider_user_id` optional
- `scheduled_start`
- `scheduled_end` optional
- `appointment_type`
- `status` — Scheduled / Confirmed / Completed / Cancelled / No Show
- non-clinical scheduling `notes` optional
- `created_at`
- `created_by`
- `updated_at`
- `updated_by`

An appointment may exist without a visit. A visit may be created from an appointment.

Scheduling UI remains Phase 5 and is not authorized by this schema specification.

### 6. Visit

Visit remains the actual clinical encounter and owner of the approved visit lifecycle.

Core fields remain:

- `visit_id`
- `clinic_id`
- `patient_id`
- `appointment_id` optional
- `provider_user_id` optional
- `visit_date`
- `visit_type`
- `chair` optional
- `visit_state`
- authorship/timestamps

Approved visit lifecycle:

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

The transition matrix remains a separate Runtime Workflow Contract.

### 7. Clinical Note

Narrative clinical documentation associated with a visit.

Core relationships:

- patient
- visit
- author

Structured diagnoses, procedures, and tooth findings must not be stored only as free-form note text.

### 8. Diagnosis

Structured clinical assessment associated with a visit.

Core relationships:

- patient
- visit
- optional tooth
- recording user

Diagnosis vocabulary/coding remains a separate clinical vocabulary decision.

### 9. Tooth

Structured patient tooth reference.

Core fields remain conceptually:

- `tooth_id`
- `patient_id`
- `notation_system`
- `tooth_code`
- `dentition`
- `created_at`

The schema must support structured FDI references such as `11` and `46` without forcing every clinical event to reference a tooth.

### 10. Dental Chart Finding

Persistent chart state/finding owned by Dental Chart.

Core relationships:

- clinic
- patient
- optional tooth
- finding type/value
- recorded/updated authorship and timestamps

The exact finding vocabulary remains owned by the authoritative Dental Chart contract.

### 11. Treatment Plan — RECONCILED

Purpose: longitudinal planned care for a patient.

Canonical fields:

| Field | Required | Rule |
|---|---:|---|
| `treatment_plan_id` | Yes | UUID primary key |
| `clinic_id` | Yes | FK → Clinic |
| `patient_id` | Yes | FK → Patient |
| `title` | Yes | Plan display name |
| `created_at` | Yes | Required |
| `created_by` | Yes | FK → User |
| `updated_at` | Yes | Required |
| `updated_by` | Yes | FK → User |

**There is intentionally no `treatment_plan.status` field in v1.1.**

Reason: the authoritative Treatment Planning contract defines the lifecycle of treatment-plan items, not a separate plan-container lifecycle.

### 12. Planned Treatment Item — RECONCILED

Purpose: individual planned treatment within a treatment plan.

Canonical fields:

| Field | Required | Rule |
|---|---:|---|
| `planned_item_id` | Yes | UUID primary key |
| `treatment_plan_id` | Yes | FK → Treatment Plan |
| `patient_id` | Yes | FK → Patient |
| `procedure_definition_id` | No | Optional FK → Procedure Definition |
| `description` | Yes | Planned treatment description |
| `tooth_id` | No | Optional FK → Tooth |
| `status` | Yes | Exactly: Planned / Scheduled / In Progress / Completed |
| `sequence` | No | Ordering within plan |
| `created_at` | Yes | Required |
| `created_by` | Yes | FK → User |
| `updated_at` | Yes | Required |
| `updated_by` | Yes | FK → User |

The item lifecycle is authoritative and must not include `Cancelled`, `Archived`, or generic `Active` unless a future approved architecture explicitly changes the contract.

A completed planned item does not replace a performed procedure record.

### 13. Procedure Definition

Reusable controlled procedure definition/catalog entry.

Core fields remain:

- `procedure_definition_id`
- `clinic_id`
- optional `code`
- `name`
- `status` — Active / Inactive
- `created_at`
- `updated_at`

This is not a clinical event.

### 14. Performed Procedure

Actual clinical work, distinct from planned treatment.

Core relationships:

- patient
- visit
- optional procedure definition
- optional tooth
- performing user

The event remains subject to its existing finalized/draft/error contract and the later Runtime Workflow Contract.

### 15. Clinical Closure

Clinical Closure remains a visit-level closure boundary.

Closure Outcome remains distinct from Visit State and Treatment Planning lifecycle.

Canonical closure outcomes:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

The exact closure persistence transaction remains subject to the Runtime Workflow Contract.

### 16. Clinical Record History

Clinical Record History remains a read-only longitudinal projection.

It is not an independent mutable source-of-truth entity.

### 17. Documents / Attachments

Documents remain associated with the relevant clinic/patient/clinical context according to the later file-storage contract.

Exact storage-provider details are deferred.

### 18. Audit Events

Audit events remain immutable traceability records for authorized mutations and other explicitly audited actions.

The exact event taxonomy is deferred to the Audit Trail specification.

## Cross-module ownership invariants

### Patient Registration

Owns registration/creation/capture workflow and its approved registration fields.

### Patient Management

Owns patient-level management presentation, summary, and navigation within approved scope.

### Dental Chart

Owns permanent tooth/chart state and tooth-condition presentation.

It does not own treatment planning, performed procedures, clinical closure, clinical history, or general clinical documentation.

### Treatment Planning

Owns treatment-plan items and their lifecycle:

```text
Planned → Scheduled → In Progress → Completed
```

It does not own visit state, clinical documentation, closure outcome, performed-procedure details, historical chronology, billing, or insurance.

### Shared Visit

Owns visit identity and visit lifecycle.

### Clinical Workspace

Owns neither patient identity nor a separate clinical database. It is a visit-scoped working surface that operates on the domain records owned by the appropriate modules.

### Performed Procedure

Owns finalized actual clinical work.

### Clinical Closure

Owns closure outcome.

### Clinical Record History

Owns read-only historical presentation.

## Explicit state separation

The schema must preserve these independent concepts:

```text
Visit State
    ≠
Treatment Plan Item Status
    ≠
Performed Procedure Status
    ≠
Closure Outcome
```

No database enum may be reused across these domains merely because labels look similar.

## Implementation constraints

This v1.1 specification does **not** authorize:

- SQL migrations
- Supabase tables
- RLS policies
- authentication implementation
- application persistence
- Figma modifications
- scheduling implementation
- billing
- HMO/insurance

## Remaining contract-dependent fields

The following remain intentionally unresolved until authoritative module specifications are reconciled:

- Patient Registration exact field inventory
- Patient Management exact field inventory
- Dental Chart exact finding vocabulary and field inventory
- Treatment Planning exact container/item field inventory beyond the recovered lifecycle
- Clinical diagnosis vocabulary
- Procedure catalog vocabulary
- File/document storage contract
- Audit-event taxonomy
- Runtime transition/transaction rules
- Authorization matrix

These are not blockers to the **schema reconciliation audit**, but they are blockers to final database implementation authorization if they affect concrete tables, constraints, or persistence behavior.

## Reconciliation status

| Area | v1.1 result |
|---|---|
| Single canonical Patient entity | **RESOLVED** |
| Registration vs Management ownership | **RESOLVED** |
| Treatment-plan item lifecycle | **RESOLVED** |
| Treatment-plan container lifecycle | **DEFERRED — no invented enum** |
| Dental Chart ownership | **CONFIRMED** |
| Treatment Planning ownership | **CONFIRMED** |
| Visit lifecycle separation | **CONFIRMED** |
| Closure separation | **CONFIRMED** |
| HMO / insurance | **EXCLUDED** |

## Next gate

Run:

> **SmileFlow Phase 2 — Core Data Schema Consistency Audit v2**

The v2 audit must verify that this reconciled specification no longer contains the conflicts identified in v1.0 and that no new cross-module ownership contradiction was introduced.

**Database implementation remains unauthorized until the v2 audit and subsequent authentication/authorization, runtime workflow, technology, and implementation-authorization gates are complete.**
