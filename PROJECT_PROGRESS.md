# SmileFlow — Project Progress & Execution Guide

## Purpose

This file is the human-friendly progress index for SmileFlow.

It exists so a future ChatGPT/Codex session can recover the project direction after a crash or context loss.

**This file is NOT the authoritative project-state record.**

For current authorization and the exact next action, always defer to:

1. `SOURCE_OF_TRUTH.md`
2. `PROJECT_STATE.md`
3. `AGENTS.md`
4. the applicable module `ARCHITECTURE.md` / `FIELD_SPECIFICATION.md`
5. the applicable phase authorization/audit files

If this file conflicts with `PROJECT_STATE.md`, `PROJECT_STATE.md` wins and this file must be reconciled.

---

## Current Recovery Checkpoint

**Repository:** `jobs2019/SmileFlow`

**Default branch:** `main`

**Latest project-state commit:** `4bda985d1f36ee9dcefe6ff6fd51268dc0abcdfe`

**Current authoritative project state:** Phase 1 module baseline complete; bounded prototype integration is explicitly authorized, subject to a passing Figma preflight.

**Current authorized next step:**

> **SmileFlow Baseline — Integration Implementation / Read-First Figma Preflight**

---

# Strict Execution Order

## Gate 0 — Repository Governance / Recovery

**Status: COMPLETE / ACTIVE GOVERNANCE**

- [x] `AGENTS.md` established
- [x] `PROJECT_STATE.md` established
- [x] `SOURCE_OF_TRUTH.md` established
- [x] Design-system governance established
- [x] Freeze/architecture-exception governance established
- [x] Historical artifacts preserved
- [x] Local Supabase QA/runtime initialization documentation recorded
- [x] Crash-recovery progress index established

### Rule
Never infer the next task from an old conversation. Read the current repository state first.

---

## Phase 1 — Product Shell

**Status: COMPLETE / ACCEPTED**

- [x] Application shell
- [x] Dashboard
- [x] Global patient search
- [x] Navigation
- [x] User/account structure
- [x] Responsive desktop/laptop/tablet/mobile shell
- [x] Functional prototype QA
- [x] Route destination integrity
- [x] Protected-area integrity
- [x] Final QA

**Do not reopen Phase 1 for speculative visual polish.**

---

## Phase 2 — Baseline Integration

**Status: AUTHORIZED — PRE-WRITE PREFLIGHT REQUIRED**

- [x] Baseline integration proposal
- [x] Read-only cross-module dependency audit
- [x] Exact route ownership audit
- [x] State handoff audit
- [x] Protected-node audit
- [x] Prototype-only behavior audit
- [x] INT-08 Clinical Record History destination resolution
- [x] Explicit integration implementation authorization
- [ ] Read-first Figma preflight
- [ ] Integration implementation
- [ ] Structural/behavioral/visual integration QA
- [ ] Protection audit after implementation

### Authorized scope

Exactly eight prototype-navigation routes:

`INT-01 → INT-02 → INT-03 → INT-04 → INT-05 → INT-06 → INT-07 → INT-08`

Implementation must use a dedicated bounded integration harness/page or equivalent non-canonical integration layer.

### Important

Figma navigation is not runtime persistence.

Do not introduce cross-module mutation, backend behavior, database/API changes, lifecycle transitions, billing, HMO/insurance, or AI clinical decision behavior.

---

## Phase 3 — Runtime Contract Recovery / Reconciliation

**Status: PARTIALLY DOCUMENTED — GATES MUST BE CLOSED BEFORE PRODUCTION RUNTIME IMPLEMENTATION**

Required contract areas:

- [ ] Patient Registration architecture/field contract reconciled
- [ ] Patient Management architecture/field contract reconciled
- [ ] Dental Chart architecture/field contract reconciled
- [ ] Treatment Planning architecture/field contract reconciled
- [ ] Patient ownership/entity boundary confirmed
- [ ] Visit identity/lifecycle contract confirmed
- [ ] Clinical Workspace contract confirmed
- [ ] Performed Procedure contract confirmed
- [ ] Clinical Closure contract confirmed
- [ ] Clinical Record History contract confirmed
- [ ] Cross-module ownership boundaries reconciled

### Current known architectural decisions

- One canonical Patient entity
- Treatment-plan-item lifecycle is exactly:
  `Planned → Scheduled → In Progress → Completed`
- Planned treatment remains distinct from performed work
- Visit lifecycle remains distinct from treatment status and closure outcome
- Clinical Closure owns Closure Outcome
- Clinical Record History is read-only historical presentation
- HMO/insurance is excluded from SmileFlow scope

---

## Phase 4 — Authentication / Authorization

**Status: NOT YET PRODUCTION-AUTHORIZED**

- [ ] Authentication specification
- [ ] Role model
- [ ] Permission matrix
- [ ] Clinic/organization boundary
- [ ] Least-privilege rules
- [ ] Session/security rules
- [ ] Audit requirements
- [ ] RLS/security behavior specification
- [ ] Security QA

No real patient data before this gate is complete.

---

## Phase 5 — Database / Persistence Architecture

**Status: ARCHITECTURE / QA WORK IN PROGRESS; PRODUCTION SCHEMA MUST FOLLOW AUTHORITY CHAIN**

- [ ] Canonical runtime entities
- [ ] Relationships
- [ ] Primary/foreign keys
- [ ] Constraints
- [ ] Indexes
- [ ] Visit lifecycle persistence
- [ ] Dental chart persistence
- [ ] Treatment plan persistence
- [ ] Performed procedure persistence
- [ ] Closure persistence
- [ ] Clinical history/event model
- [ ] Audit records
- [ ] Attachment/document boundary
- [ ] Retention/archive/deletion rules
- [ ] Transaction/concurrency rules
- [ ] Schema consistency audit PASS

### Local Supabase rule

The local Supabase baseline is for disposable QA/reconstruction only unless an explicit production implementation authorization says otherwise.

Never import production patient data into the local QA environment.

---

## Phase 6 — Runtime Workflow Contract

**Status: NOT COMPLETE**

Define before production implementation:

- [ ] Commands/actions
- [ ] Valid state transitions
- [ ] Validation rules
- [ ] Persistence boundaries
- [ ] Error/failure behavior
- [ ] Idempotency rules
- [ ] Concurrency/versioning rules
- [ ] Audit events
- [ ] Cross-module handoffs

Core conceptual workflow:

`Patient → Visit → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed`

This does not authorize implementation by itself.

---

## Phase 7 — Application Technology / Technical Foundation

**Status: NOT FINALIZED FOR PRODUCTION**

- [ ] Technology decision
- [ ] Repository/application structure
- [ ] Environment separation
- [ ] Database connection
- [ ] Authentication implementation
- [ ] Storage
- [ ] API/service boundaries
- [ ] Validation
- [ ] Error handling
- [ ] Observability
- [ ] Testing infrastructure

---

## Phase 8 — Working Application Implementation

**Status: NOT YET AUTHORIZED AS A GENERAL PRODUCTION IMPLEMENTATION PHASE**

Implement in dependency order only after the preceding contracts/gates pass:

1. [ ] Application shell/runtime session
2. [ ] Patient Registration
3. [ ] Patient Management
4. [ ] Shared Visit
5. [ ] Dental Chart
6. [ ] Clinical Workspace
7. [ ] Treatment Planning
8. [ ] Performed Procedure
9. [ ] Clinical Closure
10. [ ] Clinical Record History

### Rule
Do not invent backend behavior from Figma alone.

---

## Phase 9 — Integration / End-to-End Runtime

**Status: NOT STARTED**

- [ ] Replace prototype-only navigation with runtime contracts
- [ ] Persist state changes
- [ ] Validate cross-module ownership
- [ ] Validate visit lifecycle
- [ ] Validate treatment planning → performed work boundary
- [ ] Validate closure behavior
- [ ] Validate history projection
- [ ] End-to-end QA

---

## Phase 10 — Production Readiness

**Status: NOT STARTED**

- [ ] Security review
- [ ] Authorization/RLS review
- [ ] Audit-log review
- [ ] Backup strategy
- [ ] Recovery test
- [ ] Environment separation
- [ ] File/document security
- [ ] Error monitoring
- [ ] Performance testing
- [ ] Accessibility testing
- [ ] Data retention policy
- [ ] Deployment procedure
- [ ] Production smoke test
- [ ] Real-patient-data readiness approval

---

# Strict Rules for Every Future Session

### Rule 1 — Read before changing

Before modifying SmileFlow, read `AGENTS.md` and `PROJECT_STATE.md`.

### Rule 2 — One authorized gate at a time

Do not jump to a later phase because it is convenient or exciting.

### Rule 3 — No speculative redesign

Do not reopen frozen/accepted modules without the required versioned change proposal and authorization.

### Rule 4 — No implementation from evidence alone

Figma, screenshots, old reports, and historical artifacts are evidence. They do not override current approved specifications.

### Rule 5 — No partial implementation

If the complete requested operation cannot be safely implemented and validated, stop rather than leaving a half-finished change.

### Rule 6 — Keep state files synchronized

When project authorization/state changes, reconcile `PROJECT_STATE.md` and this progress index. Historical reports must remain historical.

### Rule 7 — Protect clinical ownership

Never let a downstream module silently become the owner of another module's data.

### Rule 8 — No real patient data before production-readiness gates pass

Local QA data must remain disposable and isolated.

---

# Current Next Action

**STOP HERE until the current authorized gate is completed:**

> **SmileFlow Baseline — Integration Implementation / Read-First Figma Preflight**

Do not write to Figma until the preflight result is `READY`.

---

## Recovery Procedure After a ChatGPT Crash

If the working conversation is lost:

1. Open `PROJECT_PROGRESS.md`.
2. Read `PROJECT_STATE.md`.
3. Read `SOURCE_OF_TRUTH.md`.
4. Read `AGENTS.md`.
5. Read the current phase's specification/audit/authorization files.
6. Inspect the latest Git commit.
7. Determine the **current authorized next action**.
8. Continue only from that gate.

**Never restart SmileFlow from an old conversational memory if the repository contains a newer state.**

_Last reconciled: 2026-08-13._
