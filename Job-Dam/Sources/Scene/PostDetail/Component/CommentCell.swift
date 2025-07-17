import UIKit
import SnapKit
import Then

final class CommentCell: UITableViewCell {
    
    static let identifier = "CommentCell"
    
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.gray700.color
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .jobdamFont(.body3)
        $0.textColor = JobDamAsset.black.color
        $0.numberOfLines = 0
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
        
        [authorLabel, contentLabel].forEach { cardView.addSubview($0) }
        
        authorLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(id: String, content: String) {
        self.authorLabel.text = id
        self.contentLabel.text = content
    }
}
