//
//  ShareIosScreenCapture.swift
//  Test-Mac
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
}

protocol ShareIosScreenCaptureManagerProtocol: AnyObject {
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer { get }
    var delegate: ShareIosScreenCaptureManagerDelegate? { get set }
    var isIosDeviceAvailable: Bool  { get }
    var isRunning: Bool  { get }
    func start()
    func stop()
}

class ShareIosScreenCaptureManager: NSObject, ShareIosScreenCaptureManagerProtocol {
    weak var delegate: ShareIosScreenCaptureManagerDelegate?
    
    private let captureSession = AVCaptureSession()
    private let captureDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified)
    private var captureDeviceInput: AVCaptureDeviceInput?
    private var captureMovieFileOutput: AVCaptureMovieFileOutput?
    private(set) var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer
    
    private var currentCaptureDevice: AVCaptureDevice?
    private var iosDeviceList = [String: AVCaptureDevice]()
    var isIosDeviceAvailable: Bool { return iosDeviceList.isEmpty }
    
    var isRunning: Bool { captureSession.isRunning }
    var isStarted = false
    
    private var mobileDeviceBundle: CFBundle?
    private var mobileDeviceAdapter: MobileDeviceAdapter?
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
        selectDevice()
    }
    
    func stop() {
        SPARK_LOG_DEBUG(#function)
        isStarted = false
        stopCapture()
    }
    
    private func initialize() {
        setupCaptureVideoPreviewLayer()
        setupMobileDeviceAdapter()
        
        captureSession.sessionPreset = .medium
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceConnected(_:)), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceDisconnected(_:)), name: .AVCaptureDeviceWasDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStart(_:)), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStop(_:)), name: .AVCaptureSessionDidStopRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureInputPortFormatDescriptionDidChange(_:)), name: .AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        
        enableHalDevice(true)
        mobileDeviceAdapter?.deviceNotificationSubscribe()
    }
    
    private func clear() {
        NotificationCenter.default.removeObserver(self)
        mobileDeviceAdapter?.deviceNotificationUnSubscribe()
        enableHalDevice(false)
    }
    
    private func setupMobileDeviceAdapter() {
        mobileDeviceBundle = Bundle.loadPrivateFrameworkBundle(frameworkName: "MobileDevice.framework")
        if let mobileDeviceBundle = mobileDeviceBundle {
            mobileDeviceAdapter = MobileDeviceAdapter(mobileDeviceBundle: mobileDeviceBundle)
        }
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
        
        let deviceList = captureDeviceDiscoverySession.devices
        
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
        
        captureSession.addInput(captureDeviceInput)
        
        
//        let captureMovieFileOutput = AVCaptureMovieFileOutput()
//        self.captureMovieFileOutput = captureMovieFileOutput
//        captureMovieFileOutput.delegate = self
//        captureSession.addOutput(captureMovieFileOutput)

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
                if let captureDeviceInput = self.captureDeviceInput {
                    self.captureSession.removeInput(captureDeviceInput)
                    self.captureDeviceInput = nil
                }
                if let movieOutput = self.captureMovieFileOutput {
                    self.captureSession.removeOutput(movieOutput)
                    self.captureMovieFileOutput = nil
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
    }
    
    @objc func onCaptureSessionStop(_ notification: Notification) {
        SPARK_LOG_DEBUG(#function)
    }
    
    @objc func onCaptureInputPortFormatDescriptionDidChange(_ notification: Notification) {
        if let port = notification.object as? AVCaptureInput.Port, port.mediaType == .video {
            if let dimensions = port.formatDescription?.dimensions {
                changePreviewSize(size: NSMakeSize(CGFloat(dimensions.width), CGFloat(dimensions.height)))
            }
        }
    }
    
    private func enableHalDevice(_ bEnable: Bool) {
        SPARK_LOG_DEBUG("\(bEnable)")
        mobileDeviceAdapter?.enableHalDevice(bEnable)
    }
}

extension ShareIosScreenCaptureManager: AVCaptureFileOutputDelegate {
    func fileOutputShouldProvideSampleAccurateRecordingStart(_ output: AVCaptureFileOutput) -> Bool {
        SPARK_LOG_DEBUG(#function)
        return true
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        SPARK_LOG_DEBUG(#function)
    }
}
