//
//  RDRequestAlertPlugin.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/17.
//  Copyright © 2017年 sseen. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftMessages

final class RequestAlertPlugin: PluginType {
    private let viewController: UIViewController
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    func willSend(request: RequestType, target: TargetType) {
        print("will send")
    }
    func didReceive(result: Result<Response, MoyaError>, target: TargetType) {
        guard case Result.failure(_) = result else { return }//只监听失败
        
        // 弹出Alert
        SwiftMessages.show(view: viewController.view)
    }
}
