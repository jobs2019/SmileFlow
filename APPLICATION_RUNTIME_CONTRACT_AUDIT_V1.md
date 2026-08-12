# SmileFlow Application Architecture — Read-Only Repository & Runtime Contract Audit v1

## Status

**AUDIT COMPLETE — NOT READY FOR RUNTIME IMPLEMENTATION**

Date: 2026-08-12

## Audit purpose

Inspect the current SmileFlow repository and approved module evidence to determine which runtime contracts can safely be derived for the transition from the Figma baseline to a working application.

This audit is read-only. It does not modify Figma, module specifications, frozen modules, database structure, application code, or runtime behavior.

## Governing authority

The audit follows `SOURCE_OF_TRUTH.md` and `AGENTS.md`.

The repository authority hierarchy requires current approved module Field Specifications and Architectures to define the application contract. Historical implementation reports and Figma implementations are evidence only.

## Product scope

The nine-module baseline is:

1. Patient Registration
2. Patient Management
3. Dental Chart
4. Shared Visit
5. Clinical Workspace
6. Treatment Planning
7. Performed Procedure
8. Clinical Closure
9. Clinical Record History

Explicitly excluded from the application architecture baseline:

- HMO / insurance
- AI clinical decision-making
- autonomous clinical recommendations
- billing / financial workflows unless separately authorized
- inventory unless separately authorized
- laboratory management unless separately authorized
- patient messaging campaigns unless separately authorized
- multi-branch expansion unless separately authorized
- speculative Phase 2 clinical features

## High-confidence runtime contracts

### 1. Patient identity

A patient must have a stable identity that can be referenced by downstream visit and clinical domains.

Patient Registration and Patient Management are the patient-identity boundary. The application must not duplicate patient ownership inside clinical modules.

### 2. Visit identity and lifecycle

Shared Visit owns:

- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit Lifecycle
- Current Visit State

The approved lifecycle contains exactly seven states:

`Scheduled → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed`

Only the valid forward transitions are authorized. Visit State must remain distinct from Treatment Status, Procedure Status, and Closure Outcome.

### 3. Clinical Workspace

Clinical Workspace is a visit-scoped working surface.

It may consume Shared Visit context, Treatment Planning context, and clinical working information, but does not become the owner of:

- patient registration
- visit lifecycle
- Dental Chart state
- treatment plan mutation
- finalized performed procedures
- closure outcome
- clinical history

Its Phase 1 authorized action is `Save Clinical Notes`.

### 4. Treatment Planning

Treatment Planning is the owner of planned treatment and treatment status.

Runtime implementation must keep planned treatment distinct from performed work.

**Documentation blocker:** the current repository does not expose an authoritative `ARCHITECTURE.md` or `FIELD_SPECIFICATION.md` in `modules/treatment-planning/`. The existing README/implementation evidence is not sufficient to establish a production runtime contract under the repository source-of-truth rules.

### 5. Performed Procedure

Performed Procedure owns finalized actual clinical work.

It must remain distinct from Treatment Planning and Clinical Workspace working documentation.

Its repository architecture and field specification were reconstructed from verified evidence and consistency-audited; the module is frozen.

### 6. Clinical Closure

Clinical Closure owns the Closure Outcome and closure classification.

The canonical Closure Outcome values are:

- Completed as Planned
- Completed with Modification
- Not Completed
- Treatment Continues

Closure Outcome is distinct from Visit State and Treatment Status.

The canonical action is `Save Closure Record`.

Clinical Closure is currently implemented and frozen according to the current repository project state.

### 7. Clinical Record History

Clinical Record History is the read-only historical presentation boundary.

It must not become an accidental mutation owner and must not silently overwrite historical records.

The canonical Figma destination is `153:1204` and the repository documentation chain is reconstructed and consistency-verified.

### 8. Dental Chart

Dental Chart owns tooth/chart findings and chart mutations.

Clinical Workspace and Shared Visit must not become secondary owners of odontogram state.

**Documentation blocker:** the current repository does not expose an authoritative `ARCHITECTURE.md` or `FIELD_SPECIFICATION.md` in `modules/dental-chart/`. Existing implementation evidence is not sufficient to establish the complete production runtime contract under the source-of-truth hierarchy.

### 9. Patient Registration / Patient Management

These modules form the patient identity boundary and must provide the stable patient identity consumed by the rest of the application.

**Documentation blocker:** the current repository does not expose an authoritative `ARCHITECTURE.md` or `FIELD_SPECIFICATION.md` in `modules/patient-registration/` or `modules/patient-management/`. Existing implementation reports establish implementation evidence but do not substitute for current approved runtime specifications.

## Cross-module runtime contracts

The following conceptual relationships are sufficiently established for architecture planning but are **not yet production runtime contracts**:

```text
Patient Registration / Management
              ↓
            Patient
              ↓
            Visit
              ↓
      Shared Visit lifecycle
              ↓
     Clinical Workspace context
        ↙             ↘
Treatment Planning   Clinical Work
        ↓                 ↓
 Planned Treatment   Working Notes
              ↓
      Performed Procedure
              ↓
       Clinical Closure
              ↓
   Clinical Record History
```

Important boundary:

**Navigation does not equal mutation or persistence.**

The Figma integration harness proves prototype navigation only. Runtime behavior must define explicit commands, validation, persistence, and authorization.

## Runtime contracts that remain undefined

The following cannot safely be implemented yet from the current repository authority:

1. Complete patient entity schema.
2. Complete dental chart entity/schema and tooth-level persistence contract.
3. Complete treatment plan entity schema.
4. Complete patient registration/editing field contract.
5. Complete patient-management search/list/detail contract.
6. Exact Visit creation and appointment-origin contract.
7. Exact runtime state-transition command contract.
8. Exact Performed Procedure creation/finalization command contract.
9. Exact Clinical Closure transaction contract.
10. Exact Clinical Record History projection/event model.
11. Cross-module authorization matrix.
12. Validation/error contract.
13. Audit-event taxonomy.
14. Attachment/document persistence contract.
15. Deletion/archive/retention rules.
16. Technology-specific API/service contract.
17. Database constraints and indexes.
18. Concurrency/versioning rules.

## Security findings

The application architecture correctly identifies authentication, authorization, least privilege, audit logging, secure file storage, backups, recovery, and environment separation as required before real patient data.

However, no production-ready permission matrix or security contract is currently authoritative.

Therefore production implementation is not yet authorized.

## Persistence findings

The repository establishes stable identifiers and ownership principles conceptually, but does not yet establish the final database schema.

In particular, we must not infer database tables directly from Figma regions.

Figma fields represent UI contracts; runtime persistence requires explicit entity, relationship, validation, and transaction definitions.

## Technology decision

No technology is authorized by this audit.

The existing application architecture correctly leaves technology choices TBD.

The next technical decision must compare candidate approaches against:

- relational data integrity
- authentication/authorization
- file storage
- auditability
- local development
- deployment simplicity
- maintainability
- cost
- ability to preserve the approved SmileFlow domain boundaries

## Critical repository finding

The repository contains a **documentation completeness gap across multiple frozen modules**.

The current source-of-truth rules require current Architecture and Field Specification artifacts for runtime implementation, but the following module directories do not currently expose those authoritative files:

- Patient Registration
- Patient Management
- Dental Chart
- Treatment Planning

This does not invalidate their frozen status.

It does mean that we must **not invent runtime contracts from historical Figma/implementation evidence**.

Performed Procedure and Clinical Record History are different: their documentation was explicitly reconstructed and consistency-verified, so their current runtime boundaries can be used for architecture planning, subject to the limitations documented in their reconstructed specifications.

## Audit verdict

### 🟡 NOT READY — DO NOT IMPLEMENT RUNTIME YET

The overall SmileFlow application architecture is sufficiently defined to begin **contract recovery/reconciliation**, but not sufficiently defined to begin database or production application implementation.

The blockers are documentation/contract completeness, not missing Figma modules.

## Required next gates

### Gate 1 — Runtime Contract Recovery / Reconciliation

Restore or reconstruct the authoritative Architecture and Field Specification for:

- Patient Registration
- Patient Management
- Dental Chart
- Treatment Planning

Do not represent reconstructed documentation as historical recovery.

### Gate 2 — Runtime Entity & Ownership Audit

After the documentation gap is resolved, derive the canonical runtime entities and relationships without changing module ownership.

### Gate 3 — Workflow Contract

Define commands, valid transitions, validation, persistence boundaries, and failure behavior for the approved visit/clinical workflow.

### Gate 4 — Authentication / Authorization Specification

Define roles, permissions, organization/clinic boundary, and access rules.

### Gate 5 — Technology Decision

Select the implementation stack only after the contracts are stable.

### Gate 6 — Database Architecture Specification

Define tables/entities, relationships, keys, constraints, indexes, audit records, retention, and storage boundaries.

### Gate 7 — Explicit Application Implementation Authorization

Only after Gates 1–6 pass should production application implementation begin.

## Protected baseline

No Figma changes are required by this audit.

No frozen module should be modified as part of runtime architecture work unless a separate Architecture Exception and implementation authorization are explicitly approved.

The `06 — Layouts` page and its duplicates remain untouched.

## Final decision

**Architecture discovery continues. Runtime implementation does not begin yet.**

The next proper task is:

> **SmileFlow Runtime Contract Recovery & Reconciliation — Patient Registration, Patient Management, Dental Chart, and Treatment Planning**
