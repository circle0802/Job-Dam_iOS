import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class IdViewController: BaseViewController {
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "smallLogo")
    }
    let loginTitleLabel = UILabel().then {
        $0.text = "아이디를 입력해주세요!"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }
    let idTextField = JobdamTextField("아이디", placeholder: "아이디를 입력해주세요")
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
            loginTitleLabel,
            idTextField,
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
        loginTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(32)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginTitleLabel.snp.bottom).offset(54)
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
        idTextField.textField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                SignupInfo.shared.id = self?.idTextField.textField.text
                let passwordVC = PasswordViewController()
                self?.navigationController?.pushViewController(passwordVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
