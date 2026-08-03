# Changelog

All notable changes to the OpenAV Display Cloud API are documented here.
The API follows [semantic versioning](./docs/07-versioning.md); breaking changes ship
under a new major version path (e.g., `/v2`).

Subscribe to changes: developer portal RSS feed at
`https://developer.example-openav.com/changelog.rss` or the announcements mailing list.

## [1.0.0] — 2026-07-08
### Added
- Initial public release.
- `GET /health`, `GET /displays`, `GET /displays/{id}`, `PATCH /displays/{id}`,
  `GET /displays/{id}/status`, `POST /displays/{id}/commands`.
- Webhooks: `display.status_changed`, `display.online`, `display.offline`.
- OAuth 2.0 client-credentials auth with `displays:read` / `displays:control` scopes.
- RFC 9457 error format and full error catalog.
- Rate limiting with `RateLimit-*` headers.
