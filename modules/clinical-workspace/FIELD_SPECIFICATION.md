# Clinical Workspace — Precise Field-Level Specification v1.0

## Status
APPROVED — Phase 1 source of truth

## Composition
`Clinical Workspace — Phase 1 — Canonical`

Recommended width: 920 px. Vertical Auto Layout. Exactly seven top-level regions.

## Canonical demonstration context
- Patient: `Maria Santos` — read-only
- Patient ID: `P-000128` — read-only
- Visit ID: `V-000128` — read-only
- Visit Date: `August 11, 2026` — read-only
- Visit Type: `General Consultation` — read-only
- Chair: `Chair 02` — read-only
- Visit State: `In Treatment` — read-only

## Region 1 — Workspace Header
- Module Title: `Clinical Workspace` — static/read-only
- Patient: `Maria Santos` — read-only
- Patient ID: `P-000128` — read-only
- Visit Indicator: `Current Visit` — read-only

## Region 2 — Patient & Visit Context
- Visit ID: `V-000128` — read-only
- Visit Date: `August 11, 2026` — read-only
- Visit Type: `General Consultation` — read-only
- Chair: `Chair 02` — read-only
- Visit State: `In Treatment` — read-only

## Region 3 — Active Treatment
- Treatment Item: `Composite Restoration` — read-only
- Procedure: `Composite Restoration` — read-only
- Tooth: `46` — read-only
- Surface: `Occlusal` — read-only
- Treatment Status: `In Progress` — read-only

## Region 4 — Clinical Assessment
- Presenting Concern: `Sensitivity on lower right posterior tooth.` — editable
- Clinical Findings: `Occlusal caries noted on tooth 46.` — editable
- Assessment: `Caries — tooth 46.` — editable

Use genuine existing multiline Input Field instances. Approved resized convention: approximately 840 × 64 with height-resizing text and no clipping.

## Region 5 — Treatment Plan Context
- Planned Treatment: `Composite Restoration` — read-only
- Planned Procedure: `Composite Restoration` — read-only
- Planned Tooth: `46` — read-only
- Planned Surface: `Occlusal` — read-only
- Plan Status: `Planned` — read-only

Treatment-plan editing is not authorized in Phase 1.

## Region 6 — Clinical Work & Documentation
- Procedure Notes: `Composite restoration performed on tooth 46.` — editable
- Clinical Notes: `Patient tolerated the procedure well.` — editable
- Materials / Technique: `Composite resin restoration, occlusal surface.` — editable

Use genuine existing multiline Input Field instances with the approved resized convention.

These are working documentation fields only. Finalized procedure records remain owned by Performed Procedure.

## Region 7 — Workspace Actions
Exactly one authorized action:
- `Save Clinical Notes` — Primary action

No Record Procedure, Close Visit, Complete Treatment, Cancel Visit, treatment-plan mutation, Dental Chart mutation, billing, insurance, appointment, or queue action is authorized.

## Editable / read-only matrix
### Read-only
Patient, Patient ID, Visit ID, Visit Date, Visit Type, Chair, Visit State, Treatment Item, Procedure, Tooth, Surface, Treatment Status, Planned Treatment, Planned Procedure, Planned Tooth, Planned Surface, Plan Status.

### Editable
Presenting Concern, Clinical Findings, Assessment, Procedure Notes, Clinical Notes, Materials / Technique.

### Action
Save Clinical Notes is the sole authorized action.

## Read-only presentation
Read-only values must not use active editable styling. No dropdown chevrons, input-cursor affordance, editable border treatment, or edit controls are permitted for read-only fields.

Reuse existing approved read-only presentation patterns where available. Do not modify global components to create a new one.

## Prototype
Phase 1 has no cross-module navigation or automatic workflow transition. `Save Clinical Notes` has no prototype reaction unless separately authorized by a repository interaction specification.

## Ownership boundaries
Clinical Workspace owns current working clinical assessment and documentation only. Dental Chart owns odontogram state; Treatment Planning owns planned treatment; Performed Procedure owns finalized procedure records; Shared Visit owns visit lifecycle; Clinical Closure owns closure outcomes; Clinical Record History owns historical presentation.

## Exclusions
Insurance, billing, payments, claims, appointment scheduling, queue management, messaging, AI diagnosis, AI treatment recommendations, Dental Chart mutation, Treatment Planning mutation, procedure finalization, visit closure, and historical record editing.
