# Clinical Closure — Canonicalization Plan v1.0

## Purpose

Define how the approved Clinical Closure Phase 1 implementation becomes the authoritative canonical Figma composition without modifying, renaming, deleting, duplicating, or repurposing the protected legacy composition.

## Current state

### Approved source of truth

- Architecture: APPROVED
- Field Specification v1.0: APPROVED
- Figma preflight: READY FOR BOUNDED IMPLEMENTATION

### Current implementation

Temporary construction:

`Clinical Closure — Phase 1 — v1.0 — Construction`

- Figma file: SmileFlow Foundations v1.0
- File key: `4XiHoPFlljnne38HnjLgc6`
- Page: `06 — Layouts` (`1:6`)
- Node: `331:1366`
- Dimensions: `920 × 1376 px`
- Structural QA: PASS
- Visual & UX Audit: PASS
- Local prototype validation: PASS for the tested Save/Cancel paths

### Protected legacy composition

`220:1294 — Clinical Closure — Phase 1 — Canonical`

Status:

**HISTORICAL / SUPERSEDED / PROTECTED**

The legacy node must remain physically untouched.

## Canonicalization rule

The temporary construction is the implementation candidate. The legacy composition remains historical evidence and is never used as the source of truth again.

The exact canonical name:

`Clinical Closure — Phase 1 — Canonical`

may only be assigned after the existing exact-name conflict is explicitly resolved through governance.

## Non-negotiable protections

The canonicalization process MUST NOT:

- modify `220:1294`;
- rename `220:1294`;
- delete `220:1294`;
- duplicate `220:1294`;
- repurpose `220:1294`;
- copy design decisions from the legacy composition merely to preserve its appearance;
- change global components, component sets, variables, tokens, styles, typography foundations, or icons unless separately authorized;
- silently alter Field Specification v1.0;
- freeze the module automatically.

## Required canonicalization sequence

### Gate 1 — Final acceptance

Before canonical naming, verify:

- all four Closure Outcome values are selectable;
- selected value displays correctly;
- Save Closure Outcome works for every outcome;
- Cancel works from every outcome;
- no prohibited downstream mutation occurs;
- no protected node changed;
- structural QA remains PASS;
- Visual/UX Audit remains PASS.

**Status: PENDING FINAL ACCEPTANCE**

### Gate 2 — Prototype disposition

The Saved and Cancelled prototype states are validation artifacts. They are not additional canonical modules.

After acceptance, retain them as QA evidence only or remove them only through a separately authorized cleanup operation. Their existence does not change the source of truth.

**Status: PENDING**

### Gate 3 — Exact-name conflict resolution

The legacy node currently owns the exact canonical name. We will NOT resolve this by modifying the legacy node.

The preferred resolution is a repository-governed designation that the legacy node remains the historical protected owner of the old name while the new implementation receives canonical authority through a safe naming strategy available in Figma.

No exact-name assignment should be attempted until the conflict resolution is explicitly authorized and the resulting Figma state can be verified.

**Status: BLOCKED UNTIL EXPLICIT NAMING DECISION**

### Gate 4 — Canonical implementation verification

Once the naming strategy is authorized, verify that the canonical candidate:

- is the v1.0 implementation candidate;
- contains exactly seven approved regions;
- uses genuine existing components;
- contains the approved fields and vocabulary;
- exposes only approved actions;
- remains independent of the protected legacy composition.

**Status: PENDING**

### Gate 5 — Final repository synchronization

Update:

- `STATUS.md`
- `PROJECT_STATE.md`
- `governance/FROZEN_MODULES.md` only when freeze is separately authorized
- implementation / QA / audit records as necessary

The repository must identify exactly one current canonical Clinical Closure implementation. The legacy node must remain explicitly historical/protected.

**Status: PENDING**

## Recommended naming strategy

Do not rename or modify the legacy node merely to free the exact string.

Instead, first determine whether the Figma file can safely support canonical authority through a page/container naming convention or another non-destructive identifier while preserving the legacy node's exact name.

If Figma's naming model makes this impossible, stop and request an explicit governance decision rather than silently changing the legacy artifact.

## Freeze boundary

Canonicalization does NOT equal freeze.

After canonicalization, the module remains:

**IMPLEMENTED / QA PASS / NOT FROZEN**

A separate explicit authorization is required to add Clinical Closure to the frozen module registry.

## Current verdict

**CANONICALIZATION NOT YET COMPLETE.**

The implementation candidate is ready, but final acceptance and exact-name conflict resolution remain separate gates.
