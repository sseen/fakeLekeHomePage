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

class RDScrollPageViewModel: Mappable {
    var id: String?
    var title: String?
    var url: String?
    var logoPathList: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        logoPathList <- map["logoPathList"]
    }
}

extension RDScrollPageViewModel: Hashable, IdentifiableType {
    
    static func ==(lhs: RDScrollPageViewModel, rhs: RDScrollPageViewModel) -> Bool {
        return lhs.id! == rhs.id! && lhs.title! == rhs.title! && lhs.url! == rhs.url! && lhs.logoPathList! == rhs.logoPathList!
    }
    
    var hashValue: Int {
        return id!.hashValue
    }
    
    var identity: String {
        return id!
    }
    
}
