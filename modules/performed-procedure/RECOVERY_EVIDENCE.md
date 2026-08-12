# Performed Procedure — Recovery Evidence Record

**Recovery status:** Figma-derived evidence only
**Historical source specification recovered:** No
**Figma node inspected:** `260:2`
**Figma node name:** `Performed Procedure — Phase 1 — Canonical`
**Page:** `06 — Layouts`
**Inspection mode:** Strict read-only
**Inspection date:** 2026-08-12

## Purpose

This record documents only facts directly observed in the frozen Figma implementation. It is not the recovered original architecture or field specification, and it must not be treated as proof of historical intent where the implementation does not explicitly establish it.

## Verified Node Structure

- Type: FRAME
- Size: 920 × 1568 px
- Layout: Vertical Auto Layout
- Direct child regions: 7

### Regions

1. `260:3` — Procedure Header — 872 × 129
2. `260:4` — Visit Context — 872 × 194
3. `260:5` — Planned Treatment Reference — 872 × 146
4. `260:6` — Actual Procedure — 872 × 275
5. `260:7` — Procedure Details — 872 × 256
6. `260:8` — Clinical Documentation — 872 × 302
7. `260:9` — Procedure Actions — 872 × 122

## Verified Data Boundaries

### Read-only contextual references

**Shared Visit reference:**
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State

The implementation describes these as read-only references from Shared Visit.

**Treatment Planning reference:**
- Planned Procedure
- Planned Tooth
- Planned Surface

The implementation describes these as read-only references from Treatment Planning.

### Editable actual-procedure information

The implementation visibly contains:
- Actual Procedure
- Actual Tooth
- Actual Surface
- Procedure Details
- Materials / Technique
- Procedure Notes
- Clinical Findings
- Procedure Status

The `Actual Procedure`, `Actual Tooth`, and `Actual Surface` controls use the existing Functional Select Field component.

The four long-form documentation fields use the existing Input Field component.

## Verified Components

- Functional Select Field main component: `236:1819`
- Input Field main component: `40:103`
- Primary Medium Button main component: `35:99`
- Chevron Down icon main component: `229:133`

## Verified Action

The Procedure Actions region contains a primary action named:

> `Record Procedure`

The implementation description states that this records the actual procedure and that no additional Phase 1 action is authorized.

The observed prototype reactions on the actual-procedure select fields open the select-menu destination `236:1830`. No other production-style cross-module action was observed during this inspection.

## Verified Clinical Boundary Evidence

The implementation explicitly distinguishes planned references from editable actual values. This provides direct Figma evidence that Performed Procedure is the editing surface for the actual procedure, while Planned Treatment Reference is read-only.

The implementation does **not** establish, by itself, every downstream persistence rule or database mutation. Those must not be invented from this evidence record.

## Not Verified / Must Not Be Inferred

The following were not established by this read-only inspection and require separate authoritative evidence before being specified:

- database schema
- persistence implementation
- exact lifecycle transition after `Record Procedure`
- automatic Dental Chart mutation
- automatic Clinical Record History mutation
- billing/insurance effects
- scheduling effects
- backend validation rules
- permission/role matrix
- historical specification wording

## Recovery Conclusion

**Evidence sufficiency: SUFFICIENT FOR DOCUMENTATION RECONSTRUCTION, NOT FOR CLAIMING HISTORICAL RECOVERY.**

A future `ARCHITECTURE.md` or `FIELD_SPECIFICATION.md` may be reconstructed from this evidence only if each reconstructed statement is clearly grounded in verified implementation evidence and assumptions are explicitly marked.

## Protected Figma Constraint

This recovery record was produced without modifying Figma. The canonical node `260:2` remains untouched.
