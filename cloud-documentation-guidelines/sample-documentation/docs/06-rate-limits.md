# 6. Rate Limits & Other Limits

Limits let you design a well-behaved integration before you hit a wall.

## Rate limits

| Limit | Value | Window | Scope |
|---|---|---|---|
| API requests | 600 | 60 s (rolling) | per access token |
| Commands (`POST .../commands`) | 60 | 60 s | per display |
| Health checks (`GET /health`, unauthenticated) | 2 | 60 s | per source IP |

## How limits are communicated

Every response includes rate-limit headers:

| Header | Meaning |
|---|---|
| `RateLimit-Limit` | Requests allowed in the current window. |
| `RateLimit-Remaining` | Requests remaining. |
| `RateLimit-Reset` | Seconds until the window resets. |

When you exceed a limit you receive `429 Too Many Requests` with a `Retry-After` header:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 30
RateLimit-Limit: 600
RateLimit-Remaining: 0
RateLimit-Reset: 30
Content-Type: application/problem+json

{ "type": "https://developer.example-openav.com/errors/rate-limited",
  "title": "Rate limit exceeded", "status": 429, "code": "RATE_LIMITED" }
```

**Handle it:** wait `Retry-After` seconds, then retry with exponential backoff and jitter.

## Other limits

| Limit | Value |
|---|---|
| Max request body size | 64 KB |
| Pagination `limit` | default 25, max 100 |
| Concurrent in-flight commands | 5 per display |

## Requesting an increase

Rate limits and quotas can be raised for production workloads. Open a request at
**developer portal → Support → Limit increase**, or email `api@example-openav.com` with
your client ID, the limit, and expected volume. Typical turnaround is 2 business days.
