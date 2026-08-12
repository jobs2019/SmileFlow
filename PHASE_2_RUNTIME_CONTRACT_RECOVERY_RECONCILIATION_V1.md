# SmileFlow Phase 2 — Runtime Contract Recovery & Reconciliation v1

## Status

**RECOVERY COMPLETE — RECONCILIATION REQUIRED BEFORE DATABASE IMPLEMENTATION**

Date: 2026-08-13

## Purpose

Recover the highest-confidence runtime ownership and lifecycle contracts for the four documentation-gap modules identified by the Phase 2 Core Data Schema Consistency Audit:

1. Patient Registration
2. Patient Management
3. Dental Chart
4. Treatment Planning

This artifact does not authorize database implementation, Figma modification, SQL migration, authentication implementation, or runtime code.

## Authority rule

`SOURCE_OF_TRUTH.md` requires current approved module Field Specification and Architecture artifacts to outrank historical implementation evidence. Where those authoritative artifacts are absent, this recovery uses the available module `AGENTS.md` rules only to recover ownership and lifecycle facts; it does not pretend that AGENTS.md is a substitute for a complete Field Specification or Architecture.

## Recovered high-confidence contracts

### 1. Patient Registration

Recovered ownership:

- patient creation/registration information;
- approved identity scope;
- demographic scope;
- contact scope;
- emergency-contact scope;
- patient-level alert scope;
- review scope;
- registration-action scope.

The module is explicitly FROZEN.

Source: `modules/patient-registration/AGENTS.md`.

### 2. Patient Management

Recovered ownership:

- patient-level identity;
- demographics;
- patient summaries;
- patient-level navigation within its approved scope.

The module is explicitly FROZEN.

The AGENTS contract also explicitly prevents Patient Management from taking ownership of registration, Dental Chart, Treatment Planning, Visit, Clinical Workspace, Closure, Procedure, or History workflows.

Source: `modules/patient-management/AGENTS.md`.

### 3. Dental Chart

Recovered ownership:

- permanent tooth/chart state within approved scope;
- tooth-condition presentation within approved scope.

It explicitly does not own:

- treatment planning;
- performed procedures;
- clinical closure;
- clinical history;
- general clinical documentation.

The canonical and legacy Dental Chart frames are protected/frozen.

Source: `modules/dental-chart/AGENTS.md`.

### 4. Treatment Planning

Recovered ownership:

- treatment-plan items;
- approved treatment lifecycle.

Recovered canonical lifecycle:

`Planned → Scheduled → In Progress → Completed`

It explicitly does not own:

- visit state;
- clinical documentation;
- closure outcome;
- performed-procedure details;
- historical chronology;
- billing;
- insurance.

The canonical and legacy Treatment Planning frames are protected/frozen.

Source: `modules/treatment-planning/AGENTS.md`.

## Reconciliation findings

### Finding R-01 — Treatment Plan status vocabulary conflict

**Severity: HIGH — must resolve before database implementation.**

The current Phase 2 schema specification defines Treatment Plan status as:

`Planned / Active / Completed / Cancelled / Archived`

and Planned Treatment Item status as:

`Planned / In Progress / Completed / Cancelled`.

The recovered authoritative module rule defines the Treatment Planning lifecycle as:

`Planned → Scheduled → In Progress → Completed`.

These are not equivalent.

### Required decision

The schema must not silently replace the module lifecycle with its own generic status vocabulary.

Recommended reconciliation:

- Treatment Plan lifecycle and Treatment Plan Item lifecycle must be separated if the module specification requires both.
- `Scheduled` and `In Progress` must remain available where the approved Treatment Planning contract requires them.
- `Cancelled` and `Archived` may be retained only as separate terminal/administrative states if a future authoritative Architecture/Field Specification explicitly authorizes them.
- `Active` must not be used as a substitute for `In Progress` without explicit reconciliation.

**Database implementation is blocked until this is resolved in the authoritative schema/specification chain.**

### Finding R-02 — Patient Registration / Patient Management ownership overlap

**Severity: MEDIUM — must be clarified before final schema freeze.**

Patient Registration claims ownership of approved identity and demographic information as part of registration. Patient Management also claims ownership of patient-level identity and demographics within its approved scope.

This is not necessarily a contradiction: one module can own creation/registration while another owns the patient-management presentation and navigation of the same patient entity.

However, the runtime schema must have **one Patient entity owner**, not two competing patient tables or two competing sources of truth.

### Required reconciliation

Recommended boundary:

```text
Patient Registration
    → creates / validates registration-owned patient data
              ↓
          Patient entity
              ↓
Patient Management
    → retrieves / presents / manages patient-level information
```

The exact editable fields and actions must come from the missing authoritative Field Specifications.

### Finding R-03 — Dental Chart schema is directionally compatible but not complete

**Severity: MEDIUM — documentation blocker.**

The Phase 2 schema correctly establishes structured `Tooth` and `Dental Chart Finding` concepts and does not move treatment planning, procedures, closure, or history ownership into Dental Chart.

This is consistent with the recovered module ownership.

However, the actual finding vocabulary, editable state model, chart mutation rules, and exact field requirements are not recoverable from AGENTS.md alone.

### Required action

Do not finalize the Dental Chart database table until the authoritative Architecture and Field Specification are restored/reconciled.

### Finding R-04 — Treatment Planning schema is directionally compatible but lifecycle is not

The schema's separation of Treatment Plan → Planned Treatment Item is consistent with recovered ownership.

However, the lifecycle mismatch in R-01 means the current schema is **not yet authoritative** for Treatment Planning.

### Finding R-05 — No HMO/insurance leakage

The recovered module contracts explicitly exclude insurance from Treatment Planning, and the product architecture excludes HMO/insurance globally.

No HMO/insurance entity or foreign key is permitted in the core data schema.

## Cross-module recovered ownership map

```text
Patient Registration
    owns registration actions / registration data
              ↓
          Patient Entity
              ↓
Patient Management
    owns patient management / summaries / navigation

Patient Entity
      │
      ├── Visits
      │
      ├── Dental Chart
      │      └── Tooth / permanent chart state
      │
      └── Treatment Plans
             └── Treatment Plan Items
                    └── Planned lifecycle

Visit
      ├── Clinical Workspace
      ├── Performed Procedure
      └── Clinical Closure

Clinical Record History
      └── read-only longitudinal projection
```

## Schema impact

The current schema specification remains usable as a **working architecture proposal**, but the following items must be corrected/reconciled before database implementation:

1. Treatment Plan lifecycle vocabulary.
2. Treatment Plan Item lifecycle vocabulary.
3. Patient Registration vs Patient Management field ownership.
4. Dental Chart exact finding model.
5. Treatment Planning exact field/action model.

## What was successfully recovered

The following architecture boundaries are now sufficiently high-confidence for continued planning:

- one stable Patient entity;
- Registration is the creation/registration boundary;
- Patient Management is the patient-level management/navigation boundary;
- Dental Chart owns permanent tooth/chart state;
- Treatment Planning owns planned treatment items;
- Treatment Planning does not own performed work;
- Treatment Planning does not own closure;
- Treatment Planning does not own visit lifecycle;
- no HMO/insurance domain;
- frozen Figma modules remain untouched.

## What was NOT recovered

The following cannot be responsibly invented:

- complete Patient Registration field list;
- complete Patient Management field list;
- complete Dental Chart field list;
- complete Dental Chart finding vocabulary;
- complete Treatment Planning field list;
- exact Treatment Plan vs Treatment Plan Item status model;
- exact mutation commands;
- validation rules;
- deletion/archive rules specific to these modules.

## Decision

### 🟡 NOT READY FOR DATABASE IMPLEMENTATION

Runtime contract recovery has identified the missing authoritative information and one concrete schema contradiction.

No database implementation should begin until the contradiction and documentation gaps are reconciled.

## Next proper task

> **SmileFlow Phase 2 — Schema Reconciliation Decision: Treatment Planning Lifecycle + Patient Ownership Boundary**

That decision should update the authoritative schema/specification chain only. It should not touch Figma or create database tables.

## Protected scope

- No Figma modification.
- No frozen-module modification.
- No `06 — Layouts` changes.
- No Product Shell changes.
- No HMO/insurance.
- No database tables or migrations.
