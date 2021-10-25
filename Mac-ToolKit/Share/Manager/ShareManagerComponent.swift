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
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareNotificationArrived notification: CHShareNotification)
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent)
}

protocol ShareManagerComponentSetup {
    func setup(shareComponent: ShareManagerComponentProtocol)
}

protocol ShareManagerComponentDelegate: AnyObject {
    func getExcludeWindowNumberList() -> [CGWindowID]
}

protocol ShareManagerComponentProtocol: AnyObject {
    func registerListener(_ listener: ShareManagerComponentListener & NSObject)
    func unregisterListener(_ listener: ShareManagerComponentListener & NSObject)
    var delegate: ShareManagerComponentDelegate? { get set }
    var callId: String { get }

    var shareContext: ShareContextProtocol { get }
    var shareIosScreenManager: ShareIosScreenManagerProtocol { get }

    func startShare(shareSourceList: [CHShareSource], shareType: CHShareType)
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
    func getLocalShareControlWindowLabelTooltip() -> String

    func getRemoteShareControlBarInfo() -> CHRemoteShareControlBarInfo?
}

class ShareManagerComponent: NSObject {
    private(set) var callId = ""
    weak var delegate: ShareManagerComponentDelegate?
    var shareContext: ShareContextProtocol {
        updateShareContext()
        return mShareContext
    }
    private var mShareContext: ShareContext = ShareContext(callId: "")
    private var listenerList = [Weak<NSObject>]()
    private let appContext: AppContext
    private let shareFactory: ShareFactoryProtocol
    private let drawingBoardManager: MagicDrawingBoardManagerProtocol
    private var drawingId: MagicDrawingId = MagicDrawing.inValidDrawingId
    private let shareViewModel: CHShareViewModelProtocol
    private lazy var sharePreparingWindowController: SharePreparingWindowControllerProtocol = SharePreparingWindowController()
    private lazy var shareResumeBar: ShareResumeWindowControllerProtocol = ShareResumeWindowController(appContext: appContext)
    private var localShareControlBarManager: LocalShareControlBarManagerProtocol
    var shareIosScreenManager: ShareIosScreenManagerProtocol
    
    private var isSharing = false {
        didSet {
            //when switch share, they won't tell "isSharing = false", then "isSharing = true". Instead, they only tell "isSharing = true". So we should clean the last remnant when receive "isSharing = true".
            onIsSharingChanged()
            mShareContext.isLocalSharing = isSharing
        }
    }
    private var isSharePaused = false {
        didSet {
            if isSharePaused != oldValue {
                updateShareBorder()
            }
        }
    }
     
    private var excludedWindowNumberList: [CGWindowID] { delegate?.getExcludeWindowNumberList() ?? [] }
    
    init(appContext: AppContext, callId: String) {
        self.appContext = appContext
        shareFactory = appContext.shareFactory
        self.callId = callId
        shareIosScreenManager = ShareIosScreenManager(shareFactory: appContext.shareFactory)
        
        shareViewModel = appContext.commonHeadFrameworkAdapter.makeShareViewModel()
        drawingBoardManager = appContext.drawingBoardManager
        
        localShareControlBarManager = shareFactory.makeLocalShareControlBarManager()
        
        super.init()

        shareViewModel.initialize(callId: callId)
        initialize()
    }
    
    init(appContext: AppContext, type: CHShareCallType, conversationId: String) {
        self.appContext = appContext
        shareFactory = appContext.shareFactory

        shareViewModel = appContext.commonHeadFrameworkAdapter.makeShareViewModel()
        drawingBoardManager = appContext.drawingBoardManager
        shareIosScreenManager = ShareIosScreenManager(shareFactory: appContext.shareFactory)
        localShareControlBarManager = shareFactory.makeLocalShareControlBarManager()
        
        super.init()
        
        shareViewModel.initialize(type: type, conversationId: conversationId)
        callId = shareViewModel.getCallId() ?? ""
        sparkAssert(!callId.isEmpty, "callId should not be empty")
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        clear()
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
        mShareContext.callId = callId
        updateShareViewModelScreenList()
        shareViewModel.delegate = self
        
        updateShareContext()
        if let info = shareViewModel.getLocalShareControlBarInfo() {
            isSharePaused = info.isSharePaused
        }
        shareIosScreenManager.setup(shareComponent: self)
        localShareControlBarManager.setup(shareComponent: self)
    }
    
    private func getScreenList() -> [String] {
        NSScreen.screens.compactMap{ $0.uuid() ?? nil }
    }
    
    private func updateShareViewModelScreenList() {
        shareViewModel.setScreenList(screenList: getScreenList())
    }
    
    private func isWindowValid(windowNumber: CGWindowID, onScreenOnly: Bool) -> Bool {
        drawingBoardManager.getWindowInfoList(exclude: false, onScreenOnly: onScreenOnly).contains { $0.windowNumber == windowNumber }
    }
    
    private func getWindowInfo(windowNumber: CGWindowID, onScreenOnly: Bool) -> MagicWindowInfo? {
        drawingBoardManager.getWindowInfoList(exclude: false, onScreenOnly: onScreenOnly).first { $0.windowNumber == windowNumber }
    }
    
    private func updateShareContext() {
        guard let sharingContent = shareViewModel.getSharingContent() else { return }
        switch sharingContent.sourceType {
        case .application:
            mShareContext.update(shareSourceType: .application, captureRect: sharingContent.captureRect, applicationList: sharingContent.shareSourceList.map({ $0.sourceId }), sharingWindowNumberList: sharingContent.capturedWindows.compactMap({
                if $0.intValue >= 0, isWindowValid(windowNumber: CGWindowID($0.intValue), onScreenOnly: true) {
                    return CGWindowID($0.intValue)
                }
                return nil
            }))
        case .window:
            mShareContext.update(shareSourceType: .window, captureRect: sharingContent.captureRect, windowNumberList: sharingContent.shareSourceList.map({ $0.windowHandle.uint32Value }), sharingWindowNumberList: sharingContent.capturedWindows.compactMap({
                if $0.intValue >= 0, isWindowValid(windowNumber: CGWindowID($0.intValue), onScreenOnly: true) {
                    return CGWindowID($0.intValue)
                }
                return nil
            }))
        case .desktop:
            mShareContext.update(shareSourceType: .desktop, captureRect: sharingContent.captureRect, screenId: sharingContent.shareSourceList.first?.sourceId ?? "")
        default:
            mShareContext.update(shareSourceType: .unknown)
        }
    }
    
    private func drawShareBorder() {
        guard drawingId == MagicDrawing.inValidDrawingId else { return }
        switch mShareContext.shareSourceType {
        case .desktop:
            if isSharePaused {
                drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: mShareContext.screenToDraw, style: .unsharedScreen))
                SPARK_LOG_DEBUG("unsharedScreen drawingId:\(drawingId)")
            } else {
                drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: mShareContext.screenToDraw, style: .sharingScreen))
                SPARK_LOG_DEBUG("sharingScreen drawingId:\(drawingId)")
            }
        case .application:
            if let applicationList = mShareContext.applicationList {
                if !isSharePaused {
                    drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.applicationBorderDrawing(applicationList: applicationList))
                    SPARK_LOG_DEBUG("applicationBorder drawingId:\(drawingId)")
                }
            }
        case .window:
            if let windowNumberList = mShareContext.windowNumberList  {
                if !isSharePaused {
                    drawingId = drawingBoardManager.addDrawing(drawing: MagicDrawing.windowBorderDrawing(windowNumberList: windowNumberList))
                    SPARK_LOG_DEBUG("windowBorderDrawing drawingId:\(drawingId)")
                }
            }
        case .unknown, .content, .android, .ios: break
        @unknown default: break
        }
    }
    
    private func removeShareBorder() {
        guard drawingId != MagicDrawing.inValidDrawingId else { return }
        SPARK_LOG_DEBUG("drawingId:\(drawingId)")
        drawingBoardManager.removeDrawing(drawingId: drawingId)
        drawingId = MagicDrawing.inValidDrawingId
    }
    
    private func updateKeyScreen() {
        if let uuid = mShareContext.screenToDraw.uuid() {
            drawingBoardManager.setKeyScreen(screen: uuid)
        }
    }
    
    private func onIsSharingChanged() {
        updateShareContext()
        updateShareBorder()
        updateShareIosScreenManager()
        activeSharedWindow()
        updateLocalShareControlBar()
        
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
    
    private func updateShareIosScreenManager() {
        let isSharingIosScreen = isSharing && (shareContext.lastStartShareInfo?.shareType == .iosViaCable)
        shareIosScreenManager.isSharingIosScreen = isSharingIosScreen

        if !isSharingIosScreen {
            shareIosScreenManager.stop()
        }
    }
    
    private func updateLocalShareControlBar() {
        guard appContext.coreFramework.sparkFeatureFlagsProxy.isSharingControlBarDraggableEnabled() else { return }
        
        if isSharing {
            localShareControlBarManager.showShareControlBar()
        } else {
            localShareControlBarManager.hideShareControlBar()
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
        
        stopShareWhenAllWindowClose()
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
    
    private func clear() {
        removeShareBorder()
        shareIosScreenManager.stop()
        mShareContext.update(shareSourceType: .unknown)
    }
    
    @objc private func onCallDisconnected(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        isSharing = false
        clear()
    }
    
    @objc private func onMediaDisconnected(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        isSharing = false
        
        clear()
    }
    
    @objc private func onCallFailed(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], dict[CallIdKey] as? String  == callId else {
            return
        }
        SPARK_LOG_INFO("\(callId)")
        isSharing = false
        clear()
    }
    
    private func processMinimizeSelfWindow(notification: CHShareNotification) {
        let frame = mShareContext.screenToDraw.frame
        let userInfo: [String: Any] = [
            CallIdKey: callId,
            MinimizeKey: notification.action == .hide,
            ShareRectKey: frame,
        ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareWillMiniaturizeWindow), object: self, userInfo: userInfo)
    }
    
    private func activeSharedWindow() {
        guard isSharing, shareContext.shareSourceType == .window, let sharedApplicationIdList = shareContext.lastStartShareInfo?.shareSourceList.map({ $0.sourceId }) else { return }
        
        let sharedApplicationList: [NSRunningApplication] = NSWorkspace.shared.runningApplications.compactMap {
            if sharedApplicationIdList.contains(String($0.processIdentifier)) {
                return $0
            }
            return nil
        }
        
        for application in sharedApplicationList {
            application.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        }
    }
    
    private func stopShareWhenAllWindowClose() {
        guard shareContext.lastStartShareInfo?.shareType == .window, let windowNumberList = shareContext.windowNumberList else { return }
        if windowNumberList.first(where: { isWindowValid(windowNumber: $0, onScreenOnly: false) }) == nil {
            SPARK_LOG_DEBUG("")
            stopShare()
        }
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
    
    func startShare(shareSourceList: [CHShareSource], shareType: CHShareType) {
        guard !shareSourceList.isEmpty else { return SPARK_LOG_DEBUG("source empty") }
        SPARK_LOG_DEBUG("\(callId) count: \(shareSourceList.count), shareType:\(shareType.rawValue)")
        mShareContext.lastStartShareInfo = StartShareInfo(shareSourceList: shareSourceList, shareType: shareType)
        if shareType == .iosViaCable {
            shareIosScreenManager.start()
        }
        shareViewModel.startShare(sourceList: shareSourceList, shareType: shareType)
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
        if shareContext.lastStartShareInfo?.shareType == .iosViaCable {
            shareIosScreenManager.start()
        }
    }
    
    func pauseShare(doPause: Bool) {
        SPARK_LOG_DEBUG("doPause:\(doPause) \(callId)")
        shareViewModel.toggleSharePauseState(bPause: doPause)
    }
    
    func excludeWindowFromShare() {
        SPARK_LOG_DEBUG("\(callId)")
        if appContext.coreFramework.getConfigValue(ConfigKeys.excludeWindowFromShareToggle)?.boolValue == true,  appContext.coreFramework.getConfigValue(ConfigKeys.excludeWindowFromShareEnabled)?.boolValue == false {
                return SPARK_LOG_DEBUG("excludeWindowFromShareEnabled is disabled.")
        }
        
        for window in excludedWindowNumberList {
            if let point = UnsafeMutableRawPointer(bitPattern: Int(window)) {
                shareViewModel.excludeWindowFromShare(windowHandle: point)
            }
        }
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
    
    func getLocalShareControlWindowLabelTooltip() -> String {
        var tooltip = ""
        if let windowNumberList = shareContext.windowNumberList {
            let shareSourceList: [CHShareSource] = windowNumberList.compactMap {
                if let windowInfo = getWindowInfo(windowNumber: $0, onScreenOnly: false) {
                    return CHShareSource.make(windowInfo: windowInfo)
                }
                return nil
            }
            tooltip = shareViewModel.getValidSharingWindowsTooltips(validSources: shareSourceList) ?? ""
        }
        SPARK_LOG_DEBUG(tooltip)
        return tooltip
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
    
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onShareNotificationArrived notification: CHShareNotification) {
        SPARK_LOG_DEBUG("\(notification.notificationType.rawValue): \(notification.action.rawValue) callId: \(callId)");
        switch notification.notificationType {
        case .showResumeShareWindow:
            shareResumeBar.update(component: self, info: notification)
        case .showSharePrepareWindow:
            if shareContext.lastStartShareInfo?.shareType != .iosViaCable {
                sharePreparingWindowController.update(notification: notification)
            }
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
        updateShareContext()
        updateShareBorder()
        updateKeyScreen()
        stopShareWhenAllWindowClose()
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
    func shareViewModel(_ shareViewModel: CHShareViewModelProtocol, onResumeShareControlBarInfoChanged info: CHResumeShareControlBarInfo) {}
}

extension ShareManagerComponentListener {
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareSourcesSelectionWindowInfoChanged info: CHShareSourcesSelectionWindowInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onRemoteShareControlBarInfoChanged info: CHRemoteShareControlBarInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onShareNotificationArrived notification: CHShareNotification){}
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent){}
}
