import UIKit
import SnapKit
import Then
import RxSwift

class MyPostViewController: BaseViewController {
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
        self.title = "내가 작성한 질문"

        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = JobDamAsset.black.color
    }
    override func bind() {
        postTableView.didSelectName = { [weak self] name in
            let postDetailVC = PostDetailViewController()
            postDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
