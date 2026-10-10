import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  adminClient,
  corsHeaders,
  freshAccessToken,
  getUser,
  json,
} from '../_shared/strava.ts'

// Returns a valid Strava access token for the signed-in user, refreshing
// it server-side when expired. The refresh token never leaves the server.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    const user = await getUser(req)
    if (!user) return json({ error: 'Unauthorized' }, 401)

    const admin = adminClient()
    const { data: row, error } = await admin
      .from('strava_tokens')
      .select()
      .eq('user_id', user.id)
      .single()
    if (error || !row) {
      return json({ error: 'No Strava connection found' }, 404)
    }

    try {
      return json({ access_token: await freshAccessToken(admin, row) })
    } catch (e) {
      return json({ error: 'Strava refresh failed', detail: e.message }, 502)
    }
  } catch (e) {
    return json({ error: e.message }, 500)
  }
})
