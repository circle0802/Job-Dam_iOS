import UIKit
import SnapKit
import Then
import RxSwift

class MyPostViewController: BaseViewController {
    let postTableView = MyPostTableView()
    private var posts: [Post] = [
        Post(id: 1, title: "sdfdsf", content: "sdfsdf")
    ]

    init(posts: [Post]) {
        self.posts = posts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


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
        self.title = "내가 작성한 질문"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color
        
        postTableView.updateData(posts)
    }
    override func bind() {
        postTableView.didSelectName = { [weak self] id in
            let postDetailVC = PostDetailViewController(id: id)
            postDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
