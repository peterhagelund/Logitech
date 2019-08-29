// Copyright (c) 2019 Peter Hagelund
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import IOKit.hid

/// The protocol for a `RumblePad` delegate.
///
/// - Note: Classes that implement this delegate must strive to handle each
/// method invocation as quickly as possible in order to not "hog" the run loop.
public protocol RumblePadDelegate: AnyObject {
    /// Invoked when a controller is connected.
    func connected()
    
    /// Invoked when a previously connected controller is disconnected.
    func disconnected()
    
    /// Invoked when the left joystick is manipulated.
    ///
    /// - Parameters:
    ///   - horizontal: The horizontal value (`-128` to `127`).
    ///   - vertical: The vertical value (`-128` to `127`).
    
    func leftJoystickDidChange(horizontal: Int, vertical: Int)
    
    /// Invoked when the right joystick is manipulated.
    ///
    /// - Parameters:
    ///   - horizontal: The horizontal value (`-128` to `127`).
    ///   - vertical: The vertical value (`-128` to `127`).
    func rightJoystickDidChange(horizontal: Int, vertical: Int)
    
    /// Invoked when button `1` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button1DidChange(pressed: Bool)
    
    /// Invoked when button `2` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button2DidChange(pressed: Bool)
    
    /// Invoked when button `3` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button3DidChange(pressed: Bool)
    
    /// Invoked when button `4` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button4DidChange(pressed: Bool)
    
    /// Invoked when button `5` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button5DidChange(pressed: Bool)
    
    /// Invoked when button `6` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button6DidChange(pressed: Bool)
    
    /// Invoked when button `7` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button7DidChange(pressed: Bool)
    
    /// Invoked when button `8` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button8DidChange(pressed: Bool)
    
    /// Invoked when button `9` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button9DidChange(pressed: Bool)
    
    /// Invoked when button `10` is pressed or released.
    ///
    /// - Parameter pressed: The pressed state (`true` when pressed; `false` when released).
    func button10DidChange(pressed: Bool)
    
    /// Invoked when the round pad is manipulated.
    ///
    /// - Note: Several pad states can be on simultaneously.
    ///
    /// - Parameters:
    ///   - up: The pressed state of the `up` direction (`true` when pressed; `false` when released).
    ///   - right: The pressed state of the `right` direction (`true` when pressed; `false` when released).
    ///   - down: The pressed state of the `down` direction (`true` when pressed; `false` when released).
    ///   - left: The pressed state of the `left` direction (`true` when pressed; `false` when released).
    func padDidChange(up: Bool, right: Bool, down: Bool, left: Bool)
    
    /// Invoked when the `rumble` mode is changed.
    ///
    /// - Parameter on: The state of the `rumble` mode (`true` when on; `false` when off).
    func rumbleDidChange(on: Bool)
    
    /// Invoked when the `mode` button is pressed or released.
    ///
    /// - Parameter on: The state of the `mode` button (`true` when on; `false` when off).
    func modeDidChange(on: Bool)
}

public extension RumblePadDelegate {
    func connected() {}
    func disconnected() {}
    func leftJoystickDidChange(horizontal: Int, vertical: Int) {}
    func rightJoystickDidChange(horizontal: Int, vertical: Int) {}
    func button1DidChange(pressed: Bool) {}
    func button2DidChange(pressed: Bool) {}
    func button3DidChange(pressed: Bool) {}
    func button4DidChange(pressed: Bool) {}
    func button5DidChange(pressed: Bool) {}
    func button6DidChange(pressed: Bool) {}
    func button7DidChange(pressed: Bool) {}
    func button8DidChange(pressed: Bool) {}
    func button9DidChange(pressed: Bool) {}
    func button10DidChange(pressed: Bool) {}
    func padDidChange(up: Bool, right: Bool, down: Bool, left: Bool) {}
    func rumbleDidChange(on: Bool) {}
    func modeDidChange(on: Bool) {}
}

/// A software representation of a Logitech RumblePad game controller.
public class RumblePad {
    /// The `RumblePad`'s optional delegate.
    public weak var delegate: RumblePadDelegate?
    
    /// The connected state (`true` when a RumblePad controller is connected; `false` otherwise`).
    public var connected: Bool {
        get {
            return device != nil
        }
    }
    
    /// The left joystick's horizontal position (`-128` to `127`).
    public private(set) var leftJoystickHorizontal: Int = 0
    
    /// The left joystick's vertical position (`-128` to `127`).
    public private(set) var leftJoystickVertical: Int = 0
    
    /// The right joystick's horizontal position (`-128` to `127`).
    public private(set) var rightJoystickHorizontal: Int = 0
    
    /// The right joystick's vertical position (`-128 to 127`).
    public private(set) var rightJoystickVertical: Int = 0
    
    /// Button `1`'s pressed state.
    public private(set) var button1: Bool = false
    
    /// Button `2`'s pressed state.
    public private(set) var button2: Bool = false
    
    /// Button `3`'s pressed state.
    public private(set) var button3: Bool = false
    
    /// Button `4`'s pressed state.
    public private(set) var button4: Bool = false
    
    /// Button `5`'s pressed state.
    public private(set) var button5: Bool = false
    
    /// Button `6`'s pressed state.
    public private(set) var button6: Bool = false
    
    /// Button `7`'s pressed state.
    public private(set) var button7: Bool = false
    
    /// Button `8`'s pressed state.
    public private(set) var button8: Bool = false
    
    /// Button `9`'s pressed state.
    public private(set) var button9: Bool = false
    
    /// Button `10`'s pressed state.
    public private(set) var button10: Bool = false
    
    /// The pad `up` pressed state.
    public private(set) var padUp: Bool = false
    
    /// The pad `right` pressed state.
    public private(set) var padRight: Bool = false
    
    /// The pad `down` pressed state.
    public private(set) var padDown: Bool = false
    
    /// The pad `left` pressed state.
    public private(set) var padLeft: Bool = false
    
    /// The `rumble` state.
    public private(set) var rumble: Bool = false
    
    /// The `mode` state.
    public private(set) var mode: Bool = false
    
    /// The I/O HID manager.
    var manager: IOHIDManager
    
    /// The device report (always 8 bytes from a RumblePad).
    var report = [UInt8](repeating: 0x00, count: 8)
    
    /// The current I/O HID device (`nil` when a RumblePad is not connected).
    var device: IOHIDDevice?
    
    /// Initializes a new `RumblePad` instance.
    public init() {
        let dictionary = [kIOHIDVendorIDKey: 0x046d, kIOHIDProductIDKey: 0xc218]
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        IOHIDManagerSetDeviceMatching(manager, dictionary as CFDictionary)
        let pad = Unmanaged.passUnretained(self).toOpaque()
        IOHIDManagerRegisterDeviceMatchingCallback(manager, deviceMatchingCallback, pad)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode!.rawValue)
    }
    
    deinit {
        if let device = self.device  {
            IOHIDDeviceUnscheduleFromRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode!.rawValue)
            IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone))
        }
        IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    }
    
    /// Invoked when a matching device is detected.
    ///
    /// Invoked by the `deviceMatchingCallback(...)` callback function below.
    ///
    /// - Parameters:
    ///   - result: The I/O result of the match.
    ///   - device: The matching device.
    func deviceMatched(result: IOReturn, device: IOHIDDevice) {
        let instance = Unmanaged.passUnretained(self).toOpaque()
        IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeSeizeDevice))
        IOHIDDeviceRegisterRemovalCallback(device, deviceRemovalCallback, instance)
        let report = UnsafeMutablePointer(mutating: self.report)
        IOHIDDeviceRegisterInputReportCallback(device, report, CFIndex(self.report.count), inputReportCallback, instance)
        IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        self.device = device
        if let delegate = self.delegate {
            delegate.connected()
        }
    }
    
    /// Invoked when a previously matched device is removed.
    ///
    /// Invoked by the `deviceRemovalCallback(...)` callback function below.
    ///
    /// - Parameter result: The I/O result of the removal.
    func deviceRemoved(result: IOReturn) {
        if let delegate = self.delegate {
            delegate.disconnected()
        }
        guard let device = self.device else { return }
        IOHIDDeviceUnscheduleFromRunLoop(device, CFRunLoopGetCurrent() , CFRunLoopMode.defaultMode!.rawValue)
        IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone))
    }
    
    /// Invoked when an input report is received.
    ///
    /// Invoked by the `inputReportCallback(...)` callback function below.
    ///
    /// An "input report" from a RumblePad comprises 8 bytes as follows:
    /// - `report[0]`: The horizontal position of the left joystick.
    /// - `report[1]`: The vertical position of the left joystick.
    /// - `report[2]`: The horizontal position of the right joystick.
    /// - `report[3]`: The vertical position of the right joystick.
    /// - `report[4]`: The bit flags for button 1 to 4 and the round pad.
    /// - `report[5]`: The bit flags for button 5 to 10.
    /// - `report[6]`: The bit flags for the "rumble" and mode buttons.
    /// - `report[7]`: Unused.
    ///
    /// - Parameters:
    ///   - result: The I/O result of the report.
    ///   - type: The report type.
    ///   - reportId: The report ID.
    func inputReport(result: IOReturn, type: IOHIDReportType, reportId: UInt32) {
        let leftJoystickHorizontal = Int(report[0]) - 128
        let leftJoystickVertical = (Int(report[1]) - 128) * -1
        if leftJoystickHorizontal != self.leftJoystickHorizontal || leftJoystickVertical != self.leftJoystickVertical {
            self.leftJoystickHorizontal = leftJoystickHorizontal
            self.leftJoystickVertical = leftJoystickVertical
            delegate?.leftJoystickDidChange(horizontal: leftJoystickHorizontal, vertical: leftJoystickVertical)
        }
        let rightJoystickHorizontal = Int(report[2]) - 128
        let rightJoystickVertical = (Int(report[3]) - 128) * -1
        if rightJoystickHorizontal != self.rightJoystickHorizontal || rightJoystickVertical != self.rightJoystickVertical {
            self.rightJoystickHorizontal = rightJoystickHorizontal
            self.rightJoystickVertical = rightJoystickVertical
            delegate?.rightJoystickDidChange(horizontal: rightJoystickHorizontal, vertical: rightJoystickVertical)
        }
        let button1 = ((report[4] & 0x10) != 0x00)
        if button1 != self.button1 {
            self.button1 = button1
            delegate?.button1DidChange(pressed: button1)
        }
        let button2 = ((report[4] & 0x20) != 0x00)
        if button2 != self.button2 {
            self.button2 = button2
            delegate?.button2DidChange(pressed: button2)
        }
        let button3 = ((report[4] & 0x40) != 0x00)
        if button3 != self.button3 {
            self.button3 = button3
            delegate?.button3DidChange(pressed: button3)
        }
        let button4 = ((report[4] & 0x80) != 0x00)
        if button4 != self.button4 {
            self.button4 = button4
            delegate?.button4DidChange(pressed: button4)
        }
        let button5 = ((report[5] & 0x01) != 0x00)
        if button5 != self.button5 {
            self.button5 = button5
            delegate?.button5DidChange(pressed: button5)
        }
        let button6 = ((report[5] & 0x02) != 0x00)
        if button6 != self.button6 {
            self.button6 = button6
            delegate?.button6DidChange(pressed: button6)
        }
        let button7 = ((report[5] & 0x04) != 0x00)
        if button7 != self.button7 {
            self.button7 = button7
            delegate?.button7DidChange(pressed: button7)
        }
        let button8 = ((report[5] & 0x08) != 0x00)
        if button8 != self.button8 {
            self.button8 = button8
            delegate?.button8DidChange(pressed: button8)
        }
        let button9 = ((report[5] & 0x10) != 0x00)
        if button9 != self.button9 {
            self.button9 = button9
            delegate?.button9DidChange(pressed: button8)
        }
        let button10 = ((report[5] & 0x20) != 0x00)
        if button10 != self.button10 {
            self.button10 = button10
            delegate?.button10DidChange(pressed: button8)
        }
        let pad = report[4] & 0x0f
        let padUp = ((pad == 0x07) || (pad == 0x00) || (pad == 0x01))
        let padRight = ((pad == 0x01) || (pad == 0x02) || (pad == 0x03))
        let padDown = ((pad == 0x03) || (pad == 0x04) || (pad == 0x05))
        let padLeft = ((pad == 0x05) || (pad == 0x06) || (pad == 0x07))
        if padUp != self.padUp || padRight != self.padRight || padLeft != self.padLeft || padDown != self.padDown {
            self.padUp = padUp
            self.padRight = padRight
            self.padDown = padDown
            self.padLeft = padLeft
            delegate?.padDidChange(up: padUp, right: padRight, down: padDown, left: padLeft)
        }
        let rumble = ((report[6] & 0x04) != 0x00)
        if rumble != self.rumble {
            self.rumble = rumble
            delegate?.rumbleDidChange(on: rumble)
        }
        let mode = ((report[6] & 0x08) != 0x00)
        if mode != self.mode {
            self.mode = mode
            delegate?.modeDidChange(on: mode)
        }
    }
}

/// Callback for a matching device.
///
/// This callback is invoked under two circumstances:
/// - When a `RumblePad` is initialized and a RumbledPad controller is already connected.
/// - When a RumblePad controller is connected and a `RumblePad` instance already exists.
///
/// The only role of this function is to invoke `RumblePad.deviceMatched(...)`.
///
/// - Parameters:
///   - context: The context of the callback. Always the `RumblePad`'s `self`.
///   - result: The I/O result of the match.
///   - sender: The sender.
///   - device: The matching device.
fileprivate func deviceMatchingCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, device: IOHIDDevice) {
    let instance: Unmanaged<RumblePad> = Unmanaged.fromOpaque(context!)
    instance.takeUnretainedValue().deviceMatched(result: result, device: device)
}

/// Callback for device removal.
///
/// This callback is invoked when a `RumblePad` is instantiated; has detected a matching device; and that device is removed.
///
/// The only role of this function is to invoke `RumblePad.deviceRemoved(...)`.
///
/// - Parameters:
///   - context: The context of the callback. Always the `RumblePad`'s `self`.
///   - result: The I/O result of the removal.
///   - sender: The sender.
fileprivate func deviceRemovalCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?) {
    let instance: Unmanaged<RumblePad> = Unmanaged.fromOpaque(context!)
    instance.takeUnretainedValue().deviceRemoved(result: result)
}

/// Callback for input report.
///
/// This callback is invoked when any of the joysticks, buttons, or the pad is manipulated on the connected RumblePad.
///
/// The only role of this function is to invoke `RumblePad.inputReport(...)`.
///
/// - Parameters:
///   - context: The context of the callback. Always the `RumblePad`'s `self`.
///   - result: The I/O result of the input report.
///   - sender: The sender.
///   - type: The report type.
///   - reportId: The report ID.
///   - report: The report.
///   - reportLength: The report length (always `8`).
fileprivate func inputReportCallback(context: UnsafeMutableRawPointer?, result: IOReturn, sender: UnsafeMutableRawPointer?, type: IOHIDReportType, reportId: UInt32, report: UnsafeMutablePointer<UInt8>, reportLength: CFIndex) {
    let instance: Unmanaged<RumblePad> = Unmanaged.fromOpaque(context!)
    instance.takeUnretainedValue().inputReport(result: result, type: type, reportId: reportId)
}
