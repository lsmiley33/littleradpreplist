-- Kitchen Prep Manager — Supabase Schema
-- Run this in your Supabase SQL Editor

create table if not exists staff (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz default now()
);

create table if not exists prep_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  section text not null,
  mins integer not null default 10,
  unit_qty numeric not null default 1,
  sort_order integer default 0,
  created_at timestamptz default now()
);

create table if not exists prep_days (
  id uuid primary key default gen_random_uuid(),
  prep_date date not null unique,
  scheduled_hours numeric,
  saved_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists prep_assignments (
  id uuid primary key default gen_random_uuid(),
  prep_date date not null,
  item_id uuid references prep_items(id) on delete cascade,
  qty numeric,
  assigned_to text,
  notes text,
  created_at timestamptz default now(),
  unique(prep_date, item_id)
);

-- Allow public read/write (no login required — each store has its own Supabase project)
alter table staff enable row level security;
alter table prep_items enable row level security;
alter table prep_days enable row level security;
alter table prep_assignments enable row level security;

create policy "public access" on staff for all using (true) with check (true);
create policy "public access" on prep_items for all using (true) with check (true);
create policy "public access" on prep_days for all using (true) with check (true);
create policy "public access" on prep_assignments for all using (true) with check (true);
