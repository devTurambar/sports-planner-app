-- strava_tokens is server-only: the edge functions (strava-auth,
-- strava-token, strava-disconnect) use the service role, which bypasses
-- RLS. Dropping the client policies means the app can never read the
-- refresh token or write rows directly. RLS stays enabled with no
-- policies, so anon/authenticated roles get nothing.
drop policy if exists "Users read own strava tokens" on strava_tokens;
drop policy if exists "Users insert own strava tokens" on strava_tokens;
drop policy if exists "Users update own strava tokens" on strava_tokens;
drop policy if exists "Users delete own strava tokens" on strava_tokens;

revoke all on strava_tokens from anon, authenticated;
