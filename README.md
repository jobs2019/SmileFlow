# SmileFlow — Codex Knowledge Base

Version-controlled knowledge base for SmileFlow's Figma implementation workflow.

## Core files
- `AGENTS.md` — Codex operating rules
- `DESIGN.md` — design-system/Figma rules
- `PROJECT_STATE.md` — current project state and next authorized action
- `SOURCE_OF_TRUTH.md` — repository authority map (planned governance file)
- `modules/` — module architecture and specifications
- `governance/` — frozen-module registry and architecture exceptions
- `templates/` — reusable documentation templates

## Module lifecycle
Architecture → Field Specification → Phase 1 Implementation → Structural QA → Visual & UX Audit → Minimal Polish if authorized → Final Re-audit → FREEZE.

Do not skip phases. Do not infer authorization from historical implementation artifacts.

## Current state
- Patient Management — FROZEN
- Patient Registration — FROZEN / IMPLEMENTED + POLISHED
- Dental Chart — Phase 1 — Canonical — FROZEN
- Treatment Planning — Phase 1 — Canonical — FROZEN
- Clinical Closure — Phase 1 — Canonical — FROZEN
- Shared Visit — Phase 1 — Canonical — FROZEN
- Performed Procedure — Phase 1 — Canonical — FROZEN
- Clinical Record History — Phase 1 — FROZEN
- Clinical Workspace — architecture replacement APPROVED; replacement Figma implementation NOT IMPLEMENTED; pre-flight NOT STARTED

## Current authorized next step
Run the strict Clinical Workspace Phase 1 Figma pre-flight against the replacement architecture and field specification. Do not modify Figma unless that pre-flight passes and implementation is separately authorized.

## Source-of-truth rule
Current project state and approved specifications override stale or superseded implementation artifacts. Historical reports and audits remain useful as history but must not authorize Figma changes.

Do not invent missing specifications.
