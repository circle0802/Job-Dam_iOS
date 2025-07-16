import UIKit
import SnapKit
import Then
import RxSwift
import Cosmos

class EvaluationPopupView: UIView {
    let disposeBag = DisposeBag()

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

    let perfectButton = UIButton().then {
        $0.setTitle("평가 완료하기", for: .normal)
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.subTitle2)
        $0.backgroundColor = JobDamAsset.main400.color
        $0.layer.cornerRadius = 5
    }

    public init(id: String) {
        super.init(frame: .zero)
        titleLabel.text = "\(id)님을 평가해주세요!"

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
            perfectButton
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

        perfectButton.snp.makeConstraints {
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
    }
    private func bind() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            })
            .disposed(by: disposeBag)
        perfectButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            })
            .disposed(by: disposeBag)
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
