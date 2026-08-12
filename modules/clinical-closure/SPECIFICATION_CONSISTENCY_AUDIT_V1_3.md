# Clinical Closure v1.3 — Specification Consistency Audit

## Status

**READ-ONLY AUDIT — CONDITIONAL PASS / RECONCILIATION REQUIRED**

No Figma changes were made.

No v1.3 specification files were modified by this audit.

## Scope

Compared:

- `ARCHITECTURE_V1_3_PROPOSAL.md`
- `FIELD_SPECIFICATION_V1_3.md`
- approved v1.2 baseline boundaries

Focus:

- ownership
- lifecycle
- field authority
- required/optional semantics
- Performed Procedure boundary
- conditional outcome behavior
- seven-region architecture
- save/cancel behavior
- provider/timestamp attribution

## 1. Overall result

**CONDITIONAL PASS — two specification-level contradictions must be resolved before v1.3 approval.**

The architecture and field specification agree on the major product boundary and lifecycle, but the requiredness of actual-work data is inconsistent.

## 2. Lifecycle consistency — PASS

Both documents preserve:

```text
Shared Visit
In Treatment
    ↓
Ready for Closure
    ↓
Clinical Closure
    ↓
Closure Record
    ↓
Shared Visit remains lifecycle owner
    ↓
Closed through Shared Visit workflow
```

Both prohibit automatic Visit State mutation from Clinical Closure.

## 3. Closure Outcome ownership — PASS

Both documents identify Closure Outcome as Clinical Closure-owned.

The four canonical values are consistent:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

No ownership conflict found.

## 4. Seven-region architecture — PASS

Both documents preserve exactly seven top-level regions:

1. Clinical Closure Header
2. Visit Context
3. Active Treatment Context
4. Closure Outcome
5. Closure Context / Summary
6. Downstream Handoff
7. Closure Actions

Conditional fields remain inside existing regions.

## 5. Performed Procedure boundary — PASS WITH CLARIFICATION NEEDED

Both documents explicitly prohibit Clinical Closure from becoming a second Performed Procedure editor.

Both support reference-population from authoritative Performed Procedure data.

However, the field specification uses the label `Actual Work / Procedure`, which could be interpreted as a duplicate procedure record if implemented without the stated duplication rule.

Required clarification before implementation:

- `Actual Work / Procedure` must be explicitly defined as a concise closure-context field or reference to authoritative Performed Procedure data.
- It must not expose complete procedure editing fields such as the full Performed Procedure surface/outcome/editor model.

This is not an ownership contradiction, but it should be made explicit in the approved field specification.

## 6. CONTRADICTION #1 — Core actual-work requiredness

### Architecture says

The core closure record requires:

- Closure Outcome
- Clinical Closure Summary
- Provider
- Closure Date / Time

Actual Procedure / Work Performed is listed under information that may be captured **where clinically relevant**.

### Field specification says

Region 3 defines `Actual Work / Procedure` as:

**Required: Yes for useful closure record — All outcomes**

And the `Completed as Planned` and `Completed with Modification` outcome sections require it.

### Result

**CONFLICT.**

The documents need one authoritative rule.

### Recommended resolution

Make `Actual Work / Procedure` required for closure outcomes where clinical work occurred, but not universally required for every possible closure.

Suggested rule:

> `Actual Work / Procedure` is required when any clinical work was performed during the visit and should be reference-populated from Performed Procedure when authoritative data exists. It is not required when no clinical work occurred and the closure is solely a non-completion/follow-up record.

This preserves clinical usefulness without forcing irrelevant fields.

## 7. CONTRADICTION #2 — Not Completed actual-work requirement

### Field specification section 7.2 says

`Actual Work / Procedure` is required for **all outcomes**.

### Field specification section 8.2 says

For `Not Completed`, `Actual Work / Procedure` is optional **when partial work occurred**.

### Result

**INTERNAL FIELD-SPECIFICATION CONTRADICTION.**

### Recommended resolution

For `Not Completed`:

- no actual work occurred → Actual Work / Procedure not required
- partial work occurred → Actual Work / Procedure should be captured/reference-populated

This is the same rule recommended in Contradiction #1.

## 8. Completed with Modification — PASS

The architecture and field specification agree that modification requires:

- what changed / modification classification
- modification reason
- closure summary

The modification must not silently mutate Treatment Planning.

## 9. Treatment Continues — PASS

Both documents preserve the multi-visit model.

The field specification correctly adds:

- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Next Planned Procedure / Next Step when known

No conflict with Treatment Planning ownership was found.

## 10. Not Completed — PASS AFTER REQUIREDNESS RECONCILIATION

Both documents agree that `Not Completed` requires a reason and may require follow-up context.

Only the actual-work requiredness conflict identified above needs resolution.

## 11. Clinical Closure Summary — PASS

Both documents agree that the summary:

- belongs to Clinical Closure
- is human-readable
- may be generated from structured values
- must be reviewable/editable by the provider
- must not become general Clinical Workspace documentation

The field specification's provider-review rule is compatible with the architecture.

## 12. Provider and timestamp — PASS

Architecture requires provider attribution and closure timestamp.

Field specification defines Provider and Closure Date / Time as system-derived/read-only in the normal workflow.

No contradiction found.

## 13. Save behavior — PASS

Both documents agree that saving:

- persists the closure record
- validates required conditional fields
- does not automatically mutate Shared Visit
- does not automatically create a Performed Procedure or history record

The field specification's renamed action `Save Closure Record` is compatible with the v1.3 architecture proposal.

## 14. Cancel behavior — PASS

Both documents agree that Cancel abandons unsaved changes without cross-module mutation.

## 15. Design-system boundary — PASS

Both preserve:

- genuine existing SmileFlow components
- consumer-owned vocabulary
- no global component/variant/token/style changes
- preflight blocker if an existing component cannot represent the requirement

## 16. v1.2 baseline protection — PASS

Both documents preserve v1.2 as the protected baseline and prohibit Figma modification until v1.3 approval and preflight.

## 17. Approval recommendation

**Do not approve v1.3 yet.**

First reconcile the two actual-work requiredness statements into one rule.

Recommended canonical rule:

```text
Actual Work / Procedure

If clinical work occurred:
    required or reference-populated

If no clinical work occurred:
    not required

If authoritative Performed Procedure data exists:
    reference existing data

Never:
    duplicate the full Performed Procedure editor
```

Then update both v1.3 architecture and field specification so the same rule appears in both.

## 18. Next gate

After reconciliation:

1. Re-run this specification consistency audit.
2. Approve v1.3 Architecture + Field Specification.
3. Run the read-only Cross-Module Dependency Audit against v1.3.
4. Run strict read-first Clinical Closure v1.3 Figma Preflight.
5. Only then authorize Figma implementation.

## Final Result

**SPECIFICATION CONSISTENCY: CONDITIONAL PASS**

The architecture is fundamentally sound and the major ownership boundaries are coherent. Two requiredness contradictions around `Actual Work / Procedure` must be reconciled before v1.3 is promoted from proposal to approved specification.
