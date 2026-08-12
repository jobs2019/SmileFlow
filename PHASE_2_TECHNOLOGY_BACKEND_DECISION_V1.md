# SmileFlow Phase 2 — Technology / Backend Decision v1.0

## Status

**DECISION — SUPABASE BACKEND SELECTED; IMPLEMENTATION NOT YET AUTHORIZED**

Date: 2026-08-13

## Decision

SmileFlow will use **Supabase as the initial production backend platform**, with **Postgres as the system-of-record database**, **Supabase Auth for authentication**, **Postgres Row Level Security (RLS) for the primary data-access boundary**, **Supabase Storage for protected clinical documents**, and **Supabase Edge Functions only where server-side business logic or privileged orchestration is required**.

The application client remains a separate concern. The current product direction may continue to use FlutterFlow for application construction, provided its runtime capabilities remain compatible with the approved contracts. FlutterFlow is not the security boundary.

## Why this decision fits SmileFlow

### 1. Relational clinical data

SmileFlow's reconciled model is strongly relational:

```text
Clinic
 ├── Memberships / Users
 └── Patients
      ├── Appointments
      ├── Visits
      ├── Diagnoses
      ├── Procedures
      ├── Dental Findings
      ├── Treatment Plans
      └── Documents
```

Postgres is an appropriate system of record for these foreign-key, transaction, uniqueness, indexing, and audit requirements.

### 2. Authentication and authorization alignment

The approved authorization model requires:

```text
Authenticated User
  ↓
Clinic Membership
  ↓
Role / Permission
  ↓
Clinic-owned Resource
```

Supabase Auth integrates with Postgres/RLS and provides JWT-based authenticated identity. RLS can enforce row-level access at the database boundary. citeturn0search2turn0search1

### 3. Multi-tenant clinic isolation

The schema's `clinic_id` boundary maps naturally to Postgres RLS policies. Every exposed application table must have an explicit RLS strategy; RLS must not be treated as optional production configuration. citeturn0search1turn0search10

### 4. Server-side clinical transactions

The runtime contract requires atomic operations, authorization checks, idempotency, and controlled cross-module mutations. Supabase Edge Functions provide a server-side TypeScript boundary that can validate authenticated requests and use a caller-scoped Supabase client that respects RLS. citeturn0search0turn0search5turn0search11

### 5. Documents

The later File/Document Storage requirement can use Supabase Storage with access policies integrated with Postgres RLS. citeturn0search6

### 6. Existing FlutterFlow direction

FlutterFlow has a current Supabase integration that can connect to a Supabase project and refresh database schema after tables are created. Its database actions can query/insert/update/delete rows. This makes it suitable as a client construction layer, but its UI actions and client-side conditions must not replace backend authorization. citeturn0search3turn0search7

## Selected architecture

```text
                 SMILEFLOW CLIENT
             (FlutterFlow / app UI)
                       │
                       │ authenticated request
                       ▼
              Supabase Auth / API
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
        Postgres + RLS     Edge Functions
              │                 │
              │                 └── server-side
              │                     business rules /
              │                     atomic workflows
              ▼
        SmileFlow Core Data
              │
              ├── Patients
              ├── Visits
              ├── Clinical data
              ├── Treatment Plans
              └── Audit data
              
        Supabase Storage
              │
              └── protected documents
```

## Responsibility boundaries

### Client

Responsible for:

- presentation;
- navigation;
- form interaction;
- local UX state;
- requesting authorized operations;
- displaying server results/errors.

Not trusted for:

- clinic ownership;
- role assignment;
- authorship IDs;
- clinical state authorization;
- cross-clinic access control;
- final transition validation.

### Supabase Auth

Responsible for:

- authentication identity;
- session/token handling;
- credential/recovery flows supported by the selected configuration.

The application-domain `users`/profile entity remains separate from provider credential storage.

### Postgres + RLS

Responsible for:

- persistent system of record;
- relational integrity;
- foreign keys;
- uniqueness constraints;
- row-level clinic isolation;
- baseline authorization enforcement;
- indexes and query performance;
- transactional persistence.

### Edge Functions

Use only where the operation needs server-side orchestration that should not be expressed as a direct client table mutation.

Candidates include:

- Clinical Closure atomic transaction;
- privileged correction/amendment workflows after explicitly authorized contracts;
- complex multi-table clinical mutations;
- integrations/webhooks;
- operations requiring secrets or privileged credentials.

Authenticated Edge Functions must validate the caller and should use a caller-scoped client when operating under the user's permissions. Supabase documents `verify_jwt`/user-authenticated function patterns for this purpose. citeturn0search0turn0search8

Privileged service-role access must never be exposed to the client. citeturn0search1

### Storage

Supabase Storage will be the default candidate for protected clinical document/file storage, with object access controlled by Storage RLS policies and application ownership rules. citeturn0search6

## Direct table access vs server function

Not every operation needs an Edge Function.

### Direct client-to-Postgres/Data API is acceptable for

- appropriately authorized simple reads;
- simple CRUD operations where RLS fully expresses the authorization boundary;
- non-transactional presentation queries;
- safe patient list/search queries with appropriate filters and RLS.

### Server-side function is required/preferred for

- atomic cross-domain clinical transactions;
- operations requiring complex transition validation;
- operations requiring secrets;
- privileged administrative workflows;
- external integrations;
- idempotent mutation orchestration where direct CRUD is insufficient.

This division prevents both extremes: putting all logic in the client or unnecessarily wrapping every database query in a function.

## Security architecture requirements

The technology decision inherits the previously approved security contract:

1. Every clinic-owned table must have a documented RLS policy.
2. RLS must be enabled on exposed application tables before production access.
3. Authorization must not depend solely on client visibility.
4. Client-supplied `clinic_id`, `role`, `created_by`, `updated_by`, or similar security-sensitive identity fields must not be blindly trusted.
5. Provider/service secrets must remain server-side.
6. RLS policies must be tested for cross-clinic leakage and role boundaries.
7. Authorization data must not be stored in user-editable JWT metadata; Supabase documents that `raw_user_meta_data` is user-editable and should not be used for authorization decisions. citeturn0search1

## Performance requirements

RLS policies must be designed with appropriate indexes on policy lookup columns such as `clinic_id`, membership keys, and other authorization join columns. Supabase specifically recommends indexing columns used in RLS policies and adding query filters to improve plans. citeturn0search1

The database implementation specification must therefore include:

- primary-key indexes;
- foreign-key indexes where query patterns require them;
- clinic-scoped indexes;
- patient/visit lookup indexes;
- timestamp/order indexes for longitudinal history;
- RLS-policy support indexes.

## Technology alternatives considered

### Firebase / Firestore

**Not selected.**

It could support authentication and document-oriented data, but SmileFlow's relational clinical model, foreign-key relationships, transactional state boundaries, and SQL/RLS authorization model make Postgres a better fit.

### Custom Node/Express backend + separate Postgres

**Not selected for the initial product.**

It would provide flexibility but introduces additional infrastructure, authentication, authorization, deployment, secret-management, API, and monitoring responsibilities that Supabase already integrates.

It remains a possible future migration/extension path if SmileFlow eventually outgrows the managed platform.

### Custom self-hosted Postgres/Auth stack

**Not selected for the initial product.**

It provides maximum infrastructure control but substantially increases operational burden before SmileFlow has validated its product experience and clinical workflow.

### Direct browser database without RLS

**Rejected.**

This contradicts the approved security architecture and is unacceptable for clinical data.

## Important limitation

Selecting Supabase does **not** mean the database is ready to build.

The following remain required before implementation:

1. final database/RLS specification;
2. exact unresolved module field contracts;
3. detailed permission mapping;
4. RLS policy design;
5. transaction/function boundaries;
6. migration strategy;
7. test strategy;
8. backup/recovery plan;
9. deployment/environment strategy.

## Current unresolved contract dependencies

The technology decision does not invent missing domain fields. The following remain contract-dependent:

- Patient Registration exact field inventory;
- Patient Management exact field permissions;
- Dental Chart vocabulary;
- Treatment Planning exact fields;
- Performed Procedure status/finalization contract;
- Clinical Closure field-level validation;
- Audit event taxonomy.

These must be reconciled before the final schema migration is generated.

## Implementation constraints

This decision does **not** authorize:

- creating the Supabase project;
- creating tables;
- writing SQL migrations;
- enabling/configuring production RLS;
- configuring Supabase Auth;
- creating Edge Functions;
- connecting FlutterFlow to production data;
- storing real patient data;
- changing Figma.

## Decision outcome

**Selected:** Supabase Postgres + Supabase Auth + Postgres RLS + Supabase Storage + selective Supabase Edge Functions.

**Client:** FlutterFlow remains acceptable as the current application construction layer, subject to runtime and security constraints.

**System-of-record:** Postgres.

**Primary security boundary:** Postgres RLS, backed by authenticated identity and explicit clinic membership/permission rules.

**Server-side business-logic boundary:** Edge Functions where required by workflow complexity or privilege.

## Next gate

The next required document is:

# SmileFlow Phase 2 — Database / RLS Implementation Specification v1.0

That specification will translate the approved architecture into exact tables, relationships, constraints, indexes, RLS policy strategy, Auth linkage, transaction/function boundaries, and migration order.

Only after that specification passes consistency/security audit and receives explicit implementation authorization may the actual Supabase database be created.

## Governing principle

> **Use the simplest architecture that can enforce SmileFlow's clinical contracts safely: relational Postgres for truth, RLS for row access, Auth for identity, server-side functions for complex clinical transactions, and the client as an untrusted presentation layer.**
