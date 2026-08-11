# SmileFlow — Codex Agent Instructions

## Purpose
This is the project-wide operating contract for Codex. Module specifications define WHAT to build; this file defines HOW Codex must work.

## Non-negotiable safety
Never trade architectural correctness for partial implementation. If the complete requested operation cannot be safely executed and validated in the current turn, stop before making Figma changes and report: `NOT READY — do not modify Figma.`

## Figma preflight
Before any write:
1. Confirm Figma MCP is callable.
2. Confirm the document is readable.
3. Confirm the target page is accessible.
4. Confirm write capability.
5. Confirm required components are available.
6. Confirm enough execution capacity exists to complete and validate the whole operation.
7. Check exact-name conflicts.

If any required capability is unavailable, do not modify Figma.

## Exact-name conflicts
If the requested exact composition name already exists, do not modify, delete, rename, or duplicate it. Report the node ID, location, dimensions, and classification. A naming exception requires explicit authorization.

## Frozen modules
A module marked FROZEN is read-only. Never modify it unless a later specification explicitly authorizes the change. Legacy frozen frames are also read-only.

## Design system
Never modify component definitions, component sets, variants, variables, styles, tokens, typography foundations, or icon foundations as a side effect of module implementation.

When an existing component is required, the resulting layer must be a genuine INSTANCE linked to that component. Never simulate an available component with local text/frames.

If a required component is unavailable or incompatible, stop and report the exact blocker.

## Specification fidelity
Implement the approved specification exactly. Do not simplify, omit, split, reinterpret, invent fields, invent workflows, invent navigation, or proceed to Phase 2.

## Ownership
Every data/workflow domain has an owner. A module may display another module's data as a read-only reference but must not silently become its owner.

## Implementation QA
After implementation, inspect actual Figma nodes and verify composition identity, architecture, component identity, content, Auto Layout, containment, navigation, ownership, frozen-module preservation, design-system preservation, and unauthorized additions.

## Audit mode
When instructed to AUDIT ONLY: read only. Make no Figma changes, fix no findings, and stop after reporting the audit.

## Phase control
Typical sequence:
Architecture → Field Specification → Phase 1 Implementation → Structural QA → Visual & UX Audit → Minimal Polish if authorized → Final Re-audit → Freeze.

Do not advance phases without explicit instruction.

## Failure handling
If an API/script/Figma operation fails:
- determine whether Figma actually changed;
- do not silently continue;
- retry only if safe;
- preserve the no-partial-implementation rule;
- report the exact error and change status.

## Source hierarchy
1. Explicit user authorization
2. Approved module specification
3. Approved architecture
4. DESIGN.md
5. AGENTS.md
6. Existing Figma implementation
7. External references

External repositories are references, not SmileFlow authority.
