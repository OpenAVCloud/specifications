# 1. Getting Started

This walks you from zero to your first authenticated call in three steps.

## Prerequisites

- A developer account at `https://developer.example-openav.com`.
- An OAuth 2.0 **client ID** and **client secret** (create one in the portal → *Credentials*).
- Start in **sandbox** (`https://sandbox.api.example-openav.com/v1`) — it exposes synthetic
  displays and never touches real hardware.

## Step 1 — Get a token

```bash
curl -s https://auth.example-openav.com/oauth2/token \
  -d grant_type=client_credentials \
  -d scope="displays:read displays:control" \
  -u "$CLIENT_ID:$CLIENT_SECRET"
```

```json
{ "access_token": "eyJhbGci...", "token_type": "Bearer", "expires_in": 3600 }
```

## Step 2 — List displays

```bash
curl -s https://sandbox.api.example-openav.com/v1/displays \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

```json
{
  "data": [
    { "id": "6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12", "name": "Lobby Display",
      "status": "online", "model": "OAV-55X", "createdAt": "2026-01-04T09:00:00Z" }
  ],
  "meta": { "nextCursor": null, "total": 1 }
}
```

## Step 3 — Send a command

```bash
curl -s -X POST \
  https://sandbox.api.example-openav.com/v1/displays/6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12/commands \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Idempotency-Key: 3d9b2c1a-7e5f-4a2b-8c6d-1f0e9a8b7c6d" \
  -H "Content-Type: application/json" \
  -d '{ "type": "power", "value": "on" }'
```

```json
{ "commandId": "b2d4...", "displayId": "6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12", "status": "queued" }
```

Commands are asynchronous — watch for the `display.status_changed`
[webhook](./09-webhooks.md) to confirm completion.

## More example requests

Every remaining operation, ready to copy-paste (response examples live in
[`../openapi.yaml`](../openapi.yaml)):

```bash
# Get one display
curl -s https://sandbox.api.example-openav.com/v1/displays/6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12 \
  -H "Authorization: Bearer $ACCESS_TOKEN"

# Read its status & telemetry
curl -s https://sandbox.api.example-openav.com/v1/displays/6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12/status \
  -H "Authorization: Bearer $ACCESS_TOKEN"

# Rename it
curl -s -X PATCH https://sandbox.api.example-openav.com/v1/displays/6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12 \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "name": "Main Lobby Display" }'

# Service health (public, no auth)
curl -s https://sandbox.api.example-openav.com/v1/health
```

## Next

- [Authentication](./02-authentication.md) · [Authorization](./03-authorization.md)
- Full contract: [`../openapi.yaml`](../openapi.yaml)
