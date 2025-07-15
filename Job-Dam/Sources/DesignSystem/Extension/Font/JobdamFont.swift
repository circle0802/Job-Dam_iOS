import UIKit

public extension UIFont {
    static func jobdamFont(_ font: JobdamFontStyle) -> UIFont {
        return font.uiFont()
    }
}

extension JobdamFontStyle {
    func uiFont() -> UIFont {
        let pretendard = JobDamFontFamily.Pretendard.self

        switch self {

        case .heading1, .heading2, .heading3, .heading4, .subTitle1, .subTitle2:
            return pretendard.semiBold.font(size: self.size())

        case .body1, .body2, .body3:
            return pretendard.medium.font(size: self.size())
        }
    }

    func size() -> CGFloat {
        switch self {

        case .heading1:
            return 42

        case .heading2:
            return 32

        case .heading3:
            return 24

        case .heading4:
            return 20

        case .subTitle1:
            return 18

        case .subTitle2, .body1:
            return 16

        case .body2:
            return 14

        case .body3:
            return 12
        }
    }
}
