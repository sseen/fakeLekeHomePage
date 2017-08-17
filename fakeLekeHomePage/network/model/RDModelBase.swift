//
//  RDModelBase.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class RDModelBase<T:Mappable>: Mappable {
    var code: Int?
    var msg: String?
    var data: [T]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
