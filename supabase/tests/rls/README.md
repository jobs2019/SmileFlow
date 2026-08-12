# SmileFlow RLS Behavioral QA

These tests are **development-only**. They must run against a local/development Supabase instance, never the production SmileFlow project.

## Test identities

- Dentist A — Clinic A
- Dental Assistant A — Clinic A
- Receptionist A — Clinic A
- Administrator A — Clinic A
- Dentist B — Clinic B
- Authenticated user with no clinic membership
- Anonymous request

## Required assertions

1. Authentication boundary: anonymous access is denied.
2. Clinic isolation: Clinic A users cannot read or write Clinic B resources.
3. Receptionists can use scheduling operations but cannot write restricted clinical records.
4. Dental assistants can perform only the clinical operations explicitly granted by policy.
5. Dentists can perform dentist-authorized clinical operations, including Clinical Closure creation.
6. Audit event inserts require `actor_user_id = auth.uid()` and an active clinic membership.
7. Client DELETE access is denied for SmileFlow application tables.
8. INSERT and UPDATE tests must exercise `WITH CHECK`, including attempted cross-clinic writes.
9. Clinical Closure creation does not itself mutate Visit state; state transition belongs to the transaction layer.

## Execution boundary

The repository fixture is the source for repeatable local QA. Do not create permanent fake users or fake patient data in the production Supabase project.

Recommended execution uses Supabase local development and database tests/pgTAP. Real Auth API tests should use disposable local Auth users and real authenticated sessions.
