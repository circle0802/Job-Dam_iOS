import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SignupViewController: BaseViewController {
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "smallLogo")
    }
    let loginTitleLabel = UILabel().then {
        $0.text = "아이디를 입력해주세요!"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }
    let idTextField = JobdamTextField("아이디", placeholder: "아이디를 입력해주세요")
    let nextButton = JobdamButton(text: "다음")

    override func addView() {
        [
            logoImage,
            loginTitleLabel,
            idTextField,
            nextButton
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
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }

    override func bind() {
        idTextField.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
