import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public final class TextField: UIView {
    public let textField = UITextField().then {
        $0.layer.cornerRadius = 5
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
        $0.backgroundColor = JobDamAsset.gray50.color
    }
    private let label = UILabel().then {
        $0.font = .jobdamFont(.body3)
    }
    private let errorLabel = UILabel().then {
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.error.color
        $0.isHidden = true
    }

    public init(_ text: String, placeholder: String) {
        super.init(frame: .zero)
        self.label.text = text
        self.textField.placeholder = placeholder

        addView()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func addView() {
        [
            label,
            textField,
            errorLabel
        ].forEach { self.addSubview($0) }
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
            $0.height.equalTo(50)
        }
        errorLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(textField.snp.leading)
        }
    }
}
