# Patient Management — Module Agent Rules

## Scope
These rules apply to Patient Management and its descendants.

## Current state
Patient Management is FROZEN.

## Ownership
Patient Management owns patient-level identity, demographics, patient summaries, and patient-level navigation within its approved scope.

## Change rule
Do not modify this module, its frozen Figma implementation, or its approved design-system dependencies unless the required architecture exception and implementation authorization are present.

Do not move ownership of registration, dental chart, treatment planning, visit, clinical workspace, closure, procedure, or history workflows into this module.

## Feature changes
For any requested addition, removal, or modification:
1. Identify whether the change belongs to Patient Management.
2. Check the frozen-module registry.
3. Check for an Architecture Exception.
4. Do not modify Figma without the required authorization and preflight.

## Evidence
Use this module's approved architecture/specification when available. Historical implementation and audit artifacts are evidence only.

## Safety
If the requested change conflicts with the frozen state or ownership boundary, stop and report `NOT READY — do not modify Figma.`
