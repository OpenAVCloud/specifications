# 5. Errors

Errors are part of the contract. Every error uses a single, consistent body:
**RFC 9457 Problem Details**, with media type `application/problem+json`.

## Error body

```json
{
  "type": "https://developer.example-openav.com/errors/display-offline",
  "title": "Display is offline",
  "status": 409,
  "detail": "The display cannot accept commands while offline.",
  "code": "DISPLAY_OFFLINE",
  "instance": "/v1/displays/6f1c.../commands"
}
```

| Field | Meaning |
|---|---|
| `type` | URI identifying the problem type (dereferenceable docs). |
| `title` | Short, stable human-readable summary. |
| `status` | HTTP status code. |
| `detail` | Explanation specific to this occurrence. |
| `code` | Stable application error code (table below). |
| `instance` | Path of this specific occurrence. |

## HTTP status codes

| Code | When |
|---|---|
| `200` | Successful read/update. |
| `202` | Command accepted (asynchronous). |
| `400` | Malformed request (bad JSON, wrong parameter type). |
| `401` | Missing/expired/invalid token. |
| `403` | Authenticated but missing required scope. |
| `404` | Unknown resource, or resource owned by another tenant. |
| `409` | State conflict (e.g., command to an offline display). |
| `422` | Well-formed but semantically invalid (e.g., unsupported input). |
| `429` | Rate limit / quota exceeded — see [Rate limits](./06-rate-limits.md). |
| `500` | Unexpected server error. |
| `503` | Service temporarily unavailable (see `Retry-After`). |

## Application error catalog

| `code` | HTTP | Meaning | Resolution |
|---|---|---|---|
| `BAD_REQUEST` | 400 | Request could not be parsed. | Fix request syntax/parameters. |
| `UNAUTHORIZED` | 401 | Not authenticated. | Obtain/refresh a token. |
| `FORBIDDEN` | 403 | Token lacks the required scope. | Request the needed scope. |
| `NOT_FOUND` | 404 | Resource does not exist for this tenant. | Verify the ID. |
| `DISPLAY_OFFLINE` | 409 | Command sent to an offline display. | Wait for `display.online`, then retry. |
| `INVALID_INPUT_SOURCE` | 422 | Input not supported by this model. | Use a value from `DisplayStatus.input`. |
| `RATE_LIMITED` | 429 | Too many requests. | Back off using `Retry-After`. |
| `INTERNAL_ERROR` | 500 | Server-side failure. | Retry with backoff; contact support if persistent. |
| `SERVICE_UNAVAILABLE` | 503 | Temporary outage. | Retry after `Retry-After`. |

Each operation lists exactly which of these it can return — see the `responses` of every
operation in [`../openapi.yaml`](../openapi.yaml).
