# Clinical Workspace Phase 1 — Historical Implementation Report

## Status
SUPERSEDED — historical artifact from the previous Clinical Workspace architecture.

This report records the previous Figma implementation and must not be used as authorization or as the current source of truth for the replacement architecture.

## Previous canonical composition
`Clinical Workspace — Phase 1`
Node `207:1291`
920 × 1508 px
Vertical Auto Layout.

## Previous implementation details
Exactly seven regions were implemented under the previous architecture.

Two genuine multiline-convention Input Field instances were recorded:

- Clinical Notes — node `207:1357` — `INSTANCE` — `=Input Field, State=Filled` — 840 × 64 — HEIGHT auto-resize
- Procedure Notes — node `207:1361` — `INSTANCE` — `=Input Field, State=Filled` — 840 × 64 — HEIGHT auto-resize

Previous action:
- Clinical Closure — node `207:1372` — genuine existing primary Button instance

Previous state separation:
- Treatment Status: `In Progress`
- Visit State / Visit Status: `In Treatment`

## Historical verdict
The previous implementation was reported as PASS under its then-approved architecture.

## Replacement warning
The current source of truth is the replacement `ARCHITECTURE.md` and `FIELD_SPECIFICATION.md` for:

`Clinical Workspace — Phase 1 — Canonical`

The replacement architecture changes the content model and authorized action. In particular, `Save Clinical Notes` is now the sole authorized Phase 1 action. The previous `Clinical Closure` action must not be carried forward automatically.

The previous Figma composition remains protected until the replacement pre-flight passes and implementation is separately authorized.
