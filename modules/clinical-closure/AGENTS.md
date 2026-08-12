# Clinical Closure — Module Agent Rules

## Scope
These rules apply to Clinical Closure and its descendants.

## Current state
Clinical Closure v1.3 is **APPROVED FOR IMPLEMENTATION**. A dedicated non-canonical Functional QA construction is authorized. The production/canonical implementation remains separately governed.

Do not infer production/backend implementation from the QA harness.

## Ownership
Clinical Closure owns the closure outcome boundary and closure-specific documentation as approved by the v1.3 architecture and field specification.

Do not invent final fields, regions, statuses, actions, or prototype transitions beyond approved specifications.

## Implementation gate
The v1.3 architecture and field specification are approved for the bounded Functional QA construction. Figma writes are limited to the explicitly authorized QA harness unless a separate implementation authorization expands the scope.

Figma preflight has passed for the v1.3 component requirements.

## QA construction boundary
The dedicated QA construction must remain non-canonical and test-only.

Do not modify, rename, delete, repurpose, or duplicate protected nodes:

- `207:1291`
- `220:1294`

Use genuine existing components. Do not modify shared component definitions, component sets, variants, variables, styles, tokens, typography, or icons.

## Safety
The QA harness must not introduce:

- automatic Shared Visit mutation
- automatic Treatment Planning mutation
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- scheduling or queue behavior
- `Close Visit`
- production/backend persistence

## Terminology
The v1.3 primary action label is `Save Closure Record`.

The v1.2 label `Save Closure Outcome` is superseded for v1.3.

## QA requirement
Functional QA must directly demonstrate all four Closure Outcomes, outcome-specific conditional fields, required-field validation, Summary editing, Save/Cancel behavior, and ownership safety.

## Freeze
The QA construction is not canonical and is not frozen. Canonicalization/freeze requires a separate explicit authorization.
