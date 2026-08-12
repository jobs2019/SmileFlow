# Clinical Closure v1.3 — Functional Prototype QA

## Status

**FAIL / BLOCKED — functional prototype wiring not sufficiently verifiable in the current canonical frame**

QA target: `Clinical Closure — Phase 1 — Canonical` (`220:1294`)
Protected frame: `207:1291` — untouched

## Scope

This QA checks whether the current Figma composition can demonstrate the approved v1.3 interaction contract, not merely whether the visual states exist.

## Read-only evidence

The current canonical frame contains:

- Closure Outcome using the genuine Functional Select Field instance (`220:1325`).
- The Functional Select Field component set contains the four required value states and corresponding open states:
  - `Value 1`
  - `Value 2`
  - `Value 3`
  - `Value 4`
  - corresponding open states.
- Clinical Closure Summary uses the canonical Multiline Text Field instance (`353:13`).
- Save action is labeled `Save Closure Record` (`221:1299`).
- Cancel action exists (`221:1301`).

The rendered canonical frame currently demonstrates only the `Completed as Planned` configuration.

## QA matrix

| Test | Expected | Current evidence | Result |
|---|---|---|---|
| Closure Outcome = Completed as Planned | Correct fields visible | Static state present | PASS — visual only |
| Closure Outcome = Completed with Modification | Modification Classification + Reason appear; required validation applies | No alternate outcome composition verified in canonical frame | BLOCKED |
| Closure Outcome = Not Completed, no work | Actual Work not required; reason required | No alternate outcome composition verified | BLOCKED |
| Closure Outcome = Not Completed, partial work | Actual Work required; reason required | No alternate outcome composition verified | BLOCKED |
| Closure Outcome = Treatment Continues | Completed Today + Remaining Treatment + continuation context appear | No alternate outcome composition verified | BLOCKED |
| Save Closure Record | Validates selected outcome and saves closure record | Button exists visually; save transition/validation not verifiable from current evidence | BLOCKED |
| Cancel | Abandons unsaved changes | Button exists visually; cancel transition not verifiable | BLOCKED |
| No automatic Visit State mutation | Save must not itself close Shared Visit | No executable transition evidence available | BLOCKED |
| No automatic Close Visit | No Close Visit command in current implementation | No Close Visit control present | PASS |
| Clinical Closure Summary | Multiline editable field | Canonical multiline component instance present | PASS — component/visual only |

## Findings

### 1. Functional Select component is structurally capable

The approved Functional Select Field component contains the four canonical value states and open states. Its component documentation also specifies local closed/open, selection, and dismissal behavior.

However, the current canonical Clinical Closure frame exposes only the filled `Completed as Planned` instance state in the inspected design context. The evidence does not establish that selecting the other three outcomes actually changes the Clinical Closure composition and conditional fields.

### 2. Conditional outcome fields are not currently demonstrably wired

The v1.3 field specification requires outcome-specific behavior. The canonical frame currently contains the Completed-as-Planned content only.

The following cannot be accepted as functionally tested until executable prototype states or an equivalent functional QA construction are present:

- Completed with Modification
- Not Completed with no work
- Not Completed with partial work
- Treatment Continues

### 3. Save Closure Record is visually present but behavior is not verified

The action label is correct, but the current inspected design context represents the button as a visual button composition. There is no available read-only evidence establishing the required validation and save transition.

### 4. Cancel is visually present but behavior is not verified

The Cancel control exists, but its prototype behavior is not verifiable from the current read-only evidence.

### 5. Protected boundary remains intact

No changes to `207:1291` were made during this QA.

## Acceptance rule

Clinical Closure v1.3 must not pass Functional Prototype QA until the following are demonstrably executable/testable:

1. All four Closure Outcome choices.
2. Outcome-specific conditional field visibility.
3. Required-field validation for each outcome.
4. Actual Work behavior for no-work vs partial-work Not Completed cases.
5. Clinical Closure Summary editing.
6. Save Closure Record success behavior.
7. Save blocking behavior when required fields are missing.
8. Cancel behavior.
9. No automatic Shared Visit state mutation from Save Closure Record.
10. No automatic Close Visit behavior.

## Recommendation

Do not advance to Final QA yet.

Create or repair a dedicated **Clinical Closure v1.3 Functional QA** construction using genuine existing components and the approved v1.3 field specification. The canonical seven-region composition should remain the source design; the QA construction should provide explicit executable states for the four outcomes and Save/Cancel validation without changing ownership boundaries.

No production/backend implementation is implied by this Figma prototype QA.
