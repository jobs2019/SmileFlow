# SmileFlow Baseline — End-to-End Experience Walkthrough v1

## Status

**READ-ONLY WALKTHROUGH AUDIT — EXPERIENCE INTEGRATION NOT YET COMPLETE**

## Date

2026-08-12

## Scope

This walkthrough inspects the existing Figma prototype states and their current prototype routes across the SmileFlow Phase 1 baseline. No Figma nodes were modified and no repository architecture/specification was changed.

The goal is to determine whether the current baseline can be experienced as one coherent end-to-end clinical workflow before proposing improvements.

## Baseline route inspected

Conceptual workflow:

Patient Registration
→ Patient Management
→ Dental Chart
→ Shared Visit
→ Clinical Workspace
→ Treatment Planning
→ Performed Procedure
→ Clinical Closure
→ Clinical Record History

## Read-only findings

### 1. Reception / Visit lifecycle

A Reception prototype sequence exists with states including Checked In, Waiting, Called, In Treatment, Completed, Cancelled, and No Show. Existing routes allow movement through several Reception states.

**Finding:** PASS as an isolated prototype sequence.

### 2. Shared Visit

A substantial Shared Visit state sequence exists:

Scheduled → Confirmed → Checked In → Waiting → Called → In Treatment

Additional terminal states include Completed, Cancelled, and No Show.

The Called state routes into Clinical Workspace — In Treatment.

**Finding:** PASS as an isolated lifecycle prototype; integration into the complete SmileFlow route remains incomplete.

### 3. Clinical Workspace

Clinical Workspace has Called and In Treatment states. The In Treatment state contains a route into Treatment Planning — Active and a separate completion route into an older Clinical Closure prototype state.

**Finding:** PARTIAL. The prototype demonstrates intended workflow relationships, but the completion route is not consistently routed through the current authoritative Clinical Closure implementation.

### 4. Treatment Planning

Treatment Planning contains Proposed, Accepted, Active, Completed, and Cancelled states. Accepted can route to Shared Visit — Scheduled. Active can route to an older Clinical Closure state.

**Finding:** PARTIAL. The module has a usable local prototype sequence, but its end-to-end handoff is not consistently connected to the current canonical downstream modules.

### 5. Clinical Closure

Two identically named canonical Clinical Closure frames are present in the Figma file:

- `220:1294` — protected historical/superseded composition
- `331:1366` — current canonical Phase 1 implementation according to repository status

The current canonical `331:1366` has Save and Cancel local prototype routes, but Save currently routes to `334:1801`, a local historical/test Saved state rather than a complete downstream Clinical Record History flow.

**Finding:** PARTIAL. Current canonical Clinical Closure is individually QA-passed, but it is not yet an end-to-end integrated closure experience.

### 6. Performed Procedure

Canonical Performed Procedure exists at `260:2`. Its editable-looking fields currently route only to the existing shared Select Menu component. No observed route was found from Performed Procedure into Clinical Closure or Clinical Record History.

**Finding:** PASS as an isolated canonical module; end-to-end integration is not demonstrated by the current prototype.

### 7. Clinical Record History

Canonical Clinical Record History exists at `153:1204`. No prototype reactions were found in the inspected node.

**Finding:** PASS as an informational/history composition; no end-to-end arrival route is currently demonstrated.

## Key experience conclusion

The SmileFlow baseline is **not yet a single executable end-to-end prototype**.

The repository and Figma contain the necessary module compositions and several local workflow sequences, but the current prototype is a collection of connected islands rather than one coherent patient journey.

This is not evidence that the architecture is wrong.

It is an **experience-integration gap**.

## Most important observation

The current canonical Clinical Closure `331:1366` is not the same implementation represented by several older local prototype/test states. Therefore, an end-to-end walkthrough that begins in Shared Visit or Clinical Workspace can encounter older Clinical Closure compositions instead of the current canonical v1.3 implementation.

This should be treated as a baseline integration issue, not immediately as a v1.4 product improvement.

## Experience-first interpretation

No new feature is proposed from these findings.

The appropriate next question is:

> Should we create a controlled **Baseline Experience Harness** that connects the already-approved canonical module states into one read-only, same-file walkthrough without changing any module architecture or production ownership?

Such a harness would be a test/experience surface, not a replacement for the frozen canonical modules.

## Protected boundaries

This walkthrough does not authorize:

- changes to frozen modules;
- changes to module architecture;
- changes to field specifications;
- changes to shared components;
- backend behavior;
- production persistence;
- automatic Visit State mutation;
- automatic Treatment Planning mutation;
- automatic Performed Procedure creation;
- automatic Clinical Record History creation;
- Close Visit behavior.

## Verdict

**Baseline module inventory: COMPLETE**

**Individual module compositions: AVAILABLE**

**End-to-end experience: NOT YET COHERENT**

**Architecture defect: NOT ESTABLISHED**

**v1.4 feature proposal: DEFERRED**

**Recommended next step: controlled read-only Baseline Experience Harness design/preflight, if the user wants to experience the whole SmileFlow flow in one place.**
