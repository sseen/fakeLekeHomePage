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
        default:
            return "".data(using: .utf8)!
        }
    }
}

