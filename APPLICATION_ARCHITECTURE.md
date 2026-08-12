# SmileFlow Application Architecture — From Figma Prototype to Working Product

## Status

**PROPOSED — ARCHITECTURE DISCOVERY / NOT IMPLEMENTATION-AUTHORIZED**

Date initialized: 2026-08-12

## Purpose

Define the runtime/application architecture required to transform the approved SmileFlow Figma baseline into a working software product while preserving the existing module ownership, field specifications, design-system boundaries, and frozen clinical module contracts.

This document begins the application-architecture phase. It does **not** authorize Figma modification, backend implementation, database creation, production deployment, or changes to frozen module specifications.

## Product Baseline

The current SmileFlow design baseline contains the following clinical modules:

1. Patient Registration
2. Patient Management
3. Dental Chart
4. Shared Visit
5. Clinical Workspace
6. Treatment Planning
7. Performed Procedure
8. Clinical Closure
9. Clinical Record History

The baseline has been experienced end-to-end and accepted as a usable starting point. Future product improvements should be driven by observed problems rather than speculative redesign.

## Core Architectural Principle

> **The application implementation must realize the existing approved SmileFlow contracts; it must not silently redesign them.**

The Figma baseline answers primarily **what the user sees and does**. The application architecture must now define **how state, data, permissions, persistence, navigation, and runtime behavior support those approved interactions**.

## Scope

### In scope

- Application shell
- Authentication and session model
- User / role model
- Clinic / organization boundary
- Global patient navigation and search
- Patient data model
- Visit data model
- Treatment planning data model
- Performed procedure data model
- Clinical closure data model
- Clinical record history model
- Dental chart data model
- Cross-module state contracts
- Persistence strategy
- API/service boundaries
- File/document storage strategy
- Audit trail strategy
- Error/loading/empty states
- Application navigation
- Testing strategy
- Deployment architecture
- Backup and recovery architecture
- Security architecture

### Explicitly out of scope for this architecture baseline

- HMO / insurance
- AI clinical decision-making
- Autonomous clinical recommendations
- Billing/financial workflows unless separately authorized
- Inventory unless separately authorized
- Laboratory management unless separately authorized
- Patient messaging campaigns unless separately authorized
- Multi-branch expansion unless separately authorized
- Speculative Phase 2 clinical features

**HMO / insurance is intentionally removed from the SmileFlow product scope.**

## Ownership Preservation

The runtime system must preserve the existing domain ownership boundaries:

| Domain | Owner |
|---|---|
| Patient identity/profile | Patient Management / Patient Registration boundary |
| Visit lifecycle | Shared Visit |
| Dental chart | Dental Chart |
| Clinical workspace / notes | Clinical Workspace |
| Planned treatment | Treatment Planning |
| Actual performed work | Performed Procedure |
| Closure outcome | Clinical Closure |
| Historical presentation | Clinical Record History |

A module may consume another module's data through an explicit contract without becoming its owner.

## Runtime vs Prototype

The prototype integration established navigation only.

The working application will eventually require explicit runtime contracts for:

- navigation;
- state mutation;
- persistence;
- validation;
- authorization;
- error handling;
- audit logging.

Prototype navigation must not be treated as proof that runtime persistence or mutation behavior has already been defined.

## Target High-Level Architecture

```text
Presentation Layer
        ↓
Application / Workflow Layer
        ↓
Domain Services / Contracts
        ↓
Persistence Layer
        ↓
Database + File Storage
```

Cross-cutting concerns:

```text
Authentication
Authorization
Audit Trail
Validation
Observability
Error Handling
Backup / Recovery
```

The concrete technology choices remain **TBD** and must be evaluated before implementation.

## Proposed Core Runtime Entities

Initial candidates for architecture discovery:

- Organization / Clinic
- User
- Role / Permission
- Patient
- Visit
- Dental Chart / Tooth Record
- Treatment Plan
- Planned Treatment Item
- Performed Procedure
- Clinical Closure
- Clinical Record Event / History Projection
- Clinical Note
- Attachment / Document

These are candidates for analysis, not yet approved database tables.

## Core Workflow

The application must support a controlled lifecycle similar to the approved baseline:

```text
Patient
  ↓
Visit
  ↓
Checked In
  ↓
Waiting
  ↓
Called
  ↓
In Treatment
  ↓
Treatment Planning / Clinical Work
  ↓
Performed Procedure
  ↓
Clinical Closure
  ↓
Clinical Record History
```

The exact runtime transition contract must be defined before production implementation.

## Data Integrity Principles

- Patient identity must have a stable identifier.
- Visits must have a stable identifier.
- Clinical records must retain authorship and timestamps.
- Historical records must not be silently overwritten.
- Planned treatment and performed work must remain distinct.
- Closure outcome must remain distinct from visit lifecycle state.
- History must represent historical information without becoming an accidental mutation owner.
- Deletion behavior must be explicitly defined before production use.

## Security Principles

Before real patient data is used, the application must define:

- authentication;
- authorization;
- least-privilege access;
- secure session handling;
- data access isolation;
- secure file storage;
- audit logging;
- backups;
- recovery procedures;
- environment separation.

## Design-System Boundary

The application UI should implement the approved SmileFlow design system rather than creating an independent visual system in code.

Figma component identity remains the design reference. Code components should map deliberately to approved design-system concepts.

## Development Phases

### Phase A — Architecture Discovery

1. Inspect current repository architecture and specifications.
2. Identify runtime contracts implied by the approved modules.
3. Define application boundaries.
4. Define entity relationships.
5. Define state transitions.
6. Define authentication/authorization requirements.
7. Evaluate backend/database technology.

### Phase B — Technical Foundation

1. Create application repository structure.
2. Configure environments.
3. Configure authentication.
4. Configure database.
5. Configure migrations.
6. Configure storage.
7. Configure observability and error handling.

### Phase C — Core Application Shell

1. Global navigation.
2. Dashboard.
3. Patient search.
4. User/session handling.
5. Clinic context.

### Phase D — Clinical Runtime

Implement the existing modules as working application domains in dependency order.

### Phase E — Integration

Replace prototype-only navigation with explicit runtime contracts and persisted state.

### Phase F — Production Readiness

Security, auditability, backup/recovery, testing, performance, accessibility, deployment, and monitoring.

## Required Gates

Before implementation begins, the following must be completed:

1. **Application Architecture Read-Only Repository Audit**
2. **Runtime Entity / Ownership Audit**
3. **Application Technology Decision**
4. **Database Architecture Specification**
5. **Authentication / Authorization Specification**
6. **Runtime Workflow Contract**
7. **Explicit Application Implementation Authorization**

No production code should be treated as authorized merely because this proposal exists.

## Current Decision

**START ARCHITECTURE DISCOVERY.**

The immediate next task is:

> **SmileFlow Application Architecture — Read-Only Repository & Runtime Contract Audit**

This audit must inspect the existing approved module specifications and identify the runtime contracts that the working application must implement, without changing the frozen module architecture.
