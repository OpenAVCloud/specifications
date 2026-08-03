# OpenAV Display Cloud API — Developer Documentation

> **Reference example.** This folder is a complete, minimal documentation set for a
> fictional cloud (“OpenAV Display Cloud”) that manages **one** device type — a
> networked **Display**. It is intentionally small in functionality but exercises
> **every** requirement in the [OpenAV Technical Guidelines](../openav-technical-guidelines.md).
>
> **Spec version:** 1.0.0 · **Last updated:** 2026-07-08

## What this API does

Monitor and control OpenAV networked displays: list them, read status/telemetry
(power, input, panel temperature), send control commands (power, input), and receive
real-time changes via webhooks.

- **Base URL (prod):** `https://api.example-openav.com/v1`
- **Base URL (sandbox):** `https://sandbox.api.example-openav.com/v1`
- **Transport:** HTTPS only (TLS 1.2+) · **Media type:** `application/json` · **Errors:** `application/problem+json` (RFC 9457)
- **Machine-readable contract (source of truth):** [`openapi.yaml`](./openapi.yaml)

## Documentation index

| # | Topic | File |
|---|---|---|
| 1 | Getting started (first call) | [docs/01-getting-started.md](./docs/01-getting-started.md) |
| 2 | Authentication | [docs/02-authentication.md](./docs/02-authentication.md) |
| 3 | Authorization & scopes | [docs/03-authorization.md](./docs/03-authorization.md) |
| 4 | Data models | [docs/04-data-models.md](./docs/04-data-models.md) |
| 5 | Errors & error catalog | [docs/05-errors.md](./docs/05-errors.md) |
| 6 | Rate limits & quotas | [docs/06-rate-limits.md](./docs/06-rate-limits.md) |
| 7 | Versioning & lifecycle | [docs/07-versioning.md](./docs/07-versioning.md) |
| 8 | Pagination, filtering & sorting | [docs/08-pagination.md](./docs/08-pagination.md) |
| 9 | Webhooks & events | [docs/09-webhooks.md](./docs/09-webhooks.md) |
| 10 | Security | [docs/10-security.md](./docs/10-security.md) |
| 11 | Operational behavior | [docs/11-operational.md](./docs/11-operational.md) |
| — | Changelog | [CHANGELOG.md](./CHANGELOG.md) |
| — | Conformance to the OpenAV guideline | [docs/12-conformance.md](./docs/12-conformance.md) |

## Endpoints at a glance

| Method | Path | Scope | Purpose |
|---|---|---|---|
| `GET` | `/health` | — (public) | Service health |
| `GET` | `/displays` | `displays:read` | List displays (paged) |
| `GET` | `/displays/{id}` | `displays:read` | Get one display |
| `PATCH` | `/displays/{id}` | `displays:control` | Update a display |
| `GET` | `/displays/{id}/status` | `displays:read` | Status & telemetry |
| `POST` | `/displays/{id}/commands` | `displays:control` | Send a command |

**Webhooks:** `display.status_changed`, `display.online`, `display.offline` — see [docs/09-webhooks.md](./docs/09-webhooks.md).

## Support

Developer support: `api@example-openav.com` · Portal: `https://developer.example-openav.com`
