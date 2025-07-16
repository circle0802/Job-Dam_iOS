import Foundation

final class SignupInfo {
    static let shared = SignupInfo()

    var id: String?
    var password: String?
    var schoolLevel: String?
    var gender: String?

    public init() {}

    func toRequestDTO() -> [String: Any] {
        return [
            "id": id ?? "",
            "password": password ?? "",
            "schoolLevel": "고등학교",
            "gender": gender ?? ""
        ]
    }
}
