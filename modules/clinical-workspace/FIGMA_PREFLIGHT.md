# Clinical Workspace — Figma Preflight

## Result

**NOT READY — do not modify Figma.**

The preflight was completed read-first against the approved replacement architecture and field specification. No Figma write was performed.

## Scope

- Module: Clinical Workspace
- Change: replacement Phase 1 implementation under the approved replacement architecture
- Change type: architecture replacement implementation
- Figma file: SmileFlow Foundations v1.0
- File key: `4XiHoPFlljnne38HnjLgc6`
- Target page: `06 — Layouts` (`1:6`)
- Requested composition: `Clinical Workspace — Phase 1 — Canonical`
- User authorization in current task: preflight/inspection only; no implementation authorization

## Authority

- `SOURCE_OF_TRUTH.md`: current repository authority model
- `PROJECT_STATE.md`: replacement architecture approved; replacement implementation not implemented
- `modules/clinical-workspace/AGENTS.md`: implementation blocked until preflight passes and implementation is separately authorized
- `modules/clinical-workspace/ARCHITECTURE.md`: APPROVED — Phase 1 source of truth
- `modules/clinical-workspace/FIELD_SPECIFICATION.md`: APPROVED — Phase 1 source of truth
- `governance/ARCHITECTURE_EXCEPTIONS.md`: Clinical Workspace replacement exception APPROVED
- `governance/FROZEN_MODULES.md`: Clinical Workspace explicitly not frozen, but not automatically writable
- `DESIGN.md`: existing component-first and layout rules

## Gate results

### Gate 0 — Request definition
**PASS**

The requested operation was limited to a strict, read-first preflight. No implementation or cleanup was authorized.

### Gate 1 — Repository authority
**PASS**

The module exists and has an approved architecture and field specification. The current repository state explicitly identifies the previous Figma composition as historical/protected.

### Gate 2 — Change classification and locality
**PASS**

This is a module-local replacement implementation. It does not require changing global components, other modules, or ownership boundaries.

### Gate 3 — Architecture and field specification
**PASS for repository clarity; FAIL for current Figma implementation conformity**

The approved target requires exactly seven regions:

1. Workspace Header
2. Patient & Visit Context
3. Active Treatment
4. Clinical Assessment
5. Treatment Plan Context
6. Clinical Work & Documentation
7. Workspace Actions

The sole authorized action is `Save Clinical Notes`.

The approved field specification requires:

- read-only patient/visit context;
- read-only active treatment context;
- editable Presenting Concern, Clinical Findings, Assessment;
- read-only Treatment Plan Context;
- editable Procedure Notes, Clinical Notes, Materials / Technique;
- exactly one `Save Clinical Notes` primary action.

### Gate 4 — Freeze and exception protection
**PASS**

The replacement architecture exception is approved. The previous composition remains protected and must not be modified, deleted, renamed, duplicated, or repurposed.

### Gate 5 — Exact-name conflict
**PASS**

A read-only exact-name search on `06 — Layouts` found **no** existing node named `Clinical Workspace — Phase 1 — Canonical`.

The existing node `207:1291` is named `Clinical Workspace — Phase 1`, so it is not an exact-name conflict. It is nevertheless protected historical work and cannot be used as a modification target or shortcut.

### Gate 6 — Figma document access
**PASS**

The correct design file was readable. The `06 — Layouts` page exists and is accessible. Read-only inspection confirmed the expected page inventory.

No write was attempted.

### Gate 7 — Design-system dependency verification
**PASS**

Required approved shared components exist:

- `Input Field` component set: `40:111`
- `Button` component set: `35:209`

The existing protected Clinical Workspace contains genuine `Input Field` instances and a genuine `Button` instance, confirming that the required component families are available.

The existing Input Field convention supports the approved multiline implementation pattern without modifying the global component: approximately `840 × 64`, with text auto-resize `HEIGHT`.

### Gate 8 — Layout and implementation feasibility
**PASS with a replacement-build requirement**

The target specification requires a 920 px vertical Auto Layout composition with exactly seven top-level regions. Existing design-system conventions support the required resized Input Field instances and genuine Button instances.

However, the existing protected composition does not satisfy the replacement information model and therefore cannot be repurposed as the replacement.

### Gate 9 — Protected-boundary analysis
**PASS**

The following must remain untouched:

- `207:1291` — historical Clinical Workspace composition
- frozen modules and their canonical/legacy frames
- global component definitions and component sets
- variables, styles, tokens, typography foundations, and icons
- unrelated modules/pages/prototypes

No protected node was modified during preflight.

### Gate 10 — Execution plan
**BLOCKED pending correction of the implementation target**

The replacement should be implemented as a new composition named `Clinical Workspace — Phase 1 — Canonical` on `06 — Layouts`, using approved genuine components and a new seven-region hierarchy.

The previous `207:1291` frame must remain untouched.

### Gate 11 — Validation plan
**PASS**

Validation can cover exact composition name, seven-region hierarchy, all required fields, editable/read-only state, genuine component identity, Auto Layout, dimensions, ownership boundaries, sole action, and preservation of protected nodes.

### Gate 12 — Implementation authorization
**BLOCKED — AUTHORIZATION**

The current task authorizes preflight only. It does not authorize the subsequent Figma implementation.

### Gate 13 — Final go/no-go
**NOT READY**

## Primary blocker

The existing Figma composition at `207:1291` is materially inconsistent with the approved replacement architecture and must not be carried forward as a shortcut.

Observed current structure in `207:1291`:

1. Clinical Workspace Header
2. Visit Context
3. Active Treatment
4. Tooth / Treatment Scope
5. Clinical Documentation
6. Visit Status
7. Clinical Actions

Observed conflicts with the approved replacement:

- Missing **Clinical Assessment** region.
- Missing **Treatment Plan Context** region as a distinct read-only context region.
- `Tooth / Treatment Scope` is an old grouping and does not represent the required region model.
- `Clinical Documentation` does not contain the full approved working-documentation set: `Procedure Notes`, `Clinical Notes`, and `Materials / Technique`.
- The editable **Presenting Concern**, **Clinical Findings**, and **Assessment** fields are absent.
- `Visit Status` is an old presentation structure; the approved model places `Current Visit State` inside Patient & Visit Context and requires the treatment-plan context separately.
- The current action is **Clinical Closure**, which is explicitly prohibited by the replacement specification.
- The required **Save Clinical Notes** action is absent.

Therefore the old frame cannot be safely edited into the replacement architecture under the current protection rules.

## Additional Figma evidence

The `06 — Layouts` page currently contains a node named `Clinical Closure — Phase 1 — Canonical` (`220:1294`). This is Figma implementation evidence only and does not override the repository's current Clinical Closure state, which is `NEXT / draft / not implemented`. It was not modified or used as authority during this preflight.

## Protected historical component evidence

The previous Clinical Workspace frame contains:

- `207:1357` — genuine `Input Field` instance, `840 × 64`, text auto-resize `HEIGHT`.
- `207:1361` — genuine `Input Field` instance, `840 × 64`, text auto-resize `HEIGHT`.
- `207:1372` — genuine primary `Button` instance.

These are evidence that the approved component strategy is feasible, but they remain inside protected historical work and are not authorization to modify or repurpose that frame.

## No-write confirmation

No Figma nodes were created, deleted, renamed, moved, resized, restyled, reparented, or otherwise mutated during this preflight.

## Next authorized action

Do **not** modify Figma yet.

The next step is to resolve the `NOT READY` state by confirming/authorizing the replacement implementation plan. Once separately authorized, implementation should create the new canonical composition from the approved architecture and field specification while leaving `207:1291` untouched.
