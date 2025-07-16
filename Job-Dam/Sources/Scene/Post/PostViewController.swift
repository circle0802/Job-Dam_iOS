import UIKit
import Moya
import SnapKit
import Then

class PostViewController: BaseViewController {
    private let manager: Session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: CustomServerTrustManager())
    private lazy var provider = MoyaProvider<PostAPI>(session: manager, plugins: [MoyaLoggingPlugin()])

    let postTableView = PostTableView()

    override func addView() {
        [
            postTableView
        ].forEach { view.addSubview($0) }
    }
    override func setLayout() {
        postTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    override func configureViewController() {
        self.title = "질의응답"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        self.navigationController?.navigationBar.tintColor = JobDamAsset.main400.color
    }
    override func bind() {
        postTableView.didSelectName = { [weak self] id in
            let postDetailVC = PostDetailViewController(id: id)
            postDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }

    private func getPosts() {
        provider.request(.viewAllPosts) { result in
            switch result {
            case .success(let response):
                do {
                    let posts = try JSONDecoder().decode([PostResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        let simplePosts = posts.map { SimplePost(from: $0) }
                        self.postTableView.updateData(simplePosts)
                    }
                } catch {
                    print("Decode error:", error)
                }
            case .failure(let error):
                print("Network error:", error)
            }
        }
    }
    
    @objc private func rightButtonTapped() {
        let createVC = CreateViewController()
        createVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createVC, animated: true)
    }
}

