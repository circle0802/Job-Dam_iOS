import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PasswordViewController: BaseViewController {
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "smallLogo")
    }
    let signupTitleLabel = UILabel().then {
        $0.text = "비밀번호를 입력해주세요!"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }
    let passwordTextField = JobdamTextField("비밀번호", placeholder: "8~25자 내로 생성(대소문자, 숫자, 특수문자 포함)", isSecure: true)
    let passwordConfirmTextField = JobdamTextField("비밀번호 확인", placeholder: "비밀번호를 다시 입력해주세요", isSecure: true)
    let loginLabel = UILabel().then {
        $0.text = "계정이 이미 있으신가요?"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.gray800.color
    }
    let loginButton = UIButton().then {
        let title = "로그인"
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.jobdamFont(.body2),
                .foregroundColor: JobDamAsset.main600.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.isUserInteractionEnabled = true
    }
    let nextButton = JobdamButton(text: "다음")

    override func addView() {
        [
            logoImage,
            signupTitleLabel,
            passwordTextField,
            passwordConfirmTextField,
            loginLabel,
            loginButton,
            nextButton
        ].forEach { view.addSubview($0) }
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.leading.equalToSuperview().inset(32)
        }
        signupTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(32)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(signupTitleLabel.snp.bottom).offset(54)
            $0.leading.trailing.equalToSuperview()
        }
        passwordConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
        }
        loginLabel.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
            $0.leading.equalToSuperview().inset(24)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-6)
            $0.leading.equalTo(loginLabel.snp.trailing).offset(4)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }

    override func bind() {
        passwordTextField.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
