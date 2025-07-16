import UIKit
import SnapKit
import Then

final class PostTableView: UIView {

    private let posts: [SimplePost] = [
        SimplePost(title: "첫 번째 글", id: "1", username: "홍길동", commentCount: 3),
        SimplePost(title: "두 번째 글", id: "2", username: "김철수", commentCount: 5),
        SimplePost(title: "세 번째 글", id: "3", username: "이영희", commentCount: 2),
        SimplePost(title: "네 번째 글", id: "4", username: "박지민", commentCount: 0),
        SimplePost(title: "다섯 번째 글", id: "5", username: "최수연", commentCount: 1)
    ]
    
    var didSelectName: ((String) -> Void)?
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
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

extension PostTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.section]
        cell.configure(title: post.title, id: post.username, count: post.commentCount)

        return cell
    }
}

extension PostTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.section]
        didSelectName?(selectedPost.title)
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
