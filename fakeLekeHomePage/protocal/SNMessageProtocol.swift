//
//  SNMessageProtocal.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import Foundation

enum SNMessageType {
    case error
    case warning
    case info
    case success
}

enum SNMessageStyle {
    case statusBar
    case underNav
    case card
    case floatTop
    case center
}

protocol SNMessageProtocol {
    var content:String { set get }
    var defaultStyle:SNMessageStyle { get }
    func show(type:SNMessageType,style:SNMessageStyle)
    func show(type:SNMessageType,style:SNMessageStyle,content:String)
    func hide()
}

