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

    override func addView() {
        [
            label
        ].forEach {view.addSubview( $0 )}
    }
    override func setLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
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
