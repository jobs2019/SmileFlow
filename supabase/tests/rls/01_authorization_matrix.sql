-- SmileFlow development-only RLS behavioral test specification.
-- Run against a LOCAL/DEVELOPMENT Supabase instance with disposable Auth fixtures.
-- Do not run against the production project.

begin;

-- Each test runner must establish a real Auth identity/session before executing
-- the corresponding assertions. The examples below intentionally document the
-- required matrix rather than creating production users.

-- AUTHENTICATION
-- anonymous -> application tables: DENY
-- authenticated user without clinic membership -> clinic-owned resources: DENY

-- CLINIC ISOLATION
-- Dentist A / Clinic A -> Clinic A patient: ALLOW SELECT
-- Dentist A / Clinic A -> Clinic B patient: DENY SELECT
-- Dentist A / Clinic A -> INSERT with clinic_id = Clinic B: DENY
-- Dentist A / Clinic A -> UPDATE Clinic A row to clinic_id = Clinic B: DENY

-- ROLE AUTHORIZATION
-- Receptionist A -> appointment SELECT/INSERT/UPDATE in Clinic A: ALLOW
-- Receptionist A -> restricted clinical INSERT/UPDATE: DENY
-- Dental Assistant A -> permitted clinical INSERT/UPDATE: ALLOW
-- Dentist A -> diagnoses/performed procedures/treatment planning: ALLOW
-- Dentist A -> Clinical Closure INSERT: ALLOW
-- Administrator A -> administrator-authorized operations: ALLOW

-- AUDIT INTEGRITY
-- authenticated Clinic A member with actor_user_id = auth.uid(): ALLOW INSERT
-- authenticated Clinic A member with actor_user_id != auth.uid(): DENY INSERT
-- non-authorized user -> audit event SELECT: DENY
-- client UPDATE/DELETE audit events: DENY

-- DELETE PROTECTION
-- client DELETE on patients, visits, diagnoses, performed_procedures,
-- treatment plans/items, clinical closures, documents, and audit events: DENY

rollback;
