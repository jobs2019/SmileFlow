# SmileFlow Phase 2 — Database / RLS Implementation Specification v1.0

## Status

**PROPOSED — NOT IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-13

## Purpose

Translate the approved Phase 2 architecture into an implementation-level database and Row Level Security (RLS) plan for the selected Supabase/Postgres backend.

This document specifies the target persistence boundary, relationships, constraints, indexes, authorization shape, transaction boundaries, and migration order. It does **not** create the database, execute SQL, configure Supabase, create Auth users, or modify Figma.

## Governing sources

This specification is derived from and subordinate to:

1. current user-approved SmileFlow architecture decisions;
2. `SOURCE_OF_TRUTH.md`;
3. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`;
4. `PHASE_2_AUTHENTICATION_AUTHORIZATION_SPECIFICATION_V1.md`;
5. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md`;
6. the completed Phase 2 consistency audits and technology decision.

Where an authoritative module contract is still unresolved, this specification deliberately leaves the field or constraint deferred rather than inventing it.

## Selected backend

```text
Client / FlutterFlow
        ↓
Supabase Auth
        ↓
Postgres + RLS
        ├── core relational data
        ├── authorization boundary
        └── audit persistence
        ↓
Supabase Storage
        ↓
protected documents / attachments

Supabase Edge Functions
        ↓
server-side complex clinical transactions
```

## Non-negotiable implementation rules

1. Postgres is the system of record.
2. Supabase Auth owns authentication credentials and sessions.
3. Application-domain `users` stores the SmileFlow user identity, not password material.
4. Every clinic-owned resource has an explicit clinic boundary, directly or through a validated parent relationship.
5. RLS is mandatory for production clinic-owned data.
6. Client-side visibility is never the authorization boundary.
7. `clinic_id` and acting-user identity are never trusted from arbitrary client input.
8. Clinical authorship fields are derived from authenticated server identity.
9. State transitions are validated against persisted current state.
10. Cross-module clinical transactions are atomic.
11. No generic enum is reused across independent state domains.
12. No unresolved module vocabulary is invented in SQL.
13. HMO/insurance is excluded.
14. Billing is excluded from this implementation.

# 1. Target schema

## 1.1 `clinics`

Purpose: tenant/clinic boundary.

| Column | Type | Rules |
|---|---|---|
| `clinic_id` | uuid | PK, generated server-side |
| `name` | text | NOT NULL |
| `status` | text/enum | controlled; exact values require approved clinic contract |
| `created_at` | timestamptz | NOT NULL, server default |
| `updated_at` | timestamptz | NOT NULL, server-managed |

Indexes:

- PK on `clinic_id`.
- Index on `status` only if operational queries require it.

## 1.2 `users`

Purpose: canonical SmileFlow application identity mapped from Supabase Auth.

| Column | Type | Rules |
|---|---|---|
| `user_id` | uuid | PK; maps to Auth user identity |
| `email` | text | controlled/unique according to account contract |
| `display_name` | text | NOT NULL |
| `status` | text/enum | Active / Inactive / Disabled |
| `created_at` | timestamptz | NOT NULL |
| `updated_at` | timestamptz | NOT NULL |

The application table must not contain passwords, password hashes, reset secrets, MFA secrets, or refresh tokens.

Recommended relationship:

```text
users.user_id = auth.users.id
```

The exact provisioning mechanism is implementation-specific.

## 1.3 `clinic_memberships`

Purpose: explicit tenant membership and role context.

| Column | Type | Rules |
|---|---|---|
| `membership_id` | uuid | PK |
| `clinic_id` | uuid | NOT NULL FK → clinics |
| `user_id` | uuid | NOT NULL FK → users |
| `role` | text/enum | Dentist / Dental Assistant / Receptionist / Administrator |
| `status` | text/enum | Active / Inactive |
| `created_at` | timestamptz | NOT NULL |
| `updated_at` | timestamptz | NOT NULL |

Constraints:

- Unique active membership for the same `(clinic_id, user_id)`.
- Inactive memberships never satisfy access predicates.
- No client may create a membership merely by supplying a clinic ID.

Indexes:

- `(user_id, clinic_id, status)`.
- `(clinic_id, user_id, status)`.

## 1.4 `patients`

Purpose: single canonical longitudinal patient identity.

| Column | Type | Rules |
|---|---|---|
| `patient_id` | uuid | PK |
| `clinic_id` | uuid | NOT NULL FK → clinics |
| `patient_number` | text | NOT NULL; unique within clinic |
| `first_name` | text | NOT NULL |
| `middle_name` | text | nullable |
| `last_name` | text | NOT NULL |
| `suffix` | text | nullable |
| `birth_date` | date | nullable until registration contract requires it |
| `sex` | text/enum | nullable; controlled vocabulary only when approved |
| `status` | text/enum | Active / Archived |
| `created_at` | timestamptz | NOT NULL |
| `created_by` | uuid | NOT NULL FK → users |
| `updated_at` | timestamptz | NOT NULL |
| `updated_by` | uuid | NOT NULL FK → users |

Constraints:

- Unique `(clinic_id, patient_number)`.
- `patient_id` is immutable.
- Patient cannot be reassigned between clinics by ordinary update.
- Registration and Patient Management both use this table.

Indexes:

- `(clinic_id, patient_number)` unique.
- `(clinic_id, last_name, first_name)` for patient search.
- Optional search index strategy to be selected after the search UX contract is finalized.

## 1.5 `appointments`

Purpose: scheduling-domain object, distinct from clinical Visit.

| Column | Type | Rules |
|---|---|---|
| `appointment_id` | uuid | PK |
| `clinic_id` | uuid | NOT NULL FK → clinics |
| `patient_id` | uuid | NOT NULL FK → patients |
| `provider_user_id` | uuid | nullable FK → users |
| `scheduled_start` | timestamptz | NOT NULL |
| `scheduled_end` | timestamptz | nullable |
| `appointment_type` | text | controlled vocabulary deferred |
| `status` | text/enum | Scheduled / Confirmed / Completed / Cancelled / No Show |
| `notes` | text | nullable, non-clinical scheduling note |
| `created_at` | timestamptz | NOT NULL |
| `created_by` | uuid | NOT NULL FK → users |
| `updated_at` | timestamptz | NOT NULL |
| `updated_by` | uuid | NOT NULL FK → users |

Constraints:

- Appointment patient must belong to the same clinic.
- Appointment provider, when present, must have valid membership in the clinic.
- Scheduling remains a Phase 5 UI/operations feature even though the data dependency exists here.

Indexes:

- `(clinic_id, scheduled_start)`.
- `(clinic_id, patient_id, scheduled_start)`.
- `(clinic_id, provider_user_id, scheduled_start)`.

## 1.6 `visits`

Purpose: actual clinical encounter and owner of Visit State.

| Column | Type | Rules |
|---|---|---|
| `visit_id` | uuid | PK |
| `clinic_id` | uuid | NOT NULL FK → clinics |
| `patient_id` | uuid | NOT NULL FK → patients |
| `appointment_id` | uuid | nullable FK → appointments |
| `provider_user_id` | uuid | nullable FK → users |
| `visit_date` | timestamptz/date | NOT NULL; exact domain choice to match implementation contract |
| `visit_type` | text | controlled vocabulary deferred |
| `chair` | text | nullable |
| `visit_state` | text/enum | Scheduled / Checked In / Waiting / Called / In Treatment / Ready for Closure / Closed |
| `created_at` | timestamptz | NOT NULL |
| `created_by` | uuid | NOT NULL FK → users |
| `updated_at` | timestamptz | NOT NULL |
| `updated_by` | uuid | NOT NULL FK → users |

Constraints:

- Patient and appointment, if supplied, must belong to the same clinic.
- Provider, if supplied, must have valid clinic membership.
- Ordinary database writes must not permit arbitrary state jumps; transition logic belongs to the approved runtime transaction layer.

Indexes:

- `(clinic_id, patient_id, visit_date DESC)`.
- `(clinic_id, visit_state, visit_date)`.
- `(clinic_id, provider_user_id, visit_date)`.

## 1.7 `clinical_notes`

Purpose: narrative documentation attached to a visit.

Core fields:

- `clinical_note_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `visit_id` uuid FK
- `author_user_id` uuid FK → users
- `note_text` text NOT NULL
- `created_at` timestamptz
- `updated_at` timestamptz

Structured diagnoses, procedures, and tooth findings must not be represented only by `note_text`.

Indexes:

- `(clinic_id, visit_id, created_at)`.
- `(clinic_id, patient_id, created_at)`.

## 1.8 `diagnoses`

Purpose: structured clinical assessment.

Core fields:

- `diagnosis_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `visit_id` uuid FK
- `tooth_id` uuid nullable FK
- diagnosis code/label fields, exact vocabulary deferred
- `recorded_by` uuid FK → users
- `created_at`
- `updated_at`

No implementation should invent a diagnosis coding standard before the clinical vocabulary contract is approved.

## 1.9 `teeth`

Purpose: structured patient-specific tooth reference.

Core fields:

- `tooth_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `notation_system` text
- `tooth_code` text
- `dentition` text
- `created_at`

Constraints:

- Unique `(patient_id, notation_system, tooth_code)`.
- FDI codes such as `11` and `46` must be representable without using free-form narrative as the primary reference.
- A patient-level procedure must not be forced to reference a tooth.

## 1.10 `dental_chart_findings`

Purpose: persistent chart state/findings owned by Dental Chart.

Core fields:

- `finding_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `tooth_id` uuid nullable FK
- finding type/value fields — exact vocabulary deferred
- `recorded_by` uuid FK → users
- `created_at`
- `updated_at`

RLS must enforce the patient/clinic boundary and role permission.

## 1.11 `treatment_plans`

Purpose: longitudinal container for planned care.

Canonical fields:

- `treatment_plan_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `title` text NOT NULL
- `created_at`
- `created_by` uuid FK → users
- `updated_at`
- `updated_by` uuid FK → users

**No `status` column.**

This is intentional and follows the reconciled v1.1 architecture.

## 1.12 `planned_treatment_items`

Purpose: individual planned treatment and its lifecycle.

Canonical fields:

- `planned_item_id` uuid PK
- `clinic_id` uuid FK
- `treatment_plan_id` uuid FK
- `patient_id` uuid FK
- `procedure_definition_id` uuid nullable FK
- `description` text NOT NULL
- `tooth_id` uuid nullable FK
- `status` text/enum: Planned / Scheduled / In Progress / Completed
- `sequence` integer nullable
- `created_at`
- `created_by`
- `updated_at`
- `updated_by`

Constraints:

- `patient_id` must match the treatment plan's patient.
- `tooth_id`, when supplied, must belong to the same patient.
- No `Active`, `Cancelled`, or `Archived` values.

Indexes:

- `(clinic_id, treatment_plan_id, sequence)`.
- `(clinic_id, patient_id, status)`.

## 1.13 `procedure_definitions`

Purpose: reusable procedure catalog definition, not a clinical event.

Core fields:

- `procedure_definition_id` uuid PK
- `clinic_id` uuid FK
- `code` text nullable
- `name` text NOT NULL
- `status` text/enum Active / Inactive
- `created_at`
- `updated_at`

## 1.14 `performed_procedures`

Purpose: actual clinical work performed during a visit.

Core relationships:

- `performed_procedure_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `visit_id` uuid FK
- `procedure_definition_id` uuid nullable FK
- `tooth_id` uuid nullable FK
- `performed_by` uuid FK → users
- clinical description/quantity fields only where contractually approved
- created/updated timestamps

**Performed Procedure status/finalization semantics remain deferred.** Do not invent a new status enum or reuse Visit State or Treatment Plan Item Status.

## 1.15 `clinical_closures`

Purpose: persisted closure outcome for a visit.

Core fields:

- `clinical_closure_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- `visit_id` uuid FK
- `outcome` text/enum:
  - Completed as Planned
  - Completed with Modification
  - Not Completed
  - Treatment Continues
- required closure fields — exact inventory deferred
- `closed_by` uuid FK → users
- `closed_at` timestamptz
- `created_at`

Constraints:

- One committed closure per visit under the current contract.
- Closure is valid only for an accessible visit in `Ready for Closure`.
- Closure and `visits.visit_state = Closed` must be committed atomically.

Recommended unique index:

- unique `(visit_id)`.

## 1.16 Clinical Record History

No independent mutable `clinical_record_history` source table is authorized by this specification.

Records/history is a read projection over persisted source entities and/or approved audit/event data.

## 1.17 `documents` / attachments

Target metadata boundary:

- `document_id` uuid PK
- `clinic_id` uuid FK
- `patient_id` uuid FK
- optional `visit_id` uuid FK
- storage object reference
- file metadata fields
- `uploaded_by` uuid FK → users
- `created_at`

Exact document types, bucket naming, retention, and storage policies are deferred to the File/Document Storage specification.

## 1.18 `audit_events`

Purpose: immutable traceability.

Target fields:

- `audit_event_id` uuid PK
- `clinic_id` uuid nullable where an event is not clinic-scoped
- `actor_user_id` uuid nullable for system events
- `event_type` text
- `resource_type` text
- `resource_id` uuid/text as appropriate
- event metadata JSON only where explicitly approved
- `created_at` timestamptz

Rules:

- Append-only from the application perspective.
- Ordinary clients must not update or delete audit events.
- Detailed taxonomy remains a later Audit Trail specification.

# 2. Referential integrity rules

Every clinic-owned relationship must preserve tenant consistency.

Examples:

```text
patients.clinic_id = appointments.clinic_id
patients.clinic_id = visits.clinic_id
patients.clinic_id = treatment_plans.clinic_id
patients.clinic_id = planned_treatment_items.clinic_id
patients.clinic_id = performed_procedures.clinic_id
patients.clinic_id = clinical_closures.clinic_id
```

For relationships where both parent and child store `clinic_id`, implementation should use composite foreign keys or equivalent database constraints where practical so that a client cannot create cross-clinic references.

The same principle applies to patient-scoped resources.

# 3. State-domain constraints

Do not create one shared `status` enum for all tables.

The implementation must preserve:

```text
Appointment.status
Visit.visit_state
PlannedTreatmentItem.status
PerformedProcedure.status (when later authorized)
ClinicalClosure.outcome
```

as independent concepts.

## Treatment-plan item status

Exactly:

```text
Planned
Scheduled
In Progress
Completed
```

No additional values are authorized by this specification.

## Visit state

Exactly:

```text
Scheduled
Checked In
Waiting
Called
In Treatment
Ready for Closure
Closed
```

Controlled recovery transitions must be implemented only through the approved Runtime Workflow Contract.

# 4. RLS architecture

## 4.1 General policy

Every clinic-owned table must have RLS enabled before production access.

The conceptual policy is:

```text
request
  ↓
 authenticated user
  ↓
 auth.uid()
  ↓
 users / clinic_memberships
  ↓
 active membership for resource clinic_id
  ↓
 role permission
  ↓
 allow
```

Otherwise deny.

## 4.2 Membership predicate

The canonical access predicate is conceptually:

```sql
EXISTS (
  SELECT 1
  FROM public.clinic_memberships m
  WHERE m.user_id = auth.uid()
    AND m.clinic_id = <resource.clinic_id>
    AND m.status = 'Active'
)
```

The exact helper function/view strategy is implementation-specific.

## 4.3 Role predicate

Role checks must additionally require an active membership.

Conceptually:

```text
has_active_membership(clinic_id)
AND has_role_permission(clinic_id, required_permission)
```

Do not trust a client-supplied role.

## 4.4 SELECT policies

Read access must be resource-scoped.

Examples:

- patients: active clinic membership + patient-read permission;
- visits: active clinic membership + visit-read permission;
- dental chart: active clinic membership + chart-read permission;
- treatment planning: active clinic membership + treatment-plan-read permission;
- clinical closures: active clinic membership + closure/history-read permission;
- audit events: explicit audit-read permission.

## 4.5 INSERT policies

Insert access must verify:

- active clinic membership;
- required permission;
- resource `clinic_id` belongs to caller's authorized clinic;
- foreign-keyed patient/resource belongs to the same clinic;
- authorship fields are server-derived or constrained to the authenticated user.

## 4.6 UPDATE policies

Update access must verify:

- active membership;
- permission for that mutation;
- resource belongs to caller's clinic;
- state transition is valid;
- protected ownership fields cannot be reassigned by ordinary updates.

State transitions requiring atomic multi-record changes should not rely on a client-issued direct update; they should use the approved server-side transaction boundary.

## 4.7 DELETE policies

Default policy: **deny destructive deletes** for clinical records.

Where an operational entity needs removal, prefer an approved archive/deactivation state.

Audit events must never be client-deleted.

# 5. Permission mapping

The implementation must use explicit permissions rather than broad role checks where clinical risk requires finer control.

Minimum conceptual permissions include:

```text
patient.read
patient.register
patient.update
appointment.read
appointment.manage
visit.read
visit.open
visit.update
chart.read
chart.write
clinical_note.write
diagnosis.write
treatment_plan.read
treatment_plan.write
performed_procedure.write
clinical_closure.read
clinical_closure.write
document.read
document.upload
audit.read
membership.manage
clinic.manage
```

The exact final role-to-permission mapping remains subject to the approved authorization contract.

Ambiguous permissions must fail closed.

# 6. Auth-to-domain identity mapping

The expected identity chain is:

```text
Supabase Auth user
       ↓
auth.uid()
       ↓
public.users.user_id
       ↓
public.clinic_memberships
       ↓
clinic + role
```

A production mutation must not accept `created_by`, `updated_by`, `performed_by`, or `closed_by` as arbitrary trusted client values.

# 7. Server-side clinical transactions

## 7.1 Clinical Closure

Clinical Closure is the first explicitly required multi-record transaction boundary.

Conceptually:

```text
BEGIN
  verify auth identity
  verify active clinic membership
  verify closure permission
  lock/read current visit state
  verify visit = Ready for Closure
  validate closure payload
  insert clinical_closure
  update visits.visit_state = Closed
  insert audit_event
COMMIT
```

Failure anywhere means rollback.

The implementation mechanism may be a Postgres function/RPC or Edge Function invoking a transactional database operation, subject to the final implementation design.

## 7.2 Treatment-plan item transition

A state transition must validate the expected current status and requested next status atomically.

Conceptually:

```text
expected = current persisted status
requested = allowed next status
```

A stale request fails with a concurrency conflict.

## 7.3 Other cross-module operations

Do not introduce cross-module transactions merely because a UI button appears to perform multiple actions.

Only explicitly approved workflow contracts may mutate multiple owned domains atomically.

# 8. Concurrency and idempotency

## Optimistic concurrency

State-changing operations must guard against stale clients.

A transition should be conditional on the expected persisted source state.

## Idempotency

At minimum, server-side idempotency protection is required for:

- Clinical Closure commit;
- Performed Procedure creation/finalization once its contract is finalized;
- any later mutation identified as non-repeatable.

The exact idempotency-key persistence mechanism is implementation-specific.

# 9. Indexing strategy

Initial indexes should support the application's primary access paths:

```text
clinic → patients
clinic → patient search
clinic → appointments by time
clinic → visits by patient/date/state
clinic → treatment plans by patient
clinic → planned items by plan/status
clinic → procedures by visit/patient
clinic → closures by visit
clinic → audit events by clinic/time
```

Indexes should be added based on actual query plans after the first implementation pass rather than pre-indexing every column.

# 10. Migration order

The recommended implementation order is:

```text
1. Extensions / common database primitives
2. clinics
3. users ↔ Supabase Auth identity mapping
4. clinic_memberships
5. patients
6. teeth
7. procedure_definitions
8. appointments
9. visits
10. clinical_notes
11. diagnoses
12. dental_chart_findings
13. treatment_plans
14. planned_treatment_items
15. performed_procedures
16. clinical_closures
17. documents metadata
18. audit_events
19. helper authorization functions
20. RLS enablement and policies
21. transaction functions / RPCs
22. indexes not already created by constraints
23. seed/reference data only where explicitly approved
```

Migration dependencies must be enforced by foreign keys.

# 11. Seed/reference data

No production patient data is part of the schema migration.

Reference data such as procedure definitions must be explicitly classified as reference data before seeding.

No invented clinical diagnosis or procedure vocabulary should be seeded from this specification alone.

# 12. Storage boundary

Supabase Storage is the intended document backend.

The database stores metadata and ownership relationships; protected files remain in Storage.

Storage access must use the same clinic/patient authorization boundary as the database.

Exact bucket and object-path conventions are deferred to the File/Document Storage specification.

# 13. Security-sensitive implementation rules

The implementation must not:

- expose the service-role key to the client;
- trust client-supplied clinic IDs for authorization;
- trust client-supplied role values;
- disable RLS to make FlutterFlow queries work;
- use a broad public policy as a temporary production shortcut;
- allow cross-clinic foreign-key relationships;
- let ordinary clients delete audit events;
- let ordinary clients rewrite clinical authorship;
- implement Clinical Closure as multiple unrelated client writes;
- infer clinical permissions from screen visibility.

# 14. Deferred items that block final implementation of affected areas

The following remain contract-dependent:

- Patient Registration exact fields and validation;
- Patient Management exact field-level permissions;
- Dental Chart exact finding vocabulary;
- Treatment Planning exact field inventory beyond lifecycle;
- Performed Procedure exact status/finalization semantics;
- Clinical Closure exact field validation;
- final audit-event taxonomy;
- final document/storage policy;
- final role-to-permission matrix where currently marked conditional.

Therefore this specification defines the **database/RLS architecture and target shape**, but final SQL must not invent unresolved contracts.

# 15. Explicitly excluded

```text
HMO / insurance       ❌
Billing               ❌
Inventory             ❌
Laboratory management ❌
AI clinical decisions ❌
Autonomous treatment  ❌
```

# 16. Implementation authorization gate

This specification is **not authorization to create the backend**.

Before implementation, the following must pass:

1. Database / RLS Specification Consistency Audit — **required**
2. Explicit Database Implementation Authorization — **required**
3. Supabase project/environment readiness check — **required**
4. Migration/recovery strategy — **required**
5. Final unresolved module contracts that affect concrete columns/constraints — **required before those tables are finalized**

## Governing principle

> **The database must enforce the architecture we already approved; it must never become the place where unresolved product decisions are invented.**
