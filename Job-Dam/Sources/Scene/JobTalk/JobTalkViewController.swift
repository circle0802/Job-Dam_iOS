import UIKit
import SnapKit
import Then

class JobTalkViewController: BaseViewController {
    let containerView = UIView()
    let label = UILabel().then {
        $0.text = "아직 서비스를 개발 중입니다!"
        $0.font = .jobdamFont(.subTitle2)
        $0.textColor = JobDamAsset.gray700.color
    }
    let postButton = UIButton().then {
        $0.setTitle("질문 작성하러 가기", for: .normal)
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body2)
        $0.backgroundColor = JobDamAsset.main400.color
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }

    override func addView() {
        [containerView].forEach {view.addSubview( $0 )}
        [
            label,
            postButton
        ].forEach {containerView.addSubview( $0 )}
    }
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        postButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(41)
            $0.width.equalTo(160)
        }
    }
    override func configureViewController() {
        self.title = "진로 체험"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
