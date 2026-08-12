-- SmileFlow reconstructed database baseline
-- STATUS: RECONSTRUCTED BASELINE — NOT ORIGINAL MIGRATION HISTORY
-- Source: live SmileFlow Supabase project inspected 2026-08-13.
-- Purpose: reproducible local development / RLS QA.
-- Do not apply this file to the production project as a replacement for 0001-0011.

create extension if not exists pgcrypto;

create type public.smileflow_user_status as enum ('active','inactive');
create type public.smileflow_role as enum ('dentist','dental_assistant','receptionist','administrator');
create type public.smileflow_membership_status as enum ('active','inactive');

create table public.users (
  id uuid primary key references auth.users(id) on delete restrict,
  display_name text,
  status public.smileflow_user_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.clinics (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  status text not null default 'active' check (status in ('active','inactive')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.clinic_memberships (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  user_id uuid not null references public.users(id) on delete restrict,
  role public.smileflow_role not null,
  status public.smileflow_membership_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.patients (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_number text not null,
  first_name text not null,
  middle_name text,
  last_name text not null,
  preferred_name text,
  date_of_birth date,
  sex text check (sex is null or sex in ('female','male','intersex','prefer_not_to_say','unspecified')),
  civil_status text check (civil_status is null or civil_status in ('single','married','widowed','separated','divorced','unknown')),
  contact_number text,
  email text,
  address text,
  emergency_contact_name text,
  emergency_contact_number text,
  status text not null default 'active' check (status in ('active','inactive','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references public.users(id) on delete restrict,
  updated_by uuid references public.users(id) on delete restrict,
  unique (clinic_id,id),
  unique (clinic_id,patient_number)
);

create table public.appointments (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  scheduled_start timestamptz not null,
  scheduled_end timestamptz,
  appointment_type text,
  reason text,
  status text not null default 'scheduled' check (status in ('scheduled','confirmed','completed','cancelled','no_show')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references public.users(id) on delete restrict,
  updated_by uuid references public.users(id) on delete restrict,
  unique (clinic_id,id),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict
);

create table public.visits (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  appointment_id uuid,
  visit_state text not null default 'scheduled' check (visit_state in ('scheduled','checked_in','waiting','called','in_treatment','ready_for_closure','closed')),
  started_at timestamptz,
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references public.users(id) on delete restrict,
  updated_by uuid references public.users(id) on delete restrict,
  unique (clinic_id,id),
  unique (clinic_id,patient_id,id),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict,
  foreign key (clinic_id,appointment_id) references public.appointments(clinic_id,id) on delete restrict
);

create table public.teeth (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  notation_system text not null,
  tooth_code text not null,
  dentition text,
  created_at timestamptz not null default now(),
  unique (clinic_id,patient_id,id),
  unique (clinic_id,patient_id,notation_system,tooth_code),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict
);

create table public.procedure_definitions (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  code text,
  name text not null,
  status text not null default 'active' check (status in ('active','inactive')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (clinic_id,id),
  unique (clinic_id,code)
);

create table public.clinical_notes (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  visit_id uuid not null,
  author_user_id uuid not null references public.users(id) on delete restrict,
  note_text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  foreign key (clinic_id,patient_id,visit_id) references public.visits(clinic_id,patient_id,id) on delete restrict
);

create table public.diagnoses (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  visit_id uuid not null,
  tooth_id uuid,
  diagnosis_code text,
  diagnosis_label text not null,
  recorded_by uuid not null references public.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  foreign key (clinic_id,patient_id,visit_id) references public.visits(clinic_id,patient_id,id) on delete restrict,
  foreign key (clinic_id,patient_id,tooth_id) references public.teeth(clinic_id,patient_id,id) on delete restrict
);

create table public.dental_chart_findings (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  tooth_id uuid,
  finding_type text not null,
  finding_value text,
  recorded_by uuid not null references public.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict,
  foreign key (clinic_id,patient_id,tooth_id) references public.teeth(clinic_id,patient_id,id) on delete restrict
);

create table public.performed_procedures (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  visit_id uuid not null,
  procedure_definition_id uuid references public.procedure_definitions(id) on delete restrict,
  tooth_id uuid,
  performed_by uuid not null references public.users(id) on delete restrict,
  description text not null,
  quantity numeric(12,3) check (quantity is null or quantity > 0),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid not null references public.users(id) on delete restrict,
  updated_by uuid not null references public.users(id) on delete restrict,
  foreign key (clinic_id,patient_id,visit_id) references public.visits(clinic_id,patient_id,id) on delete restrict,
  foreign key (clinic_id,patient_id,tooth_id) references public.teeth(clinic_id,patient_id,id) on delete restrict
);

create table public.treatment_plans (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid not null references public.users(id) on delete restrict,
  updated_by uuid not null references public.users(id) on delete restrict,
  unique (clinic_id,patient_id,id),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict
);

create table public.planned_treatment_items (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null,
  patient_id uuid not null,
  treatment_plan_id uuid not null,
  procedure_definition_id uuid,
  tooth_id uuid,
  title text not null,
  description text,
  status text not null default 'planned' check (status in ('planned','scheduled','in_progress','completed')),
  planned_for date,
  completed_at timestamptz,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid not null references public.users(id) on delete restrict,
  updated_by uuid not null references public.users(id) on delete restrict,
  foreign key (clinic_id,patient_id,treatment_plan_id) references public.treatment_plans(clinic_id,patient_id,id) on delete restrict,
  foreign key (clinic_id,procedure_definition_id) references public.procedure_definitions(clinic_id,id) on delete restrict,
  foreign key (clinic_id,patient_id,tooth_id) references public.teeth(clinic_id,patient_id,id) on delete restrict,
  check ((status = 'completed' and completed_at is not null) or (status <> 'completed' and completed_at is null))
);

create table public.clinical_closures (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null,
  patient_id uuid not null,
  visit_id uuid not null,
  outcome text not null check (outcome in ('completed_as_planned','completed_with_modification','not_completed','treatment_continues')),
  summary text not null,
  closed_by uuid not null references public.users(id) on delete restrict,
  closed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid not null references public.users(id) on delete restrict,
  updated_by uuid not null references public.users(id) on delete restrict,
  unique (clinic_id,visit_id),
  foreign key (clinic_id,patient_id,visit_id) references public.visits(clinic_id,patient_id,id) on delete restrict
);

create table public.audit_events (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  actor_user_id uuid references public.users(id) on delete restrict,
  event_type text not null,
  resource_type text not null,
  resource_id uuid,
  action text not null check (action in ('create','read','update','delete','transition','login','logout','export','upload','download','other')),
  metadata jsonb not null default '{}'::jsonb,
  occurred_at timestamptz not null default now()
);

create table public.documents (
  id uuid primary key default gen_random_uuid(),
  clinic_id uuid not null references public.clinics(id) on delete restrict,
  patient_id uuid,
  visit_id uuid,
  uploaded_by uuid not null references public.users(id) on delete restrict,
  bucket_id text not null default 'smileflow-documents',
  storage_path text not null,
  file_name text not null,
  mime_type text,
  file_size_bytes bigint check (file_size_bytes is null or file_size_bytes >= 0),
  document_type text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  foreign key (clinic_id,patient_id) references public.patients(clinic_id,id) on delete restrict,
  foreign key (clinic_id,patient_id,visit_id) references public.visits(clinic_id,patient_id,id) on delete restrict
);

create index clinic_memberships_user_clinic_idx on public.clinic_memberships(user_id,clinic_id);
create index patients_clinic_name_idx on public.patients(clinic_id,last_name,first_name);
create index appointments_clinic_start_idx on public.appointments(clinic_id,scheduled_start);
create index appointments_clinic_patient_idx on public.appointments(clinic_id,patient_id,scheduled_start);
create index visits_clinic_patient_idx on public.visits(clinic_id,patient_id,created_at);
create index visits_clinic_state_idx on public.visits(clinic_id,visit_state,created_at);
create index teeth_clinic_patient_idx on public.teeth(clinic_id,patient_id);
create index procedure_definitions_clinic_status_idx on public.procedure_definitions(clinic_id,status);
create index clinical_notes_clinic_visit_idx on public.clinical_notes(clinic_id,patient_id,visit_id,created_at);
create index diagnoses_clinic_visit_idx on public.diagnoses(clinic_id,patient_id,visit_id,created_at);
create index dental_chart_findings_clinic_patient_idx on public.dental_chart_findings(clinic_id,patient_id,created_at);
create index performed_procedures_clinic_visit_idx on public.performed_procedures(clinic_id,visit_id,created_at);
create index performed_procedures_clinic_patient_idx on public.performed_procedures(clinic_id,patient_id,created_at);
create index performed_procedures_clinic_tooth_idx on public.performed_procedures(clinic_id,patient_id,tooth_id,created_at);
create index treatment_plans_clinic_patient_idx on public.treatment_plans(clinic_id,patient_id,created_at);
create index planned_treatment_items_clinic_plan_idx on public.planned_treatment_items(clinic_id,patient_id,treatment_plan_id,created_at);
create index planned_treatment_items_clinic_status_idx on public.planned_treatment_items(clinic_id,patient_id,status);
create index planned_treatment_items_clinic_tooth_idx on public.planned_treatment_items(clinic_id,patient_id,tooth_id);
create index clinical_closures_clinic_patient_idx on public.clinical_closures(clinic_id,patient_id,closed_at);
create index clinical_closures_clinic_visit_idx on public.clinical_closures(clinic_id,visit_id);
create index audit_events_clinic_occurred_idx on public.audit_events(clinic_id,occurred_at);
create index audit_events_resource_idx on public.audit_events(clinic_id,resource_type,resource_id,occurred_at);
create index documents_clinic_patient_idx on public.documents(clinic_id,patient_id,created_at);
create index documents_clinic_visit_idx on public.documents(clinic_id,patient_id,visit_id,created_at);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

create or replace function public.is_clinic_member(p_clinic_id uuid)
returns boolean language sql security definer stable set search_path = public, pg_temp as $$
  select exists (select 1 from public.clinic_memberships cm where cm.clinic_id=p_clinic_id and cm.user_id=auth.uid() and cm.status='active');
$$;

create or replace function public.has_clinic_role(p_clinic_id uuid, p_roles text[])
returns boolean language sql security definer stable set search_path = public, pg_temp as $$
  select exists (select 1 from public.clinic_memberships cm where cm.clinic_id=p_clinic_id and cm.user_id=auth.uid() and cm.status='active' and cm.role::text=any(p_roles));
$$;

revoke all on function public.is_clinic_member(uuid) from public;
revoke all on function public.has_clinic_role(uuid,text[]) from public;
grant execute on function public.is_clinic_member(uuid) to authenticated;
grant execute on function public.has_clinic_role(uuid,text[]) to authenticated;

create trigger users_set_updated_at before update on public.users for each row execute function public.set_updated_at();
create trigger clinics_set_updated_at before update on public.clinics for each row execute function public.set_updated_at();
create trigger clinic_memberships_set_updated_at before update on public.clinic_memberships for each row execute function public.set_updated_at();
create trigger patients_set_updated_at before update on public.patients for each row execute function public.set_updated_at();
create trigger appointments_set_updated_at before update on public.appointments for each row execute function public.set_updated_at();
create trigger visits_set_updated_at before update on public.visits for each row execute function public.set_updated_at();
create trigger procedure_definitions_set_updated_at before update on public.procedure_definitions for each row execute function public.set_updated_at();
create trigger clinical_notes_set_updated_at before update on public.clinical_notes for each row execute function public.set_updated_at();
create trigger diagnoses_set_updated_at before update on public.diagnoses for each row execute function public.set_updated_at();
create trigger dental_chart_findings_set_updated_at before update on public.dental_chart_findings for each row execute function public.set_updated_at();
create trigger performed_procedures_set_updated_at before update on public.performed_procedures for each row execute function public.set_updated_at();
create trigger treatment_plans_set_updated_at before update on public.treatment_plans for each row execute function public.set_updated_at();
create trigger planned_treatment_items_set_updated_at before update on public.planned_treatment_items for each row execute function public.set_updated_at();
create trigger clinical_closures_set_updated_at before update on public.clinical_closures for each row execute function public.set_updated_at();
create trigger documents_set_updated_at before update on public.documents for each row execute function public.set_updated_at();

alter table public.users enable row level security;
alter table public.clinics enable row level security;
alter table public.clinic_memberships enable row level security;
alter table public.patients enable row level security;
alter table public.appointments enable row level security;
alter table public.visits enable row level security;
alter table public.teeth enable row level security;
alter table public.procedure_definitions enable row level security;
alter table public.clinical_notes enable row level security;
alter table public.diagnoses enable row level security;
alter table public.dental_chart_findings enable row level security;
alter table public.performed_procedures enable row level security;
alter table public.treatment_plans enable row level security;
alter table public.planned_treatment_items enable row level security;
alter table public.clinical_closures enable row level security;
alter table public.audit_events enable row level security;
alter table public.documents enable row level security;

create policy users_select_self on public.users for select to authenticated using (id=auth.uid());
create policy users_update_self on public.users for update to authenticated using (id=auth.uid()) with check (id=auth.uid());
create policy clinics_select_member on public.clinics for select to authenticated using (public.is_clinic_member(id));
create policy memberships_select_self on public.clinic_memberships for select to authenticated using (user_id=auth.uid());

create policy patients_select_member on public.patients for select to authenticated using (public.is_clinic_member(clinic_id));
create policy patients_insert_staff on public.patients for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy patients_update_staff on public.patients for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy appointments_select_member on public.appointments for select to authenticated using (public.is_clinic_member(clinic_id));
create policy appointments_insert_staff on public.appointments for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator']));
create policy appointments_update_staff on public.appointments for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator']));

create policy visits_select_member on public.visits for select to authenticated using (public.is_clinic_member(clinic_id));
create policy visits_insert_clinical on public.visits for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy visits_update_clinical on public.visits for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy teeth_select_member on public.teeth for select to authenticated using (public.is_clinic_member(clinic_id));
create policy teeth_insert_clinical on public.teeth for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy teeth_update_clinical on public.teeth for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy procedure_definitions_select_member on public.procedure_definitions for select to authenticated using (public.is_clinic_member(clinic_id));
create policy procedure_definitions_insert_admin on public.procedure_definitions for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','administrator']));
create policy procedure_definitions_update_admin on public.procedure_definitions for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','administrator']));

create policy clinical_notes_select_member on public.clinical_notes for select to authenticated using (public.is_clinic_member(clinic_id));
create policy clinical_notes_insert_clinical on public.clinical_notes for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy clinical_notes_update_clinical on public.clinical_notes for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy diagnoses_select_member on public.diagnoses for select to authenticated using (public.is_clinic_member(clinic_id));
create policy diagnoses_insert_clinical on public.diagnoses for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','administrator']));
create policy diagnoses_update_clinical on public.diagnoses for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','administrator']));

create policy dental_findings_select_member on public.dental_chart_findings for select to authenticated using (public.is_clinic_member(clinic_id));
create policy dental_findings_insert_clinical on public.dental_chart_findings for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy dental_findings_update_clinical on public.dental_chart_findings for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy performed_select_member on public.performed_procedures for select to authenticated using (public.is_clinic_member(clinic_id));
create policy performed_insert_clinical on public.performed_procedures for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy performed_update_clinical on public.performed_procedures for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy plans_select_member on public.treatment_plans for select to authenticated using (public.is_clinic_member(clinic_id));
create policy plans_insert_clinical on public.treatment_plans for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy plans_update_clinical on public.treatment_plans for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy planned_items_select_member on public.planned_treatment_items for select to authenticated using (public.is_clinic_member(clinic_id));
create policy planned_items_insert_clinical on public.planned_treatment_items for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));
create policy planned_items_update_clinical on public.planned_treatment_items for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','administrator']));

create policy closures_select_member on public.clinical_closures for select to authenticated using (public.is_clinic_member(clinic_id));
create policy closures_insert_dentist on public.clinical_closures for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','administrator']));

create policy documents_select_member on public.documents for select to authenticated using (public.is_clinic_member(clinic_id));
create policy documents_insert_staff on public.documents for insert to authenticated with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator']));
create policy documents_update_staff on public.documents for update to authenticated using (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator'])) with check (public.has_clinic_role(clinic_id,array['dentist','dental_assistant','receptionist','administrator']));

create policy audit_select_admin on public.audit_events for select to authenticated using (public.has_clinic_role(clinic_id,array['dentist','administrator']));
create policy audit_insert_member on public.audit_events for insert to authenticated with check (public.is_clinic_member(clinic_id) and actor_user_id=auth.uid());

comment on table public.users is 'SmileFlow domain identity linked 1:1 to Supabase Auth users.';
comment on table public.clinics is 'SmileFlow clinic tenant boundary.';
comment on table public.clinic_memberships is 'Explicit user-to-clinic membership and role authorization context.';
comment on table public.patients is 'SmileFlow canonical longitudinal patient entity. Registration creates/captures; Patient Management manages/presents.';
comment on table public.appointments is 'Scheduled patient interaction. Distinct from an actual clinical visit/encounter.';
comment on table public.visits is 'Actual patient clinical encounter. Distinct from an appointment.';
comment on table public.teeth is 'Patient-specific structured tooth reference; supports notation such as FDI without making narrative text the primary tooth identity.';
comment on table public.procedure_definitions is 'Reusable procedure catalog definition; not a performed clinical event.';
comment on table public.clinical_notes is 'Narrative clinical documentation attached to a visit; structured clinical data belongs in dedicated tables.';
comment on table public.diagnoses is 'Structured clinical assessment attached to a visit; diagnosis vocabulary remains contract-controlled.';
comment on table public.dental_chart_findings is 'Persistent Dental Chart finding/state owned by the Dental Chart domain.';
comment on table public.performed_procedures is 'SmileFlow actual clinical work performed during a visit. Distinct from procedure definitions, planned treatment items, and clinical closure.';
comment on table public.treatment_plans is 'SmileFlow treatment plan container. Deliberately has no generic lifecycle/status field.';
comment on table public.planned_treatment_items is 'SmileFlow planned care items with lifecycle: planned, scheduled, in_progress, completed.';
comment on table public.clinical_closures is 'SmileFlow encounter-level clinical closure record. Creating a row does not itself perform the Visit state transition; runtime transaction logic must validate and atomically close the Visit.';
comment on table public.audit_events is 'Append-oriented SmileFlow audit trail. Application/runtime logic is responsible for writing authoritative events.';
comment on table public.documents is 'SmileFlow document metadata pointing to protected Supabase Storage objects. The database record is not the file itself.';
