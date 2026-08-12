# SmileFlow Phase 1 — Product Shell Read-Only Architecture & Scope Audit v1

## Status

**AUDIT COMPLETE — PHASE 1 SCOPE DEFINED / NOT IMPLEMENTATION-AUTHORIZED**

Date: 2026-08-12

## Purpose

Define the strict scope, boundaries, responsive requirements, dependencies, and exit criteria for Phase 1 of the SmileFlow application roadmap:

1. Application Shell
2. Dashboard
3. Global Patient Search
4. Navigation
5. User / Account Structure

This is a read-only audit. It does not authorize Figma changes, application code, database implementation, authentication implementation, or changes to the frozen clinical modules.

## Governing principle

> **I don't want to improve what I don't see. I want to experience SmileFlow first.**

Phase 1 therefore builds only the minimum product shell required to enter, navigate, and experience the working application. It must not redesign the approved clinical modules or introduce speculative clinic features.

## Roadmap position

Phase 1 — Product Shell is the first implementation phase in the strict SmileFlow execution roadmap.

Phase 2 — Core Data follows.

Phase 3 — Existing clinical modules become real application modules.

Phase 4 — Production behavior.

Phase 5 — Clinic operations.

Phase 6 — Production hardening.

HMO / insurance is permanently excluded from the current roadmap.

## Phase 1 scope

### 1. Application Shell

The shell provides the persistent application frame around the product.

Required capabilities:

- application identity / branding;
- persistent header or equivalent global context;
- primary navigation container;
- authenticated user/account entry point;
- main content region;
- clinic context where required by the current architecture;
- responsive layout behavior;
- consistent page-level spacing and structural conventions.

The shell must not embed clinical ownership or clinical state.

### 2. Dashboard

The dashboard is the initial operational landing surface.

Phase 1 should establish only the minimum information and entry points needed to orient the user and enter the existing SmileFlow workflow.

Candidate dashboard content must be derived from available approved contracts rather than invented clinical metrics.

The following are not automatically authorized:

- financial widgets;
- production/revenue analytics;
- AI insights;
- HMO/insurance widgets;
- inventory widgets;
- speculative clinical recommendations.

### 3. Global Patient Search

The shell must provide a global way to locate an existing patient and enter the patient-centered workflow.

Minimum conceptual contract:

```text
Search
  ↓
Patient Results
  ↓
Select Patient
  ↓
Patient Context / Patient Management
```

Search implementation details, indexing, filtering, and database behavior belong to later runtime/data gates and are not authorized by this audit.

### 4. Navigation

Phase 1 establishes application-level navigation between the shell and approved product areas.

Navigation must remain distinct from domain mutation.

A route may open a module without automatically changing visit state, treatment state, procedure state, closure state, or history.

The existing eight-route baseline integration remains a prototype-only reference and is not automatically converted into production runtime behavior by Phase 1.

### 5. User / Account Structure

Phase 1 establishes the application concept of a signed-in user and account context.

Minimum conceptual elements:

- current user identity;
- account/session entry point;
- clinic/organization context where applicable;
- role concept.

Detailed authentication and authorization contracts belong to Phase 2 and are not redefined here.

## Responsive requirement

Responsive behavior is part of Phase 1 Product Shell scope.

The shell must be intentionally designed for four viewport classes:

### Desktop

- Full primary navigation.
- Full content workspace.
- Persistent application context.
- Comfortable multi-column dashboard where appropriate.

### Laptop

- Preserve full clinical/application usability at reduced horizontal space.
- Navigation may use a compact form where needed.
- Content must not require avoidable horizontal scrolling.

### Tablet

- Navigation may collapse into a compact menu.
- Content should adapt to narrower widths.
- Touch targets must remain usable.
- Dashboard content may stack.

### Mobile

- Single-column primary content.
- Compact header.
- Navigation must become a mobile-appropriate pattern.
- No dependence on hover-only interaction.
- Critical actions remain reachable.
- Avoid horizontal scrolling for normal product use.

### Responsive boundary

This requirement applies to the **Product Shell**, not to automatic responsive redesign of the nine existing clinical modules.

Existing clinical modules remain governed by their approved specifications. If later experience proves that an individual clinical module needs responsive adaptation, that becomes a separately authorized change.

## Responsive breakpoints

Exact pixel breakpoints are **not yet approved** by this audit.

They must be selected during the Product Shell specification/preflight based on actual layout constraints rather than arbitrary framework defaults.

The required outcome is behaviorally defined as:

`Desktop → Laptop → Tablet → Mobile`

with no loss of core navigation or patient access.

## Navigation model — Phase 1 boundary

The following conceptual destinations may be represented at the application-shell level:

- Dashboard
- Patients / Patient Search
- Visits / current visit workflow entry where applicable
- Clinical / patient-centered clinical workflow entry where applicable
- Records / patient clinical history entry where applicable
- Settings / account context

However, the exact navigation labels and route hierarchy are **not yet approved**. They must be derived during the Product Shell specification gate.

Do not invent a large sidebar merely to fill space.

## Clinical-module boundary

Phase 1 must not modify:

- Patient Registration architecture;
- Patient Management architecture;
- Dental Chart architecture;
- Shared Visit architecture;
- Clinical Workspace architecture;
- Treatment Planning architecture;
- Performed Procedure architecture;
- Clinical Closure architecture;
- Clinical Record History architecture.

The shell may provide navigation into these areas when an approved route exists, but the shell does not acquire ownership of their data.

## Data boundary

Phase 1 does not establish production database tables.

It may display placeholder/demo content in the prototype or development shell where necessary to demonstrate the experience, but such content must not be represented as production persistence.

Patient, Visit, and clinical entities remain Phase 2 runtime architecture work.

## Authentication boundary

Phase 1 defines the visible user/account concept but does not establish the complete authentication runtime.

Authentication belongs to Phase 2 Core Data and must be specified before production access to real patient data.

## Dashboard data boundary

The dashboard must not imply that unsupported backend metrics already exist.

If a dashboard card requires real data, it must be explicitly marked as a runtime dependency and implemented only after the corresponding Phase 2 contract exists.

## Design-system boundary

The Product Shell must use the approved SmileFlow design system and existing approved components wherever applicable.

Do not create replacement global components merely because a shell element is not yet convenient.

If a required shell component does not exist, document the gap and stop for a component decision rather than silently modifying global foundations.

## Accessibility baseline

Phase 1 must include basic accessibility requirements in the shell design:

- visible focus behavior;
- keyboard-reachable navigation;
- meaningful labels;
- sufficient target size for touch controls;
- no hover-only critical interaction;
- readable text hierarchy;
- responsive usability.

Full accessibility validation remains part of Phase 6 Production Hardening.

## Explicitly out of scope

The following are not Phase 1 deliverables:

- production database;
- patient CRUD persistence;
- appointment scheduling implementation;
- billing;
- HMO / insurance;
- notifications;
- reports;
- inventory;
- laboratory management;
- AI;
- messaging campaigns;
- clinical module redesign;
- new clinical fields;
- Clinical Closure v1.4;
- production audit logging;
- production file storage;
- production backup/recovery;
- final production security implementation.

## Phase 1 dependencies

Phase 1 can proceed as a shell/prototype implementation without completing the full Phase 2 data architecture, provided the implementation uses clearly non-production placeholder/demo state.

However, production-ready user authentication, patient search against real data, and persistent dashboard metrics require Phase 2 runtime contracts.

Therefore Phase 1 has two layers:

### Product Shell / Prototype

Authorized after the Phase 1 implementation gates. Can use controlled demo data.

### Production Shell

Blocked until Phase 2 authentication/data contracts exist.

## Required implementation gates

Before Figma or application implementation:

1. Phase 1 Product Shell Specification.
2. Responsive behavior specification.
3. Navigation/route inventory.
4. Dashboard content inventory.
5. User/account presentation contract.
6. Read-first Figma preflight.
7. Explicit Phase 1 implementation authorization.

## Phase 1 acceptance criteria

Phase 1 is complete only when:

- the application shell exists;
- the shell is usable on desktop, laptop, tablet, and mobile viewport classes;
- dashboard entry exists;
- global patient-search entry exists;
- application navigation exists;
- user/account entry exists;
- no clinical module ownership is changed;
- no frozen clinical module is modified without explicit authorization;
- responsive behavior is verified;
- Visual/UX QA passes;
- Functional QA passes for the shell prototype;
- repository documentation reflects the actual implementation state.

## Decision

**PASS — PHASE 1 SCOPE IS SUFFICIENTLY DEFINED TO PROCEED TO SPECIFICATION.**

No implementation is authorized by this audit alone.

## Next task

> **SmileFlow Phase 1 — Product Shell Precise Field / Interaction / Responsive Specification**

That specification must define the actual shell regions, navigation items, dashboard content, patient-search interaction, user/account presentation, responsive behavior, and acceptance criteria before implementation begins.
