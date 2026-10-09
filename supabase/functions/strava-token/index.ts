import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const STRAVA_TOKEN_URL = 'https://www.strava.com/oauth/token'

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, content-type',
      },
    })
  }

  try {
    const authHeader = req.headers.get('authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization' }), {
        status: 401,
      })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { authorization: authHeader } } }
    )

    const { data: { user }, error: userError } = await supabase.auth.getUser()
    if (userError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
      })
    }

    // Fetch stored tokens.
    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: tokens, error: fetchError } = await adminClient
      .from('strava_tokens')
      .select()
      .eq('user_id', user.id)
      .single()

    if (fetchError || !tokens) {
      return new Response(
        JSON.stringify({ error: 'No Strava connection found' }),
        { status: 404 }
      )
    }

    const now = Math.floor(Date.now() / 1000)

    // If token is still valid, return it.
    if (tokens.expires_at > now + 60) {
      return new Response(
        JSON.stringify({ access_token: tokens.access_token }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Token expired — refresh it.
    const clientId = Deno.env.get('STRAVA_CLIENT_ID')
    const clientSecret = Deno.env.get('STRAVA_CLIENT_SECRET')

    const refreshRes = await fetch(STRAVA_TOKEN_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        client_id: clientId,
        client_secret: clientSecret,
        refresh_token: tokens.refresh_token,
        grant_type: 'refresh_token',
      }),
    })

    if (!refreshRes.ok) {
      const body = await refreshRes.text()
      return new Response(
        JSON.stringify({ error: 'Strava refresh failed', detail: body }),
        { status: 502 }
      )
    }

    const refreshData = await refreshRes.json()

    // Persist refreshed tokens.
    await adminClient
      .from('strava_tokens')
      .update({
        access_token: refreshData.access_token,
        refresh_token: refreshData.refresh_token,
        expires_at: refreshData.expires_at,
      })
      .eq('user_id', user.id)

    return new Response(
      JSON.stringify({ access_token: refreshData.access_token }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), { status: 500 })
  }
})
