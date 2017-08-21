//
//  RDUtils.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//
import RxSwift
import YYCache

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
    struct Size  {
        
        static let iconSize:CGFloat = 32
        static let iconAppSize:CGFloat = 29
    }
    
    struct Color {
        static let titleBlack = UIColor(hex: 0x484848)
        static let titleGray = UIColor(hex: 0x929292)
        static let titleSearchGray = UIColor(hex: 0xb1b1b1)
        static let bgGray = UIColor(hex: 0xf3f6f9)
        
        static let tabBlue = UIColor(hex: 0x4cb2ff)
        static let tabGray = UIColor(hex: 0xd5e3ed)
    }
    struct CommonUnit {
        static let marginItem = 20
        static let navPlusStatus:CGFloat = 64
        static let animationTime:TimeInterval = 0.33
        static let delayTime:TimeInterval = 0
        static let bannerHeight:CGFloat = 188
        static let iconsHeight:CGFloat = 84
        static let navbar_change_point = 50
        static let cellReuse = "cell0"
        static let headerReuse = "headerView"
        
        static let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
    }
    
    struct CustomCollection {
        static let DayHeaderHeight = CommonUnit.iconsHeight * 2
        static let HourHeaderWidth = CommonUnit.iconsHeight
        static let DaysPerWeek = 5
    }
    
    struct Cache {
        struct Key {
            static let scrollImages = "scrollImages"
        }
        static let scrollImages = YYCache(name: Key.scrollImages)
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

extension UIFont {
    enum Size:CGFloat  {
        case  fontSmall = 12
        case  fontMiddle = 15
        case  fontLarge = 18
    }
    
    enum CustomFont: String {
        case Avenir = "Avenir"
        case Lato = "Lato"
        case System = ".PingFangSC-Medium" //SFUIText
        case SystemRegular = ".PingFangSC-Regular"
    }
    convenience init (custSize:Size){
        self.init(.System, size: custSize)
    }
    convenience init(_ customName:CustomFont, size:Size) {
        self.init(name: customName.rawValue, size: size.rawValue)!
    }
}

