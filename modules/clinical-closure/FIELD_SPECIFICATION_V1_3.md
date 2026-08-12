# Clinical Closure — Precise Field-Level Specification v1.3

## Status

**PROPOSED — NOT APPROVED — NO FIGMA WRITE AUTHORIZED**

This specification translates the proposed Clinical Closure v1.3 architecture into exact field-level behavior. It preserves the approved Option A lifecycle and the v1.2 canonical implementation as the protected baseline.

No Figma modification, component modification, production runtime behavior, database implementation, or automatic cross-module mutation is authorized by this document alone.

---

## 1. Purpose

Clinical Closure v1.3 upgrades the v1.2 outcome selector into a useful structured closure record.

The module must answer:

1. What was the closure outcome?
2. What clinical work was completed or not completed for this visit?
3. What changed from the plan, if anything?
4. What remains, if treatment continues?
5. Why was treatment not completed, if applicable?
6. What concise clinical summary should be retained?
7. Who recorded the closure and when?

Clinical Closure remains a current-workflow boundary. It is not a replacement for Treatment Planning, Performed Procedure, Clinical Workspace documentation, Dental Chart, or Clinical Record History.

---

## 2. Lifecycle and entry condition

Clinical Closure is entered only when authoritative Shared Visit state is:

`Ready for Closure`

The approved Option A lifecycle remains:

```text
Shared Visit
In Treatment
    ↓
Shared Visit
Ready for Closure
    ↓
Clinical Closure
Closure Record
    ↓
Shared Visit remains lifecycle owner
    ↓
Closed when the Shared Visit workflow explicitly performs closure
```

Saving a closure record does not automatically change Shared Visit Visit State.

---

## 3. Canonical composition

Canonical name:

`Clinical Closure — Phase 1 — Canonical`

Target architecture:

- Exactly seven top-level regions
- Existing SmileFlow components only
- Vertical Auto Layout preserved
- No global component, variant, variable, style, token, typography, or icon modifications
- Conditional fields may appear within existing regions; a new top-level region is not permitted without separate architecture approval

Seven regions:

1. Clinical Closure Header
2. Visit Context
3. Active Treatment Context
4. Closure Outcome
5. Closure Context / Summary
6. Downstream Handoff
7. Closure Actions

---

## 4. Canonical demonstration context

The following values are demonstration values only.

| Field | Demonstration value | Mode | Owner |
|---|---|---|---|
| Patient Name | `Maria Santos` | Read-only | Patient domain |
| Patient ID | `P-000128` | Read-only | Patient domain |
| Visit ID | `V-000128` | Read-only | Shared Visit |
| Visit Date | `August 11, 2026` | Read-only | Shared Visit |
| Visit Type | `General Consultation` | Read-only | Shared Visit |
| Chair | `Chair 02` | Read-only | Shared Visit |
| Visit State | `Ready for Closure` | Read-only | Shared Visit |
| Treatment Item | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Procedure | `Composite Restoration` | Read-only | Treatment Planning |
| Planned Tooth / Site | `46` | Read-only | Treatment Planning |
| Planned Surface / Scope | `Occlusal` | Read-only | Treatment Planning |
| Treatment Status | `In Progress` | Read-only | Treatment Planning |
| Plan Status | `Planned` | Read-only | Treatment Planning |
| Closure Outcome | `Completed as Planned` | Editable | Clinical Closure |
| Clinical Closure Summary | `Composite restoration completed on tooth #46, occlusal surface. Procedure completed as planned.` | Editable | Clinical Closure |
| Provider | `Dr. Example` | Read-only or system-derived | Authenticated provider context |
| Closure Date / Time | `August 11, 2026 — 3:42 PM` | System-derived | Clinical Closure |
| Patient Tolerance | `Good` | Editable/select when applicable | Clinical Closure |
| Complications / Exceptions | `None` | Editable when applicable | Clinical Closure |

Demonstration values do not authorize mutation of upstream modules.

---

# 5. Region 1 — Clinical Closure Header

Purpose: identify the patient and current module.

| Field | Exact label | Mode | Required | Component intent |
|---|---|---|---|---|
| Module title | `Clinical Closure` | Static/read-only | Yes | Existing heading/text |
| Patient | `Patient` | Read-only | Yes | Existing patient context pattern |
| Patient ID | `Patient ID` | Read-only | Yes | Existing field pattern |

No editable patient information is permitted here.

---

# 6. Region 2 — Visit Context

All fields are read-only.

| Field | Exact label | Required | Owner |
|---|---|---|---|
| Visit ID | `Visit ID` | Yes | Shared Visit |
| Visit Date | `Visit Date` | Yes | Shared Visit |
| Visit Type | `Visit Type` | Yes | Shared Visit |
| Chair | `Chair` | Yes | Shared Visit |
| Visit State | `Visit State` | Yes | Shared Visit |

Canonical Visit State:

`Ready for Closure`

### Invariant

Clinical Closure must never provide an editable Visit State control.

---

# 7. Region 3 — Active Treatment Context

This region establishes the planned/reference context and, where necessary, concise actual-work context.

## 7.1 Planned/reference fields

| Field | Exact label | Mode | Required | Owner |
|---|---|---|---|---|
| Treatment Item | `Treatment Item` | Read-only | Yes | Treatment Planning |
| Planned Procedure | `Planned Procedure` | Read-only | Yes | Treatment Planning |
| Planned Tooth / Site | `Planned Tooth / Site` | Read-only | Yes | Treatment Planning |
| Planned Surface / Scope | `Planned Surface / Scope` | Read-only | Yes | Treatment Planning |
| Treatment Status | `Treatment Status` | Read-only | Yes | Treatment Planning |
| Plan Status | `Plan Status` | Read-only | Yes | Treatment Planning |

## 7.2 Actual-work fields

These fields are closure documentation, not a replacement Performed Procedure editor.

| Field | Exact label | Mode | Required | Conditional |
|---|---|---|---|---|
| Actual Work / Procedure | `Actual Work / Procedure` | Editable or reference-populated | Yes for useful closure record | All outcomes |
| Actual Tooth / Site | `Actual Tooth / Site` | Editable or reference-populated | When clinically relevant | All outcomes where site applies |
| Actual Surface / Scope | `Actual Surface / Scope` | Editable or reference-populated | When clinically relevant | All outcomes where scope applies |

### Duplication rule

If authoritative Performed Procedure data already exists for the visit/treatment item, Clinical Closure should reference that data rather than require duplicate re-entry.

Clinical Closure must not expose the complete Performed Procedure editing surface.

---

# 8. Region 4 — Closure Outcome

## 8.1 Primary field

| Field | Exact label | Mode | Required | Component |
|---|---|---|---|---|
| Closure Outcome | `Closure Outcome` | Editable | Yes | Existing approved Functional Select Field |

Exactly four values are permitted, in this order:

1. `Completed as Planned`
2. `Completed with Modification`
3. `Not Completed`
4. `Treatment Continues`

No additional domain-specific values may be introduced without a specification revision.

## 8.2 Outcome-dependent fields

Only fields relevant to the selected outcome should appear.

### A. Completed as Planned

Required:

- Closure Outcome
- Actual Work / Procedure
- Clinical Closure Summary
- Provider
- Closure Date / Time

Optional when relevant:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

### B. Completed with Modification

Required:

- Closure Outcome
- Actual Work / Procedure
- Modification Classification
- Modification Reason
- Clinical Closure Summary
- Provider
- Closure Date / Time

Optional when relevant:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

### C. Not Completed

Required:

- Closure Outcome
- Not Completed Reason
- Clinical Closure Summary
- Provider
- Closure Date / Time

Conditionally required when follow-up is needed:

- Next Step / Follow-up Context

Optional:

- Patient Tolerance
- Complications / Exceptions
- Actual Work / Procedure when partial work occurred

### D. Treatment Continues

Required:

- Closure Outcome
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Clinical Closure Summary
- Provider
- Closure Date / Time

Conditionally required when known:

- Next Planned Procedure / Next Step

Optional:

- Actual Tooth / Site
- Actual Surface / Scope
- Patient Tolerance
- Complications / Exceptions

---

# 9. Outcome-specific vocabulary

## 9.1 Modification Classification

This is a consumer-owned Clinical Closure vocabulary.

Recommended initial values:

1. `Procedure Changed`
2. `Tooth / Site Changed`
3. `Surface / Scope Changed`
4. `Treatment Extent Changed`
5. `Material / Technique Changed`
6. `Other`

The selected classification must not automatically mutate Treatment Planning.

## 9.2 Not Completed Reason

Recommended initial values:

1. `Patient Declined`
2. `Patient Unable to Tolerate`
3. `Insufficient Time`
4. `Medical Concern`
5. `Unexpected Clinical Finding`
6. `Equipment / Resource Issue`
7. `Financial / Administrative Reason`
8. `Referred Elsewhere`
9. `Other`

These values classify the closure record only.

## 9.3 Patient Tolerance

Recommended initial values:

1. `Good`
2. `Fair`
3. `Poor`
4. `Not Documented`

If the clinical team requires a different controlled vocabulary, revise the field specification before implementation.

---

# 10. Region 5 — Closure Context / Summary

This region contains the durable closure record summary and confirmation context.

## 10.1 Clinical Closure Summary

| Property | Specification |
|---|---|
| Exact label | `Clinical Closure Summary` |
| Type | Multiline text field |
| Mode | Editable |
| Required | Yes for every saved closure |
| Owner | Clinical Closure |
| Initial value | May be generated from structured closure fields |
| User control | Dentist/provider must be able to review and edit before save |

The summary should be concise and clinically meaningful.

Example:

`Composite restoration completed on tooth #46, occlusal surface. Procedure completed as planned. Occlusion checked. Patient tolerated procedure well. No complications noted.`

The system must not represent generated text as independently verified clinical fact until the provider saves/approves it.

## 10.2 Selected Outcome

| Property | Specification |
|---|---|
| Exact label | `Selected Outcome` |
| Mode | Read-only derived confirmation |
| Required | Yes |

## 10.3 Treatment Context

| Property | Specification |
|---|---|
| Exact label | `Treatment Context` |
| Mode | Read-only reference |
| Required | Yes |

## 10.4 Visit Context

| Property | Specification |
|---|---|
| Exact label | `Visit Context` |
| Mode | Read-only reference |
| Required | Yes |

## 10.5 Provider

| Property | Specification |
|---|---|
| Exact label | `Provider` |
| Mode | System-derived/read-only in normal workflow |
| Required | Yes |
| Owner | Authenticated provider context |

The provider must not normally be manually typed into the closure record.

## 10.6 Closure Date / Time

| Property | Specification |
|---|---|
| Exact label | `Closure Date / Time` |
| Mode | System-derived/read-only in normal workflow |
| Required | Yes |
| Owner | Clinical Closure system record |

The application should use a consistent system timestamp rather than asking the provider to manually type the saved timestamp.

## 10.7 Patient Tolerance

| Property | Specification |
|---|---|
| Exact label | `Patient Tolerance` |
| Mode | Editable controlled field |
| Required | Outcome-dependent / clinically applicable |

## 10.8 Complications / Exceptions

| Property | Specification |
|---|---|
| Exact label | `Complications / Exceptions` |
| Mode | Editable multiline text |
| Required | Optional; required if the selected workflow requires documenting an exception |

`None` may be represented as an explicit controlled value only if the product decides this is preferable to an empty optional field.

---

# 11. Region 6 — Downstream Handoff

This region remains architectural communication, not an automatic transition control.

| Field | Exact label | Value / behavior | Mode |
|---|---|---|---|
| Next Workflow Boundary | `Next Workflow Boundary` | `Shared Visit — Close Lifecycle` | Read-only |
| Handoff Status | `Handoff Status` | `No automatic transition` | Read-only |

The closure record may be saved without changing Visit State.

No automatic navigation, procedure creation, treatment completion, history creation, or Shared Visit mutation is authorized by this specification.

---

# 12. Region 7 — Closure Actions

## 12.1 Save Closure Record

The v1.2 label `Save Closure Outcome` is proposed to evolve to:

`Save Closure Record`

| Property | Value |
|---|---|
| Exact label | `Save Closure Record` |
| Type | Primary Button |
| Owner | Clinical Closure |
| Required behavior | Validate and save the complete closure record |
| Cross-module mutation | None unless separately approved |
| Visit State mutation | None by this specification |
| Automatic navigation | Not authorized by this specification |

### Save validation

Save must be blocked when a required field for the selected Closure Outcome is missing.

Examples:

- `Completed with Modification` without Modification Reason → block save.
- `Not Completed` without Not Completed Reason → block save.
- `Treatment Continues` without Remaining Treatment / Continuation Context → block save.
- Any outcome without Clinical Closure Summary → block save.

The exact validation message vocabulary should be defined during interaction specification/preflight.

## 12.2 Cancel

| Property | Value |
|---|---|
| Exact label | `Cancel` |
| Type | Secondary Button |
| Owner | Clinical Closure |
| Effect | Abandons unsaved closure changes |
| Cross-module mutation | None |

Cancel must not delete an already-saved closure record. Record editing/revision behavior is a separate specification.

## 12.3 Close Visit

`Close Visit` remains **not implemented** in this specification.

A future user-facing Close Visit command requires a separate approved interaction contract describing how it invokes the Shared Visit-owned transition `Ready for Closure → Closed`.

---

# 13. Editable / Read-only matrix

## Editable fields

Core:

- Closure Outcome
- Actual Work / Procedure, when not reference-populated
- Actual Tooth / Site, when applicable and not reference-populated
- Actual Surface / Scope, when applicable and not reference-populated
- Clinical Closure Summary
- Patient Tolerance, when applicable
- Complications / Exceptions, when applicable

Conditional:

- Modification Classification
- Modification Reason
- Not Completed Reason
- Next Step / Follow-up Context
- Completed Today / Current Work Summary
- Remaining Treatment / Continuation Context
- Next Planned Procedure / Next Step

## System-derived/read-only

- Patient
- Patient ID
- Visit ID
- Visit Date
- Visit Type
- Chair
- Visit State
- Provider
- Closure Date / Time
- Treatment Item
- Planned Procedure
- Planned Tooth / Site
- Planned Surface / Scope
- Treatment Status
- Plan Status
- Selected Outcome
- Treatment Context
- Visit Context
- Next Workflow Boundary
- Handoff Status

---

# 14. Save-state semantics

Before save:

```text
Closure Record
Draft / unsaved
```

After successful save:

```text
Closure Record
Saved
```

The saved record is attributable to the provider and timestamped.

This specification does not define record editing/revision after save. That requires a separate approved specification to avoid accidental overwriting of clinical history.

---

# 15. Clinical Summary generation rule

If the application generates a suggested Clinical Closure Summary:

1. Generate only from captured structured values and approved contextual data.
2. Present it as editable text.
3. Allow provider review/edit before save.
4. Do not silently introduce unsupported clinical facts.
5. Save only the provider-approved final text.

AI-generated clinical recommendations or diagnoses are outside scope.

---

# 16. Performed Procedure boundary

Clinical Closure must not recreate the complete Performed Procedure editor.

If the current visit already contains an authoritative performed procedure:

```text
Performed Procedure
       ↓
Clinical Closure
read-only/reference context
```

If a concise actual-work value is needed for closure documentation, it may be captured within the limited closure field set, but it must not become an alternate procedure-record system.

Any conflict between Closure actual-work data and authoritative Performed Procedure data requires an explicit reconciliation workflow; it must not be silently resolved by either module.

---

# 17. Clinical Record History boundary

A saved Clinical Closure record may later be represented in Clinical Record History according to the separate history architecture.

Clinical Closure does not directly edit the history timeline.

The persistence/event mechanism remains unspecified here.

---

# 18. Multi-visit rule

`Treatment Continues` means the current visit's closure record documents continuation of treatment.

It does not mean:

- the treatment plan is completed;
- the patient is discharged from treatment;
- the next visit is automatically booked;
- Shared Visit automatically changes state;
- a new treatment plan is automatically created.

The next planned procedure/step may be documented when known, but automatic scheduling remains out of scope.

---

# 19. Conditional-field behavior matrix

| Outcome | Required conditional fields | Optional fields |
|---|---|---|
| Completed as Planned | Actual Work / Procedure; Clinical Closure Summary; Provider; Closure Date / Time | Actual site/scope; Patient Tolerance; Complications / Exceptions |
| Completed with Modification | Actual Work / Procedure; Modification Classification; Modification Reason; Summary; Provider; Date / Time | Actual site/scope; Patient Tolerance; Complications / Exceptions |
| Not Completed | Not Completed Reason; Summary; Provider; Date / Time | Actual partial work; Patient Tolerance; Complications / Exceptions; Next Step / Follow-up when applicable |
| Treatment Continues | Completed Today / Current Work Summary; Remaining Treatment / Continuation Context; Summary; Provider; Date / Time | Next Planned Procedure / Next Step; Actual site/scope; Patient Tolerance; Complications / Exceptions |

---

# 20. Error/validation requirements

The implementation must provide clear validation for missing required fields.

Minimum rules:

1. Closure Outcome is required.
2. Clinical Closure Summary is required.
3. Provider context is required.
4. Closure Date / Time is required and system-derived.
5. Outcome-specific required fields must be completed before save.
6. Save must not silently discard incomplete data.
7. Validation must identify the missing field or section.
8. Cancel must not accidentally save the draft.

Exact visual error treatment should reuse existing approved form validation patterns.

---

# 21. Seven-region invariants

1. Exactly seven top-level regions remain.
2. No new top-level region is created for conditional fields.
3. Conditional content belongs inside the appropriate existing region.
4. Closure Outcome remains the primary classification field.
5. Shared Visit remains sole owner of Visit State.
6. Treatment Planning remains sole owner of treatment lifecycle/status.
7. Performed Procedure remains owner of finalized procedure records.
8. Clinical Workspace remains owner of general active clinical documentation.
9. Clinical Record History remains the historical presentation boundary.
10. Clinical Closure owns its closure record and outcome.

---

# 22. Design-system invariants

1. Existing approved Functional Select Field is reused for Closure Outcome.
2. Existing approved buttons are reused.
3. Existing approved field/text components are preferred for new fields.
4. No shared component is modified for Clinical Closure-specific vocabulary.
5. No shared variant is repurposed to introduce unrelated domain semantics.
6. No design tokens, typography, colors, spacing foundations, or icons are modified.
7. If a required component is unavailable, stop at Figma Preflight and report the blocker.

---

# 23. Explicit exclusions

This v1.3 specification does not authorize:

- automatic Visit State mutation
- automatic `Close Visit`
- automatic treatment completion
- automatic treatment-plan modification
- automatic Performed Procedure creation
- automatic Clinical Record History creation
- automatic appointment scheduling
- automatic follow-up booking
- Dental Chart editing
- general Clinical Workspace note editing
- billing
- insurance
- payments
- claims
- queue management
- messaging
- AI diagnosis
- AI treatment recommendations
- autonomous clinical decision-making
- full record revision history

---

# 24. Implementation gate

This is a proposed specification and is **not yet approved**.

Before any Figma change:

1. Review and approve/revise v1.3 architecture proposal.
2. Review and approve/revise this v1.3 field specification.
3. Run the read-only Cross-Module Dependency Audit against v1.3.
4. Run strict read-first Clinical Closure v1.3 Figma Preflight.
5. Confirm exact existing components and protected/frozen boundaries.
6. Obtain explicit Figma implementation authorization.
7. Implement only approved bounded changes.
8. Run Structural QA.
9. Run Visual/UX Audit.
10. Run Functional Prototype QA for all four outcomes and validation branches.
11. Run Final QA.
12. Freeze only after explicit authorization.

The current v1.2 canonical implementation remains the protected baseline until these gates pass.
