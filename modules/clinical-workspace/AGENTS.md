# Clinical Workspace — Module Agent Rules

## Scope
These rules apply to Clinical Workspace and its descendants.

## Current state
Clinical Workspace replacement architecture and field specification are APPROVED.

The replacement Figma implementation is COMPLETE, structurally QA'd, visually/UX audited, and FROZEN.

Canonical composition:
`Clinical Workspace — Phase 1 — Canonical` (`328:1919`)

The previous Clinical Workspace Figma composition `207:1291` is protected historical work and remains untouched.

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

## Freeze
The canonical replacement composition `328:1919` is FROZEN.

Any future modification requires:
1. an explicit Architecture Exception;
2. applicable implementation authorization; and
3. re-validation through structural QA and Visual & UX Audit before any re-freeze.

Do not modify the frozen canonical composition without satisfying those requirements.

## Protected historical composition
Do not modify, delete, rename, duplicate, or repurpose `207:1291` as a shortcut.

It remains historical/protected regardless of future replacement work.

## Ownership boundaries
Do not introduce Treatment Planning editing, Dental Chart editing, Clinical Closure controls, Performed Procedure editing, Clinical Record History editing, billing, or insurance workflows into Clinical Workspace unless the approved architecture explicitly changes.

## Design-system protection
Reuse approved existing SmileFlow components as genuine instances. Do not modify global components, variants, variables, styles, tokens, or typography foundations as a side effect.

## Safety
If authorization, specification, ownership, exact-name, component, or freeze requirements are unresolved, stop and report `NOT READY — do not modify Figma.`
