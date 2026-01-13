Document Version: 1.0\
Prepared by: OpenAVCloud Technical Working Group\
Date: November 06, 2025

# Table of Contents

[Table of Contents 2](#table-of-contents)

[Document History and Change Log 3](#document-history-and-change-log)

[1.](#purpose) Purpose 4

[2.](#minimum-functionality-requirements) Minimum Functionality
Requirements 5

[2.1](#device-status) Device Status 5

[2.2](#device-inventory) Device Inventory 5

[2.3](#device-operations) Device Operations 5

[2.4](#device-networking-information) Device Networking Information 5

[2.5](#video-capable-device-specific-functions) Video-Capable Device
Specific Functions 6

[2.6](#audio-capable-device-specific-functions) Audio-Capable Device
Specific Functions 6

[2.7](#device-discovery) Device Discovery 6

[3.](#additional-considerations) Additional Considerations 7

[3.1](#device-specific-functions) Device-Specific Functions 7

[3.2](#device-maintenance) Device Maintenance 7

[3.3](#device-security) Device Security 7

[3.4](#device-proxiesaggregators) Device Proxies/Aggregators 7

[3.5](#device-openapiprotocol) Device OpenAPI/Protocol 7

[5. References 8](#references)

# Document History and Change Log

This section captures the history of changes made to this document.

  -----------------------------------------------------------------
  Version               Date                  Reason for Change
  --------------------- --------------------- ---------------------
  1.0                   2025-11-06            Initial release of AV
                                              Device Minimum
                                              Functionality
                                              Guidelines.

  -----------------------------------------------------------------

# Purpose

This document outlines the minimum functionality guidelines required for
Audio/Video (AV) devices developed, deployed, or integrated by members
of the OpenAVCloud initiative.

# Minimum Functionality Requirements

#  Device Status

1.  Devices must implement the ability to report current operational
    status (e.g. Power State On/Off/Standby).

2.  Devices must report an Uptime value (time in seconds or other
    measurement) since last reboot.

3.  The manufacturer may expose any other pertinent status for the
    specific device (.e.g power status, standby etc).

#  Device Inventory

1.  Devices must report a manufacturer identifier.

2.  Devices must report a model number. If a device has a single model a
    product name be an acceptable substitute.

3.  Devices must report a globally unique serial number. If a
    manufacturer uses MAC address as the unique identifier, then the
    device may report that as a substitute.

4.  Devices must report version number of running firmware components
    that are field upgradeable.

5.  If available, devices must report a hardware version.

6.  If the device supports a separate application resident on the
    device, devices must report an application version.

7.  Devices must report and allow setting of a user-friendly device
    name.

#  Device Operations

1.  Devices must support a remote (via API) reboot operation.

2.  Devices must support remote firmware updates for all field
    upgradeable components (this must include applications as well as
    the device OS).

3.  If the device has the ability/use case to present a visible
    indicator to the user devices must support an identify function that
    allows users to locate the device (e.g. flash LEDs, present message
    on the display etc).

#  Device Networking Information

1.  Devices must support reporting network status, including IP Address,
    MAC Address, Subnet Mask, Default Gateway, DNS Server and Connection
    Type.

2.  Devices may also allow setting of the above network values.

3.  For WiFi capable devices, devices must support reporting SSID,
    signal strength as well.

#  Video-Capable Device Specific Functions

1.  Device must introduce a relevant profile that will include
    operational information as below.

    1.  Devices must support reporting video resolutions received.

    2.  Devices must support reporting current video status (e.g.
        displaying, playback state etc).

    3.  Devices that offer multiple inputs must support reporting
        current video input active.

#  Audio-Capable Device Specific Functions

1.  Device must introduce a relevant profile that will include
    operational information as below.

    1.  Devices must support reporting audio volume settings.

    2.  Devices must support reporting mute status.

#  Device Discovery

1.  Device must support a means to auto-discover units present on the
    network using a standard protocol (e.g. mDNS, LLDP etc).

# Additional Considerations

#  Device-Specific Functions

1.  Depending on the type of device (e.g. codec, display, audio device
    etc), the device may expose other functions now outlined in this
    document. A clear API interface must be published for those.

#  Device Maintenance

1.  Device must support a means to remotely retrieve logs.

2.  Device may also expose other system diagnostic data for debug
    purposes as per the manufacturer\'s needs.

3.  Device may also report amount of available local storage.

#  Device Security

1.  Device must support the security guidelines defined in the Open AV
    Cloud "AV Device Security Guidelines".

#  Device Proxies/Aggregators

1.  For devices that utilize an aggregator or proxy on the network, all
    the guidelines defined in this document will apply to the
    aggregator. The aggregator is expected to structure its child
    devices into a logical model that allows these guidelines to also
    apply to the children (i.e. child devices must have individual
    status, and functions such as firmware updates etc.).

#  Device OpenAPI/Protocol

1.  Device must support a standard API for exercising the functionality
    documented in this document and exposed via a standard interface
    e.g. JSON, XML, REST.

#  

# 5. References

1.  ONVIF Core Specification

2.  PJLink Specifications

3.  European Commission "Radio Equipment Directive (RED)"

4.  OAVC "AV Device Security Guidelines".
