-- SmileFlow Phase 2 — Final Database Schema Delta
--
-- STATUS: EXECUTABLE FOR DISPOSABLE/LOCAL QA ONLY
-- AUTHORIZATION: Phase 2 Database Migration Implementation Authorization
-- SOURCE BASELINE: 20260813000000_reconstructed_baseline.sql
-- TARGET SPEC: PHASE_2_FINAL_DATABASE_MIGRATION_SPECIFICATION.md
--
-- IMPORTANT:
-- 1. This migration is intentionally fail-closed on unexpected/non-empty data
--    for changes that require a semantic backfill.
-- 2. It is NOT a production deployment script.
-- 3. It must be executed only against the disposable/local Docker QA database
--    until the full schema/RLS/runtime verification suite passes.
-- 4. It does not create Auth users or modify application data outside the
--    explicitly reconciled schema delta.

begin;

set local lock_timeout = '10s';
set local statement_timeout = '60s';

-- ============================================================================
-- 0. PRE-FLIGHT: fail closed if the expected reconstructed baseline is absent
-- ============================================================================

do $$
begin
  if to_regclass('public.users') is null
     or to_regclass('public.patients') is null
     or to_regclass('public.appointments') is null
     or to_regclass('public.visits') is null
     or to_regclass('public.treatment_plans') is null
     or to_regclass('public.planned_treatment_items') is null then
    raise exception
      'SmileFlow Phase 2 migration aborted: expected reconstructed baseline tables are missing';
  end if;

  if to_regtype('public.smileflow_user_status') is null
     or to_regtype('public.smileflow_role') is null then
    raise exception
      'SmileFlow Phase 2 migration aborted: expected SmileFlow enum types are missing';
  end if;
end;
$$;

-- ============================================================================
-- 1. MB-01 — User status domain
-- Target: active / inactive / disabled
-- ============================================================================

do $$
begin
  if not exists (
    select 1
    from pg_enum e
    join pg_type t on t.oid = e.enumtypid
    join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public'
      and t.typname = 'smileflow_user_status'
      and e.enumlabel = 'disabled'
  ) then
    alter type public.smileflow_user_status add value 'disabled';
  end if;
end;
$$;

-- ============================================================================
-- 2. MB-04 — users.email
-- Auth remains the identity authority. public.users.email is the application
-- copy. No independent UNIQUE constraint is invented here.
-- ============================================================================

alter table public.users
  add column if not exists email text;

-- If this environment contains users, require an authoritative Auth email
-- before enforcing NOT NULL. Never invent a placeholder email.
do $$
begin
  if exists (
    select 1
    from public.users u
    left join auth.users au on au.id = u.id
    where u.email is null
      and au.email is null
  ) then
    raise exception
      'SmileFlow Phase 2 migration aborted: one or more users have no authoritative Auth email for users.email backfill';
  end if;
end;
$$;

update public.users u
set email = au.email
from auth.users au
where au.id = u.id
  and u.email is null
  and au.email is not null;

-- Fail closed if any application user still lacks email.
do $$
begin
  if exists (select 1 from public.users where email is null) then
    raise exception
      'SmileFlow Phase 2 migration aborted: public.users.email still contains NULL values';
  end if;
end;
$$;

alter table public.users
  alter column email set not null;

-- ============================================================================
-- 3. MB-05 — users.display_name NOT NULL
-- No placeholder/default is permitted.
-- ============================================================================

do $$
begin
  if exists (select 1 from public.users where display_name is null) then
    raise exception
      'SmileFlow Phase 2 migration aborted: users.display_name contains NULL values; resolve through the approved provisioning/profile source first';
  end if;
end;
$$;

alter table public.users
  alter column display_name set not null;

-- ============================================================================
-- 4. MB-02 — Patient status
-- Canonical target: active / archived.
-- Existing inactive rows are a semantic migration decision and therefore cause
-- a fail-closed abort rather than an invented inactive -> archived mapping.
-- ============================================================================

do $$
begin
  if exists (select 1 from public.patients where status = 'inactive') then
    raise exception
      'SmileFlow Phase 2 migration aborted: patients.status contains inactive rows; explicit conversion policy required';
  end if;
end;
$$;

-- Replace the recovered-baseline status CHECK without relying on the generated
-- constraint name.
do $$
declare
  c record;
begin
  for c in
    select conname
    from pg_constraint
    where conrelid = 'public.patients'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) like '%status%'
      and pg_get_constraintdef(oid) like '%archived%'
  loop
    execute format('alter table public.patients drop constraint %I', c.conname);
  end loop;
end;
$$;

alter table public.patients
  add constraint patients_status_check_phase2
  check (status in ('active','archived'));

-- ============================================================================
-- 5. Patient core delta
-- ============================================================================

alter table public.patients
  add column if not exists suffix text;

-- Canonicalize the recovered date_of_birth field without duplicating the
-- concept. Fail closed if an unexpected birth_date column already exists.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'patients'
      and column_name = 'birth_date'
  ) and exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'patients'
      and column_name = 'date_of_birth'
  ) then
    raise exception
      'SmileFlow Phase 2 migration aborted: both patients.birth_date and patients.date_of_birth exist; manual reconciliation required';
  elsif exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'patients'
      and column_name = 'date_of_birth'
  ) then
    alter table public.patients rename column date_of_birth to birth_date;
  elsif not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'patients'
      and column_name = 'birth_date'
  ) then
    alter table public.patients add column birth_date date;
  end if;
end;
$$;

-- ============================================================================
-- 6. MB-07 / Appointment provider
-- ============================================================================

alter table public.appointments
  add column if not exists provider_user_id uuid;

-- A provider must be an existing application user. Clinic membership is
-- enforced below by a fail-closed trigger because membership is tenant-scoped.

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.appointments'::regclass
      and conname = 'appointments_provider_user_fk_phase2'
  ) then
    alter table public.appointments
      add constraint appointments_provider_user_fk_phase2
      foreign key (provider_user_id)
      references public.users(id)
      on delete restrict;
  end if;
end;
$$;

-- ============================================================================
-- 7. MB-03 + Visit core delta
-- visit_date is timestamptz NOT NULL.
-- ============================================================================

alter table public.visits
  add column if not exists provider_user_id uuid;

alter table public.visits
  add column if not exists visit_date timestamptz;

alter table public.visits
  add column if not exists visit_type text;

alter table public.visits
  add column if not exists chair text;

-- Fail closed rather than guessing a backfill for visit_date in a non-empty DB.
do $$
begin
  if exists (select 1 from public.visits where visit_date is null) then
    raise exception
      'SmileFlow Phase 2 migration aborted: visits.visit_date requires an approved backfill for existing rows';
  end if;
end;
$$;

alter table public.visits
  alter column visit_date set not null;

-- Provider must resolve to an application user.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.visits'::regclass
      and conname = 'visits_provider_user_fk_phase2'
  ) then
    alter table public.visits
      add constraint visits_provider_user_fk_phase2
      foreign key (provider_user_id)
      references public.users(id)
      on delete restrict;
  end if;
end;
$$;

-- ============================================================================
-- 8. Provider clinic-membership enforcement
-- This deliberately uses a trigger because a simple provider_user_id -> users.id
-- FK cannot establish same-clinic membership.
-- ============================================================================

create or replace function public.validate_provider_clinic_membership()
returns trigger
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
begin
  if new.provider_user_id is not null then
    if not exists (
      select 1
      from public.clinic_memberships cm
      where cm.clinic_id = new.clinic_id
        and cm.user_id = new.provider_user_id
        and cm.status = 'active'
    ) then
      raise exception
        'Provider % is not an active member of clinic %',
        new.provider_user_id,
        new.clinic_id
        using errcode = '23514';
    end if;
  end if;

  return new;
end;
$$;

revoke all on function public.validate_provider_clinic_membership() from public;

drop trigger if exists appointments_validate_provider_clinic on public.appointments;
create trigger appointments_validate_provider_clinic
before insert or update of provider_user_id, clinic_id
on public.appointments
for each row
execute function public.validate_provider_clinic_membership();

drop trigger if exists visits_validate_provider_clinic on public.visits;
create trigger visits_validate_provider_clinic
before insert or update of provider_user_id, clinic_id
on public.visits
for each row
execute function public.validate_provider_clinic_membership();

-- ============================================================================
-- 9. Treatment Plan
-- ============================================================================

alter table public.treatment_plans
  add column if not exists title text;

-- Current inspected baseline is empty. For any non-empty database, title must
-- be supplied by an approved application/backfill source; do not invent one.
do $$
begin
  if exists (select 1 from public.treatment_plans where title is null) then
    raise exception
      'SmileFlow Phase 2 migration aborted: treatment_plans.title contains NULL values; approved title backfill required';
  end if;
end;
$$;

alter table public.treatment_plans
  alter column title set not null;

-- Explicitly do NOT add treatment_plans.status.

-- ============================================================================
-- 10. Planned Treatment Items
-- ============================================================================

alter table public.planned_treatment_items
  add column if not exists sequence integer;

-- Existing description NULLs cannot be guessed.
do $$
begin
  if exists (select 1 from public.planned_treatment_items where description is null) then
    raise exception
      'SmileFlow Phase 2 migration aborted: planned_treatment_items.description contains NULL values; approved backfill required';
  end if;
end;
$$;

alter table public.planned_treatment_items
  alter column description set not null;

-- Preserve the existing four-state lifecycle and explicitly guard against
-- introduction of non-canonical states.
do $$
declare
  c record;
begin
  for c in
    select conname
    from pg_constraint
    where conrelid = 'public.planned_treatment_items'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) like '%status%'
      and pg_get_constraintdef(oid) like '%planned%'
  loop
    execute format('alter table public.planned_treatment_items drop constraint %I', c.conname);
  end loop;
end;
$$;

alter table public.planned_treatment_items
  add constraint planned_treatment_items_status_check_phase2
  check (status in ('planned','scheduled','in_progress','completed'));

-- Preserve the recovered completed_at consistency rule.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.planned_treatment_items'::regclass
      and conname = 'planned_treatment_items_completed_at_check_phase2'
  ) then
    alter table public.planned_treatment_items
      add constraint planned_treatment_items_completed_at_check_phase2
      check (
        (status = 'completed' and completed_at is not null)
        or
        (status <> 'completed' and completed_at is null)
      );
  end if;
end;
$$;

-- ============================================================================
-- 11. MB-06 — canonical has_clinic_role() signature
--
-- PostgreSQL function identity includes argument types. The reconstructed
-- baseline uses text[]; the approved live contract uses smileflow_role[].
-- We create the canonical overload without dropping the legacy function here,
-- because RLS policies may still depend on the old signature. Policy rewiring is
-- a separate verified RLS deployment step.
-- ============================================================================

create or replace function public.has_clinic_role(
  p_clinic_id uuid,
  p_roles public.smileflow_role[]
)
returns boolean
language sql
security definer
stable
set search_path = pg_catalog, pg_temp
as $$
  select exists (
    select 1
    from public.clinic_memberships cm
    where cm.clinic_id = p_clinic_id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
      and cm.role = any (p_roles)
  );
$$;

revoke all on function public.has_clinic_role(uuid, public.smileflow_role[]) from public;

grant execute on function public.has_clinic_role(uuid, public.smileflow_role[]) to authenticated;

-- ============================================================================
-- 12. Verification assertions before COMMIT
-- ============================================================================

do $$
begin
  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.users'::regclass
      and attname = 'email'
      and not attisdropped
      and attnotnull
  ) then
    raise exception 'Verification failed: users.email is not NOT NULL';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.users'::regclass
      and attname = 'display_name'
      and not attisdropped
      and attnotnull
  ) then
    raise exception 'Verification failed: users.display_name is not NOT NULL';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.patients'::regclass
      and attname = 'birth_date'
      and not attisdropped
  ) then
    raise exception 'Verification failed: patients.birth_date is missing';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.appointments'::regclass
      and attname = 'provider_user_id'
      and not attisdropped
  ) then
    raise exception 'Verification failed: appointments.provider_user_id is missing';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.visits'::regclass
      and attname = 'visit_date'
      and not attisdropped
      and attnotnull
  ) then
    raise exception 'Verification failed: visits.visit_date is missing or nullable';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.treatment_plans'::regclass
      and attname = 'title'
      and not attisdropped
      and attnotnull
  ) then
    raise exception 'Verification failed: treatment_plans.title is missing or nullable';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.planned_treatment_items'::regclass
      and attname = 'sequence'
      and not attisdropped
  ) then
    raise exception 'Verification failed: planned_treatment_items.sequence is missing';
  end if;

  if not exists (
    select 1 from pg_attribute
    where attrelid = 'public.planned_treatment_items'::regclass
      and attname = 'description'
      and not attisdropped
      and attnotnull
  ) then
    raise exception 'Verification failed: planned_treatment_items.description is not NOT NULL';
  end if;
end;
$$;

commit;

-- ============================================================================
-- POST-COMMIT NOTE
-- ============================================================================
-- RLS policy deployment, transition RPCs/functions, audit-event enforcement,
-- Auth provisioning/synchronization, and full Clinic A/B + role-isolation QA
-- are intentionally separate verification gates. This migration changes the
-- schema contract; it does not claim that clinical workflow security is fully
-- verified merely because the DDL commits successfully.
