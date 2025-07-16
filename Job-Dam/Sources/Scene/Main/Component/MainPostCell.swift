import UIKit
import SnapKit
import Then

final class MainPostCell: UITableViewCell {
    
    static let identifier = "CustomSimpleCell"
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let title = UILabel().then {
        $0.font = .jobdamFont(.body2)
        $0.textColor = .black
    }
    private let id = UILabel().then {
        $0.font = .jobdamFont(.caption)
        $0.textColor = JobDamAsset.gray700.color
    }
    private let numberLabel = UILabel().then {
        $0.font = .jobdamFont(.caption)
        $0.textColor = JobDamAsset.main400.color
    }
    private let postImage = UIImageView().then {
        $0.image = JobDamAsset.talk.image
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
            title,
            id,
            numberLabel,
            postImage
        ].forEach { cardView.addSubview($0) }
        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        id.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(16)
        }
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        postImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(numberLabel.snp.leading).offset(-2)
        }
    }
    
    func configure(title: String, id: String, count: Int) {
        self.title.text = title
        self.id.text = id
        self.numberLabel.text = "\(count)"
    }
}
