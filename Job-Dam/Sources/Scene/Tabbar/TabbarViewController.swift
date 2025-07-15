import UIKit
import Then

class TabbarViewController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBarLayout()
        setUpTabBarItem()
        self.selectedIndex = 1

//        if Token.accessToken == nil {
//            let loginViewController = LoginViewController()
//            loginViewController.modalPresentationStyle = .fullScreen
//            DispatchQueue.main.async {
//                self.present(loginViewController, animated: true)
//            }
//        }
    }

    override func viewDidLoad() {
//        Token.accessToken = nil
    }

    func setUpTabBarLayout() {
        let tabBar: UITabBar = self.tabBar
        tabBar.unselectedItemTintColor = JobDamAsset.gray600.color
        tabBar.tintColor = JobDamAsset.main400.color
        tabBar.backgroundColor = .white
        tabBar.layer.borderColor = JobDamAsset.gray300.color.cgColor
        tabBar.layer.borderWidth = 1
        self.hidesBottomBarWhenPushed = true
    }

    func setUpTabBarItem() {
        let postViewController = BaseNavigationController(
            rootViewController: PostViewController()
        )
        postViewController.tabBarItem = UITabBarItem(
            title: "질의응답",
            image: JobDamAsset.post.image,
            selectedImage: JobDamAsset.post.image
        )
        let mainViewController = BaseNavigationController(
            rootViewController:  MainViewController()
        )
        mainViewController.tabBarItem = UITabBarItem(
            title: "메인페이지",
            image: JobDamAsset.home.image,
            selectedImage: JobDamAsset.home.image
        )
        let myViewController = BaseNavigationController(
            rootViewController: MyViewController()
        )
        myViewController.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: JobDamAsset.my.image,
            selectedImage: JobDamAsset.my.image
        )
        viewControllers = [
            postViewController,
            mainViewController,
            myViewController
        ]
    }

//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item.title == "ADD" {
//            let writeViewContoller = WriteViewController()
//            writeViewContoller.modalPresentationStyle = .overFullScreen
//            self.present(writeViewContoller, animated: true) {
//                self.selectedIndex = 0
//            }
//        }
//    }
}

