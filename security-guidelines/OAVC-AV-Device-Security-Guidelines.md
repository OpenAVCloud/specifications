Document Version: 1.0\
Prepared by: OpenAVCloud Technical Working Group\
Date: October 2, 2025

# Table of Contents

[Table of Contents [2](#table-of-contents)](#table-of-contents)

[Document History and Change Log
[3](#document-history-and-change-log)](#document-history-and-change-log)

[1. Purpose [4](#purpose)](#purpose)

[2. Security Requirements
[5](#security-requirements)](#security-requirements)

[2.1 Firmware Integrity and Secure Boot
[5](#firmware-integrity-and-secure-boot)](#firmware-integrity-and-secure-boot)

[2.2 Secure Communications (Data in Transit)
[5](#secure-communications-data-in-transit)](#secure-communications-data-in-transit)

[2.3 Network Authentication and Access Control
[5](#network-authentication-and-access-control)](#network-authentication-and-access-control)

[2.4 Secure Storage (Data at Rest)
[5](#secure-storage-data-at-rest)](#secure-storage-data-at-rest)

[2.1 Device Provisioning and Identity
[6](#device-provisioning-and-identity)](#device-provisioning-and-identity)

[2.2 Lifecycle Security and Vulnerability Management
[6](#lifecycle-security-and-vulnerability-management)](#lifecycle-security-and-vulnerability-management)

[3. Additional Considerations
[7](#additional-considerations)](#additional-considerations)

[3.1 Password Management
[7](#password-management)](#password-management)

[3.2 Secure Development and Supply Chain Practices
[7](#secure-development-and-supply-chain-practices)](#secure-development-and-supply-chain-practices)

[3.3 Incident Response and Logging
[7](#incident-response-and-logging)](#incident-response-and-logging)

[3.4 Application Security
[7](#application-security)](#application-security)

[4. Compliance and Auditing
[7](#compliance-and-auditing)](#compliance-and-auditing)

[4.1 Security Audits [7](#security-audits)](#security-audits)

[5. References [8](#references)](#references)

# Document History and Change Log

This section captures the history of changes made to this document.

  -----------------------------------------------------------------------
  Version                 Date                    Reason for Change
  ----------------------- ----------------------- -----------------------
  1.0                     2025-10-02              Initial release of AV
                                                  Device Security
                                                  Guidelines.

  -----------------------------------------------------------------------

# Purpose

This document outlines the minimum security guidelines required for
Audio/Video (AV) devices developed, deployed, or integrated by members
of the OpenAVCloud initiative.

# Security Requirements

#  Firmware Integrity and Secure Boot

1.  Devices must implement an irrevocable hardware Secure Boot process.

2.  Secure Boot must be enabled by default.

3.  Devices must prevent unauthorized and unauthenticated software from
    being loaded. If permitted, it must run in a sandboxed or
    limited-permission environment.

4.  Remote software updates must be digitally signed by a trusted
    authority.

5.  Devices must verify the digital signature and certificate chain
    before updates.

#  Secure Communications (Data in Transit)

1.  Devices must use certificate pinning or equivalent for TCP/IP or
    UDP/IP communication.

2.  TCP protocols (e.g., MQTT) must be protected by TLS.

3.  UDP protocols (e.g., CoAP) must be protected by DTLS.

4.  Cryptographic suites must be validated against NIST 800-131A or
    OWASP. Unsecure suites must be removed.

#  Network Authentication and Access Control

1.  Devices must support a secure network authentication method such as
    802.1X.

2.  All unused ports must be closed by default.

3.  Treat auto-discovery conservatively by default and restrict its
    scope to intended domains and purposes

4.  Debug interfaces must be disabled or protected via a best practice
    authentication or access control mechanism.

5.  Debug interfaces that are physical ports should be physically
    protected by the device.

6.  Resilience should be built into the device, taking into account the
    possibility of outages of data networks and power.

#  Secure Storage (Data at Rest)

1.  Devices must not contain hardcoded credentials.

2.  Network communication keys must be stored securely.

3.  Passwords must be stored using industry-standard cryptographic
    algorithms.

4.  Users must be provided with functionality such that all their user
    data can be erased from the consumer IoT device in a simple manner
    (factory reset).

#  Device Provisioning and Identity

1.  Devices must have a unique and tamper-resistant identifier.

2.  Secure provisioning must include unique generation, distribution,
    update, revocation, and destruction of keys.

#  Lifecycle Security and Vulnerability Management

1.  Vulnerability assessments must be conducted before launch and
    periodically thereafter.

2.  The manufacturer must make a vulnerability disclosure policy
    publicly available. This policy must include, at a minimum:

    1.  contact information for the reporting of issues; and

    2.  timelines for initial acknowledgement of receipt of a
        vulnerability report; and

    3.  timelines for when the person who reported the issue will
        receive status updates until the resolution of the reported
        issues.

3.  The manufacturer must publish, in an accessible way that is clear
    and transparent to the user, the defined support period.

# Additional Considerations

#  Password Management

1.  Enforce strong password policies including complexity, rotation, and
    secure recovery.

2.  Avoid default passwords and ensure initial credentials are changed
    at first use

3.  Establish mutual trust for device-to-device and device-to-gateway
    communications, with credentials managed for expiration and
    revocation

#  Secure Development and Supply Chain Practices

1.  Follow secure coding practices, code signing, and vulnerability
    scanning.

2.  Ensure vendors comply with supply chain security standards including
    SBOM transparency.

#  Incident Response and Logging

1.  Support event logging for security actions.

2.  Maintain a documented incident response plan including detection,
    containment, and remediation.

#  Application Security

1.  All applications running on the device, including third-party apps,
    must follow secure development practices.

# Compliance and Auditing

#  Security Audits

5.  1.  All AV devices must undergo regular security audits and
        demonstrate compliance with this standard.

# 5. References

1.  NIST SP 800-131A

2.  OWASP IoT Top 10

3.  ISO/IEC 27001

4.  IEEE 802.1X
