-- Vilassa Conecta: tabela de solicitações de cadastro
-- Execute no SQL Editor do seu projeto Supabase.
create extension if not exists pgcrypto;

create table if not exists public.professionals (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 100),
  city text not null check (char_length(city) between 2 and 100),
  category text not null check (category in ('Casa e manutenção','Tecnologia','Design e artes','Veículos','Aulas e cursos','Serviços profissionais','Outros serviços')),
  phone text not null check (char_length(phone) between 8 and 30),
  description text not null default '' check (char_length(description) <= 1000),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

alter table public.professionals enable row level security;

drop policy if exists "Public can submit pending profiles" on public.professionals;
create policy "Public can submit pending profiles"
on public.professionals for insert
to anon, authenticated
with check (status = 'pending');

drop policy if exists "Public can view approved profiles" on public.professionals;
create policy "Public can view approved profiles"
on public.professionals for select
to anon, authenticated
using (status = 'approved');

-- Não crie política pública de UPDATE ou DELETE.
-- Aprove/rejeite solicitações pelo painel do Supabase, após autenticar como administrador.
