//
//  RDMessage.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import Foundation
import SwiftMessages

private let globalInstance = RDMessage()

class RDMessage:SNMessageProtocol {

    var content: String {
        get {
            return "好像哪里出错了"
        }
        set (newValue){
            content = newValue
        }
    }
    
    var defaultStyle: SNMessageStyle {
        return .underNav
    }
    
    func showError(content:String) {
        self.show(type: .error, style: self.defaultStyle, content:content)
    }
    
    // MARK: - SNMessage
    
    func show(type: SNMessageType, style: SNMessageStyle) { }
    
    func show(type: SNMessageType, style: SNMessageStyle , content: String) {
        // View setup
        
        let view: MessageView
        switch style {
        case .floatTop:
            view = MessageView.viewFromNib(layout: .CardView)
        case .statusBar:
            view = MessageView.viewFromNib(layout: .StatusLine)
        default:
            view = try! SwiftMessages.viewFromNib()
        }
        
        view.configureContent(title: nil, body: content, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle = .default
        
        switch type {
        case .info:
            view.configureTheme(.info, iconStyle: iconStyle)
        case .success:
            view.configureTheme(.success, iconStyle: iconStyle)
        case .warning:
            view.configureTheme(.warning, iconStyle: iconStyle)
        case .error:
            view.configureTheme(.error, iconStyle: iconStyle)
        default:
            let iconText = ["🐸", "🐷", "🐬", "🐠", "🐍", "🐹", "🐼"].sm_random()
            view.configureTheme(backgroundColor: UIColor.purple, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
            view.button?.setImage(Icon.ErrorSubtle.image, for: .normal)
            view.button?.setTitle(nil, for: .normal)
            view.button?.backgroundColor = UIColor.clear
            view.button?.tintColor = UIColor.green.withAlphaComponent(0.7)
        }
        
        view.titleLabel?.isHidden = true
        
        // Config setup
        
        var config = SwiftMessages.defaultConfig
        
        // Show
        SwiftMessages.show(config: config, view: view)
        
    }
    
    func hide() {
        
    }
}

extension RDMessage {
    public static var sharedInstance: RDMessage {
        return globalInstance
    }
    
    
    public static func showError(content:String) {
        globalInstance.showError(content: content)
    }
    
}
