# SmileFlow Phase 2 — Authentication & Authorization Specification v1.0

## Status

**PROPOSED — NOT IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-13

## Purpose

Define the identity, authentication, clinic-membership, role, authorization, session, and access-boundary contract required before SmileFlow connects the reconciled Core Data schema to a real backend.

This document does not select or configure an authentication provider, create users, create database policies, or implement login.

## Governing principles

1. **Authentication answers who the user is. Authorization answers what that user may do.**
2. **Clinic membership is the tenant boundary.** A user's access to a clinic must be explicit.
3. **Deny by default.** An authenticated user receives no clinical-data access merely by being authenticated.
4. **Least privilege.** Permissions are granted only where required by the approved workflow.
5. **No client-only authorization.** UI visibility is not a security boundary; server/database enforcement is required for production.
6. **One canonical application user.** Authentication identity maps to the SmileFlow `user_id` domain identity.
7. **No credential material in the application-domain User entity.** The authentication provider owns passwords, tokens, and credential recovery material.
8. **Clinic isolation is mandatory.** A user must never access another clinic's records through an ID, URL, API call, or client-state manipulation.
9. **Clinical mutations require authenticated authorship.** Important clinical writes must identify the acting user and clinic.
10. **Role semantics must not be inferred from screen visibility.** Permissions are explicit runtime rules.

## Identity model

```text
Authentication Identity
        │
        │ maps to
        ▼
SmileFlow User (`user_id`)
        │
        ├── Clinic Membership A
        │       └── Role
        │
        └── Clinic Membership B
                └── Role
```

A single user may have multiple clinic memberships in the future. The active clinic context must always be explicit.

## Authentication requirements

The production authentication boundary must support:

- sign in;
- sign out;
- session establishment;
- session persistence/refresh according to the selected provider;
- account recovery;
- authenticated identity retrieval;
- expired/invalid session handling.

The exact authentication mechanism is deferred to the Technology Decision gate.

### Credentials

Passwords, password hashes, reset secrets, MFA secrets, refresh tokens, and other credential material must not be stored in the SmileFlow application-domain `User` record unless the selected provider explicitly requires a secure provider-managed representation.

## Session requirements

A valid authenticated session must establish:

```text
user_id
active clinic context
membership/role context
session validity
```

The client must not be trusted to self-assign `clinic_id` or `role`.

Changing clinic context, where multi-clinic membership exists, must resolve against server-side membership rather than arbitrary client input.

## Clinic membership

The reconciled schema uses:

```text
Clinic Membership
 ├── membership_id
 ├── clinic_id
 ├── user_id
 ├── role
 └── status
```

A user may access clinic data only through an **active membership** for that clinic.

Inactive membership must not grant access.

## Roles

The initial approved application roles are:

1. **Dentist**
2. **Dental Assistant**
3. **Receptionist**
4. **Administrator**

These roles are application authorization roles, not claims about professional licensure.

## Permission model

Authorization should be modeled as:

```text
User
  ↓
Active Clinic Membership
  ↓
Role
  ↓
Permission
  ↓
Resource / Action
```

The system must avoid hard-coding authorization solely as UI conditions such as `if role === dentist`.

## Initial permission matrix

| Capability | Dentist | Dental Assistant | Receptionist | Administrator |
|---|---:|---:|---:|---:|
| Sign in / use assigned clinic | Yes | Yes | Yes | Yes |
| View patient identity | Yes | Yes | Yes | Yes |
| Register patient | Yes | Yes | Yes | Yes |
| Manage basic patient information | Yes | Yes | Yes | Yes |
| View appointments | Yes | Yes | Yes | Yes |
| Manage scheduling | Yes | Yes | Yes | Yes |
| Open visit | Yes | Yes | Yes | Yes |
| View clinical chart | Yes | Yes | Restricted by approved workflow | Yes |
| Edit dental chart | Yes | Yes, where authorized | No by default | Yes |
| Create clinical notes | Yes | Yes, where authorized | No | Yes |
| Record diagnosis | Yes | No by default | No | Yes, where explicitly authorized |
| Record performed procedure | Yes | Yes, where authorized | No | Yes |
| Create/manage treatment plan | Yes | No by default | No | Yes, where explicitly authorized |
| Perform clinical closure | Yes | No by default | No | Yes, where explicitly authorized |
| View clinical history | Yes | Yes, where authorized | Limited to approved non-clinical scope | Yes |
| Upload clinical documents | Yes | Yes, where authorized | Yes, where operationally required | Yes |
| Manage users/memberships | No by default | No | No | Yes |
| Manage clinic configuration | No by default | No | No | Yes |
| View audit events | Yes, limited/approved | No by default | No by default | Yes |

### Important authorization rule

The matrix above is an **initial proposal**, not a final clinical permission contract. Any capability marked "where authorized", "restricted", "limited", or "explicitly authorized" requires a later permission-level decision before production implementation.

No ambiguous permission may be silently converted into unrestricted access.

## Resource-level isolation

Every clinic-owned clinical resource must resolve to a clinic boundary.

Conceptually:

```text
request
  ↓
authenticated user
  ↓
active membership
  ↓
resource clinic_id
  ↓
clinic_id matches membership
  ↓
permission allows action
  ↓
allow
```

Otherwise:

```text
DENY
```

This must be enforced outside the visual client layer.

## Patient access

A user may access a patient only when:

1. the user is authenticated;
2. the user has an active membership in the patient's clinic;
3. the user's role has the required patient permission.

A patient ID alone must never be sufficient to retrieve a record.

## Visit access

A visit inherits its clinic boundary through its persisted `clinic_id` and patient relationship.

Clinical visit access additionally requires the relevant role permission.

The active visit context must not be accepted merely because a client supplies a `visit_id`.

## Clinical mutation authorship

Clinical mutations must be attributable to the authenticated user.

Where the schema requires:

```text
created_by
updated_by
recorded_by
performed_by
```

these values must be derived from the authenticated server-side identity rather than trusted client-provided user IDs.

## Clinical closure authorization

Clinical Closure is a privileged clinical boundary.

The runtime must verify that the acting user has permission to perform closure for the relevant visit before committing a closure outcome.

Closure authorization must remain separate from merely being able to view a visit.

## Treatment Planning authorization

Treatment-plan item lifecycle mutations must be permission-checked independently from visit-state transitions.

```text
Visit State
    ≠
Treatment Plan Item Status
```

A role authorized to update a visit is not automatically authorized to alter treatment-plan lifecycle state.

## Dental Chart authorization

Dental Chart permissions must distinguish at least:

- view chart;
- create/update chart findings;
- perform privileged corrections where applicable.

The chart permission does not grant treatment-planning, performed-procedure, or closure authority.

## Patient Registration vs Patient Management

Both modules operate on the same canonical Patient entity.

Authorization therefore controls actions, not ownership duplication:

```text
Registration
   ↓
creates/updates permitted patient fields

Management
   ↓
views/manages permitted patient information
```

A user cannot bypass field-level authorization by entering through the other module.

## Administrator boundary

Administrator is not automatically equivalent to unrestricted clinical authority.

Administrative permissions should cover clinic/user/configuration operations. Clinical permissions marked as requiring explicit authorization must remain explicit.

This prevents an administrative role from silently becoming a clinical role.

## Audit requirements

Security-sensitive and clinical authorization decisions should be auditable where appropriate, including:

- sign-in/sign-out events where supported;
- membership changes;
- role changes;
- permission-sensitive clinical mutations;
- unauthorized access attempts where the production security architecture supports capture.

The detailed audit-event taxonomy is deferred to the Audit Trail specification.

## Failure behavior

The application must distinguish:

### Unauthenticated

No valid session exists.

Expected behavior: redirect/return to authentication boundary.

### Unauthorized

The user is authenticated but lacks the required permission.

Expected behavior: deny the action and do not expose protected data.

### Wrong clinic

The user is authenticated but has no active membership for the resource's clinic.

Expected behavior: deny as though the resource is not accessible; do not leak cross-clinic existence information.

### Inactive membership

Membership exists but is inactive.

Expected behavior: deny access.

## Role change behavior

Role and membership changes must take effect according to the server-side authorization source.

A stale client session must not permanently preserve privileges after membership/role revocation.

The exact session invalidation/refresh mechanism belongs to the selected authentication architecture.

## Account lifecycle

At minimum, application identity should support:

```text
Active
Inactive / Disabled
```

Deactivation must prevent new authenticated access while preserving historical authorship and audit references where required.

The User record should not be destructively deleted merely to remove access.

## Security boundaries explicitly deferred

The following require later production-hardening specifications:

- MFA policy;
- password policy if provider-managed;
- session duration;
- refresh-token policy;
- device/session management;
- brute-force/rate limiting;
- IP/network restrictions if required;
- encryption/key management;
- detailed security logging;
- regulatory/privacy policy;
- backup/recovery controls.

These are not ignored; they belong to Phase 6 security hardening and the selected authentication provider architecture.

## Implementation constraints

This specification does **not** authorize:

- authentication provider configuration;
- login implementation;
- user creation in production;
- database RLS policies;
- API authorization middleware;
- Figma modifications;
- clinical workflow changes.

## Readiness gate

Before authentication/authorization implementation is authorized, the following must pass:

1. Core Data Schema Consistency Audit v2 — **required**
2. Authentication/Authorization Consistency Audit — **required**
3. Runtime Workflow Contract — **required for clinical mutation authorization**
4. Technology Decision — **required before provider-specific implementation**
5. Database/RLS implementation plan — **required before production data access**

## Governing principle

> **No authenticated identity without an explicit authorization context; no clinical access without clinic membership and permission; no production security boundary enforced only by the client.**
