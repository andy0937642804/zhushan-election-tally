-- 竹山鎮鎮民代表第一選區 雲端同步資料庫
-- 先將下方管理者 Email 改成你自己的 Supabase Auth 登入 Email，再於 SQL Editor 執行。

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

drop policy if exists "public read tally" on public.election_tally;
create policy "public read tally"
on public.election_tally for select
to anon, authenticated
using (id = 'main');

-- 只有下方指定的管理者 Email 可以更新票數。
drop policy if exists "admin write tally" on public.election_tally;
create policy "admin write tally"
on public.election_tally for update
to authenticated
using (
  id = 'main'
  and (auth.jwt() ->> 'email') = 'andy0937642804@gmail.com'
)
with check (
  id = 'main'
  and (auth.jwt() ->> 'email') = 'andy0937642804@gmail.com'
);

revoke all on table public.election_tally from anon, authenticated;
grant select on table public.election_tally to anon, authenticated;
grant update on table public.election_tally to authenticated;

-- Realtime 啟用：若表格已加入 publication，則不重複加入。
do $ begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'election_tally'
  ) then
    alter publication supabase_realtime add table public.election_tally;
  end if;
end $;
