import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let isLoggedIn = Token.accessToken != nil

        if isLoggedIn {
            window?.rootViewController = TabbarViewController()
        } else {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = nav
        }

        window?.makeKeyAndVisible()
    }

    // 로그인 후 Tabbar로 전환할 때 사용
    static func switchToMainTabbar() {
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first else { return }

        window.rootViewController = TabbarViewController()
        window.makeKeyAndVisible()

        // 간혹 애니메이션 적용하고 싶다면:
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionFlipFromRight,
                          animations: nil,
                          completion: nil)
    }
}
