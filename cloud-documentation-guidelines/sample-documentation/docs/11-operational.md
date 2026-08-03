# 11. Operational Behavior

How the API behaves in normal and degraded operation.

## Health

- `GET /health` (public) returns `{ "status": "ok" | "degraded", "time": "<RFC3339>" }`.
- Use it for readiness checks; do not poll more than once per 30 seconds.

## Timeouts & retries

- Server-side request timeout: **30 seconds**.
- **Retry** `429`, `500`, `502`, `503`, and network timeouts with **exponential backoff +
  jitter**. Respect `Retry-After` when present.
- Do **not** retry `4xx` other than `429` — fix the request instead.

## Idempotency

- `POST /displays/{id}/commands` accepts an **`Idempotency-Key`** header (a UUID).
- Retrying with the same key returns the original result instead of queuing a duplicate
  command. Keys are retained for **24 hours**, scoped per client + endpoint.
- Read (`GET`) and `PATCH` operations are naturally idempotent and need no key.

## Availability

- **SLA:** 99.9% monthly uptime for production (see portal → *SLA*).
- **Status page:** `https://status.example-openav.com` — subscribe for incident updates.
- **Incidents:** report suspected outages to `api@example-openav.com` or via the status page.
