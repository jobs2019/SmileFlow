# Clinical Workspace — Module Agent Rules

## Scope
These rules apply to Clinical Workspace and its descendants.

## Current state
Clinical Workspace has an approved replacement architecture and field specification, but the replacement Figma implementation is NOT IMPLEMENTED and preflight has NOT STARTED.

The previous Clinical Workspace Figma composition is protected historical work.

## Ownership
Clinical Workspace owns active clinical work and current clinical documentation within its approved Phase 1 boundary.

Current approved Phase 1 regions:
1. Workspace Header
2. Patient & Visit Context
3. Active Treatment
4. Clinical Assessment
5. Treatment Plan Context
6. Clinical Work & Documentation
7. Workspace Actions

Sole authorized action: `Save Clinical Notes`.

Insurance is excluded.

## Implementation gate
Do not modify Figma until the strict Clinical Workspace preflight passes and implementation is separately authorized.

Do not modify, delete, rename, duplicate, or repurpose the previous Clinical Workspace composition as a shortcut.

## Ownership boundaries
Do not introduce Treatment Planning editing, Dental Chart editing, Clinical Closure controls, Performed Procedure editing, Clinical Record History editing, billing, or insurance workflows into Clinical Workspace unless the approved architecture explicitly changes.

## Design-system protection
Reuse approved existing SmileFlow components as genuine instances. Do not modify global components, variants, variables, styles, tokens, or typography foundations as a side effect.

## Safety
If authorization, specification, ownership, exact-name, component, or preflight requirements are unresolved, stop and report `NOT READY — do not modify Figma.`
