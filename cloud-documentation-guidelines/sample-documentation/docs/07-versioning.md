# 7. Versioning & Lifecycle

## Strategy

- The API is versioned in the **URL path**: `/v1`, `/v2`, …
- The spec follows **semantic versioning** (`MAJOR.MINOR.PATCH`); the current spec version
  is shown in `info.version` and in the docs header.

## What counts as breaking

| Non-breaking (same major) | Breaking (new major) |
|---|---|
| Adding an endpoint | Removing/renaming an endpoint or field |
| Adding an optional field | Making an optional field required |
| Adding a new enum value *(clients must tolerate unknown values)* | Changing a field's type or meaning |
| Adding a new error `code` | Changing auth or error format |

Clients **should** ignore unknown fields and tolerate new enum values so that
non-breaking changes never break them.

## Deprecation & sunset policy

- Deprecated versions/endpoints are announced at least **90 days** before sunset.
- Deprecated responses carry standard headers:

```http
Deprecation: Sat, 01 Nov 2025 00:00:00 GMT
Sunset: Sun, 01 Feb 2026 00:00:00 GMT
Link: <https://developer.example-openav.com/changelog#v2>; rel="successor-version"
```

- After the `Sunset` date the version returns `410 Gone`.

## Changelog & notifications

- All changes are recorded in [`../CHANGELOG.md`](../CHANGELOG.md) and on the portal.
- Subscribe via the **RSS feed** (`https://developer.example-openav.com/changelog.rss`) or
  the **announcements mailing list** (portal → *Notifications*). Breaking changes and
  sunsets are additionally emailed to all registered developers.
