# Discussion: Viability of the Capability-Centric Model

Document Version: 0.1 (Draft -- For Working Group Discussion)
Prepared by: Greg Herlein
Date: April 13, 2026

## 1.0 Purpose

This document examines the capability-centric model as described in the OpenAV Cloud-to-Cloud REST API specification (v0.3). It traces where the model is defined, assesses what is actually mandated versus aspirational, identifies practical concerns with implementation, and proposes questions the working group should resolve before manufacturers begin building to this spec.

This is not a rejection of the capability-centric concept. It is an argument that the concept as currently specified is simultaneously too vague to implement and too prescriptive to ignore -- a combination that creates risk for early adopters.

## 2.0 Where the Capability-Centric Model Is Defined

The capability-centric model appears in three locations across the OpenAV specifications:

### 2.1 Cloud API Spec -- Section 1.0 (Purpose & Goals)

> The goal of this API is to enable **cloud-to-cloud interoperability** between OpenAV-compatible systems. The API is intended to expose device and system capabilities in a **capability-centric**, standards-aligned way that supports scalable integration across multiple vendors and cloud platforms.

This establishes "capability-centric" as a foundational design principle of the entire specification. It is stated as a goal, not qualified with "should" or "may."

### 2.2 Cloud API Spec -- Section 3.2 (Capability-Centric Model)

> - The API is capability-centric, not strictly device-centric
> - Devices expose one or more capabilities
> - Capabilities may be:
>   - Common (standardized across manufacturers)
>   - Manufacturer-specific (extensions)
> - HATEOAS-style discoverability where appropriate
> - See Section 13

This is the design principle statement. It draws a clear line: the API is "not strictly device-centric." The word "strictly" introduces ambiguity -- it suggests the API is *primarily* capability-centric but does not entirely exclude device-level access.

### 2.3 Cloud API Spec -- Section 13.0 (Capabilities Model)

> - Each device exposes a defined list of capabilities
> - Capabilities allow one to write code that is feature-focused instead of device-focused. When capabilities are used to check for device features, this meets the Open-Closed Principle of SOLID when more new devices are added, or more features are added to an existing devices.
> - This works on the same principle as interfaces in object-oriented programming; the interaction with the capability is considered interchangeable when...
>   - Two or more devices implement the same capability
>   - Two or more firmware versions of the same model of device implement the same capability
> - A future OpenAV effort will define a standardized capability registry
> - In the future, common capabilities will have a common definition

Section 13.2 adds:

> Capabilities may share common semantics across devices but differ in constraints, such as:
> - Value ranges (e.g., volume, gain, brightness)
> - Allowed formats or character sets (e.g., regex constraints on names)

### 2.4 Cloud API Spec -- Section 12.2 (Endpoint Definition)

> ```
> GET /v1/devices/{deviceId}/capabilities
> ```
> - Returns the set of capabilities supported by the specified device
> - Capabilities are enumerated using a standard list where possible

This is the only concrete endpoint mandated for the capability model.

### 2.5 Minimum Functionality Guidelines -- Section 3.1

> 3.1.1 Depending on the type of device (e.g. codec, display, audio device etc), the device may expose other functions not outlined in this document. A clear API interface must be published for those.

This implicitly supports extensible capabilities but does not reference the capability-centric model by name.

## 3.0 What Is Actually Mandated

Reading the spec carefully, the following are **mandated**:

1. A `GET /v1/devices/{deviceId}/capabilities` endpoint must exist
2. It must return a list of capabilities for the device
3. Capabilities should use a standard list "where possible"
4. Capabilities may include manufacturer-specific extensions
5. Capabilities may have different constraints (value ranges, formats) per device

The following are **explicitly deferred**:

1. The standardized capability registry ("A future OpenAV effort will define...")
2. Common capability definitions ("In the future, common capabilities will have a common definition")

The following are **not specified at all**:

1. The JSON schema for a capability object
2. The naming convention for capabilities
3. Whether capabilities are flat strings or structured objects
4. Whether capabilities have operations (read/write/execute) or are just identifiers
5. How to interact with a specific capability (is there a `/capabilities/{capabilityName}` endpoint?)
6. How manufacturer-specific extensions are namespaced
7. How capability constraints are expressed
8. How capability versions are tracked
9. The relationship between capabilities and the Minimum Functionality requirements

## 4.0 The Practical Problem

### 4.1 The Spec Mandates an Endpoint Without Defining Its Contract

Section 12.2 requires the existence of `GET /v1/devices/{deviceId}/capabilities`, and Section 13 describes the conceptual model. But there is no response schema. Consider what a manufacturer faces today:

**Question:** What does the response body look like?

The spec provides no answer. The only example payload in the entire document (Section 7.3) shows capabilities as a flat string array:

```json
"capabilities": [
    "firmware-version",
    "audio-mute"
]
```

Is this the format? Are capabilities just strings? Or are they structured objects with operations, constraints, current values, and HATEOAS links? The spec references HATEOAS (Section 3.2) and constraints (Section 13.2) but never shows how these compose into a response.

If Manufacturer A returns flat strings and Manufacturer B returns structured objects, the API is not interoperable -- which defeats the stated purpose.

### 4.2 The Registry Does Not Exist

Section 13.1 states:

> A future OpenAV effort will define a standardized capability registry

Without this registry, there is no shared vocabulary. If BrightSign calls it `audio-mute`, Shure calls it `mute`, and Crestron calls it `audioMuteState`, the capability model provides no interoperability benefit over a device-specific API. The capability-centric model's entire value proposition depends on a shared capability vocabulary, and that vocabulary does not exist yet.

The spec also provides only a single example of a capability name: `802.1x configuration`. This is a network security feature, not a core AV function. There are no examples of the kinds of capabilities that would actually dominate real-world usage (volume control, power management, video routing, etc.).

### 4.3 The SOLID Analogy Cuts Both Ways

Section 13.1 invokes the Open-Closed Principle:

> Capabilities allow one to write code that is feature-focused instead of device-focused. When capabilities are used to check for device features, this meets the Open-Closed Principle of SOLID when more new devices are added, or more features are added to an existing devices.

This analogy is correct in principle but reveals a practical problem: **interfaces in object-oriented programming only work when the interface contract is precisely defined.** A Go `io.Reader` works because `Read(p []byte) (n int, err error)` is specified exactly. An OpenAV `audio-mute` capability currently has no such contract. What method do you call? What do you pass? What comes back? What error conditions exist?

The spec is asking manufacturers to implement interfaces without defining the interface signatures.

### 4.4 Constraints Without Schema

Section 13.2 acknowledges that the same capability may have different constraints on different devices:

> Capabilities may share common semantics across devices but differ in constraints, such as:
> - Value ranges (e.g., volume, gain, brightness)
> - Allowed formats or character sets (e.g., regex constraints on names)

This is an important acknowledgment. But it raises implementation questions that are not addressed:

- How does a client discover the constraints for a given capability on a given device?
- Are constraints returned alongside the capability in the capabilities response?
- Is there a separate endpoint for capability metadata?
- Are constraints expressed in JSON Schema, or a custom format, or ad hoc?
- If a device has volume range 0-100 and another has 0-11, does the integrator need to handle this per-device? If so, how is this different from a device-centric API?

### 4.5 The Minimum Functionality Gap

The Minimum Functionality Guidelines define concrete, testable requirements: devices must report power state, uptime, serial number, support remote reboot, etc. These are practical and implementable.

But the Cloud API spec never maps these requirements to capabilities. Is `device-status` a capability? Is it two capabilities (`power-state` and `uptime`)? Is every row in the Minimum Functionality table a separate capability, or are they grouped? The two documents do not cross-reference in this direction -- the Cloud API spec references "See Section 13" for the capability model, and the Minimum Functionality spec does not reference the capability model at all.

The Minimum Functionality Guidelines Section 1 (Purpose) even states:

> It is also currently left up to individual manufacturers on how to present the data/features based on their implementation (e.g. API, WebUI, Cloud, Screen, CommandLine etc.).

This explicit deference to manufacturer implementation choice is in tension with a mandated capability-centric API model that requires a specific JSON structure at a specific endpoint.

### 4.6 Interoperability Requires More Than a List of Strings

The stated goal (Section 1.0) is "cloud-to-cloud interoperability." Consider a practical scenario:

A building management platform wants to mute all audio devices in Conference Room B. With a capability-centric model, the integration should look like:

1. `GET /v1/devices?capability=audio-mute&location=conference-room-b`
2. For each device, `PUT /v1/devices/{id}/capabilities/audio-mute` with `{"muted": true}`

But the spec only defines `GET /v1/devices` and `GET /v1/devices/{id}/capabilities`. There is:
- No filtering by capability on the device list endpoint
- No individual capability endpoint (`/capabilities/{name}`)
- No write operation on capabilities
- No standard payload for mutating a capability

The capability-centric model as specified is **read-only discovery** -- you can find out what capabilities a device has, but the spec does not define how to interact with any of them. Discovery without interaction is a device catalog, not an interoperable API.

## 5.0 Comparison With Industry Precedent

The capability-centric concept is not new. Examining how other ecosystems handle this:

### 5.1 Matter (Smart Home)

Matter defines device types (light, lock, thermostat) composed of **clusters** (the Matter equivalent of capabilities). Each cluster has a defined attribute set, command set, and event set -- down to the data types, value ranges, and error codes. The "On/Off" cluster specifies exactly: attribute `OnOff` (bool), commands `On()`, `Off()`, `Toggle()`, and events `StateChange`. This level of precision is what makes interoperability work.

The OpenAV spec is at the "there should be capabilities" stage. Matter took years of multi-vendor work to reach full cluster definitions.

### 5.2 OCF (Open Connectivity Foundation)

OCF defines resource types (e.g., `oic.r.switch.binary`) with JSON schemas for properties and operations. Each resource type is a capability with a precise contract.

### 5.3 Common Observation

Every successful capability-based interoperability standard defines the capability contracts in exhaustive detail. The model only works when the contracts are specific enough that two independent implementations can interoperate without out-of-band coordination. Defining the model without defining the contracts gives manufacturers something to build toward but nothing to build against.

## 6.0 What This Means Practically for Manufacturers

A manufacturer reading the v0.3 spec today faces a decision:

**Option A: Wait.** Do not implement the capabilities endpoint until the registry and schemas are defined. Risk: falling behind if the spec is adopted quickly.

**Option B: Implement speculatively.** Design a capability schema, invent capability names, and build the endpoint. Risk: incompatible with whatever the working group eventually standardizes, requiring rework.

**Option C: Implement minimally.** Return capabilities as a flat list of strings (matching the only example in the spec) with no operations or constraints. Risk: technically compliant but practically useless for interoperability.

None of these options are good. The spec as written creates a mandate without giving manufacturers enough information to comply in a meaningful way.

## 7.0 Recommendations

### 7.1 Decouple Discovery From Interaction

Acknowledge that the capability model has two distinct phases:

1. **Discovery** (what can this device do?) -- this is what the current spec describes
2. **Interaction** (how do I use this capability?) -- this is undefined

The spec should explicitly state that v1 of the API provides discovery only, and that capability interaction endpoints will be defined in a future version alongside the capability registry. This sets honest expectations.

### 7.2 Define a Minimum Response Schema

Even without a full capability registry, the working group should define the JSON structure for the capabilities response. At minimum:

- Is a capability a string or an object?
- If an object, what are the required fields?
- How are manufacturer extensions distinguished from standard capabilities?

This can be done without defining every capability -- it is the envelope, not the content.

### 7.3 Publish a Starter Registry

Define 5-10 capabilities that map directly to the Minimum Functionality requirements:

| Capability | Source | Type |
|---|---|---|
| `device-status` | Min Func 2.1 | read |
| `device-inventory` | Min Func 2.2 | read |
| `device-reboot` | Min Func 2.3.1 | execute |
| `firmware-update` | Min Func 2.3.2 | execute |
| `device-identify` | Min Func 2.3.3 | execute |
| `network-info` | Min Func 2.4 | read |
| `video-status` | Min Func 2.5 | read |
| `audio-volume` | Min Func 2.6.1 | read/write |
| `audio-mute` | Min Func 2.6.2 | read/write |

These do not need full schemas yet, but naming them and tying them to the existing requirements document gives manufacturers something concrete to implement and test against.

### 7.4 Address the Verb Problem

The spec defines HTTP methods (Section 5.1: GET, POST, PUT, DELETE) but never connects them to capability operations. The working group should decide:

- Does `GET /v1/devices/{id}/capabilities/audio-mute` return the current mute state?
- Does `PUT /v1/devices/{id}/capabilities/audio-mute` change it?
- Does `POST /v1/devices/{id}/capabilities/device-reboot` trigger the action?

Or is capability interaction handled differently (e.g., a generic command endpoint)? This architectural decision shapes every manufacturer's implementation.

### 7.5 Separate "Capability-Aware" From "Capability-Centric"

Consider whether the API needs to be **capability-centric** (capabilities are the primary abstraction, device endpoints are secondary) or **capability-aware** (device endpoints are primary, capabilities are metadata that enables discovery and filtering).

A capability-aware API preserves device-centric access patterns that manufacturers already support while adding capability metadata for interoperability. This is a lower barrier to adoption with most of the same benefits. The spec could be reframed as: devices are the resources, capabilities are a standardized vocabulary for describing what those devices can do, and the capabilities endpoint is an index into device functionality -- not a replacement for device-specific APIs.

## 8.0 Conclusion

The capability-centric model is the right long-term direction for AV interoperability. But the current specification defines it as a mandate (Section 1.0, Section 3.2) while deferring the details that would make it implementable (the registry, the schemas, the interaction model). This puts manufacturers in an untenable position.

The working group should either:

1. **Define the capability contracts** (at least for the minimum functionality set) before expecting manufacturers to implement the model, or
2. **Explicitly mark the capability model as aspirational** in v1, with the capabilities endpoint serving as discovery-only, and commit to a timeline for the registry and interaction specifications

The worst outcome would be multiple manufacturers implementing incompatible interpretations of an underspecified model, each claiming OpenAV compliance, and producing an ecosystem that is no more interoperable than what exists today.
