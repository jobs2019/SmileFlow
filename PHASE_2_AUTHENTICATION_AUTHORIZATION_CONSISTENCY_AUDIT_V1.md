# SmileFlow Phase 2 — Authentication & Authorization Consistency Audit v1

## Status

**STRUCTURAL CONSISTENCY PASS — IMPLEMENTATION NOT YET AUTHORIZED**

Date: 2026-08-13

## Audit scope

This audit checks the Authentication & Authorization Specification v1.0 against:

- `PHASE_2_CORE_DATA_SCHEMA_SPECIFICATION_V1_1.md`
- the established Phase 2 reconciliation decisions;
- the existing module ownership boundaries;
- the Phase 1 Product Shell boundary.

This is a read-only consistency audit. No authentication provider, database policy, RLS rule, application code, or Figma change is authorized by this document.

## Executive result

**PASS**

No contradiction was found in the foundational identity, clinic-membership, resource-isolation, or authorship model.

The security model correctly treats authentication and authorization as separate concerns and correctly places clinic membership between identity and resource access.

Two areas remain intentionally conditional and must be resolved before production authorization implementation:

1. the exact permission matrix for ambiguous clinical capabilities;
2. provider-specific session/authentication behavior.

These are specification follow-ups, not structural contradictions.

## 1. Identity model consistency — PASS

Core Data defines:

```text
User
  ↓
Clinic Membership
  ↓
Role
```

Authentication & Authorization defines:

```text
Authentication Identity
  ↓
SmileFlow User (`user_id`)
  ↓
Clinic Membership
  ↓
Role
```

These are consistent.

The application-domain User remains separate from provider-managed credentials.

**Result: PASS**

## 2. Clinic tenant boundary — PASS

Core Data requires `clinic_id` on clinic-owned domain entities and explicitly prohibits implicit cross-clinic access.

Authentication & Authorization requires:

```text
authenticated user
AND
active membership
AND
resource clinic matches membership
AND
permission allows action
```

This correctly reinforces the Core Data tenant boundary rather than creating a competing ownership model.

**Result: PASS**

## 3. Canonical Patient identity — PASS

Core Data defines exactly one canonical Patient entity with immutable `patient_id`.

Authentication & Authorization does not create a second patient identity or module-specific patient identity.

Patient access is correctly permissioned against the canonical Patient resource.

**Result: PASS**

## 4. Patient Registration vs Patient Management — PASS

Core Data establishes:

```text
Patient Registration
    ↓
Canonical Patient
    ↓
Patient Management
```

Authentication & Authorization controls permitted actions against that shared resource instead of creating ownership duplication.

The rule that a user cannot bypass field/action authorization by entering through another module is consistent with the shared Patient model.

**Result: PASS**

## 5. Visit access — PASS

Core Data defines Visit as a clinic-owned, patient-linked clinical encounter.

Authentication & Authorization requires both clinic membership and the appropriate visit permission before access or mutation.

A client-supplied `visit_id` is explicitly insufficient on its own.

**Result: PASS**

## 6. Visit State vs authorization — PASS

Core Data explicitly separates Visit State from Treatment Plan Item Status, Performed Procedure Status, and Closure Outcome.

Authentication & Authorization does not reuse any of these clinical states as security roles or permission states.

This is correct.

**Result: PASS**

## 7. Treatment Planning — PASS WITH CONDITIONAL FOLLOW-UP

Core Data establishes the authoritative planned-item lifecycle:

```text
Planned
  ↓
Scheduled
  ↓
In Progress
  ↓
Completed
```

Authentication & Authorization correctly states that treatment-plan lifecycle mutations require permission independently from visit-state transitions.

However, the initial role matrix contains conditional entries such as:

- "Yes, where authorized"
- "Yes, where explicitly authorized"
- "No by default"

These are intentionally not converted into a final production permission enum.

**Result: PASS WITH FOLLOW-UP**

Required next action: define the final treatment-planning action permissions in the Runtime Workflow / Authorization matrix before implementation.

## 8. Dental Chart — PASS WITH CONDITIONAL FOLLOW-UP

Core Data assigns chart state/findings to Dental Chart.

Authentication & Authorization separates:

- view chart;
- create/update chart findings;
- privileged corrections.

It also explicitly prevents chart permission from automatically granting treatment-planning, performed-procedure, or closure authority.

This is consistent.

The exact field-level and correction permissions remain contract-dependent.

**Result: PASS WITH FOLLOW-UP**

## 9. Performed Procedure — PASS WITH CONDITIONAL FOLLOW-UP

Core Data defines Performed Procedure as actual clinical work attached to the patient/visit and optionally tooth/procedure definition.

Authentication & Authorization separately requires permission to record performed procedures and requires server-derived authorship.

This does not conflict with the domain ownership.

The exact draft/final/error mutation permissions remain deferred to the Runtime Workflow Contract.

**Result: PASS WITH FOLLOW-UP**

## 10. Clinical Closure — PASS

Core Data defines Clinical Closure as the visit-level closure boundary with a distinct closure outcome.

Authentication & Authorization treats closure as a privileged clinical action and explicitly requires authorization before committing a closure outcome.

It does not equate closure permission with generic visit access.

**Result: PASS**

## 11. Clinical Record History — PASS

Core Data defines Clinical Record History as a read-only longitudinal projection.

Authentication & Authorization treats history as a read capability and does not grant history access the ability to mutate source records.

**Result: PASS**

## 12. Audit authorship — PASS

Core Data requires authorship fields such as:

```text
created_by
updated_by
recorded_by
performed_by
```

Authentication & Authorization explicitly requires these values to be derived from the authenticated server-side identity rather than trusted client input.

This is a direct and correct dependency.

**Result: PASS**

## 13. Administrator boundary — PASS

The security specification explicitly states:

> Administrator is not automatically unrestricted clinical authority.

This is consistent with the Core Data module ownership boundaries.

Administrative management and clinical authority remain conceptually separate.

Any administrator clinical permission must be explicitly granted rather than inferred from the administrator role itself.

**Result: PASS**

## 14. Authentication credentials — PASS

Core Data User does not own authentication credentials.

Authentication & Authorization leaves passwords, reset secrets, MFA secrets, and provider-managed tokens to the selected authentication provider.

No credential storage has been introduced into the domain schema.

**Result: PASS**

## 15. Session context — PASS

Authentication & Authorization requires the effective session context to establish:

```text
user_id
active clinic context
membership/role context
session validity
```

The Core Data schema supplies the corresponding domain relationships through User and Clinic Membership.

The exact provider-specific session mechanism remains deferred appropriately.

**Result: PASS**

## 16. Failure behavior — PASS

The specification distinguishes:

- unauthenticated;
- authenticated but unauthorized;
- wrong clinic;
- inactive membership.

This supports the Core Data tenant boundary and does not leak cross-clinic resource existence by default.

**Result: PASS**

## 17. Phase boundary consistency — PASS

The Authentication & Authorization specification does not accidentally authorize:

- Scheduling implementation;
- Billing;
- HMO/insurance;
- Figma changes;
- clinical redesign;
- database RLS implementation;
- provider configuration.

It defines access requirements without implementing later phases.

**Result: PASS**

## 18. Phase 1 Product Shell consistency — PASS

The Product Shell provides navigation and account/search surfaces but is not treated as a security boundary.

This is correct.

The shell may hide or show controls for UX, but production authorization must remain enforced at the backend/database boundary.

**Result: PASS**

## Findings requiring later resolution

### Finding A — Final permission matrix

The initial role matrix is useful for architecture but is not sufficiently precise for implementation because several clinical actions remain conditional.

Required resolution before implementation:

```text
role
  ↓
resource
  ↓
action
  ↓
allow / deny
  ↓
conditions, if any
```

This should be defined against the Runtime Workflow Contract rather than guessed now.

### Finding B — Authentication provider behavior

Provider selection, session duration, refresh behavior, MFA, recovery, and session revocation remain technology-dependent.

No contradiction exists, but implementation cannot be finalized until the Technology Decision is made.

### Finding C — Field-level authorization

The Patient and other module specifications intentionally leave some exact field inventories unresolved.

Therefore field-level authorization cannot be finalized for those fields yet.

This is consistent with the repository's anti-invention rule.

## Explicit non-findings

The audit found no contradiction involving:

- canonical Patient identity;
- clinic isolation;
- user identity;
- membership model;
- role model;
- Visit ownership;
- Treatment Planning state separation;
- Dental Chart ownership;
- Clinical Closure ownership;
- Clinical Record History projection;
- authorship attribution;
- HMO/insurance exclusion.

## Final audit status

| Area | Result |
|---|---|
| Authentication identity | **PASS** |
| User ↔ domain User mapping | **PASS** |
| Clinic membership boundary | **PASS** |
| Cross-clinic isolation | **PASS** |
| Canonical Patient access | **PASS** |
| Patient Registration / Management | **PASS** |
| Visit access | **PASS** |
| Treatment Planning authorization | **PASS WITH FOLLOW-UP** |
| Dental Chart authorization | **PASS WITH FOLLOW-UP** |
| Performed Procedure authorization | **PASS WITH FOLLOW-UP** |
| Clinical Closure authorization | **PASS** |
| Clinical Record History | **PASS** |
| Authorship | **PASS** |
| Administrator boundary | **PASS** |
| Credential separation | **PASS** |
| Session model | **PASS** |
| Phase boundary | **PASS** |
| HMO / insurance | **EXCLUDED** |

## Conclusion

**Authentication & Authorization Specification v1.0 is structurally consistent with the reconciled Core Data Schema v1.1.**

The remaining issues are deliberately deferred implementation details, not architectural contradictions.

Therefore:

> **Authentication/Authorization architecture: PASS**
>
> **Authentication/Authorization implementation: NOT YET AUTHORIZED**

## Next gate

The next required task is:

> **SmileFlow Phase 2 — Runtime Workflow Contract Specification v1.0**

That contract must define the allowed state transitions and mutation boundaries for Visits, Treatment Planning, Performed Procedures, and Clinical Closure. It will also resolve the conditional clinical permissions identified in this audit.

Only after that should the final permission matrix and provider/database implementation plan be finalized.
