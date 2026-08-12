# Patient Registration — Module Agent Rules

## Scope
These rules apply to Patient Registration and its descendants.

## Current state
Patient Registration is FROZEN.

## Ownership
Patient Registration owns patient creation/registration information, including approved identity, demographic, contact, emergency-contact, patient-level alert, review, and registration-action scope.

## Change rule
Do not modify this module, its frozen Figma implementation, or global components/tokens as a side effect of unrelated work.

Do not move patient-level registration ownership into Patient Management, Shared Visit, Clinical Workspace, or another module without an approved architecture decision.

## Feature changes
For any requested addition, removal, or modification:
1. Confirm the requested feature is registration-owned.
2. Check the frozen-module registry.
3. Check for an Architecture Exception.
4. Do not modify Figma without required authorization and preflight.

## Safety
If the request would change the frozen architecture, ownership, or design-system definitions, stop and report `NOT READY — do not modify Figma.`
