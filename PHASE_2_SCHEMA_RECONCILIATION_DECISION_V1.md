# SmileFlow Phase 2 — Schema Reconciliation Decision v1.0

## Status

**DECISION RECORDED — SCHEMA RECONCILIATION COMPLETE / SCHEMA UPDATE REQUIRED**

Date: 2026-08-12

## Purpose

Resolve the two material conflicts identified during `PHASE_2_RUNTIME_CONTRACT_RECOVERY_RECONCILIATION_V1.md` before database implementation.

This decision does not create database tables, migrations, authentication rules, or application code.

## Governing authority

The decision follows `SOURCE_OF_TRUTH.md`: explicit current user direction and approved module contracts take precedence over the proposed core-data schema.

## Decision 1 — Treatment Planning lifecycle

### Conflict

The proposed schema used generic treatment-plan statuses:

`Planned / Active / Completed / Cancelled / Archived`

The authoritative Treatment Planning module contract states that Treatment Planning owns treatment-plan items and their approved treatment lifecycle:

`Planned → Scheduled → In Progress → Completed`

The module explicitly does not own visit state, clinical documentation, closure outcome, performed-procedure details, historical chronology, billing, or insurance.

### Decision

**The authoritative Treatment Planning lifecycle wins.**

The runtime contract for a treatment-plan item shall use exactly:

```text
Planned
  ↓
Scheduled
  ↓
In Progress
  ↓
Completed
```

The generic schema lifecycle values `Active`, `Cancelled`, and `Archived` must **not** be used as treatment-plan-item lifecycle values unless a future approved Treatment Planning architecture explicitly authorizes them.

### Important distinction

The treatment-plan container and the treatment-plan item are not automatically assigned the same lifecycle.

The authoritative contract establishes the lifecycle for **treatment-plan items**. The application must not invent a separate plan-level clinical lifecycle during schema implementation.

Therefore:

- `planned_treatment_item.status` → authoritative four-state lifecycle above.
- `treatment_plan.status` → **UNRESOLVED / DEFERRED** until an authoritative Treatment Planning field specification explicitly defines a container-level status.

If a database implementation needs an administrative container state, it must use a separately named concept and receive explicit architecture approval rather than reusing the item lifecycle.

### Consequence for existing schema

The current schema specification must be amended before database implementation:

1. Replace the planned-item status values with the four authoritative states.
2. Remove or mark the treatment-plan container `status` field as unresolved/deferred until the module contract establishes it.
3. Do not add `Cancelled`, `Archived`, or generic `Active` to the treatment-item lifecycle.

## Decision 2 — Patient ownership boundary

### Conflict

Patient Registration and Patient Management both reference patient identity/demographics ownership.

Patient Registration states that it owns patient creation/registration information, including approved identity, demographic, contact, emergency-contact, patient-level alert, review, and registration-action scope.

Patient Management states that it owns patient-level identity, demographics, patient summaries, and patient-level navigation within its approved scope.

### Decision

**There is one canonical Patient entity.**

Patient Registration and Patient Management do not create separate patient entities or duplicate patient identity tables.

The ownership boundary is:

```text
Patient Registration
        │
        │ creates / registers
        ▼
   Canonical Patient
        │
        ├───────────────┐
        ▼               ▼
Patient Management   Clinical domains
(summary/navigation) (visits/chart/treatment/etc.)
```

### Patient Registration owns

- creation/registration workflow;
- approved registration fields;
- registration-time identity and demographic capture;
- contact information within its approved contract;
- emergency-contact information within its approved contract;
- patient-level alerts within its approved contract;
- registration review/action behavior.

### Patient Management owns

- patient-level management presentation;
- patient summary;
- patient-level navigation;
- approved patient identity/demographic management within its scope.

### Shared runtime rule

Both modules reference the same immutable `patient_id`.

Neither module may create a second patient record to represent the same person.

Registration is therefore an **ownership boundary for creation/capture**, not a separate persistence entity.

## Decision 3 — Patient data normalization

The core schema may retain one `patient` entity, but exact registration fields must not be invented from the shell or historical Figma evidence.

The following remain dependent on the authoritative Patient Registration field specification:

- exact contact structures;
- emergency-contact structures;
- patient-level alerts;
- review fields;
- registration actions;
- any additional demographic fields.

The database schema must not create speculative columns merely because a field appears plausible for a dental application.

## Decision 4 — Dental Chart boundary

The Dental Chart contract remains authoritative for permanent tooth/chart state and tooth-condition presentation.

The schema may preserve a structured `tooth` reference and chart-finding boundary, but the exact finding vocabulary and field contract remain owned by Dental Chart.

No treatment planning, performed procedure, closure, history, or general clinical documentation ownership is transferred into Dental Chart.

## Decision 5 — Treatment Planning boundary

Treatment Planning remains the owner of treatment-plan items and their lifecycle.

It does not own:

- visit state;
- clinical documentation;
- closure outcome;
- performed-procedure details;
- historical chronology;
- billing;
- insurance.

This keeps the core model aligned with the existing SmileFlow domain boundaries.

## Reconciliation matrix

| Conflict | Decision | Result |
|---|---|---|
| Treatment item lifecycle | Authoritative four-state lifecycle wins | **RESOLVED** |
| Treatment plan container lifecycle | Do not invent | **DEFERRED / CONTRACT REQUIRED** |
| Patient entity duplication | One canonical Patient entity | **RESOLVED** |
| Registration vs management ownership | Registration creates/captures; Management manages/presents | **RESOLVED** |
| Dental Chart ownership | Chart remains tooth/chart owner | **CONFIRMED** |
| Treatment Planning ownership | Planned treatment remains separate from performed work | **CONFIRMED** |

## Required schema changes

Before database implementation, `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1.md` must be revised so that it no longer conflicts with this decision.

The revised schema must:

1. use `Planned → Scheduled → In Progress → Completed` for treatment-plan-item lifecycle;
2. mark treatment-plan container status as unresolved unless explicitly defined by the authoritative module specification;
3. preserve one canonical Patient entity;
4. preserve the registration/management ownership split without duplicating patient persistence;
5. preserve Dental Chart and Treatment Planning ownership boundaries.

## Required next gate

After the schema is reconciled, run:

> **SmileFlow Phase 2 — Core Data Schema Consistency Audit v2**

Only if that audit passes should the process continue to authentication/authorization and runtime workflow specification.

## Implementation prohibition

This decision does **not** authorize:

- database creation;
- SQL migrations;
- Supabase implementation;
- RLS policies;
- application persistence;
- authentication implementation;
- Figma changes.

## Scope exclusions preserved

The following remain excluded:

- HMO / insurance
- billing / financial workflows
- inventory
- laboratory management
- patient messaging campaigns
- AI clinical decision-making
- autonomous clinical recommendations

## Final decision

**The schema conflict is resolved at the architecture level. The authoritative Treatment Planning lifecycle and single Patient entity are now the governing decisions. The schema itself must be amended next, then re-audited.**
