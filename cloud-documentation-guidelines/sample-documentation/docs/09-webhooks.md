# 9. Webhooks & Events

> Webhooks are **conditional** in the OpenAV guideline: they must be documented *because*
> this API offers them. An API without events would omit this section.

The API pushes events to an HTTPS endpoint you register. Events are also defined
machine-readably under `webhooks` in [`../openapi.yaml`](../openapi.yaml).

## Event catalog

| Event `type` | Trigger | Payload schema |
|---|---|---|
| `display.status_changed` | Power/input/temperature changed, or a command completed. | `DisplayStatusChangedEvent` |
| `display.online` | A display connected. | `DisplayConnectivityEvent` |
| `display.offline` | A display disconnected. | `DisplayConnectivityEvent` |

## Subscription

1. Portal → **Webhooks → Add endpoint**: provide an HTTPS URL and select event types.
2. Copy the generated **signing secret** (shown once).
3. To stop delivery, disable or delete the endpoint in the portal.

## Payload

```json
{
  "id": "evt_9a...",
  "type": "display.status_changed",
  "createdAt": "2026-07-08T10:16:00Z",
  "data": {
    "displayId": "6f1c9e2a-0d3b-4f7a-9c11-2a4b6d8e0f12",
    "status": { "power": "on", "input": "hdmi2", "temperatureC": 42.0 }
  }
}
```

## Delivery semantics

- **Guarantee:** at-least-once. De-duplicate on the event `id`.
- **Acknowledgement:** respond `2xx` within **5 seconds**.
- **Retries:** on non-2xx/timeout, redelivered with exponential backoff for up to **24 hours**.
- **Ordering:** not guaranteed; use `createdAt` to order and ignore stale updates.

## Verifying authenticity

Every delivery includes a signature header:

```http
OpenAV-Signature: t=1751971000,v1=6f2b...9c
```

- `t` — Unix timestamp of signing.
- `v1` — hex HMAC-SHA256 of `"{t}.{raw_request_body}"` using your endpoint's signing secret.

**Validate:** recompute the HMAC over `t` + `.` + the raw body, compare in constant time,
and reject if `t` is older than 5 minutes (replay protection).

```python
import hmac, hashlib, time
def valid(secret, header, raw_body):
    parts = dict(kv.split("=") for kv in header.split(","))
    t, sig = parts["t"], parts["v1"]
    if abs(time.time() - int(t)) > 300: return False
    expected = hmac.new(secret.encode(), f"{t}.{raw_body}".encode(), hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, sig)
```
