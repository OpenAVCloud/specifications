# Discussion: Implementation Challenges of Building Practical Cloud-to-Cloud AV Interoperability to the OpenAV Specs

Document Version: 0.1 (Draft -- For Working Group Discussion)
Prepared by: Greg Herlein
Date: June 8, 2026

## Executive Summary

The OpenAV Cloud-to-Cloud API exists to let one vendor's management platform discover and operate another vendor's AV equipment without custom, one-off integration. That promise -- multi-vendor interoperability across signage, conferencing, audio, and large-venue systems -- is the reason the membership is investing in the standard.

**What is missing.** The API describes each device as an isolated record: an identifier, a status, and a list of features. It says nothing about *where* the device is, *what it is part of*, or *how it relates to the equipment around it*. There is no concept of a site, building, room, or zone, and no way to express that a microphone belongs to a particular audio processor, that a display is driven by a particular media player, or that a set of panels make up one video wall. A partner platform that queries the API receives a flat, unordered, location-less list of opaque device IDs.

**Why it matters to the business.** Real operations are expressed in terms of place and grouping, not isolated devices. A partner cannot reliably "mute the microphones in Room 214" or "power down every display in this building," because the API never tells it which devices those are. The missing relationships must instead be reconstructed by hand, outside the standard, for every site and every integration -- which is precisely the bespoke, non-portable work the initiative set out to eliminate. As written, the promised interoperability holds for listing devices but breaks at the moment a partner needs to take real-world action. The detailed analysis and three worked cross-vendor scenarios (Appendix B) trace exactly where it breaks.

**How to fix it, at a high level.** The fix is not more API endpoints. The starting point, before any API, is an agreed-upon data model -- a shared definition of devices, their capabilities, their locations, and, critically, their relationships to one another. An API is only a projection of a data model; if the model cannot represent location and association, no API design can exchange them. Once the membership agrees on that model, the REST API to expose it follows naturally. Section 10 lays out this approach and the concrete elements the model and API need.

## 1.0 Purpose

The goal of the OpenAV Cloud-to-Cloud REST API is interoperability between the cloud platforms that manage AV equipment: enabling one vendor's cloud (a signage CMS, a conferencing-room management service, an audio-system platform, an enterprise dashboard) to discover and operate the devices managed by another vendor's cloud, without bespoke per-vendor integration. That is the lens this document uses. It does not evaluate whether the requirements are conceptually sound; it asks a narrower, more practical question: can an engineer handed the current specs build an interoperability system that actually works across the range of equipment the OpenAV membership ships?

That range matters, because it is wide. The membership spans digital signage (BrightSign, Navori, Signagelive, Korbyt, Appspace), professional displays and projection (Sony, Panasonic, Planar, Barco, Optoma), large-format LED and its processing (Planar, NovaStar, Megapixel), professional and conferencing audio (Shure, Bose Professional, Yamaha, ClearOne, L-Acoustics, AtlasIED, Ecler), cameras and collaboration (Logitech, Huddly, Vaddio/Legrand AV), AV-over-IP and switching (Wyrestorm), and the network, power, and structural infrastructure that ties it together (Netgear, Legrand AV). Appendix A catalogs this device population and classifies it by how it connects. Digital signage is the flagship use case and, as Section 9 argues, the most tractable place to start -- but the spec that signage adopts will be applied across all of these AV applications, and the analysis below holds for every one of them.

## 2.0 The Shape of the Problem

Interoperability begins with one cloud calling another's API to find out what devices exist and to act on them. The first thing a calling cloud learns is also the first sign of trouble: the API hands back devices that describe *what they are* and *what they can do*, but not *where they are*, *what they belong to*, or *how to reach the physical thing*. The complete descriptive device payload the API defines (API spec Section 7.3) is:

```json
{
  "deviceId": "abc-123",
  "deviceState": "ONLINE",
  "hardwareIdentity": { "serialNumber": "1232123456" },
  "softwareIdentity": { "firmwareVersion": "4.5.0", "model": "Microphone" },
  "capabilities": ["firmware-version", "audio-mute"]
}
```

That is the entire model: an identifier, a state, two identity strings, and a capability list. There is no `location`, `site`, `building`, `room`, or `zone`; no `ipAddress` or `macAddress`; and no `parentDeviceId`, `aggregator`, `children`, or `group`. The endpoint set offers no remedy -- `GET /v1/devices`, `GET /v1/devices/{deviceId}`, and `GET /v1/devices/{deviceId}/capabilities` (API spec Section 12) are the only device resources; there is no `/sites`, `/locations`, `/groups`, or `/devices/{deviceId}/children`. The device list is described as supporting filtering (API spec Section 12.1, deferring to the pagination parameters of Section 6), but no location or association query parameter is defined and the schema exposes no attribute to filter on, so even filtering by site is unspecified in practice. A calling cloud therefore receives a flat, unordered, location-less list of opaque identifiers. It cannot learn from the API that two devices share a room, that a microphone belongs to a particular DSP, that a display sits in a named building, or that a set of panels make up one video wall.

This single gap -- call it the **association problem** -- is what breaks the practical use cases the API exists to enable. Appendix B works three of them end to end; in summary:

- **A content platform readying displays before a campaign (Appendix B.1)** queries a partner cloud and gets a flat list of player identifiers with no building or room, and no indication of which player drives which display. It can target the right screens only because a human supplied that mapping out of band.
- **A room-booking system preparing a meeting room across two audio vendors (Appendix B.2)** cannot assemble "the audio system for this room" from the response, because nothing links the ceiling microphones to their DSP or tags any of them with a room.
- **A show-control platform driving an LED wall it does not own (Appendix B.3)** receives a single identifier for the processor, with no way to discover the wall's panel composition or the venue it sits in.

In every case the calling cloud must already hold, outside the API, the very associations the API was supposed to convey. The interoperability the spec promises stops at the moment a partner needs to know *where* something is or *what it is part of* -- and, as the rest of this document shows, the same omission blocks *how to reach it* and *what to say to it*.

Underneath that flat list is a delivery chain, and the chain has the same shape in every AV application even though the devices differ:

```
Managing cloud  ->  OpenAV REST API  ->  Vendor cloud  ->  Networked anchor device
                                                              ->  Downstream device (RS-232 / CEC / analog / Dante / proprietary)
```

The "networked anchor" is whatever device in a given system actually has an IP presence and reports to a vendor cloud. Which device plays that role depends on the application:

| AV application | Typical networked anchor | Typical downstream devices |
|---|---|---|
| Digital signage | Media player (or integrated smart display) | Commercial display, audio amp, video-wall panels |
| Corporate conferencing | Room kit / DSP / codec | Ceiling mics, display, PTZ camera, amplifier |
| Live sound / large venue | Audio DSP / mixer / amplifier network | Loudspeakers, stage mics, amplifier channels |
| LED video wall | LED processor / controller | Individual LED cabinets/panels |
| Control-room / AV-over-IP | Control processor / AV-over-IP fabric | Displays, projectors, matrix-switched sources |

The REST API sits at the top of this chain and speaks in clean abstractions: a device has a `deviceId`, a list of capabilities, and a status. The anchor is the one node the vendor cloud can actually reach. Below it, the chain speaks RS-232 baud rates, CEC logical addresses, Dante flow subscriptions, proprietary display and amplifier command dialects, and LED-controller protocols. The entire job of an OpenAV implementation is to translate between these two worlds and keep them consistent.

There is an important variation that changes the shape of the chain: **the anchor and the device may be one and the same.** A system-on-chip signage display (Samsung Tizen, LG webOS, BrightSign-integrated), an all-in-one conferencing video bar (Logitech, Bose), or a networked self-powered loudspeaker collapses anchor and endpoint into a single network-connected unit. When that is the case, the chain has *no* downstream hop, the device is directly addressable, and the association problem this document describes largely evaporates for that unit. This is the best case, and it is increasingly common. The difficulty is that an interoperability implementation cannot assume either form factor:

```
Split topology:      vendor cloud  ->  networked anchor  ->  downstream device (serial / Dante / proprietary)
Integrated topology: vendor cloud  ->  device (anchor and endpoint are one networked unit)
```

The same OpenAV `deviceId` might denote a tightly integrated smart display or video bar whose every capability is directly fulfillable, or a networked player/DSP/processor fronting a dumb panel, a passive loudspeaker, or a serial-only projector. The spec gives software no way to tell these apart, yet they demand completely different handling.

The specs define the top of the chain in detail. They define nothing about the translation. That translation layer -- call it the **resolver** -- is where all the engineering difficulty lives, and it is precisely the part the specs leave to each vendor to invent privately. Because every vendor invents it differently and behind their own cloud, the stated goal of cloud-to-cloud interoperability is undermined at exactly the layer that matters most.

## 3.0 A `deviceId` Is Not an Address

The Cloud API returns devices keyed by `deviceId` (see Section 7.3 and Section 12.1). The spec treats this identifier as the handle through which all operations on a device are performed. But a `deviceId` is an opaque label. It is not routable. To act on a device, software must answer a question the spec never poses:

> Given a `deviceId`, where is it, how do I reach it, and what do I say when I get there?

For a networked anchor device -- a media player, a DSP, an AV-over-IP encoder, an integrated display, a conferencing bar -- the answer is a tuple along the lines of `{ip, port, protocol, credentials, command-dialect}`, and even that is not provided by the API. There is no field that says "this device is at 10.2.14.7, speaks PJLink on TCP 4352" or "this DSP exposes its mixer at this control port." The integrating cloud must hold that mapping outside the spec. For anchor devices this is the *easy* case, because the device is genuinely on the network and genuinely addressable.

For a downstream device -- the display behind a player, the loudspeaker behind an amplifier, the ceiling mic behind a DSP, the panel behind an LED processor, the projector behind a control processor -- the answer is worse, because the addressable target is not the device at all. It is the anchor, plus an internal addressing scheme that selects the downstream device:

| Downstream device reached via | The real addressable target is | Selecting the device requires |
|---|---|---|
| RS-232 from a player or control processor | The anchor's IP / vendor-cloud handle | A serial port and the device's command dialect (e.g. Samsung MDC, NEC, Sony, PJLink) |
| HDMI-CEC | The anchor's IP / vendor-cloud handle | A CEC logical/physical address |
| Dante / AES67 | The DSP or domain controller | A flow/channel subscription identity |
| Analog audio | The driving amplifier or DSP | An output channel or zone |
| LED video wall | The LED processor's IP | A cabinet/panel row-column index |
| Matrix switcher | The switcher's control IP | An input/output crosspoint |
| RS-485 multidrop bus | The bus master's IP | A bus address on a shared wire |

In every one of these cases the downstream device's `deviceId` must resolve to *the anchor's network address plus an anchor-internal selector*. The spec provides neither half of that resolution, and provides no `aggregator`, `parentDeviceId`, or `controlledBy` field that would even hint at the existence of the first half -- the same association gap surfaced in Section 2.0, now seen as a routing problem rather than a location one. So the moment the operator's intent concerns a downstream device rather than the anchor, the API gives software no way to find the thing it must talk to.

The integrated unit is the exception that proves the rule: there, the device *is* the networked anchor, so resolving the `deviceId` to a target is trivial and the selector is empty. But because the spec exposes no field distinguishing an integrated unit from an anchor fronting a downstream device, software cannot know in advance whether a given `deviceId` resolves trivially or needs the full proxy treatment above. It must be built to handle both and to discover which it is facing -- a determination the API does not surface.

## 4.0 The Resolution Table Is the Real System of Record

Because the API cannot express any of the above, every implementation must build and maintain a private resolution table: the authoritative mapping from logical `deviceId` to physical addressable target. This table is the true heart of the system, and it has properties that make it hard to build and harder to keep correct:

1. **It is populated mostly by hand.** A serial-controlled display, a passive loudspeaker, or an analog mic cannot announce its own identity to its anchor. At install time, a technician types in "the display on this player's serial port is a Samsung QM series at 9600 baud," or "zone 3 of this amplifier drives the lobby speakers," or "ceiling mic 2 is on Dante channel 7 of this DSP." Nothing in the field validates that entry, and nothing detects when it drifts from reality. In simple topologies (one display per signage player) this is bounded; in a conferencing room or a venue audio rack it can be dozens of manual associations.

2. **It is not standardized, so it is not portable.** Two OpenAV clouds federating with each other each hold their own private resolution table in their own schema. There is no interchange format. A managing cloud that wants to mute a partner cloud's microphone or power down its display cannot learn the routing -- it can only ask the owning cloud to perform the action and trust the result. This is the practical ceiling on cloud-to-cloud interoperability, and it is precisely the boundary OpenAV exists to dissolve.

3. **It is the single point of correctness for the whole system.** If the table says a player's serial port drives a Samsung display but an installer swapped in an NEC unit, or says a speaker is on amplifier zone 3 when it was re-patched to zone 4, every command on that `deviceId` now goes to the wrong place in the wrong dialect and silently fails or misbehaves. There is no spec-defined mechanism to detect or repair this.

## 5.0 Identity and Correlation Over Time

The resolution table only works if `deviceId` is stable and if the thing it points to can be re-identified after change. For networked anchors this is mostly manageable -- a cloud-managed player, DSP, or video bar has a stable vendor-cloud identity and usually a queryable serial number. For downstream devices, both assumptions are fragile:

- **DHCP churn.** An anchor's IP is not stable. If the resolver keyed on IP, a lease change breaks routing. If it keyed on MAC, it survives -- but the Min Functionality spec lists MAC as a *reported* field, not a stable correlation key, and a downstream display, speaker, or analog mic has no MAC the cloud can see at all.
- **Unqueryable downstream identity.** The natural stable identity is the serial number, but most serial- and analog-controlled devices cannot reliably report one over the control link. So the downstream device's identity is pinned manually once and never re-verified. After it is RMA'd and replaced, the physical device is different but the `deviceId` and its claimed serial are unchanged.
- **Re-cabling and re-homing.** Moving a display to a different player, a speaker to a different amplifier channel, or a mic to a different DSP changes the physical association while the logical identity must remain stable to preserve history, scheduling, and configuration. The spec has no concept of "this device moved to a different anchor but it is the same device," nor its inverse, "same anchor port, different device."
- **Reset or firmware change.** A device reset or an anchor factory-reset can change what is queryable. Without a stable hardware-rooted identity for the downstream device (which a serial-only or passive device effectively lacks), correlation is guesswork.

The integrated unit simplifies this considerably: anchor and endpoint share one stable, network-rooted, queryable identity, so there is nothing to pair and little to drift. But this only sharpens the modeling problem -- an implementer must decide, with no guidance, what `deviceId` is anchored to (the anchor, the downstream device, or the pairing) *and* must use the same model whether a given unit is integrated or split, because the spec gives no signal which one a `deviceId` represents. Every choice trades one failure mode for another.

## 6.0 Reachability Is Not Liveness, and the Chain Has Many Links

The Min Functionality spec models status largely as a device property (power state, uptime). A practical implementation cannot, because for downstream devices "status" is a property of the *path*, not the device:

- A display can be powered on and showing content while its RS-232 cable is unplugged -- the anchor reports reachable = false, but the display is not "off," it simply cannot be controlled.
- A DSP can be online and reporting healthy while a Dante mic below it has dropped its subscription -- the cloud sees green, the room has no audio.
- An anchor can confirm it is *outputting* video or audio while having no way to confirm the downstream device is actually *rendering* it.

Each hop in the chain of Section 2.0 has an independent health state, and the cloud's single `status` field collapses all of them into one value. For signage this is the difference between "the campaign is playing" and "the player thinks the campaign is playing"; for conferencing and live sound it is the difference between "the system is armed" and "the room actually has sound and picture." A single `reachable` boolean (as smart-home standards such as Matter define for bridged devices) addresses only the last hop. A real implementation needs per-hop health to do anything useful for the proof-of-play, fault detection, and remote troubleshooting that customers actually pay for, and must invent its own representation because the spec offers one flat status.

## 7.0 Commands: Translation, Confirmation, and Idempotency

Even after the resolver has produced a target and a transport, executing an operation surfaces a new layer of difficulty that the capability model glosses over. The universal command sets operators actually use -- power and input on a display, gain and mute on an audio channel, PTZ on a camera, reboot on anything -- run straight into it.

- **Translation.** A generic intent ("power off," "mute," "set level," "recall preset") must become a device-specific byte sequence, and every brand uses a different one. Display power alone fans a single OpenAV `power-off` capability out to Samsung MDC, NEC, LG, Sony BRAVIA, and PJLink dialects; audio gain fans out across Shure, Bose, Yamaha, and ClearOne control protocols. The mapping from capability to wire command is per-model and lives, again, only in the resolver.
- **No acknowledgment.** Many control protocols are effectively fire-and-forget. The anchor sends `PWR OFF` over serial, or a level change over an analog-fronted path, and receives nothing back. It cannot confirm the device obeyed, cannot detect a severed cable mid-command, and cannot distinguish "done" from "ignored." Yet the REST layer is expected to return a success or failure to the federating cloud.
- **Idempotency and verification.** Retrying an unconfirmed command risks double-execution -- a `power-toggle` display that reads a retry as "turn back on," or a relative gain change applied twice -- are real hazards. Building reliable operations on top of unreliable, unacknowledged transports is real distributed-systems work that the spec assigns implicitly and silently.
- **The capability contract is missing.** Even once the target is resolved, the implementer does not know the request/response shape, because no capability has a defined operation contract, payload schema, or error model. The capabilities endpoint lists *what* a device can do but not *how* to invoke it. Resolution gets you to the device; the spec never says what to say to it.

## 8.0 Enrollment and Discovery Only Solve the Easy Half

Min Functionality §2.7 mandates network discovery via mDNS/LLDP. This finds the networked anchors -- the small set of IP-connected nodes -- and, for an integrated unit, that single discovery covers the endpoint too, since it is the networked device. But it cannot find anything downstream of an anchor, because those devices are not on the network by definition. So the discovery requirement automates enrollment for exactly the devices that need it least (the anchors, which the vendor cloud already knows about) and leaves the downstream population -- the displays, speakers, mics, and panels an operator most wants to manage -- to manual enrollment, which is the source of the stale, unvalidated resolution table in Section 4.0. The discovery story and the association story are disconnected: discovering a DSP or a player tells you nothing about the mics or display hanging off it. A topology-aware spec could close this by defining how an anchor reports the downstream devices it has detected (many displays return at least a model string over CEC or serial; Dante devices enumerate on the audio network), turning part of the manual table into discovered data -- and could let an integrated device simply declare itself as a single unit, so software is not left guessing.

Compounding this, the spec scopes discovery to *available resources and supported capabilities* only (API spec Section 11.1) -- not to where devices are or what controls what -- and defers device claiming, provisioning, and onboarding to a future release (API spec Section 16.1). Association and location are exactly what those deferred onboarding steps would establish, so the one place the API might capture them is explicitly out of scope for the initial release. As written, there is no point in the device lifecycle, from discovery through registration to query, at which a calling cloud can learn a device's location or its relationship to other devices.

## 9.0 What a Practical Implementer Actually Builds

Reconciling all of the above, a cloud-to-cloud AV implementation that works in the field must contain, today, the following components -- none of which the spec defines, all of which must be invented per-vendor:

1. A **resolver / topology database** mapping `deviceId` to `{addressable target, transport, protocol, selector, command dialect}`.
2. A **manual enrollment and provisioning workflow** to populate that database for everything discovery can't find, plus tooling to detect drift.
3. A **stable-identity policy** deciding what `deviceId` is anchored to and how to re-correlate after IP change, re-cabling, re-homing, or hardware swap.
4. A **per-hop health and reachability model** richer than the spec's single status field.
5. A **command translation and confirmation layer** that turns capability intents into the many per-brand wire protocols and copes with unacknowledged, non-idempotent transports.
6. A **state cache and reconciliation loop**, since downstream devices cannot always be polled and the cloud view inevitably diverges from physical reality.

Every one of these is non-trivial. Every one is a place where two compliant implementations will diverge. The specs standardize the thin layer that is easy to standardize (a REST envelope, a device list) and leave unstandardized the thick layer where interoperability is actually won or lost.

The encouraging part is that the list above is finite, and that the AV applications differ in how hard they make it. Digital signage is the most bounded -- usually one networked player and one display, often fused into a single integrated unit -- which makes it the natural first scope: the topology is short, the command set is small and universal, and the integrated case eliminates the proxy hop entirely. The richer applications (multi-mic conferencing rooms, venue audio racks, LED walls) exercise the same model at greater depth. Defining the association model against the signage case first, with an eye to the broader population catalogued in Appendix A, gets a working contract into the field while keeping it extensible to the harder topologies the membership also ships.

## 10.0 How to Fix It

Every problem in this document -- addressing, identity, reachability, command translation, and above all the missing location and association data of Section 2.0 -- traces back to a single root cause: there is no agreed model of what an AV device *is*, where it lives, and how it relates to the devices around it. The natural instinct is to fix the symptoms by adding API endpoints and fields. That is backwards. An API is only a projection of an underlying data model. If the model does not represent a room, a site, a parent-child control relationship, or a group, then no amount of endpoint design will let two clouds exchange those facts. The work has to start one level deeper.

### 10.1 Start With an Agreed Data Model, Not an API

The first deliverable is not an API revision; it is a shared data model that the membership agrees on. That model must define both the entities and the relationships among them:

- **Entities** -- sites and physical locations (building, floor, room, zone); devices; the distinction between a networked anchor and a downstream device; and logical groupings such as a video wall or a room's audio system.
- **Relationships** -- containment and location (this device is in this room, in this building); control and proxy (this downstream device is reached through this anchor); and grouping (these panels are one wall; these devices are one room system).

The relationships are the part the current specification omits entirely, and they are the part that makes interoperability real -- they are what let a partner cloud reason about "this room" or "this building" instead of a flat list of opaque IDs. Agreeing this model is the standards work that matters; the REST surface should be derived from it, not invented ahead of it. A capability vocabulary, an addressing scheme, and an identity contract all hang off this model, so it must come first.

The recommendations below are the concrete contents of that model and of the API that projects it. Each is framed to start with the tractable signage case and extend to the full device population in Appendix A.

### 10.2 Define a Resolution / Addressing Model

The spec should acknowledge that `deviceId` is logical and define how it relates to a physical addressable target. Even an optional, structured `addressing` block -- transport, host, port, protocol, and an anchor-relative selector for the downstream device -- would let federating clouds reason about routing instead of treating every device as an opaque remote-procedure call into a black box. The signage case needs only a small set of transports (a player's network handle plus an RS-232/CEC selector); the broader AV population adds Dante/AES67 subscriptions, amplifier zones, LED panel indices, and matrix crosspoints, but the block stays a small, enumerable set. Critically, the model must let an integrated device declare itself as directly addressable with an empty selector, so software can immediately distinguish the trivial case (anchor and endpoint are one) from the proxied case instead of probing to find out.

### 10.3 Define a Stable Identity Contract

State explicitly what `deviceId` must remain stable across (anchor reboots, IP changes, re-cabling) and what it must change across (hardware replacement). Define a correlation key hierarchy (hardware serial > MAC > manual anchor for downstream devices) and state whether a `deviceId` denotes the anchor, the downstream device, or the pairing, so clouds anchor identity consistently and can match devices when they federate.

### 10.4 Make Relationships, Location, and Reachability First-Class

Add `aggregator`/`parentDeviceId` and `reachable` fields so a downstream device can name the anchor that fronts it, and let `reachable` express per-hop path health rather than a single device-level boolean. Add the location and grouping data the model currently lacks (Section 2.0) -- at minimum a `location`/`site` reference and a `group` or video-wall membership -- and make those attributes filterable on `GET /v1/devices` so a partner cloud can ask "which devices are in this building" and get a meaningful answer. This directly powers the proof-of-play, fault detection, and remote troubleshooting that every AV application depends on -- routing, grouping, and diagnosis are impossible without expressed topology and location.

### 10.5 Specify Command Semantics, Not Just Discovery

Tie the capability operation model -- a defined set of verbs, payloads, and error responses for each capability -- together with the resolution model so that "what can this device do," "how do I reach it through its anchor," and "what do I send" form one coherent contract. This can start with the small, universal command set every platform already needs -- display power and input, audio level and mute, camera PTZ, reboot -- and grow from there. Discovery without addressing and without operation contracts is not enough to build against.

### 10.6 Define an Enrollment Model for Downstream Devices

Provide a standard way to enroll, correlate, and re-validate the devices behind an anchor -- the population discovery cannot reach -- including how an addressing entry is authored, how an anchor reports any model/identity it can read over CEC, serial, or Dante, and how the entry is corrected when the device is swapped or re-homed.

## 11.0 Conclusion

The OpenAV specs are implementable as a logical contract and, as written, unbuildable as a practical interoperability system, because the entire problem of connecting a logical `deviceId` to a real, addressable, command-able target is left undefined. That association problem -- resolution, stable identity, per-hop reachability, and command translation -- is not a detail to be filled in later; it is the substance of any working implementation, in every AV application the membership serves. By standardizing the easy logical layer and omitting the hard physical layer, the specs guarantee that each vendor solves the hard part privately and incompatibly, which is the precise opposite of the cloud-to-cloud interoperability the specifications set out to achieve.

But the device population also points to the way out. Across the membership the topology is the same shape everywhere -- a small set of networked anchors fronting a larger population of downstream and passive devices, with an increasing share of integrated units that need no proxy at all -- and that shape is finite and specifiable. Digital signage is the trivial end of the spectrum, where a single integrated display or a player-and-one-display pairing makes association nearly vanish; multi-mic conferencing rooms, venue audio racks, and LED walls are the harder end, but they exercise the *same* addressing, identity, relationship, and command model at greater depth. The working group should seize that commonality, and it should start where Section 10 argues it must: with an agreed data model that defines devices, their locations, and their relationships, against the signage case first and with the broader population of Appendix A explicitly in view -- rather than either leaving it to private invention or deferring it indefinitely. An API built on that model, specifying how a `deviceId` resolves to a real endpoint -- integrated or anchored, signage or conferencing or audio -- and what it belongs to, would deliver real cloud-to-cloud interoperability instead of a logical contract that every vendor must privately, and incompatibly, complete.

## Appendix A: Representative Device Population

The addressability tiers this document relies on are not a theoretical spread -- they map directly onto the equipment the OpenAV member companies actually ship. The table below catalogs the kinds of connected equipment that may appear in a deployment, drawn from the founding and contributing membership, and classifies each by how it connects. The classification is what determines whether a `deviceId` resolves cleanly to a network endpoint or must be proxied through an aggregator per Sections 3-9. Signage is the lead use case, but the membership spans the full range of AV applications, so this population is broader than signage alone.

Connectivity tiers:

- **Networked** -- has its own IP presence and is directly cloud-manageable; `deviceId` resolves to a real endpoint.
- **Mixed** -- networked on some models or configurations, serial/proprietary-only on others; the device *type* does not tell software which.
- **Downstream** -- typically reached only through an aggregator (RS-232, CEC, analog, Dante) or entirely passive; not independently addressable.
- **Cloud** -- a software or device-cloud platform; one of the federation endpoints the cloud-to-cloud API actually connects.

### Playback, content, and management

| Equipment | Example members | Tier |
|---|---|---|
| Media / signage players (incl. player built into a display) | BrightSign, Sony, Panasonic | Networked |
| CMS, content, and workplace-experience platforms | Navori, Signagelive, Korbyt, Appspace, Adobe | Cloud |
| Device-cloud / connected-product platform | Xyte | Cloud |

### Displays

| Equipment | Example members | Tier |
|---|---|---|
| Integrated smart displays (player and panel are one unit) | Sony, Panasonic, Optoma | Networked |
| Professional LCD/LED flat-panel displays | Sony, Panasonic, Planar, Optoma, Avocor, Barco | Mixed |
| Interactive / collaboration touch displays | Avocor, Optoma, Planar | Mixed |
| Commodity panels fronted by an external player | (any brand, via RS-232/CEC) | Downstream |

### Large-format LED and video processing

| Equipment | Example members | Tier |
|---|---|---|
| Direct-view / fine-pitch LED video walls | Planar (Leyard), Sony (Crystal LED), Barco, Optoma | Mixed |
| LED video processors / controllers | NovaStar, Megapixel, Planar | Mixed |
| Image / videowall processors | Barco | Mixed |

### Projection

| Equipment | Example members | Tier |
|---|---|---|
| Laser / lamp projectors (install and large-venue) | Panasonic, Sony, Barco, Optoma | Mixed |
| Projection screens (some motorized via relay/serial) | Legrand AV (Da-Lite) | Downstream |

### Cameras

| Equipment | Example members | Tier |
|---|---|---|
| AI / conferencing cameras | Huddly, Logitech, ClearOne | Networked |
| PTZ cameras | Panasonic, Sony, Legrand AV (Vaddio) | Mixed |

### Audio capture

| Equipment | Example members | Tier |
|---|---|---|
| Networked ceiling / array microphones | Shure, ClearOne, Yamaha | Networked |
| Wireless microphone systems / receivers | Shure, Sony | Mixed |
| Gooseneck / boundary / table mics (analog or Dante into a DSP) | (various) | Downstream |

### Audio processing, distribution, and amplification

| Equipment | Example members | Tier |
|---|---|---|
| DSP / audio processors / mixers | Shure, Bose Professional, ClearOne, Yamaha, Ecler, AtlasIED | Networked |
| Networked audio (Dante / AES67) endpoints | Shure, Yamaha, L-Acoustics, AtlasIED, Bose | Mixed |
| Power amplifiers | L-Acoustics, Bose Professional, Yamaha, AtlasIED, Ecler | Mixed |
| Loudspeakers (passive, driven by an amplifier) | L-Acoustics, Bose, Yamaha, AtlasIED, Ecler | Downstream |

### Conferencing and collaboration

| Equipment | Example members | Tier |
|---|---|---|
| All-in-one video bars / room kits | Logitech, Bose, Huddly | Networked |
| Room scheduling / touch controllers | Logitech | Networked |
| Wireless presentation / BYOM | Barco (ClickShare) | Networked |

### Signal transport and switching

| Equipment | Example members | Tier |
|---|---|---|
| AV-over-IP encoders / decoders | Wyrestorm, ClearOne | Networked |
| Matrix / presentation switchers | Wyrestorm | Mixed |
| HDMI extenders / splitters / distribution amps | Wyrestorm, Legrand AV (C2G) | Downstream |

### Infrastructure

| Equipment | Example members | Tier |
|---|---|---|
| Managed AV network switches / APs / routers | Netgear, Legrand AV (Luxul) | Networked |
| Power distribution / conditioning (PDUs) | Legrand AV (WattBox) | Mixed |
| Racks, mounts, structural, cabling | Legrand AV (Chief, Middle Atlantic, SANUS, C2G) | Downstream |

### Mass notification and commercial/background audio

| Equipment | Example members | Tier |
|---|---|---|
| IP audio endpoints, paging, zone/BGM controllers | AtlasIED, Bose, Ecler | Networked |

### What the population implies for the spec

Three observations follow from this catalog:

1. **The Mixed tier is large and unavoidable.** Displays, projectors, PTZ cameras, amplifiers, and matrix switchers -- a substantial fraction of the membership's output -- ship in both networked and serial-only variants of the *same model line*. The spec cannot infer addressability from device type; it must carry it as explicit, per-instance data (Section 10.2).
2. **The Downstream tier is not an edge case.** Loudspeakers, passive panels, extenders, screens, and structural products are core catalog items for several members. Any model that requires every device to be individually addressable forces these into false or manual compliance -- reported capabilities that cannot actually be fulfilled, or hand-entered data that drifts.
3. **The Cloud tier is the actual federation surface.** The cloud-to-cloud API connects software and device-cloud platforms to one another -- not the endpoints directly. The association, identity, and reachability data these clouds must exchange about the Networked, Mixed, and Downstream devices below them is precisely what the spec currently leaves undefined.

## Appendix B: Worked Cross-Vendor Scenarios

These three scenarios make the abstract problems concrete. In each, **Company A** is the calling cloud that wants to read status and change something, and **Company B** is the owning cloud whose devices A operates through the OpenAV API. The scenarios are deliberately drawn from different AV applications, and each lands on a different unspecified part of the contract -- including, in every case, the absence of location and association data established in Section 2.0.

### B.1 Signage -- a content platform readies displays before a campaign launch

**Company A:** a content / signage CMS cloud. **Company B:** a media-player vendor cloud. **Target:** a commercial display driven over HDMI-CEC by Company B's player.

1. Company A is about to push a timed campaign to the lobby displays across a customer's buildings. It calls `GET /v1/devices` on Company B's cloud and receives a flat, unordered list of player `deviceId`s -- **with no `site`, `building`, or `room` field, and no indication which player drives which display, or even which entries are "lobby" displays.** A can only target the right devices because the customer supplied that mapping out of band; the API did not provide it (Section 2.0).
2. For each intended device, A calls `GET /v1/devices/{deviceId}/capabilities`, sees `display-power`, `input-select`, and `device-status`, and reads status. Several report power = on but active input = `HDMI-2` (a laptop was left connected) rather than the `HDMI-1` the player feeds.
3. A issues an `input-select` change to `HDMI-1` and re-reads to confirm.

**What bites:** The thing A wants is the *display*, but the only routable `deviceId` is the *player*; A relies entirely on Company B privately resolving "player → CEC → this panel, this dialect" (Section 3). And because no field distinguishes an integrated smart display from a player fronting a dumb panel, A cannot tell whether `display-power` even acts on the same device as `device-status` (Section 2). The location gap means A never learns from the API which building any of these displays is in.

### B.2 Conferencing -- a room-booking system prepares a meeting room across two vendors

**Company A:** a room-booking / workplace platform. **Company B:** an audio-system cloud managing a DSP and its ceiling microphone array. **Target:** the room's microphone bus and output level.

1. A meeting begins. Company A calls `GET /v1/devices` on Company B's cloud to find the audio devices for the booked room -- but the response is a flat list with **no `room` field and no `parentDeviceId` linking the four ceiling mics to their DSP.** A cannot determine from the API that these five records belong to one room, let alone *which* room; it must already hold that association externally (Section 2.0).
2. A reads `device-status` per channel and finds the DSP online but one mic channel `reachable = false` -- a Dante subscription dropped. A flags that channel and proceeds with the other three.
3. A sets `audio-mute` → false on the mic bus and raises `audio-level` to the room's calibrated default for the booked headcount.

**What bites:** "Status" is a property of the *path*, not the device -- the DSP is healthy while a mic below it is unreachable (Section 6). `audio-level` must be translated from a generic scale into Company B's native control range, which the spec never defines (Sections 7, 11.4). And without association data, A cannot even assemble "the audio system for Room 214" from the flat device list.

### B.3 Large venue -- a show-control platform manages an LED wall it does not own

**Company A:** a venue / show-control platform. **Company B:** an LED-processor cloud driving a fine-pitch video wall. **Target:** the wall's brightness and active source.

1. Twenty minutes to doors. Company A calls `GET /v1/devices` on Company B's cloud and finds a single `deviceId` for the LED *processor* -- **the individual cabinets are not listed at all, and the processor record carries no `venue`, `zone`, or `children`,** so A cannot discover the wall's composition or where it physically is from the API (Section 2.0).
2. A calls `GET /v1/devices/{deviceId}/capabilities`, sees `brightness`, `input-select`, `device-status`, and `panel-health`, and reads them: the wall is up but at 35% brightness (a night setting) on a `test-pattern` input, with two cabinets in a fault state.
3. A sets `brightness` → 80% and `input-select` → the live program feed, re-reads to confirm, and raises a maintenance ticket for the two faulted cabinets -- which it can identify only because the processor happened to expose a per-panel health detail, not because the API models the cabinets as devices.

**What bites:** The cabinets are downstream of the processor, addressed by a selector the spec has no field for (Section 3). Two faulted cabinets are a per-hop health detail collapsed under one flat `status` unless the processor volunteers panel-level data (Section 6). And, again, the API never tells A which venue or zone the wall is in.
