# Clinical Workspace — Precise Field-Level Specification v1.0

## Composition
`Clinical Workspace — Phase 1`
Recommended width: 920 px. Vertical Auto Layout. Exactly seven top-level regions.

## Header
- Patient Name — `Maria Santos` — read-only
- Patient ID — `P-000128` — read-only
- Module Title — `Clinical Workspace` — read-only

## Visit Context
- Visit Type — `General Consultation` — read-only
- Chair — `Chair 02` — read-only
- Visit Status — `In Treatment` — read-only
- Patient — `Maria Santos` — reference
- Patient ID — `P-000128` — reference

## Active Treatment
- Treatment Name — `Composite Restoration` — read-only
- Tooth / Site — `46` — read-only
- Planned Surface — `Occlusal` — read-only
- Treatment Status — `In Progress` — read-only
- Current Visit State — `In Treatment` — read-only

## Tooth / Treatment Scope
- Tooth — `46` — read-only
- Surface — `Occlusal` — read-only

## Clinical Documentation
### Clinical Notes
Value: `Patient evaluated and treatment initiated for the planned restoration.`
Editable. Genuine existing `Input Field` instance. Approved resized convention: approximately 840 × 64, text auto-resize `HEIGHT`.

### Procedure Notes
Value: `Tooth 46 prepared for planned occlusal composite restoration.`
Editable. Genuine existing `Input Field` instance. Same approved resized convention.

## Visit Status
`In Treatment` — read-only.

## Clinical Actions
Exactly one action: `Clinical Closure`, using a genuine existing Button instance.

## Invalid content
No Dental Chart editing, Treatment Planning editing, queue/appointment controls, closure outcomes, performed-procedure finalization, history timeline, billing, or insurance.
