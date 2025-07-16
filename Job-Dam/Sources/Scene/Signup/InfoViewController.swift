import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya

class InfoViewController: BaseViewController {
    private let manager: Session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: CustomServerTrustManager())
    private lazy var provider = MoyaProvider<AuthAPI>(session: manager, plugins: [MoyaLoggingPlugin()])

    private let genderSelected = BehaviorRelay<Bool>(value: false)

    var isAllRequiredAgreed: Bool {
        return termsView.isChecked && privacyView.isChecked
    }

    private let logoImage = UIImageView().then {
        $0.image = UIImage(named: "smallLogo")
    }
    private let signupTitleLabel = UILabel().then {
        $0.text = "회원가입 후 진로 탐색을 시작해보세요!"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.black.color
    }
    private let maleButton = UIButton().then {
        $0.setTitle("남자", for: .normal)
        $0.setTitleColor(JobDamAsset.gray700.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body2)
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(selectMale), for: .touchUpInside)
    }
    private let femaleButton = UIButton().then {
        $0.setTitle("여자", for: .normal)
        $0.setTitleColor(JobDamAsset.gray700.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body2)
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(selectFemale), for: .touchUpInside)
    }
    private let allAgreeView = AgreementItemView(title: "전체", isRequired: false)
    private let line = UIView().then {
        $0.backgroundColor = JobDamAsset.gray300.color
    }
    private let termsView = AgreementItemView(title: "이용약관 동의", isRequired: true)
    private let privacyView = AgreementItemView(title: "개인정보 취급방침 동의", isRequired: true)
    private let marketingView = AgreementItemView(title: "마케팅 정보 수신 동의", isRequired: false)
    private let singupButton = JobdamButton(text: "회원가입 완료하기")

    override func addView() {
        [
            logoImage,
            signupTitleLabel,
            genderLabel,
            maleButton,
            femaleButton,
            allAgreeView,
            line,
            termsView,
            privacyView,
            marketingView,
            singupButton
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
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(signupTitleLabel.snp.bottom).offset(54)
            $0.leading.equalToSuperview().inset(24)
        }
        maleButton.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        femaleButton.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(4)
            $0.leading.equalTo(maleButton.snp.trailing).offset(12)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        allAgreeView.snp.makeConstraints {
            $0.top.equalTo(femaleButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(allAgreeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        termsView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        privacyView.snp.makeConstraints {
            $0.top.equalTo(termsView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        marketingView.snp.makeConstraints {
            $0.top.equalTo(privacyView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        singupButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
            $0.height.equalTo(50)
        }
    }

    override func bind() {
        allAgreeView.checked
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] isChecked in
                guard let self = self else { return }
                self.termsView.isChecked = isChecked
                self.privacyView.isChecked = isChecked
                self.marketingView.isChecked = isChecked
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            termsView.checked,
            privacyView.checked,
            marketingView.checked
        )
        .map { $0 && $1 && $2 }
        .distinctUntilChanged()
        .subscribe(onNext: { [weak self] allSelected in
            self?.allAgreeView.isChecked = allSelected
        })
        .disposed(by: disposeBag)

        Observable.combineLatest(
            termsView.checked,
            privacyView.checked,
            genderSelected.asObservable()
        )
        .map { $0 && $1 && $2 }
        .distinctUntilChanged()
        .bind(to: singupButton.rx.isEnabled)
        .disposed(by: disposeBag)

        singupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                SignupInfo.shared.gender = self.maleButton.isSelected ? "남성" : "여성"

                self.sendSignupRequest()
            })
            .disposed(by: disposeBag)

    }

    private func sendSignupRequest() {
        let parameters = SignupInfo.shared.toRequestDTO()

        provider.request(.signup(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                // 성공 처리
                print("가입 성공:", response.statusCode)
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            case .failure(let error):
                print("가입 실패:", error)
            }
        }
    }

    private func updateButtonStyles() {
        let selectedColor = JobDamAsset.main400.color
        let normalColor = JobDamAsset.gray700.color
        
        let buttons = [(maleButton, maleButton.isSelected), (femaleButton, femaleButton.isSelected)]
        
        buttons.forEach { (button, isSelected) in
            button.setTitleColor(isSelected ? selectedColor : normalColor, for: .normal)
            button.layer.borderWidth = isSelected ? 1 : 0
            button.layer.borderColor = isSelected ? selectedColor.cgColor : nil
        }
    }
    @objc private func selectMale() {
        maleButton.isSelected = true
        femaleButton.isSelected = false
        updateButtonStyles()
        genderSelected.accept(true)
    }

    @objc private func selectFemale() {
        maleButton.isSelected = false
        femaleButton.isSelected = true
        updateButtonStyles()
        genderSelected.accept(true)
    }

}
