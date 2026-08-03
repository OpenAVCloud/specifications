# 2. Authentication

The API uses **OAuth 2.0 client-credentials** (machine-to-machine). This documents the
scheme the API already uses — it does not prescribe how you build your integration.

## Obtaining credentials

1. Sign in to `https://developer.example-openav.com`.
2. Go to **Credentials → Create client**.
3. Copy the **client ID** and **client secret** (the secret is shown once).

## Getting a token

Exchange your client credentials at the token endpoint:

- **Token endpoint:** `POST https://auth.example-openav.com/oauth2/token`
- **Grant type:** `client_credentials`
- **Requested scopes:** space-separated (`displays:read`, `displays:control`)

```bash
curl -s https://auth.example-openav.com/oauth2/token \
  -d grant_type=client_credentials \
  -d scope="displays:read displays:control" \
  -u "$CLIENT_ID:$CLIENT_SECRET"
```

| Field | Value |
|---|---|
| `token_type` | `Bearer` |
| `expires_in` | `3600` seconds (1 hour) |

## Using a token

Send it on every request:

```http
Authorization: Bearer <access_token>
```

Tokens **must** be sent in the header — never in the URL or query string
(see [Security](./10-security.md)).

## Lifetime, refresh & rotation

- **Lifetime:** 3600 seconds. Request a new token when the current one nears expiry.
- **Refresh:** re-run the client-credentials request (there is no separate refresh token
  in this flow).
- **Rotation/revocation:** rotate a secret in the portal (**Credentials → Rotate**). The
  old secret keeps working for a 24-hour overlap, then stops. Revoked secrets stop
  immediately; existing tokens remain valid until they expire.

## Sandbox

Use the same flow against the sandbox; sandbox clients are separate from production
clients and only see synthetic displays.
