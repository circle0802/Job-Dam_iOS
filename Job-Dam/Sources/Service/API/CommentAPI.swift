import UIKit
import Moya

enum CommentAPI {
    case evaluation(id: Int, point: Double)
}

extension CommentAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .evaluation:
            return "/comment/rate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .evaluation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .evaluation(let id, let point):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "point": point
                ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return Header.accessToken.header()
        }
    }
}
