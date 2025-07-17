import UIKit
import SnapKit
import Then

final class MyPostCell: UITableViewCell {
    
    static let identifier = "MyPostCell"
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = JobDamAsset.black.color.cgColor
        $0.layer.cornerRadius = 10
    }
    private let title = UILabel().then {
        $0.font = .jobdamFont(.body2)
        $0.textColor = .black
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            title
        ].forEach { cardView.addSubview($0) }
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(title: String) {
        self.title.text = title
    }
}


