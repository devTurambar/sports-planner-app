import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import {
  adminClient,
  corsHeaders,
  freshAccessToken,
  getUser,
  json,
} from '../_shared/strava.ts'

// Unlinks Strava for the signed-in user: revokes Kadence's access on
// Strava (best effort) and deletes the stored tokens. Idempotent — safe
// to call when no connection exists.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    const user = await getUser(req)
    if (!user) return json({ error: 'Unauthorized' }, 401)

    const admin = adminClient()
    const { data: row } = await admin
      .from('strava_tokens')
      .select()
      .eq('user_id', user.id)
      .maybeSingle()

    let revoked = false
    if (row) {
      try {
        const token = await freshAccessToken(admin, row)
        const res = await fetch('https://www.strava.com/oauth/deauthorize', {
          method: 'POST',
          headers: { Authorization: `Bearer ${token}` },
        })
        revoked = res.ok
      } catch (_) {
        // Already revoked on Strava's side (or refresh failed) — still
        // delete our copy below.
      }
    }

    const { error } = await admin
      .from('strava_tokens')
      .delete()
      .eq('user_id', user.id)
    if (error) return json({ error: error.message }, 500)

    return json({ disconnected: true, revoked })
  } catch (e) {
    return json({ error: e.message }, 500)
  }
})
