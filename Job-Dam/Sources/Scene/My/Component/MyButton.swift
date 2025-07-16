import UIKit
import SnapKit
import Then

class MyButton: UIButton {
    let title = UILabel().then {
        $0.text = "내가 한 질문 보기"
        $0.font = .jobdamFont(.body1)
    }
    let rightImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = JobDamAsset.black.color
    }
    public init(text: String, color: UIColor) {
        super.init(frame: .zero)
        title.text = text
        rightImage.tintColor = color
        title.textColor = color
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        [
            title,
            rightImage
        ].forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        rightImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
