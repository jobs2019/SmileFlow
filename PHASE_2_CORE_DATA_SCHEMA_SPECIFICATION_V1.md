# SmileFlow Phase 2 — Core Data Schema Specification v1.0

## Status

**PROPOSED — SCHEMA SPECIFICATION / NOT DATABASE-IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-12

## Purpose

Define the canonical relational data model required to turn the approved SmileFlow Figma baseline into a working application while preserving the existing clinical domain ownership boundaries.

This document is a **schema specification**, not a SQL migration and not a database implementation authorization.

It defines:

- entities;
- identifiers;
- relationships;
- ownership;
- cardinality;
- lifecycle/status concepts;
- timestamps and authorship;
- integrity rules;
- archive/deletion principles;
- cross-module references.

It does not select a concrete database engine or create tables.

## Governing principles

1. **Domain first, UI second.** Database entities must represent durable business/clinical concepts, not Figma screens.
2. **Stable patient identity.** A patient remains the same patient across visits and over time.
3. **Appointment and Visit are distinct.** An appointment represents expected attendance; a visit represents an actual clinical encounter.
4. **Planned treatment and performed work are distinct.** A treatment plan must not be overwritten by completed procedures.
5. **Visit state, treatment status, and closure outcome are distinct concepts.**
6. **Clinical history is a projection/read boundary, not a second mutation store.**
7. **Tooth-level information must be structured.** Tooth references must not depend only on free-form text.
8. **Authorship and timestamps are mandatory for clinical mutations.**
9. **Clinical records must not be casually destructively deleted.** Archive/retention behavior must be explicit.
10. **No schema may be invented for excluded product areas.** HMO/insurance is excluded.

## Product scope

### Included core domains

- Clinic / organization boundary
- User and role context
- Patient registration and identity
- Patient management
- Appointments
- Visits
- Dental chart
- Clinical notes
- Diagnoses
- Treatment planning
- Performed procedures
- Clinical closure
- Clinical record history
- Attachments/documents
- Audit events

### Explicitly excluded

- HMO / insurance
- AI clinical decision-making
- Autonomous clinical recommendations
- Billing / financial workflows
- Inventory
- Laboratory management
- Patient messaging campaigns
- Multi-branch expansion
- Speculative clinical modules

## Schema overview

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
        └── Clinical History (projection)
```

## 1. Clinic

### Purpose

Tenant/practice boundary for SmileFlow data access.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `clinic_id` | UUID | Yes | Primary key |
| `name` | text | Yes | Clinic display name |
| `status` | enum | Yes | Active/inactive |
| `created_at` | timestamp | Yes | Immutable creation timestamp |
| `updated_at` | timestamp | Yes | Last mutation timestamp |

### Ownership

Clinic owns the tenant boundary. Clinical records belong to a clinic through their patient/visit ownership chain.

## 2. User

### Purpose

Authenticated application identity.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `user_id` | UUID | Yes | Primary key |
| `email` | text | Yes | Authentication identity; uniqueness governed by auth system |
| `display_name` | text | Yes | Application display name |
| `status` | enum | Yes | Active/inactive |
| `created_at` | timestamp | Yes | Required |
| `updated_at` | timestamp | Yes | Required |

Authentication credentials are **not** stored in the application domain table. The selected authentication provider owns credential material.

## 3. Clinic Membership / Role

### Purpose

Connect a user to a clinic and establish authorization context.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `membership_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `user_id` | UUID | Yes | FK → User |
| `role` | enum | Yes | Dentist / Dental Assistant / Receptionist / Administrator |
| `status` | enum | Yes | Active/inactive |
| `created_at` | timestamp | Yes | Required |
| `updated_at` | timestamp | Yes | Required |

A user may have multiple clinic memberships in the future, but cross-clinic access must never be implicit.

## 4. Patient

### Purpose

Stable longitudinal patient identity.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `patient_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_number` | text | Yes | Clinic-scoped human-readable identifier |
| `first_name` | text | Yes | Required |
| `middle_name` | text | No | Optional |
| `last_name` | text | Yes | Required |
| `suffix` | text | No | Optional |
| `birth_date` | date | No | Optional until registration rules require it |
| `sex` | enum | No | Controlled value if collected |
| `status` | enum | Yes | Active/archived |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

### Integrity

- `patient_id` is immutable.
- `patient_number` must be unique within a clinic.
- A patient cannot be silently reassigned to another clinic.

Contact information and additional registration fields should be normalized into a separate patient-contact structure if the approved Patient Registration specification requires multiple contact methods. The schema must not invent duplicate contact fields without that contract.

## 5. Appointment

### Purpose

Expected/scheduled interaction with a patient.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `appointment_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `provider_user_id` | UUID | No | FK → User |
| `scheduled_start` | timestamp | Yes | Required |
| `scheduled_end` | timestamp | No | Required if duration model is used |
| `appointment_type` | text/controlled ref | Yes | Clinic-configurable definition |
| `status` | enum | Yes | Scheduled / Confirmed / Completed / Cancelled / No Show |
| `notes` | text | No | Non-clinical scheduling note |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

### Integrity

An appointment may exist without a visit. A visit may be created from an appointment, but the runtime must preserve the distinction.

## 6. Visit

### Purpose

Actual patient clinical encounter and owner of the approved visit lifecycle.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `visit_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `appointment_id` | UUID | No | FK → Appointment |
| `provider_user_id` | UUID | No | FK → User |
| `visit_date` | timestamp | Yes | Encounter timestamp |
| `visit_type` | text/controlled ref | Yes | Approved visit type contract |
| `chair` | text/controlled ref | No | Chair/resource context |
| `visit_state` | enum | Yes | Controlled lifecycle |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

### Visit lifecycle

The approved baseline lifecycle is:

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

Runtime implementation must preserve the distinction between:

- `visit_state`;
- treatment status;
- closure outcome.

The exact allowed transition matrix belongs to the Runtime Workflow Contract and must not be inferred from database enum values alone.

## 7. Clinical Note

### Purpose

Narrative clinical documentation associated with a patient/visit.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `clinical_note_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `visit_id` | UUID | Yes | FK → Visit |
| `author_user_id` | UUID | Yes | FK → User |
| `note_type` | controlled value | Yes | Approved note classification |
| `content` | text | Yes | Narrative content |
| `created_at` | timestamp | Yes | Immutable creation time |
| `updated_at` | timestamp | Yes | Required if editing is permitted |
| `archived_at` | timestamp | No | Archive marker when permitted |

Clinical notes must not be used as the sole storage location for structured diagnoses, procedures, or tooth findings.

## 8. Diagnosis

### Purpose

Structured clinical assessment associated with a visit.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `diagnosis_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `visit_id` | UUID | Yes | FK → Visit |
| `code_system` | text | No | Coding system if adopted |
| `code` | text | No | Structured code if adopted |
| `label` | text | Yes | Clinical label |
| `tooth_id` | UUID | No | Optional FK → Tooth |
| `status` | enum | Yes | Active/resolved/entered-in-error as governed by clinical contract |
| `recorded_by` | UUID | Yes | FK → User |
| `recorded_at` | timestamp | Yes | Required |

The exact diagnosis vocabulary/coding system remains a separate clinical vocabulary decision and must not be invented by the schema.

## 9. Tooth

### Purpose

Structured reference to an individual tooth within a patient's dental chart.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `tooth_id` | UUID | Yes | Primary key |
| `patient_id` | UUID | Yes | FK → Patient |
| `notation_system` | enum | Yes | FDI / future supported systems |
| `tooth_code` | text | Yes | Structured tooth identifier, e.g. `11`, `46` |
| `dentition` | enum | Yes | Permanent / Primary when applicable |
| `created_at` | timestamp | Yes | Required |

### Integrity

A patient's tooth reference must be unique for the applicable notation system and dentition.

The schema must not require every clinical event to reference a tooth.

## 10. Dental Chart Finding

### Purpose

Persistent tooth/chart finding associated with the patient's dental chart.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `finding_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `tooth_id` | UUID | No | Optional for whole-mouth findings |
| `finding_type` | controlled value | Yes | Approved chart vocabulary |
| `value` | structured/text | Yes | Finding state/value |
| `recorded_at` | timestamp | Yes | Required |
| `recorded_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

The exact finding vocabulary is owned by Dental Chart specification and is not invented here.

## 11. Treatment Plan

### Purpose

Longitudinal planned care for a patient.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `treatment_plan_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `status` | enum | Yes | Planned / Active / Completed / Cancelled / Archived |
| `title` | text | Yes | Plan display name |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

## 12. Planned Treatment Item

### Purpose

Individual planned care item within a treatment plan.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `planned_item_id` | UUID | Yes | Primary key |
| `treatment_plan_id` | UUID | Yes | FK → Treatment Plan |
| `patient_id` | UUID | Yes | FK → Patient |
| `procedure_definition_id` | UUID | No | Optional controlled procedure reference |
| `description` | text | Yes | Planned treatment description |
| `tooth_id` | UUID | No | Optional FK → Tooth |
| `status` | enum | Yes | Planned / In Progress / Completed / Cancelled |
| `sequence` | integer | No | Ordering within plan |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

A completed planned item does not replace the corresponding performed procedure record.

## 13. Procedure Definition

### Purpose

Reusable controlled definition/catalog entry for a clinical procedure.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `procedure_definition_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | Clinic-scoped definition |
| `code` | text | No | Optional clinic/system code |
| `name` | text | Yes | Procedure name |
| `status` | enum | Yes | Active/inactive |
| `created_at` | timestamp | Yes | Required |
| `updated_at` | timestamp | Yes | Required |

This is a definition, not a clinical event.

## 14. Performed Procedure

### Purpose

Finalized/recorded actual clinical work.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `performed_procedure_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `visit_id` | UUID | Yes | FK → Visit |
| `procedure_definition_id` | UUID | No | Optional FK → Procedure Definition |
| `description` | text | Yes | Snapshot/clinical description |
| `tooth_id` | UUID | No | Optional FK → Tooth |
| `status` | enum | Yes | Draft / Finalized / Entered in Error where authorized |
| `performed_at` | timestamp | Yes | Clinical event timestamp |
| `performed_by` | UUID | Yes | FK → User |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

### Integrity

Finalized performed work must not be silently rewritten as though it were planned treatment.

Any correction/entered-in-error behavior must be governed by the Runtime Workflow and Audit specifications.

## 15. Clinical Closure

### Purpose

Final visit closure record and closure classification.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `clinical_closure_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `visit_id` | UUID | Yes | FK → Visit |
| `closure_outcome` | enum | Yes | Approved four-value vocabulary |
| `summary` | text | No | Clinical closure summary |
| `closed_at` | timestamp | Yes | Closure timestamp |
| `closed_by` | UUID | Yes | FK → User |
| `created_at` | timestamp | Yes | Required |
| `created_by` | UUID | Yes | FK → User |
| `updated_at` | timestamp | Yes | Required |
| `updated_by` | UUID | Yes | FK → User |

### Closure Outcome

Exactly:

- `Completed as Planned`
- `Completed with Modification`
- `Not Completed`
- `Treatment Continues`

Closure Outcome must remain distinct from `visit_state`.

## 16. Clinical Record History

### Purpose

Longitudinal historical presentation of persisted clinical information.

### Schema decision

**Do not create a duplicate mutable `clinical_record_history` source-of-truth table solely to render the Records screen.**

History should be derived from authoritative domain records and, where necessary for audit/event ordering, from a dedicated immutable event/audit model.

Possible projection sources include:

- visits;
- clinical notes;
- diagnoses;
- dental findings;
- performed procedures;
- treatment plans/items;
- clinical closure;
- documents.

The exact projection/query model is a runtime implementation concern and must preserve the Clinical Record History read-only ownership boundary.

## 17. Document / Attachment

### Purpose

Reference to supporting clinical files without embedding binary content directly in domain tables.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `document_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `patient_id` | UUID | Yes | FK → Patient |
| `visit_id` | UUID | No | Optional FK → Visit |
| `document_type` | controlled value | Yes | Approved document category |
| `storage_key` | text | Yes | Secure object-storage reference |
| `file_name` | text | Yes | Original/display name |
| `mime_type` | text | Yes | File type |
| `size_bytes` | integer | Yes | File size |
| `uploaded_by` | UUID | Yes | FK → User |
| `uploaded_at` | timestamp | Yes | Required |
| `status` | enum | Yes | Active/archived |

Binary files must be stored in controlled file/object storage, not directly in relational text/blob fields unless separately authorized.

## 18. Audit Event

### Purpose

Immutable security/clinical traceability event.

### Canonical fields

| Field | Type | Required | Rule |
|---|---|---:|---|
| `audit_event_id` | UUID | Yes | Primary key |
| `clinic_id` | UUID | Yes | FK → Clinic |
| `actor_user_id` | UUID | No | FK → User; null only for explicitly system-generated events |
| `event_type` | controlled value | Yes | Versioned event taxonomy |
| `entity_type` | text | Yes | Affected domain entity |
| `entity_id` | UUID | Yes | Affected entity identifier |
| `occurred_at` | timestamp | Yes | Immutable event time |
| `metadata` | structured JSON | No | Non-authoritative event metadata |

Audit events are append-only. They are not a substitute for the authoritative domain record.

## Relationship cardinality

### Core

```text
Clinic 1 ─── N Users/Memberships
Clinic 1 ─── N Patients
Patient 1 ─── N Appointments
Patient 1 ─── N Visits
Appointment 0..1 ─── 1 Visit
Visit 1 ─── N Clinical Notes
Visit 1 ─── N Diagnoses
Visit 1 ─── N Performed Procedures
Patient 1 ─── N Treatment Plans
Treatment Plan 1 ─── N Planned Items
Patient 1 ─── N Teeth
Patient 1 ─── N Dental Findings
Visit 1 ─── 0..1 Clinical Closure
Patient 1 ─── N Documents
Clinic 1 ─── N Audit Events
```

The `Visit → Clinical Closure` relationship is intentionally zero-or-one for the current baseline: a visit may be open, and only a single authoritative closure record should represent the final closure state. Reopening/reclosure behavior must be explicitly defined before implementation.

## Referential integrity rules

1. Every patient belongs to exactly one clinic.
2. Every visit belongs to exactly one patient and clinic.
3. An appointment may reference only a patient in the same clinic.
4. A visit may reference an appointment only when the appointment belongs to the same patient and clinic.
5. Clinical notes, diagnoses, procedures, and closure records must reference the same patient and clinic as their visit.
6. A tooth must belong to the same patient as any tooth-level clinical record referencing it.
7. A treatment plan must belong to the same patient and clinic as its planned items.
8. A performed procedure must reference the same patient and clinic as its visit.
9. A finalized clinical closure must reference an existing visit.
10. Cross-clinic foreign-key references are prohibited.

## Required indexes / lookup intent

The eventual database implementation must support efficient lookup by at least:

- clinic + patient number;
- clinic + patient name/search fields;
- clinic + appointment date/time;
- clinic + appointment status;
- clinic + patient + visit date;
- clinic + visit state;
- patient + clinical history chronology;
- patient + tooth;
- treatment plan + patient;
- performed procedure + patient/visit;
- audit event + entity;
- document + patient/visit.

Exact index definitions remain implementation-specific.

## Timestamps and authorship

All mutable clinical/domain entities must use a consistent timestamp convention.

Required baseline fields where applicable:

- `created_at`
- `created_by`
- `updated_at`
- `updated_by`

Clinical event entities additionally require an event-specific timestamp such as:

- `visit_date`;
- `performed_at`;
- `closed_at`;
- `recorded_at`.

The implementation must use one explicit timezone strategy and must not mix local timestamps and UTC timestamps without a documented conversion rule.

## Status vocabulary rules

Statuses are domain-specific. Do not create one global `status` enum for every table.

Examples:

- Appointment Status
- Visit State
- Treatment Plan Status
- Planned Item Status
- Performed Procedure Status
- Closure Outcome
- Patient Status
- Document Status

A status value must not be reused across domains merely because the text is similar.

## Deletion / archive rules

The schema does not authorize destructive deletion of clinical records.

Before production implementation, each entity must receive one of these explicit policies:

- immutable;
- editable with audit trail;
- archivable;
- entered-in-error correction;
- deletable only when non-clinical and legally permitted.

Clinical Record History must preserve historical meaning even when a source record is corrected or archived.

## Runtime transaction boundaries

The schema anticipates, but does not yet authorize, transactions such as:

### Create patient

```text
Patient
 + registration data
 + authorship
```

### Start visit

```text
Patient
 + Visit
 + optional Appointment linkage
```

### Record clinical work

```text
Visit
 + note/diagnosis/finding/procedure
```

### Close visit

```text
Performed work finalized
 + Clinical Closure
 + Visit state → Closed
```

The exact transaction ordering, rollback behavior, and concurrency rules belong to the Runtime Workflow Contract.

## Explicit non-goals

This specification does not define:

- UI field labels;
- Figma layouts;
- API URL structure;
- SQL syntax;
- Supabase-specific implementation;
- authentication-provider implementation;
- RLS policy syntax;
- clinical decision support;
- billing;
- HMO/insurance;
- inventory;
- laboratory management.

## Known documentation dependency

The repository audit identified documentation completeness gaps for Patient Registration, Patient Management, Dental Chart, and Treatment Planning. This schema specification therefore preserves their existing ownership boundaries and uses only the high-confidence domain concepts established by the architecture audit.

Before database implementation, those module-specific field contracts must be reconciled against this schema so that the schema does not silently invent or omit authoritative module fields.

## Schema review gates

Before database implementation is authorized, the following must pass:

1. **Schema Consistency Audit**
   - field names;
   - ownership;
   - cardinality;
   - status separation;
   - clinical closure separation;
   - tooth-level integrity.

2. **Cross-Module Dependency Audit**
   - Patient → Visit → Clinical domains;
   - Treatment Planning → Performed Procedure;
   - Closure → History.

3. **Authentication / Authorization Specification**
   - user/clinic membership;
   - roles;
   - access boundaries.

4. **Runtime Workflow Contract**
   - visit transitions;
   - mutation commands;
   - transaction boundaries;
   - validation;
   - correction/reopening rules.

5. **Technology Decision**
   - relational database;
   - authentication;
   - object storage;
   - application/runtime stack.

6. **Explicit Database Implementation Authorization**

## Current decision

**SCHEMA SPECIFICATION COMPLETE — REVIEW REQUIRED.**

The next proper task is:

> **SmileFlow Phase 2 — Core Data Schema Consistency Audit**

No database tables, migrations, Supabase schema, or production application persistence should be implemented until that audit passes and explicit implementation authorization is granted.
