# Clinical Record History — Architecture (Reconstructed)

**Status:** Reconstructed from verified Figma evidence; not recovered historical source.
**Figma node inspected:** `153:1204`
**Node name:** `Clinical Record History — Phase 1`
**Size:** 920 × 1548 px
**Layout:** Vertical Auto Layout

## Reconstruction rule

This document records only architecture directly supported by the inspected Figma implementation. Runtime, backend, event-generation, and persistence mechanisms are intentionally unspecified where not observable.

## Purpose

Clinical Record History is a **read-only historical presentation** of clinical procedure records.

The implementation explicitly labels itself `Clinical Record History · Read-only` and describes its filters as view controls only.

## Four-region architecture

1. **History Header** — patient and record identity.
2. **History Filters** — read-only view/filter controls.
3. **Timeline Summary** — read-only aggregate counts.
4. **Procedure Timeline** — chronological historical procedure records.

## Region responsibilities

### History Header
Provides:
- Patient
- Patient ID
- Record Type

### History Filters
Provides five read-only filters:
- Date
- Procedure
- Tooth
- Treatment Item
- Visit

These are view controls only. They are not clinical editing fields.

### Timeline Summary
Displays aggregate historical information:
- Total Procedures
- Completed
- Treatment Items
- Visits

### Procedure Timeline
Displays historical records in **Newest → Oldest** order.

Observed record structure:
- Date / Time
- Procedure
- Status
- Site / Scope
- Visit
- Treatment Item

## Component architecture

The five filter controls use the existing read-only Select Field component:

- Main component `42:125`
- Name: `=Select Field, State=Read-only`

No global component modification is implied or authorized by this reconstruction.

## Interaction boundary

No prototype reactions were observed on the inspected node.

The composition is read-only. This reconstruction does not infer backend filtering, pagination, permissions, export behavior, or navigation behavior.

## Ownership boundary

Clinical Record History presents historical information and does not expose an editing surface for the displayed clinical records.

The inspected Figma implementation does not establish the mechanism that creates historical entries. That mechanism remains unspecified.

## Phase 1 exclusions

- editing procedures
- editing treatment plans
- editing Dental Chart
- editing Shared Visit
- creating procedures
- changing clinical status
- billing/insurance actions
- scheduling/queue actions

## Protected implementation

The Figma node `153:1204` was inspected read-only and remains untouched.
