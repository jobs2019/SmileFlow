# SmileFlow Phase 2 — Migration Blocker Resolution Decisions v1

**Status:** READ-ONLY RESOLUTION COMPLETE — NO MIGRATION AUTHORIZED

**Baseline:** `b8bb65c857a63ad3c1a84a3b687a53027bd61e0d`

**Supabase project:** `bijeyikklzfqlipzlsqu` (`SmileFlow's Project`)

**Verified:** 2026-08-14

## Purpose

Resolve MB-01 through MB-06 from `PHASE_2_MIGRATION_BLOCKER_RESOLUTION_REGISTER.md` using exact repository source-of-truth evidence and direct read-only inspection of the connected Supabase/Postgres project.

No DDL, migration, RLS policy, Auth configuration, or application code was changed.

---

# Executive result

| Blocker | Final decision | Status |
|---|---|---|
| MB-01 User status | `active`, `inactive`, `disabled` | 🟢 RESOLVED |
| MB-02 Patient status | `active`, `archived` only | 🟢 RESOLVED |
| MB-03 `visit_date` | `timestamptz` | 🟢 RESOLVED |
| MB-04 User email | required domain field; Auth remains identity authority; public uniqueness not independently invented | 🟢 RESOLVED |
| MB-05 `display_name` | `NOT NULL`; no backfill required in current DB because zero rows | 🟢 RESOLVED |
| MB-06 `has_clinic_role()` | `uuid, smileflow_role[] → boolean`, SECURITY DEFINER, fixed search path | 🟢 RESOLVED |

**MB-01 through MB-06 are now closed as migration-semantics blockers.**

This does **not** mean the migration is authorized. MB-07 through MB-10 and the implementation-authorization gate remain.

---

# Evidence baseline

## Repository

The Phase 2 implementation specification states that the `users` target contains `email`, `display_name`, and a controlled status of `Active / Inactive / Disabled`. It also specifies `display_name` as NOT NULL. For Visit it leaves `visit_date` as `timestamptz/date` pending the implementation contract. fileciteturn197file0L7-L7

The reconciled v1.1 Core Data specification establishes the canonical Patient fields, including `suffix`, `birth_date`, and Patient status `Active / Archived`; it also establishes the canonical Visit field `visit_date` and removes any Treatment Plan container status. fileciteturn217file0L2-L2

The original Core Data schema v1.0 is stronger on Visit type: it defines `visit_date` as a timestamp/encounter timestamp. It also defines the original User `email` as required and says uniqueness is governed by the authentication system. fileciteturn214file0L7-L7

The Authentication/Authorization specification makes the application User separate from provider-managed credentials and requires authenticated identity to map to the SmileFlow User identity. fileciteturn198file0L7-L7

The Authentication/Authorization consistency audit found no structural contradiction in the identity, membership, tenant, or authorship model. fileciteturn211file0L7-L7

## Supabase

The connected Supabase project is active/healthy and uses PostgreSQL 17.6.1.

Current migrations are already present through:

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

The live database currently contains **zero rows** in:

```text
public.users
public.patients
public.visits
public.clinic_memberships
```

It also contains zero Auth users.

These observations are read-only and do not authorize a migration.

---

# MB-01 — User status domain

## Previous blocker

The recovered baseline had:

```text
active
inactive
```

while the Phase 2 implementation specification stated:

```text
Active / Inactive / Disabled
```

## Exact repository evidence

`PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`, User section:

```text
status | text/enum | Active / Inactive / Disabled
```

The Authentication/Authorization contract separately states that account lifecycle must support Active and Inactive/Disabled, while membership status is separately Active/Inactive. fileciteturn198file0L7-L7

## Live Supabase evidence

The connected database currently exposes:

```text
public.smileflow_user_status
  active
  inactive
```

No `disabled` enum value currently exists.

There are zero rows in `public.users`, so no existing User status data would require conversion.

## Resolution

**Canonical User status domain:**

```text
active
inactive
disabled
```

Semantic ownership:

- `active` = application user may operate normally subject to membership/permission;
- `inactive` = application identity remains retained but is not active;
- `disabled` = application identity is explicitly disabled and must not be treated as an active application identity.

`clinic_memberships.status` remains a separate membership state and continues to use its own Active/Inactive lifecycle.

The User status must not be reused as a clinic membership status.

## Migration implication

The eventual migration may extend the existing `smileflow_user_status` enum with `disabled`.

Because current `public.users` row count is zero, no existing-row status conversion is required in the inspected environment.

## Decision

🟢 **MB-01 RESOLVED.**

---

# MB-02 — Patient status domain

## Previous blocker

Recovered baseline:

```text
active
inactive
archived
```

Target v1.1:

```text
Active / Archived
```

## Exact repository evidence

The reconciled v1.1 Patient definition explicitly states:

```text
status — Active / Archived
```

and the v1.1 document says it is the reconciled governing specification. fileciteturn217file0L2-L2

The schema reconciliation decision establishes that approved current module contracts take precedence over the proposed/reconstructed schema. fileciteturn213file0L7-L7

## Live Supabase evidence

Current constraint:

```text
patients_status_check
CHECK (status = ANY (ARRAY['active','inactive','archived']))
```

Current row count:

```text
public.patients = 0
```

Therefore there is no live `inactive` Patient data to preserve in the inspected environment.

## Resolution

Canonical Patient status:

```text
active
archived
```

`inactive` is not part of the Phase 2 Patient lifecycle and must not remain as an additional canonical Patient status.

Do not reinterpret `inactive` as a third canonical Patient state.

## Migration implication

Replace the current Patient status check/domain with the v1.1 two-state contract.

No data backfill is required in the current zero-row environment.

## Decision

🟢 **MB-02 RESOLVED.**

---

# MB-03 — `visit_date` type

## Previous blocker

Implementation specification allowed:

```text
`timestamptz/date`
```

## Exact repository evidence

The original Core Data schema defines:

```text
visit_date | timestamp | Yes | Encounter timestamp
```

and describes Visit as the actual clinical encounter. fileciteturn214file0L7-L7

The implementation-level specification uses:

```text
visit_date | timestamptz/date
```

while explicitly deferring the exact domain choice to the implementation contract. fileciteturn197file0L7-L7

The existing Visit timing fields in the live database are already PostgreSQL `timestamptz`:

```text
started_at  timestamptz
closed_at   timestamptz
```

## Resolution

Canonical type:

```text
visits.visit_date = timestamptz NOT NULL
```

Semantic meaning:

> The timestamp representing the actual clinical encounter date/time in the system's canonical timezone-aware representation.

This is preferable to `date` because the authoritative v1.0 contract calls it an **encounter timestamp**, and the recovered Visit model already uses timezone-aware timestamps for encounter start/closure.

## Migration implication

Add:

```text
visit_date timestamptz NOT NULL
```

The exact default/backfill behavior for any future non-empty environment must be explicit; no arbitrary historical date may be invented.

Current live row count is zero, so no existing Visit backfill is required in the inspected environment.

## Decision

🟢 **MB-03 RESOLVED.**

---

# MB-04 — User email semantics

## Previous blocker

The target requires `users.email`, but the recovered baseline has no public `email` column.

The previous concern was whether it should be independently unique, nullable, or synchronized with Auth.

## Exact repository evidence

Core Data v1 defines:

```text
email | text | Yes | Authentication identity; uniqueness governed by auth system
```

fileciteturn214file0L7-L7

The Authentication/Authorization specification states that the application User is mapped from authentication identity and that credential material belongs to the authentication provider. fileciteturn198file0L7-L7

## Supabase evidence

Supabase's current User Management documentation states that the `auth` schema is not exposed through the auto-generated API and recommends a public application table referencing `auth.users` for application user data. It also documents maintaining that public profile row from `auth.users` through an `after insert` trigger. The Supabase Auth hook documentation confirms that Auth's user object contains the email address. 

This supports the architecture of:

```text
Supabase Auth
    ↓
auth.users.email
    ↓
SmileFlow public.users.email
```

rather than making `public.users.email` a second independent authentication authority.

## Live evidence

```text
public.users row count = 0
auth.users row count = 0
```

No existing email data requires reconciliation.

## Resolution

Canonical semantics:

1. `public.users.email` is **NOT NULL**.
2. `auth.users.email` remains the authentication authority.
3. SmileFlow `public.users.email` is the application-domain copy of the Auth email.
4. Do **not** invent an independent public email uniqueness rule that could compete with Auth.
5. Email changes must be synchronized with the Auth identity rather than treated as an unrelated profile edit.
6. No password/credential material belongs in `public.users`.

The exact synchronization mechanism is an implementation detail and can use an approved Auth trigger/hook/server-side mechanism; it is no longer a schema-semantics blocker.

## Migration implication

Add:

```text
users.email text NOT NULL
```

No existing-row backfill is required in the current zero-row environment.

## Decision

🟢 **MB-04 RESOLVED.**

---

# MB-05 — `users.display_name` nullability

## Previous blocker

Target implementation requires:

```text
display_name NOT NULL
```

Recovered baseline has a nullable `display_name`.

## Exact repository evidence

The Phase 2 database/RLS implementation specification defines:

```text
display_name | text | NOT NULL
```

fileciteturn197file0L7-L7

The Authentication/Authorization model treats display/profile information as application-domain User information, separate from Auth credentials. fileciteturn198file0L7-L7

## Live Supabase evidence

Current schema:

```text
public.users.display_name text
is_nullable = YES
```

Current data:

```text
public.users row count = 0
NULL display_name rows = 0
```

## Resolution

Canonical rule:

```text
display_name text NOT NULL
```

No placeholder/default display name is authorized.

New User provisioning must supply a valid display name before the public User row is considered complete.

## Migration implication

Because the inspected database has zero `public.users` rows, the NOT NULL transition has no current data backfill requirement.

Future provisioning must guarantee a non-null value before insertion or use a transaction that supplies it atomically.

## Decision

🟢 **MB-05 RESOLVED.**

---

# MB-06 — `has_clinic_role()` helper signature parity

## Previous blocker

The earlier reconstructed-baseline analysis reported a possible mismatch between:

```text
(uuid, text[])
```

and:

```text
(uuid, smileflow_role[])
```

This needed direct live verification.

## Exact live Supabase evidence

The connected database currently defines:

```text
public.has_clinic_role(
  p_clinic_id uuid,
  p_roles smileflow_role[]
)
returns boolean
```

and:

```text
SECURITY DEFINER
STABLE
SET search_path TO 'pg_catalog', 'pg_temp'
```

Its implementation checks `clinic_memberships` for:

```text
clinic_id = p_clinic_id
user_id = auth.uid()
status = 'active'
role = ANY(p_roles)
```

This is direct database evidence, not inferred from the reconstructed SQL.

## Resolution

Canonical helper signature:

```text
public.has_clinic_role(uuid, smileflow_role[]) → boolean
```

Canonical security properties observed live:

```text
SECURITY DEFINER
STABLE
fixed search_path = pg_catalog, pg_temp
```

The helper's authorization predicate correctly uses the authenticated identity (`auth.uid()`), active membership, clinic ID, and role membership.

## Important correction

The previous blocker statement that the live/cloud signature might be `text[]` was **not supported by the current live database**.

The direct live inspection establishes that the current project already uses `smileflow_role[]`.

Therefore MB-06 is a **false-positive blocker from the earlier reconstructed-baseline comparison**, not a real migration defect.

## Decision

🟢 **MB-06 RESOLVED — FALSE POSITIVE / LIVE PARITY CONFIRMED.**

---

# 7. Final blocker matrix

| ID | Previous issue | Evidence result | Final classification | Status |
|---|---|---|---|---|
| MB-01 | User status missing `disabled` | Repository target explicitly includes Disabled; live enum lacks it; zero rows | Real target delta | 🟢 RESOLVED |
| MB-02 | Patient has extra `inactive` | v1.1 explicitly Active/Archived; live has zero rows | Real target delta | 🟢 RESOLVED |
| MB-03 | `visit_date` type ambiguous | v1.0 defines encounter timestamp; implementation uses timestamptz/date; live timing fields are timestamptz | Real target type decision | 🟢 RESOLVED |
| MB-04 | Email semantics unclear | v1.0 says required and Auth governs uniqueness; Supabase Auth is identity source | Real implementation detail, semantics now frozen | 🟢 RESOLVED |
| MB-05 | `display_name` nullable | target says NOT NULL; live has zero rows | Real constraint delta | 🟢 RESOLVED |
| MB-06 | Possible helper signature mismatch | live database directly confirms `smileflow_role[]` | False positive / baseline reconstruction mismatch | 🟢 RESOLVED |

---

# 8. Remaining gates after MB-01–MB-06

Resolving these six blockers does **not** authorize migration.

Still open:

### MB-07 — Provider clinic membership

`appointments.provider_user_id` and `visits.provider_user_id` must enforce same-clinic provider membership.

### MB-08 — Tenant-consistent FK verification

All new relationships must preserve the clinic boundary using appropriate composite/validated relationships.

### MB-09 — Runtime state-transition enforcement

The Runtime Workflow Contract requires server-side current-state validation, permission checks, atomicity, concurrency handling, and idempotency. fileciteturn199file0L7-L7

### MB-10 — Deferred field inventory

Unresolved module-specific fields remain preserved/deferred and must not be invented or destructively removed.

---

# 9. Migration readiness conclusion

## MB-01 through MB-06

**RESOLVED.**

The six blockers no longer prevent generation of an exact migration design.

## Overall Phase 2 migration

**Still NOT AUTHORIZED.**

The next correct artifact is:

> `PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION.md`

That document should now encode the resolved decisions exactly, then undergo a final read-only SQL/RLS review before implementation authorization.

No production or local database changes were made while resolving MB-01 through MB-06.
