# Dental Chart — Module Agent Rules

## Scope
These rules apply to Dental Chart and its descendants.

## Current state
Dental Chart — Phase 1 — Canonical is FROZEN. The legacy `Dental Chart — Phase 1` frame is also protected.

## Ownership
Dental Chart owns the approved permanent tooth/chart state and tooth-condition presentation within its approved scope.

It does not own treatment planning, performed procedures, clinical closure, clinical history, or general clinical documentation.

## Change rule
Do not modify the canonical or legacy protected Figma frames without an explicit Architecture Exception and separate implementation authorization.

Do not alter global components, variables, styles, or tokens as a side effect of module work.

## Feature changes
Any requested addition/removal/modification must first be classified as chart-owned or cross-module. Cross-module requests require an architecture decision before implementation.

## Safety
If a requested change conflicts with frozen status, ownership, or the approved chart architecture, stop and report `NOT READY — do not modify Figma.`
