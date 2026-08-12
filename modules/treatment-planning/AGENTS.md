# Treatment Planning — Module Agent Rules

## Scope
These rules apply to Treatment Planning and its descendants.

## Current state
Treatment Planning — Phase 1 — Canonical is FROZEN. Its legacy Phase 1 frame is also protected.

## Ownership
Treatment Planning owns treatment-plan items and their approved treatment lifecycle. The canonical lifecycle is:

`Planned → Scheduled → In Progress → Completed`

It does not own visit state, clinical documentation, closure outcome, performed-procedure details, or historical chronology.

## Change rule
Do not modify the frozen canonical or legacy Figma implementation without an explicit Architecture Exception and separate implementation authorization.

Do not introduce visit, closure, procedure, history, billing, or insurance controls into Treatment Planning unless a future approved architecture explicitly assigns them there.

## Safety
If a requested change crosses ownership or frozen boundaries, stop and report `NOT READY — do not modify Figma.`
