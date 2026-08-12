# Clinical Closure v1.4 — Change Proposal

## Status

**PROPOSED — NOT APPROVED**

This document initializes the v1.4 change process. It does not authorize Figma writes, canonical implementation, modification of the frozen v1.3 baseline, or backend/production behavior.

## Frozen Baseline

Clinical Closure v1.3 is the current frozen baseline.

The v1.3 baseline must remain unchanged while this proposal is evaluated.

### Baseline governance

- Architecture: FROZEN
- Field Specification: FROZEN
- Figma canonical composition: FROZEN
- Final QA: PASS
- Canonicalization: COMPLETE

## Purpose of this proposal

Provide a controlled place to define, evaluate, and either reject or approve improvements to Clinical Closure after v1.3 freeze.

The proposal deliberately separates the **problem/change request** from the eventual architecture, field, Figma, and functional solution.

## Proposed Change

**PENDING DEFINITION**

No specific v1.4 feature or field is authorized yet.

## Problem

**PENDING DEFINITION**

Describe the concrete limitation, workflow friction, missing capability, ambiguity, or newly discovered requirement in the frozen v1.3 baseline.

## Why v1.3 Is Insufficient

**PENDING DEFINITION**

Explain why the current frozen behavior cannot adequately address the identified problem.

## Proposed Behavior

**PENDING DEFINITION**

Describe the desired behavior conceptually only. Do not define final UI geometry, component structure, implementation details, or backend behavior at this stage.

## User / Clinical Benefit

**PENDING DEFINITION**

Describe the expected improvement for the clinician, patient record, workflow clarity, or downstream safety.

## Affected Areas

To be assessed during the v1.4 impact audit:

- Architecture
- Field specification
- Figma composition
- Functional behavior
- Design-system components
- Shared Visit
- Treatment Planning
- Performed Procedure
- Clinical Record History
- Dental Chart
- Scheduling / Queue
- Data ownership

## Ownership Impact

| Area | Impact | Decision |
|---|---|---|
| Clinical Closure | TBD | PENDING |
| Shared Visit | TBD | PENDING |
| Treatment Planning | TBD | PENDING |
| Performed Procedure | TBD | PENDING |
| Clinical Record History | TBD | PENDING |
| Dental Chart | TBD | PENDING |
| Scheduling / Queue | TBD | PENDING |

No ownership change is approved by this document.

## Backward Compatibility

**PENDING DEFINITION**

The v1.4 proposal must explicitly state whether existing v1.3 behavior remains valid and whether migration or compatibility considerations are required.

## Risks

**PENDING DEFINITION**

Risks will be evaluated after the concrete change request is defined.

## Out of Scope

Unless separately proposed and approved, v1.4 does not authorize:

- modification of the frozen v1.3 baseline;
- shared-component changes;
- backend/API implementation;
- automatic Shared Visit mutation;
- automatic Treatment Planning mutation;
- automatic Performed Procedure creation;
- automatic Clinical Record History creation;
- `Close Visit` behavior;
- scheduling or queue behavior;
- unrelated clinical modules.

## Acceptance Criteria

**PENDING DEFINITION**

Acceptance criteria will be written only after the proposed problem and intended behavior are understood and audited.

## Required Next Gate

The next step is:

**Clinical Closure v1.4 — Read-Only Change Impact & Dependency Audit**

The audit must determine whether the proposed change affects the architecture, field specification, design system, Figma implementation, cross-module ownership, or any protected boundary.

No Figma write is authorized before that audit and a subsequent explicit implementation authorization.

## Decision

**PENDING**

Possible outcomes:

1. Reject the proposal and retain v1.3 unchanged.
2. Revise the proposal and re-audit.
3. Approve the proposal for v1.4 specification work.

## Rule

**v1.3 remains frozen unless and until a separately authorized v1.4 change supersedes it.**

Date initialized: 2026-08-12
