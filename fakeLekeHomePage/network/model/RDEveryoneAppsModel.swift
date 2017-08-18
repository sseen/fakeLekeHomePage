//
//  RDScrollPageViewModel.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit
import ObjectMapper
import RxDataSources

class RDEveryoneAppsModel: Mappable {
    var id: String?
    var type    : String?
    var name    : String?
    var icon    : String?
    var androidUrl : String?
    var iosUrl    : String?
    var wechatUrl  : String?
    var serviceCod : String?
    var apkdownUrl : String?
    var apkFileNam : String?
    var apkPackage : String?
    var urlScheme  : String?
    var urliTunes  : String?
    var procode    : String?
    var otherFlag  : String?
    var moduletype : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        name <- map["name"]
        icon <- map["icon"]
        androidUrl <- map["androidUrl"]
        iosUrl <- map["iosUrl"]
        wechatUrl <- map["wechatUrl"]
        serviceCod <- map["serviceCod"]
        apkdownUrl <- map["apkdownUrl"]
        apkFileNam <- map["apkFileNam"]
        apkPackage <- map["apkPackage"]
        urlScheme <- map["urlScheme"]
        urliTunes <- map["urliTunes"]
        procode  <- map["procode"]
        otherFlag <- map["otherFlag"]
        moduletype <- map["moduletype"]
    }
}

extension RDEveryoneAppsModel: Hashable, IdentifiableType {
    
    static func ==(lhs: RDEveryoneAppsModel, rhs: RDEveryoneAppsModel) -> Bool {
        return lhs.id! == rhs.id! &&
        lhs.type!==rhs.type! &&
        lhs.name!==rhs.name! &&
        lhs.icon!==rhs.icon! &&
        lhs.androidUrl!==rhs.androidUrl! &&
        lhs.iosUrl!==rhs.iosUrl! &&
        lhs.wechatUrl!==rhs.wechatUrl! &&
        lhs.serviceCod!==rhs.serviceCod! &&
        lhs.apkdownUrl!==rhs.apkdownUrl! &&
        lhs.apkFileNam!==rhs.apkFileNam! &&
        lhs.apkPackage!==rhs.apkPackage! &&
        lhs.urlScheme!==rhs.urlScheme! &&
        lhs.urliTunes!==rhs.urliTunes! &&
        lhs.procode!==rhs.procode! &&
        lhs.otherFlag!==rhs.otherFlag! &&
        lhs.moduletype!==rhs.moduletype! 
    }
    
    var hashValue: Int {
        return id!.hashValue
    }
    
    var identity: String {
        return id!
    }
    
}
