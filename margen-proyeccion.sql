-- Margen Abastecimiento: proyeccion vigente compartida
-- Ejecutar UNA VEZ en Supabase: SQL Editor > New query > pegar > Run.
-- Guarda una sola fila ('vigente') con la ultima proyeccion confirmada.

create table if not exists public.margen_proyeccion (
  id         text primary key,
  datos      jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.margen_proyeccion enable row level security;

grant select, insert, update on public.margen_proyeccion to anon;

-- Cualquiera con el enlace puede ver y guardar la proyeccion vigente.
-- Solo se permite la fila 'vigente' (no se pueden crear ni borrar otras filas).
drop policy if exists "margen_proyeccion lectura"    on public.margen_proyeccion;
drop policy if exists "margen_proyeccion insertar"   on public.margen_proyeccion;
drop policy if exists "margen_proyeccion actualizar" on public.margen_proyeccion;

create policy "margen_proyeccion lectura"
  on public.margen_proyeccion for select
  using (true);

create policy "margen_proyeccion insertar"
  on public.margen_proyeccion for insert
  with check (id = 'vigente');

create policy "margen_proyeccion actualizar"
  on public.margen_proyeccion for update
  using (id = 'vigente')
  with check (id = 'vigente');
