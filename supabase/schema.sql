-- ─────────────────────────────────────────────
-- HearIt – Supabase Schema
-- Run this in the Supabase SQL Editor (once)
-- ─────────────────────────────────────────────

-- 1. TABLES

create table if not exists categories (
  id              text primary key,
  name_en         text not null,
  name_ar         text not null,
  icon            text not null,
  color_hex       text not null,
  total_questions int  not null default 0
);

create table if not exists questions (
  id            text primary key,
  category_id   text not null references categories(id) on delete cascade,
  audio_url     text not null,
  correct_index int  not null check (correct_index between 0 and 3),
  hint_en       text not null,
  hint_ar       text not null,
  created_at    timestamptz default now()
);

create table if not exists answers (
  id          text primary key,
  question_id text not null references questions(id) on delete cascade,
  text_en     text not null,
  text_ar     text not null,
  sort_order  int  not null check (sort_order between 0 and 3)
);

create table if not exists scores (
  id                  uuid        default gen_random_uuid() primary key,
  player_name         text        not null,
  category_id         text        not null references categories(id),
  score               int         not null,
  questions_answered  int         not null,
  created_at          timestamptz default now()
);

-- 2. LEADERBOARD VIEW (adds rank per category)

create or replace view leaderboard as
select
  id::text,
  rank() over (partition by category_id order by score desc)::int as rank,
  player_name,
  score,
  category_id,
  questions_answered,
  created_at
from scores;

-- 3. SUBMIT SCORE FUNCTION (insert + return rank atomically)

create or replace function submit_score(
  p_player_name        text,
  p_category_id        text,
  p_score              int,
  p_questions_answered int
)
returns json
language plpgsql
security definer
as $$
declare
  v_rank  bigint;
  v_total bigint;
begin
  insert into scores (player_name, category_id, score, questions_answered)
  values (p_player_name, p_category_id, p_score, p_questions_answered);

  select count(*) + 1 into v_rank
  from scores
  where category_id = p_category_id and score > p_score;

  select count(*) into v_total
  from scores
  where category_id = p_category_id;

  return json_build_object('rank', v_rank, 'total_players', v_total);
end;
$$;

-- 4. ROW LEVEL SECURITY

alter table categories enable row level security;
alter table questions  enable row level security;
alter table answers    enable row level security;
alter table scores     enable row level security;

-- Public read for categories / questions / answers / leaderboard
create policy "public read categories" on categories for select using (true);
create policy "public read questions"  on questions  for select using (true);
create policy "public read answers"    on answers    for select using (true);
create policy "public read scores"     on scores     for select using (true);

-- Anyone can insert a score (anonymous play)
create policy "public insert scores" on scores for insert with check (true);
