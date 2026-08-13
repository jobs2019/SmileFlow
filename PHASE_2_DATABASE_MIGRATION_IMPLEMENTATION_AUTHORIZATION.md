# SmileFlow Phase 2 — Database Migration Implementation Authorization

**Status:** AUTHORIZED — QA/DISPOSABLE ENVIRONMENT ONLY  
**Production migration:** NOT AUTHORIZED  
**Date:** 2026-08-14  
**Baseline:** `b8bb65c857a63ad3c1a84a3b687a53027bd61e0d`  
**Target specification:** `PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION.md`  
**Blocker decisions:** `PHASE_2_MIGRATION_BLOCKER_RESOLUTION_DECISIONS_V1.md`

---

## 1. Authorization statement

Explicit authorization is granted to **construct, apply, inspect, test, and validate the Phase 2 database migration in the disposable/local QA environment only**, using the finalized Phase 2 migration specification as the source of truth.

This authorization permits:

- generation of the executable migration SQL;
- creation of the migration file(s) in the SmileFlow QA/work branch;
- application of the migration to the disposable/local Docker/Postgres environment;
- creation/update of local QA RLS policies, helper functions, triggers, and constraints required by the approved migration design;
- execution of schema, referential-integrity, RLS, and security verification tests;
- correction of migration defects discovered during QA;
- iteration within the disposable/local environment until the migration passes the defined verification gates.

This authorization does **not** authorize any change to the production/cloud Supabase database.

---

# 2. Scope of authorization

## Authorized environment

```text
LOCAL / DISPOSABLE QA DATABASE

PostgreSQL/Supabase-compatible local environment
Docker-backed
Disposable/rebuildable
No production patient data
```

## Explicitly unauthorized environment

```text
PRODUCTION SUPABASE
LIVE PATIENT DATA
LIVE AUTH USERS
LIVE STORAGE OBJECTS
```

No production connection string, production service role key, production JWT secret, or production database credential may be used during this phase.

---

# 3. Source-of-truth chain

The implementation must be generated from this order of authority:

1. current user-approved SmileFlow architecture;
2. `SOURCE_OF_TRUTH.md`;
3. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`;
4. `PHASE_2_MIGRATION_BLOCKER_RESOLUTION_DECISIONS_V1.md`;
5. `PHASE_2_FINAL_FIELD_INVENTORY_RECONCILIATION.md`;
6. `PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION.md`;
7. `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`;
8. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md`;
9. approved consistency-audit decisions;
10. recovered baseline SQL as implementation evidence only.

The reconstructed baseline must not override an explicitly resolved target decision.

---

# 4. Resolved MB-01 through MB-06

The following migration semantics are frozen for implementation:

| Blocker | Canonical decision | Status |
|---|---|---|
| MB-01 | User status = `active`, `inactive`, `disabled` | RESOLVED |
| MB-02 | Patient status = `active`, `archived` | RESOLVED |
| MB-03 | `visits.visit_date` = `timestamptz NOT NULL` | RESOLVED |
| MB-04 | `users.email` = required application-domain copy; Auth remains identity authority | RESOLVED |
| MB-05 | `users.display_name` = `NOT NULL` | RESOLVED |
| MB-06 | `has_clinic_role(uuid, smileflow_role[]) → boolean`, SECURITY DEFINER, fixed search path | RESOLVED |

No alternate interpretation may be introduced merely to simplify SQL.

---

# 5. Authorized Phase 2 schema delta

The migration may implement the following approved target delta.

## Users

```text
ADD users.email text NOT NULL
ALTER users.display_name → NOT NULL
EXTEND user status domain with `disabled`
```

`auth.users` remains the authentication authority.

## Patients

```text
ADD patients.suffix text NULL
RECONCILE patients.date_of_birth → patients.birth_date
RESTRICT Patient status to active / archived
```

No Patient data may be deleted merely because the recovered baseline contains additional fields that remain deferred.

## Appointments

```text
ADD appointments.provider_user_id uuid NULL
```

Provider membership must remain clinic-consistent.

## Visits

```text
ADD visits.provider_user_id uuid NULL
ADD visits.visit_date timestamptz NOT NULL
ADD visits.visit_type text
ADD visits.chair text NULL
```

Existing `started_at` and `closed_at` fields are preserved unless an explicitly approved later contract supersedes them.

## Treatment Plans

```text
ADD treatment_plans.title text NOT NULL
```

Do **not** add `treatment_plans.status`.

## Planned Treatment Items

```text
ALTER planned_treatment_items.description → NOT NULL
ADD planned_treatment_items.sequence integer NULL
```

Preserve the approved four-state lifecycle:

```text
planned
scheduled
in_progress
completed
```

Do not introduce:

```text
active
cancelled
archived
```

---

# 6. Deferred fields

The migration must not destructively remove unresolved recovered-baseline fields.

These remain preserved/deferred until their authoritative module contracts resolve them:

```text
patients.preferred_name
patients.civil_status
patients.contact_number
patients.email
patients.address
patients.emergency_contact_name
patients.emergency_contact_number

appointments.reason

planned_treatment_items.title
planned_treatment_items.planned_for
planned_treatment_items.completed_at
planned_treatment_items.notes
```

Preservation does not make these fields canonical. It prevents premature destructive schema changes.

---

# 7. Required implementation order

The executable migration must follow dependency order.

```text
1. extensions / enum prerequisites
2. users
3. clinics / clinic memberships as required by baseline
4. patients
5. provider-related relationship constraints
6. appointments
7. visits
8. clinical foundation dependencies
9. treatment plans
10. planned treatment items
11. indexes / uniqueness / composite constraints
12. helper functions
13. RLS policies
14. privileged transaction functions / triggers where approved
15. verification assertions
```

Do not apply child-table foreign keys before their parent keys/types exist.

Do not enable a new RLS policy that depends on a helper function before the helper function has been created and verified.

---

# 8. Tenant-integrity authorization

Every clinic-owned relationship must preserve the tenant boundary.

The implementation must prevent cross-clinic references for:

```text
appointments → patients
appointments → providers
visits → patients
visits → appointments
visits → providers
treatment_plans → patients
planned_treatment_items → treatment_plans
planned_treatment_items → patients
performed_procedures → patients/visits
clinical_closures → patients/visits
```

Where practical, use composite foreign keys or equivalent database-level validation that includes `clinic_id`.

Client-side validation is not sufficient.

---

# 9. Provider authorization

For:

```text
appointments.provider_user_id
visits.provider_user_id
```

when non-null, the provider must be an active member of the same clinic.

The implementation must verify this through a database/server authorization boundary.

A plain FK to `users.id` alone is insufficient if it permits a provider from another clinic to be assigned.

---

# 10. RLS implementation authorization

The QA migration may implement and test the approved RLS architecture.

The canonical helper is:

```text
public.has_clinic_role(uuid, smileflow_role[]) → boolean
```

Required observed security properties:

```text
SECURITY DEFINER
STABLE
search_path = pg_catalog, pg_temp
```

The helper must derive the acting identity from:

```text
auth.uid()
```

and evaluate active clinic membership and role.

RLS must not trust arbitrary client-supplied `clinic_id` or acting-user identity as an authorization fact.

---

# 11. Auth boundary

The QA migration may create/update the public application User boundary required by the approved architecture.

Rules:

```text
auth.users
    ↓
identity authority

public.users
    ↓
SmileFlow application identity
```

`public.users` must not contain:

```text
passwords
password hashes
refresh tokens
reset secrets
MFA secrets
```

Email synchronization must not create a competing authentication authority.

---

# 12. State-transition authorization

The migration may create the database primitives needed to support approved server-side state-transition enforcement.

However, a simple CHECK constraint is not considered sufficient for the clinical transition graph.

The runtime contract requires:

```text
persisted current-state validation
permission validation
atomic persistence
concurrency handling
idempotency
```

The following must remain independently owned:

```text
Appointment.status
Visit.visit_state
PlannedTreatmentItem.status
ClinicalClosure.outcome
```

Do not reuse one generic state enum across these domains.

---

# 13. Clinical Closure authorization

QA implementation may create the approved closure transaction boundary.

Closure must atomically:

```text
1. verify accessible Visit
2. verify current Visit state
3. verify acting-user permission
4. create/update closure record
5. set Visit = Closed
6. write required audit information
7. COMMIT
```

The client must not implement these as unrelated independent updates.

---

# 14. Data-safety requirements

Before applying the migration to any environment, capture:

```text
schema snapshot
row counts
NULL counts
enum/check values
FK inventory
index inventory
RLS policy inventory
function signatures
```

For the currently inspected Supabase project, the affected core tables contain zero rows and no live Auth users were observed. This is useful evidence but does not permit production migration.

The local QA environment must still run the complete preflight checks.

---

# 15. Migration execution rules

The implementation agent/operator is authorized to:

```text
CREATE migration SQL
RUN migration locally
DROP/recreate disposable local DB
RE-RUN migration from clean state
RUN verification queries
RUN RLS tests
RUN tenant-isolation tests
RUN role-isolation tests
FIX migration defects
REPEAT
```

The implementation agent/operator is **not** authorized to:

```text
RUN migration against production
RESET production database
DROP production tables
ALTER live patient data
CREATE production Auth users
CHANGE production RLS
CHANGE production Storage policies
```

---

# 16. Required QA test matrix

## Schema

```text
[ ] migration applies from clean disposable baseline
[ ] migration is repeatable/idempotency strategy is verified
[ ] all required columns exist
[ ] forbidden columns/statuses are absent
[ ] required NOT NULL constraints exist
[ ] types match frozen specification
[ ] FK constraints exist
[ ] tenant-consistency constraints exist
[ ] unique constraints exist
[ ] required indexes exist
```

## Authentication

```text
[ ] authenticated identity maps to public.users
[ ] unauthenticated access denied
[ ] email synchronization behaves correctly
[ ] disabled User cannot operate as active application identity
```

## Tenant isolation

At minimum:

```text
Clinic A user → Clinic A data = ALLOW
Clinic A user → Clinic B data = DENY
Clinic B user → Clinic B data = ALLOW
Clinic B user → Clinic A data = DENY
```

## Role isolation

At minimum:

```text
Administrator → authorized operations = ALLOW
Dentist → clinical operations = ALLOW where specified
Dental Assistant → permitted operational operations = ALLOW
Receptionist → permitted scheduling/registration operations = ALLOW
Unauthorized role → restricted operation = DENY
```

Exact permission matrix remains governed by the Authorization contract.

## Clinical lifecycle

Test valid transitions and invalid jumps for:

```text
Visit State
Planned Treatment Item Status
Clinical Closure
```

## Tenant-integrity attacks

Attempt cross-clinic references for:

```text
patient
provider
appointment
visit
treatment plan
planned item
clinical note
performed procedure
closure
```

All unauthorized cross-clinic references must fail.

---

# 17. Rollback / recovery

The local QA environment is disposable.

Preferred rollback during development:

```text
DROP disposable database/container
RECREATE from approved baseline
REAPPLY migration
RERUN tests
```

Do not design a destructive production rollback around this QA authorization.

A future production migration requires its own backup, rollback, maintenance-window, and recovery authorization.

---

# 18. Production gate

This authorization explicitly stops before production.

Production requires a separate gate after successful local QA:

```text
LOCAL MIGRATION
      ↓
SCHEMA VERIFICATION
      ↓
RLS VERIFICATION
      ↓
AUTH VERIFICATION
      ↓
CLINIC A/B ISOLATION
      ↓
ROLE ISOLATION
      ↓
RUNTIME WORKFLOW TESTS
      ↓
QA SIGN-OFF
      ↓
PRODUCTION MIGRATION AUTHORIZATION
```

A successful local migration does not automatically authorize production.

---

# 19. Required artifacts after implementation

Before production consideration, the following must exist:

```text
PHASE_2_EXECUTABLE_DATABASE_MIGRATION.sql
PHASE_2_MIGRATION_VERIFICATION_REPORT.md
PHASE_2_RLS_SECURITY_TEST_REPORT.md
PHASE_2_AUTH_INTEGRATION_TEST_REPORT.md
PHASE_2_TENANT_ISOLATION_TEST_REPORT.md
PHASE_2_RUNTIME_STATE_TRANSITION_TEST_REPORT.md
```

Any failed test must remain visible in the QA record until resolved or explicitly accepted by the appropriate gate.

---

# 20. Final authorization decision

## 🟢 AUTHORIZED FOR LOCAL/DISPOSABLE QA IMPLEMENTATION

The Phase 2 database migration may now be **constructed and executed against the disposable/local Docker QA environment**.

## 🔴 NOT AUTHORIZED FOR PRODUCTION

No production Supabase migration or live-data modification is authorized by this artifact.

## Gate ownership

This artifact authorizes the **implementation/testing phase**, not production deployment.

The next required operational step is:

> Generate the executable Phase 2 migration from `PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION.md`, apply it only to the disposable/local Docker QA environment, and run the full schema + RLS + Auth + Clinic A/B + role-isolation verification suite.

**No production database action is permitted until a separate production authorization is explicitly granted.**
