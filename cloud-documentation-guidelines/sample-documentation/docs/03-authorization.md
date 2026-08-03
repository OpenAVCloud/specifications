# 3. Authorization

Authentication proves *who* you are; authorization controls *what* you may do. Access is
governed by **scopes** on your token and by **tenant ownership** of resources.

## Scopes

| Scope | Grants |
|---|---|
| `displays:read` | List and read displays; read status/telemetry. |
| `displays:control` | Send commands and update displays. Includes read. |

Request only the scopes you need (least privilege). A token missing a required scope
receives `403 Forbidden`.

## Per-operation requirements

| Operation | Required scope |
|---|---|
| `GET /displays`, `GET /displays/{id}`, `GET /displays/{id}/status` | `displays:read` |
| `PATCH /displays/{id}`, `POST /displays/{id}/commands` | `displays:control` |
| `GET /health` | none (public) |

These are declared per-operation in [`../openapi.yaml`](../openapi.yaml) under `security`.

## Multi-tenancy & resource ownership

- Every display belongs to exactly one **tenant** (the organization that owns your client).
- A token can only see and act on displays owned by its tenant.
- Requesting a display owned by another tenant returns `404 Not Found` (not `403`), so the
  API never discloses the existence of other tenants' resources.

## Permission errors

| Situation | Response |
|---|---|
| No/expired/invalid token | `401 Unauthorized` |
| Valid token, missing scope | `403 Forbidden` (`code: FORBIDDEN`) |
| Valid token, resource owned by another tenant | `404 Not Found` |

See [Errors](./05-errors.md) for the response body format.
