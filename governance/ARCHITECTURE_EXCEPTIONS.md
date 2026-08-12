# SmileFlow — Architecture Exceptions

Architecture exceptions are explicit authorizations that temporarily or permanently alter the normal protection rules. An exception does not by itself authorize a Figma write; implementation still requires the applicable pre-flight and phase authorization.

## Dental Chart
Existing legacy `Dental Chart — Phase 1` conflicted with the strict canonical name.
Authorized canonical name: `Dental Chart — Phase 1 — Canonical`.
Legacy `127:1110` remains untouched.

## Treatment Planning
Existing legacy `Treatment Planning — Phase 1` conflicted with the strict canonical name.
Authorized canonical name: `Treatment Planning — Phase 1 — Canonical`.
Legacy `136:1124` remains untouched.

## Clinical Workspace — architecture replacement
Previous Clinical Workspace Phase 1 architecture and field specification were superseded by an explicitly authorized replacement.

Authorization: APPROVED
Previous source of truth: `modules/clinical-workspace/ARCHITECTURE.md` and `modules/clinical-workspace/FIELD_SPECIFICATION.md` before the replacement update.
Replacement canonical composition: `Clinical Workspace — Phase 1 — Canonical`
Replacement Figma implementation: NOT IMPLEMENTED
Figma pre-flight: NOT STARTED

The previous Clinical Workspace Figma composition remains protected and must not be modified, deleted, renamed, duplicated, or repurposed as part of the replacement until the strict pre-flight passes and implementation is separately authorized.

## Exception rule
Future exceptions require explicit user authorization and must be recorded here before they are treated as project authority.
