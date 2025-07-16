import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya

class LoginViewController: BaseViewController {
    private let manager: Session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: CustomServerTrustManager())
    private lazy var provider = MoyaProvider<AuthAPI>(session: manager, plugins: [MoyaLoggingPlugin()])

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
    let signupLabel = UILabel().then {
        $0.text = "계정이 없으신가요?"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.gray800.color
    }
    let signupButton = UIButton().then {
        let title = "회원가입"
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
    let loginButton = JobdamButton(text: "로그인")

    override func addView() {
        [
            logoImage,
            loginTitleLabel,
            idTextField,
            passwordTextField,
            signupLabel,
            signupButton,
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
            $0.top.equalTo(idTextField.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
        }
        signupLabel.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-12)
            $0.leading.equalToSuperview().inset(24)
        }
        signupButton.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-6)
            $0.leading.equalTo(signupLabel.snp.trailing).offset(4)
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
        
        signupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let idViewController = IdViewController()
                self?.navigationController?.pushViewController(idViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self!.login()
                
            })
            .disposed(by: disposeBag)
    }

    private func login() {
        provider.request(.login(id: idTextField.textField.text ?? "", password: passwordTextField.textField.text ?? "")) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(AccessToken.self, from: response.data)
                    Token.accessToken = decodedData.accessToken
                    print("로그인 성공:", decodedData.accessToken)

                    // 로그인 성공 후 탭바로 전환
                    SceneDelegate.switchToMainTabbar()

                } catch {
                    print("디코딩 에러:", error)
                }

            case .failure(let error):
                print("로그인 실패:", error)
            }
        }
    }

}
