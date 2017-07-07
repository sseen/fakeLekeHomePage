//
//  RDUtils.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//
import RxSwift

struct K {
    struct NotificationKey {
        static let Welcome = "kWelcomeNotif"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct ViewSize {
        static let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    }
    
    struct Rx {
        static  let disposeBag = DisposeBag()
    }
}

struct RD {
    
    enum HomeHeaderState{
        case hided
        case showing
        case partial
    }
    
    struct CommonUnit {
        static let marginItem = 20
        static let navPlusStatus:CGFloat = 64
        static let animationTime:TimeInterval = 0.33
        static let delayTime:TimeInterval = 0
        static let bannerHeight:CGFloat = 120
        static let bannerPlusIconsHeight:CGFloat = 120 * 2
        static let navbar_change_point = 50
        static let cellReuse = "cell0"
        static let headerReuse = "headerView"
        
        static let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
    }
}

extension UIColor {
    // Usage: UIColor(hex: 0xFC0ACE)
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    // Usage: UIColor(hex: 0xFC0ACE, alpha: 0.25)
    convenience init(hex: Int, alpha: Double) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}

