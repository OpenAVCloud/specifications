# OpenAV Cloud-to-Cloud REST API
Initial Specification (v0.3 – Draft)
## 1.0 Purpose & Goals
The goal of this API is to enable **cloud-to-cloud interoperability** between OpenAV-compatible systems. The API is intended to expose device and system capabilities in a **capability-centric**, standards-aligned way that supports scalable integration across multiple vendors and cloud platforms.

This guideline builds on industry best practices, with an emphasis on:
- Interoperability
- Extensibility
- Secure, standards-based access
- Event-driven integration

## 2.0 Document History and Change Log
This section captures the history of changes made to this document.

  -----------------------------------------------------------------------
  | Version|Date|Reason for Change|
  |---|---|---|
  0.2|2026-04-03|Draft|
  0.3|2026-04-13|Update per feedback|
  -----------------------------------------------------------------------

## 3.0 Design Principles
### 3.1 Architectural Style
- RESTful API design
- Stateless interactions for scalability and reliability
- Resource-oriented URLs are preferred (e.g., `/v1/devices`, `/v1/devices/{deviceId}/capabilities`)
- JSON for request and response payloads

### 3.2 Capability-Centric Model
- The API is capability-centric, not strictly device-centric
- Devices expose one or more capabilities
- Capabilities may be:
  - Common (standardized across manufacturers)
  - Manufacturer-specific (extensions)
- HATEOAS-style discoverability where appropriate
- See Section 13

### 3.3 Standards Alignment
- OAuth 2.0 for authentication
- OData JSON format used for request/response batching

## 4.0 API Versioning
- API Versioning is included in the URL path
Example: 
```
    /v1/...
```
- Changing the API version indicates a breaking change to the consumer of the API
- Backward compatibility should be maintained where possible while enabling iterative improvements
- Each individual endpoint could also be independently versioned
Example: 
both are v1 of the overall API spec, but the endpoint itself has been updated:
```
    /v1/devices/{deviceId}/audio-channels
    /v1/devices/{deviceId}/audio-channels-v2
```

## 5.0 HTTP Methods & Idempotency
### 5.1 Method Usage
- GET – Retrieve resources
- POST – Create resources
- PUT – Update resources
- DELETE – Delete resources

### 5.2 Idempotency
Idempotency rules for device-related operations is preferred when possible, but is not strictly required. For example, operations such as triggering a firmware update may not be idempotent by nature, as the outcome depends on the current state of the device at the time of execution.

## 6.0 Pagination
- Pagination shall be possible for limiting the number of records returned.
- It must be possible to seek through pages of records, limiting the number of records returned in a page.
- When specifying records to be returned, they should be done from a durable identifier describing the record (as opposed to the index or position of the record in the collection)

## 7.0 Request & Response Formatting
### 7.1 JSON Format
- All request and response bodies use JSON
- Content-Type header:    ```application/json```

### 7.2 Date and Time
- DateTime in ISO-8601 format 
- All date and time are in UTC

### 7.3 Descriptive Payloads

Example response:
```
{
  "deviceState": "ONLINE",
  "hardwareIdentity": {
    "serialNumber": "1232123456"
  },
  "softwareIdentity": {
    "firmwareVersion": "4.5.0",
    "model": "Microphone"
  },
  "capabilities": [
    "firmware-version",
    "audio-mute"
  ]
}
```
#### 7.3.1 Extensibility
Client may ignore data returned that doesn't fit the spec (allows for future additions)

## 8.0 Validation & Error Handling
### 8.1 Validation
- All incoming requests must be validated by the API.
- Requests containing invalid or malformed data must be rejected.
- Validation failures must return clear, actionable error information.

### 8.2 Standard Error Structure
- Refer to RFC9457 (which obsoletes RFC7807)
- Error responses include a consistent JSON structure.
- Error payloads should include:
  - A machine-readable error code
  - A human-readable message
  - Optional details describing the validation or processing failure
Example error response:
```
{
  "type": "",
  "title": "Requested device(s) could not be found.",
  "errorId": 123,
  "detail": "Device information is not available",
  "instance": "",
  "traceId": "df41558a-01e8-4db1-bdfe-034de7b32c5e"
}
```

## 9.0 Documentation
- The API must be documented using the OpenAPI specification.
- Documentation should include:
  - Endpoint definitions
  - Request and response schemas
  - Example requests and responses
- Documentation should be suitable for both human readers and automated tooling.

## 10.0 Authentication & Security
### 10.1 Authentication
- OAuth 2.0 is used for authorization and access delegation
- Access is granted via OAuth tokens
- Token-based access enables cross-cloud integration scenarios
- Authentication of the resource owner or end-user is outside the scope of this specification and left to each implementation.
- For cloud-to-cloud integration scenarios, implementations must support the Client Credentials Grant (RFC 6749 §4.4). Other grant types (e.g., Authorization Code, Device Flow) may be supported to accommodate additional use cases.
- Access tokens must be transmitted using the Authorization request header with the Bearer scheme, as defined in RFC 6750.
  Example: `Authorization: Bearer <token>`

### 10.2 Authorization
- Role-Based Access Control (RBAC) should be supported where applicable
- Authorization rules may differ by capability or operation

### 10.3 Transport Security
- All endpoints must use HTTPS
- TLS 1.2+ is required for data in transit
- Sensitive data should be encrypted at rest where applicable

## 11.0 Discovery
### 11.1 Discovery
- The API should support discoverability of:
  - Available resources
  - Supported capabilities

### 11.2 Registration (Initial Scope)
- Initial implementation focuses on OAuth-based access only
- Registration and claiming of:
  - Users
  - Devices
are considered **future iterations** and out of *initial* scope

## 12.0 Resources & Endpoints
### 12.1 Devices
#### List Devices
```
GET /v1/devices
```
- Returns a paginated list of devices accessible to the caller
- Supports filtering, sorting, and pagination via query parameters
### 12.2 Capabilities
#### Get Device Capabilities
```
GET /v1/devices/{deviceId}/capabilities
```
- Returns the set of capabilities supported by the specified device
- Capabilities are enumerated using a standard list where possible
## 13.0 Capabilities Model
### 13.1 Capability Enumeration
- Each device exposes a defined list of capabilities
  - Capabilities allow one to write code that is feature-focused instead of device-focused. When capabilities are used to check for device features, this meets the Open-Closed Principle of SOLID when more new devices are added, or more features are added to an existing devices.
  - This works on the same principle as interfaces in object-oriented programming; the interaction with the capability is considered interchangeable when...
    - Two or more devices implement the same capability
    - Two or more firmware versions of the same model of device implement the same capability
- A future OpenAV effort will define a standardized capability registry
- In the future, common capabilities will have a common definition

Example: ```802.1x configuration```

### 13.2 Constraints
Capabilities may share common semantics across devices but differ in constraints, such as:
- Value ranges (e.g., volume, gain, brightness)
- Allowed formats or character sets (e.g., regex constraints on names)

## 14.0 Bulk Operations & Batching
- The API should support:
  - Bulk endpoints
  - Batch operations
- Batching aligns with OData-style JSON conventions
- This enables efficient updates across multiple devices or capabilities

## 15.0 Events & Subscriptions

### 15.1 Event-Driven Model
The API favors event-driven communication
Polling should be avoided where possible

### 15.2 Subscription Mechanisms

Possible mechanisms include:

- Webhooks
- WebSockets
- Event callbacks

Details of event schemas and lifecycle management are part of a dedicated event-driven section to be expanded

## 16.0 Future Topics (Out of Scope for initial revision)
The following topics are explicitly out of scope for the initial release but are expected to be addressed in future iterations:

### 16.1 Device claiming, privisioning, and onboarding
### 16.2 User and organization registration
### 16.3 Agent-to-agent (A2A) integration
### 16.4 Model Context Protocol (MCP) and AI agent interoperability

## 17.0 Related Specifications
The following OpenAV Cloud specifications are related to this document:

| Specification | Version | Relationship |
|---|---|---|
| [AV Device Taxonomy Guidelines](../device-taxonomy/OAVC-AV-Device-Taxonomy-Guidelines.md) | 1.1 | Defines the device categories and taxonomy referenced in Section 12 (Capabilities Model) |
| [AV Device Minimum Functionality Guidelines](../min-device-functionality/OAVC-AV-Device-Minimum-Functionality-Guidelines.md) | 1.1 | Defines the minimum device functionality that implementations of this API are expected to expose |
| [AV Device Security Guidelines](../security-guidelines/OAVC-AV-Device-Security-Guidelines.md) | 1.1 | Defines the security requirements that complement Section 9 (Authentication & Security) of this specification |