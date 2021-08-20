//
//  ShareManagerComponent.swift
//  WebexTeams
//
//  Created by Archie You on 2021/6/9.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

protocol ShareManagerComponentListener: AnyObject {
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareSourcesSelectionWindowInfoChanged info: CHShareSourcesSelectionWindowInfo)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onRemoteShareControlBarInfoChanged info: CHRemoteShareControlBarInfo)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onResumeShareControlBarInfoChanged info: CHResumeShareControlBarInfo)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareNotificationArrived notification: CHShareNotification)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent)
}

protocol ShareManagerComponentDelegate: AnyObject {
    func getExcludeWindowNumberList() -> [Int]
}

protocol ShareManagerComponentProtocol: AnyObject {
    func registerListener(_ listener: ShareManagerComponentListener & NSObject)
    func unregisterListener(_ listener: ShareManagerComponentListener & NSObject)
    var delegate: ShareManagerComponentDelegate? { get set }
    var callId: String { get }
    
    var shareParameters: ShareParameters? { get }
    
    func startShare(shareSourceList: [CHShareSource])
    func stopShare()
    func resumeShare()
    func pauseShare(doPause: Bool)
    func endShareOnlyCallIfNotStart()
    func excludeWindowFromShare()
    
    func getShareSourcesSelectionWindowInfo() -> CHShareSourcesSelectionWindowInfo?
    func setOptimizeForShare(type: CHShareOptimizeType)
    func setEnableShareAudio(isEnabled: Bool)
    func installAudioSharePlugin()
    func checkAudioSharePluginStatus()
    
    func getLocalShareControlBarInfo() -> CHLocalShareControlBarInfo?
    
    func getRemoteShareControlBarInfo() -> CHRemoteShareControlBarInfo?
}

class ShareManagerComponent: NSObject {
    private(set) var callId = ""
    weak var delegate: ShareManagerComponentDelegate?
    var shareParameters: ShareParameters? { makeShareParameters() }
    
    private var listenerList = [Weak<NSObject>]()
    private let appContext: AppContext
    private let drawingBoardManager: MagicDrawingBoardManagerProtocol
    private var drawingId: MagicDrawingId = MagicDrawing.inValidDrawingId
    private let shareViewModel: CHShareViewModelProtocol
    private lazy var sharePreparingWindowController: SharePreparingWindowControllerProtocol = SharePreparingWindowController()
    private lazy var shareResumeBar: ShareResumeWindowControllerProtocol = ShareResumeWindowController(appContext: appContext)
    
    private var isSharing = false {
        didSet {
            //when switch share, they won't tell "isSharing = false", then "isSharing = true". Instead, they only tell "isSharing = true". So we should clean the last remnant when receive "isSharing = true".
            onIsSharingChanged()
        }
    }
    private var isSharePaused = false {
        didSet {
            if isSharePaused != oldValue {
                updateShareBorder()
            }
        }
    }
     
    private var excludedWindowNumberList: [Int] { delegate?.getExcludeWindowNumberList() ?? [] }
    
    init(appContext: AppContext, callId: String) {
        self.appContext = appContext
        self.callId = callId
        
        shareViewModel = appContext.commonHeadFrameworkAdapter.makeShareViewModel()
        drawingBoardManager = appContext.drawingBoardManager
        
        super.init()

        shareViewModel.initialize(callId: callId)
        initialize()
    }
    
    init(appContext: AppContext, type: CHShareCallType, conversationId: String) {
        self.appContext = appContext

        shareViewModel = appContext.commonHeadFrameworkAdapter.makeShareViewModel()
        drawingBoardManager = appContext.drawingBoardManager
        
        super.init()
        
        shareViewModel.initialize(type: type, conversationId: conversationId)
        callId = shareViewModel.getCallId() ?? ""
        sparkAssert(!callId.isEmpty, "callId should not be empty")
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        removeShareBorder()
    }
    
    private func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(onScreenParametersChanged), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onApplicationDidTerminate), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onShareStateChanged), name: NSNotification.Name(rawValue: OnShareStateChanged), object: nil)
        //https://jira-eng-gpk2.cisco.com/jira/browse/SPARK-247802 This is temp fix, should be removed after telephony service fixed
        NotificationCenter.default.addObserver(self, selector: #selector(onCallDisconnected), name: NSNotification.Name(rawValue: OnCallDisconnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onMediaDisconnected), name: NSNotification.Name(rawValue: OnMediaDisconnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCallFailed), name: NSNotification.Name(rawValue: OnCallFailed), object: nil)
        
        shareViewModel.setIsUserAdmin(isUserAdmin: MacOSUtilsHelper.isUserAdmin())
        updateShareViewModelScreenList()
        shareViewModel.delegate = self
        
        if let info = shareViewModel.getLocalShareControlBarInfo() {
            isSharePaused = info.isSharePaused
        }
    }
    
    private func getScreenList() -> [String] {
        NSScreen.screens.compactMap{ $0.uuid() ?? nil }
    }
    
    private func updateShareViewModelScreenList() {
        shareViewModel.setScreenList(screenList: getScreenList())
    }
    
    private func getSharedScreen(rect: CHRect) -> NSScreen {
        if var sharedScreen = NSScreen.main {
            for screen in NSScreen.screens {
                let screenFrame = screen.getFlippedCoordinateFrame()
                if screenFrame.minX == CGFloat(rect.x.floatValue), screenFrame.minY == CGFloat(rect.y.floatValue), screenFrame.width == CGFloat(rect.width.floatValue), screenFrame.height == CGFloat(rect.height.floatValue) {
                    sharedScreen = screen
                    break
                }
            }
            return sharedScreen
        } else {
            fatalError()
        }
    }
    
    private func makeShareParameters() -> ShareParameters? {
        var result: ShareParameters?
        if let sharingContent = shareViewModel.getSharingContent() {
            let sharedScreen = getSharedScreen(rect: sharingContent.captureRect)
            switch sharingContent.sourceType {
            case .application:
                result = ShareParameters(callId: callId, shareSourceType: .application, applicationList: sharingContent.shareSourceList.map({ $0.sourceId }), screenToDraw: sharedScreen)
            case .window:
                result = ShareParameters(callId: callId, shareSourceType: .window, windowNumberList: sharingContent.shareSourceList.map({ $0.windowHandle.intValue }), screenToDraw: sharedScreen)
            case .desktop:
                result = ShareParameters(callId: callId, shareSourceType: .desktop, screen: sharedScreen, screenToDraw: sharedScreen)
            default:
                break
            }
        }
        return result;
    }
    
    private func drawShareBorder() {
        guard drawingId == MagicDrawing.inValidDrawingId else { return }
        if let shareParameters = shareParameters {
            switch shareParameters.shareSourceType {
            case .desktop:
                if isSharePaused {
                    drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: shareParameters.screenToDraw, style: .unsharedScreen))
                    SPARK_LOG_DEBUG("unsharedScreen drawingId:\(drawingId)")
                } else {
                    drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: shareParameters.screenToDraw, style: .sharingScreen))
                    SPARK_LOG_DEBUG("sharingScreen drawingId:\(drawingId)")
                }
            case .application:
                if let applicationList = shareParameters.applicationList {
                    if !isSharePaused {
                        drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.applicationBorderDrawing(applicationList: applicationList))
                        SPARK_LOG_DEBUG("applicationBorder drawingId:\(drawingId)")
                    }
                }
            case .window:
                if let windowNumberList = shareParameters.windowNumberList {
                    if !isSharePaused {
                        drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.windowBorderDrawing(windowNumberList: windowNumberList))
                        SPARK_LOG_DEBUG("windowBorderDrawing drawingId:\(drawingId)")
                    }
                }
            case .unknown, .content, .android, .ios: break
            @unknown default: break
            }
        }
    }
    
    private func removeShareBorder() {
        guard drawingId != MagicDrawing.inValidDrawingId else { return }
        SPARK_LOG_DEBUG("drawingId:\(drawingId)")
        drawingBoardManager.removeDrawing(drawingId: drawingId)
        drawingId = MagicDrawing.inValidDrawingId
    }
    
    private func updateKeyScreen() {
        if let uuid = shareParameters?.screenToDraw.uuid() {
            drawingBoardManager.setKeyScreen(screen: uuid)
        }
    }
    
    private func onIsSharingChanged() {
        updateShareBorder()
        if isSharing {
            excludeWindowFromShare()
        }
    }
    
    private func updateShareBorder() {
        removeShareBorder()
        if isSharing {
            drawShareBorder()
        }
    }
    
    @objc private func onScreenParametersChanged(_ notification:NSNotification) {
        updateShareViewModelScreenList()
    }
    
    @objc private func onApplicationDidTerminate(_ notification:NSNotification) {
        guard let dict = notification.userInfo else { return }
        
        if let app = dict[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
            SPARK_LOG_DEBUG(app.localizedName)
            shareViewModel.applicationDidTerminate(processId: String(app.processIdentifier))
        }
    }
    
    @objc private func onShareStateChanged(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String == callId, let callState = dict[CallStateKey] as? Int, let tType = dict[TrackTypeKey] as? NSInteger,  TrackVMType(rawValue: tType) == .local else { return }
        
        if let callState = CallStateEnum(rawValue: callState) {
            SPARK_LOG_DEBUG("\(callState.description)")
            switch callState {
            case .shareStartedEvent:
                isSharing = true
            case .shareFinishedEvent:
                isSharing = false
            default:
                break
            }
        }
    }
    
    @objc private func onCallDisconnected(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        
        removeShareBorder()
    }
    
    @objc private func onMediaDisconnected(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        
        removeShareBorder()
    }
    
    @objc private func onCallFailed(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        
        removeShareBorder()
    }
    
    private func processMinimizeSelfWindow(notification: CHShareNotification) {
        var frame: CGRect = .zero
        if let shareParameters = shareParameters {
            frame = shareParameters.screenToDraw.frame
        }
        let userInfo: [String: Any] = [
            CallIdKey: callId,
            MinimizeKey: notification.action == .hide,
            ShareRectKey: frame,
        ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareWillMiniaturizeWindow), object: self, userInfo: userInfo)
    }
}

extension ShareManagerComponent: ShareManagerComponentProtocol {
    func registerListener(_ listener: ShareManagerComponentListener & NSObject) {
        guard !listenerList.contains(where: { $0.value === listener }) else { return }
        SPARK_LOG_DEBUG("\(callId) listener:\(listener.className)")
        let weakListener = Weak<NSObject>(value: listener)
        listenerList.append(weakListener)
    }
    
    func unregisterListener(_ listener: ShareManagerComponentListener & NSObject) {
        SPARK_LOG_DEBUG("\(callId) listener:\(listener.className)")
        listenerList.removeAll { $0.value === listener || $0.value == nil }
    }
    
    func startShare(shareSourceList: [CHShareSource]) {
        guard !shareSourceList.isEmpty else { return SPARK_LOG_DEBUG("source empty") }
        SPARK_LOG_DEBUG("\(callId) type:\(shareSourceList[0].shareSourceType.rawValue) count: \(shareSourceList.count)")
        shareViewModel.startShare(sourceList: shareSourceList)
        excludeWindowFromShare()
    }
    
    func stopShare() {
        SPARK_LOG_DEBUG("\(callId)")
        shareViewModel.stopShare()
    }
    
    func endShareOnlyCallIfNotStart() {
        SPARK_LOG_DEBUG("\(callId)")
        shareViewModel.endShareOnlyCallIfNotStart()
    }
    
    func resumeShare() {
        SPARK_LOG_DEBUG("\(callId)")
        shareViewModel.resumeShare()
    }
    
    func pauseShare(doPause: Bool) {
        SPARK_LOG_DEBUG("doPause:\(doPause) \(callId)")
        shareViewModel.toggleSharePauseState(bPause: doPause)
    }
    
    func excludeWindowFromShare() {
        SPARK_LOG_DEBUG("\(callId)")
        for window in excludedWindowNumberList {
            if let point = UnsafeMutableRawPointer(bitPattern: window) {
                shareViewModel.excludeWindowFromShare(windowHandle: point)
            }
        }
        
        drawingBoardManager.setExcludedWindowNumberList(windowNumberList: excludedWindowNumberList)
    }
    
    func getShareSourcesSelectionWindowInfo() -> CHShareSourcesSelectionWindowInfo? {
        SPARK_LOG_DEBUG("\(callId)")
        return shareViewModel.getShareSourcesSelectionWindowInfo()
    }
    
    
    func setOptimizeForShare(type: CHShareOptimizeType) {
        SPARK_LOG_DEBUG("\(callId) optimizeType:\(type.rawValue)")
        shareViewModel.setOptimizeForShare(type: type)
    }
    
    func setEnableShareAudio(isEnabled: Bool) {
        SPARK_LOG_DEBUG("\(callId) isEnabled:\(isEnabled)")
        shareViewModel.setEnableShareAudio(isEnabled: isEnabled)
    }
    
    func installAudioSharePlugin() {
        SPARK_LOG_DEBUG("\(callId)")
        shareViewModel.installAudioSharePlugin()
    }
    
    func checkAudioSharePluginStatus() {
        SPARK_LOG_DEBUG("\(callId)")
        shareViewModel.checkAudioSharePluginStatus()
    }
    
    func getLocalShareControlBarInfo() -> CHLocalShareControlBarInfo? {
        SPARK_LOG_DEBUG("\(callId)")
        return shareViewModel.getLocalShareControlBarInfo()
    }
    
    func getRemoteShareControlBarInfo() -> CHRemoteShareControlBarInfo? {
        SPARK_LOG_DEBUG("\(callId)")
        return shareViewModel.getRemoteShareControlBarInfo()
    }
}

extension ShareManagerComponent: CHShareViewModelDelegate {
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onShareSourcesSelectionWindowInfoChanged info: CHShareSourcesSelectionWindowInfo) {
        SPARK_LOG_DEBUG("callId: \(callId)")
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onShareSourcesSelectionWindowInfoChanged: info)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onRemoteShareControlBarInfoChanged info: CHRemoteShareControlBarInfo) {
        SPARK_LOG_DEBUG("callId: \(callId)")
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onRemoteShareControlBarInfoChanged: info)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        SPARK_LOG_DEBUG("callId: \(callId)")
        isSharePaused = info.isSharePaused
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onLocalShareControlBarInfoChanged: info)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onResumeShareControlBarInfoChanged info: CHResumeShareControlBarInfo) {
        SPARK_LOG_DEBUG("callId: \(callId)")
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onResumeShareControlBarInfoChanged: info)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onShareNotificationArrived notification: CHShareNotification) {
        SPARK_LOG_DEBUG("\(notification.notificationType.rawValue): \(notification.action.rawValue) callId: \(callId)");
        switch notification.notificationType {
        case .showResumeShareWindow:
            shareResumeBar.update(component: self, info: notification)
        case .showSharePrepareWindow:
            sharePreparingWindowController.update(notification: notification)
        case .onShareMinimizeWindow:
            processMinimizeSelfWindow(notification: notification)
        default:
            break
        }
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onShareNotificationArrived: notification)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        SPARK_LOG_DEBUG("\(sharingContent.sourceType.rawValue) callId: \(callId)");
        updateShareBorder()
        updateKeyScreen()
        for weakListener in listenerList {
            if let listener = weakListener.value as? ShareManagerComponentListener {
                listener.shareManagerComponent(self, onSharingContentChanged: sharingContent)
            }
        }
    }
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onLocalShareStateChanged isActive: Bool) {}
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onHWAccelerationCheckReceived isSupported: Bool) {}
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onShareTabDataChanged sharingTabData: CHShareTabData) {}
    func shareViewModel(onSharingServiceStopped shareViewModel: CHShareViewModelProtocol) {}
}

extension ShareManagerComponentListener {
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareSourcesSelectionWindowInfoChanged info: CHShareSourcesSelectionWindowInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onRemoteShareControlBarInfoChanged info: CHRemoteShareControlBarInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onResumeShareControlBarInfoChanged info: CHResumeShareControlBarInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareNotificationArrived notification: CHShareNotification){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent){}
}
