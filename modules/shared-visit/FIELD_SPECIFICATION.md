# Shared Visit — Precise Field-Level Specification v1.0

Status: APPROVED FOR IMPLEMENTATION
Architecture: Shared Visit — Architecture & Information Model v1.0
Figma Implementation: NOT YET IMPLEMENTED
Figma Changes: NONE

## 1. Purpose

Defines exact Phase 1 fields, values, editability, lifecycle behavior, component requirements, prototype boundaries, and acceptance criteria for Shared Visit.

## 2. Canonical Demonstration Data

These are canonical demonstration values only and must not be hardcoded into reusable design-system components.

- Patient Name: `Maria Santos`
- Patient ID: `P-000128`
- Visit ID: `V-000128`
- Visit Date: `August 11, 2026`
- Visit Type: `General Consultation`
- Chair: `Chair 02`
- Current Visit State: `In Treatment`

Canonical Visit ID and Visit Date are now explicitly resolved for the Phase 1 demonstration scenario.

## 3. Seven-Region Architecture

Exactly seven top-level regions, in this order:
1. Visit Header
2. Patient / Visit Identity
3. Visit Context
4. Visit Lifecycle
5. Current Visit State
6. Visit Summary
7. Visit Actions

## 4. Region 1 — Visit Header

Required:
- Patient: Maria Santos — read-only
- Patient ID: P-000128 — read-only
- Module title: Shared Visit — read-only

Patient name receives the strongest visual emphasis within the header.

## 5. Region 2 — Patient / Visit Identity

Required:
- Patient: Maria Santos — read-only
- Patient ID: P-000128 — read-only
- Visit ID: V-000128 — read-only
- Visit Date: August 11, 2026 — read-only

## 6. Region 3 — Visit Context

Required:
- Visit Type: General Consultation — read-only
- Chair: Chair 02 — read-only

No appointment or queue controls.

## 7. Region 4 — Visit Lifecycle

Exactly these states:
1. Scheduled
2. Checked In
3. Waiting
4. Called
5. In Treatment
6. Ready for Closure
7. Closed

Canonical current state: `In Treatment`.

The current state must be visually distinct from non-current states.

## 8. Region 5 — Current Visit State

Required:
- Visit State: In Treatment — read-only

This is the authoritative visible Shared Visit state. It is not Treatment Status, Closure Outcome, or Procedure Status.

## 9. Region 6 — Visit Summary

Required read-only information:
- Visit Type: General Consultation
- Chair: Chair 02
- Current State: In Treatment

Do not invent a separate Visit Status value.

## 10. Region 7 — Visit Actions

Canonical current state: `In Treatment`.

Required active action:
`Ready for Closure`

This is a Shared Visit lifecycle transition only. It does not complete treatment, complete a procedure, select a closure outcome, or navigate to Clinical Closure.

## 11. Editable / Read-only Matrix

| Element | Editable | Action |
|---|---:|---|
| Patient | No | — |
| Patient ID | No | — |
| Visit ID | No | — |
| Visit Date | No | — |
| Visit Type | No | — |
| Chair | No | — |
| Lifecycle display | No | — |
| Current Visit State | No | — |
| Visit Summary | No | — |
| Ready for Closure | — | Yes |

Lifecycle state changes occur through authorized lifecycle actions, not generic field editing.

## 12. Lifecycle Transitions

- Scheduled → Checked In
- Checked In → Waiting
- Waiting → Called
- Called → In Treatment
- In Treatment → Ready for Closure
- Ready for Closure → Closed

No backward or shortcut transitions.

The canonical screen is in `In Treatment`, so only `Ready for Closure` is exposed as the active action.

## 13. Explicitly Invalid Transitions

Do not represent:
- Scheduled → In Treatment
- Scheduled → Closed
- Checked In → Called
- Waiting → In Treatment
- Waiting → Closed
- In Treatment → Scheduled
- In Treatment → Checked In
- In Treatment → Closed
- Closed → In Treatment
- Closed → Scheduled

## 14. Ownership Boundaries

Shared Visit owns:
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit Lifecycle
- Current Visit State

Treatment Planning owns treatment plan and treatment status. Shared Visit must not mutate treatment.

Clinical Workspace owns Clinical Notes and Procedure Notes. Shared Visit must not contain them.

Clinical Closure owns Closure Outcome, Close Visit, Cancel, and closure classification. Shared Visit must not contain them.

Dental Chart owns chart findings and mutation. No tooth, surface, condition, or finding controls are permitted.

Performed Procedure, Clinical Record History, Billing, and Insurance are outside Phase 1.

Appointment scheduling, appointment management, queue management, and no-show controls are outside Phase 1.

## 15. Multi-Visit Preservation

A visit may close while treatment remains In Progress. `Visit Closed` must never imply `Treatment Completed`.

A later visit may independently begin `In Treatment`.

`Treatment Continues` remains a Clinical Closure outcome and must not appear in Shared Visit.

## 16. Component Requirements

Use genuine existing approved component instances where applicable, especially existing Button and established status/read-only conventions.

Do not create or modify design-system definitions without separate authorization.

## 17. Prototype Requirements

All interactions remain local to Shared Visit. No cross-module navigation or mutation is authorized.

## 18. Layout Requirements

- Root width: `920 px`
- Root layout: vertical Auto Layout
- Content-driven height
- No clipping
- No overlap
- No horizontal overflow
- Clear patient hierarchy
- Clear current-state hierarchy
- Readable lifecycle
- Clear next action

## 19. Visual Hierarchy

Priority:
1. Patient identity
2. Current Visit State
3. Visit Context
4. Lifecycle
5. Visit Summary
6. Next lifecycle action

## 20. Acceptance Criteria

PASS requires:
- one canonical composition
- exactly seven top-level regions
- correct region order
- 920 px root width
- vertical Auto Layout
- all canonical fields present
- current state In Treatment
- lifecycle represented correctly
- Ready for Closure as the active action
- genuine component instances where applicable
- no unauthorized workflow or navigation
- no frozen-module modification
- no design-system modification
- no clipping, overlap, or overflow

## 21. Freeze Gate

Before freeze:
- Architecture: APPROVED
- Field Specification: APPROVED
- Figma Pre-flight: PASS
- Implementation: PASS
- Structural QA: PASS
- Visual / UX Audit: PASS
- P0: NONE
- P1: NONE
- P2: NONE
- P3: NONE

## 22. Current Status

Architecture: APPROVED
Field Specification: APPROVED FOR IMPLEMENTATION
Canonical Visit ID: `V-000128`
Canonical Visit Date: `August 11, 2026`
Figma: NOT IMPLEMENTED
Freeze: NOT READY
Figma Changes: NONE
