//
//  RDScrollPageViewModel.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit
import ObjectMapper

class RDScrollPageViewModel: Mappable {
    var id: String?
    var title: String?
    var url: String?
    var logoPathList: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        logoPathList <- map["logoPathList"]
    }
}
