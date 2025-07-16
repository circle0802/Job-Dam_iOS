import UIKit
import SnapKit
import Then

class PostViewController: BaseViewController {
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
        postTableView.didSelectName = { [weak self] name in
            let postDetailVC = PostDetailViewController()
            postDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }
    
    @objc private func rightButtonTapped() {
        let createVC = CreateViewController()
        createVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createVC, animated: true)
    }
}

