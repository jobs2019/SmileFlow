# SmileFlow Phase 2 — Final Database Migration Specification

## Status

**FINAL MIGRATION SPECIFICATION — NOT EXECUTION-AUTHORIZED**

Date: 2026-08-14

Repository: `jobs2019/SmileFlow`

Baseline: `b8bb65c857a63ad3c1a84a3b687a53027bd61e0d`

Supabase project: `bijeyikklzfqlipzlsqu` (`SmileFlow's Project`)

Related resolution commit: `96cb89d55c09d54746f2a3f2b8f5b2662af24358`

## Purpose

This document is the final implementation specification for the Phase 2 database migration after resolution of MB-01 through MB-06.

It translates the reconciled Core Data schema, Database/RLS implementation specification, Authentication/Authorization contract, Runtime Workflow contract, consistency audits, and direct read-only Supabase evidence into an executable migration design.

It does **not** authorize execution of SQL, modification of Supabase, creation of Auth users, application persistence changes, Figma changes, or production deployment.

The next authorization gate must explicitly approve the migration implementation and its execution environment.

---

# 1. Governing source-of-truth hierarchy

The migration must be generated and reviewed using this order of authority:

1. Current user-approved SmileFlow architecture decisions.
2. `SOURCE_OF_TRUTH.md`.
3. Current approved/frozen module contracts.
4. `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`.
5. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`.
6. `PHASE_2_MIGRATION_BLOCKER_RESOLUTION_DECISIONS_V1.md`.
7. `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`.
8. `PHASE_2_AUTHENTICATION_AUTHORIZATION_SPECIFICATION_V1.md` and its consistency audit.
9. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md` and its consistency audit.
10. Direct read-only Supabase evidence as implementation evidence.
11. Historical Figma evidence only where explicitly authoritative.

The reconstructed database baseline is evidence of the current implementation. It is not authority to redefine the approved target model.

---

# 2. Migration safety boundary

## 2.1 No execution is authorized by this document

This document freezes the migration semantics only.

Before execution, a separate implementation-authorization decision must confirm:

- target environment;
- migration file(s);
- backup/snapshot strategy;
- rollback strategy;
- Supabase project/environment;
- local/disposable versus production execution;
- post-migration verification;
- RLS verification;
- application compatibility verification.

## 2.2 Current inspected database state

The connected Supabase project was inspected read-only during MB-01 through MB-06 resolution.

The inspected environment currently has zero rows in:

```text
public.users
public.patients
public.visits
public.clinic_memberships
```

It also has zero Auth users.

Existing migrations were observed through:

```text
0001_database_foundation
0002_identity_clinic_membership
0003_patients
0004_appointments_visits
0005_clinical_foundation
0006_performed_procedures
0007_treatment_planning
0008_clinical_closure
0009_audit_events_document_storage
0010_rls_policies
0011_rls_policy_hardening
```

The zero-row condition removes current data-backfill requirements for MB-01 through MB-05 in the inspected environment. It does not remove the need to define deterministic migration behavior for any non-empty deployment.

---

# 3. Resolved migration semantics

| Blocker | Canonical migration decision |
|---|---|
| MB-01 User status | `active`, `inactive`, `disabled` |
| MB-02 Patient status | `active`, `archived` |
| MB-03 `visit_date` | `timestamptz NOT NULL` |
| MB-04 User email | `text NOT NULL`; Auth remains identity authority; no competing public uniqueness rule invented |
| MB-05 `display_name` | `text NOT NULL`; no placeholder/default |
| MB-06 `has_clinic_role()` | `public.has_clinic_role(uuid, smileflow_role[]) → boolean`; preserve live security properties |

MB-06 is not a schema change. Direct live evidence confirmed the intended helper signature and security shape.

---

# 4. Migration design principles

The migration must satisfy all of the following:

1. Postgres remains the system of record.
2. Supabase Auth owns authentication credentials and sessions.
3. `public.users` stores application identity, not credential material.
4. Every clinic-owned resource has an explicit or validated clinic boundary.
5. Cross-clinic references must be impossible through ordinary relational writes.
6. RLS remains mandatory for production clinic-owned data.
7. Client-provided `clinic_id` and acting-user identity are never treated as trusted authorization facts.
8. Authenticated identity is obtained server-side.
9. Clinical authorship is derived from authenticated identity.
10. State transitions are validated against persisted current state.
11. Cross-module clinical transactions are atomic.
12. Independent state domains must not share a generic lifecycle enum.
13. Unresolved clinical vocabulary must not be invented merely to complete the migration.
14. HMO/insurance and billing remain outside Phase 2.

---

# 5. Target schema

The following is the canonical Phase 2 target. Exact deferred field inventories remain deferred and must not be invented in the migration.

## 5.1 `clinics`

| Column | Type | Required | Rule |
|---|---|---:|---|
| `clinic_id` | uuid | Yes | PK; server-generated |
| `name` | text | Yes | NOT NULL |
| `status` | controlled text/enum | Yes | Exact clinic lifecycle remains contract-dependent |
| `created_at` | timestamptz | Yes | server default |
| `updated_at` | timestamptz | Yes | server-managed |

Do not invent a clinic status vocabulary if it is not already frozen by an authoritative clinic contract.

## 5.2 `users`

| Column | Type | Required | Rule |
|---|---|---:|---|
| `user_id` | uuid | Yes | PK; maps to `auth.users.id` |
| `email` | text | Yes | NOT NULL; application copy of Auth email |
| `display_name` | text | Yes | NOT NULL |
| `status` | `smileflow_user_status` | Yes | `active`, `inactive`, `disabled` |
| `created_at` | timestamptz | Yes | server-managed |
| `updated_at` | timestamptz | Yes | server-managed |

The table must never contain passwords, password hashes, reset secrets, MFA secrets, refresh tokens, or other credential material.

Email authority:

```text
auth.users.email
       ↓
public.users.email
```

The exact synchronization mechanism is an implementation detail, but `public.users.email` must not become a second authentication authority.

## 5.3 `clinic_memberships`

| Column | Type | Required | Rule |
|---|---|---:|---|
| `membership_id` | uuid | Yes | PK |
| `clinic_id` | uuid | Yes | FK → clinics |
| `user_id` | uuid | Yes | FK → users |
| `role` | `smileflow_role` | Yes | Dentist / Dental Assistant / Receptionist / Administrator |
| `status` | controlled membership status | Yes | Active / Inactive |
| `created_at` | timestamptz | Yes | server-managed |
| `updated_at` | timestamptz | Yes | server-managed |

Recommended/required uniqueness semantics:

```text
one active membership for (clinic_id, user_id)
```

Inactive memberships must never satisfy authorization predicates.

## 5.4 `patients`

| Column | Type | Required | Rule |
|---|---|---:|---|
| `patient_id` | uuid | Yes | PK; immutable longitudinal identity |
| `clinic_id` | uuid | Yes | FK → clinics |
| `patient_number` | text | Yes | unique within clinic |
| `first_name` | text | Yes | NOT NULL |
| `middle_name` | text | No | nullable |
| `last_name` | text | Yes | NOT NULL |
| `suffix` | text | No | nullable |
| `birth_date` | date | No | nullable until registration contract requires it |
| `sex` | controlled text | No | only if approved vocabulary exists |
| `status` | controlled patient status | Yes | `active`, `archived` |
| `created_at` | timestamptz | Yes | server-managed |
| `created_by` | uuid | Yes | FK → users |
| `updated_at` | timestamptz | Yes | server-managed |
| `updated_by` | uuid | Yes | FK → users |

Required uniqueness:

```text
UNIQUE (clinic_id, patient_number)
```

A patient must not be silently reassigned to another clinic.

## 5.5 `appointments`

Canonical fields:

```text
appointment_id uuid PK
clinic_id uuid NOT NULL
patient_id uuid NOT NULL
provider_user_id uuid NULL
scheduled_start timestamptz NOT NULL
scheduled_end timestamptz NULL
appointment_type text NOT NULL/controlled according to contract
status controlled appointment lifecycle
notes text NULL
created_at timestamptz NOT NULL
created_by uuid NOT NULL
updated_at timestamptz NOT NULL
updated_by uuid NOT NULL
```

Appointment lifecycle:

```text
Scheduled
Confirmed
Completed
Cancelled
No Show
```

The provider, when supplied, must have valid active membership in the same clinic.

## 5.6 `visits`

Canonical fields:

```text
visit_id uuid PK
clinic_id uuid NOT NULL
patient_id uuid NOT NULL
appointment_id uuid NULL
provider_user_id uuid NULL
visit_date timestamptz NOT NULL
visit_type text controlled/deferred
chair text NULL
visit_state controlled Visit lifecycle
created_at timestamptz NOT NULL
created_by uuid NOT NULL
updated_at timestamptz NOT NULL
updated_by uuid NOT NULL
```

Canonical `visit_state`:

```text
Scheduled
Checked In
Waiting
Called
In Treatment
Ready for Closure
Closed
```

The migration must not use a database enum to imply that arbitrary direct updates are valid state transitions. Runtime transition enforcement is a separate requirement.

## 5.7 Clinical and supporting tables

The following remain part of the target boundary, subject to their authoritative field contracts:

```text
clinical_notes
diagnoses
teeth
dental_chart_findings
treatment_plans
planned_treatment_items
procedure_definitions
performed_procedures
clinical_closures
documents
audit_events
```

Clinical Record History is a read projection, not an independent mutable source table.

### Treatment plans

` treatment_plans ` has no `status` column.

Canonical fields include:

```text
treatment_plan_id
clinic_id
patient_id
title
created_at
created_by
updated_at
updated_by
```

### Planned treatment items

Canonical lifecycle:

```text
Planned
Scheduled
In Progress
Completed
```

Never introduce:

```text
Active
Cancelled
Archived
```

unless a future approved architecture decision explicitly changes the contract.

`description` is NOT NULL.

`sequence` is nullable.

### Clinical closure

Canonical outcomes:

```text
Completed as Planned
Completed with Modification
Not Completed
Treatment Continues
```

Closure is a visit-level boundary and must be committed atomically with the Visit transition to `Closed`.

---

# 6. Exact migration operations

The migration implementation should be generated in this order.

## Step 0 — Preflight assertions

Before DDL, assert:

- expected current schema/migration baseline;
- expected Supabase/Postgres environment;
- expected existing enum names;
- expected existing tables;
- expected RLS state;
- expected helper function signature;
- expected row counts where relevant.

If the preflight detects an unexpected baseline, the migration must stop rather than attempting destructive reconciliation automatically.

## Step 1 — Extend User status domain

Existing domain:

```text
smileflow_user_status = active, inactive
```

Target:

```text
active
inactive
disabled
```

Migration operation:

```sql
ALTER TYPE public.smileflow_user_status
ADD VALUE 'disabled';
```

Do not recreate the enum unnecessarily if the existing type can be safely extended.

## Step 2 — Add/complete `users.email`

Target:

```text
email text NOT NULL
```

Because the inspected database has zero `public.users` rows, no current-row backfill is required.

For any non-empty deployment, the migration must first reconcile each application User to `auth.users` and fail closed if an authoritative email cannot be resolved.

Do not invent a placeholder email.

Do not create an independent public uniqueness rule merely to compensate for Auth identity management.

## Step 3 — Enforce `users.display_name NOT NULL`

Current inspected data has zero rows.

Target:

```text
display_name text NOT NULL
```

For a non-empty deployment:

```text
inventory NULLs
→ resolve from authoritative provisioning/profile source
→ verify zero NULLs
→ apply NOT NULL
```

Never use an arbitrary placeholder name.

## Step 4 — Reconcile Patient status

Current reconstructed domain/check allows:

```text
active
inactive
archived
```

Canonical target allows:

```text
active
archived
```

Because the inspected `patients` table contains zero rows, no conversion is required there.

The implementation must still fail safely in a non-empty deployment if an `inactive` row exists and no approved conversion rule has been supplied.

Do not silently map `inactive → archived` unless an explicit approved migration policy authorizes that mapping.

## Step 5 — Add missing Patient core delta

Apply the approved v1.1 additive/renaming delta:

```text
ADD suffix
RECONCILE date_of_birth → birth_date
```

The exact existing baseline column name/type must be asserted before rename.

Do not drop historical data merely because the target uses a different canonical name.

## Step 6 — Add Appointment provider field

Target:

```text
provider_user_id uuid NULL
```

The relationship must be tenant-safe.

A plain `provider_user_id → users.user_id` FK is insufficient to prove clinic membership.

The final implementation must use a composite FK or equivalent server-side enforcement so that:

```text
provider_user_id
+
clinic_id
```

resolves to an active membership in that clinic.

## Step 7 — Add Visit target fields

Target additions/reconciliation:

```text
provider_user_id uuid NULL
visit_date timestamptz NOT NULL
visit_type text
chair text NULL
```

If any of these fields already exist under an equivalent canonical name, the migration must reconcile rather than duplicate them.

For the inspected zero-row environment, `visit_date` can be introduced directly as NOT NULL after the table definition is aligned.

For a non-empty deployment, a deterministic backfill source must be approved before adding NOT NULL.

## Step 8 — Preserve tenant-consistent relationships

Every clinic-owned child relationship must prevent cross-clinic references.

Required examples:

```text
appointments (clinic_id, patient_id)
    → patients (clinic_id, patient_id)

visits (clinic_id, patient_id)
    → patients (clinic_id, patient_id)

clinical_notes (clinic_id, patient_id, visit_id)
    → visits (clinic_id, patient_id, visit_id)

treatment_plans (clinic_id, patient_id)
    → patients (clinic_id, patient_id)

planned_treatment_items (clinic_id, treatment_plan_id, patient_id)
    → treatment_plans / patients
```

Use composite foreign keys where practical and otherwise use equivalent database-enforced validation.

## Step 9 — Preserve/verify `has_clinic_role()`

No signature replacement is required.

Canonical live signature:

```text
public.has_clinic_role(uuid, smileflow_role[]) → boolean
```

Required observed security properties:

```text
SECURITY DEFINER
STABLE
SET search_path TO pg_catalog, pg_temp
```

The migration must not downgrade this helper to `text[]`, remove `SECURITY DEFINER`, loosen its search path, or introduce a client-controlled role argument as an authorization authority.

If the migration script contains a function definition for this helper, it must reproduce the approved canonical security properties exactly.

## Step 10 — Provider membership enforcement

Implement database/server enforcement for:

```text
appointments.provider_user_id
visits.provider_user_id
```

when a provider is supplied.

The invariant is:

```text
provider_user_id belongs to the same clinic
AND
membership is active
```

This cannot depend solely on FlutterFlow validation.

## Step 11 — RLS policy alignment

RLS must be aligned only after table relationships and helper semantics are stable.

Every clinic-owned table must have policies based on authenticated identity and active clinic membership.

Do not trust arbitrary client-supplied clinic IDs.

Do not duplicate authorization logic inconsistently across tables when the approved helper/authorization abstraction can be reused safely.

## Step 12 — State-transition enforcement boundary

Do not implement privileged clinical transitions as unrestricted CRUD.

The Runtime Workflow contract requires:

```text
current-state validation
permission validation
atomic persistence
concurrency protection
idempotency
```

Examples of invalid direct jumps include:

```text
Waiting → Closed
Scheduled → Closed
Closed → In Treatment
```

The migration must preserve the database structure needed by the approved runtime transaction layer and must not create policies that allow ordinary clients to bypass that layer.

---

# 7. Index requirements

At minimum, preserve/create indexes for the approved query paths:

```text
patients:
  UNIQUE (clinic_id, patient_number)
  (clinic_id, last_name, first_name)

appointments:
  (clinic_id, scheduled_start)
  (clinic_id, patient_id, scheduled_start)
  (clinic_id, provider_user_id, scheduled_start)

visits:
  (clinic_id, patient_id, visit_date DESC)
  (clinic_id, visit_state, visit_date)
  (clinic_id, provider_user_id, visit_date)

clinical_notes:
  (clinic_id, visit_id, created_at)
  (clinic_id, patient_id, created_at)

planned_treatment_items:
  (clinic_id, treatment_plan_id, sequence)
  (clinic_id, patient_id, status)
```

Do not add speculative indexes merely because they are technically possible. Indexes must support approved query/access patterns.

---

# 8. Referential-integrity invariants

The migration is correct only if all of the following remain true.

## Tenant invariant

For every clinic-owned record:

```text
resource.clinic_id
```

must resolve to the same clinic as its clinic-owned parent.

## Patient invariant

A patient belongs to exactly one clinic in the current domain model.

A patient reference cannot cross clinics.

## Provider invariant

A provider used on an appointment or visit must have active membership in that resource's clinic.

## Auth identity invariant

```text
auth.users.id = public.users.user_id
```

for every application-domain User.

## Auth email invariant

`public.users.email` reflects the Auth identity email and is not an independent credential authority.

## Authorship invariant

`created_by`, `updated_by`, `recorded_by`, `performed_by`, `closed_by`, and equivalent fields must resolve to the authenticated application User where the contract requires authorship.

---

# 9. State-domain invariants

The database must preserve independent state concepts:

```text
Appointment.status
        ≠
Visit.visit_state
        ≠
PlannedTreatmentItem.status
        ≠
PerformedProcedure status/finalization
        ≠
ClinicalClosure.outcome
```

The following values are authoritative for their respective domains:

### User status

```text
active
inactive
disabled
```

### Patient status

```text
active
archived
```

### Appointment status

```text
Scheduled
Confirmed
Completed
Cancelled
No Show
```

### Visit state

```text
Scheduled
Checked In
Waiting
Called
In Treatment
Ready for Closure
Closed
```

### Planned Treatment Item status

```text
Planned
Scheduled
In Progress
Completed
```

### Clinical Closure outcome

```text
Completed as Planned
Completed with Modification
Not Completed
Treatment Continues
```

No unrelated lifecycle may reuse another domain's enum merely because the labels appear similar.

---

# 10. RLS implementation boundary

The final SQL must preserve the following authorization architecture:

```text
Supabase Auth
      ↓
auth.uid()
      ↓
SmileFlow public.users
      ↓
active clinic_memberships
      ↓
clinic/role authorization
      ↓
resource RLS
```

## `has_clinic_role()`

The canonical helper is:

```text
public.has_clinic_role(
  p_clinic_id uuid,
  p_roles smileflow_role[]
) returns boolean
```

The helper must remain safe against search-path manipulation and must use the authenticated identity rather than a client-supplied user ID.

## RLS policy requirements

For clinic-owned resources:

- SELECT requires active membership and permitted role/scope.
- INSERT requires server-derived identity and valid clinic membership.
- UPDATE requires active membership and field/transition authorization.
- DELETE is restricted and must not bypass clinical/audit requirements.

Exact role-by-resource permissions remain governed by the approved Authorization Matrix; do not invent broader permissions in the migration.

---

# 11. Audit requirements

Mutating operations that are explicitly audited must produce immutable audit records.

Audit events must not be client-editable or client-deletable.

The migration must not introduce a generic audit taxonomy beyond the approved contract.

Where a state transition is performed through a privileged transaction, the audit event and state mutation must share the required atomic transaction boundary.

---

# 12. Migration ordering

The recommended execution order is:

```text
1. PRECHECK / BASELINE ASSERTIONS
        ↓
2. ENUM / DOMAIN EXTENSIONS
        ↓
3. ADDITIVE COLUMNS
        ↓
4. DATA RECONCILIATION / BACKFILL (if required)
        ↓
5. NOT NULL / CHECK / UNIQUE CONSTRAINTS
        ↓
6. COMPOSITE / TENANT-SAFE FOREIGN KEYS
        ↓
7. INDEXES
        ↓
8. AUTH / USER SYNCHRONIZATION SUPPORT
        ↓
9. PROVIDER MEMBERSHIP ENFORCEMENT
        ↓
10. RLS POLICY ALIGNMENT
        ↓
11. STATE-TRANSITION / PRIVILEGED TRANSACTION SUPPORT
        ↓
12. VERIFICATION SUITE
```

For the current zero-row inspected environment, data reconciliation steps for MB-01 through MB-05 are expected to be no-op after preflight verification.

---

# 13. Transaction and failure behavior

The migration must fail closed on unexpected schema/data conditions.

It must not:

- silently delete rows;
- silently remap statuses without an approved mapping;
- invent placeholder emails;
- invent placeholder display names;
- silently move patients between clinics;
- weaken RLS to make migration succeed;
- replace authorization helpers with less-safe signatures;
- drop useful baseline fields without explicit classification;
- introduce unresolved clinical vocabulary.

Where PostgreSQL DDL cannot be safely rolled back as one transaction, the migration plan must isolate irreversible operations and require explicit preflight verification before them.

---

# 14. Preflight verification SQL requirements

The implementation should include read-only assertions equivalent to the following checks before mutation:

```sql
-- Expected helper exists with canonical signature
-- public.has_clinic_role(uuid, smileflow_role[])

-- Expected row counts are known
SELECT count(*) FROM public.users;
SELECT count(*) FROM public.patients;
SELECT count(*) FROM public.visits;
SELECT count(*) FROM public.clinic_memberships;

-- No unexpected User nulls before NOT NULL transition
SELECT count(*)
FROM public.users
WHERE display_name IS NULL;

-- No unexpected Patient statuses
SELECT status, count(*)
FROM public.patients
GROUP BY status;

-- No unexpected Visit rows before NOT NULL visit_date transition
SELECT count(*)
FROM public.visits
WHERE visit_date IS NULL;
```

The actual migration script must use baseline-appropriate catalog queries and should stop if an unexpected condition is detected.

---

# 15. Post-migration verification

The migration is not considered successful until all of the following are verified.

## Schema

- User status accepts exactly the approved three states.
- Patient status accepts exactly the approved two states.
- `users.email` exists and is NOT NULL.
- `users.display_name` is NOT NULL.
- `visits.visit_date` is `timestamptz NOT NULL`.
- Appointment and Visit provider fields exist where required.
- Treatment Plan has no `status` column.
- Planned Treatment Item has the four-state lifecycle only.

## Relationships

- Cross-clinic patient references are rejected.
- Cross-clinic appointment/visit references are rejected.
- Provider without active same-clinic membership is rejected.
- Patient-specific tooth references cannot cross patients.
- Treatment-plan item cannot reference a different patient than its plan.

## Auth

- `public.users.user_id` maps to `auth.users.id`.
- Application credentials remain outside `public.users`.
- Email synchronization behavior is correct.

## RLS

For each representative clinic/resource combination, verify:

```text
same-clinic authorized user → allowed
same-clinic unauthorized role → denied where required
cross-clinic user → denied
unauthenticated user → denied
inactive membership → denied
```

## Helper

Verify:

```text
public.has_clinic_role(uuid, smileflow_role[])
```

and its security properties remain intact.

## Runtime safety

Verify that ordinary CRUD cannot bypass privileged Visit state transitions or Clinical Closure rules.

## Audit

Verify required mutations generate the appropriate immutable audit event(s).

---

# 16. Rollback / recovery strategy

Rollback is environment-dependent.

## Before execution

For any non-disposable environment:

1. capture database backup/snapshot;
2. record current migration version;
3. record schema catalog state;
4. record RLS policies and helper definitions;
5. record row counts and status distributions;
6. confirm restoration procedure.

## For the inspected zero-row development environment

A clean disposable reset/rebuild is preferred over attempting ad-hoc reverse DDL when practical.

## Production-like environment

Do not assume every DDL operation has a safe automatic reverse migration.

The implementation-authorization gate must explicitly approve the recovery method before execution.

---

# 17. Application compatibility boundary

Database migration and application persistence changes are separate gates.

Before application code begins writing the new fields, verify:

```text
public.users.email
public.users.display_name
public.users.status
patients.suffix
patients.birth_date
patients.status
appointments.provider_user_id
visits.provider_user_id
visits.visit_date
visits.visit_type
visits.chair
```

FlutterFlow must not be treated as the authorization boundary.

Application code must use the approved backend transaction boundary for privileged clinical transitions.

---

# 18. Deferred items that must not be invented in this migration

The following remain contract-dependent and therefore must not be silently filled in:

- exact Clinic status vocabulary;
- exact Patient Registration field inventory beyond the reconciled core fields;
- exact Patient Management field inventory;
- exact Dental Chart finding vocabulary;
- diagnosis vocabulary/coding standard;
- exact Procedure Definition catalog vocabulary;
- Performed Procedure finalization/status semantics;
- exact Clinical Closure supporting field inventory;
- document/file taxonomy and retention rules;
- complete Audit Event taxonomy;
- full role-by-resource authorization matrix where not already frozen;
- scheduling UI/operations behavior;
- billing;
- HMO/insurance.

A migration must preserve useful existing baseline fields when their ownership has not been disproven. Such fields require explicit classification as `REQUIRED`, `OPTIONAL/PRESERVE`, `DEFERRED`, or `REMOVE` before destructive changes.

---

# 19. MB-07 through MB-10 status after finalization

## MB-07 — Provider clinic membership

**Status: implementation requirement, not unresolved schema semantics.**

The final migration must include database/server enforcement that a supplied provider belongs to the same clinic with active membership.

## MB-08 — Tenant-consistent child relationships

**Status: required implementation safeguard.**

Composite foreign keys or equivalent database-enforced constraints must preserve clinic and patient boundaries.

## MB-09 — Privileged state transitions

**Status: runtime/database transaction requirement.**

The migration must not expose unrestricted client CRUD that bypasses the Runtime Workflow Contract.

## MB-10 — Deferred module fields

**Status: deferred.**

No unresolved field should be invented merely to make the migration appear complete.

---

# 20. Final migration gate

This specification establishes the canonical target and exact migration semantics for Phase 2.

It does **not** authorize execution.

The next required gate is:

> **Explicit Phase 2 Database Migration Implementation Authorization**

That authorization should identify:

1. the exact migration file(s) to execute;
2. the target environment;
3. whether the execution is disposable/local or persistent/production-like;
4. backup/reset expectations;
5. approval to modify Supabase schema/RLS;
6. approval to generate and run verification SQL;
7. application compatibility scope.

Only after that authorization should an executable migration SQL file be created or applied.

---

# 21. Final decision

```text
MB-01  🟢 RESOLVED
MB-02  🟢 RESOLVED
MB-03  🟢 RESOLVED
MB-04  🟢 RESOLVED
MB-05  🟢 RESOLVED
MB-06  🟢 RESOLVED / FALSE POSITIVE CONFIRMED

TARGET DATABASE SEMANTICS: FROZEN
MIGRATION SQL: NOT YET EXECUTED
SUPABASE: NOT MODIFIED BY THIS DOCUMENT
IMPLEMENTATION AUTHORIZATION: REQUIRED
```

The correct next artifact is an executable, reviewable migration SQL file generated strictly from this specification after implementation authorization.