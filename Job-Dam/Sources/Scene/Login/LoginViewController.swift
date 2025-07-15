import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "smallLogo")
    }
    let loginTitleLabel = UILabel().then {
        $0.text = "로그인 후 진로 탐색을 시작해보세요!"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }
    let idTextField = JobdamTextField("아이디", placeholder: "아이디를 입력해주세요")
    let passwordTextField = JobdamTextField("비밀번호", placeholder: "비밀번호를 입력해주세요", isSecure: true)
    let loginButton = JobdamButton(text: "로그인")

    override func addView() {
        [
            logoImage,
            loginTitleLabel,
            idTextField,
            passwordTextField,
            loginButton
        ].forEach { view.addSubview($0) }
    }

    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.leading.equalToSuperview().inset(32)
        }
        loginTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(32)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginTitleLabel.snp.bottom).offset(54)
            $0.leading.trailing.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview()
        }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }
    
    override func bind() {
        Observable
            .combineLatest(
                idTextField.textField.rx.text.orEmpty,
                passwordTextField.textField.rx.text.orEmpty
            )
            .map { !$0.isEmpty && !$1.isEmpty }
            .distinctUntilChanged()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
