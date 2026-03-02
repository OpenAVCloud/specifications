# AV Device Minimum Functionality Guidelines

Document Version: 1.1

Prepared by: OpenAVCloud Technical Working Group

Date: January 15, 2026

Page: 1 **Version: 1.1**

# <span id="page-1-0"></span>**Table of Contents**

| Table of Contents                           | 2   |
|---------------------------------------------|-----|
| Document History and Change Log             | 3   |
| 1. Purpose                                  | 4   |
| 2. Minimum Functionality Requirements       | 5   |
| 2.1 Device Status                           | 5   |
| 2.2 Device Inventory                        | 5   |
| 2.3 Device Operations                       | 5   |
| 2.4 Device Networking Information           | 5   |
| 2.5 Video-Capable Device Specific Functions | 6   |
| 2.6 Audio-Capable Device Specific Functions | 6   |
| 2.7 Device Discovery                        | 6   |
| 3. Additional Considerations                | . 7 |
| 3.1 Device-Specific Functions               | 7   |
| 3.2 Device Maintenance                      |     |
| 3.3 Device Security                         | 7   |
| 3.4 Device Proxies/Aggregators              | 7   |
| 3.5 Device OpenAPI/Protocol                 | 7   |
| E Deferences                                | o   |

### <span id="page-2-0"></span>**Document History and Change Log**

This section captures the history of changes made to this document.

| Version | Date       | Reason<br>for<br>Change                                                             |
|---------|------------|-------------------------------------------------------------------------------------|
| 1.0     | 2025-11-06 | Initial<br>release<br>of<br>AV<br>Device<br>Minimum<br>Functionality<br>Guidelines. |
| 1.1     | 2026-01-15 | Initial<br>release<br>of<br>AV<br>Device<br>Minimum<br>Functionality<br>Guidelines. |

Page: 3 **Version: 1.1**

## <span id="page-3-0"></span>**1. Purpose**

This document outlines the minimum functionality guidelines required for Audio/Video (AV) devices developed, deployed, or integrated by members of the OpenAVCloud initiative.

The intent of this document is not to replace any global regulation or required standard for manufacturers to offer products for sale in geographical regions. It is also not intended to be overly prescriptive on what a manufacturer needs to implement. Its sole purpose is to define the minimum set of data/features required to support OAVC. Members' common customers. It is expected that as these guidelines gain adoption and gain more maturity, these documents will be revisited and defined in further detail. It is also currently left up to individual manufacturers on how to present the data/features based on their implementation (e.g. API, WebUI, Cloud, Screen, CommandLine etc.).

Finally, this document is solely intended to discuss data and management features and not the performance of the core functionality of the devices (e.g. no latency, performance of audio or video etc). That is unique to each manufacturer and should remain as such.

Page: 4 **Version: 1.1**

### <span id="page-4-1"></span><span id="page-4-0"></span>**2. Minimum Functionality Requirements**

## **2.1 Device Status**

- 2.1.1 Devices must implement the ability to report current operational status (e.g. Power State On/Off/Standby).
- 2.1.2 Devices must report an Uptime value (time in seconds or other measurement) since last reboot.
- 2.1.3 The manufacturer may expose any other pertinent status for the specific device (.e.g power status, standby etc).

## <span id="page-4-2"></span>**2.2 Device Inventory**

- 2.2.1 Devices must report a manufacturer identifier.
- 2.2.2 Devices must report a model number. If a device has a single model a product name be an acceptable substitute.
- 2.2.3 Devices must report a globally unique serial number. If a manufacturer uses MAC address as the unique identifier, then the device may report that as a substitute.
- 2.2.4 Devices must report version number of running firmware components that are field upgradeable.
- 2.2.5 If available, devices must report a hardware version.
- 2.2.6 If the device supports separate applications resident on the device, devices must report an application version.
- 2.2.7 Devices mayreport and allow setting of a user-friendly device name.

## <span id="page-4-3"></span>**2.3 Device Operations**

- 2.3.1 Devices must support a remote (via API) reboot operation.
- 2.3.2 Devices must support remote firmware updates for all field upgradeable components (this must include applications as well as the device OS).
- 2.3.3 If the device has the ability/use case to present a visible indicator to the user, devices must support an identify function that allows users to locate the device (e.g. flash LEDs, present message on the display etc). This is useful when administering the device remotely and needing to physically locate it in a facility.

# <span id="page-4-4"></span>**2.4 Device Networking Information**

2.4.1 Devices must support reporting network status, including IP Address, MAC Address, Subnet Mask, Default Gateway, DNS Server and Connection Type.

Page: 5 **Version: 1.1**

- 2.4.2 Devices may also allow setting of the above network values.
- 2.4.3 For WiFi capable devices, devices must support reporting SSID, signal strength as well.

## <span id="page-5-0"></span>**2.5 Video-Capable Device Specific Functions**

- 2.5.1 Device must introduce a relevant profile that will include operational information as below.
  - 2.5.1.1 Devices must support reporting video resolutions received.
  - 2.5.1.2 Devices must support reporting current video status (e.g. displaying, playback state etc).
  - 2.5.1.3 Devices that offer multiple inputs must support reporting current video input active.

## <span id="page-5-1"></span>**2.6 Audio-Capable Device Specific Functions**

- 2.6.1 Device must introduce a relevant profile that will include operational information as below.
  - 2.6.1.1 Devices must support reporting audio volume settings.
  - 2.6.1.2 Devices must support reporting mute status.

## <span id="page-5-2"></span>**2.7 Device Discovery**

2.7.1 Device must support a means to auto-discover units present on the network using a standard protocol (e.g. mDNS, LLDP etc).

Page: 6 **Version: 1.1**

## <span id="page-6-1"></span><span id="page-6-0"></span>**3. Additional Considerations**

## **3.1 Device-Specific Functions**

3.1.1 Depending on the type of device (e.g. codec, display, audio device etc), the device may expose other functions now outlined in this document. A clear API interface must be published for those.

### <span id="page-6-2"></span>**3.2 Device Maintenance**

- 3.2.1 Device must support a means to remotely retrieve logs.
- 3.2.2 Device may support a means to remotely retrieve operational data for remote monitoring (e.g. CPU usage, available local storage, etc).
- 3.2.3 Device may also expose other system diagnostic data for debug purposes as per the manufacturer's needs.

### <span id="page-6-3"></span>**3.3 Device Security**

3.3.1 Device must support the security guidelines defined in the Open AV Cloud "AV Device Security Guidelines".

## <span id="page-6-4"></span>**3.4 Device Proxies/Aggregators**

3.4.1 For devices that utilize an aggregator or proxy on the network, all the guidelines defined in this document will apply to the aggregator. The aggregator is expected to structure its child devices into a logical model that allows these guidelines to also apply to the children (i.e. child devices must have individual status, and functions such as firmware updates etc.).

# <span id="page-6-5"></span>**3.5 Device OpenAPI/Protocol**

3.5.1 Device must support a standard API for exercising the functionality documented in this document and exposed via a standard interface e.g. JSON, REST.

Page: 7 **Version: 1.1**

## <span id="page-7-0"></span>**5. References**

- ONVIF Core Specification.
- PJLink Specifications.
- European Commission "Radio Equipment Directive (RED)".
- OAVC "AV Device Security Guidelines".
- The European Cyber Resilience Act (CRA).

Page: 8 **Version: 1.1**