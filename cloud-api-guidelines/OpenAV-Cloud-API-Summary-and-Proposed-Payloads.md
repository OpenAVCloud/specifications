# OpenAV Cloud-to-Cloud REST API: Summary and Proposed Payloads

Document Version: 0.1 (Draft)
Prepared by: OpenAVCloud Technical Working Group
Date: April 13, 2026

## 1.0 Purpose

This document provides a concise summary of the OpenAV Cloud-to-Cloud REST API specification (v0.3) and proposes concrete JSON payloads for the defined endpoints. The proposed payloads are derived from the capabilities and device categories defined in the following companion specifications:

- **AV Device Taxonomy Guidelines** (v1.1) -- defines the device categories and subcategories
- **AV Device Minimum Functionality Guidelines** (v1.1) -- defines the minimum data and features each device must expose

These payloads are proposals for discussion and are not normative.

## 2.0 API Summary

### 2.1 Design Principles

The API is RESTful, stateless, and JSON-based. It uses resource-oriented URLs and follows a **capability-centric model** where devices expose discrete capabilities rather than monolithic device-specific interfaces. This aligns with the Open-Closed Principle: integrators write code against capabilities, not specific device models.

### 2.2 Key Technical Decisions

| Area | Decision |
|---|---|
| Versioning | URL path (`/v1/...`), optional per-endpoint versioning |
| Authentication | OAuth 2.0, Client Credentials Grant (RFC 6749 section 4.4), Bearer tokens |
| Transport | HTTPS required, TLS 1.2+ |
| Error Format | RFC 9457 problem details |
| Pagination | Cursor/ID-based, not index-based |
| Date/Time | ISO-8601, UTC |
| Batching | OData-style JSON |
| Events | Event-driven preferred (webhooks, WebSockets, callbacks) |
| Documentation | OpenAPI specification required |
| Discoverability | HATEOAS-style links where appropriate |

### 2.3 Defined Endpoints (Initial Scope)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/v1/devices` | Paginated list of devices with filtering and sorting |
| GET | `/v1/devices/{deviceId}/capabilities` | Capabilities supported by a specific device |

### 2.4 Out of Scope (Future)

- Device claiming, provisioning, and onboarding
- User and organization registration
- Agent-to-agent (A2A) integration
- Model Context Protocol (MCP) and AI agent interoperability

## 3.0 Device Categories from Taxonomy

The AV Device Taxonomy Guidelines define 8 top-level categories:

| Code | Category | Subcategories |
|---|---|---|
| `display-device` | Display Devices | monitors-screens, projectors, video-walls, interactive-whiteboards |
| `audio-device` | Audio Devices | microphones, speakers, amplifiers-mixers |
| `video-device` | Video Devices | cameras, video-capture-streaming, codec-systems |
| `control-system` | Control Systems | control-panels, remote-controls, automation-systems |
| `signal-management` | Signal Management & Distribution | switchers-matrix-switches, extenders-converters, splitters-distribution-amplifiers |
| `collaboration` | Collaboration & Video Conferencing | interactive-displays, wireless-presentation, unified-communications |
| `recording-playback` | Recording & Playback Devices | media-players, recorders, storage-solutions |
| `infrastructure` | Infrastructure & Accessories | power-management, networking-equipment |

## 4.0 Minimum Capabilities Derived from Minimum Functionality Guidelines

The Minimum Functionality Guidelines define capabilities that all devices must or may expose. These map to the capability-centric model as follows:

### 4.1 Universal Capabilities (All Devices)

| Capability | Source | Required | Operations |
|---|---|---|---|
| `device-status` | Section 2.1 | MUST | read |
| `device-inventory` | Section 2.2 | MUST | read |
| `device-operations` | Section 2.3 | MUST | execute |
| `device-networking` | Section 2.4 | MUST | read, write |
| `device-discovery` | Section 2.7 | MUST | read |
| `device-maintenance` | Section 3.2 | SHOULD | read |

### 4.2 Category-Specific Capabilities

| Capability | Applicable Categories | Required | Operations |
|---|---|---|---|
| `video-profile` | display-device, video-device, collaboration, codec-systems | MUST | read |
| `audio-volume` | audio-device, collaboration, codec-systems | MUST | read, write |
| `audio-mute` | audio-device, collaboration, codec-systems | MUST | read, write |

## 5.0 Proposed Payloads

### 5.1 GET /v1/devices

#### Request
```
GET /v1/devices?category=audio-device&limit=20&after=cursor_abc123
Authorization: Bearer <token>
Accept: application/json
```

#### Response (200 OK)
```json
{
  "data": [
    {
      "deviceId": "d-001-bfm-4400",
      "deviceName": "Boardroom Ceiling Mic Array",
      "deviceState": "ONLINE",
      "category": "audio-device",
      "subCategory": "microphones",
      "hardwareIdentity": {
        "manufacturer": "AcmePro",
        "model": "BeamArray-4400",
        "serialNumber": "AP-BF-2026-00412"
      },
      "softwareIdentity": {
        "firmwareVersion": "2.8.1"
      },
      "capabilities": [
        "device-status",
        "device-inventory",
        "device-operations",
        "device-networking",
        "device-discovery",
        "device-maintenance",
        "audio-mute",
        "audio-volume"
      ],
      "_links": {
        "self": { "href": "/v1/devices/d-001-bfm-4400" },
        "capabilities": { "href": "/v1/devices/d-001-bfm-4400/capabilities" }
      }
    },
    {
      "deviceId": "d-002-spk-cx200",
      "deviceName": "Lobby Ceiling Speaker Zone A",
      "deviceState": "ONLINE",
      "category": "audio-device",
      "subCategory": "speakers",
      "hardwareIdentity": {
        "manufacturer": "SoundCorp",
        "model": "CX-200",
        "serialNumber": "SC-CX-2025-98701"
      },
      "softwareIdentity": {
        "firmwareVersion": "1.4.0"
      },
      "capabilities": [
        "device-status",
        "device-inventory",
        "device-operations",
        "device-networking",
        "device-discovery",
        "audio-mute",
        "audio-volume"
      ],
      "_links": {
        "self": { "href": "/v1/devices/d-002-spk-cx200" },
        "capabilities": { "href": "/v1/devices/d-002-spk-cx200/capabilities" }
      }
    }
  ],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "cursor_def456"
  },
  "_links": {
    "self": { "href": "/v1/devices?category=audio-device&limit=20&after=cursor_abc123" },
    "next": { "href": "/v1/devices?category=audio-device&limit=20&after=cursor_def456" }
  }
}
```

### 5.2 GET /v1/devices/{deviceId}/capabilities

The following examples show the capabilities response for representative devices from different taxonomy categories.

---

#### 5.2.1 Audio Device: Beamforming Microphone

**Taxonomy:** audio-device > microphones

```
GET /v1/devices/d-001-bfm-4400/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-001-bfm-4400",
  "category": "audio-device",
  "subCategory": "microphones",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF", "STANDBY"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 432000
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "AcmePro" },
        "model": { "type": "string", "current": "BeamArray-4400" },
        "serialNumber": { "type": "string", "current": "AP-BF-2026-00412" },
        "firmwareVersion": { "type": "string", "current": "2.8.1" },
        "hardwareVersion": { "type": "string", "current": "Rev C" },
        "deviceName": { "type": "string", "current": "Boardroom Ceiling Mic Array" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-001-bfm-4400/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-001-bfm-4400/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        },
        {
          "name": "identify",
          "href": "/v1/devices/d-001-bfm-4400/capabilities/device-operations/actions/identify",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read", "write"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "192.168.1.40" },
        "macAddress": { "type": "string", "current": "AA:BB:CC:11:22:33" },
        "subnetMask": { "type": "string", "current": "255.255.255.0" },
        "defaultGateway": { "type": "string", "current": "192.168.1.1" },
        "dnsServer": { "type": "string", "current": "192.168.1.1" },
        "connectionType": { "type": "string", "current": "ethernet" }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["mDNS"]
        }
      }
    },
    {
      "name": "device-maintenance",
      "operations": ["read", "execute"],
      "attributes": {
        "logsAvailable": { "type": "boolean", "current": true }
      },
      "actions": [
        {
          "name": "retrieve-logs",
          "href": "/v1/devices/d-001-bfm-4400/capabilities/device-maintenance/actions/retrieve-logs",
          "method": "POST"
        }
      ]
    },
    {
      "name": "audio-mute",
      "operations": ["read", "write"],
      "attributes": {
        "muted": { "type": "boolean", "current": false }
      },
      "_links": {
        "self": { "href": "/v1/devices/d-001-bfm-4400/capabilities/audio-mute" }
      }
    },
    {
      "name": "audio-volume",
      "operations": ["read", "write"],
      "attributes": {
        "volume": {
          "type": "integer",
          "current": 72,
          "constraints": { "min": 0, "max": 100, "step": 1 }
        }
      },
      "_links": {
        "self": { "href": "/v1/devices/d-001-bfm-4400/capabilities/audio-volume" }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-001-bfm-4400/capabilities" },
    "device": { "href": "/v1/devices/d-001-bfm-4400" }
  }
}
```

---

#### 5.2.2 Display Device: LED Video Wall

**Taxonomy:** display-device > video-walls

```
GET /v1/devices/d-010-vw-led900/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-010-vw-led900",
  "category": "display-device",
  "subCategory": "video-walls",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF", "STANDBY"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 86400
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "VizMax" },
        "model": { "type": "string", "current": "LED-900 Wall" },
        "serialNumber": { "type": "string", "current": "VM-LED-2026-50021" },
        "firmwareVersion": { "type": "string", "current": "3.1.2" },
        "hardwareVersion": { "type": "string", "current": "Rev A" },
        "deviceName": { "type": "string", "current": "Main Lobby Video Wall" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-010-vw-led900/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-010-vw-led900/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        },
        {
          "name": "identify",
          "href": "/v1/devices/d-010-vw-led900/capabilities/device-operations/actions/identify",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read", "write"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "10.0.5.20" },
        "macAddress": { "type": "string", "current": "DD:EE:FF:44:55:66" },
        "subnetMask": { "type": "string", "current": "255.255.254.0" },
        "defaultGateway": { "type": "string", "current": "10.0.4.1" },
        "dnsServer": { "type": "string", "current": "10.0.4.1" },
        "connectionType": { "type": "string", "current": "ethernet" }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["mDNS", "LLDP"]
        }
      }
    },
    {
      "name": "video-profile",
      "operations": ["read"],
      "attributes": {
        "currentResolution": {
          "type": "string",
          "current": "3840x2160"
        },
        "videoStatus": {
          "type": "enum",
          "values": ["DISPLAYING", "NO_SIGNAL", "STANDBY"],
          "current": "DISPLAYING"
        },
        "activeInput": {
          "type": "string",
          "current": "HDMI-1"
        },
        "availableInputs": {
          "type": "array",
          "items": "string",
          "current": ["HDMI-1", "HDMI-2", "DP-1", "HDMI_OVER_IP"]
        }
      },
      "_links": {
        "self": { "href": "/v1/devices/d-010-vw-led900/capabilities/video-profile" }
      }
    },
    {
      "name": "audio-volume",
      "operations": ["read", "write"],
      "attributes": {
        "volume": {
          "type": "integer",
          "current": 40,
          "constraints": { "min": 0, "max": 100, "step": 1 }
        }
      }
    },
    {
      "name": "audio-mute",
      "operations": ["read", "write"],
      "attributes": {
        "muted": { "type": "boolean", "current": false }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-010-vw-led900/capabilities" },
    "device": { "href": "/v1/devices/d-010-vw-led900" }
  }
}
```

---

#### 5.2.3 Video Device: PTZ Camera

**Taxonomy:** video-device > cameras

```
GET /v1/devices/d-020-ptz-cam100/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-020-ptz-cam100",
  "category": "video-device",
  "subCategory": "cameras",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF", "STANDBY"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 172800
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "OptiVision" },
        "model": { "type": "string", "current": "PTZ-CAM-100" },
        "serialNumber": { "type": "string", "current": "OV-PTZ-2026-33010" },
        "firmwareVersion": { "type": "string", "current": "5.0.3" },
        "hardwareVersion": { "type": "string", "current": "Rev B" },
        "deviceName": { "type": "string", "current": "Conference Room A Camera" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-020-ptz-cam100/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-020-ptz-cam100/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        },
        {
          "name": "identify",
          "href": "/v1/devices/d-020-ptz-cam100/capabilities/device-operations/actions/identify",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read", "write"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "192.168.2.15" },
        "macAddress": { "type": "string", "current": "11:22:33:AA:BB:CC" },
        "subnetMask": { "type": "string", "current": "255.255.255.0" },
        "defaultGateway": { "type": "string", "current": "192.168.2.1" },
        "dnsServer": { "type": "string", "current": "192.168.2.1" },
        "connectionType": { "type": "string", "current": "ethernet" }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["mDNS", "LLDP"]
        }
      }
    },
    {
      "name": "video-profile",
      "operations": ["read"],
      "attributes": {
        "currentResolution": {
          "type": "string",
          "current": "1920x1080"
        },
        "videoStatus": {
          "type": "enum",
          "values": ["CAPTURING", "IDLE", "STANDBY"],
          "current": "CAPTURING"
        }
      },
      "_links": {
        "self": { "href": "/v1/devices/d-020-ptz-cam100/capabilities/video-profile" }
      }
    },
    {
      "name": "audio-mute",
      "operations": ["read", "write"],
      "attributes": {
        "muted": { "type": "boolean", "current": false }
      }
    },
    {
      "name": "audio-volume",
      "operations": ["read", "write"],
      "attributes": {
        "volume": {
          "type": "integer",
          "current": 80,
          "constraints": { "min": 0, "max": 100, "step": 1 }
        }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-020-ptz-cam100/capabilities" },
    "device": { "href": "/v1/devices/d-020-ptz-cam100" }
  }
}
```

---

#### 5.2.4 Signal Management: HDMI Matrix Switcher

**Taxonomy:** signal-management > switchers-matrix-switches

```
GET /v1/devices/d-030-sw-mx8x8/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-030-sw-mx8x8",
  "category": "signal-management",
  "subCategory": "switchers-matrix-switches",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF", "STANDBY"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 604800
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "SignalPath" },
        "model": { "type": "string", "current": "MX-8x8-HDMI" },
        "serialNumber": { "type": "string", "current": "SP-MX-2025-70088" },
        "firmwareVersion": { "type": "string", "current": "1.9.4" },
        "hardwareVersion": { "type": "string", "current": "Rev D" },
        "deviceName": { "type": "string", "current": "AV Rack Matrix Switch" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-030-sw-mx8x8/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-030-sw-mx8x8/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read", "write"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "10.0.10.50" },
        "macAddress": { "type": "string", "current": "CC:DD:EE:77:88:99" },
        "subnetMask": { "type": "string", "current": "255.255.255.0" },
        "defaultGateway": { "type": "string", "current": "10.0.10.1" },
        "dnsServer": { "type": "string", "current": "10.0.10.1" },
        "connectionType": { "type": "string", "current": "ethernet" }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["LLDP"]
        }
      }
    },
    {
      "name": "video-profile",
      "operations": ["read"],
      "attributes": {
        "currentResolution": {
          "type": "string",
          "current": "3840x2160"
        },
        "videoStatus": {
          "type": "enum",
          "values": ["ROUTING", "NO_SIGNAL", "STANDBY"],
          "current": "ROUTING"
        },
        "activeInput": {
          "type": "string",
          "current": "INPUT-3"
        },
        "availableInputs": {
          "type": "array",
          "items": "string",
          "current": ["INPUT-1", "INPUT-2", "INPUT-3", "INPUT-4", "INPUT-5", "INPUT-6", "INPUT-7", "INPUT-8"]
        }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-030-sw-mx8x8/capabilities" },
    "device": { "href": "/v1/devices/d-030-sw-mx8x8" }
  }
}
```

---

#### 5.2.5 Collaboration: Unified Communications Platform

**Taxonomy:** collaboration > unified-communications

This example demonstrates a device that spans multiple taxonomy domains, exposing both audio and video capabilities.

```
GET /v1/devices/d-040-uc-room500/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-040-uc-room500",
  "category": "collaboration",
  "subCategory": "unified-communications",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF", "STANDBY"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 259200
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "CollabTech" },
        "model": { "type": "string", "current": "RoomSystem-500" },
        "serialNumber": { "type": "string", "current": "CT-RS-2026-10055" },
        "firmwareVersion": { "type": "string", "current": "8.2.0" },
        "applicationVersion": { "type": "string", "current": "3.5.1" },
        "hardwareVersion": { "type": "string", "current": "Rev A" },
        "deviceName": { "type": "string", "current": "Executive Boardroom UC System" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-040-uc-room500/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-040-uc-room500/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        },
        {
          "name": "identify",
          "href": "/v1/devices/d-040-uc-room500/capabilities/device-operations/actions/identify",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read", "write"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "192.168.5.100" },
        "macAddress": { "type": "string", "current": "FF:00:11:22:33:44" },
        "subnetMask": { "type": "string", "current": "255.255.255.0" },
        "defaultGateway": { "type": "string", "current": "192.168.5.1" },
        "dnsServer": { "type": "string", "current": "192.168.5.1" },
        "connectionType": { "type": "string", "current": "ethernet" },
        "wifiSsid": { "type": "string", "current": "CorpNet-5G" },
        "wifiSignalStrength": { "type": "integer", "unit": "dBm", "current": -42 }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["mDNS", "LLDP"]
        }
      }
    },
    {
      "name": "device-maintenance",
      "operations": ["read", "execute"],
      "attributes": {
        "logsAvailable": { "type": "boolean", "current": true },
        "diagnostics": {
          "cpuUsage": { "type": "number", "unit": "percent", "current": 23.5 },
          "availableStorage": { "type": "integer", "unit": "megabytes", "current": 4096 }
        }
      },
      "actions": [
        {
          "name": "retrieve-logs",
          "href": "/v1/devices/d-040-uc-room500/capabilities/device-maintenance/actions/retrieve-logs",
          "method": "POST"
        }
      ]
    },
    {
      "name": "video-profile",
      "operations": ["read"],
      "attributes": {
        "currentResolution": {
          "type": "string",
          "current": "1920x1080"
        },
        "videoStatus": {
          "type": "enum",
          "values": ["DISPLAYING", "CAPTURING", "IN_CALL", "NO_SIGNAL", "STANDBY"],
          "current": "IN_CALL"
        },
        "activeInput": {
          "type": "string",
          "current": "INTEGRATED_CAMERA"
        }
      }
    },
    {
      "name": "audio-mute",
      "operations": ["read", "write"],
      "attributes": {
        "muted": { "type": "boolean", "current": false }
      }
    },
    {
      "name": "audio-volume",
      "operations": ["read", "write"],
      "attributes": {
        "volume": {
          "type": "integer",
          "current": 65,
          "constraints": { "min": 0, "max": 100, "step": 1 }
        }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-040-uc-room500/capabilities" },
    "device": { "href": "/v1/devices/d-040-uc-room500" }
  }
}
```

---

#### 5.2.6 Infrastructure: Power Distribution Unit

**Taxonomy:** infrastructure > power-management

This example demonstrates a device with only universal capabilities and no audio/video-specific capabilities.

```
GET /v1/devices/d-050-pdu-rack3/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "deviceId": "d-050-pdu-rack3",
  "category": "infrastructure",
  "subCategory": "power-management",
  "capabilities": [
    {
      "name": "device-status",
      "operations": ["read"],
      "attributes": {
        "powerState": {
          "type": "enum",
          "values": ["ON", "OFF"],
          "current": "ON"
        },
        "uptime": {
          "type": "integer",
          "unit": "seconds",
          "current": 2592000
        }
      }
    },
    {
      "name": "device-inventory",
      "operations": ["read"],
      "attributes": {
        "manufacturer": { "type": "string", "current": "PowerGrid" },
        "model": { "type": "string", "current": "PDU-16A-SMART" },
        "serialNumber": { "type": "string", "current": "PG-PDU-2024-80005" },
        "firmwareVersion": { "type": "string", "current": "1.2.0" },
        "deviceName": { "type": "string", "current": "AV Rack 3 PDU" }
      }
    },
    {
      "name": "device-operations",
      "operations": ["execute"],
      "actions": [
        {
          "name": "reboot",
          "href": "/v1/devices/d-050-pdu-rack3/capabilities/device-operations/actions/reboot",
          "method": "POST"
        },
        {
          "name": "firmware-update",
          "href": "/v1/devices/d-050-pdu-rack3/capabilities/device-operations/actions/firmware-update",
          "method": "POST"
        }
      ]
    },
    {
      "name": "device-networking",
      "operations": ["read"],
      "attributes": {
        "ipAddress": { "type": "string", "current": "10.0.10.200" },
        "macAddress": { "type": "string", "current": "AA:00:BB:11:CC:22" },
        "subnetMask": { "type": "string", "current": "255.255.255.0" },
        "defaultGateway": { "type": "string", "current": "10.0.10.1" },
        "dnsServer": { "type": "string", "current": "10.0.10.1" },
        "connectionType": { "type": "string", "current": "ethernet" }
      }
    },
    {
      "name": "device-discovery",
      "operations": ["read"],
      "attributes": {
        "protocols": {
          "type": "array",
          "items": "string",
          "current": ["LLDP"]
        }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v1/devices/d-050-pdu-rack3/capabilities" },
    "device": { "href": "/v1/devices/d-050-pdu-rack3" }
  }
}
```

## 6.0 Proposed Error Response

Per RFC 9457, as specified in the Cloud API Guidelines Section 8.2:

```
GET /v1/devices/nonexistent-id/capabilities
Authorization: Bearer <token>
Accept: application/json
```

```json
{
  "type": "https://openavcloud.org/errors/device-not-found",
  "title": "Requested device could not be found.",
  "errorId": 404,
  "detail": "No device exists with ID 'nonexistent-id'. Verify the device ID and ensure it is accessible under your current authorization scope.",
  "instance": "/v1/devices/nonexistent-id/capabilities",
  "traceId": "df41558a-01e8-4db1-bdfe-034de7b32c5e"
}
```

## 7.0 Payload Design Rationale

| Design Decision | Rationale | Source |
|---|---|---|
| `category` and `subCategory` on every response | Enables clients to determine applicable capabilities without a separate taxonomy lookup | Taxonomy Guidelines Section 2 |
| Universal capabilities on all devices | Minimum Functionality sections 2.1-2.4, 2.7 are mandatory for all device types | Min Functionality Guidelines |
| `video-profile` capability with resolution, status, active input | Directly maps to Min Functionality section 2.5 requirements | Min Functionality Guidelines Section 2.5 |
| `audio-mute` and `audio-volume` as separate capabilities | Allows devices to support one without the other; aligns with capability-centric model | Min Functionality Guidelines Section 2.6, Cloud API Section 13 |
| `constraints` on writable attributes | Cloud API section 13.2 specifies that capabilities may differ in value ranges across devices | Cloud API Guidelines Section 13.2 |
| `operations` array per capability | Distinguishes read-only telemetry from writable settings and executable actions | Inferred from Min Functionality read vs. write requirements |
| HATEOAS `_links` on capabilities | Cloud API section 3.2 calls for HATEOAS-style discoverability | Cloud API Guidelines Section 3.2 |
| `actions` with `href` and `method` | Makes executable operations self-documenting and discoverable per HATEOAS | Cloud API Guidelines Section 3.2 |
| `applicationVersion` on UC platform | Min Functionality section 2.2.6 requires separate application version reporting where applicable | Min Functionality Guidelines Section 2.2.6 |
| WiFi attributes on UC platform | Min Functionality section 2.4.3 requires SSID and signal strength for WiFi-capable devices | Min Functionality Guidelines Section 2.4.3 |
| No `identify` action on matrix switcher or PDU | Min Functionality section 2.3.3 only requires identify for devices with visible indicators | Min Functionality Guidelines Section 2.3.3 |
| Cursor-based pagination on device list | Cloud API section 6 requires durable identifier-based pagination, not index-based | Cloud API Guidelines Section 6 |

## 8.0 Open Questions

1. **Capability registry format** -- The Cloud API spec (Section 13.1) references a future standardized capability registry. Should capability names use a namespace prefix (e.g., `oavc:audio-mute`) to distinguish standard capabilities from manufacturer extensions?

2. **Manufacturer-specific capabilities** -- How should vendor-proprietary capabilities be represented? A possible convention:
   ```json
   { "name": "x-acmepro:beam-steering", "operations": ["read", "write"] }
   ```

3. **Capability versioning** -- If a capability definition evolves (e.g., `audio-volume` gains new attributes), should capabilities carry their own version identifier?

4. **Aggregator/proxy model** -- Min Functionality Section 3.4 requires aggregators to expose child devices individually. Should the capabilities response include a `children` link or a `parentDeviceId` reference?

5. **Batch capabilities request** -- Should there be a bulk endpoint to retrieve capabilities for multiple devices in a single request, per Cloud API Section 14?
