# SmileFlow Baseline — Explicit Integration Implementation Authorization v1

## Status

**AUTHORIZED — BOUNDED PROTOTYPE NAVIGATION ONLY**

Date: 2026-08-13

## Authorization basis

This authorization is reaffirmed by the user's explicit current instruction:

> **Explicit Integration Implementation Authorization**

It follows the completed and passing baseline integration gates:

1. `BASELINE_INTEGRATION_PROPOSAL_V1.md`
2. `BASELINE_CROSS_MODULE_DEPENDENCY_AUDIT_V1.md`
3. `BASELINE_INT08_CLINICAL_RECORD_HISTORY_RESOLUTION_V1.md`
4. current `PROJECT_STATE.md`
5. `governance/FROZEN_MODULES.md`
6. `governance/FIGMA_PREFLIGHT.md`

## Authorized scope

Implement exactly these eight bounded prototype-navigation routes:

| ID | From | To | Scope |
|---|---|---|---|
| INT-01 | Patient Registration | Patient Management | Navigation only |
| INT-02 | Patient Management | Dental Chart | Navigation only |
| INT-03 | Patient Management | Shared Visit | Navigation only |
| INT-04 | Shared Visit | Clinical Workspace | Navigation only |
| INT-05 | Clinical Workspace | Treatment Planning | Navigation only |
| INT-06 | Treatment Planning | Performed Procedure | Navigation only |
| INT-07 | Performed Procedure | Clinical Closure | Navigation only |
| INT-08 | Clinical Closure | Clinical Record History | Navigation only |

## Implementation boundary

Integration must be implemented through a dedicated, clearly bounded prototype integration harness/page or equivalent non-canonical integration layer.

The implementation must reuse the existing canonical module compositions and genuine approved components. It must not modify the internal composition of frozen modules merely to add routing.

Canonical destinations:

- Treatment Planning: `198:1290`
- Shared Visit: `256:1303`
- Performed Procedure: `260:2`
- Clinical Record History: `153:1204`
- Clinical Workspace: `328:1919`
- Clinical Closure: `220:1294`

Protected historical Clinical Workspace node: `207:1291`.

## Navigation semantics

Routes may display/carry minimum contextual identifiers required for prototype presentation, including Patient ID, Visit ID, and an already-established treatment/procedure context.

This is navigation context only. It does not authorize persistence, API calls, database writes, event generation, automatic record creation, or cross-module synchronization.

## Ownership requirements

- Patient Registration remains the registration boundary.
- Patient Management remains the patient-management boundary.
- Dental Chart remains the chart-state boundary.
- Shared Visit remains the sole owner of Visit State.
- Clinical Workspace remains responsible for its approved clinical-work surface.
- Treatment Planning remains the planned-treatment boundary.
- Performed Procedure remains the actual-procedure boundary.
- Clinical Closure remains the closure-record boundary.
- Clinical Record History remains read-only historical presentation.

Navigation never transfers ownership.

## Protected modules and nodes

The following canonical modules remain protected during integration:

- Patient Management
- Patient Registration
- Dental Chart
- Treatment Planning
- Shared Visit
- Clinical Workspace
- Performed Procedure
- Clinical Record History
- Clinical Closure

All are currently recorded as frozen in `governance/FROZEN_MODULES.md`.

Protected legacy frames remain untouched, including Clinical Workspace `207:1291`.

No frozen node may be modified, replaced, renamed, repurposed, or used as an integration shortcut.

## Explicit prohibitions

This authorization does NOT permit:

- backend implementation;
- database changes or migrations;
- API changes;
- runtime persistence;
- automatic Visit State transitions;
- `Close Visit` behavior;
- automatic check-in/call/treatment/closure transitions;
- Treatment Planning mutation from another module;
- automatic Performed Procedure creation;
- automatic Clinical Record History creation;
- Dental Chart mutation;
- scheduling/queue mutation;
- billing;
- HMO/insurance behavior;
- AI clinical decision behavior;
- new clinical fields;
- new design-system components, variants, tokens, variables, or styles;
- redesign of existing modules;
- changes to module architecture or field specifications;
- Clinical Closure v1.4 work;
- changes to historical/superseded compositions.

## Required Figma preflight

This authorization does not bypass `governance/FIGMA_PREFLIGHT.md`.

Before any Figma write, a strict read-first preflight must be completed and must end in `READY`.

The preflight must establish:

1. correct Figma file and target page;
2. exact integration harness/bounded target;
3. exact eight authorized routes;
4. canonical destination verification;
5. exact-name conflict results;
6. design-system dependencies;
7. protected boundaries;
8. incremental execution plan;
9. structural, behavioral, visual, and protection validation plan;
10. recovery/rollback approach.

If any mandatory preflight gate fails, stop with:

> `NOT READY — do not modify Figma.`

## Required QA after implementation

Integration QA must verify:

1. INT-01 through INT-08 each reach the intended canonical destination;
2. no route reaches a historical/superseded composition;
3. no route mutates Visit State;
4. no `Close Visit` behavior exists;
5. no implicit downstream record creation occurs;
6. protected canonical modules remain untouched;
7. protected legacy frames remain untouched;
8. no global design-system assets were modified;
9. back-navigation is bounded and intentional;
10. the full journey is traversable;
11. the resulting prototype remains consistent with approved ownership, architecture, and field specifications.

## Stop conditions

Stop immediately if implementation requires:

- modifying a frozen module;
- changing architecture or field specifications;
- adding a shared component or token;
- modifying global design-system assets;
- introducing runtime persistence;
- resolving an unresolved contradiction by guesswork;
- targeting a historical/superseded node;
- expanding beyond INT-01 through INT-08.

Such work requires a separate change-control/authorization path.

## Decision

**IMPLEMENTATION AUTHORIZED — BOUNDED PROTOTYPE NAVIGATION ONLY**

The next operational step is:

> **SmileFlow Baseline — Integration Implementation / Read-First Figma Preflight**

No canonical module internals may be modified as part of this authorization.
