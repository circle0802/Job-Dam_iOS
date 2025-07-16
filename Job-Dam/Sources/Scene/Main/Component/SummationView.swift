import UIKit
import SnapKit
import Then

class SummationView: UIView {
    let titleLabel1 = UILabel().then {
        $0.text = "저번엔"
        $0.font = .jobdamFont(.body1)
    }
    let jobLabel = UILabel().then {
        $0.font = .jobdamFont(.subTitle1)
        $0.textColor = JobDamAsset.main400.color
    }
    let titleLabel2 = UILabel().then {
        $0.text = "을 체험했어요!"
        $0.font = .jobdamFont(.body1)
    }
    let contentLabel = UILabel().then {
        $0.font = .jobdamFont(.body2)
        $0.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
    }
    
    public init(job: String, content: String) {
        super.init(frame: .zero)
        jobLabel.text = job
        contentLabel.text = content
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        configureView()
        addView()
        setLayout()
    }
    
    private func configureView() {
        self.backgroundColor = JobDamAsset.gray50.color
        self.layer.cornerRadius = 10
    }
    
    private func addView() {
        [
            titleLabel1,
            jobLabel,
            titleLabel2,
            contentLabel
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayout() {
        titleLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        jobLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(titleLabel1.snp.trailing).offset(2)
        }
        titleLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(jobLabel.snp.trailing).offset(2)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(jobLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
