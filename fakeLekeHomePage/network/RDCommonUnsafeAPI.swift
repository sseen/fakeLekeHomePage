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
        default:
            return "".data(using: .utf8)!
        }
    }
}

