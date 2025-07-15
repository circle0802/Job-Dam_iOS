import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public enum DescriptionType: Equatable {
    case error(description: String)
    case clear
}

public final class JobdamTextField: UIView {
    public let textField = UITextField().then {
        $0.layer.cornerRadius = 5
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
        $0.backgroundColor = JobDamAsset.gray50.color
        $0.isSecureTextEntry = false
        $0.font = .jobdamFont(.body2)
    }

    private let label = UILabel().then {
        $0.font = .jobdamFont(.body3)
    }

    private let errorLabel = UILabel().then {
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.error.color
        $0.isHidden = true
    }

    private lazy var toggleButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "eyeOff"), for: .normal)
        $0.setImage(UIImage(named: "eyeOpen"), for: .selected)
        $0.tintColor = JobDamAsset.black.color
        $0.isHidden = true

        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        $0.configuration = config

        $0.configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            updatedConfig?.background.backgroundColor = .clear
            button.configuration = updatedConfig
        }

        $0.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    private var isPasswordField = false
    private var isPasswordVisible = false

    // MARK: - Init
    public init(_ text: String, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.label.text = text
        self.textField.placeholder = placeholder

        self.isPasswordField = isSecure
        self.textField.isSecureTextEntry = isSecure
        self.toggleButton.isHidden = !isSecure

        addView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    public func setDescription(_ descriptionType: DescriptionType) {
        switch descriptionType {
        case .error(let description):
            errorLabel.text = description
            errorLabel.isHidden = false
        default:
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }

    public func currentText() -> String {
        return textField.text ?? ""
    }

    // MARK: - Private Setup
    private func addView() {
        [
            label,
            textField,
            errorLabel
        ].forEach { self.addSubview($0) }
        textField.addSubview(toggleButton)
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(70)
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(41)
        }

        toggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(20)
        }

        errorLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(textField.snp.leading)
        }
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        toggleButton.isSelected = isPasswordVisible
    }
}
