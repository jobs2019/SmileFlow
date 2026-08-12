# SmileFlow Local Supabase Runtime Initialization

## Purpose

Run the reconstructed SmileFlow database baseline locally for disposable RLS/Auth QA. This environment must never use production patient data or production Auth users.

## Prerequisites

- Docker Desktop installed and running
- Supabase CLI installed
- Git
- Repository checked out locally

## Initialize

From the repository root:

```bash
supabase start
supabase db reset
```

`db reset` applies the reconstructed baseline in `supabase/migrations/` to the local database.

## Verify

Run:

```bash
supabase status
supabase db diff
```

The local database should contain the 17 SmileFlow application tables and the reconstructed RLS/policy layer.

## Important safety rule

Do not point the local environment at the production project. Do not import production patient data. Do not create disposable test users in the production Auth environment.

## Expected next step

After `supabase db reset` succeeds, run the local schema parity checks and then create disposable Auth/clinic fixtures for RLS behavioral QA.

## Current limitation

ChatGPT cannot start Docker on the user's computer through the connected GitHub/Supabase tools. Therefore local runtime execution must be performed on the development machine. This file is the canonical reproducible procedure.
