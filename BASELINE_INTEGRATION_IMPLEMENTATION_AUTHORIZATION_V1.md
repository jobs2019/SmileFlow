# SmileFlow Baseline — Explicit Integration Implementation Authorization

## Status

**AUTHORIZED — BOUNDED PROTOTYPE INTEGRATION ONLY**

Date: 2026-08-12

## Authorization basis

This authorization follows:

1. SmileFlow Phase 1 baseline completion;
2. Project-State Reconciliation;
3. End-to-End Experience Walkthrough and user acceptance;
4. Repository Integration Readiness Reconciliation;
5. Baseline Integration Proposal v1;
6. Read-Only Cross-Module Dependency Audit v1.

## Scope

Authorization is granted to implement the minimum cross-module **Figma prototype navigation** required to make the existing SmileFlow Phase 1 baseline behave as one bounded navigable journey.

This is a prototype-integration authorization only.

It does not authorize production behavior, backend behavior, database/API changes, real persistence, event generation, automatic record creation, or lifecycle mutation.

## Authorized routes

| ID | From | To | Authorization |
|---|---|---|---|
| INT-01 | Patient Registration | Patient Management | AUTHORIZED |
| INT-02 | Patient Management | Dental Chart | AUTHORIZED |
| INT-03 | Patient Management | Shared Visit | AUTHORIZED |
| INT-04 | Shared Visit | Clinical Workspace | AUTHORIZED |
| INT-05 | Clinical Workspace | Treatment Planning | AUTHORIZED |
| INT-06 | Treatment Planning | Performed Procedure | AUTHORIZED |
| INT-07 | Performed Procedure | Clinical Closure | AUTHORIZED |
| INT-08 | Clinical Closure | Clinical Record History | AUTHORIZED |

## Route semantics

All eight routes are navigation-only prototype transitions.

Routes may display or carry minimum contextual identifiers needed to represent the destination prototype state, such as Patient ID or Visit ID, but they must not create persistence semantics.

## Explicit prohibitions

This authorization does NOT permit:

- changing Shared Visit Visit State;
- `Close Visit` behavior;
- automatic check-in, call, treatment, closure, or visit-state transitions;
- editing Treatment Planning from another module;
- automatic Performed Procedure creation;
- automatic Clinical Record History creation;
- Dental Chart mutation;
- scheduling or queue mutation;
- billing or insurance behavior;
- backend/API/database implementation;
- AI-generated clinical content;
- creation of new fields;
- creation or modification of shared design-system components;
- redesign of any canonical module;
- changes to frozen architectures;
- Clinical Closure v1.4 changes.

## Module ownership

Integration must preserve the existing ownership model:

- Patient Registration owns registration workflow.
- Patient Management owns patient-record management.
- Dental Chart owns its approved chart boundary.
- Shared Visit remains sole owner of Visit State.
- Clinical Workspace owns its approved clinical-work surface.
- Treatment Planning owns planned treatment.
- Performed Procedure owns actual procedure recording.
- Clinical Closure owns the closure record.
- Clinical Record History owns historical presentation.

Navigation does not transfer ownership.

## Protected modules and nodes

The following modules remain read-only during integration:

- Patient Management
- Patient Registration
- Dental Chart
- Treatment Planning
- Shared Visit
- Clinical Workspace
- Performed Procedure
- Clinical Record History

Clinical Closure is currently canonical, Final-QA-passed, and governed by its approved v1.3 architecture/field specification. Its current repository source-of-truth state is **NOT FROZEN**; this integration authorization does not freeze it. The integration may add only the explicitly authorized navigation route to the existing canonical Clinical Closure composition and must not alter its internal architecture, fields, or behavior.

No frozen node may be modified, replaced, renamed, or repurposed by this authorization.

## Implementation boundary

Integration should be implemented in a dedicated, clearly named **SmileFlow Baseline Integration / Experience** prototype harness or other explicitly bounded integration surface approved by the Figma preflight.

The implementation must reuse the existing canonical module compositions and genuine existing components. It must not create replacement module screens merely to simplify routing.

Historical/superseded frames must not be used as integration destinations.

## Required pre-write gate

Before writing to Figma, the implementation must still satisfy the repository's Figma preflight requirements, including:

- read-first inspection;
- exact canonical destination verification;
- exact-name conflict check;
- component identity verification;
- protected-node verification;
- route-boundary verification;
- no unintended shared-component modification.

This authorization does not bypass Figma preflight.

## Required QA after implementation

The integration must undergo a dedicated Integration QA covering at minimum:

1. INT-01 through INT-08 each reach the intended canonical destination;
2. no route reaches a historical/superseded composition;
3. no forbidden state mutation occurs;
4. Shared Visit remains sole Visit State owner;
5. no `Close Visit` behavior exists;
6. no implicit Performed Procedure or Clinical Record History creation occurs;
7. protected modules/nodes remain untouched;
8. backward navigation is bounded and intentional;
9. the complete journey is traversable;
10. the integrated journey remains consistent with all approved module architectures and field specifications.

## Freeze impact

This authorization does not freeze any currently open module.

It does not reopen or unfreeze any frozen module.

It does not supersede any module architecture or field specification.

## Decision

**IMPLEMENTATION AUTHORIZED — BOUNDED PROTOTYPE INTEGRATION ONLY**

The next task is:

**SmileFlow Baseline — Integration Implementation / Read-First Figma Preflight**

No implementation should begin by modifying canonical module internals. The first implementation action is the required read-only Figma preflight for the integration harness and all eight destinations.
