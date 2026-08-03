# 4. Data Models

All models are defined once under `components/schemas` in [`../openapi.yaml`](../openapi.yaml)
and referenced from operations. JSON fields use `camelCase`; timestamps are RFC 3339 UTC.

## Display

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string (uuid) | yes | Unique display ID. |
| `name` | string (≤120) | yes | Human-friendly name. |
| `status` | enum `online`\|`offline` | yes | Connectivity status. |
| `model` | string \| null | no | Hardware model, if known. |
| `createdAt` | string (date-time) | yes | Registration time. |

## DisplayStatus

| Field | Type | Required | Notes |
|---|---|---|---|
| `power` | enum `on`\|`off`\|`standby` | yes | Current power state. |
| `input` | enum `hdmi1`\|`hdmi2`\|`usb-c` \| null | no | Active input; null when off. |
| `temperatureC` | number | yes | **Panel temperature in °C.** |

## Command (request body)

| Field | Type | Required | Notes |
|---|---|---|---|
| `type` | enum `power`\|`input` | yes | Command category. |
| `value` | string | yes | `power`: `on`\|`off`\|`standby`; `input`: `hdmi1`\|`hdmi2`\|`usb-c`. |

## DisplayUpdate (request body)

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string (1–120) | yes | New display name (only mutable field). |

## Collection envelope

List responses wrap items in `data` with pagination in `meta`:

```json
{ "data": [ /* Display[] */ ], "meta": { "nextCursor": null, "total": 1 } }
```

See [Pagination](./08-pagination.md). Units of measure: temperature is always **degrees
Celsius (°C)**.
