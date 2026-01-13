Document Version: 0.2\
Prepared by: OpenAVCloud Technical Working Group\
Date: January 12, 2026

# Table of Contents

[Table of Contents 2](#table-of-contents)

[Document History and Change Log 6](#document-history-and-change-log)

[1. Purpose 7](#purpose)

[2. High-Level Device Categories 8](#high-level-device-categories)

[Below is a taxonomy of AV (Audio-Visual) devices organized into
categories based on their function, usage context, and technical
characteristics:
8](#below-is-a-taxonomy-of-av-audio-visual-devices-organized-into-categories-based-on-their-function-usage-context-and-technical-characteristics)

[2.1 Display Devices 8](#display-devices)

[Devices that present visual content to users.
8](#devices-that-present-visual-content-to-users.)

[2.1.1 Monitors & Screens 8](#monitors-screens)

[2.1.1.1 LCD/LED Monitors 8](#lcdled-monitors)

[2.1.1.2 OLED Displays 8](#oled-displays)

[**2.1.1.3 Touchscreens 8**](#touchscreens)

[**2.1.1.4 Passive Screens 8**](#passive-screens)

[2.1.2 Projectors 8](#projectors)

[2.1.2.1 DLP Projectors 8](#dlp-projectors)

[2.1.2.2 LCD Projectors 8](#lcd-projectors)

[2.1.2.3 Laser Projectors 8](#laser-projectors)

[2.1.3 Video Walls 8](#video-walls)

[2.1.3.1 LED Panels 8](#led-panels)

[2.1.3.3 LCD Video Walls 10](#lcd-video-walls)

[2.1.4 Interactive Whiteboards 10](#interactive-whiteboards)

[2.1.4.1 Smart Boards 10](#smart-boards)

[2.1.4.2 Digital Flipcharts 10](#digital-flipcharts)

[2.2 Audio Devices 10](#audio-devices)

[Devices that capture, process, or reproduce sound.
10](#devices-that-capture-process-or-reproduce-sound.)

[2.2.1 Microphones 10](#microphones)

[2.2.1.1 Dynamic Microphones 10](#dynamic-microphones)

[2.2.1.2 Condenser Microphones 10](#condenser-microphones)

[2.2.1.3 Lavalier Microphones 10](#lavalier-microphones)

[2.2.1.4 Boundary Microphones 10](#boundary-microphones)

[2.2.1.5 Beamforming Microphones 10](#beamforming-microphones)

[2.2.2 Speakers 10](#speakers)

[2.2.2.1 Passive Speakers 10](#passive-speakers)

[2.2.2.2 Active Speakers 10](#active-speakers)

[2.2.2.3 Ceiling Speakers 11](#ceiling-speakers)

[2.2.2.4 Soundbars 11](#soundbars)

[2.2.3 Amplifiers & Mixers 11](#amplifiers-mixers)

[2.2.3.1 Audio Mixers 11](#audio-mixers)

[2.2.3.2 Power Amplifiers 11](#power-amplifiers)

[2.2.3.3 Digital Signal Processors (DSPs)
11](#digital-signal-processors-dsps)

[2.3 Video Devices 11](#video-devices)

[Devices that capture or transmit video.
11](#devices-that-capture-or-transmit-video.)

[2.3.1 Cameras 11](#cameras)

[2.3.1.1 PTZ (Pan-Tilt-Zoom) Cameras 11](#ptz-pan-tilt-zoom-cameras)

[2.3.1.2 Fixed Cameras 11](#fixed-cameras)

[2.3.1.3 Document Cameras 11](#document-cameras)

[2.3.2 Video Capture & Streaming Devices
11](#video-capture-streaming-devices)

[2.3.2.1 Capture Cards 11](#capture-cards)

[2.3.2.2 Streaming Encoders 11](#streaming-encoders)

[2.4 Video Conferencing Systems 12](#video-conferencing-systems)

[2.4.1 Integrated Room Systems 12](#integrated-room-systems)

[2.4.2 USB Cameras 12](#usb-cameras)

[**2.4.3 Codec-based Systems 12**](#codec-based-systems)

[**2.5 Control Systems 12**](#control-systems)

[Devices and software used to manage AV systems.
12](#devices-and-software-used-to-manage-av-systems.)

[2.5.1 Control Panels 12](#control-panels)

[2.5.1.1 Touch Panels 12](#touch-panels)

[2.5.1.2 Button Panels 12](#button-panels)

[2.5.2 Remote Controls 12](#remote-controls)

[2.5.2.1 IR Remotes 12](#ir-remotes)

[2.5.2.2 RF Remotes 12](#rf-remotes)

[2.5.3 Automation Systems 12](#automation-systems)

[2.5.3.1 Room Scheduling Panels 12](#room-scheduling-panels)

[2.5.3.2 Environmental Controls (lighting, shades)
12](#environmental-controls-lighting-shades)

[2.5.4 AV Control Software 13](#av-control-software)

[2.5.4.1 On-Prem Control Systems 13](#on-prem-control-systems)

[2.5.4.2 Cloud-based AV Management Platforms
13](#cloud-based-av-management-platforms)

[2.6 Signal Management & Distribution
13](#signal-management-distribution)

[Devices that manage AV signal routing and processing.
13](#devices-that-manage-av-signal-routing-and-processing.)

[2.6.1 Switchers & Matrix Switches 13](#switchers-matrix-switches)

[2.6.1.1 HDMI/SDI/AV Switchers 13](#hdmisdiav-switchers)

[2.6.1.2 Video Matrix Routers 13](#video-matrix-routers)

[2.6.2 Extenders & Converters 13](#extenders-converters)

[**2.6.2.1 HDMI over IP 13**](#hdmi-over-ip)

[**2.6.2.2 HDBaseT 13**](#hdbaset)

[2.6.2.3 Fiber Optic Extenders 13](#fiber-optic-extenders)

[2.6.2.4 Format Converters (e.g., VGA to HDMI)
13](#format-converters-e.g.-vga-to-hdmi)

[**2.6.2.5 DisplayPort/USB-C DP Alt-mode devices
13**](#displayportusb-c-dp-alt-mode-devices)

[2.6.3 Splitters & Distribution Amplifiers
14](#splitters-distribution-amplifiers)

[2.6.3.1 Audio Splitters 14](#audio-splitters)

[2.6.3.2 Video Distribution Amplifiers
14](#video-distribution-amplifiers)

[2.7 Collaboration Tools 14](#collaboration-tools)

[Devices and platforms that facilitate interaction and teamwork.
14](#devices-and-platforms-that-facilitate-interaction-and-teamwork.)

[2.7.1 Interactive Displays 14](#interactive-displays)

[2.7.2 Wireless Presentation Systems 14](#wireless-presentation-systems)

[2.7.3 Unified Communications Platforms
14](#unified-communications-platforms)

[2.7.4 Digital Whiteboarding Tools 14](#digital-whiteboarding-tools)

[2.8 Recording & Playback Devices 14](#recording-playback-devices)

[Devices used for capturing and replaying AV content.
14](#devices-used-for-capturing-and-replaying-av-content.)

[2.8.1 Media Players 14](#media-players)

[2.8.1.1 Blu-ray/DVD Players 14](#blu-raydvd-players)

[2.8.1.2 Streaming Devices (Apple TV, Chromecast)
14](#streaming-devices-apple-tv-chromecast)

[2.8.2 Recorders 14](#recorders)

[2.8.2.1 Digital Video Recorders (DVRs)
15](#digital-video-recorders-dvrs)

[2.8.2.2 Network Video Recorders (NVRs)
15](#network-video-recorders-nvrs)

[2.8.3 Storage Solutions 15](#storage-solutions)

[2.8.3.1 NAS Devices 15](#nas-devices)

[2.8.3.2 Cloud Storage Platforms 15](#cloud-storage-platforms)

[2.9 Infrastructure & Accessories 15](#infrastructure-accessories)

[Supporting components for AV systems.
15](#supporting-components-for-av-systems.)

[2.9.1 Power Management 15](#power-management)

[2.9.1.1 UPS Systems 15](#ups-systems)

[**2.9.1.2 Power Conditioners 15**](#power-conditioners)

[**2.9.1.3 Power Distribution Units (PDU)
15**](#power-distribution-units-pdu)

[2.9.2 Networking Equipment 15](#networking-equipment)

[2.9.2.1 Switches 15](#switches)

[2.9.2.2 Routers 15](#routers)

[**2.9.2.3 Wireless Access Points 15**](#wireless-access-points)

[**2.9.2.4 Network Gateways 16**](#network-gateways)

[3. Additional Considerations 16](#additional-considerations)

[3.1 XXX 16](#xxx)

[3.2 XXX 16](#xxx-1)

[**3.3 16**](#_heading=)

[5. References 17](#references)

# Document History and Change Log

This section captures the history of changes made to this document.

  -----------------------------------------------------------------
  Version               Date                  Reason for Change
  --------------------- --------------------- ---------------------
  1.0                   2025-11-06            Initial release of AV
                                              Device Taxonomy
                                              Guidelines.

  -----------------------------------------------------------------

# Purpose

This document outlines the taxonomy guidelines for Audio/Video (AV)
devices developed, deployed, or integrated by members of the OpenAVCloud
initiative.

# High-Level Device Categories

# Below is a taxonomy of AV (Audio-Visual) devices organized into categories based on their function, usage context, and technical characteristics:

#  Display Devices

# Devices that present visual content to users.

# Monitors & Screens 

# LCD/LED Monitors

# OLED Displays

# Touchscreens

# Passive Screens

# Projectors 

# DLP Projectors

# LCD Projectors

# Laser Projectors

# Video Walls 

# LED Panels

2.  **AIO LED Walls**

# LCD Video Walls

# Interactive Whiteboards 

# Smart Boards

# Digital Flipcharts

#  Audio Devices

# Devices that capture, process, or reproduce sound.

# Microphones 

# Dynamic Microphones

# Condenser Microphones

# Lavalier Microphones

# Boundary Microphones

# Beamforming Microphones

# Speakers 

# Passive Speakers

# Active Speakers

# Ceiling Speakers

# Soundbars

# Amplifiers & Mixers 

# Audio Mixers

# Power Amplifiers

# Digital Signal Processors (DSPs)

#  Video Devices

# Devices that capture or transmit video.

# Cameras 

# PTZ (Pan-Tilt-Zoom) Cameras

# Fixed Cameras

# Document Cameras

# Video Capture & Streaming Devices 

# Capture Cards

# Streaming Encoders

#  Video Conferencing Systems 

# Integrated Room Systems

# USB Cameras

# Codec-based Systems

#  Control Systems

# Devices and software used to manage AV systems.

# Control Panels 

# Touch Panels

# Button Panels

# Remote Controls 

# IR Remotes

# RF Remotes

# Automation Systems 

# Room Scheduling Panels

# Environmental Controls (lighting, shades)

# AV Control Software 

# On-Prem Control Systems

# Cloud-based AV Management Platforms

#  Signal Management & Distribution

# Devices that manage AV signal routing and processing.

# Switchers & Matrix Switches 

# HDMI/SDI/AV Switchers

# Video Matrix Routers

# Extenders & Converters 

# HDMI over IP

# HDBaseT

# Fiber Optic Extenders

# Format Converters (e.g., VGA to HDMI)

# DisplayPort/USB-C DP Alt-mode devices

# Splitters & Distribution Amplifiers 

# Audio Splitters

# Video Distribution Amplifiers

#  Collaboration Tools

# Devices and platforms that facilitate interaction and teamwork.

# Interactive Displays

# Wireless Presentation Systems 

# Unified Communications Platforms 

# Digital Whiteboarding Tools

#  Recording & Playback Devices

# Devices used for capturing and replaying AV content.

# Media Players 

# Blu-ray/DVD Players

# Streaming Devices (Apple TV, Chromecast)

# Recorders 

# Digital Video Recorders (DVRs)

# Network Video Recorders (NVRs)

# Storage Solutions 

# NAS Devices

# Cloud Storage Platforms

#  Infrastructure & Accessories

# Supporting components for AV systems.

#  Power Management 

# UPS Systems

# Power Conditioners

# Power Distribution Units (PDU)

# Networking Equipment 

# Switches

# Routers

# Wireless Access Points

# Network Gateways

# Additional Considerations

#  XXX

1.  YYY.

#  XXX

1.  .

#  

# 5. References

1.  XXX

2.  XXX

3.  XXX
