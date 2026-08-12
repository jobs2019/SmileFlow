# Clinical Closure v1.3 — Functional QA Construction

## Status

**AUTHORIZED — CONSTRUCTION SPECIFICATION**

This document defines the dedicated non-canonical Functional QA construction authorized by `V1_3_APPROVAL.md`.

## Purpose

Provide an explicit, bounded Figma prototype harness that makes the approved Clinical Closure v1.3 interaction contract directly testable without modifying the protected canonical/historical boundaries.

This is a QA construction, not a production implementation and not a new canonical Clinical Closure composition.

## Protected boundaries

Do not modify, rename, delete, repurpose, or duplicate:

- `207:1291` — protected frame
- `220:1294` — protected/historical Clinical Closure frame

The current canonical implementation is used only as a visual/reference baseline.

## QA construction boundary

Create a separate QA construction on the appropriate Clinical Closure QA page or existing QA/test area.

Preferred root name:

`Clinical Closure — v1.3 — Functional QA`

The construction may contain test-only state frames and bounded prototype destinations.

## Component rules

Use genuine existing components only:

- Functional Select Field for Closure Outcome
- Multiline Text Field for Clinical Closure Summary
- existing Button component for Save Closure Record and Cancel
- existing approved Input/Select components for outcome-specific fields where the approved field specification requires them

Do not modify shared component definitions, component sets, variants, variables, styles, tokens, typography, or icons.

## Required outcome states

The harness must provide directly testable states for:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

## Required conditional behavior

### Completed as Planned

Show the approved completion/actual-work context and Clinical Closure Summary. Save is valid when all required fields are satisfied.

### Completed with Modification

Show:

- Modification Classification
- Modification Reason

Both required before Save.

### Not Completed — no work

Show:

- Not Completed Reason

Actual Work must not be required when no work occurred.

### Not Completed — partial work

Show:

- bounded Actual Work information
- Not Completed Reason

Actual Work and Reason are required.

Do not duplicate the Performed Procedure editing surface.

### Treatment Continues

Show:

- Completed Today
- Remaining Treatment / continuation context
- next planned procedure / next step when known
- Clinical Closure Summary

Required values must block Save when missing.

## Required validation states

For each outcome, include at least one explicit invalid state demonstrating that Save is blocked when required fields are missing.

The validation state must remain local to the QA harness.

## Save behavior

Primary action label:

`Save Closure Record`

Valid Save routes to a test-only confirmation state that explicitly communicates:

- Closure Record saved
- no Shared Visit state mutation
- no Treatment Planning mutation
- no Performed Procedure creation
- no Clinical Record History creation
- no automatic Close Visit

Invalid Save routes to or remains in an explicit validation state.

## Cancel behavior

`Cancel` must route to a bounded test-only cancelled state that explicitly communicates:

- unsaved Clinical Closure changes were discarded
- no other module was mutated
- no Visit State mutation occurred

## Ownership safety tests

The QA harness must demonstrate absence of:

- `Close Visit`
- Shared Visit mutation
- Treatment Planning mutation
- Performed Procedure creation/editing
- Clinical Record History editing/creation
- Dental Chart mutation
- scheduling
- queue controls
- automatic navigation outside the QA boundary

## Select behavior

The Closure Outcome control should use the genuine Functional Select Field and expose the four consumer-owned v1.3 values through the existing menu/variant behavior where supported.

If the existing component's menu cannot directly route to the consumer states without modifying the shared component, stop and report a preflight/design-system blocker. Do not modify the shared component.

## Layout rules

- Preserve SmileFlow's existing visual language.
- Use vertical Auto Layout.
- Let parent Auto Layout expand with conditional content.
- Do not use absolute positioning to fake state changes.
- Do not introduce fixed-height clipping.
- Keep test states clearly bounded and distinguishable from canonical production compositions.

## QA matrix

| Test ID | State | Required check |
|---|---|---|
| CC-FQ-01 | Completed as Planned | valid Save |
| CC-FQ-02 | Completed with Modification | classification + reason required |
| CC-FQ-03 | Not Completed — no work | reason required; Actual Work not required |
| CC-FQ-04 | Not Completed — partial work | Actual Work + reason required |
| CC-FQ-05 | Treatment Continues | completed-today + remaining-treatment context required |
| CC-FQ-06 | Missing required field | Save blocked |
| CC-FQ-07 | Clinical Closure Summary | editable multiline field |
| CC-FQ-08 | Cancel | local discard only |
| CC-FQ-09 | Save ownership safety | no Shared Visit mutation |
| CC-FQ-10 | Forbidden action audit | no Close Visit / cross-module action |

## Acceptance rule

The Functional QA construction is complete only when every test above has an explicit executable or directly inspectable state and no protected boundary was modified.

A completed construction does not imply production/backend implementation and does not authorize canonicalization or freeze.
