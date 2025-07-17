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
    let nextButton = JobdamButton(text: "다음")

    override func addView() {
        [
            logoImage,
            signupTitleLabel,
            passwordTextField,
            passwordConfirmTextField,
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
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }

    override func bind() {
        Observable
            .combineLatest(
                passwordTextField.textField.rx.text.orEmpty,
                passwordConfirmTextField.textField.rx.text.orEmpty
            )
            .map { password, confirm in
                return !password.isEmpty && !confirm.isEmpty && password == confirm
            }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                SignupInfo.shared.password = self?.passwordTextField.textField.text
                let infoVC = InfoViewController()
                self?.navigationController?.pushViewController(infoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
