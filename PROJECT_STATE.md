# SmileFlow — Current Project State

## Frozen / complete
1. Patient Management
2. Patient Registration
3. Dental Chart — Phase 1 — Canonical
4. Treatment Planning — Phase 1 — Canonical
5. Clinical Workspace — Phase 1
6. Clinical Closure — Phase 1 — Canonical

## Legacy frozen frames
- Dental Chart — Phase 1 — `127:1110`
- Treatment Planning — Phase 1 — `136:1124`

## Design-system dependencies
### Functional Select Field v1.2
- Select Option — `232:1439`
- Select Menu — `232:1443`
- Functional Select Field — `232:1863`
- Icon / Chevron Down — `229:133`

Status: IMPLEMENTED — FINAL.

## Clinical Closure
Architecture: APPROVED
Field Specification: APPROVED
Implementation: COMPLETE
Visual/UX Audit: PASS
P0 Findings: NONE
P1 Findings: NONE
P2 Findings: NONE
P3 Findings: NONE
Freeze: READY TO FREEZE

Clinical Closure canonical frame: `220:1294`

The Closure Outcome uses the Functional Select Field with exactly four
consumer-configured outcomes:
1. Completed as Planned
2. Completed with Modification
3. Not Completed
4. Treatment Continues

`Treatment Continues` remains a local closure outcome and does not imply
treatment completion, procedure completion, visit completion, history
creation, Dental Chart mutation, billing, insurance, or cross-module
navigation.

## Shared Visit
Architecture: APPROVED
Field Specification: APPROVED
Canonical Visit ID: `V-000128`
Canonical Visit Date: `August 11, 2026`
Implementation: NOT YET IMPLEMENTED
Visual/UX Audit: NOT PERFORMED
Freeze: NOT READY

Canonical demonstration data:
- Patient: `Maria Santos`
- Patient ID: `P-000128`
- Visit ID: `V-000128`
- Visit Date: `August 11, 2026`
- Visit Type: `General Consultation`
- Chair: `Chair 02`
- Current Visit State: `In Treatment`

Shared Visit owns the visit lifecycle and current visit state. It does
not own treatment status, clinical documentation, performed procedures,
closure outcomes, clinical history, billing, insurance, appointment
management, or queue management.

Approved lifecycle:
Scheduled → Checked In → Waiting → Called → In Treatment → Ready for Closure → Closed

The canonical Phase 1 action from `In Treatment` is `Ready for Closure`.
No cross-module navigation is authorized.

Repository source-of-truth files:
- `modules/shared-visit/ARCHITECTURE.md`
- `modules/shared-visit/FIELD_SPECIFICATION.md`

## Repository / Figma boundary
- Figma changes are complete for the approved Clinical Closure Phase 1 scope.
- Functional Select Field v1.2 remains a frozen design-system dependency.
- Shared Visit Figma implementation is not yet authorized beyond successful pre-flight.
- No Shared Visit Figma nodes have been created or modified.

## Next module
Shared Visit is the current implementation target.
Next step: run the strict Shared Visit Phase 1 Figma pre-flight, then implement only if pre-flight passes.
