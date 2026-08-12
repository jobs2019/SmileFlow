# SmileFlow Local Supabase

This directory is the local development source for SmileFlow database and RLS QA.

## Baseline status

`migrations/20260813000000_reconstructed_baseline.sql` is a **RECONSTRUCTED BASELINE — NOT ORIGINAL MIGRATION HISTORY**.

It was reconstructed from the live SmileFlow Supabase schema after confirming that the original SQL bodies for migrations 0001–0011 were not available through the connected migration registry.

The live migration registry remains authoritative for historical deployment order:

1. 0001_database_foundation
2. 0002_identity_clinic_membership
3. 0003_patients
4. 0004_appointments_visits
5. 0005_clinical_foundation
6. 0006_performed_procedures
7. 0007_treatment_planning
8. 0008_clinical_closure
9. 0009_audit_events_document_storage
10. 0010_rls_policies
11. 0011_rls_policy_hardening

Do not rewrite production migration history using the reconstructed file.

## Purpose

The reconstructed baseline exists so we can run:

- local PostgreSQL schema validation
- disposable Auth fixtures
- RLS behavioral tests
- storage authorization tests
- CI database tests

without creating a paid Supabase development branch.

## Safety rules

- Never put production secrets in this directory.
- Never use production patient data as local fixtures.
- Never disable RLS to make a test pass.
- Never use the service role to claim client authorization works.
- Any schema drift discovered between local and cloud must be documented and reconciled explicitly.
