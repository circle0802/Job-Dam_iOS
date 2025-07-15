import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

public final class JobdamButton: UIButton {
    private var labelText: String

    public override var isHighlighted: Bool {
        didSet { self.configureUI() }
    }

    public override var isEnabled: Bool {
        didSet { self.configureUI() }
    }

    private var fgColor: UIColor {
        return JobDamAsset.white.color
    }

    private var bgColor: UIColor {
        if isEnabled {
            return JobDamAsset.main400.color
        } else {
            return JobDamAsset.main50.color
        }
    }

    public init(text: String) {
        self.labelText = text
        super.init(frame: .zero)
        self.configureUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        var config = UIButton.Configuration.plain()
        config.title = self.labelText
        config.attributedTitle?.foregroundColor = fgColor
        config.attributedTitle?.font = .jobdamFont(.subTitle2)

        self.configuration = config
        self.layer.cornerRadius = 12
        self.backgroundColor = bgColor
    }
}

extension JobdamButton {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
}
