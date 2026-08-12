# Clinical Closure v1.3 — Strict Read-First Figma Preflight

## Status

**READ-ONLY PREFLIGHT — CONDITIONAL PASS — NO FIGMA WRITE AUTHORIZED**

## 1. Target

- Figma file: `4XiHoPFlljnne38HnjLgc6`
- Canonical node: `220:1294`
- Name: `Clinical Closure — Phase 1 — Canonical`
- Current size: `920 × 1461`
- Layout: vertical Auto Layout
- Top-level regions: exactly 7

## 2. Protected baseline

The existing v1.2 canonical frame remains the protected implementation baseline during this preflight.

No Figma node was modified during this inspection.

## 3. Existing seven-region architecture

Verified in the current canonical frame:

1. Clinical Closure Header — `220:1295`
2. Visit Context — `220:1296`
3. Active Treatment Context — `220:1297`
4. Closure Outcome — `220:1298`
5. Closure Context / Summary — `220:1299`
6. Downstream Handoff — `220:1300`
7. Closure Actions — `220:1301`

The v1.3 specification can fit within these seven regions. No new top-level region is required by the current architecture proposal.

## 4. Existing components verified

### Functional Select Field

- Shared component main frame: `232:1863`
- Existing filled/open states include four value states.
- Current canonical instance: `220:1325`
- Current canonical instance uses the genuine Functional Select Field.

Component description confirms:

- reusable single-select control
- local closed/open, selection, and dismissal behavior
- consumer owns options and selected value

This is compatible with the v1.3 Closure Outcome contract.

### Input Field

- Existing main component: `40:103`
- Filled state observed.

This provides an existing field primitive for bounded single-line editable fields.

### Primary / Secondary Buttons

The current canonical Closure Actions region contains genuine button instances:

- Save action instance: `221:1299`
- Cancel instance: `221:1301`

The current Save instance still displays `Save Closure Outcome` and therefore requires bounded consumer-level text reconciliation to `Save Closure Record` for v1.3.

No shared button component modification is authorized.

## 5. Current canonical content vs v1.3 requirements

### Already present and compatible

- Patient context
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State = `Ready for Closure`
- Treatment Item
- Procedure reference
- Tooth / Site
- Planned Surface / Scope
- Treatment Status
- Closure Outcome
- Selected Outcome confirmation
- Treatment Context
- Visit Context
- Shared Visit handoff boundary
- No automatic transition
- Cancel action

### Missing from current canonical frame

The v1.3 specification requires additional closure-record fields that are not currently represented in the canonical frame:

- Clinical Closure Summary
- Provider
- Closure Date / Time
- Actual Work / Procedure when applicable
- Actual Tooth / Site when applicable
- Actual Surface / Scope when applicable
- Patient Tolerance when applicable
- Complications / Exceptions when applicable
- Modification Classification when applicable
- Modification Reason when applicable
- Not Completed Reason when applicable
- Next Step / Follow-up Context when applicable
- Completed Today / Current Work Summary for Treatment Continues
- Remaining Treatment / Continuation Context for Treatment Continues
- Next Planned Procedure / Next Step when known

These must be added within the existing seven-region architecture if implementation is authorized.

## 6. Conditional-field feasibility

The seven-region architecture provides sufficient placement capacity conceptually, especially in:

- Active Treatment Context
- Closure Outcome
- Closure Context / Summary
- Closure Actions

However, the existing canonical frame is only `1461px` tall and currently uses compact read-only fields. v1.3 will require additional vertical content.

The implementation must therefore preserve vertical Auto Layout rather than forcing fixed-height compression or overlapping content.

## 7. Multiline summary component finding

The inspected existing Input Field component is a 240 × 40 filled single-line field.

The current preflight does **not** establish an approved existing multiline text component for `Clinical Closure Summary`.

Therefore:

**BLOCKER / DESIGN-SYSTEM CHECK REQUIRED:** before implementation, confirm whether an approved existing multiline/text-area component exists elsewhere in the SmileFlow design system.

If no approved multiline component exists, stop implementation at component preflight rather than creating an ad-hoc shared component or changing the global design system inside Clinical Closure.

## 8. Vocabulary isolation

Closure Outcome remains consumer-owned.

The exact four values remain:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

No shared-menu vocabulary change is required.

Conditional vocabularies such as Modification Classification and Not Completed Reason are also consumer-owned and must not be inserted into shared component definitions.

## 9. Ownership checks

The current Figma structure supports the repository ownership boundaries:

- Shared Visit context is read-only.
- Treatment Planning context is read-only.
- Clinical Closure owns the outcome and closure record.
- Performed Procedure remains a separate authoritative actual-procedure surface.
- Clinical Record History remains read-only.

No Figma evidence requires changing these boundaries.

## 10. Save action reconciliation

v1.3 has adopted Option B:

`Save Closure Record`

The current canonical instance still reads:

`Save Closure Outcome`

This is a bounded instance-level text change, not a shared button component change.

The current action must remain a save-record action and must not be changed into `Close Visit`.

## 11. Figma implementation boundary

If implementation is authorized, the change set should be limited to:

1. Extend existing seven regions using vertical Auto Layout.
2. Add approved existing field components for v1.3 fields.
3. Add conditional outcome-specific fields within existing regions.
4. Preserve the genuine Functional Select Field instance.
5. Change the consumer-level Save label to `Save Closure Record`.
6. Preserve Cancel.
7. Preserve `Shared Visit — Close Lifecycle` and `No automatic transition`.
8. Do not modify global components, variants, variables, styles, tokens, or shared menu vocabulary.
9. Do not add `Close Visit`.
10. Do not modify protected unrelated nodes.

## 12. Preflight decision

### Architecture fit

**PASS** — seven-region architecture can contain v1.3.

### Existing component reuse

**PASS with blocker** — Functional Select Field, Input Field, and buttons exist; multiline summary component still requires verification.

### Ownership boundaries

**PASS**.

### Vocabulary isolation

**PASS**.

### Save action terminology

**PASS with bounded instance update required**.

### Layout feasibility

**PASS with Auto Layout expansion required**.

### Overall

**CONDITIONAL PASS — DO NOT IMPLEMENT YET.**

The only identified implementation blocker is confirmation of an approved existing multiline text component for `Clinical Closure Summary`.

## 13. Required next gate

Before Figma implementation:

1. Verify the approved SmileFlow multiline text component, if one exists.
2. If available, map `Clinical Closure Summary` to that genuine component.
3. If unavailable, stop and resolve the design-system component gap separately.
4. After the component check passes, obtain explicit implementation authorization.
5. Implement only the bounded v1.3 changes above.

## 14. No-write confirmation

This preflight was read-only.

The canonical node `220:1294` and shared components inspected during this preflight were not modified.
