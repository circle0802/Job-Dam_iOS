import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyViewController: BaseViewController {

    let profileImage = UIImageView().then {
        $0.image = JobDamAsset.student.image
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }

    let idLabel = UILabel().then {
        $0.text = "circle08"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }

    let genderLabel = UILabel().then {
        $0.text = "여자"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.black.color
    }

    let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(JobDamAsset.main500.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body1)
    }

    let buttonView = UIView().then {
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 10
    }

    let questionButton = MyButton(text: "내가 작성한 질문", color: JobDamAsset.black.color)
    let logoutButton = MyButton(text: "로그아웃", color: JobDamAsset.error.color)
    let secessionButton = MyButton(text: "회원탈퇴", color: JobDamAsset.error.color)

    private let logoutPopupView = PopupView(title: "로그아웃", content: "정말 로그아웃 하시겠습니까?")
    private let secessionPopupView = PopupView(title: "회원탈퇴", content: "정말 회원탈퇴 하시겠습니까?")

    override func configureViewController() {
        self.title = "마이페이지"
    }

    override func addView() {
        [
            profileImage,
            idLabel,
            genderLabel,
            editButton,
            buttonView
        ].forEach { view.addSubview($0) }
        [
            questionButton,
            logoutButton,
            secessionButton
        ].forEach { buttonView.addSubview($0) }
    }

    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().inset(32)
            $0.height.width.equalTo(80)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top).offset(17)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }
        editButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.trailing.equalToSuperview().inset(32)
        }
        buttonView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(156)
        }
        questionButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.trailing.equalToSuperview()
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(questionButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        secessionButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
    }

    override func bind() {
        logoutButton.rx.tap
            .bind { [weak self] in
                self?.logoutPopupView.show()
            }
            .disposed(by: disposeBag)

        secessionButton.rx.tap
            .bind { [weak self] in
                self?.secessionPopupView.show()
            }
            .disposed(by: disposeBag)

        questionButton.rx.tap
            .bind { [weak self] in
                let mypostVC = MyPostViewController()
                self?.navigationController?.pushViewController(mypostVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
