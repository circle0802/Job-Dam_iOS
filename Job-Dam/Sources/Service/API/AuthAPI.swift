import UIKit
import Moya

enum AuthAPI {
    case signup(parameters: [String: Any])
    case login(id: String, password: String)
    case idConfirm(id: String)
    case myPage
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/user/register"
        case .login:
            return "/user/login"
        case .idConfirm(let id):
            return "/user/exist?id=\(id)"
        case .myPage:
            return "/user/myPage"
        }
    }

    var method: Moya.Method {
        switch self {
        case .idConfirm, .myPage:
            return .get
        default:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signup(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case .login(let id, let password):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "password": password
                ], encoding: JSONEncoding.default)
        case .idConfirm, .myPage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myPage:
            return Header.accessToken.header()
        default:
            return Header.tokenIsEmpty.header()
        }
    }
}
