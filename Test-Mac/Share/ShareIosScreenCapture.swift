//
//  ShareIosScreenCapture.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/17.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import AVFoundation

enum CaptureState
{
    case none
    case connecting
    case connected
};

class ShareIosScreenCapture: NSObject {
    let captureSession = AVCaptureSession()
    var currentDevice: AVCaptureDevice?
    var iOSDeviceList = [String: AVCaptureDevice]()
    var captureState = CaptureState.none
    var captureDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown, .builtInMicrophone, .builtInWideAngleCamera], mediaType: nil, position: .unspecified)
    var mobileDeviceBundle: CFBundle?
    var mobileDeviceAdapter: MobileDeviceAdapter?
    
    override init() {
        captureSession.sessionPreset = .medium
    }
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceConnected(_:)), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceDisconnected(_:)), name: .AVCaptureDeviceWasDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStart(_:)), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStop(_:)), name: .AVCaptureSessionDidStopRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureInputPortFormatDescriptionDidChange(_:)), name: .AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        
        if CFBundle.loadPrivateFrameworkBundle(frameworkName: "MobileDevice.framework", bundle: &mobileDeviceBundle), let bundle = mobileDeviceBundle {
            mobileDeviceAdapter = MobileDeviceAdapter(mobileDeviceBundle: bundle)
            mobileDeviceAdapter?.deviceNotificationSubscribe()
        }
        
        selectDevice()
    }
    
    private func selectDevice() {
        guard currentDevice == nil else { return SPARK_LOG_DEBUG("currentDevice isn't empty") }
        
        let deviceList = captureDeviceDiscoverySession.devices
        
        for device in deviceList {
            let uniqueID = device.uniqueID
            let modelID = device.modelID
            SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID:\(modelID)")
            if modelID == "iOS Device" {
                iOSDeviceList[uniqueID] = device
            }
        }
        
        if let device = iOSDeviceList.first?.value {
            connectDevice(device)
        } else {
            showInstructionView()
        }
    }
    
    private func connectDevice(_ device: AVCaptureDevice) {
        guard currentDevice == nil else { return SPARK_LOG_DEBUG("currentDevice isn't empty") }
        
        captureState = .connecting
        
        currentDevice = device
        startCapture()
    }
    
    @objc func onDeviceConnected(_ notification: Notification) {
        let device = notification.object as? AVCaptureDevice
        let uniqueID = device?.uniqueID ?? ""
        let modelID = device?.modelID ?? ""
        SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID:\(modelID)")
        guard let theDevice = device, modelID == "iOS Device" else { return }

        iOSDeviceList[uniqueID] = theDevice

        connectDevice(theDevice)
    }

    @objc func onDeviceDisconnected(_ notification: Notification) {
        let device = notification.object as? AVCaptureDevice
        let uniqueID = device?.uniqueID ?? ""
        let modelID = device?.modelID ?? ""
        SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID\(modelID)")
        guard let theDevice = device, modelID == "iOS Device" else { return }

        iOSDeviceList[uniqueID] = nil

        guard currentDevice?.uniqueID == theDevice.uniqueID else { return SPARK_LOG_DEBUG("currentDevice isn't equal") }

        stopCapture()
        currentDevice = nil

        captureState = .none

        selectDevice()
    }
    
    private func startCapture() {
        
    }
    
    private func stopCapture() {
    }
    
    private func showInstructionView() {
        
    }
    
    @objc func onCaptureSessionStart(_ notification: Notification) {
    }
    
    @objc func onCaptureSessionStop(_ notification: Notification) {
    }
    
    @objc func onCaptureInputPortFormatDescriptionDidChange(_ notification: Notification) {
    }
}
