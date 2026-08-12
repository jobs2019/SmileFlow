# Clinical Record History — Field Specification (Reconstructed)

**Status:** Reconstructed from verified Figma evidence; not recovered historical source.
**Phase:** 1
**Figma node:** `153:1204`

## 1. Header

| Field | Value observed | Mode |
|---|---|---|
| History Heading | Clinical Record History · Read-only | Static |
| Patient | Patient: Maria Santos | Read-only |
| Patient ID | Patient ID: P-000128 | Read-only |
| Record Type | Record Type: Clinical Record History | Read-only |

## 2. History Filters

The implementation explicitly describes these as view controls only.

| Field | Default value observed | Mode | Component |
|---|---|---|---|
| Date | All | Read-only filter | Select Field `42:125` |
| Procedure | All Procedures | Read-only filter | Select Field `42:125` |
| Tooth | All Teeth | Read-only filter | Select Field `42:125` |
| Treatment Item | All Treatment Items | Read-only filter | Select Field `42:125` |
| Visit | All Visits | Read-only filter | Select Field `42:125` |

The recovery evidence confirms these controls and defaults but does not establish the complete option vocabulary or runtime filtering implementation.

## 3. Timeline Summary

| Field | Value observed | Mode |
|---|---|---|
| Total Procedures | Total Procedures: 3 | Read-only |
| Completed | Completed: 3 | Read-only |
| Treatment Items | Treatment Items: 2 | Read-only |
| Visits | Visits: 2 | Read-only |

These values are demonstration data observed in the frozen Figma implementation, not a runtime data contract.

## 4. Procedure Timeline

Order:

**Newest → Oldest**

### Record 1

- Date / Time: 11 Aug 2026 · 10:07 AM
- Procedure: Composite Restoration
- Status: Completed
- Site / Scope: Tooth 46 · Occlusal
- Visit: General Consultation · Chair 02
- Treatment Item: Composite Restoration

### Record 2

- Date / Time: 08 Aug 2026 · 11:20 AM
- Procedure: Oral Prophylaxis
- Status: Completed
- Site / Scope: Full Mouth
- Visit: General Consultation · Chair 02
- Treatment Item: Oral Prophylaxis

### Record 3

- Date / Time: 21 Jul 2026 · 09:30 AM
- Procedure: Extraction
- Status: Completed
- Site / Scope: Tooth 18
- Visit: General Consultation · Chair 02
- Treatment Item: Extraction

These records are demonstration content, not an assertion about production data.

## 5. Editable / read-only matrix

### Editable clinical data

None.

### Read-only

All visible data and filters in Phase 1 are read-only/view-only.

## 6. Component rules

The five filters use the existing read-only Select Field component `42:125`.

No custom filter component, global component modification, or new clinical editing component is authorized by this reconstructed specification.

## 7. Interaction rules

No prototype reactions were observed in the inspected Figma implementation.

The specification therefore treats the module as read-only and does not invent navigation, export, editing, persistence, or filtering mechanics not evidenced by Figma.

## 8. Clinical boundaries

Clinical Record History must not become an editor for:

- Performed Procedure
- Treatment Planning
- Dental Chart
- Shared Visit
- Clinical Workspace
- billing/insurance
- scheduling/queue

It presents history; it does not create or edit the underlying clinical event.

## 9. Evidence limitations

This specification does not establish:

- database schema
- source-of-record implementation
- event-generation mechanism
- persistence timing
- backend immutability enforcement
- permissions/roles
- audit-log implementation
- complete filter option vocabulary
- pagination behavior
- export behavior

Those require separate authoritative evidence.
