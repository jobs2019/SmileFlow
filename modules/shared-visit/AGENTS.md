# Shared Visit — Module Agent Rules

## Scope
These rules apply to Shared Visit and its descendants.

## Current state
Shared Visit — Phase 1 — Canonical is FROZEN.

## Ownership
Shared Visit owns the current visit context and visit-state domain within its approved scope.

The visit state `In Treatment` must remain distinct from Treatment Planning's `In Progress` and Clinical Closure's closure outcomes.

## Change rule
Do not modify the frozen Figma implementation without an explicit Architecture Exception and separate implementation authorization.

Do not move treatment lifecycle, clinical documentation, closure outcomes, procedure details, or history ownership into Shared Visit.

## Safety
If a requested change changes visit semantics or crosses module ownership, stop before Figma modification and report `NOT READY — do not modify Figma.`
