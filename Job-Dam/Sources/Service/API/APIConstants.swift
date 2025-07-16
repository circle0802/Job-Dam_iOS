import Foundation

enum APIConstants {
    static let baseURL: String = {
        if let url = Bundle.main.infoDictionary?["BASE_URL"] as? String {
            print("🔵 BASE_URL loaded: \(url)")
            return url
        } else {
            fatalError("❌ BASE_URL not found in Info.plist")
        }
    }()
}

