# Clinical Closure — Field Specification v1.1 Amendment

## Status

**APPROVED — Phase 1 source-of-truth amendment**

This amendment supplements `FIELD_SPECIFICATION.md` (v1.0). All v1.0 requirements remain in force except where this document explicitly clarifies prototype-only behavior.

## Purpose

Resolve the Final QA conflict between the approved v1.0 field specification and the already-built functional prototype.

The prototype requires Save/Cancel reactions so the user can test the workflow. Those reactions are therefore explicitly authorized **for local QA validation only**.

## Authorized prototype behavior

### Save Closure Outcome

The canonical prototype may attach a local reaction:

`Save Closure Outcome` → local `Saved` QA validation state

### Cancel

The canonical prototype may attach a local reaction:

`Cancel` → local `Cancelled` QA validation state

## Strict boundary

These reactions are **prototype-only validation behavior**.

They do NOT authorize:

- production navigation
- automatic cross-module navigation
- Treatment Planning mutation
- Shared Visit mutation
- Visit closure
- Treatment completion
- Performed Procedure creation
- Clinical Record History creation
- Dental Chart mutation
- billing or insurance actions
- scheduling or queue actions
- any other clinical-state mutation

The Saved and Cancelled destinations are QA evidence artifacts, not production modules and not additional source-of-truth compositions.

## Production semantics

The production meaning remains:

- `Save Closure Outcome` saves the Clinical Closure decision only.
- `Cancel` abandons the unsaved local Clinical Closure decision only.

If actual production persistence, navigation, or downstream handoff is later required, it must receive a separate approved interaction specification and pass the SmileFlow Figma Preflight protocol again.

## Canonical invariants added

The following invariant is added to the v1.0 canonical composition invariants:

> Any prototype reaction attached to Clinical Closure actions must be local-only QA behavior and must not authorize production navigation or cross-module mutation.

## QA consequence

The existing Save/Cancel prototype reactions are now **specification-compliant** under v1.1 and may remain in the canonical prototype.

Final QA must re-run against v1.0 plus this amendment.

## Version rule

This amendment is intentionally narrow. It does not change:

- the seven-region architecture
- field ownership
- editable/read-only matrix
- Closure Outcome vocabulary
- existing component requirements
- clinical boundaries
- downstream ownership
- protected legacy-node rules
- canonical node identity

**Effective specification: `FIELD_SPECIFICATION.md` v1.0 + this v1.1 amendment.**
