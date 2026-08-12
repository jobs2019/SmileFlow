# Clinical Closure v1.3 — Specification Reconciliation Decision

## Status

**RECONCILED — PROPOSED / NOT APPROVED — NO FIGMA WRITE AUTHORIZED**

This decision record resolves the consistency findings between:

- `ARCHITECTURE_V1_3_PROPOSAL.md`
- `FIELD_SPECIFICATION_V1_3.md`

The v1.2 canonical Figma implementation remains protected.

## 1. Resolved rule: Actual Work / Procedure

The authoritative rule is:

> Actual Work / Procedure is required only when clinical work was actually performed or when authoritative performed-procedure data exists and is being referenced. It is not required when no clinical work occurred.

This rule applies across the v1.3 architecture and field specification.

## 2. Outcome-specific requirement

### Completed as Planned

`Actual Work / Procedure` is required or reference-populated.

### Completed with Modification

`Actual Work / Procedure` is required or reference-populated.

The record must also capture:
- Modification Classification
- Modification Reason

### Not Completed

`Actual Work / Procedure` is **not required when no clinical work occurred**.

If partial clinical work occurred, `Actual Work / Procedure` becomes required or reference-populated.

`Not Completed Reason` remains required.

`Next Step / Follow-up Context` is required when follow-up is needed.

### Treatment Continues

`Completed Today / Current Work Summary` is required.

Where the work is represented by an authoritative Performed Procedure record, Clinical Closure should reference that record rather than duplicate the complete procedure entry.

`Remaining Treatment / Continuation Context` is required.

## 3. Required change to wording

The field specification's generic Region 3 table must be interpreted as:

| Field | Requirement |
|---|---|
| Actual Work / Procedure | Required when work occurred; otherwise not required |
| Actual Tooth / Site | Required when clinically relevant to the recorded work |
| Actual Surface / Scope | Required when clinically relevant to the recorded work |

This replaces the ambiguous phrase `Yes for useful closure record | All outcomes`.

## 4. Duplication boundary

The reconciliation does not authorize Clinical Closure to duplicate the complete Performed Procedure editor.

When authoritative Performed Procedure data exists:

```text
Performed Procedure
       ↓
Clinical Closure
reference / summarize
```

Clinical Closure may retain the concise actual-work information necessary to explain the closure decision, but Performed Procedure remains authoritative for the complete procedure record.

## 5. Why this rule is authoritative

The rule resolves both identified inconsistencies:

1. It aligns the field specification with the architecture's phrase **where clinically relevant**.
2. It removes the contradiction in which `Actual Work / Procedure` was globally marked required but later marked optional for `Not Completed`.

It also avoids forcing a meaningless procedure entry when a patient declined treatment before any clinical work occurred.

## 6. No other architecture changes

The following remain unchanged:

- Option A lifecycle
- Shared Visit ownership of Visit State
- Clinical Closure ownership of Closure Outcome
- four Closure Outcome values
- seven-region architecture
- Clinical Closure Summary
- Provider attribution
- Closure Date / Time
- conditional outcome fields
- Performed Procedure boundary
- Save/Cancel semantics
- no automatic Visit State mutation
- no automatic `Close Visit`
- no Figma modification authorization

## 7. Approval state

This reconciliation resolves the documentation contradiction but does **not** itself approve v1.3 for implementation.

Required next gates remain:

1. Re-run the read-only specification consistency audit against this reconciliation decision.
2. Approve/reject the reconciled v1.3 architecture and field specification.
3. Run the v1.3 cross-module dependency audit.
4. Run strict read-first Figma preflight.
5. Obtain explicit implementation authorization.

## 8. Baseline protection

Clinical Closure v1.2 remains the protected implementation baseline until v1.3 passes its approval and implementation gates.
