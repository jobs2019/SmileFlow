# SmileFlow Baseline — Integration Proposal v1

## Status

**PROPOSED — READ-ONLY / NOT AUTHORIZED FOR FIGMA WRITE**

This proposal defines the minimum cross-module experience needed to make the completed SmileFlow Phase 1 baseline behave as one navigable prototype journey. It does not authorize runtime/backend behavior, data mutation, shared-component changes, or modification of frozen module compositions.

## Baseline

The Phase 1 modules are individually implemented and validated. The integration goal is limited to letting a user move through the existing clinical journey while preserving module ownership.

## Principle

**Navigation is not ownership.**

A prototype route may move the user from one module to another without granting the destination module ownership of the source module's data or lifecycle.

## Proposed journey

```text
Patient Registration
        ↓
Patient Management
        ↓
Dental Chart
        ↓
Shared Visit
        ↓
Clinical Workspace
        ↓
Treatment Planning
        ↓
Performed Procedure
        ↓
Clinical Closure
        ↓
Clinical Record History
```

## Proposed prototype routes

| ID | From | To | Purpose | Mutation authorized? |
|---|---|---|---|---|
| INT-01 | Patient Registration | Patient Management | Continue after patient registration | No |
| INT-02 | Patient Management | Dental Chart | Open patient's chart | No |
| INT-03 | Patient Management | Shared Visit | Open the patient's active visit context | No |
| INT-04 | Shared Visit | Clinical Workspace | Enter active clinical work context | No |
| INT-05 | Clinical Workspace | Treatment Planning | Open treatment-plan context | No |
| INT-06 | Treatment Planning | Performed Procedure | Open actual-procedure recording context | No |
| INT-07 | Performed Procedure | Clinical Closure | Continue to closure after recording procedure | No |
| INT-08 | Clinical Closure | Clinical Record History | Review the closure/history context | No |

## Route semantics

All proposed routes are navigation-only prototype transitions unless a separate approved interaction contract explicitly authorizes state mutation.

No route may:

- change Shared Visit Visit State;
- close a visit;
- edit Treatment Planning from another module;
- create a Performed Procedure implicitly;
- create Clinical Record History implicitly;
- modify Dental Chart state;
- alter scheduling or queue state;
- create billing/insurance behavior.

## Module ownership preservation

- Patient Registration owns registration workflow.
- Patient Management owns patient-record management.
- Dental Chart owns chart presentation/state within its approved boundary.
- Shared Visit remains sole owner of Visit State.
- Clinical Workspace owns its approved clinical-work/documentation surface.
- Treatment Planning owns planned treatment.
- Performed Procedure owns actual procedure recording.
- Clinical Closure owns the closure record.
- Clinical Record History owns historical presentation.

## Navigation-only context handoff

A route may carry or display the minimum contextual identifiers needed to render the destination prototype state, such as Patient ID and Visit ID, but this proposal does not define persistence, API contracts, event generation, or database behavior.

## Protected modules

All frozen modules remain read-only:

- Patient Management
- Patient Registration
- Dental Chart
- Treatment Planning
- Shared Visit
- Clinical Workspace
- Performed Procedure
- Clinical Record History

Clinical Closure v1.3 is also frozen under its explicit freeze authorization.

No route in this proposal authorizes modification of those modules.

## QA requirements

If this proposal is later authorized for implementation, integration QA must verify:

1. every intended route reaches the correct canonical destination;
2. no route reaches historical or superseded compositions;
3. no route mutates ownership outside its source/destination contract;
4. Visit State remains owned by Shared Visit;
5. no `Close Visit` behavior is introduced;
6. no implicit downstream record creation occurs;
7. protected nodes remain untouched;
8. all destinations use the current canonical module compositions;
9. broken/back-navigation behavior is bounded and intentional;
10. the integrated journey remains consistent with each module's approved architecture and field specification.

## Explicit non-goals

This proposal does not authorize:

- backend implementation;
- database/API changes;
- production workflow integration;
- cross-module data synchronization;
- automatic event creation;
- automatic lifecycle transitions;
- redesign of any module;
- new fields;
- new components;
- changes to frozen architecture;
- Clinical Closure v1.4.

## Decision

**PENDING EXPLICIT IMPLEMENTATION AUTHORIZATION**

The proposal must pass the read-only Cross-Module Dependency Audit before any Figma implementation is considered.

Date: 2026-08-12
