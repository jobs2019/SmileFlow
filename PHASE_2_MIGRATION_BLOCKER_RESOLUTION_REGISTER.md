# SmileFlow Phase 2 — Migration Blocker Resolution Register

## Status

**READ-ONLY REGISTER — MIGRATION BLOCKED PENDING RESOLUTION**

Date: 2026-08-14
Baseline: `b8bb65c857a63ad3c1a84a3b687a53027bd61e0d`
Repository: `jobs2019/SmileFlow`

## Purpose

This register records the concrete blockers identified by the read-only **Phase 2 Database Migration Readiness Audit** after reconciling:

- `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
- `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`
- `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_CONSISTENCY_AUDIT_V1.md`
- `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md`
- `PHASE_2_AUTHENTICATION_AUTHORIZATION_CONSISTENCY_AUDIT_V1.md`
- the reconstructed Supabase database baseline
- the recovered Phase 2 reconciliation decisions.

This document does **not** authorize a database migration and does **not** change the Supabase schema, RLS, Auth, application code, or Figma.

The purpose is to resolve the remaining ambiguity before an exact SQL migration is generated.

---

# 1. Executive decision

## 🔴 Migration is not yet SQL-ready

The logical schema target is substantially reconciled, but the following implementation-level decisions must be closed before an exact migration can be treated as canonical:

1. User status domain
2. Patient status domain
3. `visit_date` type
4. User email nullability / uniqueness / Auth synchronization semantics
5. `users.display_name` nullability and backfill rule
6. `has_clinic_role()` helper signature / RLS parity

Additional implementation conditions remain open for provider membership enforcement, tenant-consistent foreign keys, and server-side state-transition enforcement.

No blocker in this register should be resolved by inventing a new domain concept merely to make the migration compile.

---

# 2. Source-of-truth hierarchy

For blocker resolution, use this order:

1. Current user-approved SmileFlow architecture decisions
2. `SOURCE_OF_TRUTH.md`
3. Current approved/frozen module contracts
4. `PHASE_2_SCHEMA_RECONCILIATION_DECISION_V1.md`
5. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
6. Runtime and authorization contracts
7. Reconstructed live Supabase baseline as implementation evidence
8. Historical Figma evidence only where explicitly authoritative

The reconstructed SQL is evidence of the recovered baseline, not an independent authority to redefine the target schema.

---

# 3. Blocker register

| ID | Area | Severity | Status | Migration action |
|---|---|---:|---|---|
| MB-01 | User status domain | HIGH | 🔴 OPEN | Freeze canonical User status before enum migration |
| MB-02 | Patient status domain | HIGH | 🔴 OPEN | Freeze canonical Patient status before enum migration |
| MB-03 | `visit_date` type | HIGH | 🔴 OPEN | Select `date` or `timestamptz` |
| MB-04 | User email semantics | HIGH | 🔴 OPEN | Freeze nullability, uniqueness and Auth synchronization |
| MB-05 | `users.display_name` nullability | HIGH | 🔴 OPEN | Define backfill and NOT NULL transition |
| MB-06 | RLS helper signature parity | HIGH | 🔴 OPEN | Reconcile `has_clinic_role()` signature before RLS QA |
| MB-07 | Provider clinic membership | MEDIUM/HIGH | 🟠 OPEN | Define composite FK or equivalent server-side enforcement |
| MB-08 | Tenant-consistent child relationships | HIGH | 🟠 REQUIRED | Preserve composite clinic/patient integrity in final SQL |
| MB-09 | Privileged state transitions | HIGH | 🟠 REQUIRED | Keep transition enforcement outside ordinary unrestricted CRUD |
| MB-10 | Deferred module fields | MEDIUM | 🟡 DEFERRED | Do not invent unresolved fields; preserve only justified baseline fields |

---

# 4. MB-01 — User status domain

## Finding

The reconciled core schema defines a User with a controlled status field. The database implementation specification describes the target conceptually as:

```text
Active / Inactive / Disabled
```

The reconstructed baseline instead defines:

```sql
create type public.smileflow_user_status as enum ('active','inactive');
```

and `users.status` defaults to `active`.

## Evidence

### Target

`PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`

Section 1.2 — `users`:

```text
status | text/enum | Active / Inactive / Disabled
```

### Baseline

Reconstructed SQL:

```text
create type public.smileflow_user_status as enum ('active','inactive');

create table public.users (
  id uuid primary key references auth.users(id) on delete restrict,
  display_name text,
  status public.smileflow_user_status not null default 'active',
  ...
);
```

## Classification

**Actual migration ambiguity.**

This is not merely a naming difference because `disabled` would create a new persisted state with potentially different authentication/account semantics.

## Resolution required

Freeze one authoritative account-status vocabulary and define its meaning:

```text
active
inactive
[disabled?]
```

If `disabled` is approved, define whether it means:

- application account disabled;
- Auth account disabled;
- membership disabled;
- or another distinct condition.

Do not add `disabled` to SQL merely because the implementation specification mentions it.

## Migration gate

🔴 **BLOCKS enum migration.**

---

# 5. MB-02 — Patient status domain

## Finding

The reconciled v1.1 Patient specification defines:

```text
status — Active / Archived
```

The reconstructed baseline contains:

```sql
status text not null default 'active'
  check (status in ('active','inactive','archived'))
```

## Evidence

### Target

`PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`, Patient section:

```text
status — Active / Archived
```

### Baseline

Reconstructed SQL `public.patients.status`:

```text
check (status in ('active','inactive','archived'))
```

## Classification

**Actual migration ambiguity.**

`inactive` cannot be removed safely until its semantic usage is established.

Possible meanings must not be guessed:

```text
inactive patient
vs
archived patient
vs
temporarily unavailable patient
```

## Resolution required

Audit all runtime/application references to `patients.status` and determine whether `inactive` is:

- obsolete reconstructed-baseline residue;
- a real runtime state that needs a contract decision;
- or an intentional compatibility state.

Only then should the target enum/check constraint be finalized.

## Migration gate

🔴 **BLOCKS Patient status constraint replacement.**

---

# 6. MB-03 — `visit_date` type

## Finding

The database/RLS implementation specification intentionally leaves the type unresolved:

```text
visit_date | timestamptz/date
```

The reconstructed baseline does not currently contain `visit_date`.

## Evidence

### Target implementation specification

`PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`, Section 1.6:

```text
visit_date | timestamptz/date | NOT NULL; exact domain choice to match implementation contract
```

### Baseline

`public.visits` currently contains visit state/timing fields but no canonical `visit_date` field.

## Classification

**Actual unresolved schema decision.**

This affects:

- date filtering;
- timezone semantics;
- longitudinal history ordering;
- reporting;
- UI display;
- migration SQL type.

## Resolution required

The authoritative Visit contract must explicitly select:

```text
DATE
```

or

```text
TIMESTAMPTZ
```

and define the meaning of the value.

## Migration gate

🔴 **BLOCKS exact `visits` migration.**

---

# 7. MB-04 — User email semantics

## Finding

The target User model includes `email`, but the reconstructed baseline `users` table does not.

The implementation specification describes email as controlled/unique according to the account contract, but does not freeze the exact SQL constraint.

## Evidence

### Target

`PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`, Section 1.2:

```text
email | text | controlled/unique according to account contract
```

### Baseline

Reconstructed `public.users` contains:

```text
id
 display_name
 status
 created_at
 updated_at
```

and no application-domain `email` column.

## Resolution required

Freeze all of the following:

1. Is `email` nullable?
2. Is it globally unique?
3. Is uniqueness case-insensitive?
4. Is Auth `auth.users.email` the authoritative value?
5. Does `public.users.email` mirror Auth email?
6. What happens when Auth email changes?
7. Is email editable through SmileFlow?
8. What happens to existing rows when the column is introduced?

## Classification

**Actual migration ambiguity.**

The field itself is approved; its persistence semantics are not fully frozen.

## Migration gate

🔴 **BLOCKS exact User migration.**

---

# 8. MB-05 — `users.display_name` nullability

## Finding

The implementation specification requires:

```text
display_name text NOT NULL
```

The reconstructed baseline defines:

```text
display_name text
```

with no NOT NULL constraint.

## Resolution required

Before adding `NOT NULL`, establish the backfill source:

```text
auth.users metadata
or
account provisioning contract
or
explicit application profile value
```

The migration must not blindly set arbitrary placeholder names.

Required sequence:

```text
inventory existing users
        ↓
resolve null display names
        ↓
backfill from authoritative source
        ↓
verify zero NULL rows
        ↓
apply NOT NULL
```

## Classification

**Real constraint migration issue, not an architectural contradiction.**

## Migration gate

🔴 **BLOCKS NOT NULL constraint application.**

---

# 9. MB-06 — `has_clinic_role()` helper signature parity

## Finding

The reconstructed baseline defines an authorization helper using a text-array role parameter:

```sql
create or replace function public.has_clinic_role(
  p_clinic_id uuid,
  p_roles text[]
)
```

The prior live/cloud inspection recorded a role-array signature using the SmileFlow role type. The final migration cannot safely assume the two signatures are interchangeable because PostgreSQL function identity includes argument types.

## Evidence

### Reconstructed baseline

The SQL baseline contains:

```text
public.has_clinic_role(uuid, text[])
```

### Security architecture

`PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_CONSISTENCY_AUDIT_V1.md` explicitly defers exact RLS helper implementation and requires safe membership/role checks without recursion or client-controlled authorization context.

## Classification

**Real implementation-parity blocker.**

This is especially important because local RLS QA can produce misleading results if the helper contract differs from the intended cloud/live implementation.

## Resolution required

Perform a direct read-only parity check of:

```text
function name
argument types
return type
SECURITY DEFINER/INVOKER
search_path
EXECUTE privileges
function owner
RLS interaction
```

Then freeze one canonical helper signature.

## Migration gate

🔴 **BLOCKS final RLS migration/QA baseline.**

---

# 10. MB-07 — Provider clinic membership

## Finding

The target Appointment and Visit models allow an optional `provider_user_id`.

The implementation specification requires that a provider, when supplied, must have valid membership in the resource clinic.

A simple FK:

```text
provider_user_id → users.user_id
```

does not prove clinic membership.

## Resolution options to evaluate

Preferred database-level approach:

```text
provider_user_id + clinic_id
        ↓
clinic membership relationship
```

or an equivalent server-side authorization check.

Do not rely only on FlutterFlow/client validation.

## Classification

**Implementation condition, not target-schema contradiction.**

## Status

🟠 OPEN.

---

# 11. MB-08 — Tenant-consistent child relationships

## Finding

SmileFlow intentionally stores `clinic_id` on clinic-owned resources and uses composite foreign keys in the reconstructed baseline for many patient/visit relationships.

This is correct and must be preserved.

Examples from the reconstructed baseline include:

```text
appointments (clinic_id, patient_id)
    → patients (clinic_id, id)

visits (clinic_id, patient_id)
    → patients (clinic_id, id)

clinical_notes (clinic_id, patient_id, visit_id)
    → visits (clinic_id, patient_id, id)
```

## Requirement

New relationships introduced by the target delta must preserve the same tenant-consistency principle.

The database/RLS consistency audit identifies this as a hard implementation requirement.

## Classification

**Required implementation safeguard.**

## Status

🟠 REQUIRED before production access.

---

# 12. MB-09 — Privileged state transitions

## Finding

The schema can constrain allowed enum values, but an enum/check constraint alone does not implement the approved state-transition graph.

The Runtime Workflow Contract requires current-state validation, permission checking, atomic persistence, concurrency protection, and idempotency.

Examples:

```text
Scheduled → Checked In
Checked In → Waiting
Waiting → Called
Called → In Treatment
In Treatment → Ready for Closure
Ready for Closure → Closed
```

Invalid jumps such as:

```text
Waiting → Closed
Scheduled → Closed
Closed → In Treatment
```

must not be possible through an unrestricted client update.

## Requirement

The migration must not accidentally expose privileged state transitions as ordinary unrestricted CRUD.

Final enforcement belongs to the approved runtime/database transaction boundary.

## Classification

**Runtime implementation requirement, not a reason to redesign the schema.**

## Status

🟠 REQUIRED before clinical workflow implementation.

---

# 13. MB-10 — Deferred module fields

The reconciled schema deliberately leaves several exact field inventories contract-dependent.

Examples:

- Patient Registration exact field inventory
- Patient Management exact field inventory
- Dental Chart finding vocabulary
- Treatment Planning fields beyond the reconciled lifecycle
- Performed Procedure finalization/status semantics
- Clinical Closure field-level validation
- Audit event taxonomy
- Document/storage taxonomy

## Rule

Do not invent fields merely to make the migration look complete.

At the same time, do not automatically delete useful reconstructed-baseline fields simply because they are absent from the compact target specification if their ownership has not been disproven.

Every such field must be classified as:

```text
REQUIRED
OPTIONAL/PRESERVE
DEFERRED
REMOVE
```

with evidence.

## Status

🟡 DEFERRED.

---

# 14. Known additive/constraint deltas that are NOT blockers

The following target changes are already sufficiently clear to be incorporated once the blockers above are resolved.

## Patient

```text
ADD suffix
RECONCILE date_of_birth → birth_date
```

## Appointment

```text
ADD provider_user_id
```

## Visit

```text
ADD provider_user_id
ADD visit_date   ← type still blocked by MB-03
ADD visit_type
ADD chair
```

## Treatment Plan

```text
ADD title NOT NULL
DO NOT ADD status
```

## Planned Treatment Item

```text
MAKE description NOT NULL
ADD sequence
PRESERVE four-state lifecycle only
```

The authoritative planned-item lifecycle remains:

```text
Planned → Scheduled → In Progress → Completed
```

No `Active`, `Cancelled`, or `Archived` value is authorized for that lifecycle.

---

# 15. Baseline fields requiring preservation review

The reconstructed baseline contains fields that are not all present in the compact target inventory.

Examples include:

### Patients

```text
preferred_name
civil_status
contact_number
email
address
emergency_contact_name
emergency_contact_number
```

### Planned treatment items

```text
title
planned_for
completed_at
notes
```

### Visits

```text
started_at
closed_at
```

These must **not** be deleted merely to force textual equality with the target specification.

They require explicit classification based on authoritative module contracts and source-of-truth evidence.

---

# 16. Required resolution order

Resolve blockers in this order:

```text
MB-01 User status
        ↓
MB-02 Patient status
        ↓
MB-03 visit_date type
        ↓
MB-04 User email semantics
        ↓
MB-05 display_name nullability/backfill
        ↓
MB-06 RLS helper parity
        ↓
MB-07 provider membership enforcement
        ↓
MB-08 tenant-consistent FK verification
        ↓
MB-09 transition enforcement boundary
        ↓
MB-10 deferred field classification
```

The order is intentional: enum and type semantics should be frozen before migration SQL is generated, and security helper parity should be established before RLS QA is used as evidence.

---

# 17. Resolution evidence required

A blocker is considered **RESOLVED** only when the repository contains explicit evidence for:

```text
1. authoritative decision
2. affected table/column/function
3. current baseline value
4. target value
5. migration operation
6. data/backfill implications
7. RLS/security implications where applicable
8. verification query/test
```

No blocker should be closed solely because a migration script happens to execute successfully.

---

# 18. Read-only verification checklist

Before generating the final migration, perform these read-only checks:

### Schema

```text
[ ] all target tables exist
[ ] all required target columns identified
[ ] all forbidden columns/enums identified
[ ] nullability differences enumerated
[ ] type differences enumerated
[ ] default differences enumerated
[ ] CHECK constraints enumerated
[ ] FK constraints enumerated
[ ] indexes enumerated
```

### Data safety

```text
[ ] row counts recorded
[ ] NULL counts recorded for columns becoming NOT NULL
[ ] existing enum/check values inventoried
[ ] duplicate email values checked
[ ] duplicate patient numbers checked
[ ] invalid tenant relationships checked
```

### Security

```text
[ ] RLS enabled/disabled state recorded
[ ] policy inventory recorded
[ ] helper function signatures recorded
[ ] function security mode recorded
[ ] function privileges recorded
[ ] Auth ↔ public.users relationship verified
```

### Runtime

```text
[ ] Visit transition enforcement boundary identified
[ ] Treatment Item transition enforcement boundary identified
[ ] Clinical Closure transaction boundary identified
[ ] Performed Procedure idempotency boundary identified
```

---

# 19. What must NOT happen while this register is open

```text
NO production migration
NO destructive enum replacement
NO silent field deletion
NO guessed visit_date type
NO guessed User/Patient status semantics
NO guessed email ownership model
NO RLS helper signature replacement without parity evidence
NO client-only clinical transition enforcement
NO production patient data writes
```

---

# 20. Exit criteria

This register can move to **RESOLVED / MIGRATION-READY** only when:

```text
MB-01 = RESOLVED
MB-02 = RESOLVED
MB-03 = RESOLVED
MB-04 = RESOLVED
MB-05 = RESOLVED
MB-06 = RESOLVED
MB-07 = ACCEPTED WITH IMPLEMENTATION MECHANISM
MB-08 = VERIFIED
MB-09 = ACCEPTED WITH RUNTIME ENFORCEMENT DESIGN
MB-10 = CLASSIFIED
```

Then produce:

> **PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION**

That document should contain the exact SQL delta, migration ordering, backfill strategy, rollback/safety strategy, RLS deployment ordering, and verification queries.

Only after that should the project use the explicit implementation authorization and environment gate to construct/test the migration.

---

# 21. Final register decision

## 🔴 PHASE 2 DATABASE MIGRATION — BLOCKED

The architecture is not being rejected.

The migration is being held because several concrete SQL semantics are not yet authoritative enough to encode safely.

This is the intended outcome of the readiness gate:

```text
Recovered baseline
      ↓
Reconciled target
      ↓
Migration readiness audit
      ↓
BLOCKER REGISTER  ← CURRENT GATE
      ↓
Resolve exact SQL semantics
      ↓
Final migration specification
      ↓
Implementation authorization/environment gate
      ↓
Migration construction
      ↓
Schema + RLS verification
```

**No production schema change is authorized by this document.**
