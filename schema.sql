-- Capital18 – baza de date
-- Rulează tot fișierul o singură dată în Supabase → SQL Editor → New query → Run.

-- Profilul fiecărui utilizator (elev sau profesor). Tot progresul stă în coloana "data".
create table public.profiles (
  id uuid primary key references auth.users on delete cascade,
  username text unique not null,
  role text not null default 'elev' check (role in ('elev','profesor')),
  class_code text,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Clasele create de profesori (cod, nume, teme).
create table public.classes (
  code text primary key,
  teacher uuid not null references auth.users on delete cascade default auth.uid(),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Permisiuni de acces pentru utilizatorii logați (proiectele Supabase noi nu le dau automat).
grant usage on schema public to authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.classes to authenticated;

-- Securitate: fiecare își modifică doar datele lui.
alter table public.profiles enable row level security;
alter table public.classes enable row level security;

create policy "utilizatorii logați văd profilurile" on public.profiles
  for select to authenticated using (true);
create policy "îmi creez profilul" on public.profiles
  for insert to authenticated with check (auth.uid() = id);
create policy "îmi editez profilul" on public.profiles
  for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "utilizatorii logați văd clasele" on public.classes
  for select to authenticated using (true);
create policy "profesorul își creează clasa" on public.classes
  for insert to authenticated with check (auth.uid() = teacher);
create policy "profesorul își editează clasa" on public.classes
  for update to authenticated using (auth.uid() = teacher) with check (auth.uid() = teacher);

-- Profesorul poate scoate un elev doar din clasele lui.
create function public.scoate_din_clasa(p_username text) returns void
language plpgsql security definer set search_path = '' as $$
begin
  update public.profiles
     set class_code = null,
         data = jsonb_set(data, '{classCode}', 'null'::jsonb),
         updated_at = now()
   where username = p_username
     and class_code in (select code from public.classes where teacher = auth.uid());
end;
$$;
revoke execute on function public.scoate_din_clasa(text) from public, anon;
grant execute on function public.scoate_din_clasa(text) to authenticated;

-- Verifică dacă un nume de utilizator e liber (folosit la înregistrare, înainte de login).
create or replace function public.username_liber(p_username text) returns boolean
language sql security definer set search_path = '' stable as $$
  select not exists (select 1 from public.profiles where username = lower(p_username));
$$;
grant execute on function public.username_liber(text) to anon, authenticated;
