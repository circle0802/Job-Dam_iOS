import UIKit
import SnapKit
import Then
import RxSwift

class PopupView: UIView {
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
        $0.font = .jobdamFont(.heading4)
        $0.textAlignment = .center
    }

    let contentLabel = UILabel().then {
        $0.textColor = JobDamAsset.gray600.color
        $0.font = .jobdamFont(.body3)
        $0.textAlignment = .center
    }

    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(JobDamAsset.gray600.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body3)
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.layer.cornerRadius = 5
    }

    let logoutButton = UIButton().then {
        $0.setTitleColor(JobDamAsset.white.color, for: .normal)
        $0.titleLabel?.font = .jobdamFont(.body3)
        $0.backgroundColor = JobDamAsset.main400.color
        $0.layer.cornerRadius = 5
    }

    public init(title: String, content: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        contentLabel.text = content
        logoutButton.setTitle(title, for: .normal)

        setupUI()
        setupConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        addSubview(backgroundView)
        addSubview(containerView)
        [titleLabel, contentLabel, cancelButton, logoutButton].forEach { containerView.addSubview($0) }
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(271)
            $0.height.equalTo(151)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.centerX.equalToSuperview()
        }

        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(34)
            $0.width.equalTo(100)
        }

        logoutButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(34)
            $0.width.equalTo(100)
        }
    }
    private func bind() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            })
            .disposed(by: disposeBag)
    }
}

extension PopupView {
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
