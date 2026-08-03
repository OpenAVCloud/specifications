# 12. Conformance to the OpenAV Guideline

This maps every section of the
[OpenAV Technical Guidelines](../../openav-technical-guidelines.md) to where this sample
satisfies it — demonstrating full coverage.

| Guideline § | Requirement | Where satisfied here |
|---|---|---|
| 2 | OpenAPI 3.1.x, single machine-readable source of truth, validates cleanly, full surface | [`openapi.yaml`](../openapi.yaml) (`openapi: 3.1.0`; all 6 endpoints + webhooks) |
| 3 | `info`, `servers`, HTTPS, media type/encoding/date/naming | `openapi.yaml` `info`/`servers`; [README](../README.md); [security](./10-security.md) |
| 4 | Auth scheme declared + provisioning + token lifecycle | [02-authentication](./02-authentication.md); `securitySchemes.oauth2` |
| 5 | Scopes mapped, per-op `security`, tenancy, 403 documented | [03-authorization](./03-authorization.md); per-op `security` in spec |
| 6 | Every op: id/summary/tags/params/body/responses/examples | All paths in `openapi.yaml` (each has `operationId`, examples, full responses) |
| 7 | Reusable schemas, field types/required/nullability, enums, units | [04-data-models](./04-data-models.md); `components/schemas` (temperature in °C) |
| 8 | Full status-code coverage, consistent RFC 9457 body, error catalog | [05-errors](./05-errors.md); `components/responses` + `Problem` schema |
| 9 | Limits + communication + increase process | [06-rate-limits](./06-rate-limits.md); `RateLimit-*` headers in spec |
| 10 | Versioning, compatibility, deprecation/sunset, changelog, notifications | [07-versioning](./07-versioning.md); [CHANGELOG](../CHANGELOG.md) |
| 11 | Pagination pattern, filtering, sorting, default/max sizes | [08-pagination](./08-pagination.md); `PageCursor`/`PageLimit` params |
| 12 | Webhooks: catalog, subscription, delivery, verification *(conditional — API has events)* | [09-webhooks](./09-webhooks.md); `webhooks` in spec |
| 13 | TLS, no secrets in URL, CORS, sensitive data | [10-security](./10-security.md) |
| 14 | Health, timeouts, retries, idempotency keys, SLA/status | [11-operational](./11-operational.md); `/health`, `Idempotency-Key` |
| 15 | Examples + quickstart + tooling | [01-getting-started](./01-getting-started.md); examples on every operation |
| 16 | Reachable, in-sync, lint-clean, last-updated + version visible | [README](../README.md) (version + date); docs generated from spec |
| 17 | Submit valid OpenAPI 3.1.x to OpenAV | [`openapi.yaml`](../openapi.yaml) is the submittable artifact |

Every **MUST** in [Appendix C](../../openav-technical-guidelines.md#appendix-c--conformance-checklist)
of the guideline is exercised by this example.
