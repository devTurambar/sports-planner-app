-- Strava OAuth tokens, one row per user.
create table if not exists strava_tokens (
  user_id    uuid primary key references auth.users on delete cascade,
  athlete_id bigint not null,
  access_token  text not null,
  refresh_token text not null,
  expires_at    bigint not null,  -- Unix epoch seconds
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- Auto-bump updated_at on every update (reuse existing trigger function).
create trigger strava_tokens_updated_at
  before update on strava_tokens
  for each row execute function update_updated_at();

-- RLS: users can only read/update their own row.
alter table strava_tokens enable row level security;

create policy "Users read own strava tokens"
  on strava_tokens for select
  using (auth.uid() = user_id);

create policy "Users insert own strava tokens"
  on strava_tokens for insert
  with check (auth.uid() = user_id);

create policy "Users update own strava tokens"
  on strava_tokens for update
  using (auth.uid() = user_id);

create policy "Users delete own strava tokens"
  on strava_tokens for delete
  using (auth.uid() = user_id);
