-- MedStudy Planner: per-user cloud storage with Row Level Security (RLS)
-- Run this entire script in Supabase Dashboard -> SQL Editor -> New query.

create table if not exists public.medstudy_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"tasks":[],"notes":[],"settings":{},"moved":0}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.medstudy_data enable row level security;

drop policy if exists "Users can read their own MedStudy data" on public.medstudy_data;
create policy "Users can read their own MedStudy data"
  on public.medstudy_data for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert their own MedStudy data" on public.medstudy_data;
create policy "Users can insert their own MedStudy data"
  on public.medstudy_data for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own MedStudy data" on public.medstudy_data;
create policy "Users can update their own MedStudy data"
  on public.medstudy_data for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

grant select, insert, update on public.medstudy_data to authenticated;
