-- 竹山鎮鎮民代表第一選區 雲端同步資料庫
-- Supabase SQL Editor 執行

create table if not exists public.election_tally (
  id text primary key default 'main',
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid
);

insert into public.election_tally (id, data)
values ('main', '{}'::jsonb)
on conflict (id) do nothing;

alter table public.election_tally enable row level security;

-- 公開展示：允許讀取票數
drop policy if exists "public read tally" on public.election_tally;
create policy "public read tally"
on public.election_tally for select
to anon, authenticated
using (id = 'main');

-- 寫入僅限已登入管理者（Supabase Auth）
drop policy if exists "authenticated write tally" on public.election_tally;
create policy "authenticated write tally"
on public.election_tally for update
to authenticated
using (id = 'main')
with check (id = 'main');

-- 禁止匿名寫入
revoke insert, update, delete on public.election_tally from anon;
grant select on public.election_tally to anon, authenticated;
grant update on public.election_tally to authenticated;

-- 啟用 Realtime
alter publication supabase_realtime add table public.election_tally;
