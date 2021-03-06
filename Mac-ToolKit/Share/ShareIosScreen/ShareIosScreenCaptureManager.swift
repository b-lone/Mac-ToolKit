//
//  ShareIosScreenCapture.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/8/17.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import AVFoundation
import CoreMediaIO

protocol ShareIosScreenCaptureManagerDelegate: AnyObject {
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onIosDeviceAvailableChanged isAvailable: Bool)
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onPreviewSizeChanged size: NSSize)
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onCaptureSessionStateChanged isRunning: Bool)
}

protocol ShareIosScreenCaptureManagerProtocol: AnyObject {
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer { get }
    var delegate: ShareIosScreenCaptureManagerDelegate? { get set }
    var isIosDeviceAvailable: Bool  { get }
    var isRunning: Bool  { get }
    var deviceName: String? { get }
    func start()
    func stop()
}

class ShareIosScreenCaptureManager: NSObject, ShareIosScreenCaptureManagerProtocol {
    weak var delegate: ShareIosScreenCaptureManagerDelegate?
    
    private let captureSession = AVCaptureSession()
    private var captureDeviceInput: AVCaptureDeviceInput?
    private(set) var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer
    private var captureAudioPreviewOutput = AVCaptureAudioPreviewOutput()
    
    private var currentCaptureDevice: AVCaptureDevice?
    private var iosDeviceList = [String: AVCaptureDevice]()
    var isIosDeviceAvailable: Bool { return !iosDeviceList.isEmpty }
    var deviceName: String? { currentCaptureDevice?.localizedName }
    
    var isRunning: Bool { captureSession.isRunning }
    private var isStarted = false
    
    private var videoQueue: DispatchQueue
    
    override init() {
        captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoQueue = DispatchQueue(label: "capture queue")

        super.init()
        
        initialize()
    }
    
    deinit {
        clear()
    }
    
    func start() {
        SPARK_LOG_DEBUG(#function)
        isStarted = true
        enableHalDevice(true)
        selectDevice()
    }
    
    func stop() {
        SPARK_LOG_DEBUG(#function)
        isStarted = false
        stopCapture()
    }
    
    private func initialize() {
        setupCaptureVideoPreviewLayer()
        
        captureSession.sessionPreset = .high
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceConnected(_:)), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceDisconnected(_:)), name: .AVCaptureDeviceWasDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStart(_:)), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStop(_:)), name: .AVCaptureSessionDidStopRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureInputPortFormatDescriptionDidChange(_:)), name: .AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        
        enableHalDevice(true)
        
        captureAudioPreviewOutput.volume = 1
    }
    
    private func clear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupCaptureVideoPreviewLayer() {
        captureVideoPreviewLayer.backgroundColor = .black
        captureVideoPreviewLayer.frame = NSMakeRect(0, 0, 640, 480)
    }
    
    private func addIosDevices(_ deviceList: [String: AVCaptureDevice]) {
        let isAvailable = isIosDeviceAvailable
        
        deviceList.forEach{ iosDeviceList[$0.key] = $0.value }
        
        if isAvailable != isIosDeviceAvailable {
            SPARK_LOG_DEBUG("onIosDeviceAvailableChanged:\(isIosDeviceAvailable)")
            delegate?.shareIosScreenCaptureManager(self, onIosDeviceAvailableChanged: isIosDeviceAvailable)
        }
        
        if let device = iosDeviceList.first?.value {
            connectDevice(device)
        }
    }
    
    private func removeIosDevice(_ device: AVCaptureDevice) {
        let isAvailable = isIosDeviceAvailable
        
        iosDeviceList[device.uniqueID] = nil
        
        if isAvailable != isIosDeviceAvailable {
            SPARK_LOG_DEBUG("onIosDeviceAvailableChanged:\(isIosDeviceAvailable)")
            delegate?.shareIosScreenCaptureManager(self, onIosDeviceAvailableChanged: isIosDeviceAvailable)
        }
        
        if currentCaptureDevice?.uniqueID == device.uniqueID {
            currentCaptureDevice = nil
            stopCapture()
        }
        
        if let device = iosDeviceList.first?.value {
            connectDevice(device)
        }
    }
    
    private func selectDevice() {
        SPARK_LOG_DEBUG(#function)
        guard currentCaptureDevice == nil else { return SPARK_LOG_DEBUG("currentDevice isn't empty") }
        
        var deviceList = [AVCaptureDevice]()
        if #available(macOS 10.15, *) {
            let captureDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified)
            deviceList = captureDeviceDiscoverySession.devices
        } else {
            deviceList = AVCaptureDevice.devices()
        }
        
        var iosDevices = [String: AVCaptureDevice]()
        for device in deviceList {
            let uniqueID = device.uniqueID
            let modelID = device.modelID
            SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID:\(modelID)")
            if modelID == "iOS Device" {
                iosDevices[uniqueID] = device
            }
        }
        
        addIosDevices(iosDevices)
    }
    
    private func connectDevice(_ device: AVCaptureDevice) {
        guard currentCaptureDevice == nil else { return SPARK_LOG_DEBUG("currentDevice isn't empty") }
        guard !isRunning, isStarted else { return SPARK_LOG_DEBUG("Not start.") }
        
        currentCaptureDevice = device
        startCapture()
    }
    
    @objc func onDeviceConnected(_ notification: Notification) {
        let device = notification.object as? AVCaptureDevice
        let uniqueID = device?.uniqueID ?? ""
        let modelID = device?.modelID ?? ""
        SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID:\(modelID)")
        guard let theDevice = device, modelID == "iOS Device" else { return }

        addIosDevices([uniqueID: theDevice])
    }

    @objc func onDeviceDisconnected(_ notification: Notification) {
        let device = notification.object as? AVCaptureDevice
        let uniqueID = device?.uniqueID ?? ""
        let modelID = device?.modelID ?? ""
        SPARK_LOG_DEBUG("uniqueID:\(uniqueID) modelID:\(modelID)")
        guard let theDevice = device, modelID == "iOS Device" else { return }

        removeIosDevice(theDevice)
    }
    
    private func startCapture() {
        guard let currentDevice = currentCaptureDevice else { return }
        guard !isRunning else { return }
 
        SPARK_LOG_DEBUG(#function)
        
        captureSession.beginConfiguration()

        captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice)
        
        guard let captureDeviceInput = captureDeviceInput else {
            captureSession.commitConfiguration()
            return SPARK_LOG_DEBUG("create AVCaptureDeviceInput error")
        }
        
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
            SPARK_LOG_DEBUG("[addInput] \(captureDeviceInput.description)")
        }
        
        if captureSession.canAddOutput(captureAudioPreviewOutput) {
            captureSession.addOutput(captureAudioPreviewOutput)
            SPARK_LOG_DEBUG("[addOutput] \(captureAudioPreviewOutput.description)")
        }

        captureSession.commitConfiguration()
        videoQueue.async { [weak self] in
            if let self = self {
                self.captureSession.startRunning()
                SPARK_LOG_DEBUG("startRunning finished!")
            }
        }
    }
    
    private func stopCapture() {
        SPARK_LOG_DEBUG(#function)
        
        videoQueue.async { [weak self] in
            if let self = self {
                guard self.isRunning else { return }
                self.captureSession.stopRunning()
                for input in self.captureSession.inputs {
                    self.captureSession.removeInput(input)
                    SPARK_LOG_DEBUG("[removeInput] \(input.description)")
                }
                for output in self.captureSession.outputs {
                    self.captureSession.removeOutput(output)
                    SPARK_LOG_DEBUG("[removeOutput] \(output.description)")
                }
                self.currentCaptureDevice = nil
                SPARK_LOG_DEBUG("stopRunning finished!")
            }
        }
    }
    
    private func changePreviewSize(size: NSSize) {
        SPARK_LOG_DEBUG("\(size)")
        
        delegate?.shareIosScreenCaptureManager(self, onPreviewSizeChanged: size)
    }
    
    @objc func onCaptureSessionStart(_ notification: Notification) {
        SPARK_LOG_DEBUG(#function)
        if notification.object as? AVCaptureSession === captureSession {
            delegate?.shareIosScreenCaptureManager(self, onCaptureSessionStateChanged: true)
        }
    }
    
    @objc func onCaptureSessionStop(_ notification: Notification) {
        SPARK_LOG_DEBUG(#function)
        if notification.object as? AVCaptureSession === captureSession {
            delegate?.shareIosScreenCaptureManager(self, onCaptureSessionStateChanged: false)
        }
    }
    
    @objc func onCaptureInputPortFormatDescriptionDidChange(_ notification: Notification) {
        guard let port = notification.object as? AVCaptureInput.Port, port.mediaType == .video, port.input == captureDeviceInput else { return }
        guard let formatDescription = port.formatDescription else { return }
        if #available(macOS 10.15, *) {
            let dimensions = formatDescription.dimensions
            changePreviewSize(size: NSMakeSize(CGFloat(dimensions.width), CGFloat(dimensions.height)))
        } else {
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            changePreviewSize(size: NSMakeSize(CGFloat(dimensions.width), CGFloat(dimensions.height)))
        }
    }
    
    private func enableHalDevice(_ bEnable: Bool) {
        SPARK_LOG_DEBUG("\(bEnable)")
        MobileDeviceAdapter.enableHalDevice(bEnable)
    }
}
