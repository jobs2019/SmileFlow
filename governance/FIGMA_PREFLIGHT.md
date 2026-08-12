# SmileFlow — Figma Preflight Protocol

## Status

**ACTIVE GOVERNANCE PROTOCOL**

This document defines the mandatory gate between repository authorization and any Figma write in SmileFlow.

It applies to:

- new module implementation;
- feature additions;
- feature removals;
- feature modifications;
- visual corrections that change Figma nodes;
- architecture replacement implementation;
- component-instance changes;
- layout changes;
- content changes that require Figma mutation.

It does **not** authorize a Figma write by itself.

A preflight may establish `READY`, but implementation still requires the applicable authorization defined by `SOURCE_OF_TRUTH.md`, `PROJECT_STATE.md`, module specifications, governance, and the user's current instruction.

---

## 1. Core rule

**No Figma write before a passing preflight.**

If any mandatory gate is unresolved, the result is:

> `NOT READY — do not modify Figma.`

Do not partially implement around a failed gate.

Do not treat a small change as exempt because it appears visually trivial.

Do not use an existing Figma frame as permission to modify it.

---

## 2. Preflight outcome states

Every preflight must end in exactly one of these states:

### READY

All mandatory gates pass, the requested operation is authorized, and the execution/validation path is available.

### NOT READY

One or more mandatory gates fail or remain unknown.

No Figma write is permitted.

### BLOCKED — AUTHORIZATION

The repository may be structurally ready, but the requested operation has not been authorized.

No Figma write is permitted.

### BLOCKED — CAPABILITY

Required Figma access, component, page, write capability, or validation capability is unavailable.

No Figma write is permitted.

### BLOCKED — CONTRADICTION

Repository sources conflict and the authority hierarchy cannot safely resolve the conflict.

No Figma write is permitted.

---

## 3. Gate 0 — Request definition

Before inspecting Figma, define the requested operation.

Record:

- module;
- requested change;
- change type;
- target composition/page when known;
- whether the request is new implementation, modification, removal, or audit;
- explicit user authorization present in the current task.

Do not broaden the request while performing preflight.

A request such as `add a field` does not authorize redesigning the surrounding module.

---

## 4. Gate 1 — Repository authority

Read:

1. `SOURCE_OF_TRUTH.md`
2. `PROJECT_STATE.md`
3. root `AGENTS.md`
4. nearest module `AGENTS.md`
5. module `ARCHITECTURE.md`
6. module `FIELD_SPECIFICATION.md`
7. relevant governance files
8. `DESIGN.md`

Confirm:

- the module exists in the repository;
- the module has an identifiable owner;
- the applicable architecture is known;
- the applicable field specification is known;
- the requested operation is compatible with the current state;
- no higher-authority document forbids the operation.

If required authoritative documentation is missing, the preflight fails unless the request is explicitly for documentation recovery rather than Figma implementation.

---

## 5. Gate 2 — Change classification and locality

Classify the change:

- feature addition;
- feature removal;
- feature modification;
- visual correction;
- content correction;
- architecture change;
- ownership change;
- design-system change;
- governance change.

Determine the smallest affected scope.

Confirm whether the change is:

- module-local;
- cross-module;
- design-system-wide.

A local change must remain local unless the approved architecture requires a broader change.

If ownership or scope is unclear, fail preflight.

---

## 6. Gate 3 — Architecture and field specification

Confirm that the requested result can be described exactly from the approved architecture and field specification.

Verify:

- required regions;
- required fields;
- field order where specified;
- values/options;
- editability/read-only state;
- required actions;
- prohibited actions;
- ownership boundaries;
- Phase 1/Phase 2 boundary;
- naming requirements;
- required composition identity.

If architecture and field specification conflict:

`BLOCKED — CONTRADICTION`

Do not resolve the conflict by design judgment.

---

## 7. Gate 4 — Freeze and exception protection

Check `governance/FROZEN_MODULES.md` and `governance/ARCHITECTURE_EXCEPTIONS.md`.

If the target is frozen:

- an applicable Architecture Exception must exist;
- the exception must cover the requested scope;
- implementation authorization must still be present.

If the module is not frozen, that does **not** mean it is automatically writable.

Current state, specifications, preflight, and explicit authorization still apply.

Protected legacy frames remain protected even when a replacement architecture exists.

---

## 8. Gate 5 — Exact-name conflict

Before creating a composition, verify whether the requested exact name already exists.

If the exact name exists:

- do not modify it;
- do not delete it;
- do not rename it;
- do not duplicate it as a workaround.

Report:

- node ID;
- page/location;
- dimensions;
- node type;
- classification as current, historical, frozen, or unknown;
- relationship to the requested composition.

An exact-name conflict is a blocker unless explicitly resolved by authorization and governance.

---

## 9. Gate 6 — Figma document access

Confirm:

- correct Figma file;
- correct file key;
- design-file/editor mode is appropriate;
- target page exists;
- target page is accessible;
- target composition can be inspected;
- required write capability exists if implementation is authorized.

When using the Figma Plugin API through `use_figma`, the `figma-use` skill must be loaded first and its instructions followed.

Use read-only inspection tools for discovery whenever possible.

Do not use a write operation merely to test access.

---

## 10. Gate 7 — Design-system dependency verification

Before implementation, identify every required shared component, variable, style, token, and icon.

Confirm that:

- required components exist;
- required components are the approved components;
- required variants/properties exist;
- required variables/styles exist;
- the implementation can use genuine instances;
- no global design-system modification is necessary unless separately authorized.

Search the design system before inventing a replacement.

Never simulate an available component with a local frame/text construction.

If the required component does not exist or cannot support the specification, fail preflight rather than silently creating a substitute.

---

## 11. Gate 8 — Layout and implementation feasibility

Confirm the requested architecture can be implemented without violating the design-system rules.

Check:

- Auto Layout requirements;
- container hierarchy;
- fixed/hug/fill sizing feasibility;
- typography availability;
- icon availability;
- component-instance requirements;
- expected dimensions;
- expected responsive/reflow behavior;
- page placement constraints.

For large implementations, define incremental implementation steps before writing.

Do not attempt an unnecessarily large atomic Figma script.

---

## 12. Gate 9 — Protected-boundary analysis

List the things the implementation must **not** modify.

At minimum consider:

- frozen modules;
- protected legacy frames;
- global components;
- component sets;
- variables;
- styles;
- tokens;
- unrelated modules;
- unrelated pages;
- unrelated prototypes.

If the requested operation cannot be isolated from a protected boundary, fail preflight until the boundary is explicitly authorized.

---

## 13. Gate 10 — Execution plan

Before writing, define:

1. target page;
2. target composition;
3. nodes to create;
4. nodes to mutate;
5. components to instantiate;
6. nodes that must remain untouched;
7. expected resulting structure;
8. validation method;
9. rollback/recovery approach if an operation fails.

For multi-page work, split operations by page according to the applicable Figma tool rules.

For `use_figma`, work incrementally and validate after each meaningful step.

Every write must return the IDs of created or mutated nodes.

---

## 14. Gate 11 — Validation plan

Before writing, define how success will be verified.

At minimum, validation must cover:

### Structural

- exact composition identity;
- node hierarchy;
- required regions;
- required fields/actions;
- component identity;
- genuine instances;
- Auto Layout;
- dimensions;
- containment;
- naming.

### Behavioral

- editable vs read-only behavior;
- prototype/navigation behavior when applicable;
- action availability;
- ownership boundaries;
- absence of unauthorized actions.

### Visual

- typography;
- spacing;
- alignment;
- hierarchy;
- component appearance;
- visual consistency with the approved design system.

### Protection

- frozen modules unchanged;
- protected legacy frames unchanged;
- global components unchanged;
- tokens/variables/styles unchanged unless authorized;
- unrelated modules unchanged.

---

## 15. Gate 12 — Implementation authorization

A passing technical preflight does not itself authorize implementation.

Before writing, confirm all required authorization sources agree:

- current user instruction;
- `PROJECT_STATE.md`;
- applicable module state;
- architecture/field specification approval;
- governance exceptions when applicable;
- freeze protection requirements.

If authorization is absent:

`BLOCKED — AUTHORIZATION`

---

## 16. Gate 13 — Final go/no-go

Only when Gates 0–12 pass may the result be:

`READY`

The preflight record should state:

- module;
- change;
- authorization basis;
- architecture source;
- field specification source;
- freeze/exception status;
- target Figma file/page;
- exact-name result;
- design-system dependencies;
- protected boundaries;
- implementation plan;
- validation plan;
- preflight result.

If any required item is unknown:

`NOT READY — do not modify Figma.`

---

## 17. Write-time rules

After a passing preflight:

- use the approved Figma workflow/tool;
- follow the loaded Figma skill instructions;
- work incrementally;
- do not broaden scope;
- return affected node IDs;
- stop on tool errors;
- do not immediately retry a failed `use_figma` script without understanding the failure;
- validate the resulting Figma state.

A successful API call is not equivalent to a successful implementation.

---

## 18. Post-write verification

Immediately after implementation, perform structural verification against the approved architecture and field specification.

Then perform the required Visual & UX Audit.

If verification fails:

- do not declare PASS;
- identify the discrepancy;
- determine whether the issue is implementation, specification, or governance;
- correct only when correction is authorized;
- revalidate after correction.

Do not freeze a module with unresolved discrepancies.

---

## 19. Audit-only mode

If the user requests `AUDIT ONLY`:

- all repository and Figma inspection is read-only;
- no write is permitted;
- no cleanup is permitted;
- no fixes are permitted;
- report findings only.

The preflight protocol still applies to determine what can be safely inspected.

---

## 20. Failure and partial-state handling

If a Figma operation fails:

1. determine whether the operation actually changed Figma;
2. do not assume atomicity unless the tool contract guarantees it;
3. inspect the resulting state when safe;
4. identify created/mutated nodes;
5. do not continue with dependent writes until state is understood;
6. do not claim success;
7. choose the safest recovery path.

For `use_figma`, follow the tool/skill contract regarding atomic execution and returned node IDs.

---

## 21. Feature-change fast path

Future feature changes use the same protocol.

For a simple local change:

`Request → Owner → Specification → Scope → Freeze → Figma conflict → Design-system dependency → Authorization → Preflight → Implement → QA`

Do not skip preflight because a change is small.

The purpose of the protocol is to make small changes **safe and localized**, not to make them informal.

---

## 22. Clinical Workspace current preflight state

Clinical Workspace currently has:

- approved replacement architecture;
- approved replacement field specification;
- canonical composition: `Clinical Workspace — Phase 1 — Canonical`;
- replacement Figma implementation: **NOT IMPLEMENTED**;
- Figma preflight: **NOT STARTED**;
- freeze: **NOT READY**.

The previous Clinical Workspace composition is protected historical work.

This protocol does not itself authorize implementation.

The next authorized operational step after completion of the governance setup is a **strict, read-first Clinical Workspace preflight**.

---

## 23. Preflight record template

Use this template for future preflight reports:

```text
SMILEFLOW FIGMA PREFLIGHT

Module:
Change:
Change Type:

Authority
- User authorization:
- PROJECT_STATE:
- Architecture:
- Field Specification:
- Module AGENTS:
- Governance:

Ownership
- Data/workflow owner:
- Local or cross-module:
- Architecture impact:

Protection
- Frozen status:
- Architecture Exception:
- Protected legacy frame:
- Protected design-system dependencies:

Figma
- File:
- File key:
- Target page:
- Target composition:
- Exact-name conflict:
- Required components:
- Required variables/styles:

Execution
- Planned writes:
- Protected nodes/modules:
- Incremental steps:
- Validation method:

Result
- READY / NOT READY / BLOCKED — AUTHORIZATION / BLOCKED — CAPABILITY / BLOCKED — CONTRADICTION
- Blocking findings:
- Next authorized action:
```

---

## 24. Protocol maintenance

Changes to this protocol are governance changes.

Do not create competing preflight procedures in module documentation.

Module-level `AGENTS.md` files may add stricter module-specific gates but may not weaken this protocol.

If this protocol changes, update `SOURCE_OF_TRUTH.md` or other governance references when necessary so there is one authoritative preflight model.
