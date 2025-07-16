import UIKit
import Moya

enum PostAPI {
    case viewAllPosts
    case viewDetailPost(id: Int)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .viewAllPosts:
            return "/posts"
        case .viewDetailPost(let id):
            return "/post/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .viewAllPosts:
            return .get
        case .viewDetailPost:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return Header.accessToken.header()
        }
    }
}
