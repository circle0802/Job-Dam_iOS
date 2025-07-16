import UIKit
import SnapKit
import Then

final class CommentTableView: UIView {

    private let posts: [Comment] = [
        Comment(count: 1, id: "circle08", content: "이렇게 해보세요이렇게 해보세요이렇게 해보세요이렇게 해보세요이렇게 해보세요이렇게 해보세요이렇게 해보세요이렇게 해보세요"),
        Comment(count: 2, id: "circle08", content: "저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요저렇게 해보세요")
    ]
    
    var didSelectName: ((Int) -> Void)?
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CommentTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.section]
        cell.configure(id: post.id, content: post.content)


        return cell
    }
}

extension CommentTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.section]
        didSelectName?(selectedPost.count)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView().then {
            $0.backgroundColor = .clear
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
