import Foundation
import Moya
import ObjectMapper

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        // let str = String(data: prettyData, encoding: String.Encoding.utf8) as String!
        // let info = Mapper<RDModelBase<RDScrollPageViewModel>>().map(JSONString: str!)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}



let RDCommonUnsafeProvider = RxMoyaProvider<CommonUnsafe>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum CommonUnsafe {
    case scrollPageViews
    case everyonesApps
    case myApps
    case login
}

extension CommonUnsafe: TargetType {

    
    public var baseURL: URL { return URL(string: "http://10.71.33.72:8088/zftal-mobile")! }
    public var path: String {
        switch self {
        case .scrollPageViews:
            return "/homePageHttp/homePageHttp_getMhRecommendPage.html"
        case .everyonesApps:
            return "/homePageHttp/homePageHttp_getCommonService.html"
        case .myApps:
            return "/homePageHttp/homePageHttp_Commonfunction.html"
        case .login:
            return "/commonHttp/commonHttp_login.html"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .scrollPageViews:
            return ["size":"5"]
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        switch self {
        case .scrollPageViews:
            return "{\"code\": 1,\"msg\": \"成功\",\"data\": [{\"id\": \"683F8C2BDB934338836B650BB921C640\",\"title\": \"社会新闻1\",\"logoPathList\": [\"http://10.71.33.72:8088/zftal-mobile/homeimages/14890545747470df431adcbef7609010486dc2edda3cc7cd99e61.jpg\", \"http://10.71.33.72:8088/zftal-mobile/homeimages/e23cf9e1.gif\", \"http://10.71.33.72:8088/zftal-mobile/homeimages/148947762606112597126_980x1200_292.jpg\"],\"url\": \"http://10.71.33.72:8088/zftal-mobile/mobile/web_content.html?newsId\\u003d683F8C2BDB934338836B650BB921C640\"}, {\"id\": \"27172ADFC93A470FABD9F72A37B83427\",\"title\": \"NBA第四代\",\"logoPathList\": [\"http://10.71.33.72:8088/zftal-mobile/homeimages/1498441703084图片测试.jpg\", \"http://10.71.33.72:8088/zftal-mobile/homeimages/1498441927242图片测试002.jpg\"],\"url\": \"http://10.71.33.72:8088/zftal-mobile/mobile/web_content.html?newsId\\u003d27172ADFC93A470FABD9F72A37B83427\"}, {\"id\": \"83F9F8147F80410084CCD08A7E7FABB3\",\"title\": \"测试资讯类别\",\"logoPathList\": [\"http://10.71.33.72:8088/zftal-mobile/homeimages/1497600970413图片测试002.jpg\", \"http://10.71.33.72:8088/zftal-mobile/homeimages/1497600998023图片测试002.jpg\"],\"url\": \"http://10.71.33.72:8088/zftal-mobile/mobile/web_content.html?newsId\\u003d83F9F8147F80410084CCD08A7E7FABB3\"}]}".data(using: .utf8)!
        case .everyonesApps:
            return "{\"code\": 1,\"msg\": \"成功\",\"data\": [{\"id\": \"52D55D72B22546EA8D41F182FFD0127A\",\"type\": \"APP_APPLICATION\",\"name\": \"QQ\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/32.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"8036\",\"apkdownUrl\": \"http://10.71.33.72:8088/zftal-mobile//file/attachement_download.html?model.guId\\u003dA447B1926A134F7C87F272EA857D6044\",\"apkFileName\": \"0570338da10e94bbce2a000e77643d7e.apk\",\"apkPackage\": \"com.qiyi.video\",\"urlScheme\": \"mqq://\",\"urliTunes\": \"https://itunes.apple.com/us/app/qq/id444934666?mt\\u003d8\",\"procode\": \"xtbm666\",\"otherFlag\": \"0\",\"moduletype\": \"930B191C2B3F41579C0E92C1189CB4E0\"}, {\"id\": \"4C1B463F92084EB3B606C6AC2E967ABD\",\"type\": \"APP_APPLICATION\",\"name\": \"墨客\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/14.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"8148\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"com.moke.moke-1://\",\"urliTunes\": \"https://itunes.apple.com/us/app/%E5%A2%A8%E5%AE%A2-%E8%AF%97-%E8%AE%A9%E4%BD%A0%E5%AE%89%E5%AE%89%E9\",\"procode\": \"xtbm666\",\"otherFlag\": \"0\",\"moduletype\": \"930B191C2B3F41579C0E92C1189CB4E0\"}]}".data(using: .utf8)!
        case .myApps:
            return "{\"code\": 1,\"msg\": \"成功\",\"data\": [{\"id\": \"2051D7E3851FB986E050007F01007B7E\",\"type\": \"WEB_SERVICE\",\"name\": \"最新公文\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/1.png\",\"url\": \"http://10.71.19.248:8005/zfoa/mobilelogin.action?theAction\\u003dinit\\u0026procode\\u003d003\\u0026type\\u003d1\\u0026choice\\u003d4\\u0026uid\\u003d999\\u0026key\\u003d4dd99e44d83828457d482e43c1bcdec7\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"serviceCode\": \"2002\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"2076548AC90C37C0E050007F0100067F\",\"type\": \"APP_SERVICE\",\"name\": \"通知公告\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/minimages/14890320810634837014bda63d1d257de92a93ecefad2.jpg\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"301\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"1CAFD16709208294E050007F01007A50\",\"type\": \"APP_SERVICE\",\"name\": \"会议管理\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/20.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"304\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"1CAFE3C9F833B844E050007F01007A62\",\"type\": \"APP_SERVICE\",\"name\": \"待办事宜\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/9.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"306\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"22213A94DE1A1B47E050007F0100641F\",\"type\": \"WEB_SERVICE\",\"name\": \"车辆申请管理\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/upload/default_image.jpg\",\"url\": \"http://10.71.19.248:8005/zfoa/mobilelogin.action?theAction\\u003dinit\\u0026procode\\u003d003\\u0026type\\u003d1\\u0026choice\\u003d13\\u0026uid\\u003d999\\u0026key\\u003d90adc5676cdc98168d661724ed3f834f\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"serviceCode\": \"2007\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"252CE41521F48675E050007F01001093\",\"type\": \"APP_SERVICE\",\"name\": \"办结事宜\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/45.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"324\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}, {\"id\": \"252CE41521F48675E050007F01001094\",\"type\": \"APP_SERVICE\",\"name\": \"会议签到\",\"icon\": \"http://10.71.33.72:8088/zftal-mobile/icoimages/15.png\",\"androidUrl\": \"\",\"iosUrl\": \"\",\"wechatUrl\": \"\",\"serviceCode\": \"325\",\"apkdownUrl\": \"\",\"apkFileName\": \"\",\"apkPackage\": \"\",\"urlScheme\": \"\",\"urliTunes\": \"\",\"procode\": \"003\",\"otherFlag\": \"0\",\"moduletype\": \"1CAF68A0F3B6BD69E050007F01006EDC\"}]}".data(using: .utf8)!
        default:
            return "".data(using: .utf8)!
        }
    }
}

