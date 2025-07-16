import Foundation

enum APIConstants {
    static let baseURL: String = {
        guard let url = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("❌ BASE_URL not found in Info.plist")
        }
        return url
    }()
}
