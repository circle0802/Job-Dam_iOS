import UIKit
import SnapKit
import Then

class JobExperienceBannerView: UIView {
    let aiTogetherLabel = UILabel().then {
        $0.text = "AI와 함께"
        $0.font = .jobdamFont(.subTitle2)
        $0.textColor = JobDamAsset.white.color
    }
    let subLabel = UILabel().then {
        $0.text = "하는 직업 체험?"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.white.color
    }
    let subLabel2 = UILabel().then {
        $0.text = "지금 바로 시작해보세요!"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.white.color
    }
    let searchImage = UIImageView().then {
        $0.image = JobDamAsset.search.image
    }
    let goButton = UIButton().then {
        $0.backgroundColor = JobDamAsset.main600.color
        $0.layer.cornerRadius = 5
        $0.setTitle("바로가기", for: .normal)
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureView() {
        self.backgroundColor = JobDamAsset.main300.color
        self.layer.cornerRadius = 10
    }
    private func addView() {
        [
            aiTogetherLabel,
            subLabel,
            subLabel2,
            searchImage,
            goButton
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        aiTogetherLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalTo(aiTogetherLabel.snp.trailing).offset(4)
        }
        subLabel2.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(24)
        }
        searchImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(4)
        }
        goButton.snp.makeConstraints {
            $0.top.equalTo(subLabel2.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(32)
            $0.width.equalTo(95)
        }
    }
}
