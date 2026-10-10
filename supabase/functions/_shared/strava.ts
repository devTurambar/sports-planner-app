import { createClient, SupabaseClient, User } from 'https://esm.sh/@supabase/supabase-js@2'

const STRAVA_TOKEN_URL = 'https://www.strava.com/oauth/token'

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
}

export function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}

/** Resolves the Kadence user from the request's Supabase session JWT. */
export async function getUser(req: Request): Promise<User | null> {
  const authHeader = req.headers.get('authorization')
  if (!authHeader) return null
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { authorization: authHeader } } },
  )
  const { data: { user }, error } = await supabase.auth.getUser()
  return error ? null : user
}

/** Service-role client — the only thing allowed to touch strava_tokens. */
export function adminClient(): SupabaseClient {
  return createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  )
}

export interface StravaTokenRow {
  user_id: string
  access_token: string
  refresh_token: string
  expires_at: number
}

/**
 * Returns a valid access token for [row], refreshing (and persisting the
 * new pair) when it expires within a minute. Throws on refresh failure.
 */
export async function freshAccessToken(
  admin: SupabaseClient,
  row: StravaTokenRow,
): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  if (row.expires_at > now + 60) return row.access_token

  const res = await fetch(STRAVA_TOKEN_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      client_id: Deno.env.get('STRAVA_CLIENT_ID'),
      client_secret: Deno.env.get('STRAVA_CLIENT_SECRET'),
      refresh_token: row.refresh_token,
      grant_type: 'refresh_token',
    }),
  })
  if (!res.ok) throw new Error(`Strava refresh failed: ${await res.text()}`)
  const data = await res.json()

  await admin
    .from('strava_tokens')
    .update({
      access_token: data.access_token,
      refresh_token: data.refresh_token,
      expires_at: data.expires_at,
    })
    .eq('user_id', row.user_id)

  return data.access_token
}
