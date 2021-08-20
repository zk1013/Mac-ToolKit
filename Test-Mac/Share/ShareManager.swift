//
//  ShareManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/6/9.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

protocol ShareManagerProtocol: AnyObject {
    func getComponent(callId: String) -> ShareManagerComponentProtocol?
    func getComponent(type: CHShareCallType, conversationId: String) -> ShareManagerComponentProtocol?
    var telemetryManager: CHShareTelemetryManagerProtocol { get }
}

class ShareManager: NSObject {
    private let appContext: AppContext
    private(set) lazy var telemetryManager: CHShareTelemetryManagerProtocol = appContext.commonHeadFrameworkAdapter.makeShareTelemetryManager()
    
    private var shareManagerComponents = [String : ShareManagerComponentProtocol]()
    
    private var excludedWindowNumberList = [Int]()
    
    init(appContext: AppContext) {
        self.appContext = appContext
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onCallStateChanged), name: NSNotification.Name(rawValue: OnCallStateChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onShareShouldExcludeWindow), name: NSNotification.Name(rawValue: OnShareShouldExcludeWindow), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createShareManagerComponent(callId: String) -> ShareManagerComponentProtocol {
        if let component = shareManagerComponents[callId] {
            return component
        }
        SPARK_LOG_DEBUG("create component: \(callId)")
        let component = ShareManagerComponent(appContext: appContext, callId: callId)
        component.delegate = self
        component.excludeWindowFromShare()
        shareManagerComponents[callId] = component
        return component
    }
    
    private func createShareManagerComponent(type: CHShareCallType, conversationId: String) -> ShareManagerComponentProtocol {
        SPARK_LOG_DEBUG("create component: {type:\(type.rawValue), conversationId:\(conversationId)}")
        let component = ShareManagerComponent(appContext: appContext, type: type, conversationId: conversationId)
        if let existingComponent = shareManagerComponents[component.callId] {
            SPARK_LOG_DEBUG("find already existing component: \(component.callId), just return it")
            return existingComponent
        } else {
            component.delegate = self
            component.excludeWindowFromShare()
            shareManagerComponents[component.callId] = component
            return component
        }
    }
    
    private func removeShareManagerComponent(callId: String) {
        SPARK_LOG_DEBUG("remove component: \(callId)")
        shareManagerComponents[callId] = nil
    }
    
    @objc private func onCallStateChanged(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: AnyObject], let callId = dict[CallIdKey] as? String, let callState = dict[CallStateKey] as? Int else { return }
        
        if let callState = CallStateEnum(rawValue: callState) {
            switch callState {
            case .callStarted:
                let _ = createShareManagerComponent(callId: callId)
            case .callTerminated:
                removeShareManagerComponent(callId: callId)
            default:
                break
            }
        }
    }
    
    @objc private func onShareShouldExcludeWindow(notification: NSNotification) {
        if let windowNumber = notification.userInfo?["windowNumber"] as? Int {
            if !excludedWindowNumberList.contains(windowNumber) {
                excludedWindowNumberList.append(windowNumber)
                shareManagerComponents.values.forEach{ $0.excludeWindowFromShare() }
            }
        }
    }
}

extension ShareManager: ShareManagerProtocol {
    func getComponent(callId: String) -> ShareManagerComponentProtocol? {
        var component = shareManagerComponents[callId]
        if component == nil {
            SPARK_LOG_ERROR("can't find share component for:\(callId)")
            component = createShareManagerComponent(callId: callId)
        }
        return component
    }
    
    func getComponent(type: CHShareCallType, conversationId: String) -> ShareManagerComponentProtocol? {
        return createShareManagerComponent(type: type, conversationId: conversationId)
    }
}

extension ShareManager: ShareManagerComponentDelegate {
    func getExcludeWindowNumberList() -> [Int] {
        return excludedWindowNumberList
    }
}
