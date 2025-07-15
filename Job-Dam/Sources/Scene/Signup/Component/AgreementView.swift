import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AgreementItemView: UIView {
    private let disposeBag = DisposeBag()

    private let checkBox = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        $0.tintColor = JobDamAsset.main400.color

        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        $0.configuration = config

        $0.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            updatedConfig?.background.backgroundColor = .clear
            button.configuration = updatedConfig
        }
    }

    private let titleLabel = UILabel().then {
        $0.font = .jobdamFont(.body2)
        $0.textColor = JobDamAsset.black.color
    }

    private let checkedRelay = BehaviorRelay<Bool>(value: false)

    var checked: Observable<Bool> { checkedRelay.asObservable() }
    
    var isChecked: Bool {
        get { checkedRelay.value }
        set {
            checkedRelay.accept(newValue)
            checkBox.isSelected = newValue
        }
    }

    init(title: String, isRequired: Bool) {
        super.init(frame: .zero)
        titleLabel.text = "\(title) \(isRequired ? "(필수)" : "(선택)")"
        addSubview(checkBox)
        addSubview(titleLabel)
        setLayout()
        bind()
    }

    private func setLayout() {
        self.snp.makeConstraints { $0.height.equalTo(20) }
        checkBox.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(12)
            $0.trailing.centerY.equalToSuperview()
        }
    }

    private func bind() {
        checkBox.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isChecked.toggle()
            })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
