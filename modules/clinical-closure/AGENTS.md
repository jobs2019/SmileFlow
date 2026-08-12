# Clinical Closure — Module Agent Rules

## Scope
These rules apply to Clinical Closure and its descendants.

## Current state
Clinical Closure is the next module. Its current architecture is `DRAFT FOR APPROVAL`, its field specification is not approved, implementation is not authorized, and it is not frozen.

Do not infer a completed Clinical Closure implementation from historical project-state references or Figma node references.

## Ownership
Clinical Closure is intended to own the closure outcome boundary, subject to approval of its architecture and field specification.

Do not invent final fields, regions, statuses, actions, or prototype transitions beyond approved specifications.

## Implementation gate
Architecture approval and field-specification approval must precede Figma implementation. Figma preflight is mandatory before any write.

## Safety
If the requested work depends on an unapproved architecture or field specification, stop and report `NOT READY — do not modify Figma.`

Do not use this file as authorization to implement Clinical Closure.
