# Clinical Closure v1.4 — Change Proposal

## Status

**DEFERRED — EXPERIENCE-FIRST**

This proposal is intentionally paused. No v1.4 feature, field, architecture change, Figma write, canonical implementation, or backend/production behavior is authorized.

## Frozen Baseline

Clinical Closure v1.3 is the current frozen baseline.

The v1.3 baseline must remain unchanged while v1.4 is deferred.

### Baseline governance

- Architecture: FROZEN
- Field Specification: FROZEN
- Figma canonical composition: FROZEN
- Final QA: PASS
- Canonicalization: COMPLETE

## Reason for Deferral

The team has not yet experienced the complete SmileFlow workflow as an integrated product. It would be premature to define v1.4 improvements based only on anticipated problems.

The preferred product-development sequence is to finish the current SmileFlow baseline first, experience the system as an actual user, observe concrete workflow friction or missing capabilities, and only then propose evidence-based changes.

## Experience-First Principle

> **Finish the baseline. Experience it. Observe real problems. Then improve it.**

v1.4 must not become an exercise in inventing improvements to a module that has not yet been used within the complete SmileFlow workflow.

## Deferred Change Definition

The following remain intentionally undefined until real usage provides evidence:

- Proposed Change
- Problem
- Why v1.3 Is Insufficient
- Proposed Behavior
- User / Clinical Benefit
- Affected Areas
- Ownership Impact
- Backward Compatibility
- Risks
- Acceptance Criteria

No assumptions should be converted into v1.4 requirements merely to advance the version number.

## What Happens Before v1.4

The project should continue completing the remaining SmileFlow baseline modules and their required integration boundaries without speculative enhancement.

The baseline-completion workflow should prioritize:

1. repository/module inventory;
2. dependency and ownership verification;
3. authoritative architecture/specification where missing;
4. read-first Figma preflight;
5. bounded implementation;
6. Functional QA;
7. Visual / UX QA;
8. Final QA;
9. canonicalization/freeze where authorized.

## Experience Phase

After the baseline modules are sufficiently complete, the team should perform an end-to-end SmileFlow walkthrough using realistic clinical workflow scenarios.

The experience phase should record observations such as:

- duplicated data entry;
- unclear ownership or responsibility;
- confusing workflow transitions;
- missing clinical context;
- unnecessary fields or steps;
- insufficient visibility;
- awkward handoffs between modules;
- incorrect timing of a module in the workflow;
- unexpected behavior;
- clinically useful information that is unavailable at the point of decision.

These observations become evidence for future change proposals.

## Evidence Rule

A future v1.4 proposal should preferably originate from an observed problem in the completed SmileFlow workflow rather than an assumed improvement.

The evidence should describe:

- what the user attempted to accomplish;
- what the user expected;
- what actually happened;
- why the difference matters;
- which module or boundary is implicated.

## Protected Scope

While this proposal is deferred, there is no authorization to:

- modify frozen Clinical Closure v1.3;
- modify the canonical Figma frame;
- modify shared components;
- change the four canonical Closure Outcome values;
- change the seven-region architecture;
- change ownership boundaries;
- introduce backend/API behavior;
- introduce automatic Shared Visit mutation;
- introduce automatic Treatment Planning mutation;
- introduce automatic Performed Procedure creation;
- introduce automatic Clinical Record History creation;
- introduce `Close Visit` behavior;
- introduce scheduling or queue behavior.

## Resume Condition

Resume v1.4 only when at least one concrete, evidence-based problem has been observed during actual SmileFlow use or a clearly established baseline workflow review.

At that point:

1. record the observation;
2. define the v1.4 change proposal;
3. run the Read-Only Change Impact & Dependency Audit again;
4. determine whether architecture/specification changes are actually necessary;
5. proceed through the normal versioned implementation gates only if justified.

## Decision

**DEFERRED — EXPERIENCE-FIRST**

v1.3 remains the authoritative frozen Clinical Closure baseline.

## Date

2026-08-12
