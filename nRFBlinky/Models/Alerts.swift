//
//  Alerts.swift
//  CalmDataLogger
//
//  Created by Admin on 8/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import SwiftMessages

class Alerts {
    private static var alertConfig: SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        config.duration = .automatic
        config.dimMode = .none
        config.interactiveHide = false
        config.preferredStatusBarStyle = .default
        return config
    }
    
    private static var errorAlertConfig: SwiftMessages.Config {
        var config = alertConfig
        config.duration = .forever
        return config
    }
    
    private static var errorToastConfig: SwiftMessages.Config {
        var config = alertConfig
        config.duration = .automatic
        return config
    }
    
    static func showSuccess(title: String, message: String) {
        SwiftMessages.show(config: alertConfig, viewProvider: {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: nil)
            return view
        })
    }
    
    static func showInfo(title: String, message: String) {
        SwiftMessages.show(config: alertConfig, viewProvider: {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.info)
            view.configureDropShadow()
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: nil)
            return view
        })
    }
    
    static func showWarning(title: String, message: String) {
        SwiftMessages.show(config: alertConfig, viewProvider: {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: nil)
            return view
        })
    }
    
    static func showError(title: String, message: String) {
        SwiftMessages.show(config: errorAlertConfig, viewProvider: {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: nil)
            return view
        })
    }
    
    static func showToastError(title: String, message: String) {
        SwiftMessages.show(config: errorToastConfig, viewProvider: {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: { _ in
                SwiftMessages.hide()
            })
            //            view.button?.isHidden = true
            //            view.bodyLabel?.textAlignment = .center
            //            view.bodyLabel?.backgroundColor = UIColor.red
            return view
        })
    }
}

