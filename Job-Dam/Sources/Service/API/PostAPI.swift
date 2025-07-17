import UIKit
import Moya

enum PostAPI {
    case viewAllPosts
    case viewDetailPost(id: Int)
    case createPost(title: String, content: String)
    case deletePost(id: Int)
    case editPost(id: Int, content: String)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .viewAllPosts:
            return "/posts"
        case .viewDetailPost(let id), .deletePost(let id), .editPost(let id, _):
            return "/post/\(id)"
        case .createPost:
            return "/post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .viewAllPosts, .viewDetailPost:
            return .get
        case .createPost:
            return .post
        case .deletePost:
            return .delete
        case .editPost:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createPost(let title, let content):
            return .requestParameters(
                parameters: [
                    "title": title,
                    "content": content
                ], encoding: JSONEncoding.default)
        case .editPost(_ , let content):
            return .requestParameters(
                parameters: [
                    "content": content
                ], encoding: JSONEncoding.default)
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
