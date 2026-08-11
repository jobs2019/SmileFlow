CLINICAL CLOSURE PHASE 1 — STRICT CODEX IMPLEMENTATION PROMPT v1.0

IMPLEMENT THE APPROVED CLINICAL CLOSURE PHASE 1 SPECIFICATION IN FULL.

Do not simplify, split, reinterpret, partially implement, or invent any
part of the approved specification.

Do not proceed to Phase 2.

==================================================
1. PRE-FLIGHT — REQUIRED BEFORE ANY FIGMA WRITE
==================================================

Before making any Figma change:

1. Confirm Figma MCP is callable.
2. Confirm the Figma document is readable.
3. Confirm `06 — Layouts` is accessible.
4. Confirm Figma write capability.
5. Confirm sufficient execution capacity exists to create AND fully validate
   the complete seven-region composition in this turn.
6. Confirm the required existing Select Field component is available.
7. Confirm the required existing Primary Medium Button instance/component
   is available.
8. Confirm the required existing Secondary Medium Button instance/component
   is available.
9. Search `06 — Layouts` for an exact-name conflict:
   `Clinical Closure — Phase 1`

If any required pre-flight condition fails:

STOP.

Do not modify Figma.

Report:

`NOT READY — do not modify Figma.`

Include the exact blocker.

==================================================
2. EXACT-NAME CONFLICT RULE
==================================================

The canonical requested composition name is:

`Clinical Closure — Phase 1`

If a frame with that exact name already exists:

DO NOT:

- modify it
- delete it
- rename it
- duplicate it
- overwrite it

STOP and report:

- node ID
- page
- position
- dimensions
- top-level children
- classification
- whether it appears legacy/frozen/canonical

Do not create a duplicate unless an explicit naming exception is authorized.

==================================================
3. FROZEN MODULE PRESERVATION
==================================================

Treat all previously completed/frozen modules as READ-ONLY.

Do not modify:

- Patient Management
- Patient Registration
- Dental Chart — Phase 1 — Canonical
- Legacy Dental Chart `127:1110`
- Treatment Planning — Phase 1 — Canonical
- Legacy Treatment Planning `136:1124`
- Clinical Workspace — Phase 1

Also preserve all other frozen modules and workflows.

Any modification to a frozen module is unauthorized.

==================================================
4. DESIGN-SYSTEM PRESERVATION
==================================================

Do not modify:

- component definitions
- component sets
- variants
- variables
- styles
- tokens
- typography foundations
- icons

Reuse existing components.

When the specification requires a component instance, the resulting
layer MUST be a genuine `INSTANCE`.

Never simulate an existing component using local text or frames.

If a required component is unavailable or incompatible:

STOP.

Do not substitute another component.

Report the exact field/action that cannot be implemented.

==================================================
5. CANONICAL COMPOSITION
==================================================

Create exactly one composition:

`Clinical Closure — Phase 1`

on:

`06 — Layouts`

Use:

- vertical Auto Layout
- approximately 920 px desktop width
- contained content
- no clipping
- no horizontal overflow
- no parent overflow

The composition MUST contain exactly seven top-level regions in this
exact order:

1. Clinical Closure Header
2. Visit Context
3. Active Treatment Context
4. Closure Outcome
5. Closure Context / Summary
6. Downstream Handoff
7. Closure Actions

Do not add an eighth top-level region.

==================================================
6. CANONICAL DEMONSTRATION DATA
==================================================

Use exactly these approved demonstration values.

Patient:

Maria Santos

Patient ID:

P-000128

Visit:

General Consultation

Chair:

Chair 02

Visit Status:

In Treatment

Treatment:

Composite Restoration

Tooth / Site:

46

Surface:

Occlusal

Treatment Status:

In Progress

Closure Outcome:

Completed as Planned

Do not invent alternative values.

==================================================
7. REGION 1 — CLINICAL CLOSURE HEADER
==================================================

Create:

Clinical Closure Header

Content:

`Clinical Closure`

`Maria Santos`

`P-000128`

All header content is READ-ONLY.

Patient identity should be visually prominent.

Patient ID is secondary metadata.

Do not add:

- appointment information
- billing
- insurance
- queue information
- closure outcomes
- treatment-editing controls

==================================================
8. REGION 2 — VISIT CONTEXT
==================================================

Create:

Visit Context

Include:

Visit Type
`General Consultation`

Chair
`Chair 02`

Visit Status
`In Treatment`

All are READ-ONLY.

`In Treatment` represents the current visit state.

Do not represent it as the closure outcome.

Do not make these fields editable.

==================================================
9. REGION 3 — ACTIVE TREATMENT CONTEXT
==================================================

Create:

Active Treatment Context

Include:

Treatment
`Composite Restoration`

Tooth / Site
`46`

Surface
`Occlusal`

Treatment Status
`In Progress`

All are READ-ONLY.

This is reference context only.

DO NOT provide controls for:

- editing treatment
- completing treatment
- deleting treatment
- changing tooth
- changing surface
- changing treatment status

Treatment Planning remains the owner of treatment lifecycle.

==================================================
10. REGION 4 — CLOSURE OUTCOME
==================================================

Create:

Closure Outcome

This is the PRIMARY EDITABLE REGION.

Field:

`Closure Outcome`

The field MUST be a genuine existing:

`Select Field`

INSTANCE.

Do not use local text.

Do not simulate the Select Field.

Do not create a new component.

Approved options, exactly:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

Do not add any other options.

Initial demonstration value:

`Completed as Planned`

The selected value must be visible.

IMPORTANT:

Closure Outcome is owned by Clinical Closure.

It is NOT:

- Treatment Status
- Treatment Completion
- Visit Completion

Do not rename it.

==================================================
11. REGION 5 — CLOSURE CONTEXT / SUMMARY
==================================================

Create:

Closure Context / Summary

This region is READ-ONLY.

Display:

Closure Outcome
`Completed as Planned`

Current Visit
`In Treatment`

Treatment
`Composite Restoration`

Tooth / Surface
`46 · Occlusal`

This region exists to let the clinician visually confirm the closure
context.

Do NOT create a second editable Closure Outcome field.

There must be exactly ONE editable Closure Outcome control in the entire
composition.

==================================================
12. REGION 6 — DOWNSTREAM HANDOFF
==================================================

Create:

Downstream Handoff

Heading:

`Next Step`

Read-only informational content:

`Continue to the appropriate downstream clinical workflow after closure.`

This is informational only.

DO NOT create prototype navigation from this region.

DO NOT automatically navigate to:

- Performed Procedure
- Clinical Record History
- Treatment Planning
- Dental Chart
- Shared Visit
- Patient Management

The exact downstream transition has NOT been authorized for Phase 1.

Do not invent one.

==================================================
13. REGION 7 — CLOSURE ACTIONS
==================================================

Create:

Closure Actions

Exactly two actions:

Primary:

`Close Visit`

Secondary:

`Cancel`

Both MUST be genuine existing Button instances.

--------------------------------------------------
Close Visit
--------------------------------------------------

Required:

- INSTANCE
- existing Button
- Type = Primary
- Size = Medium
- State = Default

--------------------------------------------------
Cancel
--------------------------------------------------

Required:

- INSTANCE
- existing Button
- Type = Secondary
- Size = Medium
- State = Default

Do not create custom buttons.

Do not use local text as buttons.

Do not add any other action.

==================================================
14. ACTION SEMANTICS
==================================================

`Close Visit` is the primary Clinical Closure action.

However, Phase 1 MUST NOT invent downstream mutations.

Do NOT make `Close Visit` automatically:

- complete the treatment
- create a performed procedure
- modify Dental Chart
- create Clinical Record History
- modify billing
- modify insurance
- schedule another appointment
- modify Treatment Planning

Do not add unauthorized prototype reactions.

`Cancel` must not introduce an unsupported workflow.

==================================================
15. EDITABLE / READ-ONLY MATRIX
==================================================

READ-ONLY:

- Patient Name
- Patient ID
- Clinical Closure
- Visit Type
- Chair
- Visit Status
- Treatment
- Tooth / Site
- Surface
- Treatment Status
- Closure Summary
- Next Step

EDITABLE:

- Closure Outcome

ACTION:

- Close Visit
- Cancel

There must be exactly:

1 genuine Select Field instance
2 genuine Button instances

==================================================
16. CLINICAL OWNERSHIP BOUNDARIES
==================================================

Clinical Closure owns:

- closure outcome classification
- closure decision
- closure action

Clinical Closure may reference:

- patient identity
- visit context
- treatment context
- current documentation/context

Clinical Closure does NOT own:

- patient registration
- Dental Chart state
- Treatment Planning
- Shared Visit lifecycle
- Clinical Workspace documentation
- Performed Procedure
- Clinical Record History
- billing
- insurance

==================================================
17. DENTAL CHART BOUNDARY
==================================================

Do not add:

- tooth editing
- condition editing
- surface editing
- tooth status editing
- odontogram controls

Tooth 46 and Occlusal are READ-ONLY treatment references.

==================================================
18. TREATMENT PLANNING BOUNDARY
==================================================

Do not add:

- add treatment
- edit treatment
- delete treatment
- complete treatment
- lifecycle controls

Treatment remains:

`In Progress`

Do not automatically change it based on the closure action.

==================================================
19. CLINICAL WORKSPACE BOUNDARY
==================================================

Do not duplicate:

- Clinical Notes
- Procedure Notes
- clinical documentation editing
- active treatment documentation

Clinical Workspace owns current clinical work.

Clinical Closure owns closure classification.

==================================================
20. SHARED VISIT BOUNDARY
==================================================

Do not add:

- appointment controls
- queue controls
- check-in
- waiting
- called
- no-show
- scheduling controls

The current visit reference is:

`In Treatment`

==================================================
21. PERFORMED PROCEDURE BOUNDARY
==================================================

Do not add:

- actual procedure entry
- actual surface
- actual outcome
- procedure finalization
- procedure documentation

Performed Procedure remains a downstream owned module.

==================================================
22. CLINICAL RECORD HISTORY BOUNDARY
==================================================

Do not add:

- historical timeline
- procedure history
- visit chronology
- historical editing

Clinical Closure is a CURRENT workflow boundary.

==================================================
23. MULTI-VISIT RULE
==================================================

The closure outcome:

`Treatment Continues`

MUST remain available.

This preserves multi-visit treatment.

Do not imply:

`Close Visit = Treatment Completed`

Do not imply:

`Visit Closed = Treatment Completed`

Treatment Planning retains its own lifecycle.

==================================================
24. PROTOTYPE RULE
==================================================

Phase 1 may represent the closure decision locally.

Do not create unauthorized cross-module reactions.

No automatic navigation is authorized in this implementation unless
explicitly defined above.

If a prototype reaction is inherited from a cloned component instance:

remove ONLY that inherited reaction from the newly created instance if
necessary to preserve the approved Phase 1 boundary.

Do not modify the source component definition.

==================================================
25. IMPLEMENTATION METHOD
==================================================

Prefer cloning/reusing existing approved component instances.

For the Select Field:

- obtain a valid existing Select Field INSTANCE
- clone it
- place it in Closure Outcome
- configure the instance value to `Completed as Planned`
- preserve main component identity

For Buttons:

- obtain valid existing Button instances
- clone them
- configure one as Primary Medium Default with `Close Visit`
- configure one as Secondary Medium Default with `Cancel`
- preserve main component identity

Do not traverse descendant APIs on TEXT nodes.

Only inspect/configure descendants after confirming the node is an
appropriate INSTANCE/container.

==================================================
26. STRUCTURAL QA
==================================================

After implementation, inspect the ACTUAL Figma document.

Verify:

- exactly one `Clinical Closure — Phase 1`
- correct page: `06 — Layouts`
- exactly seven top-level regions
- exact region order
- vertical Auto Layout
- no overlap
- no clipping
- no horizontal overflow
- no parent overflow
- no duplicate Clinical Closure composition

==================================================
27. COMPONENT INSTANCE QA
==================================================

Inspect each target individually.

Closure Outcome MUST report:

`INSTANCE`
`Main Component: Select Field`
`Value: Completed as Planned`

Close Visit MUST report:

`INSTANCE`
`Main Component: Button`
`Type: Primary`
`Size: Medium`
`State: Default`

Cancel MUST report:

`INSTANCE`
`Main Component: Button`
`Type: Secondary`
`Size: Medium`
`State: Default`

If any target is not a genuine INSTANCE:

FAIL.

Do not silently leave it as text/frame content.

==================================================
28. CONTENT QA
==================================================

Verify exact canonical values:

Maria Santos
P-000128
Clinical Closure
General Consultation
Chair 02
In Treatment
Composite Restoration
46
Occlusal
In Progress
Completed as Planned
Next Step
Continue to the appropriate downstream clinical workflow after closure.
Close Visit
Cancel

No unauthorized content.

==================================================
29. OWNERSHIP QA
==================================================

Verify that Clinical Closure does not contain:

- Dental Chart ownership
- Treatment Planning editing
- Shared Visit controls
- Clinical Workspace documentation
- Performed Procedure editing
- Clinical Record History
- billing
- insurance

==================================================
30. FROZEN MODULE QA
==================================================

Verify that no frozen module changed.

Explicitly inspect/preserve:

- Patient Management
- Patient Registration
- Dental Chart — Phase 1 — Canonical
- Legacy Dental Chart `127:1110`
- Treatment Planning — Phase 1 — Canonical
- Legacy Treatment Planning `136:1124`
- Clinical Workspace — Phase 1

Report any unexpected modification.

==================================================
31. DESIGN-SYSTEM QA
==================================================

Verify:

- no component definition changes
- no component-set changes
- no variant changes
- no variable changes
- no style changes
- no token changes
- no typography changes
- no icon changes

==================================================
32. PROTOTYPE QA
==================================================

Inspect the final Clinical Closure composition for reactions.

There must be no unauthorized cross-module navigation.

Specifically verify no unauthorized transition to:

- Dental Chart
- Treatment Planning
- Clinical Workspace
- Shared Visit
- Performed Procedure
- Clinical Record History
- Patient Management

==================================================
33. ERROR HANDLING
==================================================

If implementation fails:

1. Determine whether Figma actually changed.
2. Do not silently continue.
3. Do not leave partial implementation.
4. Report the exact error.
5. Report whether any Figma changes occurred.

If an individual required component cannot be instantiated:

STOP.

Report that exact field/action.

==================================================
34. FINAL REPORT
==================================================

Return:

CLINICAL CLOSURE PHASE 1 — IMPLEMENTATION REPORT v1.0

1. Composition Created
2. Seven-Region Architecture
3. Clinical Closure Header
4. Visit Context
5. Active Treatment Context
6. Closure Outcome
7. Closure Context / Summary
8. Downstream Handoff
9. Closure Actions
10. Editable / Read-only Matrix
11. Component Instance Verification
12. Canonical Demonstration Data
13. Treatment / Visit State Separation
14. Multi-Visit Preservation
15. Dental Chart Boundary
16. Treatment Planning Boundary
17. Clinical Workspace Boundary
18. Shared Visit Boundary
19. Performed Procedure Boundary
20. Clinical Record History Boundary
21. Prototype Navigation
22. Invalid Transition Audit
23. Frozen Module Preservation
24. Design-System Preservation
25. Structural QA
26. Content QA
27. Unauthorized Additions
28. Script / Execution Errors
29. Remaining Issues
30. Final Verdict
31. Exact Change Boundary

For Component Instance Verification, explicitly list:

- Closure Outcome — INSTANCE — Select Field — Completed as Planned
- Close Visit — INSTANCE — Button — Primary — Medium — Default
- Cancel — INSTANCE — Button — Secondary — Medium — Default

==================================================
35. FINAL VERDICT RULE
==================================================

The implementation may only be marked:

`PASS`

if ALL required structural, component, content, ownership, prototype,
frozen-module, and design-system checks pass.

Otherwise:

`FAIL`

Do not claim PASS based on intended structure.

==================================================
36. PHASE CONTROL
==================================================

This is:

`Clinical Closure — Phase 1`

Do not:

- implement Phase 2
- implement Performed Procedure
- implement Clinical Record History
- modify other modules
- add future workflow behavior

STOP after the implementation report.

==================================================
37. ABSOLUTE CHANGE BOUNDARY
==================================================

The only authorized Figma change in this operation is:

Creation of:

`Clinical Closure — Phase 1`

and its seven local regions, approved content, one Select Field instance,
two Button instances, and only explicitly approved local instance
configuration.

Nothing else may be modified.

Do not modify existing modules.

Do not modify existing component definitions.

Do not modify the design system.

Do not modify frozen frames.

Do not proceed to Phase 2.