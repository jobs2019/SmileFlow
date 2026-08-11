# Shared Visit — Architecture & Information Model v1.0

Status: APPROVED FOR FIELD SPECIFICATION
Figma Implementation: NOT YET IMPLEMENTED
Figma Changes: NONE

## 1. Module Identity

Shared Visit owns the lifecycle and current operational state of the active patient visit.

Authoritative ownership:
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit Lifecycle
- Current Visit State

Shared Visit does not own treatment lifecycle, clinical documentation, performed procedures, closure outcomes, clinical history, billing, insurance, appointment management, or queue management.

## 2. Architectural Principle

Visit State, Treatment Status, Closure Outcome, and Procedure Status are independent domains and must never be presented as interchangeable.

Example:
- Visit State: In Treatment
- Treatment Status: In Progress

## 3. Seven-Region Architecture

The Phase 1 composition contains exactly seven top-level regions in this order:
1. Visit Header
2. Patient / Visit Identity
3. Visit Context
4. Visit Lifecycle
5. Current Visit State
6. Visit Summary
7. Visit Actions

No additional top-level regions are authorized.

## 4. Region Ownership

### Visit Header
Identifies the patient and module. Displays Patient Name, Patient ID, and Shared Visit. Read-only.

### Patient / Visit Identity
Displays Patient, Patient ID, Visit ID, and Visit Date. Patient master data remains owned by Patient Management / Patient Registration; Visit ID and Visit Date are owned by Shared Visit.

### Visit Context
Owns Visit Type and Chair. Does not introduce appointment or queue architecture.

### Visit Lifecycle
Represents the visit lifecycle: Scheduled → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed.

### Current Visit State
Displays the authoritative current visit state. Canonical state: In Treatment.

### Visit Summary
Provides concise read-only operational information such as Visit Type, Chair, and Current Visit State. Do not invent a separate Visit Status value if no distinct canonical value exists.

### Visit Actions
Exposes the valid Shared Visit lifecycle transition for the current state. For the canonical state In Treatment, the next valid action is Ready for Closure.

## 5. Lifecycle State Model

Exactly seven states:
1. Scheduled
2. Checked In
3. Waiting
4. Called
5. In Treatment
6. Ready for Closure
7. Closed

Valid transitions:
- Scheduled → Checked In
- Checked In → Waiting
- Waiting → Called
- Called → In Treatment
- In Treatment → Ready for Closure
- Ready for Closure → Closed
- Closed → no further Phase 1 transition

No backward or shortcut transitions are authorized.

## 6. Explicit Boundaries

Treatment Planning owns treatment plan and treatment status. Shared Visit must not complete or mutate treatment.

Clinical Workspace owns Clinical Notes and Procedure Notes. Shared Visit must not duplicate them.

Clinical Closure owns Closure Outcome, Close Visit, Cancel, and closure classification. Shared Visit must not contain those controls or outcomes.

Dental Chart owns chart findings and mutations. Shared Visit contains no tooth, surface, condition, or finding controls.

Performed Procedure and Clinical Record History are outside Phase 1.

Billing and Insurance are outside Phase 1.

Appointment scheduling, appointment management, queue numbering, no-show management, and waiting-room queue behavior are outside Phase 1. Waiting and Called are lifecycle states only.

## 7. Multi-Visit Principle

Visit Closed must never imply Treatment Completed. A visit may close while treatment remains In Progress. A later visit may independently begin In Treatment.

Clinical Closure may classify an outcome as Treatment Continues; that outcome belongs exclusively to Clinical Closure.

## 8. Data Ownership

| Data | Owner |
|---|---|
| Patient master data | Patient Management |
| Registration data | Patient Registration |
| Visit ID | Shared Visit |
| Visit Date | Shared Visit |
| Visit Type | Shared Visit |
| Chair | Shared Visit |
| Visit Lifecycle | Shared Visit |
| Current Visit State | Shared Visit |
| Treatment Plan / Status | Treatment Planning |
| Clinical Notes / Procedure Notes | Clinical Workspace |
| Closure Outcome | Clinical Closure |
| Performed Procedure | Future module |
| Clinical History | Future module |
| Billing | Future module |
| Insurance | Future module |

## 9. Prototype Boundary

Only valid Shared Visit lifecycle transitions may be represented. No cross-module navigation is required or authorized in Phase 1.

## 10. Design-System Boundary

Shared Visit must consume existing approved design-system components. Do not modify component definitions, variants, variables, tokens, typography, global styles, or icon foundations. If a required reusable component is unavailable, stop rather than inventing an unauthorized substitute.

## 11. Frozen Modules

The following remain frozen:
- Patient Management
- Patient Registration
- Dental Chart — Phase 1 — Canonical
- Legacy Dental Chart — Phase 1
- Treatment Planning — Phase 1 — Canonical
- Legacy Treatment Planning — Phase 1
- Clinical Workspace — Phase 1
- Clinical Closure — Phase 1 — Canonical

## 12. Phase 1 Non-Goals

Appointment scheduling, appointment management, queue management, billing, insurance, treatment editing/completion, procedure documentation/completion, Dental Chart editing, clinical notes, closure outcome selection, clinical history, and treatment completion are out of scope.

## 13. Implementation Gate

Before Figma implementation:
1. Field specification approved.
2. Canonical Visit ID established.
3. Canonical Visit Date established.
4. Strict Codex implementation prompt generated.
5. Figma pre-flight passes.

## 14. Current Status

Architecture: APPROVED FOR FIELD SPECIFICATION
Field Specification: NEXT
Figma: NOT IMPLEMENTED
Freeze: NOT READY
Figma Changes: NONE
