import UIKit
import SnapKit
import Then
import RxSwift
import Cosmos

class EvaluationPopupView: UIView {
    let disposeBag = DisposeBag()
    var onEvaluationComplete: ((Double) -> Void)?
    
    private let authorName: String
    
    let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = JobDamAsset.black.color
        $0.font = .jobdamFont(.subTitle1)
        $0.textAlignment = .center
    }
    
    let cosmosView = CosmosView()
    
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = JobDamAsset.black.color
    }
    
    let submitButton = UIButton().then {
        $0.setTitle("평가 완료하기", for: .normal)
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.subTitle2)
        $0.backgroundColor = JobDamAsset.main400.color
        $0.layer.cornerRadius = 5
    }
    
    init(authorName: String) {
        self.authorName = authorName
        super.init(frame: .zero)
        
        titleLabel.text = "\(authorName)님을 평가해주세요!"
        addView()
        setLayout()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        backgroundColor = .clear
        addSubview(backgroundView)
        addSubview(containerView)
        [
            titleLabel,
            cosmosView,
            cancelButton,
            submitButton
        ].forEach { containerView.addSubview($0) }
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(301)
            $0.height.equalTo(219)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.centerX.equalToSuperview()
        }
        cosmosView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(24)
        }
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(41)
        }
    }
    
    private func configureView() {
        self.cosmosView.settings.starSize = 36
        self.cosmosView.settings.starMargin = 4
        self.cosmosView.settings.filledColor = JobDamAsset.main400.color
        self.cosmosView.settings.emptyColor = JobDamAsset.gray100.color
        self.cosmosView.settings.emptyBorderColor = JobDamAsset.gray100.color
        self.cosmosView.settings.filledBorderColor = JobDamAsset.main400.color
        self.cosmosView.settings.fillMode = .half
    }
    
    private func bind() {
        // 배경 탭으로 닫기
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(backgroundTap)
        
        // 취소 버튼
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            })
            .disposed(by: disposeBag)
        
        // 평가 완료 버튼
        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let rating = self.cosmosView.rating
                
                if rating > 0 {
                    self.onEvaluationComplete?(rating)
                    self.hide()
                } else {
                    // 평점을 선택하지 않은 경우 알림
                    self.showRatingAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func backgroundTapped() {
        hide()
    }
    
    private func showRatingAlert() {
        let alert = UIAlertController(title: "평가 필요", message: "평점을 선택해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = window.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

extension EvaluationPopupView {
    func show() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first(where: { $0.isKeyWindow }) else { return }
        
        self.frame = window.bounds
        window.addSubview(self)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
