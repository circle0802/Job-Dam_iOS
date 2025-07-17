import Foundation

struct Token {
    static var saveAccessToken: String?
    static var accessToken: String? {
        get {
            saveAccessToken = UserDefaults.standard.string(forKey: "accessToken")
            return saveAccessToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
            UserDefaults.standard.synchronize()
            saveAccessToken = newValue
        }
    }

    static var saveRefreshToken: String?
    static var refreshToken: String? {
        get {
            saveRefreshToken = UserDefaults.standard.string(forKey: "refreshToken")
            return saveRefreshToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refreshToken")
            UserDefaults.standard.synchronize()
            saveRefreshToken = newValue
        }
    }

    static var saveNickname: String?
    static var userID: String? {
        get {
            saveNickname = UserDefaults.standard.string(forKey: "userID")
            return saveNickname
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
            saveNickname = newValue
        }
    }

    static func removeToken() {
        accessToken = nil
        refreshToken = nil
        userID = nil
    }
}


enum Header {
    case accessToken, tokenIsEmpty, refreshToken, uploadImage

    func header() -> [String: String]? {
        switch self {
        case .accessToken:
            if let token = Token.accessToken {
                print("💡 AccessToken exists: \(token)")
                return ["Authorization": "Bearer \(token)"]
            } else {
                print("⚠️ AccessToken is missing")
                return ["Content-Type": "application/json"]
            }

        case .refreshToken:
            if let token = Token.accessToken, let refresh = Token.refreshToken {
                return ["Authorization": "Bearer \(token)",
                        "Refresh-Token": refresh,
                        "Content-Type": "application/json"]
            } else {
                print("⚠️ RefreshToken or AccessToken is missing")
                return ["Content-Type": "application/json"]
            }

        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]

        case .uploadImage:
            if let token = Token.accessToken {
                return ["Authorization": "Bearer \(token)",
                        "Content-Type": "multipart/form-data"]
            } else {
                return ["Content-Type": "multipart/form-data"]
            }
        }
    }
}
