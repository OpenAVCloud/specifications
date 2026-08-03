# 8. Pagination, Filtering & Sorting

`GET /displays` is a collection endpoint and uses **cursor-based** pagination.

## Pagination

| Parameter | In | Default | Max | Notes |
|---|---|---|---|---|
| `limit` | query | 25 | 100 | Items per page. |
| `cursor` | query | — | — | Opaque cursor from the previous page's `meta.nextCursor`. |

Each response carries a `meta` object:

```json
{
  "data": [ /* Display[] */ ],
  "meta": { "nextCursor": "eyJvIjoyNX0", "total": 42 }
}
```

- Fetch the next page by passing `cursor=<meta.nextCursor>`.
- `nextCursor` is `null` on the last page.
- `total` is the count of items matching the current filter (may be `null` for very large sets).

**Example — page two:**

```bash
curl -s "https://api.example-openav.com/v1/displays?limit=25&cursor=eyJvIjoyNX0" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

## Filtering

| Parameter | Values | Effect |
|---|---|---|
| `status` | `online` \| `offline` | Return only displays with that connectivity status. |

## Sorting

| Parameter | Values | Effect |
|---|---|---|
| `sort` | `name`, `-name`, `createdAt`, `-createdAt` | Sort field; `-` prefix = descending. Default `name`. |

Filtering and sorting can be combined with pagination; the cursor preserves them across pages.
