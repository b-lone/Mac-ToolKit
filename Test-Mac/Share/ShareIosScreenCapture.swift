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

enum CaptureState
{
    case none
    case connecting
    case connected
};

class ShareIosScreenCapture: NSObject {
    let captureSession = AVCaptureSession()
    var currentDevice: AVCaptureDevice?
    var captureDeviceInput: AVCaptureDeviceInput?
    var movieOutput: AVCaptureMovieFileOutput?
    var iOSDeviceList = [String: AVCaptureDevice]()
    var captureState = CaptureState.none
    var captureDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified)
    var mobileDeviceBundle: CFBundle?
    var mobileDeviceAdapter: MobileDeviceAdapter?
    var previewLayer: AVCaptureVideoPreviewLayer
    var captureAudioPreviewOutput: AVCaptureAudioPreviewOutput
    let previewWindow = PreviewWindow()
    var captureTimer: Timer?
    var plugAnimationTimer: Timer?
    var reEnablHalTimer: Timer?
    var gbHalDeviceEnabled: Int = 0
    var reselectTimer: Timer?
    var abnormalDisconnectTimer: Timer?
    var isRunning = false
    var isRealRunning = false
    var mbGotFormatChange = false
    var lock = NSLock()
    var buffer: CMSampleBuffer?
    var image: CGImage?
    
    override init() {
        captureSession.sessionPreset = .medium
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureAudioPreviewOutput = AVCaptureAudioPreviewOutput()
        
        super.init()
        
        previewLayer.autoresizingMask =  CAAutoresizingMask(rawValue: CAAutoresizingMask.layerWidthSizable.rawValue | CAAutoresizingMask.layerHeightSizable.rawValue )
        let color = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        previewLayer.backgroundColor = color
        previewLayer.frame = NSMakeRect(0, 0, 640, 480)
        
        previewWindow.contentView?.wantsLayer = true
        previewWindow.contentView?.layer?.addSublayer(previewLayer)
        previewWindow.setContentSize(NSMakeSize(640, 480))
//        previewWindow.center()
        previewWindow.orderFront(nil)
    }
    
    deinit {
        captureTimer?.invalidate()
        plugAnimationTimer?.invalidate()
        reEnablHalTimer?.invalidate()
        reselectTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceConnected(_:)), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceDisconnected(_:)), name: .AVCaptureDeviceWasDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStart(_:)), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureSessionStop(_:)), name: .AVCaptureSessionDidStopRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCaptureInputPortFormatDescriptionDidChange(_:)), name: .AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        
        if CFBundle.loadPrivateFrameworkBundle(frameworkName: "MobileDevice.framework", bundle: &mobileDeviceBundle), let bundle = mobileDeviceBundle {
            mobileDeviceAdapter = MobileDeviceAdapter(mobileDeviceBundle: bundle)
            mobileDeviceAdapter?.delegate = self
            mobileDeviceAdapter?.deviceNotificationSubscribe()
        }
        
        captureTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(onCaptureTimer(_:)), userInfo: nil, repeats: true)
        plugAnimationTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(onPlugAnimationTimer(_:)), userInfo: nil, repeats: true)
        
        selectDevice()
    }
    
    private func selectDevice() {
        SPARK_LOG_DEBUG(#function)
        if let reselectTimer = reselectTimer {
            reselectTimer.invalidate()
            self.reselectTimer = nil
        }
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
        guard !isRunning, let currentDevice = currentDevice else { return }
        
        isRunning = true
        SPARK_LOG_DEBUG("[APPSHARE] startCapture")
        
        mbGotFormatChange = false
        
        captureSession.beginConfiguration()

        captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice)
        
        guard let captureDeviceInput = captureDeviceInput else {
            isRunning = false
            captureSession.commitConfiguration()
            return SPARK_LOG_DEBUG("[APPSHARE] deviceInputWithDevice error")
        }
        
        captureSession.addInput(captureDeviceInput)
        
        captureSession.addOutput(captureAudioPreviewOutput)
//
//        let output = AVCaptureAudioFileOutput()
//        output.delegate = self
//        captureSession.addOutput(output)
        
//        let movieOutput = AVCaptureMovieFileOutput()
//        self.movieOutput = movieOutput
//        movieOutput.delegate = self
//
//        captureSession.addOutput(movieOutput)
//        let connections = movieOutput.connections
//        if !connections.isEmpty {
//            let connection = connections[0]
//            movieOutput.setOutputSettings([:], for: connection)
//        }

        captureSession.commitConfiguration()
        //Thread
        captureSession.startRunning()
    }
    
    private func stopCapture() {
        if let abnormalDisconnectTimer = abnormalDisconnectTimer {
            abnormalDisconnectTimer.invalidate()
            self.abnormalDisconnectTimer = nil
        }
        
        currentDevice = nil
        mbGotFormatChange = false
        
        guard isRunning else { return }
        
        SPARK_LOG_DEBUG("[APPSHARE] stopCapture")
        
        isRunning = false
        isRealRunning = false
        
//        [self ShowInstructionView];
//        [mInstructionView setRunning:NO];
//        [self updateMaskWindow];
        
//        dispatch_sync(mVideoQueue, ^ {
        
        captureSession.stopRunning()
        
        if let captureDeviceInput = captureDeviceInput {
            captureSession.removeInput(captureDeviceInput)
            self.captureDeviceInput = nil
        }
        
//        if(mStillImageOutput)
//        {
//        [mCaptureSession removeOutput:mStillImageOutput];
//        mStillImageOutput = nil;
//        }
        
        if let movieOutput = movieOutput {
            captureSession.removeOutput(movieOutput)
            self.movieOutput = nil
        }
//        });
        

        lock.lock()
        buffer = nil
        image = nil
        lock.unlock()
    }
    
    private func changePreviewSize(size: NSSize) {
        previewWindow.setContentSize(size)
    }
    
    private func showInstructionView() {
        
    }
    
    @objc func onCaptureSessionStart(_ notification: Notification) {
    }
    
    @objc func onCaptureSessionStop(_ notification: Notification) {
    }
    
    @objc func onCaptureInputPortFormatDescriptionDidChange(_ notification: Notification) {
    }
    
    var myCount = 0
    @objc func onCaptureTimer(_ sender: Any?) {
//        guard isRunning else { return }
//        myCount += 1
//        if myCount % 30 == 1 {
//            SPARK_LOG_DEBUG(#function)
//        }
    }
    
    var myCount2 = 0
    @objc func onPlugAnimationTimer(_ sender: Any?) {
//        myCount2 += 1
//        if myCount2 % 30 == 1 {
//            SPARK_LOG_DEBUG(#function)
//        }
    }
    
    var myCount3 = 0
    @objc func onCaptureWindowTimer(_ sender: Any?) {
//        myCount3 += 1
//        if myCount3 % 30 == 1 {
//            SPARK_LOG_DEBUG(#function)
//        }
        
        guard isRealRunning else { return }

//        int winNum = [mPreviewWindow windowNumber];
//        void* winList = (void*)winNum;
//
//        CGWindowImageOption option = kCGWindowImageNominalResolution | kCGWindowImageBoundsIgnoreFraming | kCGWindowImageShouldBeOpaque;
//        if(mbEnableRetinaCapture)
//            option = kCGWindowImageBoundsIgnoreFraming | kCGWindowImageShouldBeOpaque;
//
//        CFArrayRef windowIDsArray = CFArrayCreate(kCFAllocatorDefault, (const void**)&winList, 1, NULL);
//        CGImageRef captureImageRef = CGWindowListCreateImageFromArray(CGRectNull,windowIDsArray,option);
//        CFRelease (windowIDsArray);
//
//        if(captureImageRef == nil)
//            return;
//
//        int width = CGImageGetWidth(captureImageRef);
//        int height = CGImageGetHeight(captureImageRef);
//
//        NSView* contentView = [mPreviewWindow contentView];
//        NSRect contentRect =  [contentView convertRect:[contentView bounds] toView:nil];
//        NSSize winSize = [mPreviewWindow frame].size;
//
//        float xScale = winSize.width/width;
//        float yScale = winSize.height/height;
//
//        CGRect srcRect = CGRectMake(contentRect.origin.x,winSize.height - contentRect.origin.y - contentRect.size.height,
//                                    contentRect.size.width,contentRect.size.height);
//
//        srcRect.origin.x /= xScale;
//        srcRect.origin.y /= yScale;
//        srcRect.size.width/= xScale;
//        srcRect.size.height /= yScale;
//
//        CGImageRef subImage = CGImageCreateWithImageInRect(captureImageRef,srcRect);
//        CGImageRelease(captureImageRef);
//
//        if(!subImage)
//            return;
//
//        if(CGImageGetWidth(subImage) <= 1 || CGImageGetHeight(subImage) <= 1)
//        {
//            CGImageRelease(subImage);
//            return;
//        }
//
//        [mLock lock];
//        if(m_cachedCGImage)
//        {
//            CGImageRelease(m_cachedCGImage);
//            m_cachedCGImage = nil;
//        }
//        m_cachedCGImage = subImage;
//        [mLock unlock];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self ProcessCachedCGImage];
//        });
    }
    
    
    
    @objc func onReEnableHalDeviceTimer(_ sender: Any?) {
        SPARK_LOG_DEBUG(#function)
        reEnablHalTimer = nil;
        enableHalDevice(bEnable: 1)
    }
    
    private func reEnableHalDevice() {
        guard currentDevice == nil else { return }
        
        SPARK_LOG_DEBUG("ReEnableHalDevice")
        self.enableHalDevice(bEnable: 0)
        
        if let reEnablHalTimer = reEnablHalTimer {
            reEnablHalTimer.invalidate()
        }
        
        reEnablHalTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(onReEnableHalDeviceTimer(_:)), userInfo: nil, repeats: false)
    }
    
    private func enableHalDevice(bEnable: Int) {
//        guard gbHalDeviceEnabled == bEnable else { return }
        
        SPARK_LOG_DEBUG("[APPSHARE] EnableHalDevice: \(bEnable)")
        
        gbHalDeviceEnabled = bEnable;
        
        mobileDeviceAdapter?.enableHalDevice(Int32(gbHalDeviceEnabled))
        selectDevice()
    }
    
    @objc func onReselectTimer(_ sender: Any?) {
        reselectTimer = nil
        if currentDevice == nil, gbHalDeviceEnabled != 0 {
            selectDevice()
        }
    }
}

extension ShareIosScreenCapture: MobileDeviceAdapterDelegate {
    func mobileDeviceAdapter(_ adapter: MobileDeviceAdapter, deviceCallback status: Int32) {
        if status == 1 {
            if let reselectTimer = reselectTimer {
                reselectTimer.invalidate()
                self.reselectTimer = nil
            }
            
            if gbHalDeviceEnabled != 0 {
                reselectTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(onReselectTimer(_:)), userInfo: nil, repeats: false)
                if reEnablHalTimer == nil {
                    enableHalDevice(bEnable: 1)
                }
            }
            enableHalDevice(bEnable: 1)
            selectDevice()
        } else if status == 2 {
            
        } else if status == 4 {
            reEnableHalDevice()
        }
    }
    
    func mobileDeviceAdapter(onCaptureWindowTimer adapter: MobileDeviceAdapter) {
        onCaptureWindowTimer(nil)
    }
}

extension ShareIosScreenCapture: AVCaptureFileOutputDelegate {
    func fileOutputShouldProvideSampleAccurateRecordingStart(_ output: AVCaptureFileOutput) -> Bool {
        SPARK_LOG_DEBUG(#function)
        return true
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        SPARK_LOG_DEBUG(#function)
    }
}
