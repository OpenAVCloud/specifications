# 10. Security

This documents the security behavior relevant to integrators. It describes how the API
behaves — it does not prescribe how you build your client.

## Transport

- **HTTPS only.** Plain HTTP requests are rejected (connection refused / redirect to HTTPS).
- **Minimum TLS 1.2.** TLS 1.3 is supported and preferred.

## Credentials

- Send the bearer token in the `Authorization` header only.
- Credentials and tokens are **never** accepted in the URL path or query string, and must
  not be logged there by clients.
- Rotate client secrets periodically (portal → *Credentials → Rotate*); see
  [Authentication](./02-authentication.md).

## CORS

- The API is intended for **server-to-server** use. Browser-based cross-origin requests
  are **not** enabled by default (no `Access-Control-Allow-Origin` for arbitrary origins).
- Do not embed client secrets in browser or mobile apps; use a backend to hold credentials.

## Sensitive data

- Payloads contain device metadata and telemetry only; no end-user PII is exchanged by
  this API.
- Webhook payloads are signed (`OpenAV-Signature`) — always verify before trusting them
  (see [Webhooks](./09-webhooks.md)).
