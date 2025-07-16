import UIKit
import SnapKit
import Then

class PostViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "질의응답"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        self.navigationController?.navigationBar.tintColor = JobDamAsset.main400.color
    }
    
    @objc private func rightButtonTapped() {
        let createVC = CreateViewController()
        createVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createVC, animated: true)
    }
}

