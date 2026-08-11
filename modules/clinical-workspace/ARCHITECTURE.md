# Clinical Workspace — Architecture & Information Model v1.0

## Status
APPROVED — Phase 1 source of truth

## Purpose
Clinical Workspace is the clinician's active working surface during an active visit. It brings together the minimum context needed to understand who the patient is, why they are here, what is currently being treated, what was planned, and what clinical work needs to be documented.

Clinical Workspace is an orchestration/workspace surface, not the authoritative owner of every clinical record.

## Canonical composition
`Clinical Workspace — Phase 1 — Canonical`

Recommended page: `06 — Layouts`

Recommended desktop width: 920 px

## Seven regions
1. Workspace Header
2. Patient & Visit Context
3. Active Treatment
4. Clinical Assessment
5. Treatment Plan Context
6. Clinical Work & Documentation
7. Workspace Actions

## Ownership principle
Clinical Workspace shows and coordinates the current clinical work; specialized modules own the underlying records.

### Clinical Workspace does not own
- Patient registration or demographics
- Shared Visit lifecycle
- Dental Chart state or odontogram mutation
- Treatment Planning mutation
- Finalized Performed Procedure records
- Clinical Closure outcomes or Close Visit
- Clinical Record History
- Billing
- Insurance
- Appointment or queue management

## Region 1 — Workspace Header
Purpose: establish immediate patient and workspace identity.

Contains:
- Module title
- Patient name
- Patient ID
- Current Visit indicator

All fields are read-only.

## Region 2 — Patient & Visit Context
Contains:
- Visit ID
- Visit Date
- Visit Type
- Chair
- Current Visit State

Shared Visit is authoritative for these values. Clinical Workspace only presents them.

All fields are read-only. Clinical Workspace must not independently modify visit lifecycle.

## Region 3 — Active Treatment
Contains:
- Treatment Item
- Procedure
- Tooth / Site
- Surface / Scope
- Treatment Status

Treatment Planning and Performed Procedure remain authoritative for their respective records. Clinical Workspace presents the current treatment context and must not become a second treatment-planning editor.

## Region 4 — Clinical Assessment
Contains the current working clinical assessment:
- Presenting Concern
- Clinical Findings
- Assessment

These fields are Clinical Workspace working documentation. They must not automatically mutate Dental Chart data.

## Region 5 — Treatment Plan Context
Contains read-only treatment-plan context:
- Planned Treatment Item
- Planned Procedure
- Planned Tooth / Site
- Planned Surface / Scope
- Planned Treatment Status

Treatment Planning is authoritative. No Phase 1 treatment-plan editing is permitted here.

## Region 6 — Clinical Work & Documentation
Contains working clinical documentation, including:
- Procedure Notes
- Clinical Notes
- Materials / Technique

These are working documentation fields and do not themselves constitute a finalized Performed Procedure record.

## Region 7 — Workspace Actions
Phase 1 authorized action:
- Save Clinical Notes

Do not add Record Procedure, Close Visit, Complete Treatment, Cancel Visit, Treatment Planning mutation, Dental Chart mutation, billing, insurance, appointment, or queue actions.

## Workflow boundary
Approved conceptual flow:

Shared Visit → Clinical Workspace → Performed Procedure / Clinical Closure → Clinical Record History

These arrows represent ownership/handoff, not automatic prototype navigation.

## Multi-visit rule
Clinical Workspace is visit-scoped. Documentation for one visit must not overwrite another visit's documentation. Historical finalized records belong to Clinical Record History.

## Phase 1 exclusions
Insurance, billing, payments, claims, scheduling, queue management, messaging, analytics, AI diagnosis, AI treatment recommendations, Dental Chart mutation, Treatment Planning mutation, procedure finalization, visit closure, and historical record editing are excluded.

## Design-system strategy
Use existing approved components and presentation conventions. No new global component is authorized by this architecture. Do not modify Functional Select Field, Select Menu, Select Option, Chevron, Input Field definitions, Button definitions, variables, tokens, typography, styles, or icons.

## Freeze safety
Clinical Workspace must consume context rather than redefine ownership of Shared Visit, Dental Chart, Treatment Planning, Performed Procedure, Clinical Closure, or Clinical Record History.
