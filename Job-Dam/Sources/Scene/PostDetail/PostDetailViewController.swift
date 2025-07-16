import UIKit
import SnapKit
import Then
import RxSwift

class PostDetailViewController: BaseViewController {
    private let titleLabel = UILabel().then {
        $0.text = "인생이 너무 힘들어요 ㅜ"
        $0.font = .jobdamFont(.heading3)
        $0.numberOfLines = 0
    }
    private let idLabel = UILabel().then {
        $0.text = "circle08"
        $0.font = .jobdamFont(.body1)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let contentLabel = UILabel().then {
        $0.text = "저만 그런가요? 요즘 너무 무기력하고 뭘 하고 싶지도 않네요. 하 너무 인생이 재미가 없는 것 같아요. 저에게 인생의 재미 를 알려주실 분 안계신가요? 시급해요. 평점 5점 드릴게요."
        $0.font = .jobdamFont(.body1)
        $0.numberOfLines = 0
    }
    private let dayLabel = UILabel().then {
        $0.text = "2025.07.16"
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.gray600.color
    }
    private let line = UIView().then {
        $0.backgroundColor = JobDamAsset.gray200.color
    }

    override func addView() {
        [
            titleLabel,
            idLabel,
            contentLabel,
            dayLabel,
            line
        ].forEach { view.addSubview($0) }
    }
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(32)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(32)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    override func configureViewController() {
        self.title = "질문"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
