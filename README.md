# Logitech

The `Logitech` module is a Swift package for using a Logitech RumblePad game controller within a macOS application.

## Copyright and License

Copyright (c) 2019 Peter Hagelund

This software is licensed under the [MIT License](https://en.wikipedia.org/wiki/MIT_License)

See `LICENSE.txt`

_Please note:_ I am in no way affiliated with Logitech or any of its subsidiaries or suppliers. I have had a Rumbled for years and been unable
to get it recognized as a `GCController` by the standard `GameController` Framework on macOS. So I created this - if there's a better way,
please let me know!

## From macOS System Report

Logitech RumblePad 2 USB:

- Product ID: 0xc218
- Vendor ID: 0x046d  (Logitech Inc.)
- Version:	 1.00
- Speed: Up to 1.5 Mb/sec
- Manufacturer: Logitech
- Location ID: 0x14400000 / 46
- Current Available (mA): 500
- Current Required (mA): 500
- Extra Operating Current (mA): 0

The `RumblePad` class is hardcoded to match devices with product ID `0xc218` and vendor ID `0x046d`.

## Installation and Setup

* Clone the repository (`git clone https://github.com/peterhagelund/Logitech.git`)
* `cd Logitech/`
* `swift build`
* `swift package generate-xcodeproj`
* `open Logitech.xcodeproj/`

### Documentation

The source contains documentation comments suitable for [jazzy](https://github.com/realm/jazzy)

TL;DR:
* `[sudo] gem install jazzy`
* `jazzy --clean --author "Peter Hagelund" --module Logitech --min-acl private`
* `open docs/index.html`

## Using

For projects that depend upon `iRobot`, make sure `Package.swift` contains the correct dependency:

    // swift-tools-version:5.0
    // The swift-tools-version declares the minimum version of Swift required to build this package.

    import PackageDescription

    let package = Package(
        name: "<package name>",
        products: [
            .library(
                name: "<package name>",
                targets: ["<your target>"]),
        ],
        dependencies: [
            .package(url: "https://github.com/peterhagelund/Logitech.git", from: "1.0.2")
            .package(url: "https://github.com/...", from: "...")
            .package(url: "https://github.com/...", from: "...")
        ],
        targets: [
            .target(
                name: "<your target>",
                dependencies: ["Logitech", "...", "..."]),
            .testTarget(
                name: "<your test target>",
                dependencies: ["<your target>"]),
        ]
    )

The `RumblePad` class can be used in two ways:

- Polling.
- Through a `RumblePadDelegate`.

Once a `RumblePad` instance has been initialized, it schedules all the HID functionality on the current runloop and will automatically receive - and handle - device matching, device removal, and input reports.
The `RumblePad.connected` property can be used to determine whether a RumblePad is currently connected or not.

### Example:


    class AppDelegate: NSObject, NSApplicationDelegate, RumblePadDelegate {
        ...
        var rumblePad: RumblePad
        ...
        
        override init() {
            ...
            rumblePad = RumblePad()
            super.init()
            rumblePad.delegate = self
        }
        
        func leftJoystickDidChange(horizontal: Int, vertical: Int) {
            // Handle left joystick
        }
        
        func rightJoystickDidChange(horizontal: Int, vertical: Int) {
            // Handle right joystick
        }
        
        ...
    }
