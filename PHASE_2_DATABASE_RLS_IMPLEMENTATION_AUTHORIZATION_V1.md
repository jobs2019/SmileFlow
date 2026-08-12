# SmileFlow Phase 2 — Explicit Database / RLS Implementation Authorization v1.0

## Status

**AUTHORIZED — IMPLEMENTATION MAY PROCEED**

Date: 2026-08-13

## Authorization scope

The approved SmileFlow Phase 2 architecture and implementation specification are authorized to proceed from documentation into backend construction.

This authorization covers:

- Supabase/Postgres database schema construction;
- database constraints and indexes defined by the approved implementation specification;
- Supabase Auth integration needed to establish the canonical application identity;
- clinic membership and role persistence;
- production RLS policy construction according to the approved authorization model;
- database-side tenant and relationship integrity enforcement;
- server-side transaction boundaries required by the approved Runtime Workflow Contract;
- audit persistence required by the approved implementation specification;
- development/test environment validation of the above.

## Governing documents

Implementation must remain subordinate to these approved contracts:

1. `SOURCE_OF_TRUTH.md`
2. `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
3. `PHASE_2_CORE_DATA_SCHEMA_CONSISTENCY_AUDIT_V2.md`
4. `PHASE_2_AUTHENTICATION_AUTHORIZATION_SPECIFICATION_V1.md`
5. `PHASE_2_AUTHENTICATION_AUTHORIZATION_CONSISTENCY_AUDIT_V1.md`
6. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_SPECIFICATION_V1.md`
7. `PHASE_2_RUNTIME_WORKFLOW_CONTRACT_CONSISTENCY_AUDIT_V1.md`
8. `PHASE_2_TECHNOLOGY_BACKEND_DECISION_V1.md`
9. `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_V1.md`
10. `PHASE_2_DATABASE_RLS_IMPLEMENTATION_SPECIFICATION_CONSISTENCY_AUDIT_V1.md`

If implementation evidence conflicts with an authoritative contract, implementation must stop at the conflict rather than silently redefining the contract.

## Authorized backend

```text
FlutterFlow / application client
            ↓
        Supabase Auth
            ↓
      PostgreSQL + RLS
       ↙           ↘
 Core data       Audit data
            ↓
    Supabase Storage
            ↓
 Protected documents

Supabase Edge Functions
            ↓
Complex / atomic clinical workflows
```

## Non-negotiable implementation rules

### 1. No client-trusted security context

The client must never be trusted to establish:

- authenticated identity;
- clinic membership;
- role;
- permission;
- authoritative `clinic_id` for protected operations;
- clinical authorship identity.

### 2. Tenant isolation is mandatory

Every clinic-owned resource must be protected by the clinic boundary. Cross-clinic reads and writes must be denied at the database/security layer.

### 3. RLS is a production security boundary

RLS policies must be implemented and tested for the authorized resource/action combinations. Frontend visibility is supplementary UX only.

### 4. Clinical state transitions are not generic CRUD

Where the Runtime Workflow Contract requires a valid transition, implementation must validate current state, permission, required data, and transition legality before committing the mutation.

### 5. Clinical transactions must be atomic

A cross-module clinical transaction must either complete as a valid unit or leave no partial committed state.

### 6. Clinical authorship is server-derived

Fields such as `created_by`, `updated_by`, `performed_by`, and `closed_by` must derive from the authenticated identity rather than arbitrary client-supplied IDs.

### 7. State domains remain independent

Do not reuse a generic status enum across:

- Appointment status;
- Visit state;
- Planned Treatment Item status;
- Performed Procedure status when later authorized;
- Clinical Closure outcome.

### 8. No invented clinical vocabulary

Where a field or controlled vocabulary is explicitly deferred by the approved specification, implementation must not invent a production value merely to complete the migration.

### 9. Clinical data is not destructively deleted by default

Historical clinical authorship and auditability must be preserved according to the approved data model.

### 10. HMO/insurance remains excluded

No HMO/insurance tables, policies, workflows, or UI are authorized by this gate.

## Authorized implementation order

Implementation should proceed in controlled stages:

```text
1. Supabase development environment readiness
        ↓
2. Auth identity linkage
        ↓
3. Base tenant / identity tables
        ↓
4. Core patient / appointment / visit tables
        ↓
5. Clinical child tables
        ↓
6. Treatment planning tables
        ↓
7. Documents / audit persistence boundaries
        ↓
8. Referential constraints and indexes
        ↓
9. RLS helper/security functions
        ↓
10. RLS policies
        ↓
11. Transaction / Edge Function boundaries
        ↓
12. Migration validation
        ↓
13. Authorization/security test matrix
        ↓
14. Runtime integration readiness review
```

The sequence may be adjusted only when required by an implementation dependency; any material deviation must be documented.

## Development environment restriction

Authorization is for controlled implementation and validation. Do **not** populate production with real patient data during construction or testing.

Use synthetic/test identities and synthetic clinical records for validation.

## Required implementation validation

Before declaring the database implementation complete, verify at minimum:

### Identity

- Auth identity maps to exactly one canonical SmileFlow user identity.
- Deactivated users cannot initiate new authorized access.
- Credential material remains provider-managed.

### Tenant isolation

- User with Clinic A membership cannot read Clinic B patients.
- User with Clinic A membership cannot insert a Clinic B resource.
- User cannot change a resource's clinic boundary through client input.
- Inactive membership does not grant access.

### Authorization

- Role permissions are enforced server-side.
- Unauthorized reads fail safely.
- Unauthorized mutations fail safely.
- Administrative permissions do not silently become unrestricted clinical permissions.

### Referential integrity

- Cross-clinic patient/resource relationships are rejected.
- Cross-patient tooth references are rejected.
- Appointment/visit relationships remain clinic-consistent.
- Treatment-plan item relationships remain patient-consistent.

### Workflow

- Invalid Visit transitions are rejected.
- Invalid Treatment Plan Item transitions are rejected.
- Closure cannot occur before `Ready for Closure`.
- Closure cannot be performed without required authorization/validation.
- Closure and Visit → Closed commit atomically.
- Treatment Item completion does not silently close a Visit.
- Procedure completion does not silently close a Visit.
- Visit closure does not silently complete Treatment Plan Items.

### Auditability

- Important clinical mutations identify the acting user.
- Audit events cannot be modified/deleted by ordinary application clients.
- Unauthorized access attempts are handled according to the security/audit contract.

## Stop conditions

Implementation must stop and return to the appropriate specification gate if any of the following occurs:

1. A required field is missing from the approved contract.
2. A controlled vocabulary is ambiguous or contradictory.
3. An RLS rule requires an authorization decision not present in the approved specification.
4. A foreign-key relationship creates an unresolved ownership contradiction.
5. A runtime transition cannot be implemented without inventing behavior.
6. A module requires data ownership that contradicts the canonical architecture.
7. A security requirement cannot be enforced server-side as specified.
8. Implementation would require adding HMO/insurance functionality.

No developer or tool should silently resolve these conditions by guessing.

## What remains out of scope

This authorization does not authorize:

- Phase 5 Scheduling UI/operations;
- Notifications;
- Billing;
- HMO/insurance;
- Phase 6 production hardening beyond implementation-time security validation;
- production monitoring/observability rollout;
- backups/recovery configuration;
- performance optimization beyond schema/index correctness;
- accessibility work;
- Figma redesign;
- Clinical Closure v1.4 improvements;
- new clinical vocabulary not already approved.

## Figma boundary

No Figma modification is implied by this authorization.

The implementation may connect existing approved Product Shell and module experiences to the backend only after the relevant runtime integration gate authorizes that connection.

## Definition of authorization

This document means:

> **The SmileFlow team is explicitly authorized to construct the approved Supabase/Postgres database and RLS security layer in a controlled development environment, while remaining strictly bound by the approved Phase 2 contracts and stop conditions.**

It does **not** mean the product is production-ready.

## Next gate

After implementation construction and validation:

**SmileFlow Phase 2 — Database / RLS Implementation Validation & Integration Readiness Audit**

Only after that audit passes should the backend be considered ready for application persistence integration.
