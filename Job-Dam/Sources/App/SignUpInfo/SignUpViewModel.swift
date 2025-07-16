import UIKit

class SignUpViewModel {
    var info = SignupInfo.shared

    func updateUsername(_ username: String) {
        info.id = username
    }

    func updatePassword(_ password: String) {
        info.password = password
    }

    func submit() {
        // 서버 전송용 DTO 변환 후 API 호출
    }
}
