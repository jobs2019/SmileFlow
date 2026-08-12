# SmileFlow — Source of Truth

## Purpose

This document defines which repository artifact is authoritative for each class of SmileFlow information.

Its purpose is to prevent Codex, reviewers, and future contributors from treating stale implementation reports, historical audits, legacy Figma frames, or duplicated documentation as current authority.

This file governs **repository interpretation**. It does not override explicit user authorization, approved module specifications, or the operating rules in `AGENTS.md`.

---

## 1. Absolute authority order

When two sources appear to disagree, use this order:

1. **Explicit user authorization in the current task**
2. **Current approved module Field Specification**
3. **Current approved module Architecture**
4. **`PROJECT_STATE.md`** for current project phase, freeze state, and next authorized action
5. **`governance/FROZEN_MODULES.md`** for frozen-module protection
6. **`governance/ARCHITECTURE_EXCEPTIONS.md`** for authorized departures from normal architecture/freeze rules
7. **`DESIGN.md`** for global design-system and Figma rules
8. **Module `AGENTS.md`** files for local operating constraints
9. **Root `AGENTS.md`** for project-wide Codex operating rules
10. **Current Figma implementation** as implementation evidence only
11. **Implementation reports and visual/UX audits** as phase evidence only
12. **README.md and templates** as navigation/documentation aids
13. **External references** as non-authoritative references only

A lower-ranked source must never silently override a higher-ranked source.

---

## 2. Authority by information type

| Information | Authoritative source |
|---|---|
| Current project phase | `PROJECT_STATE.md` |
| Current authorized next action | `PROJECT_STATE.md` |
| Module architecture | `modules/<module>/ARCHITECTURE.md` |
| Module field/content requirements | `modules/<module>/FIELD_SPECIFICATION.md` |
| Module-specific operating rules | `modules/<module>/AGENTS.md` |
| Project-wide Codex behavior | `AGENTS.md` |
| Global design-system rules | `DESIGN.md` |
| Frozen-module protection | `governance/FROZEN_MODULES.md` |
| Architecture exceptions | `governance/ARCHITECTURE_EXCEPTIONS.md` |
| Implementation result | `modules/<module>/IMPLEMENTATION_REPORT.md` |
| Structural QA result | Module QA artifact when present; otherwise implementation evidence |
| Visual/UX audit result | `modules/<module>/VISUAL_UX_AUDIT.md` |
| Current module readiness/status | `modules/<module>/STATUS.md`, interpreted against `PROJECT_STATE.md` and governance |
| Historical implementation evidence | Implementation reports/audits marked historical or superseded |
| Repository orientation | `README.md` |
| Reusable documentation structure | `templates/` |

---

## 3. Current project-state rule

`PROJECT_STATE.md` is the authoritative ledger for the current SmileFlow project state.

A module's historical `STATUS.md`, implementation report, visual/UX audit, or existing Figma frame must not be used to infer that a later implementation is authorized.

In particular:

- `PASS` does not equal permission to modify Figma.
- `READY TO FREEZE` does not equal `FROZEN` unless the current project state and frozen registry agree.
- A historical implementation does not satisfy a replacement architecture.
- A prior freeze does not survive an explicitly authorized architecture replacement unless the replacement is separately implemented and frozen.
- A repository commit does not by itself authorize a Figma write.

---

## 4. Module architecture rule

For an active module, `ARCHITECTURE.md` defines the approved structural model and ownership boundaries.

`FIELD_SPECIFICATION.md` defines the precise required fields, values, editability, actions, and presentation constraints.

When the architecture and field specification are both approved, implementation must satisfy both.

If they conflict:

1. Stop.
2. Do not modify Figma.
3. Report the exact conflict.
4. Require an explicit resolution before implementation.

Do not resolve an architecture/specification conflict by guessing.

---

## 5. Frozen-module rule

`governance/FROZEN_MODULES.md` is the authoritative protection registry for frozen modules and protected legacy frames.

A frozen module is read-only unless an explicit Architecture Exception has been recorded in `governance/ARCHITECTURE_EXCEPTIONS.md` and the applicable implementation authorization has been given.

Being absent from the frozen registry does **not** mean that a module is automatically writable.

Architecture, field specification, project state, preflight, and explicit authorization still apply.

---

## 6. Architecture-exception rule

`governance/ARCHITECTURE_EXCEPTIONS.md` records explicit departures from normal architecture or freeze protection.

An architecture exception:

- authorizes a change to the repository's architectural interpretation only within its stated scope;
- does not automatically authorize a Figma write;
- does not automatically authorize implementation;
- does not automatically unfreeze unrelated modules;
- does not authorize unrelated design-system changes.

The exception must be read together with `PROJECT_STATE.md`, the applicable module specification, and the Figma preflight requirements.

---

## 7. Historical artifacts

Implementation reports and visual/UX audits describe what was implemented or audited at a particular point in time.

They are evidence, not permanent authorization.

When an architecture or field specification is replaced, the previous implementation/audit artifacts must be treated as historical unless explicitly revalidated under the replacement source of truth.

Historical artifacts must not be deleted merely because they are superseded. They provide traceability.

When necessary, a historical artifact must be explicitly labeled `SUPERSEDED` or `HISTORICAL` so its scope is unambiguous.

---

## 8. Figma is not the repository authority

The current Figma file is an implementation surface and verification source, not the ultimate source of SmileFlow architecture.

Codex must not infer new requirements from an existing Figma frame when the repository specification says otherwise.

If the repository specifies a replacement composition, the old Figma composition remains protected until the replacement preflight and implementation authorization are satisfied.

Existing Figma nodes may be inspected to establish:

- current implementation state;
- component identity;
- node IDs;
- dimensions;
- Auto Layout;
- containment;
- visual evidence;
- possible conflicts.

Inspection does not grant permission to modify them.

---

## 9. README rule

`README.md` is a navigation and orientation document.

It must summarize the current state accurately, but it is not an independent source of project authority.

If README and `PROJECT_STATE.md` disagree, `PROJECT_STATE.md` wins and README must be corrected.

README must never be used as justification for a Figma change.

---

## 10. Templates are not specifications

Files under `templates/` provide documentation structure only.

A template must never be treated as evidence that a module has a particular field, workflow, architecture, status, or authorization.

Module-specific files override templates.

---

## 11. Change locality rule

When a feature is added, removed, renamed, or changed, Codex must identify the owning module before editing anything.

The smallest valid set of authoritative artifacts should be changed.

A local feature change must not cause unrelated modules, frozen modules, global components, or design tokens to be modified unless the approved architecture explicitly requires it.

If a proposed change crosses module ownership boundaries, stop and identify the required architecture decision before implementation.

---

## 12. Contradiction protocol

If Codex discovers contradictory repository information:

1. Identify all conflicting sources.
2. Apply the authority order in Section 1.
3. Determine whether the conflict can be resolved mechanically from that hierarchy.
4. If yes, use the higher-ranked source and preserve historical evidence where appropriate.
5. If no, stop before Figma modification.
6. Report `NOT READY — do not modify Figma.`
7. State exactly what must be resolved.

Never silently rewrite architecture, ownership, authorization, freeze state, or historical evidence to make a task appear implementable.

---

## 13. Current Clinical Workspace exception

The current repository state contains an explicitly authorized Clinical Workspace architecture replacement.

Authoritative current state:

- Replacement architecture: `modules/clinical-workspace/ARCHITECTURE.md`
- Replacement field specification: `modules/clinical-workspace/FIELD_SPECIFICATION.md`
- Canonical composition: `Clinical Workspace — Phase 1 — Canonical`
- Replacement Figma implementation: **NOT IMPLEMENTED**
- Figma preflight: **NOT STARTED**
- Freeze: **NOT READY**

The previous `Clinical Workspace — Phase 1` Figma composition is historical/protected and is not the source of truth for the replacement architecture.

The next authorized operation is the strict Clinical Workspace Figma preflight. No Figma modification is authorized merely by the existence of the architecture exception.

---

## 14. Required interpretation behavior

Before any SmileFlow Figma write, Codex must be able to answer all of the following from the repository:

- What module am I changing?
- Who owns the affected data/workflow?
- What architecture is currently approved?
- What fields and actions are currently approved?
- Is the module frozen?
- Is there an applicable architecture exception?
- Is the requested change authorized in the current project state?
- Is there an existing exact-name conflict?
- Which existing Figma components must be reused?
- Which modules/components/tokens are protected from modification?
- What QA and audit obligations follow the change?

If any answer cannot be established safely, stop before writing to Figma.

---

## 15. Non-authoritative convenience rule

Convenience does not change authority.

A source may be easier to read, newer in file timestamp, closer to a Figma node, or more detailed than another source and still be non-authoritative.

Authority is determined by the rules in this document, not by convenience.

---

## 16. Maintenance rule

When the repository governance model changes, update this document in the same change set as the governance change whenever practical.

Do not create a new competing source-of-truth document without explicitly updating this authority map.
