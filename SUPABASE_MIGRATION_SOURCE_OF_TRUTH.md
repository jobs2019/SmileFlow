# SmileFlow — Supabase Migration Source of Truth

## Status

**Recovery audit completed: 2026-08-13.**

The connected SmileFlow Supabase project reports exactly 11 applied migrations. The migration registry is authoritative for the applied versions and names.

| Sequence | Applied version | Migration name | Source SQL in GitHub |
|---:|---|---|---|
| 0001 | 20260812165646 | `0001_database_foundation` | Not recovered |
| 0002 | 20260812165821 | `0002_identity_clinic_membership` | Not recovered |
| 0003 | 20260812170259 | `0003_patients` | Not recovered |
| 0004 | 20260812220458 | `0004_appointments_visits` | Not recovered |
| 0005 | 20260812220931 | `0005_clinical_foundation` | Not recovered |
| 0006 | 20260812221250 | `0006_performed_procedures` | Not recovered |
| 0007 | 20260812221638 | `0007_treatment_planning` | Not recovered |
| 0008 | 20260812221952 | `0008_clinical_closure` | Not recovered |
| 0009 | 20260812222305 | `0009_audit_events_document_storage` | Not recovered |
| 0010 | 20260812222449 | `0010_rls_policies` | Not recovered |
| 0011 | 20260812222734 | `0011_rls_policy_hardening` | Not recovered |

## Important finding

Supabase exposes the applied migration registry and current database schema through the connected project, but the migration tool available to this workflow does not expose the original SQL bodies of historical migrations.

Therefore we must **not** pretend that the exact historical migration files have been recovered.

The current cloud database is the authoritative runtime schema. The migration registry is the authoritative record of which migrations were applied. The original SQL bodies must be reconstructed from their actual source or from an exact schema export before being committed as canonical migration files.

## Current public schema inventory

The connected project currently contains these 17 SmileFlow application tables:

- `appointments`
- `audit_events`
- `clinic_memberships`
- `clinical_closures`
- `clinical_notes`
- `clinics`
- `dental_chart_findings`
- `diagnoses`
- `documents`
- `patients`
- `performed_procedures`
- `planned_treatment_items`
- `procedure_definitions`
- `teeth`
- `treatment_plans`
- `users`
- `visits`

## Source-of-truth rule

Until exact migration source is recovered:

1. Do not fabricate historical migration SQL.
2. Do not create a second, guessed migration history in GitHub.
3. Do not reset the production project.
4. Do not create a paid Supabase development branch solely to recover migration source.
5. Do not treat an inferred schema dump as identical to the original migration history.
6. Local Supabase initialization must wait until a reproducible migration source has been established.

## Next recovery options

Preferred order:

1. Recover the original SQL files from the machine/session/repository that executed migrations 0001–0011.
2. If those files cannot be recovered, generate an exact schema reconstruction from the live project and explicitly label it as a **reconstructed baseline**, not historical migration source.
3. Commit the recovered/reconstructed baseline into `supabase/migrations/` and verify a clean local reset reproduces the expected schema.

This document exists to prevent schema drift and to keep Codex/agents from inventing migration history.