# OpenAV Cloud-to-Cloud REST API
Initial Specification (v0.1 – Draft)
## 1.0 Purpose & Goals
The goal of this API is to enable **cloud-to-cloud interoperability** between OpenAV-compatible systems. The API is intended to expose device and system capabilities in a **capability-centric**, standards-aligned way that supports scalable integration across multiple vendors and cloud platforms.

This specification builds on industry best practices, with an emphasis on:
- Interoperability
- Extensibility
- Secure, standards-based access
- Event-driven integration

## 2.0 Design Principles
### 2.1 Architectural Style
- RESTful API design
- Stateless interactions for scalability and reliability
- Resource-oriented URLs are preferred
- JSON for request and response payloads

### 2.2 Capability-Centric Model
- The API is capability-centric, not strictly device-centric
- Devices expose one or more capabilities
- Capabilities may be:
  - Common (standardized across manufacturers)
  - Manufacturer-specific (extensions)
- HATEOAS-style discoverability where appropriate
- See Section 12

### 2.3 Standards Alignment
- OAuth 2.0 for authentication
- OData JSON format used for request/response batching

## 3.0 API Versioning
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

## 4.0 HTTP Methods & Idempotency
### 4.1 Method Usage
- GET – Retrieve resources
- POST – Create resources
- PUT – Update resources
- DELETE – Delete resources

### 4.2 Idempotency
Idempotency rules for device-related operations is preferred when possible, but is not strictly required

## 5.0 Pagination
- Pagination shall be possible for limiting the number of records returned.
- It must be possible to seek through pages of records, limiting the number of records returned in a page.
- When specifying records to be returned, they should be done from a durable identifier describing the record (as opposed to the index or position of the record in the collection)

## 6.0 Request & Response Formatting
### 6.1 JSON Format
- All request and response bodies use JSON
- Content-Type header:    ```application/json```

### 6.2 Descriptive Payloads

Example response:
```
{
  "userId": 123,
  "userName": "JohnDoe",
  "email": "john.doe@example.com",
  "createdAt": "2023-10-01T12:00:00Z"
}
```

## 7.0 Validation & Error Handling
### 7.1 Validation
- All incoming requests must be validated by the API.
- Requests containing invalid or malformed data must be rejected.
- Validation failures must return clear, actionable error information.

### 7.2 Standard Error Structure
- Refer to RFC7807
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
  "status": 404,
  "detail": "Device information is not available",
  "instance": "",
  "traceId": "df41558a-01e8-4db1-bdfe-034de7b32c5e"
}
```

## 8.0 Documentation
- The API must be documented using the OpenAPI specification.
- Documentation should include:
  - Endpoint definitions
  - Request and response schemas
  - Example requests and responses
- Documentation should be suitable for both human readers and automated tooling.

## 9.0 Authentication & Security
### 9.1 Authentication
- OAuth 2.0 is the initial authentication mechanism
- Access is granted via OAuth tokens
- Token-based access enables cross-cloud integration scenarios

### 9.2 Authorization
- Role-Based Access Control (RBAC) should be supported where applicable
- Authorization rules may differ by capability or operation

### 9.3 Transport Security
- All endpoints must use HTTPS
- TLS is required for data in transit
- Sensitive data should be encrypted at rest where applicable

## 10.0 Discovery
### 10.1 Discovery
- The API should support discoverability of:
  - Available resources
  - Supported capabilities

### 10.2 Registration (Initial Scope)
- Initial implementation focuses on OAuth-based access only
- Registration and claiming of:
  - Users
  - Devices
are considered **future iterations** and out of *initial* scope

## 11.0 Resources & Endpoints
### 11.1 Devices
#### List Devices
```
GET /v1/devices
```
- Returns a paginated list of devices accessible to the caller
- Supports filtering, sorting, and pagination via query parameters
### 11.2 Capabilities
#### Get Device Capabilities
```
GET /v1/devices/{deviceId}/capabilities
```
- Returns the set of capabilities supported by the specified device
- Capabilities are enumerated using a standard list where possible
## 12.0 Capabilities Model
### 12.1 Capability Enumeration
- Each device exposes a defined list of capabilities
  - Capabilities allow one to write code that is feature-focused instead of device-focused. When capabilities are used to check for device features, this meets the Open-Closed Principle of SOLID when more new devices are added, or more features are added to an existing devices.
  - This works on the same principle as interfaces in object-oriented programming; the interaction with the capability is considered interchangeable when...
    - Two or more devices implement the same capability
    - Two or more firmware versions of the same model of device implement the same capability
- A future OpenAV effort will define a standardized capability registry
- In the future, common capabilities will have a common definition

Example: ```802.1x configuration```

### 12.2 Constraints
Capabilities may share common semantics across devices but differ in constraints, such as:
- Value ranges (e.g., volume, gain, brightness)
- Allowed formats or character sets (e.g., regex constraints on names)

## 13.0 Future Topics (Out of Scope for v0.1)
The following topics are explicitly out of scope for the initial v0.1 release but are expected to be addressed in future iterations:
### 13.1 Bulk Operations & Batching
- The API should support:
  - Bulk endpoints
  - Batch operations
- Batching aligns with OData-style JSON conventions
- This enables efficient updates across multiple devices or capabilities

### 13.2 Events & Subscriptions

#### 13.2.1 Event-Driven Model
The API favors event-driven communication
Polling should be avoided where possible

#### 13.2.2 Subscription Mechanisms

Possible mechanisms include:

- Webhooks
- WebSockets
- Event callbacks

Details of event schemas and lifecycle management are part of a dedicated event-driven section to be expanded

### 13.3 Device claiming and onboarding
### 13.4 User and organization registration
### 13.5 Agent-to-agent (A2A) integration
### 13.6 Model Context Protocol (MCP) and AI agent interoperability