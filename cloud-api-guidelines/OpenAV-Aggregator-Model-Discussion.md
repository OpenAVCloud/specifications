# Discussion: Viability of the Individually-Addressable Child Device Requirement

Document Version: 0.1 (Draft -- For Working Group Discussion)
Prepared by: Greg Herlein
Date: April 13, 2026

## 1.0 Purpose

This document examines the requirement that devices behind aggregators or proxies must be individually addressable, as stated in Section 3.4 of the AV Device Minimum Functionality Guidelines. It traces where this requirement is defined, identifies what the specification set does and does not say about device-to-device control relationships, and discusses the practical implications for real-world AV deployments where most devices are not directly connected to the network and instead depend on other devices to reach them.

The concern is not that hierarchical device management is a bad idea. It is that the spec mandates a flat, individually-addressable device model in a world where AV systems are inherently hierarchical, and it does so without defining the mechanisms, relationships, or boundaries that would make such a model workable.

## 2.0 Where the Requirement Is Defined

### 2.1 The Single Source: Min Functionality Guidelines Section 3.4

The requirement appears in exactly one place across the entire OpenAV specification set:

**AV Device Minimum Functionality Guidelines, Section 3.4 -- Device Proxies/Aggregators:**

> 3.4.1 For devices that utilize an aggregator or proxy on the network, all the guidelines defined in this document will apply to the aggregator. The aggregator is expected to structure its child devices into a logical model that allows these guidelines to also apply to the children (i.e. child devices must have individual status, and functions such as firmware updates etc.).

This single paragraph carries significant implications. It states:

1. All minimum functionality requirements apply to the aggregator itself
2. The aggregator must structure child devices into a "logical model"
3. The guidelines must also apply to each child device individually
4. The parenthetical example specifically calls out "individual status" and "functions such as firmware updates" for child devices

### 2.2 What the Other Specs Say About This

**Cloud API Spec (v0.3):** Does not mention aggregators, proxies, parent devices, child devices, or device hierarchies at any point. The only endpoint for devices is `GET /v1/devices` and `GET /v1/devices/{deviceId}/capabilities`. There is no mechanism for expressing device relationships -- no `parentDeviceId`, no `children` array, no `/v1/devices/{id}/children` endpoint.

**AV Device Taxonomy Guidelines (v1.1):** Does not mention aggregators or proxies. Every device category is described as a standalone entity. The taxonomy's stated goal is "to capture all the possible categories of AV products that can be integrated and managed at a customer site" -- with no acknowledgment that many of those products are only reachable through other products.

**AV Device Security Guidelines:** No references to aggregator or proxy relationships.

### 2.3 Summary of Spec Coverage

| Document | Mentions aggregators/proxies? | Defines relationships? | Defines mechanisms? |
|---|---|---|---|
| Min Functionality Guidelines 3.4 | Yes -- one paragraph | Implies parent/child | No |
| Cloud API Spec | No | No | No |
| Device Taxonomy | No | No | No |
| Security Guidelines | No | No | No |

The requirement exists in isolation. It is defined in the Min Functionality doc but has no corresponding support in the API spec that would need to implement it or the taxonomy that would need to classify the relationships.

## 3.0 How Real AV Systems Are Actually Wired

The individually-addressable requirement assumes a model where every device has its own network presence and can be reached independently. This does not reflect how commercial AV systems are deployed.

### 3.1 Typical Conference Room

A standard corporate conference room might contain:

| Device | Network Connected? | How It Is Reached |
|---|---|---|
| Display (TV/Projector) | Sometimes | Often controlled via RS-232 serial or HDMI-CEC from a control processor or media player |
| Ceiling speakers | No | Driven by an amplifier, which is driven by a DSP |
| Ceiling microphones | Sometimes | Often connected to a DSP via analog or Dante, not IP-addressable independently |
| DSP (audio processor) | Yes | IP-connected, controls mic/speaker routing |
| Camera (PTZ) | Usually | IP or USB, sometimes controlled via serial from a codec |
| Media player / Codec | Yes | Primary control device, manages display + camera |
| Control panel (wall touch) | Sometimes | May be IP, may be serial/IR from control processor |
| HDMI switcher | Rarely | Often controlled via serial from control processor |

In this single room, of 8 devices, perhaps 3-4 have independent IP addresses. The rest are reached through serial, analog, CEC, USB, or proprietary bus connections from a device that does have a network connection. This is not a deficiency -- it is by design. Not every device needs or benefits from a network stack.

### 3.2 Digital Signage Installation

| Device | Network Connected? | How It Is Reached |
|---|---|---|
| BrightSign media player | Yes | Cloud-managed via BSN.cloud |
| Commercial display | No | Controlled via RS-232 serial or CEC from the media player |
| Audio amplifier | No | Line-level audio from the media player |
| Speakers | No | Driven by the amplifier |

The media player is the only networked device. It controls the display's power, input selection, and volume via serial commands. The display, amplifier, and speakers have no network presence whatsoever.

### 3.3 Large Venue / Auditorium

| Device | Network Connected? | How It Is Reached |
|---|---|---|
| Control processor (Crestron/Extron/AMX) | Yes | Central brain, everything routes through it |
| 4x projectors | Maybe | Some IP-controlled, some serial-only |
| 12x ceiling speakers | No | Driven by amplifiers |
| 4x amplifiers | Maybe | Some networked (Dante), some analog-only |
| 8x wireless microphones | No | RF to receivers, receivers may or may not be networked |
| 2x cameras | Yes | IP-connected, but presets controlled by the control processor |
| Matrix switcher | Sometimes | Often controlled via serial from control processor |
| Lighting controller | Sometimes | DMX/sACN, may have IP gateway |
| Motorized shades | No | Controlled via serial/relay from control processor |

In a venue with 30+ devices, the control processor is the aggregator for most of them. Many devices are separated from the network by one, two, or even three layers of intermediary devices.

### 3.4 The Pattern

The common pattern across all AV deployments is:

1. A small number of "gateway" devices connect to the IP network
2. Those gateways control many downstream devices via non-IP protocols (serial, CEC, IR, analog, GPIO, USB, DMX, Dante)
3. Downstream devices often have no awareness they are being managed and provide no API of their own
4. The gateway is the only point of contact for all devices it controls

This is the aggregator/proxy pattern. Section 3.4 acknowledges it exists. The problem is what Section 3.4 demands of it.

## 4.0 What Section 3.4 Actually Requires

Parsing the requirement carefully:

> "all the guidelines defined in this document will apply to the aggregator"

This is straightforward. The aggregator (the networked device) must meet all minimum functionality requirements itself. Most manufacturers can comply with this.

> "The aggregator is expected to structure its child devices into a logical model"

This implies the aggregator must maintain a data model that represents each downstream device as a distinct entity. This is a real software requirement -- the aggregator must discover, enumerate, and track the devices it controls.

> "that allows these guidelines to also apply to the children"

This is where the requirement becomes problematic. "These guidelines" means the full minimum functionality requirements. Applied to child devices, this means:

### 4.1 Child Devices Must Report Individual Status (Section 2.1)

> Devices must implement the ability to report current operational status (e.g. Power State On/Off/Standby).

For a display controlled via RS-232: Possible in some cases. Many commercial displays respond to serial status queries for power state. But "uptime since last reboot" (Section 2.1.2)? Most displays controlled via serial have no concept of reporting uptime to the controlling device.

For passive speakers: Impossible. A ceiling speaker driven by an amplifier has no operational status to report. It is either physically present or not.

### 4.2 Child Devices Must Report Inventory (Section 2.2)

> Devices must report a manufacturer identifier... model number... globally unique serial number... firmware version.

For a display controlled via serial: Sometimes possible. Some commercial displays respond to serial queries for model and serial number. Many do not. Firmware version is rarely queryable via serial.

For analog devices (speakers, amplifiers on analog inputs, passive video splitters): Impossible. These devices have no digital interface through which to query inventory information.

### 4.3 Child Devices Must Support Remote Operations (Section 2.3)

> Devices must support a remote (via API) reboot operation.

For a display controlled via serial: The aggregator can send a power-off/power-on sequence. But is that a "reboot"? The display may not have a reboot command.

> Devices must support remote firmware updates.

For a display controlled via serial: Not possible through the serial control interface. Display firmware updates require direct USB, network access on the display itself, or manufacturer-specific tooling.

For non-networked devices: Not possible at all through the aggregator.

### 4.4 Child Devices Must Report Networking Information (Section 2.4)

> Devices must support reporting network status, including IP Address, MAC Address, Subnet Mask, Default Gateway, DNS Server and Connection Type.

For devices controlled via serial, CEC, or analog: They have no network status. A display controlled via RS-232 may not have an IP stack at all. A passive speaker has no MAC address. This requirement is logically inapplicable to non-networked devices, but Section 3.4 makes no exception for it.

### 4.5 Child Devices Must Support Discovery (Section 2.7)

> Device must support a means to auto-discover units present on the network using a standard protocol (e.g. mDNS, LLDP etc).

For non-networked devices: Impossible by definition. A device that is not on the network cannot be discovered via network protocols.

## 5.0 The Fundamental Tension

Section 3.4 attempts to extend network-native device management concepts to devices that are not network-native. The minimum functionality requirements were clearly written with directly-networked devices in mind -- every requirement assumes the device has an IP stack, a network presence, and the ability to respond to queries. Section 3.4 then retrofits these requirements onto non-networked devices by requiring the aggregator to make them appear individually addressable.

This creates three categories of compliance:

### 5.1 Requirements the Aggregator Can Fulfill by Proxy

| Requirement | Feasibility | How |
|---|---|---|
| Power state (2.1.1) | Often possible | Query via serial/CEC, report on behalf of child |
| Manufacturer/model (2.2.1-2.2.2) | Sometimes possible | Query via serial if supported, otherwise manual config |
| User-friendly name (2.2.7) | Always possible | Aggregator assigns a name |
| Video status (2.5.1.2) | Sometimes possible | Query via serial/CEC for input signal status |
| Audio mute (2.6.1.2) | Often possible | Aggregator controls mute via serial/CEC |

### 5.2 Requirements the Aggregator Can Fake but Not Truly Fulfill

| Requirement | Issue |
|---|---|
| Serial number (2.2.3) | Aggregator can store a manually-entered serial, but cannot query it from most non-networked devices. Requires manual data entry at installation time. |
| Firmware version (2.2.4) | Aggregator has no way to query firmware version from a device it controls via serial. Can store a manually-entered value that becomes stale. |
| Uptime (2.1.2) | Aggregator can track how long since it last power-cycled the child, but this is not the child's actual uptime. |

### 5.3 Requirements That Are Inapplicable to Non-Networked Devices

| Requirement | Why |
|---|---|
| Remote firmware update (2.3.2) | Cannot update firmware of a device over a serial control link |
| Network status reporting (2.4.1) | Non-networked devices have no network status |
| WiFi reporting (2.4.3) | Not applicable |
| Network discovery (2.7.1) | Cannot discover via mDNS/LLDP if not on the network |
| Remote log retrieval (3.2.1) | Non-networked devices do not produce retrievable logs |

## 6.0 The Cloud API Spec Does Not Support the Model

Even if a manufacturer solves the on-device problems and builds an aggregator that can represent child devices, the Cloud API spec provides no mechanism to express the relationship:

### 6.1 No Parent-Child Relationship in the API

`GET /v1/devices` returns a flat list. There is no field for `parentDeviceId`, `aggregatorId`, `controlledBy`, or any other relationship indicator. A BrightSign player and the display it controls via serial would both appear as top-level devices with no visible connection between them.

An integrator querying the API cannot tell:
- Which devices are directly network-connected vs. proxied
- Which device controls which other device
- Whether an operation on a child device will be fulfilled directly or brokered through an aggregator
- What the latency or reliability characteristics of the proxy relationship are

### 6.2 No Mechanism for Partial Compliance

The API provides no way for an aggregator to signal that a child device supports some requirements but not others. If a display controlled via serial can report power state but not firmware version, there is no field or convention to express "this device reports power state but firmware version is unknown/unavailable."

### 6.3 No Concept of Proxied Operations

If an integrator sends a reboot command to a child device, there is no mechanism to indicate that the command will be proxied through an aggregator, that it may take longer than a direct network command, that it may fail silently if the serial connection is interrupted, or that the aggregator may not be able to confirm the child actually rebooted.

### 6.4 No Topology or Wiring Information

Real AV troubleshooting depends on understanding the signal chain. If a display is showing no video, the technician needs to know: is the media player sending signal? Is the matrix switcher routing to the correct output? Is the HDMI cable connected? The API provides no way to express signal flow or physical connectivity.

## 7.0 Scale of the Problem

This is not an edge case. Consider how many devices in the AV Device Taxonomy are commonly controlled by other devices rather than connected directly to the network:

| Taxonomy Category | Commonly Network-Connected? | Commonly Controlled Via |
|---|---|---|
| Monitors & Screens | Sometimes (smart displays) | Serial, CEC, IP (varies) |
| Projectors | Sometimes | Serial, IP, PJLink |
| Video Walls (LED panels) | Rarely per-panel | Proprietary controller/processor |
| Speakers | No | Amplifier (analog or Dante) |
| Amplifiers | Sometimes | Serial from control processor, sometimes Dante |
| Microphones | Sometimes (Dante/AES67) | Analog to DSP, sometimes Dante |
| Cameras (PTZ) | Usually | IP, sometimes serial from codec |
| Remote Controls | No | IR/RF to receiver |
| Switchers | Sometimes | Serial from control processor |
| Splitters/DAs | Rarely | Usually unmanaged |
| Media Players | Yes | Cloud-managed |
| Power Management (PDU) | Sometimes | Serial/IP to control processor |

A significant portion of the taxonomy consists of devices that are routinely deployed without direct network connectivity. The aggregator/proxy pattern is not an exception -- it is the dominant deployment model for most device categories.

## 8.0 Comparison With Industry Precedent

### 8.1 Matter / Thread

Matter handles this through a "bridge" device type. A Matter bridge represents non-Matter devices to the Matter fabric. Critically, Matter defines:
- A `Bridged Device Basic Information` cluster with a reduced set of attributes (no networking info required for bridged devices)
- A `Reachability` attribute that indicates whether the bridge can currently communicate with the child
- The bridge is the explicit parent, and child devices carry a `PartsList` indicating the bridge relationship

Matter explicitly acknowledges that bridged devices have a reduced capability set. Not every cluster is expected to work through a bridge.

### 8.2 ONVIF

ONVIF (used for IP cameras and video devices) assumes all devices are IP-connected. It does not have an aggregator model. This works for ONVIF's scope (IP video surveillance) but would not work for AV systems where serial-controlled devices are the norm.

### 8.3 Z-Wave / Zigbee

Both Z-Wave and Zigbee have explicit hub/controller models where the hub mediates access to child devices. Child devices have reduced capability expectations based on their device class. A battery-powered sensor is not expected to support the same operations as a mains-powered switch.

### 8.4 The Pattern

Successful IoT/device management standards that handle proxied devices define:
1. An explicit bridge/hub device type
2. A reduced requirement set for bridged/proxied devices
3. A reachability indicator
4. A formal parent-child relationship in the data model

The OpenAV spec does none of these.

## 9.0 Practical Consequences if Implemented As Written

### 9.1 Phantom Devices With Stale Data

If aggregators must register child devices and report their inventory, much of that data will be manually entered at installation time and never updated. A display's serial number will be typed in once. Its firmware version will be entered once and become stale after the first manual firmware update that the aggregator was not involved in. The API will report data that appears authoritative but is actually a snapshot from installation day.

### 9.2 False Compliance

Manufacturers will be forced to report capabilities they cannot truly fulfill. An aggregator will claim a serial-controlled display supports "remote firmware update" because the spec requires it, then return an error or silently fail when the operation is attempted. This is worse than not listing the capability -- it misleads integrators into believing an operation is possible.

### 9.3 Massive Inventory Inflation

A single conference room with a control processor, display, camera, DSP, amplifier, 4 ceiling speakers, and 2 microphones would register 10 devices in the API. Scale this across a 500-room enterprise campus and the API now tracks 5,000 devices, the majority of which are passive or serial-controlled with incomplete data. The signal-to-noise ratio of the device inventory degrades significantly.

### 9.4 Unclear Responsibility Boundaries

If a BrightSign player controls a display and the display is also managed by a Crestron control processor, who is the aggregator? Both devices can send serial commands to the display. Do both register it as a child device, creating duplicates in the API? Does the display appear twice with potentially conflicting status data?

## 10.0 Recommendations

### 10.1 Define an Aggregator Device Type in the Taxonomy

The taxonomy should include a device type for aggregators/controllers that explicitly describes the parent-child relationship. This device type should define:
- How child devices are enumerated
- How the aggregator-to-child control protocol is described (serial, CEC, IP, etc.)
- What happens when multiple aggregators control the same physical device

### 10.2 Define a Reduced Requirement Set for Proxied Devices

Not every minimum functionality requirement should apply to devices accessed through a proxy. The spec should define three tiers:

**Tier 1 -- Directly Connected:** Full minimum functionality requirements apply. The device has its own IP stack and network presence.

**Tier 2 -- Managed Proxy:** Device is reachable via a smart protocol (IP control, PJLink, Dante) through an aggregator. Most requirements apply, but the aggregator mediates access. Network information requirements may not apply.

**Tier 3 -- Passive/Unmanaged:** Device is controlled via basic protocol (serial, CEC, IR, analog) or is entirely passive (speakers, cables, passive splitters). Only inventory registration and basic status (reachable/unreachable) should be required. Firmware update, network reporting, and discovery requirements are inapplicable.

### 10.3 Add Relationship Fields to the Cloud API

The Cloud API `GET /v1/devices` and capabilities endpoints should include:

```json
{
  "deviceId": "display-conf-room-b",
  "connectionType": "proxied",
  "aggregator": {
    "deviceId": "brightsign-player-042",
    "protocol": "rs232",
    "reachable": true,
    "lastContact": "2026-04-13T14:22:00Z"
  },
  "complianceTier": 3,
  "limitedCapabilities": true
}
```

This allows integrators to:
- Distinguish directly-connected from proxied devices
- Understand the reliability characteristics of the connection
- Avoid sending unsupported operations to devices that cannot fulfill them
- Trace the control chain for troubleshooting

### 10.4 Define a Reachability Indicator

Borrowing from Matter's model, proxied devices should have a `reachable` attribute that the aggregator maintains. This is distinct from "online" -- a device may be powered on but unreachable if the serial cable is disconnected. The aggregator is the only entity that knows the current state of the proxy link.

### 10.5 Address the Multi-Aggregator Problem

The spec should define rules for when multiple network-connected devices can control the same physical device:
- Does the device appear once or multiple times in the API?
- If once, which aggregator is the "owner"?
- How is ownership transferred when equipment is reconfigured?
- How are conflicting commands resolved when two aggregators send contradictory instructions to the same device?

### 10.6 Acknowledge That Some Devices Should Not Be Registered

Not every physical device in an AV system needs to appear in the cloud API. Passive speakers, analog cables, HDMI splitters, and other infrastructure components add noise without value. The spec should define criteria for which devices must be registered and which are reasonably excluded.

## 11.0 Conclusion

Section 3.4 of the Minimum Functionality Guidelines identifies a real problem -- many AV devices are reachable only through other devices -- and proposes a reasonable aspiration: those devices should be individually manageable through their aggregator. But the single-paragraph treatment does not grapple with the practical realities of AV deployment:

- Most devices behind aggregators cannot fulfill the full minimum functionality requirements
- The Cloud API has no mechanism for expressing device relationships
- The taxonomy does not classify aggregators or define control topologies
- Multi-aggregator scenarios are unaddressed
- No distinction is drawn between devices that can be meaningfully proxied and devices that are fundamentally passive

The working group should either define the aggregator model in full -- with tiered requirements, explicit relationship fields in the API, reachability indicators, and multi-aggregator rules -- or explicitly scope the initial specification to directly-networked devices only, deferring the aggregator model to a future iteration. The current state of one mandating paragraph with no supporting infrastructure in the API spec or taxonomy creates a requirement that manufacturers cannot comply with in a meaningful or interoperable way.
