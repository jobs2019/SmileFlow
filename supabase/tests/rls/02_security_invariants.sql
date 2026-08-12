-- SmileFlow development-only structural RLS assertions.
-- Requires pgTAP and a local/development Supabase database with SmileFlow migrations applied.

begin;

select plan(5);

select ok(
  (select count(*) from pg_class c
   join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public'
     and c.relname in (
       'users','clinics','clinic_memberships','patients','appointments','visits',
       'teeth','procedure_definitions','clinical_notes','diagnoses',
       'dental_chart_findings','performed_procedures','treatment_plans',
       'planned_treatment_items','clinical_closures','documents','audit_events'
     )
     and c.relrowsecurity) = 17,
  'all 17 SmileFlow application tables have RLS enabled'
);

select is(
  (select count(*)::integer from pg_policies
   where schemaname = 'public'
     and tablename in (
       'users','clinics','clinic_memberships','patients','appointments','visits',
       'teeth','procedure_definitions','clinical_notes','diagnoses',
       'dental_chart_findings','performed_procedures','treatment_plans',
       'planned_treatment_items','clinical_closures','documents','audit_events'
     )
     and roles::text like '%anon%'),
  0,
  'no SmileFlow application policy grants access to anon'
);

select is(
  (select count(*)::integer from pg_policies
   where schemaname = 'public'
     and tablename in (
       'users','clinics','clinic_memberships','patients','appointments','visits',
       'teeth','procedure_definitions','clinical_notes','diagnoses',
       'dental_chart_findings','performed_procedures','treatment_plans',
       'planned_treatment_items','clinical_closures','documents','audit_events'
     )
     and cmd = 'DELETE'),
  0,
  'no client DELETE policy exists for SmileFlow application tables'
);

select ok(
  exists (select 1 from pg_proc where proname = 'is_clinic_member' and pronamespace = 'public'::regnamespace),
  'clinic membership helper exists'
);

select ok(
  exists (select 1 from pg_proc where proname = 'has_clinic_role' and pronamespace = 'public'::regnamespace),
  'clinic role helper exists'
);

select * from finish();
rollback;
