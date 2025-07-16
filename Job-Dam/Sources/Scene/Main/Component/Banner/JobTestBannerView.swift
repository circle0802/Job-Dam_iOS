import UIKit
import SnapKit
import Then

class JobTestBannerView: UIView {
    let testImage = UIImageView().then {
        $0.image = JobDamAsset.test.image
    }
    let courseLabel = UILabel().then {
        $0.text = "진로 흥미 검사"
        $0.font = .jobdamFont(.subTitle2)
        $0.textColor = JobDamAsset.white.color
    }
    let subLabel = UILabel().then {
        $0.text = "을 통해"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.white.color
    }
    let subLabel2 = UILabel().then {
        $0.text = "자신에게 맞는 직업을 찾아보세요!"
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.white.color
    }
    let goButton = UIButton().then {
        $0.backgroundColor = JobDamAsset.main600.color
        $0.layer.cornerRadius = 5
        $0.setTitle("검사 바로가기", for: .normal)
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
            testImage,
            courseLabel,
            subLabel,
            subLabel2,
            goButton
        ].forEach { self.addSubview($0) }
    }
    private func setLayout() {
        testImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalToSuperview()
        }
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(24)
        }
        courseLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.trailing.equalTo(subLabel.snp.leading).offset(-4)
        }
        subLabel2.snp.makeConstraints {
            $0.top.equalTo(courseLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(24)
        }
        goButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(32)
            $0.width.equalTo(95)
        }
    }
}
