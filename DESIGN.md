# SmileFlow — Design System & Figma Working Rules

## Design philosophy
SmileFlow is clinical software, not a generic dashboard. Prioritize clinical clarity, patient/context recognition, strong hierarchy, safe ownership boundaries, fast scanning, reusable components, responsive containment, and minimal unnecessary interaction.

## Component-first
Reuse existing components before creating anything new. Required components must be genuine INSTANCE nodes. Never recreate an existing component visually with local text and frames.

## Input Field
Existing component set: `Input Field` (component set `40:111`).

Known variants:
- `=Input Field, State=Default`
- `=Input Field, State=Focus`
- `=Input Field, State=Filled`
- `=Input Field, State=Error`
- `=Input Field, State=Disabled`
- `=Input Field, State=Read-only`

The definitions are single-line by default.

Approved resized-instance convention: genuine `Input Field` instances at approximately 840 × 64 using text auto-resize `HEIGHT`.

Known reference instances:
- Address — `180:51`
- Current Medications — `180:1873`
- Medical Conditions — `180:1877`
- Special Precautions — `180:1885`
- Important Clinical Notes — `180:1889`

Do not modify the global Input Field component to create multiline behavior unless separately authorized.

## Select Field
Use genuine existing Select Field instances for approved selection fields. Never simulate them with local text/frames.

## Button
Use genuine existing Button instances. Do not create a new Button component during module implementation. Preserve existing type/size/state conventions.

## Typography, color, tokens
Use existing conventions. Do not create or modify global typography, styles, colors, variables, or tokens as a module side effect.

## Layout
Preferred module root: vertical Auto Layout, approximately 920 px width where specified, clear section rhythm, no horizontal overflow, clipping, or parent overflow.

## Editable vs read-only
Editable fields should use established field affordances. Read-only summaries should read as summaries/references. Do not rely only on literal labels.

## Status semantics
`In Progress` = Treatment Planning treatment state.
`In Treatment` = Shared Visit/current clinical visit state.
Do not merge them.

## Clinical ownership
Patient Management owns patient-level identity/demographics. Patient Registration owns registration. Dental Chart owns current dentition/tooth state. Treatment Planning owns planned treatment. Shared Visit owns visit lifecycle. Clinical Workspace owns active clinical work/current documentation. Clinical Closure owns outcome classification. Performed Procedure owns finalized actual procedure. Clinical Record History owns historical chronology.

## Clinical workflow
Scheduled → Confirmed → Checked In → Waiting → Called → In Treatment → Clinical Closure → downstream procedure/history as appropriate.

## Treatment lifecycle
Planned → Scheduled → In Progress → Completed.

Do not equate visit completion with treatment completion.

## External references
Figma SDS, Figma MCP guidance, DHIS2, CMS Design System, Primer, and dental software repositories may inform research, but SmileFlow specifications remain authoritative.
