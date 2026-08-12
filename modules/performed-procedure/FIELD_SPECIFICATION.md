# Performed Procedure — Field Specification (Reconstructed)

**Status:** Reconstructed from verified Figma evidence; not recovered historical source.
**Phase:** 1
**Figma node:** `260:2`

## 1. Field matrix

### Procedure Header

| Field | Value observed | Mode | Ownership |
|---|---|---|---|
| Module title | Performed Procedure | Static | Module presentation |
| Patient | Maria Santos | Read-only | Patient context |
| Patient ID | P-000128 | Read-only | Patient context |

### Visit Context — read-only Shared Visit references

| Field | Value observed | Mode | Source |
|---|---|---|---|
| Visit ID | V-000128 | Read-only | Shared Visit |
| Visit Date | August 11, 2026 | Read-only | Shared Visit |
| Visit Type | General Consultation | Read-only | Shared Visit |
| Chair | Chair 02 | Read-only | Shared Visit |
| Visit State | In Treatment | Read-only | Shared Visit |

### Planned Treatment Reference — read-only

| Field | Value observed | Mode | Source |
|---|---|---|---|
| Planned Procedure | Composite Restoration | Read-only | Treatment Planning |
| Planned Tooth | 46 | Read-only | Treatment Planning |
| Planned Surface | Occlusal | Read-only | Treatment Planning |

### Actual Procedure — editable

| Field | Value observed | Mode | Component |
|---|---|---|---|
| Actual Procedure | Composite Restoration | Editable | Functional Select Field `236:1819` |
| Actual Tooth | 46 | Editable | Functional Select Field `236:1819` |
| Actual Surface | Occlusal | Editable | Functional Select Field `236:1819` |

The exact option vocabulary for these three select fields is not reconstructed here because the recovery evidence establishes their existence and component identity, but not a complete authoritative option set.

### Procedure Details — editable

| Field | Value observed | Mode | Component |
|---|---|---|---|
| Procedure Details | Composite restoration performed on tooth 46, occlusal surface. | Editable | Input Field `40:103` |
| Materials / Technique | Composite resin restoration using standard adhesive technique. | Editable | Input Field `40:103` |

### Clinical Documentation — editable

| Field | Value observed | Mode | Component |
|---|---|---|---|
| Procedure Notes | Occlusal composite restoration completed on tooth 46. Restoration finished and polished. | Editable | Input Field `40:103` |
| Clinical Findings | Occlusal caries noted prior to restoration. | Editable | Input Field `40:103` |

### Procedure status

| Field | Value observed | Mode |
|---|---|---|
| Procedure Status | Recorded | Displayed status |

The implementation does not provide enough evidence to define the complete status lifecycle or backend persistence rules.

## 2. Action

| Action | Exact label | Type | Observed behavior |
|---|---|---|---|
| Record | `Record Procedure` | Primary Button | Records the actual procedure according to the Figma description |

No additional Phase 1 action is authorized by the inspected implementation.

## 3. Read-only/editable boundary

Editable:
- Actual Procedure
- Actual Tooth
- Actual Surface
- Procedure Details
- Materials / Technique
- Procedure Notes
- Clinical Findings

Read-only/reference:
- Patient
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State
- Planned Procedure
- Planned Tooth
- Planned Surface
- Procedure Status display

## 4. Clinical boundaries

The module must not become an editor for:

- Shared Visit state
- Treatment Planning
- Dental Chart
- billing or insurance
- scheduling or queue

The reconstruction does not infer any automatic downstream mutation after `Record Procedure`.

## 5. Component rules

Use the observed existing SmileFlow components. Do not create or modify global components solely from this reconstructed specification.

## 6. Evidence limitations

This document is a reconstruction from Figma evidence. It does not establish:

- database schema
- API behavior
- permissions
- persistence timing
- audit behavior
- exact select-option vocabulary
- downstream event generation

Those require separate authoritative evidence.
