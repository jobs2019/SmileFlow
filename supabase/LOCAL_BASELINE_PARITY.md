# SmileFlow Phase 2 — Local Supabase Baseline Parity

## Status

**PARTIAL PASS — source/schema parity verified; local runtime reproduction not yet executed.**

This document deliberately does not claim a local Supabase PASS because the connected tooling can inspect the cloud project and repository but does not execute Docker/Supabase CLI on the user's workstation.

## Source of truth used for this audit

- Live SmileFlow Supabase project inspected on 2026-08-13.
- Reconstructed migration: `supabase/migrations/20260813000000_reconstructed_baseline.sql`.
- This migration is explicitly a reconstructed baseline, not the original 0001–0011 migration history.

## Verified

### Application tables

The live project contains 17 SmileFlow application tables and the reconstructed baseline defines the same 17:

1. users
2. clinics
3. clinic_memberships
4. patients
5. appointments
6. visits
7. teeth
8. procedure_definitions
9. clinical_notes
10. diagnoses
11. dental_chart_findings
12. performed_procedures
13. treatment_plans
14. planned_treatment_items
15. clinical_closures
16. audit_events
17. documents

### Tenant boundary

The reconstructed baseline preserves the live clinic-scoped relationship model, including composite clinic/entity foreign-key relationships used to prevent cross-clinic references.

### Identity

The baseline preserves the `auth.users` → `public.users` identity relationship and the SmileFlow role/membership enums:

- dentist
- dental_assistant
- receptionist
- administrator

### Clinical lifecycle

The baseline preserves the live visit states:

- scheduled
- checked_in
- waiting
- called
- in_treatment
- ready_for_closure
- closed

Treatment item states and clinical closure outcomes are also represented according to the inspected live schema.

### RLS

All 17 application tables are RLS-enabled in the live project. The reconstructed baseline contains the corresponding RLS/policy layer intended for local authorization testing.

## Important limitation

A true **local reproduction test** requires running:

```text
supabase start
supabase db reset
```

(or the equivalent local Docker/Supabase CLI workflow) on the developer machine.

That execution has not been performed through the connected tools in this session. Therefore:

> **Do not mark local schema parity as PASS yet.**

## Required next validation

Run the reconstructed migration against a disposable local Supabase instance and compare:

- table names
- columns and data types
- nullability/defaults
- primary keys
- foreign keys
- unique constraints
- check constraints
- indexes
- functions
- triggers
- RLS enabled state
- RLS policies
- application enums

Only after those checks pass should disposable Auth fixtures be created.

## Safety rule

Never apply the reconstructed baseline to the production SmileFlow project as a replacement for migrations 0001–0011.
