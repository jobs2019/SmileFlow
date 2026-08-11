# Clinical Workspace — Architecture & Information Model v1.0

## Purpose
Clinical Workspace is the active clinical work/documentation workspace for a visit in the `In Treatment` state.

It references patient, visit, and planned-treatment data but owns current clinical documentation.

It does not own patient registration, Dental Chart state, Treatment Planning, Shared Visit lifecycle, Clinical Closure outcomes, Performed Procedure, Clinical Record History, billing, or insurance.

## Seven regions
1. Clinical Workspace Header
2. Visit Context
3. Active Treatment
4. Tooth / Treatment Scope
5. Clinical Documentation
6. Visit Status
7. Clinical Actions

## State distinction
Treatment Planning: `In Progress`
Clinical Workspace / visit: `In Treatment`

## Approved flow
Shared Visit → Clinical Workspace → Clinical Closure → downstream procedure/history as appropriate.

## Multi-visit rule
Visit completion does not automatically equal treatment completion.
